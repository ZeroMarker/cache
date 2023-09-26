Class web.DHCBZTClass Extends %RegisteredObject
{

ClassMethod FindPatName(itmjs, patno)
{
	;patno是入参，itmjs用来获得返回值
	;s ^T="ssssssssssssssss"
	;w !,^T
	 if patno="" q ""
	  s patRowid = $O(^PAPERi("PAPMI_PatNo",patno,""))
	  q:patRowid=""
	  s data = ^PAPER(patRowid,"ALL")
	  q:data=""
	  s patname=$P(data,"^",1)
	  s patSexDr = $p(data,"^",7)
	  s patsex = $P(^CT("SEX",patSexDr),"^",2)
	 ; q patname_"^"_patsex
	  s srt=patname_"^"_patsex
	  S retval=itmjs_"('"_$ZCVT(srt,"O","JS")_"');"
     &javascript<#(retval)#>//通过javaScript返回到页面
}

}
