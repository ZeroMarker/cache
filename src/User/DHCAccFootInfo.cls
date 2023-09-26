Class User.DHCAccFootInfo Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AccFI_RowID, SqlTableName = DHC_AccFootInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On AccFISub [ IdKey, PrimaryKey, Unique ];

/// DHC_AccManager Parent Reference
Relationship AccFIParRef As User.DHCAccManager [ Cardinality = parent, Inverse = ChildDHCAccFootInfo, Required, SqlFieldName = AccFI_ParRef ];

/// AccFI_Sub
Property AccFISub As %Library.Float [ InitialExpression = {$i(^DHCACD("AccM",+%d(0),"AccFI",0))}, SqlColumnNumber = 2, SqlFieldName = AccFI_Sub ];

/// AccFI_PAPMI_DR
Property AccFIPAPMIDR As User.PAPatMas [ SqlColumnNumber = 3, SqlFieldName = AccFI_PAPMI_DR ];

/// AccFI_PAPMINo
Property AccFIPAPMINo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = AccFI_PAPMINo ];

/// AccFI_PreSum
Property AccFIPreSum As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = AccFI_PreSum ];

/// AccFI_Type
Property AccFIType As %Library.String(DISPLAYLIST = ",Pay,Refund", MAXLEN = 6, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",P,R") [ SqlColumnNumber = 6, SqlFieldName = AccFI_Type ];

/// AccFI_RefPreSum
Property AccFIRefPreSum As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = AccFI_RefPreSum ];

/// AccFI_Date
Property AccFIDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = AccFI_Date ];

/// AccFI_Time
Property AccFITime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = AccFI_Time ];

/// AccFI_User_DR
Property AccFIUserDR As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = AccFI_User_DR ];

/// AccFI_IPRep_DR
Property AccFIIPRepDR As User.DHCINVPRTReports [ SqlColumnNumber = 11, SqlFieldName = AccFI_IPRep_DR ];

/// AccFI_PaySum
Property AccFIPaySum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = AccFI_PaySum ];

/// AccFI_Note2
Property AccFINote2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = AccFI_Note2 ];

/// AccFI_Note3
Property AccFINote3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = AccFI_Note3 ];

/// AccFI_Note4
Property AccFINote4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = AccFI_Note4 ];

/// AccFI_Note5
Property AccFINote5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = AccFI_Note5 ];

/// AccFI_Note6
Property AccFINote6 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = AccFI_Note6 ];

/// AccFI_Note7
Property AccFINote7 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = AccFI_Note7 ];

/// AccFI_Note8
Property AccFINote8 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = AccFI_Note8 ];

/// AccFI_Note9
Property AccFINote9 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = AccFI_Note9 ];

/// AccFI_Note10
Property AccFINote10 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = AccFI_Note10 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="AccFI_Date">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AccFI_IPRep_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AccFI_Note10">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="AccFI_Note2">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AccFI_Note3">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AccFI_Note4">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AccFI_Note5">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AccFI_Note6">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AccFI_Note7">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="AccFI_Note8">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="AccFI_Note9">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="AccFI_PAPMINo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AccFI_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AccFI_PaySum">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AccFI_PreSum">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AccFI_RefPreSum">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AccFI_Time">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AccFI_Type">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AccFI_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCACD</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHC_AccManager.AccM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>AccFI_Sub</Field>
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
<Expression>"AccFI"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AccFI_Sub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCACDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_AccManager.AccM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>AccFI_Sub</Field>
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
<Expression>"FIDate"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AccFI_Date}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DHC_AccManager.AccM_RowID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>"AccFI"</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{AccFI_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIReps">
<Global>^DHCACDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_AccManager.AccM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>AccFI_Sub</Field>
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
<Expression>"FIIRepDR"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AccFI_IPRep_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DHC_AccManager.AccM_RowID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>"AccFI"</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{AccFI_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUserDR">
<Global>^DHCACDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_AccManager.AccM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>AccFI_Sub</Field>
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
<Expression>"FIUser"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AccFI_User_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DHC_AccManager.AccM_RowID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>"AccFI"</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{AccFI_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAccFootInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
