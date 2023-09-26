/// 描述: 获取CA签名的接口类
/// 编写者：ZY
/// 编写日期: 2023-02-28
/// 产品组：设备管理
Class web.DHCEQ.Interface.Inner.DHCEQCA Extends %Persistent
{

/// w ##Class(web.DHCEQ.Interface.Inner.DHCEQCA).GetCAImage()
ClassMethod GetCAImage(UserID As %String) As CA.UsrSignatureInfo
{
	s id=##Class(CA.UsrSignatureInfo).GetInUseID(UserID)
	i id'=""
	{
		s obj=##Class(CA.UsrSignatureInfo).%OpenId(id)
		i obj'="" q obj.SignImage
	}
	q ""
}

Storage Default
{
<Data name="DHCEQCADefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQ.Interface5FF.DHCEQCAD</DataLocation>
<DefaultData>DHCEQCADefaultData</DefaultData>
<IdLocation>^web.DHCEQ.Interface5FF.DHCEQCAD</IdLocation>
<IndexLocation>^web.DHCEQ.Interface5FF.DHCEQCAI</IndexLocation>
<StreamLocation>^web.DHCEQ.Interface5FF.DHCEQCAS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
