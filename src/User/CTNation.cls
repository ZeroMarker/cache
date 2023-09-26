/// 民族字典         (CTNAT,537)
Class User.CTNation Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_Nation, StorageStrategy = SQLStorage ]
{

/// 民族数字代码
Property CTNATCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = CTNAT_Code ];

/// 民族名称
Property CTNATDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = CTNAT_Desc ];

/// 民族罗马代码
Property CTNATRomanCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = CTNAT_RomanCode ];

/// 民族罗马名称
Property CTNATRomanDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = CTNAT_RomanDesc ];

/// 民族外国名称
Property CTNATForeignDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = CTNAT_ForeignDesc ];

/// 是否有效(Y/N)
Property CTNATActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 7, SqlFieldName = CTNAT_Activity ];

/// 开始日期
Property CTNATStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 8, SqlFieldName = CTNAT_StartDate ];

/// 结束日期
Property CTNATEndDate As %Date [ SqlColumnNumber = 9, SqlFieldName = CTNAT_EndDate ];

/// 系统创建日期
Property CTNATCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 10, SqlFieldName = CTNAT_CreateDate ];

/// 系统创建时间
Property CTNATCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 11, SqlFieldName = CTNAT_CreateTime ];

/// 系统创建人
Property CTNATCreateUser As User.SSUser [ SqlColumnNumber = 12, SqlFieldName = CTNAT_CreateUser ];

/// 系统排序号
Property CTNATSeqNo As %Float [ SqlColumnNumber = 13, SqlFieldName = CTNAT_SeqNo ];

/// 系统最后更新日期
Property CTNATLastUpdateDate As %Date [ SqlColumnNumber = 14, SqlFieldName = CTNAT_LastUpdateDate ];

/// 系统最后更新时间
Property CTNATLastUpdateTime As %Time [ SqlColumnNumber = 15, SqlFieldName = CTNAT_LastUpdateTime ];

/// 系统最新更新人
Property CTNATLastUpdateUser As User.SSUser [ SqlColumnNumber = 16, SqlFieldName = CTNAT_LastUpdateUser ];

/// 拼音码
Property CTNATPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = CTNAT_PYCode ];

/// 五笔码
Property CTNATWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = CTNAT_WBCode ];

/// 备注
Property CTNATMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = CTNAT_Mark ];

Index CTNATCodeUnqIdx1 On CTNATCode [ Unique ];

Index CTNATDescUnqIdx2 On CTNATDesc [ Unique ];

Parameter EXTENTSIZE = 10;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTNation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTNation","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTNation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTNation","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTNation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTNation","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTNation).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTNation","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTNation).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTNation","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>10</ExtentSize>
<Property name="CTNATCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="CTNATDesc">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^CT("NAT",0))</SqlIdExpression>
<SQLMap name="DataMasterCTNAT">
<Data name="CTNAT_Activity">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CTNAT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CTNAT_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CTNAT_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CTNAT_CreateUser">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CTNAT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CTNAT_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CTNAT_ForeignDesc">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CTNAT_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CTNAT_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CTNAT_LastUpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CTNAT_Mark">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="CTNAT_PYCode">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CTNAT_RomanCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CTNAT_RomanDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CTNAT_SeqNo">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CTNAT_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CTNAT_WBCode">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CTNAT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"NAT"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CTNAT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCTNATCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTNAT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"NAT"</Expression>
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
<Expression>$$ALPHAUP({CTNAT_Code})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CTNAT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCTNATDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTNAT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"NAT"</Expression>
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
<Expression>$$ALPHAUP({CTNAT_Desc})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CTNAT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CTNAT_RowId</SqlRowIdName>
<StreamLocation>^User.CTNationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
