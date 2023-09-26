/// Syndrome Differentration
Class User.DHCDocSyndDiff Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Synd_Rowid, SqlTableName = DHC_DocSyndDiff, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Synd_Adm_DR 就诊ID
Property SyndAdmDR As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = Synd_Adm_DR ];

/// Synd_MRDiag_DR 诊断ID
Property SyndMRDiagDR As User.MRDiagnos [ SqlColumnNumber = 3, SqlFieldName = Synd_MRDiag_DR ];

/// Synd_Sign 证
Property SyndSign As User.MRCDiagnosSignSymptom [ SqlColumnNumber = 4, SqlFieldName = Synd_Sign ];

/// Synd_User_DR 录入人
Property SyndUserDR As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = Synd_User_DR ];

/// Synd_Date 增加日期
Property SyndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = Synd_Date ];

/// Synd_Time 增加时间
Property SyndTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = Synd_Time ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCDocSYND)</SqlIdExpression>
<SQLMap name="IndexAdm">
<Global>^DHCDocSYND</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Synd_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Synd_Adm_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Synd_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOfSyndSign">
<Global>^DHCDocSYND</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SYN"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Synd_Sign}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Synd_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofDiagnos">
<Global>^DHCDocSYND</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Synd_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Diagnos"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Synd_MRDiag_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Synd_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="Synd_Adm_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Synd_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Synd_MRDiag_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Synd_Sign">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="Synd_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="Synd_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCDocSYND</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Synd_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{Synd_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCDocSyndDiffS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
