Class EPRservice.BLL.BLPatientList Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:根据条件查询病人基本信息列表
/// Creator: Candyxu
/// Create Date：2012-07-27 
/// Modify: yang
/// Modify Date: 2012-10-15
/// Input:	AStartDate 开始日期，
/// 		AStartTime 开始时间，
/// 		AEndDate 结束日期，
/// 		AEndTime 结束时间
///       	AWard 病区ID，
///       	APatientNo 病人登记号，
///       	APatientName 病人姓名
///       	ALocID 科室ID,
///       	AAdmType 就诊类型
/// Output:PAAdmType 就诊类型,PAPMINO 登记号,PAPMIDOB 出生日期,PAPMIAge 年龄,PAPMISex 性别
///       PAAdmDateTime 入院时间,PAAdmWard 病区,PAAdmRoom 病房,PAAdmBed病床,PAAdmLoc就诊科室
///       PADischgeDateTime出院时间,PAAdmDoc医生,PayMode付费类型
/// Debug:do ##class(%ResultSet).RunQuery("EPRservice.BLL.BLPatientList","GetPatientList","00000011^^^^^^^^^^^^","^^^^2012-09-11^^^^^^")
Query GetPatientList(AParam As %String, AFilterParam As %String) As %Query(ROWSPEC = "PAStatusType:%String,PAAdmType:%String,PAPMIName:%String,PAPMINO:%String,PAPMIDOB:%String,PAPMIAge:%String,PAPMISex:%String,PAAdmDateTime:%String,PAAdmWard:%String,PAAdmRoom:%String,PAAdmBed:%String,PAAdmLoc:%String,PADischgeDateTime:%String,PAAdmDoc:%String,PayMode:%String,EpisodeID:%String,PatientID:%String")
{
}

ClassMethod GetPatientListExecute(ByRef qHandle As %Binary, AParam As %String, AFilterParam As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s APatientNo = $p(AParam,"^",1)
	s APatientName = $p(AParam,"^",2)
	s ALocID = $p(AParam,"^",3)
    s AWard = $p(AParam,"^",4)
	s AStartDate = $p(AParam,"^",5)
	s AStartTime = $p(AParam,"^",6)
	s AEndDate = $p(AParam,"^",7)
	s AEndTime = $p(AParam,"^",8)
	s AOutStartDate = $p(AParam,"^",9)
	s AOutStartTime = $p(AParam,"^",10)
	s AOutEndDate = $p(AParam,"^",11)
	s AOutEndTime = $p(AParam,"^",12)
	s AAdmNo = $p(AParam,"^",13)
	
	s APAStatusType = $p(AFilterParam,"^",1)
	s APAAdmType = $p(AFilterParam,"^",2) 
	s AGender = $p(AFilterParam,"^",3)
	s AAge = $p(AFilterParam,"^",4)
	s ABirthday = $p(AFilterParam,"^",5)
	s AMarriage = $p(AFilterParam,"^",6)  
	s ANation = $p(AFilterParam,"^",7)
	s AMobilePhone = $p(AFilterParam,"^",8)
	s AOccupation = $p(AFilterParam,"^",9) 
	s AProvinceBirth = $p(AFilterParam,"^",10)
	s ACityBirth = $p(AFilterParam,"^",11) 
	s AIdCardNo = $p(AFilterParam,"^",12)
 	
 	d DealParamter   //处理参数
 	
	if (AAdmNo '= ""){
		s count = 0
		for {
			s count = count + 1
			q:(count > 1)
			s PAAdm = AAdmNo
		    continue:(..CheckAdmDate(PAAdm,AStartDate,AEndDate,AStartTime,AEndTime,"in") = "invalid")
		    continue:(..CheckAdmDate(PAAdm,AOutStartDate,AOutEndDate,AOutStartTime,AOutEndTime,"out") = "invalid")
			d OutPutRow 		
		}

	}
 	elseif (APatientNo '= ""){
	 	s APatientNo = ..AddZero(APatientNo)
	 	s PAPMI = $o(^PAPERi("PAPMI_PatNo",APatientNo,""))
	 	q:(PAPMI = "") $$$OK
	 	d OutPutPAMI 
	}
	elseif (APatientName '= ""){ 
		s PAPMI = ""
		for {
		   s PAPMI = $O(^PAPERi("PAPER_PatName",APatientName,PAPMI))
		   q:(PAPMI = "")
		   d OutPutPAMI
	    }	 
	}
	elseif(AWard '= ""){
		s RowID = ""
		for {
			 s RowID = $o(^PAADMi("CurrWard",AWard,RowID))
			 q:(RowID = "")
			 s PAAdm = ""
			 for {
				 s PAAdm = $o(^PAADMi("CurrWard",AWard,RowID,PAAdm))
				 q:(PAAdm = "")
		         continue:(..CheckAdmDate(PAAdm,AStartDate,AEndDate,AStartTime,AEndTime,"in") = "invalid")
		         continue:(..CheckAdmDate(PAAdm,AOutStartDate,AOutEndDate,AOutStartTime,AOutEndTime,"out") = "invalid")
		         d OutPutRow 
			 }
		}		
	}
	else{
		//科室
		if (AStartDate '= "") {s TempDate = AStartDate-1} else {s TempDate = ""}
		for {
			s TempDate = $o(^PAADMi("DepDateTime",ALocID,TempDate))
			q:((TempDate > AEndDate) && (AEndDate '= ""))
			q:(TempDate = "")
			s TempTime = ""
			for {
				s TempTime = $o(^PAADMi("DepDateTime",ALocID,TempDate,TempTime))
				q:((TempDate = AStartDate)&&(TempTime < AStartTime))
				q:((TempDate = AEndTime)&&(TempDate > AEndTime))
				q:(TempTime = "")
				s PAAdm = ""
				for {
					s PAAdm = $o(^PAADMi("DepDateTime",ALocID,TempDate,TempTime,PAAdm))
					q:(PAAdm = "")
		       		continue:(..CheckAdmDate(PAAdm,AStartDate,AEndDate,AStartTime,AEndTime,"in") = "invalid")
		         	continue:(..CheckAdmDate(PAAdm,AOutStartDate,AOutEndDate,AOutStartTime,AOutEndTime,"out") = "invalid")
					d OutPutRow
				}
			}
		}
	}
	Quit $$$OK
	
OutPutPAMI
	s AdmType = ""
	for {
	    s AdmType = $o(^PAPERdr(PAPMI,"ADM",AdmType))
	    q:(AdmType = "")
	    s PAAdm = ""
	    for {
		     s PAAdm = $o(^PAPERdr(PAPMI,"ADM",AdmType,PAAdm))
		     q:(PAAdm = "")
			 continue:(..CheckAdmDate(PAAdm,AStartDate,AEndDate,AStartTime,AEndTime,"in") = "invalid")
		     continue:(..CheckAdmDate(PAAdm,AOutStartDate,AOutEndDate,AOutStartTime,AOutEndTime,"out") = "invalid")
		     d OutPutRow
		}
	}
	q
	
OutPutRow
	s Hospital=##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName")
	s PatientID = $p($g(^PAADM(PAAdm)),"^",1)
	s PAAdmType = $p($g(^PAADM(PAAdm)),"^",2)   
	//就诊类型
	if ((APAAdmType '= "") && (APAAdmType '= PAAdmType)) q
	if PAAdmType = "I"
	{
		s PAAdmType = "住院"
	}elseif PAAdmType = "O"
	{
		s PAAdmType = "门诊"
	}elseif PAAdmType = "E"
	{
		s PAAdmType = "急诊"
	}
	//病人姓名
	s PAPMIName = $p($g(^PAPER(PatientID,"ALL")),"^",1)  
	if ((APatientName '= "") && (APatientName '= PAPMIName)) q
	//身份证号
	s IdCardNo = $P($G(^PAPER(PatientID,"ALL")),"^",9) 
	if ((AIdCardNo '= "") && (AIdCardNo '= IdCardNo)) q
	//登记号
	s PAPMINO = $p($g(^PAPER(PatientID,"PAT",1)),"^",1) 

	if ((APatientNo '= "") && ((+APatientNo) '= (+PAPMINO))) q
	//出生日期,年龄
	s PAPMIDOB = "" ,PAPMIAge = ""  
	s DobDate = $p($g(^PAPER(PatientID,"ALL")),"^",6)
	If DobDate '= ""
	{
		s PAPMIDOB = $ZD(DobDate,3)
		s PAPMIAge = $fn((+$H-DobDate)/365,"",0)
	}
	if ((ABirthday '= "") && (ABirthday '= PAPMIDOB)) q
	if ((AAge '= "") && (AAge '= PAPMIAge)) q 
	//性别
	s Sex = $P($g(^PAPER(PatientID,"ALL")),"^",7)  
	if ((AGender '= "") && (AGender '= Sex)) q 
	s PAPMISex = $P($g(^CT("SEX",Sex)),"^",2)
	//婚姻
 	s tmpMarriage=##Class(EPRservice.HISInterface.PatientInfoAssist).Marriage(PatientID)
 	if tmpMarriage'=""
 	{
	 	s Marriage= $p($g(tmpMarriage),"^",3)
	}
	if ((AMarriage '= "") && (AMarriage '= $p($g(tmpMarriage),"^",2))) q
	//出生地
	s tmpNative=##Class(EPRservice.HISInterface.PatientInfoAssist).Native(PatientID,Hospital)
 	if tmpNative'=""
 	{
   		//出生地城市 
   		s CityBirth = $p($g(tmpNative),"!",2)
   		s CityBirth = $p($g(CityBirth),"^",2)
 
   		//出生地省份 
   		s ProvinceBirth = $p($g(tmpNative),"!",1)
   		s ProvinceBirth = $p($g(ProvinceBirth),"^",2)
 	}
 	if ((ACityBirth '= "") && (ACityBirth '= CityBirth)) q
 	if ((AProvinceBirth '= "") && (AProvinceBirth '= ProvinceBirth)) q
 	//职业
 	s tmpOccupation=##Class(EPRservice.HISInterface.PatientInfoAssist).Occupation(PatientID,Hospital)
 	i tmpOccupation'=""
 	{
   		s Occupation = $p($g(tmpOccupation),"^",2)
 	}
 	if ((AOccupation '= "") && (AOccupation '= Occupation)) q
	//民族
	s tmpNation=##Class(EPRservice.HISInterface.PatientInfoAssist).Nation(PatientID,Hospital)
	i tmpNation'=""
 	{
   		s Nation = $p($g(tmpNation),"^",2)
 	}
 	if ((ANation '= "") && (ANation '= Nation)) q
 	//手机
	s MobilePhone=##Class(EPRservice.HISInterface.PatientInfoAssist).MobilePhone(PatientID,Hospital)
	if ((AMobilePhone '= "") && (AMobilePhone '= MobilePhone)) q
	
	s PAAdmDate = $ZD($P($g(^PAADM(PAAdm)),"^",6),3) //入院日期
	s PAAdmTime = $ZT($P($g(^PAADM(PAAdm)),"^",7),3)  //入院时间
	s PAAdmDateTime = PAAdmDate_","_PAAdmTime
	if (PAAdmDateTime = ",") s PAAdmDateTime = ""
	//病区
	s PAAdmWard = ""  
	s WardDr = $P($g(^PAADM(PAAdm)),"^",70)
	if ((AWard '= "") && (AWard '= WardDr)) q
	if WardDr '= "" s PAAdmWard = $P($g(^PAWARD(WardDr)),"^",1)
	
	s PAAdmRoom = "" //病房
	s RoomDr = $P($g(^PAADM(PAAdm)),"^",69)
	if RoomDr '="" s PAAdmRoom = $p($g(^PAROOM(RoomDr)),"^",1)
	
	s PAAdmBed = ""  //病床
	s BedId = $P($g(^PAADM(PAAdm)),"^",73)   
	if BedId '= "" s PAAdmBed = $P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)
	//当前科室
	s PAAdmLoc = ""    
	s Loc = $P($g(^PAADM(PAAdm)),"^",4)  
	if ((ALocID '= "") && (ALocID '= Loc)) q	
	s PAAdmLoc = $P($g(^CTLOC(Loc)),"^",1)
	//出院日期时间
	s PADischgeDate=$P($g(^PAADM(PAAdm)),"^",17) 
	s PADischgeTime=$P($g(^PAADM(PAAdm)),"^",18)
	s PADischgeDateTime = $zd(PADischgeDate,3)_","_$zt(PADischgeTime,3)
	//在院状态
	s PAStatusType = "A"
	if (PADischgeDate = "") s PADischgeDateTime = "" 
	if (PADischgeDateTime '= "") s PAStatusType = "D"
	s ^CacheTemp("PAStatusType") = PADischgeDateTime_"||"_PAStatusType
	if ((APAStatusType '= "") && (APAStatusType '= PAStatusType)) q
	if (PAStatusType = "A")
	{
		s PAStatusType = "在院"
	}elseif (PAStatusType = "D")
	{
		s PAStatusType = "出院"
	}
	//医生 
	s PAAdmDoc = ""  
	s Doctor = $P($g(^PAADM(PAAdm)),"^",9) 
	//if ((ADoctor '= "") && (ADoctor '= Doctor)) q
	if Doctor '= ""  s PAAdmDoc = $P($g(^CTPCP(Doctor,1)),"^",2)
	//付费方式
	s PayMode = "" 
	s prtRowID = ""
	for {
		s prtRowID = $o(^DHCSFPRINTDETAIL(0,"adm",PAAdm,prtRowID))
		q:(prtRowID = "")
		s pmRowID = $p($g(^DHCSFPRINTDETAIL(prtRowID)),"^",9)
		s pmDesc = $p($g(^CT("CTPM",pmRowID)),"^",2)
		if $f(PayMode,pmDesc) = 0 s PayMode = PayMode_pmDesc_" "
	}
 	s data = $lb(PAStatusType,PAAdmType,PAPMIName,PAPMINO,PAPMIDOB,PAPMIAge,PAPMISex,PAAdmDateTime,PAAdmWard,PAAdmRoom,PAAdmBed,PAAdmLoc,PADischgeDateTime,PAAdmDoc,PayMode,PAAdm,PatientID)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1 
	q
	
DealParamter
    if ((AStartDate = $c(0)) || (AStartDate = "")) {s AStartDate = ""} else {s AStartDate = $zdh(AStartDate,3)}
    if ((AStartTime = $c(0)) || (AStartTime = "")) {s AStartTime = ""} else {s AStartTime = $zth(AStartTime)}
    if ((AEndDate = $c(0)) || (AEndDate = "")) {s AEndDate = ""} else {s AEndDate = $zdh(AEndDate,3)}
    if ((AEndTime =$c(0)) || (AEndTime = "")) {s AEndTime = ""} else {s AEndTime = $zth(AEndTime)}
    
    if ((AOutStartDate = $c(0)) || (AOutStartDate = "")) {s AOutStartDate = ""} else {s AOutStartDate = $zdh(AOutStartDate,3)}
    if ((AOutStartTime = $c(0)) || (AOutStartTime = "")) {s AOutStartTime = ""} else {s AOutStartTime = $zth(AOutStartTime)}
    if ((AOutEndDate = $c(0)) || (AOutEndDate = "")) {s AOutEndDate = ""} else {s AOutEndDate = $zdh(AOutEndDate,3)}
    if ((AOutEndTime =$c(0)) || (AOutEndTime = "")) {s AOutEndTime = ""} else {s AOutEndTime = $zth(AOutEndTime)}
    
    if AWard = $c(0) s AWard = ""
    if AWard '= ""
    {
       s TempWard = $o(^PAWARD(0,"WARD_LocationDR",AWard,""))
       if TempWard '= "" s AWard = TempWard
    }
    if APatientNo = $c(0) s APatientNo = ""
    if APatientName = $c(0) s APatientName = ""
    if ALocID = $c(0) s ALocID = ""
    if APAStatusType = $c(0) s APAStatusType = ""
    q
}

ClassMethod GetPatientListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatientListExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPatientListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatientListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// Desc:时间是否在查询范围内
/// Creator: Candyxu
/// Create Date:2012-07-27
/// [Previously private]
/// [Previously private]
ClassMethod CheckAdmDate(Adm As %String, DateFrom As %Date, DateTo As %Date, TimeFrom As %Time, TimeTo As %Time, Type As %String) As %Status
{
	s AdmDate = ""
	s AdmTime = ""
	if (Type = "in"){
		s AdmDate = $P($g(^PAADM(Adm)),"^",6)
		s AdmTime = $P($g(^PAADM(Adm)),"^",7)
	}
	else{
		s AdmDate = $P($g(^PAADM(Adm)),"^",17)
		s AdmTime = $P($g(^PAADM(Adm)),"^",18)	
	}

	if (DateFrom '= "")&&(AdmDate < DateFrom) q "invalid" 
	if (TimeFrom '= "")&&(AdmDate = DateFrom)&&(AdmTime < TimeFrom) q "invalid" 
	If (DateTo '= "")&&(AdmDate > DateTo) q "invalid" 
	if (TimeTo '= "")&&(AdmDate = DateTo)&&(AdmTime>TimeTo) q "invalid" 
	//出院日期为空，过滤条件截至日期不为空
	if (Type = "out")&&(DateTo '= "") && (AdmDate = "") q "invalid"
	q "valid"
}

ClassMethod AddZero(APatientNo As %String) As %String
{
	s patientNo = ""
	s patientNo = $o(^PAPERi("PAPMI_PatNo",patientNo))
	s patientNo = $tr(patientNo, " ")
	s patientNo = $tr(patientNo,$c(10),"")
	s patientNo = $tr(patientNo,$c(13),"")
	s length = $l(patientNo)
	q:(length = $l(APatientNo)) APatientNo
	
	for index=1:1:(length - $l(APatientNo)) {
		s APatientNo = "0"_APatientNo
	}
	q APatientNo
}

}
