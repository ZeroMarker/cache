Class web.DHCEQMergeOrder Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 创建:lmm 2017-08-21
/// 描述:新增、更新汇总单数据
/// ----------------------------------
/// w ##Class(web.DHCEQMergeOrder).SaveData("^2^1^1^1^1^1^1^1^1^^^^^^^^^^^","^2^3^3^^^^^^^&^1^3^^3^^^^^^^")
/// w ##Class(web.DHCEQMergeOrder).SaveData("^32^0^","^5&^7")
ClassMethod SaveData(val, valList)
{
	new (val, valList)
	//s ^lmm("SaveData")=val_"//"_valList
	k PLIST,RowID
	Set $ZT="ERRORSave"
    s RowID=$p(val,"^",1)       ;RowID
	s User=1 //%session.Get("LOGON.USERID")
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
	s User=1 //%session.Get("LOGON.USERID")
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
/// ----------------------------------
/// d ##class(%ResultSet).RunQuery("web.DHCEQMergeOrder","GetMergeOrderList","87")
Query GetMergeOrderList(RowID) As %Query(ROWSPEC = "TRowID:%String,TDRRowID:%String,TMergeOrderDR:%String,TSourceID:%String,TRequestNum:%String,TAduitNum:%String,TRemark:%String,TRequestNo:%String,TUserLoc:%String,TEquip:%String,TNo:%String,TOriginalFee:%String,TQuantityNum:%String")
{
}

ClassMethod GetMergeOrderListExecute(ByRef qHandle As %Binary, RowID) As %Status
{
	s ^lmm("RowID")=RowID
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
	i TSourceType ="34"  d
	.s TRequestNo=$p($g(^DHCEQDisuseRequest(TSourceID)),"^",33)
	.s TUserLocDR=$Piece($Get(^DHCEQDisuseRequest(TSourceID)),"^",34)
	.i TUserLocDR'="" Set TUserLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUserLocDR)
	.i TUserLoc'="" Set TUserLoc=##class(web.DHCEQCommon).GetSplitDataByFlag(TUserLoc,"-")
	.s DRLRowID=0
	.f  s DRLRowID=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",TSourceID,DRLRowID))  quit:DRLRowID=""  d
	..s TEquipDR=$p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",2)
	..s TEquip=$p($g(^DHCEQEquip(TEquipDR)),"^",1)
	..s TNo=$p($g(^DHCEQEquip(TEquipDR)),"^",71)
	..s TOriginalFee=+$p($g(^DHCEQEquip(TEquipDR)),"^",27)
	.i $d(^DHCEQDisuseList(0,"Request",TSourceID))  d
	..s dlid=0
	..f  s dlid=$Order(^DHCEQDisuseList(0,"Request",TSourceID,dlid)) Quit:dlid=""  Do
	...s TQuantityNum=TQuantityNum+$Piece($Get(^DHCEQDisuseList(dlid)),"^",4)
	.e  d
	..s TQuantityNum=1
	d OutputRowGetMergeOrderList
	quit
	
OutputRowGetMergeOrderList
	s Data=$lb(TRowID,TDRRowID,TMergeOrderDR,TSourceID,TRequestNum,TAduitNum,TRemark,TRequestNo,TUserLoc,TEquip,TNo,TOriginalFee,TQuantityNum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetMergeOrderList
	s (TRowID,TDRRowID,TMergeOrderDR,TSourceID,TRequestNum,TAduitNum,TAuditedFlag,TRemark,TRequestNo,TUserLoc,TEquip,TNo,TOriginalFee,TQuantityNum)=""
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

}
