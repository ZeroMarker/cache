Class web.DHCPE.ChargeLimit Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod GetOPChargeLimitInfo(UserId As %String)
{
	q:UserId="" "0^0"
	s OPFlag=0,ASChargedFlag=0
	i $g(^DHCPECFDataEx("DHCPEBaseData","OPChargeLimit","OPFlag",UserId))="Y" s OPFlag=1
	i $g(^DHCPECFDataEx("DHCPEBaseData","OPChargeLimit","ASChargedFlag",UserId))="Y" s ASChargedFlag=1
	q OPFlag_"^"_ASChargedFlag
}

Query FindChargeLimit(UserId As %String = "") As %Query(ROWSPEC = "TUserId:%String,TOPNumber:%String,TName:%String,TDFLimit:%String,TOPFlag:%String,TASChargedFlag:%String,TRoundingFeeMode:%String,TRoundingFeeModeID:%String")
{
}

ClassMethod FindChargeLimitExecute(ByRef qHandle As %Binary, UserId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	s SSUser=""
 	f  s SSUser=$o(^DHCPECFDataEx("DHCPEBaseData","OPChargeLimit","DF",SSUser)) q:SSUser=""  d
 	.q:(UserId'="")&&(UserId'=SSUser)
 	.s DFLimit=$g(^DHCPECFDataEx("DHCPEBaseData","OPChargeLimit","DF",SSUser))_"%"
 	.i DFLimit="0%" s DFLimit=""
 	.s OPFlag=$g(^DHCPECFDataEx("DHCPEBaseData","OPChargeLimit","OPFlag",SSUser))
 	.i OPFlag="Y" S OPFlag="是"
 	.e  S OPFlag="否"
 	.s ASChargedFlag=$g(^DHCPECFDataEx("DHCPEBaseData","OPChargeLimit","ASChargedFlag",SSUser))
 	.i ASChargedFlag="Y" S ASChargedFlag="是"
 	.e  S ASChargedFlag="否"
 	.S RoundingFeeModeID=$g(^DHCPESetting("DHCPE","RoundingFeeMode",SSUser))
 	.s RoundingFeeMode=..GetRoundingFeeModeDesc(SSUser)  
 	.s Name=$p($g(^SSU("SSUSR",SSUser)),"^",2)
 	.s Number=$p($g(^SSU("SSUSR",SSUser)),"^",1)
	.d FindBuild	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
FindBuild      
	set Data=$lb(SSUser,Number,Name,DFLimit,OPFlag,ASChargedFlag,RoundingFeeMode,RoundingFeeModeID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindChargeLimitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindChargeLimitExecute ]
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

ClassMethod FindChargeLimitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindChargeLimitExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod OPChargeLimit(Instring As %String)
{
	s DFLimit=0,UserId=""
	s UserId=$p(Instring,"^",1)
	q:UserId="" "NoUser"
	s DFLimit=+$p(Instring,"^",2)
	i $p(DFLimit,".",1)="" s DFLimit=0_DFLimit
	s OPFlag=$p(Instring,"^",3)
	s ASChargedFlag=$p(Instring,"^",4)
	s RoundingFeeMode=$p(Instring,"^",5)
	s ^DHCPECFDataEx("DHCPEBaseData","OPChargeLimit","DF",UserId)=DFLimit
	s ^DHCPECFDataEx("DHCPEBaseData","OPChargeLimit","OPFlag",UserId)=OPFlag
	s ^DHCPECFDataEx("DHCPEBaseData","OPChargeLimit","ASChargedFlag",UserId)=ASChargedFlag
   	s ^DHCPESetting("DHCPE","RoundingFeeMode",UserId)=RoundingFeeMode
	q 0
}

ClassMethod DFLimit(UserId As %String)
{
	s DFLimit=0
	i $d(^DHCPECFDataEx("DHCPEBaseData","OPChargeLimit","DF",UserId)) d
	.s DFLimit=$g(^DHCPECFDataEx("DHCPEBaseData","OPChargeLimit","DF",UserId))
	q DFLimit
}

ClassMethod DeleteOPChargeLimit(UserId As %String)
{
	q:UserId="" "" 
	s flag=""
	i $d(^DHCPECFDataEx("DHCPEBaseData","OPChargeLimit","DF",UserId)) d
	.k ^DHCPECFDataEx("DHCPEBaseData","OPChargeLimit","DF",UserId)
	.s flag=0
	i $d(^DHCPECFDataEx("DHCPEBaseData","OPChargeLimit","OPFlag",UserId)) d
	.k ^DHCPECFDataEx("DHCPEBaseData","OPChargeLimit","OPFlag",UserId)
	.s flag=0
	i $d(^DHCPECFDataEx("DHCPEBaseData","OPChargeLimit","ASChargedFlag",UserId)) d
	.k ^DHCPECFDataEx("DHCPEBaseData","OPChargeLimit","ASChargedFlag",UserId)
	.s flag=0
	i $d(^DHCPESetting("DHCPE","RoundingFeeMode",UserId)) d
	.k ^DHCPESetting("DHCPE","RoundingFeeMode",UserId)
	.s flag=0
	q flag
}

ClassMethod GetRoundingFeeModeDesc(UserId As %String)
{
	q:UserId="" ""
	s RoundingFeeModeDesc=""
	i $d(^DHCPESetting("DHCPE","RoundingFeeMode",UserId)) d
	.s RoundingFeeMode=$g(^DHCPESetting("DHCPE","RoundingFeeMode",UserId))
	.i RoundingFeeMode=0 s RoundingFeeModeDesc="不允许"
	.i RoundingFeeMode=1 s RoundingFeeModeDesc="个人收费允许"
	.i RoundingFeeMode=2 s RoundingFeeModeDesc="团体收费允许"
	.i RoundingFeeMode=3 s RoundingFeeModeDesc="个人和团体收费均允许"
	q RoundingFeeModeDesc
}

}
