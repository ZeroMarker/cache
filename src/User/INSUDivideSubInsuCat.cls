Class User.INSUDivideSubInsuCat Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INDISIC_Rowid, SqlTableName = INSU_DivideSubInsuCat, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// INDISIC_DivideDr
Property INDISICDivideDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = INDISIC_DivideDr ];

/// INDISIC_AdmInfo_Dr
Property INDISICAdmInfoDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = INDISIC_AdmInfo_Dr ];

/// INDISIC_Adm_Dr
Property INDISICAdmDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = INDISIC_Adm_Dr ];

/// INDISIC_PB_Dr
Property INDISICPBDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = INDISIC_PB_Dr ];

/// INDISIC_CatDr
Property INDISICCatDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = INDISIC_CatDr ];

/// INDISIC_InsuCatDr
Property INDISICInsuCatDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = INDISIC_InsuCatDr ];

/// INDISIC_TarIpCat
Property INDISICTarIpCat As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = INDISIC_TarIpCat ];

/// INDISIC_Amount
Property INDISICAmount As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = INDISIC_Amount ];

/// INDISIC_Scale1
Property INDISICScale1 As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = INDISIC_Scale1 ];

/// INDISIC_Scale2
Property INDISICScale2 As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = INDISIC_Scale2 ];

/// INDISIC_Scale3
Property INDISICScale3 As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = INDISIC_Scale3 ];

/// INDISIC_InsuPay1
Property INDISICInsuPay1 As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = INDISIC_InsuPay1 ];

/// INDISIC_InsuPay2
Property INDISICInsuPay2 As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = INDISIC_InsuPay2 ];

/// INDISIC_InsuPay3
Property INDISICInsuPay3 As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = INDISIC_InsuPay3 ];

/// INDISIC_ScaleSelf
Property INDISICScaleSelf As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = INDISIC_ScaleSelf ];

/// INDISIC_Self
Property INDISICSelf As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = INDISIC_Self ];

/// INDISIC_OverSelf
Property INDISICOverSelf As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = INDISIC_OverSelf ];

/// INDISIC_InsuMax
Property INDISICInsuMax As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = INDISIC_InsuMax ];

/// INDISIC_Date
Property INDISICDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 20, SqlFieldName = INDISIC_Date ];

/// INDISIC_Time
Property INDISICTime As %Library.Time [ SqlColumnNumber = 21, SqlFieldName = INDISIC_Time ];

/// INDISIC_CreatDate
Property INDISICCreatDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 22, SqlFieldName = INDISIC_CreatDate ];

/// INDISIC_CreatTime
Property INDISICCreatTime As %Library.Time [ SqlColumnNumber = 23, SqlFieldName = INDISIC_CreatTime ];

/// INDISIC_Demo1
Property INDISICDemo1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = INDISIC_Demo1 ];

/// INDISIC_Demo2
Property INDISICDemo2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = INDISIC_Demo2 ];

/// INDISIC_Demo3
Property INDISICDemo3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = INDISIC_Demo3 ];

/// INDISIC_Demo4
Property INDISICDemo4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = INDISIC_Demo4 ];

/// INDISIC_Demo5
Property INDISICDemo5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = INDISIC_Demo5 ];

/// INDISIC_JYLSH
Property INDISICJYLSH As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = INDISIC_JYLSH ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINDISIC)</SqlIdExpression>
<SQLMap name="DatemasterMap">
<Data name="INDISIC_AdmInfo_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INDISIC_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INDISIC_Amount">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INDISIC_CatDr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INDISIC_CreatDate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INDISIC_CreatTime">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INDISIC_Date">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INDISIC_Demo1">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INDISIC_Demo2">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INDISIC_Demo3">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INDISIC_Demo4">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="INDISIC_Demo5">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="INDISIC_DivideDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INDISIC_InsuCatDr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INDISIC_InsuMax">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INDISIC_InsuPay1">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INDISIC_InsuPay2">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INDISIC_InsuPay3">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INDISIC_JYLSH">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="INDISIC_OverSelf">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INDISIC_PB_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INDISIC_Scale1">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INDISIC_Scale2">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INDISIC_Scale3">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INDISIC_ScaleSelf">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INDISIC_Self">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INDISIC_TarIpCat">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INDISIC_Time">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Global>^DHCINDISIC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INDISIC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{INDISIC_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofAdmDr">
<Global>^DHCINDISIC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INDISIC_Rowid</Field>
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
<Expression>{INDISIC_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INDISIC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofAdmInfoDr">
<Global>^DHCINDISIC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INDISIC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"AdmInfoDr"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INDISIC_AdmInfo_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INDISIC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofDHCPB">
<Global>^DHCINDISIC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INDISIC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DHCPB"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INDISIC_PB_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INDISIC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofDateCat">
<Global>^DHCINDISIC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INDISIC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Date_Cat"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INDISIC_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INDISIC_CatDr}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INDISIC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofDateInCat">
<Global>^DHCINDISIC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INDISIC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Date_InCat"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INDISIC_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INDISIC_InsuCatDr}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INDISIC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofDivideDr">
<Global>^DHCINDISIC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INDISIC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DivideDr"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INDISIC_DivideDr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INDISIC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofJYLSH">
<Global>^DHCINDISIC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INDISIC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"JYLSH"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INDISIC_JYLSH}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INDISIC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.INSUDivideSubInsuCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
