Class web.DHCEQAReduce Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 更新插入数据、删除数据
///  d ##Class(web.DHCEQAReduce).SaveData("1^1^114^1^20/11/2012^luosi^^1^2764","1^1^^1^3^100^1^hao^^^^^","")
ClassMethod SaveData(val, valList, DelRowID)
{
	new RowID,PLIST
	Set $ZT="ERRORSave"
	s Date=+$H
	s Time=$P($H,",",2)
	s User=$p(val,"^",8)
	s RowID=$p(val,"^",1)
	s PLIST(3)=$p(val,"^",2)   //AccessoryTypeDR
	s PLIST(4)=$p(val,"^",11)  //reducetype
	s PLIST(5)=$p(val,"^",3)   //ReduceLocDR
	s PLIST(7)=$p(val,"^",4)   //ProviderDR
	s PLIST(8)=$p(val,"^",8)   //MakerDR
	s PLIST(9)=##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",5),"date")   //MakeDate
	s PLIST(10)=Time           //MakeTime
	s PLIST(23)=$p(val,"^",6)  //Remark	需求号:275383 Mozy	2016-10-21
	s Job=$p(val,"^",9)
	s PLIST(24)="0"            //Status  add by zx 2015-09-14 BugZX0032
	TSTART
	if RowID=""
	{
		s PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQAReduce",+$H,$p(val,"^",3),$p(val,"^",2))	// Mozy	2016-10-21
		&SQL(Insert into SQLUSER.DHC_EQAReduce values :PLIST())
	}
	else
	{
		&SQL(Update SQLUSER.DHC_EQAReduce values :PLIST() where AR_RowID=:RowID)
	}
	s rowid=$G(%ROWID)
	s SQLCODE=..JudgeRLQuantityNum(rowid,Job,valList)
 	i SQLCODE
 	{
		TROLLBACK
		q SQLCODE
 	}
	s SQLCODE=..DeleteReduceList(DelRowID)
	i SQLCODE
 	{
		TROLLBACK
		q SQLCODE
 	}
	s SQLCODE=..SaveReduceList(rowid,Job,valList)
	i SQLCODE
 	{
		TROLLBACK
		q SQLCODE
 	}
 
 	;s SQLCODE=##Class(web.DHCEQStoreMoveNew).CheckOrder(2,rowid) //此方法需重写
 	i SQLCODE
 	{
		TROLLBACK
		q SQLCODE
 	}
	TCOMMIT
 	q rowid
ERRORSave 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORSave"_ErrorMsg     //返回错误消息 ;
}

/// 描述:判断按序列号转移的配件数量与选择的RowIDs是否一致QW0006-2014-08-21
/// w ##Class(web.DHCEQAMoveStock).JudgeAMSLQuantityNum("13","2780","1^^1^PJLZ^配件1^^41^1^false^true^50^1^50^^34^^^^")
ClassMethod JudgeRLQuantityNum(AMSRowID, Job, val)
{
	new (AMSRowID, Job, val)
	i AMSRowID="" q -1
	i val="" q 0
	s Flag=0
	s StoreLocDR=$p($g(^DHCEQAReduce(AMSRowID)),"^",4)		;StoreLocDR
	s Length=$l(val,"&")
	for i=1:1:Length
	{
		q:Flag'=0
		s valList=$p(val,"&",i)
		i ("true"'=$p(valList,"^",16))	continue //过滤掉不是按序列号管理的配件qw0005-2014-06-03
		s index=$p(valList,"^",1)  		//index
		s AMSLRowID=$p(valList,"^",2)  	//AMSLRowID要  TRwoID：DHCEQAReduceList
		s StockDetailDR=$p(valList,"^",3)
		; Modify by :qw0005 2014-06-03 
		; 序列号管理
		if ($p(valList,"^",5)=1)
		{			
			if AMSLRowID=""  //新增明细
			{
				s ^TEMPEQ("AMXList","EX",Job,index)=$p(valList,"^",3)
			}
			else
			{
				s ^DHCEQAReduceList(AMSLRowID,"EX","RowIDs")=$p(valList,"^",3)
				k ^TEMPEQ("AMXList",Job,AMSLRowID)
			}		
			//continue //单台设备不处理
		}
		else
		{
			;Modify by :QW0005 2014-5-8原为8，改为12
			s QuantityNum=$p(valList,"^",5)  	;SML_TQuantityNum=1序列号管理非批量所以不适用以下判断：需累加
 			s RowIDs=""
			s Len=0
 			if AMSLRowID=""  //新增明细
 			{
	 			s RowIDs=$g(^TEMPEQ("AMXList","EX",Job,index))
 			}
 			else
 			{
			 	s RowIDs=$g(^TEMPEQ("AMXList",Job,AMSLRowID))
	 			; 当InStockListDR相同时,才取原来的rowids
 				i (RowIDs="") s RowIDs=$g(^DHCEQAReduceList(AMSLRowID,"EX","RowIDs"))
	 		}
	 		if RowIDs'="" s Len=$l(RowIDs,",")
	 		if (Len'=QuantityNum)
	 		{
				 s Flag=##Class(web.DHCEQUpdateAccessoryByList).GetRowIDsByQuantityNum(StockDetailDR,QuantityNum,AMSLRowID,StoreLocDR,Job,index,"0") //movetype=0为退货
			}
			else
			{
				if (AMSLRowID'="")&&($Data(^TEMPEQ("AMXList",Job,AMSLRowID)))
				{
					s ^DHCEQAReduceList(AMSLRowID,"EX","RowIDs")=$g(^TEMPEQ("AMXList",Job,AMSLRowID))
					k ^TEMPEQ("AMXList",Job,AMSLRowID)
				}
			}
		}
	}
	q Flag
}

/// 更新插入退货明细业务表
/// 参数：PRowID:退货单rowid
///        val:明细串
ClassMethod SaveReduceList(PRowID, Job, val)
{
	new Length,RLRowID,Flag,valList
	k PLISTMX
	i val="" q 0
	i PRowID="" q -1
	s Flag=0
	s PLISTMX(2)=PRowID
	s Length=$l(val,"&")
	for i=1:1:Length
	{
		q:Flag'=0
		s valList=$p(val,"&",i)
		s index= $p(valList,"^",1)  		;index
		s RLRowID= $p(valList,"^",2)  		;RLRowID
		//QW00006-2014-08-21 保存标志位
		i $Piece(valList,"^",16)="true" d
		.s PLISTMX(9)="Y"		;RL_SerialFlag
		.s PLISTMX(8)="N"		;RL_BatchFlag
		e   d 
		.s PLISTMX(9)="N"		;RL_SerialFlag
		.s PLISTMX(8)="Y"		;RL_BatchFlag
		s PLISTMX(6)=$p(valList,"^",3)      ;ARL_StockDetailDR
		s PLISTMX(3)=$p(valList,"^",4) 		;ARL_ItemDR		
		;s PLISTMX(5)=$p(valList,"^",3)      ;ARL_BaseUOMDR
		s PLISTMX(7)=$p(valList,"^",15)		;ARL_ManuFactoryDR
		s PLISTMX(10)=$p(valList,"^",6)  	;ARL_ReturnFee
		s PLISTMX(11)=$p(valList,"^",5)  	;ARL_ReturnQtyNum
		s PLISTMX(12)=PLISTMX(10)*PLISTMX(11) ;ARL_Amount
		s PLISTMX(13)=$p(valList,"^",8)  	;ARL_TRemark
		s PLISTMX(14)=$p(valList,"^",7)  	;ARL_ReturnReasonDR(Hold1)
		s PLISTMX(15)=$p(valList,"^",10)  	;ARL_Hold2 //AInStockListDR modify by GBX;用作记录入库单详细id
		s PLISTMX(16)=$p(valList,"^",11)  	;ARL_Hold3
		s PLISTMX(17)=$p(valList,"^",12)  	;ARL_Hold4
		s PLISTMX(18)=$p(valList,"^",13)  	;ARL_Hold5
		if (RLRowID="")
		{			
			&SQL(Insert Into SQLUSER.DHC_EQAReduceList Values :PLISTMX())
			i SQLCODE 
			{
				s Flag=index_"^更新明细记录失败!"
				q
			}
			//QW00006-2014-08-21保存id串
			s RLRowID=$G(%ROWID)
			if ($p(valList,"^",16)="true")  //序列号管理
			{
				i $d(^TEMPEQ("AMXList","EX",Job,index))		//Modify DJ 2014-09-11
				{
					//modify by:qw 2014-4-25 
					s ^DHCEQAReduceList(RLRowID,"EX","RowIDs")=$g(^TEMPEQ("AMXList","EX",Job,index))
					//k ^TEMPEQ("AMXList","EX",Job,index) 
				}
				else
				{
					s ^DHCEQAReduceList(RLRowID,"EX","RowIDs")=$g(^TEMPEQ("AMXList","EX",Job,RLRowID))
				}
			}
		}
		else
		{
			&SQL(update sqluser.DHC_EQAReduceList values :PLISTMX() where ARL_RowID=:RLRowID)
			i SQLCODE s Flag=index_"^更新明细记录失败!"
		}
	}
	q Flag
}

/// 删除配件退货单明细表中的记录
/// 参数：DelRowID:明细表中的rowid
ClassMethod DeleteReduceList(DelRowid)
{
	new Length,RLRowID,Flag
	i DelRowid="" q 0
	s Flag=0
	s Length=$l(DelRowid,",")
	for i=1:1:Length
	{
		q:Flag'=0
		s RLRowID=$p(DelRowid,",",i)
		if (RLRowID>0)
		{
			&SQL(delete from  sqluser.DHC_EQAReduceList where ARL_RowID=:RLRowID)
			i SQLCODE s Flag=RLRowID_"^更新操作失败"
 			k ^DHCEQAReduceList(RLRowID,"EX","RowIDs")
		}
	}
	q Flag
}

/// 删除退货单
/// 通过把status更新为3使该退货单作废
ClassMethod DeleteData(val)
{
	n rowid
	s rowid=$p(val,"^",1)
	i rowid="" q ""
	s $ZT="ERRORDelete"
 TSTART
	&SQL(Update SQLUSER.DHC_EQAReduce set AR_Status=3 where AR_RowID=:rowid)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
 TCOMMIT
 q SQLCODE
ERRORDelete
  s ErrorMsg=$ZE
  TROLLBACK
  Quit "ERRORDelete_ErrorMsg"
}

/// 提交功能								
/// w ##Class(web.DHCEQAReduce).SubmitData("3^1^410^4^17/06/2013^^^1^5264^")
ClassMethod SubmitData(val)
{
	new (val,%session)
	Set $ZT="ERRORSubmit"
	s Date=+$H
	s Time=$p($H,",",2)
	s RowID=$p(val,"^",1)
	i RowID="" q ""
	s Status=$p($g(^DHCEQAReduce(RowID)),"^",23)
	i Status=3 q -1005
	s ReduceLocDR=$p(val,"^",3) //2014-4-9 10:52:12 BY：GBX
	s User=$p(val,"^",8)		//需求号:270539	Mozy	2016-11-4
	s AccessoryTypeDR=$p(val,"^",2)
	s PLIST(13)=User
	s PLIST(14)=$p(Date,",",1)
	s PLIST(15)=Time
	s PLIST(24)="1"    ;Status  add by zx 2015-09-14 BugZX0032
	s LocType=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0101",0))
	i '$d(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocType,ReduceLocDR)) q -1005
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("21")
	s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, AccessoryTypeDR,"","","","","")
	i ApproveSet="" q -4007
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, 0, "")
	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	s LastFlag=$P(ApproveFlow,"^",1)
	s NextStep=$P(ApproveFlow,"^",2)
	s NextRole=$P(ApproveFlow,"^",3)
	
	s AppInfoStatus="1"		;Status	
	s AuditFlag=0		//判断是否是最后一步,0:否;1:是
	i (AutoAuditFlag="Y")&&(NextStep="")
	{
		s AuditFlag=1
		s AppInfoStatus="2"
	}
	
	TSTART
	//删除已经审批过的意见
	s SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,RowID,"21",User)
	i SQLCODE
	{
		TROLLBACK
	 	q SQLCODE
	}
	if AuditFlag=1  //没有设置审批流,就直接审核
 	{
		s SQLCODE=##Class(web.DHCEQAReduce).LastAuditAction(RowID, User, Date)
		if SQLCODE'=0 //2011-05-27 DJ
		{
			TROLLBACK
			q SQLCODE
		}
 	}
 	else
 	{
	//更新审批信息
		s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,"","",AppInfoStatus)
	    If SQLCODE
	    {
		    TROLLBACK
		    Quit SQLCODE
	    }
 	}
	&SQL(update sqluser.DHC_EQAReduce values :PLIST() where AR_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	
	//add by zx 2016-03-03 消息处理 ZX0035
	s BussType="A04"
	s ReduceType=$p($g(^DHCEQAReduce(RowID)),"^",3)
	i ReduceType=1 s BussType="A03"
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo(BussType, RowID, User, ApproveFlow_"^"_ApproveSet, "N","",AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
 	TCOMMIT
 	q RowID
ERRORSubmit 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORSubmit"_ErrorMsg     //返回错误消息 ;
}

/// 退货单的查询
/// d ##Class(%ResultSet).RunQuery("web.DHCEQAReduce","Reduce","","114","2","","","","on","","")
Query Reduce(QXType, LocDR As %String = "", Status As %String = "", StartDate As %String = "", EndDate As %String = "", ReturnTypeDR As %String = "", WaitAD As %String = "", ApproveRole As %String = "", ReduceNo As %String = "") As %Query(ROWSPEC = "TRowID:%String,TReduceNo:%String,TLoc:%String,TLocDR:%String,TProvider:%String,TProviderDR:%String,TReduceDate:%String,TStatus:%String,TRemark:%String,TAckUser:%String,TAckUserDR:%String,TApproveRole:%String,TApproveStep:%String,TAccessoryType:%String,TAccessoryTypeDR:%String,TRow:%String,TApprovals:%String")
{
}

ClassMethod ReduceExecute(ByRef qHandle As %Binary, QXType, LocDR As %String = "", Status As %String = "", StartDate As %String = "", EndDate As %String = "", ReturnTypeDR As %String = "", WaitAD As %String = "", ApproveRole As %String = "", ReduceNo As %String = "") As %Status
{
	new repid, index,rowid,CurRole
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	// Mozy	888605	2019-5-21	Hisui改造
	s StartDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	s EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	s index=1
	s TRow=1
	s CurRole=""
	s rowid=0
	i StartDate="" s StartDate=0
	i EndDate="" s EndDate=+$H
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("21") //Modifed BY:GBX 2014-4-9 
	f  s rowid=$o(^DHCEQAReduce(rowid)) q:rowid=""  d
	.d ResetVariablesGetInStock
	.s TRowID=rowid
	.s TLocDR=$P($g(^DHCEQAReduce(rowid)),"^",4)    ///退货科室ID
	.q:(LocDR'="")&&(LocDR'=TLocDR)
	.q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TLocDR)))
	.s ReduceDate=$P($g(^DHCEQAReduce(rowid)),"^",8)    ///退货日期
	.q:(StartDate>ReduceDate)||(ReduceDate>EndDate)
	.s TStatus=$P($g(^DHCEQAReduce(rowid)),"^",23)
	.q:(Status'="")&&(Status'=TStatus)      ///状态
	.s AIRowID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveType,rowid,0))
	.i AIRowID'="" s CurRole=$p(^DHCEQApproveInfo(AIRowID),"^",4)
	.i (WaitAD="on")&&(CurRole'="") q:(CurRole'=ApproveRole)   ///退货审核角色
	.s TReduceNo=$p(^DHCEQAReduce(rowid),"^",1)
	.q:TReduceNo=""
	.q:(ReduceNo'="")&&($e(TReduceNo,1,$l(ReduceNo))'=ReduceNo)   ///退货单号	Modifed By HZY 2013-7-3
	.s TLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)  ///退货科室
	.s TProviderDR = $p($g(^DHCEQAReduce(rowid)),"^",6) //供应商
	.s TProvider =  ##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	.s TReduceDate = ##class(web.DHCEQCommon).TransValueToPage(ReduceDate,"date") //退货日期
	.s TAccessoryTypeDR=$p($g(^DHCEQAReduce(rowid)),"^",2)   ///配件类组
	.// Mozy	888605	2019-5-21	Hisui改造
	.q:(##class(web.DHCEQACommon).AccessoryTypeIsIn(TAccessoryTypeDR)'=0)
	.s TAccessoryType=##Class(web.DHCEQCommon).GetTrakNameByID("AccessoryType", TAccessoryTypeDR)
	.s TRemark = $p($g(^DHCEQAReduce(rowid)),"^",22) //备注
	.s TAckUserDR = $p($g(^DHCEQAReduce(rowid)),"^",15) //账目确认人	Mozy003003	1246572		2020-3-27
	.s TAckUser= ##class(web.DHCEQCommon).GetTrakNameByID("user",TAckUserDR)
	.i TStatus'="" s TStatus=$Case(TStatus,"0":"新增","1":"提交","2":"审核","3":"作废")
	.s TReduceType=$p($g(^DHCEQAReduce(rowid)),"^",3)
	.q:(ReturnTypeDR'="")&&(1'=TReduceType) //Modify BY:GBX 2014-8-20 23:17:21 退货和减少分开，1为退货，其他为减少
	.q:(ReturnTypeDR="")&&(1=TReduceType) 
	.;i TOutType'="" s TOutType=$p($g(^DHCEQCCode("DHCEQCOutType",TOutType)),"^",2)
	.;i TToDept'="" s TToDept=$p($g(^DHCEQCCode("DHCEQCFromToDept",TToDept)),"^",2)
	.s TApprovals="无"
	.s ApproveInfo=##Class(web.DHCEQApprove).GetApproveInfoBySourceID("21",rowid) //2010-08-31 DJ begin
	.i ApproveInfo'=""  d
	..s TApproveRole=$p(ApproveInfo,"^",9)
	..s TApproveStep=$p(ApproveInfo,"^",5)
	..s TApproveRoleDR=$p(ApproveInfo,"^",6)
	..i TApproveRoleDR'="" s TApprovals=$p(^DHCEQCCode("DHCEQCApproveRole",TApproveRoleDR),"^",2)	//add by CZF0080 2020-02-24
	.i $P($g(^DHCEQAReduce(rowid)),"^",23)=0 s TApprovals=""	// Mozy003003	1246572		2020-3-27
	.d OutputRowGetReduceList
	
    quit $$$OK
OutputRowGetReduceList
   s Data=$lb(TRowID,TReduceNo,TLoc,TLocDR,TProvider,TProviderDR,TReduceDate,TStatus,TRemark,TAckUser,TAckUserDR,TApproveRole,TApproveStep,TAccessoryType,TAccessoryTypeDR,TRow,TApprovals)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set TRow=TRow+1
	quit
ResetVariablesGetInStock
    s (TRowID,TReduceNo,TLoc,TLocDR,TProvider,TProviderDR,TReduceDate,TStatus,TRemark,TAckUser,TAckUserDR,TApproveRole,TApproveStep,TAccessoryType,TAccessoryTypeDR,TReduceType,TApprovals)=""
    quit
}

ClassMethod ReduceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReduceExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ReduceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReduceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// modify By:GBX 2014-8-27 15:23:46

Query ReduceList(RowID As %String = "") As %Query(ROWSPEC = "TTotalFee:%String,TAccessory:%String,TAccessoryDR:%String,TRowID:%String,TManuFactory:%String,TReturnQtyNum:%String,TReturnFee:%String,TReturnReason:%String,TReturnReasonDR:%String,TRemark:%String,TRow:%String,TJob:%String,TStockDetailDR:%String,TManuFactoryDR:%String,TFlag:%String,TSerialFlag:%String,TAInStockListDR:%String,TInStockNo:%String,TInvoiceNos:%String")
{
}

/// 退货明细的查询
/// d ##Class(%ResultSet).RunQuery("web.DHCEQAReduce","ReduceList","1")
ClassMethod ReduceListExecute(ByRef qHandle As %Binary, RowID As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s Job=$J
	s (TRow,TotalQty,Amount)=0
	s TotalFlag=##class(web.DHCEQCommon).GetSysInfo("301006")
	i TotalFlag="1"  s index=2
	i RowID'=""  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQAReduceList(0,"Reduce",RowID,rowid)) q:rowid=""  d  
	..d ResetVariablesGetReturnList
	..s TRow=TRow+1
	..s TAccessoryDR=$p(^DHCEQAReduceList(rowid),"^",2)
	..i TAccessoryDR'=""  d
	...s TAccessory=$p(^DHCEQCCode("DHCEQCAccessory",TAccessoryDR),"^",2)
	..e  d
	...s TAccessory=""
	..s TManuFactoryDR=$p(^DHCEQAReduceList(rowid),"^",6)
	..i TManuFactoryDR'=""  d
	...s TManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)	// MZY0061	1580585		2020-12-2
	..e  d
	...s TManuFactory=""
	..s TReturnQtyNum=$p(^DHCEQAReduceList(rowid),"^",10)
	..s TotalQty=TotalQty+TReturnQtyNum                   ///总退货量
	..s TReturnFee=$p(^DHCEQAReduceList(rowid),"^",9)
	..s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TReturnQtyNum*TReturnFee,"",2)
	..s Amount=Amount+TTotalFee                           ///总退货费用
	..s TReturnReasonDR=$p(^DHCEQAReduceList(rowid),"^",13)  ///退货原因（Hold1）
	..i TReturnReasonDR'=""  d 
	...s TReturnReason=$p(^DHCEQCCode("DHCEQCReturnReason",TReturnReasonDR),"^",2)
	..e  d
	...s TReturnReason=""
	..s TAInStockListDR=$p(^DHCEQAReduceList(rowid),"^",14)  //入库明细ID(Hold2) modify BY:GBX 2014-8-27 14:08:54
	..//Mozy	2017-2-2
	..i TAInStockListDR'="" d
	...s TAInStockDR=$p($g(^DHCEQAInStockList(TAInStockListDR)),"^",1)
	...s TInStockNo=$p($g(^DHCEQAInStock(TAInStockDR)),"^",6)
	...s TInvoiceNos=$p($g(^DHCEQAInStockList(TAInStockListDR)),"^",19)
	..s TRemark=$p(^DHCEQAReduceList(rowid),"^",12)
	..s TStockDetailDR=$p($g(^DHCEQAReduceList(rowid)),"^",5)	//Add By HZY 2013-6-17 
	..s TRowID=rowid
	..s TJob=Job
	..; //输出标志位
	..s TSerialFlag=$p(^DHCEQAReduceList(rowid),"^",8)
	..i ((TSerialFlag="Y")&&(TReturnQtyNum>1))  d
	...s TFlag=1
	..e  d
	...s TFlag=0
	..i TSerialFlag="Y" d
	...s TSerialFlag=1
	..e  d
	...s TSerialFlag=0
	..d OutputRowGetReturnList
	
	i TRow=0  d
	.d ResetVariablesGetReturnList
	.s TRow=1
	.s TJob=Job
	.d OutputRowGetReturnList
	
	i TotalFlag>0  d
	.d ResetVariablesGetReturnList
	.s TRowID=-1
	.s TRow="合计"
	.s TReturnQtyNum=TotalQty
	.s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(Amount,"",2)
	.i TotalFlag="1"  d
	..s index=1
	.e  d
	..s index=index+1
	.s TJob=Job
	.d OutputRowGetReturnList
	Quit $$$OK
ResetVariablesGetReturnList
   s (TTotalFee,TAccessory,TAccessoryDR,TRowID,TManuFactory,TReturnQtyNum,TReturnFee,TReturnReason,TReturnReasonDR,TRemark,TJob,TStockDetailDR,TManuFactoryDR,TFlag,TSerialFlag,TAInStockListDR,TInStockNo,TInvoiceNos)=""
   quit
OutputRowGetReturnList
   s Data=$lb(TTotalFee,TAccessory,TAccessoryDR,TRowID,TManuFactory,TReturnQtyNum,TReturnFee,TReturnReason,TReturnReasonDR,TRemark,TRow,TJob,TStockDetailDR,TManuFactoryDR,TFlag,TSerialFlag,TAInStockListDR,TInStockNo,TInvoiceNos)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod ReduceListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReduceListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ReduceListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReduceListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOneList(rowid)
{
	new (rowid)
	i (^DHCEQAReduceList(rowid))="" q
	s Item=""
	s AccessoryDR=$p(^DHCEQAReduceList(rowid),"^",2)
	i AccessoryDR'=""  d
	.s Item=$p(^DHCEQCCode("DHCEQCAccessory",AccessoryDR),"^",2)
	s Model=$p(^DHCEQAReduceList(rowid),"^",3)
	s Uom=$p(^DHCEQAReduceList(rowid),"^",4)
	i Uom'="" s Uom=##Class(web.DHCEQCommon).GetTrakNameByID("uom",Uom)
	s Quantity=$p(^DHCEQAReduceList(rowid),"^",10)
	s Price=$p(^DHCEQAReduceList(rowid),"^",9)
	i Price'="" s Price=##Class(web.DHCEQCommon).FormatNumber(Price,"",4)  //Modify BY:GBX 2014-9-13 18:55:39
	s Amount=$p(^DHCEQAReduceList(rowid),"^",11)
	i Amount'="" s Amount=##Class(web.DHCEQCommon).FormatNumber(Price,"",4)  //Modify BY:GBX 2014-9-13 18:55:39
	s Remark=$p(^DHCEQAReduceList(rowid),"^",12)
	q Item_"^"_Model_"^"_Uom_"^"_Quantity_"^"_Price_"^"_Amount_"^"_Remark
}

/// Creator：      WL
/// CreatDate：    2019-11-20
/// Description:   润乾打印(配件退货单明细)
/// Input：        RowID:配件退货
/// d ##class(%ResultSet).RunQuery("web.DHCEQAReduce","ReduceListPrint","1") 
Query ReduceListPrint(RowID As %String = "", CurGroupID As %String = "") As %Query(ROWSPEC = "TItem:%String,TModel:%String,TUom:%String,TQuantity:%String,TPrice:%String,TAmount:%String,TRemark:%String") [ SqlProc ]
{
}

ClassMethod ReduceListPrintExecute(ByRef qHandle As %Binary, RowID As %String = "", CurGroupID As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s Job=$J
	i RowID'=""  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQAReduceList(0,"Reduce",RowID,rowid)) q:rowid=""  d  
	..d ResetVariablesReduceListPrint
	..s Item=""
	..s AccessoryDR=$p(^DHCEQAReduceList(rowid),"^",2)
	..i AccessoryDR'=""  d
	...s TItem=$p(^DHCEQCCode("DHCEQCAccessory",AccessoryDR),"^",2)
	..s TModel=$p(^DHCEQAReduceList(rowid),"^",3)
	..s TUomDR=$p(^DHCEQAReduceList(rowid),"^",4)
	..s TUom=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUomDR)	// MZY0126	2662625		2022-06-13
	..s TQuantity=$p(^DHCEQAReduceList(rowid),"^",10)
	..s TPrice=$p(^DHCEQAReduceList(rowid),"^",9)
	..i TPrice'="" s TPrice=##Class(web.DHCEQCommon).FormatNumber(TPrice,"",4)  
	..s TAmount=$p(^DHCEQAReduceList(rowid),"^",11)
	..// Mozy0244	2020-1-20	1177974
	..i TAmount="" s TAmount=TPrice*TQuantity
	..s TAmount=##Class(web.DHCEQCommon).FormatNumber(TAmount,"",4)  
	..s TRemark=$p(^DHCEQAReduceList(rowid),"^",12)
	..d OutputRowReduceListPrint
	Quit $$$OK
ResetVariablesReduceListPrint
   s (TItem,TModel,TUom,TQuantity,TPrice,TAmount,TRemark)=""
   quit
OutputRowReduceListPrint
   s Data=$lb(TItem,TModel,TUom,TQuantity,TPrice,TAmount,TRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod ReduceListPrintFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReduceListPrintExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ReduceListPrintClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReduceListPrintExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：      WL
/// CreatDate：    2019-11-20
/// Description:   润乾打印(配件退货单)
/// Input：        RowID:配件退货
/// d ##class(%ResultSet).RunQuery("web.DHCEQAReduce","ReducePrint","1") 
Query ReducePrint(RowID As %String = "", CurGroupID As %String = "") As %Query(ROWSPEC = "TAccessoryType:%String,TMaker:%String,title:%String,TReduceNo:%String,TLoc:%String,TProvider:%String,TReduceDate:%String") [ SqlProc ]
{
}

/// d ##Class(%ResultSet).RunQuery("web.DHCEQAReduce","ReducePrint","1")
ClassMethod ReducePrintExecute(ByRef qHandle As %Binary, RowID As %String = "", CurGroupID As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s Job=$J
	s (TReduceNo,TLoc,TProvider,TReduceDate,TRemark)=""
	i RowID'=""  d
	.s TReduceNo=$p($g(^DHCEQAReduce(RowID)),"^",1)
	.s TReduceType= $p($g(^DHCEQAReduce(RowID)),"^",3)
	.s TAccessoryTypeDR=$p($g(^DHCEQAReduce(RowID)),"^",2)
	.q:(##class(web.DHCEQACommon).AccessoryTypeIsIn(TAccessoryTypeDR,CurGroupID)'=0)
	.s TAccessoryType=##Class(web.DHCEQCommon).GetTrakNameByID("AccessoryType", TAccessoryTypeDR)
	.i TReduceType=1 s title="退货"
	.e  s title="减少"
	.s TLocDR=$p($g(^DHCEQAReduce(RowID)),"^",4)
	.i TLocDR'="" s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TLocDR)
	.s TProviderDR=$p($g(^DHCEQAReduce(RowID)),"^",6)
	.s TMakerDR=$p($g(^DHCEQAReduce(RowID)),"^",7)
	.i TMakerDR'="" s TMaker =  ##Class(web.DHCEQCommon).GetTrakNameByID("user", TMakerDR)
	.i TProviderDR'="" s TProvider = ##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	.s ReduceDate=$P($g(^DHCEQAReduce(RowID)),"^",8)    
	.s TReduceDate = ##class(web.DHCEQCommon).TransValueToPage(ReduceDate,"date") //退货日期
	.d OutputRowReducePrint
	Quit $$$OK
OutputRowReducePrint
   s Data=$lb(TAccessoryType,TMaker,title,TReduceNo,TLoc,TProvider,TReduceDate)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod ReducePrintFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReducePrintExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ReducePrintClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReducePrintExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 审核功能
ClassMethod AuditData(val, CurRole, RoleStep, EditFieldsInfo)
{
	new RowID,Date,ApproveType,ApproveSet,ApproveFlow,AutoAuditFlag,LastFlag,NextStep,NextRole,Actions,ReduceType
	k PLIST
	s (RowID,Date,ApproveType,ApproveSet,ApproveFlow,AutoAuditFlag,LastFlag,NextStep,NextRole,Actions,ReduceType)=""
	Set $ZT="ERRORAudit"
	s RowID=$P(val,"^",1)
	i RowID="" q ""
	s Date=+$H
	s User=$P(val,"^",8)
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("21")
	s ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("21", RowID)
	i ApproveSet="" q -4007	
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, RoleStep, CurRole)
	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	s LastFlag=$P(ApproveFlow,"^",1)
	s NextStep=$P(ApproveFlow,"^",2)
	s NextRole=$P(ApproveFlow,"^",3)
	
	s AppInfoStatus="1"		;Status	
	
	s AuditFlag=0		//判断是否是最后一步,0:否;1:是
	i ((NextStep="")||(LastFlag="Y"))
	{
		i ("2"=$p($g(^DHCEQAReduce(RowID)),"^",23)) //QW0006-2014-08-21 判断状态
		{
	    		 TROLLBACK			
	     		q -1010
		}
		s AuditFlag=1
		s AppInfoStatus="2"
	}
	TSTART	
	;生成审批记录
	s SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,"","",CurRole,RoleStep)
	if SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	//编辑要修改的字段
	if EditFieldsInfo'=""
	{
		s SQLCODE=##Class(web.DHCEQApprove).EditRoleReqFields(EditFieldsInfo)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	//做定义要做的操作
	s Actions=##Class(web.DHCEQCApproveAction).GetApproveActions(ApproveSet, RoleStep, CurRole)
	if Actions'=""				//执行当前角色要执行的动作
	{
		s SQLCODE=##Class(web.DHCEQCApproveAction).DoActions(RowID,User,Actions,EditFieldsInfo)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	//后一步审核的操作
	i AuditFlag=1
	{
		s SQLCODE=##Class(web.DHCEQAReduce).LastAuditAction(RowID, User, Date)
		if SQLCODE'=0 //2011-05-27 DJ
		{
			TROLLBACK
			q SQLCODE
		}
	}
	;记录单据当前审批状态
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,RoleStep,CurRole,AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	//add by zx 2016-03-03 消息处理 ZX0035
	s BussType="A04"
	s ReduceType=$p($g(^DHCEQAReduce(RowID)),"^",3)
	i ReduceType=1 s BussType="A03"
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo(BussType, RowID, User, ApproveFlow_"^"_ApproveSet, "N",CurRole,AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
 	q RowID

ERRORAudit
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORAudit"_ErrorMsg     //返回错误消息 ;*/
}

/// 最后一部审核要执行的动作
ClassMethod LastAuditAction(RowID, User, Date)
{
	new RLRowID,SQLCODE
	i RowID="" q ""
	k PLIST
	s PLIST(16)=User	//##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s PLIST(17)=+$H
	s PLIST(18)=$p($H,",",2) //qw0006-2014-08-21 19->18
	s PLIST(24)="2"
	;改变库存量
	s RLRowID=0
	f  s RLRowID=$o(^DHCEQAReduceList(0,"Reduce",RowID,RLRowID)) q:RLRowID=""  d
	.s QtyNum=$p($g(^DHCEQAReduceList(RLRowID)),"^",10)
	.s StockDetailDR=$p($g(^DHCEQAReduceList(RLRowID)),"^",5)
	.s ReduceDR=$p($g(^DHCEQAReduceList(RLRowID)),"^",1)
	.s ReduceType=$p($g(^DHCEQAReduce(ReduceDR)),"^",3)
	.s StockDetailNum=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",17)
	.s Num=StockDetailNum-QtyNum  ///库存明细中未被占用的库存量
	.s SQLCODE=..CheckNum(Num,QtyNum,ReduceType,RLRowID)
	i $p($g(^DHCEQAReduce(RowID)),"^",23)=2 q -1010
	&SQL(update sqluser.DHC_EQAReduce values:PLIST() where AR_RowID=:RowID)
	i SQLCODE q SQLCODE
	q SQLCODE
}

/// 审核完成后减少库存总量和库存明细库存量
/// 增加退掉的配件明细
/// 参数：RowID为库存明细rowid
///      Stock为该明细中没有被其他单据占据的库存量
///      ReduceNum为审核的退货数量
///      QW-2014-08-28 修改批号和序列号库存明细的处理
/// d ##Class(web.DHCEQAReduce).CheckNum("3","1","3")      
ClassMethod CheckNum(Stock, ReduceNum, ReduceType, RLRowID)
{
	
	s StockDetailDR=$p($g(^DHCEQAReduceList(RLRowID)),"^",5)
	s Num=Stock
	s QtyNum=ReduceNum
	i ReduceType=1  d
	.s reducetype=3
	e  d
	.s reducetype=2
	//s $ZT="ERROR"	//Modified By HZY 2013-7-4 事务不能嵌套.
	//TSTART	//Modified By HZY 2013-7-4 事务不能嵌套.
	i $p($g(^DHCEQAReduceList(RLRowID)),"^",8)="Y"   //序列号管理 直接修改状态和数量
	{
		s RLRowIDs=^DHCEQAReduceList(RLRowID,"EX","RowIDs")
		s count=$l(RLRowIDs,",")
		f i=1:1:count  d
		.k PLISTMIX
		.s PLISTMIX(13)=reducetype  //Status
		.s RowIDs=$p(RLRowIDs,",",i)
		.&SQL(update sqluser.DHC_EQAStockDetail values :PLISTMIX() where ASD_RowID=:RowIDs)
	}
	else{ //批号管理则需在明细加上一条退库明细
		//BY GBX 2014-4-11 15:06:19 GBX0004
		k PLISTMIX
		s PLISTMIX(2)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",1)  //LocDR
		s PLISTMIX(3)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",2)  //AccessoryDR
		s PLISTMIX(4)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",3)  //AInStockListDR
		s PLISTMIX(5)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",4)  //code
		s PLISTMIX(6)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",5)  //desc
		s PLISTMIX(7)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",6)  //batchno
		s PLISTMIX(8)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",7) //expirydate
		s PLISTMIX(9)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",8)  //Price
		s PLISTMIX(10)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",9)  //seriano
		s PLISTMIX(11)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",10)  //no
		s PLISTMIX(12)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",11)  //AccessoryTypeDR
		s PLISTMIX(13)=reducetype  //Status
		s PLISTMIX(14)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",13)  //baseUOMDR
		s PLISTMIX(15)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",14)  //ManuFactory
		s PLISTMIX(16)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",15)  //Model
		s PLISTMIX(17)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",16)  //provider
		s PLISTMIX(18)=QtyNum //Stock
		s PLISTMIX(19)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",18)  //FreezeStock
		s PLISTMIX(20)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",19)  //StartDate
		s PLISTMIX(21)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",20)  //DisuseDate
		s PLISTMIX(22)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",21)  //StockDR
		s PLISTMIX(23)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",22)  //InType
		s PLISTMIX(24)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",23)  //InSourceID
		s PLISTMIX(25)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",24)  //ToType
		s PLISTMIX(26)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",25)  //ToSourceI
		s PLISTMIX(27)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",26)  //HasStockFlag
		s PLISTMIX(28)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",27)  //OriginDR	
		&SQL(update sqluser.DHC_EQAStockDetail set ASD_Stock=:Num where ASD_RowID=:StockDetailDR )
		i SQLCODE   
		{
			q SQLCODE
		}
		/*	Modify DJ 2016-12-09
		&SQL(insert into sqluser.DHC_EQAStockDetail values :PLISTMIX())
		i SQLCODE
		{
			//TROLLBACK
			q SQLCODE
		}
		*/
	}

	s StockDR=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",21)
	s StockNum=$p($g(^DHCEQAStock(StockDR)),"^",10)
	s ReturnNum=StockNum-QtyNum
	;s ^DHCEQTemp("wen",StockDetailDR)=StockDR_"^"_StockNum_"^"_ReturnNum_"^"_QtyNum
	&SQl(update sqluser.DHC_EQAStock set AS_Stock=:ReturnNum where AS_RowID=:StockDR)
	i SQLCODE
	{
		//TROLLBACK
		q SQLCODE
	}
	//TCOMMIT
	q SQLCODE
	
 /*ERROR	//Modified By HZY 2013-7-4 事务不能嵌套.
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERROR"_ErrorMsg
 */
}

/// Mozy		888605	2019-5-21	Hisui改造
ClassMethod StatusList(name, width, Type, Value As %Library.String = "") As %String
{
	;;下拉列表
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")
	s selectedone=$case(Value,0:"selected",:"")
	s selectedtwo=$case(Value,1:"selected",:"")
	s selectedthree=$case(Value,2:"selected",:"")
	
	w "<option value=></option>"
	i (Type="")||(Type="0") w "<option value=0 "_selectedone_">"_##Class(web.DHCEQAInStock).GetAInStockStatusList(0)_"</option>"
	i Type'="2" w "<option value=1 "_selectedtwo_">"_##Class(web.DHCEQAInStock).GetAInStockStatusList(1)_"</option>"
	w "<option value=2 "_selectedthree_">"_##Class(web.DHCEQAInStock).GetAInStockStatusList(2)_"</option>"
	
	w "</select>",!
}

ClassMethod GetStatu(TStatus)
{
	;q $CASE(TStatus,"0":"新增","1":"提交","3":"出库审核","2":"账目审核",:"没有定义")
	q $CASE(TStatus,"0":"新增","1":"提交","2":"审核",:"没有定义")
}

/// d ##class(web.DHCEQAReduce).GetReturnList(17)
ClassMethod GetReturnList(RowID) As %String
{
	new (RowID)
	s (ReturnList,ReturnListMx)=""
	s ReturnList=$g(^DHCEQAReduce(RowID))
	s ReturnListMx=ReturnListMx_"^"    ///配件类组
	i ($p(ReturnList,"^",2)'="")  d
	.s ReturnListMx=ReturnListMx_$p(^DHCEQCCode("DHCEQCAccessoryType",$p(ReturnList,"^",2)),"^",2)	
	s ReturnListMx=ReturnListMx_"^" ///退货类型
	i ($p(ReturnList,"^",3)'="")  d
	.s ReturnListMx=ReturnListMx_$CASE($p(ReturnList,"^",3),"1":"退货","2":"报损","3":"消耗","4":"盘亏","9":"其他")	
	s ReturnListMx=ReturnListMx_"^"   ///退货科室
	i ($p(ReturnList,"^",4)'="")  d
	.s ReturnListMx=ReturnListMx_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(ReturnList,"^",4))
	s ReturnListMx=ReturnListMx_"^"   ///供货商
	i ($p(ReturnList,"^",6)'="")  d
	.s ReturnListMx=ReturnListMx_##class(web.DHCEQCommon).GetTrakNameByID("prov",$p(ReturnList,"^",6))
	s ReturnListMx=ReturnListMx_"^"   ///制单人
	i ($p(ReturnList,"^",7)'="")  d
	.s ReturnListMx=ReturnListMx_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(ReturnList,"^",7))
	s ReturnListMx=ReturnListMx_"^"  ///备注
	i ($p(ReturnList,"^",22)'="")  d 
	.s ReturnListMx=ReturnListMx_$p(ReturnList,"^",22)
	s ReturnListMx=ReturnListMx_"^"
	i ($p(ReturnList,"^",23)'="")  d   ///状态
	.s ReturnListMx=ReturnListMx_$p(ReturnList,"^",23)
	s ReturnListMx=ReturnListMx_"^"	//Add By HZY 2013-7-1 增加退货日期
	i ($p(ReturnList,"^",8)'="")  d
	.s ReturnListMx=ReturnListMx_##class(web.DHCEQCommon).TransValueToPage($p(ReturnList,"^",8),"date")
	s ReturnListMx=ReturnListMx_"^"
	s apprInfo=##Class(web.DHCEQApprove).GetApproveInfoBySourceID("21",RowID)
	i apprInfo'=""  d
	.s ReturnListMx=ReturnListMx_apprInfo
	s ReturnList=ReturnList_ReturnListMx
	q ReturnList
}

/// d ##Class(web.DHCEQAReduce).GetAccessoryById("Accessory",1)
ClassMethod GetAccessoryById(desc, rowid) As %String
{
	i (rowid="")  q ""
	if (desc="Asory")   ///配件
	{
	   q $p($g(^DHCEQAStockDetail(rowid)),"^",2)
	}
	elseif (desc="Factory")   ///生产商
	{
		
	      q $p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",1)
	   
	}
	elseif (desc="Num")   ///可退数量
	{
		q $p(^DHCEQAStockDetail(rowid),"^",17)
		
	}
	elseif (desc="Fee")
	{
		q $p(^DHCEQAStockDetail(rowid),"^",8)
		
	}
}

/// 被退货单占用的配件数量
/// 需增加减少单占用的数量
/// RowID为DHC_EQAReduceList中的StockDetailDR
/// vMXRowID 转移明细、退货明细或维修单配件明细RowID
/// vChangeType     0:退货,减少单	1:转移单 	2:维修单
/// w ##Class(web.DHCEQAReduce).CheckAccessoryDR(1723,485,3,2)
/// w ##Class(web.DHCEQAReduce).CheckAccessoryDR(1723,485,"",2,"")
ClassMethod CheckAccessoryDR(RowID, LocDR, vMXRowID, vChangeType)
{
	new (RowID, LocDR, vMXRowID, vChangeType)
	;s ^DHCEQMozy("CheckAccessoryDR",$h)=RowID_","_LocDR_","_vMXRowID_","_vChangeType
	s movenum=0
	s reducenum=0
	s maintnum=0
	s Num=0
	
	//被减少单占据的数量
	s Status=""
	f  s Status=$o(^DHCEQAReduce(0,"StatusReturnloc",Status)) q:Status=""  d
	.q:(Status>1)
	.s rowid=0
	.f  s rowid=$o(^DHCEQAReduce(0,"StatusReturnloc",Status,LocDR,rowid)) q:rowid=""  d
	..s mxrowid=0
	..f  s mxrowid=$o(^DHCEQAReduceList(0,"Reduce",rowid,mxrowid)) q:mxrowid=""  d
	...q:((vMXRowID'="")&&(mxrowid=vMXRowID)&&(vChangeType=0))
	...s DetailIDs=$g(^DHCEQAReduceList(mxrowid,"EX","RowIDs")) 
	...s TSerialFlag=$p($g(^DHCEQAReduceList(mxrowid)),"^",8) //// modify BY:GBX 2014-8-29 11:04:17增加序列号标志判断
	...i TSerialFlag="Y" d
	....i DetailIDs'=""  d  //不为空时存的为库存详细表ID,取ID的数量
	.....s DetailLen=$L(DetailIDs,",")
	.....s idx=1
	.....f  s DetailDR=$p(DetailIDs,",",idx) q:idx>DetailLen  d
	......s idx=idx+1
	......q:(DetailDR'="")&&(RowID'=DetailDR)
	......s reducenum=reducenum+1
	....e  d
	.....s DetailDR=$p($g(^DHCEQAReduceList(mxrowid)),"^",5)
	.....q:(DetailDR'="")&&(RowID'=DetailDR)
	.....s reducenum=reducenum+$p($g(^DHCEQAReduceList(mxrowid)),"^",10)
	...e  d  //为空时直接取业务详细表的数量
	....s DetailDR=$p($g(^DHCEQAReduceList(mxrowid)),"^",5)
	....q:(DetailDR'="")&&(RowID'=DetailDR)
	....s reducenum=reducenum+$p($g(^DHCEQAReduceList(mxrowid)),"^",10)
	
	//被转移单占据的数量
	s rowid=0 
	f  s rowid=$o(^DHCEQAMoveStock(0,"FromLoc",LocDR,rowid))  q:(rowid="")  d
	.s Status=$p($g(^DHCEQAMoveStock(rowid)),"^",28)
	.q:(Status>1)		//过滤掉非'新增','提交' 状态的单据.
	.s mrowid=0 
	.f  s mrowid=$o(^DHCEQAMoveStockList(0,"MoveStock",rowid,mrowid))  q:(mrowid="")  d
	..q:((vMXRowID'="")&&(mrowid=vMXRowID)&&(vChangeType=1))
	..;s mStockDetailDR=$p($g(^DHCEQAMoveStockList(mrowid)),"^",14)
	..
	..;维修配件	Mozy
	..s WXPartRowID=""	
	..i (vChangeType=2) s WXPartRowID=$o(^DHCEQMMaintPart(0,"AMoveStockList",mrowid,""))
	..q:(WXPartRowID'="")&&(WXPartRowID=vMXRowID)
	..
	..s DetailIDs=$g(^DHCEQAMoveStockList(mrowid,"EX","RowIDs"))
	..s TSerialFlag=$p($g(^DHCEQAMoveStockList(mrowid)),"^",9)
	..i TSerialFlag="Y" d
	...i DetailIDs'=""  d
	....s DetailLen=$L(DetailIDs,",")
	....s idx=1
	....f  s DetailDR=$p(DetailIDs,",",idx) q:idx>DetailLen  d
	.....s idx=idx+1
	.....q:(DetailDR'="")&&(RowID'=DetailDR)
	.....s movenum=movenum+1
	...e  d
	....s DetailDR=$p($g(^DHCEQAMoveStockList(mrowid)),"^",14)
	....q:(DetailDR'="")&&(RowID'=DetailDR)
	....s movenum=movenum+$p($g(^DHCEQAMoveStockList(mrowid)),"^",11)
	..e  d
	...s DetailDR=$p($g(^DHCEQAMoveStockList(mrowid)),"^",14)
	...q:(DetailDR'="")&&(RowID'=DetailDR)
	...s movenum=movenum+##Class(web.DHCEQAReduce).GetMaxQuantityNum(mrowid)	
	
	
	//被维修单占用的数量	
	s MRRowID=0
	f  s MRRowID=$o(^DHCEQMMaintPart(0,"MaintRequest",MRRowID)) q:MRRowID=""  d
	.s MTPRowID=0
	.f  s MTPRowID=$o(^DHCEQMMaintPart(0,"MaintRequest",MRRowID,MTPRowID)) q:MTPRowID=""  d
	..q:$p($g(^DHCEQMMaintPart(MTPRowID)),"^",12)="Y"				//待购标志
	..s DetailDR=$p($g(^DHCEQMMaintPart(MTPRowID)),"^",13)			//ASDRowID
	..q:(RowID'="")&&(DetailDR'=RowID)
	..q:((vMXRowID'="")&&(RowID'="")&&(MRRowID'=vMXRowID)&&(DetailDR'=RowID)&&(vChangeType=2))
	..q:((vMXRowID'="")&&(vMXRowID=MTPRowID)&&(vChangeType=2))		//选择记录过滤
	..;;;;;;;;;;;;;;;;;;;;;;;;无效转移要算占用
	..s mslrowid=+$p($g(^DHCEQMMaintPart(MTPRowID)),"^",11)
	..q:(mslrowid>0)&($d(^DHCEQAMoveStockList(mslrowid)))
	..s maintnum=maintnum+$p($g(^DHCEQMMaintPart(MTPRowID)),"^",3)
	
	
	s Num=movenum+reducenum+maintnum
	q Num
}

/// Mozy	20160621
/// 获取维修配件数量和其对应配件出库单数量最大值
/// w ##Class(web.DHCEQAReduce).GetMaxQuantityNum(315)
ClassMethod GetMaxQuantityNum(BussID As %String = "")
{
	i BussID="" q 0
	;作废的转移单不计算占用数
	i ##Class(web.DHCEQAReduce).IsMSInvalid(BussID)=1 q 0		
	n maxnum,mpdr
	s maxnum=$p($g(^DHCEQAMoveStockList(BussID)),"^",11)
	
	s mpdr=$o(^DHCEQMMaintPart(0,"AMoveStockList",BussID,""))
	i mpdr'="" d
	.i +$p($g(^DHCEQMMaintPart(mpdr)),"^",3)>maxnum s maxnum=+$p($g(^DHCEQMMaintPart(mpdr)),"^",3)
	
	q maxnum
}

/// Mozy	20160621
/// 判断转移单是否有效(未作废)
/// 返回值:	1-作废	其它-有效
/// w ##Class(web.DHCEQAReduce).IsMSInvalid()
ClassMethod IsMSInvalid(msldr As %String = "")
{
	i msldr="" q 1
	n msdr
	s msdr=$p($g(^DHCEQAMoveStockList(msldr)),"^",1)
	i ($p($g(^DHCEQAMoveStock(msdr)),"^",28)=3) q 1
	q 0
}

/// 反提交
ClassMethod CancelSubmitData(val, CurRole)
{
	new (val,CurRole,%session)  //ZX0035 清空session值后,影响消息生成
	Set $ZT="ERRORCancel"
	s RowID=$P(val,"^",1)
	i RowID="" q ""
	s User=$P(val,"^",8)
	s CancelToFlowDR=$P(val,"^",10)
	s Date=+$H
	//获取取消到上一步的信息,没有设置取消到第几步,就取消到更新状态
	s Status="0"
	s ApproveRoleDR=""
	s Step=""
	if (CancelToFlowDR'="")
	{
		s ApproveRoleDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",2)
		s Step=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",3)
		s Status="1"
	}
	s AppInfo(5)=ApproveRoleDR
	s AppInfo(6)=Step
	s AppInfo(7)=""		;ApproveStatus
	s AppInfo(8)=""		;ApproveRoleDR
	s AppInfo(9)=Status	;Status	
	
	s PLIST(20) = User //$p(val,"^",5)	;MakerDR	//Modify DJ 2014-09-10 begin
 	s PLIST(28) = $p(Date,",",1)
 	s PLIST(29) = $p(Date,",",2)		//Modify DJ 2014-09-10 end
 	s PLIST(24) = Status	//需求: 283238	Mozy	20161111
	TSTART
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("21")
	Set ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("21", RowID)
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,ApproveRoleDR,Step,"","",Status,"Y")
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	&SQL(update sqluser.DHC_EQAReduce values :PLIST() where AR_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	else
	{
		;Modified by jdl 2011-3-9  jdl0073
	    s ApproveFlow=""
	    i CancelToFlowDR'=""
	    {
		    s ApproveFlow="N^"_Step_"^"_ApproveRoleDR_"^"_$p(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR),"^",7,11)_"^"_ApproveSet
	    }
	    //add by zx 2016-03-03 消息处理 ZX0035
	    s BussType="A04"
	    s ReduceType=$p($g(^DHCEQAReduce(RowID)),"^",3)
	    i ReduceType=1 s BussType="A03"
	    s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo(BussType, RowID, User, ApproveFlow, "Y",CurRole)
	    i SQLCODE
	    {
		    TROLLBACK
		    q SQLCODE
	    }
	}
 	TCOMMIT
 	q RowID
ERRORCancel 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORCancel"_ErrorMsg     //返回错误消息 ;
}

ClassMethod GetID(rowid)
{
	new (rowid)
	s result=$g(^DHCEQAReduce(rowid))
	s resultmx=""
	i $p(result,"^",1)'=""  d       //退货单号
	.s resultmx=$p(result,"^",1)
	i $p(result,"^",2)'=""  d       //配件类组
	.s resultmx=resultmx_"^"_$p(^DHCEQCCode("DHCEQCAccessoryType",$p(result,"^",2)),"^",2)
	i $p(result,"^",4)'=""  d      //退货科室
	.s resultmx=resultmx_"^"_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",4))
	i $p(result,"^",6)'=""  d       //供应商 
	.s resultmx=resultmx_"^"_##class(web.DHCEQCommon).GetTrakNameByID("prov",$p(result,"^",6))
	e  d
	.s resultmx=resultmx_"^"_""  //modify BY:GBX 2014-9-13 18:16:46
	i $p(result,"^",7)'=""  d       //制单人
	.s resultmx=resultmx_"^"_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",7))
	i $p(result,"^",8)'=""  d       //制单时间
	.s resultmx=resultmx_"^"_##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",8),"date")
	i $p(result,"^",3)'=""  d  //减少类型   //modify BY:GBX 2014-9-13 18:19:28
	.s resultmx=resultmx_"^"_..GetReduceType($p(result,"^",3))
	q resultmx
}

ClassMethod GetList(ReduceID)
{
	new RLID,RLIDs
	s RLIDs=""
	s RLID=0
	f  s RLID=$o(^DHCEQAReduceList(0,"Reduce",ReduceID,RLID)) q:RLID=""  d
	.i RLIDs="" d
	..s RLIDs=RLID
	.e  d
	..s RLIDs=RLIDs_"^"_RLID
	q RLIDs
}

/// Modify BY:GBX 2014-4-21  GBX0006
/// 将减少和退货分开	2014-8-12 10:30:41
ClassMethod ReduceTypeList(name, width, Type) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	//w "<option value=></option>"
	if (Type="1")  //Modify DJ 2014-09-11
	{
		w "<option value=1>"_..GetReduceType(1)_"</option>"
	}
	else
	{
		w "<option value=2>"_..GetReduceType(2)_"</option>"
		w "<option value=3>"_..GetReduceType(3)_"</option>"
		w "<option value=4>"_..GetReduceType(4)_"</option>"
		w "<option value=9>"_..GetReduceType(9)_"</option>"
	}
	w "</select>",!
}

ClassMethod GetReduceType(Status)
{
	q $CASE(Status,"1":"退货","2":"报损","3":"消耗","4":"盘亏","9":"其他")
}

/// 库房配件查询放大镜
/// Flag :批量管理
/// qw0005-2014-06-05 :增加单台批量显示，增加一个标志位
/// modify by:GBX 2014-8-31 15:13:18 GBX0029 增加一个changetype区分退货减少和转移
/// ChangeType:0: 退货和减少
/// 		   1：转移
/// vMXRowID  转移明细或退货明细RowID
/// d ##class(%ResultSet).RunQuery("web.DHCEQAReduce","GetAStockDetail","","410","1","","true")
Query GetAStockDetail(ASDRowID, LocDR, AccessoryTypeDR, Desc, Flag, ChangeType, vMXRowID As %String = "", ProviderDR As %String = "") As %Query(ROWSPEC = "HIDDEN:%String,TDesc:%String:名称,TCode:%String:编码,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,TBatchNo:%String:批号,HIDDEN:%String,TBprice:%String:进价,TSerialNo:%String:序列号,TNo:%String:编号,HIDDEN:%String,TBaseUOM:%String:基本单位,HIDDEN:%String,HIDDEN:%String,TModel:%String:型号,HIDDEN:%String,TProvider:%String:供应商,TStock:%String:库存,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,CanUseNum:%String:可用数量,FreezeNum:%String:冻结数量,HIDDEN:%String,HIDDEN:%String,TInStockNo:%String:入库单号,TInDate:%String:入库日期,HIDDEN:%String")
{
}

ClassMethod GetAStockDetailExecute(ByRef qHandle As %Binary, ASDRowID, LocDR, AccessoryTypeDR, Desc, Flag, ChangeType, vMXRowID As %String = "", ProviderDR As %String = "") As %Status
{
	new repid, index,rowid,TAStockListDR,TStockSum
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	s TAStockListDR=0
	s TStockSum=0
	S Desc=$ZCONVERT(Desc,"U")
	i LocDR="" Set LocDR=##Class(web.DHCEQCommon).GetFirstIDByLocType("0302")			;Mozy	默认取 SBLJCK-设备零件仓库的配件
	;i LocDR="" q $$$OK
	i AccessoryTypeDR="" q $$$OK
	i Flag="true" s ASDRowID=""
	s TSerialFlag=""
	s TAInStockListDR=""
	;s ^DHCEQMozy("GetAStockDetail")=ASDRowID_","_LocDR_","_AccessoryTypeDR_","_Desc_","_Flag_","_ChangeType_","_vMXRowID_","_ProviderDR
	if ASDRowID'=""
	{
		d ResetVariablesGetAStockDetail
		s rowid=ASDRowID
		d BuildDataGetAStockDetail
	}
	else
	{		
		if Flag="true"
		{
            s TAInStockListDR=""	;;;需求序号:	567450		Mozy	2018-3-23
			f  s TAInStockListDR=$o(^DHCEQAStockDetail(0,"AInStockList",TAInStockListDR),-1) q:TAInStockListDR=""  d
			.d ResetVariablesGetAStockDetail
			.s (TStock,rowid,TID)=0
			.s FreezeNumSum=0  //GBX 2014-8-28 16:16:56
			.s FirstID=0	//Modify DJ 2014-09-10
			.f  s rowid=$o(^DHCEQAStockDetail(0,"AInStockList",TAInStockListDR,rowid)) q:rowid=""  d
			..;s TBatchNo=$p($g(^DHCEQAStockDetail(rowid)),"^",6)
			..;i TBatchNo'=""  d
			..s TAInStockListDR=$p($g(^DHCEQAStockDetail(rowid)),"^",3) //modify BY GBX 用批号标志做判断
			..s TSerialFlag=$p($g(^DHCEQAInStockList(TAInStockListDR)),"^",15)
			..i TSerialFlag'="Y" d		//Modify DJ 2014-09-10
			...d BuildDataGetAStockDetail	//Modify DJ 2014-09-10
			..e  d
			...s TLocDR=$p($g(^DHCEQAStockDetail(rowid)),"^",1)
		    ...q:(LocDR'=TLocDR) 
			...s TStatus=$p($g(^DHCEQAStockDetail(rowid)),"^",12)
		    ...q:(ChangeType=0)&&(TStatus'=0)
		    ...q:(ChangeType=1)&&(TStatus'=0)&&(TStatus'=1)
		    ...s TStockSum=$p($g(^DHCEQAStockDetail(rowid)),"^",17)
		    ...q:(TStockSum=0)
		    ...s TStock=TStock+TStockSum
		    ...s FreezeNum=##class(web.DHCEQAReduce).CheckAccessoryDR(rowid,LocDR,vMXRowID,ChangeType)      ///被占用的数量  //Modify DJ 2014-09-10
		    ...s FreezeNumSum=FreezeNumSum+FreezeNum
			...i ((FirstID=0)&&(FreezeNum=0))  d	//Modify DJ 2014-09-10
			....s TID=rowid
			....s FirstID=1
			.s TNo=""
			.s TSerialNo=""
			.s rowid=TID
			.q:($p($g(^DHCEQAStockDetail(rowid)),"^",10)="")		//Modify DJ 2014-09-10
			.;s TSerialNo=$e($p($g(^DHCEQAStockDetail(rowid)),"^",9),0,1) //qw0006-2014-08-21
			.d BuildDataGetAStockDetail
		}
		else
		{	
			s rowid=""
			f  s rowid=$o(^DHCEQAStockDetail(rowid),-1) q:rowid=""  d
			.d ResetVariablesGetAStockDetail
			.d BuildDataGetAStockDetail
		}
	}
	
	Quit $$$OK
	
BuildDataGetAStockDetail
		s TRowID=rowid
		s TLocDR=$p($g(^DHCEQAStockDetail(TRowID)),"^",1)
		q:((LocDR'="")&&(LocDR'=TLocDR))
		s TAccessoryTypeDR=$p($g(^DHCEQAStockDetail(TRowID)),"^",11)
		q:##class(web.DHCEQACommon).AccessoryTypeIsIn(TAccessoryTypeDR)
		q:(AccessoryTypeDR'="")&&(AccessoryTypeDR'=TAccessoryTypeDR)
		s TCode=$p($g(^DHCEQAStockDetail(TRowID)),"^",4)
		s TDesc=$p($g(^DHCEQAStockDetail(TRowID)),"^",5)
		s TAccessoryType=$p($g(^DHCEQCCode("DHCEQCAccessoryType",TAccessoryTypeDR)),"^",2)
		s TItemDR=$p($g(^DHCEQAStockDetail(TRowID)),"^",2)
		s TItem=$p($g(^DHCEQCCode("DHCEQCAccessory",TItemDR)),"^",2)
		s TAInStockListDR=$p($g(^DHCEQAStockDetail(TRowID)),"^",3)
		s TShortDesc=$p($g(^DHCEQCCode("DHCEQCAccessory",TItemDR)),"^",3)
		q:(Desc'="")&&(($ZCONVERT(TCode,"U")'[Desc)&&($ZCONVERT(TDesc,"U")'[Desc)&&($ZCONVERT(TShortDesc,"U")'[Desc))
		s TStatus=$p($g(^DHCEQAStockDetail(TRowID)),"^",12)
		q:(ChangeType=0)&&(TStatus'=0)
		q:(ChangeType=1)&&(TStatus'=0)&&(TStatus'=1)
		s THasStockFlag=$p($g(^DHCEQAStockDetail(TRowID)),"^",26)
		q:(THasStockFlag="N")
		s TLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
		//add By GBX 2014-8-27 15:42:08
		i TAInStockListDR'="" d
		.s TAInStockDR=$p($g(^DHCEQAInStockList(TAInStockListDR)),"^",1)
		.s TBatchFlag=$p($g(^DHCEQAInStockList(TAInStockListDR)),"^",16)	//Modify DJ 2014-09-10
		.i (Flag'="true")&($p($g(^DHCEQAInStockList(TAInStockListDR)),"^",15)="Y")  d  //modify BY：Mozy0230	2019-11-11	1085274	批量标志
		..s TSerialNo=$p($g(^DHCEQAStockDetail(TRowID)),"^",9)
		..s TNo=$p($g(^DHCEQAStockDetail(TRowID)),"^",10)
		.i TAInStockDR'="" d
		..s TInStockNo=$p($g(^DHCEQAInStock(TAInStockDR)),"^",6)  //入库单号
		..s TInDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAInStock(TAInStockDR)),"^",1),"date") //入库日期
		e  d
		.s TBatchFlag="Y"	;导入配件批量处理
		s TBatchNo=$p($g(^DHCEQAStockDetail(TRowID)),"^",6)
		s TExpiryDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAStockDetail(TRowID)),"^",7),"date")
		s TBprice=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQAStockDetail(TRowID)),"^",8),"",2)  //add by wy 2017-12-22
		s TBaseUOMDR=$p($g(^DHCEQAStockDetail(TRowID)),"^",13)
		i TBaseUOMDR'="" s TBaseUOM=##class(web.DHCEQCommon).GetTrakNameByID("uom",TBaseUOMDR)
		s TManuFactoryDR=$p($g(^DHCEQAStockDetail(TRowID)),"^",14)
		s TManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)	// MZY0061	1580585		2020-12-2
		s TModel=$p($g(^DHCEQAStockDetail(TRowID)),"^",15)
		s TProviderDR=$p($g(^DHCEQAStockDetail(TRowID)),"^",16)
		q:((ProviderDR'="")&&(TProviderDR'=ProviderDR))		//Add By DJ 2014-09-11
		i TProviderDR'="" s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
		
		i TSerialFlag="Y"  d
		.s FreezeNum=FreezeNumSum
		e  d
		.s TStock=$p($g(^DHCEQAStockDetail(TRowID)),"^",17) //modify by GBX:2014-8-27 16:45:15
		.s FreezeNum=##class(web.DHCEQAReduce).CheckAccessoryDR(TRowID,LocDR,vMXRowID,ChangeType)      ///被占用的数量	//Modify DJ 2014-09-10
		/*
		i ((Flag="false")||(TBatchNo'="")) d
		.s TSerialNo=$p($g(^DHCEQAStockDetail(TRowID)),"^",9)
		.s TNo=$p($g(^DHCEQAStockDetail(TRowID)),"^",10)
		.s TStock=$p($g(^DHCEQAStockDetail(TRowID)),"^",17)
		else  d
		.i TStock=""  d
		..s TStock=$p($g(^DHCEQAStockDetail(TRowID)),"^",17) //modify by GBX:2014-8-27 16:45:15
		*/
		q:(TStock=0)           //Modify GBX 2014-4-10 11:50:22
		
		;s FreezeNum=##class(web.DHCEQAReduce).CheckAccessoryDR(TRowID,LocDR)      ///被占用的数量
		s CanUseNum=TStock-FreezeNum                 ///可退数量 
		q:CanUseNum<1 
		
		s TFreezeStock=$p($g(^DHCEQAStockDetail(TRowID)),"^",18)
		s TStartDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAStockDetail(TRowID)),"^",19),"date")
		s TDisuseDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAStockDetail(TRowID)),"^",20),"date")
		s TStockDR=$p($g(^DHCEQAStockDetail(TRowID)),"^",21)
		s TInType=$p($g(^DHCEQAStockDetail(TRowID)),"^",22)
		s TInSourceID=$p($g(^DHCEQAStockDetail(TRowID)),"^",23)
		s TToType=$p($g(^DHCEQAStockDetail(TRowID)),"^",24)
		s TToSourceID=$p($g(^DHCEQAStockDetail(TRowID)),"^",25)
		s THasStockFlag=$p($g(^DHCEQAStockDetail(TRowID)),"^",26)
		s TOriginDR=$p($g(^DHCEQAStockDetail(TRowID)),"^",27)
		i TOriginDR'="" s TOrigin=$p($g(^DHCEQCCode("DHCEQCOrigin",TOriginDR)),"^",2)
		;s StockQtyNum=$p($g(^DHCEQAStockDetail(TRowID)),"^",17)
		
		s TReturnFee=##class(web.DHCEQAReduce).GetAccessoryById("Fee",TRowID)
		s TReturnFee=##Class(web.DHCEQCommon).FormatNumber(TReturnFee,"",2)     //add by wy 2017-12-22
		s TTotalFee=CanUseNum*TReturnFee
		d OutputRowGetAStockDetail

	quit
OutputRowGetAStockDetail
	s Data=$lb(TRowID,TDesc,TCode,TLocDR,TLoc,TAccessoryTypeDR,TAccessoryType,TStatus,THasStockFlag,TItemDR,TItem,TAInStockListDR,TBatchNo,TExpiryDate,TBprice,TSerialNo,TNo,TBaseUOMDR,TBaseUOM,TManuFactoryDR,TManuFactory,TModel,TProviderDR,TProvider,TStock,TFreezeStock,TStartDate,TDisuseDate,TStockDR,TInType,TInSourceID,TToType,TToSourceID,TOriginDR,TOrigin,CanUseNum,FreezeNum,TReturnFee,TTotalFee,TInStockNo,TInDate,TBatchFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetAStockDetail
	s (TRowID,TDesc,TCode,TLocDR,TLoc,TAccessoryTypeDR,TAccessoryType,TStatus,THasStockFlag,TItemDR,TItem,TBatchNo,TExpiryDate,TBprice,TSerialNo,TNo,TBaseUOMDR,TBaseUOM,TManuFactoryDR,TManuFactory,TModel,TProviderDR,TProvider,TStock,TFreezeStock,TStartDate,TDisuseDate,TStockDR,TInType,TInSourceID,TToType,TToSourceID,TOriginDR,TOrigin,FreezeNum,CanUseNum,TReturnFee,TTotalFee,TAInStockDR,TInStockNo,TInDate,TBatchFlag)=""
	quit
}

ClassMethod GetAStockDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAStockDetailExecute ]
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

ClassMethod GetAStockDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAStockDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 只能用于放大镜不能用于Table
/// 重写库存配件查询简略输出列信息(把ID值移动靠前)
/// Flag :批量管理
/// 增加单台批量显示，增加一个标志位
/// 增加一个changetype区分退货减少和转移
/// ChangeType:0: 退货和减少
/// 		   1：转移
/// 		   2：维修
/// vMXRowID  转移明细或退货明细RowID
/// d ##class(%ResultSet).RunQuery("web.DHCEQAReduce","GetAStockDetailNew","",327,44,"","false",2,"","")
/// modified by kdf 2018-01-31 增加TProvider 输出列; 需求号：542709
/// modified by sjh SJH0036 2020-20-13 输出列标题修改
Query GetAStockDetailNew(ASDRowID, LocDR, AccessoryTypeDR, Desc, Flag, ChangeType, vMXRowID As %String = "", ProviderDR As %String = "", ChkFlag As %String = "") As %Query(ROWSPEC = "HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,TDesc:%String:名称,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,TModel:%String:型号,TBprice:%String:进价,TManuFactory:%String:生产厂商,HIDDEN:%String,TStock:%String:库存,CanUseNum:%String:可用数量,FreezeNum:%String:冻结数量,TInStockNo:%String:在库数量,TInDate:%String:入库日期,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,TBatchNo:%String:批号,HIDDEN:%String,TSerialNo:%String:序列号,HIDDEN:%String,TBaseUOM:%String:配件单位,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,TBillPage:%String:账页,TProvider:%String:供应商,TInvoiceNos:%String:发票号串")
{
}

ClassMethod GetAStockDetailNewExecute(ByRef qHandle As %Binary, ASDRowID, LocDR, AccessoryTypeDR, Desc, Flag, ChangeType, vMXRowID As %String = "", ProviderDR As %String = "", ChkFlag As %String = "") As %Status
{
	new repid, index,rowid,TAStockListDR,TStockSum
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	i ChkFlag="Y" Quit $$$OK
	s index=1
	s rowid=0
	s TAStockListDR=0
	s TStockSum=0
	S Desc=$ZCONVERT(Desc,"U")
	i LocDR="" Set LocDR=##Class(web.DHCEQCommon).GetFirstIDByLocType("0302")			;Mozy	默认取 SBLJCK-设备零件仓库的配件
	;i LocDR="" q $$$OK
	i AccessoryTypeDR="" q $$$OK
	i Flag="true" s ASDRowID=""
	s TSerialFlag=""
	s TAInStockListDR=""
	;s ^DHCEQMozy("GetAStockDetailNew")=ASDRowID_","_LocDR_","_AccessoryTypeDR_","_Desc_","_Flag_","_ChangeType_","_vMXRowID_","_ProviderDR
	if ASDRowID'=""
	{
		d ResetVariablesGetAStockDetailNew
		s rowid=ASDRowID
		d BuildDataGetAStockDetailNew
	}
	else
	{
		if Flag="true"
		{
            s TAInStockListDR=""	;;Mozy	2018-3-22	567450
			f  s TAInStockListDR=$o(^DHCEQAStockDetail(0,"AInStockList",TAInStockListDR),-1) q:TAInStockListDR=""  d
			.d ResetVariablesGetAStockDetailNew
			.s (TStock,rowid,TID)=0
			.s FreezeNumSum=0
			.s FirstID=0
			.f  s rowid=$o(^DHCEQAStockDetail(0,"AInStockList",TAInStockListDR,rowid)) q:rowid=""  d
			..;s TBatchNo=$p($g(^DHCEQAStockDetail(rowid)),"^",6)
			..;i TBatchNo'=""  d
			..s TAInStockListDR=$p($g(^DHCEQAStockDetail(rowid)),"^",3) //用批号标志做判断
			..s TSerialFlag=$p($g(^DHCEQAInStockList(TAInStockListDR)),"^",15)
			..i TSerialFlag'="Y" d
			...d BuildDataGetAStockDetailNew
			..e  d
			...s TLocDR=$p($g(^DHCEQAStockDetail(rowid)),"^",1)
		    ...q:(LocDR'=TLocDR) 
			...s TStatus=$p($g(^DHCEQAStockDetail(rowid)),"^",12)
		    ...q:(ChangeType=0)&&(TStatus'=0)
		    ...q:(ChangeType=1)&&(TStatus'=0)&&(TStatus'=1)
		    ...q:(ChangeType=2)&&(TStatus'=0)	// Mozy003008	1268242		2020-04-09
		    ...s TStockSum=$p($g(^DHCEQAStockDetail(rowid)),"^",17)
		    ...q:(TStockSum=0)
		    ...s TStock=TStock+TStockSum
		    ...s FreezeNum=##class(web.DHCEQAReduce).CheckAccessoryDR(rowid,LocDR,vMXRowID,ChangeType)      ///被占用的数量
		    ...s FreezeNumSum=FreezeNumSum+FreezeNum
			...i ((FirstID=0)&&(FreezeNum=0))  d
			....s TID=rowid
			....s FirstID=1
			.s TNo=""
			.s TSerialNo=""
			.s rowid=TID
			.q:($p($g(^DHCEQAStockDetail(rowid)),"^",10)="")
			.;s TSerialNo=$e($p($g(^DHCEQAStockDetail(rowid)),"^",9),0,1)
			.d BuildDataGetAStockDetailNew
		}
		else
		{	
			s rowid=""
			f  s rowid=$o(^DHCEQAStockDetail(rowid),-1) q:rowid=""  d
			.d ResetVariablesGetAStockDetailNew
			.d BuildDataGetAStockDetailNew
		}
	}
	
	Quit $$$OK
	
BuildDataGetAStockDetailNew
		s TRowID=rowid
		s TLocDR=$p($g(^DHCEQAStockDetail(TRowID)),"^",1)
		q:((LocDR'="")&&(LocDR'=TLocDR))
		s TAccessoryTypeDR=$p($g(^DHCEQAStockDetail(TRowID)),"^",11)
		q:##class(web.DHCEQACommon).AccessoryTypeIsIn(TAccessoryTypeDR)
		q:(AccessoryTypeDR'="")&&(AccessoryTypeDR'=TAccessoryTypeDR)
		s TCode=$p($g(^DHCEQAStockDetail(TRowID)),"^",4)
		s TDesc=$p($g(^DHCEQAStockDetail(TRowID)),"^",5)
		s TAccessoryType=$p($g(^DHCEQCCode("DHCEQCAccessoryType",TAccessoryTypeDR)),"^",2)
		s TItemDR=$p($g(^DHCEQAStockDetail(TRowID)),"^",2)
		s TItem=$p($g(^DHCEQCCode("DHCEQCAccessory",TItemDR)),"^",2)
		s TAInStockListDR=$p($g(^DHCEQAStockDetail(TRowID)),"^",3)
		s TShortDesc=$p($g(^DHCEQCCode("DHCEQCAccessory",TItemDR)),"^",3)
		s TBillPage= $p($g(^DHCEQAStockDetail(TRowID)),"^",29)
		q:(Desc'="")&&(($ZCONVERT(TCode,"U")'[Desc)&&($ZCONVERT(TDesc,"U")'[Desc)&&($ZCONVERT(TShortDesc,"U")'[Desc)&&(TBillPage'=Desc))
		s TStatus=$p($g(^DHCEQAStockDetail(TRowID)),"^",12)
		q:(ChangeType=0)&&(TStatus'=0)
		q:(ChangeType=1)&&(TStatus'=0)&&(TStatus'=1)
		q:(ChangeType=2)&&(TStatus'=0)		// Mozy003008	1268242		2020-04-09
		s THasStockFlag=$p($g(^DHCEQAStockDetail(TRowID)),"^",26)
		q:(THasStockFlag="N")
		s TLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
		i TAInStockListDR'="" d
		.s TAInStockDR=$p($g(^DHCEQAInStockList(TAInStockListDR)),"^",1)
		.s TBatchFlag=$p($g(^DHCEQAInStockList(TAInStockListDR)),"^",16)
		.s TInvoiceNos=$p($g(^DHCEQAInStockList(TAInStockListDR)),"^",19)  //add by jyp 2018-02-26 546653
		.i (Flag="false")&($p($g(^DHCEQAInStockList(TAInStockListDR)),"^",15)="Y")  d  //批量标志
		..s TSerialNo=$p($g(^DHCEQAStockDetail(TRowID)),"^",9)
		..s TNo=$p($g(^DHCEQAStockDetail(TRowID)),"^",10)
		.i TAInStockDR'="" d
		..s TInStockNo=$p($g(^DHCEQAInStock(TAInStockDR)),"^",6)  //入库单号
		..s TInDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAInStock(TAInStockDR)),"^",1),"date") //入库日期
		e  d
		.s TBatchFlag="Y"	;导入配件批量处理
		s TBatchNo=$p($g(^DHCEQAStockDetail(TRowID)),"^",6)
		s TExpiryDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAStockDetail(TRowID)),"^",7),"date")
		s TBprice=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQAStockDetail(TRowID)),"^",8),"",2)   //add by mwz 20180222 需求号:542809
		s TBaseUOMDR=$p($g(^DHCEQAStockDetail(TRowID)),"^",13)
		i TBaseUOMDR'="" s TBaseUOM=##class(web.DHCEQCommon).GetTrakNameByID("uom",TBaseUOMDR)
		s TManuFactoryDR=$p($g(^DHCEQAStockDetail(TRowID)),"^",14)
		s TManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)	// MZY0061	1580585		2020-12-2
		s TModel=$p($g(^DHCEQAStockDetail(TRowID)),"^",15)
		s TProviderDR=$p($g(^DHCEQAStockDetail(TRowID)),"^",16)
		q:((ProviderDR'="")&&(TProviderDR'=ProviderDR))
		i TProviderDR'="" s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
		
		i TSerialFlag="Y"  d
		.s FreezeNum=FreezeNumSum
		e  d
		.s TStock=$p($g(^DHCEQAStockDetail(TRowID)),"^",17)
		.s FreezeNum=##class(web.DHCEQAReduce).CheckAccessoryDR(TRowID,LocDR,vMXRowID,ChangeType)      ///被占用的数量
		
		/*
		i ((Flag="false")||(TBatchNo'="")) d
		.s TSerialNo=$p($g(^DHCEQAStockDetail(TRowID)),"^",9)
		.s TNo=$p($g(^DHCEQAStockDetail(TRowID)),"^",10)
		.s TStock=$p($g(^DHCEQAStockDetail(TRowID)),"^",17)
		else  d
		.i TStock=""  d
		..s TStock=$p($g(^DHCEQAStockDetail(TRowID)),"^",17)
		*/
		q:(TStock=0)
		
		;s FreezeNum=##class(web.DHCEQAReduce).CheckAccessoryDR(TRowID,LocDR)      ///被占用的数量
		s CanUseNum=TStock-FreezeNum                 ///可退数量 
		q:CanUseNum<1 
		
		s TFreezeStock=$p($g(^DHCEQAStockDetail(TRowID)),"^",18)
		s TStartDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAStockDetail(TRowID)),"^",19),"date")
		s TDisuseDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAStockDetail(TRowID)),"^",20),"date")
		s TStockDR=$p($g(^DHCEQAStockDetail(TRowID)),"^",21)
		s TInType=$p($g(^DHCEQAStockDetail(TRowID)),"^",22)
		s TInSourceID=$p($g(^DHCEQAStockDetail(TRowID)),"^",23)
		s TToType=$p($g(^DHCEQAStockDetail(TRowID)),"^",24)
		s TToSourceID=$p($g(^DHCEQAStockDetail(TRowID)),"^",25)
		s THasStockFlag=$p($g(^DHCEQAStockDetail(TRowID)),"^",26)
		s TOriginDR=$p($g(^DHCEQAStockDetail(TRowID)),"^",27)
		i TOriginDR'="" s TOrigin=$p($g(^DHCEQCCode("DHCEQCOrigin",TOriginDR)),"^",2)
		;s StockQtyNum=$p($g(^DHCEQAStockDetail(TRowID)),"^",17)
		
		s TReturnFee=##class(web.DHCEQAReduce).GetAccessoryById("Fee",TRowID)
		s TTotalFee=CanUseNum*TReturnFee
		d OutputRowGetAStockDetailNew

	quit
OutputRowGetAStockDetailNew
	s TStock=##Class(web.DHCEQCommon).FormatNumber(TStock,"",2)
	s CanUseNum=##Class(web.DHCEQCommon).FormatNumber(CanUseNum,"",2)
	s FreezeNum=##Class(web.DHCEQCommon).FormatNumber(FreezeNum,"",2)
	Set Data=$lb(TRowID,TLocDR,TAccessoryTypeDR,TItemDR,TAInStockListDR,TBaseUOMDR,TManuFactoryDR,TProviderDR,TStockDR,TInType,TInSourceID,TToType,TToSourceID,TOriginDR,TDesc,TCode,TLoc,TAccessoryType,TModel,TBprice,TManuFactory,TProvider,TStock,CanUseNum,FreezeNum,TInStockNo,TInDate,TStatus,THasStockFlag,TItem,TBatchNo,TExpiryDate,TSerialNo,TNo,TBaseUOM,TFreezeStock,TStartDate,TDisuseDate,TOrigin,TReturnFee,TTotalFee,TBatchFlag,TBillPage ,TProvider,TInvoiceNos)    ;modified by kdf 2018-01-31 需求号：542709
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetAStockDetailNew
	Set (TRowID,TDesc,TCode,TLocDR,TLoc,TAccessoryTypeDR,TAccessoryType,TStatus,THasStockFlag,TItemDR,TItem,TBatchNo,TExpiryDate,TBprice,TSerialNo,TNo,TBaseUOMDR,TBaseUOM,TManuFactoryDR,TManuFactory,TModel,TProviderDR,TProvider,TStock,TFreezeStock,TStartDate,TDisuseDate,TStockDR,TInType,TInSourceID,TToType,TToSourceID,TOriginDR,TOrigin,FreezeNum,CanUseNum,TReturnFee,TTotalFee,TAInStockDR,TInStockNo,TInDate,TBatchFlag,TBillPage ,TProvider,TInvoiceNos)=""      
	Quit
}

ClassMethod GetAStockDetailNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAStockDetailNewExecute ]
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

ClassMethod GetAStockDetailNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAStockDetailNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
