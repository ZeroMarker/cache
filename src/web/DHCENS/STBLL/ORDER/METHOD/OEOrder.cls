Class web.DHCENS.STBLL.ORDER.METHOD.OEOrder Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2016—05-31
/// Description：获取医嘱信息
/// Table：
/// Input：医嘱号^医嘱号^医嘱号
/// Return：医嘱信息集合
/// Others: 
/// w ##class(web.DHCENS.STBLL.ORDER.METHOD.OEOrder).OEOrder("56403||7")
ClassMethod OEOrder(Input As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.ORDER.MODEL.Request).%New()
	
	set header=##class(web.DHCENS.STBLL.ORDER.MODEL.Header).%New()
	set header.SourceSystem="02"
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set request.header=header
	
	
	set length=$l(Input,"^")
	set OEOrder=##class(web.DHCENS.STBLL.ORDER.MODEL.OEOrder).%New()
	for i=1:1:length {
		set rowId=$p(Input,"^",i)
		set OEOrdItem=##class(web.DHCENS.STBLL.ORDER.MODEL.OEOrdItem).%New()
		set OEOrdItem=..OEOrdItem(rowId)
		d OEOrder.ordItems.Insert(OEOrdItem)
	}
	set body=##class(web.DHCENS.STBLL.ORDER.MODEL.Body).%New()
	set admRowId=$p($g(^OEORD(+Input)),"^",1)
	set patRowId=$p($g(^PAADM(admRowId)),"^",1)
		
	set OEOrder.PAADMVisitNumber=admRowId
	set AdmDeptRowID=$p($g(^PAADM(admRowId)),"^",4)	
	if AdmDeptRowID'=""  {		
		set hopitalId=$p($g(^CTLOC(AdmDeptRowID)),"^",22)
		set:hopitalId'="" OEOrder.HospitalCode=$p($g(^CT("HOSP",hopitalId)),"^",1)
	}	
	set OEOrder.PATPatientID=$p($g(^PAPER(patRowId,"PAT",1)),"^",1)
	set AdmTypeCode=$p($g(^PAADM(admRowId)),"^",2)
	set OEOrder.PAADMEncounterTypeCode=AdmTypeCode

	set OEOrder.UpdateUserCode="demo"
	set OEOrder.UpdateUserDesc="demo"
	set OEOrder.UpdateDate=$ZD(+$H,3)
	set OEOrder.UpdateTime=$ZT($P($H,",",2))	

	set body.oEOrds=OEOrder
	set request.body=body
	d request.XMLExportToStream(.stream)
	q stream
Exception
	set $zt=""
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator：WuXianPu
/// CreatDate：2016—05-31
/// Description：获取医嘱信息
/// Table：
/// Input：医嘱号
/// Return：医嘱信息
/// Others: w ##class(web.DHCENS.STBLL.ORDER.METHOD.OEOrder).OEOrdItem("1||1")
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
	
	set ChildOEOrdItemObj.MaterialBarcode=$p(^OEORD(ord,"I",sub,"DHC"),"^",14)  //add by lipan
	set ChildOEOrdItemObj.OEORIPrice=..GetPrice(ordRowId)
	set ChildOEOrdItemObj.OEORISpecification=..GetSpec(arcimId)
	set ChildOEOrdItemObj.OEORISpecimenCode=..GetSpecName(ordRowId)
	set ChildOEOrdItemObj.OEORIBillStatusCode = $P(ordstr3,"^",5)  
	Quit ChildOEOrdItemObj
Exception
	set $zt=""
	set ChildOEOrdItemObj=##class(web.DHCENS.STBLL.ORDER.MODEL.OEOrdItem).%New()
	Quit ChildOEOrdItemObj
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
	set $zt=""
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
	set AdmID=$p($g(^OEORD(ord)),"^",1)
	q:AdmID="" ""
	set LocDr=$p($g(^PAADM(AdmID)),"^",4)
	q:LocDr="" ""
	set HospDr=$p($g(^CTLOC(LocDr)),"^",22)
	if (CatType="P") {
		s tmpPrice=$p(ordstr3,"^",25)
    	set price = ##CLASS(web.UDHCJFPRICE).GetOrderPrice(EpissubtypeDR,"",arcimId,VerifyDate,"","","",+tmpPrice,HospDr)
	}
	else {
    	set price = ##CLASS(web.UDHCJFPRICE).GetOrderPrice(EpissubtypeDR,"",arcimId,VerifyDate,"","","","",HospDr)
	}
    set TotalPrice=childOrdPrice+price
    Quit TotalPrice
Exception
	set $zt=""
	Quit "价格异常"
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

/// Creator：lyh
/// CreatDate：2016-06-16
/// Description：获取医嘱状态信息
/// Table：
/// Input：医嘱号^医嘱号^医嘱号
/// Return：医嘱状态信息集合
/// Others: 
/// w ##class(web.DHCENS.STBLL.ORDER.METHOD.OEOrder).GetOrdersState("1461||1")
ClassMethod GetOrdersState(Input As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.ORDER.MODEL.Request).%New()
	
	set header=##class(web.DHCENS.STBLL.ORDER.MODEL.Header).%New()
	set header.SourceSystem="02"
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set request.header=header
	
	
	set length=$l(Input,"^")
	set OEOrder=##class(web.DHCENS.STBLL.ORDER.MODEL.OEOrder).%New()
	for i=1:1:length {
		set rowId=$p(Input,"^",i)
		set OEOrdStatus=##class(web.DHCENS.STBLL.ORDER.MODEL.OEOrdStatus).%New()
		set OEOrdStatus=..OEOrdStatus(rowId)
		d OEOrder.ordStatus.Insert(OEOrdStatus)
	}
	set body=##class(web.DHCENS.STBLL.ORDER.MODEL.Body).%New()
	set admRowId=$p($g(^OEORD(+Input)),"^",1)
	set patRowId=$p($g(^PAADM(admRowId)),"^",1)
	set OEOrder.PAADMVisitNumber=admRowId
	set OEOrder.PATPatientID=$p($g(^PAPER(patRowId,"PAT",1)),"^",1)
	
	set AdmDeptRowID=$p($g(^PAADM(admRowId)),"^",4)	
	if AdmDeptRowID'=""  {		
		set hopitalId=$p($g(^CTLOC(AdmDeptRowID)),"^",22)
		set:hopitalId'="" OEOrder.HospitalCode=$p($g(^CT("HOSP",hopitalId)),"^",1)
	}
	set OEOrder.UpdateUserCode="demo"
	set OEOrder.UpdateUserDesc="demo"
	set OEOrder.UpdateDate=$ZD(+$H,3)
	set OEOrder.UpdateTime=$ZT($P($H,",",2))	
	
	set body.oEOrdStatus=OEOrder
	set request.body=body
	d request.XMLExportToStream(.stream)
	d ..InvokeApi(Input)
	q stream
Exception
	set $zt=""
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator：lyh
/// CreatDate：2016-06-16
/// Description：获取单条医嘱状态信息
/// Table：
/// Input：医嘱号
/// Return：单条医嘱状态信息
/// Others: w ##class(web.DHCENS.STBLL.ORDER.METHOD.OEOrder).OEOrdStatus("1||1").XMLExport()
ClassMethod OEOrdStatus(ordRowId As %String) As web.DHCENS.STBLL.ORDER.MODEL.OEOrdStatus
{
	set $zt="Exception"
	set tSC=0
	set ord = $P(ordRowId,"||",1)
	set sub = $P(ordRowId,"||",2)
	set ChildOEOrdItemObj=##class(web.DHCENS.STBLL.ORDER.MODEL.OEOrdStatus).%New()	
	set ordstr1 = $g(^OEORD(ord,"I",sub,1))
	set ordstr2 = $g(^OEORD(ord,"I",sub,2))
	set ordstr3 = $g(^OEORD(ord,"I",sub,3))
	set ordstr7 = $g(^OEORD(ord,"I",sub,7))
	set ordstr11 = $g(^OEORD(ord,"I",sub,11))
    set arcimId = $P(ordstr1,"^",2)
    set arcSub = $P(arcimId,"||",1)
    set arcVer = $P(arcimId,"||",2)
	
	set ChildOEOrdItemObj.OEORIOrderItemID=ordRowId
	set ChildOEOrdItemObj.OEORIParentOrderID=$p(ordstr11,"^",39)
	set ordStatusRowID = $P(ordstr1,"^",13)   
    if ordStatusRowID'="" {
		set ChildOEOrdItemObj.OEORIStatusCode=$p($g(^OEC("OSTAT",ordStatusRowID)),"^",1)
		set OrdSubCatRowID = $p($g(^ARCIM(arcSub,arcVer,1)),"^",10)
	    if (OrdSubCatRowID '= "") {
		    //医嘱子类信息
		    set ChildOEOrdItemObj.OEORIOrdSubCatCode = $p($g(^ARC("IC",OrdSubCatRowID)),"^",1)
		    set ChildOEOrdItemObj.OEORIOrdSubCatDesc = $p($g(^ARC("IC",OrdSubCatRowID)),"^",2)
		    //医嘱大类信息
			set OrdCatRowID = $p($g(^ARC("IC",OrdSubCatRowID)),"^",8)
	    	if (OrdCatRowID '= "") {
		    	set ChildOEOrdItemObj.OEORIOrdCatCode = $p($g(^OEC("ORCAT",OrdCatRowID)),"^",1)
		    	set ChildOEOrdItemObj.OEORIOrdCatDesc = $p($g(^OEC("ORCAT",OrdCatRowID)),"^",2)  
	    	}
	    }
    }
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
	Quit ChildOEOrdItemObj
Exception
	set $zt=""
	set ChildOEOrdItemObj=##class(web.DHCENS.STBLL.ORDER.MODEL.OEOrdStatus).%New()
	Quit ChildOEOrdItemObj
}

/// Creator：ZhangXinying
/// CreatDate：2021—12-02
/// Description：根据医嘱号判断是否为HIS医技专业产品分库模式，分库模式情况下调PACS组方法发送停止医嘱信息
/// Table：
/// Input：医嘱号^医嘱号 118||3
/// Others: 
/// w ##class(web.DHCENS.STBLL.ORDER.METHOD.OEOrder).InvokeApi("1086||216")
ClassMethod InvokeApi(input As %String) As %String
{
	s $zt="Err"
	s OrdList=$p(input,"@",1)
	s OrdLen=$l(OrdList,"^")
	for i=1:1:OrdLen
	{
		s OrdPacs=$p(OrdList,"^",i)
		continue:OrdPacs=""
		s systemType=##Class(web.DHCENS.STBLL.RIS.METHOD.Common).GetSystemType(OrdPacs)
		continue:systemType=""
		s apiSysConfigID=""
		f {
			s apiSysConfigID=$o(^Config.ENS.EnsApiSysConfigI("systemCodeIndex",systemType,apiSysConfigID))
			q:apiSysConfigID=""
			s dbStatus=$lg($g(^Config.ENS.EnsApiSysConfigD(apiSysConfigID)),8)
			continue:dbStatus="N"
			s dbMode=$lg($g(^Config.ENS.EnsApiSysConfigD(apiSysConfigID)),6)
			continue:dbMode="共库"
			s ordHosId=""
			s adm=$p($g(^OEORD(+OrdPacs)),"^",1)
			s:adm'="" admDeptRowID=$p($g(^PAADM(adm)),"^",4)
			s:admDeptRowID'="" hopitalId=$p($g(^CTLOC(admDeptRowID)),"^",22)
			s:hopitalId'="" ordHosId=$p($g(^CT("HOSP",hopitalId)),"^",1)
			s hosId=$lg($g(^Config.ENS.EnsApiSysConfigD(apiSysConfigID)),4)
			continue:hosId'=ordHosId
			if (systemType="US")||(systemType="ES")||(systemType="PACS")||(systemType="RIS")
			{
				set appInfo=##class(web.DHCAPPInterface).GetExaReqContent(OrdPacs)
				set partInfo=$p(appInfo,"^",18)
				if partInfo=""
				{
					s ret=##class(RISService.InvokeRISService).DiscontinueAppInfoEns(OrdPacs)
				}
				else
				{
					s partLen=$l(partInfo,"、") //多部位顿号分割
					f partNum=1:1:partLen
					{
						s partDesc=$p(partInfo,"、",partNum),partID=""
						s:partDesc'="" partID=$o(^DHCAPPART(0,"Desc",partDesc,"0"))
						s ret=##class(RISService.InvokeRISService).DiscontinueAppInfoEns(OrdPacs,"",partID)
					}
				}
			}
		}
	}
	q "0"
Err
	s $zt=""
	q "-1^"_$ze
}

}
