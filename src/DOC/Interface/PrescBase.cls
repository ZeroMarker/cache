/// 国家医保处方流转
Class DOC.Interface.PrescBase Extends (%Persistent, User.Abstract) [ SqlTableName = PrescBase ]
{

Index IdxPrescNo On PrescNo;

Index IdxHiRxno On hiRxno;

/// 处方号
Property PrescNo As %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 医嘱ID串
Property OrderIdStr As %String(MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 处方Base64值
Property Base64Str As %CSP.CharacterStream [ SqlColumnNumber = 4 ];

/// 插入日期
Property CreateDate As %Date [ SqlColumnNumber = 5 ];

/// 插入时间
Property CreateTime As %Time [ SqlColumnNumber = 6 ];

/// 处方追溯码
Property rxTraceCode As %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 7 ];

/// 医保处方编号
Property hiRxno As %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 8 ];

/// 医保电子签名后的处方Base64值
Property rxFile As %CSP.CharacterStream [ SqlColumnNumber = 9 ];

/// 医保电子签名后的签名/章摘要值
Property signDigest As %CSP.CharacterStream [ SqlColumnNumber = 10 ];

/// 签名机构证书SN
Property signCertSn As %String(MAXLEN = 9999) [ SqlColumnNumber = 11 ];

/// 签名机构证书DN
Property signCertDn As %String(MAXLEN = 9999) [ SqlColumnNumber = 12 ];

/// 当前状态(1:有效,2:已失效,3:已撤销)
Property CurrentStatus As %String [ SqlColumnNumber = 13 ];

/// 更新日期
Property UpdateDate As %Date [ SqlColumnNumber = 14 ];

/// 更新时间
Property UpdateTime As %Time [ SqlColumnNumber = 15 ];

/// 更新用户
Property UpdateUserID As User.SSUser [ SqlColumnNumber = 16 ];

/// 电子处方信息查询返回数据
Property hospRxDetlQuery As %String(MAXLEN = 99999, TRUNCATE = 1) [ SqlColumnNumber = 17 ];

/// 电子处方审核结果查询返回数据
Property rxChkInfoQuery As %String(MAXLEN = 9999, TRUNCATE = 1) [ SqlColumnNumber = 18 ];

/// 电子处方取药结果查询返回数据
Property rxSetlInfoQuery As %String(MAXLEN = 9999, TRUNCATE = 1) [ SqlColumnNumber = 19 ];

Storage Default
{
<Data name="DOC.Interface.PrescBaseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PrescNo</Value>
</Value>
<Value name="3">
<Value>OrderIdStr</Value>
</Value>
<Value name="4">
<Value>Base64Str</Value>
</Value>
<Value name="5">
<Value>CreateDate</Value>
</Value>
<Value name="6">
<Value>CreateTime</Value>
</Value>
<Value name="7">
<Value>rxTraceCode</Value>
</Value>
<Value name="8">
<Value>hiRxno</Value>
</Value>
<Value name="9">
<Value>rxFile</Value>
</Value>
<Value name="10">
<Value>signDigest</Value>
</Value>
<Value name="11">
<Value>signCertSn</Value>
</Value>
<Value name="12">
<Value>signCertDn</Value>
</Value>
<Value name="13">
<Value>CurrentStatus</Value>
</Value>
<Value name="14">
<Value>UpdateDate</Value>
</Value>
<Value name="15">
<Value>UpdateTime</Value>
</Value>
<Value name="16">
<Value>UpdateUserID</Value>
</Value>
<Value name="17">
<Value>hospRxDetlQuery</Value>
</Value>
<Value name="18">
<Value>rxChkInfoQuery</Value>
</Value>
<Value name="19">
<Value>rxSetlInfoQuery</Value>
</Value>
</Data>
<DataLocation>^DOC.Interface.PrescBaseD</DataLocation>
<DefaultData>DOC.Interface.PrescBaseDefaultData</DefaultData>
<IdLocation>^DOC.Interface.PrescBaseD</IdLocation>
<IndexLocation>^DOC.Interface.PrescBaseI</IndexLocation>
<StreamLocation>^DOC.Interface.PrescBaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
