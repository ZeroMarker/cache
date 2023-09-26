/// 临床路径字典
Class User.DHCMRCClinPathWaysDic Extends (%Persistent, web.DHCCPW.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = CPWD_RowId, SqlTableName = DHC_MRC_ClinPathWaysDic ]
{

/// 代码
Property CPWDCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CPWD_Code ];

/// 描述
Property CPWDDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CPWD_Desc ];

/// 临床路径类型
Property CPWDCPWTypeDR As DHCMRCClinPathType [ SqlColumnNumber = 4, SqlFieldName = CPWD_CPWType_DR ];

/// 激活标志
Property CPWDActive As %String(DISPLAYLIST = ",Yes,No", MINLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = CPWD_Active ];

/// 开始日期
Property CPWDDateFrom As %Date [ SqlColumnNumber = 6, SqlFieldName = CPWD_DateFrom ];

/// 截止日期
Property CPWDDateTo As %Date [ SqlColumnNumber = 7, SqlFieldName = CPWD_DateTo ];

/// 当前版本
Property CPWDVersion As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = CPWD_Version ];

/// 是否门诊临床路径
Property CPWDIsOpCPW As %String(DISPLAYLIST = ",Yes,No", MINLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = CPWD_IsOpCPW ];

/// 临床路径通用名
Property CPWDGenericDR As DHCMRCClinPathGeneric [ SqlColumnNumber = 10, SqlFieldName = CPWD_Generic_DR ];

/// 当前版本 索引
Index IndexVersion On CPWDVersion As Exact;

/// Creator：     zhufei
/// CreatDate：   2015-06-18
/// Description:  根据ID取临床路径字典
/// Table：       User.DHCMRCClinPathWaysDic
/// Input：       ID:    User.DHCMRCClinPathWaysDic.Id
/// Return：      返回object
/// w ##class(User.DHCMRCClinPathWaysDic).GetObjById(1)
ClassMethod GetObjById(argId As %String) As User.DHCMRCClinPathWaysDic
{
	New (argId)
	Set return=##Class(User.DHCMRCClinPathWaysDic).%OpenId(argId)
	Do:return'="" return.%Close()
	Quit return
}

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CPWDCode</Value>
</Value>
<Value name="3">
<Value>CPWDDesc</Value>
</Value>
<Value name="4">
<Value>CPWDCPWTypeDR</Value>
</Value>
<Value name="5">
<Value>CPWDActive</Value>
</Value>
<Value name="6">
<Value>CPWDDateFrom</Value>
</Value>
<Value name="7">
<Value>CPWDDateTo</Value>
</Value>
<Value name="8">
<Value>CPWDVersion</Value>
</Value>
<Value name="9">
<Value>CPWDIsOpCPW</Value>
</Value>
<Value name="10">
<Value>CPWDGenericDR</Value>
</Value>
</Data>
<DataLocation>^DHCMRC("CPWD")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMRC("CPWD")</IdLocation>
<IndexLocation>^DHCMRCi("CPWD",0)</IndexLocation>
<StreamLocation>^User.DHCMRCClinPathWaysDicS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
