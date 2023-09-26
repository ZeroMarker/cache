Class User.PMPModuleUser Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MDU_Rowid, SqlTableName = PMP_ModuleUser, StorageStrategy = SQLStorage ]
{

/// MDUUserDR
Property MDUUserDR As PMPProjectUser [ SqlColumnNumber = 2, SqlFieldName = MDU_User_DR ];

/// MDUModuleDR
Property MDUModuleDR As PMPModule [ SqlColumnNumber = 3, SqlFieldName = MDU_Module_DR ];

/// MDURemark
Property MDURemark As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = MDU_Remark ];

/// MDUStDate
Property MDUStDate As %Date [ SqlColumnNumber = 5, SqlFieldName = MDU_StDate ];

/// MDUEnDate
Property MDUEnDate As %Date [ SqlColumnNumber = 6, SqlFieldName = MDU_EnDate ];

/// MDUUserDR1
Property MDUUserDR1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MDU_User_DR1 ];

/// MDUStTime
Property MDUStTime As %Time [ SqlColumnNumber = 8, SqlFieldName = MDU_StTime ];

/// MDUEnTime
Property MDUEnTime As %Time [ SqlColumnNumber = 9, SqlFieldName = MDU_EnTime ];

/// MDUDate
Property MDUDate As %Date [ SqlColumnNumber = 10, SqlFieldName = MDU_Date ];

/// MDUTime
Property MDUTime As %Time [ SqlColumnNumber = 11, SqlFieldName = MDU_Time ];

/// MDUFalg
Property MDUFalg As %String(DISPLAYLIST = ",有效,无效,其他", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Yes,No,Other") [ SqlColumnNumber = 12, SqlFieldName = MDU_Falg ];

/// MDUStandby1
Property MDUStandby1 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = MDU_Standby1 ];

/// MDUStandby2
Property MDUStandby2 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = MDU_Standby2 ];

/// MDUStandby3
Property MDUStandby3 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = MDU_Standby3 ];

/// MDUStandby4
Property MDUStandby4 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = MDU_Standby4 ];

/// MDUStandby5
Property MDUStandby5 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = MDU_Standby5 ];

/// MDUStandby6
Property MDUStandby6 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = MDU_Standby6 ];

/// MDUStandby7
Property MDUStandby7 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = MDU_Standby7 ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^User.PMPModuleUser(0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="MDU_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MDU_EnDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MDU_EnTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MDU_Falg">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MDU_Module_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MDU_Remark">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MDU_StDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MDU_StTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MDU_Standby1">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MDU_Standby2">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MDU_Standby3">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MDU_Standby4">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MDU_Standby5">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MDU_Standby6">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="MDU_Standby7">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="MDU_Time">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MDU_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MDU_User_DR1">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^PMPModuleUser</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MDU_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MDU_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofMDUModuleDR">
<Global>^PMPModuleUseri</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"ModuleDR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MDU_Module_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MDU_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofMDUUserDR">
<Global>^PMPModuleUseri</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"USER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MDU_User_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MDU_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PMPModuleUserS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
