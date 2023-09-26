/// 标本拒收记录
Class dbo.RPVisitNumberRejectSpec Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumberRejectSpec, StorageStrategy = Default ]
{

/// Foreign Key FKRPVisitNumberRejectSpecBTRejectType created via DDL
ForeignKey FKRPVisitNumberRejectSpecBTRejectType(RejectTypeDR) References dbo.BTRejectType(PKBTREJECTTYPE) [ SqlName = FK_RP_VisitNumberRejectSpec_BT_RejectType ];

/// Foreign Key FKRPVisitNumberRejectSpecRPVisitNumber created via DDL
ForeignKey FKRPVisitNumberRejectSpecRPVisitNumber(VisitNumberDR) References dbo.RPVisitNumber(PKRPVISITNUMBER) [ SqlName = FK_RP_VisitNumberRejectSpec_RP_VisitNumber ];

/// Foreign Key FKRPVisitNumberRejectSpecSYSUser created via DDL
ForeignKey FKRPVisitNumberRejectSpecSYSUser(CreateUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RP_VisitNumberRejectSpec_SYS_User ];

/// Foreign Key FKRPVisitNumberRejectSpecSYSUser1 created via DDL
ForeignKey FKRPVisitNumberRejectSpecSYSUser1(OperateUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RP_VisitNumberRejectSpec_SYS_User1 ];

/// Foreign Key FKRPVisitNumberRejectSpecBTWorkGroup created via DDL
ForeignKey FKRPVisitNumberRejectSpecBTWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_RP_VisitNumberRejectSpec_BT_WorkGroup ];

Index IndexAdmNo On (AdmNo, VisitNumberDR) [ SqlName = Index_AdmNo, Type = index ];

Index IndexCreateUser On (CreateUserDR, VisitNumberDR) [ SqlName = Index_CreateUser, Type = index ];

Index IndexMaster On (CreateDate, CreateTime, VisitNumberDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexRecjectType On (RejectTypeDR, VisitNumberDR) [ SqlName = Index_RecjectType, Type = index ];

/// DDL Primary Key Specification
Index PKdboRPVisitNumberRejectSpec On RowID [ PrimaryKey, SqlName = "PK_dbo.RP_VisitNumberRejectSpec", Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 标本  
Property VisitNumberDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

/// 创建日期  
Property CreateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 创建时间  
Property CreateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 创建用户  
Property CreateUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 拒收说明  
Property RejectNotes As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 7 ];

/// 拒收类型  
Property RejectTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

/// 通知病人  
Property NoticePatient As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 9 ];

/// 通知电话  
Property NoticePhone As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 10 ];

/// 通知说明  
Property NoticeNotes As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 11 ];

/// 操作日期  
Property OperateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 操作时间  
Property OperateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 操作人  
Property OperateUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 操作说明  
Property OperateNotes As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 15 ];

/// 是否完成  {1:true,0:false}
Property IsFinish As %Library.Boolean [ SqlColumnNumber = 16 ];

/// 就诊号  
Property AdmNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 17 ];

/// 工作组  
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

/// 处理方法  
Property ProcessNotes As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 19 ];

/// 回退医嘱列表  
Property TestSets As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 20 ];

/// 是否只是记录
Property IsRecord As %Library.Boolean [ SqlColumnNumber = 21 ];

Storage Default
{
<Data name="RPVisitNumberRejectSpecDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberDR</Value>
</Value>
<Value name="3">
<Value>CreateDate</Value>
</Value>
<Value name="4">
<Value>CreateTime</Value>
</Value>
<Value name="5">
<Value>CreateUserDR</Value>
</Value>
<Value name="6">
<Value>RejectNotes</Value>
</Value>
<Value name="7">
<Value>RejectTypeDR</Value>
</Value>
<Value name="8">
<Value>NoticePatient</Value>
</Value>
<Value name="9">
<Value>NoticePhone</Value>
</Value>
<Value name="10">
<Value>NoticeNotes</Value>
</Value>
<Value name="11">
<Value>OperateDate</Value>
</Value>
<Value name="12">
<Value>OperateTime</Value>
</Value>
<Value name="13">
<Value>OperateUserDR</Value>
</Value>
<Value name="14">
<Value>OperateNotes</Value>
</Value>
<Value name="15">
<Value>IsFinish</Value>
</Value>
<Value name="16">
<Value>AdmNo</Value>
</Value>
<Value name="17">
<Value>WorkGroupDR</Value>
</Value>
<Value name="18">
<Value>ProcessNotes</Value>
</Value>
<Value name="19">
<Value>TestSets</Value>
</Value>
<Value name="20">
<Value>IsRecord</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberRejectSpecD</DataLocation>
<DefaultData>RPVisitNumberRejectSpecDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RPVisitNumberRejectSpecD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberRejectSpecI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberRejectSpecS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
