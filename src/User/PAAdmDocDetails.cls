Class User.PAAdmDocDetails Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = PAAdm_DocDetails, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On AdmDocChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_Adm Parent Reference
Relationship AdmDocParRef As PAAdm [ Cardinality = parent, Inverse = ChildPAAdmDocDetails, Required, SqlFieldName = AdmDoc_ParRef ];

/// Childsub
Property AdmDocChildsub As %Float [ InitialExpression = {$i(^PAADM($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"DOCDETAIL",0))}, SqlColumnNumber = 2, SqlFieldName = AdmDoc_Childsub ];

/// 用户ID
Property AdmDocUserDR As SSUser [ SqlColumnNumber = 3, SqlFieldName = AdmDoc_UserDR ];

/// 就诊医生ID
Property AdmDocDocDR As CTCareProv [ SqlColumnNumber = 4, SqlFieldName = AdmDoc_DocDR ];

/// 就诊科室ID
Property AdmDocLocDR As CTLoc [ SqlColumnNumber = 5, SqlFieldName = AdmDoc_LocDR ];

/// 插入日期
Property AdmDocDate As %Date [ SqlColumnNumber = 6, SqlFieldName = AdmDoc_Date ];

/// 插入时间
Property AdmDocTime As %Time [ SqlColumnNumber = 7, SqlFieldName = AdmDoc_Time ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAAdmLab).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmDocDetails","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAAdmLab).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmDocDetails","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAAdmLab).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmDocDetails","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAAdmLab).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmDocDetails","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAAdmLab).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmDocDetails","OnBeforeUpdate")
}

Storage SQLStorage
{
<SQLMap name="Datamaster">
<Data name="AdmDoc_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AdmDoc_DocDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AdmDoc_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AdmDoc_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AdmDoc_UserDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>AdmDoc_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DOCDEATIL"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AdmDoc_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>AdmDoc_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdmDocDetailsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
