/// RPFridgeSaveLog
Class dbo.RPFridgeSaveLog Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_FridgeSaveLog ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index ];

Index IndexFridgeStorageDR On (FridgeStorageDR, StorageStructDR, RowNum, ColNum) [ SqlName = Index_FridgeStorageDR, Type = index ];

Index IndexBLL On (BLLType, BLLDR) [ SqlName = Index_BLL, Type = index ];

Index IndexBLLMianDR On (BLLType, BLLMianDR) [ SqlName = Index_BLLMianDR, Type = index ];

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

/// Foreign Key FKWorkGroupDR created via DDL
ForeignKey FKWorkGroupDR(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_WorkGroupDR ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 位置  
Property Code As %Library.String(COLLATION = "EXACT", MAXLEN = 150) [ SqlColumnNumber = 3 ];

/// 业务类型  {MIC:菌株存储}
Property BLLType As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ Required, SqlColumnNumber = 4 ];

/// 业务主键  
Property BLLDR As %Library.String(COLLATION = "EXACT", MAXLEN = 150) [ Required, SqlColumnNumber = 5 ];

/// 冰箱架子  
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

/// 说明  
Property Remark As %Library.String(COLLATION = "EXACT", MAXLEN = 400) [ SqlColumnNumber = 12 ];

/// 存储结构  
Property StorageStructDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 13 ];

/// 主ID  
Property BLLMianDR As %Library.String(COLLATION = "EXACT", MAXLEN = 150) [ Required, SqlColumnNumber = 14 ];

/// 存项目主键     
Property BLLChildDR As %Library.String(COLLATION = "EXACT", MAXLEN = 150) [ SqlColumnNumber = 15 ];

/// 操作  
Property Oper As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ Required, SqlColumnNumber = 16 ];

/// 是否是外来菌       
Property IsExternalOrg As %Library.Boolean [ SqlColumnNumber = 17 ];

/// 入库原因
Property Reason As %Library.String(COLLATION = "EXACT", MAXLEN = 500) [ SqlColumnNumber = 18 ];

/// 工作组  
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

/// 登记号  
Property RegNo As %Library.String(COLLATION = "EXACT", MAXLEN = 40) [ SqlColumnNumber = 20 ];

Storage Default
{
<Data name="RPFridgeSaveLogDefaultData">
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
<Value>Remark</Value>
</Value>
<Value name="12">
<Value>StorageStructDR</Value>
</Value>
<Value name="13">
<Value>BLLMianDR</Value>
</Value>
<Value name="14">
<Value>BLLChildDR</Value>
</Value>
<Value name="15">
<Value>Oper</Value>
</Value>
<Value name="16">
<Value>IsExternalOrg</Value>
</Value>
<Value name="17">
<Value>Reason</Value>
</Value>
<Value name="18">
<Value>WorkGroupDR</Value>
</Value>
<Value name="19">
<Value>RegNo</Value>
</Value>
</Data>
<DataLocation>^dbo.RPFridgeSaveLogD</DataLocation>
<DefaultData>RPFridgeSaveLogDefaultData</DefaultData>
<IdLocation>^dbo.RPFridgeSaveLogD</IdLocation>
<IndexLocation>^dbo.RPFridgeSaveLogI</IndexLocation>
<StreamLocation>^dbo.RPFridgeSaveLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
