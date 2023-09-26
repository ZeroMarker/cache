/// 名称: DHCHAI.DP.PAAdm
/// 描述: 就诊表
/// 编写者：liyi
/// 编写日期: 2017-01-12
Class DHCHAI.DP.PAAdm Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊序号
Property PAEpisodeIDx As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 病人主索引
Property PAPatientIDx As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 登记号
Property PAPapmiNo As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 病案号
Property PAMrNo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 姓名
Property PAPatName As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 性别（M男、F女、O其他）
Property PASex As %String(DISPLAYLIST = ",M,F,O", VALUELIST = ",M,F,O") [ Required ];

/// 民族
Property PANation As %String(MAXLEN = 100, TRUNCATE = 1);

/// 出生日期
Property PABirthday As %Date;

/// 年龄
Property PAAge As %String(MAXLEN = 100, TRUNCATE = 1);

/// 身份证号码
Property PAIdentityCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 现住址
Property PAHomeAddress As %String(MAXLEN = 100, TRUNCATE = 1);

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

/// 就诊类型（O门诊、E急诊、EP急诊留观、I住院）
Property PAAdmType As %String(DISPLAYLIST = ",O,E,EP,I", VALUELIST = ",O,E,EP,I") [ Required ];

/// 就诊状态（预住院P、在院A、出院D、退院C、作废U）
Property PAVisitStatus As %String(DISPLAYLIST = ",A,D,C,U,P", VALUELIST = ",A,D,C,U,P") [ Required ];

/// 住院次数
Property PAAdmTimes As %Integer;

/// 入院日期
Property PAAdmDate As %Date [ Required ];

/// 入院时间
Property PAAdmTime As %Time [ Required ];

/// 就诊科室
Property PAAdmLocDr As DHCHAI.BT.Location;

/// 就诊病区
Property PAAdmWardDr As DHCHAI.BT.Location;

/// 就诊房间
Property PAAdmRoom As %String(MAXLEN = 100, TRUNCATE = 1);

/// 就诊床位
Property PAAdmBedDr As DHCHAI.BT.PACBed;

/// 主管医生（ID|Code|Desc）
Property PAAdmDoc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 出院日期
Property PADischDate As %Date;

/// 出院时间
Property PADischTime As %Time;

/// 出院科室
Property PADischLocDr As DHCHAI.BT.Location;

/// 出院病区
Property PADischWardDr As DHCHAI.BT.Location;

/// 住院天数（住院病人未出院值为-1）
Property PAAdmDays As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 新生儿标志
Property PAIsNewBaby As %Boolean [ Required ];

/// 新生儿出生体重（g）
Property PABirthWeight As %String(MAXLEN = 100, TRUNCATE = 1);

/// 新生儿入院体重（g）
Property PAAdmitWeight As %String(MAXLEN = 100, TRUNCATE = 1);

/// 更新日期
Property PAUpdateDate As %Date [ Required ];

/// 更新时间
Property PAUpdateTime As %Time [ Required ];

/// (新生儿)阿普加评分 "H" 手录标记 
Property PAApgar As %String(MAXLEN = 100, TRUNCATE = 1);

/// 就诊序号索引
Index IndexEpisodeIDx On PAEpisodeIDx As Exact;

/// 病人主索引索引
Index IndexPatientIDx On PAPatientIDx As Exact;

/// 登记号索引
Index IndexPapmiNo On PAPapmiNo As Exact;

/// 病案号索引
Index IndexMrNo On PAMrNo As Exact;

/// 姓名索引
Index IndexPatName On PAPatName As Exact;

/// 身份证号码索引
Index IndexIdentityCode On PAIdentityCode As Exact;

/// 死亡标志索引
Index IndexIsDeath On PAIsDeath As Exact;

/// 就诊类型+就诊日期时间索引
Index IndexAdmDateTime On (PAAdmType As Exact, PAAdmDate, PAAdmTime);

/// 就诊类型+出院日期时间索引
Index IndexDischDateTime On (PAAdmType As Exact, PADischDate, PADischTime);

/// 就诊类型+住院天数+就诊日期索引
Index IndexAdmDaysDate On (PAAdmType As Exact, PAAdmDays As Exact, PAAdmDate);

/// 就诊类型+就诊状态索引
Index IndexVisitStatus On (PAAdmType As Exact, PAVisitStatus As Exact);

/// Creator：     liyi
/// CreatDate：   2017-04-14
/// Description:  根据PAEpisodeIDx取就诊表
/// Table：       DHCHAI.DP.PAAdm
/// Input：       ID:    DHCHAI.DP.PAAdm.PAEpisodeIDx
/// Return：      返回Object
/// w ##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(981)
ClassMethod GetObjByEpisodeIDX(aEpisodeID As %String) As DHCHAI.DP.PAAdm
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set id = $o(^DHCHAI.DP.PAAdmI("IndexEpisodeIDx",aEpisodeID,""))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据ID取就诊表
/// Table：       DHCHAI.DP.PAAdm
/// Input：       ID:    DHCHAI.DP.PAAdm.ID
///               aSeparete: 指定的分隔符
/// Return：      返回Object
/// w ##class(DHCHAI.DP.PAAdm).GetObjById(5865)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.PAAdm
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.PAAdm).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.PAAdm).%OpenId(+id)
	Quit:'$IsObject(obj) return
	//add by zf 2017-12-07 年龄计算（出院显示出院年龄，在院期间实时计算）
	Set obj.PAAge=##class(DHCHAI.Utils.CommonSrv).GetPatAge(obj)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2018-01-07
/// Description:  根据ID取新生儿标志
/// Table：       DHCHAI.DP.PAAdm
/// Input：       ID:    DHCHAI.DP.PAAdm.ID
/// Return：      返回新生儿标志
/// w ##class(DHCHAI.DP.PAAdm).GetNewBabyById(5865)
ClassMethod GetNewBabyById(id As %String) As %String
{
	New (id)
	Set return=0
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.PAAdm).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.PAAdm).%OpenId(+id)
	Quit:'$IsObject(obj) return
	Set return=obj.PAIsNewBaby
	Do obj.%Close()

	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-04-1
/// Description:  根据EpisodeID取就诊表
/// Table：       DHCHAI.DP.PAAdm
/// Input：       EpisodeID
/// Return：      返回新生儿标志
/// w ##class(DHCHAI.DP.PAAdm).GetNewBabyByAdm(45)
ClassMethod GetNewBabyByAdm(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set aSCode="HIS01"
	Set id = $o(^DHCHAI.DP.PAAdmI("IndexEpisodeIDx",aSCode_"||"_aEpisodeID,""))
	Quit:id="" return
	Set obj=..GetObjById(id)
	Quit:'$IsObject(obj) return
	Set return=obj.PAIsNewBaby
	Do obj.%Close()
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2021-03-18
/// Description:  判断患者就诊状态是否有效
/// Table：       DHCHAI.DP.PAAdm
/// Input：       EpisodeID
/// Return：      返回新生儿标志
/// w ##class(DHCHAI.DP.PAAdm).GetVisIsActive(45)
ClassMethod GetVisIsActive(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=0
	Quit:aEpisodeID="" return
	
	Set PAAdmInfo = $g(^DHCHAI.DP.PAAdmD(aEpisodeID))
	Quit:PAAdmInfo="" return
	Set VisitStatus = $lg(PAAdmInfo,19)
	Quit:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U") return
	Set return=1
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新就诊表
/// Table：       DHCHAI.DP.PAAdm
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
///  w ##class(DHCHAI.DP.PAAdm).Update("^1^1^0009^0928^李毅^M^中国^^^^^^^0^2017-01-01^18:00:00^I^A^2017-01-01^18:00:00^^^^^^^^^^^^^^2017-01-01^18:00:00")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID				= $p(InStr,aSeparete,1)
	Set EpisodeIDx		= $p(InStr,aSeparete,2)
	Set PatientIDx		= $p(InStr,aSeparete,3)
	Set PapmiNo			= $p(InStr,aSeparete,4)
	Set MrNo			= $p(InStr,aSeparete,5)
	Set PatName			= $p(InStr,aSeparete,6)
	Set Sex				= $p(InStr,aSeparete,7)
	Set Nation			= $p(InStr,aSeparete,8)
	Set Birthday		= $p(InStr,aSeparete,9)
	Set Age				= $p(InStr,aSeparete,10)
	Set IdentityCode	= $p(InStr,aSeparete,11)
	Set HomeAddress		= $p(InStr,aSeparete,12)
	Set Company			= $p(InStr,aSeparete,13)
	Set RelativeName	= $p(InStr,aSeparete,14)
	Set RelativeTel		= $p(InStr,aSeparete,15)
	Set IsDeath			= +$p(InStr,aSeparete,16)
	Set DeathDate		= $p(InStr,aSeparete,17)
	Set DeathTime		= $p(InStr,aSeparete,18)
	Set AdmType			= $p(InStr,aSeparete,19)
	Set VisitStatus		= $p(InStr,aSeparete,20)
	Set AdmDate			= $p(InStr,aSeparete,21)
	Set AdmTime			= $p(InStr,aSeparete,22)
	Set AdmLocDr		= $p(InStr,aSeparete,23)
	Set AdmWardDr		= $p(InStr,aSeparete,24)
	Set AdmRoom			= $p(InStr,aSeparete,25)
	Set AdmBedDr    	= $p(InStr,aSeparete,26)
	Set DischDate		= $p(InStr,aSeparete,27)
	Set DischTime		= $p(InStr,aSeparete,28)
	Set DischLocDr		= $p(InStr,aSeparete,29)
	Set DischWardDr		= $p(InStr,aSeparete,30)
	Set AdmDays			= +$p(InStr,aSeparete,31)
	Set IsNewBaby		= +$p(InStr,aSeparete,32)
	Set BirthWeight		= $p(InStr,aSeparete,33)
	Set AdmitWeight		= $p(InStr,aSeparete,34)
	Set UpdateDate		= $p(InStr,aSeparete,35)
	Set UpdateTime		= $p(InStr,aSeparete,36)
	Set PAAdmTimes      = +$p(InStr,aSeparete,37)   //就诊次数
	Set PAAdmDoc        = $p(InStr,aSeparete,38)    //主管医生
	Set PAApgar			= $p(InStr,aSeparete,39)	//新生儿阿普加评分
	Set:Birthday["-" Birthday = $zdh(Birthday,3)
	Set:DeathDate["-" DeathDate = $zdh(DeathDate,3)
	Set:DeathTime[":" DeathTime = $zth(DeathTime,1)
	Set:AdmDate["-" AdmDate = $zdh(AdmDate,3)
	Set:AdmTime[":" AdmTime = $zth(AdmTime,1)
	Set:DischDate["-" DischDate = $zdh(DischDate,3)
	Set:DischTime[":" DischTime = $zth(DischTime,1)
	Set:UpdateDate["-" UpdateDate = $zdh(UpdateDate,3)
	Set:UpdateTime[":" UpdateTime = $zth(UpdateTime,1)

	Quit:(EpisodeIDx="")||(PatientIDx="")||(PatName="")||(Sex="")||(IsDeath="")||(AdmType="")||(VisitStatus="") return
	Quit:(AdmDate="")||(AdmTime="")||(AdmDays="")||(IsNewBaby="")||(UpdateDate="")||(UpdateTime="") return
	///就诊序号唯一性
	Set tID = $o(^DHCHAI.DP.PAAdmI("IndexEpisodeIDx",EpisodeIDx,0))
	Quit:(tID'="")&(ID'=tID) -100
	
	Set objAdmLoc = ##class(DHCHAI.BT.Location).GetObjById(AdmLocDr)
	Set objAdmWard = ##class(DHCHAI.BT.Location).GetObjById(AdmWardDr)
	Set objAdmBed = ##class(DHCHAI.BT.PACBed).GetObjById(AdmBedDr)
	Set objDischLoc = ##class(DHCHAI.BT.Location).GetObjById(DischLocDr)
	Set objDischWard = ##class(DHCHAI.BT.Location).GetObjById(DischWardDr)
	if ID="" {
		Set obj=##class(DHCHAI.DP.PAAdm).%New()
	}else{
		Set obj=##class(DHCHAI.DP.PAAdm).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.PAEpisodeIDx	= EpisodeIDx
	Set obj.PAPatientIDx	= PatientIDx
	Set obj.PAPapmiNo		= PapmiNo
	Set obj.PAMrNo			= MrNo
	Set obj.PAPatName		= PatName
	Set obj.PASex			= Sex
	Set obj.PANation		= Nation
	Set obj.PABirthday		= Birthday
	Set obj.PAAge			= Age
	Set obj.PAIdentityCode	= IdentityCode
	Set obj.PAHomeAddress	= HomeAddress
	Set obj.PACompany		= Company
	Set obj.PARelativeName	= RelativeName
	Set obj.PARelativeTel	= RelativeTel
	Set obj.PAIsDeath		= IsDeath
	Set obj.PADeathDate		= DeathDate	
	Set obj.PADeathTime		= DeathTime
	Set obj.PAAdmType		= AdmType
	Set obj.PAVisitStatus	= VisitStatus
	Set obj.PAAdmDate		= AdmDate
	Set obj.PAAdmTime		= AdmTime
	Set obj.PAAdmLocDr		= objAdmLoc
	Set obj.PAAdmWardDr		= objAdmWard
	Set obj.PAAdmRoom		= AdmRoom
	Set obj.PAAdmBedDr		= objAdmBed
	Set obj.PADischDate		= DischDate
	Set obj.PADischTime		= DischTime
	Set obj.PADischLocDr	= objDischLoc
	Set obj.PADischWardDr	= objDischWard
	Set obj.PAAdmDays		= AdmDays
	Set obj.PAIsNewBaby		= IsNewBaby
	Set obj.PABirthWeight	= BirthWeight
	//增加判断 如果无值就不覆盖补录体重
	Set:(AdmitWeight'="")&(+AdmitWeight>0) obj.PAAdmitWeight	= +AdmitWeight
	Set obj.PAUpdateDate	= UpdateDate
	Set obj.PAUpdateTime	= UpdateTime
	Set obj.PAAdmTimes      = PAAdmTimes   //住院次数
	Set obj.PAAdmDoc        = PAAdmDoc     //主管医生
	//apgar评分判断
	Set:obj.PAApgar="H" obj.PAApgar	= ""
	if (obj.PAApgar["H"){
		Set:PAApgar["H" obj.PAApgar	= PAApgar	 //手工填写的apgar评分优先级高
	}else{
		Set obj.PAApgar	= PAApgar
	}	
	
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  删除就诊表
/// Table：       DHCHAI.DP.PAAdm
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.DP.PAAdm).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PAEpisodeIDx</Value>
</Value>
<Value name="3">
<Value>PAPatientIDx</Value>
</Value>
<Value name="4">
<Value>PAPapmiNo</Value>
</Value>
<Value name="5">
<Value>PAMrNo</Value>
</Value>
<Value name="6">
<Value>PAPatName</Value>
</Value>
<Value name="7">
<Value>PASex</Value>
</Value>
<Value name="8">
<Value>PANation</Value>
</Value>
<Value name="9">
<Value>PABirthday</Value>
</Value>
<Value name="10">
<Value>PAIdentityCode</Value>
</Value>
<Value name="11">
<Value>PAHomeAddress</Value>
</Value>
<Value name="12">
<Value>PACompany</Value>
</Value>
<Value name="13">
<Value>PARelativeName</Value>
</Value>
<Value name="14">
<Value>PARelativeTel</Value>
</Value>
<Value name="15">
<Value>PAIsDeath</Value>
</Value>
<Value name="16">
<Value>PADeathDate</Value>
</Value>
<Value name="17">
<Value>PADeathTime</Value>
</Value>
<Value name="18">
<Value>PAAdmType</Value>
</Value>
<Value name="19">
<Value>PAVisitStatus</Value>
</Value>
<Value name="20">
<Value>PAAdmDate</Value>
</Value>
<Value name="21">
<Value>PAAdmTime</Value>
</Value>
<Value name="22">
<Value>PAAdmLocDr</Value>
</Value>
<Value name="23">
<Value>PAAdmWardDr</Value>
</Value>
<Value name="24">
<Value>PAAdmRoom</Value>
</Value>
<Value name="25">
<Value>PAAdmBedDr</Value>
</Value>
<Value name="26">
<Value>PADischDate</Value>
</Value>
<Value name="27">
<Value>PADischTime</Value>
</Value>
<Value name="28">
<Value>PADischLocDr</Value>
</Value>
<Value name="29">
<Value>PADischWardDr</Value>
</Value>
<Value name="30">
<Value>PAAdmPatCond</Value>
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
<Value>PAUpdateDate</Value>
</Value>
<Value name="36">
<Value>PAUpdateTime</Value>
</Value>
<Value name="37">
<Value>PAAge</Value>
</Value>
<Value name="38">
<Value>PAAdmTimes</Value>
</Value>
<Value name="39">
<Value>PAAdmDoc</Value>
</Value>
<Value name="40">
<Value>PAApgar</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.PAAdmD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.PAAdmD</IdLocation>
<IndexLocation>^DHCHAI.DP.PAAdmI</IndexLocation>
<StreamLocation>^DHCHAI.DP.PAAdmS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
