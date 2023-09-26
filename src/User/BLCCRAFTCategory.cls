/// CRAFT Category(2314)
Class User.BLCCRAFTCategory Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = BLC_CRAFTCategory, StorageStrategy = SQLStorage ]
{

/// Code
Property CRAFTCCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CRAFTC_Code ];

/// DHS AverageLOS
Property CRAFTCDHSAverageLOS As %Float [ SqlColumnNumber = 8, SqlFieldName = CRAFTC_DHS_AverageLOS ];

/// Date From
Property CRAFTCDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = CRAFTC_DateFrom ];

/// Date To
Property CRAFTCDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = CRAFTC_DateTo ];

/// Description
Property CRAFTCDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CRAFTC_Desc ];

/// High Inlier Boundary
Property CRAFTCHighInlierBoundary As %Float [ SqlColumnNumber = 7, SqlFieldName = CRAFTC_HighInlierBoundary ];

/// High Outlier PerDiem
Property CRAFTCHighOutlierPerDiem As %Float [ SqlColumnNumber = 13, SqlFieldName = CRAFTC_HighOutlierPerDiem ];

/// Inlier Weight
Property CRAFTCInlierWeight As %Float [ SqlColumnNumber = 12, SqlFieldName = CRAFTC_InlierWeight ];

/// Low Inlier Boundary
Property CRAFTCLowInlierBoundary As %Float [ SqlColumnNumber = 6, SqlFieldName = CRAFTC_LowInlierBoundary ];

/// Low Outlier Per Diem
Property CRAFTCLowOutlierPerDiem As %Float [ SqlColumnNumber = 11, SqlFieldName = CRAFTC_LowOutlierPerDiem ];

/// Same Day Weight
Property CRAFTCSameDayWeight As %Float [ SqlColumnNumber = 9, SqlFieldName = CRAFTC_SameDayWeight ];

/// Short Stay Weight
Property CRAFTCShortStayWeight As %Float [ SqlColumnNumber = 10, SqlFieldName = CRAFTC_ShortStayWeight ];

Relationship ChildBLCCRAFTCategoryVersions As BLCCRAFTCategoryVersions [ Cardinality = children, Inverse = VERParRef ];

Parameter EXTENTSIZE = 7;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.BLCCRAFTCategory).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.BLCCRAFTCategory","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.BLCCRAFTCategory).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.BLCCRAFTCategory","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.BLCCRAFTCategory).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.BLCCRAFTCategory","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.BLCCRAFTCategory).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.BLCCRAFTCategory","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.BLCCRAFTCategory).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.BLCCRAFTCategory","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>7</ExtentSize>
<Property name="CRAFTCCode">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="CRAFTCDHSAverageLOS">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="CRAFTCDateFrom">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="CRAFTCDateTo">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="CRAFTCDesc">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="CRAFTCHighInlierBoundary">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="CRAFTCHighOutlierPerDiem">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="CRAFTCInlierWeight">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="CRAFTCLowInlierBoundary">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="CRAFTCLowOutlierPerDiem">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="CRAFTCSameDayWeight">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="CRAFTCShortStayWeight">
<Selectivity>33.3333%</Selectivity>
</Property>
<SqlIdExpression>$i(^BLC("CRAFTC",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="CRAFTC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CRAFTC_DHS_AverageLOS">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CRAFTC_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CRAFTC_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CRAFTC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CRAFTC_HighInlierBoundary">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CRAFTC_HighOutlierPerDiem">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CRAFTC_InlierWeight">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CRAFTC_LowInlierBoundary">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CRAFTC_LowOutlierPerDiem">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CRAFTC_SameDayWeight">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CRAFTC_ShortStayWeight">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^BLC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CRAFTC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CRAFTC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CRAFTC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^BLC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CRAFTC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CRAFTC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CRAFTC_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CRAFTC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^BLC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CRAFTC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CRAFTC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CRAFTC_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CRAFTC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CRAFTC_RowId</SqlRowIdName>
<StreamLocation>^User.BLCCRAFTCategoryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
