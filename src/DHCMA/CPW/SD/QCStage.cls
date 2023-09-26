/// 名称: DHCMA.CPW.SD.QCStage
/// 描述: 单病种质控项目阶段
/// 编写者：fuchengzhi
/// 编写日期: 2018-09-10
Class DHCMA.CPW.SD.QCStage Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 质控分类代码
Property BTCode As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 质控分类名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

Index IdxOfCode On BTCode;

ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SD.QCStage
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.QCStage).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.QCStage).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// w ##class(DHCMA.CPW.SD.QCStage).Update("^DiagInfo^诊疗信息")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return		
	Set:$g(aSeparete)="" aSeparete="^"
	Set ID               = $p(aInputStr,aSeparete,1)
	Set Code             = $p(aInputStr,aSeparete,2)
	Set Desc             = $p(aInputStr,aSeparete,3)
	Set tID=$o(^DHCMA.CPW.SD.QCStageI("IdxOfCode"," "_$zcvt(Code,"U"),0))
	Quit:(tID'="")&(ID'=tID) -2                
	If ID="" {
		Set obj=##class(DHCMA.CPW.SD.QCStage).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.SD.QCStage).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode        = Code
	Set obj.BTDesc        = Desc
	
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
<Data name="QCStageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTCode</Value>
</Value>
<Value name="3">
<Value>BTDesc</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.SD.QCStageD</DataLocation>
<DefaultData>QCStageDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SD.QCStageD</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.QCStageI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.QCStageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
