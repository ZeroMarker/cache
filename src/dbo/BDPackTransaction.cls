/// 血袋处理
Class dbo.BDPackTransaction Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_PackTransaction, StorageStrategy = Default ]
{

/// Foreign Key FKBDPTransLocation created via DDL
ForeignKey FKBDPTransLocation(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_BD_PTrans_Location ];

/// Foreign Key FKBDPTransNewReq created via DDL
ForeignKey FKBDPTransNewReq(NewReqDR) References dbo.BDReqForm(PKBDREQFORM) [ SqlName = FK_BD_PTrans_NewReq ];

/// Foreign Key FKBDPTransPStatus created via DDL
ForeignKey FKBDPTransPStatus(NewPackStatusDR) References dbo.BBPackStatus(PKBBPACKSTATUS) [ SqlName = FK_BD_PTrans_PStatus ];

/// Foreign Key FKBDPTransPack created via DDL
ForeignKey FKBDPTransPack(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_BD_PTrans_Pack ];

/// Foreign Key FKBDPTransTrans created via DDL
ForeignKey FKBDPTransTrans(TransactionDR) References dbo.BBTransaction(PKBBTRANSACTION) [ SqlName = FK_BD_PTrans_Trans ];

/// Foreign Key FKBDPTransTransUser created via DDL
ForeignKey FKBDPTransTransUser(TransUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_PTrans_TransUser ];

/// Foreign Key FKBDPTransUseReq created via DDL
ForeignKey FKBDPTransUseReq(UseReqDR) References dbo.BDReqForm(PKBDREQFORM) [ SqlName = FK_BD_PTrans_UseReq ];

/// Foreign Key FKBDPTransWorkGroup created via DDL
ForeignKey FKBDPTransWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BD_PTrans_WorkGroup ];

Index IndexPack On PackDR [ SqlName = Index_Pack, Type = index ];

Index IndexTransDate On TransDate [ SqlName = Index_TransDate, Type = index ];

Index IndexTransaction On (TransactionDR, TransDate) [ SqlName = Index_Transaction, Type = index ];

/// DDL Primary Key Specification
Index PKBDPACKTRANSACTION On RowID [ PrimaryKey, SqlName = PK_BD_PACKTRANSACTION, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 血袋信息  
Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 处理日期  
Property TransDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 处理时间  
Property TransTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 处理人  
Property TransUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 处理事件  
Property TransactionDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 当前使用病人登记号  
Property UsePatientRegNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 8 ];

/// 当前使用的申请单  
Property UseReqDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 处理后状态  
Property NewPackStatusDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 10 ];

/// 处理后使用病人登记号  
Property NewPatientRegNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 11 ];

/// 使用的申请单  
Property NewReqDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 工作组  
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 临床科室  
Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 备注  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 15 ];

/// 是否删除  {1:true,0:false}
Property IsRemoved As %Library.Boolean [ SqlColumnNumber = 16 ];

Storage Default
{
<Data name="BDPackTransactionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PackDR</Value>
</Value>
<Value name="3">
<Value>TransDate</Value>
</Value>
<Value name="4">
<Value>TransTime</Value>
</Value>
<Value name="5">
<Value>TransUserDR</Value>
</Value>
<Value name="6">
<Value>TransactionDR</Value>
</Value>
<Value name="7">
<Value>UsePatientRegNo</Value>
</Value>
<Value name="8">
<Value>UseReqDR</Value>
</Value>
<Value name="9">
<Value>NewPackStatusDR</Value>
</Value>
<Value name="10">
<Value>NewPatientRegNo</Value>
</Value>
<Value name="11">
<Value>NewReqDR</Value>
</Value>
<Value name="12">
<Value>WorkGroupDR</Value>
</Value>
<Value name="13">
<Value>LocationDR</Value>
</Value>
<Value name="14">
<Value>Remark</Value>
</Value>
<Value name="15">
<Value>IsRemoved</Value>
</Value>
</Data>
<DataLocation>^dbo.BDPackTransactionD</DataLocation>
<DefaultData>BDPackTransactionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDPackTransactionD</IdLocation>
<IndexLocation>^dbo.BDPackTransactionI</IndexLocation>
<StreamLocation>^dbo.BDPackTransactionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
