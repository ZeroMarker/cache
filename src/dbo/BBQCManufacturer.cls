/// 输血质控 试剂厂商
Class dbo.BBQCManufacturer Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BBQC_Manufacturer ]
{

/// Foreign Key FKBBQCManufacturerHospitalDR created via DDL
ForeignKey FKBBQCManufacturerHospitalDR(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BBQCManufacturerHospitalDR ];

/// DDL Primary Key Specification
Index PKBBQCMANUFACTURER On RowID [ PrimaryKey, SqlName = PK_BBQC_MANUFACTURER, Type = index, Unique ];

Index IndexMaster On (HospitalDR, Code) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSequence On (HospitalDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 4 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 地址  
Property Address As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 6 ];

/// 办公电话  
Property OfficeTel As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 7 ];

/// 手机号  
Property Mobile As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 8 ];

/// 全名  
Property FullName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 9 ];

/// 联系人  
Property Linkman As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 10 ];

/// 传真  
Property Fax As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 11 ];

/// 邮编  
Property Postcode As %Library.String(COLLATION = "Exact", MAXLEN = 6) [ SqlColumnNumber = 12 ];

/// 邮箱  
Property Email As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 13 ];

/// 说明  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 14 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 16 ];

Storage Default
{
<Data name="BBQCManufacturerDefaultData">
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
</Data>
<DataLocation>^dbo.BBQCManufacturerD</DataLocation>
<DefaultData>BBQCManufacturerDefaultData</DefaultData>
<IdLocation>^dbo.BBQCManufacturerD</IdLocation>
<IndexLocation>^dbo.BBQCManufacturerI</IndexLocation>
<StreamLocation>^dbo.BBQCManufacturerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
