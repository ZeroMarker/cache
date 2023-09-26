Class User.DHCWMRNoType Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Rowid, SqlTableName = DHC_WMR_NoType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// NoLength
Property NoLength As %Library.Float [ SqlColumnNumber = 2 ];

/// NoHead
Property NoHead As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// GetWay
Property GetWay As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

/// MinNo
Property MinNo As %Library.Float [ SqlColumnNumber = 5 ];

/// NoFiled
Property NoFiled As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

/// IsCancelMain
Property IsCancelMain As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7 ];

/// DefaultType
Property DefaultType As User.DHCWMRDictionary [ SqlColumnNumber = 8 ];

/// HospitalID
Property HospitalID As User.CTHospital [ SqlColumnNumber = 9 ];

/// AdmType
Property AdmType As User.DHCWMRDictionary [ SqlColumnNumber = 10 ];

/// ReceiptType
Property ReceiptType As User.DHCWMRDictionary [ SqlColumnNumber = 11 ];

/// AssignType
Property AssignType As User.DHCWMRDictionary [ SqlColumnNumber = 12 ];

/// UnReceiptType
Property UnReceiptType As User.DHCWMRDictionary [ SqlColumnNumber = 13 ];

/// RecycleType
Property RecycleType As User.DHCWMRDictionary [ SqlColumnNumber = 14 ];

/// Text1
Property Text1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15 ];

/// Text2
Property Text2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16 ];

/// Text3
Property Text3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17 ];

/// Text4
Property Text4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCWMRNOTYPE("NoFormat"))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="AdmType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AssignType">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DefaultType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="GetWay">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HospitalID">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IsCancelMain">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MinNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="NoFiled">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="NoHead">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="NoLength">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ReceiptType">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="RecycleType">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="Text1">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="Text2">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="Text3">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="Text4">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="UnReceiptType">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^DHCWMRNOTYPE</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"NoFormat"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexHospitalAdmType">
<Global>^DHCWMRNOTYPE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"HospitalAdmType"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{HospitalID}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AdmType}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCWMRNoTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
