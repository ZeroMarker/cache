/// modified by ZY0247 2020-12-22
/// Add By DJ 2010-12-20 DJ0077
/// 描述:(1)EquipResourceFee增加资源类型ResourceType参数传递
/// 	 (2)增加GetGuaranteeFee获取保修合同费用方法
/// 	 (3)增加GetMonthNum函数获取两个日期之间总月份
Class web.DHCEQBenefitAnalyReport Extends (%Library.RegisteredObject, websys.Abstract, web.DHCEQCommon) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 设备效益分析报表
ClassMethod GetMonthBenfitAnalyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMonthBenfitAnalyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetMonthBenfitAnalyExecute(ByRef qHandle As %Binary, vData As %String = "", QXType As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=2
	s rowid=0
	s (SumOriginalFee,SumInCome,SumOutCome,SumDepre,SumMaint,SumConsumable,SumResource,SumPayOff)=0
	d BuildDataGetMonthBenfitAnaly
	Quit $$$OK
BuildDataGetMonthBenfitAnaly
	Set vData=..UnEscape(vData)
	Set Equip=..GetDataByName(vData,"Equip")
	Set EquipNo=..GetDataByName(vData,"EquipNo")
	Set EquipCode=..GetDataByName(vData,"EquipCode")
	Set EquipTypeDR=..GetDataByName(vData,"EquipTypeDR")
	Set StatCatDR=..GetDataByName(vData,"StatCatDR")
	Set EquipCatDR=..GetDataByName(vData,"EquipCatDR")
	Set ContactSub=..GetDataByName(vData,"ContactSub")
	Set UseLocDR=..GetDataByName(vData,"UseLocDR")
	Set StartOriginalFee=..GetDataByName(vData,"StartOriginalFee")
	Set EndOriginalFee=..GetDataByName(vData,"EndOriginalFee")
	Set StartDate=..GetDataByName(vData,"StartDate")
	Set EndDate=..GetDataByName(vData,"EndDate")
	i (StartDate'="")&&(EndDate'="")&&($ZDH(StartDate_"-01",3)>$ZD(EndDate_"-01",3)) q
	Set InStockStartDate=..GetDataByName(vData,"InStockStartDate")
	;i InStockStartDate'="" s InStockStartDate=$zdh(InStockStartDate,4)
	;日期格式统一调整
	s InStockStartDate=##Class(web.DHCEQCommon).TransValueFromPage(InStockStartDate,"date")
	Set InStockEndDate=..GetDataByName(vData,"InStockEndDate")
	;i InStockEndDate'="" s InStockEndDate=$zdh(InStockEndDate,4)
	;日期格式统一调整
	s InStockEndDate=##Class(web.DHCEQCommon).TransValueFromPage(InStockEndDate,"date")
	Set IsDisUseDR=..GetDataByName(vData,"IsDisUseDR")
	Set ItemDR=..GetDataByName(vData,"ItemDR")
	s EquipNo=$ZCONVERT(EquipNo,"U")
	s EquipCode=$ZCONVERT(EquipCode,"U")
	if UseLocDR'=""
	{
		f  s rowid=$o(^DHCEQEquip(0,"UseLoc",UseLocDR,rowid))  q:rowid=""  d
		.d CheckEquip
		.q:passed=0
		.d OutputRowGetMonthBenfitAnaly
	}
	else
	{
		f  s rowid=$o(^DHCEQEquip(rowid))  q:rowid=""  d
		.d CheckEquip
		.q:passed=0
		.d OutputRowGetMonthBenfitAnaly
	}
	d ResetVariablesGetMonthBenfitAnaly
	s index=1
	s TEquipName="合计:"
	s TOriginalFee=SumOriginalFee
	s TInCome=SumInCome
	s TOutCome=SumOutCome
	s TDepreFee=SumDepre
	s TMaintFee=SumMaint
	s TConsumableFee=SumConsumable
	s TResourceFee=SumResource
	s TPayOff=SumPayOff
	d OutputRowGetMonthBenfitAnaly
	quit
CheckEquip
	d ResetVariablesGetMonthBenfitAnaly
	s passed=1
	s passed=..CheckEquipID(rowid)
	i passed=0 q
	s TRowID=rowid
	s Name=$p($g(^DHCEQEquip(rowid)),"^",1)
	i (Equip'="")&&(Name'[Equip)
	{
		s passed=0
		q
	}
	s Item=$p($g(^DHCEQEquip(rowid)),"^",7)
	i (ItemDR'="")&&(Item'=ItemDR)
	{
		s passed=0
		q
	}
	s Code=$ZCONVERT($p($g(^DHCEQEquip(rowid)),"^",6),"U")
	i (EquipCode'="")&&($E(Code,1,$L(EquipCode))'=EquipCode)
	{
		s passed=0
		q
	}
	s No=$ZCONVERT($p($g(^DHCEQEquip(rowid)),"^",71),"U")
	i (EquipNo'="")&&($E(No,1,$L(EquipNo))'=EquipNo)
	{
		s passed=0
		q
	}
	s ETDR=$p($g(^DHCEQEquip(rowid)),"^",63)
	i (EquipTypeDR'="")&&(ETDR'=EquipTypeDR)
	{
		s passed=0
		q
	}
	s SCDR=$p($g(^DHCEQEquip(rowid)),"^",75)
	i (StatCatDR'="")&&(SCDR'=StatCatDR)
	{
		s passed=0
		q
	}
	s UseLoc=$p($g(^DHCEQEquip(rowid)),"^",19)
	i (UseLocDR'="")&&(UseLoc'=UseLocDR)
	{
		s passed=0
		q
	}
	s InvalidFlag=$p($g(^DHCEQEquip(rowid)),"^",59)
	i InvalidFlag="Y"
	{
		s passed=0
		q
	}		
	s ECDR=$p($g(^DHCEQEquip(rowid)),"^",4)
	i (EquipCatDR'="")&&(ECDR'=EquipCatDR)
	{
		i (ContactSub'="1")
		{
			s passed=0
		}
		else
		{
			s passed=##class(web.DHCEQCEquipeCat).IsChildPar(EquipCatDR,ECDR)
		}
		i passed=0 q
	}
	s EQFee=$p($g(^DHCEQEquip(rowid)),"^",27)
	i (StartOriginalFee'="")&&(EQFee<StartOriginalFee)
	{
		s passed=0
		q
	}
	i (EndOriginalFee'="")&&(EQFee>EndOriginalFee)
	{
		s passed=0
		q
	}
	s InStockListDR=$p($g(^DHCEQEquip(rowid)),"^",70)
	if ((InStockStartDate'="")||(InStockEndDate'=""))	
	{
		i (InStockListDR="")
		{	s InStockDate=$p($g(^DHCEQEquip(rowid)),"^",45)}
		else
		{
			s InStockDate=$p($g(^DHCEQInStockList(InStockListDR)),"^",1)
			s InStockDate=$p($g(^DHCEQInStock(InStockDate)),"^",13)
		}
		i ((InStockStartDate'="")&(InStockDate<InStockStartDate))
		{s passed=0
		q}
		
		i ((InStockEndDate'="")&(InStockDate>InStockEndDate))
		{s passed=0
		q}
	}
	s Status=$p($g(^DHCEQEquip(rowid)),"^",38)
	i (IsDisUseDR="Y")&(Status'=3)
	{
		s passed=0
		q
	}
	i (IsDisUseDR="N")&(Status=3)
	{
		s passed=0
		q
	}
	s StockStatus=$p($g(^DHCEQEquip(rowid)),"^",60)
	i (StockStatus=0)||(StockStatus=3)
	{
		s passed=0
		q
	}
	s StoreLoc=$p($g(^DHCEQEquip(rowid)),"^",67) //2010-10-29 DJ begin
	i StoreLoc'=""
	{
		s Find=##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLoc)
		i Find'=0
		{
			s passed=0
			q
		}
	} //2010-10-29 DJ end
	s TRowID=rowid
	s TEquipName=Name
	s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(EQFee,"",2)
	s TEquipNo=No
	s InCome=..AllInCome(rowid,StartDate,EndDate,QXType)
	s TInCome=##Class(web.DHCEQCommon).FormatNumber($p(InCome,"^",1)+$p(InCome,"^",4),"",2)
	s TConsumableFee=##Class(web.DHCEQCommon).FormatNumber($p(InCome,"^",2),"",2)
	k ^TempDHCEQ("EquipOutDetailFee",$J)
	
	;Modified by JDL JDL0079 优化效率 2011-04-19
	s TMaintFee=..GetOutFeeByLifeInfo(rowid,StartDate,EndDate,"31",QXType)
	s TMaintFee=TMaintFee+..GetOutFeeByLifeInfo(rowid,StartDate,EndDate,"32",QXType)
	s TMaintFee=TMaintFee+..GetOutFeeByLifeInfo(rowid,StartDate,EndDate,"33",QXType)
	s TMaintFee=TMaintFee+..GetGuaranteeFee(rowid,StartDate,EndDate)
	s TMaintFee=##Class(web.DHCEQCommon).FormatNumber(TMaintFee,"",2)
	s TDepreFee=..GetOutFeeByLifeInfo(rowid,StartDate,EndDate,"35",QXType)
	s TDepreFee=##Class(web.DHCEQCommon).FormatNumber(TDepreFee,"",2)
	
	s TResourceFee=##Class(web.DHCEQCommon).FormatNumber(..EquipResourceFee(rowid,StartDate,EndDate,QXType),"",2)
	s TOutCome=##Class(web.DHCEQCommon).FormatNumber(TDepreFee+TMaintFee+TConsumableFee+TResourceFee,"",2)
	s TPayOff=##Class(web.DHCEQCommon).FormatNumber(TInCome-TOutCome,"",2)
	s AnalyMonth=..GetAnalyMonth(rowid,StartDate,EndDate)
	i TDepreFee+TPayOff>0 s TCallBackTime=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee/(((TDepreFee+TPayOff)/AnalyMonth)*12),"",2)
	s SumOriginalFee=SumOriginalFee+TOriginalFee
	s SumInCome=SumInCome+TInCome
	s SumOutCome=SumOutCome+TOutCome
	s SumDepre=SumDepre+TDepreFee
	s SumMaint=SumMaint+TMaintFee
	s SumConsumable=SumConsumable+TConsumableFee
	s SumResource=SumResource+TResourceFee
	s SumPayOff=SumPayOff+TPayOff
	quit
OutputRowGetMonthBenfitAnaly
	s Data=$lb(TRowID,TEquipName,TOriginalFee,TInCome,TOutCome,TDepreFee,TMaintFee,TConsumableFee,TResourceFee,TPayOff,TCallBackTime,TEquipNo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetMonthBenfitAnaly
	s (TRowID,TEquipName,TOriginalFee,TInCome,TOutCome,TDepreFee,TMaintFee,TConsumableFee,TResourceFee,TPayOff,TCallBackTime,TEquipNo)=""
	quit
}

ClassMethod GetMonthBenfitAnalyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMonthBenfitAnalyExecute ]
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

Query GetMonthBenfitAnaly(vData As %String = "", QXType As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEquipName:%String,TOriginalFee:%String,TInCome:%String,TOutCome:%String,TDepreFee:%String,TMaintFee:%String,TConsumableFee:%String,TResourceFee:%String,TPayOff:%String,TCallBackTime:%String,TEquipNo:%String") [ SqlProc ]
{
}

/***************************************************************************/
/// 设备盈利亏损统计分析
ClassMethod GetProfitLossAnalyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetProfitLossAnalyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetProfitLossAnalyExecute(ByRef qHandle As %Binary, vData As %String = "", Flag As %String = "", QXType As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=2
	s rowid=0
	s (SumOriginalFee,SumInCome,SumOutCome,SumDepre,SumMaint,SumConsumable,SumResource,SumPayOff)=0
	d BuildDataGetProfitLossAnaly
	Quit $$$OK
BuildDataGetProfitLossAnaly
	Set vData=..UnEscape(vData)
	Set Equip=..GetDataByName(vData,"Equip")
	Set EquipNo=..GetDataByName(vData,"EquipNo")
	Set EquipCode=..GetDataByName(vData,"EquipCode")
	Set EquipTypeDR=..GetDataByName(vData,"EquipTypeDR")
	Set StatCatDR=..GetDataByName(vData,"StatCatDR")
	Set EquipCatDR=..GetDataByName(vData,"EquipCatDR")
	Set ContactSub=..GetDataByName(vData,"ContactSub")
	Set UseLocDR=..GetDataByName(vData,"UseLocDR")
	Set StartOriginalFee=..GetDataByName(vData,"StartOriginalFee")
	Set EndOriginalFee=..GetDataByName(vData,"EndOriginalFee")
	Set StartDate=..GetDataByName(vData,"StartDate")
	Set EndDate=..GetDataByName(vData,"EndDate")
	i (StartDate'="")&&(EndDate'="")&&($ZDH(StartDate_"-01",3)>$ZD(EndDate_"-01",3)) q
	Set InStockStartDate=..GetDataByName(vData,"InStockStartDate")
	;i InStockStartDate'="" s InStockStartDate=$zdh(InStockStartDate,4)
	;日期格式统一调整
	s InStockStartDate=##Class(web.DHCEQCommon).TransValueFromPage(InStockStartDate,"date")
	Set InStockEndDate=..GetDataByName(vData,"InStockEndDate")
	;i InStockEndDate'="" s InStockEndDate=$zdh(InStockEndDate,4)
	;日期格式统一调整
	s InStockEndDate=##Class(web.DHCEQCommon).TransValueFromPage(InStockEndDate,"date")
	Set IsDisUseDR=..GetDataByName(vData,"IsDisUseDR")
	Set Rows=..GetDataByName(vData,"Rows")
	Set ItemDR=..GetDataByName(vData,"ItemDR")
	s EquipNo=$ZCONVERT(EquipNo,"U")
	s EquipCode=$ZCONVERT(EquipCode,"U")
	k ^TempDHCEQ("DHCEQProfitLossAnaly",$J)
	if UseLocDR'=""
	{
		f  s rowid=$o(^DHCEQEquip(0,"UseLoc",UseLocDR,rowid))  q:rowid=""  d
		.d CheckProfitLossEquip
		.q:passed=0
		.s ^TempDHCEQ("DHCEQProfitLossAnaly",$J,TPayOffRate,TRowID)=TEquipName_"^"_TOriginalFee_"^"_TInCome_"^"_TOutCome_"^"_TDepreFee_"^"_TMaintFee_"^"_TConsumableFee_"^"_TResourceFee_"^"_TPayOff_"^"_TCallBackTime_"^"_TEquipNo
	}
	else
	{
		f  s rowid=$o(^DHCEQEquip(rowid))  q:rowid=""  d
		.d CheckProfitLossEquip
		.q:passed=0
		.s ^TempDHCEQ("DHCEQProfitLossAnaly",$J,TPayOffRate,TRowID)=TEquipName_"^"_TOriginalFee_"^"_TInCome_"^"_TOutCome_"^"_TDepreFee_"^"_TMaintFee_"^"_TConsumableFee_"^"_TResourceFee_"^"_TPayOff_"^"_TCallBackTime_"^"_TEquipNo
	}
	s PayOffRate=""
	s Currow=0
	f  s PayOffRate=$o(^TempDHCEQ("DHCEQProfitLossAnaly",$J,PayOffRate),-1)  q:(PayOffRate="")||((Rows'="")&&(Currow>=Rows))  d
	.s RowID=0
	.f  s RowID=$o(^TempDHCEQ("DHCEQProfitLossAnaly",$J,PayOffRate,RowID))  q:(RowID="")||((Rows'="")&&(Currow>=Rows))  d
	..s TEquipName=$p($g(^TempDHCEQ("DHCEQProfitLossAnaly",$J,PayOffRate,RowID)),"^",1)
	..s TOriginalFee=$p($g(^TempDHCEQ("DHCEQProfitLossAnaly",$J,PayOffRate,RowID)),"^",2)
	..s TInCome=$p($g(^TempDHCEQ("DHCEQProfitLossAnaly",$J,PayOffRate,RowID)),"^",3)
	..s TOutCome=$p($g(^TempDHCEQ("DHCEQProfitLossAnaly",$J,PayOffRate,RowID)),"^",4)
	..s TDepreFee=$p($g(^TempDHCEQ("DHCEQProfitLossAnaly",$J,PayOffRate,RowID)),"^",5)
	..s TMaintFee=$p($g(^TempDHCEQ("DHCEQProfitLossAnaly",$J,PayOffRate,RowID)),"^",6)
	..s TConsumableFee=$p($g(^TempDHCEQ("DHCEQProfitLossAnaly",$J,PayOffRate,RowID)),"^",7)
	..s TResourceFee=$p($g(^TempDHCEQ("DHCEQProfitLossAnaly",$J,PayOffRate,RowID)),"^",8)
	..s TPayOff=$p($g(^TempDHCEQ("DHCEQProfitLossAnaly",$J,PayOffRate,RowID)),"^",9)
	..s TCallBackTime=$p($g(^TempDHCEQ("DHCEQProfitLossAnaly",$J,PayOffRate,RowID)),"^",10)
	..s TEquipNo=$p($g(^TempDHCEQ("DHCEQProfitLossAnaly",$J,PayOffRate,RowID)),"^",11)
	..s TPayOffRate=PayOffRate
	..s Currow=Currow+1
	..d OutputRowGetProfitLossAnaly
	d ResetVariablesGetProfitLossAnaly
	s index=1
	s TEquipName="合计:"
	s TOriginalFee=SumOriginalFee
	s TInCome=SumInCome
	s TOutCome=SumOutCome
	s TDepreFee=SumDepre
	s TMaintFee=SumMaint
	s TConsumableFee=SumConsumable
	s TResourceFee=SumResource
	s TPayOff=SumPayOff
	d OutputRowGetProfitLossAnaly
	quit
CheckProfitLossEquip
	d ResetVariablesGetProfitLossAnaly
	s passed=1
	s passed=..CheckEquipID(rowid)
	i passed=0 q
	s TRowID=rowid
	s Name=$p($g(^DHCEQEquip(rowid)),"^",1)
	i (Equip'="")&&(Name'[Equip)
	{
		s passed=0
		q
	}
	s Item=$p($g(^DHCEQEquip(rowid)),"^",7)
	i (ItemDR'="")&&(Item'=ItemDR)
	{
		s passed=0
		q
	}
	s Code=$ZCONVERT($p($g(^DHCEQEquip(rowid)),"^",6),"U")
	i (EquipCode'="")&&($E(Code,1,$L(EquipCode))'=EquipCode)
	{
		s passed=0
		q
	}
	s No=$ZCONVERT($p($g(^DHCEQEquip(rowid)),"^",71),"U")
	i (EquipNo'="")&&($E(No,1,$L(EquipNo))'=EquipNo)
	{
		s passed=0
		q
	}
	s ETDR=$p($g(^DHCEQEquip(rowid)),"^",63)
	i (EquipTypeDR'="")&&(ETDR'=EquipTypeDR)
	{
		s passed=0
		q
	}
	s SCDR=$p($g(^DHCEQEquip(rowid)),"^",75)
	i (StatCatDR'="")&&(SCDR'=StatCatDR)
	{
		s passed=0
		q
	}
	s UseLoc=$p($g(^DHCEQEquip(rowid)),"^",19)
	i (UseLocDR'="")&&(UseLoc'=UseLocDR)
	{
		s passed=0
		q
	}
	s InvalidFlag=$p($g(^DHCEQEquip(rowid)),"^",59)
	i InvalidFlag="Y"
	{
		s passed=0
		q
	}		
	s ECDR=$p($g(^DHCEQEquip(rowid)),"^",4)
	i (EquipCatDR'="")&&(ECDR'=EquipCatDR)
	{
		i (ContactSub'="1")
		{
			s passed=0
		}
		else
		{
			s passed=##class(web.DHCEQCEquipeCat).IsChildPar(EquipCatDR,ECDR)
		}
		i passed=0 q
	}
	s EQFee=$p($g(^DHCEQEquip(rowid)),"^",27)
	i (StartOriginalFee'="")&&(EQFee<StartOriginalFee)
	{
		s passed=0
		q
	}
	i (EndOriginalFee'="")&&(EQFee>EndOriginalFee)
	{
		s passed=0
		q
	}
	s InStockListDR=$p($g(^DHCEQEquip(rowid)),"^",70)
	if ((InStockStartDate'="")||(InStockEndDate'=""))	
	{
		i (InStockListDR="")
		{	s InStockDate=$p($g(^DHCEQEquip(rowid)),"^",45)}
		else
		{
			s InStockDate=$p($g(^DHCEQInStockList(InStockListDR)),"^",1)
			s InStockDate=$p($g(^DHCEQInStock(InStockDate)),"^",13)
		}
		i ((InStockStartDate'="")&(InStockDate<InStockStartDate))
		{s passed=0
		q}
		
		i ((InStockEndDate'="")&(InStockDate>InStockEndDate))
		{s passed=0
		q}
	}
	s Status=$p($g(^DHCEQEquip(rowid)),"^",38)
	i (IsDisUseDR="Y")&(Status'=3)
	{
		s passed=0
		q
	}
	i (IsDisUseDR="N")&(Status=3)
	{
		s passed=0
		q
	}
	s StockStatus=$p($g(^DHCEQEquip(rowid)),"^",60)
	i (StockStatus=0)||(StockStatus=3)
	{
		s passed=0
		q
	}
	s StoreLoc=$p($g(^DHCEQEquip(rowid)),"^",67) //2010-10-29 DJ begin
	i StoreLoc'=""
	{
		s Find=##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLoc)
		i Find'=0
		{
			s passed=0
			q
		}
	} //2010-10-29 DJ end
	s TRowID=rowid
	s TEquipName=Name
	s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(EQFee,"",2)
	s TEquipNo=No
	s InCome=..AllInCome(rowid,StartDate,EndDate,QXType)
	s TInCome=##Class(web.DHCEQCommon).FormatNumber($p(InCome,"^",1)+$p(InCome,"^",4),"",2)
	s TConsumableFee=##Class(web.DHCEQCommon).FormatNumber($p(InCome,"^",2),"",2)
	k ^TempDHCEQ("EquipOutDetailFee",$J)
	
	;Modified by JDL JDL0079 优化效率 2011-04-19
	s TMaintFee=..GetOutFeeByLifeInfo(rowid,StartDate,EndDate,"31",QXType)
	s TMaintFee=TMaintFee+..GetOutFeeByLifeInfo(rowid,StartDate,EndDate,"32",QXType)
	s TMaintFee=TMaintFee+..GetOutFeeByLifeInfo(rowid,StartDate,EndDate,"33",QXType)
	s TMaintFee=TMaintFee+..GetGuaranteeFee(rowid,StartDate,EndDate)
	s TMaintFee=##Class(web.DHCEQCommon).FormatNumber(TMaintFee,"",2)
	s TDepreFee=..GetOutFeeByLifeInfo(rowid,StartDate,EndDate,"35",QXType)
	s TDepreFee=##Class(web.DHCEQCommon).FormatNumber(TDepreFee,"",2)
	
	s TResourceFee=##Class(web.DHCEQCommon).FormatNumber(..EquipResourceFee(rowid,StartDate,EndDate,QXType),"",2)
	s TOutCome=##Class(web.DHCEQCommon).FormatNumber(TDepreFee+TMaintFee+TConsumableFee+TResourceFee,"",2)
	s TPayOff=##Class(web.DHCEQCommon).FormatNumber(TInCome-TOutCome,"",2)
	i (Flag=1)&&(TPayOff<0) //盈利
	{
		s passed=0
		q
	}
	i (Flag=0)&&(TPayOff>=0) //亏损
	{
		s passed=0
		q
	}
	s AnalyMonth=..GetAnalyMonth(rowid,StartDate,EndDate)
	i TDepreFee+TPayOff>0 s TCallBackTime=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee/(((TDepreFee+TPayOff)/AnalyMonth)*12),"",2)
	i TOriginalFee=0 s TCallBackTime=""
	s TPayOffRate=0.00
	i TOriginalFee>0 s TPayOffRate=##Class(web.DHCEQCommon).FormatNumber(((TPayOff/AnalyMonth)*12)/TOriginalFee*100,"",2)
	s SumOriginalFee=SumOriginalFee+TOriginalFee
	s SumInCome=SumInCome+TInCome
	s SumOutCome=SumOutCome+TOutCome
	s SumDepre=SumDepre+TDepreFee
	s SumMaint=SumMaint+TMaintFee
	s SumConsumable=SumConsumable+TConsumableFee
	s SumResource=SumResource+TResourceFee
	s SumPayOff=SumPayOff+TPayOff
	quit
OutputRowGetProfitLossAnaly
	s Data=$lb(TRowID,TEquipName,TOriginalFee,TInCome,TOutCome,TDepreFee,TMaintFee,TConsumableFee,TResourceFee,TPayOff,TCallBackTime,TEquipNo,TPayOffRate)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetProfitLossAnaly
	s (TRowID,TEquipName,TOriginalFee,TInCome,TOutCome,TDepreFee,TMaintFee,TConsumableFee,TResourceFee,TPayOff,TCallBackTime,TEquipNo,TPayOffRate)=""
	quit
}

ClassMethod GetProfitLossAnalyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetProfitLossAnalyExecute ]
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

Query GetProfitLossAnaly(vData As %String = "", Flag As %String = "", QXType As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEquipName:%String,TOriginalFee:%String,TInCome:%String,TOutCome:%String,TDepreFee:%String,TMaintFee:%String,TConsumableFee:%String,TResourceFee:%String,TPayOff:%String,TCallBackTime:%String,TEquipNo:%String,TPayOffRate:%String") [ SqlProc ]
{
}

/***************************************************************************/
/// 设备收益率分析
ClassMethod GetYeildRateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetYeildRateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetYeildRateExecute(ByRef qHandle As %Binary, vData As %String = "", QXType As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=2
	s rowid=0
	s (SumNetInCome,SumInvest)=0
	d BuildDataGetYeildRate
	Quit $$$OK
BuildDataGetYeildRate
	Set vData=..UnEscape(vData)
	Set Equip=..GetDataByName(vData,"Equip")
	Set EquipNo=..GetDataByName(vData,"EquipNo")
	Set EquipCode=..GetDataByName(vData,"EquipCode")
	Set EquipTypeDR=..GetDataByName(vData,"EquipTypeDR")
	Set StatCatDR=..GetDataByName(vData,"StatCatDR")
	Set EquipCatDR=..GetDataByName(vData,"EquipCatDR")
	Set ContactSub=..GetDataByName(vData,"ContactSub")
	Set UseLocDR=..GetDataByName(vData,"UseLocDR")
	Set StartOriginalFee=..GetDataByName(vData,"StartOriginalFee")
	Set EndOriginalFee=..GetDataByName(vData,"EndOriginalFee")
	Set StartDate=..GetDataByName(vData,"StartDate")
	Set EndDate=..GetDataByName(vData,"EndDate")
	i (StartDate'="")&&(EndDate'="")&&($ZDH(StartDate_"-01",3)>$ZD(EndDate_"-01",3)) q
	Set InStockStartDate=..GetDataByName(vData,"InStockStartDate")
	i InStockStartDate'="" s InStockStartDate=$zdh(InStockStartDate,4)
	Set InStockEndDate=..GetDataByName(vData,"InStockEndDate")
	i InStockEndDate'="" s InStockEndDate=$zdh(InStockEndDate,4)
	Set IsDisUseDR=..GetDataByName(vData,"IsDisUseDR")
	Set ItemDR=..GetDataByName(vData,"ItemDR")
	s EquipNo=$ZCONVERT(EquipNo,"U")
	s EquipCode=$ZCONVERT(EquipCode,"U")
	if UseLocDR'=""
	{
		f  s rowid=$o(^DHCEQEquip(0,"UseLoc",UseLocDR,rowid))  q:rowid=""  d
		.d CheckYeildRateEquip
		.q:passed=0
		.d OutputRowGetYeildRate
	}
	else
	{
		f  s rowid=$o(^DHCEQEquip(rowid))  q:rowid=""  d
		.d CheckYeildRateEquip
		.q:passed=0
		.d OutputRowGetYeildRate
	}
	d ResetVariablesGetYeildRate
	s index=1
	s TEquipName="合计:"
	s TNetInCome=SumNetInCome
	s TInvest=SumInvest
	d OutputRowGetYeildRate
	quit
CheckYeildRateEquip
	d ResetVariablesGetYeildRate
	s passed=1
	s passed=..CheckEquipID(rowid)
	i passed=0 q
	s TRowID=rowid
	s Name=$p($g(^DHCEQEquip(rowid)),"^",1)
	i (Equip'="")&&(Name'[Equip)
	{
		s passed=0
		q
	}
	s Item=$p($g(^DHCEQEquip(rowid)),"^",7)
	i (ItemDR'="")&&(Item'=ItemDR)
	{
		s passed=0
		q
	}
	s Code=$ZCONVERT($p($g(^DHCEQEquip(rowid)),"^",6),"U")
	i (EquipCode'="")&&($E(Code,1,$L(EquipCode))'=EquipCode)
	{
		s passed=0
		q
	}
	s No=$ZCONVERT($p($g(^DHCEQEquip(rowid)),"^",71),"U")
	i (EquipNo'="")&&($E(No,1,$L(EquipNo))'=EquipNo)
	{
		s passed=0
		q
	}
	s ETDR=$p($g(^DHCEQEquip(rowid)),"^",63)
	i (EquipTypeDR'="")&&(ETDR'=EquipTypeDR)
	{
		s passed=0
		q
	}
	s SCDR=$p($g(^DHCEQEquip(rowid)),"^",75)
	i (StatCatDR'="")&&(SCDR'=StatCatDR)
	{
		s passed=0
		q
	}
	s UseLoc=$p($g(^DHCEQEquip(rowid)),"^",19)
	i (UseLocDR'="")&&(UseLoc'=UseLocDR)
	{
		s passed=0
		q
	}
	s InvalidFlag=$p($g(^DHCEQEquip(rowid)),"^",59)
	i InvalidFlag="Y"
	{
		s passed=0
		q
	}		
	s ECDR=$p($g(^DHCEQEquip(rowid)),"^",4)
	i (EquipCatDR'="")&&(ECDR'=EquipCatDR)
	{
		i (ContactSub'="1")
		{
			s passed=0
		}
		else
		{
			s passed=##class(web.DHCEQCEquipeCat).IsChildPar(EquipCatDR,ECDR)
		}
		i passed=0 q
	}
	s EQFee=$p($g(^DHCEQEquip(rowid)),"^",27)
	i (StartOriginalFee'="")&&(EQFee<StartOriginalFee)
	{
		s passed=0
		q
	}
	i (EndOriginalFee'="")&&(EQFee>EndOriginalFee)
	{
		s passed=0
		q
	}
	s InStockListDR=$p($g(^DHCEQEquip(rowid)),"^",70)
	if ((InStockStartDate'="")||(InStockEndDate'=""))	
	{
		i (InStockListDR="")
		{	s InStockDate=$p($g(^DHCEQEquip(rowid)),"^",45)}
		else
		{
			s InStockDate=$p($g(^DHCEQInStockList(InStockListDR)),"^",1)
			s InStockDate=$p($g(^DHCEQInStock(InStockDate)),"^",13)
		}
		i ((InStockStartDate'="")&(InStockDate<InStockStartDate))
		{s passed=0
		q}
		
		i ((InStockEndDate'="")&(InStockDate>InStockEndDate))
		{s passed=0
		q}
	}
	s Status=$p($g(^DHCEQEquip(rowid)),"^",38)
	i (IsDisUseDR="Y")&(Status'=3)
	{
		s passed=0
		q
	}
	i (IsDisUseDR="N")&(Status=3)
	{
		s passed=0
		q
	}
	s StockStatus=$p($g(^DHCEQEquip(rowid)),"^",60)
	i (StockStatus=0)||(StockStatus=3)
	{
		s passed=0
		q
	}
	s StoreLoc=$p($g(^DHCEQEquip(rowid)),"^",67) //2010-10-29 DJ begin
	i StoreLoc'=""
	{
		s Find=##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLoc)
		i Find'=0
		{
			s passed=0
			q
		}
	} //2010-10-29 DJ end
	s TRowID=rowid
	s TEquipName=Name
	s TInvest=##Class(web.DHCEQCommon).FormatNumber(EQFee,"",2)
	s TEquipNo=No
	s InCome=..AllInCome(rowid,StartDate,EndDate,QXType)
	s TInCome=##Class(web.DHCEQCommon).FormatNumber($p(InCome,"^",1)+$p(InCome,"^",4),"",2)
	s TConsumableFee=##Class(web.DHCEQCommon).FormatNumber($p(InCome,"^",2),"",2)
	k ^TempDHCEQ("EquipOutDetailFee",$J)
	
	;Modified by JDL JDL0079 优化效率 2011-04-19
	s TMaintFee=..GetOutFeeByLifeInfo(rowid,StartDate,EndDate,"31",QXType)
	s TMaintFee=TMaintFee+..GetOutFeeByLifeInfo(rowid,StartDate,EndDate,"32",QXType)
	s TMaintFee=TMaintFee+..GetOutFeeByLifeInfo(rowid,StartDate,EndDate,"33",QXType)
	s TMaintFee=TMaintFee+..GetGuaranteeFee(rowid,StartDate,EndDate)
	s TMaintFee=##Class(web.DHCEQCommon).FormatNumber(TMaintFee,"",2)
	s TDepreFee=..GetOutFeeByLifeInfo(rowid,StartDate,EndDate,"35",QXType)
	s TDepreFee=##Class(web.DHCEQCommon).FormatNumber(TDepreFee,"",2)
	
	s TResourceFee=##Class(web.DHCEQCommon).FormatNumber(..EquipResourceFee(rowid,StartDate,EndDate,QXType),"",2)
	s TOutCome=##Class(web.DHCEQCommon).FormatNumber(TDepreFee+TMaintFee+TConsumableFee+TResourceFee,"",2)
	s TPayOff=##Class(web.DHCEQCommon).FormatNumber(TInCome-TOutCome,"",2)
	s AnalyMonth=..GetAnalyMonth(rowid,StartDate,EndDate)
	i TDepreFee+TPayOff>0 s TCallBackTime=##Class(web.DHCEQCommon).FormatNumber(TInvest/(((TDepreFee+TPayOff)/AnalyMonth)*12),"",2)
	i TInvest=0 s TCallBackTime=""
	s TNetInCome=##Class(web.DHCEQCommon).FormatNumber((TPayOff+TDepreFee)/AnalyMonth*12,"",2)
	s TYeildRate=0.00
	s TYearRate=0.00
	i TInvest>0 
	{
		s TYeildRate=##Class(web.DHCEQCommon).FormatNumber(TNetInCome/12/TInvest*100,"",2)
		s TYearRate=##Class(web.DHCEQCommon).FormatNumber(TNetInCome/TInvest*100,"",2)
	}
	s SumNetInCome=SumNetInCome+TNetInCome
	s SumInvest=SumInvest+TInvest
	quit
OutputRowGetYeildRate
	s Data=$lb(TRowID,TEquipName,TNetInCome,TInvest,TYeildRate,TYear,TYearRate,TEquipNo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetYeildRate
	s (TRowID,TEquipName,TNetInCome,TInvest,TYeildRate,TYear,TYearRate,TEquipNo)=""
	quit
}

ClassMethod GetYeildRateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetYeildRateExecute ]
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

Query GetYeildRate(vData As %String = "", QXType As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEquipName:%String,TNetInCome:%String,TInvest:%String,TYeildRate:%String,TYear:%String,TYearRate:%String,TEquipNo:%String") [ SqlProc ]
{
}

/***************************************************************************/
/// 设备回收期分析
ClassMethod GetInvestCallBackTimeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInvestCallBackTimeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetInvestCallBackTimeExecute(ByRef qHandle As %Binary, vData As %String = "", QXType As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=2
	s rowid=0
	s (SumNetInCome,SumInvest)=0
	d BuildDataGetInvestCallBackTime
	Quit $$$OK
BuildDataGetInvestCallBackTime
	Set vData=..UnEscape(vData)
	Set Equip=..GetDataByName(vData,"Equip")
	Set EquipNo=..GetDataByName(vData,"EquipNo")
	Set EquipCode=..GetDataByName(vData,"EquipCode")
	Set EquipTypeDR=..GetDataByName(vData,"EquipTypeDR")
	Set StatCatDR=..GetDataByName(vData,"StatCatDR")
	Set EquipCatDR=..GetDataByName(vData,"EquipCatDR")
	Set ContactSub=..GetDataByName(vData,"ContactSub")
	Set UseLocDR=..GetDataByName(vData,"UseLocDR")
	Set StartOriginalFee=..GetDataByName(vData,"StartOriginalFee")
	Set EndOriginalFee=..GetDataByName(vData,"EndOriginalFee")
	Set StartDate=..GetDataByName(vData,"StartDate")
	Set EndDate=..GetDataByName(vData,"EndDate")
	i (StartDate'="")&&(EndDate'="")&&($ZDH(StartDate_"-01",3)>$ZD(EndDate_"-01",3)) q
	Set InStockStartDate=..GetDataByName(vData,"InStockStartDate")
	;i InStockStartDate'="" s InStockStartDate=$zdh(InStockStartDate,4)
	;日期格式统一调整
	s InStockStartDate=##Class(web.DHCEQCommon).TransValueFromPage(InStockStartDate,"date")
	Set InStockEndDate=..GetDataByName(vData,"InStockEndDate")
	;i InStockEndDate'="" s InStockEndDate=$zdh(InStockEndDate,4)
	;日期格式统一调整
	s InStockEndDate=##Class(web.DHCEQCommon).TransValueFromPage(InStockEndDate,"date")
	Set IsDisUseDR=..GetDataByName(vData,"IsDisUseDR")
	Set ItemDR=..GetDataByName(vData,"ItemDR")
	s EquipNo=$ZCONVERT(EquipNo,"U")
	s EquipCode=$ZCONVERT(EquipCode,"U")
	if UseLocDR'=""
	{
		f  s rowid=$o(^DHCEQEquip(0,"UseLoc",UseLocDR,rowid))  q:rowid=""  d
		.d CheckInvestCallBackEquip
		.q:passed=0
		.d OutputRowGetInvestCallBackTime
	}
	else
	{
		f  s rowid=$o(^DHCEQEquip(rowid))  q:rowid=""  d
		.d CheckInvestCallBackEquip
		.q:passed=0
		.d OutputRowGetInvestCallBackTime
	}
	d ResetVariablesGetInvestCallBackTime
	s index=1
	s TEquipName="合计:"
	s TNetInCome=SumNetInCome
	s TInvest=SumInvest
	d OutputRowGetInvestCallBackTime
	quit
CheckInvestCallBackEquip
	d ResetVariablesGetInvestCallBackTime
	s passed=1
	s passed=..CheckEquipID(rowid)
	i passed=0 q
	s TRowID=rowid
	s Name=$p($g(^DHCEQEquip(rowid)),"^",1)
	i (Equip'="")&&(Name'[Equip)
	{
		s passed=0
		q
	}
	s Item=$p($g(^DHCEQEquip(rowid)),"^",7)
	i (ItemDR'="")&&(Item'=ItemDR)
	{
		s passed=0
		q
	}
	s Code=$ZCONVERT($p($g(^DHCEQEquip(rowid)),"^",6),"U")
	i (EquipCode'="")&&($E(Code,1,$L(EquipCode))'=EquipCode)
	{
		s passed=0
		q
	}
	s No=$ZCONVERT($p($g(^DHCEQEquip(rowid)),"^",71),"U")
	i (EquipNo'="")&&($E(No,1,$L(EquipNo))'=EquipNo)
	{
		s passed=0
		q
	}
	s ETDR=$p($g(^DHCEQEquip(rowid)),"^",63)
	i (EquipTypeDR'="")&&(ETDR'=EquipTypeDR)
	{
		s passed=0
		q
	}
	s SCDR=$p($g(^DHCEQEquip(rowid)),"^",75)
	i (StatCatDR'="")&&(SCDR'=StatCatDR)
	{
		s passed=0
		q
	}
	s UseLoc=$p($g(^DHCEQEquip(rowid)),"^",19)
	i (UseLocDR'="")&&(UseLoc'=UseLocDR)
	{
		s passed=0
		q
	}
	s InvalidFlag=$p($g(^DHCEQEquip(rowid)),"^",59)
	i InvalidFlag="Y"
	{
		s passed=0
		q
	}		
	s ECDR=$p($g(^DHCEQEquip(rowid)),"^",4)
	i (EquipCatDR'="")&&(ECDR'=EquipCatDR)
	{
		i (ContactSub'="1")
		{
			s passed=0
		}
		else
		{
			s passed=##class(web.DHCEQCEquipeCat).IsChildPar(EquipCatDR,ECDR)
		}
		i passed=0 q
	}
	s EQFee=$p($g(^DHCEQEquip(rowid)),"^",27)
	i (StartOriginalFee'="")&&(EQFee<StartOriginalFee)
	{
		s passed=0
		q
	}
	i (EndOriginalFee'="")&&(EQFee>EndOriginalFee)
	{
		s passed=0
		q
	}
	s InStockListDR=$p($g(^DHCEQEquip(rowid)),"^",70)
	if ((InStockStartDate'="")||(InStockEndDate'=""))	
	{
		i (InStockListDR="")
		{	s InStockDate=$p($g(^DHCEQEquip(rowid)),"^",45)}
		else
		{
			s InStockDate=$p($g(^DHCEQInStockList(InStockListDR)),"^",1)
			s InStockDate=$p($g(^DHCEQInStock(InStockDate)),"^",13)
		}
		i ((InStockStartDate'="")&(InStockDate<InStockStartDate))
		{s passed=0
		q}
		
		i ((InStockEndDate'="")&(InStockDate>InStockEndDate))
		{s passed=0
		q}
	}
	s Status=$p($g(^DHCEQEquip(rowid)),"^",38)
	i (IsDisUseDR="Y")&(Status'=3)
	{
		s passed=0
		q
	}
	i (IsDisUseDR="N")&(Status=3)
	{
		s passed=0
		q
	}
	s StockStatus=$p($g(^DHCEQEquip(rowid)),"^",60)
	i (StockStatus=0)||(StockStatus=3)
	{
		s passed=0
		q
	}
	s StoreLoc=$p($g(^DHCEQEquip(rowid)),"^",67) //2010-10-29 DJ begin
	i StoreLoc'=""
	{
		s Find=##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLoc)
		i Find'=0
		{
			s passed=0
			q
		}
	} //2010-10-29 DJ end
	s TRowID=rowid
	s TEquipName=Name
	s TInvest=##Class(web.DHCEQCommon).FormatNumber(EQFee,"",2)
	s TEquipNo=No
	s InCome=..AllInCome(rowid,StartDate,EndDate,QXType)
	s TInCome=##Class(web.DHCEQCommon).FormatNumber($p(InCome,"^",1)+$p(InCome,"^",4),"",2)
	s TConsumableFee=##Class(web.DHCEQCommon).FormatNumber($p(InCome,"^",2),"",2)
	k ^TempDHCEQ("EquipOutDetailFee",$J)
	
	;Modified by JDL JDL0079 优化效率 2011-04-19
	s TMaintFee=..GetOutFeeByLifeInfo(rowid,StartDate,EndDate,"31",QXType)
	s TMaintFee=TMaintFee+..GetOutFeeByLifeInfo(rowid,StartDate,EndDate,"32",QXType)
	s TMaintFee=TMaintFee+..GetOutFeeByLifeInfo(rowid,StartDate,EndDate,"33",QXType)
	s TMaintFee=TMaintFee+..GetGuaranteeFee(rowid,StartDate,EndDate)
	s TMaintFee=##Class(web.DHCEQCommon).FormatNumber(TMaintFee,"",2)
	s TDepreFee=..GetOutFeeByLifeInfo(rowid,StartDate,EndDate,"35",QXType)
	s TDepreFee=##Class(web.DHCEQCommon).FormatNumber(TDepreFee,"",2)
	
	s TResourceFee=##Class(web.DHCEQCommon).FormatNumber(..EquipResourceFee(rowid,StartDate,EndDate,QXType),"",2)
	s TOutCome=##Class(web.DHCEQCommon).FormatNumber(TDepreFee+TMaintFee+TConsumableFee+TResourceFee,"",2)
	s TPayOff=##Class(web.DHCEQCommon).FormatNumber(TInCome-TOutCome,"",2)
	s AnalyMonth=..GetAnalyMonth(rowid,StartDate,EndDate)
	i TDepreFee+TPayOff>0 s TCallBackTime=##Class(web.DHCEQCommon).FormatNumber(TInvest/(((TDepreFee+TPayOff)/AnalyMonth)*12),"",2)
	s TNetInCome=##Class(web.DHCEQCommon).FormatNumber((TPayOff+TDepreFee)/AnalyMonth*12,"",2)
	s SumNetInCome=SumNetInCome+TNetInCome
	s SumInvest=SumInvest+TInvest
	quit
OutputRowGetInvestCallBackTime
	s Data=$lb(TRowID,TEquipName,TNetInCome,TInvest,TCallBackTime,TYear,TEquipNo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetInvestCallBackTime
	s (TRowID,TEquipName,TNetInCome,TInvest,TCallBackTime,TYear,TEquipNo)=""
	quit
}

ClassMethod GetInvestCallBackTimeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInvestCallBackTimeExecute ]
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

Query GetInvestCallBackTime(vData As %String = "", QXType As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEquipName:%String,TNetInCome:%String,TInvest:%String,TCallBackTime:%String,TYear:%String,TEquipNo:%String") [ SqlProc ]
{
}

/***************************************************************************/
/// 设备总收入及设备耗材费
/// w ##Class(web.DHCEQBenefitAnalyReport).AllInCome("826","","2011-01","","1","1")
ClassMethod AllInCome(EquipDR As %String = "", StartDate As %String = "", EndDate As %String = "", QXType As %String = "", CTLocID As %String = "", CurGroupID As %String = "")
{
	q ##Class(web.DHCEQBenefitAnalyReport).AllInComeNew(EquipDR,StartDate,EndDate,QXType,CTLocID,CurGroupID)
	new Start,End,URRowID,Find,UseLoc
	new URFee,Amount,TotalFee,vCount
	
	i EquipDR=""  q ""
	s Amount=0
	s URFee=0
	s Start=..StartDate(StartDate)
	s End=..EndDate(EndDate)
	i CTLocID'="" s CTLocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",CTLocID)    //Modefied by zc0050  2019-10-19  CTLocID取值对应DHCEQCDepartment表中的值
	;Modified by JDL JDL0079 优化效率 2011-04-19
	;^DHCEQUseRecord(0,"SourceDate",{UR_Status},{UR_SourceType},{UR_SourceID},{UR_UseDate},{UR_RowID})
	s vCount=0
	f  s Start=$o(^DHCEQUseRecord(0,"SourceDate",2,1,EquipDR,Start))  q:(Start="")||(Start>End)  d
	.s URRowID=0
	.f  s URRowID=$o(^DHCEQUseRecord(0,"SourceDate",2,1,EquipDR,Start,URRowID)) q:URRowID=""  d
	..q:$p($g(^DHCEQUseRecord(URRowID)),"^",20)="Y"		;InvalidFlag
	..s Find=0 //2010-10-29 DJ begin
	..s UseLoc=$p($g(^DHCEQUseRecord(URRowID)),"^",9)
	..i UseLoc'=""  d
	...s Find=##class(web.DHCEQCommon).LocIsInEQ(QXType,UseLoc,CTLocID,CurGroupID)
	..q:Find'=0 //2010-10-29 DJ end
	..s URFee=URFee+..GetUseRecordConsumableFee(URRowID)
	..s TotalFee=$p($g(^DHCEQUseRecord(URRowID)),"^",12)
	..s vCount=vCount+$p($g(^DHCEQUseRecord(URRowID)),"^",7)
	..s Amount=Amount+TotalFee
	q Amount_"^"_URFee_"^"_vCount
}

/// add by zy 2013-05-29 ZY0107
/// 设备总收入及设备耗材费从使用记录汇总表中取数据
/// w ##Class(web.DHCEQBenefitAnalyReport).AllInCome("2282","2013-01","2013-01","","1","1")
/// add by zx  2014-09-28  新增消耗额外收费统计，用于报表收入汇总 
ClassMethod AllInComeNew(EquipDR As %String = "", StartDate As %String = "", EndDate As %String = "", QXType As %String = "", CTLocID As %String = "", CurGroupID As %String = "")
{
	new SYear,EYear,SMonth,EMonth,YearLen,MonthLen
	new TotalFee,URFee,WorkLoadNum,PURFee
	new URSRowID,UseLoc,Month,Year,ConsumableValue
	i EquipDR=""  q ""
	s SYear=$p(StartDate,"-",1)
	s EYear=$p(EndDate,"-",1)
	s SMonth=$p(StartDate,"-",2)
	s EMonth=$p(EndDate,"-",2)
	s (TotalFee,URFee,WorkLoadNum,PURFee)=0
	i CTLocID'="" s CTLocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",CTLocID)    //Modefied by zc0050  2019-10-19  CTLocID取值对应DHCEQCDepartment表中的值
	s Year=0
	f  s Year=$o(^DHCEQUseRecordStat(0,"SourceMonth",1,EquipDR,Year)) quit:(Year="")  d
	.q:(Year<SYear)||(Year>EYear)
	.s Month=0
	.f  s Month=$o(^DHCEQUseRecordStat(0,"SourceMonth",1,EquipDR,Year,Month)) quit:Month=""  d
	..Q:(SYear=Year)&(Month<SMonth)
	..Q:(EYear=Year)&(Month>EMonth)
	..s URSRowID=0
	..f  s URSRowID=$o(^DHCEQUseRecordStat(0,"SourceMonth",1,EquipDR,Year,Month,URSRowID))  q:URSRowID=""  d
	...s UseLocID=$p($g(^DHCEQUseRecordStat(URSRowID)),"^",5)
	...i UseLocID'="" q:##class(web.DHCEQCommon).LocIsInEQ(QXType,UseLocID,CTLocID,CurGroupID)'=0
	...s ConsumableValue=..GetUseRecordConsumableFeeNew(URSRowID) //add by zx 2014-09-27
	...s URFee=+$p(ConsumableValue,"^",1)+URFee
	...s PURFee=+$p(ConsumableValue,"^",2)+PURFee
	...s TotalFee=TotalFee+$p($g(^DHCEQUseRecordStat(URSRowID)),"^",7)
	...s WorkLoadNum=WorkLoadNum+$p($g(^DHCEQUseRecordStat(URSRowID)),"^",8)
	//add by zy 2014-09-15  ZY0117 
	//改变取消耗费用的方式,取设备对应质控类型的消耗成本
	i StartDate=""  d
	.s start=0
	e  d
	.s start=$ZDH(StartDate_"-01",3)
	s end=$ZDH(EndDate_"-01",3)
	s Month=0
	f  s Month=$o(^DHCEQUseConsumableItem(0,"MonthStr","Y",1,EquipDR,Month)) q:Month=""  d
	.s MonthDate=$ZDH(Month_"-01",3)
	.q:(start>MonthDate)||(end<MonthDate)
	.s UCIRowID=0
	.f  s UCIRowID=$o(^DHCEQUseConsumableItem(0,"MonthStr","Y",1,EquipDR,Month,UCIRowID)) q:UCIRowID=""  d
	..s DataList=$g(^DHCEQUseConsumableItem(UCIRowID))
	..s ConsumableItemID=$p(DataList,"^",2)
	..s ECIrowid =$o(^DHCEQEquipConsumableItem(0,"ConsumableItemDR",ConsumableItemID,EquipDR,0))
	..s Rate=+$p($g(^DHCEQEquipConsumableItem(ECIrowid)),"^",3)
	..s Amount=+$p(DataList,"^",6)
	..i Rate'=0 s Amount=Amount*Rate  //取设备占用费用的分配比例
	..s URFee=URFee+Amount
	
	q TotalFee_"^"_URFee_"^"_WorkLoadNum_"^"_PURFee
}

/// 设备折旧费
ClassMethod EquipDepreFee(EquipDR As %String = "", StartDate As %String = "", EndDate As %String = "")
{
	i EquipDR=""  q ""
	s Amount=0
	i StartDate'=""
	{
		s StartYear=$p(StartDate,"-",1)
		s StartMonth=+$p(StartDate,"-",2)
	}
	i EndDate'=""
	{
		s EndYear=$p(EndDate,"-",1)
		s EndMonth=+$p(EndDate,"-",2)
	}
	//add by zx 2015-10-21 判断机组,取机组整体折旧费用 BUG ZX0047
	s EquipGroupID=##class(web.DHCEQBenefitAnalyReport).CheckGroupEquip(EquipDR) 
	i EquipGroupID=0 d
	.s YearMonth=""
	.f  s YearMonth=$o(^DHCEQMonthDepre(0,"EquipMonth",EquipDR,YearMonth))  q:YearMonth=""  d
	..s Year=$p(YearMonth,"-",1)
	..s Month=+$p(YearMonth,"-",2)
	..q:(StartDate'="")&&(Year<StartYear)
	..q:(EndDate'="")&&(Year>EndYear)
	..q:(StartDate'="")&&(Year=StartYear)&&(Month<StartMonth)
	..q:(EndDate'="")&&(Year=EndYear)&&(Month>EndMonth)
	..s MDRowID=0
	..f  s MDRowID=$o(^DHCEQMonthDepre(0,"EquipMonth",EquipDR,YearMonth,MDRowID))  q:MDRowID=""  d
	...s MainFlag=$p($g(^DHCEQMonthDepre(MDRowID)),"^",3)
	...q:MainFlag'="Y"
	...s MDStatus=$p($g(^DHCEQMonthDepre(MDRowID)),"^",20)	//DJ0136
	...q:MDStatus="3"
	...s DepreFee=$p($g(^DHCEQMonthDepre(MDRowID)),"^",14)
	...s Amount=Amount+DepreFee
	e  d
	.s GroupListID=0
	.f  s GroupListID=$o(^DHCEQGroupList(0,"Group",EquipGroupID,GroupListID)) q:GroupListID=""  d
	..s EquipDR=$p($g(^DHCEQGroupList(GroupListID)),"^",2)
	..s YearMonth=""
	..f  s YearMonth=$o(^DHCEQMonthDepre(0,"EquipMonth",EquipDR,YearMonth))  q:YearMonth=""  d
	...s Year=$p(YearMonth,"-",1)
	...s Month=+$p(YearMonth,"-",2)
	...q:(StartDate'="")&&(Year<StartYear)
	...q:(EndDate'="")&&(Year>EndYear)
	...q:(StartDate'="")&&(Year=StartYear)&&(Month<StartMonth)
	...q:(EndDate'="")&&(Year=EndYear)&&(Month>EndMonth)
	...s MDRowID=0
	...f  s MDRowID=$o(^DHCEQMonthDepre(0,"EquipMonth",EquipDR,YearMonth,MDRowID))  q:MDRowID=""  d
	....s MainFlag=$p($g(^DHCEQMonthDepre(MDRowID)),"^",3)
	....q:MainFlag'="Y"
	....s DepreFee=$p($g(^DHCEQMonthDepre(MDRowID)),"^",14)
	....s Amount=Amount+DepreFee
	q Amount
}

/// 设备支出明细费(以下包含:保养,检查,维修,折旧费)
/// w ##Class(web.DHCEQBenefitAnalyReport).EquipOutDetailFee("826","","","31,32,33,35","","1","1")
ClassMethod EquipOutDetailFee(EquipDR As %String = "", StartDate As %String = "", EndDate As %String = "", SourceTypeIDS As %String = "", QXType As %String = "", CTLocID As %String = "", CurGroupID As %String = "")
{
	//n (EquipDR,StartDate,EndDate,SourceTypeIDS)
	i EquipDR=""  q ""
	s Amount=""
	//维修31
	//保养32
	//检查33
	//折旧35
	i CTLocID'="" s CTLocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",CTLocID)    //Modefied by zc0050  2019-10-19  CTLocID取值对应DHCEQCDepartment表中的值
	k ^TempDHCEQ("EquipOutDetailFee",$J)
	i SourceTypeIDS'="" s SourceTypeIDS=","_SourceTypeIDS_","
	s Fee=0
	s Start=..StartDate(StartDate)
	s End=..EndDate(EndDate)
	f  s Start=$o(^DHCEQLifeInfo(0,"Equip",EquipDR,Start)) q:(Start="")||(Start>End)  d
	.s LIRowID=0
	.f  s LIRowID=$o(^DHCEQLifeInfo(0,"Equip",EquipDR,Start,LIRowID))  q:LIRowID=""  d
	..s SourceType=$p($g(^DHCEQLifeInfo(LIRowID)),"^",19)
	..q:(SourceTypeIDS'="")&&(SourceTypeIDS'[(","_SourceType_","))
	..s Fee=$p($g(^DHCEQLifeInfo(LIRowID)),"^",17)
	..s Find=0 //2010-10-29 DJ begin
	..s ToStoreLoc=$p($g(^DHCEQLifeInfo(LIRowID)),"^",10)
	..i ToStoreLoc'=""  d
	...s Find=##class(web.DHCEQCommon).LocIsInEQ(QXType,ToStoreLoc,CTLocID,CurGroupID)
	..q:Find'=0 //2010-10-29 DJ end
	..s ^TempDHCEQ("EquipOutDetailFee",$J,SourceType)=Fee+$g(^TempDHCEQ("EquipOutDetailFee",$J,SourceType))
	s Count=$l(SourceTypeIDS,",")-1
	f i=2:1:Count
	{
		s Fee=$g(^TempDHCEQ("EquipOutDetailFee",$J,$p(SourceTypeIDS,",",i)))
		s Amount=Amount_Fee_"^"
	}
	q $e(Amount,1,$l(Amount)-1)
}

/// 设备耗材费(消耗项目费)
ClassMethod EquipConsumableFee(EquipDR As %String = "", StartDate As %String = "", EndDate As %String = "", QXType As %String = "", CTLocID As %String = "", CurGroupID As %String = "")
{
	i EquipDR=""  q ""
	s Amount=0
	s Start=..StartDate(StartDate)
	s End=..EndDate(EndDate)
	i CTLocID'="" s CTLocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",CTLocID)    //Modefied by zc0050  2019-10-19  CTLocID取值对应DHCEQCDepartment表中的值
	f  s Start=$o(^DHCEQUseRecord(0,"UseDate",Start))  q:(Start="")||(Start>End)  d
	.s URRowID=0
	.f  s URRowID=$o(^DHCEQUseRecord(0,"UseDate",Start,1,EquipDR,URRowID)) q:URRowID=""  d
	..s InvalidFlag=$p($g(^DHCEQUseRecord(URRowID)),"^",20)
	..q:InvalidFlag="Y"
	..s Status=$p($g(^DHCEQUseRecord(URRowID)),"^",19)
	..q:Status'=2
	..s Find=0 //2010-10-29 DJ begin
	..s UseLoc=$p($g(^DHCEQUseRecord(URRowID)),"^",9)
	..i UseLoc'=""  d
	...s Find=##class(web.DHCEQCommon).LocIsInEQ(QXType,UseLoc,CTLocID,CurGroupID)
	..q:Find'=0 //2010-10-29 DJ end
	..s URFee=..GetUseRecordConsumableFee(URRowID)
	..s Amount=Amount+URFee
	q Amount
}

/// 根据使用记录获取对应消耗项目费用
ClassMethod GetUseRecordConsumableFee(UseRecord As %String = "")
{
	i UseRecord=""  q ""
	s URCFee=0
	s UCIRowID=0
	f  s UCIRowID=$o(^DHCEQUseConsumableItem(0,"UseRecord",UseRecord,UCIRowID))  q:UCIRowID=""  d
	.s UCIFee=$p($g(^DHCEQUseConsumableItem(UCIRowID)),"^",6)
	.s URCFee=URCFee+UCIFee
	q URCFee
}

/// add by zy 2013-05-29 ZY0107
/// 根据使用记录获取对应消耗项目费用
/// w ##Class(web.DHCEQBenefitAnalyReport).GetUseRecordConsumableFeeNew("80")
ClassMethod GetUseRecordConsumableFeeNew(UseRecordStatID As %String = "")
{
	i UseRecordStatID=""  q ""
	s URCFee=0
	s UCSRowID=0
	s PURCFee=0
	f  s UCSRowID=$o(^DHCEQUseConsumableStat(0,"UseRecordstat",UseRecordStatID,UCSRowID))  q:UCSRowID=""  d
	.s UCSFee=$p($g(^DHCEQUseConsumableStat(UCSRowID)),"^",6)
	.s URCFee=URCFee+UCSFee
	.s PUCSFee=$p($g(^DHCEQUseConsumableStat(UCSRowID)),"^",16) //add by zx 2014-09-27
	.s PURCFee=PURCFee+PUCSFee
	q URCFee_"^"_PURCFee
}

/// 设备资源费
ClassMethod EquipResourceFee(EquipDR As %String = "", StartDate As %String = "", EndDate As %String = "", QXType As %String = "", ResourceType As %String = "", CTLocID As %String = "", CurGroupID As %String = "")
{
	n Year,Month,URRowID,Find,RSTDR,Amount
	i EquipDR=""  q ""
	s Amount=0
	s Year=0
	i StartDate'=""
	{
		s StartYear=$p(StartDate,"-",1)
		s Year=StartYear-1
		s StartMonth=+$p(StartDate,"-",2)
	}
	i EndDate'=""
	{
		s EndYear=$p(EndDate,"-",1)
		s EndMonth=+$p(EndDate,"-",2)
	}
	
	;Modified by JDL JDL0079 优化效率 2011-04-19
	;^DHCEQUsedResource(0,"SourceDate",{UR_Status},{UR_SourceType},{UR_SourceID},{UR_Year},{UR_Month},{UR_RowID})
	
	f  s Year=$o(^DHCEQUsedResource(0,"SourceDate",2,1,EquipDR,Year))  q:(Year="")||((EndDate'="")&&(Year>EndYear))  d
	.s Month=0
	.f  s Month=$o(^DHCEQUsedResource(0,"SourceDate",2,1,EquipDR,Year,Month)) q:Month=""  d
	..q:(StartDate'="")&&(Year=StartYear)&&(Month<StartMonth)
	..q:(EndDate'="")&&(Year=EndYear)&&(Month>EndMonth)
	..s URRowID=0
	..f  s URRowID=$o(^DHCEQUsedResource(0,"SourceDate",2,1,EquipDR,Year,Month,URRowID))  q:URRowID=""  d
	...s Find=0 //2010-10-29 DJ
	...s UseLoc=$p($g(^DHCEQUsedResource(URRowID)),"^",10)
	...i UseLoc'=""  d
	....s Find=##class(web.DHCEQCommon).LocIsInEQ(QXType,UseLoc,CTLocID,CurGroupID)
	...q:Find'=0 //2010-10-29 DJ
	...i ResourceType'=""  d
	....s RSTDR=$p($g(^DHCEQUsedResource(URRowID)),"^",5)
	....i RSTDR'="" s RSTDR=$p($g(^DHCEQCCode("DHCEQCResourceType",RSTDR)),"^",1)
	....i (RSTDR="")||($e(RSTDR,1,$l(ResourceType))'=ResourceType) s Find=1
	...q:Find'=0
	...s Amount=Amount+$p($g(^DHCEQUsedResource(URRowID)),"^",9)
	q Amount
}

/// Modified by Modified by JDL JDL0079 优化效率 2011-04-19
/// 1.增加参数：IncludeDepreFlag："Y":包括折旧费用 其他:不包括折旧费用
/// 2.取消EquipOutDetailFee,改为通过GetOutFeeByLifeInfo获取31:维修、32保养、33检查、35折旧费用
/// 3.取消获取耗材费用,因在AllIncome方法中已经获取
/// 
/// ----------------------------------------------------------------------
/// 设备总支出
/// w ##Class(web.DHCEQBenefitAnalyReport).AllOutFee("826","","","","1","1")
ClassMethod AllOutFee(EquipDR As %String = "", StartDate As %String = "", EndDate As %String = "", QXType As %String = "", CTLocID As %String = "", CurGroupID As %String = "", IncludeDepreFlag As %String = "Y")
{
	new AllOutFee
	
	i EquipDR=""  q ""
	s AllOutFee=0
	;s OutDetailFee=..EquipOutDetailFee(EquipDR,StartDate,EndDate,"31,32,33,35", QXType,CTLocID,CurGroupID)
	;Modified by JDL JDL0079 优化效率 2011-04-19
	s AllOutFee=AllOutFee+..GetOutFeeByLifeInfo(EquipDR,StartDate,EndDate,"31", QXType,CTLocID,CurGroupID)
	s AllOutFee=AllOutFee+..GetOutFeeByLifeInfo(EquipDR,StartDate,EndDate,"32", QXType,CTLocID,CurGroupID)
	s AllOutFee=AllOutFee+..GetOutFeeByLifeInfo(EquipDR,StartDate,EndDate,"33", QXType,CTLocID,CurGroupID)
	i IncludeDepreFlag="Y" s AllOutFee=AllOutFee+..GetOutFeeByLifeInfo(EquipDR,StartDate,EndDate,"35", QXType,CTLocID,CurGroupID)
	
	;s AllOutFee=AllOutFee+..EquipConsumableFee(EquipDR,StartDate,EndDate,QXType,CTLocID,CurGroupID)
	s AllOutFee=AllOutFee+..EquipResourceFee(EquipDR,StartDate,EndDate,QXType,"",CTLocID,CurGroupID)
	q AllOutFee
}

ClassMethod StartDate(value As %String = "")
{
	i value'=""
	{
		s value=$ZDH(value_"-01",3)
		s value=value-1
	}
	else
	{
		s value=0
	}
	q value
}

ClassMethod EndDate(value As %String = "")
{
	new (value)
	i value=""
	{
		s value=+$H
	}
	else
	{
		s Year=$p(value,"-",1)
		s Month=+$p(value,"-",2)+1
		i Month>12
		{
			s Year=Year+1
			s Month=1
		}
		s value=$ZDH(Year_"-"_Month_"-01",3)-1
	}
	q value
}

ClassMethod GetAnalyMonth(EquipDR As %String = "", StartDate As %String = "", EndDate As %String = "")
{
	i EquipDR="" q ""
	i StartDate=""
	{
		s ISDate=$p($g(^DHCEQEquip(EquipDR)),"^",45)
		i ISDate=""
		{
			s InStockListDR=$p($g(^DHCEQEquip(EquipDR)),"^",70)
			i InStockListDR'=""
			{
				s ISDate=$p($g(^DHCEQInStockList(InStockListDR)),"^",1)
				s ISDate=$p(^DHCEQInStock(ISDate),"^",13)
			}
		}
		s Start=$ZD(ISDate,1)
	}
	else
	{
		s Start=$p(StartDate,"-",2)_"/01/"_$p(StartDate,"-",1)
	}
	i EndDate=""
	{
		s End=$ZD($H,1)
	}
	else
	{
		s End=$p(EndDate,"-",2)_"/01/"_$p(EndDate,"-",1)
	}
	s Return=..DateDiff("m",Start,End)+1
	q Return
}

/*
/// Add By DJ 2010-12-20
/// 描述:增加获取保修合同费
ClassMethod GetGuaranteeFee(SourceID, StartDate, EndDate)
{
	i (SourceID="")||(StartDate="")||(EndDate="") q 0
	i ($ZDH(StartDate_"-01",3)>$ZDH(EndDate_"-01",3)) q 0
	s vStart=$ZDH(StartDate_"-01",3)
	s vEnd=$ZDH(EndDate_"-01",3)
	s GFSumFee=0
	f ID=vStart:1:vEnd  d
	.;当前月份
	.s YearMonth=$E($ZD(ID,3),1,7)
	.s SCRowID=0
	.f  s SCRowID=$o(^DHCEQServiceContract(0,"Equip",SourceID,SCRowID))  q:SCRowID=""  d
	..s GFStartDate=$p($g(^DHCEQContract(SCRowID)),"^",11)
	..q:GFStartDate=""
	..s GFEndDate=$p($g(^DHCEQContract(SCRowID)),"^",12)
	..q:GFEndDate=""
	..s GFTotalFee=$p($g(^DHCEQContract(SCRowID)),"^",4)
	..s GFStartDate=$ZDH($E($ZD(GFStartDate,3),1,7)_"-01",3)
	..s GFEndDate=$ZDH($E($ZD(GFEndDate,3),1,7)_"-01",3)
	..s CurYearMonth=$ZDH(YearMonth_"-01",3)
	..i (CurYearMonth>=GFStartDate)&&(CurYearMonth<GFEndDate)  d
	...s TotalMonth=..GetMonthNum(GFStartDate,GFEndDate)
	...s TotalMonth=TotalMonth+1
	...s GFSumFee=GFSumFee+(GFTotalFee/TotalMonth)
	.s vYear=$E($ZD(ID,3),1,4)
	.s vMonth=$E($ZD(ID,3),6,7)
	.i vMonth=12  d
	..s vYear=vYear+1
	..s vMonth=1
	.e  d
	..s vMonth=vMonth+1
	.s ID=$ZDH(vYear_"-"_vMonth_"-01",3) - 1	
	q GFSumFee
}*/
/// modified by czf 393720 重写保修合同费获取方法，费用改为从DHCEQContract获取
/// 描述:增加获取保修合同费
/// 入参：SourceID：设备RowID；StartDate，EndDate格式:"yyyy-mm"
/// w ##Class(web.DHCEQBenefitAnalyReport).GetGuaranteeFee(116,"2017-07","2017-07")
ClassMethod GetGuaranteeFee(SourceID, StartDate, EndDate)
{
	i (SourceID="")||(StartDate="")||(EndDate="") q 0
	i ($ZDH(StartDate_"-01",3)>$ZDH(EndDate_"-01",3)) q 0
	s vStart=$ZDH(StartDate_"-01",3)
	s vEnd=$ZDH(EndDate_"-01",3)
	s Months=..GetMonthNum(vStart,vEnd)
	s GFSumFee=0
	
	s CTLRowID=0
	f  s CTLRowID=$o(^DHCEQContractList(0,"SourceID",2,SourceID,CTLRowID)) q:CTLRowID=""  d
	.s CTRowID=$p($g(^DHCEQContractList(CTLRowID)),"^",1)
	.s TotalFee=$p($g(^DHCEQContractList(CTLRowID)),"^",8)
	.s ContractType=$p($g(^DHCEQContract(CTRowID)),"^",39)   //0:采购，1：保修
	.q:ContractType'=1
	.s Status=$p($g(^DHCEQContract(CTRowID)),"^",24)
	.q:Status'=2
	.s GFStartDate=$p($g(^DHCEQContract(CTRowID)),"^",49)  //保修开始日期
	.q:GFStartDate=""
	.s GFEndDate=$p($g(^DHCEQContract(CTRowID)),"^",50)    //保修结束日期
	.q:GFEndDate=""
	.s GFTotalFee=$p($g(^DHCEQContract(CTRowID)),"^",5)    //保修费用
	.q:(GFTotalFee=0)||(GFTotalFee="")
	.s CTLTotalFee=0
	.s RowID=0
	.f  s RowID=$o(^DHCEQContractList(0,"Contract",CTRowID,RowID)) q:RowID=""  d
	..s CTLTotalFee=CTLTotalFee+$p($g(^DHCEQContractList(RowID)),"^",8)   //合同设备总价
	.q:CTLTotalFee=0
	.s GFStartDate=$ZDH($E($ZD(GFStartDate,3),1,7)_"-01",3)
	.s GFEndDate=$ZDH($E($ZD(GFEndDate,3),1,7)_"-01",3)
	.f Num=0:1:Months  d
	..s YearMonth=##Class(web.DHCEQCommon).GetYearMonth(StartDate,Num)
	..s CurYearMonth=$ZDH(YearMonth_"-01",3)
	..s GFFee=0
	..i (CurYearMonth>=GFStartDate)&&(CurYearMonth<GFEndDate)  d
	...s TotalMonth=..GetMonthNum(GFStartDate,GFEndDate)+1
	...s GFFee=(GFTotalFee/TotalMonth)*(TotalFee/CTLTotalFee)
	..s GFSumFee=GFSumFee+GFFee            //modified by czf 393720 end
		
	q GFSumFee
}

/// w ##Class(web.DHCEQBenefitAnalyReport).GetMonthNum("62000","62030")
ClassMethod GetMonthNum(StartDate, EndDate)
{
	s vStartDate=$ZD(StartDate,3)
	s vEndDate=$ZD(EndDate,3)
	s SYear=+$p(vStartDate,"-",1)
	s SMonth=+$p(vStartDate,"-",2)
	s EYear=+$p(vEndDate,"-",1)
	s EMonth=+$p(vEndDate,"-",2)
	s Return=(EYear-SYear)*12+EMonth-SMonth
	q Return
}

/// modified by YZ0253 结构调整,索引变化
/// w ##Class(web.DHCEQBenefitAnalyReport).CheckEquipID(1)
/// 返回值 0,不是效益分析的设备;
/// 	   1,效益分析设备;
ClassMethod CheckEquipID(id)
{
	new flag,sourcetype,sourceid,rowid
	
	s flag=0
	s sourceid=0
	f  s sourceid=$o(^DHCEQDeviceMap(0,"Equip",id,sourceid)) q:(sourceid="")||(flag=1)  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQDeviceMap(0,"Equip",id,sourceid,rowid)) q:(rowid="")||(flag=1)  d
	..i $p($g(^DHCEQDeviceMap(rowid)),"^",5)'="Y"  s flag=1	
	i flag=1 q flag
	
	//1,设备;2,设备项
	s sourcetype=""
	f  s sourcetype=$o(^DHCEQEquipService(0,"SourceService",0,sourcetype)) q:(sourcetype="")||(flag=1)  d
	.i sourcetype=2 s id=$p($g(^DHCEQEquip(id)),"^",7) 
	.q:id=""
	.s sourceid=0
	.f  s sourceid=$o(^DHCEQEquipService(0,"SourceService",0,sourcetype,id,sourceid)) q:(sourceid="")||(flag=1)  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQEquipService(0,"SourceService",0,sourcetype,id,sourceid,rowid)) q:(rowid="")||(flag=1)  d
	...i $p($g(^DHCEQEquipService(rowid)),"^",9)'="Y"  s flag=1	
		
	q flag
}

/******************************************************************/
/// Add By DJ 2010-12-21
/// 描述:收支明细查询
/// d ##class(%ResultSet).RunQuery("web.DHCEQBenefitAnalyReport","InOutDetail","","","","490","90","","")
Query InOutDetail(EquipName As %String = "", StartDate As %String = "", EndDate As %String = "", CTLocID As %String = "", CurGroupID As %String = "", UseLocDR As %String = "", EquipID As %String = "") As %Query(ROWSPEC = "TMonth:%String,TEquip:%String,TCount:%String,TInCome:%String,TConsumableFee:%String,TConsumableRate:%String,TPersonFee:%String,TPersonRate:%String,TWEFee:%String,TWERate:%String,TMaintFee:%String,TMaintRate:%String,TDepreFee:%String,TDepreRate:%String,THouseFee:%String,THouseRate:%String,TOutFee:%String,TUseLoc:%String,TNo:%String,TModel:%String,TExposure:%String,TOriginalFee:%String,TTransAssetDate:%String,TMaintainFee:%String,TInSpectFee:%String,TMaintainRate:%String,TInSpectRate:%String,TBenefitRate:%String,TUseRate:%String,TBackNum:%String,TStandUseRate:%String") [ SqlProc ]
{
}

ClassMethod InOutDetailExecute(ByRef qHandle As %Binary, EquipName As %String = "", StartDate As %String = "", EndDate As %String = "", CTLocID As %String = "", CurGroupID As %String = "", UseLocDR As %String = "", EquipID As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i (StartDate="")||(EndDate="") Quit $$$OK
	i ($ZDH(StartDate_"-01",3)>$ZDH(EndDate_"-01",3)) Quit $$$OK
	/// modified by ZY0247 2020-12-22
	s belrowid=0
	f  s belrowid=$o(^DHCEQBenefitEquipList(belrowid))  quit:belrowid=""  d
	.s Datalist=$g(^DHCEQBenefitEquipList(belrowid))
	.s rowid=$p(Datalist,"^",1)
	.q:(EquipID'="")&&(rowid'=EquipID)
	.//q:(..CheckEquipID(rowid)'=1) //只显示效益分析设备
	.
	.s TUseLocDR=$p($g(^DHCEQEquip(rowid)),"^",19)
	.q:(UseLocDR'="")&&(TUseLocDR'=UseLocDR)
	.i TUseLocDR'="" s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	.s InvalidFlag=$p($g(^DHCEQEquip(rowid)),"^",59)
	.q:InvalidFlag="Y"
	.s StockStatus=$p($g(^DHCEQEquip(rowid)),"^",60)
	.q:(StockStatus=0)||(StockStatus=3)
	.s EQStatus=$p($g(^DHCEQEquip(rowid)),"^",38)
	.q:EQStatus'=1
	.s EQName=$p($g(^DHCEQEquip(rowid)),"^",1)
	.q:(EquipName'="")&&(EQName'[EquipName)
	.s vStart=$ZDH(StartDate_"-01",3)
	.s vEnd=$ZDH(EndDate_"-01",3)
	.f ID=vStart:1:vEnd  d
	..;当前月份
	..d ResetVariablesGetInOutDetail
	..s TMonth=$E($ZD(ID,3),1,7)
	..s TEquip=$p($g(^DHCEQEquip(rowid)),"^",1)
	..s TNo=$p($g(^DHCEQEquip(rowid)),"^",71)
	..s TOriginalFee=$fn($p($g(^DHCEQEquip(rowid)),"^",27),"",2)
	..s TTransAssetDate=$p($g(^DHCEQEquip(rowid)),"^",45)
	..i TTransAssetDate'="" s TTransAssetDate=$ZD(TTransAssetDate,3)
	..s TModelDR=$p($g(^DHCEQEquip(rowid)),"^",3)
	..i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	..//modified by ZY0213
	..;s Values=..AllInCome(rowid,TMonth,TMonth,"",CTLocID,CurGroupID)
	..;s TFactualWorkLoad=+$p(Values,"^",4)
	..s TFactualWorkLoad=+##Class(web.DHCEQ.BA.STATReport).EquipUseContext(rowid,"Workload",TMonth,TMonth)
	..///modified by ZY 20221206 bug:3102745
	..s TPositiveWorkLoad=+##Class(web.DHCEQ.BA.STATReport).EquipUseContext(rowid,"Positive",TMonth,TMonth)
	..
	..s TWorkLoadPerMonth=+$p($g(^DHCEQEquip(rowid)),"^",84)
	..s TStandUseRate=$fn(+$p($g(^DHCEQEquip(rowid)),"^",92),"",2)	//2015-07-21 DJ
	..s TUseRate=0
	..///modified by ZY 20221206 bug:3102745
	..;i TWorkLoadPerMonth'=0  d
	..i TFactualWorkLoad'=0  d
	...;s TUseRate=$fn((TFactualWorkLoad/TWorkLoadPerMonth)*100,"",2)
	...s TUseRate=$fn((TPositiveWorkLoad/TFactualWorkLoad)*100,"",2)
	..;s TCount=$p(Values,"^",4)
	..s TCount=TFactualWorkLoad
	..;s TInCome=$p(Values,"^",1)+$p(Values,"^",4) //add by zx 2014-09-28
	..s TInCome=+##Class(web.DHCEQ.BA.STATReport).EquipUseContext(rowid,"InCome",TMonth,TMonth)
	..s TExposure=""	//$p(Values,"^",6)	//Add By DJ 2015-06-23
	..;s TConsumableFee=$p(Values,"^",2)
	..s TConsumableFee=+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"14",TMonth,TMonth)
	..;s TPersonFee=..EquipResourceFee(rowid,TMonth,TMonth,"","03",CTLocID,CurGroupID)
	..s TPersonFee=+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"01",TMonth,TMonth)
	..;s TWEFee=..EquipResourceFee(rowid,TMonth,TMonth,"","01",CTLocID,CurGroupID)
	..s TWEFee=+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"03",TMonth,TMonth)
	..s TWEFee=TWEFee+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"04",TMonth,TMonth)
	..
	..;Modified by JDL JDL0079 优化效率 2011-04-19
	..;s THouseFee=..EquipResourceFee(rowid,TMonth,TMonth,"","04",CTLocID,CurGroupID)
	..s THouseFee=+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"06",TMonth,TMonth)
	..;s TMaintFee=..GetOutFeeByLifeInfo(rowid,TMonth,TMonth,"31", "",CTLocID,CurGroupID)
	..s TMaintFee=+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"07",TMonth,TMonth)
	..;s TMaintainFee=..GetOutFeeByLifeInfo(rowid,TMonth,TMonth,"32", "",CTLocID,CurGroupID)		//保养
	..s TMaintainFee=+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"09",TMonth,TMonth)
	..;s TInSpectFee=..GetOutFeeByLifeInfo(rowid,TMonth,TMonth,"33", "",CTLocID,CurGroupID)		//检查
	..s TInSpectFee=+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"10",TMonth,TMonth)
	..;s TMaintFee=TMaintFee+..GetGuaranteeFee(rowid,TMonth,TMonth)
	..s TMaintFee=TMaintFee+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"08",TMonth,TMonth)
	..;s TDepreFee=..GetOutFeeByLifeInfo(rowid,TMonth,TMonth,"35", "",CTLocID,CurGroupID)
	..s TDepreFee=+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"05",TMonth,TMonth)
	..;s TOutFee=TConsumableFee+TMaintFee+TMaintainFee+TInSpectFee+TDepreFee+..EquipResourceFee(rowid,TMonth,TMonth,"","",CTLocID,CurGroupID)
	..s TOutFee=+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"",TMonth,TMonth)
	..//end  modified by ZY0213
	..
	..i TOutFee'=0  d
	...s TConsumableRate=##Class(web.DHCEQCommon).FormatNumber(TConsumableFee/TOutFee,"",2)
	...s TPersonRate=##Class(web.DHCEQCommon).FormatNumber(TPersonFee/TOutFee,"",2)
	...s TWERate=##Class(web.DHCEQCommon).FormatNumber(TWEFee/TOutFee,"",2)
	...s TMaintRate=##Class(web.DHCEQCommon).FormatNumber(TMaintFee/TOutFee,"",2)
	...s TMaintainRate=##Class(web.DHCEQCommon).FormatNumber(TMaintainFee/TOutFee,"",2)
	...s TInSpectRate=##Class(web.DHCEQCommon).FormatNumber(TInSpectFee/TOutFee,"",2)
	...s TDepreRate=##Class(web.DHCEQCommon).FormatNumber(TDepreFee/TOutFee,"",2)
	...s THouseRate=##Class(web.DHCEQCommon).FormatNumber(THouseFee/TOutFee,"",2)
	..d OutputRowGetInOutDetail
	..s vYear=$E($ZD(ID,3),1,4)
	..s vMonth=$E($ZD(ID,3),6,7)
	..i vMonth=12  d
	...s vYear=vYear+1
	...s vMonth=1
	..e  d
	...s vMonth=vMonth+1
	..s ID=$ZDH(vYear_"-"_vMonth_"-01",3) - 1
	Quit $$$OK
OutputRowGetInOutDetail
	s TInCome=##Class(web.DHCEQCommon).FormatNumber(TInCome,"",2)
	s TConsumableFee=##Class(web.DHCEQCommon).FormatNumber(TConsumableFee,"",2)
	s TConsumableRate=##Class(web.DHCEQCommon).FormatNumber(TConsumableRate,"",2)
	s TPersonFee=##Class(web.DHCEQCommon).FormatNumber(TPersonFee,"",2)
	s TPersonRate=##Class(web.DHCEQCommon).FormatNumber(TPersonRate,"",2)
	s TWEFee=##Class(web.DHCEQCommon).FormatNumber(TWEFee,"",2)
	s TWERate=##Class(web.DHCEQCommon).FormatNumber(TWERate,"",2)
	s TMaintFee=##Class(web.DHCEQCommon).FormatNumber(TMaintFee,"",2)
	s TMaintRate=##Class(web.DHCEQCommon).FormatNumber(TMaintRate,"",2)
	s TDepreFee=##Class(web.DHCEQCommon).FormatNumber(TDepreFee,"",2)
	s TDepreRate=##Class(web.DHCEQCommon).FormatNumber(TDepreRate,"",2)
	s THouseFee=##Class(web.DHCEQCommon).FormatNumber(THouseFee,"",2)
	s THouseRate=##Class(web.DHCEQCommon).FormatNumber(THouseRate,"",2)
	s TOutFee=##Class(web.DHCEQCommon).FormatNumber(TOutFee,"",2)
	s TCount=$fn(TCount,"",0)
	s TMaintainFee=##Class(web.DHCEQCommon).FormatNumber(TMaintainFee,"",2)
	s TInSpectFee=##Class(web.DHCEQCommon).FormatNumber(TInSpectFee,"",2)
	s TMaintainRate=##Class(web.DHCEQCommon).FormatNumber(TMaintainRate,"",2)
	s TInSpectRate=##Class(web.DHCEQCommon).FormatNumber(TInSpectRate,"",2)
	i +TInCome'=0  d
	.s TBenefitRate=##Class(web.DHCEQCommon).FormatNumber((TInCome-TOutFee)*100/TInCome,"",2)
	.s TBackNum=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee/(TInCome-TOutFee),"",2)  //Modify by zx 2022-12-05 2833896 回收期按利润算
	e  d
	.s TBenefitRate=0
	.s TBackNum=0
	s Data=$lb(TMonth,TEquip,TCount,TInCome,TConsumableFee,TConsumableRate,TPersonFee,TPersonRate,TWEFee,TWERate,TMaintFee,TMaintRate,TDepreFee,TDepreRate,THouseFee,THouseRate,TOutFee,TUseLoc,TNo,TModel,TExposure,TOriginalFee,TTransAssetDate,TMaintainFee,TInSpectFee,TMaintainRate,TInSpectRate,TBenefitRate,TUseRate,TBackNum,TStandUseRate)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetInOutDetail
	s (TMonth,TEquip,TCount,TInCome,TConsumableFee,TConsumableRate,TPersonFee,TPersonRate,TWEFee,TWERate,TMaintFee,TMaintRate,TDepreFee,TDepreRate,THouseFee,THouseRate,TOutFee,TUseLocDR,TNo,TModel,TExposure,TOriginalFee,TTransAssetDate,TMaintainFee,TInSpectFee,TMaintainRate,TInSpectRate,TBenefitRate,TUseRate,TBackNum,TStandUseRate)=""
	quit
}

ClassMethod InOutDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = InOutDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod InOutDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = InOutDetailExecute ]
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

/******************************************************************/
/// Add By DJ 2010-12-22
/// 描述:本量力分析--CostVolumeProfitAnaly
/// d ##class(%ResultSet).RunQuery("web.DHCEQBenefitAnalyReport","CVPAnaly","","2010-12","2011-01","1","1")
ClassMethod CVPAnalyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CVPAnalyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod CVPAnalyExecute(ByRef qHandle As %Binary, EquipName As %String = "", StartDate As %String = "", EndDate As %String = "", CTLocID As %String = "", CurGroupID As %String = "", UseLocDR As %String = "", EquipID As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetCVPAnaly
	Quit $$$OK
BuildDataGetCVPAnaly
	i (StartDate="")||(EndDate="") q
	i ($ZDH(StartDate_"-01",3)>$ZDH(EndDate_"-01",3)) q
	/// modified by ZY0247 2020-12-22
	s belrowid=0
	f  s belrowid=$o(^DHCEQBenefitEquipList(belrowid))  quit:belrowid=""  d
	.s Datalist=$g(^DHCEQBenefitEquipList(belrowid))
	.s rowid=$p(Datalist,"^",1)
	.Quit:((EquipID'="")&&(rowid'=EquipID))
	.s InvalidFlag=$p($g(^DHCEQEquip(rowid)),"^",59)
	.q:InvalidFlag="Y"
	.s StockStatus=$p($g(^DHCEQEquip(rowid)),"^",60)
	.q:(StockStatus=0)||(StockStatus=3)
	.s EQStatus=$p($g(^DHCEQEquip(rowid)),"^",38)
	.q:EQStatus'=1
	.s EQName=$p($g(^DHCEQEquip(rowid)),"^",1)
	.q:(EquipName'="")&&(EQName'[EquipName)
	.s TUseLocDR=$p($g(^DHCEQEquip(rowid)),"^",19)
	.q:(UseLocDR'="")&&(TUseLocDR'=UseLocDR)
	.i TUseLocDR'="" s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	.s vStart=$ZDH(StartDate_"-01",3)
	.s vEnd=$ZDH(EndDate_"-01",3)
	.f ID=vStart:1:vEnd  d
	..;当前月份
	..d ResetVariablesGetCVPAnaly
	..s TMonth=$E($ZD(ID,3),1,7)
	..s TEquip=$p($g(^DHCEQEquip(rowid)),"^",1)
	..s TNo=$p($g(^DHCEQEquip(rowid)),"^",71)
	../// modified by ZY0247 2020-12-22
	..;s Values=..AllInCome(rowid,TMonth,TMonth,"",CTLocID,CurGroupID)
	..s TInCome=+##Class(web.DHCEQ.BA.STATReport).EquipUseContext(rowid,"InCome",TMonth,TMonth)
	..s TConsumableFee=+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"14",TMonth,TMonth)
	..s TFactualWorkLoad=+##Class(web.DHCEQ.BA.STATReport).EquipUseContext(rowid,"Workload",TMonth,TMonth)
	..i TFactualWorkLoad'=0  d
	...//s TCostWorkLoad=##Class(web.DHCEQCommon).FormatNumber(($p(Values,"^",1)+$p(Values,"^",4)-$p(Values,"^",2))/TFactualWorkLoad,"",2)
	...;Modified by JDL JDL0079 优化效率 2011-04-19 
	...;..AllOutFee方法中已经不包含消耗材料费
	...//s AllOutFee=..AllOutFee(rowid,TMonth,TMonth,"",CTLocID,CurGroupID)+..GetGuaranteeFee(rowid,TMonth,TMonth)
	...//i +TCostWorkLoad'=0  d		//Modify By DJ DJ0150
	...//.s TCostWorkLoad=AllOutFee/TCostWorkLoad
	...//s TSafeWorkLoad=TFactualWorkLoad-TCostWorkLoad
	...//i +TCostWorkLoad'=0  d		//Modify By DJ DJ0150
	...//.s TSafeBoundRate=TSafeWorkLoad*100/TFactualWorkLoad
	...s TPrice=##Class(web.DHCEQCommon).FormatNumber(TInCome/TFactualWorkLoad,"",2)
	...s TOutCome=##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"",TMonth,TMonth)
	...i +TPrice'=0  s TCostWorkLoad=TOutCome/TPrice			//czf 2021-01-15  1754410
	...s TSafeWorkLoad=TFactualWorkLoad-TCostWorkLoad
	...i TCostWorkLoad'=0 s TSafeBoundRate=TSafeWorkLoad*100/TFactualWorkLoad
	..d OutputRowGetCVPAnaly
	..s vYear=$E($ZD(ID,3),1,4)
	..s vMonth=$E($ZD(ID,3),6,7)
	..i vMonth=12  d
	...s vYear=vYear+1
	...s vMonth=1
	..e  d
	...s vMonth=vMonth+1
	..s ID=$ZDH(vYear_"-"_vMonth_"-01",3) - 1
	quit
OutputRowGetCVPAnaly
	s TCostWorkLoad=$fn(TCostWorkLoad,"",0)
	s TFactualWorkLoad=$fn(TFactualWorkLoad,"",0)
	s TSafeWorkLoad=$fn(TSafeWorkLoad,"",0)
	s TSafeBoundRate=##Class(web.DHCEQCommon).FormatNumber(TSafeBoundRate,"",2)
	s Data=$lb(TMonth,TEquip,TCostWorkLoad,TFactualWorkLoad,TSafeWorkLoad,TSafeBoundRate,TUseLoc,TNo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetCVPAnaly
	s (TMonth,TEquip,TCostWorkLoad,TFactualWorkLoad,TSafeWorkLoad,TSafeBoundRate,TUseLocDR,TNo)=""
	quit
}

ClassMethod CVPAnalyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CVPAnalyExecute ]
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

Query CVPAnaly(EquipName As %String = "", StartDate As %String = "", EndDate As %String = "", CTLocID As %String = "", CurGroupID As %String = "", UseLocDR As %String = "", EquipID As %String = "") As %Query(ROWSPEC = "TMonth:%String,TEquip:%String,TCostWorkLoad:%String,TFactualWorkLoad:%String,TSafeWorkLoad:%String,TSafeBoundRate:%String,TUseLoc:%String,TNo:%String") [ SqlProc ]
{
}

/******************************************************************/
/// Add By DJ 2010-12-22
/// 描述:动态分析
/// d ##class(%ResultSet).RunQuery("web.DHCEQBenefitAnalyReport","DynamicAnaly","2010-01","2010-12","","1","1")
ClassMethod DynamicAnalyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DynamicAnalyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod DynamicAnalyExecute(ByRef qHandle As %Binary, EquipName As %String = "", StartDate As %String = "", EndDate As %String = "", DCRate As %String = "", CTLocID As %String = "", CurGroupID As %String = "", UseLocDR As %String = "", EquipID As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TInOutTotalFee=0
	d BuildDataGetDynamicAnaly
	Quit $$$OK
BuildDataGetDynamicAnaly
	i DCRate'="" set DCRate=DCRate/100
	i (StartDate="")||(EndDate="") q
	i ($ZDH(StartDate_"-01",3)>$ZDH(EndDate_"-01",3)) q
	/// modified by ZY0247 2020-12-22
	s belrowid=0
	f  s belrowid=$o(^DHCEQBenefitEquipList(belrowid))  quit:belrowid=""  d
	.s Datalist=$g(^DHCEQBenefitEquipList(belrowid))
	.s rowid=$p(Datalist,"^",1)
	.Quit:((EquipID'="")&&(rowid'=EquipID))
	.
	.s InvalidFlag=$p($g(^DHCEQEquip(rowid)),"^",59)
	.q:InvalidFlag="Y"
	.s StockStatus=$p($g(^DHCEQEquip(rowid)),"^",60)
	.q:(StockStatus=0)||(StockStatus=3)
	.s EQStatus=$p($g(^DHCEQEquip(rowid)),"^",38)
	.q:EQStatus'=1
	.s EQName=$p($g(^DHCEQEquip(rowid)),"^",1)
	.q:(EquipName'="")&&(EQName'[EquipName)
	.s TUseLocDR=$p($g(^DHCEQEquip(rowid)),"^",19)
	.q:(UseLocDR'="")&&(TUseLocDR'=UseLocDR)
	.i TUseLocDR'="" s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	.s vStart=$ZDH(StartDate_"-01",3)
	.s vEnd=$ZDH(EndDate_"-01",3)
	.s ISDate=$p($g(^DHCEQEquip(rowid)),"^",45)
	.i ISDate=""  d
	..s EQInStockListDR=$p($g(^DHCEQEquip(rowid)),"^",70)
	..i EQInStockListDR'=""  d
	...s ISDate=$p($g(^DHCEQInStockList(EQInStockListDR)),"^",1)
	...s ISDate=$p($g(^DHCEQInStock(ISDate)),"^",13)
	.s ISDate=$ZD(ISDate,3)
	.s ISDate=$E(ISDate,1,7)
	.f ID=vStart:1:vEnd  d
	..;当前月份
	..d ResetVariablesGetDynamicAnaly
	..s Num=0
	..s Num=Num+1
	..s TMonth=$E($ZD(ID,3),1,7)
	..s TEquip=$p($g(^DHCEQEquip(rowid)),"^",1)
	..set TNo=$p($g(^DHCEQEquip(rowid)),"^",71)
	..s EquipGroupID=##class(web.DHCEQBenefitAnalyReport).CheckGroupEquip(rowid) 
	..//add by zx 2015-10-26 Bug ZX0047
	..i EquipGroupID=0 Set TOriginalFee=$Piece($Get(^DHCEQEquip(rowid)),"^",27)  
	..e  d
	...s GroupListID=0
	...s TOriginalFee=0
	...f  s GroupListID=$o(^DHCEQGroupList(0,"Group",EquipGroupID,GroupListID)) q:GroupListID=""  d
	....s EquipDR=$p($g(^DHCEQGroupList(GroupListID)),"^",2)
	....s TOriginalFee=TOriginalFee+$Piece($Get(^DHCEQEquip(EquipDR)),"^",27)
	..;s TOriginalFee=$p($g(^DHCEQEquip(rowid)),"^",27)
	..///modified by ZY0213
	..;s Values=..AllInCome(rowid,TMonth,TMonth,"",CTLocID,CurGroupID)
	..;s TInCome=$p(Values,"^",1)+$p(Values,"^",4)
	..s TInCome=+##Class(web.DHCEQ.BA.STATReport).EquipUseContext(rowid,"InCome",TMonth,TMonth)
	..;Modified by JDL JDL0079 优化效率 2011-04-19 
	..;..AllOutFee方法中已经不包含消耗材料费,并传递参数不获取折旧
	..;s TOutAmount=..AllOutFee(rowid,TMonth,TMonth,"",CTLocID,CurGroupID,"N")+..GetGuaranteeFee(rowid,TMonth,TMonth)
	..;s TOutAmount=TOutAmount+$p(Values,"^",2)
	..s TOutAmount=+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"",TMonth,TMonth)
	..///end modified by ZY0213
	..
	..i ISDate'=""  d
	...s Years=$E(TMonth,1,4)-$E(ISDate,1,4)
	...s TInOutNetFee=0
	...s TInOutTotalFee=0
	...s TInOutNetFee=((TInCome-TOutAmount)/((1+DCRate)**Years))
	...s TInOutTotalFee=TInOutTotalFee+TInOutNetFee
	...s TNowNetFee=TInOutTotalFee-TOriginalFee
	...i +(TInCome-TOutAmount)>0  d
	....s TDynamicCBTime=TNowNetFee/TInOutNetFee
	....i +TDynamicCBTime<0 s TDynamicCBTime=(0-TDynamicCBTime+Num)/12
	...e  d
	....s TDynamicCBTime=""
	..d OutputRowGetDynamicAnaly
	..s vYear=$E($ZD(ID,3),1,4)
	..s vMonth=$E($ZD(ID,3),6,7)
	..i vMonth=12  d
	...s vYear=vYear+1
	...s vMonth=1
	..e  d
	...s vMonth=vMonth+1
	..s ID=$ZDH(vYear_"-"_vMonth_"-01",3) - 1
	quit
OutputRowGetDynamicAnaly
	s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"",2)
	s TInCome=##Class(web.DHCEQCommon).FormatNumber(TInCome,"",2)
	s TOutAmount=##Class(web.DHCEQCommon).FormatNumber(TOutAmount,"",2)
	s TDCRate=##Class(web.DHCEQCommon).FormatNumber(DCRate*100,"",2)
	s TNowNetFee=##Class(web.DHCEQCommon).FormatNumber(TNowNetFee,"",2)
	s TDynamicCBTime=##Class(web.DHCEQCommon).FormatNumber(TDynamicCBTime,"",2)
	s Data=$lb(TMonth,TEquip,TOriginalFee,TInCome,TOutAmount,TDCRate,TNowNetFee,TDynamicCBTime,TUseLoc,TNo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetDynamicAnaly
	s (TMonth,TEquip,TOriginalFee,TInCome,TOutAmount,TDCRate,TNowNetFee,TDynamicCBTime,TUseLocDR,TNo)=""
	quit
}

ClassMethod DynamicAnalyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DynamicAnalyExecute ]
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

Query DynamicAnaly(EquipName As %String = "", StartDate As %String = "", EndDate As %String = "", DCRate As %String = "", CTLocID As %String = "", CurGroupID As %String = "", UseLocDR As %String = "", EquipID As %String = "") As %Query(ROWSPEC = "TMonth:%String,TEquip:%String,TOriginalFee:%String,TInCome:%String,TOutAmount:%String,TDCRate:%String,TNowNetFee:%String,TDynamicCBTime:%String,TUseLoc:%String,TNo:%String") [ SqlProc ]
{
}

/*****************************************************************/
/// Add By DJ 2010-12-24
/// 描述:内含报酬率
/// w ##Class(web.DHCEQBenefitAnalyReport).IRRRate("826","1","1")
ClassMethod IRRRate(EquipDR, CTLocID As %String = "", CurGroupID As %String = "")
{
	n InterRate,OriginalFee,YearsFee
	s OriginalFee=$p($g(^DHCEQEquip(EquipDR)),"^",27)
	s YearsFee=..GetYearFee(EquipDR,CTLocID,CurGroupID)
	s InterRate=..GetInterRate(OriginalFee,YearsFee)
	q InterRate
}

/******************************************************************/
/// Add By DJ 2010-12-28
/// 描述:决策分析DecisionAnaly
/// d ##class(%ResultSet).RunQuery("web.DHCEQBenefitAnalyReport","DecisionAnaly","痔疮治疗机","","131","85")
ClassMethod DecisionAnalyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DecisionAnalyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod DecisionAnalyExecute(ByRef qHandle As %Binary, EquipName As %String = "", DCRate As %String = "", CTLocID As %String = "", CurGroupID As %String = "", UseLocDR As %String = "", EquipID As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	/// modified by ZY0247 2020-12-22
	d BuildDataGetDecisionAnaly
	Quit $$$OK
BuildDataGetDecisionAnaly
	s belrowid=0
	f  s belrowid=$o(^DHCEQBenefitEquipList(belrowid))  quit:belrowid=""  d
	.s Datalist=$g(^DHCEQBenefitEquipList(belrowid))
	.s rowid=$p(Datalist,"^",1)
	.Quit:((EquipID'="")&&(rowid'=EquipID))
	.s InvalidFlag=$p($g(^DHCEQEquip(rowid)),"^",59)
	.q:InvalidFlag="Y"
	.s StockStatus=$p($g(^DHCEQEquip(rowid)),"^",60)
	.q:(StockStatus=0)||(StockStatus=3)
	.s EQStatus=$p($g(^DHCEQEquip(rowid)),"^",38)
	.q:EQStatus'=1
	.s EQName=$p($g(^DHCEQEquip(rowid)),"^",1)
	.q:(EquipName'="")&&(EQName'[EquipName)
	.s TUseLocDR=$p($g(^DHCEQEquip(rowid)),"^",19)
	.q:(UseLocDR'="")&&(TUseLocDR'=UseLocDR)
	.i TUseLocDR'="" s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	.s ISDate=$p($g(^DHCEQEquip(rowid)),"^",45)
	.i ISDate=""  d
	..s EQInStockListDR=$p($g(^DHCEQEquip(rowid)),"^",70)
	..i EQInStockListDR'=""  d
	...s ISDate=$p($g(^DHCEQInStockList(EQInStockListDR)),"^",1)
	...s ISDate=$p($g(^DHCEQInStock(ISDate)),"^",13)
	.s EQStatus=$p($g(^DHCEQEquip(rowid)),"^",38)
	.i EQStatus'=3  d
	..s NowYear=+$H
	.e  d
	..s NowYear=$p($g(^DHCEQEquip(rowid)),"^",89)
	..i NowYear=""  d
	...&SQL(Select DRL_DisuseRequestDR->DR_AuditDate Into :NowYear From SQLUSER.DHC_EQDisuseRequestList Where DRL_EquipDR=:rowid)
	...i NowYear="" s NowYear=+$H
	.d ResetVariablesGetDecisionAnaly
	.s TEquip=$p($g(^DHCEQEquip(rowid)),"^",1)
	.set TNo=$p($g(^DHCEQEquip(rowid)),"^",71)
	.//add by zx 2015-10-26 BUG ZX0047
	.s EquipGroupID=##class(web.DHCEQBenefitAnalyReport).CheckGroupEquip(rowid) 
	.i EquipGroupID=0 Set TOriginalFee=$Piece($Get(^DHCEQEquip(rowid)),"^",27)  
	.e  d
	..s GroupListID=0
	..s TOriginalFee=0
	..f  s GroupListID=$o(^DHCEQGroupList(0,"Group",EquipGroupID,GroupListID)) q:GroupListID=""  d
	...s EquipDR=$p($g(^DHCEQGroupList(GroupListID)),"^",2)
	...s TOriginalFee=TOriginalFee+$Piece($Get(^DHCEQEquip(EquipDR)),"^",27)
	.;s TOriginalFee=$p($g(^DHCEQEquip(rowid)),"^",27)
	.///modified by ZY0213
	.;s Values=..AllInCome(rowid,"",$E($ZD(NowYear,3),1,7),"",CTLocID,CurGroupID)
	.;s TInCome=$p(Values,"^",1)+$p(Values,"^",4)
	.s TMonth=$E($ZD(NowYear,3),1,7)
	.s TInCome=+##Class(web.DHCEQ.BA.STATReport).EquipUseContext(rowid,"InCome",TMonth,TMonth)
	.
	.;Modified by JDL JDL0079 优化效率 2011-04-19 
	.;..AllOutFee方法中已经不包含消耗材料费,并传递参数不获取折旧
	.;s TOutAmount=..AllOutFee(rowid,$E($ZD(ISDate,3),1,7),$E($ZD(NowYear,3),1,7),"",CTLocID,CurGroupID,"N")
	.;s TOutAmount=TOutAmount+..GetGuaranteeFee(rowid,$E($ZD(ISDate,3),1,7),$E($ZD(NowYear,3),1,7))
	.;s TOutAmount=TOutAmount+$p(Values,"^",2)
	.s TOutAmount=+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"",TMonth,TMonth)
	.//end  modified by ZY0213
	.
	.s TDCRate=DCRate
	.s TUseDate=..GetMonthNum(ISDate,NowYear)
	.s YearsFee=..GetYearFee(rowid,CTLocID,CurGroupID)
	.s TAmountNowNetFee=..GetNowFee(YearsFee,DCRate)-TOriginalFee
	.s TIRRRate=..IRRRate(rowid,CTLocID,CurGroupID)
	.d OutputRowGetDecisionAnaly
	quit
OutputRowGetDecisionAnaly
	S TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"",2)
	S TInCome=##Class(web.DHCEQCommon).FormatNumber(TInCome,"",2)
	S TOutAmount=##Class(web.DHCEQCommon).FormatNumber(TOutAmount,"",2)
	S TDCRate=##Class(web.DHCEQCommon).FormatNumber(TDCRate,"",2)
	S TUseDate=$fn(TUseDate,"",0)
	S TAmountNowNetFee=##Class(web.DHCEQCommon).FormatNumber(TAmountNowNetFee,"",2)
	S TIRRRate=##Class(web.DHCEQCommon).FormatNumber(TIRRRate,"",2)	
	s Data=$lb(TEquip,TOriginalFee,TInCome,TOutAmount,TDCRate,TUseDate,TAmountNowNetFee,TIRRRate,TUseLoc,TNo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetDecisionAnaly
	s (TEquip,TOriginalFee,TInCome,TOutAmount,TDCRate,TUseDate,TAmountNowNetFee,TIRRRate,TUseLocDR,TNo)=""
	quit
}

ClassMethod DecisionAnalyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DecisionAnalyExecute ]
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

Query DecisionAnaly(EquipName As %String = "", DCRate As %String = "", CTLocID As %String = "", CurGroupID As %String = "", UseLocDR As %String = "", EquipID As %String = "") As %Query(ROWSPEC = "TEquip:%String,TOriginalFee:%String,TInCome:%String,TOutAmount:%String,TDCRate:%String,TUseDate:%String,TAmountNowNetFee:%String,TIRRRate:%String,TUseLoc:%String,TNo:%String") [ SqlProc ]
{
}

/******************************************************************/
ClassMethod Abs(expression As %String) As %String [ Language = basic ]
{
	Return Abs(expression)
}

/******************************************************************/
/// Add By JDL 2010-12-28
/// 描述:获取设备每年净收入
/// 	w ##Class(web.DHCEQBenefitAnalyReport).GetYearFee("826","1","1")
ClassMethod GetYearFee(EquipDR, CTLocID As %String = "", CurGroupID As %String = "")
{
	i EquipDR="" q ""
	s YearsFee=""
	s ISDate=$p($g(^DHCEQEquip(EquipDR)),"^",45)
	s EQOriginalFee=$p($g(^DHCEQEquip(EquipDR)),"^",27)
	s NetNowFee=0
	i ISDate'=""  d
	.s ISDate=$ZD(ISDate,3)
	e  d
	.s EQInStockListDR=$p($g(^DHCEQEquip(EquipDR)),"^",70)
	.i EQInStockListDR'=""  d
	..s ISDate=$p($g(^DHCEQInStockList(EQInStockListDR)),"^",1)
	..s ISDate=$p($g(^DHCEQInStock(ISDate)),"^",13)
	i ISDate="" q ""
	s ISDate=$E(ISDate,1,7)
	s Years=$E(ISDate,1,4)
	s EQStatus=$p($g(^DHCEQEquip(EquipDR)),"^",38)
	i EQStatus'=3  d
	.s NowYear=$E($ZD(+$H,3),1,4)
	e  d
	.s NowYear=$p($g(^DHCEQEquip(EquipDR)),"^",89)
	.i NowYear=""  d
	..&SQL(Select DRL_DisuseRequestDR->DR_AuditDate Into :NowYear From SQLUSER.DHC_EQDisuseRequestList Where DRL_EquipDR=:EquipDR)
	..i NowYear="" s NowYear=+$H
	.s NowYear=$E($ZD(NowYear,3),1,4)
	
	f CurYear=Years:1:NowYear  d
	.s Values=##Class(web.DHCEQBenefitAnalyReport).AllInCome(EquipDR,CurYear_"-01",CurYear_"-12","",CTLocID,CurGroupID)
	.s InCome=$p(Values,"^",1)+$p(Values,"^",4)
	.
	.;Modified by JDL JDL0079 优化效率 2011-04-19 
	.;..AllOutFee方法中已经不包含消耗材料费,并传递参数不获取折旧
	.s OutAmount=$p(Values,"^",2)
	.s OutAmount=OutAmount+##Class(web.DHCEQBenefitAnalyReport).AllOutFee(EquipDR,CurYear_"-01",CurYear_"-12","",CTLocID,CurGroupID,"N")
	.s OutAmount=OutAmount+##Class(web.DHCEQBenefitAnalyReport).GetGuaranteeFee(EquipDR,CurYear_"-01",CurYear_"-12")
	.
	.i YearsFee'="" s YearsFee=YearsFee_"^"
	.s YearsFee=YearsFee_(InCome-OutAmount)
	.;s NetNowFee=NetNowFee+((InCome-OutAmount)/((1+DCRate)**(CurYear-Years)))
	
	q YearsFee
}

/// Add by JDL 2010-12-28
/// 获取内涵报酬率
/// 传入参数：OriginalFee：投资额/原值
/// 			 YearsFee：各年净收入   各年收入之间以"^"分割
/// 返回值：0：无法计算
/// 			内涵报酬率
/// 	w ##Class(web.DHCEQBenefitAnalyReport).GetInterRate(3123.33,"1000^1500^2000")
ClassMethod GetInterRate(OriginalFee, YearsFee)
{
	n NowFee,MaxNowFee,MinRate,MaxRate,InterRate
	;投资额为零无法计算	
	if +OriginalFee'>0 q 0
	s NowFee=..GetNowFee(YearsFee,0)
	;收入不大于零无法计算
	if NowFee'>0 q 0
	;第一年收入就大于等于投资 无法计算
	if +YearsFee>=OriginalFee q 0
	;收入大于 投资额 则内含报酬率在正值区间，反之在负值区间	
	if NowFee>OriginalFee
	{
		s MinRate=0
		s MaxRate=50
	}
	else
	{
		s MinRate=-99
		s MaxRate=0
	}
	
	s InterRate=""
	
	;最多试算50次,如果尚未算出则不再计算
	f i=0:1:100 q:(InterRate'="")  d
	.s NowFee=..GetNowFee(YearsFee,MinRate)
	.s MaxNowFee=..GetNowFee(YearsFee,MaxRate)
	.i OriginalFee=NowFee s InterRate=MinRate
	.i OriginalFee=MaxNowFee s InterRate=MaxRate
	.i MaxNowFee>OriginalFee  d
	..s MinRate=MaxRate
	..s MaxRate=MaxRate*2
	.;如果最小率都不可以，则退出
	.i NowFee<OriginalFee s InterRate=0
	.i (OriginalFee>MaxNowFee)&&(OriginalFee<NowFee)  d
	..s NowFee=..GetNowFee(YearsFee,((MaxRate+MinRate)/2))
	..i NowFee=OriginalFee s InterRate=((MaxRate+MinRate)/2)
	..i NowFee>OriginalFee s MinRate=((MaxRate+MinRate)/2)
	..i NowFee<OriginalFee s MaxRate=((MaxRate+MinRate)/2)
	.i (##Class(web.DHCEQCommon).FormatNumber(MinRate,"",2)=##Class(web.DHCEQCommon).FormatNumber(MaxRate,"",2)) s InterRate=((MaxRate+MinRate)/2)
	q InterRate
}

/// Add by JDL 2010-12-28
/// 获取累计现值
/// 入参：YearsFee：各年净收入   各年收入之间以"^"分割
/// 		 Rate：折现率 值为百分率	
/// 返回值：累计现值
/// 	w ##Class(web.DHCEQBenefitAnalyReport).GetNowFee("0^0^0^0^0^0^0^0^0^0^0^0^0^0^110211.14^2381.5","6")
ClassMethod GetNowFee(YearsFee, Rate)
{
	n NowFee,YearsNum,i
	s NowFee=0
	i YearsFee="" q 0
	i Rate="" q 0
	s Rate=Rate/100
	s YearsNum=1+$l(YearsFee,"^")
	f i=1:1:YearsNum  d
	.s NowFee=NowFee+($p(YearsFee,"^",i)/((1+Rate)**(i-1)))
	q NowFee
}

/// Mozy0037	2010-12-22
/// 描述：收益分析表
/// 访问表:
/// 输入：EquipNo, EquipName, UseLocDR, ConditionStartDate, ConditionEndDate, CTLocID, CurGroupID
/// 输出：无
/// 返回：成功返回数据列表
/// 备注：
/// d ##class(%ResultSet).RunQuery("web.DHCEQBenefitAnalyReport","BenfitAnalyReport","","","","2010-9","","1","1")
Query BenfitAnalyReport(EquipNo, EquipName, UseLocDR, ConditionStartDate, ConditionEndDate, CTLocID As %String = "", CurGroupID As %String = "", EquipID As %String = "") As %Query(ROWSPEC = "LebDate:%String,InCome:%String,TotalInCome:%String,OutFee:%String,TotalOutFee:%String,ProfitFee:%String,TotalProfitFee:%String,ProfitFeeRate:%String,TotalProfitFeeRate:%String") [ SqlProc ]
{
}

ClassMethod BenfitAnalyReportExecute(ByRef qHandle As %Binary, EquipNo, EquipName, UseLocDR, ConditionStartDate, ConditionEndDate, CTLocID, CurGroupID, EquipID As %String = "") As %Status
{
	new repid, index, rowid
	New LebDate,InCome,TotalInCome,OutFee,TotalOutFee,ProfitFee,TotalProfitFee,ProfitFeeRate,TotalProfitFeeRate
	New tmpDate,tmpData
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set rowid=0
	i (ConditionStartDate="")||(ConditionEndDate="") Quit $$$OK
	Kill ^TempDHCEQ("EquipOutDetailFee",$J)
	Set TotalInCome=0
	Set TotalOutFee=0
	
	Set TotalProfitFee=0
	;设置默认查询日期(年-月)
	If ConditionStartDate="" Set ConditionStartDate=$Piece($ZD($H,3),"-",1)_"-01"
	Set tmpDate= ##class(web.DHCEQReport).GetReportDate(ConditionStartDate,"1")
	Set StartDate=$ZDH(tmpDate,4)
	If ConditionEndDate="" Do
	.Set ConditionEndDate=$ZD($H,3)
	.Set ConditionEndDate=$Piece(ConditionEndDate,"-",1,2)	;2010-12
	Set EndDate= ##class(web.DHCEQReport).GetReportDate(ConditionEndDate,"1")
	Set EndDate=$ZDH(EndDate,4)
	
	While (StartDate'>EndDate)
	{
		Do ResetVariablesBenfitAnalyReport
		Set InCome=0
		Set OutFee=0
		
		
		Set LebDate=$Piece($ZD(StartDate,3),"-",1,2)
		/// modified by ZY0247 2020-12-22
		Set rowid=0
		For  Set rowid=$Order(^DHCEQBenefitEquipList(rowid)) Quit:rowid=""  Do
		.s Datalist=$g(^DHCEQBenefitEquipList(rowid))
		.s EquipDR=$p(Datalist,"^",1)		//czf 2021-01-15 begin 1754417
		.Quit:((EquipID'="")&&(EquipDR'=EquipID))
		.Set TRowID = EquipDR			//czf 2021-01-15 end 1754417
		.;Quit:##Class(web.DHCEQBenefitAnalyReport).CheckEquipID(TRowID)=0
		.Set TEquipName=$Piece($Get(^DHCEQEquip(TRowID)),"^",1)
		.Quit:((TEquipName'="")&&(TEquipName'[EquipName))
		.Set TUseLocDR=$Piece($Get(^DHCEQEquip(TRowID)),"^",19)
		.Quit:((UseLocDR'="")&&(TUseLocDR'=UseLocDR))
		.Set Status=$Piece($Get(^DHCEQEquip(TRowID)),"^",38)
		.Quit:(Status'=1)
		.Set InvalidFlag=$Piece($Get(^DHCEQEquip(TRowID)),"^",59)
		.Quit:(InvalidFlag="Y")
		.Set StockStatus=$Piece($Get(^DHCEQEquip(TRowID)),"^",60)
		.Quit:((StockStatus=0)||(StockStatus=3))
		.Set TEquipNo=$Piece($Get(^DHCEQEquip(TRowID)),"^",71)
		.Quit:((EquipNo'="")&&(TEquipNo'=EquipNo))
		./// modified by ZY0247 2020-12-22
		.;Set tmpData=##Class(web.DHCEQBenefitAnalyReport).AllInCome(TRowID,LebDate,LebDate,"",CTLocID,CurGroupID) //单期收入
		.;Set InCome=$Piece(tmpData,"^",1)+InCome+$Piece(tmpData,"^",4)
		.s InCome=InCome+##Class(web.DHCEQ.BA.STATReport).EquipUseContext(TRowID,"InCome",LebDate,LebDate)		//Modify By DJ 2021-06-16 DJ0193
		.;Modified by JDL JDL0079 优化效率 2011-04-19 
		.;获取消耗材料费用
		.Set ConsumableFee=+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(TRowID,"14",LebDate,LebDate)
		.;Set tmpData=##Class(web.DHCEQBenefitAnalyReport).AllOutFee(TRowID,LebDate,LebDate,"",CTLocID,CurGroupID) //单期支出
		.;Set tmpData=##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(TRowID,"",LebDate,LebDate) //单期支出
		.;Set tmpData=ConsumableFee+tmpData+##Class(web.DHCEQBenefitAnalyReport).GetGuaranteeFee(TRowID,LebDate,LebDate)
		.Set OutFee=OutFee+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(TRowID,"",LebDate,LebDate)		//Modify By DJ 2021-06-16 DJ0193
		
		Set TotalInCome=TotalInCome+InCome
		Set TotalOutFee=TotalOutFee+OutFee
		Set ProfitFee=InCome-OutFee			//单期利润
		Set TotalProfitFee=TotalInCome-TotalOutFee
		
		If InCome'=0 Do
		.Set ProfitFeeRate=ProfitFee/InCome	//单期利润率
		Else  Do
		.Set ProfitFeeRate=0
		Set ProfitFeeRate=##Class(web.DHCEQCommon).FormatNumber(ProfitFeeRate*100,"",2)
		
		If TotalInCome'=0 Do
		.Set TotalProfitFeeRate=TotalProfitFee/TotalInCome	//单期利润率
		Else  Do
		.Set TotalProfitFeeRate=0
		Set TotalProfitFeeRate=##Class(web.DHCEQCommon).FormatNumber(TotalProfitFeeRate*100,"",2)
		
		Do OutputRowBenfitAnalyReport
		Set tmpDate=##class(web.DHCEQCommon).DateAdd("M",1,tmpDate) 	;$ZD($H,4)
		s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(tmpDate,"date")
	}
	
	Quit $$$OK
ResetVariablesBenfitAnalyReport
	Set (LebDate,InCome,OutFee,ProfitFee,ProfitFeeRate)=""
	Quit
OutputRowBenfitAnalyReport
	Set InCome=##Class(web.DHCEQCommon).FormatNumber(InCome,"",2)
	Set TotalInCome=##Class(web.DHCEQCommon).FormatNumber(TotalInCome,"",2)
	Set OutFee=##Class(web.DHCEQCommon).FormatNumber(OutFee,"",2)
	Set TotalOutFee=##Class(web.DHCEQCommon).FormatNumber(TotalOutFee,"",2)
	Set ProfitFee=##Class(web.DHCEQCommon).FormatNumber(ProfitFee,"",2)
	Set TotalProfitFee=##Class(web.DHCEQCommon).FormatNumber(TotalProfitFee,"",2)
	Set Data=$lb(LebDate,InCome,TotalInCome,OutFee,TotalOutFee,ProfitFee,TotalProfitFee,ProfitFeeRate,TotalProfitFeeRate)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
}

ClassMethod BenfitAnalyReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BenfitAnalyReportExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$Order(^CacheTemp(repid,ind))
	If ind=""
	{
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
	 	Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)

	Quit $$$OK
}

ClassMethod BenfitAnalyReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BenfitAnalyReportExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

///  Mozy0037	2010-12-27
///  描述：投资效益分析表
///  访问表:EquipNo, EquipName, UseLocDR, ConditionStartDate, ConditionEndDate, CTLocID, CurGroupID
///  输出：无
///  返回：成功返回数据列表
///  备注：设备名称, 投资额=原值
///  		投资收益率=累计利润/原值, 回收期=原值/累计利润
///  d ##class(%ResultSet).RunQuery("web.DHCEQBenefitAnalyReport","InvestBenefitAnalyReport","","","","2013-04","2013-05","410","90","")
Query InvestBenefitAnalyReport(EquipNo, EquipName, UseLocDR, ConditionStartDate, ConditionEndDate, CTLocID As %String = "", CurGroupID As %String = "", EquipID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEquipName:%String,TOriginalFee:%String,TInvestBenefitRate:%String,TPaybackTime:%String,TInCome:%String,TOutFee:%String,TUseLoc:%String,TNo:%String") [ SqlProc ]
{
}

ClassMethod InvestBenefitAnalyReportExecute(ByRef qHandle As %Binary, EquipNo, EquipName, UseLocDR, ConditionStartDate, ConditionEndDate, CTLocID, CurGroupID, EquipID As %String = "") As %Status
{
	new repid, index, rowid, interval, start, end
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set rowid=0
	i (ConditionStartDate="")||(ConditionEndDate="") Quit $$$OK
	Kill ^TempDHCEQ("EquipOutDetailFee",$J)
	
	;设置默认查询日期(年-月)
	If ConditionStartDate="" Set ConditionStartDate=$Piece($ZD($H,3),"-",1)_"-01"
	If ConditionEndDate="" Do
	.Set ConditionEndDate=$ZD($H,3)
	.Set ConditionEndDate=$Piece(ConditionEndDate,"-",1,2)	;2010-12
	;查询的间隔月数的年份比例
	Set start=$Piece(ConditionStartDate,"-",2)_"/01/"_$Piece(ConditionStartDate,"-",1)
	Set end=$Piece(ConditionEndDate,"-",2)_"/01/"_$Piece(ConditionEndDate,"-",1)
	Set interval=##Class(web.DHCEQCommon).DateDiff("m",start,end)+1
	Set interval=interval/12
	/// modified by ZY0247 2020-12-22
	s belrowid=0
	f  s belrowid=$o(^DHCEQBenefitEquipList(belrowid))  quit:belrowid=""  d
	.s Datalist=$g(^DHCEQBenefitEquipList(belrowid))
	.s rowid=$p(Datalist,"^",1)
	.Do ResetVariablesInvestBenefitAnalyReport
	.q:(EquipID'="")&&(rowid'=EquipID)
	.s EquipGroupID=##class(web.DHCEQBenefitAnalyReport).CheckGroupEquip(rowid) //add by zx 2015-10-27 BUG ZX0047
	.set TNo=$p($g(^DHCEQEquip(rowid)),"^",71)
	.s TRowID=rowid
	.;Quit:##Class(web.DHCEQBenefitAnalyReport).CheckEquipID(TRowID)=0
	.Set TEquipName=$Piece($Get(^DHCEQEquip(rowid)),"^",1)
	.Quit:((TEquipName'="")&&(TEquipName'[EquipName))
	.Set TUseLocDR=$Piece($Get(^DHCEQEquip(rowid)),"^",19)
	.Quit:((UseLocDR'="")&&(TUseLocDR'=UseLocDR))
	.i TUseLocDR'="" s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	.////add by zx 2015-10-26 BUG ZX0047
	.i EquipGroupID=0 Set TOriginalFee=$Piece($Get(^DHCEQEquip(rowid)),"^",27)  //add by zx 2015-10-26
	.e  d
	..s GroupListID=0
	..s TOriginalFee=0
	..f  s GroupListID=$o(^DHCEQGroupList(0,"Group",EquipGroupID,GroupListID)) q:GroupListID=""  d
	...s EquipDR=$p($g(^DHCEQGroupList(GroupListID)),"^",2)
	...s TOriginalFee=TOriginalFee+$Piece($Get(^DHCEQEquip(EquipDR)),"^",27)
	.Set Status=$Piece($Get(^DHCEQEquip(rowid)),"^",38)
	.Quit:(Status'=1)
	.Set InvalidFlag=$Piece($Get(^DHCEQEquip(rowid)),"^",59)
	.Quit:(InvalidFlag="Y")
	.Set StockStatus=$Piece($Get(^DHCEQEquip(rowid)),"^",60)
	.Quit:((StockStatus=0)||(StockStatus=3))
	.Set TEquipNo=$Piece($Get(^DHCEQEquip(rowid)),"^",71)
	.Quit:((EquipNo'="")&&(TEquipNo'=EquipNo))
	.///modified by ZY0213
	.;Set TInCome=##Class(web.DHCEQBenefitAnalyReport).AllInCome(TRowID,ConditionStartDate,ConditionEndDate,"",CTLocID,CurGroupID) //收入
	.;Set TOutFee=+##Class(web.DHCEQBenefitAnalyReport).AllOutFee(TRowID,ConditionStartDate,ConditionEndDate,"",CTLocID,CurGroupID) //支出
	.;Modified by JDL JDL0079 优化效率 2011-04-19 
	.;获取消耗材料费用
	.;Set TOutFee=TOutFee+$p(TInCome,"^",2)
	.;Set TInCome=$p(TInCome,"^",1)+$p(TInCome,"^",4)
	.
	.;Set TOutFee=+TOutFee+##Class(web.DHCEQBenefitAnalyReport).GetGuaranteeFee(TRowID,ConditionStartDate,ConditionEndDate)
	.s TInCome=##Class(web.DHCEQ.BA.STATReport).EquipUseContext(rowid,"InCome",ConditionStartDate,ConditionEndDate)
	.s TOutFee=##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"",ConditionStartDate,ConditionEndDate)
	.
	.If ((TInCome-TOutFee)>0)&&(TOriginalFee>0) Set TInvestBenefitRate=(((TInCome-TOutFee)/interval)/TOriginalFee)*100	; 投资收益率
	.If TInvestBenefitRate'="" Set TPaybackTime=100/TInvestBenefitRate
	.
	.Do OutputRowInvestBenefitAnalyReport

	Quit $$$OK
ResetVariablesInvestBenefitAnalyReport
	Set (TRowID,TEquipName,TOriginalFee,TInvestBenefitRate,TPaybackTime,TInCome,TOutFee,TUseLocDR,TNo)=""
	Quit
OutputRowInvestBenefitAnalyReport
	Set TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"",2)
	Set TInvestBenefitRate=##Class(web.DHCEQCommon).FormatNumber(TInvestBenefitRate,"",2)
	Set TPaybackTime=##Class(web.DHCEQCommon).FormatNumber(TPaybackTime,"",2)
	Set TInCome=##Class(web.DHCEQCommon).FormatNumber(TInCome,"",2)
	Set TOutFee=##Class(web.DHCEQCommon).FormatNumber(TOutFee,"",2)
	Set Data=$lb(TRowID,TEquipName,TOriginalFee,TInvestBenefitRate,TPaybackTime,TInCome,TOutFee,TUseLoc,TNo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
}

ClassMethod InvestBenefitAnalyReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = InvestBenefitAnalyReportExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$Order(^CacheTemp(repid,ind))
	If ind=""
	{
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
	 	Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)

	Quit $$$OK
}

ClassMethod InvestBenefitAnalyReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = InvestBenefitAnalyReportExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Modified by JDL JDL0079 优化效率 2011-04-19
/// 根据声明周期信息,获取支出费用
/// 入参：EquipDR	要获取费用的设备
/// 		 StartDate	费用开始日期
/// 		 EndDate	费用结束日期
/// 		 SourceType	费用类型  31:维修、32保养、33检查、35折旧
/// 		 QXType		权限类型,和CTLocID，CurGroupID一起控制可访问范围
/// 		 CTLocID	当前科室
/// 		 CurGroupID	当前安全组
/// 	返回：该设备该日期段支出该项费用
ClassMethod GetOutFeeByLifeInfo(EquipDR As %String = "", StartDate As %String = "", EndDate As %String = "", SourceType As %String = "", QXType As %String = "", CTLocID As %String = "", CurGroupID As %String = "")
{
	n Start,End,LIRowID,Find,ToStoreLoc,Amount,Month	//czf 2021-01-28 1754433
	i EquipDR=""  q ""
	i SourceType="" q ""
	s Start=..StartDate(StartDate)
	s End=..EndDate(EndDate)
	i CTLocID'="" s CTLocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",CTLocID)    //Modefied by zc0050  2019-10-19  CTLocID取值对应DHCEQCDepartment表中的值
	s Amount=0
	//add by zx 2015-10-21 判断机组,取机组整体折旧等费用 Bug ZX0047
	s EquipGroupID=##class(web.DHCEQBenefitAnalyReport).CheckGroupEquip(EquipDR)  //27834
	;^DHCEQLifeInfo(0,"EquipSourceDate",{LI_EquipDR},{LI_SourceType},{LI_ChangeDate},{LI_RowID})
	i EquipGroupID=0 d
	.f  s Start=$o(^DHCEQLifeInfo(0,"EquipSourceDate",EquipDR,SourceType,Start)) q:(Start="")||(Start>End)  d
	..s LIRowID=0
	..f  s LIRowID=$o(^DHCEQLifeInfo(0,"EquipSourceDate",EquipDR,SourceType,Start,LIRowID))  q:LIRowID=""  d
	...s Find=0 //2010-10-29 DJ begin
	...s ToStoreLoc=$p($g(^DHCEQLifeInfo(LIRowID)),"^",10)
	...i ToStoreLoc'=""  d
	....i CTLocID'="" s Find=##class(web.DHCEQCommon).LocIsInEQ(QXType,ToStoreLoc,CTLocID,CurGroupID)	//czf 2021-01-28 执行任务时不需要过滤当前科室权限 1754433
	...q:Find'=0 //2010-10-29 DJ end
	...s Amount=Amount+$p($g(^DHCEQLifeInfo(LIRowID)),"^",17)	;Fee
	else  d
	.s GroupListID=0
	.f  s GroupListID=$o(^DHCEQGroupList(0,"Group",EquipGroupID,GroupListID)) q:GroupListID=""  d
	..s EquipDR=$p($g(^DHCEQGroupList(GroupListID)),"^",2)
	..s rate=$p($g(^DHCEQGroupList(GroupListID)),"^",9)
	..s Start=..StartDate(StartDate)
	..s End=..EndDate(EndDate)
	..f  s Start=$o(^DHCEQLifeInfo(0,"EquipSourceDate",EquipDR,SourceType,Start)) q:(Start="")||(Start>End)  d
	...s LIRowID=0
	...f  s LIRowID=$o(^DHCEQLifeInfo(0,"EquipSourceDate",EquipDR,SourceType,Start,LIRowID))  q:LIRowID=""  d
	....s Find=0 //2010-10-29 DJ begin
	....s ToStoreLoc=$p($g(^DHCEQLifeInfo(LIRowID)),"^",10)
	....i ToStoreLoc'=""  d
	.....i CTLocID'="" s Find=##class(web.DHCEQCommon).LocIsInEQ(QXType,ToStoreLoc,CTLocID,CurGroupID)	//czf 2021-01-28 执行任务时不需要过滤当前科室权限 1754433
	....q:Find'=0 //2010-10-29 DJ end
	....;w $p($g(^DHCEQLifeInfo(LIRowID)),"^",17)_"^"_EquipDR,!
	....s Amount=Amount+($p($g(^DHCEQLifeInfo(LIRowID)),"^",17)*rate/100)	;Fee	//modified by ZY0269 20210615
	
	//add by zy 2014-09-15  ZY0117
	//折旧费用这块,如果生命周期中取不到费用,直接到折旧明细中取数据.  （廊坊管道局折旧是导入的，写在折旧明细表中。）
	//modified by zy 2014-9-18
	i (Amount=0)&(SourceType="35")
	{
		s Start=..StartDate(StartDate)
		s Amount=0
		s Month=0
		f  s Month=$o(^DHCEQMonthDepre(0,"EquipMonth",EquipDR,Month))  q:Month=""  d
		.s CurDate=$ZDH(Month_"-01",3)
		.q:(Start>CurDate)||(End<CurDate)
		.s MonthDepreID=0
		.f  s MonthDepreID=$o(^DHCEQMonthDepre(0,"EquipMonth",EquipDR,Month,MonthDepreID))  q:MonthDepreID=""  d
		..s MonthDepre=$g(^DHCEQMonthDepre(MonthDepreID))
		..q:$p(MonthDepre,"^",3)'="Y"
		..s MDStatus=$p($g(^DHCEQMonthDepre(MonthDepreID)),"^",20)	//DJ0136
		..q:MDStatus="3"
		..s Amount=Amount+$p(MonthDepre,"^",14)	;Fee
	}
	q Amount
}

/// 新增：2009-09-07 ZY 
/// 描述：入库单设备来源类型使用下拉列表控件
///  d ##class(%ResultSet).RunQuery("web.DHCEQBenefitAnalyReport","GetBenefitEquip","","","243")
Query GetBenefitEquip(Equip, UseLocID As %Library.String = "", CurGroupID As %Library.String = "") As %Query(ROWSPEC = "TName:%String,TRowID:%String,TUseLoc:%String,TNo:%String") [ SqlProc ]
{
}

ClassMethod GetBenefitEquipExecute(ByRef qHandle As %Binary, Equip, UseLocID As %Library.String = "", CurGroupID As %Library.String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s Equip=$ZCONVERT(Equip,"U")
	s Code=0
	f  s Code=$o(^DHCEQEquip(0,"Code",Code))  quit:Code=""  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQEquip(0,"Code",Code,rowid))  quit:rowid=""  d
	..d ResetVariablesGetBenefitEquip
	..Quit:##Class(web.DHCEQBenefitAnalyReport).CheckEquipID(rowid)=0
	..Quit:$p($g(^DHCEQEquip(rowid)),"^",59)'="N"
	..s TRowID=rowid
	..s TName = $p($g(^DHCEQEquip(rowid)),"^",1)
	..s TCode = Code
	..s TDesc = $p($g(^DHCEQEquip(rowid)),"^",7)
	..s TLeaveFactoryNo = $p($g(^DHCEQEquip(rowid)),"^",10)
	..s TMemoryCode = $p($g(^DHCEQEquip(rowid)),"^",61)
	..s TNo = $p($g(^DHCEQEquip(rowid)),"^",71)
	..quit:(Equip'="")&&(($ZCONVERT(TName,"U")'[Equip)&($ZCONVERT(TLeaveFactoryNo,"U")'[Equip)&(TRowID'=Equip)&($ZCONVERT(TMemoryCode,"U")'[Equip)&($ZCONVERT(TNo,"U")'[Equip)&($ZCONVERT(TCode,"U")'[Equip))
	..
	..s TEquipType=$p($g(^DHCEQEquip(rowid)),"^",63)
	..quit:(TEquipType'="")&&("1"=..EquipTypeIsIn(TEquipType,CurGroupID))
	..s TStatus = $p($g(^DHCEQEquip(rowid)),"^",38)
	..quit:(TStatus="2")||(TStatus="3")
	..s TUseLocDR = $p($g(^DHCEQEquip(rowid)),"^",19)
	..quit:(UseLocID'="")&&(TUseLocDR'=UseLocID)
	..i TUseLocDR'="" s TUseLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	..d OutputRowGetBenefitEquip
	Quit $$$OK
OutputRowGetBenefitEquip
	s Data=$lb(TName,TRowID,TUseLoc,TNo)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetBenefitEquip
	s (TRowID,TName,TCode,TDesc,TLeaveFactoryNo,TMemoryCode,TNo,TEquipType,TStatus,TUseLocDR,TUseLoc)=""
	quit
}

ClassMethod GetBenefitEquipFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBenefitEquipExecute ]
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

ClassMethod GetBenefitEquipClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBenefitEquipExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Modified by ZY  成本分开显示 2011-06-08
/// 1.取消获取耗材费用,因在AllIncome方法中已经获取
/// 2.			Value1,001,公用成本;
///   			Value2,002,管理成本;
/// 			Value3,003,医辅成本;
/// 			Value4,004,直接成本(不能直接计入设备的成本);
/// ----------------------------------------------------------------------
/// w ##Class(web.DHCEQBenefitAnalyReport).AllOutFeeList("11253","2011-04","2011-04","","1","1")
ClassMethod AllOutFeeList(EquipDR As %String = "", StartDate As %String = "", EndDate As %String = "", QXType As %String = "", CTLocID As %String = "", CurGroupID As %String = "", IncludeDepreFlag As %String = "Y")
{
	new AllOutFee,Value1,Value2,Value3,Value4,Person,DepreFee
	s AllOutFee=""
	i (EquipDR="")||(StartDate="")||(EndDate="")  q ""
	s (Value1,Value2,Value3,Value4,Person,DepreFee)=0
	s Value1=+..EquipResourceFee(EquipDR,StartDate,EndDate,QXType,"001",CTLocID,CurGroupID)
	s Value2=+..EquipResourceFee(EquipDR,StartDate,EndDate,QXType,"002",CTLocID,CurGroupID)
	s Value3=+..EquipResourceFee(EquipDR,StartDate,EndDate,QXType,"003",CTLocID,CurGroupID)
	s Value4=+..EquipResourceFee(EquipDR,StartDate,EndDate,QXType,"004",CTLocID,CurGroupID)
	s Person=+..EquipResourceFee(EquipDR,StartDate,EndDate,QXType,"03",CTLocID,CurGroupID)
	s DepreFee=+..EquipDepreFee(EquipDR,StartDate,EndDate)
	s MaintFee=+..EquipResourceFee(EquipDR,StartDate,EndDate,QXType,"05",CTLocID,CurGroupID)
		
	s AllOutFee=Value1_"^"_Value2_"^"_Value3_"^"_Value4_"^"_Person_"^"_DepreFee_"^"_MaintFee
	q AllOutFee
}

/******************************************************************/
/// Add By DJ 2010-12-22  11253
/// 描述:本量力分析--CostVolumeProfitAnaly
/// d ##class(%ResultSet).RunQuery("web.DHCEQBenefitAnalyReport","CVPAnalyNew","","62150","62220","","")
Query CVPAnalyNew(EquipDR As %String = "", StartDate As %String = "", EndDate As %String = "", CTLocID As %String = "", CurGroupID As %String = "", UseLocDR As %String = "") As %Query(ROWSPEC = "TMonth:%String,TEquipDR:%String,TEquip:%String,TNo:%String,TFactualWorkLoad:%String,TInCome:%String,TConsumableFee:%String,TCostWorkLoad:%String,TGYCost:%String,TGLCost:%String,TYFCost:%String,TZJCost:%String,TPersonFee:%String,TDepreFee:%String,TOutCome:%String,TPrice:%String,TSafeWorkLoad:%String,TSafeBoundRate:%String,TOriginalFee:%String,TPaybackTime:%String,TNetFee:%String,TLoc:%String,TMaintFee:%String,TJob:%String") [ SqlProc ]
{
}

ClassMethod CVPAnalyNewExecute(ByRef qHandle As %Binary, EquipDR As %String = "", StartDate As %String = "", EndDate As %String = "", CTLocID As %String = "", CurGroupID As %String = "", UseLocDR As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	
	i (StartDate="")||(EndDate="") Quit $$$OK
	i StartDate>EndDate Quit $$$OK
	s StartDate=$E($ZD(StartDate,3),1,7)
	s EndDate=$E($ZD(EndDate,3),1,7)
	s TJob=$j
	
	k ^TempDHCEQ("CVPAnalyNew")
	
	/// modified by ZY0247 2020-12-22
	s belrowid=0
	f  s belrowid=$o(^DHCEQBenefitEquipList(belrowid))  quit:belrowid=""  d
	.s Datalist=$g(^DHCEQBenefitEquipList(belrowid))
	.s rowid=$p(Datalist,"^",1)
	.Quit:((EquipDR'="")&&(rowid'=EquipDR))
	.
	.s InvalidFlag=$p($g(^DHCEQEquip(rowid)),"^",59)
	.q:InvalidFlag="Y"
	.s StockStatus=$p($g(^DHCEQEquip(rowid)),"^",60)
	.q:(StockStatus=0)||(StockStatus=3)
	.s EQName=$p($g(^DHCEQEquip(rowid)),"^",1)
	.s TUseLocDR=$p($g(^DHCEQEquip(rowid)),"^",19)
	.q:(UseLocDR'="")&&(TUseLocDR'=UseLocDR)
	.i TUseLocDR'="" s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	.s vStart=$ZDH(StartDate_"-01",3)
	.s vEnd=$ZDH(EndDate_"-01",3)
	.s TOriginalFee=$p($g(^DHCEQEquip(rowid)),"^",27)
	.f ID=vStart:1:vEnd  d
	..;当前月份
	..d ResetVariablesGetCVPAnalyNew
	..s TMonth=$E($ZD(ID,3),1,7)
	..s TEquipDR=rowid
	..s TEquip=$p($g(^DHCEQEquip(rowid)),"^",1)
	..s TNo=$p($g(^DHCEQEquip(rowid)),"^",71)
	..///modified by ZY0213
	..//s Values=..AllInCome(rowid,TMonth,TMonth,"",CTLocID,CurGroupID)
	..//s TFactualWorkLoad=+$p(Values,"^",3)
	..s TFactualWorkLoad=+##Class(web.DHCEQ.BA.STATReport).EquipUseContext(rowid,"Workload",TMonth,TMonth)
	..//s TInCome=$p(Values,"^",1)+$p(Values,"^",4)
	..s TInCome=+##Class(web.DHCEQ.BA.STATReport).EquipUseContext(rowid,"InCome",TMonth,TMonth)
	..//s TConsumableFee=0
	..//i $p(Values,"^",2)>0 s TConsumableFee=##Class(web.DHCEQCommon).FormatNumber($p(Values,"^",2),"",2)
	..s TConsumableFee=+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"14",TMonth,TMonth)
	..i TFactualWorkLoad'=0  d
	...s TPrice=##Class(web.DHCEQCommon).FormatNumber(TInCome/TFactualWorkLoad,"",2)
	...;s AllOutFee=..AllOutFeeList(rowid,TMonth,TMonth,"",CTLocID,CurGroupID)			//+..GetGuaranteeFee(rowid,TMonth,TMonth)
	...;s TGYCost=$p(AllOutFee,"^",1)
	...;s TGLCost=$p(AllOutFee,"^",2)
	...;s TYFCost=$p(AllOutFee,"^",3)
	...;s TZJCost=$p(AllOutFee,"^",4)
	...;s TPersonFee=$p(AllOutFee,"^",5)
	...;s TDepreFee=$p(AllOutFee,"^",6)
	...;s TMaintFee=$p(AllOutFee,"^",7)
	...;s TOutCome=TGYCost+TGLCost+TYFCost+TZJCost+TPersonFee+TDepreFee+TConsumableFee+TMaintFee
	...s TOutCome=##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"",TMonth,TMonth)
	...i TPrice'=0  s TCostWorkLoad=TOutCome/TPrice
	...s TSafeWorkLoad=TFactualWorkLoad-TCostWorkLoad
	...i TCostWorkLoad'=0 s TSafeBoundRate=TSafeWorkLoad*100/TFactualWorkLoad
	..s TNetFee=TInCome-TOutCome
	..i TNetFee>0 s TPaybackTime=TOriginalFee/((TInCome-TOutCome+TDepreFee)*12)
	..
	..d OutputRowGetCVPAnalyNew
	..s vYear=$E($ZD(ID,3),1,4)
	..s vMonth=$E($ZD(ID,3),6,7)
	..i vMonth=12  d
	...s vYear=vYear+1
	...s vMonth=1
	..e  d
	...s vMonth=vMonth+1
	..s ID=$ZDH(vYear_"-"_vMonth_"-01",3) - 1
	Quit $$$OK
OutputRowGetCVPAnalyNew
	s TCostWorkLoad=$fn(TCostWorkLoad,"",0)
	s TFactualWorkLoad=$fn(TFactualWorkLoad,"",0)
	s TSafeWorkLoad=$fn(TSafeWorkLoad,"",0)
	i +TSafeBoundRate=0 s TSafeBoundRate="-"
	i +TSafeBoundRate'=0 s TSafeBoundRate=##Class(web.DHCEQCommon).FormatNumber(TSafeBoundRate,"",2)
	i +TPaybackTime=0 s TPaybackTime="-"
	i +TPaybackTime'=0 s TPaybackTime=##Class(web.DHCEQCommon).FormatNumber(TPaybackTime,"",2)
	i +TNetFee=0 s TNetFee="-"
	s Data=$lb(TMonth,TEquipDR,TEquip,TNo,TFactualWorkLoad,TInCome,TConsumableFee,TCostWorkLoad,TGYCost,TGLCost,TYFCost,TZJCost,TPersonFee,TDepreFee,TOutCome,TPrice,TSafeWorkLoad,TSafeBoundRate,TOriginalFee,TPaybackTime,TNetFee,TLoc,TMaintFee,TJob)
	Set ^CacheTemp(repid,index)=Data
	s ^TempDHCEQ("CVPAnalyNew",TJob,index)=TMonth_"^"_TEquipDR_"^"_TEquip_"^"_TNo_"^"_TFactualWorkLoad_"^"_TInCome_"^"_TConsumableFee_"^"_TCostWorkLoad_"^"_TGYCost_"^"_TGLCost_"^"_TYFCost_"^"_TZJCost_"^"_TPersonFee_"^"_TDepreFee_"^"_TOutCome_"^"_TPrice_"^"_TSafeWorkLoad_"^"_TSafeBoundRate_"^"_TPaybackTime_"^"_TOriginalFee_"^"_TNetFee_"^"_TLoc_"^"_TMaintFee
	Set index=index+1
	quit
ResetVariablesGetCVPAnalyNew
	s (TMonth,TEquipDR,TEquip,TNo)=""
	s (TFactualWorkLoad,TInCome,TConsumableFee,TCostWorkLoad,TGYCost,TGLCost,TYFCost,TZJCost,TPersonFee,TDepreFee,TOutCome,TPrice,TSafeWorkLoad,TSafeBoundRate,TPaybackTime,TNetFee,TMaintFee)=0
	quit
}

ClassMethod CVPAnalyNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CVPAnalyNewExecute ]
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

ClassMethod CVPAnalyNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CVPAnalyNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##Class(web.DHCEQBenefitAnalyReport).GetCVPAnalyList("270724","35")
ClassMethod GetCVPAnalyList(job, index)
{
	new Num
	if index="" s Num=$order(^TempDHCEQ("CVPAnalyNew",job,""),-1)
	if index'=""  s Num=$G(^TempDHCEQ("CVPAnalyNew",job,index))
	q Num
}

/// 新增：2014-12-26 ZY Utilization rate
///  d ##class(%ResultSet).RunQuery("web.DHCEQBenefitAnalyReport","MaintBenefit","","","2014-12","2014-12","111")
Query MaintBenefit(Equip, UseLocID As %Library.String = "", sMonthStr As %Library.String = "", eMonthStr As %Library.String = "", CurGroupID As %Library.String = "") As %Query(ROWSPEC = "TRowID:%String,TName:%String,TUseLoc:%String,TNo:%String,TLeaveFactoryNo:%String,TOldNo:%String,TIntactRate:%String,TStartingRate:%String,MonthStr:%String") [ SqlProc ]
{
}

ClassMethod MaintBenefitExecute(ByRef qHandle As %Binary, Equip, UseLocID As %Library.String = "", sMonthStr As %Library.String = "", eMonthStr As %Library.String = "", CurGroupID As %Library.String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s Equip=$ZCONVERT(Equip,"U")
	i (sMonthStr="")||(eMonthStr="") Quit $$$OK
	i ($ZDH(sMonthStr_"-01",3)>$ZDH(eMonthStr_"-01",3)) Quit $$$OK	
	s Code=0
	f  s Code=$o(^DHCEQEquip(0,"Code",Code))  quit:Code=""  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQEquip(0,"Code",Code,rowid))  quit:rowid=""  d
	..d ResetVariablesMaintBenefit
	..Quit:##Class(web.DHCEQBenefitAnalyReport).CheckEquipID(rowid)=0
	..Quit:$p($g(^DHCEQEquip(rowid)),"^",59)'="N"
	..s TRowID=rowid
	..s TName = $p($g(^DHCEQEquip(rowid)),"^",1)
	..s TCode = Code
	..s TDesc = $p($g(^DHCEQEquip(rowid)),"^",7)
	..s TLeaveFactoryNo = $p($g(^DHCEQEquip(rowid)),"^",10)
	..s TMemoryCode = $p($g(^DHCEQEquip(rowid)),"^",61)
	..s TOldNo = $p($g(^DHCEQEquip(rowid)),"^",91)
	..s TNo = $p($g(^DHCEQEquip(rowid)),"^",71)
	..quit:(Equip'="")&&(($ZCONVERT(TName,"U")'[Equip)&($ZCONVERT(TLeaveFactoryNo,"U")'[Equip)&(TRowID'=Equip)&($ZCONVERT(TMemoryCode,"U")'[Equip)&($ZCONVERT(TNo,"U")'[Equip)&($ZCONVERT(TCode,"U")'[Equip))
	..
	..s TEquipType=$p($g(^DHCEQEquip(rowid)),"^",63)
	..quit:(TEquipType'="")&&("1"=##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipType,CurGroupID))
	..s TStatus = $p($g(^DHCEQEquip(rowid)),"^",38)
	..quit:(TStatus="2")||(TStatus="3")
	..s TUseLocDR = $p($g(^DHCEQEquip(rowid)),"^",19)
	..quit:(UseLocID'="")&&(TUseLocDR'=UseLocID)
	..i TUseLocDR'="" s TUseLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	..s vStart=$ZDH(sMonthStr_"-01",3)
	..s vEnd=$ZDH(eMonthStr_"-01",3)
	..f ID=vStart:1:vEnd  d
	...;当前月份
	...s MonthStr=$E($ZD(ID,3),1,7)
    ...s TIntactRate=##Class(web.DHCEQAnalysisIndex).IntractRate(rowid,MonthStr)
	...s TStartingRate=##Class(web.DHCEQAnalysisIndex).StartingRate(rowid,MonthStr)
	...d OutputRowMaintBenefit
	...s vYear=$E($ZD(ID,3),1,4)
	...s vMonth=$E($ZD(ID,3),6,7)
	...i vMonth=12  d
	....s vYear=vYear+1
	....s vMonth=1
	...e  d
	....s vMonth=vMonth+1
	...s ID=$ZDH(vYear_"-"_vMonth_"-01",3) - 1
	Quit $$$OK
OutputRowMaintBenefit
	s Data=$lb(TRowID,TName,TUseLoc,TNo,TLeaveFactoryNo,TOldNo,TIntactRate,TStartingRate,MonthStr)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesMaintBenefit
	s (TRowID,TName,TCode,TDesc,TLeaveFactoryNo,TMemoryCode,TNo,TOldNo,TEquipType,TStatus,TUseLocDR,TUseLoc,TIntactRate,TStartingRate,MonthStr)=""
	quit
}

ClassMethod MaintBenefitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MaintBenefitExecute ]
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

ClassMethod MaintBenefitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MaintBenefitExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 新增：2014-12-26 ZY 
///  d ##class(%ResultSet).RunQuery("web.DHCEQBenefitAnalyReport","Utilization","","","2014-12","2014-12","111")
Query Utilization(Equip, UseLocID As %Library.String = "", sMonthStr As %Library.String = "", eMonthStr As %Library.String = "", CurGroupID As %Library.String = "") As %Query(ROWSPEC = "TRowID:%String,TName:%String,TUseLoc:%String,TNo:%String,TLeaveFactoryNo:%String,TOldNo:%String,TUtilizationRate:%String,TUtilization:%String,TUsedUtilization:%String,MonthStr:%String") [ SqlProc ]
{
}

ClassMethod UtilizationExecute(ByRef qHandle As %Binary, Equip, UseLocID As %Library.String = "", sMonthStr As %Library.String = "", eMonthStr As %Library.String = "", CurGroupID As %Library.String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s Equip=$ZCONVERT(Equip,"U")
	i (sMonthStr="")||(eMonthStr="") Quit $$$OK
	i ($ZDH(sMonthStr_"-01",3)>$ZDH(eMonthStr_"-01",3)) Quit $$$OK	
	s Code=0
	f  s Code=$o(^DHCEQEquip(0,"Code",Code))  quit:Code=""  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQEquip(0,"Code",Code,rowid))  quit:rowid=""  d
	..d ResetVariablesUtilization
	..Quit:##Class(web.DHCEQBenefitAnalyReport).CheckEquipID(rowid)=0
	..Quit:$p($g(^DHCEQEquip(rowid)),"^",59)'="N"
	..s TRowID=rowid
	..s TName = $p($g(^DHCEQEquip(rowid)),"^",1)
	..s TCode = Code
	..s TDesc = $p($g(^DHCEQEquip(rowid)),"^",7)
	..s TLeaveFactoryNo = $p($g(^DHCEQEquip(rowid)),"^",10)
	..s TMemoryCode = $p($g(^DHCEQEquip(rowid)),"^",61)
	..s TOldNo = $p($g(^DHCEQEquip(rowid)),"^",91)
	..s TNo = $p($g(^DHCEQEquip(rowid)),"^",71)
	..quit:(Equip'="")&&(($ZCONVERT(TName,"U")'[Equip)&($ZCONVERT(TLeaveFactoryNo,"U")'[Equip)&(TRowID'=Equip)&($ZCONVERT(TMemoryCode,"U")'[Equip)&($ZCONVERT(TNo,"U")'[Equip)&($ZCONVERT(TCode,"U")'[Equip))
	..
	..s TEquipType=$p($g(^DHCEQEquip(rowid)),"^",63)
	..quit:(TEquipType'="")&&("1"=##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipType,CurGroupID))
	..s TStatus = $p($g(^DHCEQEquip(rowid)),"^",38)
	..quit:(TStatus="2")||(TStatus="3")
	..s TUseLocDR = $p($g(^DHCEQEquip(rowid)),"^",19)
	..quit:(UseLocID'="")&&(TUseLocDR'=UseLocID)
	..i TUseLocDR'="" s TUseLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	..s vStart=$ZDH(sMonthStr_"-01",3)
	..s vEnd=$ZDH(eMonthStr_"-01",3)
	..f ID=vStart:1:vEnd  d
	...;当前月份
	...s MonthStr=$E($ZD(ID,3),1,7)
    ...s TUtilizationStr=##Class(web.DHCEQAnalysisIndex).UtilizationRate(rowid,MonthStr)
    ...s TUtilizationRate=$p(TUtilizationStr,"^",1)
	...s TUtilization=$p(TUtilizationStr,"^",2)
	...s TUsedUtilization=$p(TUtilizationStr,"^",3)
	...d OutputRowUtilization
	...s vYear=$E($ZD(ID,3),1,4)
	...s vMonth=$E($ZD(ID,3),6,7)
	...i vMonth=12  d
	....s vYear=vYear+1
	....s vMonth=1
	...e  d
	....s vMonth=vMonth+1
	...s ID=$ZDH(vYear_"-"_vMonth_"-01",3) - 1
	Quit $$$OK
OutputRowUtilization
	s Data=$lb(TRowID,TName,TUseLoc,TNo,TLeaveFactoryNo,TOldNo,TUtilizationRate,TUtilization,TUsedUtilization,MonthStr)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesUtilization
	s (TRowID,TName,TCode,TDesc,TLeaveFactoryNo,TMemoryCode,TNo,TOldNo,TEquipType,TStatus,TUseLocDR,TUseLoc,TUtilizationRate,TUtilization,TUsedUtilization,MonthStr)=""
	quit
}

ClassMethod UtilizationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = UtilizationExecute ]
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

ClassMethod UtilizationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = UtilizationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// add by zx 2015-10-21 Bug ZX0047

/// 检查效益分析设备是否为机组设备
/// 返回值为"0"表示无机组关系 否则返回机组主表ID
ClassMethod CheckGroupEquip(EquipID)
{
	n Flag,GroupListDR,EquipGroupDR
	i EquipID="" q "0"
	s Flag=0
	s GroupListDR=0
	f  s GroupListDR=$o(^DHCEQGroupList(0,"Equip",EquipID,GroupListDR)) q:GroupListDR=""  d
	.s EquipGroupDR=$p($g(^DHCEQGroupList(GroupListDR)),"^",1)
	.s Flag=EquipGroupDR
	
	q Flag
}

/// MZY0149	3076888,3080559		2023-01-09
/// d ##class(%ResultSet).RunQuery("web.DHCEQBenefitAnalyReport","InOutDetailNew","2022-06","2022-06","266","85")
/// d ##class(%ResultSet).RunQuery("web.DHCEQBenefitAnalyReport","InOutDetailNew","2022-12","2023-01","107","85")
Query InOutDetailNew(StartMonth As %String = "", EndMonth As %String = "", CTLocID As %String = "", CurGroupID As %String = "", UseLocDR As %String = "", EquipID As %String = "") As %Query(ROWSPEC = "TEquipName:%String,TEquipNo:%String,TUseLocDR:%String,TUseLoc:%String,TServiceItemDR:%String,TServiceItem:%String,TInCome:%String,TWorkLoadNum:%String,TPrice:%String,TMonth:%String,TCheckNumPerItem:%String,TCheckNum:%String,TCheckPersonPerItem:%String,TCheckPerson:%String,TExposureNumPerItem:%String,TExposureNum:%String,TConsumableFee:%String,TPersonFee:%String,TWaterFee:%String,TElectricFee:%String,TGasFee:%String,THouseFee:%String,TOfficesFee:%String,TPublicFee:%String,TMaintFee:%String,TInSpectFee:%String,TDepreFee:%String,TEquipDR:%String,TModel:%String,TOriginalFee:%String") [ SqlProc ]
{
}

ClassMethod InOutDetailNewExecute(ByRef qHandle As %Binary, StartMonth As %String = "", EndMonth As %String = "", CTLocID As %String = "", CurGroupID As %String = "", UseLocDR As %String = "", EquipID As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
	;s ^DHCEQMozy("web.DHCEQBenefitAnalyReport.InOutDetailNew")=StartMonth_","_EndMonth_","_CTLocID_","_CurGroupID_","_UseLocDR_","_EquipID
	i (StartMonth="")||(EndMonth="") Quit $$$OK
	i ($ZDH(StartMonth_"-01",3)>$ZDH(EndMonth_"-01",3)) Quit $$$OK
	s SYear=$p(StartMonth,"-",1)
	s SMonth=$p(StartMonth,"-",2)
	s EYear=$p(EndMonth,"-",1)
	s EMonth=$p(EndMonth,"-",2)
	s CBMonth=StartMonth
	s CEMonth=EndMonth
	s index=1
	
	; ^DHCEQUseRecordStat(0,"SourceMonth",1,10904,2022,"06",14847)=""
	//暂时只处理设备的数据
	s SourceID=0
	f  s SourceID=$o(^DHCEQUseRecordStat(0,"SourceMonth","1",SourceID)) q:SourceID=""  d
	.q:(EquipID'="")&&(EquipID'=SourceID)
	.s TUseLocDR=$p($g(^DHCEQEquip(SourceID)),"^",19)
	.q:(UseLocDR'="")&&(UseLocDR'=TUseLocDR)
	.s TEquipName=$p($g(^DHCEQEquip(SourceID)),"^",1)
	.s TEquipNo=$p($g(^DHCEQEquip(SourceID)),"^",71)
	.s TModelDR=$p($g(^DHCEQEquip(SourceID)),"^",3)
	.//modified by ZY20230209 bug:3234188
	.s TModel=##class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
	.s TOriginalFee=$p($g(^DHCEQEquip(SourceID)),"^",27)
	.d ResetVariablesGetInOutDetailNew
	.s TEquipDR=SourceID
	.s TPersonFee=##Class(web.DHCEQBenefitAnalyReport).EquipResourceFee(SourceID,CBMonth,CEMonth,"","03",CTLocID,CurGroupID)  //人工费
	.s TWaterFee=##Class(web.DHCEQBenefitAnalyReport).EquipResourceFee(SourceID,CBMonth,CEMonth,"","02",CTLocID,CurGroupID)  //水费
	.s TElectricFee=##Class(web.DHCEQBenefitAnalyReport).EquipResourceFee(SourceID,CBMonth,CEMonth,"","01",CTLocID,CurGroupID)  //电费
	.s TGasFee=##Class(web.DHCEQBenefitAnalyReport).EquipResourceFee(SourceID,CBMonth,CEMonth,"","06",CTLocID,CurGroupID)  //燃气费
	.s THouseFee=##Class(web.DHCEQBenefitAnalyReport).EquipResourceFee(SourceID,CBMonth,CEMonth,"","04",CTLocID,CurGroupID)  //房屋折旧
	.s TOfficesFee=##Class(web.DHCEQBenefitAnalyReport).EquipResourceFee(SourceID,CBMonth,CEMonth,"","08",CTLocID,CurGroupID)  //办公家具折旧
	.s TPublicFee=##Class(web.DHCEQBenefitAnalyReport).EquipResourceFee(SourceID,CBMonth,CEMonth,"","07",CTLocID,CurGroupID)  //公用支出
	.s TMaintFee=##Class(web.DHCEQBenefitAnalyReport).GetOutFeeByLifeInfo(SourceID,CBMonth,CEMonth,"31", "",CTLocID,CurGroupID)  //维修费
	.s TMaintainFee=##Class(web.DHCEQBenefitAnalyReport).GetOutFeeByLifeInfo(SourceID,CBMonth,CEMonth,"32", "",CTLocID,CurGroupID)		//保养
	.s TInSpectFee=##Class(web.DHCEQBenefitAnalyReport).GetOutFeeByLifeInfo(SourceID,CBMonth,CEMonth,"33", "",CTLocID,CurGroupID)		//检查
	.s TGuaranteeFee=##Class(web.DHCEQBenefitAnalyReport).GetGuaranteeFee(SourceID,CBMonth,CEMonth)  //保修
	.s TDepreFee=##Class(web.DHCEQBenefitAnalyReport).GetOutFeeByLifeInfo(SourceID,CBMonth,CEMonth,"35", "",CTLocID,CurGroupID)  //折旧
	.
	.f CurYear=SYear:1:EYear d
	..s NewEMonth=EMonth
	..i CurYear<EYear s NewEMonth=12
	..f CurMonth=SMonth:1:NewEMonth d
	...i CurMonth<10 s CurMonth="0"_CurMonth
	...s TMonth=CurYear_"-"_CurMonth
	...
	...s rowid=0
	...f  s rowid=$o(^DHCEQUseRecordStat(0,"SourceMonth","1",SourceID,CurYear,CurMonth,rowid)) q:(rowid="")  d
	....s TConsumableFee=0
	....s TUseLocDR=$p($g(^DHCEQUseRecordStat(rowid)),"^",5)
	....;q:(UseLocDR'="")&&(TUseLocDR'=UseLocDR)
	....i TUseLocDR'="" s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	....s TServiceItemDR=$p($g(^DHCEQUseRecordStat(rowid)),"^",6)
	....i TServiceItemDR'="" s TServiceItem=$p($g(^DHCEQCCode("DHCEQCServiceItem",TServiceItemDR)),"^",1)
	....s TInCome=$p($g(^DHCEQUseRecordStat(rowid)),"^",7)
	....s TWorkLoadNum=$p($g(^DHCEQUseRecordStat(rowid)),"^",8)
	....s TWorkLoadUnitDR=$p($g(^DHCEQUseRecordStat(rowid)),"^",9)
	....s TPrice=$fn($p($g(^DHCEQUseRecordStat(rowid)),"^",10),"",2)
	....s TRemark=$p($g(^DHCEQUseRecordStat(rowid)),"^",11)
	....s TCheckNumPerItem=$p($g(^DHCEQUseRecordStat(rowid)),"^",12)
	....s TCheckNum=$p($g(^DHCEQUseRecordStat(rowid)),"^",13)
	....s TCheckPersonPerItem=$p($g(^DHCEQUseRecordStat(rowid)),"^",14)
	....s TCheckPerson=$p($g(^DHCEQUseRecordStat(rowid)),"^",15)
	....s TExposureNumPerItem=$p($g(^DHCEQUseRecordStat(rowid)),"^",16)
	....s TExposureNum=$p($g(^DHCEQUseRecordStat(rowid)),"^",17)
	....;s TMonth=CurYear_"-"_CurMonth
	....//汇总单个服务项所产生消耗项目支出
	....s ConsumableID=0
	....f  s ConsumableID=$o(^DHCEQUseConsumableStat(0,"UseRecordstat",rowid,ConsumableID)) q:ConsumableID=""  d
	.....s TConsumableFee=TConsumableFee+$p($g(^DHCEQUseConsumableStat(ConsumableID)),"^",6)
	....d OutputRowGetInOutDetailNew
	Quit $$$OK
	
OutputRowGetInOutDetailNew
	Set Data=$lb(TEquipName,TEquipNo,TUseLocDR,TUseLoc,TServiceItemDR,TServiceItem,TInCome,TWorkLoadNum,TPrice,TMonth,TCheckNumPerItem,TCheckNum,TCheckPersonPerItem,TCheckPerson,TExposureNumPerItem,TExposureNum,TConsumableFee,TPersonFee,TWaterFee,TElectricFee,TGasFee,THouseFee,TOfficesFee,TPublicFee,TMaintFee,TInSpectFee,TDepreFee,TEquipDR,TModel,TOriginalFee)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetInOutDetailNew
	s (TUseLocDR,TUseLoc,TServiceItemDR,TServiceItem,TInCome,TWorkLoadNum,TWorkLoadUnitDR,TPrice,TMonth,TRemark,TCheckNumPerItem,TCheckNum,TCheckPersonPerItem,TCheckPerson,TExposureNumPerItem,TExposureNum,TConsumableFee,TPersonFee,TWaterFee,TElectricFee,TGasFee,THouseFee,TOfficesFee,TPublicFee,TMaintFee,TInSpectFee,TDepreFee,TEquipDR)=""
	quit
}

ClassMethod InOutDetailNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = InOutDetailNewExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod InOutDetailNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = InOutDetailNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
