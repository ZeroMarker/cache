Import SQLUSER

/// Creator：xiongwang
/// CreatDate：2020-10-23
/// Description: 收费应急系统-数据导出
Class BILL.CES.BL.Export Extends %RegisteredObject
{

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 2.医嘱别名信息(ARC_Alias)
/// Input:	stIndex开始索引，expNum条数
/// Return: (-1:无数据，非-1：mysql插入语句)
/// Debug: w ##class(BILL.CES.BL.Export).GetARCAliasData(0,10).Read()
ClassMethod GetARCAliasData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set stream=##class(%Stream.GlobalCharacter).%New()
	do stream.MoveToEnd()
	set listNum=0
	set endIndex=-1
	
	set ARCAliasRowid=stIndex
	for  set ARCAliasRowid=$o(^ARC("ALIAS",ARCAliasRowid)) quit:((ARCAliasRowid="")||(listNum>=expNum))  do
	.set listNum=listNum+1
	.set endIndex=ARCAliasRowid		//结束索引
	.quit:$g(^ARC("ALIAS",ARCAliasRowid))=""
	.set ARCIMDR=$p(^ARC("ALIAS",ARCAliasRowid),"^",1)
	.set ARCOSDR=$p(^ARC("ALIAS",ARCAliasRowid),"^",2)
	.set EffDateTo=$p($g(^ARCOS(+ARCOSDR)),"^",16)
	.quit:((EffDateTo<+$h)&&(EffDateTo'=""))
	.set Text=$p(^ARC("ALIAS",ARCAliasRowid),"^",6)
	.set Desc=$p(^ARC("ALIAS",ARCAliasRowid),"^",3)
	.set OrderSubCatDR=$p(^ARC("ALIAS",ARCAliasRowid),"^",4)
	.set Type=$p(^ARC("ALIAS",ARCAliasRowid),"^",5)
	.set RowCalc=""
	.set OrderOnItsOwn=$p(^ARC("ALIAS",ARCAliasRowid),"^",7)
	.set Service=$p(^ARC("ALIAS",ARCAliasRowid),"^",8)
	.set ServiceSetDR=$p(^ARC("ALIAS",ARCAliasRowid),"^",9)
	.set AuxInsTypeDR=$p(^ARC("ALIAS",ARCAliasRowid),"^",10)
	.set InsTypeDR=$p(^ARC("ALIAS",ARCAliasRowid),"^",11)
	.set DateFrom=$p(^ARC("ALIAS",ARCAliasRowid),"^",12)
	.set:(DateFrom'="") DateFrom=$zd(DateFrom,3)
	.set DateTo=$p(^ARC("ALIAS",ARCAliasRowid),"^",13)
	.set:(DateTo'="") DateTo=$zd(DateTo,3)
	.set GenericDR=$p(^ARC("ALIAS",ARCAliasRowid),"^",14)
	.&sql(select ALIAS_Row_Calc into :RowCalc from ARC_Alias where ALIAS_RowId=:ARCAliasRowid )
	.set RowCalc=$p(RowCalc,$c(1))
	.set Data=$lb(ARCAliasRowid,$g(ARCIMDR),$g(ARCOSDR),$g(Text),$g(Desc),$g(OrderSubCatDR),$g(Type))   ///0--6
	.set Data=Data_$lb(RowCalc,OrderOnItsOwn,Service,ServiceSetDR,AuxInsTypeDR,InsTypeDR,DateFrom,DateTo,GenericDR)   ///7--15
	
	.for index=1:1:$ll(Data) do
	..set Data=$lu(Data,index,##class(BILL.CES.COM.Util).EscapeMysqlStr($lg(Data,index)))
	..//set Data=$lu(Data,index,$tr($lg(Data,index),"′",""))
	..//set Data=$lu(Data,index,$case($lg(Data,index)="",1:"NULL",:"'"_$lg(Data,index)_"'"))	//空值转换成Null
	
	.set sql="INSERT INTO ARC_Alias(ALIAS_RowId,ALIAS_ARCIM_DR,ALIAS_ARCOS_DR,ALIAS_Text,ALIAS_Desc,ALIAS_OrderSubCat_DR,ALIAS_Type,ALIAS_Row_Calc,ALIAS_OrderOnItsOwn,ALIAS_Service  ,ALIAS_ServiceSet_DR,"
    .set sql=sql_"ALIAS_AuxInsType_DR,ALIAS_InsType_DR,ALIAS_DateFrom,ALIAS_DateTo,ALIAS_Generic_DR)"
	.set sql= sql_" VALUES ("_$lts(Data,",")_");"
	.do stream.Write(sql)
	
	do stream.Write("^"_endIndex)		//加上本次查询结束索引
	
	quit stream
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 2.账单大类信息(ARC_BillGrp)
/// Debug: w ##class(BILL.CES.BL.Export).GetARCBillGrpData(0,10).Read()
ClassMethod GetARCBillGrpData(stIndex As %Integer = 0, expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="ARC_BillGrp"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" ARCBG_RowId>"_(+stIndex)
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 3.账单子类信息(ARC_BillSub)
/// Debug: w ##class(BILL.CES.BL.Export).GetARCBillSubData("6||3",5).Read()
ClassMethod GetARCBillSubData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="ARC_BillSub"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" ((ARCSG_ARCBG_ParRef="_+$p(stIndex,"||",1)_" AND ARCSG_ChildSub>"_+$p(stIndex,"||",2)_")"
	set condition=condition_" OR (ARCSG_ARCBG_ParRef->ARCBG_RowId>"_+$p(stIndex,"||",1)_" ))"
	set condition=condition_" ORDER BY ARCSG_ARCBG_ParRef,ARCSG_ChildSub"
	quit ..GetDataByTabName(tabName, queryColumn, condition, 2)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 4.医嘱子类(ARC_ItemCat)
/// Debug: w ##class(BILL.CES.BL.Export).GetARCItemCatData().Read()
ClassMethod GetARCItemCatData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="ARC_ItemCat"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" ARCIC_RowId>"_(+stIndex)
	quit ..GetDataByTabName(tabName, queryColumn, condition, 1)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 5.医嘱价格信息(ARC_ItemPriceItaly)不用
/// Debug: w ##class(BILL.CES.BL.Export).GetARCItemPriceItalyData().Read()
ClassMethod GetARCItemPriceItalyData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set stream=##class(%Stream.GlobalCharacter).%New()
	do stream.MoveToEnd()
	set listNum=0
	set endIndex=-1
	do stream.Write("^"_endIndex)
	quit stream
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 6.医嘱子类接收科室信息(ARC_ItemCatRecLoc)
/// Debug: w ##class(BILL.CES.BL.Export).GetARCItemCatRecLocData("1||123",5).Read()
ClassMethod GetARCItemCatRecLocData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="ARC_ItemCatRecLoc"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" ((RL_ParRef="_+$p(stIndex,"||",1)_" AND RL_Childsub>"_+$p(stIndex,"||",2)_")"
	set condition=condition_" OR (RL_ParRef>"_+$p(stIndex,"||",1)_" ))"
	set condition=condition_" ORDER BY RL_ParRef,RL_Childsub"
	quit ..GetDataByTabName(tabName, queryColumn, condition, 2)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 7.医嘱项信息(ARC_ItmMast)
/// Debug: w ##class(BILL.CES.BL.Export).GetARCItmMastData(0,15000).Read()
ClassMethod GetARCItmMastData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set stream=##class(%Stream.GlobalCharacter).%New()
	do stream.MoveToEnd()
	set listNum=0
	set endIndex=-1

	set ARCIMSubscript=+$p(stIndex,"||",1)
	set CurrDate=+$h
	for  set ARCIMSubscript=$o(^ARCIM(ARCIMSubscript))  quit:(ARCIMSubscript="")||(listNum>=expNum)  do
	.set ARCIMVersion=0
	.if (ARCIMSubscript=$p(stIndex,"||",1)) set ARCIMVersion=+$p(stIndex,"||",2)
	.for  set ARCIMVersion=$o(^ARCIM(ARCIMSubscript,ARCIMVersion))  quit:(ARCIMVersion="")||(listNum>=expNum)  do
	..set MastRowid=ARCIMSubscript_"||"_ARCIMVersion
	..quit:$g(^ARCIM(ARCIMSubscript,ARCIMVersion,1))=""
	..set Code=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,1),"^",1)
	..set Desc=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,1),"^",2)
	..set Abbrev=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,1),"^",3)
	..set UOMDR=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,1),"^",4)
	..set ItemCatDR=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,1),"^",10)
	..quit:($d(^ARC("IC",ItemCatDR))=0)
	..;set IsCNMedItem=##class(web.DHCDocOrderCommon).IsCNMedItem(MastRowid)
	..;quit:(IsCNMedItem=1)	//中草药不导
	..set listNum=listNum+1
	..set endIndex=MastRowid	
	..set ItemCatDesc=""
	..set ItemCatDesc=$p(^ARC("IC",ItemCatDR),"^",2)
	..//quit:(ItemCatDesc="HIDE")
	..set BillSubDR=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,1),"^",9) 
	..set DoseType=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,1),"^",5)
	..set EffDateTime=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,1),"^",13)
	..set:($p(EffDateTime,"Z",1)'="") EffDate=$zd($p(EffDateTime,"Z",1),3)
	..set EffTime=##class(websys.Conversions).TimeLogicalToHtml($p(EffDateTime,"Z",2),1)
	..if $d(^ARCIM(ARCIMSubscript,ARCIMVersion,2))'=0  do
	...set MinAmt=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,2),"^",3)
	...set MaxAmt=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,2),"^",4)
	...set ChgUnitFact=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,2),"^",1)
	...set TypeAAmt=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,2),"^",5)
	...set TypeBAmt=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,2),"^",6)
	...set ChgCost=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,2),"^",2)
	..if $d(^ARCIM(ARCIMSubscript,ARCIMVersion,5))'=0  do
	...set ChgMinAmt=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,5),"^",1) 
	...set ChgMaxAmt=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,5),"^",2)
	...set StdAmt=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,5),"^",3)
	..set EffDateTo=""
	..if $d(^ARCIM(ARCIMSubscript,ARCIMVersion,7))'=0  do
	...set InsSubCatDR=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,7),"^",2) 
	...set EffDateTo=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,7),"^",1)
	...set IncSourceDR=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,7),"^",12)
	...set OrderOnItsOwn=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,7),"^",13)
	...set VisibleInOrderList=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,7),"^",14)
	...set ChargePartial=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,7),"^",15)
	...set SnackFlag=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,7),"^",16)
	..quit:((EffDateTo'="")&&(EffDateTo<+$h))
	..set:(EffDateTo'="") EffDateTo=$zd(EffDateTo,3)
	..if $d(^ARCIM(ARCIMSubscript,ARCIMVersion,8))'=0  do
	...set UpdateDate=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,8),"^",1)
	...set:(UpdateDate'="") UpdateDate=$zd(UpdateDate,3)
	...set UpdateTime=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,8),"^",2)
	...set UpdateTime=##class(websys.Conversions).TimeLogicalToHtml(UpdateTime,1)
	...set UpdateUser=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,8),"^",3)
	...set ConsultDept=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,8),"^",4)
	...set Minutes=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,8),"^",10)
	...set Days=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,8),"^",9)
	...set AllowOrderWOStockCheck=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,8),"^",11)
	...set BillDescription=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,8),"^",12)
	...set PriceCostOnOrdering=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,8),"^",13)
	...set BillingUOMDR=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,8),"^",14)
	...set WordTemplate=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,8),"^",15)
	...set RMDurationDR=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,8),"^",16)
	...set RMFrequencyDR=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,8),"^",17)
	...set GenericDesc=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,8),"^",21)
	...set DefPriorityDR=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,8),"^",22)
	..if $d(^ARCIM(ARCIMSubscript,ARCIMVersion,9))'=0  do
	...set RangeFrom=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,9),"^",1)
	...set RangeTo=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,9),"^",2)
	...set DaysCheckDuplicate=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,9),"^",8)
	...set ProcessingNotes=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,9),"^",14)
	...set MaxPrice=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,9),"^",15)
	...set MinPrice=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,9),"^",16)
	...set ModifiersRequired=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,9),"^",17)
	...set Sensitive=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,9),"^",18)
	...set PatientOrderFile1=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,9),"^",19)
	...set PatientOrderFile2=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,9),"^",20)
	...set PatientOrderFile3=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,9),"^",21)
	...set SensitiveOrder=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,9),"^",22)
	...set HL7ResultType=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",27)
	...set DentalState=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",28)
	...set Text1=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",32)
	...set Text2=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",33)
	...set Text3=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",34)
	...set Text4=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",35)
	...set Text6=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",36)
	...set MaxQtyPerDay=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",37)
	...set MaxQty=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",38)
	
	..//按单机版规则计算单位转换系数
	..set PHCDFDR=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,1),"^",12)
	..if (PHCDFDR'="")  do
	...set PHCDFDR1=$p(PHCDFDR,"||",1)
	...set PHCDFDR2=$p(PHCDFDR,"||",2)
	...if (($g(PHCDFDR1)'="")&&($g(PHCDFDR2)'=""))  do
	....if ($d(^PHCD(PHCDFDR1,"DF",PHCDFDR2,2))'=0)  do
	.....set DrgFormCTUomDr=$p(^PHCD(PHCDFDR1,"DF",PHCDFDR2,2),"^",4)
	
	..;set INCIID=$o(^INCI(0,"ARCIM_DR",ARCIMSubscript,0))
	..set INCIID=$o(^INCI(0,"ARCIM_DR",ARCIMSubscript,""),-1)		//取最后一个？
	..set INCItmFlag=$s((+INCIID>0):"Y",1:"N")
	..set ordCateType=##class(BILL.CES.COM.Util).GetOrdCateType(MastRowid, 0)
	..set AvailQty=0
	..quit:((ordCateType="R")&&(INCIID=""))		//药品医嘱无库存项
	..if (ordCateType="R") do
	...set BillingUOMDR=$p($g(^INCI(+INCIID,1)),"^",12)
	...set ConFac=##class(BILL.CES.COM.Util).UOMFac(BillingUOMDR,DrgFormCTUomDr)
	...quit:(INCItmFlag="N")
	...set sub=0
	...for  set sub=$o(^INCI(INCIID,"IL",sub))  quit:(sub="")||(+AvailQty>0)  do
	....quit:$g(^INCI(INCIID,"IL",sub))=""
	....set AvailQty=$p(^INCI(INCIID,"IL",sub),"^",3)-$p(^INCI(INCIID,"IL",sub),"^",10) //有效库存
	..else  do
	...set ConFac=1
	..quit:(+BillingUOMDR=0)
	..quit:(AvailQty=0)&&(ordCateType="R")		//无库存不导出
	..if (+BillingUOMDR>0) set PackUom=BillingUOMDR
	..else  set PackUom=UOMDR
	..set Hosp=$o(^CT("HOSP",0))
	..set BillPrice=##class(web.UDHCJFPRICE).GetOrderPrice("", "", MastRowid, +$h, "", "", "", "", Hosp, "")
	..quit:($p(BillPrice,"^",5)'="")
	..set Price=$p(BillPrice,"^",1)*ConFac
	..set Price=$fn(Price,"",4)
	..s ServMaterial=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",6)
	..set Data=$lb(MastRowid,$g(Code),$g(Desc),$g(Abbrev),$g(UOMDR),$g(MinAmt),$g(MaxAmt),$g(ChgUnitFact),$g(ItemCatDR),$g(ChgCost))    ///0--9
	..set Data=Data_$lb($g(ChgMinAmt),$g(ChgMaxAmt),$g(StdAmt),$g(TypeAAmt),$g(TypeBAmt),$g(BillSubDR),$g(DoseType),$g(PHCDFDR))       ///10--17
	..set Data=Data_$lb(ARCIMVersion,$g(EffDate),$g(EffTime),$g(EffDateTime),$g(ARCIMSubscript),$g(InsSubCatDR),$g(EffDateTo),$g(BillBodyPDR))    ///18--25
	..set Data=Data_$lb($g(OEMessage),$g(IncSourceDR),$g(OrderOnItsOwn),$g(VisibleInOrderList),$g(Manufactured),$g(ChargePartial),$g(SnackFlag))      ///26--32
	..set Data=Data_$lb($g(RiceTypeDR),$g(UpdateDate),$g(UpdateTime),$g(UpdateUser),$g(ConsultDept),$g(Minutes),$g(Days),$g(AllowOrderWOStockCheck))   ///33--40
	..set Data=Data_$lb($g(BillDescription),$g(PriceCostOnOrdering),$g(BillingUOMDR),$g(WordTemplate),$g(RMDurationDR),$g(RMFrequencyDR),$g(GenericDR))   ///41--47
	..set Data=Data_$lb($g(GenericDesc),$g(DefPriorityDR),$g(ShortDesc),$g(RangeFrom),$g(RangeTo),$g(DaysCheckDuplicate),$g(ProcessingNotes))             ///48--54
	..set Data=Data_$lb($g(MaxPrice),$g(MinPrice),$g(ModifiersRequired),$g(Sensitive),$g(PatientOrderFile1),$g(PatientOrderFile2),$g(PatientOrderFile3))  ///55-61
	..set Data=Data_$lb($g(SensitiveOrder),$g(HL7ResultType),$g(DentalStateDR),$g(Text1),$g(Text2),$g(Text3),$g(Text4),$g(Text5),$g(MaxQtyPerDay))   ///62--70
	..set Data=Data_$lb($g(MaxQty),$g(DrgFormCTUomDr),INCItmFlag,PackUom,ConFac,Price,ServMaterial)  ///71
 
	..for index=1:1:$ll(Data) do
	...set Data=$lu(Data,index,##class(BILL.CES.COM.Util).EscapeMysqlStr($lg(Data,index)))
	...//set Data=$lu(Data,index,$tr($lg(Data,index),"′","\′"))
	...//set Data=$lu(Data,index,$case($lg(Data,index)="",1:"NULL",:"'"_$lg(Data,index)_"'"))	//空值转换成Null
	
	..set sql="INSERT INTO Arc_ItmMast(ARCIM_RowId,ARCIM_Code,ARCIM_Desc,ARCIM_Abbrev,ARCIM_UOM_DR,ARCIM_MinAmt,ARCIM_MaxAmt,ARCIM_ChgUnitFact,ARCIM_ItemCat_DR,ARCIM_ChgCost,ARCIM_ChgMinAmt,"
    ..set sql= sql_"ARCIM_ChgMaxAmt,ARCIM_StdAmt,ARCIM_TypeAAmt,ARCIM_TypeBAmt,ARCIM_BillSub_DR,ARCIM_DoseType,ARCIM_PHCDF_DR,ARCIM_Version ,ARCIM_EffDate,ARCIM_EffTime,"
    ..set sql= sql_"ARCIM_EffDateTime,ARCIM_Subscript,ARCIM_InsSubCat_DR,ARCIM_EffDateTo,ARCIM_BillBodyP_DR,ARCIM_OEMessage,ARCIM_IncSource_DR,ARCIM_OrderOnItsOwn,"
    ..set sql= sql_"ARCIM_VisibleInOrderList,ARCIM_Manufactured,ARCIM_ChargePartial,ARCIM_SnackFlag,ARCIM_RiceType_DR,ARCIM_UpdateDate,ARCIM_UpdateTime,ARCIM_UpdateUser,"
    ..set sql= sql_"ARCIM_ConsultDept,ARCIM_Minutes,ARCIM_Days,ARCIM_AllowOrderWOStockCheck,ARCIM_BillDescription,ARCIM_PriceCostOnOrdering,ARCIM_BillingUOM_DR,"
    ..set sql= sql_"ARCIM_WordTemplate,ARCIM_RMDuration_DR,ARCIM_RMFrequency_DR,ARCIM_Generic_DR,ARCIM_GenericDesc,ARCIM_DefPriority_DR,ARCIM_ShortDesc,"
    ..set sql= sql_"ARCIM_RangeFrom,ARCIM_RangeTo,ARCIM_DaysCheckDuplicate,ARCIM_ProcessingNotes,ARCIM_MaxPrice,ARCIM_MinPrice,ARCIM_ModifiersRequired,ARCIM_Sensitive,"
    ..set sql= sql_"ARCIM_PatientOrderFile1,ARCIM_PatientOrderFile2,ARCIM_PatientOrderFile3,ARCIM_SensitiveOrder,ARCIM_HL7ResultType,ARCIM_DentalState_DR,ARCIM_Text1,"
    ..set sql= sql_"ARCIM_Text2,ARCIM_Text3,ARCIM_Text4,ARCIM_Text5,ARCIM_MaxQtyPerDay,ARCIM_MaxQty,ARCIM_DrgFormCTUom_Dr,ARCIM_INCItmFlag,ARCIM_PackUom,ARCIM_CTCFFactor,ARCIM_Price,ARCIM_ServMaterial)"
	..set sql= sql_" VALUES ("_$lts(Data,",")_");"
	..do stream.Write(sql)
	do stream.Write("^"_endIndex)
	quit stream
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 8.医嘱接收科室信息(ARC_ItmRecLoc)
/// Debug: w ##class(BILL.CES.BL.Export).GetARCItmRecLocData().Read()
ClassMethod GetARCItmRecLocData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="ARC_ItmRecLoc"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" ((ARCRL_ARCIMSub="_+$p(stIndex,"||",1)_" AND ARCRL_Subscript>"_+$p(stIndex,"||",2)_")"
	set condition=condition_" OR (ARCRL_ARCIMSub>"_+$p(stIndex,"||",1)_" ))"
	set condition=condition_" ORDER BY ARCRL_ARCIMSub,ARCRL_Subscript"
	quit ..GetDataByTabName(tabName, queryColumn, condition, 1)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 9.医嘱套信息(ARC_OrdSets)
/// Debug: w ##class(BILL.CES.BL.Export).GetARCOrdSetsData().Read()
ClassMethod GetARCOrdSetsData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set stream=##class(%Stream.GlobalCharacter).%New()
	do stream.MoveToEnd()
	set listNum=0
	set endIndex=-1
	
	set Hosp=$o(^CT("HOSP",0))
	set ARCOSRowId=stIndex
	set CurrentDate=+$h
	for  set ARCOSRowId=$o(^ARCOS(ARCOSRowId))  quit:(ARCOSRowId="")||(listNum>=expNum)  do
	.quit:$g(^ARCOS(ARCOSRowId))=""
	.set listNum=listNum+1
	.set endIndex=ARCOSRowId		//结束索引
	.set Code=$p(^ARCOS(ARCOSRowId),"^",1)
	.set ActiveFlag=$p(^ARCOS(ARCOSRowId),"^",4)
	.set ItemTypeDR=$p(^ARCOS(ARCOSRowId),"^",3)
	.set Desc=$p(^ARCOS(ARCOSRowId),"^",2)
	.set Subscript=$p(^ARCOS(ARCOSRowId),"^",6)
	.set Version=$p(^ARCOS(ARCOSRowId),"^",7)
	.&sql(select ARCOS_CurVers_DR,ARCOS_CurVerFlg,ARCOS_Type_Calc into :CurVersDR,:CurVerFlg,:TypeCalc from ARC_OrdSets where arcos_rowid=:ARCOSRowId  )
	.set CurVersDR=$p($g(CurVersDR),$c(1))
	.set CurVerFlg=$p($g(CurVerFlg),$c(1))
	.set TypeCalc=$p($g(TypeCalc),$c(1))
	.set EffDateTime=$p(^ARCOS(ARCOSRowId),"^",5)
	.if (EffDateTime'="")  do
	..//set EffDate=$zd($p(EffDateTime,"Z",1))
	..set:($p(EffDateTime,"Z",1)'="") EffDate=$zd($p(EffDateTime,"Z",1),3)
	..set EffTime=##class(websys.Conversions).TimeLogicalToHtml($p(EffDateTime,"Z",2),1)
	.set OrdCatDR=$p(^ARCOS(ARCOSRowId),"^",8)
	.set OrdSubCatDR=$p(^ARCOS(ARCOSRowId),"^",9) 
	.set PackagePrice=$p(^ARCOS(ARCOSRowId),"^",10)
	.set LabTrakTestSet=$p(^ARCOS(ARCOSRowId),"^",11)
	.set ServiceGroupDR=$p(^ARCOS(ARCOSRowId),"^",12)
	.set Minutes=$p(^ARCOS(ARCOSRowId),"^",13)
	.set Days=$p(^ARCOS(ARCOSRowId),"^",14)
	.set EffDateFrom=$p(^ARCOS(ARCOSRowId),"^",15)
	.set:(EffDateFrom'="") EffDateFrom=$zd(EffDateFrom,3)
	.set EffDateTo=$p(^ARCOS(ARCOSRowId),"^",16)
	.quit:((EffDateTo<+$h)&&(EffDateTo'=""))
	.set:(EffDateTo'="") EffDateTo=$zd(EffDateTo,3)
	.set DefPriorityDR=$p(^ARCOS(ARCOSRowId),"^",17)
	.set BillGroupDR=$p(^ARCOS(ARCOSRowId),"^",18)
	.set BillSubDR=$p(^ARCOS(ARCOSRowId),"^",19)
	.set DurationDR=$p(^ARCOS(ARCOSRowId),"^",20)
	.set FrequencyDR=$p(^ARCOS(ARCOSRowId),"^",21)
	.//modify 2009-12-30 增加医嘱套价格
	.set OrdSetsPrice=0
	.set DATEChildsub=0
	.for  set DATEChildsub=$o(^ARCOS(ARCOSRowId,"DATE",DATEChildsub))  quit:(DATEChildsub="")  do
	..set ITMChildsub=0
	..for  set ITMChildsub=$o(^ARCOS(ARCOSRowId,"DATE",DATEChildsub,"ITM",ITMChildsub))  quit:(ITMChildsub="")  do
	...set ARCIMDR=$p(^ARCOS(ARCOSRowId,"DATE",DATEChildsub,"ITM",ITMChildsub),"^",1)
	...set Qty=$p(^ARCOS(ARCOSRowId,"DATE",DATEChildsub,"ITM",ITMChildsub),"^",2)
	...quit:(ARCIMDR="")
	...set PriceStr=##class(web.UDHCJFPRICE).GetOrderPrice("", "", ARCIMDR, CurrentDate, "", "", "", "",Hosp,"")
	...quit:($p(PriceStr,"^",5)'="")
	...set Price=$p(PriceStr,"^",1)
	...set Price=+$g(Price)
	...set Price=Price*Qty
	...set OrdSetsPrice=OrdSetsPrice+Price 
	
	.set Data=$lb(ARCOSRowId,$g(Code),$g(ActiveFlag),$g(ItemTypeDR),$g(Desc),$g(Subscript),$g(Version),$g(CurVersDR),$g(CurVerFlg),$g(EffDate))   ///0--9
	.set Data=Data_$lb($g(EffTime),$g(EffDateTime),$g(OrdCatDR),$g(OrdSubCatDR),$g(PackagePrice),$g(LabTrakTestSet),$g(TypeCalc),$g(ServiceGroupDR))  ///10-17
	.set Data=Data_$lb($g(Minutes),$g(Days),$g(EffDateFrom),$g(EffDateTo),$g(DefPriorityDR),$g(BillGroupDR),$g(BillSubDR),$g(DurationDR),$g(FrequencyDR),$g(OrdSetsPrice))  ///18--17
	.for index=1:1:$ll(Data) do
	..set Data=$lu(Data,index,##class(BILL.CES.COM.Util).EscapeMysqlStr($lg(Data,index)))
	..//set Data=$lu(Data,index,$tr($lg(Data,index),"′",""))
	..//set Data=$lu(Data,index,$case($lg(Data,index)="",1:"NULL",:"'"_$lg(Data,index)_"'"))	//空值转换成Null
	
	.set sql="INSERT INTO ARC_OrdSets(ARCOS_RowId,ARCOS_Code,ARCOS_ActiveFlag,ARCOS_ItemType_DR,ARCOS_Desc,ARCOS_Subscript,ARCOS_Version,ARCOS_CurVers_DR,ARCOS_CurVerFlg,ARCOS_EffDate,"
    .set sql= sql_" ARCOS_EffTime,ARCOS_EffDateTime,ARCOS_OrdCat_DR,ARCOS_OrdSubCat_DR,ARCOS_PackagePrice,ARCOS_LabTrakTestSet,ARCOS_Type_Calc,ARCOS_ServiceGroup_DR,"
    .set sql= sql_" ARCOS_Minutes,ARCOS_Days,ARCOS_EffDateFrom,ARCOS_EffDateTo,ARCOS_DefPriority_DR,ARCOS_BillGroup_DR,ARCOS_BillSub_DR,ARCOS_DurationDR,ARCOS_FrequencyDR,ARCOS_Price)"
	.set sql= sql_" VALUES ("_$lts(Data,",")_");"
	.do stream.Write(sql)
	do stream.Write("^"_endIndex)
	quit stream
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 10.医嘱套子表信息(ARC_OrdSetDate)
/// Debug: w ##class(BILL.CES.BL.Export).GetARCOrdSetDateData().Read()
ClassMethod GetARCOrdSetDateData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="ARC_OrdSetDate"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" ((DATE_ParRef="_+$p(stIndex,"||",1)_" AND DATE_Childsub>"_+$p(stIndex,"||",2)_")"
	set condition=condition_" OR (DATE_ParRef>"_+$p(stIndex,"||",1)_" ))"
	set condition=condition_" order by DATE_ParRef,DATE_Childsub"
	quit ..GetDataByTabName(tabName, queryColumn, condition, 2)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 11.医嘱套明细信息(ARC_OrdSetDateItem)
/// Debug: w ##class(BILL.CES.BL.Export).GetARCOrdSetDateItemData("2464||1||1",5).Read()
ClassMethod GetARCOrdSetDateItemData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="ARC_OrdSetDateItem"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" ((ITM_ParRef->DATE_ParRef="_+$p(stIndex,"||",1)_" AND ITM_ParRef->DATE_Childsub="_+$p(stIndex,"||",2)_" AND ITM_Childsub>"_+$p(stIndex,"||",3)_")"
	set condition=condition_" OR (ITM_ParRef->DATE_ParRef="_+$p(stIndex,"||",1)_" AND ITM_ParRef->DATE_Childsub>"_+$p(stIndex,"||",2)_")"
	set condition=condition_" OR (ITM_ParRef->DATE_ParRef>"_+$p(stIndex,"||",1)_" ))"
	set condition=condition_" ORDER BY ITM_ParRef->DATE_ParRef,ITM_ParRef->DATE_Childsub,ITM_Childsub"
	quit ..GetDataByTabName(tabName, queryColumn, condition, 2)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 12.银行信息(CMC_BankMas)
/// Debug: w ##class(BILL.CES.BL.Export).GetCMCBankMasData().Read()
ClassMethod GetCMCBankMasData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="CMC_BankMas"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" CMCBM_RowId >"_(+stIndex)
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 13.医护人员信息(CT_CareProv)
/// Debug: w ##class(BILL.CES.BL.Export).GetCTCareProvData()
ClassMethod GetCTCareProvData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="CT_CareProv"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" CTPCP_RowId >"_(+stIndex)
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 14.单位关系(CT_ConFac)
/// Debug: w ##class(BILL.CES.BL.Export).GetCTConFacData().Read()
ClassMethod GetCTConFacData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="CT_ConFac"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" CTCF_RowID >"_(+stIndex)
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 15.科室信息(CT_Loc)
/// Debug: w ##class(BILL.CES.BL.Export).GetCTLocData().Read()
ClassMethod GetCTLocData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="CT_Loc"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" CTLOC_RowID >"_(+stIndex)
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 16.婚姻表信息(CT_Marital)
/// Debug: w ##class(BILL.CES.BL.Export).GetCTMaritalData().Read()
ClassMethod GetCTMaritalData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="CT_Marital"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" CTMAR_RowId >"_(+stIndex)
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 17.支付方式信息(CT_PayMode)
/// Debug: w ##class(BILL.CES.BL.Export).GetCTPayModeData().Read()
ClassMethod GetCTPayModeData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="CT_PayMode"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" CTPM_RowId >"_(+stIndex)
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 18.性别信息(CT_Sex)
/// Debug: w ##class(BILL.CES.BL.Export).GetCTSexData().Read()
ClassMethod GetCTSexData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="CT_Sex"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" CTSEX_RowId >"_(+stIndex)
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 19.病人身份信息(CT_SocialStatus)
/// Debug: w ##class(BILL.CES.BL.Export).GetCTSocialStatusData().Read()
ClassMethod GetCTSocialStatusData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="CT_SocialStatus"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" SS_RowId >"_(+stIndex)
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 20.单位代码信息(CT_UOM)
/// Debug: w ##class(BILL.CES.BL.Export).GetCTUOMData().Read()
ClassMethod GetCTUOMData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="CT_UOM"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" CTUOM_RowId >"_(+stIndex)
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-03-03
/// Description: 21.卡类型表(DHC_CardTypeDef)
/// Debug: w ##class(BILL.CES.BL.Export).GetDHCCardTypeDefData(1,1).Read()
ClassMethod GetDHCCardTypeDefData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="DHC_CardTypeDef"
	set queryColumn=" TOP "_expNum _" * "
	set condition=" CTD_RowID >"_(+stIndex)	
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-03-03
/// Description: 22.库存项收费项关联表信息(DHC_IncTarRela)
/// Debug: w ##class(BILL.CES.BL.Export).GetDHCIncTarRelaData().Read()
ClassMethod GetDHCIncTarRelaData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="DHC_IncTarRela"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" INCTR_RowId >"_(+stIndex)
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 23.打印模板信息(DHC_JFPrtXML)
/// Debug: w ##class(BILL.CES.BL.Export).GetDHCJFPrtXMLData(0,1000).Read()
ClassMethod GetDHCJFPrtXMLData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set stream=##class(%Stream.GlobalCharacter).%New()
	do stream.MoveToEnd()
	set listNum=0
	set endIndex=-1
	

	set rowId=stIndex
	for  set rowId=$o(^User.DHCXMLPConfigD(rowId))  quit:((rowId="")||(listNum>=expNum))  do
	.set XMLData=$g(^User.DHCXMLPConfigD(rowId))
	.quit:(XMLData="")
	.set endIndex=rowId
	.set listNum=listNum+1
	.set PrtXMLName=$lg(XMLData,3)
	.set fstream=##class(%SerialStream).%Open($lg(XMLData,2))
	.quit:'$Isobject(fstream)
	.do fstream.Rewind()
	.while(fstream.AtEnd=0){set IOStrLen=60000 set mystr=fstream.Read(.IOStrLen)}
	.do fstream.%Close()

	.set Data=$lb("",PrtXMLName,mystr)
	
	.for index=1:1:$ll(Data) do
	..set Data=$lu(Data,index,##class(BILL.CES.COM.Util).EscapeMysqlStr($lg(Data,index)))
	.set sql="INSERT INTO DHC_JFPrtXML (JFPX_Code,JFPX_PrtName,JFPX_PrtXML)"
	.set sql=sql_" VALUES ("_$replace($lts(Data,","), "\_", "_")_");"
	.;set sql=sql_" VALUES ("_$lts(Data,",")_");"
	.do stream.Write(sql)
	do stream.Write("^"_endIndex)
	quit stream
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 24.医嘱与收费项目关联信息(DHC_OrderLinkTar)
/// Debug: w ##class(BILL.CES.BL.Export).GetDHCOrderLinkTarData().Read()
ClassMethod GetDHCOrderLinkTarData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="DHC_OrderLinkTar"
	set queryColumn=" TOP "_(+expNum)
	set queryColumn=queryColumn_" * "
	set condition=" OLT_RowId >"_(+stIndex)
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-03-03
/// Description: 25.库存批次表信息(DHC_PACADM)
/// Debug: w ##class(BILL.CES.BL.Export).GetDHCPACADMData().Read()
ClassMethod GetDHCPACADMData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="DHC_PACADM"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" PAC_RowId >"_(+stIndex)
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 26.处方类型信息(DHC_PrescriptType)
/// Debug: w ##class(BILL.CES.BL.Export).GetDHCPrescriptTypeData().Read()
ClassMethod GetDHCPrescriptTypeData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="DHC_PrescriptType"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" PT_Rowid >"_(+stIndex)
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 27.就诊类型与价格对照表信息(DHC_TarEpisode)
/// Debug: w ##class(BILL.CES.BL.Export).GetDHCTarEpisodeData().Read()
ClassMethod GetDHCTarEpisodeData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="DHC_TarEpisode"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" TEP_RowId >"_(+stIndex)
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 28.折扣系数信息(DHC_TarFactor)
/// Debug: w ##class(BILL.CES.BL.Export).GetDHCTarFactorData().Read()
ClassMethod GetDHCTarFactorData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="DHC_TarFactor"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" TF_RowId >"_(+stIndex)
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 29.收费项信息(DHC_TarItem)
/// Debug: w ##class(BILL.CES.BL.Export).GetDHCTarItemData().Read()
ClassMethod GetDHCTarItemData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="DHC_TarItem"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" TARI_RowId >"_(+stIndex)
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 30.收费项价格表信息(DHC_TarItemPrice)
/// Debug: w ##class(BILL.CES.BL.Export).GetDHCTarItemPriceData().Read()
ClassMethod GetDHCTarItemPriceData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="DHC_TarItemPrice"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" ((TP_TARI_ParRef="_+$p(stIndex,"||",1)_" AND TP_ChildSub>"_+$p(stIndex,"||",2)_")"
	set condition=condition_" OR (TP_TARI_ParRef>"_+$p(stIndex,"||",1)_" ))"
	set condition=condition_" ORDER BY TP_TARI_ParRef,TP_ChildSub"
	quit ..GetDataByTabName(tabName, queryColumn, condition, 2)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 31.门诊发票大类(DHC_TarOC)
/// Debug: w ##class(BILL.CES.BL.Export).GetDHCTarOCData().Read()
ClassMethod GetDHCTarOCData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="DHC_TarOC"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" tartoc_rowid >"_(+stIndex)
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 32.门诊发票子类(DHC_TarOutpatCate)
/// Debug: w ##class(BILL.CES.BL.Export).GetDHCTarOutpatCateData().Read()
ClassMethod GetDHCTarOutpatCateData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="DHC_TarOutpatCate"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" taroc_rowid >"_(+stIndex)
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 33.就诊类型与科室对照表(DHC_TarRecSubtype)
/// Debug: w ##class(BILL.CES.BL.Export).GetDHCTarRecSubtypeData().Read()
ClassMethod GetDHCTarRecSubtypeData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="DHC_TarRecSubtype"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" TRS_RowId >"_(+stIndex)
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 34.收费项目子类(DHC_TarSubCate)
/// Debug: w ##class(BILL.CES.BL.Export).GetDHCTarSubCateData(0,5).Read()
ClassMethod GetDHCTarSubCateData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="DHC_TarSubCate"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" TARSC_RowId >"_(+stIndex)
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-03-03
/// Description: 35.批次价调价表信息(IN_AdjPriceBatch)
/// Debug: w ##class(BILL.CES.BL.Export).GetINAdjPriceBatchData().Read()
ClassMethod GetINAdjPriceBatchData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="IN_AdjPriceBatch"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" INAPB_RowID >"_(+stIndex)
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-03-03
/// Description: 36.统一调价表信息(IN_AdjSalePrice)
/// Debug: w ##class(BILL.CES.BL.Export).GetINAdjSalePriceData().Read()
ClassMethod GetINAdjSalePriceData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="IN_AdjSalePrice"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" INASP_Rowid >"_(+stIndex)
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-03-03
/// Description: 37.库存项表信息(INC_Itm)
/// Debug: w ##class(BILL.CES.BL.Export).GetINCItmData().Read()
ClassMethod GetINCItmData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="INC_Itm"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" INCI_RowId >"_(+stIndex)
	set condition=condition_" and INCI_Code is not null"
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-03-03
/// Description: 38.库存批次表信息(INC_ItmBat)--???
/// Debug: w ##class(BILL.CES.BL.Export).GetINCItmBatData("4434||2",100).Read()
ClassMethod GetINCItmBatData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	
	set tabName="INC_ItmBat"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" ((INCIB_INCI_ParRef="_+$p(stIndex,"||",1)_" AND INCIB_ChildSub>"_+$p(stIndex,"||",2)_") OR (INCIB_INCI_ParRef>"_+$p(stIndex,"||",1)_"))"
	set condition=condition_" ORDER BY INCIB_INCI_ParRef,INCIB_ChildSub"
	quit ..GetDataByTabName(tabName, queryColumn, condition,2)
}

/// Creator: xiongwang
/// CreatDate: 2020-03-03
/// Description: 39.科室批次库存表信息(INC_ItmLcBt)
/// Debug: w ##class(BILL.CES.BL.Export).GetINCItmLcBtData("3||3||12",25).Read()
ClassMethod GetINCItmLcBtData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	
	set tabName="INC_ItmLcBt"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" ((INCLB_INCIL_ParRef->INCIL_INCI_ParRef="_+$p(stIndex,"||",1)_" AND INCLB_INCIL_ParRef->INCIL_ChildSub="_+$p(stIndex,"||",2)_" AND INCLB_ChildSub>"_+$p(stIndex,"||",3)_")"
	set condition=condition_" OR (INCLB_INCIL_ParRef->INCIL_INCI_ParRef="_+$p(stIndex,"||",1)_" AND INCLB_INCIL_ParRef->INCIL_ChildSub>"_+$p(stIndex,"||",2)_")"
	set condition=condition_" OR (INCLB_INCIL_ParRef->INCIL_INCI_ParRef>"_+$p(stIndex,"||",1)_" ))"
	set condition=condition_" AND INCLB_PhyQty>0"
	set condition=condition_" ORDER BY INCLB_INCIL_ParRef->INCIL_INCI_ParRef,INCLB_INCIL_ParRef->INCIL_ChildSub,INCLB_ChildSub"
	quit ..GetDataByTabName(tabName, queryColumn, condition, 2)
}

/// Creator: xiongwang
/// CreatDate: 2020-03-03
/// Description: 40.科室库存项表信息(INC_ItmLoc)
/// Debug: w ##class(BILL.CES.BL.Export).GetINCItmLocData("4434||2",100).Read()
ClassMethod GetINCItmLocData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	/* 这2个sql运行结果不一致,表结构有个关？？
	SELECT TOP 10 * FROM INC_ItmLoc
	WHERE ((INCIL_INCI_ParRef->INCI_RowId=1 AND INCIL_INCI_ParRef>3)
	OR (INCIL_INCI_ParRef->INCI_RowId>1))

	SELECT TOP 10 * FROM INC_ItmLoc
	WHERE ((INCIL_INCI_ParRef=1 AND INCIL_INCI_ParRef>3)
	OR (INCIL_INCI_ParRef>1))
	*/
	set tabName="INC_ItmLoc"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" ((INCIL_INCI_ParRef->INCI_RowId="_+$p(stIndex,"||",1)_" AND INCIL_ChildSub>"_+$p(stIndex,"||",2)_")"
	set condition=condition_" OR (INCIL_INCI_ParRef->INCI_RowId>"_+$p(stIndex,"||",1)_" ))"
	set condition=condition_" AND INCIL_AvailQty>0"
	set condition=condition_" ORDER BY INCIL_INCI_ParRef->INCI_RowId,INCIL_ChildSub "
	quit ..GetDataByTabName(tabName, queryColumn, condition, 2)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 43.医嘱与医保对照关系父表信息(INSU_TarContrast)
/// Debug: w ##class(BILL.CES.BL.Export).GetINSUTarContrastData().Read()
ClassMethod GetINSUTarContrastData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="INSU_TarContrast"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" INTCT_Rowid >"_(+stIndex)
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 44.医嘱与医保对照关系子表信息(INSU_TarItems)
/// Debug: w ##class(BILL.CES.BL.Export).GetINSUTarItemsData().Read()
ClassMethod GetINSUTarItemsData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="INSU_TarItems"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" INTIM_Rowid >"_(+stIndex)
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 45.诊断类别代码信息(MRC_DiagnosType)
/// Debug: w ##class(BILL.CES.BL.Export).GetMRCDiagnosTypeData().Read()
ClassMethod GetMRCDiagnosTypeData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="MRC_DiagnosType"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" DTYP_RowId >"_(+stIndex)
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 46.诊断代码信息(MRC_ICDDx)
/// Debug: w ##class(BILL.CES.BL.Export).GetMRCICDDxData(1,10).Read()
ClassMethod GetMRCICDDxData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set CurDate=$zd(+$h,3)
	set tabName="MRC_ICDDx"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" MRCID_RowId >"_(+stIndex)
	set condition=condition_" AND MRCID_DateActiveFrom<='"_CurDate_"'"
	set condition=condition_" AND (MRCID_DateActiveTo>='"_CurDate_"' OR MRCID_DateActiveTo IS NULL )"
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 47.诊断别名信息(MRC_ICDAlias)
/// Debug: w ##class(BILL.CES.BL.Export).GetMRCICDAliasData().Read()
ClassMethod GetMRCICDAliasData(stIndex As %String, expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set CurDate=$zd(+$h,3)
	set ParRef=+$p(stIndex,"||",1)
	set Childsub=+$p(stIndex,"||",2)
	set ParRef=$case(ParRef,0:1,:ParRef)
	set tabName="MRC_ICDAlias"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" ((ALIAS_ParRef="_ParRef_" AND ALIAS_Childsub>"_Childsub_") OR (ALIAS_ParRef>"_ParRef_"))"
	set condition=condition _" order by ALIAS_ParRef,ALIAS_Childsub"
	quit ..GetDataByTabName(tabName, queryColumn, condition, 2)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 48.医嘱大类接收科室信息(OEC_OrdCatRecLoc)
/// Debug: w ##class(BILL.CES.BL.Export).GetOECOrdCatRecLocData().Read()
ClassMethod GetOECOrdCatRecLocData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	//set expNum=1
	set ParRef=+$p(stIndex,"||",1)
	set Childsub=+$p(stIndex,"||",2)
	set ParRef=$case(ParRef,0:1,:ParRef)
	set tabName="OEC_OrdCatRecLoc"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" ((RL_ParRef="_ParRef_" AND RL_Childsub>"_Childsub_") OR (RL_ParRef>"_ParRef_"))"
	set condition=condition_" order by RL_ParRef,RL_Childsub"
	quit ..GetDataByTabName(tabName, queryColumn, condition, 2)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 49.医嘱大类(OEC_OrderCategory)
/// Debug: w ##class(BILL.CES.BL.Export).GetOECOrderCategoryData().Read()
ClassMethod GetOECOrderCategoryData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="OEC_OrderCategory"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" ORCAT_RowId >"_(+stIndex)
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 50.医嘱状态表信息(OEC_OrderStatus)
/// Debug: w ##class(BILL.CES.BL.Export).GetOECOrderStatusData().Read()
ClassMethod GetOECOrderStatusData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="OEC_OrderStatus"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" OSTAT_RowId >"_(+stIndex)
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 51.医嘱优先级表信息(OEC_Priority)
/// Debug: w ##class(BILL.CES.BL.Export).GetOECPriorityData().Read()
ClassMethod GetOECPriorityData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="OEC_Priority"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" OECPR_RowId >"_(+stIndex)
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 52.收费类别信息(PAC_AdmReason)
/// Debug: w ##class(BILL.CES.BL.Export).GetPACAdmReasonData().Read()
ClassMethod GetPACAdmReasonData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="PAC_AdmReason"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" REA_RowId >"_(+stIndex)
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 53.病人来源(PAC_AdmSource)
/// Debug: w ##class(BILL.CES.BL.Export).GetPACAdmSourceData(1,2).Read()
ClassMethod GetPACAdmSourceData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="PAC_AdmSource"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" ADSOU_RowId >"_(+stIndex)
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 54.科室类型信息(PAC_AdmTypeLocation)
/// Debug: w ##class(BILL.CES.BL.Export).GetPACAdmTypeLocationData().Read()
ClassMethod GetPACAdmTypeLocationData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="PAC_AdmTypeLocation"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" ADMLOC_RowId >"_(+stIndex)
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 55.就诊类型(PAC_EpisodeSubType)
/// Debug: w ##class(BILL.CES.BL.Export).GetPACEpisodeSubTypeData().Read()
ClassMethod GetPACEpisodeSubTypeData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="PAC_EpisodeSubType"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" SUBT_RowId >"_(+stIndex)
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 56.疗程表信息(PHC_Duration)
/// Debug: w ##class(BILL.CES.BL.Export).GetPHCDurationData().Read()
ClassMethod GetPHCDurationData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="PHC_Duration"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" PHCDU_RowId >"_(+stIndex)
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 57.药品等效单位信息(PHC_FormDoseEquiv)--????
/// Debug: w ##class(BILL.CES.BL.Export).GetPHCFormDoseEquivData("",5).Read()
ClassMethod GetPHCFormDoseEquivData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="PHC_FormDoseEquiv"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" ((EQ_ParRef->PHCDF_PHCD_ParRef="_+$p(stIndex,"||",1)_" AND EQ_ParRef->PHCDF_ChildSub="_+$p(stIndex,"||",2)_" AND EQ_Childsub>"_+$p(stIndex,"||",3)_")"
	set condition=condition_" OR (EQ_ParRef->PHCDF_PHCD_ParRef="_+$p(stIndex,"||",1)_" AND EQ_ParRef->PHCDF_ChildSub>"_+$p(stIndex,"||",2)_")"
	set condition=condition_" OR (EQ_ParRef->PHCDF_PHCD_ParRef>"_+$p(stIndex,"||",1)_" ))"
	set condition=condition_" order by EQ_ParRef->PHCDF_PHCD_ParRef,EQ_ParRef->PHCDF_ChildSub,EQ_Childsub"
	quit ..GetDataByTabName(tabName, queryColumn, condition,2)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 58.医嘱频次表信息(PHC_Freq)
/// Debug: w ##class(BILL.CES.BL.Export).GetPHCFreqData().Read()
ClassMethod GetPHCFreqData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="PHC_Freq"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" PHCFR_RowId >"_(+stIndex)
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 59.医嘱药品用法信息(PHC_Instruc)
/// Debug: w ##class(BILL.CES.BL.Export).GetPHCInstrucData().Read()
ClassMethod GetPHCInstrucData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="PHC_Instruc"
	set queryColumn=" TOP "_(+expNum)
	set queryColumn=queryColumn_" * "
	set condition=" PHCIN_RowId >"_(+stIndex)
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-10-23
/// Description: 60.医生科室信息(RB_Resource)
/// Debug: w ##class(BILL.CES.BL.Export).GetRBResourceData(1,1).Read()
ClassMethod GetRBResourceData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="RB_Resource"
	set queryColumn=" TOP "_(+expNum)
    set queryColumn=queryColumn_" * "
    
	set condition=" RES_RowId1 >"_(+stIndex)
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator：xiongwang
/// CreatDate：2020-10-23
/// Description: 61.用户信息(SS_User)
/// Debug: w ##class(BILL.CES.BL.Export).GetSSUserData(1,1).Read()
ClassMethod GetSSUserData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="SS_User"
	set queryColumn=" TOP "_(+expNum) _" SSUSR_RowId,SSUSR_Initials,SSUSR_Name,SSUSR_Password AS SSUSR_Password,SSUSR_DefaultDept_DR,SSUSR_CareProv_DR AS SSUSR_CTPCP_DR,SSUSR_CareProv_DR->CTPCP_CarPrvTp_DR->CTCPT_InternalType As  SSUSR_InternalType"
	set condition=" SSUSR_RowId >"_(+stIndex)
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-03-03
/// Description: 62.院区表(CT_Hospital)
/// Debug: w ##class(BILL.CES.BL.Export).GetCTHospitalData(1,2).Read()
ClassMethod GetCTHospitalData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="CT_Hospital"
	set queryColumn=" TOP "_(+expNum) _" * "
	set condition=" HOSP_RowId >"_(+stIndex)	
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-03-03
/// Description: 63.东华表结构名称与中文对照表(BDP_TableList)
/// Debug: w ##class(BILL.CES.BL.Export).GetBDPTableListData().Read()
ClassMethod GetBDPTableListData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="BDP_TableList"
	set queryColumn=" TOP "_(+expNum) _" * "
	set condition=" ID >"_(+stIndex)	
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-03-03
/// Description: 64.表结构登记子表(BDP_ExceptionHosp)
/// Debug: w ##class(BILL.CES.BL.Export).GetBDPExceptionHospData().Read()
ClassMethod GetBDPExceptionHospData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="BDP_ExceptionHosp"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" ((ExceptionHospParRef="_+$p(stIndex,"||",1)_" AND childsub>"_+$p(stIndex,"||",2)_")"
	set condition=condition_" OR (ExceptionHospParRef>"_+$p(stIndex,"||",1)_" ))"
	set condition=condition_" ORDER BY ExceptionHospParRef,childsub"
	quit ..GetDataByTabName(tabName, queryColumn, condition,2)
}

/// Creator: xiongwang
/// CreatDate: 2020-03-03
/// Description: 65.证据类型表(PAC_CardType)
/// Debug: w ##class(BILL.CES.BL.Export).GetPACCardTypeData().Read()
ClassMethod GetPACCardTypeData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="PAC_CardType"
	set queryColumn=" TOP "_(+expNum) _" * "
	set condition=" CARD_RowId >"_(+stIndex)
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-03-03
/// Description: 66.合同单位表(CT_HealthCareProvider)
/// Debug: w ##class(BILL.CES.BL.Export).GetCTHealthCareProviderData().Read()
ClassMethod GetCTHealthCareProviderData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="CT_HealthCareProvider"
	set queryColumn=" TOP "_(+expNum) _" * "
	set condition=" HCP_RowId>"_stIndex
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-03-03
/// Description: 67.卡表(DHC_CardRef)
/// Debug: w ##class(BILL.CES.BL.Export).GetDHCCardRefData(1,5).Read()
ClassMethod GetDHCCardRefData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="DHC_CardRef"
	set queryColumn=" TOP "_(+expNum) _" * "
	set condition=" CF_RowID >"_(+stIndex)
	set condition=condition_" AND  CF_ActiveFlag='N' and CF_PAPMI_DR>0"
	quit ..GetDataByTabName(tabName, queryColumn, condition)
}

/// Creator: xiongwang
/// CreatDate: 2020-03-03
/// Description: 67.患者信息表(PA_PatMas)
/// Debug: w ##class(BILL.CES.BL.Export).GetPAPatMasData(1,2).Read()
ClassMethod GetPAPatMasData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set stream=##class(%Stream.GlobalCharacter).%New()
	do stream.MoveToEnd()
	set listNum=0
	set endIndex=-1
	
	set num=0
	set papmi=stIndex
	for  set papmi=$o(^PAPER(papmi)) quit:(papmi="")||(listNum>=expNum)  do
	.quit:'$d(^PAPER(papmi,"PAT"))
	.quit:'$d(^PAPER(papmi,"ALL"))
	.quit:(+papmi<0)
	.set active=$p($g(^PAPER(papmi,"PAT",1)),"^",6)
	.quit:(active'="Y")
	.set listNum=listNum+1
	.set endIndex=papmi	
	.set patNo=$p(^PAPER(papmi,"PAT",1),"^",2)
	.set patName=$p(^PAPER(papmi,"ALL"),"^",1)
	.set sexDR=$p(^PAPER(papmi,"ALL"),"^",7)
	.set patDOB=$p(^PAPER(papmi,"ALL"),"^",6)
	.set:(patDOB'="") patDOB=$zd(patDOB,3)
	.set socialStatusDR=$p($g(^PAPER(papmi,"PER",1)),"^",10)
	.set patTelH=$p($g(^PAPER(papmi,"PER",1)),"^",11)
	.set:$l(patTelH)>11 patTelH=""		//长度大于11 位，不导
	.set patDVAnumber=$p($g(^PAPER(papmi,"PAT",3)),"^",6)
	.set patCardTypeDR=$p($g(^PAPER(papmi,"PAT",3)),"^",7)
	.set patHCPDR=$p($g(^PAPER(papmi,"PER",4)),"^",17)
	.set hospDR=$p($g(^PAPER(papmi,"PER",5)),"^",51)
	.set updateUser=$p($g(^PAPER(papmi,"PER",4)),"^",7)
	.set updateDate=$p($g(^PAPER(papmi,"PER",5)),"^",2)
	.set:(updateDate'="") updateDate=$zd(updateDate,3)
	.set updateTime=$p($g(^PAPER(papmi,"PER",5)),"^",3)
	.set updateTime=##class(websys.Conversions).TimeLogicalToHtml(updateTime,1) 
	.set newFlag="N"
	.set importFlag="N"
	.set Data=$lb(papmi,patNo,patName,sexDR,patDOB,socialStatusDR,patTelH,patDVAnumber,patCardTypeDR,patHCPDR,updateUser,hospDR,updateDate,updateTime,newFlag,importFlag)
	.for index=1:1:$ll(Data) do
	..//将Data中的'符号替换，否则影响sql语句
	..set Data=$lu(Data,index,##class(BILL.CES.COM.Util).EscapeMysqlStr($lg(Data,index)))	
	.set sql="INSERT INTO PA_PatMas (PAPMI_RowId1,PAPMI_No,PAPMI_Name,PAPMI_Sex_DR,PAPMI_DOB,PAPMI_SocialStatus_DR,PAPMI_TelH,PAPMI_DVAnumber,PAPMI_CardType_DR ,PAPMI_HCP_DR,PAPMI_UpdateUser,PAPMI_Hosp_DR,PAPMI_UpdateDate,PAPMI_UpdateTime,PAPMI_NewFlag,PAPMI_Import) "
	.set sql=sql_" VALUES ("_$lts(Data,",")_");"
	.do stream.Write(sql)
	
	do stream.Write("^"_endIndex)	
	
	quit stream
}

/// Creator: xiongwang
/// CreatDate: 2020-03-03
/// Description: 68.(BDP_MappingHosp)
/// Debug: w ##class(BILL.CES.BL.Export).GetBDPMappingHospData(0,10000).Read()
ClassMethod GetBDPMappingHospData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	
	set tabName="BDP_MappingHosp"
	set queryColumn=" TOP "_(+expNum) _" * "
	set condition=" ID >"_(+stIndex)
	set condition=condition_" AND  BDPMPH_TableName IN ('Bill_Com_TarPara','DHC_TarItemPrice','Bill_Com_TarFactor','APC_VendCat','MRC_ICDDx')"
	quit ..GetDataByTabName(tabName, queryColumn, condition)
	
	/*
	set stream=##class(%Stream.GlobalCharacter).%New()
	do stream.MoveToEnd()
	set listNum=0
	set endIndex=-1
	set tmpArry("Bill_Com_TarPara")=""
	set tmpArry("DHC_TarItemPrice")=""
	set tmpArry("Bill_Com_TarFactor")=""
	set tmpArry("APC_VendCat")=""
	set tmpArry("MRC_ICDDx")=""
	set tableName=""
	for  set tableName=$o(tmpArry(tableName)) quit:(tableName="")||(listNum>=expNum)   do
	.set rowId=stIndex
	.for  set rowId=$o(^User.BDPMappingHospI("TableRef",tableName,rowId)) quit:(rowId="")||(listNum>=expNum)   do
	..quit:'$d(^User.BDPMappingHospD(rowId))
	
	set rowId=stIndex
	for  set rowId=$o(^User.BDPMappingHospD(rowId)) quit:(rowId="")||(listNum>=expNum)  do
	.quit:'$d(^User.BDPMappingHospD(rowId))
	.quit:121
	.set listNum=listNum+1
	.set endIndex=rowId		//结束索引
	.set DataList=$g(^User.BDPMappingHospD(rowId))
	.set Data=$lb(rowId,$lg(DataList,2),$lg(DataList,3),$lg(DataList,4))
	.for index=1:1:$ll(Data) do
	..//将Data中的'符号替换，否则影响sql语句
	..set Data=$lu(Data,index,##class(BILL.CES.COM.Util).EscapeMysqlStr($lg(Data,index)))	
	
	.set sql="INSERT INTO BDP_MappingHosp (ID, BDPMPH_TableName, BDPMPH_DataReference, BDPMPH_Hospital)"
	.set sql=sql_" VALUES ("_$lts(Data,",")_");"
	.do stream.Write(sql)
	
	do stream.Write("^"_endIndex)
	
	quit stream
	*/
}

/// Creator: xiongwang
/// CreatDate: 2020-03-03
/// Description: 69.药学项剂型(PHC_DrgForm)
/// Debug: w ##class(BILL.CES.BL.Export).GetPHCDrgFormData(1,2).Read()
ClassMethod GetPHCDrgFormData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="PHC_DrgForm"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" ((PHCDF_PHCD_ParRef->PHCD_RowId="_+$p(stIndex,"||",1)_" AND PHCDF_ChildSub>"_+$p(stIndex,"||",2)_")"
	set condition=condition_" OR (PHCDF_PHCD_ParRef->PHCD_RowId>"_+$p(stIndex,"||",1)_" ))"
	set condition=condition_" ORDER BY PHCDF_PHCD_ParRef,PHCDF_ChildSub"
	quit ..GetDataByTabName(tabName, queryColumn, condition,2)
}

/// Creator: xiongwang
/// CreatDate: 2020-03-03
/// Description: 70.用户登录科室表(ss_userotherlogonloc)
/// Debug: w ##class(BILL.CES.BL.Export).GetSSUserOtherLogonLocData("",2).Read()
ClassMethod GetSSUserOtherLogonLocData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="ss_userotherlogonloc"
	set queryColumn=" top "_(+expNum) 
	set queryColumn= queryColumn_" * "
	set condition=" ((OTHLL_ParRef="_+$p(stIndex,"||",1)_" AND OTHLL_Childsub>"_+$p(stIndex,"||",2)_")"
	set condition=condition_" OR (OTHLL_ParRef>"_+$p(stIndex,"||",1)_" ))"
	set condition=condition_" ORDER BY OTHLL_ParRef,OTHLL_Childsub"
	quit ..GetDataByTabName(tabName,queryColumn,condition,2)
}

/// Creator: xiongwang
/// CreatDate: 2020-03-03
/// Description: 71.用户登录科室表(ARC_ItemHosp)
/// Debug: w ##class(BILL.CES.BL.Export).GetARCItemHospData("",2).Read()
ClassMethod GetARCItemHospData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
	set tabName="ARC_ItemHosp"
	set queryColumn=" TOP "_(+expNum) 
	set queryColumn=queryColumn_" * "
	set condition=" ((HOSP_ParRef->ARCIM_Subscript="_+$p(stIndex,"||",1)_" AND HOSP_ParRef->ARCIM_Version="_+$p(stIndex,"||",2)_" AND HOSP_Childsub>"_+$p(stIndex,"||",3)_")"
	set condition=condition_" OR (HOSP_ParRef->ARCIM_Subscript="_+$p(stIndex,"||",1)_" AND HOSP_ParRef->ARCIM_Version>"_+$p(stIndex,"||",2)_")"
	set condition=condition_" OR (HOSP_ParRef->ARCIM_Subscript>"_+$p(stIndex,"||",1)_" ))"
	set condition=condition_" order by HOSP_ParRef->ARCIM_Subscript,HOSP_ParRef->ARCIM_Version,HOSP_Childsub"
	quit ..GetDataByTabName(tabName, queryColumn, condition,2)
}

/// Creator: xiongwang
/// CreatDate: 2020-03-03
/// Description: 71.字典配置同步(dicdata)
/// Debug: w ##class(BILL.CES.BL.Export).GetDicData().Read()
ClassMethod GetDicData(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
    set stream=##class(%Stream.GlobalCharacter).%New()
    do stream.MoveToEnd()
    set endIndex=-1
    if (+stIndex>0){
	    do stream.Write("^-1")
	    quit stream
    }
    ;更新表结构
    ;set stream=##class(BILL.CES.BL.Export).UPMYSQLDB()
    
    set curDateTime=$zdt($h,3,1)
    
    ;获取平台配置是否开启医院级别授权
    set BDPHospAutflag = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut")
    set condition="`type`='GlobalCfg' and `code`='BDPHospAut' and (`hospital`=0 or `hospital` = null)"
    set sql="UPDATE `ces_db`.`dicdata` set `concode`='"_BDPHospAutflag_ "' ,`update_datetime`='"_curDateTime_ "' where "_condition_";"
    do stream.Write(sql)
    
    ;更新登记号长度,该配置全局的，没有按院区来？
    set condition="`type`='JFOPPara' and `code`='PAPERNOLen' and (`hospital`=0 or `hospital` = null)"
    set patLen=+$p(^CF("PATCF",1,3),"^",5)
    set sql="UPDATE `ces_db`.`dicdata` set `concode`='"_patLen_ "' ,`update_datetime`='"_curDateTime_ "' where "_condition_";"
    do stream.Write(sql)
    
    ;更新药品取集团化医院标志
    set groupFlag=##Class(web.DHCSTCOMMPARA).GetGroupFlag()
    set condition="`type`='GlobalCfg' and `code`='DrugGroupFlag' and (`hospital`=0 or `hospital` = null)"
    set patLen=+$p(^CF("PATCF",1,3),"^",5)
    set sql="UPDATE `ces_db`.`dicdata` set `concode`='"_groupFlag_ "' ,`update_datetime`='"_curDateTime_ "' where "_condition_";"
    do stream.Write(sql)
    
    ;根据院区更新
    set hospId=0
 	while($o(^CT("HOSP",hospId))){
	 	set hospId=$o(^CT("HOSP",hospId))
	 	set dateFrom=$p(^CT("HOSP",hospId),"^",9)
	 	set dateTo=$p(^CT("HOSP",hospId),"^",10)
	 	continue:(dateFrom>+$h)
	 	continue:((dateTo'="")&&(dateTo<=+$h))
	 	;分币误差
	 	set OPFCRowID=##class(web.DHCOPConfig).GetSOPFCfgId(hospId)
		if (OPFCRowID>0){
			set roundNum=+$p($g(^DHCSOPFCON(OPFCRowID)),"^",16)
			;删除
			set sql="delete from `ces_db`.`dicdata` where `type`='JFOPPara' and `code`='RoundDownNum' and `hospital`='"_hospId_"';"
			do stream.Write(sql)
			;插入
			set data=$lb("JFOPPara", "RoundDownNum", "分币误差", "设置计算现金舍人方式(0:不舍入,5:四舍五入,6:五舍六入)", curDateTime, "", "Y", curDateTime, "", hospId, roundNum, "0", "JFOPPara")
			for index=1:1:$ll(data){
				set data=$lu(data,index,##class(BILL.CES.COM.Util).EscapeMysqlStr($lg(data,index)))
			}
			set sql="INSERT INTO `ces_db`.`dicdata` (`type`, `code`, `desc`, `demo`, `create_datetime`, `create_user`, `activeflag`, `update_datetime`, `update_user`, `hospital`, `concode`, `condesc`, `relation_dic`)"
    		set sql=sql_" VALUES ("_$lts(data,",")_");"
    		do stream.Write(sql)
		}
		
		;药品批次价
		set methodExits=##class(%Dictionary.MethodDefinition).%ExistsId("web.DHCSTINTERFACE||GetRpRule")
		if (methodExits=1){
			set batchFlag=##class(web.DHCSTINTERFACE).GetRpRule(hospId)
			set batchFlag=$case(batchFlag,3:1,:0)
			;删除
			set sql="delete from `ces_db`.`dicdata` where `type`='JFOPPara' and `code`='AdjPriceBatchFlag' and `hospital`='"_hospId_"';"
			do stream.Write(sql)
			;插入
			set data=$lb("JFOPPara", "AdjPriceBatchFlag", "药品是否走批次价", "0:统一价，1:批次价", curDateTime, "", "Y", curDateTime, "", hospId, batchFlag, "0", "JFOPPara")
			for index=1:1:$ll(data){
				set data=$lu(data,index,##class(BILL.CES.COM.Util).EscapeMysqlStr($lg(data,index)))
			}
			set sql="INSERT INTO `ces_db`.`dicdata` (`type`, `code`, `desc`, `demo`, `create_datetime`, `create_user`, `activeflag`, `update_datetime`, `update_user`, `hospital`, `concode`, `condesc`, `relation_dic`)"
    		set sql=sql_" VALUES ("_$lts(data,",")_");"
    		do stream.Write(sql)
			
		}
		;物资批次价
		set methodExits=##class(%Dictionary.MethodDefinition).%ExistsId("web.DHCSTMHUI.DHCSTMSERVICE||GetBatSpFlag")
		if (methodExits=1){
			set batchFlag=##class(web.DHCSTMHUI.DHCSTMSERVICE).GetBatSpFlag(hospId)
			;删除
			set sql="delete from `ces_db`.`dicdata` where `type`='JFOPPara' and `code`='MatbatchFlag' and `hospital`='"_hospId_"';"
			do stream.Write(sql)
			;插入
			set data=$lb("JFOPPara", "MatbatchFlag", "材料是否走批次价", "0:统一价,1:批次价", curDateTime, "", "Y", curDateTime, "", hospId, batchFlag, "0", "JFOPPara")
			for index=1:1:$ll(data){
				set data=$lu(data,index,##class(BILL.CES.COM.Util).EscapeMysqlStr($lg(data,index)))
			}
			set sql="INSERT INTO `ces_db`.`dicdata` (`type`, `code`, `desc`, `demo`, `create_datetime`, `create_user`, `activeflag`, `update_datetime`, `update_user`, `hospital`, `concode`, `condesc`, `relation_dic`)"
    		set sql=sql_" VALUES ("_$lts(data,",")_");"
    		do stream.Write(sql)
		}
		;缺省收费类别DHC_TarPara
		set cfgId=##class(web.DHCBillCommon).GetTarParaId(hospId)
		if (cfgId>0){
			set insType=$p(^DHCTarC("CF",cfgId),"^",3)
			;删除
			set sql="delete from `ces_db`.`dicdata` where `type`='DHC_TarPara' and `code`='TM_DefaultInsType' and `hospital`='"_hospId_"';"
			do stream.Write(sql)
			;插入
			set data=$lb("DHC_TarPara", "TM_DefaultInsType", "缺省收费类别", "", curDateTime, "", "Y", curDateTime, "", hospId, insType, "0", "JFOPPara")
			for index=1:1:$ll(data){
				set data=$lu(data,index,##class(BILL.CES.COM.Util).EscapeMysqlStr($lg(data,index)))
			}
			set sql="INSERT INTO `ces_db`.`dicdata` (`type`, `code`, `desc`, `demo`, `create_datetime`, `create_user`, `activeflag`, `update_datetime`, `update_user`, `hospital`, `concode`, `condesc`, `relation_dic`)"
    		set sql=sql_" VALUES ("_$lts(data,",")_");"
    		do stream.Write(sql)
		}
		;缺省缺省折扣方式
		if (cfgId>0){
			set discFlag=$p(^DHCTarC("CF",cfgId),"^",4)
			;删除
			set sql="delete from `ces_db`.`dicdata` where `type`='DHC_TarPara' and `code`='TM_DiscountType' and `hospital`='"_hospId_"';"
			do stream.Write(sql)
			;插入
			set data=$lb("DHC_TarPara", "TM_DiscountType", "缺省缺省折扣方式", "", curDateTime, "", "Y", curDateTime, "", hospId, discFlag, "0", "JFOPPara")
			for index=1:1:$ll(data){
				set data=$lu(data,index,##class(BILL.CES.COM.Util).EscapeMysqlStr($lg(data,index)))
			}
			set sql="INSERT INTO `ces_db`.`dicdata` (`type`, `code`, `desc`, `demo`, `create_datetime`, `create_user`, `activeflag`, `update_datetime`, `update_user`, `hospital`, `concode`, `condesc`, `relation_dic`)"
    		set sql=sql_" VALUES ("_$lts(data,",")_");"
    		do stream.Write(sql)
		}
 	}

    set DocConfig=##Class(DHCDoc.Interface.StandAlone.Export).GetDocDicData()
    do stream.Write(DocConfig)
    do stream.Write("^1")
    quit stream
}

/// Creator: xiongwang
/// CreatDate: 2020-03-03
/// Description: 直接通过sql导出(输出第一列必须为主键)
/// Debug: w ##class(BILL.CES.BL.Export).GetDataByTabName().Read()
ClassMethod GetDataByTabName(tabName, queryColumn, condition, priKeyCol As %Integer = 1)
{
	set stream=##class(%Stream.GlobalCharacter).%New()
	do stream.MoveToEnd()
	set endIndex=-1
	
	set tabName=" "_tabName_" "
	set query="SELECT "_queryColumn_" FROM "_tabName _" WHERE " _condition
	set result=$SYSTEM.SQL.Execute(query,1)
	set sqlhead="INSERT INTO "_tabName
	set cols=""
	b ;query
	set metadata=result.%GetMetadata()
	if (metadata=""){
		do stream.Write("^"_endIndex)
		quit stream
	}
	
	set colsList=metadata.columns
	set colsnum=metadata.columns.Count()
	for i=1:1:colsnum {
		set colName=colsList.GetAt(i).colName
   		set cols=cols_$lb(colName)
	}
    set colsStr="("_$lts(cols,",")_")"

	while result.%Next() {
		set Data=""
		set colnum=result.%ResultColumnCount
		set tmpIndex=result.%GetData(priKeyCol)
		if (+tmpIndex'=0) set endIndex=tmpIndex
		continue:(+tmpIndex=0)	//有非表中的无效数据
		
		for i=1:1:colnum {
			set value=result.%GetData(i)
			set value=##class(BILL.CES.COM.Util).EscapeMysqlStr(value)
			set Data=Data_$lb(value)
		}
		
		set valuesStr="("_$lts(Data,",")_")"
		set sql=sqlhead_colsStr_" VALUES "_valuesStr_";"
		do stream.Write(sql)
	}
	do stream.Write("^"_endIndex)
	quit stream
}

/// Creator: xiongwang
/// CreatDate: 2022-08-23
/// Description: 更新mysql数据库(用于已部署的项目)
/// Debug: w ##class(BILL.CES.BL.Export).UPMYSQLDB().Read()
ClassMethod UPMYSQLDB() As %Stream.GlobalCharacter
{
	set stream=##class(%Stream.GlobalCharacter).%New()
    do stream.MoveToEnd()
    
    /*********2022-08-23 更新实现多院区,新增医生站配置 ********/
	;新增`arc_itemhosp`表 
	set sql="CREATE TABLE IF NOT EXISTS `arc_itemhosp` ("
	  set sql=sql_"`HOSP_ParRef` varchar(36) NOT NULL,"
	  set sql=sql_"`HOSP_RowId` varchar(512) DEFAULT NULL,"
	  set sql=sql_"`HOSP_Childsub` double NOT NULL,"
	  set sql=sql_"`HOSP_Hospital_DR` int(10) DEFAULT NULL,"
	  set sql=sql_"PRIMARY KEY (`HOSP_ParRef`,`HOSP_Childsub`),"
	  set sql=sql_"UNIQUE KEY `DataMaster` (`HOSP_ParRef`,`HOSP_Childsub`),"
	  set sql=sql_"KEY `REFERENCE__HOSP_Hospital_DR` (`HOSP_Hospital_DR`),"
	  set sql=sql_"CONSTRAINT `REFERENCE__HOSP_Hospital_DR` FOREIGN KEY (`HOSP_Hospital_DR`) REFERENCES `ct_hospital` (`HOSP_RowId`)"
	set sql=sql_") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ;"
	do stream.Write(sql)
	
	;插入到同步表
	set sql="INSERT IGNORE INTO `dhc_synctable` VALUES ('79', 'ARC_ItemHosp', 'ARCData', '', '2022/08/23 11:28:27', '2022/08/23 11:28:27', '0', 'BILL.CES.BL.Export', 'GetARCItemHospData', 'N', 'Y', '医嘱项医院关联', null);"
	do stream.Write(sql)
	
	;新增一个医生站配置
	set sql="INSERT INTO `ces_db`.`dicdata`(`type`, `code`, `desc`, `demo`, `create_datetime`, `create_user`, `activeflag`, `update_datetime`, `update_user`, `hospital`, `concode`, `condesc`, `relation_dic`) "
	set sql=sql_"SELECT 'JFOPPara', 'OrdLookUpLimit', '诊疗页面医嘱检索限制', '为优化检索速度,当检索条件长度小于3时,限制得到医嘱检索结果的数量,配置为0时,不限制', '2022-08-19 11:34:15', NULL, 'Y', NULL, NULL, NULL, '100', NULL, NULL  "
	set sql=sql_"from DUAL  "
	set sql=sql_"where not exists(select 1 from `ces_db`.`dicdata` where `type`='JFOPPara' and `code` = 'OrdLookUpLimit'); "
	do stream.Write(sql)
	
	quit stream
}

}
