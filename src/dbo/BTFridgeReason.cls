/// 入库原因
Class dbo.BTFridgeReason Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_FridgeReason ]
{

Index IndexWorkGroup On WorkGroupDR [ SqlName = Index_WorkGroup, Type = index ];

/// Foreign Key FKBTFridgeReasonWorkGroupDR created via DDL
ForeignKey FKBTFridgeReasonWorkGroupDR(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BTFridgeReasonWorkGroupDR ];

/// DDL Primary Key Specification
Index PKBTFRIDGEREASON On RowID [ PrimaryKey, SqlName = PK_BT_FRIDGEREASON, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 原因  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 3 ];

/// 检索码  
Property RetrievalCode As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

/// 工作组  
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTFridgeReasonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CName</Value>
</Value>
<Value name="3">
<Value>RetrievalCode</Value>
</Value>
<Value name="4">
<Value>WorkGroupDR</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTFridgeReasonD</DataLocation>
<DefaultData>BTFridgeReasonDefaultData</DefaultData>
<IdLocation>^dbo.BTFridgeReasonD</IdLocation>
<IndexLocation>^dbo.BTFridgeReasonI</IndexLocation>
<StreamLocation>^dbo.BTFridgeReasonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
