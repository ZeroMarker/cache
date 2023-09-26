/// PDA科室模板配置
/// 2018-0328
/// lmm
Class web.DHCNurPdaDepModelSet Extends %Persistent
{

/// Creator: 		lmm
/// CreatDate: 		2018-03-28
/// Description: 	取科室	
/// Input			""
/// Return：		""
/// Method			w ##class(web.DHCNurPdaDepModelSet).getLocJson()
ClassMethod getLocJson() As %String
{
	
	w "{rowData:["
	w "{locName:"""_"通用"_""",commonFlag:"""_"Y"_""",locId:"""_"common"_"""}"
	s locId=""
	f  s locId=$o(^CTLOC(locId)) q:locId=""  d
	.s locName=$p(^CTLOC(locId),"^",2)  
	.i $p(locName,"-",2)'="" s locName=$p(locName,"-",2)
	.i $d(^DHCNurPdaLocComFlag(locId)) s commonFlag=^DHCNurPdaLocComFlag(locId)
	.e  s commonFlag="Y" 
	.s locType=$p(^CTLOC(locId),"^",13)  
	.q:locType'="W"
	.w ",{locName:"""_locName_""",commonFlag:"""_commonFlag_""",locId:"""_locId_"""}"
	w "]}"
	q ""
}

/// Creator: 		lmm
/// CreatDate: 		2018-03-28
/// Description: 	取护理病历模板	
/// Input			""
/// Return：		""
/// Method			w ##class(web.DHCNurPdaDepModelSet).getModelListJson()
ClassMethod getModelListJson() As %String
{
	s firstRow=1
	w "{rowData:["
	s kCode=""
	s DepModelStrPDA=$G(^DHCNurDepModelSet("PDA"))
	f ii=1:1:$L(DepModelStrPDA) d
	.s DepModel=$P(DepModelStrPDA,"^",ii)
	.q:DepModel=""
	.s modelCode=$P(DepModel,"|",1)
	.s modelName=$P(DepModel,"|",2)
	.i firstRow=1 w "{modelCode:"""_modelCode_""",modelName:"""_modelName_"""}"
	.e  w ",{modelCode:"""_modelCode_""",modelName:"""_modelName_"""}"
	.s firstRow=0
	w "]}"
	q ""
}

/// Creator: 		lmm
/// CreatDate: 		2018-03-28
/// Description: 	取护理病历模板	
/// Input			""
/// Return：		""
/// Method			w ##class(web.DHCNurPdaDepModelSet).getModelList()
ClassMethod getModelList(funname) As %String
{
	s modelStr="^DHCNURXHNEWRYPG^DHCNURXH2^"
	s kCode=""
	f  s kCode=$o(^NurEmr.NurEmrSubI("KCode",kCode)) q:kCode=""  d
	.s id=""
	.f  s id=$o(^NurEmr.NurEmrSubI("KCode",kCode,id)) q:id=""  d
	..s modelName=$List(^NurEmr.NurEmrSubD(id),4)
	..s modelCode=$List(^NurEmr.NurEmrSubD(id),7)
	..q:modelStr'[("^"_modelCode_"^")
	..s rtnval=funname_"('"_$ZCVT($g(modelCode),"O","JS")_"','"_$ZCVT($g(modelName),"O","JS")_"');"
	..&javascript<#(rtnval)#>
	q ""
}

/// Creator: 		lmm
/// CreatDate: 		2018-03-28
/// Description: 	取根目录	
/// Input			""
/// Return：		""
/// Method			w ##class(web.DHCNurPdaDepModelSet).getMenuList()
ClassMethod getMenuList(funname) As %String
{
	s id=""
	f  s id=$o(^Nur.DHCNurPdaEmrMenuD(id)) q:id=""  d
	.s menuData=^Nur.DHCNurPdaEmrMenuD(id)
	.s sort=$listget(menuData,4)
	.s menuID(sort,id)=1
	s sort=""
	f  s sort=$o(menuID(sort)) q:sort=""  d
	.s menuID=""
	.f  s menuID=$o(menuID(sort,menuID)) q:menuID=""  d
	..s menuData=$g(^Nur.DHCNurPdaEmrMenuD(menuID))
	..s menuName=$listget(menuData,2)
	..s menuCode=$listget(menuData,3)
	..s menuSort=$listget(menuData,4)
	..s canFlag=$listget(menuData,5)
	..q:canFlag'="Y"
	..s rtnval=funname_"('"_$ZCVT($g(menuID),"O","JS")_"','"_$ZCVT($g(menuName),"O","JS")_"');"
	..&javascript<#(rtnval)#>
	q ""
}

/// Creator: 		lms
/// CreatDate: 		2019-07-25
/// Description: 	取模板配置	
/// Input			""
/// Return：		""
/// Method			w ##class(web.DHCNurPdaDepModelSet).getModelJson()
ClassMethod getModelJson() As %String
{
	s id=""
	f  s id=$o(^Nur.DHCNurPdaEmrModelD(id)) q:id=""  d
	.s modelData=^Nur.DHCNurPdaEmrModelD(id)
	.s sort=$listget(modelData,4)
	.i sort="" s sort=999999
	.s modelID(sort,id)=1
	s firstRow=1
	w "{rowData:["
	s sort=""
	f  s sort=$o(modelID(sort)) q:sort=""  d
	.s modelID=""
	.f  s modelID=$o(modelID(sort,modelID)) q:modelID=""  d
	..s modelData=$g(^Nur.DHCNurPdaEmrModelD(modelID))
	..s modelName=$listget(modelData,2)
	..s modelCode=$listget(modelData,3)
	..s modelSort=$listget(modelData,4)
	..s modelCanFlag=$listget(modelData,5)
	..i firstRow=1 w "{modelName:"""_modelName_""",modelCode:"""_modelCode_""",modelSort:"""_modelSort_""",modelCanFlag:"""_modelCanFlag_""",modelID:"""_modelID_"""}"
	..e   w ",{modelName:"""_modelName_""",modelCode:"""_modelCode_""",modelSort:"""_modelSort_""",modelCanFlag:"""_modelCanFlag_""",modelID:"""_modelID_"""}"
	..s firstRow=0
	w "]}"
	q ""
}

/// Creator: 		lmm
/// CreatDate: 		2018-03-28
/// Description: 	取根目录	
/// Input			""
/// Return：		""
/// Method			w ##class(web.DHCNurPdaDepModelSet).getMenuJson()
ClassMethod getMenuJson() As %String
{
	s id=""
	f  s id=$o(^Nur.DHCNurPdaEmrMenuD(id)) q:id=""  d
	.s menuData=^Nur.DHCNurPdaEmrMenuD(id)
	.s sort=$listget(menuData,4)
	.s menuID(sort,id)=1
	s firstRow=1
	w "{rowData:["
	s sort=""
	f  s sort=$o(menuID(sort)) q:sort=""  d
	.s menuID=""
	.f  s menuID=$o(menuID(sort,menuID)) q:menuID=""  d
	..s menuData=$g(^Nur.DHCNurPdaEmrMenuD(menuID))
	..s menuName=$listget(menuData,2)
	..s menuCode=$listget(menuData,3)
	..s menuSort=$listget(menuData,4)
	..s canFlag=$listget(menuData,5)
	..i firstRow=1 w "{menuName:"""_menuName_""",menuCode:"""_menuCode_""",menuSort:"""_menuSort_""",canFlag:"""_canFlag_""",menuID:"""_menuID_"""}"
	..e   w ",{menuName:"""_menuName_""",menuCode:"""_menuCode_""",menuSort:"""_menuSort_""",canFlag:"""_canFlag_""",menuID:"""_menuID_"""}"
	..s firstRow=0
	w "]}"
	q ""
}

/// Creator: 		lmm
/// CreatDate: 		2018-03-28
/// Description: 	取根目录(PDA用)	
/// Input			""
/// Return：		""
/// Method			w ##class(web.DHCNurPdaDepModelSet).getSetBylocToPda()
ClassMethod getSetBylocToPda(locId, adm)
{
	s menus=##class(%ListOfDataTypes).%New() 
	s locId="common"
	s locId=$ZConvert(locId,"U")
	s id=""
	f  s id=$o(^Nur.DHCNurPdaDepModelSetI("locIndex"," "_locId,id)) q:id=""  d
	.s setDta=^Nur.DHCNurPdaDepModelSetD(id)
	.s menuId=$listget(setDta,4)
	.q:menuId=""
	.s menuData=^Nur.DHCNurPdaEmrMenuD(menuId)
	.s sort=$listget(menuData,4)
	.s setID(sort,menuId,id)=1
	s sort=""
	s returnSum=0
	f  s sort=$o(setID(sort)) q:sort=""  d
	.s menuId=""
	.f  s menuId=$o(setID(sort,menuId)) q:menuId=""  d
	..s menuData=^Nur.DHCNurPdaEmrMenuD(menuId)
	..s menuName=$listget(menuData,2)
	..s menuSubs=##class(%ListOfDataTypes).%New() 
	..s setId=""
	..f  s setId=$o(setID(sort,menuId,setId)) q:setId=""  d
	...s setDta=$g(^Nur.DHCNurPdaDepModelSetD(setId))
	...s modelCode=$listget(setDta,3)
	...s modelName=..getEmrDescByCode(modelCode)
	...s menuId=$listget(setDta,4)
	...q:menuId=""
	...s saved=1
	...s menuSub=##class(%ArrayOfDataTypes).%New()
	...d menuSub.SetAt(menuName,"menuName")
	...d menuSub.SetAt(modelName,"modelName")
	...d menuSub.SetAt(modelCode,"modelCode")
	...d menuSub.SetAt(saved,"saved")
	...d menuSub.SetAt("","modelNote")
	...d menuSub.SetAt(111,"modelType")
	...d menuSubs.Insert(menuSub)
	..s menu=##class(%ArrayOfDataTypes).%New()
	..d menu.SetAt(menuName,"menuName")
	..d menu.SetAt(menuSubs,"menuSubs")
	..d menus.Insert(menu)
	..s returnSum=returnSum+1
	s json=##class(%ArrayOfDataTypes).%New()
	d json.SetAt($g(menus),"rows")
	d json.SetAt($g(returnSum),"returnSum")
	q ##class(Nur.JSON).Encode(json)
}

/// Creator: 		lmm
/// CreatDate: 		2018-03-28
/// Description: 	设置科室是否取通用配置	
/// Input			""
/// Return：		""
/// Method			w ##class(web.DHCNurPdaDepModelSet).setLocComFlag(locId,flag)
ClassMethod setLocComFlag(locId, flag) As %String
{
	s ^DHCNurPdaLocComFlag(locId)=flag
	q ""
}

/// Creator: 		lmm
/// CreatDate: 		2018-03-28
/// Description: 	取模板关联科室配置	
/// Input			""
/// Return：		""
/// Method			w ##class(web.DHCNurPdaDepModelSet).getSetByloc()
ClassMethod getSetByloc(locId) As %String
{
	s locId=$ZConvert(locId,"U")
	s id=""
	f  s id=$o(^Nur.DHCNurPdaDepModelSetI("locIndex"," "_locId,id)) q:id=""  d
	.s setDta=^Nur.DHCNurPdaDepModelSetD(id)
	.s menuId=$listget(setDta,4)
	.q:menuId=""
	.q:'$d(^Nur.DHCNurPdaEmrMenuD(menuId))
	.s menuData=^Nur.DHCNurPdaEmrMenuD(menuId)
	.s sort=$listget(menuData,4)
	.s setID(sort,id)=1
	.b
	s firstRow=1
	w "{rowData:["
	s sort="",preMenuName=""
	f  s sort=$o(setID(sort)) q:sort=""  d
	.s setId=""
	.f  s setId=$o(setID(sort,setId)) q:setId=""  d
	..s setDta=$g(^Nur.DHCNurPdaDepModelSetD(setId))
	..s modelCode=$listget(setDta,3)
	..s modelName=..getEmrDescByCode(modelCode)
	..s menuId=$listget(setDta,4)
	..q:menuId=""
	..s menuData=^Nur.DHCNurPdaEmrMenuD(menuId)
	..s menuName=$listget(menuData,2)
	..i menuName=preMenuName&&(preMenuName'="") s menuName=""
	..s preMenuName=$listget(menuData,2)
	..s modelType=$listget(setDta,9)
	..i modelType=1 s modelType="记录单"
	..i modelType=2 s modelType="评估单"
	..i modelType=3 s modelType="多次评估单"
	..i firstRow=1 w "{menuName:"""_menuName_""",modelName:"""_modelName_""",modelCode:"""_modelCode_""",setId:"""_setId_""",modelType:"""_modelType_"""}" 
	..e   w ",{menuName:"""_menuName_""",modelName:"""_modelName_""",modelCode:"""_modelCode_""",setId:"""_setId_""",modelType:"""_modelType_"""}"
	..s firstRow=0
	w "]}"
	q ""
}

/// Creator: 		lmm
/// CreatDate: 		2018-03-28
/// Description: 	通过模板CODE获取模板名称	
/// Input			模板CODE
/// Return：		模板名称
/// Method			w ##class(web.DHCNurPdaDepModelSet).getEmrDescByCode()
ClassMethod getEmrDescByCode(EmrCode) As %String
{
	s code=$ZConvert(EmrCode,"U")
    s id=$O(^NurEmr.NurEmrSubI("KCode"," "_code,""))
    q:id="" ""
    s a=##class(NurEmr.NurEmrSub).%OpenId(id)
	q a.EmrSubDesc
}

/// Creator: 		lmm
/// CreatDate: 		2018-03-28
/// Description: 	取根目录	
/// Input			""
/// Return：		""
/// Method			
ClassMethod getPlanJson() As %String
{
	
	s id=""
	f  s id=$o(^Nur.DHCNurPdaEmrMenuD(id)) q:id=""  d
	.s menuData=^Nur.DHCNurPdaEmrMenuD(id)
	.s sort=$listget(menuData,4)
	.s menuID(sort,id)=1
	s firstRow=1
	w "{rowData:["
	s sort=""
	f  s sort=$o(menuID(sort)) q:sort=""  d
	.s planID=""
	.f  s planID=$o(menuID(sort,planID)) q:planID=""  d
	..s menuData=$g(^Nur.DHCNurPdaEmrMenuD(planID))
	..s menuName=$listget(menuData,2)
	..s menuCode=$listget(menuData,3)
	..s menuSort=$listget(menuData,4)
	..s canFlag=$listget(menuData,5)
	..i firstRow=1 w "{planName:"""_menuName_""",planMeasure:"""_menuCode_""",planID:"""_planID_"""}"
	..e   w ",{planName:"""_menuName_""",planMeasure:"""_menuCode_""",planID:"""_planID_"""}"
	..s firstRow=0
	w "]}"
	q ""
}

/// Creator: 		lmm
/// CreatDate: 		2018-03-28
/// Description: 	根据配置ID 取配置信息	
/// Input			""
/// Return：		""
/// Method			
ClassMethod getModelSetInfoById(setId) As %String
{
	s setDta=$g(^Nur.DHCNurPdaDepModelSetD(setId))
	s modelCode=$listget(setDta,3)
	s modelName=..getEmrDescByCode(modelCode)
	s menuId=$listget(setDta,4)
	q:menuId="" ""
	s menuData=^Nur.DHCNurPdaEmrMenuD(menuId)
	s menuName=$listget(menuData,2)
	s modelType=$listget(setDta,9)
	s Linkmodel=$listget(setDta,10)
	s showName=$listget(setDta,8)
	s modelNum=$listget(setDta,11)
	s getValMth=$listget(setDta,12)
	s getListMth=$listget(setDta,13)
	s saveMth=$listget(setDta,14)
	q modelCode_"^"_menuId_"^"_showName_"^"_modelType_"^"_Linkmodel_"^"_modelNum_"^"_getValMth_"^"_getListMth_"^"_saveMth
}

/// Creator: 		lmm
/// CreatDate: 		2018-03-28
/// Description: 	取根目录	
/// Input			""
/// Return：		""
/// Method	   	    d ##class(%ResultSet).RunQuery("web.DHCNurPdaDepModelSet","GetPatList","13")
ClassMethod GetPatListExecute(ByRef qHandle As %Binary, WardIdr As %String, EpisodeID As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	
	k ^TMPPAT("PDAPAT")
	s room="" 
	f  s room=$O(^PAADMi("CurrWard",WardIdr,room)) q:room=""  d
	.s adm=""  f  s adm=$O(^PAADMi("CurrWard",WardIdr,room,adm)) q:adm=""  d
	..s VistStatus=$P(^PAADM(adm),"^",20)
	..q:VistStatus="D"
	..q:(EpisodeID'="")
	..s Papmidr=$P(^PAADM(adm),"^",1)
	..s PatName=$P(^PAPER(Papmidr,"ALL"),"^",1)
	..s PatRegNo=$P(^PAPER(Papmidr,"PAT",1),"^",1)
	..s bedSub=$p($g(^PAADM(adm)),"^",73)
	..q:bedSub=""
	..s curWardId=$P(bedSub,"||",1)
	..s curBedSub=$P(bedSub,"||",2)
	..s bedCode=$p($g(^PAWARD(curWardId,"BED",curBedSub)),"^",1) //床号
	..s patinfo=bedCode_" "_PatName
	..s bedCode=$tr(bedCode,"+",".")
	..i +bedCode'=0  d
	...s bedCode=+bedCode
	...s bedCode=bedCode*100
	..s ^TMPPAT("PDAPAT",bedCode)=adm_"^"_patinfo_"^"_PatRegNo
	i EpisodeID'=""  d
	.s adm=EpisodeID
	.s Papmidr=$P(^PAADM(adm),"^",1)
	.s PatName=$P(^PAPER(Papmidr,"ALL"),"^",1)
	.s PatRegNo=$P(^PAPER(Papmidr,"PAT",1),"^",1)
	.s bedSub=$p($g(^PAADM(adm)),"^",73)
	.i bedSub="" s bedCode="空床"
	.e  d
	..s curWardId=$P(bedSub,"||",1)
	..s curBedSub=$P(bedSub,"||",2)
	..s bedCode=$p($g(^PAWARD(curWardId,"BED",curBedSub)),"^",1) //床号
	.s patinfo=bedCode_" "_PatName
	.s bedCode=$tr(bedCode,"+",".")
	.i +bedCode'=0  d
	..s bedCode=+bedCode
	..s bedCode=bedCode*100
	.s ^TMPPAT("PDAPAT",bedCode)=adm_"^"_patinfo_"^"_PatRegNo
	s bedid=""
	f  s bedid=$o(^TMPPAT("PDAPAT",bedid)) q:bedid=""  d
	.s adm=$p(^TMPPAT("PDAPAT",bedid),"^",1)
	.s patinfo=$p(^TMPPAT("PDAPAT",bedid),"^",2)
	.s PatRegNo=$p(^TMPPAT("PDAPAT",bedid),"^",3)
	.d OutPutPat
	Set qHandle=$lb(0,repid,0)
	k TMP($zn,$j)
	Quit $$$OK
	

	
OutPutPat
	s Data=$lb(adm,patinfo,PatRegNo)      
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatListExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

/// by LMM 2017-06-09
Query GetPatList(WardIdr As %String, EpisodeID As %String = "") As %Query(ROWSPEC = "adm:%String,patinfo:%String,PatRegNo:%String")
{
}

ClassMethod GetPatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator: 		lmm
/// CreatDate: 		2018-08-20
/// Description: 	取模板元素配置	
/// Input			""
/// Return：		""
/// Method			w ##class(web.DHCNurPdaDepModelSet).getItemSetByEmrCode("DHCNURPGD_BDY5SYCFXPGHLD")
ClassMethod getItemSetByEmrCode(emrCode) As %String
{
	s emrCode=$ZConvert(emrCode,"U")
	s ^MML("getItemSetByEmrCode")=emrCode
	s firstRow=1
	w "{rowData:["
	s id=""
	f  s id=$o(^Nur.DHCNurPdaModelSetI("EmrCode"," "_emrCode,id)) q:id=""  d
	.s setDta=^Nur.DHCNurPdaModelSetD(id)
	.s itemCode=$listget(setDta,3)
	.s linkCode=$listget(setDta,4)
	.s linkType=$listget(setDta,5)
	.s linkNote=$listget(setDta,6)
	.s linkType=$s(linkType=1:"赋值",linkType=2:"联动",linkType=3:"跳转",linkType=4:"必填项",linkType=5:"数字键",linkType=6:"不可编辑",linkType=7:"语音代码",linkType=8:"平铺",linkType=9:"单选",linkType=10:"联动2",linkType=11:"说明联动")
	.i firstRow=1 w "{emrCode:"""_emrCode_""",itemCode:"""_itemCode_""",linkCode:"""_linkCode_""",linkType:"""_linkType_""",linkNote:"""_linkNote_""",setId:"""_id_"""}" 
	.e   w ",{emrCode:"""_emrCode_""",itemCode:"""_itemCode_""",linkCode:"""_linkCode_""",linkType:"""_linkType_""",linkNote:"""_linkNote_""",setId:"""_id_"""}" 
	.s firstRow=0
	w "]}"
	q ""
}

/// Creator: 		lmm
/// CreatDate: 		2018-03-28
/// Description: 	取模板元素配置信息	
/// Input			""
/// Return：		""
/// Method			
ClassMethod getItemSetInfoById(setId) As %String
{
	q:'$d(^Nur.DHCNurPdaModelSetD(setId)) ""
	s setDta=$g(^Nur.DHCNurPdaModelSetD(setId))
	s itemCode=$listget(setDta,3)
	s linkCode=$listget(setDta,4)
	s linkType=$listget(setDta,5)
	s linkNote=$listget(setDta,6)
	q itemCode_"^"_linkCode_"^"_linkType_"^"_linkNote
}

Storage Default
{
<Data name="DHCNurPdaDepModelSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCNurPdaDepModelSetD</DataLocation>
<DefaultData>DHCNurPdaDepModelSetDefaultData</DefaultData>
<IdLocation>^web.DHCNurPdaDepModelSetD</IdLocation>
<IndexLocation>^web.DHCNurPdaDepModelSetI</IndexLocation>
<StreamLocation>^web.DHCNurPdaDepModelSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
