Class web.Util.FindClassSession Extends %CSP.SessionEvents
{

ClassMethod OnEndSession()
{
	//ie ,chrome 关闭整个页面,单页签不调用
	k ^Temp("DHCTTFindTableStructure",%session.Key)
	Quit
}

}
