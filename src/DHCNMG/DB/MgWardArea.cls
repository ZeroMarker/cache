/// creator:xbl
/// date:20170810
/// desc:片区
Class DHCNMG.DB.MgWardArea Extends %Persistent
{

/// 代码
Property AreaCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = Area_Code ];

/// 描述
Property AreaDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = Area_Desc ];

/// 片区护士长
Property AreaNurHeadDR As DHCNMG.HR.MgPersons [ SqlColumnNumber = 4, SqlFieldName = Area_NurHeadDR ];

/// 启用日期
Property AreaStDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Area_StDate ];

/// 停用日期
Property AreaEndDate As %Date [ SqlColumnNumber = 6, SqlFieldName = Area_EndDate ];

Index Code On AreaCode [ Unique ];

Index NurHead On AreaNurHeadDR [ Condition = {Area_NurHeadDR'=""} ];

Storage Default
{
<Data name="MgWardAreaDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AreaCode</Value>
</Value>
<Value name="3">
<Value>AreaDesc</Value>
</Value>
<Value name="4">
<Value>AreaNurHeadDR</Value>
</Value>
<Value name="5">
<Value>AreaStDate</Value>
</Value>
<Value name="6">
<Value>AreaEndDate</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgWardAreaD</DataLocation>
<DefaultData>MgWardAreaDefaultData</DefaultData>
<IdLocation>^DHCNMG.DB.MgWardAreaD</IdLocation>
<IndexLocation>^DHCNMG.DB.MgWardAreaI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgWardAreaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
