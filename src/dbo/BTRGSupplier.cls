/// 供应商
Class dbo.BTRGSupplier Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTRG_Supplier, StorageStrategy = Default ]
{

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On (HospitalDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

Index IndexDepartment On DepartmentDR [ SqlName = Index_Department, Type = index ];

/// DDL Primary Key Specification
Index PKBTRGSUPPLIER On RowID [ PrimaryKey, SqlName = PK_BTRG_SUPPLIER, Type = index, Unique ];

/// Foreign Key FKRGSupplierHospital created via DDL
ForeignKey FKRGSupplierHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_RG_Supplier_Hospital ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 4 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 地址  
Property Address As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 6 ];

/// 办公电话  
Property OfficeTel As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 7 ];

/// 手机  
Property Mobile As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 8 ];

/// 全称  
Property FullName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 9 ];

/// 送货人  
Property Carrier As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 10 ];

/// 联系人  
Property Linkman As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 11 ];

/// 传真  
Property Fax As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 12 ];

/// 邮编  
Property Postcode As %Library.String(COLLATION = "Exact", MAXLEN = 6) [ SqlColumnNumber = 13 ];

/// 邮箱  
Property Email As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 14 ];

/// 备注  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 15 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 17 ];

///       
Property DepartmentDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

Storage Default
{
<Data name="BTRGSupplierDefaultData">
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
<Value>HospitalDR</Value>
</Value>
<Value name="5">
<Value>Address</Value>
</Value>
<Value name="6">
<Value>OfficeTel</Value>
</Value>
<Value name="7">
<Value>Mobile</Value>
</Value>
<Value name="8">
<Value>FullName</Value>
</Value>
<Value name="9">
<Value>Carrier</Value>
</Value>
<Value name="10">
<Value>Linkman</Value>
</Value>
<Value name="11">
<Value>Fax</Value>
</Value>
<Value name="12">
<Value>Postcode</Value>
</Value>
<Value name="13">
<Value>Email</Value>
</Value>
<Value name="14">
<Value>Remark</Value>
</Value>
<Value name="15">
<Value>Sequence</Value>
</Value>
<Value name="16">
<Value>Active</Value>
</Value>
<Value name="17">
<Value>DepartmentDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTRGSupplierD</DataLocation>
<DefaultData>BTRGSupplierDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTRGSupplierD</IdLocation>
<IndexLocation>^dbo.BTRGSupplierI</IndexLocation>
<StreamLocation>^dbo.BTRGSupplierS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
