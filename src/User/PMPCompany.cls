Class User.PMPCompany Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PC_Rowid, SqlTableName = PMP_Company, StorageStrategy = SQLStorage ]
{

/// PC_Code
Property PCCode As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PC_Code ];

/// DTY_Desc
Property PCDesc As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PC_Desc ];

/// PC_Address
Property PCAddress As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PC_Address ];

/// PC_Phone
Property PCPhone As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PC_Phone ];

/// PC_Phone1
Property PCPhone1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PC_Phone1 ];

/// PC_Phone2
Property PCPhone2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PC_Phone2 ];

/// PC_Website
Property PCWebsite As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PC_Website ];

/// PC_PostCdoe
Property PCPostCdoe As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PC_PostCdoe ];

/// PC_LawPerson
Property PCLawPerson As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PC_LawPerson ];

/// PC_Type
Property PCType As PMPDictionary3 [ SqlColumnNumber = 11, SqlFieldName = PC_Type ];

/// PC_Listing
Property PCListing As %String(DISPLAYLIST = ",有效,无效,其他", MAXLEN = 30, VALUELIST = ",Y,N,Other") [ SqlColumnNumber = 12, SqlFieldName = PC_Listing ];

/// PC_Emeail
Property PCEmeail As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PC_Emeail ];

/// PC_Emeail1
Property PCEmeail1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PC_Emeail1 ];

/// PC_Emeail2
Property PCEmeail2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = PC_Emeail2 ];

/// PC_CreatUser
Property PCCreatUser As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = PC_CreatUser ];

/// PC_CreatDate
Property PCCreatDate As %Date [ SqlColumnNumber = 17, SqlFieldName = PC_CreatDate ];

/// PC_CreatTime
Property PCCreatTime As %Time [ SqlColumnNumber = 18, SqlFieldName = PC_CreatTime ];

/// PC_UpdateUser
Property PCUpdateUser As SSUser [ SqlColumnNumber = 19, SqlFieldName = PC_UpdateUser ];

/// PC_UpdateDate
Property PCUpdateDate As %Date [ SqlColumnNumber = 20, SqlFieldName = PC_UpdateDate ];

/// PC_UpdateTime
Property PCUpdateTime As %Time [ SqlColumnNumber = 21, SqlFieldName = PC_UpdateTime ];

/// PC_Standby1
Property PCStandby1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = PC_Standby1 ];

/// PC_Standby2
Property PCStandby2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = PC_Standby2 ];

/// PC_Standby3
Property PCStandby3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = PC_Standby3 ];

/// PC_Standby4
Property PCStandby4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = PC_Standby4 ];

/// PC_Standby5
Property PCStandby5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = PC_Standby5 ];

/// PC_Standby6
Property PCStandby6 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = PC_Standby6 ];

/// PC_Standby7
Property PCStandby7 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = PC_Standby7 ];

/// PC_Standby8
Property PCStandby8 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = PC_Standby8 ];

/// PC_Standby9
Property PCStandby9 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = PC_Standby9 ];

/// PC_Flag
Property PCFlag As %String(DISPLAYLIST = ",有效,无效,其他", MAXLEN = 30, VALUELIST = ",Y,N,Other") [ SqlColumnNumber = 31, SqlFieldName = PC_Flag ];

/// PC_Remark
Property PCRemark As %String(COLLATION = "Exact", MAXLEN = 1024, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = PC_Remark ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^User.PMPCompany("0"))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="PC_Address">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PC_CreatDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PC_CreatTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PC_CreatUser">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PC_Emeail">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PC_Emeail1">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PC_Emeail2">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PC_Flag">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="PC_LawPerson">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PC_Listing">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PC_Phone">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PC_Phone1">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PC_Phone2">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PC_PostCdoe">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PC_Remark">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="PC_Standby1">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PC_Standby2">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PC_Standby3">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PC_Standby4">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PC_Standby5">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PC_Standby6">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="PC_Standby7">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="PC_Standby8">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="PC_Standby9">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="PC_Type">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PC_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PC_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PC_UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PC_Website">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^PMPCompany</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PC_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PC_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofType">
<Global>^PMPCompanyi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"PC_Type"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PC_Type}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PMPCompanyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
