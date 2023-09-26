Class web.DHCEQ.Plat.CTPicType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 获取业务可访问图片类型
/// w ##Class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTPicType","GetPicType","","",0)
Query GetPicType(RowID As %String = "", Desc As %String = "", CurrentSourceType = "", Code As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String")
{
}

ClassMethod GetPicTypeExecute(ByRef qHandle As %Binary, RowID As %String = "", Desc As %String = "", CurrentSourceType As %String = "", Code As %String = "") As %Status
{
	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
	i CurrentSourceType '="" 
	{
		s PicSourceTypeDR=0
		For  Set PicSourceTypeDR=$Order(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR)) Quit:PicSourceTypeDR=""  Do BuildDataGetPicType
 	
		s TPicTypeDR=""
		for  Set TPicTypeDR=$o(DHCEQTemp(TPicTypeDR)) q:TPicTypeDR=""  d
		.Do ResetVariablesLookUpInfo
		.Set TRowID =TPicTypeDR
		.Quit:(RowID'="")&&(TRowID'=RowID)
		.Set TCode=$Piece($Get(^DHCEQCCode("DHCEQCPicType",TRowID)),"^",1)
		.q:(Code'="")&&(TCode'[Code)
		.Set TDesc=$Piece($Get(^DHCEQCCode("DHCEQCPicType",TRowID)),"^",2)
		.Quit:(Desc'="")&&(TDesc'[Desc)
		.q:($Piece($Get(^DHCEQCCode("DHCEQCPicType",TRowID)),"^",4)="Y")
		.Do OutputRowLookUpInfo
	}
	else
	{
		s TPicTypeDR=0
		for  Set TPicTypeDR=$o(^DHCEQCCode("DHCEQCPicType",TPicTypeDR)) q:TPicTypeDR=""  d
		.Do ResetVariablesLookUpInfo
		.Set TRowID =TPicTypeDR
		.Quit:(RowID'="")&&(TRowID'=RowID)
		.Set TCode=$Piece($Get(^DHCEQCCode("DHCEQCPicType",TRowID)),"^",1)
		.q:(Code'="")&&(TCode'[Code)
		.Set TDesc=$Piece($Get(^DHCEQCCode("DHCEQCPicType",TRowID)),"^",2)
		.Quit:(Desc'="")&&(TDesc'[Desc)
		.q:($Piece($Get(^DHCEQCCode("DHCEQCPicType",TRowID)),"^",4)="Y")
		.Do OutputRowLookUpInfo
	}
	
	Quit $$$OK	
BuildDataGetPicType
	s TSourceType=$p(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR),"^",1)
	q:(CurrentSourceType'="")&&(CurrentSourceType'=TSourceType)
	s TPicTypeDR=$p(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR),"^",2)
	Set TInvalidFlag=$p(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR),"^",9)
	Quit:TInvalidFlag="Y"
	s DHCEQTemp(TPicTypeDR)=TPicTypeDR
	quit
OutputRowLookUpInfo
	s Data=$lb(TRowID,TCode,TDesc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesLookUpInfo
	Set (TRowID,TCode,TDesc)=""
	Quit
}

ClassMethod GetPicTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPicTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPicTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPicTypeExecute ]
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

/// MZY0023	1306895		2020-05-08	修正处理
/// 获取业务下所有图片类型及其访问权限
/// 参数:
/// 		Desc	图片类型
/// 		CurrentSourceType	业务代码
/// 				0：无 11:开箱验收 12:安装调试验收 21:入库、22:转移 23:减少 31:维修、32保养、33检查、34报废、35折旧、41使用记录、51设备调帐,52 设备 53设备盘点 61工程管理 62科研课题63证件 91采购申请 92采购计划 93采购招标 94采购合同 95保修合同 ;A01:配件入库  A02:配件转移  A03:配件退货  A04:配件减少
/// d ##Class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTPicType","GetPicTypeAndAccess","",11)
/// Modefied by zc0107 2021-11-15 添加TSourceTypeDesc输出
/// Modefied by WY 2022-8-26 添加TdefaultFlag 默认访问标志
Query GetPicTypeAndAccess(Desc As %String = "", CurrentSourceType) As %Query(ROWSPEC = "TRowID:%String,TDesc:%String,TPicTypeDR:%String,TPicFlag:%String,TFileFlag:%String,TMustFlag:%String,TApproveSetDR:%String,TApproveSet:%String,TSourceTypeDesc:%String,TDefaultFlag:%String,TSort:%String")
{
}

ClassMethod GetPicTypeAndAccessExecute(ByRef qHandle As %Binary, Desc As %String = "", CurrentSourceType) As %Status
{
	new repid, index, TPicTypeDR, TRowID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
	i CurrentSourceType ="" q $$$OK
	
	s TPicTypeDR=0
	for  Set TPicTypeDR=$o(^DHCEQCCode("DHCEQCPicType",TPicTypeDR)) q:TPicTypeDR=""  d
	.q:($Piece($Get(^DHCEQCCode("DHCEQCPicType",TPicTypeDR)),"^",4)="Y")
	.q:##Class(web.DHCEQ.Lib.Common).PicTypeIsIn(TPicTypeDR)=1  // 安全组可访问的文件与图片类型
	.Do ResetVariablesPicTypeAndAccess
	.Set TDesc=$Piece($Get(^DHCEQCCode("DHCEQCPicType",TPicTypeDR)),"^",2)
	.Quit:(Desc'="")&&(TDesc'[Desc)
	.
	.s TRowID=$o(^DHCEQCCode("DHCEQCPicSourceType",0,"SourceTypeIndex",CurrentSourceType,TPicTypeDR,""))
	.i (TRowID'="")&&($p(^DHCEQCCode("DHCEQCPicSourceType",TRowID),"^",9)'="Y") d
	..;获取业务设置的文件与图片类型信息
	..s TPicFlag=$p(^DHCEQCCode("DHCEQCPicSourceType",TRowID),"^",10)
	..s TFileFlag=$p(^DHCEQCCode("DHCEQCPicSourceType",TRowID),"^",11)
	..s TMustFlag=$p(^DHCEQCCode("DHCEQCPicSourceType",TRowID),"^",12)
	..s TApproveSetDR=$p(^DHCEQCCode("DHCEQCPicSourceType",TRowID),"^",13)
	..i TApproveSetDR'="" s TApproveSet=$p(^DHCEQCCode("DHCEQCApproveSet",TApproveSetDR),"^",2)
	..s TSort=$p(^DHCEQCCode("DHCEQCPicSourceType",TRowID),"^",14)
	..s TDefaultFlag=$p(^DHCEQCCode("DHCEQCPicSourceType",TRowID),"^",15) //add by wy 2022-8-26 图片默认访问标识
    .s TSourceTypeDesc=##Class(web.DHCEQ.Plat.CTBussType).GetBussTypeForPicture(CurrentSourceType)
	.Do OutputRowPicTypeAndAccess
	
	Quit $$$OK	
OutputRowPicTypeAndAccess
	Set Data=$lb(TRowID,TDesc,TPicTypeDR,TPicFlag,TFileFlag,TMustFlag,TApproveSetDR,TApproveSet,TSourceTypeDesc,TDefaultFlag,TSort)  /// Modefied by zc0107 2021-11-15 添加TSourceTypeDesc输出
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesPicTypeAndAccess
	Set (TRowID,TDesc,TPicFlag,TFileFlag,TMustFlag,TApproveSetDR,TApproveSet,TSourceTypeDesc,TDefaultFlag,TSort)=""   /// Modefied by zc0107 2021-11-15 添加TSourceTypeDesc输出
	Quit
}

ClassMethod GetPicTypeAndAccessFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPicTypeAndAccessExecute ]
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

ClassMethod GetPicTypeAndAccessClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPicTypeAndAccessExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SaveData(PTData)
{
	new PList
	s PList(1)=$p($G(PTData),"^",1)
	s PList(2)=$p($G(PTData),"^",2)
	s PList(3)=$p($G(PTData),"^",3)
	s PList(5)=$p($G(PTData),"^",5)
	
	s tmpid=""      //add by czf 550193
	&SQL(select PT_RowID into tmpid from SQLUser.DHC_EQCPicType where PT_Code=:PList(2) and PT_Desc=:PList(3) and PT_InvalidFlag='N')
	if (tmpid'="") q "数据有重复"
	
	i (PList(1)="")&&(PList(5)="N")
	{
		k PList(1)
		//注意提交后要刷新
		//&SQL(select PT_RowID from SQLUser.DHC_EQCPicType where PT_Code=:PList(2) or PT_Desc=:PList(3))  ///modify by lmm 2017-04-06 359392
		//if (SQLCODE'=100) q -1   ///modify by lmm 2017-04-06 359392
		&SQL(insert into SQLUser.DHC_EQCPicType values :PList())
	}
	else
	{
		//&SQL(select PT_RowID from SQLUser.DHC_EQCPicType where (PT_Code=:PList(2) or PT_Desc=:PList(3)) and PT_RowID!=:PList(1))
		//if (SQLCODE'=100) q -1	///modify by lmm 2017-04-11 361681
		s PTRowID=PList(1)
		k PList(1)
		&SQL(Update SQLUser.DHC_EQCPicType values :PList() where PT_RowID=:PTRowID)
	}
	
	q:SQLCODE SQLCODE
	q $g(%ROWID)
}

// 需求号：266171  start    add by csy 2016-10-17 

ClassMethod DeletePTData(PTRowID)
{
	//modify by mwz 2017-10-27需求号467118
	new SQLCODE
	s count=0
	&SQL(select count(*) into :count from SQLUser.DHC_EQCPicSourceType where (PST_PicTypeDR=:PTRowID) and PST_Invalidflag='N' )
	i count'=0 q -1
	&SQL(Update SQLUSER.DHC_EQCPicType Set PT_InvalidFlag='Y' where PT_RowID=:PTRowID)
	q SQLCODE
}

//  需求号：266171  end  add by csy 2016-10-17  

/// Add By DJ 2017-04-27
/// 描述:根据业务类型获取图片类型  
ClassMethod GetPicTypeBySourceType(vSourceType As %String = "")
{
	i vSourceType="" q ""
	s ReturnInfo=""
	s PicTypeDR=0
	f  s PicTypeDR=$o(^DHCEQCCode("DHCEQCPicSourceType",0,"SourceTypeIndex",vSourceType,PicTypeDR))  q:PicTypeDR=""  d
	.s PicType=$p($g(^DHCEQCCode("DHCEQCPicType",PicTypeDR)),"^",2)
	.s PSTRowID=0
	.s InvalidFlag="N"
	.f  s PSTRowID=$o(^DHCEQCCode("DHCEQCPicSourceType",0,"SourceTypeIndex",vSourceType,PicTypeDR,PSTRowID))  q:(PSTRowID="")||(InvalidFlag="Y")  d
	..s InvalidFlag=$p(^DHCEQCCode("DHCEQCPicSourceType",PSTRowID),"^",9)
	.q:InvalidFlag="Y"
	.i ReturnInfo=""  d
	..s ReturnInfo="^..........&"_PicTypeDR_"^"_PicType
	.e  d
	..s ReturnInfo=ReturnInfo_"&"_PicTypeDR_"^"_PicType
	
	q ReturnInfo
}

// hisui改造

/*
ClassMethod SavePicSourceType(SourceType, IDs)
{
	s SQLCODE=0
	&SQL(delete from  sqluser.DHC_EQCPicSourceType where PST_SourceType=:SourceType)
	i SQLCODE=100 s SQLCODE=0
	i SQLCODE q SQLCODE
	new Length,i
	s Length=$l(IDs,",")
	for i=1:1:Length
	{
		k PLIST
		s PLIST(2)=SourceType
		s PLIST(3)=$p(IDs,",",i)
		s PLIST(10)="N"      //add by wy 20181114
		&SQL(insert into SQLUser.DHC_EQCPicSourceType values :PLIST())
		q:SQLCODE'=0
	}
	q SQLCODE
}*/
/// Modiedy by zc0058 重写保存方法  begin
ClassMethod SavePicSourceType(SourceType, listVal)
{
	s SQLCODE=0
	new Length,i,PSTRowID
	s Length=$l(listVal,"#")
	for i=1:1:Length
	{
		q:SQLCODE'=0
		k PLIST
		s List=	$p(listVal,"#",i)
		s PSTRowID=$p(List,"^",1)
		s PLIST(2)=SourceType
		s PLIST(3)=$p(List,"^",3)
		s PLIST(10)="N"      //add by wy 20181114
		s PLIST(11)=$p(List,"^",11)
		s PLIST(12)=$p(List,"^",12)
		s PLIST(13)=$p(List,"^",13)
		s PLIST(14)=$p(List,"^",14)
		s PLIST(15)=$p(List,"^",15)
		s PLIST(16)=$p(List,"^",16)  //add by WY 2022-8-26 增加图片默认访问
		if (PSTRowID'="")
		{
			if ((PLIST(11)'="Y")&&(PLIST(12)'="Y"))
			{
				&SQL(delete from sqluser.DHC_EQCPicSourceType  where PST_RowID=:PSTRowID)
			}
			else
			{
				&SQL(Update SQLUSER.DHC_EQCPicSourceType values :PLIST() where PST_RowID=:PSTRowID)
			}
		}
		else
		{
			if ((PLIST(11)="Y")||(PLIST(12)="Y"))
			{
				&SQL(insert into SQLUser.DHC_EQCPicSourceType values :PLIST())
			}
		}
		
	}
	q SQLCODE
}

/// Modiedy by zc0058 重写保存方法  end

}
