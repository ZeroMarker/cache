/// Modified By HZY 2012-04-23 HZY0027.公司测试出的Bug.
/// Desc:将函数中的'401001'改为'301006'.(应取设置码为'301006'对应的系统设置信息.)
/// -------------------------------
/// 修改：zy 2009-11-20   ZY0017
/// 修改方法：GetInStockDetail,GetOneInStockDetail
/// 描述:增加了变动信息的打印导出功能
/// -------------------------------
/// 修改:ZY 2009-11-12  zy0016
/// 增加方法:UpdateData
/// 描述:机型,生产厂家,供应商的rowid在js中进行处理;
/// -------------------------------
/// 修改:ZY 2009-11-03 ZY0015
/// 修改Query方法:GetInStockDetail
/// 目的:查询包含设备分类子类的设备
/// 描述:增加参数IncludeFlag
/// 备注:IncludeFlag="off",不包含IncludeFlag子类，IncludeFlag="on",包含IncludeFlag子类，
/// ----------------------------------------------------
Class web.DHCEQInStockList Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 396;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ISL_RowID";

Parameter SQLDESCRIPTION = "ISL_RowID";

Parameter SQLROWID = "ISL_RowID";

Parameter GlobalLen = 23;

ClassMethod UpdateData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val, Type)
{
	//Type=1 删除
	//Type=0 插入、更新
	s RowID=$P(val,"^",1)
	s PLIST(2) = $p(val,"^",2)	;InStockDR
 	s PLIST(3) = $p(val,"^",3)	;EquipDR
 	s PLIST(4) = $p(val,"^",4)	;BatchFlag
 	i $p(val,"^",4)'=""  s PLIST(4) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",4),"bool")	;BatchFlag
 	s PLIST(5) = $p(val,"^",5)	;BuyPlanListDR
 	s PLIST(6) = $p(val,"^",6)	;EquipName
 	s PLIST(7) = $p(val,"^",7)	;ManuFactoryDR
 	s PLIST(8) = $p(val,"^",8)	;OriginalFee
 	//s Flag=..EquipIsAudit(PLIST(4),PLIST(8),PLIST(3))
 	//i Flag q Flag
 	s PLIST(9) = $p(val,"^",9)	;QuantityNum
 	s PLIST(10) = $p(val,"^",10)	;ModelDR
 	s PLIST(11) = $p(val,"^",11)	;UnitDR
 	s PLIST(12) = $p(val,"^",12)	;Hold1
 	s PLIST(13) = $p(val,"^",13)	;Remark
 	s PLIST(14) = $p(val,"^",14)    ;AppendFee 
 	s PLIST(15) = $p(val,"^",15)    ;EquipCatDR
 	s PLIST(16) = $p(val,"^",16)    ;LimitYearsNum
 	s PLIST(17) = $p(val,"^",17)    ;ItemDR
 	s InvoiceNos=$p(val,"^",18)
 	s InvoiceDate=$p(val,"^",19)
 	s InvoiceFee=$p(val,"^",20)
 	
 	//add by jdl 2009-04-13
 	s PLIST(18) = $p(val,"^",21)    ;StatCatDR
 	s PLIST(19) = $p(val,"^",22)    ;SourceType
 	s PLIST(20) = $p(val,"^",23)    ;SourceID
 	s PLIST(21) = $p(val,"^",24)    ;Hold2
 	s PLIST(22) = $p(val,"^",25)    ;Hold3
 	s PLIST(23) = $p(val,"^",26)    ;Hold3
 	s PLIST(24) = $p(val,"^",27)    ;Hold4
 	
 	//add by jdl 2009-10-29 JDL0037
 	i PLIST(19)=0    ;SourceType
 	{	s PLIST(4) = "N"	}	;BatchFlag
 	else
 	{	s PLIST(4) = "Y"	}	;BatchFlag
 	
	TSTART
	if +Type=0
	{
		///Modified By ZY ZY0016 2009-11-12  删除ModelDR的处理代码
		if RowID=""
		{
			&SQL(insert into sqluser.DHC_EQInStockList values :PLIST())
		}
		else
		{
			&SQL(update sqluser.DHC_EQInStockList values :PLIST() where ISL_RowID=:RowID)
		}
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		s ISLRowID=$G(%ROWID)
		s SQLCODE=..UpdateInvoiceInfo(ISLRowID, InvoiceNos, InvoiceDate, InvoiceFee)
 		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		s Total=..StockHaveEquip(PLIST(3),PLIST(2))
		i Total>0
		{
			
		}
		else
		{
			TROLLBACK
			q Total
		}
	}
	if +Type=1
	{
		&SQL(delete from sqluser.DHC_EQInStockList where ISL_RowID=:RowID)
	}
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	s ID=$G(%ROWID)
	TCOMMIT
	q ID
ERROR //2009-07-10 党军 begin
 	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK		       //回滚事务
 	Quit "<ERROR>"_ErrorMsg     //返回错误消息 ; //2009-07-10 党军 end
}

ClassMethod BillAuditUpdateOther(Val)
{
	new ISLRowID,ISRowID
	s ISLRowID=$P(Val,"^",1) //入库明细ID
	s EquipCatDR=$P(Val,"^",2) //设备分类ID
	s UseYearsNum=$P(Val,"^",3) //使用年限
	s Fee=$P(Val,"^",4) //设备原值
	s Invoice=$P(Val,"^",5) //发票号
	s InvoiceDate=$P(Val,"^",6) //开票日期
	s InvoiceFee=$P(Val,"^",7) //开票金额
	s AppendFee=$P(Val,"^",8) //附加费用
	s UpdAll=$P(Val,"^",9) //附加费用
	s BatchFlag=$P(^DHCEQInStockList(ISLRowID),"^",3)
	s EQPLIST(5)=EquipCatDR
	s EQPLIST(32)=UseYearsNum
	s EQPLIST(28)=Fee
	s EQPLIST(29)=Fee
	s EQPLIST(44)=AppendFee
	s ISLPLIST(15)=EquipCatDR
	s ISLPLIST(16)=UseYearsNum
	S ISLPLIST(8)=Fee
	s ISLPLIST(14)=AppendFee
	s ISRowID=$p(^DHCEQInStockList(ISLRowID),"^",1)
	TSTART
	&SQL(update sqluser.DHC_EQInStockList values ISLPLIST() where ISL_RowID=:ISLRowID)
	i SQLCODE=100 q -100
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	i UpdAll="Y"
	{
		s SQLCODE=..BillAuditUpdateInvoice(ISLRowID,Invoice,InvoiceDate,InvoiceFee)
	}
	else
	{
		s SQLCODE=..UpdateInvoiceInfo(ISLRowID,Invoice,InvoiceDate,InvoiceFee)
	}
	i SQLCODE=100 q -100
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	s EquipIsIn=##class(web.DHCEQInStock).EquipHasIn(ISRowID)
	i EquipIsIn="0"
	{
		s CSRowID=0
		s SQLCODE=0
		f  s CSRowID=$o(^DHCEQChangeStock(0,"Source",0,ISLRowID,CSRowID))  quit:(CSRowID="")||(SQLCODE'=0)  d
		.s EquipID=$P(^DHCEQChangeStock(CSRowID),"^",1)
		.&SQL(update sqluser.DHC_EQEquip values EQPLIST() where EQ_RowID=:EquipID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	TCOMMIT
	q ISLRowID
}

ClassMethod BillAuditUpdateInvoice(ISLRowID, Invoice, InvoiceDate, InvoiceFee)
{
	s ISID=$P(^DHCEQInStockList(ISLRowID),"^",1)
	s ISLID=0
	f  s ISLID=$o(^DHCEQInStockList(0,"InStock",ISID,ISLID)) q:(ISLID="")||(SQLCODE'=0)  d
	.s SQLCODE=..UpdateInvoiceInfo(ISLID,Invoice,InvoiceDate,InvoiceFee)
	i SQLCODE=100 q -100
	q SQLCODE
}

ClassMethod EquipIsAudit(BatchFlag, ValueFee, EquipID)
{
	new CHRowID,Flag
	s AuditFee=##class(web.DHCEQCommon).GetSysInfo(301003)
	q:(BatchFlag="Y")&&(ValueFee>AuditFee) -1002
	q:(BatchFlag="N")&&(EquipID="")&&(ValueFee>AuditFee) -1005
	if (BatchFlag="N")&&(EquipID'="")&&(ValueFee>AuditFee)
	{
		s Flag=##class(web.DHCEQCommon).GetSysInfo(301005)
		if (Flag=1)
		{
			s CHRowID=0
			s Flag=0
			f  s CHRowID=$O(^DHCEQCheck(0,"Equip",EquipID,CHRowID)) q:(CHRowID="")&&(Flag="1")  d
			.s Status=$p(^DHCEQCheck(CHRowID),"^",11)
			.i Status="2" s Flag="1"
			q:Flag="0" -1003 
		}
	}
	q 0
}

ClassMethod UpdateInvoiceInfo(ISLRowID, Invoice, InvoiceDate, InvoiceFee)
{
	new ISRowID,ProviderID,ISStatus,IUMRowID
	s ISRowID=$P(^DHCEQInStockList(ISLRowID),"^",1)
	s ProviderID=$P(^DHCEQInStock(ISRowID),"^",17)
	s ISStatus=$P(^DHCEQInStock(ISRowID),"^",10)
	s IUMRowID=$o(^DHCEQInvoiceUseMap(0,"Source","1",ISLRowID,0))
	s InvoiceDate=##Class(web.DHCEQCommon).TransValueFromPage(InvoiceDate,"date")
	s INPLIST(3)=Invoice
	s INPLIST(4)=InvoiceDate
	s INPLIST(5)=InvoiceFee
	s INPLIST(11)="0" //Status
	s INPLIST(6)=ProviderID
	i IUMRowID=""
	{
		i Invoice="" q 0
		s InvoiceID=$o(^DHCEQInvoice(0,"InvoiceNo",Invoice,0))
		i InvoiceID=""
		{
			i ISStatus="3" s INPLIST(11)="1"
			&SQL(insert into sqluser.DHC_EQInvoice values INPLIST())
			if SQLCODE
			{
				q SQLCODE
			}
			s InvoiceID=$G(%ROWID)
		}
		else
		{
			s Date=$p(^DHCEQInvoice(InvoiceID),"^",3)
			s Fee=$p(^DHCEQInvoice(InvoiceID),"^",4)
			s Status=$p(^DHCEQInvoice(InvoiceID),"^",10)
			q:(Date'=InvoiceDate)||(Fee'=InvoiceFee) -1001
			q:Status="2" -1004
		}
		s INMPLIST(2)=ISLRowID
		s INMPLIST(3)=InvoiceID
		s INMPLIST(4)="1"
		&SQL(insert into sqluser.DHC_EQInvoiceUseMap values INMPLIST())
		if SQLCODE
		{
			q SQLCODE
		}
	}
	else
	{
		s OldInvoiceDR=$P(^DHCEQInvoiceUseMap(IUMRowID),"^",2)
		i Invoice'=""
		{
			s NewInvoiceDR=$o(^DHCEQInvoice(0,"InvoiceNo",Invoice,0))
			i OldInvoiceDR=NewInvoiceDR q 0
			s OldInvoiceStatus=$p(^DHCEQInvoice(OldInvoiceDR),"^",10)
			q:OldInvoiceStatus="2" -1004
			s Total=..InvoiceUsedByOtherISLRowID(OldInvoiceDR)
			i Total=0
			{
				&SQL(delete from sqluser.DHC_EQInvoice where IV_RowID=:OldInvoiceDR)
				i SQLCODE
				{
					q SQLCODE
				}
			}
			i NewInvoiceDR'=""
			{
				s NewInvoiceStatus=$p(^DHCEQInvoice(NewInvoiceDR),"^",10)
				q:NewInvoiceStatus="2" -1004
				&SQL(update sqluser.DHC_EQInvoice values INPLIST() where IV_RowID=:NewInvoiceDR)
			}
			else
			{
				i ISStatus="3" s INPLIST(11)="1"
				&SQL(insert into sqluser.DHC_EQInvoice values INPLIST())
			}
			i SQLCODE
			{
				q SQLCODE
			}
			s NewInvoiceDR=$G(%ROWID)
			s INMPLIST(2)=ISLRowID
			s INMPLIST(3)=NewInvoiceDR
			s INMPLIST(4)="1"
			&SQL(update sqluser.DHC_EQInvoiceUseMap values INMPLIST() where IUM_RowID=:IUMRowID)
			if SQLCODE
			{
				q SQLCODE
			}
		}
		else
		{
			s Total=..InvoiceUsedByOtherISLRowID(OldInvoiceDR)
			i Total=1
			{
				&SQL(delete from sqluser.DHC_EQInvoice where IV_RowID=:OldInvoiceDR)
				i SQLCODE
				{
					q SQLCODE
				}
			}
			&SQL(delete from sqluser.DHC_EQInvoiceUseMap where IUM_RowID=:IUMRowID)
		}
		if SQLCODE
		{
			q SQLCODE
		}
	}
	q 0
}

ClassMethod InvoiceUsedByOtherISLRowID(InvoiceDR)
{
	s UIMRowID=0,Total=0
	f  s UIMRowID=$O(^DHCEQInvoiceUseMap(0,"Invoice","1",InvoiceDR,UIMRowID)) q:UIMRowID=""  d
	.s Total=Total+1
	q Total
}

ClassMethod StockHaveEquip(EquipDR, ISRowID)
{
	s (Total,Total2)=0
	&SQL(select COUNT(ISL_RowID) into :Total from sqluser.DHC_EQInStockList where ISL_EquipDR=:EquipDR and ISL_InStockDR->IS_Status>=2)
	&SQL(select COUNT(ISL_RowID) into :Total2 from sqluser.DHC_EQInStockList where ISL_EquipDR=:EquipDR and ISL_InStockDR=:ISRowID)
	i Total2>1 q -1006	;"本单据已经录入该设备"
	i Total>0 q -1007	;"设备已经审核入库"
	q ISRowID
}

ClassMethod GetStatus(ISRowID)
{
	i ISRowID="" q ""
	q $P($G(^DHCEQInStock(ISRowID)),"^",10)
}

ClassMethod GetOneInStockList(rowid)
{
	new result,resultex,StatCatDR
	s (result,resultex,return,StatCat,StatCatDR)=""
	s result= ^DHCEQInStockList(rowid)
	set count=..#GlobalLen-$l(result,"^")
	for i=count:-1:1 { s result=result_"^"}
	s resultex=resultex_"^"	;InStockDR
	s resultex=resultex_"^"	;EquipDR
	s $p(result,"^",3)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",3),"bool")	;BatchFlag
	s resultex=resultex_"^"	;BuyPlanListDR
	s resultex=resultex_"^"	;ManuFactoryDR
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$p(result,"^",6))	//$p($g(^DHCEQCCode("DHCEQCManufacturer",$p(result,"^",6))),"^",1)
	s resultex=resultex_"^"	;ModelDR
	i $p(result,"^",9)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCModel",$p(result,"^",9))),"^",2)
	s resultex=resultex_"^"	;UnitDR
	i $p(result,"^",10)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("uom",$p(result,"^",10))
	s resultex=resultex_"^"	;EquipCatDR
	i $p(result,"^",14)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCEquipeCat",$p(result,"^",14))),"^",2)
	s return=##Class(web.DHCEQInvoice).GetInvoiceInfos(1,rowid)
	
	i $p(result,"^",16)'="" d
	.s StatCatDR=$P(^DHCEQCCode("DHCEQCMasterItem",$p(result,"^",16)),"^",5)
	i $p(result,"^",2)'="" d
	.s StatCatDR=$P(^DHCEQEquip($p(result,"^",2)),"^",75)
	
	; Modified by Jdl 2009-04-13 入库明细增加设备类型、来源类型、来源ID、保留字段
	s StatCatDR=$p(result,"^",17)
	s SourceType=$p(result,"^",18)
	s SourceID=$p(result,"^",19)
	s Hold2=$p(result,"^",20)
	s Hold3=$p(result,"^",21)
	s Hold4=$p(result,"^",22)
	s Hold5=$p(result,"^",23)
	
	i StatCatDR'="" d
	.s StatCat=$P(^DHCEQCCode("DHCEQCStatCat",StatCatDR),"^",2)
	s Flag="1"
	i $p(result,"^",4)'="" s Flag="0"
	i $p(result,"^",2)'="" s Flag="0"
	s hold1desc=$p(result,"^",11)
	if hold1desc'="" s hold1desc=$P($g(^DHCEQCCode("DHCEQCTechLevel",hold1desc)),"^",2)
	
	//add by jdl 2009-9-25  JDL0036
	//格式化金额为小数点两位
	i $p(result,"^",7)'="" s $p(result,"^",7)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",7),"",2)	;OriginalFee
	i $p(result,"^",13)'="" s $p(result,"^",13)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",13),"",2)	;AppendFee
	
	q result_resultex_"^"_return_"^"_Flag_"^"_StatCat_"^"_hold1desc_"^"_StatCatDR_"^"_SourceType_"^"_SourceID_"^"_Hold2_"^"_Hold3_"^"_Hold4_"^"_Hold5
}

/*
ClassMethod GetInvoiceInfo(ISLRowID)
{
	new Invoice,InvoiceDate,InvoiceFee,InvoiceDR
	s (Invoice,InvoiceDate,InvoiceFee,InvoiceDR)=""
	s IUMRowID=$o(^DHCEQInvoiceUseMap(0,"Source","1",ISLRowID,0))
	i IUMRowID'=""
	{
		s InvoiceDR=$p(^DHCEQInvoiceUseMap(IUMRowID),"^",2)
		i InvoiceDR'=""
		{
			s Invoice=..GetOneInvoice(InvoiceDR,1)
			s InvoiceDate=..GetOneInvoice(InvoiceDR,2)
			s InvoiceFee=..GetOneInvoice(InvoiceDR,3)
			
		}
	}
	q Invoice_"^"_InvoiceDate_"^"_InvoiceFee
}
*/
ClassMethod GetOneInvoice(InvoiceDR, Type)
{
	i InvoiceDR="" q ""
	i Type="1" q $P(^DHCEQInvoice(InvoiceDR),"^",2)
	i Type="2"
	{
		s InvoiceDate=$P(^DHCEQInvoice(InvoiceDR),"^",3)
		i InvoiceDate'="" s InvoiceDate=##Class(web.DHCEQCommon).TransValueToPage(InvoiceDate,"date")
		q InvoiceDate
	}
	i Type="3" q $P(^DHCEQInvoice(InvoiceDR),"^",4)
}

ClassMethod GetBachFlag(RowID)
{
	i RowID="" q 0
	q $P(^DHCEQInStockList(RowID),"^",3)
}

ClassMethod GetArriveNum(BPLID)
{
	s ExecNum=$p(^DHCEQBuyPlanList(BPLID),"^",11)
	s ArriveNum=$p(^DHCEQBuyPlanList(BPLID),"^",17)
	i ExecNum="" s ExecNum=0
	i ArriveNum="" s ArriveNum=0
	q ExecNum-ArriveNum
}

Query GetInStockList(InStockDR) As %Query(ROWSPEC = "TStatCat:%String,TItemDR:%String,TTotal:%String,TInvoiceNos:%String,TInvoiceDate:%String,TInvoiceFee:%String,TRowID:%String,TInStockDR:%String,TEquipDR:%String,TBatchFlag:%String,TBuyPlanListDR:%String,TEquipName:%String,TManuFactoryDR:%String,TOriginalFee:%String,TQuantityNum:%String,TModelDR:%String,TUnitDR:%String,THold1:%String,TRemark:%String,TAppendFee:%String,TEquipCatDR:%String,TLimitYearsNum:%String,TInStock:%String,TEquip:%String,TBuyPlanList:%String,TManuFactory:%String,TModel:%String,TUnit:%String,TEquipCat:%String,TMaxInStockNum:%String,TSourceType:%String,TSourceID:%String")
{
}

ClassMethod GetInStockListExecute(ByRef qHandle As %Binary, InStockDR) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	
	; Modified by Jdl 2009-04-13 修改入库明细显示合计处理
	new TotalFlag,TotalQty,TotalFee,TotalLoc
	s (TotalQty,TotalFee,TotalLoc)=0
	s TotalFlag=##class(web.DHCEQCommon).GetSysInfo("301006")
	i TotalFlag="1"  s index=2
	
	d BuildDataGetInStockList
	Quit $$$OK
BuildDataGetInStockList
	Q:InStockDR=""
	f  s rowid=$o(^DHCEQInStockList(0,"InStock",InStockDR,rowid))  quit:rowid=""  d
	.d ResetVariablesGetInStockList
	.s TRowID = rowid
	.s TInStockDR = $p($g(^DHCEQInStockList(rowid)),"^",1)
	.s TEquipDR = $p($g(^DHCEQInStockList(rowid)),"^",2)
	.i TEquipDR '=""  d
	..s TStockStatus = $p($g(^DHCEQEquip(TEquipDR)),"^",60)
	.s TBatchFlag = $p($g(^DHCEQInStockList(rowid)),"^",3)
	.s TBuyPlanListDR = $p($g(^DHCEQInStockList(rowid)),"^",4)
	.i TBuyPlanListDR'="" s TMaxInStockNum=..GetArriveNum(TBuyPlanListDR)
	.s TEquipName = $p($g(^DHCEQInStockList(rowid)),"^",5)
	.s TManuFactoryDR = $p($g(^DHCEQInStockList(rowid)),"^",6)
	.i TManuFactoryDR '=""  d
	..s TManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR) //$p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1) //CZF0093
	.s TOriginalFee = $p($g(^DHCEQInStockList(rowid)),"^",7)
	.s TQuantityNum = $p($g(^DHCEQInStockList(rowid)),"^",8)
	.s TTotal=TOriginalFee*TQuantityNum
	.
	.s TotalQty=TotalQty+TQuantityNum
	.s TotalFee=TotalFee+TTotal
	.
	.s TModelDR = $p($g(^DHCEQInStockList(rowid)),"^",9)
	.i TModelDR '=""  d
	..s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.s TUnitDR = $p($g(^DHCEQInStockList(rowid)),"^",10)
	.i TUnitDR '=""  d
	..s TUnit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",(TUnitDR))
	.s TQuantityNum=TQuantityNum_" "_TUnit
	.s THold1 = $p($g(^DHCEQInStockList(rowid)),"^",11)
	.s TRemark = $p($g(^DHCEQInStockList(rowid)),"^",12)
	.s TAppendFee = $p($g(^DHCEQInStockList(rowid)),"^",13)
	.s TEquipCatDR = $p($g(^DHCEQInStockList(rowid)),"^",14)
	.i TEquipCatDR '=""  d
	..s TEquipCat = $p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",2)
	.s TLimitYearsNum = $p($g(^DHCEQInStockList(rowid)),"^",15)
	.s TItemDR=$p($g(^DHCEQInStockList(rowid)),"^",16)
	.i TItemDR'="" d
	..s TStatCatDR=$P(^DHCEQCCode("DHCEQCMasterItem",TItemDR),"^",5)
	.i TEquipDR'="" d
	..s TStatCatDR=$P(^DHCEQEquip(TEquipDR),"^",75)
	.
	.; Modified by Jdl 2009-04-13 入库明细增加设备类型、来源类型、来源ID、保留字段
	.s TStatCatDR=$p($g(^DHCEQInStockList(rowid)),"^",17)
	.s TSourceType=$p($g(^DHCEQInStockList(rowid)),"^",18)
	.s TSourceID=$p($g(^DHCEQInStockList(rowid)),"^",19)
	.s THold2=$p($g(^DHCEQInStockList(rowid)),"^",20)
	.s THold3=$p($g(^DHCEQInStockList(rowid)),"^",21)
	.s THold4=$p($g(^DHCEQInStockList(rowid)),"^",22)
	.s THold5=$p($g(^DHCEQInStockList(rowid)),"^",23)
	.
	.i TStatCatDR'="" d
	..s TStatCat=$P(^DHCEQCCode("DHCEQCStatCat",TStatCatDR),"^",2)
	.s return=##Class(web.DHCEQInvoice).GetInvoiceInfos(1,rowid)
	.s TInvoiceNos=$p(return,"^",1)
	.s TInvoiceDate=$p(return,"^",2)
	.s TInvoiceFee=$p(return,"^",3)
	.d OutputRowGetInStockList
	
	; Modified by Jdl 2009-04-13 修改入库明细显示合计处理
	; Mozy 2009-03-26 金额合计
	i TotalFlag="1" s TotalLoc=1
	i TotalFlag="2" s TotalLoc=index+1
	i TotalLoc'=0
	{
		d ResetVariablesGetInStockList
		s TEquipName="合计:"
		s TQuantityNum=TotalQty
		s TTotal=TotalFee
		s index=TotalLoc
		d OutputRowGetInStockList
	}
		
	quit
OutputRowGetInStockList
	//add by jdl 2009-9-25  JDL0036
	//格式化金额为小数点两位
	i TOriginalFee'="" s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"",2)
	i TAppendFee'="" s TAppendFee=##Class(web.DHCEQCommon).FormatNumber(TAppendFee,"",2)
	i TTotal'="" s TTotal=##Class(web.DHCEQCommon).FormatNumber(TTotal,"",2)
	
	
	s Data=$lb(TStatCat,TItemDR,TTotal,TInvoiceNos,TInvoiceDate,TInvoiceFee,TRowID,TInStockDR,TEquipDR,TBatchFlag,TBuyPlanListDR,TEquipName,TManuFactoryDR,TOriginalFee,TQuantityNum,TModelDR,TUnitDR,THold1,TRemark,TAppendFee,TEquipCatDR,TLimitYearsNum,TInStock,TEquip,TBuyPlanList,TManuFactory,TModel,TUnit,TEquipCat,TMaxInStockNum,TSourceType,TSourceID)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetInStockList
	s (TStatCatDR,TStatCat,TItemDR,TTotal,TInvoiceNos,TInvoiceDate,TInvoiceFee,TRowID,TInStockDR,TEquipDR,TBatchFlag,TBuyPlanListDR,TEquipName,TManuFactoryDR,TOriginalFee,TQuantityNum,TModelDR,TUnitDR,THold1,TRemark,TAppendFee,TEquipCatDR,TLimitYearsNum,TInStock,TEquip,TBuyPlanList,TManuFactory,TModel,TUnit,TEquipCat,TMaxInStockNum,TSourceType,TSourceID)=""
	quit
}

ClassMethod GetInStockListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInStockListExecute ]
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

ClassMethod GetInStockListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInStockListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// DJType=1为入库
Query GetEquip(StatCatDR, EquipTypeDR, Equip, StockStatus, StockDR, DJType, OutTypeDR As %String = "", EQStatus As %String = "", ProviderDR As %String = "") As %Query(ROWSPEC = "Name:%String,HIDDEN:%String,EquipNo:%String,Model:%String,LeaveFactoryNo:%String")
{
}

ClassMethod GetEquipClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

// vEquipName As %String = "", vEquipNo As %String = "", vModelDR As %String = "", vManageLocDR As %String = "", vUseLocDR As %String = "", vStatus As %String = "", vLeaveFactoryNo As %String = ""

ClassMethod GetEquipExecute(ByRef qHandle As %Binary, StatCatDR, EquipTypeDR, Equip, StockStatus, StockDR, DJType, OutTypeDR As %String = "", EQStatus As %String = "", ProviderDR As %String = "") As %Status
{
 	new repid, index,rowid,Flag,ISLRowID,ISRowID,StockStatu,EqStatus
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set Equip=$ZCONVERT(Equip,"U")
	s index=1
	s rowid=0
	d BuildDataGetEquip
	Quit $$$OK
BuildDataGetEquip
	i +DJType=1
	{
		f  s rowid=$o(^DHCEQEquip(0,"StockStatus",StockStatus,rowid)) q:rowid=""  d
		.d ResetVariablesGetEquip
		.d GetOneEquipData
	}
	else
	{
		q:StockDR=""
		f  s rowid=$o(^DHCEQEquip(0,"StoreEquipType","N",StockStatus,StockDR,EquipTypeDR,rowid)) q:rowid=""  d
		.s TStatCatID=$p($g(^DHCEQEquip(rowid)),"^",75)
		.q:(TStatCatID'="")&&(StatCatDR'="")&&(TStatCatID'=StatCatDR)
		.s TEquipTypeID=$p($g(^DHCEQEquip(rowid)),"^",63)
		.q:(TEquipTypeID'="")&&(EquipTypeDR'="")&&(TEquipTypeID'=EquipTypeDR)
		.d ResetVariablesGetEquip
		.d GetOneEquipData
	}
	quit
GetOneEquipData
	s RowID = rowid
	s Flag="N"
	s ISLRowID=$p($g(^DHCEQEquip(rowid)),"^",70)
	i ISLRowID'="" d
	.s ISRowID=$p($g(^DHCEQInStockList(ISLRowID)),"^",1)
	.s StockStatu=$p($g(^DHCEQInStock(ISRowID)),"^",10)
	.i StockStatu'="3" s Flag="Y"
	q:(Flag="Y")&&(DJType'="1")
	s Name = $ZCONVERT($p($g(^DHCEQEquip(rowid)),"^",1),"U")
	s Code = $ZCONVERT($p($g(^DHCEQEquip(rowid)),"^",6),"U")
	s EquipNo=$p($g(^DHCEQEquip(rowid)),"^",71)
	s ModelDR=$p($g(^DHCEQEquip(rowid)),"^",3)
	i ModelDR'="" s Model=$p(^DHCEQCCode("DHCEQCModel",ModelDR),"^",2)
	s LeaveFactoryNo = $ZCONVERT($p($g(^DHCEQEquip(rowid)),"^",10),"U")
	s TStatCatDR=$p($g(^DHCEQEquip(rowid)),"^",75)
	q:(DJType'="1")&&(TStatCatDR="")
	q:(TStatCatDR'="")&&(TStatCatDR'=StatCatDR)&&(StatCatDR'="")
	q:(Equip'="")&&((Name'[Equip)&(LeaveFactoryNo'[Equip)&(RowID'[Equip)&(Code'[Equip))     ;&(Model'[Equip)&(UseLoc'[Equip))
	s EqStatus=$p($g(^DHCEQEquip(rowid)),"^",38)
	q:(OutTypeDR=2)&&(EqStatus'=3)	//报废设备处理要选择报废设备
	;q:(OutTypeDR'=2)&&(EqStatus=3)	///其他要选择非报废设备
	//s TStatus=
	q:(EQStatus'="")&&(EQStatus'=EqStatus)
	q:(EQStatus="")&&(OutTypeDR'=2)&&(EqStatus=3)	///其他要选择非报废设备
	
	s Provider=$p($g(^DHCEQEquip(rowid)),"^",25)
 	q:(ProviderDR'="")&&(Provider'=ProviderDR)
 	s EquipType=$p($g(^DHCEQEquip(rowid)),"^",63)
 	q:(EquipTypeDR'="")&&(EquipType'=EquipTypeDR)
 
	d OutputRowGetEquip
	quit
OutputRowGetEquip
	s Data=$lb(Name,RowID,EquipNo,Model,LeaveFactoryNo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetEquip
	s (Name,RowID,EquipNo,Model,LeaveFactoryNo,Code)=""
	quit
}

ClassMethod GetEquipFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipExecute ]
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

ClassMethod GetInstockEquipType(InStockDR, Type)
{
	i InStockDR="" q ""
	
	s EquipTypeDR=$P($G(^DHCEQInStock(InStockDR)),"^",19+Type)
	
	q EquipTypeDR
}

ClassMethod GetOtherData(RowID, Type)
{
	i RowID="" q ""
	s (StatCat,StatCatDR,ItemDR,Model,ModelDR,ManuFactory,ManuFactoryDR,Unit,UnitDR,AppendFee,EquipCatDR,EquipCat,UseYearsNum)=""
	s (Quantity,Fee)=""
	if Type="1" //批量验收
	{
		//modified by jdl 2009-10-29 JDL0037
		/*
		s ModelDR=$p(^DHCEQBuyPlanList(RowID),"^",3)
		i ModelDR'="" s Model=$p(^DHCEQCCode("DHCEQCModel",ModelDR),"^",2)
		s ManuFactoryDR=$p(^DHCEQBuyPlanList(RowID),"^",4)
		i ManuFactoryDR'="" s ManuFactory=$p(^DHCEQCCode("DHCEQCManufacturer",ManuFactoryDR),"^",1)
		s ExecNum=$p(^DHCEQBuyPlanList(RowID),"^",11)
		s ArriveNum=$p(^DHCEQBuyPlanList(RowID),"^",17)
		s Quantity=ExecNum-ArriveNum
		s Fee=$p(^DHCEQBuyPlanList(RowID),"^",6)
		s ItemDR=$p(^DHCEQBuyPlanList(RowID),"^",18)
		i ItemDR'="" d
		.s UnitDR=$P(^DHCEQCCode("DHCEQCMasterItem",ItemDR),"^",7)
		.s StatCatDR=$P(^DHCEQCCode("DHCEQCMasterItem",ItemDR),"^",5)
		.i StatCatDR'="" d
		..s StatCat=$P(^DHCEQCCode("DHCEQCStatCat",StatCatDR),"^",2)
		s Unit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",UnitDR)
		s EquipCatDR=$p(^DHCEQBuyPlanList(RowID),"^",16)
		i (EquipCatDR="")&&(ItemDR'="") s EquipCatDR=$P(^DHCEQCCode("DHCEQCMasterItem",ItemDR),"^",4)
		i EquipCatDR'=""
		{
			s EquipCat=$P(^DHCEQCCode("DHCEQCEquipeCat",EquipCatDR),"^",2)
			s UseYearsNum=$P(^DHCEQCCode("DHCEQCEquipeCat",EquipCatDR),"^",6)
		}
		*/
		s OCLRowID=RowID
		s ModelDR=$p(^DHCEQOpenCheckList(OCLRowID),"^",5)
		i ModelDR'="" s Model=$p(^DHCEQCCode("DHCEQCModel",ModelDR),"^",2)
		s ManuFactoryDR=$p(^DHCEQOpenCheckList(OCLRowID),"^",15)
		i ManuFactoryDR'="" s ManuFactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",ManuFactoryDR) //$p(^DHCEQCCode("DHCEQCManufacturer",ManuFactoryDR),"^",1) //CZF0093
		s Quantity=$p(^DHCEQOpenCheckList(OCLRowID),"^",16)
		s Quantity=+##Class(web.DHCEQInStock).GetOpenCheckCountInfo(OCLRowID)
		s Fee=$p(^DHCEQOpenCheckList(OCLRowID),"^",17)
		s ItemDR=$p(^DHCEQOpenCheckList(OCLRowID),"^",9)
		s UnitDR=$p(^DHCEQOpenCheckList(OCLRowID),"^",7)
		s Unit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",UnitDR)
		s EquipCatDR=$p(^DHCEQOpenCheckList(OCLRowID),"^",6)
		i EquipCatDR'="" d
		.s EquipCat=$P(^DHCEQCCode("DHCEQCEquipeCat",EquipCatDR),"^",2)
		.s UseYearsNum=##class(web.DHCEQInStockList).GetUseYearsByCat(EquipCatDR)
		s StatCatDR=$p(^DHCEQOpenCheckList(OCLRowID),"^",28)
		i StatCatDR'="" s StatCat=$P(^DHCEQCCode("DHCEQCStatCat",StatCatDR),"^",2)		
		
	}
	elseif Type="2" ///设备
	{
		s StatCatDR=$P(^DHCEQEquip(RowID),"^",75)
		i StatCatDR'="" d
		.s StatCat=$P(^DHCEQCCode("DHCEQCStatCat",StatCatDR),"^",2)
		s ModelDR=$p(^DHCEQEquip(RowID),"^",3)
		i ModelDR'="" s Model=$p(^DHCEQCCode("DHCEQCModel",ModelDR),"^",2)
		s ManuFactoryDR=$p(^DHCEQEquip(RowID),"^",26)
		i ManuFactoryDR'="" s ManuFactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",ManuFactoryDR) //$p(^DHCEQCCode("DHCEQCManufacturer",ManuFactoryDR),"^",1)//CZF0093
		s UnitDR=$p(^DHCEQEquip(RowID),"^",5)
		s Quantity=1
		s Fee=$p(^DHCEQEquip(RowID),"^",27)
		s AppendFee=$p(^DHCEQEquip(RowID),"^",43)
		s EquipCatDR=$p(^DHCEQEquip(RowID),"^",4)
		s UseYearsNum=$p(^DHCEQEquip(RowID),"^",31)
		s ItemDR=$p(^DHCEQEquip(RowID),"^",7)
		i (UnitDR="")&&(ItemDR'="") s UnitDR=$P(^DHCEQCCode("DHCEQCMasterItem",ItemDR),"^",7)
		s Unit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",UnitDR)
		i (EquipCatDR="")&&(ItemDR'="") s EquipCatDR=$P(^DHCEQCCode("DHCEQCMasterItem",ItemDR),"^",4)
		i EquipCatDR'=""
		{
			s EquipCat=$P(^DHCEQCCode("DHCEQCEquipeCat",EquipCatDR),"^",2)
			i UseYearsNum="" s UseYearsNum=..GetYearsByEquipCat(EquipCatDR)
			//i UseYearsNum="" s UseYearsNum=$P(^DHCEQCCode("DHCEQCEquipeCat",EquipCatDR),"^",6)
		}
	}
	else
	{
		s ItemDR=RowID
		s StatCatDR=$P(^DHCEQCCode("DHCEQCMasterItem",ItemDR),"^",5)
		i StatCatDR'="" d
		.s StatCat=$P(^DHCEQCCode("DHCEQCStatCat",StatCatDR),"^",2)
		s UnitDR=$P(^DHCEQCCode("DHCEQCMasterItem",ItemDR),"^",7)
		s Unit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",UnitDR)
		s EquipCatDR=$P(^DHCEQCCode("DHCEQCMasterItem",ItemDR),"^",4)
		s Quantity=1
		i EquipCatDR'=""
		{
			s EquipCat=$P(^DHCEQCCode("DHCEQCEquipeCat",EquipCatDR),"^",2)
			i UseYearsNum="" s UseYearsNum=..GetYearsByEquipCat(EquipCatDR)
		}
		
		s ModelDR=..GetModelByItem(ItemDR,1)
		s Model=..GetModelByItem(ItemDR,2)
		s UseYearsNum=""
		i UseYearsNum=""  s UseYearsNum=..GetLimitYearsNum(ItemDR)
	}
	q ModelDR_"^"_Model_"^"_ManuFactoryDR_"^"_ManuFactory_"^"_UnitDR_"^"_Unit_"^"_Quantity_"^"_Fee_"^"_AppendFee_"^"_EquipCatDR_"^"_EquipCat_"^"_UseYearsNum_"^"_ItemDR_"^"_StatCat_"^"_StatCatDR_"^"_RowID
}

/// 根据设备项获取相应的使用年限
ClassMethod GetLimitYearsNum(MastItemID)
{
	new YearsNum
	new EquipCatDR
	i MastItemID="" q ""
	s EquipCatDR=$P(^DHCEQCCode("DHCEQCMasterItem",MastItemID),"^",4)
	s YearsNum=..GetYearsByEquipCat(EquipCatDR)
	i YearsNum=""
	{
		s StatCatDR=$P(^DHCEQCCode("DHCEQCMasterItem",MastItemID),"^",5)
		s YearsNum=$P(^DHCEQCCode("DHCEQCStatCat",StatCatDR),"^",3)
		i YearsNum'="" s YearsNum=##Class(web.DHCEQCommon).Trim(YearsNum)
	}
	i YearsNum=$C(0) s YearsNum=""
	q YearsNum
}

/// 根据分类获取使用年限
ClassMethod GetYearsByEquipCat(EquipCatID)
{
	new YearsNum
	i EquipCatID="" q ""
	s YearsNum=$P(^DHCEQCCode("DHCEQCEquipeCat",EquipCatID),"^",6)
	i YearsNum=""
	{
		s EquipCatID=$P(^DHCEQCCode("DHCEQCEquipeCat",EquipCatID),"^",4)
		s YearsNum=..GetYearsByEquipCat(EquipCatID)
	}
	q YearsNum
}

ClassMethod GetModelByItem(ItemID, Type)
{
	s (ModelDR,Model)=""
	s rowid=0
	s i=0
	f  s rowid=$O(^DHCEQCCode("DHCEQCModel",0,"MItemDR",ItemDR,rowid)) q:rowid=""  d
	.s i=i+1
	.s ModelDR=rowid
	.s Model=$P(^DHCEQCCode("DHCEQCModel",rowid),"^",2)
	i i=1
	{
		i Type=1 q ModelDR
		i Type=2 q Model
	}
	q ""
}

Query GetInvoice(InvoiceNos, StatusDR, ProviderDR, StartDate, EndDate, InvoiceDR) As %Query(ROWSPEC = "TISLTotal:%String,TInStockNo:%String,TInvoiceDR:%String,TUseMapDR:%String,TInStockListDR:%String,TInStockDR:%String,TInStoreLocDR:%String,TInStoreLoc:%String,TInDate:%String,TEquipName:%String,TModelDR:%String,TModel:%String,TManuFactoryDR:%String,TManuFactory:%String,TBatchFlag:%String,TEquipCatDR:%String,TEquipCat:%String,TQuantityNum:%String,TUnitDR:%String,TUnit:%String,TOriginalFee:%String,TAppendFee:%String,TInvoiceNos:%String,TInvoiceDate:%String,TInvoiceFee:%String,TProviderDR:%String,TProvider:%String,TStatus:%String,TTotalFee:%String,TStatusDR:%String,TInStockStatu:%String")
{
}

ClassMethod GetInvoiceExecute(ByRef qHandle As %Binary, InvoiceNos, StatusDR, ProviderDR, StartDate, EndDate, InvoiceDR) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetInvoice
	Quit $$$OK
BuildDataGetInvoice
	/*i InvoiceNos'=""
	{
		f  s rowid=$o(^DHCEQInvoice(0,"InvoiceNo",InvoiceNos,rowid)) q:rowid=""  d
		.d ResetVariablesGetInvoice
		.d GetOneInvoice
	}
	else
	{*/
	i InvoiceDR'=""
	{
		s rowid=InvoiceDR
		d ResetVariablesGetInvoice
		d GetOneInvoice
		Quit
	}
		i (StatusDR'="")&&(ProviderDR'="")
		{
			f  s rowid=$o(^DHCEQInvoice(0,"StatusProvider",StatusDR,ProviderDR,rowid)) q:rowid=""  d
			.d ResetVariablesGetInvoice
			.d GetOneInvoice
		}
		i (StatusDR'="")&&(ProviderDR="")
		{
			s Provider=0
			f  s Provider=$o(^DHCEQInvoice(0,"StatusProvider",StatusDR,Provider)) q:Provider=""  d
			.s rowid=0
			.f  s rowid=$o(^DHCEQInvoice(0,"StatusProvider",StatusDR,Provider,rowid)) q:rowid=""  d
			..d ResetVariablesGetInvoice
			..d GetOneInvoice
		}
		i (StatusDR="")&&(ProviderDR'="")
		{
			f  s rowid=$O(^DHCEQInvoice(0,"Provider",ProviderDR,rowid)) q:rowid=""  d
			.d ResetVariablesGetInvoice
			.d GetOneInvoice
		}
		i (StatusDR="")&&(ProviderDR="")
		{
			f  s rowid=$O(^DHCEQInvoice(rowid)) q:rowid=""  d
			.d ResetVariablesGetInvoice
			.d GetOneInvoice
		}
	//}
	Quit
GetOneInvoice
	s TInvoiceDR=rowid
	s TUseMapDR=0
	f  s TUseMapDR=$o(^DHCEQInvoiceUseMap(0,"Invoice","1",TInvoiceDR,TUseMapDR)) q:TUseMapDR=""  d
	.d GetOneInStock
	Quit
GetOneInStock
	q:TUseMapDR=""
	s TInStockListDR=$P(^DHCEQInvoiceUseMap(TUseMapDR),"^",1)
	q:TInStockListDR=""
	s TInStockDR=$P(^DHCEQInStockList(TInStockListDR),"^",1)
	s TEquipTypeDR=$p($g(^DHCEQInStock(TInStockDR)),"^",20)
	q:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	s TInStockStatu=$P(^DHCEQInStock(TInStockDR),"^",10)
	s TInStockStatu=##class(web.DHCEQInStock).GetInStockStatus(TInStockStatu)
	s TInStockNo=$P(^DHCEQInStock(TInStockDR),"^",14)
	s TInStoreLocDR=$P(^DHCEQInStock(TInStockDR),"^",2)
	s TInStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TInStoreLocDR)
	s TInDate=$P(^DHCEQInStock(TInStockDR),"^",5)
	i StartDate="" s StartDate=0
	i EndDate="" s EndDate=+$h
	q:(TInDate>EndDate)||(TInDate<StartDate)
	s TInDate=##Class(web.DHCEQCommon).TransValueToPage(TInDate,"date")
	s TEquipName=$P(^DHCEQInStockList(TInStockListDR),"^",5)
	s TModelDR=$P(^DHCEQInStockList(TInStockListDR),"^",9)
	i TModelDR'="" s TModel=$P(^DHCEQCCode("DHCEQCModel",TModelDR),"^",2)
	s TManuFactoryDR=$P(^DHCEQInStockList(TInStockListDR),"^",6)
	i TManuFactoryDR'="" s TManuFactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR) //$P(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR),"^",1) //CZF0093
	s TBatchFlag=$P(^DHCEQInStockList(TInStockListDR),"^",3)
	s TEquipCatDR=$P(^DHCEQInStockList(TInStockListDR),"^",14)
	i TEquipCatDR'="" s TEquipCat=$P(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR),"^",2)
	s TQuantityNum=$P(^DHCEQInStockList(TInStockListDR),"^",8)
	s TUnitDR=$P(^DHCEQInStockList(TInStockListDR),"^",10)
	i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	s TOriginalFee=$P(^DHCEQInStockList(TInStockListDR),"^",7)
	s TTotalFee=TOriginalFee*TQuantityNum
	s TQuantityNum=TQuantityNum_" "_TUnit
	s TAppendFee=$P(^DHCEQInStockList(TInStockListDR),"^",13)
	s TInvoiceNos=$P(^DHCEQInvoice(TInvoiceDR),"^",2)
	q:(InvoiceNos'="")&&(TInvoiceNos'[InvoiceNos)
	s TInvoiceDate=$P(^DHCEQInvoice(TInvoiceDR),"^",3)
	s TInvoiceDate=##Class(web.DHCEQCommon).TransValueToPage(TInvoiceDate,"date")
	s TInvoiceFee=$P(^DHCEQInvoice(TInvoiceDR),"^",4)
	s TISLTotal=..InvoiceUsedByOtherISLRowID(TInvoiceDR)
	s TProviderDR=$P(^DHCEQInvoice(TInvoiceDR),"^",5)
	q:(ProviderDR'="")&&(ProviderDR'=TProviderDR)
	i TProviderDR'="" s TProvider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	s TStatusDR=$P(^DHCEQInvoice(TInvoiceDR),"^",10)
	q:(StatusDR'="")&&(StatusDR'=TStatusDR)
	s TStatus=..GetInvoiceStatu(TStatusDR)
	d OutputRowGetInvoice
	quit
OutputRowGetInvoice
	s Data=$lb(TISLTotal,TInStockNo,TInvoiceDR,TUseMapDR,TInStockListDR,TInStockDR,TInStoreLocDR,TInStoreLoc,TInDate,TEquipName,TModelDR,TModel,TManuFactoryDR,TManuFactory,TBatchFlag,TEquipCatDR,TEquipCat,TQuantityNum,TUnitDR,TUnit,TOriginalFee,TAppendFee,TInvoiceNos,TInvoiceDate,TInvoiceFee,TProviderDR,TProvider,TStatus,TTotalFee,TStatusDR,TInStockStatu)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetInvoice
	s (TISLTotal,TInStockNo,TInvoiceDR,TUseMapDR,TInStockListDR,TInStockDR,TInStoreLocDR,TInStoreLoc,TInDate,TEquipName,TModelDR,TModel,TManuFactoryDR,TManuFactory,TBatchFlag,TEquipCatDR,TEquipCat,TQuantityNum,TUnitDR,TUnit,TOriginalFee,TAppendFee,TInvoiceNos,TInvoiceDate,TInvoiceFee,TProviderDR,TProvider,TStatus,TTotalFee,TStatusDR,TInStockStatu)=""
	quit
}

ClassMethod GetInvoiceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInvoiceExecute ]
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

ClassMethod GetInvoiceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInvoiceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetInvoiceStatu(StatusDR)
{
	i StatusDR="" q ""
	i StatusDR="0" q "新增"
	i StatusDR="1" q "账物入库"
	i StatusDR="2" q "提交"
}

Query GetInvoiceStatus() As %Query(ROWSPEC = "Status:%String,ID:%String")
{
}

ClassMethod GetInvoiceStatusExecute(ByRef qHandle As %Binary, Type) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	//s rowid=0
	d BuildDataGetInvoiceStatus
	Quit $$$OK
BuildDataGetInvoiceStatus
	s ID="0"
	s Status=..GetInvoiceStatu(ID)
	d OutputRowGetInvoiceStatus
	s ID="1"
	s Status=..GetInvoiceStatu(ID)
	d OutputRowGetInvoiceStatus
	s ID="2"
	s Status=..GetInvoiceStatu(ID)
	d OutputRowGetInvoiceStatus
	quit
OutputRowGetInvoiceStatus
	s Data=$lb(Status,ID)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetInvoiceStatus
	s (Status,ID)=""
	quit
}

ClassMethod GetInvoiceStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInvoiceStatusExecute ]
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

ClassMethod GetInvoiceStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInvoiceStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod UpdateInvoiceStatus(InvoiceDR, Status)
{
	&SQL(update sqluser.DHC_EQInvoice set IV_Status=:Status where IV_RowID=:InvoiceDR)
	q SQLCODE
}

ClassMethod CheckInStockStatu(InvoiceDR)
{
	s Flag=0
	s IUMRowID=0
	f  s IUMRowID=$o(^DHCEQInvoiceUseMap(0,"Invoice","1",InvoiceDR,IUMRowID)) q:(IUMRowID="")||(Flag="1")  d
	.s ISLRowID=$P(^DHCEQInvoiceUseMap(IUMRowID),"^",1)
	.s ISRowID=$P(^DHCEQInStockList(ISLRowID),"^",1)
	.s Statu=$P(^DHCEQInStock(ISRowID),"^",10)
	.i Statu'="3" s Flag=1
	i Flag=1 q -1001
	q Flag
}

ClassMethod GetUseYearsByCat(CatID)
{
	q ##Class(web.DHCEQCEquipeCat).GetYearsByCatID(CatID)
	
	;i CatID="" q ""
	;s Years=$P($G(^DHCEQCCode("DHCEQCEquipeCat",CatID)),"^",6)
	;q Years
}

ClassMethod IsCanAdd(BPID)
{
	s Flag=1
	s BPLID=0
	s BPLID=$o(^DHCEQBuyPlanList(0,"BuyPlan",BPID,BPLID)) q:(BPLID="")||Flag=0  d
	.s ExecNum=$P(^DHCEQBuyPlanList(BPLID),"^",11)
	.i ExecNum="" s ExecNum=0
	.s ArriveNum=$P(^DHCEQBuyPlanList(BPLID),"^",17)
	.i ArriveNum="" s ArriveNum=0
	.i (ExecNum-ArriveNum)>0 s Flag=0
	q Flag
}

Query GetBPList(StatCatDR, EquipTypeDR, Equip) As %Query(ROWSPEC = "TName:%String,HIDDEN:%String,TModel:%String,TManuFac:%String,TQuantityNum:%String,TExecNum:%String,TArriveNum:%String")
{
}

ClassMethod GetBPListExecute(ByRef qHandle As %Binary, StatCatDR, EquipTypeDR, Equip) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetBPList
	Quit $$$OK
BuildDataGetBPList
	q:EquipTypeDR=""
	s BPID=0
	f  s BPID=$o(^DHCEQBuyPlan(0,"EquipType",EquipTypeDR,BPID)) q:BPID=""  d
	.s TBuyStatu=$P(^DHCEQBuyPlan(BPID),"^",38)
	.q:+TBuyStatu<3
	.q:..IsCanAdd(BPID)
	.d OneBuyPlanDetail
	Quit
OneBuyPlanDetail
	s rowid=0
	f  s rowid=$o(^DHCEQBuyPlanList(0,"BuyPlan",BPID,rowid))  quit:rowid=""  d
	.d ResetVariablesGetBPList
	.d GetOneBuyPlanList
	quit

GetOneBuyPlanList
	s TRowID = rowid
	s TName = $p($g(^DHCEQBuyPlanList(rowid)),"^",2)
	q:(Equip'="")&&(TName'[Equip)
	s TModelDR=$p($g(^DHCEQBuyPlanList(rowid)),"^",3)
	i TModelDR'="" s TModel=$P(^DHCEQCCode("DHCEQCModel",TModelDR),"^",2)
	s TManuFacDR=$p($g(^DHCEQBuyPlanList(rowid)),"^",4)
	i TManuFacDR'="" s TManumFac=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFacDR) //$P(^DHCEQCCode("DHCEQCManufacturer",TManuFacDR),"^",1) //CZF0093
	s TQuantityNum = $p($g(^DHCEQBuyPlanList(rowid)),"^",7)
	s TExecNum=$p($g(^DHCEQBuyPlanList(rowid)),"^",11)
	s TArriveNum=$p($g(^DHCEQBuyPlanList(rowid)),"^",17)
	q:TArriveNum'<TExecNum
	d OutputRowGetBPList
	quit
OutputRowGetBPList
	s Data=$lb(TName,TRowID,TModel,TManuFac,TQuantityNum,TExecNum,TArriveNum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetBPList
	s (TName,TRowID,TModel,TManuFac,TQuantityNum,TExecNum,TArriveNum)=""
	quit
}

ClassMethod GetBPListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBPListExecute ]
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

ClassMethod GetBPListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBPListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// modified by ZY0286 增加制单人输出
/// Modified By HZY 2012-04-23 HZY0027.公司测试出的Bug.
/// Desc:将函数中的'401001'改为'301006'.(应取设置码为'301006'对应的系统设置信息.)
/// -------------------------------
/// 修改：zy 2009-11-20   ZY0017
/// 描述:保存查询的信息到临时Global中,为保存导出提供数据
/// -------------------------------
/// 修改:ZY 2009-11-03 ZY0015
/// 目的:查询包含设备分类子类的设备
/// 描述:增加参数IncludeFlag
/// 备注:IncludeFlag="off",不包含IncludeFlag子类，IncludeFlag="on",包含IncludeFlag子类，
/// Flag: 1:只查询被服类组数据
Query GetInStockDetail(vData As %String = "", QXType As %String = "") As %Query(ROWSPEC = "TISRowID:%String,TProviderDR:%String,TProvider:%String,TInDate:%String,TISNo:%String,TLocDR:%String,TLoc:%String,TStatCatDR:%String,TStatCat:%String,TEquipTypeDR:%String,TEquipType:%String,TStatus:%String,TEquipName:%String,TModelDR:%String,TModel:%String,TOriginalFee:%String,TQuantityNum:%String,TUnitDR:%String,TUnit:%String,TInvoice:%String,TTotalFee:%String,TEquipCat:%String,TUseYearsNum:%String,TInStockDR:%String,TJob:%String,TApproveStep:%String,TApproveRole:%String,TFunds:%String,TCommonName:%String,TRow:%String,TManuFactoryDR:%String,TManuFactory:%String,TReduceNum:%String,TPrintNum:%String,TRequestUser:%String")
{
}

ClassMethod GetInStockDetailExecute(ByRef qHandle As %Binary, vData As %String = "", QXType As %String = "") As %Status
{
 	new repid, index,rowid,Total,TotalFee,PNum
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    //modified by ZY 20220928
    //d ##Class(web.DHCEQCommon).KillTempGlobal("InStockDetail")
 	/**************************************************/
	Set vData=##Class(web.DHCEQCommon).UnEscape(vData)
	Set Type=##Class(web.DHCEQCommon).GetDataByName(vData,"Type")
	Set LocDR=##Class(web.DHCEQCommon).GetDataByName(vData,"LocDR")
	Set Status=##Class(web.DHCEQCommon).GetDataByName(vData,"Status")
	Set InvoiceNos=##Class(web.DHCEQCommon).GetDataByName(vData,"InvoiceNos")
	Set MinPrice=##Class(web.DHCEQCommon).GetDataByName(vData,"MinPrice")
	Set MaxPrice=##Class(web.DHCEQCommon).GetDataByName(vData,"MaxPrice")
	Set ProviderDR=##Class(web.DHCEQCommon).GetDataByName(vData,"ProviderDR")
	Set ModelDR=##Class(web.DHCEQCommon).GetDataByName(vData,"ModelDR")
	Set StartDate=##Class(web.DHCEQCommon).GetDataByName(vData,"StartDate")
	Set EndDate=##Class(web.DHCEQCommon).GetDataByName(vData,"EndDate")
	Set Name=##Class(web.DHCEQCommon).GetDataByName(vData,"Name")
	Set EquipCatDR=##Class(web.DHCEQCommon).GetDataByName(vData,"EquipCatDR")
	Set EquipTypeDR=##Class(web.DHCEQCommon).GetDataByName(vData,"EquipTypeDR")
	Set StatCatDR=##Class(web.DHCEQCommon).GetDataByName(vData,"StatCatDR")
	Set IncludeFlag=##Class(web.DHCEQCommon).GetDataByName(vData,"IncludeFlag")
	Set InStockNo=##Class(web.DHCEQCommon).GetDataByName(vData,"InStockNo")
	Set EquipNo=##Class(web.DHCEQCommon).GetDataByName(vData,"EquipNo")
	Set Flag=##Class(web.DHCEQCommon).GetDataByName(vData,"Flag")
	Set ContractNo=##Class(web.DHCEQCommon).GetDataByName(vData,"ContractNo")
	Set ReduceFilter=##Class(web.DHCEQCommon).GetDataByName(vData,"ReduceFilter") //add by zx 2015-07-23
	Set IsPrintDR=##Class(web.DHCEQCommon).GetDataByName(vData,"IsPrintDR")   ;Add By QW20210422 bug:QW0100
	Set HospitalDR=##Class(web.DHCEQCommon).GetDataByName(vData,"HospitalDR") // Add QW20210629 BUG:QW0131 增加输入参数院区HospitalDR
	i ##Class(web.DHCEQCommon).ExistsElement(vData,"InvalidFlag")
	{
		Set InvalidFlag=##Class(web.DHCEQCommon).GetDataByName(vData,"InvalidFlag")
	}
	else
	{
		Set InvalidFlag="N"
	}
	s EquipTypeValues=""
	i Flag="1"  s EquipTypeValues=##class(web.DHCEQCommon).GetSysInfo("990024")
	i EquipTypeValues'="" s EquipTypeValues=","_EquipTypeValues_","
	i StartDate'="" s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date") ;$ZDH(StartDate,4)
	i EndDate'="" s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date") ;$ZDH(EndDate,4)
 	/**************************************************/
 	i StartDate="" s StartDate=0
 	i EndDate="" s EndDate=+$H
	s index=2
	s ISRowID=0
	s rowid=0
	s Total=0
	s TotalFee=0
	s TotalReduceNum=0	// Mozy0254		1189992		2020-3-5
	s PNum=1
	s TJob=$J
    //modified by ZY 20220928
    s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
    d ##class(web.DHCEQ.Plat.LIBCommon).ClearTempGlobal("InStockDetail",TJob,curuser)
    
    k ^TempDHCEQ("GetInStockDetail")        // Mozy0254     1031718     2020-3-5
	d BuildDataGetInStockDetail
	Quit $$$OK
BuildDataGetInStockDetail
	i vData="" q
	i StartDate>EndDate q
	i ProviderDR'=""
	{
		// MZY0130	2775874		2022-07-27
		s ISRowID=""
		f  s ISRowID=$o(^DHCEQInStock(0,"Provider",ProviderDR,ISRowID),-1) quit:ISRowID=""  d
		.s TLocDR=$p(^DHCEQInStock(ISRowID),"^",2)
		.q:(LocDR'="")&&(LocDR'=TLocDR)
		.q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TLocDR))) //2010-10-26 DJ
		.s TStatusDR=$p(^DHCEQInStock(ISRowID),"^",10)
		.q:(Status'="")&&(TStatusDR'=Status)
		.s TInDate=$p($g(^DHCEQInStock(ISRowID)),"^",1)
		.q:(TInDate>EndDate)||(TInDate<StartDate)
		.s TEquipTypeDR=$p($g(^DHCEQInStock(ISRowID)),"^",20)
		.q:(Flag'="")&&(EquipTypeValues'[(","_TEquipTypeDR_","))
		.q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR))
		.s rowid=0
		.f  s rowid=$o(^DHCEQInStockList(0,"InStock",ISRowID,rowid))  quit:rowid=""  d
		..s TPrice=$p(^DHCEQInStockList(rowid),"^",7)
		..q:(MinPrice="")&&(MaxPrice'="")&&(TPrice>MaxPrice)
		..q:(MinPrice'="")&&(MaxPrice="")&&(TPrice<MinPrice)
		..q:(MinPrice'="")&&(MaxPrice'="")&&((TPrice<MinPrice)||(TPrice>MaxPrice))
		..s TModelDR=$p(^DHCEQInStockList(rowid),"^",9)
		..q:(ModelDR'="")&&(TModelDR'=ModelDR)
		..d GetOneInStockDetail
	}
	else
	{
		// MZY0130	2775874		2022-07-27
		s ISRowID=""
		f  s ISRowID=$o(^DHCEQInStock(ISRowID),-1) quit:(ISRowID="")||(ISRowID=0)  d
		.s TLocDR=$p(^DHCEQInStock(ISRowID),"^",2)
		.q:(LocDR'="")&&(LocDR'=TLocDR)
		.q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TLocDR))) //2010-10-26 DJ
		.s TStatusDR=$p(^DHCEQInStock(ISRowID),"^",10)
		.q:(Status'="")&&(TStatusDR'=Status)
		.s TInDate=$p($g(^DHCEQInStock(ISRowID)),"^",1)
		.q:(TInDate>EndDate)||(TInDate<StartDate)
		.s TEquipTypeDR=$p($g(^DHCEQInStock(ISRowID)),"^",20)
		.q:(Flag'="")&&(EquipTypeValues'[(","_TEquipTypeDR_","))
		.q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR))
		.s rowid=0
		.f  s rowid=$o(^DHCEQInStockList(0,"InStock",ISRowID,rowid))  quit:rowid=""  d
		..s TPrice=$p(^DHCEQInStockList(rowid),"^",7)
		..q:(MinPrice="")&&(MaxPrice'="")&&(TPrice>MaxPrice)
		..q:(MinPrice'="")&&(MaxPrice="")&&(TPrice<MinPrice)
		..q:(MinPrice'="")&&(MaxPrice'="")&&((TPrice<MinPrice)||(TPrice>MaxPrice))
		..s TModelDR=$p(^DHCEQInStockList(rowid),"^",9)
		..q:(ModelDR'="")&&(TModelDR'=ModelDR)
		..d GetOneInStockDetail
	}
	s TotalFlag=##class(web.DHCEQCommon).GetSysInfo("301006")
	i (TotalFlag'="")&&(TotalFlag'="0")
	{
		i TotalFlag="1" s TotalLoc=1
		i TotalFlag="2" s TotalLoc=index+1
		i TotalFlag="3" s TotalLoc=0
		d ResetVariablesGetInStockDetail
		s TQuantityNum=Total
		s TTotalFee=TotalFee
		// Mozy0254		1189992		2020-3-5
		s TReduceNum=TotalReduceNum
		// Mozy0254		1031718		2020-3-5
		s TInvoiceNoDR=""
        f  s TInvoiceNoDR=$o(^TempDHCEQ("GetInStockDetail","InvoiveDR",+$H,TJob,TInvoiceNoDR)) quit:TInvoiceNoDR=""  d
		.s TInvoice=1+TInvoice
		i TInvoice'="" s TInvoice=TInvoice_" 张"
		s TRow="合计:"
		//s Data=$lb(TISRowID,TProviderDR,TProvider,TInDate,TISNo,TLocDR,TLoc,TStatCatDR,TStatCat,TEquipTypeDR,TEquipType,TStatus,TEquipName,TModelDR,TModel,TOriginalFee,TQuantityNum,TUnitDR,TUnit,TInvoice,TTotalFee,TEquipCat,TUseYearsNum,TISRowID,TJob,TApproveStep,TApproveRole,TFunds,TCommonName,TRow,TManuFactoryDR,TManuFactory,TReduceNum,TRequestUser)
		//Set ^CacheTemp(repid,TotalLoc)=Data
        //modified by ZY 20220928
        //Set ^DHCEQTemp("InStockDetail",+$H,TJob,PNum)=TISRowID_"^"_TProviderDR_"^"_TProvider_"^"_TInDate_"^"_TISNo_"^"_TLocDR_"^"_TLoc_"^"_TStatCatDR_"^"_TStatCat_"^"_TEquipTypeDR_"^"_TEquipType_"^"_TStatus_"^"_TEquipName_"^"_TModelDR_"^"_TModel_"^"_TOriginalFee_"^"_TQuantityNum_"^"_TUnitDR_"^"_TUnit_"^"_TInvoice_"^"_TTotalFee_"^"_TEquipCat_"^"_TUseYearsNum_"^"_TISRowID_"^"_TApproveStep_"^"_TApproveRole_"^"_TFunds_"^"_TCommonName_"^"_TManuFactoryDR_"^"_TManuFactory_"^"_TReduceNum_"^"_TRequestUser
        s tmpValue=TISRowID_"^"_TProviderDR_"^"_TProvider_"^"_TInDate_"^"_TISNo_"^"_TLocDR_"^"_TLoc_"^"_TStatCatDR_"^"_TStatCat_"^"_TEquipTypeDR_"^"_TEquipType_"^"_TStatus_"^"_TEquipName_"^"_TModelDR_"^"_TModel_"^"_TOriginalFee_"^"_TQuantityNum_"^"_TUnitDR_"^"_TUnit_"^"_TInvoice_"^"_TTotalFee_"^"_TEquipCat_"^"_TUseYearsNum_"^"_TISRowID_"^"_TApproveStep_"^"_TApproveRole_"^"_TFunds_"^"_TCommonName_"^"_TManuFactoryDR_"^"_TManuFactory_"^"_TReduceNum_"^"_TRequestUser
        d ##class(web.DHCEQ.Plat.LIBCommon).SetTempGlobal("InStockDetail",+$H,TJob,curuser,PNum,tmpValue)
	}
	quit
GetOneInStockDetail
	d ResetVariablesGetInStockDetail
	s TISRowID=ISRowID
	s ISFlag=$p($g(^DHCEQInStock(ISRowID)),"^",25)
	i ISFlag="" s ISFlag="N"
	q:(InvalidFlag'="")&&(InvalidFlag'=ISFlag)
	s OCLSourceType=$p($g(^DHCEQInStockList(rowid)),"^",18)
	s OCLSourceID=$p($g(^DHCEQInStockList(rowid)),"^",19)
	s OCLContractNo=""
	s EQRowID=""
	i OCLSourceType=0  d
	.s EQRowID=OCLSourceID
	e  i OCLSourceType=2  d
	.s EQRowID=$o(^DHCEQEquip(0,"OpenCheckList",OCLSourceID,0))
	i EQRowID'=""  d
	.s OCLContractNo=$p($g(^DHCEQEquip(EQRowID)),"^",76)
	q:(ContractNo'="")&&(OCLContractNo'[ContractNo)
	s TProviderDR=$p(^DHCEQInStock(TISRowID),"^",17)
	s TProvider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	s TManuFactoryDR = $p($g(^DHCEQInStockList(rowid)),"^",6)   //add by wy 2017-4-27 需求：369806
	i TManuFactoryDR '=""  d
	.s TManuFactory =##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)	// $p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1) 	//CZF0093
	s TInDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInStock(TISRowID)),"^",1),"date")
	s TISNo=$p(^DHCEQInStock(TISRowID),"^",14)
	q:TISNo=""
	q:(InStockNo'="")&&($e(TISNo,1,$l(InStockNo))'=InStockNo)
	s Find=##Class(web.DHCEQInStockNew).CheckOrderEqNo("InStock",TISRowID,EquipNo)
	q:(EquipNo'="")&&(Find=0)
	s TLocDR=$p(^DHCEQInStock(TISRowID),"^",2)
	i TLocDR'="" s TLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept", TLocDR)
	s TStatCatDR=$p($g(^DHCEQInStock(TISRowID)),"^",21)
	q:(StatCatDR'="")&&(TStatCatDR'=StatCatDR)
	i TStatCatDR '=""  d
	.s TStatCat = $p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
	s TEquipTypeDR=$p($g(^DHCEQInStock(TISRowID)),"^",20)
	q:(EquipTypeDR'="")&&(TEquipTypeDR'=EquipTypeDR)
	s result=##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	q:+result'=0
	i TEquipTypeDR '=""  d
	.s TEquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	s TStatus=$p($g(^DHCEQInStock(TISRowID)),"^",10)
	s result=##class(web.DHCEQCommon).FundsTypeIsIn(3,rowid)	// Mozy0231	资金来源类型
	q:+result'=0
	q:..EquipIsInStock(rowid,Name)
	
	s TRequestUserDR=$p($g(^DHCEQInStock(TISRowID)),"^",4)
	s TRequestUser=##class(web.DHCEQCommon).GetTrakNameByID("user", TRequestUserDR)
	
	//modified by ZY0308 2819263
	s TEquipName=$p(^DHCEQInStockList(rowid),"^",5)
	s TCommonName=$p($g(^DHCEQInStockList(rowid)),"^",16)
	i TCommonName'="" s TCommonName=$p($g(^DHCEQCCode("DHCEQCMasterItem",TCommonName)),"^",1)
	s TModelDR=$p(^DHCEQInStockList(rowid),"^",9)
	i TModelDR'="" d
	.s TModel=$P(^DHCEQCCode("DHCEQCModel",TModelDR),"^",2)
	s TReduceValue=##Class(web.DHCEQInStockList).GetReturnInfoOfInstockList(rowid)
	s TReduceNum=$p(TReduceValue,"^",1)
	s TUseYearsNum=$p(^DHCEQInStockList(rowid),"^",15)
	s TOriginalFee=$p(^DHCEQInStockList(rowid),"^",7)
	s TQuantityNum=$p(^DHCEQInStockList(rowid),"^",8)
	i ReduceFilter=1 s TQuantityNum=TQuantityNum-TReduceNum
	q:TQuantityNum=0
	;Add By QW20210422 bug:QW0100 获取打印次数 begin
	s TPrintNum=##class(web.DHCEQ.Plat.BUSOperateLog).GetOperateTimes("21",TISRowID) ;Modified By QW20210913 BUG:QW0147 修改打印次数
	q:(IsPrintDR="1")&&(TPrintNum=0) 
	q:(IsPrintDR="0")&&(TPrintNum'=0) 
	;Add By QW20210422 bug:QW0100 获取打印次数 end
	s TTotalFee=TOriginalFee*TQuantityNum
	s TEquipCatDR=$p(^DHCEQInStockList(rowid),"^",14)
	i (EquipCatDR'="")&(EquipCatDR'=TEquipCatDR)
	{
		s passed=1
		i (IncludeFlag'="on")
		{
			s passed=0
		}
		else
		{
			s passed=##class(web.DHCEQCEquipeCat).IsChildPar(EquipCatDR,TEquipCatDR)
		}
		i passed=0 q
	}
	Set THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TLocDR) ;Add QW20210629 BUG:QW0131
	q:(HospitalDR'="")&&(HospitalDR'=THospitalDR) ;Add QW20210629 BUG:QW0131
	//q:(EquipCatDR'="")&&(TEquipCatDR'=EquipCatDR)
	i TEquipCatDR'="" d
	.s TEquipCat=$P(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR),"^",2)
	s TUnitDR=$p(^DHCEQInStockList(rowid),"^",10)
	i TUnitDR'="" d
	.s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	s InvoiceInfo=##Class(web.DHCEQInvoice).GetInvoiceInfos(1,rowid)
	;s TInvoice=$p(InvoiceInfo,"^",1)
	
	;Modified By QW20210917 BUG:QW0153 begin 修改取发票数量及相关信息。存在一对多发票,时间取最新
	s InvoiceLen=$l(InvoiceInfo,"&")
	for i=1:1:InvoiceLen d
	.s Invoice=$p(InvoiceInfo,"&",i)	//czf 2022-05-19
	.s PerInvoiceNo=$p(Invoice,"^",1)
	.i (TInvoice'="")&&((","_TInvoice_",")'[(","_PerInvoiceNo_",")) s TInvoice=TInvoice_","_PerInvoiceNo
	.i TInvoice="" s TInvoice=PerInvoiceNo
	q:(InvoiceNos'="")&&((","_TInvoice_",")'[(","_InvoiceNos_","))	
	;Modified By QW20210917 BUG:QW0153 end
	
	;不统计配置设备	// Mozy0217  2018-11-01
	;i $p(^DHCEQInStockList(rowid),"^",22)="" d
	s Total=Total+TQuantityNum
	s TotalFee=TotalFee+TTotalFee
	
	i TOriginalFee'="" s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"",2)
	i TTotalFee'="" s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"",2)
	i TotalFee'="" s TotalFee=##Class(web.DHCEQCommon).FormatNumber(TotalFee,"",2)
	i TStatus'=0  d
	.s ApproveInfo=##Class(web.DHCEQApprove).GetApproveInfoBySourceID("13",TISRowID)
	.i ApproveInfo'=""  d
	..s TApproveRole=$p(ApproveInfo,"^",9)
	..s TApproveStep=$p(ApproveInfo,"^",5)
	s TStatus=##class(web.DHCEQInStock).GetInStockStatus(TStatus)
	
	Set Funds=##Class(web.DHCEQInStockList).GetFundsTypeInfos(3,rowid)
	i Funds'="" d
	.Set n=$Length(Funds,",")
	.For i=1:1:n Do
	..If TFunds'="" Set TFunds=TFunds_"/"
	..Set TFunds=TFunds_$Piece($Get(^DHCEQCCode("DHCEQCFundsType",$Piece(Funds,",",i))),"^",2)
	// Mozy0254		1189992		2020-3-5
	s TReduceValue=##Class(web.DHCEQInStockList).GetReturnInfoOfInstockList(rowid)
	s TReduceNum=$p(TReduceValue,"^",1)
	s TotalReduceNum=TotalReduceNum+TReduceNum
	// Mozy0254		1031718		2020-3-5	设置发票记录
	s IUMRowID=0
  	f  s IUMRowID=$o(^DHCEQInvoiceUseMap(0,"Source",1,rowid,IUMRowID)) q:IUMRowID=""  d
  	.s TInvoiceNoDR=$p($g(^DHCEQInvoiceUseMap(IUMRowID)),"^",2)
  	.q:TInvoiceNoDR=""
	.q:$P(^DHCEQInvoice(TInvoiceNoDR),"^",16)="Y"
    .i $p($g(^DHCEQInvoice(TInvoiceNoDR)),"^",2)'="" s ^TempDHCEQ("GetInStockDetail","InvoiveDR",+$H,TJob,TInvoiceNoDR)=""
  	
	d OutputRowGetInStockDetail
	quit
OutputRowGetInStockDetail
	s TRow=PNum
	s Data=$lb(TISRowID,TProviderDR,TProvider,TInDate,TISNo,TLocDR,TLoc,TStatCatDR,TStatCat,TEquipTypeDR,TEquipType,TStatus,TEquipName,TModelDR,TModel,TOriginalFee,TQuantityNum,TUnitDR,TUnit,TInvoice,TTotalFee,TEquipCat,TUseYearsNum,TISRowID,TJob,TApproveStep,TApproveRole,TFunds,TCommonName,TRow,TManuFactoryDR,TManuFactory,TReduceNum,TPrintNum,TRequestUser)
	Set ^CacheTemp(repid,index)=Data
    //modified by ZY 20220928
    //Set ^DHCEQTemp("InStockDetail",+$H,TJob,PNum)=TISRowID_"^"_TProviderDR_"^"_TProvider_"^"_TInDate_"^"_TISNo_"^"_TLocDR_"^"_TLoc_"^"_TStatCatDR_"^"_TStatCat_"^"_TEquipTypeDR_"^"_TEquipType_"^"_TStatus_"^"_TEquipName_"^"_TModelDR_"^"_TModel_"^"_TOriginalFee_"^"_TQuantityNum_"^"_TUnitDR_"^"_TUnit_"^"_TInvoice_"^"_TTotalFee_"^"_TEquipCat_"^"_TUseYearsNum_"^"_TISRowID_"^"_TApproveStep_"^"_TApproveRole_"^"_TFunds_"^"_TCommonName_"^"_TManuFactoryDR_"^"_TManuFactory_"^"_TReduceNum_"^"_TRequestUser
    s tmpValue=TISRowID_"^"_TProviderDR_"^"_TProvider_"^"_TInDate_"^"_TISNo_"^"_TLocDR_"^"_TLoc_"^"_TStatCatDR_"^"_TStatCat_"^"_TEquipTypeDR_"^"_TEquipType_"^"_TStatus_"^"_TEquipName_"^"_TModelDR_"^"_TModel_"^"_TOriginalFee_"^"_TQuantityNum_"^"_TUnitDR_"^"_TUnit_"^"_TInvoice_"^"_TTotalFee_"^"_TEquipCat_"^"_TUseYearsNum_"^"_TISRowID_"^"_TApproveStep_"^"_TApproveRole_"^"_TFunds_"^"_TCommonName_"^"_TManuFactoryDR_"^"_TManuFactory_"^"_TReduceNum_"^"_TRequestUser
    d ##class(web.DHCEQ.Plat.LIBCommon).SetTempGlobal("InStockDetail",+$H,TJob,curuser,PNum,tmpValue)
	Set PNum=PNum+1
	Set index=index+1
	quit
ResetVariablesGetInStockDetail
	s (TISRowID,TProviderDR,TProvider,TInDate,TISNo,TLocDR,TLoc,TStatCatDR,TStatCat,TEquipTypeDR,TEquipType,TStatus,TEquipName,TModelDR,TModel,TOriginalFee,TQuantityNum,TUnitDR,TUnit,TInvoice,TTotalFee,TEquipCat,TUseYearsNum,InvoiceInfo,TISRowID,TApproveStep,TApproveRole,TFunds,TCommonName,TRow,TManuFactoryDR,TManuFactory,TReduceNum,TPrintNum,TRequestUser)=""    //Modefied by zc0120 2022-7-26 初始化TRequestUser
	quit
}

ClassMethod GetInStockDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInStockDetailExecute ]
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

ClassMethod GetInStockDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInStockDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 0在此入库单  1不在此入库单
ClassMethod EquipIsInStock(ISLID, Name)
{
	i Name="" q 0
	s Name=$ZCONVERT(Name ,"U")
	s SMName=$ZCONVERT($p(^DHCEQInStockList(ISLID),"^",5),"U")
	i SMName[Name q 0
	s EquipID=$p(^DHCEQInStockList(ISLID),"^",2)
	i EquipID=""
	{
		s CSID=$o(^DHCEQChangeStock(0,"Source","0",ISLID,0))
		i CSID="" q 1
		s EquipID=$p(^DHCEQChangeStock(CSID),"^",1)
	}
	s Code=$ZCONVERT($p(^DHCEQEquip(EquipID),"^",6),"U")
	i Code[Name q 0
	q 1
}

/// -------------------------------
/// 创建：zy 2009-11-18   ZY0017
/// 描述:取到打印导出的查询信息
/// -------------------------------
ClassMethod GetOneInStockDetail(PNum, job)
{
	i PNum=0 q $o(^DHCEQTemp("InStockDetail",+$H,job,""),-1)
	q $g(^DHCEQTemp("InStockDetail",+$H,job,PNum))
}

/// #Class(web.DHCEQInStockList).GetInStockDate(instocklistdr, isnum)
ClassMethod GetInStockDate(instocklistdr, isnum)
{
	s InDate=""
	i instocklistdr'="" d
	.s ISID=$p(^DHCEQInStockList(instocklistdr),"^",1)
	.s InDate = $p($g(^DHCEQInStock(ISID)),"^",13)
	.i isnum'=1 s InDate=##Class(web.DHCEQCommon).TransValueToPage(InDate,"date") ;$ZD(InDate,3)
	q InDate
}

/// ##Class(web.DHCEQInStockList).GetNoIcon(rs.GetDataByName("TRowID"))
ClassMethod GetNoIcon(sourceType As %Library.String, sourceID As %Library.String)
{
	n (sourceType,sourceID)
	i sourceType="" q ""
	i sourceID="" q ""
	i sourceType="1"
	{
		s iSourceType=$p($g(^DHCEQInStockList(sourceID)),"^",18)
		s iSourceID=$p($g(^DHCEQInStockList(sourceID)),"^",19)
		i (iSourceType="1")
		{
			s inStockID=$p($g(^DHCEQInStockList(sourceID)),"^",1)
			s status=$p($g(^DHCEQInStock(inStockID)),"^",10)
			i status'=3 q ""
		}
	}
	q "websys/edit.gif"
}

// 2011-07-20 DJ

/// Modified by jdl 2011-10-28 JDL0099 与web.DHCEQCommon统一方法参数
ClassMethod GetNum(node As %Library.String = "", job)
{
	q ..GetOneInStockDetail(0,job)
}

/// Modified by jdl 2011-10-28 JDL0099 与web.DHCEQCommon统一方法参数
ClassMethod GetList(node As %Library.String = "", job, gnum)
{
	q ..GetOneInStockDetail(gnum,job)
}

/// Mozy0084	2012-6-1
/// 获取某一来源的所有资金来源类型
/// w ##Class(web.DHCEQInStockList).GetFundsTypeInfos(3,2152)
ClassMethod GetFundsTypeInfos(FromType, FromID)
{
	Quit:((FromType="")&(FromID="")) ""
	
	new Amount,FundsID,LastFundsID
	Set FundsTypeInfos=""
	If ($Piece(^DHCEQInStockList(FromID),"^",18)="2")
	{
		//入库明细来源于验收时,从验收取资金来源数据
		Set FromType=0
		Set FromID=$Piece(^DHCEQInStockList(FromID),"^",19)
	}
	
	Set FundsID=0
	For  Set FundsID=$Order(^DHCEQFunds(0,"Source",FromType,FromID,FundsID)) Quit:(FundsID="")  Do
	.Quit:$Piece(^DHCEQFunds(FundsID),"^",10)="Y"		;F_InvalidFlag
	.Quit:$Piece(^DHCEQFunds(FundsID),"^",6)="2"		;F_OperFlag
	.Set FundsTypeDR=$Piece($Get(^DHCEQFunds(FundsID)),"^",2)
	.If FundsTypeInfos'="" Set FundsTypeInfos=FundsTypeInfos_","
	.;$Piece($Get(^DHCEQCCode("DHCEQCFundsType",FundsTypeDR)),"^",2)
	.Set FundsTypeInfos=FundsTypeInfos_FundsTypeDR
	
	Quit FundsTypeInfos
}

/// Mozy0217  2018-11-01
/// 判断入库明细记录是否存在有配置设备
/// 		返回值		Find:空		未匹配到配置记录
/// w ##Class(web.DHCEQInStockNew).CheckConfigDR(712)
ClassMethod CheckConfigDR(RowID As %String = "")
{
	n Find, ListID
	
	s Find=""
	i (RowID="") q Find
	
	s ListID=0	
	f  s ListID=$O(^DHCEQInStockList(0,"InStock",RowID,ListID)) q:(ListID="")||(Find'="")  d
	.q:($Piece($Get(^DHCEQInStockList(ListID)),"^",18)'=2)
	.s Find = ##Class(web.DHCEQ.EM.BUSConfig).GetConfigDRs(1, $Piece($Get(^DHCEQInStockList(ListID)),"^",19))
	
	q Find
}

/// add by zx 2015-07-23
/// 获取入库明细对应的退货的数量和总金额
/// w ##Class(web.DHCEQInStockList).GetReturnInfoOfInstockList(120,24787)
ClassMethod GetReturnInfoOfInstockList(ISLRowID, EQID As %String = "")
{
	new (ISLRowID,EQID)		;20150902
	s (num,amount)=0
	if (ISLRowID>0)
	{
		s ISRowID=$p($g(^DHCEQInStockList(ISLRowID)),"^",1)
		s EquipTypeDR=$p($g(^DHCEQInStock(ISRowID)),"^",20)
		s ProviderDR=$p(^DHCEQInStock(ISRowID),"^",17)
		
		s RRowID=0
		f  s RRowID=$o(^DHCEQReturn(0,"Provider",ProviderDR,RRowID)) q:RRowID=""  d
		.q:($p($g(^DHCEQReturn(RRowID)),"^",13)'=2)
		.q:($p($g(^DHCEQReturn(RRowID)),"^",14)="Y")
		.q:(EquipTypeDR'=$p($g(^DHCEQReturn(RRowID)),"^",15))
		.s RLRowID=0
		.f  s RLRowID=$o(^DHCEQReturnList(0,"Return",RRowID,RLRowID)) q:RLRowID=""  d
		..s ISLDR=$p($g(^DHCEQReturnList(RLRowID)),"^",3)
		..s RLQuantity=$p($g(^DHCEQReturnList(RLRowID)),"^",5)
		..s RLOriginalFee=$p($g(^DHCEQReturnList(RLRowID)),"^",6)
		..s EQRowIDs=$g(^DHCEQReturnList(RLRowID,"EX","RowIDs"))
		..q:(EQID'="")&&((","_EQRowIDs_",")'[(","_EQID_","))
		..i EQID'="" s RLQuantity=1
		..i ""'=ISLDR  d
		...i ISLRowID=ISLDR  d
		....s num=num+RLQuantity
		....s amount=RLQuantity*RLOriginalFee+amount
		..e  d
		...s equipDR=$p($g(^DHCEQReturnList(RLRowID)),"^",4)
		...i ISLRowID=$p($g(^DHCEQEquip(equipDR)),"^",70)  d
		....s num=num+1
		....s amount=+$p($g(^DHCEQReturnList(RLRowID)),"^",6)*1+amount
	}
	q num_"^"_amount
}

/// czf 2022-07-05
/// 描述：hisui改造在jQuery页面标签显示合计信息
/// 输入：node：临时global的节点名称
/// w ##Class(web.DHCEQInStockList).GetSumInfo(27232)
ClassMethod GetSumInfo(Ejob As %Library.String = "")
{
	//s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s info=""
	
	s (Count,TotalFee,TotalNetFee,TotalDepreFee)=0
	
	s nrowid=0	
	f  s nrowid=$o(^DHCEQTemp("InStockDetail",+$h,Ejob,nrowid)) q:nrowid=""  d
	.q:$p($g(^DHCEQTemp("InStockDetail",+$h,Ejob,nrowid)),"^",1)=""	;TRowID
	.s OriginalFee=$p($g(^DHCEQTemp("InStockDetail",+$h,Ejob,nrowid)),"^",16)
	.s Quantity=$p($g(^DHCEQTemp("InStockDetail",+$h,Ejob,nrowid)),"^",17)
	.s Count=Count+Quantity
	.s TotalFee=TotalFee+(Quantity*OriginalFee)
	s TotalFee=##Class(web.DHCEQCommon).FormatNumber(TotalFee,"")
  	s info="合计&nbsp;&nbsp;数量:"_Count_"&nbsp;&nbsp;&nbsp;总金额:"_TotalFee
  	
  	q info
}

}
