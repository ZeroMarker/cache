Import SQLUser

Class web.UDHCJFInvprtNew Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 97;

ClassMethod DocListBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
 ;n id,code,desc
 ;
 Set (id,code,desc)=""
 ;
 Set rs=##Class(%ResultSet).%New("web.DHCOPAdm:OPDocList")
 Set Status=0
 If rs.QueryIsValid() {
	 Set Status=rs.Execute(val)
	 If 'Status Quit
	 While rs.Next() {
		 Set DocCode=rs.Data("Code")
		 Set DocDesc=rs.Data("Desc")
		 If desc="" Set desc=DocCode_$c(1)_DocDesc
		 Else  Set desc=desc_"^"_DocCode_$c(1)_DocDesc
	 }
 }
 ;
 Set SQLCODE=0
 ;
 i SQLCODE s desc=val q 0
 s retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(desc,"O","JS")_"^"_id_"^"_$ZCVT(code,"O","JS")_"');"
 &javascript<#(retval)#>
 q 1
}

ClassMethod GetEncrypt(Method As %String)
{
	s encmeth=##Class(websys.Page).Encrypt($lb(Method))
	Quit encmeth
}

ClassMethod GetPatDetailBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
 ;n id,code,desc
 ;
 Set (id,code,desc)=""
 ;
 Set PatDr=$o(^PAPERi("PAPMI_PatNo",$ZCVT(val,"U"),""))
 If PatDr="" {
	Set SQLCODE=1
	Set desc=val
	Quit 0
 }  Else {
	Set Name=$p(^PAPER(PatDr,"ALL"),"^",1)
    set RIDCardNo=$p($g(^PAPER(PatDr,"ALL")),"^",9)
	Set Age=+$p(^PAPER(PatDr,"ALL"),"^",6)
	Set Age=$p(((+$H-Age)/365)+0.5,".")
	Set Sex=$p(^CT("SEX",$p(^PAPER(PatDr,"ALL"),"^",7)),"^",2)
	Set OPMRN=$p(^PAPER(PatDr,"PER",4),"^",4)
	Set IPMRN=$p(^PAPER(PatDr,"PAT",1),"^",22)
	set RAddress=$p(^PAPER(PatDr,"PER",4),"^",18) 
	Set PatCat=""
	Set PatCatDr=$p(^PAPER(PatDr,"PER",1),"^",10)
	If PatCatDr'="" Set PatCat=$p(^CT("SS",PatCatDr),"^",1)_"."_$p(^CT("SS",PatCatDr),"^",2)
	Set desc=Name_"^"_Age_"^"_Sex_"^"_OPMRN_"^"_IPMRN_"^"_PatCat_"^"_PatDr_"^"_RIDCardNo_"^"_RAddress
	Set SQLCODE=0
 }
 ;
 i SQLCODE s desc=val q 0
 s retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(desc,"O","JS")_"^"_id_"^"_$ZCVT(code,"O","JS")_"');"
 &javascript<#(retval)#>
 q 1
}

/// /////////////////////////////////////////
ClassMethod InvprtBuyListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = InvprtBuyListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod InvprtBuyListExecute(ByRef qHandle As %Binary, type As %String) As %Status
{
 	//
 	Set repid=$I(^CacheTemp)
 	//
 	if $G(type)="" Set qHandle=$lb(0,repid,0) quit $$$OK	;s type="I"
	If $g(ind)="" Set ind=1
	Set RowId=""
	f  s RowId=$o(^DHCAMTMAG(0,"L",type,RowId)) q:RowId=""  d
	.s btype=$p(^DHCAMTMAG(RowId),"^",2)
	.q:(type'="")&(type'=btype)
	.s RowId0=RowId
	.s bdate=$p(^DHCAMTMAG(RowId),"^",1)
	.i bdate'="" s bdate=$ZD(bdate,3)
	.s bstartno=$p(^DHCAMTMAG(RowId),"^",5)
	.s bendno=$p(^DHCAMTMAG(RowId),"^",6)
	.s bbuyer=$p(^DHCAMTMAG(RowId),"^",3)
	.i bbuyer'=""  s bbuyer=$p(^SSU("SSUSR",bbuyer),"^",2)
	.s bcurrent=$p(^DHCAMTMAG(RowId),"^",10)
	.s bflag=$p(^DHCAMTMAG(RowId),"^",9)
	.i bflag="Y"  s bflag="可用"
	.i bflag="N"  s bflag="已用完"
	.i bflag=""  s bflag="待用"
	.i btype="I"  s btype="InPatient"
	.i btype="O"  s btype="OutPatient"
	.i btype="E"  s btype="Emergency"
	.Do OutputRow1
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow1
	set Data=$lb(RowId0,bdate,bstartno,bendno,bbuyer,bcurrent,bflag,btype)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod InvprtBuyListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = InvprtBuyListExecute ]
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

Query InvprtBuyList(type As %String) As %Query(ROWSPEC = "TRowid:%String,TDate:%String,TStartno:%String,TEndno:%String,TBuyer:%String,TCurrentno:%String,TFlag:%String,TType:%String")
{
}

// insert 2005.7.22   by cx////////////////////////////////////////////////////////////////////////////////////////////////

ClassMethod InvprtdeliverClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = InvprtdeliverExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod InvprtdeliverExecute(ByRef qHandle As %Binary, guser As %String, type As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	
 	//Set guser="1"
 	if $G(guser)="" Set qHandle=$lb(0,repid,0) quit $$$OK	;s type="I"
    if $G(type)="" Set qHandle=$lb(0,repid,0) quit $$$OK
    Set ind=1
	Set RowId=""
	f  s RowId=$o(^DHCINVOICE(0,"USER",guser,RowId)) q:RowId=""  d
	.s bflag=$p(^DHCINVOICE(RowId),"^",7)
	.;q:(bflag="Y")
	.s RowId0=RowId
	.s num=1,receipt=RowId
	.s bdate=$p(^DHCINVOICE(RowId),"^",4)
	.i bdate'="" s bdate=$ZD(bdate,3)
	.s btime=$p(^DHCINVOICE(RowId),"^",5)
	.i btime'="" s btime=$ZT(btime,1)
	.s bstartno=$p(^DHCINVOICE(RowId),"^",1)
	.s bendno=$p(^DHCINVOICE(RowId),"^",2)
	.s bcurrent=$p(^DHCINVOICE(RowId),"^",6)
	.s btype=$p(^DHCINVOICE(RowId),"^",8)
	.q:(type'="")&(type'=btype)
	.i btype="I" s btype="住院"
	.i btype="O" s btype="门诊"
	.i btype="E" s btype="挂号"
	.i bflag="Y" s bstatus="可用"
	.i bflag="N" s bstatus="已用完"
	.i bflag=""  s bstatus="待用"
	.s busername=$p(^SSU("SSUSR",guser),"^",2)	
	.Do OutputRow	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow
   	set Data=$lb(bdate,btime,bstartno,bendno,bcurrent,btype,bstatus,RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod InvprtdeliverFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = InvprtdeliverExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query Invprtdeliver(guser As %String, type As %String) As %Query(ROWSPEC = "Tdate:%String,Ttime:%String,Tstartno:%String,Tendno:%String,Tcurrentno:%String,Ttype:%String,Tstatus:%String,Trowid:%String")
{
}

ClassMethod Getkydeliver(itmjs As %Library.String = "", itmjsex As %Library.String = "", guser As %Library.String = "")
{
	s str=""
	s curno="",endno="",invtype="",invrowid=""
	&sql(select inv_rowid,INV_LastNum,INV_EndInv,INV_type into:invrowid,:curno,:endno,:invtype from dhc_invoice where INV_Finalflag='Y' and INV_Usr=:guser)
	s str=curno_"^"_endno_"^"_invtype_"^"_invrowid	
	s retval=itmjs_"('"_$ZCVT(str,"O","JS")_"');"
    i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(str,"O","JS")_"');"
    &javascript<#(retval)#>
    q 0
}

ClassMethod Getkydeliverbak(itmjs As %Library.String = "", itmjsex As %Library.String = "", guser As %Library.String = "", invtype As %Library.String = "")
{
	s str=""
	s curno="",endno="",invrowid=""
	;&sql(select inv_rowid,INV_LastNum,INV_EndInv into:invrowid,:curno,:endno from dhc_invoice where INV_Finalflag='Y' and  INV_type<>:invtype and INV_Usr=:guser )
	s count=0
	s rowid=""
	f  s rowid=$o(^DHCINVOICE(0,"USER",guser,rowid))  q:(rowid="")!(count>0)  d
	.s curtype=$p(^DHCINVOICE(rowid),"^",8)
	.q:(invtype="")
	.q:(invtype'="")&(invtype'=curtype)
	.s finalflag=$p(^DHCINVOICE(rowid),"^",7)
	.q:(finalflag'="Y")
	.s count=1
	.s curno=$p(^DHCINVOICE(rowid),"^",6)
	.s endno=$p(^DHCINVOICE(rowid),"^",2)
	.s invrowid=rowid
	s str=curno_"^"_endno_"^"_invtype_"^"_invrowid	
	s retval=itmjs_"('"_$ZCVT(str,"O","JS")_"');"
    i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(str,"O","JS")_"');"
    &javascript<#(retval)#>
    q 0
}

ClassMethod deliverinv(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
 k PLIST
 s str=val 
 k PLIST(1)
 s PLIST(2)=$p(str,"^",2)
 s PLIST(3)=$p(str,"^",3)
 s PLIST(4)=$p(str,"^",4)
 s lquser=PLIST(4)
 s PLIST(5)=+$h
 s PLIST(6)=$p($h,",",2)
 s PLIST(7)=PLIST(2)
 s invtype=$p(str,"^",7)
 s userno=$p(str,"^",8)
 s cw=..invcw(PLIST(4),invtype) 
 i cw>0 d
 .s PLIST(8)=""
 e  d
 .s PLIST(8)="Y"
 s PLIST(9)=invtype 
 s PLIST(10)="N" 
 s buyend=$p(str,"^",5)
 s invid=$p(str,"^",6)
 s lqenno=PLIST(3) 
 s PLIST(16)=invid
 TSTART
 &sql(INSERT INTO SQLUser.DHC_invoice Values PLIST())
 i SQLCODE=0  d
 .s retcode=0 
 .i lqenno'=buyend d 
 ..s err=..deliverinvupdate(lqenno,invid)
 .s retcode=retcode+SQLCODE
 .i lqenno=buyend d 
 ..s err1=..deliverinvrefund(userno,invid,invtype)
 .s retcode=retcode+SQLCODE
 e  d
 .s retcode=100
 i retcode=0  d
 .TCOMMIT
 e  d
 .TROLLBACK
 s retval=itmjs_"('"_$ZCVT(retcode,"O","JS")_"');"
 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(retcode,"O","JS")_"');"
 &javascript<#(retval)#>
 q 1
}

ClassMethod deliverinvrefund(userid As %String, invid As %Integer, invtype As %String) As %String
{
 &sql(update SQLUser.dhc_invoice set INV_Finalflag='N' where inv_rowid=:invid)
 &sql(select count(*) into :num from SQLUser.dhc_invoice where (INV_Finalflag="" or INV_Finalflag is null) and INV_Usr=:userid and INV_type=:invtype)
 i num'=0  d 
 .&sql(select min(inv_rowid) into :rowid1  from SQLUser.dhc_invoice where (INV_Finalflag="" or INV_Finalflag is null) and INV_Usr=:userid and INV_type=:invtype)
 .&sql(update SQLUser.dhc_invoice set INV_Finalflag='Y' where inv_rowid=:rowid1)
 q SQLCODE
}

ClassMethod deliverinvupdate(endno As %String, invid As %Integer) As %String
{
  ;修改住院处领取收据的结束编号?将当前编号改为结束编号
  s endno=..incre(endno)
  &sql(update SQLUser.dhc_invoice set INV_LastNum=:endno where inv_rowid=:invid)
  q SQLCODE
}

ClassMethod userpwd(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
        s initials="",pwd=""
        s userid=$p(val,"^",1)
        s pwd1=$p(val,"^",2)
        &sql(select ssusr_initials,ssusr_password into:initials,:pwd from ss_user where ssusr_rowid=:userid)
		s pwd1=..ENCR(pwd1)
		i (pwd=pwd1) d
		.s retcode=0
		e  d
		.s retcode=100
		s retval=itmjs_"('"_$ZCVT(retcode,"O","JS")_"');"
        i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(retcode,"O","JS")_"');"
        &javascript<#(retval)#>
		q 1
}

ClassMethod ENCR(x)
{
	 s const=37,out=""
	
	f piece=1:1:$l(x) s char=$e(x,piece) d
	. i char="D" s char=$c(2)
	.i char="p" s char=$c(3)
	.i char="d" s char=$c(4)
	.i char="t" s char=$c(5)
	.s num=$a(char)
	.s num=(num-piece+const)#255
	.i num>127 s num=(num+128)#255
	.i num<32 s num=(num+40)#255
	.i $c(num)="^" s num=num+1
	.s $e(out,piece)=$c(num#255)
	//; Pad out the length
	s len=$l(out)
	f piece=(len+1):1:12 d
	.s char=$e(out,(piece-len))
	.s num=$a(char)
	.s num=(num*2.345*const*(const-7))#255
	.i num>127 s num=(num+128)#255
	.i num<32 s num=(num+40)#255
	.i $c(num)="^" s num=num+1
	.s $e(out,piece)=$c(num#255)
	q out
}

// //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

ClassMethod InvprtTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = InvprtTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod InvprtTypeExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)

 	If $g(ind)="" Set ind=1
	s invtype="I",invtype1="住院"
 	Do OutputRow2
 	s invtype="O",invtype1="门诊"
 	Do OutputRow2
 	s invtype="E",invtype1="挂号"
 	Do OutputRow2 	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow2
	set Data=$lb(invtype,invtype1)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod InvprtTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = InvprtTypeExecute ]
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

ClassMethod invprtgetmax(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
 s type=$ZCVT(val,"U")
 s maxno=..invprtgetmax0(type)
 s retval=itmjs_"('"_$ZCVT(maxno,"O","JS")_"');"
 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(maxno,"O","JS")_"');"
 &javascript<#(retval)#>
 q 1
}

ClassMethod invprtgetmax0(type) As %String
{
	 
	       k P8,P9
	       s buyendno="",title=""
	       &sql(select max(finac_rowid) into:maxrow from SQLUser.dhc_amtmag where finac_loc=:type)
	       &sql(select nvl(finac_ednum,"") into:buyendno from SQLUser.dhc_amtmag where finac_rowid=:maxrow)
	       i buyendno="" d  
	       e  d
	       .s buyendno=..incre(buyendno)
	       s P9=buyendno
	       q P9
}

ClassMethod incre(invno) As %String
{
 ;发票号自动累加1
	s lng=$l(invno)
	s ret=invno+1
	s l=$l(ret)
	f i=lng:(-1):(l+1) d
	.s ret="0"_""_ret
	q ret
}

Query InvprtType() As %Query(ROWSPEC = "type:%String,type1:%String")
{
}

ClassMethod ssuserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ssuserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod ssuserExecute(ByRef qHandle As %Binary, type As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    i type="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    i type="I" s ssgroup="15"
    i type="O" s ssgroup="7"
 	If $g(ind)="" Set ind=1
	s rowid=0
	f  s rowid=$o(^SSU("SSUSR",rowid)) q:rowid=""  d
	
	.s username=$p(^SSU("SSUSR",rowid),"^",2)
	.;s userloc=$p(^SSU("SSUSR",rowid),"^",4)
	.s usergroup=$p(^SSU("SSUSR",rowid),"^",5)
	.;q:ssgroup'=usergroup
	.q:(usergroup'=15)&(usergroup'=25)&(type="I")
	.q:(usergroup'=7)&(type="O")
	.s rowid0=rowid
 	.Do OutputRow4	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow4
	set Data=$lb(username,rowid0)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod ssuserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ssuserExecute ]
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

Query ssuser(type As %String) As %Query(ROWSPEC = "buyer:%String,userid:%String")
{
}

ClassMethod buyuserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = buyuserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod buyuserExecute(ByRef qHandle As %Binary, type As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    ;i type="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    ;i type="I" s ssgroup=11
    ;i type="O" s ssgroup=7
 	If $g(ind)="" Set ind=1
	s rowid=0
	f  s rowid=$o(^SSU("SSUSR",rowid)) q:rowid=""  d
	.s username=$p(^SSU("SSUSR",rowid),"^",2)
	.;s userloc=$p(^SSU("SSUSR",rowid),"^",4)
	.s usergroup=$p(^SSU("SSUSR",rowid),"^",5)
	.q:(usergroup'=16)&(usergroup'=25)
	.s rowid0=rowid
 	.Do OutputRow5	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow5
	set Data=$lb(username,rowid0)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod buyuserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = buyuserExecute ]
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

Query buyuser(type As %String) As %Query(ROWSPEC = "buyer:%String,userid:%String")
{
}

ClassMethod invprtbuyinsert(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
 s str=$ZCVT(val,"U")
 s retcode=..dhcamtmaginsert(str)
 s retval=itmjs_"('"_$ZCVT(retcode,"O","JS")_"');"
 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(retcode,"O","JS")_"');"
 &javascript<#(retval)#>
 q 1
}

ClassMethod dhcamtmaginsert(str As %String) As %String
{
	;
	s PLIST(1)=""
	s PLIST(2)=+$h
	s PLIST(3)=$p(str,"^",3)
	s PLIST(4)=$p(str,"^",4)
	s PLIST(6)=$p(str,"^",6)
	s PLIST(8)=PLIST(6)
	s PLIST(7)=$p(str,"^",7) 
	s PLIST(9)=$p(str,"^",9) 
	       s cw=..finaccw(PLIST(3))
	       i cw>0 d
	       .s PLIST(11)=""
	       e  d
	       .s PLIST(11)="Y"
	;
	;s $ZT="ERROR^SSERR" TSTART
	&sql(INSERT INTO SQLUser.DHC_AMTMAG Values PLIST())
	i SQLCODE=0 d   s retcode=0
	       e  s retcode=100
	       q retcode
	;
	;s P1=$P($g(%ROWID),$C(1))
	;i 'SQLCODE TCOMMIT
}

ClassMethod finaccw(type) As %Integer
{
	       k P1
	       &sql(select count(*) into :count from SQLUser.DHC_AMTMAG where finac_avail='Y' and finac_loc=:type)
	       s P1=count
	       q count
}

// 

// / ////////////////////////////////////////////////////////////////////

ClassMethod InvprtGrantListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = InvprtGrantListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod InvprtGrantListExecute(ByRef qHandle As %Binary, type As %String, lquserid As %String) As %Status
{
 	//
 	Set repid=$I(^CacheTemp)
 	//
 	if $G(type)="" Set qHandle=$lb(0,repid,0) quit $$$OK	;s type="I"
	If $g(ind)="" Set ind=1
	Set RowId=""
	f  s RowId=$o(^DHCINVOICE(0,"TYPE",type,RowId)) q:RowId=""  d
	.s btype=$p(^DHCINVOICE(RowId),"^",8)
	.q:(type'="")&(type'=btype)
	.s RowId0=RowId
	.s bdate=$p(^DHCINVOICE(RowId),"^",4)
	.i bdate'=""  s bdate=$zd(bdate,3)
	.s btime=$p(^DHCINVOICE(RowId),"^",5)
	.i btime'=""  s btime=$zt(btime)
	.s bstartno=$p(^DHCINVOICE(RowId),"^",1)
	.s bendno=$p(^DHCINVOICE(RowId),"^",2)
	.s buser=$p(^DHCINVOICE(RowId),"^",3)
	.q:(lquserid'="")&(lquserid'=buser)
	.i buser'=""  s buser=$p(^SSU("SSUSR",buser),"^",2)
	.s bcurrent=$p(^DHCINVOICE(RowId),"^",6)
	.s bflag=$p(^DHCINVOICE(RowId),"^",7)
	.i bflag="Y"  s bflag="可用"
	.i bflag="N"  s bflag="已用完"
	.i bflag=""  s bflag="待用"
	.i btype="I"  s btype="InPatient"
	.i btype="O"  s btype="OutPatient"
	.i btype="E"  s btype="Emergency"
	.Do OutputRow3
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow3
	set Data=$lb(RowId0,bdate,btime,bstartno,bendno,bcurrent,buser,bflag,btype)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod InvprtGrantListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = InvprtGrantListExecute ]
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

Query InvprtGrantList(type As %String, lquserid As %String) As %Query(ROWSPEC = "Trowid:%String,Tdate:%String,Ttime:%String,Tstartno:%String,Tendno:%String,Tcurrentno:%String,Tlquser:%String,Tflag:%String,Ttype:%String")
{
}

// 

ClassMethod dhcamtmaguse(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
 s type=$ZCVT(val,"U")
 s maxno=..dhcamtmaguse0(type)
 s retval=itmjs_"('"_$ZCVT(maxno,"O","JS")_"');"
 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(maxno,"O","JS")_"');"
 &javascript<#(retval)#>
 q 1
}

ClassMethod dhcamtmaguse0(type As %String) As %String
{
	       k P5
	       s stno="",endno="",curno="",id=""
	       &sql(select finac_stnum,finac_ednum,finac_note,finac_rowid into :stno,:endno,:curno,:id from SQLUser.dhc_amtmag where finac_avail='Y' and finac_loc=:type)
	       s P5=$g(stno)_"^"_$g(endno)_"^"_$g(curno)_"^"_$g(id)
	       q P5
}

// 

ClassMethod dhcinvoiceinsert(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
 s str=val
 s retcode=..dhcinvoiceinsert0(str)
 s retval=itmjs_"('"_$ZCVT(retcode,"O","JS")_"');"
 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(retcode,"O","JS")_"');"
 &javascript<#(retval)#>
 q 1
}

// 

ClassMethod dhcinvoiceinsert0(str As %String) As %String
{
	;
	s PLIST(1)=""
	s PLIST(2)=$p(str,"^",2)
	s PLIST(3)=$p(str,"^",3)
	s PLIST(4)=$p(str,"^",4)
	s PLIST(5)=+$h
	s PLIST(6)=$p($h,",",2)
	s type=$p(str,"^",6)
	s PLIST(9)=type
	s PLIST(10)="N" 
	s PLIST(7)=PLIST(2)
	       s cw=..invcw(PLIST(4),type)
	       i cw>0 d
	       .s PLIST(8)=""
	       e  d
	       .s PLIST(8)="Y"
	
	s buyend=$p(str,"^",5)
	s lqenno=PLIST(3)
	TSTART
	&sql(INSERT INTO SQLUser.DHC_invoice Values :PLIST())
	  i SQLCODE=0  d
	       .s retcode=0
	       .;
	       .s err=..invupdate(lqenno,buyend,type)
	       .s retcode=retcode+SQLCODE
	       .i lqenno=buyend d
	       ..s err1=..invrefund(type)
	       .s retcode=retcode+SQLCODE
	       .
	       e  d
	       .s retcode=100
	       i retcode=0  d
	       .TCOMMIT
	       e  d
	       .TROLLBACK
	       q retcode
}

// 

ClassMethod invrefund(type As %String) As %String
{
	       ;当领取的结束编号等于可用收据的结束编号时?将标志置为不可用??2??同时判断是否有待用的收据
	       ;有则将代用的rowid最小的变为可用标志
	       &sql(update SQLUser.dhc_amtmag set finac_avail='N' where finac_avail='Y' and finac_loc=:type)
	       &sql(select count(*) into :num from SQLUser.dhc_amtmag where (finac_avail='' or finac_avail is null) and finac_rowid<>'0' and finac_loc=:type)
	       i num'=0  d
	       .&sql(select min(finac_rowid) into :rowid1  from SQLUser.dhc_amtmag where (finac_avail='' or finac_avail is null) and finac_rowid<>'0' and finac_loc=:type)
	       .&sql(update SQLUser.dhc_amtmag set finac_avail='Y' where finac_rowid=:rowid1)
	       q SQLCODE
}

ClassMethod invupdate(endno As %String, buyend As %String, type As %String) As %String
{
	      ;修改住院处领取收据的结束编号?将当前编号改为结束编号
	
	      i endno'=buyend  s endno=..incre(endno)
	       &sql(update SQLUser.dhc_amtmag set finac_note=:endno where finac_avail='Y' and finac_loc=:type)
	       q SQLCODE
}

ClassMethod invcw(userid As %Integer, type As %String) As %Integer
{
		   k P2
	       &sql(select count(*) into :count from SQLUser.dhc_invoice where INV_Finalflag='Y' and INV_Usr=:userid and INV_type=:type)
	       s P2=count	      
	       q count
}

ClassMethod getbuynote(itmjs As %Library.String = "", itmjsex As %Library.String = "", stno As %Library.String = "", endno As %Library.String = "", invtype As %Library.String = "")
{
 s num=0
 &sql(select count(*) into :num from dhc_amtmag 
      where (finac_loc=:invtype) and (finac_avail<>'N') and 
            ((finac_stnum<=:stno and finac_ednum>=:stno) or (finac_stnum<=:endno and finac_ednum>=:endno)) )
 s retval=itmjs_"('"_$ZCVT(num,"O","JS")_"');"
 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(num,"O","JS")_"');"
 &javascript<#(retval)#>
 q num
}

}
