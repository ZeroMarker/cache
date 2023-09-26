/// 名称: DHCMA.Util.IO.SyncAdmSrv
/// 描述: 就诊记录 提供接口服务
/// 编写者：zhufei
/// 编写日期: 2019-01-17
Class DHCMA.Util.IO.SyncAdmSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      zhufei
/// CreatDate：    2019-01-17
/// Description:   查询就诊记录
/// Table：        PA_Adm
/// Input：        无
/// Output：       代码：Code、名称：Desc
/// d ##class(%ResultSet).RunQuery("DHCMA.Util.IO.SyncAdmSrv","GetEpisInfo","16")
Query GetEpisInfo(aEpisodeID As %String) As %Query(ROWSPEC = "EpisodeID:%String,PatientID:%String,AdmType:%String,VisitStatus:%String,AdmNo:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Nation:%String,Birthday:%String,Age:%String,IdentityCode:%String,HomeAddress:%String,Company:%String,RelativeName:%String,RelativeTel:%String,IsDeath:%String,DeathDate:%String,DeathTime:%String,AdmTimes:%String,AdmDate:%String,AdmTime:%String,AdmLocID:%String,AdmWardID:%String,AdmRoom:%String,AdmBed:%String,AdmDocID:%String,DischDate:%String,DischTime:%String,AdmDays:%String,IsNewBaby:%String,BirthWeight:%String,AdmitWeight:%String,MotherDr:%String,LocDesc:%String,WardDesc:%String,DocName:%String")
{
}

ClassMethod GetEpisInfoExecute(ByRef qHandle As %Binary, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	Quit:aEpisodeID="" $$$OK
	Set AdmStr=$g(^PAADM(aEpisodeID))
	Quit:AdmStr="" $$$OK
	Set PatientID=$p(AdmStr,"^",1)      // 病人ID
	Quit:PatientID="" $$$OK
	
	//病人基本信息
	Set PapmiNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)               // 登记号
	Set PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1)                 // 病人姓名
	Set Sex=$p($g(^CT("SEX",$p($g(^PAPER(PatientID,"ALL")),"^",7))),"^",2)
	Set Sex=$s(Sex="男":"M",Sex="女":"F",1:"O")                       // 性别（M男、F女、O其他）
	Set Nation=$p($g(^PAPER(PatientID,"PER",2)),"^",1)
	Set:Nation'="" Nation=$p($g(^CT("NAT",Nation)),"^",2)             // 民族
	Set Birthday=$p($g(^PAPER(PatientID,"ALL")),"^",6)                // 出生日期
	Set IdentityCode=$p($g(^PAPER(PatientID,"ALL")),"^",9)            // 身份证号码
	//病人身份证号不存在时不再取值为证件号码
	//Set:IdentityCode="" IdentityCode=$p($g(^PAPER(PatientID,"PAT",3)),"^",6)
	Set HomeAddress=$g(^PAPER(PatientID,"PER","ADD",1))               // 现住址
	Set Company=$p($g(^PAPER(PatientID,"PER",4)),"^",18)              // 工作单位
	Set RelativeName=$p($g(^PAPER(PatientID,"PER",2)),"^",13)         // 联系人
	Set RelativeTel=$p($g(^PAPER(PatientID,"ALL")),"^",4)             // 联系人电话
	Set DeathDate=$p($g(^PAPER(PatientID,"ALL")),"^",13)              // 死亡日期
	Set DeathTime=$p($g(^PAPER(PatientID,"ALL")),"^",8)               // 死亡时间
	Set IsDeath=$s(DeathDate'="":1,1:0)                               // 死亡标志
	
	//患者就诊信息
	Set AdmType=$p(AdmStr,"^",2)	    // 就诊类型（门诊O、急诊E、住院I）
	Set VisitStatus=$p(AdmStr,"^",20)   // 就诊状态（预住院P、在院A、出院D、退院C、作废U）
	Set AdmNo=$p(AdmStr,"^",81)         // 住院号
	Set AdmTimes=$p(AdmStr,"^",29)      // 就诊次数
	Set MotherDr=$p(AdmStr,"^",75)	// 母亲就诊指针
	
	//就诊日期、时间、科室、病区、床位、医生
	Set AdmDateTime=##Class(DHCMA.Util.IO.FromHisSrv).GetAdmDateTime(aEpisodeID)
	Set AdmDate=$p(AdmDateTime,"^",1)
	Set AdmTime=$p(AdmDateTime,"^",2)
	Set AdmLocID=$p(AdmStr,"^",4)
	Set AdmLocDesc=$p($g(^CTLOC(+AdmLocID)),"^",2)
	Set:AdmLocDesc["-" AdmLocDesc=$p(AdmLocDesc,"-",2)
	Set AdmWardID=$p(AdmStr,"^",70)
	Set AdmWardID=$p($g(^PAWARD(+AdmWardID)),"^",5)  //病区科室转换一下
	Set AdmWardDesc=$p($g(^CTLOC(+AdmWardID)),"^",2)
	Set:AdmWardDesc["-" AdmWardDesc=$p(AdmWardDesc,"-",2)
	Set AdmRoom=$p(AdmStr,"^",69)
	Set:AdmRoom'="" AdmRoom=$p($g(^PAROOM(AdmRoom)),"^",2)
	Set AdmBed=$p(AdmStr,"^",73)
	Set:AdmBed'="" AdmBed=$p($g(^PAWARD(+AdmBed,"BED",$p(AdmBed,"||",2))),"^",1)
	Set AdmDocID=$p(AdmStr,"^",9)
	Set AdmDocName=$p($g(^CTPCP(+AdmDocID,1)),"^",2)
	//出院日期、出院时间
	Set DischDateTime=##Class(DHCMA.Util.IO.FromHisSrv).GetDischDateTime(aEpisodeID)
	Set DischDate=$p(DischDateTime,"^",1)
	Set DischTime=$p(DischDateTime,"^",2)
	
	//病案号
	Set MrNo=##Class(DHCMA.Util.IO.FromHisSrv).GetMrNoByAdm(aEpisodeID)
	
	//年龄计算
	Set Age=##class(DHCMA.Util.IO.FromHisSrv).GetPapmiAge(PatientID,aEpisodeID,AdmDate,AdmTime)
	
	//住院天数（未出院-1）
	If DischDate'="" {
		//Set AdmDays=DischDate-AdmDate+1
		Set AdmDays=DischDate-AdmDate   //修复bug:统一住院天数计算
		Set:AdmDays<1 AdmDays=1
	} Else {
		Set AdmDays=-1
	}
	
	//是否新生儿、新生儿出生体重、新生儿入院体重
	Set IsNewBaby=0,BirthWeight="",AdmitWeight=""
	If Birthday'=""{
		Set:(AdmDate-Birthday<=28) IsNewBaby=1	//新生儿：出生28天以内
	}
	If IsNewBaby=1{
		Set BirthWeight = ""			//新生儿出生体重（g）
		Set AdmitWeight = ""			//新生儿入院体重（g）
		Set PregID=$o(^PAPRGi("BABY_Person_DR",PatientID,""))
		If PregID'=""{
			Set DelID=$o(^PAPRGi("BABY_Person_DR",PatientID,PregID,"DEL",""))
			If DelID'=""{
				Set BabyID=$o(^PAPRGi("BABY_Person_DR",PatientID,PregID,"DEL",DelID,"BABY",""))
				If BabyID'=""{
					Set PregdelBaby=$g(^PAPRG(PregID,"DEL",DelID,"BABY",BabyID))
					Set birthdate=$p(PregdelBaby,"^",13)
					Set birthtime=$p(PregdelBaby,"^",49)
					Set BirthWeight=$zcvt($p(PregdelBaby,"^",17),"L")
					Set:(BirthWeight["kg") BirthWeight=+BirthWeight*1000
					Set:(BirthWeight'["g") BirthWeight=BirthWeight_"g"
					Set:(BirthWeight="g") BirthWeight=""
				}
			}
		}
	}
	
	Set Data=""
	Set $list(Data,1)  = aEpisodeID     // 就诊ID
	Set $list(Data,2)  = PatientID      // 病人ID
	Set $list(Data,3)  = AdmType        // 就诊类型（O门诊、E急诊、EP急诊留观、I住院）
	Set $list(Data,4)  = VisitStatus    // 就诊状态（预住院P、在院A、出院D、退院C、作废U）
	Set $list(Data,5)  = AdmNo          // 住院号
	Set $list(Data,6)  = PapmiNo        // 登记号
	Set $list(Data,7)  = MrNo           // 病案号
	Set $list(Data,8)  = PatName        // 姓名
	Set $list(Data,9)  = Sex            // 性别（M男、F女、O其他）
	Set $list(Data,10) = Nation         // 民族
	Set $list(Data,11) = Birthday       // 出生日期
	Set $list(Data,12) = Age            // 年龄
	Set $list(Data,13) = IdentityCode   // 身份证号码
	Set $list(Data,14) = HomeAddress    // 现住址
	Set $list(Data,15) = Company        // 工作单位
	Set $list(Data,16) = RelativeName   // 联系人
	Set $list(Data,17) = RelativeTel    // 联系人电话
	Set $list(Data,18) = IsDeath        // 死亡标志
	Set $list(Data,19) = DeathDate      // 死亡日期
	Set $list(Data,20) = DeathTime      // 死亡时间
	Set $list(Data,21) = AdmTimes       // 住院次数
	Set $list(Data,22) = AdmDate        // 入院日期
	Set $list(Data,23) = AdmTime        // 入院时间
	Set $list(Data,24) = AdmLocID       // 就诊科室
	Set $list(Data,25) = AdmWardID      // 就诊病区
	Set $list(Data,26) = AdmRoom        // 就诊房间
	Set $list(Data,27) = AdmBed         // 就诊床位
	Set $list(Data,28) = AdmDocID       // 主管医生
	Set $list(Data,29) = DischDate      // 出院日期
	Set $list(Data,30) = DischTime      // 出院时间
	Set $list(Data,31) = AdmDays        // 住院天数（住院病人未出院值为-1）
	Set $list(Data,32) = IsNewBaby      // 新生儿标志
	Set $list(Data,33) = BirthWeight    // 新生儿出生体重（g）
	Set $list(Data,34) = AdmitWeight    // 新生儿入院体重（g）
	Set $list(Data,35) = MotherDr       // 母亲就诊指针
	Set $list(Data,36) = AdmLocDesc     // 就诊科室
	Set $list(Data,37) = AdmWardDesc    // 就诊病区
	Set $list(Data,38) = AdmDocName     // 主管医生
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod GetEpisInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEpisInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetEpisInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEpisInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
