Import sqluser

/// Descript:	新老系统交换处理高值数据
/// Creator:	zhangxiao
/// CreateDate:	20200615
Class web.DHCSTMService.HvNewVersion.ServiceForHvDataSync Extends %RegisteredObject [ Not ProcedureBlock ]
{

Parameter UseFlag = "N";

/// 服务器调用ip控制，避免上线后新备份测试库调用程序在老数据库产生高值数据
Parameter LocalIP = "10.1.132.63";

/// Parameter LocalIP = $lb("10.1.132.63","10.1.132.65")
/// w ##class(web.DHCSTMService.HvNewVersion.ServiceForHvDataSync).GetUseFlag()
ClassMethod GetUseFlag()
{
	new
	;或扩展成其他方法
	s Flag="N"
	s ServerIP=##class(web.DHCSTMHUI.Common.UtilCommon).ServerIP()
	s LocalIPStr=..#LocalIP
	s LoccalIPList=$lfs(LocalIPStr,",")
	s UseFlag=..#UseFlag
	
	s IPFlag="Y"
	i (LocalIPStr'="")&&'$lf(LoccalIPList,ServerIP) s IPFlag="N"

	;或扩展成其他方法
	i (UseFlag="Y")&&(IPFlag="Y") s Flag="Y"

	q Flag
}

/// 接口连通性测试
/// d ##class(web.DHCSTMService.HvNewVersion.ServiceForHvDataSync).Test()
ClassMethod Test()
{
	s SciServiceObj=##class(web.DHCSTMService.HvNewVersion.HvDataSyncServiceSoap).%New()
	s UseFlag=..GetUseFlag()
	w UseFlag ,!
	s operateResultStream=SciServiceObj.Test()
	w operateResultStream
}

/// 新系统开医嘱或者停医嘱在老系统生成调整单调用
/// 开医嘱调用ListData为-1，停医嘱调用ListData为1
/// Date: 20200617
/// Creator:zx
/// Return: 
/// w ##class(web.DHCSTMService.HvNewVersion.ServiceForHvDataSync).CreateAdjForOld("GZ20200814001","1")
ClassMethod CreateAdjForOld(HVBarCode As %String, ListData As %String) As %String
{
	n (HVBarCode,ListData)
	s Ret=0
	s Qty=$p(ListData,"^",1)
	s UseFlag=..GetUseFlag()
	q:UseFlag'="Y" Ret
	q:HVBarCode="" Ret
	s Info=##class(web.DHCSTMService.HvNewVersion.HvDataSyncServiceSoap).%New()
	s Err=Info.CreateInfoHvForOld(HVBarCode,Qty,"Adj")
	q Err
}

/// 从新库向老库同步出库单(转移入库接收调用)
/// Date: 20200617
/// Creator:zx
/// Return: 
/// w ##class(web.DHCSTMService.HvNewVersion.ServiceForHvDataSync).CreateInitForOld(522)
ClassMethod CreateInitForOld(Init As %String) As %String
{
	n (Init)
	
	s Ret=0
	s UseFlag=..GetUseFlag()
	q:UseFlag'="Y" Ret
	q:Init="" Ret
	s HvFlag=##class(web.DHCSTMHUI.Common.UtilCommon).GetCertDocHVFlag(Init,"T")
	
	q:HvFlag'="Y" Ret  ;非高值单据不进行处理
	
	s FrlocId=$p(^DHCINIT(Init),"^",5)
	s TolocId=$p(^DHCINIT(Init),"^",6)
	s UserId=$p(^DHCINIT(Init),"^",8)
	s UserCode="",FrLocCode="",ToLocCode=""
	s:UserId'="" UserCode=$p(^SSU("SSUSR",UserId),"^",1)
	s:FrlocId'="" FrLocCode=$p(^CTLOC(FrlocId),"^",1)
	s:TolocId'="" ToLocCode=$p(^CTLOC(TolocId),"^",1)
	;s MainData=FrlocId_"^"_TolocId_"^"_UserCode
	s MainData=FrLocCode_"^"_ToLocCode_"^"_UserCode
	
	s InitiStr=""
	s Ch=0
	f  s Ch=$o(^DHCINIT(Init,"ITI",Ch)) q:Ch=""  d
	.q:+Ch=0
	.s Initi=Init_"||"_Ch
	.s HVBarCode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr("T",Initi)
	.q:HVBarCode=""
	.;s HVBarCode=HVBarCode_"1"  ;20200617本机测试修改
	.i InitiStr="" d
	..s InitiStr=HVBarCode
	.e  d
	..s InitiStr=InitiStr_"#"_HVBarCode
	
	q:InitiStr="" ""
	s Info=##class(web.DHCSTMService.HvNewVersion.HvDataSyncServiceSoap).%New()
	s Err=Info.CreateInfoHvForOld(MainData,InitiStr,"T")
	q Err
}

/// 从新库向老库同步高值条码和入库单(入库审核的时候调用)
/// Date: 20200617
/// Creator:zx
/// Return: 
/// w ##class(web.DHCSTMService.HvNewVersion.ServiceForHvDataSync).CreateRecForOld(336)
ClassMethod CreateRecForOld(RecId As %String) As %String
{
	n (RecId)
	s UseFlag=..GetUseFlag()
	q:UseFlag'="Y" Ret
	q:+RecId=0 ""
	s HvFlag=##class(web.DHCSTMHUI.Common.UtilCommon).GetCertDocHVFlag(RecId,"G")
	q:HvFlag'="Y" ""
	s LocId=$p(^DHCINGR(RecId),"^",13)
	q:+LocId=0 ""
	s DhcLocId=$o(^DHCLOC(0,"LOC",LocId,0))
	q:+DhcLocId=0 ""
	s MainLoc=$p(^DHCLOC(DhcLocId),"^",6)
	q:+MainLoc=0  ;没有支配科室非虚库不调接口
	
	s VendorId=$p(^DHCINGR(RecId),"^",3)
	s UserId=$p(^DHCINGR(RecId),"^",16)
	s StkGrpId=$p(^DHCINGR(RecId),"^",28)
	s StkGrpId="" ;新老系统同步，类组不填
	s UserCode="",VendorCode="",LocCode=""
	s:UserId'="" UserCode=$p(^SSU("SSUSR",UserId),"^",1)
	s:VendorId'="" VendorCode=$p(^APC("APCVM",VendorId),"^",2)
	s:LocId'="" LocCode=$p(^CTLOC(LocId),"^",1)
	;s MainData=VendorId_"^"_LocId_"^"_UserId
	s MainData=VendorCode_"^"_LocCode_"^"_UserCode
	
	s IngriStr=""
	s Ch=0
	f  s Ch=$o(^DHCINGR(RecId,"GRI",Ch)) q:Ch=""  d
	.q:+Ch=0
	.s Ingri=RecId_"||"_Ch
	.s Inci=$p(^DHCINGR(RecId,"GRI",Ch),"^",25) ;库存项id
	.s InciCode=$p(^INCI(Inci,1),"^",1)
	.s BatNo=$p(^DHCINGR(RecId,"GRI",Ch),"^",13) ;批号
	.s ExpDate=$p(^DHCINGR(RecId,"GRI",Ch),"^",9) ;效期
	.s:ExpDate'="" ExpDate=$zd(ExpDate,3)
	.s ManfId=$p(^DHCINGR(RecId,"GRI",Ch),"^",29) ;厂商
	.s ManfId=""
	.s Rp=$p(^DHCINGR(RecId,"GRI",Ch),"^",30) 
	.s HVBarCode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr("G",Ingri)
	.q:HVBarCode=""
	.;s HVBarCode=HVBarCode_"1"  ;20200617本机测试修改
	.s Qty=$p(^DHCINGR(RecId,"GRI",Ch),"^",4) 
	.s Data=InciCode_"^"_BatNo_"^"_ExpDate_"^"_ManfId_"^"_Rp_"^"_HVBarCode_"^"_Qty
	.i IngriStr="" d
	..s IngriStr=Data
	.e  d
	..s IngriStr=IngriStr_"#"_Data
	q:IngriStr="" ""
	s Info=##class(web.DHCSTMService.HvNewVersion.HvDataSyncServiceSoap).%New()
	s Err=Info.CreateInfoHvForOld(MainData,IngriStr,"G")
	q Err
}

}
