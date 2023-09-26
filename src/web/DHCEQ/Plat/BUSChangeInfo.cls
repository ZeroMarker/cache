Class web.DHCEQ.Plat.BUSChangeInfo Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 修改设备状态为0:在库|1:启用|2:停用|3:报废|4:其他,根据设备的状态来判断记录在库或在用
/// w ##Class(web.DHCEQ.Plat.BUSChangeInfo).StopEquipBySource(31,11)
ClassMethod StopEquipBySource(SourceType, SourceID, StopFalg)
{
	new ExObjDR,ObjSourceTypeDR,EquipIDs,KindFlag,ListID,Len,SQLCODE,Reason,i
	new ChangeTypeDR,ChangeDate,FromOther,ToOther,ApproveListDR
	s (ExObjDR,ObjSourceTypeDR,EquipIDs,KindFlag,Reason,ChangeDate,FromOther,ToOther,ApproveListDR)=""
	s (Len,SQLCODE)=0
	s ChangeTypeDR=1	//1,设备状态变动；9;其他变动   
	i StopFalg=1  d
	.s ToStatus=2
	.s ChangeTypeDR=2  ;modify by lmm 2018-12-11 771471
	e  d
	.s ToStatus=1
	If SourceType=31
	{
		s ExObjDR = $Piece($Get(^DHCEQMMaintRequest(SourceID)),"^",5)
		quit:ExObjDR=""
		s ObjSourceTypeDR=$Piece($Get(^DHCEQMMaintRequest(SourceID)),"^",63)	//Add By DJ 2014-09-21
		//Mozy	900363	2019-5-24	简易台账设备
		i (ObjSourceTypeDR=1)||(ObjSourceTypeDR=2)  d
		.s EquipIDs = $p($g(^DHCEQMExObj(ExObjDR)),"^",5)
		s Reason="报    修"
		d StopEquipList
	}
	elseif SourceType=34
	{
		s KindFlag = $p($g(^DHCEQDisuseRequest(SourceID)),"^",44)
		s Reason="报废提交"
		s EquipIDs=##Class(web.DHCEQBatchDisuseRequest).GetDisuseEquipIDs(SourceID)
		d StopEquipList
	}
	quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
StopEquipList
	s Len=$l(EquipIDs,",")
	s i=1
	for i=i:1:Len q:(SQLCODE'=0)  d
	.s EquipID=$p(EquipIDs,",",i)
	.s FromStatus=$P($g(^DHCEQEquip(EquipID)),"^",38)
	.s val="^"_EquipID_"^^"_ChangeTypeDR_"^"_ChangeDate_"^"_SourceType_"^"_SourceID_"^2^"_FromStatus_"^"_ToStatus_"^"_FromOther_"^"_ToOther_"^"_ApproveListDR_"^"_Reason_"^"
	.s ReturnInfo=##Class(web.DHCEQ.Plat.BUSChangeInfo).SaveData(val,"2")
	.s ReturnObj=##class(web.DHCEQ.Plat.JsonObject).FromJSON(ReturnInfo)		//CZF0131 2021-01-20
	.s SQLCODE=ReturnObj.SQLCODE
	q SQLCODE
}

/// w ##Class(web.DHCEQChangeInfo).SaveData(31,11)
ClassMethod SaveData(val As %Library.String = "", isDel As %Library.String = "")
{
	new User,Date,Time,SQLCODE,ESRowID,EquipID,ToStatus
	s SQLCODE=0
	s ESRowID=$p(val,"^",1)
	s User=$p(val,"^",16) 
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	k PL
	s Date=+$H
	s Time=$p($H,",",2)
	s PL(2)=$p(val,"^",2)
	s EquipID=$p(val,"^",2)
	s PL(3)=$p(val,"^",3)
	s PL(4)=$p(val,"^",4)
	s PL(5)=$p(val,"^",5)
	i PL(5)="" s PL(5)=Date
	s PL(6)=$p(val,"^",6)
	s PL(7)=$p(val,"^",7)
	s PL(8)=$p(val,"^",8) 	//Status
	s PL(9)=$p(val,"^",9)
	s PL(10)=$p(val,"^",10)
	s ToStatus=$p(val,"^",10)
	s PL(11)=$p(val,"^",11)
	s PL(12)=$p(val,"^",12)
	s PL(13)=$p(val,"^",13)
	s PL(14)=$p(val,"^",14)
	s PL(15)=$p(val,"^",15)
	s PL(16)="N"
	s PL(17)=User
	s PL(18)=Date
	s PL(19)=Time
	//s PL(20)=User
	//s PL(21)=Date
	//s PL(22)=Time
	TSTART
	i (+isDel=1)
	{
		k PL
		s PL(16)="N"
		s PL(17)=User
		s PL(18)=Date
		s PL(19)=Time
		&SQL(Update SQLUSER.DHC_EQChangeInfo Values :PL() where CI_RowID = :ESRowID)
		i SQLCODE
		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	else
	{
		if (+isDel=2)
		{
			s PL(8)="2"
			s PL(23)=User
			s PL(24)=Date
			s PL(25)=Time
		}
		if (ESRowID'="") 
		{
			&SQL(Update SQLUSER.DHC_EQChangeInfo Values :PL() where CI_RowID = :ESRowID)
			i SQLCODE
			{
				TROLLBACK
				q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
			}
		}
		else
		{
			&SQL(Insert Into SQLUSER.DHC_EQChangeInfo Values :PL())
		}
		i SQLCODE
		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		s ChangeInfoDR=$G(%ROWID)
		k LI
		s LI(2)=EquipID  //设备
		s LI(4)=$p($g(^DHCEQEquip(EquipID)),"^",19)   	//原使用科室
		s LI(5)=$p($g(^DHCEQEquip(EquipID)),"^",17) 	//原管理科室
		s LI(6)=$p($g(^DHCEQEquip(EquipID)),"^",67)  	//原库房
		s LI(7)=$p($g(^DHCEQEquip(EquipID)),"^",27)  	//原值
		s LI(8)=$p($g(^DHCEQEquip(EquipID)),"^",28)  	//原净值
		s LI(9)=$p($g(^DHCEQEquip(EquipID)),"^",19)  	//变动后使用科室
 		s LI(10)=$p($g(^DHCEQEquip(EquipID)),"^",17) 	//变动后管理科室
 		s LI(11)=$p($g(^DHCEQEquip(EquipID)),"^",67)  	//变动后库房
 		s LI(12)=$p($g(^DHCEQEquip(EquipID)),"^",27)  	//变动后原值
 		s LI(13)=$p($g(^DHCEQEquip(EquipID)),"^",28)  	//变动后净值
 		if ToStatus=1 d
		.s LI(14)="启用" //原因
		else  d
		.s LI(14)="停用"
		s LI(16)=Date	//变动日期
		s LI(17)=Time	//变动时间
		;s LI(18)=depreFee //折旧费用
		s LI(19)="C"	//生命周期类型
		s LI(20)=41		//来源类型
		s LI(21)=ChangeInfoDR	//来源ID
		s LI(27)=User	//更新人
		s LI(28)=Date	//更新日期
		s LI(29)=Time	//更新时间
		&sql(Insert Into SQLUSER.DHC_EQLifeInfo Values :LI())
		i SQLCODE
		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	//EQ_Status	设备状态是否需要停用
	if (+isDel=2)
	{
		&SQL(Update SQLUser.DHC_EQEquip set EQ_Status=:ToStatus where EQ_RowID=:EquipID)
		i SQLCODE
		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
}

/// 31:维修、32保养、33检查、34报废
/// w ##Class(web.DHCEQ.Plat.BUSChangeInfo).UpdateEquipUnusualStatus(34,4,5,18) 
ClassMethod UpdateEquipUnusualStatus(EquipIDs, UnusualStatus, Remark)
{
	new Len,i,EquipID,SQLCODE
	s SQLCODE=0
	k EQ
	s Len=$l(EquipIDs,",")
	for i=1:1:Len q:(SQLCODE'=0)  d
	.s EquipID=$p(EquipIDs,",",i)
	.q:SQLCODE'=0
	.s EQ(94)=UnusualStatus			//EQ_AdvanceDisFlag（EQ_Hold8） 原来的预报废标志
	.s EQ(105)=Remark				//EQ_Hold1	异常状态备注信息
	.&SQL(Update SQLUser.DHC_EQEquip  values:EQ() where EQ_RowID=:EquipID)
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
}

}
