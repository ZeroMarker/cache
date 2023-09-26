Import sqluser

Class web.DHCOutPhAdd Extends %Library.RegisteredObject [ Not Abstract, ClassType = "", ProcedureBlock ]
{

ClassMethod GLocPatPYClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GLocPatPYExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GLocPatPYExecute(ByRef QHandle As %Binary, CDateSt As %Library.String = "", CDateEnd As %Library.String = "", ctloc As %Library.String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	s ind=1
 	i $g(ctloc)=""  Set QHandle=$lb(0,repid,0) Quit $$$OK
 	s st=CDateSt,end=CDateEnd
 	i CDateSt="" S QHandle=$lb(0,repid,0)	Quit $$$OK  
 	i CDateEnd="" S QHandle=$lb(0,repid,0)	Quit $$$OK  
 	i st>end  Set QHandle=$lb(0,repid,0) Quit $$$OK
	s phl=""
	s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
	i phl=""  Set QHandle=$lb(0,repid,0) Quit $$$OK
	s phddate = "", t = 0
    f  s phddate=$o(^DHCPHDISPi(phddate)) q:phddate=""  d
      .q:phddate<st
      .q:phddate>end
      .s phdrow = ""
      .f  s phdrow=$o(^DHCPHDISPi(phddate,phl,phdrow)) q:phdrow=""  d
         ..s pyflag="",fyflag="",pydr="",fydr1="",prt="",inv="",pydate="",use="",perno="",pname=""
         ..s pytime=""
         ..s pytime=+$p(^DHCPHDISP(phdrow,1),"^",7)
         ..s pyflag=$p(^DHCPHDISP(phdrow,1),"^",6)
         ..s fyflag=$p(^DHCPHDISP(phdrow),"^",4)
         ..q:(pyflag'="1")&(fyflag'="1")
         ..s pydate=phddate
         ..s pydate=$zd(pydate,4)
         ..s pydr=$p(^DHCPHDISP(phdrow,1),"^",3)
         ..q:pydr'="" 
         ..s prescno=""
         ..s prescno=$p(^DHCPHDISP(phdrow,2),"^",1)
         ..s pmi=""
         ..s pmi=+$p(^DHCPHDISP(phdrow),"^",7)
         ..s perno=$p(^PAPER(pmi,"PAT",1),"^",2)
         ..s pname=$p(^PAPER(pmi,"ALL"),"^",1)
         ..s pyname=""
         ..;i $d(^DHCPHPER(pydr))  s pyname=$p(^DHCPHPER(pydr1),"^",2)
         ..s prt=+$p(^DHCPHDISP(phdrow),"^",2)
         ..q:'$d(^DHCINVPRT(prt))
         ..s inv=$p(^DHCINVPRT(prt),"^",14)
         ..s phdi="",phdmoney=0
         ..s tcheck=""
 	     ..set Data=$lb(pname,perno,pydate,prescno,inv,pyname,pydr,tcheck,phdrow)
 	     ..Set ^CacheTemp(repid,ind)=Data	
 	     ..Set ind=ind+1
   
    Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod GLocPatPYFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GLocPatPYExecute ]
{

 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)

 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }

 // Save QHandle
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

Query GLocPatPY(CDateSt As %String, CDateEnd As %String, ctloc As %String) As %Query(ROWSPEC = "TPerName:%String,TPmiNo:%String,TPrtDate:%String,TPrescNo:%String,TPrtInv:%String,TPyName:%String,TPydr:%String,TCheck:%String,TPhdrow:%String")
{
}

ClassMethod UpdatePyd(phdrow As %Library.String = "", pydr As %Library.String = "")
{
 &sql(update sqluser.dhc_phdispen set phd_php_pydr=:pydr where phd_rowid=:phdrow)
   q SQLCODE
}

ClassMethod GetHosName()
{
 s desc=""
 &sql(select hosp_desc into :desc from  sqluser.ct_hospital)
 q desc
}

ClassMethod QueryChFyClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryChFyExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryChFyExecute(ByRef QHandle As %Binary, ctloc As %Library.String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	s ind=1
	s loc=""
	s phl=""
	s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
	i phl="" S QHandle=$lb(0,repid,0) Quit $$$OK
	s phlp=""
	f  s phlp=$o(^DHCPHPER(phlp)) q:phlp=""  d
	  .s phwl="",phwdesc=""
	  .s phwl=+$p(^DHCPHPER(phlp),"^",3)
	  .q:phwl'=phl
	  .s use=""
	  .s use=$p(^DHCPHPER(phlp),"^",9)
	  .q:use="1"
	  .s phwdesc=$p(^DHCPHPER(phlp),"^",2)
	  .s Data=$lb(phwdesc,phlp)
 	  .S ^CacheTemp(repid,ind)=Data	
 	  .S ind=ind+1
 	S QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryChFyFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryChFyExecute ]
{
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)

 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }

 // Save QHandle
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

Query QueryChFy(ctloc As %String) As %Query(ROWSPEC = "PyName:%String,Pydr:%String")
{
}

/// description:门诊处方统计
/// modified by yunhaibao 20160711 处方统计按照发药日期
/// d ##class(%ResultSet).RunQuery("web.DHCOutPhAdd","GLocPresc","06/12/2018","06/12/2018","17:00","23:59","308","","","","92","1","EasyUI","1")
Query GLocPresc(CDateSt As %String, CDateEnd As %String, sttime As %String, endtime As %String, ctloc As %String, CPrescTypeID As %String, CPrescPhNum As %String, CIncCatID As %String, CPhCatID As %String, PrescType As %String, Plugin = "", GLocPresc As %String = "") As websys.Query(ROWSPEC = "TPrescType:%String,TPrescNum:%String,TPrescTotal:%String,TPrescBL:%String,TPrescMax:%String,TPrescMin:%String,TPrescMaxPmi:%String,TPrescMinPmi:%String,TPrescMaxMoney:%String,TPrescMinMoney:%String,TPrescMoney:%String,TPrescPhNum:%String,TCYFS:%String,TJYFS:%String,TJYCF:%String") [ SqlProc ]
{
}

ClassMethod GLocPrescExecute(ByRef QHandle As %Binary, CDateSt As %Library.String = "", CDateEnd As %Library.String = "", sttime As %Library.String = "", endtime As %Library.String = "", ctloc As %Library.String = "", CPrescTypeID As %Library.String = "", CPrescPhNum As %Library.String = "", CIncCatID As %Library.String = "", CPhCatID As %Library.String = "", PrescType As %Library.String = "", Plugin = "", FYFlag As %Library.String = "") As %Status
{
	i Plugin["EasyUI" s enterChar="</br>"
	s enterChar=$s(Plugin["EasyUI":"</br>",1:$c(10,13))
	Set repid=$I(^CacheTemp)
	s ind=1
	S QHandle=$lb(0,repid,0)
	//s ^hlh($h)=$lb(CDateSt, CDateEnd, sttime , endtime, ctloc, CPrescTypeID,CPrescPhNum, CIncCatID, CPhCatID,PrescType, Plugin, GLocPresc)
	s contentstr=""
	i $g(ctloc)=""  Set QHandle=$lb(0,repid,0) Quit $$$OK
	s CDateSt=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CDateSt)
	s CDateEnd=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CDateEnd)
	s sttime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(sttime)
	s endtime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(endtime)
	s startdate=CDateSt,enddate=CDateEnd
	i CDateSt="" S QHandle=$lb(0,repid,0)	Quit $$$OK  
	i CDateEnd="" S QHandle=$lb(0,repid,0)	Quit $$$OK  
	i startdate>enddate  Set QHandle=$lb(0,repid,0) Quit $$$OK
	s phl=""
	s pid=..NewPid()
	//s $zt="ErrorGLocPresc"
	k ^TMP("DHCOUTPHA",$this,"GLocPresc",pid)
	s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
	i phl=""  Set QHandle=$lb(0,repid,0) Quit $$$OK
	s phddate = "", t = 0,dd=0
	f  s phddate=$o(^DHCPHDISPi("FYDATE",phddate)) q:phddate=""  d
	.q:phddate<startdate
	.q:phddate>enddate
	.s phdrow = ""
	.f  s phdrow=$o(^DHCPHDISPi("FYDATE",phddate,phl,phdrow)) q:phdrow=""  d
	..k ^TMP("DHCOUTPHA",$this,"GLocPresc","OrdItm",pid)
	..s pyflag="",fyflag="",pydr="",fydr1="",prt=""
	..s inv="",pydate="",use="",perno="",pname=""
	..s pytime=""
	..s pytime=+$p(^DHCPHDISP(phdrow,1),"^",7)
	..s fytime=+$p(^DHCPHDISP(phdrow),"^",5)
	..s pyflag=$p(^DHCPHDISP(phdrow,1),"^",6)
	..s fyflag=$p(^DHCPHDISP(phdrow),"^",4)
	..s prt=+$p(^DHCPHDISP(phdrow),"^",2)
	..q:(fyflag'="1")
	..s fydate=phddate
	..s fydate=$zd(fydate,4)
	..q:(sttime'="")&(phddate=startdate)&(fytime<sttime)
	..q:(sttime'="")&(phddate=enddate)&(fytime>endtime)
	..s pydr=$p(^DHCPHDISP(phdrow,1),"^",3)
	..s prescno="",presctype="",prescmoney=0
	..s prescno=$p(^DHCPHDISP(phdrow,2),"^",1)
	..s tmpPhdSub=$o(^DHCPHDI(phdrow,"PHDI",""))
	..q:tmpPhdSub=""
	..s tmpOeori=$p(^DHCPHDI(phdrow,"PHDI",tmpPhdSub),"^",5)
	..s adm=$p(^OEORD(+tmpOeori),"^",1)
	..S admType=$p(^PAADM($g(adm)),"^",2)
	..q:(PrescType'="1")&(admType["O")
	..q:(PrescType'="2")&(admType["E")
	..q:(PrescType'="3")&(admType["H")
	..s PrescTypeCode=$p($g(^OEORD(+tmpOeori,"I",$p(tmpOeori,"||",2),11)),"^",18) // 费别
	..i PrescTypeCode="" s PrescTypeCode="10000"
	..s cyfs=0 //草药付数
	..s prescqty=0 //品种数
	..s phdch="",phdorditm="",m=0
	..f  s phdch=$o(^DHCPHDI(phdrow,"PHDI",phdch)) q:phdch=""  d
	...s phorditm=$p(^DHCPHDI(phdrow,"PHDI",phdch),"^",5)
	...s phdord=$p(phorditm,"||",1)
	...s phditm=$p(phorditm,"||",2)
	...s itmmast=$p(^OEORD(phdord,"I",phditm,1),"^",2)
	...s phcdrg=$p(^ARCIM($p(itmmast,"||",1),$p(itmmast,"||",2),1),"^",12)
	...s phcgeDr=$p(^PHCD(+phcdrg,4),"^",1)
	...s phcmId=$p(^PHCGE("GE",phcgeDr,"DHC"),"^",3)
	...s dhcphccat=$p(^DHCPHCM(phcmId),"^",3)
	...//s dhcphccat=$p($g(^PHCD(+$p(phcdrg,"||",1),"DF",1,"DHC")),"^",20) //yunhaibao20160704,修正为新药学分类
	...q:(CPhCatID'="")&&(CPhCatID'=dhcphccat)
	...s phdsub=""
	...f  s phdsub=$o(^DHCPHDI(phdrow,"PHDI",phdch,"INCLB",phdsub)) q:phdsub=""  d 
    ....s inci=+$p(^DHCPHDI(phdrow,"PHDI",phdch,"INCLB",phdsub),"^",3)
	....s incsc=+$p(^INCI(inci,2),"^",2)
	....q:(incsc'=CIncCatID)&(CIncCatID'="")
	....i '$d(^TMP("DHCOUTPHA",$this,"GLocPresc","OrdItm",pid,inci)) d
	.....s prescqty=prescqty+1 //品种数
	....s ^TMP("DHCOUTPHA",$this,"GLocPresc","OrdItm",pid,inci)=""
	....i '$d(^TMP("DHCOUTPHA",$this,"GLocPresc","PrescTypeCode",pid,PrescTypeCode,inci)) d
	.....s ^TMP("DHCOUTPHA",$this,"GLocPresc","PrescTypeCode",pid,PrescTypeCode)=1+$g(^TMP("DHCOUTPHA",$this,"GLocPresc","PrescTypeCode",pid,PrescTypeCode))
	....s ^TMP("DHCOUTPHA",$this,"GLocPresc","PrescTypeCode",pid,PrescTypeCode,inci)="" // 按类别的品种数
	....i '$d(^TMP("DHCOUTPHA",$this,"GLocPresc","PhNum",pid,inci)) d
	.....s ^TMP("DHCOUTPHA",$this,"GLocPresc","PhNum",pid)=1+$g(^TMP("DHCOUTPHA",$this,"GLocPresc","PhNum",pid))
	....s ^TMP("DHCOUTPHA",$this,"GLocPresc","PhNum",pid,inci)="" // 合计品种数
	....//s prescmoney=prescmoney+phdimoney
	....s m=m+1
	..
	..q:m=0
	..s jytype=""
	..s queId=##class(web.DHCSTCOMMONORDER).PrescCYQueId(prescno)
	..i queId'=""  d
	...s jytype=$p($g(^PAQUE1(queId,"DHC")),"^",15)
	...s duratId=$p($g(^OEORD(+tmpOeori,"I",+$p(tmpOeori,"||",2),2)),"^",6)
	...q:duratId="" 
	...s cyfs=$P($g(^PHCDU(duratId)),"^",2)
	..s pmi=""
	..s pmi=+$p(^DHCPHDISP(phdrow),"^",7)
	..s perno=$p(^PAPER(pmi,"PAT",1),"^",2)
	..s pname=$p(^PAPER(pmi,"ALL"),"^",1)
	..i prt=0 s prescmoney=##class(web.DHCOutPhDisp).GetPrescMoney(adm,prescno,ctloc,FYFlag) // yunhaibao,20170815,此处应为处方金额
	..e  s prescmoney=##class(web.DHCOutPhCommon).GetPriceByInv(phl,prt,prescno)
	..s prescmoney=$p(prescmoney,"^",1)
	..s t=t+1
	..i $d(^TMP("DHCOUTPHA",$this,"GLocPresc",pid,PrescTypeCode,prescno)) d
	...i jytype["代" d
	....
	...e  d
	...s $p(^TMP("DHCOUTPHA",$this,"GLocPresc",pid,PrescTypeCode,prescno),"^",1)=$p(^TMP("DHCOUTPHA",$this,"GLocPresc",pid,PrescTypeCode,prescno),"^",1)+prescmoney
	...s $p(^TMP("DHCOUTPHA",$this,"GLocPresc",pid,PrescTypeCode,prescno),"^",4)=$p(^TMP("DHCOUTPHA",$this,"GLocPresc",pid,PrescTypeCode,prescno),"^",4)+prescqty
	..e  d
	...i jytype["代" d
	....s ^TMP("DHCOUTPHA",$this,"GLocPresc",pid,PrescTypeCode,prescno)=prescmoney_"^"_perno_"^"_pname_"^"_prescqty_"^"_cyfs_"^"_cyfs_"^"_1
	...e  d
	....s ^TMP("DHCOUTPHA",$this,"GLocPresc",pid,PrescTypeCode,prescno)=prescmoney_"^"_perno_"^"_pname_"^"_prescqty_"^"_cyfs_"^"_0_"^"_0
	/// 计算金额最高与最低登记号的人
	s presctype=""
	f  s presctype=$o(^TMP("DHCOUTPHA",$this,"GLocPresc",pid,presctype)) q:presctype=""  d
	.q:presctype=""
	.s presc=""
	.f  s presc=$o(^TMP("DHCOUTPHA",$this,"GLocPresc",pid,presctype,presc)) q:presc=""  d
	..q:presc=""
	..s prescdata=^TMP("DHCOUTPHA",$this,"GLocPresc",pid,presctype,presc)
	..s prescmoney=+$p(prescdata,"^",1),patno=$p(prescdata,"^",2),patname=$p(prescdata,"^",3)
	..i $d(^TMP("DHCOUTPHA",$this,"GLocPresc","MaxMin",pid,presctype,prescmoney)) d
	...i $p(^TMP("DHCOUTPHA",$this,"GLocPresc","MaxMin",pid,presctype,prescmoney),"^",1)'[patno d
	....s $p(^TMP("DHCOUTPHA",$this,"GLocPresc","MaxMin",pid,presctype,prescmoney),"^",1)=$p(^TMP("DHCOUTPHA",$this,"GLocPresc","MaxMin",pid,presctype,prescmoney),"^",1)_enterChar_patno
	....s $p(^TMP("DHCOUTPHA",$this,"GLocPresc","MaxMin",pid,presctype,prescmoney),"^",2)=$p(^TMP("DHCOUTPHA",$this,"GLocPresc","MaxMin",pid,presctype,prescmoney),"^",2)_enterChar_patname
	..e  s ^TMP("DHCOUTPHA",$this,"GLocPresc","MaxMin",pid,presctype,prescmoney)=patno_"^"_patname
	//总计
	s presctype=""  //处方类型
	s totalmoney=0 //合计金额
	s totalprescnum=0 //合计处方数量
	s totalprescsum=0 //处方总数  
	s totalprescbl="" //处方比率
	s totalphnum=0 //品种数
	s totalcyfs=0 //合计草药付数
	s totaljyfs=0 //合计煎药付数
	s totalprescjy=0 //合计煎药处方数
	f  s presctype=$o(^TMP("DHCOUTPHA",$this,"GLocPresc",pid,presctype)) q:presctype=""  d
	.i presctype="10000" s presctypedesc="其他"
	.e  s presctypedesc=$p(^PAC("ADMREA",presctype),"^",2)
	.//按类型合计
	.s prescmaxmoney=0
	.s prescminmoney=0
	.s prescmaxpmino=""
	.s prescminpmino=""
	.s prescmaxpminame=""
	.s prescminpminame=""
	.s prescbl="" //处方比率
	.s prescmoney=0
	.s prescnum=0
	.s prescsum=0
	.s cyfs=0
	.s jyfs=0
	.s prescjy=0
	.s phnum=0
	.s presc=""
	.f  s presc=$o(^TMP("DHCOUTPHA",$this,"GLocPresc",pid,presctype,presc)) q:presc=""  d
	..s prescdata=^TMP("DHCOUTPHA",$this,"GLocPresc",pid,presctype,presc)
	..s prescsum=prescsum+1 //处方总数
	..s tmpprescmoney=+$p(prescdata,"^",1)
	..s prescmoney=+prescmoney+$p(prescdata,"^",1) //处方金额
	..s prescpmino=$p(prescdata,"^",2)
	..s prescpname=$p(prescdata,"^",3)
	..//s phnum=phnum+$p(prescdata,"^",4)
	..s cyfs=cyfs+$p(prescdata,"^",5) //草药付数
	..s jyfs=jyfs+$p(prescdata,"^",6) //煎药付数
	..s prescjy=prescjy+$p(prescdata,"^",7) //煎药处方数
	..s prescmaxmoney=$o(^TMP("DHCOUTPHA",$this,"GLocPresc","MaxMin",pid,presctype,""),-1)
	..s prescmaxinfo=$g(^TMP("DHCOUTPHA",$this,"GLocPresc","MaxMin",pid,presctype,prescmaxmoney))
	..s prescminmoney=$o(^TMP("DHCOUTPHA",$this,"GLocPresc","MaxMin",pid,presctype,""))
	..s prescmininfo=$g(^TMP("DHCOUTPHA",$this,"GLocPresc","MaxMin",pid,presctype,prescminmoney))
	..s prescmaxpmino=$p(prescmaxinfo,"^",1),prescmaxpminame=$p(prescmaxinfo,"^",2)
	..s prescminpmino=$p(prescmininfo,"^",1),prescminpminame=$p(prescmininfo,"^",2)
	..i (CPrescPhNum="") d
	...s prescnum=prescsum
	..e  i (CPrescPhNum=+$p(prescdata,"^",4)) s prescnum=prescnum+1
	.s phnum=$g(^TMP("DHCOUTPHA",$this,"GLocPresc","PrescTypeCode",pid,presctype))
	.s totalmoney=totalmoney+prescmoney
	.s totalprescnum=totalprescnum+prescnum
	.s totalprescsum=totalprescsum+prescsum
	.s totalphnum=totalphnum+phnum
	.s totalcyfs=totalcyfs+cyfs
	.s totaljyfs=totaljyfs+jyfs
	.s totalprescjy=totalprescjy+prescjy
	.s prescbl=100*(prescnum/prescsum)
	.s prescbl=$j(prescbl,10,2) 
	.s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag("")
	.i EncryptFlag=1 d
	..i contentstr="" d
	...s contentstr=presctypedesc_"^"_prescnum_"^"_prescsum_"^"_prescbl_"^"_prescmaxpminame_"^"_prescminpminame_"^"_prescmaxpmino_"^"_prescminpmino
	.set Data=$lb(presctypedesc,prescnum,prescsum,prescbl,prescmaxpminame,prescminpminame,prescmaxpmino,prescminpmino,prescmaxmoney,prescminmoney,prescmoney,phnum,cyfs,jyfs,prescjy)
	.Set ^CacheTemp(repid,ind)=Data	
	.Set ind=ind+1
	s totalphnum=$g(^TMP("DHCOUTPHA",$this,"GLocPresc","PhNum",pid))
	s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag("")
	i (EncryptFlag=1)&(contentstr'="") d
	.s condition=##class(web.DHCSTCOMMONSRV).ChangeToJson("CDateSt^CDateEnd^sttime^endtime^ctloc^CPrescTypeID^CPrescPhNum^CIncCatID^CPhCatID",CDateSt_"^"_CDateEnd_"^"_sttime_"^"_endtime_"^"_ctloc_"^"_CPrescTypeID_"^"_CPrescPhNum_"^"_CIncCatID_"^"_CPhCatID)
	.s content=##class(web.DHCSTCOMMONSRV).ChangeToJson("TPrescType^TPrescNum^TPrescTotal^TPrescBL^TPrescMax^TPrescMin^TPrescMaxPmi^TPrescMinPmi",contentstr)
	.s EncryptCode=$o(^User.DHCSecretLevelI("Code",""))
	.s eventlogret=##class(web.DHCSTCOMMONSRV).CreateEventLog("DHCOUTPRESCSTAT",condition,content,EncryptCode)   //记录日志
	set Data=$lb("合计",totalprescnum,totalprescsum,"","","","","","","",totalmoney,totalphnum,totalcyfs,totaljyfs,totalprescjy)
	k ^TMP("DHCOUTPHA",$this,"GLocPresc",pid)
	k ^TMP("DHCOUTPHA",$this,"GLocPresc","OrdItm",pid)
	k ^TMP("DHCOUTPHA",$this,"GLocPresc","MaxMin",pid)
	k ^TMP("DHCOUTPHA",$this,"GLocPresc","PrescTypeCode",pid)
	k ^TMP("DHCOUTPHA",$this,"GLocPresc","PhNum",pid)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
ErrorGLocPresc
	k ^TMP("DHCOUTPHA",$this,"GLocPresc",pid)
	k ^TMP("DHCOUTPHA",$this,"GLocPresc","OrdItm",pid)
	k ^TMP("DHCOUTPHA",$this,"GLocPresc","MaxMin",pid)
	s Error=$$Error^DHCSTERROR()
	Set ind=ind+1
	Set QHandle=$lb(0,repid,0)
	q $$$OK
}

ClassMethod GPrescTypeClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GPrescTypeExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GPrescTypeExecute(ByRef QHandle As %Binary, ctloc As %Library.String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	s ind=1
	s rea=""
	f  s rea=$o(^PAC("ADMREA",rea)) q:rea=""  d
	  .s desc=""
	  .q:rea=0
	  .s desc=$p(^PAC("ADMREA",rea),"^",2)
	  .s Data=$lb(desc,rea)
 	  .S ^CacheTemp(repid,ind)=Data	
 	  .S ind=ind+1
 	S QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod GPrescTypeFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GPrescTypeExecute ]
{
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)

 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }

 // Save QHandle
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

Query GPrescType(ctloc As %String) As %Query(ROWSPEC = "TypeDesc:%String,TypeRowid:%String")
{
}

ClassMethod QueryPhDescClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryPhDescExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryPhDescExecute(ByRef QHandle As %Binary, ctloc As %Library.String = "", input As %Library.String = "") As %Status
{
  Set repid=$I(^CacheTemp)
	s ind=1
	s stkgrptype="",stkgrpcode=""
	i input="" S QHandle=$lb(0,repid,0)	Quit $$$OK 
	s input=$g(input)
	s input=$ZCVT(input,"U")
	s input="^"_input 
	k ^DHCTMPSAME($j)
	s num=0
	k ^DHCPHTMP($j,"Itmrowid"),^DHCPHTMP($j,"Itmcode"),^DHCPHTMP($j,"Itmdesc"),^DHCPHTMP($j,"ItmUO")
    s inca="0"
    f  s inca=$o(^INCALIAS(inca)) q:(inca="")!(inca="0")  d
     .s incatext=""
     .s incatext=$p(^INCALIAS(inca),"^",4)
     .s incatext=$ZCVT(incatext,"U")
     .s incatext="^"_incatext
     .q:incatext'[input
     .s inci=""
     .s inci=+$p(^INCALIAS(inca),"^",1)
     .q:$d(^DHCTMPSAME($j,inci))
     .s ^DHCTMPSAME($j,inci)="ok"
     .s incil="",pp=0
     .f  s incil=$o(^INCI("IL_LOC",ctloc,inci,incil)) q:incil=""  d
	    ..s pp=pp+1
	  .q:pp=0
	  .s num=num+1
	  .s ^DHCPHTMP($j,"Itmrowid",num)=inci
	  .s ^DHCPHTMP($j,"Itmcode",num)=$p(^INCI(inci,1),"^",1)
	  .s ^DHCPHTMP($j,"Itmdesc",num)=$p(^INCI(inci,1),"^",2)
	  .s uomdr=$p(^INCI(inci,1),"^",10)
	  .s ^DHCPHTMP($j,"ItmUO",num)="" i uomdr'="" s ^DHCPHTMP($j,"ItmUO",num)=$p(^CT("UOM",+uomdr),"^",2)
   s ii=1
   s sysdate=""
   s sysdate=+$h+1
   for ii=1:1:num 
     { s itmrowid="",itmcode="",itmdesc="",phuomdesc="",phuom="",price=0,retprice=""
      s itmrowid=^DHCPHTMP($j,"Itmrowid",ii)
      s itmcode=^DHCPHTMP($j,"Itmcode",ii)
      s itmdesc=^DHCPHTMP($j,"Itmdesc",ii)
      s arcitm="",locdate=""
      s locdate=$o(^DHCLOCTOT(0,"LOCITMDATE",ctloc,itmrowid,sysdate),-1)
      q:locdate=""
      s locdaily=$o(^DHCLOCTOT(0,"LOCITMDATE",ctloc,itmrowid,locdate,""))
      s locqtybas=0
      q:locdaily=""
      s locqtybas=+$p(^DHCLOCTOT(locdaily),"^",4)
      ;i locqtybas=0 q
      s arcitm=$p(^INCI(itmrowid,1),"^",3)
      Q:arcitm=""
      s phuom=+$p(^ARCIM($p(arcitm,"||",1),$p(arcitm,"||",2),8),"^",14)
      s phuomdesc=$p($g(^CT("UOM",phuom)),"^",2)
      s basuom=""
      s basuom=+$p(^INCI(itmrowid,1),"^",10)
	  s confac=1,conrow=""
	  i basuom=phuom s confac=1
	  e  d
	    .s conrow=$o(^CT("CTCF",0,"UOM",phuom,basuom,conrow))
	    .i conrow'="" s confac=+$p(^CT("CTCF",conrow),"^",3)
      s qty=0
      s qty=locqtybas/confac
      s HospString=##class(web.DHCSTCOMMONSRV).GetLocHosp(ctloc)
      s hospdr=$p(HospString,"^",1)
	  //s price=##class(web.DHCSTCOMMONSRV).GetPriceElse(+itmrowid,+$h,phuom,hospdr)
	  s price=##class(web.DHCSTPRICE).GetSp(+itmrowid,+$h,phuom,hospdr,"")	//zhouyg 20150113
	  ;s price=##class(web.DHCOPItemMast).GetOrderPrice("","",arcitm,+$h,"","","","","")
      ;s retprice=##class(web.DHCOPItemMast).GetOrderPrice("","",arcitm,+$h,"","","","")
      ;q:retprice=""
      ;s price=$p(retprice,"^",1)
      ;s price=$fn(price,"",2)
	  set Data=$lb(itmdesc,itmrowid,phuomdesc,phuom,price,qty)
	  Set ^CacheTemp(repid,ind)=Data
	  Set ind=ind+1
	   }
 	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryPhDescFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPhDescExecute ]
{

 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

Query QueryPhDesc(ctloc As %String, input As %String) As %Query(ROWSPEC = "名称:%String,IncId:%String,单位:%String,UomID:%String,单价:%String,库存:%String")
{
}

ClassMethod GetPhDescClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetPhDescExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetPhDescExecute(ByRef QHandle As %Binary, ctloc As %Library.String = "", input As %Library.String = "") As %Status
{
     Set repid=$I(^CacheTemp)
	 s ind=1
	 s stkgrptype="",stkgrpcode=""
	 i input="" S QHandle=$lb(0,repid,0)	Quit $$$OK 
	 s input=$g(input)
	 s input=$ZCVT(input,"U") 
	 s input="^"_input
	 k ^DHCTMPSAME($j)
	 s num=0
	 k ^DHCPHTMP($j,"Itmrowid"),^DHCPHTMP($j,"Itmcode"),^DHCPHTMP($j,"Itmdesc"),^DHCPHTMP($j,"ItmUO")
     s inca="0"
     f  s inca=$o(^INCALIAS(inca)) q:(inca="")!(inca="0")  d
     .s incatext=""
     .s incatext=$p(^INCALIAS(inca),"^",4)
     .s incatext=$ZCVT(incatext,"U")
     .s incatext="^"_incatext
     .q:incatext'[input
     .s inci=""
     .s inci=+$p(^INCALIAS(inca),"^",1)
     .q:inci=0
     .q:$d(^DHCTMPSAME($j,inci))
     .s ^DHCTMPSAME($j,inci)="ok"
     .s incil="",pp=0
     .f  s incil=$o(^INCI("IL_LOC",ctloc,inci,incil)) q:incil=""  d
	 ..s pp=pp+1
	 .q:pp=0
	 .s num=num+1
	 .s ^DHCPHTMP($j,"Itmrowid",num)=inci
	 .s ^DHCPHTMP($j,"Itmcode",num)=$p(^INCI(inci,1),"^",1)
	 .s ^DHCPHTMP($j,"Itmdesc",num)=$p(^INCI(inci,1),"^",2)
	 .s uomdr=$p(^INCI(inci,1),"^",10)
	 .s ^DHCPHTMP($j,"ItmUO",num)="" i uomdr'="" s ^DHCPHTMP($j,"ItmUO",num)=$p(^CT("UOM",+uomdr),"^",2)
     s ii=1
     s sysdate=""
     s sysdate=+$h+1
     for ii=1:1:num 
     { 
      s itmrowid="",itmcode="",itmdesc="",phuomdesc="",phuom="",price=0,retprice=""
      s itmrowid=^DHCPHTMP($j,"Itmrowid",ii)
      s itmcode=^DHCPHTMP($j,"Itmcode",ii)
      s itmdesc=^DHCPHTMP($j,"Itmdesc",ii)
      s arcitm="",locdate="",locqtybas=0
      s locdate=$o(^DHCLOCTOT(0,"LOCITMDATE",ctloc,itmrowid,sysdate),-1)
      q:locdate=""
      s locdaily=$o(^DHCLOCTOT(0,"LOCITMDATE",ctloc,itmrowid,locdate,""))
      s locqtybas=0
      s locqtybas=+$p(^DHCLOCTOT(locdaily),"^",4)
      //i locqtybas=0 q
      s arcitm=$p(^INCI(itmrowid,1),"^",3)
      Q:arcitm=""
      s phuom=+$p(^ARCIM($p(arcitm,"||",1),$p(arcitm,"||",2),8),"^",14)
      s phcdrg="",phcform="",phfact="",drgmast="",ybcode="",ybdesc="",factdesc=""
      s phcdrg=$p(^ARCIM($p(arcitm,"||",1),$p(arcitm,"||",2),1),"^",12)
      i phcdrg'=""  d
	    .s phcform=$p(^PHCD($p(phcdrg,"||",1),"DF",$p(phcdrg,"||",2),1),"^",1)
	    .s phfact=$p(^PHCD($p(phcdrg,"||",1),2),"^",4)
	  e  d
	    .s phcform="",phfact=""
	  i phcdrg'=""  s drgmast=$p(phcdrg,"||",1)
	  e  s drgmast=""
	  i drgmast'="" s ybcode=$p(^PHCD(drgmast,4),"^",2)
	  e  s ybcode=""
	  i ybcode="1" s ybdesc="无自付"
	  i ybcode="2" s ybdesc="有自付"
	  i ybcode="3" s ybdesc="全自付"
	  i phfact=""  s factdesc="" 
      e  d
        .i '$d(^PHMNF(phfact))  s factdesc="" 
        .e  s factdesc=$p(^PHMNF(phfact),"^",2)
      s phuomdesc=$p($g(^CT("UOM",phuom)),"^",2)
      s basuom=""
      s basuom=+$p(^INCI(itmrowid,1),"^",10)
	  s confac=1,conrow=""
	  i basuom=phuom d
	    .s confac=1
	  e  d
	    .s conrow=$o(^CT("CTCF",0,"UOM",phuom,basuom,conrow))
	    .i conrow'="" s confac=+$p(^CT("CTCF",conrow),"^",3)
      s qty=0
      ;q:locqtybas=0
      s qty=locqtybas/confac
      //s retprice=##class(web.DHCOPItemMast).GetOrderPrice("","",arcitm,+$h,"","","","")
      //q:retprice=""
      //s price=$p(retprice,"^",1)
      s HospString=##class(web.DHCSTCOMMONSRV).GetLocHosp(ctloc)
      s hospdr=$p(HospString,"^",1)
	  //s price=##class(web.DHCSTCOMMONSRV).GetPriceElse(+itmrowid,+$h,phuom,hospdr)
	  //s price=$fn(price,"",6)
	  s price=##class(web.DHCSTPRICE).GetSp(+itmrowid,+$h,phuom,hospdr,"")	//zhouyg 20150113
	  set Data=$lb(itmdesc,ybdesc,phuomdesc,factdesc,price,qty)
	  Set ^CacheTemp(repid,ind)=Data
	  Set ind=ind+1
	  
	   }
 	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod GetPhDescFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPhDescExecute ]
{

 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

Query GetPhDesc(ctloc As %String, input As %String) As %Query(ROWSPEC = "PhDesc:%String,IncId:%String,UomDesc:%String,Uom:%String,Price:%String,LocQty:%String")
{
}

ClassMethod QueryPhClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryPhExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryPhExecute(ByRef QHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	s ind=1
	set Data=$lb("","","","","","","")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
 	S QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryPhFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPhExecute ]
{
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)

 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

Query QueryPh() As %Query(ROWSPEC = "TPhDesc:%String,TPhInci:%String,TPhUomDesc:%String,TPhUom:%String,TPhPrice:%String,TPhQty:%String,TPhMoney:%String")
{
}

ClassMethod InsertPerInf(name, sex, age, typeid, patno, note)
{
 s patcode="",patrow="",phprow="",pat=""
 s inprow=""
 i sex=""  d
    .&sql(insert into sqluser.dhc_phinperson(phinp_age,phinp_name,phinp_demo,phinp_patno,PHINP_SOCSTATUS_DR)
     values(:age,:name,:note,:patno,:typeid))
 e  d
    .&sql(insert into sqluser.dhc_phinperson(phinp_age,phinp_name,phinp_sex_dr,phinp_demo,phinp_patno,PHINP_SOCSTATUS_DR)
     values(:age,:name,:sex,:note,:patno,:typeid))
 i SQLCODE q -1
 s inprow=+$g(%ROWID)
 q inprow
}

/// Description:处理非正常发药
/// Input:数据格式,操作员ID
/// Output: >0 成功  , 非>0 失败
/// Creator:Liang Qiang
/// CreatDate:2011-03-16
ClassMethod InsertUnDisp(tmpStirng)
{
	
	     s ret=0
		 s currdate=$p($h,",",1)
		 s currtime=$p($h,",",2)
		 s dispenStr=$p(tmpStirng,"!!",1)
		 s dispitmStr=$p(tmpStirng,"!!",2)
		 s patname=$p(dispenStr,"^",1)
		 s patsex=$p(dispenStr,"^",2)
		 //s patage=$p(dispenStr,"^",3)
		 s pattype=$p(dispenStr,"^",4)
		 s patpmi=$p(dispenStr,"^",5)
		 s pmi=$o(^PAPERi("PAPMI_PatNo",patpmi,""))
		 s patage=##class(web.DHCSTKUTIL).GetAgeNum(pmi) //年龄统一调用接口(比较用的年龄)wyx 2015-01-29
		 s patnote=$p(dispenStr,"^",6)
		 s ctloc=$p(dispenStr,"^",7)
		 s userid=$p(dispenStr,"^",8)
		 s poscode=$p(dispenStr,"^",9)
		 s reasid=$p(dispenStr,"^",10)
		 
		 s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(ctloc)
         s HospID=$p(CustStr,"^",5)
         s CustID=$p(CustStr,"^",1)
		 
		 TSTART
		 Set $ZT="troll"
		 l +^OUTUNDISP("OUTUNDISP",patpmi):5 e  q -1
		 &sql(insert into sqluser.dhc_phinperson(phinp_age,phinp_name,phinp_sex_dr,phinp_demo,phinp_patno,PHINP_SOCSTATUS_DR)
		     values(:patage,:patname,:patsex,:patnote,:patpmi,:pattype))
		 i SQLCODE'=0 d exit
		 i SQLCODE q -2
		 s perrow=+$g(%ROWID)
		 //
		 s phl="",php=""
		 s phl=$o(^DHCPHLOCi("LOC",ctloc,"")) 
		 s inphp=""
		 f  s inphp=$o(^DHCPHPERi("USR",userid,inphp)) q:(inphp="")!(php'="")  d
		   .s inphl=""
		   .s inphl=+$p(^DHCPHPER(inphp),"^",3)
		   .i inphl=phl s php=inphp
		   .
		 &sql(insert into sqluser.dhc_phundispen(phund_date,phund_time,phund_month,phund_php_dr,
		      phund_phinp_dr,phund_phl_dr,phund_finflag,PHUND_CUFLAG1,PHUND_PHUNDR_DR)
		  values(:currdate,:currtime,:currdate,:php,:perrow,:phl,'1',:poscode,:reasid))
		 i SQLCODE'=0 d exit
		 i SQLCODE'=0 q -3
		 s phundrow=+$g(%ROWID)
		 //
		 s ret=0
		 s itmnum=$l(dispitmStr,"%") 
		 f i=1:1:itmnum q:ret<0  d
		 .s dispitm=$p(dispitmStr,"%",i)
		 .s inci=$p(dispitm,"^",1)
		 .s uom=$p(dispitm,"^",2)
		 .s incicode=$p(^INCI(inci,1),"^",1)
		 .s incibuom=$p(^INCI(inci,1),"^",10)
		 .s fac=##class(web.DHCSTCOMMONSRV).UOMFac(uom,incibuom)
		 .i fac=0 s fac=1
		 .s qty=$p(dispitm,"^",3)
		 .s qty=qty*fac
		 .s price=$p(dispitm,"^",4)
		 .s money=$p(dispitm,"^",5)
		 .s sub=i
		 .&sql(insert into sqluser.dhc_phundispitm(phundi_phund_parref,phundi_childsub,phundi_inci_dr,phundi_qty,
		 phundi_total,phundi_price,phundi_ctuom_dr) values(:phundrow,:sub,:inci,:qty,:money,:price,:uom))
		 .i SQLCODE'=0  s ret=-4
		 .q:ret<0
		 .s phunitm=phundrow_"||"_sub
		 .s:$G(pid)="" pid=##CLASS(web.DHCSTKUTIL).GetInclbCounter()
		 .s price=price/fac  //基本单位单价
		 .s CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(inci)
	     .s StkTypeDesc=$P(CatGrpStr,"^",4)
	     .//s Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"
	     .s Perv="^^^"_StkTypeDesc_"^"_HospID_"^DHC"	//zhouyg 20141208 BS药库参数变化
	     .s price=##Class(web.DHCSTCOMMPARA).GetNumbDec(price,Perv,"FmtSA",1)
		 .s ret=..InsertPhUndispItmClb(inci,qty,price,ctloc,phunitm,pid,userid)
         .i ret<0 s ret=-5
         .
         i +ret<0 d exit 
		 Q:+ret<0 ret
		 s ret=phundrow	 
		 TCOMMIT
		 
		 Q ret
exit
  TRO
  l -^OUTUNDISP("OUTUNDISP",patpmi)
  q
troll
  Set $ZT=""
  TRo
  l -^OUTUNDISP("OUTUNDISP",patpmi)
  s ErrorMsg=$ZE
  q ErrorMsg
}

/// Description:处理非正常发药批次表
/// Output: =0 成功  , 非0 失败
/// Creator:Liang Qiang
/// CreatDate:2011-03-16
/// 
ClassMethod InsertPhUndispItmClb(inci, qty, price, locdr, phunitm, pid, usesr)
{
	 
	 l +^DHCINCIL(locdr,inci):10  e  q -1   ;加锁
	 k ^TMPGETINCLB(pid)
	 s stkqty=##CLASS(web.DHCSTSTKQTY).GetInclbQty(inci,qty,locdr,pid)
	 i stkqty=0 d exit
	 q:stkqty=0 -2
	 s newclb="",itmclbnum=0,sub=0
	 f  s newclb=$o(^TMPGETINCLB(pid,newclb)) q:(newclb="")!(itmclbnum'=0)  d
	 .s baseqty=0
	 .s sub=sub+1
	 .s baseqty=$p(^TMPGETINCLB(pid,newclb),"^",1)
	 .&sql(insert into SQLUSER.DHC_PHUNDISPITMCLB(PHUNDIC_PHUNDI_PARREF,PHUNDIC_CHILDSUB,PHUNDIC_INCLB_DR,PHUNDIC_QTY)
	       values(:phunitm,:sub,:newclb,:baseqty))
	 .i SQLCODE'=0  d
	 ..s itmclbnum=itmclbnum+1
	 ..s tt=newclb
	 .q:SQLCODE'=0
	 .s phunitmclb=phunitm_"||"_sub
     .s Err=..InsertTransForUndisp(newclb,-baseqty,price,usesr,locdr,phunitmclb)
     .s:Err'=0 itmclbnum=itmclbnum+1
     .
	 d exit
	 i itmclbnum'=0 q -3
	 i sub=0 q -4
	 q 0
exit
  l -^DHCINCIL(locdr,inci)
  k ^TMPGETINCLB(pid)
  q
}

/// Description:处理非正常发药批次表
/// Output: =0 成功  , 非0 失败
/// Creator:Liang Qiang
/// CreatDate:2011-03-16
/// 
ClassMethod InsertPhUnRetItmClb(inci, qty, price, locdr, phunitm, pid, usesr)
{
	 
	 l +^DHCINCIL(locdr,inci):10  e  q -1   ;加锁
	 
	 s cil=$o(^INCI("IL_LOC",locdr,inci,""))
	 q:cil="" -2
     s clb=$o(^INCI(inci,"IL",cil,"LB",""),-1)
     s inclb=inci_"||"_cil_"||"_+clb
     s Err=..InsertTransForUndisp(inclb,qty,price,usesr,locdr,phunitm)
	 d exit
	 i Err'=0 q -3
	 q 0
exit
  l -^DHCINCIL(locdr,inci)
  q
}

/// Description:处理非正常发药库存,台帐
/// Output: =0 成功  , 非0 失败
/// Creator:Liang Qiang
/// CreatDate:2011-03-16
/// 
ClassMethod InsertTransForUndisp(inclb, qty, Price, User, locdr, phunitmclb)
{
	 i qty>0 s Type="Z"
	 i qty<0 s Type="S" 
	 s inci=+inclb
	 s ItmCode=$p(^INCI(inci,1),"^",1)
	 s UomDescDr=$p(^INCI(inci,1),"^",10)
	 s UomDesc=$p( ^CT("UOM",UomDescDr),"^",2)
	 s LocDesc=$p(^CTLOC(locdr),"^",2)
	 s Pointer=phunitmclb
	 s Data=Type_"^"_""_"^"_inclb_"^"_qty_"^"_UomDesc_"^"_ItmCode_"^"_Price_"^"_User_"^"_Pointer_"^"_LocDesc
	 s Err=##class(web.DHCST01).UPDINCI(Data)
     q:Err=0 -1
	 q 0
}

ClassMethod InsertUnDispOLD(ctloc, userid, perrow, poscode, reas)
{
 s currdate="",currtime="",ssusr="",undrow="",ret=""
 s currdate=$p($h,",",1)
 s currtime=$p($h,",",2)
 s phl="",php=""
 s phl=$o(^DHCPHLOCi("LOC",ctloc,"")) 
 k ^TMPINCLBT($j)
 s inphp=""
 f  s inphp=$o(^DHCPHPERi("USR",userid,inphp)) q:(inphp="")!(php'="")  d
   .s inphl=""
   .s inphl=+$p(^DHCPHPER(inphp),"^",3)
   .i inphl=phl s php=inphp
 &sql(insert into sqluser.dhc_phundispen(phund_date,phund_time,phund_month,phund_php_dr,
      phund_phinp_dr,phund_phl_dr,phund_finflag,PHUND_CUFLAG1,PHUND_PHUNDR_DR)
  values(:currdate,:currtime,:currdate,:php,:perrow,:phl,'1',:poscode,:reas))
 i SQLCODE'=0 q -1
 s phundrow="",ADRowid=""
 s phundrow=+$g(%ROWID)

 k PLIST
 s PLIST(3)=currdate
 s PLIST(5)=userid
 s PLIST(6)=""
 s PLIST(9)="4"
 s error=0
 s adjno=""
 Set Config=##Class(websys.Configuration).%OpenId(1)
 Set MEDDATA=Config.DataNamespace            ;得到当前的MEDTRAK的NameSpace,保存到MEDDATA中
 Set LABDATA=Config.LabDataNamespace         ;得到当前的LABTRAK的NameSpace,保存到LABDATA中
 Set CurrentNS=$ZNSPACE                      ;保存当前所用的NameSpace  
 ZN MEDDATA                                  ;切换到所希望的NameSpace,
 s error=$$INSERT^MVBSTAD("A")
 i error'=0 q -1 
 s ADRowid=+$g(%ROWID)
 s dhcadjrow=""
 s adjno=$$GetMaxAdjNo^DHCSTCOMMONSRV("AD")
 zn CurrentNS
 &sql(insert into sqluser.dhc_inadj(inad_adj_dr,inad_date,inad_time,inad_ReasonAdj_DR,inad_State,
      inad_ssusr_dr,inad_no,INAD_ChkDate,inad_chktime,inad_chkusr_dr)
     values(:ADRowid,:currdate,:currtime,"",'20',:userid,:adjno,:currdate,:currtime,:userid))
 s dhcadjrow=+$g(%ROWID)
 s ret=phundrow_"^"_ADRowid_"^"_dhcadjrow
 s $p(^DHCPHUND(phundrow),"^",13)=ADRowid
 q ret
}

ClassMethod InsUDItm(ctloc, allrow, inci, uom, qty, price, money, sub, xsub)
{
 s basuom=""
 s undrow=$p(allrow,"^",1)
 s adjrow=$p(allrow,"^",2)
 s dhcadjrow=$p(allrow,"^",3)
 s basuom=+$p(^INCI(inci,1),"^",10)
 s confac=1
 s conrow=""
 k ^TMPINCLBT($j)
 i xsub="" s xsub=0
 i basuom=uom s confac=1
 e  d
   .s conrow=$o(^CT("CTCF",0,"UOM",uom,basuom,conrow))
   .i conrow'="" s confac=+$p(^CT("CTCF",conrow),"^",3)
 s adjqty=0,adjprice=0
 s adjqty=qty*confac
 s adjprice=price/confac
 &sql(insert into sqluser.dhc_phundispitm(phundi_phund_parref,phundi_childsub,phundi_inci_dr,phundi_qty,
 phundi_total,phundi_price,phundi_ctuom_dr) values(:undrow,:sub,:inci,:qty,:money,:price,:uom))
 s err="",paus=0
 i SQLCODE'=0 d
  .&sql(delete from sqluser.dhc_phundispen where phund_rowid=:undrow)
  .&sql(delete from sqluser.in_adj where inad_rowid=:adjrow)
  .&sql(delete from sqluser.dhc_inadj where inad_rowid=:dhcadjrow)
  .s paus=-1
 i paus=-1 q -1
 s err=##CLASS(web.DHCOutPhAdd).GetInclbOrd(inci,ctloc,adjqty)
 s ret=""
 s ret=##CLASS(web.DHCOutPhAdd).InsertAdjItm(inci,ctloc,adjrow,basuom,adjprice,xsub,dhcadjrow)
 q ret
}

ClassMethod GetInclbOrd(inc, loc, basqty)
{
 s incil="0",tr=""
 f  s incil=$o(^INCI("IL_LOC",loc,inc,incil)) q:(incil="")!(tr="ok")!(incil="0")  d
 .s inclb="0"
 .f  s inclb=$o(^INCI(inc,"IL",incil,"LB",inclb)) q:(inclb="")!(tr="ok")!(inclb="0")  d
 ..s clbqty=0
 ..s clbqty=+$p(^INCI(inc,"IL",incil,"LB",inclb),"^",2)
 ..i clbqty="" s clbqty=0
 ..q:clbqty=0
 ..i clbqty'<basqty d
 ...s ^TMPINCLBT($j,inc,incil,inclb)=basqty
 ...s tr="ok"
 ..e  d
 ...s ^TMPINCLBT($j,inc,incil,inclb)=clbqty
 ...s basqty=basqty-clbqty
 q 0
}

ClassMethod InsertAdjItm(pinc, ploc, adjrow, uomdr, price, xsub, dhcadjrow)
{
 s pincil="",x=xsub
 s pincil=$o(^INCI("IL_LOC",ploc,pinc,pincil)) 
 s pinclb="0"
 f  s pinclb=$o(^TMPINCLBT($j,pinc,pincil,pinclb)) q:(pinclb="0")!(pinclb="")  d
 .s pqty=0,inclb=pinc_"||"_pincil_"||"_pinclb
 .s x=x+1
 .s pqty=$g(^TMPINCLBT($j,pinc,pincil,pinclb))
 .s PLIST(0)=adjrow
 .s PLIST(2)=x
 .s PLIST(5)=-pqty
 .s PLIST(3)=pinc_"||"_pincil_"||"_pinclb
 .s PLIST(4)=uomdr
 .s PLIST(6)=price
 .s err=""
 .Set Config=##Class(websys.Configuration).%OpenId(1)
 .Set MEDDATA=Config.DataNamespace            ;得到当前的MEDTRAK的NameSpace,保存到MEDDATA中
 .Set LABDATA=Config.LabDataNamespace         ;得到当前的LABTRAK的NameSpace,保存到LABDATA中
 .Set CurrentNS=$ZNSPACE                      ;保存当前所用的NameSpace  
 .ZN MEDDATA                                  ;切换到所希望的NameSpace,
 .s err=$$INSERT^MVBSTADI(adjrow,"A")
 .s err=$$CONVQTY^ST01(pinc,uomdr,-pqty)
 .zn CurrentNS
 .s adjitm=""
 .s adjitm=adjrow_"||"_x
 .&sql(insert into sqluser.dhc_inadjitm(INADI_INAD_ParRef,INADI_ChildSub,INADI_CTLOC_DR,INADI_INCLB_DR,
     INADI_Qty,INADI_UCost,INADI_CTUOM_DR,INADI_AdjItm_DR)
  values(:dhcadjrow,:x,:ploc,:inclb,-:pqty,:price,:uomdr,:adjitm))
 q x
}

/// Description:处理非正常退药
/// Input:数据格式,操作员ID
/// Output: >0 成功  , 非>0 失败
/// Creator:Liang Qiang
/// CreatDate:2011-03-16
ClassMethod InsertUnReturn(tmpStirng)
{
	
	     s ret=0
		 s currdate=$p($h,",",1)
		 s currtime=$p($h,",",2)
		 s dispenStr=$p(tmpStirng,"!!",1)
		 s dispitmStr=$p(tmpStirng,"!!",2)
		 s patname=$p(dispenStr,"^",1)
		 s patsex=$p(dispenStr,"^",2)
		 //s patage=$p(dispenStr,"^",3)
		 s pattype=$p(dispenStr,"^",4)
		 s patpmi=$p(dispenStr,"^",5)
		 s pmi=$o(^PAPERi("PAPMI_PatNo",patpmi,""))
		 s patage=##class(web.DHCSTKUTIL).GetAgeNum(pmi) //年龄统一调用接口(比较用的年龄)wyx 2015-01-29
		 s patnote=$p(dispenStr,"^",6)
		 s ctloc=$p(dispenStr,"^",7)
		 s userid=$p(dispenStr,"^",8)
		 s poscode=$p(dispenStr,"^",9)
		 s reasid=$p(dispenStr,"^",10)
		 
		 s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(ctloc)
         s HospID=$p(CustStr,"^",5)
         s CustID=$p(CustStr,"^",1)
		 
		 
		 TSTART
		 Set $ZT="troll"
		 l +^OUTUNDISP("OUTUNDISP",patpmi):5 e  q -1
		 &sql(insert into sqluser.dhc_phinperson(phinp_age,phinp_name,phinp_sex_dr,phinp_demo,phinp_patno,PHINP_SOCSTATUS_DR)
		     values(:patage,:patname,:patsex,:patnote,:patpmi,:pattype))
		 i SQLCODE'=0 d exit
		 i SQLCODE q -2
		 s perrow=+$g(%ROWID)
		 //
		 s phl="",php=""
		 s phl=$o(^DHCPHLOCi("LOC",ctloc,"")) 
		 s inphp=""
		 f  s inphp=$o(^DHCPHPERi("USR",userid,inphp)) q:(inphp="")!(php'="")  d
		   .s inphl=""
		   .s inphl=+$p(^DHCPHPER(inphp),"^",3)
		   .i inphl=phl s php=inphp
		   .
		 &sql(insert into sqluser.dhc_phunreturn(phunr_date,phunr_time,phunr_php_dr,
         phunr_phinp_dr,phunr_phl_dr,phunr_finflag,phunr_cuflag1,phunr_phundr_dr) values(:currdate,:currtime,:php,:perrow,:phl,'1',:poscode,:reasid))
		 i SQLCODE'=0 d exit
		 i SQLCODE'=0 q -3
		 s unretrow=+$g(%ROWID)
		 //
		 s ret=0
		 s itmnum=$l(dispitmStr,"%") 
		 f i=1:1:itmnum q:ret<0  d
		 .s dispitm=$p(dispitmStr,"%",i)
		 .s inci=$p(dispitm,"^",1)
		 .s uom=$p(dispitm,"^",2)
		 .s incicode=$p(^INCI(inci,1),"^",1)
		 .s incibuom=$p(^INCI(inci,1),"^",10)
		 .s fac=##class(web.DHCSTCOMMONSRV).UOMFac(uom,incibuom)
		 .i fac=0 s fac=1
		 .s qty=$p(dispitm,"^",3)
		 .s qty=qty*fac
		 .s price=$p(dispitm,"^",4)
		 .s money=$p(dispitm,"^",5)
		 .s sub=i
		 .&sql(insert into sqluser.dhc_phunretitm(phunri_phunr_parref,phunri_childsub,phunri_inci_dr,phunri_qty,
         phunri_total,phunri_price,phunri_ctuom_dr) values(:unretrow,:sub,:inci,:qty,:money,:price,:uom))
		 .i SQLCODE'=0  s ret=SQLCODE
		 .q:ret<0
		 .s phunitm=unretrow_"||"_sub
		 .s:$G(pid)="" pid=##CLASS(web.DHCSTKUTIL).GetInclbCounter()
		 .s price=price/fac  //基本单位
		 .s CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(inci)
	     .s StkTypeDesc=$P(CatGrpStr,"^",4)
	     .//s Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"
	     .s Perv="^^^"_StkTypeDesc_"^"_HospID_"^DHC"	//zhouyg 20141208 BS药库参数变化
	     .s price=##Class(web.DHCSTCOMMPARA).GetNumbDec(price,Perv,"FmtSA",1)
		 .s ret=..InsertPhUnRetItmClb(inci,qty,price,ctloc,phunitm,pid,userid)
         .s:ret<0 ret=-5
         .
         i ret<0 d exit
		 q:ret<0 ret
		 s ret=unretrow
		 TCOMMIT
		 
		 Q ret
exit
  TRO
  l -^OUTUNDISP("OUTUNDISP",patpmi)
  q
troll
  Set $ZT=""
  TRo
  l -^OUTUNDISP("OUTUNDISP",patpmi)
  s ErrorMsg=$ZE
  q ErrorMsg
}

ClassMethod InsertUnReturnOld(ctloc, userid, perrow, poscode, reas)
{
 s currdate="",currtime="",ssusr="",undrow="",ret=""
 s currdate=$p($h,",",1)
 s currtime=$p($h,",",2)
 s phl="",php="",dhcadjrow=""
 s phl=$o(^DHCPHLOCi("LOC",ctloc,"")) 
 k ^TMPINCLBT($j)
 s inphp=""
 f  s inphp=$o(^DHCPHPERi("USR",userid,inphp)) q:(inphp="")!(php'="")  d
   .s inphl=""
   .s inphl=+$p(^DHCPHPER(inphp),"^",3)
   .i inphl=phl s php=inphp
 &sql(insert into sqluser.dhc_phunreturn(phunr_date,phunr_time,phunr_php_dr,
 phunr_phinp_dr,phunr_phl_dr,phunr_finflag,phunr_cuflag1,phunr_phundr_dr) values(:currdate,:currtime,:php,:perrow,:phl,'1',:poscode,:reas))
 i SQLCODE q -1
 s unretrow=+%ROWID
 k PLIST
 s PLIST(3)=currdate
 s ssusr=userid
 s PLIST(5)=ssusr
 s PLIST(6)=""
 s PLIST(9)="4"
 s error=0,adjno=""
 Set Config=##Class(websys.Configuration).%OpenId(1)
 Set MEDDATA=Config.DataNamespace            ;得到当前的MEDTRAK的NameSpace,保存到MEDDATA中
 Set LABDATA=Config.LabDataNamespace         ;得到当前的LABTRAK的NameSpace,保存到LABDATA中
 Set CurrentNS=$ZNSPACE                      ;保存当前所用的NameSpace  
 ZN MEDDATA                                  ;切换到所希望的NameSpace,
 s err=$$INSERT^MVBSTAD("A")
 i error'=0 q -1 
 s adjrow=""
 s adjrow=+$g(%ROWID)
 s adjno=$$GetMaxAdjNo^DHCSTCOMMONSRV("AD")
 s $p(^DHCPHUNR(unretrow),"^",13)=adjrow
 ZN CurrentNS 
 &sql(insert into sqluser.dhc_inadj(inad_adj_dr,inad_date,inad_time,inad_ReasonAdj_DR,inad_State,
      inad_ssusr_dr,inad_no,INAD_ChkDate,inad_chktime,inad_chkusr_dr)
     values(:adjrow,:currdate,:currtime,"",'20',:userid,:adjno,:currdate,:currtime,:userid))
 s dhcadjrow=+$g(%ROWID)
 s ret=unretrow_"^"_adjrow_"^"_dhcadjrow
 q ret
}

ClassMethod InsUnRItm(ctloc, allrow, inci, uom, qty, price, money, sub)
{
 s basuom=""
 s unretrow=$p(allrow,"^",1)
 s adjrow=$p(allrow,"^",2)
 s dhcadjrow=$p(allrow,"^",3)
 s basuom=+$p(^INCI(inci,1),"^",10)
 s confac=1
 s conrow=""
 i basuom=uom s confac=1
 e  d
   .s conrow=$o(^CT("CTCF",0,"UOM",uom,basuom,conrow))
   .i conrow'="" s confac=+$p(^CT("CTCF",conrow),"^",3)
 s adjqty=0,adjprice=0
 s adjqty=qty*confac
 s adjprice=price/confac
 &sql(insert into sqluser.dhc_phunretitm(phunri_phunr_parref,phunri_childsub,phunri_inci_dr,phunri_qty,
 phunri_total,phunri_price,phunri_ctuom_dr) values(:unretrow,:sub,:inci,:qty,:money,:price,:uom))
 i SQLCODE q -1
 d ##CLASS(web.DHCOutPhAdd).InsAdjItmR(inci,ctloc,adjrow,basuom,adjprice,sub,adjqty,dhcadjrow)
 q 0
}

ClassMethod InsAdjItmR(rinci, rctloc, radj, runit, rprice, rsub, rqty, dhcadjrow)
{
 s incil=""
 s incil=$o(^INCI("IL_LOC",rctloc,rinci,incil))
 s inclb="0",maxinclb="0",maxinclbrow=""
 f  s inclb=$o(^INCI(rinci,"IL",incil,"LB",inclb)) q:(inclb="0")!(inclb="")  d
 .i maxinclb<inclb s maxinclb=inclb,maxinclbrow=rinci_"||"_incil_"||"_maxinclb
 s PLIST(0)=radj
 s PLIST(2)=rsub
 s PLIST(5)=rqty
 s PLIST(3)=rinci_"||"_incil_"||"_maxinclb
 s PLIST(4)=runit
 s PLIST(6)=rprice
 s err=""
 Set Config=##Class(websys.Configuration).%OpenId(1)
 Set MEDDATA=Config.DataNamespace            ;得到当前的MEDTRAK的NameSpace,保存到MEDDATA中
 Set LABDATA=Config.LabDataNamespace         ;得到当前的LABTRAK的NameSpace,保存到LABDATA中
 Set CurrentNS=$ZNSPACE                      ;保存当前所用的NameSpace  
 ZN MEDDATA                                  ;切换到所希望的NameSpace,
 s err=$$INSERT^MVBSTADI(radj,"A")
 s err=$$CONVQTY^ST01(rinci,runit,rqty)
 ZN CurrentNS 
 s adjitm=""
 s adjitm=radj_"||"_rsub
 &sql(insert into sqluser.dhc_inadjitm(INADI_INAD_ParRef,INADI_ChildSub,INADI_CTLOC_DR,INADI_INCLB_DR,
     INADI_Qty,INADI_UCost,INADI_CTUOM_DR,INADI_AdjItm_DR)
  values(:dhcadjrow,:rsub,:rctloc,:maxinclbrow,:rqty,:rprice,:runit,:adjitm))

 q
}

ClassMethod BalDHCINTableDis(adj, ctloc, undisp)
{
 s undi=""
 f  s undi=$o(^DHCPHUND(undisp,"I",undi)) q:undi=""  d
   .s inc="",unqty=0,unctuom="",getinclb="",basuom="",basprice=0,purprice=0
   .s inc=+$p(^DHCPHUND(undisp,"I",undi),"^",2)
   .s unqty=+$p(^DHCPHUND(undisp,"I",undi),"^",4) 
   .s unctuom=+$p(^DHCPHUND(undisp,"I",undi),"^",1)
   .s purprice=+$p(^DHCPHUND(undisp,"I",undi),"^",3)
   .s basuom=+$p(^INCI(inc,1),"^",10)
   .s confac=1,conrow=""
   .i unctuom=basuom  s confac=1
   .e  d
     ..s conrow=$o(^CT("CTCF",0,"UOM",unctuom,basuom,conrow))
     ..s confac=+$p(^CT("CTCF",conrow),"^",3)
   .s basprice=purprice/confac
   .s basqty=0
   .s basqty=unqty*confac
   .s getinclb=##CLASS(web.DHCOutPhAdd).GetClbFromInc(inc,ctloc,basqty)
   .s pp=0,inadj=""
   .s inadj=$p(^DHCPHUND(undisp),"^",13)
   .s inadjitm="0"
   .f  s inadjitm=$o(^INAD(inadj,"ADI",inadjitm)) q:(pp=1)!(inadjitm="")!(inadjitm="0")  d
     ..s inadjclb="",inadjinc=""
     ..s inadjclb=$p(^INAD(inadj,"ADI",inadjitm),"^",1)
     ..s inadjinc=$p(inadjclb,"||",1)
     ..q:inadjinc'=inc
     ..s pp=pp+1
   .i pp=0  d
     ..s medadjitm="",adjsub=0,sub=""
     ..f  s medadjitm=$o(^INAD(inadj,"ADI",medadjitm)) q:(medadjitm="")!(medadjitm="0")  d
       ...s adjsub=medadjitm
     ..s sub=adjsub+1
     ..&sql(insert into sqluser.in_adjitm(INADI_INAD_ParRef,INADI_ChildSub,INADI_CTLOC_DR,
        INADI_CTUOM_DR,INADI_INCLB_DR,INADI_qty,INADI_UCost)
       values(:inadj,:sub,:ctloc,:basuom,:getinclb,-:basqty,:basprice))
     ..s dhcadjitm="",dhcadjsub=0
     ..s inadjitmrow=inadj_"||"_sub
     ..f  s dhcadjitm=$o(^DHCINAD(adj,"ADI",dhcadjitm)) q:(dhcadjitm="")!(dhcadjitm="0")  d
       ...s dhcadjsub=dhcadjitm
     ..&sql(insert into sqluser.dhc_inadjitm(INADI_INAD_ParRef,INADI_ChildSub,INADI_CTLOC_DR,INADI_INCLB_DR,
     INADI_Qty,INADI_UCost,INADI_CTUOM_DR,INADI_AdjItm_DR)
     values(:adj,:dhcadjsub+1,:ctloc,:getinclb,-:basqty,:basprice,:basuom,:inadjitmrow))
 s adjitm="0",inst="",usr=""
 s usr=+$p(^DHCINAD(adj),"^",3)
 f  s adjitm=$o(^DHCINAD(adj,"ADI",adjitm)) q:(adjitm="")!(adjitm="0")  d
 .s inclb="",qty=0,inci="",err="",manrow="",uom="",money=0,price=0
 .s inclb=$p(^DHCINAD(adj,"ADI",adjitm),"^",1)
 .s qty=+$p(^DHCINAD(adj,"ADI",adjitm),"^",2)
 .s uom=+$p(^DHCINAD(adj,"ADI",adjitm),"^",5)
 .s price=+$p(^DHCINAD(adj,"ADI",adjitm),"^",4)
 .s money=qty*price
 .s inci=$p(inclb,"||",1)
 .;(type, qty, inci, inclb, money, pointer, usr, ctuom, transno, price)
 .s manrow=##CLASS(web.DHCOutPhModCZ).DoDhcTotalMain(inci,ctloc,qty)
 .s err=##CLASS(web.DHCOutPhModCZ).InsertDhcIntrans("S",qty,inci,inclb,money,adj_"||"_adjitm,usr,uom,"",price)
 .s err=##CLASS(web.DHCOutPhModCZ).DoDhcTotalTail(inclb,ctloc,qty,manrow)
 q 0
}

ClassMethod GetClbFromInc(inci, loc, getclbqty)
{
	s incil=""
	s incil=$o(^INCI("IL_LOC",loc,inci,""))
	i incil="" q ""
	s getclb="0",myclb=""
	f  s getclb=$o(^INCI(inci,"IL",incil,"LB",getclb)) q:(getclb="")!(getclb="0")!(myclb'="")  d
	 .s getqty=0
	 .s getqty=+$p(^INCI(inci,"IL",incil,"LB",getclb),"^",2)
	 .i getqty>getclbqty  d
	   ..s myclb=inci_"||"_incil_"||"_getclb
	q myclb
}

ClassMethod BalDHCINTableRet(adj, ctloc, unret)
{
  s undi=""
 f  s undi=$o(^DHCPHUNRI(unret,"I",undi)) q:undi=""  d
   .s inc="",unqty=0,unctuom="",getinclb="",basuom="",basprice=0,purprice=0
   .s inc=+$p(^DHCPHUNRI(unret,"I",undi),"^",2)
   .s unqty=+$p(^DHCPHUNRI(unret,"I",undi),"^",4) 
   .s unctuom=+$p(^DHCPHUNRI(unret,"I",undi),"^",1)
   .s purprice=+$p(^DHCPHUNRI(unret,"I",undi),"^",3)
   .s basuom=+$p(^INCI(inc,1),"^",10)
   .s confac=1,conrow=""
   .i unctuom=basuom  s confac=1
   .e  d
     ..s conrow=$o(^CT("CTCF",0,"UOM",unctuom,basuom,conrow))
     ..s confac=+$p(^CT("CTCF",conrow),"^",3)
   .s basprice=purprice/confac
   .s basqty=0
   .s basqty=unqty*confac
   .s getinclb=##CLASS(web.DHCOutPhAdd).GetClbFromInc(inc,ctloc,basqty)
   .s pp=0,inadj=""
   .s inadj=$p(^DHCPHUNR(unret),"^",13)
   .s inadjitm="0"
   .f  s inadjitm=$o(^INAD(inadj,"ADI",inadjitm)) q:(pp=1)!(inadjitm="")!(inadjitm="0")  d
     ..s inadjclb="",inadjinc=""
     ..s inadjclb=$p(^INAD(inadj,"ADI",inadjitm),"^",1)
     ..s inadjinc=$p(inadjclb,"||",1)
     ..q:inadjinc'=inc
     ..s pp=pp+1
   .i pp=0  d
     ..s medadjitm="",adjsub=0,sub=""
     ..f  s medadjitm=$o(^INAD(inadj,"ADI",medadjitm)) q:(medadjitm="")!(medadjitm="0")  d
       ...s adjsub=medadjitm
     ..s sub=adjsub+1
     ..&sql(insert into sqluser.in_adjitm(INADI_INAD_ParRef,INADI_ChildSub,INADI_CTLOC_DR,
        INADI_CTUOM_DR,INADI_INCLB_DR,INADI_qty,INADI_UCost)
       values(:inadj,:sub,:ctloc,:basuom,:getinclb,:basqty,:basprice))
     ..s dhcadjitm="",dhcadjsub=0
     ..s inadjitmrow=inadj_"||"_sub
     ..f  s dhcadjitm=$o(^DHCINAD(adj,"ADI",dhcadjitm)) q:(dhcadjitm="")!(dhcadjitm="0")  d
       ...s dhcadjsub=dhcadjitm
     ..&sql(insert into sqluser.dhc_inadjitm(INADI_INAD_ParRef,INADI_ChildSub,INADI_CTLOC_DR,INADI_INCLB_DR,
     INADI_Qty,INADI_UCost,INADI_CTUOM_DR,INADI_AdjItm_DR)
     values(:adj,:dhcadjsub+1,:ctloc,:getinclb,:basqty,:basprice,:basuom,:inadjitmrow))
 s adjitm="0",inst="",usr=""
 s usr=+$p(^DHCINAD(adj),"^",3)
 f  s adjitm=$o(^DHCINAD(adj,"ADI",adjitm)) q:(adjitm="")!(adjitm="0")  d
 .s inclb="",qty=0,inci="",err="",manrow="",uom="",money=0,price=0
 .s inclb=$p(^DHCINAD(adj,"ADI",adjitm),"^",1)
 .s qty=+$p(^DHCINAD(adj,"ADI",adjitm),"^",2)
 .s uom=+$p(^DHCINAD(adj,"ADI",adjitm),"^",5)
 .s price=+$p(^DHCINAD(adj,"ADI",adjitm),"^",4)
 .s money=qty*price
 .s inci=$p(inclb,"||",1)
 .s manrow=##CLASS(web.DHCOutPhModCZ).DoDhcTotalMain(inci,ctloc,qty)
 .s err=##CLASS(web.DHCOutPhModCZ).InsertDhcIntrans("Z",qty,inci,inclb,money,adj_"||"_adjitm,usr,uom,"",price)
 .s err=##CLASS(web.DHCOutPhModCZ).DoDhcTotalTail(inclb,ctloc,qty,manrow)
 q 0
}

ClassMethod GetPatInf(pmino)
{
 s ret=""
 i pmino="" q ret
 s pmi=""
 s pmi=$o(^PAPERi("PAPMI_PatNo",pmino,pmi))
 i pmi="" q ret
 s patname="",sexdr="",sex="",pertype="",typedr="",age=""
 s sysdate=+$h,difdate=""
 s birthday="" 
 s patname=$p(^PAPER(pmi,"ALL"),"^",1)
 s sexdr=+$p(^PAPER(pmi,"ALL"),"^",7)
 s birthday=+$p(^PAPER(pmi,"ALL"),"^",6)
 s difdate=sysdate-birthday+1
 //s age=difdate/365
 s age=##class(web.DHCSTKUTIL).GetAge(pmi) //年龄统一调用接口wyx 2015-01-29
 i age["." s age=$p(age,".",1)
 s sex=$p(^CT("SEX",sexdr),"^",2)
 s typedr=+$p(^PAPER(pmi,"PER",1),"^",10)
 i typedr="" s pertype="自费"
 e  s pertype=$p(^CT("SS",typedr),"^",2)
 s ret=patname_"^"_sex_"^"_sexdr_"^"_age_"^"_pertype_"^"_typedr
 q ret
}

ClassMethod CheckCard(stdate, enddate, pmino, groupid, ctloc)
{
 s pmidr="",ret=""
 s pmidr=$o(^PAPERi("PAPMI_PatNo",pmino,""))
 s adm="",retadm=""
 s stdate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(stdate)
 s enddate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(enddate)
 i pmidr="" q 0
 f  s adm=$o(^PAPERdr(pmidr,"ADM","O",adm)) q:adm=""  d
   .s admdate=""
   .s admdate=$p(^PAADM(adm),"^",6)
   .s status=""
   .s status=$p(^PAADM(adm),"^",20)
   .q:status["C"
   .q:admdate<stdate
   .q:admdate>enddate
   .i retadm'="" s retadm=retadm_"^"_adm 
   .e  s retadm=adm
  i retadm="" d
	.s retadm=##class(web.DHCDocEmergencyPatientList).GetEmergencyEpisode(pmidr, "" ,"")
 s ret=##class(web.udhcOPBillIF).ReadUFAdmOrder(retadm,"","",ctloc,"")
 i ret="" s ret=0
 q ret
}

ClassMethod QueryPhNameClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryPhNameExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryPhNameExecute(ByRef QHandle As %Binary, ctloc As %Library.String = "", input As %Library.String = "") As %Status
{
  Set repid=$I(^CacheTemp)
	s ind=1
	s stkgrptype="",stkgrpcode=""
	k ^DHCTMPINC($j)
	i input="" S QHandle=$lb(0,repid,0)	Quit $$$OK 
	s input=$g(input)
	s input=$ZCVT(input,"U")
	s input="^"_input
	s num=0
	k ^DHCPHTMP($j,"Itmrowid"),^DHCPHTMP($j,"Itmcode"),^DHCPHTMP($j,"Itmdesc"),^DHCPHTMP($j,"ItmUO")
    s inca="0"
    f  s inca=$o(^INCALIAS(inca)) q:(inca="")!(inca="0")  d
     .s incatext=""
     .s incatext=$p(^INCALIAS(inca),"^",4)
     .s incatext=$ZCVT(incatext,"U")
     .s incatext="^"_incatext
     .q:incatext'[input
     .s inci=""
     .s inci=+$p(^INCALIAS(inca),"^",1)
     .q:'$d(^INCI(inci,1))
     .q:$d(^DHCTMPINC($j,inci))
     .s ^DHCTMPINC($j,inci)=inci 
     .s incil="",pp=0
      .;f  s incil=$o(^INCI("IL_LOC",ctloc,inci,incil)) q:incil=""  d
	  .;.s pp=pp+1
	  .;q:pp=0
	  .s num=num+1
	  .s ^DHCPHTMP($j,"Itmrowid",num)=inci
	  .q:'$d(^INCI(inci,1))
	  .s ^DHCPHTMP($j,"Itmcode",num)=$p($g(^INCI(inci,1)),"^",1)
	  .s ^DHCPHTMP($j,"Itmdesc",num)=$p($g(^INCI(inci,1)),"^",2)
	  .s uomdr=$p(^INCI(inci,1),"^",10)
      .q:'$d(^CT("UOM",+uomdr)) 
	  .s ^DHCPHTMP($j,"ItmUO",num)="" i uomdr'="" s ^DHCPHTMP($j,"ItmUO",num)=$p($g(^CT("UOM",+uomdr)),"^",2)
   s HospID=$p($g(^CTLOC(ctloc)),"^",22)
   s ii=1
   s sysdate=""
   s sysdate=+$h+1
   for ii=1:1:num 
     { s itmrowid="",itmcode="",itmdesc="",phuomdesc="",phuom="",price=0,retprice=""
      s itmrowid=^DHCPHTMP($j,"Itmrowid",ii)
      s itmcode=^DHCPHTMP($j,"Itmcode",ii)
      s itmdesc=^DHCPHTMP($j,"Itmdesc",ii)
      s arcitm="",locdate=""
      ;s locdate=$o(^DHCLOCTOT(0,"LOCITMDATE",ctloc,itmrowid,sysdate),-1)
      ;q:locdate=""
      ; s locdaily=$o(^DHCLOCTOT(0,"LOCITMDATE",ctloc,itmrowid,locdate,""))
      ; s locqtybas=0
      ; q:locdaily=""
      ;s locqtybas=+$p(^DHCLOCTOT(locdaily),"^",4)
      ;i locqtybas=0 q
      s arcitm=$p(^INCI(itmrowid,1),"^",3)
      Q:arcitm=""
      s phuom=+$p(^ARCIM($p(arcitm,"||",1),$p(arcitm,"||",2),8),"^",14)
      s phcdrg="",phcform="",phfact="",drgmast="",ybcode="",ybdesc="",factdesc=""
      s phcdrg=$p(^ARCIM($p(arcitm,"||",1),$p(arcitm,"||",2),1),"^",12)
      i phcdrg'=""  d
	    .s phcform=$p(^PHCD($p(phcdrg,"||",1),"DF",$p(phcdrg,"||",2),1),"^",1)
	    .s phfact=$p(^PHCD($p(phcdrg,"||",1),2),"^",4)
	  e  d
	    .s phcform="",phfact=""
	  i phcdrg'=""  s drgmast=$p(phcdrg,"||",1)
	  e  s drgmast=""
	  i drgmast'="" s ybcode=$p(^PHCD(drgmast,4),"^",2)
	  e  s ybcode=""
	  ;i ybcode="1" s ybdesc="无自付"
	  ;i ybcode="2" s ybdesc="有自付"
	  ;i ybcode="3" s ybdesc="全自付"
	  s ybdesc=ybcode
	  i phfact=""  s factdesc="" 
      e  d
        .i '$d(^PHMNF(phfact))  s factdesc="" 
        .e  s factdesc=$p(^PHMNF(phfact),"^",2)
    
      s phuomdesc=$p($g(^CT("UOM",phuom)),"^",2)
      s basuom=""
      s basuom=+$p(^INCI(itmrowid,1),"^",10)
	  s confac=1,conrow=""
	  i basuom=phuom s confac=1
	  e  d
	    .s conrow=$o(^CT("CTCF",0,"UOM",phuom,basuom,conrow))
	    .i conrow'="" s confac=+$p(^CT("CTCF",conrow),"^",3)
      s qty=0
      ;s qty=locqtybas/confac
      //s retprice=##class(web.DHCOPItemMast).GetOrderPrice("","",arcitm,+$h,"","","","")
      //s price=$p(retprice,"^",1)
      //s price=$fn(price,"",2)
      s retprice=##class(web.DHCSTPRICE).GetCurSp(itmrowid,phuom,HospID)
      s price=retprice
      ;itmdesc,ybdesc,phuomdesc,factdesc,price,qty
	  set Data=$lb(itmdesc,ybdesc,phuomdesc,factdesc,price,qty)
	  Set ^CacheTemp(repid,ind)=Data
	  Set ind=ind+1
	   }
 	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryPhNameFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPhNameExecute ]
{

 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

Query QueryPhName(ctloc As %String, input As %String) As %Query(ROWSPEC = "名称:%String,IncID:%String,单位:%String,UomID:%String,单价:%String,库存:%String")
{
}

ClassMethod GetPminoLen()
{
 s PatLen=$p(^CF("PATCF",1,3),"^",5)
 q PatLen
}

ClassMethod GetPrintRow(rPHL As %Library.String = "", rPRT As %Library.String = "", rPrescNo As %Library.String = "")
{
	  s phl=$g(rPHL)
	  s prt=+$g(rPRT),hh=0,allmoney=0
	  s yprescno=$g(rPrescNo)
	  s unflag=""
	  s sysdate=+$h
	  //i (phl="")!(prt="") Set QHandle=$lb(0,repid,0)	Quit $$$OK
	  
	  s pid=$I(^DHCOUTPHDISPPRT("PRESCNO"))
	  
	  s locdr=$p(^DHCPHLOC(phl),"^",1)
	  s leadlocdr=##class(web.DHCOutPhDisp).GetLeadLoc(locdr)
	  s mainphl=$o(^DHCPHLOCi("LOC",leadlocdr,""))  //主科室  lq
	  s phl=mainphl
	  
	  s reclocdr=""
	  s reclocdr=+$p(^DHCPHLOC(phl),"^",1)
	  s cy=""
	  s cy=$p(^DHCPHLOC(phl),"^",6)
	  s HospID=$p($g(^CTLOC(reclocdr)),"^",22)
	  /*
	  s bci="0"
	  f  s bci=$o(^DHCBCI(0,"INV",prt,bci)) q:(bci="")!(bci="0")  d
	    .s patbill=""
	    .s patbill=+$p(^DHCBCI(bci),"^",2)
	    .s patbillsub="0"
	    .f  s patbillsub=$o(^DHCPB(patbill,"O",patbillsub)) q:(patbillsub="")!(patbillsub="")  d
	      ..s orditm="",ord="",itm="",dispflag="",prescno=""
	      ..s orditm=$p(^DHCPB(patbill,"O",patbillsub),"^",4)
	      ..s ord=$p(orditm,"||",1),itm=$p(orditm,"||",2)
	      ..s recplocdr=""
	      ..s recplocdr=+$p(^OEORD(ord,"I",itm,3),"^",6)
	      ..q:recplocdr=""
	      ..q:recplocdr'=reclocdr
	      ..s dispflag="" 
	      ..s dispflag=$p($g(^OEORD(ord,"I",itm,6)),"^",7)
	      ..s prescno=$p($g(^OEORD(ord,"I",itm,1)),"^",14)
	      ..q:prescno=""
	      ..q:(prescno'=yprescno)&(yprescno'="") //lq
	      ..s qty=0,money=0
	      ..s qty=+$p(^DHCPB(patbill,"O",patbillsub),"^",5)
	      ..s money=+$p(^DHCPB(patbill,"O",patbillsub),"^",8)
	      ..i $d(^DHCPHTMPPRESCNO(pid,prt,"PRESCNO",prescno,orditm))  d
	         ...s $p(^DHCPHTMPPRESCNO(pid,prt,"PRESCNO",prescno,orditm),"^",1)=$p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,orditm),"^",1)+qty
	         ...s $p(^DHCPHTMPPRESCNO(pid,prt,"PRESCNO",prescno,orditm),"^",2)=$p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,orditm),"^",2)+money
	      ..e  d
	         ...s $p(^DHCPHTMPPRESCNO(pid,prt,"PRESCNO",prescno,orditm),"^",1)=qty
	         ...s $p(^DHCPHTMPPRESCNO(pid,prt,"PRESCNO",prescno,orditm),"^",2)=money
	   
	    */       
	         
	         
	  	s ord=""
	    f  s ord=$o(^OEORD(0,"PrescNo",yprescno,ord)) q:ord=""  d 
	    .s itm=""
	    .f  s itm=$o(^OEORD(0,"PrescNo",yprescno,ord,itm) ) q:itm=""  d
	    ..s orditm=ord_"||"_itm
	    ..s recplocdr=+$p(^OEORD(ord,"I",itm,3),"^",6)
	    ..q:recplocdr=""
	    ..q:recplocdr'=reclocdr
	    ..s prescno=$p($g(^OEORD(ord,"I",itm,1)),"^",14)
	    ..q:prescno'=yprescno
	    ..s dspdate=##class(web.DHCOutPhDisp).getDspDate(ord_"||"_itm)
	    ..s qty=+##class(web.DHCOutPhDisp).getDspQty(ord_"||"_itm)
        ..s inci=##class(web.DHCOutPhCommon).GetInciByOrditm(ord_"||"_itm)
	    ..i +prt=0 d
	    ...//s ordprice=##class(web.DHCOutPhCommon).GetItmPrice(inci,+dspdate,reclocdr)
	    ...s phditmID=##Class(web.DHCOutPhCommon).GetPhdItmIDByPrt(yprescno,prt,phl,orditm)
	    ...i phditmID'="" d
	    ....s ordprice=##Class(web.DHCOutPhCommon).GetPhdItmSp(phditmID)
	    ...e  d
	    ....s exStr=orditm_"^"
	    ....s ordprice=##Class(web.DHCSTPRICE).GetSp(inci, +dspdate, "", HospID, "",exStr)
	    ...s money=$fn(ordprice*qty,"",2)
	    ..e  d
	    ...s ordpriceinfo=##class(web.DHCOutPhCommon).GetBasPriceByInv(prt,ord_"||"_itm)
	    ...s ordprice=$p(ordpriceinfo,"^",1)
	    ...s money=$p(ordpriceinfo,"^",2) 
	    ...s money=$fn(money,"",2)
	    ..i $d(^DHCPHTMPPRESCNO(pid,prt,"PRESCNO",yprescno,orditm))  d
	    ...s $p(^DHCPHTMPPRESCNO(pid,prt,"PRESCNO",yprescno,orditm),"^",1)=$p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,orditm),"^",1)+qty
	    ...s $p(^DHCPHTMPPRESCNO(pid,prt,"PRESCNO",yprescno,orditm),"^",2)=$p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,orditm),"^",2)+money
	    ..e  d
	    ...s $p(^DHCPHTMPPRESCNO(pid,prt,"PRESCNO",yprescno,orditm),"^",1)=qty
	    ...s $p(^DHCPHTMPPRESCNO(pid,prt,"PRESCNO",yprescno,orditm),"^",2)=money
	    ...
	    
	    s durfact="",ret=""
	    s yprescno=""
	     f  s yprescno=$o(^DHCPHTMPPRESCNO(pid,prt,"PRESCNO",yprescno)) q:yprescno=""  d
	     .s ordi=""
	     .f  s ordi=$o(^DHCPHTMPPRESCNO(pid,prt,"PRESCNO",yprescno,ordi)) q:ordi=""  d
	     ..s dispqty=0,dispmoney=0,price=0
	     ..s dispqty=$p(^DHCPHTMPPRESCNO(pid,prt,"PRESCNO",yprescno,ordi),"^",1)
	     ..s dispmoney=$p(^DHCPHTMPPRESCNO(pid,prt,"PRESCNO",yprescno,ordi),"^",2)
	     ..s price=dispmoney/dispqty
	     ..s ord="",itm=""
	     ..s ord=$p(ordi,"||",1)
	     ..s itm=$p(ordi,"||",2)
	 	 ..s itmmast=""
	     ..s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)      ;arc_itmmast
	     ..s priority=""
	     ..s priority=$p(^OEORD(ord,"I",itm,1),"^",8)     ;????
	     ..s yppc="",inclb="",incib=""
	     ..i $d(^OEORD(ord,"I",itm,"X",1,"D",1))  d
	       ...s inclb=$p(^OEORD(ord,"I",itm,"X",1,"D",1),"^",2)
	       ...s incib=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
	       ...s yppc=$p(^INCI($p(incib,"||",1),"IB",$p(incib,"||",2)),"^",1)
	     ..e  s yppc=""
	     ..s priordesc=""
	     ..i priority'="" s priordesc=$p(^OECPR(priority),"^",2)
	     ..q:priordesc["自备"
	     ..s orddoctco=""
	     ..s orddoctco=$p($g(^OEORD(ord,"I",itm,1)),"^",11) ;??
	     ..s doseqty="" s doseqty=$p($g(^OEORD(ord,"I",itm,2)),"^",1)
	     ..;i doseqty<1 s doseqty="0"_doseqty
	     ..s unitdr="" s unitdr=$p($g(^OEORD(ord,"I",itm,2)),"^",3)
	     ..s phfragdr="" s phfragdr=$p($g(^OEORD(ord,"I",itm,2)),"^",4)
	     ..s duratdr="" s duratdr=$p($g(^OEORD(ord,"I",itm,2)),"^",6)
	     ..s instrdr="" s instrdr=$p($g(^OEORD(ord,"I",itm,2)),"^",7)
	     ..s unitdesc=""
	     ..i unitdr'="" s unitdesc=$p($g(^CT("UOM",unitdr)),"^",2)
	     ..s phuomid="",phuomdesc="",itmmastid="",itmmastver=""
	     ..s itmmastid=$p(itmmast,"||",1)
	     ..s itmmastver=$p(itmmast,"||",2)
	     ..s genric=""
	     ..s genric=$p(^ARCIM(itmmastid,itmmastver,8),"^",20)
	     ..s incTYdesc=""
	     ..i genric'="" s incTYdesc=$p(^PHCGE("GE",genric),"^",2)
	     ..s drgform="",drgmast="",phtype="",jrflag=""
	     ..s drgform=$p(^ARCIM(itmmastid,itmmastver,1),"^",12)
	     ..i drgform'="" s drgmast=$p(drgform,"||",1)
	     ..i drgmast'=""  d
	     ...s phtype=$p($g(^PHCD(drgmast,1)),"^",4)
	     ..s phtypedesc=""
	     ..i phtype'="" d
	     ...s phtype=+phtype
	     ...s phtypedesc=""
	     ...s phtypedesc=$p(^PHCPO(phtype),"^",1)
	     ..i phtypedesc["02" s jrflag="2"
	     ..i phtypedesc["01" s jrflag="1"
	     ..s phuomid=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
	     ..q:phuomid=""
	     ..s phuomid=$p(phuomid,$c(1),1)
	     ..s currdate=""
	     ..s currdate=$p($h,",",1)
	     ..s phuomdesc=$p($g(^CT("UOM",phuomid)),"^",2)
	     ..i phuomdesc["(" s phuomdesc=$p(phuomdesc,"(",1)
	     ..s inci=""
	     ..s inci=$o(^INCI(0,"ARCIM_DR",itmmastid,inci))
	     ..q:inci=""
	     ..s inci=$p(inci,$c(1),1)
	     ..s basuom=""
         ..s basuom=+$p(^INCI(inci,1),"^",10)
	     ..s dxsl="",dxunit=""
	     ..s dxrowid="0"
	     ..s dxrowid=$o(^PHCD(drgmast,"DF",$p(drgform,"||",2),"EQ",dxrowid))
	     ..s dxts="",dxundesc=""
	     ..i dxrowid'=""  d
	        ...s dxsl=+$p(^PHCD(drgmast,"DF",$p(drgform,"||",2),"EQ",dxrowid),"^",2) 
	        ...s dxunit=+$p(^PHCD(drgmast,"DF",$p(drgform,"||",2),"EQ",dxrowid),"^",1) 
	        ...i dxunit'=0  d
	        ....s dxundesc=$p($g(^CT("UOM",dxunit)),"^",2)
	        ....s dxts=dxsl_dxundesc
	    ..s phbz="",bz=0,bb=0
	    ..s bz=$g(^OEORD(ord,"I",itm,"DEP",0))
	    ..f bb=1:1:bz  d
	      ...s phbz0=""
	      ...s phbz0=$g(^OEORD(ord,"I",itm,"DEP",bb))
	      ...s phbz=phbz_phbz0
	    ..s cybz=""
	    ..s cybz=$p($g(^OEORD(ord,"I",itm,2)),"^",8)
	    ..
	    ..s sdate="",qtyend=0
	    ..s sdate=$o(^DHCLOCTOT(0,"LOCITMDATE",reclocdr,inci,sysdate+1),-1)        
	    ..i sdate'="" d
	      ...s ldtrow=$o(^DHCLOCTOT(0,"LOCITMDATE",reclocdr,inci,sdate,""))
	      ...s qtyend=+$p(^DHCLOCTOT(ldtrow),"^",4)
        ..i qtyend<dispqty s unflag="1"
	    ..;^INCI("IL_LOC",{INCIL_CTLOC_DR},{INC_Itm.INCI_RowId},             x
	    ..s incil="",yphw="",incstb=""
	    ..s incil=$o(^INCI("IL_LOC",reclocdr,inci,""))
	    ..i incil'=""  d
	      ...s incstb=+$p(^INCI(inci,"IL",incil),"^",2)
	      ...i incstb'=0  d
	      ....q:'$d(^INC("SB",incstb))
	      ....s yphw=$p(^INC("SB",incstb),"^",2)
	    ..s puruom="",puruomdesc="",basuomdesc=""
	    ..s puruom=+$p(^INCI(inci,3),"^",6)
	    ..s puruomdesc=$p($g(^CT("UOM",puruom)),"^",2)
	    ..s basuomdesc=$p($g(^CT("UOM",basuom)),"^",2)
	    ..s phgg=""
	    ..;s phgg=$p($g(^INCI(inci,3)),"^",9)
	    ..s phgg=##class(web.DHCSTKUTIL).GetSpec(inci) 
	    ..s confac=1,conrow=""
	    ..i basuom=phuomid s confac=1
	    ..e  d
	      ...s conrow=$o(^CT("CTCF",0,"UOM",phuomid,basuom,conrow))
	      ...i conrow'="" s confac=+$p(^CT("CTCF",conrow),"^",3)
	      ...
	    ..s qty=0,newunit="",getnum=0,newunitdesc="",newprice=0
	    ..s getnum=$p((dispqty/confac),".",1)
	    ..s newprice=price*confac
	    ..;  add by xiaohe 20140609
	    ..s dispuomdr=$p($g(^OEORD(ord,"I",itm,"DHC")),"^",13)
	    ..i dispuomdr'="" d
        ...s Fac=##class(web.DHCSTCOMMONSRV).UOMFac(dispuomdr,basuom)
        ...s getnum=dispqty/Fac
        ...i getnum<1 s getnum=0_getnum
        ...s phuomdesc=$p($g(^CT("UOM",dispuomdr)),"^",2)
        ...s newprice=price/Fac
        ..;--------
	    ..s phqtyuom=""
	    ..s phqtyuom=getnum_phuomdesc
	    ..s phdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)
	    ..q:phdesc="" 
	    ..i cy="1"  d
	    ...s phdesc=$e(phdesc,1,10)
	    ..e  d
	    ...;s phdesc=$e(phdesc,1,25)
	    ..s duratdesc=""
	    ..i (duratdr'="")&(durfact="") s duratdesc=$p($g(^PHCDU(duratdr)),"^",3),durfact=$p($g(^PHCDU(duratdr)),"^",2)
	    ..s phfragdesc=""
	    ..i phfragdr'="" s phfragdesc=$p($g(^PHCFR(phfragdr)),"^",3)
	    ..s instrdesc=""
	    ..i instrdr'="" s instrdesc=$p($g(^PHCIN(instrdr)),"^",2)
	    ..s orduser="",ordusertypedr="",ordusercare="",careprovtype="",userdoctype=""
	    ..s orduser=+$p($g(^OEORD(ord,"I",itm,7)),"^",1)
	    ..s username=""
	    ..s username=$p(^SSU("SSUSR",orduser),"^",2)
	    ..i orduser'=""  s ordusercare=$p(^SSU("SSUSR",orduser),"^",14)
	    ..i ordusercare'="" s careprovtype=$p(^CTPCP(ordusercare,1),"^",4)
	    ..i careprovtype'="" s userdoctype=$p(^CT("CPT",careprovtype),"^",4)
	    ..s orddoctname="",orddoctcode=""
	    ..i orddoctco'=""  d
	      ...s orddoctname=$p($g(^CTPCP(orddoctco,1)),"^",2)
	      ...s orddoctcode=$p($g(^CTPCP(orddoctco,1)),"^",1)
	    ..s doctype=""
	    ..i orddoctco'=""  s doctype=$p(^CT("CPT",+$p(^CTPCP(orddoctco,1),"^",4)),"^",4)
	    ..s jlflag=""
	    ..;i unitdesc["?" s unitdesc=$p(unitdesc,"?",1) s unitdesc=unitdesc_"?"
	    ..s jlflag=doseqty_unitdesc
	    ..s yfyl=""
	    ..i instrdesc["遵医嘱" s instrdesc=phbz
	    ..s yfyl=phfragdesc_" "_instrdesc
	    ..s phfact="",factdesc=""
	    ..i drgform'=""  d
	       ...s phcform=$p(^PHCD($p(drgform,"||",1),"DF",$p(drgform,"||",2),1),"^",1)
	       ...s phfact=$p(^PHCD($p(drgform,"||",1),2),"^",4)
	     ..e  d
	       ...s phcform="",phfact=""
         ..i phfact=""  s factdesc="" 
         ..e  d
           ...i '$d(^PHMNF(phfact))  s factdesc="" 
           ...e  s factdesc=$p(^PHMNF(phfact),"^",2)  
        ..i factdesc["-" s factdesc=$p(factdesc,"-",2)  
	    ..s error="",t=0,cc=0,notes=""
	    ..s notes=$p(^OEORD(ord,"I",itm,2),"^",8)
	    ..s oeflag="",inclbid="",disstatu=""
	    ..s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",2)       ;????
        ..q:oeflag["停"
        ..i newunitdesc["(" s newunitdesc=$p(newunitdesc,"(",1)
	    ..i t=0 s error="1"
	    ..s allmoney=allmoney+dispmoney
	    ..s ypmc=""
	    ..s seqno=""
	    ..s seqno=$p(^OEORD(ord,"I",itm,3),"^",4)
	    ..i (basuom=5)||(basuom=6)  d   //dj090406
	       ...s dxundesc=basuomdesc
	       ...s doseqty=doseqty/dxsl
	       ...i doseqty["."  s doseqty=$fn(doseqty,"",2)
           ...s jlflag=doseqty_dxundesc
	    ..s firstqty=""
	    ..s firstqty=$p($g(^OEORD(ord,"I",itm,"DHC")),"^",15)
	    ..i firstqty'="" s firstqty="输液"_firstqty_"次"
	    ..s ypmc=phdesc
	    ..;_"("_incTYdesc_")"
	    ..s orderqty="" //一次用量草药
	    ..s prescrow=$o(^PAQUE1(0,"PrescNo",yprescno,""))
	    ..i prescrow'=""  d
	    ...i $d(^PAQUE1(prescrow,"DHC")) s orderqty=$p(^PAQUE1(prescrow,"DHC"),"^",13) //用量 
 	    ..s hh=hh+1
 	    ..s newprice=$fn(newprice,"",2)
 	    ..i (newprice<1)&(newprice'["0.")  d
 	    ...s newprice="0"_newprice
 	    ..i (dispmoney<1)&(dispmoney'["0.")  d
 	    ...s dispmoney="0"_dispmoney
 	    ..i userdoctype'["DOC"  d
	    ...s yfyl="",orddoctnam="",orddoctcode="",firstqty=""
	    ..s drugtypestr=##class(web.DHCINSUPort).ArcimLinkInsu(itmmast, "14")
	    ..s doctor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(ord_"||"_itm)
	    ..s drugtype=$p(drugtypestr,"^",1)
 	    ..i ret'="" s ret=ret_$c(1)_ypmc_"^"_phuomdesc_"^"_getnum_"^"_jlflag_"^"_instrdesc_"^"_phfragdesc_"^"_newprice_"^"_dispmoney_"^"_jrflag_"^"_orddoctname_"^"_seqno_"^"_firstqty_"^"_cybz_"^"_orderqty_"^"_drugtype
 	    ..e  s ret=ypmc_"^"_phuomdesc_"^"_getnum_"^"_jlflag_"^"_instrdesc_"^"_phfragdesc_"^"_newprice_"^"_dispmoney_"^"_jrflag_"^"_orddoctname_"^"_seqno_"^"_firstqty_"^"_cybz_"^"_orderqty_"^"_drugtype
        k ^DHCPHTMPPRESCNO(pid)
        q ret
}

ClassMethod ExportInc()
{
  s inc="0",m=0,ret=""
  k ^DHCTMPINCEXPORT
  f  s inc=$o(^INCI(inc)) q:(inc="")!(inc="0")!(inc="IB_NO")  d
    .s incdesc="",inccode="",incbasuom="",incbasuomdesc=""
    .s incpuruom="",incpuruomdesc="",incphuom="",inphuomdesc=""
    .s arcitm="",incprice=0,inctext=""
    .s incalrow="0"
    .;INCALIAS(0,"INCI",
    .f  s incalrow=$o(^INCALIAS(0,"INCI",inc,incalrow)) q:(incalrow="")!(incalrow="0")  d
    ..s incatext=""
    ..s incatext=$p(^INCALIAS(incalrow),"^",4)
    ..i inctext=""  d
    ... s inctext=incatext
    ..e  d
    ...s inctext=inctext_";"_incatext
    .s incdesc=$p(^INCI(inc,1),"^",2)
    .s inccode=$p(^INCI(inc,1),"^",1)
    .s incbasuom=+$p(^INCI(inc,1),"^",10)
    .s incpuruom=+$p(^INCI(inc,3),"^",6)
    .s arcitm=$p(^INCI(inc,1),"^",3)
    .s genric=""
	.s genric=$p(^ARCIM($p(arcitm,"||",1),$p(arcitm,"||",2),8),"^",20)
	.s incTYdesc=""
	.i genric'="" s incTYdesc=$p(^PHCGE("GE",genric),"^",2)
    .s incphuom=+$p(^ARCIM($p(arcitm,"||",1),$p(arcitm,"||",2),8),"^",14)
    .s tarrow=""
    .s tarrow=$o(^DHCTARI(0,"Code",inccode,"")) 
    .i tarrow="" d
    ..s incprice=0
    .e  d
    ..s taritm="0"
    ..f  s taritm=$o(^DHCTARI(tarrow,"P",taritm)) q:(taritm="")!(taritm="0")  d
    ...s incprice=+$p(^DHCTARI(tarrow,"P",taritm),"^",5)
    .s incbasuomdesc=$p(^CT("UOM",incbasuom),"^",2)
    .s incpuruomdesc=$p(^CT("UOM",incpuruom),"^",2)
    .s inphuomdesc=$p(^CT("UOM",incphuom),"^",2)
    .i (incprice<1)&(incprice'["0.")  d
    ..s incprice="0"_incprice
    .
    .s m=m+1
    .s ^DHCTMPINCEXPORT(m)=incdesc_"^"_incTYdesc_"^"_inccode_"^"_incbasuomdesc_"^"_incpuruomdesc_"^"_inphuomdesc_"^"_incprice_"^"_inctext
   q m
}

ClassMethod ExportIncRow(t)
{
	s ret=^DHCTMPINCEXPORT(t+1)
	q ret
}

ClassMethod CheckItmLocFrTotal(loc)
{
  s inc="0",t=0
  k ^DHCTMPCHECKLOCQTY
  f  s inc=$o(^INCI(inc)) q:(inc="")!(inc=0)  d
    .s cil=""
    .f  s cil=$o(^INCI("IL_LOC",loc,inc,cil)) q:cil=""  d
     ..s dhcqty=0,medqty=0
     ..s medqty=+$p(^INCI(inc,"IL",cil),"^",3)
     ..s sdate="",qtyend=0,ldtrow=""
	 ..s sdate=$o(^DHCLOCTOT(0,"LOCITMDATE",loc,inc,+$h+1),-1)        
	 ..i sdate'="" d
	      ...s ldtrow=$o(^DHCLOCTOT(0,"LOCITMDATE",loc,inc,sdate,""))
	      ...s qtyend=+$p(^DHCLOCTOT(ldtrow),"^",4)
  
     ..i medqty'=qtyend  d
       ...&sql(update sqluser.inc_itmloc set incil_logqty=:qtyend where incil_inci_parref=:inc and incil_childsub=:cil)
       ...s t=t+1
       ...s ^DHCTMPCHECKLOCQTY(t)=inc_"^"_medqty_"^"_qtyend
 q t
}

ClassMethod UpdateLocDailyTotal(ctloc, currdate)
{
  ;w ##class(web.DHCOutPhAdd).UpdateLocDailyTotal()
  ;currdate格式为YYYY-MM-DD
  s currdate=$zdh(currdate,3)
  s phlrow="",lp=0
  s phlrow=$o(^DHCPHLOCi("LOC",ctloc,""))
  s phdrow = "",suess=0,suecs=0
  ;TSTART
  f  s phdrow=$o(^DHCPHDISPi(currdate,phlrow,phdrow)) q:phdrow=""  d
    .s ppyflag="",pfyflag="",pydr="",fydr="",prt="",inv="",pydate="",ssuser="",perno="",pname=""
    .s ppyflag=$p(^DHCPHDISP(phdrow,1),"^",6)
    .s pfyflag=$p(^DHCPHDISP(phdrow),"^",4)
    .q:(pfyflag'="1")
    .s fydr=+$p(^DHCPHDISP(phdrow,1),"^",2)
    .;s pydr=+$p(^DHCPHDISP(phdrow,1),"^",3)
    .;s ssuser=+^DHCPHPER(fydr,"^",5)
    .;q:$p(^DHCPHDISP(phdrow,1),"^",19)="1"
    .;s $p(^DHCPHDISP(phdrow,1),"^",19)="1"
    .s phdsub="",lh=0
    .f  s phdsub=$o(^DHCPHDI(phdrow,"PHDI",phdsub)) q:phdsub=""  d
    ..s money=0,qty=0,oeori="",ord="",itm="",basprice=0
    ..s money=+$p(^DHCPHDI(phdrow,"PHDI",phdsub),"^",3)
    ..s qty=+$p(^DHCPHDI(phdrow,"PHDI",phdsub),"^",4)
    ..s basprice=money/qty
    ..s basprice=$fn(basprice,"",2)
    ..s oeori=$p(^DHCPHDI(phdrow,"PHDI",phdsub),"^",5)
    ..s ord=$p(oeori,"||",1),itm=$p(oeori,"||",2)
    ..s itmmast="",puruom="",basuom="",inci=""
	..s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)
	..;s inci=$o(^INCI(0,"ARCIM_DR",$p(itmmast,"||",1),inci))
	..;q:inci=""
	..s phdicsub="0"
    ..f  s phdicsub=$o(^DHCPHDI(phdrow,"PHDI",phdsub,"INCLB",phdicsub)) q:(phdicsub="")!(phdicsub="0")!(suess'=0)  d
      ...s inclb="",incqty=0,basuom="",pointer="",intrno=""
      ...s inclb=$p(^DHCPHDI(phdrow,"PHDI",phdsub,"INCLB",phdicsub),"^",3)
      ...s incqty=+$p(^DHCPHDI(phdrow,"PHDI",phdsub,"INCLB",phdicsub),"^",1)
      ...s inc=""
      ...q:inclb=""
      ...s inc=$p(inclb,"||",1)
      ...s basuom=$p(^INCI(inc,1),"^",10)
      ...s pointer=phdrow_"||"_phdsub_"||"_phdicsub
      ...s int=0
      ...&sql(select count(intr_rowid) into :int from sqluser.dhc_intrans where intr_date=:currdate and intr_pointer=:pointer)
      ...q:int'=0
      ...&sql(update sqluser.dhc_intrans set intr_date=:currdate where intr_pointer=:pointer) 
      ...s err=""
      ...s lp=lp+1
      ...;s suecs=suecs+1
      ...;s err=##CLASS(web.DHCOutPhModCZ).HandleStk(inclb,-incqty,basuom,ctloc,basprice,pointer,"",ssuser)
      ...;i err'=0 d
      ...;.s suess=suess+1
     ;i suess=0  d
     ;  .TCOMMIT
     ;e  d
     ;  .TRo
     ;i suess>0 q -1
 q lp
}

ClassMethod GetBasLoc(ctloc)
{
 s basloc="",retphl=""
 s tphl=""
 s tphl=$o(^DHCPHLOCi("LOC",ctloc,""))
 &sql(select phgl_ctloc_dr into :basloc from sqluser.dhc_phgloc where phgl_phl_dr=:tphl)
 i SQLCODE=100 q ctloc
 s basloc=$p(basloc,$c(1),1)

 q basloc
}

ClassMethod GetTwoPhlFrThree(tphl)
{
 s basloc="",retphl=""
 &sql(select phgl_ctloc_dr into :basloc from sqluser.dhc_phgloc where phgl_phl_dr=:tphl)
 i SQLCODE=100 	q tphl
 s basloc=+basloc
 i basloc'="" s retphl=$o(^DHCPHLOCi("LOC",basloc,""))
 e  s retphl=tphl

 q retphl
}

ClassMethod CheckGroupLoc(ctloc)
{
 s basloc="",retphl=""
 s tphl=""
 s tphl=$o(^DHCPHLOCi("LOC",ctloc,""))
 &sql(select phgl_ctloc_dr into :basloc from sqluser.dhc_phgloc where phgl_phl_dr=:tphl)
 i SQLCODE=100 q 0
 s basloc=$p(basloc,$c(1),1)
 q basloc
}

ClassMethod GetPmiNoFrCardNo(cardno)
{
	i cardno="" q -1
	s cardrow="0",retpatno=""
	f  s cardrow=$o(^DHCCARDi("CF",0,"CardNo",cardno,cardrow)) q:(cardrow="")!(cardrow="0")  d
	  .s cardstatus="",pmi=""
	  .s cardstatus=$p(^DHCCARD("CF",cardrow),"^",10)
	  .i cardstatus="" s cardstatus="N"
	  .q:cardstatus'["N"
	  .s pmi=+$p(^DHCCARD("CF",cardrow),"^",4)
	  .s retpatno=$p(^PAPER(pmi,"PAT",1),"^",2)
	  
	i retpatno="" q -1
	
	q retpatno
}

ClassMethod ColectPrescTotalClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = ColectPrescTotalExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod ColectPrescTotalFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ColectPrescTotalExecute ]
{

 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCOutPhAdd","ColectPrescTotal",102,"2014-06-01","2014-09-01",0) 
Query ColectPrescTotal(ctloc As %Library.String = "", CDateSt As %Library.String = "", CDateEnd As %Library.String = "", type As %Library.String = "") As %Query(ROWSPEC = "Tinsc:%String,Tcfcnt:%String,Tcffac:%String,Tcfws:%String,Tcfamt:%String") [ SqlProc ]
{
}

ClassMethod ColectPrescTotalExecute(ByRef QHandle As %Binary, ctloc, CDateSt, CDateEnd, type) As %Status
{
	set repid = $I(^CacheTemp)
	set ind = 1
	Set QHandle=$lb(0,repid,0)
 	i $g(ctloc)=""   Quit $$$OK
 	s st=$zdh(CDateSt,3),end=$zdh(CDateEnd,3)
 	i CDateSt="" 	Quit $$$OK  
 	i CDateEnd="" 	Quit $$$OK  
 	i st>end   Quit $$$OK
	s phl=""
	s pid=..NewPid()
	s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
	i phl=""   Quit $$$OK
	s phddate = "", t = 0,dd=0 
     //门诊
     if type=0 {
      f phadate=st:1:end  d
      .f  s phddate=$o(^DHCPHDISPi(phddate)) q:phddate=""  d
      ..q:phddate<st
      ..q:phddate>end
      ..s phdrow = ""
      ..f  s phdrow=$o(^DHCPHDISPi(phddate,phl,phdrow)) q:phdrow=""  d
      ...s pyflag="",fyflag="",pydr="",fydr1="",prt="",inv="",pydate="",use="",perno="",pname=""
      ...s pytime=""
      ...s pytime=+$p(^DHCPHDISP(phdrow,1),"^",7)
      ...s pyflag=$p(^DHCPHDISP(phdrow,1),"^",6)
      ...s fyflag=$p(^DHCPHDISP(phdrow),"^",4)
      ...q:(fyflag'="1")
      ...s pydate=phddate
      ...s pydate=$zd(pydate,4)
      ...s pydr=$p(^DHCPHDISP(phdrow,1),"^",3)
      ...s prescno="",presctype="",prescmoney=0,prescqty=0
      ...s prescno=$p(^DHCPHDISP(phdrow,2),"^",1)
      ...s cyfs=0
      ...s phdsub="",phdorditm="",PrescTypeCode="",m=0
      ...f  s phdsub=$o(^DHCPHDI(phdrow,"PHDI",phdsub)) q:phdsub=""  d
      ....s phdimoney=0
      ....s phdimoney=+$p(^DHCPHDI(phdrow,"PHDI",phdsub),"^",3)
      ....s cyfs=$p(^DHCPHDI(phdrow,"PHDI",phdsub),"^",9) //付数
      ....s prescqty=prescqty+1                           //味数
      ....s phdorditm=$p(^DHCPHDI(phdrow,"PHDI",phdsub),"^",5)
      ....s phdord="",phditm="",phorditm=""
      ....s phorditm=$p(^DHCPHDI(phdrow,"PHDI",phdsub),"^",5)
      ....s phdord=$p(phorditm,"||",1)
      ....s phditm=$p(phorditm,"||",2)
      ....s itmmast=""
      ....s itmmast=$p(^OEORD(phdord,"I",phditm,1),"^",2)
      ....s inci=""
      ....s inci=$o(^INCI(0,"ARCIM_DR",$p(itmmast,"||",1),inci))
      ....s incsc=""
      ....s incsc=+$p(^INCI(inci,2),"^",2)    //类组
      ....//q:(incsc'=CIncCatID)&(CIncCatID'="") 
      ....s phcdrg="",phcform="",phfact="",ordertype="",ItemCatDR=""
      ....s phcdrg=$p(^ARCIM($p(itmmast,"||",1),$p(itmmast,"||",2),1),"^",12)
      ....s subcat="",phcat="",minsubcat=""
      ....s subcat=$p(^PHCD($p(phcdrg,"||",1),1),"^",3)
      ....i subcat'=""  d
      .....s phcat=$p(subcat,"||",1)
      ....//q:(CPhCatID'="")&(CPhCatID'=phcat)
      ....s prescmoney=prescmoney+phdimoney    //金额
      ....s m=m+1
      ...q:m=0
      ...s ord="",itm="",preason="",preascode=""
      ...s ord=$p(phdorditm,"||",1)
      ...s itm=$p(phdorditm,"||",2)
      ...s preason=$p(^OEORD(ord,"I",itm,11),"^",18)
      ...;s preascode=$p(^PAC("ADMREA",preason),"^",1)
      ...s dhcprescrow=""
      ...s dhcprescrow=$o(^DHCPAQPT(0,"PrescNo",prescno,""))
      ...i dhcprescrow '=""  d
      ....s psonrow="",pson="",psoncode=""
      ....s psonrow=+$p(^DHCPAQPT(dhcprescrow),"^",2)
      ....s pson=+$p(^DHCPAADMPrescType(psonrow),"^",2)
      ....;s psoncode=$p(^PAC("ADMREA",pson),"^",1)
      ....s PrescTypeCode=pson
      ...e  s PrescTypeCode=preason
      ...s prescrow="",jytype=""
      ...s prescrow=$o(^PAQUE1(0,"PrescNo",prescno,""))
      ...i prescrow'=""  d
      ....i $d(^PAQUE1(prescrow,"DHC")) s jytype=$p(^PAQUE1(prescrow,"DHC"),"^",15)
      ...s pmi=""
      ...s pmi=+$p(^DHCPHDISP(phdrow),"^",7)
      ...s perno=$p(^PAPER(pmi,"PAT",1),"^",2)
      ...s pname=$p(^PAPER(pmi,"ALL"),"^",1)
      ...s t=t+1
      ...s ^TMP("web","DHCOutPhAdd","CollectPrescTotal",pid,incsc,prescno)=cyfs_"^"_prescqty_"^"_prescmoney
      ...
      ...
      ...
     }  
     else 
     { //住院发药
       f phadate=st:1:end  d   
       .s phac=""
	.f  s phac=$o(^DHCPHAC(0,"PHA",ctloc,"DATE",phadate,phac)) q:phac=""  d  
	..s ch=""
	..s num1=0   ;处方张数
	..s num2=0   ;处方剂数
       ..s ws=0     ;统计味数
       ..
	..f  s ch=$o(^DHCPHAC(phac,"I",ch)) q:ch=""  d
	...s inci=$p(^DHCPHAC(phac,"I",ch),"^",4)
       ...s incsc=""
       ...s incsc=+$p(^INCI(inci,2),"^",2)    //类组
	...s prescno=$p(^DHCPHAC(phac,"I",ch),"^",5)  ;处方号
	...s queid=$o(^PAQUE1(0,"PrescNo",prescno,""))
	...q:queid=""     
	...q:'$d(^PAQUE1(queid,"DHC")) ;过滤非中草药
	...s oedis=$p(^DHCPHAC(phac,"I",ch),"^",7)
       ...//s ws=ws+1      //味数
       ...//q:$d(^TMP("web","DHCOutPhAdd","CollectPrescTotal",pid,incsc,prescno))
       ...//s num1=num1+1         //处方张数
       ...s durdr=$p(^PAQUE1(queid,"DHC"),"^",10)
       ...s facotor=$p(^PHCDU(durdr),"^",2) ;
       ...s num2=facotor+num2      //剂数
       ...s qty=$p(^DHCPHAC(phac,"I",ch),"^",6)
       ...s price=$p(^DHCPHAC(phac,"I",ch),"^",9)
       ...s amtout=qty*price    //金额
       ...i '$d(^TMP("web","DHCOutPhAdd","CollectPrescTotal",pid,incsc,prescno)) d 
       ....s ^TMP("web","DHCOutPhAdd","CollectPrescTotal",pid,incsc,prescno)=facotor_"^"_1_"^"_amtout
       ...e  d
       ....s $p(^TMP("web","DHCOutPhAdd","CollectPrescTotal",pid,incsc,prescno),"^",2)=$p(^TMP("web","DHCOutPhAdd","CollectPrescTotal",pid,incsc,prescno),"^",2)+1    
	....s $p(^TMP("web","DHCOutPhAdd","CollectPrescTotal",pid,incsc,prescno),"^",3)=$p(^TMP("web","DHCOutPhAdd","CollectPrescTotal",pid,incsc,prescno),"^",3)+amtout         
	....

	  }  
      s inscstype=""
      s sumcfcnt=0
      s sumcffac=0
      s sumcfws=0
      s sumcfamt=0
      f  s inscstype=$o(^TMP("web","DHCOutPhAdd","CollectPrescTotal",pid,inscstype)) q:inscstype=""  d 
      .s prescno=""
      .s cfcnt=0
      .s cffac=0
      .s cfws=0
      .s cfamt=0
      .f  s prescno=$o(^TMP("web","DHCOutPhAdd","CollectPrescTotal",pid,inscstype,prescno)) q:prescno=""  d 
      ..//s cfcnt=cfcnt+1
      ..s cfcnt=1
      ..s sumcfcnt=sumcfcnt+cfcnt
      ..s data=^TMP("web","DHCOutPhAdd","CollectPrescTotal",pid,inscstype,prescno)
      ..s inscstypedesc=$p(^INC("SC",inscstype),"^",2)
      ..s cffac=$p(data,"^",1)
      ..s sumcffac=sumcffac+cffac
      ..s cfws=$p(data,"^",2)
      ..s sumcfws=sumcfws+cfws
      ..s cfamt=$p(data,"^",3)
      ..s sumcfamt=sumcfamt+cfamt
      ..set Data=$lb(inscstypedesc,cfcnt,cffac,cfws,cfamt)
      ..Set ^CacheTemp(repid,ind)=Data	
      ..Set ind=ind+1
      k ^TMP("web","DHCOutPhAdd","CollectPrescTotal",pid)

       set Data=$lb("合计:",sumcfcnt,sumcffac,sumcfws,sumcfamt)
 	Set ^CacheTemp(repid,ind)=Data	
 	Set ind=ind+1
	Quit $$$OK
}

ClassMethod NewPid() As %String
{
	q $i(^DHCOUTPHA($this))
}

ClassMethod CreatePrtLabelLog(pmino, content) As %String
{
	s papmi=$o(^PAPERi("PAPMI_PatNo",pmino,""))
	s condition=##class(web.DHCSTCOMMONSRV).ChangeToJson("登记号",pmino)
 	s content=##class(web.DHCSTCOMMONSRV).ChangeToJson("姓名^处方号",content)
 	s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(papmi,"")
 	s EncryptCode=$p(EncryptLevelInfo,"^",3)
 	s ^tmpouteve=condition_"^"_content_"^"_EncryptCode
 	s eventlogret=##class(web.DHCSTCOMMONSRV).CreateEventLog("DHCDISPOUTLABEL",condition,content,EncryptCode)
 	q eventlogret
}

/// 检查库存 返回1足够库存 0库存不够
/// 2015-10-13 LianqQiang
ClassMethod ChkDrugStockQty(inci, ctlocdr, qty) As %String
{
	  s arcitm=$p(^INCI(inci,1),"^",3)
	  q:arcitm="" 0
	  s pid=##CLASS(web.DHCSTKUTIL).GetInclbCounter()
      s puomdr=+$p(^ARCIM($p(arcitm,"||",1),$p(arcitm,"||",2),8),"^",14)
      s buomdr=+$p(^INCI(inci,1),"^",10)
      s confac=##class(web.DHCSTCOMMONSRV).UOMFac(puomdr,buomdr)
      s qty=qty*confac
      s sub=$o(^INCI("IL_LOC",ctlocdr,inci,""),-1)
      q:sub="" 0
      s incil=inci_"||"_sub
      s stkqty=##CLASS(web.DHCST01).GetInclbQty(incil,qty,pid,1)
      i stkqty'=1 q 0
      q 1
}

/// 检查其他未发药科室,没有返回"",有就返回科室串
/// w ##class(web.DHCOutPhAdd).ChkUnFyOtherLoc("2017-08-03","2017-08-03","0000000222","2","2")
ClassMethod ChkUnFyOtherLoc(stdate, enddate, pmino, gphl, gphw = "")
{
	//s ^ligao("ChkUnFyOtherLoc")=stdate_","_enddate_","_pmino_","_gphl_","_gphw
	s pmidr=""
	q:pmino="" -1
 	s pmidr=$o(^PAPERi("PAPMI_PatNo",pmino,""))
 	q:pmidr="" -2
 	s adm="",retadm=""
 	s stdate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(stdate)
 	s enddate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(enddate)
 	s fstdate=stdate
 	s fenddate=enddate
 	//已经收费的
 	s retInfo1=""
	f phadate=fstdate:1:fenddate  d
	.s phl=""
	.f  s phl=$o(^DHCPHARWi(phadate,phl)) q:phl=""  d
	..q:$d(findflag(phl))
	..s pha="",findflag=0
	..f  s pha=$o(^DHCPHARWi(phadate,phl,pha)) q:pha=""  d
	...s finflag=$p(^DHCPHARW(pha),"^",6)
	...q:(finflag="1")
	...s nouse=$p(^DHCPHARW(pha),"^",7)
	...q:nouse="1"
	...s retflag=$p(^DHCPHARW(pha),"^",13)
	...q:retflag'="1"
	...s prt=+$p(^DHCPHARW(pha),"^",1)
	...s papmidr=$p($g(^DHCINVPRT(prt)),"^",15)
	...q:pmidr'=papmidr
	...s phaphw=$p(^DHCPHARW(pha),"^",4)
	...q:phaphw=""
	...q:(gphl=phl)&&((gphw=phaphw)||(gphw=""))  // 科室+窗口相同不提示
	...s ctloc=$p($g(^DHCPHLOC(phl)),"^",1)
	...q:ctloc=""
	...s ctlocdesc=$p($g(^CTLOC(ctloc)),"^",2)
	...i ctlocdesc["-" s ctlocdesc=$p(ctlocdesc,"-",2)
	...s phwdesc=$p(^DHCPHWIN(phaphw),"^",1)
	...s tmpRetInfo=ctlocdesc_":"_phwdesc
	...q:$d(ChkUnFyOtherLoc(tmpRetInfo))
	...s ChkUnFyOtherLoc(tmpRetInfo)=""
	...s retInfo1=$s(retInfo1="":"　　"_tmpRetInfo,1:retInfo1_"</br>　　"_tmpRetInfo)
	i retInfo1'="" s retInfo1="待取药信息:</br>"_retInfo1
	k ChkUnFyOtherLoc
	s groupid=$s($d(%session):%session.Data("LOGON.GROUPID"),1:"")
	s hospId=$s($d(%session):%session.Data("LOGON.HOSPID"),1:"")
	s payMode=##class(PHA.FACE.IN.Com).IStayPayModeByEpisodeID(hospId)
	//未收费的
	s retInfo2=""
	s ordRet=..CheckCard(stdate, enddate, pmino, groupid, "") // ^1321||4^ 分隔的未交费串
	s ordI=0
	f ordI=1:1:$l(ordRet,"^") q:ordRet=0  d
	.s ordItm=$p(ordRet,"^",ordI)
	.q:ordRet=0
	.q:ordItm=""
	.s emLGflag=$p($g(^OEORD(+ordItm,"I",$p(ordItm,"||",2),"DHC")),"^",17) //急诊留观标志
	.q:(emLGflag'="")&(emLGflag'=0)&(payMode="1")
	.s ReadyToBill=$p($g(^OEORD(+ordItm,"I",$p(ordItm,"||",2),12)),"^",26)
	.q:ReadyToBill="Y"	//急诊留观和先就诊后收费的不处理
	.s recLocDr=$p(^OEORD(+ordItm,"I",$p(ordItm,"||",2),3),"^",6)
	.q:recLocDr=""
	.q:'$d(^DHCPHLOCi("LOC",+recLocDr))
	.q:$d(ChkUnFyOtherLoc(recLocDr))
	.s ChkUnFyOtherLoc(recLocDr)=1 
	.s ctlocdesc=$p($g(^CTLOC(recLocDr)),"^",2)
	.i ctlocdesc["-" s ctlocdesc=$p(ctlocdesc,"-",2)
	.s retInfo2=$s(retInfo2="":"　　"_ctlocdesc,1:retInfo2_"</br>　　"_ctlocdesc)
	i retInfo2'="" s retInfo2="待交费信息:</br>"_retInfo2
	k ChkUnFyOtherLoc
	s retInfo=retInfo1
	i retInfo2'="" s retInfo=retInfo_"</br>"_retInfo2
	q retInfo
}

ClassMethod GetChkUnFyThisLocProp(LocId, GroupId, UserId)
{
	s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
    s Param=GroupId_"^"_LocId_"^"_UserId_"^"_$g(HospId)
    s AppName="DHCSTOUTPH"
    s ChkUnDispPrescNum=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"ChkUnDispPrescNum",Param)
    q ChkUnDispPrescNum
}

/// w ##class(web.DHCOutPhAdd).ChkUnFyThisLoc("2022-03-13","2022-03-15","0000000150","1")
/// Description:发药完成之后检查该病人在该药房的剩余未发处方数量(有项目怕漏打处方/配药单)
ClassMethod ChkUnFyThisLoc(stdate, enddate, pmino, gphl)
{
    s stdate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(stdate)
 	s enddate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(enddate)
 	s pmidr=""
	q:pmino="" -1
 	s pmidr=$o(^PAPERi("PAPMI_PatNo",pmino,""))
 	q:pmidr="" -2
 	s unDspPrescNum=0
 	f phadate=stdate:1:enddate  d
	.s pha=""
	.f  s pha=$o(^DHCPHARWi(phadate,gphl,pha)) q:pha=""  d
	..s prescno=$p(^DHCPHARW(pha),"^",16)
	..s finflag=$p(^DHCPHARW(pha),"^",6)
	..q:(finflag="1")
	..s nouse=$p(^DHCPHARW(pha),"^",7)
	..q:nouse="1"
	..s retflag=$p(^DHCPHARW(pha),"^",13)
	..q:retflag'="1"
	..s prt=+$p(^DHCPHARW(pha),"^",1)
	..s papmidr=$p($g(^DHCINVPRT(prt)),"^",15)
	..q:pmidr'=papmidr
	..s doclocstr=##class(web.DHCOutPhCommon).GetOrdUseLocByPresc(prescno)
    ..s uselocdr=$p(doclocstr,"^",1)
    ..q:uselocdr'=""   //基数药过滤
    ..s unDspPrescNum=unDspPrescNum+1
    q unDspPrescNum
}

}
