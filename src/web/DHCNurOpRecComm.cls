Class web.DHCNurOpRecComm Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod OpCheckRecExecute(ByRef qHandle As %Binary, AnaesId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//Set qHandle=$lb(0,repid,0) Quit $$$OK
	s id=""
	s ret=""
	f {
	 s id=$O(^Nur.DHCNurOpChecRecI("AnaesId"," "_AnaesId,id))
	 q:id=""
	 s ret=##class(Nur.DHCNurOpChecRec).getVal(id)

	 d OutRowtyp
  	}

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod OpCheckRecFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OpCheckRecExecute ]
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

ClassMethod OpCheckRecClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OpCheckRecExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

Query OpCheckRec(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod OpCheckRecPrnExecute(ByRef qHandle As %Binary, AnaesId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s mp("病室")=2
	s mp("手术室")=3
	s mp("ICU/PACU")=4
	s mp("回病室")=5

    S CP(1)="病历、CT/X片/MRI"
    S CP(2)="合血单"
    S CP(3)="备皮、皮肤情况"
    S CP(4)="术前用药"
    S CP(5)="术中带药"
    S CP(6)="贵重物品、假牙"
    S CP(7)="胸带、腹带、毛巾"
    S CP(8)="管道"
    S CP(9)="其它"
    S CP(10)="签名"

	s id=""
	s ret=""
	s tmp=""
	f {
	 s id=$O(^Nur.DHCNurOpChecRecI("AnaesId"," "_AnaesId,id))
	 q:id=""
	 s a=##class(Nur.DHCNurOpChecRec).%OpenId(id)
	 s col=mp(a.roomplace)
	 s tmp(1,col)=a.roomplace
     

	
	 s tmp(2,col)=a.CheckQt
	
	
 	 s tmp(3,col)=a.BloodDan 
	
	
	 s tmp(4,col)=a.OpPreMed
	
	
	 s tmp(5,col)=a.OpAfterMed
	
	
	 s tmp(6,col)=a.Gold
	
	//2
	 s tmp(7,col)=a.Skin /// 

	 s tmp(8,col)=a.Towel
	
	//8
	
	 s tmp(9,col)=a.Tube  
	 s tmp(10,col)=a.Qt
	
	 s tmp(11,col)=a.RecUser ///24     
  	}
  	S I=1
  	s rw=1  f  s rw=$O(tmp(rw)) q:rw=""  d
  	.s ret="Item1|"_$G(CP(I))_"^Item2|"_$G(tmp(rw,2))_"^Item3|"_$G(tmp(rw,3))_"^Item4|"_$g(tmp(rw,4))_"^Item5|"_$g(tmp(rw,5))
  	.S I=I+1
  	.d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod OpCheckRecPrnFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OpCheckRecPrnExecute ]
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

ClassMethod OpCheckRecPrnClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OpCheckRecPrnExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

Query OpCheckRecPrn(parr As %String) As %Query(ROWSPEC = "ret")
{
}

}
