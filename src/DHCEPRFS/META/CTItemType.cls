/// 描述:归档项目类型
Class DHCEPRFS.META.CTItemType Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 项目类型编码
Property TypeCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 项目类型名称
Property TypeName As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 项目类型描述
Property TypeDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// 打印csp路径
Property CSPPath As %String(MAXLEN = 2000, TRUNCATE = 1) [ SqlColumnNumber = 5 ];

/// 顺序号
Property Sequence As %Integer [ SqlColumnNumber = 6 ];

/// 产品来源
Property ProductSource As %String(TRUNCATE = 1) [ SqlColumnNumber = 7 ];

/// 调用方式
Property InvokeType As %String [ SqlColumnNumber = 8 ];

/// webservices路径
Property TypeURL As %String(MAXLEN = 2000, TRUNCATE = 1) [ SqlColumnNumber = 9 ];

/// webservices类
Property TypeClass As %String(MAXLEN = 2000, TRUNCATE = 1) [ SqlColumnNumber = 10 ];

/// webservices方法
Property TypeMethod As %String(MAXLEN = 2000, TRUNCATE = 1) [ SqlColumnNumber = 11 ];

/// FTPConfig参数
Property TypeFTPConfig As %String(MAXLEN = 2000, TRUNCATE = 1) [ SqlColumnNumber = 12 ];

/// 备注
/// 目前用来标识PDF下载中麻醉单的ftpconfig
Property TypeNote As %String [ SqlColumnNumber = 13 ];

/// 标识
/// 用来决定PDF下载的方式
Property TypeFlag As %String [ SqlColumnNumber = 14 ];

/// 生成方式
/// 目前有六种生成方式:exe,ftp,csp,thirdpartyftp,thirdpartyurl,epr2emr3
Property CreateType As %String [ SqlColumnNumber = 15 ];

/// 公司
Property Company As %String [ SqlColumnNumber = 16 ];

/// 产品组
Property ProductTeam As %String [ SqlColumnNumber = 17 ];

/// 确定生成方式之后的调用类型，比如FTP下面就有EKG、PACS、PIS等
Property CreateTypeSub As %String [ SqlColumnNumber = 18 ];

Index IdxMain On TypeCode [ Unique ];

Storage Default
{
<Data name="CTItemTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TypeCode</Value>
</Value>
<Value name="3">
<Value>TypeName</Value>
</Value>
<Value name="4">
<Value>TypeDesc</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>CSPPath</Value>
</Value>
<Value name="7">
<Value>ProductSource</Value>
</Value>
<Value name="8">
<Value>InvokeType</Value>
</Value>
<Value name="9">
<Value>TypeURL</Value>
</Value>
<Value name="10">
<Value>TypeClass</Value>
</Value>
<Value name="11">
<Value>TypeMethod</Value>
</Value>
<Value name="12">
<Value>TypeFTPConfig</Value>
</Value>
<Value name="13">
<Value>TypeNote</Value>
</Value>
<Value name="14">
<Value>TypeFlag</Value>
</Value>
<Value name="15">
<Value>CreateType</Value>
</Value>
<Value name="16">
<Value>Company</Value>
</Value>
<Value name="17">
<Value>ProductTeam</Value>
</Value>
<Value name="18">
<Value>CreateTypeSub</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.CTItemTypeD</DataLocation>
<DefaultData>CTItemTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.CTItemTypeD</IdLocation>
<IndexLocation>^DHCEPRFS.META.CTItemTypeI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.CTItemTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
