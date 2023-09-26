Class DHCINM.HR.MgPartTimeLoc Extends %Persistent
{

Relationship ChildSub As DHCINM.HR.MgPartTimePost [ Cardinality = children, Inverse = Parref ];

/// 兼职科室
Property Loc As %String [ SqlColumnNumber = 2, SqlFieldName = PT_Loc ];

/// 联系人
Property ContactPerson As %String [ SqlColumnNumber = 3, SqlFieldName = PT_COntPerson ];

/// 联系方式
Property ContactPhone As %String [ SqlColumnNumber = 4, SqlFieldName = PT_ContPhone ];

/// 创建者
Property Creator As %String [ SqlColumnNumber = 5, SqlFieldName = PT_Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 6, SqlFieldName = PT_CreateDate ];

/// 启用日期
Property StartDate As %Date [ SqlColumnNumber = 7, SqlFieldName = PT_StartDate ];

/// 停用日期
Property StopDate As %Date [ SqlColumnNumber = 8, SqlFieldName = PT_StopDate ];

Index loc On Loc;

Storage Default
{
<Data name="MgPartTimeLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Loc</Value>
</Value>
<Value name="3">
<Value>ContactPerson</Value>
</Value>
<Value name="4">
<Value>ContactPhone</Value>
</Value>
<Value name="5">
<Value>Creator</Value>
</Value>
<Value name="6">
<Value>CreateDate</Value>
</Value>
<Value name="7">
<Value>StartDate</Value>
</Value>
<Value name="8">
<Value>StopDate</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HR.MgPartTimeLocD</DataLocation>
<DefaultData>MgPartTimeLocDefaultData</DefaultData>
<IdLocation>^DHCINM.HR.MgPartTimeLocD</IdLocation>
<IndexLocation>^DHCINM.HR.MgPartTimeLocI</IndexLocation>
<StreamLocation>^DHCINM.HR.MgPartTimeLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
