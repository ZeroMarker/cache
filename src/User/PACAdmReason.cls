/// PAC Admission Reason(1467)
Class User.PACAdmReason Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_AdmReason, StorageStrategy = SQLStorage ]
{

Relationship ChildPACAdmReasonDet As PACAdmReasonDet [ Cardinality = children, Inverse = DETParRef ];

/// Code
Property REACode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = REA_Code ];

/// Description
Property READesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = REA_Desc ];

/// Date From
Property READateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = REA_DateFrom ];

/// Date To
Property READateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = REA_DateTo ];

/// National Code
Property REANationalCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = REA_NationalCode ];

/// Age From
Property REAAgeFrom As %Float [ SqlColumnNumber = 7, SqlFieldName = REA_AgeFrom ];

/// Age To
Property REAAgeTo As %Float [ SqlColumnNumber = 8, SqlFieldName = REA_AgeTo ];

/// Des Ref InPatAdm
Property REAInPatAdmDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = REA_InPatAdm_DR ];

/// AdmSource
Property REAAdmSource As %String(COLLATION = "Exact", MAXLEN = 600, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = REA_AdmSource ];

/// Qualif Status
Property REAQualifStatus As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = REA_QualifStatus ];

/// CareType
Property REACareType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = REA_CareType ];

/// EpisSubType
Property REAEpisSubType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = REA_EpisSubType ];

/// AgeType
Property REAAgeType As %String(DISPLAYLIST = ",Month,Day,Year", MAXLEN = 5, TRUNCATE = 1, VALUELIST = ",M,D,Y") [ SqlColumnNumber = 14, SqlFieldName = REA_AgeType ];

/// Age1From
Property REAAge1From As %Float [ SqlColumnNumber = 15, SqlFieldName = REA_Age1From ];

/// Age1To
Property REAAge1To As %Float [ SqlColumnNumber = 16, SqlFieldName = REA_Age1To ];

/// Age1Type
Property REAAge1Type As %String(DISPLAYLIST = ",Year,Month,Days", MAXLEN = 5, TRUNCATE = 1, VALUELIST = ",Y,M,D") [ SqlColumnNumber = 17, SqlFieldName = REA_Age1Type ];

/// ReaIPInvFlag
Property ReaIPInvPrtFlag As %String [ SqlColumnNumber = 18, SqlFieldName = Rea_IPInvPrtFlag ];

Index REACodeUnqIdx1 On REACode;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACAdmReason).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAdmReason","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACAdmReason).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAdmReason","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACAdmReason).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAdmReason","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACAdmReason).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAdmReason","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACAdmReason).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAdmReason","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("ADMREA",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="REA_AdmSource">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="REA_Age1From">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="REA_Age1To">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="REA_Age1Type">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="REA_AgeFrom">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="REA_AgeTo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="REA_AgeType">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="REA_CareType">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="REA_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="REA_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="REA_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="REA_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="REA_EpisSubType">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="REA_InPatAdm_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="REA_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="REA_QualifStatus">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="Rea_IPInvPrtFlag">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>REA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ADMREA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{REA_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>REA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ADMREA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({REA_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{REA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>REA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ADMREA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({REA_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{REA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>REA_RowId</SqlRowIdName>
<StreamLocation>^User.PACAdmReasonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
