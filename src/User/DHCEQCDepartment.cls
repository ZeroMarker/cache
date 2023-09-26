Class User.DHCEQCDepartment Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Dept_RowID, SqlTableName = DHC_EQCDepartment, StorageStrategy = SQLStorage ]
{

Index ULoginNameUnqIdx1 On DeptCode [ Unique ];

Parameter EXTENTSIZE = 250;

/// Dept_Code
Property DeptCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = Dept_Code ];

/// Dept_Desc
Property DeptDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = Dept_Desc ];

/// Dept_LeaderUserDR
Property DeptLeaderUserDR As User.DHCEQCUser [ SqlColumnNumber = 4, SqlFieldName = Dept_LeaderUserDR ];

/// Dept_ContactsUserDR
Property DeptContactsUserDR As User.DHCEQCUser [ SqlColumnNumber = 5, SqlFieldName = Dept_ContactsUserDR ];

/// Dept_Telephone
Property DeptTelephone As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = Dept_Telephone ];

/// Dept_Address
Property DeptAddress As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = Dept_Address ];

/// Dept_OrganizeType
Property DeptOrganizeType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = Dept_OrganizeType ];

/// Dept_OrganizeID
Property DeptOrganizeID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = Dept_OrganizeID ];

/// Dept_DeptType
Property DeptDeptType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = Dept_DeptType ];

/// Dept_ExType
Property DeptExType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = Dept_ExType ];

/// Dept_ExID
Property DeptExID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = Dept_ExID ];

/// Dept_ExDesc
Property DeptExDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = Dept_ExDesc ];

/// Dept_ActiveFlag
Property DeptActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = Dept_ActiveFlag ];

/// Dept_UpdateUserDR
Property DeptUpdateUserDR As User.DHCEQCUser [ SqlColumnNumber = 15, SqlFieldName = Dept_UpdateUserDR ];

/// Dept_UpdateDate
Property DeptUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = Dept_UpdateDate ];

/// Dept_UpdateTime
Property DeptUpdateTime As %Library.Time [ SqlColumnNumber = 17, SqlFieldName = Dept_UpdateTime ];

/// Dept_DateFrom
Property DeptDateFrom As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 18, SqlFieldName = Dept_DateFrom ];

/// Dept_DateTo
Property DeptDateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 19, SqlFieldName = Dept_DateTo ];

/// Dept_InvalidFlag
Property DeptInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = Dept_InvalidFlag ];

/// Dept_Hold1
Property DeptHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = Dept_Hold1 ];

/// Dept_Hold2
Property DeptHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = Dept_Hold2 ];

/// Dept_Hold3
Property DeptHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = Dept_Hold3 ];

/// Dept_Hold4
Property DeptHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = Dept_Hold4 ];

/// Dept_Hold5
Property DeptHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = Dept_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCDepartment",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="Dept_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="Dept_Address">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="Dept_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Dept_ContactsUserDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Dept_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="Dept_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="Dept_DeptType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="Dept_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Dept_ExDesc">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="Dept_ExID">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="Dept_ExType">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="Dept_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="Dept_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="Dept_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="Dept_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="Dept_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="Dept_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="Dept_LeaderUserDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Dept_OrganizeID">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="Dept_OrganizeType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="Dept_Telephone">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="Dept_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="Dept_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="Dept_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>Dept_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCDepartment"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{Dept_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexExID">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>Dept_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCDepartment"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ExID"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Dept_ActiveFlag}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Dept_ExType}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{Dept_ExID}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{Dept_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCDepartmentS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
