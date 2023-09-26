Class web.DHCJFZXCommon Extends %Persistent
{

// w ##class(web.DHCJFZXCommon).ServerIP()

// 获取服务器IP地址

ClassMethod ServerIP()
{
	Set SERVER=""
	if $d(%request)&&(%request.CgiEnvs("LOCAL_ADDR")){
		Set SERVER = %request.CgiEnvs("LOCAL_ADDR") ;%request.CgiEnvs("SERVER_ADDR")
	}else{
	 	Set SERVER = $p($zu(54,13,$zu(54,0)),",")
	}
	Quit SERVER
}

Storage Default
{
<Data name="DHCJFZXCommonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCJFZXCommonD</DataLocation>
<DefaultData>DHCJFZXCommonDefaultData</DefaultData>
<IdLocation>^web.DHCJFZXCommonD</IdLocation>
<IndexLocation>^web.DHCJFZXCommonI</IndexLocation>
<StreamLocation>^web.DHCJFZXCommonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
