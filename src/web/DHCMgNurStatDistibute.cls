Class web.DHCMgNurStatDistibute Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 人力资源统计分布
/// 
/// 按病区对性别统计分布
Query SearchSexSatistic() As %Query(ROWSPEC = "PersonDepDR,count11,count21,countSum") [ SqlProc ]
{
}

ClassMethod SearchSexSatisticExecute(ByRef qHandle As %Binary) As %Status
{
	//w ##class(%ResultSet).RunQuery("web.DHCMgNurStatDistibute","SearchSexSatistic")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	;s tempDep="" f  s tempDep=$O(^DHCMGNUR.MgNurPerWardI("WardLoc",tempDep)) q:tempDep=""  d
 	s ord="" f  s ord=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",ord)) q:ord=""  d
 	.s ordid="" f  s ordid=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",ord,ordid)) q:ordid=""  d
 	..s aa=##class(DHCMGNUR.MgNurPerWard).%OpenId(ordid)
 	..s tempDep=aa.WardLoc
 	..q:((tempDep="9999")!(tempDep="9998")!(tempDep="9997"))
 	..s count1=0,count2=0,countS=0
 	..s PersonDepDR=tempDep
 	..s id="" f  s id=$O(^DHCMGNUR.MgPersonsI("Dep"," "_tempDep,id)) q:id=""  d
 	...;b ;011
 	...s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
 	...q:a.PersonType2'="N"
 	...i a.PersonSexDR=2 s count1=count1+1 //男
 	...i a.PersonSexDR=1 s count2=count2+1 	//女
 	..s count11=count1,count21=count2,countSum=count11+count21
 	..s PersonDepDR=$TR(PersonDepDR," ","")
 	..i PersonDepDR'="" s PersonDepDR=$P(^CTLOC(PersonDepDR),"^",2)
 	..e  s PersonDepDR=""
 	..d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(PersonDepDR,count11,count21,countSum)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod SearchSexSatisticFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchSexSatisticExecute ]
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

ClassMethod SearchSexSatisticClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchSexSatisticExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// 
/// 按病区统计护士层级分布
/// 
Query SearchBatterySatistic() As %Query(ROWSPEC = "PersonDepDR,countN1,countN2,countN3,countN4,countN5,countSum") [ SqlProc ]
{
}

ClassMethod SearchBatterySatisticExecute(ByRef qHandle As %Binary) As %Status
{
	//w ##class(%ResultSet).RunQuery("web.DHCMgNurStatDistibute","SearchBatterySatistic")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	;s tempDep="" f  s tempDep=$O(^DHCMGNUR.MgNurPerWardI("WardLoc",tempDep)) q:tempDep=""  d
 	s ord="" f  s ord=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",ord)) q:ord=""  d
 	.s ordid="" f  s ordid=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",ord,ordid)) q:ordid=""  d
 	..s aa=##class(DHCMGNUR.MgNurPerWard).%OpenId(ordid)
 	..s tempDep=aa.WardLoc
 	..q:((tempDep="9999")!(tempDep="9998")!(tempDep="9997"))
 	..s countN1=0,countN2=0,countN3=0,countN4=0,countN5=0,countSum=0
 	..s PersonDepDR=tempDep
 	..s id="" f  s id=$O(^DHCMGNUR.MgPersonsI("Dep"," "_tempDep,id)) q:id=""  d
 	...s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
 	...q:a.PersonType2'="N"
 	...;b ;01
 	...i a.PersonBattery.Code="N1" s countN1=countN1+1
 	...i a.PersonBattery.Code="N2" s countN2=countN2+1
 	...i a.PersonBattery.Code="N3" s countN3=countN3+1
 	...i a.PersonBattery.Code="N4" s countN4=countN4+1
 	...i a.PersonBattery.Code="N5" s countN5=countN5+1
 	..s sumN1=countN1,sumN2=countN2,sumN3=countN3,sumN4=countN4,sumN5=countN5
 	..s countSum=countN1+countN2+countN3+countN4+countN5
 	..s PersonDepDR=$TR(PersonDepDR," ","")
 	..;i PersonDepDR'="" s PersonDepDR=$P(^CTLOC(PersonDepDR),"^",1)
 	..i PersonDepDR'="" s PersonDepDR=$P(^CTLOC(PersonDepDR),"^",2)
 	..e  s PersonDepDR=""
 	..d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(PersonDepDR,sumN1,sumN2,sumN3,sumN4,sumN5,countSum)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod SearchBatterySatisticFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchBatterySatisticExecute ]
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

ClassMethod SearchBatterySatisticClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchBatterySatisticExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// 
/// 按病区统计护士种类分布
/// 
Query SearchNurTyp() As %Query(ROWSPEC = "PersonDepDR,sum3,sum4,countSum") [ SqlProc ]
{
}

ClassMethod SearchNurTypExecute(ByRef qHandle As %Binary) As %Status
{
	//w ##class(%ResultSet).RunQuery("web.DHCMgNurStatDistibute","SearchNurTyp")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	;s tempDep="" f  s tempDep=$O(^DHCMGNUR.MgNurPerWardI("WardLoc",tempDep)) q:tempDep=""  d
 	s ord="" f  s ord=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",ord)) q:ord=""  d
 	.s ordid="" f  s ordid=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",ord,ordid)) q:ordid=""  d
 	..s aa=##class(DHCMGNUR.MgNurPerWard).%OpenId(ordid)
 	..s tempDep=aa.WardLoc
 	..q:((tempDep="9999")!(tempDep="9998")!(tempDep="9997"))
 	..s count3=0,count4=0,countSum=0
 	..s PersonDepDR=tempDep
 	..s id="" f  s id=$O(^DHCMGNUR.MgPersonsI("Dep"," "_tempDep,id)) q:id=""  d
 	...s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
 	...q:a.PersonType2'="N"
 	...i a.PersonNurTyp.Code="聘用制职工" s count3=count3+1 //聘用制职工
 	...i a.PersonNurTyp.Code="协议职工" s count4=count4+1 //协议职工
 	..s sum3=count3,sum4=count4,countSum=sum3+sum4 //countSum 合计
 	..s PersonDepDR=$TR(PersonDepDR," ","")
 	..i PersonDepDR'="" s PersonDepDR=$P(^CTLOC(PersonDepDR),"^",2)
 	..e  s PersonDepDR=""
 	..d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(PersonDepDR,sum3,sum4,countSum)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod SearchNurTypFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchNurTypExecute ]
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

ClassMethod SearchNurTypClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchNurTypExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// 
/// 按病区统计男护士鞋号分布
/// 
Query SearchMShoeNO() As %Query(ROWSPEC = "PersonDepDR,count1,count2,count3,count4,count5,count6,count7,count8,count9,count10,count11,countSum") [ SqlProc ]
{
}

ClassMethod SearchMShoeNOExecute(ByRef qHandle As %Binary) As %Status
{
	//w ##class(%ResultSet).RunQuery("web.DHCMgNurStatDistibute","SearchMShoeNO")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	;s tempDep="" f  s tempDep=$O(^DHCMGNUR.MgNurPerWardI("WardLoc",tempDep)) q:tempDep=""  d
 	s ord="" f  s ord=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",ord)) q:ord=""  d
 	.s ordid="" f  s ordid=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",ord,ordid)) q:ordid=""  d
 	..s aa=##class(DHCMGNUR.MgNurPerWard).%OpenId(ordid)
 	..s tempDep=aa.WardLoc
 	..q:((tempDep="9999")!(tempDep="9998")!(tempDep="9997"))
 	..s count1=0,count2=0,count3=0,count4=0,count5=0,count6=0,count7=0,count8=0,count9=0,count10=0,count11=0,countSum=0
 	..s PersonDepDR=tempDep
 	..s id="" f  s id=$O(^DHCMGNUR.MgPersonsI("Dep"," "_tempDep,id)) q:id=""  d
 	...s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
 	...q:a.PersonType2'="N"
 	...q:a.PersonSexDR'="2"
 	...if a.PersonSexDR="2" d //男性护士
 	....i a.PersonShoeNO.Code="34" s count1=count1+1
 	....i a.PersonShoeNO.Code="35" s count2=count2+1
 	....i a.PersonShoeNO.Code="36" s count3=count3+1
 	....i a.PersonShoeNO.Code="37" s count4=count4+1
 	....i a.PersonShoeNO.Code="38" s count5=count5+1
 	....i a.PersonShoeNO.Code="39" s count6=count6+1
 	....i a.PersonShoeNO.Code="40" s count7=count7+1
 	....i a.PersonShoeNO.Code="41" s count8=count8+1
 	....i a.PersonShoeNO.Code="42" s count9=count9+1
 	....i a.PersonShoeNO.Code="43" s count10=count10+1
 	....i a.PersonShoeNO.Code="44" s count11=count11+1
 	..s countSum=count1+count2+count3+count4+count5+count6+count7+count8+count9+count10+count11 //男性合计
 	..s PersonDepDR=$TR(PersonDepDR," ","")
 	..i PersonDepDR'="" s PersonDepDR=$P(^CTLOC(PersonDepDR),"^",2)
 	..e  s PersonDepDR=""
 	..d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(PersonDepDR,count1,count2,count3,count4,count5,count6,count7,count8,count9,count10,count11,countSum)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod SearchMShoeNOFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchMShoeNOExecute ]
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

ClassMethod SearchMShoeNOClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchMShoeNOExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// 
/// 按病区统计女护士鞋号分布
/// 
Query SearchWShoeNO() As %Query(ROWSPEC = "PersonDepDR,count1,count2,count3,count4,count5,count6,count7,count8,count9,count10,count11,countSum") [ SqlProc ]
{
}

ClassMethod SearchWShoeNOExecute(ByRef qHandle As %Binary) As %Status
{
	//w ##class(%ResultSet).RunQuery("web.DHCMgNurStatDistibute","SearchWShoeNO")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	;s tempDep="" f  s tempDep=$O(^DHCMGNUR.MgNurPerWardI("WardLoc",tempDep)) q:tempDep=""  d
 	s ord="" f  s ord=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",ord)) q:ord=""  d
 	.s ordid="" f  s ordid=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",ord,ordid)) q:ordid=""  d
 	..s aa=##class(DHCMGNUR.MgNurPerWard).%OpenId(ordid)
 	..s tempDep=aa.WardLoc
 	..q:((tempDep="9999")!(tempDep="9998")!(tempDep="9997"))
 	..s count1=0,count2=0,count3=0,count4=0,count5=0,count6=0,count7=0,count8=0,count9=0,count10=0,count11=0,countSum=0
 	..s PersonDepDR=tempDep
 	..s id="" f  s id=$O(^DHCMGNUR.MgPersonsI("Dep"," "_tempDep,id)) q:id=""  d
 	...s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
 	...q:a.PersonType2'="N"
 	...q:a.PersonSexDR'="1"
 	...if a.PersonSexDR="1" d //女性护士
 	....i a.PersonShoeNO.Code="34" s count1=count1+1
 	....i a.PersonShoeNO.Code="35" s count2=count2+1
 	....i a.PersonShoeNO.Code="36" s count3=count3+1
 	....i a.PersonShoeNO.Code="37" s count4=count4+1
 	....i a.PersonShoeNO.Code="38" s count5=count5+1
 	....i a.PersonShoeNO.Code="39" s count6=count6+1
 	....i a.PersonShoeNO.Code="40" s count7=count7+1
 	....i a.PersonShoeNO.Code="41" s count8=count8+1
 	....i a.PersonShoeNO.Code="42" s count9=count9+1
 	....i a.PersonShoeNO.Code="43" s count10=count10+1
 	....i a.PersonShoeNO.Code="44" s count11=count11+1
 	..s countSum=count1+count2+count3+count4+count5+count6+count7+count8+count9+count10+count11 //女性合计
 	..s PersonDepDR=$TR(PersonDepDR," ","")
 	..i PersonDepDR'="" s PersonDepDR=$P(^CTLOC(PersonDepDR),"^",2)
 	..e  s PersonDepDR=""
 	..d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(PersonDepDR,count1,count2,count3,count4,count5,count6,count7,count8,count9,count10,count11,countSum)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod SearchWShoeNOFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchWShoeNOExecute ]
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

ClassMethod SearchWShoeNOClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchWShoeNOExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// 
/// 按病区统计女护士衣号分布
/// 
Query SearchClothesNO() As %Query(ROWSPEC = "PersonDepDR,countL,countM,countS,countXL,countXXL,countXXXL,countSum") [ SqlProc ]
{
}

ClassMethod SearchClothesNOExecute(ByRef qHandle As %Binary) As %Status
{
	//w ##class(%ResultSet).RunQuery("web.DHCMgNurStatDistibute","SearchClothesNO")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	;s tempDep="" f  s tempDep=$O(^DHCMGNUR.MgNurPerWardI("WardLoc",tempDep)) q:tempDep=""  d
 	s ord="" f  s ord=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",ord)) q:ord=""  d
 	.s ordid="" f  s ordid=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",ord,ordid)) q:ordid=""  d
 	..s aa=##class(DHCMGNUR.MgNurPerWard).%OpenId(ordid)
 	..s tempDep=aa.WardLoc
 	..q:((tempDep="9999")!(tempDep="9998")!(tempDep="9997"))
 	..s countL=0,countM=0,countS=0,countXL=0,countXXL=0,countXXXL=0,countSum=0
 	..s PersonDepDR=tempDep
 	..s id="" f  s id=$O(^DHCMGNUR.MgPersonsI("Dep"," "_tempDep,id)) q:id=""  d
 	...s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
 	...q:a.PersonType2'="N"
 	...q:a.PersonSexDR="2" //不包括男性护士
 	...i a.PersonClothesNO.Code="L" s countL=countL+1
 	...i a.PersonClothesNO.Code="M" s countM=countM+1
 	...i a.PersonClothesNO.Code="S" s countS=countS+1
 	...i a.PersonClothesNO.Code="XL" s countXL=countXL+1
 	...i a.PersonClothesNO.Code="XXL" s countXXL=countXXL+1
 	...i a.PersonClothesNO.Code="XXXL" s countXXXL=countXXXL+1
 	..s countSum=countL+countM+countS+countXL+countXXL+countXXXL
 	..s PersonDepDR=$TR(PersonDepDR," ","")
 	..i PersonDepDR'="" s PersonDepDR=$P(^CTLOC(PersonDepDR),"^",2)
 	..e  s PersonDepDR=""
 	..d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(PersonDepDR,countL,countM,countS,countXL,countXXL,countXXXL,countSum)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod SearchClothesNOFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchClothesNOExecute ]
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

ClassMethod SearchClothesNOClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchClothesNOExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// 
/// 按病区统计男护士衣号分布
/// 
Query SearchMClothesNO() As %Query(ROWSPEC = "PersonDepDR,countL,countM,countS,countXL,countXXL,countXXXL,countSum") [ SqlProc ]
{
}

ClassMethod SearchMClothesNOExecute(ByRef qHandle As %Binary) As %Status
{
	//w ##class(%ResultSet).RunQuery("web.DHCMgNurStatDistibute","SearchMClothesNO")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	;s tempDep="" f  s tempDep=$O(^DHCMGNUR.MgNurPerWardI("WardLoc",tempDep)) q:tempDep=""  d
 	s ord="" f  s ord=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",ord)) q:ord=""  d
 	.s ordid="" f  s ordid=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",ord,ordid)) q:ordid=""  d
 	..s aa=##class(DHCMGNUR.MgNurPerWard).%OpenId(ordid)
 	..s tempDep=aa.WardLoc
 	..q:((tempDep="9999")!(tempDep="9998")!(tempDep="9997"))
 	..s countL=0,countM=0,countS=0,countXL=0,countXXL=0,countXXXL=0,countSum=0
 	..s PersonDepDR=tempDep
 	..s id="" f  s id=$O(^DHCMGNUR.MgPersonsI("Dep"," "_tempDep,id)) q:id=""  d
 	...s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
 	...q:a.PersonType2'="N"
 	...q:a.PersonSexDR="1" //不包括女性护士
 	...i a.PersonClothesNO.Code="L" s countL=countL+1
 	...i a.PersonClothesNO.Code="M" s countM=countM+1
 	...i a.PersonClothesNO.Code="S" s countS=countS+1
 	...i a.PersonClothesNO.Code="XL" s countXL=countXL+1
 	...i a.PersonClothesNO.Code="XXL" s countXXL=countXXL+1
 	...i a.PersonClothesNO.Code="XXXL" s countXXXL=countXXXL+1
 	..s countSum=countL+countM+countS+countXL+countXXL+countXXXL
 	..s PersonDepDR=$TR(PersonDepDR," ","")
 	..i PersonDepDR'="" s PersonDepDR=$P(^CTLOC(PersonDepDR),"^",2)
 	..e  s PersonDepDR=""
 	..d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(PersonDepDR,countL,countM,countS,countXL,countXXL,countXXXL,countSum)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod SearchMClothesNOFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchMClothesNOExecute ]
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

ClassMethod SearchMClothesNOClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchMClothesNOExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

///  
///  按病区统计护士学历分布
///  
/// do ##class(%ResultSet).RunQuery("web.DHCMgNurStatDistibute","CountNurEduBackground")
Query CountNurEduBackground() As %Query(ROWSPEC = "WardCode,count1,count2,count3,count4,count5,count") [ SqlProc ]
{
}

ClassMethod CountNurEduBackgroundExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s count=0
	s ord="" f  s ord=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",ord)) q:ord=""  d
 	.s ordid="" f  s ordid=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",ord,ordid)) q:ordid=""  d
 	..s aa=##class(DHCMGNUR.MgNurPerWard).%OpenId(ordid)
 	..s WardRowId=aa.WardLoc
	..q:((WardRowId="9999")!(WardRowId="9998")!(WardRowId="9997"))
	..set CommDictionaryCode=""
	..for  set CommDictionaryCode=$O(^DHCMGNUR.CommDictionarySubI("Code",CommDictionaryCode)) q:CommDictionaryCode=""  do
	...set CommDictionaryId=""
	...for  set CommDictionaryId=$O(^DHCMGNUR.CommDictionarySubI("Code",CommDictionaryCode,19,CommDictionaryId)) q:CommDictionaryId=""  do
	....set CommDictionaryObj = ##class(DHCMGNUR.CommDictionarySub).%OpenId("19||"_CommDictionaryId)
	....set CommDictionaryDesc =CommDictionaryObj.CodeDesc
	....set Count(CommDictionaryDesc)=0
	..if WardRowId'=" " do
	...;set WardId = $P(WardRowId," ",2)
	...set WardCode = $P(^CTLOC(WardRowId),"^",2)
	...set WardDesc = $P(^CTLOC(WardRowId),"^",2)
	..else  set WardCode=" " set WardDesc=" "
	..set PersonRowId = ""
	..for  set PersonRowId=$O(^DHCMGNUR.MgPersonsI("Dep"," "_WardRowId,PersonRowId)) q:PersonRowId=""  do
	...set PersonObj = ##class(DHCMGNUR.MgPersons).%OpenId(PersonRowId)
	...q:PersonObj.PersonType2'="N"
	...set PersonSchoolAgeDr =  PersonObj.PersonSchoolAgeDr
	...;set CommDicObj = ##class(DHCMGNUR.CommDictionarySub).%OpenId(PersonSchoolAgeDr)
	...q:PersonSchoolAgeDr=""
	...set CommDicDesc = PersonSchoolAgeDr.CodeDesc
	...set Count(CommDicDesc) = Count(CommDicDesc)+1
	..set count=Count("中专")+Count("大专")+Count("本科")+Count("研究生")+Count("高中")
	..Do OutputRow
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow      
	set Data=$lb(WardCode,Count("高中"),Count("中专"),Count("大专"),Count("本科"),Count("研究生"),count)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod CountNurEduBackgroundClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CountNurEduBackgroundExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod CountNurEduBackgroundFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CountNurEduBackgroundExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// 按病区对聘任职称统计分布
Query PersonAppDutSatistic() As %Query(ROWSPEC = "PersonDepDR,count1,count2,count3,count4,count5,count6,count") [ SqlProc ]
{
}

ClassMethod PersonAppDutSatisticExecute(ByRef qHandle As %Binary) As %Status
{
	//w ##class(%ResultSet).RunQuery("web.DHCMgNurStatDistibute","PersonAppDutSatistic")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	;s tempDep="" f  s tempDep=$O(^DHCMGNUR.MgNurPerWardI("WardLoc",tempDep)) q:tempDep=""  d
 	s ord="" f  s ord=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",ord)) q:ord=""  d
 	.s ordid="" f  s ordid=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",ord,ordid)) q:ordid=""  d
 	..s aa=##class(DHCMGNUR.MgNurPerWard).%OpenId(ordid)
 	..s tempDep=aa.WardLoc
 	..q:((tempDep="9999")!(tempDep="9998")!(tempDep="9997"))
 	..s count1=0,count2=0,count3=0,count4=0,count5=0,count6=0,count=0
 	..s PersonDepDR=tempDep
 	..s id="" f  s id=$O(^DHCMGNUR.MgPersonsI("Dep"," "_tempDep,id)) q:id=""  d
 	...s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
 	...q:a.PersonType2'="N"
 	...i a.PersonAppDutyDR.CodeDesc="主任护师" s count1=count1+1 //主任护师
 	...i a.PersonAppDutyDR.CodeDesc="主管护师" s count2=count2+1 	//主管护师
 	...i a.PersonAppDutyDR.CodeDesc="副主任护师" s count3=count3+1 	//副主任护师
 	...i a.PersonAppDutyDR.CodeDesc="护士" s count4=count4+1 	//护士
 	...i a.PersonAppDutyDR.CodeDesc="护师" s count5=count5+1 	//护师
 	...i a.PersonAppDutyDR.CodeDesc="未定级" s count6=count6+1 	//未定级
 	..s count=count1+count2+count3+count4+count5+count6
 	..s PersonDepDR=$TR(PersonDepDR," ","")
 	..i PersonDepDR'="" s PersonDepDR=$P(^CTLOC(PersonDepDR),"^",2)
 	..e  s PersonDepDR=""
 	..d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(PersonDepDR,count1,count2,count3,count4,count5,count6,count)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod PersonAppDutSatisticFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PersonAppDutSatisticExecute ]
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

ClassMethod PersonAppDutSatisticClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PersonAppDutSatisticExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// 
/// 按病区统计工作科室分布
/// 
Query PersonPostTypSatistic() As %Query(ROWSPEC = "PersonDepDR,count1,count2,count3,count4,count5,count6,count7,count8,count9,count10,count") [ SqlProc ]
{
}

ClassMethod PersonPostTypSatisticExecute(ByRef qHandle As %Binary) As %Status
{
	//w ##class(%ResultSet).RunQuery("web.DHCMgNurStatDistibute","PersonPostTypSatistic")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	;s tempDep="" f  s tempDep=$O(^DHCMGNUR.MgNurPerWardI("WardLoc",tempDep)) q:tempDep=""  d
 	s ord="" f  s ord=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",ord)) q:ord=""  d
 	.s ordid="" f  s ordid=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",ord,ordid)) q:ordid=""  d
 	..s aa=##class(DHCMGNUR.MgNurPerWard).%OpenId(ordid)
 	..s tempDep=aa.WardLoc
 	..q:((tempDep="9999")!(tempDep="9998")!(tempDep="9997"))
 	..s count1=0,count2=0,count3=0,count4=0,count5=0,count6=0,count7=0,count8=0,count9=0,count10=0,count=0
 	..s PersonDepDR=tempDep
 	..s id="" f  s id=$O(^DHCMGNUR.MgPersonsI("Dep"," "_tempDep,id)) q:id=""  d
 	...s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
 	...q:a.PersonType2'="N"
 	...i a.PersonPostTyp.CodeDesc="病房" s count1=count1+1
 	...i a.PersonPostTyp.CodeDesc="门诊" s count2=count2+1
 	...i a.PersonPostTyp.CodeDesc="急诊" s count3=count3+1
 	...i a.PersonPostTyp.CodeDesc="ICU" s count4=count4+1
 	...i a.PersonPostTyp.CodeDesc="手术室" s count5=count5+1
 	...i a.PersonPostTyp.CodeDesc="社区护理" s count6=count6+1
 	...i a.PersonPostTyp.CodeDesc="供应室" s count7=count7+1
 	...i a.PersonPostTyp.CodeDesc="护理部" s count8=count8+1
 	...i a.PersonPostTyp.CodeDesc="医技科室" s count9=count9+1
 	...i a.PersonPostTyp.CodeDesc="其他" s count10=count10+1
 	..s count=count1+count2+count3+count4+count5+count6+count7+count8+count9+count10
 	..s PersonDepDR=$TR(PersonDepDR," ","")
 	..i PersonDepDR'="" s PersonDepDR=$P(^CTLOC(PersonDepDR),"^",2)
 	..e  s PersonDepDR=""
 	..d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(PersonDepDR,count1,count2,count3,count4,count5,count6,count7,count8,count9,count10,count)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod PersonPostTypSatisticFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PersonPostTypSatisticExecute ]
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

ClassMethod PersonPostTypSatisticClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PersonPostTypSatisticExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// 
/// 按病区对护士职务分布统计
/// 
Query PersonHSDRSati() As %Query(ROWSPEC = "PersonDepDR,count1,count2,count3,count4,count5,count") [ SqlProc ]
{
}

ClassMethod PersonHSDRSatiExecute(ByRef qHandle As %Binary) As %Status
{
	//w ##class(%ResultSet).RunQuery("web.DHCMgNurStatDistibute","PersonHSDRSati")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	;s tempDep="" f  s tempDep=$O(^DHCMGNUR.MgNurPerWardI("WardLoc",tempDep)) q:tempDep=""  d
 	s ord="" f  s ord=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",ord)) q:ord=""  d
 	.s ordid="" f  s ordid=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",ord,ordid)) q:ordid=""  d
 	..s aa=##class(DHCMGNUR.MgNurPerWard).%OpenId(ordid)
 	..s tempDep=aa.WardLoc
 	..q:((tempDep="9999")!(tempDep="9998")!(tempDep="9997"))
 	..s count1=0,count2=0,count3=0,count4=0,count5=0,count=0
 	..s PersonDepDR=tempDep
 	..s id="" f  s id=$O(^DHCMGNUR.MgPersonsI("Dep"," "_tempDep,id)) q:id=""  d
 	...s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
 	...q:a.PersonType2'="N"
 	...i a.PersonheadshipDR.CodeDesc="副护士长" s count1=count1+1 //副护士长
 	...i a.PersonheadshipDR.CodeDesc="护士长" s count2=count2+1 	//护士长
 	...i a.PersonheadshipDR.CodeDesc="科护士长" s count3=count3+1 	//科护士长
 	...i a.PersonheadshipDR.CodeDesc="护理部副主任" s count4=count4+1 	//护理部副主任
 	...i a.PersonheadshipDR.CodeDesc="护理部主任" s count5=count5+1 	//护理部主任
 	..s count=count1+count2+count3+count4+count5
 	..s PersonDepDR=$TR(PersonDepDR," ","")
 	..i PersonDepDR'="" s PersonDepDR=$P(^CTLOC(PersonDepDR),"^",2)
 	..e  s PersonDepDR=""
 	..d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(PersonDepDR,count1,count2,count3,count4,count5,count)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod PersonHSDRSatiFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PersonHSDRSatiExecute ]
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

ClassMethod PersonHSDRSatiClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PersonHSDRSatiExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// 
/// 按病区统计护士工作类别分布
/// 
Query SearchWorkTyp() As %Query(ROWSPEC = "PersonDepDR,count1,count2,countSum") [ SqlProc ]
{
}

ClassMethod SearchWorkTypExecute(ByRef qHandle As %Binary) As %Status
{
	//w ##class(%ResultSet).RunQuery("web.DHCMgNurStatDistibute","SearchWorkTyp")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	;s tempDep="" f  s tempDep=$O(^DHCMGNUR.MgNurPerWardI("WardLoc",tempDep)) q:tempDep=""  d
 	s ord="" f  s ord=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",ord)) q:ord=""  d
 	.s ordid="" f  s ordid=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",ord,ordid)) q:ordid=""  d
 	..s aa=##class(DHCMGNUR.MgNurPerWard).%OpenId(ordid)
 	..s tempDep=aa.WardLoc
 	..q:((tempDep="9999")!(tempDep="9998")!(tempDep="9997"))
 	..s count1=0,count2=0
 	..s PersonDepDR=tempDep
 	..s id="" f  s id=$O(^DHCMGNUR.MgPersonsI("Dep"," "_tempDep,id)) q:id=""  d
 	...s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
 	...q:a.PersonType2'="N"
 	...i a.PersonWorkType ="1" s count1=count1+1   //临床
 	...i a.PersonWorkType ="2" s count2=count2+1 //非临床 
 	..s countSum=count1+count2 //合计
 	..s PersonDepDR=$TR(PersonDepDR," ","")
 	..i PersonDepDR'="" s PersonDepDR=$P(^CTLOC(PersonDepDR),"^",2)
 	..e  s PersonDepDR=""
 	..d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(PersonDepDR,count1,count2,countSum)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod SearchWorkTypFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchWorkTypExecute ]
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

ClassMethod SearchWorkTypClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchWorkTypExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// 根据出生日计算年龄
ClassMethod CalAge(IBirth As %String, IToday As %String)
{
	//b ;1109
    s IBirth=$g(IBirth),IToday=$g(IToday)
    i IBirth>2980000 s IBirth=""
    i IBirth<0 s IBirth=""
    q:'$G(IBirth) ""
    s XBirth=$ZD(IBirth)
    s XToday=$ZD(IToday)
    s AgeMth=XToday-XBirth
    s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
    s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
    s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
    s AgeYear=CurrYear-BirthYear
    i AgeDay<0 d
        . s AgeMth=AgeMth-1
	    . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
	    . q:XToday'=2
	    . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
	i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
	s $P(AgeYr,"|",12)=AgeYear
	s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
	q reage
}

/// 
/// 按病区统计护士工作年限分布
/// 
Query SearchWorkYear() As %Query(ROWSPEC = "PersonDepDR,count1,count2,count3,count4,count5,count6,count7,count8,count9,count10,countSum") [ SqlProc ]
{
}

ClassMethod SearchWorkYearExecute(ByRef qHandle As %Binary) As %Status
{
	//w ##class(%ResultSet).RunQuery("web.DHCMgNurStatDistibute","SearchWorkYear")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	;s tempDep="" f  s tempDep=$O(^DHCMGNUR.MgNurPerWardI("WardLoc",tempDep)) q:tempDep=""  d
 	s ord="" f  s ord=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",ord)) q:ord=""  d
 	.s ordid="" f  s ordid=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",ord,ordid)) q:ordid=""  d
 	..s aa=##class(DHCMGNUR.MgNurPerWard).%OpenId(ordid)
 	..s tempDep=aa.WardLoc
 	..;w !,tempDep
 	..q:((tempDep="9999")!(tempDep="9998")!(tempDep="9997"))
 	..s count1=0,count2=0,count3=0,count4=0,count5=0,count6=0,count7=0,count8=0,count9=0,count10=0
 	..s PersonDepDR=tempDep
 	..s id="" f  s id=$O(^DHCMGNUR.MgPersonsI("Dep"," "_tempDep,id)) q:id=""  d
 	...s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
 	...q:a.PersonType2'="N"
 	...q:a.PersonWorkDateTime=""
 	...i a.PersonWorkDateTime'="" s PersonWorkDateTime=$P(..CalAge(a.PersonWorkDateTime,+$H),"Y",1) //工作年限
 	...;w !,PersonWorkDateTime
 	...;i PersonWorkDateTime =1 s count1=count1+1 //新员工
 	...i PersonWorkDateTime =2 s count2=count2+1 //2年 
 	...e  i PersonWorkDateTime =3 s count3=count3+1 //3年
 	...e  i PersonWorkDateTime =4 s count4=count4+1 //4年
 	...e  i PersonWorkDateTime =5 s count5=count5+1 //5年
 	...e  i PersonWorkDateTime =6 s count6=count6+1 //6年
 	...e  i PersonWorkDateTime =7 s count7=count7+1 //7年
 	...e  i PersonWorkDateTime =8 s count8=count8+1 //8年
 	...e  i PersonWorkDateTime =9 s count9=count9+1 //9年
 	...e  i PersonWorkDateTime >=10 s count10=count10+1 //10年及以上
 	...e  s count1=count1+1 //新员工
 	...;w !,count10
 	..s countSum=count1+count2+count3+count4+count5+count6+count7+count8+count9+count10 //合计
 	..s PersonDepDR=$TR(PersonDepDR," ","")
 	..i PersonDepDR'="" s PersonDepDR=$P(^CTLOC(PersonDepDR),"^",2)
 	..e  s PersonDepDR=""
 	..d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(PersonDepDR,count1,count2,count3,count4,count5,count6,count7,count8,count9,count10,countSum)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod SearchWorkYearFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchWorkYearExecute ]
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

ClassMethod SearchWorkYearClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchWorkYearExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// 
/// 按病区统计护士平均年龄分布
/// 
Query SearchAvgAge() As %Query(ROWSPEC = "PersonDepDR,count1,count2,count3,count4,count5,count,Avg") [ SqlProc ]
{
}

ClassMethod SearchAvgAgeExecute(ByRef qHandle As %Binary) As %Status
{
	//w ##class(%ResultSet).RunQuery("web.DHCMgNurStatDistibute","SearchAvgAge")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	;s tempDep="" f  s tempDep=$O(^DHCMGNUR.MgNurPerWardI("WardLoc",tempDep)) q:tempDep=""  d
 	s ord="" f  s ord=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",ord)) q:ord=""  d
 	.s ordid="" f  s ordid=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",ord,ordid)) q:ordid=""  d
 	..s aa=##class(DHCMGNUR.MgNurPerWard).%OpenId(ordid)
 	..s tempDep=aa.WardLoc
 	..s count1(tempDep)=0,count2(tempDep)=0,count3(tempDep)=0,count4(tempDep)=0,count5(tempDep)=0,count(tempDep)=0,sum(tempDep)=0,Avg(tempDep)=0
 	..q:((tempDep="9999")!(tempDep="9998")!(tempDep="9997"))
 	..s count1=0,count2=0,count3=0,count4=0,count5=0,count6=0,count7=0,count8=0,count9=0,count10=0
 	..s PersonDepDR=tempDep
 	..s id="" f  s id=$O(^DHCMGNUR.MgPersonsI("Dep"," "_tempDep,id)) q:id=""  d
 	...s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
 	...q:a.PersonType2'="N"
 	...i a.PersonBirthDay'="" s PersonBirthDay=$P(..CalAge(a.PersonBirthDay,+$H),"Y",1) //年龄
 	...;w !,PersonBirthDay
 	...i PersonBirthDay <20 s count1(tempDep)=count1(tempDep)+1,sum(tempDep)=sum(tempDep)+PersonBirthDay //20岁以下
 	...e  i PersonBirthDay <30 s count2(tempDep)=count2(tempDep)+1,sum(tempDep)=sum(tempDep)+PersonBirthDay //20-30(不含30) 
 	...e  i PersonBirthDay <40 s count3(tempDep)=count3(tempDep)+1,sum(tempDep)=sum(tempDep)+PersonBirthDay //30-40(不含40)
 	...e  i PersonBirthDay <50 s count4(tempDep)=count4(tempDep)+1,sum(tempDep)=sum(tempDep)+PersonBirthDay //40-50(不含50)
 	...e  s count5(tempDep)=count5(tempDep)+1,sum(tempDep)=sum(tempDep)+PersonBirthDay //50及以上
 	..s count(tempDep)=count1(tempDep)+count2(tempDep)+count3(tempDep)+count4(tempDep)+count5(tempDep)
 	..i count(tempDep)'=0 s Avg(tempDep)=sum(tempDep)/count(tempDep)
 	..e  set Avg(tempDep)=0
 	..set Avg(tempDep)=$FN(Avg(tempDep),"P",0)
 	..s PersonDepDR=$TR(PersonDepDR," ","")
 	..i PersonDepDR'="" s PersonDepDR=$P(^CTLOC(PersonDepDR),"^",2)
 	..e  s PersonDepDR=""
 	..d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(PersonDepDR,count1(tempDep),count2(tempDep),count3(tempDep),count4(tempDep),count5(tempDep),count(tempDep),Avg(tempDep))
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod SearchAvgAgeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchAvgAgeExecute ]
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

ClassMethod SearchAvgAgeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchAvgAgeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// 按病区统计护士学历分布
/// 
Query SearchSchoolAge() As %Query(ROWSPEC = "PersonDepDR,count1,count2,count3,count4,count5,count6,count7,count8,count9,count10") [ SqlProc ]
{
}

ClassMethod SearchSchoolAgeExecute(ByRef qHandle As %Binary) As %Status
{
	//w ##class(%ResultSet).RunQuery("web.DHCMgNurStatDistibute","SearchSchoolAge")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	;s tempDep="" f  s tempDep=$O(^DHCMGNUR.MgNurPerWardI("WardLoc",tempDep)) q:tempDep=""  d
 	s ord="" f  s ord=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",ord)) q:ord=""  d
 	.s ordid="" f  s ordid=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",ord,ordid)) q:ordid=""  d
 	..s aa=##class(DHCMGNUR.MgNurPerWard).%OpenId(ordid)
 	..s tempDep=aa.WardLoc
 	..q:((tempDep="9999")!(tempDep="9998")!(tempDep="9997"))
 	..s count1=0,count2=0,count3=0,count4=0,count5=0,count6=0,count7=0,count8=0,count9=0,count10=0
 	..s PersonDepDR=tempDep
 	..s id="" f  s id=$O(^DHCMGNUR.MgPersonsI("Dep"," "_tempDep,id)) q:id=""  d
 	...s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
 	...q:a.PersonType2'="N"
 	...s PersonSchoolAge=a.PersonSchoolAgeDr.CodeDesc
 	...s PersonID=a.PersonID 
 	...if PersonSchoolAge="中专"  s count1=count1+1
 	...if PersonSchoolAge="大专"  s count2=count2+1
 	...if PersonSchoolAge="本科"  s count3=count3+1
 	...if PersonSchoolAge="三本"  s count3=count3+1
 	...if PersonSchoolAge="研究生"  s count4=count4+1
 	...;s lcode="" s lcode=$O(^DHCMGNUR.MgNurLeaExpI("PerID"," "_PersonID,lcode)) q:lcode=""  d
 	....;set lid="" s lid=$O(^DHCMGNUR.MgNurLeaExpI("PerID"," "_PersonID,lcode,lid)) q:lid=""  d
 	...s PersonSchoolHighAge=""
	...s PersonHighDegree=""
	...s leaExpStDate=$O(^DHCMGNUR.MgNurLeaExpI("DataSort"," "_PersonID,""),-1)
	...i leaExpStDate'=""  d
	....s leaExpPar="" f  s leaExpPar=$O(^DHCMGNUR.MgNurLeaExpI("DataSort"," "_PersonID,leaExpStDate,leaExpPar)) q:leaExpPar=""  d
	.....s leaExpRw="" f  s leaExpRw=$O(^DHCMGNUR.MgNurLeaExpI("DataSort"," "_PersonID,leaExpStDate,leaExpPar,leaExpRw)) q:leaExpRw=""  d
 	......s aaa=##class(DHCMGNUR.MgNurLeaExp).%OpenId(leaExpPar_"||"_leaExpRw)
 	......s LPersonSchoolAge=aaa.PerSchoolAgeDr.CodeDesc
 	......if LPersonSchoolAge="中专"  s count6=count6+1
 	......if LPersonSchoolAge="大专"  s count7=count7+1
 	......if LPersonSchoolAge="本科"  s count8=count8+1
 	......if LPersonSchoolAge="三本"  s count8=count8+1
 	......if LPersonSchoolAge="研究生"  s count9=count9+1
 	..set count5=count1+count2+count3+count4
 	..set count10=count6+count7+count8+count9
 	..s PersonDepDR=$TR(PersonDepDR," ","")
 	..i PersonDepDR'="" s PersonDepDR=$P(^CTLOC(PersonDepDR),"^",2)
 	..e  s PersonDepDR=""
 	..d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowtyp
	set Data=$lb(PersonDepDR,count1,count2,count3,count4,count5,count6,count7,count8,count9,count10)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod SearchSchoolAgeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchSchoolAgeExecute ]
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

ClassMethod SearchSchoolAgeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchSchoolAgeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

// d ##class(%ResultSet).RunQuery("web.DHCMgNurStatDistibute","FindpersonBySchoolAge","内科门诊")

/// 按科室根据最终学历中专查询护士详细信息
Query FindpersonBySchoolAge(tempDep As %String) As %Query(ROWSPEC = "PersonDepDR,PersonID,PersonName,PersonSexDR,LPersonSchoolAge") [ SqlProc ]
{
}

ClassMethod FindpersonBySchoolAgeExecute(ByRef qHandle As %Binary, tempDep As %String) As %Status
{
	//w ##class(%ResultSet).RunQuery("web.DHCMgNurStatDistibute","SearchSchoolAge")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ord="" f  s ord=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",ord)) q:ord=""  d
 	.s ordid="" f  s ordid=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",ord,ordid)) q:ordid=""  d
 	..s aa=##class(DHCMGNUR.MgNurPerWard).%OpenId(ordid)
 	..s tempDepDR=aa.WardLoc
 	..q:((tempDepDR="9999")!(tempDepDR="9998")!(tempDepDR="9997"))
 	..s PersonDepDR=tempDepDR
 	..s PersonDepDR=$TR(PersonDepDR," ","")
 	..i PersonDepDR'="" s PersonDepDR=$P(^CTLOC(PersonDepDR),"^",2)
 	..;b ;110
 	..e  s PersonDepDR=""
 	..i tempDep=PersonDepDR d
 	...s id="" f  s id=$O(^DHCMGNUR.MgPersonsI("Dep"," "_tempDepDR,id)) q:id=""  d
 	....s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
 	....q:a.PersonType2'="N"
 	....s PersonSchoolAge=a.PersonSchoolAgeDr.CodeDesc
 	....s PersonID=a.PersonID 
 	....s PersonName=a.PersonName
 	....s PersonSexDR=a.PersonSexDR
 	....i PersonSexDR="2" s PersonSexDR="男"
 	....i PersonSexDR="1" s PersonSexDR="女"
 	....s PersonSchoolHighAge=""
	....s PersonHighDegree=""
	....s leaExpStDate=$O(^DHCMGNUR.MgNurLeaExpI("DataSort"," "_PersonID,""),-1)
	....i leaExpStDate'=""  d
	.....s leaExpPar="" f  s leaExpPar=$O(^DHCMGNUR.MgNurLeaExpI("DataSort"," "_PersonID,leaExpStDate,leaExpPar)) q:leaExpPar=""  d
	......s leaExpRw="" f  s leaExpRw=$O(^DHCMGNUR.MgNurLeaExpI("DataSort"," "_PersonID,leaExpStDate,leaExpPar,leaExpRw)) q:leaExpRw=""  d
 	.......s aaa=##class(DHCMGNUR.MgNurLeaExp).%OpenId(leaExpPar_"||"_leaExpRw)
 	.......s LPersonSchoolAge=aaa.PerSchoolAgeDr.CodeDesc
 	....if LPersonSchoolAge="中专" DO OutRowtyp
 	..i tempDep="全院" d
 	...s id="" f  s id=$O(^DHCMGNUR.MgPersonsI("Dep"," "_tempDepDR,id)) q:id=""  d
 	....s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
 	....q:a.PersonType2'="N"
 	....s PersonSchoolAge=a.PersonSchoolAgeDr.CodeDesc
 	....s PersonID=a.PersonID 
 	....s PersonName=a.PersonName
 	....s PersonSexDR=a.PersonSexDR
 	....i PersonSexDR="2" s PersonSexDR="男"
 	....i PersonSexDR="1" s PersonSexDR="女"
 	....s PersonSchoolHighAge=""
	....s PersonHighDegree=""
	....s leaExpStDate=$O(^DHCMGNUR.MgNurLeaExpI("DataSort"," "_PersonID,""),-1)
	....i leaExpStDate'=""  d
	.....s leaExpPar="" f  s leaExpPar=$O(^DHCMGNUR.MgNurLeaExpI("DataSort"," "_PersonID,leaExpStDate,leaExpPar)) q:leaExpPar=""  d
	......s leaExpRw="" f  s leaExpRw=$O(^DHCMGNUR.MgNurLeaExpI("DataSort"," "_PersonID,leaExpStDate,leaExpPar,leaExpRw)) q:leaExpRw=""  d
 	.......s aaa=##class(DHCMGNUR.MgNurLeaExp).%OpenId(leaExpPar_"||"_leaExpRw)
 	.......s LPersonSchoolAge=aaa.PerSchoolAgeDr.CodeDesc
 	....if LPersonSchoolAge="中专" DO OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowtyp
	set Data=$lb(PersonDepDR,PersonID,PersonName,PersonSexDR,LPersonSchoolAge)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod FindpersonBySchoolAgeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindpersonBySchoolAgeExecute ]
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

ClassMethod FindpersonBySchoolAgeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindpersonBySchoolAgeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// 按病区统计护士鞋号分布
Query SearchShoNO() As %Query(ROWSPEC = "PersonDepDR,count1,count2,count3,count4,count5,count6,count7,count8,count9,count10,count11,count12,count13,count14,count15,count16,count17,count18,count19,count20,count21,count22,countSum1,countSum2,countSum") [ SqlProc ]
{
}

ClassMethod SearchShoNOExecute(ByRef qHandle As %Binary) As %Status
{
	//w ##class(%ResultSet).RunQuery("web.DHCMgNurStatDistibute","SearchShoNO")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	;s tempDep="" f  s tempDep=$O(^DHCMGNUR.MgNurPerWardI("WardLoc",tempDep)) q:tempDep=""  d
 	s ord="" f  s ord=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",ord)) q:ord=""  d
 	.s ordid="" f  s ordid=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",ord,ordid)) q:ordid=""  d
 	..s aa=##class(DHCMGNUR.MgNurPerWard).%OpenId(ordid)
 	..s tempDep=aa.WardLoc
 	..q:((tempDep="9999")!(tempDep="9998")!(tempDep="9997"))
 	..s count1=0,count2=0,count3=0,count4=0,count5=0,count6=0,count7=0,count8=0,count9=0,count10=0,count11=0,countSum=0,count12=0,count13=0,count14=0,count15=0,count16=0,count17=0,count18=0,count19=0,count20=0,count21=0,count22=0,countSum1=0,countSum2=0
 	..s PersonDepDR=tempDep
 	..s id="" f  s id=$O(^DHCMGNUR.MgPersonsI("Dep"," "_tempDep,id)) q:id=""  d
 	...s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
 	...q:a.PersonType2'="N"
 	...if a.PersonSexDR="2" d //男性护士
 	....i a.PersonShoeNO.Code="34" s count1=count1+1
 	....i a.PersonShoeNO.Code="35" s count3=count3+1
 	....i a.PersonShoeNO.Code="36" s count5=count5+1
 	....i a.PersonShoeNO.Code="37" s count7=count7+1
 	....i a.PersonShoeNO.Code="38" s count9=count9+1
 	....i a.PersonShoeNO.Code="39" s count11=count11+1
 	....i a.PersonShoeNO.Code="40" s count13=count13+1
 	....i a.PersonShoeNO.Code="41" s count15=count15+1
 	....i a.PersonShoeNO.Code="42" s count17=count17+1
 	....i a.PersonShoeNO.Code="43" s count19=count19+1
 	....i a.PersonShoeNO.Code="44" s count21=count21+1
 	...e  d //女性护士
 	....i a.PersonShoeNO.Code="34" s count2=count2+1
 	....i a.PersonShoeNO.Code="35" s count4=count4+1
 	....i a.PersonShoeNO.Code="36" s count6=count6+1
 	....i a.PersonShoeNO.Code="37" s count8=count8+1
 	....i a.PersonShoeNO.Code="38" s count10=count10+1
 	....i a.PersonShoeNO.Code="39" s count12=count12+1
 	....i a.PersonShoeNO.Code="40" s count14=count14+1
 	....i a.PersonShoeNO.Code="41" s count16=count16+1
 	....i a.PersonShoeNO.Code="42" s count18=count18+1
 	....i a.PersonShoeNO.Code="43" s count20=count20+1
 	....i a.PersonShoeNO.Code="44" s count22=count22+1
 	..s countSum1=count1+count3+count5+count7+count9+count11+count13+count15+count17+count19+count21 //男性合计
 	..s countSum2=count2+count4+count6+count8+count10+count12+count14+count16+count18+count20+count22 //女性合计
 	..s countSum=countSum1+countSum2 //合计
 	..s PersonDepDR=$TR(PersonDepDR," ","")
 	..i PersonDepDR'="" s PersonDepDR=$P(^CTLOC(PersonDepDR),"^",2)
 	..e  s PersonDepDR=""
 	..d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(PersonDepDR,count1,count2,count3,count4,count5,count6,count7,count8,count9,count10,count11,count12,count13,count14,count15,count16,count17,count18,count19,count20,count21,count22,countSum1,countSum2,countSum)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod SearchShoNOFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchShoNOExecute ]
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

ClassMethod SearchShoNOClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchShoNOExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

}
