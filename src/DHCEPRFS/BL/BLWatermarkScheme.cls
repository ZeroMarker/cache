Class DHCEPRFS.BL.BLWatermarkScheme Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// Desc: 新增水印方案
/// Debug: w ##class(DHCEPRFS.BL.BLWatermarkScheme).AddWatermarkScheme("159","浏览水印","队列管理浏览水印","QUEUEVIEW")
ClassMethod AddWatermarkScheme(AUserID As %String, AWatermarkSchemeName As %String, AWatermarkSchemeDesc As %String, AWatermarkLocation As %String) As %String
{
	s ret = "0"
	q:(AUserID = "")||(AWatermarkLocation = "") ret
	s:(AWatermarkSchemeDesc = $c(0)) AWatermarkSchemeDesc = ""
	
	//水印方案适用范围默认为全院
	s watermarkScale = "Hosp"
	s:(watermarkScale = "User") watermarkScale = watermarkScale_"|"_AUserID
	
	s ret = "-1"
	s rowID = ""
	s rowID = $o(^DHCEPRFS.META.WatermarkSchemeI("IdxWatermarkLocation"," "_$zcvt(watermarkScale,"U")," "_AWatermarkLocation,rowID))
	if (rowID = "")
	{
		s obj = ##class(DHCEPRFS.META.WatermarkScheme).%New()
		s obj.WatermarkScale = watermarkScale
		s obj.WatermarkSchemeName = AWatermarkSchemeName
		s obj.WatermarkSchemeDesc = AWatermarkSchemeDesc
		s obj.WatermarkLocation = AWatermarkLocation
		s obj.IsAvailable = "Y"
		s obj.CreateDate = $p($h,",",1)
		s obj.CreateTime = $p($h,",",2)
		s obj.CreateUserID = AUserID
		s sc = obj.%Save()
		if ($$$ISOK(sc))
		{
			s ret = "1"
		}
	}
	else
	{
		s obj = ##class(DHCEPRFS.META.WatermarkScheme).%OpenId(rowID)
		s obj.WatermarkSchemeName = AWatermarkSchemeName
		s obj.WatermarkSchemeDesc = AWatermarkSchemeDesc
		s obj.IsAvailable = "Y"
		s obj.ModifyDate = $p($h,",",1)
		s obj.ModifyTime = $p($h,",",2)
		s obj.ModifyUserID = AUserID
		s sc = obj.%Save()
		if ($$$ISOK(sc))
		{
			s ret = "1"
		}
	}
	q ret
}

/// Desc: 作废水印方案
/// Debug: w ##class(DHCEPRFS.BL.BLWatermarkScheme).DisableWatermarkScheme("159","QUEUEVIEW")
ClassMethod DisableWatermarkScheme(AUserID As %String, AWatermarkLocation As %String) As %String
{
	s ret = "0"
	q:(AUserID = "")||(AWatermarkLocation = "") ret
	
	s watermarkScale = "Hosp"
	s:(watermarkScale = "User") watermarkScale = watermarkScale_"|"_AUserID
	
	s rowID = ""
	s rowID = $o(^DHCEPRFS.META.WatermarkSchemeI("IdxWatermarkLocation"," "_$zcvt(watermarkScale,"U")," "_AWatermarkLocation,rowID))
	q:(rowID = "") ret
	s obj = ##class(DHCEPRFS.META.WatermarkScheme).%OpenId(rowID)
	s obj.IsAvailable = "N"
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		s ret = "1"
	}
	q ret
}

/// Desc: 查询水印方案列表
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLWatermarkScheme","QueryWatermarkList","159")
Query QueryWatermarkList(AUserID As %String) As %Query(ROWSPEC = "ID:%String,WatermarkScale:%String,WatermarkSchemeName:%String,WatermarkSchemeDesc:%String,WatermarkLocation:%String,WatermarkLocationDesc:%String,WatermarkText:%String,FontColor:%String,DuplicateTimes:%String,LineHeight:%String,Rotation:%String,FontSize:%String,Custom:%String")
{
}

ClassMethod QueryWatermarkListExecute(ByRef qHandle As %Binary, AUserID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s:(AUserID = $c(0)) AUserID = ""
	q:(AUserID = "") $$$OK
	s watermarkScale = "Hosp"
	s:(watermarkScale = "User") watermarkScale = watermarkScale_"|"_AUserID
	
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.META.WatermarkSchemeI("IdxWatermarkScale"," "_$zcvt(watermarkScale,"U"),rowID))
		q:(rowID = "")
		
		s obj = ##class(DHCEPRFS.META.WatermarkScheme).%OpenId(rowID)
		continue:(obj.IsAvailable ="N")
		s watermarkScale = obj.WatermarkScale
		s watermarkSchemeName = obj.WatermarkSchemeName
		s watermarkSchemeDesc = obj.WatermarkSchemeDesc
		s watermarkLocation = obj.WatermarkLocation
		s watermarkText = obj.WatermarkText
		s fontColor = obj.FontColor
		s duplicateTimes = obj.DuplicateTimes
		s lineHeight = obj.LineHeight
		s rotation = obj.Rotation
		s fontSize = obj.FontSize
		s custom = obj.Custom
		
		s watermarkLocationDesc = ""
		if (watermarkLocation = "COMMON")
		{
			s watermarkLocationDesc = "通用"
		}
		elseif (watermarkLocation = "QUEUEVIEW")
		{
			s watermarkLocationDesc = "队列管理浏览"
		}
		elseif (watermarkLocation = "QUERYVIEW")
		{
			s watermarkLocationDesc = "查询浏览"
		}
		elseif (watermarkLocation = "PRINT")
		{
			s watermarkLocationDesc = "打印"
		}
		elseif (watermarkLocation = "EXPORT")
		{
			s watermarkLocationDesc = "导出"
		}
		elseif (watermarkLocation = "ACTIVEXVIEW")
		{
			s watermarkLocationDesc = "前端控件浏览"
		}
		
		s data = $lb(rowID,watermarkScale,watermarkSchemeName,watermarkSchemeDesc,watermarkLocation,watermarkLocationDesc,watermarkText,fontColor,duplicateTimes,lineHeight,rotation,fontSize,custom)
		s ^CacheTemp(repid,ind)=data
		s ind=ind+1
	} 
	
	Quit $$$OK
}

ClassMethod QueryWatermarkListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryWatermarkListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryWatermarkListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryWatermarkListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
		kill ^CacheTemp(repid)
	}
	Else      {				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Desc: 获取水印方案配置
/// Debug: w ##class(DHCEPRFS.BL.BLWatermarkScheme).GetWatermarkScheme("","QUEUEVIEW","131")
ClassMethod GetWatermarkScheme(AUserID As %String, AWatermarkLocation As %String, AMRUserID As %String) As %String
{
	s result = ""
	q:(AWatermarkLocation = "") result
	s:(AUserID = $c(0)) AUserID = ""
	s:(AMRUserID = $c(0)) AMRUserID = ""
	if (AMRUserID '= "")
	{
		s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId(AMRUserID)
		if (objUser.Type = "TEMP")
		{
			s AUserID = "TEMP"_"^"_objUser.%Id()
		}
		else
		{
			s AUserID = objUser.SSUserID
		}
	}
	q:(AUserID = "") result
	
	s watermarkScale = "Hosp"
	s:(watermarkScale = "User") watermarkScale = watermarkScale_"|"_AUserID
	s rowID = ""
	s rowID = $o(^DHCEPRFS.META.WatermarkSchemeI("IdxIsAvailable"," "_$zcvt(watermarkScale,"U")," "_AWatermarkLocation," Y",rowID))
	if (rowID = "")
	{
		s rowID = $o(^DHCEPRFS.META.WatermarkSchemeI("IdxIsAvailable"," "_$zcvt(watermarkScale,"U")," COMMON"," Y",rowID))
	}
	q:(rowID = "") result
	
	s obj = ##class(DHCEPRFS.META.WatermarkScheme).%OpenId(rowID)
	q:(obj = "") result
	s watermarkText = ..GetWatermarkText(obj.WatermarkText,AUserID)
	s fontColor = obj.FontColor
	s duplicateTimes = obj.DuplicateTimes
	s lineHeight = obj.LineHeight
	s rotation = obj.Rotation
	s fontSize = obj.FontSize
	s custom = obj.Custom
	s result = watermarkText_"$$$"_fontColor_"$$$"_duplicateTimes_"$$$"_lineHeight_"$$$"_rotation_"$$$"_fontSize_"$$$"_custom
	q result
}

/// Desc: 保存水印方案配置
/// Debug: w ##class(DHCEPRFS.BL.BLWatermarkScheme).SaveWatermarkScheme("1","159","HospitalFlag^Custom","仅供参考","255.0.0","3","250","45","40")
ClassMethod SaveWatermarkScheme(AID As %String, AUserID As %String, AWatermarkText As %String, ACustom As %String, AFontColor As %String, ADuplicateTimes As %String, ALineHeight As %String, ARotation As %String, AFontSize As %String) As %String
{
	s ret = "0"
	q:(AID = "") ret
	s:(ACustom = $c(0)) ACustom = ""
	s obj = ##class(DHCEPRFS.META.WatermarkScheme).%OpenId(AID)
	q:(obj = "") ret
	s obj.ModifyDate = $p($h,",",1)
	s obj.ModifyTime = $p($h,",",2)
	s obj.ModifyUserID = AUserID
	s obj.WatermarkText = AWatermarkText
	s obj.Custom = ACustom
	s obj.FontColor = AFontColor
	s obj.DuplicateTimes = ADuplicateTimes
	s obj.LineHeight = ALineHeight
	s obj.Rotation = ARotation
	s obj.FontSize = AFontSize
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		s ret = "1"
	}
	q ret
}

/// Desc: 获取水印文本内容
/// Debug: w ##class(DHCEPRFS.BL.BLWatermarkScheme).GetWatermarkText("IP^Date^HospitalFlag","159")
ClassMethod GetWatermarkText(AInput As %String, AUserID As %String) As %String
{
	s allWatermarkText = ""
	s:(AInput = $c(0)) AInput = ""
	q:(AInput = "") allWatermarkText
	for i=1:1:$l(AInput,"^")
	{
		s oneWatermarkText = $p(AInput,"^",i)
		s realWatermarkText = $ZOBJCLASSMETHOD("DHCEPRFS.BL.BLWatermarkClassMethod",oneWatermarkText,AUserID)
		if (allWatermarkText = "")
		{
			s allWatermarkText = realWatermarkText
		}
		else
		{
			s allWatermarkText = allWatermarkText_"^"_realWatermarkText
		}
	}
	q allWatermarkText
}

}
