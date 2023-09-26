/// 试剂耗材
Class dbo.BTRGReagent Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTRG_Reagent, StorageStrategy = Default ]
{

Index IndexCategory On (HospitalDR, CategoryDR) [ SqlName = Index_Category, Type = index ];

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexManufacturer On (HospitalDR, ManufacturerDR) [ SqlName = Index_Manufacturer, Type = index ];

Index IndexSequence On (HospitalDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

Index IndexBarCode On (HospitalDR, BarCode) [ SqlName = Index_BarCode, Type = index ];

Index IndexDepartment On DepartmentDR [ SqlName = Index_Department, Type = index ];

/// DDL Primary Key Specification
Index PKBTRGREAGENT On RowID [ PrimaryKey, SqlName = PK_BTRG_REAGENT, Type = index, Unique ];

/// Foreign Key FKBTRGREARGREAGENBTRGUNI created via DDL
ForeignKey FKBTRGREARGREAGENBTRGUNI(UnitDR) References dbo.BTRGUnit(PKBTRGUNIT) [ SqlName = FK_BTRG_REA_RG_REAGEN_BTRG_UNI ];

/// Foreign Key FKRGReagentGroupType created via DDL
ForeignKey FKRGReagentGroupType(CategoryDR) References dbo.BTRGCategory(PKBTRGCATEGORY) [ SqlName = FK_RG_Reagent_GroupType ];

/// Foreign Key FKRGReagentHospital created via DDL
ForeignKey FKRGReagentHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_RG_Reagent_Hospital ];

/// Foreign Key FKRGReagentManufacturer created via DDL
ForeignKey FKRGReagentManufacturer(ManufacturerDR) References dbo.BTRGManufacturer(PKBTRGMANUFACTURER) [ SqlName = FK_RG_Reagent_Manufacturer ];

/// Foreign Key FKRGReagentStorageModel created via DDL
ForeignKey FKRGReagentStorageModel(StorageModelDR) References dbo.BTRGStorageModel(PKBTRGSTORAGEMODEL) [ SqlName = FK_RG_Reagent_StorageModel ];

/// Foreign Key FKRGReagentPosition created via DDL
ForeignKey FKRGReagentPosition(PositionDR) References dbo.BTRGPosition(PKBTRGPOSITION) [ SqlName = FK_RG_Reagent_Position ];

/// Foreign Key FKRGReagentDepartment created via DDL
ForeignKey FKRGReagentDepartment(DepartmentDR) References dbo.BTDepartment(PKBTDEPARTMENT) [ SqlName = FK_RG_Reagent_Department ];

/// ID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 4 ];

/// 英文简称  
Property EName As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 5 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 类别  
Property CategoryDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 图片  
Property Photo As %Library.String(COLLATION = "Exact", MAXLEN = 8000) [ SqlColumnNumber = 8 ];

/// 存储方式  
Property StorageModelDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 生产厂商  
Property ManufacturerDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 货号  
Property SynID As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 11 ];

/// 条形码  
Property BarCode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 12 ];

/// 规格型号  
Property PackageSize As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 13 ];

/// 包装容量  
Property Volume As %Library.Float [ SqlColumnNumber = 14 ];

/// 容量单位  
Property VolUnit As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 15 ];

/// 包装单位（整）  
Property UnitDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

/// 包装单位（拆）  
Property PackUnit As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

/// 最小使用单位  
Property MinUseUnit As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 18 ];

/// 生产批号  
Property BatchNo As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 19 ];

/// 许可证号  
Property LicenseNo As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 20 ];

/// 注册证号  
Property RegisterNo As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 21 ];

/// 注册证有效期  
Property RegExpireDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

/// 预警最低库存线  
Property MixQty As %Library.Float [ SqlColumnNumber = 23 ];

/// 预警最高库存线  
Property MaxQty As %Library.Float [ SqlColumnNumber = 24 ];

/// 最佳库存  
Property StandardQty As %Library.Float [ SqlColumnNumber = 25 ];

/// 预警天数  
Property WarnDays As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 26 ];

/// 备注  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 27 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 28 ];

/// 激活  {1:是,0:否}
Property Active As %Library.Boolean [ SqlColumnNumber = 29 ];

/// 有效期天数  
Property StorageDays As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 30 ];

/// 开封后保存天数  
Property UnsealSaveDays As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 31 ];

/// 开封预警天数  
Property UnsealWarnDays As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 32 ];

///       
Property SelfMatch As %Library.Boolean [ SqlColumnNumber = 33 ];

///       
Property FilePath As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 34 ];

///       
Property PositionDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 35 ];

///       
Property DepartmentDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 36 ];

Storage Default
{
<Data name="BTRGReagentDefaultData">
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
<Value>EName</Value>
</Value>
<Value name="5">
<Value>HospitalDR</Value>
</Value>
<Value name="6">
<Value>CategoryDR</Value>
</Value>
<Value name="7">
<Value>Photo</Value>
</Value>
<Value name="8">
<Value>StorageModelDR</Value>
</Value>
<Value name="9">
<Value>ManufacturerDR</Value>
</Value>
<Value name="10">
<Value>SynID</Value>
</Value>
<Value name="11">
<Value>BarCode</Value>
</Value>
<Value name="12">
<Value>PackageSize</Value>
</Value>
<Value name="13">
<Value>Volume</Value>
</Value>
<Value name="14">
<Value>VolUnit</Value>
</Value>
<Value name="15">
<Value>UnitDR</Value>
</Value>
<Value name="16">
<Value>PackUnit</Value>
</Value>
<Value name="17">
<Value>MinUseUnit</Value>
</Value>
<Value name="18">
<Value>BatchNo</Value>
</Value>
<Value name="19">
<Value>LicenseNo</Value>
</Value>
<Value name="20">
<Value>RegisterNo</Value>
</Value>
<Value name="21">
<Value>RegExpireDate</Value>
</Value>
<Value name="22">
<Value>MixQty</Value>
</Value>
<Value name="23">
<Value>MaxQty</Value>
</Value>
<Value name="24">
<Value>StandardQty</Value>
</Value>
<Value name="25">
<Value>WarnDays</Value>
</Value>
<Value name="26">
<Value>Remark</Value>
</Value>
<Value name="27">
<Value>Sequence</Value>
</Value>
<Value name="28">
<Value>Active</Value>
</Value>
<Value name="29">
<Value>StorageDays</Value>
</Value>
<Value name="30">
<Value>UnsealSaveDays</Value>
</Value>
<Value name="31">
<Value>UnsealWarnDays</Value>
</Value>
<Value name="32">
<Value>SelfMatch</Value>
</Value>
<Value name="33">
<Value>FilePath</Value>
</Value>
<Value name="34">
<Value>PositionDR</Value>
</Value>
<Value name="35">
<Value>DepartmentDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTRGReagentD</DataLocation>
<DefaultData>BTRGReagentDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTRGReagentD</IdLocation>
<IndexLocation>^dbo.BTRGReagentI</IndexLocation>
<StreamLocation>^dbo.BTRGReagentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
