/// CT Care Provider Type    (CTCPT,44)
Class User.CTCarPrvTp Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_CarPrvTp, StorageStrategy = SQLStorage ]
{

/// Care Provider Type Code
Property CTCPTCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = CTCPT_Code ];

/// Care Provider Type Description
Property CTCPTDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = CTCPT_Desc ];

/// Active Flag
Property CTCPTActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", Required, SqlColumnNumber = 4, SqlFieldName = CTCPT_ActiveFlag ];

/// Internal Type
Property CTCPTInternalType As %String(DISPLAYLIST = ",NURSE,DOCTOR,Technician,Pharmacist,Other", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",NURSE,DOCTOR,Technician,Pharmacist,Other") [ SqlColumnNumber = 5, SqlFieldName = CTCPT_InternalType ];

/// Date From
Property CTCPTDateFrom As %Date [ SqlColumnNumber = 6, SqlFieldName = CTCPT_DateFrom ];

/// Date To
Property CTCPTDateTo As %Date [ SqlColumnNumber = 7, SqlFieldName = CTCPT_DateTo ];

/// Des Ref ARCIM
Property CTCPTARCIMDR As ARCItmMast [ SqlColumnNumber = 8, SqlFieldName = CTCPT_ARCIM_DR ];

/// the new field Rotary Flag
Property CTCPTRotaryFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = CTCPT_RotaryFlag ];

/// the new field Study Flag
Property CTCPTStudyFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = CTCPT_StudyFlag ];

Index CTCPTCodeUnqIdx1 On CTCPTCode [ Unique ];

Index CTCPTDescUnqIdx2 On CTCPTDesc [ Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTCarPrvTp).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCarPrvTp","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTCarPrvTp).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCarPrvTp","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTCarPrvTp).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCarPrvTp","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTCarPrvTp).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCarPrvTp","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTCarPrvTp).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCarPrvTp","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCarPrvTp","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>19</ExtentSize>
<Property name="CTCPTARCIMDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CTCPTActiveFlag">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="CTCPTCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="CTCPTDateFrom">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="CTCPTDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CTCPTDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="CTCPTInternalType">
<Selectivity>33.3333%</Selectivity>
</Property>
<SqlIdExpression>$i(^CT("CPT",0))</SqlIdExpression>
<SQLMap name="DataMasterCTCPT">
<Data name="CTCPT_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CTCPT_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CTCPT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CTCPT_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CTCPT_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CTCPT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CTCPT_InternalType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CTCPT_RotaryFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CTCPT_StudyFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CTCPT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"CPT"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CTCPT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTCPT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"CPT"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({CTCPT_Code})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CTCPT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTCPT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"CPT"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({CTCPT_Desc})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CTCPT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CTCPT_RowId</SqlRowIdName>
<StreamLocation>^User.CTCarPrvTpS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
