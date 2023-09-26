Class CKB.PDSS.FeedBack Extends (%Persistent, User.Abstract) [ SqlRowIdName = FB_RowID, SqlTableName = FeedBack ]
{

/// D ##class(CKB.PDSS.FeedBack).%BuildIndices()
/// FB_MsgID 监测日志表id
Property FBMsgID As CKB.PDSS.MonMaster [ SqlColumnNumber = 2, SqlFieldName = FB_MsgID ];

/// FB_User 干预人/开医嘱人
Property FBUser As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = FB_User ];

/// FB_Date 干预/开医嘱 日期
Property FBDate As %Date [ SqlColumnNumber = 4, SqlFieldName = FB_Date ];

/// FB_Time 干预/开医嘱 时间
Property FBTime As %Time [ SqlColumnNumber = 5, SqlFieldName = FB_Time ];

/// FB_OrdItem_Dr 医嘱
Property FBOrdItemDr As User.OEOrdItem [ SqlColumnNumber = 6, SqlFieldName = FB_OrdItem_Dr ];

/// FB_Status 干预状态 医护人员类型 R:(强制通过-Review)/F:(提醒错误-False)/T:(提醒正确-True)/P:(Pass-系统审核通过)
Property FBStatus As %String(MAXLEN = 100, VALUELIST = ",R,F,T,P,Y,N") [ SqlColumnNumber = 7, SqlFieldName = FB_Status ];

/// FB_UserType  Doc(医生)/Pha(药师)/Nur(护士)
Property FBUserType As %String(MAXLEN = 100, VALUELIST = ",Doc,Pha,Nur") [ SqlColumnNumber = 8, SqlFieldName = FB_UserType ];

/// FB_Notes 干预备注
Property FBNotes As %String(MAXLEN = 5000) [ SqlColumnNumber = 9, SqlFieldName = FB_Notes ];

/// FB_Reason 干预原因
Property FBReason As %String(MAXLEN = 5000) [ SqlColumnNumber = 10, SqlFieldName = FB_Reason ];

/// FB_Level 药品级别
Property FBLevel As %String(MAXLEN = 5000) [ SqlColumnNumber = 11, SqlFieldName = FB_Level ];

/// FB_Unique 药品唯一标识
Property FBUnique As %String(MAXLEN = 5000) [ SqlColumnNumber = 12, SqlFieldName = FB_Unique ];

/// FB_ArciName 医嘱项id 2021-06-18
Property FBArciId As %String(MAXLEN = 5000) [ SqlColumnNumber = 13, SqlFieldName = FB_ArciId ];

/// FB_ArciName 医嘱项名称 2021-06-18
Property FBArciName As %String(MAXLEN = 5000) [ SqlColumnNumber = 14, SqlFieldName = FB_ArciName ];

/// FB_SeqNo 医嘱项序号 2021-06-18
Property FBSeqNo As %String(MAXLEN = 5000) [ SqlColumnNumber = 15, SqlFieldName = FB_SeqNo ];

/// FB_PassFlag 通过审查标志 2021-06-18
Property FBPassFlag As %String(MAXLEN = 5000) [ SqlColumnNumber = 16, SqlFieldName = FB_PassFlag ];

/// FB_Params 入参的药品信息串 2021-06-18
Property FBParams As %String(MAXLEN = 5000) [ SqlColumnNumber = 17, SqlFieldName = FB_Params ];

/// FB_LastId 上一次药品记录的id(流转用-展示药品的变化) 2021-06-18
Property FBLastId As %String(MAXLEN = 5000) [ SqlColumnNumber = 18, SqlFieldName = FB_LastId ];

/// FB_Reason 干预原因combobox框
Property FBReasonCombo As %String [ SqlColumnNumber = 19, SqlFieldName = FB_ReasonCombo ];

Index MsgIDType On (FBMsgID As Exact, FBUserType As Exact);

Index OeorItem On (FBOrdItemDr As Exact, FBUserType As Exact);

Storage Default
{
<Data name="FeedBackDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FBMsgID</Value>
</Value>
<Value name="3">
<Value>FBUser</Value>
</Value>
<Value name="4">
<Value>FBDate</Value>
</Value>
<Value name="5">
<Value>FBTime</Value>
</Value>
<Value name="6">
<Value>FBOrdItemDr</Value>
</Value>
<Value name="7">
<Value>FBStatus</Value>
</Value>
<Value name="8">
<Value>FBUserType</Value>
</Value>
<Value name="9">
<Value>FBNotes</Value>
</Value>
<Value name="10">
<Value>FBReason</Value>
</Value>
<Value name="11">
<Value>FBLevel</Value>
</Value>
<Value name="12">
<Value>FBUnique</Value>
</Value>
<Value name="13">
<Value>FBArciId</Value>
</Value>
<Value name="14">
<Value>FBArciName</Value>
</Value>
<Value name="15">
<Value>FBSeqNo</Value>
</Value>
<Value name="16">
<Value>FBPassFlag</Value>
</Value>
<Value name="17">
<Value>FBParams</Value>
</Value>
<Value name="18">
<Value>FBLastId</Value>
</Value>
<Value name="19">
<Value>FBReasonCombo</Value>
</Value>
</Data>
<DataLocation>^CKB.PDSS.FeedBackD</DataLocation>
<DefaultData>FeedBackDefaultData</DefaultData>
<IdLocation>^CKB.PDSS.FeedBackD</IdLocation>
<IndexLocation>^CKB.PDSS.FeedBackI</IndexLocation>
<StreamLocation>^CKB.PDSS.FeedBackS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
