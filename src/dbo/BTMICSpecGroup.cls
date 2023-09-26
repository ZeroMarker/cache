/// 微生物标本组
Class dbo.BTMICSpecGroup Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTMIC_SpecGroup ]
{

/// Foreign Key FKBTMICSpecGroupHospitalDR created via DDL
ForeignKey FKBTMICSpecGroupHospitalDR(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BTMICSpecGroupHospitalDR ];

/// DDL Primary Key Specification
Index PKBTMICSPECGROUP On RowID [ PrimaryKey, SqlName = PK_BTMIC_SPECGROUP, Type = index, Unique ];

Index IndexHospitalDR On (HospitalDR, Code) [ SqlName = Index_HospitalDR, Type = index, Unique ];

Index IndexSequence On (HospitalDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

/// 医院
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 序号
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 激活
Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTMICSpecGroupDefaultData">
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
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMICSpecGroupD</DataLocation>
<DefaultData>BTMICSpecGroupDefaultData</DefaultData>
<IdLocation>^dbo.BTMICSpecGroupD</IdLocation>
<IndexLocation>^dbo.BTMICSpecGroupI</IndexLocation>
<StreamLocation>^dbo.BTMICSpecGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
