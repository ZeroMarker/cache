Class dbo.BTSTQueryConf Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTST_QueryConf, StorageStrategy = Default ]
{

Index IndexMaster On (HospitalDR, Code) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSequence On (HospitalDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTSTQueryConf On RowID [ PrimaryKey, SqlName = PK_BTST_QueryConf, Type = index, Unique ];

/// Foreign Key FKWorkGroup created via DDL
ForeignKey FKBTSTQueryConfWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BTSTQueryConfWorkGroup ];

/// Foreign Key FKTATTestSetHospital created via DDL
ForeignKey FKBTSTQueryConfHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BTSTQueryConfHospital ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 4 ];

/// 医院
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 统计分类
Property GroupType As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 6 ];

/// 序号
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 工作组
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 公式
Property Rule As %Library.String(MAXLEN = 1000) [ SqlColumnNumber = 9 ];

/// 公式解释
Property RuleName As %Library.String(MAXLEN = 1000) [ SqlColumnNumber = 10 ];

/// 激活
Property Active As %Library.Boolean [ SqlColumnNumber = 11 ];

Storage Default
{
<Data name="BTSTQueryConfDefaultData">
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
<Value>GroupType</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
<Value name="7">
<Value>WorkGroupDR</Value>
</Value>
<Value name="8">
<Value>Rule</Value>
</Value>
<Value name="9">
<Value>RuleName</Value>
</Value>
<Value name="10">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTSTQueryConfD</DataLocation>
<DefaultData>BTSTQueryConfDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTSTQueryConfD</IdLocation>
<IndexLocation>^dbo.BTSTQueryConfI</IndexLocation>
<StreamLocation>^dbo.BTSTQueryConfS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
