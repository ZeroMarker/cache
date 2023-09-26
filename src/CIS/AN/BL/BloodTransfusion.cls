/// 输血记录业务类
Class CIS.AN.BL.BloodTransfusion Extends %RegisteredObject
{

/// Creator：      	陈长青
/// CreatDate：    	2018-07-30
/// Description： 	查询血制品交接信息
/// Table：        	CIS_AN.BloodTransShift
/// Input:			startDate:开始日期,endDate:结束日期
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.BloodTransfusion","FindBloodTransShift","2018-07-30","2018-07-30")
Query FindBloodTransShift(startDate As %String, endDate As %String, medcareNo As %String = "") As %Query(ROWSPEC = "OperDate,PatDeptDesc,PatName,PatGender,PatAge,CurMedcareNo,ABO,RH,BloodCategory,TransProv,FetchProv,FetchDT,CircualNurse,CirShiftDT,CheckProv,DiscardProv,DiscardDT") [ SqlProc ]
{
}

ClassMethod FindBloodTransShiftExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, medcareNo As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set startDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate,"")
	set endDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")
	if (startDateH>endDateH)!(endDateH=0)
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK	
	}
	for dateIndex=startDateH:1:endDateH
	{
		set shiftId=0
		for
		{
			set shiftId=$order(^CIS.AN.BloodTransShiftD("CirDate",dateIndex,shiftId))
			quit:(shiftId="")
			set transShift=##class(CIS.AN.BloodTransShift).%OpenId(shiftId)
			set recordSheet=##class(CIS.AN.RecordSheet).%OpenId(transShift.RecordSheet)
			set operDate="",patDeptDesc="",patName="",patGender="",patAge="",curMedcareNo="",ABO="",RH=""
			set rset=##class(%ResultSet).%New("CIS.AN.BL.OperSchedule:FindOperScheduleList")
			set sc=rset.Execute("","","",recordSheet.OperSchedule.%Id())
			while(rset.%Next())
			{
				set operDate=rset.Get("OperDate")
				set patDeptDesc=rset.Get("PatDeptDesc")
				set patName=rset.Get("PatName")
				set patGender=rset.Get("PatGender")
				set patAge=rset.Get("PatAge")
				set curMedcareNo=rset.Get("MedcareNo")
				set ABO=rset.Get("ABO")
				set RH=rset.Get("RH")	
			}
			continue:(medcareNo'="")&(medcareNo'=curMedcareNo)
			set bloodCategory=transShift.BloodCategory
			set transProv=##class(CIS.AN.COM.String).GetDescByID("User.SSUser","SSUSRName",transShift.TransProv)
			set fetchProv=##class(CIS.AN.COM.String).GetDescByID("User.SSUser","SSUSRName",transShift.FetchNurse)	
			set fetchDT=##class(CIS.AN.COM.DateTime).ConvertToDateTime(transShift.FetchDate,transShift.FetchTime,"")
			set circualNurse=##class(CIS.AN.COM.String).GetDescByID("User.SSUser","SSUSRName",transShift.CircualNurse)
			set cirShiftDT=##class(CIS.AN.COM.DateTime).ConvertToDateTime(transShift.CirShiftDate,transShift.CirShiftTime,"")
			set checkProv=##class(CIS.AN.COM.String).GetDescByID("User.SSUser","SSUSRName",transShift.CheckProv)
			set discardProv=##class(CIS.AN.COM.String).GetDescByID("User.SSUser","SSUSRName",transShift.DiscardProv)
			set discardDT=##class(CIS.AN.COM.DateTime).ConvertToDateTime(transShift.DiscardDate,transShift.DiscardTime,"")
			do OutputRow
		}	
	}
	

OutputRow
	s Data=$lb(operDate,patDeptDesc,patName,patGender,patAge,curMedcareNo,ABO,RH,bloodCategory,transProv,fetchProv,fetchDT,circualNurse,cirShiftDT,checkProv,discardProv,discardDT)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindBloodTransShiftFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBloodTransShiftExecute ]
{
	s AtEnd=$li(qHandle,1)
	s repid=$li(qHandle,2)
	s ind=$li(qHandle,3)
	//
	s ind=$o(^CacheTemp(repid,ind))
	i ind="" {				// if there are no more rows, finish fetching
	s AtEnd=1
	s Row=""
	}
	else      {				// fetch row
	s Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindBloodTransShiftClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBloodTransShiftExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator：      	陈长青
/// CreatDate：    	2018-07-30
/// Description： 	查询输血申请信息
/// Table：        	CIS_AN.BloodTransfusion
/// Input:			recordSheetId:手术麻醉记录表单ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.BloodTransfusion","FindBloodTransfusion")
Query FindBloodTransfusion(opsId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT *,
	   CIS_AN_COM.String_GetDescByID('User.SSUser','SSUSRName',AppDoctor) As AppDoctorDesc,
	   CIS_AN_COM.String_GetDescByID('User.SSUser','SSUSRName',SuperiorDoctor) As SuperiorDoctorDesc,
	   CIS_AN_COM.String_GetDescByID('User.SSUser','SSUSRName',HeadOfDept) As HeadOfDeptDesc,
	   CIS_AN_COM.String_GetDescByID('User.SSUser','SSUSRName',MedicalAdmin) As MedicalAdminDesc,
	   CIS_AN_COM.String_GetDescByID('User.SSUser','SSUSRName',TransProv) As TransProvDesc,
	   CIS_AN_COM.String_GetDescByID('User.SSUser','SSUSRName',SpecimenCollector) As SpecimenCollectorDesc
	   From CIS_AN.BloodTransfusion
	   where OperSchedule=:opsId
}

/// Creator：      	陈长青
/// CreatDate：    	2018-07-30
/// Description： 	查询输血记录信息
/// Table：        	CIS_AN.BloodTransRecord
/// Input:			recordSheetId:手术麻醉记录表单ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.BloodTransfusion","FindBloodTransRecord","69")
Query FindBloodTransRecord(recordSheetId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   RecordSheet,
	   ABO,
	   RH,
	   TestProv,
	   BloodType,
	   BloodCategory,
	   Volume,
	   Unit,
	   CrossMatching,
	   MatchingProv,
	   GrantProv,
	   FetchProv,
	   ExecProv,
	   CheckProv,
	   UpdateUser,
	   MatchingProvDesc,
	   GrantProvDesc,
	   TestProvDesc,
	   BloodBag->ComponentCode As ComponentCode,
	   BloodBag->BarCode As BarCode,
	   BloodBag->ABO As BloodABO,
	   BloodBag->RH As BloodRH,
	   CIS_AN_COM.DateTime_ConvertToDateTime(FetchDate,FetchTime,'') As FetchDT,
	   CIS_AN_COM.DateTime_ConvertToDateTime(TransStartDate,TransStartTime,'') As TransStartDT,
	   CIS_AN_COM.DateTime_ConvertToDateTime(TransEndDate,TransEndTime,'') As TransEndDT,
	   CIS_AN_COM.DateTime_ConvertToDateTime(MatchingDate,MatchingTime,'') As MatchingDT,
	   CIS_AN_COM.String_GetDescByID("User.SSUser","SSUSRName",FetchProv) As FetchProvDesc,
	   CIS_AN_COM.String_GetDescByID("User.SSUser","SSUSRName",CheckProv) As CheckProvDesc,
	   CIS_AN_COM.String_GetDescByID("User.SSUser","SSUSRName",ExecProv) As ExecProvDesc,
	
	   TransABO,
	   TransRH,
	   Note
	   From CIS_AN.BloodTransRecord
	   where RecordSheet=:recordSheetId
}

/// Creator：      	陈长青
/// CreatDate：    	2018-07-30
/// Description： 	查询输血记录信息
/// Table：        	CIS_AN.BloodTransRecord
/// Input:			recordSheetId:手术麻醉记录表单ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.BloodTransfusion","FindBloodTransRecord")
Query FindBloodTransCmpt(opsId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT *
	   From CIS_AN.BloodTransCmpt
	   where Transfusion->OperSchedule=:opsId
}

/// w ##class(CIS.AN.BL.BloodTransfusion).AddBloodTransRecordold("19336","0060118109990","6480")
ClassMethod AddBloodTransRecordold(recordSheetId As %String, barCode As %String, userId As %String) As %String
{
	quit:(##class(CIS.AN.RecordSheet).%ExistsId(recordSheetId)=0) "E^手术申请信息不存在"
	
	set $zt="Error"
	set transRecordId=..GetBloodTransRecordByBarCode(barCode)
	if (##class(CIS.AN.BloodTransRecord).%ExistsId(transRecordId))
	{
		quit "S^"_transRecordId	
	}
	tstart
	set recordSheet=##class(CIS.AN.RecordSheet).%OpenId(recordSheetId)
	set opsId=recordSheet.OperSchedule.%Id()
	set saveResult=""
	set bloodBagId=..GetBloodBagId(barCode,opsId)
	if (##class(CIS.AN.BloodBag).%ExistsId(bloodBagId)=0)
	{
		trollback
		quit bloodBagId	
	}
	set transBloodBag=##class(CIS.AN.BloodBag).%OpenId(bloodBagId)
	if (transBloodBag.Transfusion.OperSchedule.%Id()'=recordSheet.OperSchedule.%Id())
	{
		trollback
		quit "E^患者信息不一致。"_"当前病人："_recordSheet.OperSchedule.%Id()_" "_recordSheet.OperSchedule.PatName_"  血袋对应病人："_transBloodBag.Transfusion.OperSchedule.%Id()_" "_transBloodBag.Transfusion.OperSchedule.PatName
	}
	set appBarCode=transBloodBag.Transfusion.AppBarCode
	set bloodMatchingList=##class(web.DHCANImportDataNew).GetBloodTransInfo(barCode,appBarCode)
	if (bloodMatchingList.Size>0)
	{
		set saveResult="S^"
		for i=1:1:bloodMatchingList.Size
		{
			set bloodMatching=bloodMatchingList.GetAt(i)
			set saveResult=..SaveBloodTransRecord(recordSheet,transBloodBag,bloodMatching,userId)
			quit:($piece(saveResult,"^",1)'="S")	
		}
	}
	else
	{
		set saveResult="E^无法从接口获取到输血配血数据。"	
	}
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	tcommit
	quit "S^"_$piece(saveResult,"^",2)
	
Error
	trollback
	quit "E^"_$ze
}

/// w ##class(CIS.AN.BL.BloodTransfusion).GetBloodBagId("0060118109990","12839")
ClassMethod GetBloodBagId(bloodBagList As %String, bloodInfo As %String, opsId As %String, jsondata, testItem) As %String
{
	//set barCode = $ZSTRIP(barCode,"*CWP")
	set barCode=$P(bloodBagList,"^",2)
	set bloodBagId=..GetBloodBagByBarCode(barCode)
	if (##class(CIS.AN.BloodBag).%ExistsId(bloodBagId)=1)
	{
		quit bloodBagId
	}
	b ;001
	set saveResult=""

	//if (bloodInfo.Size>0)
	//{
		b ;003
		set saveResult="S^"	
		set saveResult=..SaveBloodTransfusion(bloodBagList,jsondata,opsId,testItem)
		quit:($piece(saveResult,"^",1)'="S")
		set bloodTransId=$piece(saveResult,"^",2)
		set saveResult=..SaveTransComponent(bloodTransId,bloodBagList)
		quit:($piece(saveResult,"^",1)'="S")
		quit:($piece(saveResult,"^",1)'="S")
		set saveResult=..SaveTransBloodBag(bloodTransId,bloodBagList)
		quit:($piece(saveResult,"^",1)'="S")
		set bloodBagId=$piece(saveResult,"^",2)
	/*}
	else
	{
		set saveResult="E^无法从接口获取到血袋信息。"	
	}*/
	/*
	for i=1:1:bloodBagList.Size
	{
		set bloodBag=bloodBagList.GetAt(i)
		set saveResult=..SaveBloodTransfusion(bloodBag,opsId)
		quit:($piece(saveResult,"^",1)'="S")
		set bloodTransId=$piece(saveResult,"^",2)
		set saveResult=..SaveTransComponent(bloodTransId,bloodBag)
		quit:($piece(saveResult,"^",1)'="S")
		set saveResult=..SaveTransBloodBag(bloodTransId,barCode,bloodBag)
		quit:($piece(saveResult,"^",1)'="S")
		set bloodBagId=$piece(saveResult,"^",2)
	}
	if ($piece(saveResult,"^",1)'="S")
	{
		quit saveResult	
	}*/
	quit bloodBagId
}

ClassMethod GetBloodBagByBarCode(barCode As %String) As %String
{
	set bloodBagId=""
	&sql(select RowId into :bloodBagId from CIS_AN.bloodbag where barcode=:barCode)
	quit bloodBagId
}

ClassMethod GetBloodTransRecordByBarCode(barCode As %String) As %String
{
	set transRecordId=""
	&sql(select RowId into :transRecordId from CIS_AN.bloodtransrecord where bloodbag->barcode=:barCode)
	quit transRecordId
}

ClassMethod SaveBloodTransfusionold(bloodBag As CIS.AN.SRV.BloodBag, opsId As %String) As %String
{
	set transAppID=bloodBag.TransAppID
	set bloodTransId=""
	&sql(select RowId into :bloodTransId from CIS_AN.bloodtransfusion where ExternalID=:transAppID)
	if (##class(CIS.AN.BloodTransfusion).%ExistsId(bloodTransId)=0)
	{
		set bloodTrans=##class(CIS.AN.BloodTransfusion).%New()	
	}
	else
	{
		//set bloodTrans=##class(CIS.AN.BloodTransfusion).%OpenId(bloodTransId)
		quit "S^"_bloodTransId	
	}
	
	//set opsId=##class(CIS.AN.BL.OperSchedule).GetOperScheduleByMedNo(bloodBag.MedNo)
	set curMedNo=##class(CIS.AN.BL.OperSchedule).GetMedNoByOpsId(opsId)
	quit:(curMedNo'=bloodBag.MedNo) "E^血袋信息与手术信息不一致，血袋信息为 患者："_bloodBag.PatName_"("_bloodBag.PatGender_","_bloodBag.PatAge_") 住院号："_bloodBag.MedNo_" 血制品："_bloodBag.BloodSpecies_" 采集日期："_bloodBag.CollectedDT
	set bloodTrans.OperSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set bloodTrans.ABO=bloodBag.ABO
	set bloodTrans.RH=bloodBag.RH
	set bloodTrans.TransHistory=bloodBag.TransHistory
	set bloodTrans.Diagnosis=bloodBag.Diagnosis
	set bloodTrans.Purpose=bloodBag.TransReason
	set bloodTrans.PlanTransDT=bloodBag.PlanTransTime
	set bloodTrans.Nature=bloodBag.TransNature
	set bloodTrans.HGB=bloodBag.HGB
	set bloodTrans.HCT=bloodBag.HCT
	set bloodTrans.PLT=bloodBag.PLT
	set bloodTrans.ALT=bloodBag.ALT
	set bloodTrans.HBsAg=bloodBag.HbsAg
	set bloodTrans.HBsAb=bloodBag.AntiHBs
	set bloodTrans.HBeAg=bloodBag.HBeAg
	set bloodTrans.HBeAb=bloodBag.AntiHBe
	set bloodTrans.HCVAb=bloodBag.AntiHCV
	set bloodTrans.HIVAb=bloodBag.AntiHIV12
	set bloodTrans.Syphilis=bloodBag.SP
	set bloodTrans.AppDoctor=$tr(bloodBag.AppDoctor,$c(0),"")
	set bloodTrans.SuperiorDoctor=$tr(bloodBag.SuperiorDoctor,$c(0),"")
	set bloodTrans.HeadOfDept=$tr(bloodBag.HeadDoctor,$c(0),"")
	set bloodTrans.MedicalAdmin=$tr(bloodBag.MedSignatory,$c(0),"")
	set bloodTrans.TransProv=$tr(bloodBag.TransSignatory,$c(0),"")
	set bloodTrans.SpecimenCollector=$tr(bloodBag.SpecimenCollector,$c(0),"")
	set bloodTrans.AppBarCode=$tr(bloodBag.TransBarCode,$c(0),"")
	set bloodTrans.ExternalID=$tr(bloodBag.TransAppID,$c(0),"")
	set sc=bloodTrans.%Save()
	if ($System.Status.IsError(sc))
	{
		quit "E^"_$System.Status.GetErrorText(sc)	
	}	
	quit "S^"_bloodTrans.%Id()
}

ClassMethod SaveTransBloodBag(bloodTransId As %String, bloodBagList As CIS.AN.SRV.BloodBag) As %String
{
	set bloodBagId=""
	set barCode=$P(bloodBagList,"^",2)
	&sql(select RowId into :bloodBagId from CIS_AN.bloodbag where barCode=:barCode)
	if (##class(CIS.AN.BloodBag).%ExistsId(bloodBagId)=0)
	{
		set transBloodBag=##class(CIS.AN.BloodBag).%New()	
	}
	else
	{
		set transBloodBag=##class(CIS.AN.BloodBag).%OpenId(bloodBagId)	
		quit "S^"_bloodBagId
	}
	set bloodTrans=##class(CIS.AN.BloodTransfusion).%OpenId(bloodTransId)	
	set transBloodBag.ABO=$P(bloodBagList,"^",13)
	set transBloodBag.RH=$P(bloodBagList,"^",14)
	set transBloodBag.BloodSpecies=$P(bloodBagList,"^",15)
	set transBloodBag.CollectedDT=$P(bloodBagList,"^",20)
	;set transBloodBag.ComponentCode=bloodBag.ComponentCode
	set transBloodBag.ExpiredDT=$P(bloodBagList,"^",22)
	;set transBloodBag.RespInDT=bloodBag.RespInDT
	set transBloodBag.BarCode=$P(bloodBagList,"^",2)
	set transBloodBag.Transfusion=bloodTrans
	set sc=transBloodBag.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	quit "S^"_transBloodBag.%Id()
}

ClassMethod SaveTransComponent(bloodTransId As %String, bloodBagList) As %String
{
	set component=$P(bloodBagList,"^",15)
	set transCmptId=""
	&sql(select RowId into :transCmptId from CIS_AN.BloodTransCmpt where Component=:component)
	if (##class(CIS.AN.BloodTransCmpt).%ExistsId(transCmptId)=0)
	{
		set transCmpt=##class(CIS.AN.BloodTransCmpt).%New()	
	}
	else
	{
		//set transCmpt=##class(CIS.AN.BloodTransCmpt).%OpenId(transCmptId)	
		quit "S^transCmptId"
	}
	
	set bloodTrans=##class(CIS.AN.BloodTransfusion).%OpenId(bloodTransId)	
	set transCmpt.Transfusion=bloodTrans
	set transCmpt.Component=$P(bloodBagList,"^",15)       //bloodBag.TransComponents
	set transCmpt.Volume=$P(bloodBagList,"^",16)
	set transCmpt.Unit=$P(bloodBagList,"^",17)
	set sc=transCmpt.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	quit "S^"_transCmpt.%Id()
}

ClassMethod SaveBloodTransRecord(recordSheet As CIS.AN.RecordSheet, bloodBag As CIS.AN.BloodBag, userId As %String, bloodBagList, bloodInfo) As %String
{
	set barCode=$P(bloodBagList,"^",2)
	set transRecordId=..GetBloodTransRecordByBarCode(barCode)
	quit:(##class(CIS.AN.BloodTransRecord).%ExistsId(transRecordId)) "S^"_transRecordId
	set transRecord=##class(CIS.AN.BloodTransRecord).%New()
	set transRecord.BloodBag=bloodBag
	set transRecord.ABO=$P(bloodBagList,"^",8)    //$tr(bloodMatchInfo.PatABO,$c(0),"")
	set transRecord.BloodCategory=$P(bloodBagList,"^",15)    //$tr(bloodMatchInfo.BloodSpecies,$c(0),"")
	;set transRecord.BloodType=$tr(bloodMatchInfo.TransABO,$c(0),"")
	;set transRecord.CrossMatching=$tr(bloodMatchInfo.CrossMatching,$c(0),"")
	set transRecord.GrantProv=$P(bloodBagList,"^",19)    ;$tr(bloodMatchInfo.DispenseProv,$c(0),"")
	set transRecord.GrantProvDesc=$P(bloodBagList,"^",19)
	if ($P(bloodBagList,"^",19)'="")
	{
		set transRecord.MatchingDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($piece($P(bloodBagList,"^",20)," ",1))
		set transRecord.MatchingTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($piece($P(bloodBagList,"^",20)," ",2))
	}
	set transRecord.MatchingProv=$P(bloodBagList,"^",21)    ;$tr(bloodMatchInfo.MatchingProv,$c(0),"")
	set transRecord.MatchingProvDesc=$P(bloodBagList,"^",21)
	set transRecord.RecordSheet=recordSheet
	set transRecord.RH=$P(bloodBagList,"^",9)    //$tr(bloodMatchInfo.PatRH,$c(0),"")
	;set transRecord.TestProv=$tr(bloodMatchInfo.RetestProv,$c(0),"")
	set transRecord.Unit=$P(bloodBagList,"^",17)   //$tr($piece(bloodMatchInfo.BloodVolumeUnit,bloodMatchInfo.BloodVolume_"",2),$c(0),"")
	set transRecord.UpdateDate=+$h
	set transRecord.UpdateTime=$piece($h,",",2)
	set transRecord.UpdateUser=userId
	set transRecord.Volume=$P(bloodBagList,"^",16)   ;$tr(bloodMatchInfo.BloodVolume,$c(0),"")
	set transRecord.TransStartDate=+$h
	set transRecord.TransStartTime=$p($h,",",2)
	set transRecord.FetchDate=+$h
	set transRecord.FetchTime=$piece($h,",",2)
	set transRecord.FetchProv=userId
	;set transRecord.MatchingProvDesc=$tr(bloodMatchInfo.MatchingProvDesc,$c(0),"")
	;set transRecord.GrantProvDesc=$tr(bloodMatchInfo.DispenseProvDesc,$c(0),"")
	;set transRecord.TestProvDesc=$tr(bloodMatchInfo.RetestProvDesc,$c(0),"")
	set sc=transRecord.%Save()
	if ($System.Status.IsError(sc))
	{
		quit "E^"_$System.Status.GetErrorText(sc)	
	}
	quit "S^"_transRecord.%Id()
}

/// w ##class(CIS.AN.BL.BloodTransfusion).AddBloodTransShift("0060118080236",""
ClassMethod AddBloodTransShift(barCode As %String, userId As %String) As %String
{
	set $zt="Error"
	
	set transShiftId=""
	&sql(select RowId into :transShiftId from CIS_AN.bloodtransshift where bloodbag->barcode=:barCode)
	if (##class(CIS.AN.BloodTransShift).%ExistsId(transShiftId)=1)
	{
		quit "S^"_transShiftId	
	}
	tstart
	set bloodBagId=..GetBloodBagId(barCode)
	if (##class(CIS.AN.BloodBag).%ExistsId(bloodBagId)=0)
	{
		trollback
		quit bloodBagId	
	}
	set transBloodBag=##class(CIS.AN.BloodBag).%OpenId(bloodBagId)
	set transShift=##class(CIS.AN.BloodTransShift).%New()
	set transShift.BloodBag=transBloodBag
	set transShift.UpdateUser=userId
	set transShift.UpdateDate=+$h
	set transShift.UpdateTime=$p($h,",",2)
	set sc=transShift.%Save()
	if ($System.Status.IsError(sc))
	{
		trollback
		quit "E^"_$System.Status.GetErrorText(sc)	
	}
	tcommit
	quit "S^"_transShift.%Id()
Error
	trollback
	quit "E^"_$ze
}

/// w ##class(CIS.AN.BL.BloodTransfusion).SaveBloodSignUser("9","5","ExecProv")
ClassMethod SaveBloodSignUser(recordSheet As CIS.AN.RecordSheet, RowId As %String, SignCode As %String) As %String
{
	quit:RowId="" "未选中行数据"
	set SingRowId=""
	&sql(select RowId into :SingRowId from CIS_AN.Signature where RecordSheet=:recordSheet and SignCode=:SignCode order by RowId desc)
	;quit:SingRowId="" ""
	set SignInfo=""
	if SingRowId'="" set SignInfo=##class(CIS.AN.Signature).%OpenId(SingRowId)
	set BloodTransRecord=##class(CIS.AN.BloodTransRecord).%OpenId(RowId)
	if (SignCode="ExecProv")
	{
		if SingRowId="" set BloodTransRecord.ExecProv=""
	    else  set BloodTransRecord.ExecProv=SignInfo.SignUser
	}
	if (SignCode="CheckProv")
	{
		if SingRowId="" set BloodTransRecord.CheckProv=""
	    else  set BloodTransRecord.CheckProv=SignInfo.SignUser
	}
	set sc=BloodTransRecord.%Save()
	if ($System.Status.IsError(sc))
	{
		quit "E^"_$System.Status.GetErrorText(sc)	
	}
	quit "S^"_BloodTransRecord.%Id()
}

/// w ##class(CIS.AN.BL.BloodTransfusion).AddBloodTransRecord("371","001040818001","Z046901","12816",^TMPYGB("AddBloodTransRecord","jsondata"),^TMPYGB("AddBloodTransRecord","testItem"))
ClassMethod AddBloodTransRecord(recordSheetId As %String, barCode As %String, serCode As %String, userId As %String, jsondata As %String, testItem As %String) As %String
{
	s ^TMPYGB("AddBloodTransRecord","jsondata")=jsondata
	s ^TMPYGB("AddBloodTransRecord","testItem")=testItem
	quit:(##class(CIS.AN.RecordSheet).%ExistsId(recordSheetId)=0) "E^手术申请信息不存在"
	b ;;0012
	set $zt="Error"
	set transRecordId=..GetBloodTransRecordByBarCode(barCode)
	if (##class(CIS.AN.BloodTransRecord).%ExistsId(transRecordId))
	{
		quit "S^"_transRecordId	
	}
	tstart
	set recordSheet=##class(CIS.AN.RecordSheet).%OpenId(recordSheetId)
	set opsId=recordSheet.OperSchedule.%Id()
	set saveResult=""
	
	set OperSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)	
	set opaId=OperSchedule.ExternalID
	set adm=OperSchedule.EpisodeID
	zn "DHC-LISDATA"
	set bloodBagList=##CLASS(Service.BLD.REQ.REQService).GetPackInfoByPackCode(barCode,serCode)
	set bloodInfo=##CLASS(Service.BLD.REQ.REQService).QryReqFormInfo(adm,opaId)
	zn "DHC-APP"
	if (opaId'=$P(bloodBagList,"^",4))
	{
		trollback
		quit "该输血包不是此手术对应的输血包"	
	}
	set bloodBagId=..GetBloodBagId(bloodBagList,bloodInfo,opsId,jsondata,testItem)
	if (##class(CIS.AN.BloodBag).%ExistsId(bloodBagId)=0)
	{
		trollback
		quit bloodBagId	
	}
	set transBloodBag=##class(CIS.AN.BloodBag).%OpenId(bloodBagId)
	set saveResult=..SaveBloodTransRecord(recordSheet,transBloodBag,userId,bloodBagList,bloodInfo)

	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	tcommit
	quit "S^"_$piece(saveResult,"^",2)
	
Error
	trollback
	quit "E^"_$ze
}

ClassMethod SaveBloodTransfusion(bloodBag As %String, bloodInfo1 As %String, opsId As %String, testItem) As %String
{
	set transAppID=$P(bloodBag,"^",1)
	set bloodTransId=""
	set sc=##class(CIS.AN.COM.String).ToArray(bloodInfo1,.array)
	m bloodInfo=array(1)
	set sc=##class(CIS.AN.COM.String).ToArray(testItem,.testIteminfo)
	m testIteminfo=array1(1)
	&sql(select RowId into :bloodTransId from CIS_AN.bloodtransfusion where ExternalID=:transAppID)
	if (##class(CIS.AN.BloodTransfusion).%ExistsId(bloodTransId)=0)
	{
		set bloodTrans=##class(CIS.AN.BloodTransfusion).%New()	
	}
	else
	{
		//set bloodTrans=##class(CIS.AN.BloodTransfusion).%OpenId(bloodTransId)
		quit "S^"_bloodTransId	
	}
	//set opsId=##class(CIS.AN.BL.OperSchedule).GetOperScheduleByMedNo(bloodBag.MedNo)
	//set curMedNo=##class(CIS.AN.BL.OperSchedule).GetMedNoByOpsId(opsId)
	//quit:(curMedNo'=bloodBag.MedNo) "E^血袋信息与手术信息不一致，血袋信息为 患者："_bloodBag.PatName_"("_bloodBag.PatGender_","_bloodBag.PatAge_") 住院号："_bloodBag.MedNo_" 血制品："_bloodBag.BloodSpecies_" 采集日期："_bloodBag.CollectedDT
	set bloodTrans.OperSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set bloodTrans.ABO=bloodInfo("PatABO")
	set bloodTrans.RH=bloodInfo("PatRHD")
	set bloodTrans.TransHistory=bloodInfo("TransHistory")
	set bloodTrans.Diagnosis=bloodInfo("Diagnosis")
	set bloodTrans.Purpose=bloodInfo("TransReason")
	//set bloodTrans.PlanTransDT=bloodInfo.PlanTransTime
	set bloodTrans.Nature=bloodInfo("TransNature")
	set bloodTrans.HGB=testIteminfo(3,"HGB")
	;set bloodTrans.HCT=bloodBag.HCT
	;set bloodTrans.PLT=bloodBag.PLT
	set bloodTrans.ALT=testIteminfo(2,"ALT")
	set bloodTrans.HBsAg=testIteminfo(4,"HBSAG")
	set bloodTrans.HBsAb=testIteminfo(7,"HBSAB")
	;set bloodTrans.HBeAg=testIteminfo("HBEAG")
	set bloodTrans.HBeAb=testIteminfo(5,"HBEAB")
	;set bloodTrans.HCVAb=bloodBag.AntiHCV
	set bloodTrans.HIVAb=testIteminfo(6,"HIVAB")
	;set bloodTrans.Syphilis=bloodBag.SP
	set bloodTrans.AppDoctor=bloodInfo("AppUser")   
	set bloodTrans.SuperiorDoctor=bloodInfo("SuperiorUser")
	set bloodTrans.HeadOfDept=bloodInfo("HeadUser")
	set bloodTrans.MedicalAdmin=bloodInfo("MedMatUser")
	;set bloodTrans.TransProv=$tr(bloodBag.TransSignatory,$c(0),"")
	;set bloodTrans.SpecimenCollector=$tr(bloodBag.SpecimenCollector,$c(0),"")
	;set bloodTrans.AppBarCode=$tr(bloodBag.TransBarCode,$c(0),"")
	set bloodTrans.ExternalID=$P(bloodBag,"^",1)  ;bloodInfo("AppFlow")
	set sc=bloodTrans.%Save()
	if ($System.Status.IsError(sc))
	{
		quit "E^"_$System.Status.GetErrorText(sc)	
	}	
	quit "S^"_bloodTrans.%Id()
}

/// w ##class(CIS.AN.BL.BloodTransfusion).GetBloodTransInfo("371","001040818001","Z046901","12816")
ClassMethod GetBloodTransInfo(recordSheetId, barCode, serCode, userId)
{
	set recordSheet=##class(CIS.AN.RecordSheet).%OpenId(recordSheetId)
	set opsId=recordSheet.OperSchedule.%Id()
	set bloodBagId=..GetBloodBagByBarCode(barCode)
	if (##class(CIS.AN.BloodBag).%ExistsId(bloodBagId)=1)
	{
		quit "E^该输血包已添加，请扫描其他输血包!!"
	}
	set OperSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)	
	set opaId=OperSchedule.ExternalID
	set adm=OperSchedule.EpisodeID
	zn "DHC-LISDATA"
	set bloodBagList=##CLASS(Service.BLD.REQ.REQService).GetPackInfoByPackCode(barCode,serCode)
	set bloodInfo=##CLASS(Service.BLD.REQ.REQService).QryReqFormInfo(adm,opaId)
	zn "DHC-APP"
	q bloodInfo
}

/// w ##class(CIS.AN.BL.BloodTransfusion).DeleteBloodRecord(699)
ClassMethod DeleteBloodRecord(rowId)
{
	quit:rowId="" "E^未选中行"
	tstart
	set $zt="Error"
	set BloodRecord=##class(CIS.AN.BloodTransRecord).%OpenId(rowId)
	b ;0001
	set bloodBagId=""
	if (BloodRecord.BloodBag)
	{
		set bloodBagId=BloodRecord.BloodBag.%Id()
	}
	set transfusionId=""
	b ;0002
	if ((bloodBagId'="")&&(##class(CIS.AN.BloodBag).%ExistsId(bloodBagId)'=0))
	{
		set BloodBag=##class(CIS.AN.BloodBag).%OpenId(bloodBagId)
		set transfusionId=BloodBag.Transfusion.%Id()
		set BloodTransShiftId=""
		&sql(select %id into :BloodTransShiftId from CIS_AN.BloodTransShift where BloodBag=:bloodBagId)
		if ((BloodTransShiftId'="")&&(##class(CIS.AN.BloodTransShift).%ExistsId(BloodTransShiftId)'=0))
		{
			set BloodTransShift=##class(CIS.AN.BloodTransShift).%OpenId(BloodTransShiftId)
			set sc=BloodTransShift.%DeleteId(BloodTransShiftId)
			if ($System.Status.IsError(sc))
			{
				trollback
				quit "E^"_$System.Status.GetErrorText(sc)	
			}
		}
		set sc=BloodBag.%DeleteId(bloodBagId)
		if ($System.Status.IsError(sc))
		{
			trollback
			quit "E^"_$System.Status.GetErrorText(sc)	
		}
	}
	b ;001
	if ((transfusionId'="")&&(##class(CIS.AN.BloodTransfusion).%ExistsId(transfusionId)'=0))
	{
		set BloodTransfusion=##class(CIS.AN.BloodTransfusion).%OpenId(transfusionId)
		set BloodTransCmptId=""
		&sql(select %id into :BloodTransCmptId from CIS_AN.BloodTransCmpt where Transfusion=:transfusionId)
		if ((BloodTransCmptId'="")&&(##class(CIS.AN.BloodTransCmpt).%ExistsId(BloodTransCmptId)'=0))
		{
			set BloodTransCmpt=##class(CIS.AN.BloodTransCmpt).%OpenId(BloodTransCmptId)
			set sc=BloodTransfusion.%DeleteId(BloodTransCmptId)
			if ($System.Status.IsError(sc))
			{
				trollback
				quit "E^"_$System.Status.GetErrorText(sc)	
			}
		}
		set sc=BloodTransfusion.%DeleteId(transfusionId)
		if ($System.Status.IsError(sc))
		{
			trollback
			quit "E^"_$System.Status.GetErrorText(sc)	
		}
		
	}
	b ; 002
	set sc=BloodRecord.%DeleteId(rowId)
	if ($System.Status.IsError(sc))
	{
		trollback
		quit "E^"_$System.Status.GetErrorText(sc)	
	}
	tcommit
	quit "S^"
Error
	trollback
	quit "E^"_$ze
}

}
