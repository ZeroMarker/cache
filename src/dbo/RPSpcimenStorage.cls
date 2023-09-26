/// RPSpcimenStorage
Class dbo.RPSpcimenStorage Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_SpcimenStorage, StorageStrategy = Default ]
{

/// Foreign Key FKSpcimenStorage created via DDL
ForeignKey FKSpcimenStorage(VisitNumberDR) References dbo.RPVisitNumber(PKRPVISITNUMBER) [ SqlName = FK_SpcimenStorage ];

/// Foreign Key FKSpcimenStorageRack created via DDL
ForeignKey FKSpcimenStorageRack(SpecimenRackDR) References dbo.BTSpecimenRack(PKBTSPECIMENRACK) [ SqlName = FK_SpcimenStorageRack ];

/// Foreign Key FKRPSpcimenStorageWorkGroup created via DDL
ForeignKey FKRPSpcimenStorageWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_RPSpcimenStorageWorkGroup ];

Index IndexRackPosition On (SpecimenRackDR, PositionNo) [ SqlName = Index_RackPosition, Type = index, Unique ];

Index IndexVisitNumber On VisitNumberDR [ SqlName = Index_VisitNumber, Type = index ];

Index IndexRegNo On RegNo [ SqlName = Index_RegNo, Type = index ];

Index IndexWorkGroup On WorkGroupDR [ SqlName = Index_WorkGroup, Type = index ];

/// DDL Primary Key Specification
Index PKRPSPCIMENSTORAGE On RowID [ PrimaryKey, SqlName = PK_RP_SPCIMENSTORAGE, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 存储架  
Property SpecimenRackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 位置号  
Property PositionNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 标本号  
Property VisitNumberDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 存储类型  
Property StorageType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 6 ];

/// 增加天数  
Property AddDays As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 登记号  
Property RegNo As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 8 ];

/// 工作组      
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="RPSpcimenStorageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SpecimenRackDR</Value>
</Value>
<Value name="3">
<Value>PositionNo</Value>
</Value>
<Value name="4">
<Value>VisitNumberDR</Value>
</Value>
<Value name="5">
<Value>StorageType</Value>
</Value>
<Value name="6">
<Value>AddDays</Value>
</Value>
<Value name="7">
<Value>RegNo</Value>
</Value>
<Value name="8">
<Value>WorkGroupDR</Value>
</Value>
</Data>
<DataLocation>^dbo.RPSpcimenStorageD</DataLocation>
<DefaultData>RPSpcimenStorageDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RPSpcimenStorageD</IdLocation>
<IndexLocation>^dbo.RPSpcimenStorageI</IndexLocation>
<StreamLocation>^dbo.RPSpcimenStorageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
