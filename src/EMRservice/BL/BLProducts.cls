/// Desc: 		产品模块基础字典表Bl层 
/// Creator:	Donglulu
/// CreatDate:	2019-06-21
Class EMRservice.BL.BLProducts Extends (%RegisteredObject, %XML.Adaptor)
{

/// Debug: d ##Class(EMRservice.BL.BLProducts).Init()
ClassMethod Init() As %String
{
	//操作规则
	d ##class(EMRmeta.Products).%BuildIndices()
	
	s productCode = "EMR"
	s productName = "电子病历"
	d ..InsertRule(productCode, productName)
	
	s productCode = "DHCEPRFS"
	s productName = "归档"
	d ..InsertRule(productCode, productName)
	
	s productCode = "CRITICAL"
	s productName = "危急值"
	d ..InsertRule(productCode, productName)
	
	s productCode = "CONSULTATION"
	s productName = "会诊"
	d ..InsertRule(productCode, productName)
	
	s productCode = "ONESTEPPRINT"
	s productName = "一键打印"
	d ..InsertRule(productCode, productName)
	
	s productCode = "CENTRALIZEDPRINT"
	s productName = "集中打印"
	d ..InsertRule(productCode, productName)
	
	s productCode = "OPERATION"
	s productName = "手术"
	d ..InsertRule(productCode, productName)
	
	s productCode = "BLOODTRANS"
	s productName = "输血"
	d ..InsertRule(productCode, productName)
	
	s productCode = "HEMODIALYSIS"
	s productName = "血透"
	d ..InsertRule(productCode, productName)
	
	s productCode = "Oeord"
	s productName = "门诊输液"
	d ..InsertRule(productCode, productName)
	
	s productCode = "PacsOeord"
	s productName = "检查医嘱"
	d ..InsertRule(productCode, productName)
	
	s productCode = "LisOeord"
	s productName = "检验医嘱"
	d ..InsertRule(productCode, productName)
	
	s productCode = "Quality"
	s productName = "质控"
	d ..InsertRule(productCode, productName)
	
	s productCode = "QualityDepartment"
	s productName = "科室终末质控"
	d ..InsertRule(productCode, productName)
	
	s productCode = "QualityHospital"
	s productName = "院级终末质控"
	d ..InsertRule(productCode, productName)
	
	s productCode = "Auto"
	s productName = "系统自动"
	d ..InsertRule(productCode, productName)
	
	s productCode = "MDTConsult"
	s productName = "MDT会诊"
	d ..InsertRule(productCode, productName)
	
	s productCode = "OPAudit"
	s productName = "门诊诊断证明书"
	d ..InsertRule(productCode, productName)
}

/// Debug: d ##Class(EMRservice.BL.BLProducts).InsertRule("","")
ClassMethod InsertRule(AProductCode As %String, AProductName As %String) As %String
{
	s id=$O(^DHCEMRM.ProductsI("IdxProductCode"," "_$zcvt(AProductCode,"U"),""))
	if ( id = "")
	{
		s obj = ##Class(EMRmeta.Products).%New()
	}
	else
	{
		s obj = ##Class(EMRmeta.Products).%OpenId(id)
	}
	
	s obj.ProductCode = AProductCode
	s obj.ProductName = AProductName
	d obj.%Save()
}

/// 获取所有数据
/// Debug:	d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLProducts","SelectAll")
Query SelectAll() As %Query(ROWSPEC = "ID:%Integer,ProductCode:%String,ProductName:%String")
{
}

ClassMethod SelectAllExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)

	s rowID = ""
	for {
		s rowID = $o(^DHCEMRM.ProductsD(rowID))
		q:(rowID = "")
		s objProducts = ##Class(EMRmeta.Products).%OpenId(rowID)
		continue:(objProducts = "")
	
		s ProductCode = objProducts.ProductCode
		s ProductName = objProducts.ProductName
	
		s Data = $lb(rowID,ProductCode,ProductName)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1	
		
	}
	
	q $$$OK
}

ClassMethod SelectAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectAllExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod SelectAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectAllExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 更新
ClassMethod UpdateData(aProducts As EMRservice.entity.EProducts) As %String [ WebMethod ]
{
	set objProducts = ##class(EMRmeta.Products).%OpenId(aProducts.ID)
	q:(objProducts="") "0"
	set objProducts.ProductCode = aProducts.ProductCode
	set objProducts.ProductName = aProducts.ProductName
	s status = objProducts.%Save()
	q:('$$$ISOK(status)) "0"	
	q "1"
}

/// 增加
ClassMethod AddData(aProducts As EMRservice.entity.EProducts) As %String [ WebMethod ]
{
	set objProducts = ##class(EMRmeta.Products).%New()
	set objProducts.ProductCode = aProducts.ProductCode
	set objProducts.ProductName = aProducts.ProductName
	s status = objProducts.%Save()
	q:('$$$ISOK(status)) "0"	
	q "1"
}

/// 删除
ClassMethod DeleteData(rowID As %String) As %String [ WebMethod ]
{
	set objProducts = ##class(EMRmeta.Products).%OpenId(rowID)
	q:(objProducts="") "0"
	s status = objProducts.%DeleteId(rowID)
	q:('$$$ISOK(status)) "0"	
	q "1"
}

}
