/// Payor         (ARCIT,1111)
Class User.ARCInsuranceType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = ARC_InsuranceType, StorageStrategy = SQLStorage ]
{

Relationship ChildARCInsTypeDescr As ARCInsTypeDescr [ Cardinality = children, Inverse = DESParRef ];

/// Code
Property INSTCode As %String(COLLATION = "AlphaUp", MAXLEN = 40, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = INST_Code ];

/// Description
Property INSTDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = INST_Desc ];

/// Split Bills By Location
Property INSTSplitBillsByLoc As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = INST_SplitBillsByLoc ];

/// Category
Property INSTCategory As %String(MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",Medicaid,Medicare,Foreign,Auto,Labour,Veteran,CommonLaw,Private") [ SqlColumnNumber = 5, SqlFieldName = INST_Category ];

/// MultiPart
Property INSTMultiPart As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = INST_MultiPart ];

/// Ins. Batch Only
Property INSTInsBatchOnly As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = INST_InsBatchOnly ];

/// Des Ref InsType
Property INSTLinkInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 8, SqlFieldName = INST_LinkInsType_DR ];

/// Des Ref Priority
Property INSTPriorityDR As OECPriority [ SqlColumnNumber = 9, SqlFieldName = INST_Priority_DR ];

/// Des Ref Default AuxInsType
Property INSTDefaultAuxInsTypeDR As ARCAuxilInsurType [ SqlColumnNumber = 10, SqlFieldName = INST_DefaultAuxInsType_DR ];

/// Code1
Property INSTCode1 As %String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = INST_Code1 ];

/// Code2
Property INSTCode2 As %String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = INST_Code2 ];

/// Code3
Property INSTCode3 As %String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = INST_Code3 ];

/// Date From
Property INSTDateFrom As %Date [ SqlColumnNumber = 14, SqlFieldName = INST_DateFrom ];

/// Date To
Property INSTDateTo As %Date [ SqlColumnNumber = 15, SqlFieldName = INST_DateTo ];

/// Account Class
Property INSTAccountClass As PACAccountClass [ SqlColumnNumber = 16, SqlFieldName = INST_AccountClass ];

/// Unqualified Admission
Property INSTUnqualifiedAdm As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = INST_UnqualifiedAdm ];

/// Accommodation Type
Property INSTAccommodationType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = INST_AccommodationType ];

/// Program Funding Source
Property INSTProgramFundingSource As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = INST_ProgramFundingSource ];

/// Care Type
Property INSTCareType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = INST_CareType ];

/// Code4
Property INSTCode4 As %String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = INST_Code4 ];

/// Des Ref PayMode
Property INSTPayModeDR As CTPayMode [ SqlColumnNumber = 22, SqlFieldName = INST_PayMode_DR ];

/// DoNot Default/Copy
Property INSTDoNotDefaultCopy As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 23, SqlFieldName = INST_DoNotDefaultCopy ];

/// BillingLogic
Property INSTBillingLogic As %String(DISPLAYLIST = ",Bill Upon Ordering,Bill Upon Execution", MAXLEN = 19, TRUNCATE = 1, VALUELIST = ",BUO,BUE") [ SqlColumnNumber = 24, SqlFieldName = INST_BillingLogic ];

Index INSTCodeUnqIdx1 On INSTCode;

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCInsuranceType).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCInsuranceType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCInsuranceType).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCInsuranceType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCInsuranceType).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCInsuranceType","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCInsuranceType).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCInsuranceType","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCInsuranceType","OnBeforeInsert")
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCInsuranceType).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCInsuranceType","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^ARC("INST",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="INST_AccommodationType">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INST_AccountClass">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INST_BillingLogic">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INST_CareType">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INST_Category">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INST_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INST_Code1">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INST_Code2">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INST_Code3">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INST_Code4">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INST_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INST_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INST_DefaultAuxInsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INST_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INST_DoNotDefaultCopy">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INST_InsBatchOnly">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INST_LinkInsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INST_MultiPart">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INST_PayMode_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INST_Priority_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INST_ProgramFundingSource">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INST_SplitBillsByLoc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INST_UnqualifiedAdm">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>INST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INST_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({INST_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({INST_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INST_RowId</SqlRowIdName>
<StreamLocation>^User.ARCInsuranceTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
