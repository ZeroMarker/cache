/// 排班管理-班次
/// ^Code.PIVA.Schedul
Class User.PIVASchedul Extends (%Persistent, User.Abstract) [ Owner = {_SYSTEM}, SqlTableName = PIVA_Schedul, StorageStrategy = CacheSQLStorage ]
{

/// 配液中心
Property PSLocDr As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = PS_Loc_Dr ];

/// 班次代码
Property PSCode As %Library.String [ SqlColumnNumber = 3, SqlFieldName = PS_Code ];

/// 班次名称
Property PSDesc As %Library.String [ SqlColumnNumber = 4, SqlFieldName = PS_Desc ];

/// 班次简称
Property PSShortDesc As %Library.String [ SqlColumnNumber = 5, SqlFieldName = PS_ShortDesc ];

/// 上班时间
Property PSStartTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = PS_StartTime ];

/// 下班时间
Property PSEndTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = PS_EndTime ];

/// 班次类型
Property PSScheTypeDr As User.PIVASchedulType [ SqlColumnNumber = 8, SqlFieldName = PS_ScheType_Dr ];

/// 是否手工排班
Property PSCustomFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = PS_CustomFlag ];

/// 工作时长(小时)
Property PSDuration As %Float [ SqlColumnNumber = 10, SqlFieldName = PS_Duration ];

/// 班次固定日期(M:1!!D:211!!ME:1)
Property PSDays As %String [ SqlColumnNumber = 11, SqlFieldName = PS_Days ];

/// 间隔天数
Property PSInterval As %Float [ SqlColumnNumber = 12, SqlFieldName = PS_Interval ];

/// 关联班次
Property PSLinkSchedul As %String [ SqlColumnNumber = 13, SqlFieldName = PS_LinkSchedul ];

Storage CacheSQLStorage
{
<SqlIdExpression>$i(^Code.PIVA.Schedul(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PS_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PS_CustomFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PS_Days">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PS_Duration">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PS_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PS_Interval">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PS_LinkSchedul">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PS_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PS_ScheType_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PS_ShortDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PS_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^Code.PIVA.Schedul</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PS_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PS_RowId</SqlRowIdName>
<StreamLocation>^Code.PIVA.SchedulS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
