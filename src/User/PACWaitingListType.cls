/// PAC Waiting List Type(1476)
Class User.PACWaitingListType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_WaitingListType, StorageStrategy = SQLStorage ]
{

Relationship ChildPACWLTypeOfListCriteria As PACWLTypeOfListCriteria [ Cardinality = children, Inverse = CRITParREf ];

Relationship ChildPACWLTypeMRRequirements As PACWLTypeMRRequirements [ Cardinality = children, Inverse = MRParRef ];

Relationship ChildPACWLTypeKeywords As PACWLTypeKeywords [ Cardinality = children, Inverse = KEYWParRef ];

/// Code
Property WLTCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = WLT_Code ];

/// Description
Property WLTDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = WLT_Desc ];

/// Type
Property WLTType As %String(DISPLAYLIST = ",OutPatient,InPatient", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",O,I") [ SqlColumnNumber = 4, SqlFieldName = WLT_Type ];

/// Off List Criteria
Property WLTOffListCriteria As %String(DISPLAYLIST = ",On Discharge,On Registration,On Operation Entry", MAXLEN = 18, TRUNCATE = 1, VALUELIST = ",D,R,E") [ SqlColumnNumber = 5, SqlFieldName = WLT_OffListCriteria ];

/// Operation Booking Required
Property WLTOperBookRequired As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = WLT_OperBookRequired ];

/// Appointement Required
Property WLTAppointmentRequired As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = WLT_AppointmentRequired ];

/// Preadm Required
Property WLTPreadmRequired As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = WLT_PreadmRequired ];

/// Main MR Required
Property WLTMainMRRequired As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = WLT_MainMRRequired ];

/// Date From
Property WLTDateFrom As %Date [ SqlColumnNumber = 10, SqlFieldName = WLT_DateFrom ];

/// Date To
Property WLTDateTo As %Date [ SqlColumnNumber = 11, SqlFieldName = WLT_DateTo ];

/// Des Ref Hospital
Property WLTHospitalDR As CTHospital [ SqlColumnNumber = 12, SqlFieldName = WLT_Hospital_DR ];

/// Des Ref CTLOC
Property WLTCTLOCDR As CTLoc [ SqlColumnNumber = 13, SqlFieldName = WLT_CTLOC_DR ];

/// Des Ref CareProv
Property WLTCareProvDR As CTCareProv [ SqlColumnNumber = 14, SqlFieldName = WLT_CareProv_DR ];

/// National Code
Property WLTNationalCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = WLT_NationalCode ];

Index WLTCodeUnqIdx1 On WLTCode [ Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACWaitingListType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWaitingListType","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACWaitingListType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWaitingListType","OnAfterInsert")
 
 d POFILINS^at1476
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACWaitingListType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWaitingListType","OnAfterUpdate")
 
 d POFILUPD^at1476
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACWaitingListType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWaitingListType","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACWaitingListType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWaitingListType","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("WLT",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="WLT_AppointmentRequired">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="WLT_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="WLT_CareProv_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="WLT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WLT_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="WLT_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="WLT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="WLT_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="WLT_MainMRRequired">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="WLT_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="WLT_OffListCriteria">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="WLT_OperBookRequired">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="WLT_PreadmRequired">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="WLT_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>WLT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WLT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WLT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WLT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WLT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({WLT_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WLT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WLT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WLT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({WLT_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WLT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>WLT_RowId</SqlRowIdName>
<StreamLocation>^User.PACWaitingListTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
