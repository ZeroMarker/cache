Class User.DHCDocThreeCheckList Extends %Persistent [ SqlTableName = DHC_DocThreeCheckList, StorageStrategy = DHCDocThreeCheckList ]
{

Relationship ChildDHCDocThreeCheckListAdm As User.DHCDocThreeCheckListAdm [ Cardinality = children, Inverse = DocThreeCheckParRef ];

/// DocThree_UserDR 医生
Property DocThreeUserDR As User.SSUser [ SqlColumnNumber = 2, SqlFieldName = DocThree_UserDR ];

/// DocThree_LocDR 科室
Property DocThreeLocDR As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = DocThree_LocDR ];

/// DocThree_Type 类型 (主(副)任医师MaterD，上级医师UpD)
Property DocThreeType As %Library.String [ SqlColumnNumber = 4, SqlFieldName = DocThree_Type ];

/// DocThree_Type 默认
Property DocThreeDefined As %Library.String [ SqlColumnNumber = 5, SqlFieldName = DocThree_Defined ];

/// DocThreeDate 更新日期
Property DocThreeDate As %Library.Date [ SqlColumnNumber = 6, SqlFieldName = DocThree_Date ];

/// DocThreeTime  更新时间
Property DocThreeTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = DocThree_Time ];

/// DocThree_UserDR 医生
Property DocThreeUpdateUserDR As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = DocThree_UpdateUserDR ];

Storage DHCDocThreeCheckList
{
<IdExpression>$i(^DHCDocThreeCheck(0))</IdExpression>
<SqlIdExpression>$i(^DHCDocThreeCheck(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DocThree_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DocThree_Defined">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DocThree_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DocThree_Time">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DocThree_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DocThree_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DocThree_UserDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCDocThreeCheck</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DocThree_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DocThree_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLocUser">
<Global>^DHCDocThreeChecki</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DocThree_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"LocUser"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DocThree_LocDR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DocThree_UpdateUserDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DocThree_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DocThree_RowId</SqlRowIdName>
<StreamLocation>^User.DHCDocThreeCheckListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
