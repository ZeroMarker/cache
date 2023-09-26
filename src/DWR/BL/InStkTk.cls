/// Descript:移动盘点相关
/// Creater:	ZhangDongmei
/// CreateDate:	2013-06-05
/// 
Class DWR.BL.InStkTk Extends (%RegisteredObject, %XML.Adaptor)
{

/// Descript:获取需要进行实盘录入的盘点单
/// Creater:	ZhangDongmei
/// CreateDate:	2013-06-05
/// Table:DHC_InStkTk
/// Input:<Request><departmentId>科室id</departmentId><startDate>开始日期</startDate><endDate>截止日期</endDate></Request>
/// Output:	
/// Return：<Record></Record>…<Record></Record>	
/// w ##class(DWR.BL.InStkTk).GetStkTk("<Request><departmentId>100</departmentId><startDate>2013-01-01</startDate><endDate>2013-06-06</endDate></Request>")
/// 
ClassMethod GetStkTk(Param As %String) As %String
{
	s retStr=""
	s Param=$tr(Param,$c(10))
	s reader=##class(%XML.Reader).%New()
	s sc=reader.OpenString(Param)
	do reader.Correlate("Request","DWR.MSG.Request")
	;
	if reader.Next(.request,.sc){
		s locId=request.departmentId
		s startDate=request.startDate
		s endDate=request.endDate		
	}
	q:$g(locId)="" "701^科室不能为空"
	q:$g(startDate)="" "702^开始日期不能为空"
	q:$g(endDate)="" "703^截止日期不能为空"
	s result=##class(%ResultSet).%New("web.DHCST.INStkTk:DHCSTINStkTk")
	s sc=result.Execute("rowid","desc",locId,startDate,endDate,"Y","N","N")
	if $$$ISERR(sc) q ""
	;
	;inst,instNo,date,time,user,userName,status,loc,locDesc,comp,stktkComp,adjComp,adj,manFlag,freezeUom,includeNotUse,onlyNotUse,scg,scgDesc,sc,scDesc,frSb,toSb,inputType
	while(result.Next()){
		s objRecord=##class(DWR.MSG.Record).%New()
		s objRecord.id=result.Data("inst")
		s objRecord.no=result.Data("instNo")
		s objRecord.date=result.Data("date")
		s objRecord.time=result.Data("time")
		s objRecord.userName=result.Data("userName")
		s objRecord.inputType=result.Data("InputType")
		s ret=objRecord.XMLExportToString(.Xml,"Record")
		i ret=1  s retStr=retStr_Xml
		s objRecord=""     //instead of %Close	
	}
	;
	q retStr
}

/// Descript:扫描药品，保存数据
/// Creater:	ZhangDongmei
/// CreateDate:	2013-06-06
/// Table:User.DHCInStkTkInput.cls
/// Input:<Request><barCode>条码</barCode><instId>盘点主表id</instId><userId>盘点人id</userId></Request>
/// Output:	
/// Return：<InStkTkInput></InStkTkInput>
/// 
ClassMethod InitInput(Param As %String) As %String
{
	s Param=$TR(Param,$c(10))
	s reader=##class(%XML.Reader).%New()
	s sc=reader.OpenString(Param)
	do reader.Correlate("Request","DWR.MSG.InStkTkInput")
	;
	if reader.Next(.request,.sc){
		s barCode=request.barCode
		s instId=request.instId	
		s userId=request.userId
	}
	q:$g(barCode)="" "704^请扫描药品条码"
	q:$g(instId)="" "705^请选择盘点单"
	s incRowid=$o(^INCI(0,"Code",$$ALPHAUP^SSUTIL4(barCode),0))
	q:incRowid="" "706^药品条码未定义"
	b ;1
	s chl=$o(^DHCINST(instId,"STI1",0,"INCI",incRowid,0))
	q:chl="" "707^该药品不在本盘点单范围之内"
	//盘点主表id^药品id^单位id^实盘数^实盘人id
	s objIncItm=##class(User.INCItm).%OpenId(incRowid)
	if objIncItm'=""{
		s objPurUom=objIncItm.INCICTUOMPurchDR
		s objUom=objIncItm.INCICTUOMDR
		s purUomId=objPurUom.%Id()
		s purUomDesc=objPurUom.CTUOMDesc
		s uomId=objUom.%Id()
		s uomDesc=objUom.CTUOMDesc
		;s:purUomId'="" purUomDesc=$p(^CT("UOM",purUomId),"^",2)
		;s:uomId'="" uomDesc=$p(^CT("UOM",uomId),"^",2)
		s incCode=objIncItm.INCICode
		s incDesc=objIncItm.INCIDesc
		s infoId=$o(^DHCITMINFO(0,"INCI",incRowid,0))
		s spec=$p(^DHCITMINFO(infoId),"^",27)
	}
	s objIncItm=""
	;
	q:($g(purUomId)="")!($g(purUomDesc)="") "708^该药品包装单位为空，不能盘点"
	q:($g(uomId)="")!($g(uomDesc)="") "709^该药品基本单位为空，不能盘点"
	s data=instId_"^"_incRowid_"^"_purUomId_"^"_1_"^"_userId
	s ret=##class(web.DHCST.InStkTkInput).Insert(data)
	q:+ret<=0 "710^数据保存失败"
	s inputId=ret
	s objInput=##class(DWR.MSG.InStkTkInput).%New()
	s objInput.barCode=barCode
	s objInput.countQtyPurUom=1
	s objInput.countQtyUom=0
	s objInput.incCode=$g(incCode)
	s objInput.incDesc=$g(incDesc)
	s objInput.incRowid=incRowid
	s objInput.inputId=inputId
	s objInput.instId=instId
	s objInput.purUomDesc=$g(purUomDesc)
	s objInput.purUomId=purUomId
	s objInput.spec=$g(spec)
	s objInput.uomDesc=$g(uomDesc)
	s objInput.uomId=uomId
	s ret=objInput.XMLExportToString(.Xml,"InStkTkInput")
	s objInput=""
	q Xml
}

/// Descript:更新实盘数
/// Creater:	ZhangDongmei
/// CreateDate:	2013-06-07
/// Table:User.DHCInStkTkInput.cls
/// Input:<Request><inputId>实盘记录id</inputId><countQtyPurUom>实盘数(包装单位)</countQtyPurUom>
/// <countQtyUom>实盘数(基本单位)</countQtyUom></Request>
/// Output:	
/// Return：0^成功
/// 
ClassMethod UpdateCountQty(Param As %String) As %String
{
	s Param=$TR(Param,$c(10))
	s reader=##class(%XML.Reader).%New()
	s sc=reader.OpenString(Param)
	do reader.Correlate("Request","DWR.MSG.InStkTkInput")
	while(reader.Next(.request,.sc)){
		s inputId=request.inputId
		s countQtyPurUom=request.countQtyPurUom
		s countQtyUom=request.countQtyUom	
	}
	q:$g(inputId)="" "711^实盘记录id不能为空"
	s countQtyPurUom=+$g(countQtyPurUom)
	s countQtyUom=+$g(countQtyUom)
	s objInput=##class(User.DHCInStkTkInput).%OpenId(inputId)
	s objIncItm=objInput.DHCSTIINCIDR
	s purUomId=objIncItm.INCICTUOMPurchDR.%Id()
	s uomId=objIncItm.INCICTUOMDR.%Id()
	s uomFac=##class(web.DHCST.Common.UtilCommon).UOMFac(purUomId,uomId)
	;
	if (countQtyUom>0) {
		s countUom=uomId
		s countQty=countQtyPurUom*uomFac+countQtyUom
	}else{
		s countUom=purUomId
		s countQty=countQtyPurUom
	}
	s userId=objInput.DHCSTICountUserDr.%Id()
	s data=inputId_"^"_countUom_"^"_countQty_"^"_userId
	s ret=##class(web.DHCST.InStkTkInput).Update(data)
	q:ret'=0 ret
	q 0
}

}
