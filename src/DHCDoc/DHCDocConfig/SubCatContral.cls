Class DHCDoc.DHCDocConfig.SubCatContral Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query FindCatList(value As %String, HospId As %String = "") As %Query(ROWSPEC = "ARCICRowId:%String,ARCICDesc:%String,selected:%Boolean")
{
}

ClassMethod FindCatListExecute(ByRef qHandle As %Binary, value As %String, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.SubCatContral","FindCatList","NeedExecCat")
	i value'="" s FrequencedItemCatListStr=..%GetConfig(value,HospId) //$g(^DHCDocConfig(value))
	if (value="OrdNeedMMDiagCat")||(value="CMOrdNeedTCMDiagCat") {
		s CNMedItemCat=##Class(web.DHCDocOrderCommon).GetCNMedItemCatStr(HospId)
		s CNMedItemCat="^"_CNMedItemCat_"^"
	}
	Set repid=$I(^CacheTemp)
    Set ind=1
    s ARCICRowId=0
 	f  s ARCICRowId=$o(^ARC("IC",ARCICRowId)) q:ARCICRowId=""  d
 	.Q:(value="OrdNeedMMDiagCat")&&(CNMedItemCat[("^"_ARCICRowId_"^"))
 	.Q:(value="CMOrdNeedTCMDiagCat")&&(CNMedItemCat'[("^"_ARCICRowId_"^"))
 	.Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItemCat",ARCICRowId,HospId)="N"
 	.s ARCICDesc=$p(^ARC("IC",ARCICRowId),"^",2)
 	.s selected=0
 	.i value'="" d
 	..s:("^"_FrequencedItemCatListStr_"^")[("^"_ARCICRowId_"^") selected=1
	.Do OutputRowFindCatList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindCatList
	set Data=$lb($g(ARCICRowId),$g(ARCICDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindCatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCatListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCatListExecute ]
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

Query FindFreqList(value As %String, Type As %String = "", HospId As %String = "") As %Query(ROWSPEC = "FreqRowId:%String,FreqCode:%String,selected:%Boolean")
{
}

ClassMethod FindFreqListExecute(ByRef qHandle As %Binary, value As %String, Type As %String = "", HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.SubCatContral","FindFreqList","FrequencedItemFreq")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s FreqRowId=0
 	f  s FreqRowId=$o(^PHCFR(FreqRowId)) q:FreqRowId=""  d
 	.s str=$g(^PHCFR(FreqRowId))
 	.s FreqCode=$p(str,"^",3)
 	.s PHCFRDesc2=$p(str,"^",4)
 	.Q:(PHCFRDesc2'="饮片")&&(Type="CM")
	.Q:(PHCFRDesc2="饮片")&&(Type'="CM")
	.s Active=$P(^PHCFR(FreqRowId),"^",6)
	.q:(Active="N")
	.s selected=0
	.i value'="" d
	..i FreqRowId=..%GetConfig(value,HospId) s selected=1 //$g(^DHCDocConfig(value))
	.Do OutputRowFindFreqList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindFreqList
	set Data=$lb($g(FreqRowId),$g(FreqCode),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindFreqListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindFreqListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindFreqListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindFreqListExecute ]
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

Query FindDurList(value As %String, Type As %String = "CM", HospId As %String = "") As %Query(ROWSPEC = "DurRowId:%String,DurCode:%String,selected:%Boolean,DurationFactor:%String")
{
}

ClassMethod FindDurListExecute(ByRef qHandle As %Binary, value As %String, Type As %String = "CM", HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.SubCatContral","FindDurList","FrequencedItemDur")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s DurRowId=0
 	f  s DurRowId=$o(^PHCDU(DurRowId)) q:DurRowId=""  d
 	.s str=$g(^PHCDU(DurRowId))
 	.s DurCode=$p(str,"^",1)
 	.s DurDesc2=$p(str,"^",4)
 	.q:(DurDesc2'="饮片")&&(Type="CM")
 	.q:(DurDesc2="饮片")&&(Type="XY")
 	.s PHCDUDateFrom=$p(str,"^",5)
 	.Q:(PHCDUDateFrom'="")&&(PHCDUDateFrom>+$h)
 	.s PHCDUDateTo=$p(str,"^",6)
 	.Q:(PHCDUDateTo'="")&&(PHCDUDateTo<+$h)
 	.s DurationFactor=$p(str,"^",2)
	.s selected=0
	.i value'="" d
	..i DurRowId=..%GetConfig(value,HospId) s selected=1 //$g(^DHCDocConfig(value))
	.Do OutputRowFindDurList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindDurList
	set Data=$lb($g(DurRowId),$g(DurCode),$g(selected),$g(DurationFactor))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindDurListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDurListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindDurListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDurListExecute ]
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

Query ReOrdSubCatList() As %Library.Query(CONTAINID = 0, ROWSPEC = "Rowid:%String,Desc:%String,Code:%String") [ SqlProc ]
{
}

// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ReSetOrdSubCat","ReOrdSubCatList")

ClassMethod ReOrdSubCatListExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ModuleId=0,FindRowID=""
	f  s ModuleId=$o(^DHCDocCT("Module",ModuleId)) q:(ModuleId="")||(FindRowID'="")  d
	.s ModuleDesc=$g(^DHCDocCT("Module",ModuleId))
	.i ModuleDesc="医嘱重分类" s FindRowID=ModuleId
	if (FindRowID=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	Set langid=..%LanguageID()
	s CTDefine=0
	f  s CTDefine=$o(^DHCDocCTi(0,"Define","ModuleDR",FindRowID,CTDefine)) q:CTDefine=""  d
	.//^DHCDocCT("Define",24) = "ORDSUBCAT^医嘱重分类^2" 
	.s DefineDataID=0
	.f  s DefineDataID=$o(^DHCDocCT("DefineData",CTDefine,"D",DefineDataID)) q:DefineDataID=""  d
	..//^DHCDocCT("DefineData",24,"D",1) = "01^药物^63911^" 
	..s DefineDataCode=$p(^DHCDocCT("DefineData",CTDefine,"D",DefineDataID),"^",1)
	..s DefineDataDesc=$p(^DHCDocCT("DefineData",CTDefine,"D",DefineDataID),"^",2)
	..Set DefineDataDesc= ##class(User.DHCDocCTDefineData).GetTranByDesc("DHCDocCTDefineDataDesc",DefineDataDesc,langid)
	..s DefineDataFrom=$p(^DHCDocCT("DefineData",CTDefine,"D",DefineDataID),"^",3)
	..q:(DefineDataFrom'="")&&(DefineDataFrom>+$h)
	..s DefineDataTo=$p(^DHCDocCT("DefineData",CTDefine,"D",DefineDataID),"^",4)
	..q:(DefineDataTo'="")&&(DefineDataTo<=..%SysDate())
	..d OutputRow4	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow4
	set Data=$lb(CTDefine_"||"_DefineDataID,DefineDataDesc,DefineDataCode)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod ReOrdSubCatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReOrdSubCatListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {			// if there are no more rows, finish fetching
	 Set AtEnd=1
	 Set Row=""
	}
	Else {				// fetch row
	 Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ReOrdSubCatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReOrdSubCatListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindCatListNew(value As %String, HospId As %String = "") As %Query(ROWSPEC = "ARCICRowId:%String,ARCICDesc:%String,selected:%Boolean")
{
}

ClassMethod FindCatListNewExecute(ByRef qHandle As %Binary, value As %String, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ReSetOrdSubCat","FindCatList","NeedExecCat")
	Set repid=$I(^CacheTemp)
    Set ind=1
    i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
	}else{
		s HospCodeNode=""
	}
    k SubCateArr
    if (HospCodeNode'=""){
	    s OrdSubCatID=""
	    for {
			s OrdSubCatID=$O(^DHCDocConfig(HospCodeNode,"DHCDocReSetOrdSubCat",OrdSubCatID))
			q:(OrdSubCatID="")
			s OrdSubCatDesc=$P(^DHCDocCT("DefineData",+OrdSubCatID,"D",$P(OrdSubCatID,"||",2)),"^",2)
			s SubCateList=$G(^DHCDocConfig(HospCodeNode,"DHCDocReSetOrdSubCat",OrdSubCatID))
			for i=1:1:$Length(SubCateList,"^") {
				s ARCICRowId=$P(SubCateList,"^",i)
				continue:(ARCICRowId="")
				s ARCICDesc=$p(^ARC("IC",ARCICRowId),"^",2)
				if ($D(SubCateArr(ARCICRowId))){
					s SubCateArr(ARCICRowId)=SubCateArr(ARCICRowId)_"|"_OrdSubCatDesc
				}else{
					s SubCateArr(ARCICRowId)=OrdSubCatDesc
				}
				
			}
		}
	}else{
    	s OrdSubCatID=""
	    for {
			s OrdSubCatID=$O(^DHCDocConfig("DHCDocReSetOrdSubCat",OrdSubCatID))
			q:(OrdSubCatID="")
			s OrdSubCatDesc=$P(^DHCDocCT("DefineData",+OrdSubCatID,"D",$P(OrdSubCatID,"||",2)),"^",2)
			s SubCateList=$G(^DHCDocConfig("DHCDocReSetOrdSubCat",OrdSubCatID))
			for i=1:1:$Length(SubCateList,"^") {
				s ARCICRowId=$P(SubCateList,"^",i)
				continue:(ARCICRowId="")
				s ARCICDesc=$p(^ARC("IC",ARCICRowId),"^",2)
				if ($D(SubCateArr(ARCICRowId))){
					s SubCateArr(ARCICRowId)=SubCateArr(ARCICRowId)_"|"_OrdSubCatDesc
				}else{
					s SubCateArr(ARCICRowId)=OrdSubCatDesc
				}
				
			}
		}
	}
	s CatListStr=..%GetConfig1("DHCDocReSetOrdSubCat",value,HospId) //$g(^DHCDocConfig("DHCDocReSetOrdSubCat",value))
    s ARCICRowId=0
 	f  s ARCICRowId=$o(^ARC("IC",ARCICRowId)) q:ARCICRowId=""  d
 	.Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItemCat",ARCICRowId,HospId)="N"
 	.s ARCICDesc=$p(^ARC("IC",ARCICRowId),"^",2)
 	.i $D(SubCateArr(ARCICRowId)) d
 	..s ARCICDesc=ARCICDesc_"|"_SubCateArr(ARCICRowId)
 	.s selected=0
 	.i value'="" d
 	..s:("^"_CatListStr_"^")[("^"_ARCICRowId_"^") selected=1
	.Do OutputRowFindCatListNew
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindCatListNew
	set Data=$lb($g(ARCICRowId),$g(ARCICDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindCatListNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCatListNewExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCatListNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCatListNewExecute ]
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

// 得到分类串

// w ##class(DHCDoc.DHCDocConfig.SubCatContral).GetOrdCateGoryStr()

ClassMethod GetOrdCateGoryStr() As %String
{
	set ret=""
	Set rset=##Class(%ResultSet).%New("DHCDoc.DHCDocConfig.SubCatContral:ReOrdSubCatList")
	If rset.QueryIsValid() { 
		Set Status=rset.Execute()
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		While (rset.Next()) {
		   i ret="" s ret=rset.GetData(1)_":"_rset.GetData(2)
	       e  s ret=ret_";"_rset.GetData(1)_":"_rset.GetData(2)
		}
		d rset.Close()
 	}
 	q ret
}

// 根据分类查询分类下的医嘱子类串

// w ##class(DHCDoc.DHCDocConfig.SubCatContral).GetOrdSubCateGoryStr()

ClassMethod GetOrdSubCateGoryStr(value As %String, HospId As %String = "") As %String
{
	set ret=""
	Set rset=##Class(%ResultSet).%New("DHCDoc.DHCDocConfig.SubCatContral:FindCatListNew")
	If rset.QueryIsValid() { 
		Set Status=rset.Execute(value,HospId)
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		While (rset.Next()) {
		   i rset.GetData(3)'="1" continue
		   i ret="" s ret=rset.GetData(1)
	       e  s ret=ret_"^"_rset.GetData(1)
		}
		d rset.Close()
 	}
 	q ret
}

ClassMethod GetPropmtInfo(HospId As %String = "") As %String
{
	//医嘱重分类设置缺陷提醒
	s PropmtInfo="",repeatInfo=""
	s CatListStr=""
	Set rset=##Class(%ResultSet).%New("DHCDoc.DHCDocConfig.SubCatContral:ReOrdSubCatList")
	If rset.QueryIsValid() { 
		Set Status=rset.Execute()
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		While (rset.Next()) {
			s ID=rset.GetData(1)
			s Value=..%GetConfig1("DHCDocReSetOrdSubCat",ID,HospId) //$g(^DHCDocConfig("DHCDocReSetOrdSubCat",ID))
			if (Value=""){
				continue   
			}
			if (CatListStr=""){
				s CatListStr=Value
			}else{
				s CatListStr=CatListStr_"^"_Value
			}
			
		}
		d rset.Close()
	}
	
	s ARCICRowId=""
	f  {
		s ARCICRowId=$o(^ARC("IC",ARCICRowId))
		q:ARCICRowId=""
		continue:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItemCat",ARCICRowId,HospId)="N"
		s count=0
		for i=1:1:$L(CatListStr,"^"){
			if ($P(CatListStr,"^",i)=ARCICRowId){
				s count=count+1
			}
		}
		if (count=1){
			continue
		}
 		s ARCICDesc=$p(^ARC("IC",ARCICRowId),"^",2)
 		if (count>1){
	 		if (repeatInfo=""){
		 		s repeatInfo="医嘱重分类维护重复子类: "_ARCICDesc
		 	}else{
			 	s repeatInfo=repeatInfo_","_ARCICDesc
			}
	 	}else{
	 		if (PropmtInfo=""){
		 		s PropmtInfo="未进行医嘱重分类维护的子类: "_ARCICDesc
		 	}else{
			 	s PropmtInfo=PropmtInfo_","_ARCICDesc
			}
		}
	}
	q PropmtInfo_"<br/>"_repeatInfo
}

Query FindSubCatConfigList(ARCICRowId As %String = "", HospId As %String) As websys.Query(ROWSPEC = "id:%String,text:%String,SubCatHasConfigFlag:%String,tip:%String")
{
}

/// 获取子类控制设置配置项列表
ClassMethod FindSubCatConfigListExecute(ByRef qHandle As %Binary, ARCICRowId As %String = "", HospId As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.SubCatContral","FindSubCatConfigList")
	Set repid=$I(^CacheTemp)
    Set ind=1
	k ConfigCongeriesArr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(..GetSubCatConfigJson(),.ConfigCongeriesArr)
    s count=0
    for {
	    s count=$o(ConfigCongeriesArr(count)) Q:count=""
	    s id=$G(ConfigCongeriesArr(count,"id"))
	    s text=$G(ConfigCongeriesArr(count,"text"))
		s tip=$G(ConfigCongeriesArr(count,"tip"))
	    s SubCatHasConfigFlag="N"
	    if (ARCICRowId'="") {
		    ;但查询子类已配置的项目时过滤医嘱重分类
		    continue:id="DHCDocReSetOrdSubCat"
		    s CatListStr=..%GetConfig(id,HospId)
		    if ("^"_CatListStr_"^")[("^"_ARCICRowId_"^") s SubCatHasConfigFlag="Y"
		}
	    d OutputRow1
	}
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb($g(id),$g(text),$g(SubCatHasConfigFlag),tip)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetSubCatConfigJson() As %String
{
	s JsonObj=[]
	d JsonObj.%Push({"id":"FrequencedItemCat","text":"录入频次疗程的非药品子类"})
	d JsonObj.%Push({"id":"NeedExecCat","text":"需生成执行记录的无频次子类V6.0-6.9"})
	d JsonObj.%Push({"id":"NotAlertRepeatItemCat","text":"不需要提示重复的子类"})
    d JsonObj.%Push({"id":"NotSamePriorNeedAlertItemCat","text":"不同医嘱类型需提示重复的子类"})
	d JsonObj.%Push({"id":"OPUnRepeatItemCat","text":"门诊不能重复的子类"})
	d JsonObj.%Push({"id":"NoDisplayItemCat","text":"不需要显示的子类"})
	d JsonObj.%Push({"id":"CheckItemCat","text":"需要审批的子分类(项目用)"})
	d JsonObj.%Push({"id":"MedItemCat","text":"西药子分类"})
	d JsonObj.%Push({"id":"CPMedItemCat","text":"中成药子分类"})
	d JsonObj.%Push({"id":"LimitMedItemCat","text":"精二类药品子分类(项目用)"})
	d JsonObj.%Push({"id":"PreciousDrugItemCat","text":"贵重药品子分类(项目用)"})
    d JsonObj.%Push({"id":"AllowEntryDecimalItemCat","text":"数量可以录入小数的子类","tip":"1、因退药问题,药品医嘱仅在住院和急诊长期模式下有效;<br>2、不支持草药,请单独维护医嘱项允许录入小数标志"})
	d JsonObj.%Push({"id":"NotAlertZeroItemCat","text":"不需要提示零费用子类"})
	d JsonObj.%Push({"id":"NotLinkItemCat","text":"不能关联的医嘱子类"})
    d JsonObj.%Push({"id":"StopAllExecItemCat","text":"停医嘱强制停止执行的子类"})
	d JsonObj.%Push({"id":"TreatItemCat","text":"治疗子分类"})
	d JsonObj.%Push({"id":"SelectInstrNotDrugCat","text":"可选择用法的非药品子分类"})
	d JsonObj.%Push({"id":"DHCDocReSetOrdSubCat","text":"医嘱重分类设置"})
	d JsonObj.%Push({"id":"IssuedNotCancelItemCat","text":"发药后不可作废或撤销"})
	d JsonObj.%Push({"id":"IPNecessaryCat","text":"住院患者必录的子类-提醒"})
	d JsonObj.%Push({"id":"OPAutoDurCat","text":"自动带上一行疗程的医嘱子类-门急诊"})
	d JsonObj.%Push({"id":"AfterNurDealCanUnuseItemCat","text":"护士处理后可以作废/撤销的子类-住院","tip":"需先启用'常规设置-护士处理医嘱后不能作废/撤销(住院)'后,此配置才生效"})
	d JsonObj.%Push({"id":"OrdNeedMMDiagCat","text":"医嘱录入需存在西医诊断的子类"})
	d JsonObj.%Push({"id":"CMOrdNeedTCMDiagCat","text":"草药录入需存在中医诊断的子类"})
	d JsonObj.%Push({"id":"OPGenOneExecCat","text":"门急诊仅产生一条执行记录的子类","tip":"一般是配置门诊口服药以及不会在医院执行的子类,防止因为开立医嘱疗程过长需要插入大量的执行记录而导致开立医嘱卡顿"})
	Q JsonObj.%ToJSON()
}

/// 批量修改某个子类的子类配置项
/// w ##class(DHCDoc.DHCDocConfig.SubCatContral).SaveSubCatConfigBySubCatId("MedItemCat^AllowEntryDecimalItemCat^NotAlertRepeatItemCat",1,2)
ClassMethod SaveSubCatConfigBySubCatId(ConfigIdStr As %String, ARCICRowId As %String = "", HospId As %String) As %String
{
	s Coninfo=""
	k ConfigCongeriesArr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(..GetSubCatConfigJson(),.ConfigCongeriesArr)
    s count=0
    for {
	    s count=$o(ConfigCongeriesArr(count)) Q:count=""
	    s id=$G(ConfigCongeriesArr(count,"id"))
	    continue:id="DHCDocReSetOrdSubCat"
	    s text=$G(ConfigCongeriesArr(count,"text"))
	    s OldCatListStr=..%GetConfig(id,HospId)
	    i OldCatListStr=0 s OldCatListStr=""
	    s NewCatListStr=""
	    if ("^"_ConfigIdStr_"^")[("^"_id_"^") {
		    // 添加某个子类的某个配置项维护,若配置项旧数据中包含传入的子类则继续循环下一条数据
			if ("^"_OldCatListStr_"^")[("^"_ARCICRowId_"^") continue
			if OldCatListStr="" s NewCatListStr=ARCICRowId
			else  s NewCatListStr=OldCatListStr_"^"_ARCICRowId
		}else{
			// 去掉某个子类的某个配置项维护,若配置项旧数据中不包含传入的子类则继续循环下一条数据
			if ("^"_OldCatListStr_"^")'[("^"_ARCICRowId_"^") continue
			for i=1:1:$l(OldCatListStr,"^") {
				s oneARCICRowId=$p(OldCatListStr,"^",i)
				continue:oneARCICRowId=ARCICRowId
				i NewCatListStr="" s NewCatListStr=oneARCICRowId
				else  s NewCatListStr=NewCatListStr_"^"_oneARCICRowId
			}
		}
		i Coninfo="" s Coninfo=id_$C(1)_NewCatListStr
		else  s Coninfo=Coninfo_$C(2)_id_$C(1)_NewCatListStr
	}
	Q:Coninfo="" 0
	Q ##class(web.DHCDocConfig).SaveConfig(Coninfo,HospId)
}

}
