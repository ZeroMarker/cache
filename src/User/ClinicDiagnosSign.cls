Class User.ClinicDiagnosSign Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, ProcedureBlock, SqlRowIdName = CDSS_Rowid, SqlTableName = DHC_ClinicDiagnosSign, StorageStrategy = SQLStorage ]
{

Property ClinicGroupDr As RBCClinicGroup [ SqlColumnNumber = 2, SqlFieldName = CDSS_ClinicGroup_Dr ];

Property MRCDSSDr As MRCDiagnosSignSymptom [ SqlColumnNumber = 3, SqlFieldName = CDSS_MRCDSS_Dr ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ClinicDiagnosSign).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CliniciagnosSign","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ClinicDiagnosSign).OnTrigger($g(%d(1)))             
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ClinicDiagnosSign","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ClinicDiagnosSign).OnTrigger($g(%d(1))) 
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ClinicDiagnosSign","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ClinicDiagnosSign).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ClinicDiagnosSign","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ClinicDiagnosSign).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ClinicDiagnosSign","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCClinicDSS)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CDSS_ClinicGroup_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CDSS_MRCDSS_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCClinicDSS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CDSS_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{CDSS_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>CDSS_Rowid</SqlRowIdName>
<StreamLocation>^User.ClinicDiagnosSignS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
