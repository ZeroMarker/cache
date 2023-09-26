Class dbo.BBEXTMatchData Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_EXTMatchData, StorageStrategy = Default ]
{

Index IndexMaster On (FromSuppCode, FromBarCode, ToSuppCode) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexToSuppCode On ToSuppCode [ SqlName = Index_ToSuppCode, Type = index ];

/// DDL Primary Key Specification
Index PKBBEXTMATCHDATA On RowID [ PrimaryKey, SqlName = PK_BB_EXTMATCHDATA, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 原始血站  
Property FromSuppCode As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ Required, SqlColumnNumber = 3 ];

/// 原始产品码  
Property FromBarCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 4 ];

/// 目标血站  
Property ToSuppCode As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ Required, SqlColumnNumber = 5 ];

/// 目标产品码  
Property ToBarCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 6 ];

/// 目标血产品   
Property PackSize As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 7 ];

/// 原始产品名称   
Property FromProduct As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 8 ];

/// 目标产品名称   
Property ToProduct As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BBEXTMatchDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FromSuppCode</Value>
</Value>
<Value name="3">
<Value>FromBarCode</Value>
</Value>
<Value name="4">
<Value>ToSuppCode</Value>
</Value>
<Value name="5">
<Value>ToBarCode</Value>
</Value>
<Value name="6">
<Value>PackSize</Value>
</Value>
<Value name="7">
<Value>FromProduct</Value>
</Value>
<Value name="8">
<Value>ToProduct</Value>
</Value>
</Data>
<DataLocation>^dbo.BBEXTMatchDataD</DataLocation>
<DefaultData>BBEXTMatchDataDefaultData</DefaultData>
<IdLocation>^dbo.BBEXTMatchDataD</IdLocation>
<IndexLocation>^dbo.BBEXTMatchDataI</IndexLocation>
<StreamLocation>^dbo.BBEXTMatchDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
