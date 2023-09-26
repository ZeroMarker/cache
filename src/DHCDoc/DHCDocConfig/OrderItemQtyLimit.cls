Class DHCDoc.DHCDocConfig.OrderItemQtyLimit Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 收费类别与处方类型
Query GetPAADMPrescTypeList(HospId As %String = "") As %Query(ROWSPEC = "AILRowid:%String,PAADMType:%String,PAADMTypeDesc:%String,BillType:%String,BillTypeDesc:%String,PrescType:%String,PrescTypeDesc:%String,Default:%String")
{
}

ClassMethod GetPAADMPrescTypeListExecute(ByRef qHandle As %Binary, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.OrderItemQtyLimit","GetPAADMPrescTypeList")
	Set repid=$I(^CacheTemp)
    Set ind=1 
    i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
    s AILRowid=0  f  s AILRowid=$o(^DHCPAADMPrescType(AILRowid)) q:AILRowid=""  d
    .s PAADMType=$p(^DHCPAADMPrescType(AILRowid),"^",1)
    .i PAADMType="O" s PAADMTypeDesc="门诊"
    .i PAADMType="I" s PAADMTypeDesc="住院"
    .i PAADMType="E" s PAADMTypeDesc="急诊"
    .i PAADMType="H" s PAADMTypeDesc="体检"
    .i PAADMType="N" s PAADMTypeDesc="新生儿"
    .s BillType=$p(^DHCPAADMPrescType(AILRowid),"^",2)
    .s BillTypeDesc=$p($g(^PAC("ADMREA",BillType)),"^",2)
    .if ('$d(^PAC("ADMREA",BillType))) s BillTypeDesc=BillTypeDesc_"<font color=red> 已失效</font>"
    .e  d
    ..s BillTypeSttDate=$p(^PAC("ADMREA",BillType),"^",3)
    ..if (BillTypeSttDate'="")&&(BillTypeSttDate>+$h) s BillTypeDesc=BillTypeDesc_"<font color=red> 未到生效日期</font>" 
    ..s BillTypeEndDate=$p(^PAC("ADMREA",BillType),"^",4)
    ..if (BillTypeEndDate'="")&&(BillTypeEndDate<+$h) s BillTypeDesc=BillTypeDesc_"<font color=red> 已过截止日期</font>" 
    .s PrescType=$p(^DHCPAADMPrescType(AILRowid),"^",3)
    .s PrescTypeDesc=$p($g(^DHCPrescriptType(PrescType)),"^",2)
    .if ('$d(^DHCPrescriptType(PrescType))) s PrescTypeDesc=PrescTypeDesc_"<font color=red> 已失效</font>"
    .s Default=$p(^DHCPAADMPrescType(AILRowid),"^",4)
    .s HospRowid=$p(^DHCPAADMPrescType(AILRowid),"^",5)
    .q:HospRowid'=HospId
	.Do OutputRowGetPAADMPrescTypeList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetPAADMPrescTypeList
	set Data=$lb($g(AILRowid),$g(PAADMType),$g(PAADMTypeDesc),$g(BillType),$g(BillTypeDesc),$g(PrescType),$g(PrescTypeDesc),$g(Default))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetPAADMPrescTypeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPAADMPrescTypeListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPAADMPrescTypeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPAADMPrescTypeListExecute ]
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

ClassMethod delete(Rowid) As %String
{
	&sql(delete from SQLUser.DHC_PAADMPrescType where AIL_Rowid=:Rowid)
    Q SQLCODE
}

ClassMethod insert(Str As %String, HospId As %String = "") As %String
{
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	s find=..find("",Str,HospId)
	q:find=0 "-1"
	s Default=$p(Str,"^",8)
	if (Default="Y") {
		d ..UpdateDefault("",Str,HospId)
	}
	s PAADMTypeRowid=$p(Str,"^",1)
	s billtype=$p(Str,"^",2)
    s presctype=$p(Str,"^",3)
	&sql(insert into SQLUser.DHC_PAADMPrescType set AIL_BillType=:billtype,AIL_PAADMType=:PAADMTypeRowid,AIL_PrescType=:presctype,AIL_Default=:Default,AIL_Hosp_Dr=:HospId)
    Q SQLCODE
}

ClassMethod update(Rowid As %String, Str As %String, HospId As %String = "") As %String
{
	s find=..find(Rowid,Str,HospId)
	q:find=0 "-1"
	s Default=$p(Str,"^",8)
	if (Default="Y") {
		d ..UpdateDefault(Rowid,Str)
	}
	s PAADMTypeRowid=$p(Str,"^",1)
	s billtype=$p(Str,"^",2)
    s presctype=$p(Str,"^",3)
	&sql(update SQLUser.DHC_PAADMPrescType
                  set AIL_BillType=:billtype,AIL_PAADMType=:PAADMTypeRowid,AIL_PrescType=:presctype,AIL_Default=:Default
            where AIL_Rowid=:Rowid )
    Q SQLCODE
}

/// w ##class(DHCDoc.DHCDocConfig.OrderItemQtyLimit).find("","O^1^1^^^^^N")
ClassMethod find(Rowid As %String, Str As %String, HospId As %String = "") As %String
{
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	k PLIST
	s PAADMTypeRowid=$p(Str,"^",1)
	s BillType=$p(Str,"^",2)
	s PrescType=$p(Str,"^",3)
	s find=1
	s AILRowid=0 
	for {
		s AILRowid=$o(^DHCPAADMPrescType(AILRowid)) q:(AILRowid="")||(find=0)
		continue:(Rowid'="")&&(Rowid=AILRowid)
		s tmpADMType=$p(^DHCPAADMPrescType(AILRowid),"^",1)
		continue:(tmpADMType'=PAADMTypeRowid)
	    s tmpBillType=$p(^DHCPAADMPrescType(AILRowid),"^",2)
	    continue:tmpBillType'=BillType
	    s tmpPrescType=$p(^DHCPAADMPrescType(AILRowid),"^",3)
	    continue:tmpPrescType'=PrescType
	    s HospRowid=$p(^DHCPAADMPrescType(AILRowid),"^",5)
	    continue:HospRowid'=HospId
	    s find=0
    }
	q find
}

Query FindBillTypeConfig(value As %String, HospId As %String = "") As %Query(ROWSPEC = "BillTypeRowid:%String,BillTypeDesc:%String,selected:%Boolean")
{
}

ClassMethod FindBillTypeConfigExecute(ByRef qHandle As %Binary, value As %String, HospId As %String = "") As %Status
{
	s ^tempscl("value")=value
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.OrderItemQtyLimit","FindBillTypeConfig","QuickAdmBillType")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s BillTypeRowid=0
    f  s BillTypeRowid=$o(^PAC("ADMREA",BillTypeRowid)) q:BillTypeRowid=""  d
    .Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("PAC_AdmReason",BillTypeRowid,HospId)="N"
    .s BillTypeDesc=$p(^PAC("ADMREA",BillTypeRowid),"^",2)
    .s BillTypeSttDate=$p(^PAC("ADMREA",BillTypeRowid),"^",3)
    .Q:(BillTypeSttDate'="")&&(BillTypeSttDate>+$h)
    .s BillTypeEndDate=$p(^PAC("ADMREA",BillTypeRowid),"^",4)
    .Q:(BillTypeEndDate'="")&&(BillTypeEndDate<+$h)
    .s selected=0
    .i (value'="")&&(BillTypeRowid=value) s selected=1
	.Do OutputRowFindBillTypeConfig
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindBillTypeConfig
	set Data=$lb($g(BillTypeRowid),$g(BillTypeDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindBillTypeConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBillTypeConfigExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindBillTypeConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBillTypeConfigExecute ]
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

ClassMethod UpdateDefault(Rowid As %String, Str As %String, HospId As %String = "") As %String
{
	n (Rowid,Str,HospId)
	s PAADMTypeRowid=$p(Str,"^",1)
	s BillTypeRowId=$p(Str,"^",2)
    s AILRowid=0  
    for {
	    s AILRowid=$o(^DHCPAADMPrescType(AILRowid)) q:AILRowid="" 
	    continue:(Rowid'="")&&(AILRowid=Rowid)
	    s PAADMType=$p(^DHCPAADMPrescType(AILRowid),"^",1)
	    continue:(PAADMType'=PAADMTypeRowid)
	    s BillType=$p(^DHCPAADMPrescType(AILRowid),"^",2)
	    continue:(BillType'=BillTypeRowId)
	    s PrescType=$p(^DHCPAADMPrescType(AILRowid),"^",3)
	    s Default=$p(^DHCPAADMPrescType(AILRowid),"^",4)
	    continue:(Default'="Y")
	    s HospRowid=$p(^DHCPAADMPrescType(AILRowid),"^",5)
    	continue:(Rowid="")&&(HospRowid'=HospId)
	    &sql(update SQLUser.DHC_PAADMPrescType set AIL_Default='N' where AIL_Rowid=:AILRowid)
	}
	Q 0
}

}
