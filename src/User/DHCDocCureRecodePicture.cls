/// 治疗记录图片上传
Class User.DHCDocCureRecodePicture Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DCRP_RowId, SqlTableName = DHC_DocCureRecodePicture, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DCRPChildSub [ IdKey, PrimaryKey, Unique ];

/// User.DHCDocCureRecode Parent Reference
Relationship DCRPParRef As User.DHCDocCureRecode [ Cardinality = parent, Inverse = ChildDHCDocCureRecodePicture, Required, SqlFieldName = DCRP_ParRef ];

/// DCRP_ChildSub
Property DCRPChildSub As %Library.Float [ InitialExpression = {$i(^DHCDocCure(+$s($d(initvalue):initvalue,1:%d(0)),"Recode",$p($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"||",2),"Pic",0))}, SqlColumnNumber = 2, SqlFieldName = DCRP_ChildSub ];

/// DCRP_Date  上传日期
Property DCRPDate As %Library.Date [ SqlColumnNumber = 3, SqlFieldName = DCRP_Date ];

/// DCRP_Time  上传时间
Property DCRPTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = DCRP_Time ];

/// DCRP_User_DR  上传用户
Property DCRPUserDR As SSUser [ SqlColumnNumber = 5, SqlFieldName = DCRP_User_DR ];

/// DCRP_PicureName 上传图片的名称
Property DCRPPictureName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = DCRP_PictureName ];

/// DCRP_PicureData 上传图片
Property DCRPPictureData As %Library.String(COLLATION = "Exact", MAXLEN = 1000000, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = DCRP_PictureData ];

/// DCRP_Base64Data 上传图片的base64数据
Property DCRPPictureStreamData As %Stream.GlobalCharacter [ SqlColumnNumber = 8, SqlFieldName = DCRP_PictureStreamData ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DCRP_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DCRP_PictureData">
<Node>"PD"</Node>
</Data>
<Data name="DCRP_PictureName">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DCRP_PictureStreamData">
<Node>"PSD"</Node>
</Data>
<Data name="DCRP_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DCRP_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCDocCure</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocCureApp.DCA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_DocCureRecode.DCR_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>DCRP_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_DocCureApp.DCA_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Record"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_DocCureRecode.DCR_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Pic"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DCRP_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DCRP_RowId</SqlRowIdName>
<StreamLocation>^User.DHCDocCureRecodePictureS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
