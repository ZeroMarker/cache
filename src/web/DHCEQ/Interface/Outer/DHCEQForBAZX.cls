/// 宝安中心医院数据接口;
Class web.DHCEQ.Interface.Outer.DHCEQForBAZX Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 宝安中心医院基础数据接口
/// Input:输入参数
/// ReportDate "" 每月的第一天上传上一个月甲乙类设备数据，不为空取ReportDate当月甲乙类设备的数据上传
/// Creator:add WY 2023-3-17
/// output::YLJGDM,TJND,TJYF,SBDM,SBMC,YNSBMC,TPGJSBTS,CD,SCCJ,SBXH,GMRQ,GJSXJQK,GMDJ,LLSJSM,SYQKDM,ZCXMFLDM,ZCXMFLMC,ZCYZ,XGBZ,YWSCSJ,SJSCSJ,YLYL1,YLYL2
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.Outer.DHCEQForBAZX","GetEquipByAttribute")
Query GetEquipByAttribute(ReportDate As %String = "") As %Query(ROWSPEC = "YLJGDM:%String,TJND:%String,TJYF:%String,SBDM:%String,SBMC:%String,YNSBMC:%String,TPGJSBTS:%String,CD:%String,SCCJ:%String,SBXH:%String,GMRQ:%String,GJSXJQK:%String,GMDJ:%String,LLSJSM:%String,SYQKDM:%String,ZCXMFLDM:%String,ZCXMFLMC:%String,ZCYZ:%String,XGBZ:%String,YWSCSJ:%String,SJSCSJ:%String,YLYL1:%String,YLYL2:%String")
{
}

ClassMethod GetEquipByAttributeExecute(ByRef qHandle As %Binary, ReportDate As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=0
	i (ReportDate'="")
	{
		s Date=ReportDate  
	}
	else
	{
		s Date=$H-1  
	}
	s MonthStr=##Class(web.DHCEQReport).GetReportMonthByDate(Date)
	s StartDate= ##Class(web.DHCEQReport).GetMonthDate(MonthStr,1)
	s endDate=##Class(web.DHCEQReport).GetMonthDate(MonthStr,1)
	s RowID=0
	f  s RowID=$o(^DHCEQEquip(RowID)) q:RowID=""  d
	.d BuildDataGetEquipByAttribute
	Quit $$$OK
BuildDataGetEquipByAttribute		
	d ResetVariablesGetEquipByAttribute
	q:$p($g(^DHCEQEquip(RowID)),"^",59)="Y"    //过滤无效设备
    s TStockStatus=$p($g(^DHCEQEquip(RowID)),"^",60)
    q:(TStockStatus="0")||(TStockStatus="3")   //过滤新增未入库和出库设备
    s TStatus = $p($g(^DHCEQEquip(RowID)),"^",38)
	q:(TStatus>"2")    //过滤报废，其他状态设备
	s TransAssetDate=$p($g(^DHCEQEquip(RowID)),"^",45)
	q:(TransAssetDate>endDate)||(TransAssetDate<StartDate)
	q:(##Class(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttribute(3,RowID,"51")=0)
	s YLJGDM=""    //医疗机构组织机构代码(标注)
	s TJND=$p(MonthStr,"-",1)  //统计年度
	s TJYF=$p(MonthStr,"-",2)   //统计月份
	s SBDM=$p($g(^DHCEQEquip(RowID)),"^",6)  //设备代码
	s SBMC=$p($g(^DHCEQEquip(RowID)),"^",1)  //设备名称
	s YNSBM=$p($g(^DHCEQEquip(RowID)),"^",1)  //院内设备名
	s TPGJSBTS=""    //同批购进相 同型号设备 台数
	s CountryDR=$p($g(^DHCEQEquip(RowID)),"^",16)
	if CountryDR'="" s CD=##class(web.DHCEQCommon).GetTrakNameByID("country",CountryDR)  //产地
	s ManuFactoryDR=$p($g(^DHCEQEquip(RowID)),"^",26)
	if ManuFactoryDR'=""  s ManuFactory=##class(web.DHCEQCommon).GetTrakNameByID("DHCEQCManufacturer",ManuFactoryDR) //
	if (ManuFactory="中国")||(ManuFactory="香港")||(ManuFactory="台湾") d
	.s CD="02"
	e  d
	.s CD="01"
	s TModelDR=$p($g(^DHCEQEquip(RowID)),"^",3)
	i TModelDR'="" s SBXH=##class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)  //规格
    s GMRQ=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(RowID)),"^",45),"date")  //购买日期
    s GJSXJQK=""  //购进时新旧情况
    s GMDJ=$p($g(^DHCEQEquip(RowID)),"^",27)  //购买单价
	s LLSJSM=##Class(web.DHCEQCEquipeCat).GetYearsByCatID(TCatDR,TStatCatDR)  //理论设计寿命
    s SYQKDM="01"   //使用情况代码 01 启用 02 未启用 03报废
    
    s EARowid=$o(^DHCEQCCode("DHCEQCEquipAttribute",0,"Code",51,0))
    s Lrowid=$o(^DHCEQEquipAttributeList(0,"AttributeSource",EARowID,3,RowID,0))
    s EALSubInfo=$p($g(^DHCEQEquipAttributeList(Lrowid)),"^",4)
	i EALSubInfo'="" d 
    .s ZCXMFLDM=$p($g(^DHCEQCCode("DHCEQCInHospitalType",EALSubInfo)),"^",1)  //资产项目分类代码
    .s ZCXMFLMC=$p($g(^DHCEQCCode("DHCEQCInHospitalType",EALSubInfo)),"^",2)  //资产项目分类名称
    s ZCYZ=$p($g(^DHCEQEquip(RowID)),"^",27)  //资产原值
    s XGBZ="0"   //修改标志  。0：正常、1：撤销；
    s Datetime=$p($g(^DHCEQEquip(RowID)),"^",53)_","_$p($g(^DHCEQEquip(RowID)),"^",54)
    s YWSCSJ=##class(web.DHCEQCommon).TransValueToPage(Datetime,"datetime")   //数据生成时间
  	s SJSCSJ=##class(web.DHCEQCommon).TransValueToPage(+$H,"datetime")  //上传日期
	s YL1=""    //预留一
	s YLYL2=""  //预留二
	d OutputRowGetEquipByAttribute
	quit
OutputRowGetEquipByAttribute
	s Data=$lb(YLJGDM,TJND,TJYF,SBDM,SBMC,YNSBMC,TPGJSBTS,CD,SCCJ,SBXH,GMRQ,GJSXJQK,GMDJ,LLSJSM,SYQKDM,ZCXMFLDM,ZCXMFLMC,ZCYZ,XGBZ,YWSCSJ,SJSCSJ,YLYL1,YLYL2)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetEquipByAttribute
	s (YLJGDM,TJND,TJYF,SBDM,SBMC,YNSBMC,TPGJSBTS,CD,SCCJ,SBXH,GMRQ,GJSXJQK,GMDJ,LLSJSM,SYQKDM,ZCXMFLDM,ZCXMFLMC,ZCYZ,XGBZ,YWSCSJ,SJSCSJ,YLYL1,YLYL2)=""
	quit
}

ClassMethod GetEquipByAttributeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipByAttributeExecute ]
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

ClassMethod GetEquipByAttributeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipByAttributeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 宝安中心医院基础数据接口
/// Input:输入参数
/// Creator:add WY 2020-12-20
/// output::YLJGDM,GDZCBM,GDZCMC,LBBM,GG,XH,JLDW,TYBZ,SCCSBM,SYNX,CD,YT,SJSCSJ,YL1
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.Outer.DHCEQForBAZX","GetBasicInfo")
Query GetBasicInfo() As %Query(ROWSPEC = "YLJGDM:%String,GDZCBM:%String,GDZCMC:%String,LBBM:%String,GG:%String,XH:%String,JLDW:%String,TYBZ:%String,SCCSBM:%String,SYNX:%String,CD:%String,YT:%String,SJSCSJ:%String,YL1:%String")
{
}

ClassMethod GetBasicInfoExecute(ByRef qHandle As %Binary) As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=0
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCMasterItem",rowid))  quit:rowid=""  d
	.d BuildDataGetBasicInfo
	Quit $$$OK
BuildDataGetBasicInfo		
	d ResetVariablesGetBasicInfo
	q:$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",8)'="N"   //过滤无效设备项
	s YLJGDM=""    //医疗机构组织机构代码(标注)
	s GDZCBM=""  //固定资产编码(标注)
	s GDZCMC=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",1)   //固定资产名称
	s TCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",4)
	i TCatDR'="" s LBBM=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TCatDR)),"^",1)  //类别编码
	s TModelDR=$o(^DHCEQCCode("DHCEQCModel",0,"MItemDR",rowid,0))
	i TModelDR'="" s GG=##class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)  //规格
	s XH=GG   //型号
	s TUnitDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",7)
	i TUnitDR'="" s JLDW=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)  //单位
	s TYBZ=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",8)  //停用标志 N有效Y无效
	s SCCSBM=""   //生产厂商编码
	s TStatCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",5)
	s SYNX=##Class(web.DHCEQCEquipeCat).GetYearsByCatID(TCatDR,TStatCatDR)  //使用年限
	s CD=""   //产地信息
	s YT=""   //用途
	s SJSCSJ=##class(web.DHCEQCommon).TransValueToPage(+$H,"datetime")  //上传日期
	s YL1=""    //预留一
	d OutputRowGetBasicInfo
	quit
OutputRowGetBasicInfo
	s Data=$lb(YLJGDM,GDZCBM,GDZCMC,LBBM,GG,XH,JLDW,TYBZ,SCCSBM,SYNX,CD,YT,SJSCSJ,YL1)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetBasicInfo
	s (YLJGDM,GDZCBM,GDZCMC,LBBM,GG,XH,JLDW,TYBZ,SCCSBM,SYNX,CD,YT,SJSCSJ,YL1)=""
	quit
}

ClassMethod GetBasicInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBasicInfoExecute ]
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

ClassMethod GetBasicInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBasicInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 宝安中心医院合同接口
/// Input:输入参数  :aStartDate:开始日期(YYYY-MM-DD) aEndDate:结束日期(YYYY-MM-DD)
/// Creator:add WY 2020-12-04 
/// output::YLJGDM,HTH,CGJHDH,QDRQ,HTKSRQ,HTJSRQ,HTLB,GHSBM,HTJJ,HTJE,SJSCSJ,YL1
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.Outer.DHCEQForBAZX","GetContract","2018-03-01","2020-12-25")
Query GetContract(aStartDate As %String = "", aEndDate As %String = "") As %Query(ROWSPEC = "YLJGDM:%String,HTH:%String,CGJHDH:%String,QDRQ:%String,HTKSRQ:%String,HTJSRQ:%String,HTLB:%String,GHSBM:%String,HTJJ:%String,HTJE:%String,SJSCSJ:%String,YL1:%String")
{
}

ClassMethod GetContractExecute(ByRef qHandle As %Binary, aStartDate As %String = "", aEndDate As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=0
 	i aStartDate="" d
	.s aStartDate=+$H
	e  d
	.Set aStartDate=##Class(web.DHCEQCommon).TransValueFromPage(aStartDate,"date")
	i aEndDate="" d
	.s aEndDate=+$H
	e  d
	.Set aEndDate=##Class(web.DHCEQCommon).TransValueFromPage(aEndDate,"date")
	s rowid=0
	f  s rowid=$o(^DHCEQContract(rowid))  q:rowid=""  d
	.d BuildDataGetContract
	Quit $$$OK
BuildDataGetContract		
	d ResetVariablesGetContract
	s TAuditDate=$p($g(^DHCEQContract(rowid)),"^",33)
	q:$p($g(^DHCEQContract(rowid)),"^",39)'="0"   //过滤非采购合同
	q:$p($g(^DHCEQContract(rowid)),"^",24)'="2"   //过滤未审核的合同
	q:(TAuditDate<aStartDate)||(TAuditDate>aEndDate)
	s YLJGDM=""    //医疗机构组织机构代码(标注)
	s HTH=$p($g(^DHCEQContract(rowid)),"^",2) //合同号
	s CGJHDH= "" //采购计划单号(标注)
	s QDRQ=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",7),"date") //签订日期
	s HTKSRQ=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",12),"date") //合同开始日期
	s HTJSRQ=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",13),"date") //合同结束日期 
	s HTLB="2"   //合同类别 1 原始合同 2 最终合同
	s TProviderDR=$p($g(^DHCEQContract(rowid)),"^",18)
	i TProviderDR'="" s GHSBM=$p($g(^DHCEQCCode("DHCEQCVendor",TProviderDR)),"^",1)  //##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)	 //供货商编码
	s HTJJ=""    //合同简介
	s HTJE=$p($g(^DHCEQContract(rowid)),"^",4)  //合同金额
	s SJSCSJ=##class(web.DHCEQCommon).TransValueToPage(+$H,"datetime")  //上传日期
	s YL1=""    //预留一
	d OutputRowGetContract
	quit
OutputRowGetContract
	s Data=$lb(YLJGDM,HTH,CGJHDH,QDRQ,HTKSRQ,HTJSRQ,HTLB,GHSBM,HTJJ,HTJE,SJSCSJ,YL1)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetContract
	s (YLJGDM,HTH,CGJHDH,QDRQ,HTKSRQ,HTJSRQ,HTLB,GHSBM,HTJJ,HTJE,SJSCSJ,YL1)=""
	quit
}

ClassMethod GetContractFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetContractExecute ]
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

ClassMethod GetContractClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetContractExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 宝安中心医院合同明细接口
/// Input:输入参数  :fStartDate:开始日期(YYYY-MM-DD) fEndDate:结束日期(YYYY-MM-DD)
/// Creator:add WY 2020-12-04 
/// output::YLJGDM,HTH,CGJHDH,GDZCBM,GG,XH,PP,SCCSBM,SL,DJ,JHRQ,BXQ,BXDW,SFAZ,SFFK,SFYS,SJSCSJ,YL1
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.Outer.DHCEQForBAZX","GetContractList","2018-03-01","2020-12-25")
Query GetContractList(fStartDate As %String = "", fEndDate As %String = "") As %Query(ROWSPEC = "YLJGDM:%String,HTH:%String,CGJHDH:%String,GDZCBM:%String,GG:%String,XH:%String,PP:%String,SCCSBM:%String,SL:%String,DJ:%String,JHRQ:%String,BXQ:%String,BXDW:%String,SFAZ:%String,SFFK:%String,SFYS:%String,SJSCSJ:%String,YL1:%String")
{
}

ClassMethod GetContractListExecute(ByRef qHandle As %Binary, fStartDate As %String = "", fEndDate As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=0
 	i fStartDate="" d
	.s fStartDate=+$H
	e  d
	.Set fStartDate=##Class(web.DHCEQCommon).TransValueFromPage(fStartDate,"date")
	i fEndDate="" d
	.s fEndDate=+$H
	e  d
	.Set fEndDate=##Class(web.DHCEQCommon).TransValueFromPage(fEndDate,"date")
	s rowid=0
	f  s rowid=$o(^DHCEQContract(rowid))  q:rowid=""  d
	.d BuildDataGetContractList
	Quit $$$OK
BuildDataGetContractList		
	d ResetVariablesGetContractList
	s TAuditDate=$p($g(^DHCEQContract(rowid)),"^",33)
	q:$p($g(^DHCEQContract(rowid)),"^",39)'="0"   //过滤非采购合同
	q:$p($g(^DHCEQContract(rowid)),"^",24)'="2"   //过滤未审核的合同
	q:(TAuditDate<fStartDate)||(TAuditDate>fEndDate)
	s YLJGDM=""    //医疗机构组织机构代码(标注)
	s HTH=$p($g(^DHCEQContract(rowid)),"^",2) //合同号	
	s CGJHDH= "" //采购计划单号(标注)
	s MXRowID=0
	f  s MXRowID=$o(^DHCEQContractList(0,"Contract",rowid,MXRowID))  q:MXRowID=""  d
	.s TItemDR=$p($g(^DHCEQContractList(MXRowID)),"^",18) 
	.i TItemDR'="" s GDZCBM=$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",2)   //固定资产编码(标注)
	.s TModelDR=$p($g(^DHCEQContractList(MXRowID)),"^",3) 
	.i TModelDR'="" s GG=##class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)	 //规格
	.s XH=GG   //型号
	.s PP=""   //品牌(标注)
	.s TManuFacDR=$p($g(^DHCEQContractList(MXRowID)),"^",4)
	.i TManuFacDR'="" s SCCSBM=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFacDR)	 //供货商编码
	.s SL=$p($g(^DHCEQContractList(MXRowID)),"^",7)  //数量
	.s DJ=$p($g(^DHCEQContractList(MXRowID)),"^",6)  //单价
	.s JHRQ=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContractList(MXRowID)),"^",10),"date") //交货日期
	.s BXQ=$p($g(^DHCEQContract(rowid)),"^",23) //保修期(月)
	.s TServiceDR=$p($g(^DHCEQContract(rowid)),"^",36)
	.i TServiceDR'=""  s BXDW=##class(web.DHCEQCommon).GetTrakNameByID("service",TServiceDR)      //保修单位
	.s SFAZ=""      //是否安装(标注)
	.s SFFK=""      //是否付款(标注)
	.s SFYS=""      //是否验收(标注)
	.s SJSCSJ=##class(web.DHCEQCommon).TransValueToPage(+$H,"datetime")  //上传日期
	.s YL1=""    //预留一
	.d OutputRowGetContractList
	quit
OutputRowGetContractList
	s Data=$lb(YLJGDM,HTH,CGJHDH,GDZCBM,GG,XH,PP,SCCSBM,SL,DJ,JHRQ,BXQ,BXDW,SFAZ,SFFK,SFYS,SJSCSJ,YL1)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetContractList
	s (YLJGDM,HTH,CGJHDH,GDZCBM,GG,XH,PP,SCCSBM,SL,DJ,JHRQ,BXQ,BXDW,SFAZ,SFFK,SFYS,SJSCSJ,YL1)=""
	quit
}

ClassMethod GetContractListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetContractListExecute ]
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

ClassMethod GetContractListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetContractListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 宝安中心医院采购计划接口
/// Input:输入参数  :GStartDate:开始日期(YYYY-MM-DD) GEndDate:结束日期(YYYY-MM-DD)
/// Creator:add WY 2020-12-04 
/// output::YLJGDM,CGJHDH,ZY,BZ,TBRXM,TBRQ,SPRXM,SPYJ,SPRQ,ZT,BZBM,SJSCSJ,YL1
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.Outer.DHCEQForBAZX","GetBuyPlan","2018-03-01","2020-12-25")
Query GetBuyPlan(GStartDate As %String = "", GEndDate As %String = "") As %Query(ROWSPEC = "YLJGDM:%String,CGJHDH:%String,ZY:%String,BZ:%String,TBRXM:%String,TBRQ:%String,SPRXM:%String,SPYJ:%String,SPRQ:%String,ZT:%String,BZBM:%String,SJSCSJ:%String,YL1:%String")
{
}

ClassMethod GetBuyPlanExecute(ByRef qHandle As %Binary, GStartDate As %String = "", GEndDate As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=0
 	i GStartDate="" d
	.s GStartDate=+$H
	e  d
	.Set GStartDate=##Class(web.DHCEQCommon).TransValueFromPage(GStartDate,"date")
	i GEndDate="" d
	.s GEndDate=+$H
	e  d
	.Set GEndDate=##Class(web.DHCEQCommon).TransValueFromPage(GEndDate,"date")
	s rowid=0
	For  set rowid=$Order(^DHCEQBuyPlan(rowid))  Quit:rowid=""  Do
	.d BuildDataGetBuyPlan
	Quit $$$OK
BuildDataGetBuyPlan		
	d ResetVariablesGetBuyPlan
	s TAuditDate=$p($g(^DHCEQBuyPlan(rowid)),"^",17)
	q:$p($g(^DHCEQBuyPlan(rowid)),"^",46)'="N"   //过滤无效采购计划
	q:$p($g(^DHCEQBuyPlan(rowid)),"^",6)'="2"  //过滤未审核的采购计划
	q:(TAuditDate<GStartDate)||(TAuditDate>GEndDate)
	s YLJGDM=""    //医疗机构组织机构代码(标注)
	s CGJHDH=$p($g(^DHCEQBuyPlan(rowid)),"^",25) //采购计划单号
	s ZY=""    //摘要
	s BZ=$p($g(^DHCEQBuyPlan(rowid)),"^",4)    //备注
	s TAddUserDR=$p($g(^DHCEQBuyPlan(rowid)),"^",19)
	i TAddUserDR'="" s TBRXM=##class(web.DHCEQCommon).GetTrakNameByID("user",TAddUserDR)	 //填报人姓名
	s TBRQ=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQBuyPlan(rowid)),"^",20),"date") //填报日期
	s TAuditUserDR=$p($g(^DHCEQBuyPlan(rowid)),"^",16)
	i TAuditUserDR'="" s SPRXM=##class(web.DHCEQCommon).GetTrakNameByID("user",TAuditUserDR)	 //审批人姓名?
	s SPYJ="1"   //审批意见?
	s SPRQ=##class(web.DHCEQCommon).TransValueToPage(TAuditDate,"date")  //审批日期?
	s ZT=$p($g(^DHCEQBuyPlan(rowid)),"^",6)   //0:新增|1:提交|2:审核|3:作废
	s BZBM=""    //编制部门(标注)
	s SJSCSJ=##class(web.DHCEQCommon).TransValueToPage(+$H,"datetime")  //上传日期
	s YL1=""    //预留一
	d OutputRowGetBuyPlan
	quit
OutputRowGetBuyPlan
	s Data=$lb(YLJGDM,CGJHDH,ZY,BZ,TBRXM,TBRQ,SPRXM,SPYJ,SPRQ,ZT,BZBM,SJSCSJ,YL1)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetBuyPlan
	s (YLJGDM,CGJHDH,ZY,BZ,TBRXM,TBRQ,SPRXM,SPYJ,SPRQ,ZT,BZBM,SJSCSJ,YL1)=""
	quit
}

ClassMethod GetBuyPlanFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBuyPlanExecute ]
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

ClassMethod GetBuyPlanClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBuyPlanExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 宝安中心医院计划明细接口
/// Input:输入参数  :eStartDate:开始日期(YYYY-MM-DD) eEndDate:结束日期(YYYY-MM-DD)
/// Creator:add WY 2020-12-04 
/// output::YLJGDM,CGJHDH,GDZCBM,JHDHRQ,JHDJ,CGSL,CGY,XQKS,SJSCSJ,YL1
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.Outer.DHCEQForBAZX","GetBuyPlanList","2018-03-01","2020-12-25")
Query GetBuyPlanList(eStartDate As %String = "", eEndDate As %String = "") As %Query(ROWSPEC = "YLJGDM:%String,CGJHDH:%String,GDZCBM:%String,JHDHRQ:%String,JHDJ:%String,CGSL:%String,CGY:%String,XQKS:%String,SJSCSJ:%String,YL1:%String")
{
}

ClassMethod GetBuyPlanListExecute(ByRef qHandle As %Binary, eStartDate As %String = "", eEndDate As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=0
 	i eStartDate="" d
	.s eStartDate=+$H
	e  d
	.Set eStartDate=##Class(web.DHCEQCommon).TransValueFromPage(eStartDate,"date")
	i eEndDate="" d
	.s eEndDate=+$H
	e  d
	.Set eEndDate=##Class(web.DHCEQCommon).TransValueFromPage(eEndDate,"date")
	s rowid=0
	For  set rowid=$Order(^DHCEQBuyPlan(rowid))  Quit:rowid=""  Do
	.d BuildDataGetBuyPlanList
	Quit $$$OK
BuildDataGetBuyPlanList		
	d ResetVariablesGetBuyPlanList
	s TAuditDate=$p($g(^DHCEQBuyPlan(rowid)),"^",17)
	q:$p($g(^DHCEQBuyPlan(rowid)),"^",46)'="N"   //过滤无效采购计划
	q:$p($g(^DHCEQBuyPlan(rowid)),"^",6)'="2"  //过滤未审核的采购计划
	q:(TAuditDate<eStartDate)||(TAuditDate>eEndDate)
	s YLJGDM=""    //医疗机构组织机构代码(标注)
	s CGJHDH=$p($g(^DHCEQBuyPlan(rowid)),"^",25) //采购计划单号
	s BPLRowID=0
	f  s BPLRowID=$Order(^DHCEQBuyPlanList(0,"BuyPlan",rowid,BPLRowID))  q:BPLRowID=""  d
	.s JHDHRQ=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQBuyPlanList(BPLRowID)),"^",19),"date")   //计划到货日期(标注)
    .s TItemDR=$p($g(^DHCEQBuyPlanList(BPLRowID)),"^",18) 
	.i TItemDR'="" s GDZCBM=$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",2)  //固定资产编码(取设备项编码标注)

	.s JHDJ=$p($g(^DHCEQBuyPlanList(BPLRowID)),"^",6)   //计划单价
	.s CGSL=$p($g(^DHCEQBuyPlanList(BPLRowID)),"^",7)   //采购数量
	.s CGY=""   //采购员
	.s XQKS=""   //需求科室代码(标注)
	.s SJSCSJ=##class(web.DHCEQCommon).TransValueToPage(+$H,"datetime")  //上传日期
	.s YL1=""    //预留一
	.d OutputRowGetBuyPlanList
	quit
OutputRowGetBuyPlanList
	s Data=$lb(YLJGDM,CGJHDH,GDZCBM,JHDHRQ,JHDJ,CGSL,CGY,XQKS,SJSCSJ,YL1)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetBuyPlanList
	s (YLJGDM,CGJHDH,GDZCBM,JHDHRQ,JHDJ,CGSL,CGY,XQKS,SJSCSJ,YL1)=""
	quit
}

ClassMethod GetBuyPlanListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBuyPlanListExecute ]
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

ClassMethod GetBuyPlanListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBuyPlanListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 宝安中心医院验收接口
/// Input:输入参数  :pStartDate:开始日期(YYYY-MM-DD) pEndDate:结束日期(YYYY-MM-DD)
/// Creator:add WY 2020-12-04 
/// output::YLJGDM,YSDH,XQKS,YSRQ,YSRXM,HTH,XQKSYSRXM,PYDW,ZDRXM,ZDRQ,SHRXM,SHRQ,ZT,SJSCSJ,YL1
/// 医疗机构组织机构代码,验收单号,需求科室代码,验收日期,验收人姓名,合同号,需求科室验收人姓名,培训单位,制单人姓名,制单日期,审核人姓名,审核日期,固定资产验收状态代码,数据上传时间,预留一
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.Outer.DHCEQForBAZX","GetOpenCheckRequest","2018-03-01","2019-3-25")
Query GetOpenCheckRequest(StartDate As %String = "", EndDate As %String = "") As %Query(ROWSPEC = "YLJGDM:%String,YSDH:%String,XQKS:%String,YSRQ:%String,YSRXM:%String,HTH:%String,XQKSYSRXM:%String,PYDW:%String,ZDRXM:%String,ZDRQ:%String,SHRXM:%String,SHRQ:%String,ZT:%String,SJSCSJ:%String,YL1:%String")
{
}

ClassMethod GetOpenCheckRequestExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=0
 	i StartDate="" d
	.s StartDate=+$H-1
	e  d
	.Set StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	i EndDate="" d
	.s EndDate=+$H
	e  d
	.Set EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	s rowid=0
	For  Set rowid=$Order(^DHCEQOpenCheckRequest(rowid))  Quit:rowid=""  Do
	.d BuildDataGetOpenCheckRequest
	Quit $$$OK
BuildDataGetOpenCheckRequest		
	d ResetVariablesGetOpenCheckRequest
	q:$p($g(^DHCEQOpenCheckRequest(rowid)),"^",45)="Y" //过滤无效验收单
	q:($p($g(^DHCEQOpenCheckRequest(rowid)),"^",10)>EndDate)||($p($g(^DHCEQOpenCheckRequest(rowid)),"^",10)<StartDate)   //通过验收日期过滤时间的验收单
	s OpenCheckList=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",rowid,0)) //设备批量申请明细单ID
	s YLJGDM=""    //医疗机构组织机构代码(标注)
	s YSDH=$p($g(^DHCEQOpenCheckRequest(rowid)),"^",37) //验收单号
	s TUseLocDR=$p($g(^DHCEQOpenCheckList(OpenCheckList)),"^",33)  //需求科室代码
	i TUseLocDR'="" s XQKS=##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)	
	s YSRQ=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOpenCheckRequest(rowid)),"^",10),"date") //验收日期
	s YSRXM=$p($g(^DHCEQOpenCheckRequest(rowid)),"^",19)   //验收人姓名
	s HTH=$p($g(^DHCEQOpenCheckList(OpenCheckList)),"^",36)  //合同号
	s XQKSYSRXM=""   //需求科室验收人姓名
	s PYDW=""        //培训单位
	s TSubmitUserDR=$p($g(^DHCEQOpenCheckRequest(rowid)),"^",22)  //
	i TSubmitUserDR'="" s ZDRXM=##class(web.DHCEQCommon).GetTrakNameByID("user",TSubmitUserDR)
	s ZDRQ=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOpenCheckRequest(rowid)),"^",23),"date")
	s TAuditUserDR=$p($g(^DHCEQOpenCheckRequest(rowid)),"^",25)  //审核人姓名
	i TAuditUserDR'="" s SHRXM=##class(web.DHCEQCommon).GetTrakNameByID("user",TAuditUserDR)
	s SHRQ=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOpenCheckRequest(rowid)),"^",26),"date")  //审核日期
	s ZT=$p($g(^DHCEQOpenCheckRequest(rowid)),"^",20) //状态 0:新增|1:提交|2:审核
	s SJSCSJ=##class(web.DHCEQCommon).TransValueToPage(+$H,"datetime")  //上传日期
	s YL1=""    //预留一
	d OutputRowGetOpenCheckRequest
	quit
OutputRowGetOpenCheckRequest
	s Data=$lb(YLJGDM,YSDH,XQKS,YSRQ,YSRXM,HTH,XQKSYSRXM,PYDW,ZDRXM,ZDRQ,SHRXM,SHRQ,ZT,SJSCSJ,YL1)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetOpenCheckRequest
	s (YLJGDM,YSDH,XQKS,YSRQ,YSRXM,HTH,XQKSYSRXM,PYDW,ZDRXM,ZDRQ,SHRXM,SHRQ,ZT,SJSCSJ,YL1)=""
	quit
}

ClassMethod GetOpenCheckRequestFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOpenCheckRequestExecute ]
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

ClassMethod GetOpenCheckRequestClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOpenCheckRequestExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 宝安中心医院入库接口
/// Input:输入参数  :pStartDate:开始日期(YYYY-MM-DD) pEndDate:结束日期(YYYY-MM-DD)
/// Creator:add WY 2020-12-04 
/// output::YLJGDM,RKDH,GDZCKPH,GDZCBM,GDZCMC,GDZCFL,TMH,ZBHRQ,KJND,KJYF,GG,XH,PP,CGRQ,CGND,CGPZ,CGRXM,DJ,SCCSMC,SCCSGB,GYSBM,GYSMC,SYZT,HQFS,GDZCYT,GDZCGSBM,GSKSBM,CKBM,RKKSDM,RKRQ,GDZCYZ,GDZCXZ,LJZJ,ZJNX,ZCGS,YSRQ,QYRQ,ZRRXM,SJSCSJ,YL1
/// 医疗机构组织机 构代码,入库单号,固定资产卡片号,固定资产编码,固定资产名称,固定资产分类,条码号,资本化日期,会计年度,会计月份,规格,型号,品牌,采购日期,采购年度,采购凭证,采购人姓名,单价,生产厂商名称,生产厂商国别,供应商编码,供应商名称,使用状态,获取方式,固定资产用途,固定资产归属编 码,归属科室编码,仓库编码,入库科室代码,入库日期,固定资产原值,固定资产现值,累计折旧,折旧年限,资产归属,验收日期,启用日期,责任人姓名,数据上传时间,预留一
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.Outer.DHCEQForBAZX","GetInStock","2018-03-01","2019-3-25")
Query GetInStock(pStartDate As %String = "", pEndDate As %String = "") As %Query(ROWSPEC = "YLJGDM:%String,RKDH:%String,GDZCKPH:%String,GDZCBM:%String,GDZCMC:%String,GDZCFL:%String,TMH:%String,ZBHRQ:%String,KJND:%String,KJYF:%String,GG:%String,XH:%String,PP:%String,CGRQ:%String,CGND:%String,CGPZ:%String,CGRXM:%String,DJ:%String,SCCSMC:%String,SCCSGB:%String,GYSBM:%String,GYSMC:%String,SYZT:%String,HQFS:%String,GDZCYT:%String,GDZCGSBM:%String,GSKSBM:%String,CKBM:%String,RKKSDM:%String,RKRQ:%String,GDZCYZ:%String,GDZCXZ:%String,LJZJ:%String,ZJNX:%String,ZCGS:%String,YSRQ:%String,QYRQ:%String,ZRRXM:%String,SJSCSJ:%String,YL1:%String") [ SqlProc ]
{
}

ClassMethod GetInStockExecute(ByRef qHandle As %Binary, pStartDate As %String = "", pEndDate As %String = "") As %Status
{
	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 		
 	i pStartDate="" d
	.s pStartDate=+$H-1
	e  d
	.Set pStartDate=##Class(web.DHCEQCommon).TransValueFromPage(pStartDate,"date")
	i pEndDate="" d
	.s pEndDate=+$H
	e  d
	.Set pEndDate=##Class(web.DHCEQCommon).TransValueFromPage(pEndDate,"date")
	//入库
	s EquipTypeDR=0
	f  s EquipTypeDR=$o(^DHCEQInStock(0,"TypeDate",EquipTypeDR)) q:EquipTypeDR=""  d
	.d ResetVariablesGetInStock
	.s BillDate=pStartDate
	.f  s BillDate=$o(^DHCEQInStock(0,"TypeDate",EquipTypeDR,BillDate)) q:(BillDate="")||(BillDate>pEndDate)  d
	..s InStockDR=0
	..f  s InStockDR=$o(^DHCEQInStock(0,"TypeDate",EquipTypeDR,BillDate,InStockDR)) q:InStockDR=""  d
	...q:($p($g(^DHCEQInStock(InStockDR)),"^",25)="Y")      //过滤无效入库单
	...q:($p($g(^DHCEQInStock(InStockDR)),"^",10)'="2")     //过滤未审核入库单
	...s YLJGDM=""    //医疗机构组织机构代码(标注)
	...s RKDH=$p($g(^DHCEQInStock(InStockDR)),"^",14)   //入库单号
	...s ZBHRQ=$p($g(^DHCEQInStock(InStockDR)),"^",13)  //资本化日期
	...s KJND=""    //会计年度(标注)
	...s KJYF=""   //会计月份(标注)
	...s CGND=##class(web.DHCEQCommon).TransValueToPage(ZBHRQ,"date")   //采购年度
	...s CGND=$p(CGND,"-",1)
	...s CGPZ=""   //采购凭证(标注)
	...s CGRXM=""  //采购人姓名(标注)
	...s EquipTypeDR=$p($g(^DHCEQInStock(InStockDR)),"^",20)
	...i EquipTypeDR'=""  s GDZCGSBM=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",1) //固定资产归属编码对照DHC_EQCEquipType
    ...s GSKSBM=""    //归属科室编码(标注)
    ...s RKKSDM=""    //入库科室代码
    ...s RKRQ=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInStock(InStockDR)),"^",7),"date")  //入库日期
	...s ZCGS=""     //资产归属
	...s TProviderDR=$p($g(^DHCEQInStock(InStockDR)),"^",17)
	...i TProviderDR'="" d
	....s GYSBM=$p($g(^DHCEQCCode("DHCEQCVendor",TProviderDR)),"^",1)  //供应商编码
	....s GYSMC=##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)  //供应商名称	
	...s TLocDR=$p($g(^DHCEQInStock(InStockDR)),"^",2)
	...i TLocDR'="" s CKBM=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)    //
	...
	...s InStockListDR=0
	...f  s InStockListDR=$o(^DHCEQInStockList(0,"InStock",InStockDR,InStockListDR)) q:InStockListDR=""  d
	....s GG=$p($g(^DHCEQInStockList(InStockListDR)),"^",9)   //规格
	....s XH=$p($g(^DHCEQInStockList(InStockListDR)),"^",9)   //型号
	....s DJ=$p($g(^DHCEQInStockList(InStockListDR)),"^",7)   //单价
	....s GDZCYZ=$p($g(^DHCEQInStockList(InStockListDR)),"^",7) //固定资产原值
	....s EquipDR=0
	....f  s EquipDR=$o(^DHCEQEquip(0,"InStockList",InStockListDR,TLocDR,EquipDR)) q:EquipDR=""  d
	.....s GDZCKPH=$p($g(^DHCEQEquip(EquipDR)),"^",71)           //固定资产卡片号
	.....s GDZCBM=$p($g(^DHCEQEquip(EquipDR)),"^",6)            //固定资产编码
	.....s GDZCMC=$p($g(^DHCEQEquip(EquipDR)),"^",1)            //固定资产名称
    .....s TEquiCatDR=$p($g(^DHCEQEquip(EquipDR)),"^",4) 
    .....i TEquiCatDR'="" s GDZCFL=##Class(web.DHCEQCommon).GetTrakNameByID("equipcat",TEquiCatDR)  //固定资产分类
    .....s TMH=$p($g(^DHCEQEquip(EquipDR)),"^",71)    //条码号取设备编号
    .....s TBrandDR=$p($g(^DHCEQEquip(EquipDR)),"^",94)
    .....i TBrandDR'="" s PP=##class(web.DHCEQCommon).GetTrakNameByID("barnd",TBrandDR)  
    .....;s PP=$p($g(^DHCEQEquip(EquipDR)),"^",74)     //品牌
    .....s TManuFactoryDR=$p($g(^DHCEQEquip(EquipDR)),"^",26)
    .....i TManuFactoryDR'=""  s SCCSMC=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)   //生产厂商名称
 	.....s TCountryDR=$p($g(^DHCEQEquip(EquipDR)),"^",16)
 	.....i TCountryDR'="" s SCCSGB=##Class(web.DHCEQCommon).GetTrakNameByID("cou",TCountryDR)     //生产厂商国别
    .....s SYZT=$p($g(^DHCEQEquip(EquipDR)),"^",38)
    .....s OriginDR=$p($g(^DHCEQEquip(EquipDR)),"^",20)
    .....i OriginDR'="" s HQFS=##Class(web.DHCEQCommon).GetTrakNameByID("origin",OriginDR)   //获取方式
    .....s PurposeTypeDR=$p($g(^DHCEQEquip(EquipDR)),"^",65)
    .....i PurposeTypeDR'="" s GDZCYT=##Class(web.DHCEQCommon).GetTrakNameByID("purchase",PurposeTypeDR)  //用途
	.....s GDZCXZ=$p($g(^DHCEQEquip(EquipDR)),"^",27) //固定资产现值
	.....s LJZJ=+$p($g(^DHCEQEquip(EquipDR)),"^",35)   //累计折旧,未入库设备折旧为0
	.....s ZJNX=$p($g(^DHCEQEquip(EquipDR)),"^",31)   //折旧年限
	.....s YSRQ=$p($g(^DHCEQEquip(EquipDR)),"^",13)   //验收日期
	.....s QYRQ=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(EquipDR)),"^",44),"date")  //启用日期
    .....s TKeeperDR=$p($g(^DHCEQEquip(EquipDR)),"^",66)
    .....s ZRRXM=##Class(web.DHCEQCommon).GetTrakNameByID("user",TKeeperDR)
    .....s ContractListDR=$p($g(^DHCEQEquip(EquipDR)),"^",32)
	.....s CGRQ=""
    .....i ContractListDR'="" d
    ......s ContractDR=$p($g(^DHCEQContractList(ContractListDR)),"^",2)  
	......s CGRQ=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(ContractDR)),"^",33),"date")  //采购日期
	.....s SJSCSJ=##class(web.DHCEQCommon).TransValueToPage(+$H,"datetime")  //上传日期
	.....s YL1=""  //预留一
 	.....d OutputRowGetInStock	
 	Quit $$$OK	
ResetVariablesGetInStock
	s (YLJGDM,RKDH,GDZCKPH,GDZCBM,GDZCMC,GDZCFL,TMH,ZBHRQ,KJND,KJYF,GG,XH,PP,CGRQ,CGND,CGPZ,CGRXM,DJ,SCCSMC,SCCSGB,GYSBM,GYSMC,SYZT,HQFS,GDZCYT,GDZCGSBM,GSKSBM,CKBM,RKKSDM,RKRQ,GDZCYZ,GDZCXZ,LJZJ,ZJNX,ZCGS,YSRQ,QYRQ,ZRRXM,SJSCSJ,YL1)=""
	quit	 	
OutputRowGetInStock
	s Data=$lb(YLJGDM,RKDH,GDZCKPH,GDZCBM,GDZCMC,GDZCFL,TMH,ZBHRQ,KJND,KJYF,GG,XH,PP,CGRQ,CGND,CGPZ,CGRXM,DJ,SCCSMC,SCCSGB,GYSBM,GYSMC,SYZT,HQFS,GDZCYT,GDZCGSBM,GSKSBM,CKBM,RKKSDM,RKRQ,GDZCYZ,GDZCXZ,LJZJ,ZJNX,ZCGS,YSRQ,QYRQ,ZRRXM,SJSCSJ,YL1)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetInStockFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInStockExecute ]
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

ClassMethod GetInStockClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInStockExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// 宝安中心医院入库明细接口
/// Input:输入参数  :vStartDate:开始日期(YYYY-MM-DD) vEndDate:结束日期(YYYY-MM-DD)
/// Creator:add WY 2020-12-04 
/// output::YLJGDM,RKDH,GDZCBM,GG,XH,PP,SCCSMC,ZZG,JLDW,RKDJ,SL,ZJJE,KPJE,FKJE,QCKPJE,QCFKJE,BZ,LSKPH,HTH,TXM,CGDJ,SFFJ,SJSCSJ,YL1
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.Outer.DHCEQForBAZX","GetInStockList","2018-03-01","2019-3-25")
Query GetInStockList(vStartDate As %String = "", vEndDate As %String = "") As %Query(ROWSPEC = "YLJGDM:%String,RKDH:%String,GDZCBM:%String,GG:%String,XH:%String,PP:%String,SCCSMC:%String,ZZG:%String,JLDW:%String,RKDJ:%String,SL:%String,ZJJE:%String,KPJE:%String,FKJE:%String,QCKPJE:%String,QCFKJE:%String,BZ:%String,LSKPH:%String,HTH:%String,TXM:%String,CGDJ:%String,SFFJ:%String,SJSCSJ:%String,YL1:%String") [ SqlProc ]
{
}

ClassMethod GetInStockListExecute(ByRef qHandle As %Binary, vStartDate As %String = "", vEndDate As %String = "") As %Status
{
	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1	
 	i vStartDate="" d
	.s vStartDate=+$H-1
	e  d
	.Set vStartDate=##Class(web.DHCEQCommon).TransValueFromPage(vStartDate,"date")
	i vEndDate="" d
	.s vEndDate=+$H
	e  d
	.Set vEndDate=##Class(web.DHCEQCommon).TransValueFromPage(vEndDate,"date")
	//入库
	s EquipTypeDR=0
	f  s EquipTypeDR=$o(^DHCEQInStock(0,"TypeDate",EquipTypeDR)) q:EquipTypeDR=""  d
	.d ResetVariablesGetInStockList
	.s BillDate=vStartDate
	.f  s BillDate=$o(^DHCEQInStock(0,"TypeDate",EquipTypeDR,BillDate)) q:(BillDate="")||(BillDate>vEndDate)  d
	..s InStockDR=0
	..f  s InStockDR=$o(^DHCEQInStock(0,"TypeDate",EquipTypeDR,BillDate,InStockDR)) q:InStockDR=""  d
	...q:($p($g(^DHCEQInStock(InStockDR)),"^",25)="Y")      //过滤无效入库单
	...q:($p($g(^DHCEQInStock(InStockDR)),"^",10)'="2")     //过滤未审核入库单
	...s YLJGDM=""    //医疗机构组织机构代码(标注)
	...s RKDH=$p($g(^DHCEQInStock(InStockDR)),"^",14)   //入库单号
	...s BZ= $p($g(^DHCEQInStock(InStockDR)),"^",11)                  //备注
	
	...s TLocDR=$p($g(^DHCEQInStock(InStockDR)),"^",2)
	...s InStockListDR=0
	...f  s InStockListDR=$o(^DHCEQInStockList(0,"InStock",InStockDR,InStockListDR)) q:InStockListDR=""  d
	....s GG=$p($g(^DHCEQInStockList(InStockListDR)),"^",9)   //规格
	....s XH=$p($g(^DHCEQInStockList(InStockListDR)),"^",9)   //型号
	....s RKDJ=$p($g(^DHCEQInStockList(InStockListDR)),"^",7)   //单价
	....s SL=$p($g(^DHCEQInStockList(InStockListDR)),"^",8)   //数量
	....s ZJJE=RKDJ*SL    //增加金额(标注)
	....s KPJE=""       //开票金额(标注)
	....s FKJE=""       //付款金额(标注)
	....s QCKPJE=""     //期初开票金额(标注)
	....s QCFKJE=""   //期初付款金额(标注)
	....s CGDJ=$p($g(^DHCEQInStockList(InStockListDR)),"^",7)   //采购单价	
	....s EquipDR=0
	....f  s EquipDR=$o(^DHCEQEquip(0,"InStockList",InStockListDR,TLocDR,EquipDR)) q:EquipDR=""  d
    .....s TBrandDR=$p($g(^DHCEQEquip(EquipDR)),"^",94)
    .....i TBrandDR'="" s PP=##class(web.DHCEQCommon).GetTrakNameByID("barnd",TBrandDR)  
    .....;s PP=$p($g(^DHCEQEquip(EquipDR)),"^",74)     //品牌
    .....s TManuFactoryDR=$p($g(^DHCEQEquip(EquipDR)),"^",26)
    .....i TManuFactoryDR'=""  s SCCSMC=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)   //生产厂商名称
 	.....s TCountryDR=$p($g(^DHCEQEquip(EquipDR)),"^",16)
 	.....i TCountryDR'="" s ZZG=##Class(web.DHCEQCommon).GetTrakNameByID("cou",TCountryDR)     //生产厂商国别
    .....s TUnitDR=$p($g(^DHCEQEquip(EquipDR)),"^",5)
 	.....i TUnitDR'="" s JLDW=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)     //生产厂商国别
 	.....s LSKPH=$p($g(^DHCEQEquip(EquipDR)),"^",71)    //临时卡片号
 	.....s TXM=$p($g(^DHCEQEquip(EquipDR)),"^",71)    //条形码
    .....i ContractListDR'="" d
    ......s ContractDR=$p($g(^DHCEQContractList(ContractListDR)),"^",2)  
	......s HTH=$p($g(^DHCEQContract(ContractDR)),"^",2)  //合同号
	......s CGDJ=$p($g(^DHCEQContractList(ContractListDR)),"^",6)   //采购单价,有合同时取合同单价
	.....e  d
	......s CGDJ=$p($g(^DHCEQInStockList(InStockListDR)),"^",7)   //采购单价，没有合同取入库单价格
 	.....s AFRowID=$o(^DHCEQAffix(0,"Equip",EquipDR,0))
 	.....i AFRowID'="" d
 	......s SFFJ="Y" 
 	.....e  d
 	......s SFFJ="N"
	.....s SJSCSJ=##class(web.DHCEQCommon).TransValueToPage(+$H,"datetime")  //上传日期
	.....s YL1=""  //预留一
 	.....d OutputRowGetInStockList	
 	
 	Quit $$$OK	
ResetVariablesGetInStockList
	s (YLJGDM,RKDH,GDZCBM,GG,XH,PP,SCCSMC,ZZG,JLDW,RKDJ,SL,ZJJE,KPJE,FKJE,QCKPJE,QCFKJE,BZ,LSKPH,HTH,TXM,CGDJ,SFFJ,SJSCSJ,YL1)=""
	quit	 	
OutputRowGetInStockList
	s Data=$lb(YLJGDM,RKDH,GDZCBM,GG,XH,PP,SCCSMC,ZZG,JLDW,RKDJ,SL,ZJJE,KPJE,FKJE,QCKPJE,QCFKJE,BZ,LSKPH,HTH,TXM,CGDJ,SFFJ,SJSCSJ,YL1)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
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

/// 宝安中心医院出库接口
/// Input:输入参数  :StartDate:开始日期(YYYY-MM-DD) EndDate:结束日期(YYYY-MM-DD)
/// YLJGDM,CKDH,FFRXM,JSRXM,BZ,ZDRXM,ZDRQ,SHRXM,ZT,ZCCK,LYKS,QRRXM,GDZCGSBM,CKBM,KSDM,JE,CKLX,SJSCSJ,YL1
/// Creator:add WY 2020-12-04 
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.Outer.DHCEQForBAZX","GetStoreMove","2018-03-01","2020-10-12")
Query GetStoreMove(bStartDate As %String = "", bEndDate As %String = "") As %Query(ROWSPEC = "YLJGDM:%String,CKDH:%String,FFRXM:%String,JSRXM:%String,BZ:%String,ZDRXM:%String,ZDRQ:%String,SHRXM:%String,ZT:%String,ZCCK:%String,LYKS:%String,QRRXM:%String,GDZCGSBM:%String,CKBM:%String,KSDM:%String,JE:%String,CKLX:%String,SJSCSJ:%String,YL1:%String") [ SqlProc ]
{
}

ClassMethod GetStoreMoveExecute(ByRef qHandle As %Binary, bStartDate As %String = "", bEndDate As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1	
 	i bStartDate="" d
	.s bStartDate=+$H-1
	e  d
	.Set bStartDate=##Class(web.DHCEQCommon).TransValueFromPage(bStartDate,"date")
	i bEndDate="" d
	.s bEndDate=+$H
	e  d
	.Set bEndDate=##Class(web.DHCEQCommon).TransValueFromPage(bEndDate,"date")
 	s EquipTypeDR=0
	f  s EquipTypeDR=$o(^DHCEQStoreMove(0,"TypeDate",EquipTypeDR)) q:EquipTypeDR=""  d
	.s BillDate=bStartDate
	.f  s BillDate=$o(^DHCEQStoreMove(0,"TypeDate",EquipTypeDR,BillDate)) q:((BillDate="")||(BillDate>bEndDate))  d
	..s SMRowID=0
	..f  s SMRowID=$o(^DHCEQStoreMove(0,"TypeDate",EquipTypeDR,BillDate,SMRowID)) q:(SMRowID="")  d
 	...d ResetVariablesGetGetStoreMove
 	...q:$p($g(^DHCEQStoreMove(SMRowID)),"^",12)'=0    //过滤非出库类型转移
 	...q:$p($g(^DHCEQStoreMove(SMRowID)),"^",27)'="N"   //过滤无效出库单
 	...q:$p($g(^DHCEQStoreMove(SMRowID)),"^",13)'=2    //过滤未审核的出库单
	...s YLJGDM=""    //医疗机构组织机构代码(标注)
 	...s CKDH=$p($g(^DHCEQStoreMove(SMRowID)),"^",1)   //出库单号
 	...s FFRXM=""             //发放人姓名
 	...s TReciverDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",15)
 	...i TReciverDR'="" s JSRXM=##class(web.DHCEQCommon).GetTrakNameByID("user",TReciverDR) //接收人姓名
 	...s BZ=$p($g(^DHCEQStoreMove(SMRowID)),"^",14)                     // 备注 
 	...s TMakerDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",4)
 	...i TMakerDR'="" s ZDRXM=##class(web.DHCEQCommon).GetTrakNameByID("user",TMakerDR) //制单人姓名
 	...s ZDRQ=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQStoreMove(SMRowID)),"^",5),"date")  //制单日期
 	...s TInAckUserDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",9)
 	...i TInAckUserDR'="" s SHRXM=##class(web.DHCEQCommon).GetTrakNameByID("user",TInAckUserDR) //审核人姓名
 	...s ZT=$p($g(^DHCEQStoreMove(SMRowID)),"^",13)
 	...s TFromLocDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",2)
 	...i TFromLocDR'="" d
 	....s ZCCK=##class(web.DHCEQCommon).GetTrakNameByID("dept",TFromLocDR)   //转出仓库
 	....s CKBM=##class(web.DHCEQCommon).GetTrakNameByID("deptcode",TFromLocDR)   //仓库编码
 	...s TToLocDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",3)
 	...i TToLocDR'="" d
 	....s LYKS=##class(web.DHCEQCommon).GetTrakNameByID("dept",TToLocDR)    //领用科室
 	....s KSDM=##class(web.DHCEQCommon).GetTrakNameByID("deptcode",TToLocDR)  //科室编码
 	...s QRRXM=SHRXM   //确认人姓名取值审核人姓名
 	...s CKLX=$p($g(^DHCEQStoreMove(SMRowID)),"^",12)   //出库类型
	...s EquipTypeDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",16)
	...i EquipTypeDR'=""  s GDZCGSBM=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",1) //固定资产归属编码对照DHC_EQCEquipType
 	...s JE=""
 	...s SMLRowID=0
 	...f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",SMRowID,SMLRowID))  q:SMLRowID=""  d
 	....s TQuantity=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",8)
 	....s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQStoreMoveList(SMLRowID)),"^",7),"",2)
	....i JE="" d
	.....Set JE=##Class(web.DHCEQCommon).FormatNumber(TQuantity*TOriginalFee,"",2)
	....e  d
	.....s JE=JE+(##Class(web.DHCEQCommon).FormatNumber(TQuantity*TOriginalFee,"",2))  //金额
	...s SJSCSJ=##class(web.DHCEQCommon).TransValueToPage(+$H,"datetime")  //上传日期
	...s YL1=""  //预留一
 	...d OutputRowGetGetStoreMove
	Quit $$$OK
OutputRowGetGetStoreMove
	s Data=$lb(YLJGDM,CKDH,FFRXM,JSRXM,BZ,ZDRXM,ZDRQ,SHRXM,ZT,ZCCK,LYKS,QRRXM,GDZCGSBM,CKBM,KSDM,JE,CKLX,SJSCSJ,YL1)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetGetStoreMove
	s (YLJGDM,CKDH,FFRXM,JSRXM,BZ,ZDRXM,ZDRQ,SHRXM,ZT,ZCCK,LYKS,QRRXM,GDZCGSBM,CKBM,KSDM,JE,CKLX,SJSCSJ,YL1)=""
	quit
}

ClassMethod GetStoreMoveFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStoreMoveExecute ]
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

ClassMethod GetStoreMoveClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStoreMoveExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// 宝安中心医院出库明细接口
/// Input:输入参数  :cStartDate:开始日期(YYYY-MM-DD) cEndDate:结束日期(YYYY-MM-DD)
/// YLJGDM,CKDH,GDZCKPH,LYSL,LYJE,BZ,SJSCSJ,YL1 
/// Creator:add WY 2020-12-04 
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.Outer.DHCEQForBAZX","GetStoreMoveList","2018-03-01","2020-10-12")
Query GetStoreMoveList(cStartDate As %String = "", cEndDate As %String = "") As %Query(ROWSPEC = "YLJGDM:%String,CKDH:%String,GDZCKPH:%String,LYSL:%String,LYJE:%String,BZ:%String,SJSCSJ:%String,YL1:%String") [ SqlProc ]
{
}

ClassMethod GetStoreMoveListExecute(ByRef qHandle As %Binary, cStartDate As %String = "", cEndDate As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1	
 	i cStartDate="" d
	.s cStartDate=+$H-1
	e  d
	.Set cStartDate=##Class(web.DHCEQCommon).TransValueFromPage(cStartDate,"date")
	i cEndDate="" d
	.s cEndDate=+$H
	e  d
	.Set cEndDate=##Class(web.DHCEQCommon).TransValueFromPage(cEndDate,"date")
 	s EquipTypeDR=0
	f  s EquipTypeDR=$o(^DHCEQStoreMove(0,"TypeDate",EquipTypeDR)) q:EquipTypeDR=""  d
	.s BillDate=cStartDate
	.f  s BillDate=$o(^DHCEQStoreMove(0,"TypeDate",EquipTypeDR,BillDate)) q:((BillDate="")||(BillDate>cEndDate))  d
	..s SMRowID=0
	..f  s SMRowID=$o(^DHCEQStoreMove(0,"TypeDate",EquipTypeDR,BillDate,SMRowID)) q:(SMRowID="")  d
 	...d ResetVariablesGetStoreMoveList
 	...q:$p($g(^DHCEQStoreMove(SMRowID)),"^",12)'="0"   //过滤非出库类型转移
 	...q:$p($g(^DHCEQStoreMove(SMRowID)),"^",27)'="N"   //过滤无效出库单
 	...q:$p($g(^DHCEQStoreMove(SMRowID)),"^",13)'="2"    //过滤未审核的出库单
	...s YLJGDM=""    //医疗机构组织机构代码(标注)
 	...s CKDH=$p($g(^DHCEQStoreMove(SMRowID)),"^",1)   //出库单号	
	...s EquipTypeDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",16)
	...i EquipTypeDR'=""  s GDZCGSBM=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",1) //固定资产归属编码对照DHC_EQCEquipType
 	...s SMLRowID=0
 	...f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",SMRowID,SMLRowID))  q:SMLRowID=""  d
 	....s BatchFlag=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",3)
 	....i BatchFlag="Y" d 
 	.....s GDZCKPH=""
 	.....s LYSL=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",8)   //领用数量
 	.....s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQStoreMoveList(SMLRowID)),"^",7),"",2)
 	.....s LYJE=##Class(web.DHCEQCommon).FormatNumber(LYSL*TOriginalFee,"",2)  //领用金额
 	.....s TEquipDRs=$g(^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs"))
 	.....s Len=$L(TEquipDRs,",")
 	.....for i=1:1:Len d
 	......s TEquipDR=$p(TEquipDRs,",",i)
	......i GDZCKPH'="" Set GDZCKPH=GDZCKPH_","
	......s GDZCKPH=GDZCKPH_$p($g(^DHCEQEquip(TEquipDR)),"^",71) //固定资产卡片号,固定资产拼串输出 	
 	....e  d 
 	.....s TEquipDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",2)
 	.....s GDZCKPH=$p($g(^DHCEQEquip(TEquipDR)),"^",71)  //固定资产卡片号
 	.....s LYSL=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",8)
 	.....s LYJE=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQStoreMoveList(SMLRowID)),"^",7),"",2)
	....s SJSCSJ=##class(web.DHCEQCommon).TransValueToPage(+$H,"datetime")  //上传日期
	....s YL1=""  //预留一
 	....d OutputRowGetStoreMoveList
	Quit $$$OK
OutputRowGetStoreMoveList
	s Data=$lb(YLJGDM,CKDH,GDZCKPH,LYSL,LYJE,BZ,SJSCSJ,YL1)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetStoreMoveList
	s (YLJGDM,CKDH,GDZCKPH,LYSL,LYJE,BZ,SJSCSJ,YL1)=""
	quit
}

ClassMethod GetStoreMoveListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStoreMoveListExecute ]
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

ClassMethod GetStoreMoveListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStoreMoveListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// 宝安中心医院转移接口
/// Input:输入参数  :dStartDate:开始日期(YYYY-MM-DD) dEndDate:结束日期(YYYY-MM-DD)
/// Creator:add WY 2020-9-17 
/// output::YLJGDM,YJDH,FFRXM,JSRXM,YCKS,YRKS,BZ,ZDRXM,ZDRQ,SHRXM,SHRQ,ZYLX,ZCCK,JSCK,YCDJH,QRRXM,JBRXM,QRRQ,ZCXZ,SJSCSJ,YL1
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.Outer.DHCEQForBAZX","GetStoreMoveDetail","2018-03-01","2020-10-12")
Query GetStoreMoveDetail(dStartDate As %String = "", dEndDate As %String = "") As %Query(ROWSPEC = "YLJGDM:%String,YJDH:%String,FFRXM:%String,JSRXM:%String,YCKS:%String,YRKS:%String,BZ:%String,ZDRXM:%String,ZDRQ:%String,SHRXM:%String,SHRQ:%String,ZYLX:%String,ZCCK:%String,JSCK:%String,YCDJH:%String,QRRXM:%String,JBRXM:%String,QRRQ:%String,ZCXZ:%String,SJSCSJ:%String,YL1:%String") [ SqlProc ]
{
}

ClassMethod GetStoreMoveDetailExecute(ByRef qHandle As %Binary, dStartDate As %String = "", dEndDate As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	
 	i dStartDate="" d
	.s dStartDate=+$H-1
	e  d
	.Set dStartDate=##Class(web.DHCEQCommon).TransValueFromPage(dStartDate,"date")
	i dEndDate="" d
	.s dEndDate=+$H
	e  d
	.Set dEndDate=##Class(web.DHCEQCommon).TransValueFromPage(dEndDate,"date")
 	s EquipTypeDR=0
	f  s EquipTypeDR=$o(^DHCEQStoreMove(0,"TypeDate",EquipTypeDR)) q:EquipTypeDR=""  d
	.s BillDate=dStartDate
	.f  s BillDate=$o(^DHCEQStoreMove(0,"TypeDate",EquipTypeDR,BillDate)) q:((BillDate="")||(BillDate>dEndDate))  d
	..s SMRowID=0
	..f  s SMRowID=$o(^DHCEQStoreMove(0,"TypeDate",EquipTypeDR,BillDate,SMRowID)) q:(SMRowID="")  d
 	...d ResetVariablesGetGetStoreMoveDetail
 	...q:$p($g(^DHCEQStoreMove(SMRowID)),"^",12)="0"    //过滤非出库类型转移
 	...q:$p($g(^DHCEQStoreMove(SMRowID)),"^",27)'="N"   //过滤无效出库单
 	...q:$p($g(^DHCEQStoreMove(SMRowID)),"^",13)'="2"    //过滤未审核的出库单
 	...s TStatCatDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",17)
 	...i TStatCatDR'="" s TStatCat=##class(web.DHCEQCommon).GetTrakNameByID("statcat",TStatCatDR)
	...s YLJGDM=""    //医疗机构组织机构代码(标注)
 	...s YJDH=$p($g(^DHCEQStoreMove(SMRowID)),"^",1)   //移交单号	
 	...s FFRXM=""             //发放人姓名
 	...s TReciverDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",15)
 	...i TReciverDR'="" s JSRXM=##class(web.DHCEQCommon).GetTrakNameByID("user",TReciverDR) //接收人姓名
 	...s TFromLocDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",2)
 	...i TFromLocDR'="" d
 	....s YCKS=##class(web.DHCEQCommon).GetTrakNameByID("dept",TFromLocDR)   //移出科室
 	....s ZCCK=##class(web.DHCEQCommon).GetTrakNameByID("deptcode",TFromLocDR)   //转出仓库编码
 	...s TToLocDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",3)
 	...i TToLocDR'="" d
 	....s YRKS=##class(web.DHCEQCommon).GetTrakNameByID("dept",TToLocDR)    //移入科室
 	....s JSCK=##class(web.DHCEQCommon).GetTrakNameByID("deptcode",TToLocDR)  //接收仓库编码
 	...s BZ=$p($g(^DHCEQStoreMove(SMRowID)),"^",14)                     // 备注 
 	...s TMakerDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",4)
 	...i TMakerDR'="" s ZDRXM=##class(web.DHCEQCommon).GetTrakNameByID("user",TMakerDR) //制单人姓名
 	...s ZDRQ=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQStoreMove(SMRowID)),"^",5),"date")  //制单日期
 	...s TInAckUserDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",9)
 	...i TInAckUserDR'="" s SHRXM=##class(web.DHCEQCommon).GetTrakNameByID("user",TInAckUserDR) //审核人姓名
 	...s SHRQ=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQStoreMove(SMRowID)),"^",10),"date")  //审核日期
 	...s ZYLX=$p($g(^DHCEQStoreMove(SMRowID)),"^",12)   //转移类型
 	...s YJDH=$p($g(^DHCEQStoreMove(SMRowID)),"^",1)   //移出单据号与移交单号有关？？？？
 	...s QRRXM=""    //确认人姓名
 	...s JBRXM=""    //经办人姓名
 	...s QRRQ=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQStoreMove(SMRowID)),"^",10),"date")     //确认日期
 	...s ZCXZ="1"	//资产性质
	...s SJSCSJ=##class(web.DHCEQCommon).TransValueToPage(+$H,"datetime")  //上传日期
	...s YL1=""  //预留一
 	...d OutputRowGetStoreMoveDetail 	
	Quit $$$OK
OutputRowGetStoreMoveDetail
	s Data=$lb(YLJGDM,YJDH,FFRXM,JSRXM,YCKS,YRKS,BZ,ZDRXM,ZDRQ,SHRXM,SHRQ,ZYLX,ZCCK,JSCK,YCDJH,QRRXM,JBRXM,QRRQ,ZCXZ,SJSCSJ,YL1)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetGetStoreMoveDetail
	s (YLJGDM,YJDH,FFRXM,JSRXM,YCKS,YRKS,BZ,ZDRXM,ZDRQ,SHRXM,SHRQ,ZYLX,ZCCK,JSCK,YCDJH,QRRXM,JBRXM,QRRQ,ZCXZ,SJSCSJ,YL1)=""
	quit
}

ClassMethod GetStoreMoveDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStoreMoveDetailExecute ]
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

ClassMethod GetStoreMoveDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStoreMoveDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// 宝安中心医院转移明细接口
/// Input:输入参数  :eStartDate:开始日期(YYYY-MM-DD) eEndDate:结束日期(YYYY-MM-DD)
/// Creator:add WY 2020-9-17 
/// output::YLJGDM,YJDH,GDZCKPH,YJSL,DJ,YJJE,TXM,YZRRXM,SFFJ,GDZCBM,SFBHFJ,SJSCSJ,YL1
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.Outer.DHCEQForBAZX","GetStoreMoveDetailList","2018-03-01","2020-10-12")
Query GetStoreMoveDetailList(eStartDate As %String = "", eEndDate As %String = "") As %Query(ROWSPEC = "YLJGDM:%String,YJDH:%String,GDZCKPH:%String,YJSL:%String,DJ:%String,YJJE:%String,TXM:%String,YZRRXM:%String,SFFJ:%String,GDZCBM:%String,SFBHFJ:%String,SJSCSJ:%String,YL1:%String") [ SqlProc ]
{
}

ClassMethod GetStoreMoveDetailListExecute(ByRef qHandle As %Binary, eStartDate As %String = "", eEndDate As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	
 	i eStartDate="" d
	.s eStartDate=+$H-1
	e  d
	.Set eStartDate=##Class(web.DHCEQCommon).TransValueFromPage(eStartDate,"date")
	i eEndDate="" d
	.s eEndDate=+$H
	e  d
	.Set eEndDate=##Class(web.DHCEQCommon).TransValueFromPage(eEndDate,"date")
 	s EquipTypeDR=0
	f  s EquipTypeDR=$o(^DHCEQStoreMove(0,"TypeDate",EquipTypeDR)) q:EquipTypeDR=""  d
	.s BillDate=eStartDate
	.f  s BillDate=$o(^DHCEQStoreMove(0,"TypeDate",EquipTypeDR,BillDate)) q:((BillDate="")||(BillDate>eEndDate))  d
	..s SMRowID=0
	..f  s SMRowID=$o(^DHCEQStoreMove(0,"TypeDate",EquipTypeDR,BillDate,SMRowID)) q:(SMRowID="")  d
 	...d ResetVariablesGetStoreMoveDetailList
 	...q:$p($g(^DHCEQStoreMove(SMRowID)),"^",12)=0    //过滤非出库类型转移
 	...q:$p($g(^DHCEQStoreMove(SMRowID)),"^",27)'="N"   //过滤无效出库单
 	...q:$p($g(^DHCEQStoreMove(SMRowID)),"^",13)'=2    //过滤未审核的出库单
 	...s TStatCatDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",17)
 	...i TStatCatDR'="" s TStatCat=##class(web.DHCEQCommon).GetTrakNameByID("statcat",TStatCatDR)
	...s YLJGDM=""    //医疗机构组织机构代码(标注)
 	...s YJDH=$p($g(^DHCEQStoreMove(SMRowID)),"^",1)   //移交单号	
 	...s GDZCKPH=""    //固定资产卡片号(标注)
 	...s SMLRowID=0
 	...f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",SMRowID,SMLRowID))  q:SMLRowID=""  d
 	....s YJSL=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",8)  //移交数量
 	....s DJ=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",7)   //
 	....s YJJE=YJSL*DJ
 	....s TXM=""  //条形码(标注)
 	....s YZRRXM=""  //原责任人姓名
 	....s SFFJ=""   //是否附件(标注)
 	....s GDZCBM=""  //固定资产编码(标注)
 	....s SFBHFJ=""  //是否包含附件(标注)	
	....s SJSCSJ=##class(web.DHCEQCommon).TransValueToPage(+$H,"datetime")  //上传日期
	....s YL1=""  //预留一
 	....d OutputRowGetStoreMoveDetailList	
	Quit $$$OK
OutputRowGetStoreMoveDetailList
	s Data=$lb(YLJGDM,YJDH,GDZCKPH,YJSL,DJ,YJJE,TXM,YZRRXM,SFFJ,GDZCBM,SFBHFJ,SJSCSJ,YL1)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetStoreMoveDetailList
	s (YLJGDM,YJDH,GDZCKPH,YJSL,DJ,YJJE,TXM,YZRRXM,SFFJ,GDZCBM,SFBHFJ,SJSCSJ,YL1)=""
	quit
}

ClassMethod GetStoreMoveDetailListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStoreMoveDetailListExecute ]
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

ClassMethod GetStoreMoveDetailListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStoreMoveDetailListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// 宝安中心医院资产卡片接口
/// Input:输入参数  :
/// Creator:add WY 2020-12-20 
/// output::YLJGDM,GDZCKPH,GDZCBM,GDZCMC,GDZCFL,TMH,BZ,KPZT,XLH,ZCZT,KPSZWZLX,GG,XH,PP,CCSMC,SCCSGB,CCH,CCRQ,RKRQ,CKRQ,QYRQ,GMRQ,YSRQ,SZRQ,CGY,YSRXM,ZRRXM,SZRXM,ZLDJ,JSBBS,YYNX,AZFY,YZF,SL,SBDJ,GDZCYZ,GDZCXZ,SYNX,LJZJJE,JLZQ,LZQZ,CJRXM,CJRQ,ZHXGRXM,ZHXGRQ,GDZCYT,RKDH,BCFKPH,JZMJ,SYMJ,ZCXZ,CG,QSZS,QSXZ,KYNX,CGHTH,HTDJ,HTJE,DJ,JLDW,KSFZRXM,SQKS,BIZ,SFMS,WBJE,FZDD,TYRQ,TYBZ,SFJK,TXM,SFFJ,ZJKP,GYSBM,ZJLY,SFTF,ZLZT,ZLHT,ZLDW,KSRQ,JSRQ,SJSCSJ,YL1
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.Outer.DHCEQForBAZX","GetEquip")
Query GetEquip() As %Query(ROWSPEC = "YLJGDM:%String,GDZCKPH:%String,GDZCBM:%String,GDZCMC:%String,GDZCFL:%String,TMH:%String,BZ:%String,KPZT:%String,XLH:%String,ZCZT:%String,KPSZWZLX:%String,GG:%String,XH:%String,PP:%String,CCSMC:%String,SCCSGB:%String,CCH:%String,CCRQ:%String,RKRQ:%String,CKRQ:%String,QYRQ:%String,GMRQ:%String,YSRQ:%String,SZRQ:%String,CGY:%String,YSRXM:%String,ZRRXM:%String,SZRXM:%String,ZLDJ:%String,JSBBS:%String,YYNX:%String,AZFY:%String,YZF:%String,SL:%String,SBDJ:%String,GDZCYZ:%String,GDZCXZ:%String,SYNX:%String,LJZJJE:%String,JLZQ:%String,LZQZ:%String,CJRXM:%String,CJRQ:%String,ZHXGRXM:%String,ZHXGRQ:%String,GDZCYT:%String,RKDH:%String,BCFKPH:%String,JZMJ:%String,SYMJ:%String,ZCXZ:%String,CG:%String,QSZS:%String,QSXZ:%String,KYNX:%String,CGHTH:%String,HTDJ:%String,HTJE:%String,DJ:%String,JLDW:%String,KSFZRXM:%String,SQKS:%String,BIZ:%String,SFMS:%String,WBJE:%String,FZDD:%String,TYRQ:%String,TYBZ:%String,SFJK:%String,TXM:%String,SFFJ:%String,ZJKP:%String,GYSBM:%String,ZJLY:%String,SFTF:%String,ZLZT:%String,ZLHT:%String,ZLDW:%String,KSRQ:%String,JSRQ:%String,SJSCSJ:%String,YL1:%String") [ SqlProc ]
{
}

ClassMethod GetEquipExecute(ByRef qHandle As %Binary) As %Status
{
	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
	s RowID=0
	f  s RowID=$o(^DHCEQEquip(RowID)) q:RowID=""  d
	.d ResetVariablesGetEquip
    .q:$p($g(^DHCEQEquip(RowID)),"^",59)'="N"    //过滤无效设备
    .s TStockStatus=$p($g(^DHCEQEquip(RowID)),"^",60)
    .q:(TStockStatus="0")||(TStockStatus="3")   //过滤新增未入库和出库设备
    .s TStatus = $p($g(^DHCEQEquip(RowID)),"^",38)
	.q:(TStatus>"2")    //过滤报废，其他状态设备
	.s YLJGDM=""    									//医疗机构组织机构代码(标注)
    .s GDZCKPH=$p($g(^DHCEQEquip(RowID)),"^",71)  		//固定资产卡片号
    .s GDZCBM=$p($g(^DHCEQEquip(RowID)),"^",6)  		//固定资产编码
    .s TName=$p($g(^DHCEQEquip(RowID)),"^",1)  			//固定资产名称
    .s TEquiCatDR=$p($g(^DHCEQEquip(RowID)),"^",4)
    .i TEquiCatDR'="" s GDZCFL=##class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquiCatDR)  //固定资产分类
    .s TMH=GDZCKPH  									//条码号
    .s BZ=$p($g(^DHCEQEquip(RowID)),"^",34)  			//备注
    .s KPZT=TStockStatus   								//0:新增|1:入库|2:转移出库|3:出库
    .s XLH=""                                           //序列号(标注)
    .s ZCZT=TStatus  									// 资产状态 0:新增|1:启用|2:封存|3:报废|4:其他
    .if TStatus="1"  s KPSZWZLX="2"
    .else  if (TStatus="0")&&(TStockStatus="1") s KPSZWZLX="1"  
 	.s TModelDR=$p($g(^DHCEQEquip(RowID)),"^",3)
	.i TModelDR'=""  s GG = ##class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)  //规格
    .s XH=GG  											//型号
    .s TBrandDR=$p($g(^DHCEQEquip(RowID)),"^",94)
    .i TBrandDR'="" s PP=##class(web.DHCEQCommon).GetTrakNameByID("barnd",TBrandDR)  
    .s TManuFactoryDR=$p($g(^DHCEQEquip(RowID)),"^",26)
    .i TManuFactoryDR'="" s SCCSMC=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)  //生产厂商名称
    .s SCCSGB=""  										//生产厂商国别
    .s CCH=$p($g(^DHCEQEquip(RowID)),"^",10)  			//出厂号
    .s CCRQ=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(RowID)),"^",11),"date")   //出厂日期
    .s RKRQ=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(RowID)),"^",45),"date")   //入库日期
    .s CKRQ=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(RowID)),"^",44),"date")   //出库日期
    .s QYRQ=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(RowID)),"^",44),"date")   //启用日期
    .s GMRQ=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(RowID)),"^",45),"date")   //购买日期
    .s YSRQ=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(RowID)),"^",13),"date")   //验收日期
    .s SZRQ=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(RowID)),"^",45),"date")   //上账日期
 	.s CGY=""  //采购员
 	.s YSRXM=""   //验收人姓名
 	.s TManageUserDR=$p($g(^DHCEQEquip(RowID)),"^",39)
 	.i TManageUserDR'="" s ZRRXM=##class(web.DHCEQCommon).GetTrakNameByID("user",TManageUserDR)   //责任人姓名
 	.s SZRXM=""      //上账人姓名
 	.s ZLDJ=""          //质量等级(标注)
 	.s TPurchaseTypeDR=$p($g(^DHCEQEquip(RowID)),"^",64)  //申购类别
 	.i TPurchaseTypeDR="1" d
 	..s JSBBS="N"
 	.e  d
 	..s JSBBS="Y"
 	.s YYNX=""     //已用年限(标注)
 	.s AZFY=""     //安装费用(标注)
 	.s YZF=""     //运杂费(标注)
 	.s SL=""      //税率
 	.s TOpenCheckListDR=$p($g(^DHCEQEquip(RowID)),"^",77)
 	.i TOpenCheckListDR'="" d
 	..s SBDJ=$p($g(^DHCEQOpenCheckList(TOpenCheckListDR)),"^",17) //设备单价
 	..s GDZCYZ=$p($g(^DHCEQOpenCheckList(TOpenCheckListDR)),"^",17)    //固定资产原值
 	
 	.e  d
 	..s SBDJ=$p($g(^DHCEQEquip(RowID)),"^",27)    //设备单价
 	..s GDZCYZ=$p($g(^DHCEQEquip(RowID)),"^",27)    //固定资产原值
 	.s GDZCXZ=$p($g(^DHCEQEquip(RowID)),"^",28)    //固定资产现值
 	.s SYNX=$p($g(^DHCEQEquip(RowID)),"^",31)      //使用年限
 	.s LJZJJE=$p($g(^DHCEQEquip(RowID)),"^",35)    //累计折旧金额
 	.s JLZQ=""                               //计量周期(标注)
 	.s JLZQZ=""                          //计量周期值(标注)
 	.s CJRXM=""                              //创建人姓名
 	.s CJRQ=""                  //创建日期:卡片的创建日期
 	.s TUpdateUserDR=$p($g(^DHCEQEquip(RowID)),"^",55)
 	.i TUpdateUserDR'="" s ZHXGRXM=##class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)   //最后修改人姓名
 	.s ZHXGRQ=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(RowID)),"^",56),"date")   //最后修改日期
 	.s TPurposeTypeDR=$p($g(^DHCEQEquip(RowID)),"^",65)
 	.i TPurposeTypeDR'="" s GDZCYT=$p($g(^DHCEQCCode("DHCEQCPurposeType",TPurposeTypeDR)),"^",2)   //固定资产用途
 	.s TInStockListDR=$p($g(^DHCEQEquip(RowID)),"^",70)
 	.i TInStockListDR'="" d
 	..s TInStockDR=$p($g(^DHCEQInStockList(TInStockListDR)),"^",1)
 	..s RKDH=$p($g(^DHCEQInStock(TInStockDR)),"^",14)    //入库单号
 	.s BCFKPH=""    //被拆分卡片号(标注)
 	.s JZMJ=""      //建筑面积(标注)
 	.s SYMJ=""      //使用面积(标注)
 	.s ZCXZ="2"      //资产性质
 	.s CG=""        //层高(标注)
 	.s QSZS=""      //权属证书(标注)
 	.s QSXZ=""      //权属性质(标注)
 	.s KYNX=SYNX      //可用年限
 	.s TContractListDR=$p($g(^DHCEQEquip(RowID)),"^",32)
 	.s TContractNo=$p($g(^DHCEQEquip(RowID)),"^",76)
 	.i TContractListDR'="" d
 	..s TContractDR=$p($g(^DHCEQContractList(TContractListDR)),"^",1)
 	..s CGHTH=$p($g(^DHCEQContract(TContractDR)),"^",2)         //采购合同号
 	..s HTDJ=$p($g(^DHCEQContractList(TContractListDR)),"^",6)  //采购合同单价
 	..s HTJE=$p($g(^DHCEQContractList(TContractListDR)),"^",8)  //采购合同金额
 	..i $p($g(^DHCEQContract(TContractDR)),"^",47)'="1" s WBJE=$p($g(^DHCEQContractList(TContractListDR)),"^",8)  //合同金额的外币数字

 	.e  i (TContractListDR="")&&(TContractNo'="") d
 	..s CGHTH=$p($g(^DHCEQEquip(RowID)),"^",76)   //采购合同号
 	.s DJ=$p($g(^DHCEQEquip(RowID)),"^",27)       //单价
 	.s TUnitDR=$p($g(^DHCEQEquip(RowID)),"^",5)
 	.i TUnitDR'="" s JLDW=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)   //计量单位
 	.s KSFZRXM=""      //科室负责人姓名(标注)
 	.s TUseLocDR=$p($g(^DHCEQEquip(RowID)),"^",19)
 	.i TUseLocDR'="" s SQKS=##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)   //申请科室
 	.s TCurrencyDR=$p($g(^DHCEQEquip(RowID)),"^",58)
 	.i TCurrencyDR'="" s BIZ=##class(web.DHCEQCommon).GetTrakNameByID("cur",TCurrencyDR)   //币种
    .s SFMS=""    //是否免税
    .s TLocationDR=$p($g(^DHCEQEquip(RowID)),"^",72)
 	.i TLocationDR'="" s FZDD=##class(web.DHCEQCommon).GetTrakNameByID("location",TLocationDR)   //放置地点 
    .i TStatus="2"  d
    ..s TYBZ="Y"   //停用标志
    ..s TYRQ=""   //停用日期
    ..Set CSID=""
	..f  s CSID=$Order(^DHCEQChangeStock(0,"Equip",rowid,CSID),-1)  Quit:(CSID="")||(enddate'="")  Do
	...s Status=$Piece($Get(^DHCEQChangeStock(CSID)),"^",5)
	...q:Status'=1
	...s CSAuditDate=$Piece($Get(^DHCEQChangeStock(CSID)),"^",8)
	..If CSAuditDate'="" Set TYRQ=##Class(web.DHCEQCommon).TransValueToPage(CSAuditDate,"date")
    .e  d
    ..s TYBZ="N"
    .s TCountryDR=$p($g(^DHCEQEquip(RowID)),"^",16)
    .i TCountryDR="Y" d
    ..s SFJK="N"     //是否进口
    .e  d
    ..s SFJK="Y"
    .s TXM=GDZCKPH
    .s AFRowID=$o(^DHCEQAffix(0,"Equip",RowID,0))
    .i AFRowID="" d
    ..s SFFJ="N" 
    .e  d
    ..s SFFJ="Y"     //是否附件
    .s ZJKP=""       //主机卡片
    .s TProviderDR=$p($g(^DHCEQEquip(RowID)),"^",25)
 	.i TProviderDR'="" s GYSBM=$p($g(^DHCEQCCode("DHCEQCVendor",TProviderDR)),"^",1)   //供应商编码
 	.s ZJLY=##Class(web.DHCEQEquip).GetFundsInfo(RowID)    //资金来源
 	.s SFTF=""      //是否投放
 	.s ZLZT=$p($g(^DHCEQEquip(RowID)),"^",87)   //租赁状态0:在库 1:出租
    .s RRowID=$o(^DHCEQRent(0,"Equip",RowID,0))
    .i RRowID'="" d
    ..s ZLHT=""     //租赁合同(标注)
    ..s TWorkLoadUOMDR=$p($g(^DHCEQRent(RRowID)),"^",31)     //租赁剂量单位
    ..i TWorkLoadUOMDR'="" s ZLDW=##class(web.DHCEQCommon).GetTrakNameByID("uom",TWorkLoadUOMDR)
    ..s KSRQ=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQRent(RRowID)),"^",10),"date")     //开始日期
    ..s JSRQ=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQRent(RRowID)),"^",23),"date")     //结束日期
	.s SJSCSJ=##class(web.DHCEQCommon).TransValueToPage(+$H,"datetime")  //上传日期
	.s YL1=""  //预留一	
 	.d OutputRowGetEquip
 	Quit $$$OK	
ResetVariablesGetEquip
	s (YLJGDM,GDZCKPH,GDZCBM,GDZCMC,GDZCFL,TMH,BZ,KPZT,XLH,ZCZT,KPSZWZLX,GG,XH,PP,CCSMC,SCCSGB,CCH,CCRQ,RKRQ,CKRQ,QYRQ,GMRQ,YSRQ,SZRQ,CGY,YSRXM,ZRRXM,SZRXM,ZLDJ,JSBBS,YYNX,AZFY,YZF,SL,SBDJ,GDZCYZ,GDZCXZ,SYNX,LJZJJE,JLZQ,LZQZ,CJRXM,CJRQ,ZHXGRXM,ZHXGRQ,GDZCYT,RKDH,BCFKPH,JZMJ,SYMJ,ZCXZ,CG,QSZS,QSXZ,KYNX,CGHTH,HTDJ,HTJE,DJ,JLDW,KSFZRXM,SQKS,BIZ,SFMS,WBJE,FZDD,TYRQ,TYBZ,SFJK,TXM,SFFJ,ZJKP,GYSBM,ZJLY,SFTF,ZLZT,ZLHT,ZLDW,KSRQ,JSRQ,SJSCSJ,YL1)=""
	quit	 	
OutputRowGetEquip
	s Data=$lb(YLJGDM,GDZCKPH,GDZCBM,GDZCMC,GDZCFL,TMH,BZ,KPZT,XLH,ZCZT,KPSZWZLX,GG,XH,PP,CCSMC,SCCSGB,CCH,CCRQ,RKRQ,CKRQ,QYRQ,GMRQ,YSRQ,SZRQ,CGY,YSRXM,ZRRXM,SZRXM,ZLDJ,JSBBS,YYNX,AZFY,YZF,SL,SBDJ,GDZCYZ,GDZCXZ,SYNX,LJZJJE,JLZQ,LZQZ,CJRXM,CJRQ,ZHXGRXM,ZHXGRQ,GDZCYT,RKDH,BCFKPH,JZMJ,SYMJ,ZCXZ,CG,QSZS,QSXZ,KYNX,CGHTH,HTDJ,HTJE,DJ,JLDW,KSFZRXM,SQKS,BIZ,SFMS,WBJE,FZDD,TYRQ,TYBZ,SFJK,TXM,SFFJ,ZJKP,GYSBM,ZJLY,SFTF,ZLZT,ZLHT,ZLDW,KSRQ,JSRQ,SJSCSJ,YL1)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
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

ClassMethod GetEquipClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 宝安中心医院资产折旧数据接口：按月统计
/// Input:输入参数  MonthStr 月份格式"2020-12"
/// Creator:add WY 2020-12-20 
/// output::YLJGDM,ZJND,ZJY,ZJQJ,ZCKPH,ZJLY,SYKS,BQZJ,LJZJJE,CZY,CLRQ,SFSCPZ,SCPZRQ,SFJTCB,JTCBRQ,SYZJFF,CKBM,YZJL,GDZCBM,SJSCSJ,YL1
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.Outer.DHCEQForBAZX","GetEquipMonthDepre","2019-01")
Query GetEquipMonthDepre(MonthStr As %String) As %Query(ROWSPEC = "YLJGDM:%String,ZJND:%String,ZJY:%String,ZJQJ:%String,ZCKPH:%String,ZJLY:%String,SYKS:%String,BQZJ:%String,LJZJJE:%String,CZY:%String,CLRQ:%String,SFSCPZ:%String,SCPZRQ:%String,SFJTCB:%String,JTCBRQ:%String,SYZJFF:%String,CKBM:%String,YZJL:%String,GDZCBM:%String,SJSCSJ:%String,YL1:%String") [ SqlProc ]
{
}

ClassMethod GetEquipMonthDepreExecute(ByRef qHandle As %Binary, MonthStr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
    if MonthStr="" q ""
    s SnapShotID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(MonthStr,"Equip")
    q:SnapShotID=""
	s EQRowID=0
	f  s EQRowID=$o(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID))  q:(EQRowID="")  d
	.s StockStatus=$p($g(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID)),"^",60)
	.q:((StockStatus="3")||(StockStatus="0"))			
	.s Status=$p($g(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID)),"^",38)
	.q:Status>"3"		
	.s InvalidFlag=$p($g(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID)),"^",59)
	.q:InvalidFlag="Y"
	.s MDRowID=0
	.f  s MDRowID=$o(^DHCEQMonthDepre(0,"EquipMonth",EQRowID,MonthStr,MDRowID))  q:(MDRowID="")  d
	..q:$p($g(^DHCEQMonthDepre(MDRowID)),"^",39)'=""			;过滤冲负记录
	..d ResetVariablesGetEquipMonthDepre
	..s YLJGDM=""
	..i ##class(web.DHCEQCommon).GetSysInfo("990061")="0" d
	...s TDepredate= ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(EQRowID)),"^",45),"date") 
	..e  d
	...s TDepredate= ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQRent(EQRowID)),"^",44),"date") 
	..s ZJND=$p(TDepredate,"-",1)  //固定资产开始计提折 旧的年数
	..s ZJY=$p(TDepredate,"-",2)   //固定资产开始计提折 旧的月份
	..s ZJQJ=""                  //折旧期间(标注)   
	..s DataList=$g(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID))
	..s ZCKPH= $p(DataList,"^",71)  //资产卡片号
	..s ZJLY=##Class(web.DHCEQEquip).GetFundsInfo(EQRowID)  //资金来源
	..s TUseLocDR=$p(DataList,"^",19)
    ..i TUseLocDR'="" s SYKS=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)   // 使用科室
	..s BQZJ=$P($g(^DHCEQMonthDepre(MDRowID)),"^",14)  //本期折旧
    ..s LJZJJE=$p(DataList,"^",35)+BQZJ     //累计折旧金额
    ..s CZY=""   //操作员(标注)
    ..s CLRQ=""   //处理日期
    ..s SFSCPZ=""  //是否生成凭证(标注)
    ..s SCPZRQ=""  //生成凭证日期(标注)
    ..s TDepreMethodDR=$p(DataList,"^",33)
	..i TDepreMethodDR'="" s TDepreMethod=$p($g(^DHCEQCCode("DHCEQCDepreMethod",TDepreMethodDR)),"^",2)
	..i TDepreMethod'="不计提折旧"  d
	...s SFJTCB="Y"   //是否计提成本
	..e  d 
	...s SFJTCB="N"
    ..s JTCBRQ=TDepredate   
    ..s SYZJFF=TDepreMethod  //使用折旧方法
    ..s TStoreLocDR=$p(DataList,"^",67)
    ..i TStoreLocDR'=""  s CKBM=##Class(web.DHCEQCommon).GetTrakNameByID("deptcode",TStoreLocDR)  //仓库编码
    ..s YZJL=##Class(web.DHCEQCommon).FormatNumber(BQZJ/$p(DataList,"^",27),"",2) //月折旧率,保留两位小数
	..s GDZCBM=$p(DataList,"^",6)   //固定资产编码
	..s SJSCSJ=##class(web.DHCEQCommon).TransValueToPage(+$H,"datetime")  //上传日期
	..s YL1=""  //预留一	
	..d OutputRowGetEquipMonthDepre 
	Quit $$$OK
OutputRowGetEquipMonthDepre
	s data=$lb(YLJGDM,ZJND,ZJY,ZJQJ,ZCKPH,ZJLY,SYKS,BQZJ,LJZJJE,CZY,CLRQ,SFSCPZ,SCPZRQ,SFJTCB,JTCBRQ,SYZJFF,CKBM,YZJL,GDZCBM,SJSCSJ,YL1)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	quit
ResetVariablesGetEquipMonthDepre
	s (YLJGDM,ZJND,ZJY,ZJQJ,ZCKPH,ZJLY,SYKS,BQZJ,LJZJJE,CZY,CLRQ,SFSCPZ,SCPZRQ,SFJTCB,JTCBRQ,SYZJFF,CKBM,YZJL,GDZCBM,SJSCSJ,YL1)=""
	quit
}

ClassMethod GetEquipMonthDepreFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipMonthDepreExecute ]
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

ClassMethod GetEquipMonthDepreClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipMonthDepreExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 宝安中心医院资产月报数据接口：按月统计
/// Input:输入参数  	Year: "2013" 	Month:"03"
/// Creator: add by WY 2021-1-5
/// output::YLJGDM,KJND,KJYD,GDZCBM,CKBM,FJBM,QCSL,QCJE,BQZJSL,BQZJJE,BQJSSL,BQJSJE,NCSL,NCJE,LJZJSL,LJZJJE,LJJSSL,LJJSJE,SFFJ,SJSCSJ,YL1
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.Outer.DHCEQForBAZX","GetMonthReport","2020","12")
Query GetMonthReport(Year As %String, Month As %String) As %Query(ROWSPEC = "YLJGDM:%String,KJND:%String,KJYD:%String,GDZCBM:%String,CKBM:%String,FJBM:%String,QCSL:%String,QCJE:%String,BQZJSL:%String,BQZJJE:%String,BQJSSL:%String,BQJSJE:%String,NCSL:%String,NCJE:%String,LJZJSL:%String,LJZJJE:%String,LJJSSL:%String,LJJSJE:%String,SFFJ:%String,SJSCSJ:%String,YL1") [ SqlProc ]
{
}

ClassMethod GetMonthReportExecute(ByRef qHandle As %Binary, Year As %String, Month As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	Set TJob=$job
	Set LJob=$job
	If ($L(Month))=1 Set Month="0"_Month	
	//本月没有生成记录的,要去快照中,找到记录,并写入表中.
	if '$Data(^DHCEQForWJWSnapMonthReport(0,"YearMonth",Year,Month)) 
	{
		d ##Class(web.DHCEQ.Interface.Outer.DHCEQForBAZX).FillReportListInfo(Year,Month,TJob)
	}
	//防止写入记录的程序出错,本query报错.
	i '$Data(^DHCEQForWJWSnapMonthReport(0,"YearMonth",Year,Month))  Quit $$$OK
	s (ATTCODE,ATTNAME,EQUIAMOUNT)=""
	s YLJGDM=""    ////医疗机构组织机构代码(标注)
	s KJND=Year    //会计年度
	s KJYD=Month   //会计月度
	s rowid=0
	f  s rowid=$o(^DHCEQForWJWSnapMonthReport(0,"YearMonth",Year,Month,rowid))  quit:rowid=""  d
	.s DataList=$g(^DHCEQForWJWSnapMonthReport(rowid))
	.s GDZCBM=""  //固定资产编码
	.s CKBM= $p(DataList,"^",6)  //仓库编码
	.s FJBM=""    //附件编码(标注)
	.s QCSL=+$p(DataList,"^",13)  //期初数量
	.s QCJE=+$p(DataList,"^",14)  //期初金额
	.s BQZJSL=+$p(DataList,"^",15) //本期增加数量
	.s BQZJJE=+$p(DataList,"^",16)  //本期增加金额
	.s BQJSSL=+$p(DataList,"^",17) //本期减少数量
	.s BQJSJE=+$p(DataList,"^",18) //本期减少金额
	.if '$Data(^DHCEQForWJWSnapMonthReport(0,"YearMonth",Year,"01"))  d //判断年初是否存在中间表
	..d ##Class(web.DHCEQ.Interface.Outer.DHCEQForBAZX).FillReportListInfo(Year,"01",LJob) 
	.q:'$Data(^DHCEQForWJWSnapMonthReport(0,"YearMonth",Year,"01")) 
	.s FristRowid=$o(^DHCEQForWJWSnapMonthReport(0,"YearMonth",Year,"01",0))
    .s NCSL=+$p($g(^DHCEQForWJWSnapMonthReport(FristRowid)),"^",13) //年初数量
    .s NCJE=+$p($g(^DHCEQForWJWSnapMonthReport(FristRowid)),"^",14) //年初金额
    .s LJZJSL=""     //累计增加数量(标注)
    .s LJZJJE=""     //累计增加金额(标注)
    .s LJJSSL=""     //累计减少数量(标注)
    .s LJJSJE=""     //累计减少金额(标注)
    .s SFFJ=""      //是否附件(标注)
	.s SJSCSJ=##class(web.DHCEQCommon).TransValueToPage(+$H,"datetime")  //上传日期
	.s YL1=""  //预留一	
	.d OutputRowGetMonthReport
	Quit $$$OK
OutputRowGetMonthReport
	s data=$lb(YLJGDM,KJND,KJYD,GDZCBM,CKBM,FJBM,QCSL,QCJE,BQZJSL,BQZJJE,BQJSSL,BQJSJE,NCSL,NCJE,LJZJSL,LJZJJE,LJJSSL,LJJSJE,SFFJ,SJSCSJ,YL1)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	q
}

ClassMethod GetMonthReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMonthReportExecute ]
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
	;b
	Quit $$$OK
}

ClassMethod GetMonthReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMonthReportExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##Class(web.DHCEQ.Interface.DHCEQForWJW).FillReportListInfo("2014","07",1464)
ClassMethod FillReportListInfo(Year, Month, Job)
{
	//new PreMonthStr,flag,Preflag,beginFlag,CurSnapID,SnapID,PreSnapID,CurMonth,rowid
	//new CurDataList,PreDataList
	//new CurEquipTypeDR,PreEquipTypeDR,ItemDR,CurOriginalFee,PreOriginalFee,ChangeFee,CurDepreFee
	//new CurDepreTotalFee,PreDepreTotalFee,CurStatus,PreStatus,CurStoreLocDR,PreStoreLocDR
	//new BeginQty,BeginFee,AddQty,AddFee,ReduceQty,ReduceFee,EndQty,EndFee,DepreFee,DepreTotalFee
	//new TJob,EquipTypeID,StoreLocID,TempList
	
	k ^DHCEQTemp("BUSI_EQUI_BALANCE",Job)
	
	i ($L(Month))=1 s Month="0"_Month
	s CurMonthStr=Year_"-"_Month
	
	//找到前后两个快照的ID,通过比较两个快照来出结果
	s (SnapID,PreSnapID)=""
	//指定的会计周期的第一天才能取到ID
	//20150701  Mozy0155
	Set SnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(CurMonthStr)
	If SnapID="" Quit
	Set PreSnapID=SnapID-1
	
	s rowid=0
	f  s rowid=$o(^DHCEQSnapShot(SnapID,"Equip",rowid))  quit:rowid=""  d
	.s CurDataList=$g(^DHCEQSnapShot(SnapID,"Equip",rowid))
	.s PreDataList=$g(^DHCEQSnapShot(PreSnapID,"Equip",rowid))
	.d BulidTempData
	
	//从临时golable中把数据写如表中.
	d ..SaveReportListInfo(Year,Month,Job)
	
	k ^DHCEQTemp("BUSI_EQUI_BALANCE",Job)
	quit
BulidTempData
	s (CurStatCatDR,PreStatCatDR,CurAsssetsTypeDR,PreAsssetsTypeDR,CurStatus,PreStatus,ItemDR)=""
	s (CurStoreLocDR,PreStoreLocDR,CurAsssetsTypeDRCode,PreAsssetsTypeDRCode,CurInvalidFlag,PreInvalidFlag)=""
	s (CurStockStatus,PreStockStatus)=""
	s (CurOriginalFee,PreOriginalFee,ChangeFee,CurDepreFee,CurDepreTotalFee,PreDepreTotalFee)=0
	s CurStatCatDR = $p(CurDataList,"^",75)
	s PreStatCatDR = $p(PreDataList,"^",75)
	i CurStatCatDR'="" s CurAsssetsTypeDR=$p($g(^DHCEQCCode("DHCEQCStatCat",CurStatCatDR)),"^",10)
	i PreStatCatDR'="" s PreAsssetsTypeDR=$p($g(^DHCEQCCode("DHCEQCStatCat",PreStatCatDR)),"^",10)
	i CurAsssetsTypeDR'="" s CurAsssetsTypeDRCode=$p($g(^DHCEQCCode("DHCEQForCWJW",CurAsssetsTypeDR)),"^",1)
	i PreAsssetsTypeDR'="" s PreAsssetsTypeDRCode=$p($g(^DHCEQCCode("DHCEQForCWJW",PreAsssetsTypeDR)),"^",1)
	q:(CurAsssetsTypeDRCode="09")&&(PreAsssetsTypeDRCode="09")	//都09就是非卫计委统计数据
	i CurAsssetsTypeDR="" s CurAsssetsTypeDR=0
	i PreAsssetsTypeDR="" s PreAsssetsTypeDR=0
	s ItemDR = $p(CurDataList,"^",7)
	quit:ItemDR=""		//有空就是数据有问题
	
	s CurStatus = $p(CurDataList,"^",38)
	s PreStatus = $p(PreDataList,"^",38)
	quit:(CurStatus>"2")&(PreStatus>"2")	//不是本月报废数据,不统计
	i (CurStatus="0")||(CurStatus="2") s CurStatus=0	//状态只记两种	0:在库;1:在用
	i (PreStatus="0")||(PreStatus="2") s PreStatus=0	//0:在库;2:封存 都记为在库
	s CurInvalidFlag = $p(CurDataList,"^",59)
	s PreInvalidFlag = $p(PreDataList,"^",59)
	quit:(CurInvalidFlag="Y")&(PreInvalidFlag="Y")	//无效数据
	s CurStockStatus = $p(CurDataList,"^",60)
	s PreStockStatus = $p(PreDataList,"^",60)
	quit:(CurStockStatus="0")&(PreStockStatus="0")	//验收未入库
	quit:(CurStockStatus="3")&(PreStockStatus="3")	//退货和减少
	s CurStoreLocDR  = $p(CurDataList,"^",67)
	s PreStoreLocDR  = $p(PreDataList,"^",67)
	s CurOriginalFee = +$p(CurDataList,"^",27)
	s PreOriginalFee = +$p(PreDataList,"^",27)
	s ChangeFee=+CurOriginalFee-PreOriginalFee
	s CurDepreFee=$o(^DHCEQMonthDepre(0,"EquipMonth",rowid,CurMonthStr,0))
	i CurDepreFee'="" s CurDepreFee=$p($g(^DHCEQMonthDepre(CurDepreFee)),"^",14)
	s CurDepreTotalFee = $p(CurDataList,"^",35)
	s PreDepreTotalFee = $p(PreDataList,"^",35)
	//只要有下面一个条件变化的就要分别记期初的减少,期末的增加
	i (CurStatus'=PreStatus)||(CurStoreLocDR'=PreStoreLocDR)||(CurAsssetsTypeDR'=PreAsssetsTypeDR)||(CurInvalidFlag'=PreInvalidFlag) d
	.s (BeginQty,BeginFee,AddQty,AddFee,ReduceQty,ReduceFee,EndQty,EndFee,DepreFee,DepreTotalFee)=0
	.quit:((PreStatus="3")&((CurStatus<"3")))	//期初是报废,期末可用的只记期末
	.quit:((PreInvalidFlag="Y")&((CurInvalidFlag'="Y")))	//期初无效,期末有效的只记期末
	.s StoreLocID=PreStoreLocDR
	.s AsssetsTypeID=PreAsssetsTypeDR
	.s Status=PreStatus
	.s BeginQty=1
	.s BeginFee=PreOriginalFee
	.s ReduceQty=1
	.s ReduceFee=PreOriginalFee
	.s DepreFee=CurDepreFee
	.d DoDataList
	.s (BeginQty,BeginFee,AddQty,AddFee,ReduceQty,ReduceFee,EndQty,EndFee,DepreFee,DepreTotalFee)=0
	.s StoreLocID=CurStoreLocDR
	.s AsssetsTypeID=CurAsssetsTypeDR
	.quit:CurStatus="3"	//本月报废的数据只记减少.
	.quit:CurInvalidFlag="Y"	//本月无效掉的数据只记减少.
	.s Status=CurStatus
	.s AddQty=1
	.s AddFee=CurOriginalFee
	.s EndQty=1
	.s EndFee=CurOriginalFee
	.s DepreTotalFee=CurDepreTotalFee
	.d DoDataList
	e  d
	.s (BeginQty,BeginFee,AddQty,AddFee,ReduceQty,ReduceFee,EndQty,EndFee,DepreFee,DepreTotalFee)=0
	.s StoreLocID=CurStoreLocDR
	.s AsssetsTypeID=CurAsssetsTypeDR
	.s Status=CurStatus
	.s BeginQty=1
	.s BeginFee=PreOriginalFee
	.//处理原值调账的数据
	.i ChangeFee>0 d
	..s AddFee=ChangeFee
	.e  d
	..s ReduceFee=-ChangeFee
	.s EndQty=1
	.s EndFee=CurOriginalFee
	.s DepreFee=CurDepreFee
	.s DepreTotalFee=CurDepreTotalFee
	.d DoDataList
	quit
DoDataList
	i (StoreLocID="")||(ItemDR="")||(AsssetsTypeID="")||(Status="") quit 
	s TempList=$g(^DHCEQTemp("BUSI_EQUI_BALANCE",Job,StoreLocID,AsssetsTypeID,Status,ItemDR))
	s $p(TempList,"^",1)=+$p(TempList,"^",1)+BeginQty
	s $p(TempList,"^",2)=+$p(TempList,"^",2)+BeginFee
	s $p(TempList,"^",3)=+$p(TempList,"^",3)+AddQty
	s $p(TempList,"^",4)=+$p(TempList,"^",4)+AddFee
	s $p(TempList,"^",5)=+$p(TempList,"^",5)+ReduceQty
	s $p(TempList,"^",6)=+$p(TempList,"^",6)+ReduceFee
	s $p(TempList,"^",7)=+$p(TempList,"^",7)+EndQty
	s $p(TempList,"^",8)=+$p(TempList,"^",8)+EndFee
	s $p(TempList,"^",9)=+$p(TempList,"^",9)+DepreFee
	s $p(TempList,"^",10)=+$p(TempList,"^",10)+DepreTotalFee
	s ^DHCEQTemp("BUSI_EQUI_BALANCE",Job,StoreLocID,AsssetsTypeID,Status,ItemDR)=TempList
	
	quit
}

/// d ##Class(web.DHCEQ.Interface.DHCEQForWJW).SaveReportListInfo("2013","03",1464)
ClassMethod SaveReportListInfo(Year, Month, Job)
{
	k PLIST
 	s Date=+$H
	s Time=$p($H,",",2)
	s PLIST(5) = Year
	s PLIST(6) = Month
	
	s PLIST(25) = Date
	s PLIST(26) = Time
	
	Set $ZT="SaveReportList"
	TStart
	s SQLCODE=0
	///保存当月结果
	s StoreLocID=0
	f  s StoreLocID=$o(^DHCEQTemp("BUSI_EQUI_BALANCE",Job,StoreLocID))  quit:StoreLocID=""  d
	.s AsssetsTypeID=""
	.f  s AsssetsTypeID=$o(^DHCEQTemp("BUSI_EQUI_BALANCE",Job,StoreLocID,AsssetsTypeID))  quit:AsssetsTypeID=""  d
	..s PLIST(10)=AsssetsTypeID
	..s Status=""
	..f  s Status=$o(^DHCEQTemp("BUSI_EQUI_BALANCE",Job,StoreLocID,AsssetsTypeID,Status))  quit:Status=""  d
	...i Status=0 d
	....s PLIST(7)= StoreLocID
	....s PLIST(8)="在库"
	...e  d
	....s PLIST(7)="在科"
	....s PLIST(8)= StoreLocID
	...s ItemID=0
	...f  s ItemID=$o(^DHCEQTemp("BUSI_EQUI_BALANCE",Job,StoreLocID,AsssetsTypeID,Status,ItemID))  quit:ItemID=""  d
	....s PLIST(11)=ItemID
	....s (EquipCatDR,AsssetsTypeDR)=""
	....s EquipCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemID)),"^",4)
	....s PLIST(9)=EquipCatDR
	....s DataList=$G(^DHCEQTemp("BUSI_EQUI_BALANCE",Job,StoreLocID,AsssetsTypeID,Status,ItemID))
	....s PLIST(14)=+$p(DataList,"^",1)
	....s PLIST(15)=+$p(DataList,"^",2)
	....s PLIST(16)=+$p(DataList,"^",3)
	....s PLIST(17)=+$p(DataList,"^",4)
	....s PLIST(18)=+$p(DataList,"^",5)
	....s PLIST(19)=+$p(DataList,"^",6)
	....s PLIST(20)=+$p(DataList,"^",7)
	....s PLIST(21)=+$p(DataList,"^",8)
	....s PLIST(22)=+$p(DataList,"^",9)
	....s PLIST(23)=+$p(DataList,"^",10)
	....&SQL(Insert Into SQLUSER.DHC_EQForWJWSnapMonthReport Values :PLIST())
	....q:SQLCODE'=0 
	
	i SQLCODE'=0
	{	TRollBack}
	else
	{	TCommit}
	q SQLCODE
SaveReportList
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "-1^"_ErrorMsg     //返回错误消息 ;
}

/// d ##Class(web.DHCEQ.Interface.DHCEQForWJW).DeleteData("2014","07")
/// add by zy  2014-7-24
/// 用于要删除某月的数据操作.
ClassMethod DeleteData(Year, Month)
{
	q:'$Data(^DHCEQForWJWSnapMonthReport(0,"YearMonth",Year,Month))
	s (rowid,flag,SQLCODE)=0
	f  s rowid=$o(^DHCEQForWJWSnapMonthReport(0,"YearMonth",Year,Month,rowid))  quit:(rowid="")||(flag=1)  d
	.s DataList=$g(^DHCEQForWJWSnapMonthReport(rowid))
	.s EQUIKINDTYPE=$p(DataList,"^",9)
	.i EQUIKINDTYPE=0 s flag=1
	
	i flag=0 w "报表中数据完整,如继续删除g,取消删除q!"
	TSTART
	&sql(delete from sqluser.DHC_EQForWJWSnapMonthReport where SMR_AcctYear=:Year and SMR_AcctMonth=:Month)
 	if SQLCODE
 	{
	 	TROLLBACK
	 	q SQLCODE
 	}
	TCOMMIT
	q SQLCODE
}

/// 宝安中心医院资产盘点数据接口
/// Input:输入参数  
/// Creator:add WY 2020-12-20 
/// output::YLJGDM,PDDH,PDRQ,PDLB,CKBM,KSBM,ZY,PDRXM,ZDRXM,BZ,SHRXM,ZT,GDZCGSBM,SCPYD,SCPKD,KSRQ,JSRQ,SFJS,SJSCSJ,YL1
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.Outer.DHCEQForBAZX","GetInventory","2018-03-01","2020-10-12")
Query GetInventory(HStartDate As %String = "", HEndDate As %String = "") As %Query(ROWSPEC = "YLJGDM:%String,PDDH:%String,PDRQ:%String,PDLB:%String,CKBM:%String,KSBM:%String,ZY:%String,PDRXM:%String,ZDRXM:%String,BZ:%String,SHRXM:%String,ZT:%String,GDZCGSBM:%String,SCPYD:%String,SCPKD:%String,KSRQ:%String,JSRQ:%String,SFJS:%String,SJSCSJ:%String,YL1:%String") [ SqlProc ]
{
}

ClassMethod GetInventoryExecute(ByRef qHandle As %Binary, HStartDate As %String = "", HEndDate As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
 	i HStartDate="" d
	.s HStartDate=+$H-1
	e  d
	.Set HStartDate=##Class(web.DHCEQCommon).TransValueFromPage(HStartDate,"date")
	i HEndDate="" d
	.s HEndDate=+$H
	e  d
	.Set HEndDate=##Class(web.DHCEQCommon).TransValueFromPage(HEndDate,"date")
	
	s rowid=0
	f  s rowid=$o(^DHCEQInventory(rowid))  quit:rowid=""  d
	.d ResetVariablesGetInventory
	.s data=$g(^DHCEQInventory(rowid))
	.s TDate=$p(data,"^",7)  //盘点日期
	.q:((HStartDate>TDate)||(HEndDate<TDate))
	.s YLJGDM=""    //医疗机构组织机构代码(标注)
	.s PDDH=$p(data,"^",1) //盘点单号
	.s PDRQ=##Class(web.DHCEQCommon).TransValueToPage($p(data,"^",7),"date")  //盘点日期
	.s PDLB="1"   //盘点类别1 固定资产 2 现金 3、存货	
	.s CKBM=""    //仓库编码(标注)
	.s KSBM=""    //科室编码(标注)
	.s ZY=""      //摘要
	.s TUserDR=$p(data,"^",9)
	.i TUserDR'="" s PDRXM=##class(web.DHCEQCommon).GetTrakNameByID("user",TUserDR)  //盘点人姓名
	.s ZDRXM=""   //制单人姓名
	.s BZ=$p(data,"^",11)  // 备注
	.s TCompleter=$p(data,"^",12)
	.i TCompleter'="" s SHRXM=##class(web.DHCEQCommon).GetTrakNameByID("user",TCompleter)  //审核人姓名	
	.s ZT= $p(data,"^",10)  //  状态
	.s GDZCGSBM=""       // 固定资产归属编码(标注)
	.s SCPYD=""    //生成盘盈单(标注)
	.s SCPKD=""    //生成盘亏单(标注)
	.s KSRQ=""     //开始日期
	.s JSRQ=""     // 结束日期
	.i ZT="2" d
	..s SFJS="Y"     //是否结束
	.e  d
	..s SFJS="N"
	.s SJSCSJ=##class(web.DHCEQCommon).TransValueToPage(+$H,"datetime")  //上传日期
	.s YL1=""  //预留一	
	.d OutputRowGetInventory 
	Quit $$$OK
OutputRowGetInventory
	s data=$lb(YLJGDM,PDDH,PDRQ,PDLB,CKBM,KSBM,ZY,PDRXM,ZDRXM,BZ,SHRXM,ZT,GDZCGSBM,SCPYD,SCPKD,KSRQ,JSRQ,SFJS,SJSCSJ,YL1)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	quit
ResetVariablesGetInventory
	s (YLJGDM,PDDH,PDRQ,PDLB,CKBM,KSBM,ZY,PDRXM,ZDRXM,BZ,SHRXM,ZT,GDZCGSBM,SCPYD,SCPKD,KSRQ,JSRQ,SFJS,SJSCSJ,YL1)=""
	quit
}

ClassMethod GetInventoryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInventoryExecute ]
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

ClassMethod GetInventoryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInventoryExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 宝安中心医院资产盘点明细数据接口
/// Input:输入参数  :KStartDate:开始日期(YYYY-MM-DD) KEndDate:结束日期(YYYY-MM-DD)
/// Creator:add WY 2020-12-21 
/// output::YLJGDM,PDDH,KSBM,CKBM,KPBM,DJ,ZMSL,PDSL,YKSL,YKYY,TXM,GDZCBM,GDZCMC,ZCGG,ZCXH,ZCGJ,ZCPP,PDRQ,SJSCSJ,YL1
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.Outer.DHCEQForBAZX","GetInventoryList","2018-03-01","2020-10-12")
Query GetInventoryList(KStartDate As %String = "", KEndDate As %String = "") As %Query(ROWSPEC = "YLJGDM:%String,PDDH:%String,KSBM:%String,CKBM:%String,KPBM:%String,DJ:%String,ZMSL:%String,PDSL:%String,YKSL:%String,YKYY:%String,TXM:%String,GDZCBM:%String,GDZCMC:%String,ZCGG:%String,ZCXH:%String,ZCGJ:%String,ZCPP:%String,PDRQ:%String,SJSCSJ:%String,YL1:%String") [ SqlProc ]
{
}

ClassMethod GetInventoryListExecute(ByRef qHandle As %Binary, KStartDate As %String = "", KEndDate As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
 	i KStartDate="" d
	.s KStartDate=+$H
	e  d
	.Set KStartDate=##Class(web.DHCEQCommon).TransValueFromPage(KStartDate,"date")
	i KEndDate="" d
	.s KEndDate=+$H
	e  d
	.Set KEndDate=##Class(web.DHCEQCommon).TransValueFromPage(KEndDate,"date")
	
	s rowid=0
	f  s rowid=$o(^DHCEQInventory(rowid))  quit:rowid=""  d	
	.s data=$g(^DHCEQInventory(rowid))
	.s ILRowID=0
	.f  s ILRowID=$o(^DHCEQInventoryList(0,"Inventory",rowid,ILRowID))  quit:((ILRowID=""))  d
	..d ResetVariablesGetInventoryList
	..s TDate=$p(data,"^",7)  //盘点日期
	..q:((KStartDate>TDate)||(KEndDate<TDate))
	..s YLJGDM=""    //医疗机构组织机构代码(标注)
	..s PDDH=$p(data,"^",1) //盘点单号
	..s TBillStoreLocDR=$p($g(^DHCEQInventoryList(ILRowID)),"^",4)
	..i TBillStoreLocDR'="" s CKBM=##class(web.DHCEQCommon).GetTrakNameByID("dept",TBillStoreLocDR)	 //仓库编码
	..s TBillUseLocDR=$p($g(^DHCEQInventoryList(ILRowID)),"^",5)
	..i TBillUseLocDR'="" s KSBM=##class(web.DHCEQCommon).GetTrakNameByID("dept",TBillUseLocDR)	 //科室编码
    ..s ILStatus=$p($g(^DHCEQInventoryList(ILRowID)),"^",14)
    ..i ILStatus="1"  d
    ...s TEquipDR=$p($g(^DHCEQInventoryList(ILRowID)),"^",3)
    ..e  d
    ...s TEquipDR=$p($g(^DHCEQInventoryList(ILRowID)),"^",2)
    ..s KPBM=$p($g(^DHCEQEquip(TEquipDR)),"^",71)   //卡片编码
    ..s DJ=$p($g(^DHCEQInventoryList(ILRowID)),"^",8)  //单价
    ..s ZMSL=""     //账面数量(标注)
    ..s PDSL=""       //盘点数量(标注)
    ..s YKSL=""    //盈亏数量(标注)
    ..s YKYY=""    //盈亏原因(标注)
    ..s TXM=""     //条形码(标注)
    ..s GDZCBM=$p($g(^DHCEQEquip(TEquipDR)),"^",6)  //固定资产编码
    ..s GDZCMC=$p($g(^DHCEQEquip(TEquipDR)),"^",1)  //固定资产名称
 	..s ZCGG=""   //资产规格(标注)
 	..s TModelDR=$p($g(^DHCEQEquip(TEquipDR)),"^",3)
	..i TModelDR'=""  s ZCXH = ##class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)  //资产规格
	..s TCountryDR=$p($g(^DHCEQEquip(TEquipDR)),"^",16)
    ..i TCountryDR'=""  s ZCGJ=##class(web.DHCEQCommon).GetTrakNameByID("cou",TModelDR)  //资产国家
    ..s TBrandDR=$p($g(^DHCEQEquip(TEquipDR)),"^",94)
    ..i TBrandDR'="" s ZCPP=##class(web.DHCEQCommon).GetTrakNameByID("barnd",TBrandDR)   //品牌
	..s PDRQ=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInventoryList(ILRowID)),"^",12),"date")  //盘点日期	
	..s SJSCSJ=##class(web.DHCEQCommon).TransValueToPage(+$H,"datetime")  //上传日期
	..s YL1=""  //预留一	
	..d OutputRowGetInventoryList 
	Quit $$$OK
OutputRowGetInventoryList
	s data=$lb(YLJGDM,PDDH,KSBM,CKBM,KPBM,DJ,ZMSL,PDSL,YKSL,YKYY,TXM,GDZCBM,GDZCMC,ZCGG,ZCXH,ZCGJ,ZCPP,PDRQ,SJSCSJ,YL1)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	quit
ResetVariablesGetInventoryList
	s (YLJGDM,PDDH,KSBM,CKBM,KPBM,DJ,ZMSL,PDSL,YKSL,YKYY,TXM,GDZCBM,GDZCMC,ZCGG,ZCXH,ZCGJ,ZCPP,PDRQ,SJSCSJ,YL1)=""
	quit
}

ClassMethod GetInventoryListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInventoryListExecute ]
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

ClassMethod GetInventoryListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInventoryListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 宝安中心医院资产报废数据接口
/// Input:输入参数  :KStartDate:开始日期(YYYY-MM-DD) KEndDate:结束日期(YYYY-MM-DD)
/// Creator:add WY 2020-12-22 
/// output::YLJGDM,BFDH,GDZCBM,GG,XH,JLDW,SCCSMC,SYBM,SBDJ,CGRQ,YYNX,GJCZ,BFYY,SQRXM,SQRQ,SHRXM,SHRQ,ZCKPH,SCCSBM,SJSCSJ,YL1
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.Outer.DHCEQForBAZX","DisuseRequest","2018-03-01","2020-10-12")
Query DisuseRequest(LStartDate As %String = "", LEndDate As %String = "") As %Query(ROWSPEC = "YLJGDM:%String,BFDH:%String,GDZCBM:%String,GG:%String,XH:%String,JLDW:%String,SCCSMC:%String,SYBM:%String,SBDJ:%String,CGRQ:%String,YYNX:%String,GJCZ:%String,BFYY:%String,SQRXM:%String,SQRQ:%String,SHRXM:%String,SHRQ:%String,ZCKPH:%String,SCCSBM:%String,SJSCSJ:%String,YL1:%String") [ SqlProc ]
{
}

ClassMethod DisuseRequestExecute(ByRef qHandle As %Binary, LStartDate As %String = "", LEndDate As %String = "") As %Status
{
	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1	
 	i LStartDate="" d
	.s LStartDate=+$H
	e  d
	.Set LStartDate=##Class(web.DHCEQCommon).TransValueFromPage(LStartDate,"date")
	i LEndDate="" d
	.s LEndDate=+$H
	e  d
	.Set LEndDate=##Class(web.DHCEQCommon).TransValueFromPage(LEndDate,"date")
	
 	//报废
 	s EquipTypeDR=0
	f  s EquipTypeDR=$o(^DHCEQDisuseRequest(0,"TypeDate",EquipTypeDR)) q:EquipTypeDR=""  d
	.s EquipTypeCode=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",1)
	.s EquipTypeDesc=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",2)
	.s AuditDate=LStartDate
	.f  s AuditDate=$o(^DHCEQDisuseRequest(0,"TypeDate",EquipTypeDR,AuditDate)) q:(AuditDate="")||(AuditDate>LEndDate)  d
	..s DisuseRequestDR=0
	..f  s DisuseRequestDR=$o(^DHCEQDisuseRequest(0,"TypeDate",EquipTypeDR,AuditDate,DisuseRequestDR)) q:DisuseRequestDR=""  d
	...d ResetVariablesDisuseRequest
	...q:($p($g(^DHCEQDisuseRequest(DisuseRequestDR)),"^",53)="Y")
	...;q:($p($g(^DHCEQDisuseRequest(DisuseRequestDR)),"^",10)'="2")
	...s YLJGDM=""    //医疗机构组织机构代码(标注)
	...s BFDH=$p($g(^DHCEQDisuseRequest(DisuseRequestDR)),"^",33)  //报废单号
	...s TUseLocDR=$p($g(^DHCEQDisuseRequest(DisuseRequestDR)),"^",34)
	...i TUseLocDR'="" s SYBM=##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)  //使用部门
	...s BFYY=$p($g(^DHCEQDisuseRequest(DisuseRequestDR)),"^",7)   //报废原因
    ...s TAddUserDR=$p($g(^DHCEQDisuseRequest(DisuseRequestDR)),"^",11)
    ...i TAddUserDR'="" s SQRXM=##class(web.DHCEQCommon).GetTrakNameByID("user",TAddUserDR)  //申请人姓名
    ...s SQRQ=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQDisuseRequest(DisuseRequestDR)),"^",12),"date")   // 申请日期
    ...s TAuditUserDR=$p($g(^DHCEQDisuseRequest(DisuseRequestDR)),"^",20)
    ...i TAuditUserDR'="" s SHRXM=##class(web.DHCEQCommon).GetTrakNameByID("user",TAuditUserDR)  //审核人姓名
    ...s SHRQ=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQDisuseRequest(DisuseRequestDR)),"^",21),"date")  //审核日期
	...s SJSCSJ=##class(web.DHCEQCommon).TransValueToPage(+$H,"datetime")  //上传日期
	...s YL1=""  //预留一
	...s DRLRowID=0
	...f  s DRLRowID=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",DisuseRequestDR,DRLRowID))  q:DRLRowID=""  d
	....s TEquipDR=$p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",2)
	....s GDZCBM=$p($g(^DHCEQEquip(TEquipDR)),"^",6)   //固定资产编码
 	....s GG=""   //规格(标注)
    ....s TModelDR=$p($g(^DHCEQEquip(TEquipDR)),"^",3)
	....i TModelDR'=""  s XH = ##class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)  //型号
    ....s TUnitDR=$p($g(^DHCEQEquip(TEquipDR)),"^",5)
    ....i TUnitDR'="" s JLDW=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)  //计量单位
    ....s ZCKPH=$p($g(^DHCEQEquip(TEquipDR)),"^",71)    //资产卡片号
    ....s TManuFactoryDR=$p($g(^DHCEQEquip(TEquipDR)),"^",26)
    ....i TManuFactoryDR'="" d
    .....s SCCSMC=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)  //生产厂商名称)
    .....s SCCSBM=$p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",2)  //生产厂商编码
 	....s SBDJ=$p($g(^DHCEQEquip(TEquipDR)),"^",27)   //设备单价
	....s CGRQ=""   //采购日期(标注)
	....s YYNX=""   //已用年限(标注)
	....s GJCZ=$p($g(^DHCEQEquip(TEquipDR)),"^",29)    //估计残值

 	....d OutputRowDisuseRequest
 	Quit $$$OK

 	
ResetVariablesDisuseRequest
	s (YLJGDM,BFDH,GDZCBM,GG,XH,JLDW,SCCSMC,SYBM,SBDJ,CGRQ,YYNX,GJCZ,BFYY,SQRXM,SQRQ,SHRXM,SHRQ,ZCKPH,SCCSBM,SJSCSJ,YL1)=""
	quit	 	
OutputRowDisuseRequest
	s Data=$lb(YLJGDM,BFDH,GDZCBM,GG,XH,JLDW,SCCSMC,SYBM,SBDJ,CGRQ,YYNX,GJCZ,BFYY,SQRXM,SQRQ,SHRXM,SHRQ,ZCKPH,SCCSBM,SJSCSJ,YL1)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod DisuseRequestFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DisuseRequestExecute ]
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

ClassMethod DisuseRequestClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DisuseRequestExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/*
/// 宝安中心医院资产发票数据接口
/// Input:输入参数  :MStartDate:开始日期(YYYY-MM-DD) MEndDate:结束日期(YYYY-MM-DD)
/// Creator:add WY 2020-12-22 
/// output::YLJGDM,FPH,KPRQ,GYSBM,CGY,FKTJ,BZ,ZDRXM,SHRXM,ZT,FPJE,SFYF,SJSCSJ,YL1
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.Outer.DHCEQForBAZX","GetInvoice","2018-03-01","2020-10-12")
Query GetInvoice(MStartDate As %String = "", MEndDate As %String = "") As %Query(ROWSPEC = "YLJGDM:%String,FPH:%String,KPRQ:%String,GYSBM:%String,CGY:%String,FKTJ:%String,BZ:%String,ZDRXM:%String,SHRXM:%String,ZT:%String,FPJE:%String,SFYF:%String,SJSCSJ:%String,YL1:%String") [ SqlProc ]
{
}

ClassMethod GetInvoiceExecute(ByRef qHandle As %Binary, MStartDate As %String = "", MEndDate As %String = "") As %Status
{
	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1	
 	i MStartDate="" d
	.s MStartDate=+$H
	e  d
	.Set MStartDate=##Class(web.DHCEQCommon).TransValueFromPage(MStartDate,"date")
	i MEndDate="" d
	.s MEndDate=+$H
	e  d
	.Set MEndDate=##Class(web.DHCEQCommon).TransValueFromPage(MEndDate,"date")
	
	s rowid=0
	f  s rowid=$o(^DHCEQInvoice(rowid)) q:rowid=""  d
	.d ResetVariablesGetInvoice
	.s TInvalidFlag=$p($g(^DHCEQInvoice(rowid)),"^",16)
	.q:TInvalidFlag="Y"
	.s YLJGDM=""   //医疗机构组织机构代码(标注)
	.s FPH=$p($g(^DHCEQInvoice(rowid)),"^",2)  //发票号
    .s KPRQ=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInvoice(rowid)),"^",3),"date")  //开票日期
    .s TProviderDR=$p($g(^DHCEQInvoice(rowid)),"^",5)
    .i TProviderDR'="" s GYSBM=$p($g(^DHCEQCCode("DHCEQCVendor",TProviderDR)),"^",1)  //申请人姓名
    .s CGY=""   //采购员
    .s FKTJ=""  //付款条件
    .s BZ=""    //备注
    .s ZDRXM="" //制单人姓名
    .s SHRXM="" //审核人姓名
    .s ZT=$p($g(^DHCEQInvoice(rowid)),"^",10) //状态 0:新增|1:帐物审核|2:提交
    .s FPJE=$p($g(^DHCEQInvoice(rowid)),"^",4)   //发票金额
    .s SFYF="" //是否预付  
	.s SJSCSJ=##class(web.DHCEQCommon).TransValueToPage(+$H,"datetime")  //上传日期
	.s YL1=""  //预留一	
 	.d OutputRowGetInvoice
 	Quit $$$OK	
ResetVariablesGetInvoice
	s (YLJGDM,FPH,KPRQ,GYSBM,CGY,FKTJ,BZ,ZDRXM,SHRXM,ZT,FPJE,SFYF,SJSCSJ,YL1)=""
	quit	 	
OutputRowGetInvoice
	s Data=$lb(YLJGDM,FPH,KPRQ,GYSBM,CGY,FKTJ,BZ,ZDRXM,SHRXM,ZT,FPJE,SFYF,SJSCSJ,YL1)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
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
}*/
/// 宝安中心医院资产发票明细数据接口
/// Input:输入参数  :MStartDate:开始日期(YYYY-MM-DD) MEndDate:结束日期(YYYY-MM-DD)
/// Creator:add WY 2020-12-22 
/// output::YLJGDM,BFDH,GDZCBM,GG,XH,JLDW,SCCSMC,SYBM,SBDJ,CGRQ,YYNX,GJCZ,BFYY,SQRXM,SQRQ,SHRXM,SHRQ,ZCKPH,SCCSBM,SJSCSJ,YL1
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.Outer.DHCEQForBAZX","GetInvoiceList","2018-03-01","2020-10-12")
Query GetInvoiceList(NStartDate As %String = "", NEndDate As %String = "") As %Query(ROWSPEC = "YLJGDM:%String,FPH:%String,FPJE:%String,FKJE:%String,QCFKJE:%String,FKSM:%String,GDZCBM:%String,SL:%String,SJSCSJ:%String,YL1:%String") [ SqlProc ]
{
}

ClassMethod GetInvoiceListExecute(ByRef qHandle As %Binary, NStartDate As %String = "", NEndDate As %String = "") As %Status
{
	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1	
 	i NStartDate="" d
	.s NStartDate=+$H
	e  d
	.Set NStartDate=##Class(web.DHCEQCommon).TransValueFromPage(NStartDate,"date")
	i NEndDate="" d
	.s NEndDate=+$H
	e  d
	.Set NEndDate=##Class(web.DHCEQCommon).TransValueFromPage(NEndDate,"date")
	s rowid=0
	f  s rowid=$o(^DHCEQInvoice(rowid)) q:rowid=""  d
	.d ResetVariablesGetInvoiceList
	.s TInvalidFlag=$p($g(^DHCEQInvoice(rowid)),"^",16)
	.q:TInvalidFlag="Y"
	.s YLJGDM=""   //医疗机构组织机构代码(标注)
	.s FPH=$p($g(^DHCEQInvoice(rowid)),"^",2) //发票号	
	.s FPJE=$p($g(^DHCEQInvoice(rowid)),"^",4)    //发票金额
	.s FKJE=""    //付款金额(标注)
	.s QCFKJE=""   //期初付款金额(标注)
	.s FKSM=""    //付款说明
	.s GDZCBM=""  //固定资产编码(标注
	.s SL=""      //数量(标注
	.s SJSCSJ=##class(web.DHCEQCommon).TransValueToPage(+$H,"datetime")  //上传日期
	.s YL1=""  //预留一	
 	.d OutputRowGetInvoiceList
 	Quit $$$OK

 	
ResetVariablesGetInvoiceList
	s (YLJGDM,FPH,FPJE,FKJE,QCFKJE,FKSM,GDZCBM,SL,SJSCSJ,YL1)=""
	quit	 	
OutputRowGetInvoiceList
	s Data=$lb(YLJGDM,FPH,FPJE,FKJE,QCFKJE,FKSM,GDZCBM,SL,SJSCSJ,YL1)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetInvoiceListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInvoiceListExecute ]
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

ClassMethod GetInvoiceListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInvoiceListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// 宝安中心医院资产付款单数据接口
/// Input:输入参数  :OStartDate:开始日期(YYYY-MM-DD) OEndDate:结束日期(YYYY-MM-DD)
/// Creator:add WY 2020-12-22 
/// output:YLJGDM,KJND,FKDH,FKRQ,FKFS,CGY,FKTJ,BZ,ZDRXM,SHRXM,ZT,FKJE,SFYF,SJSCSJ,YL1
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.Outer.DHCEQForBAZX","GetPayRequest","2018-03-01","2020-10-12")
Query GetPayRequest(OStartDate As %String = "", OEndDate As %String = "") As %Query(ROWSPEC = "YLJGDM:%String,KJND:%String,FKDH:%String,FKRQ:%String,FKFS:%String,CGY:%String,FKTJ:%String,BZ:%String,ZDRXM:%String,SHRXM:%String,ZT:%String,FKJE:%String,SFYF:%String,SJSCSJ:%String,YL1:%String") [ SqlProc ]
{
}

ClassMethod GetPayRequestExecute(ByRef qHandle As %Binary, OStartDate As %String = "", OEndDate As %String = "") As %Status
{
	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1	
 	i OStartDate="" d
	.s OStartDate=+$H
	e  d
	.Set OStartDate=##Class(web.DHCEQCommon).TransValueFromPage(OStartDate,"date")
	i OEndDate="" d
	.s OEndDate=+$H
	e  d
	.Set OEndDate=##Class(web.DHCEQCommon).TransValueFromPage(OEndDate,"date")
	s rowid=0
	f  s rowid=$o(^DHCEQPayRequest(rowid)) q:rowid=""  d
	.d ResetVariablesGetPayRequest
	.s TInvalidFlag=$p($g(^DHCEQPayRequest(rowid)),"^",26)
	.q:TInvalidFlag="Y"
	.s TAuditDate=$p($g(^DHCEQPayRequest(rowid)),"^",21)  //审核日期
	.q:(TAuditDate>OEndDate)||(TAuditDate<OStartDate)    //通过审核日期过滤
	.s YLJGDM=""   //医疗机构组织机构代码(标注)
	.s KJND=""     //会计年度
	.s FKDH=$p($g(^DHCEQPayRequest(rowid)),"^",1)  //付款单号
	.s FKRQ=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQPayRequest(rowid)),"^",7),"date")
    .s FKFS=$p($g(^DHCEQPayRequest(rowid)),"^",10) //付款方式
	.s CGY=""  //采购员
	.s FKTJ=""   //付款条件
	.s BZ=$p($g(^DHCEQPayRequest(rowid)),"^",13)    //备注
	.s TUpdateUserDR=$p($g(^DHCEQPayRequest(rowid)),"^",14) 
	.i TUpdateUserDR'="" s ZDRXM=##class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)  //制单人姓名
	.s TAuditUserDR=$p($g(^DHCEQPayRequest(rowid)),"^",20) 
	.i TAuditUserDR'="" s SHRXM=##class(web.DHCEQCommon).GetTrakNameByID("user",TAuditUserDR)  //审核人姓名
	.s ZT=$p($g(^DHCEQPayRequest(rowid)),"^",12)   //状态 0:新增 1:提交  2:审核  3:作废
	.s FKJE=""    //付款金额(标注)
	.s SFYF=""    //是否预付(标注)
	.s SJSCSJ=##class(web.DHCEQCommon).TransValueToPage(+$H,"datetime")  //上传日期
	.s YL1=""  //预留一	
 	.d OutputRowGetPayRequest
 	Quit $$$OK

 	
ResetVariablesGetPayRequest
	s (YLJGDM,KJND,FKDH,FKRQ,FKFS,CGY,FKTJ,BZ,ZDRXM,SHRXM,ZT,FKJE,SFYF,SJSCSJ,YL1)=""
	quit	 	
OutputRowGetPayRequest
	s Data=$lb(YLJGDM,KJND,FKDH,FKRQ,FKFS,CGY,FKTJ,BZ,ZDRXM,SHRXM,ZT,FKJE,SFYF,SJSCSJ,YL1)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetPayRequestFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPayRequestExecute ]
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

ClassMethod GetPayRequestClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPayRequestExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// 适用于8.3版本以下
/// 宝安中心医院资产付款单明细数据接口
/// Input:输入参数  :QStartDate:开始日期(YYYY-MM-DD) QEndDate:结束日期(YYYY-MM-DD)
/// Creator:add WY 2021-1-5
/// output::YLJGDM,BFDH,GDZCBM,GG,XH,JLDW,SCCSMC,SYBM,SBDJ,CGRQ,YYNX,GJCZ,BFYY,SQRXM,SQRQ,SHRXM,SHRQ,ZCKPH,SCCSBM,SJSCSJ,YL1
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.Outer.DHCEQForBAZX","GetPayRecord","2018-03-01","2020-10-12")
Query GetPayRecord(QStartDate As %String = "", QEndDate As %String = "") As %Query(ROWSPEC = "YLJGDM:%String,FKDH:%String,HTH:%String,FPH:%String,FKQH:%String,FKJE:%String,SJSCSJ:%String,YL1:%String") [ SqlProc ]
{
}

ClassMethod GetPayRecordExecute(ByRef qHandle As %Binary, QStartDate As %String = "", QEndDate As %String = "") As %Status
{
	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1	
 	i QStartDate="" d
	.s QStartDate=+$H
	e  d
	.Set QStartDate=##Class(web.DHCEQCommon).TransValueFromPage(QStartDate,"date")
	i QEndDate="" d
	.s QEndDate=+$H
	e  d
	.Set QEndDate=##Class(web.DHCEQCommon).TransValueFromPage(QEndDate,"date")
	s rowid=0
	f  s rowid=$o(^DHCEQPayRecord(rowid)) q:rowid=""  d
	.d ResetVariablesGetPayRecord
	.s TInvalidFlag=$p($g(^DHCEQPayRecord(rowid)),"^",29)
	.q:TInvalidFlag="Y"
	.s TAuditDate=$p($g(^DHCEQPayRecord(rowid)),"^",23)  //审核日期
	.q:(TAuditDate<QStartDate)||(TAuditDate>QEndDate)    //通过审核日期过滤
	.s YLJGDM=""   //医疗机构组织机构代码(标注)
	.s TPayRequestDR=$p($g(^DHCEQPayRecord(rowid)),"^",5)
	.i TPayRequestDR'=""  s FKDH=$p($g(^DHCEQPayRequest(TPayRequestDR)),"^",1)   //付款单号(标注)
	.s HTH=""  //合同号(标注)
	.s TInvoieDR=$p($g(^DHCEQPayRecord(rowid)),"^",1)
	.i TInvoieDR'="" s FPH=$p($g(^DHCEQInvoice(TInvoieDR)),"^",2)  //发票号
	.s FKQH=""  //付款期号(标注)
	.s FKJE=$p($g(^DHCEQPayRecord(rowid)),"^",3)  //付款金额
	.s SJSCSJ=##class(web.DHCEQCommon).TransValueToPage(+$H,"datetime")  //上传日期
	.s YL1=""  //预留一	
 	.d OutputRowGetPayRecord
 	Quit $$$OK 	
ResetVariablesGetPayRecord
	s (YLJGDM,FKDH,HTH,FPH,FKQH,FKJE,SJSCSJ,YL1)=""
	quit	 	
OutputRowGetPayRecord
	s Data=$lb(YLJGDM,FKDH,HTH,FPH,FKQH,FKJE,SJSCSJ,YL1)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetPayRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPayRecordExecute ]
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

ClassMethod GetPayRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPayRecordExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/*
///适用于8.3版本以上
/// 宝安中心医院资产付款单明细数据接口
/// Input:输入参数  :QStartDate:开始日期(YYYY-MM-DD) QEndDate:结束日期(YYYY-MM-DD)
/// Creator:add WY 2021-1-5
/// output::YLJGDM,BFDH,GDZCBM,GG,XH,JLDW,SCCSMC,SYBM,SBDJ,CGRQ,YYNX,GJCZ,BFYY,SQRXM,SQRQ,SHRXM,SHRQ,ZCKPH,SCCSBM,SJSCSJ,YL1
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.Outer.DHCEQForBAZX","GetEquip","2018-03-01","2020-10-12")
Query GetPayRecord(QStartDate As %String = "", QEndDate As %String = "") As %Query(ROWSPEC = "YLJGDM:%String,FKDH:%String,HTH:%String,FPH:%String,FKQH:%String,FKJE:%String,SJSCSJ:%String,YL1:%String") [ SqlProc ]
{
}

ClassMethod GetPayRecordExecute(ByRef qHandle As %Binary, QStartDate As %String = "", QEndDate As %String = "") As %Status
{
	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1	
 	i QStartDate="" d
	.s QStartDate=+$H
	e  d
	.Set QStartDate=##Class(web.DHCEQCommon).TransValueFromPage(QStartDate,"date")
	i QEndDate="" d
	.s QEndDate=+$H
	e  d
	.Set QEndDate=##Class(web.DHCEQCommon).TransValueFromPage(QEndDate,"date")
	s rowid=0
	f  s rowid=$o(^DHCEQPayRecord(rowid)) q:rowid=""  d
	.d ResetVariablesGetPayRecord
	.s TInvalidFlag=$p($g(^DHCEQPayRecord(rowid)),"^",14)
	.q:TInvalidFlag="Y"
	.s YLJGDM=""   //医疗机构组织机构代码(标注)
	.s TPayRequestDR=$p($g(^DHCEQPayRecord(rowid)),"^",1)
	.i TPayRequestDR'=""  s FKDH=$p($g(^DHCEQPayRequest(TPayRequestDR)),"^",1)   //付款单号(标注)
	.s SourceType=$p($g(^DHCEQPayRecord(rowid)),"^",2)
	.s SourceType=$p($g(^DHCEQPayRecord(rowid)),"^",2)
	.s SourceID=$p($g(^DHCEQPayRecord(rowid)),"^",2)
	.s HTH=""  //合同号(标注)
	.s TInvoieDR=$p($g(^DHCEQPayRecord(rowid)),"^",1)
	.i TInvoieDR'="" s FPH=$p($g(^DHCEQInvoice(TInvoieDR)),"^",2)  //发票号
	.s FKQH=""  //付款期号(标注)
	.s FKJE=$p($g(^DHCEQPayRecord(rowid)),"^",3)  //付款金额
	.s SJSCSJ=##class(web.DHCEQCommon).TransValueToPage(+$H,"datetime")  //上传日期
	.s YL1=""  //预留一	
 	.d OutputRowGetPayRecord
 	Quit $$$OK 	
ResetVariablesGetPayRecord
	s (YLJGDM,FKDH,HTH,FPH,FKQH,FKJE,SJSCSJ,YL1)=""
	quit	 	
OutputRowGetPayRecord
	s Data=$lb(YLJGDM,FKDH,HTH,FPH,FKQH,FKJE,SJSCSJ,YL1)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetPayRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPayRecordExecute ]
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

ClassMethod GetPayRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPayRecordExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}
*/
/// 计量台帐(8.3以上版本有记录计量台帐)
/// 宝安中心医院资产采集计量设备
/// Input:输入参数  :YLJGDM,BH,GDZCBM,GDZCMC,GG,XH,LBBM,JLFL,JCDWBM,JCDW,SJSCSJ,YL1
/// Creator:add WY 2021-1-5
/// output::YLJGDM,BFDH,GDZCBM,GG,XH,JLDW,SCCSMC,SYBM,SBDJ,CGRQ,YYNX,GJCZ,BFYY,SQRXM,SQRQ,SHRXM,SHRQ,ZCKPH,SCCSBM,SJSCSJ,YL1
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.Outer.DHCEQForBAZX","GetmeteringEquip")
Query GetmeteringEquip() As %Query(ROWSPEC = "YLJGDM:%String,BH:%String,GDZCBM:%String,GDZCMC:%String,GG:%String,XH:%String,LBBM:%String,JLFL:%String,JCDWBM:%String,JCDW:%String,SJSCSJ:%String,YL1%String") [ SqlProc ]
{
}

ClassMethod GetmeteringEquipExecute(ByRef qHandle As %Binary) As %Status
{
	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
	s RowID=0
	f  s RowID=$o(^DHCEQEquip(RowID)) q:RowID=""  d
	.d ResetVariablesGetEquip
    .s TInvalidFlag=$p($g(^DHCEQEquip(RowID)),"^",59)
    .q:TInvalidFlag'="N"  //过滤无效设备
    .q:$p($g(^DHCEQEquip(RowID)),"^",38)>2  //过滤停用,报废设备
    .s TStockStatus=$p($g(^DHCEQEquip(RowID)),"^",60)
    .q:(TStockStatus="0")||((TStockStatus="3"))   //过滤未入库设备
    .;入库日期为设备转资日期，资产管理和上传以入库日期为准
    .s TTransAssetDate=$p($g(^DHCEQEquip(RowID)),"^",45)
    .;q:(TTransAssetDate<RStartDate)||(TTransAssetDate>REndDate)    
    .s YLJGDM=""   //医疗机构组织机构代码(标注)
    .s BH=""       //院内序号
    .s GDZCBM=$p($g(^DHCEQEquip(RowID)),"^",6)      //固定资产编码
    .s GDZCMC=$p($g(^DHCEQEquip(RowID)),"^",1)        //固定资产名称
 	.s GG=""   //规格(标注)
    .s TModelDR=$p($g(^DHCEQEquip(RowID)),"^",3)
	.i TModelDR'=""  s XH = ##class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)  //型号
    .s TEquiCatDR=$p($g(^DHCEQEquip(RowID)),"^",4)
    .i TEquiCatDR'="" s LBBM=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquiCatDR)),"^",1)  //固定资产分类	
	.;计量台帐(8.3以上版本有记录计量台帐)
	.q:##Class(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttribute("3",RowID,"11")'="1"   //过滤非计量设备，计量设备属性代码"11"
 	.s JLFL=""   //计量分类(标注)
 	.s JCDWBM=""  //检测单位编码(标注)
 	.s JCDW=""    //检测单位(标注)
	.s SJSCSJ=##class(web.DHCEQCommon).TransValueToPage(+$H,"datetime")  //上传日期
	.s YL1=""  //预留一	
 	.d OutputRowGetmeteringEquip
 	Quit $$$OK	
ResetVariablesGetmeteringEquip
	s (YLJGDM,BH,GDZCBM,GDZCMC,GG,XH,LBBM,JLFL,JCDWBM,JCDW,SJSCSJ,YL1)=""
	quit	 	
OutputRowGetmeteringEquip
	s Data=$lb(YLJGDM,BH,GDZCBM,GDZCMC,GG,XH,LBBM,JLFL,JCDWBM,JCDW,SJSCSJ,YL1)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetmeteringEquipFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetmeteringEquipExecute ]
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

ClassMethod GetmeteringEquipClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetmeteringEquipExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 资产计量记录数据采集
/// Input:输入参数
/// Creator:add WY 2021-1-7
/// output:YLJGDM,SYKSBM,GDZCBM,SL,GDZCKPH,JDZQ(Y),JDJGBM,JDJG,JDFL,JDDW,JHJDRQ,GDZCMC,GG,XH,SJJDRQ,ZZDW,SJSCSJ,YL1
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.Outer.DHCEQForBAZX","Getmetering","2018-01-01","2020-12-12")
Query Getmetering(UStartDate As %String = "", UEndDate As %String = "") As %Query(ROWSPEC = "YLJGDM:%String,SYKSBM:%String,GDZCBM:%String,SL:%String,GDZCKPH:%String,JDZQY:%String,JDJGBM:%String,JDJG:%String,JDFL:%String,JDDW:%String,JHJDRQ:%String,GDZCMC:%String,GG:%String,XH:%String,SJJDRQ:%String,ZZDW:%String,SJSCSJ:%String,YL1:%String")
{
}

ClassMethod GetmeteringExecute(ByRef qHandle As %Binary, UStartDate As %String = "", UEndDate As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i UStartDate="" d
	.s UStartDate=+$H-1
	e  d
	.Set UStartDate=##Class(web.DHCEQCommon).TransValueFromPage(UStartDate,"date")
	i UEndDate="" d
	.s UEndDate=+$H
	e  d
	.Set UEndDate=##Class(web.DHCEQCommon).TransValueFromPage(UEndDate,"date")
	s rowid=0
	f  s rowid=$o(^DHCEQMaint(rowid))  quit:rowid=""  d
	.d ResetVariablesGetmetering
	.q:($p($g(^DHCEQMaint(rowid)),"^",2)'="2")&&($p($g(^DHCEQMaint(rowid)),"^",4)'="5")   //过滤非计量记录
	.s TAuditDate=$p($g(^DHCEQMaint(rowid)),"^",19)
	.q:(TAuditDate>UEndDate)||(TAuditDate<UStartDate)  //根据非计量记录审核日期过滤
    .s YLJGDM=""   //医疗机构组织机构代码(标注)
    .s TUseLocDR = $p($g(^DHCEQMaint(rowid)),"^",12)
	.i TUseLocDR '=""  s SYKSBM = ##class(web.DHCEQCommon).GetTrakNameByID("deptcode",TUseLocDR) //使用科室编码
	.s TEquipDR = $p($g(^DHCEQMaint(rowid)),"^",1)
    .s GDZCBM= $p($g(^DHCEQEquip(TEquipDR)),"^",6)  //固定资产编码
    .s SL="1"  //数量
    .s GDZCKPH=$p($g(^DHCEQEquip(TEquipDR)),"^",71)     //固定资产卡片号
    .s SourceID=$p($g(^DHCEQMaint(rowid)),"^",3)
    .i SourceID'="" d
    ..s TCycleNum=$p($g(^DHCEQMaintPlan(SourceID)),"^",7)
    ..s TCycleUnitDR=$p($g(^DHCEQMaintPlan(SourceID)),"^",8)
    ..i TCycleUnitDR'="" s TCycleUnit=$p($g(^DHCEQCCode("DHCEQCCycleUnit",TCycleUnitDR)),"^",2)
    ..s JDZQY=TCycleNum_TCycleUnit   //检定周期(月)
    .s JDJGBM=""    //检定结果编码(标注)
    .s JDJG=""      //检定结果(标注)
    .s JDFL=""      //检定分类(标注)
    .s JDDW=""      //检定单位(标注)
    .s JHJDRQ=""    //计划检定日期(标注)
    .s GDZCMC=$p($g(^DHCEQEquip(TEquipDR)),"^",1)  //固定资产名称
	.s TModelDR=$p($g(^DHCEQEquip(TEquipDR)),"^",3)
	.i TModelDR'="" s GG=##class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)	 //规格
    .s XH=""         //型号(标注) 
    .s SJJDRQ=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMaint(rowid)),"^",5),"date")     //实际检定日期
    .s ZZDW=""       //制造单位(标注)    
	.s SJSCSJ=##class(web.DHCEQCommon).TransValueToPage(+$H,"datetime")  //上传日期
	.s YL1=""  //预留一	
	.d OutputRowGetmetering
	Quit $$$OK
OutputRowGetmetering
	s Data=$lb(YLJGDM,SYKSBM,GDZCBM,SL,GDZCKPH,JDZQY,JDJGBM,JDJG,JDFL,JDDW,JHJDRQ,GDZCMC,GG,XH,SJJDRQ,ZZDW,SJSCSJ,YL1)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetmetering
	s (YLJGDM,SYKSBM,GDZCBM,SL,GDZCKPH,JDZQY,JDJGBM,JDJG,JDFL,JDDW,JHJDRQ,GDZCMC,GG,XH,SJJDRQ,ZZDW,SJSCSJ,YL1)=""
	quit
}

ClassMethod GetmeteringFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetmeteringExecute ]
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

/// 资产保养项目数据采集
/// Input:输入参数
/// Creator:add WY 2021-1-6
/// output::YLJGDM,BYXMMC,SFZX,SFZC,BZ,SJSCSJ,YL1
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.Outer.DHCEQForBAZX","GetMaintItem")
Query GetMaintItem() As %Query(ROWSPEC = "YLJGDM:%String,BYXMMC:%String,SFZX:%String,SFZC:%String,BZ:%String,SJSCSJ:%String,YL1:%String") [ SqlProc ]
{
}

ClassMethod GetMaintItemExecute(ByRef qHandle As %Binary) As %Status
{
	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
	s RowID=0
	for  s RowID=$o(^DHCEQCCode("DHCEQCMaintItem",RowID)) quit:RowID=""  d
	.d ResetVariablesGetMaintItem
	.s TInvalidFlag=$p($g(^DHCEQCCode("DHCEQCMaintItem",RowID)),"^",4)
	.q:TInvalidFlag="Y"
	.q:$p($g(^DHCEQCCode("DHCEQCMaintItem",RowID)),"^",5)'="1"
    .s YLJGDM=""   //医疗机构组织机构代码(标注)
	.s BYXMMC=$p($g(^DHCEQCCode("DHCEQCMaintItem",RowID)),"^",2) //保养项目名称
	.s SFZX=""  //是否执行
	.s SFZC=""  //是否正常
	.s BZ=$p($g(^DHCEQCCode("DHCEQCMaintItem",RowID)),"^",3)  //备注
	.s SJSCSJ=##class(web.DHCEQCommon).TransValueToPage(+$H,"datetime")  //上传日期
	.s YL1=""  //预留一	
 	.d OutputRowGetMaintItem
 	Quit $$$OK	
ResetVariablesGetMaintItem
	s (YLJGDM,BYXMMC,SFZX,SFZC,BZ,SJSCSJ,YL1)=""
	quit	 	
OutputRowGetMaintItem
	s Data=$lb(YLJGDM,BYXMMC,SFZX,SFZC,BZ,SJSCSJ,YL1)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetMaintItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaintItemExecute ]
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

ClassMethod GetMaintItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMaintItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 资产保养记录数据采集
/// Input:输入参数
/// Creator:add WY 2021-1-7
/// output:YLJGDM,BYDH,ZXRXM,JHZXRQ,SJZXRQ,BYSM,YSRXM,ZT,ZCSZBM,SFYBYXM,FKFS,ZPHM,FPH,GDZCGSBM,SHRXM,SJSCSJ,YL1
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.Outer.DHCEQForBAZX","GetMaint","2018-01-01","2020-12-12")
Query GetMaint(SStartDate As %String = "", SEndDate As %String = "") As %Query(ROWSPEC = "YLJGDM:%String,BYDH:%String,ZXRXM:%String,JHZXRQ:%String,SJZXRQ:%String,BYSM:%String,YSRXM:%String,ZT:%String,ZCSZBM:%String,SFYBYXM:%String,FKFS:%String,ZPHM:%String,FPH:%String,GDZCGSBM:%String,SHRXM:%String,SJSCSJ:%String,YL1:%String")
{
}

ClassMethod GetMaintExecute(ByRef qHandle As %Binary, SStartDate As %String = "", SEndDate As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i SStartDate="" d
	.s SStartDate=+$H-1
	e  d
	.Set SStartDate=##Class(web.DHCEQCommon).TransValueFromPage(SStartDate,"date")
	i SEndDate="" d
	.s SEndDate=+$H
	e  d
	.Set SEndDate=##Class(web.DHCEQCommon).TransValueFromPage(SEndDate,"date")
	s rowid=0
	f  s rowid=$o(^DHCEQMaint(rowid))  quit:rowid=""  d
	.d ResetVariablesGetMaint
	.q:$p($g(^DHCEQMaint(rowid)),"^",2)'="1"  //过滤非保养类型
	.s TAuditDate=$p($g(^DHCEQMaint(rowid)),"^",19)
	.q:(TAuditDate>SEndDate)||(TAuditDate<SStartDate)  //根据保养计划审核过滤
    .s YLJGDM=""   //医疗机构组织机构代码(标注)
    .s BYDH=""      //保养单号
    .s TMaintUserDR=$p($g(^DHCEQMaint(rowid)),"^",7) 
    .i TMaintUserDR'="" s ZXRXM=##class(web.DHCEQCommon).GetTrakNameByID("user",TMaintUserDR)    //保养项目的执行人员 姓名
    .s JHZXRQ=""    //保养项目计划执行日期(标注)
    .s SJZXRQ=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMaint(rowid)),"^",5),"date")     //保养项目实际执行日期    
    .s BYSM="" //保养说明
    .s YSRXM=""  //验收人姓名
    .s ZT=$p($g(^DHCEQMaint(rowid)),"^",13)     //状态0:新增|1:提交|2:审核
    .s TUseLocDR = $p($g(^DHCEQMaint(rowid)),"^",12)
	.i TUseLocDR '=""  s ZCSZBM = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR) //资产所在部门
    .s SFYBYXM=""    //是否有保养项目
    .s FKFS=""       //付款方式(标注)
    .s ZPHM=""       //支票号码(标注)
    .s FPH=""       //发票号(标注)
	.s TEquipDR = $p($g(^DHCEQMaint(rowid)),"^",1)
	.s EquipTypeDR=$p($g(^DHCEQEquip(TEquipDR)),"^",63) 
	.i EquipTypeDR'=""  s GDZCGSBM=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",1) //固定资产归属编码
    .s TAuditUserDR=$p($g(^DHCEQMaint(rowid)),"^",18) 
    .i TAuditUserDR'="" s SHRXM=##class(web.DHCEQCommon).GetTrakNameByID("user",TAuditUserDR)    //审核人姓名
	.s SJSCSJ=##class(web.DHCEQCommon).TransValueToPage(+$H,"datetime")  //上传日期
	.s YL1=""  //预留一	
	.d OutputRowGetMaint
	Quit $$$OK
OutputRowGetMaint
	s Data=$lb(YLJGDM,BYDH,ZXRXM,JHZXRQ,SJZXRQ,BYSM,YSRXM,ZT,ZCSZBM,SFYBYXM,FKFS,ZPHM,FPH,GDZCGSBM,SHRXM,SJSCSJ,YL1)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetMaint
	s (YLJGDM,BYDH,ZXRXM,JHZXRQ,SJZXRQ,BYSM,YSRXM,ZT,ZCSZBM,SFYBYXM,FKFS,ZPHM,FPH,GDZCGSBM,SHRXM,SJSCSJ,YL1)=""
	quit
}

ClassMethod GetMaintFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaintExecute ]
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

ClassMethod GetMaintClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMaintExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 资产保养记录明细数据采集
/// Input:输入参数
/// Creator:add WY 2021-1-7
/// output:YLJGDM,BYDH,ZCKPH,BYFY,BYGS,ZXKS,BZ,SFFJ,BYGSDW,SJSCSJ,YL1
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.Outer.DHCEQForBAZX","GetMaintList","2018-01-01","2020-12-12")
Query GetMaintList(TStartDate As %String = "", TEndDate As %String = "") As %Query(ROWSPEC = "YLJGDM:%String,BYDH:%String,ZCKPH:%String,BYFY:%String,BYGS:%String,ZXKS:%String,BZ:%String,SFFJ:%String,BYGSDW:%String,SJSCSJ:%String,YL1:%String")
{
}

ClassMethod GetMaintListExecute(ByRef qHandle As %Binary, TStartDate As %String = "", TEndDate As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i TStartDate="" d
	.s TStartDate=+$H-1
	e  d
	.Set TStartDate=##Class(web.DHCEQCommon).TransValueFromPage(TStartDate,"date")
	i TEndDate="" d
	.s TEndDate=+$H
	e  d
	.Set TEndDate=##Class(web.DHCEQCommon).TransValueFromPage(TEndDate,"date")
	s rowid=0
	f  s rowid=$o(^DHCEQMaint(rowid))  quit:rowid=""  d
	.d ResetVariablesGetMaintList
	.q:$p($g(^DHCEQMaint(rowid)),"^",2)'="1"  //过滤非保养类型
	.s TAuditDate=$p($g(^DHCEQMaint(rowid)),"^",19)
	.q:(TAuditDate<TStartDate)||(TAuditDate>TEndDate)  //根据保养计划审核过滤
    .s YLJGDM=""   //医疗机构组织机构代码(标注)
    .s BYDH=""      //保养单号
	.s TEquipDR = $p($g(^DHCEQMaint(rowid)),"^",1)
	.s ZCKPH=$p($g(^DHCEQEquip(TEquipDR)),"^",71)     //资产卡片号
	.s BYFY=$p($g(^DHCEQMaint(rowid)),"^",9)     //保养费用
	.s BYGS=""     //保养工时(标注)
    .s TMaintLocDR=$p($g(^DHCEQMaint(rowid)),"^",6) 
    .i TMaintLocDR'="" s ZXKS=##class(web.DHCEQCommon).GetTrakNameByID("dept",TMaintLocDR)    //保养项目的执行人员 姓名
	.s BZ=$p($g(^DHCEQMaint(rowid)),"^",14)     //备注
	.i $Data(^DHCEQAffix(0,"Equip",TEquipDR))  d
	..s SFFJ="Y"   //是否附件
	.e  d
	..s SFFJ="N" 
    .s BYGSDW=""   //计量工时的单位(标注)
	.s SJSCSJ=##class(web.DHCEQCommon).TransValueToPage(+$H,"datetime")  //上传日期
	.s YL1=""  //预留一	
	.d OutputRowGetMaintList
	Quit $$$OK
OutputRowGetMaintList
	s Data=$lb(YLJGDM,BYDH,ZCKPH,BYFY,BYGS,ZXKS,BZ,SFFJ,BYGSDW,SJSCSJ,YL1)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetMaintList
	s (YLJGDM,BYDH,ZCKPH,BYFY,BYGS,ZXKS,BZ,SFFJ,BYGSDW,SJSCSJ,YL1)=""
	quit
}

ClassMethod GetMaintListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaintListExecute ]
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

ClassMethod GetMaintListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMaintListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 资产维修数据采集
/// Input:输入参数
/// Creator:add WY 2021-1-6
/// output:YLJGDM,WXJLDH,SFNBWX,GZJB,WXJB,WBWXGCS,WXRQ,QJRQ,WXGS,SFHT,FKDH,HTH,CLF,XLF,JXSM,YSSM,YSRXM,JBRXM,JXRXM,QJRXM,ZT,GDZCKPH,ZCSZBM,WXBM,GHDW,SFFJ,FPH,KYKH,ZDRXM,ZDRQ,SHRXM,ZJLY,GDZCGSBM,SFSYPJ,ZFFS,ZPHM,GDZCBM,GDZCMC,SJSCSJ,YL1
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.Outer.DHCEQForBAZX","GetMaintRequest","2018-01-01","2020-12-12")
Query GetMaintRequest(RStartDate As %String = "", REndDate As %String = "") As %Query(ROWSPEC = "YLJGDM:%String,WXJLDH:%String,SFNBWX:%String,GZJB:%String,WXJB:%String,WBWXGCS:%String,WXRQ:%String,QJRQ:%String,WXGS:%String,SFHT:%String,FKDH:%String,HTH:%String,CLF:%String,XLF:%String,JXSM:%String,YSSM:%String,YSRXM:%String,JBRXM:%String,JXRXM:%String,QJRXM:%String,ZT:%String,GDZCKPH:%String,ZCSZBM:%String,WXBM:%String,GHDW:%String,SFFJ:%String,FPH:%String,KYKH:%String,ZDRXM:%String,ZDRQ:%String,SHRXM:%String,ZJLY:%String,GDZCGSBM:%String,SFSYPJ:%String,ZFFS:%String,ZPHM:%String,GDZCBM:%String,GDZCMC:%String,SJSCSJ:%String,YL1:%String") [ SqlProc ]
{
}

ClassMethod GetMaintRequestExecute(ByRef qHandle As %Binary, RStartDate As %String = "", REndDate As %String = "") As %Status
{
	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	i RStartDate="" d
	.s RStartDate=+$H
	e  d
	.Set RStartDate=##Class(web.DHCEQCommon).TransValueFromPage(RStartDate,"date")
	i REndDate="" d
	.s REndDate=+$H-1
	e  d
	.Set REndDate=##Class(web.DHCEQCommon).TransValueFromPage(REndDate,"date")
	Set RowID=0
	For  Set RowID=$Order(^DHCEQMMaintRequest(RowID))  Quit:RowID=""  Do
	.d ResetVariablesGetMaintRequest
	.q:$p($g(^DHCEQMMaintRequest(RowID)),"^",57)="Y"
	.s TAuditDate=$p($g(^DHCEQMMaintRequest(RowID)),"^",52)
	.q:(TAuditDate>REndDate)||(TAuditDate<RStartDate)
    .s YLJGDM=""   //医疗机构组织机构代码(标注)
    .s WXJLDH=$p($g(^DHCEQMMaintRequest(RowID)),"^",1)  //维修记录单号
    .s TMaintModeDR=$p($g(^DHCEQMMaintRequest(RowID)),"^",28) 
    .i TMaintModeDR="1" d
    ..s SFNBWX="Y" //是否内部维修
    .e  d
    ..s SFNBWX="N"
    .s GZJB=$p($g(^DHCEQMMaintRequest(RowID)),"^",62)   //故障级别 0:一般 1:严重 2:非常严重
    .s WXJB=""   //维修级别(标注)
    .s WBWXGCS=""  //外部维修工程师
    .s WXRQ=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMMaintRequest(RowID)),"^",24),"date")    //维修日期(维修受理开始计算)
    .s QJRQ=""    //取件日期(标注)
    .s WXGS=$p($g(^DHCEQMMaintRequest(RowID)),"^",39)     //维修工时
    .s SFHT="N"   //是否合同
    .s FKDH=""  //付款单号(标注)
    .s HTH=""   //合同号
    .s TContractDR=$p($g(^DHCEQMMaintRequest(RowID)),"^",30)
    .i TContractDR'="" d
    ..s HTH=$p($g(^DHCEQContract(TContractDR)),"^",1)
    ..s SFHT="Y"   //是否合同
    .s CLF=$p($g(^DHCEQMMaintRequest(RowID)),"^",59)  //材料费
    .s XLF=$p($g(^DHCEQMMaintRequest(RowID)),"^",58)  //修理费
    .s JXSM=$p($g(^DHCEQMMaintRequest(RowID)),"^",15)
    .s YSSM=""  //验收说明
    .s YSRXM=""  //验收人姓名
    .s JBRXM=""  //经办人姓名
    .s TAcceptUserDR=$p($g(^DHCEQMMaintRequest(RowID)),"^",26)
 	.i TAcceptUserDR'="" s JXRXM=##class(web.DHCEQCommon).GetTrakNameByID("user",TAcceptUserDR) //经修人姓名
    .s QJRXM=""   //维修配件领取人员姓名
    .s ZT=$p($g(^DHCEQMMaintRequest(RowID)),"^",41)             //状态0:新增|1:提交|2:审核|3:作废
	.s TUseLocDR=$p($g(^DHCEQMMaintRequest(RowID)),"^",6)  
	.i TUseLocDR'="" s ZCSZBM=##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)	 //资产所在部门
	.s TMaintLocDR=$p($g(^DHCEQMMaintRequest(RowID)),"^",29)  
	.i TMaintLocDR'="" s WXBM=##class(web.DHCEQCommon).GetTrakNameByID("dept",TMaintLocDR)	 //维修部门
	.s KYKH=""   //科研卡号(标注)
    .s TAddUserDR=$p($g(^DHCEQMMaintRequest(RowID)),"^",42)
 	.i TAddUserDR'="" s ZDRXM=##class(web.DHCEQCommon).GetTrakNameByID("user",TAddUserDR) //制单人姓名
 	.s ZDRQ=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMMaintRequest(RowID)),"^",43),"date") //制单日期
    .s TAuditUserDR=$p($g(^DHCEQMMaintRequest(RowID)),"^",51)
 	.i TAuditUserDR'="" s SHRXM=##class(web.DHCEQCommon).GetTrakNameByID("user",TAuditUserDR) //审核人姓名
 	.i CLF>0 d
 	..s SFSYPJ="Y"    //是否使用配件
 	.e  d
 	..s SFSYPJ="N"   
 	.s ZFFS=""     //支付方式(标注)
 	.s ZPHM=""   //支票号码(标注)
 	.s TExObjDR=$p($g(^DHCEQMMaintRequest(RowID)),"^",5)
 	.i TExObjDR'="" d
 	..s TEquipDR=$p($g(^DHCEQMExObj(TExObjDR)),"^",5) 
 	..s ZJLY=##Class(web.DHCEQEquip).GetFundsInfo(TEquipDR) //资金来源
 	..s GDZCBM=$p($g(^DHCEQEquip(TEquipDR)),"^",6)     //固定资产编码
    ..s GDZCKPH=$p($g(^DHCEQMExObj(TExObjDR)),"^",2)    //固定资产卡片号
 	..s GDZCMC=$p($g(^DHCEQMExObj(TExObjDR)),"^",1)  //固定资产名称
	..s EquipTypeDR=$p($g(^DHCEQEquip(TEquipDR)),"^",63) 
	..i EquipTypeDR'=""  s GDZCGSBM=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",1) //固定资产归属编码
    ..s TProviderDR=$p($g(^DHCEQEquip(RowID)),"^",25)
 	..i TProviderDR'="" s GHDW=$p($g(^DHCEQCCode("DHCEQCVendor",TProviderDR)),"^",1)   //供应商注册证名称(??)
	..i $Data(^DHCEQAffix(0,"Equip",TEquipDR))  d
	...s SFFJ="Y"   //是否附件
	..e  d
	...s SFFJ="N" 
	..s FPH=##Class(web.DHCEQEquip).GetInvoiceNo(TEquipDR,"1")   //发票号
	.s SJSCSJ=##class(web.DHCEQCommon).TransValueToPage(+$H,"datetime")  //上传日期
	.s YL1=""  //预留一	 	
 	.d OutputRowGetMaintRequest
 	Quit $$$OK	
ResetVariablesGetMaintRequest
	s (YLJGDM,WXJLDH,SFNBWX,GZJB,WXJB,WBWXGCS,WXRQ,QJRQ,WXGS,SFHT,FKDH,HTH,CLF,XLF,JXSM,YSSM,YSRXM,JBRXM,JXRXM,QJRXM,ZT,GDZCKPH,ZCSZBM,WXBM,GHDW,SFFJ,FPH,KYKH,ZDRXM,ZDRQ,SHRXM,ZJLY,GDZCGSBM,SFSYPJ,ZFFS,ZPHM,GDZCBM,GDZCMC,SJSCSJ,YL1)=""
	quit	 	
OutputRowGetMaintRequest
	s Data=$lb(YLJGDM,WXJLDH,SFNBWX,GZJB,WXJB,WBWXGCS,WXRQ,QJRQ,WXGS,SFHT,FKDH,HTH,CLF,XLF,JXSM,YSSM,YSRXM,JBRXM,JXRXM,QJRXM,ZT,GDZCKPH,ZCSZBM,WXBM,GHDW,SFFJ,FPH,KYKH,ZDRXM,ZDRQ,SHRXM,ZJLY,GDZCGSBM,SFSYPJ,ZFFS,ZPHM,GDZCBM,GDZCMC,SJSCSJ,YL1)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetMaintRequestFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaintRequestExecute ]
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

ClassMethod GetMaintRequestClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMaintRequestExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 资产使用记录数据采集
/// Input:输入参数
/// Creator:add WY 2021-1-7
/// output:YLJGDM,SBZT,SYRQ,SYSJ,BRSR,SFYGZ,GZFL,GZRQ,CLMS,CZY,ZDRXM,ZDRQ,ZCKPH,SJSCSJ,YL1
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.Outer.DHCEQForBAZX","GetUseRecord","2018-01-01","2020-12-12")
Query GetUseRecord(WStartDate As %String = "", WEndDate As %String = "") As %Query(ROWSPEC = "YLJGDM:%String,SBZT:%String,SYRQ:%String,SYSJ:%String,BRSR:%String,SFYGZ:%String,GZFL:%String,GZRQ:%String,CLMS:%String,CZY:%String,ZDRXM:%String,ZDRQ:%String,ZCKPH:%String,SJSCSJ:%String,YL1:%String") [ SqlProc ]
{
}

ClassMethod GetUseRecordExecute(ByRef qHandle As %Binary, WStartDate As %String = "", WEndDate As %String = "") As %Status
{
	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	i WStartDate="" d
	.s WStartDate=+$H-1
	e  d
	.Set WStartDate=##Class(web.DHCEQCommon).TransValueFromPage(WStartDate,"date")
	i WEndDate="" d
	.s WEndDate=+$H
	e  d
	.Set WEndDate=##Class(web.DHCEQCommon).TransValueFromPage(WEndDate,"date")
	Set RowID=0
	For  Set RowID=$Order(^DHCEQUseRecord(RowID))  Quit:RowID=""  Do
	.d ResetVariablesGetUseRecord
	.s TUseDate=$p($g(^DHCEQUseRecord(RowID)),"^",3)
	.q:(TUseDate<WStartDate)||(TUseDate>WEndDate)    //根据设备使用日期过滤使用记录
    .s YLJGDM=""   //医疗机构组织机构代码(标注)
    .s SourceType=$p($g(^DHCEQUseRecord(RowID)),"^",1)
    .s SourceID=$p($g(^DHCEQUseRecord(RowID)),"^",2)
    .s AdvanceDisFlag=""
    .i (SourceType="1")&&(SourceID'="") d
    ..s SBZT=##class(web.DHCEQEquip).GetEquipStatusDisplay($p($g(^DHCEQEquip(SourceID)),"^",38))    //设备状态
    ..s AdvanceDisFlag=$p($g(^DHCEQEquip(SourceID)),"^",93)
    ..s ZCKPH=$p($g(^DHCEQEquip(SourceID)),"^",71)   //资产卡片号	

    .s SYRQ=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQUseRecord(RowID)),"^",3),"date")  //设备的使用日期
    .s SYSJ=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQUseRecord(RowID)),"^",3),"time")   //设备开机的时间
    .s BRSR=$p($g(^DHCEQUseRecord(RowID)),"^",12)  //本日收入
    .i (AdvanceDisFlag>2) d
    ..s SFYGZ="Y"    //是否有故障
    ..s GZFL=""      //故障分类
    ..s GZRQ=""      //故障日期
    ..s CLMS=""      //处理描述
    .e  d
    ..s SFYGZ="N"    //是否有故障
    .s TOperator=$p($g(^DHCEQUseRecord(RowID)),"^",39)
 	.i TOperator'="" s CZY=##class(web.DHCEQCommon).GetTrakNameByID("user",TOperator) //操作员
    .s TAddUserDR=$p($g(^DHCEQUseRecord(RowID)),"^",22)
 	.i TAddUserDR'="" s ZDRXM=##class(web.DHCEQCommon).GetTrakNameByID("user",TAddUserDR) //制单人姓名
 	.s ZDRQ=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQUseRecord(RowID)),"^",23),"date") //制单日期	
	.s SJSCSJ=##class(web.DHCEQCommon).TransValueToPage(+$H,"datetime")  //上传日期
	.s YL1=""  //预留一	 	
 	.d OutputRowGetUseRecord
 	Quit $$$OK	
ResetVariablesGetUseRecord
	s (YLJGDM,SBZT,SYRQ,SYSJ,BRSR,SFYGZ,GZFL,GZRQ,CLMS,CZY,ZDRXM,ZDRQ,ZCKPH,SJSCSJ,YL1)=""
	quit	 	
OutputRowGetUseRecord
	s Data=$lb(YLJGDM,SBZT,SYRQ,SYSJ,BRSR,SFYGZ,GZFL,GZRQ,CLMS,CZY,ZDRXM,ZDRQ,ZCKPH,SJSCSJ,YL1)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetUseRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUseRecordExecute ]
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

ClassMethod GetUseRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUseRecordExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 资产使用记录明细
/// Input:输入参数
/// Creator:add WY 2021-1-7
/// output:
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.Outer.DHCEQForBAZX","GetUseRecordList","2018-01-01","2020-12-12")
Query GetUseRecordList(XStartDate As %String = "", xEndDate As %String = "") As %Query(ROWSPEC = "YLJGDM:%String,GDZCKPH:%String,SYJS:%String,DJRXM:%String,BLH:%String,HZXM:%String,BCSR:%String,RGFY:%String,CLFY:%String,YPFY:%String,SDFY:%String,GLFY:%String,QTFY:%String,SYRC:%String,BBRC:%String,JSDJLDW:%String,JCXMXH:%String,SYSJ:%String,SJSCSJ:%String,YL1:%String") [ SqlProc ]
{
}

ClassMethod GetUseRecordListExecute(ByRef qHandle As %Binary, XStartDate As %String = "", xEndDate As %String = "") As %Status
{
	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	i XStartDate="" d
	.s XStartDate=+$H
	e  d
	.Set XStartDate=##Class(web.DHCEQCommon).TransValueFromPage(XStartDate,"date")
	i xEndDate="" d
	.s xEndDate=+$H-1
	e  d
	.Set xEndDate=##Class(web.DHCEQCommon).TransValueFromPage(xEndDate,"date")
	Set RowID=0
	For  Set RowID=$Order(^DHCEQUseRecord(RowID))  Quit:RowID=""  Do
	.d ResetVariablesGetUseRecordList
	.s TUseDate=$p($g(^DHCEQUseRecord(RowID)),"^",3)
	.q:(TUseDate>xEndDate)||(TUseDate<XStartDate)    //根据设备使用日期过滤使用记录
    .s YLJGDM=""   //医疗机构组织机构代码(标注)
    .s SourceType=$p($g(^DHCEQUseRecord(RowID)),"^",1)
    .s SourceID=$p($g(^DHCEQUseRecord(RowID)),"^",2)
    .s AdvanceDisFlag=""
    .i (SourceType="1")&&(SourceID'="") d
    ..s GDZCKPH=$p($g(^DHCEQEquip(SourceID)),"^",71)   //固定资产卡片号
    .s TStartTime=$p($g(^DHCEQUseRecord(RowID)),"^",4)
    .s TEndTime=$p($g(^DHCEQUseRecord(RowID)),"^",6)
    .s SYJS=TEndTime-TEndTime   //使用机时
    .s DJRXM=""                //登记人姓名
    .s BLH=""                  //病历号(标注)
    .s HZXM=$p($g(^DHCEQUseRecord(RowID)),"^",46)                //患者姓名(标注)
    .s BCSR=$p($g(^DHCEQUseRecord(RowID)),"^",12)   //本次收入
    .s RGFY=""         //人工费用(标注)
    .s CLFY=""           //材料费用(标注)
    .s YPFY=""         //药品费用(标注)
    .s SDFY=""          //水电费用(标注)
    .s GLFY=""           //管理费用(标注)
    .s QTFY=""          //其他费用(标注)
    .s SYRC=""           //使用人次(标注)
    .s BBRC=""          //病变人次(标注)
    .s TWorkLoadUnitDR=$p($g(^DHCEQUseRecord(RowID)),"^",8)
    .i TWorkLoadUnitDR'=""  s JSDJLDW=##class(web.DHCEQCommon).GetTrakNameByID("uom",TWorkLoadUnitDR)       //机时的计量单位
    .s TServiceItemDR=$p($g(^DHCEQUseRecord(RowID)),"^",15)
    .i TServiceItemDR'="" s JCXMXH=$p($g(^DHCEQCCode("DHCEQCServiceItem",TServiceItemDR)),"^",2)         //检查项目序号
    .s SYSJ=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQUseRecord(RowID)),"^",3),"time")        //使用时间
   	.s SJSCSJ=##class(web.DHCEQCommon).TransValueToPage(+$H,"datetime")  //上传日期
	.s YL1=""  //预留一	 	
 	.d OutputRowGetUseRecordList
 	Quit $$$OK	
ResetVariablesGetUseRecordList
	s (YLJGDM,GDZCKPH,SYJS,DJRXM,BLH,HZXM,BCSR,RGFY,CLFY,YPFY,SDFY,GLFY,QTFY,SYRC,BBRC,JSDJLDW,JCXMXH,SYSJ,SJSCSJ,YL1)=""
	quit	 	
OutputRowGetUseRecordList
	s Data=$lb(YLJGDM,GDZCKPH,SYJS,DJRXM,BLH,HZXM,BCSR,RGFY,CLFY,YPFY,SDFY,GLFY,QTFY,SYRC,BBRC,JSDJLDW,JCXMXH,SYSJ,SJSCSJ,YL1)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetUseRecordListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUseRecordListExecute ]
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

ClassMethod GetUseRecordListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUseRecordListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query GetInvoice(InvoiceNo As %String = "", ProvderDR As %String = "", StartDate As %String = "", EndDate As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurHospID As %String = "", CurUserID As %String = "") As %Query(ROWSPEC = "TNo:%String,TRowID:%String,TCode:%String,TDate:%String,TAmountFee:%String,TTypeDR:%String,TInvoiceType:%String,TCertificateDR:%String,TCertificateNo:%String,TProviderDR:%String,TProvider:%String,TCustomer:%String,TInvoiceDept:%String,TPayedAmountFee:%String,TStatus:%String,TRemark:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String")
{
}

ClassMethod GetInvoiceExecute(ByRef qHandle As %Binary, InvoiceNo As %String = "", ProvderDR As %String = "", StartDate As %String = "", EndDate As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurHospID As %String = "", CurUserID As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
 	i StartDate="" d
	.s StartDate=+$H-1
	e  d
	.Set StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	i EndDate="" d
	.s EndDate=+$H
	e  d
	.Set EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	s InvoiceNo=$ZCONVERT(InvoiceNo,"U")
	d BuildDataGetInvoice
	Quit $$$OK
BuildDataGetInvoice
	s rowid=0
	f  s rowid=$o(^DHCEQInvoice(rowid)) q:rowid=""  d
	.d ResetVariablesGetInvoice
	.s TInvalidFlag=$p($g(^DHCEQInvoice(rowid)),"^",16)
	.q:TInvalidFlag="Y"
	.s TRowID=rowid
	.s TCode=$p($g(^DHCEQInvoice(rowid)),"^",1)
	.s TNo=$p($g(^DHCEQInvoice(rowid)),"^",2)
	.q:(InvoiceNo'="")&($ZCONVERT(TNo,"U")'[InvoiceNo)
	.q:($p($g(^DHCEQInvoice(rowid)),"^",3)<StartDate)||($p($g(^DHCEQInvoice(rowid)),"^",3)>EndDate)
	.s TDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInvoice(rowid)),"^",3),"date")
	.s TAmountFee=$p($g(^DHCEQInvoice(rowid)),"^",4)
	.s TTypeDR=$p($g(^DHCEQInvoice(rowid)),"^",6)
	.i TTypeDR'="" s TInvoiceType=$P(^DHCEQCCode("DHCEQCInvoiceType",TTypeDR),"^",2)
	.s TCertificateDR=$p($g(^DHCEQInvoice(rowid)),"^",15)
	.i TCertificateDR'=""  s TCertificateNo=$p($g(^DHCEQCertificate(TCertificateDR)),"^",2)
  	.s TProviderDR=$p($g(^DHCEQInvoice(rowid)),"^",5)	;ProviderDR
  	.q:(ProvderDR'="")&&(TProviderDR'=ProvderDR)
  	.i TProviderDR'="" s TProvider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
  	.s TCustomer=$p($g(^DHCEQInvoice(rowid)),"^",7)
  	.s TInvoiceDept=$p($g(^DHCEQInvoice(rowid)),"^",8)
  	.s TPayedAmountFee=$p($g(^DHCEQInvoice(rowid)),"^",9)
  	.s TStatus=$p($g(^DHCEQInvoice(rowid)),"^",10)
  	.s TRemark=$p($g(^DHCEQInvoice(rowid)),"^",14)
  	.s THold1=$p($g(^DHCEQInvoice(rowid)),"^",17)
  	.s THold2=$p($g(^DHCEQInvoice(rowid)),"^",18)
  	.s THold3=$p($g(^DHCEQInvoice(rowid)),"^",19)
  	.s THold4=$p($g(^DHCEQInvoice(rowid)),"^",20)
  	.s THold5=$p($g(^DHCEQInvoice(rowid)),"^",21)
	.d OutputRowGetInvoice
	quit
OutputRowGetInvoice
	s Data=$lb(TNo,TRowID,TCode,TDate,TAmountFee,TTypeDR,TInvoiceType,TCertificateDR,TCertificateNo,TProviderDR,TProvider,TCustomer,TInvoiceDept,TPayedAmountFee,TStatus,TRemark,THold1,THold2,THold3,THold4,THold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetInvoice
	s (TNo,TRowID,TCode,TDate,TAmountFee,TTypeDR,TInvoiceType,TCertificateDR,TCertificateNo,TProviderDR,TProvider,TCustomer,TInvoiceDept,TPayedAmountFee,TStatus,TRemark,THold1,THold2,THold3,THold4,THold5)=""
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

}
