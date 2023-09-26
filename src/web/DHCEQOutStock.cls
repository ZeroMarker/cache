Class web.DHCEQOutStock Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 93;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

//设备退货单

Parameter SQLCODE = "OS_RowID";

Parameter SQLDESCRIPTION = "OS_RowID";

Parameter SQLROWID = "OS_RowID";

ClassMethod OutStockClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OutStockExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod OutStockExecute(ByRef qHandle As %Binary, QXType, Type, Loc As %String = "", Status As %String = "", StartDate As %String = "", EndDate As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetInStock
	Quit $$$OK
BuildDataGetInStock
	f  s rowid=$o(^DHCEQOutStock(rowid))  quit:rowid=""  d
	.d ResetVariablesGetInStock
	.s TRowID = rowid
	.s TOutStockNo = $p($g(^DHCEQOutStock(rowid)),"^",1) //退货单号
	.s TOutStockLocDR = $p($g(^DHCEQOutStock(rowid)),"^",2) //退货科室
	.q:(Loc'="")&&(Loc'=TOutStockLocDR)
	.q:(1=(##Class(web.DHCEQCommon).LocIsInEQ(QXType,TOutStockLocDR)))
	.i TOutStockLocDR '=""  d
	..s TOutStockLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TOutStockLocDR)
	.s TProviderDR = $p($g(^DHCEQOutStock(rowid)),"^",3) //供应商
	.i TProviderDR '=""  d
	..s TProvider = ##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	.i StartDate="" s StartDate=0
	.i EndDate="" s EndDate=+$h
	.s OutStockDate=$p($g(^DHCEQOutStock(rowid)),"^",4)  //退货日期
	.q:(OutStockDate>EndDate)||(OutStockDate<StartDate)
	.s TOutStockDate = ##class(web.DHCEQCommon).TransValueToPage(OutStockDate,"date") //退货日期
	.s TStatus = $p($g(^DHCEQOutStock(rowid)),"^",13) //状态
	.q:(Type="1")&&(TStatus="0")
	.q:(Type="2")&&(TStatus="0")
	.q:(Type="2")&&(TStatus="1")
	.q:(Status'="")&&(Status'=TStatus)
	.s TStatus=..GetStatu(TStatus)
	.s TRemark = $p($g(^DHCEQOutStock(rowid)),"^",14) //备注
	.s TBillAuditUserDR = $p($g(^DHCEQInStock(rowid)),"^",10) //账目确认人
	.i TBillAuditUserDR '=""  d
	..s TBillAuditUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TBillAuditUserDR)
	.s TEquipTypeDR=$p($g(^DHCEQOutStock(rowid)),"^",15)
	.q:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	.i TEquipTypeDR '=""  d
	..s TEquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	.s TStatCatDR=$p($g(^DHCEQOutStock(rowid)),"^",16)
	.i TStatCatDR '=""  d
	..s TStatCat = $p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
	.d OutputRowGetInStock
	quit
OutputRowGetInStock                                 
	s Data=$lb(TRowID,TOutStockNo,TOutStockLoc,TProvider,TOutStockDate,TStatus,TRemark,TBillAuditUser,TEquipTypeDR,TEquipType,TStatCatDR,TStatCat)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetInStock
	s (TRowID,TOutStockNo,TOutStockLoc,TProvider,TOutStockDate,TStatus,TRemark,TBillAuditUser,TEquipTypeDR,TEquipType,TStatCatDR,TStatCat)=""
	quit
}

ClassMethod OutStockFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OutStockExecute ]
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

Query OutStock(QXType, Type, LocDR As %String = "", Status As %String = "", StartDate As %String = "", EndDate As %String = "") As %Query(ROWSPEC = "TRowID:%String,TOutStockNo:%String,TOutStockLoc:%String,TProvider:%String,TOutStockDate:%String,TStatus:%String,TRemark:%String,TBillAuditUser:%String,TEquipTypeDR:%String,TEquipType:%String,TStatCatDR:%String,TStatCat:%String")
{
}

ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", Type As %Library.String = "")
{
	//Type=0 新增、更新
	//Type=1 提交
	//Type=2 账目审核
	//Type=3 出库审核
	//Type=4 删除
	//Type=5 反提交
	s Date=+$H
	s Time=$P($H,",",2)
	s RowID=$P(val,"^",1)
	s PLIST(14)=Type
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	TSTART
	if +Type=0
	{
		s PLIST(1) = $p(val,"^",1)	;RowID
 		s PLIST(2) = $p(val,"^",2)	;OutStockNo
 		s PLIST(3) = $p(val,"^",3)	;OutStockLocDR
 		s PLIST(4) = $p(val,"^",4)	;ProviderDR
 		s PLIST(5) = $p(val,"^",5)	;OutStockDate
 		i $p(val,"^",5)'=""  s PLIST(5) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",5),"date")	;OutStockDate
 		s PLIST(6) = User //$p(val,"^",6)	;MakerDR
 		s PLIST(7) = Date //$p(val,"^",7)	;MakeDate
 		//i $p(val,"^",7)'=""  s PLIST(7) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",7),"date")	;MakeDate
 		//s PLIST(8) = $p(val,"^",8)	;AckUserDR
 		//s PLIST(9) = $p(val,"^",9)	;AckDate
 		//i $p(val,"^",9)'=""  s PLIST(9) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",9),"date")	;AckDate
 		//s PLIST(10) = $p(val,"^",10)	;AckTime
 		//s PLIST(11) = $p(val,"^",11)	;BillAckUserDR
 		//s PLIST(12) = $p(val,"^",12)	;BillAckDate
 		//i $p(val,"^",12)'=""  s PLIST(12) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",12),"date")	;BillAckDate
 		//s PLIST(13) = $p(val,"^",13)	;BillAckTime
 		//s PLIST(14) = $p(val,"^",14)	;Status
 		s PLIST(15) = $p(val,"^",15)	;Remark
 		s PLIST(16) = $p(val,"^",16)	;EquipTypeDR
 		s PLIST(17) = $p(val,"^",17)	;StatCatDR
 		k PLIST(1)
 		if RowID=""
 		{
	 		i PLIST(2)="" s PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQOutStock",+$H,$p(val,"^",3),$p(val,"^",16))	// Mozy	2016-10-21
	 		&SQL(insert into sqluser.DHC_EQOutStock values :PLIST())
 		}
 		else
 		{
	 		&SQL(update sqluser.DHC_EQOutStock values :PLIST() where OS_RowID=:RowID)
 		}
	}
	if +Type=1
	{
		s PLIST(6) = User //$p(val,"^",5)	;MakerDR
 		s PLIST(7) = Date
 		&SQL(update sqluser.DHC_EQOutStock values :PLIST() where OS_RowID=:RowID)
	}
	if +Type=3
	{
		s PLIST(8)=User
		S PLIST(9)=Date
		s PLIST(10)=Time
		s SQLCODE=..UpdateBPLArriveNum(RowID)
		i SQLCODE'=0
		{
			TROLLBACK
			q SQLCODE
		}
		s EQCode=..UpdateOtherDataByEquip(RowID, User, Date)
		if EQCode'=0
		{
			TROLLBACK
			q EQCode
		}
		s BatchCode=..UpdateOtherDataByBatch(RowID, User, Date)
		if BatchCode'=0
		{
			TROLLBACK
			q BatchCode
		}
		&SQL(update sqluser.DHC_EQOutStock values :PLIST() where OS_RowID=:RowID)
	}
	if +Type=2
	{
		s PLIST(11)=User
		s PLIST(12)=Date
		S PLIST(13)=Time
		s i=$l(val,"^")
		s ValList=$P(val,"^",2,i)
		s SQLCODE=..UpdateOutStockList(ValList)
		i SQLCODE
 		{
			TROLLBACK
			q SQLCODE
 		}
		/*s SQLCODE=..UpdateChangeStock(RowID,Date)
		i SQLCODE
 		{
			TROLLBACK
			q SQLCODE
 		}*/
		&SQL(update sqluser.DHC_EQOutStock values :PLIST() where OS_RowID=:RowID)
	}
	if +Type=4
	{
		&SQL(delete from sqluser.DHC_EQOutStockList where OSL_OutStockDR=:RowID)
		i SQLCODE=100 s SQLCODE=0
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		&SQL(delete from sqluser.DHC_EQOutStock where OS_RowID=:RowID)
		
	}
	if +Type=5
	{
		s PLIST(6) = User //$p(val,"^",5)	;MakerDR
 		s PLIST(7) = Date
 		s PLIST(14) = "0"
 		&SQL(update sqluser.DHC_EQOutStock values :PLIST() where OS_RowID=:RowID)
	}
	if SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	s ID=$G(%ROWID)
	TCOMMIT
	q ID
}

ClassMethod UpdateBPLArriveNum(RID)
{
	s SQLCODE=0
	s RLID=0
	f  s RLID=$o(^DHCEQOutStockList(0,"OutStock",RID,RLID)) q:(RLID="")||(SQLCODE'=0)  d
	.s Flag=$p(^DHCEQOutStockList(RLID),"^",2)
	.i Flag="Y" d
	..s InStockListID=$P(^DHCEQOutStockList(RLID),"^",3)
	..s BPLID=$p(^DHCEQInStockList(InStockListID),"^",4)
	..q:BPLID=""
	..s Num=$P(^DHCEQOutStockList(RLID),"^",5)
	..s SQLCODE=##class(web.DHCEQOpenCheck).UpdateBPLArriveNum(-Num,BPLID)
	.q:SQLCODE'=0
	.i Flag="N" d
	..s EquipID=$P(^DHCEQOutStockList(RLID),"^",4)
	..s SQLCODE=..UpdateBPLArriveNumByEquip(EquipID)
	q SQLCODE
}

ClassMethod UpdateBPLArriveNumByEquip(EquipID)
{
	s Flag="N"
	s SQLCODE=0
	s InStockListID=$p(^DHCEQEquip(EquipID),"^",70)
	i InStockListID'=""
	{
		s BPLID=$p(^DHCEQInStockList(InStockListID),"^",4)
		i BPLID'=""
		{
			s Flag="Y"
			s SQLCODE=##class(web.DHCEQOpenCheck).UpdateBPLArriveNum(-1,BPLID)
		}
	}
	i Flag="N"
	{
		s ContractListID=$p(^DHCEQEquip(EquipID),"^",32)
		i ContractListID'=""
		{
			s BPLID=$p(^DHCEQContractList(ContractListID),"^",17)
			i BPLID'=""
			{
				s Flag="Y"
				s SQLCODE=##class(web.DHCEQOpenCheck).UpdateBPLArriveNum(-1,BPLID)
			}
		}
	}
	q SQLCODE
}

ClassMethod UpdateOutStockList(ValList)
{
	s i=0
	s j=0
	s CODE=0
	s i=$l(ValList,"^")
	for i=1:1:i
	{
		s Val=$P(ValList,"^",i)
		s j=$L(Val,",")
		s ISLRow=$P(Val,",",1)
		s Invoice=$P(Val,",",2,j)
		&SQL(update sqluser.DHC_EQOutStockList set OSL_InvoiceNo=:Invoice where OSL_RowID=:ISLRow)
		s CODE=CODE+SQLCODE
	}
	q CODE
}

ClassMethod UpdateChangeStock(RowID, Date)
{
	s ISLRowID=0
	s CSCode=0
	f  s ISLRowID=$o(^DHCEQOutStockList(0,"OutStock",RowID,ISLRowID))  quit:ISLRowID=""  d
	.&SQL(update sqluser.DHC_EQChangeStock set CS_BillChangeDate=:Date where CS_SourceID=:ISLRowID and CS_ChangeType='2')
	.s CSCode=CSCode+SQLCODE
	q CSCode
}

ClassMethod UpdateOtherDataByEquip(RowID, User, Date)
{
	s RLRowID=0
	s EQCode=0
	s CSCode=0
	s EquipVaildCount=0
	s EquipName=""
	s Stock=$P(^DHCEQOutStock(RowID),"^",2)
	s REquipType=$P(^DHCEQOutStock(RowID),"^",15)
	f  s RLRowID=$o(^DHCEQOutStockList(0,"OutStock",RowID,RLRowID))  quit:(RLRowID="")||(CSCode'=0)||(EQCode'=0)||(EquipVaildCount>0)  d
	.q:EquipVaildCount>0
	.q:CSCode'=0
	.q:EQCode'=0
	.s BatchFlag=$P(^DHCEQOutStockList(RLRowID),"^",2)
	.q:BatchFlag="Y"
	.s Equip=$P(^DHCEQOutStockList(RLRowID),"^",4)
	.s EquipName=$P(^DHCEQEquip(Equip),"^",1)
	.s EquipStockStatus=$P(^DHCEQEquip(Equip),"^",60)
	.s EquipStock=$P(^DHCEQEquip(Equip),"^",67)
	.s EquipInvalid=$P(^DHCEQEquip(Equip),"^",59)
	.s EquipEquipType=$P(^DHCEQEquip(Equip),"^",63)
	.i EquipEquipType'=REquipType s EquipVaildCount=EquipVaildCount+1
	.i EquipInvalid="Y" s EquipVaildCount=EquipVaildCount+1
	.i EquipStockStatus'="1" s EquipVaildCount=EquipVaildCount+1
	.i Stock'=EquipStock s EquipVaildCount=EquipVaildCount+1
	.q:EquipVaildCount>0
	.s EQCode=##class(web.DHCEQStoreMove).UpdateEquipStockStatus(Equip,"3",Stock)
	.q:EQCode'=0
	.s CSCode=..InSertChangeStock(Equip,RLRowID,User,Date)
	i EquipVaildCount>0 q EquipName_"所在库房或库房状态或者状态不符合条件"
	i CSCode'=0 q EquipName_"插入变动信息错误"
	i EQCode'=0 q EquipName_"更改设备信息错误"
	q 0
}

ClassMethod UpdateOtherDataByBatch(RowID, User, Date)
{
	s RLRowID=0
	s Code=0
	s (InStockList,EquipName)=""
	f  s RLRowID=$o(^DHCEQOutStockList(0,"OutStock",RowID,RLRowID))  quit:(RLRowID="")||(Code'=0)  d
	.s BatchFlag=$P(^DHCEQOutStockList(RLRowID),"^",2)
	.q:BatchFlag="N"
	.s InStockList=$P(^DHCEQOutStockList(RLRowID),"^",3)
	.s EquipName=$P(^DHCEQInStockList(InStockList),"^",5)
	.s Code=..UpdateOtherDataByRLID(RLRowID,User,Date)
	i Code'=0 q EquipName_Code
	q 0
}

ClassMethod UpdateOtherDataByRLID(RowID, User, Date)
{
	s EQCode=0
	s CSCode=0
	s EquipCount=0
	s Equip=0
	s Stock=""
	s CSRowID=$P(^DHCEQOutStockList(RowID),"^",1)
	s REquipType=$P(^DHCEQOutStock(CSRowID),"^",15)
	s Total=$P(^DHCEQOutStockList(RowID),"^",5)
	s InStockList=$P(^DHCEQOutStockList(RowID),"^",3)
	s Stock=$P(^DHCEQOutStock(CSRowID),"^",2)
	s EquipName=""
	f  s Equip=$O(^DHCEQEquip(0,"StoreInStock",Stock,REquipType,"1","N",InStockList,Equip)) q:(Equip="")||(CSCode+EQCode'=0)||(EquipCount>=Total)  d
	.s EQCode=##class(web.DHCEQStoreMove).UpdateEquipStockStatus(Equip,"3",Stock)
	.q:EQCode'=0
	.s EquipCount=EquipCount+1
	.s CSCode=..InSertChangeStock(Equip,RowID,User,Date)
	i EquipCount<Total q "最多可以退货"_EquipCount
	i EQCode'=0 q "修改设备状态错误"
	i CSCode'=0 q "插入变动信息错误"
	q 0
}

ClassMethod InSertChangeStock(EquipID, RLRowID, User, Date)
{
	new RowID
	s RowID=$P(^DHCEQOutStockList(RLRowID),"^",1)
	s BillDate=$P(^DHCEQOutStock(RowID),"^",11)
	s CSPL(2)=EquipID
	s CSPL(3)=$P(^DHCEQOutStock(RowID),"^",2)
	//s CSPL(4)=$P(^DHCEQOutStock(RowID),"^",3)
	s CSPL(5)=RLRowID
	s CSPL(6)="2"
	s CSPL(7)=Date
	s CSPL(8)=User
	s CSPL(9)=Date
	s CSPL(10)=BillDate
	&SQL(Insert into sqluser.DHC_EQChangeStock values :CSPL())
	q SQLCODE
}

ClassMethod GetID(rowid)
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQOutStock(rowid)
	s resultex=resultex_"^"	;OutStockLocDR
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",2))
	s resultex=resultex_"^"	;ProviderDR
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("prov",$p(result,"^",3))
	s $p(result,"^",4)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",4),"date")	;OutStockDate
	s resultex=resultex_"^"	;MakerDR
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",5))
	s $p(result,"^",6)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",6),"date")	;MakeDate
	s resultex=resultex_"^"	;AckUserDR
	i $p(result,"^",7)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",7))
	s $p(result,"^",8)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",8),"date")	;AckDate
	s resultex=resultex_"^"	;BillAckUserDR
	i $p(result,"^",10)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",10))
	s $p(result,"^",11)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",11),"date")	;BillAckDate
	s resultex=resultex_"^"	;EquipTypeDR
	i $p(result,"^",15)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCEquipType",$p(result,"^",15))),"^",2)
	s resultex=resultex_"^"	;StatCatDR
	i $p(result,"^",16)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCStatCat",$p(result,"^",16))),"^",2)
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex
}

ClassMethod StatusList(name, width, Type) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	i (Type="0")||(Type="4") w "<option value=0>"_..GetStatu("0")_"</option>"
	i Type'="2" w "<option value=1>"_..GetStatu("1")_"</option>"
	w "<option value=2>"_..GetStatu("2")_"</option>"
	w "<option value=3>"_..GetStatu("3")_"</option>"
	w "</select>",!
}

ClassMethod GetStatus(RowID)
{
	i RowID="" q ""
	q $P(^DHCEQOutStock(RowID),"^",13)
}

ClassMethod OutStockListIsVaild(RowID)
{
	s RLRowID=0
	s EquipVaildCount=0
	s BatchVaildCount=0
	s ListCount=0
	s EquipName=""
	s REquipType=$P(^DHCEQOutStock(RowID),"^",15)
	s RStatCat=$P(^DHCEQOutStock(RowID),"^",16)
	f  s RLRowID=$o(^DHCEQOutStockList(0,"OutStock",RowID,RLRowID))  quit:(RLRowID="")||(EquipVaildCount+BatchVaildCount>0)  d
	.s ListCount=ListCount+1
	.s BatchFlag=$P(^DHCEQOutStockList(RLRowID),"^",2)
	.q:EquipVaildCount+BatchVaildCount>0
	.//s EquipName=$P(^DHCEQOutStockList(RLRowID),"^",5)
	.i BatchFlag="Y" d
	..s InStockList=$P(^DHCEQOutStockList(RLRowID),"^",3)
	..s MoveQuantity=$P(^DHCEQOutStockList(RLRowID),"^",5)
	..s EquipName=$P(^DHCEQInStockList(InStockList),"^",5)
	..s Stock=$P(^DHCEQOutStock(RowID),"^",2)
	..s TotalQuantity=##class(web.DHCEQStoreMove).GetTotalMoveQuantity(Stock,InStockList,REquipType,RStatCat)
	..i MoveQuantity>TotalQuantity s BatchVaildCount=BatchVaildCount+1
	.i BatchFlag="N" d
	..s Equip=$P(^DHCEQOutStockList(RLRowID),"^",4)
	..s EquipName=$P(^DHCEQEquip(Equip),"^",1)
	..s Stock=$P(^DHCEQOutStock(RowID),"^",2)
	..s EquipStockStatus=$P(^DHCEQEquip(Equip),"^",60)
	..s EquipStock=$P(^DHCEQEquip(Equip),"^",67)
	..s EquipInvalid=$P(^DHCEQEquip(Equip),"^",59)
	..s EquipEquipType=$P(^DHCEQEquip(Equip),"^",63)
	..i EquipEquipType'=REquipType s EquipVaildCount=EquipVaildCount+1
	..i EquipInvalid="Y" s EquipVaildCount=EquipVaildCount+1
	..i EquipStockStatus'="1" s EquipVaildCount=EquipVaildCount+1
	..i Stock'=EquipStock s EquipVaildCount=EquipVaildCount+1
	i ListCount=0 q "没有录入退货明细"
	i BatchVaildCount>0 q EquipName_"最多可以退货"_TotalQuantity
	i EquipVaildCount>0 q EquipName_"所在库房或库房状态或者状态不符合退库条件"
	q 0
}

ClassMethod GetStatu(TStatus)
{
	q $CASE(TStatus,"0":"新增","1":"提交","3":"出库审核","2":"账目审核",:"没有定义")
}

ClassMethod GetList(OutStockID)
{
	new RLID,RLIDs
	s RLIDs=""
	s RLID=0
	f  s RLID=$o(^DHCEQOutStockList(0,"OutStock",OutStockID,RLID)) q:RLID=""  d
	.i RLIDs="" d
	..s RLIDs=RLID
	.e  d
	..s RLIDs=RLIDs_"^"_RLID
	q RLIDs
}

}
