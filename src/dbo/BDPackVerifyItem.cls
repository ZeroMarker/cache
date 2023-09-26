Class dbo.BDPackVerifyItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_PackVerifyItem ]
{

/// DDL Primary Key Specification
Index IndexMaster On (PackVerifyDR, PackCheckItemDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL   
Index IndexSeqNum On (PackVerifyDR, SeqNum) [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBDPACKVERIFYITEM On RowID [ PrimaryKey, SqlName = PK_BDPACK_VERIFYITEM, Type = index, Unique ];

/// Foreign Key FKBDPackCheckResultBBPackCheckItems created via DDL
ForeignKey FKBDPackVerifyItemBBPackCheckItems(PackCheckItemDR) References dbo.BBPackCheckItems(PKBBPACKCHECKITEMS) [ SqlName = FK_VerifyItem_CheckItems ];

/// Foreign Key FKCheckResultPack created via DDL
ForeignKey FKVerifyItemPackVerify(PackVerifyDR) References dbo.BDPackVerify(PKBDPACKVERIFY) [ SqlName = FK_VerifyItem_PackVerify ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 血袋信息  
Property PackVerifyDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 核查项目  
Property PackCheckItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 结果  
Property Result As %Library.Boolean [ SqlColumnNumber = 5 ];

/// 序号  
Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 说明  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BDPackVerifyItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PackVerifyDR</Value>
</Value>
<Value name="3">
<Value>PackCheckItemDR</Value>
</Value>
<Value name="4">
<Value>Result</Value>
</Value>
<Value name="5">
<Value>SeqNum</Value>
</Value>
<Value name="6">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.BDPackVerifyItemD</DataLocation>
<DefaultData>BDPackVerifyItemDefaultData</DefaultData>
<IdLocation>^dbo.BDPackVerifyItemD</IdLocation>
<IndexLocation>^dbo.BDPackVerifyItemI</IndexLocation>
<StreamLocation>^dbo.BDPackVerifyItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
