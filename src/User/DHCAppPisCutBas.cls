Class User.DHCAppPisCutBas Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AP_RowID, SqlTableName = DHC_AppPisCutBas, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On APChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_AppPisMaster Parent Reference AP_ParRef_Dr
Relationship APParRefDr As User.DHCAppPisMaster [ Cardinality = parent, Inverse = ChildDHCAPPPISCUTBAS, Required, SqlFieldName = AP_ParRef_Dr ];

/// AP_ChildSub
Property APChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = AP_ChildSub ];

/// 取材离体日期  AP_SepDate
Property APSepDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = AP_SepDate ];

/// 取材离体时间  AP_SepTime
Property APSepTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = AP_SepTime ];

/// 开始固定日期  AP_FixDate
Property APFixDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = AP_FixDate ];

/// 开始固定时间  AP_FixTime 
Property APFixTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = AP_FixTime ];

/// 取材科室  AP_Loc_Dr 
Property APLocDr As %Library.String [ SqlColumnNumber = 7, SqlFieldName = AP_Loc_Dr ];

/// 取材医生  AP_Doc_Dr 
Property APDocDr As %Library.String [ SqlColumnNumber = 8, SqlFieldName = AP_Doc_Dr ];

/// 取材部位  AP_Position
Property APPosition As %Library.String [ SqlColumnNumber = 9, SqlFieldName = AP_Position ];

/// 取材类型  AP_Type
Property APType As %Library.String [ SqlColumnNumber = 10, SqlFieldName = AP_Type ];

/// 手术名称  AP_OperName
Property APOperName As %Library.String [ SqlColumnNumber = 11, SqlFieldName = AP_OperName ];

/// 手术部位  AP_OperPart
Property APOperPart As %Library.String [ SqlColumnNumber = 12, SqlFieldName = AP_OperPart ];

/// 手术日期  AP_OperDate
Property APOperDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = AP_OperDate ];

/// 手术时间  AP_OperTime
Property APOperTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = AP_OperTime ];

/// 手术医生  AP_OperUser
Property APOperUser As %Library.String [ SqlColumnNumber = 15, SqlFieldName = AP_OperUser ];

/// 联系电话  AP_OperUserTel
Property APOperUserTel As %Library.String [ SqlColumnNumber = 16, SqlFieldName = AP_OperUserTel ];

/// 手术室/间  AP_OperRoom
Property APOperRoom As %Library.String [ SqlColumnNumber = 17, SqlFieldName = AP_OperRoom ];

/// 手术方式  AP_OperWay add 2018/9/3 qunianpeng
Property APOperWay As %Library.String [ SqlColumnNumber = 18, SqlFieldName = AP_OperWay ];

/// 送检目的  AP_OperAim add 2018/9/3 qunianpeng
Property APOperAim As %Library.String [ SqlColumnNumber = 19, SqlFieldName = AP_OperAim ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="AP_Doc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AP_FixDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AP_FixTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AP_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AP_OperAim">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="AP_OperDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AP_OperName">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AP_OperPart">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AP_OperRoom">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AP_OperTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AP_OperUser">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AP_OperUserTel">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AP_OperWay">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="AP_Position">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AP_SepDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AP_SepTime">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AP_Type">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
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
<Expression>"B"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AP_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAppPisCutBasS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
