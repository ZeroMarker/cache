Class EPRservice.Quality.Ajax.OutPatDiscussInfo Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s idea = $Get(%request.Data("idea",1),"")
	s DiscussDates = $Get(%request.Data("DiscussDates",1),"")
	s date=$zd($h,3)
	//s ^temp("wei")=DiscussDates
	s submited=$o(^DHCEPRQ.OutPatDiscussInfoI("IdxDiscussDates"," "_DiscussDates,""))
	if (submited'="")  //如果此日期段讨论提交过，则更修此日期讨论的内容
	{
		w ##class(EPRservice.Quality.DataAccess.OutPatDiscussInfo).UpDateDiscussInfo(idea,DiscussDates,date)
		Quit $$$OK
	}
	
	w ##class(EPRservice.Quality.DataAccess.OutPatDiscussInfo).InsertDiscussInfo(idea,DiscussDates,date)
	
	Quit $$$OK
}

}
