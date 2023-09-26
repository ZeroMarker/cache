Class web.DHCEQDJNew Extends %RegisteredObject
{

/// 宁波慈林医院折旧处理
/// Add By DJ 2014-12-16
/// w ##Class(web.DHCEQDJNew).ResetDepre()
ClassMethod ResetDepre()
{
	K ^DHCEQCostAllotDetail
	K ^DHCEQDJNew
	K ^DHCEQMonthDepre
	K ^DHCEQMonthReportList
	w "(1)global成功清除!",!
	/**************************************************************************/
	i '$D(^DHCEQCCode("DHCEQCSysSet",0,"Code","990029"))
	{
		&SQL(Insert Into SQLUSER.DHC_EQCSysset(ss_code,ss_value,ss_desc,ss_remark,ss_hidden) values('990029','10','残值率','百分比','N'))
		i SQLCODE
		{
			q "增加系统参数失败!"
		}
		w "(2)增加系统参数成功!",!
	}
	/**************************************************************************/
	s SQLCODE=..BackSnapShot()
	i SQLCODE q "恢复快照失败!"
	w "(3)快照恢复成功!",!
	
	q "执行成功!"
}

/// w ##Class(web.DHCEQDJNew).UpdateOther(1,2000)
ClassMethod UpdateOther(SRowID, ERowID)
{
	s SQLCODE=..UpdateDepreSet(SRowID,ERowID)
	i SQLCODE'=0 q SQLCODE
	w "DHCEQDepreSet成功["_SRowID_"|"_ERowID_"]",!
	
	s SQLCODE=..UpdateEquip(SRowID,ERowID)
	i SQLCODE'=0 q SQLCODE
	w "DHCEQEquip成功["_SRowID_"|"_ERowID_"]",!
	
	s SQLCODE=..UpdateFunds(SRowID,ERowID)
	i SQLCODE'=0 q SQLCODE
	w "DHCEQFunds成功["_SRowID_"|"_ERowID_"]",!
	
	s SQLCODE=..UpdateLifeInfo(SRowID,ERowID)
	i SQLCODE'=0 q SQLCODE
	w "DHCEQLifeInfo成功["_SRowID_"|"_ERowID_"]",!
	
	q "执行成功!["_SRowID_"|"_ERowID_"]"
}

/// 恢复快照累计折旧,净值,净残值
ClassMethod BackSnapShot()
{
	s node="Equip"
	s SnapID=0
	f  s SnapID=$o(^DHCEQSnapShot(SnapID))  q:SnapID=""  d
	.;台账
	.s EQRowID=0
	.f  s EQRowID=$o(^DHCEQSnapShot(SnapID,node,EQRowID))  q:EQRowID=""  d
	..s ReturnInfo=$g(^DHCEQSnapShot(SnapID,node,EQRowID))
	..s OriginalFee=$p(ReturnInfo,"^",27)
	..s $p(ReturnInfo,"^",28)=OriginalFee		//NetFee
	..s $p(ReturnInfo,"^",29)=##Class(web.DHCEQCommon).FormatNumber(OriginalFee*0.1,"",2)		//NetRemainFee
	..s $p(ReturnInfo,"^",35)=0		//DepreTotalFee
	.;资金来源
	.s Fundsnode="Funds"
	.s EQRowID=0
	.f  s EQRowID=$o(^DHCEQSnapShot(SnapID,Fundsnode,EQRowID))  q:EQRowID=""  d
	..s FRowID=0
	..f  s FRowID=$o(^DHCEQSnapShot(SnapID,Fundsnode,EQRowID,FRowID))  q:FRowID=""  d
	...s FundsInfo=$g(^DHCEQSnapShot(SnapID,Fundsnode,EQRowID,FRowID))
	...s $p(FundsInfo,"^",13)=0
	
	q 0
}

ClassMethod UpdateEquip(SRowID, ERowID)
{
	TSTART
	s SQLCODE=0
	s EQRowID=0
	f  s EQRowID=$o(^DHCEQEquip(EQRowID))  q:(EQRowID="")||(SQLCODE'=0)  d
	.q:((EQRowID<SRowID)||(EQRowID>ERowID))
	.&SQL(Update SQLUSER.DHC_EQEquip Set EQ_NetFee=EQ_OriginalFee,EQ_DepretotalFee=0,EQ_NetRemainFee=round(EQ_OriginalFee*0.1,2) where EQ_RowID=:EQRowID)
	
	i SQLCODE'=0
	{
		TROLLBACK
		q SQLCODE_"|"_EQRowID
	}
	TCOMMIT
	q SQLCODE
}

ClassMethod UpdateFunds(SRowID, ERowID)
{
	TSTART
	s SQLCODE=0
	s FRowID=0
	f  s FRowID=$o(^DHCEQFunds(FRowID))  q:(FRowID="")||(SQLCODE'=0)  d
	.q:((FRowID<SRowID)||(FRowID>ERowID))
	.&SQL(Update SQLUSER.DHC_EQFunds Set F_DepreTotal=0 where F_RowID=:FRowID)
	
	i SQLCODE'=0
	{
		TROLLBACK
		q SQLCODE_"|"_FRowID
	}
	TCOMMIT
	q SQLCODE
}

ClassMethod UpdateDepreSet(SRowID, ERowID)
{
	TSTART
	s SQLCODE=0
	s DSRowID=0
	f  s DSRowID=$o(^DHCEQDepreSet(DSRowID))  q:(DSRowID="")||(SQLCODE'=0)  d
	.q:((DSRowID<SRowID)||(DSRowID>ERowID))
	.&SQL(Update SQLUSER.DHC_EQDepreSet Set DS_DepreTotal=0,DS_DepreTotalFee=0 where DS_RowID=:DSRowID)
	
	i SQLCODE'=0
	{
		TROLLBACK
		q SQLCODE_"|"_DSRowID
	}
	TCOMMIT
	q SQLCODE
}

ClassMethod UpdateLifeInfo(SRowID, ERowID)
{
	TSTART
	s SQLCODE=0
	s LIChangeDate=0
	f  s LIChangeDate=$o(^DHCEQLifeInfo(0,"LifeType","P",LIChangeDate))  q:(LIChangeDate="")||(SQLCODE'=0)  d
	.s LIRowID=0
	.f  s LIRowID=$o(^DHCEQLifeInfo(0,"LifeType","P",LIChangeDate,LIRowID))  q:(LIRowID="")||(SQLCODE'=0)  d
	..q:((LIRowID<SRowID)||(LIRowID>ERowID))
	..s LISourceType=$p($g(^DHCEQLifeInfo(LIRowID)),"^",19)
	..q:LISourceType'="35"
	..&SQL(Delete From SQLUSER.DHC_EQLifeInfo where LI_RowID=:LIRowID)
	
	i SQLCODE'=0
	{
		TROLLBACK
		q SQLCODE_"|"_LIRowID
	}
	TCOMMIT
	q SQLCODE
}

}
