/// CT Country               (CTCOU,20)
/// 国家地区
Class User.CTCountry Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_Country, StorageStrategy = SQLStorage ]
{

/// 数字代码
Property CTCOUCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = CTCOU_Code ];

/// 描述(中文简称)=CTCOU_CHNShortDesc
Property CTCOUDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = CTCOU_Desc ];

/// 是否有效
Property CTCOUActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 4, SqlFieldName = CTCOU_Active ];

/// 开始日期
Property CTCOUDateActiveFrom As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 5, SqlFieldName = CTCOU_DateActiveFrom ];

/// 结束日期
Property CTCOUDateActiveTo As %Date [ SqlColumnNumber = 6, SqlFieldName = CTCOU_DateActiveTo ];

/// Language DR
Property CTCOULanguageDR As SSLanguage [ SqlColumnNumber = 7, SqlFieldName = CTCOU_Language_DR ];

/// 英文简称 add@20220923
Property CTCOUENGShortDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = CTCOU_ENGShortDesc ];

/// 中文全称
Property CTCOUCHNFullDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = CTCOU_CHNFullDesc ];

/// 英文全称
Property CTCOUENGFullDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = CTCOU_ENGFullDesc ];

/// 罗马2字符代码
Property CTCOURomanCode2 As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = CTCOU_RomanCode2 ];

/// 罗马3字符代码
Property CTCOURomanCode3 As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = CTCOU_RomanCode3 ];

/// 系统创建日期
Property CTCOUCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 14, SqlFieldName = CTCOU_CreateDate ];

/// 系统创建时间
Property CTCOUCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 15, SqlFieldName = CTCOU_CreateTime ];

/// 系统创建人
Property CTCOUCreateUser As User.SSUser [ SqlColumnNumber = 16, SqlFieldName = CTCOU_CreateUser ];

/// 系统排序号
Property CTCOUSeqNo As %Float [ SqlColumnNumber = 17, SqlFieldName = CTCOU_SeqNo ];

/// 系统最后更新日期
Property CTCOULastUpdateDate As %Date [ SqlColumnNumber = 18, SqlFieldName = CTCOU_LastUpdateDate ];

/// 系统最后更新时间
Property CTCOULastUpdateTime As %Time [ SqlColumnNumber = 19, SqlFieldName = CTCOU_LastUpdateTime ];

/// 系统最新更新人
Property CTCOULastUpdateUser As User.SSUser [ SqlColumnNumber = 20, SqlFieldName = CTCOU_LastUpdateUser ];

/// 拼音码
Property CTCOUPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = CTCOU_PYCode ];

/// 五笔码
Property CTCOUWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = CTCOU_WBCode ];

/// 备注
Property CTCOUMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = CTCOU_Mark ];

Index CTCOUCodeUnqIdx1 On CTCOUCode [ Unique ];

Index CTCOUDescUnqIdx2 On CTCOUDesc [ Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTCountry).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCountry","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTCountry).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCountry","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTCountry).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCountry","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTCountry).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCountry","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTCountry).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCountry","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^CT("COU",0))</SqlIdExpression>
<SQLMap name="DataMasterCTCOU">
<Data name="CTCOU_Active">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CTCOU_CHNFullDesc">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CTCOU_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CTCOU_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CTCOU_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CTCOU_CreateUser">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CTCOU_DateActiveFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CTCOU_DateActiveTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CTCOU_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CTCOU_ENGFullDesc">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CTCOU_ENGShortDesc">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CTCOU_Language_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CTCOU_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CTCOU_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="CTCOU_LastUpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="CTCOU_Mark">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="CTCOU_PYCode">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="CTCOU_RomanCode2">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CTCOU_RomanCode3">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CTCOU_SeqNo">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CTCOU_WBCode">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CTCOU_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"COU"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CTCOU_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCTCOUCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTCOU_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"COU"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({CTCOU_Code})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CTCOU_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCTCOUDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTCOU_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"COU"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({CTCOU_Desc})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CTCOU_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CTCOU_RowId</SqlRowIdName>
<StreamLocation>^User.CTCountryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
