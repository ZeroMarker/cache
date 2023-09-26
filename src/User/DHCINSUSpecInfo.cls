Class User.DHCINSUSpecInfo Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INSPEC_Rowid, SqlTableName = DHC_INSUSpecInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// INSPEC_SQDH
Property INSPECSQDH As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = INSPEC_SQDH ];

/// INSPEC_BRXM
Property INSPECBRXM As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = INSPEC_BRXM ];

/// INSPEC_SFZH
Property INSPECSFZH As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = INSPEC_SFZH ];

/// INSPEC_LXDZ
Property INSPECLXDZ As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = INSPEC_LXDZ ];

/// INSPEC_DHHM
Property INSPECDHHM As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = INSPEC_DHHM ];

/// INSPEC_ZLXM
Property INSPECZLXM As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = INSPEC_ZLXM ];

/// INSPEC_ZLXM2
Property INSPECZLXM2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = INSPEC_ZLXM2 ];

/// INSPEC_YYMC
Property INSPECYYMC As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = INSPEC_YYMC ];

/// INSPEC_YSGH
Property INSPECYSGH As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = INSPEC_YSGH ];

/// INSPEC_BWTR
Property INSPECBWTR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = INSPEC_BWTR ];

/// INSPEC_SFZH2
Property INSPECSFZH2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = INSPEC_SFZH2 ];

/// INSPEC_DHHM2
Property INSPECDHHM2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = INSPEC_DHHM2 ];

/// INSPEC_DJRQ
Property INSPECDJRQ As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = INSPEC_DJRQ ];

/// INSPEC_Time
Property INSPECTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = INSPEC_Time ];

/// INSPEC_CZGH
Property INSPECCZGH As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = INSPEC_CZGH ];

/// INSPEC_ZTZT
Property INSPECZTZT As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = INSPEC_ZTZT ];

/// INSPEC_YBKH
Property INSPECYBKH As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = INSPEC_YBKH ];

/// INSPEC_DWMC
Property INSPECDWMC As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = INSPEC_DWMC ];

/// INSPEC_ZLXM3
Property INSPECZLXM3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = INSPEC_ZLXM3 ];

/// INSPEC_ZLXM4
Property INSPECZLXM4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = INSPEC_ZLXM4 ];

/// INSPEC_QSRQ
Property INSPECQSRQ As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = INSPEC_QSRQ ];

/// INSPEC_JSRQ
Property INSPECJSRQ As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = INSPEC_JSRQ ];

/// INSPEC_JBZD
Property INSPECJBZD As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = INSPEC_JBZD ];

/// INSPEC_SFXZ
Property INSPECSFXZ As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = INSPEC_SFXZ ];

/// INSPEC_GZQK
Property INSPECGZQK As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = INSPEC_GZQK ];

/// INSPEC_YBLB
Property INSPECYBLB As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = INSPEC_YBLB ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINSPEC)</SqlIdExpression>
<SQLMap name="DatemasterMap">
<Data name="INSPEC_BRXM">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INSPEC_BWTR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INSPEC_CZGH">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INSPEC_DHHM">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INSPEC_DHHM2">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INSPEC_DJRQ">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INSPEC_DWMC">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INSPEC_GZQK">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INSPEC_JBZD">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INSPEC_JSRQ">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INSPEC_LXDZ">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INSPEC_QSRQ">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INSPEC_SFXZ">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INSPEC_SFZH">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INSPEC_SFZH2">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INSPEC_SQDH">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INSPEC_Time">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INSPEC_YBKH">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INSPEC_YBLB">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="INSPEC_YSGH">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INSPEC_YYMC">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INSPEC_ZLXM">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INSPEC_ZLXM2">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INSPEC_ZLXM3">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INSPEC_ZLXM4">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INSPEC_ZTZT">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Global>^DHCINSPEC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INSPEC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INSPEC_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofJBZD">
<Global>^DHCINSPEC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INSPEC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"JBZD"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INSPEC_JBZD}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INSPEC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofQSRQ">
<Global>^DHCINSPEC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INSPEC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"QSRQ"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INSPEC_QSRQ}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INSPEC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofSQDH">
<Global>^DHCINSPEC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INSPEC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SQDH"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INSPEC_SQDH}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INSPEC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofYBKH">
<Global>^DHCINSPEC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INSPEC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"YBKH"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INSPEC_YBKH}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INSPEC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofYBLB">
<Global>^DHCINSPEC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INSPEC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"YBLB"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INSPEC_YBLB}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INSPEC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofZLXM">
<Global>^DHCINSPEC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INSPEC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ZLXM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INSPEC_YBKH}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INSPEC_ZLXM}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INSPEC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofZLXM2">
<Global>^DHCINSPEC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INSPEC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ZLXM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INSPEC_YBKH}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INSPEC_ZLXM2}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INSPEC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofZLXM3">
<Global>^DHCINSPEC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INSPEC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ZLXM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INSPEC_YBKH}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INSPEC_ZLXM3}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INSPEC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofZLXM4">
<Global>^DHCINSPEC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INSPEC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ZLXM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INSPEC_YBKH}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INSPEC_ZLXM4}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INSPEC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCINSUSpecInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
