Class web.DHCEQSwapListDetail Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 更新操作
ClassMethod SaveData(SwapDR, val)
{
	
 	new RowID
	i val="" q 0
	s Flag=0
	s Length=$l(val,"&")
	Set $ZT="ERRORSave"
	
	TSTART
	for i=1:1:Length
	{
		q:Flag'=0
		s SQLCODE=0
		s valList=	$p(val,"&",i)
		;TRow+"^"+TRowID+"^"+TSwapDR+"^"+TSwapListDR+"^"+TLocDR+"^"+TMasterItemDR+"^"+TModelDR+"^"+TQuantityNum+"^"+TSupplementNum+"^"+TDifference+"^"+TDamagedAllotQty+"^"+THold1+"^"+THold2+"^"+THold3+"^"+THold4+"^"+THold5;
		s index= $p(valList,"^",1)  		;index
		s RowID= $p(valList,"^",2)  		;SLDRowID
		;s PLISTMX(2)=$p(valList,"^",3)  	;TSwapDR
		;s PLISTMX(3)=$p(valList,"^",4)		;TSwapListDR
		s MasterItemDR=$p(valList,"^",6)  	;TMasterItemDR
		;s PLISTMX(5)=$p(valList,"^",7)  	;TModelDR
		s PLISTMX(6)=$p(valList,"^",8)  	;TQuantityNum
		s PLISTMX(7)=$p(valList,"^",9)  	;TSupplementNum
		s LocDR=$p(valList,"^",5)  	;TLocDR
		s Difference=$p(valList,"^",10)  	;TDifference
		s DamagedAllotQty=$p(valList,"^",10)  	;TDamagedAllotQty
		s PLISTMX(9)=$p(valList,"^",12)  	;THold1
		s PLISTMX(10)=$p(valList,"^",13)  	;THold2
		s PLISTMX(11)=$p(valList,"^",14)  	;THold3
		s PLISTMX(12)=$p(valList,"^",15)  	;THold4
		s PLISTMX(13)=$p(valList,"^",16)  	;THold5
	
		;s QuantityNum=PLISTMX(5)
		if (RowID="")
		{
			;&SQL(Insert Into SQLUSER.DHC_EQSwapListDetail Values :PLISTMX())
			;s RowID=$G(%ROWID)
			;s ^DHCEQSwapListDetail(RowID,"AutoCostAllot")=DamagedAllotQty_"^"_Difference	
		}
		else
		{
			&SQL(update sqluser.DHC_EQSwapListDetail values :PLISTMX() where SLD_RowID=:RowID)
			s ^DHCEQSwapListDetail(0,"AutoCostAllot",LocDR,MasterItemDR)=DamagedAllotQty_"^"_Difference
		}
		
		i SQLCODE s Flag=index_"^更新明细记录失败!"
	}
	i Flag
	{
		TROLLBACK
		q Flag
	}	
 	
 	TCOMMIT
 	q SwapDR
	
ERRORSave 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORSave"_ErrorMsg     //返回错误消息 ;
}

/// 描述:提交
/// w ##Class(web.DHCEQSwapListDetail).SubmitData("174^^1^^9^2","")
ClassMethod SubmitData(val, valList)
{
	new (val)
	s RowID=$P(val,"^",1)
	i RowID="" q ""
	
	s InvalidFlag=$p($g(^DHCEQSwap(RowID)),"^",25)
	i InvalidFlag="Y" q -1015
	
	Set $ZT="ERRORSubmit"
	;s User=$P(val,"^",7)
	
	;s Date=+$H
	;s Time=$P($H,",",2)
  	
  	s PLIST(9)="Y"		;Hold1 审核标记
		
	TSTART
	
	&SQL(update sqluser.DHC_EQSwapListDetail values :PLIST() where SLD_RowID=:RowID)
	
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	
	TCOMMIT
 	q RowID
ERRORSubmit 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORSubmit"_ErrorMsg     //返回错误消息 ;
}

/// 验证销毁或补给数量是否一致
/// w ##Class(web.DHCEQSwapListDetail).CheckData(1,20,20)
ClassMethod CheckData(SwapDR, vQuantityNum, vSupplementNum)
{
	i SwapDR="" q "Error"
	n (SwapDR, vQuantityNum, vSupplementNum)
	s (TotalQuantityNum,TotalSupplementNum)=0
	s rowid=0
	f  s rowid=$O(^DHCEQSwapList(0,"Swap",SwapDR,rowid)) quit:rowid=""  d
	.s QuantityNum=$P($G(^DHCEQSwapList(rowid)),"^",4)
	.s SupplementNum=$P($G(^DHCEQSwapList(rowid)),"^",5)
	.s TotalQuantityNum=TotalQuantityNum+QuantityNum
	.s TotalSupplementNum=TotalSupplementNum+SupplementNum
	
	i ((vQuantityNum'=TotalQuantityNum)||(vSupplementNum'=TotalSupplementNum)) q "实际总销毁或补充数量和分摊总数量不符"
	q ""
}

/*
/// w ##Class(web.DHCEQSwapNew).SaveSwapList("241","3812","1^365^^361^担架车^2^30^2^922^1601")
/// ----------------------------------
ClassMethod UpdateSwapListDetail(val)
{
	new RowID
	i val="" q 0
	s Flag=0
	s Length=$l(val,"&")
	for i=1:1:Length
	{
		q:Flag'=0
		s SQLCODE=0
		s valList=	$p(val,"&",i)
		;TRow+"^"+TRowID+"^"+TSwapDR+"^"+TSwapListDR+"^"+TLocDR+"^"+TMasterItemDR+"^"+TModelDR+"^"+TQuantityNum+"^"+TSupplementNum+"^"+TDifference+"^"+TDamagedAllotQty+"^"+THold1+"^"+THold2+"^"+THold3+"^"+THold4+"^"+THold5;
		s index= $p(valList,"^",1)  		;index
		s RowID= $p(valList,"^",2)  		;SLDRowID
		;s PLISTMX(2)=$p(valList,"^",3)  	;TSwapDR
		;s PLISTMX(3)=$p(valList,"^",4)		;TSwapListDR
		s MasterItemDR=$p(valList,"^",6)  	;TMasterItemDR
		;s PLISTMX(5)=$p(valList,"^",7)  	;TModelDR
		s PLISTMX(6)=$p(valList,"^",8)  	;TQuantityNum
		s PLISTMX(7)=$p(valList,"^",9)  	;TSupplementNum
		s LocDR=$p(valList,"^",5)  	;TLocDR
		s Difference=$p(valList,"^",10)  	;TDifference
		s DamagedAllotQty=$p(valList,"^",10)  	;TDamagedAllotQty
		s PLISTMX(9)=$p(valList,"^",12)  	;THold1
		s PLISTMX(10)=$p(valList,"^",13)  	;THold2
		s PLISTMX(11)=$p(valList,"^",14)  	;THold3
		s PLISTMX(12)=$p(valList,"^",15)  	;THold4
		s PLISTMX(13)=$p(valList,"^",16)  	;THold5
	
		;s QuantityNum=PLISTMX(5)
		if (RowID="")
		{
			;&SQL(Insert Into SQLUSER.DHC_EQSwapListDetail Values :PLISTMX())
			;s RowID=$G(%ROWID)
			;s ^DHCEQSwapListDetail(RowID,"AutoCostAllot")=DamagedAllotQty_"^"_Difference	
		}
		else
		{
			&SQL(update sqluser.DHC_EQSwapListDetail values :PLISTMX() where SLD_RowID=:RowID)
			s ^DHCEQSwapListDetail(LocDR,MasterItemDR,"AutoCostAllot")=DamagedAllotQty_"^"_Difference
		}
		
		i SQLCODE s Flag=index_"^更新明细记录失败!"
	}
	q Flag
}
*/
}
