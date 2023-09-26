Class User.DHCMedDepGroup Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MDG_Rowid, SqlTableName = DHC_MedDepGroup, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCMedDepGroupArcim As User.DHCMedDepGroupArcim [ Cardinality = children, Inverse = MDGAParRef ];

Relationship ChildDHCMedDepGroupDIA As User.DHCMedDepGroupDIA [ Cardinality = children, Inverse = MDGDParRef ];

Relationship ChildDHCMedDepGroupItms As User.DHCMedDepGroupItms [ Cardinality = children, Inverse = MDGIParRef ];

Relationship ChildDHCMedDepGroupSub As User.DHCMedDepGroupSub [ Cardinality = children, Inverse = MDGSParRef ];

/// MDG_ActiveFlag
Property MDGActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 2, SqlFieldName = MDG_ActiveFlag ];

/// MDG_DepGroup_DR
Property MDGDepGroupDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = MDG_DepGroup_DR ];

/// MDG_Demo
Property MDGDemo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MDG_Demo ];

/// MDG_BodyTempL
Property MDGBodyTempL As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = MDG_BodyTempL ];

/// MDG_BodyTempH
Property MDGBodyTempH As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = MDG_BodyTempH ];

/// MDG_TempWeight
Property MDGTempWeight As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = MDG_TempWeight ];

/// MDG_ReportWeight
Property MDGReportWeight As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = MDG_ReportWeight ];

/// MDG_DisplayWeight
Property MDGDisplayWeight As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = MDG_DisplayWeight ];

/// MDG_GlobalFlag
Property MDGGlobalFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = MDG_GlobalFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMDG)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="MDG_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MDG_BodyTempH">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MDG_BodyTempL">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MDG_Demo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MDG_DepGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MDG_DisplayWeight">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MDG_GlobalFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MDG_ReportWeight">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MDG_TempWeight">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCMDG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MDG_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MDG_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexFlagDepGroup">
<Global>^DHCMDG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MDG_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"FlagDepGroup"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MDG_ActiveFlag}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MDG_DepGroup_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MDG_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGlobalFlag">
<Global>^DHCMDG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MDG_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"GlobalFlag"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MDG_GlobalFlag}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MDG_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMedDepGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
