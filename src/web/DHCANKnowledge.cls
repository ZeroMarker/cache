Import SQLUSER

/// 对知识库数据进行增删改操作lhw20100128
Class web.DHCANKnowledge Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

//插入数据

ClassMethod InsertOperKnowledge(NANCKSCode As %String, NANCKSDesc As %String, ANKANCKSCDr As %String, ANKKeyWord As %String, ANKKeyWordAlias As %String, ANKData As %String, ANKStatus As %String, ANKSourceDr As %String, ANKUpdateUserDr As %String)
{
	TSTART
	s PLIST(2)=NANCKSCode
	s PLIST(3)=NANCKSDesc
	s PLIST(4)=ANKANCKSCDr
	s PLIST(5)=ANKKeyWord
	s PLIST(6)=ANKKeyWordAlias
	s PLIST(7)=ANKData
	s PLIST(8)=ANKStatus
	s PLIST(9)=ANKSourceDr
	s PLIST(10)=ANKUpdateUserDr
	s PLIST(11)=$p($h,",")
	s PLIST(12)=$p($h,",",2)
	&SQL(insert into DHC_AN_Knowledge Values :PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
}

//更新数据

ClassMethod UpdateOperKnowledge(NANCKSRowid As %String, NANCKSCode As %String, NANCKSDesc As %String, ANKANCKSCDr As %String, ANKKeyWord As %String, ANKKeyWordAlias As %String, ANKData As %String, ANKStatus As %String, ANKSourceDr As %String, ANKUpdateUserDr As %String)
{
	TSTART
	i (NANCKSRowid'="")&&(NANCKSCode'="")&&(NANCKSDesc'="")&&(ANKANCKSCDr'="") d
	.k PLIST
	.s PLIST(2)=NANCKSCode
	.s PLIST(3)=NANCKSDesc
	.s PLIST(4)=ANKANCKSCDr
	.s PLIST(5)=ANKKeyWord
	.s PLIST(6)=ANKKeyWordAlias
	.s PLIST(7)=ANKData
	.s PLIST(8)=ANKStatus
	.s PLIST(9)=ANKSourceDr
	.s PLIST(10)=ANKUpdateUserDr
	.s PLIST(11)=$p($h,",")
	.s PLIST(12)=$p($h,",",2)
	.&SQL(update DHC_AN_Knowledge Values :PLIST() where ANK_RowId=:NANCKSRowid)
	Q 0
}

//删除数据

ClassMethod DeleteOperKnowledge(NANCKSRowid As %String)
{
	i ANCKSRowid'="" d
	.k ^DHCANKnowledge(NANCKSRowid)
	Q 0
}

ClassMethod FindDHCANKnowledgeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDHCANKnowledgeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindDHCANKnowledgeExecute(ByRef qHandle As %Binary, NANCKSDesc As %String, ANKANCKSCDr As %String, ANKKeyWord As %String, ANKKeyWordAlias As %String, ANKData As %String, ANKSourceDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s rowid=0
	f  s rowid=$o(^DHCANKnowledge(rowid)) q:rowid=""  d
	.q:(^DHCALias(rowid)'[NANCKSDesc )&(^DHCALias(rowid)'[ANKANCKSCDr)&(^DHCALias(rowid)'[ANKANCKSCDr)&(^DHCALias(rowid)'[ANKKeyWord)&(^DHCALias(rowid)'[ANKKeyWordAlias)&(^DHCALias(rowid)'[ANKData)&(^DHCALias(rowid)'[ANKSourceDr)
	.s NANCKSCode=$p($g(^DHCANKnowledge(rowid)),"^",1)
	.s NANCKSDesc=$p($g(^DHCANKnowledge(rowid)),"^",2)
	.s ANKANCKSCDr=$p($g(^DHCANKnowledge(rowid)),"^",3)
	.s ANKKeyWord=$p($g(^DHCANKnowledge(rowid)),"^",4)
	.s ANKKeyWordAlias=$p($g(^DHCANKnowledge(rowid)),"^",5)
	.s ANKData=$p($g(^DHCANKnowledge(rowid)),"^",6)
	.s ANKSourceDr=$p($g(^DHCANKnowledge(rowid)),"^",8)
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(rowid,NANCKSCode,NANCKSDesc,ANKANCKSCDr,ANKKeyWord,ANKKeyWordAlias,ANKData,ANKSourceDr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindDHCANKnowledgeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDHCANKnowledgeExecute ]
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

Query FindDHCANKnowledge(NANKrowid As %String, NANCKSCode As %String, NANCKSDesc As %String, ANKANCKSCDr As %String, ANKKeyWord As %String, ANKKeyWordAlias As %String, ANKData As %String, ANKSourceDr As %String) As %Query(ROWSPEC = "NANCKSDesc:%String,ANKANCKSCDr:%String,ANKKeyWord:%String,ANKKeyWordAlias:%String,ANKData:%String,ANKSourceDr:%String")
{
}

ClassMethod FindknowledgetreeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindknowledgetreeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindknowledgetreeExecute(ByRef qHandle As %Binary, ANKANCKSCDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s rowid=0
	s rowid=$o(^DHCANKnowledgeD(-1))
	f  s rowid=$o(^DHCANKnowledgeD(rowid)) q:rowid=""  d
	.i $li(^DHCANKnowledgeD(rowid),3)=ANKANCKSCDr d
	..s NANCKSCode=$li(^DHCANKnowledgeD(rowid),1)
	..s NANCKSDesc=$li(^DHCANKnowledgeD(rowid),2)
	..s ANKANCKSCDr=$li(^DHCANKnowledgeD(rowid),3)
	..s ANKKeyWord=$li(^DHCANKnowledgeD(rowid),4)
	..s ANKKeyWordAlias=$li(^DHCANKnowledgeD(rowid),5)
	..;s ANKData=$p($g(^DHCANKnowledge(rowid)),,6)
	..s ANKSourceDr=$li(^DHCANKnowledgeD(rowid),8)
	..S NANKrowid=rowid
	..d OutputRow
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(NANKrowid,NANCKSCode,NANCKSDesc,ANKANCKSCDr,ANKKeyWord,ANKKeyWordAlias,ANKSourceDr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindknowledgetreeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindknowledgetreeExecute ]
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

Query Findknowledgetree(ANKANCKSCDr As %String) As %Query(ROWSPEC = "NANKrowid:%String,NANCKSCode:%String,NANCKSDesc:%String,ANKANCKSCDr:%String,ANKKeyWord:%String,ANKKeyWordAlias:%String,ANKSourceDr:%String")
{
}

//D ##class(%ResultSet).RunQuery("web.DHCANKnowledge","Findknowledgetree",91)

ClassMethod FindSearchKnowledgeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSearchKnowledgeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindSearchKnowledgeExecute(ByRef qHandle As %Binary, ANKANCKSCrowid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ANKSourceDrDESC=""
	s NANCKSCode=$li(^DHCANKnowledgeD(ANKANCKSCrowid),1)
	s NANCKSDesc=$li(^DHCANKnowledgeD(ANKANCKSCrowid),2)
	s ANKANCKSCDr=$li(^DHCANKnowledgeD(ANKANCKSCrowid),3)
	s ANKKeyWord=$li(^DHCANKnowledgeD(ANKANCKSCrowid),4)
	s ANKKeyWordAlias=$li(^DHCANKnowledgeD(ANKANCKSCrowid),5)
	;s ANKData=$p($g(^DHCANKnowledge(rowid)),6)
	s ANKSourceDr=$li(^DHCANKnowledgeD(ANKANCKSCrowid),8)
    i ANKSourceDr'=""  s ANKSourceDrDESC=$p(^DHCANC("KSrc",ANKSourceDr),"^",2)
	d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(ANKANCKSCrowid,NANCKSCode,NANCKSDesc,ANKANCKSCDr,ANKKeyWord,ANKKeyWordAlias,ANKSourceDr,ANKSourceDrDESC)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindSearchKnowledgeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSearchKnowledgeExecute ]
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

Query FindSearchKnowledge(ANKANCKSCrowid As %String) As %Query(ROWSPEC = "ANKANCKSCrowid:%String,NANCKSCode:%String,NANCKSDesc:%String,ANKANCKSCDr:%String,ANKKeyWord:%String,ANKKeyWordAlias:%String,ANKSourceDr:%String,ANKSourceDrDESC:%String")
{
}

ClassMethod FindKnowledgeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindKnowledgeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindKnowledgeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s rowid=0
	f  s rowid=$o(^DHCANKnowledgeD(rowid)) q:rowid=""  d
	.s NANCKSCode=$li(^DHCANKnowledgeD(rowid),1)
	.s NANCKSDesc=$li(^DHCANKnowledgeD(rowid),2)
	.s ANKANCKSCDr=$li(^DHCANKnowledgeD(rowid),3)
	.s ANKKeyWord=$li(^DHCANKnowledgeD(rowid),4)
	.s ANKKeyWordAlias=$li(^DHCANKnowledgeD(rowid),5)
	.s ANKSourceDr=$li(^DHCANKnowledgeD(rowid),8)
	.S ANKANCKSCrowid=rowid
	.s ANKANCKSCDrdesc=""
	.s ANKANCKSCDrCatdesc=""
	.s Rowsubid=0
	.i ANKANCKSCDr'=""  d
	.. s ANKANCKSCDrdesc=$p($g(^DHCANC("KSCat",ANKANCKSCDr)),"^",2)
	.. S Rowsubid=$p($g(^DHCANC("KSCat",ANKANCKSCDr)),"^",3)
	.i Rowsubid'="" s ANKANCKSCDrCatdesc=$p($G(^DHCANC("KCat",Rowsubid)),"^",2)
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(ANKANCKSCrowid,NANCKSCode,NANCKSDesc,ANKANCKSCDr,ANKKeyWord,ANKKeyWordAlias,ANKSourceDr,ANKANCKSCDrdesc,ANKANCKSCDrCatdesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindKnowledgeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindKnowledgeExecute ]
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

Query FindKnowledge() As %Query(ROWSPEC = "ANKANCKSCrowid:%String,NANCKSCode:%String,NANCKSDesc:%String,ANKANCKSCDr:%String,ANKKeyWord:%String,ANKKeyWordAlias:%String,ANKSourceDr:%String,ANKANCKSCDrdesc:%String,ANKANCKSCDrCatdesc:%String")
{
}

//D ##class(%ResultSet).RunQuery("web.DHCANKnowledge","FindKnowledge")

ClassMethod GetKnowledgeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetKnowledgeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetKnowledgeExecute(ByRef qHandle As %Binary, ANKANCKSCDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ANKSourceDrDESC=""
	s ANKANCKSCrowid=0
	f  s ANKANCKSCrowid=$o(^DHCANKnowledgeD(ANKANCKSCrowid)) q:ANKANCKSCrowid=""  d
	.I $li(^DHCANKnowledgeD(ANKANCKSCrowid),2)[ANKANCKSCDesc D
	..s NANCKSCode=$li(^DHCANKnowledgeD(ANKANCKSCrowid),1)
	..s NANCKSDesc=$li(^DHCANKnowledgeD(ANKANCKSCrowid),2)
	..s ANKANCKSCDr=$li(^DHCANKnowledgeD(ANKANCKSCrowid),3)
	..s ANKKeyWord=$li(^DHCANKnowledgeD(ANKANCKSCrowid),4)
	..s ANKKeyWordAlias=$li(^DHCANKnowledgeD(ANKANCKSCrowid),5)
	..s ANKSourceDr=$li(^DHCANKnowledgeD(ANKANCKSCrowid),8)
	..s ANKSourceDrDESC=""
    ..i ANKSourceDr'=""  s ANKSourceDrDESC=$p(^DHCANC("KSrc",ANKSourceDr),"^",2)
	..d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(ANKANCKSCrowid,NANCKSCode,NANCKSDesc,ANKANCKSCDr,ANKKeyWord,ANKKeyWordAlias,ANKSourceDr,ANKSourceDrDESC)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetKnowledgeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetKnowledgeExecute ]
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

Query GetKnowledge(ANKANCKSCDesc As %String) As %Query(ROWSPEC = "ANKANCKSCrowid:%String,NANCKSCode:%String,NANCKSDesc:%String,ANKANCKSCDr:%String,ANKKeyWord:%String,ANKKeyWordAlias:%String,ANKSourceDr:%String,ANKSourceDrDESC:%String")
{
}

ClassMethod GetKnowledgeConfigration(ANKANCKSCrowid As %String) As %Library.String
{

	s id="",objectId=""
	f  s id=$o(^DHCANKnowledgeD(id)) q:id=""  d
	.i id=ANKANCKSCrowid d
	..s objectId=id
	q objectId
}

//w ##class(web.DHCANKnowledge).GetKnowledgeConfigration("54")

ClassMethod GetKnowledgeKeyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetKnowledgeKeyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetKnowledgeKeyExecute(ByRef qHandle As %Binary, ANKANCKSCDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ANKSourceDrDESC=""
	s ANKANCKSCrowid=0
	f  s ANKANCKSCrowid=$o(^DHCANKnowledgeD(ANKANCKSCrowid)) q:ANKANCKSCrowid=""  d
	.I $li(^DHCANKnowledgeD(ANKANCKSCrowid),4)[ANKANCKSCDesc D
	..s NANCKSCode=$li(^DHCANKnowledgeD(ANKANCKSCrowid),1)
	..s NANCKSDesc=$li(^DHCANKnowledgeD(ANKANCKSCrowid),2)
	..s ANKANCKSCDr=$li(^DHCANKnowledgeD(ANKANCKSCrowid),3)
	..s ANKKeyWord=$li(^DHCANKnowledgeD(ANKANCKSCrowid),4)
	..s ANKKeyWordAlias=$li(^DHCANKnowledgeD(ANKANCKSCrowid),5)
	..s ANKSourceDr=$li(^DHCANKnowledgeD(ANKANCKSCrowid),8)
	..s ANKSourceDrDESC=""
    ..i ANKSourceDr'=""  s ANKSourceDrDESC=$p(^DHCANC("KSrc",ANKSourceDr),"^",2)
	..d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(ANKANCKSCrowid,NANCKSCode,NANCKSDesc,ANKANCKSCDr,ANKKeyWord,ANKKeyWordAlias,ANKSourceDr,ANKSourceDrDESC)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetKnowledgeKeyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetKnowledgeKeyExecute ]
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

Query GetKnowledgeKey(ANKANCKSCDesc As %String) As %Query(ROWSPEC = "ANKANCKSCrowid:%String,NANCKSCode:%String,NANCKSDesc:%String,ANKANCKSCDr:%String,ANKKeyWord:%String,ANKKeyWordAlias:%String,ANKSourceDr:%String,ANKSourceDrDESC:%String")
{
}

//d ##class(web.DHCANKnowledge).setupRoomEquip() 

ClassMethod setupRoomEquip()
{
	s Rowid=0
	s rowidn=0,rowidm=0
	f  s Rowid=$o(^DHCANRoomEquip(Rowid)) q:Rowid=""  d
    .s TcpipAddress=$p(^DHCANRoomEquip(Rowid),"^",3)
	.s UserIPAdress=$p(^DHCANRoomEquip(Rowid),"^",7)
	.i TcpipAddress'="" d
	..s rowidn=rowidn+1
	..s rowidm=60+rowidn
	..;s TcpipAddress="172.24.4."_rowidm
	..i UserIPAdress["|" d
	...s UserIPAdress="192.168.0.103|172.24.4."_rowidn
	..e  d
	...s UserIPAdress=UserIPAdress_"|192.168.0.103"
	..;&sql(update DHC_AN_RoomEquip set ANRE_TcpipAddress=:TcpipAddress,ANRE_EditTcpipAddress=:UserIPAdress  where ANRE_RowId=:Rowid)
	..&sql(update DHC_AN_RoomEquip set ANRE_EditTcpipAddress=:UserIPAdress  where ANRE_RowId=:Rowid)
    ;s adm=6832084,chl=1,sub=1
    ;s scnId=0 f  s scnId=$O(^OR(adm,"ANA",chl,"OP",sub,"SCN",scnId)) q:scnId=""  d
	;.q:scnId>20
	;.s scnDr=$P(^OR(6832084,"ANA",1,"OP",1,"SCN",scnId),"^",1)
	;.q:scnDr=""
	;.w scnDr,scnId,!
	;q 0
}

}
