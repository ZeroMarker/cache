Class dbo.BDPackVerifyResult Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_PackVerifyResult, StorageStrategy = Default ]
{

/// DDL Primary Key Specification
Index IndexMaster On (PackDR, CheckStage, PackCheckItemDR) [ PrimaryKey, SqlName = Index_Master, Type = index, Unique ];

/// DDL   
Index IndexSeqNum On (PackDR, CheckStage, SeqNum) [ SqlName = Index_SeqNum, Type = index ];

/// Foreign Key FKBDPackCheckResultBBPackCheckItems created via DDL
ForeignKey FKBDPackCheckResultBBPackCheckItems(PackCheckItemDR) References dbo.BBPackCheckItems(PKBBPACKCHECKITEMS) [ SqlName = FK_CheckResult_CheckItems ];

/// Foreign Key FKCheckResultPack created via DDL
ForeignKey FKCheckResultPack(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_CheckResult_Pack ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 血袋信息  
Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 血袋核查阶段  
Property CheckStage As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 核查项目  
Property PackCheckItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 结果  
Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 6 ];

/// 序号  
Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BDPackVerifyResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PackDR</Value>
</Value>
<Value name="3">
<Value>CheckStage</Value>
</Value>
<Value name="4">
<Value>PackCheckItemDR</Value>
</Value>
<Value name="5">
<Value>Result</Value>
</Value>
<Value name="6">
<Value>SeqNum</Value>
</Value>
</Data>
<DataLocation>^dbo.BDPackVerifyResultD</DataLocation>
<DefaultData>BDPackVerifyResultDefaultData</DefaultData>
<IdLocation>^dbo.BDPackVerifyResultD</IdLocation>
<IndexLocation>^dbo.BDPackVerifyResultI</IndexLocation>
<StreamLocation>^dbo.BDPackVerifyResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
