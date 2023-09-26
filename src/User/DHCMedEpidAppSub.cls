Class User.DHCMedEpidAppSub Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MEAS_Rowid, SqlTableName = DHC_MedEpidAppSub, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On MEASChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_MedEpidApp Parent Reference
Relationship MEASParRef As User.DHCMedEpidApp [ Cardinality = parent, Inverse = ChildDHCMedEpidAppSub, Required, SqlFieldName = MEAS_ParRef ];

/// MEAS_ChildSub
Property MEASChildSub As %Library.Float [ InitialExpression = {$i(^DHCMEPA($p(%d(0),$c(1),1),"I",0))}, SqlColumnNumber = 2, SqlFieldName = MEAS_ChildSub ];

/// MEAS_AppType
Property MEASAppType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MEAS_AppType ];

/// MEAS_LabType
Property MEASLabType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MEAS_LabType ];

/// MEAS_LabNo
Property MEASLabNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MEAS_LabNo ];

/// MEAS_MIFC_Dr
Property MEASMIFCDr As User.DHCMedInfectionCtl [ SqlColumnNumber = 6, SqlFieldName = MEAS_MIFC_Dr ];

/// MEAS_LabResult
Property MEASLabResult As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MEAS_LabResult ];

/// MEAS_LabDate
Property MEASLabDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = MEAS_LabDate ];

/// MEAS_LabTime
Property MEASLabTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = MEAS_LabTime ];

/// MEAS_MRDis_Dr
Property MEASMRDisDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = MEAS_MRDis_Dr ];

/// MEAS_MEPD_Dr
Property MEASMEPDDr As User.DHCMedEpidemic [ SqlColumnNumber = 11, SqlFieldName = MEAS_MEPD_Dr ];

/// MEAS_MDR_Dr
Property MEASMDRDr As User.DHCMedDeathRep [ SqlColumnNumber = 12, SqlFieldName = MEAS_MDR_Dr ];

/// MEAS_Operation
Property MEASOperation As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = MEAS_Operation ];

/// MEAS_AppInfo
Property MEASAppInfo As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = MEAS_AppInfo ];

/// MEAS_User_Dr
Property MEASUserDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = MEAS_User_Dr ];

/// MEAS_AppDate
Property MEASAppDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = MEAS_AppDate ];

/// MEAS_AppTime
Property MEASAppTime As %Library.Time [ SqlColumnNumber = 17, SqlFieldName = MEAS_AppTime ];

/// MEAS_Demo
Property MEASDemo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = MEAS_Demo ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="MEAS_AppDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MEAS_AppInfo">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MEAS_AppTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MEAS_AppType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MEAS_Demo">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MEAS_LabDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MEAS_LabNo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MEAS_LabResult">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MEAS_LabTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MEAS_LabType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MEAS_MDR_Dr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MEAS_MEPD_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MEAS_MIFC_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MEAS_MRDis_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MEAS_Operation">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MEAS_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Global>^DHCMEPA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_MedEpidApp.MEA_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MEAS_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_MedEpidApp.MEA_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MEAS_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMedEpidAppSubS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
