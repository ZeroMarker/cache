Import sqluser

Class web.DHCOutPhAddBaseMed Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod QueryLocBaseMedClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryLocBaseMedExecute ]
{

	 Set repid=$li(QHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod QueryLocBaseMedExecute(ByRef QHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	s ind=1
	
	s phbr=""
	f  s phbr=$o(^DHCPHBMED(phbr)) q:phbr=""  d
	.s arc=$p(^DHCPHBMED(phbr),"^",1)
	.s arcitm=$p(^ARCIM($p(arc,"||",1),$p(arc,"||",2),1),"^",2)
	.s inst=""
	.s instdr=$p(^DHCPHBMED(phbr),"^",2)
	.s:instdr'="" inst=$p(^PHCIN(instdr),"^",2)
	.s doclocdr=$p(^DHCPHBMED(phbr),"^",3)
	.s docloc=$p(^CTLOC(doclocdr),"^",2)
	.s uselocdr=$p(^DHCPHBMED(phbr),"^",4)
	.s useloc=$p(^CTLOC(uselocdr),"^",2)
	.s note=$p(^DHCPHBMED(phbr),"^",5)
	.s inci=$o(^INCI(0,"ARCIM_DR",+arc,""))
 	.Do OutputLocRow
 	
 	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputLocRow
	set Data=$lb(arcitm,inst,docloc,useloc,phbr,note,instdr,doclocdr,uselocdr,arc,inci)
 	Set ^CacheTemp(repid,ind)=Data	
 	Set ind=ind+1
	quit
}

ClassMethod QueryLocBaseMedFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocBaseMedExecute ]
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

Query QueryLocBaseMed() As %Query(ROWSPEC = "Tarcitm:%String,Tinst:%String,Tdocloc:%String,Tuseloc:%String,Tphbr:%String,Tnote:%String,Tinstrowid:%String,Tdoclocdr:%String,Tuselocdr:%String,Tarcdr:%String,Tinci:%String") [ SqlProc ]
{
}

ClassMethod AddBaseMed(arc, instdr, doclocdr, uselocdr, note)
{
  q:..ChkPhbmExist(arc,instdr,doclocdr,uselocdr)=1 0
  k PLIST
  s PLIST(2)=arc
  s PLIST(3)=instdr
  s PLIST(4)=doclocdr
  s PLIST(5)=uselocdr
  s PLIST(6)=note
  &sql(INSERT INTO DHC_PHBaseMedicine VALUES :PLIST())
  q:SQLCODE -1
  q +$g(%ROWID)
}

ClassMethod DelBaseMed(phbr)
{
  
  &sql(delete from DHC_PHBaseMedicine where  PHB_Rowid=:phbr)
  q:SQLCODE -1
  q 0
}

/// w ##class(web.DHCOutPhAddBaseMed).UpdBaseMed(20,1366,2,64,64,"HQLTest223")
ClassMethod UpdBaseMed(phbr, arc, inst, doclocdr, uselocdr, note)
{
   //s ^yunhaibao("update")=phbr_","_inci_","_inst_","_doclocdr_","_uselocdr_","_note
   s parcitm=$p(^DHCPHBMED(phbr),"^",1)
   s pinstdr=$p(^DHCPHBMED(phbr),"^",2)
   s pdoclocdr=$p(^DHCPHBMED(phbr),"^",3)
   s puselocdr=$p(^DHCPHBMED(phbr),"^",4)
   s pnote=$p(^DHCPHBMED(phbr),"^",5)
   s parcitm=arc
   s pinstdr=inst
   i doclocdr'="" s pdoclocdr=doclocdr
   i uselocdr'="" s puselocdr=uselocdr
   s pnote=note
   q:..ChkPhbmExist(parcitm,pinstdr,pdoclocdr,puselocdr,phbr)=1 -2
   &sql(update DHC_PHBaseMedicine set PHB_ArcItm_Dr=:parcitm,PHB_Instruc_Dr=:pinstdr, PHB_DocLoc_Dr=:pdoclocdr,PHB_UseLoc_Dr=:puselocdr,PHB_Note=:pnote where PHB_Rowid=:phbr )
   q:SQLCODE -1
   q 0
}

/// 检查某科室基数药是否存在
/// Output: 0 不符条件  , 1 符合条件
ClassMethod ChkPhbmExist(arc, instdr, doclocdr, uselocdr, phbrowid = "")
{
	q:doclocdr="" 0
	s ret=0
	s phbr=""
	f  s phbr=$o(^DHCPHBMEDI(0,"ArcLoc",arc,doclocdr,phbr)) q:(phbr="")||(ret=1)  d
	.q:(phbrowid'="")&&(phbrowid=phbr)
	.s pinstdr=$p(^DHCPHBMED(phbr),"^",2)
	.i pinstdr=instdr d
	..s ret=1
	.s puselocdr=$p(^DHCPHBMED(phbr),"^",4)
	.i puselocdr=uselocdr d
	..s ret=1
	q ret
}

/// 获取基数科室使用集合
ClassMethod GetPhbLocDs1()
{
	k ^TMP("dhcpha","DHCOutPhAddBaseMed","ChkPhbLocs",$j)
	s ret=0
	s phbr=""
	f  s phbr=$o(^DHCPHBMED(phbr)) q:(phbr="")  d
	.s puselocdr=$p(^DHCPHBMED(phbr),"^",4)
	.s ^TMP("dhcpha","DHCOutPhAddBaseMed","ChkPhbLocs",$j,puselocdr)=""
	s retString=""
	s locdr=""
	f  s locdr=$o(^TMP("dhcpha","DHCOutPhAddBaseMed","ChkPhbLocs",$j,locdr)) q:locdr=""  d
	.s locdesc=$p(^CTLOC(locdr),"^",2)
	.s ret=locdr_$C(1)_locdesc
	.i retString="" d
    ..s retString=ret
    .e  d
    ..s retString=ret_"^"_retString
    .
    k ^TMP("dhcpha","DHCOutPhAddBaseMed","ChkPhbLocs",$j)
    q retString
}

/// 获取基数科室使用集合 
/// LiangQiang
/// w ##class(%ResultSet).RunQuery("web.DHCOutPhAddBaseMed","GetPhbLocDs","")
Query GetPhbLocDs(inputs As %String, PHBType = "O") As %SQLQuery(CONTAINID = 1)
{
     SELECT distinct PHB_UseLoc_Dr->CTLOC_Desc,PHB_UseLoc_Dr FROM DHC_PHBaseMedicine 
     where PHB_Type=:PHBType and ((%ALPHAUP(PHB_UseLoc_Dr->CTLOC_Desc) %STARTSWITH %ALPHAUP(:inputs))
     or	(%ALPHAUP(PHB_UseLoc_Dr->CTLOC_ContactName) %STARTSWITH %ALPHAUP(:inputs)))
}

/// creator:yunhaibao
/// createdate:20160623
/// description:门诊基数药记录
/// w ##class(web.DHCOutPhAddBaseMed).jsQueryLocBaseMed(1,1)
ClassMethod jsQueryLocBaseMed(page, rows)
{
	s stpage=((page-1)*rows)+1 //开始行
	s endpage=page*rows  //结束行
	s pid=..NewPid()
    s $zt="ErrorjsQueryLocBaseMed"
    s result=##class(%Library.ResultSet).%New("web.DHCOutPhAddBaseMed:QueryLocBaseMed")
	s sc=result.Execute()
	i $$$ISERR(sc) q ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s colNum=result.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.i colNameStr="" s colNameStr=result.GetColumnName(i)
	.e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
	s countrecords=0
	While(result.Next())
	{ 
		s ret=""
		f i=1:1:colNum d
		.s retvalue=result.%GetData(i)
		.i ret="" s ret=retvalue
		.e   s ret=ret_"^"_retvalue
		s countrecords=countrecords+1  //可做索引用
		s ^TMP("DHCST","web.DHCOutPhAddBaseMed","jsQueryLocBaseMed",pid,countrecords)=ret
	}
	q:countrecords="0" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	i endpage>countrecords s endpage=countrecords
	s count=0
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","web.DHCOutPhAddBaseMed","jsQueryLocBaseMed",pid,outputi)) q:outputi=""  d
	.s outputdata=^TMP("DHCST","web.DHCOutPhAddBaseMed","jsQueryLocBaseMed",pid,outputi)
	.s count=count+1
	.q:count<stpage
    .q:count>endpage
	.I count=stpage d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(countrecords)
	..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.e  d
	..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.i count=endpage w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	k ^TMP("DHCST","web.DHCOutPhAddBaseMed","jsQueryLocBaseMed",pid)
	q ""
ErrorjsQueryLocBaseMed
	k ^TMP("DHCST","web.DHCOutPhAddBaseMed","jsQueryLocBaseMed",pid)
	s Error=$$Error^DHCSTERROR()
	q Error
}

ClassMethod NewPid()
{
	q ##class(web.DHCSTKUTIL).NewPid($ClassName(),"OP")
}

}
