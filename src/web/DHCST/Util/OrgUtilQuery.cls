Import sqluser

/// creator:    yunhaibao
/// createdate: 2017-06-27
/// description:与web.DHCST.Util.DrugUtil对应,建立相应query,仅返回数据集
/// others:		ext\easyui等需要的数据格式有所区别
Class web.DHCST.Util.OrgUtilQuery Extends %RegisteredObject
{

/// deccription:厂商
/// table:      User.ARCBillGrp
/// d ##class(%ResultSet).RunQuery("web.DHCST.Util.OrgUtilQuery","GetPhManufacturer","hbjj")
Query GetPhManufacturer(PHMNFName = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetPhManufacturerExecute(ByRef qHandle As %Binary, PHMNFName = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s PHMNFName=$$ALPHAUP^SSUTIL4(PHMNFName)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "select a.PHMNF_RowId as RowId,a.PHMNF_Name as Description from ph_manufacturer a left join DHC_Manf_AddionInfo b "_
    "on a.phMnf_rowid=b.MANF_PhcManf_DR where b.MANF_Type="_"'G'"_" and b.MANF_Active='Y' ORDER BY PHMNF_RowId"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        s Description = result.Data("Description")
	    s DescPY=##class(web.DHCST.Common.AppCommon).GetCNCODE(Description)
	    continue:(PHMNFName'="")&&(DescPY'[PHMNFName)&&(Description'[PHMNFName)
        continue:Description=""
        d outputRow
    }
    d result.Close()
	Quit $$$OK
outputRow  
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:供应商
/// table:      User.APCVendor
/// d ##class(%ResultSet).RunQuery("web.DHCST.Util.OrgUtilQuery","GetAPCVendor","bj")
Query GetAPCVendor(filterDesc = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetAPCVendorExecute(ByRef qHandle As %Binary, filterDesc = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s filterDesc=$$ALPHAUP^SSUTIL4(filterDesc)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT APCVM_ROWID AS RowId, APCVM_NAME AS Description FROM APC_Vendor WHERE"_
    " APCVM_Status= 'A' and APCVM_Type='G' ORDER BY APCVM_ROWID"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        s Description = result.Data("Description")
		s DescPY=##class(web.DHCST.Common.AppCommon).GetCNCODE(Description)
		continue:(filterDesc'="")&&(DescPY'[filterDesc)&&(Description'[filterDesc)
        continue:Description=""
        d outputRow
    }
    d result.Close()
	Quit $$$OK
outputRow  
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:配送商
/// table:      User.DHCCarrier
/// d ##class(%ResultSet).RunQuery("web.DHCST.Util.OrgUtilQuery","GetCarrier","bj")
Query GetCarrier(caDesc = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetCarrierExecute(ByRef qHandle As %Binary, caDesc = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s caDesc=$$ALPHAUP^SSUTIL4(caDesc)
    s result = ##class(%Library.ResultSet).%New()
    s StkType="G"
    s sqlStr = "SELECT Ca_RowId as RowId, Ca_Desc as Description FROM DHC_Carrier WHERE CA_Type ="_"'"_StkType_"'"_" ORDER BY Ca_RowId"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        s Description = result.Data("Description")
        continue:Description=""
	    s descPY=##class(web.DHCST.Common.AppCommon).GetCNCODE(Description)
	    continue:(caDesc'="")&&(descPY'[caDesc)&&(Description'[caDesc)
        d outputRow
    }
    d result.Close()
	Quit $$$OK
outputRow  
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:安全组能访问的科室ComboBox
/// d ##class(%ResultSet).RunQuery("web.DHCST.Util.OrgUtilQuery","GetGroupDept",1,"D")
Query GetGroupDept(groupId As %String, type = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetGroupDeptExecute(ByRef qHandle As %Binary, groupId As %String, type = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr="Select st_ctloc_dr AS RowId,st_ctloc_dr->ctloc_desc  AS Description from ss_groupstocklocations where st_parref="_groupId_" AND (ST_ActiveFlag IS NULL OR ST_ActiveFlag='Y')" 
    i type'="" d
    .s sqlStr = sqlStr_" and st_ctloc_dr->ctloc_type="_type
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        s Description = result.Data("Description")
        continue:Description=""
        d outputRow
    }
    d result.Close()
	Quit $$$OK
outputRow  
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

}
