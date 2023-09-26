/// 血袋核查
Class dbo.BBCheckPack Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_CheckPack, StorageStrategy = Default ]
{

/// Foreign Key FKBBCheckPackHospital created via DDL
ForeignKey FKBBCheckPackHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BB_CheckPack_Hospital ];

/// Foreign Key FKBBCheckPackItems created via DDL
ForeignKey FKBBCheckPackItems(PackCheckItemDR) References dbo.BBPackCheckItems(PKBBPACKCHECKITEMS) [ SqlName = FK_BB_CheckPack_Items ];

/// Foreign Key FKBBBPFBProduct created via DDL
ForeignKey FKBBBPFBProduct(BloodProductDR) References dbo.BBBloodProduct(PKBBBLOODPRODUCT) [ SqlName = FK_BB_BPF_BProduct ];

Index IndexMaster On (HospitalDR, CheckStage, PackCheckItemDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSeqNum On SeqNum [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBBCHECKPACK On RowID [ PrimaryKey, SqlName = PK_BB_CHECKPACK, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 核查阶段  
Property CheckStage As %Library.SmallInt [ Required, SqlColumnNumber = 3 ];

/// 核查项目  
Property PackCheckItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 序号  
Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 默认结果  
Property DefaultResult As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 7 ];

/// 血液产品  
Property BloodProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BBCheckPackDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CheckStage</Value>
</Value>
<Value name="3">
<Value>PackCheckItemDR</Value>
</Value>
<Value name="4">
<Value>HospitalDR</Value>
</Value>
<Value name="5">
<Value>SeqNum</Value>
</Value>
<Value name="6">
<Value>DefaultResult</Value>
</Value>
<Value name="7">
<Value>BloodProductDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BBCheckPackD</DataLocation>
<DefaultData>BBCheckPackDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BBCheckPackD</IdLocation>
<IndexLocation>^dbo.BBCheckPackI</IndexLocation>
<StreamLocation>^dbo.BBCheckPackS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
