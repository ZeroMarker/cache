/// DHC_ANC_ViewCat
Class User.DHCANCViewCat Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ANCVC_RowId, SqlTableName = DHC_ANC_ViewCat, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ANCVC_Code
Property ANCVCCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ANCVC_Code ];

/// ANCVC_Desc
Property ANCVCDesc As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ANCVC_Desc ];

/// ANCVC_VitalSign
Property ANCVCVitalSign As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = ANCVC_VitalSign ];

/// ANCVC_Order
Property ANCVCOrder As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = ANCVC_Order ];

/// ANCVC_Event
Property ANCVCEvent As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = ANCVC_Event ];

/// ANCVC_VPSite
Property ANCVCVPSite As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = ANCVC_VPSite ];

/// ANCVC_AnApply
Property ANCVCAnApply As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = ANCVC_AnApply ];

/// ANCVC_IcuApply
Property ANCVCIcuApply As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = ANCVC_IcuApply ];

/// ANCVC_Display
Property ANCVCDisplay As %Library.String(DISPLAYLIST = ",All,Hide,Doctor,Nurse", MAXLEN = 6, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",A,H,D,N") [ SqlColumnNumber = 10, SqlFieldName = ANCVC_Display ];

/// ANCVC_ANCVSC_Dr
Property ANCVCANCVSCDr As User.DHCANCViewSuperCat [ SqlColumnNumber = 11, SqlFieldName = ANCVC_ANCVSC_Dr ];

/// ANCVC_DisplayByCat
Property ANCVCDisplayByCat As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = ANCVC_DisplayByCat ];

/// ANCVC_Therapy
Property ANCVCTherapy As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = ANCVC_Therapy ];

/// ANCVC_Lab
Property ANCVCLab As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = ANCVC_Lab ];

Property ANCVCSummaryType As %String(DISPLAYLIST = ",Average,High,Low,Normal,Sum,BothHighAndLow", MAXLEN = 14, TRUNCATE = 1, VALUELIST = ",A,H,L,N,S,B") [ SqlColumnNumber = 15, SqlFieldName = ANCVC_SummaryType ];

Property ANCVCIntegrity As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = ANCVC_Integrity ];

/// 20141011new
Property ANCVCDataFormat As %String(TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = ANCVC_DataFormat ];

Property ANCVCOptions As %String(TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = ANCVC_Options ];

Property ANCVCRelateCat As %String(TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = ANCVC_RelateCat ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCANC("ViewCat",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ANCVC_ANCVSC_Dr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ANCVC_AnApply">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ANCVC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ANCVC_DataFormat">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ANCVC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ANCVC_Display">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ANCVC_DisplayByCat">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ANCVC_Event">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ANCVC_IcuApply">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ANCVC_Integrity">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ANCVC_Lab">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ANCVC_Options">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ANCVC_Order">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ANCVC_RelateCat">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ANCVC_SummaryType">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ANCVC_Therapy">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ANCVC_VPSite">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ANCVC_VitalSign">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCANC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ANCVC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ViewCat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ANCVC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCANC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ANCVC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ViewCat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ANCVC_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ANCVC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCANCViewCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
