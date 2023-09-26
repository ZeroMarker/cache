/// 名称: DHCMA.CPW.STA.DataResults
/// 描述: 临床路径 记录明细信息
/// 编写者：jiangpengpeng
/// 编写日期: 2019-03-25
Class DHCMA.CPW.STA.DataDetails Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMA.CPW.STA.DataResults [ Cardinality = parent, Inverse = Child ];

/// 类型(F应入径,I入径,O出径,C完成,V变异,H院感)
Property STAType As %String;

/// 出入径记录ID(DHCMA.CPW.CP.Pathway)
Property STACPWID As %String;

Index IdxofType On (Parref As Exact, STAType As Exact, STACPWID As Exact);

/// Creator：     jiangpengpeng
/// CreatDate：   2019-03-25
/// Description:  更新数据
/// Table：       DHCMA.CPW.STA.DataDetails
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.STA.DataDetails).Update(1)
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=""
	Quit:aInputStr="" return
	
	Set Parref=$p(aInputStr,aSeparete,1)
	Set Type=$p(aInputStr,aSeparete,2)
	Set CPWID=$p(aInputStr,aSeparete,3)
	
	Set objParref=##class(DHCMA.CPW.STA.DataResults).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	
	Set obj=##class(DHCMA.CPW.STA.DataDetails).%New()
	Quit:'$IsObject(obj) return
	
	Set obj.Parref=objParref
	Set obj.STAType=Type
	Set obj.STACPWID=CPWID
	
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

/// Creator：     jiangpengpeng
/// CreatDate：   2019-03-25
/// Description:  清除数据
/// Table：       DHCMA.CPW.STA.DataDetails
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.STA.DataDetails).Clear()
ClassMethod Clear(Parref As %String)
{
	New (Parref)
	Set return=""
	Quit:Parref="" return
	
	Kill ^DHCMA.CPW.STA.DataResultsD(Parref,"Child")
	Kill ^DHCMA.CPW.STA.DataResultsI("Child","IdxofType",Parref)
	
	Quit 1
}

Storage Default
{
<Data name="DataDetailsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>STAType</Value>
</Value>
<Value name="3">
<Value>STACPWID</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Child")</DataLocation>
<DefaultData>DataDetailsDefaultData</DefaultData>
<IdLocation>{%%PARENT}("Child")</IdLocation>
<IndexLocation>^DHCMA.CPW.STA.DataResultsI("Child")</IndexLocation>
<StreamLocation>^DHCMA.CPW.STA.DataDetailsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
