/// 已停用， 20150902 JDL After V4.0.0
/// -------------------------------
/// 修改：zy 2009-07-22   zy0008
/// 修改方法：UpdateData
/// 描述:设备转移单提交时判断供给部门或接受部门与设备转移条件是否符合。
/// -------------------------------
/// 修改：jdl 2009-07-23 JDL0015
/// 修改方法:UpdateData
/// 描述:从入库单生成出库单后，接收科室为空应不能提交
/// -------------------------------
Class web.DHCEQStoreMove Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 137;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "SM_RowID";

Parameter SQLDESCRIPTION = "SM_RowID";

Parameter SQLROWID = "SM_RowID";

Parameter GlobalLen = 23;

/// 修改：jdl 2009-07-23 JDL0015
/// 描述：从入库单生成出库单后，接收科室为空应不能提交
/// -------------------------------
/// 修改：zy 2009-07-22   zy0008
/// 描述:设备转移单提交时判断供给部门或接受部门与设备转移条件是否符合。
/// 备注:设备转移：0，库房分配；3，科室退库
/// -------------------------------
ClassMethod UpdateData(val, Type)
{
	//Type=0 新增、更新
	//Type=1 提交
	//Type=2 出库审核
	//Type=3 入库审核
	//Type=4 删除
	//Type=5 反提交
	//
	//Type=9 账务审核
	s Date=+$H
	s Time=$P($H,",",2)
	s RowID=$P(val,"^",1)
	s PLIST(14)=Type
	s User=$P(val,"^",16)
	TSTART
	if +Type=0
	{
		s PLIST(1) = $p(val,"^",1)	;RowID
 		s PLIST(2) = $p(val,"^",2)	;StoreMoveNo
 		s PLIST(3) = $p(val,"^",3)	;FromLocDR
 		s PLIST(4) = $p(val,"^",4)	;ToLocDR
 		s PLIST(5) = User //$p(val,"^",5)	;MakerDR
 		s PLIST(6) = Date //$p(val,"^",6)	;MakeDate
 		s PLIST(13) = $p(val,"^",13)	;MoveType
 		//s PLIST(14) = $p(val,"^",14)	;Status
 		s PLIST(15) = $p(val,"^",15)	;Remark
 		s PLIST(16) = $p(val,"^",17)	;ReciverDR
 		s PLIST(17) = $p(val,"^",18)	;EquipTypeDR
 		s PLIST(18) = $p(val,"^",19)	;StatCatDR
 		k PLIST(1)
 		if RowID=""
 		{
	 		i PLIST(2)="" s PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQStoreMove",+$H)
	 		&SQL(insert into sqluser.DHC_EQStoreMove values :PLIST())
 		}
 		else
 		{
	 		&SQL(update sqluser.DHC_EQStoreMove values :PLIST() where SM_RowID=:RowID)
 		}
	}
	if +Type=1
	{
		;Modified by ZY 2009-07-23 ZY0008
		s MoveType=$p($g(^DHCEQStoreMove(RowID)),"^",12)
  		i MoveType=0    //转移类型：0，库房分配
  		{
			s FromLocDR=$p($g(^DHCEQStoreMove(RowID)),"^",2)
			i '$d(^DHCEQCCode("DHCEQCLocType",0,"LocType",1,FromLocDR)) q "供给部门不是库房,请修改!"  //判断供给部门科室类型是否属于库房		
  		}
 		 i MoveType=3    //转移类型：3，科室退库
 		{
			s ToLocDR=$p($g(^DHCEQStoreMove(RowID)),"^",3)
			i '$d(^DHCEQCCode("DHCEQCLocType",0,"LocType",1,ToLocDR)) q "接收部门不是库房,请修改!"   //判断接受部门科室类型是否属于库房
 		}
		;end 2009-07-23 ZY0008
		s PLIST(5) = User //$p(val,"^",5)	;MakerDR
 		s PLIST(6) = Date
 		;Add by JDL 2009-07-23 JDL0015
		i $P(^DHCEQStoreMove(RowID),"^",3)=""
		{
			TRollback
			q "接收科室不能为空!"
		}
 		///管理审核放在第几步,0：提交后，出库审核前 1：出库审核后，入库审核前
		i ##class(web.DHCEQCommon).GetSysInfo("302008")'=1
		{
			//如果不需要管理审核则直接置为管理审核状态	
			s MoveType=$P(^DHCEQStoreMove(RowID),"^",12)	
			s sysmovetype=##class(web.DHCEQCommon).GetSysInfo("302007")
			s sysmovetype=","_sysmovetype_","		
			if (sysmovetype[(","_MoveType_","))
			{
				//s PLIST(19)=User
				s PLIST(20)=Date
				S PLIST(21)=Time
				s PLIST(14)="9"
			}
		}
 		&SQL(update sqluser.DHC_EQStoreMove values :PLIST() where SM_RowID=:RowID)
	}
	if +Type=2
	{
		s PLIST(7)=User
		S PLIST(8)=Date
		s PLIST(9)=Time
		s PLIST(16) = $p(val,"^",17)	;ReciverDR
		s MoveType=$P(^DHCEQStoreMove(RowID),"^",12)
		///管理审核放在第几步,0：提交后，出库审核前 1：出库审核后，入库审核前
		i ##class(web.DHCEQCommon).GetSysInfo("302008")=1
		{
			//如果不需要管理审核则直接置为管理审核状态		
			s sysmovetype=##class(web.DHCEQCommon).GetSysInfo("302007")
			s sysmovetype=","_sysmovetype_","		
			if (sysmovetype[(","_MoveType_","))
			{
				//s PLIST(19)=User
				s PLIST(20)=Date
				S PLIST(21)=Time
				s PLIST(14)="9"
			}
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
		
		i MoveType="0" s MoveCode="302004"
		i MoveType="1" s MoveCode="302005"
		i MoveType="3" s MoveCode="302006"
		i MoveType="2" s MoveCode="302009"
		s UPDEQType=##class(web.DHCEQCommon).GetSysInfo(MoveCode)
		i UPDEQType="0"
		{
			s SQLCODE=..UpdateEquipWhenInAudit(RowID)
			i SQLCODE
			{
				TROLLBACK
				q SQLCODE
			}
			//s PLIST(10)=User
			s PLIST(11)=Date
			S PLIST(12)=Time
			s PLIST(14)="3"
		}
		&SQL(update sqluser.DHC_EQStoreMove values :PLIST() where SM_RowID=:RowID)
	}
	if +Type=3
	{
		s PLIST(10)=User
		s PLIST(11)=Date
		S PLIST(12)=Time
		s SQLCODE=..UpdateEquipWhenInAudit(RowID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		&SQL(update sqluser.DHC_EQStoreMove values :PLIST() where SM_RowID=:RowID)
	}
	if +Type=4
	{
		&SQL(delete from sqluser.DHC_EQStoreMoveList where SML_StoreMoveDR=:RowID)
		i SQLCODE=100 s SQLCODE=0
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		&SQL(delete from sqluser.DHC_EQStoreMove where SM_RowID=:RowID)
	}
	if +Type=5
	{
		s PLIST(5) = User //$p(val,"^",5)	;MakerDR
 		s PLIST(6) = Date
 		s PLIST(14) = "0"
 		&SQL(update sqluser.DHC_EQStoreMove values :PLIST() where SM_RowID=:RowID)
	}
	if +Type=9
	{
		s PLIST(19)=User
		s PLIST(20)=Date
		S PLIST(21)=Time
		&SQL(update sqluser.DHC_EQStoreMove values :PLIST() where SM_RowID=:RowID)
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

ClassMethod UpdateEquipWhenInAudit(RowID)
{
	s Error=""  //2009-07-22 党军
	s SMLRowID=0
	s Equip=""
	s EquipName=""
	s LI(16)=Date	//变动日期 //2009-07-22 党军 begin
	s LI(17)=Time	//变动时间
 	s LI(19)="C"	//生命周期类型
 	s LI(20)=22	//来源类型
 	s LI(22)=$p($g(^DHCEQStoreMove(RowID)),"^",12) //来源辅助类型
 	s LI(27)=User	//更新人
 	s LI(28)=Date	//更新日期
 	s LI(29)=Time	//更新时间 //2009-07-22 党军 end
	s Stock=$P(^DHCEQStoreMove(RowID),"^",3) //移入科室
	f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",RowID,SMLRowID))  quit:(SMLRowID="")||(Error'="")  d //2009-07-22 党军
	.s EquipName=$P(^DHCEQStoreMoveList(SMLRowID),"^",5)
	.s StatCatDR=$P(^DHCEQStoreMove(RowID),"^",17)
	.s CSRowID=0
	.f  s CSRowID=$o(^DHCEQChangeStock(0,"Source","1",SMLRowID,CSRowID)) q:(CSRowID="")||(Error'="")  d //2009-07-22 党军
	..s Equip=$P(^DHCEQChangeStock(CSRowID),"^",1)
	..i Equip="" s Error=EquipName_"得到设备编号错误" //2009-07-22 党军 begin
	..q:Error'=""
	..s LI(2)=Equip  //设备
	..s LI(4)=$p($g(^DHCEQEquip(Equip)),"^",19)   //原使用科室 
	..s LI(5)=$p($g(^DHCEQEquip(Equip)),"^",17)  //原管理科室
	..s LI(6)=$p($g(^DHCEQEquip(Equip)),"^",67)  //原库房
	..s LI(7)=$p($g(^DHCEQEquip(Equip)),"^",27)  //原值
	..s LI(8)=$p($g(^DHCEQEquip(Equip)),"^",28)  //原净值
	..i (..UpdateEquipStockStatus(Equip,"1",Stock,StatCatDR,RowID)'=0) s Error=EquipName_"更新设备状态错误"
	..q:Error'=""
 	..s LI(9)=$p($g(^DHCEQEquip(Equip)),"^",19)   //变动后使用科室 
 	..s LI(10)=$p($g(^DHCEQEquip(Equip)),"^",17) //变动后管理科室
 	..s LI(11)=$p($g(^DHCEQEquip(Equip)),"^",67)  //变动后库房
 	..s LI(12)=$p($g(^DHCEQEquip(Equip)),"^",27)  //变动后原值
 	..s LI(13)=$p($g(^DHCEQEquip(Equip)),"^",28)  //变动后净值 
 	..s LI(21)=SMLRowID //来源ID
 	..s LI(23)=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",11) //备注
 	..&SQL(Insert Into SQLUSER.DHC_EQLifeInfo Values :LI()) 
 	..i SQLCODE'=0 s Error=EquipName_"更新生命周期表信息失败!"
	i Error="" q 0
	q Error //2009-07-22 党军 end
}

ClassMethod GetEquipIDBySMLID(SMLID)
{
	s EquipID=""
	&SQL(select CS_EquipDR into :EquipID from sqluser.DHC_EQChangeStock where CS_SourceID=:SMLID and CS_ChangeType='1')
	q EquipID
}

ClassMethod UpdateOtherDataByEquip(RowID, User, Date)
{
	s SMLRowID=0
	s EQCode=0
	s CSCode=0
	s EquipVaildCount=0
	s EquipName=""
	s Stock=$P(^DHCEQStoreMove(RowID),"^",2)
	s SMEquipType=$P(^DHCEQStoreMove(RowID),"^",16)
	f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",RowID,SMLRowID))  quit:SMLRowID=""  d
	.q:EquipVaildCount>0
	.q:CSCode'=0
	.q:EQCode'=0
	.s BatchFlag=$P(^DHCEQStoreMoveList(SMLRowID),"^",3)
	.q:BatchFlag="Y"
	.s EquipName=$P(^DHCEQStoreMoveList(SMLRowID),"^",5)
	.s Equip=$P(^DHCEQStoreMoveList(SMLRowID),"^",2)
	.s EquipStockStatus=$P(^DHCEQEquip(Equip),"^",60)
	.s EquipStock=$P(^DHCEQEquip(Equip),"^",67)
	.s EquipInvalid=$P(^DHCEQEquip(Equip),"^",59)
	.s EquipEquipType=$P(^DHCEQEquip(Equip),"^",63)
	.i EquipEquipType'=SMEquipType s EquipVaildCount=EquipVaildCount+1
	.i EquipInvalid="Y" s EquipVaildCount=EquipVaildCount+1
	.i EquipStockStatus'="1" s EquipVaildCount=EquipVaildCount+1
	.i Stock'=EquipStock s EquipVaildCount=EquipVaildCount+1
	.q:EquipVaildCount>0
	.s EQCode=..UpdateEquipStockStatus(Equip,"2",Stock,"",RowID)
	.q:EQCode'=0
	.s CSCode=..InSertChangeStock(Equip,SMLRowID,User,Date)
	i EquipVaildCount>0 q EquipName_"所在库房或库房状态或者状态不符合条件"
	i CSCode'=0 q EquipName_"插入变动信息错误"
	i EQCode'=0 q EquipName_"更改设备信息错误"
	q 0
}

ClassMethod UpdateOtherDataByBatch(RowID, User, Date)
{
	s SMLRowID=0
	s Code=0
	s (InStockList,EquipName)=""
	f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",RowID,SMLRowID))  quit:SMLRowID=""  d
	.q:Code'=0
	.s BatchFlag=$P(^DHCEQStoreMoveList(SMLRowID),"^",3)
	.q:BatchFlag'="Y"
	.s EquipName=$P(^DHCEQStoreMoveList(SMLRowID),"^",5)
	.s InStockList=$P(^DHCEQStoreMoveList(SMLRowID),"^",4)
	.s Code=..UpdateOtherDataBySMLID(SMLRowID,User,Date)
	i Code'=0 q EquipName_Code
	q 0
}

ClassMethod UpdateOtherDataBySMLID(RowID, User, Date)
{
	s EQCode=0
	s CSCode=0
	s EquipCount=0
	s Equip=0
	s Stock=""
	s SMRowID=$P(^DHCEQStoreMoveList(RowID),"^",1)
	s SMEquipType=$P(^DHCEQStoreMove(SMRowID),"^",16)
	s Total=$P(^DHCEQStoreMoveList(RowID),"^",8)
	s InStockList=$P(^DHCEQStoreMoveList(RowID),"^",4)
	s Stock=$P(^DHCEQStoreMove(SMRowID),"^",2)
	f  s Equip=$O(^DHCEQEquip(0,"StoreInStock",Stock,SMEquipType,"1","N",InStockList,Equip)) q:(Equip="")||(CSCode+EQCode'=0)||(EquipCount>=Total)  d
	.q:EquipCount>=Total
	.s EQCode=..UpdateEquipStockStatus(Equip,"2",Stock,"",SMRowID)
	.q:EQCode'=0
	.s EquipCount=EquipCount+1
	.s CSCode=..InSertChangeStock(Equip,RowID,User,Date)
	i EquipCount<Total q "最多可以转移"_EquipCount
	i EQCode'=0 q "修改设备状态错误"
	i CSCode'=0 q "插入变动信息错误"
	q 0
}

ClassMethod UpdateEquipStockStatus(EquipID, Status, Stock, StatCatDR, SMRowID, ToDeptDR)
{
	s EQPL(61)=Status
	s EQPL(68)=Stock
	
	if (Status="1")
	{
		//s EQPL(76)=StatCatDR
		s UseLoc=$P(^DHCEQStoreMove(SMRowID),"^",3)
		s MoveType=$P(^DHCEQStoreMove(SMRowID),"^",12)
		i MoveType="0" s MoveCode="302001"
		i MoveType="1" s MoveCode="302002"
		i MoveType="3" s MoveCode="302003"
		i MoveType="2" 
		{	s UPDEQType="0"	}
		else
		{	s UPDEQType=##class(web.DHCEQCommon).GetSysInfo(MoveCode)	}
		i UPDEQType="1" s EQPL(39)="1"
		i UPDEQType="2" s EQPL(20)=UseLoc
		i UPDEQType="4"
		{
			s EQPL(39)="2"
		}
		i UPDEQType="3"
		{
			s EQPL(20)=UseLoc
			s EQPL(39)="1"
			s EQPL(45)=+$H
		}
		i MoveType="3" s EQPL(20)=""
	}
	if (Status="3") s EQPL(23)=ToDeptDR
	
	&SQL(update sqluser.DHC_EQEquip values :EQPL() where EQ_RowID=:EquipID)
	q SQLCODE
}

ClassMethod InSertChangeStock(EquipID, SMLRowID, User, Date)
{
	new RowID
	s RowID=$P(^DHCEQStoreMoveList(SMLRowID),"^",1)
	s CSPL(2)=EquipID
	s CSPL(3)=$P(^DHCEQStoreMove(RowID),"^",2)
	s CSPL(4)=$P(^DHCEQStoreMove(RowID),"^",3)
	s CSPL(5)=SMLRowID
	s CSPL(6)="1"
	s CSPL(7)=Date
	s CSPL(8)=User
	s CSPL(9)=Date
	&SQL(Insert into sqluser.DHC_EQChangeStock values :CSPL())
	q SQLCODE
}

ClassMethod StoreMoveListIsVaild(RowID)
{
	s SMLRowID=0
	s EquipVaildCount=0
	s BatchVaildCount=0
	s ListCount=0
	s EquipName=""
	s SMEquipType=$P(^DHCEQStoreMove(RowID),"^",16)
	s SMStatCat=$P(^DHCEQStoreMove(RowID),"^",17)
	f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",RowID,SMLRowID))  quit:(SMLRowID="")||(EquipVaildCount+BatchVaildCount>0)  d
	.s ListCount=ListCount+1
	.s BatchFlag=$P(^DHCEQStoreMoveList(SMLRowID),"^",3)
	.q:EquipVaildCount+BatchVaildCount>0
	.s EquipName=$P(^DHCEQStoreMoveList(SMLRowID),"^",5)
	.i BatchFlag="Y" d
	..s InStockList=$P(^DHCEQStoreMoveList(SMLRowID),"^",4)
	..s MoveQuantity=$P(^DHCEQStoreMoveList(SMLRowID),"^",8)
	..s Stock=$P(^DHCEQStoreMove(RowID),"^",2)
	..s TotalQuantity=..GetTotalMoveQuantity(Stock,InStockList,SMEquipType,SMStatCat)
	..i MoveQuantity>TotalQuantity s BatchVaildCount=BatchVaildCount+1
	.i BatchFlag="N" d
	..s Equip=$P(^DHCEQStoreMoveList(SMLRowID),"^",2)
	..s Stock=$P(^DHCEQStoreMove(RowID),"^",2)
	..s EquipStockStatus=$P(^DHCEQEquip(Equip),"^",60)
	..s EquipStock=$P(^DHCEQEquip(Equip),"^",67)
	..s EquipInvalid=$P(^DHCEQEquip(Equip),"^",59)
	..s EquipEquipType=$P(^DHCEQEquip(Equip),"^",63)
	..i EquipEquipType'=SMEquipType s EquipVaildCount=EquipVaildCount+1
	..i EquipInvalid="Y" s EquipVaildCount=EquipVaildCount+1
	..i EquipStockStatus'="1" s EquipVaildCount=EquipVaildCount+1
	..i Stock'=EquipStock s EquipVaildCount=EquipVaildCount+1
	i ListCount=0 q "没有录入转移明细"
	i BatchVaildCount>0 q EquipName_"最多可以转移"_TotalQuantity
	i EquipVaildCount>0 q EquipName_"所在库房或库房状态或者状态不符合转移条件"
	q 0
}

ClassMethod GetTotalMoveQuantity(Stock, InStockList, EquipType, StatCat)
{
	s Total=0
	s EQRowID=0
	f  s EQRowID=$O(^DHCEQEquip(0,"StoreInStock",Stock,EquipType,"1","N",InStockList,EQRowID)) q:EQRowID=""  d
	.s StatCatDR=$P(^DHCEQEquip(EQRowID),"^",75)
	.q:StatCatDR'=StatCat
	.s Total=Total+1
	q Total
}

ClassMethod GetOneStoreMove(rowid)
{
	new result,resultex
	s (result,resultex,FromLocCode,ToLocCode)=""
	s result= ^DHCEQStoreMove(rowid)
	set count= ..#GlobalLen-$l(result,"^")
	for i=count:-1:1 { s result=result_"^"}
	s resultex=resultex_"^"	;FromLocDR
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",2))
	.s FromLocCode=$p(^CTLOC($p(result,"^",2)),"^",1)
	s resultex=resultex_"^"	;ToLocDR
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",3))
	.s ToLocCode=$p(^CTLOC($p(result,"^",3)),"^",1)
	s resultex=resultex_"^"	;MakerDR
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",4))
	s $p(result,"^",5)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",5),"date")	;MakeDate
	s resultex=resultex_"^"	;AckUserDR
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",6))
	s $p(result,"^",7)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",7),"date")	;AckDate
	s resultex=resultex_"^"	;InAckUserDR
	i $p(result,"^",9)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",9))
	s $p(result,"^",10)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",10),"date") ;InAckDate
	s resultex=resultex_"^"	;ReciverDR
	i $p(result,"^",15)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",15))
	s resultex=resultex_"^"	;EquipTypeDR
	i $p(result,"^",16)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCEquipType",$p(result,"^",16))),"^",2)
	s resultex=resultex_"^"	;StatCatDR
	i $p(result,"^",17)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCStatCat",$p(result,"^",17))),"^",2)
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex_"^"_FromLocCode_"^"_ToLocCode_"^"_$CASE($p(result,"^",12),"0":"库房分配","1":"科室调配","2":"报废转废品库","3":"科室退货","4":"库房调配",:"没有定义") //2010-10-26 DJ
}

ClassMethod GetStatus(RowID)
{
	i RowID="" q ""
	q $P(^DHCEQStoreMove(RowID),"^",13)
}

ClassMethod StatusList(name, width, Type, Value As %Library.String = "", CancelOper As %Library.String = "") As %String
{
	;;下拉列表
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")
	s selectedone=$case(Value,0:"selected",:"")
	s selectedtwo=$case(Value,1:"selected",:"")
	s selectedthree=$case(Value,2:"selected",:"")
	s selectedfour=$case(Value,3:"selected",:"")		//modified by CZF0060 2020-02-20 begin
	
	w "<option value=></option>"
	i CancelOper="Y"
	{
		w "<option value=2 "_selectedthree_">审核</option>"
		w "<option value=3 "_selectedfour_">作废</option>"
	}
	else
	{
		i (Type="0")||(Type="") w "<option value=0 "_selectedone_">新增</option>"
		i Type'="2" w "<option value=1 "_selectedtwo_">提交</option>"
		w "<option value=2 "_selectedthree_">审核</option>"		//modified by CZF0060 2020-02-20 end
	}
	w "</select>",!
}

ClassMethod MoveTypeList(name, width, Type) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value=0>库房分配</option>"
	//w "<option value=1>科室调配</option>"
	//w "<option value=2>报废转废品库</option>"
	w "<option value=3>科室退库</option>"
	w "<option value=4>库房调配</option>" //2010-10-26 DJ
	w "</select>",!
}

Query GetStoreMove(QXType, Type, FromLocDR, ToLocDR, StartDate, EndDate, Status, MoveType) As %Query(ROWSPEC = "TRowID:%String,TStoreMoveNo:%String,TFromLocDR:%String,TToLocDR:%String,TMakerDR:%String,TMakeDate:%String,TAckUserDR:%String,TAckDate:%String,TAckTime:%String,TInAckUserDR:%String,TInAckDate:%String,TInAckTime:%String,TMoveType:%String,TStatus:%String,TRemark:%String,TFromLoc:%String,TToLoc:%String,TMaker:%String,TAckUser:%String,TInAckUser:%String,TReciver:%String,TEquipTypeDR:%String,TEquipType:%String,TStatCatDR:%String,TStatCat:%String")
{
}

ClassMethod GetStoreMoveExecute(ByRef qHandle As %Binary, QXType, Type, FromLocDR, ToLocDR, StartDate, EndDate, Status, MoveType) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetStoreMove
	Quit $$$OK
BuildDataGetStoreMove
	f  s rowid=$o(^DHCEQStoreMove(rowid))  quit:rowid=""  d
	.d ResetVariablesGetStoreMove
	.s TRowID = rowid
	.s TStoreMoveNo = $p($g(^DHCEQStoreMove(rowid)),"^",1)
	.s TFromLocDR = $p($g(^DHCEQStoreMove(rowid)),"^",2)
	.q:(FromLocDR'="")&&(FromLocDR'=TFromLocDR)
	.q:(1=(##Class(web.DHCEQCommon).LocIsInEQ(QXType,TFromLocDR)))
	.i TFromLocDR '=""  d
	..s TFromLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TFromLocDR)
	.s TToLocDR = $p($g(^DHCEQStoreMove(rowid)),"^",3)
	.q:(ToLocDR'="")&&(ToLocDR'=TToLocDR)
	.i TToLocDR '=""  d
	..s TToLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TToLocDR)
	.s TMakerDR = $p($g(^DHCEQStoreMove(rowid)),"^",4)
	.i TMakerDR '=""  d
	..s TMaker = ##class(web.DHCEQCommon).GetTrakNameByID("user",TMakerDR)
	.i StartDate="" s StartDate=0
	.i EndDate="" s EndDate=+$h
	.q:($p($g(^DHCEQStoreMove(rowid)),"^",5)>EndDate)||($p($g(^DHCEQStoreMove(rowid)),"^",5)<StartDate)
	.s TMakeDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQStoreMove(rowid)),"^",5),"date")
	.s TAckUserDR = $p($g(^DHCEQStoreMove(rowid)),"^",6)
	.i TAckUserDR '=""  d
	..s TAckUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAckUserDR)
	.s TAckDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQStoreMove(rowid)),"^",7),"date")
	.s TAckTime = $p($g(^DHCEQStoreMove(rowid)),"^",8)
	.s TInAckUserDR = $p($g(^DHCEQStoreMove(rowid)),"^",9)
	.i TInAckUserDR '=""  d
	..s TInAckUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TInAckUserDR)
	.s TInAckDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQStoreMove(rowid)),"^",10),"date")
	.s TInAckTime = $p($g(^DHCEQStoreMove(rowid)),"^",11)
	.s TMoveType = $p($g(^DHCEQStoreMove(rowid)),"^",12)
	.q:(MoveType'="")&&(MoveType'=TMoveType)
	.s TMoveType = $CASE(TMoveType,"0":"库房分配","1":"科室调配","2":"报废转废品库","3":"科室退货","4":"库房调配",:"没有定义") //2010-10-26 DJ
	.s TStatus = $p($g(^DHCEQStoreMove(rowid)),"^",13)
	.q:(Status'="")&&(TStatus'=Status)
	.q:(Type="1")&&(TStatus="0")
	.q:(Type="2")&&(TStatus="0")
	.q:(Type="2")&&(TStatus="1")
	.s TStatus = $CASE(TStatus,"0":"新增","1":"提交","2":"出库审核","3":"入库审核","9":"管理审核",:"没有定义")
	.s TRemark = $p($g(^DHCEQStoreMove(rowid)),"^",14)
	.s TReciverDR=$p($g(^DHCEQStoreMove(rowid)),"^",15)
	.i TReciverDR'="" s TReciver=##class(web.DHCEQCommon).GetTrakNameByID("user",TReciverDR)
	.s TEquipTypeDR=$p($g(^DHCEQStoreMove(rowid)),"^",16)
	.q:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	.i TEquipTypeDR '=""  d
	..s TEquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	.s TStatCatDR=$p($g(^DHCEQStoreMove(rowid)),"^",17)
	.i TStatCatDR '=""  d
	..s TStatCat = $p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
	.d OutputRowGetStoreMove
	quit
OutputRowGetStoreMove
	s Data=$lb(TRowID,TStoreMoveNo,TFromLocDR,TToLocDR,TMakerDR,TMakeDate,TAckUserDR,TAckDate,TAckTime,TInAckUserDR,TInAckDate,TInAckTime,TMoveType,TStatus,TRemark,TFromLoc,TToLoc,TMaker,TAckUser,TInAckUser,TReciver,TEquipTypeDR,TEquipType,TStatCatDR,TStatCat)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetStoreMove
	s (TRowID,TStoreMoveNo,TFromLocDR,TToLocDR,TMakerDR,TMakeDate,TAckUserDR,TAckDate,TAckTime,TInAckUserDR,TInAckDate,TInAckTime,TMoveType,TStatus,TRemark,TFromLoc,TToLoc,TMaker,TAckUser,TInAckUser,TReciver,TReciverDR,TEquipTypeDR,TEquipType,TStatCatDR,TStatCat)=""
	quit
}

ClassMethod GetStoreMoveFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStoreMoveExecute ]
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

ClassMethod GetStoreMoveClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStoreMoveExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Storage Default
{
<Data name="DHCEQStoreMoveDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQStoreMoveD</DataLocation>
<DefaultData>DHCEQStoreMoveDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCEQStoreMoveD</IdLocation>
<IndexLocation>^web.DHCEQStoreMoveI</IndexLocation>
<StreamLocation>^web.DHCEQStoreMoveS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
