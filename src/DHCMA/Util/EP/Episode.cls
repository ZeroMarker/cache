/// 就诊表
Class DHCMA.Util.EP.Episode Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 就诊ID
Property OID As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 病人ID
Property PAPatientID As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 就诊类型（O门诊、E急诊、I住院）
Property PAAdmType As %String(DISPLAYLIST = ",O,E,I,H", VALUELIST = ",O,E,I,H") [ Required ];

/// 就诊状态（预住院P、在院A、出院D、退院C、作废U）
Property PAVisitStatus As %String(DISPLAYLIST = ",A,D,C,U,P", VALUELIST = ",A,D,C,U,P") [ Required ];

/// 住院号
Property PAAdmNo As %String(MAXLEN = 50, TRUNCATE = 1);

/// 登记号
Property PAPapmiNo As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 病案号
Property PAMrNo As %String(MAXLEN = 50, TRUNCATE = 1);

/// 姓名
Property PAPatName As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 性别（M男、F女、O其他）
Property PASex As %String(DISPLAYLIST = ",M,F,O", VALUELIST = ",M,F,O");

/// 民族
Property PANation As %String(MAXLEN = 50, TRUNCATE = 1);

/// 出生日期
Property PABirthday As %Date;

/// 年龄
Property PAAge As %String(MAXLEN = 50, TRUNCATE = 1);

/// 身份证号码
Property PAIdentityCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 现住址
Property PAHomeAddress As %String(MAXLEN = 200, TRUNCATE = 1);

/// 工作单位
Property PACompany As %String(MAXLEN = 100, TRUNCATE = 1);

/// 联系人
Property PARelativeName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 联系人电话
Property PARelativeTel As %String(MAXLEN = 100, TRUNCATE = 1);

/// 死亡标志
Property PAIsDeath As %Boolean [ Required ];

/// 死亡日期
Property PADeathDate As %Date;

/// 死亡时间
Property PADeathTime As %Time;

/// 住院次数
Property PAAdmTimes As %Integer;

/// 入院日期
Property PAAdmDate As %Date [ Required ];

/// 入院时间
Property PAAdmTime As %Time [ Required ];

/// 入院日期时间
Property PAAdmDateT As %String;

/// 就诊科室
Property PAAdmLocID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 就诊科室Desc
Property PAAdmLocDesc As %String(MAXLEN = 50, TRUNCATE = 1);

/// 就诊病区
Property PAAdmWardID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 就诊病区Desc
Property PAAdmWardDesc As %String(MAXLEN = 50, TRUNCATE = 1);

/// 就诊房间
Property PAAdmRoom As %String(MAXLEN = 100, TRUNCATE = 1);

/// 就诊床位
Property PAAdmBed As %String(MAXLEN = 100, TRUNCATE = 1);

/// 主管医生
Property PAAdmDocID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 主管医生姓名
Property PAAdmDocName As %String(MAXLEN = 50, TRUNCATE = 1);

/// 出院日期
Property PADischDate As %Date;

/// 出院时间
Property PADischTime As %Time;

/// 出院日期时间
Property PADischDateT As %String;

/// 住院天数（住院病人未出院值为-1）
Property PAAdmDays As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 新生儿标志
Property PAIsNewBaby As %Boolean [ Required ];

/// 新生儿出生体重（g）
Property PABirthWeight As %String(MAXLEN = 50, TRUNCATE = 1);

/// 新生儿入院体重（g）
Property PAAdmitWeight As %String(MAXLEN = 50, TRUNCATE = 1);

/// 母亲就诊指针
Property PAMotherDr As %String(MAXLEN = 50, TRUNCATE = 1);

/// 更新日期
Property PAUpdateDate As %Date [ Required ];

/// 更新时间
Property PAUpdateTime As %Time [ Required ];

/// 取就诊信息
/// w ##class(DHCMA.Util.EP.Episode).GetObjByOID("7!!1")
ClassMethod GetObjByOID(aOID As %String) As DHCMA.Util.EP.Episode
{
	New (aOID)
	Set return=""
	Quit:(aOID="") return
	
	//OID有效性检查，缺系统指针自动补齐
	Set aOID=##class(DHCMA.Util.EPS.OIDService).GetValidOID(aOID)
	
	Set objTmp=..xGetByOID(aOID)
	If '$IsObject(objTmp){
		Set flg=..xSetByOID(aOID)
		Quit:(+flg)<1 return
		Set objTmp=..xGetByOID(aOID)
	}
	Quit:'$IsObject(objTmp) return
	
	Set obj=##class(DHCMA.Util.EP.Episode).%New()
	Set obj.OID            = objTmp.OID              // 就诊ID
	Set obj.PAPatientID    = objTmp.PAPatientID      // 病人ID
	Set obj.PAAdmType      = objTmp.PAAdmType        // 就诊类型（O门诊、E急诊、EP急诊留观、I住院）
	Set obj.PAVisitStatus  = objTmp.PAVisitStatus    // 就诊状态（预住院P、在院A、出院D、退院C、作废U）
	Set obj.PAAdmNo        = objTmp.PAAdmNo          // 住院号
	Set obj.PAPapmiNo      = objTmp.PAPapmiNo        // 登记号
	Set obj.PAMrNo         = objTmp.PAMrNo           // 病案号
	Set obj.PAPatName      = objTmp.PAPatName        // 姓名
	Set obj.PASex          = objTmp.PASex            // 性别（M男、F女、O其他）
	Set obj.PANation       = objTmp.PANation         // 民族
	Set obj.PABirthday     = objTmp.PABirthday       // 出生日期
	Set obj.PAAge          = objTmp.PAAge            // 年龄
	Set obj.PAIdentityCode = objTmp.PAIdentityCode   // 身份证号码
	Set obj.PAHomeAddress  = objTmp.PAHomeAddress    // 现住址
	Set obj.PACompany      = objTmp.PACompany        // 工作单位
	Set obj.PARelativeName = objTmp.PARelativeName   // 联系人
	Set obj.PARelativeTel  = objTmp.PARelativeTel    // 联系人电话
	Set obj.PAIsDeath      = objTmp.PAIsDeath        // 死亡标志
	Set obj.PADeathDate    = objTmp.PADeathDate      // 死亡日期
	Set obj.PADeathTime    = objTmp.PADeathTime      // 死亡时间
	Set obj.PAAdmTimes     = objTmp.PAAdmTimes       // 住院次数
	Set obj.PAAdmDate      = objTmp.PAAdmDate        // 入院日期
	Set obj.PAAdmTime      = objTmp.PAAdmTime        // 入院时间
	Set obj.PAAdmLocID     = objTmp.PAAdmLocID       // 就诊科室
	Set obj.PAAdmWardID    = objTmp.PAAdmWardID      // 就诊病区
	Set obj.PAAdmRoom      = objTmp.PAAdmRoom        // 就诊房间
	Set obj.PAAdmBed       = objTmp.PAAdmBed         // 就诊床位
	Set obj.PAAdmDocID     = objTmp.PAAdmDocID       // 主管医生
	Set obj.PADischDate    = objTmp.PADischDate      // 出院日期
	Set obj.PADischTime    = objTmp.PADischTime      // 出院时间
	Set obj.PAAdmDays      = objTmp.PAAdmDays        // 住院天数（住院病人未出院值为-1）
	Set obj.PAIsNewBaby    = objTmp.PAIsNewBaby      // 新生儿标志
	Set obj.PABirthWeight  = objTmp.PABirthWeight    // 新生儿出生体重（g）
	Set obj.PAAdmitWeight  = objTmp.PAAdmitWeight    // 新生儿入院体重（g）
	Set obj.PAMotherDr     = objTmp.PAMotherDr       // 母亲就诊指针
	Set obj.PAUpdateDate   = objTmp.PAUpdateDate     // 更新日期
	Set obj.PAUpdateTime   = objTmp.PAUpdateTime     // 更新时间
	If obj'="" Do obj.%Close()
	Quit obj
}

/// 取就诊信息
/// w ##class(DHCMA.Util.EP.Episode).xGetByOID("2!!1")
ClassMethod xGetByOID(aOID As %String) As DHCMA.Util.EPx.Episode
{
	New (aOID)
	Set return=""
	Quit:(aOID="") return
	
	Set ID=$o(^DHCMA.Util.EPx.EpisodeI("IdxOfOID"," "_$zcvt(aOID,"U"),0))
	Quit:ID="" return
	Set return=##class(DHCMA.Util.EPx.Episode).GetObjById(ID)
	Quit return
}

/// 保存就诊信息
/// w ##class(DHCMA.Util.EP.Episode).xSetByOID("2!!1")
ClassMethod xSetByOID(aOID As %String) As %String
{
	New (aOID)
	Set return=##Class(DHCMA.Util.EPy.EpisodeSrv).SetEpisInfo(aOID)
	Quit return
}

Storage Default
{
<Data name="EpisodeState">
<Value name="1">
<Value>OID</Value>
</Value>
<Value name="2">
<Value>PAPatientID</Value>
</Value>
<Value name="3">
<Value>PAAdmType</Value>
</Value>
<Value name="4">
<Value>PAVisitStatus</Value>
</Value>
<Value name="5">
<Value>PAAdmNo</Value>
</Value>
<Value name="6">
<Value>PAPapmiNo</Value>
</Value>
<Value name="7">
<Value>PAMrNo</Value>
</Value>
<Value name="8">
<Value>PAPatName</Value>
</Value>
<Value name="9">
<Value>PASex</Value>
</Value>
<Value name="10">
<Value>PANation</Value>
</Value>
<Value name="11">
<Value>PABirthday</Value>
</Value>
<Value name="12">
<Value>PAAge</Value>
</Value>
<Value name="13">
<Value>PAIdentityCode</Value>
</Value>
<Value name="14">
<Value>PAHomeAddress</Value>
</Value>
<Value name="15">
<Value>PACompany</Value>
</Value>
<Value name="16">
<Value>PARelativeName</Value>
</Value>
<Value name="17">
<Value>PARelativeTel</Value>
</Value>
<Value name="18">
<Value>PAIsDeath</Value>
</Value>
<Value name="19">
<Value>PADeathDate</Value>
</Value>
<Value name="20">
<Value>PADeathTime</Value>
</Value>
<Value name="21">
<Value>PAAdmTimes</Value>
</Value>
<Value name="22">
<Value>PAAdmDate</Value>
</Value>
<Value name="23">
<Value>PAAdmTime</Value>
</Value>
<Value name="24">
<Value>PAAdmLocID</Value>
</Value>
<Value name="25">
<Value>PAAdmWardID</Value>
</Value>
<Value name="26">
<Value>PAAdmRoom</Value>
</Value>
<Value name="27">
<Value>PAAdmBed</Value>
</Value>
<Value name="28">
<Value>PAAdmDocID</Value>
</Value>
<Value name="29">
<Value>PADischDate</Value>
</Value>
<Value name="30">
<Value>PADischTime</Value>
</Value>
<Value name="31">
<Value>PAAdmDays</Value>
</Value>
<Value name="32">
<Value>PAIsNewBaby</Value>
</Value>
<Value name="33">
<Value>PABirthWeight</Value>
</Value>
<Value name="34">
<Value>PAAdmitWeight</Value>
</Value>
<Value name="35">
<Value>PAMotherDr</Value>
</Value>
<Value name="36">
<Value>PAUpdateDate</Value>
</Value>
<Value name="37">
<Value>PAUpdateTime</Value>
</Value>
<Value name="38">
<Value>PAAdmLocDesc</Value>
</Value>
<Value name="39">
<Value>PAAdmWardDesc</Value>
</Value>
<Value name="40">
<Value>PAAdmDocName</Value>
</Value>
<Value name="41">
<Value>PAAdmDateT</Value>
</Value>
<Value name="42">
<Value>PADischDateT</Value>
</Value>
</Data>
<State>EpisodeState</State>
<StreamLocation>^DHCMA.Util.EP.EpisodeS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
