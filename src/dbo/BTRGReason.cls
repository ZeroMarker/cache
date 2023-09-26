/// 处理原因
Class dbo.BTRGReason Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTRG_Reason, StorageStrategy = Default ]
{

Index IndexMaster On (HospitalDR, ReasonType, Code) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSequence On (HospitalDR, ReasonType, Sequence) [ SqlName = Index_Sequence, Type = index ];

Index IndexDepartment On DepartmentDR [ SqlName = Index_Department, Type = index ];

/// DDL Primary Key Specification
Index PKBTRGREASON On RowID [ PrimaryKey, SqlName = PK_BTRG_REASON, Type = index, Unique ];

/// Foreign Key FKRGReasonHospital created via DDL
ForeignKey FKRGReasonHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_RG_Reason_Hospital ];

/// ID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 4 ];

/// 类型  {5:报损原因,4:借出原因,6:作废原因,2:拒绝原因,0:取消审核订单原因,1:取消审核入库单原因,3:取消审核出库单原因,7:退货原因,8:取消审核请领原因}
Property ReasonType As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 激活  {1:是,0:否}
Property Active As %Library.Boolean [ SqlColumnNumber = 8 ];

///       
Property DepartmentDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BTRGReasonDefaultData">
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
<Value>ReasonType</Value>
</Value>
<Value name="5">
<Value>HospitalDR</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
<Value name="8">
<Value>DepartmentDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTRGReasonD</DataLocation>
<DefaultData>BTRGReasonDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTRGReasonD</IdLocation>
<IndexLocation>^dbo.BTRGReasonI</IndexLocation>
<StreamLocation>^dbo.BTRGReasonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
