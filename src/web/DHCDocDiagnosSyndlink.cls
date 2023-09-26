Import SQLUser

Class web.DHCDocDiagnosSyndlink Extends %RegisteredObject
{

/// d ##Class(web.DHCDocDiagnosSyndlink).SignSymptomlistDesc()
ClassMethod SignSymptomlistDesc() As %String
{
 s rowid="0" ,OutStr=""
 f  s rowid=$o(^MRC("DSYM",rowid))  q:rowid=""  d
 .s TDSYMCode=$p(^MRC("DSYM",rowid),"^",1)
 .s TDSYMDesc =$p(^MRC("DSYM",rowid),"^",2)
 .s DSYMDateFrom=$zd($p(^MRC("DSYM",rowid),"^",5),4)
 .s DSYMDateTo=$p(^MRC("DSYM",rowid),"^",6)
 .//s DSYMDateTo=$zd($p(^MRC("DSYM",rowid),"^",6),4)
 .i $g(DSYMDateTo)="" s DSYMDateTo=""
 .i $g(DSYMDateTo)'="" s DSYMDateTo=$zd(DSYMDateTo,4)
 .s DSYMActiveInActive=$p(^MRC("DSYM",rowid),"^",7)
 .q:DSYMActiveInActive'="Y"
 .s TDSYMCTLOCDR=$p(^MRC("DSYM",rowid),"^",3)
 .s SyndStr=rowid_"^"_TDSYMDesc
 .s OutStr=OutStr_"|"_SyndStr
 q OutStr
}

/// w ##Class(web.DHCDocDiagnosSyndlink).LookUpBrokerWithAlias()
ClassMethod LookUpBrokerWithAlias(itmjs As %Library.String = "") As %String
{

	s desc=""
	s n=0
	Set rset=##Class(%ResultSet).%New("web.DHCMRDiagnos:LookUpWithAlias")
	If rset.QueryIsValid() { 
		Set Status=rset.Execute("","","")
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		While (rset.Next()) {
			set ret=""
		    For col = 1:1:columns {
			   i ret="" s ret=rset.GetData(col)
		       e  s ret= ret_"^"_rset.GetData(col)
		    }
		    
	       s n=n+1
	       i (ret'="") {
		   		s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
				&javascript<#(retval)#>
	       }
		}
		d rset.Close()
	}
	Q n
}

/// w ##Class(web.DHCDocDiagnosSyndlink).InsertDiagnosSyndLinkMethod("1^3$4")
ClassMethod InsertDiagnosSyndLinkMethod(PutStr As %Library.String = "") As %String
{
	;n (PutStr)
	s ^songsong("InsertDiagnosSyndLinkMethod")=PutStr
	s ItemDiagnos=$p(PutStr,"^",1)
	s ItemSynd=$p(PutStr,"^",2)
	s i=0
	s ICDlen=$LENGTH(ItemDiagnos,"$")
	s Syndlen=$LENGTH(ItemSynd,"$")

	For i = 1:1:ICDlen
	{
		S ItemDiagnoId=$p(ItemDiagnos,"$",i)
		s SyndlinkRowid=""
		
		For j = 1:1:Syndlen
		{
			k PLIST
			s PLIST(2)=ItemDiagnoId
			s PLIST(3)=$p(ItemSynd,"$",j)
			s SyndlinkRowid="",SQLCODE="",flag1="-1"
			f  s SyndlinkRowid=$o(^DHCDocSyndLink("0","MRCICDDX",ItemDiagnoId,SyndlinkRowid)) q:(SyndlinkRowid="")!(flag1="0")  d
			.s SyndRowid=$p(^DHCDocSyndLink(SyndlinkRowid),"^",1)
			.s ICDRowid=$p(^DHCDocSyndLink(SyndlinkRowid),"^",2)
			.i (PLIST(2)=ICDRowid)&&(PLIST(3)=SyndRowid)  d    ;相同的对照关系，不保存
			..s flag1="0"
			
			i flag1="-1" d
			.&sql(insert into DHCDocSyndlink values :PLIST())
			.s SQLCODE="1"
			e  s SQLCODE="0"
					
			}
		}
		q:flag1="0" "-1"
		s flag=$p(%ROWID,$c(1))
		
		q flag
}

ClassMethod DeleteDiagnosSyndLinkMethod(PutStr As %Library.String = "") As %String
{

	s ItemDiagnos=$p(PutStr,"^",1)
	s ItemSynd=$p(PutStr,"^",2)
	&sql(delete from SQLUser.DHCDocSyndlink where syndrome_MRCICDDR=:ItemDiagnos and syndrome_MRCDiaSymptomDr=:ItemSynd)
	q SQLCODE
	//s flag=$p(%ROWID,$c(1))
	//q flag
}

ClassMethod GetDiagnosSyndLinkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiagnosSyndLinkExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// W ##class(%ResultSet).RunQuery("web.DHCDocDiagnosSyndlink","GetDiagnosSyndLink")
ClassMethod GetDiagnosSyndLinkExecute(ByRef qHandle As %Binary, SearchItem As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s SyndlinkRowid="0"
	f  s SyndlinkRowid=$o(^DHCDocSyndLink(SyndlinkRowid))  q:SyndlinkRowid=""  d
	.s ICDDr=$p(^DHCDocSyndLink(SyndlinkRowid),"^",2)
	.i ICDDr'=""  d
	..s ICDDesc=$p(^MRC("ID",ICDDr),"^",2)
	.s SyndRowid=$p(^DHCDocSyndLink(SyndlinkRowid),"^",1)
	.i SyndRowid'=""  d
	..s SyndDesc="" 
	..s SyndDesc=$p($g(^MRC("DSYM",SyndRowid)),"^",2)
	.s data=ICDDesc_"^"_SyndDesc
	.q:(data'[SearchItem)&(SearchItem'="")
	.d BuildCont1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildCont1      
	set Data=$lb(ICDDr,ICDDesc,SyndRowid,SyndDesc)  
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GetDiagnosSyndLinkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDiagnosSyndLinkExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetDiagnosSyndLink(SearchItem As %String) As %Query(ROWSPEC = "ICDDr:%String,ICDDesc:%String,SyndRowid:%String,SyndDesc:%String")
{
}

ClassMethod GetSyndList(DiagnosRowid As %String) As %String
{
	s SyndList=""
	s SyndlinkRowid="0",SyndDesc=""
	s ICDCodeDR=$p(^MR(+DiagnosRowid,"DIA",$p(DiagnosRowid,"||",2)),"^",1)
	f  s SyndlinkRowid=$o(^DHCDocSyndLink(0,"MRCICDDX",ICDCodeDR,SyndlinkRowid)) q:SyndlinkRowid=""  d   
	.s SyndRowid=$p(^DHCDocSyndLink(SyndlinkRowid),"^",1) 
	.i SyndRowid'=""  d
	..s SyndDesc=$p($g(^MRC("DSYM",SyndRowid)),"^",2)
	..s SyndList=SyndList_"|"_SyndDesc_"^"_SyndRowid
	Q:SyndList="" ""
	Q SyndList
}

/// w ##Class(web.DHCDocDiagnosSyndlink).InsertSyndLink("2","12821||2")
ClassMethod InsertSyndLink(NewSyndRowid, DiagnosRowid) As %String
{
	Q:(NewSyndRowid="")||(DiagnosRowid="")
	s SyndRowid="0"
	s err="0"
	s SyndRowid=$o(^DHCDocSYND("0","Diagnos",DiagnosRowid,SyndRowid))  d
	.s err=..UpdateSyndLink(SyndRowid,DiagnosRowid,NewSyndRowid)
	i (err)
	{
	s PLIST(3)=DiagnosRowid
	s PLIST(5)=NewSyndRowid
	&sql(insert into DHC_DocSyndDiff values PLIST())    
	q:SQLCODE SQLCODE
	s flag=$p(%ROWID,$c(1))
	q flag
		}
	Q ""
}

ClassMethod UpdateSyndLink(SyndRowid As %String, DiagnosRowid As %String, NewSyndRowid As %String) As %String
{

	//&sql(Update SQLUser.DHC_DocSyndDiff set Synd_Sign1=:NewSyndRowid where Synd_Rowid=:SyndRowid)
	//Q SQLCODE
}

}
