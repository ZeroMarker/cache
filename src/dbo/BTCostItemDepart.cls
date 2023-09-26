Class dbo.BTCostItemDepart Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_CostItemDepart, StorageStrategy = Default ]
{

/// Foreign Key FKBBAgreeTestItemHospital created via DDL
ForeignKey FKBTCostItemDepartCostItem(CostItemDR) References dbo.BTCostItem(PKBTCOSTITEM) [ SqlName = FK_BTCostItemDepart_CostItem ];

/// Foreign Key FKBBAgreeTestItemItem created via DDL
ForeignKey FKBTCostItemDepartDepart(DepartmentDR) References dbo.BTDepartment(PKBTDEPARTMENT) [ SqlName = FK_BTCostItemDepart_Depart ];

Index IndexMaster On (CostItemDR, DepartmentDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexDepartment On (DepartmentDR, CostItemDR) [ SqlName = Index_Department, Type = index ];

/// DDL Primary Key Specification
Index PKBTCOSTITEMDEPART On RowID [ PrimaryKey, SqlName = PK_BT_COSTITEM, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property CostItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property DepartmentDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BTCostItemDepartDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CostItemDR</Value>
</Value>
<Value name="3">
<Value>DepartmentDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTCostItemDepartD</DataLocation>
<DefaultData>BTCostItemDepartDefaultData</DefaultData>
<IdLocation>^dbo.BTCostItemDepartD</IdLocation>
<IndexLocation>^dbo.BTCostItemDepartI</IndexLocation>
<StreamLocation>^dbo.BTCostItemDepartS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
