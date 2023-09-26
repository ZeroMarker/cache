/// 患者一次就诊中监区变化记录 PAAdm_ImprisonChange  
/// ^PAADM({PAIC_Adm_ParRef},"PAIC",{PAIC_Childsub})
/// Creator：tanjishan
/// CreatDate: 2017-10-11
Class User.PAAdmImprisonChange Extends %Persistent [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlRowIdName = PAIC_Rowid, SqlTableName = PAAdm_ImprisonChange, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On (PAICAdmParRef, PAICChildsub) [ IdKey, PrimaryKey, Unique ];

/// 就诊记录主索引
Property PAICAdmParRef As User.PAAdm [ InitialExpression = {$s($d(initvalue):initvalue,1:%d(2))}, SqlColumnNumber = 2, SqlFieldName = PAIC_Adm_ParRef ];

/// 子记录ID
Property PAICChildsub As %Numeric [ InitialExpression = {$i(^PAADM(+$s($d(initvalue):initvalue,1:%d(2)),"PAIC",0))}, SqlColumnNumber = 3, SqlFieldName = PAIC_Childsub ];

/// 原始监区
Property PAICOldEscortUnits As User.DHCCTEscortUnits [ SqlColumnNumber = 4, SqlFieldName = PAIC_OldEscortUnits ];

/// 新监区
Property PAICNewEscortUnits As User.DHCCTEscortUnits [ SqlColumnNumber = 5, SqlFieldName = PAIC_NewEscortUnits ];

/// 创建日期
Property PAICCreatDate As %Library.Date [ SqlColumnNumber = 6, SqlFieldName = PAIC_CreatDate ];

/// 创建时间
Property PAICCreatTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = PAIC_CreatTime ];

/// 创建人
Property PAICCreatUser As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = PAIC_CreatUser ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMap">
<Data name="PAIC_CreatDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PAIC_CreatTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PAIC_CreatUser">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PAIC_NewEscortUnits">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PAIC_OldEscortUnits">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PAIC_Adm_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PAIC_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PAIC_Adm_ParRef}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAIC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAIC_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PAIC_Rowid</SqlRowIdName>
<StreamLocation>^User.PAAdmImprisonChangeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
