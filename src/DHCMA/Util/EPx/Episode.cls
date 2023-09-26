/// 就诊表
Class DHCMA.Util.EPx.Episode Extends (%Persistent, User.Abstract, DHCMA.Util.EP.Episode) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 系统指针
Property SYSDr As DHCMA.Util.BT.SYSTEM [ Required ];

/// 字典指针
Property SYSOID As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 记录码 索引
Index IdxOfOID On OID [ Unique ];

/// 住院患者 索引
Index IdxOfIPAdmit On (SYSDr, PAAdmDays, PAAdmDate);

/// 入院日期 索引
Index IdxOfAdmDate On (SYSDr, PAAdmDate);

/// 出院日期 索引
Index IdxOfDischDate On (SYSDr, PADischDate);

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  根据ID取医护人员信息
/// Table：       DHCMA.Util.EPx.Episode
/// Input：       aId : DHCMA.Util.EPx.Episode.ID
/// Return：      返回obj
/// w ##class(DHCMA.Util.EPx.Episode).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.Util.EPx.Episode
{
	New (aId)
	Quit:'##class(DHCMA.Util.EPx.Episode).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.Util.EPx.Episode).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     yankai
/// CreatDate：   2022-12-09
/// Description:  根据OID【实时】获取患者就诊信息
/// Table：       DHCMA.Util.EPx.Episode
/// Input：       aId : DHCMA.Util.EPx.Episode.ID
/// Return：      返回obj
/// w ##class(DHCMA.Util.EPx.Episode).GetXObjByOID("364!!1")
ClassMethod GetXObjByOID(aOID) As DHCMA.Util.EPx.Episode
{
	New (aOID)
	Set return=""
	Quit:aOID="" return
	
	Set flg=..xSetByOID(aOID)			// 先更新就诊基本信息
	Quit:(+flg)<1 return
	
	Set ID=$o(^DHCMA.Util.EPx.EpisodeI("IdxOfOID"," "_$zcvt(aOID,"U"),0))
	Quit:ID="" return
	Set obj=##Class(DHCMA.Util.EPx.Episode).%OpenId(ID)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  更新医护人员信息
/// Table：       DHCMA.Util.EPx.Episode
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.Util.EPx.Episode).Update("","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:aSeparete="" aSeparete="^"
	Set ID            = $p(aInputStr,aSeparete,1)
	Set OID           = $p(aInputStr,aSeparete,2)  // 就诊ID
	Set PatientID     = $p(aInputStr,aSeparete,3)  // 病人ID
	Set AdmType       = $p(aInputStr,aSeparete,4)  // 就诊类型（O门诊、E急诊、EP急诊留观、I住院）
	Set VisitStatus   = $p(aInputStr,aSeparete,5)  // 就诊状态（预住院P、在院A、出院D、退院C、作废U）
	Set AdmNo         = $p(aInputStr,aSeparete,6)  // 住院号
	Set PapmiNo       = $p(aInputStr,aSeparete,7)  // 登记号
	Set MrNo          = $p(aInputStr,aSeparete,8)  // 病案号
	Set PatName       = $p(aInputStr,aSeparete,9)  // 姓名
	Set Sex           = $p(aInputStr,aSeparete,10) // 性别（M男、F女、O其他）
	Set Nation        = $p(aInputStr,aSeparete,11) // 民族
	Set Birthday      = $p(aInputStr,aSeparete,12) // 出生日期
	Set Age           = $p(aInputStr,aSeparete,13) // 年龄
	Set IdentityCode  = $p(aInputStr,aSeparete,14) // 身份证号码
	Set HomeAddress   = $p(aInputStr,aSeparete,15) // 现住址
	Set Company       = $p(aInputStr,aSeparete,16) // 工作单位
	Set RelativeName  = $p(aInputStr,aSeparete,17) // 联系人
	Set RelativeTel   = $p(aInputStr,aSeparete,18) // 联系人电话
	Set IsDeath       = $p(aInputStr,aSeparete,19) // 死亡标志
	Set DeathDate     = $p(aInputStr,aSeparete,20) // 死亡日期
	Set DeathTime     = $p(aInputStr,aSeparete,21) // 死亡时间
	Set AdmTimes      = $p(aInputStr,aSeparete,22) // 住院次数
	Set AdmDate       = $p(aInputStr,aSeparete,23) // 入院日期
	Set AdmTime       = $p(aInputStr,aSeparete,24) // 入院时间
	Set AdmLocID      = $p(aInputStr,aSeparete,25) // 就诊科室
	Set AdmWardID     = $p(aInputStr,aSeparete,26) // 就诊病区
	Set AdmRoom       = $p(aInputStr,aSeparete,27) // 就诊房间
	Set AdmBed        = $p(aInputStr,aSeparete,28) // 就诊床位
	Set AdmDocID      = $p(aInputStr,aSeparete,29) // 主管医生
	Set DischDate     = $p(aInputStr,aSeparete,30) // 出院日期
	Set DischTime     = $p(aInputStr,aSeparete,31) // 出院时间
	Set AdmDays       = $p(aInputStr,aSeparete,32) // 住院天数（住院病人未出院值为-1）
	Set IsNewBaby     = $p(aInputStr,aSeparete,33) // 新生儿标志
	Set BirthWeight   = $p(aInputStr,aSeparete,34) // 新生儿出生体重（g）
	Set AdmitWeight   = $p(aInputStr,aSeparete,35) // 新生儿入院体重（g）
	Set MotherDr   = $p(aInputStr,aSeparete,36) // 母亲就诊ID
	Set LocDesc   		= $p(aInputStr,aSeparete,37) 	// 就诊科室Desc
	Set WardDesc   		= $p(aInputStr,aSeparete,38) 	// 就诊病区Desc
	Set DocName   		= $p(aInputStr,aSeparete,39) 	// 住院医生
	Quit:(OID="")||(AdmType="")||(VisitStatus="")||(PatName="") return
	
	Set objSYS=##class(DHCMA.Util.EPS.OIDService).GetSYSDr(OID)
	Set SYSOID=##class(DHCMA.Util.EPS.OIDService).GetSYSOID(OID)
	Quit:(objSYS="")||(SYSOID="") return
	
	Set tID=$o(^DHCMA.Util.EPx.EpisodeI("IdxOfOID"," "_$zcvt(OID,"U"),0))
	Set:ID="" ID=tID
	Quit:(tID'="")&(ID'=tID) -2
	
	If ID="" {
		Set obj=##class(DHCMA.Util.EPx.Episode).%New()
	}Else{
		Set obj=##class(DHCMA.Util.EPx.Episode).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.OID            = OID            // 就诊ID
	Set obj.PAPatientID    = PatientID      // 病人ID
	Set obj.PAAdmType      = AdmType        // 就诊类型（O门诊、E急诊、EP急诊留观、I住院）
	Set obj.PAVisitStatus  = VisitStatus    // 就诊状态（预住院P、在院A、出院D、退院C、作废U）
	Set obj.PAAdmNo        = AdmNo          // 住院号
	Set obj.PAPapmiNo      = PapmiNo        // 登记号
	Set obj.PAMrNo         = MrNo           // 病案号
	Set obj.PAPatName      = PatName        // 姓名
	Set obj.PASex          = Sex            // 性别（M男、F女、O其他）
	Set obj.PANation       = Nation         // 民族
	Set obj.PABirthday     = Birthday       // 出生日期
	Set obj.PAAge          = Age            // 年龄
	Set obj.PAIdentityCode = IdentityCode   // 身份证号码
	Set obj.PAHomeAddress  = HomeAddress    // 现住址
	Set obj.PACompany      = Company        // 工作单位
	Set obj.PARelativeName = RelativeName   // 联系人
	Set obj.PARelativeTel  = RelativeTel    // 联系人电话
	Set obj.PAIsDeath      = IsDeath        // 死亡标志
	Set obj.PADeathDate    = DeathDate      // 死亡日期
	Set obj.PADeathTime    = DeathTime      // 死亡时间
	Set obj.PAAdmTimes     = AdmTimes       // 住院次数
	Set obj.PAAdmDate      = AdmDate        // 入院日期
	Set obj.PAAdmTime      = AdmTime        // 入院时间
	Set obj.PAAdmLocID     = AdmLocID       // 就诊科室
	Set obj.PAAdmWardID    = AdmWardID      // 就诊病区
	Set obj.PAAdmRoom      = AdmRoom        // 就诊房间
	Set obj.PAAdmBed       = AdmBed         // 就诊床位
	Set obj.PAAdmDocID     = AdmDocID       // 主管医生
	Set obj.PADischDate    = DischDate      // 出院日期
	Set obj.PADischTime    = DischTime      // 出院时间
	Set obj.PAAdmDays      = AdmDays        // 住院天数（住院病人未出院值为-1）
	Set obj.PAIsNewBaby    = IsNewBaby      // 新生儿标志
	Set obj.PABirthWeight  = BirthWeight    // 新生儿出生体重（g）
	Set obj.PAAdmitWeight  = AdmitWeight    // 新生儿入院体重（g）
	Set obj.PAMotherDr  = MotherDr    // 母亲就诊ID
	Set obj.PAAdmLocDesc  	= LocDesc    	// 就诊科室Desc
	Set obj.PAAdmWardDesc  	= WardDesc    	// 就诊病区Desc
	Set obj.PAAdmDocName  	= DocName    	// 医生姓名
	Set obj.PAUpdateDate   = +$h
	Set obj.PAUpdateTime   = $p($h,",",2)
	Set obj.SYSDr          = objSYS
	Set obj.SYSOID         = SYSOID
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  删除医护人员信息
/// Table：       DHCMA.Util.EPx.Episode
/// Input：       aId : DHCMA.Util.EPx.Episode.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.Util.EPx.Episode).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.Util.EPx.Episode).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

Storage Default
{
<Data name="EpisodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OID</Value>
</Value>
<Value name="3">
<Value>PAPatientID</Value>
</Value>
<Value name="4">
<Value>PAAdmType</Value>
</Value>
<Value name="5">
<Value>PAVisitStatus</Value>
</Value>
<Value name="6">
<Value>PAAdmNo</Value>
</Value>
<Value name="7">
<Value>PAPapmiNo</Value>
</Value>
<Value name="8">
<Value>PAMrNo</Value>
</Value>
<Value name="9">
<Value>PAPatName</Value>
</Value>
<Value name="10">
<Value>PASex</Value>
</Value>
<Value name="11">
<Value>PANation</Value>
</Value>
<Value name="12">
<Value>PABirthday</Value>
</Value>
<Value name="13">
<Value>PAAge</Value>
</Value>
<Value name="14">
<Value>PAIdentityCode</Value>
</Value>
<Value name="15">
<Value>PAHomeAddress</Value>
</Value>
<Value name="16">
<Value>PACompany</Value>
</Value>
<Value name="17">
<Value>PARelativeName</Value>
</Value>
<Value name="18">
<Value>PARelativeTel</Value>
</Value>
<Value name="19">
<Value>PAIsDeath</Value>
</Value>
<Value name="20">
<Value>PADeathDate</Value>
</Value>
<Value name="21">
<Value>PADeathTime</Value>
</Value>
<Value name="22">
<Value>PAAdmTimes</Value>
</Value>
<Value name="23">
<Value>PAAdmDate</Value>
</Value>
<Value name="24">
<Value>PAAdmTime</Value>
</Value>
<Value name="25">
<Value>PAAdmLocID</Value>
</Value>
<Value name="26">
<Value>PAAdmWardID</Value>
</Value>
<Value name="27">
<Value>PAAdmRoom</Value>
</Value>
<Value name="28">
<Value>PAAdmBed</Value>
</Value>
<Value name="29">
<Value>PAAdmDocID</Value>
</Value>
<Value name="30">
<Value>PADischDate</Value>
</Value>
<Value name="31">
<Value>PADischTime</Value>
</Value>
<Value name="32">
<Value>PAAdmDays</Value>
</Value>
<Value name="33">
<Value>PAIsNewBaby</Value>
</Value>
<Value name="34">
<Value>PABirthWeight</Value>
</Value>
<Value name="35">
<Value>PAAdmitWeight</Value>
</Value>
<Value name="36">
<Value>PAMotherDr</Value>
</Value>
<Value name="37">
<Value>PAUpdateDate</Value>
</Value>
<Value name="38">
<Value>PAUpdateTime</Value>
</Value>
<Value name="39">
<Value>SYSDr</Value>
</Value>
<Value name="40">
<Value>SYSOID</Value>
</Value>
<Value name="41">
<Value>PAAdmLocDesc</Value>
</Value>
<Value name="42">
<Value>PAAdmWardDesc</Value>
</Value>
<Value name="43">
<Value>PAAdmDocName</Value>
</Value>
<Value name="44">
<Value>PAAdmDateT</Value>
</Value>
<Value name="45">
<Value>PADischDateT</Value>
</Value>
</Data>
<DataLocation>^DHCMA.Util.EPx.EpisodeD</DataLocation>
<DefaultData>EpisodeDefaultData</DefaultData>
<IdLocation>^DHCMA.Util.EPx.EpisodeD</IdLocation>
<IndexLocation>^DHCMA.Util.EPx.EpisodeI</IndexLocation>
<StreamLocation>^DHCMA.Util.EPx.EpisodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
