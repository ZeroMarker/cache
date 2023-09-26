Class User.DHCRBCSystemParam Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DSP_RowID, SqlTableName = DHCRBC_SystemParam, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DSP_MoreItem_Report
Property DSPMoreItemReport As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 2, SqlFieldName = DSP_MoreItem_Report ];

/// DSP_Item_MoreReport
Property DSPItemMoreReport As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = DSP_Item_MoreReport ];

/// DSP_SendOutPItoLoc
Property DSPSendOutPItoLoc As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = DSP_SendOutPItoLoc ];

/// DSP_SendEmergItoLoc
Property DSPSendEmergItoLoc As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = DSP_SendEmergItoLoc ];

/// DSP_SendInPItoLoc
Property DSPSendInPItoLoc As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = DSP_SendInPItoLoc ];

/// DSP_SendApptoLoc
Property DSPSendApptoLoc As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = DSP_SendApptoLoc ];

/// DSP_AppointmentConflict
Property DSPAppointmentConflict As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = DSP_AppointmentConflict ];

/// DSP_AppointmentInterval
Property DSPAppointmentInterval As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DSP_AppointmentInterval ];

/// DSP_OnlyQueryExamItm
Property DSPOnlyQueryExamItm As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = DSP_OnlyQueryExamItm ];

/// DSP_SendHPtoLoc
Property DSPSendHPtoLoc As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = DSP_SendHPtoLoc ];

/// DSP_AllowOPRegNotPaid
Property DSPAllowOPRegNotPaid As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = DSP_AllowOPRegNotPaid ];

/// DSP_AllowIPRegNotPaid
Property DSPAllowIPRegNotPaid As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = DSP_AllowIPRegNotPaid ];

/// DSP_AllowHPRegNotPaid
Property DSPAllowHPRegNotPaid As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = DSP_AllowHPRegNotPaid ];

/// DSP_AllowEMRegNotPaid
Property DSPAllowEMRegNotPaid As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = DSP_AllowEMRegNotPaid ];

/// Version of System
Property DSPVersion As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = DSP_Version ];

/// DSP_FileVersion
Property DSPFileVersion As %Library.String(COLLATION = "Exact", MAXLEN = 8, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = DSP_FileVersion ];

/// DSP_FilePath
Property DSPFilePath As %Library.String(COLLATION = "Exact", MAXLEN = 128, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = DSP_FilePath ];

/// DSP_HosptalName
Property DSPHosptalName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = DSP_HosptalName ];

/// DSP_UseHisKnowledge
Property DSPUseHisKnowledge As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = DSP_UseHisKnowledge ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBC("SystemParam"))</SqlIdExpression>
<SQLMap name="MasterDataIndex">
<Data name="DSP_AllowEMRegNotPaid">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DSP_AllowHPRegNotPaid">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DSP_AllowIPRegNotPaid">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DSP_AllowOPRegNotPaid">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DSP_AppointmentConflict">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DSP_AppointmentInterval">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DSP_FilePath">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DSP_FileVersion">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DSP_HosptalName">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DSP_Item_MoreReport">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DSP_MoreItem_Report">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DSP_OnlyQueryExamItm">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DSP_SendApptoLoc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DSP_SendEmergItoLoc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DSP_SendHPtoLoc">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DSP_SendInPItoLoc">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DSP_SendOutPItoLoc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DSP_UseHisKnowledge">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DSP_Version">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Global>^DHCRBC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DSP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SystemParam"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DSP_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCSystemParamS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
