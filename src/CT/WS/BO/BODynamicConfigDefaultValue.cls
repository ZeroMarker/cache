Class CT.WS.BO.BODynamicConfigDefaultValue Extends %Persistent
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "DynamicConfigDefaultValue";

/// Creator：     dujinrong
/// CreatDate：    2013-12-26
/// Description:   创建一个新对象，并将属性设置上
/// Table：        
/// Input：        ClassName：类名 Properties: 属性=Value, 逗号分隔
/// Output：       
/// Return：        
/// test: d ##class(CT.WS.BO.BODynamicConfigDefaultValue).AddRecord("EPRmeta.SysOption", "Description=Description,OptionValue=OptionValue")    
ClassMethod AddRecord(ClassName As %String, morenzhi As %String) As %String [ WebMethod ]
{
	q ##class(CT.WS.BLL.BLDynamicConfigDefaultValue).AddRecord(ClassName, morenzhi)
}

/// Creator：     dujinrong
/// CreatDate：    2013-12-26
/// Description:   修改对象
/// Table：        
/// Input：        ClassName：类名 ID:主键 Properties: 属性=Value, 逗号分隔
/// Output：       
/// Return：
/// d ##class(CT.WS.BO.BODynamicConfigDefaultValue).DelRecord()              
ClassMethod DelRecord(ClassName As %String) [ WebMethod ]
{
	d ##class(CT.WS.BLL.BLDynamicConfigDefaultValue).DelRecord(ClassName)
}

Storage Default
{
<Data name="BODynamicConfigDefaultValueDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CT.WS.BO.BODynamicCoA559D</DataLocation>
<DefaultData>BODynamicConfigDefaultValueDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CT.WS.BO.BODynamicCoA559D</IdLocation>
<IndexLocation>^CT.WS.BO.BODynamicCoA559I</IndexLocation>
<StreamLocation>^CT.WS.BO.BODynamicCoA559S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
