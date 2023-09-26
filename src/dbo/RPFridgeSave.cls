/// 菌株存储
Class dbo.RPFridgeSave Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_FridgeSave ]
{

Index IndexMaster On (BLLType, AddDate, BLLDR) [ SqlName = Index_Master, Type = index ];

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexUse On (BLLType, FridgeStorageDR, Code) [ SqlName = Index_Use, Type = index ];

Index IndexFridgeStorageDR On (FridgeStorageDR, StorageStructDR, RowNum, ColNum) [ SqlName = Index_FridgeStorageDR, Type = index, Unique ];

Index IndexBLL On (BLLType, BLLDR) [ SqlName = Index_BLL, Type = index ];

Index IndexBLLMianDR On (BLLType, BLLMianDR) [ SqlName = Index_BLLMianDR, Type = index ];

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

Index IndexWorkGroup On (WorkGroupDR, AddDate) [ SqlName = Index_WorkGroup, Type = index ];

Index IndexRegNo On (RegNo, AddDate) [ SqlName = Index_RegNo, Type = index ];

/// DDL Primary Key Specification
Index PKRPFRIDGESAVE On RowID [ PrimaryKey, SqlName = PK_RP_FRIDGESAVE, Type = index, Unique ];

/// Foreign Key FKFridgeStorageDR created via DDL
ForeignKey FKFridgeStorageDR(FridgeStorageDR) References dbo.BTFridgeStorage(PKBTFRIDGESTORAGE) [ SqlName = FK_FridgeStorageDR ];

/// Foreign Key FKStorageStructDR created via DDL
ForeignKey FKStorageStructDR(StorageStructDR) References dbo.BTStorageStruct(PKBTSTORAGESTRUCT) [ SqlName = FK_StorageStructDR ];

/// Foreign Key FKAddUser created via DDL
ForeignKey FKAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_AddUser ];

/// Foreign Key FKUpdateUserDR created via DDL
ForeignKey FKUpdateUserDR(UpdateUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_UpdateUserDR ];

/// Foreign Key FKWorkGroupDR created via DDL
ForeignKey FKWorkGroupDR(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_WorkGroupDR ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "EXACT", MAXLEN = 150) [ SqlColumnNumber = 3 ];

/// 业务类型  {MIC:菌株存储}
Property BLLType As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ Required, SqlColumnNumber = 4 ];

/// 业务主键  
Property BLLDR As %Library.String(COLLATION = "EXACT", MAXLEN = 150) [ Required, SqlColumnNumber = 5 ];

/// 冰箱存储  
Property FridgeStorageDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 列  
Property ColNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 行  
Property RowNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

/// 添加日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 添加时间  
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 添加人  
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 更新日期  
Property UpdateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 更新时间  
Property UpdateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 更新人  
Property UpdateUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 说明  
Property Remark As %Library.String(COLLATION = "EXACT", MAXLEN = 400) [ SqlColumnNumber = 15 ];

/// 存储结构  
Property StorageStructDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 16 ];

/// 业务主ID  
Property BLLMianDR As %Library.String(COLLATION = "EXACT", MAXLEN = 150) [ Required, SqlColumnNumber = 17 ];

/// 业务子ID  
Property BLLChildDR As %Library.String(COLLATION = "EXACT", MAXLEN = 150) [ SqlColumnNumber = 18 ];

/// 是否外来菌  {1:true,0:false}
Property IsExternalOrg As %Library.Boolean [ SqlColumnNumber = 19 ];

/// 入库原因
Property Reason As %Library.String(COLLATION = "EXACT", MAXLEN = 500) [ SqlColumnNumber = 20 ];

/// 工作组  
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

/// 登记号  
Property RegNo As %Library.String(COLLATION = "EXACT", MAXLEN = 40) [ SqlColumnNumber = 22 ];

Storage Default
{
<Data name="RPFridgeSaveDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>BLLType</Value>
</Value>
<Value name="4">
<Value>BLLDR</Value>
</Value>
<Value name="5">
<Value>FridgeStorageDR</Value>
</Value>
<Value name="6">
<Value>ColNum</Value>
</Value>
<Value name="7">
<Value>RowNum</Value>
</Value>
<Value name="8">
<Value>AddDate</Value>
</Value>
<Value name="9">
<Value>AddTime</Value>
</Value>
<Value name="10">
<Value>AddUserDR</Value>
</Value>
<Value name="11">
<Value>UpdateDate</Value>
</Value>
<Value name="12">
<Value>UpdateTime</Value>
</Value>
<Value name="13">
<Value>UpdateUserDR</Value>
</Value>
<Value name="14">
<Value>Remark</Value>
</Value>
<Value name="15">
<Value>StorageStructDR</Value>
</Value>
<Value name="16">
<Value>BLLMianDR</Value>
</Value>
<Value name="17">
<Value>BLLChildDR</Value>
</Value>
<Value name="18">
<Value>IsExternalOrg</Value>
</Value>
<Value name="19">
<Value>Reason</Value>
</Value>
<Value name="20">
<Value>WorkGroupDR</Value>
</Value>
<Value name="21">
<Value>RegNo</Value>
</Value>
</Data>
<DataLocation>^dbo.RPFridgeSaveD</DataLocation>
<DefaultData>RPFridgeSaveDefaultData</DefaultData>
<IdLocation>^dbo.RPFridgeSaveD</IdLocation>
<IndexLocation>^dbo.RPFridgeSaveI</IndexLocation>
<StreamLocation>^dbo.RPFridgeSaveS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
