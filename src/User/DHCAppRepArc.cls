Class User.DHCAppRepArc Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AR_RowID, SqlTableName = DHC_AppRepArc, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ARChildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildDHCAPPREPPART As User.DHCAppRepPart [ Cardinality = children, Inverse = ARParRefDr ];

Relationship ChildDHCAPPREPDISP As User.DHCAppRepDisp [ Cardinality = children, Inverse = ARParRefDr ];

/// DHC_AppReport Parent Reference AR_ParRef_Dr
Relationship ARParRefDr As User.DHCAppReport [ Cardinality = parent, Inverse = ChildDHCAPPREPARC, Required, SqlFieldName = AR_ParRef_Dr ];

/// AR_ChildSub
Property ARChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = AR_ChildSub ];

/// 检查医嘱项  AR_Arc_Dr 
Property ARArcDr As User.ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = AR_Arc_Dr ];

/// 体位  AR_Pos_Dr 
Property ARPosDr As User.DHCAppPosition [ SqlColumnNumber = 4, SqlFieldName = AR_Pos_Dr ];

/// 医嘱id  AR_OrdItem 
Property AROrdItem As User.OEOrdItem [ SqlColumnNumber = 5, SqlFieldName = AR_OrdItem ];

/// 备注  AR_Remark 
Property ARRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = AR_Remark ];

/// 检查目的  AR_ExaPurpose 
Property ARExaPurpose As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = AR_ExaPurpose ];

/// 计费标志  AR_ChargeFlag 
Property ARChargeFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 7, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = AR_ChargeFlag ];

/// 检验标本  AR_SpecCode 
Property ARSpecCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = AR_SpecCode ];

/// 牙床图  AR_ToothBitmap 
Property ARToothBitmap As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = AR_ToothBitmap ];

/// 医嘱状态  AR_Status 
Property ARStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = AR_Status ];

/// 是否加急标志 AR_EmgFlag
Property AREmgFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = AR_EmgFlag ];

/// 是否医保标志 AR_CoverMainIns
Property ARCoverMainIns As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = AR_CoverMainIns ];

/// 是否医嘱阶段 AR_OrderStage
Property AROrderStage As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = AR_OrderStage ];

/// 附加医嘱信息 医嘱项id|||数量&医嘱项id|||数量&。。。。
/// tanjishan 2020.10.09暂时不用,使用DHC_AppRepPart表中的附加医嘱绑定功能
Property ARAppendOrderStr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = AR_AppendOrderStr ];

/// 标本采集部位
Property ARSpecCollectionSite As %Library.String [ SqlColumnNumber = 21, SqlFieldName = AR_SpecCollectionSite ];

/// 牙位信息
Property ARToothInfo As %Library.String(COLLATION = "Exact", MAXLEN = 30000000, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = AR_ToothInfo ];

/// 数量 AR_Qty
Property ARQty As User.OEOrdItem [ SqlColumnNumber = 23, SqlFieldName = AR_Qty ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="AR_AppendOrderStr">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AR_Arc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AR_ChargeFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AR_CoverMainIns">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AR_EmgFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AR_ExaPurpose">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AR_OrdItem">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AR_OrderStage">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AR_Pos_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AR_Qty">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AR_Remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AR_SpecCode">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AR_SpecCollectionSite">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AR_Status">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AR_ToothBitmap">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AR_ToothInfo">
<Node>"ToothInfo"</Node>
</Data>
<Global>^DHCAPREP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_AppReport.AR_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>AR_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_AppReport.AR_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AR_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOrdItem">
<Global>^DHCAPREP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_AppReport.AR_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>AR_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AR_OrdItem}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_AppReport.AR_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AR_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAppRepArcS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
