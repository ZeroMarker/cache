Class dbo.BBNoticeBoard Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_NoticeBoard, StorageStrategy = Default ]
{

/// Foreign Key FKBBAgreeHospital created via DDL
ForeignKey FKBBNoticeBoardHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BB_NoticeBoard_Hospital ];

ForeignKey FKBBNoticeBoardLastUser(LastUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BB_NoticeBoard_LastUser ];

Index IndexSeqNum On (HospitalDR, SeqNum) [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBBNOTICEBOARD On RowID [ PrimaryKey, SqlName = PK_BB_NOTICEBOARD, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 名称  
Property Description As %Library.String(MAXLEN = 200) [ Required, SqlColumnNumber = 3 ];

/// 序号  
Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 激活  
Property Active As %Library.Boolean [ SqlColumnNumber = 5 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 创建日期  
Property LastDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 创建时间  
Property LastTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 创建人  
Property LastUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BBNoticeBoardDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>SeqNum</Value>
</Value>
<Value name="4">
<Value>Active</Value>
</Value>
<Value name="5">
<Value>HospitalDR</Value>
</Value>
<Value name="6">
<Value>LastDate</Value>
</Value>
<Value name="7">
<Value>LastTime</Value>
</Value>
<Value name="8">
<Value>LastUserDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BBNoticeBoardD</DataLocation>
<DefaultData>BBNoticeBoardDefaultData</DefaultData>
<IdLocation>^dbo.BBNoticeBoardD</IdLocation>
<IndexLocation>^dbo.BBNoticeBoardI</IndexLocation>
<StreamLocation>^dbo.BBNoticeBoardS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
