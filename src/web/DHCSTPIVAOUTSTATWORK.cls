Import sqluser

/// 门诊配液工作量统计
Class web.DHCSTPIVAOUTSTATWORK Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod QueryPIVAWork(Input) As %String
{
	s stdate=$p(Input,"^",1)
	s stdate=$zdh(stdate,4)
	s eddate=$p(Input,"^",2)
	s eddate=$zdh(eddate,4)
	s phlocdr=$p(Input,"^",3)
	s type="O"
	s adtpsnumber="3"
	
	s pid=##class(web.DHCSTPIVAOUTCOMMON).GetPIVAOUTPID()
	s psnumber=""
	f  s psnumber=$o(^PIVAS(0,"NUMBER",psnumber)) q:psnumber=""  d
	.q:psnumber=90 //病区接收的状态不统计
	.s psrowid=""
	.f  s psrowid=$o(^PIVAS(0,"NUMBER",psnumber,psrowid)) q:psrowid=""  d
	..s pslocdr=$p(^PIVAS(psrowid),"^",7)
	..q:pslocdr'=phlocdr
	..s loctype=$p(^PIVAS(psrowid),"^",9)
	..q:type'=loctype
	..s index=pslocdr_"^"_psnumber
	..s ^TMP("dhcpha","DHCSTPIVAOUTSTATWORK","QueryPIVAWork",pid,"Index",index)=""
	..
	.

	s psstring=adtpsnumber
	s index=""
	f  s index=$o(^TMP("dhcpha","DHCSTPIVAOUTSTATWORK","QueryPIVAWork",pid,"Index",index)) q:index=""  d
	.s locdr=$p(index,"^",1)
	.s psnumber=$p(index,"^",2)
	.s psstring=psstring_"^"_psnumber
	.
	.
	//统计审核处方数
	f date=stdate:1:eddate d
	.s phordm=""
	.f  s phordm=$o(^DHCPHORDM(0,"DateLoc",date,phlocdr,phordm)) q:phordm=""  d
	..s user=$p(^DHCPHORDM(phordm),"^",1)
	..s chl=""
	..f  s chl=$o(^DHCPHORDM(phordm,"I",chl)) q:chl=""  d
	...s prescno=$p(^DHCPHORDM(phordm,"I",chl),"^",4)
	...i '$D(^TMP("dhcpha","DHCSTPIVAOUTSTATWORK","QueryPIVAWork",pid,"PrescNo",user,prescno)) d
	....s ^TMP("dhcpha","DHCSTPIVAOUTSTATWORK","QueryPIVAWork",pid,"WorkItm",user,adtpsnumber)=+$g(^TMP("dhcpha","DHCSTPIVAOUTSTATWORK","QueryPIVAWork",pid,"WorkItm",user,adtpsnumber))+1 
	....s ^TMP("dhcpha","DHCSTPIVAOUTSTATWORK","QueryPIVAWork",pid,"PrescNo",user,prescno)=""
	...
	..
	.
    .;配液流程定制
    .s ssusr="" 
    .f  s ssusr=$o(^PIVA(0,"SDUS",date,ssusr)) q:ssusr=""  d
    ..s psdr=""
    ..f  s psdr=$o(^PIVA(0,"SDUS",date,ssusr,psdr)) q:psdr=""  d  
    ...s number=$p(^PIVAS(psdr),"^",1)
    ...q:number=90 //病区接收的状态不统计
    ...s pog=""
    ...f  s pog=$o(^PIVA(0,"SDUS",date,ssusr,psdr,pog)) q:pog=""  d
    ....s num=+$g(^TMP("dhcpha","DHCSTPIVAOUTSTATWORK","QueryPIVAWork",pid,"WorkItm",ssusr,number))
    ....s ^TMP("dhcpha","DHCSTPIVAOUTSTATWORK","QueryPIVAWork",pid,"WorkItm",ssusr,number)=num+1
    ...
    ..
    .
    //统计
    s h=0
    s cnt=$l(psstring,"^")
    s user=""
    f  s user=$o(^TMP("dhcpha","DHCSTPIVAOUTSTATWORK","QueryPIVAWork",pid,"WorkItm",user)) q:user=""  d
    .s username=$p(^SSU("SSUSR",user),"^",2)
    .s str=""
    .f i=1:1:cnt d
    ..s psnumber=$p(psstring,"^",i)
    ..s num=+$g(^TMP("dhcpha","DHCSTPIVAOUTSTATWORK","QueryPIVAWork",pid,"WorkItm",user,psnumber))
    ..i str="" d
    ...s str=num
    ..e  d
    ...s str=str_"^"_num
    .s num1=$p(str,"^",1)
    .s num2=$p(str,"^",2)
    .s num3=$p(str,"^",3)
    .s num4=$p(str,"^",4)
    .s h=h+1
    .s data=username_"^"_num1_"^"_num2_"^"_num3_"^"_num4
    .s ^TMP("dhcpha","DHCSTPIVAOUTSTATWORK","QueryPIVAWork",pid,"Row",h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
   
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTPIVAOUTSTATWORK","QueryPIVAWork",pid,"Row",h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTPIVAOUTSTATWORK","QueryPIVAWork",pid,"Row",h)
    .s username=$p(data,"^",1)
    .s num1=$p(data,"^",2)
    .s num2=$p(data,"^",3)
    .s num3=$p(data,"^",4)
    .s num4=$p(data,"^",4)
    .
    .s username=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("username",username)
    .s num1=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("adtnum",num1)
	.s num2=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("prtnum",num2)
	.s num3=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("opstknum",num3)
	.s num4=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("checkednum",num4)
	.
	.s tmpstr=username_num1_num2_num3_num4
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("dhcpha","DHCSTPIVAOUTQUERY","QueryPIVAWork",pid)
	q ""
}

}
