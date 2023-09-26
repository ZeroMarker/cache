Class web.DHCPdaReturnDrug Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod GetBasUom(arcitmdr) As %String
{
	       s inci=$o(^INCI(0,"ARCIM_DR",$p(arcitmdr,"||",1),""))   
	       q:'inci ""
	       s basicuom=+$p(^INCI(inci,1),"^",10)
	       s baseuomdesc=$p(^CT("UOM",basicuom),"^",2)
	       q baseuomdesc
}

Query GetRequestDrug(StDate As %String, EndDate As %String, RequestNo As %String, Ward As %String, Status As %String) As %Query(ROWSPEC = "OpDateTim,ReqNo,PatName,BedCode,ArcimDes,ReclocDesc,ReqQty,ReQty,dispQty,BasUom,Status,ID")
{
}

ClassMethod GetRequestDrugExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, RequestNo As %String, Ward As %String, ReqStatus As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    Set qHandle=$lb(0,repid,0)
 	//"60732","60915","-1","578","0"
 	if ReqStatus="-1" 	Quit $$$OK
 	//s StDate="60696",EndDate=60915,RequestNo=-1,ReqStatus=0,Ward=578
 	for Date=StDate:1:EndDate
 	{
	  s rw=""  f  s rw=$O(^RETRQ(0,"Date",Date,rw)) q:rw=""  d
	  .s ReqNo=$P(^RETRQ(rw),"^",1)
	  .i (ReqNo'=RequestNo)&(RequestNo'="-1") q
	  .s RecLocDr=$P(^RETRQ(rw),"^",2)
	  .s RegNo=$P(^RETRQ(rw),"^",3)
	  .s admId=$P(^RETRQ(rw),"^",5)
	  .s papmiId=+^PAADM(admId)
	  .s Status=$P(^RETRQ(rw),"^",14)
	  .q:(Status'=ReqStatus)&(ReqStatus'="0")
	  .if RecLocDr'="" s ReclocDesc=$p(^CTLOC(RecLocDr),"^",2)	
	  .s DocDr=$P(^RETRQ(rw),"^",6)
	  .if DocDr'="" s DocDes=$P(^CTPCP(DocDr,1),"^",2)
      .s PatName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	  .s AdmLocDr=$P(^RETRQ(rw),"^",21)
	  .s AdmLocDes=$p(^CTLOC(AdmLocDr),"^",2)	
	  .s wardDr=$P(^RETRQ(rw),"^",7)
	  .q:wardDr'=Ward
	  .s WardDes=$p(^CTLOC(wardDr),"^",2)
	  .b	
	  .s BedDr=$P(^RETRQ(rw),"^",8)
	  .s BedCode=$p($g(^PAWARD(+BedDr,"BED",$P(BedDr,"||",2))),"^",1)
	  .s DispDr=$P(^RETRQ(rw),"^",9)
	  .s ArcimDr=$P($G(^OEORD(+DispDr,"I",$P(DispDr,"||",2),1)),"^",2)
	  .s ArcimDes=$P($G(^ARCIM(+ArcimDr,$P(ArcimDr,"||",2),1)),"^",2)
	  .s BasUom=..GetBasUom(ArcimDr)
	  .s PrescNo=$P(^RETRQ(rw),"^",10)
	  .s disp=^OEORD(+DispDr,"I",$P(DispDr,"||",2),"X",$P(DispDr,"||",3),"D",$P(DispDr,"||",4)) 
	  .s dispQty=$P(disp,"^",1)
	  .s ReQty=$P(disp,"^",7)
	  .s ReqQty=$P(^RETRQ(rw),"^",11)  //申请数量
	  .s Price=$P(^RETRQ(rw),"^",12)   //单价
	  .s Amount=$P(^RETRQ(rw),"^",13)  //金额
	  .s OpuserDr=$P(^RETRQ(rw),"^",15)
	  .s OpUser=^SSU("SSUSR",OpuserDr)
	  .s OpDate=$ZD($P(^RETRQ(rw),"^",16),4)
	  .s OpTime=$ZT($P(^RETRQ(rw),"^",17))
	  .s OpDateTim=OpDate_","_$TR(OpTime,":",";")
	  .s DrugFrom=$P(^RETRQ(rw),"^",22)
      .d OutRowtyp
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(OpDateTim,ReqNo,PatName,BedCode,ArcimDes,$P(ReclocDesc,"-",2),ReqQty,ReQty,dispQty,BasUom,Status,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetRequestDrugFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRequestDrugExecute ]
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

ClassMethod GetRequestDrugClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRequestDrugExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Storage Default
{
<Data name="DHCPdaReturnDrugDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPdaReturnDrugD</DataLocation>
<DefaultData>DHCPdaReturnDrugDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPdaReturnDrugD</IdLocation>
<IndexLocation>^web.DHCPdaReturnDrugI</IndexLocation>
<StreamLocation>^web.DHCPdaReturnDrugS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
