Class User.DHCCRMFUSDetail Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SD_RowId, SqlTableName = DHC_CRM_FUSDetail, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On SDChildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildDHCCRMFUSDSelect As User.DHCCRMFUSDSelect [ Cardinality = children, Inverse = SDSParRef ];

/// DHC_CRM_FUSubject Parent Reference
Relationship SDParRef As User.DHCCRMFUSubject [ Cardinality = parent, Inverse = ChildDHCCRMFUSDetail, Required, SqlFieldName = SD_ParRef ];

/// SD_ChildSub
Property SDChildSub As %Library.String(COLLATION = "Exact", MAXLEN = 16, TRUNCATE = 0) [ InitialExpression = {$i(^DHCCRMFUS($p(%d(0),$c(1),1),"FUSD",0))}, Required, SqlColumnNumber = 3, SqlFieldName = SD_ChildSub ];

/// SD_Code
Property SDCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = SD_Code ];

/// SD_Desc
Property SDDesc As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = SD_Desc ];

/// SD_Type
Property SDType As %Library.String(DISPLAYLIST = ",Text,Number,SingleSelect,DoubleSelect,DoubleText,DoubleNumber,Date", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",T,N,S,D,DT,DN,DA") [ SqlColumnNumber = 6, SqlFieldName = SD_Type ];

/// SD_Unit
Property SDUnit As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = SD_Unit ];

/// SD_Explain
Property SDExplain As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = SD_Explain ];

/// SD_Sex
Property SDSex As %Library.String(DISPLAYLIST = ",Male,Female,No", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",M,F,N") [ SqlColumnNumber = 9, SqlFieldName = SD_Sex ];

/// SD_Active
Property SDActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = SD_Active ];

/// SD_EffDate
Property SDEffDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = SD_EffDate ];

/// SD_EffDateTo
Property SDEffDateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = SD_EffDateTo ];

/// SD_Required
Property SDRequired As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = SD_Required ];

/// SD_Sequence
Property SDSequence As %Library.Numeric(SCALE = 0) [ SqlColumnNumber = 14, SqlFieldName = SD_Sequence ];

/// SD_Parent_DR
Property SDParentDR As %Library.String [ SqlColumnNumber = 15, SqlFieldName = SD_Parent_DR ];

/// SD_Cascade
Property SDCascade As %Library.Numeric(SCALE = 0) [ SqlColumnNumber = 16, SqlFieldName = SD_Cascade ];

/// SD_SelectNum
Property SDSelectNum As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = SD_SelectNum ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterDHCCRMFUSD">
<Data name="SD_Active">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SD_Cascade">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SD_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SD_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SD_EffDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SD_EffDateTo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SD_Explain">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SD_Parent_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SD_Required">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SD_SelectNum">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SD_Sequence">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SD_Sex">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SD_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SD_Unit">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCCRMFUS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_CRM_FUSubject.FUS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_CRM_FUSubject.FUS_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SD"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SD_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCascade">
<Global>^DHCCRMFUS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_CRM_FUSubject.FUS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>SD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SD_Cascade"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHC_CRM_FUSubject.FUS_RowId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{SD_Cascade}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{SD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCRMFUS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_CRM_FUSubject.FUS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>SD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SD_Code"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({SD_Code})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_CRM_FUSubject.FUS_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{SD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCCRMFUS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_CRM_FUSubject.FUS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>SD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SD_Desc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({SD_Desc})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_CRM_FUSubject.FUS_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{SD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSequence">
<Global>^DHCCRMFUS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_CRM_FUSubject.FUS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>SD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SD_Sequence"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHC_CRM_FUSubject.FUS_RowId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{SD_Sequence}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{SD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCCRMFUSDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
