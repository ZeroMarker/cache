/// 名称: DHCHAI.IR.CCFeedback
/// 描述: 用户反馈列表
/// 编写者：zhufei
/// 编写日期: 2017-09-27
Class DHCHAI.IR.CCFeedback Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊记录
Property CCEpisodeDr As DHCHAI.DP.PAAdm;

/// 问题类型
Property CCQuestTypeDr As DHCHAI.BT.Dictionary;

/// 问题说明
Property CCQuestNote As %String(MAXLEN = 1000, TRUNCATE = 1) [ Required ];

/// 登记日期
Property CCRegDate As %Date;

/// 登记时间
Property CCRegTime As %Time;

/// 登记人
Property CCRegUserDr As DHCHAI.BT.SysUser;

/// 登记科室
Property CCRegLocDr As DHCHAI.BT.Location;

/// 处置日期
Property CCActDate As %Date;

/// 处置时间
Property CCActTime As %Time;

/// 处置人
Property CCActUserDr As DHCHAI.BT.SysUser;

/// 处置科室
Property CCActLocDr As DHCHAI.BT.Location;

/// 处置意见
Property CCOpinion As %String(MAXLEN = 500, TRUNCATE = 1);

/// 问题类型+就诊记录索引
Index IndexAdmQuestType On (CCQuestTypeDr As Exact, CCEpisodeDr As Exact);

/// 登记日期+登记时间索引
Index IndexRegDateTime On (CCRegDate, CCRegTime);

/// Creator：     mayanpeng
/// CreatDate：   2017-10-12
/// Description:  根据ID取用户反馈信息
/// Table：       DHCHAI.IR.CCFeedback
/// Input：       aId : DHCHAI.IR.CCFeedback.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CCFeedback).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.CCFeedback
{
	New (aId)
	Quit:'##class(DHCHAI.IR.CCFeedback).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.CCFeedback).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     mayanpeng
/// CreatDate：   2017-10-12
/// Description:  更新用户反馈信息
/// Table：       DHCHAI.IR.CCFeedback
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CCFeedback).Update("^37664^1^问题详情4^^^9^^^10^","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID          = $p(aInputStr,aSeparete,1)
	Set EpisodeDr   = $p(aInputStr,aSeparete,2)
	Set TypeCode    = $p(aInputStr,aSeparete,3)
	Set QuestNote	= $p(aInputStr,aSeparete,4)
	Set RegDate     = $p(aInputStr,aSeparete,5)
	Set RegTime     = $p(aInputStr,aSeparete,6)
	Set RegUserDr   = $p(aInputStr,aSeparete,7)
	Set ActDate   	= $p(aInputStr,aSeparete,8)
	Set ActTime   	= $p(aInputStr,aSeparete,9)
	Set ActUserDr  	= $p(aInputStr,aSeparete,10)
	Set Opinion 	= $p(aInputStr,aSeparete,11)
    Set RegLocDr    = $p(aInputStr,aSeparete,12)
    Set ActLocDr    = $p(aInputStr,aSeparete,13)
	
	//Set:RegDate["-" RegDate = $zdh(RegDate,3)
    Set:RegDate'="" RegDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(RegDate)
	Set:RegTime[":" RegTime = $zth(RegTime,1)
	//Set:ActDate["-" ActDate = $zdh(ActDate,3)
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	
	Set:RegDate="" RegDate = +$h
	Set:RegTime="" RegTime = +($p($h,",",2))
	Set:ActDate="" ActDate = +$h
	Set:ActTime="" ActTime = +($p($h,",",2))
	
	Quit:(QuestNote="")||(TypeCode="") return
	
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
	Quit:'$IsObject(objAdm) return
	
	Set objType = ##class(DHCHAI.BT.Dictionary).GetObjByCode("FeedbackType",TypeCode)
	Quit:'$IsObject(objType) return
	
	Set objRegUser = ""
	If RegUserDr'=""{
		Set objRegUser = ##class(DHCHAI.BT.SysUser).GetObjById(RegUserDr)
		Quit:'$IsObject(objRegUser) return
	}
    Set objRegLoc = ""
    If RegLocDr'=""{
        Set objRegLoc = ##class(DHCHAI.BT.Location).GetObjById(RegLocDr)
        Quit:'$IsObject(objRegLoc) return
    }
    Set objActUser = ""
    If ActUserDr'=""{
        Set objActUser = ##class(DHCHAI.BT.SysUser).GetObjById(ActUserDr)
        Quit:'$IsObject(objActUser) return
    }
    Set objActLoc = ""
    If ActLocDr'=""{
        Set objActLoc = ##class(DHCHAI.BT.Location).GetObjById(ActLocDr)
        Quit:'$IsObject(objActLoc) return
    }
	If ID="" {
		Set obj=##class(DHCHAI.IR.CCFeedback).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.CCFeedback).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.CCEpisodeDr   = objAdm
	Set obj.CCQuestTypeDr = objType
	Set obj.CCQuestNote	  = QuestNote
	Set obj.CCRegDate	  = RegDate
	Set obj.CCRegTime     = RegTime
	Set obj.CCRegUserDr   = objRegUser
	Set obj.CCActDate     = ActDate
	Set obj.CCActTime     = ActTime
	Set obj.CCActUserDr	  = objActUser
	Set obj.CCOpinion	  = Opinion
    Set obj.CCRegLocDr    = objRegLoc
    Set obj.CCActLocDr    = objActLoc
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

/// Creator：     mayanpeng
/// CreatDate：   2017-10-12
/// Description:  删除用户反馈信息
/// Table：       DHCHAI.IR.CCFeedback
/// Input：       aId : DHCHAI.IR.CCFeedback.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CCFeedback).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.CCFeedback).%DeleteId(aId)
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
<Data name="CCFeedbackDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CCEpisodeDr</Value>
</Value>
<Value name="3">
<Value>CCQuestTypeDr</Value>
</Value>
<Value name="4">
<Value>CCQuestNote</Value>
</Value>
<Value name="5">
<Value>CCRegDate</Value>
</Value>
<Value name="6">
<Value>CCRegTime</Value>
</Value>
<Value name="7">
<Value>CCRegUserDr</Value>
</Value>
<Value name="8">
<Value>CCActDate</Value>
</Value>
<Value name="9">
<Value>CCActTime</Value>
</Value>
<Value name="10">
<Value>CCActUserDr</Value>
</Value>
<Value name="11">
<Value>CCOpinion</Value>
</Value>
<Value name="12">
<Value>CCRegLocDr</Value>
</Value>
<Value name="13">
<Value>CCActLocDr</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.CCFeedbackD</DataLocation>
<DefaultData>CCFeedbackDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.CCFeedbackD</IdLocation>
<IndexLocation>^DHCHAI.IR.CCFeedbackI</IndexLocation>
<StreamLocation>^DHCHAI.IR.CCFeedbackS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
