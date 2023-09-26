/// 患者收监信息记录 PAPerson_Imprison  
/// ^PAPER({PAI_PER_ParRef},"IMP",{PAI_Childsub})
/// ^PAPERi("IMPNumber",{PAI_PER_ParRef},{PAI_Childsub})
/// Creator：tanjishan
/// CreatDate: 2017-10-11
Class User.PAPersonImprison Extends %Persistent [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlRowIdName = PAI_Rowid, SqlTableName = PAPerson_Imprison, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On (PAIPERParRef, PAIChildsub) [ IdKey, PrimaryKey, Unique ];

/// 病人主索引
Property PAIPERParRef As User.PAPerson [ InitialExpression = {$s($d(initvalue):initvalue,1:%d(2))}, SqlColumnNumber = 2, SqlFieldName = PAI_PER_ParRef ];

/// 子记录ID
Property PAIChildsub As %Numeric [ InitialExpression = {$i(^PAPER(+$s($d(initvalue):initvalue,1:%d(2)),"IMP",0))}, SqlColumnNumber = 3, SqlFieldName = PAI_Childsub ];

/// 监禁编号
Property PAINumber As %String [ SqlColumnNumber = 4, SqlFieldName = PAI_Number ];

/// 入监日期
Property PAIInDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = PAI_InDate ];

/// 入监时间
Property PAIInTime As %Library.Time(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = PAI_InTime ];

/// 监狱
Property PAIEscortUnits As User.DHCCTEscortUnits [ SqlColumnNumber = 7, SqlFieldName = PAI_EscortUnits ];

/// 出监日期
Property PAIOutDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = PAI_OutDate ];

/// 出监时间
Property PAIOutTime As %Library.Time(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = PAI_OutTime ];

/// 创建日期
Property PAICreatDate As %Library.Date [ SqlColumnNumber = 10, SqlFieldName = PAI_CreatDate ];

/// 创建时间
Property PAICreatTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = PAI_CreatTime ];

/// 创建人
Property PAICreatUser As User.SSUser [ SqlColumnNumber = 12, SqlFieldName = PAI_CreatUser ];

/// 监区
Property PAIEscortUnitsRegions As User.DHCCTEscortUnitsRegions [ SqlColumnNumber = 13, SqlFieldName = PAI_EscortUnitsRegions ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMap">
<Data name="PAI_CreatDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PAI_CreatTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PAI_CreatUser">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PAI_EscortUnits">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PAI_EscortUnitsRegions">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PAI_InDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PAI_InTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PAI_Number">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PAI_OutDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PAI_OutTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^PAPER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PAI_PER_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PAI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PAI_PER_ParRef}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"IMP"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PAI_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexNumber">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAI_PER_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PAI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"IMPNumber"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAI_Number}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAI_PER_ParRef}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PAPI_Rowid</SqlRowIdName>
<StreamLocation>^User.PAPersonImprisonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
