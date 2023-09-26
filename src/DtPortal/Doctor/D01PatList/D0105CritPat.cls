/// DtPortal.Doctor.D01PatList.D0105CritPat
/// 描述:Portal医生角色 D01危重患者服务
/// 创建者：  程鹏
/// 创建日期: 2018-11-03
Class DtPortal.Doctor.D01PatList.D0105CritPat Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator： 	程鹏
/// CreatDate： 2018-11-03
/// Description: 查询当日危重患者列表
/// Input：		QueryType : 查询单位(P:本人  PG 本主诊组  loc:科室 ward:病区); 
/// 			QureyID :   本人,主诊组为空,科室,病区为为CT_LOC表id 
/// 			UserCode:用户code
/// Return：	BedNo：床号
/// 			MedicareNo：病案号
/// 			Name：姓名
/// 			Sex：性别
/// 			Age：年龄
/// 			PAPMINO：登记号 
/// 			CareLevel：护理级别
/// 			VitalSign：生命体征
/// 			ManagerDoc：主管医师
/// 			ChargeDoc：主治医师
/// 			DirDoc：主任医师
/// 			DiagnoseDesc：诊断  
/// 			AdmNo：就诊号      //感染二科
/// 服务号:		D01.05.01
/// d ##class(%ResultSet).RunQuery("DtPortal.Doctor.D01PatList.D0105CritPat","D010501CritPat","P","","4829")
/// d ##class(%ResultSet).RunQuery("DtPortal.Doctor.D01PatList.D0105CritPat","D010501CritPat","PG","","4829")
/// d ##class(%ResultSet).RunQuery("DtPortal.Doctor.D01PatList.D0105CritPat","D010501CritPat","loc","105","4829")
/// d ##class(%ResultSet).RunQuery("DtPortal.Doctor.D01PatList.D0105CritPat","D010501CritPat","ward","193","4829")
Query D010501CritPat(QueryType As %String, QueryID As %String, UserCode As %String) As DtPortal.Query(ROWSPEC = "BedNo,MedicareNo,Name,Sex,Age,PAPMINO, CareLevel,VitalSign,ManagerDoc,ChargeDoc,DirDoc,DiagnoseDesc,UserCode,dept,Ward,TempValue,BreatheValue,PulseValue,BloodPressureValue,PatType,EMRDocID,EMRInstanceID,locID,PatientID,EpisodeID,UserId")
{
}

ClassMethod D010501CritPatExecute(ByRef qHandle As %Binary, QueryType As %String, QueryID As %String, UserCode As %String) As %Status
{
	n (qHandle,QueryType,QueryID,UserCode)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	quit:((QueryType="")&&(UserCode="")) $$$OK
	
	//获得查询范围
	set rangeType=1,UserId=""
	s UserId=##class(DtPortal.Common.PublicService).GetUserID(UserCode)
	if QueryType="ward"
	{
		set wardID=$o(^PAWARD(0,"WARD_LocationDR",QueryID,""))
		set QueryID=wardID
		
	}
	
	
	//根据配置医嘱code取医嘱ID,病危+病重
	set ArcIDs=##Class(DtPortal.Configure.arcim).getArcImID("SERIOUSLY^CRITICALLY",1)	
	//根据配置医嘱code取医嘱ID,全部护理
	set ArcIDsNur=##Class(DtPortal.Configure.arcim).getArcImID("NURSELEVEL",1)	
	set admPatList=##Class(DtPortal.Common.PaadmService).GetIPPaadmList(QueryType,UserId,QueryID)
	for admIndex=1:1:$l(admPatList,"^")
	{
		set PAAdm=$p(admPatList,"^",admIndex)
		continue:PAAdm=""
		set VitalSign="",ManagerDoc=""
		set isHave=##class(DtPortal.Common.PaadmService).IsHaveArc(PAAdm,ArcIDs)
		continue:isHave=""
		set PatType=isHave
		s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(PAAdm)
		s BedNo=$p(patInfoStr,"^",1)
		s MedicareNo=$p(patInfoStr,"^",5)
		s Name=$p(patInfoStr,"^",2)
		s Sex=$p(patInfoStr,"^",3)
		s Age=$p(patInfoStr,"^",4)
		s AdmReason=$p(patInfoStr,"^",6)
		
		Set PatientID=$P($g(^PAADM(PAAdm)),"^",1)
		s AdmNo=$p(^PAADM(PAAdm),"^",81)
		s PAPMINo=$p(patInfoStr,"^",7)
		Set DobDate=$P($g(^PAPER(PatientID,"ALL")),"^",6)
		Set PAPMINO=$P(^PAPER(PatientID,"PAT",1),"^",1)
	
		Set VitalSignStr=##class(DtPortal.Common.PaadmService).GetVitalSignByAdm(PAAdm)
		if VitalSignStr'="" s VitalSign="T:"_$p(VitalSignStr,"^",1)_"℃ ,"_"P:"_$p(VitalSignStr,"^",2)_"次/分 ,"_"R:"_$p(VitalSignStr,"^",3)_"次/分 ,"_"BP:"_$p(VitalSignStr,"^",4)_"/"_$p(VitalSignStr,"^",5)	
		//分开取生命体征
		s TempValue="T:"_$p(VitalSignStr,"^",1)_"℃"           //体温
		s BreatheValue="R:"_$p(VitalSignStr,"^",3)_"次/分"       //呼吸 
		s PulseValue="P:"_$p(VitalSignStr,"^",2)_"次/分"     //脉搏
		i $p(VitalSignStr,"^",4)'="" d
		.s BloodPressureValue="BP:"_$p(VitalSignStr,"^",4)_"/"_$p(VitalSignStr,"^",5)
		e  s BloodPressureValue="BP:"
		s DiagnoseDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(PAAdm)
		S AdmNo=$P($g(^PAADM(PAAdm)),"^",81)
		
		set UserDr=""
		s DocDr=$P($g(^PAADM(PAAdm)),"^",9)
		s:DocDr'="" UserDr=$o(^SSU("SSUSR",0,"CTPCP",DocDr,0))
		set Resident="",Attending="",Chief=""

		set CareLevel=##class(DtPortal.Common.PaadmService).IsHaveArc(PAAdm,ArcIDsNur)
		Set Loc=$P($g(^PAADM(PAAdm)),"^",4)
		s dept="",Ward=""
		if Loc'="" s dept=$p($g(^CTLOC(Loc)),"^",2)
		if dept["-" s dept=$p(dept,"-",2)
		s WardID=$p(^PAADM(PAAdm),"^",70)
		i WardID'="" s Ward=$p(^PAWARD(WardID),"^",2)
		i Ward["-" s Ward=$p(Ward,"-",2)
		
		//获取打开电子病历所需要的参数
		set EMRinfo=##class(DtPortal.Common.PaadmService).GetEMRParameter(PAAdm)
		set EMRDocID=$p(EMRinfo,"^",1)
		set EMRInstanceID=$p(EMRinfo,"^",2)
		set locID=$p(EMRinfo,"^",3)
		set PatientID=$p(EMRinfo,"^",4)
		set EpisodeID=$p(EMRinfo,"^",5)
		
		Set ^||CacheTemp(repid,ind)=$lb(BedNo,MedicareNo,Name,Sex,Age,PAPMINO, CareLevel,VitalSign,ManagerDoc,ChargeDoc,DirDoc,DiagnoseDesc,UserCode,dept,Ward,TempValue,BreatheValue,PulseValue,BloodPressureValue,PatType,EMRDocID,EMRInstanceID,locID,PatientID,EpisodeID,UserId)
		Set ind=ind+1
	}
	
	quit $$$OK
}

}
