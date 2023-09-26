/// 名称: DHCMed.EPD.CasesX
/// 描述: 疾病筛查日志
/// 编写者：pylian
/// 编写日期: 2020-07-28
Class DHCMed.SS.CasesX Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 筛查明细
Relationship ChildDtl As DHCMed.SS.CasesXDtl [ Cardinality = children, Inverse = Parref ];

/// 产品代码
Property CXProductCode As %String;

/// 就诊号
Property CXEpisodeID As %String;

/// 发生日期
Property CXActDate As %Date;

/// 结果日期
Property CXRstDate As %Date;

/// 触发科室
Property CXActLoc As %String;

/// 触发诊断
Property CXActDiagnos As %String;

/// 初诊A、复诊R
Property CXIsReAdm As %String;

/// 处置状态（-1未处置、1确诊/标记、0排除）
Property CXStatus As %String;

/// 确诊诊断(DHCMed.SS.Disease)
Property CXDiagnos As %String;

/// 处置意见
Property CXOpinion As %String(MAXLEN = 500);

/// 评价日期
Property CXEvalDate As %Date;

/// 评价时间
Property CXEvalTime As %Time;

/// 评价科室
Property CXEvalLoc As %String;

/// 评价人
Property CXEvalUser As %String;

/// 是否有效
Property CXIsActive As %Boolean;

/// 备注
Property CXResume As %String(MAXLEN = 500);

Index IndexPaadm On (CXProductCode As Exact, CXEpisodeID As Exact);

Index IndexStatusDate On (CXProductCode As Exact, CXStatus As Exact, CXActDate As Exact);

///  一次就诊同一诊断只有一条疾病诊断
Index IndexActDiagnos On (CXProductCode As Exact, CXEpisodeID As Exact, CXActDiagnos);

Index IndexActDate On (CXProductCode As Exact, CXActDate As Exact);

/// Creator：     liuzhenhe
/// CreatDate：   2020-08-04
/// Description:  根据ID取疾病筛查日志
/// Table：       DHCMed.SS.CasesX
/// Input：       ID:    DHCMed.SS.CasesX.ID
/// Return：      返回Object
/// w ##class(DHCMed.SS.CasesX).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.SS.CasesX
{
	New (aId)
	Set return=""
	Quit:'..%ExistsId(+aId) return
	Set obj=..%OpenId(+aId)
	Do:obj'="" obj.%Close()
	
	Quit obj
}

/// Creator：     liuzhenhe
/// CreatDate：   2020-08-04
/// Description:  删除疾病筛查日志
/// Table：       DHCMed.SS.CasesX
/// Input：       ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMed.SS.CasesX).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)

	Set sc = ..%Delete(aId)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set ret=-1
	}else{
		set ret=0
	}
	
	quit ret
}

/// Creator：     zhufei
/// CreatDate：   2014-06-19
/// Description:  更新疾病筛查日志
/// Table：       DHCMed.SS.CasesX
/// Input：       各属性列表 separator: 指定的分隔符(delimiter)
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.SS.CasesX).Update("","^")
ClassMethod Update(aInStr As %String, separator As %String) As %String
{
	New (aInStr,separator)
	Set return=""
	Quit:aInStr="" return
	Set:$g(separator)="" separator=..#SEPARATE
	
	Set ID			=$p(aInStr,separator,1)
	Set ProductCode	= $p(aInStr,separator,2)
	Set EpisodeID	= $p(aInStr,separator,3)
	Set ActDate		= $p(aInStr,separator,4)
	Set ActDate		= ##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(ActDate)
	Set RstDate		= $p(aInStr,separator,5)
	Set RstDate		= ##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(RstDate)
	Set ActLoc		= $p(aInStr,separator,6)
	Set ActDiagnos	= $p(aInStr,separator,7)
	Set IsReAdm		= $p(aInStr,separator,8)
	Set Status		= $p(aInStr,separator,9)
	Set Diagnos		= $p(aInStr,separator,10)
	Set Opinion		= $p(aInStr,separator,11)
	Set EvalDate	= $p(aInStr,separator,12)
	Set:EvalDate="" CXEvalDate=+$h
	Set EvalTime	= $p(aInStr,separator,13)
	set:EvalTime="" EvalTime=$p($h,",",2)
	Set EvalLoc		= $p(aInStr,separator,14)
	Set EvalUser	= $p(aInStr,separator,15)
	Set IsActive	= $p(aInStr,separator,16)
	Set Resume		= $p(aInStr,separator,17)
	quit:(ProductCode="")||(EpisodeID="")||(ActDate="")||(RstDate="") return
	If ID="" {
		Set obj		= ..%New()
	}else {
		Set obj		= ..%OpenId(ID)
	}
	
	Set obj.CXProductCode	= ProductCode
	Set obj.CXEpisodeID		= EpisodeID
	Set obj.CXActDate		= ActDate
	Set obj.CXRstDate		= RstDate
	Set obj.CXActDiagnos    = ActDiagnos
	Set obj.CXActLoc		= ActLoc
	Set obj.CXIsReAdm		= IsReAdm
	Set obj.CXStatus		= Status
	Set obj.CXDiagnos		= Diagnos
	Set obj.CXOpinion		= Opinion
	Set obj.CXEvalDate		= EvalDate
	Set obj.CXEvalTime		= EvalTime
	Set obj.CXEvalLoc		= EvalLoc
	Set obj.CXEvalUser		= EvalUser
	Set obj.CXIsActive		= IsActive
	Set obj.CXResume		= Resume
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {
		Do $system.OBJ.DisplayError(sc)
		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CXProductCode</Value>
</Value>
<Value name="3">
<Value>CXEpisodeID</Value>
</Value>
<Value name="4">
<Value>CXActDate</Value>
</Value>
<Value name="5">
<Value>CXRstDate</Value>
</Value>
<Value name="6">
<Value>CXActLoc</Value>
</Value>
<Value name="7">
<Value>CXActDiagnos</Value>
</Value>
<Value name="8">
<Value>CXIsReAdm</Value>
</Value>
<Value name="9">
<Value>CXStatus</Value>
</Value>
<Value name="10">
<Value>CXDiagnos</Value>
</Value>
<Value name="11">
<Value>CXOpinion</Value>
</Value>
<Value name="12">
<Value>CXEvalDate</Value>
</Value>
<Value name="13">
<Value>CXEvalTime</Value>
</Value>
<Value name="14">
<Value>CXEvalLoc</Value>
</Value>
<Value name="15">
<Value>CXEvalUser</Value>
</Value>
<Value name="16">
<Value>CXIsActive</Value>
</Value>
<Value name="17">
<Value>CXResume</Value>
</Value>
</Data>
<DataLocation>^MA.SS.CasesXD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^MA.SS.CasesXD</IdLocation>
<IndexLocation>^MA.SS.CasesXI</IndexLocation>
<StreamLocation>^MA.SS.CasesXS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
