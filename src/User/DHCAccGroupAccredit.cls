Class User.DHCAccGroupAccredit Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AGA_RowID, SqlTableName = DHC_AccGroupAccredit, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On AGASub [ IdKey, PrimaryKey, Unique ];

/// DHC_AccManager Parent Reference
Relationship AGAAccMParRef As User.DHCAccManager [ Cardinality = parent, Inverse = ChildDHCAccGroupAccredit, Required, SqlFieldName = AGA_AccM_ParRef ];

/// AGA_Sub
Property AGASub As %Library.Float [ InitialExpression = {$i(^DHCACD("AccM",+%d(0),"A",0))}, SqlColumnNumber = 2, SqlFieldName = AGA_Sub ];

/// AGA_Flag
Property AGAFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = AGA_Flag ];

/// AGA_BeginDate
Property AGABeginDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = AGA_BeginDate ];

/// AGA_BeginTime
Property AGABeginTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = AGA_BeginTime ];

/// AGA_EndDate
Property AGAEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = AGA_EndDate ];

/// AGA_EndTime
Property AGAEndTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = AGA_EndTime ];

/// AGA_PAPMI_DR
Property AGAPAPMIDR As User.PAPatMas [ SqlColumnNumber = 8, SqlFieldName = AGA_PAPMI_DR ];

/// AGA_Prior
Property AGAPrior As %Library.String(DISPLAYLIST = ",Person,Group", MAXLEN = 6, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",P,G") [ SqlColumnNumber = 9, SqlFieldName = AGA_Prior ];

/// AGA_CurrentLimit
Property AGACurrentLimit As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = AGA_CurrentLimit ];

/// AGA_AllLimit
Property AGAAllLimit As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = AGA_AllLimit ];

/// AGA_Note1
Property AGAAddUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = AGA_AddUser ];

/// AGA_Note2
Property AGAActiveFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = AGA_ActiveFlag ];

///  AGA_Note3
Property AGAAddDate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = AGA_AddDate ];

/// AGA_Note4
Property AGAAddTime As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = AGA_AddTime ];

/// AGA_Note5
Property AGANote5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = AGA_Note5 ];

/// AGA_Note6
Property AGANote6 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = AGA_Note6 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="AGA_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AGA_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AGA_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AGA_AddUser">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AGA_AllLimit">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AGA_BeginDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AGA_BeginTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AGA_CurrentLimit">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AGA_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AGA_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AGA_Flag">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AGA_Note5">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AGA_Note6">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AGA_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AGA_Prior">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCACD</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHC_AccManager.AccM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>AGA_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"AccM"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{DHC_AccManager.AccM_RowID}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"A"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AGA_Sub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAddDate">
<Global>^DHCACDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DHC_AccManager.AccM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>AGA_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"AccM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"GA"</Expression>
</Subscript>
<Subscript name="4">
<Expression>"AddDate"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AGA_AddDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHC_AccManager.AccM_RowID}</Expression>
</Subscript>
<Subscript name="7">
<Expression>"A"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{AGA_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAPMI">
<Global>^DHCACDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DHC_AccManager.AccM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>AGA_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"AccM"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"GA"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{AGA_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{DHC_AccManager.AccM_RowID}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>"A"</Expression>
</Subscript>
<Subscript name="8">
<AccessType>sub</AccessType>
<Expression>{AGA_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAccGroupAccreditS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
