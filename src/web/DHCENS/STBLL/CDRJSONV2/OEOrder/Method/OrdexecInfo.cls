Class web.DHCENS.STBLL.CDRJSONV2.OEOrder.Method.OrdexecInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2020-12-22
/// Description：根据id取医嘱执行记录表(ACC0009)
/// Table：OE_OrdExec
/// Input：医嘱执行记录rowid
/// Output：
/// Return：数据中心OE_OrdExec医嘱(json)
/// Others：w ##class(web.DHCENS.STBLL.CDRJSONV2.OEOrder.Method.OrdexecInfo).GetOEOrderExec("30550473||113||69")
ClassMethod GetOEOrderExec(ordExecRowId As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set stream=##class(%GlobalCharacterStream).%New()
	set obj=##class(web.DHCENS.STBLL.CDRJSONV2.OEOrder.Model.Data).%New()
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.OEOrder.Model.Oeordexec).%New()
	set ordID=$p(ordExecRowId,"||",1),ordSub=$p(ordExecRowId,"||",2),ordExec=$p(ordExecRowId,"||",3)
	set ordRowId=ordID_"||"_ordSub
	if (ordExecRowId="")||($d(^OEORD(ordID))=0) {
		d stream.Write("{""theme"":""theme001"",""data"":[]}")
		quit stream	
	}
	set arcim=$p($g(^OEORD(ordID,"I",ordSub,1)),"^",2)
	if arcim="" {
		d stream.Write("{""theme"":""theme001"",""data"":[error:""-1^医嘱项id不能为空""]}")
		quit stream	
	}
	set subObj=..Getordexecinfo(ordExecRowId)
	d obj.oeorditemList.Insert(subObj)
	set JsonString=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.JSONUtil).ObjToJson(obj,"")
	d stream.Write(JsonString)
	quit stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("{}")
	quit stream
}

/// w ##class(web.DHCENS.STBLL.CDRJSONV2.OEOrder.Method.OrdexecInfo).Getordexecinfo("30535374||21||25")
ClassMethod Getordexecinfo(ordExecRowId) As web.DHCENS.STBLL.CDRJSONV2.OEOrder.Model.Oeordexec
{
		
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.OEOrder.Model.Oeordexec).%New()
	set businessfieldcode=subObj.businessfieldcode
	set ordID=$p(ordExecRowId,"||",1),ordSub=$p(ordExecRowId,"||",2),ordExec=$p(ordExecRowId,"||",3)
	set ordRowId=ordID_"||"_ordSub
	set OEOrdExecInfo=$g(^OEORD(ordID,"I",ordSub,"X",ordExec))
	set OEOREExStDate=$p(OEOrdExecInfo,"^",1)
	set:OEOREExStDate'="" OEOREExStDate=$zd(OEOREExStDate,3)
	set OEOREExStTime=$p(OEOrdExecInfo,"^",2)
	set:OEOREExStTime'="" OEOREExStTime=$zt(OEOREExStTime)
	//1.如果是非药品，长期类记录的是每次的数量，临时类记录的总数量2.如果是药品，记录的是OEORI_PhQtyOrd,临时类医嘱为总剂量，长期医嘱为单次剂量
	set OEOREPhQtyOrd=$p(OEOrdExecInfo,"^",4)
	set OEORECTUOMDR=$p(OEOrdExecInfo,"^",17),OEORECTUOMCode=""

	set OEORECTUOMCode=OEORECTUOMDR
	set OEOREQtyAdmin=$p(OEOrdExecInfo,"^",5)
	set OEOREDesc=$p(OEOrdExecInfo,"^",21)
	set OEOREXDate=$p(OEOrdExecInfo,"^",12)
	set:OEOREXDate'="" OEOREXDate=$zd(OEOREXDate,3)
	set OEOREXTime=$p(OEOrdExecInfo,"^",14)
	set:OEOREXTime'="" OEOREXTime=$zt(OEOREXTime)
	set OEORECTPCPCode=$p(OEOrdExecInfo,"^",15)
	set OEOREDateExecuted=$p(OEOrdExecInfo,"^",19)
	set:OEOREDateExecuted'="" OEOREDateExecuted=$zd(OEOREDateExecuted,3)
	set OEORETimeExecuted=$p(OEOrdExecInfo,"^",20)
	set:OEORETimeExecuted'="" OEORETimeExecuted=$zt(OEORETimeExecuted)
	set OEOREOrderStatusDR=$p(OEOrdExecInfo,"^",16),OEOREOrderStatusCode=""
	set OEOREOrderStatusCode=OEOREOrderStatusDR
	// 要求执行日期
	set OEORERequireExecDate=OEOREExStDate
	// 要求执行时间
	set OEORERequireExecTime=OEOREExStTime
	set OEOREExEnDate=$p(OEOrdExecInfo,"^",35)
	set:OEOREExEnDate'="" OEOREExEnDate=$zd(OEOREExEnDate,3)
	set OEOREExEnTime=$p(OEOrdExecInfo,"^",36)
	set:OEOREExEnTime'="" OEOREExEnTime=$zt(OEOREExEnTime)
	set admRowId=$p($g(^OEORD(ordID)),"^",1)
	set patID=$p($g(^PAADM(admRowId)),"^",1)
	set OrdObj=..OEOrdItem(ordRowId)
	set arcim=$p($g(^OEORD(ordID,"I",ordSub,1)),"^",2)
	set arcimCode=arcim
	set subObj.oeoreexecstdate=OEOREExStDate	//执行开始日期
	set subObj.oeoreexecsttime=OEOREExStTime	//执行开始时间
	set subObj.oeoredoseqty=OEOREPhQtyOrd //剂量
	set subObj.oeoredoseunitcode=OEORECTUOMCode //剂量单位
	set subObj.oeoreqtyadmin=OEOREQtyAdmin //计费数量
	set subObj.oeoredesc=OEOREDesc //简短描述
	set subObj.oeorexdate=OEOREXDate //撤销执行日期
	set subObj.oeorextime=OEOREXTime //撤销执行时间
	set subObj.oeoreexecusercode=OEORECTPCPCode //执行人代码
	set subObj.oeoredateexecuted=OEOREDateExecuted //执行日期
	set subObj.oeoretimeexecuted=OEORETimeExecuted //执行时间
	set subObj.oeoreadminstatuscode=OEOREOrderStatusCode //医嘱执行记录状态
	set subObj.oeorerequireexecdate=OEORERequireExecDate //要求执行日期
	set subObj.oeorerequireexectime=OEORERequireExecTime //要求执行时间
	set subObj.oeoreexecfinishdate=OEOREExEnDate //要求结束日期
	set subObj.oeoreexecfinishtime=OEOREExEnTime //要求结束时间
	set subObj.updatedate=$zd(+$h,3)      //时间戳
	set subObj.updatetime=$zt($p($h,",",2))   //时间戳
	set subObj.oeorehosexecid=ordExecRowId //院内执行记录id
	set subObj.oeorerelexecid=businessfieldcode_"_"_ordExecRowId //业务域_院内执行记录id
	set subObj.oeorirelorderitemid=businessfieldcode_"_"_ordRowId
	set subObj.papatrelpatientid=businessfieldcode_"_"_patID //业务域_院内患者id
	set subObj.paadmrelvisitnumber=businessfieldcode_"_"_admRowId         //业务域_院内就诊号
	quit subObj
}

/// Creator：WuXianPu
/// CreatDate：2016—05-31
/// Description：获取医嘱信息
/// Table：
/// Input：医嘱号
/// Return：医嘱信息
/// Others: w ##class(web.DHCENS.STBLL.CDRJSONV2.OEOrder.Method.OrdexecInfo).OEOrdItem("1||1")
ClassMethod OEOrdItem(ordRowId As %String) As web.DHCENS.STBLL.ORDER.MODEL.OEOrdItem
{
	set $zt="Exception"
	set tSC=0
	set ord = $P(ordRowId,"||",1)
	set sub = $P(ordRowId,"||",2)
	set ChildOEOrdItemObj=##class(web.DHCENS.STBLL.ORDER.MODEL.OEOrdItem).%New()	
	set ordstr1 = $g(^OEORD(ord,"I",sub,1))
	set ordstr2 = $g(^OEORD(ord,"I",sub,2))
	set ordstr3 = $g(^OEORD(ord,"I",sub,3))
	set ordstr7 = $g(^OEORD(ord,"I",sub,7))
	set ordstr9 = $g(^OEORD(ord,"I",sub,9))
    set arcimId = $P(ordstr1,"^",2)
    set arcSub = $P(arcimId,"||",1)
    set arcVer = $P(arcimId,"||",2)
	set admRowId=$p($g(^OEORD(ord)),"^",1)
	set AdmDeptRowID=$P($g(^PAADM(admRowId)),"^",4)    
	set hopitalId=$p($g(^CTLOC(AdmDeptRowID)),"^",22)
	set:hopitalId'="" ChildOEOrdItemObj.HospitalCode=$p($g(^CT("HOSP",hopitalId)),"^",1)	
	set ChildOEOrdItemObj.OEORIOrderItemID=ordRowId
	set ChildOEOrdItemObj.OEORIOEORIDR=""
	set ChildOEOrdItemObj.OEORIARCItmMastCode=$p($g(^ARCIM(arcSub,arcVer,1)),"^",1)
	set ChildOEOrdItemObj.OEORIARCItmMastDesc=$p($g(^ARCIM(arcSub,arcVer,1)),"^",2)
	set ordTypeRowID = $P(ordstr1,"^",8)
	if ordTypeRowID'="" {
		set ChildOEOrdItemObj.OEORIPriorityCode=$P($g(^OECPR(ordTypeRowID)),"^",1)
		set ChildOEOrdItemObj.OEORIPriorityDesc=$P($g(^OECPR(ordTypeRowID)),"^",2)
	}
    set ordStatusRowID = $P(ordstr1,"^",13)   
    if ordStatusRowID'="" { 
		set ChildOEOrdItemObj.OEORIStatusCode=$p($g(^OEC("OSTAT",ordStatusRowID)),"^",1)
		set ChildOEOrdItemObj.OEORIStatusDesc=$p($g(^OEC("OSTAT",ordStatusRowID)),"^",2)
    }
    set OrdSubCatRowID = $p($g(^ARCIM(arcSub,arcVer,1)),"^",10)
    if (OrdSubCatRowID '= "")                              //add by lipan 20160725
    {
	    //医嘱大类信息
		set OrdCatRowID = $p($g(^ARC("IC",OrdSubCatRowID)),"^",8)
    	if (OrdCatRowID '= "")
    	{
	    	set ChildOEOrdItemObj.OEORIClass = $p($g(^OEC("ORCAT",OrdCatRowID)),"^",1)
	    	set ChildOEOrdItemObj.OEORIClassDesc = $p($g(^OEC("ORCAT",OrdCatRowID)),"^",2)  
    	}
    }
	set ChildOEOrdItemObj.OEORIPrescNo=$p(ordstr1,"^",14)
	set pHCDFRowID = $p($g(^ARCIM(arcSub,arcVer,1)),"^",12)	
	if pHCDFRowID'="" {
		set formId=$p($g(^PHCD(+pHCDFRowID,"DF",$p(pHCDFRowID,"||",2),1)),"^",1)
		if formId'="" {
			set ChildOEOrdItemObj.OEORIDoseFormsCode=$p($g(^PHCF(formId)),"^",1)
			set ChildOEOrdItemObj.OEORIDoseFormsDesc=$p($g(^PHCF(formId)),"^",2)
		}
	}	
	set OEORIDoseQty=$p(ordstr2,"^",1)
	set ChildOEOrdItemObj.OEORIDoseQty=$tr(OEORIDoseQty,"/","")
	set dosageUnitRowID = $P(ordstr2,"^",3)
	if ((dosageUnitRowID'="")&&(dosageUnitRowID'=0)) {
		set ChildOEOrdItemObj.OEORIDoseUnitCode=$p($g(^CT("UOM",dosageUnitRowID)),"^",1)
		set ChildOEOrdItemObj.OEORIDoseUnitDesc=$p($g(^CT("UOM",dosageUnitRowID)),"^",2)
	}
	set freqRowID = $P(ordstr2,"^",4)
	if freqRowID'="" {
		set ChildOEOrdItemObj.OEORIFreqCode=$P($g(^PHCFR(freqRowID)),"^",1)
		set ChildOEOrdItemObj.OEORIFreqDesc=$P($g(^PHCFR(freqRowID)),"^",4)
	}
	set instrID=$p(ordstr2,"^",7)
	if ((instrID'="")&&(instrID'=0)) {
		set ChildOEOrdItemObj.OEORIInstrCode=$p($g(^PHCIN(instrID)),"^",1)
		set ChildOEOrdItemObj.OEORIInstrDesc=$p($g(^PHCIN(instrID)),"^",2)
	}
	set useDaysRowID = $P(ordstr2,"^",6)
	if useDaysRowID'="" {
		set ChildOEOrdItemObj.OEORIDurationCode=$P($g(^PHCDU(useDaysRowID)),"^",1)
		set ChildOEOrdItemObj.OEORIDurationDesc=$P($g(^PHCDU(useDaysRowID)),"^",3)
	}
	set OEORIOrderQty=$p(ordstr9,"^",4)
	if OEORIOrderQty="" {
		set ChildOEOrdItemObj.OEORIOrderQty=0	;$p(ordstr9,"^",4) ;
	}
	else {
		set ChildOEOrdItemObj.OEORIOrderQty=OEORIOrderQty
	}
	
	set OEORIResultStatus=$p(ordstr1,"^",5)
	if OEORIResultStatus'="" {
		set resultStatusRowId=$o(^OEC("RESST",0,"Code",$$ALPHAUP^SSUTIL4(OEORIResultStatus),""))
		set ChildOEOrdItemObj.OEORIResultStatusCode=OEORIResultStatus
		set:resultStatusRowId'="" ChildOEOrdItemObj.OEORIResultStatusDesc=$p($g(^OEC("RESST",resultStatusRowId)),"^",2)
	}
	set OEORIRemarks=$g(^OEORD(ord,"I",sub,"DEP",1))
	set ChildOEOrdItemObj.OEORIRemarks=$tr(OEORIRemarks," ","")
	set docRowID = $P(ordstr1,"^",11)
	if docRowID'="" {
		set userId=$o(^SSU("SSUSR",0,"CTPCP",docRowID,""))	
		if userId'="" {
			set ChildOEOrdItemObj.OEORIEnterDocCode=$p($g(^SSU("SSUSR",userId)),"^",1)
			set ChildOEOrdItemObj.OEORIEnterDocDesc=$p($g(^SSU("SSUSR",userId)),"^",2)
		}	
	}
	set verifyDate = $P(ordstr3,"^",7)
	set:verifyDate'="" ChildOEOrdItemObj.OEORIEnterDate=$ZD(verifyDate,3)
	set verifyTime = $P(ordstr1,"^",17)
	set:verifyTime'="" ChildOEOrdItemObj.OEORIEnterTime=$ZT(verifyTime)
	
	set appDeptRowID = $P(ordstr7,"^",2)
	if appDeptRowID'="" {
		set ChildOEOrdItemObj.OEORIEnterDeptCode=$p($g(^CTLOC(appDeptRowID)),"^",1)
		set ChildOEOrdItemObj.OEORIEnterDeptDesc=$p($g(^CTLOC(appDeptRowID)),"^",2)
	}
	set recDeptRowID = $P(ordstr3,"^",6)
	if recDeptRowID'="" {
		set ChildOEOrdItemObj.OEORIExecDeptCode=$p($g(^CTLOC(recDeptRowID)),"^",1)
		set ChildOEOrdItemObj.OEORIExecDeptDesc=$p($g(^CTLOC(recDeptRowID)),"^",2)
	}
	set startDate = $P(ordstr1,"^",9)
	set:startDate'="" ChildOEOrdItemObj.OEORIRequireExecDate=$ZD(startDate,3)
    set startTime = $P(ordstr1,"^",10)
	set:startTime'="" ChildOEOrdItemObj.OEORIRequireExecTime=$ZT(startTime)
	set stopDate=$p(ordstr3,"^",34)
	set:stopDate'="" ChildOEOrdItemObj.OEORIStopDate=$ZD(stopDate,3)
	set stopTime=$p(ordstr2,"^",15)
	set:stopTime'="" ChildOEOrdItemObj.OEORIStopTime=$ZT(stopTime)
	set stopDocId=$p(^OEORD(ord,"I",sub,3),"^",29)
	if stopDocId'="" {
		set userId=$o(^SSU("SSUSR",0,"CTPCP",stopDocId,""))	
		if userId'="" {
			set ChildOEOrdItemObj.OEORIStopDocCode=$p($g(^SSU("SSUSR",userId)),"^",1)
			set ChildOEOrdItemObj.OEORIStopDocDesc=$p($g(^SSU("SSUSR",userId)),"^",2)
		}
	}
	set ChildOEOrdItemObj.OEORIIsSkinTest=$p($g(^OEORD(ord,"I",sub,5)),"^",2)
	set ChildOEOrdItemObj.OEORIISEmergency=$p($g(^OEORD(ord,"I",sub,11)),"^",55)
	
	set ChildOEOrdItemObj.OEORIParentOrderID=$p($g(^OEORD(ord,"I",sub,11)),"^",39)
	set ChildOEOrdItemObj.OEORISpecimenID=$p(ordstr3,"^",20)
	/// 高值耗材条码信息，目前不知如何获取
	
	set ChildOEOrdItemObj.MaterialBarcode=$p($G(^OEORD(ord,"I",sub,"DHC")),"^",14)  //add by lipan
	set ChildOEOrdItemObj.OEORIPrice=..GetPrice(ordRowId)
	set ChildOEOrdItemObj.OEORISpecification=..GetSpec(arcimId)
	set ChildOEOrdItemObj.OEORISpecimenCode=..GetSpecName(ordRowId)
	Quit ChildOEOrdItemObj
Exception
	set ChildOEOrdItemObj=##class(web.DHCENS.STBLL.ORDER.MODEL.OEOrdItem).%New()
	Quit ChildOEOrdItemObj
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

/// Creator：ZhangXinying
/// CreatDate：2020-12-22
/// Description：根据id取医嘱执行记录表(ACC0009) 历史数据Global
/// Table：OE_OrdExec
/// Input：医嘱执行记录rowid
/// Output：
/// Return：数据中心OE_OrdExec医嘱(Global)
/// Others：w ##class(web.DHCENS.STBLL.CDRJSONV2.OEOrder.Method.OrdexecInfo).GetOEOrderExecGlobal("2021-01-01","2021-12-31")
/// w ##class(web.DHCENS.STBLL.CDRJSONV2.OEOrder.Method.OrdexecInfo).GetOEOrderExecGlobal("2022-01-01","2022-02-25")
ClassMethod GetOEOrderExecGlobal(strdate As %String, enddate As %String) As %String
{

	set $zt="Exception" 
	set ^ExportHistoryData("OEOrdExec")=$lb("院内执行记录id","执行开始日期","执行开始时间","剂量","剂量单位","计费数量","简短描述","撤销执行日期","撤销执行时间","执行人代码","执行日期","执行时间","医嘱执行记录状态","要求执行日期","要求执行时间","执行结束日期","执行结束时间","时间戳","时间戳","医嘱明细id","业务域院内患者id")
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.OEOrder.Model.Oeordexec).%New()
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
				continue:$d(^OEORD(ordID,"I",ordSub))=0
				set ordExec=0
				for {
					set ordExec=$o(^OEORD(ordID,"I",ordSub,"X",ordExec))
					quit:ordExec=""
					continue:$d(^OEORD(ordID,"I",ordSub,"X",ordExec))=0
					set ordExecRowId=ordID_"||"_ordSub_"||"_ordExec
					set con=con+1
					set subObj=..Getordexecinfo(ordExecRowId)
					set ^ExportHistoryData("OEOrdExec",ordExecRowId)=$lb(ordExecRowId,subObj.oeoreexecstdate,subObj.oeoreexecsttime,subObj.oeoredoseqty,subObj.oeoredoseunitcode,
																		 subObj.oeoreqtyadmin,subObj.oeoredesc,subObj.oeorexdate,subObj.oeorextime,subObj.oeoreexecusercode,
																		 subObj.oeoredateexecuted,subObj.oeoretimeexecuted,subObj.oeoreadminstatuscode,subObj.oeorerequireexecdate,subObj.oeorerequireexectime,
																		 subObj.oeoreexecfinishdate,subObj.oeoreexecfinishtime,subObj.updatedate,subObj.updatetime,subObj.oeorerelexecid,
																		 subObj.oeorirelorderitemid,subObj.paadmrelvisitnumber, subObj.papatrelpatientid,subObj.businessfieldcode)
																		
					set no=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.StringUtil).point(strdate, enddate, con, OEORIDate)
					}
				}
			}
		}
	quit "Finish   count:"_con
Exception
	quit "-1^"_$ze
}

}
