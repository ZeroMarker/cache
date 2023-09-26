/// FDIU Diagnosis(2239)
Class User.PACFdiuDiagnosis Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_FdiuDiagnosis, StorageStrategy = SQLStorage ]
{

/// active
Property FDIUDIAGActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = FDIUDIAG_Active ];

/// Code
Property FDIUDIAGCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = FDIUDIAG_Code ];

/// Date From
Property FDIUDIAGDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = FDIUDIAG_DateFrom ];

/// Date To
Property FDIUDIAGDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = FDIUDIAG_DateTo ];

/// Description
Property FDIUDIAGDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = FDIUDIAG_Desc ];

/// National code
Property FDIUDIAGNationalCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = FDIUDIAG_NationalCode ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACFdiuDiagnosis).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACFdiuDiagnosis","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACFdiuDiagnosis).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACFdiuDiagnosis","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACFdiuDiagnosis).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACFdiuDiagnosis","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACFdiuDiagnosis).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACFdiuDiagnosis","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACFdiuDiagnosis).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACFdiuDiagnosis","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="FDIUDIAGActive">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="FDIUDIAGCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="FDIUDIAGDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="FDIUDIAGDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="FDIUDIAGDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="FDIUDIAGNationalCode">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("FDIUDIAG",0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="FDIUDIAG_Active">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="FDIUDIAG_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FDIUDIAG_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="FDIUDIAG_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="FDIUDIAG_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="FDIUDIAG_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>FDIUDIAG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"FDIUDIAG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{FDIUDIAG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>FDIUDIAG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"FDIUDIAG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({FDIUDIAG_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{FDIUDIAG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>FDIUDIAG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"FDIUDIAG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({FDIUDIAG_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{FDIUDIAG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>FDIUDIAG_RowId</SqlRowIdName>
<StreamLocation>^User.PACFdiuDiagnosisS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
