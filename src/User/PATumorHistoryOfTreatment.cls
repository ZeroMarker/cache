/// TumorHistoryOfTreatment(2335)
Class User.PATumorHistoryOfTreatment Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_TumorHistoryOfTreatment, StorageStrategy = SQLStorage ]
{

/// Childsub
Property HISChildsub As %Float [ InitialExpression = {$i(^PATUM($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"HIS",0))}, SqlColumnNumber = 2, SqlFieldName = HIS_Childsub ];

/// End Date
Property HISEndDate As %Date [ SqlColumnNumber = 5, SqlFieldName = HIS_EndDate ];

/// Des Ref HistoryOfTreatment
Property HISHistoryOfTreatmentDR As MRCHistoryOfTreatment [ SqlColumnNumber = 3, SqlFieldName = HIS_HistoryOfTreatment_DR ];

/// PA_Tumor Parent Reference
Relationship HISParRef As PATumor [ Cardinality = parent, Inverse = ChildPATumorHistoryOfTreatment, Required, SqlFieldName = HIS_ParRef ];

/// Start Date
Property HISStartDate As %Date [ SqlColumnNumber = 4, SqlFieldName = HIS_StartDate ];

Index RowIDBasedIDKeyIndex On HISChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 1;

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="HISChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="HISEndDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="HISHistoryOfTreatmentDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="HISParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="HISStartDate">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="Datamaster">
<Data name="HIS_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HIS_HistoryOfTreatment_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="HIS_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PATUM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Tumor.TUM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>HIS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Tumor.TUM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HIS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HIS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>HIS_RowId</SqlRowIdName>
<StreamLocation>^User.PATumorHistoryOfTreatmentS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
