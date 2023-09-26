Class web.DHCEQ.Plat.BUSMergeOrder Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 创建:lmm 2017-08-21
/// 描述:新增、更新汇总单数据
/// ----------------------------------
/// w ##Class(web.DHCEQMergeOrder).SaveData("^2^1^1^1^1^1^1^1^1^^^^^^^^^^^","^2^3^3^^^^^^^&^1^3^^3^^^^^^^")
/// w ##Class(web.DHCEQMergeOrder).SaveData("^32^0^","^5&^7")
ClassMethod SaveData(val, valList)
{
	new (val, valList,%session)  //modify by lmm 2018-11-14 748968
	k PLIST,RowID
	Set $ZT="ERRORSave"
    s RowID=$p(val,"^",1)       ;RowID
	s User=##class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)

	s PLIST(3)=$p(val,"^",2)    ;M_SourceType
	s PLIST(4)=$p(val,"^",3)    ;M_SubType
	s PLIST(5)=$p(val,"^",4)    ;M_Remark
	//s PLIST(12)=$p(val,"^",12)	;M_AuditUser
	//s PLIST(13)=$p(val,"^",13)	;M_AuditDate
	//s PLIST(14)=$p(val,"^",14)	;M_AuditTime
	s PLIST(16)="N"				;M_InvalidFlag
		
	TSTART
	i (RowID="")  //新增按钮操作
	{
		s PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQMergeOrder",Date,"","")
		s PLIST(15)="0"				;M_Status
		s PLIST(6)=User    			;M_UpdateUser
		s PLIST(7)=Date				;M_UpdateDate
		s PLIST(8)=Time				;M_UpdateTime
		
		&SQL(Insert Into SQLUSER.DHC_EQMergeOrder Values :PLIST())
		s RowID=$G(%ROWID) 

		if SQLCODE
		{
			TROLLBACK
			q SQLCODE_"^"_RowID
		}

	 }
	 else
	 {
		 	
		&SQL(update sqluser.DHC_EQMergeOrder values :PLIST() where M_RowID=:RowID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE_"^"_RowID
		}
 	}
		
		
 	s SQLCODE=..SaveMergeOrderList(RowID,valList)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^"_RowID
	}
		
	
	
	TCOMMIT
 	q SQLCODE_"^"_RowID
ERRORSave 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "<ERRORSave>"_ErrorMsg     //返回错误消息 ;
}

/// ----------------------------------
/// 创建:lmm 2017-08-21  
/// 描述:提交汇总单
/// 入参： MRowID：汇总单单ID
/// ----------------------------------
/// w ##Class(web.DHCEQMergeOrder).SubmitData("1")
ClassMethod SubmitData(RowID)
{
	s User=##class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	s PLIST(15)="1"		;M_Status
	s PLIST(9)=User		;M_SubmitUser
	s PLIST(10)=Date	;M_SubmitDate
	s PLIST(11)=Time	;M_SubmitTime
	&SQL(update sqluser.DHC_EQMergeOrder values :PLIST() where M_RowID=:RowID)
	q SQLCODE_"^"_RowID
}

/// ----------------------------------
/// 创建:lmm 2017-08-21  
/// 描述:删除汇总单
/// 入参： MRowID：汇总单单ID
/// ----------------------------------
/// w ##Class(web.DHCEQMergeOrder).DeleteData("1^2^1^1^1^1^1^1^1^1^^^^^^^^^^^")
ClassMethod DeleteData(RowID)
{
	Set $ZT="ERRORDelete"
	TSTART
	i RowID="" q 0
		&SQL(update SQLUSER.DHC_EQMergeOrder set M_InvalidFlag='Y' where M_RowID=:RowID) 
		if SQLCODE
		{
			TROLLBACK
			q SQLCODE_"^"_RowID
		}
	
	s MLRowID=0
	for  s MLRowID=$o(^DHCEQMergeOrderList(0,"MergeOrderDR",RowID,MLRowID))  q:(MLRowID="")  d
	.s DRRowID=$p($g(^DHCEQMergeOrderList(MLRowID)),"^",2)
	.i DRRowID'=""  d
	..&SQL(Update SQLUSER.DHC_EQDisuseRequest Set DR_MergeOrderFlag='N' where DR_RowID=:DRRowID )	
	i SQLCODE  
	{
		TROLLBACK
		q SQLCODE_"^"_RowID
	}
	
	TCOMMIT
 	q SQLCODE_"^"_RowID
ERRORDelete 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "<ERRORDelete>"_ErrorMsg     //返回错误消息 ;
}

/// ----------------------------------
/// 创建:lmm 2017-08-21  
/// 描述:写入汇总单明细
/// 入参： MRowID：汇总单单ID
/// ----------------------------------
/// w ##Class(web.DHCEQMergeOrder).SaveMergeOrderList("8","1^2^3^3^^^^^^^&1^1^3^^3^^^^^^^")
/// w ##Class(web.DHCEQMergeOrder).SaveMergeOrderList("71","^193^2&^194^3&^195^5&^196^6")
ClassMethod SaveMergeOrderList(MRowID, val)
{
	new Length,MLRowID,i,DRRowID
	n valList
	k PLISTMX
	i val="" q 0
	i MRowID="" q -1
	
	s DRRowID=""
	s Length=$l(val,"&")
	s PLISTMX(2)=MRowID  				;MergeOrderDR
	
	s Flag=0
	for i=1:1:Length
	{
		
		q:Flag'=0
		s valList=	$p(val,"&",i)
		s MLRowID= $p(valList,"^",1)
		s PLISTMX(3)=$p(valList,"^",2)  	;ML_SourceID
		s DRRowID=$p(valList,"^",2)
		s PLISTMX(4)=$p(valList,"^",3) 		;ML_RequestNum
		s PLISTMX(5)=$p(valList,"^",4)		;ML_AduitNum
		s PLISTMX(7)=$p(valList,"^",5)  	;ML_Remark
		
		if (MLRowID="")
		{
			&SQL(Insert Into SQLUSER.DHC_EQMergeOrderList Values :PLISTMX())
			s MLRowID=$G(%ROWID)
			
		}
		else
		{
			&SQL(update SQLUSER.DHC_EQMergeOrderList values :PLISTMX() where ML_RowID=:MLRowID)
		}
		
		i DRRowID'=""  
		{
			&SQL(Update SQLUSER.DHC_EQDisuseRequest Set DR_MergeOrderFlag='Y' where DR_RowID=:DRRowID )	//无效掉入库明细对应的资金来源记录.2012-02-08 HZY0021

		}
	}
	Quit SQLCODE
}

/// ----------------------------------
/// 创建:lmm 2017-08-23  
/// 描述:根据汇总单显示汇总单明细
/// 入参： RowID：汇总单单ID
/// modify by lmm 2019-08-05 增加出参 TTotalFee 939131
/// ----------------------------------
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.BUSMergeOrder","GetMergeOrderList","3")
/// Add By QW20201207 BUG:QW0082 报废汇总打印无响应 增加SqlProc属性
Query GetMergeOrderList(RowID) As %Query(ROWSPEC = "TRowID:%String,TDRRowID:%String,TMergeOrderDR:%String,TSourceID:%String,TRequestNum:%String,TAduitNum:%String,TRemark:%String,TRequestNo:%String,TUserLoc:%String,TEquip:%String,TNo:%String,TOriginalFee:%String,TQuantityNum:%String,TRequestLocDR:%String,TRequestLoc:%String,TTotalFee:%String") [ SqlProc ]
{
}

ClassMethod GetMergeOrderListExecute(ByRef qHandle As %Binary, RowID) As %Status
{
 	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	new rowid,TRow,TotalFlag,TotalQty,Total,MergeOrderDR
	s (TotalQty,Total)=0
	
	s TRow=0
	s MergeOrderDR=RowID
	if MergeOrderDR'=""  d
	.s rowid=0 
	.f  s rowid=$o(^DHCEQMergeOrderList(0,"MergeOrderDR",MergeOrderDR,rowid))  quit:rowid=""  d
	..d ResetVariablesGetMergeOrderList
	..s TRowID = rowid
	..s TMergeOrderDR = $p($g(^DHCEQMergeOrderList(rowid)),"^",1)
	..q:$p($g(^DHCEQMergeOrderList(rowid)),"^",7)="Y"   //add by wy 2020-05-06 1288746系统参数控制是否删除汇总报废单中的对应明细记录
	..s TInvalidFlag = $p($g(^DHCEQMergeOrder(TMergeOrderDR)),"^",15)
	..q:TInvalidFlag="Y"
	..s TSourceID = $p($g(^DHCEQMergeOrderList(rowid)),"^",2)
	..s TRequestNum = $p($g(^DHCEQMergeOrderList(rowid)),"^",3)
	..s TAduitNum = $p($g(^DHCEQMergeOrderList(rowid)),"^",4)
	..s TAuditedFlag= $p($g(^DHCEQMergeOrderList(rowid)),"^",5)	
	..s TRemark = $p($g(^DHCEQMergeOrderList(rowid)),"^",6)
	..;s TOriginalFee = ##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQInStockList(rowid)),"^",7),"")
	..;s TQuantityNum = $p($g(^DHCEQInStockList(rowid)),"^",8)
	..;i TOriginalFee'="" s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee*TQuantityNum,"")
	..;s TotalQty=TotalQty+TQuantityNum
	..;s Total=Total+TTotalFee
	..;s TQuantityNum=TQuantityNum   //_" "_TUnit
	..s TRow=TRow+1
	..s TSourceType = $p($g(^DHCEQMergeOrder(TMergeOrderDR)),"^",2)
	..d GetSourceDataList
	;..d OutputRowGetMergeOrderList
	/*
	;没有数据时,也返回一个空行,用于编辑
	i TRow=0  d
	.d ResetVariablesGetMergeOrderList
	.s TRow=1
	.d OutputRowGetMergeOrderList
	
	;处理合计行
	i TotalFlag>0  d
	.d ResetVariablesGetMergeOrderList
	.s TRowID=-1
	.s TEquipName="合计:"
	.s TQuantityNum=TotalQty
	.s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(Total,"")
	.i TotalFlag="1"  d
	..s index=1
	.e  d
	..s index=index+1
	.d OutputRowGetMergeOrderList*/
	Quit $$$OK
	
GetSourceDataList
	//start by csj 2020-11-16 需求号：1590681
	i TSourceType ="34"  
	{
		s TRequestNo=$p($g(^DHCEQDisuseRequest(TSourceID)),"^",33)
		s TRequestLocDR = $p($g(^DHCEQDisuseRequest(TSourceID)),"^",3)
		.i TRequestLocDR'="" Set TRequestLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TRequestLocDR)
		s TUserLocDR=$Piece($Get(^DHCEQDisuseRequest(TSourceID)),"^",34)
		i TUserLocDR'="" Set TUserLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUserLocDR)
		i TUserLoc'="" Set TUserLoc=##class(web.DHCEQCommon).GetSplitDataByFlag(TUserLoc,"-")
		s TEquipDR = $p($g(^DHCEQDisuseRequest(TSourceID)),"^",1)
		s TKindFlag =$p($g(^DHCEQDisuseRequest(TSourceID)),"^",44)
		s AllNum=0
		s AllAmount=0
		i TKindFlag ="0"  d
		.s TEquip = $p($g(^DHCEQEquip(TEquipDR)),"^",1)
		.s TEquip=$ZCONVERT(TEquip,"U")
		.s TNo = $p($g(^DHCEQEquip(TEquipDR)),"^",71)
		.s TNo=$ZCONVERT(TNo,"U")
		.s TModelDR=$p($g(^DHCEQEquip(TEquipDR)),"^",3)
		.i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
		.s TManuFactoryDR=$p($g(^DHCEQEquip(TEquipDR)),"^",26)
		.i TManuFactoryDR'="" s TManuFactory=$p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1)
		.s TPurchaseTypeDR=$p($g(^DHCEQEquip(TEquipDR)),"^",64)
		.i TPurchaseTypeDR'="" s TPurchaseType=$p($g(^DHCEQCCode("DHCEQCPurchaseType",TPurchaseTypeDR)),"^",2)
		.s TOriginalFee=$p($g(^DHCEQEquip(TEquipDR)),"^",27)
		.s TUnit=$p($g(^DHCEQEquip(TEquipDR)),"^",5)            
		.s AllNum=AllNum+1
		.s AllAmount=AllAmount+$Piece($Get(^DHCEQEquip(TEquipDR)),"^",27)
		.s TInStockDate=$p($g(^DHCEQEquip(TEquipDR)),"^",45)	
		.s TQuantity=1 
		.s TTotalFee=TOriginalFee*TQuantity  
		
		if TKindFlag ="1"  d
		.s InStockListDR=$p($g(^DHCEQDisuseRequest(TSourceID)),"^",45) 
		.i InStockListDR'=""  d
		..s TEquip=$p($g(^DHCEQInStockList(InStockListDR)),"^",5) 
		..s TInStockDR=$p($g(^DHCEQInStockList(InStockListDR)),"^",1) 	
		..s TInStockDate=$p($g(^DHCEQInStock(TInStockDR)),"^",7)
		..s TOriginalFee=$p($g(^DHCEQInStockList(InStockListDR)),"^",7) 		
		..s TUnit=$p($g(^DHCEQInStockList(InStockListDR)),"^",10)       
		.Set equipRowIDs=$Get(^DHCEQDisuseRequest(TSourceID,"EX"))
		.Quit:equipRowIDs=""
		.Set count=$l(equipRowIDs,",")
		.For i=1:1:count Do
		..Set TEquipDR=$Piece(equipRowIDs,",",i)
		..If TNo '="" Set TNo = TNo_","
		..Set TNo = TNo_$Piece($Get(^DHCEQEquip(TEquipDR)),"^",71)
		..If (TEquip '="")&&((","_$Piece($Get(^DHCEQEquip(TEquipDR)),"^",1)_",")'[(","_TEquip_","))  d
		...Set TEquip = TEquip_","_$Piece($Get(^DHCEQEquip(TEquipDR)),"^",1)
		..If TEquip ="" Set TEquip = $Piece($Get(^DHCEQEquip(TEquipDR)),"^",1)
		..;i TOriginalFee'="" s TOriginalFee=TOriginalFee_","_$p($g(^DHCEQEquip(TEquipDR)),"^",27)
		..;e  s TOriginalFee=$p($g(^DHCEQEquip(TEquipDR)),"^",27)
		..s AllNum=AllNum+1
		..s AllAmount=AllAmount+$Piece($Get(^DHCEQEquip(TEquipDR)),"^",27)
		
		if TKindFlag ="2"  d
		.Set dlid=0
		.s TQuantity=0 
		.s TTotalFee=0
		.For  Set dlid=$Order(^DHCEQDisuseList(0,"Request",TSourceID,dlid)) Quit:dlid=""  Do
		..Set TQuantity=TQuantity+$Piece($Get(^DHCEQDisuseList(dlid)),"^",4)  
		..Set TTotalFee=($Piece($Get(^DHCEQDisuseList(dlid)),"^",4))*($Piece($Get(^DHCEQDisuseList(dlid)),"^",9))
		..If $Piece($Get(^DHCEQDisuseList(dlid)),"^",2)=0 Do
		...;单台
		...Set TEquipDR=$Piece($Get(^DHCEQDisuseList(dlid)),"^",3)
		...If TNo '="" Set TNo = TNo_","
		...Set TNo = TNo_$Piece($Get(^DHCEQEquip(TEquipDR)),"^",71)
		...If (TEquip '="")&&((","_$Piece($Get(^DHCEQEquip(TEquipDR)),"^",1)_",")'[(","_TEquip_","))  d
		....Set TEquip = TEquip_","_$Piece($Get(^DHCEQEquip(TEquipDR)),"^",1)
		...If TEquip ="" Set TEquip = $Piece($Get(^DHCEQEquip(TEquipDR)),"^",1)
		...;i TOriginalFee'="" s TOriginalFee=TOriginalFee_","_$p($g(^DHCEQEquip(TEquipDR)),"^",27)
		...;e  s TOriginalFee=$p($g(^DHCEQEquip(TEquipDR)),"^",27)
		...s AllNum=AllNum+1
		...s AllAmount=AllAmount+$Piece($Get(^DHCEQEquip(TEquipDR)),"^",27)
		..Else  Do
		...;批量
		...Set equipRowIDs=$Get(^DHCEQDisuseList(dlid,"EX"))
		...Quit:equipRowIDs=""
		...Set count=$l(equipRowIDs,",")
		...For i=1:1:count Do
		....Set TEquipDR=$Piece(equipRowIDs,",",i)
		....If TNo '="" Set TNo = TNo_","
		....Set TNo = TNo_$Piece($Get(^DHCEQEquip(TEquipDR)),"^",71)
		....If (TEquip '="")&&((","_$Piece($Get(^DHCEQEquip(TEquipDR)),"^",1)_",")'[(","_TEquip_","))  d
		.....Set TEquip = TEquip_","_$Piece($Get(^DHCEQEquip(TEquipDR)),"^",1)
		....If TEquip ="" Set TEquip = $Piece($Get(^DHCEQEquip(TEquipDR)),"^",1)
		....;i TOriginalFee'="" s TOriginalFee=TOriginalFee_","_$p($g(^DHCEQEquip(TEquipDR)),"^",27)
		....;e  s TOriginalFee=$p($g(^DHCEQEquip(TEquipDR)),"^",27)
		....s AllNum=AllNum+1
		....s AllAmount=AllAmount+$Piece($Get(^DHCEQEquip(TEquipDR)),"^",27)
		s TQuantityNum=AllNum
		s TTotalFee=AllAmount

	}
	//end by csj 2020-11-16
	d OutputRowGetMergeOrderList
	quit
	
OutputRowGetMergeOrderList
	s Data=$lb(TRowID,TDRRowID,TMergeOrderDR,TSourceID,TRequestNum,TAduitNum,TRemark,TRequestNo,TUserLoc,TEquip,TNo,TOriginalFee,TQuantityNum,TRequestLocDR,TRequestLoc,TTotalFee)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetMergeOrderList
	s (TRowID,TDRRowID,TMergeOrderDR,TSourceID,TRequestNum,TAduitNum,TAuditedFlag,TRemark,TRequestNo,TUserLoc,TEquip,TNo,TOriginalFee,TQuantityNum,TRequestLocDR,TRequestLoc,TTotalFee)=""
	quit
}

ClassMethod GetMergeOrderListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMergeOrderListExecute ]
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

ClassMethod GetMergeOrderListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMergeOrderListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod SplitData(rowids)
{
	s Length=0
	i rowids="" s rowids=0
	s Length=$l(rowids,",")

	for j=1:1:Length 
	{
		s rowid=0
		s rowid=$p(rowid,",",j)
		d ##class(%ResultSet).RunQuery("web.DHCEQBatchDisuseRequest","DisuseList",rowid)
	}
}

/// add by lmm 2017-08-28
/// 描述:根据汇总单rowid取汇总单信息
/// ----------------------------------
/// w ##Class(web.DHCEQMergeOrder).GetMergeOrderInfo(1)
ClassMethod GetMergeOrderInfo(rowid)
{
	if rowid="" q ""
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQMergeOrder(rowid)
	/*
	s resultex=resultex_"^"	;
	
	i $p(result,"^",1)'=""  d  
	.s resultex=resultex_$p($g(^DHCEQMergeOrder(rowid)),"^",1)	;MergeOrderNo	

	s resultex=resultex_"^"	;
	i $p(result,"^",3)'=""  d  
	.s resultex=resultex_$p($g(^DHCEQMergeOrder(rowid)),"^",3)  ;SubType
	s resultex=resultex_"^"	;
	i $p(result,"^",4)'=""  d  
	.s resultex=resultex_$p($g(^DHCEQMergeOrder(rowid)),"^",4)	;Remark
	
	s result=result_"^"_resultex*/
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

/// Desc:在删除汇总单明细的同时将明细对应的报废单无效恢复.
/// ----------------------------------
/// 创建:lmm 2017-08-29
/// 描述:删除汇总单明细
/// w ##Class(web.DHCEQMergeOrder).DeleteMergeOrderList(1)
ClassMethod DeleteMergeOrderList(DelRowID)
{
	new Length,MLRowID,Flag,i
	Set $ZT="ERRORDeleteList"
	s Flag=0
	i DelRowID="" q 0
	s MLRowID=DelRowID
	s DRRowID=$p($g(^DHCEQMergeOrderList(MLRowID)),"^",2)
	TSTART	
	if (DelRowID>0)
	{
		&SQL(delete from  sqluser.DHC_EQMergeOrderList where ML_RowID=:DelRowID)
		i SQLCODE 
		{
			TROLLBACK
			q SQLCODE_"^"_DelRowID
		}
			
	}
	if (DRRowID>0)
	{
		&SQL(Update SQLUSER.DHC_EQDisuseRequest Set DR_MergeOrderFlag='N' where DR_RowID=:DRRowID )	//无效掉入库明细对应的资金来源记录.2012-02-08 HZY0021
		i SQLCODE 
		{
			TROLLBACK
			q SQLCODE_"^"_DelRowID
		}
	}
		
	TCOMMIT
	q SQLCODE_"^"_DelRowID
	
ERRORDeleteList 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "<ERRORDeleteList>"_ErrorMsg     //返回错误消息 ;
}

/// Desc:在删除汇总单明细的同时将明细对应的报废单无效恢复.
/// ----------------------------------
/// 创建:lmm 2017-08-29
/// 描述:删除汇总单明细
/// w ##Class(web.DHCEQInStockNew).DeleteMergeOrderList(" ,0,0,0")
ClassMethod DeleteMergeOrderListold(DelRowIDs)
{
	new Length,MLRowID,Flag,i
	
	i DelRowIDs="" q 0
	
	s Flag=0
	s Length=$l(DelRowIDs,",")
	for i=1:1:Length
	{
		q:Flag'=0
		s MLRowID=$p(DelRowIDs,",",i)
		if (MLRowID>0)
		{
			&SQL(delete from  sqluser.DHC_EQMergeOrderList where ML_RowID=:MLRowID)
			i SQLCODE s Flag=SQLCODE
			q:Flag'=0
			s DRRowID=$p($g(^DHCEQMergeOrderList(MLRowID)),"^",2)
			i DRRowID'=""  d
			.&SQL(Update SQLUSER.DHC_EQDisuseRequest Set DR_MergeOrderFlag='N' where DR_RowID=:DRRowID )	//无效掉入库明细对应的资金来源记录.2012-02-08 HZY0021
			.s Flag=SQLCODE
			
		}
	}
	q Flag
}

/// 创建:lmm 2020-04-16 
/// 描述:显示汇总单明细
/// 入参： SourceType：业务类型 RequestNo：单据号 MergeOrderNo：汇总单号 Equip：设备名称 UseLoc：使用科室
/// ----------------------------------
/// Modified by QW20201223 BUG: QW0085 报废汇总批量审核 增加参数StatusDR QXType Type WaitAD
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.BUSMergeOrder","GetMergeOrder","34")
/// Modified By QW20210429 BUG:QW0102 增加参数Ejob
Query GetMergeOrder(SourceType, RequestNo As %String = "", MergeOrderNo As %String = "", Equip As %String = "", UseLoc As %String = "", StartDate As %String = "", EndDate As %String = "", QXType As %String = "", Type As %String = "", WaitAD As %String = "", StatusDR As %String = "", Ejob As %String = "") As %Query(ROWSPEC = "TRowID:%String,TMergeOrderNo:%String,TSourceType:%String,TSourceID:%String,TRequestNum:%String,TRequestNo:%String,TUserLoc:%String,TEquip:%String,TNo:%String,TOriginalFee:%String,TQuantityNum:%String,TRequestLocDR:%String,TRequestLoc:%String,TTotalFee:%String,TDisuseDate:%String,TStatus:%String")
{
}

ClassMethod GetMergeOrderExecute(ByRef qHandle As %Binary, SourceType, RequestNo As %String = "", MergeOrderNo As %String = "", Equip As %String = "", UseLoc As %String = "", StartDate As %String = "", EndDate As %String = "", QXType As %String = "", Type As %String = "", WaitAD As %String = "", StatusDR As %String = "", Ejob As %String = "") As %Status
{
 	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	if (SourceType="") Quit $$$OK
	///Add By QW20210429 BUG:QW0102 begin
	s gnum=1
	s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	d ##Class(web.DHCEQCommon).KillTempGlobal("MergeOrderList",Ejob) 
 	///Add By QW20210429 BUG:QW0102 end
	new rowid,TRow,TotalFlag,TotalQty,Total
	s (TotalQty,Total)=0
	s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
 	i StartDate="" s StartDate=0
 	i EndDate="" s EndDate=+$H
	
	s rowid=0 
	f  s rowid=$o(^DHCEQMergeOrder(0,"SourceType",SourceType,rowid))  quit:rowid=""  d
	.d ResetVariablesGetMergeOrder
	.s TRowID = rowid
	.s TInvalidFlag = $p($g(^DHCEQMergeOrder(TRowID)),"^",15)
	.q:TInvalidFlag="Y"
	.s TMergeOrderNo = $p($g(^DHCEQMergeOrder(TRowID)),"^",1)
	.q:(MergeOrderNo'="")&&(TMergeOrderNo'=MergeOrderNo)
	.s TStatus = $p($g(^DHCEQMergeOrder(TRowID)),"^",14)
	.q:(StatusDR'="")&&(StatusDR'=TStatus)  //Add by QW20201211 BUG:
	.s TStatus=$case(TStatus,0:"新增",1:"提交",2:"审核",:"")
	.s TSourceType = SourceType
	.s MOLRowID=0
	.s TRequestNumTotal=0
	.s PassFlag="N"  //add by csj 2020-11-24 需求号：1605437
	.f  s MOLRowID=$o(^DHCEQMergeOrderList(0,"MergeOrderDR",TRowID,MOLRowID))  quit:MOLRowID=""  d
	..q:$p($g(^DHCEQMergeOrderList(MOLRowID)),"^",7)="Y"   //add by wy 2020-05-06 1288746系统参数控制是否删除汇总报废单中的对应明细记录
	..s TRequestNum = $p($g(^DHCEQMergeOrderList(MOLRowID)),"^",3)
	..s TSourceID = $p($g(^DHCEQMergeOrderList(MOLRowID)),"^",2)
	..d GetSourceData
	.q:(RequestNo'="")&&(TRequestNo'[RequestNo) //add by csj 2020-11-24 需求号：1605437
	.q:PassFlag="N" //modified by csj 2020-11-24 需求号：1605437
	.d OutputRowGetMergeOrder //modified by csj 2020-11-16 需求号：1605437

	Quit $$$OK
	
GetSourceData
	i TSourceType ="34"  d
	.i TRequestNo="" s TRequestNo=$p($g(^DHCEQDisuseRequest(TSourceID)),"^",33) //modified by csj 2020-11-16
	.e  s TRequestNo=TRequestNo_","_$p($g(^DHCEQDisuseRequest(TSourceID)),"^",33)
	.s TRequestLocDR = $p($g(^DHCEQDisuseRequest(TSourceID)),"^",3)
	.i TRequestLocDR'="" Set TRequestLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TRequestLocDR)
	.s TUserLocDR=$Piece($Get(^DHCEQDisuseRequest(TSourceID)),"^",34)
	.i TUserLocDR'="" Set TUserLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUserLocDR)
	.i TUserLoc'="" Set TUserLoc=##class(web.DHCEQCommon).GetSplitDataByFlag(TUserLoc,"-")
	.s TDisuseDate=$p($g(^DHCEQDisuseRequest(TSourceID)),"^",4)
	.s TDisuseDate=##Class(web.DHCEQCommon).TransValueToPage(TDisuseDate,"date")
	.s DRLRowID=0
	.f  s DRLRowID=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",TSourceID,DRLRowID))  quit:DRLRowID=""  d
	..s TEquipDR=$p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",2)
	..If (TEquip '="")&&((","_$Piece($Get(^DHCEQEquip(TEquipDR)),"^",1)_",")'[(","_TEquip_","))  d
	...Set TEquip = TEquip_","_$Piece($Get(^DHCEQEquip(TEquipDR)),"^",1)
	..If TEquip ="" Set TEquip = $Piece($Get(^DHCEQEquip(TEquipDR)),"^",1)
	..If TNo '="" Set TNo = TNo_","
	..Set TNo = TNo_$Piece($Get(^DHCEQEquip(TEquipDR)),"^",71)
	..If (TOriginalFee'=0)  d    //start added by LMH 20220810 2772600
	...Set TOriginalFee = TOriginalFee+$Piece($Get(^DHCEQEquip(TEquipDR)),"^",27)
	..If TOriginalFee =0 Set TOriginalFee = $Piece($Get(^DHCEQEquip(TEquipDR)),"^",27) //end added by LMH 20220810 2772600   ..s TOriginalFee=+$p($g(^DHCEQEquip(TEquipDR)),"^",27)
	.i $d(^DHCEQDisuseList(0,"Request",TSourceID))  d
	..s dlid=0
	..f  s dlid=$Order(^DHCEQDisuseList(0,"Request",TSourceID,dlid)) Quit:dlid=""  Do
	...s TQuantityNum=TQuantityNum+$Piece($Get(^DHCEQDisuseList(dlid)),"^",4)
	.e  d
	..s TQuantityNum=1
	.s TTotalFee=TOriginalFee  //modefied by LMH 20220810 2772600
	.s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee)
	.s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee)

	i PassFlag="Y" quit //汇总报废单只要有一条明细符合就输出
	i (UseLoc'="")&&(UseLoc'=TUserLoc) s PassFlag="N" quit
	i (Equip'="")&&(##Class(web.DHCEQCommon).Find(TEquip,Equip,"N")=0) s PassFlag="N" quit  ;Modified By QW20210129 BUG:QW0089 测试需求1747830
	i ($p($g(^DHCEQDisuseRequest(TSourceID)),"^",4)>EndDate)||($p($g(^DHCEQDisuseRequest(TSourceID)),"^",4)<StartDate) s PassFlag="N" quit
	s PassFlag="Y"
	//d OutputRowGetMergeOrder //end by csj 2020-11-16 需求号：1605437
	quit
	
OutputRowGetMergeOrder
	///Add By QW20210429 BUG:QW0102 begin
	s ^DHCEQTemp("MergeOrderList",+$h,Ejob,curuser,gnum)=TQuantityNum_"^"_TTotalFee
	s gnum=gnum+1
	///Add By QW20210429 BUG:QW0102 end
	s Data=$lb(TRowID,TMergeOrderNo,TSourceType,TSourceID,TRequestNum,TRequestNo,TUserLoc,TEquip,TNo,TOriginalFee,TQuantityNum,TRequestLocDR,TRequestLoc,TTotalFee,TDisuseDate,TStatus)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetMergeOrder
	s (TRowID,TDRRowID,TMergeOrderDR,TSourceID,TRequestNum,TStatus,TRequestNo,TUserLoc,TEquip,TNo,TOriginalFee,TQuantityNum,TRequestLocDR,TRequestLoc,TTotalFee)=""
	quit
}

ClassMethod GetMergeOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMergeOrderExecute ]
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

ClassMethod GetMergeOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMergeOrderExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Add by QW20201223 BUG: QW0085 报废汇总批量审核获取审批权限
/// w ##Class(web.DHCEQ.Plat.BUSMergeOrder).GetApproveAction("34",85)
ClassMethod GetApproveAction(BussType As %String = "", GroupID As %String = "")
{
	s SActionCode=##class(web.DHCEQCommon).GetSysInfo("601007")
	if SActionCode="" q ""
	s ActionDR=$O(^DHCEQCCode("DHCEQCAction",0,"Code",SActionCode,0))
	if ActionDR="" q ""
	s ActionDesc=""
	i GroupID="" s GroupID=%session.Get("LOGON.GROUPID")
	s CurRoleIDs=##Class(web.DHCEQCGroupRole).GetRolebyGroup(GroupID) 
	s ApproveType= ##Class(web.DHCEQMessages).GetApproveTypeByBussType(BussType)
	s ApproveSetDR=0
	f  s ApproveSetDR=$o(^DHCEQCCode("DHCEQCApproveSet",0,"ApproveType",ApproveType,ApproveSetDR))  q:ApproveSetDR=""  d
	.s id=$O(^DHCEQCCode("DHCEQCApproveFlow",0,"Action",ApproveSetDR,ActionDR,0))
	.q:id=""
	.s Step=$P($g(^DHCEQCCode("DHCEQCApproveFlow",id)),"^",3)-1
	.f  s Step=$O(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSetDR,Step)) q:Step=""  d
	..s rowid=0
	..f  s rowid=$O(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSetDR,Step,rowid)) q:rowid=""  d
	...s Role=$P($g(^DHCEQCCode("DHCEQCApproveFlow",rowid)),"^",2)
	...q:((","_CurRoleIDs_",")'[(","_Role_","))
	...s actiondr=$P($g(^DHCEQCCode("DHCEQCApproveFlow",rowid)),"^",9)
	...i ActionDesc'="" s ActionDesc=ActionDesc_","
	...i actiondr'="" s ActionDesc=ActionDesc_ApproveSetDR_"&"_$P($g(^DHCEQCCode("DHCEQCApproveFlow",rowid)),"^",2)_"&"_$p($g(^DHCEQCCode("DHCEQCAction",actiondr)),"^",1)_"^"_$p($g(^DHCEQCCode("DHCEQCAction",actiondr)),"^",2)
	q ActionDesc
}

/// Add by QW20201223 BUG: QW0085 判断报废单是否已属于汇总单
/// w ##Class(web.DHCEQ.Plat.BUSMergeOrder).IsInMergeOrder("34",85)
ClassMethod IsInMergeOrder(MORowID As %String = "", DRowID As %String = "")
{
	s num=0
	i MORowID="" q 0
	s MOLRowID=0 
	f  s MOLRowID=$o(^DHCEQMergeOrderList(0,"MergeOrderDR",MORowID,MOLRowID))  quit:MOLRowID=""  d
	.s TSourceID = $p($g(^DHCEQMergeOrderList(MOLRowID)),"^",2)
	.q:TSourceID=""
	.q:DRowID'=TSourceID
	.s num=1
	q num
}

/// Add By QW20210429 BUG:QW0102
/// 输入：node：临时global的节点名称
/// 输出：合计信息
/// w ##Class(web.DHCEQ.Plat.BUSMergeOrder).GetEquipSumInfo()
ClassMethod GetEquipSumInfo(Ejob As %Library.String = "")
{
	s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s info=""
	s (Count,TotalFee)=0
	s nrowid=0
	f  s nrowid=$o(^DHCEQTemp("MergeOrderList",+$h,Ejob,curuser,nrowid)) q:nrowid=""  d
	.s Count=Count+$p($g(^DHCEQTemp("MergeOrderList",+$h,Ejob,curuser,nrowid)),"^",1)
	.s TotalFee=TotalFee+$p($g(^DHCEQTemp("MergeOrderList",+$h,Ejob,curuser,nrowid)),"^",2)
	s TotalFee=##Class(web.DHCEQCommon).FormatNumber(TotalFee,"")
  	s info="总数量:"_Count_"&nbsp;&nbsp;&nbsp;总金额:"_TotalFee_"&nbsp;&nbsp;&nbsp;"
  	q info
}

}
