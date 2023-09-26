Class User.PMPDocument Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PDM_Rowid, SqlTableName = PMP_Document, StorageStrategy = SQLStorage ]
{

Relationship ChildPDMSub As PMPDocumentReceive [ Cardinality = children, Inverse = PDMParRef ];

/// PDM_Code
Property PDMCode As %String(COLLATION = "Exact", MAXLEN = 128, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PDM_Code ];

/// PDM_Desc
Property PDMDesc As %String(COLLATION = "Exact", MAXLEN = 128, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PDM_Desc ];

/// PDM_Group
Property PDMGroup As PMPDictionary3 [ SqlColumnNumber = 4, SqlFieldName = PDM_Group ];

/// PDM_Receive
Property PDMReceive As %String(DISPLAYLIST = ",需要,不需要,其他", MAXLEN = 30, VALUELIST = ",Y,N,Other") [ SqlColumnNumber = 5, SqlFieldName = PDM_Receive ];

/// PDM_CreatUser
Property PDMCreatUser As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PDM_CreatUser ];

/// PDM_CreatDate
Property PDMCreatDate As %Date [ SqlColumnNumber = 7, SqlFieldName = PDM_CreatDate ];

/// PDM_CreatTime
Property PDMCreatTime As %Time [ SqlColumnNumber = 8, SqlFieldName = PDM_CreatTime ];

/// PDM_Level
Property PDMLevel As PMPDictionary3 [ SqlColumnNumber = 9, SqlFieldName = PDM_Level ];

/// PDM_Status
Property PDMStatus As PMPDictionary3 [ SqlColumnNumber = 10, SqlFieldName = PDM_Status ];

/// PDM_DownloadsCount
Property PDMDownloadsCount As %String(COLLATION = "Exact", MAXLEN = 128, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PDM_DownloadsCount ];

/// PDM_Standby1
Property PDMStandby1 As %String(COLLATION = "Exact", MAXLEN = 128, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PDM_Standby1 ];

/// PDM_Standby2
Property PDMStandby2 As %String(COLLATION = "Exact", MAXLEN = 128, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PDM_Standby2 ];

/// PDM_Standby3
Property PDMStandby3 As %String(COLLATION = "Exact", MAXLEN = 128, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PDM_Standby3 ];

/// PDM_Standby4
Property PDMStandby4 As %String(COLLATION = "Exact", MAXLEN = 128, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = PDM_Standby4 ];

/// PDM_Standby5
Property PDMStandby5 As %String(COLLATION = "Exact", MAXLEN = 128, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = PDM_Standby5 ];

/// PDM_Standby6
Property PDMStandby6 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = PDM_Standby6 ];

/// PDM_Standby7
Property PDMStandby7 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = PDM_Standby7 ];

/// PDM_Standby8
Property PDMStandby8 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = PDM_Standby8 ];

/// PDM_Standby9
Property PDMStandby9 As %String(COLLATION = "Exact", MAXLEN = 1024, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = PDM_Standby9 ];

/// PDM_Standby10
Property PDMStandby10 As %String(COLLATION = "Exact", MAXLEN = 1024, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = PDM_Standby10 ];

/// PDM_Remark
Property PDMRemark As %String(COLLATION = "Exact", MAXLEN = 1024, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = PDM_Remark ];

/// PDM_Leve
Property PDMLeve As PMPDictionary3 [ SqlColumnNumber = 23, SqlFieldName = PDM_Leve ];

/// PDM_FatherLevel
Property PDMFatherLevel As PMPDocument [ SqlColumnNumber = 24, SqlFieldName = PDM_FatherLevel ];

/// PDM_Share
Property PDMShare As %String(DISPLAYLIST = ",Yes,No,Other", MAXLEN = 30, VALUELIST = ",Y,N,Other") [ SqlColumnNumber = 25, SqlFieldName = PDM_Share ];

/// PDM_Contents
Property PDMContents As PMPDirectoryTree [ SqlColumnNumber = 26, SqlFieldName = PDM_Contents ];

/// PDM_Size
Property PDMSize As %String(COLLATION = "Exact", MAXLEN = 1024, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = PDM_Size ];

/// PDM_Type
Property PDMType As %String(COLLATION = "Exact", MAXLEN = 1024, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = PDM_Type ];

/// PDM_FtpName
Property PDMFtpName As %String(COLLATION = "Exact", MAXLEN = 1024, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = PDM_FtpName ];

/// PDM_Delete
Property PDMDelete As %String(DISPLAYLIST = ",Yes,No,Other", MAXLEN = 30, VALUELIST = ",Y,N,Other") [ SqlColumnNumber = 30, SqlFieldName = PDM_Delete ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^User.PMPDocument("0"))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="PDM_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PDM_Contents">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PDM_CreatDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PDM_CreatTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PDM_CreatUser">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PDM_Delete">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="PDM_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PDM_DownloadsCount">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PDM_FatherLevel">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PDM_FtpName">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="PDM_Group">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PDM_Leve">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PDM_Level">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PDM_Receive">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PDM_Remark">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PDM_Share">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PDM_Size">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="PDM_Standby1">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PDM_Standby10">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PDM_Standby2">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PDM_Standby3">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PDM_Standby4">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PDM_Standby5">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PDM_Standby6">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PDM_Standby7">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PDM_Standby8">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PDM_Standby9">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PDM_Status">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PDM_Type">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Global>^PMPDocument</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PDM_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PDM_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofCode">
<Global>^PMPDocumenti</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PDM_Code}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofContents">
<Global>^PMPDocumenti</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Contents"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PDM_Contents}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofDate">
<Global>^PMPDocumenti</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PDM_CreatDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofFatherLeve">
<Global>^PMPDocumenti</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"FatherLeve"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PDM_FatherLevel}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofLeve">
<Global>^PMPDocumenti</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Leve"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PDM_Leve}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofReceive">
<Global>^PMPDocumenti</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Receive"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PDM_Receive}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofShare">
<Global>^PMPDocumenti</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Share"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PDM_Share}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofType">
<Global>^PMPDocumenti</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PDM_Type}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofUser">
<Global>^PMPDocumenti</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PDM_CreatUser}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PMPDocumentS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
