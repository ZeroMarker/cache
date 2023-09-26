Class web.DHCEQASnapShot Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Add By DJ 2016-09-19
/// 描述:配件库存快照
ClassMethod AStockSnap()
{
	s snapDate=+$H
	s snapTime=$p($H,",",2)
	
	s SnapID=$I(^DHCEQASnapShot(0,"SnapID"))
	s ^DHCEQASnapShot(SnapID,"Begin")=snapDate_","_snapTime
	
	s node="AStock"
	s ^DHCEQASnapShot(SnapID,node,0,"Begin")=$H	
	s ASRowID=0 
	f  s ASRowID=$o(^DHCEQAStock(ASRowID))  quit:ASRowID=""  d
	.s ^DHCEQASnapShot(SnapID,node,ASRowID)=$g(^DHCEQAStock(ASRowID))
	.s tmp=##Class(web.DHCEQASnapShot).GetAStockByID(ASRowID)
	.s ^DHCEQASnapShot(SnapID,node,ASRowID,"EX")=tmp
	s ^DHCEQASnapShot(SnapID,node,0,"End")=$H


	s node="AStockDetail"
	s ^DHCEQASnapShot(SnapID,node,0,"Begin")=$H	
	s ASDRowID=0 
	f  s ASDRowID=$o(^DHCEQAStockDetail(ASDRowID))  quit:ASDRowID=""  d
	.s ^DHCEQASnapShot(SnapID,node,ASDRowID)=$g(^DHCEQAStockDetail(ASDRowID))
	.s tmp=##Class(web.DHCEQASnapShot).GetAStockDetailByID(ASDRowID)
	.s ^DHCEQASnapShot(SnapID,node,ASDRowID,"EX")=tmp
	s ^DHCEQASnapShot(SnapID,node,0,"End")=$H

	s ^DHCEQASnapShot(SnapID,"End")=$H
	q 0
}

/// Add By DJ 2016-09-19
/// 描述:根据配件库存RowID获取解析信息
ClassMethod GetAStockByID(vASRowID)
{
	s ASInfo=""
	i vASRowID="" q ASInfo
	s (TLoc,TBaseUOMDR,TBaseUOM,TAccessoryType)=""
	s TLocDR =	$p($g(^DHCEQAStock(vASRowID)),"^",1) //科室
	i TLocDR'="" s TLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
	s TItemDR = $p($g(^DHCEQAStock(vASRowID)),"^",2) //配件项ID
	i TItemDR'="" d
	.s TBaseUOMDR = $p($g(^DHCEQCCode("DHCEQCAccessory",TItemDR)),"^",5)
	.i TBaseUOMDR '="" s TBaseUOM=##class(web.DHCEQCommon).GetTrakNameByID("uom",(TBaseUOMDR))
	s TAccessoryTypeDR = $p($g(^DHCEQAStock(vASRowID)),"^",5) //类组
	i TAccessoryTypeDR'="" s TAccessoryType=$p($g(^DHCEQCCode("DHCEQCAccessoryType",TAccessoryTypeDR)),"^",2)
	s ASInfo=TLoc_"^"_TBaseUOMDR_"^"_TBaseUOM_"^"_TAccessoryType
	q ASInfo
}

/// Add By DJ 2016-09-19
/// 描述:根据配件库存明细RowID获取解析信息
ClassMethod GetAStockDetailByID(vASDRowID)
{
	s ASDInfo=""
	i vASDRowID="" q ASDInfo
	s (TLoc,TShortDesc,TAccessoryType,TBaseUOM,TManuFactory,TCurProvider)=""
	s TLocDR =	$p($g(^DHCEQAStockDetail(vASDRowID)),"^",1) //科室
	i TLocDR'="" s TLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
	s TItemDR=$p($g(^DHCEQAStockDetail(vASDRowID)),"^",2)
	i TItemDR'="" s TShortDesc=$p($g(^DHCEQCCode("DHCEQCAccessory",TItemDR)),"^",3)
	s TAccessoryTypeDR = $p($g(^DHCEQAStockDetail(vASDRowID)),"^",11) //类组
	i TAccessoryTypeDR'="" s TAccessoryType=$p($g(^DHCEQCCode("DHCEQCAccessoryType",TAccessoryTypeDR)),"^",2)
	s TBaseUOMDR =	$p($g(^DHCEQAStockDetail(vASDRowID)),"^",13) //单位
	i TBaseUOMDR '="" s TBaseUOM=##class(web.DHCEQCommon).GetTrakNameByID("uom",(TBaseUOMDR))
	s TManuFactoryDR =	$p($g(^DHCEQAStockDetail(vASDRowID)),"^",14) //厂家
	i TManuFactoryDR'="" s TManuFactory=$p($g(^DHCEQCCode("DHCEQCManuFacturer",TManuFactoryDR)),"^",2)
	s TCurProviderDR=$p($g(^DHCEQAStockDetail(vASDRowID)),"^",16)	//供应商
	i TCurProviderDR'="" s TCurProvider=$p($g(^DHCEQCCode("DHCEQCVendor",TCurProviderDR)),"^",2)
	s ASDInfo=TLoc_"^"_TShortDesc_"^"_TAccessoryType_"^"_TBaseUOM_"^"_TManuFactory_"^"_TCurProvider
	q ASDInfo
}

}
