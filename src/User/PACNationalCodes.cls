/// NationalCodes(2692)
Class User.PACNationalCodes Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_NationalCodes, StorageStrategy = SQLStorage ]
{

/// DateFrom
Property NATCDateFrom As %Date [ SqlColumnNumber = 2, SqlFieldName = NATC_DateFrom ];

/// DateTo
Property NATCDateTo As %Date [ SqlColumnNumber = 3, SqlFieldName = NATC_DateTo ];

/// Des Ref Table
Property NATCTableDR As SSTable [ SqlColumnNumber = 4, SqlFieldName = NATC_Table_DR ];

/// TableName
Property NATCTableName As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = NATC_TableName ];

/// Des Ref TableField
Property NATCTableFieldDR As SSTableField [ SqlColumnNumber = 6, SqlFieldName = NATC_TableField_DR ];

/// FieldName
Property NATCFieldName As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = NATC_FieldName ];

/// ActualValue
Property NATCActualValue As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = NATC_ActualValue ];

/// MappedValue
Property NATCMappedValue As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = NATC_MappedValue ];

/// Des Ref ReportingType
Property NATCReportingTypeDR As PACReportingType [ SqlColumnNumber = 10, SqlFieldName = NATC_ReportingType_DR ];

/// No Display On WEB
Property NATCNoDisplayOnWEB As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = NATC_NoDisplayOnWEB ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PACNationalCodes).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACNationalCodes","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PACNationalCodes).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACNationalCodes","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PACNationalCodes).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACNationalCodes","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PACNationalCodes).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACNationalCodes","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PACNationalCodes).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACNationalCodes","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACNationalCodes","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("NATC",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="NATC_ActualValue">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="NATC_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="NATC_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="NATC_FieldName">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="NATC_MappedValue">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="NATC_NoDisplayOnWEB">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="NATC_ReportingType_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="NATC_TableField_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="NATC_TableName">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="NATC_Table_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>NATC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"NATC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{NATC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTable">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>NATC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"NATC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Table"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({NATC_TableName})</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({NATC_FieldName})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{NATC_ReportingType_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{NATC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>NATC_RowId</SqlRowIdName>
<StreamLocation>^User.PACNationalCodesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
