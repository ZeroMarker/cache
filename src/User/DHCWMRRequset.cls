Class User.DHCWMRRequset Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RowId, SqlTableName = DHC_WMR_Requset, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MrType_Dr
Property MrTypeDr As User.DHCWMRDictionary [ SqlColumnNumber = 2, SqlFieldName = MrType_Dr ];

/// MrMain_Dr
Property MrMainDr As User.DHCWMRMain [ SqlColumnNumber = 3, SqlFieldName = MrMain_Dr ];

/// RequestType
Property RequestType As User.DHCWMRDictionary [ SqlColumnNumber = 4 ];

/// WorkItem_Dr
Property WorkItemDr As User.DHCWMRWorkItem [ SqlColumnNumber = 5, SqlFieldName = WorkItem_Dr ];

/// AimDate
Property AimDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6 ];

/// AimCtLoc_Dr
Property AimCtLocDr As User.CTLoc [ SqlColumnNumber = 7, SqlFieldName = AimCtLoc_Dr ];

/// AimUser_Dr
Property AimUserDr As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = AimUser_Dr ];

/// FirstValue
Property FirstFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9 ];

/// RequestDate
Property RequestDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10 ];

/// RequestTime
Property RequestTime As %Library.Time [ SqlColumnNumber = 11 ];

/// RequestUser_Dr
Property RequestUserDr As User.SSUser [ SqlColumnNumber = 12, SqlFieldName = RequestUser_Dr ];

/// IsActive
Property IsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13 ];

/// ResponseDate
Property ResponseDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14 ];

/// ResponseTime
Property ResponseTime As %Library.Time [ SqlColumnNumber = 15 ];

/// ResponseUser_Dr
Property ResponseUserDr As User.SSUser [ SqlColumnNumber = 16, SqlFieldName = ResponseUser_Dr ];

/// MrMainStatus_Dr
Property MrMainStatusDr As User.DHCWMRMainStatus [ SqlColumnNumber = 17, SqlFieldName = MrMainStatus_Dr ];

/// ResumeText
Property ResumeText As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 18 ];

/// Paadm_Dr
Property PaadmDr As User.PAAdm [ SqlColumnNumber = 19, SqlFieldName = Paadm_Dr ];

/// PrintFlag
Property PrintFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 20 ];

/// PrintDate
Property PrintDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 21 ];

/// PrintTime
Property PrintTime As %Library.Time [ SqlColumnNumber = 22 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCWMRReq)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="AimCtLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AimDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AimUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="FirstFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IsActive">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MrMainStatus_Dr">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MrMain_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MrType_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Paadm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PrintDate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PrintFlag">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PrintTime">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="RequestDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="RequestTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="RequestType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RequestUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ResponseDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ResponseTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ResponseUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ResumeText">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="WorkItem_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCWMRReq</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAimDate">
<Global>^DHCWMRReq</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"AimDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{AimDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAimDateFirst">
<Global>^DHCWMRReq</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DateFirst"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{AimDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{IsActive}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{FirstFlag}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMRAimDate">
<Global>^DHCWMRReq</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"MainAimDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MrMain_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AimDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{FirstFlag}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMainStatus">
<Global>^DHCWMRReq</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"MainStatus"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MrMainStatus_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPaadm">
<Global>^DHCWMRReq</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Paadm"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{Paadm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCWMRRequsetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
