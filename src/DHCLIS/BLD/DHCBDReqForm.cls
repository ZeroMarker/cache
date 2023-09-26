Class DHCLIS.BLD.DHCBDReqForm Extends %RegisteredObject
{

/// 通过单号获取绑定的电子病历ID
ClassMethod GetAgreeFormIDMTHD(ReportID, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %String
{
	
	S AgreeFormID=""
	S ReportID=$G(ReportID)
	S ReqFormDR=$O(^dbo.BDReqFormI("IndexReqFormNo",##Class(LIS.Util.Common).IndexData(ReportID),""))
	I $L(ReqFormDR) S AgreeFormID=$LG($G(^dbo.BDReqFormD(ReqFormDR)),48)
	I AgreeFormID'["||" Q "-1^该患者未填写电子病历知情同意书"
	Q AgreeFormID
}

/// Creator：      zyx
/// CreatDate：    20190604
/// Description:： 获取单号id
/// Output：       
/// Return：       
/// Others：     0成功。-1失败
/// w ##class(DHCLIS.BLD.DHCBDReqForm).GetReportDRMTHD("20200709004","ADV","","","","","","","","","","","","","8388^^5^36^1")
ClassMethod GetReportDRMTHD(ReportID, Type, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %String
{
	S ret="",retstr=""
	S ReportID=$G(ReportID),Type=$G(Type)
    I Type="" Q ""
    I (Type="REQ") S ret="-1^申请单号为空，请核实患者是否已开申请单"
    I (Type="AGF") S ret="-1^知情同意书单号为空，请核实患者是否已填知情同意书"
    I (Type="ADV") S ret="-1^不良反应单号为空，请核实患者是否填写不良反应单"
    I (Type="ISS") S ret="-1^发血单号为空，请核实患者是否已发血"
    I (Type="BDT") S ret="-1^取血单号为空，请核实患者是否已填写取血单"
    I (Type="XMP") S ret="-1^配血单号为空，请核实患者是否已配血"
    
    I (Type="REQ") {
	   S retstr=$O(^dbo.BDReqFormI("IndexReqFormNo",##Class(LIS.Util.Common).IndexData(ReportID),""))    
	} 
	elseIF(Type="AGF"){
		 S ReqFormDR=$O(^dbo.BDReqFormI("IndexReqFormNo",##Class(LIS.Util.Common).IndexData(ReportID),"")),AgreeFormNo=""
		 I $L(ReqFormDR) S AgreeFormNo=$LG($G(^dbo.BDReqFormD(ReqFormDR)),48)
		 I $L(AgreeFormNo) S retstr=$O(^dbo.BDAgreeFormI("IndexAgreeFormNo",##Class(LIS.Util.Common).IndexData(AgreeFormNo),""))
		
	}
	elseIF(Type="ADV"){
		    S ReqFormDR=$O(^dbo.BDReqFormI("IndexReqFormNo",##Class(LIS.Util.Common).IndexData(ReportID),"")),AdmNo=""
		    I $L(ReqFormDR) S RegNo=$LG($G(^dbo.BDReqFormD(ReqFormDR)),8)
		    b ;00
		    I $L(RegNo) {
			    S ReactionDR=""
			    F  S ReactionDR=$O(^dbo.BDReactionI("IndexRegNo",##Class(LIS.Util.Common).IndexData(RegNo),ReactionDR)) Q:ReactionDR=""  D
			    .S retstr=retstr_ReactionDR_"||"
			    }
		
	}
	elseIF(Type="ISS"){
		   S ReqFormDR=$O(^dbo.BDReqFormI("IndexReqFormNo",##Class(LIS.Util.Common).IndexData(ReportID),"")),IssueRecordDR=""
		   I $L(ReqFormDR){
			    S IssueRecordDR=""
			    F  S IssueRecordDR=$O(^dbo.BDIssueRecordI("IndexReqForm",ReqFormDR,IssueRecordDR)) Q:IssueRecordDR=""  D
			    .S retstr=retstr_IssueRecordDR_"||"
			   } 
		
	}
	elseIF(Type="BDT"){
		   S ReqFormDR=$O(^dbo.BDReqFormI("IndexReqFormNo",##Class(LIS.Util.Common).IndexData(ReportID),"")),BDTakeDR=""
		   I $L(ReqFormDR){
			    S BDTakeDR=""
			    F  S BDTakeDR=$O(^dbo.BDTakeRecordI("IndexRequestForm",ReqFormDR,BDTakeDR)) Q:BDTakeDR=""  D
		        .s Status=$lg($g(^dbo.BDTakeRecordD(BDTakeDR)),18)
		        .I Status'=20 Q
		        .S retstr=retstr_BDTakeDR_"||"
		   }
	}
	elseIF(Type="XMP"){
		   S ReqFormDR=$O(^dbo.BDReqFormI("IndexReqFormNo",##Class(LIS.Util.Common).IndexData(ReportID),"")),XMPlanDR=""
		   I $L(ReqFormDR){
			    S PackDR=""
			    F  S PackDR=$O(^dbo.BDXMPlanI("IndexMaster",ReqFormDR,PackDR)) Q:PackDR=""  D
			    .S XMPlanDR=$O(^dbo.BDXMPlanI("IndexMaster",ReqFormDR,PackDR,""))
			    .s XMPlanNO=$LG($G(^dbo.BDXMPlanD(XMPlanDR)),26)
			    .I retstr[XMPlanNO Q
			    .S retstr=retstr_XMPlanNO_"||"
		   }
	}
	else{
			S retstr=ReportID
	}
	i $l(retstr) s ret=retstr
    Q ret
}

/// Creator：      SunZhiWen
/// CreatDate：    20151126
/// Description:： 查询申请单详情
/// Table：        BD_ReqForm
/// Input：        
/// Output：       
/// Return：       
/// Others：  
/// d ##Class(%ResultSet).RunQuery("DHCLIS.BLD.DHCBDReqForm","QryReqFormInfo","2","9","20150101","20150309","","","","","","","","",20,1,"106^10^^13^1")
Query QryReqFormInfo(fReqFormDR, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "ReqFormNo,ReqTypeDR,AdmNo,AddDate,AddTime,AddUserDR,RegNo,MedicalRecordNo,SurName,GivenName,SpeciesDR,Age,AgeUnitDR,CertTypeDR,CertNo,IDNumber,ABODR,RHDR,RareBloodGroup,Ethnicity,NativePlace,LocationDR,WardDR,BedNo,Diagnosis,IsTransHistory,LastTransDate,IsUntowardEffect,UntowardEffectNote,IsOrganExplant,OrganBloodGroupDR,IsKeestExplant,KeestBloodGroupDR,IsDrugHistory,DrugList,IsPregHistory,Pregnancies,ChildBirths,BookDate,AssHeart,AssLiver,AssKidney,AssLung,AssHypertensive,SampleNo,UseSampleNo,AgreeFormNo,Remark,IsExcess,Status,AdmType,OpsName,OpsCode,IsSame,SendDate,SendTime,SendUserDR,SignDate,SignTime,SignUserDR,CheckCause,CheckDate,CheckTime,CheckUserDR,IsPrinted,IsSended,ReceiveDate,ReceiveTime,ReceiveUserDR,WorkGroupDR,IsQualified,EvaluateText,Weight,Height,BldPressure,Pulse,BodyTemp,OpsDate,BookCollDate,BookTime,OpsTime,BookCollTime,BookCollVolume,AddUserName,OrganBloodGroup,KeestBloodGroup,ReceiveUserName,WorkGroupName,Sex,Ward,Location,ReqTypeName,ReqTypeCode,CheckUserName,ABO,RH,AgeUnit,CurrentABO,CurrentRH,AgeDesc,IsDefinitelyUse,BldInfo,AntiScreen,AntiScreenFlag,AuthDate,AuthTime,ReqRuleInfo,MedicalInsuranceType,TISMedicalInsuranceType,IsIntraoperative,HeadCheckRemark")
{
}

ClassMethod QryReqFormInfoExecute(ByRef qHandle As %Binary, fReqFormDR, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
	Set UserID=$p(Sessions,"^",1),WorkGroupDR=$p(Sessions,"^",2),HospitalDR=$p(Sessions,"^",5),LocationDR=$p(Sessions,"^",3)
    s RowCount=0
 	s PageSize=+$g(PageSize),PageIndex=+$g(PageIndex),ToRow=0,FormRow=0
 	i PageIndex>0,PageSize>0 s ToRow=PageIndex*PageSize,FormRow=ToRow-PageSize+1
 	
 	i $l(fReqFormDR) {
	 	s (AddUserName,OrganBloodGroup,KeestBloodGroup,ReceiveUserName,WorkGroupName) = ""
	 	s ReqFormData = $g(^dbo.BDReqFormD(fReqFormDR))
		s AddUserDR = $lg(ReqFormData,7)
		s OrganBloodGroupDR = $lg(ReqFormData,32)
		s KeestBloodGroupDR = $lg(ReqFormData,34)
		s ReceiveUserDR = $lg(ReqFormData,70)
		s WorkGroupDR = $lg(ReqFormData,71)
		s SpeciesDR = $lg(ReqFormData,12)
		s ReqTypeDR = $lg(ReqFormData,3)
		s (ReqTypeName,ReqTypeCode)=""
		i $l(ReqTypeDR) {
			s ReqTypeCode = $lg(^dbo.BBReqTypeD(ReqTypeDR),2)
			s ReqTypeName = $lg(^dbo.BBReqTypeD(ReqTypeDR),3)
		}
		s Sex = ""
		i $l(SpeciesDR) s Sex = $lg(^dbo.BTSpeciesD(SpeciesDR),3)
		s WardDR = $lg(ReqFormData,24)
		s Ward=""
		i $l(WardDR) s Ward = $lg(^dbo.BTWardD(WardDR),3)
		i $l(Ward,"-")>1 s Ward = $p(Ward,"-",2)
		s LocationDR= $lg(ReqFormData,23)
		s Location=""
		i $l(LocationDR) s Location = $lg(^dbo.BTLocationD(LocationDR),3)
		i $l(Location,"-")>1 s Location = $p(Location,"-",2)
		i $l(AddUserDR) s AddUserName = $lg($g(^dbo.SYSUserD(AddUserDR)),3)
		i $l(OrganBloodGroupDR) s OrganBloodGroup = $lg($g(^dbo.BBBloodGroupD(OrganBloodGroupDR)),3)
		i $l(KeestBloodGroupDR) s KeestBloodGroup = $lg($g(^dbo.BBBloodGroupD(KeestBloodGroupDR)),3)
		i $l(ReceiveUserDR) s ReceiveUserName = $lg($g(^dbo.SYSUserD(ReceiveUserDR)),3)
		i $l(WorkGroupDR) s WorkGroupName = $lg($g(^dbo.BTWorkGroupD(WorkGroupDR)),3)
		s CheckUserDR = $lg(ReqFormData,65)
		s CheckUserName=""
		i $l(CheckUserDR) s CheckUserName = $lg($g(^dbo.SYSUserD(CheckUserDR)),3)
		s ABODR = $lg(ReqFormData,18)
		s RHDR = $lg(ReqFormData,19)
		
		S (ABO,RH)=""
		i $l(ABODR) s ABO = $lg($g(^dbo.BTABOBGD(ABODR)),3)
	
		i $l(RHDR) s RH = $lg($g(^dbo.BTRHBGD(RHDR)),3)
		s RegNo=$lg(ReqFormData,8) 
		s (CheckABOD,CurrentABO,CheckRHD,CurrentRH)=""
		s $namespace="dhc-lisdata"
		i $l(RegNo) s CheckABOD=##class(BLD.WS.BLL.DHCTCResult).GetTCResultByRegNoMTHD(RegNo,"ABO","LIS")
        i $l(RegNo) s CurrentABO=$tr($p($p(CheckABOD,",",6),":",2),"”""“""}")
        i $l(RegNo) s CheckRHD=##class(BLD.WS.BLL.DHCTCResult).GetTCResultByRegNoMTHD(RegNo,"RH","LIS")
        i $l(RegNo) s CurrentRH=$tr($p($p(CheckRHD,",",6),":",2),"”""“""}")
    	s $namespace="dhc-app"
		s AgeUnitDR = $lg(ReqFormData,14)
		s AgeUnit=""
		i $l(AgeUnitDR) s AgeUnit = $lg($g(^dbo.BTAgeUnitD(AgeUnitDR)),3)
		s AgeDesc=$lg(ReqFormData,85)
		s IsDefinitelyUse = $lg(ReqFormData,86)
		s MedicalInsuranceType = $lg(ReqFormData,87)
		s TISMedicalInsuranceType = $lg(ReqFormData,88)
		s IsIntraoperative = $lg(ReqFormData,92)
		s HeadCheckRemark= $lg(ReqFormData,111)
		s $namespace="dhc-lisdata"
		s ABOTypeInfo=##class(BLD.WS.BLL.DHCTCResult).GetTCResultByRegNoMTHD(RegNo,"ABO","BLD")
	    s RHTypeInfo=##class(BLD.WS.BLL.DHCTCResult).GetTCResultByRegNoMTHD(RegNo,"RH","BLD")
	    s ABOType="",RHType="",AntiScreen="",AntiScreenFlag=""
	    i $l(ABOTypeInfo) s ABOType=$p($p(ABOTypeInfo,"""P5"":""",2),""",",1)
        i $l(RHTypeInfo) s RHType="Rh(D)"_$p($p(RHTypeInfo,"""P5"":""",2),""",",1)
        i $l(RHTypeInfo) s AuthDate=$p($p(ABOTypeInfo,"""P8"":""",2),""",",1)
        i $l(RHTypeInfo) s AuthTime=$tr($p($p(ABOTypeInfo,"""P9"":""",2),""",",1),"""}")
     
	    s BldInfo=ABOType_RHType
	    s AntiScreenInfo=##class(BLD.WS.BLL.DHCTCResult).GetTCResultByRegNoMTHD(RegNo,"SAS","BLD")
	    s $namespace="dhc-app"
	    i $l(AntiScreenInfo) s AntiScreen=$p($p(AntiScreenInfo,"""P5"":""",2),""",",1)
	    i $l(AntiScreenInfo) s AntiScreenFlag=$p($p(AntiScreenInfo,"""P10"":""",2),""",",1)
	
		//评估信息
	    s ReqRuleDR=""
	    s ReqRuleNum=0
	    s ReqRuleInfo=""
	    for {
		    s ReqRuleDR=$o(^dbo.BDReqFormRuleI("IndexMaster",fReqFormDR,ReqRuleDR))
		    q:ReqRuleDR=""
		    s ReqRuleDesc = $lg(^dbo.BBRUReqRuleD(ReqRuleDR),4)
		    s ReqRuleNum = ReqRuleNum+1
		    s ReqRuleInfo = ReqRuleInfo_ReqRuleNum_"、"_ReqRuleDesc_$c(13,10)
	    }
	
		s Data = $li(ReqFormData,2,84)_$lb(AddUserName,OrganBloodGroup,KeestBloodGroup,ReceiveUserName,WorkGroupName,Sex,Ward,Location,ReqTypeName,ReqTypeCode,CheckUserName,ABO,RH,AgeUnit,CurrentABO,CurrentRH,AgeDesc,IsDefinitelyUse,BldInfo,AntiScreen,AntiScreenFlag,AuthDate,AuthTime,ReqRuleInfo,MedicalInsuranceType,TISMedicalInsuranceType,IsIntraoperative,HeadCheckRemark)
	
 		d OutPut
 	}
 	Set qHandle=$lb(0,repid,0)
    q $$$OK
    
OutPut
	set ColFields="ReqFormNo,ReqTypeDR,AdmNo,AddDate,AddTime,AddUserDR,RegNo,MedicalRecordNo,SurName,GivenName,SpeciesDR,Age,AgeUnitDR,CertTypeDR,CertNo,IDNumber,ABODR,RHDR,RareBloodGroup,Ethnicity,NativePlace,LocationDR,WardDR,BedNo,Diagnosis,IsTransHistory,LastTransDate,IsUntowardEffect,UntowardEffectNote,IsOrganExplant,OrganBloodGroupDR,IsKeestExplant,KeestBloodGroupDR,IsDrugHistory,DrugList,IsPregHistory,Pregnancies,ChildBirths,BookDate,AssHeart,AssLiver,AssKidney,AssLung,AssHypertensive,SampleNo,UseSampleNo,AgreeFormNo,Remark,IsExcess,Status,AdmType,OpsName,OpsCode,IsSame,SendDate,SendTime,SendUserDR,SignDate,SignTime,SignUserDR,CheckCause,CheckDate,CheckTime,CheckUserDR,IsPrinted,IsSended,ReceiveDate,ReceiveTime,ReceiveUserDR,WorkGroupDR,IsQualified,EvaluateText,Weight,Height,BldPressure,Pulse,BodyTemp,OpsDate,BookCollDate,BookTime,OpsTime,BookCollTime,BookCollVolume,AddUserName,OrganBloodGroup,KeestBloodGroup,ReceiveUserName,WorkGroupName,Sex,Ward,Location,ReqTypeName,ReqTypeCode,CheckUserName,ABO,RH,AgeUnit,CurrentABO,CurrentRH,AgeDesc,IsDefinitelyUse,BldInfo,AntiScreen,AntiScreenFlag,AuthDate,AuthTime,ReqRuleInfo,MedicalInsuranceType,TISMedicalInsuranceType,IsIntraoperative,HeadCheckRemark"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QryReqFormInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReqFormInfoExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryReqFormInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReqFormInfoExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      SunZhiWen
/// CreatDate：    20151228
/// Description:： 查询申请单申请医嘱信息
/// Table：        
/// Input：        fStatus代表申请单状态，1代表审核，审核状态下的申请单已经将医嘱数据存入表中
/// Output：       
/// Return：       
/// Others：  
/// d ##Class(%ResultSet).RunQuery("BLD.WS.BLL.DHCBDReqForm","QryReqFormCostItem","31","","20150101","20150309","","","","","","","","",20,1,"106^10^^13^1")
Query QryReqFormCostItem(fReqFormDR, fStatus, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "RowID,CostItemCode,CostItemName,ReqProductDR,CostItemPrice,Quantity,CostItemDR,CostType,BillType")
{
}

ClassMethod QryReqFormCostItemExecute(ByRef qHandle As %Binary, fReqFormDR, fStatus, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
	Set UserID=$p(Sessions,"^",1),WorkGroupDR=$p(Sessions,"^",2),HospitalDR=$p(Sessions,"^",5),LocationDR=$p(Sessions,"^",3)
    s RowCount=0
 	s PageSize=+$g(PageSize),PageIndex=+$g(PageIndex),ToRow=0,FormRow=0
 	i PageIndex>0,PageSize>0 s ToRow=PageIndex*PageSize,FormRow=ToRow-PageSize+1
 	s ReqFormCostItemDR=""
 	i $l(fReqFormDR) {
	 	//RowID,CostItemCode,CostItemName,ReqProductDR,CostItemPrice,Volumn,Unit,CostItemDR
	 	i $d(^dbo.BDReqFormCostItemI("IndexReqForm",fReqFormDR)) {
		 	s ReqFormCostItemDR = ""
		 	for {
			 	s ReqFormCostItemDR = $o(^dbo.BDReqFormCostItemI("IndexReqForm",fReqFormDR,ReqFormCostItemDR))
			 	q:ReqFormCostItemDR=""
			 	s ReqFormCostItemData = $g(^dbo.BDReqFormCostItemD(ReqFormCostItemDR))
			 	s CostItemDR = $lg(ReqFormCostItemData,4)
			 	s CostItemData = $g(^dbo.BTCostItemD(CostItemDR))
			 	s CostItemCode = $lg(CostItemData,2)
			 	s CostItemName = $lg(CostItemData,3)
			 	s CostItemPrice = $lg(ReqFormCostItemData,5)
			 	s Quantity = $lg(ReqFormCostItemData,6)
			 	s ReqProductDR = $lg(ReqFormCostItemData,23)
			 	s CostType = $lg(ReqFormCostItemData,3)
			 	s BillType=""
			 	i CostType=6 s BillType=1
			 	i (CostType'=5)&&(CostType'=6)&&(CostType'=30) continue
			 	s Data = $lb(ReqFormCostItemDR,CostItemCode,CostItemName,ReqProductDR,CostItemPrice,Quantity,CostItemDR,CostType,BillType)
				d OutPut
		 	}
	 	}
	}
 	Set qHandle=$lb(0,repid,0)
    q $$$OK
    
OutPut
	set ColFields="RowID,CostItemCode,CostItemName,ReqProductDR,CostItemPrice,Volumn,Unit,CostItemDR"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QryReqFormCostItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReqFormInfoExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryReqFormCostItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReqFormInfoExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      zhanglianzhu
/// CreatDate：    20150910
/// Description:： 
/// Table：        dbo.BD_ReqFormItemResult
/// Input：        ReqFormDR:申请单主键  ReqTypeDR:申请单类型  HospitalDR:医院  RegNo：登记号
/// Output：       输血申请单项目结果
/// Return：       
/// Others：       d ##Class(%ResultSet).RunQuery("BLD.WS.BLL.DHCBDReqForm","QueryReqFormItemResult","","","1","0000000811","","","","","","","","","","","113^46^^2^1")
Query QueryReqFormItemResult(ReqFormDR As %String, ReqTypeDR As %String, HospitalDR As %String, RegNo As %String, ReqTypeCode, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "IsPrompt,ResultList,Days,RowID,reqFormDR,TestItemDR,TestItemName,Result,Unit,RefRanges,SeqNum,AbFlag,AuthUserName,AuthDate,AuthTime,ScCode,flag,ResultStatus,AuthUserDR,NextResult,NextAuthDate,NextAuthTime,NextAbFlag,NextResNoes")
{
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("BLD.WS.BLL.DHCBDReqForm","QueryReqFormItemResult","","","1","0000000071","Normal","","","","","","","","","","8071^^113^36^1")
ClassMethod QueryReqFormItemResultExecute(ByRef qHandle As %Binary, ReqFormDR As %String, ReqTypeDR As %String, HospitalDR As %String, RegNo As %String, ReqTypeCode, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Status
{
    s ReqFormDR=$g(ReqFormDR)
    s HospitalDR=$g(HospitalDR)
    s RegNo=$g(RegNo)
    i '$l(ReqTypeDR),$l(ReqTypeCode) s ReqTypeCode = $ZCVT(ReqTypeCode,"U") s ReqTypeDR = $o(^dbo.BBReqTypeI("IndexCode",##Class(LIS.Util.Common).IndexData(ReqTypeCode),""))
    i '$l(ReqTypeDR) s ReqTypeDR=1
    s (IsPrompt,ResultList,Days,RowID,reqFormDR,TestItemDR,TestItemName,Result,Unit,RefRanges,SeqNum,AbFlag,AuthUserDR,AuthUserName,AuthDate,AuthTime,VisitNumberReportDR,ScCode,flag,ResultStatus)=""
 	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	i $l(ReqFormDR) d
	.//获取申请单的增加日期，以用来获取增加日期后的最近的一次结果
	.s RegNo = $lg(^dbo.BDReqFormD(ReqFormDR),8) 
	.s AddReqFormDate = $lg(^dbo.BDReqFormD(ReqFormDR),5)
	.s AddReqFormTime = $lg(^dbo.BDReqFormD(ReqFormDR),6)
    .s ResultList=""
	.s TestItemDR="" f  s TestItemDR=$o(^dbo.BDReqFormItemResultI("IndexMaster",ReqFormDR,TestItemDR)) Quit:TestItemDR=""  Do 
	..s rowId="" f  s rowId=$o(^dbo.BDReqFormItemResultI("IndexMaster",ReqFormDR,TestItemDR,rowId)) Quit:rowId=""  Do 	
	...s IsPrompt="" 
	...s Days=0
	...s reqFormItemRowID="" f  s reqFormItemRowID=$o(^dbo.BBReqTestItemI("IndexMaster",ReqTypeDR,HospitalDR,TestItemDR,reqFormItemRowID)) Quit:reqFormItemRowID=""  Do 
	....s reqFormItemData=	$g(^dbo.BBReqTestItemD(reqFormItemRowID))
	....s IsPrompt=$lg(reqFormItemData,5)
	....s ResultList=$lg(reqFormItemData,6)
	....s Days=+$lg(reqFormItemData,7) 
	...s StrData=$g(^dbo.BDReqFormItemResultD(rowId))
	...s TestItemName=""
	...s TestItemName=$lg($g(^dbo.BBTestItemD(TestItemDR)),3) //AbFlag,AuthUserDR,AuthUserName,AuthDate,AuthTime
	...s ScCode=$lg($g(^dbo.BBTestItemD(TestItemDR)),4)
	...s ScCode=$ZCVT(ScCode,"U")
	...s RowID=rowId
	...s reqFormDR=$lg(StrData,2)
	...s Result=$lg(StrData,4)
	...s Unit=$lg(StrData,5)
	...s RefRanges=$lg(StrData,6)
	...s SeqNum=$lg(StrData,10)
	...i '$l(SeqNum) s SeqNum=999
	...s (VisitNumberReportDR,AbFlag)=""
	...s AuthTime=$lg(StrData,8)
	...s AuthDate=$lg(StrData,7)
	...s AuthUserDR=$lg(StrData,9)
	...s AuthUserName=""
	...i $l(AuthUserDR) s AuthUserName=$lg(^dbo.SYSUserD(AuthUserDR),3)
	...s (NextResult,NextAuthDate,NextAuthTime,NextAbFlag,NextResNoes)=""
	...s (NextResult,NextAuthDate,NextAuthTime,NextAbFlag,NextResNoes)=""
	...s TestCodeDR="" f  s TestCodeDR=$o(^dbo.BTTestCodeI("IndexSCode",##Class(LIS.Util.Common).IndexData(ScCode),TestCodeDR)) q:(TestCodeDR="")!($l(NextResult))  d
	....s NextResultDR=""
	....s NextAuthTime=$o(^dbo.RPVisitNumberReportResultI("IndexPatientItem",##Class(LIS.Util.Common).IndexData(RegNo),TestCodeDR,AddReqFormDate,AddReqFormTime))
	....i $l(NextAuthTime) d
	.....s NextAuthDate = AddReqFormDate
	.....s NextResultDR=$o(^dbo.RPVisitNumberReportResultI("IndexPatientItem",##Class(LIS.Util.Common).IndexData(RegNo),TestCodeDR,AddReqFormDate,AddReqFormTime,""))
	....e  d
	.....s NextAuthDate=$o(^dbo.RPVisitNumberReportResultI("IndexPatientItem",##Class(LIS.Util.Common).IndexData(RegNo),TestCodeDR,AddReqFormDate))
	.....i '$l(NextAuthDate) q 
	.....q:NextAuthDate<0
	.....s NextAuthTime=$o(^dbo.RPVisitNumberReportResultI("IndexPatientItem",##Class(LIS.Util.Common).IndexData(RegNo),TestCodeDR,NextAuthDate,""))
	.....i '$l(NextAuthTime) q 
	.....q:NextAuthTime<0
	.....s NextResultDR=$o(^dbo.RPVisitNumberReportResultI("IndexPatientItem",##Class(LIS.Util.Common).IndexData(RegNo),TestCodeDR,NextAuthDate,NextAuthTime,""))
	....i '$l(NextResultDR) q
	....s NextResultData=$g(^dbo.RPVisitNumberReportResultD(NextResultDR))
	....s NextResult=$lg(NextResultData,5)
	....s NextExtraRes=$lg(NextResultData,6)
	....i $l(NextExtraRes) s NextResult=NextResult_"("_NextExtraRes_")"
	....s NextUnit=$lg(NextResultData,11) 
	....s NextAbFlag=$lg(NextResultData,9)
	....s RefRanges=$lg(NextResultData,12)  
	....s NextResNoes=$lg(NextResultData,8)
	...s OutResult(SeqNum,RowID)=$lb(IsPrompt,ResultList,Days,RowID,reqFormDR,TestItemDR,TestItemName,Result,Unit,RefRanges,SeqNum,AbFlag,AuthUserName,AuthDate,AuthTime,ScCode,flag,ResultStatus,AuthUserDR,NextResult,NextAuthDate,NextAuthTime,NextAbFlag,NextResNoes)
	.s SeqNum=""
	.for  s SeqNum = $o(OutResult(SeqNum)) q:SeqNum=""  d
	..s RowID=""  f  s RowID = $o(OutResult(SeqNum,RowID)) q:RowID=""  d
	...s Data=OutResult(SeqNum,RowID)
	...d OutputRow
	e  i $l(HospitalDR) d
	.s SeqNum="" f  s SeqNum=$o(^dbo.BBReqTestItemI("IndexSeqNum",ReqTypeDR,HospitalDR,SeqNum)) Quit:SeqNum=""  Do 	
	..s (IsPrompt,ResultList,Days,RowID,reqFormDR,TestItemName,Result,Unit,RefRanges,TestItemDR,AuthDate,AuthTime,ResultStatus,NextResult,NextAuthDate,NextAuthTime,NextAbFlag,NextResNoes)=""
	..s Days=""
	..s reqFormItemRowID="" f  s reqFormItemRowID=$o(^dbo.BBReqTestItemI("IndexSeqNum",ReqTypeDR,HospitalDR,SeqNum,reqFormItemRowID)) Quit:reqFormItemRowID=""  Do 
	...s reqFormItemData=	$g(^dbo.BBReqTestItemD(reqFormItemRowID))
	...s TestItemDR = $lg(reqFormItemData,4)
	...s IsPrompt=$lg(reqFormItemData,5)
	...s ResultList=$lg(reqFormItemData,6)
	...s Days=$lg(reqFormItemData,7)
	...s testItemData=$g(^dbo.BBTestItemD(TestItemDR))
	...s TestItemName=$lg(testItemData,3)
	...s ScCode=$lg(testItemData,4)
	...i '$l(ScCode) q
	...s (AuthDate,AuthTime)=""
	...s ScCode = $zcvt(ScCode,"U")
	...s (AuthUserName,AuthUserDR)=""
	...S ResultStr=##class(BLD.WS.BLL.DHCTCResult).GetResultBySCodeMTHD(RegNo,ScCode,Days)
	...///s RetResultStr = Result_$c(2)_ExtraRes_$c(2)_Unit_$c(2)_AbFlag
	...//s RetResultStr = RetResultStr_$c(2)_RefRanges_$c(2)_ResNoes_$c(2)_AuthUserName_$c(2)_AuthDate_$c(2)_AuthTime
	...s Result = $p(ResultStr,$c(2),1)
	...s ExtraRes = $p(ResultStr,$c(2),2)
	...s Unit = $p(ResultStr,$c(2),3)
	...s AbFlag = $p(ResultStr,$c(2),4)
	...s RefRanges = $p(ResultStr,$c(2),5)
	...s ResNoes = $p(ResultStr,$c(2),6)
	...s AuthUserName = $p(ResultStr,$c(2),7)
	...s AuthDate = $p(ResultStr,$c(2),8)
	...s AuthTime = $p(ResultStr,$c(2),9)
	...s AuthUserDR=$p(ResultStr,$c(2),10)
	...//判断状态 
	...s ResultStatus=""
	...i '$l(Result) s ResultStatus=##class(BLD.WS.BLL.DHCTCResult).GetSCodeResultStatusMTHD(RegNo,ScCode,"","","",HospitalDR,"","","","","","","","",Sessions)
	...//-1未下医嘱 0下医嘱 1采集 2运送 3接收 4上机 5 审核 
	...i '$l(Result),((ResultStatus=3)!(ResultStatus=4)) s Result="检查中"
	...i '$l(Result),((ResultStatus=1)!(ResultStatus=2)) s Result="已采集"
	...i '$l(Result),(ResultStatus=0) s Result="未采集"
	...s lastData=$lb(IsPrompt,ResultList,Days,RowID,reqFormDR,TestItemDR,TestItemName,Result,Unit,RefRanges,SeqNum,AbFlag,AuthUserName,AuthDate,AuthTime,ScCode,flag,ResultStatus,AuthUserDR)
 	...d OutputRow1
 
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
	
OutputRow
    //Set Data=$lb(IsPrompt,ResultList,Days,RowID,reqFormDR,TestItemDR,TestItemName,Result,Unit,RefRanges,SeqNum,AbFlag,AuthUserName,AuthDate,AuthTime,ScCode,flag,ResultStatus,NextResult,NextAuthDate,NextAuthTime,NextAbFlag,NextResNoes)
    Set ColFields="IsPrompt,ResultList,Days,RowID,reqFormDR,TestItemDR,TestItemName,Result,Unit,RefRanges,SeqNum,AbFlag,AuthUserName,AuthDate,AuthTime,ScCode,flag,ResultStatus,AuthUserDR,NextResult,NextAuthDate,NextAuthTime,NextAbFlag,NextResNoes"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	quit
OutputRow1
    Set Data=lastData
    Set ColFields="IsPrompt,ResultList,Days,RowID,reqFormDR,TestItemDR,TestItemName,Result,Unit,RefRanges,SeqNum,AbFlag,AuthUserName,AuthDate,AuthTime,ScCode,flag,ResultStatus,AuthUserDR,NextResult,NextAuthDate,NextAuthTime,NextAbFlag,NextResNoes"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	quit
}

ClassMethod QueryReqFormItemResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryReqFormItemResultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryReqFormItemResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryReqFormItemResultExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {	
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      SunZhiWen
/// CreatDate：    20150930
/// Description:： 输血申请单申请成分查询
/// Table：        BD_ReqForm
/// Input：        
/// Output：       
/// Return：       
/// Others：  
/// d ##Class(%ResultSet).RunQuery("BLD.WS.BLL.DHCBDReqForm","QryReqFormProduct","74","9","20150101","20150309","","","","","","","","",20,1,"106^10^^13^1")
Query QryReqFormProduct(fReqFormDR, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "RowID,ReqProductDR,ReqProduct,PurposeDR,Purpose,Volumn,Unit,SpecialNeed,Remark,ReqBloodGroupDR,ReqBloodGroup,ReqFormDR,BloodComponentsDR,TakedVolumns,IsAccumulate,ScaleFactor,BloodComponents,BloodComponentsSynonym,Height,Weight,TestItemRes,RuleRes,RuleRemark")
{
}

ClassMethod QryReqFormProductExecute(ByRef qHandle As %Binary, fReqFormDR, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
	Set UserID=$p(Sessions,"^",1),WorkGroupDR=$p(Sessions,"^",2),HospitalDR=$p(Sessions,"^",5),LocationDR=$p(Sessions,"^",3)
    s RowCount=0
 	s PageSize=+$g(PageSize),PageIndex=+$g(PageIndex),ToRow=0,FormRow=0
 	i PageIndex>0,PageSize>0 s ToRow=PageIndex*PageSize,FormRow=ToRow-PageSize+1
 	
 	s ReqProductDR = ""
 	for {
	 	q:fReqFormDR=""
	 	s ReqProductDR = $o(^dbo.BDReqFormProductI("IndexMaster",fReqFormDR,ReqProductDR))
	 	q:ReqProductDR=""
	 	s ReqFormProductDR = $o(^dbo.BDReqFormProductI("IndexMaster",fReqFormDR,ReqProductDR,""))
	 	s ReqFormProductData = $g(^dbo.BDReqFormProductD(ReqFormProductDR))
	 	s ReqProductDR = $lg(ReqFormProductData,3)
	 	s ReqProductData = $g(^dbo.BBReqProductD(ReqProductDR))
	 	s ReqProduct = $lg(ReqProductData,3)
	 	s BloodComponentsDR = $lg(ReqProductData,7)
	 	s BBBloodComponentsData = $g(^dbo.BBBloodComponentsD(BloodComponentsDR))
	 	s BloodComponents = $lg(BBBloodComponentsData,3)
	 	s BloodComponentsSynonym = $lg(BBBloodComponentsData,5)
        s ReqFormData=$g(^dbo.BDReqFormD(fReqFormDR))
        s ReqTypeDR=$lg(ReqFormData,3)
        s BBReqTypeData=$g(^dbo.BBReqTypeD(ReqTypeDR))
        s ReqTypeCode=$lg(BBReqTypeData,2) 
	 	s ScaleFactor = $lg(ReqProductData,8)
	 	s IsAccumulate = $lg(ReqProductData,9)
	 	s PurposeDR = $lg(ReqFormProductData,4)
	 	s Purpose = $lg(^dbo.BBPurposeD(PurposeDR),3)
	 	s Volumn = $lg(ReqFormProductData,5)
	 	s Unit = $lg(ReqFormProductData,6)
	 	 i ReqTypeCode="Hemocyte"
        {
	        s Purpose=$lg(ReqFormProductData,8)
	        s Volumn="",Unit=""
        }
	 	s SpecialNeed = $lg(ReqFormProductData,7)
	 	s Remark = $lg(ReqFormProductData,8)
	 	s ReqBloodGroupDR = $lg(ReqFormProductData,9)
	 	s ReqBloodGroup = $lg(^dbo.BBBloodGroupD(ReqBloodGroupDR),3)
	 	S Height= $lg(ReqFormProductData,10)
	 	s Weight= $lg(ReqFormProductData,11)
	 	s TestItemRes= $lg(ReqFormProductData,12)
	 	s RuleResMax= $lg(ReqFormProductData,13)
	 	s RuleResMin= $lg(ReqFormProductData,14)
	 	s RuleRemark= $lg(ReqFormProductData,15)
	 	s RuleRes=RuleResMax
	 	i $l(RuleResMin) s RuleRes=RuleResMin_"-"_RuleResMax
	 	
	 	//查询已取血量，按照取血单
	 	s TakeRecordDR = ""
	 	s TakedVolumns=0
	 	for {
		 	i '$d(^dbo.BDTakeRecordI("IndexRequestForm",fReqFormDR)) q
		 	s TakeRecordDR= $o(^dbo.BDTakeRecordI("IndexRequestForm",fReqFormDR,TakeRecordDR))
		 	q:TakeRecordDR=""
		 	i '$d(^dbo.BDTakeRecordComponentsI("IndexMaster",TakeRecordDR,BloodComponentsDR)) continue
 			s TakeRecordStatus = $lg($g(^dbo.BDTakeRecordD(TakeRecordDR)),18)
          	i TakeRecordStatus=30 continue
		 	s TakeRecordComponentsDR = $o(^dbo.BDTakeRecordComponentsI("IndexMaster",TakeRecordDR,BloodComponentsDR,""),-1)
		 	q:TakeRecordComponentsDR=""
		 	s TakeRecordComponentsData = $g(^dbo.BDTakeRecordComponentsD(TakeRecordComponentsDR))
		 	s TakeVolumn = $lg(TakeRecordComponentsData,4)
		 	s TakedVolumns = TakedVolumns+TakeVolumn
		 	//s TakedVolumns=TakeVolumn
	 	}
	 	s Data = $lb(ReqFormProductDR,ReqProductDR,ReqProduct,PurposeDR,Purpose,Volumn,Unit,SpecialNeed,Remark,ReqBloodGroupDR,ReqBloodGroup,fReqFormDR,BloodComponentsDR,TakedVolumns,IsAccumulate,ScaleFactor,BloodComponents,BloodComponentsSynonym,Height,Weight,TestItemRes,RuleRes,RuleRemark)
	 	d OutPut
 	}
	
 	Set qHandle=$lb(0,repid,0)
    q $$$OK
 	
OutPut
	set ColFields="ReqFormProductDR,ReqProductDR,ReqProduct,PurposeDR,Purpose,Volumn,Unit,SpecialNeed,Remark,ReqBloodGroupDR,ReqBloodGroup,ReqFormDR,BloodComponentsDR,TakedVolumns,IsAccumulate,ScaleFactor,BloodComponents,BloodComponentsSynonym,Height,Weight,TestItemRes,RuleRes,RuleRemark"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QryReqFormProductClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReqFormProductExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryReqFormProductFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReqFormProductExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
