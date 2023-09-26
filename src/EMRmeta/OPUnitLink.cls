/// 对应链接单元配置
Class EMRmeta.OPUnitLink Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxName On Name;

Property Name As %String(TRUNCATE = 1);

Property Title As %String(TRUNCATE = 1);

Property Link As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 对应页面上保存至病历按钮事件writeBack中的取值方法
Property Method As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 显示及引用格式
Property Scheme As %String(MAXLEN = 3000, TRUNCATE = 1);

/// 是否直接打开链接地址页面，不通过iframe打开(Y 直接打开/N 通过iframe打开)
Property IsDirectOpen As %String(TRUNCATE = 1);

/// d ##Class(EMRmeta.OPUnitLink).Init()
ClassMethod Init()
{
	d ##class(EMRmeta.OPUnitLink).%BuildIndices()
		
	s Name = "diag"
	s Title = "诊断"
	s id=$O(^DHCEMRM.OPHisToolsI("IdxName"," "_$zcvt(Name,"U"),""))
	if (""'=id) {
		s obj = ##Class(EMRmeta.OPHisTools).%OpenId(id)
		s Link = obj.Link
		s Method = "getDiag"
		d ..insertRecord(Name, Title, Link, Method)
	}

	
	s Name = "oeord"
	s Title = "医嘱"
	s id=$O(^DHCEMRM.OPHisToolsI("IdxName"," "_$zcvt(Name,"U"),""))
	if (""'=id) {
		s obj = ##Class(EMRmeta.OPHisTools).%OpenId(id)
		s Link = obj.Link
		s Method = "getOeord"
		d ..insertRecord(Name, Title, Link, Method)
	}
}

/// d ##class(EMRmeta.OPUnitLink).%BuildIndices()
ClassMethod insertRecord(Name, Title, Link, Method As %String)
{
	s id=$O(^DHCEMRM.OPUnitLinkI("IdxName"," "_$zcvt(Name,"U"),""))
	q:(""'=id)

	s obj = ##Class(EMRmeta.OPUnitLink).%New()
	s obj.Name = Name
	s obj.Title = Title
	s obj.Link = Link
	s obj.Method = Method
	d obj.%Save()
}

/// d ##class(EMRmeta.OPUnitLink).mergeGlobal()
ClassMethod mergeGlobal()
{
	merge ^DHCEMRM.OPHisToolsD = ^EMRmeta.OPHisToolsD
	merge ^DHCEMRM.OPHisToolsI = ^EMRmeta.OPHisToolsI
	merge ^DHCEMRM.OPHisToolsS = ^EMRmeta.OPHisToolsS
	
	merge ^DHCEMRM.OPResourceD = ^EMRmeta.OPResourceD
	merge ^DHCEMRM.OPResourceI = ^EMRmeta.OPResourceI
	merge ^DHCEMRM.OPResourceS = ^EMRmeta.OPResourceS
	
	merge ^DHCEMRM.OPResource2D = ^EMRmeta.OPResource2D
	merge ^DHCEMRM.OPResource2I = ^EMRmeta.OPResource2I
	merge ^DHCEMRM.OPResource2S = ^EMRmeta.OPResource2S
	
	merge ^DHCEMRM.OPSectionResD = ^EMRmeta.OPSectionResD
	merge ^DHCEMRM.OPSectionResI = ^EMRmeta.OPSectionResI
	merge ^DHCEMRM.OPSectionResS = ^EMRmeta.OPSectionResS
	
	merge ^DHCEMRM.OPUnitLinkD = ^EMRmeta.OPUnitLinkD
	merge ^DHCEMRM.OPUnitLinkI = ^EMRmeta.OPUnitLinkI
	merge ^DHCEMRM.OPUnitLinkS = ^EMRmeta.OPUnitLinkS
}

Storage Default
{
<Data name="OPUnitLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Title</Value>
</Value>
<Value name="4">
<Value>Link</Value>
</Value>
<Value name="5">
<Value>Method</Value>
</Value>
<Value name="6">
<Value>Scheme</Value>
</Value>
<Value name="7">
<Value>IsDirectOpen</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.OPUnitLinkD</DataLocation>
<DefaultData>OPUnitLinkDefaultData</DefaultData>
<IdLocation>^DHCEMRM.OPUnitLinkD</IdLocation>
<IndexLocation>^DHCEMRM.OPUnitLinkI</IndexLocation>
<StreamLocation>^DHCEMRM.OPUnitLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
