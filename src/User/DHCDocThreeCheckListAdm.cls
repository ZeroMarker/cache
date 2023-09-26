Class User.DHCDocThreeCheckListAdm Extends %Persistent [ SqlTableName = DHC_DocThreeCheckListAdm, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DocThreeCheckChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_DocCureApp Parent Reference
Relationship DocThreeCheckParRef As User.DHCDocThreeCheckList [ Cardinality = parent, Inverse = ChildDHCDocThreeCheckListAdm, Required, SqlFieldName = DocThreeCheck_ParRef ];

/// DCAA_ChildSub
Property DocThreeCheckChildSub As %Library.Float [ InitialExpression = {$i(^DHCDocThreeCheck($p(%d(0),$c(1)),"ThreeCheck",0))}, SqlColumnNumber = 2, SqlFieldName = DocThreeCheck_ChildSub ];

/// DocThree_UserDR 就诊
Property DocThreeCheckAdm As User.PAAdm [ SqlColumnNumber = 3, SqlFieldName = DocThreeCheck_Adm ];

/// DocThree_UserDR 激活
Property DocThreeCheckActiveFlag As %Library.String [ SqlColumnNumber = 4, SqlFieldName = DocThreeCheck_ActiveFlag ];

/// DocThreeDate 更新日期
Property DocThreeCheckDate As %Library.Date [ SqlColumnNumber = 5, SqlFieldName = DocThreeCheck_Date ];

/// DocThreeTime  更新时间
Property DocThreeCheckTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = DocThreeCheck_Time ];

/// DocThree_UserDR 医生
Property DocThreeCheckUpdateUserDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = DocThreeCheck_UpdateUserDR ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="DocThreeCheck_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DocThreeCheck_Adm">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DocThreeCheck_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DocThreeCheck_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DocThreeCheck_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCDocThreeCheck</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocThreeCheckList.DocThree_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DocThreeCheck_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_DocThreeCheckList.DocThree_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ThreeCheck"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DocThreeCheck_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^DHCDocThreeChecki</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_DocThreeCheckList.DocThree_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DocThreeCheck_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ThreeAdm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_DocThreeCheckList.DocThree_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DocThreeCheck_Adm}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DocThreeCheck_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFadm">
<Global>^DHCDocThreeChecki</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_DocThreeCheckList.DocThree_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DocThreeCheck_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FristAdm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DocThreeCheck_Adm}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_DocThreeCheckList.DocThree_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DocThreeCheck_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DocThreeCheck_RowId</SqlRowIdName>
<StreamLocation>^User.DHCDocThreeCheckListAdmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
