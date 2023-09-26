/// dbo.RPFridgeRecord
Class dbo.RPFridgeRecord Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_FridgeRecord ]
{

Index IndexMaster On (BLLType, BLLDR, SeqNo) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexInDate On (InDate, WorkGroupDR) [ SqlName = Index_InDate, Type = index ];

Index IndexOutDate On (OutDate, WorkGroupDR) [ SqlName = Index_OutDate, Type = index ];

Index IndexDestroyDate On (DestroyDate, WorkGroupDR) [ SqlName = Index_DestroyDate, Type = index ];

Index IndexInUser On (InUserDR, InDate) [ SqlName = Index_InUser, Type = index ];

Index IndexOutUser On (OutUserDR, OutDate) [ SqlName = Index_OutUser, Type = index ];

Index IndexDestroyUser On (DestroyUserDR, DestroyDate) [ SqlName = Index_DestroyUser, Type = index ];

Index IndexBLLMianDR On (BLLMianDR, BLLChildDR, SeqNo) [ SqlName = Index_BLLMianDR, Type = index ];

/// DDL Primary Key Specification
Index RPFRIDGERECORD On RowID [ PrimaryKey, SqlName = PK_RP_FRIDGERECORD, Type = index, Unique ];

/// Foreign Key FKStorageStructDR created via DDL
ForeignKey FKStorageStructDR(StorageStructDR) References dbo.BTStorageStruct(PKBTSTORAGESTRUCT) [ SqlName = FK_StorageStructDR ];

/// Foreign Key FKAddUser created via DDL
ForeignKey FKInUser(InUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_InUser ];

/// Foreign Key FKOutUser created via DDL
ForeignKey FKOutUser(OutUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_OutUser ];

/// Foreign Key FKDestroyUser created via DDL
ForeignKey FKDestroyUser(DestroyUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_DestroyUser ];

/// Foreign Key FKWorkGroupDR created via DDL
ForeignKey FKWorkGroupDR(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_WorkGroupDR ];

/// Foreign Key FKFridgeStorageDR created via DDL
ForeignKey FKFridgeStorageDR(FridgeStorageDR) References dbo.BTFridgeStorage(PKBTFRIDGESTORAGE) [ SqlName = FK_FridgeStorageDR ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 业务类型  {MIC:菌株存储}
Property BLLType As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ Required, SqlColumnNumber = 3 ];

/// 业务主键  {内部菌：报告主键-细菌主键；外来菌：ExternalOrganismDR}
Property BLLDR As %Library.String(COLLATION = "EXACT", MAXLEN = 150) [ Required, SqlColumnNumber = 4 ];

/// 存储次数  
Property SeqNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 存储结构  
Property StorageStructDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

// 冰箱存储  

Property FridgeStorageDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 列  
Property ColNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

/// 行  
Property RowNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 9 ];

/// 是否外来菌  {1:true,0:false}
Property IsExternalOrg As %Library.Boolean [ SqlColumnNumber = 10 ];

/// 入库日期  
Property InDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 入库时间  
Property InTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 入库人  
Property InUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 入库说明  
Property InRemark As %Library.String(COLLATION = "EXACT", MAXLEN = 400) [ SqlColumnNumber = 14 ];

/// 出库日期  
Property OutDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

/// 出库时间  
Property OutTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

/// 出库人  
Property OutUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

/// 出库说明  
Property OutRemark As %Library.String(COLLATION = "EXACT", MAXLEN = 400) [ SqlColumnNumber = 18 ];

/// 销毁日期  
Property DestroyDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

/// 销毁时间  
Property DestroyTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

/// 销毁人  
Property DestroyUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

/// 销毁说明  
Property DestroyRemark As %Library.String(COLLATION = "EXACT", MAXLEN = 400) [ SqlColumnNumber = 22 ];

/// 报告主键  VisitNumberReportDR
Property BLLMianDR As %Library.String(COLLATION = "EXACT", MAXLEN = 150) [ Required, SqlColumnNumber = 23 ];

/// 存项目主键 TestCodeDR
Property BLLChildDR As %Library.String(COLLATION = "EXACT", MAXLEN = 150) [ SqlColumnNumber = 24 ];

/// 工作组  
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 25 ];

/// 登记号  
Property RegNo As %Library.String(COLLATION = "EXACT", MAXLEN = 40) [ SqlColumnNumber = 26 ];

Storage Default
{
<Data name="RPFridgeRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BLLType</Value>
</Value>
<Value name="3">
<Value>BLLDR</Value>
</Value>
<Value name="4">
<Value>SeqNo</Value>
</Value>
<Value name="5">
<Value>StorageStructDR</Value>
</Value>
<Value name="6">
<Value>FridgeStorageDR</Value>
</Value>
<Value name="7">
<Value>ColNum</Value>
</Value>
<Value name="8">
<Value>RowNum</Value>
</Value>
<Value name="9">
<Value>IsExternalOrg</Value>
</Value>
<Value name="10">
<Value>InDate</Value>
</Value>
<Value name="11">
<Value>InTime</Value>
</Value>
<Value name="12">
<Value>InUserDR</Value>
</Value>
<Value name="13">
<Value>InRemark</Value>
</Value>
<Value name="14">
<Value>OutDate</Value>
</Value>
<Value name="15">
<Value>OutTime</Value>
</Value>
<Value name="16">
<Value>OutUserDR</Value>
</Value>
<Value name="17">
<Value>OutRemark</Value>
</Value>
<Value name="18">
<Value>DestroyDate</Value>
</Value>
<Value name="19">
<Value>DestroyTime</Value>
</Value>
<Value name="20">
<Value>DestroyUserDR</Value>
</Value>
<Value name="21">
<Value>DestroyRemark</Value>
</Value>
<Value name="22">
<Value>BLLMianDR</Value>
</Value>
<Value name="23">
<Value>BLLChildDR</Value>
</Value>
<Value name="24">
<Value>WorkGroupDR</Value>
</Value>
<Value name="25">
<Value>RegNo</Value>
</Value>
</Data>
<DataLocation>^dbo.RPFridgeRecordD</DataLocation>
<DefaultData>RPFridgeRecordDefaultData</DefaultData>
<IdLocation>^dbo.RPFridgeRecordD</IdLocation>
<IndexLocation>^dbo.RPFridgeRecordI</IndexLocation>
<StreamLocation>^dbo.RPFridgeRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
