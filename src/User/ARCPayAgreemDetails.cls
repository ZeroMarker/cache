/// ARC Pay Agreem Details(1662)
Class User.ARCPayAgreemDetails Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_PayAgreemDetails, StorageStrategy = SQLStorage ]
{

/// Des Ref ARCIM1
Property DETARCIM1DR As ARCItmMast [ SqlColumnNumber = 5, SqlFieldName = DET_ARCIM1_DR ];

/// Des Ref ARCIM2
Property DETARCIM2DR As ARCItmMast [ SqlColumnNumber = 6, SqlFieldName = DET_ARCIM2_DR ];

/// AdmissionType
Property DETAdmissionType As %String(DISPLAYLIST = ",InPatient,OutPatient,Emergency,Health Promotion", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",I,O,E,H") [ SqlColumnNumber = 3, SqlFieldName = DET_AdmissionType ];

/// Childsub
Property DETChildsub As %Float [ InitialExpression = {$i(^ARC("PAY",$p(%d(0),$c(1)),"DET",0))}, SqlColumnNumber = 2, SqlFieldName = DET_Childsub ];

/// Des Ref EpisSubType
Property DETEpisSubTypeDR As PACEpisodeSubType [ SqlColumnNumber = 4, SqlFieldName = DET_EpisSubType_DR ];

/// Number1
Property DETNumber1 As %Float [ SqlColumnNumber = 12, SqlFieldName = DET_Number1 ];

/// Number10
Property DETNumber10 As %Float [ SqlColumnNumber = 21, SqlFieldName = DET_Number10 ];

/// Number11
Property DETNumber11 As %Float [ SqlColumnNumber = 36, SqlFieldName = DET_Number11 ];

/// Number12
Property DETNumber12 As %Float [ SqlColumnNumber = 22, SqlFieldName = DET_Number12 ];

/// Number13
Property DETNumber13 As %Float [ SqlColumnNumber = 23, SqlFieldName = DET_Number13 ];

/// Number14
Property DETNumber14 As %Float [ SqlColumnNumber = 24, SqlFieldName = DET_Number14 ];

/// Number15
Property DETNumber15 As %Float [ SqlColumnNumber = 25, SqlFieldName = DET_Number15 ];

/// Number16
Property DETNumber16 As %Float [ SqlColumnNumber = 26, SqlFieldName = DET_Number16 ];

/// Number17
Property DETNumber17 As %Float [ SqlColumnNumber = 27, SqlFieldName = DET_Number17 ];

/// Number18
Property DETNumber18 As %Float [ SqlColumnNumber = 28, SqlFieldName = DET_Number18 ];

/// Number19
Property DETNumber19 As %Float [ SqlColumnNumber = 29, SqlFieldName = DET_Number19 ];

/// Number2
Property DETNumber2 As %Float [ SqlColumnNumber = 13, SqlFieldName = DET_Number2 ];

/// Number20
Property DETNumber20 As %Float [ SqlColumnNumber = 30, SqlFieldName = DET_Number20 ];

/// Number3
Property DETNumber3 As %Float [ SqlColumnNumber = 14, SqlFieldName = DET_Number3 ];

/// Number4
Property DETNumber4 As %Float [ SqlColumnNumber = 15, SqlFieldName = DET_Number4 ];

/// Number5
Property DETNumber5 As %Float [ SqlColumnNumber = 16, SqlFieldName = DET_Number5 ];

/// Number6
Property DETNumber6 As %Float [ SqlColumnNumber = 17, SqlFieldName = DET_Number6 ];

/// Number7
Property DETNumber7 As %Float [ SqlColumnNumber = 18, SqlFieldName = DET_Number7 ];

/// Number8
Property DETNumber8 As %Float [ SqlColumnNumber = 19, SqlFieldName = DET_Number8 ];

/// Number9
Property DETNumber9 As %Float [ SqlColumnNumber = 20, SqlFieldName = DET_Number9 ];

/// ARC_PaymentAgreement Parent Reference
Relationship DETParRef As ARCPaymentAgreement [ Cardinality = parent, Inverse = ChildARCPayAgreemDetails, Required, SqlFieldName = DET_ParRef ];

/// Text1
Property DETText1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 31, SqlFieldName = DET_Text1 ];

/// Text2
Property DETText2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 32, SqlFieldName = DET_Text2 ];

/// Text3
Property DETText3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 33, SqlFieldName = DET_Text3 ];

/// Text4
Property DETText4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 34, SqlFieldName = DET_Text4 ];

/// Text5
Property DETText5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 35, SqlFieldName = DET_Text5 ];

/// YesNo1
Property DETYesNo1 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = DET_YesNo1 ];

/// YesNo2
Property DETYesNo2 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = DET_YesNo2 ];

/// YesNo3
Property DETYesNo3 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = DET_YesNo3 ];

/// YesNo4
Property DETYesNo4 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = DET_YesNo4 ];

/// YesNo5
Property DETYesNo5 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = DET_YesNo5 ];

Index RowIDBasedIDKeyIndex On DETChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemDetails).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemDetails","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemDetails).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemDetails","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemDetails).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemDetails","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCPayAgreemDetails).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemDetails","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCPayAgreemDetails).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemDetails","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DET_ARCIM1_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DET_ARCIM2_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DET_AdmissionType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DET_EpisSubType_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DET_Number1">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DET_Number10">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DET_Number11">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DET_Number12">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DET_Number13">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DET_Number14">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="DET_Number15">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="DET_Number16">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="DET_Number17">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="DET_Number18">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="DET_Number19">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="DET_Number2">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DET_Number20">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="DET_Number3">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DET_Number4">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DET_Number5">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DET_Number6">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DET_Number7">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DET_Number8">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DET_Number9">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DET_Text1">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="DET_Text2">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="DET_Text3">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="DET_Text4">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="DET_Text5">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="DET_YesNo1">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DET_YesNo2">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DET_YesNo3">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DET_YesNo4">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DET_YesNo5">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_PaymentAgreement.PAY_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DET_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DET"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DET_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DET_RowId</SqlRowIdName>
<StreamLocation>^User.ARCPayAgreemDetailsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
