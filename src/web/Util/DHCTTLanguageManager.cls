Class web.Util.DHCTTLanguageManager Extends %RegisteredObject
{

//拿到语言种类对象

ClassMethod getLanguage() As web.Util.DHCTTLanguage
{
	s ip=%request.GetCgiEnv("REMOTE_ADDR")	
	s language = $s($g(^DHCTTTEMP("config",ip,"language"))'="":^DHCTTTEMP("config",ip,"language"),1:"English")
	quit $ZOBJCLASSMETHOD("web.Util.DHCTTLanguage"_language, "%New")
}

}
