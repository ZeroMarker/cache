/// BDSupplierPack
Class dbo.BDSupplierPack Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_SupplierPack, StorageStrategy = Default ]
{

/// Foreign Key FKBDSPackAddUser created via DDL
ForeignKey FKBDSPackAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_SPack_AddUser ];

/// Foreign Key FKBDSPackWorkGroup created via DDL
ForeignKey FKBDSPackWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BD_SPack_WorkGroup ];

/// Foreign Key FKBDPackBloodProduct created via DDL
ForeignKey FKBDSPackBloodProduct(BloodProductDR) References dbo.BBBloodProduct(PKBBBLOODPRODUCT) [ SqlName = FK_BD_SPack_BloodProduct ];

/// Foreign Key FKBDPackBGroup created via DDL
ForeignKey FKBDSPackBGroup(BloodGroupDR) References dbo.BBBloodGroup(PKBBBLOODGROUP) [ SqlName = FK_BD_SPack_BGroup ];

/// Foreign Key FKBDPackBGroup created via DDL
ForeignKey FKBDSPackPackIn(PackInDR) References dbo.BDPackIn(PKBDPACKIN) [ SqlName = FK_BD_SPack_PackIn ];

/// Foreign Key FKBDPackBGroup created via DDL
ForeignKey FKBDSPackPack(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_BD_SPack_Pack ];

Index IndexMaster On (PackBarcode, ProductCode, SplitLevel) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexReceiptID On ReceiptID [ SqlName = Index_ReceiptID, Type = index ];

Index IndexWorkGroup On (WorkGroupDR, AddDate) [ SqlName = Index_WorkGroup, Type = index ];

Index IndexPackIn On PackInDR [ SqlName = Index_PackIn, Type = index ];

/// DDL Primary Key Specification
Index PKBDSUPPLIERPACK On RowID [ PrimaryKey, SqlName = PK_BD_SUPPLIERPACK, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 血袋条码  
Property PackBarcode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

/// 血制品代码  
Property ProductCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 4 ];

/// 分装级别  
Property SplitLevel As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ Required, SqlColumnNumber = 5 ];

/// 血袋内部ID  
Property BloodID As %Library.String(COLLATION = "Exact", MAXLEN = 25) [ SqlColumnNumber = 6 ];

/// 血制品条码  
Property ProductBarcode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 7 ];

/// 血成分代码  
Property ComponentCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 8 ];

/// 血型代码  
Property BloodTypeCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 9 ];

/// ABO血型  
Property ABO As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 10 ];

/// RH血型  
Property RH As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 11 ];

/// 献血人姓名  
Property DonorName As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 12 ];

/// 献血时间  
Property DonateTimeStr As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 13 ];

/// 制备日期  
Property ProductTimeStr As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 14 ];

/// 失效日期  
Property ExpireTimeStr As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 15 ];

/// 血量  
Property BloodVolume As %Library.Float [ SqlColumnNumber = 16 ];

/// 入库金额  
Property MoneySum As %Library.Numeric(MAXVAL = 999999999999999.9999, MINVAL = -999999999999999.9999, SCALE = 4) [ SqlColumnNumber = 17 ];

/// 献血类型  
Property DonorType As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 18 ];

/// 备注  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 19 ];

/// 血站出库用户代码  
Property UserCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 20 ];

/// 血站出库用户名称  
Property UserName As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 21 ];

/// 血站出库单号  
Property ReceiptID As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 22 ];

/// 是否接收  {1:true,0:false}
Property IsReceived As %Library.Boolean [ SqlColumnNumber = 23 ];

/// 工作组  
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 24 ];

/// 创建日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 25 ];

/// 创建时间  
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 26 ];

/// 创建人  
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 27 ];

/// 血液产品  
Property BloodProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 28 ];

/// 血型组  
Property BloodGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 29 ];

/// 有效日期  
Property ExpiredDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 30 ];

/// 有效时间  
Property ExpiredTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 31 ];

/// 入库方式 1：手工，2：接口，3：文件  
Property AddWay As %Library.SmallInt [ SqlColumnNumber = 32 ];

/// 血袋入库单  
Property PackInDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 33 ];

/// 血袋  
Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 34 ];

/// 血站系统血制品ID  
Property ProductID As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 35 ];

/// 血站系统血制品名称  
Property ProductName As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 36 ];

/// 单位  
Property Unit As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 37 ];

Storage Default
{
<Data name="BDSupplierPackDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PackBarcode</Value>
</Value>
<Value name="3">
<Value>ProductCode</Value>
</Value>
<Value name="4">
<Value>SplitLevel</Value>
</Value>
<Value name="5">
<Value>BloodID</Value>
</Value>
<Value name="6">
<Value>ProductBarcode</Value>
</Value>
<Value name="7">
<Value>ComponentCode</Value>
</Value>
<Value name="8">
<Value>BloodTypeCode</Value>
</Value>
<Value name="9">
<Value>ABO</Value>
</Value>
<Value name="10">
<Value>RH</Value>
</Value>
<Value name="11">
<Value>DonorName</Value>
</Value>
<Value name="12">
<Value>DonateTimeStr</Value>
</Value>
<Value name="13">
<Value>ProductTimeStr</Value>
</Value>
<Value name="14">
<Value>ExpireTimeStr</Value>
</Value>
<Value name="15">
<Value>BloodVolume</Value>
</Value>
<Value name="16">
<Value>MoneySum</Value>
</Value>
<Value name="17">
<Value>DonorType</Value>
</Value>
<Value name="18">
<Value>Remark</Value>
</Value>
<Value name="19">
<Value>UserCode</Value>
</Value>
<Value name="20">
<Value>UserName</Value>
</Value>
<Value name="21">
<Value>ReceiptID</Value>
</Value>
<Value name="22">
<Value>IsReceived</Value>
</Value>
<Value name="23">
<Value>WorkGroupDR</Value>
</Value>
<Value name="24">
<Value>AddDate</Value>
</Value>
<Value name="25">
<Value>AddTime</Value>
</Value>
<Value name="26">
<Value>AddUserDR</Value>
</Value>
<Value name="27">
<Value>BloodProductDR</Value>
</Value>
<Value name="28">
<Value>BloodGroupDR</Value>
</Value>
<Value name="29">
<Value>ExpiredDate</Value>
</Value>
<Value name="30">
<Value>ExpiredTime</Value>
</Value>
<Value name="31">
<Value>AddWay</Value>
</Value>
<Value name="32">
<Value>PackInDR</Value>
</Value>
<Value name="33">
<Value>PackDR</Value>
</Value>
<Value name="34">
<Value>ProductID</Value>
</Value>
<Value name="35">
<Value>ProductName</Value>
</Value>
<Value name="36">
<Value>Unit</Value>
</Value>
</Data>
<DataLocation>^dbo.BDSupplierPackD</DataLocation>
<DefaultData>BDSupplierPackDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDSupplierPackD</IdLocation>
<IndexLocation>^dbo.BDSupplierPackI</IndexLocation>
<StreamLocation>^dbo.BDSupplierPackS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
