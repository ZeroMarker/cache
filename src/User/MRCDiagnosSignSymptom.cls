/// MRC Diag Sign/Symptom(1075)
Class User.MRCDiagnosSignSymptom Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MRC_DiagnosSignSymptom, StorageStrategy = SQLStorage ]
{

/// Des Ref ARCOS
Property DSYMARCOSDR As ARCOrdSets [ SqlColumnNumber = 5, SqlFieldName = DSYM_ARCOS_DR ];

/// Active InActive
Property DSYMActiveInActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = DSYM_ActiveInActive ];

/// Des Ref to CTLOC
Property DSYMCTLOCDR As CTLoc [ SqlColumnNumber = 4, SqlFieldName = DSYM_CTLOC_DR ];

/// Code
Property DSYMCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = DSYM_Code ];

/// Date From
Property DSYMDateFrom As %Date [ SqlColumnNumber = 6, SqlFieldName = DSYM_DateFrom ];

/// Date To
Property DSYMDateTo As %Date [ SqlColumnNumber = 7, SqlFieldName = DSYM_DateTo ];

/// Description
Property DSYMDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = DSYM_Desc ];

Index DSYMCodeUnqIdx1 On DSYMCode [ Unique ];

Parameter EXTENTSIZE = 3;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRCDiagnosSignSymptom).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCDiagnosSignSymptom","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRCDiagnosSignSymptom).OnTrigger($g(%d(1)))             
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCDiagnosSignSymptom","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRCDiagnosSignSymptom).OnTrigger($g(%d(1))) 
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCDiagnosSignSymptom","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRCDiagnosSignSymptom).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCDiagnosSignSymptom","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRCDiagnosSignSymptom).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCDiagnosSignSymptom","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>3</ExtentSize>
<Property name="DSYMARCOSDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="DSYMActiveInActive">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DSYMCTLOCDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="DSYMCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="DSYMDateFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="DSYMDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="DSYMDesc">
<Selectivity>33.3333%</Selectivity>
</Property>
<SqlIdExpression>$i(^MRC("DSYM",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DSYM_ARCOS_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DSYM_ActiveInActive">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DSYM_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DSYM_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DSYM_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DSYM_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DSYM_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^MRC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DSYM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DSYM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DSYM_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DSYM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DSYM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({DSYM_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DSYM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DSYM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DSYM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({DSYM_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DSYM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DSYM_RowId</SqlRowIdName>
<StreamLocation>^User.MRCDiagnosSignSymptomS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
