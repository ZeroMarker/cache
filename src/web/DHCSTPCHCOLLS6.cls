Include webimport

IncludeGenerator webimport

Class web.DHCSTPCHCOLLS6 Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

//ward to be waiting for dispensing

ClassMethod GetDispenWardList(phaloc As %String, d1 As %String, d2 As %String)
{
	n (phaloc,d1,d2)
	;
	s datefrom=d1
	s dateto=d2 
	s n=0
	k ^TMP($j)
	f dd=d1:1:d2  d 
	.s WardId=""
	.f  s WardId=$o(^DHCCLNurseExec("SendMedic",phaloc,dd,WardId))  q:WardId=""  d
	. . s dispcat="",dispcatlist="" 
	. . f  s dispcat=$o(^DHCCLNurseExec("SendMedic",phaloc,dd,WardId,dispcat)) q:dispcat=""  d
	. . . i '$d(^TMP($j,WardId,dispcat)) d
	. . . . s n=n+1
	. . . . s ^TMP($j,WardId,dispcat)=""
	q n
}

ClassMethod GetDispWardListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDispWardListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetDispWardListExecute(ByRef qHandle As %Binary, displocrowid As %String, StartDate As %String, EndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	;
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	//

	;s displocrowid=1122
	;s StartDate=60413
	;s EndDate=60413
	s allcats=..GetAllDispCats(displocrowid)
	s (TCat0,TCat1,TCat2,TCat3,TCat4,TCat5,TCat6,TCat7,TCat8,TCat9)=""
	s cnt=$l(allcats,"^")
	f i=1:1:cnt d
	.s cat=$p(allcats,"^",i)
	.d setcatcode(i,cat)
	s TWard="病区"
	s TSelect="选择"
	d outputrow
	
	/*
	s TCat0Code=$p($p(allcats,"^",1),"@",1)
	s TCat0=$p($p(allcats,"^",1),"@",2)
	s TCat1Code=$p($p(allcats,"^",2),"@",1)
	s TCat1=$p($p(allcats,"^",2),"@",2)
	s TCat2Code=$p($p(allcats,"^",3),"@",1)
	s TCat2=$p($p(allcats,"^",3),"@",2)
	s TCat3Code=$p($p(allcats,"^",4),"@",1)
	s TCat3=$p($p(allcats,"^",4),"@",2)
	s TCat4Code=$p($p(allcats,"^",5),"@",1)
	s TCat4=$p($p(allcats,"^",5),"@",2)
	s TCat5Code=$p($p(allcats,"^",6),"@",1)
	s TCat5=$p($p(allcats,"^",6),"@",2)
	s TCat6Code=$p($p(allcats,"^",7),"@",1)
	s TCat6=$p($p(allcats,"^",7),"@",2)
	s TCat7Code=$p($p(allcats,"^",8),"@",1)
	s TCat7=$p($p(allcats,"^",8),"@",2)
	s TCat8Code=$p($p(allcats,"^",9),"@",1)
	s TCat8=$p($p(allcats,"^",9),"@",2)
	s TCat9Code=$p($p(allcats,"^",10),"@",1)
	s TCat9=$p($p(allcats,"^",10),"@",2)
	*/
	;
	q:displocrowid="" $$$OK
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	
	s d1=StartDate
	s d2=EndDate
	s phaloc=displocrowid
	s n=0
	k ^TMP($j,"DISPWARDCATS")
	f dd=d1:1:d2  d 
	.s WardId=""
	.f  s WardId=$o(^DHCCLNurseExec("SendMedic",phaloc,dd,WardId))  q:WardId=""  d
	. . s dispcat="" 
	. . f  s dispcat=$o(^DHCCLNurseExec("SendMedic",phaloc,dd,WardId,dispcat)) q:dispcat=""  d
	. . . i '$d(^TMP($j,"DISPWARDCATS",WardId,dispcat)) d
	. . . . s n=n+1
	. . . . s ^TMP($j,"DISPWARDCATS",WardId,dispcat)=""
	;
	q:n=0 $$$OK
	;
	s WardId=""
	f  s WardId=$o(^TMP($j,"DISPWARDCATS",WardId)) q:WardId=""  d
	. s dispcat=""
	. d resetvariables
	. &sql(select ward_locationdr into :locdr from pac_ward where ward_rowid=:WardId)
	. q:$g(locdr)="" 
	. s TWard=$p(^CTLOC(locdr),"^",2)
	. f  s dispcat=$o(^TMP($j,"DISPWARDCATS",WardId,dispcat)) q:dispcat=""  d
	. . d seekcat(dispcat) 
	. .
	. s TWardRowid=WardId
	. d outputrow
	k ^TMP($j,"DISPWARDCATS")
	Quit $$$OK
	
outputrow
	;
	s Data=$lb(TWard,TCat0,TCat1,TCat2,TCat3,TCat4,TCat5,TCat6,TCat7,TCat8,TCat9,TWardRowid,TSelect)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
resetvariables
	s (TWard,TCat0,TCat1,TCat2,TCat3,TCat4,TCat5,TCat6,TCat7,TCat8,TCat9,TWardRowid,TSelect)=""
	q
seekcat(catcode)
	i catcode=TCat0Code s TCat0="Yes" q
	i catcode=TCat1Code s TCat1="Yes" q
	i catcode=TCat2Code s TCat2="Yes" q
	i catcode=TCat3Code s TCat3="Yes" q
	i catcode=TCat4Code s TCat4="Yes" q
	i catcode=TCat5Code s TCat5="Yes" q
	i catcode=TCat6Code s TCat6="Yes" q
	i catcode=TCat7Code s TCat7="Yes" q
	i catcode=TCat8Code s TCat8="Yes" q
	i catcode=TCat9Code s TCat9="Yes" q
	q
setcatcode(i,result)
  i i=0  d
	.s TCat0Code=$p(result,"@",1)
	.s TCat0=$p(result,"@",2)
  i i=1  d
	.s TCat1Code=$p(result,"@",1)
	.s TCat1=$p(result,"@",2)
  i i=2  d
	.s TCat2Code=$p(result,"@",1)
	.s TCat2=$p(result,"@",2)
  i i=3  d
	.s TCat3Code=$p(result,"@",1)
	.s TCat3=$p(result,"@",2)
  i i=4  d
	.s TCat4Code=$p(result,"@",1)
	.s TCat4=$p(result,"@",2)
  i i=5  d
	.s TCat5Code=$p(result,"@",1)
	.s TCat5=$p(result,"@",2)
  i i=6  d
	.s TCat6Code=$p(result,"@",1)
	.s TCat6=$p(result,"@",2)
  i i=7  d
	.s TCat7Code=$p(result,"@",1)
	.s TCat7=$p(result,"@",2)
  i i=8  d
	.s TCat8Code=$p(result,"@",1)
	.s TCat8=$p(result,"@",2)
  i i=9  d
	.s TCat0Code=$p(result,"@",1)
	.s TCat0=$p(result,"@",2)
}

ClassMethod GetDispWardListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDispWardListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetDispWardList(displocrowid As %String, StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "TWard:%String,TCat0:%String,TCat1:%String,TCat2:%String,TCat3:%String,TCat4:%String,TCat5:%String,TCat6:%String,TCat7:%String,TCat8:%String,TCat9:%String,TWardRowid:%String,TSelect:%String")
{
}

ClassMethod GetZTS() As %String
{
	s a=$$ALPHAUP^SSUTIL4($ZTIMESTAMP)
	s a1=$p(a,",",1)
	s a2=$p(a,",",2)
	s a=$j_a1_a2
	q a
}

ClassMethod GetAllDispCats(loc)
{
 
 s pl=$o(^DHCPL(0,"Loc",loc,""))
 q:pl="" ""        
 s ch=0
 s result=""
 f   s ch=$o(^DHCPL(pl,"DIS",ch)) q:ch=""  d
 . s distype=$p(^DHCPL(pl,"DIS",ch),"^",1)
 . s catcode=$p( ^DHCSTDRUGGRP(distype),"^",1)            
 . s catdesc=$p( ^DHCSTDRUGGRP(distype),"^",2)      
 . i result=""  s result=sdg
 . e  s result=result_"^"_sdg
  q result

 /*
 &sql(declare xx cursor for select sdg_code,sdg_desc From DHCStkDrugGroup)
 s result=""
 &sql(open xx)
 f  &sql(fetch xx into :catcode,:catdesc) q:SQLCODE  d
 . s sdg=catcode_"@"_catdesc
 . i result=""  s result=sdg
 . e  s result=result_"^"_sdg
 . .
 &sql(close xx)
 q result 
 */
}

ClassMethod GetDispCatCode(oeori As %String) As %String
{
 n (oeori)
 s ord=$p(oeori,"||",1),itm=$p(oeori,"||",2)
 q:ord="" "" q:itm="" "" q:'$d(^OEORD(ord,"I",itm,1)) ""
 s arcim=$p(^OEORD(ord,"I",itm,1),"^",2) q:arcim="" ""
 s sub=$p(arcim,"||",1),ver=$p(arcim,"||",2)
 q:sub="" "" q:ver="" "" q:'$d(^ARCIM(sub,ver,1))
 s arcic=$p(^ARCIM(sub,ver,1),"^",10) q:arcic="" ""
 &sql(select sdgi_sdg_parref->sdg_code into :sdgcode 
	 From DHCStkDrugGrpitm where sdgi_ordercat_dr=:arcic)
 q $g(sdgcode)
}

ClassMethod GetDispWardCnt(displocrowid As %String, startdate As %String, enddate As %String) As %String
{
	//Retrieve the wards that have dispensing requests 
	n (startdate,enddate,displocrowid)
	s d1=$zdh(startdate,4)
	s d2=$zdh(enddate,4)
	s phaloc=displocrowid
	s wardnum=0
	f dd=d1:1:d2  d 
	.s WardId=""
	.f  s WardId=$o(^DHCCLNurseExec("SendMedic",phaloc,dd,WardId))  q:WardId=""  d
	. . s wardnum=wardnum+1
	q wardnum
}

}
