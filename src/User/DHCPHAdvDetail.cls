Class User.DHCPHAdvDetail Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = PHAD_RowID, SqlTableName = DHC_PHAdvDetail, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHADChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHAdvice Parent Reference
Relationship PHADPHAParref As User.DHCPHAdvice [ Cardinality = parent, Inverse = ChildDHCPHAdvDetail, Required, SqlFieldName = PHAD_PHA_Parref ];

/// PHAD_ChildSub
Property PHADChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PHAD_ChildSub ];

/// PHAD_Advice  建议/申诉内容
Property PHADAdvice As %Library.String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PHAD_Advice ];

/// PHAD_User_Dr  用户
Property PHADUserDr As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = PHAD_User_Dr ];

/// PHAD_Date  日期
Property PHADDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = PHAD_Date ];

/// PHAD_Time  时间
Property PHADTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = PHAD_Time ];

/// PHAD_FLAG  匿名标志
Property PHADFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PHAD_FLAG ];

/// PHAD_Rational  
Property PHADRational As %Library.Integer [ SqlColumnNumber = 9, SqlFieldName = PHAD_Rational ];

/// PHAD_Problem  
Property PHADProblem As %Library.Integer [ SqlColumnNumber = 10, SqlFieldName = PHAD_Problem ];

///  建议类型串 指向User.DHCPHMedAdvTemp
Property PHADAdviceType As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PHAD_AdviceType ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PHAD_Advice">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHAD_AdviceType">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHAD_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHAD_FLAG">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHAD_Problem">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHAD_Rational">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHAD_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHAD_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHAD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHAdvice.PHA_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHAD_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHAdvice.PHA_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AD"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHAD_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHAdvDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
