/// PersonAdmInsurance(2573)
Class User.PAPersonAdmInsurance Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_PersonAdmInsurance, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PAINSChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_Person Parent Reference
Relationship PAINSParRef As PAPerson [ Cardinality = parent, Inverse = ChildPAPersonAdmInsurance, Required, SqlFieldName = PAINS_ParRef ];

/// Childsub
Property PAINSChildsub As %Float [ InitialExpression = {$i(^PAPER($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"PAINS",0))}, SqlColumnNumber = 2, SqlFieldName = PAINS_Childsub ];

/// CardNo
Property PAINSCardNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PAINS_CardNo ];

/// DateTypeFrom
Property PAINSDateTypeFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = PAINS_DateTypeFrom ];

/// DateTypeTo
Property PAINSDateTypeTo As %Date [ SqlColumnNumber = 5, SqlFieldName = PAINS_DateTypeTo ];

/// DateValidFrom
Property PAINSDateValidFrom As %Date [ SqlColumnNumber = 6, SqlFieldName = PAINS_DateValidFrom ];

/// DateValidTo
Property PAINSDateValidTo As %Date [ SqlColumnNumber = 7, SqlFieldName = PAINS_DateValidTo ];

/// Des Ref AuxInsType
Property PAINSAuxInsTypeDR As ARCAuxilInsurType [ SqlColumnNumber = 8, SqlFieldName = PAINS_AuxInsType_DR ];

/// Des Ref InsType
Property PAINSInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 9, SqlFieldName = PAINS_InsType_DR ];

/// Des Ref CardType
Property PAINSCardTypeDR As PACCardType [ SqlColumnNumber = 10, SqlFieldName = PAINS_CardType_DR ];

/// ApplyGST
Property PAINSApplyGST As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = PAINS_ApplyGST ];

/// Rank
Property PAINSRank As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = PAINS_Rank ];

/// UpdateDate
Property PAINSUpdateDate As %Date [ SqlColumnNumber = 13, SqlFieldName = PAINS_UpdateDate ];

/// UpdateTime
Property PAINSUpdateTime As %Time [ SqlColumnNumber = 14, SqlFieldName = PAINS_UpdateTime ];

/// Des Ref UpdateUser
Property PAINSUpdateUserDR As SSUser [ SqlColumnNumber = 15, SqlFieldName = PAINS_UpdateUser_DR ];

/// Des Ref UpdateUserHospital
Property PAINSUpdateUserHospitalDR As CTHospital [ SqlColumnNumber = 16, SqlFieldName = PAINS_UpdateUserHospital_DR ];

/// PayorVariationComments
Property PAINSPayorVariationComments As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = PAINS_PayorVariationComments, SqlListType = subnode ];

/// CardholderId
Property PAINSCardholderId As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = PAINS_CardholderId ];

/// CardholderName
Property PAINSCardholderName As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = PAINS_CardholderName ];

/// Des Ref CTREL
Property PAINSCTRELDR As CTRelation [ SqlColumnNumber = 20, SqlFieldName = PAINS_CTREL_DR ];

/// PersonResponsible
Property PAINSPersonResponsible As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = PAINS_PersonResponsible ];

/// Des Ref Spec
Property PAINSSpecDR As CTSpec [ SqlColumnNumber = 22, SqlFieldName = PAINS_Spec_DR ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PAPersonAdmInsurance).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonAdmInsurance","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PAPersonAdmInsurance).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonAdmInsurance","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PAPersonAdmInsurance).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonAdmInsurance","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PAPersonAdmInsurance).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonAdmInsurance","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonAdmInsurance","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PAPersonAdmInsurance).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonAdmInsurance","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PAINS_ApplyGST">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PAINS_AuxInsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PAINS_CTREL_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PAINS_CardNo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PAINS_CardType_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PAINS_CardholderId">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PAINS_CardholderName">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PAINS_DateTypeFrom">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PAINS_DateTypeTo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PAINS_DateValidFrom">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PAINS_DateValidTo">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PAINS_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PAINS_PayorVariationComments">
<Node>"VAR"</Node>
</Data>
<Data name="PAINS_PersonResponsible">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PAINS_Rank">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PAINS_Spec_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PAINS_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PAINS_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PAINS_UpdateUserHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PAINS_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Global>^PAPER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PAINS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAINS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAINS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PAINS_RowId</SqlRowIdName>
<StreamLocation>^User.PAPersonAdmInsuranceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
