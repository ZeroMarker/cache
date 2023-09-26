Import SQLUser

/// *****************************************************
/// CLASS说明:取质控配置表数据,检查数据合法性
/// *****************************************************
Class web.DHCWMRQuality.BOACRExpBaseConfig Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 110;

/// ************************************
/// 说明        ：模板ID取病历内容
/// 入参        ：
/// TemplateID  ：模板ID
/// 返回值      ：ret=病历内容
/// 调试        ：w ##Class(web.DHCWMRQuality.BOACRExpBaseConfig).GetEPRContent(TemplateID)
/// ************************************
ClassMethod GetEPRContent(TemplateID As %String) As %String
{
	n (TemplateID)
	s ret=""
	q:TemplateID="" ret
	s WECTRowid=$o(^DHCWMREPRCT(0,"TemplateID",TemplateID,"Y",0))
	q:WECTRowid="" ret
	s ret=$g(^DHCWMREPRCT(WECTRowid))
	q ret
}

/// ************************************
/// 说明        ：模板取病历内容对应模板(ID)LIST
/// 入参        ：
/// TemplateID  ：模板ID
/// 返回值      ：ret=LIST(TemplateID)
/// 调试        ：w ##Class(web.DHCWMRQuality.BOACRExpBaseConfig).GetEPRTemIdList(TemplateID)
/// ************************************
ClassMethod GetEPRTemIdList(TemplateID As %String) As %String
{
	n (TemplateID)
	s ret=""
	q:TemplateID="" ret
	s EPRContent=$p(..GetEPRContent(TemplateID),"^",2)
	q:EPRContent="" ret
	s WECTRowid=0
	f  s WECTRowid=$o(^DHCWMREPRCT(0,"EPRContent",EPRContent,"Y",WECTRowid)) q:WECTRowid=""  d
	.s tmp=$g(^DHCWMREPRCT(WECTRowid))
	.s TemplateID=$p(tmp,"^",1)
	.q:TemplateID=""
	.s ret=ret_$lb(TemplateID)
	q ret
}

/// ************************************
/// 说明        ：病历内容取模板(ID)LIST
/// 入参        ：
/// EPRContent  ：病历内容
/// 返回值      ：ret=LIST(TemplateID)
/// 调试        ：w ##Class(web.DHCWMRQuality.BOACRExpBaseConfig).GetEPRTemIdListByCont(EPRContent)
/// ************************************
ClassMethod GetEPRTemIdListByContent(EPRContent As %String) As %String
{
	n (EPRContent)
	s ret=""
	q:EPRContent="" ret
	s WECTRowid=0
	f  s WECTRowid=$o(^DHCWMREPRCT(0,"EPRContent",EPRContent,"Y",WECTRowid)) q:WECTRowid=""  d
	.s tmp=$g(^DHCWMREPRCT(WECTRowid))
	.s TemplateID=$p(tmp,"^",1)
	.q:TemplateID=""
	.s ret=ret_$lb(TemplateID)
	q ret
}

/// ************************************
/// 说明        ：取电子病历事件配置表信息
/// 入参        ：
/// TemplateID  ：界面模板ID
/// EventType   ：事件类型
/// 返回值      ：ret=病历内容_"^"_事件类型_"^"_控制类型_"^"_评估标准ID_"^"_是否有效_"^"_备注_"^"_Text1_"^"_Text2
/// 调试        ：w ##Class(web.DHCWMRQuality.BOACRExpBaseConfig).GetEPRExamRule(TemplateID,EventType)
/// ************************************
ClassMethod GetEPRExamRule(TemplateID As %String, EventType As %String) As %String
{
	n (TemplateID,EventType)
	s ret=""
	q:(TemplateID="")||(EventType="") ret
	s EPRContent=$p(..GetEPRContent(TemplateID),"^",2)
	q:EPRContent="" ret
	s WEERRowid=$o(^DHCWMREPRER(0,"CountEvent",EPRContent,EventType,"Y",0))
	q:WEERRowid="" ret
	s ret=$g(^DHCWMREPRER(WEERRowid))
	q ret
}

/// ************************************
/// 说明        ：取电子病历事件配置表信息
/// 入参        ：
/// EPRContent  ：病历内容
/// EventType   ：事件类型
/// 返回值      ：ret=病历内容_"^"_事件类型_"^"_控制类型_"^"_评估标准ID_"^"_是否有效_"^"_备注_"^"_Text1_"^"_Text2
/// 调试        ：w ##Class(web.DHCWMRQuality.BOACRExpBaseConfig).GetEPRExamRuleByCont(EPRContent,EventType)
/// ************************************
ClassMethod GetEPRExamRuleByCont(EPRContent As %String, EventType As %String) As %String
{
	n (EPRContent,EventType)
	s ret=""
	q:(EPRContent="")||(EventType="") ret
	s WEERRowid=$o(^DHCWMREPRER(0,"CountEvent",EPRContent,EventType,"Y",0))
	q:WEERRowid="" ret
	s ret=$g(^DHCWMREPRER(WEERRowid))
	q ret
}

/// ************************************
/// 说明        ：取电子病历目录名称配置表信息
/// 入参        ：
/// CatNormName ：标准名称
/// 返回值      ：ret=目录ID_"^"_子目录序号_"^"_标准名称_"^"_是否有效_"^"_备注_"^"_Text1_"^"_Text2
/// 调试        ：w ##Class(web.DHCWMRQuality.BOACRExpBaseConfig).GetEPRCatalog(CatNormName)
/// ************************************
ClassMethod GetEPRCatalog(CatNormName As %String) As %String
{
	n (CatNormName)
	s ret=""
	q:CatNormName="" ret
	q:'$d(^DHCWMREPRCAT(0,"NormName",CatNormName,"Y")) ret
	s Rowid=$o(^DHCWMREPRCAT(0,"NormName",CatNormName,"Y",0))
	s ret=$g(^DHCWMREPRCAT(Rowid))
	q ret
}

/// ************************************
/// 说明        ：取电子病历模板单元名称配置表信息
/// 入参        ：
/// TemplateID  ：模板ID
/// ElNormName  ：标准名称
/// 返回值      ：ret=模板ID_"^"_单元ID_"^"_标准名称_"^"_是否允许为空_"^"_允许填写内容_"^"_不允许填写内容_"^"_是否有效_"^"_备注_"^"_Text1_"^"_Text2
/// 调试        ：w ##Class(web.DHCWMRQuality.BOACRExpBaseConfig).GetEPRTemplate(TemplateID,ElNormName)
/// ************************************
ClassMethod GetEPRTemplate(TemplateID As %String, ElNormName As %String) As %String
{
	n (TemplateID,ElNormName)
	s ret=""
	q:(TemplateID="")||(ElNormName="") ret
	q:'$d(^DHCWMREPRTEM(0,"TempName",TemplateID,ElNormName,"Y")) ret
	s Rowid=$o(^DHCWMREPRTEM(0,"TempName",TemplateID,ElNormName,"Y",0))
	s ret=$g(^DHCWMREPRTEM(Rowid))
	q ret
}

ClassMethod BuildExamRule()
{
	//^DHCWMREPRER(0,"CountEvent",{WEER_EPRContent},{WEER_EventType},{WEER_IsActive},{WEER_Rowid})
	s (Rowid,ControlType,ExamRule,Resume,Text1,Text2)="",IsActive="N"
	i $d(^DHCWMREPRER(0,"CountEvent",EPRContID,EventType)) d
	.s IsActive=""
	.f  s IsActive=$o(^DHCWMREPRER(0,"CountEvent",EPRContID,EventType,IsActive)) q:IsActive=""  d
	..s Rowid=0
	..f  s Rowid=$o(^DHCWMREPRER(0,"CountEvent",EPRContID,EventType,IsActive,Rowid)) q:Rowid=""  d
	...s tmp=$g(^DHCWMREPRER(Rowid))
	...s EPRContID=$p(tmp,"^",1)
	...s:EPRContID'=0 EPRContent=$p($g(^DHCWMRDIC(+EPRContID)),"^",3)
	...s EventType=$p(tmp,"^",2)
	...s ControlType=$p(tmp,"^",3)
	...s:ControlType=0 ControlType="0-控制"
	...s:ControlType=1 ControlType="1-提醒"
	...s ExamRule=$p(tmp,"^",4)
	...s IsActive=$p(tmp,"^",5)
	...s Resume=$p(tmp,"^",6)
	...s Text1=$p(tmp,"^",7)
	...s Text2=$p(tmp,"^",8)
	...s Data=$lb(Rowid,EPRContID,EPRContent,EventType,ControlType,ExamRule,IsActive,Resume,Text1,Text2)
	...s ^CacheTemp(repid,ind)=Data
	...s ind=ind+1
	e  d
	.s Data=$lb(Rowid,EPRContID,EPRContent,EventType,ControlType,ExamRule,IsActive,Resume,Text1,Text2)
	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	q
}

ClassMethod QryEPRExamRuleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEPRExamRuleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryEPRExamRuleExecute(ByRef qHandle As %Binary) As %Status
{
	//取病历内容 加“默认标准”
	s tmpEPRContent=$lb("0/默认标准")
	s ds = ##class(%Library.ResultSet).%New("web.DHCWMRQuality.BOACRExpBaseConfig:QryEPRDic")
	d ds.Execute("病历内容")
	while(ds.Next())
	{
			s tmpEPRContent=tmpEPRContent_$lb(ds.Data("Rowid")_"/"_ds.Data("Desc"))
	}
	d ds.Close()
	
	//取事件类型
	s tmpEventType=""
	s ds = ##class(%Library.ResultSet).%New("web.DHCWMRQuality.BOACRExpBaseConfig:QryEPRDic")
	d ds.Execute("事件类型")
	while(ds.Next())
	{
			s tmpEventType=tmpEventType_$lb(ds.Data("Rowid"))
	}
	d ds.Close()
	q:tmpEventType="" $$$OK
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	f Ind1=1:1:$listlength(tmpEPRContent) d
	.s EPRContID=$p($list(tmpEPRContent,Ind1),"/",1)
	.s EPRContent=$p($list(tmpEPRContent,Ind1),"/",2)
	.f Ind2=1:1:$listlength(tmpEventType) d
	..s EventType=$list(tmpEventType,Ind2)
	..q:(EPRContent="")||(EventType="")
	..d ..BuildExamRule()
	
	Quit $$$OK
}

ClassMethod QryEPRExamRuleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEPRExamRuleExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// ****************************************************************
/// 功能说明   : 取电子病历目录模板数据
/// 入参       : 
/// 出参       ：Data=$lb(Rowid,EPRContent,EventType,ControlType,ExamRule,IsActive,Resume,Text1,Text2)
/// 程序调试   : d ##Class(%ResultSet).RunQuery("web.DHCWMRQuality.BOACRExpBaseConfig","QryEPRExamRule")
/// ****************************************************************
Query QryEPRExamRule() As %Query(ROWSPEC = "Rowid:%String,EPRContID:%String,EPRContent:%String,EventType:%String,ControlType:%String,ExamRule:%String,IsActive:%String,Resume:%String,Text1:%String,Text2:%String")
{
}

ClassMethod BuildCatTem()
{
	s (Rowid,EPRContent,Resume,Text1,Text2)="",IsActive="N"
	s tmpObj=##class(EPRmeta.TemplateCategory).%OpenId(CategoryID)
	q:tmpObj=""
	s tmpParentID=tmpObj.ParentID
	s RootCatName=""
	i (+tmpParentID)'=0 d
	.s tmpObj=##class(EPRmeta.TemplateCategory).%OpenId(tmpParentID)
	.q:tmpObj=""
	.s RootCatName=tmpObj.Name
	.s ParentID=tmpObj.ParentID
	.q:(+ParentID)=0
	.s tmpObj=##class(EPRmeta.TemplateCategory).%OpenId(+ParentID)
	.q:tmpObj=""
	.s RootCatName=tmpObj.Name_" "_RootCatName
	i $d(^DHCWMREPRCT(0,"TemplateID",TemplateID)) d
	.s IsActive=""
	.f  s IsActive=$o(^DHCWMREPRCT(0,"TemplateID",TemplateID,IsActive)) q:IsActive=""  d
	..s Rowid=0
	..f  s Rowid=$o(^DHCWMREPRCT(0,"TemplateID",TemplateID,IsActive,Rowid)) q:Rowid=""  d
	...s tmp=$g(^DHCWMREPRCT(Rowid))
	...s EPRContent=$p(tmp,"^",2)
	...s Resume=$p(tmp,"^",4)
	...s Text1=$p(tmp,"^",5)
	...s Text2=$p(tmp,"^",6)
	...s Data=$lb(Rowid,TemplateID,RootCatName_"||"_CatName_"||"_CatSubName_"||"_TemName,EPRContent,IsActive,Resume,Text1,Text2)
	...s ^CacheTemp(repid,ind)=Data
	...s ind=ind+1
	e  d
	.s Data=$lb(Rowid,TemplateID,RootCatName_"||"_CatName_"||"_CatSubName_"||"_TemName,EPRContent,IsActive,Resume,Text1,Text2)
	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	q
}

ClassMethod QryEPRContentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEPRContentExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryEPRContentExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//组织根目录数据
	s ParentIDList=""
	s CategoryID=0
	f  s CategoryID=$o(^DHCEPRM.TemplateCategoryD(CategoryID)) q:CategoryID=""  d
	.s objCategory=##class(EPRmeta.TemplateCategory).%OpenId(CategoryID)
	.q:objCategory=""
	.s:((objCategory.CategoryType="Main")&&(objCategory.ParentID=0)) ParentIDList=ParentIDList_$lb(CategoryID)
	
	//取挂载目录数据
	s CategoryID=0
	f  s CategoryID=$o(^DHCEPRM.TemplateCategoryD(CategoryID)) q:CategoryID=""  d
	.s objCategory=##class(EPRmeta.TemplateCategory).%OpenId(CategoryID)
	.q:objCategory=""
	.q:((objCategory.CategoryType'="Group")&&(objCategory.CategoryType'="Normal"))
	.//q:$listfind(ParentIDList,CategoryID)
	.//s ParentID=objCategory.ParentID
	.//q:(('$listfind(ParentIDList,ParentID))&&(ParentID'=0))
	.s CatName=objCategory.Name
	.//取模板父目录数据
	.s CategorySub=0
	.f  s CategorySub=$o(^DHCEPRM.TemplateCategoryD(CategorySub)) q:CategorySub=""  d
	..s objCategorySub=##class(EPRmeta.TemplateCategory).%OpenId(CategorySub)
	..q:objCategorySub=""
	..q:objCategorySub.ParentID'=CategoryID
	..s CatSubName=objCategorySub.Name
	..//取模板数据
	..s TemplateID=0
	..f  s TemplateID=$o(^DHCEPRM.TemplateD(TemplateID)) q:TemplateID=""  d
	...s objTemplate=##class(EPRmeta.Template).%OpenId(TemplateID)
	...q:objTemplate=""
	...q:objTemplate.TemplateCategoryID'=CategorySub
	...s TemName=objTemplate.Name
	...d ..BuildCatTem()
	.//取模板数据
	.s TemplateID=0
	.f  s TemplateID=$o(^DHCEPRM.TemplateD(TemplateID)) q:TemplateID=""  d
	..s objTemplate=##class(EPRmeta.Template).%OpenId(TemplateID)
	..q:objTemplate=""
	..q:objTemplate.TemplateCategoryID'=CategoryID
	..s TemName=objTemplate.Name
	..s CatSubName=" "
	..d ..BuildCatTem()
	
	Quit $$$OK
}

ClassMethod QryEPRContentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEPRContentExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// ****************************************************************
/// 功能说明   : 取电子病历目录模板数据
/// 入参       : 
/// 出参       ：Data=$lb(Rowid,TemplateID,RootCatName_"||"_CatName_"||"_CatSubName_"||"_TemName,EPRContent,IsActive,Resume,Text1,Text2)
/// 程序调试   : d ##Class(%ResultSet).RunQuery("web.DHCWMRQuality.BOACRExpBaseConfig","QryEPRContent")
/// ****************************************************************
Query QryEPRContent() As %Query(ROWSPEC = "Rowid:%String,TemplateID:%String,EPRDesc:%String,EPRContent:%String,IsActive:%String,Resume:%String,Text1:%String,Text2:%String")
{
}

ClassMethod BuildCatalog()
{
	s (Rowid,CatNormName,Resume,Text1,Text2)="",IsActive="N"
	s tmpObj=##class(EPRmeta.TemplateCategory).%OpenId(CategoryID)
	q:tmpObj=""
	s tmpParentID=tmpObj.ParentID
	s RootCatName=""
	i (+tmpParentID)'=0 d
	.s tmpObj=##class(EPRmeta.TemplateCategory).%OpenId(tmpParentID)
	.q:tmpObj=""
	.s RootCatName=tmpObj.Name
	.s ParentID=tmpObj.ParentID
	.q:(+ParentID)=0
	.s tmpObj=##class(EPRmeta.TemplateCategory).%OpenId(+ParentID)
	.q:tmpObj=""
	.s RootCatName=tmpObj.Name_" "_RootCatName
	i $d(^DHCWMREPRCAT(0,"CatSub",CategoryID,CategorySub)) d
	.s IsActive=""
	.f  s IsActive=$o(^DHCWMREPRCAT(0,"CatSub",CategoryID,CategorySub,IsActive)) q:IsActive=""  d
	..s Rowid=0
	..f  s Rowid=$o(^DHCWMREPRCAT(0,"CatSub",CategoryID,CategorySub,IsActive,Rowid)) q:Rowid=""  d
	...s tmp=$g(^DHCWMREPRCAT(Rowid))
	...s CatNormName=$p(tmp,"^",3)
	...s Resume=$p(tmp,"^",5)
	...s Text1=$p(tmp,"^",6)
	...s Text2=$p(tmp,"^",7)
	...s Data=$lb(Rowid,CategoryID,CategorySub,RootCatName_"||"_CatName_"||"_CatSubName,CatNormName,IsActive,Resume,Text1,Text2)
	...s ^CacheTemp(repid,ind)=Data
	...s ind=ind+1
	e  d
	.s Data=$lb(Rowid,CategoryID,CategorySub,RootCatName_"||"_CatName_"||"_CatSubName,CatNormName,IsActive,Resume,Text1,Text2)
	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	q
}

ClassMethod QryEPRCatalogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEPRCatalogExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryEPRCatalogExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//组织根目录数据
	s ParentIDList=""
	s CategoryID=0
	f  s CategoryID=$o(^DHCEPRM.TemplateCategoryD(CategoryID)) q:CategoryID=""  d
	.s objCategory=##class(EPRmeta.TemplateCategory).%OpenId(CategoryID)
	.q:objCategory=""
	.s:((objCategory.CategoryType="Main")&&(objCategory.ParentID=0)) ParentIDList=ParentIDList_$lb(CategoryID)
	
	//取挂载目录数据
	s CategoryID=0
	f  s CategoryID=$o(^DHCEPRM.TemplateCategoryD(CategoryID)) q:CategoryID=""  d
	.s objCategory=##class(EPRmeta.TemplateCategory).%OpenId(CategoryID)
	.q:objCategory=""
	.q:((objCategory.CategoryType'="Group")&&(objCategory.CategoryType'="Normal"))
	.//q:$listfind(ParentIDList,CategoryID)
	.//s ParentID=objCategory.ParentID
	.//q:(('$listfind(ParentIDList,ParentID))&&(ParentID'=0))
	.s CatName=objCategory.Name
	.//取模板父目录数据
	.i $d(^DHCEPRM.TemplateCategoryI("IdxParentId"," "_CategoryID)) d
	..s CategorySub=0
	..f  s CategorySub=$o(^DHCEPRM.TemplateCategoryI("IdxParentId"," "_CategoryID,CategorySub)) q:CategorySub=""  d
	...s objCategorySub=##class(EPRmeta.TemplateCategory).%OpenId(CategorySub)
	...q:objCategorySub=""
	...q:objCategorySub.ParentID'=CategoryID
	...s CatSubName=objCategorySub.Name
	...d ..BuildCatalog()
	.e  d
	..s CategorySub=CategoryID
	..s CatSubName=" "
	..d ..BuildCatalog()
	
	Quit $$$OK
}

ClassMethod QryEPRCatalogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEPRCatalogExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// ****************************************************************
/// 功能说明   : 取电子病历目录数据
/// 入参       : 
/// 出参       ：Data=$lb(Rowid,CategoryID,CategorySub,RootCatName_"||"_CatName_"||"_CatSubName,CatNormName,IsActive,Resume,Text1,Text2)
/// 程序调试   : d ##Class(%ResultSet).RunQuery("web.DHCWMRQuality.BOACRExpBaseConfig","QryEPRCatalog")
/// ****************************************************************
Query QryEPRCatalog() As %Query(ROWSPEC = "Rowid:%String,CategoryID:%String,CategorySub:%String,CatDesc:%String,CatNormName:%String,IsActive:%String,Resume:%String,Text1:%String,Text2:%String")
{
}

ClassMethod BuildElement()
{
	s (ElNormName,TrueContent,FalseContent,Resume,Text1,Text2)="",IsNull="N",IsActive="N"
	i $d(^DHCWMREPRTEM(0,"Element",TemplateID,ElementCode)) d
	.//q      //过滤掉已经定义好名称的单元
	.s Rowid=0
	.f  s Rowid=$o(^DHCWMREPRTEM(0,"Element",TemplateID,ElementCode,Rowid)) q:Rowid=""  d
	..s tmp=$g(^DHCWMREPRTEM(Rowid))
	..q:tmp=""
	..s ElNormName=$p(tmp,"^",3)
	..s IsNull=$p(tmp,"^",4)
	..s TrueContent=$p(tmp,"^",5)
	..s FalseContent=$p(tmp,"^",6)
	..s IsActive=$p(tmp,"^",7)
	..s Resume=$p(tmp,"^",8)
	..s Text1=$p(tmp,"^",9)
	..s Text2=$p(tmp,"^",10)
	..s Data=$lb(Rowid,TemplateID,ElementCode,ElDesc,ElNormName,IsNull,TrueContent,FalseContent,IsActive,Resume,Text1,Text2)
	..s ^CacheTemp(repid,ind)=Data
	..s ind=ind+1
	e  d
	.s Data=$lb(Rowid,TemplateID,ElementCode,ElDesc,ElNormName,IsNull,TrueContent,FalseContent,IsActive,Resume,Text1,Text2)
	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	q
}

ClassMethod QryEPRElementClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEPRElementExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryEPRElementExecute(ByRef qHandle As %Binary, CatalogID As %String, CatalogSub As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	q:(CatalogID="")||(CatalogSub="") $$$OK
	s:CatalogSub'=CatalogID CatID=CatalogSub
	s:CatalogSub=CatalogID CatID=CatalogID
	q:'$d(^DHCEPRM.TemplateI("IndexCategoryId"," "_CatID))
	s TemplateID=0
	f  s TemplateID=$o(^DHCEPRM.TemplateI("IndexCategoryId"," "_CatID,TemplateID)) q:TemplateID=""  d
	.s ElementCode=""
	.f  s ElementCode=$o(^DHCWMREPRELCODE(TemplateID,ElementCode)) q:ElementCode=""  d
	..q:$p(ElementCode,"CODE:",3)'=""     //过滤掉双Code模板单元
	..s ElDesc=$g(^DHCWMREPRELCODE(TemplateID,ElementCode))
	..q:ElDesc["作废"                     //过滤掉作废模板单元
	..d ..BuildElement()
	
	Quit $$$OK
}

ClassMethod QryEPRElementFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEPRElementExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// ****************************************************************
/// 功能说明   : 取电子病历单元Code数据
/// 入参       : 
/// 出参       ：Data=$lb(Rowid,TemplateID,ElementCode,ElDesc,ElNormName,TrueContent,FalseContent,Resume,Text1,Text2)
/// 程序调试   : d ##Class(%ResultSet).RunQuery("web.DHCWMRQuality.BOACRExpBaseConfig","QryEPRElement")
/// ****************************************************************
Query QryEPRElement(CatalogID As %String, CatalogSub As %String) As %Query(ROWSPEC = "Rowid:%String,TemplateID:%String,ElementCode:%String,ElDesc:%String,ElNormName:%String,IsNull:%String,TrueContent:%String,FalseContent:%String,IsActive:%String,Resume:%String,Text1:%String,Text2:%String")
{
}

ClassMethod QryEPRDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEPRDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryEPRDicExecute(ByRef qHandle As %Binary, Type As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	i Type="病历内容" d
	.s EPRContent=..GetContentDic()
	.f Ind=1:1:$listlength(EPRContent) d
	..s tmpCont=$list(EPRContent,Ind)
	..s Data=$lb($p(tmpCont,"/",1),$p(tmpCont,"/",3))
	..s ^CacheTemp(repid,ind)=Data
	..s ind=ind+1
	
	i Type="事件类型" d
	.s EventType=$lb("Save","Print","Prompt")
	.f Ind=1:1:$listlength(EventType) d
	..s Data=$lb($list(EventType,Ind),$list(EventType,Ind))
	..s ^CacheTemp(repid,ind)=Data
	..s ind=ind+1
	
	i Type="控制类型" d
	.s ControlType=$lb("0-控制","1-提醒")
	.f Ind=1:1:$listlength(ControlType) d
	..s Data=$lb($list(ControlType,Ind),$list(ControlType,Ind))
	..s ^CacheTemp(repid,ind)=Data
	..s ind=ind+1
	
	Quit $$$OK
}

ClassMethod QryEPRDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEPRDicExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// ****************************************************************
/// 功能说明   : 取维护电子病历数据字典
/// 入参       : 
/// 出参       ：
/// 程序调试   : d ##Class(%ResultSet).RunQuery("web.DHCWMRQuality.BOACRExpBaseConfig","QryEPRDic",Type)
/// ****************************************************************
Query QryEPRDic(Type As %String) As %Query(ROWSPEC = "Rowid:%String,Desc:%String")
{
}

ClassMethod GetContentDic()
{
	n
	s ret=""
	s ds = ##class(%Library.ResultSet).%New("web.DHCWMRCommon.Dictionary:QueryDic")
	d ds.Execute("","QualityEPRContent","Y")
	while(ds.Next())
	{
		s tmp=ds.Data("DicId")_"/"_ds.Data("DicCode")_"/"_ds.Data("DicDesc")
		s ret=ret_$lb(tmp)
	}
	d ds.Close()
	q ret
}

/// 0、电子病历病历内容标准名称维护   DHC_WMR_EPRContent
ClassMethod UpdateEPRContent(InStr)
{
	n (InStr)
	q:InStr="" -1
	s $p(InStr,"^",3)=+$p(InStr,"^",3)
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
	s ret=$$UpdateEPRContent^DHCWMREPRBase(InStr)
	zn CurrentNS
	q ret
}

/// 1、电子病历事件参数设置   DHC_WMR_EPRExamRule
ClassMethod UpdateEPRExamRule(InStr)
{
	n (InStr)
	q:InStr="" -1
	s $p(InStr,"^",2)=+$p(InStr,"^",2)
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
	s ret=$$UpdateEPRExamRule^DHCWMREPRBase(InStr)
	zn CurrentNS
	q ret
}

/// 2、电子病历目录标准名称维护   DHC_WMR_EPRCatalog
ClassMethod UpdateEPRCatalog(InStr)
{
	n (InStr)
	q:InStr="" -1
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
	s ret=$$UpdateEPRCatalog^DHCWMREPRBase(InStr)
	zn CurrentNS
	q ret
}

/// 3、电子病历模板单元标准名称维护   DHC_WMR_EPRTemplate
ClassMethod UpdateEPRElement(InStr)
{
	n (InStr)
	q:InStr="" -1
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
	s ret=$$UpdateEPRTemplate^DHCWMREPRBase(InStr)
	zn CurrentNS
	q ret
}

}
