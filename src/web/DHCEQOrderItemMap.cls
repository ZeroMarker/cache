Import SQLUser

Class web.DHCEQOrderItemMap Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 5;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

//设备医嘱项对照表

Parameter SQLCODE = "OIM_RowID";

Parameter SQLDESCRIPTION = "OIM_RowID";

Parameter SQLROWID = "OIM_RowID";

ClassMethod OrderItemMapClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OrderItemMapExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod OrderItemMapExecute(ByRef qHandle As %Binary) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetOrderItemMap
	Quit $$$OK
BuildDataGetOrderItemMap
	f  s rowid=$o(^DHCEQOrderItemMap(rowid))  quit:rowid=""  d
	.d ResetVariablesGetOrderItemMap
	.s LTRowID = rowid	//rowid
	.s LTEquipDR=$p($g(^DHCEQOrderItemMap(rowid)),"^",1) //设备
	.i LTEquipDR'="" s LTEquip=$p($g(^DHCEQEquip(LTEquipDR)),"^",1) //设备名称
	.s SLTOrderItem=$p($g(^DHCEQOrderItemMap(rowid)),"^",2) //医嘱项
	.i SLTOrderItem'="" d
	..s LName1=$p(SLTOrderItem,"||",1)
	..s LName2=$p(SLTOrderItem,"||",2)
	..i (LName1'="")&(LName2'="") d 
	..s LTOrderItem=$p($g(^ARCIM(LName1,LName2,1)),"^",2)
	.s LTRemark=$p($g(^DHCEQOrderItemMap(rowid)),"^",3) //备注
	.s LTAddUser=$p($g(^DHCEQOrderItemMap(rowid)),"^",4) //新增人
	.s LTAddDate1=$p($g(^DHCEQOrderItemMap(rowid)),"^",5) //新增日期
	.;i LTAddDate1'="" s LTAddDate=$zd(LTAddDate1,4) 
	.;日期格式统一调整   modify by jyp  2017-03-02
	.s LTAddDate=##Class(web.DHCEQCommon).TransValueToPage(LTAddDate1,"date")
	.s LTAddTime1=$p($g(^DHCEQOrderItemMap(rowid)),"^",6) //新增时间
	.;i LTAddTime1'="" s LTAddTime=$zt(LTAddTime1,2)
	.;日期格式统一调整   modify by jyp  2017-03-02
	.s LTAddTime=##Class(web.DHCEQCommon).TransValueToPage(LTAddTime1,"time")
	.s LTUpdateUser=$p($g(^DHCEQOrderItemMap(rowid)),"^",7) //更新人
	.s LTUpdateDate1=$p($g(^DHCEQOrderItemMap(rowid)),"^",8) //更新日期
	.;i LTUpdateDate1'="" s LTUpdateDate=$zd(LTUpdateDate1,4)
	.;日期格式统一调整   modify by jyp  2017-03-02
	.s LTUpdateDate=##Class(web.DHCEQCommon).TransValueToPage(LTUpdateDate1,"date")
	.s LTUpdateTime1=$p($g(^DHCEQOrderItemMap(rowid)),"^",9) //更新时间
	.i LTUpdateTime1'="" s LTUpdateTime=$zt(LTUpdateTime1,2) 
	.;日期格式统一调整   modify by jyp  2017-03-02
	.s LTUpdateTime=##Class(web.DHCEQCommon).TransValueToPage(LTUpdateTime1,"time")
	.d OutputRowGetOrderItemMap
	quit
OutputRowGetOrderItemMap
   s Data=$lb(LTRowID,LTEquip,LTOrderItem,LTRemark,LTAddUser,LTAddDate,LTAddTime,LTUpdateUser,LTUpdateDate,LTUpdateTime)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetOrderItemMap
	s (LTRowID,LTEquip,LTOrderItem,LTRemark,LTAddUser,LTAddDate,LTAddTime,LTUpdateUser,LTUpdateDate,LTUpdateTime)=""
	quit
}

ClassMethod OrderItemMapFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OrderItemMapExecute ]
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

Query OrderItemMap() As %Query(ROWSPEC = "TRowID:%String,TEquip:%String,TOrderItem:%String,TRemark:%String,TAddUser:%String,TAddDate:%String,TAddTime:%String,TUpdateUser:%String,TUpdateDate:%String,TUpdateTime:%String")
{
}

ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", isDel As %Library.String = "")
{
 k PLIST,rowid
 s rowid=$p(val,"^",1)
 i (+isDel=1)
 {
 	&SQL(Delete From SQLUSER.DHC_EQOrderItemMap where OIM_RowID= :rowid)
 	if SQLCODE  q SQLCODE
 	q rowid
 } 
  s PLIST(2) = $p(val,"^",2)	;设备
 s EquipDR=$p(val,"^",2)
 s PLIST(3) = $p(val,"^",3)	;医嘱项
 s OrderItemDR= $p(val,"^",3)
  s PLIST(4) = $p(val,"^",4)	;备注
 s Rowid=""
 &SQL(select OIM_RowID into :Rowid from SQLUSER.DHC_EQOrderItemMap where OIM_EquipDR=:EquipDR and OIM_OrderItemDR=:OrderItemDR)
 	i (Rowid="")
 	{
 i (+isDel=2)
 {
 s PLIST(5) = $p(val,"^",5)	;新增人5
 s PLIST(6) = +$H ;审核日期
 s PLIST(7) = $P($H,",",2) ;审核时间 
 	&SQL(Insert Into SQLUSER.DHC_EQOrderItemMap Values :PLIST())
 	if SQLCODE  q SQLCODE
 	Set ID=$g(%ROWID)
 q ID
 } 
 if (rowid'="") 
 {
 s PLIST(8) = $p(val,"^",5)	;新增人5
 s PLIST(9) = +$H ;审核日期
 s PLIST(10) = $P($H,",",2) ;审核时间 
 	 &SQL(Update SQLUSER.DHC_EQOrderItemMap Values :PLIST() where OIM_RowID = :rowid) 	 
 }
 else
 {	 
 s PLIST(5) = $p(val,"^",5)	;新增人5
 s PLIST(6) = +$H ;审核日期
 s PLIST(7) = $P($H,",",2) ;审核时间
	 &SQL(Insert Into SQLUSER.DHC_EQOrderItemMap Values :PLIST())
 }
 }
 elseif(Rowid=rowid)
 {
	 
 i (+isDel=2)
 {
 s PLIST(5) = $p(val,"^",5)	;新增人5
 s PLIST(6) = +$H ;审核日期
 s PLIST(7) = $P($H,",",2) ;审核时间 
 	&SQL(Insert Into SQLUSER.DHC_EQOrderItemMap Values :PLIST())
 	if SQLCODE  q SQLCODE
 	Set ID=$g(%ROWID)
 q ID
 } 
 if (rowid'="") 
 {
 s PLIST(8) = $p(val,"^",5)	;新增人5
 s PLIST(9) = +$H ;审核日期
 s PLIST(10) = $P($H,",",2) ;审核时间 
 	 &SQL(Update SQLUSER.DHC_EQOrderItemMap Values :PLIST() where OIM_RowID = :rowid) 	 
 }
 else
 {	 
 s PLIST(5) = $p(val,"^",5)	;新增人5
 s PLIST(6) = +$H ;审核日期
 s PLIST(7) = $P($H,",",2) ;审核时间
	 &SQL(Insert Into SQLUSER.DHC_EQOrderItemMap Values :PLIST())
 }
	 }
 if SQLCODE  q SQLCODE
 Set ID=$g(%ROWID)
 q ID
}

ClassMethod GetDocByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQOrderItemMap(rowid)
	s resultex=rowid
	s resultex=resultex_"^"	//设备1
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQEquip($p($g(^DHCEQOrderItemMap(rowid)),"^",1))),"^",1)
	s resultex=resultex_"^"	//医嘱项2
	i $p(result,"^",2)'=""  d
	.s SLTOrderItem=$p($g(^DHCEQOrderItemMap(rowid)),"^",2)
	.i SLTOrderItem'="" s LName1=$p(SLTOrderItem,"||",1)
	.s LName2=$p(SLTOrderItem,"||",2)
	.i (LName1'="")&(LName2'="") s LTOrderItem=$p($g(^ARCIM(LName1,LName2,1)),"^",2)
	.else  s LTOrderItem=""
	.s resultex=resultex_LTOrderItem
	s resultex=resultex_"^"	//备注3
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQOrderItemMap(rowid)),"^",3)
	s resultex=resultex_"^"	//设备代码4
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQOrderItemMap(rowid)),"^",1)
	s resultex=resultex_"^"	//医嘱项代码5
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQOrderItemMap(rowid)),"^",2)
	.s resultex=##Class(web.DHCEQCommon).Replace(resultex,$C(13,10),"\n")
	q resultex
}

ClassMethod OrderItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OrderItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod OrderItemExecute(ByRef qHandle As %Binary, OrderItem As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	s rowid1=0
	d BuildDataGetOrderItem
	Quit $$$OK
BuildDataGetOrderItem
	f  s rowid=$o(^ARCIM(rowid))  quit:rowid=""  d
	.f  s rowid1=$o(^ARCIM(rowid,rowid1))  quit:rowid1=""  d
	..d ResetVariablesGetOrderItem
	..s LTRowID = rowid_"||"_rowid1
	..s LName=$p($g(^ARCIM(rowid,rowid1,1)),"^",2)
	..q:(LName'[OrderItem)
	..d OutputRowGetOrderItem
	quit
OutputRowGetOrderItem
   s Data=$lb(LName,LTRowID)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetOrderItem
	s (LName,LTRowID)=""
	quit
}

ClassMethod OrderItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OrderItemExecute ]
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

Query OrderItem(OrderItem As %String = "") As %Query(ROWSPEC = "Name:%String,RowID:%String")
{
}

Storage NewStorage1
{
<Type>%Storage.Persistent</Type>
}

Storage NewStorage2
{
<Type>%Storage.Persistent</Type>
}

Storage NewStorage3
{
<Type>%Storage.SQL</Type>
}

}
