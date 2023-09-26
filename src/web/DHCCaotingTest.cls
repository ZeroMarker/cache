Class web.DHCCaotingTest Extends %RegisteredObject
{

ClassMethod GetAdmBySortClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdmBySortExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetAdmBySortExecute(ByRef qHandle As %Binary, stdate, enddate, username) As %Status
{

 k ^TESTTMP
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=0
 s ^TESTTMP="",padate="",ctCode="",id=0
 ;s stdate=$zdh(stdate,3),enddate=$zdh(enddate,3)
 w !,stdate_"^"_enddate
 f prtdate=stdate:1:enddate d
 .s prtrowid="",id=0
 .f  s prtrowid=$o(^PAADMi("PAADM_AdmDate",prtdate,prtrowid)) q:prtrowid=""  d
 ..s papmidr=$p(^PAADM(prtrowid),"^",1)

 ..s papname=""
 
 ..i $d(^PAPER(papmidr,"ALL"))  s papname=$p(^PAPER(papmidr,"ALL"),"^",1)
 ..q:(username'=papname)&(username'="")
 ..s padate=$p(^PAADM(prtrowid),"^",6)
 ..s date=$zd(padate,3)
 ..s patime=$p(^PAADM(prtrowid),"^",7)
 ..s time=$zt(patime,3)
 ..s depCode=$p(^PAADM(prtrowid),"^",4)
 ..i $d(^CTLOC(depCode)) s ctCode=$p(^CTLOC(depCode),"^",1)
  
 ..s id=id+1
 ..s ^TESTTMP(padate,ctCode,id)=papname_"^"_date_"^"_time_"^"_ctCode
 ..;w id,^TESTTMP(padate,ctCode,id),!
 
 s padate="",ctCode="",id=0
 f  s padate=$o(^TESTTMP(padate)) q:padate=""  d
 .s ctCode=""
 .f  s ctCode=$o(^TESTTMP(padate,ctCode)) q:ctCode=""  d
 ..s id=0
 
 ..f  s id=$o(^TESTTMP(padate,ctCode,id)) q:id=""  d
 
 ...;w ^TESTTMP(padate,ctCode,id),!
 ...;w ^TMP(padate,ctCode,id),!

 ...s MyPapname=$p(^TESTTMP(padate,ctCode,id),"^",1)
 ...s MyDate=$p(^TESTTMP(padate,ctCode,id),"^",2)
 ...s MyTime=$p(^TESTTMP(padate,ctCode,id),"^",3)
 ...s MyCtCode=$p(^TESTTMP(padate,ctCode,id),"^",4)
 
 ...Set ind=ind+1
 
 ...d OutputRow2
 Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow2
	set Data=$lb(MyPapname,MyDate,MyTime,MyCtCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAdmBySortFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdmBySortExecute ]
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

Query GetAdmBySort(stdate, enddate, username) As %Query(ROWSPEC = "MyPapname:%String,MyDate:%String,MyTime:%String,MyCtCode:%String")
{
}

ClassMethod GetUserNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUserNameExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetUserNameExecute(ByRef qHandle As %Binary) As %Status
{
 Set repid=$I(^CacheTemp)
 s ind=0
 s UserName="",RowId=""
 f  s RowId=$o(^PAPER(RowId)) q:RowId=""  d
 .i $d(^PAPER(RowId,"ALL")) s UserName=$p(^PAPER(RowId,"ALL"),"^",1)
 .;w UserName,RowId,!
 
 .;Set ind=ind+1
 
 .d OutputRow2
 Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow2
	set Data=$lb(UserName,RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetUserNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserNameExecute ]
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

Query GetUserName() As %Query(ROWSPEC = "UserName:%String,RowId:%String")
{
}

ClassMethod GetPatInfoByNo(PatNo)
{
	//根据病人登记号返回病人姓名和性别
	i PatNo="" q ""
	s PatName="",PatSex="",RowId=""
	s RowId=$o(^PAPERi("PAPMI_PatNo",PatNo,""))
	s data=^PAPER(RowId,"ALL")
	q:data=""
    s PatName=$p(data,"^",1)
    s PatSexDr=$p(data,"^",7)
    s PatSex=$p(^CT("SEX",PatSexDr),"^",2)
    //s PatAdmNo=$p(data,"^",81)
    s PaType=""
    s PaType=$o(^PAPERdr(RowId,"ADM",PaType))  q:PaType=""  d
    .s AdmRowId=""
    .s AdmRowId=$o(^PAPERdr(RowId,"ADM",PaType,AdmRowId)) q:AdmRowId=""  d
    ..s AdmNo=$p(^PAADM(AdmRowId),"^",81)
    q PatName_"^"_PatSex
}

}
