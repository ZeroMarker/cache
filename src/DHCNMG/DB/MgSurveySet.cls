/// Creator: guozj
/// Createdate: 2017-12-21
/// Description：患者满意度调查设置【南方医院版】
Class DHCNMG.DB.MgSurveySet Extends %Persistent
{

/// 开始年龄
Property StAge As %String [ SqlColumnNumber = 2, SqlFieldName = St_Age ];

/// 截止年龄
Property EndAge As %String [ SqlColumnNumber = 3, SqlFieldName = End_Age ];

/// 发送对象
Property SendType As %String [ SqlColumnNumber = 4, SqlFieldName = Send_Type ];

/// 回复有效期
Property ReplyValid As %String [ SqlColumnNumber = 5, SqlFieldName = Reply_Valid ];

/// 回访有效期
Property ReVisitValid As %String [ SqlColumnNumber = 6, SqlFieldName = ReVisit_Valid ];

/// 技术操作模板
Property OperateModel As %String(MAXLEN = 1000) [ SqlColumnNumber = 7, SqlFieldName = Operate_Model ];

/// 服务态度模板
Property ServiceModel As %String(MAXLEN = 1000) [ SqlColumnNumber = 8, SqlFieldName = Service_Model ];

/// 管理员手机号
Property AdminPhone As %String [ SqlColumnNumber = 9, SqlFieldName = Admin_Phone ];

Storage Default
{
<Data name="MgSurveySetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StAge</Value>
</Value>
<Value name="3">
<Value>EndAge</Value>
</Value>
<Value name="4">
<Value>SendType</Value>
</Value>
<Value name="5">
<Value>ReplyValid</Value>
</Value>
<Value name="6">
<Value>ReVisitValid</Value>
</Value>
<Value name="7">
<Value>OperateModel</Value>
</Value>
<Value name="8">
<Value>ServiceModel</Value>
</Value>
<Value name="9">
<Value>AdminPhone</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgSurveySetD</DataLocation>
<DefaultData>MgSurveySetDefaultData</DefaultData>
<IdLocation>^DHCNMG.DB.MgSurveySetD</IdLocation>
<IndexLocation>^DHCNMG.DB.MgSurveySetI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgSurveySetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
