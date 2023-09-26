Class User.DHCStkSysAFVProp Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SSAFVP_RowID, SqlTableName = DHC_StkSysAFVProp, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On SSAFVPChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_StkSysAFVsfg Parent Reference
Relationship SSAFVPSSAFVParref As User.DHCStkSysAFVsfg [ Cardinality = parent, Inverse = ChildDHCStkSysAFVProp, Required, SqlFieldName = SSAFVP_SSAFV_Parref ];

/// SSAFVP_ChildSub
Property SSAFVPChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = SSAFVP_ChildSub ];

/// SSAFVP_Key
Property SSAFVPKey As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SSAFVP_Key ];

/// SSAFVP_Name
Property SSAFVPName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = SSAFVP_Name ];

/// SSAFVP_Header
Property SSAFVPHeader As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = SSAFVP_Header ];

/// SSAFVP_Width
Property SSAFVPWidth As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = SSAFVP_Width ];

/// SSAFVP_Alignment
Property SSAFVPAlignment As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = SSAFVP_Alignment ];

/// SSAFVP_Format
Property SSAFVPFormat As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = SSAFVP_Format ];

/// SSAFVP_EditMask
Property SSAFVPEditMask As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = SSAFVP_EditMask ];

/// SSAFVP_ComboList
Property SSAFVPComboList As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = SSAFVP_ComboList ];

/// SSAFVP_DataType
Property SSAFVPDataType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = SSAFVP_DataType ];

/// SSAFVP_Hidden
Property SSAFVPHidden As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = SSAFVP_Hidden ];

/// SSAFVP_Modi
Property SSAFVPModi As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = SSAFVP_Modi ];

/// SSAFVP_Necessary
Property SSAFVPNecessary As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = SSAFVP_Necessary ];

/// SSAFVP_SysFlag
Property SSAFVPSysFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = SSAFVP_SysFlag ];

/// SSAFVP_Order
Property SSAFVPOrder As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = SSAFVP_Order ];

/// SSAFVP_SSL_Dr
Property SSAFVPSSLDr As User.DHCStkSysLibrary [ SqlColumnNumber = 17, SqlFieldName = SSAFVP_SSL_Dr ];

/// SSAFVP_Print
Property SSAFVPPrint As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = SSAFVP_Print ];

/// SSAFVP_SSP_Dr
Property SSAFVPSSPDr As User.DHCStkSysPerview [ SqlColumnNumber = 19, SqlFieldName = SSAFVP_SSP_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterAFVP">
<Data name="SSAFVP_Alignment">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SSAFVP_ComboList">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SSAFVP_DataType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SSAFVP_EditMask">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SSAFVP_Format">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SSAFVP_Header">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SSAFVP_Hidden">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SSAFVP_Key">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SSAFVP_Modi">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SSAFVP_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SSAFVP_Necessary">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SSAFVP_Order">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SSAFVP_Print">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="SSAFVP_SSL_Dr">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="SSAFVP_SSP_Dr">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="SSAFVP_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SSAFVP_Width">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCSSA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_StkSysApp.SSA_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_StkSysAFrm.SSAF_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>DHC_StkSysAFVsfg.SSAFV_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L7}</Expression>
<Field>SSAFVP_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_StkSysApp.SSA_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AF"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_StkSysAFrm.SSAF_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"FV"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_StkSysAFVsfg.SSAFV_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"VP"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SSAFVP_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCStkSysAFVPropS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
