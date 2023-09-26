/// web.DHCMedUnionCardControl
/// 2011-1-24 刘铁英
/// 医联卡系统接口对照
Class web.DHCMedUnionCardControl Extends %RegisteredObject
{

ClassMethod ModifyMedUnionCardInfo(SelectType As %String, InStr As %String) As %String
{
	s Rowid=$p(InStr,"^",6)
	q:Rowid="" 
	s ActiveF=$p(InStr,"^",5)
	s MUCDesc=$p(InStr,"^",4)
	s MUCCode=$p(InStr,"^",3)
	s HisDesc=$p(InStr,"^",2)
	s HisCode=$p(InStr,"^",1)
	
	if (SelectType="Freq"){
		&sql(update SQLUser.DHC_FreqExternal 
		     set FE_Local_Freq_DR=:HisCode,FE_Local_Desc=:HisDesc,FE_Ext_Code=:MUCCode,FE_Ext_Desc=:MUCDesc,FE_Active=:ActiveF
		     where FE_Rowid=:Rowid)
	}
	if (SelectType="Instruc"){
		&sql(update SQLUser.DHC_InstrucExternal 
		     set IE_Local_Instruc_DR=:HisCode,IE_Local_Desc=:HisDesc,IE_Ext_Code=:MUCCode,IE_Ext_Desc=:MUCDesc,IE_Active=:ActiveF
		     where IE_Rowid=:Rowid)
	}
	if (SelectType="Duration"){
		&sql(update SQLUser.DHC_DurationExternal 
		     set DE_Local_Duration_DR=:HisCode,DE_Local_Desc=:HisDesc,DE_Ext_Code=:MUCCode,DE_Ext_Desc=:MUCDesc,DE_Active=:ActiveF
		     where DE_Rowid=:Rowid)
	}
	q SQLCODE
}

ClassMethod SelectMedUnionCardInfo(SelectType As %String) As %String
{
	s DhcRowid=0,ResRtn=""
	if (SelectType="Freq"){
		for {
			s DhcRowid=$O(^DHCFE(DhcRowid))
			q:DhcRowid=""
			&sql(select FE_Local_Freq_DR->PHCFR_Code,FE_Local_Desc,FE_Ext_Code,FE_Ext_Desc,FE_Active,FE_Rowid 
			     into :HisCode,:HisDesc,:MUCCode,:MUCDesc,:ActiveFlag,:HidRowid 
			     from SQLUser.DHC_FreqExternal
			     where FE_Rowid=:DhcRowid )
		     if (SQLCODE=0){
			     if (ResRtn="") s ResRtn=HisCode_"^"_HisDesc_"^"_MUCCode_"^"_MUCDesc_"^"_ActiveFlag_"^"_HidRowid
			     else  s ResRtn=ResRtn_"!"_HisCode_"^"_HisDesc_"^"_MUCCode_"^"_MUCDesc_"^"_ActiveFlag_"^"_HidRowid
		     }
		} 
	}
	if (SelectType="Instruc"){
		for {
			s DhcRowid=$O(^DHCIE(DhcRowid))
			q:DhcRowid=""
			&sql(select IE_Local_Instruc_DR->PHCIN_Code,IE_Local_Desc,IE_Ext_Code,IE_Ext_Desc,IE_Active,IE_Rowid 
		         into :HisCode,:HisDesc,:MUCCode,:MUCDesc,:ActiveFlag,:HidRowid 
		         from SQLUser.DHC_InstrucExternal
			     where IE_Rowid=:DhcRowid )
		     if (SQLCODE=0){
			     if (ResRtn="") s ResRtn=HisCode_"^"_HisDesc_"^"_MUCCode_"^"_MUCDesc_"^"_ActiveFlag_"^"_HidRowid
			     else  s ResRtn=ResRtn_"!"_HisCode_"^"_HisDesc_"^"_MUCCode_"^"_MUCDesc_"^"_ActiveFlag_"^"_HidRowid
		     }
		}		
	}
	if (SelectType="Duration"){
		for {
			s DhcRowid=$O(^DHCDE(DhcRowid))
			q:DhcRowid=""
			&sql(select DE_Local_Duration_DR->PHCDU_Code,DE_Local_Desc,DE_Ext_Code,DE_Ext_Desc,DE_Active,DE_Rowid 
		     	 into :HisCode,:HisDesc,:MUCCode,:MUCDesc,:ActiveFlag,:HidRowid 
		         from SQLUser.DHC_DurationExternal
			     where DE_Rowid=:DhcRowid )
		     if (SQLCODE=0){
			     if (ResRtn="") s ResRtn=HisCode_"^"_HisDesc_"^"_MUCCode_"^"_MUCDesc_"^"_ActiveFlag_"^"_HidRowid
			     else  s ResRtn=ResRtn_"!"_HisCode_"^"_HisDesc_"^"_MUCCode_"^"_MUCDesc_"^"_ActiveFlag_"^"_HidRowid
		     }
		} 		 
	}
	;if (SQLCODE=0) s ResRtn=HisCode_"^"_HisDesc_"^"_MUCCode_"^"_MUCDesc_"^"_ActiveFlag_"^"_HidRowid
	q ResRtn
}

ClassMethod RepeatMedUnionCardInfo(SelectType As %String, Repstr As %String) As %String
{
	q:Repstr="" 
	if (SelectType="Freq"){
		if (Repstr["Qd")!(Repstr["Tid")!(Repstr["Bid"){
			s Repstr=$p(Repstr,")",1)
			s Repstr1=$p(Repstr,"(",1)
			s Repstr2=$p(Repstr,"(",2)
			s Repstr=Repstr1_Repstr2
		}
		s Repstr=$ZCVT(Repstr,"U")
		s FreDr=$O(^PHCFR(0,"Code",Repstr,""))
		q:FreDr="" "NULL"
		s FERowid=$O(^DHCFE(0,"FREQ",FreDr,""))
		if (FERowid'="") {s RtnStr="R"_"^"_FreDr}
		else {s RtnStr="NR"_"^"_FreDr}
	}
	if (SelectType="Instruc"){
		s InsDr=$O(^PHCIN(0,"Code",Repstr,""))
		q:InsDr="" "NULL"
		s IERowid=$O(^DHCIE(0,"INSTRUC",InsDr,""))
		if (IERowid'="") {s RtnStr="R"_"^"_InsDr}
		else {s RtnStr="NR"_"^"_InsDr}
	}
	if (SelectType="Duration"){
		s DurDr=$O(^PHCDU(0,"Code",Repstr,""))
		q:DurDr="" "NULL"
		s DERowid=$O(^DHCDE(0,"DURATION",DurDr,""))
		if (DERowid'="") {s RtnStr="R"_"^"_DurDr}
		else {s RtnStr="NR"_"^"_DurDr}
	}
	q RtnStr
}

ClassMethod InsertMedUnionCardInfo(SelectType As %String, Instr As %String) As %String
{
	q:SelectType=""
	s PLIST(2)=$p(Instr,"^",1)
	s PLIST(3)=$p(Instr,"^",2)
	s PLIST(4)=$p(Instr,"^",3)
	s PLIST(5)=$p(Instr,"^",4)
	s PLIST(6)=$p(Instr,"^",5)
	
	if (SelectType="Freq"){
		&sql(insert into SQLUser.DHC_FreqExternal values PLIST())
		 //(FE_Ext_Code,FE_Ext_Desc,FE_Local_Desc,FE_Local_Freq_DR,FE_Active) 	
	}
	if (SelectType="Instruc"){
		&sql(insert into SQLUser.DHC_InstrucExternal values PLIST())
	}
	if (SelectType="Duration"){
		&sql(insert into SQLUser.DHC_DurationExternal values PLIST())
	}
	q SQLCODE
}

ClassMethod DeleteMedUnionCardInfo(SelectType As %String, DelRowid As %String) As %String
{
	q:(SelectType="")!(DelRowid="")
	if (SelectType="Freq"){
		&sql(delete from SQLUser.DHC_FreqExternal where FE_Rowid=:DelRowid)
	}
	if (SelectType="Instruc"){
		&sql(delete from SQLUser.DHC_InstrucExternal where IE_Rowid=:DelRowid)
	}
	if (SelectType="Duration"){
		&sql(delete from SQLUser.DHC_DurationExternal where DE_Rowid=:DelRowid)
	}
	q SQLCODE
}

ClassMethod MedUnionCardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MedUnionCardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod MedUnionCardExecute(ByRef qHandle As %Binary, SelectType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	
	//if SelectType="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	if SelectType="" Set SelectType="Freq"
	s FERowid=0,IERowid=0,DERowid=0
	s (THisCode,THisDesc,TMUCCode,TMUCDesc,TActiveFlag,HidRowid)=""
	
	i SelectType="Freq" d
	.f  s FERowid=$O(^DHCFE(FERowid)) q:FERowid=""  d
	..s TActiveFlag=$p(^DHCFE(FERowid),"^",5)
	..;q:TActiveFlag'="Y"
	..i TActiveFlag="Y" s TActiveFlag="Y"
	..s TMUCCode=$p(^DHCFE(FERowid),"^",1)
	..s TMUCDesc=$p(^DHCFE(FERowid),"^",2)
	..s THisDesc=$p(^DHCFE(FERowid),"^",3)
	..s FreDr=$p(^DHCFE(FERowid),"^",4)
	..s THisCode=""
	..s:+FreDr'=0 THisCode=$p($G(^PHCFR(FreDr)),"^",1)
	..s HidRowid=FERowid
	..d OutputRow
	.i HidRowid="" d OutputRow
	i SelectType="Instruc" d
	.f  s IERowid=$O(^DHCIE(IERowid)) q:IERowid=""  d
	..s TActiveFlag=$p(^DHCIE(IERowid),"^",5)
	..;q:TActiveFlag'="Y"
	..i TActiveFlag="Y" s TActiveFlag="是"
	..s TMUCCode=$p(^DHCIE(IERowid),"^",1)
	..s TMUCDesc=$p(^DHCIE(IERowid),"^",2)
	..s THisDesc=$p(^DHCIE(IERowid),"^",3)
	..s InsDr=$p(^DHCIE(IERowid),"^",4)
	..s InsDr=""
	..s:+InsDr'=0 THisCode=$p($G(^PHCIN(InsDr)),"^",1)
	..s HidRowid=IERowid 
	..d OutputRow
	.i HidRowid="" d OutputRow
	i SelectType="Duration" d
	.f  s DERowid=$O(^DHCDE(DERowid)) q:DERowid=""  d
	..s TActiveFlag=$p(^DHCDE(DERowid),"^",5)
	..;q:TActiveFlag'="Y"
	..i TActiveFlag="Y" s TActiveFlag="是"
	..s TMUCCode=$p(^DHCDE(DERowid),"^",1)
	..s TMUCDesc=$p(^DHCDE(DERowid),"^",2)
	..s THisDesc=$p(^DHCDE(DERowid),"^",3)
	..s DurDr=$p(^DHCDE(DERowid),"^",4)
	..s THisCode=""
	..s:+DurDr'=0 THisCode=$p(^PHCDU(DurDr),"^",1)
	..s HidRowid=DERowid
	..d OutputRow
	.;d OutputRow	

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow      
	set Data=$lb(THisCode,THisDesc,TMUCCode,TMUCDesc,TActiveFlag,HidRowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod MedUnionCardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MedUnionCardExecute ]
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

ClassMethod HisCodeQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = HisCodeQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod HisCodeQueryExecute(ByRef qHandle As %Binary, SelectType As %String, SelectHISCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	
	if SelectType="" Set qHandle=$lb(0,repid,0) Quit $$$OK	
	s PhcRowid=0
	
	if SelectType="Freq" do
	.if SelectHISCode="" do
	..f  s PhcRowid=$O(^PHCFR(PhcRowid)) q:PhcRowid=""  d
	...s HISCode=$p(^PHCFR(PhcRowid),"^",1)
	...s HISDesc=$p(^PHCFR(PhcRowid),"^",3)
	...d OutputRow
	.if SelectHISCode'="" do
	..;s PhcRowid=$O(^PHCFR(0,"Code",SelectHISCode,PhcRowid))
	..f  s PhcRowid=$O(^PHCFR(PhcRowid)) q:PhcRowid=""  d
	...s HISCode=$p(^PHCFR(PhcRowid),"^",1)
	...q:HISCode'[SelectHISCode
	...s HISDesc=$p(^PHCFR(PhcRowid),"^",3)
	...d OutputRow
	if SelectType="Instruc" do
	.if SelectHISCode="" do
	..f  s PhcRowid=$O(^PHCIN(PhcRowid)) q:PhcRowid=""  d
	...s HISCode=$p(^PHCIN(PhcRowid),"^",1)
	...s HISDesc=$p(^PHCIN(PhcRowid),"^",3)
	...d OutputRow
	.if SelectHISCode'="" do
	..;s PhcRowid=$O(^PHCIN(0,"Code",SelectHISCode,PhcRowid))
	..f  s PhcRowid=$O(^PHCIN(PhcRowid)) q:PhcRowid=""  d
	...s HISCode=$p(^PHCIN(PhcRowid),"^",1)
	...q:HISCode'[SelectHISCode
	...s HISDesc=$p(^PHCIN(PhcRowid),"^",3)
	...d OutputRow
	if SelectType="Duration" do
	.if SelectHISCode="" do
	..f  s PhcRowid=$O(^PHCDU(PhcRowid)) q:PhcRowid=""  d
	...s HISCode=$p(^PHCDU(PhcRowid),"^",1)
	...s HISDesc=$p(^PHCDU(PhcRowid),"^",3)
	...d OutputRow
	.if SelectHISCode'="" do
	..;s PhcRowid=$O(^PHCDU(0,"Code",SelectHISCode,PhcRowid))
	..f  s PhcRowid=$O(^PHCDU(PhcRowid)) q:PhcRowid=""  d
	...s HISCode=$p(^PHCDU(PhcRowid),"^",1)
	...q:HISCode'[SelectHISCode
	...s HISDesc=$p(^PHCDU(PhcRowid),"^",3)
	...d OutputRow
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow      
	set Data=$lb(HISCode,HISDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod HisCodeQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = HisCodeQueryExecute ]
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

Query HisCodeQuery(SelectType As %String, SelectHISCode As %String) As %Query(ROWSPEC = "HISCode:%String,HISDesc:%String")
{
}

Query MedUnionCard(SelectType As %String) As %Query(ROWSPEC = "THISCode:%String,THISDesc:%String,TMUCCode:%String,TMUCDesc:%String,TActiveFlag:%String,HidRowid:%String")
{
}

}
