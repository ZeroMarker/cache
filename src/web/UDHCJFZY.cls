Import SQLUser

Class web.UDHCJFZY Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 7;

ClassMethod SaveWarrant(itmjs As %Library.String = "", itmjsex As %Library.String = "", val1 As %Library.String = "")
{
 ;s p1=bill+"^"+user+"^"+loc+"^"+tmpdep+"^"+depflag+"^"+pay+"^"+adm+"^"+computername
 s adm=$p(val1,"&",1),d1=$p(val1,"&",2),d2=$p(val1,"&",3),WarrName=$p(val1,"&",4),WarrAmt=$p(val1,"&",5),WarrStatus=$p(val1,"&",6),memo=$p(val1,"&",7),userid=$p(val1,"&",8)
 s err=..SaveWarrant0(adm, d1, d2, WarrName, WarrAmt, WarrStatus, memo, userid)
 ;s retval=itmjs_"('"_$ZCVT(str,"O","JS")_"');"
 ;i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(str,"O","JS")_"');"
 ;&javascript<#(retval)#>
 q err
}

ClassMethod SaveWarrant0(adm, d1, d2, WarrName, WarrAmt, WarrStatus, memo, userid)
{
	 ;k (adm,d1,d2,WarrName,WarrAmt,WarrStatus,memo,userid)
	 k PLIST
	 s WarrAmt=$g(WarrAmt)
	 s PLIST(2)=$g(adm)
	 s PLIST(3)=$g(userid)
	 s PLIST(4)=+WarrAmt
	 s PLIST(5)=$zdh(d1,4)
	 s PLIST(6)=$zdh(d2,4)
	 s PLIST(7)=$g(WarrStatus)
	 s PLIST(9)=$g(WarrName)
	 s PLIST(10)=$g(memo)
	 &sql(insert into DHC_WARRANT values PLIST())
	 q SQLCODE
}

ClassMethod AAClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AAExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod AAExecute(ByRef qHandle As %Binary, startdate As %String, enddate As %String, Adm As %String, warrantor As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	//i Adm="" Set qHandle=$lb(0,repid,0) Quit $$$OK
 	If $g(ind)="" Set ind=1
	;n (d1,d2,adm,warrantor)
	; k ^TMP("ZYJF",$j)
	; s d1=$zdh(d1,3)
	; s d2=$zdh(d2,3)
	 s adm=$g(Adm)
	 s warrantor=$g(warrantor)
	 ;s num=0
	 f d=startdate:1:enddate d
	 . s wdr=""
	 . f  s wdr=$o(^DHCWARRANT(0,"DATA",d,wdr)) q:wdr=""  d
	 . . s ss=^DHCWARRANT(wdr)
	 . . s admdr=$p(ss,"^",1)
	 . . q:'$d(^PAADM(admdr))
	 . . q:(adm'="")&(adm'=admdr)
	 . . s wrrantname=$p(ss,"^",9)
	 . . q:(warrantor'="")&(warrantor'=wrrantname)
	 . . s amt=$p(ss,"^",2)
	 . . s wd=$p(ss,"^",3)
	 . . s lwd=$p(ss,"^",4)
	 . . s userid=$p(ss,"^",7)
	 . . s userid=$g(userid)
	 . . s status=$p(ss,"^",8)
	 . . i status="Y" s stat="有效" e  s stat="无效"  
	 . . s memo=$p(ss,"^",10)
	 . . s username=""
	 . . i userid'="" s username=$p(^SSU("SSUSR",userid),"^",1)
	 . . i admdr'="" s patmidr=$p(^PAADM(admdr),"^",1)         ; pa_adm 中的 paadm_papmi_dr
	 . . i patmidr'=""&$d(^PAPER(patmidr,"ALL")) s patname=$p(^PAPER(patmidr,"ALL"),"^",1)   ; 患者姓名
	 . . s wd=$zd(wd,3),amt=$j(amt,3,2),lwd=$zd(lwd,3)
	 . . d OutputRow4
	 . . ;s ^TMP("ZYJF",$j,num)=$zd(wd,3)_"^"_wrrantname_"^"_patname_"^"_$j(amt,3,2)_"^"_$zd(lwd,3)_"^"_stat_"^"_memo_"^"_username_"^"_admdr_"^"_userid_"^"_wdr
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow4
	set Data=$lb(wd,wrrantname,patname,amt,lwd,stat,memo,username)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod AAFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AAExecute ]
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

Query AA(startdate As %String, enddate As %String, Adm As %String, warrantor As %String) As %Query(ROWSPEC = "Tstartdate:%String,Twarrantor:%String,Tpatname:%String,Tmoney:%String,Tenddate:%String,Tstatus:%String,Tremark:%String,Tuser:%String")
{
}

}
