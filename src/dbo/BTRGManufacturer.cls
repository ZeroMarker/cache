/// 厂商
Class dbo.BTRGManufacturer Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTRG_Manufacturer, StorageStrategy = Default ]
{

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On (HospitalDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

Index IndexDepartment On DepartmentDR [ SqlName = Index_Department, Type = index ];

/// DDL Primary Key Specification
Index PKBTRGMANUFACTURER On RowID [ PrimaryKey, SqlName = PK_BTRG_MANUFACTURER, Type = index, Unique ];

/// Foreign Key FKRGManufacturerHospital created via DDL
ForeignKey FKRGManufacturerHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_RG_Manufacturer_Hospital ];

/// ID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 4 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 联系地址  
Property Address As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 6 ];

/// 办公电话  
Property OfficeTel As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 7 ];

/// 手机号  
Property Mobile As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 8 ];

/// 全称  
Property FullName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 9 ];

/// 联系人  
Property Linkman As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 10 ];

/// 传真  
Property Fax As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 11 ];

/// 邮政编码  
Property Postcode As %Library.String(COLLATION = "Exact", MAXLEN = 6) [ SqlColumnNumber = 12 ];

/// 电子邮箱  
Property Email As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 13 ];

/// 备注  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 14 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 16 ];

///       
Property DepartmentDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

Storage Default
{
<Data name="BTRGManufacturerDefaultData">
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
<Value>Linkman</Value>
</Value>
<Value name="10">
<Value>Fax</Value>
</Value>
<Value name="11">
<Value>Postcode</Value>
</Value>
<Value name="12">
<Value>Email</Value>
</Value>
<Value name="13">
<Value>Remark</Value>
</Value>
<Value name="14">
<Value>Sequence</Value>
</Value>
<Value name="15">
<Value>Active</Value>
</Value>
<Value name="16">
<Value>DepartmentDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTRGManufacturerD</DataLocation>
<DefaultData>BTRGManufacturerDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTRGManufacturerD</IdLocation>
<IndexLocation>^dbo.BTRGManufacturerI</IndexLocation>
<StreamLocation>^dbo.BTRGManufacturerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
