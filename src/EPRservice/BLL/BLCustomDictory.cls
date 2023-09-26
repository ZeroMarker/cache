/// Creator: Candyxu
/// Creatdeta :20120409
Class EPRservice.BLL.BLCustomDictory Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// desc: 根据TID获得重复模板关联文书标题
/// Date: 2012-04-10
/// Ctreator : Candyxu
/// Debug:d ##Class(EPRservice.BLL.BLCustomDictory).GetDateByTID(32)
ClassMethod GetDateByTID(TID As %String) As %String
{
	s Result = ""
	q:($d(^DHCEPRM.CustomDictionaryI("IdxCtmTypeCode"," TIDLINKTITLE"," "_TID)) = 0) Result
	s CtmRowID = $o(^DHCEPRM.CustomDictionaryI("IdxCtmTypeCode"," TIDLINKTITLE"," "_TID,""))
	q:(CtmRowID = "") Result
	s CtmDictRef = $li(^DHCEPRM.CustomDictionaryD(CtmRowID),13)
	q:(CtmDictRef = "") Result
	s RowCount = $LENGTH(CtmDictRef,"^")
	s Result = $li(^DHCEPRM.CustomDictionaryD(CtmRowID),8)
    f I=  1 :1:RowCount
    {
	   s CtmRowID = $p($p(CtmDictRef,"^",I),"-",1)
	   continue:(CtmRowID="")
	   
	   s CtmStatus = $p($p(CtmDictRef,"^",I),"-",2)
	   s CtmDicDesc =  $li(^DHCEPRM.CustomDictionaryD(CtmRowID),4)
	   s CtmDictAlias = $li(^DHCEPRM.CustomDictionaryD(CtmRowID),2)
	   i ($g(CtmDictAlias) '= "")&&($g(CtmDictAlias)'= $c(0)) s CtmDicDesc = CtmDicDesc_"-"_CtmDictAlias
	   i ($g(CtmStatus) '= "" )&&($g(CtmStatus)'=$c(0)) s CtmDicDesc = CtmDicDesc_"-"_CtmStatus
	   s Result = Result_"$"
	   s Result = Result_CtmDicDesc
	}
	q Result
}

/// Ceator: Candyxu
/// Date：2012-04-11
/// Desc:诊断类型与可重复模板表题的对应关系
/// Debug: do ##class(%ResultSet).RunQuery("EPRservice.BLL.BLCustomDictory","GetDiagnosTypeByTitle")
Query GetDiagnosTypeByTitle() As %Query(ROWSPEC = "ADiagnosTypeID:%String,ATitleName:%String")
{
}

ClassMethod GetDiagnosTypeByTitleExecute(ByRef qHandle As %Binary) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	set RowID = "0"
 	for {
	 	set RowID = $o(^DHCEPRM.CustomDictionaryI("IdxCtmDictType"," TYPELINKTITLE",RowID))
	 	quit:(RowID = "")
		set DiagnosTypeID = $li(^DHCEPRM.CustomDictionaryD(RowID),3)
		 	set CtmDictRef = $li(^DHCEPRM.CustomDictionaryD(RowID),13)
		 	set RowCount = $LENGTH(CtmDictRef,"^")
		 	for I =  1 :1:RowCount
		 	{
			 	set CtmRowID = $p(CtmDictRef,"^",I)
	            set CtmDicDesc =  $li(^DHCEPRM.CustomDictionaryD(CtmRowID),4)
	 	        set data = $lb(DiagnosTypeID,CtmDicDesc)
	            set ^CacheTemp(repid,ind)=data
	            set ind=ind+1
			}
	}
	Quit $$$OK
}

ClassMethod GetDiagnosTypeByTitleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiagnosTypeByTitleExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDiagnosTypeByTitleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDiagnosTypeByTitleExecute ]
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

/// desc:用于将系统参数中ListTitleChoice	中内容移动到持久化类中
/// debug: d ##Class(EPRservice.BLL.BLCustomDictory).SetData()
ClassMethod SetData()
{
	if $d(^DHCEPRM.SysOptionI("NameIndex"," LISTTITLECHOICE")) '=0
	{
		s RowID = $o(^DHCEPRM.SysOptionI("NameIndex"," LISTTITLECHOICE",""))
		if $g(RowID) '= ""
		{
			s OptionValue = $li(^DHCEPRM.SysOptionD(RowID),4)
			s RowCount = $LENGTH(OptionValue,"#")
			for I =  1 :1:RowCount
			{
				s TemplateID = $p($p($p(OptionValue,"#",I),"|",1),"^",1)
				s TemplateStatus = $p($p($p(OptionValue,"#",I),"|",1),"^",2)
				s Titles = $p($p(OptionValue,"#",I),"|",2)
				s TitleCount = $LENGTH(Titles,"^")
				s IDs = ""
				for J=1 :1:TitleCount
				{
					s TName = $p($p(Titles,"^",J),"-",1)
					s TAlis = $p($p(Titles,"^",J),"-",2)
					s TStatus = $p($p(Titles,"^",J),"-",3)
					i J > 1 {s IDs = IDs_"^"}
					i $d(^DHCEPRM.CustomDictionaryI("IdxCtmDictDesc"," "_TName)) = 0
					{
						s obj = ##Class(EPRmeta.CustomDictionary).%New()
						s obj.CtmDictAlias = $g(TAlis)
						s obj.CtmDictDesc = TName
						s obj.CtmDictStatus = "Y"
						s obj.CtmDictType = "TitleList"
						s sc = obj.%Save()
						if $SYSTEM.Status.IsOK(sc){s id = obj.%Id()}
						if (id '= "") 
						{
							if $g(TStatus) '= "" {s id = id_"-"_TStatus}
							s IDs = IDs_id
						}
					}else
					{
						s id = $o(^DHCEPRM.CustomDictionaryI("IdxCtmDictDesc"," "_TName,""))
						if id '= "" {s IDs = IDs_id}
					}
				}
				s objT = ##Class(EPRmeta.CustomDictionary).%New()
				s objT.CtmDictCode = TemplateID
				s objT.CtmDictDesc = "模板关联记录"
				s objT.CtmDictComment = $g(TemplateStatus)
				s objT.CtmDictRef = IDs
				s objT.CtmDictStatus = "Y"
				s objT.CtmDictType = "TidLinkTitle"
				s sc = objT.%Save()
			} 
		}
	}
}

/// Ceator: Candyxu
/// Date：2012-05-15
/// Desc:牙位信息
/// Debug: do ##class(%ResultSet).RunQuery("EPRservice.BLL.BLCustomDictory","GetTeethInformation")
Query GetTeethInformation() As %Query(ROWSPEC = "CtmDictCode:%String,CtmDictAlias:%String,CtmDictDesc:%String")
{
}

ClassMethod GetTeethInformationExecute(ByRef qHandle As %Binary) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	set CodeID = "0"
 	for {
	 	set CodeID = $o(^DHCEPRM.CustomDictionaryI("IdxCtmTypeCode"," TEETHTYPE",CodeID))
	 	quit:(CodeID = "")
	 	set RowID = $o(^DHCEPRM.CustomDictionaryI("IdxCtmTypeCode"," TEETHTYPE",CodeID,""))
		set CtmDictCode = $li(^DHCEPRM.CustomDictionaryD(RowID),3)
		set CtmDictAlias = $li(^DHCEPRM.CustomDictionaryD(RowID),2)
		set CtmDictDesc =  $li(^DHCEPRM.CustomDictionaryD(RowID),4)

	 	set data = $lb(CtmDictCode,CtmDictAlias,CtmDictDesc)
	    set ^CacheTemp(repid,ind)=data
	    set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod GetTeethInformationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTeethInformationExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetTeethInformationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTeethInformationExecute ]
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

/// Desc:	获取不打印的标题列表
/// Input：	APrintTemplateID : 界面模板ID
/// Output: 无
/// Return: 不打印的标题列表
/// Debug：	w ##Class(EPRservice.BLL.BLCustomDictory).GetUnprintTitle("10")
ClassMethod GetUnprintTitle(APrintTemplateID As %String) As %String
{
	s unprintTitle = ""
	
	q:(APrintTemplateID = "") unprintTitle
	
	s CtmRowID = $o(^DHCEPRM.CustomDictionaryI("IdxCtmTypeCode"," PTIDLINKUNPRINTTITLE"," "_APrintTemplateID,""))
	q:(CtmRowID = "") unprintTitle
	
	s CtmDictRef = $li(^DHCEPRM.CustomDictionaryD(CtmRowID),13)
	q:(CtmDictRef = "")||(CtmDictRef=$c(0)) unprintTitle
	
	s validCount = 0
	s titleCount = $LENGTH(CtmDictRef,"^")
	f I=  1:1:titleCount
    {
	   s CtmRowID = $p(CtmDictRef,"^",I)
	   continue:(CtmRowID="")
	   
	   s objList = $g(^DHCEPRM.CustomDictionaryD(CtmRowID))
	   continue:(objList = "")
	   
	   s validCount = validCount + 1
	   s CtmDicDesc =  $li(objList,4)
	   	
	   if (validCount = 1)
	   {
		   s unprintTitle = CtmDicDesc
	   }
	   else
	   {
		   s unprintTitle = unprintTitle_"^"_CtmDicDesc 
	   }
	}
	
	q unprintTitle
}

/// Desc:	取指定类型的医嘱项信息
/// Debug:	w ##Class(EPRservice.BLL.BLCustomDictory).GetOrderItemConfig("")
ClassMethod GetOrderItemConfig(AOrderItemName As %String) As %String
{
	s orderItemID = ""
	
	k SQLCODE
	&sql(select top 1 CtmDictID into :orderItemID from EPRmeta.CustomDictionary where CtmDictType = 'ARCItemMast' and CtmDictName=:AOrderItemName and CtmDictStatus='Y')
	if (SQLCODE = 0)
	{
		q orderItemID
	}
	else
	{
		q ""
	}
}

}
