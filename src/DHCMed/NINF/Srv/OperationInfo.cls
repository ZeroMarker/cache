/// 手麻系统接口数据
Class DHCMed.NINF.Srv.OperationInfo Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 手术记录编号
Property OperationID As %String(TRUNCATE = 1);

/// 就诊ID
Property EpisodeID As %String(TRUNCATE = 1) [ Required ];

/// 病案号
Property MrNo As %String(TRUNCATE = 1);

/// 病人姓名
Property PatName As %String(TRUNCATE = 1);

/// 手术CM3编码
Property OperationCode As %String(TRUNCATE = 1);

/// 手术名称
Property OperationName As %String(TRUNCATE = 1);

/// 手术开始日期
Property StartDate As %Date;

/// 手术开始时间
Property StartTime As %Time;

/// 手术结束日期
Property EndDate As %Date;

/// 手术结束时间
Property EndTime As %Time;

/// 手术医生代码
Property OperatorCode As %String(TRUNCATE = 1);

/// 手术医生名称
Property OperatorName As %String(TRUNCATE = 1);

/// 手术类型
Property OperationType As %String(DISPLAYLIST = ",急诊,择期,损伤", TRUNCATE = 1, VALUELIST = ",E,B,I");

/// 术前外周WBC
Property OperationWBC As %String(TRUNCATE = 1);

/// 切口个数
Property CutNumber As %String(TRUNCATE = 1);

/// 切口等级描述 清洁/清洁污染/污染
Property CutGradeDesc As %String(TRUNCATE = 1);

/// 切口等级代码
Property CutGradeCode As %String(TRUNCATE = 1);

/// 愈合情况  甲/乙/丙
Property HealState As %String(TRUNCATE = 1);

/// 麻醉方法描述 全麻/复合/硬膜外/局麻/其它
Property NarcosisModeDesc As %String(TRUNCATE = 1);

/// 麻醉方法代码
Property NarcosisModeCode As %String(TRUNCATE = 1);

/// ASA（麻醉）评分 I/II/III/IV/V
Property NarcosisFraction As %String(TRUNCATE = 1);

/// 失血量（MLS）
Property LoseBlood As %String(TRUNCATE = 1);

/// 输血量（MLS）
Property EnterBlood As %String(TRUNCATE = 1);

/// 术前口服抗生素肠道准备
Property IsAntibiotic As %String(DISPLAYLIST = ",是,否", TRUNCATE = 1, VALUELIST = ",Y,N");

/// 植入物
Property IsImplants As %String(DISPLAYLIST = ",是,否", TRUNCATE = 1, VALUELIST = ",Y,N");

/// 使用窥镜
Property IsLookinGlass As %String(DISPLAYLIST = ",是,否", TRUNCATE = 1, VALUELIST = ",Y,N");

/// 是否急诊手术
Property IsEmergencyMark As %String(DISPLAYLIST = ",是,否", TRUNCATE = 1, VALUELIST = ",Y,N");

/// 病人所在科室代码
Property DeptCode As %String(TRUNCATE = 1);

/// 病人所在科室名称
Property DeptDesc As %String(TRUNCATE = 1);

/// 手术科室代码
Property OperatingDeptCode As %String(TRUNCATE = 1);

/// 手术科室名称
Property OperatingDeptDesc As %String(TRUNCATE = 1);

/// 手术诊断
Property OperatingDiagnose As %String(TRUNCATE = 1);

/// 引流
Property IsDrainage As %String(DISPLAYLIST = ",是,否", TRUNCATE = 1, VALUELIST = ",Y,N");

/// 穿孔
Property IsPerforation As %String(DISPLAYLIST = ",是,否", TRUNCATE = 1, VALUELIST = ",Y,N");

/// 瘘管
Property IsFistula As %String(DISPLAYLIST = ",是,否", TRUNCATE = 1, VALUELIST = ",Y,N");

/// 切口裂开
Property IsCutDehiscence As %String(DISPLAYLIST = ",是,否", TRUNCATE = 1, VALUELIST = ",Y,N");

/// 脂肪液化
Property IsFatLiquefaction As %String(DISPLAYLIST = ",是,否", TRUNCATE = 1, VALUELIST = ",Y,N");

/// 深静脉血栓
Property IsDeepVein As %String(DISPLAYLIST = ",是,否", TRUNCATE = 1, VALUELIST = ",Y,N");

Index IndexOfEpisodeID On EpisodeID;

Index IndexOfOperationID On OperationID;

ClassMethod GetObjectByID(ID As %String) As DHCMed.NINF.Srv.OperationInfo
{
	New (ID)
	Set Rtn=""
	Quit:ID="" Rtn
	Quit:'##Class(DHCMed.NINF.Srv.OperationInfo).%ExistsId(ID) Rtn
	Set Obj=##Class(DHCMed.NINF.Srv.OperationInfo).%OpenId(ID)
	Set Rtn=Obj
	Do Obj.%Close()
	Quit Rtn
}

/// 描述：更新手术信息
/// w ##Class(DHCMed.NINF.Srv.OperationInfo).Update($g(^DHCMed.OperationInfo(63008,61424)))
ClassMethod Update(argInput As %String) As %String
{
	New (argInput)
	Set Rtn=-1
	Quit:argInput="" Rtn
	
	Set $ZT="UpdateOperationErr"
	
	Set ^DHCMed.OperationInfo(+$h,$p($h,",",2))=argInput
	
	Set (OperationID,EpisodeID,Sex,Age,MrNo,PatName,OperationCode,OperationName,StartDate,StartTime,EndDate,EndTime,OperatorCode,
	OperatorName,OperationType,OperationWBC,CutNumber,CutGradeDesc,CutGradeCode,HealState,NarcosisModeDesc,NarcosisModeCode,
	NarcosisFraction,LoseBlood,EnterBlood,IsAntibiotic,IsImplants,IsLookinGlass,IsEmergencyMark,DeptCode,DeptDesc,OperatingDeptCode,
	OperatingDeptDesc,OperatingDiagnose,IsDrainage,IsPerforation,IsFistula,IsCutDehiscence,IsFatLiquefaction,IsDeepVein)=""
	
	;1-patientid, 2-e_date, 3-姓名, 4-性别, 5-年龄, 6-住院号, 7-科室, 8-手术诊断, 9-手术名称, 10-急诊, 11-ASA, 12-麻醉方法, 13-手术医生, 
	;14-手术开始时间, 15-手术结束时间, 16-手术科室, 17-自体血, 18-医嘱号, 19-主刀,  20-助1, 21-助2, 22-助3, 23-助4, 24-输血, 25-出血量, 26-手术切口
	
	Set MrNo=$P(argInput,"^",6)
	Set PatName=$P(argInput,"^",3)
	Set Sex=$P(argInput,"^",4)
	Set Age=$P(argInput,"^",5)
	Set DeptDesc=$P(argInput,"^",7)       ;病人所在科室名称
	Set OperatingDiagnose=$P(argInput,"^",8)    ;手术诊断
	Set OperationName=$P(argInput,"^",9)
	Set OperationType=$P(argInput,"^",10) ;手术类型
	Set:OperationType["急诊" OperationType="E"
	Set:OperationType["择期" OperationType="B"
	Set:OperationType["损伤" OperationType="I"
	Set NarcosisFraction=$P(argInput,"^",11) ;ASA（麻醉）评分
	Set NarcosisModeDesc=$P(argInput,"^",12) ;麻醉方法描述
	Set OperatorName=$P(argInput,"^",19)  ;手术医生名称
	
	//手术开始时间
	Set StartDate=$P(argInput,"^",14)
	Set:StartDate[" " StartTime=$p(StartDate," ",2),StartDate=$p(StartDate," ",1)
	Set:StartDate'="" StartDate=$tr(StartDate,".","-")
	Set:StartDate'="" StartDate=$zdh(StartDate,3)
	Quit:StartDate="" -11  ;手术日期为空
	Set:StartTime'="" StartTime=$zth(StartTime,2)
	
	//手术结束时间
	Set EndDate=$P(argInput,"^",15)
	Set:EndDate[" " EndTime=$p(EndDate," ",2),EndDate=$p(EndDate," ",1)
	Set:EndDate'="" EndDate=$tr(EndDate,".","-")
	Set:EndDate'="" EndDate=$zdh(EndDate,3)
	Set:EndTime'="" EndTime=$zth(EndTime,2)
	
	Set OperatingDeptDesc=$P(argInput,"^",16)          ;手术科室名称
	Set EnterBlood=$P(argInput,"^",24)       ;输血量（MLS）
	Set LoseBlood=$P(argInput,"^",25)        ;失血量（MLS）
	
	//add by zf 20130705 增加手术切口字段
	Set CutGradeDesc=$P(argInput,"^",26)      ;手术切口
	Set CutGradeCode=""
	Set:CutGradeDesc["Ⅰ" CutGradeCode="Ⅰ"
	Set:CutGradeDesc["Ⅱ" CutGradeCode="Ⅱ"
	Set:CutGradeDesc["Ⅲ" CutGradeCode="Ⅲ"
	
	
	//通过病案号（或患者姓名、性别、年龄）、手术日期，反推就诊号
	Set EpisodeID=..GetEpisodeIDByMrNoAndOperDate(MrNo,PatName,Sex,Age,StartDate)
	Quit:EpisodeID=-1 -8      ;找不到就诊
	
	Set OperationID=EpisodeID_"||"_StartDate
	Set RowID=$O(^DHCMed.NINFSi("OperationInfo",0,"IndexOfOperationID"," "_OperationID,0))
	If (RowID'=""){
		Set Obj=##Class(DHCMed.NINF.Srv.OperationInfo).%OpenId(RowID)
	}Else{
		Set Obj=##Class(DHCMed.NINF.Srv.OperationInfo).%New()	
	}
	Quit:'$IsObject(Obj) -10  ;记录错误
	
	Set OperatorCode=..GetSSUsrByEpisodeIDAndDocName(EpisodeID,OperatorName)
	Set Obj.OperationID=OperationID
	Set Obj.EpisodeID=EpisodeID
	Set Obj.MrNo=MrNo
	Set Obj.PatName=PatName
	Set Obj.OperationCode=OperationCode
	Set Obj.OperationName=OperationName
	Set Obj.StartDate=StartDate
	Set Obj.StartTime=StartTime
	Set Obj.EndDate=EndDate
	Set Obj.EndTime=EndTime
	Set Obj.OperatorCode=OperatorCode
	Set Obj.OperatorName=OperatorName
	Set Obj.OperationType=OperationType
	Set Obj.OperationWBC=OperationWBC
	Set Obj.CutNumber=CutNumber
	Set Obj.CutGradeDesc=CutGradeDesc
	Set Obj.CutGradeCode=CutGradeCode
	Set Obj.HealState=HealState
	Set Obj.NarcosisModeDesc=NarcosisModeDesc
	Set Obj.NarcosisModeCode=NarcosisModeCode
	Set Obj.NarcosisFraction=NarcosisFraction
	Set Obj.LoseBlood=LoseBlood
	Set Obj.EnterBlood=EnterBlood
	Set Obj.IsAntibiotic=IsAntibiotic
	Set Obj.IsImplants=IsImplants
	Set Obj.IsLookinGlass=IsLookinGlass
	Set Obj.IsEmergencyMark=IsEmergencyMark
	Set Obj.DeptCode=DeptCode
	Set Obj.DeptDesc=DeptDesc
	Set Obj.OperatingDeptCode=OperatingDeptCode
	Set Obj.OperatingDeptDesc=OperatingDeptDesc
	Set Obj.OperatingDiagnose=OperatingDiagnose
	Set Obj.IsDrainage=IsDrainage
	Set Obj.IsPerforation=IsPerforation
	Set Obj.IsFistula=IsFistula
	Set Obj.IsCutDehiscence=IsCutDehiscence
	Set Obj.IsFatLiquefaction=IsFatLiquefaction
	Set Obj.IsDeepVein=IsDeepVein
	Set Obj.CutGradeDesc=CutGradeDesc  //手术切口描述
	Set Obj.CutGradeCode=CutGradeCode  //手术切口代码
	
	Set sc=Obj.%Save()
	If $System.Status.IsError(sc) {        //检查Save是否成功
   		//Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=Obj.%Id()
		Set return=0
	}
	Do Obj.%Close()
	
	Quit return
	
UpdateOperationErr
	Quit $ZError
}

/// 描述：根据病案号和手术日期获取EpisodeID;
///      出院病人判断手术日期在AdmDate和DischDate之间，在院病判断就诊日期小于手术日期
/// Debug:w ##Class(DHCMed.NINF.Srv.OperationInfo).GetEpisodeIDByMrNoAndOperDate("住院","张美嵌","女",46,62928)
ClassMethod GetEpisodeIDByMrNoAndOperDate(MrNo As %String, PatName As %String, Sex As %String, Age As %String, OperDate As %String)
{
	New (MrNo,PatName,Sex,Age,OperDate)
	Set Rtn=-1
	;Quit:MrNo="" Rtn
	Set:OperDate["-" OperDate=$zdh(OperDate,3)
	Set:OperDate["/" OperDate=$zdh(OperDate,4)
	Set OperDate=+OperDate
	Set Papmi=""
	If (MrNo'=""){
      Set MrNo=$ZCVT(MrNo,"U")_"Z"
      Set Papmi=$O(^PAPERi("Govern",MrNo,""),-1)
	}
    If (Papmi=""){
       Set PapmiID=0
       For {
		 Set PapmiID=$o(^PAPERi("PAPER_PatName",$ZCVT(PatName,"U"),PapmiID))  
		 Quit:(PapmiID="")||(Papmi'="")
		 Set (PatSex,PatDOB,PatAge)=""
		 Set PatCTSexID=$p($g(^PAPER(PapmiID,"ALL")),"^",7)
		 Set:PatCTSexID'="" PatSex=$p($g(^CT("SEX",PatCTSexID)),"^",2)
		 Set PatDOB=$p($g(^PAPER(PapmiID,"ALL")),"^",6)
		 Set:+PatDOB>0 PatAge=$p($zd($h,3),"-",1)-$p($zd(PatDOB,3),"-",1)
		 
		 Set:(Sex=PatSex)&&(Age=PatAge) Papmi=PapmiID
	   }
    }
    Quit:Papmi="" Rtn
    Set Paadm=0,EpisodeID=""
    For {
		Set Paadm=$O(^PAPERdr(Papmi,"ADM","I",Paadm))
		Quit:(Paadm="")||(EpisodeID'="")
        
        //Set AdmDate=$P($g(^PAADM(Paadm)),"^",6)
        //Set AdmTime=$P($g(^PAADM(Paadm)),"^",7)
        //upadte by pylian 2016-02-18 修改入院时间取值方式
    	Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(Paadm)
		Set AdmDate=$p(AdmDateTime,"^",1)
		Set AdmTime=$p(AdmDateTime,"^",2)
        //Set DischDate=$P($g(^PAADM(Paadm)),"^",17)
        //Set DischTime=$P($g(^PAADM(Paadm)),"^",18)
        //Update by pylian 2016-01-21 修改出院时间取值方式
		Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(Paadm)
		Set DischDate=$p(DischDateTime,"^",1)
		Set DischTime=$p(DischDateTime,"^",2)
	
        Set:(DischDate'="")&&((AdmDate<=OperDate)&&(DischDate>=OperDate)) EpisodeID=Paadm  ;出院病人
        Set:(DischDate="")&&(AdmDate<=OperDate) EpisodeID=Paadm ;在院病人
	}
	Set:EpisodeID'="" Rtn=EpisodeID
	Quit Rtn
}

/// 描述：根据就诊ID和手术名字
ClassMethod GetSSUsrByEpisodeIDAndDocName(EpisodeID As %String, DocName As %String)
{
	New (EpisodeID,DocName)
	Set Rtn=""
	Quit:DocName="" Rtn
	
	Set DocName=$ZCVT(DocName,"U")
	Set SSUsrID=0,LastUsrID="",CompUsrID=""
	For {
		Set SSUsrID=$O(^SSU("SSUSR",0,"SSUSR_Name",DocName,0)) 
		Quit:(SSUsrID="")||(CompUsrID'="")
		Set LastUsrID=SSUsrID
		Set DefaultLocDR=$P(^SSU("SSUSR",SSUsrID),"^",4)
		Set AdmDepDR=$P(^PAADM(EpisodeID),"^",4)
		Set:DefaultLocDR=AdmDepDR CompUsrID=SSUsrID
	}
	Set:CompUsrID'="" Rtn=CompUsrID
	Set:CompUsrID="" Rtn=LastUsrID
	Quit Rtn
}

/// 描述：根据科室名称获取科室ID
/// w ##Class(DHCMed.NINF.Srv.OperationInfo).GetLocByDesc("泌尿外科一区")
ClassMethod GetLocByDesc(LocDesc As %String) As %String
{
	New (LocDesc)
	Set Rtn="",Str="科"
	Set:LocDesc["科" LocDesc=$ZCVT($e(LocDesc,0,$f(LocDesc,Str)-1),"U")
	If ($d(^RBC("DEP",0,"Desc",LocDesc))){
		Set DepID=$O(^RBC("DEP",0,"Desc",LocDesc,0))
		;^CTLOC(0,"DepGrp",{CTLOC_Dep_DR},{CTLOC_RowID}) 
		Set LocID=0
		For {
		    Set LocID=$O(^CTLOC(0,"DepGrp",DepID,LocID)) 	
		    Quit:(LocID="")||(Rtn'="")
		    
		    Set Desc=$p(^CTLOC(LocID),"^",2)
		    Set:Desc["-" Desc=$p(Desc,"-",2)
		    Continue:Desc'=LocDesc	
		    Set Rtn=LocID
		}
	}
	Quit Rtn
}

/// 描述：根据EpisodeID获取病人手术信息条数
ClassMethod GetOprOfCountByEpisodeID(EpisodeID As %String)
{
	New (EpisodeID)
	Set Rtn=0
	Set OperationID=$O(^DHCMed.NINFSi("OperationInfo",0,"IndexOfEpisodeID"," "_EpisodeID,""),-1)
	Set:OperationID'="" Rtn=1
	Quit Rtn
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Antibiotic</Value>
</Value>
<Value name="3">
<Value>CutDehiscence</Value>
</Value>
<Value name="4">
<Value>CutGradeCode</Value>
</Value>
<Value name="5">
<Value>CutGradeDesc</Value>
</Value>
<Value name="6">
<Value>CutNumber</Value>
</Value>
<Value name="7">
<Value>DeepVein</Value>
</Value>
<Value name="8">
<Value>DeptCode</Value>
</Value>
<Value name="9">
<Value>DeptDesc</Value>
</Value>
<Value name="10">
<Value>Drainage</Value>
</Value>
<Value name="11">
<Value>EmergencyMark</Value>
</Value>
<Value name="12">
<Value>EndDate</Value>
</Value>
<Value name="13">
<Value>EndTime</Value>
</Value>
<Value name="14">
<Value>EnterBlood</Value>
</Value>
<Value name="15">
<Value>FatLiquefaction</Value>
</Value>
<Value name="16">
<Value>Fistula</Value>
</Value>
<Value name="17">
<Value>HealState</Value>
</Value>
<Value name="18">
<Value>ID</Value>
</Value>
<Value name="19">
<Value>Implants</Value>
</Value>
<Value name="20">
<Value>LookinGlass</Value>
</Value>
<Value name="21">
<Value>LoseBlood</Value>
</Value>
<Value name="22">
<Value>MrNo</Value>
</Value>
<Value name="23">
<Value>NarcosisFraction</Value>
</Value>
<Value name="24">
<Value>NarcosisModeCode</Value>
</Value>
<Value name="25">
<Value>NarcosisModeDesc</Value>
</Value>
<Value name="26">
<Value>OperatingDeptCode</Value>
</Value>
<Value name="27">
<Value>OperatingDeptDesc</Value>
</Value>
<Value name="28">
<Value>OperatingDiagnose</Value>
</Value>
<Value name="29">
<Value>OperationCode</Value>
</Value>
<Value name="30">
<Value>OperationName</Value>
</Value>
<Value name="31">
<Value>OperationType</Value>
</Value>
<Value name="32">
<Value>OperationWBC</Value>
</Value>
<Value name="33">
<Value>OperatorCode</Value>
</Value>
<Value name="34">
<Value>OperatorName</Value>
</Value>
<Value name="35">
<Value>PatName</Value>
</Value>
<Value name="36">
<Value>Perforation</Value>
</Value>
<Value name="37">
<Value>StartDate</Value>
</Value>
<Value name="38">
<Value>StartTime</Value>
</Value>
<Value name="39">
<Value>EpisodeID</Value>
</Value>
<Value name="40">
<Value>OperationID</Value>
</Value>
<Value name="41">
<Value>IsAntibiotic</Value>
</Value>
<Value name="42">
<Value>IsCutDehiscence</Value>
</Value>
<Value name="43">
<Value>IsDeepVein</Value>
</Value>
<Value name="44">
<Value>IsDrainage</Value>
</Value>
<Value name="45">
<Value>IsEmergencyMark</Value>
</Value>
<Value name="46">
<Value>IsFatLiquefaction</Value>
</Value>
<Value name="47">
<Value>IsFistula</Value>
</Value>
<Value name="48">
<Value>IsImplants</Value>
</Value>
<Value name="49">
<Value>IsLookinGlass</Value>
</Value>
<Value name="50">
<Value>IsPerforation</Value>
</Value>
<Value name="51">
<Value>OperationTypeCode</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINFS("OperationInfo")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINFS("OperationInfo")</IdLocation>
<IndexLocation>^DHCMed.NINFSi("OperationInfo",0)</IndexLocation>
<StreamLocation>^DHCMed.N.OperationInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
