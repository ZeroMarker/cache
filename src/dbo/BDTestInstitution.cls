Class dbo.BDTestInstitution Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_TestInstitution, StorageStrategy = Default ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSeqNum On SeqNum [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBDTESTINSTITUTION On RowID [ PrimaryKey, SqlName = PK_BDTESTINSTITUTION, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

/// 名称
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 4 ];

/// 描述
Property FullDesc As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 5 ];

/// 机构代码
Property InstitutionNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 6 ];

/// 地址
Property Address As %Library.String(COLLATION = "Exact", MAXLEN = 60) [ SqlColumnNumber = 7 ];

/// 联系电话
Property Telephone As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 8 ];

/// 机构类型0:都适合,1:仅检测标本，2：仅交叉配血
Property InstType As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 9 ];

/// 备注
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 10 ];

/// 序号
Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 是否激活
Property Active As %Library.Boolean [ SqlColumnNumber = 12 ];

Storage Default
{
<Data name="BDTestInstitutionDefaultData">
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
<Value>SeqNum</Value>
</Value>
<Value name="5">
<Value>Active</Value>
</Value>
<Value name="6">
<Value>FullDesc</Value>
</Value>
<Value name="7">
<Value>InstitutionNo</Value>
</Value>
<Value name="8">
<Value>Address</Value>
</Value>
<Value name="9">
<Value>Telephone</Value>
</Value>
<Value name="10">
<Value>InstType</Value>
</Value>
<Value name="11">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.BDTestInstitutionD</DataLocation>
<DefaultData>BDTestInstitutionDefaultData</DefaultData>
<IdLocation>^dbo.BDTestInstitutionD</IdLocation>
<IndexLocation>^dbo.BDTestInstitutionI</IndexLocation>
<StreamLocation>^dbo.BDTestInstitutionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
