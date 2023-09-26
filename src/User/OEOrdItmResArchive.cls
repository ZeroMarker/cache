/// OE Ord Item Result Archive(1461)
Class User.OEOrdItmResArchive Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OE_OrdItmResArchive, StorageStrategy = SQLStorage ]
{

Relationship ChildOEOrdItmResArchiveFile As OEOrdItmResArchiveFile [ Cardinality = children, Inverse = OEARFParRef ];

/// Archive Status
Property OEARCArchiveStatus As %String(DISPLAYLIST = ",Initialised,Images,CDROM,Confirmed Complete", MAXLEN = 18, TRUNCATE = 1, VALUELIST = ",I,M,C,X") [ SqlColumnNumber = 2, SqlFieldName = OEARC_ArchiveStatus ];

/// Date CDROM Confirmed
Property OEARCCDROMConfirmedDate As %Date [ SqlColumnNumber = 7, SqlFieldName = OEARC_CDROMConfirmedDate ];

/// Time CDROM Confirmed
Property OEARCCDROMConfirmedTime As %Time [ SqlColumnNumber = 8, SqlFieldName = OEARC_CDROMConfirmedTime ];

/// Date CDROM Created
Property OEARCCDROMCreatedDate As %Date [ SqlColumnNumber = 5, SqlFieldName = OEARC_CDROMCreatedDate ];

/// Time CDROM Created
Property OEARCCDROMCreatedTime As %Time [ SqlColumnNumber = 6, SqlFieldName = OEARC_CDROMCreatedTime ];

/// Comment
Property OEARCComment As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = OEARC_Comment ];

/// Date Archive Last Initialised
Property OEARCCreatedDate As %Date [ SqlColumnNumber = 3, SqlFieldName = OEARC_CreatedDate ];

/// Time Archive Last Initialised
Property OEARCCreatedTime As %Time [ SqlColumnNumber = 4, SqlFieldName = OEARC_CreatedTime ];

/// OE_OrdItmResArchive Row ID
Property OEARCRowId As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ Required, SqlFieldName = OEARC_RowId ];

/// Archive Size(bytes)
Property OEARCSize As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = OEARC_Size ];

Index RowIDBasedIDKeyIndex On OEARCRowId [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OEOrdItmResArchive).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEOrdItmResArchive","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OEOrdItmResArchive).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEOrdItmResArchive","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OEOrdItmResArchive).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEOrdItmResArchive","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OEOrdItmResArchive).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEOrdItmResArchive","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OEOrdItmResArchive).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEOrdItmResArchive","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="OEARCArchiveStatus">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="OEARCCDROMConfirmedDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="OEARCCDROMConfirmedTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="OEARCCDROMCreatedDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="OEARCCDROMCreatedTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="OEARCComment">
<Selectivity>1</Selectivity>
</Property>
<Property name="OEARCCreatedDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="OEARCCreatedTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="OEARCRowId">
<Selectivity>1</Selectivity>
</Property>
<Property name="OEARCSize">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="OEARC_ArchiveStatus">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OEARC_CDROMConfirmedDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OEARC_CDROMConfirmedTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OEARC_CDROMCreatedDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OEARC_CDROMCreatedTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OEARC_Comment">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="OEARC_CreatedDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OEARC_CreatedTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OEARC_Size">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^OEARC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OEARC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{OEARC_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>OEARC_RowId</SqlRowIdName>
<StreamLocation>^User.OEOrdItmResArchiveS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
