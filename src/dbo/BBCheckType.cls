/// 	寄存出库类型
Class dbo.BBCheckType Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_CheckType ]
{

/// Foreign Key FKBBCheckTypeHospitalDR created via DDL
ForeignKey FKBBCheckTypeHospitalDR(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BBCheckTypeHospitalDR ];

/// DDL Primary Key Specification
Index PKBBCHECKTYPE On RowID [ PrimaryKey, SqlName = PK_BB_CHECKTYPE, Type = index, Unique ];

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSeqNum On (HospitalDR, Sequence) [ SqlName = Index_SeqNum, Type = index ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 4 ];

/// 医院
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 序号
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 激活
Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BBCheckTypeDefaultData">
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
<DataLocation>^dbo.BBCheckTypeD</DataLocation>
<DefaultData>BBCheckTypeDefaultData</DefaultData>
<IdLocation>^dbo.BBCheckTypeD</IdLocation>
<IndexLocation>^dbo.BBCheckTypeI</IndexLocation>
<StreamLocation>^dbo.BBCheckTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
