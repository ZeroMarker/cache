/// 科室问题描述维护配置
/// MRK
/// 2018-4-2
Class web.DHCNurQMPage Extends %RegisteredObject
{

/// Creator: 		mrk
/// CreatDate: 		2018-04-3
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
	.i $d(^DHCNurQMLocComFlag(locId)) s commonFlag=^DHCNurQMLocComFlag(locId)
	.e  s commonFlag="Y" 
	.s locType=$p(^CTLOC(locId),"^",13)  
	.q:locType'="W"
	.w ",{locName:"""_locName_""",commonFlag:"""_commonFlag_""",locId:"""_locId_"""}"
	w "]}"
	q ""
}

/// Creator: 		mrk
/// CreatDate: 		2018-04-3
/// Description: 	取护理病历模板	
/// Input			""
/// Return：		""
/// Method			w ##class(web.DHCNurPdaDepModelSet).getModelListJson()
ClassMethod getModelListJson() As %String
{
	s modelStr="^DHCNURPGD_SCHLJL^DHCNURBG_HLJLDTY^DHCNURBG_SNKFMTXD^DHCNURBG_CHHLJLD^DHCNURXH_YBHLJLD^DHCNURPGD_BDY5SYCFXPGHLD^"
	s firstRow=1
	w "{rowData:["
	s kCode=""
	f  s kCode=$o(^NurEmr.NurEmrSubI("KCode",kCode)) q:kCode=""  d
	.s id=""
	.f  s id=$o(^NurEmr.NurEmrSubI("KCode",kCode,id)) q:id=""  d
	..s modelName=$List(^NurEmr.NurEmrSubD(id),4)
	..s modelCode=$List(^NurEmr.NurEmrSubD(id),7)
	..q:modelStr'[("^"_modelCode_"^")
	..i firstRow=1 w "{modelCode:"""_modelCode_""",modelName:"""_modelName_"""}"
	..e  w ",{modelCode:"""_modelCode_""",modelName:"""_modelName_"""}"
	..s firstRow=0
	w "]}"
	q ""
}

/// Creator: 		mrk
/// CreatDate: 		2018-04-3
/// Description: 	取护理病历模板	
/// Input			""
/// Return：		""
/// Method			w ##class(web.DHCNurPdaDepModelSet).getModelList()
ClassMethod getModelList(funname) As %String
{
	s modelStr="^DHCNURPGD_SCHLJL^DHCNURBG_HLJLDTY^DHCNURBG_SNKFMTXD^DHCNURBG_CHHLJLD^DHCNURXH_YBHLJLD^DHCNURPGD_BDY5SYCFXPGHLD^"
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

/// Creator: 		mrk
/// CreatDate: 		2018-04-3
/// Description: 	取根目录	
/// Input			""
/// Return：		""
/// Method			w ##class(web.DHCNurQMPage).getMenuList()
ClassMethod getMenuList(funname) As %String
{
	s id=""
	f  s id=$o(^Nur.DHCNurQMEmrMenuD(id)) q:id=""  d
	.s menuData=^Nur.DHCNurQMEmrMenuD(id)
	.s sort=$listget(menuData,3)
	.s menuID(sort,id)=1
	s sort=""
	f  s sort=$o(menuID(sort)) q:sort=""  d
	.s menuID=""
	.f  s menuID=$o(menuID(sort,menuID)) q:menuID=""  d
	..s menuData=$g(^Nur.DHCNurQMEmrMenuD(menuID))
	..s menuName=$listget(menuData,2)
	..s menuSort=$listget(menuData,3)
	..s canFlag=$listget(menuData,4)
	..q:canFlag'="Y"
	..s rtnval=funname_"('"_$ZCVT($g(menuID),"O","JS")_"','"_$ZCVT($g(menuName),"O","JS")_"');"
	..&javascript<#(rtnval)#>
	q ""
}

/// Creator: 		mrk
/// CreatDate: 		2018-04-2
/// Description: 	取根目录	
/// Input			""
/// Return：		""
/// Method			w ##class(web.DHCNurQMPage).getMenuJson()
ClassMethod getMenuJson() As %String
{
	
	s id=""
	f  s id=$o(^Nur.DHCNurQMEmrMenuD(id)) q:id=""  d
	.s menuData=^Nur.DHCNurQMEmrMenuD(id)
	.s sort=$listget(menuData,3)
	.i sort=""  d
	..s sort="N"
	.s menuID(sort,id)=1
	s firstRow=1
	w "{rowData:["
	s sort=""
	f  s sort=$o(menuID(sort)) q:sort=""  d
	.s menuID=""
	.f  s menuID=$o(menuID(sort,menuID)) q:menuID=""  d
	..s menuData=$g(^Nur.DHCNurQMEmrMenuD(menuID))
	..s menuName=$listget(menuData,2)
	..s menuSort=$listget(menuData,3)
	..s canFlag=$listget(menuData,4)
	..i firstRow=1 w "{QuestionName:"""_menuName_""",MenuSort:"""_menuSort_""",CanFlag:"""_canFlag_""",menuID:"""_menuID_"""}"
	..e   w ",{QuestionName:"""_menuName_""",MenuSort:"""_menuSort_""",CanFlag:"""_canFlag_""",menuID:"""_menuID_"""}"
	..s firstRow=0
	w "]}"
	q ""
}

/// Creator: 		mrk
/// CreatDate: 		2018-04-3
/// Description: 	取护理问题和措施	
/// Input			""
/// Return：		""
/// Method			w ##class(web.DHCNurQMPage).getMenuNurseJson()
ClassMethod getMenuNurseJson(filterDesc As %String = "") As %String
{
	
	;s locId=$ZConvert(locId,"U")
	s id=""
	f  s id=$o(^Nur.DHCNurQMDescD(id)) q:id=""  d
	.s setDta=^Nur.DHCNurQMDescD(id)
	.s menuId=$listget(setDta,3)
	.s menuData=^Nur.DHCNurQMEmrMenuD(menuId)
	.s Sort=menuId
	.s setID(Sort,id)=1
	.b
	s firstRow=1
	w "{rowData:["
	s sort="",preMenuName=""
	f  s sort=$o(setID(sort)) q:sort=""  d
	.s setId=""
	.f  s setId=$o(setID(sort,setId)) q:setId=""  d
	..s setDta=$g(^Nur.DHCNurQMDescD(setId))
	..s menuId=$listget(setDta,3)
	..s menuData=^Nur.DHCNurQMEmrMenuD(menuId)
	..s Question=$listget(menuData,2)
	..;i Question=preMenuName&&(preMenuName'="") s Question=""
	..s QuestionDesc=$listget(setDta,4)
	..s preMenuName=$listget(menuData,2)
	..q:Question'[filterDesc
	..i firstRow=1 w "{planName:"""_Question_""",planMeasure:"""_QuestionDesc_""",planID:"""_setId_"""}"
	..e   w ",{planName:"""_Question_""",planMeasure:"""_QuestionDesc_""",planID:"""_setId_"""}"
	..s firstRow=0
	w "]}"
	q ""
}

/// Creator: 		mrk
/// CreatDate: 		2018-04-3
/// Description: 	设置科室是否取通用配置	
/// Input			""
/// Return：		""
/// Method			w ##class(web.DHCNurPdaDepModelSet).setLocComFlag(locId,flag)
ClassMethod setLocComFlag(locId, flag) As %String
{
	s ^DHCNurQMLocComFlag(locId)=flag
	q ""
}

/// Creator: 		mrk
/// CreatDate: 		2018-04-2
/// Description: 	取问题关联科室配置	
/// Input			""
/// Return：		""
/// Method			w ##class(web.DHCNurQMPage).getSetByloc("common")
ClassMethod getSetByloc(locId) As %String
{
	s locId=$ZConvert(locId,"U")
	s id=""
	f  s id=$o(^Nur.DHCNurQMDescI("LocIndex"," "_locId,id)) q:id=""  d
	.s setDta=^Nur.DHCNurQMDescD(id)
	.s menuId=$listget(setDta,3)
	.s menuData=^Nur.DHCNurQMEmrMenuD(menuId)
	.s Sort=$listget(setDta,2)
	.i Sort=""  d
	..s Sort="N"
	.s setID(menuId,Sort,id)=1
	s firstRow=1
	w "{rowData:["
	s menuId=""
	f  s menuId=$o(setID(menuId)) q:menuId=""  d
	.s sort="",preMenuName=""
	.f  s sort=$o(setID(menuId,sort)) q:sort=""  d
	..s setId=""
	..f  s setId=$o(setID(menuId,sort,setId)) q:setId=""  d
	...s setDta=$g(^Nur.DHCNurQMDescD(setId))
	...s menuId=$listget(setDta,3)
	...s menuData=^Nur.DHCNurQMEmrMenuD(menuId)
	...s Question=$listget(menuData,2)
	...i Question=preMenuName&&(preMenuName'="") s Question=""
	...s QuestionDesc=$listget(setDta,4)
	...s preMenuName=$listget(menuData,2)
	...i firstRow=1 w "{Question:"""_Question_""",QuestionDesc:"""_QuestionDesc_""",sort:"""_sort_""",setId:"""_setId_"""}"
	...e   w ",{Question:"""_Question_""",QuestionDesc:"""_QuestionDesc_""",sort:"""_sort_""",setId:"""_setId_"""}"
	...s firstRow=0
	w "]}"
	q ""
}

/// Creator: 		mrk
/// CreatDate: 		2018-04-3
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

/// 通过自定义措施ID查找诊断ID
ClassMethod DetailsSearchMenuID(setId)
{
	s setData=^Nur.DHCNurQMDescDetailsD(setId)
	s MenuId=$listget(setData,2)
	q MenuId
}

/// 查找诊断ID
ClassMethod SeachMenuID(setId)
{
	s setData=^Nur.DHCNurQMDescD(setId)
	s MenuId=$listget(setData,3)
	q MenuId
}

/// Creator: 		mrk
/// CreatDate: 		2018-04-10
/// Description: 	取该科室自定义措施	
/// Input			科室ID:LocId，诊断ID:MenuId，措施ID:DescId
/// Return：		
/// Method:			w ##class(web.DHCNurQMPage).getSetByDesc("^12^11")			
ClassMethod getSetByDesc(TotalDescId)
{
	s TotalDescId=$ZConvert(TotalDescId,"U") 
	s length=$l(TotalDescId,"^")
	
	s firstRow=1
	;s preMenuName=""
	w "{rowData:["
	f i=2:1:length  d
	.s DescId=$p(TotalDescId,"^",i)
	.s id=""
	.f  s id=$o(^Nur.DHCNurQMDescDetailsI("DescIndex"," "_DescId,id)) q:id=""  d
	..s setDta=$g(^Nur.DHCNurQMDescDetailsD(id))
	..s DescData=^Nur.DHCNurQMDescD(DescId)
	..s Question=$listget(DescData,4)
	..;i Question=preMenuName&&(preMenuName'="") s Question=""
	..s QuestionDesc=$listget(setDta,4)
	..;s preMenuName=$listget(DescData,4)
	..i firstRow=1 w "{planName:"""_Question_""",planMeasure:"""_QuestionDesc_""",planID:"""_id_"""}"
	..e   w ",{planName:"""_Question_""",planMeasure:"""_QuestionDesc_""",planID:"""_id_"""}"
	..s firstRow=0
	w "]}"
	q ""
}

/// Creator: 		mrk
/// CreatDate: 		2018-04-12
/// Description: 	查询该患者的诊断所有措施	
/// Input			就诊号:EpisodeID 诊断名:Diagnosis  停止人:RecAuditUser
/// Return：		
/// Method:			w ##class(web.DHCNurQMPage).getDiagnosis("2194391","menuId","护士")	
ClassMethod getDiagnosis(EpisodeID, menuId, RecAuditUser)
{
	s rw=""  
	s rw=$O(^Nur.DHCNurseRecParentI("Episode"," "_EpisodeID,rw)) ;查询父类ID
	
	s Date=$p($h,",",1)
	s Time=$P($h,",",2)
	s rowid=""
	f  s rowid=$O(^Nur.DHCNurseRecSubI("DiagnosisIdIndex",rw," "_menuId,rowid)) q:rowid=""  d
	.s setDta=$g(^Nur.DHCNurseRecSubD(rw,rowid))
	.s Desc=$listget(setDta,18)
	.s a=##class(Nur.DHCNurseRecSub).%OpenId(rw_"||"_rowid)
	.i a.Item48=""  d
	..s a.Item48=$zd(Date,3)
	..s a.Item49=$zt(Time,2)
	..s a.Item47=RecAuditUser
	..d a.%Save()
	q ""
}

ClassMethod SearchQuestionName(menuId)
{
		s Data=$g(^Nur.DHCNurQMEmrMenuD(menuId))
		s QuestionName=$listget(Data,2)
		q QuestionName
}

/// Creator: 		mrk
/// CreatDate: 		2018-04-12
/// Description: 	获取最大顺序号	
/// Input			
/// Return：		
/// Method:			w ##class(web.DHCNurQMPage).getLastSortNo()	
ClassMethod getLastSortNo()
{
	k menuID
	s id=""
	f  s id=$o(^Nur.DHCNurQMEmrMenuD(id)) q:id=""  d
	.s menuData=^Nur.DHCNurQMEmrMenuD(id)
	.s sort=$listget(menuData,3)
	.s menuID(sort)=1
	s lastSort=$o(menuID(""),-1)
	q +lastSort+1
}

/// Creator: 		mrk
/// CreatDate: 		2018-04-12
/// Description: 	通过描述获取诊断ID和最大序号
/// Input			
/// Return：		
/// Method:			w ##class(web.DHCNurQMPage).getMenuIdBydesc("活动无耐力")	
ClassMethod getMenuIdBydesc(desc)
{
	s id="",curId=""
	f  s id=$o(^Nur.DHCNurQMEmrMenuD(id)) q:id=""  d
	.s menuData=^Nur.DHCNurQMEmrMenuD(id)
	.s menuName=$listget(menuData,2)
	.i menuName=desc s curId=id
	q:curId="" "^"
	k menuID
	s id="",lasrtSort=""
	f  s id=$o(^Nur.DHCNurQMDescD(id)) q:id=""  d
	.s setDta=^Nur.DHCNurQMDescD(id)
	.s menuId=$listget(setDta,3)
	.q:menuId'=curId
	.s menuData=^Nur.DHCNurQMEmrMenuD(menuId)
	.s sort=$listget(setDta,2)
	.s menuID(sort)=1
	s lastSort=$o(menuID(""),-1)
	q curId_"^"_(+lastSort+1)
}

}
