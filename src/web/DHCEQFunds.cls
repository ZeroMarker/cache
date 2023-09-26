Class web.DHCEQFunds Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Modified By HZY 2012-02-24 HZY0023
/// Desc:增加'研究课题'的输出显示.
/// ---------------------------------------------------------------------
/// 获取设备的资金来源信息
/// d ##class(%ResultSet).RunQuery("web.DHCEQFunds","GetFunds",7,12,0)
Query GetFunds(FromType, FromID, FundsAmount) As %Query(ROWSPEC = "TRowID:%String,TEquipDR:%String,TFundsTypeDR:%String,TFundsType:%String,TFee:%String,TCheckListDR:%String,TOldRowDR:%String,TOperFlag:%String,TStatus:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TNoDR:%String,TNo:%String,TSource:%String,TIssueDR:%String,TIssue:%String,TDepreTotal:%String,TPreFundsFee:%String,TCurFundsFee:%String,TPreDepreTotalFee:%String,TCurDepreTotalFee:%String,TRow:%String,THold1:%String")
{
}

ClassMethod GetFundsExecute(ByRef qHandle As %Binary, FromType, FromID, FundsAmount) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=0
	d BuildDataGetFunds
	Quit $$$OK
BuildDataGetFunds
	i (FromID="")||(FromType="") q
	i FundsAmount'="" s FundsAmount=##Class(web.DHCEQCommon).Replace(FundsAmount,",","")
	;非调账,金额必须大于0
	i ((FundsAmount<=0)&&(FromType'="7")) q
	s SelfFundsFlag=##class(web.DHCEQCommon).GetSysInfo("990015")
	/*********************************************************/
	s SelfFunds=0
	;Modified By JDL 2012-2-15 JDL0116
	s SelfFlag=0
	i $D(^DHCEQFunds("0","Source",FromType,FromID)) s SelfFlag=1
	s SelfFunds=##Class(web.DHCEQFunds).GetSourceFunds(FromType,FromID, FundsAmount, SelfFundsFlag, SelfFlag)
	
	;i FromType=0 s SelfFunds=##Class(web.DHCEQOpenCheckRequest).GetSourceFunds(FromID,"", FundsAmount, SelfFundsFlag)
	;i FromType=1 s SelfFunds=##Class(web.DHCEQOpenCheckRequest).GetSourceFunds("",FromID, FundsAmount, SelfFundsFlag)
	;i FromType=2 s SelfFunds=##Class(web.DHCEQOpenCheckRequest).GetAffixFunds(FromID,FundsAmount,SelfFundsFlag)
	/*********************************************************/
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
	.s FundsInfo=##Class(web.DHCEQFunds).GetSourceFunds(FromType,FromID, FundsAmount, FTRowID, SelfFlag)
	.s rowid=$p(FundsInfo,"^",2)
	.s TSource=$p(FundsInfo,"^",3)
	.s TFee=+FundsInfo
	.Set TDepreTotal=+$p(FundsInfo,"^",4)	;///Mozy0148
	.q:(rowid="")&&(FTInvalidFlag="Y")
	.i FromType=7  d	//调账记录增加变动前,变动后资金来源及累计折旧 DJ0135
	..s EQRowID=$p($g(^DHCEQChangeAccount(FromID)),"^",1)
	..s FRowID=$o(^DHCEQFunds("0","EquipType",EQRowID,FTRowID,0))
	..s (TPreFundsFee,TPreDepreTotalFee)=0
	..i FRowID'=""  d
	...s TPreFundsFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FRowID)),"^",3),"",2)
	...s TPreDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FRowID)),"^",13),"",2)
	.i rowid'=""  d
	..d GetOneFunds
	.Set TFee=##Class(web.DHCEQCommon).FormatNumber(TFee,"")	//Modify DJ 2015-09-14 DJ0164 begin
	.Set TDepreTotal=##Class(web.DHCEQCommon).FormatNumber(TDepreTotal,"")
	.Set TPreDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber(TPreDepreTotalFee,"")
	.Set TPreFundsFee=##Class(web.DHCEQCommon).FormatNumber(TPreFundsFee,"")	//Modify DJ 2015-09-14 DJ0164 end
	.Set TCurDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber(TPreDepreTotalFee+TDepreTotal,"")	//modified by czf 20190212
	.Set TCurFundsFee=##Class(web.DHCEQCommon).FormatNumber(TPreFundsFee+TFee,"")
	.s TRow=TRow+1		//Add By DJ 2016-03-01
	.d OutputRowGetFunds
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
	Set THold4=$Piece(gbldata,"^",20)
	Set THold5=$Piece(gbldata,"^",21)
	s TNoDR=$p(gbldata,"^",16)
	i TNoDR'=""	s TNo=$p($g(^DHCEQFundsRecord(TNoDR)),"^",2)
	s TIssueDR=$p(gbldata,"^",17)	//研究课题.Add By HZY 2012-02-24 HZY0023
	i TIssueDR'="" s TIssue=$p($g(^DHCEQIssue(TIssueDR)),"^",3)
	
	quit
OutputRowGetFunds
	s Data=$lb(TRowID,TEquipDR,TFundsTypeDR,TFundsType,TFee,TCheckListDR,TOldRowDR,TOperFlag,TStatus,THold1,THold2,THold3,THold4,THold5,TNoDR,TNo,TSource,TIssueDR,TIssue,TDepreTotal,TPreFundsFee,TCurFundsFee,TPreDepreTotalFee,TCurDepreTotalFee,TRow,THold1)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetFunds
	s (TRowID,TEquipDR,TFundsTypeDR,TFundsType,TFee,TCheckListDR,TOldRowDR,TOperFlag,TStatus,THold1,THold2,THold3,THold4,THold5,TNoDR,TNo,TSource,TIssueDR,TIssue,TDepreTotal,TPreFundsFee,TCurFundsFee,TPreDepreTotalFee,TCurDepreTotalFee,THold1)=""
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

/// 获取资金来源类型代码信息
Query FundsType() As %Query(ROWSPEC = "TDesc:%String:描述,Hidden:%String,TCode:%String:编码,TRemark:%String:备注")
{
}

ClassMethod FundsTypeExecute(ByRef qHandle As %Binary) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetFundsType
	Quit $$$OK
BuildDataGetFundsType
	f  s rowid=$o(^DHCEQCCode("DHCEQCFundsType",rowid))  quit:rowid=""  d
	.s TRowID = rowid	//rowid
	.s TCode = $p($g(^DHCEQCCode("DHCEQCFundsType",rowid)),"^",1)	//代码
	.s TDesc = $p($g(^DHCEQCCode("DHCEQCFundsType",rowid)),"^",2)	//描述
	.s TRemark = $p($g(^DHCEQCCode("DHCEQCFundsType",rowid)),"^",3)	//备注
	.s TInvalidFlag = $p($g(^DHCEQCCode("DHCEQCFundsType",rowid)),"^",4) //无效标志
	.q:TInvalidFlag="Y"
	.d OutputRowGetFundsType
	quit
OutputRowGetFundsType
	s Data=$lb(TDesc,TRowID,TCode,TRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetFundsType
	s (TDesc,TRowID,TCode,TRemark)=""
	quit
}

ClassMethod FundsTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FundsTypeExecute ]
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

ClassMethod FundsTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FundsTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 获取资金来源批文信息
Query FundsRecord(No) As %Query(ROWSPEC = "TNo:%String,Hidden:%String,Hidden:%String")
{
}

ClassMethod FundsRecordExecute(ByRef qHandle As %Binary, No) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetFundsRecord
	Quit $$$OK
BuildDataGetFundsRecord
	i No'=""  d
	.s No=$ZCONVERT(No ,"U")
	
	f  s rowid=$o(^DHCEQFundsRecord(rowid))  quit:rowid=""  d
	.s TRowID = rowid	//rowid
	.s TNo = $p($g(^DHCEQFundsRecord(rowid)),"^",2)	//代码
	.s TDesc = $p($g(^DHCEQFundsRecord(rowid)),"^",1)	//描述
	.q:((No'="")&&($ZCONVERT(TNo,"U")'[No))
	.d OutputRowGetFundsRecord
	quit
OutputRowGetFundsRecord
	s Data=$lb(TNo,TRowID,TDesc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetFundsRecord
	s (TNo,TRowID,TDesc)=""
	quit
}

ClassMethod FundsRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FundsRecordExecute ]
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

ClassMethod FundsRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FundsRecordExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 检测设备的经费资金是否与设备的金额一致
/// 返回值：0：经费资金小于设备的金额	1：经费资金等于设备的金额   2：经费资金大于设备的金额
/// w ##Class(web.DHCEQFunds).CheckAmount("1",5,3,581)
ClassMethod CheckAmount(FromType, RromID, RowID, Amount)
{
	n (FromType,RromID, RowID, Amount)
	i FromType="1" s EquipDR=RromID
	i EquipDR="" q 0
	s EquipAmount=$p($g(^DHCEQEquip(EquipDR)),"^",27)
	s FundsAmount=Amount
	s rowid=0
	f  s rowid=$o(^DHCEQFunds(0,"Equip",EquipDR,rowid))  quit:rowid=""  d
	.q:$p($g(^DHCEQFunds(rowid)),"^",10)="Y"
	.q:rowid=RowID 
	.s FundsAmount=FundsAmount+$p($g(^DHCEQFunds(rowid)),"^",3)
	i FundsAmount<EquipAmount q 0
	i FundsAmount=EquipAmount q 1
	i FundsAmount>EquipAmount q 2
}

/// 删除资金来源记录
/// 入参：rowid记录ID，fromType来源类型：0验收单  1设备    fromID：对应ID
/// 返回：SQLCODE
ClassMethod DeleteFunds(rowid, fromType, fromID)
{
	n (rowid,fromType,fromID)
	s openCheckListID=$p($g(^DHCEQFunds(rowid)),"^",4)
	;如果是验收单处编辑，则直接设置无效标志
	i (fromType=0)
	{
		&SQL(Update SQLUSER.DHC_EQFunds set F_InvalidFlag='Y' where F_RowID = :rowid) 
	}
	else
	{
		;删除设备本身增加资金来源，则直接置为无效
		if (openCheckListID="")
		{
			&SQL(Update SQLUSER.DHC_EQFunds set F_InvalidFlag='Y' where F_RowID = :rowid) 
		}
		else
		{
			s oldID=$p($g(^DHCEQFunds(rowid)),"^",5)
			;如果该记录改自验收单，则修改该记录为冲销记录
			if (oldID'="")
			{
				&SQL(Update SQLUSER.DHC_EQFunds set F_OperFlag='2' where F_RowID = :rowid)
			}
			else
			{
				;插入一条冲销记录
				s PLIST(6)=rowid
		 		s PLIST(7)="2" 
		 		&SQL(Insert Into SQLUSER.DHC_EQFunds Values :PLIST())
			}			
		} 		
	}
	q SQLCODE
}

/// w ##Class(web.DHCEQFunds).SaveFunds("0","60","236^1^4800.00^^^0.00^^^^^0.00^0.00||237^2^3200.00^^^0.00^^^^^0.00^0.00||^3^0.00^^^0.00^^^^^0.00^0.00||^4^0.00^^^0.00^^^^^0.00^0.00||","Y")
ClassMethod SaveFunds(fromType, fromID, val, DataChangeFlag As %String = "")
{
	Set $ZT="SaveFunds"
	i DataChangeFlag="Y" k ^DHCEQTempFunds(0,"Source",fromType, fromID)		//add by czf 2020-10-29
	TStart
	s ListCount=$L(val,"||")-1
	s ReturnID=0
	for i=1:1:ListCount
	{
		s List=$p(val,"||",i)
		s ReturnID=..UpdateFunds(fromType, fromID, List,DataChangeFlag,i)
		i ReturnID<0 s i=ListCount+1
	}
	i ReturnID<0
	{
		TRollBack
		q ReturnID
	}
	TCommit
	q ReturnID
SaveFunds
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK		       //回滚事务
 	q -1
}

ClassMethod GetFundsByID(rowid)
{
	n result,resultex
	s (result,resultex)=""
	
	i rowid="" q ""
	s result= ^DHCEQFunds(rowid)
	s resultex=resultex_"^"	;FundsTypeDR
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCFundsType",$p(result,"^",2))),"^",2)
	s resultex=resultex_"^"	;NoDR
	i $p(result,"^",16)'=""  d
	.s resultex=resultex_$p($g(^DHCEQFundsRecord($p(result,"^",16))),"^",2)
	
	s result=result_resultex
	s result=##Class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

/// 根据条件获取资金来源的金额
/// 入参:FromType来源类型：0验收单  1设备  2  附件  
/// 		FromID：对应ID
/// 		FundsType:资金来源类型
/// 		FrundsRecordDR:批文记录ID
/// 返回：金额
/// w ##Class(web.DHCEQFunds).GetFundsAmountByFromID(1,"","","")
ClassMethod GetFundsAmountByFromID(FromType, FromID, FundsType As %Library.String = "", FrundsRecordDR As %Library.String = "")
{
	n (FromType,FromID,FundsType,FrundsRecordDR)
	
	s Amount=0
	i FromType=0 //验收单
	{
		s FTDR=0
		f  s FTDR=$o(^DHCEQFunds("0","CheckListType",FromID,FTDR))  q:FTDR=""  d
		.q:(FundsType'="")&&(FTDR'=FundsType)
		.s FRowID=0
		.f  s FRowID=$o(^DHCEQFunds("0","CheckListType",FromID,FTDR,FRowID))  q:FRowID=""  d
		..q:$p($g(^DHCEQFunds(FRowID)),"^",10)="Y"
		..s FrundsRecord=$p($g(^DHCEQFunds(FRowID)),"^",16)
		..q:(FrundsRecordDR'="")&&(FrundsRecord'=FrundsRecordDR)
		..s Amount=Amount+$p($g(^DHCEQFunds(FRowID)),"^",3)
	}
	i FromType=1 //设备
	{
		s SelfFundsFlag=##class(web.DHCEQCommon).GetSysInfo("990015")
		s FTDR=0
		f  s FTDR=$o(^DHCEQFunds("0","EquipType",FromID,FTDR))  q:FTDR=""  d //改自验收单,设备本身
		.q:(FundsType'="")&&(FTDR'=FundsType)
		.;q:FTDR=SelfFundsFlag //过滤自有资金  Modified by jdl 2013-11-11 JDL0134
		.s FRowID=0
		.f  s FRowID=$o(^DHCEQFunds("0","EquipType",FromID,FTDR,FRowID))  q:FRowID=""  d
		..q:$p($g(^DHCEQFunds(FRowID)),"^",10)="Y"
		..s FrundsRecord=$p($g(^DHCEQFunds(FRowID)),"^",16)
		..q:(FrundsRecordDR'="")&&(FrundsRecord'=FrundsRecordDR)
		..s Amount=Amount+$p($g(^DHCEQFunds(FRowID)),"^",3)
		/*    Modified by jdl 2013-11-11 JDL0134		
		//未改自验收单
		s OCLDR=$p($g(^DHCEQEquip(FromID)),"^",77) //OpenCheckList
		i OCLDR'=""  d
		.s MaxID=$o(^DHCEQEquip(0,"OpenCheckList",OCLDR,""),-1)
		.s Quantity=$p($g(^DHCEQOpenCheckList(OCLDR)),"^",16)
		.s FTDR=0
		.f  s FTDR=$o(^DHCEQFunds("0","CheckListType",OCLDR,FTDR))  q:FTDR=""  d
		..q:(FundsType'="")&&(FTDR'=FundsType)
		..q:FTDR=SelfFundsFlag //过滤自有资金
		..s FRowID=0
		..f  s FRowID=$o(^DHCEQFunds("0","CheckListType",OCLDR,FTDR,FRowID))  q:FRowID=""  d
		...q:$p($g(^DHCEQFunds(FRowID)),"^",10)="Y"
		...s FrundsRecord=$p($g(^DHCEQFunds(FRowID)),"^",16)
		...q:(FrundsRecordDR'="")&&(FrundsRecord'=FrundsRecordDR)
		...q:$d(^DHCEQFunds("0","OldRowEquip",FRowID,FromID))
		...s FromIDFee=$p($g(^DHCEQFunds(FRowID)),"^",3)
		...i MaxID=FromID  d //同批次最后一台设备
		....s FromIDFee=FromIDFee-($fn(FromIDFee/Quantity,"",2)*(Quantity-1))
		...e  d
		....s FromIDFee=$fn(FromIDFee/Quantity,"",2)
		...s Amount=Amount+FromIDFee
		s OriginalFee=$p($g(^DHCEQEquip(FromID)),"^",27)
		i (FundsType'="")&&(SelfFundsFlag=FundsType) s Amount=##Class(web.DHCEQOpenCheckRequest).GetSourceFunds("",FromID,OriginalFee,SelfFundsFlag)
		i (FundsType="") s Amount=Amount+##Class(web.DHCEQOpenCheckRequest).GetSourceFunds("",FromID,OriginalFee,SelfFundsFlag)
		*/
	}
	i FromType=2 //附件
	{
		s FTDR=0
		f  s FTDR=$o(^DHCEQFunds("0","AffixType",FromID,FTDR))  q:FTDR=""  d
		.q:(FundsType'="")&&(FTDR'=FundsType)
		.s FRowID=0
		.f  s FRowID=$o(^DHCEQFunds("0","AffixType",FromID,FTDR,FRowID))  q:FRowID=""  d
		..q:$p($g(^DHCEQFunds(FRowID)),"^",10)="Y"
		..s FrundsRecord=$p($g(^DHCEQFunds(FRowID)),"^",16)
		..q:(FrundsRecordDR'="")&&(FrundsRecord'=FrundsRecordDR)
		..s Amount=Amount+$p($g(^DHCEQFunds(FRowID)),"^",3)
	}
	q Amount
}

/****************************************************************************************/
/// Modified By HZY 2012-02-24 HZY0023
/// Desc:增加 研究课题IssueDR 的存储.
ClassMethod UpdateFunds(fromType, fromID, val, DataChangeFlag As %String = "", RowNo As %String = "")
{
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s rowid=$p(val,"^",1)
	k PLIST
	s (PLIST(2),PLIST(5),PLIST(13),PLIST(14))=""		//add by czf 2020-10-29
	i fromType=0 s PLIST(5) = fromID
	i fromType=1 s PLIST(2) = fromID
	i fromType=2 s PLIST(13) =fromID
	//Add By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
	s SelfFinaceItemFlag=##class(web.DHCEQCommon).GetSysInfo("990070")
	s SelfFunctionCatFlag=##class(web.DHCEQCommon).GetSysInfo("990071")
	s UseFinaceItemType=+##class(web.DHCEQCommon).GetSysInfo("990076")
	//End By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
	s PLIST(3) = $p(val,"^",2)	;FundsTypeDR
	s PLIST(4) = $p(val,"^",3)	;Fee
	s PLIST(6) = $p(val,"^",4)	;OldRowDR
	s PLIST(8) =User
	s PLIST(9) =+$H
	s PLIST(10) = $P($H,",",2)
	s PLIST(11) ="N"
	Set PLIST(12) =$Piece(val,"^",5)	;F_Remark
	;Set PLIST(13) =$Piece(val,"^",5)	;F_AffixDR
	If $Piece(val,"^",11)'="" Set PLIST(14) =$Piece(val,"^",11)	;F_DepreTotal	///Mozy0148
	Set PLIST(15) =fromType				;F_SourceType
	Set PLIST(16) =fromID				;F_SourceID
	;Set PLIST(17) =$Piece(val,"^",8)	;F_NoDR
	Set PLIST(18) =$Piece(val,"^",10)	;F_Hold1 研究课题IssueDR 2012-02-24 HZY0023
	Set PLIST(19) =$Piece(val,"^",12)	;PreFundsFee //DJ0135
	Set PLIST(20) =$Piece(val,"^",6)	;TPreDepreTotalFee	//DJ0135
	Set PLIST(21) =$Piece(val,"^",7)	;F_Hold4  //Add By QW 20190410 BUG:QW0027 资金来源核算项目
	Set PLIST(22) =$Piece(val,"^",8)	;F_Hold5  //Add By QW 20190410 BUG:QW0027 资金来源功能分类
	//Add By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
	i UseFinaceItemType>0 d
	.if PLIST(21) =""  Set PLIST(21) =SelfFinaceItemFlag
	.if PLIST(22) =""  Set PLIST(22) =SelfFunctionCatFlag
	//End By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
	s No=$p(val,"^",9)
	;如果批文号不为空，则自动插入该批文记录
	s FundsTypeDR=PLIST(3)
	s NoID=""
	//Add By QW 20190412 BUG:QW0027 资金来源核算项目及功能分类
	s FinaceItemDR=$Piece(val,"^",7)
	s FunctionCatDR=$Piece(val,"^",8)
	
	;验收单据调整记录信息 add by czf 2020-10-29
	i DataChangeFlag="Y" 
	{
		s FNoDR=""
		i rowid'="" s FNoDR=$p($g(^DHCEQFunds(rowid)),"^",16)
		s FundVal=PLIST(2)_"^"_PLIST(3)_"^"_PLIST(4)_"^"_PLIST(5)_"^"_PLIST(6)_"^0^"_PLIST(8)_"^"_PLIST(9)_"^"_PLIST(10)_"^"_PLIST(11)_"^"_PLIST(12)_"^"_PLIST(13)_"^"_PLIST(14)_"^"_PLIST(15)_"^"_PLIST(16)_"^"_FNoDR_"^"_PLIST(18)_"^"_PLIST(19)_"^"_PLIST(20)_"^"_PLIST(21)_"^"_PLIST(22)_"^"_rowid_"^"_No			//czf 2021-01-06 1706105
		s ^DHCEQTempFunds(0,"Source",fromType, fromID,FundsTypeDR,RowNo)=FundVal
		q 0
	}
	
	s flag=0
	s FundsRowID=0
	f  s FundsRowID=$o(^DHCEQFunds("0","Source",fromType,fromID,FundsRowID))  q:((FundsRowID="")||(flag'=0))  d
	.q:rowid=FundsRowID
	.s TFinaceItemDR = $Piece($Get(^DHCEQFunds(FundsRowID)),"^",20)	
	.s TFunctionCatDR = $Piece($Get(^DHCEQFunds(FundsRowID)),"^",21)
	.s TFundsTypeDR=$p($g(^DHCEQFunds(FundsRowID)),"^",2)
	.q:(TFinaceItemDR'=FinaceItemDR)||(TFunctionCatDR'=FunctionCatDR)||(TFundsTypeDR'=FundsTypeDR)
	.s flag=-1001
	if flag
	{
		q flag
	}
	//End By QW 20190412 BUG:QW0027 资金来源核算项目及功能分类
	&SQL(select FR_RowID into :NoID from SQLUSER.DHC_EQFundsRecord Where FR_No=:No)
	i (NoID="")&&(No'="")
	{
		&SQL(Insert Into SQLUSER.DHC_EQFundsRecord (FR_No,FR_FundsTypeDR) values (:No,:FundsTypeDR))
		if SQLCODE 
		{
			q SQLCODE
		}
		s NoID=$g(%ROWID)
	}
	s PLIST(17)=NoID
	i (rowid'="")
	{
		s oldID=$p($g(^DHCEQFunds(rowid)),"^",5)
		s openCheckListID=$p($g(^DHCEQFunds(rowid)),"^",4)
 		;如果是设备台帐处编辑资金来源，
 		;且该记录oldID为空，且openCheckListID不为空
 		;则插入记录，修改源自验收单
	 	i ((fromType="1")&&(oldID="")&&(openCheckListID'=""))
		{
			s PLIST(6) = rowid
			s PLIST(7) = "1"
			&SQL(Insert Into SQLUSER.DHC_EQFunds Values :PLIST())
		}
		else
		{
			i (oldID="")&&(+PLIST(4)=0)&&(+PLIST(14)=0) //更新本身记录时如果来源资金为0则删除记录	///Mozy0148
			{
				&SQL(Delete From SQLUSER.DHC_EQFunds where F_RowID=:rowid)
			}
			else
			{
				;更新当前记录
				&SQL(Update SQLUSER.DHC_EQFunds Values :PLIST() where F_RowID = :rowid)
			}
		}
	}
	else
	{
		s PLIST(7) = "0"
		i (+PLIST(4)'=0)||(+PLIST(14)'=0)||(+PLIST(19)'=0) //来源资金或累计折旧,原来原值不为0的时候进行处理				///Mozy0148
		{
			;插入全新记录
			&SQL(Insert Into SQLUSER.DHC_EQFunds Values :PLIST())
		}
	}
	if SQLCODE 
	{
		q SQLCODE
	}
	Set ID=$g(%ROWID)
	q ID
}

/****************************************************************************************/

/*
/// Add By DJ 2011-05-06
/// FromType: 0 验收单  1 设备调账  2 附件
ClassMethod ChangeFundsBySourceID(FromType, FromID)
{
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	n (User,FromType,FromID)
	s Funds=..GetFundsAmountByFromID(FromType,FromID,"","")
	s SelfFundsFlag=##class(web.DHCEQCommon).GetSysInfo("990015")
	i FromType=0 //验收单
	{
		s FundsID=$o(^DHCEQFunds("0","CheckListType",FromID,SelfFundsFlag,0))
		s FundsAmount=$p($g(^DHCEQOpenCheckList(FromID)),"^",16)*$p($g(^DHCEQOpenCheckList(FromID)),"^",17)
	}
	i FromType=1 //设备调账
	{
		s FundsID=$o(^DHCEQFunds("0","EquipType",FromID,SelfFundsFlag,0))
		s ChangeAccountID=$o(^DHCEQChangeAccount(0,"Equip",FromID,""),-1)
		s FundsAmount=$p($g(^DHCEQChangeAccount(ChangeAccountID)),"^",3)
	}
	i FromType=2 //附件
	{
		s FundsID=$o(^DHCEQFunds("0","AffixType",FromID,SelfFundsFlag,0))
		s FundsAmount=$p($g(^DHCEQAffix(FromID)),"^",7)*$p($g(^DHCEQAffix(FromID)),"^",11)
	}
	i Funds=FundsAmount q 0
	i FundsAmount>Funds
	{
		k PLIST
		s PLIST(3)=SelfFundsFlag
		i FromType=0 s PLIST(5)=FromID
		i FromType=1 s PLIST(2)=FromID
		i FromType=2 s PLIST(13)=FromID
		i FundsID="" //新增自有资金
		{
			s PLIST(4)=FundsAmount-Funds
			s PLIST(7)="0"
			s PLIST(8) =User
			s PLIST(9) =+$H
			s PLIST(10) = $P($H,",",2)
			s PLIST(11) ="N"
			;Mozy0075 2011-12-29
			Set PLIST(15) =FromType
			Set PLIST(16) =FromID
			i FromType=1 //检测是否来自验收单
			{
				i '$d(^DHCEQFunds("0","Equip",FromID)) s PLIST(4)=##Class(web.DHCEQOpenCheckRequest).GetSourceFunds("",FromID,FundsAmount,SelfFundsFlag) //导入设备或来自验收单设备资金来源未改自验收单
				s OCLDR=$p($g(^DHCEQEquip(FromID)),"^",77)
				if OCLDR'=""
				{
					s Find=$o(^DHCEQFunds("0","CheckListType",OCLDR,SelfFundsFlag,0))
					i Find'=""
					{
						s PLIST(7)="1"
						s PLIST(6)=Find
					}
				}
			}
			&SQL(Insert Into SQLUSER.DHC_EQFunds Values :PLIST())
		}
		else //更新自有资金
		{
			s PLIST(4)=+$P($G(^DHCEQFunds(FundsID)),"^",3)+FundsAmount-Funds
			&SQL(Update SQLUSER.DHC_EQFunds Values :PLIST() where F_RowID = :FundsID)
		}
	}
	else
	{
		//根据资金来源顺序递减差额
		s Amount=Funds-FundsAmount
		s FundsTypeID=0
		s SQLCODE=0
		f  s FundsTypeID=$o(^DHCEQCCode("DHCEQCFundsType",FundsTypeID))  q:(FundsTypeID="")||(Amount=0)||(SQLCODE'=0)  d
		.s CurFunds=0
		.i FromType=0  d //验收单
		..s CurID=$o(^DHCEQFunds("0","CheckListType",FromID,FundsTypeID,0))
		..i CurID'="" s CurFunds=$p($g(^DHCEQFunds(CurID)),"^",3)
		.i FromType=1  d //设备
		..s CurID=$o(^DHCEQFunds("0","EquipType",FromID,FundsTypeID,0))
		..s CurFunds=##Class(web.DHCEQOpenCheckRequest).GetSourceFunds("",FromID,Funds,FundsTypeID)
		.i FromType=2  d //附件
		..s CurID=$o(^DHCEQFunds("0","AffixType",FromID,FundsTypeID,0))
		..i CurID'="" s CurFunds=$p($g(^DHCEQFunds(CurID)),"^",3)
		.i CurFunds<=Amount  d
		..i FromType=1  d //设备
		...i CurID'=""  d //此处包括两种情况1:来自验收单 2:自己本身
		....s OLDRowID=$p($g(^DHCEQFunds(CurID)),"^",5)
		....i OLDRowID'=""  d
		.....&SQL(Update SQLUSER.DHC_EQFunds Set F_Fee=0 Where F_RowID=:CurID)
		....e  d
		.....&SQL(Delete From SQLUSER.DHC_EQFunds Where F_RowID=:CurID)
		...e  d //来自验收单,新增资金来源为0记录
		....s OCLDR=$p($g(^DHCEQEquip(FromID)),"^",77)
		....i OCLDR'=""  d
		.....k PLIST
		.....s PLIST(2)=FromID
		.....s PLIST(3)=FundsTypeID
		.....s PLIST(4)=0
		.....s PLIST(7)="1"
		.....s PLIST(6)=$o(^DHCEQFunds("0","CheckListType",OCLDR,FundsTypeID,0))
		.....s PLIST(8) =User
		.....s PLIST(9) =+$H
		.....s PLIST(10) = $P($H,",",2)
		.....s PLIST(11) ="N"
		.....;Mozy0075 2011-12-29
		.....Set PLIST(15) =FromType
		.....Set PLIST(16) =FromID
		.....&SQL(Insert Into SQLUSER.DHC_EQFunds Values :PLIST())
		..e  d //验收单及附件
		...i CurID'=""  d
		....&SQL(Delete From SQLUSER.DHC_EQFunds Where F_RowID=:CurID)
		..s Amount=Amount-CurFunds
		.e  d
		..i FromType=1  d //设备
		...i CurID'=""  d
		....&SQL(Update SQLUSER.DHC_EQFunds Set F_Fee=(:CurFunds-:Amount) Where F_RowID=:CurID)
		...e  d //来自验收单,新增资金来源为CurFunds-Amount金额记录
		....s OCLDR=$p($g(^DHCEQEquip(FromID)),"^",77)
		....k PLIST
		....s PLIST(2)=FromID
		....s PLIST(3)=FundsTypeID
		....s PLIST(4)=CurFunds-Amount
		....s PLIST(7)="0"
		....i OCLDR'=""  d
		.....s PLIST(6)=$o(^DHCEQFunds("0","CheckListType",OCLDR,FundsTypeID,0))
		.....s PLIST(7)="1"
		....s PLIST(8) =User
		....s PLIST(9) =+$H
		....s PLIST(10) = $P($H,",",2)
		....s PLIST(11) ="N"
		....;Mozy0075 2011-12-29
		....Set PLIST(15) =FromType
		....Set PLIST(16) =FromID
		....&SQL(Insert Into SQLUSER.DHC_EQFunds Values :PLIST())
		..e  d //验收单及附件
		...&SQL(Update SQLUSER.DHC_EQFunds Set F_Fee=(:CurFunds-:Amount) Where F_RowID=:CurID)
		..s Amount=0
	}
	q SQLCODE
}
*/

/****************************************************************************************/
/// Add By JDL 2012-2-15 JDL0116
/// 获取指定业务的 指定资金来源类型的 资金额
/// SourceType:业务类型
/// SourceID:业务ID
/// FundsType:资金来源类型 FundsType为空时,取非自有资金的 其他资金之和
/// FundsAmount:资金总额
/// 返回值：Amount^FundsRowID
ClassMethod GetSourceFunds(SourcType, SourceID, FundsAmount, FundsType, SelfFlag As %String = "")
{
	n (SourcType,SourceID,FundsAmount, FundsType, SelfFlag)
	i (SourcType="")||(SourceID="") q 0

	s SelfFundsFlag=##class(web.DHCEQCommon).GetSysInfo("990015")
	s SelfAmount=FundsAmount
	s Amount=""
	s FindRowID=""
	s TSource=""
	///Mozy0148
	Set DepreTotal=0
	Set SelfDepreTotal=0
	If SourcType=1
	{
		Set SelfDepreTotal=$Piece($Get(^DHCEQEquip(SourceID)),"^",35)
	}
	ElseIf SourcType=7
	{
		Set SelfDepreTotal=$Piece($Get(^DHCEQChangeAccount(SourceID)),"^",33)
	}
	//Modified By QW20190603 需求号:920859 入库资金来源保存后从记录中取
	s fundsid=$o(^DHCEQFunds("0","Source",SourcType,SourceID,0))
	;入库明细，且入库明细来源于验收时，从验收取数据
	if ((SourcType=3)&&($p(^DHCEQInStockList(SourceID),"^",18)="2" )&&(+SelfFlag=0))
	{  //End  By QW20190603 需求号:920859
		
		//add by zx 2019-02-19 附属设备入库生成资金来源处理 BUG号:829375
		i $p($g(^DHCEQInStockList(SourceID)),"^",22)'="" d
		.i FundsType=SelfFundsFlag d
		..s Amount=FundsAmount
		.e  d
		..s Amount=0
		e  d
		.s Amount=+..GetSourceFunds(0,$p(^DHCEQInStockList(SourceID),"^",19),FundsAmount, FundsType)
		s TSource="验收单"
	}
	elseif ((SourcType=7)&&($p(^DHCEQChangeAccount(SourceID),"^",10)<2))
	{
		;未审核调账记录，且调账来源于附件时，从附件取数据
		s AffixID=0
		f  s AffixID=$o(^DHCEQAffix("0","ChangeAccountAdd",SourceID,AffixID))  q:((AffixID=""))  d
		.s AffixAmount=$p(^DHCEQAffix(AffixID),"^",7)*$p(^DHCEQAffix(AffixID),"^",11)
		.q:AffixAmount'>0
		.s Amount=Amount+..GetSourceFunds(2,AffixID,AffixAmount, FundsType)
		s AffixID=0
		f  s AffixID=$o(^DHCEQAffix("0","ChangeAccountReduce",SourceID,AffixID))  q:((AffixID=""))  d
		.s AffixAmount=$p(^DHCEQAffix(AffixID),"^",7)*$p(^DHCEQAffix(AffixID),"^",11)
		.q:AffixAmount'>0
		.s Amount=Amount-..GetSourceFunds(2,AffixID,AffixAmount, FundsType)
		if Amount'="" s TSource="验收单"
	}
	if Amount'="" q ##Class(web.DHCEQCommon).FormatNumber(Amount,"",2)_"^^^"	///Mozy0148
	
	s FundsRowID=0
	f  s FundsRowID=$o(^DHCEQFunds("0","Source",SourcType,SourceID,FundsRowID))  q:((FundsRowID=""))  d
	.q:$p($g(^DHCEQFunds(FundsRowID)),"^",10)="Y"
	.s FundsTypeDR=$p($g(^DHCEQFunds(FundsRowID)),"^",2)
	.i ((SelfFundsFlag=FundsTypeDR)&&(FundsType=FundsTypeDR)) s FindRowID=FundsRowID
	.q:FundsTypeDR=SelfFundsFlag //过滤自有资金
	.s SelfAmount=SelfAmount-$p($g(^DHCEQFunds(FundsRowID)),"^",3)
	.Set SelfDepreTotal=SelfDepreTotal-$Piece($Get(^DHCEQFunds(FundsRowID)),"^",13)		///Mozy0148
	.q:((FundsType'="")&&(FundsTypeDR'=FundsType))
	.i FundsType'="" s FindRowID=FundsRowID
	.s Amount=Amount+$p($g(^DHCEQFunds(FundsRowID)),"^",3)
	.Set DepreTotal=DepreTotal+$Piece($Get(^DHCEQFunds(FundsRowID)),"^",13)			///Mozy0148
	///Mozy0148
	i FundsType=SelfFundsFlag Do
	.s Amount=SelfAmount
	.Set DepreTotal=SelfDepreTotal
	
	q ##Class(web.DHCEQCommon).FormatNumber(Amount,"",2)_"^"_FindRowID_"^"_TSource_"^"_DepreTotal
}

/// Add By JDL 2012-2-15 JDL0116
/// 重新计算更新下列业务单据的 资金来源信息
/// 验收明细,入库明细,附件,调账
/// 0:验收明细 1:设备 2:附件 3:入库明细 4:转移明细 5:退货明细 6:报废明细 7:调账明细
/// w ##Class(web.DHCEQFunds).GetSourceFunds("3","31", "2000", "1")
ClassMethod ChangeFundsBySourceIDNew(FromType, FromID, FundsAmount, SelfFlag As %String = "")
{
	;s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	;s User=1
	if (FromType'=0)&&(FromType'=2)&&(FromType'=3)&&(FromType'=7) q 0
	n (User,FromType,FromID,FundsAmount,SelfFlag)
	
	s SelfFundsFlag=##class(web.DHCEQCommon).GetSysInfo("990015")
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
	.s FundsInfo=##Class(web.DHCEQFunds).GetSourceFunds(FromType,FromID, FundsAmount, FTRowID, SelfFlag)
	.s TFundsRowID=$p(FundsInfo,"^",2)
	.s TSource=$p(FundsInfo,"^",3)
	.s TFee=+FundsInfo
	.Set DepreTotal=+$Piece(FundsInfo,"^",4)	///Mozy0148
	.k PLIST
	.s PLIST(3)=FTRowID
	.s PLIST(4)=TFee
	.s PLIST(7)="0"
	.;s PLIST(8) =User
	.s PLIST(9) =+$H
	.s PLIST(10) = $P($H,",",2)
	.s PLIST(11) ="N"
	.Set PLIST(14) = DepreTotal			///Mozy0148
	.s PLIST(15) =FromType
	.s PLIST(16) =FromID
	.i FromType=7  d	//调账记录增加变动前,变动后资金来源及累计折旧 DJ0135 begin
	..s EQRowID=$p($g(^DHCEQChangeAccount(FromID)),"^",1)
	..s FRowID=$o(^DHCEQFunds("0","EquipType",EQRowID,FTRowID,0))
	..s (TPreFundsFee,TPreDepreTotalFee)=0
	..i FRowID'=""  d
	...s TPreFundsFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FRowID)),"^",3),"",2)
	...s TPreDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FRowID)),"^",13),"",2)
	..s PLIST(19)=TPreFundsFee
	..s PLIST(20)=TPreDepreTotalFee
	..s TCurFundsFee=##Class(web.DHCEQCommon).FormatNumber(TPreFundsFee+TFee,"",2)
	..s TCurDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber(TPreDepreTotalFee+DepreTotal,"",2)
	..i TCurFundsFee<0 s SQLCODE=-3002
	..q:SQLCODE'=0
	..i TCurDepreTotalFee<0 s SQLCODE=-3003
	..q:SQLCODE'=0
	..i TCurDepreTotalFee>TCurFundsFee s SQLCODE=-3004
	..q:SQLCODE'=0
	.q:SQLCODE'=0	//DJ0135 end
	.i TFundsRowID>0  d
	..s TFundsFee=$p($g(^DHCEQFunds(TFundsRowID)),"^",3)
	..if TFee>0  d
	...;调账减值时,录入资金信息不能为正数
	...i (FromType=7)&&(FundsAmount<0) s SQLCODE=-3001
	...q:SQLCODE'=0
	...;仅重新计算自有资金,当自有资金与原信息不一致时更新
	...i ((TFee'=TFundsFee)&&(FTRowID=SelfFundsFlag))  d
	....&SQL(Update SQLUSER.DHC_EQFunds Set F_Fee=:TFee where F_SourceType=:FromType and F_SourceID=:FromID and F_FundsTypeDR=:FTRowID)
	..else  if TFee=0  d
	...///Mozy0148
	...If DepreTotal=0 Do
	....&SQL(Delete From SQLUSER.DHC_EQFunds where F_SourceType=:FromType and F_SourceID=:FromID and F_FundsTypeDR=:FTRowID)
	...Else  Do
	....&SQL(Update SQLUSER.DHC_EQFunds Set F_DepreTotal=:DepreTotal where F_SourceType=:FromType and F_SourceID=:FromID and F_FundsTypeDR=:FTRowID)
	..else  d
	...;仅做调账时,资金方可小于0，且需对于设备来讲，资金信息必须大于0
	...i (FromType=7)&&(FundsAmount'>0)  d
	....s TChangeEquipDR=$p($g(^DHCEQChangeAccount(FromID)),"^",1)
	....s TEquipFundsID=$o(^DHCEQFunds("0","EquipType",TChangeEquipDR,FTRowID,0))
	....i (TEquipFundsID'="")&&($p($g(^DHCEQFunds(TEquipFundsID)),"^",3)+TFee<0)  d
	.....s SQLCODE=-3001
	....e  d
	.....&SQL(Update SQLUSER.DHC_EQFunds Set F_Fee=:TFee where F_SourceType=:FromType and F_SourceID=:FromID and F_FundsTypeDR=:FTRowID)
	...e  d
	....s SQLCODE=-3001
	.e  d
	..;;;;;;;;;;;;;;;;;;;;;;;;;无资金来源信息;;;;;;;;;;;;;;;;;;;;;;;;;
	..if TFee>0  d
	...;调账减值时,录入资金信息不能为正数
	...i (FromType=7)&&(FundsAmount<0) s SQLCODE=-3001
	...q:SQLCODE'=0
	...;仅当入库明细及调账时,需要删除可能残留的资金信息
	...i ((FromType=3)||(FromType=7))  d
	....&SQL(Delete From SQLUSER.DHC_EQFunds where F_SourceType=:FromType and F_SourceID=:FromID and F_FundsTypeDR=:FTRowID)
	....i SQLCODE=100 s SQLCODE=0
	...
	...
	...i FromType=0 s PLIST(5)=FromID
	...i FromType=1 s PLIST(2)=FromID
	...i FromType=2 s PLIST(13)=FromID
	...&SQL(Insert Into SQLUSER.DHC_EQFunds Values :PLIST())
	..else  if TFee=0  d
	...///Mozy0148
	...If DepreTotal=0 Do
	....;资金来源金额和累计折旧都为0是相当于无效记录,应删除
	....&SQL(Delete From SQLUSER.DHC_EQFunds where F_SourceType=:FromType and F_SourceID=:FromID and F_FundsTypeDR=:FTRowID)
	....i SQLCODE=100 s SQLCODE=0
	...Else  Do
	....;累计折旧不为0时生成新记录
	....&SQL(Insert Into SQLUSER.DHC_EQFunds Values :PLIST())
	..else  d
	...;仅做调账时,资金方可小于0，且需对于设备来讲，资金信息必须大于0
	...i (FromType=7)&&(FundsAmount'>0)  d
	....s TChangeEquipDR=$p($g(^DHCEQChangeAccount(FromID)),"^",1)
	....s TEquipFundsID=$o(^DHCEQFunds("0","EquipType",TChangeEquipDR,FTRowID,0))
	....i (TEquipFundsID'="")&&($p($g(^DHCEQFunds(TEquipFundsID)),"^",3)+TFee<0)  d
	.....s SQLCODE=-3001
	....e  d
	.....&SQL(Insert Into SQLUSER.DHC_EQFunds Values :PLIST())
	...e  d
	....s SQLCODE=-3001
	
	q SQLCODE
}

/// Modified by JDL 2012-2-27 JDL0117
/// 获取其本身的所有资金来源及其最后一条资金来源ID
/// 返回值：资金来源金额^最后一条资金来源ID
/// w ##Class(web.DHCEQFunds).GetFundsAmountInfo("1",5)
ClassMethod GetFundsAmountInfo(SourceType, SouceID)
{
	n Amount,FundsID,LastFundsID
	s LastFundsID=""
	s Amount=0
	i ((SourceType'="")||(SouceID'=""))  d 
	.s FundsID=0
	.f  s FundsID=$o(^DHCEQFunds(0,"Source",SourceType,SouceID,FundsID)) q:(FundsID="")  d
	..q:$p(^DHCEQFunds(FundsID),"^",10)="Y"		;F_InvalidFlag
	..q:$p(^DHCEQFunds(FundsID),"^",6)="2"		;F_OperFlag
	..s Amount=Amount+$p($g(^DHCEQFunds(FundsID)),"^",3)		;Fee
	..s LastFundsID=FundsID
	
	q Amount_"^"_LastFundsID
}

/// add by zy ZY0090
/// 根据条件获取资金来源的金额
/// 入参:FromType来源类型：1设备  2  附件  
/// 		FromID：对应ID
/// 返回：FundsType,金额;FundsType,金额
/// w ##Class(web.DHCEQFunds).GetFundsInfo(2,6000)
ClassMethod GetFundsInfo(FromType, FromID)
{
	n (FromType,FromID)
	s FundsStr=""
	s Amount=0
	i FromType=1 s NodeStr="Equip"
	i FromType=2 s NodeStr="Affix"	
	
	s SelfFundsFlag=##class(web.DHCEQCommon).GetSysInfo("990015")
	
	s FRowID=0
	f  s FRowID=$o(^DHCEQFunds("0",NodeStr,FromID,FRowID))  q:FRowID=""  d
	.q:$p($g(^DHCEQFunds(FRowID)),"^",10)="Y"
	.s Funds=$p($g(^DHCEQFunds(FRowID)),"^",2)
	.i Funds'=""  d
	..s Funds=$p($g(^DHCEQCCode("DHCEQCFundsType",Funds)),"^",2)
	..s Funds=Funds_","_$p($g(^DHCEQFunds(FRowID)),"^",3)
	.i FundsStr=""  d
	..s FundsStr=Funds
	.e  d
	..s FundsStr=FundsStr_";"_Funds
	
	i FundsStr=""
	{
		s Funds=$p($g(^DHCEQCCode("DHCEQCFundsType",SelfFundsFlag)),"^",2)
		i FromType=1 
		{
			s Fee=$p($g(^DHCEQEquip(FromID)),"^",27)
			s FundsStr=Funds_","_Fee
		}
		i FromType=2
		{
			s Qty=$p($g(^DHCEQAffix(FromID)),"^",7)
			s Fee=$p($g(^DHCEQAffix(FromID)),"^",11)
			s FundsStr=Funds_","_(Qty*Fee)
		}
	}
	q FundsStr
}

/// w ##Class(web.DHCEQFunds).CheckFundsType(2,6000)
ClassMethod CheckFundsType(FundsTypeDR, Fee)
{
	;s ^DHCEQMozy("web.DHCEQFunds.CheckFundsType")=FundsTypeDR_","_Fee
	i +Fee=0 q 0
	n Flag,GroupID,tmpFTDR
	s Flag=0
	s GroupID=%session.Get("LOGON.GROUPID")
	
	i $d(^DHCEQCCode("DHCEQCGroupFundsType","0","Group",GroupID)) d
	.s Flag=1		;存在安全组设置则默认不能访问
	.i $d(^DHCEQCCode("DHCEQCGroupFundsType","0","Group",GroupID,FundsTypeDR)) s Flag=0
	
	i Flag=1 d
	.s Flag=""
	.s tmpFTDR=0
	.f  s tmpFTDR=$o(^DHCEQCCode("DHCEQCGroupFundsType","0","Group",GroupID,tmpFTDR)) q:(tmpFTDR="")  d
	..i Flag'="" s Flag=Flag_","
	..s Flag=Flag_$p($g(^DHCEQCCode("DHCEQCFundsType",tmpFTDR)),"^",2)
	q Flag
}

/// MZY0070	1756530		2021-02-20
/// 根据调账记录获取当前设备总值单位折旧额
/// w ##Class(web.DHCEQFunds).getUnitDepreFee(21)
ClassMethod getUnitDepreFee(FromID As %String = "")
{
	i +FromID=0 q 0
	n ChangeEquipDR,OriginalFee,DepreTotalFee
	s ChangeEquipDR=$p($g(^DHCEQChangeAccount(FromID)),"^",1)
	s OriginalFee = +$p($g(^DHCEQEquip(ChangeEquipDR)),"^",27)
	s DepreTotalFee = +$p($g(^DHCEQEquip(ChangeEquipDR)),"^",35)
	i (OriginalFee=0)||(DepreTotalFee=0) q 0
	q ##Class(web.DHCEQCommon).FormatNumber(DepreTotalFee/OriginalFee,"",5)
}

/// czf 2022-02-09
/// 获取台账或快照资金来源及折旧信息
/// 入参：	EquipIDs：设备ID串，逗号分隔
/// 		SnapRowID：快照ID
/// 返回值：自筹=123:112,财政=234:140,科研=345:235
/// w ##Class(web.DHCEQFunds).GetFundsInfoNew("1")
ClassMethod GetFundsInfoNew(EquipIDs, SnapRowID As %String = "")
{
	n length,i,equipRowID,node
	n FTDR,FRowID,FundsInfo,FundsType,FundsFee,FundsDepreTotal
	s Times=$H
	s node="web.DHCEQFunds.GetFundsInfoNew"
	k ^DHCEQTemp(node,Times,$j)
	i EquipIDs="" q ""
	
	s FundsInfo=""
	s length=$l(EquipIDs,",")
	f i=1:1:length d
	.s equipRowID=$p(EquipIDs,",",i)
	.q:equipRowID=""
	.i SnapRowID="" d
	..s FRowID=0
	..f  s FRowID=$o(^DHCEQFunds(0,"Equip",equipRowID,FRowID))  q:FRowID=""  d
	...s FundsStr=$g(^DHCEQFunds(FRowID))
	...q:$p(FundsStr,"^",10)="Y"
	...d BuildGetFundsInfo
	.e  d
	..s FRowID=0
	..f  s FRowID=$o(^DHCEQSnapShot(SnapRowID,"Funds",equipRowID,FRowID))  q:FRowID=""  d
	...s FundsStr=$g(^DHCEQSnapShot(SnapRowID,"Funds",equipRowID,FRowID))
	...q:$p(FundsStr,"^",10)="Y"
	...d BuildGetFundsInfo
	
	i length>1  d
	.s FundsInfo=""
	.s FTDR=0
	.f  s FTDR=$o(^DHCEQTemp(node,Times,$j,FTDR)) q:FTDR=""  d
	..s FundsFee=+$p($g(^DHCEQTemp(node,Times,$j,FTDR)),"^",1)
	..s FundsDepreTotal=+$p($g(^DHCEQTemp(node,Times,$j,FTDR)),"^",2)
	..d BuildDataFundsInfoNew
	
	k ^DHCEQTemp(node,Times,$j) 
	q FundsInfo
	
BuildGetFundsInfo
	s FTDR=$p(FundsStr,"^",2)
	s FundsFee=$fn(+$p(FundsStr,"^",3),"",2)
	s FundsDepreTotal=$fn(+$p(FundsStr,"^",13),"",2)
	i length=1  d
	.d BuildDataFundsInfoNew
	e  d
	.s FundsFee=+$p($g(^DHCEQTemp(node,Times,$j,FTDR)),"^",1)+FundsFee
	.s FundsDepreTotal=+$p($g(^DHCEQTemp(node,Times,$j,FTDR)),"^",2)+FundsDepreTotal
	.s ^DHCEQTemp(node,Times,$j,FTDR)=FundsFee_"^"_FundsDepreTotal
	
	quit	
BuildDataFundsInfoNew
	s FundsType=$p($g(^DHCEQCCode("DHCEQCFundsType",FTDR)),"^",2)
	i FundsInfo="" d
	.s FundsInfo=FundsType_"="_FundsFee_":"_FundsDepreTotal
	e  d
	.s FundsInfo=FundsInfo_","_FundsType_"="_FundsFee_":"_FundsDepreTotal
	
	quit
}

/// add by czf 2022-11-15
/// 获取业务资金来源
/// SourceType:0:验收明细
/// w ##class(web.DHCEQFunds).GetSourceFundsInfo("0",5394)
ClassMethod GetSourceFundsInfo(SourcType, SourceID)
{
	s FundsInfo=""
	s FundsRowID=0
	f  s FundsRowID=$o(^DHCEQFunds("0","Source",SourcType,SourceID,FundsRowID))  q:((FundsRowID=""))  d
	.q:$p($g(^DHCEQFunds(FundsRowID)),"^",10)="Y"
	.s FundsTypeDR=$p($g(^DHCEQFunds(FundsRowID)),"^",2)
	.s FundsFee=$p($g(^DHCEQFunds(FundsRowID)),"^",3)
	.q:+FundsFee=0
	.s FundsType=$p($g(^DHCEQCCode("DHCEQCFundsType",FundsTypeDR)),"^",2)
	.i FundsInfo="" d
	..s FundsInfo=FundsType_"="_FundsFee
	.e  d
	..s FundsInfo=FundsInfo_","_FundsType_"="_FundsFee
	
	q FundsInfo
}

}
