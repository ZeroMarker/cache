Class User.DHCAppPisGynWon Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AP_RowID, SqlTableName = DHC_AppPisGynWon, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On APChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_AppPisMaster Parent Reference AP_ParRef_Dr
Relationship APParRefDr As User.DHCAppPisMaster [ Cardinality = parent, Inverse = ChildDHCAPPPISGYNWON, Required, SqlFieldName = AP_ParRef_Dr ];

/// AP_ChildSub
Property APChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = AP_ChildSub ];

/// 上次月经日期  AP_LastMensDate 
Property APLastMensDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = AP_LastMensDate ];

/// 末次月经日期  AP_MensDate 
Property APMensDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = AP_MensDate ];

/// 是否绝经  AP_PauFlag
Property APPauFlag As %Library.String [ SqlColumnNumber = 5, SqlFieldName = AP_PauFlag ];

/// 怀孕次数  AP_PreTimes
Property APPreTimes As %Library.String [ SqlColumnNumber = 6, SqlFieldName = AP_PreTimes ];

/// 生产次数  AP_LyTimes
Property APLyTimes As %Library.String [ SqlColumnNumber = 7, SqlFieldName = AP_LyTimes ];

///  初孕年龄 AP_PreAge
Property APPreAge As %Library.String [ SqlColumnNumber = 8, SqlFieldName = AP_PreAge ];

///  初产年龄 AP_LyAge
Property APLyAge As %Library.String [ SqlColumnNumber = 9, SqlFieldName = AP_LyAge ];

///  宫颈手术史 AP_CsHistory
Property APCsHistory As %Library.String [ SqlColumnNumber = 10, SqlFieldName = AP_CsHistory ];

///  是否有性生活史 AP_SexHistory
Property APSexHistory As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = AP_SexHistory ];

///  妇科疾病史 AP_GyHistory
Property APGyHistory As %Library.String [ SqlColumnNumber = 12, SqlFieldName = AP_GyHistory ];

///  妇科治疗史 AP_GyTreatHistory
Property APGyTreatHistory As %Library.String [ SqlColumnNumber = 13, SqlFieldName = AP_GyTreatHistory ];

///  既往阴道镜检查结果 AP_RepResultRes
Property APRepResultRes As %Library.String [ SqlColumnNumber = 14, SqlFieldName = AP_RepResultRes ];

/// 是否怀孕  AP_PreFlag
Property APPreFlag As %Library.String [ SqlColumnNumber = 15, SqlFieldName = AP_PreFlag ];

///  月经史--不详 AP_MenUnknown
Property APMenUnknown As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = AP_MenUnknown ];

///  月经史--子宫异常出血 AP_AbnBleed
Property APAbnBleed As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = AP_AbnBleed ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="AP_AbnBleed">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AP_CsHistory">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AP_GyHistory">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AP_GyTreatHistory">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AP_LastMensDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AP_LyAge">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AP_LyTimes">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AP_MenUnknown">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AP_MensDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AP_PauFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AP_PreAge">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AP_PreFlag">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AP_PreTimes">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AP_RepResultRes">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AP_SexHistory">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
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
<Expression>"G"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AP_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAppPisGynWonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
