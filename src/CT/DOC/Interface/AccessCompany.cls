/// 对外接口厂家列表
Class CT.DOC.Interface.AccessCompany Extends (%Persistent, User.Abstract) [ SqlTableName = AccessCompany ]
{

Index IdxCode On CompanyCode;

Index IdxDesc On CompanyDesc;

/// 厂家代码
Property CompanyCode As %String(COLLATION = "Exact", MAXLEN = 99) [ Required, SqlColumnNumber = 2, SqlFieldName = Company_Code ];

/// 厂家描述
Property CompanyDesc As %String(COLLATION = "Exact", MAXLEN = 99) [ Required, SqlColumnNumber = 3, SqlFieldName = Company_Desc ];

/// 开始日期
Property CompanyStDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Company_StDate ];

/// 结束日期
Property CompanyEndDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Company_EndDate ];

Storage Default
{
<Data name="CT.DOC.Interface.AccessCompanyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CompanyCode</Value>
</Value>
<Value name="3">
<Value>CompanyDesc</Value>
</Value>
<Value name="4">
<Value>CompanyStDate</Value>
</Value>
<Value name="5">
<Value>CompanyEndDate</Value>
</Value>
</Data>
<DataLocation>^CT.DOC.Interface.AccessCompanyD</DataLocation>
<DefaultData>CT.DOC.Interface.AccessCompanyDefaultData</DefaultData>
<IdLocation>^CT.DOC.Interface.AccessCompanyD</IdLocation>
<IndexLocation>^CT.DOC.Interface.AccessCompanyI</IndexLocation>
<SqlRowIdName>Company_Rowid</SqlRowIdName>
<StreamLocation>^CT.DOC.Interface.AccessCompanyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
