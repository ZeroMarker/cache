Import SQLUser

Class web.DHCEQPartList Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 5;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

//设备部位列表

Parameter SQLCODE = "PL_RowID";

Parameter SQLDESCRIPTION = "PL_RowID";

Parameter SQLROWID = "PL_RowID";

ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", isDel As %Library.String = "")
{
 k PLIST,rowid
 s rowid=$p(val,"^",1)
 i (+isDel=1)
 {
 	&SQL(Delete From SQLUSER.DHC_EQPartList where PL_RowID = :rowid)
 	if SQLCODE  q SQLCODE
 	q rowid
 } 
 ;i $p(val,"^",2)'="" 
  s PLIST(2) = $p(val,"^",2)	;设备2
  s EquipDR=$p(val,"^",2)
 ;i $p(val,"^",3)'="" 
  s PLIST(3) = $p(val,"^",3)	;部位3
  s PartDR=$p(val,"^",3)
 ;i $p(val,"^",4)'="" 
  s PLIST(4) = $p(val,"^",4)	;备注4
 &SQL(select PL_RowID into :Rowid from DHC_EQPartList where PL_EquipDR=:EquipDR and PL_PartDR=:PartDR)
 	if (Rowid=rowid)
 	{
	  &SQL(Update SQLUSER.DHC_EQPartList Values :PLIST() where PL_RowID = :rowid) 	 
	  i (+isDel=2)
 {
 s PLIST(5) = $p(val,"^",5)	;新增人5
 s PLIST(6) = +$H ;审核日期
 s PLIST(7) = $P($H,",",2) ;审核时间 
 	&SQL(Insert Into SQLUSER.DHC_EQPartList Values :PLIST())
 	if SQLCODE  q SQLCODE
 	Set ID=$g(%ROWID)
 q ID
 } 
	  }
 	elseif (Rowid="")
 	{
 if (rowid'="") 
 {
 s PLIST(8) = $p(val,"^",5)	;新增人5
 s PLIST(9) = +$H ;审核日期
 s PLIST(10) = $P($H,",",2) ;审核时间 
 	 &SQL(Update SQLUSER.DHC_EQPartList Values :PLIST() where PL_RowID = :rowid) 	 
 }
 else
 {	 
 s PLIST(5) = $p(val,"^",5)	;新增人5
 s PLIST(6) = +$H ;审核日期
 s PLIST(7) = $P($H,",",2) ;审核时间 
	 &SQL(Insert Into SQLUSER.DHC_EQPartList Values :PLIST())
 }
}
 if SQLCODE  q SQLCODE
 Set ID=$g(%ROWID)
 q ID
}

ClassMethod PartListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PartListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod PartListExecute(ByRef qHandle As %Binary) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetPartList
	Quit $$$OK
BuildDataGetPartList
	f  s rowid=$o(^DHCEQPartList(rowid))  quit:rowid=""  d
	.d ResetVariablesGetPartList
	.s LTRowID = rowid	//rowid
	.s LTEquipDR=$p($g(^DHCEQPartList(rowid)),"^",1) //设备
	.i LTEquipDR'="" s LTEquip=$p($g(^DHCEQEquip(LTEquipDR)),"^",1) //设备名称
	.s LTPartDR=$p($g(^DHCEQPartList(rowid)),"^",2) //部位   
	.i LTPartDR'="" s LTPart=$p($g(^DHCEQCCode("DHCEQCPart",LTPartDR)),"^",2)
	.s LTRemark=$p($g(^DHCEQPartList(rowid)),"^",3) //备注 
	.s LTAddUser=$p($g(^DHCEQPartList(rowid)),"^",4) //新增人            
	.s LTAddDate1=$p($g(^DHCEQPartList(rowid)),"^",5) //新增日期 
	.s LTAddDate=##Class(web.DHCEQCommon).TransValueToPage(LTAddDate,"date")         
	.s LTAddTime1=$p($g(^DHCEQPartList(rowid)),"^",6) //新增时间 
	.s LTAddTime=##Class(web.DHCEQCommon).TransValueToPage(LTAddTime,"time")           
	.s LTUpdateUser=$p($g(^DHCEQPartList(rowid)),"^",7) //更新人               
	.s LTUpdateDate1=$p($g(^DHCEQPartList(rowid)),"^",8) //更新日期
	.s LTUpdateDate=##Class(web.DHCEQCommon).TransValueToPage(LTUpdateDate,"date")             
	.s LTUpdateTime1=$p($g(^DHCEQPartList(rowid)),"^",9) //更新时间
	.s LTUpdateTime=##Class(web.DHCEQCommon).TransValueToPage(LTUpdateTime,"time")  
	.d OutputRowGetPartList
	quit
OutputRowGetPartList
   s Data=$lb(LTRowID,LTEquip,LTPart,LTRemark,LTAddUser,LTAddDate,LTAddTime,LTUpdateUser,LTUpdateDate,LTUpdateTime)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetPartList
	s (LTRowID,LTEquip,LTPart,LTRemark,LTAddUser,LTAddDate,LTAddTime,LTUpdateUser,LTUpdateDate,LTUpdateTime)=""
	quit
}

ClassMethod PartListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PartListExecute ]
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

Query PartList() As %Query(ROWSPEC = "TRowID:%String,TEquip:%String,TPart:%String,TRemark:%String,TAddUser:%String,TAddDate:%String,TAddTime:%String,TUpdateUser:%String,TUpdateDate:%String,TUpdateTime:%String")
{
}

ClassMethod GetDocByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQPartList(rowid)
	s resultex=rowid
	s resultex=resultex_"^"	//设备
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQEquip($p($g(^DHCEQPartList(rowid)),"^",1))),"^",1)
	s resultex=resultex_"^"	
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCPart",$p($g(^DHCEQPartList(rowid)),"^",2))),"^",2) //部位 
	s resultex=resultex_"^"	
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQPartList(rowid)),"^",3) //备注  
	s resultex=resultex_"^"	//设备代码
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQPartList(rowid)),"^",1)
	s resultex=resultex_"^"	//部位代码
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQPartList(rowid)),"^",2)
	s resultex=##Class(web.DHCEQCommon).Replace(resultex,$C(13,10),"\n")
	q resultex
}

}
