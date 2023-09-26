/// 名称: DHCMA.Util.EPy.EpisodeSrv
/// 描述: HIS接口服务 就诊信息
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.Util.EPy.EpisodeSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:	  zhufei
/// CreatDate：   2019-01-17
/// Description:  根据EpisodeID同步就诊信息
/// Table：       DHCMA.Util.EP.Episode
/// Input：		  aOID : DHCMA.Util.EP.Episode.OID
/// Return：      异常：空、正常：处理数据条数
/// w ##Class(DHCMA.Util.EPy.EpisodeSrv).SetEpisInfo("842897!!1")
ClassMethod SetEpisInfo(aOID As %String = "") As %String
{
	New (aOID)
	Set return=0
	Quit:(aOID="") return
	
	Set objSYS=##class(DHCMA.Util.EPS.OIDService).GetSYSDr(aOID)
	Quit:'$IsObject(objSYS) return
	Set SYSDr=objSYS.%Id()
	Set SYSExCode=objSYS.SYSExCode
	Quit:SYSExCode'="localhost" return
	Set SYSOID=##class(DHCMA.Util.EPS.OIDService).GetSYSOID(aOID)
	Quit:SYSOID="" return
	
	Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncAdmSrv:GetEpisInfo")
  	Set sc=rs.Execute(SYSOID)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
    While (rs.Next()){
		Set OID           = rs.Data("EpisodeID")    // 就诊ID
		Set PatientID     = rs.Data("PatientID")    // 病人ID
		Set AdmType       = rs.Data("AdmType")      // 就诊类型（O门诊、E急诊、EP急诊留观、I住院）
		Set VisitStatus   = rs.Data("VisitStatus")  // 就诊状态（预住院P、在院A、出院D、退院C、作废U）
		Set AdmNo         = rs.Data("AdmNo")        // 住院号
		Set PapmiNo       = rs.Data("PapmiNo")      // 登记号
		Set MrNo          = rs.Data("MrNo")         // 病案号
		Set PatName       = rs.Data("PatName")      // 姓名
		Set Sex           = rs.Data("Sex")          // 性别（M男、F女、O其他）
		Set Nation        = rs.Data("Nation")       // 民族
		Set Birthday      = rs.Data("Birthday")     // 出生日期
		Set Age           = rs.Data("Age")          // 年龄
		Set IdentityCode  = rs.Data("IdentityCode") // 身份证号码
		Set HomeAddress   = rs.Data("HomeAddress")  // 现住址
		Set Company       = rs.Data("Company")      // 工作单位
		Set RelativeName  = rs.Data("RelativeName") // 联系人
		Set RelativeTel   = rs.Data("RelativeTel")  // 联系人电话
		Set IsDeath       = rs.Data("IsDeath")      // 死亡标志
		Set DeathDate     = rs.Data("DeathDate")    // 死亡日期
		Set DeathTime     = rs.Data("DeathTime")    // 死亡时间
		Set AdmTimes      = rs.Data("AdmTimes")     // 住院次数
		Set AdmDate       = rs.Data("AdmDate")      // 入院日期
		Set AdmTime       = rs.Data("AdmTime")      // 入院时间
		Set AdmLocID      = rs.Data("AdmLocID")     // 就诊科室
		Set AdmWardID     = rs.Data("AdmWardID")    // 就诊病区
		Set AdmRoom       = rs.Data("AdmRoom")      // 就诊房间
		Set AdmBed        = rs.Data("AdmBed")       // 就诊床位
		Set AdmDocID      = rs.Data("AdmDocID")     // 主管医生
		Set DischDate     = rs.Data("DischDate")    // 出院日期
		Set DischTime     = rs.Data("DischTime")    // 出院时间
		Set AdmDays       = rs.Data("AdmDays")      // 住院天数（住院病人未出院值为-1）
		Set IsNewBaby     = rs.Data("IsNewBaby")    // 新生儿标志
		Set BirthWeight   = rs.Data("BirthWeight")  // 新生儿出生体重（g）
		Set AdmitWeight   = rs.Data("AdmitWeight")  // 新生儿入院体重（g）
		Set MotherDr      = rs.Data("MotherDr")     // 母亲就诊指针
		Set LocDesc       = rs.Data("LocDesc")      // 就诊科室
		Set WardDesc      = rs.Data("WardDesc")     // 就诊病区
		Set DocName       = rs.Data("DocName")      // 主管医生
	    Set:OID'="" OID=OID_"!!"_SYSDr
	    Set:AdmLocID'="" AdmLocID=AdmLocID_"!!"_SYSDr
	    Set:AdmWardID'="" AdmWardID=AdmWardID_"!!"_SYSDr
	    Set:AdmDocID'="" AdmDocID=AdmDocID_"!!"_SYSDr
	    Set:MotherDr'="" MotherDr=MotherDr_"!!"_SYSDr
		Continue:(OID="")||(AdmType="")||(VisitStatus="")||(PatName="")
		
		Set ID=""
		Set objTmp=##class(DHCMA.Util.EP.Episode).xGetByOID(OID)
		If $IsObject(objTmp){
			Set ID=objTmp.%Id()
		}
		
		Set InputStr=""
		Set $p(InputStr,"^",1)  = ID                     // ID
		Set $p(InputStr,"^",2)  = OID                    // 就诊ID
		Set $p(InputStr,"^",3)  = PatientID              // 病人ID
		Set $p(InputStr,"^",4)  = AdmType                // 就诊类型（O门诊、E急诊、EP急诊留观、I住院）
		Set $p(InputStr,"^",5)  = VisitStatus            // 就诊状态（预住院P、在院A、出院D、退院C、作废U）
		Set $p(InputStr,"^",6)  = AdmNo                  // 住院号
		Set $p(InputStr,"^",7)  = PapmiNo                // 登记号
		Set $p(InputStr,"^",8)  = MrNo                   // 病案号
		Set $p(InputStr,"^",9)  = PatName                // 姓名
		Set $p(InputStr,"^",10) = Sex                    // 性别（M男、F女、O其他）
		Set $p(InputStr,"^",11) = Nation                 // 民族
		Set $p(InputStr,"^",12) = Birthday               // 出生日期
		Set $p(InputStr,"^",13) = Age                    // 年龄
		Set $p(InputStr,"^",14) = IdentityCode           // 身份证号码
		Set $p(InputStr,"^",15) = HomeAddress            // 现住址
		Set $p(InputStr,"^",16) = Company                // 工作单位
		Set $p(InputStr,"^",17) = RelativeName           // 联系人
		Set $p(InputStr,"^",18) = RelativeTel            // 联系人电话
		Set $p(InputStr,"^",19) = IsDeath                // 死亡标志
		Set $p(InputStr,"^",20) = DeathDate              // 死亡日期
		Set $p(InputStr,"^",21) = DeathTime              // 死亡时间
		Set $p(InputStr,"^",22) = AdmTimes               // 住院次数
		Set $p(InputStr,"^",23) = AdmDate                // 入院日期
		Set $p(InputStr,"^",24) = AdmTime                // 入院时间
		Set $p(InputStr,"^",25) = AdmLocID    			// 就诊科室
		Set $p(InputStr,"^",26) = AdmWardID   			// 就诊病区
		Set $p(InputStr,"^",27) = AdmRoom                // 就诊房间
		Set $p(InputStr,"^",28) = AdmBed                 // 就诊床位
		Set $p(InputStr,"^",29) = AdmDocID    			// 主管医生
		Set $p(InputStr,"^",30) = DischDate              // 出院日期
		Set $p(InputStr,"^",31) = DischTime              // 出院时间
		Set $p(InputStr,"^",32) = AdmDays                // 住院天数（住院病人未出院值为-1）
		Set $p(InputStr,"^",33) = IsNewBaby              // 新生儿标志
		Set $p(InputStr,"^",34) = BirthWeight            // 新生儿出生体重（g）
		Set $p(InputStr,"^",35) = AdmitWeight            // 新生儿入院体重（g）
		Set $p(InputStr,"^",36) = MotherDr    				// 母亲就诊指针
		Set $p(InputStr,"^",37) = LocDesc    			// 就诊科室
		Set $p(InputStr,"^",38) = WardDesc    			// 就诊病区
		Set $p(InputStr,"^",39) = DocName    			// 主管医生
		Set return=##class(DHCMA.Util.EPx.Episode).Update(InputStr,"^")
		Quit
	}
	Quit return
}

/// 通过判断是否存在同步就诊记录，选择是否同步后返回就诊记录对象,按配置转换日期格式
/// w ##class(DHCMA.Util.EPy.EpisodeSrv).GetSynObjByOID("921238!!1")
ClassMethod GetSynObjByOID(OID As %String) As DHCMA.Util.EPx.Episode
{
	New (OID)
	if ('$d(^DHCMA.Util.EPx.EpisodeI("IdxOfOID"," "_OID))){
		Set ret=..SetEpisInfo(OID)  //未同步数据，需要同步
		Quit:ret<1 ""
		}
	Set aId=$o(^DHCMA.Util.EPx.EpisodeI("IdxOfOID"," "_OID,""),-1)
	Set obj=##Class(DHCMA.Util.EPx.Episode).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Set:obj.PAAdmDate'="" obj.PAAdmDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(obj.PAAdmDate)
	Set:obj.PAAdmTime'="" obj.PAAdmTime=$zt(obj.PAAdmTime)
	Set:obj.PABirthday'="" obj.PABirthday=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(obj.PABirthday)
	Set:obj.PADeathDate'="" obj.PADeathDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(obj.PADeathDate)
	Set:obj.PADeathTime'="" obj.PADeathTime=$zt(obj.PADeathTime)
	Set:obj.PADischDate'="" obj.PADischDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(obj.PADischDate)
	Set:obj.PADischTime'="" obj.PADischTime=$zt(obj.PADischTime)
	Set obj.PAAdmDateT=obj.PAAdmDate_" "_obj.PAAdmTime
	Set obj.PADischDateT=obj.PADischDate_" "_obj.PADischTime
	Quit obj
}

/// 通过判断是否存在同步就诊记录，同步后返回就诊记录对象,返回原始值
/// w ##class(DHCMA.Util.EPy.EpisodeSrv).GetLogicSynObjByOID("921238!!1")
ClassMethod GetLogicSynObjByOID(OID As %String) As DHCMA.Util.EPx.Episode
{
	New (OID)
	if ('$d(^DHCMA.Util.EPx.EpisodeI("IdxOfOID"," "_OID))){
		Set ret=..SetEpisInfo(OID)  //未同步数据，需要同步
		Quit:ret<1 ""
		}
	Set aId=$o(^DHCMA.Util.EPx.EpisodeI("IdxOfOID"," "_OID,""),-1)
	Set obj=##Class(DHCMA.Util.EPx.Episode).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

}
