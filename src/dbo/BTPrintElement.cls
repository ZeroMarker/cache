/// 打印元素
Class dbo.BTPrintElement Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_PrintElement, StorageStrategy = Default ]
{

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexPrintTemplate On PrintTemplateDR [ SqlName = Index_PrintTemplate, Type = index ];

Index IndexSequence On (HospitalDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTPRINTELEMENT On RowID [ PrimaryKey, SqlName = PK_BT_PRINTELEMENT, Type = index, Unique ];

/// Foreign Key FKPrintElement created via DDL
ForeignKey FKPrintElement(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_PrintElement ];

/// Foreign Key FKPrintElementTempl created via DDL
ForeignKey FKPrintElementTempl(PrintTemplateDR) References dbo.BTPrintTemplate(PKBTPRINTTEMPLATE) [ SqlName = FK_PrintElementTempl ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 4 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 模板  
Property PrintTemplateDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 属性串  
Property PropertyStr As %Library.String(COLLATION = "Exact", MAXLEN = 2000) [ SqlColumnNumber = 7 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BTPrintElementDefaultData">
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
<Value>HospitalDR</Value>
</Value>
<Value name="5">
<Value>PrintTemplateDR</Value>
</Value>
<Value name="6">
<Value>PropertyStr</Value>
</Value>
<Value name="7">
<Value>Sequence</Value>
</Value>
<Value name="8">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTPrintElementD</DataLocation>
<DefaultData>BTPrintElementDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTPrintElementD</IdLocation>
<IndexLocation>^dbo.BTPrintElementI</IndexLocation>
<StreamLocation>^dbo.BTPrintElementS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
