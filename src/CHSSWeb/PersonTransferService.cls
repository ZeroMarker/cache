Class CHSSWeb.PersonTransferService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: lyy
/// CreatDate：2010-04-
/// Description:转诊登记表
/// Table：PersonTransfer
/// Input: PersonTransfer
/// Output：
/// Return：
/// Others：
ClassMethod InceptList(PersonRowId As %Integer, start As %Integer, limit As %Integer, sort As %String) As %String
{
      
    s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select TransferRowId from CHSS.PersonTransfer where TransferTypeDR=2 and PersonRowId="_PersonRowId
    
    d result.Prepare(sqlStr)
	d result.Execute()
	
	Set start=$G(start)
	Set limit=$G(limit)
	Set sort=$G(sort)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit
	
	Set tmp = ""
	
	Set json = ##class(Code.JsonObj).%New()

	While(result.Next())
	{
      
      s TransferRowId = result.Data("TransferRowId")     
      s tempPersonTransfer=##class(CHSS.PersonTransfer).%OpenId(TransferRowId)
      set TransferStatusDRName = ""
      set TransferStatusDR = ""
      i tempPersonTransfer.TransferStatusDR '= "" d
      .s TransferStatusDR = tempPersonTransfer.TransferStatusDR
      .//s TransferStatusDRName = tempPersonTransfer.TransferStatusDR.Description
      .s TransferStatusDRName=..getStatusDesc(tempPersonTransfer.TransferStatusDR)
         
      set TransferTypeDRName = ""
      set TransferTypeDR = ""
      i tempPersonTransfer.TransferTypeDR '= "" d
      .s TransferTypeDR = tempPersonTransfer.TransferTypeDR
      .//s TransferTypeDRName = tempPersonTransfer.TransferTypeDR.Description
      .s TransferTypeDRName=..getTypeDesc(tempPersonTransfer.TransferTypeDR)
      
      s SendUnit = tempPersonTransfer.SendUnit
      s PatientName = tempPersonTransfer.PatientName
      
           
      set SexDRName = ""
      set SexDR = ""
      i tempPersonTransfer.SexDR '= "" d
      .s SexDR = tempPersonTransfer.SexDR.%Id()
      .s SexDRName = tempPersonTransfer.SexDR.CTSEXDesc
      
      
      set Birth = tempPersonTransfer.Birth
      i Birth '= "" d
      .s Birth = $zd(Birth,3)
      
      s CaseBookNumber = tempPersonTransfer.CaseBookNumber
      s TelNumber = tempPersonTransfer.TelNumber
      s HomePlace = tempPersonTransfer.HomePlace
      s SendDepartment = tempPersonTransfer.SendDepartment
      s SendLeader = tempPersonTransfer.SendLeader
      s SendDoctor = tempPersonTransfer.SendDoctor
     
      set SendDate = tempPersonTransfer.SendDate
      i SendDate '= "" d
      .s SendDate = $zd(SendDate,3)
      
      s SendDoctNumber = tempPersonTransfer.SendDoctNumber
      s AcceptUnit = tempPersonTransfer.AcceptUnit
      s AcceptDepartment = tempPersonTransfer.AcceptDepartment
      s AcceptLeader = tempPersonTransfer.AcceptLeader
      s AcceptDoctor = tempPersonTransfer.AcceptDoctor
          
      set StartAcceptDate = tempPersonTransfer.StartAcceptDate
      i StartAcceptDate '= "" d
      .s StartAcceptDate = $zd(StartAcceptDate,3)
      
      set EndAcceptDate = tempPersonTransfer.EndAcceptDate
      i EndAcceptDate '= "" d
      .s EndAcceptDate = $zd(EndAcceptDate,3)
      
      s AcceptDoctNumber = tempPersonTransfer.AcceptDoctNumber
      s AcceptNumberDay1 = tempPersonTransfer.AcceptNumberDay1
      s AcceptNumberDay2 = tempPersonTransfer.AcceptNumberDay2
      s AcceptNumberNight = tempPersonTransfer.AcceptNumberNight
      s AuditMan = tempPersonTransfer.AuditMan
                
      set AuditDate = tempPersonTransfer.AuditDate
      i AuditDate '= "" d
      .s AuditDate = $zd(AuditDate,3)
      
      s ChiefComplaint = tempPersonTransfer.ChiefComplaint
      s DoctorSay = tempPersonTransfer.DoctorSay
      s DiseaseHistory = tempPersonTransfer.DiseaseHistory
      s PersonHistory = tempPersonTransfer.PersonHistory
      s FamilyHistory = tempPersonTransfer.FamilyHistory
      s Suggestion = tempPersonTransfer.Suggestion
      s DiagnoseResult = tempPersonTransfer.DiagnoseResult
      s TransferReason = tempPersonTransfer.TransferReason
      s TransferTarget = tempPersonTransfer.TransferTarget
      s CaseAbstract = tempPersonTransfer.CaseAbstract
      s Attentions = tempPersonTransfer.Attentions
      s Remark = tempPersonTransfer.Remark
      s SendUnitCode = tempPersonTransfer.SendUnitCode
      s AcceptUnitCode = tempPersonTransfer.AcceptUnitCode
      s bDeleteFlag = tempPersonTransfer.bDeleteFlag
      s OldRecordRowId = tempPersonTransfer.OldRecordRowId
      
      set FeeTypeDRName = ""
      set FeeTypeDR = ""
      i tempPersonTransfer.FeeTypeDR '= "" d
      .s FeeTypeDR = tempPersonTransfer.FeeTypeDR.%Id()
      .s FeeTypeDRName = tempPersonTransfer.FeeTypeDR.Description
      
      set BackDate = tempPersonTransfer.BackDate
      i BackDate '= "" d
      .s BackDate = $zd(BackDate,3)
      
      s BackCaseInfo = tempPersonTransfer.BackCaseInfo
          
      Set tmp = PersonRowId_"^"_TransferRowId_"^"_TransferStatusDR_"^"_TransferStatusDRName_"^"_TransferTypeDR_"^"_TransferTypeDRName_"^"_SendUnit_"^"_PatientName_"^"_SexDR_"^"_SexDRName_"^"_Birth_"^"_CaseBookNumber_"^"_TelNumber_"^"_HomePlace_"^"_SendDepartment_"^"_SendLeader_"^"_SendDoctor_"^"_SendDate_"^"_SendDoctNumber_"^"_AcceptUnit_"^"_AcceptDepartment_"^"_AcceptLeader_"^"_AcceptDoctor_"^"_StartAcceptDate_"^"_EndAcceptDate_"^"_AcceptDoctNumber_"^"_AcceptNumberDay1_"^"_AcceptNumberDay2_"^"_AcceptNumberNight_"^"_AuditMan_"^"_AuditDate_"^"_ChiefComplaint_"^"_DoctorSay_"^"_DiseaseHistory_"^"_PersonHistory_"^"_FamilyHistory_"^"_Suggestion_"^"_DiagnoseResult_"^"_TransferReason_"^"_TransferTarget_"^"_CaseAbstract_"^"_Attentions_"^"_Remark_"^"_SendUnitCode_"^"_AcceptUnitCode_"^"_bDeleteFlag_"^"_OldRecordRowId_"^"_FeeTypeDR_"^"_FeeTypeDRName_"^"_BackDate_"^"_BackCaseInfo

	  s count = count+1
	  i (count>start)&(count<=end) d
	  .d json.InsertRowData(tmp)
	  
      
	}
      
      Set resultString = json.getJsonData("PersonRowId^TransferRowId^TransferStatusDR^TransferStatusDRName^TransferTypeDR^TransferTypeDRName^SendUnit^PatientName^SexDR1^SexDRName^Birth1^CaseBookNumber^TelNumber^HomePlace^SendDepartment^SendLeader^SendDoctor^SendDate^SendDoctNumber^AcceptUnit^AcceptDepartment^AcceptLeader^AcceptDoctor^StartAcceptDate^EndAcceptDate^AcceptDoctNumber^AcceptNumberDay1^AcceptNumberDay2^AcceptNumberNight^AuditMan^AuditDate^ChiefComplaint^DoctorSay^DiseaseHistory^PersonHistory^FamilyHistory^Suggestion^DiagnoseResult^TransferReason^TransferTarget^CaseAbstract^Attentions^Remark^SendUnitCode^AcceptUnitCode^bDeleteFlag^OldRecordRowId^FeeTypeDR^FeeTypeDRName^BackDate^BackCaseInfo",count)
      k json
      d result.Close()
      
      Quit resultString
}

/// Creator: lyy
/// CreatDate：2010-04-
/// Description:转诊登记表
/// Table：PersonTransfer
/// Input: PersonTransfer
/// Output：
/// Return：
/// Others：
ClassMethod InceptListAll(CommunityCode As %String, start As %Integer, limit As %Integer, sort As %String, whereStr As %String) As %String
{
      
    s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select TransferRowId from CHSS.PersonTransfer where TransferTypeDR=2 and PersonRowId in (select PersonRowId from CHSS.PersonHealthRecordMain where CommunityCode ='"_CommunityCode_"') "_whereStr
    s ^TMP("zhwh",11)=whereStr
       
    d result.Prepare(sqlStr)
	d result.Execute()
	
	Set start=$G(start)
	Set limit=$G(limit)
	Set sort=$G(sort)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit
	
	Set tmp = ""
	
	Set json = ##class(Code.JsonObj).%New()

	While(result.Next())
	{
      
      s TransferRowId = result.Data("TransferRowId")     
      
         
      s tempPersonTransfer=##class(CHSS.PersonTransfer).%OpenId(TransferRowId)
      
      i tempPersonTransfer.PersonRowId '= "" d
      .s PersonRowId = tempPersonTransfer.PersonRowId.%Id()
     
      set TransferStatusDRName = ""
      set TransferStatusDR = ""
      i tempPersonTransfer.TransferStatusDR '= "" d
      .s TransferStatusDR = tempPersonTransfer.TransferStatusDR
      .//s TransferStatusDRName = tempPersonTransfer.TransferStatusDR.Description
      .s TransferStatusDRName=..getStatusDesc(tempPersonTransfer.TransferStatusDR )
      
         
      set TransferTypeDRName = ""
      set TransferTypeDR = ""
      i tempPersonTransfer.TransferTypeDR '= "" d
      .s TransferTypeDR = tempPersonTransfer.TransferTypeDR
      .//s TransferTypeDRName = tempPersonTransfer.TransferTypeDR.Description
      .s TransferTypeDRName=..getTypeDesc(TransferTypeDR)
      
      s SendUnit = tempPersonTransfer.SendUnit
      s PatientName = tempPersonTransfer.PatientName
      
           
      set SexDRName = ""
      set SexDR = ""
      i tempPersonTransfer.SexDR '= "" d
      .s SexDR = tempPersonTransfer.SexDR.%Id()
      .s SexDRName = tempPersonTransfer.SexDR.CTSEXDesc
      
      
      set Birth = tempPersonTransfer.Birth
      i Birth '= "" d
      .s Birth = $zd(Birth,3)
      
      s CaseBookNumber = tempPersonTransfer.CaseBookNumber
      s TelNumber = tempPersonTransfer.TelNumber
      s HomePlace = tempPersonTransfer.HomePlace
      s SendDepartment = tempPersonTransfer.SendDepartment
      s SendLeader = tempPersonTransfer.SendLeader
      s SendDoctor = tempPersonTransfer.SendDoctor
     
      set SendDate = tempPersonTransfer.SendDate
      i SendDate '= "" d
      .s SendDate = $zd(SendDate,3)
      
      s SendDoctNumber = tempPersonTransfer.SendDoctNumber
      s AcceptUnit = tempPersonTransfer.AcceptUnit
      s AcceptDepartment = tempPersonTransfer.AcceptDepartment
      s AcceptLeader = tempPersonTransfer.AcceptLeader
      s AcceptDoctor = tempPersonTransfer.AcceptDoctor
          
      set StartAcceptDate = tempPersonTransfer.StartAcceptDate
      i StartAcceptDate '= "" d
      .s StartAcceptDate = $zd(StartAcceptDate,3)
      
      set EndAcceptDate = tempPersonTransfer.EndAcceptDate
      i EndAcceptDate '= "" d
      .s EndAcceptDate = $zd(EndAcceptDate,3)
      
      s AcceptDoctNumber = tempPersonTransfer.AcceptDoctNumber
      s AcceptNumberDay1 = tempPersonTransfer.AcceptNumberDay1
      s AcceptNumberDay2 = tempPersonTransfer.AcceptNumberDay2
      s AcceptNumberNight = tempPersonTransfer.AcceptNumberNight
      s AuditMan = tempPersonTransfer.AuditMan
                
      set AuditDate = tempPersonTransfer.AuditDate
      i AuditDate '= "" d
      .s AuditDate = $zd(AuditDate,3)
      
      s ChiefComplaint = tempPersonTransfer.ChiefComplaint
      s DoctorSay = tempPersonTransfer.DoctorSay
      s DiseaseHistory = tempPersonTransfer.DiseaseHistory
      s PersonHistory = tempPersonTransfer.PersonHistory
      s FamilyHistory = tempPersonTransfer.FamilyHistory
      s Suggestion = tempPersonTransfer.Suggestion
      s DiagnoseResult = tempPersonTransfer.DiagnoseResult
      s TransferReason = tempPersonTransfer.TransferReason
      s TransferTarget = tempPersonTransfer.TransferTarget
      s CaseAbstract = tempPersonTransfer.CaseAbstract
      s Attentions = tempPersonTransfer.Attentions
      s Remark = tempPersonTransfer.Remark
      s SendUnitCode = tempPersonTransfer.SendUnitCode
      s AcceptUnitCode = tempPersonTransfer.AcceptUnitCode
      s bDeleteFlag = tempPersonTransfer.bDeleteFlag
      s OldRecordRowId = tempPersonTransfer.OldRecordRowId
      
      set FeeTypeDRName = ""
      set FeeTypeDR = ""
      i tempPersonTransfer.FeeTypeDR '= "" d
      .s FeeTypeDR = tempPersonTransfer.FeeTypeDR.%Id()
      .s FeeTypeDRName = tempPersonTransfer.FeeTypeDR.Description
      
      set BackDate = tempPersonTransfer.BackDate
      i BackDate '= "" d
      .s BackDate = $zd(BackDate,3)
      
      s BackCaseInfo = tempPersonTransfer.BackCaseInfo
          
      Set tmp = PersonRowId_"^"_TransferRowId_"^"_TransferStatusDR_"^"_TransferStatusDRName_"^"_TransferTypeDR_"^"_TransferTypeDRName_"^"_SendUnit_"^"_PatientName_"^"_SexDR_"^"_SexDRName_"^"_Birth_"^"_CaseBookNumber_"^"_TelNumber_"^"_HomePlace_"^"_SendDepartment_"^"_SendLeader_"^"_SendDoctor_"^"_SendDate_"^"_SendDoctNumber_"^"_AcceptUnit_"^"_AcceptDepartment_"^"_AcceptLeader_"^"_AcceptDoctor_"^"_StartAcceptDate_"^"_EndAcceptDate_"^"_AcceptDoctNumber_"^"_AcceptNumberDay1_"^"_AcceptNumberDay2_"^"_AcceptNumberNight_"^"_AuditMan_"^"_AuditDate_"^"_ChiefComplaint_"^"_DoctorSay_"^"_DiseaseHistory_"^"_PersonHistory_"^"_FamilyHistory_"^"_Suggestion_"^"_DiagnoseResult_"^"_TransferReason_"^"_TransferTarget_"^"_CaseAbstract_"^"_Attentions_"^"_Remark_"^"_SendUnitCode_"^"_AcceptUnitCode_"^"_bDeleteFlag_"^"_OldRecordRowId_"^"_FeeTypeDR_"^"_FeeTypeDRName_"^"_BackDate_"^"_BackCaseInfo

	  s count = count+1
	  i (count>start)&(count<=end) d
	  .d json.InsertRowData(tmp)
	  
      
	}
      
      Set resultString = json.getJsonData("PersonRowId^TransferRowId^TransferStatusDR^TransferStatusDRName^TransferTypeDR^TransferTypeDRName^SendUnit^PatientName^SexDR1^SexDRName^Birth1^CaseBookNumber^TelNumber^HomePlace^SendDepartment^SendLeader^SendDoctor^SendDate^SendDoctNumber^AcceptUnit^AcceptDepartment^AcceptLeader^AcceptDoctor^StartAcceptDate^EndAcceptDate^AcceptDoctNumber^AcceptNumberDay1^AcceptNumberDay2^AcceptNumberNight^AuditMan^AuditDate^ChiefComplaint^DoctorSay^DiseaseHistory^PersonHistory^FamilyHistory^Suggestion^DiagnoseResult^TransferReason^TransferTarget^CaseAbstract^Attentions^Remark^SendUnitCode^AcceptUnitCode^bDeleteFlag^OldRecordRowId^FeeTypeDR^FeeTypeDRName^BackDate^BackCaseInfo",count)
      k json
      d result.Close()
      
      Quit resultString
}

/// Creator: lyy
/// CreatDate：2010-04-
/// Description:转诊登记表
/// Table：PersonTransfer
/// Input: PersonTransfer
/// Output：
/// Return：
/// Others：
ClassMethod List(PersonRowId As %Integer, start As %Integer, limit As %Integer, sort As %String) As %String
{
      
    s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select TransferRowId from CHSS.PersonTransfer where TransferTypeDR=1 and PersonRowId="_PersonRowId
    
    d result.Prepare(sqlStr)
	d result.Execute()
	
	Set start=$G(start)
	Set limit=$G(limit)
	Set sort=$G(sort)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit
	
	Set tmp = ""
	
	Set json = ##class(Code.JsonObj).%New()

	While(result.Next())
	{
      
      s TransferRowId = result.Data("TransferRowId")     
      
         
      s tempPersonTransfer=##class(CHSS.PersonTransfer).%OpenId(TransferRowId)
      
          
      set TransferStatusDRName = ""
      set TransferStatusDR = ""
      i tempPersonTransfer.TransferStatusDR '= "" d
      .s TransferStatusDR = tempPersonTransfer.TransferStatusDR
      .//s TransferStatusDRName = tempPersonTransfer.TransferStatusDR.Description
      .s TransferStatusDRName=..getStatusDesc(tempPersonTransfer.TransferStatusDR)
      
         
      set TransferTypeDRName = ""
      set TransferTypeDR = ""
      i tempPersonTransfer.TransferTypeDR '= "" d
      .s TransferTypeDR = tempPersonTransfer.TransferTypeDR
      .//s TransferTypeDRName = tempPersonTransfer.TransferTypeDR.Description
      .s TransferTypeDRName=..getTypeDesc(tempPersonTransfer.TransferTypeDR)
      
      s SendUnit = tempPersonTransfer.SendUnit
      s PatientName = tempPersonTransfer.PatientName
      
           
      set SexDRName = ""
      set SexDR = ""
      i tempPersonTransfer.SexDR '= "" d
      .s SexDR = tempPersonTransfer.SexDR.%Id()
      .s SexDRName = tempPersonTransfer.SexDR.CTSEXDesc
      
      
      set Birth = tempPersonTransfer.Birth
      i Birth '= "" d
      .s Birth = $zd(Birth,3)
      
      s CaseBookNumber = tempPersonTransfer.CaseBookNumber
      s TelNumber = tempPersonTransfer.TelNumber
      s HomePlace = tempPersonTransfer.HomePlace
      s SendDepartment = tempPersonTransfer.SendDepartment
      s SendLeader = tempPersonTransfer.SendLeader
      s SendDoctor = tempPersonTransfer.SendDoctor
     
      set SendDate = tempPersonTransfer.SendDate
      i SendDate '= "" d
      .s SendDate = $zd(SendDate,3)
      
      s SendDoctNumber = tempPersonTransfer.SendDoctNumber
      s AcceptUnit = tempPersonTransfer.AcceptUnit
      s AcceptDepartment = tempPersonTransfer.AcceptDepartment
      s AcceptLeader = tempPersonTransfer.AcceptLeader
      s AcceptDoctor = tempPersonTransfer.AcceptDoctor
          
      set StartAcceptDate = tempPersonTransfer.StartAcceptDate
      i StartAcceptDate '= "" d
      .s StartAcceptDate = $zd(StartAcceptDate,3)
      
      set EndAcceptDate = tempPersonTransfer.EndAcceptDate
      i EndAcceptDate '= "" d
      .s EndAcceptDate = $zd(EndAcceptDate,3)
      
      s AcceptDoctNumber = tempPersonTransfer.AcceptDoctNumber
      s AcceptNumberDay1 = tempPersonTransfer.AcceptNumberDay1
      s AcceptNumberDay2 = tempPersonTransfer.AcceptNumberDay2
      s AcceptNumberNight = tempPersonTransfer.AcceptNumberNight
      s AuditMan = tempPersonTransfer.AuditMan
                
      set AuditDate = tempPersonTransfer.AuditDate
      i AuditDate '= "" d
      .s AuditDate = $zd(AuditDate,3)
      
      s ChiefComplaint = tempPersonTransfer.ChiefComplaint
      s DoctorSay = tempPersonTransfer.DoctorSay
      s DiseaseHistory = tempPersonTransfer.DiseaseHistory
      s PersonHistory = tempPersonTransfer.PersonHistory
      s FamilyHistory = tempPersonTransfer.FamilyHistory
      s Suggestion = tempPersonTransfer.Suggestion
      s DiagnoseResult = tempPersonTransfer.DiagnoseResult
      s TransferReason = tempPersonTransfer.TransferReason
      s TransferTarget = tempPersonTransfer.TransferTarget
      s CaseAbstract = tempPersonTransfer.CaseAbstract
      s Attentions = tempPersonTransfer.Attentions
      s Remark = tempPersonTransfer.Remark
      s SendUnitCode = tempPersonTransfer.SendUnitCode
      s AcceptUnitCode = tempPersonTransfer.AcceptUnitCode
      s bDeleteFlag = tempPersonTransfer.bDeleteFlag
      s OldRecordRowId = tempPersonTransfer.OldRecordRowId
      
      set FeeTypeDRName = ""
      set FeeTypeDR = ""
      i tempPersonTransfer.FeeTypeDR '= "" d
      .s FeeTypeDR = tempPersonTransfer.FeeTypeDR.%Id()
      .s FeeTypeDRName = tempPersonTransfer.FeeTypeDR.Description
      
      set BackDate = tempPersonTransfer.BackDate
      i BackDate '= "" d
      .s BackDate = $zd(BackDate,3)
      
      s BackCaseInfo = tempPersonTransfer.BackCaseInfo
          
      Set tmp = PersonRowId_"^"_TransferRowId_"^"_TransferStatusDR_"^"_TransferStatusDRName_"^"_TransferTypeDR_"^"_TransferTypeDRName_"^"_SendUnit_"^"_PatientName_"^"_SexDR_"^"_SexDRName_"^"_Birth_"^"_CaseBookNumber_"^"_TelNumber_"^"_HomePlace_"^"_SendDepartment_"^"_SendLeader_"^"_SendDoctor_"^"_SendDate_"^"_SendDoctNumber_"^"_AcceptUnit_"^"_AcceptDepartment_"^"_AcceptLeader_"^"_AcceptDoctor_"^"_StartAcceptDate_"^"_EndAcceptDate_"^"_AcceptDoctNumber_"^"_AcceptNumberDay1_"^"_AcceptNumberDay2_"^"_AcceptNumberNight_"^"_AuditMan_"^"_AuditDate_"^"_ChiefComplaint_"^"_DoctorSay_"^"_DiseaseHistory_"^"_PersonHistory_"^"_FamilyHistory_"^"_Suggestion_"^"_DiagnoseResult_"^"_TransferReason_"^"_TransferTarget_"^"_CaseAbstract_"^"_Attentions_"^"_Remark_"^"_SendUnitCode_"^"_AcceptUnitCode_"^"_bDeleteFlag_"^"_OldRecordRowId_"^"_FeeTypeDR_"^"_FeeTypeDRName_"^"_BackDate_"^"_BackCaseInfo

	  s count = count+1
	  i (count>start)&(count<=end) d
	  .d json.InsertRowData(tmp)
	  
      
	}
      
      Set resultString = json.getJsonData("PersonRowId^TransferRowId^TransferStatusDR^TransferStatusDRName^TransferTypeDR^TransferTypeDRName^SendUnit^PatientName^SexDR1^SexDRName^Birth1^CaseBookNumber^TelNumber^HomePlace^SendDepartment^SendLeader^SendDoctor^SendDate^SendDoctNumber^AcceptUnit^AcceptDepartment^AcceptLeader^AcceptDoctor^StartAcceptDate^EndAcceptDate^AcceptDoctNumber^AcceptNumberDay1^AcceptNumberDay2^AcceptNumberNight^AuditMan^AuditDate^ChiefComplaint^DoctorSay^DiseaseHistory^PersonHistory^FamilyHistory^Suggestion^DiagnoseResult^TransferReason^TransferTarget^CaseAbstract^Attentions^Remark^SendUnitCode^AcceptUnitCode^bDeleteFlag^OldRecordRowId^FeeTypeDR^FeeTypeDRName^BackDate^BackCaseInfo",count)
      k json
      d result.Close()
      
      Quit resultString
}

/// Creator: lyy
/// CreatDate：2010-04-
/// Description:转诊登记表
/// Table：PersonTransfer
/// Input: PersonTransfer
/// Output：
/// Return：
/// Others：
ClassMethod ListAll(CommunityCode As %String, start As %Integer, limit As %Integer, sort As %String, whereStr As %String) As %String
{
      
    s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select TransferRowId from CHSS.PersonTransfer where TransferTypeDR=1 and PersonRowId in (select PersonRowId from CHSS.PersonHealthRecordMain where CommunityCode ='"_CommunityCode_"') "_whereStr
    
     s ^TMP("zhwh",0)=whereStr
     
    d result.Prepare(sqlStr)
	d result.Execute()
	
	Set start=$G(start)
	Set limit=$G(limit)
	Set sort=$G(sort)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit
	
	Set tmp = ""
	
	Set json = ##class(Code.JsonObj).%New()

	While(result.Next())
	{
      
      s TransferRowId = result.Data("TransferRowId")     
      
         
      s tempPersonTransfer=##class(CHSS.PersonTransfer).%OpenId(TransferRowId)
      
      i tempPersonTransfer.PersonRowId '= "" d
      .s PersonRowId = tempPersonTransfer.PersonRowId.%Id()
     
      set TransferStatusDRName = ""
      set TransferStatusDR = ""
      i tempPersonTransfer.TransferStatusDR '= "" d
      .s TransferStatusDR = tempPersonTransfer.TransferStatusDR
      .//s TransferStatusDRName = tempPersonTransfer.TransferStatusDR.Description
      .s TransferStatusDRName=..getStatusDesc(tempPersonTransfer.TransferStatusDR )
      
         
      set TransferTypeDRName = ""
      set TransferTypeDR = ""
      i tempPersonTransfer.TransferTypeDR '= "" d
      .s TransferTypeDR = tempPersonTransfer.TransferTypeDR
      .//s TransferTypeDRName = tempPersonTransfer.TransferTypeDR.Description
      .s TransferTypeDRName=..getTypeDesc(tempPersonTransfer.TransferTypeDR )
      
      s SendUnit = tempPersonTransfer.SendUnit
      s PatientName = tempPersonTransfer.PatientName
      
           
      set SexDRName = ""
      set SexDR = ""
      i tempPersonTransfer.SexDR '= "" d
      .s SexDR = tempPersonTransfer.SexDR.%Id()
      .s SexDRName = tempPersonTransfer.SexDR.CTSEXDesc
      
      
      set Birth = tempPersonTransfer.Birth
      i Birth '= "" d
      .s Birth = $zd(Birth,3)
      
      s CaseBookNumber = tempPersonTransfer.CaseBookNumber
      s TelNumber = tempPersonTransfer.TelNumber
      s HomePlace = tempPersonTransfer.HomePlace
      s SendDepartment = tempPersonTransfer.SendDepartment
      s SendLeader = tempPersonTransfer.SendLeader
      s SendDoctor = tempPersonTransfer.SendDoctor
     
      set SendDate = tempPersonTransfer.SendDate
      i SendDate '= "" d
      .s SendDate = $zd(SendDate,3)
      
      s SendDoctNumber = tempPersonTransfer.SendDoctNumber
      s AcceptUnit = tempPersonTransfer.AcceptUnit
      s AcceptDepartment = tempPersonTransfer.AcceptDepartment
      s AcceptLeader = tempPersonTransfer.AcceptLeader
      s AcceptDoctor = tempPersonTransfer.AcceptDoctor
          
      set StartAcceptDate = tempPersonTransfer.StartAcceptDate
      i StartAcceptDate '= "" d
      .s StartAcceptDate = $zd(StartAcceptDate,3)
      
      set EndAcceptDate = tempPersonTransfer.EndAcceptDate
      i EndAcceptDate '= "" d
      .s EndAcceptDate = $zd(EndAcceptDate,3)
      
      s AcceptDoctNumber = tempPersonTransfer.AcceptDoctNumber
      s AcceptNumberDay1 = tempPersonTransfer.AcceptNumberDay1
      s AcceptNumberDay2 = tempPersonTransfer.AcceptNumberDay2
      s AcceptNumberNight = tempPersonTransfer.AcceptNumberNight
      s AuditMan = tempPersonTransfer.AuditMan
                
      set AuditDate = tempPersonTransfer.AuditDate
      i AuditDate '= "" d
      .s AuditDate = $zd(AuditDate,3)
      
      s ChiefComplaint = tempPersonTransfer.ChiefComplaint
      s DoctorSay = tempPersonTransfer.DoctorSay
      s DiseaseHistory = tempPersonTransfer.DiseaseHistory
      s PersonHistory = tempPersonTransfer.PersonHistory
      s FamilyHistory = tempPersonTransfer.FamilyHistory
      s Suggestion = tempPersonTransfer.Suggestion
      s DiagnoseResult = tempPersonTransfer.DiagnoseResult
      s TransferReason = tempPersonTransfer.TransferReason
      s TransferTarget = tempPersonTransfer.TransferTarget
      s CaseAbstract = tempPersonTransfer.CaseAbstract
      s Attentions = tempPersonTransfer.Attentions
      s Remark = tempPersonTransfer.Remark
      s SendUnitCode = tempPersonTransfer.SendUnitCode
      s AcceptUnitCode = tempPersonTransfer.AcceptUnitCode
      s bDeleteFlag = tempPersonTransfer.bDeleteFlag
      s OldRecordRowId = tempPersonTransfer.OldRecordRowId
      
      set FeeTypeDRName = ""
      set FeeTypeDR = ""
      i tempPersonTransfer.FeeTypeDR '= "" d
      .s FeeTypeDR = tempPersonTransfer.FeeTypeDR.%Id()
      .s FeeTypeDRName = tempPersonTransfer.FeeTypeDR.Description
      
      set BackDate = tempPersonTransfer.BackDate
      i BackDate '= "" d
      .s BackDate = $zd(BackDate,3)
      
      s BackCaseInfo = tempPersonTransfer.BackCaseInfo
          
      Set tmp = PersonRowId_"^"_TransferRowId_"^"_TransferStatusDR_"^"_TransferStatusDRName_"^"_TransferTypeDR_"^"_TransferTypeDRName_"^"_SendUnit_"^"_PatientName_"^"_SexDR_"^"_SexDRName_"^"_Birth_"^"_CaseBookNumber_"^"_TelNumber_"^"_HomePlace_"^"_SendDepartment_"^"_SendLeader_"^"_SendDoctor_"^"_SendDate_"^"_SendDoctNumber_"^"_AcceptUnit_"^"_AcceptDepartment_"^"_AcceptLeader_"^"_AcceptDoctor_"^"_StartAcceptDate_"^"_EndAcceptDate_"^"_AcceptDoctNumber_"^"_AcceptNumberDay1_"^"_AcceptNumberDay2_"^"_AcceptNumberNight_"^"_AuditMan_"^"_AuditDate_"^"_ChiefComplaint_"^"_DoctorSay_"^"_DiseaseHistory_"^"_PersonHistory_"^"_FamilyHistory_"^"_Suggestion_"^"_DiagnoseResult_"^"_TransferReason_"^"_TransferTarget_"^"_CaseAbstract_"^"_Attentions_"^"_Remark_"^"_SendUnitCode_"^"_AcceptUnitCode_"^"_bDeleteFlag_"^"_OldRecordRowId_"^"_FeeTypeDR_"^"_FeeTypeDRName_"^"_BackDate_"^"_BackCaseInfo

	  s count = count+1
	  i (count>start)&(count<=end) d
	  .d json.InsertRowData(tmp)
	  
      
	}
      
      Set resultString = json.getJsonData("PersonRowId^TransferRowId^TransferStatusDR^TransferStatusDRName^TransferTypeDR^TransferTypeDRName^SendUnit^PatientName^SexDR1^SexDRName^Birth1^CaseBookNumber^TelNumber^HomePlace^SendDepartment^SendLeader^SendDoctor^SendDate^SendDoctNumber^AcceptUnit^AcceptDepartment^AcceptLeader^AcceptDoctor^StartAcceptDate^EndAcceptDate^AcceptDoctNumber^AcceptNumberDay1^AcceptNumberDay2^AcceptNumberNight^AuditMan^AuditDate^ChiefComplaint^DoctorSay^DiseaseHistory^PersonHistory^FamilyHistory^Suggestion^DiagnoseResult^TransferReason^TransferTarget^CaseAbstract^Attentions^Remark^SendUnitCode^AcceptUnitCode^bDeleteFlag^OldRecordRowId^FeeTypeDR^FeeTypeDRName^BackDate^BackCaseInfo",count)
      k json
      d result.Close()
      
      Quit resultString
}

/// Creator: lyy
/// CreatDate：2010-04-
/// Description:添加转诊登记表
/// Table：PersonTransfer
/// Input: PersonTransfer
/// Output：
/// Return：
/// Others：
ClassMethod Insert(PersonRowId As %Integer, TransferStatusDR As %Integer, TransferTypeDR As %Integer, SendUnit As %String, PatientName As %String, SexDR As %Integer, Birth As %Date, CaseBookNumber As %String, TelNumber As %String, HomePlace As %String, SendDepartment As %String, SendLeader As %String, SendDoctor As %String, SendDate As %Date, SendDoctNumber As %String, AcceptUnit As %String, AcceptDepartment As %String, AcceptLeader As %String, AcceptDoctor As %String, StartAcceptDate As %Date, EndAcceptDate As %Date, AcceptDoctNumber As %String, AcceptNumberDay1 As %String, AcceptNumberDay2 As %String, AcceptNumberNight As %String, AuditMan As %String, AuditDate As %Date, ChiefComplaint As %String, DoctorSay As %String, DiseaseHistory As %String, PersonHistory As %String, FamilyHistory As %String, Suggestion As %String, DiagnoseResult As %String, TransferReason As %String, TransferTarget As %String, CaseAbstract As %String, Attentions As %String, Remark As %String, SendUnitCode As %String, AcceptUnitCode As %String, bDeleteFlag As %String, OldRecordRowId As %Integer, FeeTypeDR As %Integer, BackDate As %Date, BackCaseInfo As %String) As %String
{
      s tempPersonTransfer=""
      s tempPersonTransfer=##class(CHSS.PersonTransfer).%New()
      q:(tempPersonTransfer="") 0
                 
	  
      i PersonRowId '= "" d
      .s PersonRowIdobj=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
      .s tempPersonTransfer.PersonRowId=PersonRowIdobj

      i TransferStatusDR="" s TransferStatusDR="1"
      i TransferStatusDR '= "" d
      .//s TransferStatusDRobj=##class(CHSS.DictTransferStatus).%OpenId(TransferStatusDR)
      .//s tempPersonTransfer.TransferStatusDR=TransferStatusDRobj
      .s tempPersonTransfer.TransferStatusDR=TransferStatusDR
      
      
      i TransferTypeDR="" s TransferTypeDR="1"
      i TransferTypeDR '= "" d
      .//s TransferTypeDRobj=##class(CHSS.DictTransferType).%OpenId(TransferTypeDR)
      .//s tempPersonTransfer.TransferTypeDR=TransferTypeDRobj
      .s tempPersonTransfer.TransferTypeDR=TransferTypeDR
      
      s tempPersonTransfer.SendUnit = SendUnit
      s tempPersonTransfer.PatientName = PatientName
      
      
      i SexDR '= "" d
	  .s SexDRobj=##class(User.CTSex).%OpenId(SexDR)
	  .s tempPersonTransfer.SexDR=SexDRobj
            
      
      i Birth '= "" d
      .s Birth=$zdh(Birth ,3)
      s tempPersonTransfer.Birth=Birth
      
      s tempPersonTransfer.CaseBookNumber = CaseBookNumber
      s tempPersonTransfer.TelNumber = TelNumber
      s tempPersonTransfer.HomePlace = HomePlace
      s tempPersonTransfer.SendDepartment = SendDepartment
      s tempPersonTransfer.SendLeader = SendLeader
      s tempPersonTransfer.SendDoctor = SendDoctor
      
      i SendDate '= "" d
      .s SendDate=$zdh(SendDate ,3)
      s tempPersonTransfer.SendDate=SendDate
      
      s tempPersonTransfer.SendDoctNumber = SendDoctNumber
      s tempPersonTransfer.AcceptUnit = AcceptUnit
      s tempPersonTransfer.AcceptDepartment = AcceptDepartment
      s tempPersonTransfer.AcceptLeader = AcceptLeader
      s tempPersonTransfer.AcceptDoctor = AcceptDoctor
            
      i StartAcceptDate '= "" d
      .s StartAcceptDate=$zdh(StartAcceptDate ,3)
      s tempPersonTransfer.StartAcceptDate=StartAcceptDate
           
      i EndAcceptDate '= "" d
      .s EndAcceptDate=$zdh(EndAcceptDate ,3)
      s tempPersonTransfer.EndAcceptDate=EndAcceptDate
      
      
      s tempPersonTransfer.AcceptDoctNumber = AcceptDoctNumber
      s tempPersonTransfer.AcceptNumberDay1 = AcceptNumberDay1
      s tempPersonTransfer.AcceptNumberDay2 = AcceptNumberDay2
      s tempPersonTransfer.AcceptNumberNight = AcceptNumberNight
      s tempPersonTransfer.AuditMan = AuditMan
            
      i AuditDate '= "" d
      .s AuditDate=$zdh(AuditDate ,3)
      s tempPersonTransfer.AuditDate=AuditDate
      
      s tempPersonTransfer.ChiefComplaint = ChiefComplaint
      s tempPersonTransfer.DoctorSay = DoctorSay
      s tempPersonTransfer.DiseaseHistory = DiseaseHistory
      s tempPersonTransfer.PersonHistory = PersonHistory
      s tempPersonTransfer.FamilyHistory = FamilyHistory
      s tempPersonTransfer.Suggestion = Suggestion
      s tempPersonTransfer.DiagnoseResult = DiagnoseResult
      s tempPersonTransfer.TransferReason = TransferReason
      s tempPersonTransfer.TransferTarget = TransferTarget
      s tempPersonTransfer.CaseAbstract = CaseAbstract
      s tempPersonTransfer.Attentions = Attentions
      s tempPersonTransfer.Remark = Remark
      s tempPersonTransfer.SendUnitCode = SendUnitCode
      s tempPersonTransfer.AcceptUnitCode = AcceptUnitCode
      s tempPersonTransfer.bDeleteFlag = bDeleteFlag
      s tempPersonTransfer.OldRecordRowId = OldRecordRowId
     
       
	   

      i FeeTypeDR '= "" d
      .s FeeTypeDRRobj=##class(CHSS.DictMedicalInsuranceType).%OpenId(FeeTypeDR)
      .s tempPersonTransfer.FeeTypeDR=FeeTypeDRRobj
      
      i BackDate '= "" d
      .s BackDate=$zdh(BackDate ,3)
      s tempPersonTransfer.BackDate=BackDate
      
      s tempPersonTransfer.BackCaseInfo = BackCaseInfo

        
      s result=""
      s result=tempPersonTransfer.%Save()
      
      Set resultString = ""
      
      
      i result = "1" d
      .s resultString = "{""success"":""true"",""info"":"_tempPersonTransfer.%Id()_"}"
      .///w "{""success"":""true"",""info"":"_tempPersonTransfer.%Id()_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      .///w "{""success"":""false"",""info"":""数据保存出错!""}"
      .
      q resultString
}

/// Creator: lyy
/// CreatDate：2010-04-
/// Description:更新转诊登记表
/// Table：PersonTransfer
/// Input: PersonTransfer
/// Output：
/// Return：
/// Others：
ClassMethod Update(TransferRowId As %Integer, PersonRowId As %Integer, TransferStatusDR As %Integer, TransferTypeDR As %Integer, SendUnit As %String, PatientName As %String, SexDR As %Integer, Birth As %Date, CaseBookNumber As %String, TelNumber As %String, HomePlace As %String, SendDepartment As %String, SendLeader As %String, SendDoctor As %String, SendDate As %Date, SendDoctNumber As %String, AcceptUnit As %String, AcceptDepartment As %String, AcceptLeader As %String, AcceptDoctor As %String, StartAcceptDate As %Date, EndAcceptDate As %Date, AcceptDoctNumber As %String, AcceptNumberDay1 As %String, AcceptNumberDay2 As %String, AcceptNumberNight As %String, AuditMan As %String, AuditDate As %Date, ChiefComplaint As %String, DoctorSay As %String, DiseaseHistory As %String, PersonHistory As %String, FamilyHistory As %String, Suggestion As %String, DiagnoseResult As %String, TransferReason As %String, TransferTarget As %String, CaseAbstract As %String, Attentions As %String, Remark As %String, SendUnitCode As %String, AcceptUnitCode As %String, bDeleteFlag As %String, OldRecordRowId As %Integer, FeeTypeDR As %Integer, BackDate As %Date, BackCaseInfo As %String) As %String
{
  
      q:($d(TransferRowId)=0)||(TransferRowId="")
      
      s tempPersonTransfer="",result=""
      s tempPersonTransfer=##class(CHSS.PersonTransfer).%OpenId(TransferRowId)
      q:(tempPersonTransfer="") 0
       
       
      i PersonRowId '= "" d
      .s PersonRowIdobj=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
      .s tempPersonTransfer.PersonRowId=PersonRowIdobj
 

	  i TransferStatusDR '= "" d
      .//s TransferStatusDRobj=##class(CHSS.DictTransferStatus).%OpenId(TransferStatusDR)
      .//s tempPersonTransfer.TransferStatusDR=TransferStatusDRobj
      .s tempPersonTransfer.TransferStatusDR=TransferStatusDR
      
      
      i TransferTypeDR '= "" d
      .//s TransferTypeDRobj=##class(CHSS.DictTransferType).%OpenId(TransferTypeDR)
      .//s tempPersonTransfer.TransferTypeDR=TransferTypeDRobj
      .s tempPersonTransfer.TransferTypeDR=TransferTypeDR
      
      s tempPersonTransfer.SendUnit = SendUnit
      s tempPersonTransfer.PatientName = PatientName
      
      
      i SexDR '= "" d
	  .s SexDRobj=##class(User.CTSex).%OpenId(SexDR)
	  .s tempPersonTransfer.SexDR=SexDRobj
            
      
      i Birth '= "" d
      .s Birth=$zdh(Birth ,3)
      s tempPersonTransfer.Birth=Birth
      
      s tempPersonTransfer.CaseBookNumber = CaseBookNumber
      s tempPersonTransfer.TelNumber = TelNumber
      s tempPersonTransfer.HomePlace = HomePlace
      s tempPersonTransfer.SendDepartment = SendDepartment
      s tempPersonTransfer.SendLeader = SendLeader
      s tempPersonTransfer.SendDoctor = SendDoctor
      
      i SendDate '= "" d
      .s SendDate=$zdh(SendDate ,3)
      s tempPersonTransfer.SendDate=SendDate
      
      s tempPersonTransfer.SendDoctNumber = SendDoctNumber
      s tempPersonTransfer.AcceptUnit = AcceptUnit
      s tempPersonTransfer.AcceptDepartment = AcceptDepartment
      s tempPersonTransfer.AcceptLeader = AcceptLeader
      s tempPersonTransfer.AcceptDoctor = AcceptDoctor
            
      i StartAcceptDate '= "" d
      .s StartAcceptDate=$zdh(StartAcceptDate ,3)
      s tempPersonTransfer.StartAcceptDate=StartAcceptDate
           
      i EndAcceptDate '= "" d
      .s EndAcceptDate=$zdh(EndAcceptDate ,3)
      s tempPersonTransfer.EndAcceptDate=EndAcceptDate
      
      
      s tempPersonTransfer.AcceptDoctNumber = AcceptDoctNumber
      s tempPersonTransfer.AcceptNumberDay1 = AcceptNumberDay1
      s tempPersonTransfer.AcceptNumberDay2 = AcceptNumberDay2
      s tempPersonTransfer.AcceptNumberNight = AcceptNumberNight
      s tempPersonTransfer.AuditMan = AuditMan
            
      i AuditDate '= "" d
      .s AuditDate=$zdh(AuditDate ,3)
      s tempPersonTransfer.AuditDate=AuditDate
      
      s tempPersonTransfer.ChiefComplaint = ChiefComplaint
      s tempPersonTransfer.DoctorSay = DoctorSay
      s tempPersonTransfer.DiseaseHistory = DiseaseHistory
      s tempPersonTransfer.PersonHistory = PersonHistory
      s tempPersonTransfer.FamilyHistory = FamilyHistory
      s tempPersonTransfer.Suggestion = Suggestion
      s tempPersonTransfer.DiagnoseResult = DiagnoseResult
      s tempPersonTransfer.TransferReason = TransferReason
      s tempPersonTransfer.TransferTarget = TransferTarget
      s tempPersonTransfer.CaseAbstract = CaseAbstract
      s tempPersonTransfer.Attentions = Attentions
      s tempPersonTransfer.Remark = Remark
      s tempPersonTransfer.SendUnitCode = SendUnitCode
      s tempPersonTransfer.AcceptUnitCode = AcceptUnitCode
      s tempPersonTransfer.bDeleteFlag = bDeleteFlag
      s tempPersonTransfer.OldRecordRowId = OldRecordRowId
      
      i FeeTypeDR '= "" d
      .s FeeTypeDRRobj=##class(CHSS.DictMedicalInsuranceType).%OpenId(FeeTypeDR)
      .s tempPersonTransfer.FeeTypeDR=FeeTypeDRRobj
    
      
      i BackDate '= "" d
      .s BackDate=$zdh(BackDate ,3)
      s tempPersonTransfer.BackDate=BackDate
      
      s tempPersonTransfer.BackCaseInfo = BackCaseInfo

             
      s result=""
      s result=tempPersonTransfer.%Save()
           
      Set resultString = ""
      
      
      i result = "1" d
      .s resultString = "{""success"":""true"",""info"":"_TransferRowId_"}"
      .///w "{""success"":""true"",""info"":"_TransferRowId_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      .///w "{""success"":""false"",""info"":""数据保存出错!""}"
      q resultString
}

/// Creator: lyy
/// CreatDate：2010-04-
/// Description:删除转诊登记表
/// Table：PersonTransfer
/// Input: TransferRowId
/// Output：
/// Return：
/// Others：
ClassMethod Delete(TransferRowId As %String) As %String
{
      //增加控制:审批后禁止删除
      Set resultString = ""
   	  s transStatusDR=""
   	  &sql(select TransferStatusDR into :transStatusDR from CHSS.PersonTransfer where %ID=:TransferRowId)
    
      i SQLCODE d   //不存在
      .s resultString = "{""success"":""false"",""info"":""转诊数据不存在!""}"
      e  d           
      .
      .i transStatusDR'="1" d 
      ..s resultString = "{""success"":""false"",""info"":""当前状态禁止删除!""}"
      .e  d
      ..&sql(delete from CHSS.PersonTransfer where %ID=:TransferRowId)
      ..s result=SQLCODE
      ..i result = "0" d
      ...s resultString = "{""success"":""true"",""info"":"_TransferRowId_"}"
      ..e  d
      ...s resultString = "{""success"":""false"",""info"":""数据删除出错!""}"
      
      q resultString
}

/// Creator: lyy
/// CreatDate：2010-04-
/// Description:审核转诊登记表
/// Table：PersonTransfer
/// Input: PersonTransfer
/// Output：
/// Return：
/// Others：
ClassMethod Audit(TransferRowId As %Integer, AuditMan As %String) As %String
{
      ///判断是否符合可审批的条件
      ///
      s transStatus=""
      &SQL(select TransferStatusDR into :transStatus from CHSS.PersonTransfer where %ID=:TransferRowId)
      i SQLCODE s resultString = "{""success"":""false"",""info"":""转诊单不存在!""}" q resultString
      //
      i transStatus'=1  d
      .s resultString = "{""success"":""false"",""info"":""当前状态禁止审核!""}" 
      e  d
      .&sql(update CHSS.PersonTransfer set TransferStatusDR = 2, AuditMan =:AuditMan, AuditDate = CURRENT_DATE  where %ID=:TransferRowId)
      .s result=SQLCODE
      .i result d
      ..s resultString = "{""success"":""false"",""info"":""数据审核出错!""}"
      .e  d
      ..s ret=..SendTargets(TransferRowId,AuditMan)
      ..i ret="True" d
      ...s resultString = "{""success"":""true"",""info"":"_TransferRowId_"}"
      ..e  d
      ...s resultString = "{""success"":""false"",""info"":""数据审核出错!""}"
    
      q resultString
}

/// 将转诊单信息发送到服务平台
/// TransferRowId : 转诊单Rowid
/// AuditMan : 审核人
/// 
ClassMethod SendTargets(TransferRowId As %Integer, AuditMan As %String) As %String
{
 //
 s perTransObj=##class(CHSS.PersonTransfer).%OpenId(TransferRowId)
 s phrID=perTransObj.PersonRowIdGetObjectId()
 ;w phrID,!
 s auditUserName=perTransObj.AuditMan   //审核人
 s instanceType=perTransObj.InstanceType   //转诊实体类型
 s targetsType=perTransObj.TargetsType   //转诊目标类型
 s recvDept=perTransObj.SendDepartment   //目标科室
 s TransferReason=perTransObj.TransferReason  //转诊原因
 s SendDoctor=perTransObj.SendDoctor
 s SendDoctNumber=perTransObj.SendDoctNumber                            
                                      
    s userid=%session.Get("LOGON.USERID")  i userid=""  s userid=1
	s communityCode=##class(CHSSWeb.CommunityService).GetCommunityCode(userid)
	s communityName=""
	&sql(select CommunityName into :communityName from CHSS.DictHospital where CommunityCode=:communityCode)
	 
	 //s personId=
	 s perObj=##class(CHSS.PersonHealthRecordMain).%OpenId(phrID)
	 s personCode=perObj.PersonCode
	 s personName=perObj.PersonName
 	 s dob=perObj.Birth
 	 i dob'="" s dob=$zd(dob,3)
 	 s addr=..getAddr(perObj.%Id())
 	 s tel=perObj.LinkManPhone
 	 s sex=perObj.SexDR.CTSEXDesc
 	 
 	 s nation=perObj.NationDR.CTNATDesc
 	 
 	 s height=""
 	 s weight=""
 	 s education=perObj.EducationDR.EDUDesc   // 文化程度
	s insuType=perObj.MedicalInsuranceTypeDR.Description

   //准备--PatientData
     s obj=##class(CHSSWeb.TrAdm.PatientData).%New()
     s obj.Name=personName
     s obj.Address=addr
     s obj.TEL=tel
     s obj.HealthRecordID=personCode
     s obj.PatientInserialID=""
     s obj.BirthDay=dob
     s obj.Sex=sex
     s obj.Nation=nation
     s obj.culturalDegree=education
     s obj.AdmReason=insuType
     s obj.Height=height
     s obj.Weight=weight
     s obj.BMI=""
     s PatientDataString=""
	 s ret=obj.XMLExportToString(.PatientDataString)
     
   //准备-TransferData
   	s objx=##class(CHSSWeb.TrAdm.TransferData).%New()
   	s objx.SourceLocation=communityName
   	s objx.TransferDate=+$h
   	s objx.TransferTime=$p($h,",",2)
   	s objx.TargetLocation=recvDept
   	s objx.TransferReason=TransferReason
   	s objx.TransferUserID=SendDoctor
   	s objx.TransferContract=SendDoctNumber
    s transDataString=""
    s ret=objx.XMLExportToString(.transDataString)
	
   //准备-PatientEPRData
   //
   // 这一部分暂时没有写...
   // 
	
     //将转诊信息发到公共服务器
	 s transAdmObj=##class(TransferAdm.TransferInfoSoap).%New()
	 s dataObj=##class(TransferAdm.EPublicECRecord).%New()
	 s dataObj.PatientInserialID=personCode   //存放健康档案号 - 似乎应存放EPMI索引号???
	 s dataObj.SourceLocationID=communityCode
	 s dataObj.TargetLocationID="9999"
	 s dataObj.CreateDate=+$h
	 s dataObj.CreateTime=$p($h,",",2)
	 s dataObj.CreateUser=auditUserName
	 s dataObj.ModifyDate=+$h
	 s dataObj.ModifyTime=$p($h,",",2)
	 s dataObj.ModifyUser=auditUserName
	 s dataObj.Status="1"   		 // (申请1，分诊2，接诊3,撤销4)(申请，转回5)
	 //s dataObj.InstanceType=instanceType   //转诊类型(检查检验申请InstanceType =“checkup”，真正转诊InstanceType =“Transfer”)
     s dataObj.InstanceType="Transfer"
     s dataObj.TransferType="1"     	  //转诊单类型(社区向专科1、专科向社区2)
     
     //s dataObj.TargetsType=targetsType    			 //  转诊目标类型(门诊OP住院IP)
      //暂用常量OP
     s dataObj.TargetsType="OP"   
     
     s dataObj.TransferInserialID=TransferRowId     //转诊单流水号(用就诊号?)
     s dataObj.PatientData=PatientDataString
     s dataObj.TransferData=transDataString
     s dataObj.PatientEPRData=""
     
	 s ret=transAdmObj.SaveRstDataFromA(dataObj)
	 q ret
}

/// Creator: lyy
/// CreatDate：2010-05-
/// Description:转出月度汇总
/// Table：PersonTransfer
/// Input: PersonTransfer
/// Output：
/// Return：
/// Others：
ClassMethod ListMonthOut(CommunityCode As %String, start As %Integer, limit As %Integer, sort As %String, whereStr As %String) As %String
{
      
    s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select TransferRowId from CHSS.PersonTransfer where TransferTypeDR=1 and PersonRowId in (select PersonRowId from CHSS.PersonHealthRecordMain where CommunityCode ='"_CommunityCode_"') "_whereStr
    
       
    d result.Prepare(sqlStr)
	d result.Execute()
	
	Set start=$G(start)
	Set limit=$G(limit)
	Set sort=$G(sort)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit
	
	Set tmp = ""
	
	Set json = ##class(Code.JsonObj).%New()

	While(result.Next())
	{
      
      s TransferRowId = result.Data("TransferRowId")     
      
         
      s tempPersonTransfer=##class(CHSS.PersonTransfer).%OpenId(TransferRowId)
      
      i tempPersonTransfer.PersonRowId '= "" d
      .s PersonRowId = tempPersonTransfer.PersonRowId.%Id()
       
      s PatientName = tempPersonTransfer.PatientName
                
      set SexDRName = ""
      set SexDR = ""
      i tempPersonTransfer.SexDR '= "" d
      .s SexDR = tempPersonTransfer.SexDR.%Id()
      .s SexDRName = tempPersonTransfer.SexDR.CTSEXDesc
          
      set Birth = tempPersonTransfer.Birth
      i Birth '= "" d
      .s Birth = $zd(Birth,3)
      
      s AcceptUnit = tempPersonTransfer.AcceptUnit
      
      set SendDate = tempPersonTransfer.SendDate
      i SendDate '= "" d
      .s SendDate = $zd(SendDate,3)
   
      s SendDoctor = tempPersonTransfer.SendDoctor
               
      Set tmp = PersonRowId_"^"_PatientName_"^"_SexDRName_"^"_Birth_"^"_AcceptUnit_"^"_SendDate_"^"_SendDoctor

	  s count = count+1
	  i (count>start)&(count<=end) d
	  .d json.InsertRowData(tmp)
	  
      
	}
      
      Set resultString = json.getJsonData("PersonRowId^PatientName^SexDRName^Birth^AcceptUnit^SendDate^SendDoctor",count)
      k json
      d result.Close()
      
      Quit resultString
}

/// Creator: lyy
/// CreatDate：2010-05-
/// Description:转诊年度汇总
/// Table：PersonTransfer
/// Input: PersonTransfer
/// Output：
/// Return：
/// Others：
ClassMethod ListYear(CommunityCode As %String, start As %Integer, limit As %Integer, sort As %String, whereStr As %String) As %String
{
    
    s result = ##class(%Library.ResultSet).%New()
    
    s sqlStr = "select '转出' As Direction, nvl(sum(JanNum),0) As JanNum, nvl(sum(FebNum),0) As FebNum, nvl(sum(MarNum),0) As MarNum, nvl(sum(AprNum),0) As AprNum, nvl(sum(MayNum),0) As MayNum, nvl(sum(JunNum),0) As JunNum, nvl(sum(JulNum),0) As JulNum, nvl(sum(AugNum),0) As AugNum, nvl(sum(SepNum),0) As SepNum, nvl(sum(OctNum),0) As OctNum, nvl(sum(NovNum),0) As NovNum, nvl(sum(DecNum),0) As DecNum, nvl(sum(Num),0) As Num from ( select decode({fn MONTH(SendDate)}, 1, 1, 0) as JanNum, decode({fn MONTH(SendDate)}, 2, 1, 0) as FebNum, decode({fn MONTH(SendDate)}, 3, 1, 0) as MarNum, decode({fn MONTH(SendDate)}, 4, 1, 0) as AprNum, decode({fn MONTH(SendDate)}, 5, 1, 0) as MayNum, decode({fn MONTH(SendDate)}, 6, 1, 0) as JunNum, decode({fn MONTH(SendDate)}, 7, 1, 0) as JulNum, decode({fn MONTH(SendDate)}, 8, 1, 0) as AugNum, decode({fn MONTH(SendDate)}, 9, 1, 0) as SepNum, decode({fn MONTH(SendDate)}, 10, 1, 0) as OctNum, decode({fn MONTH(SendDate)}, 11, 1, 0) as NovNum, decode({fn MONTH(SendDate)}, 12, 1, 0) as DecNum, 1 as Num from CHSS.PersonTransfer where TransferTypeDR=1 and PersonRowId in (select PersonRowId from CHSS.PersonHealthRecordMain where CommunityCode ='"_CommunityCode_"') "_whereStr_" )"
    
    s sqlStr = sqlStr_" union select '接收' As Direction, nvl(sum(JanNum),0) As JanNum, nvl(sum(FebNum),0) As FebNum, nvl(sum(MarNum),0) As MarNum, nvl(sum(AprNum),0) As AprNum, nvl(sum(MayNum),0) As MayNum, nvl(sum(JunNum),0) As JunNum, nvl(sum(JulNum),0) As JulNum, nvl(sum(AugNum),0) As AugNum, nvl(sum(SepNum),0) As SepNum, nvl(sum(OctNum),0) As OctNum, nvl(sum(NovNum),0) As NovNum, nvl(sum(DecNum),0) As DecNum, nvl(sum(Num),0) As Num from ( select decode({fn MONTH(SendDate)}, 1, 1, 0) as JanNum, decode({fn MONTH(SendDate)}, 2, 1, 0) as FebNum, decode({fn MONTH(SendDate)}, 3, 1, 0) as MarNum, decode({fn MONTH(SendDate)}, 4, 1, 0) as AprNum, decode({fn MONTH(SendDate)}, 5, 1, 0) as MayNum, decode({fn MONTH(SendDate)}, 6, 1, 0) as JunNum, decode({fn MONTH(SendDate)}, 7, 1, 0) as JulNum, decode({fn MONTH(SendDate)}, 8, 1, 0) as AugNum, decode({fn MONTH(SendDate)}, 9, 1, 0) as SepNum, decode({fn MONTH(SendDate)}, 10, 1, 0) as OctNum, decode({fn MONTH(SendDate)}, 11, 1, 0) as NovNum, decode({fn MONTH(SendDate)}, 12, 1, 0) as DecNum, 1 as Num from CHSS.PersonTransfer where TransferTypeDR=2 and PersonRowId in (select PersonRowId from CHSS.PersonHealthRecordMain where CommunityCode ='"_CommunityCode_"') "_whereStr_" )" 

    s sqlStr = sqlStr_" union select '合计' As Direction, nvl(sum(JanNum),0) As JanNum, nvl(sum(FebNum),0) As FebNum, nvl(sum(MarNum),0) As MarNum, nvl(sum(AprNum),0) As AprNum, nvl(sum(MayNum),0) As MayNum, nvl(sum(JunNum),0) As JunNum, nvl(sum(JulNum),0) As JulNum, nvl(sum(AugNum),0) As AugNum, nvl(sum(SepNum),0) As SepNum, nvl(sum(OctNum),0) As OctNum, nvl(sum(NovNum),0) As NovNum, nvl(sum(DecNum),0) As DecNum, nvl(sum(Num),0) As Num from ( select decode({fn MONTH(SendDate)}, 1, 1, 0) as JanNum, decode({fn MONTH(SendDate)}, 2, 1, 0) as FebNum, decode({fn MONTH(SendDate)}, 3, 1, 0) as MarNum, decode({fn MONTH(SendDate)}, 4, 1, 0) as AprNum, decode({fn MONTH(SendDate)}, 5, 1, 0) as MayNum, decode({fn MONTH(SendDate)}, 6, 1, 0) as JunNum, decode({fn MONTH(SendDate)}, 7, 1, 0) as JulNum, decode({fn MONTH(SendDate)}, 8, 1, 0) as AugNum, decode({fn MONTH(SendDate)}, 9, 1, 0) as SepNum, decode({fn MONTH(SendDate)}, 10, 1, 0) as OctNum, decode({fn MONTH(SendDate)}, 11, 1, 0) as NovNum, decode({fn MONTH(SendDate)}, 12, 1, 0) as DecNum, 1 as Num from CHSS.PersonTransfer where PersonRowId in (select PersonRowId from CHSS.PersonHealthRecordMain where CommunityCode ='"_CommunityCode_"') "_whereStr_" )"

   	
    d result.Prepare(sqlStr)
	d result.Execute()
	   
    Set start=$G(start)
	Set limit=$G(limit)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit  
	
	Set json = ##class(Code.JsonObj).%New()
    Set tmp = ""
    
       	
	While(result.Next())
	{
		Set tmp = result.Data("Direction")_"^"_result.Data("JanNum")_"^"_result.Data("FebNum")_"^"_result.Data("MarNum")_"^"_result.Data("AprNum")_"^"_result.Data("MayNum")_"^"_result.Data("JunNum")_"^"_result.Data("JulNum")_"^"_result.Data("AugNum")_"^"_result.Data("SepNum")_"^"_result.Data("OctNum")_"^"_result.Data("NovNum")_"^"_result.Data("DecNum")_"^"_result.Data("Num")

    	Set count=count+1
    	If (count>start)&(count<=end) d
    	.d json.InsertRowData(tmp)
    }
    
        
    Set resultString = json.getJsonData("Direction^JanNum^FebNum^MarNum^AprNum^MayNum^JunNum^JulNum^AugNum^SepNum^OctNum^NovNum^DecNum^Sum",count)
    k json
    d result.Close()
     
    Quit resultString
}

ClassMethod getStatusDesc(status As %String) As %String
{
	q $case(status,"1":"初始","2":"审核","3":"其他",:"")
}

ClassMethod getTypeDesc(status As %String) As %String
{
	q $case(status,"1":"转出","2":"接收","3":"其他",:"")
}

/// 根据居民id 取家庭地址
/// 
ClassMethod getAddr(personId As %String) As %String
{
	//找居民档案id
	
	s obj=##class(CHSS.PersonHealthRecordMain).%OpenId(personId)
	s tempFamily=obj.FamilyRowId
	
	s FamilyAddress=""
	i tempFamily.ProvinceDR '= "" d
	.s FamilyAddress = FamilyAddress_tempFamily.ProvinceDR.Description
	i tempFamily.CityDR '= "" d
	.s FamilyAddress = FamilyAddress_tempFamily.CityDR.Description
	i tempFamily.SectionDR '= "" d
	.s FamilyAddress = FamilyAddress_tempFamily.SectionDR.Description
	i tempFamily.StreetDR '= "" d
	.s FamilyAddress = FamilyAddress_tempFamily.StreetDR.Description
	;i tempFamily.VillageDR '= "" d
	;.s FamilyAddress = FamilyAddress_tempFamily.VillageDR.Description
	s FamilyAddress = FamilyAddress_tempFamily.VillageName
	i tempFamily.DoorPlate '= "" d
	.s FamilyAddress = FamilyAddress_tempFamily.DoorPlate
	d obj.%Close()
	q FamilyAddress
}

/// 调出所有检验检查的结果
/// author :Zhao Wenhua
ClassMethod lookupLab(TransferRowId As %String) As %String
{
	s result=##class(%ResultSet).%New("CHSSWeb.PersonTransferService:GetRptList")
	d result.Execute(TransferRowId)
	
	s count=0
	s mess=""
	while (result.Next())
	{
		s ReportsType=result.Get("ReportsType")
		s CreateDate=result.Get("CreateDate")
		s CreateTime=result.Get("CreateTime")
		s ReportItemDesc=result.Get("ReportItemDesc")
		s DownLoadDate=result.Get("DownLoadDate")
		s ID =result.Get("ID")
		
		s count=count+1
		i (mess'="") s mess=mess_","
		s mess=mess_"{"_"ReportsType"_":"_""""_ReportsType_""""
		s mess=mess_","_"CreateDate"_":"_""""_CreateDate_""""
		s mess=mess_","_"CreateTime"_":"_""""_CreateTime_""""
		s mess=mess_","_"ReportItemDesc"_":"_""""_ReportItemDesc_""""		
		s mess=mess_","_"DownLoadDate"_":"_""""_DownLoadDate_""""		
		s mess=mess_","_"ID"_":"_""""_ID_""""		
		s mess=mess_"}"
	}
	 s mess="["_mess_"]"
 
	 s mess="{totalCount"_":"_""""_count_""""_","_"topics"_":"_mess_"}"
	 q $tr(mess,$c(13,10))
}

/// 取出检验检查项目的明细内容
/// 
ClassMethod lookupLabDet(rowid As %String) As %String
{
	s result=##class(%ResultSet).%New("CHSSWeb.PersonTransferService:GetRptResultByID")
	d result.Execute(rowid)
	
	s count=0
	s mess=""
	while (result.Next())
	{
		s LabItemDesc=result.Get("LabItemDesc")
		s LabRet=result.Get("LabRet")
		s Normal=result.Get("Normal")
		s LabUom=result.Get("LabUom")
		s OrderName=result.Get("OrderName")
		s ExamDesc=result.Get("ExamDesc")
		s strResult=result.Get("strResult")		
		
		s count=count+1
		i (mess'="") s mess=mess_","
		s mess=mess_"{"_"LabItemDesc"_":"_""""_LabItemDesc_""""
		s mess=mess_","_"LabRet"_":"_""""_LabRet_""""
		s mess=mess_","_"Normal"_":"_""""_Normal_""""
		s mess=mess_","_"LabUom"_":"_""""_LabUom_""""		
		s mess=mess_","_"OrderName"_":"_""""_OrderName_""""	
		s mess=mess_","_"ExamDesc"_":"_""""_ExamDesc_""""	
		s mess=mess_","_"OrderName"_":"_""""_OrderName_""""	
		s mess=mess_","_"strResult"_":"_""""_strResult_""""		
		s mess=mess_"}"
	}
	 s mess="["_mess_"]"
 
	 s mess="{totalCount"_":"_""""_count_""""_","_"topics"_":"_mess_"}"
	 q $tr(mess,$c(13,10))
}

ClassMethod lookupInfo(TransferRowId As %String) As %String
{
    s userid=%session.Get("LOGON.USERID")
    s ^TMP("zhwh",138)=userid
    i $G(userid)="" s userid=1
    
    //根据用户
    s communityCode=##class(CHSSWeb.CommunityService).GetCommunityCode(userid)
    s TransferRowId=communityCode_"-"_TransferRowId
 	s result=..ReceiveAdm(TransferRowId)
 	q result
}

ClassMethod GetRptListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRptListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCTransRptQuery","GetRptList",10,2)
ClassMethod GetRptListExecute(ByRef qHandle As %Binary, strTransID As %String, strStatus As %String = "0") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if strTransID="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ServerObj=##class(TransferAdm.TransferInfoSoap).%New()
	s ReportsRecordObj=##class(TransferAdm.EPublicReportsRecord).%New()
	s ReportsRecordObj=ServerObj.GetRptByTransInsAndStatus(strTransID,strStatus)
	for i=1:1:ReportsRecordObj.ID.Count() {
		s ReportsType=ReportsRecordObj.ReportsType.GetAt(i)
		s CreateDate=ReportsRecordObj.CreateDate.GetAt(i)
		s CreateTime=ReportsRecordObj.CreateTime.GetAt(i)
		s ReportItemDesc=ReportsRecordObj.ReportItemDesc.GetAt(i)
		s DownLoadDate=ReportsRecordObj.DownLoadDate.GetAt(i)
		s ID=ReportsRecordObj.ID.GetAt(i)
		;s ReportData=ReportsRecordObj.ReportData.GetAt(i)
		d OutRptList
	}
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutRptList
	set Data=$lb(ReportsType,CreateDate,CreateTime,ReportItemDesc,DownLoadDate,ID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetRptListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRptListExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetRptList(strTransID As %String) As %Query(ROWSPEC = "ReportsType,CreateDate,CreateTime,ReportItemDesc,DownLoadDate,ID")
{
}

ClassMethod GetRptResultByIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRptResultByIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// cteator:guorongyong
/// date:20100704
/// desc:通过报告Rowid得到相应的报告结果
/// d ##class(%ResultSet).RunQuery("web.DHCTransRptQuery","GetRptResultByID","1||17")
ClassMethod GetRptResultByIDExecute(ByRef qHandle As %Binary, RptRowid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if RptRowid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ServerObj=##class(TransferAdm.TransferInfoSoap).%New()
	s ReportsRecordObj=##class(TransferAdm.EPublicReportsRecord).%New()
	s ReportsRecordObj=ServerObj.GetRptByRptRowid(RptRowid)
	
	;初始化输出变量
	s LabItemDesc="",LabRet="",Normal="",LabUom="",OrderName="",ExamDesc="",strResult=""
	if ReportsRecordObj.ID.Count()=1 {
		s ReportsType=ReportsRecordObj.ReportsType.GetAt(1)
		s CreateDate=ReportsRecordObj.CreateDate.GetAt(1)
		s CreateTime=ReportsRecordObj.CreateTime.GetAt(1)
		s ReportItemDesc=ReportsRecordObj.ReportItemDesc.GetAt(1)
		s DownLoadDate=ReportsRecordObj.DownLoadDate.GetAt(1)
		s ID=ReportsRecordObj.ID.GetAt(1)
		s ReportData=ReportsRecordObj.ReportData.GetAt(1)
		;解析ReportData
		Set reader = ##class(%XML.Reader).%New()
		s sc=reader.OpenString(ReportData)
		Do reader.Correlate("EPublicResultSet","web.DHCEntity.PCA.EPublicResultSet")
		If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit
		if reader.Next(.object,.sc) {
		    If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit
		}
		b ;分解检验项目
		s EPublicTestObj=##class(web.DHCEntity.PCA.EPublicTest).%New()
		for i=1:1:object.EPublicTestSet.Count() {
			s EPublicTestObj=object.EPublicTestSet.GetAt(i)
			s TestItemObj=##class(web.DHCEntity.PCA.TestItem).%New()
			for j=1:1:EPublicTestObj.TestItemSet.Count() {
				s TestItemObj=EPublicTestObj.TestItemSet.GetAt(j)
				s LabItemDesc=TestItemObj.LabItemDesc
				s LabRet=TestItemObj.LabRet
				s Normal=TestItemObj.Normal
				s LabUom=TestItemObj.LabUom
				d OutRptResult
			}
		}
		b ;分解检查项目
		s EPublicInspectionObj=##class(web.DHCEntity.PCA.EPublicInspection).%New()
		for i=1:1:object.EPublicInspectionSet.Count() {
			s EPublicInspectionObj=object.EPublicInspectionSet.GetAt(i)
			s InspectionItemObj=##class(web.DHCEntity.PCA.InspectionItem).%New()
			for j=1:1:EPublicInspectionObj.InspectionItemSet.Count() {
				s InspectionItemObj=EPublicInspectionObj.InspectionItemSet.GetAt(j)
				s OrderName=InspectionItemObj.OrderName
				s ExamDesc=InspectionItemObj.ExamDesc
				s strResult=InspectionItemObj.strResult
				d OutRptResult
			}
		}
		b ;分解完成
		
	}
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutRptResult
	set Data=$lb(LabItemDesc,LabRet,Normal,LabUom,OrderName,ExamDesc,strResult)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetRptResultByIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRptResultByIDExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetRptResultByID(RptRowid As %String) As %Query(ROWSPEC = "LabItemDesc,LabRet,Normal,LabUom,OrderName,ExamDesc,strResult")
{
}

/// 取回送信息
///  TransferInserialID : "社区代码" + "转诊单流水号"
ClassMethod ReceiveAdm(TransferInserialID As %String) As %String
{
    //s EpisodeID=%request.Get("EpisodeID")
    //s TransferInserialID=%request.Get("TransferInserialID")

    s ObjServer=##class(TransferAdm.TransferInfoSoap).%New()
    s Obj=##class(TransferAdm.EPublicECRecord).%New()
    
    s Obj=ObjServer.GetPublicECRecordBByTransInsID(TransferInserialID)
    s PatientInserialID=Obj.PatientInserialID
	s SourceLocationID=Obj.SourceLocationID
	s TargetLocationID=Obj.TargetLocationID
	s CreateDate=$zd(+$h,3)
	s CreateTime=$zt($p($h,",",2))
	//s CreateUser=$G(%session.Get("LOGON.USERID"))
	//i CreateUser="" s CreateUser=1
	s CreateUser=1 
	s CreateUserName="" i CreateUser'="" s CreateUserName=$P(^SSU("SSUSR",CreateUser),"^",2)
	s ModifyDate=Obj.ModifyDate  i ModifyDate'="" s ModifyDate=$zd(ModifyDate,3)
	s ModifyTime=Obj.ModifyTime i ModifyTime'="" s ModifyTime=$zt(ModifyTime)
	s ModifyUser=Obj.ModifyUser 
	s ModifyUserName="" i ModifyUser'="" s ModifyUserName=$P(^SSU("SSUSR",ModifyUser),"^",2)
	s Status=Obj.Status
	s InstanceType=Obj.InstanceType
	s TransferType=Obj.TransferType
	s TargetsType=Obj.TargetsType
	s TransferInserialID=Obj.TransferInserialID
	
	;解析PatientData
	Set reader = ##class(%XML.Reader).%New()
	s PatientData=Obj.PatientData
	s sc=reader.OpenString(Obj.PatientData)
	//s ^gry("PatientData")=Obj.PatientData
	Do reader.Correlate("PatientData","web.DHCEntity.PCA.PatientData")
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit
	if reader.Next(.object,.sc) {
	    If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit
	}
	s Name=object.Name
	s Address=object.Address
	s TEL=object.TEL
	s HealthRecordID=object.HealthRecordID
	s PatientInserialID=object.PatientInserialID
	s BirthDay=object.BirthDay
	s Sex=object.Sex
	s Nation=object.Nation
	s culturalDegree=object.culturalDegree
	s AdmReason=object.AdmReason
	s Height=object.Height
	s Weight=object.Weight
	s BMI=object.BMI
	s PatData="姓名:"_Name_"  "_"性别:"_Sex_"  "_"出生日期:"_BirthDay_"  "_"联系电话:"_TEL_"  "_"病人类型:"_AdmReason
	s PatData1="健康档案号:"_HealthRecordID_"  "_"地址:"_Address_"  "_"BMI:"_BMI
	s PatData2="民族:"_Nation_"  "_"学历:"_culturalDegree_"  "_"身高:"_Height_"  "_"体重:"_Weight
	s PatData=PatData_","_PatData1_","_PatData2
	
	;w PatData,!
	;w PatData1,!
	//w PatData2,!
	
	;解析TransferData
	s TransferData=Obj.TransferData
	s sc=reader.OpenString(Obj.TransferData)
	Do reader.Correlate("TransferData","web.DHCEntity.PCA.TransferData")
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit
	if reader.Next(.object,.sc) {
	    If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit
	}
	s SourceLocation=object.SourceLocation
	s TransferDate=object.TransferDate
	s TransferTime=object.TransferTime
	s TargetLocation=object.TargetLocation
	s TransferReason=object.TransferReason
	s TransferUserID=object.TransferUserID
	s TransferContract=object.TransferContract
	s TransData="转出站:"_SourceLocation_"  "_"转入站:"_TargetLocation_"  "_"转诊类型:"_TransferReason_"  "_"转诊日期:"_TransferDate_"  "_"转诊时间:"_TransferTime
	
	s EPRDataXMLString=Obj.PatientEPRData
	
	s EPRData=..ReadEPRDataString(EPRDataXMLString)
	
	s PreInfo=$p(EPRData,"^",1)
	s ExamStr=$p(EPRData,"^",2)
	s DiagnoseStr=$p(EPRData,"^",3)
	
	
	s count=0
	s mess=""
		
	s count=count+1
	i (mess'="") s mess=mess_","
	
	s mess=mess_"{"_"PatientInserialID"_":"_""""_PatientInserialID_""""
	s mess=mess_","_"Name"_":"_""""_Name_""""
	s mess=mess_","_"Sex"_":"_""""_Sex_""""
	s mess=mess_","_"SourceLocationID"_":"_""""_SourceLocationID_""""
	s mess=mess_","_"TargetLocationID"_":"_""""_TargetLocationID_""""
	s mess=mess_","_"CreateDate"_":"_""""_CreateDate_""""		
	s mess=mess_","_"CreateTime"_":"_""""_CreateTime_""""	
	s mess=mess_","_"CreateUser"_":"_""""_CreateUser_""""	
	s mess=mess_","_"ModifyDate"_":"_""""_ModifyDate_""""	
	s mess=mess_","_"ModifyTime"_":"_""""_ModifyTime_""""		
	s mess=mess_","_"ModifyUser"_":"_""""_ModifyUser_""""	
	s mess=mess_","_"Status"_":"_""""_Status_""""	
	s mess=mess_","_"InstanceType"_":"_""""_InstanceType_""""	
	s mess=mess_","_"TransferType"_":"_""""_TransferType_""""	
	s mess=mess_","_"TargetsType"_":"_""""_TargetsType_""""	
	s mess=mess_","_"TransferInserialID"_":"_""""_TransferInserialID_""""	
	s mess=mess_","_"PatData"_":"_""""_PatData_""""	
	s mess=mess_","_"TransData"_":"_""""_TransData_""""	
	s mess=mess_","_"PreInfo"_":"_""""_PreInfo_""""	
	s mess=mess_","_"ExamStr"_":"_""""_ExamStr_""""	
	s mess=mess_","_"DiagnoseStr"_":"_""""_DiagnoseStr_""""	
	s mess=mess_"}"
	 s mess="["_mess_"]"
 
	 s mess="{totalCount"_":"_""""_count_""""_","_"topics"_":"_mess_"}"
	 q $tr(mess,$c(13,10))
}

/// 解析转诊服务平台的 EPR 方法
///  author: Guo Rongyong
///  
/// w ##class(web.DHCTransReceive).ReadEPRDataString("")
ClassMethod ReadEPRDataString(XMLStr As %String) As %String
{
	s ^TMP("zhwh",123)=XMLStr
	///Set $ZT="ERROR^DHCSSERR"
	Q:XMLStr="" ""
	Set reader = ##class(%XML.Reader).%New()
	/*
	;解析PatientData
	s XMLStr="<PatientData><Name>李文耀</Name><Address></Address><TEL></TEL><HealthRecordID></HealthRecordID><PatientInserialID>A061211Y000102500016</PatientInserialID><BirthDay>2006-12-11</BirthDay><Sex>男</Sex><Nation></Nation><culturalDegree></culturalDegree><AdmReason>医疗保险</AdmReason><Height></Height><Weight></Weight><BMI></BMI></PatientData>"
	s sc=reader.OpenString(XMLStr)
	Do reader.Correlate("PatientData","web.DHCEntity.PCA.PatientData")
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit
	if reader.Next(.object,.sc) {
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit
	}
	s Name=object.Name
	s Address=object.Address
	s TEL=object.TEL
	s HealthRecordID=object.HealthRecordID
	s PatientInserialID=object.PatientInserialID
	s BirthDay=object.BirthDay
	s Sex=object.Sex
	s Nation=object.Nation
	s culturalDegree=object.culturalDegree
	s AdmReason=object.AdmReason
	s Height=object.Height
	s Weight=object.Weight
	s BMI=object.BMI
	
	w "Name="_Name_"^Address="_Address_"^TEL="_TEL_"^HealthRecordID="_HealthRecordID_"^PatientInserialID="_PatientInserialID_"^BrirthDay="_BirthDay_"^Sex="_Sex_"^Nation="_Nation_"^culturalDegree="_culturalDegree_"^AdmReason="_AdmReason_"^Height="_Height_"^Weight="_Weight_"^BMI="_BMI
	*/
	;解析PatientEPRData
	;s XMLStr="<PatientEPRData><factors>高血压</factors><course>3年</course><Body><PULSE>90</PULSE><Breath>70</Breath><BloodPressure>80/120</BloodPressure><Notes>注意观察血压变化</Notes></Body><DiagnosticExamination><ExamItemSet><ExamItem><ExamID>19703</ExamID><ExamName>心电图</ExamName></ExamItem><ExamItem><ExamID>19704</ExamID><ExamName>CT</ExamName></ExamItem></ExamItemSet></DiagnosticExamination><Diagnoses><DiagnoseSet><Diagnose><DiagnoseType>I</DiagnoseType><ICDCode>A00.901</ICDCode><ICDDesc>霍乱</ICDDesc><Notes>备注</Notes></Diagnose><Diagnose><DiagnoseType>O</DiagnoseType><ICDCode>A00.101</ICDCode><ICDDesc>埃尔托霍乱弧菌引起的霍乱</ICDDesc><Notes>备注</Notes></Diagnose></DiagnoseSet></Diagnoses></PatientEPRData>"
	s sc=reader.OpenString(XMLStr)
	Do reader.Correlate("PatientEPRData","web.DHCEntity.PCA.PatientEPRData")
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit
	if reader.Next(.object,.sc) {
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit
	}
	s PreInfo=""
	s factors=object.factors
	s course=object.course
	s BodyObj=##class(web.DHCEntity.PCA.Body).%New()
	s BodyObj=object.Body
	s PULSE=BodyObj.PULSE
	s Breath=BodyObj.Breath
	s BloodPressure=BodyObj.BloodPressure
	s Notes=BodyObj.Notes
	s DiagnosticExamination=object.DiagnosticExamination
	s Diagnoses=object.Diagnoses
	s PreInfo="主诉:"_factors_" 过程:"_course
	s PreInfo=PreInfo_","_"脉搏:"_PULSE_" 呼吸:"_Breath_" 血压:"_BloodPressure_" 注意事项:"_Notes
	//b ;0
	
	s ExamStr=""
	s ExamObj=##class(web.DHCEntity.PCA.DiagnosticExamination).%New()
	s ExamObj=object.DiagnosticExamination
	//b
	s ExamLen=ExamObj.ExamItemSet.Count()
	for i=1:1:ExamLen {
	s ExamItemObj=##class(web.DHCEntity.PCA.ExamItem).%New()
	s ExamItemObj=ExamObj.ExamItemSet.GetAt(i)
	if ExamStr="" s ExamStr="检查ID:"_ExamItemObj.ExamID_" 检查名称:"_ExamItemObj.ExamName
	else  s ExamStr=ExamStr_","_"检查ID:"_ExamItemObj.ExamID_" 检查名称:"_ExamItemObj.ExamName
	}
	
	s DiagnoseStr=""
	s DiagnosesObj=##class(web.DHCEntity.PCA.Diagnoses).%New()
	s DiagnosesObj=object.Diagnoses
	s DiagnoseLen=DiagnosesObj.DiagnoseSet.Count()
	for i=1:1:DiagnoseLen {
	s DiagnoseObj=##class(web.DHCEntity.PCA.Diagnose).%New()
	s DiagnoseObj=DiagnosesObj.DiagnoseSet.GetAt(i)
	if DiagnoseStr="" s DiagnoseStr=i_". 诊断类型:"_DiagnoseObj.DiagnoseType_" ICD代码:"_DiagnoseObj.ICDCode_" ICD描述:"_DiagnoseObj.ICDDesc_" 备注:"_DiagnoseObj.Notes
	else  s DiagnoseStr=DiagnoseStr_","_i_". 诊断类型:"_DiagnoseObj.DiagnoseType_" ICD代码:"_DiagnoseObj.ICDCode_" ICD描述:"_DiagnoseObj.ICDDesc_" 备注:"_DiagnoseObj.Notes
	}

	Q PreInfo_"^"_ExamStr_"^"_DiagnoseStr
}

Storage Default
{
<Data name="PersonTransferServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PersonTransferServiceD</DataLocation>
<DefaultData>PersonTransferServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PersonTransferServiceD</IdLocation>
<IndexLocation>^CHSSWeb.PersonTransferServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.PersonTransferServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
