Class web.DHCEQ.Process.DHCEQCPicSourceType Extends %Library.RegisteredObject [ Not ProcedureBlock ]
{

/// add by zy 20180814  ZY0171
/// 产品库功能代码
/// 调整为0：无 11:开箱验收 12:安装调试验收 21:入库、22:转移 23:减少 31:维修、32保养、33检查、34报废、35折旧、41使用记录、51设备调帐,52 设备,53 设备盘点,54 盘盈设备 61工程管理 62科研课题63证件 91采购申请 92采购计划 93采购招标 94采购合同 95保修合同 ;A01:配件入库  A02:配件转移  A03:配件退货  A04:配件减少
/// 每增加一种义务，都需要修改##Class(web.DHCEQ.Process.DHCEQPicture).GetSourceIDs(CurrentSourceType,CurrentSourceID,SourceType)与
/// ##Class(web.DHCEQ.Process.DHCEQPicture).SourceTypeAccessable(CurrentSourceType,SourceType)
/// 以确定图片信息可以正确的被访问
ClassMethod GetPicSourceType(Start As %Integer, Limit As %Integer)
{
	//modified by czf 792330
	//modify by lmm 2019-10-12
	//modified by czf 20200408 基础数据global CZF0105
	// modified by csj 2020-11-19 添加入库、报废汇总图片上传
    //modified by ZY 20220926  2826780
    Quit "{""total"":7,""rows"":[{""id"":11,""SourceType"":""开箱验收""},{""id"":""21"",""SourceType"":""入库""},{""id"":""22"",""SourceType"":""转移""},{""id"":""31"",""SourceType"":""维修""},{""id"":""32"",""SourceType"":""保养""},{""id"":""33"",""SourceType"":""检查""},{""id"":51,""SourceType"":""设备调账""},{""id"":52,""SourceType"":""设备""},{""id"":53,""SourceType"":""设备盘点""},{""id"":54,""SourceType"":""设备盘盈""},{""id"":""63-1"",""SourceType"":""供应商资质""},{""id"":94,""SourceType"":""采购合同""},{""id"":95,""SourceType"":""保修合同""},{""id"":96,""SourceType"":""产品""},{""id"":""63-2"",""SourceType"":""生产厂商""},{""id"":""67"",""SourceType"":""公告""},{""id"":""34"",""SourceType"":""报废""},{""id"":""34-1"",""SourceType"":""报废汇总""},{""id"":""91"",""SourceType"":""采购申请""},{""id"":""91-1"",""SourceType"":""采购申请厂家报价""},{""id"":""93"",""SourceType"":""招标管理""},{""id"":""63"",""SourceType"":""资质管理""},{""id"":""A01"",""SourceType"":""配件入库""},{""id"":""76"",""SourceType"":""付款""},{""id"":""63-4"",""SourceType"":""供应商授权""}]}"   // MZY0147 3164887     2022-12-20
}

/// 判断业务流程是否可以访问某个具体图片类型，允许访问时返回1
ClassMethod IsPicTypeInSourceType(CurrentSourceType As %String = "", PicTypeDR As %String = "")
{
	Set PicSourceTypeDR=$o(^DHCEQCCode("DHCEQCPicSourceType",0,"SourceTypeIndex",CurrentSourceType,PicTypeDR,""))
	q:(PicSourceTypeDR="")||($p(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR),"^",9)="Y") 0
	q 1
	/*
	set ResultJson=0
	s PicSourceTypeDR=0
	for  set PicSourceTypeDR=$o(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR)) q:PicSourceTypeDR=""  d
	.s TSourceType=$p(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR),"^",1)
	.q:(CurrentSourceType'="")&&(TSourceType'=CurrentSourceType)
	.s TPicTypeDR=$p(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR),"^",2)
	.s:(PicTypeDR'="")&&(TPicTypeDR=PicTypeDR) ResultJson=1
	q ResultJson*/
}

/// extjs 图片预览，加载图片类型叶子节点时调用
/// Modefied by zc0060 20200329 条件图片与文件标识vFlag：0 图片 1 文件
/// Modefied by zc0094 2021-1-14 添加入参vAppendFlag:1 视频  2 音频 
/// w ##Class(web.DHCEQ.Process.DHCEQCPicSourceType).GetPicTypeMenu("52","",0,85)
ClassMethod GetPicTypeMenu(CurrentSourceType As %String = "", CurrentSourceID As %String = "", vFlag As %String = "0", vGroupID As %String = "", vAppendFlag As %String = "")
{
	// MZY0153	3218789		2023-02-20	修正默认类型
	s DefualtPicType=""
	i CurrentSourceType=52 s DefualtPicType=##class(web.DHCEQCommon).GetSysInfo("990046")  /// Modefied by zc0123 2022-10-17 默认图片类型
	New menusJson,DHCEQTempMenu
	set menusJson="["
	s PicSourceTypeDR=0
	for  set PicSourceTypeDR=$o(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR)) q:PicSourceTypeDR=""  d
	.s TSort=$p(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR),"^",14)
	.i TSort="" s TSort=99999
	.s SourceType=$p(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR),"^",1)
	.q:$p(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR),"^",9)="Y"
	./// Modefied by zc0060 20200329 图片与文件区分  begin
	.q:(vFlag=0)&&($p(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR),"^",10)'="Y")
	.q:(vFlag=1)&&($p(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR),"^",11)'="Y")
	./// Modefied by zc0060 20200329 图片与文件区分  end
	.Quit:(0=##Class(web.DHCEQ.Process.DHCEQPicture).SourceTypeAccessable(CurrentSourceType,SourceType))
	.s PicTypeDR=$p(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR),"^",2)
	.q:##Class(web.DHCEQ.Lib.Common).PicTypeIsIn(PicTypeDR,vGroupID)=1   //Moidefied by zc0071 安全组可访问的文件与图片类型
	./// Modefied by zc0094 2021-1-14 begin
	.q:(vAppendFlag=1)&&($P($G(^DHCEQCCode("DHCEQCPicType",PicTypeDR)),"^",3)'="1")
	.q:(vAppendFlag=2)&&($P($G(^DHCEQCCode("DHCEQCPicType",PicTypeDR)),"^",3)'="2")
	./// Modefied by zc0094 2021-1-14 end
	.s ^DHCEQTempMenu(TSort,PicTypeDR)=PicTypeDR
	s PicTypeDR=0
	s TSort=0
	for  s TSort=$o(^DHCEQTempMenu(TSort))  q:TSort=""  d
	.for  s PicTypeDR=$o(^DHCEQTempMenu(TSort,PicTypeDR)) q:PicTypeDR=""  d
	..s PicCode=$p(^DHCEQCCode("DHCEQCPicType",PicTypeDR),"^",1)
	..s PicDesc=$p(^DHCEQCCode("DHCEQCPicType",PicTypeDR),"^",2)
	..s checkd=$case(##Class(web.DHCEQ.Process.DHCEQCPicSourceType).IsPicTypeInSourceType(CurrentSourceType,PicTypeDR),1:"true",0:"false")
	../// Modefied by zc0094 2021-1-14 begin
	..;s menusJson=menusJson_"{""id"":"_PicTypeDR_",""text"":"""_PicDesc_""",""icon"":"""",""leaf"":true,""checked"":"_checkd_"}"
	..i DefualtPicType'=PicTypeDR d    /// Modefied by zc0123 2022-10-17 默认图片类型放在前面 begin
	...i menusJson="[" d
	....s menusJson=menusJson_"{""id"":"_PicTypeDR_",""text"":"""_PicDesc_""",""icon"":"""",""leaf"":true,""checked"":"_checkd_"}"
	...else  d
	....s menusJson=menusJson_",{""id"":"_PicTypeDR_",""text"":"""_PicDesc_""",""icon"":"""",""leaf"":true,""checked"":"_checkd_"}"
	..e  d
	...i menusJson="[" d
	....s menusJson=menusJson_"{""id"":"_PicTypeDR_",""text"":"""_PicDesc_""",""icon"":"""",""leaf"":true,""checked"":"_checkd_"}"
	...else  d
	....s menusJson="[{""id"":"_PicTypeDR_",""text"":"""_PicDesc_""",""icon"":"""",""leaf"":true,""checked"":"_checkd_"},"_$p(menusJson,"[",2)
	../// Modefied by zc0094 2021-1-14 end  /// Modefied by zc0123 2022-10-17 默认图片类型放在前面 begin
	s menusJson=menusJson_"]"
	k ^DHCEQTempMenu
	q menusJson
}

ClassMethod GetMainMenu()
{
	q "[{""id"":""0"",""text"":""图片类型"",""icon"":"""",""leaf"":false}]"
}

ClassMethod SaveData(PSTData)
{
	new PList
	s PList(1)=$p($G(PSTData),"^",1)
	s PList(2)=$p($G(PSTData),"^",2)
	s PList(3)=$p($G(PSTData),"^",3)
	s PList(10)=$p($G(PSTData),"^",10)
	i (PList(1)="")&&(PList(10)="N")
	{
		k PList(1)
		//注意提交后要刷新
		&SQL(insert into SQLUser.DHC_EQCPicSourceType values :PList())
	}
	else
	{
		s PSTRowID=PList(1)
		k PList(1)
		&SQL(Update SQLUser.DHC_EQCPicSourceType values :PList() where PST_RowID=:PSTRowID)
	}
	q:SQLCODE SQLCODE
	q $g(%ROWID)
}

/// add by czf 20200702
/// 获取当前业务类型可访问的图片或文件类型
/// CurrentSourceType:业务类型
/// CurrentSourceID:业务ID
/// vFlag:条件图片与文件标识  0 图片 1 文件
/// CurGroupID:安全组ID
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Process.DHCEQCPicSourceType","GetPicTypeMenus","31","","0","85")
Query GetPicTypeMenus(CurrentSourceType As %String = "", CurrentSourceID As %String = "", vFlag As %String = "0", CurGroupID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TDefaultFlag:%String")
{
}

ClassMethod GetPicTypeMenusExecute(ByRef qHandle As %Binary, CurrentSourceType As %String = "", CurrentSourceID As %String = "", vFlag As %String = "", CurGroupID As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	s PicSourceTypeDR=0
	for  set PicSourceTypeDR=$o(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR)) q:PicSourceTypeDR=""  d
	.s SourceType=$p(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR),"^",1)
	.q:$p(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR),"^",9)="Y"
	.q:(vFlag=0)&&($p(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR),"^",10)'="Y")
	.q:(vFlag=1)&&($p(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR),"^",11)'="Y")
	.q:(0=##Class(web.DHCEQ.Process.DHCEQPicture).SourceTypeAccessable(CurrentSourceType,SourceType))
	.s PicTypeDR=$p(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR),"^",2)
	.q:##Class(web.DHCEQ.Lib.Common).PicTypeIsIn(PicTypeDR,CurGroupID)=1   //Moidefied by zc0071 安全组可访问的文件与图片类型
	.s DHCEQTempPicTypeMenu(PicTypeDR)=PicTypeDR
	
	s PicTypeDR=""
	for  s PicTypeDR=$o(DHCEQTempPicTypeMenu(PicTypeDR)) q:PicTypeDR=""  d
	.d ResetGetPicTypeMenus
	.q:(0=##Class(web.DHCEQ.Process.DHCEQCPicSourceType).IsPicTypeInSourceType(CurrentSourceType,PicTypeDR))
	.;s picSourceTypeDR=$o(^DHCEQCCode("DHCEQCPicSourceType",0,"SourceTypeIndex",CurrentSourceType,PicTypeDR,""))
	.;s THold1=$p(^DHCEQCCode("DHCEQCPicSourceType",picSourceTypeDR),"^",14)		//图片数量限制czf 20200907
	.s TRowID=PicTypeDR
	.s TCode=$p(^DHCEQCCode("DHCEQCPicType",PicTypeDR),"^",1)
	.s TDesc=$p(^DHCEQCCode("DHCEQCPicType",PicTypeDR),"^",2)
	.; Add By QW20210106 BUG:  begin
	.s TRemark=$p(^DHCEQCCode("DHCEQCPicType",PicTypeDR),"^",3)
	.q:(vFlag=2)&&(TRemark'="1")
	.; Add By QW20210106 BUG:  end
	.s TDefaultFlag=$p(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR),"^",15)  //Add By QW20220826 增加输出默认标记
	.d OutputRowGetPicTypeMenus
	Quit $$$OK
OutputRowGetPicTypeMenus

	s Data=$lb(TRowID,TCode,TDesc,TDefaultFlag) //Modify By QW20220826 增加输出默认标记
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetGetPicTypeMenus
	s (TRowID,TCode,TDesc,TDefaultFlag)="" //Modify By QW20220826 增加输出默认标记
	quit
}

ClassMethod GetPicTypeMenusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPicTypeMenusExecute ]
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

ClassMethod GetPicTypeMenusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPicTypeMenusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
