Class dbo.BDPatDifficultMatchRecord Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_PatDifficultMatchRecord, StorageStrategy = Default ]
{

Index IndexRegNo On RegNo [ SqlName = Index_RegNo, Type = index ];

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

/// DDL Primary Key Specification
Index PKBDPATDIFFiCULTMATCHRECORD On RowID [ PrimaryKey, SqlName = PK_BD_PATDIFFiCULTMATCHRECORD, Type = index, Unique ];

/// Foreign Key FKBDReqAddUser created via DDL
ForeignKey FKBDPatDMRecDiffMatch(DifficultMatchDR) References dbo.BBDifficultMatch(PKBBDIFFICULTMATCH) [ SqlName = FK_BD_PatDMRec_DiffMatch ];

/// Foreign Key FKBDReqAddUser created via DDL
ForeignKey FKBDPatDMRecAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_PatDMRec_AddUser ];

/// Foreign Key FKBDReqAddUser created via DDL
ForeignKey FKBDPatDMRecReqForm(ReqFormDR) References dbo.BDReqForm(PKBDREQFORM) [ SqlName = FK_BD_PatDMRec_ReqForm ];

/// RowID
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 登记号
Property RegNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

/// 登记号
Property ReqFormDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 疑难类型
Property DifficultMatchDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 创建日期
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 创建时间
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 创建用户
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 备注
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BDPatDifficultMatchRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RegNo</Value>
</Value>
<Value name="3">
<Value>ReqFormDR</Value>
</Value>
<Value name="4">
<Value>DifficultMatchDR</Value>
</Value>
<Value name="5">
<Value>AddDate</Value>
</Value>
<Value name="6">
<Value>AddTime</Value>
</Value>
<Value name="7">
<Value>AddUserDR</Value>
</Value>
<Value name="8">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.BDPatDifficultMatchRecordD</DataLocation>
<DefaultData>BDPatDifficultMatchRecordDefaultData</DefaultData>
<IdLocation>^dbo.BDPatDifficultMatchRecordD</IdLocation>
<IndexLocation>^dbo.BDPatDifficultMatchRecordI</IndexLocation>
<StreamLocation>^dbo.BDPatDifficultMatchRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
