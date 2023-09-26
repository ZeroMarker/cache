Class web.DHCEQConsumableItemInfo Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 增加、修改数据
ClassMethod UpdateConsumableItemInfo(ConsumableItemInfo)
{
	n Plist,RowID,OneInFee
	s OneInFee=0
	s RowID=$P(ConsumableItemInfo,"^",1)
	s Plist(1)=$P(ConsumableItemInfo,"^",1) ;rowid
	s Plist(2)=$P(ConsumableItemInfo,"^",2) ;CII_SourceType/业务类型(暂定为1)
	s Plist(3)=$P(ConsumableItemInfo,"^",3) ;CII_ScourceID/业务ID(指向BuyRequest)
	s Plist(4)=$P(ConsumableItemInfo,"^",4) ;CII_Code
	s Plist(5)=$P(ConsumableItemInfo,"^",5) ;CII_Desc
	s Plist(6)=$P(ConsumableItemInfo,"^",6) ;CII_Model
	s Plist(7)=$P(ConsumableItemInfo,"^",7) ;CII_RegistrationNo
	s Plist(8)=$P(ConsumableItemInfo,"^",8) ;CII_Price
	s Plist(9)=$P(ConsumableItemInfo,"^",9) ;CII_DisposableFlag
	s Plist(10)=$P(ConsumableItemInfo,"^",10) ;CII_ChargeType
	s Plist(11)=$P(ConsumableItemInfo,"^",11) ;CII_BillItemNo
	s Plist(12)=$P(ConsumableItemInfo,"^",12) ;CII_ExpenseType
	s Plist(13)=$P(ConsumableItemInfo,"^",13) ;CII_ExpenseRate
	s Plist(14)=$P(ConsumableItemInfo,"^",14) ;CII_PreWorkload
	s Plist(15)=0
	i (Plist(10)=0)
	{
		s Plist(15)=1.05
		i (Plist(8)>500)  s Plist(15)=1.1
	}
	//s Plist(14)=$P(ConsumableItemInfo,"^",7) ;加成率
	s OneInFee=##Class(web.DHCEQCommon).FormatNumber(Plist(8)*Plist(14)*Plist(15)) ;总额
	
	if RowID=""
	{
		&SQL(insert into sqluser.DHC_EQConsumableItemInfo values :Plist())
		q SQLCODE_"^"_OneInFee
	}
	else
	{
		&SQL(update sqluser.DHC_EQConsumableItemInfo values :Plist() where CII_RowID=:RowID)
		q SQLCODE_"^"_OneInFee
	}
}

/// w ##Class(web.DHCEQConsumableItemInfo).SaveConsumableItem("1^1^4^1^2^3^4^1.1^16.5","25","5")
ClassMethod SaveConsumableItem(val, ElementID, TemplateID, SourceType, SourceID)
{
    Set $ZT="ERROR" //2009-08-10 党军
	TSTART //2009-08-10 党军
	s AllInFee=0
    s length=$l(val,"&")
	f i=1:1:length  d
	.s ConsumableItemInfo=$p(val,"&",i)
	.s OneConsumableInfo=##Class(web.DHCEQConsumableItemInfo).UpdateConsumableItemInfo(ConsumableItemInfo)
	.s SQLCODE=$p(OneConsumableInfo,"^",1)
	.q:SQLCODE'=0
	.s AllInFee=AllInFee+$p(OneConsumableInfo,"^",2)
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
	s BillItemFee=##Class(web.DHCEQBillItem).GetBillItemFee(SourceType,SourceID)
	s AllInFee=BillItemFee+AllInFee
	TCOMMIT
    q SQLCODE_"^"_AllInFee
ERROR 
	Set ErrorMsg=$ZE	          
	TROLLBACK		      
	Quit "<ERROR>"_ErrorMsg
}

/// 根据rowid号删除数据
ClassMethod DeleteConsumableItem(RowID)
{
	if RowID'=""
	{
		&SQL(update sqluser.DHC_EQConsumableItemInfo set CII_Hold1='Y' where CII_RowID=:RowID)
		q SQLCODE
	}
	q "删除失败"
}

/// 根据索引IndexBIBuyRequestDR查找数据
/// d ##Class(%ResultSet).RunQuery("web.DHCEQConsumableItemInfo","GetConsumableItem","1","5")
Query GetConsumableItem(SourceType As %String = "", SourceID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TSourceType:%String,TSourceID:%String,TCode:%String,TDesc:%String,TModel:%String,TRegistrationNo:%String,TPrice:%String,TDisposableFlagDR:%String,TDisposableFlag:%String,TChargeTypeDR:%String,TChargeType:%String,TBillItemNo:%String,TExpenseTypeDR:%String,TExpenseType:%String,TExpenseRate:%String,TPreWorkLoad:%String,TAdditionRate:%String,TTotalSpend:%String,TTotalFee:%String")
{
}

ClassMethod GetConsumableItemExecute(ByRef qHandle As %Binary, SourceType As %String = "", SourceID As %String = "") As %Status
{
	new repid,index,rowid
	set repid=$I(^CacheTemp)
	s TTotalSpend=""
	s qHandle=$lb(0,repid,0)
	i SourceType=""||SourceID="" Quit $$$OK
	i '$Data(^DHCEQConsumableItemInfo(0,"Scource",SourceType,SourceID)) Quit $$$OK
	s index=1	
	s rowid=0
	f  s rowid=$o(^DHCEQConsumableItemInfo(0,"Scource",SourceType,SourceID,rowid)) q:rowid=""  d
	.s ConsumableItemInfo=$g(^DHCEQConsumableItemInfo(rowid))
	.q:($P(ConsumableItemInfo,"^",16)="Y")
	.s TRowID=rowid
	.s TSourceType=$P(ConsumableItemInfo,"^",1)
	.s TSourceID=$P(ConsumableItemInfo,"^",2)
	.s TCode=$P(ConsumableItemInfo,"^",3)
	.s TDesc=$P(ConsumableItemInfo,"^",4)
	.s TModel=$P(ConsumableItemInfo,"^",5)
	.s TRegistrationNo=$P(ConsumableItemInfo,"^",6)
	.s TPrice=$P(ConsumableItemInfo,"^",7)
	.s TDisposableFlagDR=$P(ConsumableItemInfo,"^",8)
	.s TDisposableFlag=$CASE(TDisposableFlagDR,"":"","Y":"是","N":"否")
	.s TChargeTypeDR=$P(ConsumableItemInfo,"^",9)
	.s TChargeType=$CASE(TChargeTypeDR,"":"","0":"可单独收费","1":"在诊疗项目中打包收费","2":"纯消耗不可收费")
	.s TBillItemNo=$P(ConsumableItemInfo,"^",10)
	.s TExpenseTypeDR=$P(ConsumableItemInfo,"^",11)
	.s TExpenseType=$CASE(TExpenseTypeDR,"":"","0":"医保报销","1":"医保不报销","2":"医保部分报销")
	.s TExpenseRate=$P(ConsumableItemInfo,"^",12)
	.s TPreWorkLoad=$P(ConsumableItemInfo,"^",13)
	.s TAdditionRate=$P(ConsumableItemInfo,"^",14)
	.s TTotalSpend=TPreWorkLoad*TPrice
	.s TTotalFee=TPreWorkLoad*TPrice*TAdditionRate
	.d OutputRowGetConsumableItem
	Quit $$$OK
OutputRowGetConsumableItem
	s Data=$lb(TRowID,TSourceType,TSourceID,TCode,TDesc,TModel,TRegistrationNo,TPrice,TDisposableFlagDR,TDisposableFlag,TChargeTypeDR,TChargeType,TBillItemNo,TExpenseTypeDR,TExpenseType,TExpenseRate,TPreWorkLoad,TAdditionRate,TTotalSpend,TTotalFee)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetConsumableItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetConsumableItemExecute ]
{
	s repid=$LIST(qHandle,2)
	k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetConsumableItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetConsumableItemExecute ]
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

ClassMethod GetOneConsumableItem(CIIRowID, i)
{
	n rowid,result,node
	s rowid=0
	s SourceType=1
	s node=0
	f  s node=node+1 q:node>i  d
	.s rowid=$O(^DHCEQConsumableItem(0,"Source",SourceType,CIIRowID,rowid))
	if (rowid'="")
	{
		s result=$g(^DHCEQConsumableItem(rowid))
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
	;s RequestLoc=$P($g(^CTLOC(RequestLocDR)),"^",1)  //申请科室  //modify by jyp 2019-10-18 CTLOC调整
	s RequestLoc=##class(web.DHCEQCommon).GetTrakNameByID("deptcode",RequestLocDR)   //modify by jyp 2019-10-18 CTLOC调整
	s result=result_"^"_RequestLoc
	s EquipName=$P($g(^DHCEQBuyRequestList(BRLRowID)),"^",2)  //设备名称
	s result=result_"^"_EquipName
	q result
}

/// w ##Class(web.DHCEQConsumableItemInfo).GetConsumableItemFee(1,5)
ClassMethod GetConsumableItemFee(SourceType As %String = "", SourceID As %String = "")
{
	new ConsumableItemInfo,TTotalFee,AllTotalFee,rowid
	s (TTotalFee,AllTotalFee)=0
	i SourceType=""||SourceID="" Quit 0
	i '$Data(^DHCEQConsumableItemInfo(0,"Scource",SourceType,SourceID)) Quit 0
	s rowid=0
	f  s rowid=$o(^DHCEQConsumableItemInfo(0,"Scource",SourceType,SourceID,rowid)) q:rowid=""  d
	.s ConsumableItemInfo=$g(^DHCEQConsumableItemInfo(rowid))
	.q:($P(ConsumableItemInfo,"^",16)="Y")
	.s TPrice=$P(ConsumableItemInfo,"^",7)
	.s TPreWorkLoad=$P(ConsumableItemInfo,"^",13)
	.s TAdditionRate=$P(ConsumableItemInfo,"^",14)
	.s TTotalFee=TPrice*TPreWorkLoad*TAdditionRate
	.s AllTotalFee=AllTotalFee+TTotalFee
	
	q AllTotalFee
}

Storage Default
{
<Data name="DHCEQConsumableItemInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQConsumableItemInfoD</DataLocation>
<DefaultData>DHCEQConsumableItemInfoDefaultData</DefaultData>
<IdLocation>^web.DHCEQConsumableItemInfoD</IdLocation>
<IndexLocation>^web.DHCEQConsumableItemInfoI</IndexLocation>
<StreamLocation>^web.DHCEQConsumableItemInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
