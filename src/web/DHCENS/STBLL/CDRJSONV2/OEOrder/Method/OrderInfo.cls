Class web.DHCENS.STBLL.CDRJSONV2.OEOrder.Method.OrderInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// 根据登记号发送患者的医嘱信息
/// w ##class(web.DHCENS.STBLL.CDRJSONV2.OEOrder.Method.OrderInfo).sendOrdItem("")
ClassMethod sendOrdItem(PatRegNo)
{
	
	set patRowId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatRegNo),""))
	set admType=""
	for {
		set admType=$o(^PAPERdr(patRowId,"ADM",admType))	
		quit:admType=""
		set admId=""
		for {
			set admId=$o(^PAPERdr(patRowId,"ADM",admType,admId))
			q:admId=""
			set mainord=""
			for{
				set mainord=$o(^OEORD(0,"Adm",admId,mainord))	
				quit:mainord=""
				set subord=""
				for{
					set subord=$o(^OEORD(mainord,"I",subord))	
					quit:subord=""
					set orditemdr=mainord_"||"_subord
					set inputStream=..GetOEOrder(orditemdr)
					s tRequest=##class(%Net.HttpRequest).%New()
					do tRequest.SetHeader("Cache-Control", "no-cache")
					Do tRequest.ContentTypeSet("application/x-www-form-urlencoded; charset=utf-8")
				 	set tRequest.Server="192.168.255.185"
				 	set tRequest.Port="9098"
				 	d tRequest.EntityBody.Write()
				 	
				 	d tRequest.InsertFormData("content",inputStream)
					set tSc = tRequest.Post("/hdc/SaveService/ACC0008")
					set OutputStream=tRequest.HttpResponse.Data
				}
			}	
		}	
	}

	quit 0
}

/// Creator：ZhangXinying
/// CreatDate：2020-12-22
/// Description：根据id取医嘱明细表(ACC0008)
/// Table：OE_Order OE_OrdItem
/// Input：医嘱rowid
/// Output：
/// Return：数据中心OE_Order医嘱明细(json)
/// Others：w ##class(web.DHCENS.STBLL.CDRJSONV2.OEOrder.Method.OrderInfo).GetOEOrder("30604441||74")
ClassMethod GetOEOrder(ordRowId As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set stream=##class(%GlobalCharacterStream).%New()
	set obj=##class(web.DHCENS.STBLL.CDRJSONV2.OEOrder.Model.Data).%New()
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.OEOrder.Model.Oeorditem).%New()
	set ordID=$p(ordRowId,"||",1),ordSub=$p(ordRowId,"||",2)
	if (ordRowId="")||($d(^OEORD(ordID))=0) {
		d stream.Write("{}")
		quit stream	
	}
	set admRowId=$p($g(^OEORD(ordID)),"^",1)
	set patID=$p($g(^PAADM(admRowId)),"^",1)
	set subObj=..GetOeorditmInfo(ordRowId)
	d obj.oeorditemList.Insert(subObj)
	set JsonString=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.JSONUtil).ObjToJson(obj,"")
	d stream.Write(JsonString)
	quit stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("{}")
	quit stream
}

ClassMethod GetSpecName(oerowid) As %String
{
	s OrdId=$p(oerowid,"||",1)
	s SubId=$p(oerowid,"||",2)
	s SpecDr=$o(^OEORD(OrdId,"I",SubId,"SPEC",""),-1)
	s (SpecCode,SpecName)=""
	i $l(SpecDr) s SpecCode=$p(^OEORD(OrdId,"I",SubId,"SPEC",SpecDr),"^",1)
	i $l(SpecCode), $d(^TTAB("SPEC",SpecCode)){
		s SpecName=$p($g(^TTAB("SPEC",SpecCode)),"\",1)
	}
	q SpecCode
}

/// w ##class(web.DHCENS.STBLL.ORDER.METHOD.OEOrder).GetSpec("9325||1")
ClassMethod GetSpec(arcim As %String) As %String
{
	set $zt="Exception"
	set arcim=+arcim	q:arcim<1 ""
	set inci=$o(^INCI(0,"ARCIM_DR",arcim,""))
	q:inci="" ""
	set inci=+inci
	//***规格取法一
	set info=$O(^DHCITMINFO(0,"INCI",inci,"")) q:info="" ""
	set spec=$p($g(^DHCITMINFO(info)),"^",27)
	q spec
Exception
	Quit "获取规格信息有误"
}

/// 获取医嘱价格
/// w ##class(web.DHCENS.STBLL.ORDER.METHOD.OEOrder).GetPrice("1629||28")
ClassMethod GetPrice(rowid As %String) As %String
{
	set $zt="Exception"
    set EpissubtypeDR=""
    set tempRowid=##class(web.DHCENS.STBLL.UTIL.Common).ReplaceStr(rowid,"_","||")
    set tmpAdm=$p($g(^OEORD(+tempRowid)),"^",1)
    set EpissubtypeDR=$P($g(^PAADM(tmpAdm,1)),"^",6)
       
    // 取子医嘱中医嘱价格，当医嘱类型的子类是Price时，取医嘱表中OEORI_Price中价格，
    // 然后调用计费组方法set tmpchild=##CLASS(web.UDHCJFPRICE).GetOrderPrice(EpissubtypeDR,"",childarcimId,$P(childordstr3,"^",7),"","","",$p(childordstr3,"^",25))
    set childIndex="",childOrdPrice=0
    set ord=+rowid
    set arcimId = $P($g(^OEORD(ord,"I",$p(rowid,"||",2),1)),"^",2)
    set arcSub = $P(arcimId,"||",1)
    set arcVer = $P(arcimId,"||",2)
    f  s childIndex=$o(^OEORDi(0,"OEORI",ord,tempRowid,childIndex))  q:childIndex=""  d
	.set childordstr1 = $g(^OEORD(ord,"I",childIndex,1))
	.set childordstr3 = $g(^OEORD(ord,"I",childIndex,3))
	.set childarcimId = $P(childordstr1,"^",2)
	.set ItmMastFirst=$p(childarcimId,"||",1)
	.set ItmMastLast=$p(childarcimId,"||",2)
	.set ItemCatRowID=$p($g(^ARCIM(ItmMastFirst,ItmMastLast,1)),"^",10)
	.set ItmCatType=$p($g(^ARC("IC",ItemCatRowID)),"^",7)
	.set tmpchild=0
	.i ItmCatType="P" d
	..set tmpchild=##CLASS(web.UDHCJFPRICE).GetOrderPrice(EpissubtypeDR,"",childarcimId,$P(childordstr3,"^",7),"","","",$p(childordstr3,"^",25))
	.set childOrdPrice=+childOrdPrice++($P(tmpchild,"^",1))
	set OrdSubCatRowID=$p($g(^ARCIM(arcSub,arcVer,1)),"^",10)
    //取父医嘱价格信息，方式同取子医嘱类方法相同
	set CatType=$p($g(^ARC("IC",OrdSubCatRowID)),"^",7)
	set tmpPrice=""
	set VerifyDate=$P($g(^OEORD(ord,"I",$p(rowid,"||",2),3)),"^",7)
	set ordstr3=$g(^OEORD(ord,"I",$p(rowid,"||",2),3))
	if (CatType="P") {
		s tmpPrice=$p(ordstr3,"^",25)
    	set price = ##CLASS(web.UDHCJFPRICE).GetOrderPrice(EpissubtypeDR,"",arcimId,VerifyDate,"","","",+tmpPrice)
	}
	else {
    	set price = ##CLASS(web.UDHCJFPRICE).GetOrderPrice(EpissubtypeDR,"",arcimId,VerifyDate,"","","","")
	}
    set TotalPrice=childOrdPrice+price
    Quit TotalPrice
Exception
	Quit "价格异常"
}

ClassMethod GetOeorditmInfo(ordRowId) As web.DHCENS.STBLL.CDRJSONV2.OEOrder.Model.Oeorditem
{
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.OEOrder.Model.Oeorditem).%New()
	set businessfieldcode=subObj.businessfieldcode
	set ord = $P(ordRowId,"||",1)
	set sub = $P(ordRowId,"||",2)
	
	set ordstr1 = $g(^OEORD(ord,"I",sub,1))
	set ordstr2 = $g(^OEORD(ord,"I",sub,2))
	set ordstr3 = $g(^OEORD(ord,"I",sub,3))
	set ordstr7 = $g(^OEORD(ord,"I",sub,7))
	set ordstr9 = $g(^OEORD(ord,"I",sub,9))
    set arcimId = $P(ordstr1,"^",2)
    set arcSub = $P(arcimId,"||",1)
    set arcVer = $P(arcimId,"||",2)
	set admRowId=$p($g(^OEORD(ord)),"^",1)
	set patID=$p($G(^PAADM(admRowId)),"^",1)
	
	set arcimCode=$p($g(^ARCIM(arcSub,arcVer,1)),"^",1)                     
	set subObj.oeoriparentorderid=$p($g(^OEORD(ord,"I",sub,11)),"^",39)	  //父医嘱明细id
	set subObj.oeoriarcitmmastcode=arcimId //医嘱项目代码
	set subObj.oeoriprioritycode= $P(ordstr1,"^",8) //医嘱类型代码
	set orderPriorCode=$P(ordstr1,"^",8)
	set orderPriorRemarks=$CASE(orderPriorCode,"OM":"OM","OMLSZT":"ZT","OMST":"OM","ONE":"ONE",:"")
	set subObj.oeoripriorityaddcode=orderPriorRemarks //医嘱附加类型
	set subObj.oeoristatus=$P(ordstr1,"^",13) //医嘱状态代码
	set pHCDFRowID = $p($g(^ARCIM(arcSub,arcVer,1)),"^",12)	
	set formId=""
	if pHCDFRowID'="" {
		set formId=$p($g(^PHCD(+pHCDFRowID,"DF",$p(pHCDFRowID,"||",2),1)),"^",1)
	}
	set subObj.oeoridoseforms=formId     //剂型代码
	set OEORIDoseQty=$p(ordstr2,"^",1)
	set subObj.oeoridoseqty=$tr(OEORIDoseQty,"/","") //单次剂量
	set subObj.oeoridoseunitcode=$P(ordstr2,"^",3) //单次剂量单位代码
	set subObj.oeorifreqcode=$P(ordstr2,"^",4)   //频次代码
	set subObj.oeoriinstrcode=$p(ordstr2,"^",7) //用药途径代码
	set subObj.oeoridurationcode=$P(ordstr2,"^",6) //疗程
	set OEORIOrderQty=$p(ordstr9,"^",4)
	if OEORIOrderQty="" {
		set subObj.oeoriorderqty=1 //医嘱数量
	}else{
		set subObj.oeoriorderqty=OEORIOrderQty
	}
	set subObj.oeorichargeunit=$P(ordstr2,"^",3) //计价单位
	set OEORIRemarks=$g(^OEORD(ord,"I",sub,"DEP",1))
	set subObj.oeoriremarks=$tr(OEORIRemarks," ","") //备注
	set oeorienterdoccode=$P(ordstr1,"^",11) 
	set subObj.oeorienterdoccode=oeorienterdoccode  //医嘱开立者代码
	set verifyDate = $P(ordstr3,"^",7)
	set:verifyDate'="" subObj.oeorienterdate=$ZD(verifyDate,3) //医嘱开立日期
	set verifyTime = $P(ordstr1,"^",17)
	set:verifyTime'="" subObj.oeorientertime=$ZT(verifyTime) //医嘱开立时间
	set appDeptRowID = $P(ordstr7,"^",2)
	set subObj.oeorienterdeptcode=appDeptRowID     //医嘱开立科室代码
	set subObj.oeoriexecdeptcode=$P(ordstr3,"^",6)    //医嘱执行科室
	set startDate = $P(ordstr1,"^",9)
	set:startDate'="" subObj.oeorirequireexecdate=$ZD(startDate,3) //要求执行日期
	set startTime = $P(ordstr1,"^",10)
	set:startTime'="" subObj.oeorirequireexectime=$ZT(startTime) //要求执行时间
	set stopDate=$p(ordstr3,"^",34)
	set:stopDate'="" subObj.oeoristopdate=$ZD(stopDate,3) //医嘱停止日期
	set stopTime=$p(ordstr2,"^",15)
	set:stopTime'="" subObj.oeoristoptime=$ZT(stopTime) //医嘱停止时间
	set oeoristopdoccode=$p(^OEORD(ord,"I",sub,3),"^",29)
	set subObj.oeoristopdoccode=oeoristopdoccode //停止医嘱者代码
	set subObj.oeoriisskintest=$p($g(^OEORD(ord,"I",sub,5)),"^",2) //是否皮试
	set OrdUpdateDate=$p($g(^OEORD(ord,"I",sub,11)),"^",4),OrdUpdateTime=$p($g(^OEORD(ord,"I",sub,11)),"^",5)
	set:OrdUpdateDate'="" subObj.oeoriupdatedate=$zd(OrdUpdateDate,3)      //时间戳日期
	set:OrdUpdateTime'="" subObj.oeoriupdatetime=$zt(OrdUpdateTime)   //时间戳时间
	set:OrdUpdateDate="" subObj.oeoriupdatedate=$zd(+$h,3)      //时间戳日期
	set:OrdUpdateTime="" subObj.oeoriupdatetime=$zt($p($h,",",2))   //时间戳时间
	set subObj.oeoriupdateusercode=$p($g(^OEORD(ord,"I",sub,8)),"^",12) //更新用户
	set subObj.oeoriprescno=$p(ordstr1,"^",14) //处方号
	set subObj.updatedate=$zd(+$h,3)
	set subObj.updatetime=$zt($p($h,",",2))
	set subObj.oeorialias=$p($g(^ARCIM(arcSub,arcVer,1)),"^",3) //医嘱别名
	set subObj.oeoriseqno=$p($g(^OEORD(ord,"I",sub,3)),"^",4)
	set OEORIBBExtCodeDR=$p($g(^OEORD(ord,"I",sub,11)),"^",18),OEORIBBExtCode=""
	set:OEORIBBExtCodeDR'="" OEORIBBExtCode=$p($g(^PAC("ADMREA",OEORIBBExtCodeDR)),"^",1)
	set subObj.oeoricostcategorycode=OEORIBBExtCode //医嘱费别
	if (oeoristopdoccode'="") {
		set subObj.oeoristopdocname=$p($G(^CTPCP(oeoristopdoccode,1)),"^",2)   //停止医嘱者描述
	}
	if (oeorienterdoccode'=""){
		set subObj.oeorienterdocname=$p($G(^CTPCP(oeorienterdoccode,1)),"^",2)   //医嘱开立者描述
	}
	set subObj.oeorifillerno=$p($g(^OEORD(ord,"I",sub,9)),"^",12) //滚医嘱来源信息  首医嘱!!上一条医嘱 1||2!!1||2
	set subObj.papatrelpatientid=businessfieldcode_"_"_patID //业务域_院内患者id
	set subObj.paadmrelvisitnumber=businessfieldcode_"_"_admRowId         //业务域_院内就诊号
	set subObj.oeorihosorderitemid=ordRowId //院内医嘱明细id
	set subObj.oeorirelorderitemid=businessfieldcode_"_"_ordRowId //全局医嘱明细id
	quit subObj
}

/// Creator：wl
/// CreatDate：2020-12-22
/// Description：根据开医嘱时间取医嘱明细表(ACC0008)历史数据Global
/// Table：OE_Order OE_OrdItem
/// Input：医嘱rowid
/// Output：
/// Return：数据中心OE_Order医嘱明细(Global)
/// Others：w ##class(web.DHCENS.STBLL.CDRJSONV2.OEOrder.Method.OrderInfo).GetOEOrderGlobal("2017-08-31","2022-02-25")
ClassMethod GetOEOrderGlobal(strdate As %String, enddate As %String) As %String
{
	set $zt="Exception"
	set ^ExportHistoryData("OEOrder")=$lb("院内医嘱明细id","父医嘱明细id","医嘱项目代码","医嘱类型代码","医嘱附加类型代码","医嘱状态","剂型代码","单次剂量","单次剂量单位代码","频次代码","用药途径代码","疗程","医嘱数量","计价单位","医嘱备注信息","医嘱开立者代码","医嘱开立日期","医嘱开立时间","医嘱开立科室代码","医嘱执行科室","要求执行日期","要求执行时间","医嘱停止日期","医嘱停止时间","停止医嘱者代码","是否皮试","最后更新日期","最后更新时间","最后更新人编码","处方号","时间戳","时间戳","医嘱别名","组号","医嘱费别","停止医嘱者描述","医嘱开立者描述","滚医嘱来源信息","院内患者id","院内就诊号")
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.OEOrder.Model.Oeorditem).%New()
	if (strdate="")||(enddate="") {
		quit "-1^入参不能为空"
	}
	set:strdate["-" strdate=$zdh(strdate,3)
	set:enddate["-" enddate=$zdh(enddate,3)
	set con=0,strtime=$zt($p($now(),",",2))
	set OEORIDate=""
	for OEORIDate=strdate:1:enddate
	{	
		set ordID=""
		for{
			set ordID=$o(^OEORDi(0,"ItemDate",OEORIDate,ordID))
			quit:ordID=""
			continue:$d(^OEORD(ordID))=0
			set ordSub=""
			for {
				set ordSub=$o(^OEORDi(0,"ItemDate",OEORIDate,ordID,ordSub))
				quit:ordSub=""
				set ordRowId=ordID_"||"_ordSub
				set con=con+1
				set subObj=..GetOeorditmInfo(ordRowId)
				set ^ExportHistoryData("OEOrder",ordRowId)=$lb(ordRowId,subObj.oeoriparentorderid,subObj.oeoriarcitmmastcode,subObj.oeoriprioritycode,subObj.oeoripriorityaddcode,
															   subObj.oeoristatus,subObj.oeoridoseforms,subObj.oeoridoseqty,subObj.oeoridoseunitcode,subObj.oeorifreqcode,subObj.oeoriinstrcode,
															   subObj.oeoridurationcode,subObj.oeoriorderqty,subObj.oeorichargeunit,subObj.oeoriremarks,subObj.oeorienterdoccode,
															   subObj.oeorienterdate,subObj.oeorientertime,subObj.oeorienterdeptcode,subObj.oeoriexecdeptcode,subObj.oeorirequireexecdate,
															   subObj.oeorirequireexectime,subObj.oeoristopdate,subObj.oeoristoptime,subObj.oeoristopdoccode,subObj.oeoriisskintest,
															   subObj.oeoriupdatedate,subObj.oeoriupdatetime,subObj.oeoriupdateusercode,subObj.oeoriprescno,subObj.updatedate,
															   subObj.updatetime,subObj.oeorialias,subObj.oeoriseqno,subObj.oeoricostcategorycode,subObj.oeoristopdocname,subObj.oeorienterdocname,
															   subObj.oeorifillerno,subObj.oeorirelorderitemid,subObj.paadmrelvisitnumber,subObj.papatrelpatientid,subObj.businessfieldcode)
				set no=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.StringUtil).point(strdate, enddate, con, OEORIDate)
			}
		}
	}
	quit "Finish   count:"_con
Exception
	quit "-1^"_$ze
}

}
