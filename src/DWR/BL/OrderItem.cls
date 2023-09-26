Class DWR.BL.OrderItem Extends (%RegisteredObject, %XML.Adaptor)
{

ClassMethod GetLongOrdStateCode(ordRowId As %String = "", ordSubId As %String = "") As %String
{
	q "V"
}

/// w ##Class(DWR.BL.OrderItem).GetLongOrdItem(Param)
ClassMethod GetLongOrdItem(Param As %String = "") As %String
{
	s retStr=""
	i Param="" s Param="<Request><admId>630650</admId><orderState>D</orderState></Request>"
    s Param=$TR(Param,$C(10))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    // s sc=reader.OpenStream(objStream)
    d reader.Correlate("Request","DWR.MSG.Request")
    //Do reader.Rewind()
	While reader.Next(.request,.sc)
	{
	   s admId=request.admId
	   s admId=$TR(admId,$C(0))
	   s userCode=request.userCode
	   s userCode=$TR(userCode,$C(0))
	   s orderState=request.orderState
	   s orderState=$TR(orderState,$C(0))
	   s startDate=request.startDate
	   s startDate=$TR(startDate,$C(0))
	   s endDate=request.endDate
	   s endDate=$TR(endDate,$C(0))
	   s groupId=request.groupId
	   s groupId=$TR(groupId,$C(0))
	   s departmentId=request.departmentId
	   s departmentId=$TR(departmentId,$C(0))
	}
	q:$G(userCode)="" "200^用户名不能为空!"
	s userCode=$ZConvert(userCode,"U")
	s userId=$order(^SSU("SSUSR",0,"SSUSR_Initials",userCode,"0"))
	q:$G(userId)="" "200^用户名不存在!"
	q:($G(admId)="") "201^就诊号不能为空!"
	i orderState="" s orderState="V"
	s ordRowId=""
	f  s ordRowId=$O(^OEORD(0,"Adm",admId,ordRowId)) q:ordRowId=""  d
	.s ordSubId=""
	.f  s ordSubId=$O(^OEORD(ordRowId,"I",ordSubId))  q:(ordSubId="")  d
	..q:+ordSubId=0
	..s priorDr=$P($G(^OEORD(ordRowId,"I",ordSubId,1)),"^",8)
	..q:priorDr=""
	..s priorDes=$P(^OECPR(priorDr),"^",2)    
	..s priorDes="^"_priorDes_"^"
	..q:(^DHCOEOrdPrintSet("L","OrdTyp")'[priorDes)
	..///
	..s ordStatDr=$P($G(^OEORD(ordRowId,"I",ordSubId,1)),"^",13) 
	..s ordStatCode=$p(^OEC("OSTAT",ordStatDr),"^",1)
	..q:(ordStatCode="U")!(ordStatCode="I")!(ordStatCode="C")
	..//q:(orderState="D")&&(orderState'=ordStatCode)
	..//q:(orderState="V")&&(ordStatCode="D")
	..s orderDate=$P($G(^OEORD(ordRowId,"I",ordSubId,1)),"^",9) //医嘱开始日期
	..q:orderDate>+$H
	..s fillerNo=$P($G(^OEORD(ordRowId,"I",ordSubId,9)),"^",12)
	..i fillerNo'="" d
	...s firstOrd=$P(fillerNo,"!",1)
	...s ordFillerItem(firstOrd,ordSubId)=ordRowId_"||"_ordSubId
	..q:fillerNo'="" //过滤滚动出来的长期医嘱
	..s ordUser=$P($G(^OEORD(ordRowId,"I",ordSubId,7)),"^",1)
	..q:ordUser=""
	..s doctorDr=$P(^SSU("SSUSR",ordUser),"^",14)
	..q:doctorDr=""
	..s careTypDr=$P(^CTPCP(doctorDr,1),"^",4)
	..q:careTypDr=""
	..s careTyp=$P(^CT("CPT",careTypDr),"^",4)  
	..q:($G(careTyp)'="DOCTOR")&($G(^DHCOEOrdPrintSet("ifnur"))'="true")
	..s arcimDr=$P($G(^OEORD(ordRowId,"I",ordSubId,1)),"^",2)
	..s arcimRowId=$P(arcimDr,"||",1)
	..s arcimSubId=$P(arcimDr,"||",2)  
	..s itemCatDr=$P($G(^ARCIM(arcimRowId,arcimSubId,1)),"^",10)
	..s ordCatDr=$P(^ARC("IC",itemCatDr),"^",8)
	..s ordCat=$P(^OEC("ORCAT",ordCatDr),"^",1)
	..s ordCatDr="^"_ordCatDr_"^"
	..q:$G(^DHCOEOrdPrintSet("NotOrdCat"))[ordCatDr&($G(^DHCOEOrdPrintSet("NotOrdCat"))'="")
	..s itemCatDr="^"_itemCatDr_"^" 
	..q:$G(^DHCOEOrdPrintSet("NotSordCat"))[itemCatDr&($G(^DHCOEOrdPrintSet("NotSordCat"))'="")
	..//s orderDate=$P($G(^OEORD(ordRowId,"I",ordSubId,1)),"^",9) //医嘱开始日期
	..s orderDate=$P($G(^OEORD(ordRowId,"I",ordSubId,3)),"^",7)
	..s orderDate=+orderDate
	..s seqNo=$P($G(^OEORD(ordRowId,"I",ordSubId,3)),"^",4)
	..s linkOrdDr=$p($g(^OEORD(ordRowId,"I",ordSubId,11)),"^",39)
	..i linkOrdDr'="" d
	...s arcimOrdItem(orderDate,$P(linkOrdDr,"||"),$P(linkOrdDr,"||",2),seqNo)=ordRowId_"||"_ordSubId
	..e  d
	...s arcimOrdItem(orderDate,ordRowId,ordSubId,seqNo)=ordRowId_"||"_ordSubId
	s orderIndex=1
	s orderDate=""
	f  s orderDate=$O(arcimOrdItem(orderDate)) q:orderDate=""  d
	.s ordRowId=""
	.f  s ordRowId=$O(arcimOrdItem(orderDate,ordRowId)) q:ordRowId=""  d
	..s ordSubId=""
	..f  s ordSubId=$O(arcimOrdItem(orderDate,ordRowId,ordSubId)) q:ordSubId=""  d
	...s seqNo=""
	...f  s seqNo=$O(arcimOrdItem(orderDate,ordRowId,ordSubId,seqNo)) q:seqNo=""  d
	....s orderRowId=$G(arcimOrdItem(orderDate,ordRowId,ordSubId,seqNo))
	....q:orderRowId=""
	....
	....s lastOrdStateCode="",lastOrdRowId=""
	....s lastOrdSubId=$O(ordFillerItem(orderRowId,""),-1)
	....i lastOrdSubId'="" d
	.....s lastOrdRowId=$G(ordFillerItem(orderRowId,lastOrdSubId))
	.....s lasOrderObj=##Class(User.OEOrdItem).%OpenId(lastOrdRowId)
	.....s lastOrdStateCode=lasOrderObj.OEORIItemStatDR.OSTATCode
	.....d lasOrderObj.%Close()
	....s orderObj=##Class(User.OEOrdItem).%OpenId(orderRowId)
	....s ordStatCode=orderObj.OEORIItemStatDR.OSTATCode
	....d orderObj.%Close()
	....i lastOrdStateCode'="" s ordStatCode=lastOrdStateCode
	....q:(orderState="D")&&(orderState'=ordStatCode)
	....q:(orderState="V")&&(ordStatCode="D")
	....//i ordStatCode'="D" s lastOrdRowId=""
	....
	....q:orderIndex>100
	....s orderItem=..GetOrdItemInfo(orderRowId,orderIndex,userId,groupId,departmentId,lastOrdRowId)
	....q:$L(retStr)>32000   //最大字符长度为32K
	....s retStr=retStr_orderItem
	....s orderIndex=orderIndex+1
	q retStr
}

ClassMethod GetOrdItemInfo(orderRowId As %String = "", orderIndex As %String = "", userId As %String = "", groupId As %String = "", departmentId As %String = "", lastOrderRowId As %String = "") As %String
{
	s orderItemInfo=""
	s myObj=##class(DWR.MSG.OrderItem).%New()
	s myObj.ordIndex=orderIndex
	s myObj.ordItemId=orderRowId
	s orderObj=##Class(User.OEOrdItem).%OpenId(orderRowId)
	s myObj.seqNo=orderObj.OEORISeqNo
	s arcimRowID=orderObj.OEORIItmMastDR.%Id()
	s arcSubCatDr=$P($G(^ARCIM(+arcimRowID,$P(arcimRowID,"||",2),1)),"^",10)
	s orderType=$P($G(^ARC("IC",arcSubCatDr)),"^",7)
	s ordCatDr=$P($G(^ARC("IC",arcSubCatDr)),"^",8)
	s ordCatCode=$P($get(^OEC("ORCAT",ordCatDr)),"^",1)
	s itemCat=$P($G(^OEC("ORCAT",ordCatCode)),"^",2)
	s myObj.itemCat=itemCat
	s itemDesc=orderObj.OEORIItmMastDR.ARCIMDesc
	s linkOrdDr=orderObj.OEORIOEORIDR
	//i linkOrdDr'="" s itemDesc="____"_itemDesc   ///子医嘱
	s myObj.itemDesc=itemDesc
	s orderDoctor=orderObj.OEORIDoctorDR.CTPCPDesc
	s orderDoctor=$P(orderDoctor,"-")
	s myObj.orderDoctor=orderDoctor
	i orderObj.OEORIDate'="" s myObj.orderDate=$ZD(orderObj.OEORIDate,3)
	e  s myObj.orderDate=$C(0)
	i orderObj.OEORITimeOrd'="" s myObj.orderTime=$ZT(orderObj.OEORITimeOrd,2)
	e  s myObj.orderTime=$C(0)
	s orderStatus=orderObj.OEORIItemStatDR.OSTATDesc
	s myObj.orderStatus=orderStatus
	i orderObj.OEORIItemStatDR.OSTATCode="D" d
	.s stopOrderDoctor=orderObj.OEORIXCTCPDR.CTPCPDesc
	.s stopOrderDoctor=$P(stopOrderDoctor,"-")
	.i stopOrderDoctor="" s stopOrderDoctor=$C(0)
	.s myObj.stopOrderDoctor=stopOrderDoctor
	.i orderObj.OEORIXDate'="" s myObj.stopOrderDate=$ZD(orderObj.OEORIXDate,3)
	.e  s myObj.stopOrderDate=$C(0)
	.i orderObj.OEORIXTime'="" s myObj.stopOrderTime=$ZT(orderObj.OEORIXTime,2)
	.e  s myObj.stopOrderTime=$C(0)
	e  d
	.s myObj.stopOrderDoctor=$C(0)
	.s myObj.stopOrderDate=$C(0)
	.s myObj.stopOrderTime=$C(0)
	////长期滚动医嘱停止情况
	i lastOrderRowId'="" d
	.s lastOrderObj=##Class(User.OEOrdItem).%OpenId(lastOrderRowId)
	.s lastOrdStateCode=lastOrderObj.OEORIItemStatDR.OSTATCode
	.s stopOrderDoctor=lastOrderObj.OEORIXCTCPDR.CTPCPDesc
	.s stopOrderDoctor=$P(stopOrderDoctor,"-")
	.i stopOrderDoctor="" s stopOrderDoctor=$C(0)
	.s myObj.stopOrderDoctor=stopOrderDoctor
	.i lastOrderObj.OEORIXDate'="" s myObj.stopOrderDate=$ZD(lastOrderObj.OEORIXDate,3)
	.e  s myObj.stopOrderDate=$C(0)
	.i lastOrderObj.OEORIXTime'="" s myObj.stopOrderTime=$ZT(lastOrderObj.OEORIXTime,2)
	.e  s myObj.stopOrderTime=$C(0)
	.s orderStatus=lastOrderObj.OEORIItemStatDR.OSTATDesc
	.s myObj.orderStatus=orderStatus
	.i orderStatus="核实" s myObj.ordItemId=lastOrderRowId
	.d lastOrderObj.%Close()	
	
	i orderObj.OEORISttDat'="" s myObj.ordStartDate=$ZD(orderObj.OEORISttDat,3)
	e  s myObj.ordStartDate=$C(0)
	i orderObj.OEORISttTim'="" s myObj.ordStartTime=$ZT(orderObj.OEORISttTim,2)
	e  s myObj.ordStartTime=$C(0)
	s priority=orderObj.OEORIPriorityDR.OECPRDesc
	i priority="" s priority=$C(0)
	s myObj.priority=priority
	i orderType="R" d
	.s myObj.doseQty=orderObj.OEORIDoseQty
	.s myObj.doseUom=orderObj.OEORIUnitDR.CTUOMDesc
	.s myObj.instruction=orderObj.OEORIInstrDR.PHCINCode
	.s myObj.duration=orderObj.OEORIDuratDR.PHCDUCode
	.s packQty=orderObj.OEORIQtyPackUOM
	.s inciRowId=$O(^INCI(0,"ARCIM_DR",+arcimRowID,""))
	.i (inciRowId'="")&&(+packQty'=0) d
	..s packUomDr=$P($G(^INCI(inciRowId,3)),"^",6)
	..i (packUomDr'="") s packUom=$P($G(^CT("UOM",packUomDr)),"^",2)
	.s myObj.icoFile="drug.png"
	e  d
	.s myObj.doseQty=$C(0)
	.s myObj.doseUom=$C(0)
	.s myObj.instruction=$C(0)
	.s myObj.duration=$C(0)
	.s myObj.icoFile="orderdefault.png"
	s myObj.frequency=orderObj.OEORIPHFreqDR.PHCFRCode
	s qty=orderObj.OEORIPhQtyOrd
	i qty="" s qty=$C(0)
	s myObj.qty=qty
	s uom=orderObj.OEORIUnitDR.CTUOMDesc
	i uom="" s uom=$C(0)
	s myObj.uom=uom
	s recLoc=orderObj.OEORIRecDepDR.CTLOCDesc
	i $P(recLoc,"-",2)'=""  s recLoc=$P(recLoc,"-",2)
	s myObj.recLoc=recLoc
	s myObj.orderNote=""
	s stopPerm=0
	i (userId'="")&&(groupId'="")&&(departmentId'="") d
	.s stopPerm=..CheckStopPermission(orderRowId,userId,groupId,departmentId)
	i orderStatus'="核实" s stopPerm=0
	s myObj.stopPerm=stopPerm
	d myObj.%Close()
	s Xml=""
	s ret=myObj.XMLExportToString(.Xml,"OrderItem")
	i ret=1 s orderItemInfo=orderItemInfo_Xml
	q orderItemInfo
}

ClassMethod CheckStopPermission(orderRowId As %String = "", userId As %String = "", groupId As %String = "", departmentId As %String = "") As %String
{
	Set $ZTrap = "StopPermMCatch"
	s stopPerm=0
	s hospId=$O(^CT("HOSP",0))
	i hospId'="" s hospCode=$p($g(^CT("HOSP",hospId)),"^",1)
	i (hospCode="WHSDYYY")||(hospCode="ZDSY") d
	.s stopPerm=..CheckStopPerm(orderRowId,userId,departmentId,groupId)
	e  d
	.s stopPerm=##class(appcom.OEOrdItem).CheckStopPermission(orderRowId,userId,departmentId,groupId)
	q stopPerm
StopPermMCatch
	q 0
}

ClassMethod CheckStopPerm(OrderItemRowId As %String, UserRowId As %String, LocID As %String, GroupID As %String = "") As %String
{
	;s AddUserRowId=$P($G(^OEORD(+OrderItemRowId,"I",$P(OrderItemRowId,"||",2),7)),"^",1)
	;s DoctorDr=$P(^SSU("SSUSR",AddUserRowId),"^",14)
	;Q:DoctorDr="" 0
	s DoctorDr=$P($G(^OEORD(+OrderItemRowId,"I",$P(OrderItemRowId,"||",2),1)),"^",11)	
	Q:DoctorDr="" 1
	
	if $d(^RB("RES",0,"CTPCP",DoctorDr,LocID)) s ret=1 q ret
	s ret=0,isNurse=0
	s ctpcprowid=$P(^SSU("SSUSR",UserRowId),"^",14)
	s CTPCPCarPrvTpDR = $p(^CTPCP(ctpcprowid,1),"^",4)
	s CTCPTInternalType = $p(^CT("CPT",CTPCPCarPrvTpDR),"^",4)
	s:CTCPTInternalType="NURSE" isNurse=1
	s oeori = ++OrderItemRowId
	s oeorisub = $P(OrderItemRowId,"||",2)
	
	if isNurse=1 d
	.;if $d(^RB("RES",0,"CTPCP",DoctorDr,LocID)) s ret=1 q
	.;else  d
	.;护士可以单独停医生开出的绑定其他医嘱的非医嘱单医嘱
	.s currLocId=","_LocID_","
	.s id=0 f  s id=$o(^CTLOC(id)) q:id=""  d
	..i $d(^CTLOC(id,"LINK",0,"Loc",LocID))=10 s currLocId=currLocId_id_","
	.s ordDept = $p($g(^OEORD(oeori,"I",oeorisub,7)),"^",2)	;OEORI_UserDepartment_DR
	.q:currLocId'[ordDept		;转科医嘱不能停
	.q:'$d(^OEORD(oeori,"I",oeorisub,11))
	.s oriOriDr=$p(^OEORD(oeori,"I",oeorisub,11),"^",39)
	.q:oriOriDr=""				;非子嘱不能停
	.s str1 = ^OEORD(oeori,"I",oeorisub,1)
	.s ItmMastDR = $p(str1,"^",2)
	.s mastItemCat = $p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",10)			;护士站配置 子类		
	.s:$g(^DHCOEOrdPrintSet("NotSordCat"))[("^"_mastItemCat_"^") ret=1	q
	.s arcicOrdCatDR = $p(^ARC("IC",mastItemCat),"^",8)								;护士站配置 大类
	.s:$g(^DHCOEOrdPrintSet("NotOrdCat"))[("^"_arcicOrdCatDR_"^") ret=1 q

	q ret
}

ClassMethod StopOrder(Param As %String = "") As %String
{
	//q "100^此模块暂时不开放!"
	s retStr=""
    s Param=$TR(Param,$C(10))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    // s sc=reader.OpenStream(objStream)
    d reader.Correlate("Request","DWR.MSG.Request")
    //Do reader.Rewind()
	While reader.Next(.request,.sc)
	{
	   s userCode=request.userCode
	   s userCode=$TR(userCode,$C(0))
	   s admId=request.admId
	   s admId=$TR(admId,$C(0))
	   s ordItemId=request.ordItemId
	   s ordItemId=$TR(ordItemId,$C(0))
	}
	q:$G(userCode)="" "200^用户名不能为空!"
	s userCode=$ZConvert(userCode,"U")
	s userId=$order(^SSU("SSUSR",0,"SSUSR_Initials",userCode,"0"))
	q:$G(userId)="" "201^用户名不存在!"
	q:($G(admId)="") "202^就诊号不能为空!"
	q:($G(ordItemId)="") "203^医嘱Id不能为空!"
	s stopPerm=0
	s hospId=$O(^CT("HOSP",0))
	i hospId'="" s hospCode=$p($g(^CT("HOSP",hospId)),"^",1)
	i (hospCode="WHSDYYY")||(hospCode="ZDSY") d
	.s stopRet=..StopOrderExcOld(ordItemId,userId)
	e  d
	.s stopRet=..StopOrderExc(ordItemId,userId)
	q stopRet
}

ClassMethod StopOrderExcOld(orderRowId As %String = "", userId As %String = "", stopDate As %String = "", stopTime As %String = "") As %String
{
	//q "100^此模块暂时不开放!"
	Set $ZTrap = "StopMCatchOld"
	i stopDate="" s stopDate=$p($h,",",1)
	i stopTime="" s stopTime=$p($h,",",2)
	s $P(orderRowId,"&",3)=$ZT(stopTime)
	s stopRet=##class(web.UDHCStopOrderLook).StopOrder("""","""",orderRowId,userId,"","N")
	s stopRet=+stopRet
	i stopRet=0 q "0^医嘱停止成功!"
	i stopRet=-100 q "301^医嘱停止失败:医嘱不存在!"
	i stopRet=-201 q "302^医嘱停止失败:已停止医嘱不能再停!"
	i stopRet=-203 q "303^医嘱停止失败:已执行的医嘱不能停止!"
	i stopRet=-302 q "304^医嘱停止失败:临时医嘱已执行不能停止!"
	i stopRet=-202 q "305^医嘱停止失败:更新预停止时间失败!"
	i stopRet=-205 q "306^医嘱停止失败:更新医嘱状态失败!"
	i stopRet=-206 q "307^医嘱停止失败:更新医嘱停止时间失败!"
	q "308^医嘱停止失败:异常未识别!"

StopMCatchOld
	q "400^停医嘱发生异常!"
}

ClassMethod StopOrderExc(orderRowId As %String = "", userId As %String = "", stopDate As %String = "", stopTime As %String = "") As %String
{
	Set $ZTrap = "StopMCatch"
	i stopDate="" s stopDate=$p($h,",",1)
	i stopTime="" s stopTime=$p($h,",",2)
	s stopRet=##class(appcom.OEOrdItem).Stop(orderRowId,userId,stopDate,stopTime)
	s stopRet=+stopRet
	i stopRet=0 q "0^医嘱停止成功!"
	i stopRet=-100 q "301^医嘱停止失败:医嘱不存在!"
	i stopRet=-201 q "302^医嘱停止失败:已停止医嘱不能再停!"
	i stopRet=-203 q "303^医嘱停止失败:已执行的医嘱不能停止!"
	i stopRet=-302 q "304^医嘱停止失败:临时医嘱已执行不能停止!"
	i stopRet=-202 q "305^医嘱停止失败:更新预停止时间失败!"
	i stopRet=-205 q "306^医嘱停止失败:更新医嘱状态失败!"
	i stopRet=-206 q "307^医嘱停止失败:更新医嘱停止时间失败!"
	q "308^医嘱停止失败:异常未识别!"
StopMCatch
	q "400^停医嘱发生异常!"
}

/// w ##Class(DWR.BL.OrderItem).GetTempOrdItem()
ClassMethod GetTempOrdItem(Param As %String = "") As %String
{
	s retStr=""
	i Param="" s Param="<Request><admId>426761</admId><orderState>V</orderState><startDate>2013-01-09</startDate><endDate>2013-01-09</endDate></Request>"
    s Param=$TR(Param,$C(10))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    // s sc=reader.OpenStream(objStream)
    d reader.Correlate("Request","DWR.MSG.Request")
    //Do reader.Rewind()
	While reader.Next(.request,.sc)
	{
	   s userCode=request.userCode
	   s userCode=$TR(userCode,$C(0))
	   s admId=request.admId
	   s admId=$TR(admId,$C(0))
	   s orderState=request.orderState
	   s orderState=$TR(orderState,$C(0))
	   s startDate=request.startDate
	   s startDate=$TR(startDate,$C(0))
	   s endDate=request.endDate
	   s endDate=$TR(endDate,$C(0))
	   s groupId=request.groupId
	   s groupId=$TR(groupId,$C(0))
	   s departmentId=request.departmentId
	   s departmentId=$TR(departmentId,$C(0))
	}
	q:$G(userCode)="" "200^用户名不能为空!"
	s userCode=$ZConvert(userCode,"U")
	s userId=$order(^SSU("SSUSR",0,"SSUSR_Initials",userCode,"0"))
	q:$G(userId)="" "200^用户名不存在!"
	q:($G(admId)="") "201^就诊号不能为空!"
	q:($G(startDate)="")||($G(endDate)="") "202^查询日期不能为空!"
	i startDate'="" s startDate=$ZDH(startDate,3)
	i endDate'="" s endDate=$ZDH(endDate,3)
	i +endDate=0 d
	.s endDate=+$H
	.s startDate=endDate-3
	i endDate-startDate>2 q "203^查询日期不能超过三天!"
	i orderState="" s orderState="V"
	s ordRowId=""
	f  s ordRowId=$O(^OEORD(0,"Adm",admId,ordRowId)) q:ordRowId=""  d
	.s ordSubId=""
	.f  s ordSubId=$O(^OEORD(ordRowId,"I",ordSubId))  q:(ordSubId="")  d
	..q:+ordSubId=0
	..s priorDr=$P($G(^OEORD(ordRowId,"I",ordSubId,1)),"^",8)
	..q:priorDr=""
	..s priorDes=$P(^OECPR(priorDr),"^",2)    
	..s priorDes="^"_priorDes_"^"
	..q:(^DHCOEOrdPrintSet("OrdTyp")'[priorDes)
	..s ordStatDr=$P($G(^OEORD(ordRowId,"I",ordSubId,1)),"^",13) 
	..s ordStatCode=$p(^OEC("OSTAT",ordStatDr),"^",1)
	..q:(ordStatCode="U")!(ordStatCode="I")!(ordStatCode="C")
	..q:(ordStatCode="D")
	..s fillerNo=$P($G(^OEORD(ordRowId,"I",ordSubId,9)),"^",12) 
	..q:fillerNo'="" //过滤滚动出来的长期医嘱
	..s ordUser=$P($G(^OEORD(ordRowId,"I",ordSubId,7)),"^",1)
	..q:ordUser=""
	..s doctorDr=$P(^SSU("SSUSR",ordUser),"^",14)
	..q:doctorDr=""
	..s careTypDr=$P(^CTPCP(doctorDr,1),"^",4)
	..q:careTypDr=""
	..s careTyp=$P(^CT("CPT",careTypDr),"^",4)  
	..q:($G(careTyp)'="DOCTOR")&($G(^DHCOEOrdPrintSet("ifnur"))'="true")
	..s arcimDr=$P($G(^OEORD(ordRowId,"I",ordSubId,1)),"^",2)
	..s arcimRowId=$P(arcimDr,"||",1)
	..s arcimSubId=$P(arcimDr,"||",2)  
	..s itemCatDr=$P($G(^ARCIM(arcimRowId,arcimSubId,1)),"^",10)
	..s ordCatDr=$P(^ARC("IC",itemCatDr),"^",8)
	..s ordCat=$P(^OEC("ORCAT",ordCatDr),"^",1)
	..s ordCatDr="^"_ordCatDr_"^"
	..q:$G(^DHCOEOrdPrintSet("NotOrdCat"))[ordCatDr&($G(^DHCOEOrdPrintSet("NotOrdCat"))'="")
	..s itemCatDr="^"_itemCatDr_"^" 
	..q:$G(^DHCOEOrdPrintSet("NotSordCat"))[itemCatDr&($G(^DHCOEOrdPrintSet("NotSordCat"))'="")
	..//s orderDate=$P($G(^OEORD(ordRowId,"I",ordSubId,1)),"^",9) //医嘱开始日期
	..s orderDate=$P($G(^OEORD(ordRowId,"I",ordSubId,3)),"^",7)
	..s orderDate=+orderDate
	..q:(orderDate<startDate)||(orderDate>endDate)
	..s seqNo=$P($G(^OEORD(ordRowId,"I",ordSubId,3)),"^",4)
	..s linkOrdDr=$p($g(^OEORD(ordRowId,"I",ordSubId,11)),"^",39)
	..i linkOrdDr'="" d
	...s arcimOrdItem(orderDate,$P(linkOrdDr,"||"),$P(linkOrdDr,"||",2),seqNo)=ordRowId_"||"_ordSubId
	..e  d
	...s arcimOrdItem(orderDate,ordRowId,ordSubId,seqNo)=ordRowId_"||"_ordSubId
	s orderIndex=1
	s orderDate=""
	f  s orderDate=$O(arcimOrdItem(orderDate)) q:orderDate=""  d
	.s ordRowId=""
	.f  s ordRowId=$O(arcimOrdItem(orderDate,ordRowId)) q:ordRowId=""  d
	..s ordSubId=""
	..f  s ordSubId=$O(arcimOrdItem(orderDate,ordRowId,ordSubId)) q:ordSubId=""  d
	...s seqNo=""
	...f  s seqNo=$O(arcimOrdItem(orderDate,ordRowId,ordSubId,seqNo)) q:seqNo=""  d
	....s orderRowId=$G(arcimOrdItem(orderDate,ordRowId,ordSubId,seqNo))
	....q:orderRowId=""
	....q:$L(retStr)>30000
	....s orderItem=..GetOrdItemInfo(orderRowId,orderIndex,userId,groupId,departmentId)
	....s retStr=retStr_orderItem
	....s orderIndex=orderIndex+1
	q retStr
}

}
