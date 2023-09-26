/// 获取cas需要的配置
/// bmz20180308
Class DtPortal.Common.CASConfig Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("DtPortal.Common.CASConfig","GetPicCodeByDate","1-1","1-1")
/// lunarDate 农历日期（阴历）
/// gregorianDate 公历日期  1-1(1月1日) （）阳历
Query GetPicCodeByDate(lunarDate As %String = "", gregorianDate As %String = "") As DtPortal.Query(CONTAINID = 1, ROWSPEC = "hldCode:%String,hldDesc:%String,hldimgname:%String,hldIsLunar:%String,hldDays:%String,hldActive:%String,hldRowId:%String")
{
}

ClassMethod GetPicCodeByDateExecute(ByRef QHandle As %Library.Binary, lunarDate As %String = "", gregorianDate As %String = "") As %Library.Status
{
 	s repid=$I(^||CacheTemp) 
 	s ind=1 
 	s QHandle=$lb(0,repid,0)
 	
 	
 	//改为获取当前的节假日
 	s hldimgname=##class(websys.Holiday).GetImg(+$h)
 	if (hldimgname'=""){
	 	set Desc="当前图片"
	 	Set ^||CacheTemp(repid,ind)=$lb(Code,Desc,hldimgname,hldIsLunar,hldDays,hldActive,hldRowId)
		Set ind=ind+1
	}
 	q $$$OK
 	
 	;k ^tempPortalMate
 	;s ^tempPortalMate("GetPicCodeByDate")=lunarDate_"^"_gregorianDate
 	;s lunarDate="3-8",gregorianDate="3-8"
 	if (lunarDate="")||(gregorianDate="") Quit $$$OK
 	
	set hldRowId=""
	for {
		Set hldRowId = $o(^websys.HolidayD(hldRowId))
		Quit:hldRowId=""
		Set g = ^websys.HolidayD(hldRowId)
		
		Set obj=##class(websys.Holiday).%OpenId(hldRowId)
		
		Set hldActive=obj.hldActive
		Continue:hldActive'="Y"
		
		Set hldIsLunar = obj.hldIsLunar
		;Continue:hldIsLunar'=dateType
		
		Set hldDays = obj.hldDays
		Continue:(hldIsLunar="Y")&&((","_hldDays_",")'[(","_lunarDate_","))
		
		Continue:(hldIsLunar="N")&&((","_hldDays_",")'[(","_gregorianDate_","))
		
		Set Code=obj.hldCode
		Set Desc=obj.hldDesc
		Set hldimgname = obj.hldimgname
		
		
	
		
		Set ^||CacheTemp(repid,ind)=$lb(Code,Desc,hldimgname,hldIsLunar,hldDays,hldActive,hldRowId)
		Set ind=ind+1
	}
	Set QHandle=$lb(0,repid,0) 
	Quit $$$OK
}

}
