/// 申请卡
Class dbo.RQCard Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RQ_Card, StorageStrategy = Default ]
{

/// Foreign Key FKCardAddUser created via DDL
ForeignKey FKCardAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_CardAddUser ];

/// Foreign Key FKCardCancelUser created via DDL
ForeignKey FKCardCancelUser(CancelUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_CardCancelUser ];

/// Foreign Key FKCardHospital created via DDL
ForeignKey FKCardHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_CardHospital ];

/// Foreign Key FKCardPat created via DDL
ForeignKey FKCardPat(PatientDR) References dbo.RQPatient(PKRQPATIENT) [ SqlName = FK_CardPat ];

/// Foreign Key FKCardType created via DDL
ForeignKey FKCardType(CardTypeDR) References dbo.BTCardType(PKBTCARDTYPE) [ SqlName = FK_CardType ];

Index IndexAddTime On (HospitalDR, AddDate) [ SqlName = Index_AddTime, Type = index ];

Index IndexCancelTime On (HospitalDR, CancelDate) [ SqlName = Index_CancelTime, Type = index ];

Index IndexMaster On (HospitalDR, CardTypeDR, CardNo) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexPerson On (PatientDR, HospitalDR, CardTypeDR, CardNo) [ SqlName = Index_Person, Type = index ];

/// DDL Primary Key Specification
Index PKRQCARD On RowID [ PrimaryKey, SqlName = PK_RQ_CARD, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 卡类型  
Property CardTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 卡号  
Property CardNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 5 ];

/// 使用病人  
Property PatientDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 状态  
Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 7 ];

/// 作废日期  
Property CancelDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 作废时间  
Property CancelTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 作废人  
Property CancelUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 建卡日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 建卡时间  
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 建卡人  
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Storage Default
{
<Data name="RQCardDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HospitalDR</Value>
</Value>
<Value name="3">
<Value>CardTypeDR</Value>
</Value>
<Value name="4">
<Value>CardNo</Value>
</Value>
<Value name="5">
<Value>PatientDR</Value>
</Value>
<Value name="6">
<Value>Status</Value>
</Value>
<Value name="7">
<Value>CancelDate</Value>
</Value>
<Value name="8">
<Value>CancelTime</Value>
</Value>
<Value name="9">
<Value>CancelUserDR</Value>
</Value>
<Value name="10">
<Value>AddDate</Value>
</Value>
<Value name="11">
<Value>AddTime</Value>
</Value>
<Value name="12">
<Value>AddUserDR</Value>
</Value>
</Data>
<DataLocation>^dbo.RQCardD</DataLocation>
<DefaultData>RQCardDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RQCardD</IdLocation>
<IndexLocation>^dbo.RQCardI</IndexLocation>
<StreamLocation>^dbo.RQCardS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
