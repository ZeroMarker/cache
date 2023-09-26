Class User.DHCPEUSERREPORT Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RP_ROWID, SqlTableName = DHC_PE_USERREPORT, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEUSERREPORT";

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPEUserReportPayMode As User.DHCPEUserReportPayMode [ Cardinality = children, Inverse = RPMParRef ];

/// RP_USER_DR
Property RPUSERDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = RP_USER_DR ];

/// RP_DATE
Property RPDATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = RP_DATE ];

/// RP_TIME
Property RPTIME As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = RP_TIME ];

/// RP_LASTDATE
Property RPLASTDATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = RP_LASTDATE ];

/// RP_LASTTIME
Property RPLASTTIME As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = RP_LASTTIME ];

/// RP_INVNO
Property RPINVNO As %Library.String(COLLATION = "Exact", MAXLEN = 400, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = RP_INVNO ];

/// RP_FLAG
Property RPFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = RP_FLAG ];

/// RP_INCEPTUSER_DR
Property RPINCEPTUSERDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = RP_INCEPTUSER_DR ];

/// RP_INCEPTFLAG
Property RPINCEPTFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = RP_INCEPTFLAG ];

/// RP_INCEPTDATE
Property RPINCEPTDATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = RP_INCEPTDATE ];

/// RP_INCEPTTIME
Property RPINCEPTTIME As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = RP_INCEPTTIME ];

/// RP_COMMENT1
Property RPCOMMENT1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = RP_COMMENT1 ];

/// RP_COMMENT2
Property RPCOMMENT2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = RP_COMMENT2 ];

/// RP_RCPTNUM
Property RPRCPTNUM As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = RP_RCPTNUM ];

/// RP_REFUNDNUM
Property RPREFUNDNUM As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = RP_REFUNDNUM ];

/// RP_RCPTSUM
Property RPRCPTSUM As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = RP_RCPTSUM ];

/// RP_NORMALSUM
Property RPNORMALSUM As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = RP_NORMALSUM ];

/// RP_REFUNDSUM
Property RPREFUNDSUM As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = RP_REFUNDSUM ];

/// RP_CASHSUM
Property RPCASHSUM As %Library.Float [ SqlColumnNumber = 20, SqlFieldName = RP_CASHSUM ];

/// RP_CHEQUESUM
Property RPCHEQUESUM As %Library.Float [ SqlColumnNumber = 21, SqlFieldName = RP_CHEQUESUM ];

/// RP_OTHERSUM
Property RPOTHERSUM As %Library.Float [ SqlColumnNumber = 22, SqlFieldName = RP_OTHERSUM ];

/// RP_REFINVNO
Property RPREFINVNO As %Library.String(COLLATION = "Exact", MAXLEN = 400, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = RP_REFINVNO ];

/// RP_COMMENT3
Property RPCOMMENT3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = RP_COMMENT3 ];

/// RP_COMMENT4
Property RPCOMMENT4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = RP_COMMENT4 ];

/// RP_COMMENT5
Property RPCOMMENT5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = RP_COMMENT5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPEUSERREPORT)</SqlIdExpression>
<SQLMap name="dataDHCPEUSERREPORT">
<Data name="RP_CASHSUM">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="RP_CHEQUESUM">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="RP_COMMENT1">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="RP_COMMENT2">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="RP_COMMENT3">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="RP_COMMENT4">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="RP_COMMENT5">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="RP_DATE">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RP_FLAG">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RP_INCEPTDATE">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="RP_INCEPTFLAG">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="RP_INCEPTTIME">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="RP_INCEPTUSER_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RP_INVNO">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RP_LASTDATE">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RP_LASTTIME">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RP_NORMALSUM">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="RP_OTHERSUM">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="RP_RCPTNUM">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="RP_RCPTSUM">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="RP_REFINVNO">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="RP_REFUNDNUM">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="RP_REFUNDSUM">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="RP_TIME">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RP_USER_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPEUSERREPORT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RP_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{RP_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexdate">
<Global>^DHCPEUSERREPORT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RP_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{RP_DATE}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RP_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexflag">
<Global>^DHCPEUSERREPORT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RP_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"FLAG"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{RP_USER_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RP_FLAG}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{RP_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexinflag">
<Global>^DHCPEUSERREPORT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RP_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"INFLAG"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{RP_INCEPTUSER_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RP_INCEPTFLAG}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{RP_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexuser">
<Global>^DHCPEUSERREPORT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RP_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"USER"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{RP_USER_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RP_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEUSERREPORTS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
