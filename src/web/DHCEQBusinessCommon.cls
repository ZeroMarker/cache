Class web.DHCEQBusinessCommon Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 2012-09-14 DJ
/// 记录业务单据明细记录对应的类组,类型,来源,科室等信息
/// vData格式:SourceType^SourceID^EquipTypeDR^StatCatDR^OriginDR^LocDR^Hold1^Hold2^Hold3^Hold4^Hold5
/// 说明:单据审核前后信息不一致时不记录该项信息
ClassMethod InsertBillInfo(vData As %String = "")
{
	K BIPLIST
	s SQLCODE=0
	i vData="" q SQLCODE
	s BIPLIST(2)=$p(vData,"^",1)	//SourceType
	s BIPLIST(3)=$p(vData,"^",2)	//SourceID
	s BIPLIST(4)=$p(vData,"^",3)	//EquipTypeDR
	s BIPLIST(5)=$p(vData,"^",4)	//StatCatDR
	s BIPLIST(6)=$p(vData,"^",5)	//OriginDR
	s BIPLIST(7)=$p(vData,"^",6)	//LocDR
	s BIPLIST(8)=$p(vData,"^",7)	//Hold1
	s BIPLIST(9)=$p(vData,"^",8)	//Hold2
	s BIPLIST(10)=$p(vData,"^",9)	//Hold3
	s BIPLIST(11)=$p(vData,"^",10)	//Hold4
	s BIPLIST(12)=$p(vData,"^",11)	//Hold5
	&SQL(Insert Into SQLUSER.DHC_EQBillInfo Values :BIPLIST())
	q SQLCODE
}

/// 2012-09-14 DJ
/// 根据业务单获取执行InsertBillInfo所需要的vData信息串
/// SourceType	0:验收明细 1:设备 2:附件 3:入库明细 4:转移明细 5:退货明细 6:报废明细 7:调账明细 9:调整数据 10:折旧
/// w ##Class(web.DHCEQBusinessCommon).GetBillInfoStr(4, 12030)
ClassMethod GetBillInfoStr(SourceType As %String = "", SourceID As %String = "")
{
	s SQLCODE=0
	i (SourceType="")||(SourceID="") q SQLCODE
	s (BIEquipType,BIStatCat,BIOrigin,BILoc,BIHold1,BIHold2,BIHold3,BIHold4,BIHold5)=""
	i SourceType=4 //转移
	{
		s SMRowID=$p($g(^DHCEQStoreMoveList(SourceID)),"^",1)
		s BIEquipType=$p($g(^DHCEQStoreMove(SMRowID)),"^",16)
		s BIEquipDR=$p($g(^DHCEQStoreMoveList(SourceID)),"^",2)
		Set BILoc=$Piece($Get(^DHCEQStoreMove(SMRowID)),"^",3)		;SM_ToLocDR
		If BIEquipDR=""
		{
			;当有设备的类组类型进行调整后,不能从其入库单获取类组类型值
			Set BIEquipDR=+$Get(^DHCEQStoreMoveList(SourceID,"EX","RowIDs"))
		}
		s BIStatCat=$p($g(^DHCEQEquip(BIEquipDR)),"^",75)
		s BIOrigin=$p($g(^DHCEQEquip(BIEquipDR)),"^",20)
	}
	i SourceType=5 //退货
	{
		s RRowID=$p($g(^DHCEQReturnList(SourceID)),"^",1)
		s BIEquipType=$p($g(^DHCEQReturn(RRowID)),"^",15)
		s BIEquipDR=$p($g(^DHCEQReturnList(SourceID)),"^",4)
		Set BILoc=$Piece($Get(^DHCEQReturn(RRowID)),"^",2)
		If BIEquipDR=""
		{
			Set BIEquipDR=+$Get(^DHCEQReturnList(SourceID,"EX","RowIDs"))
		}
		s BIStatCat=$p($g(^DHCEQEquip(BIEquipDR)),"^",75)
		s BIOrigin=$p($g(^DHCEQEquip(BIEquipDR)),"^",20)
	}
	i SourceType=6 //报废
	{
		s DRLEquipDR=$p($g(^DHCEQDisuseRequestList(SourceID)),"^",2)
		s BIEquipType=$p($g(^DHCEQEquip(DRLEquipDR)),"^",63)
		s BIStatCat=$p($g(^DHCEQEquip(DRLEquipDR)),"^",75)
		s BIOrigin=$p($g(^DHCEQEquip(DRLEquipDR)),"^",20)
		s BILoc=$p($g(^DHCEQEquip(DRLEquipDR)),"^",67)
	}
	i SourceType=7 //调账
	{
		s CAEquipDR=$p($g(^DHCEQChangeAccount(SourceID)),"^",1)
		s BIEquipType=$p($g(^DHCEQChangeAccount(SourceID)),"^",30)
		s BIStatCat=$p($g(^DHCEQChangeAccount(SourceID)),"^",31)
		s BIOrigin=$p($g(^DHCEQEquip(CAEquipDR)),"^",20)
		s BILoc=$p($g(^DHCEQChangeAccount(SourceID)),"^",28)
	}
	i SourceType=10 //折旧
	{
		s MDEquipDR=$p($g(^DHCEQMonthDepre(SourceID)),"^",1)
		s BIEquipType=$p($g(^DHCEQEquip(MDEquipDR)),"^",63)
		s BIStatCat=$p($g(^DHCEQEquip(MDEquipDR)),"^",75)
		s BIOrigin=$p($g(^DHCEQEquip(MDEquipDR)),"^",20)
		Set BILoc=$Piece($Get(^DHCEQEquip(MDEquipDR)),"^",67)
	}
	
	s BIStr=SourceType_"^"_SourceID_"^"_BIEquipType_"^"_BIStatCat_"^"_BIOrigin_"^"_BILoc_"^"_BIHold1_"^"_BIHold2_"^"_BIHold3_"^"_BIHold4_"^"_BIHold5
	s SQLCODE=..InsertBillInfo(BIStr)
	q SQLCODE
}

}
