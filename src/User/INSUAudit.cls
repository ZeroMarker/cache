Class User.INSUAudit Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INAUD_Rowid, SqlTableName = INSU_Audit, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// INAUD_Adm_Dr
Property INAUDAdmDr As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = INAUD_Adm_Dr ];

/// INAUD_PB_Dr
Property INAUDPBDr As User.DHCPatientBill [ SqlColumnNumber = 3, SqlFieldName = INAUD_PB_Dr ];

/// INAUD_OEORI_Dr
Property INAUDOEORIDr As User.OEOrdItem [ SqlColumnNumber = 4, SqlFieldName = INAUD_OEORI_Dr ];

/// INAUD_TaritmDr
Property INAUDTaritmDr As User.DHCTarItem [ SqlColumnNumber = 5, SqlFieldName = INAUD_TaritmDr ];

/// INAUD_PBD_Dr
Property INAUDPBDDr As User.DHCPatBillDetails [ SqlColumnNumber = 6, SqlFieldName = INAUD_PBD_Dr ];

/// INAUD_InsuFlag
Property INAUDInsuFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = INAUD_InsuFlag ];

/// INAUD_Scale
Property INAUDScale As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = INAUD_Scale ];

/// INAUD_UnitPrice
Property INAUDUnitPrice As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = INAUD_UnitPrice ];

/// INAUD_Qty
Property INAUDQty As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = INAUD_Qty ];

/// INAUD_Amount
Property INAUDAmount As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = INAUD_Amount ];

/// INAUD_AuditInfo
Property INAUDAuditInfo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = INAUD_AuditInfo ];

/// INAUD_User_Dr
Property INAUDUserDr As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = INAUD_User_Dr ];

/// INAUD_UserName
Property INAUDUserName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = INAUD_UserName ];

/// INAUD_Date
Property INAUDDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 15, SqlFieldName = INAUD_Date ];

/// INAUD_Time
Property INAUDTime As %Library.Time [ SqlColumnNumber = 16, SqlFieldName = INAUD_Time ];

/// INAUD_AuditFlag
Property INAUDAuditFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = INAUD_AuditFlag ];

/// INAUD_BZ
Property INAUDBZ As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = INAUD_BZ ];

/// INAUD_Demo1
Property INAUDDemo1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = INAUD_Demo1 ];

/// INAUD_Demo2
Property INAUDDemo2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = INAUD_Demo2 ];

/// INAUD_Demo3
Property INAUDDemo3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = INAUD_Demo3 ];

/// INAUD_Demo4
Property INAUDDemo4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = INAUD_Demo4 ];

/// INAUD_Demo5
Property INAUDDemo5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = INAUD_Demo5 ];

/// INAUD_Demo6
Property INAUDDemo6 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = INAUD_Demo6 ];

/// INAUD_Demo7
Property INAUDDemo7 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = INAUD_Demo7 ];

/// INAUD_Demo8
Property INAUDDemo8 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = INAUD_Demo8 ];

/// INAUD_Demo9
Property INAUDDemo9 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = INAUD_Demo9 ];

/// INAUD_Demo10
Property INAUDDemo10 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = INAUD_Demo10 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINAUD)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="INAUD_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INAUD_Amount">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INAUD_AuditFlag">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INAUD_AuditInfo">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INAUD_BZ">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INAUD_Date">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INAUD_Demo1">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INAUD_Demo10">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="INAUD_Demo2">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INAUD_Demo3">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INAUD_Demo4">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INAUD_Demo5">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INAUD_Demo6">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INAUD_Demo7">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INAUD_Demo8">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INAUD_Demo9">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="INAUD_InsuFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INAUD_OEORI_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INAUD_PBD_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INAUD_PB_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INAUD_Qty">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INAUD_Scale">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INAUD_TaritmDr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INAUD_Time">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INAUD_UnitPrice">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INAUD_UserName">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INAUD_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^DHCINAUD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INAUD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INAUD_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofADMDr">
<Global>^DHCINAUD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INAUD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"AdmDr"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INAUD_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INAUD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofAuditFlag">
<Global>^DHCINAUD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INAUD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"AuditFlag"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INAUD_AuditFlag}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INAUD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofAuditInfo">
<Global>^DHCINAUD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INAUD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"AuditInfo"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INAUD_AuditInfo}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INAUD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofDate">
<Global>^DHCINAUD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INAUD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INAUD_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INAUD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofOEORITar">
<Global>^DHCINAUD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INAUD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"OEORI_Tar"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INAUD_OEORI_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INAUD_TaritmDr}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INAUD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofPBDr">
<Global>^DHCINAUD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INAUD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PBDr"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INAUD_PB_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INAUD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofUserDr">
<Global>^DHCINAUD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INAUD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"UserDr"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INAUD_User_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INAUD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.INSUAuditS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
