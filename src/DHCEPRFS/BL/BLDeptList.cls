Class DHCEPRFS.BL.BLDeptList Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:获得科室列表
/// Input: ALocID 科室ID
/// Output: ID，描述，拼音描述
/// w ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLDeptList","GetDeptList","")
Query GetDeptList(ALocID As %String = "", ALocName As %String = "") As %Query(ROWSPEC = "ID:%String,Desc:%String,AliasDesc:%String")
{
}

ClassMethod GetDeptListExecute(ByRef qHandle As %Binary, ALocID As %String = "", ALocName As %String = "") As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s LocID	= $g(ALocID)
	s LocName = $g(ALocName)
	

	s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.HISInfo.BLHISInfo:GetCTLocIDByCTLocType")
	d result.Execute("E")
	//b "s"

	while(result.Next())
	{
		//b "s"
		s RowID = $g(result.Data("CTLocID"))
		s arrFiles = ##class(%ArrayOfDataTypes).%New()
		s arrFiles = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetCTLocInfoByCTLocID(RowID)
		
		//s Desc = $p(objCtLoc,"^",2)
		s Desc = arrFiles.GetAt("CTLocDesc")
		continue:(Desc [ "门诊")
		continue:(Desc [ "医院")					//华西医院专用
		
		//s ContactName = $p(objCtLoc,"^",16)			//一些医院用于存储科室或病区拼音码
		s ContactName = arrFiles.GetAt("CTLocContactName")
		if (ContactName = "")
		{
			s ContactName = $p(Desc,"-",1)
		}

		// 匹配科室或者病区名称，包括拼音码
		continue:(LocName '= "")&&( Desc '[ LocName)&&( $zcvt(ContactName,"U") '[ $zcvt(LocName,"U"))
		
		s:(Desc [ "-") Desc = $p(Desc,"-",2) 

		// 匹配科室ID，如果Type为E，则只需要找到
		if (LocID '= "")
		{
			continue:(LocID '= RowID)
			
			s Data = $lb(RowID,Desc,ContactName)
			s ^CacheTemp(repid,ind) = Data
			s ind = ind+1
		}
		else
		{
			s Data = $lb(RowID,Desc,ContactName)
			s ^CacheTemp(repid,ind) = Data
			s ind = ind + 1
		}
	}
	q $$$OK
}

ClassMethod GetDeptListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDeptListExecute ]
{
	s repid = $list(qHandle,2)
	k ^CacheTemp(repid) 
	q $$$OK
}

ClassMethod GetDeptListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDeptListExecute ]
{
	s AtEnd = $list(qHandle,1)
	s repid = $list(qHandle,2)
	s ind = $list(qHandle,3)
	s ind = $o(^CacheTemp(repid,ind))
	if (ind = "") 
	{			
		s AtEnd = 1
		s Row = ""
		k ^CacheTemp(repid)
	} 
	else 
	{				
		s Row = ^CacheTemp(repid,ind)
	}
	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

/// Desc: 按照科室部门组取科室列表
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLDeptList","GetLocListByDepDR","2")
Query GetLocListByDepDR(ALocDepDR As %String, ALocID As %String = "") As %Query(ROWSPEC = "LocID:%String,LocCode:%String,LocDesc:%String,LocContactName:%String")
{
}

ClassMethod GetLocListByDepDRExecute(ByRef qHandle As %Binary, ALocDepDR As %String, ALocID As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	
	if (ALocDepDR '= "")
	{
		s rowID = ""
		f {
			s rowID  = $o(^CTLOC(0,"DepGrp",ALocDepDR,rowID))
			q:(rowID = "")
			continue:((ALocID '= "")&&(rowID '= ALocID))
			s locCode = $p($g(^CTLOC(rowID)),"^",1)
			s locDesc = $p($g(^CTLOC(rowID)),"^",2)
			s:($l(locDesc,"-") > 1) locDesc = $p(locDesc,"-",2)
			s locType = $p($g(^CTLOC(rowID)),"^",13)
			continue:(locType '= "E")
			s locContactName = $p($g(^CTLOC(rowID)),"^",43)
			s ^CacheTemp(repid,ind) = $lb(rowID,locCode,locDesc,locContactName)
			s ind = ind + 1
		}
	}
	else
	{
		s rowID = 0
		f {
			s rowID = $o(^CTLOC(rowID))
			q:(rowID = "")
			continue:((ALocID '= "")&&(rowID '= ALocID))
			s locCode = $p($g(^CTLOC(rowID)),"^",1)
			s locDesc = $p($g(^CTLOC(rowID)),"^",2)
			s:($l(locDesc,"-") > 1) locDesc = $p(locDesc,"-",2)
			s locType = $p($g(^CTLOC(rowID)),"^",13)
			continue:(locType '= "E")
			s locContactName = $p($g(^CTLOC(rowID)),"^",43)
			s ^CacheTemp(repid,ind) = $lb(rowID,locCode,locDesc,locContactName)
			s ind = ind + 1
		}
	}
	
	q $$$OK
}

ClassMethod GetLocListByDepDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocListByDepDRExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If ind = "" {				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
	}
	Else      {				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetLocListByDepDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocListByDepDRExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
