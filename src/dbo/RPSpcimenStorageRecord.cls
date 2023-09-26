/// RPSpcimenStorageRecord
Class dbo.RPSpcimenStorageRecord Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_SpcimenStorageRecord, StorageStrategy = Default ]
{

/// Foreign Key FKSpcimenStorageRecordOldRack created via DDL
ForeignKey FKSpcimenStorageRecordOldRack(OldSpecimenRackDR) References dbo.BTSpecimenRack(PKBTSPECIMENRACK) [ SqlName = FK_SpcimenStorageRecordOldRack ];

/// Foreign Key FKSpcimenStorageRecordRack created via DDL
ForeignKey FKSpcimenStorageRecordRack(SpecimenRackDR) References dbo.BTSpecimenRack(PKBTSPECIMENRACK) [ SqlName = FK_SpcimenStorageRecordRack ];

/// Foreign Key FKSpcimenStorageRecordUser created via DDL
ForeignKey FKSpcimenStorageRecordUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_SpcimenStorageRecordUser ];

/// Foreign Key FKSpcimenStorageRecordVisitNumber created via DDL
ForeignKey FKSpcimenStorageRecordVisitNumber(VisitNumberDR) References dbo.RPVisitNumber(PKRPVISITNUMBER) [ SqlName = FK_SpcimenStorageRecordVisitNumber ];

/// Foreign Key FKSpcimenStorageRecordWorkGroup created via DDL
ForeignKey FKSpcimenStorageRecordWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_SpcimenStorageRecordWorkGroup ];

Index IndexMaster On (VisitNumberDR, AddDate, AddTime) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexPosition On (SpecimenRackDR, PositionNo, AddTime, AddDate) [ SqlName = Index_Position, Type = index ];

Index IndexUser On (AddUserDR, AddDate, AddTime) [ SqlName = Index_User, Type = index ];

Index IndexRegNo On (RegNo, AddDate) [ SqlName = Index_RegNo, Type = index ];

Index IndexWorkGroup On (WorkGroupDR, AddDate) [ SqlName = Index_WorkGroup, Type = index ];

/// DDL Primary Key Specification
Index PKRPSPCIMENSTORAGERECORD On RowID [ PrimaryKey, SqlName = PK_RP_SPCIMENSTORAGERECORD, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 标本号  
Property VisitNumberDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 时间  
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 存储架  
Property SpecimenRackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 位置号  
Property PositionNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 存储类型  
Property StorageType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 8 ];

/// 操作类型  
Property OperateType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 9 ];

/// 用户  
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 转移前存储架  
Property OldSpecimenRackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 转移前位置号  
Property OldPositionNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 转移前位置号  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 13 ];

/// 登记号  
Property RegNo As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 14 ];

/// 工作组      
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Storage Default
{
<Data name="RPSpcimenStorageRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberDR</Value>
</Value>
<Value name="3">
<Value>AddDate</Value>
</Value>
<Value name="4">
<Value>AddTime</Value>
</Value>
<Value name="5">
<Value>SpecimenRackDR</Value>
</Value>
<Value name="6">
<Value>PositionNo</Value>
</Value>
<Value name="7">
<Value>StorageType</Value>
</Value>
<Value name="8">
<Value>OperateType</Value>
</Value>
<Value name="9">
<Value>AddUserDR</Value>
</Value>
<Value name="10">
<Value>OldSpecimenRackDR</Value>
</Value>
<Value name="11">
<Value>OldPositionNo</Value>
</Value>
<Value name="12">
<Value>Remark</Value>
</Value>
<Value name="13">
<Value>RegNo</Value>
</Value>
<Value name="14">
<Value>WorkGroupDR</Value>
</Value>
</Data>
<DataLocation>^dbo.RPSpcimenStorageRecordD</DataLocation>
<DefaultData>RPSpcimenStorageRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RPSpcimenStorageRecordD</IdLocation>
<IndexLocation>^dbo.RPSpcimenStorageRecordI</IndexLocation>
<StreamLocation>^dbo.RPSpcimenStorageRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
