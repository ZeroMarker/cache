/// 血液产品
Class dbo.BBBloodProduct Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_BloodProduct, StorageStrategy = Default ]
{

/// Foreign Key FKBBBPPackStatus created via DDL
ForeignKey FKBBBPPackStatus(StatusDR) References dbo.BBPackStatus(PKBBPACKSTATUS) [ SqlName = FK_BB_BP_PackStatus ];

/// Foreign Key FKBBBPorductBComponets created via DDL
ForeignKey FKBBBPorductBComponets(BloodComponentsDR) References dbo.BBBloodComponents(PKBBBLOODCOMPONENTS) [ SqlName = FK_BB_BPorduct_BComponets ];

/// Foreign Key FKBBBPorductBComponets created via DDL
ForeignKey FKBBBPorductReqProduct(ReqProductDR) References dbo.BBReqProduct(PKBBREQPRODUCT) [ SqlName = FK_BB_BPorduct_ReqProduct ];

/// Foreign Key FKBBBPorductHospital created via DDL
ForeignKey FKBBBPorductHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BB_BPorduct_Hospital ];

/// Foreign Key FKBBBPorductTransaction created via DDL
ForeignKey FKBBBPorductTransaction(TransactionDR) References dbo.BBTransaction(PKBBTRANSACTION) [ SqlName = FK_BB_BPorduct_Transaction ];

/// Foreign Key FKBBBPorductTransaction created via DDL
ForeignKey FKBBBloodClass(BloodClassDR) References dbo.BBBloodClass(PKBBBLOODCLASS) [ SqlName = FK_BB_BloodClass ];

/// Foreign Key FKBBBPorductBComponets created via DDL
ForeignKey FKBBBPorductBPCategory(BloodProductCategoryDR) References dbo.BBBloodProductCategory(PKBBBLOODPRODUCTCATEGORY) [ SqlName = FK_BB_BPorduct_BPCategory ];

Index IndexBloodComponents On BloodComponentsDR [ SqlName = Index_BloodComponents, Type = index ];

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSeqNum On (HospitalDR, SeqNum) [ SqlName = Index_SeqNum, Type = index ];

Index IndexSynonym On Synonym [ SqlName = Index_Synonym, Type = index ];

Index IndexReqProduct On ReqProductDR [ SqlName = Index_ReqProduct, Type = index ];

Index IndexBloodProductCategory On BloodProductCategoryDR [ SqlName = Index_BloodProductCategory, Type = index ];

/// DDL Primary Key Specification
Index PKBBBLOODPRODUCT On RowID [ PrimaryKey, SqlName = PK_BB_BLOODPRODUCT, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 4 ];

/// 英文名称  
Property EName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 5 ];

/// 英文缩写  
Property Synonym As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 6 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 保存时间  
Property NormalLife As %Library.Float [ SqlColumnNumber = 8 ];

/// 时间单位  
Property TimeUnit As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 9 ];

/// 滞留时间  
Property HoldHours As %Library.Float [ SqlColumnNumber = 10 ];

/// 血液成分  
Property BloodComponentsDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 11 ];

/// 是否匹配血型  {1:是,0:否}
Property IsMatchBloodGroup As %Library.Boolean [ SqlColumnNumber = 12 ];

/// 是否交叉配血  {1:是,0:否}
Property IsXMatchProduct As %Library.Boolean [ SqlColumnNumber = 13 ];

/// 是否自体血  {1:是,0:否}
Property IsAutologous As %Library.Boolean [ SqlColumnNumber = 14 ];

/// 血袋规格  
Property PackSize As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 15 ];

/// 计量单位  
Property Units As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 16 ];

/// 换算系数(ml)  
Property ScaleFactor As %Library.Float [ SqlColumnNumber = 17 ];

/// 是否在献血模块使用  {1:是,0:否}
Property IsDonorUse As %Library.Boolean [ SqlColumnNumber = 18 ];

/// 默认处理事件  
Property TransactionDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

/// 默认状态  
Property StatusDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

/// 特点  
Property Feature As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 21 ];

/// 是否冷冻  {1:是,0:否}
Property IsFrozen As %Library.Boolean [ SqlColumnNumber = 22 ];

/// 存储条件  
Property StorageCondition As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 23 ];

/// 激活  {1:是,0:否}
Property Active As %Library.Boolean [ SqlColumnNumber = 24 ];

/// 说明  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 25 ];

/// 序号  
Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 26 ];

/// 血量最小值  
Property MaxPackVolume As %Library.Float [ SqlColumnNumber = 27 ];

/// 血量最大值  
Property MinPackVolume As %Library.Float [ SqlColumnNumber = 28 ];

/// BloodClassDR  
Property BloodClassDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 29 ];

/// ISINSURANCE  {1:true,0:false}
Property ISINSURANCE As %Library.Boolean [ SqlColumnNumber = 30 ];

/// 申请血产品  
Property ReqProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 31 ];

/// TransHours  
Property TransHours As %Library.Float [ SqlColumnNumber = 32 ];

/// IsSpecial  {1:true,0:false}
Property IsSpecial As %Library.Boolean [ SqlColumnNumber = 33 ];

/// IsVerify  {1:true,0:false}
Property IsVerify As %Library.Boolean [ SqlColumnNumber = 34 ];

/// 所属产品类别  
Property BloodProductCategoryDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 35 ];

/// 允许规格
Property PackageSizes As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 36 ];

/// 是否次测交叉配血
Property IsMinorXMatch As %Library.Boolean [ SqlColumnNumber = 37 ];

Storage Default
{
<Data name="BBBloodProductDefaultData">
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
<Value>Synonym</Value>
</Value>
<Value name="6">
<Value>HospitalDR</Value>
</Value>
<Value name="7">
<Value>NormalLife</Value>
</Value>
<Value name="8">
<Value>TimeUnit</Value>
</Value>
<Value name="9">
<Value>HoldHours</Value>
</Value>
<Value name="10">
<Value>BloodComponentsDR</Value>
</Value>
<Value name="11">
<Value>IsMatchBloodGroup</Value>
</Value>
<Value name="12">
<Value>IsXMatchProduct</Value>
</Value>
<Value name="13">
<Value>IsAutologous</Value>
</Value>
<Value name="14">
<Value>PackSize</Value>
</Value>
<Value name="15">
<Value>Units</Value>
</Value>
<Value name="16">
<Value>ScaleFactor</Value>
</Value>
<Value name="17">
<Value>IsDonorUse</Value>
</Value>
<Value name="18">
<Value>TransactionDR</Value>
</Value>
<Value name="19">
<Value>StatusDR</Value>
</Value>
<Value name="20">
<Value>Feature</Value>
</Value>
<Value name="21">
<Value>IsFrozen</Value>
</Value>
<Value name="22">
<Value>StorageCondition</Value>
</Value>
<Value name="23">
<Value>Active</Value>
</Value>
<Value name="24">
<Value>Remark</Value>
</Value>
<Value name="25">
<Value>SeqNum</Value>
</Value>
<Value name="26">
<Value>MaxPackVolume</Value>
</Value>
<Value name="27">
<Value>MinPackVolume</Value>
</Value>
<Value name="28">
<Value>BloodClassDR</Value>
</Value>
<Value name="29">
<Value>ISINSURANCE</Value>
</Value>
<Value name="30">
<Value>ReqProductDR</Value>
</Value>
<Value name="31">
<Value>TransHours</Value>
</Value>
<Value name="32">
<Value>IsSpecial</Value>
</Value>
<Value name="33">
<Value>IsVerify</Value>
</Value>
<Value name="34">
<Value>BloodProductCategoryDR</Value>
</Value>
<Value name="35">
<Value>PackageSizes</Value>
</Value>
<Value name="36">
<Value>IsMinorXMatch</Value>
</Value>
</Data>
<DataLocation>^dbo.BBBloodProductD</DataLocation>
<DefaultData>BBBloodProductDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BBBloodProductD</IdLocation>
<IndexLocation>^dbo.BBBloodProductI</IndexLocation>
<StreamLocation>^dbo.BBBloodProductS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
