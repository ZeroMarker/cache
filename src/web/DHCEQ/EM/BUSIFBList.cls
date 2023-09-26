Import SQLUser

/// 修改人： Mozy 2011-01-19
/// 描述:设备供应商应标记录
Class web.DHCEQ.EM.BUSIFBList Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// add 20191012 by zy 修改列输出，DHC_EQIFBList用于存参考规格型号信息，用于json方式存储
/// Mozy	2011-1-19
/// 招标包查询
/// Code As %String = "", Desc As %String = ""
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSIFBList","IFBListDetail","1","28","")
Query IFBListDetail(SourceType As %String = "", SourceID As %String = "", IFBBRowID As %String = "") As %Query(ROWSPEC = "IFBLRowID:%String,IFBLVendorDR:%String,IFBLVendor:%String,IFBLManuFactoryDR:%String,IFBLManuFactory:%String,IFBLModelDR:%String,IFBLModel:%String,IFBLBrandDR:%String,IFBLBrand:%String,IFBLArg:%String,IFBLPrice:%String,IFBLAmount:%String,IFBLWinFlag:%String,IFBLWinQty:%String,IFBLCandidacy:%String,IFBLCandidacySeq:%String,IFBLScore:%String,IFBLRemark:%String,IFBLRow:%String,IFBLProviderHandler:%String,IFBLProviderTel:%String,IFBLConfigure:%String,IFBLFeatures:%String,IFBLDealPrice:%String,IFBLMaterialAndPrice:%String,IFBLQuanlity:%String,IFBLGuaranteePeriodNum:%String,IFBLArriveNum:%String,IFBLHold1:%String,IFBLHold2:%String,IFBLHold3:%String,IFBLHold4:%String,IFBLHold5:%String,IFBLSourceType:%String,IFBLSourceID:%String")
{
}

ClassMethod IFBListDetailExecute(ByRef qHandle As %Binary, SourceType As %String = "", SourceID As %String = "", IFBBRowID As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	///add 20191012 by zy 控制table的输出
	if (SourceType="")||(SourceID="") 
	{
		Do ResetVariablesIFBListDetail
		Do OutputRowIFBListDetail
		Quit $$$OK
	}
	else
	{
		s OutFlag=0
		s rowid=0
		For  Set rowid=$Order(^DHCEQIFBList(0,"Source",SourceType,SourceID,rowid))  Quit:rowid=""  Do
		.Do ResetVariablesIFBListDetail
		.s DataList=$Get(^DHCEQIFBList(rowid))
		.s TRowID = rowid
		.s TVendor=$Piece(DataList,"^",3)
		.s TVendorDR=$Piece(DataList,"^",4)
		.s TManuFactory=$Piece(DataList,"^",5)
		.s TManuFactoryDR=$Piece(DataList,"^",6)
		.s TModelDR=$Piece(DataList,"^",8)
		.s TModel=$Piece(DataList,"^",7)
		.s TBrand=$Piece(DataList,"^",9)
		.s TBrandDR=$Piece(DataList,"^",10)
		.Set TArg=$Piece(DataList,"^",11)
		.Set TPrice=$Piece(DataList,"^",12)
		.Set TPrice = ##Class(web.DHCEQCommon).FormatNumber(TPrice,"")   //add by lmm 2020-06-04 UI
		.Set TAmount=$Piece(DataList,"^",13)
		.Set TWinFlag=$Piece(DataList,"^",14)
		.If TWinFlag'="" d
		..If TWinFlag="Y" Set TWinFlag="是"
		..If TWinFlag="N" Set TWinFlag="否"
		.Set TWinQty=$Piece(DataList,"^",15)
		.Set TCandidacy	=$Piece(DataList,"^",16)
		.Set TCandidacySeq=$Piece(DataList,"^",17)
		.Set TScore=$Piece(DataList,"^",18)
		.Set TRemark=$Piece(DataList,"^",19)
		.;add by csy 2017-07-25 设备供应商应标记录扩展
		.Set TProviderHandler	=$Piece(DataList,"^",20)
		.Set TProviderTel=$Piece(DataList,"^",21)
		.Set TConfigure=$Piece(DataList,"^",22)
		.Set TFeatures=$Piece(DataList,"^",23)
		.Set TDealPrice=$Piece(DataList,"^",24)
		.Set TMaterialAndPrice	=$Piece(DataList,"^",25)
		.Set TQuanlity	=$Piece(DataList,"^",26)
		.Set TGuaranteePeriodNum=$Piece(DataList,"^",27)
		.Set TArriveNum	=$Piece(DataList,"^",28)
		.Set THold1	=$Piece(DataList,"^",29)  //招标明细ID
		.//q:(THold1="")||(THold1'[IFBBRowID)
		.Set THold2	=$Piece(DataList,"^",30)
		.Set THold3	=$Piece(DataList,"^",31)
		.Set THold4	=$Piece(DataList,"^",32)
		.Set THold5	=$Piece(DataList,"^",33)

		.Do OutputRowIFBListDetail
		.s OutFlag=1
		i OutFlag=0
		{
			Do ResetVariablesIFBListDetail
			Do OutputRowIFBListDetail
		}
	}
	Quit $$$OK
OutputRowIFBListDetail
	Set TRow=index	// 20150914  Mozy0165 序号
	Set Data=$lb(TRowID,TVendorDR,TVendor,TManuFactoryDR,TManuFactory,TModelDR,TModel,TBrandDR,TBrand,TArg,TPrice,TAmount,TWinFlag,TWinQty,TCandidacy,TCandidacySeq,TScore,TRemark,TRow,TProviderHandler,TProviderTel,TConfigure,TFeatures,TDealPrice,TMaterialAndPrice,TQuanlity,TGuaranteePeriodNum,TArriveNum,THold1,THold2,THold3,THold4,THold5,SourceType,SourceID)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesIFBListDetail
	Set (TRowID,TVendorDR,TVendor,TManuFactoryDR,TManuFactory,TModelDR,TModel,TBrandDR,TBrand,TArg,TPrice,TAmount,TWinFlag,TWinQty,TCandidacy,TCandidacySeq,TScore,TRemark,TRow,TProviderHandler,TProviderTel,TConfigure,TFeatures,TDealPrice,TMaterialAndPrice,TQuanlity,TGuaranteePeriodNum,TArriveNum,THold1,THold2,THold3,THold4,THold5)=""
	Quit
}

ClassMethod IFBListDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = IFBListDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
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

ClassMethod IFBListDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = IFBListDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// modified by ZY0202 新增入参OperateType 需要默认值
/// modified by wy 20191213新增入参OperateType
ClassMethod SaveData(val, ElementID, TemplateID, OperateType As %String = "0")
{
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")  //add by zx 2019-09-11 分割标志替换
    Set $ZT="ERROR"
	TSTART
    s length=$l(val,SplitRowCode)
	f k=1:1:length  d
	.s OneList=$p(val,SplitRowCode,k)
	.s SQLCODE=##Class(web.DHCEQ.EM.BUSIFBList).SaveDataList(OneList,OperateType)
	.q:SQLCODE'=0
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	if (ElementID'="")&&(TemplateID'="")
	{
		s tmp=""
		&SQL(select TL_RowID into :tmp from sqluser.DHC_EQTemplateList where TL_TemplateDR=:TemplateID and TL_ElementDR=:ElementID)
		i tmp'="" 
		{
			&SQL(update sqluser.DHC_EQTemplateList set TL_Result=:length where TL_RowID=:tmp)
			i SQLCODE
			{
				TROLLBACK
				Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
			}
		}
	}
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,length)
    //q SQLCODE_"^"_length
ERROR 
	TRollBack	
	Set ErrorMsg=$ZE	  
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,ErrorMsg)
}

/// author: zx 2019-09-11
/// desc: 应标供应商保存
/// input: val:保存数据json格式串 OperateType: 0 保存及更新,1 删除
/// output: 失败返回SQLCODE 成功返回SQLCODE及RowID
ClassMethod SaveDataList(val As %Library.String = "", OperateType As %Library.String = "")
{
	Kill PLIST,LIST,RowID
	Set $ZT="SaveDataERROR"
	TSTART
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(val)
	s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQIFBList",JsonData,.PLIST)
	s RowID=JsonData.IFBLRowID
	If (+OperateType=1)
	{
		i RowID="" Quit "-1"
	 	&SQL(delete from sqluser.DHC_EQIFBList where IFBL_RowID=:RowID)
 	}
 	If (+OperateType=0) //新增,更新
 	{
		if RowID'=""
		{
			///modified by ZY0240
			///判断中标是否有多个//也有地方存在一个包多个公司中标的情况
		 	Set IFBBrowid=JsonData.IFBLSourceID
			i (##class(web.DHCEQ.EM.BUSIFBList).CheckWinFlag(IFBBrowid,RowID,"Y")>0) q "-2"
			
		 	if ($Piece($Get(^DHCEQIFBList(RowID)),"^",14)="Y")
		 	{
			    &SQL(Update SQLUSER.DHC_EQIFBList Values :PLIST() where IFBL_RowID = :RowID)
			    i SQLCODE
				{
					TROLLBACK
					Quit SQLCODE
				}
			 	kill LIST
			 	;if (PLIST(15)'="Y") Set PLIST(15)="N"	//需求号:850239 modified by wjt 2019-03-18
		 		Set IFBBrowid=JsonData.IFBLSourceID
				Set LIST(6)=	JsonData.IFBLWinQty		//	IFBB_Quantity	6
				Set LIST(7)=	JsonData.IFBLManuFactoryDR		//	IFBB_ManuFactoryDR	7
				Set LIST(8)=	JsonData.IFBLModelDR		//	IFBB_ModelDR	8
				Set LIST(9)=	JsonData.IFBLArg		//	IFBB_Arg	9
				Set LIST(12)=	JsonData.IFBLPrice		//	IFBB_WinPrice	12
				Set LIST(13)=	JsonData.IFBLRemark		//	IFBB_Remark	13
			    &SQL(Update SQLUSER.DHC_EQIFBBag Values :LIST() where IFBB_RowID = :IFBBrowid)
			    i SQLCODE
				{
					TROLLBACK
					Quit SQLCODE
				}
			}
			else
			{ 
			     &SQL(Update SQLUSER.DHC_EQIFBList Values :PLIST() where IFBL_RowID = :RowID)
			     i SQLCODE
				{
					TROLLBACK
					Quit SQLCODE
				}
			}
		}
		else
		{
			&SQL(insert into SQLUSER.DHC_EQIFBList Values :PLIST())
			s RowID=$g(%ROWID)
		}
		i SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
 	}
 	TCOMMIT
	Quit SQLCODE
SaveDataERROR 
	TRollBack	
	Set ErrorMsg=$ZE	  
	Quit "SaveDataERROR"_ErrorMsg
}

/// author: zx 2019-09-11
/// desc: 获取应标供应商单条明细数据
/// input: DHC_EQIFBList表RowID
/// output: 返回解析数据json格式串
ClassMethod GetIFBListByID(RowID As %Library.String = "")
{
	//add by zx 2019-09-11
	s $ZT="ERRORGetIFBList"
	s ObjIFBList=##Class(User.DHCEQIFBList).%OpenId(RowID)
	s IFBListInfo=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(ObjIFBList)
	d IFBListInfo.%Set("IFBLRowID",RowID)
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,IFBListInfo)
ERRORGetIFBList
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012",ErrorMsg)
}

/// 检测其他中标单位
/// 返回其他中标单位数量
/// w ##class(web.DHCEQ.EM.BUSIFBList).CheckWinFlag(1,3,"Y")
ClassMethod CheckWinFlag(IFBBagDR As %Library.String = "", IFBLRowID As %Library.String = "", WinFlag As %Library.String = "")
{
	Quit:WinFlag'="Y" 0
	New flag,id
	Set flag=0
	Set id=0
	For  Set id=$Order(^DHCEQIFBList(0,"IFBBag",IFBBagDR,id))  Quit:id=""  Do
	.Set WinFlag=$Piece($Get(^DHCEQIFBList(id)),"^",8)
	.If (WinFlag="Y")&&(IFBLRowID'=id) Set flag=flag+1
	.
	
	Quit flag
}

/// 检测招标明细是否有中标供应商
/// 返回： 0	没有			1 有		其他	异常
/// w ##class(web.DHCEQ.EM.BUSIFBList).CheckWinVendor(1,3,14)
ClassMethod CheckWinVendor(SourceType As %Library.String = "", SourceID As %Library.String = "", IFBBDR As %Library.String = "")
{
	New flag,id,rowid,IFBLDR,CountWinFlag
	q:IFBBDR="" 0
	Set flag=""	
	Set CountWinFlag = 0
	Set IFBLDR=0
	For  Set IFBLDR=$Order(^DHCEQIFBList(0,"Source",SourceType,SourceID,IFBLDR))  Quit:(IFBLDR="")  Do
	.If $Piece($Get(^DHCEQIFBList(IFBLDR)),"^",14)="Y" Set CountWinFlag = CountWinFlag+1
	If CountWinFlag'=1 d
	.If flag'="" Set flag=flag_"^"
	.Set flag=flag_CountWinFlag
	else  d
   .Set flag=1
	Quit flag
}

/// modified by ZY0222 2020-04-16
/// w ##class(web.DHCEQ.EM.BUSIFBList).GetListNum(1,2)
ClassMethod GetListNum(SourceType, SourceID)
{
	new count,firstID,objInfo
	s count=0
	s firstID=""
	i (SourceType'="")&&(SourceID'="")
	{
		i $Data(^DHCEQIFBList(0,"Source",SourceType,SourceID))
		{
			s rowid=0
			For  Set rowid=$Order(^DHCEQIFBList(0,"Source",SourceType,SourceID,rowid))  Quit:rowid=""  Do
			.s count=count+1
			.i count=1 s firstID=rowid
		}
	}
	s objInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	d objInfo.%Set("count",count)
	d objInfo.%Set("firstID",firstID)
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,objInfo)
}

}
