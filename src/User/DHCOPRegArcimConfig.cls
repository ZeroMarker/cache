Class User.DHCOPRegArcimConfig Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RowID, SqlTableName = DHC_OPRegArcimConfig, StorageStrategy = SQLStorage ]
{

Property OPRegArcimLoc As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = OPRegArcimLoc ];

Property OPRegArcimMark As User.CTCareProv [ SqlColumnNumber = 3, SqlFieldName = OPRegArcimMark ];

Property OPRegArcimSex As User.CTSex [ SqlColumnNumber = 4, SqlFieldName = OPRegArcimSex ];

Property OPRegArcimAgeRang As %String [ SqlColumnNumber = 5, SqlFieldName = OPRegArcimAgeRang ];

Property OPRegArcimPrior As %String [ SqlColumnNumber = 6, SqlFieldName = OPRegArcimPrior ];

Property OPRegArcimStr As %String [ SqlColumnNumber = 7, SqlFieldName = OPRegArcimStr ];

Property OPRegArcimHospID As User.CTHospital [ SqlColumnNumber = 8, SqlFieldName = OPRegArcimHospID ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCOPRegArcimConfig)</SqlIdExpression>
<SQLMap name="MasterMap">
<Data name="OPRegArcimAgeRang">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OPRegArcimHospID">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OPRegArcimLoc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OPRegArcimMark">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OPRegArcimPrior">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OPRegArcimSex">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OPRegArcimStr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCOPRegArcimConfig</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>RowID</SqlRowIdName>
<StreamLocation>^User.DHCOPRegArcimConfigS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
