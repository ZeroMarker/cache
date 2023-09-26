Class User.DHCEQPCContactPerson Extends (%Persistent, %XML.Adaptor) [ SqlRowIdName = CI_RowID, SqlTableName = DHC_EQPCContactPerson, StorageStrategy = NewStorage1 ]
{

/// CI_SourceType
Property CISourceType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = CI_SourceType ];

/// CI_SourceID
Property CISourceID As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CI_SourceID ];

/// CI_Type
Property CIType As %String [ SqlColumnNumber = 4, SqlFieldName = CI_Type ];

/// CI_Name
Property CIName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CI_Name ];

/// CI_Role
Property CIRole As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = CI_Role ];

/// CI_Sex
Property CISex As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = CI_Sex ];

/// CI_MobilePhone
Property CIMobilePhone As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = CI_MobilePhone ];

/// CI_OfficePhone
Property CIOfficePhone As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = CI_OfficePhone ];

/// CI_Email
Property CIEmail As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = CI_Email ];

/// CI_Fax
Property CIFax As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = CI_Fax ];

/// CI_QQ
Property CIQQ As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = CI_QQ ];

/// CI_WeChat
Property CIWeChat As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = CI_WeChat ];

/// CI_OtherContact
Property CIOtherContact As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = CI_OtherContact ];

/// CI_Address
Property CIAddress As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = CI_Address ];

/// CI_Area
Property CIArea As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = CI_Area ];

/// CI_Remark
Property CIRemark As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = CI_Remark ];

/// CI_FromDate
Property CIFromDate As %Date [ SqlColumnNumber = 18, SqlFieldName = CI_FromDate ];

/// CI_ToDate
Property CIToDate As %Date [ SqlColumnNumber = 19, SqlFieldName = CI_ToDate ];

/// CI_InvalidFlag
Property CIInvalidFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = CI_InvalidFlag ];

/// CI_Hold1
Property CIHold1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = CI_Hold1 ];

/// CI_Hold2
Property CIHold2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = CI_Hold2 ];

/// CI_Hold3
Property CIHold3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = CI_Hold3 ];

/// CI_Hold4
Property CIHold4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = CI_Hold4 ];

/// CI_Hold5
Property CIHold5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = CI_Hold5 ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCEQCCode("DHCEQPCContactPerson",0))</SqlIdExpression>
<SQLMap name="DataMap">
<Data name="CI_Address">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CI_Area">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CI_Email">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CI_Fax">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CI_FromDate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="CI_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="CI_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="CI_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="CI_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="CI_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="CI_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="CI_MobilePhone">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CI_Name">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CI_OfficePhone">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CI_OtherContact">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CI_QQ">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CI_Role">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CI_Sex">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CI_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CI_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CI_ToDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="CI_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CI_WeChat">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CI_RowI</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQPCContactPerson"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="SouceTypeIndex">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CI_SourceType</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>CI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"DHCEQPCContactPerson"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>"SouceType"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{CI_SourceType}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{CI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="TypeIndex">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CI_Type</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>CI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"DHCEQPCContactPerson"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{CI_Type}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{CI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQPCContactPersonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
