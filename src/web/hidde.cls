Class web.hidde Extends %RegisteredObject
{

ClassMethod Find(itmjs, patno)
{
	 if patno=""  q ""
	  s patRowid = $O(^PAPERi("PAPMI_PatNo",patno,""))
	  q:patRowid=""
	  s data = ^PAPER(patRowid,"ALL")
	  q:data=""
	  s patname=$P(data,"^",1)
	  s patSexDr = $p(data,"^",7)
	  s patsex = $P(^CT("SEX",patSexDr),"^",2)
	 ;q patname_"^"_patsex
	  s srt=patname_"^"_patsex
	  S retval=itmjs_"('"_$ZCVT(srt,"O","JS")_"');"
     &javascript<#(retval)#>
}

}
