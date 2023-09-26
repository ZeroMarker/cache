/// ----------------------------------------------
/// Modified by JDL 2009-06-5  JDL0012
/// Modified method GetList
/// 增加返回EquipDR
/// ---------------------------------------------
Class web.DHCEQInStockSP Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 24;

// 设备入库打印

ClassMethod GetPath(itmjs As %Library.String = "", itmjsex As %Library.String = "")
{
	&sql(select pathtoreports into :path from websys.configuration)
	q path
}

ClassMethod GetEquipDR(EquipDR As %Library.String = "")
{
	s TNo = $p($g(^DHCEQEquip(EquipDR)),"^",71)
	q TNo
}

/// modified by ZY0215 2020-04-02
/// 修改取值,增加品牌输出
/// w Class(web.DHCEQInStockSP).GetList(14)
ClassMethod GetList(InStockDR As %Library.String = "")
{
	s Data=""
	s Num=0
	//modified by zy 0111
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")
	Set SplitNumCode=##class(web.DHCEQCommon).GetSysInfo("990026")
	s (sumFee,sumQty)=0
	s Rowid=0
	f  s Rowid=$o(^DHCEQInStockList(Rowid))  quit:Rowid=""  d
	.s (ManuFactory,Model,Unit)=""
	.s InStockD=$p($g(^DHCEQInStockList(Rowid)),"^",1)
	.q:InStockD'=InStockDR
	.s EquipName=$p($g(^DHCEQInStockList(Rowid)),"^",5) //设备名称
	.s ManuFactoryDR=$p($g(^DHCEQInStockList(Rowid)),"^",6) //生产厂商
	./////modified by ZY0215 2020-04-02
	.s ManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",ManuFactoryDR)
	.s ModelDR=$p($g(^DHCEQInStockList(Rowid)),"^",9) //规格
	.///modified by ZY0215 2020-04-02
	.s Model = ##Class(web.DHCEQCommon).GetTrakNameByID("model",ModelDR)
	.s UnitDR=$p($g(^DHCEQInStockList(Rowid)),"^",10) //单位
	.s Unit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",UnitDR)
	.s QuantityNum=$p($g(^DHCEQInStockList(Rowid)),"^",8) //数量
	.s OriginalFee=$p($g(^DHCEQInStockList(Rowid)),"^",7) //单价
	.s InvoiceNos=$p(##Class(web.DHCEQInvoice).GetInvoiceInfos(1,Rowid),"^",1) //发票号
	.s Remark=$p($g(^DHCEQInStockList(Rowid)),"^",12) //备注
	.s AllFee=QuantityNum*OriginalFee
	.s EquipNo=""
	.s ContractNo=""
	.s TBrand=""
	.s EquipDR=$p($g(^DHCEQInStockList(Rowid)),"^",2)
	.///modified by ZY0215 2020-04-02
	.i EquipDR="" d
	..s vStoreLocDR=0
	..f  s vStoreLocDR=$o(^DHCEQEquip(0,"InStockList",Rowid,vStoreLocDR)) q:(vStoreLocDR="")||(EquipDR'="")  d
	...s EquipDR=$o(^DHCEQEquip(0,"InStockList",Rowid,vStoreLocDR,0))
	.
	.///modified by ZY0215 2020-04-02
	.i EquipDR'=""  d
	..s EquipNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
	..s ContractNo=##class(web.DHCEQEquip).GetContractNo(EquipDR)
	..s TBrand=$p($g(^DHCEQEquip(EquipDR)),"^",94)
	..s TBrand = ##Class(web.DHCEQCommon).GetTrakNameByID("brand",TBrand)
	.//modified by ZY0198  附属设备不统计合计
	.s Hold4=$p($g(^DHCEQInStockList(Rowid)),"^",22) //附属设备的内容
	.i Hold4="" s sumFee=sumFee+AllFee
	.i Hold4="" s sumQty=sumQty+QuantityNum
	.                         //设备名称      生产厂商      规格    单位   数量         单价          金额    发票号       备注
	.s Data=Data_SplitRowCode_EquipName_"^"_ManuFactory_"^"_Model_"^"_Unit_"^"_QuantityNum_"^"_OriginalFee_"^"_AllFee_"^"_InvoiceNos_"^"_Remark_"^"_EquipNo_"^"_ContractNo_"^"_EquipDR_"^"_TBrand
	.s Num=Num+1
	i Data'=""  d
	.s Data=Data_SplitRowCode_"合计"_"^"_"^"_"^"_"^"_sumQty_"^"_"^"_sumFee_"^"_"^"_"^"_"^"_"^"
	.s Num=Num+1
	q Data_SplitNumCode_Num
}

}
