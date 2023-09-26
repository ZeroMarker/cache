/// Created By HZY 2012-12-27 
Class web.DHCEQUpdateAccessoryByList Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 1;

/// 根据列表操作，更新选择的配件，存到临时global
ClassMethod UpdateAccessoryByList(val, MXInfo)
{
	q:MXInfo=""
	s Job=$p(MXInfo,"^",1)
	s index=$p(MXInfo,"^",2)
	s Num=$p(MXInfo,"^",3)
	s MXRowID=$p(MXInfo,"^",4)
	;s ^HZY("val")=val_" # "_MXInfo
	i MXRowID'=""
	{
		s ^TEMPEQ("AMXList",Job,MXRowID)=val
	}
	else
	{
		s ^TEMPEQ("AMXList","EX",Job,index)=val
	}
	q 0
}

Query GetAccessoryByMove(SourceID As %String, QuantityNum As %String, Job As %String, index As %String, MXRowID As %String, StoreLocDR As %String, Type As %String) As %Query(ROWSPEC = "TRowID:%String,TAccessoryNo:%String,TSerialNo:%String,TSortNo:%String,TSelect:%String,TJob:%String,TRow:%String")
{
}

ClassMethod GetAccessoryByMoveExecute(ByRef qHandle As %Binary, SourceID As %String, QuantityNum As %String, Job As %String, index As %String, MXRowID As %String, StoreLocDR As %String, Type As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	s (SelectedNum,Num,SortNo)=0
 	s QuantityNum=+QuantityNum		;;;需求序号:	567450		Mozy	2018-3-23
 	s TJob=Job
 	s TRow=0	;需求序号:	409475		Mozy	20170710
 	s AccessoryIDs=..GetAccessoryIDsInfo(Type,MXRowID,StoreLocDR,QuantityNum,Job,index,SourceID)
 	s SelectIDs=$p(AccessoryIDs,"&",3)
 	s AccessoryIDs=$p(AccessoryIDs,"&",2)
 	i AccessoryIDs'="" s AccessoryIDs=","_AccessoryIDs_","
	
	if (SelectIDs'="")
	{
		d ResetGetAccessoryByMoveValues
		s SortNo=0
		s len=$l(SelectIDs,",")
		f i=1:1:len  d
		.s TRowID=$p(SelectIDs,",",i)
		.s TSerialNo=$p($g(^DHCEQAStockDetail(TRowID)),"^",9)		//序列号
		.s TAccessoryNo=$p($g(^DHCEQAStockDetail(TRowID)),"^",10)	//系统编号
		.s TStock=$p($g(^DHCEQAStockDetail(TRowID)),"^",17) //数量 //modify by GBX 2014-8-27 16:35:57
		.q:TStock=0
		.s TSortNo=TSortNo+1
		.s TSelect=0
		.q:((QuantityNum=1)&&(AccessoryIDs'[(","_TRowID_",")))		//Modify DJ 2014-09-11
		.i AccessoryIDs[(","_TRowID_",") s TSelect= 1
		.i AccessoryIDs=""  d
		..i QuantityNum>0  d
		...s QuantityNum=QuantityNum-1
		...s TSelect=1
		.d OutputRowGetAccessoryByMove
	}
	Quit $$$OK 	
OutputRowGetAccessoryByMove
	Set TRow=TRow+1		;需求序号:	409475		Mozy	20170710
	set Data=$lb(TRowID,TAccessoryNo,TSerialNo,TSortNo,TSelect,TJob,TRow)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
ResetGetAccessoryByMoveValues
	s (TRowID,TSerialNo,TAccessoryNo,TSortNo,TSelect,TStock,TRow)=0
	quit
}

ClassMethod GetAccessoryByMoveFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAccessoryByMoveExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAccessoryByMoveClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAccessoryByMoveExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

//modify by QW0005 2014-06-11

//w ##Class(web.DHCEQUpdateAccessoryByList).GetRowIDsByQuantityNum(23,4,"",410,4,3512,1)

ClassMethod GetRowIDsByQuantityNum(SourceID, QuantityNum, MXRowID, StoreLocDR, Job, index, Type)
{
	s EquipIDs=..GetAccessoryIDsInfo(Type,MXRowID,StoreLocDR,QuantityNum,Job,index,SourceID)
	s EquipIDs=$p(EquipIDs,"&",2)
	i $l(EquipIDs,",")'=QuantityNum	q index_"^可选设备数不一致!"
	if (MXRowID="")
	{
		s ^TEMPEQ("AMXList","EX",Job,index)=EquipIDs
	}
	else
	{
		if Type=1 	s ^DHCEQAMoveStockList(MXRowID,"EX","RowIDs")=EquipIDs	;qw0005-2014-06-10
		if Type=0   s ^DHCEQAReduceList(MXRowID,"EX","RowIDs")=EquipIDs	;qw0006-2014-08-13
		k ^TEMPEQ("AMXList",Job,MXRowID)
	}
	q 0
}

/// 根据所选择库存明细ID及数量，获取应该获取的ID串
/// 入参：		MXType：1转移明细 
/// 			MXID：对应的明细ID
/// 			FromLocDR:供给设备部门
/// 			Num:数量
/// 			Job:记录当前Job避免数据冲突
/// 			RowIndex：页面编辑时记录的行标记
/// 返回值：已经选中ID串^可选ID串^Flag
/// w ##Class(web.DHCEQUpdateAccessoryByList).GetAccessoryIDsInfo(1,"",410,4,3512,1,23)
ClassMethod GetAccessoryIDsInfo(MXType, MXID, FromLocDR, Num, Job, RowIndex, StockDetailDR)
{
	new AccessoryIDs,SelectIDs,Status,SelNum
	new RowID,NewAccessoryIDs,Flag
	s Status=0
	s AccessoryIDs=""
	s ReduceListID=""  //GBX2014-8-29 17:21:15
	if MXID'=""
	{
		;首先获取临时Global中存储的ID串
		i Job'="" s AccessoryIDs=$g(^TEMPEQ("AMXList",Job,MXID))
		;没有则取保存后，global中记录的数据
		i AccessoryIDs=""
		{
			i MXType=1	//配件转移
			{
				s AccessoryIDs=$g(^DHCEQAMoveStockList(MXID,"EX","RowIDs"))
				i ((Num=1)&&(AccessoryIDs'=StockDetailDR)) s AccessoryIDs=StockDetailDR		//Add By DJ 2014-09-12
				s AMSRowID=$p($g(^DHCEQAMoveStockList(MXID)),"^",1)		//Add By DJ 2014-09-12
				i AMSRowID'="" s Status=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",28)	//Add By DJ 2014-09-12
			}
			i MXType=0	//配件退货qw0006-2014-08-13
			{
				s AccessoryIDs=$g(^DHCEQAReduceList(MXID,"EX","RowIDs"))
				i ((Num=1)&&(AccessoryIDs'=StockDetailDR)) s AccessoryIDs=StockDetailDR		//Add By DJ 2014-09-12
				s ARRowID=$p($g(^DHCEQAReduceList(MXID)),"^",1)		//Add By DJ 2014-09-12
				i ARRowID'="" s Status=$p($g(^DHCEQAReduce(ARRowID)),"^",23)	//Add By DJ 2014-09-12
				s ReduceListID=MXID
				s MXID=""
			}
		}
	}
	else
	{
		i $D(^TEMPEQ("AMXList","EX",Job,RowIndex))  d		//Modify DJ 2014-09-11
		.i Num=1  d
		..s AccessoryIDs=StockDetailDR
		.e  d
		..s AccessoryIDs=$g(^TEMPEQ("AMXList","EX",Job,RowIndex))
		e  d
		.s AccessoryIDs=StockDetailDR
	}
	
	;已经提交的，直接取其记录的ID串
	i Status>0
	{
		s NewAccessoryIDs=AccessoryIDs
		s SelectIDs=AccessoryIDs
	}
	else
	{	
		s ASDList=$g(^DHCEQAStockDetail(StockDetailDR))
		s AInStockListDR=$p(ASDList,"^",3)	//库存明细对应的入库明细
		s NewAccessoryIDs=""
		s SelectIDs=""
		s SelNum=0
		i AccessoryIDs'="" s SelNum=$L(AccessoryIDs,",")
		;如果当前数量Num小于之前所选设备数量，直接截取
		i SelNum>Num
		{
			s SelNum=Num
			s AccessoryIDs=$p(AccessoryIDs,",",1,Num)
		}
		s AccessoryIDs=","_AccessoryIDs_","
		;计算缺少数量
		s SelNum=Num-SelNum  ;qw0005-2014-06-12
		
		s RowID=0
		f  s RowID=$O(^DHCEQAStockDetail(0,"AInStockList",AInStockListDR,RowID)) q:RowID=""  d
		.q:(FromLocDR'=$p($g(^DHCEQAStockDetail(RowID)),"^",1))	//科室
		.//q:(""=$p($g(^DHCEQAStockDetail(RowID)),"^",9))		//序列号
		.q:(1<$p($g(^DHCEQAStockDetail(RowID)),"^",12))			//状态
		.q:("N"=$p($g(^DHCEQAStockDetail(RowID)),"^",26))		//是否有库存
		.q:($p($g(^DHCEQAStockDetail(RowID)),"^",17)=0)         //库存  GBX GBX0028 2014-8-27 17:24:58
		.s CheckFlag=##Class(web.DHCEQAMoveStock).CheckAccessoryDR(MXID,ReduceListID, RowID, FromLocDR)
		.;s ^HZY("CheckFlag",RowID)=CheckFlag_"^"_AInStockListDR
		.q:CheckFlag=1
		.i SelectIDs'="" s SelectIDs=SelectIDs_","
		.s SelectIDs=SelectIDs_RowID
		.i AccessoryIDs[(","_RowID_",")  d
		..i NewAccessoryIDs'="" s NewAccessoryIDs=NewAccessoryIDs_","
		..s NewAccessoryIDs=NewAccessoryIDs_RowID
		.e  d
		..i SelNum>0  d
		...s SelNum=SelNum-1
		...i NewAccessoryIDs'="" s NewAccessoryIDs=NewAccessoryIDs_","
		...s NewAccessoryIDs=NewAccessoryIDs_RowID	
	}
	;Flag 0:正常  1：异常
	;如果获得的ID串的设备数与Num数量不符，说明之前选中的设备中有改变的，不符合条件的，
	;故需要重新选择
	s Flag=0
	i $L(NewAccessoryIDs,",")'=Num
	{
		s Flag=1
		s NewAccessoryIDs=$p($p(SelectIDs,"&",1),",",1,Num)
	}
	q Flag_"&"_NewAccessoryIDs_"&"_SelectIDs
}

/// 离开页面时,清空多余的临时global
/// w ##Class(web.DHCEQUpdateAccessoryByList).KillTEMPEQ("1")
ClassMethod KillTEMPEQ(Job)
{
	q:Job="" ""
	k ^TEMPEQ("AMXList",Job)
	k ^TEMPEQ("AMXList","EX",Job)
	q 0
}

}
