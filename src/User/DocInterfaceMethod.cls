Class User.DocInterfaceMethod Extends (%Persistent, %XML.Adaptor) [ SqlTableName = Doc_InterfaceMethod ]
{

Index interfaceType On (interfaceType, methodCode);

Index methodInvokType On (methodInvokType, methodCode);

Index methodCode On methodCode [ Unique ];

/// 方法代码
Property methodCode As %String(COLLATION = "EXACT", MAXLEN = 40) [ SqlColumnNumber = 2, SqlFieldName = method_Code ];

/// 方法描述
Property methodDesc As %String(MAXLEN = 200) [ SqlColumnNumber = 3, SqlFieldName = method_Desc ];

/// 接口发布日期
Property methodSttDate As %Date [ SqlColumnNumber = 4, SqlFieldName = method_SttDate ];

/// 产品线
Property methodProductLine As %String [ SqlColumnNumber = 5, SqlFieldName = method_ProductLine ];

/// 状态(Yes：运行，No：停止)
Property methodStatus As %String(COLLATION = "EXACT", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = method_Status ];

/// 本地化标识
Property methodLocal As %String(COLLATION = "EXACT", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = method_Local ];

/// 调用类型(Service 服务，Call 调用)
Property methodInvokType As %String(COLLATION = "EXACT", DISPLAYLIST = ",Service,Call", MAXLEN = 3, VALUELIST = ",S,C") [ SqlColumnNumber = 8, SqlFieldName = method_InvokType ];

/// 关联产品组
Property methodProductLinkGroup As %String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 9, SqlFieldName = method_ProductLinkGroup ];

/// 方法所在类名称
Property methodClassName As %String(MAXLEN = 100) [ SqlColumnNumber = 10, SqlFieldName = method_ClassName ];

/// 方法名称
Property methodName As %String(MAXLEN = 50) [ SqlColumnNumber = 11, SqlFieldName = method_Name ];

/// 方法类型
Property methodType As %String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 12, SqlFieldName = method_Type ];

/// 入参格式类型和说明，多个之间有逗号分隔
Property methodInput As %String(MAXLEN = 5000) [ SqlColumnNumber = 13, SqlFieldName = method_Input ];

/// 返回值类型和说明，多个之间有逗号分隔
Property methodOutput As %String(MAXLEN = 5000) [ SqlColumnNumber = 14, SqlFieldName = method_Output ];

/// 备注
Property methodNote As %String(MAXLEN = 1000) [ SqlColumnNumber = 15, SqlFieldName = method_Note ];

Property methodPublishClassName As %String(MAXLEN = 1000) [ SqlColumnNumber = 16, SqlFieldName = method_PublishClassName ];

Property methodPublishName As %String(MAXLEN = 1000) [ SqlColumnNumber = 17, SqlFieldName = method_PublishName ];

/// 创建日期
Property insertDate As %Date(XMLPROJECTION = "NONE") [ InitialExpression = {$P($H,",")}, SqlColumnNumber = 18 ];

/// 创建时间
Property insertTime As %Time(XMLPROJECTION = "NONE") [ InitialExpression = {$P($H,",",2)}, SqlColumnNumber = 19 ];

/// 接口类型
Property interfaceType As %String(COLLATION = "EXACT", MAXLEN = 40) [ SqlColumnNumber = 20, SqlFieldName = interface_Type ];

/// 日志标识
Property interfaceLogFalg As %String(COLLATION = "EXACT", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 21, SqlFieldName = interface_LogFalg ];

/// Json扩展参数
Property paramsJsonStr As %String(MAXLEN = 10000) [ SqlColumnNumber = 22, SqlFieldName = params_JsonStr ];

/// Json扩展参数1(暂未使用)
Property paramsJsonStr1 As %String(MAXLEN = 10000) [ SqlColumnNumber = 23, SqlFieldName = params_JsonStr1 ];

/// 扩展参数
Property paramsExptStr As %String(MAXLEN = 10000) [ SqlColumnNumber = 24, SqlFieldName = params_ExptStr ];

/// 超时时间
Property HTimeout As %String(COLLATION = "EXACT", MAXLEN = 40) [ SqlColumnNumber = 25 ];

/// 超时次数
Property HTimeOutNum As %String(COLLATION = "EXACT", MAXLEN = 40) [ SqlColumnNumber = 26 ];

/// 异常返回值
Property HReturnStr As %String(COLLATION = "EXACT", MAXLEN = 10000) [ SqlColumnNumber = 27 ];

/// 自动关闭
Property HAutoSwitch As %String(COLLATION = "EXACT", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 28 ];

/// 服务IP/域名
Property HServer As %String(COLLATION = "EXACT", MAXLEN = 100) [ SqlColumnNumber = 29 ];

/// 端口
Property HPort As %String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 30 ];

/// 域标识
Property HDomainFlag As %String(COLLATION = "EXACT", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 31 ];

/// 请求路径
Property HPath As %String(COLLATION = "EXACT", MAXLEN = 100) [ SqlColumnNumber = 32 ];

/// Header参数
Property HHeaderJson As %String(COLLATION = "EXACT", MAXLEN = 1000) [ SqlColumnNumber = 33 ];

/// 请求方式
Property HMethodType As %String(COLLATION = "EXACT", MAXLEN = 100) [ SqlColumnNumber = 34 ];

/// 数据类型
Property HContentType As %String(COLLATION = "EXACT", MAXLEN = 100) [ SqlColumnNumber = 35 ];

/// 是否HTTPS
Property HHttps As %String(COLLATION = "EXACT", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 36 ];

/// 验证服务器身份
Property HSSLCheckServerIdentity As %String(COLLATION = "EXACT", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 37 ];

/// SSL配置名
Property HSSLConfiguration As %String(COLLATION = "EXACT", MAXLEN = 100) [ SqlColumnNumber = 38 ];

/// 状态更新日期
Property SUpdateDate As %Date(XMLPROJECTION = "NONE") [ SqlColumnNumber = 39 ];

/// 状态更新时间
Property SUpdateTime As %Time(XMLPROJECTION = "NONE") [ SqlColumnNumber = 40 ];

/// 自动关闭标识
Property AutoStop As %String(COLLATION = "EXACT", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 41 ];

/// 自动关闭日志ID
Property StopLogID As DOC.Interface.Log [ SqlColumnNumber = 42 ];

/// Json扩展参数说明(便于字段增多时，理解每个字段的含义)
ClassMethod GetExtendJsonKey()
{
	;基础扩展字段
	;接口类型、日志标识(0\1)
	s HKeyStr="interfaceType^LogFlag^"
	
	;Http扩展相关字段: paramsJsonStr
	;服务IP(域名)、域名标志、端口、路径、请求方式(GET\POST)、数据类型、超时时间(s)、HTTPS标志(0\1)、SSL证书名、校验SSL标志(0\1)
	s HKeyStr=HKeyStr_"^HServer^HDomainFlag^HPort^HPath^HMethodType^HContentType^HTimeout^HHttps^HSSLConfiguration^HSSLCheckServerIdentity"
	;Header信息
	s HKeyStr=HKeyStr_"^HHeaderJson"

	;paramsExptStr $c(3) 拼接
	;允许超时次数_$c(3)_超过次数自动关闭_$c(3)_异常返回串
	;
	q ""
}

Storage Default
{
<Data name="DocInterfaceMethodDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>methodCode</Value>
</Value>
<Value name="3">
<Value>methodDesc</Value>
</Value>
<Value name="4">
<Value>methodSttDate</Value>
</Value>
<Value name="5">
<Value>methodProductLine</Value>
</Value>
<Value name="6">
<Value>methodStatus</Value>
</Value>
<Value name="7">
<Value>methodLocal</Value>
</Value>
<Value name="8">
<Value>methodInvokType</Value>
</Value>
<Value name="9">
<Value>methodProductLinkGroup</Value>
</Value>
<Value name="10">
<Value>methodClassName</Value>
</Value>
<Value name="11">
<Value>methodName</Value>
</Value>
<Value name="12">
<Value>methodType</Value>
</Value>
<Value name="13">
<Value>methodInput</Value>
</Value>
<Value name="14">
<Value>methodOutput</Value>
</Value>
<Value name="15">
<Value>methodNote</Value>
</Value>
<Value name="16">
<Value>methodPublishClassName</Value>
</Value>
<Value name="17">
<Value>methodPublishName</Value>
</Value>
<Value name="18">
<Value>insertDate</Value>
</Value>
<Value name="19">
<Value>insertTime</Value>
</Value>
<Value name="20">
<Value>interfaceType</Value>
</Value>
<Value name="21">
<Value>interfaceLogFalg</Value>
</Value>
<Value name="22">
<Value>paramsJsonStr</Value>
</Value>
<Value name="23">
<Value>paramsJsonStr1</Value>
</Value>
<Value name="24">
<Value>paramsExptStr</Value>
</Value>
<Value name="25">
<Value>HTimeout</Value>
</Value>
<Value name="26">
<Value>HTimeOutNum</Value>
</Value>
<Value name="27">
<Value>HReturnStr</Value>
</Value>
<Value name="28">
<Value>HAutoSwitch</Value>
</Value>
<Value name="29">
<Value>HServer</Value>
</Value>
<Value name="30">
<Value>HPort</Value>
</Value>
<Value name="31">
<Value>HDomainFlag</Value>
</Value>
<Value name="32">
<Value>HPath</Value>
</Value>
<Value name="33">
<Value>HHeaderJson</Value>
</Value>
<Value name="34">
<Value>HMethodType</Value>
</Value>
<Value name="35">
<Value>HContentType</Value>
</Value>
<Value name="36">
<Value>HHttps</Value>
</Value>
<Value name="37">
<Value>HSSLCheckServerIdentity</Value>
</Value>
<Value name="38">
<Value>HSSLConfiguration</Value>
</Value>
<Value name="39">
<Value>SUpdateDate</Value>
</Value>
<Value name="40">
<Value>SUpdateTime</Value>
</Value>
<Value name="41">
<Value>AutoStop</Value>
</Value>
<Value name="42">
<Value>StopLogID</Value>
</Value>
</Data>
<DataLocation>^User.DocInterfaceMethodD</DataLocation>
<DefaultData>DocInterfaceMethodDefaultData</DefaultData>
<IdLocation>^User.DocInterfaceMethodD</IdLocation>
<IndexLocation>^User.DocInterfaceMethodI</IndexLocation>
<StreamLocation>^User.DocInterfaceMethodS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
