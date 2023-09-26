/// add by zy 2013-05-29 ZY0107
Class web.DHCEQUseRecordStat Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 每月定期统计使用记录
/// d ##Class(web.DHCEQUseRecordStat).GatherUseRecordStat("2014-08")
ClassMethod GatherUseRecordStat(MonthStr, tmpFlag As %String = "")
{
	new Year,Month,StartDate,EndDate,SourceType,SourceID
	new WorkLoadNum,TotalFee,URRowID,TWorkLoadNum,TTotalFee,TCancelDate
	new TempDate,tmpWorkLoadNum,tmpTotalFee,CheckNumPerItem,CheckPersonPerItem,ExposureNumPerItem
	new flag,Result,UseLocDR,valList,tmpDataList,Node
	new AddFlag,tmpExposureTime
	q:MonthStr="" ""
	s Year=$p(MonthStr,"-",1)
	s Month=$p(MonthStr,"-",2)
	s MStartDate=$ZDATEH(##Class(web.DHCEQReport).GetReportDate(MonthStr,"1","4"),4)
	s MEndDate=$ZDATEH(##Class(web.DHCEQReport).GetReportDate(MonthStr,"2","4"),4)
	s StartDate=MStartDate-1
	f  s StartDate=$o(^DHCEQUseRecord(0,"UseDate",StartDate))  q:(StartDate="")||(StartDate>MEndDate)  d
	.s SourceType=0
	.f  s SourceType=$o(^DHCEQUseRecord(0,"UseDate",StartDate,SourceType))  q:(SourceType="")  d
	..s SourceID=0
	..f  s SourceID=$o(^DHCEQUseRecord(0,"UseDate",StartDate,SourceType,SourceID))  q:(SourceID="")  d
	...s (WorkLoadNum,TotalFee)=0
	...s URRowID=0
	...f  s URRowID=$o(^DHCEQUseRecord(0,"UseDate",StartDate,SourceType,SourceID,URRowID))  q:URRowID=""  d
	....q:$p($g(^DHCEQUseRecord(URRowID)),"^",20)="Y"
	....q:$p($g(^DHCEQUseRecord(URRowID)),"^",19)<2
	....q:$p($g(^DHCEQUseRecord(URRowID)),"^",9)=""
	....s AddFlag=1
	....d GatherUseRecordInfo
	....d GatherUseConsumableStat
	
	;取消记录登记		//Modify DJ 2015-09-29 DJ0169 begin
	s StartDate=MStartDate-1
	f  s StartDate=$o(^DHCEQUseRecord(0,"CancelDate",StartDate))	q:(StartDate="")||(StartDate>MEndDate)  d
	.s URRowID=0
	.f  s URRowID=$o(^DHCEQUseRecord(0,"CancelDate",StartDate,URRowID))  q:URRowID=""  d
	..q:$p($g(^DHCEQUseRecord(URRowID)),"^",20)="Y"
	..q:$p($g(^DHCEQUseRecord(URRowID)),"^",19)<2
	..q:$p($g(^DHCEQUseRecord(URRowID)),"^",9)=""
	..s SourceType=$p($g(^DHCEQUseRecord(URRowID)),"^",1)
	..s SourceID=$p($g(^DHCEQUseRecord(URRowID)),"^",2)
	..s AddFlag=-1
	..d GatherUseRecordInfo
	..d GatherUseConsumableStat
	
	
	s (flag,Result)=0
	s SourceType=0
	f  s SourceType=$o(^DHCEQUseRecordStat("Temp",SourceType)) q:(SourceType="")||(flag'=0)  d
	.s SourceID=0
	.f  s SourceID=$o(^DHCEQUseRecordStat("Temp",SourceType,SourceID)) q:(SourceID="")||(flag'=0)  d
	..s ServiceItemID=0
	..f  s ServiceItemID=$o(^DHCEQUseRecordStat("Temp",SourceType,SourceID,ServiceItemID)) q:(ServiceItemID="")||(flag'=0)  d
	...s FirstFlag=0
	...s UseLocID=0
	...f  s UseLocID=$o(^DHCEQUseRecordStat("Temp",SourceType,SourceID,ServiceItemID,UseLocID)) q:(UseLocID="")||(flag'=0)  d
	....s Price=""
	....f  s Price=$o(^DHCEQUseRecordStat("Temp",SourceType,SourceID,ServiceItemID,UseLocID,Price)) q:(Price="")||(flag'=0)  d
	.....s FirstFlag=0
	.....s WorkLoadUnitID=""
	.....f  s WorkLoadUnitID=$o(^DHCEQUseRecordStat("Temp",SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID)) q:(WorkLoadUnitID="")||(flag'=0)  d
	......s FirstFlag=FirstFlag+1
	......s TempURSDate=$g(^DHCEQUseRecordStat("Temp",SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID))
	......
	......s WorkLoadNum=+$p(TempURSDate,"^",1)
	......s TotalFee=+$p(TempURSDate,"^",2)
	......s ExposureNumPerItem=+$p(TempURSDate,"^",3)
	......s CheckNumPerItem=+$p(TempURSDate,"^",4)
	......s CheckPersonPerItem=+$p(TempURSDate,"^",5)
	......s CheckQty=0
	......s PersonTime=0
	......s ExposureTime=0
	......i FirstFlag=1  d			//Add By DJ 2015-09-29 DJ0169
	.......s CheckQty=$g(^DHCEQTemp("UseRecordStat.JCLEQ",$J,SourceType,SourceID,ServiceItemID,UseLocID,Price))
	.......s PersonTime=$g(^DHCEQTemp("UseRecordStat.JCRCEQ",$J,SourceType,SourceID,ServiceItemID,UseLocID,Price))
	.......s ExposureTime=$g(^DHCEQTemp("UseRecordStat.BGCSEQ",$J,SourceType,SourceID,ServiceItemID,UseLocID,Price))
	......s valURSList="^"_SourceType_"^"_SourceID_"^"_Year_"^"_Month_"^"_UseLocID_"^"_ServiceItemID_"^"_TotalFee_"^"_WorkLoadNum_"^"_WorkLoadUnitID_"^"_Price_"^^"_CheckNumPerItem_"^"_CheckQty_"^"_CheckPersonPerItem_"^"_PersonTime_"^"_ExposureNumPerItem_"^"_ExposureTime_"^^^^^"
	......s Result=##Class(web.DHCEQUseRecordStat).SaveDate(valURSList)
	......i Result'>0 d
	.......s flag=1
	.......s ^DHCEQUseRecordStat("Gather","Result","Error",SourceType,SourceID,MonthStr)=Result_"^"_valURSList
	......e  d
	.......d InsertUseConsumableStat
	
	k ^DHCEQUseRecordStat("Temp")
	k ^DHCEQUseConsumableStat("Temp")
	k ^DHCEQTemp("UseRecordStat.JCL")
	k ^DHCEQTemp("UseRecordStat.JCRC")
	k ^DHCEQTemp("UseRecordStat.BGCS")
	k ^DHCEQTemp("UseRecordStat.JCLEQ")
	k ^DHCEQTemp("UseRecordStat.JCRCEQ")
	k ^DHCEQTemp("UseRecordStat.BGCSEQ")
	k ^DHCEQTemp("UseRecordStat_JS.JCL")
	k ^DHCEQTemp("UseRecordStat_JS.JCRC")
	k ^DHCEQTemp("UseRecordStat_JS.BGCS")
	k ^DHCEQTemp("UseRecordStat.DXJCRC")
	k ^DHCEQTemp("UseRecordStat_JS.DXJCRC")
	
	q flag

GatherUseRecordInfo
	s WorkLoadNum=+$p($g(^DHCEQUseRecord(URRowID)),"^",7)*AddFlag
	s WorkLoadUnitID=+$p($g(^DHCEQUseRecord(URRowID)),"^",8)
	s UseLocID=$p($g(^DHCEQUseRecord(URRowID)),"^",9)
	s Price=$p($g(^DHCEQUseRecord(URRowID)),"^",11)
	s TotalFee=$p($g(^DHCEQUseRecord(URRowID)),"^",12)*AddFlag
	s ServiceItemID=$p($g(^DHCEQUseRecord(URRowID)),"^",15)
	s URExType=$p($g(^DHCEQUseRecord(URRowID)),"^",16)
	s CancelDate=$p($g(^DHCEQUseRecord(URRowID)),"^",29)
	s SampleNo=$p($g(^DHCEQUseRecord(URRowID)),"^",41)
	s PatientID=$p($g(^DHCEQUseRecord(URRowID)),"^",10)
	s TExposureNum=$p($g(^DHCEQUseRecord(URRowID)),"^",42)*AddFlag
	s ExposureTime=##Class(web.DHCEQUseRecord).GetExposureNum(URExType,SampleNo)
	s TempDate=$g(^DHCEQUseRecordStat("Temp",SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID))   //add by zx 2014-08-28
	s tmpWorkLoadNum=+$p(TempDate,"^",1)+WorkLoadNum
	s tmpTotalFee=+$p(TempDate,"^",2)+TotalFee
	s ExposureNumPerItem=+$p(TempDate,"^",3)+TExposureNum			//Add By DJ 2015-09-29 DJ0169 begin
	s CheckNumPerItem=+$p(TempDate,"^",4)+1*AddFlag
	s CheckPersonPerItem=+$p(TempDate,"^",5)
	i PatientID'=""  d
	.;当同一天同一台仪器同一个病人做同一个服务的使用记录不存在时,则登记该单项检查人次信息且单项检查人次加1
	.i ('$D(^DHCEQTemp("UseRecordStat.DXJCRC",$J,URExType,StartDate,SourceType,SourceID,PatientID,ServiceItemID))&&(AddFlag=1))  d
	..s ^DHCEQTemp("UseRecordStat.DXJCRC",$J,URExType,StartDate,SourceType,SourceID,PatientID,ServiceItemID)=1
	..s CheckPersonPerItem=+$p(TempDate,"^",5)+1
	.;当同一天同一台仪器同一个病人做同一个服务的减少记录不存在时,则登记该单项检查人次信息且单项检查人次减1
	.i ('$D(^DHCEQTemp("UseRecordStat_JS.DXJCRC",$J,URExType,StartDate,SourceType,SourceID,PatientID,ServiceItemID))&&(AddFlag=-1))  d
	..s ^DHCEQTemp("UseRecordStat_JS.DXJCRC",$J,URExType,StartDate,SourceType,SourceID,PatientID,ServiceItemID)=1
	..s CheckPersonPerItem=+$p(TempDate,"^",5)-1
	
	;检查量
	i SampleNo'=""  d
	.;当病人医技流水号检查量的使用记录不存在时,则登记该流水号且检查量加1
	.i ('$D(^DHCEQTemp("UseRecordStat.JCL",$J,URExType,SampleNo))&&(AddFlag=1))  d
	..s ^DHCEQTemp("UseRecordStat.JCL",$J,URExType,SampleNo)=1
	..s ^DHCEQTemp("UseRecordStat.JCLEQ",$J,SourceType,SourceID,ServiceItemID,UseLocID,Price)=1+$g(^DHCEQTemp("UseRecordStat.JCLEQ",$J,SourceType,SourceID,ServiceItemID,UseLocID,Price))
	.;当病人医技流水号检查量的取消记录不存在时,则登记该流水号且检查量减1
	.i ('$D(^DHCEQTemp("UseRecordStat_JS.JCL",$J,URExType,SampleNo))&&(AddFlag=-1))  d
	..s ^DHCEQTemp("UseRecordStat_JS.JCL",$J,URExType,SampleNo)=1
	..s ^DHCEQTemp("UseRecordStat.JCLEQ",$J,SourceType,SourceID,ServiceItemID,UseLocID,Price)=+$g(^DHCEQTemp("UseRecordStat.JCLEQ",$J,SourceType,SourceID,ServiceItemID,UseLocID,Price))-1
	.;当病人医技流水号曝光的使用记录不存在时,则登记该流水号且增加曝光次数
	.i ('$D(^DHCEQTemp("UseRecordStat.BGCS",$J,URExType,SampleNo))&&(AddFlag=1))  d		//曝光次数
	..s ^DHCEQTemp("UseRecordStat.BGCS",$J,URExType,SampleNo)=1
	..s ^DHCEQTemp("UseRecordStat.BGCSEQ",$J,SourceType,SourceID,ServiceItemID,UseLocID,Price)=ExposureTime+$g(^DHCEQTemp("UseRecordStat.BGCSEQ",$J,SourceType,SourceID,ServiceItemID,UseLocID,Price))
	.;当病人医技流水号曝光的取消记录不存在时,则登记该流水号且减少曝光次数
	.i ('$D(^DHCEQTemp("UseRecordStat_JS.BGCS",$J,URExType,SampleNo))&&(AddFlag=-1))  d
	..s ^DHCEQTemp("UseRecordStat_JS.BGCS",$J,URExType,SampleNo)=1
	..s ^DHCEQTemp("UseRecordStat.BGCSEQ",$J,SourceType,SourceID,ServiceItemID,UseLocID,Price)=+$g(^DHCEQTemp("UseRecordStat.BGCSEQ",$J,SourceType,SourceID,ServiceItemID,UseLocID,Price))-ExposureTime
	
	;检查人次		//Add By DJ 2015-09-29 DJ0169 end
	i PatientID'=""  d
	.;当同一天同一台仪器同一个病人的使用记录不存在时,则登记该检查人次信息且检查人次加1
	.i ('$D(^DHCEQTemp("UseRecordStat.JCRC",$J,URExType,StartDate,SourceType,SourceID,PatientID))&&(AddFlag=1))  d
	..s ^DHCEQTemp("UseRecordStat.JCRC",$J,URExType,StartDate,SourceType,SourceID,PatientID)=1
	..s ^DHCEQTemp("UseRecordStat.JCRCEQ",$J,SourceType,SourceID,ServiceItemID,UseLocID,Price)=1+$g(^DHCEQTemp("UseRecordStat.JCRCEQ",$J,SourceType,SourceID,ServiceItemID,UseLocID,Price))
	.;当同一天同一台仪器同一个病人的取消记录不存在时,则登记该检查人次信息且检查人次减1
	.i ('$D(^DHCEQTemp("UseRecordStat_JS.JCRC",$J,URExType,StartDate,SourceType,SourceID,PatientID))&&(AddFlag=-1))  d
	..s ^DHCEQTemp("UseRecordStat_JS.JCRC",$J,URExType,StartDate,SourceType,SourceID,PatientID)=1
	..s ^DHCEQTemp("UseRecordStat.JCRCEQ",$J,SourceType,SourceID,ServiceItemID,UseLocID,Price)=+$g(^DHCEQTemp("UseRecordStat.JCRCEQ",$J,SourceType,SourceID,ServiceItemID,UseLocID,Price))-1
	
	s ^DHCEQUseRecordStat("Temp",SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID)=tmpWorkLoadNum_"^"_tmpTotalFee_"^"_ExposureNumPerItem_"^"_CheckNumPerItem_"^"_CheckPersonPerItem
	
	q
GatherUseConsumableStat
	s UCIRowID=0
	f  s UCIRowID=$o(^DHCEQUseConsumableItem(0,"UseRecord",URRowID,UCIRowID))  quit:UCIRowID=""  d
	.q:$p(^DHCEQUseConsumableItem(UCIRowID),"^",7)=2
	.s UseConsumableItemID=$p(^DHCEQUseConsumableItem(UCIRowID),"^",2)
	.s UnitID=+$p(^DHCEQUseConsumableItem(UCIRowID),"^",3)
	.s Quantity=+$p(^DHCEQUseConsumableItem(UCIRowID),"^",4)*AddFlag
	.s ConsumablePrice=+$p(^DHCEQUseConsumableItem(UCIRowID),"^",5)
	.s Amount=+$p(^DHCEQUseConsumableItem(UCIRowID),"^",6)*AddFlag
	.s PayPrice=+$p(^DHCEQUseConsumableItem(UCIRowID),"^",18)  //add by zx 2014-09-16 汇总消耗额外收费
	.s PayAmount=+$p(^DHCEQUseConsumableItem(UCIRowID),"^",19)*AddFlag
	.s TServiceItemID=+$p(^DHCEQUseConsumableItem(UCIRowID),"^",12)
	.s ServDetItemID=+$p(^DHCEQUseConsumableItem(UCIRowID),"^",13)
	.s ServDetItemQty=+$p(^DHCEQUseConsumableItem(UCIRowID),"^",14)
	.s TempDate=$g(^DHCEQUseConsumableStat("Temp",SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID,UseConsumableItemID,ServDetItemID,UnitID,ConsumablePrice))   //add by zx 2014-08-28
	.s tmpQuantity=+$p(TempDate,"^",1)+Quantity
	.s tmpAmount=+$p(TempDate,"^",2)+Amount
	.s tmpPayAmount=+$p(TempDate,"^",3)+PayAmount
	.s ^DHCEQUseConsumableStat("Temp",SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID,UseConsumableItemID,ServDetItemID,UnitID,ConsumablePrice)=tmpQuantity_"^"_tmpAmount_"^"_tmpPayAmount_"^"_PayPrice
	q
	
InsertUseConsumableStat
	q:$O(^DHCEQUseConsumableStat("Temp",SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID,""))=""
	s UseConsumableItemID=0
	f  s UseConsumableItemID=$o(^DHCEQUseConsumableStat("Temp",SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID,UseConsumableItemID)) quit:(UseConsumableItemID="")||(flag'=0)  d
	.s ServDetItemID=""
	.f  s ServDetItemID=$o(^DHCEQUseConsumableStat("Temp",SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID,UseConsumableItemID,ServDetItemID)) quit:(ServDetItemID="")||(flag'=0)  d
	..s UnitID=""
	..f  s UnitID=$o(^DHCEQUseConsumableStat("Temp",SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID,UseConsumableItemID,ServDetItemID,UnitID)) quit:(UnitID="")||(flag'=0)  d
	...s ConsumablePrice=""
	...f  s ConsumablePrice=$o(^DHCEQUseConsumableStat("Temp",SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID,UseConsumableItemID,ServDetItemID,UnitID,ConsumablePrice)) quit:(ConsumablePrice="")||(flag'=0)  d
	....s TempUCSData=$g(^DHCEQUseConsumableStat("Temp",SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID,UseConsumableItemID,ServDetItemID,UnitID,ConsumablePrice))
	....s TQuantity=+$p(TempUCSData,"^",1)
	....s TAmount=+$p(TempUCSData,"^",2)
	....s TPayAmount=+$p(TempUCSData,"^",3)
	....s TPayPrice=+$p(TempUCSData,"^",4)
	....s valUCSList="^"_Result_"^"_UseConsumableItemID_"^"_UnitID_"^"_TQuantity_"^"_ConsumablePrice_"^"_TAmount_"^"_ServiceItemID_"^"_ServDetItemID_"^^^^^^"_"^"_TPayPrice_"^"_TPayAmount  //add by zx 2014-08-28
	....s ConsumableItemResult=##Class(web.DHCEQUseConsumableStat).SaveDate(valUCSList)  //add by zx 2014-12-29 Result与前面命名重复
	....i ConsumableItemResult'>0 d
	.....s flag=1
	.....s ^DHCEQUseConsumableStat("Gather","Result","Error",SourceType,SourceID,MonthStr)=ConsumableItemResult_"^"_valUCSList
	q
}

ClassMethod SaveDate(val)
{
	new PLIST,RowID,SQLCODE
	s RowID=$p(val,"^",1)
	s PLIST(2)=$p(val,"^",2)	//SourceType
	s PLIST(3)=$p(val,"^",3)	//SourceID
	s PLIST(4)=$p(val,"^",4)	//Year
	s PLIST(5)=$p(val,"^",5)	//Month
	s PLIST(6)=$p(val,"^",6)	//UseLocDR
	s PLIST(7)=$p(val,"^",7)	//ServiceItemDR
	s PLIST(8)=$p(val,"^",8)	//InCome
	s PLIST(9)=$p(val,"^",9)	//WorkLoadNum
	i $p(val,"^",10)>0 s PLIST(10)=$p(val,"^",10)	//WorkLoadUnitDR
	s PLIST(11)=$p(val,"^",11)	//Price
	s PLIST(12)=$p(val,"^",12)	//Remark
	s PLIST(13)=$p(val,"^",13)	//CheckNumPerItem		//Add By DJ 2015-09-29 DJ0169 begin
	s PLIST(14)=$p(val,"^",14)	//CheckNum
	s PLIST(15)=$p(val,"^",15)	//CheckPersonPerItem
	s PLIST(16)=$p(val,"^",16)	//CheckPerson
	s PLIST(17)=$p(val,"^",17)	//ExposureNumPerItem
	s PLIST(18)=$p(val,"^",18)	//ExposureNum
	s PLIST(19)=$p(val,"^",19)	//Hold1
	s PLIST(20)=$p(val,"^",20)	//Hold2
	s PLIST(21)=$p(val,"^",21)	//Hold3
	s PLIST(22)=$p(val,"^",22)	//Hold4
	s PLIST(23)=$p(val,"^",23)	//Hold5					//Add By DJ 2015-09-29 DJ0169 end
	/*
	s FindFlag=""
	s FindURSRowID=0
	f  s FindURSRowID=$o(^DHCEQUseRecordStat(0,"SourceMonth",1,PLIST(3),PLIST(4),PLIST(5),FindURSRowID))  q:(FindURSRowID="")||(FindFlag'="")  d
	.s FindServiceItemDR=$p($g(^DHCEQUseRecordStat(FindURSRowID)),"^",6)
	.i FindServiceItemDR=PLIST(7)  d
	..s FindFlag=1
	..s RowID=FindURSRowID
	*/
	if RowID=""
	{
		&SQL(Insert Into SQLUSER.DHC_EQUseRecordStat Values :PLIST())
	}
	else
	{
		/*
		k PLISTA
		s PLISTA(13)=PLIST(13)
		s PLISTA(14)=PLIST(14)
		s PLISTA(15)=PLIST(15)		
		&SQL(Update SQLUSER.DHC_EQUseRecordStat Values :PLISTA() where URS_RowID = :RowID)
		*/
		&SQL(Update SQLUSER.DHC_EQUseRecordStat Values :PLIST() where URS_RowID = :RowID)
	}
 	i RowID="" Set RowID=$g(%ROWID)
 	q RowID
}

}
