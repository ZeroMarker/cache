/// 模板
Class dbo.BTTemplate Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_Template ]
{

Index IndexMaster On Code [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTTEMPLATEROWID On RowID [ PrimaryKey, SqlName = PK_BT_TEMPLATEROWID, Type = index, Unique ];

/// Foreign Key FKTestCodeHospital created via DDL
ForeignKey FKBTTemplateHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BTTemplateHospital ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 4 ];

/// 模板数据  
Property TemplateData As %Library.String(COLLATION = "Exact", MAXLEN = 99999999) [ SqlColumnNumber = 5 ];

/// 创建日期  
Property CreateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 创建时间  
Property CreateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 创建用户  
Property CreateUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 9 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="BTTemplateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>TemplateData</Value>
</Value>
<Value name="5">
<Value>CreateDate</Value>
</Value>
<Value name="6">
<Value>CreateTime</Value>
</Value>
<Value name="7">
<Value>CreateUserDR</Value>
</Value>
<Value name="8">
<Value>Active</Value>
</Value>
<Value name="9">
<Value>HospitalDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTemplateD</DataLocation>
<DefaultData>BTTemplateDefaultData</DefaultData>
<IdLocation>^dbo.BTTemplateD</IdLocation>
<IndexLocation>^dbo.BTTemplateI</IndexLocation>
<StreamLocation>^dbo.BTTemplateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
