/// 库存管理业务类
Class DHCCL.BLL.StockManager Extends %RegisteredObject
{

/// Creator：      	陈长青
/// CreatDate：    	2018-6-8
/// Description： 	查询库存项分类
/// Table：        	DHCCL_Code.StockCat
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCCL.BLL.StockManager","FindStockCat")
Query FindStockCat() As %SQLQuery(CONTAINID = 1)
{
SELECT *,
	   %External(Type) As TypeDesc
	   From DHCCL_Code.StockCat
}

/// Creator：      	陈长青
/// CreatDate：    	2018-8-25
/// Description： 	查询耗材套餐
/// Table：        	DHCCL_Config.StockSet
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCCL.BLL.StockManager","FindStockSet")
Query FindStockSet(deptId As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT *
	   From DHCCL_Config.StockSet
	   where Dept=:deptId or :deptId is null
}

/// Creator：      	陈长青
/// CreatDate：    	2018-8-25
/// Description： 	查询耗材套餐明细项
/// Table：        	DHCCL_Config.StockSetItem
/// Input:			stockSetId:耗材套餐ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCCL.BLL.StockManager","FindStockSetItem","1")
Query FindStockSetItem(stockSetId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   StockSet,
	   StockSet->Description As StockSetDesc,
	   StockItem->Description As StockItemDesc,
	   StockItem->GeneralDesc As GeneralDesc,
	   StockItem->Spec As StockItemSpec,
	   StockItem->StockCatDr As StockCat,
	   StockItem->StockCatDr->Description As StockCatDesc,
	   StockItem,
	   DefaultQty,
	   Uom,
	   Uom->LocalDesc As UomDesc,
	   %ODBCOUT(ActiveDate) As ActiveDate,
	   %ODBCOUT(ExpireDate) As ExpireDate,
	   SetItemDesc
	   From DHCCL_Config.StockSetItem
	   where StockSet=:stockSetId
}

/// Creator：      	陈长青
/// CreatDate：    	2018-6-8
/// Description： 	查询物品制造商
/// Table：        	DHCCL_Code.Manufacturer
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCCL.BLL.StockManager","FindManufacturer")
Query FindManufacturer() As %SQLQuery(CONTAINID = 1)
{
SELECT *
	   From DHCCL_Code.Manufacturer
}

/// Creator：      	陈长青
/// CreatDate：    	2018-6-8
/// Description： 	查询物品供应商
/// Table：        	DHCCL_Code.Vendor
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCCL.BLL.StockManager","FindVendor")
Query FindVendor() As %SQLQuery(CONTAINID = 1)
{
SELECT *
	   From DHCCL_Code.Vendor
}

/// Creator：      	陈长青
/// CreatDate：    	2018-6-8
/// Description： 	查询单位
/// Table：        	DHCCL_Config.Uom
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCCL.BLL.StockManager","FindUom")
Query FindUom(filterDesc As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT *
	   From DHCCL_Config.Uom
	   where (UPPER(LocalDesc) [ UPPER(:filterDesc))
	   or (UPPER(ForeignDesc) [ UPPER(:filterDesc))
	   or (:filterDesc is null)
}

/// Creator：      	陈长青
/// CreatDate：    	2018-6-8
/// Description： 	查询科室
/// Table：        	DHCCL_Config.Location
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCCL.BLL.StockManager","FindLocation")
Query FindLocation() As %SQLQuery(CONTAINID = 1)
{
SELECT *
	   From DHCCL_Config.Location
}

/// Creator：      	陈长青
/// CreatDate：    	2018-6-8
/// Description： 	查询库存项
/// Table：        	DHCCL_Config.StockItem
/// Input:			filterDesc:筛选字符串，stockCatID:库存项分类ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCCL.BLL.StockManager","FindStockItem","ycxgxwhq")
Query FindStockItem(filterDesc As %String = "", stockCatID As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   Code,
	   Description,
	   StockCatDr,
	   UomDr,
	   ActiveDateTo,
	   OrderItemCode,
	   ManufacturerDr,
	   VendorDr,
	   REPLACE(Spec,'\','/') As Spec,
	   Alias,
	   GeneralDesc,
	   GeneralAlias,
	   ManufacturerDr->Description As Manufacturer,
	   VendorDr->Description As Vendor,
	   UomDr->LocalDesc As UomDesc,
	   StockCatDr->Description As StockCatDesc,
	   ChargeItem,
	   ChargeItem->Description As ChargeItemDesc
	   From DHCCL_Config.StockItem
	   where ((Description [ :filterDesc) or (UPPER(Alias) [ UPPER(:filterDesc)) or (UPPER(GeneralDesc) [ UPPER(:filterDesc)) or (UPPER(GeneralAlias) [ UPPER(:filterDesc)) or (:filterDesc is null))
	   and (StockCatDr=:stockCatID or :stockCatID is null)
}

/// Creator：      	陈长青
/// CreatDate：    	2018-6-8
/// Description： 	查询库存项
/// Table：        	DHCCL_Config.StockItem
/// Input:			filterDesc:筛选字符串，stockCatID:库存项分类ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCCL.BLL.StockManager","FindStockItem","wq")
Query FindStockItemNew(filterDesc As %String, stockCatID As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   Code,
	   Description,
	   StockCatDr,
	   UomDr,
	   ActiveDateTo,
	   OrderItemCode,
	   ManufacturerDr,
	   VendorDr,
	   REPLACE(Spec,'\','/') As Spec,
	   Alias,
	   GeneralDesc,
	   GeneralAlias,
	   ManufacturerDr->Description As Manufacturer,
	   VendorDr->Description As Vendor,
	   UomDr->LocalDesc As UomDesc,
	   StockCatDr->Description As StockCatDesc
	   From DHCCL_Config.StockItem
	   where ((Description [ :filterDesc) or (UPPER(Alias) [ UPPER(:filterDesc)) or (UPPER(GeneralDesc) [ UPPER(:filterDesc)) or (UPPER(GeneralAlias) [ UPPER(:filterDesc)))
	   and (StockCatDr=:stockCatID or :stockCatID is null)
	   and (not GeneralDesc is null)
}

/// Creator：      	陈长青
/// CreatDate：    	2018-6-8
/// Description： 	查询入库信息
/// Table：        	DHCCL_Model.StockTransfer
/// Input:			locID:入库科室ID，startDate:查询的开始日期，endDate:查询的结束日期,stockItemID:库存项ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCCL.BLL.StockManager","FindStockTransfer","29","","2018-06-01","2018-07-06")
Query FindStockTransfer(locID As %String, stockItemID As %String, startDate As %String, endDate As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   StockItemDr,
	   StockItemDr->Code As StockItemCode,
	   REPLACE(StockItemDr->Description,CHAR(0),'') As StockItemDesc,
	   REPLACE(StockItemDr->Spec,'\','/') As StockItemSpec,
	   StockItemDr->ManufacturerDr As ManufacturerDr,
	   REPLACE(StockItemDr->ManufacturerDr->Description,CHAR(0),'') As Manufacturer,
	   StockItemDr->VendorDr As VendorDr,
	   REPLACE(StockItemDr->VendorDr->Description,CHAR(0),'') As Vendor,
	   StockItemDr->StockCatDr As StockCatDr,
	   REPLACE(StockItemDr->StockCatDr->Description,CHAR(0),'') As StockCatDesc,
	   ReceiveLocationDr,
	   DHCCL_BLL.String_GetDescByID("User.CTLoc","CTLOCDesc",ReceiveLocationDr) As LocDesc,
	   ReceiveUserDr,
	   DHCCL_BLL.String_GetDescByID('User.SSUser','SSUSRName',ReceiveUserDr) As FullName,
	   BatchNo,
	   %ODBCOUT(TransferDate) As TransferDate,
	   UomDr,
	   UomDr->LocalDesc As UomDesc,
	   Qty,
	   REPLACE(FlowID,CHAR(0),'') As FlowID,
	   TRIM(RegCert) As RegCert,
	   %ODBCOUT(TransferDate)_" "_%ODBCOUT(TransferTime) As TransferDT,
	   BarCode
	   From DHCCL_Model.StockTransfer
	   where ReceiveLocationDr=:locID
	   and (StockItemDr=:stockItemID or :stockItemID is null)
	   and TransferDate>=%ODBCIN(:startDate)
	   and TransferDate<=%ODBCIN(:endDate)
}

/// Creator：      	陈长青
/// CreatDate：    	2018-6-8
/// Description： 	查询患者手术材料消耗情况
/// Table：        	DHCCL_Model.StockConsume
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCCL.BLL.StockManager","FindLocation")
Query FindStockConsume(recordSheetId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   StockItemDr,
	   StockItemDesc,
	   StockItemDr->ManufacturerDr->Description As Manufacturer,
	   StockItemDr->StockCatDr->Description As StockCatDesc,
	   StockItemDr->Spec As StockItemSpec,
	   StockTransferDr,
	   StockTransferDr->BatchNo As BatchNo,
	   StockTransferDr->RegCert As RegCert,
	   StockTransferDr->ExpiryDate As ExpDate,
	   StockTransferDr->Vendor As Vendor,
	   StockTransferDr->SterilizationNo As SterilizationNo,
	   LocationDr,
	   DHCCL_BLL.String_GetDescByID("User.CTLoc","CTLOCDesc",LocationDr) As LocDesc,
	   UomDr,
	   DHCCL_BLL.String_GetDescByID("DHCCL.Config.Uom","LocalDesc",UomDr) As UomDesc,
	   Qty,
	   Price,
	   Type,
	   %External(Type) As TypeDesc,
	   %ODBCOUT(ConsumeDate)_" "_%ODBCOUT(ConsumeTime) As ConsumeDT,
	   UpdateUser,
	   DHCCL_BLL.String_GetDescByID("User.SSUser","SSUSRName",UpdateUser) As UpdateUserDesc,
	   %ODBCOUT(UpdateDate)_" "_%ODBCOUT(UpdateTime) As UpdateDT,
	   RecordSheet,
	   BarCode
	   From DHCCL_Model.StockConsume
	   where RecordSheet=:recordSheetId
}

/// Creator：      	陈长青
/// CreatDate：    	2018-8-13
/// Description： 	查询库存月结信息
/// Table：        	DHCCL_Model.StockMonth
/// Input:			locID:月结科室ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCCL.BLL.StockManager","FindStockMonth","29")
Query FindStockMonth(locID As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT *,
	   DHCCL_BLL.String_GetDescByID("User.CTLoc","CTLOCDesc",LocationDr) As LocDesc,
	   %ODBCOUT(FromDate)_" "_%ODBCOUT(FromTime) As FromDT,
	   %ODBCOUT(ToDate)_" "_%ODBCOUT(ToTime) As ToDT,
	   %ODBCOUT(FromDate) As FromDateDesc,
	   %ODBCOUT(ToDate) As ToDateDesc,
	   %External(Status) As StatusDesc
	   From DHCCL_Model.StockMonth
	   where LocationDr=:locID
	   order by FromDate desc
}

/// Creator：      	陈长青
/// CreatDate：    	2018-8-13
/// Description： 	查询库存月结明细
/// Table：        	DHCCL_Model.StockMonthItem
/// Input:			monthID:月结项ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCCL.BLL.StockManager","FindStockMonthItem","29")
Query FindStockMonthItem(monthID As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT *,
	   Qty As OriginalQty,
	   Amount As StockInQty,
	   CostAmount As StockOutQty,
	   LastQty As MonthQty,
	   StockItemDr->Description As StockItemDesc,
	   StockItemDr->Spec As StockItemSpec,
	   StockItemDr->ManufacturerDr->Description As Manufacturer,
	   StockItemDr->VendorDr->Description As Vendor,
	   StockItemDr->StockCatDr->Description As StockCatDesc,
	   DHCCL_BLL.String_GetDescByID("User.CTLoc","CTLOCDesc",LocationDr) As LocDesc,
	   DHCCL_BLL.String_GetDescByID("User.SSUser","SSUSRName",UpdateUser) As UpdateUserDesc,
	   %ODBCOUT(UpdateDate)_" "_%ODBCOUT(UpdateTime) As UpdateDT
	   From DHCCL_Model.StockMonthItem
	   where StockMonthDr=:monthID
}

/// Creator：      	陈长青
/// CreatDate：    	2017-2-27
/// Description： 	查询病人诊断信息
/// Table：        	MR_Diagnos,MR_DiagType
/// Input:			EpisodeID:病人就诊ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCCL.BLL.StockManager","FindStockConsumeByConditions","29","2018-11-23","2018-11-25")
Query FindStockConsumeByConditions(locId As %String, startDate As %String, endDate As %String, queryType As %String = "A", medcareNo As %String = "", stockItemId As %String = "") As %Query(ROWSPEC = "ConsumeDate,PatName,MedcareNo,SurgeonDesc,CircualNurseDesc,MaterialCode,MaterialDesc,Spec,UomDesc,ExpireDate,BatchNo,Price,Qty,BarCode") [ SqlProc ]
{
}

ClassMethod FindStockConsumeByConditionsExecute(ByRef qHandle As %Binary, locId As %String, startDate As %String, endDate As %String, queryType As %String = "A", medcareNo As %String = "", stockItemId As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set startDateH=##class(DHCCL.BLL.DateTime).ConvertToDateH(startDate)
	set endDateH=##class(DHCCL.BLL.DateTime).ConvertToDateH(endDate)
	for dateIndex=startDateH:1:endDateH
	{
		set stockConsumeId=0
		for
		{
			set stockConsumeId=$order(^DHCCL.Model.StockConsumeI("LocDate"," "_locId,dateIndex,stockConsumeId))
			quit:(stockConsumeId="")
			set stockConsume=##class(DHCCL.Model.StockConsume).%OpenId(stockConsumeId)
			set curStockItemId=""
			set:(stockConsume.StockItemDr'="") curStockItemId=stockConsume.StockItemDr.%Id()
			continue:(stockItemId'="")&(curStockItemId'=stockItemId)	
			set EpisodeID=stockConsume.RecordSheet.OperSchedule.EpisodeID
			set curMedcareNo=##class(DHCCL.BLL.Admission).GetMedicareNo("",EpisodeID)
			continue:(medcareNo'="")&(curMedcareNo'=medcareNo)
			continue:(queryType="H")&(stockConsume.StockItemDr.IsHighValue'="Y")
			continue:(queryType="L")&((stockConsume.StockItemDr.IsHighValue="Y") ! (+stockConsume.Price<=0))
			continue:(queryType="N")&(+stockConsume.Price>0)
			set consumeDate=##class(DHCCL.BLL.DateTime).ConvertToDate(stockConsume.ConsumeDate)
			set operScheduleQuery=##class(%ResultSet).%New("DHCAN.BLL.OperSchedule:FindOperScheduleList")
			set opsId=stockConsume.RecordSheet.OperSchedule.%Id()
			set sc=operScheduleQuery.Execute("","","",opsId)
			set patName="",surgeonDesc="",circualNurseDesc=""
			while(operScheduleQuery.%Next())
			{
				set patName=operScheduleQuery.Get("PatName")
				set surgeonDesc=operScheduleQuery.Get("SurgeonDesc")
				set circualNurseDesc=operScheduleQuery.Get("CircualNurseDesc")	
			}
			set materialCode=stockConsume.StockItemDr.Code
			set materialDesc=$tr(stockConsume.StockItemDesc,$c(0),"")
			set spec=$tr(stockConsume.StockItemDr.Spec,$c(0),"")
			set uomDesc=##class(DHCCL.BLL.String).GetDescByID("DHCCL.Config.Uom","LocalDesc",stockConsume.UomDr)
			set expireDate=""
			set:(stockConsume.StockTransferDr'="") expireDate=stockConsume.StockTransferDr.ExpiryDate
			//set:(expireDate'="") expireDate=##class(DHCCL.BLL.DateTime).ConvertToDate(stockConsume.StockTransferDr.ExpiryDate,"")
			set batchNo=""
			set:(stockConsume.StockTransferDr'="") batchNo=$tr(stockConsume.StockTransferDr.BatchNo,$c(0),"")
			set price=""
			set:(stockConsume.StockTransferDr'="") price=stockConsume.StockTransferDr.Price
			set:(price="")&(stockConsume.StockItemDr'="")&(stockConsume.StockItemDr.ChargeItem'="") price=stockConsume.StockItemDr.ChargeItem.Price
			set qty=stockConsume.Qty
			set barCode=stockConsume.BarCode
			do OutputRow
			
		}	
	}
	
	s qHandle=$lb(0,repid,0)
	q $$$OK

OutputRow
	s Data=$lb(consumeDate,patName,curMedcareNo,surgeonDesc,circualNurseDesc,materialCode,materialDesc,spec,uomDesc,expireDate,batchNo,price,qty,barCode)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindStockConsumeByConditionsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindStockConsumeByConditionsExecute ]
{
	s AtEnd=$li(qHandle,1)
	s repid=$li(qHandle,2)
	s ind=$li(qHandle,3)
	//
	s ind=$o(^CacheTemp(repid,ind))
	i ind="" {				// if there are no more rows, finish fetching
	s AtEnd=1
	s Row=""
	}
	else      {				// fetch row
	s Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindStockConsumeByConditionsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindStockConsumeByConditionsExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator：      	chenchangqing
/// CreatDate：    	2018年6月8日
/// Description： 	获取制造商ID，如果没有该制造商则新建
/// Table：        	DHCCL_Code.Manufacturer
/// Input：        	MFRCode：制造商代码，MFRDesc：制造商名称
/// Output：       
/// Return：       	制造商ID
ClassMethod GetMFRID(MFRCode As %String, MFRDesc As %String) As %String
{
	quit:(MFRCode="")!(MFRCode=$c(0)) "E^制造商代码不能为空"
	quit:(MFRDesc="")!(MFRDesc=$c(0)) "E^制造商名称不能为空"
	set $zt="Error"
	set MFRCode=$System.SQL.ALPHAUP(MFRCode)
	set MFRID=$order(^DHCCL.Code.ManufacturerI("Code"," "_MFRCode,0))
	if (##class(DHCCL.Code.Manufacturer).%ExistsId(MFRID)=0)
	{
		set MFR=##class(DHCCL.Code.Manufacturer).%New()
		set MFR.Code=MFRCode
		set MFR.Description=MFRDesc
		set sc=MFR.%Save()
		if ($System.Status.IsError(sc))
		{
			set MFRID="E^"_$System.Status.GetErrorText(sc)	
		}	
		else
		{
			set MFRID=MFR.%Id()	
		}
	}
	quit MFRID
Error
	set $zt=""
	quit "E^"_$ze
}

/// Creator：      	chenchangqing
/// CreatDate：    	2018年6月8日
/// Description： 	获取供应商ID，如果没有该供应商则新建
/// Table：        	DHCCL_Code.Vendor
/// Input：        	vendorCode：供应商代码，vendorDesc：供应商名称
/// Output：       
/// Return：       	供应商ID
ClassMethod GetVendorID(vendorCode As %String, vendorDesc As %String) As %String
{
	quit:(vendorCode="")!(vendorCode=$c(0)) "E^供应商代码不能为空"
	quit:(vendorDesc="")!(vendorDesc=$c(0)) "E^供应商名称不能为空"
	set $zt="Error"
	set vendorCode=$System.SQL.ALPHAUP(vendorCode)
	set vendorID=$order(^DHCCL.Code.VendorI("Code"," "_vendorCode,0))
	if (##class(DHCCL.Code.Vendor).%ExistsId(vendorID)=0)
	{
		set vendor=##class(DHCCL.Code.Vendor).%New()
		set vendor.Code=vendorCode
		set vendor.Description=vendorDesc
		set sc=vendor.%Save()
		if ($System.Status.IsError(sc))
		{
			set vendorID="E^"_$System.Status.GetErrorText(sc)	
		}	
		else
		{
			set vendorID=vendor.%Id()	
		}
	}
	quit vendorID
Error
	set $zt=""
	quit "E^"_$ze
}

/// Creator：      	chenchangqing
/// CreatDate：    	2018年6月8日
/// Description： 	获取单位ID，如果没有该单位则新建
/// Table：        	DHCCL_Config.Uom
/// Input：        	uomCode：单位代码，uomDesc：单位名称
/// Output：       
/// Return：       	单位ID
ClassMethod GetUomID(uomCode As %String, uomDesc As %String) As %String
{
	quit:(uomCode="")!(uomCode=$c(0)) "E^单位代码不能为空"
	quit:(uomDesc="")!(uomDesc=$c(0)) "E^单位名称不能为空"
	set $zt="Error"
	
	set uomCode=$System.SQL.ALPHAUP(uomCode)
	set uomID=$order(^DHCCL.Config.UomI("Code",uomCode,0))
	if (##class(DHCCL.Config.Uom).%ExistsId(uomID)=0)
	{
		set uom=##class(DHCCL.Config.Uom).%New()
		set uom.Code=uomCode
		set uom.LocalDesc=uomDesc
		set uom.ForeignDesc=uomDesc
		set sc=uom.%Save()
		if ($System.Status.IsError(sc))
		{
			set uomID="E^"_$System.Status.GetErrorText(sc)	
		}	
		else
		{
			set uomID=uom.%Id()	
		}
	}
	quit uomID
Error
	set $zt=""
	quit "E^"_$ze
}

/// Creator：      	chenchangqing
/// CreatDate：    	2018年6月8日
/// Description： 	获取库存分类ID，如果没有该库存分类则新建
/// Table：        	DHCCL_Code.StockCat
/// Input：        	catCode：库存分类代码，catDesc：库存分类名称，catType：库存分类类型
/// Output：       
/// Return：       	库存分类ID
ClassMethod GetStockCatID(catCode As %String, catDesc As %String, catType As %String) As %String
{
	set $zt="Error"
	quit:(catCode="")!(catCode=$c(0)) "E^库存分类的代码不能为空。"
	quit:(catDesc="")!(catDesc=$c(0)) "E^库存分类的名称不能为空。"
	set catCode=$System.SQL.ALPHAUP(catCode)
	set catID=$order(^DHCCL.Code.StockCatI("Code"," "_catCode,0))
	if (##class(DHCCL.Code.StockCat).%ExistsId(catID)=0)
	{
		set cat=##class(DHCCL.Code.StockCat).%New()
		set cat.Code=catCode
		set cat.Description=catDesc
		set cat.Type=catType
		set sc=cat.%Save()
		if ($System.Status.IsError(sc))
		{
			set catID="E^"_$System.Status.GetErrorText(sc)	
		}	
		else
		{
			set catID=cat.%Id()	
		}
	}
	quit catID
Error
	set $zt=""
	quit "E^"_$ze
}

/// Creator：      	chenchangqing
/// CreatDate：    	2018年6月8日
/// Description： 	获取科室ID，如果没有该科室则新建
/// Table：        	DHCCL_Config.Location
/// Input：        	locCode：科室代码，locDesc：科室名称
/// Output：       
/// Return：        科室ID
ClassMethod GetLocID(locCode As %String, locDesc As %String) As %String
{
	quit:(locCode="")!(locCode=$c(0)) "E^科室代码不能为空。"
	quit:(locDesc="")!(locDesc=$c(0)) "E^科室名称不能为空。"
	set $zt="Error"
	set locCode=$System.SQL.ALPHAUP(locCode)
	set locID=$order(^DHCCL.Config.LocationI("Code"," "_locCode,0))
	if (##class(DHCCL.Config.Location).%ExistsId(locID)=0)
	{
		set loc=##class(DHCCL.Config.Location).%New()
		set loc.Code=locCode
		set loc.Description=locDesc
		set sc=loc.%Save()
		if ($System.Status.IsError(sc))
		{
			set locID="E^"_$System.Status.GetErrorText(sc)	
		}	
		else
		{
			set locID=loc.%Id()	
		}
	}
	quit locID
Error
	set $zt=""
	quit "E^"_$ze
}

/// Creator：      	chenchangqing
/// CreatDate：    	2018年6月8日
/// Description： 	保存库存项
/// Table：        	DHCCL_Config.StockItem
/// Input：        	para:库存项数据
/// Output：       
/// Return：        保存成功返回"S^ID"，保存失败返回"E^错误原因"
ClassMethod SaveStockItem(para As %String) As %String
{
	set $zt="Error"
	set sc=##class(DHCCL.BLL.String).ToArray(para,.array)
	m stockItemData=array(0)
	tstart
	if (##class(DHCCL.Code.Manufacturer).%ExistsId(stockItemData("ManufacturerDr"))=0)
	{
		set MFRID=..GetMFRID(stockItemData("MFRCode"),stockItemData("MFRDesc"))
		if (##class(DHCCL.Code.Manufacturer).%ExistsId(MFRID)=0)	
		{
			trollback
			quit MFRID	
		}
		set stockItemData("ManufacturerDr")=MFRID
	}
	if (##class(DHCCL.Code.Vendor).%ExistsId(stockItemData("VendorDr"))=0)
	{
		set vendorID=..GetMFRID(stockItemData("VendorCode"),stockItemData("VendorDesc"))
		if (##class(DHCCL.Code.Vendor).%ExistsId(vendorID)=0)
		{
			trollback
			quit vendorID	
		}	
		set stockItemData("VendorDr")=vendorID
	}
	set ret=##class(DHCCL.BLL.DataService).SaveData(.stockItemData)
	if (##class(DHCCL.Config.StockItem).%ExistsId(ret)=0)
	{
		trollback
		quit ret	
	}
	tcommit
	quit ret
Error	
	set $zt=""
	quit "E^"_$ze
}

/// Creator：      	chenchangqing
/// CreatDate：    	2018年6月8日
/// Description： 	获取库存项ID，如果没有该库存项则新建
/// Table：        	DHCCL_Config.StockItem
/// Input：        	para:库存项数据
/// Output：       
/// Return：       	库存项ID
ClassMethod GetStockItemID(para As %String) As %String
{
	set $zt="Error"
	set splitChar=$c(1)
	set itemCode=$P(para,splitChar,1)		// 物品代码	
	set itemDesc=$P(para,splitChar,2)		// 物品名称
	set itemSpec=$P(para,splitChar,3)		// 物品规格
	set MFRID=$P(para,splitChar,4)			// 物品制造商
	set vendorID=$P(para,splitChar,5)		// 物品供应商
	set uomID=$P(para,splitChar,6)			// 单位代码
	set catID=$P(para,splitChar,7)			// 物品分类代码
	set alias=$P(para,splitChar,8)			// 助记码
	
	set itemCode=$System.SQL.ALPHAUP(itemCode)
	set stockItemID=$order(^DHCCL.Config.StockItemI("Code"," "_itemCode,0))
	if (##class(DHCCL.Config.StockItem).%ExistsId(stockItemID)=0)
	{
		set stockItem=##class(DHCCL.Config.StockItem).%New()
		set stockItem.Code=itemCode
		set stockItem.Description=itemDesc
		set stockItem.Spec=itemSpec
		if (##class(DHCCL.Code.Manufacturer).%ExistsId(MFRID)=1)
		{
			set stockItem.ManufacturerDr=##class(DHCCL.Code.Manufacturer).%OpenId(MFRID)	
		}
		if (##class(DHCCL.Code.Vendor).%ExistsId(vendorID))
		{
			set stockItem.VendorDr=##class(DHCCL.Code.Vendor).%OpenId(vendorID)	
		}
		if (##class(DHCCL.Config.Uom).%ExistsId(uomID))
		{
			set stockItem.UomDr=##class(DHCCL.Config.Uom).%OpenId(uomID)
		}
		if (##class(DHCCL.Code.StockCat).%ExistsId(catID))
		{
			set stockItem.StockCatDr=##class(DHCCL.Code.StockCat).%OpenId(catID)
		}
		
		set stockItem.Alias=alias
		set sc=stockItem.%Save()
		if ($System.Status.IsError(sc))
		{
			set stockItemID="E^"_$System.Status.GetErrorText(sc)	
		}	
		else
		{
			set stockItemID=stockItem.%Id()	
		}
	}
	quit stockItemID
Error
	set $zt=""
	quit "E^"_$ze
}

/// Creator：      	chenchangqing
/// CreatDate：    	2018年6月8日
/// Description： 	保存耗材入库信息
/// Table：        	DHCCL_Model.StockTransfer
/// Input：        	para:入库信息
/// Output：       
/// Return：       	保存成功返回入库信息ID，保存失败返回原因
ClassMethod SaveStockTransfer(para As %String) As %String
{
	set $zt="Error"
	set para=$tr(para,$c(0),"")
	set splitChar=$c(1)
	set flowID=$P(para,splitChar,1)			// 请领ID
	set itemCode=$P(para,splitChar,2)		// 物品代码	
	set itemDesc=$P(para,splitChar,3)		// 物品名称
	set itemSpec=$P(para,splitChar,4)		// 物品规格
	set MFRCode=$P(para,splitChar,5)		// 物品制造商
	set vendorCode=$P(para,splitChar,6)		// 物品供应商
	set batchNo=$P(para,splitChar,7)		// 物品批号
	set recvQty=$P(para,splitChar,8)		// 领取数量
	set uomCode=$P(para,splitChar,9)		// 单位代码
	set uomDesc=$P(para,splitChar,10)		// 单位名称
	set itemPrice=$P(para,splitChar,11)		// 物品单价
	set recvDT=$P(para,splitChar,12)		// 领取日期时间
	set locCode=$P(para,splitChar,13)		// 领取科室代码
	set locDesc=$P(para,splitChar,14)		// 领取科室名称
	set regCert=$P(para,splitChar,15)		// 高值耗材注册证号
	set catCode=$P(para,splitChar,16)		// 物品分类代码
	set catDesc=$P(para,splitChar,17)		// 物品分类名称
	set barCode=$p(para,splitChar,18)		// 高值耗材条码
	set alias=$p(para,splitChar,19)			// 助记码
	set expDate=$p(para,splitChar,20)		// 失效期
	set sterilizationNo=$p(para,splitChar,21)  // 灭菌批号
	
	set stockTransferID=$order(^DHCCL.Model.StockTransferI("Flow"," "_flowID,0))
	set stockTransfer=""
	//quit:(##class(DHCCL.Model.StockTransfer).%ExistsId(stockTransferID)=0) "E^高值耗材领取记录已存在！"
	
	set MFRID=""
	if (MFRCode'="")&(MFRCode'=$c(0))
	{
		set MFRID=..GetMFRID(MFRCode,MFRCode)	
	}
	set vendorID=""
	if (vendorCode'="")&(MFRCode'=$c(0))
	{
		set vendorID=..GetVendorID(vendorCode,vendorCode)	
	}
	
	set uomID=..GetUomID(uomCode,uomDesc)
	set locID=$order(^DHCCL.Config.LocationI("Code"," "_locCode,0))
	set catID=..GetStockCatID(catCode,catDesc,"")
	set stockItemPara=itemCode_splitChar_itemDesc_splitChar_itemSpec_splitChar_MFRID_splitChar_vendorID_splitChar_uomID_splitChar_catID_splitChar_alias
	set stockItemID=..GetStockItemID(stockItemPara)
	
	
	if (##class(DHCCL.Model.StockTransfer).%ExistsId(stockTransferID)=0)
	{
		set stockTransfer=##class(DHCCL.Model.StockTransfer).%New()
	}
	else
	{
		set stockTransfer=##class(DHCCL.Model.StockTransfer).%OpenId(stockTransferID)
	}
	do stockTransfer.StockItemDrSetObjectId(stockItemID)
	set stockTransfer.ReceiveLocationDr=locID
	set stockTransfer.BatchNo=batchNo
	set stockTransfer.TransferDate=##class(DHCCL.BLL.DateTime).ConvertToDateH($p(recvDT," ",1))
	set stockTransfer.TransferTime=##class(DHCCL.BLL.DateTime).ConvertToTimeH($p(recvDT," ",2))
	do stockTransfer.UomDrSetObjectId(uomID)
	set stockTransfer.Qty=+recvQty
	set stockTransfer.Price=+itemPrice
	set stockTransfer.RegCert=regCert
	set stockTransfer.FlowID=flowID
	set stockTransfer.BarCode=barCode
	set stockTransfer.ExpiryDate=expDate
	set stockTransfer.RespCode=catCode
	set stockTransfer.RespDesc=catDesc
	set stockTransfer.SterilizationNo=sterilizationNo
	set stockTransfer.Manufacturer=MFRCode
	set stockTransfer.Vendor=vendorCode
	set sc=stockTransfer.%Save()
	
	if ($System.Status.IsError(sc))
	{
		quit "E^"_$System.Status.GetErrorText(sc)	
	}
	set stockTransferID=stockTransfer.%Id()
	quit stockTransferID
Error
	set $zt=""
	quit "E^"_$ze
}

/// Creator：      	chenchangqing
/// CreatDate：    	2018年6月16日
/// Description： 	保存材料消耗记录
/// Table：        	DHCCL_Model.StockConsume
/// Input：        	para:消耗记录数据
/// Output：       
/// Return：        保存成功返回"S^ID"，保存失败返回"E^错误原因"
ClassMethod SaveStockConsume(para As %String) As %String
{
	set $zt="Error"
	set sc=##class(DHCCL.BLL.String).ToArray(para,.array)
	m stockConsume=array(0)
	if (##class(DHCCL.Model.StockConsume).%ExistsId(stockConsume("RowId"))=0)
	{
		set stockConsume("ConsumeDate")=+$h
		set stockConsume("ConsumeTime")=$p($h,",",2)	
	}
	set ret=##class(DHCCL.BLL.DataService).SaveData(.stockConsume)
	quit ret
Error	
	set $zt=""
	quit "E^"_$ze
}

/// Creator：      	陈长青
/// CreatDate：    	2018-8-21
/// Description： 	查询库存项月结信息
/// Table：        	DHCCL_Model.StockMonth,DHCCL_Model.StockMonthItem,DHCCL_Config.StockItem,DHCCL_Model.StockTransfer
/// Input:			locId:科室ID，startDate:开始日期，endDate:结束日期
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCCL.BLL.StockManager","FindStockSum","29","2018-08-16","2018-09-15")
Query FindStockSum(stockMonthId As %String, startDate As %String, endDate As %String, deptId As %String) As %Query(ROWSPEC = "StockMonthItemId,LocId,StockItemId,StockItemDesc,Spec,OriginalQty,StockInQty,StockOutQty,MonthQty,StockMonthId,ChargeItem") [ SqlProc ]
{
}

ClassMethod FindStockSumExecute(ByRef qHandle As %Binary, stockMonthId As %String, startDate As %String, endDate As %String, deptId As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	if (##class(DHCCL.Model.StockMonth).%ExistsId(stockMonthId)=0)
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK		
	}
	set stockMonth=##class(DHCCL.Model.StockMonth).%OpenId(stockMonthId)
	set locId=stockMonth.LocationDr
	
	set stockMonthItemQuery=##class(%ResultSet).%New("DHCCL.BLL.StockManager:FindStockMonthItem")
	set sc=stockMonthItemQuery.Execute(stockMonthId)
	set monthItemCount=0
	while(stockMonthItemQuery.%Next())
	{
		set monthItemCount=monthItemCount+1	
		set stockMonthItemId=stockMonthItemQuery.Get("RowId")
		set stockItemDesc=stockMonthItemQuery.Get("StockItemDesc")
		set stockItemId=stockMonthItemQuery.Get("StockItemDr")
		set spec=stockMonthItemQuery.Get("StockItemSpec")
		set spec=$tr(spec,"\","/")
		set originalQty=stockMonthItemQuery.Get("OriginalQty")
		set stockInQty=stockMonthItemQuery.Get("StockInQty")
		set stockOutQty=stockMonthItemQuery.Get("StockOutQty")
		set monthQty=stockMonthItemQuery.Get("MonthQty")
		do OutputRow
	}
	
	// 月结明细表已有该月数据，那么退出。
	if (monthItemCount>0)
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK	
	}
	
	// 循环遍历获取库存项
	//set stockItemQuery=##class(%ResultSet).%New("DHCCL.BLL.StockManager:FindStockItem")
	//set sc=stockItemQuery.Execute("","")
	//while(stockItemQuery.%Next())
	//{
	//	set stockMonthItemId=""
	//	set stockItemDesc=stockItemQuery.Get("Description")
	//	set stockItemId=stockItemQuery.Get("RowId")
	//	set spec=stockItemQuery.Get("Spec")
	//	set spec=$tr(spec,"\","/")
	//	// 计算库存项的入库数量
	//	set stockInQty=..GetStockInQty(stockItemId,locId,startDate,endDate)
	//	// 计算库存项的出库数量
	//	set stockOutQty=..GetStockOutQty(stockItemId,locId,startDate,endDate)
	//	// 获取库存项的上次月结数量
	//	set originalQty=0
	//	if (##class(DHCCL.Model.StockMonth).%ExistsId(stockMonthId))
	//	{
	//		set originalQty=..GetStockMonthQty(stockItemId,locId,stockMonthId)	
	//	}
	//	// 月底数量
	//	set monthQty=(originalQty+stockInQty)-stockOutQty
	//	if (originalQty'=0)!(stockInQty'=0)!(monthQty'=0)
	//	{
	//		do OutputRow	
	//	}
	//}
	
	set chargeItemQuery=##class(%ResultSet).%New("DHCAN.BLL.ChargeStatistic:MaterialStatistic")
	set sc=chargeItemQuery.Execute(startDate,endDate,deptId)
	while(chargeItemQuery.%Next())
	{
		set stockMonthItemId=""
		set stockItemDesc=chargeItemQuery.Get("Description")
		set stockItemId=""
		set chargeItem=chargeItemQuery.Get("RowId")
		set spec=chargeItemQuery.Get("Spec")
		set spec=$tr(spec,"\","/")
		// 计算库存项的入库数量
		set stockInQty=0
		// 计算库存项的出库数量
		set stockOutQty=chargeItemQuery.Get("Qty")
		// 获取库存项的上次月结数量
		set originalQty=0
		// 月底数量
		set monthQty=0
		
		do OutputRow
	}
	
	s qHandle=$lb(0,repid,0)
	q $$$OK

OutputRow
	s Data=$lb(stockMonthItemId,locId,stockItemId,stockItemDesc,spec,originalQty,stockInQty,stockOutQty,monthQty,stockMonthId,chargeItem)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindStockSumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindStockSumExecute ]
{
	s AtEnd=$li(qHandle,1)
	s repid=$li(qHandle,2)
	s ind=$li(qHandle,3)
	//
	s ind=$o(^CacheTemp(repid,ind))
	i ind="" {				// if there are no more rows, finish fetching
	s AtEnd=1
	s Row=""
	}
	else      {				// fetch row
	s Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindStockSumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindStockSumExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

ClassMethod GetStockInQty(stockItemId As %String, locId As %String, startDate As %String, endDate As %String) As %String
{
	set rset=##class(%ResultSet).%New("DHCCL.BLL.StockManager:FindStockTransfer")
	set sc=rset.Execute(locId,stockItemId,startDate,endDate)
	set totalQty=0
	while(rset.%Next())
	{
		set qty=+rset.Get("Qty")
		set totalQty=totalQty+qty	
	}
	
	quit totalQty
}

ClassMethod GetStockOutQty(stockItemId As %String, locId As %String, startDate As %String, endDate As %String) As %String
{
	set rset=##class(%ResultSet).%New("DHCCL.BLL.StockManager:FindStockConsumeByConditions")
	set sc=rset.Execute(locId,startDate,endDate,"A","",stockItemId)
	set totalQty=0
	while(rset.%Next())
	{
		set qty=+rset.Get("Qty")
		set totalQty=totalQty+qty	
	}
	
	quit totalQty
}

ClassMethod GetStockMonthQty(stockItemId As %String, locId As %String, stockMonthId As %String) As %String
{
	set monthItemId=$order(^DHCCL.Model.StockMonthItemI("MonthLocItem",stockMonthId," "_locId,stockItemId,0))
	set monthQty=0
	if (##class(DHCCL.Model.StockMonthItem).%ExistsId(monthItemId))
	{
		set monthItem=##class(DHCCL.Model.StockMonthItem).%OpenId(monthItemId)
		set monthQty=+monthItem.LastQty	
	}
	quit monthQty
}

/// Creator：      	chenchangqing
/// CreatDate：    	2018年9月13日
/// Description： 	保存库存月结记录
/// Table：        	DHCCL_Model.StockMonth
/// Input：        	para:月结记录数据
/// Output：       
/// Return：        保存成功返回"S^ID"，保存失败返回"E^错误原因"
ClassMethod SaveStockMonth(dataPara As %String) As %String
{
	set $zt="Error"
	set sc=##class(DHCCL.BLL.String).ToArray(dataPara,.array)
	tstart
	
	set dataIndex=0,saveResult=""
	for
	{
		set dataIndex=$order(array(dataIndex))
		quit:(dataIndex="")
		m stockMonth=array(dataIndex)
		// 判断月结开始日期是否在已月结日期的范围内
		set dateBalanced=..IsDateBalanced(stockMonth("LocationDr"),stockMonth("FromDate"))
		if (dateBalanced=1)
		{
			set saveResult="E^开始日期包含已月结的日期范围内。"	
		}
		quit:(dateBalanced=1)
		set stockMonthID=stockMonth("RowId")
		if (##class(DHCCL.Model.StockMonth).%ExistsId(stockMonthID)=0)
		{
			set stockMonth("CreatedDate")=$p($h,",",1)
			set stockMonth("CreatedTime")=$p($h,",",2)	
		}
		set saveResult=##class(DHCCL.BLL.DataService).SaveData(.stockMonth)
		quit:($piece(saveResult,"^",1)'="S")
	}
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	
	tcommit
	quit "S^"
Error
	trollback
	set $zt=""
	quit "E^"_$ze
}

/// Creator：      	yongyang
/// CreatDate：    	2019年5月17日
/// Description： 	删除库存月结记录
/// Table：        	DHCCL_Model.StockMonth
/// Input：        	rowId,userId
/// Output：       
/// Return：        保存成功返回"S^"，保存失败返回"E^错误原因"
ClassMethod RemoveStockMonth(rowId, userId = "") As %String
{
	quit:'##class(DHCCL.Model.StockMonth).%ExistsId(rowId) "E^ID错误"
	
	set status=##class(DHCCL.Model.StockMonth).%DeleteId(rowId)
	if $$$ISERR(status) quit "E^删除时错误"
	
	quit "S^"
}

ClassMethod IsDateBalanced(locId As %String, balanceDate As %String) As %Boolean
{
	set stockMonthId=0,fromDate=0,result=0
	set balanceDateH=##class(DHCCL.BLL.DateTime).ConvertToDateH(balanceDate)
	for
	{
		set fromDate=$order(^DHCCL.Model.StockMonthI("LocDate"," "_locId,fromDate))
		quit:(fromDate="")
		set stockMonthId=$order(^DHCCL.Model.StockMonthI("LocDate"," "_locId,fromDate,0))
		set stockMonth=##class(DHCCL.Model.StockMonth).%OpenId(stockMonthId)
		if (fromDate<=balanceDateH)&(stockMonth.ToDate>=balanceDateH)	
		{
			set result=1	
		}
	}	
	quit result
}

ClassMethod AddHVMConsume(barCode As %String, recordSheetID As %String, deptID As %String, userID As %String) As %String
{
	set $zt="Error"
	set stockConsumeID=$order(^DHCCL.Model.StockConsumeI("BarCode"," "_barCode,0))
	quit:(##class(DHCCL.Model.StockConsume).%ExistsId(stockConsumeID)) "E^条码对应的高值耗材已收费。"
	;set chargeRecordDetailId=$order(^DHCAN.Model.ChargeRecordDetailI("BarCode"," "_barCode,0))
	;quit:(##class(DHCAN.Model.ChargeRecordDetail).%ExistsId(chargeRecordDetailId)) "E^条码对应的高值耗材已收费。"
	set stockTransferID=$order(^DHCCL.Model.StockTransferI("BarCode"," "_barCode,0))
	set stockTransfer=##class(DHCCL.Model.StockTransfer).%OpenId(stockTransferID)
	set stockItem=stockTransfer.StockItemDr
	tstart
	set stockConsume=##class(DHCCL.Model.StockConsume).%New()
	set stockConsume.RecordSheet=##class(DHCAN.Model.RecordSheet).%OpenId(recordSheetID)
	set stockConsume.StockItemDr=stockItem
	set stockConsume.StockTransferDr=stockTransfer
	set stockConsume.StockItemDesc=stockItem.Description
	set stockConsume.Price=stockTransfer.Price
	set stockConsume.Qty=stockTransfer.Qty
	set stockConsume.LocationDr=deptID
	set stockConsume.BarCode=barCode
	set stockConsume.ConsumeDate=+$h
	set stockConsume.ConsumeTime=$p($h,",",2)
	set stockConsume.Type="N"
	set uomID=""
	set:(stockTransfer.UomDr'="") uomID=stockTransfer.UomDr.%Id()
	set stockConsume.UomDr=uomID
	set stockConsume.UpdateUser=userID
	set stockConsume.UpdateDate=+$h
	set stockConsume.UpdateTime=$p($h,",",2)
	set sc=stockConsume.%Save()
	if ($System.Status.IsError(sc))
	{
		trollback
		quit "E^"_$System.Status.GetErrorText(sc)	
	}
	set stockConsumeID=stockConsume.%Id()
	set chargeRecordDetail=##class(DHCAN.Model.ChargeRecordDetail).%New()
	set recordSheet=##class(DHCAN.Model.RecordSheet).%OpenId(recordSheetID)
	set chargeRecordID=##class(DHCAN.BLL.ChargeRecord).GetChargeRecord(recordSheet.OperSchedule.%Id(),userID)
	set chargeRecordDetail.ChargeRecord=##class(DHCAN.Model.ChargeRecord).%OpenId(chargeRecordID)
	set chargeRecordDetail.BillDept=deptID
	set chargeRecordDetail.UserDept=deptID
	set chargeRecordDetail.ExecDept=deptID
	set chargeRecordDetail.ChargeDate=+$h
	set chargeRecordDetail.ChargeTime=$p($h,",",2)
	set chargeRecordDetail.ChargeUser=userID
	set chargeRecordDetail.CreateDate=+$h
	set chargeRecordDetail.CreateTime=$p($h,",",2)
	set chargeRecordDetail.CreateUser=userID
	set chargeRecordDetail.Price=stockTransfer.Price
	set chargeRecordDetail.Qty=stockTransfer.Qty
	set chargeRecordDetail.Status="N"
	set chargeRecordDetail.StockConsume=stockConsume
	set chargeRecordDetail.Unit=stockTransfer.UomDr
	set chargeRecordDetail.UpdateUser=userID
	set chargeRecordDetail.UpdateDate=+$h
	set chargeRecordDetail.UpdateTime=$p($h,",",2)
	set chargeRecordDetail.ChargeItemDesc=stockItem.Description
	set chargeRecordDetail.BarCode=barCode
	set sc=chargeRecordDetail.%Save()
	if ($System.Status.IsError(sc))
	{
		trollback
		quit "E^"_$System.Status.GetErrorText(sc)	
	}
	tcommit
	quit "S^"
Error
	trollback
	quit "E^"_$ze
}

ClassMethod GetMatCertImage(recordSheetId As %String) As %String
{
	quit:(##class(DHCAN.Model.RecordSheet).%ExistsId(recordSheetId)=0) "E^不存在ID为"_recordSheetId_"的手术麻醉记录表单。"
	set packId=0
	set len=1000
	w "S^"
	for
	{
		set packId=$order(^DHCCL.Model.StockConsumeI("RecordSheet",recordSheetId,packId))
		quit:(packId="")
		set pack=##class(DHCCL.Model.StockConsume).%OpenId(packId)
		continue:(pack.CertImage="")
		do pack.CertImage.Rewind()
		while(pack.CertImage.AtEnd=0)
		{
			set imageStr=pack.CertImage.Read(.len)	
			continue:(imageStr="")
			w imageStr	
		}
		w "&&&"
	}	
	quit ""
}

}
