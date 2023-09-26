/// 名称: web.DHCEQ.EM.BUSDisuseRequest
/// 描述: 设备批量报废
/// 编写者：KDF
/// 编写日期: 2019-01-10
/// 产品组：设备管理
Class web.DHCEQ.EM.BUSDisuseRequest Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query GetDisuseType(Desc As %String = "") As %SQLQuery(ROWSPEC = "TRowID:%String,TDesc:%String,TCode:%String")
{
SELECT 
       DR_RowID,
       DR_Desc,
	   DR_Code
FROM sqluser.DHC_EQCDisuseType
where DR_InvalidFlag = 'N' and DR_Desc like nvl(:para,'')||'%'
}

/// Add By KDF 2018-12-29
/// 描述: 多批报废明细query
/// 入参:报废单ID
/// 访问表：DHC_EQDisuseList 
/// modified by wy 2020-1-18 QW20200218 BUG:QW0040 
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSDisuseRequest","DisuseList",2)
Query DisuseList(RowID As %String = "", Job As %String = "") As %Query(ROWSPEC = "DLTRowID:%String,DLRowID:%String,DLSourceType:%String,DLSourceID:%String,DLSource:%String,DLModel:%String,DLManuFactory:%String,DLUnit:%String,DLProvider:%String,DLLimitYears:%String,DLInDate:%String,DLQty:%String,DLTotalFee:%String,DLUseState:%String,DLDisuseReason:%String,DLDisuseDate:%String,DLRemark:%String,DLHold1:%String,DLHold2:%String,DLHold3:%String,DLHold4:%String,DLHold5:%String,DRJob:%String,DLEquipIDs:%String,DLNo:%String,DLFlag:%String,DLNetFee:%String,DLDepreTotalFee:%String")
{
}

ClassMethod DisuseListExecute(ByRef qHandle As %Binary, RowID As %String = "", Job As %String = "") As %Status
{
	new repid, index,DLRowID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1	
    //modified by wy 2020-1-18 QW20200218 BUG:QW0040
	i Job="" s Job=$J
	if (RowID="")
	{
		d ResetVariablesGetDisuseList
		s TJob=Job
		d OutputRowGetDisuseList
	}
	else
	{
		s DLRowID=0
		f  s DLRowID=$o(^DHCEQDisuseList(0,"Request",RowID,DLRowID))  quit:DLRowID=""  d
		.d ResetVariablesGetDisuseList
		.s TSourceType=$p($g(^DHCEQDisuseList(DLRowID)),"^",2)
		.s TSourceTypeDR=TSourceType
		.s TSourceID=$p($g(^DHCEQDisuseList(DLRowID)),"^",3)
		.i TSourceType=0  d
		..s TSource=$p($g(^DHCEQEquip(TSourceID)),"^",1)
		..s TManuFactory=$p($g(^DHCEQEquip(TSourceID)),"^",26)
		..s TModel=$p($g(^DHCEQEquip(TSourceID)),"^",3)
		..s TLimitYears=$p($g(^DHCEQEquip(TSourceID)),"^",31)
		..s TUnit=$p($g(^DHCEQEquip(TSourceID)),"^",5)
		..s TProvider=$p($g(^DHCEQEquip(TSourceID)),"^",25)
		..s TInDate = $p($g(^DHCEQEquip(TSourceID)),"^",45)
		..s TNo=$p($g(^DHCEQEquip(TSourceID)),"^",71)			//Add By DJ 2016-04-25
		..s TFlag="Y"
		..// Mozy0249	1190898		20200227
		..s TNetFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(TSourceID)),"^",28),"")
		..s TDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(TSourceID)),"^",35),"")
		.e  d
		..s TSource=$p($g(^DHCEQInStockList(TSourceID)),"^",5)
		..s TManuFactory=$p($g(^DHCEQInStockList(TSourceID)),"^",6)
		..s TModel=$p($g(^DHCEQInStockList(TSourceID)),"^",9)
		..s TLimitYears=$p($g(^DHCEQInStockList(TSourceID)),"^",15)
		..s TUnit=$p($g(^DHCEQInStockList(TSourceID)),"^",10)
		..s TInStockDR=$p($g(^DHCEQInStockList(TSourceID)),"^",1)
		..s TProvider=$p($g(^DHCEQInStock(TInStockDR)),"^",17)
		..s TInDate = $p($g(^DHCEQInStock(TInStockDR)),"^",13)
		..s TNo=$p($g(^DHCEQInStock(TInStockDR)),"^",14)			//Add By DJ 2016-04-25
		..s TFlag="N"
		.i TManuFactory'="" s TManuFactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactory) //CZF0093
		.i TModel'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModel)),"^",2)
		.i TProvider'=""  s TProvider = ##class(web.DHCEQCommon).GetTrakNameByID("prov",TProvider)
		.i TUnit'="" s TUnit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnit)
		.i TInDate'="" s TInDate=##class(web.DHCEQCommon).TransValueToPage(TInDate,"date")
		.s TQtyNum=$p($g(^DHCEQDisuseList(DLRowID)),"^",4)
		.s TUseState=$p($g(^DHCEQDisuseList(DLRowID)),"^",5)
		.s TDisuseReason=$p($g(^DHCEQDisuseList(DLRowID)),"^",6)
		.s TDisuseDate=$p($g(^DHCEQDisuseList(DLRowID)),"^",7)
		.s TRemark=$p($g(^DHCEQDisuseList(DLRowID)),"^",8)
		.s THold1=$p($g(^DHCEQDisuseList(DLRowID)),"^",9)
		.s THold2=$p($g(^DHCEQDisuseList(DLRowID)),"^",10)
		.s THold3=$p($g(^DHCEQDisuseList(DLRowID)),"^",11)
		.s THold4=$p($g(^DHCEQDisuseList(DLRowID)),"^",12)
		.s THold5=$p($g(^DHCEQDisuseList(DLRowID)),"^",13)
		.s TEquipIDs=$g(^DHCEQDisuseList(DLRowID,"EX"))
		.s TTotalFee=TQtyNum*THold1
		.s TJob=Job
		.;Add BY QW20200326 BUG:QW0051 begin 取累计折旧及净值
		.s EQID=$p(TEquipIDs,",",1)
		.i EQID'="" d
		..s TNetFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(EQID)),"^",28),"")
		..s TDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(EQID)),"^",35),"")
		.;Add BY QW20200326 BUG:QW0051 end
		.d OutputRowGetDisuseList
	}	
    //modified by wy 2020-1-18 QW20200218 BUG:QW0040
	Quit $$$OK
	
OutputRowGetDisuseList
	i THold1'="" s THold1=##Class(web.DHCEQCommon).FormatNumber(THold1,"")
	s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"")
	
	s Data=$lb(RowID,DLRowID,TSourceType,TSourceID,TSource,TModel,TManuFactory,TUnit,TProvider,TLimitYears,TInDate,TQtyNum,TTotalFee,TUseState,TDisuseReason,TDisuseDate,TRemark,THold1,THold2,THold3,THold4,THold5,TJob,TEquipIDs,TNo,TFlag,TNetFee,TDepreTotalFee) //modified by wy 2020-1-18 QW20200218 BUG:QW0040
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetDisuseList
	s (TSourceType,TSourceID,TSource,TModel,TManuFactory,TUnit,TProvider,TLimitYears,TInDate,TQtyNum,TTotalFee,TUseState,TDisuseReason,TDisuseDate,TRemark,THold1,THold2,THold3,THold4,THold5,TEquipIDs,TNo,TNetFee,TDepreTotalFee)="" //modified by wy 2020-1-18 QW20200218 BUG:QW0040
	quit
}

ClassMethod DisuseListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DisuseListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod DisuseListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DisuseListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// ----------------------------------
/// 创建：kdf 2018-12-30  
/// 描述：保存报废申请单及其明细
/// 访问表:DHC_EQDisuseRequest,DHC_EQDisuseList
/// 参数：	ReqVal申请单信息
/// 		ListVal明细信息
/// 		DelListIDs:删除的报废明细ID串
/// 		IsDel:0正常保存,1删除操作
/// 返回值：
/// 	json对象 {"SQLCODE":0,"Data":RowID}
/// 	当SQLCODE为0，表示成功，Data返回主表ID
/// 	当SQLCODE为其他，表示失败
/// w ##Class(web.DHCEQ.EM.BUSDisuseRequest).SaveData("{""DRRequestNo"":"""",""DRRequestLocDR_CTLOCDesc"":""医疗设备科"",""DRUseLocDR_CTLOCDesc"":""医疗设备科"",""DRRequestDate"":""2020-01-21"",""DRDisuseTypeDR_DRDesc"":""到期报废"",""DREquipTypeDR_ETDesc"":""专用设备"",""DRKindFlag"":""2"",""DRStatus"":"""",""DRRowID"":"""",""Flag"":"""",""AllListInfo"":"""",""DRApproveSetDR"":"""",""DRNextRoleDR"":"""",""DRNextFlowStep"":"""",""NextFlowStep"":"""",""ApproveSetDR"":"""",""NextRoleDR"":"""",""CancelFlag"":"""",""CancelToFlowDR"":"""",""ApproveRoleDR"":"""",""ApproveStatus"":"""",""BeginInsertRow"":"""",""ColSpanNum"":"""",""CurRole"":"""",""DetailAudit"":"""",""DRDisuseTypeDR"":""1"",""EquipCatDR"":"""",""DRGroupDR"":"""",""DREquipDR"":"""",""DREquipTypeDR"":""3"",""DREquipType"":""房屋及构筑物"",""ExcludeIDs"":"""",""GetApproveByResource"":"""",""GetApproveFlow"":"""",""GetCancelSubmit"":"""",""DRInStockListDR"":"""",""DRUseLocDR"":""327"",""ManuFactoryDR"":"""",""ModelDR"":"""",""ProviderDR"":"""",""DRRequestLocDR"":""327"",""StopFlag"":"""",""Type"":"""",""DRJob"":""5328"",""TotalFlag"":""2"",""QXType"":""0"",""ReadOnly"":"""",""RoleStep"":""0"",""DRApproveStatu"":"""",""SplitNumCode"":""$CHAR(4)"",""SplitRowCode"":""$CHAR(3)"",""HospitalDesc"":""东华标准版数字化医院[总院]"",""PrintFlag"":""1"",""PreviewRptFlag"":""1"",""ApproveTypeCode"":""5"",""DRApproveRoleDR"":"""",""WaitAD"":""false"",""DRHold1"":"""",""DRHold2"":"""",""DRHold3"":"""",""DRHold4"":"""",""DRHold5"":"""",""DRChangeReason"":"""",""DRTechnicEvaluate"":"""",""DRCheckResult"":"""",""DRRejectReason"":"""",""DRRemark"":"""",""DRUseState"":""""}","{""DLTRowID"":"""",""DLRowID"":"""",""DLSourceType"":1,""DLSourceID"":""10"",""DLSource"":""层流床"",""DLModel"":"""",""DLManuFactory"":""比利时爱力司医疗器械公司"",""DLProvider"":""卫永公司"",""DLLimitYears"":"""",""DLInDate"":""2020-01-15"",""DLQty"":""2"",""DLTotalFee"":40000,""DLUseState"":"""",""DLDisuseReason"":"""",""DLDisuseDate"":"""",""DLRemark"":"""",""DLHold1"":""20000.00"",""DLHold2"":"""",""DLHold3"":"""",""DLHold4"":"""",""DLHold5"":"""",""DRJob"":""5328"",""DLEquipIDs"":"""",""DLNo"":""RK2020010009"",""DLFlag"":""N"",""DLStock"":""医疗设备科"",""DLIndex"":0}",0)
/// Modified By QW20200119 BUGQW0039: 增加输入TranFlag:防止事务嵌套,User:session值
ClassMethod SaveData(data, dataList, DelIs, TranFlag As %Library.String = "Y", User As %Library.String = "")
{
	s $ZT="ERRORReturn"
	new PLIST,RowID // Modified By QW20200119 BUG:QW0039 初始化变量
	k PLIST,RowID
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	; Modified By QW20200119 BUG:QW0039 增加输入User:session值
	s Date=+$H
	s Time=$p($H,",",2)
	
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
	i TranFlag="Y" TSTART // Modified By QW20200119 BUG:QW0039 增加输入TranFlag:防止事务嵌套
	if +DelIs=1
	{
		s RowID=data
			
		&SQL(Update SQLUSER.DHC_EQDisuseRequest set DR_InvalidFlag='Y',DR_CancelUser=:User,DR_CancelDate=:Date,DR_CancelTime=:Time where DR_RowID=:RowID)
		
        //modified by ZY 20220926 2757106 删除明细占用节点记录
        i SQLCODE
        {
            i TranFlag="Y" TROLLBACK 
            q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
        }
        s SQLCODE=##Class(web.DHCEQ.EM.BUSEquip).TieUpEquipByBuss("","34",RowID,1)
        i SQLCODE
        {
            TROLLBACK
            Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"删除明细占用节点记录")
        }
        //end by ZY 20220926 2757106 删除明细占用节点记录
        s RowID=""
	}
	else
	{
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
	    s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQDisuseRequest",JsonData,.PLIST)
		s RowID = JsonData.DRRowID
		if (JsonData.%IsDefined("BussID")=1) s RowID=JsonData.BussID // Modified By QW20200119 BUG:QW0039 判断是否存在BussID 通用界面传来的主单据ID
		s Job = JsonData.DRJob
		// Modified By QW20200119 begin BUG:QW0039 BUG:QW0040
		s UpdateFlag=0
		if RowID=""
		{
			s PLIST(11) = "0"	;DR_Status
			s PLIST(54) = "N"    ;DR_InvalidFlag
			s PLIST(12) = User
	 		s PLIST(13) = Date
			s PLIST(14) = Time		
	 		s PLIST(34)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQDisuseRequest",PLIST(13),"",JsonData.DREquipTypeDR)
			
	 		&SQL(insert into sqluser.DHC_EQDisuseRequest values :PLIST())
		}
		else
		{
			s UpdateFlag=1
			s PLIST(15) = User
	 		s PLIST(16) = Date
	 		s PLIST(17) = Time

	 		&SQL(Update SQLUSER.DHC_EQDisuseRequest Values :PLIST() where DR_RowID = :RowID)
		}
		s RowID=$G(%ROWID)
		// Modified By QW20200119 end BUG:QW0039 BUG:QW0040
		i SQLCODE
 		{
			i TranFlag="Y" TROLLBACK // Modified By QW20200119 BUG:QW0039 增加输入TranFlag:防止事务嵌套
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
 		} 	
		// Modified By QW20200119 begin BUG:QW0040
		i TranFlag="Y" 
		{
			// MZY0144	3077652		2022-11-24	保存DHC_EQDisuseList 仅当多批次信息时保存此信息
			if JsonData.DRKindFlag="2"
			{
				s SQLCODE=##Class(web.DHCEQ.EM.BUSDisuseRequest).JudgeDLQuantityNum(RowID,Job,dataList) 
				i SQLCODE
				{
					TROLLBACK 
					q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
				}
				s SQLCODE=##Class(web.DHCEQ.EM.BUSDisuseRequest).SaveDisuseList(RowID,Job,dataList)
				i SQLCODE
				{
					TROLLBACK
					q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
				}
			}
			if JsonData.DRKindFlag="1"
			{
				i UpdateFlag=0 s ^DHCEQDisuseRequest(RowID,"EX")=$g(^TEMPEQ("MXList","EX",Job,"1"))		//Add by DJ 2016-04-25
				if (UpdateFlag=1)&&($Data(^TEMPEQ("MXList",Job,RowID)))
				{
					s ^DHCEQDisuseRequest(RowID,"EX")=$g(^TEMPEQ("MXList",Job,RowID))
					k ^TEMPEQ("MXList","EX",Job,RowID)
				}
                ///modified by ZY 20220926 2757106
                s ListEquip=$g(^DHCEQDisuseRequest(RowID,"EX"))
                s SQLCODE=##Class(web.DHCEQ.EM.BUSEquip).TieUpEquipByBuss(ListEquip,"34",RowID,0)
                i SQLCODE
                {
                    TROLLBACK
                    q SQLCODE_"^记录业务占用信息失败!"
                }
            }
            else
            {
                ///modified by ZY 20220926 2757106
                s ListEquip=$g(^DHCEQDisuseRequest(RowID,"EX"))
                s SQLCODE=##Class(web.DHCEQ.EM.BUSEquip).TieUpEquipByBuss(ListEquip,"34",RowID,1)
                i SQLCODE
                {
                    TROLLBACK
                    q SQLCODE_"^删除业务占用信息失败!"
                }
				k ^DHCEQDisuseRequest(RowID,"EX")
			}
		}
		// Modified By QW20200119 end BUG:QW0040
	}
	i TranFlag="Y" TCOMMIT // Modified By QW20200119 BUG:QW0039 增加输入TranFlag:防止事务嵌套
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID) //modified by wy 2020-01-21 QW20200218 BUG:QW0040
	
ERRORReturn
	i TranFlag="Y" TROLLBACK
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-2201",ErrorMsg)
}

/// 创建:KDF 2018-12-30 
/// 描述:保存报废单明细
/// 入参： 
/// 	DRRowID：报废申请单ID
/// 	DataList：明细信息 
/// 	Job任务Job
/// 访问表:DHC_EQDisuseList
/// 返回值：Flag 0成功 其他失败
///  modified：wy 2020-01-16  QW20200218 BUG:QW0040
/// modified by kdf 2019-05-28 需求号：867243
ClassMethod SaveDisuseList(DRRowID, Job, DataList)
{
	new (DRRowID, Job, DataList)
    ///  modified：wy 2020-01-16 begin QW20200218 BUG:QW0040
	i DRRowID="" q -1
	i DataList="" q 0
	s DLRowIDs=""
	s Flag=0
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")  // 分割标志替换
	s Length=$l(DataList,SplitRowCode)
	for k=1:1:Length
	{
		q:Flag'=0
		s valList=$p(DataList,SplitRowCode,k)  
		q:valList=""
		k PLIST,DLRowID
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valList)
		s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQDisuseList",JsonData,.PLIST)
		s PLIST(2)=DRRowID 
		s PLIST(8)=+$H
		s DLRowID=JsonData.DLRowID
		if (DLRowID="")
		{
			&SQL(Insert Into SQLUSER.DHC_EQDisuseList Values :PLIST())
			s DLRowID=$G(%ROWID)
			//Add by QW20200303 BUG:QW0042 begin
			s index=JsonData.DLIndex //index处理
			s ^DHCEQDisuseList(DLRowID,"EX")=^TEMPEQ("MXList","EX",Job,index)
	 		k ^TEMPEQ("MXList","EX",Job,index)
	 		//Add by QW20200303 BUG:QW0042 End

		}
		else
		{	
			&SQL(update sqluser.DHC_EQDisuseList values :PLIST() where DL_RowID=:DLRowID)	
		}	 		
		if DLRowIDs'="" s DLRowIDs=DLRowIDs_","
		s DLRowIDs=DLRowIDs_DLRowID
		i SQLCODE s Flag=index_"^更新明细记录失败!"
        ///modified by ZY 20220926 2757106
        q:Flag'=0
        s ListEquip=$g(^DHCEQDisuseList(DLRowID,"EX"))
        s SQLCODE=##Class(web.DHCEQ.EM.BUSEquip).TieUpEquipByBuss(ListEquip,"34",DRRowID,0)
        i SQLCODE s Flag=index_"^记录业务占用信息失败!"
	}
    s DLRowID=0
    f  s DLRowID=$o(^DHCEQDisuseList(0,"Request",DRRowID,DLRowID)) quit:(DLRowID="")||(SQLCODE'=0)  d
    .i (","_DLRowIDs_",")'[(","_DLRowID_",")  d
    ..&SQL(delete from  sqluser.DHC_EQDisuseList where DL_RowID=:DLRowID)
    ..q:SQLCODE'=0
    ..s ListEquip=$g(^DHCEQDisuseList(DLRowID,"EX"))
    ..s SQLCODE=##Class(web.DHCEQ.EM.BUSEquip).TieUpEquipByBuss(ListEquip,"34",DRRowID,1)
    
    i SQLCODE s Flag=index_"^删除未传入的转移单明细记录失败!"
    ///end by ZY 20220926 2757106
	q Flag
}

// ----------------------------------

/// 返回值：SQLCODE^ErrDesc
/// 
/// ----------------------------------
/// 创建:KDF 2018-12-30 
/// 描述:删除报废单明细
/// 入参： 
/// 	DelListIDs：明细信息
/// 返回值：SQLCODE^ErrDesc
/// 访问表:DHC_EQDisuseRequest,DHC_EQDisuseList
/// w ##Class(web.DHCEQ.EM.BUSDisuseRequest).DeleteDisuseList(21,"")
/// modified by kdf 2019-05-28 需求号：867243
ClassMethod DeleteDisuseList(DRRowID, DelIs)
{
	new Length,DLRowID,i,DLLRowID,DelListIDs

	i DRRowID=""  q 0
	s DelListIDs=""
	
	s DLLRowID=0
	f  s DLLRowID=$o(^DHCEQDisuseList(0,"Request",DRRowID,DLLRowID))  quit:(DLLRowID="")  d
	.i DelListIDs=""  d
	..s DelListIDs=DLLRowID
	.e  d
	..s DelListIDs=DelListIDs_","_DLLRowID
	s Length=$l(DelListIDs,",")
	i Length=0 q 0
	for i=1:1:Length  q:SQLCODE'=0  d
	.s DLRowID=$p(DelListIDs,",",i)
	.if (DLRowID>0)  d
	..&SQL(delete from  sqluser.DHC_EQDisuseList where DL_RowID=:DLRowID)
	..k ^DHCEQDisuseList(DLRowID,"EX")
	
	q SQLCODE
}

/// ----------------------------------
/// 创建:KDF 2019-01-17 
/// 描述:filldata给界面赋值
/// w ##Class(web.DHCEQ.EM.BUSDisuseRequest).GetOneDisuseRequest(16,"","","")
ClassMethod GetOneDisuseRequest(RowID As %Library.String = "", ApproveRoleDR As %Library.String, action As %Library.String = "", step As %Library.String = "")
{
	s $ZT="ERRORGetOneDisuseRequest"
	s ObjReturn=##Class(User.DHCEQDisuseRequest).%OpenId(RowID)
	s ReturnInfo=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjReturn)
	
	d ReturnInfo.%Set("DRRequestLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjReturn.DRRequestLocDR))
	d ReturnInfo.%Set("DRUseLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjReturn.DRUseLocDR))
	
	d ReturnInfo.%Set("DRDisuseTypeDR_DRDesc",ObjReturn.DRDisuseTypeDR.DRDesc)
		
	d ReturnInfo.%Set("DREquipTypeDR_ETDesc",ObjReturn.DREquipTypeDR.ETDesc)
	
	//Add By By QW20200119 BUG:QW0039 begin
	s DRKindFlagDesc=$case(ObjReturn.DRKindFlag,"0":"单台报废","1":"批量报废","2":"多批报废")
	d ReturnInfo.%Set("DRKindFlagDesc",DRKindFlagDesc)
	i ObjReturn.DREquipDR'="" d
	.s DRInStockNo=ObjReturn.DREquipDR.EQInStockListDR.ISLInStockDR.ISInStockNo
	e  d
	.s DRInStockNo=ObjReturn.DRInStockListDR.ISLInStockDR.ISInStockNo
	d ReturnInfo.%Set("DRInStockNo_EX",DRInStockNo)
	//设备信息
	i ObjReturn.DRKindFlag="1"  d
	.s RowIDs=$g(^DHCEQDisuseRequest(RowID,"EX"))
	.s DREquip=ObjReturn.DRInStockListDR.ISLEquipName     //设备名	
	.s DRModel=ObjReturn.DRInStockListDR.ISLModelDR.MDesc     //机型
	.s DREquipCat=ObjReturn.DRInStockListDR.ISLEquipCatDR.ECDesc   //设备分类 
	.s DRQManufacturer=ObjReturn.DRInStockListDR.ISLManuFactoryDR.VName		//modified by CZF0103 20200408
	.s DRProvider=ObjReturn.DRInStockListDR.ISLInStockDR.ISProviderDR.VName             //供应商
	.s DRInDate = ##class(web.DHCEQCommon).TransValueToPage(ObjReturn.DRInStockListDR.ISLInStockDR.ISBillAuditDate,"date")
	.s DRLimitYearsNum = ObjReturn.DRInStockListDR.ISLLimitYearsNum  //使用年限 Modify by zx 2021-09-03 
	else  if ObjReturn.DRKindFlag="0"  d
	.s RowIDs=$p(^DHCEQDisuseRequest(RowID),"^",1)
	.s DREquip=ObjReturn.DREquipDR.EQName           //设备
	.s DRModel=ObjReturn.DREquipDR.EQModelDR.MDesc          //机型
	.s DREquipCat=ObjReturn.DREquipDR.EQEquiCatDR.ECDesc       //设备分类
	.s DRQManufacturer=ObjReturn.DREquipDR.EQManuFactoryDR.VName		//modified by CZF0103 20200408
	.s DRProvider=##Class(web.DHCEQCommon).GetTrakNameByID("prov", ObjReturn.DREquipDR.EQProviderDR)       //供应商
	.s DRInDate = ##class(web.DHCEQCommon).TransValueToPage(ObjReturn.DREquipDR.EQTransAssetDate,"date") //转资日期
	.s DRLimitYearsNum = ObjReturn.DREquipDR.EQLimitYearsNum //使用年限 Modify by zx 2021-09-03 
	else  d
	.s (RowIDs,DREquip,DRModel,DREquipCat,DRQManufacturer,DRProvider,DRInDate,DRLimitYearsNum)="" //Modified by QW20210913 BUG:QW0147
	s EQNoIDS=##class(web.DHCEQ.EM.BUSDisuseRequest).GetEquipNoAndLeaveFactoryNo("","",RowIDs) //Modified by QW20200303 BUG:QW0042
	s DRAmount=$l(RowIDs,",")
	s DREquipNos=$p(EQNoIDS,"^",1)
	s DRLeaveFactoryNo=$p(EQNoIDS,"^",2)
	s DROriginalFee=$p(EQNoIDS,"^",3)
	s DRFileNo=$p(EQNoIDS,"^",4)
	d ReturnInfo.%Set("DREquip_EX",DREquip)
	d ReturnInfo.%Set("DRModel_EX",DRModel)
	d ReturnInfo.%Set("DREquipCat_EX",DREquipCat)
	d ReturnInfo.%Set("DRQManufacturer_EX",DRQManufacturer)
	d ReturnInfo.%Set("DRProvider_EX",DRProvider)
	d ReturnInfo.%Set("DRInDate_EX",DRInDate)
	d ReturnInfo.%Set("DRLeaveFactoryNo_EX",DRLeaveFactoryNo)
	d ReturnInfo.%Set("DREquipNos_EX",DREquipNos)
	d ReturnInfo.%Set("DRAmount_EX",DRAmount)
	d ReturnInfo.%Set("DROriginalFee_EX",DROriginalFee)
	d ReturnInfo.%Set("DRFileNo_EX",DRFileNo)
	d ReturnInfo.%Set("DRLimitYearsNum_EX",DRLimitYearsNum) //使用年限 Modify by zx 2021-09-03 
	s RoleStep=##class(web.DHCEQCApproveSet).GetStepByRole(##class(web.DHCEQApproveList).GetApproveSet("5",RowID),ApproveRoleDR,action)
	d ReturnInfo.%Set("RoleStep",RoleStep)
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("5")
	Set Opinion=##Class(web.DHCEQApproveList).GetApproveListOpinion(ApproveType, RowID)
	d ReturnInfo.%Set("OpinionRecords",Opinion)
	d ReturnInfo.%Set("Status",ReturnInfo.DRStatus)
	d ReturnInfo.%Set("DRSubmitUserDR_UDesc",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjReturn.DRSubmitUserDR))	// MZY0087	2021-08-13
	//modified by ZY20230215 bug:3253924
	d ReturnInfo.%Set("DRAddUserDR_UDesc",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjReturn.DRAddUserDR))	//
	d ReturnInfo.%Set("DRAuditUserDR_UDesc",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjReturn.DRAuditUserDR))	//
	//Add By By QW20200119 BUG:QW0039 end 来源

	s AppInfo=##class(web.DHCEQApprove).GetApproveInfoBySourceID("5",RowID,ApproveRoleDR)
	d ReturnInfo.%Set("AIRowID",$p(AppInfo,"^",1))
	d ReturnInfo.%Set("ApproveSetDR",$p(AppInfo,"^",2))
	d ReturnInfo.%Set("NextRoleDR",$p(AppInfo,"^",3))
	d ReturnInfo.%Set("NextFlowStep",$p(AppInfo,"^",4))
	d ReturnInfo.%Set("ApproveStatus",$p(AppInfo,"^",5))
	d ReturnInfo.%Set("ApproveRoleDR",$p(AppInfo,"^",6))
	d ReturnInfo.%Set("CancelFlag",$p(AppInfo,"^",7))
	d ReturnInfo.%Set("CancelToFlowDR",$p(AppInfo,"^",8))
	d ReturnInfo.%Set("ApproveRole",$p(AppInfo,"^",9))
	d ReturnInfo.%Set("NextRole",$p(AppInfo,"^",10))
	d ReturnInfo.%Set("DRHold5",##class(web.DHCEQCommon).TransValueToPage(ObjReturn.DRHold5,"date"))
	s CanChangeValue=""
	i action'="" s CanChangeValue=##Class(web.DHCEQCApproveFlow).CheckApproveFlagAbove("5",action,RowID,2)
	s MultipleRoleFlag=0
	i ($p(CanChangeValue,"^",3)'="")&&((","_$p(CanChangeValue,"^",3))[(","_step_",")) d
	.s MultipleRoleFlag=1
	d ReturnInfo.%Set("MultipleRoleFlag",MultipleRoleFlag)
	
	//add by ZY20230228 bug:3295367
	Set result=##Class(web.DHCEQApproveList).GetApproveInfoByActionCode("5", RowID,"0")
	s ApproveOpinon1=$p(result,"^",3)
	i ApproveOpinon1="" s ApproveOpinon1="同意(默认)"
	d ReturnInfo.%Set("ApproveOpinon1",ApproveOpinon1)
	s ApproveUser1=$p(result,"^",6)
	s ApproveUser1Img=""
	i ApproveUser1'="" d
	.s DeptExType = $p($g(^DHCEQCCode("DHCEQCUser",ApproveUser1)),"^",18)
	.q:(DeptExType'=1)		//"1":"DHC-HIS"
	.s UserID = $p($g(^DHCEQCCode("DHCEQCUser",ApproveUser1)),"^",19)
	.s ApproveUser1Img=##Class(web.DHCEQ.Interface.Inner.DHCEQCA).GetCAImage(UserID)
	.i ApproveUser1Img'="" s ApproveUser1Img="data:image/png;base64,"_ApproveUser1Img
	d ReturnInfo.%Set("ApproveUser1",ApproveUser1Img)
	
	Set result=##Class(web.DHCEQApproveList).GetApproveInfoByActionCode("5", RowID,"Disuse_Tech",1)	
	s ApproveOpinon2=$p(result,"^",3)
	i ApproveOpinon2="" s ApproveOpinon2="同意(默认)"
	d ReturnInfo.%Set("ApproveOpinon2",ApproveOpinon2)
	s ApproveUser2=$p(result,"^",6)
	s ApproveUser2Img=""
	i ApproveUser2'="" d
	.s DeptExType = $p($g(^DHCEQCCode("DHCEQCUser",ApproveUser2)),"^",18)
	.q:(DeptExType'=1)		//"1":"DHC-HIS"
	.s UserID = $p($g(^DHCEQCCode("DHCEQCUser",ApproveUser2)),"^",19)
	.s ApproveUser2Img=##Class(web.DHCEQ.Interface.Inner.DHCEQCA).GetCAImage(UserID)
	.i ApproveUser2Img'="" s ApproveUser2Img="data:image/png;base64,"_ApproveUser2Img
	d ReturnInfo.%Set("ApproveUser2",ApproveUser2Img)
	
	Set result=##Class(web.DHCEQApproveList).GetApproveInfoByActionCode("5", RowID,"Disuse_Manage",3)	
	s ApproveOpinon3=$p(result,"^",3)
	i ApproveOpinon3="" s ApproveOpinon3="同意(默认)"
	d ReturnInfo.%Set("ApproveOpinon3",ApproveOpinon3)
	s ApproveUser3=$p(result,"^",6)
	s ApproveUser3Img=""
	i ApproveUser3'="" d
	.s DeptExType = $p($g(^DHCEQCCode("DHCEQCUser",ApproveUser3)),"^",18)
	.q:(DeptExType'=1)		//"1":"DHC-HIS"
	.s UserID = $p($g(^DHCEQCCode("DHCEQCUser",ApproveUser3)),"^",19)
	.s ApproveUser3Img=##Class(web.DHCEQ.Interface.Inner.DHCEQCA).GetCAImage(UserID)
	.i ApproveUser3Img'="" s ApproveUser3Img="data:image/png;base64,"_ApproveUser3Img
	d ReturnInfo.%Set("ApproveUser3",ApproveUser3Img)
	
	Set result=##Class(web.DHCEQApproveList).GetApproveInfoByActionCode("5", RowID,"Disuse_Tech",3)	
	s ApproveOpinon4=$p(result,"^",3)
	i ApproveOpinon4="" s ApproveOpinon4="同意(默认)"
	d ReturnInfo.%Set("ApproveOpinon4",ApproveOpinon4)
	s ApproveUser4=$p(result,"^",6)
	s ApproveUser4Img=""
	i ApproveUser4'="" d
	.s DeptExType = $p($g(^DHCEQCCode("DHCEQCUser",ApproveUser4)),"^",18)
	.q:(DeptExType'=1)		//"1":"DHC-HIS"
	.s UserID = $p($g(^DHCEQCCode("DHCEQCUser",ApproveUser4)),"^",19)
	.s ApproveUser4Img=##Class(web.DHCEQ.Interface.Inner.DHCEQCA).GetCAImage(UserID)
	.i ApproveUser4Img'="" s ApproveUser4Img="data:image/png;base64,"_ApproveUser4Img
	d ReturnInfo.%Set("ApproveUser4",ApproveUser4Img)
	
	Set result=##Class(web.DHCEQApproveList).GetApproveInfoByActionCode("5", RowID,"Disuse_CaiwuAudit")	
	s ApproveOpinon5=$p(result,"^",3)
	i ApproveOpinon5="" s ApproveOpinon5="同意(默认)"
	d ReturnInfo.%Set("ApproveOpinon5",ApproveOpinon5)
	s ApproveUser5=$p(result,"^",6)
	s ApproveUser5Img=""
	i ApproveUser5'="" d
	.s DeptExType = $p($g(^DHCEQCCode("DHCEQCUser",ApproveUser5)),"^",18)
	.q:(DeptExType'=1)		//"1":"DHC-HIS"
	.s UserID = $p($g(^DHCEQCCode("DHCEQCUser",ApproveUser5)),"^",19)
	.s ApproveUser5Img=##Class(web.DHCEQ.Interface.Inner.DHCEQCA).GetCAImage(UserID)
	.i ApproveUser5Img'="" s ApproveUser5Img="data:image/png;base64,"_ApproveUser5Img
	d ReturnInfo.%Set("ApproveUser5",ApproveUser5Img)
		
	Set result=##Class(web.DHCEQApproveList).GetApproveInfoByActionCode("5", RowID,"Disuse_Audit")	
	s ApproveOpinon6=$p(result,"^",3)
	i ApproveOpinon6="" s ApproveOpinon6="同意(默认)"
	d ReturnInfo.%Set("ApproveOpinon6",ApproveOpinon6)
	s ApproveUser6=$p(result,"^",6)
	s ApproveUser6Img=""
	i ApproveUser6'="" d
	.s DeptExType = $p($g(^DHCEQCCode("DHCEQCUser",ApproveUser6)),"^",18)
	.q:(DeptExType'=1)		//"1":"DHC-HIS"
	.s UserID = $p($g(^DHCEQCCode("DHCEQCUser",ApproveUser6)),"^",19)
	.s ApproveUser6Img=##Class(web.DHCEQ.Interface.Inner.DHCEQCA).GetCAImage(UserID)
	.i ApproveUser6Img'="" s ApproveUser6Img="data:image/png;base64,"_ApproveUser6Img
	d ReturnInfo.%Set("ApproveUser6",ApproveUser6Img)
	
	
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,ReturnInfo)
ERRORGetOneDisuseRequest
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

/// ----------------------------------
/// 创建:JDL 2011-12-02  JDL0104
/// 描述:提交报废单
/// 入参： 
/// 	RowID：报废单RowID
/// 返回值：SQLCODE^ErrDesc
/// 访问表:DHC_EQDisuseRequest,DHC_EQDisuseList
/// w ##Class(web.DHCEQ.EM.BUSDisuseRequest).SubmitData(RowID)
ClassMethod SubmitData(RowID)
{
	s $ZT="ERRSubmitData"
	
	n User,Date,Time
	n PLIST,InvalidFlag,CheckFlag
	n ApproveType,MaxPrice
	n ApproveSet,ApproveFlow,AutoAuditFlag,LastFlag,NextStep,NextRole,AuditFlag
	n StoreLocDR,KindFlag
	//midified by zy 2015-7-1 ZY0134
	n UnusualStatus,UnusualRemark
	s UnusualStatus="1"
	s UnusualRemark="报废提交"
	
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	k PLIST
	s Date=+$H
	s Time=$p($H,",",2) 	
 	
 	i RowID'=""
 	{
	 	s InvalidFlag=$Piece($G(^DHCEQDisuseRequest(RowID)),"^",53)
	 	i InvalidFlag="Y" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-2201","无效单据不能操作!") 
 	}
 	else
 	{
	 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-2201","没有单据不能操作!") 
	}
	
	;Status该记录状态不符合,不能执行操作!
	if $p($g(^DHCEQDisuseRequest(RowID)),"^",10)'="0" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-2015","该记录状态不符合,不能执行操作!") 
    
    ;检查设备是否符合要求
    s CheckFlag=..CheckData(RowID)
    s MaxPrice=$p(CheckFlag,"^",2)
    s CheckFlag=$p(CheckFlag,"^",1)    
    if CheckFlag'=1 Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(CheckFlag,"单据设备不符合要求!") 
    
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("5")  ;ApproveType=5
	
	s PLIST(11) = 1	        ;Status
	s PLIST(18) = User	    ;SubmitUserDR
	s PLIST(19) = Date	    ;SubmitDate
	s PLIST(20) = Time		;SubmitTime 		
 	s EquipType=$P(^DHCEQDisuseRequest(RowID),"^",43) 	
 	s KindFlag=$P(^DHCEQDisuseRequest(RowID),"^",44)
 	
	s ReturnEquipType=##CLASS(web.DHCEQ.EM.BUSInStock).EquipTypeIsUniqueNew(RowID,EquipType,"DisUse")      ;add by kdf 2019-02-20 提交单据时修改类组一致性判断 begin
	i ReturnEquipType<0 Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(ReturnEquipType,"设备类组不一致！")  ;add by kdf 2019-02-20 修改类组一致性判断 end
	/*
 	if (KindFlag=2)
 	{
	 	s SQLCODE=..CheckRepeat(RowID)
	 	i SQLCODE'=0 Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson($p(SQLCODE,"^",1),$p(SQLCODE,"^",2))
	}
 	*/
 	; w ##Class(web.DHCEQCApproveSet).JudgeApproveSet(5,1,"","","","","")
 	; ApproveSet=11
 	s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, EquipType, "", "", MaxPrice,"")
 	i ApproveSet="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-4007","未获取到报废审批设置!")
 	
 	TSTART
 	s SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,RowID,"5",User)
 	i SQLCODE
 	{
 		TROLLBACK
 		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"清除原无效审批信息失败!")
 	}
 	
	s SQLCODE=..InsertDisuseRequestList(RowID)
 	if SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"生成报废明细信息失败!")
	}				
	;ApproveSet=11 ApproveType=5 RowID=17
	; w ##class(web.DHCEQCApproveSet).GetNextStep("11","5","17",0,"")
 	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, 0, "")
 	; ApproveFlow=N^1^2^^^^N^0^^^11^
 	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
 	s LastFlag=$P(ApproveFlow,"^",1)
 	s NextStep=$P(ApproveFlow,"^",2)
 	s NextRole=$P(ApproveFlow,"^",3)
 	
 	s AppInfoStatus="1"
	s AuditFlag=0	
		
	i AutoAuditFlag="Y"
 	{
 		i (NextStep="")||(LastFlag="Y")
 		{
	 		s PLIST(11)="2"
 			s SQLCODE=..LastAuditAction( RowID)
			if SQLCODE'=0
			{
 				TROLLBACK
 				Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"最后审核生成信息失败!")
			}
			;Modified by jdl 2011-3-10  jdl0073
			s AuditFlag=1
			//midified by zy 2015-7-1 ZY0132 
			s (UnusualStatus,UnusualRemark)=""
			//midified by zx 2016-03-16 ZX0035 
			s AppInfoStatus="2"
 		}
 	}
 	s PLIST(28)=ApproveSet
 	s PLIST(29)=NextRole
 	s PLIST(30)=NextStep
 	s PLIST(31)=""
 	s PLIST(32)=""
	&SQL(update sqluser.DHC_EQDisuseRequest values :PLIST() where DR_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"更新报废单信息失败!")
	}
	
 	//midified by zy 2015-7-1 ZY0134 
 	//修改设备显示状态信息
 	;s EquipIDs=##Class(web.DHCEQBatchDisuseRequest).GetDisuseEquipIDs(RowID)
 	;s SQLCODE=##Class(web.DHCEQChangeInfo).UpdateEquipUnusualStatus(EquipIDs,UnusualStatus,UnusualRemark) ;UnusualStatus=1 UnusualRemark=报废提交
 	s SQLCODE=##Class(web.DHCEQBatchDisuseRequest).UpdateEQUnusualStatus(RowID,UnusualStatus,UnusualRemark)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"更新设备异常状态信息失败!")
	}
	//************保存审批流信息
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,PLIST(29),PLIST(30),"","",AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	//*********工作台业务消息
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("34", RowID, User, ApproveFlow_"^"_ApproveSet, "N","",AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^创建业务消息失败!"
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"创建业务消息失败!")
	}

 	TCOMMIT
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
ERRSubmitData
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-2201",ErrorMsg) //返回错误消息
}

/// ----------------------------------
/// 描述：最终审核时需调用此方法,执行审核中需要处理的数据
/// 	在此处，需调用
/// w ##Class(web.DHCEQ.EM.BUSDisuseRequest).LastAuditAction(52)
/// ----------------------------------
/// Modified By QW20200119 BUG:QW0039 增加输入User:微信端session传入
ClassMethod LastAuditAction(RowID, User As %Library.String = "")
{
	n PLIST,Status,DRLRowID,EquipDR
	n Date,Time //Modified By QW20200119 BUG:QW0039 增加输入User:微信端session传入
	n EQName,EQNo,FromLoc,EQStoreLocDR,DisuseType,EQStatus
	if User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID")) //Modified By QW20200119 BUG:QW0039 增加输入User:微信端session传入
	k PLIST
	s Date=+$H
	s Time=$p($H,",",2)
	
	i RowID="" q "-2201^没有单据不能操作!"	
	;InvalidFlag
	i $Piece($G(^DHCEQDisuseRequest(RowID)),"^",53)="Y" q "-2201^无效单据不能操作!"	
	;Status该记录状态不符合,不能执行操作!
	if $p($g(^DHCEQDisuseRequest(RowID)),"^",10)="2" q "-2015^该记录状态不符合,不能执行操作!"   ;Status该记录状态不符合,不能执行操作!
	
 	s PLIST(11)="2"
	s PLIST(21)=User
	s PLIST(22)=Date
	s PLIST(23)=Time

 	&sql(update sqluser.DHC_EQDisuseRequest values :PLIST() where DR_RowID=:RowID)
	if SQLCODE'=0
	{
		q SQLCODE
	}
	
 	s DRLRowID=0
	f  s DRLRowID=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",RowID,DRLRowID)) q:(DRLRowID="")||(SQLCODE'=0)  d
	.s EquipDR=$p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",2)
	.
	.s EQName=$p($g(^DHCEQEquip(EquipDR)),"^",1)
	.s EQNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
	.;InvalidFlag
	.i $p($g(^DHCEQEquip(EquipDR)),"^",59)="Y"  s SQLCODE="-2201^"_EQName_"["_EQNo_"]设备已无效!"
	.q:SQLCODE'=0
	.;StockStatus
	.i ($p($g(^DHCEQEquip(EquipDR)),"^",60)'="1")  s SQLCODE="-2201^"_EQName_"["_EQNo_"]库房状态不符合条件!"
	.q:SQLCODE'=0
	.s EQStatus=$p($g(^DHCEQEquip(EquipDR)),"^",38)
	.i (EQStatus>2)  s SQLCODE="-2201^"_EQName_"["_EQNo_"]设备状态不符合条件!"
	.q:SQLCODE'=0
	.
	.s FromLoc=$p($g(^DHCEQDisuseRequest(RowID)),"^",34)
	.s EQStoreLocDR=$p($g(^DHCEQEquip(EquipDR)),"^",67)
	.;i FromLoc'=EQStoreLocDR  s SQLCODE="-2201^"_EQName_"["_EQNo_"]所在库房已经变动,不是申请时使用部门!" ;add by kdf 需要修复条件控制
	.q:SQLCODE'=0
	.
	.s LI(2)=EquipDR  //设备
	.s LI(4)=$p($g(^DHCEQEquip(EquipDR)),"^",19)   //原使用科室
	.s LI(5)=$p($g(^DHCEQEquip(EquipDR)),"^",17) //原管理科室
	.s LI(6)=$p($g(^DHCEQEquip(EquipDR)),"^",67)  //原库房
	.s LI(7)=$p($g(^DHCEQEquip(EquipDR)),"^",27)  //原值
	.s LI(8)=$p($g(^DHCEQEquip(EquipDR)),"^",28)  //原净值
	.&sql(update sqluser.DHC_EQEquip  set EQ_Status=3,EQ_DisuseDate=:Date  where EQ_RowID=:EquipDR) //修改设备库房状态
	.q:SQLCODE'=0
	.s LI(9)=$p($g(^DHCEQEquip(EquipDR)),"^",19)   //变动后使用科室
	.s LI(10)=$p($g(^DHCEQEquip(EquipDR)),"^",17) //变动后管理科室
	.s LI(11)=$p($g(^DHCEQEquip(EquipDR)),"^",67)  //变动后库房
	.s LI(12)=$p($g(^DHCEQEquip(EquipDR)),"^",27)  //变动后原值
	.s LI(13)=$p($g(^DHCEQEquip(EquipDR)),"^",28)  //变动后净值
	.s DisuseType=$p($g(^DHCEQDisuseRequest(RowID)),"^",6) //报废类型
	.i DisuseType'="" s LI(14)=$p($g(^DHCEQCCode("DHCEQCDisuseType",DisuseType)),"^",2)  //变动原因
	.s LI(15)=$p($g(^DHCEQDisuseRequest(RowID)),"^",7)  //变动描述
	.s LI(16)=Date	//变动日期
	.s LI(17)=Time	//变动时间
	.s LI(19)="C"	//生命周期类型
	.s LI(20)=34	//来源类型
	.s LI(21)=DRLRowID	//来源ID
	.s LI(27)=User	//更新人
	.s LI(28)=Date	//更新日期
	.s LI(29)=Time	//更新时间
	.&sql(Insert Into SQLUSER.DHC_EQLifeInfo Values :LI())
	.q:SQLCODE'=0
	.&sql(Update SQLUSER.DHC_EQDisuseRequestList set DRL_Hold1=:EQStatus where DRL_RowID=:DRLRowID)
	.q:SQLCODE'=0
	.//Function:Funds	2012-2-16 生成资金来源信息
	.;Modified by JDL 2012-1-4 JDL0108
	.s SQLCODE=##class(web.DHCEQInStockNew).CreateFundsInfo(6, DRLRowID)
	.q:SQLCODE'=0
	.//begin add  by jyp 2020-02-27  JYP0020  报废信息表添加可编辑字段
	.s ReduceInfo="2^"_EquipDR_"^"_$p($g(^DHCEQDisuseRequest(RowID)),"^",49)_"^"_$p($g(^DHCEQDisuseRequest(RowID)),"^",48)_"^"_$p($g(^DHCEQDisuseRequest(RowID)),"^",8)
	.s SQLCODE=##Class(web.DHCEQ.EM.BUSReduceInfo).SaveReduceInfo(ReduceInfo)
	.q:SQLCODE'=0
	.//end add  by jyp 2020-02-27  JYP0020  报废信息表添加可编辑字段
	.//Modify by zx BUG ZX0105 修改共享资源状态
	.s SQLCODE=##Class(web.DHCEQ.RM.BUSShareResource).ChangeShareResource(34,RowID,"2")
	.q:SQLCODE'=0
	.;Mozy0089	2012-10-17
	.Set SQLCODE=##Class(web.DHCEQBusinessCommon).GetBillInfoStr(6, DRLRowID)
		
    /// modified by ZY 20220926 2757106
    i SQLCODE q SQLCODE
    s SQLCODE=##Class(web.DHCEQ.EM.BUSEquip).TieUpEquipByBuss("","34",RowID,1)
    q SQLCODE
}

/// Modified By JDL 2011-12-05 JDL0104
/// 重写生成报废明细,并增加对多批次设备报废方式的处理
/// ----------------------------------
/// 创建：zy 2009-08-17  No ZY0009
/// 描述：根据参数rowids写入报废明细。
/// 访问表:DHC_EQDisuseRequestList : 2 DisuseRequestDR,3 EquipID ,13 DHC_EQDisuseList->RowID 
/// ----------------------------------
ClassMethod InsertDisuseRequestList(RowID)
{
	n User,Date,PLISTMX
	n KindFlag,SourceType,EquipIDs,EquipID,Len
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	k PLISTMX
	s PLISTMX(2)=RowID             ;DisuseRequestDR
	s KindFlag=$P(^DHCEQDisuseRequest(RowID),"^",44)
	
	s ListID=""
	if KindFlag=0  d
	.s EquipID=$P(^DHCEQDisuseRequest(RowID),"^",1)
	.d InsertList	
	else  if KindFlag=1  d
	.s EquipIDs=$g(^DHCEQDisuseRequest(RowID,"EX"))
	.s Len=$l(EquipIDs,",")
	.for i=1:1:Len  q:(SQLCODE'=0)  d
	..s EquipID=$p(EquipIDs,",",i)
	..d InsertList
	else  d
	.;多批 KindFlag=2
	.f  s ListID=$o(^DHCEQDisuseList(0,"Request",RowID,ListID))  quit:((ListID="")||(SQLCODE'=0))  d
	..i $p(^DHCEQDisuseList(ListID),"^",2)=0  d    ;来源为台账
	...s EquipID=$P(^DHCEQDisuseList(ListID),"^",3)
	...d InsertList
	..e  d
	...s EquipIDs=$g(^DHCEQDisuseList(ListID,"EX"))
	...s Len=$l(EquipIDs,",")
	...for i=1:1:Len  q:(SQLCODE'=0)  d
	....s EquipID=$p(EquipIDs,",",i)
	....d InsertList
	
	q SQLCODE

InsertList	
	s PLISTMX(3)=EquipID
	;s PLISTMX(12)=$p($g(^DHCEQEquip(EquipID)),"^",38)     ;Sataus
	s PLISTMX(13)=ListID
	&SQL(Insert Into SQLUser.DHC_EQDisuseRequestList values:PLISTMX())
	q
}

/// 描述:多批报废设备重复记录判断
ClassMethod CheckRepeat(RowID)
{
	s ListID=0
	s Find=0
	s CurRow=0
	k ^DHCEQTemp("DisuseCheckRepeat",$J)
	f  s ListID=$o(^DHCEQDisuseList(0,"Request",RowID,ListID))  quit:((ListID="")||(Find'=0))  d
	.s CurRow=CurRow+1
	.i $p(^DHCEQDisuseList(ListID),"^",2)=0  d
	..s EquipID=$P($G(^DHCEQDisuseList(ListID)),"^",3)
	..i $d(^DHCEQTemp("DisuseCheckRepeat",$J,EquipID))  d
	...s Find=1
	..e  d
	...s ^DHCEQTemp("DisuseCheckRepeat",$J,EquipID)=1
	.e  d
	..s EquipIDs=$g(^DHCEQDisuseList(ListID,"EX"))
	..s Len=$l(EquipIDs,",")
	..for i=1:1:Len  q:(Find'=0)  d
	...s EquipID=$p(EquipIDs,",",i)
	...q:EquipID=""
	...i $d(^DHCEQTemp("DisuseCheckRepeat",$J,EquipID))  d
	....s Find=1
	...e  d
	....s ^DHCEQTemp("DisuseCheckRepeat",$J,EquipID)=1
	k ^DHCEQTemp("DisuseCheckRepeat",$J)
	i Find=0 q Find
	q "-2201^(序号:"_CurRow_",ListRowID="_ListID_")设备数据重复"
}

/// ----------------------------------
/// 描述:检查报废单信息是否完整、正确
/// 入参： 
/// 	RowID：报废单RowID
/// 返回值：CheckFlag^MaxPrice^ErrDesc
/// w ##Class(web.DHCEQ.EM.BUSDisuseRequest).CheckData(RowID)
ClassMethod CheckData(RowID)
{
	n KindFlag,MaxPrice,ListID,EquipTypeDR,StoreLocDR
	n EquipIDs,EquipID,Len,CheckFlag,i
	
	s MaxPrice=0
	s CheckFlag=1
	s StoreLocDR=$P(^DHCEQDisuseRequest(RowID),"^",34)
	s EquipTypeDR=$P(^DHCEQDisuseRequest(RowID),"^",43)	
	s KindFlag=$P(^DHCEQDisuseRequest(RowID),"^",44)
	
	if KindFlag=0  d
	.s EquipID=$P(^DHCEQDisuseRequest(RowID),"^",1)
	.d CheckEquip	
	else  if KindFlag=1  d
	.s EquipIDs=$g(^DHCEQDisuseRequest(RowID,"EX"))
	.s Len=$l(EquipIDs,",")
	.for i=1:1:Len  q:(CheckFlag'=1)  d
	..s EquipID=$p(EquipIDs,",",i)
	..d CheckEquip
	else  d
	.;多批 KindFlag=2
	.s ListID=0
	.f  s ListID=$o(^DHCEQDisuseList(0,"Request",RowID,ListID))  quit:((ListID="")||(CheckFlag'=1))  d
	..i $p(^DHCEQDisuseList(ListID),"^",2)=0  d
	...s EquipID=$p(^DHCEQDisuseList(ListID),"^",3)   //add by wy 2019-11-11 需求1082787
	...d CheckEquip
	..e  d
	...s EquipIDs=$g(^DHCEQDisuseRequest(RowID,"EX"))
	...s Len=$l(EquipIDs,",")
	...for i=1:1:Len  q:(CheckFlag'=1)  d
	....s EquipID=$p(EquipIDs,",",i)
	....d CheckEquip
			
	q CheckFlag_"^"_MaxPrice
	
CheckEquip
	if EquipID="" q
	;过滤出库状态、本月入库设备
	i +$p(^DHCEQEquip(EquipID),"^",60)="3"
	{
		s CheckFlag=-1008
		q 
	}
	i +$p(^DHCEQEquip(EquipID),"^",60)="0"
	{
		s CheckFlag=-1008
		q 
	}
	;过滤掉无效的
	i $p(^DHCEQEquip(EquipID),"^",59)="Y"
	{
		s CheckFlag=-1009
		q 
	}
	;报废状态的过滤
	i (+$p(^DHCEQEquip(EquipID),"^",38))>2
	{
		s CheckFlag=-1010
		q 
	}	
	;检查设备科室 add by kdf 需要调整控制条件
	;modified  by wy 2019-11-11 需求1082787
	i (+$p(^DHCEQEquip(EquipID),"^",67))'=StoreLocDR
	{
		s CheckFlag=-1008
		q 
	}
	
	;检查设备类组
	/*i (+$p(^DHCEQEquip(EquipID),"^",63))'=EquipTypeDR
	{
		s CheckFlag=-1011
		q 
	}*/
	if ($p($g(^DHCEQEquip(EquipID)),"^",27)>MaxPrice) s MaxPrice=$p($g(^DHCEQEquip(EquipID)),"^",27)
}

/// ----------------------------------
/// 描述:取消提交报废单
/// 入参： 
/// 	RowID：报废单RowID
/// 返回值：SQLCODE^ErrDesc
/// 访问表:DHC_EQDisuseRequest,DHC_EQDisuseRequestList
/// w ##Class(web.DHCEQ.EM.BUSDisuseRequest).CancelSubmit(RowID)
ClassMethod CancelSubmit(val)
{
	s $ZT="ERRCancelSubmit"
	
	n User,Date,Time
	n PLIST,InvalidFlag,CheckFlag
	n ApproveType,MaxPrice
	n StoreLocDR,KindFlag
	
	n RowIDs,Count,flag,Opinion,Remark,EQStatus,EQStockStatus,drlrowid,DisuseType
	n ApproveSet,NextApproveFlow,NextStep,NextRole,AutoAuditFlag,LastFlag
	n CancelToFlowDR,CancelFlag,CurRole,Step,AFRowID,PLIST,ApproveRoleDR
	//midified by zy 2015-7-1 ZY0134 
	n UnusualStatus,UnusualRemark,UnusualFlag
	s UnusualFlag=0
	//Modified By QW20200119 BUG:QW0039 begin
	s User=$P(val,"^",7)
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s RejectReason=$P(val,"^",6) ;拒绝原因
	//Modified By QW20200119 BUG:QW0039 end
	k PLIST
	s Date=+$H
	s Time=$p($H,",",2) 	
 	
 	s RowID=$P(val,"^",1)
 	i RowID'=""
 	{
	 	s InvalidFlag=$Piece($G(^DHCEQDisuseRequest(RowID)),"^",53)
	 	i InvalidFlag="Y"  Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-2201","无效单据不能操作!")
 	}
 	else
 	{
	 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-2201","没有单据不能操作!")
	}
	
	;Status该记录状态不符合,不能执行操作!
	if $p($g(^DHCEQDisuseRequest(RowID)),"^",10)'="1"  Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-2015","该记录状态不符合,不能执行操作!")
	
	
	s PLIST(11)="0"   //报废单状态
	s PLIST(24)=$P(val,"^",6) ;拒绝原因 //Modified By QW20200119 BUG:QW0039
	s PLIST(25)=User
	s PLIST(26)=Date
	s PLIST(27)=Time
	
		
	s ApproveSetDR=$p($g(^DHCEQDisuseRequest(RowID)),"^",27)
	
	//add by zy 2013-06-04 zy0107
	//修改设备的预报废标识
	s approveroleid=##class(web.DHCEQCommon).GetSysInfo("601003")		//哪个角色审批时作为院内审批完成
	s approverolestep=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveRole",ApproveSetDR,approveroleid,0))
	i approverolestep'="" s approverolestep=$p($g(^DHCEQCCode("DHCEQCApproveFlow",approverolestep)),"^",3)
	
	s CurRole=$P(val,"^",2)  //Modified By QW20200119 BUG:QW0039
	s CancelToFlowDR=""
	s CancelFlag="N"
	s AFRowID=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveRole",ApproveSetDR,CurRole,0))
	i AFRowID'="" d
	.s CancelFlag=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AFRowID)),"^",5)
	.s CancelToFlowDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AFRowID)),"^",6)
	i CancelFlag'="Y"  Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1006","该步骤未设置为可取消")
	
	s (ApproveRoleDR,Step)=""
	i CancelToFlowDR'=""
	{
		s PLIST(11)="1"
		s ApproveRoleDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",2)
 		s Step=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",3)
		s PLIST(29)=ApproveRoleDR
	 	s PLIST(30)=Step
	 	
		//midified by zy 2015-7-1 ZY0134 
		//修改设备显示状态信息
		i (approveroleid'="")&(approverolestep>Step)  //modified by wy 2020-4-20 1276898院内报废审批完结审批角色退回的时候异常状态没有改变
		{
			s UnusualStatus="2"
			s UnusualRemark="预报废"
		}
		else
		{
			s UnusualStatus="1"
			s UnusualRemark="报废提交"
		}
 		s UnusualFlag=1
	}
 	else
 	{
	 	s PLIST(29)=""
 		s PLIST(30)=""
 		//midified by zy 2015-7-1 ZY0134
 		s UnusualStatus=""
 		s UnusualRemark=""
 		s UnusualFlag=1
	}
 	s PLIST(31)=""
 	s PLIST(32)=""
	
	TSTART
	//Add By QW20200119 BUG:QW0039 begin ;生成审批记录
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("5")
	s ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("5", RowID)
	s RoleStep=##class(web.DHCEQCApproveSet).GetStepByRole(ApproveSet,CurRole)
	s SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,RejectReason,"",CurRole,RoleStep,User,"1")
	if SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	//Add By QW20200119 BUG:QW0039 End 修改返回值
 	//midified by zy 2015-7-1 ZY0134 
 	//修改设备显示状态信息
 	s EquipIDs=##Class(web.DHCEQBatchDisuseRequest).GetDisuseEquipIDs(RowID)
 	s SQLCODE=##Class(web.DHCEQChangeInfo).UpdateEquipUnusualStatus(EquipIDs,UnusualStatus,UnusualRemark)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"更新设备异常状态信息失败!")
	}
	;仅当取消到新增时，才删除报废明细
	if (PLIST(11)=0)&&($D(^DHCEQDisuseRequestList(0,"DisuseRequest",RowID)))
	{			
	    //add by wy 2020-4-30 1288746 无效对应汇总明细
		s DRMergeOrderFlag=$p($g(^DHCEQDisuseRequest(RowID)),"^",54)
		if (DRMergeOrderFlag="Y")
		 {
			;Modified By QW20210525 BUG:QW0114
			&SQL(delete from  sqluser.DHC_EQMergeOrderList where ML_SourceID=:RowID)
			i SQLCODE
	 		{
				TROLLBACK
				q SQLCODE_"^无效对应汇总明细信息失败"
	 		}
		 }
		s PLIST(55)="N"		
		&SQL(delete from  SQLUSER.DHC_EQDisuseRequestList where DRL_DisuseRequestDR=:RowID)
		i SQLCODE
 		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"删除报废明细信息失败!")
 		}
	}
	 	
	&SQL(update sqluser.DHC_EQDisuseRequest values :PLIST() where DR_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"更新报废单信息失败!")
	}
 	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSetDR,RowID,ApproveRoleDR,Step,"","",PLIST(11),"Y")
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}	
	s ApproveFlow=""
	s CurRole=$P(val,"^",2)  //Modified By QW20200119 BUG:QW0039
	i CancelToFlowDR'=""
	{
		s ApproveFlow="N^"_Step_"^"_ApproveRoleDR_"^"_$p(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR),"^",7,11)_"^"_ApproveSetDR
	}
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("34", RowID, User, ApproveFlow, "Y",CurRole)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"创建业务消息失败!")
	}
	
 	TCOMMIT
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
ERRCancelSubmit
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息  
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1",ErrorMsg ) //返回错误消息 ;
}

/// ----------------------------------
/// 描述:审批报废单
/// 入参： 
/// 	val:审批信息 RowID^CurRole^Step^Opinion^Remark  18^2^1^^
/// 返回值：SQLCODE^ErrDesc
/// 访问表:DHC_EQDisuseRequest,DHC_EQDisuseRequestList
/// w ##Class(web.DHCEQBatchDisuseRequest)AuditData(val)
/// Modified By QW20200119 BUG:QW0039 增加输入data:微信端可编辑控制
/// modify by jyp 2020-02-27  JYP0022  报废信息表添加可编辑字段
ClassMethod AuditData(val, data As %Library.String = "", editFieldsInfo As %Library.String = "")
{
	Set $ZT="ERRORAudit"
	
	n User
	n RowID,PLIST
	n ApproveSet, ApproveType,ApproveFlow,LastFlag,AutoAuditFlag,NextRole,AuditFlag,CurRole
	n Opinion,Remark
	//midified by zy 2015-7-1 ZY0134
	n UnusualStatus,UnusualRemark,UnusualFlag
	s UnusualFlag=0	//标记是否修改异常状态信息
	//Modified By QW20200119 BUG:QW0039 begin
	s User=$P(val,"^",7)
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	
	//Modified By QW20200119 BUG:QW0039 end
	//add by zy 2013-06-04 zy0107
	//修改设备的预报废标识
	s approveroleid=##class(web.DHCEQCommon).GetSysInfo("601003")		//哪个角色审批时作为院内审批完成
	k PLIST
	s RowID=$P(val,"^",1)
	i RowID=""	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-2201","没有单据不能操作!")
	;InvalidFlag
	i $Piece($G(^DHCEQDisuseRequest(RowID)),"^",53)="Y"  Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-2201","无效单据不能操作!")
	;Status该记录状态不符合,不能执行操作!
	if $p($g(^DHCEQDisuseRequest(RowID)),"^",10)'="1"  Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-2215","该记录状态不符合,不能执行操作!") 
	
	s EquipType=$P(^DHCEQDisuseRequest(RowID),"^",43)			//Add By DJ 2016-04-01	DJ0177 begin 总单与明细单类组一致性判断
	;s SQLCODE=##CLASS(web.DHCEQInStockNew).EquipTypeIsUniqueNew(RowID,EquipType,"DisUse") ;modified by kdf 类组控制 2019-01-24
	;i SQLCODE<0 Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1011")  ;modified by kdf 类组控制 2019-01-24
	
	s CurRole=$p(val,"^",2)
	s PLIST(32)=CurRole
	s PLIST(31)=$p(val,"^",3)  //Step
	s Opinion=$p(val,"^",4)  //Opinion
	s Remark=$p(val,"^",5)
	s ApproveSet=$p($g(^DHCEQDisuseRequest(RowID)),"^",27)
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("5")
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, PLIST(31), PLIST(32))
 	s LastFlag=$p(ApproveFlow,"^",1)
 	s PLIST(30)=$p(ApproveFlow,"^",2)  //NextStep
 	s PLIST(29)=$p(ApproveFlow,"^",3)  //NextRole
 	s AppInfoStatus="1"
 	s AutoAuditFlag=$p($g(^DHCEQCCode("DHCEQCApproveSet",ApproveSet)),"^",9)
 	i AutoAuditFlag="Y" s AppInfoStatus="2"
 	TSTART

	s SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType, RowID, Opinion, Remark, PLIST(32), PLIST(31),User) //Modified By QW20200119 BUG:QW0039
	if SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"生成审批信息失败!")
	}
	;记录单据当前审批状态
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,PLIST(29),PLIST(30),PLIST(31),PLIST(32),AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	//begin modify by jyp 2020-02-27  JYP0022  报废信息表添加可编辑字段
	if editFieldsInfo'=""
	{
		s SQLCODE=##Class(web.DHCEQApprove).EditRoleReqFields(editFieldsInfo)		//编辑要修改的字段
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE_"^修改编辑字段信息失败!"
		}
	}
	//begin modify by jyp 2020-02-27  JYP0022  报废信息表添加可编辑字段
	//Add By QW20200119 BUG:QW0039 begin
	if data'=""
	{
		s SQLCODE=##Class(web.DHCEQ.EM.BUSDisuseRequest).SaveData(data,"","0","N",User)		
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	//Modified By QW20200119 BUG:QW0039 end
	s AuditFlag=0
	i AutoAuditFlag="Y"
	{
 		i (PLIST(30)="")||(LastFlag="Y")
 		{
	 		s PLIST(11)="2"
 			s SQLCODE=..LastAuditAction(RowID,User) //Modified By QW20200119 BUG:QW0039 
			if SQLCODE'=0
			{
 				TROLLBACK
 				Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"最后审核生成信息失败!")
			}
			s AuditFlag=1
			//midified by zy 2015-7-1 ZY0134 
			s UnusualFlag=1
			s (UnusualStatus,UnusualRemark)=""
 		}
	}
	
	&sql(update sqluser.DHC_EQDisuseRequest values :PLIST() where DR_RowID=:RowID)
	if SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"更新报废单信息失败!")
	}
		
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("34", RowID, User, ApproveFlow_"^"_ApproveSet, "N",CurRole,AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"生成业务消息失败!")
	}
	
	//add by zy 2013-06-04 zy0107
	//修改设备的预报废标识
	i (approveroleid=CurRole)
	{
	 	//midified by zy 2015-7-1 ZY0134
		s UnusualStatus="2"
		s UnusualRemark="预报废"
		s UnusualFlag=1
		/*
		s SQLCODE=##Class(web.DHCEQBatchDisuseRequest).UpdatePreDisuseFlag(RowID,"Y")
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE_"^修改台帐预报废标识失败!"
		}*/
	}
 	//midified by zy 2015-7-1 ZY0134 
 	//修改设备显示状态信息
 	if UnusualFlag=1
 	{
	 	s EquipIDs=##Class(web.DHCEQBatchDisuseRequest).GetDisuseEquipIDs(RowID)
	 	s SQLCODE=##Class(web.DHCEQChangeInfo).UpdateEquipUnusualStatus(EquipIDs,UnusualStatus,UnusualRemark)
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"更新设备异常状态信息失败!")
		}
	}
	TCOMMIT
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
	 
ERRORAudit
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-2201",ErrorMsg ) //返回错误消息 ;
}

/// 入参:LocDR 使用科室,Equip 设备名称,QXType,RequestRowID 主单ID
/// EquipTypeDR 类组ID ，ExcludeIDs 排除在外的设备ID串，AllListInfo，Flag true单台 false多台
/// 批次设备报废根据主单信息，检索所在科室的设备
/// add by wy 2020-1-18 QW20200218 BUG:QW0040
/// Modified BY QW20200320 BUG:QW0049 begin 增加输出TNetFee,TDepreTotalFee
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSDisuseRequest","GetDisuseEquip","327","","","",3,"","","true")
Query GetDisuseEquip(LocDR As %Library.String = "", Equip As %Library.String = "", QXType As %Library.String = "", RequestRowID As %Library.String = "", EquipTypeDR As %Library.String = "", ExcludeIDs As %Library.String = "", AllListInfo As %String = "", Flag As %String = "") As %Query(ROWSPEC = "TEquipDR:%String,TStoreLocDR:%String,TInStockListDR:%String,TModelDR:%String,TEquipCatDR:%String,TEQManufacturerDR:%String,TProviderDR:%String,TEquipTypeDR:%String,TEquip:%String,TStoreLoc:%String,TInStockNo:%String,TQuantityNum:%String,TModel:%String,TEquipCat:%String,TEQManufacturer:%String,TProvider:%String,TInDate:%String,TEquipType:%String,TLimitYearsNum:%String,TNo:%String,TLeaveFactoryNo:%String,TOriginalFee:%String,TFileNo:%String,THasConfig:%String,TConfigDR:%String,TNetFee:%String,TDepreTotalFee:%String")
{
}

ClassMethod GetDisuseEquipExecute(ByRef qHandle As %Binary, LocDR As %Library.String = "", Equip As %Library.String = "", QXType As %Library.String = "", RequestRowID As %Library.String = "", EquipTypeDR As %Library.String = "", ExcludeIDs As %Library.String = "", AllListInfo As %String = "", Flag As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	s Equip=##Class(web.DHCEQCommon).UnEscape(Equip)
	s Equip=$ZCONVERT(Equip ,"U")
	s TCurListRow=$p(AllListInfo,"=",1)
	s TJob=$p(AllListInfo,"=",2)
	s TAllListInfo=$p(AllListInfo,"=",3)
	s TAllListCount=$L(TAllListInfo,"&")
	i Flag="true" s Flag=0
	i Flag="false" s Flag=1
	d BuildDataGetDisuseEquip
	Quit $$$OK
BuildDataGetDisuseEquip 		
	s ISLRowID=0
	i Flag=0    //单台报废
	{
		s StoreLocID=0
		f  s StoreLocID=$o(^DHCEQEquip(0,"StoreLoc",StoreLocID)) q:StoreLocID=""  d
		.q:(LocDR'="")&&(LocDR'=StoreLocID)
		.q:##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLocID)="1"
		.s TStoreLocDR=StoreLocID
		.s TStoreLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",StoreLocID)      //库房 
		.s rowid=0
		.f  s rowid=$o(^DHCEQEquip(0,"StoreLoc",StoreLocID,rowid)) q:rowid=""  d
		..d ResetVariablesGetDisuseEquip	
		..s CurFlag=0		
		..s CurListNo=0
		..f CurListNo=1:1:TAllListCount  d
		...q:CurFlag'=0
		...s CurListInfo=$p(TAllListInfo,"&",CurListNo)
		...q:CurListInfo=""
		...s TCurListID=$p(CurListInfo,"^",1)
		...s TCurMXRowID=$p(CurListInfo,"^",2)
		...i TCurListRow'=TCurListID  d
		....i TCurMXRowID'=""  d
		.....s TCurRowIDs=$g(^TEMPEQ("MXList",TJob,TCurMXRowID))
		....e  d
		.....s TCurRowIDs=$g(^TEMPEQ("MXList","EX",TJob,TCurListID))
		....i (","_TCurRowIDs_",")[(","_rowid_",") s CurFlag=1		
		..q:CurFlag'=0
		..s TEquip=$p($g(^DHCEQEquip(rowid)),"^",1)           //设备
		..s EQCode=$p($g(^DHCEQEquip(rowid)),"^",6)	
		..s TNo=$p($g(^DHCEQEquip(rowid)),"^",71)          //设备编号
		..Set TFileNo=$Piece($Get(^DHCEQEquip(rowid)),"^",85)	//档案号
		..q:(Equip'="")&'(($ZCONVERT(TEquip,"U")[Equip)||($ZCONVERT(EQCode,"U")[Equip)||($ZCONVERT(TNo,"U")[Equip)||($ZCONVERT(TFileNo,"U")[Equip))
		..q:##Class(web.DHCEQBatchDisuseRequest).CheckEquipDR(3,RequestRowID,rowid,LocDR,ExcludeIDs)=1
		..s InStockListDR=$p($g(^DHCEQEquip(rowid)),"^",70)
		..i InStockListDR'="" d
		...s ISRowID=$p($g(^DHCEQInStockList(InStockListDR)),"^",1)    //入库申请单号dr
		...s TInStockNo = $p($g(^DHCEQInStock(ISRowID)),"^",14)   //入库申请单号
		...s TInDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInStock(ISRowID)),"^",13),"date")  //入库日期
		..e  d
		...s TInStockNo = ""   
		...s TInDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",45),"date")  //转资日期
		..s TEquipDR=rowid
		..s TModelDR=$p($g(^DHCEQEquip(rowid)),"^",3)          //机型
		..i TModelDR'=""  s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
		..s TEquipCatDR=$p($g(^DHCEQEquip(rowid)),"^",4)       //设备分类
		..i TEquipCatDR'=""  s TEquipCat = $p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",2)
		..s TEQManufacturerDR=$p($g(^DHCEQEquip(rowid)),"^",26)  //生产厂商
		..i TEQManufacturerDR'=""  s TEQManufacturer = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TEQManufacturerDR) //CZF0093
		..s TProviderDR=$p($g(^DHCEQEquip(rowid)),"^",25)       //供应商
		..i TProviderDR'=""  s TProvider = ##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)	; $p($g(^APC("APCVM",TProviderDR)),"^",3)
		..s TLimitYearsNum=$p($g(^DHCEQEquip(rowid)),"^",31)   //使用年限 
		..s TEquipTypeDR =$p($g(^DHCEQEquip(rowid)),"^",63)            //设备类组
		..q:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR)
		..q:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)="1"
		..i TEquipTypeDR'=""  s TEquipType= $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2) //设备类组
		..s TLeaveFactoryNo=$p($g(^DHCEQEquip(rowid)),"^",10)  //出厂编号
		..s TQuantityNum=1
		..s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(rowid)),"^",27),"")  //原值
		..;Modified BY QW20200320 BUG:QW0049 begin 增加输出TNetFee,TDepreTotalFee
		..s TNetFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(rowid)),"^",28),"")
		..s TDepreTotalFe=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(rowid)),"^",35),"")
		..;Modified BY QW20200320 BUG:QW0049 end 增加输出TNetFee,TDepreTotalFee
		..i THasConfig'="Y" d
		...s TOpenCheckListDR=$p($g(^DHCEQEquip(rowid)),"^",77)
		...i ##Class(web.DHCEQ.EM.BUSConfig).GetConfigDRs(1,TOpenCheckListDR)'="" s THasConfig="Y"
		..s TConfigDR=$Piece($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",26)				; EQHold13
		..i TConfigDR'="" s THasConfig="N"									; 过滤配置设备
		..d OutputRowGetDisuseEquip
	}
	i Flag=1   //批量报废
	{
		f  s ISLRowID=$o(^DHCEQEquip(0,"InStockList",ISLRowID)) q:ISLRowID=""  d
		.d ResetVariablesGetDisuseEquip
		.s ISRowID=$p($g(^DHCEQInStockList(ISLRowID)),"^",1)  //入库申请单号dr
		.s TInStockNo = $p($g(^DHCEQInStock(ISRowID)),"^",14)  //modified by wy 2020-4-29 1302251 入库单号取值错误问题
		.s TInStockListDR=ISLRowID
		.;判断类组时,判断设备的
		.s EquipTypeFlag=1
		.s TEquip=$p($g(^DHCEQInStockList(ISLRowID)),"^",5)      //设备名
		.s EQCode=$p($g(^DHCEQInStockList(ISLRowID)),"^",16)
		.i EQCode'="" s EQCode=$p($g(^DHCEQCCode("DHCEQCMasterItem",EQCode)),"^",2) //代码
		.q:(Equip'="")&'(($ZCONVERT(TEquip,"U")[Equip)||($ZCONVERT(EQCode,"U")[Equip))
		.q:##Class(web.DHCEQFinance2019).BussFilter(21,ISLRowID)'=0   // 比较设备项与业务单据类组是否一致
		.s StoreLocDR=0
		.f  s StoreLocDR=$o(^DHCEQEquip(0,"InStockList",ISLRowID,StoreLocDR)) q:((StoreLocDR="")||(EquipTypeFlag=0))  d
		..q:(LocDR'="")&($ZCONVERT(StoreLocDR,"U")'=$ZCONVERT(LocDR,"U"))
		..q:##class(web.DHCEQCommon).LocIsInEQ(QXType,LocDR)="1"
		..s EQRowID=0
		..s TQuantityNum=0
        ..// modified by ZY20230307 bug:    3262036
        ..s FirstOriginalFee=""
		..s TEquipDR=""
		..f  s EQRowID=$o(^DHCEQEquip(0,"InStockList",ISLRowID,StoreLocDR,EQRowID)) q:((EQRowID="")||(EquipTypeFlag=0))  d
		...s CurFlag=0		
		...s CurListNo=0
		...f CurListNo=1:1:TAllListCount  d
		....q:CurFlag'=0
		....s CurListInfo=$p(TAllListInfo,"&",CurListNo)
		....q:CurListInfo=""
		....s TCurListID=$p(CurListInfo,"^",1)
		....s TCurMXRowID=$p(CurListInfo,"^",2)
		....i TCurListRow'=TCurListID  d
		.....i TCurMXRowID'=""  d
		......s TCurRowIDs=$g(^TEMPEQ("MXList",TJob,TCurMXRowID))
		.....e  d
		......s TCurRowIDs=$g(^TEMPEQ("MXList","EX",TJob,TCurListID))
		.....i (","_TCurRowIDs_",")[(","_EQRowID_",") s CurFlag=1
		...q:CurFlag'=0		
		...s TEquipTypeDR =$p($g(^DHCEQEquip(EQRowID)),"^",63)             //类组DR
		...i (EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR) s EquipTypeFlag=0
		...q:EquipTypeFlag=0
		...i ##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)="1" s EquipTypeFlag=0
		...q:EquipTypeFlag=0
		...q:##Class(web.DHCEQBatchDisuseRequest).CheckEquipDR(3,RequestRowID,EQRowID,LocDR,ExcludeIDs)=1
        ...// modified by ZY20230307 bug:    3262036
		...s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(EQRowID)),"^",27),"")  //原值
        ...i FirstOriginalFee="" s FirstOriginalFee=TOriginalFee
        ...q:(TOriginalFee'=FirstOriginalFee)
        ...s TQuantityNum=TQuantityNum+1
		...;Modified BY QW20200320 BUG:QW0049 begin 增加输出TNetFee,TDepreTotalFee
		...s TNetFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(EQRowID)),"^",28),"")
		...s TDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(EQRowID)),"^",35),"")
		...;Modified BY QW20200320 BUG:QW0049 End 增加输出TNetFee,TDepreTotalFee
        ..i FirstOriginalFee'="" s TOriginalFee=FirstOriginalFee
		..i Flag="1" q:TQuantityNum<=1
		..s TStoreLocDR=StoreLocDR
		..s TStoreLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",StoreLocDR)      //库房 20140716  Mozy0134
		..i TEquipTypeDR'=""  s TEquipType= $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2) //设备类组
		..s TModelDR=$p($g(^DHCEQInStockList(ISLRowID)),"^",9)     //机型
		..i TModelDR'=""  s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
		..s TEquipCatDR=$p($g(^DHCEQInStockList(ISLRowID)),"^",14)   //设备分类
		..i TEquipCatDR'=""  s TEquipCat = $p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",2)
		..s TEQManufacturerDR=$p($g(^DHCEQInStockList(ISLRowID)),"^",6)   //生产厂商
		..i TEQManufacturerDR'=""  s TEQManufacturer = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TEQManufacturerDR) //CZF0093
		..s TProviderDR=$p($g(^DHCEQInStock(ISRowID)),"^",17)             //供应商
		..i TProviderDR'=""  s TProvider = ##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)		;$p($g(^APC("APCVM",TProviderDR)),"^",3)
		..s TLimitYearsNum = $p($g(^DHCEQInStockList(ISLRowID)),"^",15)   //使用年限
		..s TInDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInStock(ISRowID)),"^",13),"date") //入库日期
		..s TOpenCheckListDR=$p($g(^DHCEQInStockList(ISLRowID)),"^",19)
		..i ##Class(web.DHCEQ.EM.BUSConfig).GetConfigDRs(1,TOpenCheckListDR)'="" s THasConfig="Y"
		..s TConfigDR=$Piece($Get(^DHCEQInStockList(ISLRowID)),"^",22)
		..i TConfigDR'="" s THasConfig="N"
		..d OutputRowGetDisuseEquip
	}
	quit
OutputRowGetDisuseEquip
	Set Data=$lb(TEquipDR,TStoreLocDR,TInStockListDR,TModelDR,TEquipCatDR,TEQManufacturerDR,TProviderDR,TEquipTypeDR,TEquip,TStoreLoc,TInStockNo,TQuantityNum,TModel,TEquipCat,TEQManufacturer,TProvider,TInDate,TEquipType,TLimitYearsNum,TNo,TLeaveFactoryNo,TOriginalFee,TFileNo,THasConfig,TConfigDR,TNetFee,TDepreTotalFee) //Modified BY QW20200320 BUG:QW0049 begin 增加输出TNetFee,TDepreTotalFee
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetDisuseEquip
	s (TEquipDR,TEquip,TInStockListDR,TInStockNo,TQuantityNum,TModel,TModelDR,TEquipCat,TEquipCatDR,TEQManufacturer,TEQManufacturerDR,TProvider,TProviderDR,TInDate,TEquipType,TEquipTypeDR,TLimitYearsNum,TNo,TLeaveFactoryNo,TOriginalFee,TFileNo,TConfigDR,TNetFee,TDepreTotalFee)="" //Modified BY QW20200320 BUG:QW0049 begin 增加输出TNetFee,TDepreTotalFee
	s THasConfig="N"	;无配置设备
	quit
}

ClassMethod GetDisuseEquipFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDisuseEquipExecute ]
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

ClassMethod GetDisuseEquipClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDisuseEquipExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 创建：wy 2020-01-16  QW20200218 BUG:QW0040
/// 描述：判断批次报废设备数量与选择的RowIDs是否一致
/// 参数：	DRRowID主单ID
/// 		DataList明细信息
/// 		Job任务Job
/// 返回值：Flag 0一致 其他不一致
/// 
ClassMethod JudgeDLQuantityNum(DRRowID, Job, DataList)
{
	new (DRRowID, Job, DataList)
	i DRRowID="" q -1
	i DataList="" q 0
	s Flag=0
	s StoreLocDR=$p($g(^DHCEQDisuseRequest(DRRowID)),"^",34)		;StoreLocDR
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")  
	s Length=$l(DataList,SplitRowCode)
	for k=1:1:Length
	{
		q:Flag'=0
		s valList=$p(DataList,SplitRowCode,k)   //add by zx 2019-07-22
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valList)
		s index=JsonData.DLIndex //index处理
		s DLRowID= JsonData.DLRowID 
		s DLSourceID=JsonData.DLSourceID
		i JsonData.DLSourceType=0
		{
			if DLRowID=""  //新增明细
			{
				s ^TEMPEQ("MXList","EX",Job,index)=DLSourceID
			}
			else
			{
				s ^DHCEQDisuseList(DLRowID,"EX")=DLSourceID
				k ^TEMPEQ("MXList",Job,DLRowID)
			}
			continue //单台设备不处理
		}
		s QuantityNum=JsonData.DLQty
 		s RowIDs=""
		s Len=0
 		if DLRowID=""  //新增明细
 		{
 			s RowIDs=$g(^TEMPEQ("MXList","EX",Job,index))
 		}
 		else
 		{
	 		s RowIDs=$g(^TEMPEQ("MXList",Job,DLRowID))
 			i ((RowIDs="")&&(DLSourceID=$p(^DHCEQDisuseList(DLRowID),"^",3))) s RowIDs=$g(^DHCEQDisuseList(DLRowID,"EX"))
	 	}
	 	if RowIDs'="" s Len=$l(RowIDs,",")
	 	if (Len'=QuantityNum)
	 	{
			s Flag=##Class(web.DHCEQUpdateEquipsByList).GetRowIDsByQuantityNum(DLSourceID,QuantityNum,DLRowID,StoreLocDR,Job,index,"5")   //Modified by QW20200303 BUG:QW0042
			
		}
		else
		{
			if (DLRowID'="")&&($Data(^TEMPEQ("MXList",Job,DLRowID)))
			{
				s ^DHCEQDisuseList(DLRowID,"EX")=$g(^TEMPEQ("MXList",Job,DLRowID))
				k ^TEMPEQ("MXList",Job,DLRowID)
			}
		}
	}
	q Flag
}

/// Add By QW20200119 BUG:QW0039
/// 报废种类query
/// 	入参:Type
/// 	输出-TRowID,TDesc
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSDisuseRequest","GetKindFlag","")
Query GetKindFlag(Type As %Library.String = "") As %Query(ROWSPEC = "TRowID:%String,TDesc:%String")
{
}

ClassMethod GetKindFlagExecute(ByRef qHandle As %Binary, Type As %Library.String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s Length=2
	f rowid=0:1:Length d
	.q:(Type="")&&(rowid=2) 
	.q:(Type'="")&&(rowid'=2)
	.s TDesc=$case(rowid,"0":"单台报废","1":"批量报废","2":"多批报废")
	.d OutputRowGetKindFlag
	
	Quit $$$OK
OutputRowGetKindFlag
	Set Data=$lb(rowid,TDesc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetKindFlagFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetKindFlagExecute ]
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

ClassMethod GetKindFlagClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetKindFlagExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Add by QW20200303 BUG:QW0042
/// 描述：根据参数rowid取出报废单中设备的出厂编号和设备编号,档案编号。
/// 访问表:DHC_EQEquip
ClassMethod GetEquipNoAndLeaveFactoryNo(itmjs As %Library.String = "", itmjsex As %Library.String = "", RowIDs As %Library.String = "")
{
	new result,resultNo,resultLeaveFactoryNo,resultFileNo,RowID
	s (result,resultNo,resultLeaveFactoryNo,resultFileNo)=""
	if (RowIDs=0)||(RowIDs="")  q ""
	s Count=$l(RowIDs,",")
	for j=1:1:Count
	{
		s RowID=$p(RowIDs,",",j)  ;EquipDR	 				
		s LeaveFactoryNo= $p($g(^DHCEQEquip(RowID)),"^",10)    //出厂编号
		s No=$p( $g(^DHCEQEquip(RowID)),"^",71)    //设备编号
		s FileNo=$p( $g(^DHCEQEquip(RowID)),"^",85)   	
		i LeaveFactoryNo'="" s resultLeaveFactoryNo=resultLeaveFactoryNo_","_LeaveFactoryNo 
		s resultNo=resultNo_","_No
		i FileNo'="" s resultFileNo=resultFileNo_","_FileNo 
		s OriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(RowID)),"^",27),"")  //原值	
	}
	s resultLeaveFactoryNo=$e(resultLeaveFactoryNo,2,$l(resultLeaveFactoryNo))
	s resultNo=$e(resultNo,2,$l(resultNo))
	s resultFileNo=$e(resultFileNo,2,$l(resultFileNo))
	Set resultNo=##Class(web.DHCEQCommon).NoToGroupNo(resultNo)	
	s result=resultNo_"^"_resultLeaveFactoryNo_"^"_OriginalFee_"^"_resultFileNo  
	q result
}

/// Create by wy 2020-04-29 1296762
/// 描述：根据入库单明细ID取设备ID串。
/// 入参：ISLRowID 入库明细ID StoreLocDR 存储科室
/// 返回值：设备ID串
/// w ##Class(web.DHCEQ.EM.BUSDisuseRequest).GetEquipByInStockListDR(1,327)
ClassMethod GetEquipByInStockListDR(ISLRowID As %Library.String = "", StoreLocDR As %Library.String = "")
{
	n result
	s result=""
	i (ISLRowID="")||(StoreLocDR="") q ""
	s EQRowID=0
	f  s EQRowID=$o(^DHCEQEquip(0,"InStockList",ISLRowID,StoreLocDR,EQRowID)) q:EQRowID=""  d
	.q:$p($g(^DHCEQEquip(EQRowID)),"^",59) 
	.i result="" d
	..s result=EQRowID	
	.e  d
	..s result=result_"^"_EQRowID
	q result
}

/// 创建:MWZ 2021-01-18
/// 描述:当前人取消提交
/// 入参 val:报废单rowid，CurRole ：当前菜单ApproveRole
/// 返回值：SQLCODE  RowID
/// w ##Class(web.DHCEQ.EM.BUSDisuseRequest).SelfCancelSubmitData("6^","")
ClassMethod SelfCancelSubmitData(val As %Library.String = "", CurRole As %Library.String = "")
{
	n UnusualStatus,UnusualRemark,UnusualFlag
	s UnusualFlag=0
	s RowID=$Piece(val,"^",1)
	s CancelToFlowDR="",APLRowID="",CurStep=0
	s $ZT="ERRORSelfCancelSubmitData"
	s User=$Piece(val,"^",2)
	i User="" 	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s updDate=+$H
 	s updTime=$Piece($H,",",2)
 	s ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("5", RowID)
	i CurRole'="" s CancelToFlowDR=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveRole",ApproveSet,CurRole,0))
	s RejectReason="自发撤回"
	s Status="0"     
	s ApproveRoleDR=""
	s Step="1"
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("5")
	if (CancelToFlowDR'="")
	{
		s ApproveRoleDR=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",2)
		s Step=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",3)
		s APLRowID=$o(^DHCEQApproveList(0,"Source",ApproveType,RowID,""),-1)
		i APLRowID'="" s CurStep=$p($g(^DHCEQApproveList(APLRowID)),"^",9)
		s Status="1"
	 	s approveroleid=##class(web.DHCEQCommon).GetSysInfo("601003")		//哪个角色审批时作为院内审批完成
		s approverolestep=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveRole",ApproveSetDR,approveroleid,0))
		i approverolestep'="" s approverolestep=$p($g(^DHCEQCCode("DHCEQCApproveFlow",approverolestep)),"^",3)

		i (approveroleid'="")&(approverolestep>Step)  
		{
			s UnusualStatus="2"
			s UnusualRemark="预报废"
		}
		else
		{
			s UnusualStatus="1"
			s UnusualRemark="报废提交"
		}
 		s UnusualFlag=1
	}
	else
 	{
	 	s PLIST(29)=""
 		s PLIST(30)=""
 		s UnusualStatus=""
 		s UnusualRemark=""
 		s UnusualFlag=1
	}
	i (Step'=CurStep)&&(CurStep'=0) Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9022")
	s PLIST(31)=""
 	s PLIST(32)=""
	TSTART
	;生成审批记录
	s SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,RejectReason,"",CurRole,CurStep,User,"1")
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,ApproveRoleDR,Step,"","",Status,"Y")
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	s PLIST(11)= Status	// MR_Status
	s PLIST(29)= CurRole
	i CurStep=0 s CurStep=""
	s PLIST(30)= CurStep
	;仅当取消到新增时，才删除报废明细
	if (PLIST(11)=0)&&($D(^DHCEQDisuseRequestList(0,"DisuseRequest",RowID)))
	{					
		s DRMergeOrderFlag=$p($g(^DHCEQDisuseRequest(RowID)),"^",54)
		if (DRMergeOrderFlag="Y")
		 {
			;Modified By QW20210525 BUG:QW0114
			&SQL(delete from  sqluser.DHC_EQMergeOrderList where ML_SourceID=:RowID)
			i SQLCODE
	 		{
				TROLLBACK
				q SQLCODE_"^无效对应汇总明细信息失败"
	 		}
		 }
		s PLIST(55)="N"		
		&SQL(delete from  SQLUSER.DHC_EQDisuseRequestList where DRL_DisuseRequestDR=:RowID)
		i SQLCODE
 		{
			TROLLBACK
			q SQLCODE_"^删除报废明细信息失败"
 		}
	}
 	s EquipIDs=##Class(web.DHCEQBatchDisuseRequest).GetDisuseEquipIDs(RowID)
 	s SQLCODE=##Class(web.DHCEQChangeInfo).UpdateEquipUnusualStatus(EquipIDs,UnusualStatus,UnusualRemark)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9004",SQLCODE)
	}
	 	
	&sql(Update SQLUSER.DHC_EQDisuseRequest Values :PLIST() where DR_RowID=:RowID)
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1401",SQLCODE)
	}
	s ApproveFlow=""
	i CancelToFlowDR'=""
	{
		s ApproveFlow="N^"_Step_"^"_ApproveRoleDR_"^"_$p(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR),"^",7,11)_"^"_ApproveSet
	}
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("34", RowID, User, ApproveFlow, "Y",CurRole)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9005",SQLCODE)
	}
	TCOMMIT
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
ERRORSelfCancelSubmitData 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息  
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1",ErrorMsg ) //返回错误消息 ;
}

/// 创建：MZY0153	3295363		2023-02-20
/// 描述：根据参数rowid获取报废单净值不为0的设备
/// 访问表:DHC_EQDisuseRequestList : 2 DisuseRequestDR,3 EquipID ,13 DHC_EQDisuseList->RowID 
/// 返回值：设备编号字符串
/// w ##Class(web.DHCEQ.EM.BUSDisuseRequest).CheckEquipNetfee(63)
ClassMethod CheckEquipNetfee(RowID)
{
	i RowID="" q ""
	
	n EQNoStr,KindFlag,EquipIDs,EquipID,Len
	s EQNoStr=""
	s KindFlag=$P(^DHCEQDisuseRequest(RowID),"^",44)
	
	if KindFlag=0  d
	.s EquipID=$P(^DHCEQDisuseRequest(RowID),"^",1)
	.i +$p($g(^DHCEQEquip(EquipID)),"^",28)'=0 s EQNoStr=$p($g(^DHCEQEquip(EquipID)),"^",71)
	else  if KindFlag=1  d
	.s EquipIDs=$g(^DHCEQDisuseRequest(RowID,"EX"))
	.s Len=$l(EquipIDs,",")
	.for i=1:1:Len  q:(SQLCODE'=0)  d
	..s EquipID=$p(EquipIDs,",",i)
	..i +$p($g(^DHCEQEquip(EquipID)),"^",28)'=0 d
	...i EQNoStr'="" s EQNoStr=EQNoStr_","
	...s EQNoStr=EQNoStr_$p($g(^DHCEQEquip(EquipID)),"^",71)
	else  d
	.;多批 KindFlag=2
	.s ListID=""
	.f  s ListID=$o(^DHCEQDisuseList(0,"Request",RowID,ListID))  quit:(ListID="")  d
	..i $p(^DHCEQDisuseList(ListID),"^",2)=0  d    ;来源为台账
	...s EquipID=$P(^DHCEQDisuseList(ListID),"^",3)
	...i +$p($g(^DHCEQEquip(EquipID)),"^",28)'=0 s EQNoStr=$p($g(^DHCEQEquip(EquipID)),"^",71)
	..e  d
	...s EquipIDs=$g(^DHCEQDisuseList(ListID,"EX"))
	...s Len=$l(EquipIDs,",")
	...for i=1:1:Len  d
	....s EquipID=$p(EquipIDs,",",i)
	....i +$p($g(^DHCEQEquip(EquipID)),"^",28)'=0 d
	.....i EQNoStr'="" s EQNoStr=EQNoStr_","
	.....s EQNoStr=EQNoStr_$p($g(^DHCEQEquip(EquipID)),"^",71)
	q EQNoStr
}

}
