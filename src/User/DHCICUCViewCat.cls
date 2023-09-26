/// DHC_ICUC_ViewCat
Class User.DHCICUCViewCat Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ICUCVC_RowId, SqlTableName = DHC_ICUC_ViewCat, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ICUCVC_Code
Property ICUCVCCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ICUCVC_Code ];

/// ICUCVC_Desc
Property ICUCVCDesc As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ICUCVC_Desc ];

/// ICUCVC_VitalSign
Property ICUCVCVitalSign As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = ICUCVC_VitalSign ];

/// ICUCVC_Order
Property ICUCVCOrder As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = ICUCVC_Order ];

/// ICUCVC_Event
Property ICUCVCEvent As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = ICUCVC_Event ];

/// ICUCVC_VPSite
Property ICUCVCVPSite As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = ICUCVC_VPSite ];

/// ICUCVC_PHCSC_Dr
Property ICUCVCPHCSCDr As %Library.String(MAXLEN = 200) [ SqlColumnNumber = 8, SqlFieldName = ICUCVC_PHCSC_Dr ];

/// ICUCVC_IcuApply
Property ICUCVCIcuApply As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = ICUCVC_IcuApply ];

/// ICUCVC_Display
Property ICUCVCDisplay As %Library.String(DISPLAYLIST = ",All,Hide,Doctor,Nurse", MAXLEN = 6, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",A,H,D,N") [ SqlColumnNumber = 10, SqlFieldName = ICUCVC_Display ];

/// ICUCVC_ICUCVSC_Dr
Property ICUCVCICUCVSCDr As User.DHCICUCViewSuperCat [ SqlColumnNumber = 11, SqlFieldName = ICUCVC_ICUCVSC_Dr ];

/// ICUCVC_DisplayByCat
Property ICUCVCDisplayByCat As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = ICUCVC_DisplayByCat ];

/// ICUCVC_Therapy
Property ICUCVCTherapy As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = ICUCVC_Therapy ];

/// ICUCVC_Lab
Property ICUCVCLab As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = ICUCVC_Lab ];

Property ICUCVCSummaryType As %String(DISPLAYLIST = ",Average,High,Low,Normal,Sum,BothHighAndLow", MAXLEN = 14, TRUNCATE = 1, VALUELIST = ",A,H,L,N,S,B") [ SqlColumnNumber = 15, SqlFieldName = ICUCVC_SummaryType ];

Property ICUCVCIntegrity As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = ICUCVC_Integrity ];

Property ICUCVCDataFormat As %String [ SqlColumnNumber = 17, SqlFieldName = ICUCVC_DataFormat ];

Property ICUCVCOptions As %String [ SqlColumnNumber = 18, SqlFieldName = ICUCVC_Options ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCICUC("ViewCat",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ICUCVC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ICUCVC_DataFormat">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ICUCVC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ICUCVC_Display">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ICUCVC_DisplayByCat">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ICUCVC_Event">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ICUCVC_ICUCVSC_Dr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ICUCVC_IcuApply">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ICUCVC_Integrity">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ICUCVC_Lab">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ICUCVC_Options">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ICUCVC_Order">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ICUCVC_PHCSC_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ICUCVC_SummaryType">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ICUCVC_Therapy">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ICUCVC_VPSite">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ICUCVC_VitalSign">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCICUC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ICUCVC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ViewCat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ICUCVC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCICUC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ICUCVC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ViewCat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ICUCVC_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ICUCVC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCICUCViewCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
