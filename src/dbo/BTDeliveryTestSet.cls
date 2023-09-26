/// 扫码登记医嘱
Class dbo.BTDeliveryTestSet Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_DeliveryTestSet ]
{

/// Foreign Key FKBTDeliveryTestSetTestSetDR created via DDL
ForeignKey FKBTDeliveryTestSetTestSetDR(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_BTDeliveryTestSetTestSetDR ];

/// DDL Primary Key Specification
Index PKBTDELIVERYTESTSET On RowID [ PrimaryKey, SqlName = PK_BT_DELIVERYTESTSET, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 医嘱  
Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 是否激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 5 ];

/// GroupCode  
Property GroupCode As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BTDeliveryTestSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestSetDR</Value>
</Value>
<Value name="3">
<Value>Sequence</Value>
</Value>
<Value name="4">
<Value>Active</Value>
</Value>
<Value name="5">
<Value>GroupCode</Value>
</Value>
</Data>
<DataLocation>^dbo.BTDeliveryTestSetD</DataLocation>
<DefaultData>BTDeliveryTestSetDefaultData</DefaultData>
<IdLocation>^dbo.BTDeliveryTestSetD</IdLocation>
<IndexLocation>^dbo.BTDeliveryTestSetI</IndexLocation>
<StreamLocation>^dbo.BTDeliveryTestSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
