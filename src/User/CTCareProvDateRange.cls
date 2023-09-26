/// CT Care Prov Date Range(1399)
Class User.CTCareProvDateRange Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_CareProvDateRange, StorageStrategy = SQLStorage ]
{

/// All From
Property CPDRAllFrom As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = CPDR_AllFrom ];

/// All To
Property CPDRAllTo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CPDR_AllTo ];

/// CC From
Property CPDRCCFrom As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = CPDR_CCFrom ];

/// CC To
Property CPDRCCTo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = CPDR_CCTo ];

/// Des Ref User
Property CPDRCTCPDR As SSUser [ SqlColumnNumber = 2, SqlFieldName = CPDR_CTCP_DR ];

/// Diag From
Property CPDRDiagFrom As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = CPDR_DiagFrom ];

/// Diag To
Property CPDRDiagTo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = CPDR_DiagTo ];

/// EvoFrom
Property CPDREvoFrom As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 26, SqlFieldName = CPDR_EvoFrom ];

/// Evo To
Property CPDREvoTo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 25, SqlFieldName = CPDR_EvoTo ];

/// Fixed date Range
Property CPDRFixeddateRange As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 29, SqlFieldName = CPDR_FixeddateRange ];

/// OF From
Property CPDROFFrom As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = CPDR_OFFrom ];

/// OF To
Property CPDROFTo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = CPDR_OFTo ];

/// PE From
Property CPDRPEFrom As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = CPDR_PEFrom ];

/// PE To
Property CPDRPETo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = CPDR_PETo ];

/// PI From
Property CPDRPIFrom As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = CPDR_PIFrom ];

/// PI To
Property CPDRPITo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = CPDR_PITo ];

/// Procedure From
Property CPDRProcFrom As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = CPDR_ProcFrom ];

/// Procedure To
Property CPDRProcTo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 24, SqlFieldName = CPDR_ProcTo ];

/// ROS From
Property CPDRROSFrom As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = CPDR_ROSFrom ];

/// ROS To
Property CPDRROSTo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = CPDR_ROSTo ];

/// ReFrom
Property CPDRReFrom As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = CPDR_ReFrom ];

/// ReTo
Property CPDRReTo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 27, SqlFieldName = CPDR_ReTo ];

/// Res From
Property CPDRResFrom As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = CPDR_ResFrom ];

/// Res To
Property CPDRResTo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = CPDR_ResTo ];

/// SCPT_All
Property CPDRSCPTAll As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 30, SqlFieldName = CPDR_SCPT_All ];

/// SCPT_CC
Property CPDRSCPTCC As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 31, SqlFieldName = CPDR_SCPT_CC ];

/// SCPT Diag
Property CPDRSCPTDiag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 32, SqlFieldName = CPDR_SCPT_Diag ];

/// SCPT Evolution
Property CPDRSCPTEvolution As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 39, SqlFieldName = CPDR_SCPT_Evolution ];

/// SCPT_Obj
Property CPDRSCPTObj As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 33, SqlFieldName = CPDR_SCPT_Obj ];

/// SCPT PhysExam
Property CPDRSCPTPhysExam As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 34, SqlFieldName = CPDR_SCPT_PhysExam ];

/// SCPT PresIllness
Property CPDRSCPTPresIllness As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 35, SqlFieldName = CPDR_SCPT_PresIllness ];

/// SCPT Review
Property CPDRSCPTReview As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 36, SqlFieldName = CPDR_SCPT_Review ];

/// SCPT RiskEval
Property CPDRSCPTRiskEval As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 40, SqlFieldName = CPDR_SCPT_RiskEval ];

/// SCPT Subj
Property CPDRSCPTSubj As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 37, SqlFieldName = CPDR_SCPT_Subj ];

/// SCPT Transfer
Property CPDRSCPTTransfer As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 38, SqlFieldName = CPDR_SCPT_Transfer ];

/// SF From
Property CPDRSFFrom As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = CPDR_SFFrom ];

/// SF To
Property CPDRSFTo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = CPDR_SFTo ];

/// TN From
Property CPDRTNFrom As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = CPDR_TNFrom ];

/// TN To
Property CPDRTNTo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = CPDR_TNTo ];

Index RowIDBasedIDKeyIndex On CPDRCTCPDR [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTCareProvDateRange).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTCareProvDateRange","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTCareProvDateRange).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTCareProvDateRange","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTCareProvDateRange).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTCareProvDateRange","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTCareProvDateRange).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTCareProvDateRange","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTCareProvDateRange).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTCareProvDateRange","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="CPDRAllFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CPDRAllTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CPDRCCFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CPDRCCTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CPDRCTCPDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="CPDRDiagFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CPDRDiagTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CPDREvoFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CPDREvoTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CPDRFixeddateRange">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CPDROFFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CPDROFTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CPDRPEFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CPDRPETo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CPDRPIFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CPDRPITo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CPDRProcFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CPDRProcTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CPDRROSFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CPDRROSTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CPDRReFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CPDRReTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CPDRResFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CPDRResTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CPDRSCPTAll">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CPDRSCPTCC">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CPDRSCPTDiag">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CPDRSCPTEvolution">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CPDRSCPTObj">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CPDRSCPTPhysExam">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CPDRSCPTPresIllness">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CPDRSCPTReview">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CPDRSCPTRiskEval">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CPDRSCPTSubj">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CPDRSCPTTransfer">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CPDRSFFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CPDRSFTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CPDRTNFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CPDRTNTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="CPDR_AllFrom">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CPDR_AllTo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CPDR_CCFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CPDR_CCTo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CPDR_DiagFrom">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CPDR_DiagTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CPDR_EvoFrom">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="CPDR_EvoTo">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="CPDR_FixeddateRange">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="CPDR_OFFrom">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CPDR_OFTo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CPDR_PEFrom">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CPDR_PETo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CPDR_PIFrom">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CPDR_PITo">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CPDR_ProcFrom">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="CPDR_ProcTo">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="CPDR_ROSFrom">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CPDR_ROSTo">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CPDR_ReFrom">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="CPDR_ReTo">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="CPDR_ResFrom">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CPDR_ResTo">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CPDR_SCPT_All">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="CPDR_SCPT_CC">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="CPDR_SCPT_Diag">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="CPDR_SCPT_Evolution">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="CPDR_SCPT_Obj">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="CPDR_SCPT_PhysExam">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="CPDR_SCPT_PresIllness">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="CPDR_SCPT_Review">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="CPDR_SCPT_RiskEval">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="CPDR_SCPT_Subj">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="CPDR_SCPT_Transfer">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="CPDR_SFFrom">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="CPDR_SFTo">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="CPDR_TNFrom">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="CPDR_TNTo">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Global>^COUNT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CPDR_CTCP_DR</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CPDR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CPDR_CTCP_DR}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>CPDR_RowId</SqlRowIdName>
<StreamLocation>^User.CTCareProvDateRangeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
