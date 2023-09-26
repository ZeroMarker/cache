/// 名称: web.DHCEQ.Plat.LIBDataChangeRequest
/// 描述: 数据变更申请
/// 编写者：CZF
/// 编写日期: 2020-08-18
/// 产品组：设备管理
Class web.DHCEQ.Plat.LIBDataChangeRequest Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:czf
/// CreatDate:2020-08-18
/// Description:数据变更申请
/// Input:data:保存数据Json串;
/// 	  DelIs:删除标志,1:删除 其他:保存数据; 
/// OutPut:0:成功 其他:失败
/// Command:w ##Class(web.DHCEQ.Plat.LIBDataChangeRequest).SaveData()
ClassMethod SaveData(data, DelIs)
{
	k PLIST,RowID
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$p($h,",",2)
	s SQLCODE=0
	
	if DelIs=1
	{
		s RowID=data
		&SQL(Update SQLUSER.DHC_EQDataChangeRequest set DCR_InvalidFlag='Y' where DCR_RowID = :RowID)
		i SQLCODE q SQLCODE
		;清除资金来源临时global
		s ClassName=$p($g(^DHCEQDataChangeRequest(RowID)),"^",2)
		s BussID=$p($g(^DHCEQDataChangeRequest(RowID)),"^",3)
		i ClassName="User.DHCEQOpenCheckRequest"
		{
			s SourceType=0
			s SourceID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",BussID,""))
			k ^DHCEQTempFunds(0,"Source",SourceType,SourceID)
		}
		s RowID=""
	}
	else
	{
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
		s RowID = JsonData.DCRRowID
	    s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQDataChangeRequest",JsonData,.PLIST)
	 	s PLIST(5) = User	;UpdateUserDR
	 	s PLIST(6) = Date	;UpdateDate
	 	s PLIST(7) = Time	;UpdateTime
		s PLIST(14) = "0"	;Status
		s PLIST(15) = "N"	;Invalidflag
	    if RowID'=""
	    {
			&SQL(Update SQLUSER.DHC_EQDataChangeRequest Values :PLIST() where DCR_RowID = :RowID)
		}
		else
		{
			//i PLIST(16)="" s PLIST(16)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQDataChangeRequest",Date,"","","","","")
			&SQL(insert into SQLUSER.DHC_EQDataChangeRequest Values :PLIST())
		}
		i SQLCODE q SQLCODE
		s RowID=$g(%ROWID)
	}
	i SQLCODE q SQLCODE
	
	q RowID
	//Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
}

/// Creator:czf
/// CreatDate:2020-08-18
/// Description:提交数据变更申请
/// Command:w ##Class(web.DHCEQ.Plat.LIBDataChangeRequest).SubmitData("36")
ClassMethod SubmitData(val)
{
	new (val, %session)
	k PLIST
	s User = ##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date = +$H
	s Time = $P($H,",",2)
	
	Set $ZT="ERRORSubmit"
	
	s RowID = $p(val,"^",1)
	i RowID="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9200","单据RowID不能为空!") 
	
	s InvalidFlag=$p($g(^DHCEQDataChangeRequest(RowID)),"^",14)
	i InvalidFlag="Y" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9200","单据已无效!") 
		
	s PLIST(14) = 1		;Status
	s PLIST(17) = User	;SubmitUserDR
	s PLIST(18) = Date	;SubmitDate
	s PLIST(19) = Time	;SubmitTime
	
	TSTART	
	&SQL(update sqluser.DHC_EQDataChangeRequest values :PLIST() where DCR_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	
	s AutoConfirm=##class(web.DHCEQCommon).GetSysInfo("301015")
	i AutoConfirm="1"
	{
		s RtnCode=##Class(web.DHCEQ.Plat.LIBDataChangeRequest).AuditData(RowID)
		s RtnObj=##class(web.DHCEQ.Plat.JsonObject).FromJSON(RtnCode)	//CZF0131 2021-01-20
		i +RtnObj.SQLCODE
		{
			TROLLBACK
			q RtnCode
		}
	}
	
 	TCOMMIT
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
 	
ERRORSubmit 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg) //返回错误消息
}

/// Creator:czf
/// CreatDate:2020-08-18
/// Description:数据变更申请确认
/// w ##Class(web.DHCEQ.Plat.LIBDataChangeRequest).AuditData("5")
ClassMethod AuditData(val)
{
	new (val, %session)
	k PLIST
	s User = ##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date = +$H
	s Time = $P($H,",",2)
	
	Set $ZT="ERRORAudit"
	s SQLCODE=0
	s RowID = $p(val,"^",1)
	
	s Status = $p($g(^DHCEQDataChangeRequest(RowID)),"^",14)
	i Status = 2 Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9200","调整单据已审核")	;调整单据已审核
	
	s PLIST(14) = 2		;Status
	s PLIST(11) = User	;AuditUserDR
	s PLIST(12) = Date	;AuditDate
	s PLIST(13) = Time	;AuditTime
	
	TSTART	
	&SQL(update sqluser.DHC_EQDataChangeRequest values :PLIST() where DCR_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	
	s TableName=$p(^DHCEQDataChangeRequest(RowID),"^",1)
	s ClassName=$p(^DHCEQDataChangeRequest(RowID),"^",2)
	s BussID=$p(^DHCEQDataChangeRequest(RowID),"^",3)
	s OldValue=$p(^DHCEQDataChangeRequest(RowID),"^",8)
	s NewValue=$p(^DHCEQDataChangeRequest(RowID),"^",9)
	
	i TableName="DHC_EQInStock"		//入库单修改
	{
		s SQLCODE=##Class(web.DHCEQ.Plat.LIBBusinessModify).UpdateInStockBusinessNew(BussID,NewValue,"Y","",RowID)
	}
	elseif TableName="DHC_EQInStockList"		//入库明细修改
	{
		s SQLCODE=##Class(web.DHCEQ.Plat.LIBBusinessModify).UpdateInStockBusinessNew(BussID,NewValue,"","",RowID)
	}
	elseif TableName="DHC_EQOpenCheckRequest"		//验收单修改
	{
		s SQLCODE=##Class(web.DHCEQ.Plat.LIBBusinessModify).UpdateOpenCheckBusinessNew(BussID,NewValue,"","",RowID)
	}
	///add by ZY0252 20210301
	elseif TableName="DHC_EQContract"		//合同修改
	{
		s SQLCODE=##Class(web.DHCEQ.Plat.LIBBusinessModify).UpdateContractBusinessNew(BussID,NewValue,"Y","",RowID)
	}
	elseif TableName="DHC_EQContractList"		//合同明细修改
	{
		s SQLCODE=##Class(web.DHCEQ.Plat.LIBBusinessModify).UpdateContractBusinessNew(BussID,NewValue,"","",RowID)
	}
	else
	{
		/*
		XECUTE "s TableObject=##Class("_ClassName_").%OpenId("_BussID_")"
		set Iter = DataJson.%GetIterator()
	   	while Iter.%GetNext(.key , .value ) {
		   s TableObject.key=value
	   	}
	   	s sc=TableObject.%Save()
    	i $$$ISERR(sc)
    	{
	    	TRollBACK
			q sc
	    }
	    */
	}
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
 	TCOMMIT
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
 	
ERRORAudit 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg) //返回错误消息
}

/// Creator：czf
/// CreatDate：2020-08-17
/// Description: 获取数据变动申请信息
/// Input：DCRID:入库单明细RowID
/// OutPut：表数据解析 json返回
/// Command：w ##Class(web.DHCEQ.Plat.LIBDataChangeRequest).GetOneDataChangeRequest("1")
ClassMethod GetOneDataChangeRequest(DCRID As %Library.String = "")
{
	s $ZT="ERRORGetOneDataChangeRequest"
	s ObjDataChangeRequest=##Class(User.DHCEQDataChangeRequest).%OpenId(DCRID)
	s DataChangeReqInfo=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjDataChangeRequest)
	d DataChangeReqInfo.%Set("DCRUpdateUserDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",DataChangeReqInfo.DCRUpdateUserDR))
	d DataChangeReqInfo.%Set("DCRAuditUserDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",DataChangeReqInfo.DCRAuditUserDR))
	d DataChangeReqInfo.%Set("DCRSubmitUserDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",DataChangeReqInfo.DCRSubmitUserDR))
	s NewValueObj=##class(web.DHCEQ.Plat.JsonObject).FromJSON(DataChangeReqInfo.DCRNewValue)	//CZF0131 2021-01-20
	
	//set iter = NewValueObj.%GetIterator()
   	//while iter.%GetNext(.key , .value ) {
	s key=""
	For
	{
		s value=NewValueObj.GetNext(.key)
		q:key=""
	   if (DataChangeReqInfo.DCRTableName="DHC_EQInStock")
	   {
		   i key="ISBuyLocDR" d NewValueObj.%Set("ISBuyLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",value))
		   e  i key="ISBuyUserDR" d NewValueObj.%Set("ISBuyUserDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",value))
		   e  i key="ISEquipTypeDR" d NewValueObj.%Set("ISEquipTypeDR_ETDesc",##class(web.DHCEQCommon).GetTrakNameByID("equiptype",value))
		   e  i key="ISProviderDR" d NewValueObj.%Set("ISProviderDR_VDesc",##class(web.DHCEQCommon).GetTrakNameByID("prov",value))
		   e  i key="ISOriginDR" d NewValueObj.%Set("ISOriginDR_ODesc",##class(web.DHCEQCommon).GetTrakNameByID("origin",value))
		   //i key="ISInDate" d NewValueObj.%Set("ISInDate",value)
		}
		elseif (DataChangeReqInfo.DCRTableName="DHC_EQInStockList")
		{
			//i key="ISLEquipName" d NewValueObj.%Set("ISLEquipName",value)
			i key="ISLModelDR" d NewValueObj.%Set("ISLModelDR_MDesc",##class(web.DHCEQCommon).GetTrakNameByID("model",value))
			e  i key="ISLUnitDR" d NewValueObj.%Set("ISLUnitDR_UOMDesc",##class(web.DHCEQCommon).GetTrakNameByID("uom",value))
			e  i key="ISLManuFactoryDR" d NewValueObj.%Set("ISLManuFactoryDR_MFName",##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",value))
			e  i key="ISLStatCatDR" d NewValueObj.%Set("ISLStatCatDR_SCDesc",##class(web.DHCEQCommon).GetTrakNameByID("statcat",value))
			e  i key="ISLEquipCatDR" d NewValueObj.%Set("ISLEquipCatDR_ECDesc",##class(web.DHCEQCommon).GetTrakNameByID("equipcat",value))
			//i key="ISLLimitYearsNum" d NewValueObj.%Set("ISLLimitYearsNum",value)
			e  i key="ISLHold5" d NewValueObj.%Set("ISLHold5_EDesc",##class(web.DHCEQCommon).GetTrakNameByID("expense",value))
			//i key="ISLRemark" d DataChangeReqInfo.%Set("ISLRemark",value)
		}
		elseif (DataChangeReqInfo.DCRTableName="DHC_EQOpenCheckRequest")
		{
			s OCRObj=NewValueObj.OpenCheckRequest
			s OCLObj=NewValueObj.OpenCheckList
			//set iter = OCRObj.%GetIterator()
   			//while iter.%GetNext(.key , .value ) {
	   		s ocrkey=""
			For
			{
				s ocrvalue=OCRObj.GetNext(.ocrkey)
				q:ocrkey=""
	   			i ocrkey="OCREquipTypeDR" d OCRObj.%Set("OCREquipTypeDR_ETDesc",##class(web.DHCEQCommon).GetTrakNameByID("equiptype",ocrvalue))
				e  i ocrkey="OCRStatCatDR" d OCRObj.%Set("OCRStatCatDR_SCDesc",##class(web.DHCEQCommon).GetTrakNameByID("statcat",ocrvalue))
				e  i ocrkey="OCRProviderDR" d OCRObj.%Set("OCRProviderDR_VDesc",##class(web.DHCEQCommon).GetTrakNameByID("prov",ocrvalue))
				e  i ocrkey="OCROriginDR" d OCRObj.%Set("OCROriginDR_ODesc",##class(web.DHCEQCommon).GetTrakNameByID("origin",ocrvalue))
   			}
   			//set iter = OCLObj.%GetIterator()
   			//while iter.%GetNext(.key , .value ) {
	   		s oclkey=""
			For
			{
				s oclvalue=OCLObj.GetNext(.oclkey)
				q:oclkey=""
	   			i oclkey="OCLEquiCatDR" d OCLObj.%Set("OCLEquiCatDR_ECDesc",##class(web.DHCEQCommon).GetTrakNameByID("equipcat",oclvalue))
				e  i oclkey="OCLModelDR" d OCLObj.%Set("OCLModelDR_MDesc",##class(web.DHCEQCommon).GetTrakNameByID("model",oclvalue))
				e  i oclkey="OCLUnitDR" d OCLObj.%Set("OCLUnitDR_UOMDesc",##class(web.DHCEQCommon).GetTrakNameByID("uom",oclvalue))
				e  i oclkey="OCLUseLocDR" d OCLObj.%Set("OCLUseLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",oclvalue))
				e  i oclkey="OCLLocationDR" d OCLObj.%Set("OCLLocationDR_LDesc",##class(web.DHCEQCommon).GetTrakNameByID("location",oclvalue))
   				e  i oclkey="OCLManuFactoryDR" d OCLObj.%Set("OCLManuFactoryDR_VName",##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",oclvalue)) 	//czf 2021-06-11
				e  i oclkey="OCLCountryDR" d OCLObj.%Set("OCLCountryDR_CTCOUDesc",##class(web.DHCEQCommon).GetTrakNameByID("country",oclvalue))
				e  i oclkey="OCLPurchaseTypeDR" d OCLObj.%Set("OCLPurchaseTypeDR_PTDesc",##class(web.DHCEQCommon).GetTrakNameByID("purchasetype",oclvalue))
				e  i oclkey="OCLPurposeTypeDR" d OCLObj.%Set("OCLPurposeTypeDR_PTDesc",##class(web.DHCEQCommon).GetTrakNameByID("purposetype",oclvalue))
				e  i oclkey="OCLBuyTypeDR" d OCLObj.%Set("OCLBuyTypeDR_BTDesc",##class(web.DHCEQCommon).GetTrakNameByID("buytype",oclvalue))
				e  i oclkey="OCLDepreMethodDR" d OCLObj.%Set("OCLDepreMethodDR_DMDesc",##class(web.DHCEQCommon).GetTrakNameByID("depremethod",oclvalue))
				e  i oclkey="OCLHold5" d OCLObj.%Set("OCLHold5_EDesc",##class(web.DHCEQCommon).GetTrakNameByID("expense",oclvalue))
				e  i oclkey="OCLEquipTypeDR" d OCLObj.%Set("OCLEquipTypeDR_ETDesc",##class(web.DHCEQCommon).GetTrakNameByID("equiptype",oclvalue))
				e  i oclkey="OCLStatCatDR" d OCLObj.%Set("OCLStatCatDR_SCDesc",##class(web.DHCEQCommon).GetTrakNameByID("statcat",oclvalue))
   			}
   			d NewValueObj.%Set("OpenCheckRequest",OCRObj)
   			d NewValueObj.%Set("OpenCheckList",OCLObj)
		}
		///add by ZY0252 20210301
		if (DataChangeReqInfo.DCRTableName="DHC_EQContract")
		{
			i key="CTProviderDR" d NewValueObj.%Set("CTProviderDR_VDesc",##class(web.DHCEQCommon).GetTrakNameByID("prov",value))
			e  i key="CTSignLocDR" d NewValueObj.%Set("CTSignLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",value))
		}
		elseif (DataChangeReqInfo.DCRTableName="DHC_EQContractList")
		{
			//i key="ISLEquipName" d NewValueObj.%Set("ISLEquipName",value)
			i key="CTLModelDR" d NewValueObj.%Set("CTLModelDR_MDesc",##class(web.DHCEQCommon).GetTrakNameByID("model",value))
			e  i key="CTLManuFactoryDR" d NewValueObj.%Set("CTLManuFactoryDR_MFName",##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",value))
		}
    }
    s DCRNewValue=NewValueObj.%ToJSON()
    d DataChangeReqInfo.%Set("DCRNewValue",DCRNewValue)
	q ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,DataChangeReqInfo)
ERRORGetOneDataChangeRequest
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-1300",ErrorMsg)
}

/// modified  by ZY0252 20210301
/// Creator：      CZF
/// CreatDate：    2020-08-19
/// Description:   获取数据变动明细
/// Input：        Status:数据变动单状态 BussNo:业务单号
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.LIBDataChangeRequest","GetDataChangeRequest","","")
Query GetDataChangeRequest(BussType As %String = "", BussNo As %String = "", Status As %String = "") As %Query(ROWSPEC = "TDCRRowID:%String,TTableName:%String,TTableDesc:%String,TBussType:%String,TBussID:%String,TBussNo:%String,TUpdateUser:%String,TUpdateDate:%String,TUpdateTime:%String,TAuditUser:%String,TAuditDate:%String,TAuditTime:%String,TStatus:%String")
{
}

ClassMethod GetDataChangeRequestExecute(ByRef qHandle As %Binary, BussType As %String = "", BussNo As %String = "", Status As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	
	d BuildDataGetDataChangeRequest
	Quit $$$OK
BuildDataGetDataChangeRequest
	s DCRRowID=""
	f  s DCRRowID=$o(^DHCEQDataChangeRequest(DCRRowID))  quit:DCRRowID=""  d
	.d ResetVariablesGetDataChangeRequest
	.s TDCRRowID = DCRRowID
	.s TStatus = $p($g(^DHCEQDataChangeRequest(TDCRRowID)),"^",13)
	.q:(Status'="")&&(Status'=TStatus)
	.s TStatus=$case(TStatus,"0":"新增","1":"提交","2":"审核",:"")
	.s TInvalidFlag = $p($g(^DHCEQDataChangeRequest(TDCRRowID)),"^",14)
	.q:TInvalidFlag'="N"
	.s TTableName = $p($g(^DHCEQDataChangeRequest(TDCRRowID)),"^",1)
	.s TUserName = $p($g(^DHCEQDataChangeRequest(TDCRRowID)),"^",2)
	.s TBussID = $p($g(^DHCEQDataChangeRequest(TDCRRowID)),"^",3)
	.s TUpdateUserDR = $p($g(^DHCEQDataChangeRequest(TDCRRowID)),"^",4)
	.s TUpdateUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	.s TUpdateDate = $p($g(^DHCEQDataChangeRequest(TDCRRowID)),"^",5)
	.s TUpdateDate = ##Class(web.DHCEQCommon).TransValueToPage(TUpdateDate,"date")
	.s TUpdateTime = $p($g(^DHCEQDataChangeRequest(TDCRRowID)),"^",6)
	.s TUpdateTime = ##Class(web.DHCEQCommon).TransValueToPage(TUpdateTime,"time")
	.s TOldValue = $p($g(^DHCEQDataChangeRequest(TDCRRowID)),"^",8)
	.s TNewValue = $p($g(^DHCEQDataChangeRequest(TDCRRowID)),"^",9)
	.s TAuditUserDR = $p($g(^DHCEQDataChangeRequest(TDCRRowID)),"^",10)
	.s TAuditUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user",TAuditUserDR)
	.s TAuditDate = $p($g(^DHCEQDataChangeRequest(TDCRRowID)),"^",11)
	.s TAuditDate = ##Class(web.DHCEQCommon).TransValueToPage(TAuditDate,"date")
	.s TAuditTime = $p($g(^DHCEQDataChangeRequest(TDCRRowID)),"^",12)
	.s TAuditTime = ##Class(web.DHCEQCommon).TransValueToPage(TAuditTime,"time")
	.i TTableName = "DHC_EQInStock" d
	..s TBussNo = $p($g(^DHCEQInStock(TBussID)),"^",14)
	..s TBussType = 21
	..s TTableDesc = "入库单据修改"
	.e  i TTableName = "DHC_EQInStockList" d
	..s InStockID =  $p($g(^DHCEQInStockList(TBussID)),"^",1)
	..s TBussNo = $p($g(^DHCEQInStock(InStockID)),"^",14)
	..s TBussType = 21
	..s TTableDesc = "入库明细修改"
	.e  i TTableName = "DHC_EQOpenCheckRequest" d
	..s TBussNo = $p($g(^DHCEQOpenCheckRequest(TBussID)),"^",37)
	..s TBussType = 11
	..s TTableDesc = "验收单据修改"
	.e  i TTableName = "DHC_EQContract" d
	..s TBussNo = $p($g(^DHCEQContract(TBussID)),"^",2)
	..s TBussType = 94
	..s TTableDesc = "合同主单修改"
	.e  i TTableName = "DHC_EQContractList" d
	..s ContractID =  $p($g(^DHCEQContractList(TBussID)),"^",1)
	..s TBussNo = $p($g(^DHCEQContract(ContractID)),"^",2)
	..s TBussType = 94
	..s TTableDesc = "合同明细修改"
	.q:(BussType'="")&&(BussType'=TBussType)
	.q:(BussNo'="")&&(BussNo'=TBussNo)
	.d OutputRowGetDataChangeRequest
	
	quit
OutputRowGetDataChangeRequest
	s Data=$lb(TDCRRowID,TTableName,TTableDesc,TBussType,TBussID,TBussNo,TUpdateUser,TUpdateDate,TUpdateTime,TAuditUser,TAuditDate,TAuditTime,TStatus)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetDataChangeRequest
	s (TDCRRowID,TStatus,TInvalidFlag,TTableName,TTableDesc,TUserName,TBussType,TBussID,TUpdateUserDR,TUpdateUser,TUpdateDate,TUpdateTime,TOldValue,TNewValue,TAuditUserDR,TAuditUser,TAuditDate,TAuditTime,TBussNo)=""
	quit
}

ClassMethod GetDataChangeRequestFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataChangeRequestExecute ]
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

ClassMethod GetDataChangeRequestClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataChangeRequestExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
