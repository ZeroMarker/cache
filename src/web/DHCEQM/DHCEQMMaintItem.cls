Class web.DHCEQM.DHCEQMMaintItem Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter GlobalLen = 19;

ClassMethod SaveData(val, isDel As %Library.String = "")
{
	k PLIST,RowID
    s RowID=$p(val,"^",1)
	s PLIST(2)=$p(val,"^",2)
	s PLIST(3)=$p(val,"^",3)
	s PLIST(4)=$p(val,"^",4)
	s PLIST(5)=$p(val,"^",5)
	s PLIST(6)=$p(val,"^",6)
	s PLIST(7)=$p(val,"^",7)
	s PLIST(8)=$p(val,"^",8)
	s PLIST(9)=$p(val,"^",9)
	s PLIST(10)=$p(val,"^",10)
	s PLIST(11)=$p(val,"^",11)
	s PLIST(12)=$p(val,"^",12)
	s PLIST(13)=$p(val,"^",13)
	s PLIST(14)=$p(val,"^",14)
	s PLIST(15)=$p(val,"^",15)
	s PLIST(16)=$p(val,"^",16)
	s PLIST(17)=$p(val,"^",17)
	s PLIST(18)=$p(val,"^",18)
	s PLIST(19)=$p(val,"^",19)
	
	i (+isDel=2)
	{
	  if RowID=""
	  {
	    &SQL(insert into SQLUSER.DHC_EQMMaintItem values:PLIST())
	    q SQLCODE
	  }
	  else 
	  {
	     &SQL(update SQLUSER.DHC_EQMMaintItem values:PLIST() where MTI_RowID=:RowID)
	     q SQLCODE
	  }
	}
	i (+isDel=1)
	{
		i (RowID'="")
	       {
		       &SQL(delete from SQLUSER.DHC_EQMMaintItem  where MTI_RowID=:RowID)
		       q SQLCODE
	      }
	}
}

Query MaintItem(MaintRequestDR As %String = "") As %Query(ROWSPEC = "TMTIRowID:%String,TMTIMaintPartDR:%String,TMTIMaintPart:%String,TMTIMaintItemDR:%String,TMTIMaintItem:%String,TMTIMaintUserDR:%String,TMTIMaintState:%String,TMTIRemark:%String,TMTIHold2:%String,TMTIHold3:%String,TMTIHold4:%String,TMTINormalFlag:%String,TMTIMaintContent:%String,TMTIResult:%String,TMTIProviderDR:%String,TMTIStep:%String,TMTIHold5:%String,TMTIMaintFee:%String,TMTITotalFee:%String,TMTIMaintRequestDR:%String")
{
}

ClassMethod MaintItemExecute(ByRef qHandle As %Binary, MaintRequestDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	Set TotalFee=0
	i MaintRequestDR="" q

	Set rowid=0
	For  Set rowid=$Order(^DHCEQMMaintItem(0,"MaintRequest",MaintRequestDR,rowid))  Quit:rowid=""  Do
	.Do ResetVariablesGetMaintItem
	.Set TMTIRowID=rowid
	.Set TMTIMaintDR=$P($G(^DHCEQMMaintItem(TMTIRowID)),"^",1)
	.Set TMTIMaintPartDR=$P($G(^DHCEQMMaintItem(TMTIRowID)),"^",2)
	.i TMTIMaintPartDR'="" s TMTIMaintPart=$P($G(^DHCEQCCode("DHCEQMCPart",TMTIMaintPartDR)),"^",2)
	.Set TMTIMaintItemDR=$P($G(^DHCEQMMaintItem(TMTIRowID)),"^",3)
	.i TMTIMaintItemDR'="" s TMTIMaintItem=$P($G(^DHCEQCCode("DHCEQMCMaintItem",TMTIMaintItemDR)),"^",2)
	.Set TMTIMaintUserDR=$P($G(^DHCEQMMaintItem(TMTIRowID)),"^",4)
	.Set TMTIMaintState=$P($G(^DHCEQMMaintItem(TMTIRowID)),"^",5)
	.Set TMTIRemark=$P($G(^DHCEQMMaintItem(TMTIRowID)),"^",6)
	.Set TMTIMaintRequestDR=$P($G(^DHCEQMMaintItem(TMTIRowID)),"^",7)
	.Set TMTIHold2=$P($G(^DHCEQMMaintItem(TMTIRowID)),"^",8)
	.Set TMTIHold3=$P($G(^DHCEQMMaintItem(TMTIRowID)),"^",9)
	.Set TMTIHold4=$P($G(^DHCEQMMaintItem(TMTIRowID)),"^",10)
	.Set TMTINormalFlag=$P($G(^DHCEQMMaintItem(TMTIRowID)),"^",11)
	.Set TMTIMaintContent=$P($G(^DHCEQMMaintItem(TMTIRowID)),"^",12)
	.Set TMTIResult=$P($G(^DHCEQMMaintItem(TMTIRowID)),"^",13)
	.Set TMTIProviderDR=$P($G(^DHCEQMMaintItem(TMTIRowID)),"^",14)
	.Set TMTIStep=$P($G(^DHCEQMMaintItem(TMTIRowID)),"^",15)
	.Set TMTIHold5=$P($G(^DHCEQMMaintItem(TMTIRowID)),"^",16)
	.Set TMTIMaintFee=$P($G(^DHCEQMMaintItem(TMTIRowID)),"^",17)
	.Set MTIMaintFee = MTIMaintFee + TMTIMaintFee
	.Set TMTITotalFee=$P($G(^DHCEQMMaintItem(TMTIRowID)),"^",18)
	.d OutputRowGetMaintItem
    Quit $$$OK
	
OutputRowGetMaintItem
   	s Data=$lb(TMTIRowID,TMTIMaintPartDR,TMTIMaintPart,TMTIMaintItemDR,TMTIMaintItem,TMTIMaintUserDR,TMTIMaintState,TMTIRemark,TMTIHold2,TMTIHold3,TMTIHold4,TMTINormalFlag,TMTIMaintContent,TMTIResult,TMTIProviderDR,TMTIStep,TMTIHold5,TMTIMaintFee,TMTITotalFee,TMTIMaintRequestDR)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetMaintItem
	s (TMTIRowID,MTIMaintFee,TMTIMaintPartDR,TMTIMaintPart,TMTIMaintItemDR,TMTIMaintItem,TMTIMaintUserDR,TMTIMaintState,TMTIRemark,TMTIHold2,TMTIHold3,TMTIHold4,TMTINormalFlag,TMTIMaintContent,TMTIResult,TMTIProviderDR,TMTIStep,TMTIHold5,TMTIMaintFee,TMTITotalFee,TMTIMaintRequestDR)=""
	quit
}

ClassMethod MaintItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MaintItemExecute ]
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

ClassMethod MaintItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MaintItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOneMaintItem(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
 new result,resultex
 s (result,resultex)=""
 s result=^DHCEQMMaintItem(rowid)
 set count=..#GlobalLen-$l(result,"^")
 for i=count:-1:1 { s result=result_"^"}
 s resultex=resultex_"^"	//DHC_EQMCPart
 i $p(result,"^",2)'=""  d
 .s resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQMCPart",$p(result,"^",2))),"^",2)
 . s resultex=resultex_"^"	//DHC_EQMCMaintItem
 i $p(result,"^",3)'=""  d
 .s resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQMCMaintItem",$p(result,"^",3))),"^",2)
 . s resultex=resultex_"^"	//DHC_EQCVendor
 i $p(result,"^",14)'=""  d
 .s resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQCVendor",$p(result,"^",14))),"^",2)
 
 s result=rowid_"^"_result_"^"_resultex
 q result
}

}
