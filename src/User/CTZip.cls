/// CT Postal Code Table     (CTZIP,62)
Class User.CTZip Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_Zip, StorageStrategy = SQLStorage ]
{

Relationship ChildCTZipKeywords As CTZipKeywords [ Cardinality = children, Inverse = KEYWParRef ];

/// Postal Zip Code Table Code
Property CTZIPCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CTZIP_Code ];

/// Postal Zip Code Table Desc
Property CTZIPDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CTZIP_Desc ];

/// Remark
Property CTZIPRemark As list Of %String(COLLATION = "AlphaUp", MAXLEN = "") [ SqlColumnNumber = 5, SqlFieldName = CTZIP_Remark, SqlListType = SUBNODE ];

/// Des Ref Region
Property CTZIPRegionDR As CTRegion [ SqlColumnNumber = 6, SqlFieldName = CTZIP_Region_DR ];

/// Des Ref Province
Property CTZIPProvinceDR As CTProvince [ SqlColumnNumber = 7, SqlFieldName = CTZIP_Province_DR ];

/// Des Ref HCA
Property CTZIPHCADR As CTHealthCareArea [ SqlColumnNumber = 8, SqlFieldName = CTZIP_HCA_DR ];

/// Des Ref CT_CITY
Property CTZIPCITYDR As CTCity [ SqlColumnNumber = 9, SqlFieldName = CTZIP_CITY_DR ];

/// Des Ref to CT_CityArea
Property CTZIPCITYAREADR As CTCityArea [ SqlColumnNumber = 10, SqlFieldName = CTZIP_CITYAREA_DR ];

/// Complement
Property CTZIPComplement As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = CTZIP_Complement ];

/// Type
Property CTZIPType As %String(DISPLAYLIST = ",Normal,Regional,Special", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",1,2,3") [ SqlColumnNumber = 12, SqlFieldName = CTZIP_Type ];

/// City Description
Property CTZIPCityDesc As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = CTZIP_CityDesc ];

/// Active
Property CTZIPActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = CTZIP_Active ];

/// City Area Desc
Property CTZIPCityAreaDesc As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = CTZIP_CityAreaDesc ];

/// Health Care Region Des ref
Property CTZIPHCRegionDR As CTHealthCareRegion [ SqlColumnNumber = 16, SqlFieldName = CTZIP_HCRegion_DR ];

/// Des Ref LocalAuth
Property CTZIPLocalAuthDR As CTLocalAuthority [ SqlColumnNumber = 17, SqlFieldName = CTZIP_LocalAuth_DR ];

/// Date From
Property CTZIPDateFrom As %Date [ SqlColumnNumber = 18, SqlFieldName = CTZIP_DateFrom ];

/// Date To
Property CTZIPDateTo As %Date [ SqlColumnNumber = 19, SqlFieldName = CTZIP_DateTo ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTZip).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTZip","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTZip).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTZip","OnAfterInsert")
 d POFILINS^at62
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTZip).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTZip","OnAfterUpdate")
 d POFILUPD^at62
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTZip).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTZip","OnBeforeDelete")
 
 &sql(DELETE FROM CT_ZipKeywords WHERE KEYW_ParRef=:%d(1))
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
	d PREFILINS^at62
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTZip).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTZip","OnBeforeUpdate")
 
 d PREFILUPD^at62
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^CT("ZIP",0))</SqlIdExpression>
<SQLMap name="DataMasterCTZIP">
<Data name="CTZIP_Active">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CTZIP_CITYAREA_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CTZIP_CITY_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CTZIP_CityAreaDesc">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CTZIP_CityDesc">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CTZIP_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CTZIP_Complement">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CTZIP_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CTZIP_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CTZIP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CTZIP_HCA_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CTZIP_HCRegion_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CTZIP_LocalAuth_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CTZIP_Province_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CTZIP_Region_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CTZIP_Remark">
<Node>"RMK"</Node>
</Data>
<Data name="CTZIP_Type">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CTZIP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"ZIP"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CTZIP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCTZIPCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTZIP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"ZIP"</Expression>
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
<Expression>$$ALPHAUP({CTZIP_Code})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CTZIP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCity">
<Condition>1</Condition>
<ConditionFields>CTZIP_CITY_DR</ConditionFields>
<Global>^CT</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTZIP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ZIP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"City"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CTZIP_CITY_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CTZIP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCityArea">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTZIP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ZIP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CityArea"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CTZIP_CITYAREA_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CTZIP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCityAreaDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTZIP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ZIP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CityAreaDesc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CTZIP_CityAreaDesc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CTZIP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCityCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>CTZIP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ZIP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CityCode"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CTZIP_CITY_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({CTZIP_Code})_"Z"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CTZIP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCityDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTZIP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ZIP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CityDesc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CTZIP_CityDesc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CTZIP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCityDescActive">
<Condition>{CTZIP_Active}'["N"</Condition>
<ConditionFields>CTZIP_Active,CTZIP_CityDesc</ConditionFields>
<Global>^CT</Global>
<PopulationPct>50</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTZIP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ZIP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CityDescActive"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CTZIP_CityDesc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CTZIP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCodeActive">
<Condition>{CTZIP_Active}'["N"</Condition>
<ConditionFields>CTZIP_Active,CTZIP_Code</ConditionFields>
<Global>^CT</Global>
<PopulationPct>50</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTZIP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ZIP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CodeActive"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CTZIP_Code})_"Z"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CTZIP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCodeString">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTZIP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ZIP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CodeStr"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CTZIP_Code})_"Z"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CTZIP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTZIP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ZIP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CTZIP_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CTZIP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexProvCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>CTZIP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ZIP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ProvCode"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CTZIP_Province_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({CTZIP_Code})_"Z"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CTZIP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexProvDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>CTZIP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ZIP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ProvDesc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CTZIP_Province_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({CTZIP_CityDesc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CTZIP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexProvince">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTZIP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ZIP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Prov"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CTZIP_Province_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CTZIP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CTZIP_RowId</SqlRowIdName>
<StreamLocation>^User.CTZipS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
