/// 术语文献管理
Class User.TKBDocManage Extends %Persistent [ SqlTableName = TKB_DocManage ]
{

Property TKBDomCode As %String [ SqlFieldName = TKBDom_Code ];

Property TKBDomDesc As %String [ SqlFieldName = TKBDom_Desc ];

Property TKBDomPath As %String [ SqlFieldName = TKBDom_Path ];

Property TKBDomSource As %String [ SqlFieldName = TKBDom_Source ];

Property TKBDomType As %String(DISPLAYLIST = ",doc,excel,pdf", VALUELIST = ",D,E,P") [ SqlFieldName = TKBDom_Type ];

Property TKBDomUpdateUser As User.SSUser [ SqlFieldName = TKBDom_UpdateUser ];

Property TKBDomUpdateDate As %Date [ SqlFieldName = TKBDom_UpdateDate ];

Property TKBDomFlag As %String [ SqlFieldName = TKBDom_Flag ];

Property TKBDomNote As %String [ SqlFieldName = TKBDom_Note ];

Index CodeIndex On TKBDomCode;

Storage Default
{
<Data name="TKBDocManageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TKBDomCode</Value>
</Value>
<Value name="3">
<Value>TKBDomDesc</Value>
</Value>
<Value name="4">
<Value>TKBDomPath</Value>
</Value>
<Value name="5">
<Value>TKBDomSource</Value>
</Value>
<Value name="6">
<Value>TKBDomType</Value>
</Value>
<Value name="7">
<Value>TKBDomUpdateUser</Value>
</Value>
<Value name="8">
<Value>TKBDomUpdateDate</Value>
</Value>
<Value name="9">
<Value>TKBDomFlag</Value>
</Value>
<Value name="10">
<Value>TKBDomNote</Value>
</Value>
</Data>
<DataLocation>^User.TKBDocManageD</DataLocation>
<DefaultData>TKBDocManageDefaultData</DefaultData>
<IdLocation>^User.TKBDocManageD</IdLocation>
<IndexLocation>^User.TKBDocManageI</IndexLocation>
<StreamLocation>^User.TKBDocManageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
