/// -------------------------------
/// 修改：zy 2009-07-22   zy0008
/// 修改方法：SaveData
/// 描述:设备退货单提交时判断科室类型是否属于库房类型，不是则不能提交
/// -------------------------------
Class web.DHCEQReturn Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 103;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

// 设备退货单

Parameter SQLCODE = "R_RowID";

Parameter SQLDESCRIPTION = "R_RowID";

Parameter SQLROWID = "R_RowID";

ClassMethod ReturnClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReturnExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ReturnExecute(ByRef qHandle As %Binary, QXType, Type, Loc As %String = "", Status As %String = "", StartDate As %String = "", EndDate As %String = "", OutTypeDR As %String = "", ToDeptDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetInStock
	Quit $$$OK
BuildDataGetInStock
	f  s rowid=$o(^DHCEQReturn(rowid))  quit:rowid=""  d
	.d ResetVariablesGetInStock
	.s TRowID = rowid
	.s TReturnNo = $p($g(^DHCEQReturn(rowid)),"^",1) //退货单号
	.s TReturnLocDR = $p($g(^DHCEQReturn(rowid)),"^",2) //退货科室
	.q:(Loc'="")&&(Loc'=TReturnLocDR)
	.q:(1=(##Class(web.DHCEQCommon).LocIsInEQ(QXType,TReturnLocDR)))
	.i TReturnLocDR '=""  d
	..s TReturnLoc = $p($g(^CTLOC(TReturnLocDR)),"^",2)
	.s TProviderDR = $p($g(^DHCEQReturn(rowid)),"^",3) //供应商
	.i TProviderDR '=""  d
	..s TProvider = ##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	.i StartDate="" s StartDate=0
	.i EndDate="" s EndDate=+$h
	.s ReturnDate=$p($g(^DHCEQReturn(rowid)),"^",4)  //退货日期
	.q:(ReturnDate>EndDate)||(ReturnDate<StartDate)
	.s TReturnDate = ##class(web.DHCEQCommon).TransValueToPage(ReturnDate,"date") //退货日期
	.s TStatus = $p($g(^DHCEQReturn(rowid)),"^",13) //状态
	.q:(Type="1")&&(TStatus="0")
	.q:(Type="2")&&(TStatus="0")
	.q:(Type="2")&&(TStatus="1")
	.q:(Status'="")&&(Status'=TStatus)
	.s TStatus=..GetStatu(TStatus)
	.s TRemark = $p($g(^DHCEQReturn(rowid)),"^",14) //备注
	.s TBillAuditUserDR = $p($g(^DHCEQInStock(rowid)),"^",10) //账目确认人
	.i TBillAuditUserDR '=""  d
	..s TBillAuditUser = $p($g(^SSU("SSUSR",TBillAuditUserDR)),"^",2)
	.s TEquipTypeDR=$p($g(^DHCEQReturn(rowid)),"^",15)
	.q:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	.i TEquipTypeDR '=""  d
	..s TEquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	.s TStatCatDR=$p($g(^DHCEQReturn(rowid)),"^",16)
	.i TStatCatDR '=""  d
	..s TStatCat = $p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
	.s TOutType=$p($g(^DHCEQReturn(rowid)),"^",17)
	.q:(OutTypeDR'="")&&(OutTypeDR'=TOutType)
	.q:(OutTypeDR="")&&(1=TOutType)
	.i TOutType'="" s TOutType=$p($g(^DHCEQCCode("DHCEQCOutType",TOutType)),"^",2)
	.s TToDept=$p($g(^DHCEQReturn(rowid)),"^",18)
	.q:(ToDeptDR'="")&&(ToDeptDR'=TToDept)
	.i TToDept'="" s TToDept=$p($g(^DHCEQCCode("DHCEQCFromToDept",TToDept)),"^",2)
	.d OutputRowGetInStock
	quit
OutputRowGetInStock                                 
	s Data=$lb(TRowID,TReturnNo,TReturnLoc,TProvider,TReturnDate,TStatus,TRemark,TBillAuditUser,TEquipTypeDR,TEquipType,TStatCatDR,TStatCat,TOutType,TToDept)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetInStock
	s (TRowID,TReturnNo,TReturnLoc,TProvider,TReturnDate,TStatus,TRemark,TBillAuditUser,TEquipTypeDR,TEquipType,TStatCatDR,TStatCat,TOutType,TToDept)=""
	quit
}

ClassMethod ReturnFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReturnExecute ]
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

Query Return(QXType, Type, LocDR As %String = "", Status As %String = "", StartDate As %String = "", EndDate As %String = "", OutTypeDR As %String = "", ToDeptDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TReturnNo:%String,TReturnLoc:%String,TProvider:%String,TReturnDate:%String,TStatus:%String,TRemark:%String,TBillAuditUser:%String,TEquipTypeDR:%String,TEquipType:%String,TStatCatDR:%String,TStatCat:%String,TOutType:%String,TToDept:%String")
{
}

/// -------------------------------
/// 修改：zy 2009-07-22   zy0008
/// 描述:设备退货单提交时判断科室类型是否属于库房类型，不是就返回。
/// 备注:科室类型：1，库房；0，科室
/// -------------------------------
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
 		s PLIST(2) = $p(val,"^",2)	;ReturnNo
 		s PLIST(3) = $p(val,"^",3)	;ReturnLocDR
 		s PLIST(4) = $p(val,"^",4)	;ProviderDR
 		s PLIST(5) = $p(val,"^",5)	;ReturnDate
 		i $p(val,"^",5)'=""  s PLIST(5) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",5),"date")	;ReturnDate
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
 		s PLIST(18) = $p(val,"^",18)	;OutTypeDR
 		s PLIST(19) = $p(val,"^",19)	;ToDeptDR
 		k PLIST(1)
 		if RowID=""
 		{
	 		i PLIST(2)="" s PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQReturn",+$H,$p(val,"^",3),$p(val,"^",16))	// Mozy	2016-10-21
	 		&SQL(insert into sqluser.DHC_EQReturn values :PLIST())
 		}
 		else
 		{
	 		&SQL(update sqluser.DHC_EQReturn values :PLIST() where R_RowID=:RowID)
 		}
	}
	if +Type=1
	{
		;Modified by ZY 2009-07-22 ZY0008
		s ReturnLocDr=$p($g(^DHCEQReturn(RowID)),"^",2)
  		i '$d(^DHCEQCCode("DHCEQCLocType",0,"LocType",1,ReturnLocDr)) q "退货科室不属于库房类型,请修改更新!"   //判断退货科室类型是否属于库房
		;end 2009-07-22 ZY0008
		s PLIST(6) = User //$p(val,"^",5)	;MakerDR
 		s PLIST(7) = Date
 		&SQL(update sqluser.DHC_EQReturn values :PLIST() where R_RowID=:RowID)
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
		;Modified by DJ 2009-08-05 DJ0014		
		;s BatchCode=..UpdateOtherDataByBatch(RowID, User, Date)
		;if BatchCode'=0
		;{
		;	TROLLBACK
		;	q BatchCode
		;}
		&SQL(update sqluser.DHC_EQReturn values :PLIST() where R_RowID=:RowID)
	}
	if +Type=2
	{
		s PLIST(11)=User
		s PLIST(12)=Date
		S PLIST(13)=Time
		s i=$l(val,"^")
		s ValList=$P(val,"^",2,i)
		s SQLCODE=..UpdateReturnList(ValList)
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
		&SQL(update sqluser.DHC_EQReturn values :PLIST() where R_RowID=:RowID)
	}
	if +Type=4
	{
		&SQL(delete from sqluser.DHC_EQReturnList where RL_ReturnDR=:RowID)
		i SQLCODE=100 s SQLCODE=0
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		&SQL(delete from sqluser.DHC_EQReturn where R_RowID=:RowID)
		
	}
	if +Type=5
	{
		s PLIST(6) = User //$p(val,"^",5)	;MakerDR
 		s PLIST(7) = Date
 		s PLIST(14) = "0"
 		&SQL(update sqluser.DHC_EQReturn values :PLIST() where R_RowID=:RowID)
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
	f  s RLID=$o(^DHCEQReturnList(0,"Return",RID,RLID)) q:(RLID="")||(SQLCODE'=0)  d
	.s Flag=$p(^DHCEQReturnList(RLID),"^",2)
	.i Flag="Y" d
	..s InStockListID=$P(^DHCEQReturnList(RLID),"^",3)
	..s BPLID=$p(^DHCEQInStockList(InStockListID),"^",4)
	..q:BPLID=""
	..s Num=$P(^DHCEQReturnList(RLID),"^",5)
	..s SQLCODE=##class(web.DHCEQOpenCheck).UpdateBPLArriveNum(-Num,BPLID)
	.q:SQLCODE'=0
	.i Flag'="Y" d
	..s EquipID=$P(^DHCEQReturnList(RLID),"^",4)
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

ClassMethod UpdateReturnList(ValList)
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
		&SQL(update sqluser.DHC_EQReturnList set RL_InvoiceNo=:Invoice where RL_RowID=:ISLRow)
		s CODE=CODE+SQLCODE
	}
	q CODE
}

ClassMethod UpdateChangeStock(RowID, Date)
{
	s ISLRowID=0
	s CSCode=0
	f  s ISLRowID=$o(^DHCEQReturnList(0,"Return",RowID,ISLRowID))  quit:ISLRowID=""  d
	.&SQL(update sqluser.DHC_EQChangeStock set CS_BillChangeDate=:Date where CS_SourceID=:ISLRowID and CS_ChangeType='2')
	.s CSCode=CSCode+SQLCODE
	q CSCode
}

/// 修改：2009-07-22 党军
/// 描述：增加设备退货生命周期信息记录
ClassMethod UpdateOtherDataByEquip(RowID, User, Date)
{
	s RLRowID=0
	s Error=""
	s EquipName=""
	s Stock=$P(^DHCEQReturn(RowID),"^",2)
	s REquipType=$P(^DHCEQReturn(RowID),"^",15)
	s ToDeptDR=$P(^DHCEQReturn(RowID),"^",18)
	f  s RLRowID=$o(^DHCEQReturnList(0,"Return",RowID,RLRowID))  quit:(RLRowID="")||(Error'="")  d
	.s BatchFlag=$P(^DHCEQReturnList(RLRowID),"^",2)
	.i BatchFlag="Y"  d
	..s InStockList=$P(^DHCEQReturnList(RLRowID),"^",3)
	..s EquipName=$P(^DHCEQInStockList(InStockList),"^",5)
	..s CSRowID=$P(^DHCEQReturnList(RLRowID),"^",1)
	..s Total=$P(^DHCEQReturnList(RLRowID),"^",5)
	..s Equip=0
	..s EquipCount=0
	..f  s Equip=$O(^DHCEQEquip(0,"StoreInStock",Stock,REquipType,"1","N",InStockList,Equip)) q:(Equip="")||(Error'="")||(EquipCount>=Total)  d
	...s EquipCount=EquipCount+1
	...s Error=..InsertLifeInfo(Equip,EquipName, Stock, ToDeptDR, RLRowID, User, Date, RowID)
	..i (Error="")&&(EquipCount<Total) s Error="最多可以退货"_EquipCount	
	.e  d
	..s Equip=$P(^DHCEQReturnList(RLRowID),"^",4)
	..s EquipName=$P(^DHCEQEquip(Equip),"^",1)
	..s EquipStockStatus=$P(^DHCEQEquip(Equip),"^",60)
	..s EquipStock=$P(^DHCEQEquip(Equip),"^",67)
	..s EquipInvalid=$P(^DHCEQEquip(Equip),"^",59)
	..s EquipEquipType=$P(^DHCEQEquip(Equip),"^",63)
	..i EquipEquipType'=REquipType s Error=EquipName_"该设备类组与退货单的类组不一致"
	..i EquipInvalid="Y" s Error=EquipName_"状态已经无效"
	..i EquipStockStatus'="1" s Error=EquipName_"所在库房状态不符合条件"
	..i Stock'=EquipStock s Error=EquipName_"已经不在原来库房"
	..q:Error'=""
	..s Error=..InsertLifeInfo(Equip,EquipName, Stock, ToDeptDR, RLRowID, User, Date, RowID)
	i Error'="" q Error
	q 0
}

/// 新增：2009-07-22 党军
/// 描述：记录设备退货生命周期信息
ClassMethod InsertLifeInfo(Equip, EquipName, Stock, ToDeptDR, RLRowID, User, Date, RowID)
{
	s Error=""
	s LI(2)=Equip  //设备
	s LI(4)=$p($g(^DHCEQEquip(Equip)),"^",19)   //原使用科室 
	s LI(5)=$p($g(^DHCEQEquip(Equip)),"^",17)  //原管理科室
	s LI(6)=$p($g(^DHCEQEquip(Equip)),"^",67)  //原库房
	s LI(7)=$p($g(^DHCEQEquip(Equip)),"^",27)  //原值
	s LI(8)=$p($g(^DHCEQEquip(Equip)),"^",28)  //原净值
	s LI(14)=$p($g(^DHCEQReturnList(RLRowID)),"^",8) //退货原因
	s LI(16)=Date	//变动日期
	s LI(17)=Time	//变动时间
 	s LI(18)=$p($g(^DHCEQReturnList(RLRowID)),"^",10) //费用
 	s LI(19)="C"	//生命周期类型
 	s LI(20)=23	//来源类型
 	s LI(21)=RLRowID //来源ID
 	s LI(22)=$p($g(^DHCEQReturn(RowID)),"^",17) //来源辅助类型
 	s LI(23)=$p($g(^DHCEQReturnList(RLRowID)),"^",9) //备注
 	s LI(27)=User	//更新人
 	s LI(28)=Date	//更新日期
 	s LI(29)=Time	//更新时间 	
	i (##class(web.DHCEQStoreMove).UpdateEquipStockStatus(Equip,"3",Stock,"","",ToDeptDR)'=0) s Error=EquipName_"更改设备信息错误"
	i Error'="" q Error
	s LI(9)=$p($g(^DHCEQEquip(Equip)),"^",19)   //变动后使用科室 
 	s LI(10)=$p($g(^DHCEQEquip(Equip)),"^",17) //变动后管理科室
 	s LI(11)=$p($g(^DHCEQEquip(Equip)),"^",67)  //变动后库房
 	s LI(12)=$p($g(^DHCEQEquip(Equip)),"^",27)  //变动后原值
 	s LI(13)=$p($g(^DHCEQEquip(Equip)),"^",28)  //变动后净值
 	&SQL(Insert Into SQLUSER.DHC_EQLifeInfo Values :LI())
 	i SQLCODE'=0 s Error=EquipName_"更新生命周期表信息失败!"
 	i Error'="" q Error
 	i (..InSertChangeStock(Equip,RLRowID,User,Date)'=0) s Error=EquipName_"插入变动信息错误" 
 	q Error
}

ClassMethod UpdateOtherDataByBatch(RowID, User, Date)
{
	s RLRowID=0
	s Code=0
	s (InStockList,EquipName)=""
	f  s RLRowID=$o(^DHCEQReturnList(0,"Return",RowID,RLRowID))  quit:(RLRowID="")||(Code'=0)  d
	.s BatchFlag=$P(^DHCEQReturnList(RLRowID),"^",2)
	.q:BatchFlag="N"
	.s InStockList=$P(^DHCEQReturnList(RLRowID),"^",3)
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
	s CSRowID=$P(^DHCEQReturnList(RowID),"^",1)
	s REquipType=$P(^DHCEQReturn(CSRowID),"^",15)
	s Total=$P(^DHCEQReturnList(RowID),"^",5)
	s InStockList=$P(^DHCEQReturnList(RowID),"^",3)
	s Stock=$P(^DHCEQReturn(CSRowID),"^",2)
	s ToDeptDR=$P(^DHCEQReturn(CSRowID),"^",18)
	s EquipName=""
	f  s Equip=$O(^DHCEQEquip(0,"StoreInStock",Stock,REquipType,"1","N",InStockList,Equip)) q:(Equip="")||(CSCode+EQCode'=0)||(EquipCount>=Total)  d
	.s EQCode=##class(web.DHCEQStoreMove).UpdateEquipStockStatus(Equip,"3",Stock,"","",ToDeptDR)
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
	s RowID=$P(^DHCEQReturnList(RLRowID),"^",1)
	s BillDate=$P(^DHCEQReturn(RowID),"^",11)
	s CSPL(2)=EquipID
	s CSPL(3)=$P(^DHCEQReturn(RowID),"^",2)
	//s CSPL(4)=$P(^DHCEQReturn(RowID),"^",3)
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
	s result= ^DHCEQReturn(rowid)
	s resultex=resultex_"^"	;ReturnLocDR
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",2))
	s resultex=resultex_"^"	;ProviderDR
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("prov",$p(result,"^",3))
	s $p(result,"^",4)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",4),"date")	;ReturnDate
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
	
	s resultex=resultex_"^"	;
	i $p(result,"^",17)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCOutType",$p(result,"^",17))),"^",2)
	s resultex=resultex_"^"	;
	i $p(result,"^",18)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCFromToDept",$p(result,"^",18))),"^",2)
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	s resultex=resultex_"^"_..GetOneReturnTotalFeeNum(rowid)	;单据数量及金额汇总
	s resultex=resultex_"^"	;
	i $p(result,"^",24)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",24))
	q result_resultex
}

ClassMethod GetOneReturnTotalFeeNum(rowid)
{
	new RLRowID,Fee,Num
	s RLRowID=0
	s Fee=0
	s Num=0
	f  s RLRowID=$o(^DHCEQReturnList(0,"Return",rowid,RLRowID)) q:RLRowID=""  d
	.s QuantityNum=$P(^DHCEQReturnList(RLRowID),"^",5)
	.s OriginalFee=$P(^DHCEQReturnList(RLRowID),"^",6)
	.s Fee=Fee+(QuantityNum*OriginalFee)
	.s Num=Num+QuantityNum
	i Fee=0  d
	.s Fee=""
	e  d
	.s Fee=##Class(web.DHCEQCommon).FormatNumber(Fee,"",2)
	i Num=0 s Num=""
	q Num_"^"_Fee
}

/// modify by jyp 2018-08-19 Hisui改造：自定义下拉列表格式错误
/// Modfied by zc0126 2022-12-26 2162208 增加CancelOper入参
ClassMethod StatusList(name, width, Type, Value As %Library.String = "", CancelOper As %String = "") As %String
{
	;;下拉列表
	//w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	//begin modify by jyp 2018-09-05 Hisui改造：自定义下拉列表格式错误
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")    
	s selectedone=$case(Value,0:"selected",:"")
	s selectedtwo=$case(Value,1:"selected",:"")
	s selectedthree=$case(Value,2:"selected",:"")
	///Modfied by zc0126 2022-12-26 2162208 增加CancelOper入参 begin
	//w "<option value=></option>"
	//i (Type="")||(Type="0")||(Type="4") w "<option value=0 "_selectedone_">"_..GetStatu("0")_"</option>"	// Mozy	2010-12-16
	//i Type'="2" w "<option value=1 "_selectedtwo_">"_..GetStatu("1")_"</option>"
	//w "<option value=2 "_selectedthree_">"_..GetStatu("2")_"</option>"
	//end modify by jyp 2018-09-05 Hisui改造：自定义下拉列表格式错误
	;w "<option value=3>"_..GetStatu("3")_"</option>"
	s selectedfour=$case(Value,3:"selected",:"")		//modified by CZF0060 2020-02-20 begin
	w "<option value=></option>"
	i CancelOper="Y"
	{
		w "<option value=2 "_selectedthree_">"_..GetStatu(2)_"</option>"
		w "<option value=3 "_selectedfour_">"_..GetStatu(3)_"</option>"
	}
	else
	{
		i (Type="")||(Type="0")||(Type="4") w "<option value=0 "_selectedone_">"_..GetStatu(0)_"</option>"
		i Type'="2" w "<option value=1 "_selectedtwo_">"_..GetStatu(1)_"</option>"
		w "<option value=2 "_selectedthree_">"_..GetStatu(2)_"</option>"		//modified by CZF0060 2020-02-20 end
	}
	///Modfied by zc0126 2022-12-26 2162208 增加CancelOper入参 end
	w "</select>",!
}

ClassMethod GetStatus(RowID)
{
	i RowID="" q ""
	q $P(^DHCEQReturn(RowID),"^",13)
}

ClassMethod ReturnListIsVaild(RowID)
{
	s RLRowID=0
	s EquipVaildCount=0
	s BatchVaildCount=0
	s ListCount=0
	s EquipName=""
	s REquipType=$P(^DHCEQReturn(RowID),"^",15)
	s RStatCat=$P(^DHCEQReturn(RowID),"^",16)
	f  s RLRowID=$o(^DHCEQReturnList(0,"Return",RowID,RLRowID))  quit:(RLRowID="")||(EquipVaildCount+BatchVaildCount>0)  d
	.s ListCount=ListCount+1
	.s BatchFlag=$P(^DHCEQReturnList(RLRowID),"^",2)
	.q:EquipVaildCount+BatchVaildCount>0
	.//s EquipName=$P(^DHCEQReturnList(RLRowID),"^",5)
	.i BatchFlag="Y" d
	..s InStockList=$P(^DHCEQReturnList(RLRowID),"^",3)
	..s MoveQuantity=$P(^DHCEQReturnList(RLRowID),"^",5)
	..s EquipName=$P(^DHCEQInStockList(InStockList),"^",5)
	..s Stock=$P(^DHCEQReturn(RowID),"^",2)
	..s TotalQuantity=##class(web.DHCEQStoreMove).GetTotalMoveQuantity(Stock,InStockList,REquipType,RStatCat)
	..i MoveQuantity>TotalQuantity s BatchVaildCount=BatchVaildCount+1
	.i BatchFlag="N" d
	..s Equip=$P(^DHCEQReturnList(RLRowID),"^",4)
	..s EquipName=$P(^DHCEQEquip(Equip),"^",1)
	..s Stock=$P(^DHCEQReturn(RowID),"^",2)
	..s EquipStockStatus=$P(^DHCEQEquip(Equip),"^",60)
	..s EquipStock=$P(^DHCEQEquip(Equip),"^",67)
	..s EquipInvalid=$P(^DHCEQEquip(Equip),"^",59)
	..s EquipEquipType=$P(^DHCEQEquip(Equip),"^",63)
	..i EquipEquipType'=REquipType s EquipVaildCount=EquipVaildCount+1
	..i EquipInvalid="Y" s EquipVaildCount=EquipVaildCount+1
	..i EquipStockStatus'="1" s EquipVaildCount=EquipVaildCount+1
	..i Stock'=EquipStock s EquipVaildCount=EquipVaildCount+1
	i ListCount=0 q "没有录入明细"
	i BatchVaildCount>0 q EquipName_"最多可以退货"_TotalQuantity
	i EquipVaildCount>0 q EquipName_"所在库房或库房状态或者状态不符合条件"
	q 0
}

ClassMethod GetStatu(TStatus)
{
	;q $CASE(TStatus,"0":"新增","1":"提交","3":"出库审核","2":"账目审核",:"没有定义")
	q $CASE(TStatus,"0":"新增","1":"提交","2":"审核","3":"作废",:"没有定义")    ///Modfied by zc0126 2022-12-26 2162208 增加作废状态
}

ClassMethod GetList(ReturnID)
{
	new RLID,RLIDs
	s RLIDs=""
	s RLID=0
	f  s RLID=$o(^DHCEQReturnList(0,"Return",ReturnID,RLID)) q:RLID=""  d
	.i RLIDs="" d
	..s RLIDs=RLID
	.e  d
	..s RLIDs=RLIDs_"^"_RLID
	q RLIDs
}

}
