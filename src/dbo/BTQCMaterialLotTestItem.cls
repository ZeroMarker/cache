/// 质控开通项目
Class dbo.BTQCMaterialLotTestItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTQC_MaterialLotTestItem ]
{

/// Foreign Key FKBTQCMaterialLotTestItemMaterialLotDR created via DDL
ForeignKey FKBTQCMaterialLotTestItemMaterialLotDR(MaterialLotDR) References dbo.BTQCMaterialLot(PKBTQCMATERIALLOT) [ SqlName = FK_BTQCMaterialLotTestItemMaterialLotDR ];

/// Foreign Key FKBTQCMaterialLotTestItemTestCodeDR created via DDL
ForeignKey FKBTQCMaterialLotTestItemTestCodeDR(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_BTQCMaterialLotTestItemTestCodeDR ];

/// DDL Primary Key Specification
Index PKBTQCMATERIALLOTTESTITEM On RowID [ PrimaryKey, SqlName = PK_BTQC_MATERIALLOTTESTITEM, Type = index, Unique ];

Index IndexMaster On (MaterialLotDR, TestCodeDR) [ SqlName = Index_Master, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 批次
Property MaterialLotDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 项目
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 图形类型
Property GraphType As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 5 ];

/// 精度
Property Precision As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 6 ];

/// 其他精度
Property OthPrecis As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 7 ];

/// 测试方法
Property TestMethod As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 8 ];

/// 靶值类型
Property CalcType As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BTQCMaterialLotTestItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MaterialLotDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
<Value name="4">
<Value>GraphType</Value>
</Value>
<Value name="5">
<Value>Precision</Value>
</Value>
<Value name="6">
<Value>OthPrecis</Value>
</Value>
<Value name="7">
<Value>TestMethod</Value>
</Value>
<Value name="8">
<Value>CalcType</Value>
</Value>
</Data>
<DataLocation>^dbo.BTQCMaterialLotTestItemD</DataLocation>
<DefaultData>BTQCMaterialLotTestItemDefaultData</DefaultData>
<IdLocation>^dbo.BTQCMaterialLotTestItemD</IdLocation>
<IndexLocation>^dbo.BTQCMaterialLotTestItemI</IndexLocation>
<StreamLocation>^dbo.BTQCMaterialLotTestItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
