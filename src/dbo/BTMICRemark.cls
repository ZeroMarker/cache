/// 微生物备注
Class dbo.BTMICRemark Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_MICRemark ]
{

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On (HospitalDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// Foreign Key FKBTMICRemarkHospitalDR created via DDL
ForeignKey FKBTMICRemarkHospitalDR(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BTMICRemarkHospitalDR ];

/// DDL Primary Key Specification
Index PKBTMICREMARK On RowID [ PrimaryKey, SqlName = PK_BT_MICREMARK, Type = index, Unique ];

Index IndexHospitalDR On (HospitalDR, Code) [ SqlName = Index_HospitalDR, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

/// 说明
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 4 ];

/// 医院
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 是否专用
Property IsSpecial As %Library.Boolean [ SqlColumnNumber = 6 ];

/// 序号
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 激活
Property Active As %Library.Boolean [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BTMICRemarkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Remark</Value>
</Value>
<Value name="4">
<Value>HospitalDR</Value>
</Value>
<Value name="5">
<Value>IsSpecial</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMICRemarkD</DataLocation>
<DefaultData>BTMICRemarkDefaultData</DefaultData>
<IdLocation>^dbo.BTMICRemarkD</IdLocation>
<IndexLocation>^dbo.BTMICRemarkI</IndexLocation>
<StreamLocation>^dbo.BTMICRemarkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
