Class User.DHCInvprtMedical Extends (%Persistent, User.Abstract) [ SqlRowIdName = PRT_Rowid, SqlTableName = DHC_InvprtMedical, StorageStrategy = SQLStorage ]
{

/// PRT_PAPMI_DR
Property PRTPAPMIDR As %String [ Required, SqlColumnNumber = 2, SqlFieldName = PRT_PAPMI_DR ];

/// PRT_Acount
Property PRTAcount As %Text(MAXLEN = 30) [ Required, SqlColumnNumber = 3, SqlFieldName = PRT_Acount ];

/// PRT_inv
Property PRTinv As %Text(MAXLEN = 20) [ SqlColumnNumber = 4, SqlFieldName = PRT_inv ];

/// PRT_Date
Property PRTDate As %Date [ Required, SqlColumnNumber = 5, SqlFieldName = PRT_Date ];

/// PRT_Time
Property PRTTime As %Time [ Required, SqlColumnNumber = 6, SqlFieldName = PRT_Time ];

/// PRT_Flag
Property PRTFlag As %String(DISPLAYLIST = ",Normal,Abort,Strike,ToPaid", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",N,A,S,TP") [ Required, SqlColumnNumber = 7, SqlFieldName = PRT_Flag ];

/// PRT_PayMode_Dr
Property PRTPayModeDr As %String [ Required, SqlColumnNumber = 8, SqlFieldName = PRT_PayMode_Dr ];

/// PRT_DHCINVPRTR_DR
Property PRTDHCINVPRTRDR As %String [ SqlColumnNumber = 9, SqlFieldName = PRT_DHCINVPRTR_DR ];

/// PRT_Handin
Property PRTHandin As %String(DISPLAYLIST = ",Yes,No", SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = PRT_Handin ];

/// PRT_HandinDate
Property PRTHandinDate As %Date [ SqlColumnNumber = 11, SqlFieldName = PRT_HandinDate ];

/// PRT_HandinTime
Property PRTHandinTime As %Time [ SqlColumnNumber = 12, SqlFieldName = PRT_HandinTime ];

/// PRT_initInv_DR
Property PRTinitInvDR As %String [ SqlColumnNumber = 13, SqlFieldName = PRT_initInv_DR ];

/// PRT_PatType
Property PRTPatType As %Text(MAXLEN = 30) [ SqlColumnNumber = 14, SqlFieldName = PRT_PatType ];

/// PRT_Usr
Property PRTUsr As %String [ Required, SqlColumnNumber = 15, SqlFieldName = PRT_Usr ];

/// PRT_SocialStatus
Property PRTSocialStatus As %String(TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = PRT_SocialStatus ];

/// PRT_INVPrintFlag
Property PRTINVPrintFlag As %String(DISPLAYLIST = ",NoPrint,Printed", MAXLEN = 7, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",N,P") [ Required, SqlColumnNumber = 17, SqlFieldName = PRT_INVPrintFlag ];

/// PRT_ACCPINV_DR
Property PRTACCPINVDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = PRT_ACCPINV_DR ];

/// PRT_PayorShare
Property PRTPayorShare As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = PRT_PayorShare ];

/// PRT_DiscAmount
Property PRTDiscAmount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = PRT_DiscAmount ];

/// PRT_PatientShare
Property PRTPatientShare As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = PRT_PatientShare ];

/// PRT_InsType_DR
Property PRTInsTypeDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = PRT_InsType_DR ];

/// PRT_AllowRefund
Property PRTAllowRefund As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 23, SqlFieldName = PRT_AllowRefund ];

/// PRT_AllRefundUser
Property PRTAllRefundUser As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 24, SqlFieldName = PRT_AllRefundUser ];

/// PRT_AllRefundDate
Property PRTAllRefundDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 25, SqlFieldName = PRT_AllRefundDate ];

/// PRT_AllRefundTime
Property PRTAllRefundTime As %Library.Time [ SqlColumnNumber = 26, SqlFieldName = PRT_AllRefundTime ];

/// PRT_PFinRep_DR
Property PRTPFinRepDR As %Library.String(COLLATION = "Exact", MAXLEN = 19, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = PRT_PFinRep_DR ];

/// PRT_SfootTime
Property PRTSfootTime As %Library.Time [ SqlColumnNumber = 28, SqlFieldName = PRT_SfootTime ];

/// PRT_SfootUser
Property PRTSfootUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 29, SqlFieldName = PRT_SfootUser_DR ];

/// PRT_OldINV_DR
Property PRTOldINVDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 30, SqlFieldName = PRT_OldINV_DR ];

/// PRT_InsuDiv_DR
Property PRTInsuDivDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 31, SqlFieldName = PRT_InsuDiv_DR ];

/// PRT_OPPreSum
Property PRTOPPreSum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = PRT_OPPreSum ];

/// PRT_OPBackChange
Property PRTOPBackChange As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = PRT_OPBackChange ];

/// PRT_OPCRoundErr
Property PRTOPCRoundErr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = PRT_OPCRoundErr ];

///  PRT_UserLoc_dr
Property PRTUserLocdr As %String [ Required, SqlColumnNumber = 35, SqlFieldName = PRT_UserLoc_dr ];

/// PRT_Medical_DR
Property PRTMedicalDR As %String [ SqlColumnNumber = 36, SqlFieldName = PRT_Medical_DR ];

Relationship ChildDHCInvprtMedicalSub As User.DHCInvprtMedicalSub [ Cardinality = children, Inverse = InvMedParRef ];

Storage Default
{
<Data name="DHCInvprtMedicalDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PRTPAPMIDR</Value>
</Value>
<Value name="3">
<Value>PRTAcount</Value>
</Value>
<Value name="4">
<Value>PRTinv</Value>
</Value>
<Value name="5">
<Value>PRTDate</Value>
</Value>
<Value name="6">
<Value>PRTTime</Value>
</Value>
<Value name="7">
<Value>PRTFlag</Value>
</Value>
<Value name="8">
<Value>PRTPayModeDr</Value>
</Value>
<Value name="9">
<Value>PRTDHCINVPRTRDR</Value>
</Value>
<Value name="10">
<Value>PRTHandin</Value>
</Value>
<Value name="11">
<Value>PRTHandinDate</Value>
</Value>
<Value name="12">
<Value>PRTHandinTime</Value>
</Value>
<Value name="13">
<Value>PRTinitInvDR</Value>
</Value>
<Value name="14">
<Value>PRTPatType</Value>
</Value>
<Value name="15">
<Value>PRTUsr</Value>
</Value>
<Value name="16">
<Value>PRTSocialStatus</Value>
</Value>
<Value name="17">
<Value>PRTINVPrintFlag</Value>
</Value>
<Value name="18">
<Value>PRTACCPINVDR</Value>
</Value>
<Value name="19">
<Value>PRTPayorShare</Value>
</Value>
<Value name="20">
<Value>PRTDiscAmount</Value>
</Value>
<Value name="21">
<Value>PRTPatientShare</Value>
</Value>
<Value name="22">
<Value>PRTInsTypeDR</Value>
</Value>
<Value name="23">
<Value>PRTAllowRefund</Value>
</Value>
<Value name="24">
<Value>PRTAllRefundUser</Value>
</Value>
<Value name="25">
<Value>PRTAllRefundDate</Value>
</Value>
<Value name="26">
<Value>PRTAllRefundTime</Value>
</Value>
<Value name="27">
<Value>PRTPFinRepDR</Value>
</Value>
<Value name="28">
<Value>PRTSfootTime</Value>
</Value>
<Value name="29">
<Value>PRTSfootUserDR</Value>
</Value>
<Value name="30">
<Value>PRTOldINVDR</Value>
</Value>
<Value name="31">
<Value>PRTInsuDivDR</Value>
</Value>
<Value name="32">
<Value>PRTOPPreSum</Value>
</Value>
<Value name="33">
<Value>PRTOPBackChange</Value>
</Value>
<Value name="34">
<Value>PRTOPCRoundErr</Value>
</Value>
<Value name="35">
<Value>PRTUserLocdr</Value>
</Value>
</Data>
<DataLocation>^User.DHCInvprtMedicalD</DataLocation>
<DefaultData>DHCInvprtMedicalDefaultData</DefaultData>
<IdLocation>^User.DHCInvprtMedicalD</IdLocation>
<IndexLocation>^User.DHCInvprtMedicalI</IndexLocation>
<SqlIdExpression>$i(^User.DHCInvprtMedicalD)</SqlIdExpression>
<StreamLocation>^User.DHCInvprtMedicalS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="MasterMap">
<Data name="PRT_ACCPINV_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PRT_Acount">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PRT_AllRefundDate">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PRT_AllRefundTime">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PRT_AllRefundUser">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PRT_AllowRefund">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PRT_DHCINVPRTR_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PRT_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PRT_DiscAmount">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PRT_Flag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PRT_Handin">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PRT_HandinDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PRT_HandinTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PRT_INVPrintFlag">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PRT_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PRT_InsuDiv_DR">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="PRT_Medical_DR">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="PRT_OPBackChange">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="PRT_OPCRoundErr">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="PRT_OPPreSum">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="PRT_OldINV_DR">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="PRT_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PRT_PFinRep_DR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="PRT_PatType">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PRT_PatientShare">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PRT_PayMode_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PRT_PayorShare">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PRT_SfootTime">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="PRT_SfootUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="PRT_SocialStatus">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PRT_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PRT_UserLoc_dr">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="PRT_Usr">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PRT_initInv_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PRT_inv">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCINVPRTMEDICAL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PRT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PRT_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexinv">
<Global>^DHCINVPRTMEDICAL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PRT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INV"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PRT_inv}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PRT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PRT_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCInvprtMedicalS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
