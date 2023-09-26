/// 名称: web.DHCEQ.Plat.CTModel
/// 描述: 设备规格型号
/// 编写者：ZX
/// 编写日期: 2018-09-02
/// 产品组：设备管理
Class web.DHCEQ.Plat.CTModel Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      ZX
/// CreatDate：    2018-09-02
/// Description:   设备规格型号LookUp所需Query
/// Table：        DHC_EQCLocation
/// Input：        ItemDR:设备项ID
///                Name:机型名称
/// Add By QW2021 bug号:QW00 增加输出TItem
Query GetModel(ItemDR, Name) As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String,THistoryFee:%String,TItemDR:%String")
{
}

ClassMethod GetModelExecute(ByRef qHandle As %Binary, ItemDR, valName) As %Status
{
 	new repid,  index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	
	d BuildDataGetModelList
	Quit $$$OK
BuildDataGetModelList
	f  s rowid=$o(^DHCEQCCode("DHCEQCModel",rowid))  quit:rowid=""  d
	.d ResetVariablesGetModelList
	.s RowID = rowid
	.s Flag = $p($g(^DHCEQCCode("DHCEQCModel",rowid)),"^",5)
	.q:Flag="Y"
	.s Name = $p($g(^DHCEQCCode("DHCEQCModel",rowid)),"^",2)
	.s Code=$p($g(^DHCEQCCode("DHCEQCModel",rowid)),"^",1)
	.q:(valName'="")&&(($ZCONVERT(Name ,"U")'[$ZCONVERT(valName,"U"))&&($ZCONVERT(Code,"U")'[$ZCONVERT(valName,"U")))
	.s Item=$p($g(^DHCEQCCode("DHCEQCModel",rowid)),"^",4)
	.q:(ItemDR'="")&&(ItemDR'=Item)&&(Item'="")
	.s HistoryFee=$p($g(^DHCEQCCode("DHCEQCModel",rowid)),"^",7)  //Hold2 历史原值
	.d OutputRowGetModelList
	quit
OutputRowGetModelList
	s Data=$lb(Name,RowID,Code,HistoryFee,Item) ;Modified By QW2021 bug号:QW00 增加输出TItem
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetModelList
	s (Name,RowID,Code,HistoryFee,Item)=""  ;Modified By QW2021 bug号:QW00 增加输出TItem
	quit
}

ClassMethod GetModelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetModelExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetModelClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetModelExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:ZX 2018-12-11
/// 目的:系统自动录入机型
/// 描述:设备机型为手工录入方式时,检测机型表是否存在当前数据.是则返回RowID,否则新增记录并返回RowID
/// 输入: Data:机型名称 ItemDR:设备项rowid
/// 输出: 无
/// 返回值: 成功返回RowID, 失败返回错误代码
ClassMethod UpdModel(Data, ItemDR)
{
	n MRowID,ModelOperMethod
	s MRowID=""
	s SQLCODE=0
	s Model=$p(Data,"^",1)
	s OriginalFee=$p(Data,"^",2)
	if ItemDR=""
	{
		s SQLCODE=-1
		q SQLCODE
	}
	s ModelOperMethod=##class(web.DHCEQCommon).GetSysInfo("201004")
	if (ModelOperMethod=0)||(Model="") q ""
	&SQL(Select M_RowID Into:MRowID from SQLUSER.DHC_EQCModel Where M_Code=:Model and M_Desc=:Model and M_ItemDR=:ItemDR)
	if MRowID="" //新增当前机型
	{
		&SQL(Insert Into SQLUSER.DHC_EQCModel(M_Code,M_desc,M_ItemDR,M_InvalidFlag,M_Hold2) Values(:Model,:Model,:ItemDR,'N',:OriginalFee))
		if SQLCODE 
		{
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		s MRowID=$G(%ROWID)
	}
	else
	{
		&SQL(update SQLUSER.DHC_EQCModel Set M_InvalidFlag='N',M_Hold2=:OriginalFee where M_RowID=:MRowID)
		if SQLCODE 
		{
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,MRowID)
}

}
