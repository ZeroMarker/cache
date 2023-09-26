Class web.DHCEQUpdateEquipsByList Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 440;

/// ----------------------------------
/// add by zy 2010-03-26  No ZY0019
/// 根据转移明细获取设备列表信息
/// SourceID:对应的入库单明细id
/// d ##class(%ResultSet).RunQuery("web.DHCEQUpdateEquipsByList","GetEquipsByMove",4,3,3532,1,55,499,1,"")
Query GetEquipsByMove(SourceID As %String, QuantityNum As %String, Job As %String, index As %String, MXRowID As %String, StoreLocDR As %String, Type As %String, EquipID As %String) As %Query(ROWSPEC = "TRowID:%String,TEquipNo:%String,TLeaveFactoryNo:%String,TSortNo:%String,TSelect:%String,TJob:%String,TFileNo:%String,TNetFee:%String,TDepreTotalFee:%String")
{
}

ClassMethod GetEquipsByMoveExecute(ByRef qHandle As %Binary, SourceID As %String, QuantityNum As %String, Job As %String, index As %String, MXRowID As %String, StoreLocDR As %String, Type As %String, EquipID As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	s (SelectedNum,Num,SortNo)=0
 	s TJob=Job
 	if EquipID=""
 	{
	 	s EquipIDs=..GetEquipIDsInfo(Type,MXRowID,StoreLocDR,SourceID,QuantityNum,Job,index)
	 	s SelectIDs=$p(EquipIDs,"&",3)
	 	s EquipIDs=$p(EquipIDs,"&",2)
	 	i EquipIDs'="" s EquipIDs=","_EquipIDs_","
 	}
 	else
 	{
	 	s SelectIDs=EquipID
	 	s EquipIDs=","_EquipID_","
	} 	
	if (SelectIDs'="")
	{
		s SortNo=0
		s len=$l(SelectIDs,",")
		f i=1:1:len  d
		.s EquipDR=$p(SelectIDs,",",i)
		.s LeavefactoryNo=$p($g(^DHCEQEquip(EquipDR)),"^",10)
		.s EquipNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
		.s TFileNo=$p($g(^DHCEQEquip(EquipDR)),"^",85)
		.// Mozy0249	1190898		20200227
		.s TNetFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(EquipDR)),"^",28),"")
		.s TDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(EquipDR)),"^",35),"")
		.s SortNo=SortNo+1
		.s Select=0
		.i EquipIDs[(","_EquipDR_",") s Select= 1
		.i EquipIDs=""  d
		..i QuantityNum>0  d
		...s QuantityNum=QuantityNum-1
		...s Select=1
		.d OutputRowGetEquipsByMove
	}
	Quit $$$OK 	
OutputRowGetEquipsByMove
	set Data=$lb(EquipDR,EquipNo,LeavefactoryNo,SortNo,Select,TJob,TFileNo,TNetFee,TDepreTotalFee)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetEquipsByMoveFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipsByMoveExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetEquipsByMoveClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipsByMoveExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by zy 2010-03-26  No ZY0019
/// 修改转移明细时清空临时global信息
/// w ##Class(web.DHCEQUpdateEquipsByList).SetTEMPEQ("^1^231^^364^4^1276^0")
ClassMethod SetTEMPEQ(val)
{
	new (val)
	s Job=$p(val,"^",1)
	s index=$p(val,"^",2)
	s MXRowID=$p(val,"^",3)
 	if Job=""
 	{
	 	s Job=$J
 	}
 	else
 	{
	 	if MXRowID'=""
	 	{
		 	k ^TEMPEQ("MXList",Job,MXRowID)
		}
		elseif (index'="")
		{
			k ^TEMPEQ("MXList","EX",Job,index)
		}
	}
	q Job
}

/// add by zy 2010-03-26  No ZY0019
/// 根据列表操作，更新选择的设备，存到临时global
/// w ##Class(web.DHCEQUpdateEquipsByList).UpdateEquipsByList("1^no1&2^no2&3^no3")
ClassMethod UpdateEquipsByList(val, MXInfo)
{
	new StoreMoveListDR,Num,StoreMoveDR
	q:MXInfo=""
	s Job=$p(MXInfo,"^",1)
	s index=$p(MXInfo,"^",2)
	s Num=$p(MXInfo,"^",3)
	s MXRowID=$p(MXInfo,"^",4)
	i MXRowID'=""
	{
		s ^TEMPEQ("MXList",Job,MXRowID)=val
	}
	else
	{
		s ^TEMPEQ("MXList","EX",Job,index)=val
	}
	q 0
}

/// add by zy 2010-03-26  No ZY0019
/// 查看设备是不是已经存在其他的转移单或退货减少单中，是，返回1；否则，返回0
/// 入参：Type： MXRowID类型，1转移单 2退货单
/// w ##Class(web.DHCEQUpdateEquipsByList).CheckEquipDR("","183","114",)
ClassMethod CheckEquipDR(MXRowID, EquipDR, FromLocDR, Type)
{
	new (MXRowID, EquipDR, FromLocDR,Type)
	i EquipDR="" q 0
	s pEquipDR=EquipDR
	s EquipDR=","_EquipDR_","
	s Flag=0
	//检测来源科室新增，提交状态转移单据是否已存在当前设备（不包括当前转移明细记录）
	s Status=""
	f  s Status=$o(^DHCEQStoreMove(0,"StatusFromLoc",Status))  q:(Status="")||(Flag'=0)  d
	.q:(Status'=0)&&(Status'=1)
	.s rowid=0
	.f  s rowid=$o(^DHCEQStoreMove(0,"StatusFromLoc",Status,FromLocDR,rowid))  q:(rowid="")||(Flag'=0)  d
	..s SMInvalidFlag=$p($g(^DHCEQStoreMove(rowid)),"^",27)
	..q:SMInvalidFlag="Y"
	..s mxrowid=0
	..f  s mxrowid=$o(^DHCEQStoreMoveList(0,"StoreMove",rowid,mxrowid))  q:(mxrowid="")||(Flag'=0)  d
	...q:(MXRowID'="")&&(MXRowID=mxrowid)&&(Type=1)
	...s RowIDs=$g(^DHCEQStoreMoveList(mxrowid,"EX","RowIDs"))
	...i (","_RowIDs_",")[EquipDR s Flag=1
	i Flag'=0 q Flag
	//检测来源科室新增，提交状态退货减少单据是否已经存在当前设备(不包括当前退货减少明细记录)
	s Status=""
	f  s Status=$o(^DHCEQReturn(0,"StatusReturnLoc",Status))  q:(Status="")||(Flag'=0)  d
	.q:(Status'=0)&&(Status'=1)
	.s rowid=0
	.f  s rowid=$o(^DHCEQReturn(0,"StatusReturnLoc",Status,FromLocDR,rowid)) q:(rowid="")||(Flag'=0)  d
	..s RInvalidFlag=$p($g(^DHCEQReturn(rowid)),"^",28)
	..q:RInvalidFlag="Y"
	..s mxrowid=0
	..f  s mxrowid=$o(^DHCEQReturnList(0,"Return",rowid,mxrowid)) q:(mxrowid="")||(Flag'=0)  d
	...q:(MXRowID'="")&&(MXRowID=mxrowid)&&(Type=2)
	...s RowIDs=$g(^DHCEQReturnList(mxrowid,"EX","RowIDs"))
	...i (","_RowIDs_",")[EquipDR s Flag=1
	i Flag'=0 q Flag
	
	//检测来源科室新增，提交状态报废单据是否已经存在当前设备(不包括当前报废明细记录)
	//modified by czf 2022-07-01 2695790 更改遍历方式
	/*
	s Status=""
	f  s Status=$o(^DHCEQDisuseRequest(0,"Status",Status))  q:(Status="")||(Flag'=0)  d
	.q:(Status'=0)&&(Status'=1)
	.s rowid=0
	.f  s rowid=$o(^DHCEQDisuseRequest(0,"Status",Status,rowid))  q:(rowid="")||(Flag'=0)  d
	..s InvalidFlag=$p($g(^DHCEQDisuseRequest(rowid)),"^",53)
	..q:InvalidFlag="Y"
	..s KindFlag=$p($g(^DHCEQDisuseRequest(rowid)),"^",44)
	..s DREquipDR=$p($g(^DHCEQDisuseRequest(rowid)),"^",1)
	..q:(KindFlag=0)&&(DREquipDR'=EquipDR)
	..q:(MXRowID'="")&&(MXRowID=rowid)&&(Type=6)		//单批次
	..s RowIDs=$g(^DHCEQDisuseRequest(rowid,"EX"))
	..i (","_RowIDs_",")[EquipDR s Flag=1
	..q:Flag'=0
	..s DLRowID=0
	..f  s DLRowID=$o(^DHCEQDisuseList(0,"Request",rowid,DLRowID))  q:(DLRowID="")||(Flag'=0)  d
	...q:(MXRowID'="")&&(MXRowID=DLRowID)&&(Type=5)		//多批次
	...s RowIDs=$g(^DHCEQDisuseList(DLRowID,"EX"))
	...i (","_RowIDs_",")[EquipDR s Flag=1
	*/
	s DRLRowID=0
	f  s DRLRowID=$o(^DHCEQDisuseRequestList(0,"EquipDR",pEquipDR,DRLRowID)) q:(DRLRowID="")||(Flag'=0)  d
	.s DRRowID=$p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",1)
	.s Status=$p($g(^DHCEQDisuseRequest(DRRowID)),"^",10)
	.q:(Status'=0)&&(Status'=1)
	.q:$p($g(^DHCEQDisuseRequest(DRRowID)),"^",53)="Y"
	.s Flag=1
	.q:Flag'=0
	
	q Flag
}

/// add by zy 2010-03-26  No ZY0019
/// 修改设备出厂编号
/// w ##Class(web.DHCEQUpdateEquipsByList).UpdateLeaveFactoryNo("127","10716","3")
ClassMethod UpdateLeaveFactoryNo(val)
{
	new (val)
	q:val=""
	s Length=$L(val,",")
	s Flag=0
	TStart
	for i=1:1:Length
 	{
	 	q:Flag'=0
		s Info=$P(val,",",i)
		s EquipDR=$P(Info,"^",1)
		s LeaveFactoryNo=$P(Info,"^",2)
		&SQL(Update SQLUSER.DHC_EQEquip set EQ_LeaveFactoryNo=:LeaveFactoryNo where EQ_RowID=:EquipDR)
		if SQLCODE s Flag=SQLCODE
 	}
 	if Flag'=0 TROLLBACK
	TCommit
	q Flag
}

/// add zy 2010-03-26  No ZY0019
/// 离开页面时,清空多余的临时global
/// w ##Class(web.DHCEQUpdateEquipsByList).KillTEMPEQ("1")
ClassMethod KillTEMPEQ(Job)
{
	q:Job="" ""
	k ^TEMPEQ("MXList",Job)
	k ^TEMPEQ("MXList","EX",Job)
	q 0
}

/// add by zy 2010-03-26  No ZY0019
/// 根据设备数量自动生成设备RowIDs
/// w ##Class(web.DHCEQUpdateEquipsByList).GetRowIDsByQuantityNum("364","5","371","0","1276","","1")
ClassMethod GetRowIDsByQuantityNum(SourceID, QuantityNum, MXRowID, StoreLocDR, Job, index, Type)
{
	s EquipIDs=..GetEquipIDsInfo(Type,MXRowID,StoreLocDR,SourceID,QuantityNum,Job,index)
	s EquipIDs=$p(EquipIDs,"&",2)
	i $l(EquipIDs,",")'=QuantityNum	q (index+1)_"^可选设备数不一致!" //add by wy 2020-01-21 QW20200218 BUG:QW0040 index从0开始，返回值必须从1开始。
	if (MXRowID="")
	{
		s ^TEMPEQ("MXList","EX",Job,index)=EquipIDs
	}
	else
	{
		if Type=1 	s ^DHCEQStoreMoveList(MXRowID,"EX","RowIDs")=EquipIDs
		if Type=2 	s ^DHCEQReturnList(MXRowID,"EX","RowIDs")=EquipIDs
		if Type=4 	s ^DHCEQSwapList(MXRowID,"EX","RowIDs")=EquipIDs	;MR0015
		if Type=5	s ^DHCEQDisuseList(MXRowID,"EX")=EquipIDs   //add by wy 2020-01-21 QW20200218 BUG:QW0040
		if Type=6	s ^DHCEQDisuseRequest(MXRowID,"EX")=EquipIDs //Add by QW20200303 BUG:QW0042
		k ^TEMPEQ("MXList",Job,MXRowID)
	}
	q 0
}

/// 	Mozy	2011-5-16	增加验收单明细获取设备ID
/// Add by Jdl 2011-1-21 JDL0067
/// 根据所选择入库明细ID及数量，获取应该获取的设备ID串
/// 入参：	MXType：1转移明细 2退货明细
/// 			MXID：对应的明细ID
/// 			FromLocDR:供给设备部门
/// 			ISLRowID：选择要供给的设备入库明细
/// 			Job:记录当前Job避免数据冲突
/// 			RowIndex：页面编辑时记录的行标记
/// 			Mode:返回信息模式  0：已经选中ID串^可选ID串  1选中ID串
/// 	返回值：已经选中ID串^可选ID串^Flag
/// 	w ##Class(web.DHCEQUpdateEquipsByList).GetEquipIDsInfo(1,51,114,80,3,3440,2)
ClassMethod GetEquipIDsInfo(MXType, MXID, FromLocDR, ISLRowID, Num, Job, RowIndex)
{
	;s ^DHCEQMozy("GetEquipIDsInfo")=MXType_"^"_MXID_"^"_FromLocDR_"^"_ISLRowID_"^"_Num_"^"_Job_"^"_RowIndex
	n EquipIDs,SelectIDs,Status,SelNum
	n RowID,NewEquipIDs,Flag
	s Status=0
	Set EquipIDs=""
	if MXID'=""
	{
		;首先获取临时Global中存储的ID串
		i Job'="" s EquipIDs=$g(^TEMPEQ("MXList",Job,MXID))
		;没有则取保存后，global中记录的数据
		i EquipIDs=""
		{
			i MXType=1
			{
				s Status=$p(^DHCEQStoreMove($p($g(^DHCEQStoreMoveList(MXID)),"^",1)),"^",13)
				i $p($g(^DHCEQStoreMoveList(MXID)),"^",4)=ISLRowID s EquipIDs=$g(^DHCEQStoreMoveList(MXID,"EX","RowIDs"))
			}
			elseif MXType=2
			{
				s Status=$p(^DHCEQReturn($p($g(^DHCEQReturnList(MXID)),"^",1)),"^",13)
				i $p($g(^DHCEQReturnList(MXID)),"^",3)=ISLRowID s EquipIDs=$g(^DHCEQReturnList(MXID,"EX","RowIDs"))
			}
			elseif MXType=3
			{
				Set Status=$Piece(^DHCEQOpenCheckRequest($Piece($Get(^DHCEQOpenCheckList(MXID)),"^",1)),"^",20)
				Set EquipIDs=$Get(^DHCEQOpenCheckList(MXID,"EX","RowIDs"))
			}
			elseif MXType=4 ;MR0015
			{
				s Status=$p(^DHCEQSwap($p($g(^DHCEQSwapList(MXID)),"^",1)),"^",10)
				i $p($g(^DHCEQSwapList(MXID)),"^",6)=ISLRowID s EquipIDs=$g(^DHCEQSwapList(MXID,"EX","RowIDs"))
			}
			elseif MXType=5			//Add By DJ 2016-04-25  多批
			{
				s Status=$p(^DHCEQDisuseRequest($p($g(^DHCEQDisuseList(MXID)),"^",1)),"^",10)
				s DLSourceType=$p($g(^DHCEQDisuseList(MXID)),"^",2)
				s DLSourceID=$p($g(^DHCEQDisuseList(MXID)),"^",3)
				i ((DLSourceType=1)&&(DLSourceID=ISLRowID))	s EquipIDs=$g(^DHCEQDisuseList(MXID,"EX"))
			}
			elseif MXType=6			//Add By DJ 2016-04-25  单批多台
			{
				s Status=$p(^DHCEQDisuseRequest(MXID),"^",10)
				s DLSourceID=$p(^DHCEQDisuseRequest(MXID),"^",45)
				i (DLSourceID=ISLRowID)  s EquipIDs=$g(^DHCEQDisuseRequest(MXID,"EX"))
			}
		}
	}
	else
	{
		s EquipIDs=$g(^TEMPEQ("MXList","EX",Job,RowIndex))
	}
	
	;已经提交的，直接取其记录的ID串
	i Status>0
	{
		s NewEquipIDs=EquipIDs
		s SelectIDs=EquipIDs
	}
	else
	{		
		s NewEquipIDs=""
		s SelectIDs=""
		s SelNum=0
		i EquipIDs'="" s SelNum=$L(EquipIDs,",")
		;如果当前数量Num小于之前所选设备数量，直接截取
		i SelNum>Num
		{
			s SelNum=Num
			s EquipIDs=$p(EquipIDs,",",1,Num)
		}
		s EquipIDs=","_EquipIDs_","
		;计算缺少数量
		s SelNum=Num-SelNum
		
		s RowID=0
		f  s RowID=$O(^DHCEQEquip(0,"InStockList",ISLRowID,FromLocDR,RowID)) q:RowID=""  d
		.q:$p($g(^DHCEQEquip(RowID)),"^",38)>2 //Status已经报废设备过滤
		.q:$p($g(^DHCEQEquip(RowID)),"^",59)="Y" //不可用
		.q:$p($g(^DHCEQEquip(RowID)),"^",60)'=1 //StockStatus非在库设备过滤
		.s CheckFlag=..CheckEquipDR(MXID,RowID,FromLocDR,MXType)
		.q:CheckFlag=1
		.i SelectIDs'="" s SelectIDs=SelectIDs_","
		.s SelectIDs=SelectIDs_RowID
		.i EquipIDs[(","_RowID_",")  d
		..i NewEquipIDs'="" s NewEquipIDs=NewEquipIDs_","
		..s NewEquipIDs=NewEquipIDs_RowID
		.e  d
		..i SelNum>0  d
		...s SelNum=SelNum-1
		...i NewEquipIDs'="" s NewEquipIDs=NewEquipIDs_","
		...s NewEquipIDs=NewEquipIDs_RowID	
	}
	;Flag 0:正常  1：异常
	;如果获得的ID串的设备数与Num数量不符，说明之前选中的设备中有改变的，不符合条件的，
	;故需要重新选择，将NewEquipIDs清空	
	s Flag=0
	i $L(NewEquipIDs,",")'=Num
	{
		s Flag=1
		;s NewEquipIDs=""
		s NewEquipIDs=$p($p(SelectIDs,"&",1),",",1,Num)
	}
	q Flag_"&"_NewEquipIDs_"&"_SelectIDs
}

/// Add by Mozy 2011-5-31	Mozy0052
/// 检测待保存的设备出厂编号是否有重复
/// 入参：	LeaveFactoryNos:序列号的字符串，多个之间以"^"分割
/// 返回：
/// 		0：无重复
/// 		1：LeaveFactoryNos:序列号的字符串中有重复的
/// 		2：与设备表中的设备有重复
/// 	w ##Class(web.DHCEQUpdateEquipsByList).CheckLeaveFactoryNo("251^10000,255^10111")
ClassMethod CheckLeaveFactoryNo(LeaveFactoryNos)
{
	new rowid,Flag,Num,EquipInfo,LeaveFactoryNo,id
	Quit:LeaveFactoryNos="" 0
	
	;检测序列号串中本身是否有重复的
	Set Flag=0
	Set Num=$Length(LeaveFactoryNos,",")
	Kill ^DHCEQTemp("DHCEQUpdateEquipsByList","CheckLeaveFactoryNo",$Job)
	for i=1:1:Num
	{
		Set EquipInfo=$Piece(LeaveFactoryNos,",",i)
		Set LeaveFactoryNo=$Piece(EquipInfo,"^",2)
		If LeaveFactoryNo="" continue
		If $Data(^DHCEQTemp("DHCEQUpdateEquipsByList","CheckLeaveFactoryNo",$Job,"No",LeaveFactoryNo)) Set Flag=1
		Quit:Flag'=0
		Set ^DHCEQTemp("DHCEQUpdateEquipsByList","CheckLeaveFactoryNo",$Job,"No",LeaveFactoryNo)=$Piece(EquipInfo,"^",1)
	}
	if (Flag'=0)
	{
		Kill ^DHCEQTemp("DHCEQUpdateEquipsByList","CheckLeaveFactoryNo",$Job)
		Quit Flag_"^"_$Piece($Get(^DHCEQEquip($Piece(EquipInfo,"^",1))),"^",71)_"->"_LeaveFactoryNo
	}
	
	;检测序列号是否与台帐中的设备有重复
	Set LeaveFactoryNos=","_LeaveFactoryNos_","
	Set rowid=0
	For  Set rowid=$Order(^DHCEQEquip(rowid))  Quit:(rowid="")||(Flag'=0)  Do 
	.Quit:$Piece($Get(^DHCEQEquip(rowid)),"^",59)="Y"		;InvalidFlag
	.Quit:$Piece($Get(^DHCEQEquip(rowid)),"^",60)=3			;StockStatus
	.
	.Set LeaveFactoryNo=$Piece($Get(^DHCEQEquip(rowid)),"^",10)
	.Quit:LeaveFactoryNo=""
	.Quit:('$Data(^DHCEQTemp("DHCEQUpdateEquipsByList","CheckLeaveFactoryNo",$Job,"No",LeaveFactoryNo)))
	.Quit:($Get(^DHCEQTemp("DHCEQUpdateEquipsByList","CheckLeaveFactoryNo",$Job,"No",LeaveFactoryNo))=rowid)
	.Set Flag=2
	.Set id=rowid
	
	Kill ^DHCEQTemp("DHCEQUpdateEquipsByList","CheckLeaveFactoryNo",$Job)
	Quit:Flag=0 0
	Quit Flag_"^"_$Piece($Get(^DHCEQEquip(id)),"^",71)_"->"_LeaveFactoryNo
}

/// Add By DJ 2017-11-20
/// 描述:点击保存按钮前存储明细记录对应EQRowIDs
ClassMethod UpListEQRowIDS(val)
{
	s EquipID=$p(val,"^",1)
	s Type=$p(val,"^",2)
	s MXRowID=$p(val,"^",3)
	s StoreLocDR=$p(val,"^",4)
	s SourceID=$p(val,"^",5)
	s QuantityNum=$p(val,"^",6)
	s Job=$p(val,"^",7)
	s index=$p(val,"^",8)
	//获取IDs
	i EquipID=""
	{
		s EquipIDs=..GetEquipIDsInfo(Type,MXRowID,StoreLocDR,SourceID,QuantityNum,Job,index)
	 	s EquipIDs=$p(EquipIDs,"&",2)
	 	i EquipIDs'="" s EquipIDs=","_EquipIDs_","
	}
	else
	{
		s EquipIDs=EquipID
	}
	//存储
	i MXRowID'=""
	{
		s ^TEMPEQ("MXList",Job,MXRowID)=EquipIDs
	}
	else
	{
		s ^TEMPEQ("MXList","EX",Job,index)=EquipIDs
	}
	q EquipIDs
}

}
