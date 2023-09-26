/// ------------------------------------
/// modified by wsp&JY 2015-08-20 wsp&JY0003
/// 编写DHC_EQCBillItem表的增、改、删、找方法
/// ------------------------------------
Class web.DHCEQBillItem Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 增加、修改数据
/// w ##Class(web.DHCEQBillItem).UpdateBillItem("8^01^测试^1^6^2008^10^50000^^0")
ClassMethod UpdateBillItem(BillItemInfo)
{
	n Plist,RowID,OneInFee
	s OneInFee=0
	s RowID=$P(BillItemInfo,"^",1)
	s Plist(1)=$P(BillItemInfo,"^",1) ;rowid
	s Plist(2)=$P(BillItemInfo,"^",4) ;SourceType/业务类型(暂定为1)
	s Plist(3)=$P(BillItemInfo,"^",5) ;SourceID/业务ID(指向BuyRequest)
	s Plist(4)=$P(BillItemInfo,"^",2) ;代码
	s Plist(5)=$P(BillItemInfo,"^",3) ;名称
	s Plist(6)=$P(BillItemInfo,"^",6) ;价格
	s Plist(7)=$P(BillItemInfo,"^",7) ;成本
	s Plist(8)=$P(BillItemInfo,"^",8) ;预计工作量
	s Plist(11)=$P(BillItemInfo,"^",10) ;使用标记
	s Plist(12)=$P(BillItemInfo,"^",9) ;新开发功能标记
	s Plist(14)=$P(BillItemInfo,"^",11) ;Hold1 是否是功能项目
	s OneInFee=(Plist(6)-Plist(7))*Plist(8)
	
	if RowID=""
	{
		&SQL(insert into sqluser.DHC_EQBillItem values :Plist())
		q SQLCODE_"^"_OneInFee
	}
	else
	{
		&SQL(update sqluser.DHC_EQBillItem values :Plist() where BI_RowID=:RowID)
		q SQLCODE_"^"_OneInFee
	}
}

ClassMethod SaveBillItem(val, ElementID As %String = "", TemplateID As %String = "", SourceType As %String = "", SourceID As %String = "")
{
	new AllInFee,ConsumableItemFee,length,i,SQLCODE
    Set $ZT="ERROR"
	TSTART
	s (AllInFee,ConsumableItemFee,SQLCODE)=0
    s length=$l(val,"&")
	f i=1:1:length  d
	.s BillItemInfo=$p(val,"&",i)
	.s OneBillInfo=##Class(web.DHCEQBillItem).UpdateBillItem(BillItemInfo)
	.s SQLCODE=$p(OneBillInfo,"^",1)
	.q:SQLCODE'=0
	.s AllInFee=AllInFee+$p(OneBillInfo,"^",2)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^"_AllInFee
	}
	if (ElementID'="")&&(TemplateID'="")
	{
		s tmp=""
		&SQL(select TL_RowID into :tmp from sqluser.DHC_EQTemplateList where TL_TemplateDR=:TemplateID and TL_ElementDR=:ElementID)
		i tmp'="" 
		{
			&SQL(update sqluser.DHC_EQTemplateList set TL_Result=:AllInFee where TL_RowID=:tmp)
			
			i SQLCODE
			{
				TROLLBACK
				q SQLCODE
			}
		}
	}
	if (SourceType'="")&(SourceID'="") s ConsumableItemFee=##Class(web.DHCEQConsumableItemInfo).GetConsumableItemFee(SourceType,SourceID)
	s AllInFee=ConsumableItemFee+AllInFee
	TCOMMIT
    q SQLCODE_"^"_AllInFee
ERROR 
	Set ErrorMsg=$ZE	          
	TROLLBACK		      
	Quit "<ERROR>"_ErrorMsg
}

/// 根据rowid号删除数据
ClassMethod DeleteBillItem(RowID)
{
	if RowID'=""
	{
		&SQL(update sqluser.DHC_EQBillItem set BI_InvalidFlag='Y' where BI_RowID=:RowID)
		q SQLCODE
	}
	q "删除失败"
}

/// 根据索引IndexBIBuyRequestDR查找数据
/// d ##Class(%ResultSet).RunQuery("web.DHCEQBillItem","GetBillItem","2","13383")
Query GetBillItem(SourceType As %String = "", SourceID As %String = "", IsFunction As %String = "") As %Query(ROWSPEC = "TRowID:%String,TSourceType:%String,TSourceID:%String,TCode:%String,TDesc:%String,TPrice:%String,TCost:%String,TWorkLoadNum:%String,TDevelopStatusDR:%String,TDevelopStatus:%String,TUsedFlag:%String,TTotalFee:%String")
{
}

ClassMethod GetBillItemExecute(ByRef qHandle As %Binary, SourceType As %String = "", SourceID As %String = "", IsFunction As %String = "") As %Status
{
	new repid,index,rowid
	set repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	i SourceType=""||SourceID="" Quit $$$OK
	i '$Data(^DHCEQBillItem(0,"Source",SourceType,SourceID)) Quit $$$OK
	s index=1	
	s rowid=0
	f  s rowid=$o(^DHCEQBillItem(0,"Source",SourceType,SourceID,rowid)) q:rowid=""  d
	.s BillItemInfo=$g(^DHCEQBillItem(rowid))
	.q:($P(BillItemInfo,"^",12)="Y")
	.s TRowID=rowid
	.s TSourceType=$P(BillItemInfo,"^",1)
	.s TSourceID=$P(BillItemInfo,"^",2)
	.s TCode=$P(BillItemInfo,"^",3)
	.s TDesc=$P(BillItemInfo,"^",4)
	.s TPrice=$P(BillItemInfo,"^",5)
	.s TCost=$P(BillItemInfo,"^",6)
	.s TWorkLoadNum=$P(BillItemInfo,"^",7)
	.s TDevelopStatusDR=$P(BillItemInfo,"^",11)
	.//s TDevelopStatus=##Class(web.DHCEQBillItem).GetDevelopStatus(TDevelopStatusDR)
	.s TDevelopStatus=$CASE(TDevelopStatusDR,"":"","0":"原有功能","1":"可开发功能","2":"已开发功能")
	.s TUsedFlag=$P(BillItemInfo,"^",10)
	.s THold1=$P(BillItemInfo,"^",13)
	.s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TWorkLoadNum*(TPrice-TCost))
	.q:(IsFunction'=THold1)
	.d OutputRowGetBillItem
	Quit $$$OK
OutputRowGetBillItem
	s Data=$lb(TRowID,TSourceType,TSourceID,TCode,TDesc,TPrice,TCost,TWorkLoadNum,TDevelopStatusDR,TDevelopStatus,TUsedFlag,TTotalFee)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetBillItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBillItemExecute ]
{
	s repid=$LIST(qHandle,2)
	k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetBillItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBillItemExecute ]
{
	s AtEnd=$LIST(qHandle,1)
	s repid=$LIST(qHandle,2)
	s ind=$LIST(qHandle,3)
	s ind=$o(^CacheTemp(repid,ind))
	if ind=""
	{
		s AtEnd=1
		s Row=""
	}
	else
	{
		set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetOneBillItem(BRRowID, i)
{
	n rowid,result,node
	s rowid=0
	s SourceType=1
	s node=0
	f  s node=node+1 q:node>i  d
	.s rowid=$O(^DHCEQBillItem(0,"Source",SourceType,BRRowID,rowid))
	if (rowid'="")
	{
		s result=$g(^DHCEQBillItem(rowid))
	}
	else
	{
		s result=""
	}
	q result
}

ClassMethod GetOneBuyRequestList(BRRowID, BRLRowID)
{
	n result
	s result=""
	s RequestNo=$P($g(^DHCEQBuyRequest(BRRowID)),"^",35)  //申请单号
	s result=RequestNo
	s RequestLocDR=$P($g(^DHCEQBuyRequest(BRRowID)),"^",2)  //申请科室DR
	;s RequestLoc=$P($g(^CTLOC(RequestLocDR)),"^",1)  //申请科室    //modify by jyp 2019-10-18 CTLOC调整
	s RequestLoc=##class(web.DHCEQCommon).GetTrakNameByID("deptcode",RequestLocDR)    //modify by jyp 2019-10-18 CTLOC调整
	s result=result_"^"_RequestLoc
	s EquipName=$P($g(^DHCEQBuyRequestList(BRLRowID)),"^",2)  //设备名称
	s result=result_"^"_EquipName
	q result
}

ClassMethod GetDevelopStatus(DevelopStatusDR)
{
	i DevelopStatusDR=0  q "原有功能" 
	i DevelopStatusDR=1  q "可开发功能" 
	i DevelopStatusDR=2  q "已开发功能"
}

/// w ##Class(web.DHCEQBillItem).GetBillItemFee(1,5)
ClassMethod GetBillItemFee(SourceType, SourceID)
{
	new BillItemInfo,TTotalFee,AllTotalFee,rowid
	s (TTotalFee,AllTotalFee)=0
	i SourceType=""||SourceID="" Quit 0
	i '$Data(^DHCEQBillItem(0,"Source",SourceType,SourceID)) Quit 0
	s rowid=0
	f  s rowid=$o(^DHCEQBillItem(0,"Source",SourceType,SourceID,rowid)) q:rowid=""  d
	.s BillItemInfo=$g(^DHCEQBillItem(rowid))
	.q:($P(BillItemInfo,"^",12)="Y")
	.s TPrice=$P(BillItemInfo,"^",5)
	.s TCost=$P(BillItemInfo,"^",6)
	.s TWorkLoadNum=$P(BillItemInfo,"^",7)
	.s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TWorkLoadNum*(TPrice-TCost))
	.s AllTotalFee=AllTotalFee+TTotalFee
	
	q AllTotalFee
}

Storage Default
{
<Data name="DHCEQBillItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQBillItemD</DataLocation>
<DefaultData>DHCEQBillItemDefaultData</DefaultData>
<IdLocation>^web.DHCEQBillItemD</IdLocation>
<IndexLocation>^web.DHCEQBillItemI</IndexLocation>
<StreamLocation>^web.DHCEQBillItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
