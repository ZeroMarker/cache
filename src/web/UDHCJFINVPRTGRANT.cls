Import SQLUser

Class web.UDHCJFINVPRTGRANT Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 41;

//insert 2005.7.22   by cx////////////////////////////////////////////////////////////////////////////////////////////////

// //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/// /////////////////////////////////////////
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
	.Do OutputRow3
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow3
	set Data=$lb(RowId0,bdate,btime,bstartno,bendno,bcurrent,buser,bflag,btype)
 	Set ^CacheTemp(repid,ind)=Data
 	s ^TMPINV(ind)=Data
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

ClassMethod dhcamtdeluse(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", userid As %String)
{
 s type=$ZCVT(val,"U")
 s maxno=..dhcamtdeluse0(type,userid)
 s retval=itmjs_"('"_$ZCVT(maxno,"O","JS")_"');"
 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(maxno,"O","JS")_"');"
 &javascript<#(retval)#>
 q 1
}

ClassMethod dhcamtdeluse0(type As %String, userid As %String) As %String
{
	       k P5
	       s stno="",endno="",curno="",id=""
	       &sql(select deli_stnum,deli_endnum,deli_latestinv,deli_rowid into :stno,:endno,:curno,:id from SQLUser.dhc_amtdel where deli_flag='Y' and deli_loc=:type and deli_getor=:userid)
	  
	       s P5=$g(stno)_"^"_$g(endno)_"^"_$g(curno)_"^"_$g(id)
	       i SQLCODE=100  s P5="^^^"
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
	s userid=$p(str,"^",7)
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
	       .s err=..invoiceupdate(lqenno,buyend,type,userid)
	       .s retcode=retcode+SQLCODE
	       .i lqenno=buyend d
	       ..s err1=..invoicerefund(type,userid)
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

ClassMethod invoicerefund(type As %String, userid As %String) As %String
{
	       ;当领取的结束编号等于可用收据的结束编号时?将标志置为不可用??2??同时判断是否有待用的收据
	       ;有则将代用的rowid最小的变为可用标志
	       &sql(update SQLUser.dhc_amtdel set deli_flag='N' where deli_flag='Y' and deli_loc=:type and deli_getor=:userid)
	       &sql(select count(*) into :num from SQLUser.dhc_amtdel where (deli_flag='' or deli_flag is null) and deli_rowid<>'0' and deli_loc=:type and deli_getor=:userid)
	       i num'=0  d
	       .&sql(select min(deli_rowid) into :rowid1  from SQLUser.dhc_amtdel where (deli_flag='' or deli_flag is null) and deli_rowid<>'0' and deli_loc=:type and deli_getor=:userid)
	       .&sql(update SQLUser.dhc_amtdel set deli_flag='Y' where deli_rowid=:rowid1)
	       q SQLCODE
}

ClassMethod invoiceupdate(endno As %String, buyend As %String, type As %String, userid As %String) As %String
{
	      ;修改住院处领取收据的结束编号?将当前编号改为结束编号
	
	      i endno'=buyend  s endno=..incre(endno)
	       &sql(update SQLUser.dhc_amtdel set deli_latestinv=:endno where deli_flag='Y' and deli_loc=:type and deli_getor=:userid)
	       q SQLCODE
}

ClassMethod invcw(userid As %Integer, type As %String) As %Integer
{
		   k P2
	       &sql(select count(*) into :count from SQLUser.dhc_invoice where INV_Finalflag='Y' and INV_Usr=:userid and INV_type=:type)
	       s P2=count	      
	       q count
}

//  ////////////////////////////////////////////////////////////////////////

ClassMethod InvdelGrantListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = InvdelGrantListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod InvdelGrantListExecute(ByRef qHandle As %Binary, type As %String, lquserid As %String) As %Status
{
 	//
 	Set repid=$I(^CacheTemp)
 	//
 	if $G(type)="" Set qHandle=$lb(0,repid,0) quit $$$OK	;s type="I"
	If $g(ind)="" Set ind=1
	Set RowId=""
	f  s RowId=$o(^DHCAMTDEL("Loc",type,RowId)) q:RowId=""  d
	.s btype=$p(^DHCAMTDEL(RowId),"^",10)
	.q:(type'="")&(type'=btype)
	.s RowId0=RowId
	.s bdate=$p(^DHCAMTDEL(RowId),"^",1)
	.i bdate'=""  s bdate=$zd(bdate,3)
	.s btime=$p(^DHCAMTDEL(RowId),"^",2)
	.i btime'=""  s btime=$zt(btime)
	.s bstartno=$p(^DHCAMTDEL(RowId),"^",4)
	.s bendno=$p(^DHCAMTDEL(RowId),"^",5)
	.s buser=$p(^DHCAMTDEL(RowId),"^",3)
	.q:(lquserid'="")&(lquserid'=buser)
	.i buser'=""  s buser=$p(^SSU("SSUSR",buser),"^",2)
	.s bcurrent=$p(^DHCAMTDEL(RowId),"^",8)
	.s bflag=$p(^DHCAMTDEL(RowId),"^",9)
	.i bflag="Y"  s bflag="可用"
	.i bflag="N"  s bflag="已用完"
	.i bflag=""  s bflag="待用"
	.i btype="I"  s btype="InPatient"
	.i btype="O"  s btype="OutPatient"
	.Do OutputRow6
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow6
	set Data=$lb(RowId0,bdate,btime,bstartno,bendno,bcurrent,buser,bflag,btype)
 	Set ^CacheTemp(repid,ind)=Data
 	s ^TMPINV(ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod InvdelGrantListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = InvdelGrantListExecute ]
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

Query InvdelGrantList(type As %String, lquserid As %String) As %Query(ROWSPEC = "Trowid:%String,Tdate:%String,Ttime:%String,Tstartno:%String,Tendno:%String,Tcurrentno:%String,Tlquser:%String,Tflag:%String,Ttype:%String")
{
}

ClassMethod dhcamtdelinsert(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
 s str=val
 s retcode=..dhcamtdelinsert0(str)
 s retval=itmjs_"('"_$ZCVT(retcode,"O","JS")_"');"
 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(retcode,"O","JS")_"');"
 &javascript<#(retval)#>
 q 1
}

//

ClassMethod dhcamtdelinsert0(str As %String) As %String
{
	;
	s PLIST(1)=""
	s PLIST(5)=$p(str,"^",2)
	s PLIST(6)=$p(str,"^",3)
	s PLIST(4)=$p(str,"^",4)
	s PLIST(2)=+$h
	s PLIST(3)=$p($h,",",2)
	s type=$p(str,"^",6)
	s PLIST(11)=type
	s PLIST(10)="N" 
	s PLIST(9)=PLIST(5)
	       s cw=..invdelcw(PLIST(4),type)
	       i cw>0 d
	       .s PLIST(10)=""
	       e  d
	       .s PLIST(10)="Y"
	
	s buyend=$p(str,"^",5)
	s lqenno=PLIST(6)
	TSTART
	&sql(INSERT INTO SQLUser.DHC_AMTDEL Values :PLIST())
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

ClassMethod invdelcw(userid As %Integer, type As %String) As %Integer
{
		   k P2
	       &sql(select count(*) into :count from SQLUser.dhc_amtdel where deli_flag='Y' and deli_getor=:userid and deli_loc=:type)
	       s P2=count	      
	       q count
}

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

//

}
