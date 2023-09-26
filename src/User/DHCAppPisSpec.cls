Class User.DHCAppPisSpec Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AP_RowID, SqlTableName = DHC_AppPisSpec, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On APChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_AppPisMaster Parent Reference AP_ParRef_Dr
Relationship APParRefDr As User.DHCAppPisMaster [ Cardinality = parent, Inverse = ChildDHCAPPPISSPEC, Required, SqlFieldName = AP_ParRef_Dr ];

/// AP_ChildSub
Property APChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = AP_ChildSub ];

/// 标本序号  AP_NO 
Property APNO As %Library.String [ SqlColumnNumber = 3, SqlFieldName = AP_NO ];

/// 标本标识  AP_ID 
Property APID As %Library.String [ SqlColumnNumber = 4, SqlFieldName = AP_ID ];

/// 标本名称  AP_Name 
Property APName As %Library.String [ SqlColumnNumber = 5, SqlFieldName = AP_Name ];

/// 标本说明  AP_Explain
Property APExplain As %Library.String [ SqlColumnNumber = 6, SqlFieldName = AP_Explain ];

/// 标本部位  AP_Part 
Property APPart As %Library.String [ SqlColumnNumber = 7, SqlFieldName = AP_Part ];

/// 标本数量  AP_Qty 
Property APQty As %Library.String [ SqlColumnNumber = 8, SqlFieldName = AP_Qty ];

/// 标本备注  AP_Remark
Property APRemark As %Library.String [ SqlColumnNumber = 9, SqlFieldName = AP_Remark ];

/// 玻片/蜡片  AP_SliType
Property APSliType As %Library.String [ SqlColumnNumber = 10, SqlFieldName = AP_SliType ];

/// 原病理号  AP_PisNo
Property APPisNo As %Library.String [ SqlColumnNumber = 11, SqlFieldName = AP_PisNo ];

/// 取材类型  AP_Type
Property APType As User.DHCAppCutBas [ SqlColumnNumber = 12, SqlFieldName = AP_Type ];

/// 固定液  AP_FixActive
Property APFixActive As User.DHCAPPFixActive [ SqlColumnNumber = 13, SqlFieldName = AP_FixActive ];

/// 标本大小  AP_Size
Property APSize As %Library.String [ SqlColumnNumber = 14, SqlFieldName = AP_Size ];

/// 标本性状  AP_Trait
Property APTrait As %Library.String [ SqlColumnNumber = 15, SqlFieldName = AP_Trait ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="AP_Explain">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AP_FixActive">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AP_ID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AP_NO">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AP_Name">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AP_Part">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AP_PisNo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AP_Qty">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AP_Remark">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AP_Size">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AP_SliType">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AP_Trait">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AP_Type">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
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
<Expression>"S"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AP_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAppPisSpecS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
