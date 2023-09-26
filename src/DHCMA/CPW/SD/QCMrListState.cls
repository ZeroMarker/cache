/// 名称: DHCMA.CPW.SD.QCMrListState
/// 描述: 质控病种病历列表状态记录
/// 编写者：fcz
/// 编写日期: 2018-09-10
Class DHCMA.CPW.SD.QCMrListState Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMA.CPW.SD.QCMrList [ Cardinality = parent, Inverse = ChildState ];

/// 状态附加信息记录
Relationship ChildAlias As DHCMA.CPW.SD.QCMrStateAlias [ Cardinality = children, Inverse = Parref ];

/// 状态(I确认,O排除,Save保存/Submit 提交/Check 已审核/tUp 测试上报/Up 正式上报/Back 退回)
Property StateCode As DHCMA.Util.BT.Dictionary [ Required ];

/// 状态操作人
Property StateDoc As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 状态变更日期
Property StateDate As %Date [ Required ];

/// 状态变更时间
Property StateTime As %Time [ Required ];

Index IndexParref On Parref;

Index IndexPState On (Parref, StateCode);

Index IndexDate On StateDate;

Index IndexDateState On (StateDate, StateCode As Exact);

/// w ##class(DHCMA.CPW.SD.QCMrListState).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SD.QCMrListState
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.QCMrListState).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.QCMrListState).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// w ##class(DHCMA.CPW.SD.QCMrListState).Update("3^557^1")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return		
	Set:$g(aSeparete)="" aSeparete="^"
	Set ParrefID		= $p(aInputStr,aSeparete,1)		
	Set StateCode      	= $p(aInputStr,aSeparete,2)
	Set StateDoc   		= $p(aInputStr,aSeparete,3)
	Set StateDate 		= $p(aInputStr,aSeparete,4)
	Set StateTime		= $p(aInputStr,aSeparete,5)
	Set:StateDate="" StateDate=+$h,StateTime=$p($h,",",2)
	Set obj=##class(DHCMA.CPW.SD.QCMrListState).%New()
	Quit:'$IsObject(obj) return	
	Set obj.Parref		=##class(DHCMA.CPW.SD.QCMrList).GetObjById(ParrefID)
	Set obj.StateCode	= ##class(DHCMA.Util.BT.Dictionary).GetObjByCode("SDQCMrStatus",StateCode)
	Set obj.StateDoc	= StateDoc
	Set obj.StateDate	= StateDate
	Set obj.StateTime	= StateTime	
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

Storage Default
{
<Data name="QCMrListStateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StateDr</Value>
</Value>
<Value name="3">
<Value>StateDoc</Value>
</Value>
<Value name="4">
<Value>StateDate</Value>
</Value>
<Value name="5">
<Value>StateTime</Value>
</Value>
<Value name="6">
<Value>StateCode</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildState")</DataLocation>
<DefaultData>QCMrListStateDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildState")</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.QCMrListStateI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.QCMrListStateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
