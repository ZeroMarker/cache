Class web.DHCENS.STBLL.RIS.METHOD.GetRisAppInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：Zhanglinyun
/// CreatDate：2019—06-20
/// Description:获取检查申请单信息
/// Table：
/// Input：@医嘱号^医嘱号@发票号 118||3^118||4@发票号
/// w ##class(web.DHCENS.STBLL.RIS.METHOD.GetRisAppInfo).SendAppBillByStudyNoNew("21||3^@11")
ClassMethod SendAppBillByStudyNoNew(input As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set stream=##class(%GlobalCharacterStream).%New()
	quit:input="" stream
	set request=##class(web.DHCENS.STBLL.RIS.MODEL.Request).%New() 
	set header=##class(web.DHCENS.STBLL.RIS.MODEL.Header).%New()
	set header.SourceSystem="02"
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set request.header=header
	set body=##class(web.DHCENS.STBLL.RIS.MODEL.Body).%New()
	set OrRowid=$p($p(input,"@",1),"^",1)
	set AdmDr=$p(^OEORD(+OrRowid),"^",1)
	set PatDr=$P($g(^PAADM(AdmDr)),"^",1)
	set Pat=##class(web.DHCENS.STBLL.EMPI.MODEL.PaPatientNew).%New()
	set Pat=##class(web.DHCENS.STBLL.EMPI.METHOD.Patient).PAPatientByPatId(PatDr)
	set body.PATPatientInfo=Pat
	
	set Adm=##class(web.DHCENS.STBLL.EMPI.MODEL.PAAdmInfo).%New()
	set Adm=##class(web.DHCENS.STBLL.EMPI.METHOD.PAAdm).PAAdmInfoByAdm(AdmDr)
	set body.PATAdmInfo=Adm
	
	set appBill=##class(web.DHCENS.STBLL.RIS.MODEL.RisAppInfoNew).%New()
	set appBill = ..GetAppBillByStudyNoNew(input) //获取申请单对象
	d body.AppBillsNew.Insert(appBill)
	set body.UpdateUserCode="demo"
	set body.UpdateDate=$zd(+$h,3)
	set body.UpdateTime=$zt($p($h,",",2))
	
	set request.body=body
	d request.XMLExportToStream(.stream)
	d ..InvokeApi(input) //判断HIS医技分库模式	
	q stream
Exception
	set $zt=""
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// w ##class(web.DHCENS.STBLL.RIS.METHOD.GetRisAppInfo).GetAppBillByStudyNoNew("6092||3^6092||4")
ClassMethod GetAppBillByStudyNoNew(input As %String) As web.DHCENS.STBLL.RIS.MODEL.RisAppInfoNew
{
	set $zt="Exception"
	s invprtid=$p($p(input,"@",2),"^",1)           //由于门诊结算那里医嘱号添加了发票号，格式转换那里会将发票号带进来，如5531||3@11761^5531||4@11761^5531||5@11761^5531||6@11761^5531||7@11761^5531||8@11761
	s input=$replace(input,"@"_invprtid,"")        //所以替换成空，得到需要的医嘱号串  2019-10-03 hcg
	set OrdIDs=$p(input,"@",1)
    set (RegisterNo,VerifyDate,VerifyTime)=""
	set obj=##class(web.DHCENS.STBLL.RIS.MODEL.RisAppInfoNew).%New()
	set OrdCount=$l(OrdIDs,"^")
	for i=1:1:OrdCount
	{
		set ordObj=##class(web.DHCENS.STBLL.RIS.MODEL.OrderList).%New()
		set OrdID=$p(OrdIDs,"^",i)
		continue:OrdID=""
		set ord = $P(OrdID,"||",1)
		set sub = $P(OrdID,"||",2) 
		set ordstr1 = $g(^OEORD(ord,"I",sub,1))
		set ordstr3 = $g(^OEORD(ord,"I",sub,3)) 
		set ordstr7 = $g(^OEORD(ord,"I",sub,7))
		//开单医生信息
		set DocCode = "",DocDesc=""
    	set DocRowID = $P(ordstr1,"^",11)
		set:DocRowID'="" ordObj.RISRSubmitDocCode= $p($g(^CTPCP(DocRowID,1)),"^",1)
		set:DocRowID'="" ordObj.RISRSubmitDocDesc = $p($g(^CTPCP(DocRowID,1)),"^",2)
 		//医嘱开单日期、时间
    	set VerifyDate = $P(ordstr3,"^",7)
    	set:VerifyDate'="" VerifyDate = $zd(VerifyDate,3)
    	set VerifyTime = $P(ordstr1,"^",17)
    	set:VerifyTime'="" VerifyTime = $zt(VerifyTime)
    	set ordObj.RISRSubmitTime=VerifyDate_" "_VerifyTime
    	//开单科室信息
    	set AppDeptRowID = $P(ordstr7,"^",2)
    	set:AppDeptRowID'="" ordObj.AppDeptDesc=$p($g(^CTLOC(AppDeptRowID)),"^",2) 
    	set:AppDeptRowID'="" ordObj.AppDeptCode=$p($g(^CTLOC(AppDeptRowID)),"^",1) 
    
    	//接收科室信息
    	set RecDeptCode=""
    	set RecDeptRowID = $P(ordstr3,"^",6)
    	set:RecDeptRowID'="" ordObj.RISRAcceptDeptCode= $p($g(^CTLOC(RecDeptRowID)),"^",1) 
    	set:RecDeptRowID'="" ordObj.RISRAcceptDeptDesc= $p($g(^CTLOC(RecDeptRowID)),"^",2) 

		set ordstr1 = $g(^OEORD(ord,"I",sub,1))
		set arcimId = $P(ordstr1,"^",2)
	    set arcSub = $P(arcimId,"||",1)
	    set arcVer = $P(arcimId,"||",2)
		//医嘱项的代码与名称
	    set ArcimCode="",ArcimDesc=""
	    set:arcimId'="" ArcimCode=$p($g(^ARCIM(arcSub,arcVer,1)),"^",1)
	    set:arcimId'="" ArcimDesc=$p($g(^ARCIM(arcSub,arcVer,1)),"^",2)
		set ordObj.RISRCode=ArcimCode
		set ordObj.RISRDesc=ArcimDesc
		set ordObj.OEORIOrderItemID=OrdID
		set ordObj.RISRPrice=..GetPrice(OrdID)  ;..GetArcimFee(arcimId)
		set ordObj.RISRExamID=..GetARRowID(OrdID)
		// 获取申请单内容信息
		set appInfo=##class(web.DHCAPPInterface).GetExaReqContent(OrdID)
		if appInfo'="" {
			set ordObj.RISRAppNum=$p(appInfo,"^",1)
			set ordObj.RISRMattersAttention=$p(appInfo,"^",7)
			set ordObj.RISRSpecalMedicalRecord=$p(appInfo,"^",13)	/// 现病史
			set ordObj.RISRISEmergency=$p(appInfo,"^",6)
			set ordObj.RISRClinicalSymptoms=$p(appInfo,"^",14)
			set ordObj.RISRArExaReqSym=$p(appInfo,"^",15) /// 主述	2019-10-15 wxl
			set ordObj.RISRPatDiag=$p(appInfo,"^",12)	/// 诊断	2019-10-15
			set ordObj.RISRArPurpose=$p(appInfo,"^",7)	/// 检查目的	2019-10-15
			set ordObj.RISRPositionCode=$p(appInfo,"^",18) ///检查部位
		}
		set ordObj.RISRDeptLocation=""
		 //设置医嘱子类信息
    	set OrdSubCatRowID = $p($g(^ARCIM(arcSub,arcVer,1)),"^",10)
     	if (OrdSubCatRowID '= "")
     	{
	    	set ordObj.OrdSubCatCode = $p($g(^ARC("IC",OrdSubCatRowID)),"^",1)
	    	set ordObj.OrdSubCatDesc = $p($g(^ARC("IC",OrdSubCatRowID)),"^",2)
    	}

    	//设置医嘱大类信息
    	set OrdCatRowID = $p($g(^ARC("IC",OrdSubCatRowID)),"^",8)
    	if (OrdCatRowID '= "")
    	{
	    	set ordObj.OrdCatCode = $p($g(^OEC("ORCAT",OrdCatRowID)),"^",1)
	    	set ordObj.OrdCatDesc = $p($g(^OEC("ORCAT",OrdCatRowID)),"^",2)  
    	}
		set ordstr3 = $g(^OEORD(ord,"I",sub,3))
		set OEORIBillStatusCode = $P(ordstr3,"^",5)   
		set ordObj.OrdBillStatus=$Case(OEORIBillStatusCode,"P":"已收费",:"未收费")
		set AdmNo=$p($g(^OEORD(ord)),"^",1)
		set MrAdm=$p($g(^PAADM(AdmNo)),"^",61)
		set PhySiCycleId=$p($g(^MR(MrAdm,"DHC")),"^",9)
		set:PhySiCycleId'="" ordObj.PhysiCycleCode=$p($g(^DHCPHYC(PhySiCycleId)),"^",1) //生理周期代码
		set:PhySiCycleId'="" ordObj.PhysiCycle=$p($g(^DHCPHYC(PhySiCycleId)),"^",2) //生理周期描述
		d obj.OrderList.Insert(ordObj)
	}
    Q obj
Exception
	set $zt=""
	set obj=##class(web.DHCENS.STBLL.RIS.MODEL.RisAppInfoNew).%New()
	q obj
}

/// 通过医嘱RowID获取检查申请单号
/// 入参：医嘱RowID
/// 出参：申请单No
/// w ##class(web.DHCENS.STBLL.RIS.METHOD.GetRisAppInfo).GetARRowID("21||3")
ClassMethod GetARRowID(OEORIRowId)
{
	s ARNo=""
	q:'$d(^DHCAPREP(0,"OrdItem",OEORIRowId)) ""
	
	s ARRowID=$o(^DHCAPREP(0,"OrdItem",OEORIRowId,""))
	q:ARRowID="" ""
	s ARNo=$p(^DHCAPREP(ARRowID),"^",1)
	q ARNo
}

/// Creator：lipan
/// CreatDate：2016—06-17
/// Description:获取检查申请单信息(检查号)
/// Table：
/// Input：检查号^医嘱号   3-127-001^3||128 3-127-001^3||126  3-127-001^3||127   1074-4-001^1074||4
/// w ##class(web.DHCENS.STBLL.RIS.METHOD.GetRisAppInfo).SendAppBillByStudyNo("APPI2019062000002@118||3^118||4")
ClassMethod SendAppBillByStudyNo(input As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	quit:input="" 0
	;set input=$tr(input,"@","^")
	set request=##class(web.DHCENS.STBLL.RIS.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.RIS.MODEL.Header).%New()
	set header.SourceSystem="02"
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set request.header=header
	set body=##class(web.DHCENS.STBLL.RIS.MODEL.Body).%New()
	set OrRowid=$p(input,"^",2)
	set AdmDr=$p(^OEORD(+OrRowid),"^",1)
	set PatDr=$P($g(^PAADM(AdmDr)),"^",1)
	set Pat=##class(web.DHCENS.STBLL.EMPI.MODEL.PaPatient).%New()
	set Pat=##class(web.DHCENS.STBLL.EMPI.METHOD.Patient).PAPatientByPatId(PatDr)
	set body.PATPatientInfo=Pat
	
	set Adm=##class(web.DHCENS.STBLL.EMPI.MODEL.PAAdmInfo).%New()
	set Adm=##class(web.DHCENS.STBLL.EMPI.METHOD.PAAdm).PAAdmInfoByAdm(AdmDr)
	set body.PATAdmInfo=Adm
	
	set appBill=##class(web.DHCENS.STBLL.RIS.MODEL.RisAppInfo).%New()
	set appBill = ..GetAppBillByStudyNo(input) //获取申请单对象
	
	d body.AppBills.Insert(appBill)
	
	set request.body=body
	d request.XMLExportToStream(.stream)
	q stream
Exception
	set $zt=""
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator：WuXianPu
/// CreatDate：2016—08-16
/// Description:获取检查申请单信息(医嘱号)
/// Table：
/// Input：医嘱号^医嘱号
/// w ##class(web.DHCENS.STBLL.RIS.METHOD.GetRisAppInfo).SendAppBillByOrdRowId("118||3^118||4")
ClassMethod SendAppBillByOrdRowId(input As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	quit:input="" 0
	set request=##class(web.DHCENS.STBLL.RIS.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.RIS.MODEL.Header).%New()
	set header.SourceSystem="02"
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set request.header=header
	set body=##class(web.DHCENS.STBLL.RIS.MODEL.Body).%New()
	
	set OrRowid=$p(input,"^",1)
	set AdmDr=$p(^OEORD(+OrRowid),"^",1)
	set PatDr=$P($g(^PAADM(AdmDr)),"^",1)
	set Pat=##class(web.DHCENS.STBLL.EMPI.MODEL.PaPatient).%New()
	set Pat=##class(web.DHCENS.STBLL.EMPI.METHOD.Patient).PAPatientByPatId(PatDr)
	set body.PATPatientInfo=Pat
	
	set Adm=##class(web.DHCENS.STBLL.EMPI.MODEL.PAAdmInfo).%New()
	set Adm=##class(web.DHCENS.STBLL.EMPI.METHOD.PAAdm).PAAdmInfoByAdm(AdmDr)
	set body.PATAdmInfo=Adm
		
	set length=$l(input,"^")
	for i=1:1:length {
		set appBill=##class(web.DHCENS.STBLL.RIS.MODEL.RisAppInfo).%New()
		set appBill = ..GetAppBillByOrdRowId($p(input,"^",i)) //获取申请单对象
		d body.AppBills.Insert(appBill)
	}
	
	set request.body=body
	d request.XMLExportToStream(.stream)
	q stream
Exception
	set $zt=""
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

ClassMethod GetAppBillByStudyNo(input As %String) As web.DHCENS.STBLL.RIS.MODEL.RisAppInfo
{
	set StudyNo=$p(input,"^",1)
	set OrdID=$p(input,"^",2)
    set (RegisterNo,AdmNo,DocCode,VerifyDate,VerifyTime)=""
    set (RecDeptCode)=""
	s obj=##class(web.DHCENS.STBLL.RIS.MODEL.RisAppInfo).%New()
	
	set ord = $P(OrdID,"||",1)
	set sub = $P(OrdID,"||",2)	
	set ordstr1 = $g(^OEORD(ord,"I",sub,1))
	set ordstr3 = $g(^OEORD(ord,"I",sub,3))	
	set ordstr7 = $g(^OEORD(ord,"I",sub,7))
	//开单医生信息
	set DocCode = "",DocDesc=""
    set DocRowID = $P(ordstr1,"^",11)
	set:DocRowID'="" DocCode = $p($g(^CTPCP(DocRowID,1)),"^",1)
	set:DocRowID'="" DocDesc = $p($g(^CTPCP(DocRowID,1)),"^",2)
 	//医嘱开单日期、时间
    set VerifyDate = $P(ordstr3,"^",7)
    set:VerifyDate'="" VerifyDate = $zd(VerifyDate,3)
    set VerifyTime = $P(ordstr1,"^",17)
    set:VerifyTime'="" VerifyTime = $zt(VerifyTime)
    
    //开单科室信息
    set AppDeptRowID = $P(ordstr7,"^",2)
    set:AppDeptRowID'="" obj.AppDeptDesc=$p($g(^CTLOC(AppDeptRowID)),"^",2)   
    
    //接收科室信息
    set RecDeptCode=""
    set RecDeptRowID = $P(ordstr3,"^",6)
    set:RecDeptRowID'="" RecDeptCode = $p($g(^CTLOC(RecDeptRowID)),"^",1)    
    set arcimId = $P(ordstr1,"^",2)
    set arcSub = $P(arcimId,"||",1)
    set arcVer = $P(arcimId,"||",2)
    //医嘱项的代码与名称
    set ArcimCode="",ArcimDesc=""
    set:arcimId'="" ArcimCode=$p($g(^ARCIM(arcSub,arcVer,1)),"^",1)
    set:arcimId'="" ArcimDesc=$p($g(^ARCIM(arcSub,arcVer,1)),"^",2)
	set Ret=..GetPatNoByOrderID(OrdID)
	set RegisterNo=$p(Ret,"^",2)
	set AdmNo=$p(Ret,"^",3)
	set regId="" for  set regId=$o(^DHCPACRegInfoi("StudyNo",StudyNo,regId)) q:regId=""  d
	.set OEORIDR=$p(^DHCPACRegInfo(regId),"^",11)
	.Quit:OEORIDR'=OrdID
	.set childId="" for  set childId=$o(^DHCPACRegInfoBD("BODYPARTS",0,regId,childId)) q:childId=""  d
	..// User.DHCAppPart 检查部位字典表
	..set bodyPartInfo=$g(^DHCPACRegInfoBD("BODYPARTS",0,regId,childId))
	..set ordObj=##class(web.DHCENS.STBLL.RIS.MODEL.Order).%New()
	..set ordObj.OEORIOrderItemID=OrdID_"||"_$p(bodyPartInfo,"^",1)
	..set ordObj.RISRPositionCode=$p(bodyPartInfo,"^",2)
	..set ordObj.RISRPostureCode=""
	..set ordObj.RISRCode=ArcimCode
	..set ordObj.RISRDesc=ArcimDesc
	..set ordObj.RISRPrice=..GetArcimFee(arcimId)
	..d obj.OrderList.Insert(ordObj)
	.if obj.OrderList.Count()=0  d
	..set ordObj=##class(web.DHCENS.STBLL.RIS.MODEL.Order).%New()
	..set ordObj.RISRCode=ArcimCode
	..set ordObj.RISRDesc=ArcimDesc
	..set ordObj.OEORIOrderItemID=OrdID
	..set ordObj.RISRPrice=..GetArcimFee(arcimId)
	..d obj.OrderList.Insert(ordObj)
	
	if obj.OrderList.Count()=0  d
	.set ordObj=##class(web.DHCENS.STBLL.RIS.MODEL.Order).%New()
	.set ordObj.RISRCode=ArcimCode
	.set ordObj.RISRDesc=ArcimDesc
	.set ordObj.OEORIOrderItemID=OrdID
	.set ordObj.RISRPrice=..GetArcimFee(arcimId)
	.d obj.OrderList.Insert(ordObj)
	
	set obj.Input=$tr(input,"^","@")
	set obj.RISRExamID=StudyNo
	set obj.PATPatientID=RegisterNo
	set obj.PAADMVisitNumber=AdmNo
	set obj.PAADMEncounterTypeCode=$P($g(^PAADM(AdmNo)),"^",2)
	s TmpStr=..GetLocInfo(AdmNo)
	s obj.PAADMAdmWardCode=$p(TmpStr,"^",1)
	s obj.PAADMAdmWardDesc=$p(TmpStr,"^",2)
	s obj.PAADMCurBedNo=$p(TmpStr,"^",3)
	// 获取申请单内容信息
	set appInfo=##class(web.DHCAPPInterface).GetExaReqContent(OrdID)
	if appInfo'="" {
		set obj.RISRAppNum=$p(appInfo,"^",1)
		set obj.RISRMattersAttention=$p(appInfo,"^",7)
		set obj.RISRSpecalMedicalRecord=$p(appInfo,"^",13)
		set obj.RISRISEmergency=$p(appInfo,"^",6)
		set obj.RISRClinicalSymptoms=$p(appInfo,"^",14)
	}
	
	set obj.RISRSubmitDocCode=DocCode
	set obj.RISRSubmitDocDesc=DocDesc
	set obj.RISRSubmitTime=VerifyDate_" "_VerifyTime
	set obj.RISRAcceptDeptCode=RecDeptCode
	set obj.RISRDeptLocation=""
	set obj.UpdateUserCode="demo"
	set obj.UpdateDate=$zd(+$h,3)
	set obj.UpdateTime=$zt($p($h,",",2))
    Q obj
}

/// w ##class(web.DHCENS.STBLL.RIS.METHOD.GetRisAppInfo).GetAppBillByOrdRowId("15624||32")
ClassMethod GetAppBillByOrdRowId(input As %String) As web.DHCENS.STBLL.RIS.MODEL.RisAppInfo
{
	set $zt="Exception"

	set OrdID=$p(input,"^",1)
    set (RegisterNo,AdmNo,DocCode,VerifyDate,VerifyTime)=""
    set (RecDeptCode)=""
	set obj=##class(web.DHCENS.STBLL.RIS.MODEL.RisAppInfo).%New()
	
	set ord = $P(OrdID,"||",1)
	set sub = $P(OrdID,"||",2)	
	set ordstr1 = $g(^OEORD(ord,"I",sub,1))
	set ordstr3 = $g(^OEORD(ord,"I",sub,3))	
	set ordstr7 = $g(^OEORD(ord,"I",sub,7))
	//开单医生信息
	set DocCode = "",DocDesc=""
    set DocRowID = $P(ordstr1,"^",11)
	set:DocRowID'="" DocCode = $p($g(^CTPCP(DocRowID,1)),"^",1)
	set:DocRowID'="" DocDesc = $p($g(^CTPCP(DocRowID,1)),"^",2)
 	//医嘱开单日期、时间
    set VerifyDate = $P(ordstr3,"^",7)
    set:VerifyDate'="" VerifyDate = $zd(VerifyDate,3)
    set VerifyTime = $P(ordstr1,"^",17)
    set:VerifyTime'="" VerifyTime = $zt(VerifyTime)
    
    //开单科室信息
    set AppDeptRowID = $P(ordstr7,"^",2)
    set:AppDeptRowID'="" obj.AppDeptDesc=$p($g(^CTLOC(AppDeptRowID)),"^",2)   
    
    //接收科室信息
    set RecDeptCode=""
    set RecDeptRowID = $P(ordstr3,"^",6)
    set:RecDeptRowID'="" RecDeptCode = $p($g(^CTLOC(RecDeptRowID)),"^",1)    
    set arcimId = $P(ordstr1,"^",2)
    set arcSub = $P(arcimId,"||",1)
    set arcVer = $P(arcimId,"||",2)
    //医嘱项的代码与名称
    set ArcimCode="",ArcimDesc=""
    set:arcimId'="" ArcimCode=$p($g(^ARCIM(arcSub,arcVer,1)),"^",1)
    set:arcimId'="" ArcimDesc=$p($g(^ARCIM(arcSub,arcVer,1)),"^",2)
	set Ret=..GetPatNoByOrderID(OrdID)
	set RegisterNo=$p(Ret,"^",2)
	set AdmNo=$p(Ret,"^",3)	
	set obj.Input=$tr(input,"^","@")
	set obj.RISRExamID=OrdID
	set obj.PATPatientID=RegisterNo
	set obj.PAADMVisitNumber=AdmNo
	
	set AdmDeptRowID=$p($g(^PAADM(AdmNo)),"^",4)	
	if AdmDeptRowID'=""  {		
		set hopitalId=$p($g(^CTLOC(AdmDeptRowID)),"^",22)
		set:hopitalId'="" obj.HospitalCode=$p($g(^CT("HOSP",hopitalId)),"^",1)
	}	
	
	set obj.PAADMEncounterTypeCode=$P($g(^PAADM(AdmNo)),"^",2)
	set TmpStr=..GetLocInfo(AdmNo)
	set obj.PAADMAdmWardCode=$p(TmpStr,"^",1)
	set obj.PAADMAdmWardDesc=$p(TmpStr,"^",2)
	set obj.PAADMCurBedNo=$p(TmpStr,"^",3)
	
	// 获取申请单内容信息
	set appInfo=##class(web.DHCAPPInterface).GetExaReqContent(OrdID)
	if appInfo'="" {
		set obj.RISRAppNum=$p(appInfo,"^",1)
		set obj.RISRMattersAttention=$p(appInfo,"^",7)
		set obj.RISRSpecalMedicalRecord=$p(appInfo,"^",13)
		set obj.RISRISEmergency=$p(appInfo,"^",6)
		set obj.RISRClinicalSymptoms=$p(appInfo,"^",14)
		
		set bodyPartInfo=$p(appInfo,"^",19)
		set length=$l(bodyPartInfo,"！")
		for i=1:1:length {
			set bodypart=$p(bodyPartInfo,"！",i)
			continue:bodypart=""
			set ordObj=##class(web.DHCENS.STBLL.RIS.MODEL.Order).%New()
			set ordObj.OEORIOrderItemID=OrdID_"||"_$p(bodypart,":",1)
			set ordObj.RISRPositionCode=$p(bodypart,":",1)
			set ordObj.RISRPostureCode=""
			set ordObj.RISRCode=$p(appInfo,"^",16)
			set ordObj.RISRDesc=$p(appInfo,"^",17)
			d obj.OrderList.Insert(ordObj)
		}
		
		/*->增加非循环结构,暂时解决两层循环结构数据绑定问题20160820 chenjiang*/
		set:bodypart'="" obj.OEORIOrderItemID=OrdID_"||"_$p(bodypart,":",1)
		set:bodypart="" obj.OEORIOrderItemID=OrdID
		set obj.RISRPositionCode=$p(bodypart,":",1)
		set obj.RISRPostureCode=""
		set obj.RISRCode=$p(appInfo,"^",16)
		set obj.RISRDesc=$p(appInfo,"^",17)
		
		if obj.OrderList.Count()=0  {
			set ordObj=##class(web.DHCENS.STBLL.RIS.MODEL.Order).%New()
			set ordObj.RISRCode=$p(appInfo,"^",16)
			set ordObj.RISRDesc=$p(appInfo,"^",17)
			set ordObj.OEORIOrderItemID=OrdID
			d obj.OrderList.Insert(ordObj)
		}
	}else{
		/*->增加非循环结构,暂时解决两层循环结构数据绑定问题20160820 chenjiang*/
		set obj.OEORIOrderItemID=OrdID
		set obj.RISRPositionCode=""
		set obj.RISRPostureCode=""
		set obj.RISRCode=ArcimCode
		set obj.RISRDesc=ArcimDesc
	}
	
	
	if obj.OrderList.Count()=0  {
		set ordObj=##class(web.DHCENS.STBLL.RIS.MODEL.Order).%New()
		set ordObj.RISRCode=ArcimCode
		set ordObj.RISRDesc=ArcimDesc
		set ordObj.OEORIOrderItemID=OrdID
		d obj.OrderList.Insert(ordObj)
	}
	set obj.RISRSubmitDocCode=DocCode
	set obj.RISRSubmitDocDesc=DocDesc
	set obj.RISRSubmitTime=VerifyDate_" "_VerifyTime
	set obj.RISRAcceptDeptCode=RecDeptCode
	set obj.RISRDeptLocation=""
	set obj.UpdateUserCode="demo"
	set obj.UpdateDate=$zd(+$h,3)	
	set obj.UpdateTime=$zt($p($h,",",2))
	set MrAdm=$p($g(^PAADM(AdmNo)),"^",61)
	set PhySiCycleId=$p($g(^MR(MrAdm,"DHC")),"^",9)
	set:PhySiCycleId'="" obj.PhysiCycleCode=$p($g(^DHCPHYC(PhySiCycleId)),"^",1) //生理周期代码
	set:PhySiCycleId'="" obj.PhysiCycle=$p($g(^DHCPHYC(PhySiCycleId)),"^",2) //生理周期描述
    Q obj
Exception
	set $zt=""
	set obj=##class(web.DHCENS.STBLL.RIS.MODEL.RisAppInfo).%New()
    Q obj
}

/// 通过医嘱号得到病人Rowid^登记号^就诊号
ClassMethod GetPatNoByOrderID(OrderID As %String) As %String
{
	q:OrderID="" ""
	s adm=$p($g(^OEORD(+OrderID)),"^",1)
	s RegisterNo="",patId=""
	i (adm'="") {
		s patId=$p(^PAADM(adm),"^",1)
		s RegisterNo=$p($g(^PAPER(patId,"PAT",1)),"^",1)
	}
	s Ret=patId_"^"_RegisterNo_"^"_adm
	q Ret
}

ClassMethod GetItemInfoDesc(OrditemRowid As %String) As %String
{
	s AppRowid=$o(^DHCRBAppOrdi(0,OrditemRowid,0))
	s ItemInfo=""
	i AppRowid'="" {
		s tItemInfo=$g(^DHCRBApp("Bill",AppRowid,"ItemInfo"))
		s count=$l(tItemInfo,"^")
		for i=1:1:count	{
			s tempItemInfo=""
			s pItemInfo=$p(tItemInfo,"^",i)
			s ItemName=$p(pItemInfo,$c(2),1) 
			s pItemInfo=$p(tItemInfo,"^",i)
			s ItemResult=$p(pItemInfo,$c(2),2)
			s ItemResult=$tr(ItemResult,"&","")
			s ItemResult=$tr(ItemResult,"^","")
			s tempItemInfo=ItemName_"&"_ ItemResult
			i ItemInfo="" d
			.s ItemInfo=tempItemInfo
			e  d
			.s ItemInfo=ItemInfo_"^"_tempItemInfo
		}
	}
	q ItemInfo
}

ClassMethod GetPatientNowInfo(ordRowid As %String) As %String
{
	set PatientNow = ""
	
	if ($D(^DHCRBAppi("OrdRowid",ordRowid))){
		set AppRowid = $o(^DHCRBAppi("OrdRowid",ordRowid,""))
	    s Info=$g(^DHCRBApp("Bill",AppRowid,"XMLContent"))
	    s PatientInfo=$p(Info,"<PatientNow>",2)
	    s PatientNow=$p(PatientInfo,"</PatientNow>",1)
	    
	    set PatientNow = $tr(PatientNow,$char(13),"")
	    set PatientNow = $tr(PatientNow,$char(10),"")
	}
	q PatientNow
}

ClassMethod GetAppBodyPart(ordRowid As %String) As %String
{
	set bodyPart = ""
	set posture=""
	if ($D(^DHCRBAppi("OrdRowid",ordRowid))) {
		set AppRowid = $o(^DHCRBAppi("OrdRowid",ordRowid,""))
	
	    s Info=^DHCRBApp("Bill",AppRowid,"XMLContent")
	    s bodyPartInfo=$p(Info,"<SelBodyPart>",2)
	    s bodyPart=$p(bodyPartInfo,"</SelBodyPart>",1)
	}
	set posture=$p($g(^DHCRISAPPINFOS("APPLICATIONBILL",ordRowid)),"^",4)
	set OtherPosture=$p($g(^DHCRISAPPINFOS("APPLICATIONBILL",ordRowid)),"^",2)
	if ((posture'="") && (OtherPosture="")) {
		s bodyPart=bodyPart_"("_posture_")"
	}
	elseif ((posture'="") && (OtherPosture'="")){
		s bodyPart=bodyPart_"("_posture_$p(OtherPosture,"&",2)_")"
	}
	elseif ((posture="") && (OtherPosture'="&")){
		s bodyPart=bodyPart_"("_$p(OtherPosture,"&",2)_")"
	}
	q bodyPart
}

/// w ##class(web.DHCENS.STBLL.RIS.METHOD.GetRisAppInfo).GetLocInfo("3")
ClassMethod GetLocInfo(admRowid As %String) As %String
{
	set TRANSChildsub="",AdmDeptRowID="",TmpDeptRowID="",Bed=""
	set AdmWardCode="",AdmWardRowID="",AdmWardDesc="",PATBed="",AdmWardCode="",AdmWardDesc=""
	f  s TRANSChildsub=$o(^PAADM(admRowid,"TRANS",TRANSChildsub)) q:(TRANSChildsub="")!(Bed'="")  d
	.s Bed=$p($g(^PAADM(admRowid,"TRANS",TRANSChildsub)),"^",8)
	.s TmpDeptRowID=$p($g(^PAADM(admRowid,"TRANS",TRANSChildsub)),"^",6)
	.s AdmWardRowID=$p($g(^PAADM(admRowid,"TRANS",TRANSChildsub)),"^",9)
	.if TmpDeptRowID'=""  d
	..s AdmDeptRowID=TmpDeptRowID
	if AdmWardRowID'="" 
	{
		set AdmWardCode=$p($g(^PAWARD(admRowid)),"^",1)
		set AdmWardDesc=$p($g(^PAWARD(admRowid)),"^",2)
	}
	s CurrentBedRowID=$P($g(^PAADM(admRowid)),"^",73)
	i ($d(CurrentBedRowID)'=0)&&(CurrentBedRowID'="")&&($l(CurrentBedRowID,"||")>1) {
		s BedWordRowID = $p(CurrentBedRowID,"||",1)
		s BedChildSub = $p(CurrentBedRowID,"||",2)
		i $d(^PAWARD(BedWordRowID,"BED"))=10 {
			set PATBed=$p($g(^PAWARD(BedWordRowID,"BED",BedChildSub)),"^",1)
		}
	}
	
	q AdmWardCode_"^"_AdmWardDesc_"^"_PATBed
}

ClassMethod GetArcimFee(ArcimRowid) As %String
{
	s itmprice=""
	s OLTStartDate="" f  s OLTStartDate=$o(^DHCOLT(0,"ARCIM",ArcimRowid,"Z",OLTStartDate)) q:OLTStartDate=""  d
	.s OLTRowId="" f  s OLTRowId=$o(^DHCOLT(0,"ARCIM",ArcimRowid,"Z",OLTStartDate,OLTRowId))  q:OLTRowId=""  d
	..s OLTEndDate=$p(^DHCOLT(OLTRowId),"^",5)
	..q:(OLTEndDate<=+$h)&&($g(OLTEndDate)'="")
	..s TariffDR=$p(^DHCOLT(OLTRowId),"^",2)
	..s itmnum=$p(^DHCOLT(OLTRowId),"^",3)
	..q:TariffDR=""
	..s itmname=$p($g(^DHCTARI(TariffDR)),"^",2)
	..s itmcode=$p($g(^DHCTARI(TariffDR)),"^",1)
	..s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","")
	..s itmprice=$j($p(itmpricetmp,"^",1),3,2)
	quit itmprice
}

ClassMethod GetPatOrdList(inputContent As %GlobalCharacterStream) As %GlobalCharacterStream
{
	s $zt="Err"
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(inputContent,.tDocument)
	if $$$ISERR(tSC) {
		Quit "-1^"_tSC
	}else{
		set tSC=tDocument.EvaluateExpression("/Request/Body/PATCardNo","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set PATCardNo=tRes.GetAt(1).Value							
			set PATCardNo=$tr(PATCardNo,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/PATCardType","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set PATCardType=tRes.GetAt(1).Value							
			set PATCardType=$tr(PATCardType,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/StartDate","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set StartDate=tRes.GetAt(1).Value							
			set StartDate=$tr(StartDate,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/EndDate","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set EndDate=tRes.GetAt(1).Value							
			set EndDate=$tr(EndDate,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/PAADMTypeCode","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set PAADMTypeCode=tRes.GetAt(1).Value							
			set PAADMTypeCode=$tr(PAADMTypeCode,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/RISRAcceptDept","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set RISRAcceptDept=tRes.GetAt(1).Value							
			set RISRAcceptDept=$tr(RISRAcceptDept,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/OEORIStatusCode","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set OEORIStatusCode=tRes.GetAt(1).Value							
			set OEORIStatusCode=$tr(OEORIStatusCode,$c(0),"")
		}
	}
	
	Set stream=..GetPatOrdListByCard(PATCardNo,PATCardType,StartDate,EndDate,PAADMTypeCode,RISRAcceptDept)
	q stream
Err
	s $zt=""
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	q stream
}

ClassMethod GetPatOrdListByCard(CardValue As %String, CardTypes As %String, StartDate As %String, EndDate As %String, EpsiodeType As %String, ExeLoc As %String) As %GlobalCharacterStream
{
	s MainObj=##class(web.DHCENS.STBLL.RIS.MODEL.RisAppInfoNew).%New()
	if (CardTypes=1)
	{
		s Length=$L(CardValue,"^")
		for i=1:1:Length
		{
			s TmpRowid=$p(CardValue,"^",i)
			s insObj=..GetAppBillByOrdRowId(TmpRowid)
			d MainObj.OrderList.Insert(insObj)
		}
		Quit MainObj
	}
	elseif (CardTypes=2)
	{
		set RegisterNo=CardValue
	}
	elseif (CardTypes=3)
	{
		i ('($d(^DHCCARDi("CF",0,"CardNo",CardValue)))!(CardValue=""))
		{
			q MainObj
		}
		// 通过就诊卡号得到病人登记号
		s RegisterNo=##class(web.DHCENS.Util.Common).GetRegNoByCardNo(CardValue)
	}
	elseif (CardTypes=4)
	{	
		i ('($d(^PAPERi("Medicare1",$$ALPHAUP^SSUTIL4(CardValue)))!(CardValue="")))
		{
			q MainObj
		}
		set PAPMIRowId=$o(^PAPERi("Medicare1",$$ALPHAUP^SSUTIL4(CardValue),""))
		s RegisterNo=$p($g(^PAPER(PAPMIRowId,"PAT",1)),"^",1)
	}
	elseif (CardTypes=5)
	{
		q MainObj
	}
	elseif (CardTypes=6)
	{	
		i ('($d(^PAADMi("No",$$ALPHAUP^SSUTIL4(CardValue)))!(CardValue="")))
		{
			q MainObj
		}
		s PAADMDr=$o(^PAADMi("No",$$ALPHAUP^SSUTIL4(CardValue),0))
		set PAPMIRowId=$p($g(^PAADM(PAADMDr)),"^",1)
		s RegisterNo=$p($g(^PAPER(PAPMIRowId,"PAT",1)),"^",1)
	}
	
	if (RegisterNo'="")
	{
		s MainObj=..GetPatOrdListByPatID(RegisterNo,StartDate,EndDate,ExeLoc,EpsiodeType)
	}
	
	if (CardTypes="")&&(CardValue="")&&(ExeLoc'="")
	{
		s StartDate=$zdh(StartDate,3)
		s EndDate=$zdh(EndDate,3)
		s OeRowId=""
		f date=StartDate:1:EndDate d
		.f  s OeRowId=$o(^OEORDi(0,"StDt",date,OeRowId)) q:OeRowId=""  d
		..s SubId=""
		..f  s SubId=$o(^OEORDi(0,"StDt",date,OeRowId,SubId)) q:SubId=""  d
		...s ordid=OeRowId_"||"_SubId
		...s BillState=$p($g(^OEORD(OeRowId,"I",SubId,3)),"^",5)
		...s AdmNo=$P($g(^OEORD(OeRowId)),"^",1)
		...s AdmType=$p($g(^PAADM(AdmNo)),"^",2)
		...q:(BillState'="P")&&(AdmType'="I")
		...// 判断读取时间范围
		...s OrdDate=$p($g(^OEORD(OeRowId,"I",SubId,1)),"^",9)
		...q:(OrdDate<StartDate)||(OrdDate>EndDate)
		...// 判断医嘱状态				
		...s OrderStatusDr=$p($g(^OEORD(OeRowId,"I",SubId,1)),"^",13)
		...s tmpOrderStatus=$p($g(^OEC("OSTAT",OrderStatusDr)),"^",1)
		...q:tmpOrderStatus'="V"	
		...s DeptDr=$p($g(^OEORD(OeRowId,"I",SubId,3)),"^",6)
		...i DeptDr'="" d
		....s DeptCode=$p($g(^CTLOC(DeptDr)),"^",1)
		...e  d
		....s DeptCode=""
		...q:(ExeLoc'[(DeptCode))	//可以有多个接受科室	
		...s insObj=..GetAppBillByOrdRowId(ordid)
		...d MainObj.OrderList.Insert(insObj)
		set Length=MainObj.OrderList.Count()
	
	}
	do MainObj.XMLExportToStream(.stream)
	q stream
}

ClassMethod GetPatOrdListByPatID(RegisterNo As %String, StartDate As %String, EndDate As %String, ExeLoc As %String, EpsiodeType As %String) As web.DHCENS.STBLL.RIS.MODEL.RisAppInfoNew
{
	Set $ZTrap = "SendMessageET"
	s MainObj=##class(web.DHCENS.STBLL.RIS.MODEL.RisAppInfoNew).%New()
	s Flag=0
	if (StartDate="")||(EndDate="")||(ExeLoc="")  ;||(EpsiodeType="")
	{
		;s MainObj.ResultCode="-1"
		;s MainObj.ResultContent="时间、科室、状态不能为空"
		d OutLocation
	}
	else
	{
		i '$d(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(RegisterNo))) 
		{
			;s MainObj.ResultCode="-1"
			;s MainObj.ResultContent="登记号不存在"	
			d OutLocation
		}
		s StartDate=$zdh(StartDate,3)
		s EndDate=$zdh(EndDate,3)
		s PaPatDR=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(RegisterNo),""))
		s AdmType="" f  s AdmType=$o(^PAPERdr(PaPatDR,"ADM",AdmType),-1) q:(AdmType="")  d  ;!(EpsiodeType'=AdmType)
		.s AdmDr="" f  s AdmDr=$o(^PAPERdr(PaPatDR,"ADM",AdmType,AdmDr)) q:AdmDr=""  d
	    ..s TmpStatus=$p($g(^PAADM(AdmDr)),"^",20)
		..q:TmpStatus'="A"	
		..s OeRowId=$o(^OEORD(0,"Adm",AdmDr,""))
		..q:OeRowId=""
		..s SubId=0 
		..f  s SubId=$o(^OEORD(OeRowId,"I",SubId)) q:SubId=""  d
		...s ordid=OeRowId_"||"_SubId
		...s BillState=$p($g(^OEORD(OeRowId,"I",SubId,3)),"^",5)
		...q:(BillState'="P")&&(AdmType'="I")
		...// 判断读取时间范围
		...s OrdDate=$p($g(^OEORD(OeRowId,"I",SubId,1)),"^",9)
		...q:(OrdDate<StartDate)||(OrdDate>EndDate)
		...// 判断医嘱状态				
		...s OrderStatusDr=$p($g(^OEORD(OeRowId,"I",SubId,1)),"^",13)
		...s tmpOrderStatus=$p($g(^OEC("OSTAT",OrderStatusDr)),"^",1)
		...q:tmpOrderStatus'="V"	
		...s DeptDr=$p($g(^OEORD(OeRowId,"I",SubId,3)),"^",6)
		...i DeptDr'="" d
		....s DeptCode=$p($g(^CTLOC(DeptDr)),"^",1)
		...e  d
		....s DeptCode=""
		...q:(ExeLoc'[(DeptCode))	//可以有多个接受科室
		...s insObj=..GetAppBillByOrdRowId(ordid)
		...d MainObj.OrderList.Insert(insObj)
		
		set Length=MainObj.OrderList.Count()
		
		d OutLocation
	}
OutLocation
	q MainObj
SendMessageET
	set $zt=""
	s MainObj=##class(web.DHCENS.STBLL.RIS.MODEL.RisAppInfoNew).%New()
    Quit MainObj
}

/// w ##class(web.DHCENS.STBLL.RIS.METHOD.GetRisAppInfo).Test()
ClassMethod Test() As %GlobalCharacterStream
{
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("<Request><Header><SourceSystem>SYS0003</SourceSystem><MessageID></MessageID></Header><Body><PATCardNo>0000000001</PATCardNo><PATCardType>2</PATCardType><StartDate>2020-02-18</StartDate><EndDate>2020-02-18</EndDate><PAADMTypeCode>I</PAADMTypeCode><RISRAcceptDept>ZYYJ007@心电图室</RISRAcceptDept><OEORIStatusCode>A</OEORIStatusCode></Body></Request>")
	s rtn=..GetPatOrdList(stream)
	q rtn
}

/// Creator：ZhangXinying
/// CreatDate：2021—12-02
/// Description:根据医嘱号判断是否为HIS医技专业产品分库模式，分库模式情况下调PACS组方法发送检查申请单
/// Table：
/// Input：@医嘱号^医嘱号@发票号 118||3^118||4@
/// w ##class(web.DHCENS.STBLL.RIS.METHOD.GetRisAppInfo).InvokeApi("27||1471^@11")
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
		for { 
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
				set ExaReqNoXml="",arReqID=""
				set arReqID=$o(^DHCAPREP(0,"OrdItem",OrdPacs,""))
				set ExaReqNoXml=##Class(web.DHCAPPInterface).GetExaReqNoXml(arReqID,OrdPacs) /// 申请单内容XML串
				if partInfo=""
				{
					s ret=##class(RISService.InvokeRISService).InsertAppEns(OrdPacs,ExaReqNoXml)
					;d ##class(RISService.InvokeRISService).InsertAppPACS(OrdPacs)
				}
				else
				{
					s ret=##class(RISService.InvokeRISService).InsertAppEns(OrdPacs,ExaReqNoXml,"N")
					;d ##class(RISService.InvokeRISService).InsertAppPACS(OrdPacs,ExaReqNoXml,"N")	
				}
			}
		}
	}
	q "0"
Err
	s $zt=""
	q "-1^"_$ze
}

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
	s $zt=""
	Quit "价格异常"
}

}
