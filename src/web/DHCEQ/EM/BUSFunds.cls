Class web.DHCEQ.EM.BUSFunds Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Modified By HZY 2012-02-24 HZY0023
/// Desc:增加'研究课题'的输出显示.
/// ---------------------------------------------------------------------
/// 获取设备的资金来源信息
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSFunds","GetFunds",0,60,8000,"Y")
Query GetFunds(FromType, FromID, FundsAmount, DataChangeFlag As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEquipDR:%String,TFundsTypeDR:%String,TFundsType:%String,TFee:%String,TCheckListDR:%String,TOldRowDR:%String,TOperFlag:%String,TStatus:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TNoDR:%String,TNo:%String,TSource:%String,TIssueDR:%String,TIssue:%String,TDepreTotal:%String,TPreFundsFee:%String,TCurFundsFee:%String,TPreDepreTotalFee:%String,TCurDepreTotalFee:%String,TRow:%String,THold1:%String,TFinaceItemDR:%String,TFunctionCatDR:%String,TFinaceItem:%String,TFunctionCat:%String,TProportion:%String")
{
}

ClassMethod GetFundsExecute(ByRef qHandle As %Binary, FromType, FromID, FundsAmount, DataChangeFlag As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=0
	
	i ((DataChangeFlag="Y")&&($d(^DHCEQTempFunds(0,"Source",FromType,FromID)))) d
	.s FundsTypeDR=""
	.f  s FundsTypeDR=$o(^DHCEQTempFunds(0,"Source",FromType, FromID,FundsTypeDR)) q:FundsTypeDR=""  d
	..s RowNo=0
	..f  s RowNo=$o(^DHCEQTempFunds(0,"Source",FromType, FromID,FundsTypeDR,RowNo)) q:RowNo=""  d
	...s FundsVal=$g(^DHCEQTempFunds(0,"Source",FromType, FromID,FundsTypeDR,RowNo))
	...q:$p(FundsVal,"^",10)="Y"
	...d ResetVariablesGetFunds
	...s TFundsType=$p($g(^DHCEQCCode("DHCEQCFundsType",FundsTypeDR)),"^",2)
	...s TFundsTypeDR=FundsTypeDR
	...s FTInvalidFlag=$p($g(^DHCEQCCode("DHCEQCFundsType",FundsTypeDR)),"^",4)
	...s TRowID=$Piece(FundsVal,"^",22)
	...s TEquipDR=$p(FundsVal,"^",1)
	...s TFee=$p(FundsVal,"^",3)
	...s TCheckListDR=$p(FundsVal,"^",4)
	...s TOldRowDR=$p(FundsVal,"^",5)
	...s TOperFlag=$p(FundsVal,"^",6)
	...s THold1=$p(FundsVal,"^",11)
	...s TDepreTotal=+$Piece(FundsVal,"^",13)
	...s TPreFundsFee=##Class(web.DHCEQCommon).FormatNumber($Piece(FundsVal,"^",18),"",2)
	...s TPreDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber($Piece(FundsVal,"^",19),"",2)
	...s TNoDR=$p(FundsVal,"^",16)
	...s TIssueDR=$p(FundsVal,"^",17)
	...s TFinaceItemDR=$Piece(FundsVal,"^",20)
	...s TFunctionCatDR=$Piece(FundsVal,"^",21)
	...i TFinaceItemDR'="" s TFinaceItem=$p($g(^DHCEQCCode("DHCEQCFinaceItem",TFinaceItemDR)),"^",2)
	...i TFunctionCatDR'="" s TFunctionCat=$p($g(^DHCEQCCode("DHCEQCFunctionCat",TFunctionCatDR)),"^",2)
	...s TNo=$Piece(FundsVal,"^",23)
	...;i TNoDR'=""	s TNo=$p($g(^DHCEQFundsRecord(TNoDR)),"^",2)
	...i TIssueDR'="" s TIssue=$p($g(^DHCEQIssue(TIssueDR)),"^",3)
	...d OutputRowGetFunds
	e  d
	.d BuildDataGetFunds
	Quit $$$OK
	
BuildDataGetFunds
	i (FromID="")||(FromType="") q
	i FundsAmount'="" s FundsAmount=##Class(web.DHCEQCommon).Replace(FundsAmount,",","")
	;非调账,金额必须大于0
	i ((FundsAmount<=0)&&(FromType'="7")) q
	s SelfFundsFlag=##class(web.DHCEQCommon).GetSysInfo("990015")
	s UseFinaceItemType=+##class(web.DHCEQCommon).GetSysInfo("990076")
	/*********************************************************/
	s SelfFunds=0
	;Modified By JDL 2012-2-15 JDL0116
	s SelfFlag=0
	i $D(^DHCEQFunds("0","Source",FromType,FromID)) s SelfFlag=1
	s FTRowID=0
	f  s FTRowID=$o(^DHCEQCCode("DHCEQCFundsType",FTRowID))  q:FTRowID=""  d
	.// Mozy0231	访问资金来源类型
	.s Flag=0
	.i FTRowID'=SelfFundsFlag d		// 非默认资金来源
	..i $d(^DHCEQCCode("DHCEQCGroupFundsType","0","Group",%session.Get("LOGON.GROUPID"))) d
	...s Flag=1		;存在安全组设置则默认不能访问
	...i $d(^DHCEQCCode("DHCEQCGroupFundsType","0","Group",%session.Get("LOGON.GROUPID"),FTRowID)) s Flag=0
	.q:Flag'=0
	.d ResetVariablesGetFunds
	.s TFundsType=$p($g(^DHCEQCCode("DHCEQCFundsType",FTRowID)),"^",2)
	.s TFundsTypeDR=FTRowID
	.s FTInvalidFlag=$p($g(^DHCEQCCode("DHCEQCFundsType",FTRowID)),"^",4)
	.;Modified By JDL 2012-2-15 JDL0116
	.s FundsInfo=##Class(web.DHCEQ.EM.BUSFunds).GetSourceFunds(FromType,FromID, FundsAmount, FTRowID, SelfFlag)
	.s Length=$l(FundsInfo,"&")
	.for i=1:1:Length d
	..s oneFundsInfo=$p(FundsInfo,"&",i)
	..q:oneFundsInfo=""
	..s TFee=+$p(oneFundsInfo,"^",1)
	..s rowid=$p(oneFundsInfo,"^",2)
	..s TSource=$p(oneFundsInfo,"^",3)
	..s TDepreTotal=+$p(oneFundsInfo,"^",4)	;///Mozy0148
	..s TFinaceItemDR=$Piece(oneFundsInfo,"^",5)
	..s TFunctionCatDR=$Piece(oneFundsInfo,"^",6)
	..q:(rowid="")&&(FTInvalidFlag="Y")
	..
	..i FromType=7  d	//调账记录增加变动前,变动后资金来源及累计折旧 DJ0135
	...s (TPreFundsFee,TPreDepreTotalFee)=0
	...s EQRowID=$p($g(^DHCEQChangeAccount(FromID)),"^",1)
	.../////根据rowid来看是否需要取当前资金来源下多个核算项目记录
	...i rowid="" d
	....s FRowID=$o(^DHCEQFunds("0","EquipType",EQRowID,FTRowID,0))
	....//取到这个资金来源类型下的第一条记录,用于控制是否再输出
	....//Modefied by zc0107 20211115 修改资金来源错误 begin
	....;s FirstFRowID=$o(^DHCEQFunds("0","EquipType",EQRowID,FTRowID,0))
	....s FirstFRowID=##class(web.DHCEQ.EM.BUSFunds).GetFirstFRowID(EQRowID,FTRowID)
	....//Modefied by zc0107 20211115 修改资金来源错误 end
	....q:FirstFRowID=""
	....s FRowID=""
	....f  s FRowID=$o(^DHCEQFunds("0","EquipType",EQRowID,FTRowID,FRowID),-1) q:FRowID=""  d
	.....q:+$p($g(^DHCEQFunds(FRowID)),"^",3)=0	////modified by ZY0218 2020-04-10
	.....s TFinaceItemDR=$p($g(^DHCEQFunds(FRowID)),"^",20)
	.....s TFunctionCatDR=$p($g(^DHCEQFunds(FRowID)),"^",21)
	.....s TPreFundsFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FRowID)),"^",3),"",2)
	.....s TPreDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FRowID)),"^",13),"",2)
	.....i (FirstFRowID'=FRowID) d
	......d OutputRowGetFunds
	...e  d
	....s TFinaceItemDR=$p($g(^DHCEQFunds(rowid)),"^",20)
	....s TFunctionCatDR=$p($g(^DHCEQFunds(rowid)),"^",21)
	....s FRowID=$o(^DHCEQFunds("0","EquipFinaceItem",EQRowID,FTRowID,+TFinaceItemDR,+TFunctionCatDR,0))
	....s (TPreFundsFee,TPreDepreTotalFee)=0
	....i FRowID'=""  d
	.....s TPreFundsFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FRowID)),"^",3),"",2)
	.....s TPreDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FRowID)),"^",13),"",2)
	..i rowid'=""  d
	...d GetOneFunds
	..d OutputRowGetFunds
	quit
		
GetOneFunds
	s TRowID = rowid
	s gbldata=$g(^DHCEQFunds(TRowID))
	q:gbldata=""
	q:$p(gbldata,"^",10)="Y" 	
	s TEquipDR=$p(gbldata,"^",1)
	s TCheckListDR=$p(gbldata,"^",4)
	s TOldRowDR=$p(gbldata,"^",5)
	//i (FromType=1)&&(TOldRowDR'="") s TSource="改自验收单"	//modified by czf 620104 可改自验收单,入库单,调账单,且验收单,入库单FromType参数相同
	s TOperFlag=$p(gbldata,"^",6)
	s THold1=$p(gbldata,"^",11)		//备注内容
	///Mozy0148
	Set TDepreTotal=+$Piece(gbldata,"^",13)
	;Set THold1=$Piece(gbldata,"^",17)        //modified by czf 2016-12-16
	Set TPreFundsFee=##Class(web.DHCEQCommon).FormatNumber($Piece(gbldata,"^",18),"",2)	//DJ0135
	Set TPreDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber($Piece(gbldata,"^",19),"",2)	//DJ0135
	
	Set TFinaceItemDR=$Piece(gbldata,"^",20)
	Set TFunctionCatDR=$Piece(gbldata,"^",21)
	
	s TNoDR=$p(gbldata,"^",16)
	i TNoDR'=""	s TNo=$p($g(^DHCEQFundsRecord(TNoDR)),"^",2)
	s TIssueDR=$p(gbldata,"^",17)	//研究课题.Add By HZY 2012-02-24 HZY0023
	i TIssueDR'="" s TIssue=$p($g(^DHCEQIssue(TIssueDR)),"^",3)
	
	quit
OutputRowGetFunds
	i TFinaceItemDR'="" Set TFinaceItem=$p($g(^DHCEQCCode("DHCEQCFinaceItem",TFinaceItemDR)),"^",2)
	i TFunctionCatDR'="" Set TFunctionCat=$p($g(^DHCEQCCode("DHCEQCFunctionCat",TFunctionCatDR)),"^",2)
	i (FundsAmount>0)&&(TFee>0) s TProportion=100*TFee/FundsAmount
	Set TFee=##Class(web.DHCEQCommon).FormatNumber(TFee,"")	//Modify DJ 2015-09-14 DJ0164 begin
	Set TDepreTotal=##Class(web.DHCEQCommon).FormatNumber(TDepreTotal,"")
	Set TPreDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber(TPreDepreTotalFee,"")
	Set TPreFundsFee=##Class(web.DHCEQCommon).FormatNumber(TPreFundsFee,"")	//Modify DJ 2015-09-14 DJ0164 end
	Set TCurDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber(TPreDepreTotalFee+TDepreTotal,"")	//modified by czf 20190212
	Set TCurFundsFee=##Class(web.DHCEQCommon).FormatNumber(TPreFundsFee+TFee,"")
	Set TProportion=##Class(web.DHCEQCommon).FormatNumber(TProportion,"")
	s TRow=TRow+1
	s Data=$lb(TRowID,TEquipDR,TFundsTypeDR,TFundsType,TFee,TCheckListDR,TOldRowDR,TOperFlag,TStatus,THold1,THold2,THold3,THold4,THold5,TNoDR,TNo,TSource,TIssueDR,TIssue,TDepreTotal,TPreFundsFee,TCurFundsFee,TPreDepreTotalFee,TCurDepreTotalFee,TRow,THold1,TFinaceItemDR,TFunctionCatDR,TFinaceItem,TFunctionCat,TProportion)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetFunds
	s (TRowID,TEquipDR,TFundsTypeDR,TFundsType,TFee,TCheckListDR,TOldRowDR,TOperFlag,TStatus,THold1,THold2,THold3,THold4,THold5,TNoDR,TNo,TSource,TIssueDR,TIssue,TDepreTotal,TPreFundsFee,TCurFundsFee,TPreDepreTotalFee,TCurDepreTotalFee,THold1,TFinaceItemDR,TFunctionCatDR,TFinaceItem,TFunctionCat,TProportion)=""
	quit
}

ClassMethod GetFundsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFundsExecute ]
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

ClassMethod GetFundsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFundsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/****************************************************************************************/
/// modified by ZY0263 20210514  增加合同明细的资金来源处理
/// modified by ZY0233 20200612  SourceType单词写错了，统一替换
/// Add By JDL 2012-2-15 JDL0116
/// 获取指定业务的 指定资金来源类型的 资金额
/// SourceType:业务类型
/// SourceID:业务ID
/// FundsType:资金来源类型 FundsType为空时,取非自有资金的 其他资金之和
/// FundsAmount:资金总额
/// 返回值：Amount^FundsRowID
/// w ##Class(web.DHCEQ.EM.BUSFunds).GetSourceFunds(8,17,22500)
ClassMethod GetSourceFunds(SourceType, SourceID, FundsAmount, FundsType, SelfFlag As %String = "", DataChangeFlag As %String = "", TSource As %String = "")
{
	n (SourceType,SourceID,FundsAmount, FundsType, SelfFlag,DataChangeFlag, TSource)
	i (SourceType="")||(SourceID="") q 0

	s SelfFundsFlag=##class(web.DHCEQCommon).GetSysInfo("990015")
	s SelfAmount=FundsAmount
	s Amount=""
	s FindRowID=""
	;s TSource=""		 MZY0123	2602461		2022-05-12
	///Mozy0148
	s (tmpSourceType,tmpSourceID)="" //=1的时候需要直接处理一个资金来源对应多个核算项目的数据
	Set DepreTotal=0
	Set SelfDepreTotal=0
	
	If SourceType=1
	{
		Set SelfDepreTotal=$Piece($Get(^DHCEQEquip(SourceID)),"^",35)
	}
	ElseIf SourceType=7
	{
		Set SelfDepreTotal=$Piece($Get(^DHCEQChangeAccount(SourceID)),"^",33)
	}
	;入库明细，且入库明细来源于验收时，从验收取数据
	if ((SourceType=3)&&($p(^DHCEQInStockList(SourceID),"^",18)="2" )&&(+SelfFlag=0))
	{  	
		s TSource="验收单"	// MZY0123	2602461		2022-05-12
		i $p($g(^DHCEQInStockList(SourceID)),"^",22)'="" d
		.i FundsType=SelfFundsFlag d
		..s Amount=FundsAmount
		.e  d
		..s Amount=0
		e  d
		.s tmpSourceType=0
		.s tmpSourceID=$p(^DHCEQInStockList(SourceID),"^",19)
		.s Amount=+..GetSourceFunds(tmpSourceType,tmpSourceID,FundsAmount, FundsType,2,DataChangeFlag,TSource)	// MZY0123	2602461		2022-05-12
	}
	elseif ((SourceType=7)&&($p(^DHCEQChangeAccount(SourceID),"^",10)<2))
	{
		;未审核调账记录，且调账来源于附件时，从附件取数据
		s AffixID=0
		f  s AffixID=$o(^DHCEQAffix("0","ChangeAccountAdd",SourceID,AffixID))  q:((AffixID=""))  d
		.s AffixAmount=$p(^DHCEQAffix(AffixID),"^",7)*$p(^DHCEQAffix(AffixID),"^",11)
		.q:AffixAmount'>0
		.s tmpSourceType=2
		.s tmpSourceID=AffixID
		.s Amount=Amount+..GetSourceFunds(tmpSourceType,tmpSourceID,AffixAmount, FundsType,2,DataChangeFlag)
		s AffixID=0
		f  s AffixID=$o(^DHCEQAffix("0","ChangeAccountReduce",SourceID,AffixID))  q:((AffixID=""))  d
		.s AffixAmount=$p(^DHCEQAffix(AffixID),"^",7)*$p(^DHCEQAffix(AffixID),"^",11)
		.q:AffixAmount'>0
		.s tmpSourceType=2
		.s tmpSourceID=AffixID
		.s Amount=Amount-..GetSourceFunds(tmpSourceType,tmpSourceID,AffixAmount, FundsType,2,DataChangeFlag)
		if Amount'="" s TSource="验收单"
	}elseif ((SourceType=0)&&($p($g(^DHCEQOpenCheckList(SourceID)),"^",63)="1" )&&(+SelfFlag=0))
	{
		;验收明细，且数据来源于合同明细时，从合同明细取数据
		s tmpSourceType=8
		s tmpSourceID=$p($g(^DHCEQOpenCheckList(SourceID)),"^",64)
		s Amount=+..GetSourceFunds(tmpSourceType,tmpSourceID,FundsAmount, FundsType,2,DataChangeFlag)
		s TSource="合同明细"
	}
	
	if Amount'=""
	{
		///有临时golable说明一个资金来源对多个核算项目数据
		//modified by ZY0218 2020-04-10
		if (tmpSourceType'="")&&($Data(^DHCEQFund(0,"TMP",tmpSourceType,tmpSourceID)))>0 
		{
			s FundsListData=""
			s FundsRowID=0
			f  s FundsRowID=$o(^DHCEQFund(0,"TMP",tmpSourceType,tmpSourceID,FundsRowID))  q:FundsRowID=""  d
			.s tmpDataList=$g(^DHCEQFund(0,"TMP",tmpSourceType,tmpSourceID,FundsRowID))
			.s TFee=$p(tmpDataList,"^",1)
			.s TDepreTotal=$p(tmpDataList,"^",2)
			.s TFinaceItemDR=$p(tmpDataList,"^",3)
			.s TFunctionCatDR=$p(tmpDataList,"^",4)
			.i FundsListData="" d
			..s FundsListData=TFee_"^^"_TSource_"^"_TDepreTotal_"^"_TFinaceItemDR_"^"_TFunctionCatDR
			.e  d
			..s FundsListData=FundsListData_"&"_TFee_"^^"_TSource_"^"_TDepreTotal_"^"_TFinaceItemDR_"^"_TFunctionCatDR
			k ^DHCEQFund(0,"TMP",tmpSourceType,tmpSourceID)
			q FundsListData
		}
		else
		{
			q ##Class(web.DHCEQCommon).FormatNumber(Amount,"",2)_"^^"_TSource_"^^^"	// MZY0123	2602461		2022-05-12
		}
	}
	
	k ^DHCEQFund(0,"TMP",SourceType,SourceID)
	s FundsListData=""
	s (SelfFundsID,SelfFinaceItemDR,SelfFunctionCatDR)=""
	
	if (DataChangeFlag="Y")&&($d(^DHCEQTempFunds(0,"Source",SourceType,SourceID)))		//add by czf 2020-10-29
	{  
		s FundsTypeDR=""
		f  s FundsTypeDR=$o(^DHCEQTempFunds(0,"Source",SourceType,SourceID,FundsTypeDR)) q:FundsTypeDR=""  d
		.s RowNo=0
		.f  s RowNo=$o(^DHCEQTempFunds(0,"Source",SourceType,SourceID,FundsTypeDR,RowNo)) q:RowNo=""  d
		..s FundsVal=$g(^DHCEQTempFunds(0,"Source",SourceType,SourceID,FundsTypeDR,RowNo))
		..q:$p(FundsVal,"^",10)="Y"
		..s TFinaceItemDR=$p(FundsVal,"^",20)
		..s TFunctionCatDR=$p(FundsVal,"^",21)
		..s FundsRowID=$p(FundsVal,"^",22)
		..//默认自有资金是不能有多个核算项目的,所以自有一条记录.如果有多条,这里还需要增加核算项目\功能分类的判断条件
		..i ((SelfFundsFlag=FundsTypeDR)&&(FundsType=FundsTypeDR)) d
		...s FindRowID=FundsRowID
		...s SelfFundsID=FundsRowID
		...s SelfFinaceItemDR=TFinaceItemDR
		...s SelfFunctionCatDR=TFunctionCatDR
		..q:FundsTypeDR=SelfFundsFlag	//过滤自有资金
		..s TFee=$p(FundsVal,"^",3)
		..i (SelfAmount<=TFee)&&(SourceType'=7) s TFee=SelfAmount		//czf 2021-01-06 1702794
		..s TDepreTotal=$p(FundsVal,"^",13)
		..i (SelfDepreTotal<=TDepreTotal)&&(SourceType'=7) s TDepreTotal=SelfDepreTotal		//czf 2021-01-06 1702794
		..s TFee=##Class(web.DHCEQCommon).FormatNumber(TFee,"",2)
		..s TDepreTotal=##Class(web.DHCEQCommon).FormatNumber(TDepreTotal,"",2)
		..s SelfAmount=SelfAmount-TFee
		..s SelfDepreTotal=SelfDepreTotal-TDepreTotal
		..q:((FundsType'="")&&(FundsTypeDR'=FundsType))
		..i FundsType'="" s FindRowID=FundsRowID
		..s Amount=Amount+TFee
		..s DepreTotal=DepreTotal+TDepreTotal
		..
		..i TSource="" s TSource=##class(web.DHCEQ.EM.BUSFunds).GetFeeSource(SourceType, SourceID, FindRowID)	// MZY0123	2602461		2022-05-12
		..///同一个资金来源(非自有资金)有多个核算项目的时候,非默认自有资金的时候,根据明细输出,递归调用的SelfFlag=2
		..i +SelfFlag=2 d
		...s ^DHCEQFund(0,"TMP",SourceType,SourceID,FundsRowID)=TFee_"^"_TDepreTotal_"^"_TFinaceItemDR_"^"_TFunctionCatDR
		..e  d
		...i FundsListData="" d
		....s FundsListData=TFee_"^"_FindRowID_"^"_TSource_"^"_TDepreTotal_"^"_TFinaceItemDR_"^"_TFunctionCatDR
		...e  d
		....s FundsListData=FundsListData_"&"_TFee_"^"_FindRowID_"^"_TSource_"^"_TDepreTotal_"^"_TFinaceItemDR_"^"_TFunctionCatDR
	}
	else	
	{
		s FundsRowID=0
		f  s FundsRowID=$o(^DHCEQFunds("0","Source",SourceType,SourceID,FundsRowID))  q:((FundsRowID=""))  d
		.q:$p($g(^DHCEQFunds(FundsRowID)),"^",10)="Y"
		.s FundsTypeDR=$p($g(^DHCEQFunds(FundsRowID)),"^",2)
		.s TFinaceItemDR=$p($g(^DHCEQFunds(FundsRowID)),"^",20)
		.s TFunctionCatDR=$p($g(^DHCEQFunds(FundsRowID)),"^",21)
		.//默认自有资金是不能有多个核算项目的,所以自有一条记录.如果有多条,这里还需要增加核算项目\功能分类的判断条件
		.i ((SelfFundsFlag=FundsTypeDR)&&(FundsType=FundsTypeDR)) d
		..s FindRowID=FundsRowID
		..s SelfFundsID=FundsRowID
		..s SelfFinaceItemDR=TFinaceItemDR
		..s SelfFunctionCatDR=TFunctionCatDR
		.q:FundsTypeDR=SelfFundsFlag //过滤自有资金
		.s TFee=$p($g(^DHCEQFunds(FundsRowID)),"^",3)
		.//add by ZY0287 20211216
		.i (SourceType=8)  d
		..s TContractListFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQContractList(SourceID)),"^",8),"")
		..s TFee=FundsAmount/(TContractListFee/TFee)
		.i (SelfAmount<=TFee)&&(SourceType'=7) s TFee=SelfAmount	//modified by ZY0233 20200612		//czf 2021-01-06 1702794
		.s TDepreTotal=$Piece($Get(^DHCEQFunds(FundsRowID)),"^",13)	
		.i (SelfDepreTotal<=TDepreTotal)&&(SourceType'=7) s TDepreTotal=SelfDepreTotal	//modified by ZY0233 20200612	//czf 2021-01-06 1702794
		.s TFee=##Class(web.DHCEQCommon).FormatNumber(TFee,"",2)
		.s TDepreTotal=##Class(web.DHCEQCommon).FormatNumber(TDepreTotal,"",2)
		.s SelfAmount=SelfAmount-TFee
		.Set SelfDepreTotal=SelfDepreTotal-TDepreTotal	///Mozy0148
		.q:((FundsType'="")&&(FundsTypeDR'=FundsType))
		.i FundsType'="" s FindRowID=FundsRowID
		.s Amount=Amount+TFee
		.Set DepreTotal=DepreTotal+TDepreTotal		///Mozy0148
		.
		.i TSource="" s TSource=##class(web.DHCEQ.EM.BUSFunds).GetFeeSource(SourceType, SourceID, FindRowID)	// MZY0123	2602461		2022-05-12
		.///同一个资金来源(非自有资金)有多个核算项目的时候,非默认自有资金的时候,根据明细输出,递归调用的SelfFlag=2
		.i +SelfFlag=2 d
		..s ^DHCEQFund(0,"TMP",SourceType,SourceID,FundsRowID)=TFee_"^"_TDepreTotal_"^"_TFinaceItemDR_"^"_TFunctionCatDR
		.e  d
		..i FundsListData="" d
		...s FundsListData=TFee_"^"_FindRowID_"^"_TSource_"^"_TDepreTotal_"^"_TFinaceItemDR_"^"_TFunctionCatDR
		..e  d
		...s FundsListData=FundsListData_"&"_TFee_"^"_FindRowID_"^"_TSource_"^"_TDepreTotal_"^"_TFinaceItemDR_"^"_TFunctionCatDR
	}
	i FundsListData'="" q FundsListData
	
	///Mozy0148
	i FundsType=SelfFundsFlag Do
	.s Amount=SelfAmount
	.s DepreTotal=SelfDepreTotal
	.;s FindRowID=SelfFundsID		//czf 2021-04-27
	.
	.i TSource="" s TSource=##class(web.DHCEQ.EM.BUSFunds).GetFeeSource(SourceType, SourceID, FindRowID)	// MZY0123	2602461		2022-05-12
	
	q ##Class(web.DHCEQCommon).FormatNumber(Amount,"",2)_"^"_FindRowID_"^"_TSource_"^"_DepreTotal_"^"_SelfFinaceItemDR_"^"_SelfFunctionCatDR		//czf 2021-04-27
}

/// modified by ZY0263 20210514  增加合同明细的资金来源处理
/// Add By JDL 2012-2-15 JDL0116
/// 重新计算更新下列业务单据的 资金来源信息
/// 验收明细,入库明细,附件,调账
/// 0:验收明细 1:设备 2:附件 3:入库明细 4:转移明细 5:退货明细 6:报废明细 7:调账明细
/// w ##Class(web.DHCEQ.EM.BUSFunds).ChangeFundsBySourceIDNew("8","17", "22500")
ClassMethod ChangeFundsBySourceIDNew(FromType, FromID, FundsAmount, SelfFlag As %String = "")
{
	;s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	;s User=1
	if (FromType'=0)&&(FromType'=2)&&(FromType'=3)&&(FromType'=7)&&(FromType'=8) q 0
	n (User,FromType,FromID,FundsAmount,SelfFlag)
	
	s SelfFundsFlag=##class(web.DHCEQCommon).GetSysInfo("990015")
	//Add By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
	s UseFinaceItemType=+##class(web.DHCEQCommon).GetSysInfo("990076")
	s SelfFinaceItemFlag=##class(web.DHCEQCommon).GetSysInfo("990070")
	s SelfFunctionCatFlag=##class(web.DHCEQCommon).GetSysInfo("990071")
	//End By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
	s SQLCODE=0
	s FTRowID=0
	f  s FTRowID=$o(^DHCEQCCode("DHCEQCFundsType",FTRowID))  q:((FTRowID="")||(SQLCODE'=0))  d
	.s TFundsTypeDR=FTRowID
	.s FTInvalidFlag=$p($g(^DHCEQCCode("DHCEQCFundsType",FTRowID)),"^",4)
	.;处理无效的资金来源类型的信息
	.i FTInvalidFlag="Y"  d
	..&SQL(Update SQLUSER.DHC_EQFunds Set F_InvalidFlag='Y' where F_SourceType=:FromType and F_SourceID=:FromID and F_FundsTypeDR=:FTRowID)
	..i SQLCODE=100 s SQLCODE=0
	.q:FTInvalidFlag="Y"
	.s FundsInfo=##Class(web.DHCEQ.EM.BUSFunds).GetSourceFunds(FromType,FromID, FundsAmount, FTRowID, SelfFlag)
	.;i FTRowID=2 s FundsInfo="300000^1804^^0.00&500000^1806^^0.00"
	.s Length=$l(FundsInfo,"&")
	.for i=1:1:Length d
	..s oneFundsInfo=$p(FundsInfo,"&",i)
	..q:oneFundsInfo=""
	..
	..s TFee=+$p(oneFundsInfo,"^",1)
	..s TFundsRowID=$p(oneFundsInfo,"^",2)
	..s TSource=$p(oneFundsInfo,"^",3)
	..s DepreTotal=+$Piece(oneFundsInfo,"^",4)
	..s TFinaceItemDR=$Piece(oneFundsInfo,"^",5)
	..s TFunctionCatDR=$Piece(oneFundsInfo,"^",6)
	..i UseFinaceItemType>0 d
	...i TFinaceItemDR="" s TFinaceItemDR=SelfFinaceItemFlag
	...i TFunctionCatDR="" s TFunctionCatDR=SelfFunctionCatFlag
	..k PLIST
	..s PLIST(3)=FTRowID
	..s PLIST(4)=TFee
	..s PLIST(7)="0"
	..;s PLIST(8) =User
	..s PLIST(9) =+$H
	..s PLIST(10) = $P($H,",",2)
	..s PLIST(11) ="N"
	..Set PLIST(14) = DepreTotal			///Mozy0148
	..s PLIST(15) =FromType
	..s PLIST(16) =FromID
	..
	..//Add By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
	..s PLIST(21) =TFinaceItemDR
	..s PLIST(22) =TFunctionCatDR
	..//End By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
	..i FromType=7  d	//调账记录增加变动前,变动后资金来源及累计折旧 DJ0135 begin
	...s EQRowID=$p($g(^DHCEQChangeAccount(FromID)),"^",1)
	...s (TPreFundsFee,TPreDepreTotalFee)=0
	...;s FRowID=$o(^DHCEQFunds("0","EquipType",EQRowID,FTRowID,0))
	...s FindFundsRowID=""
	...s FRowID=0
	...f  s FRowID=$o(^DHCEQFunds("0","EquipType",EQRowID,FTRowID,FRowID))  q:(FRowID="")||(FindFundsRowID'="")  d
	....//modified by ZY0218 2020-04-10
	....q:$p($g(^DHCEQFunds(FRowID)),"^",10)="Y"	//czf 2021-11-3
	....q:+$p($g(^DHCEQFunds(FRowID)),"^",3)=0
	....q:(UseFinaceItemType=2)&&(TFinaceItemDR'=$p($g(^DHCEQFunds(FRowID)),"^",20))
	....q:(UseFinaceItemType=2)&&(TFunctionCatDR'=$p($g(^DHCEQFunds(FRowID)),"^",21))
	....s FindFundsRowID=FRowID
	...i FindFundsRowID'=""  d
	....s TPreFundsFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FindFundsRowID)),"^",3),"",2)
	....s TPreDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FindFundsRowID)),"^",13),"",2)
	...s PLIST(19)=TPreFundsFee
	...s PLIST(20)=TPreDepreTotalFee
	...s TCurFundsFee=##Class(web.DHCEQCommon).FormatNumber(TPreFundsFee+TFee,"",2)
	...s TCurDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber(TPreDepreTotalFee+DepreTotal,"",2)
	...i TCurFundsFee<0 s SQLCODE=-3002
	...q:SQLCODE'=0
	...i TCurDepreTotalFee<0 s SQLCODE=-3003
	...q:SQLCODE'=0
	...i TCurDepreTotalFee>TCurFundsFee s SQLCODE=-3004
	...q:SQLCODE'=0
	..q:SQLCODE'=0	//DJ0135 end
	..i TFundsRowID>0  d
	...s TFundsFee=$p($g(^DHCEQFunds(TFundsRowID)),"^",3)
	...s TOldFundsOriginalFee=$p($g(^DHCEQFunds(TFundsRowID)),"^",18)
	...if TFee>0  d
	....;调账减值时,录入资金信息不能为正数
	....i (FromType=7)&&(FundsAmount<0) s SQLCODE=-3001
	....q:SQLCODE'=0
	....;仅重新计算自有资金,当自有资金与原信息不一致时更新
	....i ((TFee'=TFundsFee)&&(FTRowID=SelfFundsFlag))  d
	.....;&SQL(Update SQLUSER.DHC_EQFunds Set F_Fee=:TFee where F_SourceType=:FromType and F_SourceID=:FromID and F_FundsTypeDR=:FTRowID)
	.....&SQL(Update SQLUSER.DHC_EQFunds Set F_Fee=:TFee where F_RowID=:TFundsRowID)
	...else  if TFee=0  d
	....///Mozy0148
	....If (DepreTotal=0)&&(+TOldFundsOriginalFee=0) Do
	.....;&SQL(Delete From SQLUSER.DHC_EQFunds where F_SourceType=:FromType and F_SourceID=:FromID and F_FundsTypeDR=:FTRowID)
	.....&SQL(Delete From SQLUSER.DHC_EQFunds where F_RowID=:TFundsRowID)
	....Else  Do
	.....;&SQL(Update SQLUSER.DHC_EQFunds Set F_DepreTotal=:DepreTotal where F_SourceType=:FromType and F_SourceID=:FromID and F_FundsTypeDR=:FTRowID)
	.....&SQL(Update SQLUSER.DHC_EQFunds Set F_DepreTotal=:DepreTotal where F_RowID=:TFundsRowID)
	...else  d
	....;仅做调账时,资金方可小于0，且需对于设备来讲，资金信息必须大于0
	....i (FromType=7)&&(FundsAmount'>0)  d
	.....s TChangeEquipDR=$p($g(^DHCEQChangeAccount(FromID)),"^",1)
	.....s TEquipFundsID=$o(^DHCEQFunds("0","EquipType",TChangeEquipDR,FTRowID,0))
	.....i (TEquipFundsID'="")&&($p($g(^DHCEQFunds(TEquipFundsID)),"^",3)+TFee<0)  d
	......s SQLCODE=-3001
	.....e  d
	......;&SQL(Update SQLUSER.DHC_EQFunds Set F_Fee=:TFee where F_SourceType=:FromType and F_SourceID=:FromID and F_FundsTypeDR=:FTRowID)
	......&SQL(Update SQLUSER.DHC_EQFunds Set F_Fee=:TFee where F_RowID=:TFundsRowID)
	....e  d
	.....s SQLCODE=-3001
	..e  d
	...;;;;;;;;;;;;;;;;;;;;;;;;;无资金来源信息;;;;;;;;;;;;;;;;;;;;;;;;;
	...if TFee>0  d
	....;调账减值时,录入资金信息不能为正数
	....i (FromType=7)&&(FundsAmount<0) s SQLCODE=-3001
	....q:SQLCODE'=0
	....;仅当入库明细及调账时,需要删除可能残留的资金信息
	....i ((FromType=3)||(FromType=7))  d
	.....&SQL(Delete From SQLUSER.DHC_EQFunds where F_SourceType=:FromType and F_SourceID=:FromID and F_FundsTypeDR=:FTRowID and F_Hold4=:TFinaceItemDR and F_Hold5=:TFunctionCatDR)
	.....i SQLCODE=100 s SQLCODE=0
	....
	....
	....i FromType=0 s PLIST(5)=FromID
	....i FromType=1 s PLIST(2)=FromID
	....i FromType=2 s PLIST(13)=FromID
	....&SQL(Insert Into SQLUSER.DHC_EQFunds Values :PLIST())
	...else  if TFee=0  d
	....///Mozy0148
	....If DepreTotal=0 Do
	.....;资金来源金额和累计折旧都为0是相当于无效记录,应删除
	.....&SQL(Delete From SQLUSER.DHC_EQFunds where F_SourceType=:FromType and F_SourceID=:FromID and F_FundsTypeDR=:FTRowID  and F_Hold4=:TFinaceItemDR and F_Hold5=:TFunctionCatDR)
	.....i SQLCODE=100 s SQLCODE=0
	....Else  Do
	.....;累计折旧不为0时生成新记录
	.....&SQL(Insert Into SQLUSER.DHC_EQFunds Values :PLIST())
	...else  d
	....;仅做调账时,资金方可小于0，且需对于设备来讲，资金信息必须大于0
	....i (FromType=7)&&(FundsAmount'>0)  d
	.....s TChangeEquipDR=$p($g(^DHCEQChangeAccount(FromID)),"^",1)
	.....//Modefied by zc0117 20220428 修改资金来源错误 begin
	.....;s TEquipFundsID=$o(^DHCEQFunds("0","EquipType",TChangeEquipDR,FTRowID,0))
	.....s TEquipFundsID=##class(web.DHCEQ.EM.BUSFunds).GetFirstFRowID(TChangeEquipDR,FTRowID)
	.....//Modefied by zc0117 20220428 修改资金来源错误 end
	.....i (TEquipFundsID'="")&&($p($g(^DHCEQFunds(TEquipFundsID)),"^",3)+TFee<0)  d
	......s SQLCODE=-3001
	.....e  d
	......&SQL(Insert Into SQLUSER.DHC_EQFunds Values :PLIST())
	....e  d
	.....s SQLCODE=-3001
	
	q SQLCODE
}

/// add By ZY0213
/// SourceType:0:验收明细 1:设备 2:附件 3:入库明细 4:转移明细 5:退货明细 6:报废明细 7:调账明细 9：调整数据设备
/// SourceID: 对应业务ID
/// 返回值：0:不需要判断处理；1:提示有核算项目信息为空,用户自己选择是否终止提交;2:核算项目为空，不能继续提交
/// w ##Class(web.DHCEQ.EM.BUSFunds).GetFinaceItemMode(0,1)
ClassMethod GetFinaceItemMode(SourceType, SourceID)
{
	new finaceItemMode,Flag,FundsRowID,FundsTypeDR,FinaceItemDR,FunctionCatDR
	s finaceItemMode=+##class(web.DHCEQCommon).GetSysInfo("990076")
	i finaceItemMode=0 q 0
	s (FundsRowID,Flag)=0
	i SourceType=0
	{
		s SourceID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",SourceID,0))
		i '$Data(^DHCEQFunds("0","Source",SourceType,SourceID))
		{
			s Flag=1
		}else
		{
			f  s FundsRowID=$o(^DHCEQFunds("0","Source",SourceType,SourceID,FundsRowID))  q:((FundsRowID="")||(Flag'=0))  d
			.q:$p($g(^DHCEQFunds(FundsRowID)),"^",10)="Y"
			.s FundsTypeDR=$p($g(^DHCEQFunds(FundsRowID)),"^",2)
			.s FinaceItemDR=$p($g(^DHCEQFunds(FundsRowID)),"^",20)
			.s FunctionCatDR=$p($g(^DHCEQFunds(FundsRowID)),"^",21)
			.i (FundsTypeDR="")||(FinaceItemDR="")||(FunctionCatDR="") s Flag=1
		}
	}
	if finaceItemMode=1
	{
		i Flag=1 q 1
	}
	elseif finaceItemMode=2
	{
		i Flag=1 q 2
	}
	q 0
}

/// Modefied by zc0107 20211115 修改取第一条资金来源错误
/// w ##class(web.DHCEQ.EM.BUSFunds).GetFirstFRowID(2164,2)
ClassMethod GetFirstFRowID(vEQRowID, vFTRowID)
{
	s MinRowID=""
	s vFundFlag=0
	s vFuRowID=0
	f  s vFuRowID=$o(^DHCEQFunds("0","EquipType",vEQRowID,vFTRowID,vFuRowID))  quit:(vFuRowID="")||(vFundFlag'=0)  d
	.q:$p($g(^DHCEQFunds(vFuRowID)),"^",10)="Y"
	.s MinRowID=vFuRowID
	.s vFundFlag=1
	q MinRowID
}

/// MZY0123	2602461		2022-05-12
/// w ##class(web.DHCEQ.EM.BUSFunds).GetFeeSource(0,3,17)
ClassMethod GetFeeSource(SourceType, SourceID, FindRowID)
{
	; SourceType:0:验收明细 1:设备 2:附件 3:入库明细 4:转移明细 5:退货明细 6:报废明细 7:调账明细 8:合同明细 9：调整数据设备
	new FeeSource,tmpSourceID,tmpFundsTypeDR,tmpFindRowID
	
	s FeeSource=""
	If SourceType=0
	{
		; "1":"合同明细","2":"采购单","3":"计划单","4":"申请单"
		i $p($g(^DHCEQOpenCheckList(SourceID)),"^",63)=1
		{
			s tmpSourceID=$p($g(^DHCEQOpenCheckList(SourceID)),"^",64)
			i FindRowID="" q ""
			i tmpSourceID="" q ""
			s tmpFundsTypeDR=$p($g(^DHCEQFunds(FindRowID)),"^",2)
			s tmpFindRowID=$O(^DHCEQFunds(0,"SourceType",8,tmpSourceID,tmpFundsTypeDR,0))
			i (tmpFindRowID>0)&&($p($g(^DHCEQFunds(FindRowID)),"^",3)=$p($g(^DHCEQFunds(tmpFindRowID)),"^",3)) s FeeSource="合同明细"
		}
	}
	elseif (SourceType=1)
	{
		
	}
	elseif (SourceType=3)
	{
		i $p($g(^DHCEQInStockList(SourceID)),"^",18)=2
		{
			s FeeSource="验收明细"
		}
	}
	q FeeSource
}

}
