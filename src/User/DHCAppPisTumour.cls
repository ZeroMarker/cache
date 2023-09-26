Class User.DHCAppPisTumour Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AP_RowID, SqlTableName = DHC_AppPisTumour, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On APChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_AppPisMaster Parent Reference AP_ParRef_Dr
Relationship APParRefDr As User.DHCAppPisMaster [ Cardinality = parent, Inverse = ChildDHCAPPPISTUMOUR, Required, SqlFieldName = AP_ParRef_Dr ];

/// AP_ChildSub
Property APChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = AP_ChildSub ];

/// 肿瘤发现日期  AP_FoundDate 
Property APFoundDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = AP_FoundDate ];

/// 肿瘤部位  AP_TumPart
Property APTumPart As %Library.String [ SqlColumnNumber = 4, SqlFieldName = AP_TumPart ];

/// 肿瘤大小  AP_TumSize 
Property APTumSize As %Library.String [ SqlColumnNumber = 5, SqlFieldName = AP_TumSize ];

/// 是否转移  AP_TransFlag
Property APTransFlag As %Library.String [ SqlColumnNumber = 6, SqlFieldName = AP_TransFlag ];

/// 转移部位  AP_TransPos
Property APTransPos As %Library.String [ SqlColumnNumber = 7, SqlFieldName = AP_TransPos ];

/// 是否放疗  AP_RadCureFlag
Property APRadCureFlag As %Library.String [ SqlColumnNumber = 8, SqlFieldName = AP_RadCureFlag ];

/// 是否化疗  AP_CheCureFlag
Property APCheCureFlag As %Library.String [ SqlColumnNumber = 9, SqlFieldName = AP_CheCureFlag ];

/// 其他信息  AP_Remark
Property APRemark As %Library.String [ SqlColumnNumber = 10, SqlFieldName = AP_Remark ];

/// 放射治疗及剂量 AP_Radiation
Property APRadiation As %Library.String [ SqlColumnNumber = 11, SqlFieldName = AP_Radiation ];

/// 是否包膜 AP_DioCureFlag add by lp 180801
Property APDioCureFlag As %Library.String [ SqlColumnNumber = 12, SqlFieldName = AP_DioCureFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="AP_CheCureFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AP_DioCureFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AP_FoundDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AP_RadCureFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AP_Radiation">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AP_Remark">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AP_TransFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AP_TransPos">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AP_TumPart">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AP_TumSize">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCAPPPM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_AppPisMaster.AP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>AP_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_AppPisMaster.AP_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"T"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AP_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAppPisTumourS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
