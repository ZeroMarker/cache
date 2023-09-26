Import sqluser

Class web.DHCOutPhCode Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod UFindPhLocClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = UFindPhLocExecute ]
{
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod UFindPhLocExecute(ByRef QHandle As %Binary, HospId = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	s ind=1
	set myrowid=0
	s flag=""
 	for  s myrowid=$o(^DHCPHLOC(myrowid)) q:(myrowid="")!(myrowid="0")  d
 	   .s ctloc="",py="",fy="",yfsf="",tjfs="",cyflag="",tel="",cymb="",dispwin=""
 	   .s desc="",phlid="",sendflag="",dispmachine="",screenflag="",screenpath=""
 	   .s ctloc=+$p(^DHCPHLOC(myrowid),"^",1)
 	   .q:(HospId'=$p($g(^CTLOC(ctloc)),"^",22))
 	   .s py=$p(^DHCPHLOC(myrowid),"^",2) 
 	   .s fy=$p(^DHCPHLOC(myrowid),"^",3)
 	   .s yfsf=$p(^DHCPHLOC(myrowid),"^",4)
 	   .s tjfs=$p(^DHCPHLOC(myrowid),"^",5)
 	   .s cyflag=$p(^DHCPHLOC(myrowid),"^",6)
 	   .s sendflag=$p(^DHCPHLOC(myrowid),"^",12)
 	   .s printflag=$p(^DHCPHLOC(myrowid),"^",13)
 	   .s typeflag=$p(^DHCPHLOC(myrowid),"^",14)
 	   .s dispmachine=$p(^DHCPHLOC(myrowid),"^",15)
 	   .s screenflag=$p(^DHCPHLOC(myrowid),"^",16)
 	   .s screenpath=$p(^DHCPHLOC(myrowid),"^",17)
 	   .s pysure=$p(^DHCPHLOC(myrowid),"^",18)
 	   .s autopy=$p(^DHCPHLOC(myrowid),"^",19)
 	   .i tjfs="1" s tjfs="是"
 	   .e  s tjfs="否" 
 	   .i py="1" s py="是" 
 	   .e  s py="否"
 	   .i fy="1" s fy="是"
 	   .e  s fy="否"
 	   .i cyflag="1" s cyflag="是"
 	   .e  s cyflag="否"
 	   .i sendflag="1" s sendflag="是"
 	   .e  s sendflag="否"
 	   .i printflag="1" s printflag="是"
 	   .e  s printflag="否"
 	   .i typeflag="1" s typeflag="是"
 	   .e  s typeflag="否"
 	   .i dispmachine="1" s dispmachine="是"
 	   .e  s dispmachine="否"
 	   .i screenflag="1" s screenflag="是"
 	   .e  s screenflag="否"
 	   .s phlid=myrowid
 	   .i yfsf="1" s yfsf="按照次序"
 	   .e  s yfsf="按照工作量"
 	   .i dispwin="1" s dispwin="是"
 	   .e  s dispwin="否"
 	   .s desc=$p($g(^CTLOC(ctloc)),"^",2)
 	   .i pysure=1 s pysure="是"
 	   .e  s pysure="否"
 	   .i autopy="1" s autopy="是"
 	   .e  s autopy="否"
 	   .s auditflag=$p(^DHCPHLOC(myrowid),"^",7)
 	   .i auditflag="Y" s auditflag="是"
 	   .e  s auditflag="否"
 	   .s OthLocRetflag=$p(^DHCPHLOC(myrowid),"^",8)
 	   .i OthLocRetflag="Y" s OthLocRetflag="是"
 	   .e  s OthLocRetflag="否"
 	   .Do OutputRow
 	Set QHandle=$lb(0,repid,0)
 	
	Quit $$$OK
OutputRow
	set Data=$lb(desc,ctloc,py,fy,yfsf,phlid,tjfs,cyflag,sendflag,printflag,typeflag,dispmachine,screenflag,screenpath,pysure,autopy,auditflag,OthLocRetflag)
 	Set ^CacheTemp(repid,ind)=Data	
 	Set ind=ind+1
	quit
ResetVariables
	///set (repid)=0
	set (desc,ctloc,py,fy,yfsf,phlid,tjfs,cyflag,sendflag,dispmachine,screenflag,screenpath)=""
	quit
}

ClassMethod UFindPhLocFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = UFindPhLocExecute ]
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

Query UFindPhLoc(HospId) As %Query(ROWSPEC = "Tdesc:%String,Tyfid:%String,Tpy:%String,Tfy:%String,Tyfsf:%String,Tphlid:%String,Tbyfs:%String,TCyFlag:%String,TSendFlag:%String,TPrintFlag:%String,TWinTypeFlag:%String,TDispMachine:%String,TScreenFlag:%String,TScreenPath:%String,Tpysure:%String,TAutoPyFlag:%String,TAuditFlag:%String,TOthLocRet:%String") [ SqlProc ]
{
}

ClassMethod insertPhLoc(desc As %Library.String = "", py As %Library.String = "", fy As %Library.String = "", math As %Library.String = "", tjfs As %Library.String = "", cyflag As %Library.String = "", sendflag As %Library.String = "", printflag As %Library.String = "", typeflag As %Library.String = "", dispmachine As %Library.String = "", screen As %Library.String = "", screenpath As %Library.String = "", pysure, autopy, auditflag, OthLocRetflag)
{
 s ctloc=desc
 i ctloc="" q 1
 s phl=""
 s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
 i phl'="" q 1
 e  d
    .&sql(insert into SQLUser.DHC_Phloc 
      (Phl_ctloc_dr,phl_pyflag,phl_fyflag,phl_arithmet,phl_tjflag,phl_mixflag,phl_auditflag,PHL_OthLocRetflag,
      PHL_SendFlag,PHL_PrintFlag,PHL_WinTypeFlag,PHL_DispMachine,PHL_ScreenFlag,PHL_ScreenPath,PHL_PySureFlag,PHL_AutoPYFlag) 
       values(:ctloc,:py,:fy,:math,:tjfs,:cyflag,:auditflag,:OthLocRetflag,
       :sendflag,:printflag,:typeflag,:dispmachine,:screen,:screenpath,:pysure,:autopy))
    .s retrow=""
    .s retrow=$g(%ROWID)

 q SQLCODE
}

ClassMethod UpdatePhLoc(rowid As %Library.String = "", pyflag As %Library.String = "", fyflag As %Library.String = "", math As %Library.String = "", tjfs As %Library.String = "", cyflag As %Library.String = "", userid As %Library.String = "", sendflag As %Library.String = "", printflag As %Library.String = "", typeflag As %Library.String = "", dispmachine As %Library.String = "", screen As %Library.String = "", screenpath As %Library.String = "", pysure, autopy, auditflag, OthLocRetflag)
{
 s ctloc="",ccode="",tt=0,ret=""
 s php=""
 f  s php=$o(^DHCPHPERi("USR",userid,php)) q:php=""  d
   .s phl="",ctloc=""
   .s phl=+$p(^DHCPHPER(php),"^",3)
   .s ctloc=+$p(^DHCPHLOC(phl),"^",1)
   .q:phl'=rowid
   .s tt=tt+1
 i tt=0 s ret=""
 e  d
  .&sql(update SQLUser.dhc_phloc set phl_pyflag=:pyflag,phl_fyflag=:fyflag,phl_arithmet=:math,phl_tjflag=:tjfs,phl_mixflag=:cyflag,phl_auditflag=:auditflag,phl_OthLocRetflag=:OthLocRetfla,
  PHL_SendFlag=:sendflag,PHL_PrintFlag=:printflag,PHL_WinTypeFlag=:typeflag,PHL_DispMachine=:dispmachine,PHL_ScreenFlag=:screen,PHL_ScreenPath=:screenpath,PHL_PySureFlag=:pysure,PHL_AutoPYFlag=:autopy  where phl_rowid=:rowid)   
  .s ret=SQLCODE
 q ret
}

ClassMethod UpdatePhWin(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "", windesc As %Library.String = "", pyflag As %Library.String = "", fyflag As %Library.String = "", userid As %Library.String = "", wintype As %Library.String = "", ValueString = "")
{
	s ctloc="",ccode="",ret="",tt=0,ll=0
	s typeflag=$p(ValueString,"^",1)
	s phl=""
	s phl=+$p(^DHCPHWIN(rowid),"^",2)
	s php=""
	f  s php=$o(^DHCPHPERi("USR",userid,php)) q:php=""  d
	.s phwphl="",ctloc=""
	.s phwphl=+$p(^DHCPHPER(php),"^",3)
	.q:'$d(^DHCPHLOC(phwphl))
	.s ctloc=+$p(^DHCPHLOC(phwphl),"^",1)
	.q:phl'=phwphl
	.s ll=ll+1
	i ll=0 s ret="-2"
	e  d
	. i pyflag="1"  d
	..&sql(select count(phw_rowid) into :tt from sqluser.dhc_phwindow where phw_ok='1' and phw_rowid<>:rowid and phw_phl_dr=:phl and phw_nouse<>'1' )
	.i tt>0  s ret="-1"
	.e  d
	..&SQL(SELECT * FROM DHC_PHWINDOW WHERE PHW_PHL_DR=:phl AND PHW_DESC=:windesc and phw_rowid<>:rowid)
	..i SQLCODE=0 s ret=-3
	..q:ret'=""
	..s $p(^DHCPHWIN(rowid),"^",1)=windesc
	..s $p(^DHCPHWIN(rowid),"^",3)=pyflag
	..s $p(^DHCPHWIN(rowid),"^",4)=fyflag
	..s $p(^DHCPHWIN(rowid),"^",5)=typeflag
	..i '$d(^DHCPHWINTYPE(rowid))  d
	...s ^DHCPHWINTYPE(rowid)=wintype
	..e  s ^DHCPHWINTYPE(rowid)=wintype
	..s ret=0
	q:(itmjs="")&&(itmjsex="") ret
	s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
	i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
	&javascript<#(retval)#>
	q 1
}

ClassMethod FindPhWinClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindPhWinExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod FindPhWinExecute(ByRef QHandle As %Binary, strParams = "", HospId = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	s ind=1
	s locId=$p(strParams,"^",1)
	s winTypeId=$p(strParams,"^",2)
	s winDesc=$p(strParams,"^",3)
	s defaultFlag=$p(strParams,"^",4)
	s nouseFlag=$p(strParams,"^",5)
	s logctlocdr=$g(%session.Data("LOGON.USERID"))
	s logctlocdrstr=..GetLocFrUser(logctlocdr)
    s logctloccnt=$l(logctlocdrstr,"^")
    
	set myrowid=0
 	for  s myrowid=$o(^DHCPHWIN(myrowid)) q:(myrowid="")!(myrowid="0")  d
 	   .s phl="",okflag="",nouse="",windesc="",wintype="",chkloglocflag=0
 	   .s ctlocdesc="",ctloc=""
 	   .s windesc=$p(^DHCPHWIN(myrowid),"^",1)
 	   .q:(winDesc'="")&&(windesc'[winDesc)
 	   .i '$d(^DHCPHWIN(myrowid))  &sql(delete from DHC_PHWINDOW where PHW_PHL_DR =:myrowid )
 	   .s phl=+$p(^DHCPHWIN(myrowid),"^",2)
 	   .s ctloc=+$p(^DHCPHLOC(phl),"^",1)
 	   .q:(HospId'="")&&(HospId'=$p($g(^CTLOC(ctloc)),"^",22))
 	   .q:(locId'="")&&(locId'=ctloc)
 	   .f locdrnum=1:1:logctloccnt d
 	   ..s tmpstr=$p(logctlocdrstr,"^",locdrnum)
 	   ..s logctlocdr=$p(tmpstr,$c(1),1)
 	   ..q:logctlocdr'=ctloc
 	   ..s chkloglocflag=1
 	   .q:chkloglocflag=0
 	   .
 	   .s py=+$p(^DHCPHWIN(myrowid),"^",3)
 	   .s fy=+$p(^DHCPHWIN(myrowid),"^",4)
 	   .q:(defaultFlag="1")&&(py'=defaultFlag)
 	   .q:(nouseFlag="1")&&(fy'=nouseFlag)
 	   .i py="1" s py="是" 
 	   .e  s py="否"
 	   .i fy="1" s fy="是"
 	   .e  s fy="否"
 	   .s ctlocdesc=$p($g(^CTLOC(ctloc)),"^",2)
 	   .s wintypedesc="",wintype=""
 	   .i $d(^DHCPHWINTYPE(myrowid))  d
 	   ..s wintype=$g(^DHCPHWINTYPE(myrowid))
 	   .i wintype="" s wintype=1
 	   .i (wintype="")!(wintype="1") s wintypedesc="普通"
 	   .i wintype="2"  s wintypedesc="特殊(毒麻精一)"
 	   .i wintype="3"  s wintypedesc="日间"
 	   .i wintype="4"  s wintypedesc="草药"
 	   .q:(winTypeId'="")&&(winTypeId'=wintype)
 	   .Do WinOutputRow
 	
 	Set QHandle=$lb(0,repid,0)
 	
	Quit $$$OK
WinOutputRow
	set Data=$lb(ctlocdesc,phl,windesc,myrowid,py,fy,wintypedesc,wintype,ctloc)
 	Set ^CacheTemp(repid,ind)=Data	
 	Set ind=ind+1
	quit
WinResetVariables
	///set (repid)=0
	set (ctlocdesc,phl,windesc,myrowid,py,fy)=""
	quit
}

ClassMethod FindPhWinFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPhWinExecute ]
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

Query FindPhWin(strParams = "", HospId = "") As %Query(ROWSPEC = "TLocDesc:%String,TPhlid:%String,TWinDesc:%String,TPhwid:%String,TSureFlag:%String,TNoUseFlag:%String,TWinType,TWinTypeId,TLocId") [ SqlProc ]
{
}

ClassMethod QueryPhUnReasClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryPhUnReasExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryPhUnReasExecute(ByRef QHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	s ind=1
	set myrowid=0
 	f  s myrowid=$o(^DHCPHUNDR(myrowid)) q:(myrowid="")!(myrowid="0")  d
 	   .s desc="",ctloc=""
 	   .s desc=$p(^DHCPHUNDR(myrowid),"^",1)
  	   .set Data=$lb(desc,myrowid)
  	   .Set ^CacheTemp(repid,ind)=Data	
 	   .Set ind=ind+1
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryPhUnReasFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPhUnReasExecute ]
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

Query QueryPhUnReas() As %Query(ROWSPEC = "TUnReasDesc:%String,TUnReasID:%String") [ SqlProc ]
{
}

ClassMethod insertReason(reasdesc As %Library.String = "")
{
 
 s ret=..CheckReason(reasdesc,"")
 q:ret'=0 -9999
 s ret=""
 &sql(insert into SQLUser.DHC_PHUNDREAS(phundr_desc) values (:reasdesc))
 s ret=SQLCODE
 q ret
}

ClassMethod CheckReason(reasdesc As %Library.String = "", reasid As %Library.String = "")
{
 s ret="0"
 s undr=""
 f  s undr=$o(^DHCPHUNDR(undr)) q:undr=""  d
 .s undesc=$p(^DHCPHUNDR(undr),"^",1)
 .q:undesc'=reasdesc
 .q:reasid=undr
 .s ret=ret+1
 q ret
}

ClassMethod updateReason(reasdesc As %Library.String = "", reasid As %Library.String = "")
{
 s ret=..CheckReason(reasdesc,reasid)
 q:ret'=0 -9999
 s ret=""
 &sql(update SQLUser.DHC_PHUNDREAS set phundr_desc=:reasdesc where phundr_rowid=:reasid)
 s ret=SQLCODE
 q ret
}

ClassMethod DeleteReason(reasdesc As %Library.String = "", reasid As %Library.String = "")
{
 s ret="",m=0,l=0
 &sql(select count(phund_rowid) into :m from SQLUser.dhc_phundispen where phund_phundr_dr=:reasid)
 &sql(select count(phunr_rowid) into :l from SQLUser.dhc_phunreturn where phunr_phundr_dr=:reasid)
 i m>0 q -1
 i l>0 q -1
 &sql(delete from SQLUser.DHC_PHUNDREAS where phundr_rowid=:reasid)
 s ret=SQLCODE
 q ret
}

/// w ##class(web.DHCOutPhCode).insertPhWin("","","100","32121","0","0","1")
ClassMethod insertPhWin(itmjs As %Library.String = "", itmjsex As %Library.String = "", ctloc As %Library.String = "", windesc As %Library.String = "", py As %Library.String = "", fy As %Library.String = "", wintype As %Library.String = "")
{
	s ccode="",phl="",count=0	
	i ctloc'=""  d
	.&sql(select phl_rowid into :phl from SQLUser.dhc_phloc where phl_ctloc_dr=:ctloc)
	.i phl'="" s phl=$p(phl,$c(1),1)
	i phl=""  s SQLCODE=1
	e  d
	.&SQL(SELECT * FROM DHC_PHWINDOW WHERE PHW_PHL_DR=:phl AND PHW_DESC=:windesc)
	.i SQLCODE=0 s SQLCODE=-3
	.e  s SQLCODE=0
	.q:SQLCODE'=0
	.&sql(select count(phw_rowid) into :count from SQLUser.dhc_phwindow where phw_phl_dr=:phl and phw_ok='1')
	.i (py="1")&(count'=0) s SQLCODE="-1"
	.e  d inbor
	q:(itmjs="")&&(itmjsex="") SQLCODE
	s retval=itmjs_"('"_$ZCVT(SQLCODE,"O","JS")_"');"
	i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(SQLCODE,"O","JS")_"');"
	&javascript<#(retval)#>
	q 1
inbor
  s phw=""
  &sql(Insert into SQLUser.DHC_Phwindow(phw_phl_dr,phw_desc,phw_ok,phw_nouse) values(:phl,:windesc,:py,:fy))
  s phw=+$g(%ROWID)
  i '$d(^DHCPHWINTYPE(phw))  d
   .s ^DHCPHWINTYPE(phw)=wintype
  &sql(insert into sqluser.dhc_phwper(phwp_phl_dr,phwp_phw_dr)
          values(:phl,:phw))
}

ClassMethod insertGlobWin(phl As %Library.String = "", phw As %Library.String = "", pdate As %Library.String = "", openflag As %Library.String = "", dfflag As %Library.String = "", pfrs As %Library.String = "", userid As %Library.String = "")
{
  s pdate=$zdh(pdate,4)
 i (openflag="1")&(pfrs>0)&(dfflag="1")  d
    .i '$d(^DHCTodayCurrWin(pdate,"D",phl))  d
       ..s ^DHCTodayCurrWin(pdate,"D",phl)=phw
    
   i (openflag="1")&(pfrs>0)&(dfflag'="1")  d
    .i '$d(^DHCTodayCurrWin(pdate,"X",phl))  d
       ..s ^DHCTodayCurrWin(pdate,"X",phl)=phw
 
  s ^DHCPHLOCWINOPEN(pdate,phl,phw)=openflag_"^"_dfflag_"^"_pfrs_"^"_userid
  q 0
}

ClassMethod UpdateGlobWin(phl As %Library.String = "", phw As %Library.String = "", pdate As %Library.String = "", openflag As %Library.String = "", dfflag As %Library.String = "", pfrs As %Library.String = "", userid As %Library.String = "")
{
  s pdate=$zdh(pdate,4)
  i '$d(^DHCPHLOCWINOPEN(pdate,phl,phw)) q -1
  s dfwin="",xfwin=""
  s dfwin=$g(^DHCTodayCurrWin(pdate,"D",phl))
  s xfwin=$g(^DHCTodayCurrWin(pdate,"X",phl))
  i dfflag="1"  d
    .i phw=xfwin  d
       ..s ^DHCTodayCurrWin(pdate,"D",phl)=""
  e  d
    .i phw=dfwin  d
       ..s ^DHCTodayCurrWin(pdate,"D",phl)=""
   s ^DHCPHLOCWINOPEN(pdate,phl,phw)=openflag_"^"_dfflag_"^"_pfrs_"^"_userid
  q 0
}

ClassMethod QueryLocWinClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryLocWinExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryLocWinExecute(ByRef QHandle As %Binary, CDate As %Library.String = "", ctloc As %Library.String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	s ind=1
	i (ctloc="") Set QHandle=$lb(0,repid,0)	Quit $$$OK
	s phl=""
	
    s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
	i (phl="") Set QHandle=$lb(0,repid,0)	Quit $$$OK
	s cyflag=""
	s cyflag=$p(^DHCPHLOC(phl),"^",6)
	i (cyflag'="1") Set QHandle=$lb(0,repid,0)	Quit $$$OK
	s stdate=$zd(CDate,4)
	s phlocdesc=""
	s phlocdesc=$p(^CTLOC(ctloc),"^",2)
	;^DHCPHLOCWINOPEN(phl,stdate)
	i '$d(^DHCPHLOCWINOPEN(CDate,phl)) d
	  .s phw=""
	  .f  s phw=$o(^DHCPHWINi("WIN",phl,phw)) q:phw=""  d
	    ..s phwindesc="",phwnouse=""
	    ..s phwnouse=$p(^DHCPHWIN(phw),"^",4)
	    ..q:phwnouse="1"
	    ..s phwindesc=$p(^DHCPHWIN(phw),"^",1)
	    ..set Data=$lb(phlocdesc,phl,phwindesc,phw,"0","0",stdate,"","0")
 	    ..Set ^CacheTemp(repid,ind)=Data	
 	    ..Set ind=ind+1
 	  e  d
 	    .s phw=""
 	    .f  s phw=$o(^DHCPHLOCWINOPEN(CDate,phl,phw)) q:phw=""  d
 	      ..s phwindesc="",winopen="",baflag="",pfrs=""
 	      ..s phwindesc=$p(^DHCPHWIN(phw),"^",1) 
 	      ..s winopen=$p(^DHCPHLOCWINOPEN(CDate,phl,phw),"^",1)
 	      ..s baflag=$p(^DHCPHLOCWINOPEN(CDate,phl,phw),"^",2)
 	      ..s pfrs=$p(^DHCPHLOCWINOPEN(CDate,phl,phw),"^",3)
 	      ..set Data=$lb(phlocdesc,phl,phwindesc,phw,winopen,baflag,stdate,pfrs,"1")
 	      ..Set ^CacheTemp(repid,ind)=Data	
 	      ..Set ind=ind+1
 	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryLocWinFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocWinExecute ]
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

Query QueryLocWin(CDate As %String, ctloc As %String) As %Query(ROWSPEC = "TLocDesc:%String,TPhlid:%String,TWinDesc:%String,TPhwid:%String,TOpenFlag:%String,TDFFlag:%String,TDate:%String,TPfNum:%String,TOld:%String")
{
}

ClassMethod FindPhPYWinClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindPhPYWinExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod FindPhPYWinExecute(ByRef QHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	set myrowid=0
	for  s myrowid=$o(^DHCPHPY(myrowid)) q:(myrowid="")!(myrowid="0")  d
	.s phl="",okflag="",nouse="",windesc="",boxnum="",sendcode=""
	.s ctlocdesc="",ctloc=""
	.s windesc=$p(^DHCPHPY(myrowid),"^",1)
	.s phl=+$p(^DHCPHPY(myrowid),"^",2)
	.s ctloc=+$p(^DHCPHLOC(phl),"^",1)
	.s ctlocdesc=$p($g(^CTLOC(ctloc)),"^",2)
	.i $f(ctlocdesc,"-") s ctlocdesc=$p(ctlocdesc,"-",2)
	.i $d(^DHCPHPYBOX(myrowid))  d
	..s boxnum=$p(^DHCPHPYBOX(myrowid),"^",1)
	..s sendcode=$p(^DHCPHPYBOX(myrowid),"^",3)
	.Do WinOutputRow
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
WinOutputRow
	set Data=$lb(ctlocdesc,phl,windesc,myrowid,boxnum,sendcode,ctloc)
 	Set ^CacheTemp(repid,ind)=Data	
 	Set ind=ind+1
	quit
WinResetVariables
	///set (repid)=0
	set (ctlocdesc,phl,windesc,myrowid,boxnum,sendcode,ctloc)=""
	quit
}

ClassMethod FindPhPYWinFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPhPYWinExecute ]
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

Query FindPhPYWin() As %Query(ROWSPEC = "TLocDesc:%String,TPhlid:%String,TWinDesc:%String,TPhPyWin:%String,TBoxNum:%String,TSendCode:%String,TLocId:%String") [ SqlProc ]
{
}

ClassMethod insertPhPyWin(ctloc As %Library.String = "", windesc As %Library.String = "", boxnum As %Library.String = "", sendcode As %Library.String = "")
{
  q:ctloc="" -1
  s err=0
  s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
  q:phl="" -4
  s phpyid=""
  f  s phpyid=$o(^DHCPHPYi("LOC",phl,phpyid)) q:phpyid=""  d
  .s desc=$p(^DHCPHPY(phpyid),"^",1)
  .i desc=windesc s err=-2
  q:err'=0 err
  &sql(Insert into DHC_Phpywin(phpy_phl_dr,phpy_desc) 
  values(:phl,:windesc))
  s pyrow=$g(%ROWID)
  s $p(^DHCPHPYBOX(pyrow),"^",1)=boxnum
  s $p(^DHCPHPYBOX(pyrow),"^",3)=sendcode
  q SQLCODE
}

/// w ##class(web.DHCOutPhCode).UpdatePhPyWin(2,"配1")
ClassMethod UpdatePhPyWin(rowid As %Library.String = "", windesc As %Library.String = "", boxnum As %Library.String = "", sendcode As %Library.String = "")
{
  //判断名称是否重复,yunhaibao20160708
  s exist=""
  s phl=$p(^DHCPHPY(rowid),"^",2)
  q:phl="" -2
  s phpy=""
  f  s phpy=$o(^DHCPHPYi("LOC",phl,phpy)) q:(phpy="")||(exist'="")  d
  .q:+phpy=0
  .q:phpy=rowid
  .s phwindesc=$p(^DHCPHPY(phpy),"^",1)
  .i phwindesc=windesc s exist=1
  q:exist'="" -1	
  &sql(update DHC_Phpywin set phpy_desc=:windesc where phpy_rowid=:rowid)
  s $p(^DHCPHPYBOX(rowid),"^",1)=boxnum
  s $p(^DHCPHPYBOX(rowid),"^",3)=sendcode
  q SQLCODE
}

ClassMethod FindPhPYWinSubClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindPhPYWinSubExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod FindPhPYWinSubExecute(ByRef QHandle As %Binary, ctLocId = "", HospId = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	s ind=1
	set myrowid=0
 	for  s myrowid=$o(^DHCPHPY(myrowid)) q:(myrowid="")!(myrowid="0")  d
 	   .s pywinsub="0"  
 	   .f  s pywinsub=$o(^DHCPHPY(myrowid,"PHW",pywinsub)) q:(pywinsub="")!(pywinsub="0")  d
 	   ..s phl="",okflag="",nouse="",windesc="",fywin="",fywindesc=""
 	   ..s ctlocdesc="",ctloc=""
 	   ..s windesc=$p(^DHCPHPY(myrowid),"^",1)
 	   ..s fywin=+$p(^DHCPHPY(myrowid,"PHW",pywinsub),"^",1)
 	   ..s fywindesc=$p(^DHCPHWIN(fywin),"^",1)
 	   ..s phl=+$p(^DHCPHPY(myrowid),"^",2)
 	   ..s ctloc=+$p(^DHCPHLOC(phl),"^",1)
 	   ..q:(ctLocId'="")&&(ctLocId'=ctloc)
 	   ..q:(HospId'=$p($g(^CTLOC(+ctloc)),"^",22))
 	   ..s ctlocdesc=$p($g(^CTLOC(ctloc)),"^",2)
 	   ..s currrow=""
 	   ..s currrow=myrowid_"||"_pywinsub
 	   ..Do WinOutputRow
 	
 	Set QHandle=$lb(0,repid,0)
 	
	Quit $$$OK
WinOutputRow
	set Data=$lb(ctlocdesc,phl,fywindesc,fywin,windesc,currrow,ctloc)
 	Set ^CacheTemp(repid,ind)=Data	
 	Set ind=ind+1
	quit
WinResetVariables
	///set (repid)=0
	set (ctlocdesc,phl,fywindesc,fywin,windesc,currrow,ctloc)=""
	quit
}

ClassMethod FindPhPYWinSubFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPhPYWinSubExecute ]
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

Query FindPhPYWinSub(ctLocId = "", HospId = "") As %Query(ROWSPEC = "TLocDesc:%String,TPhlid:%String,TFyWinDesc:%String,TPhwid:%String,TPyWinDesc:%String,TPyWinID:%String,TLocId:%String") [ SqlProc ]
{
}

ClassMethod GetFyWinClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetFyWinExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetFyWinExecute(ByRef QHandle As %Binary, phl As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	i $g(phl)=""  Set QHandle=$lb(0,repid,0) Quit $$$OK
	s ind=1
	set phw="0"
	f  s phw=$o(^DHCPHWINi("WIN",phl,phw)) q:(phw="0")!(phw="")  d
	     .s phwdesc="",useflag=""
	     .s phwdesc=$p(^DHCPHWIN(phw),"^",1)
         .set Data=$lb(phwdesc,phw)
         .Set ^CacheTemp(repid,ind)=Data	
 	     .Set ind=ind+1
 	Set QHandle=$lb(0,repid,0)
 	
	Quit $$$OK
}

ClassMethod GetFyWinFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFyWinExecute ]
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

Query GetFyWin(phl As %String) As %Query(ROWSPEC = "发药窗口:%String,ID:%String") [ SqlProc ]
{
}

ClassMethod GetPyWinClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetPyWinExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetPyWinExecute(ByRef QHandle As %Binary, phl As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	i $g(phl)=""  Set QHandle=$lb(0,repid,0) Quit $$$OK
	s ind=1
	set phpw="0"
	f  s phpw=$o(^DHCPHPYi("LOC",phl,phpw)) q:(phpw="0")!(phpw="")  d
	     .s phwdesc="",useflag=""
	     .s phwdesc=$p(^DHCPHPY(phpw),"^",1)
         .set Data=$lb(phwdesc,phpw)
         .Set ^CacheTemp(repid,ind)=Data	
 	     .Set ind=ind+1
 	Set QHandle=$lb(0,repid,0)
 	
	Quit $$$OK
}

ClassMethod GetPyWinFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPyWinExecute ]
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

Query GetPyWin(phl As %String) As %Query(ROWSPEC = "配药窗口:%String,ID:%String") [ SqlProc ]
{
}

ClassMethod insertPhPyFyWin(ctloc As %Library.String = "", fywin As %Library.String = "", pywin As %Library.String = "")
{
  s fycs=0
  
  &sql(select count(*) into :fycs from dhc_phpywinsub where phpys_phw_dr=:fywin)
  i fycs>0 q -1
  s phl=""
  s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
  i phl'=+$p(^DHCPHPY(pywin),"^",2) q -2
  s pysub="0",maxsub=0
  f  s pysub=$o(^DHCPHPY(pywin,"PHW",pysub)) q:(pysub="0")!(pysub="")  d
   .s maxsub=pysub
   
  s currsub=maxsub+1
  &sql(Insert into DHC_PHPYWINSUB(phpys_phpy_parref,phpys_childsub,phpys_phw_dr) 
  values(:pywin,:currsub,:fywin))
  q SQLCODE
}

ClassMethod DeletePyFyWin(pywinsubrow As %String)
{
  &sql(delete from dhc_phpywinsub where phpys_rowid=:pywinsubrow)
  q SQLCODE
}

/// w ##class(web.DHCOutPhCode).GetLocFrUser(578)
ClassMethod GetLocFrUser(userid)
{
	s ret=""
	s ctloc="",ctlocdesc=""
	i userid="" q ret
	s ctloc=+$p(^SSU("SSUSR",userid),"^",4)
	s ctlocdesc=$p($g(^CTLOC(ctloc)),"^",2)
	i ctlocdesc["-" s ctlocdesc=$p(ctlocdesc,"-",2) 
	s lstr=$p($g(^CTLOC(ctloc)),"^",43)
	s ret=ctloc_$C(1)_ctlocdesc
	s GetLocFrUserArr(ctloc)=""
	s othusr="0",th=0
	f  s othusr=$o(^SSU("SSUSR",userid,"OTHLL",othusr)) q:(othusr="")!(othusr="0")  d
	.s loc="",CTDesc=""
	.s loc=+$p(^SSU("SSUSR",userid,"OTHLL",othusr),"^",1)
	.q:loc=0
	.s ctloctype=""
	.s lstr=$p($g(^CTLOC(loc)),"^",43)
	.s ctloctype=$p($g(^CTLOC(loc)),"^",13)
	.q:ctloctype'["D"
	.s CTDesc=$p($g(^CTLOC(loc)),"^",2)
	.i CTDesc["-" s CTDesc=$p(CTDesc,"-",2)
	.q:$d(GetLocFrUserArr(loc))
	.s GetLocFrUserArr(loc)=""
	.i ret'="" s ret=ret_"^"_loc_$C(1)_CTDesc
	.e  s ret=loc_$C(1)_CTDesc
	q ret
}

ClassMethod GetMath()
{
  s ret=""
  s ret=1_$C(1)_"按照次序"_"^"_2_$C(1)_"按照工作量" 
  q ret
}

ClassMethod GetPerson(ctloc)
{
 s ret=""
 set myrowid=0
 for  s myrowid=$o(^SSU("SSUSR",myrowid)) q:myrowid=""  d
 .s ctloctype="",usecode="",usename="",useid=""
 .s tr=0,loc=""
 .s loc=+$p(^SSU("SSUSR",myrowid),"^",4)
 .i ctloc=loc s tr=tr+1
 .i tr=0  d
 ..	s othusr="0",th=0
 ..f  s othusr=$o(^SSU("SSUSR",myrowid,"OTHLL",othusr)) q:(othusr="")!(othusr="0")  d
   ...s othloc="",CTDesc=""
   ...s othloc=+$p(^SSU("SSUSR",myrowid,"OTHLL",othusr),"^",1)
   ...s ctloctype=""
   ...s ctloctype=$p(^CTLOC(othloc),"^",13)
   ...q:ctloctype'["D"
   ...q:othloc'=ctloc
   ...s tr=tr+1
 .q:tr=0
 .s usecode=$p(^SSU("SSUSR",myrowid),"^",1)
 .s usename=$p(^SSU("SSUSR",myrowid),"^",2)
 .s useid=myrowid
 .i ret=""  s ret=myrowid_$C(1)_usename
 .e  s ret=ret_"^"_myrowid_$C(1)_usename
 q ret
}

ClassMethod GetFyWin(ctloc)
{
 s ret=""
 s phl=""
 s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
 q:phl="" "" //lq
 s fywin=""
 f  s fywin=$o(^DHCPHWINi(phl,fywin)) q:fywin=""  d
   .s fydesc="",useflag=""
   .s fydesc=$p(^DHCPHWIN(fywin),"^",1)
   .s useflag=$p(^DHCPHWIN(fywin),"^",4)
   .q:useflag="1"
   .i ret'=""  s ret=ret_"^"_fywin_$c(1)_fydesc
   .e  s ret=fywin_$c(1)_fydesc
  q ret
}

ClassMethod GetPyWin(ctloc)
{
 s ret=""
 s phl=""
 s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
 q:phl="" //lq
 s pywin=""
 f  s pywin=$o(^DHCPHPYi("LOC",phl,pywin)) q:pywin=""  d
   .s pydesc="",useflag=""
   .s pydesc=$p(^DHCPHPY(pywin),"^",1)
   .i ret'=""  s ret=ret_"^"_pywin_$c(1)_pydesc
   .e  s ret=pywin_$c(1)_pydesc
  q ret
}

ClassMethod GetWinType()
{
 s ret=""
 s ret=1_$C(1)_"普通"_"^"_2_$C(1)_"特殊(毒麻精一)"_"^"_3_$C(1)_"日间"_"^"_4_$C(1)_"草药"
 q ret
}

ClassMethod GetSpecialMark()
{
 s ret=""
 s ret=1_$C(1)_"留观"_"^"_2_$C(1)_"体检"_"^"_3_$C(1)_"绿色通道"_"^"_4_$C(1)_"国际患者"
 q ret
}

ClassMethod InsertPyPrint(loc, pywin, printname, curflag, useflag)
{
	s ret=0
	s phl=$o(^DHCPHLOCi("LOC",loc,""))
	 i phl="" q -1
	i '$d(^DHCPYPRINTDEF(phl,pywin)) d
	.s ^DHCPYPRINTDEF(phl,pywin,1)=printname_"^"_curflag_"^"_useflag
	e  d
	 .s row=0,printrow=0,redefin=0
	 .f  s row=$o(^DHCPYPRINTDEF(phl,pywin,row)) q:(row="")!(row=0)  d
	 ..s printrow=row
	 ..s name=""
	 ..s name=$p(^DHCPYPRINTDEF(phl,pywin,row),"^",1)
	 ..i name=printname  s redefin=1
	 .i redefin'=0 s ret=-1
	 .q:redefin'=0
	 .s printrow=printrow+1
	 .s ^DHCPYPRINTDEF(phl,pywin,printrow)=printname_"^"_curflag_"^"_useflag
	q ret
}

ClassMethod UpdatePyPrint(loc, pywin, prowid, printname, curflag, useflag, oldphloc, oldpywin)
{

	i oldphloc="" q -1
	i oldpywin="" q -1
	i pywin="" q -1
	i prowid="" q -1
	s ret=0
	s phl=$o(^DHCPHLOCi("LOC",loc,""))
	i phl="" q -1
	s row=0,printrow=0,redefin=0
	f  s row=$o(^DHCPYPRINTDEF(phl,pywin,row)) q:(row="")!(row=0)  d
 	.s name=""
 	.q:row=prowid
	.s name=$p(^DHCPYPRINTDEF(phl,pywin,row),"^",1)
	.i name=printname  s redefin=1
	i redefin'=0 s ret=-1
	 e  d
	  .s tmpp=""
	  .f  s tmpp=$o(^DHCPYPRINTDEF(oldphloc,tmpp)) q:tmpp=""  d
	  ..q:tmpp'=oldpywin  
	  ..s tmpr=""
	  ..f  s tmpr=$o(^DHCPYPRINTDEF(oldphloc,tmpp,tmpr)) q:tmpr=""  d
	  ...i tmpr=prowid d
	  ....k ^DHCPYPRINTDEF(oldphloc,tmpp,tmpr)
	  .i $d(^DHCPYPRINTDEF(phl,pywin,prowid)) s prowid=$o(^DHCPYPRINTDEF(phl,pywin,""),-1)+1
	  .s ^DHCPYPRINTDEF(phl,pywin,prowid)=printname_"^"_curflag_"^"_useflag
	q ret
}

ClassMethod QueryPyPrintClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryPyPrintExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryPyPrintExecute(ByRef QHandle As %Binary, ctloc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    s ind=1

 	s phl=""
 	f  s phl=$o(^DHCPYPRINTDEF(phl)) q:phl=""  d
 	.q:'$d(^DHCPHLOC(phl))
 	.s tmploc=$p(^DHCPHLOC(phl),"^",1)
 	.q:(ctloc'="")&(ctloc'=tmploc)
 	.s ctlocdesc=$p(^CTLOC(tmploc),"^",2)
 	.i ctlocdesc["-" s ctlocdesc=$p(ctlocdesc,"-",2)
 	.s pywin="0"
 	.f  s pywin=$o(^DHCPYPRINTDEF(phl,pywin)) q:pywin=""  d
 	  ..s printrow=""
 	  ..s pywindesc=""
 	  ..s pywindesc=$p(^DHCPHPY(pywin),"^",1)
 	  ..f  s printrow=$o(^DHCPYPRINTDEF(phl,pywin,printrow)) q:printrow=""  d
 	  ...s printname="",curflag="",useflag=""
 	  ...s printname=$p(^DHCPYPRINTDEF(phl,pywin,printrow),"^",1)
 	  ...s curflag=$p(^DHCPYPRINTDEF(phl,pywin,printrow),"^",2)
 	  ...s useflag=$p(^DHCPYPRINTDEF(phl,pywin,printrow),"^",3)
 	  ...i curflag="1" s curflag="是"
 	  ...e  s curflag="否"
 	  ...i useflag="1" s useflag="是"
 	  ...e  s useflag="否"
 	  ...set Data=$lb(ctlocdesc,phl,pywindesc,pywin,printrow,printname,curflag,useflag)
      ...Set ^CacheTemp(repid,ind)=Data	
      ...Set ind=ind+1
 	Set QHandle=$lb(0,repid,0)
 	Quit $$$OK
}

ClassMethod QueryPyPrintFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPyPrintExecute ]
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

Query QueryPyPrint(ctloc As %String) As %Query(ROWSPEC = "TLocDesc:%String,TPhlid:%String,TPyWinDesc:%String,TPyWinID:%String,TPrintRowID:%String,TPrintName:%String,TCurrPrint:%String,TPrintCancel:%String") [ SqlProc ]
{
}

ClassMethod PersonTypeClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = PersonTypeExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod PersonTypeExecute(ByRef QHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	s ind=1
	set myrowid=0
	;^DHCPERSONTYPECODE
	s typerow=""
	f  s typerow=$o(^DHCPERSONTYPECODE(typerow)) q:typerow=""  d
	  .s typedesc="",useflag=""
	  .s typedesc=$p(^DHCPERSONTYPECODE(typerow),"^",1)
	  .s useflag=$p(^DHCPERSONTYPECODE(typerow),"^",2)
	  .i useflag="1" s useflag="是"
 	  .e  s useflag="否"
	  .set Data=$lb(typerow,typedesc,useflag)
 	  .Set ^CacheTemp(repid,ind)=Data	
 	  .Set ind=ind+1
	Set QHandle=$lb(0,repid,0)
 	Quit $$$OK
}

ClassMethod PersonTypeFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PersonTypeExecute ]
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

Query PersonType() As %Query(ROWSPEC = "TTypeID:%String,TTypeDesc:%String,TUseFlag:%String") [ SqlProc ]
{
}

ClassMethod QueryPhSendClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryPhSendExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryPhSendExecute(ByRef QHandle As %Binary, ctloc As %String, cinci As %String) As %Status
{

    Set repid=$I(^CacheTemp)
    i ctloc="" s ctloc=$g(%session.Data("LOGON.CTLOCID"))
	s ind=1
	s phsrow=""
	f  s phsrow=$o(^DHCPHSEND(phsrow)) q:phsrow=""  d
	  .s loc="",locdesc="",inc="",incdesc="",sendflag="",basqty=0
	  .s loc=+$p(^DHCPHSEND(phsrow),"^",1)
	  .q:loc'=ctloc
	  .s inc=+$p(^DHCPHSEND(phsrow),"^",2)
	  .q:(inc'=cinci)&(cinci'="")
	  .s locdesc=$p(^CTLOC(loc),"^",2)
	  .i locdesc["-" s locdesc=$p(locdesc,"-",2)
	  .s incdesc=$p(^INCI(inc,1),"^",2)
	  .s sendflag=$p(^DHCPHSEND(phsrow),"^",3)
	  .s basqty=+$p(^DHCPHSEND(phsrow),"^",6)
	  .s basuom="",puruom="",sendcon=1
	  .s basuom=+$p(^INCI(inc,1),"^",10)
	  .s puruom=+$p(^INCI(inc,3),"^",6)
	  .s sendcon=##class(web.DHCOutPhReturn).GetConFac(puruom,basuom)
	  .s sendqty=0
	  .s sendqty=basqty/sendcon
	  .s sendqty=$fn(sendqty,",",0)
	  .s puruomdesc=""
	  .s puruomdesc=$p(^CT("UOM",puruom),"^",2)
	  .i sendflag="1"  d
	  ..s sendflag="是"
	  .e  d
	  ..s sendflag="否"
	  .s Data=$lb(incdesc,inc,sendflag,locdesc,phsrow,sendqty,puruomdesc)
      .S ^CacheTemp(repid,ind)=Data	
      .S ind=ind+1
 S QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryPhSendFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPhSendExecute ]
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

Query QueryPhSend(ctloc As %String, cinci As %String) As %Query(ROWSPEC = "TPhDesc:%String,TInc:%String,TSendFlag:%String,TLocDesc:%String,TPhsRow:%String,TPhQty:%String,TPhUomDesc:%String")
{
}

ClassMethod InsertPhSend(ctloc As %String, inc As %String, send As %String)
{
  
  s phl="",mt=0
  //s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
  //i phl=""  q -1
  s phsrow=""
  f  s phsrow=$o(^DHCPHSENDi("INCI",inc,phsrow)) q:phsrow=""  d
    .s phsloc=""
    .s phsloc=+$p(^DHCPHSEND(phsrow),"^",1)
    .q:phsloc'=ctloc
    .s mt=mt+1
  i mt>0 q -99
  &sql(insert into sqluser.dhc_phsend(phs_inci_dr,phs_ctloc_dr,phs_sendflag) values(:inc,:ctloc,:send))
  q SQLCODE
}

ClassMethod UpdatePhSend(phsrow As %String, sendflag As %String)
{
 
  &sql(update sqluser.dhc_phsend set phs_sendflag=:sendflag where phs_rowid=:phsrow)
  q SQLCODE
}

ClassMethod QueryPrintKFClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryPrintKFExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryPrintKFExecute(ByRef QHandle As %Binary, ctloc As %String, YFID As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	if ctloc="" s ctloc=$g(%session.Data("LOGON.CTLOCID"))
 	i $g(ctloc)=""  Set QHandle=$lb(0,repid,0) Quit $$$OK
	s ind=1
	s locdesc=$p(^CTLOC(ctloc),"^",2)
	;^DHCPHPYBOX
	set yfcoderow="0"
	f  s yfcoderow=$o(^DHCGLobIntrLoc("LOC",ctloc,yfcoderow)) q:(yfcoderow="0")!(yfcoderow="")  d
	   .s intrdesc="",intr="",boxnum=0
	   .s intrdesc=$p(^DHCGLobIntrLoc("LOC",ctloc,yfcoderow),"^",1)
	   .s intr=$p(^DHCGLobIntrLoc("LOC",ctloc,yfcoderow),"^",2)
	   .q:(YFID'="")&&(YFID'=intr)
       .set Data=$lb(locdesc,intrdesc,intr,yfcoderow)
       .Set ^CacheTemp(repid,ind)=Data	
 	   .Set ind=ind+1
 	Set QHandle=$lb(0,repid,0)
 	
	Quit $$$OK
}

ClassMethod QueryPrintKFFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPrintKFExecute ]
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

Query QueryPrintKF(ctloc As %String, YFID As %String = "") As %Query(ROWSPEC = "TLocDesc:%String,TYFDesc:%String,TYFID:%String,yfcodeid") [ SqlProc ]
{
}

ClassMethod GetAllYF()
{
 s ret=""
 s phcrow="0"
 f  s phcrow=$o(^PHCIN(phcrow)) q:(phcrow="")!(phcrow="0")  d
   .s phcdesc=""
   .s phcdesc=$p(^PHCIN(phcrow),"^",2)
   .i ret'="" s ret=ret_"^"_phcrow_$C(1)_phcdesc
   .e  s ret=phcrow_$C(1)_phcdesc
  q ret
}

ClassMethod QueryYPYFClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryYPYFExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryYPYFExecute(ByRef QHandle As %Binary, CYFDesc) As %Status
{
 	Set repid=$I(^CacheTemp)
	s ind=1
	s phcrow="0"
    f  s phcrow=$o(^PHCIN(phcrow)) q:(phcrow="")!(phcrow="0")  d
       .s phcdesc=""
       .s phcdesc=$p(^PHCIN(phcrow),"^",2)
       .q:(CYFDesc'="")&&(phcdesc'[CYFDesc)
       .set Data=$lb(phcdesc,phcrow)
       .Set ^CacheTemp(repid,ind)=Data	
 	   .Set ind=ind+1
 	Set QHandle=$lb(0,repid,0)
 	
	Quit $$$OK
}

ClassMethod QueryYPYFFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryYPYFExecute ]
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

Query QueryYPYF(CYFDesc) As %Query(ROWSPEC = "用法:%String,用法ID:%String")
{
}

ClassMethod InsertDHCOutPrintKF(ctloc, intr, intrdesc)
{
	s row=0
	s checkintr=0
	s checkintr=..CheckIntrLoc(ctloc,intr)
	i checkintr'=0  q -1
	i $d(^DHCGLobIntrLoc("LOC",ctloc))  d
	  .s row=$o(^DHCGLobIntrLoc("LOC",ctloc,""),-1)
	e  s row=0
	s row=row+1
	s ^DHCGLobIntrLoc("LOC",ctloc,row)=intrdesc_"^"_intr
   q 0
}

ClassMethod CheckIntrLoc(ctloc, intr)
{
  s retval=0,phcrow=""
  f  s phcrow=$o(^DHCGLobIntrLoc("LOC",ctloc,phcrow)) q:phcrow=""  d
    .s phcintr=""
    .s phcintr=$p(^DHCGLobIntrLoc("LOC",ctloc,phcrow),"^",2)
    .q:phcintr'=intr
    .s retval=retval+1
  q retval
}

ClassMethod DeleteDHCOutPrintKF(ctloc, rowid)
{
	k ^DHCGLobIntrLoc("LOC",ctloc,rowid)
	q 0
}

ClassMethod KillOutPharmacy() As %String
{
	//-----------配置
	k ^DHCPHLOCi,^DHCPHLOC
	k ^DHCPHWINi,^DHCPHWIN
	k ^DHCPHPYi,^DHCPHPY
	k ^DHCPHPERi,^DHCPHPER
	k ^DHCPHCW,^DHCPHWPi,^DHCPHWP,^GLobDHCPHLOC
	//-----------业务
	//
	k ^DHCSTPHARMACY //(计数器)
	k ^DHCTMPPharmacyWin
	k ^DHCPHARW,^DHCPHARi,^DHCPHARWi
	k ^DHCPHDISPi,^DHCPHDISP,^DHCPHDI
	k ^DHCPHRETi,^DHCPHRET,^DHCPHRTIi,^DHCPHRTI
	k ^DHCPHSERIAL,^DHCPHSERIALi
	k ^DHCPHDAILYi,^DHCPHDAIL
	k ^DHCPHMONDEF,^DHCPHMON
	k ^DHCPHINPi,^DHCPHINP
	k ^DHCPHUNDi,^DHCPHUND
	k ^DHCPHUNRi,^DHCPHUNR
	k ^DHCPHREQ,^DHCPHREQi
	k ^DHCPHID,^DHCPHIDi
	k ^DHCPHWQU,^DHCPHWQUi
	k ^DHCPHOW,^DHCPHOWi
	k ^DHCPHOWEI
	k ^DHCPHCWS,^DHCPHCWSi
	k ^DHCPHWINL
	
	//-----------公用
	;k ^DHCOEDISQTY (如果住院已上过，则注释，用下面的delete)
	s flag1="F"
	s flag2="H"
	s flag3="S"
	s flag4="Z"
	&sql(delete from DHC_OEDispensing where DSP_Type=:flag1)
	&sql(delete from DHC_OEDispensing where DSP_Type=:flag2)
	&sql(delete from DHC_OEDispensing where DSP_Type=:flag3)
	&sql(delete from DHC_OEDispensing where DSP_Type=:flag4)
	
	q "OVER.."
}

/// 查询指定窗口科室集合
/// Creator:LiangQiang
/// CreatDate:2011-04-15
ClassMethod GetLocWinExecute(ByRef qHandle As %Binary, phwid) As %Status
{
	
    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1

    q:phwid="" $$$OK

    s phwchl="" 
    f  s phwchl=$o(^DHCPHWINL(phwid,"I",phwchl)) q:phwchl=""  d 
    .s ctlocdr=$p(^DHCPHWINL(phwid,"I",phwchl),"^",1)
    .s ctloc=$p(^CTLOC(ctlocdr),"^",2)
    .s rowid=phwid_"||"_phwchl
    .d OutRowtLocWin
	Quit $$$OK
OutRowtLocWin
	set Data=$lb(ctloc,rowid,ctlocdr)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetLocWinFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocWinExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish 
fetching
		Set AtEnd=1
		Set Row=""
	}
	Else {			
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetLocWin(phwid As %String) As %Query(ROWSPEC = "Tloc:%String,Trowid:%String,TLocId:%String")
{
}

ClassMethod GetLocWinClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocWinExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Description:维护增加科室窗口表
ClassMethod InsertPhwLoc(phwid, locdr) As %String
{
	 k PLIST
	 s sub=+$o(^DHCPHWINL(phwid,"I",""),-1)+1
	 s PLIST(0)=+$g(phwid)
	 s PLIST(4)=sub
	 s PLIST(5)=$g(locdr)
	 &sql(INSERT INTO DHC_PHWINLOC VALUES PLIST())
	 q:SQLCODE'=0 -1
	 q 0
}

/// Description:维护删除科室窗口表
ClassMethod DeletePhwLoc(phwid) As %String
{
	 &sql(Delete from  DHC_PHWINLOC where PHWL_RowId=:phwid)
	 q:SQLCODE'=0 -1
	 q 0
}

/// Description:获取科室配置是否自动配药打单
ClassMethod GetPhlAutoPyFlag(phl) As %String
{
	s autopyflag=$p($g(^DHCPHLOC(+phl)),"^",19)
	q autopyflag
}

/// Description:获取科室配置是否需要配药确认
ClassMethod GetPhlPySureFlag(phl) As %String
{
	s pysureflag=$p($g(^DHCPHLOC(+phl)),"^",18)
	q pysureflag
}

/// creator:yunhaibao
/// createdate:20160427
/// description:获取门诊药房科室配置
ClassMethod GetPhLocConfig(ctloc)
{
	s ret="",phl="",tjflag="",cyflag=""
	s phl=$o(^DHCPHLOCi("LOC",ctloc,"")) 
	i phl=""  s ret="^"
	e  d
	.s tjflag=$p(^DHCPHLOC(phl),"^",5) //提前摆药
	.s cyflag=$p(^DHCPHLOC(phl),"^",6) //草药
	.s ret=tjflag_"^"_cyflag
	q ret
}

/// w ##class(%ResultSet).RunQuery("web.DHCOutPhCode","GetFyWinDict",100)
Query GetFyWinDict(ctloc) As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetFyWinDictExecute(ByRef qHandle As %Binary, ctloc = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:ctloc="" $$$OK
    s fyWinStr = ..GetFyWin(ctloc)
    s len=$l(fyWinStr,"^")
	f index=1:1:len d
	.s fyWin=$p(fyWinStr,"^",index)
	.s fyWinId=$p(fyWin,$c(1),1)
	.s fyWinDesc=$p(fyWin,$c(1),2)
	.d outputRow
	Quit $$$OK
outputRow  
	s Data=$lb(fyWinId,fyWinDesc)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

}
