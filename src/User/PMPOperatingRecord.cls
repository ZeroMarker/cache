Class User.PMPOperatingRecord Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = POR_Rowid, SqlTableName = PMP_OperatingRecord, StorageStrategy = SQLStorage ]
{

/// POR_TabName
Property PORTabName As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = POR_TabName ];

/// POR_TabRowid
Property PORTabRowid As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = POR_TabRowid ];

/// POR_Type
Property PORType As %String(DISPLAYLIST = ",新增,修改,删除,其他", MAXLEN = 30, VALUELIST = ",Add,Update,Delete,Other") [ SqlColumnNumber = 4, SqlFieldName = POR_Type ];

/// POR_FieldName
Property PORFieldName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = POR_FieldName ];

/// POR_OldVlaue
Property POROldVlaue As %String(COLLATION = "Exact", MAXLEN = 1024, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = POR_OldVlaue ];

/// POR_NewValue
Property PORNewValue As %String(COLLATION = "Exact", MAXLEN = 1024, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = POR_NewValue ];

/// POR_UpdateUser
Property PORUpdateUser As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = POR_UpdateUser ];

/// POR_UpdateDate
Property PORUpdateDate As %Date [ SqlColumnNumber = 9, SqlFieldName = POR_UpdateDate ];

/// POR_UpdateTime
Property PORUpdateTime As %Time [ SqlColumnNumber = 10, SqlFieldName = POR_UpdateTime ];

/// POR_IP
Property PORIP As %String(COLLATION = "Exact", MAXLEN = 1024, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = POR_IP ];

/// POR_Revelance
Property PORRevelance As PMPOperatingRecord [ SqlColumnNumber = 12, SqlFieldName = POR_Revelance ];

/// POR_Standby1
Property PORStandby1 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = POR_Standby1 ];

/// POR_Standby2
Property PORStandby2 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = POR_Standby2 ];

/// POR_Standby3
Property PORStandby3 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = POR_Standby3 ];

/// POR_Standby4
Property PORStandby4 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = POR_Standby4 ];

/// POR_Standby5
Property PORStandby5 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = POR_Standby5 ];

/// POR_Standby6
Property PORStandby6 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = POR_Standby6 ];

/// POR_Standby7
Property PORStandby7 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = POR_Standby7 ];

/// POR_Standby8
Property PORStandby8 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = POR_Standby8 ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^User.PMPOperatingRecord("0"))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="POR_FieldName">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="POR_IP">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="POR_NewValue">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="POR_OldVlaue">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="POR_Revelance">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="POR_Standby1">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="POR_Standby2">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="POR_Standby3">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="POR_Standby4">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="POR_Standby5">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="POR_Standby6">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="POR_Standby7">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="POR_Standby8">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="POR_TabName">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="POR_TabRowid">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="POR_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="POR_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="POR_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="POR_UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^PMPOperatingRecord</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PRO_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{POR_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofIPDate">
<Global>^PMPOperatingRecordi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"IPData"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{POR_IP}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POR_UpdateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{POR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofIPTabName">
<Global>^PMPOperatingRecordi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"IPTabName"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{POR_IP}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POR_TabName}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{POR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofIPTabRowid">
<Global>^PMPOperatingRecordi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"IPTabRowid"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{POR_IP}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POR_TabName}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{POR_TabRowid}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{POR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofIp">
<Global>^PMPOperatingRecordi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"IP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{POR_IP}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofIpUser">
<Global>^PMPOperatingRecordi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"IPUser"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{POR_IP}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POR_UpdateUser}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{POR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofRevelance">
<Global>^PMPOperatingRecordi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Revelance"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{POR_TabName}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POR_Revelance}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{POR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofTabFieldName">
<Global>^PMPOperatingRecordi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"TabFieldName"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{POR_TabName}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POR_FieldName}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{POR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofTabFieldNameRowid">
<Global>^PMPOperatingRecordi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"TabFieldNameRowid"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{POR_TabName}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POR_FieldName}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{POR_TabRowid}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{POR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofTabName">
<Global>^PMPOperatingRecordi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"PRO_TabName"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{POR_TabName}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofTabNameRowid">
<Global>^PMPOperatingRecordi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"TabNameRowid"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{POR_TabName}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POR_TabRowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{POR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofTabRowidFieldName">
<Global>^PMPOperatingRecordi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"TabRowidFieldName"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{POR_TabName}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POR_TabRowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{POR_FieldName}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{POR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofType">
<Global>^PMPOperatingRecordi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"POR_Type"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{POR_Type}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofTypeTabName">
<Global>^PMPOperatingRecordi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"TypeTabName"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{POR_Type}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POR_TabName}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{POR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofTypeTabRowid">
<Global>^PMPOperatingRecordi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"TypeTabRowid"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{POR_Type}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POR_TabName}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{POR_TabRowid}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{POR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofTypeUpdaeUserTab">
<Global>^PMPOperatingRecordi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"TypeUpdaeUserTab"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{POR_Type}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POR_UpdateUser}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{POR_TabName}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{POR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofTypeUpdateDate">
<Global>^PMPOperatingRecordi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"TypeUpdateDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{POR_Type}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POR_UpdateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{POR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofTypeUpdateUser">
<Global>^PMPOperatingRecordi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"TypeUpdateUser"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{POR_Type}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POR_UpdateUser}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{POR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofTypeUserDate">
<Global>^PMPOperatingRecordi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"TypeUserDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{POR_Type}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POR_UpdateUser}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{POR_UpdateDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{POR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofUpdateUser">
<Global>^PMPOperatingRecordi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"UpdateUser"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{POR_UpdateUser}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofUpdateUserDate">
<Global>^PMPOperatingRecordi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"UpdateUserDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{POR_UpdateUser}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POR_UpdateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{POR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PMPOperatingRecordS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
