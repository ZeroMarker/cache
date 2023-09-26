/// 名称: DHCHAI.IR.CCScreening
/// 描述: 疑似病例筛查病人列表
/// 编写者：chenjb
/// 编写日期: 2017-01-17
Class DHCHAI.IR.CCScreening Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 筛查结果列表
Relationship ChildDtl As DHCHAI.IR.CCScreenDtl [ Cardinality = children, Inverse = Parref ];

/// 筛查操作日志
Relationship ChildLog As DHCHAI.IR.CCScreenLog [ Cardinality = children, Inverse = Parref ];

/// 就诊记录
Property CSEpisodeDr As DHCHAI.DP.PAAdm;

/// 疑似筛查项目
Property CSItmScreenDr As DHCHAI.IR.CCItmScreen;

/// 疑似筛查文本
Property CSItmScreenTxt As %String(MAXLEN = 500, TRUNCATE = 1);

/// 疑似状态（1确诊、2排除）
Property CSStatus As %Integer;

/// 疑似诊断（部位）
Property CSInfSuPosDr As DHCHAI.BT.InfSuPos;

/// 结果开始日期
Property CSRstFromDate As %Date;

/// 结果截止日期（表示当前处理到哪天的结果了）
Property CSRstToDate As %Date;

/// 处置日期
Property CSActDate As %Date;

/// 处置时间
Property CSActTime As %Time;

/// 处置人
Property CSActUserDr As DHCHAI.BT.SysUser;

/// 处置意见
Property CSOpinion As %String(MAXLEN = 500, TRUNCATE = 1);

/// 处置意见字典
Property CSOpinionDr As DHCHAI.BT.Dictionary;

/// 处置人类型（1：临床，2：院感科）
Property CSActType As %String;

Index IndexEpisodeDr On CSEpisodeDr;

Index IndexActDateTime On (CSActDate, CSActTime);

Index IndexStatusActDate On (CSStatus As Exact, CSActDate);

Index IndexEpisodeItmScreen On (CSEpisodeDr, CSItmScreenDr, CSItmScreenTxt);

/// Creator：     chenjb
/// CreatDate：   2016-12-16
/// Description:  根据ID取疑似病例筛查病人信息
/// Table：       DHCHAI.IR.CCScreening
/// Input：       Id : DHCHAI.IR.CCScreening.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CCScreening).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.CCScreening
{
	New (aId)
	Quit:'##class(DHCHAI.IR.CCScreening).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.CCScreening).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chenjb
/// CreatDate：   2016-12-16
/// Description:  更新疑似病例筛查病人信息
/// Table：       DHCHAI.IR.CCScreening
/// Input：       各属性列表 ^分隔
/// 1 ID 2 CSEpisodeDr 3 CSItmScreenDr 4 CSItmScreenTxt 5 CSStatus 6 CSInfSuPosDr 7 CSRstToDate
/// 8 CSActDate 9 CSActTime 10 CSActUserDr 11 CSOpinion
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CCScreening).Update("^1^1^^","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID             = $p(aInputStr,aSeparete,1)
	Set EpisodeDr      = $p(aInputStr,aSeparete,2)
	Set ItmScreenDr    = $p(aInputStr,aSeparete,3)
	Set ItmScreenTxt   = $p(aInputStr,aSeparete,4)
	Set Status         = $p(aInputStr,aSeparete,5)
	Set InfSuPosDr     = $p(aInputStr,aSeparete,6)
	Set RstFromDate    = $p(aInputStr,aSeparete,7)
	Set RstToDate      = $p(aInputStr,aSeparete,8)
	Set ActDate        = $p(aInputStr,aSeparete,9)
	Set ActTime        = $p(aInputStr,aSeparete,10)
	Set ActUserDr      = $p(aInputStr,aSeparete,11)
	Set Opinion        = $p(aInputStr,aSeparete,12)
	Set OpinionDr      = $p(aInputStr,aSeparete,13)	
	Set ActType        = $p(aInputStr,aSeparete,14)	
	Quit:(EpisodeDr="")||(Status="") return
	
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
	Quit:'$IsObject(objEpisode) return
	Set objItmScreen=##class(DHCHAI.IR.CCItmScreen).GetObjById(ItmScreenDr)
	Quit:'$IsObject(objItmScreen) return
	Set objInfSuPos=##class(DHCHAI.BT.InfSuPos).GetObjById(InfSuPosDr)
	Set objOpinion=##class(DHCHAI.BT.Dictionary).GetObjById(OpinionDr)
	
	//Set:RstFromDate["-" RstFromDate=$zdh(RstFromDate,3)
	//Set:RstToDate["-" RstToDate=$zdh(RstToDate,3)
	//Set:ActDate["-" ActDate=$zdh(ActDate,3)
	Set:RstFromDate'="" RstFromDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(RstFromDate)
	Set:RstToDate'="" RstToDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(RstToDate)
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActDate="" ActDate=+$h   //当前日期
	Set:ActTime[":" ActTime=$zth(ActTime,1)
	Set:ActTime="" ActTime=$p($h,",",2)
	Set objActUser=##class(DHCHAI.BT.SysUser).GetObjById(ActUserDr)
	
	If ID="" {
		Set obj=##class(DHCHAI.IR.CCScreening).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.CCScreening).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.CSEpisodeDr    = objEpisode
	Set obj.CSItmScreenDr  = objItmScreen
	Set obj.CSItmScreenTxt = ItmScreenTxt
	Set obj.CSStatus       = Status
	Set obj.CSInfSuPosDr   = objInfSuPos
	Set obj.CSRstFromDate  = RstFromDate
	Set obj.CSRstToDate    = RstToDate
	Set obj.CSActDate      = ActDate
	Set obj.CSActTime      = ActTime
	Set obj.CSActUserDr    = objActUser
	set obj.CSOpinion      = Opinion
	set obj.CSOpinionDr    = objOpinion
	Set obj.CSActType      = ActType
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Quit:return<1 return
	
	//保存更新日志
	Set Parref=+return
	Set UpdateLog=Parref_"^"_Status_"^"_InfSuPosDr_"^"_ActUserDr_"^"_Opinion_"^"_OpinionDr_"^"_ActType
	Set flg=##Class(DHCHAI.IR.CCScreenLog).Update(UpdateLog,"^")
	
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2016-12-16
/// Description:  删除疑似病例筛查病人信息
/// Table：       DHCHAI_IR.CCScreening
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CCScreening).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.CCScreening).%DeleteId(aId)
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
<Data name="CCScreeningDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSEpisodeDr</Value>
</Value>
<Value name="3">
<Value>CSItmScreenDr</Value>
</Value>
<Value name="4">
<Value>CSItmScreenTxt</Value>
</Value>
<Value name="5">
<Value>CSStatus</Value>
</Value>
<Value name="6">
<Value>CSInfSuPosDr</Value>
</Value>
<Value name="7">
<Value>CSRstFromDate</Value>
</Value>
<Value name="8">
<Value>CSRstToDate</Value>
</Value>
<Value name="9">
<Value>CSActDate</Value>
</Value>
<Value name="10">
<Value>CSActTime</Value>
</Value>
<Value name="11">
<Value>CSActUserDr</Value>
</Value>
<Value name="12">
<Value>CSOpinion</Value>
</Value>
<Value name="13">
<Value>CSOpinionDr</Value>
</Value>
<Value name="14">
<Value>CSActType</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.CCScreeningD</DataLocation>
<DefaultData>CCScreeningDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.CCScreeningD</IdLocation>
<IndexLocation>^DHCHAI.IR.CCScreeningI</IndexLocation>
<StreamLocation>^DHCHAI.IR.CCScreeningS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
