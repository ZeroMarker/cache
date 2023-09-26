/// 名称: DHCMA.CPW.SD.QCItemExec
/// 描述: 单病种质控项目执行结果
/// 编写者：fcz
/// 编写日期: 2018-09-10
Class DHCMA.CPW.SD.QCItemExec Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMA.CPW.SD.QCMrList [ Cardinality = parent, Inverse = ChildExec ];

/// 项目
Property ExecItemDr As DHCMA.CPW.SD.QCEntityItem;

/// 执行结果
Property ExecResult As %String(MAXLEN = 500, TRUNCATE = 1);

/// 执行类型（自动 A  默认 D   手工H）
Property ExecType As %String;

/// 执行人
Property ExecDoc As %String;

/// 执行日期
Property ExecDate As %String;

/// 执行时间
Property ExecTime As %String;

/// 数据来源ObjectID
Property ObjectID As %String;

Index IndexOfType On ExecType;

Index IndexParrefItemDr On (Parref, ExecItemDr);

/// w ##class(DHCMA.CPW.SD.QCItemExec).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SD.QCExpress
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.QCItemExec).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.QCItemExec).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// w ##class(DHCMA.CPW.SD.QCItemExec).Update("4040^1||63^a^^65904^39352^^A")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return		
	Set:$g(aSeparete)="" aSeparete="^"
	Set Parref    		= $p(aInputStr,aSeparete,1)
	Set ExecItemDr     	= $p(aInputStr,aSeparete,2)
	Set ExecResult		= $p(aInputStr,aSeparete,3)
	Set ExecDoc			= $p(aInputStr,aSeparete,4)
	Set ExecDate		= $p(aInputStr,aSeparete,5)
	Set ExecTime		= $p(aInputStr,aSeparete,6)
	Set ObjectID		= $p(aInputStr,aSeparete,7)
	Set ExecType		= $p(aInputStr,aSeparete,8)	  
	Set:ExecDate="" ExecDate=+$h
	Set:ExecTime="" ExecTime=$P($H,",",2)
	Set obj=##class(DHCMA.CPW.SD.QCItemExec).%New()
	Quit:'$IsObject(obj) return
	Set obj.Parref        		= ##class(DHCMA.CPW.SD.QCMrList).GetObjById(Parref)
	Set obj.ExecItemDr			= ##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(ExecItemDr)
	Set obj.ExecResult			= ExecResult
	Set obj.ExecType    		= ExecType
	Set obj.ExecDoc     		= ExecDoc
	Set obj.ExecDate			= ExecDate
	Set obj.ExecTime  			= ExecTime	
	Set obj.ObjectID			= ObjectID
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
<Data name="QCItemExecDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ExecCPWDr</Value>
</Value>
<Value name="3">
<Value>ExecItemDr</Value>
</Value>
<Value name="4">
<Value>ExecResult</Value>
</Value>
<Value name="5">
<Value>ExecType</Value>
</Value>
<Value name="6">
<Value>ExecDate</Value>
</Value>
<Value name="7">
<Value>ExecTypeDr</Value>
</Value>
<Value name="8">
<Value>ExecDatetime</Value>
</Value>
<Value name="9">
<Value>ExecTime</Value>
</Value>
<Value name="10">
<Value>ExecDoc</Value>
</Value>
<Value name="11">
<Value>ObjectID</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Exec")</DataLocation>
<DefaultData>QCItemExecDefaultData</DefaultData>
<IdLocation>{%%PARENT}("Exec")</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.QCMrListI("Exec")</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.QCItemExecS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
