Class web.DHCAPPRepTarItm Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：      zhouxin
/// CreatDate：    2016-05-18
/// Description:： 保存检查收费项
/// Table：        DHC_AppRepTarItm
/// Input：        rep 申请单id
/// Output：       0:成功 其他:失败 
/// w ##class(web.DHCAPPRepTarItm).InsertRepTarItm(79)
ClassMethod InsertRepTarItm(rep) As %Library.String
{

	q:+rep=0 -1
	
	s repArcId="",ret=0
	f  s repArcId=$o(^DHCAPREP(rep,"AR",repArcId)) q:(repArcId="")||(ret'=0)  d
	.
	.s oeori=$p(^DHCAPREP(rep,"AR",repArcId),"^",3)
	.s pos=$p(^DHCAPREP(rep,"AR",repArcId),"^",2)
	.s arc=$p(^DHCAPREP(rep,"AR",repArcId),"^",1)
	.//插入体位对应的收费项
	.s ret=..InsertPos(pos,oeori)
	.q:ret'=0
	.//插入后执行方法对应的收费项
	.s ret=..InsertMed(rep,repArcId,oeori)
	.q:ret'=0
	.//查看医嘱是否按基价收费
	.//s baseFlag=..CheckIsBase(arc)
	.//按部位保存
	.s ret=..InsertParts(rep,repArcId,oeori,arc)


	q ret
}

/// Description:： 基价保存部位收费项
ClassMethod InsertParts(rep, repa, oeori, arc) As %Library.String
{
	s repap="",err=0
	s pid=##class(web.DHCAPPCommonUtil).NewPid()
	s ^TMP("web","DHCAPPRepTarItm","InsertParts",pid)=0
	f  s repap=$o(^DHCAPREP(rep,"AR",repa,"PA",repap)) q:repap=""  d
	.s part=$p(^DHCAPREP(rep,"AR",repa,"PA",repap),"^",1)
	.i $d(^DHCAPPART(part))=1 d
	..s partqty=$p(^DHCAPPART(part),"^",7)
	..s err=..InsertPart(arc,oeori,partqty,part,pid)
	.e  d
	..s parti=""
	..f  s parti=$o(^DHCAPPART(part,"I",parti)) q:parti=""  d
	...s partdr=$p(^DHCAPPART(part,"I",parti),"^",1)
	...s partqty=$p(^DHCAPPART(part),"^",7)
	...s err=..InsertPart(arc,oeori,partqty,partdr,pid)
	k ^TMP("web","DHCAPPRepTarItm","InsertParts",pid)
    q err
}

ClassMethod GetCurrNum(pid) As %Library.String
{
  s tmpnum= ^TMP("web","DHCAPPRepTarItm","InsertParts",pid)
  s nextnum=tmpnum+1
  s ^TMP("web","DHCAPPRepTarItm","InsertParts",pid)=nextnum
  q nextnum
}

/// Description:： 保存部位
ClassMethod InsertPart(arc, oeori, yqty = 0, part = "", pid) As %Library.String
{
	
	s tar="",err=0
	f  s tar=$o(^DHCAPARCLTA(0,"Arc",arc,tar)) q:tar=""  d
	.s start=""
	.f  s start=$o(^DHCAPARCLTA(0,"Arc",arc,tar,start)) q:start=""  d
	..q:start>+$h
	..s link=""
	..f  s link=$o(^DHCAPARCLTA(0,"Arc",arc,tar,start,link)) q:(link="")||(err'=0)  d
	...s end=$p(^DHCAPARCLTA(link),"^",5)
	...q:(+end'=0)&&(end<+$h)
	...s qty=+$p(^DHCAPARCLTA(link),"^",10)
	...s qty=$case(qty,0:1,:qty)
	...s base=$p(^DHCAPARCLTA(link),"^",11)
	...i base="Y" d
	....f i=1:1:qty d
	.....s partnum=..GetCurrNum(pid)
	.....s disc=..GetDisc(arc, partnum, oeori)
	.....s err=..Insert("P",part,tar,oeori,qty,disc)
	...e  d
    ....s err=..Insert("P",part,tar,oeori,qty,1)
    q err
}

/// Description:： 保存体位收费项
/// w ##class(web.DHCAPPRepTarItm).InsertPos(2,"1||1")
ClassMethod InsertPos(pos, oeori) As %Library.String
{
	s tar="",err=0
	f  s tar=$o(^DHCAPPOSTAR(0,"Pos",pos,tar)) q:tar=""  d
	.s start=""
	.f  s start=$o(^DHCAPPOSTAR(0,"Pos",pos,tar,start)) q:start=""  d
	..q:start>+$h
	..s link=""
	..f  s link=$o(^DHCAPPOSTAR(0,"Pos",pos,tar,start,link)) q:(link="")||(err'=0)  d
	...s end=$p(^DHCAPPOSTAR(link),"^",5)
	...q:(+end'=0)&&(end<+$h)
	...s qty=+$p(^DHCAPPOSTAR(link),"^",10)
	...s qty=$case(qty,0:1,:qty)
    ...s err=..Insert("O",link,tar,oeori,qty,1)
    
    q err
}

/// Description:： 保存后执行方法收费项
/// w ##class(web.DHCAPPRepTarItm).InsertMed(68,1,"1||1")
ClassMethod InsertMed(rep, repa, oeori) As %Library.String
{
	s repad="",err=0
	f  s repad=$o(^DHCAPREP(rep,"AR",repa,"DI",repad)) q:repad=""  d
	.s med=$p(^DHCAPREP(rep,"AR",repa,"DI",repad),"^",1)
	.q:+med=0
	.s tar=""
	.f  s tar=$o(^DHCAPMEDTAR(0,"Med",med,tar)) q:tar=""  d
	..s start=""
	..f  s start=$o(^DHCAPMEDTAR(0,"Med",med,tar,start)) q:start=""  d
	...q:start>+$h
	...s link=""
	...f  s link=$o(^DHCAPMEDTAR(0,"Med",med,tar,start,link)) q:(link="")||(err'=0)  d
	....s end=$p(^DHCAPMEDTAR(link),"^",5)
	....q:(+end'=0)&&(end<+$h)
	....s qty=+$p(^DHCAPMEDTAR(link),"^",10)
	....s qty=$case(qty,0:1,:qty)
    ....s err=..Insert("D",link,tar,oeori,qty,1)
    q err
}

/// Description:： 保存
ClassMethod Insert(ARTIType, ARTIPointer, ARTITarDr, ARTIOrdItem, ARTIQty, ARTIDisc) As %Library.String
{
	s err=0
	s obj=##class(User.DHCAppRepTarItm).%New()
	s obj.ARTIType=ARTIType
	s obj.ARTIPointer=ARTIPointer
	s obj.ARTITarDr=##class(User.DHCTarItem).%OpenId(ARTITarDr)
	s obj.ARTIOrdItem=##class(User.OEOrdItem).%OpenId(ARTIOrdItem)
	s obj.ARTIUpdDate=+$h
	s obj.ARTIUpdTime=$p($h,",",2)
	s obj.ARTIQty=ARTIQty
	s obj.ARTIDisc=ARTIDisc
	s sc=obj.%Save()
    i $$$ISERR(sc) s err=-1
    q err
}

/// Creator：      zhouxin
/// CreatDate：    2016-05-18
/// Description:： 检查医嘱是不是基价
/// Table：        DHC_AppArcLinkTar
/// Input：        arc 医嘱id
/// Output：       Y：是 N：否 
/// w ##class(web.DHCAPPRepTarItm).CheckIsBase("9573||1")
ClassMethod CheckIsBase(arc) As %Library.String
{
	q:+arc=0 "N"
	s tar="",flag="N"
	f  s tar=$o(^DHCAPARCLTA(0,"Arc",arc,tar)) q:tar=""  d
	.s startdate=""
	.f  s startdate=$o(^DHCAPARCLTA(0,"Arc",arc,tar,startdate)) q:startdate=""  d
	..q:startdate>+$h
	..s link="" 
	..f  s link=$o(^DHCAPARCLTA(0,"Arc",arc,tar,startdate,link)) q:link=""  d
	...s end=$p(^DHCAPARCLTA(link),"^",5)
	...q:(+end'=0)&&(end<+$h)
	...s base=$p(^DHCAPARCLTA(link),"^",11)
	...s:base="Y" flag="Y"
	q flag
}

ClassMethod GetDisc(arc, partnum, adm) As %Library.String
{
	
	//s adm=$p(^OEORD(+oeori),"^",1)
	q:+adm=0 1
	s admtype=$p(^PAADM(adm),"^",2)
	q:admtype="" 1	
	s ret=..GetDiscByType(arc,partnum,2)
	s flag=$p(ret,"^",2)
	q:(flag=1) +ret
	s ret=..GetDiscByType(arc,partnum,$case(admtype,"I":1,:0))
	q +ret
}

ClassMethod GetDiscByType(arc, partnum, type) As %Library.String
{
	
	s startdate="",flag=0,disc=1
	f  s startdate=$o(^DHCAPARCDIS(0,"Arc",arc,type,startdate)) q:startdate=""  d
	.q:startdate>+$h
	.s link=""
	.f  s link=$o(^DHCAPARCDIS(0,"Arc",arc,type,startdate,link)) q:(link="")||(flag=1)  d
	..s enddate=$p(^DHCAPARCDIS(link),"^",6)
	..q:(+enddate'=0)&&(enddate<+$h)
	..s linkpartnum=$p(^DHCAPARCDIS(link),"^",2)
	..q:linkpartnum'=partnum
	..s linkdisc=$p(^DHCAPARCDIS(link),"^",3)
	..s:+linkdisc'=0 disc=linkdisc,flag=1
	q disc_"^"_flag
}

}
