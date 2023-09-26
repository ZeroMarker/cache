/// 名称: 健康评估模块 公有数据维护
/// 编写者：wangguoying
/// 编写日期: 2021-08-12
Class web.DHCPE.CT.HM.CommonData Extends %RegisteredObject
{

/// Description: 查询问卷量表主题
/// Input:			
/// 				Param：代码或描述  模糊匹配
/// Return:
/// Creator:	wangguoying
/// CreateDate:	2021-08-12
/// Debug：d ##class(%ResultSet).RunQuery("web.DHCPE.CT.HM.CommonData","QuerySubject","") 
Query QuerySubject(Param As %Library.String = "") As websys.Query(ROWSPEC = "TID:%String,TCode:%String,TDesc:%String,TActive:%String,TRemark:%String") [ SqlProc ]
{
}

ClassMethod QuerySubjectExecute(ByRef qHandle As %Binary, Param As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s id = ""
 	f  s id = $O(^CT.PE.HM.CQDSubjectD(id)) q:id=""  d
 	.s code = $lg(^CT.PE.HM.CQDSubjectD(id),2)
 	.s desc = $lg(^CT.PE.HM.CQDSubjectD(id),3)
 	.q:(Param'="")&&($$ALPHAUP^SSUTIL4(code)'[$$ALPHAUP^SSUTIL4(Param))&&(desc'[Param)
	.s active = $lg(^CT.PE.HM.CQDSubjectD(id),4)
	.s remark = $lg(^CT.PE.HM.CQDSubjectD(id),8)
	.d OutputSubject
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputSubject
    set Data=$lb(id,code,desc,active,remark)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Description:保存问卷量表(主题)
/// Input:   
/// 				ID：DHC_HM_CQDSubject
/// 				Properties：属性集合
/// 				ValStr：值集合
/// 				UserID：操作员ID
/// Return:		0^ID 非0^失败
/// Creator:	wangguoying
/// CreateDate:	2021-08-12
/// Debug: w ##class(web.DHCPE.CT.HM.CommonData).SaveSubject(1)
ClassMethod SaveSubject(ID, Properties, ValStr, UserID = "")
{
	i UserID = ""
	{
		s:$D(%session) UserID = %session.Get("LOGON.USERID")
		s:UserID="" UserID=1
	}
	s Properties = Properties_"^QDSUpdateDate^QDSUpdateTime^QDSUpdateUserDR"
	s ValStr = ValStr_"^"_+$H_"^"_$P($H,",",2)_"^"_UserID
	s ret = ##class(User.DHCHMCQDSubject).SaveData(ID,ValStr,Properties)
	q:+ret<0 ret
	q 0_"^"_+ret
}

/// Description:保存问卷量表(主题)问题分类
/// Input:   
/// 				ID：DHC_HM_CQDSubjectCat
/// 				Properties：属性集合
/// 				ValStr：值集合
/// 				UserID：操作员ID
/// Return:		0^ID 非0^失败
/// Creator:	zhufei
/// CreateDate:	2021-12-21
/// Debug: w ##class(web.DHCPE.CT.HM.CommonData).SaveSubjectCat(1)
ClassMethod SaveSubjectCat(ID, Properties, ValStr, UserID = "")
{
	i UserID = ""
	{
		s:$D(%session) UserID = %session.Get("LOGON.USERID")
		s:UserID="" UserID=1
	}
	s Properties = Properties_"^QDSCUpdateDate^QDSCUpdateTime^QDSCUpdateUserDR"
	s ValStr = ValStr_"^"_+$H_"^"_$P($H,",",2)_"^"_UserID
	s ret = ##class(User.DHCHMCQDSubjectCat).SaveData(ID,ValStr,Properties)
	q:+ret<0 ret
	q 0_"^"_+ret
}

/// Description: 查询问卷量表主题与问题关联关系
/// Input:			
/// 				ParRef：  DHC_HM_CQDSubject
/// Return:
/// Creator:	wangguoying
/// CreateDate:	2021-08-12
/// Debug：d ##class(%ResultSet).RunQuery("web.DHCPE.CT.HM.CommonData","QuerySubjectDetailLink",1)
Query QuerySubjectDetailLink(ParRef As %Library.String = "", aCatID As %String = "") As websys.Query(ROWSPEC = "TID:%String,TDetailID:%String,TDetailCode:%String,TDetailDesc:%String,TSort:%String,TActive:%String,TType:%String,TCatID:%String,TCatDesc:%String,TRequired:%String,TDefvalue:%String,TNumber:%String") [ SqlProc ]
{
}

ClassMethod QuerySubjectDetailLinkExecute(ByRef qHandle As %Binary, ParRef As %Library.String = "", aCatID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	Quit:ParRef="" $$$OK
 	
 	Set xSort=""
	For {
		Set xSort=$o(^CT.PE.HM.CQDSubjectI("DTL","IndexParRefSort",ParRef,xSort))
		Quit:xSort=""
		
		Set xSub=0
		For {
			Set xSub=$o(^CT.PE.HM.CQDSubjectI("DTL","IndexParRefSort",ParRef,xSort,xSub))
			Quit:xSub=""
			
			Set ID=ParRef_"||"_xSub
			Set objCQDS=##class(User.DHCHMCQDSubjectDtl).GetObjById(ID)
			Continue:'$IsObject(objCQDS)
			Continue:'$IsObject(objCQDS.QDSDQustionDetailDR)
			//Continue:objCQDS.QDSDQustionDetailDR.QDActive'="Y"
			
			Set Active=objCQDS.QDSDActive
			Set DetailID=objCQDS.QDSDQustionDetailDR.%Id()
			Set DetailCode=objCQDS.QDSDQustionDetailDR.QDCode
			Set DetailDesc=objCQDS.QDSDQustionDetailDR.QDDesc
			Set DetailType=objCQDS.QDSDQustionDetailDR.QDType
			Set Sort=objCQDS.QDSDSort
			Set (CatID,CatDesc)=""
			If $IsObject(objCQDS.QDSDSubjectCatDR){
				Set CatID=objCQDS.QDSDSubjectCatDR.%Id()
				Set CatDesc=objCQDS.QDSDSubjectCatDR.QDSCDesc
			}
			Continue:(aCatID'="")&&(aCatID'=CatID)
			Set Required=objCQDS.QDSDRequired
			Set Defvalue=objCQDS.QDSDDefvalue
			Set Number=objCQDS.QDSDNumber
			
			Set Data=$lb(ID,DetailID,DetailCode,DetailDesc,Sort,Active,DetailType,CatID,CatDesc,Required,Defvalue,Number)
		 	Set ^CacheTemp(repid,ind)=Data
		 	Set ind=ind+1
		}
	}
	Quit $$$OK
}

/// Description: 查询问卷量表问题分类
/// Input:			
/// 				ParRef：  DHC_HM_CQDSubjectCat
/// Return:
/// Creator:	zhufei
/// CreateDate:	2021-12-22
/// Debug：d ##class(%ResultSet).RunQuery("web.DHCPE.CT.HM.CommonData","QuerySubjectCat",1)
Query QuerySubjectCat(ParRef As %Library.String = "") As websys.Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,Number:%String,Sort:%String,Active:%String") [ SqlProc ]
{
}

ClassMethod QuerySubjectCatExecute(ByRef qHandle As %Binary, ParRef As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	Quit:ParRef="" $$$OK
 	
 	Set xSort=""
	For {
		Set xSort=$o(^CT.PE.HM.CQDSubjectI("CAT","IdxOfParRefSort",ParRef,xSort))
		Quit:xSort=""
		
		Set xSub=0
		For {
			Set xSub=$o(^CT.PE.HM.CQDSubjectI("CAT","IdxOfParRefSort",ParRef,xSort,xSub))
			Quit:xSub=""
			
			Set ID=ParRef_"||"_xSub
			Set objSC=##class(User.DHCHMCQDSubjectCat).GetObjById(ID)
			Continue:'$IsObject(objSC)
			
			Set Code = objSC.QDSCCode
			Set Desc = objSC.QDSCDesc
			Set Number = objSC.QDSCNumber
			Set Sort = objSC.QDSCSort
			Set Active = objSC.QDSCActive
			
			Set Data=$lb(ID,Code,Desc,Number,Sort,Active)
		 	Set ^CacheTemp(repid,ind)=Data
		 	Set ind=ind+1
		}
	}
	Quit $$$OK
}

/// Description: 查询问卷基本内容
/// Input:			
/// 				Code：编码
/// 				Desc：描述
/// 				Type：问题类型
/// 				Sex：性别
/// 				LinkCode：关联码
/// 				Active：激活
/// Return:
/// Creator:	wangguoying
/// CreateDate:	2021-08-13
/// Debug：d ##class(%ResultSet).RunQuery("web.DHCPE.CT.HM.CommonData","QueryQDetail","") 
Query QueryQDetail(Code = "", Desc = "", Type = "", Sex = "", LinkCode = "", Active = "") As websys.Query(ROWSPEC = "QDID:%String:QDID,QDActive:%String:QDActive,QDCode:%String:QDCode,QDDesc:%String:QDDesc,QDElementNum:%String:QDElementNum,QDLinkCode:%String:QDLinkCode,QDNote:%String:QDNote,QDRemark:%String:QDRemark,QDRequired:%String:QDRequired,QDSex:%String:QDSex,QDType:%String:QDType,QDUnit:%String:QDUnit,QDLinkDesc:%String,QDLinkUnit:%String,QDLinkBreak:%String,QDMaxValue:%String,QDMinValue:%String,QDRangeMax:%String,QDRangeMin:%String")
{
}

ClassMethod QueryQDetailExecute(ByRef qHandle As %Binary, Code = "", Desc = "", Type = "", Sex = "", LinkCode = "", Active = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s index = 1
 	Set qHandle=$lb(0,repid,0)
	s ID=0
	f  s ID=$o(^User.DHCHMCQuestionsDetailD(ID)) quit:ID=""  d
	.d BuildDataFindQDetail
	Quit $$$OK
BuildDataFindQDetail
	d ResetVariablesFindQDetail
	s obj=##class(User.DHCHMCQuestionsDetail).%OpenId(ID)
	s QDActive = obj.QDActive
	q:(Active'="")&&(QDActive'=Active)
	s QDCode = obj.QDCode
	q:(Code'="")&&(QDCode'[Code)
	s QDDesc = obj.QDDesc
	q:(Desc'="")&&(QDDesc'[Desc)
	s QDElementNum = obj.QDElementNum
	s QDLinkCode = obj.QDLinkCode
	q:(LinkCode'="")&&(QDLinkCode'[LinkCode)
	s QDNote = obj.QDNote
	s QDRemark = obj.QDRemark
	s QDRequired = obj.QDRequired
	
	s QDSex = obj.QDSex
	s QDType = obj.QDType
	s QDUnit = obj.QDUnit
	s QDLinkDesc = obj.QDLinkDesc
	s QDLinkUnit = obj.QDLinkUnit
	s QDLinkBreak = obj.QDLinkBreak
	s QDMaxVal = obj.QDMaxValue
	s QDMinVal = obj.QDMinValue
	s QDRangMax = obj.QDRangeMax
	s QDRangMin = obj.QDRangeMin
	d obj.%Close()
	d OutputRowFindQDetail
	quit
OutputRowFindQDetail
	s Data=$lb(ID,QDActive,QDCode,QDDesc,QDElementNum,QDLinkCode,QDNote,QDRemark,QDRequired,QDSex,QDType,QDUnit,QDLinkDesc,QDLinkUnit,QDLinkBreak,QDMaxVal,QDMinVal,QDRangMax,QDRangMin)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesFindQDetail
	s (QDActive,QDCode,QDDesc,QDElementNum,QDLinkCode,QDNote,QDRemark,QDRequired,QDSex,QDType,QDUnit,QDLinkDesc,QDLinkUnit,QDLinkBreak,QDMaxVal,QDMinVal,QDRangMax,QDRangMin)=""
	quit
}

/// Description:查询问卷基本内容列表树
/// Input:   
/// 				SubjectId：DHC_HM_CQDSubject
/// 				QSubjectId：DHCHMCQuestionSubject
/// 				Param：代码或描述 
/// Return:		JSON数组
/// Creator:	wangguoying
/// CreateDate:	2021-08-13
/// Debug: w ##class(web.DHCPE.CT.HM.CommonData).GetDetailTree("")
ClassMethod GetDetailTree(SubjectId = "", QSubjectId = "", Param = "")
{
	s retArr = []
	s hadChecks = "^"
	i SubjectId'=""
	{
		s rs=##class(%ResultSet).%New("web.DHCPE.CT.HM.CommonData:QuerySubjectDetailLink") 
		d rs.Execute(SubjectId)
		while(rs.Next()){
			s dId = rs.Get("TDetailID")
			s hadChecks = hadChecks_dId_"^"
		}
	}elseif QSubjectId'=""{
		s rs=##class(%ResultSet).%New("web.DHCHM.QuestionnaireSet:FindCSDLink") 
		d rs.Execute(QSubjectId)
		while(rs.Next()){
			s dId = rs.Get("SDLQuestionsDetailDR")
			s hadChecks = hadChecks_dId_"^"
		}
	}
	s:hadChecks="^" hadChecks="" 
	s sbStat = "open"
	//遍历量表
	s sbId = ""
	f  s sbId = $O(^CT.PE.HM.CQDSubjectD(sbId)) q:sbId=""  d
 	.s desc = $lg(^CT.PE.HM.CQDSubjectD(sbId),3)
	.s active = $lg(^CT.PE.HM.CQDSubjectD(sbId),4)
	.q:active'="Y"
	.s sbObj = {}
	.s sbObj.id = sbId
	.s sbObj.text = desc
	.s sbObj.type = "Subject"
	.s sbObj.checked = 0
	.s sbObj.sysDefault = 0  //系统默认选中
	.i sbId = SubjectId d
	..s sbObj.text = "<label style=""color:blue;font-weight:700;"">"_desc_"</label>"
	..s sbObj.sysDefault = 1
	..s sbObj.checked = 1
	.s sbChildren = []
	.d SetSBChildren
	.s sbObj.children = sbChildren
	.i sbChildren.%Size()>0  d
	..s sbObj.state = sbStat  
	..s:sbStat="open" sbStat="closed"	//只展开第一个有记录的分类
	..d retArr.%Push(sbObj)
	
	//遍历未分类数据
	
	s sbObj = {}
	s sbObj.id = "NoType"
	s sbObj.text = "未分类"
	s sbObj.type = "Subject"
	s sbObj.sysDefault = 0  
	s sbChildren = []
	s rs=##class(%ResultSet).%New("web.DHCPE.CT.HM.CommonData:QueryQDetail") 
	d rs.Execute()
	while(rs.Next()){
		s detailId = rs.Get("QDID")
		continue:$D(^CT.PE.HM.CQDSubjectI("DTL","IndexDetailParRef",detailId))  //已分类
		d SetDetailObj
	}
	s sbObj.children = sbChildren
	i sbChildren.%Size()>0  d
	.s sbObj.state = sbStat  
	.s:sbStat="open" sbStat="closed"	//只展开第一个有记录的分类
	.d retArr.%Push(sbObj)
	q retArr.%ToJSON()
SetSBChildren	
	//遍历关联问卷
	s sort = ""
 	f  s sort = $o(^CT.PE.HM.CQDSubjectI("DTL","IndexParRefSort",sbId,sort))  q:sort=""  d
 	.s sub = ""
 	.f  s sub = $o(^CT.PE.HM.CQDSubjectI("DTL","IndexParRefSort",sbId,sort,sub))  q:sub=""  d
 	..s linkId = sbId_"||"_sub
 	..s active = $lg(^CT.PE.HM.CQDSubjectD(sbId,"DTL",sub),3)
 	..q:active'="Y"	 //	未激活的关联关系
 	..s detailId = $lg(^CT.PE.HM.CQDSubjectD(sbId,"DTL",sub),2)	
 	..d SetDetailObj
	q
SetDetailObj
	
	s detailActive = $lg(^User.DHCHMCQuestionsDetailD(detailId),2)
 	q:detailActive'="Y"	//问题本身没激活的  直接过滤
 	s detailCode = $lg(^User.DHCHMCQuestionsDetailD(detailId),3)
 	s detailDesc = $lg(^User.DHCHMCQuestionsDetailD(detailId),4)
 	s parentId = $lg(^User.DHCHMCQuestionsDetailD(detailId),23)  //父层
	q:parentId'=""  
	s children =  ..GetDetailChildren(detailId,hadChecks,Param)	
	q:(children.%Size()=0)&&(Param'="")&&($$ALPHAUP^SSUTIL4(detailCode)'[$$ALPHAUP^SSUTIL4(Param))&&(detailDesc'[Param)
	s detailObj = {}
	s detailObj.id = detailId
	s detailObj.text = detailDesc
	s detailObj.sysDefault = 0 
	s detailObj.checked = $CASE((hadChecks'="")&&(hadChecks[("^"_detailId_"^")),1:1,0:0)
	i detailObj.checked = 1  s detailObj.sysDefault = 1
	i children.%Size()=0 d  //再无子节点了
	.s detailObj.type = "Detail"	
	e  d
	.s detailObj.type = "DetailParent"
	.s detailObj.children = children
	d sbChildren.%Push(detailObj)
	q
}

/// Description:查询问题子集
/// Input:   
/// 				HadChecks：已选择的问题
/// 				DetaiID：问题ID
/// 				Param：代码或描述 
/// Return:		%ArrayOfObjects
/// Creator:	wangguoying
/// CreateDate:	2021-08-13
/// Debug: w ##class(web.DHCPE.CT.HM.CommonData).GetDetailTree("")
ClassMethod GetDetailChildren(DetaiID, HadChecks = "", Param = "") As %ArrayOfObjects
{
	s ret = []
	s id = ""
	f  s id = $O(^User.DHCHMCQuestionsDetailI("IndexParentDR",DetaiID,id))  q:id=""  d	
 	.s detailActive = $lg(^User.DHCHMCQuestionsDetailD(id),2)
 	.q:detailActive'="Y"	
 	.s detailCode = $lg(^User.DHCHMCQuestionsDetailD(id),3)
 	.s detailDesc = $lg(^User.DHCHMCQuestionsDetailD(id),4)
	.s children = ..GetDetailChildren(id,HadChecks,DetaiID)  //递归查找子集
	.q:(children.%Size()=0)&&(Param'="")&&($$ALPHAUP^SSUTIL4(detailCode)'[$$ALPHAUP^SSUTIL4(Param))&&(detailDesc'[Param)
	.s obj = {}
	.s obj.id = id
	.s obj.text = detailDesc
	.s obj.sysDefault = 0 
	.s obj.checked = $CASE((HadChecks'="")&&(HadChecks[("^"_id_"^")),1:1,0:0)
	.i obj.checked = 1 s obj.sysDefault = 1
	
	.i children.%Size()=0 d  //再无子节点了
	..s obj.type = "Detail"
	.e  d 
	..s obj.type = "DetailParent"
	..s obj.children = children
	.d ret.%Push(obj)
	q ret
}

/// Description:保存问卷量表与问题的关联关系
/// Input:   
/// 					CatDr: DHC_HM_CQDSubjectCat
/// 				InString：关联ID^问题ID^激活^序号$C(0)
/// 				UserID：操作员ID
/// Return:		0^成功 非0^失败
/// Creator:	wangguoying
/// CreateDate:	2021-08-12
/// Debug: w ##class(web.DHCPE.CT.HM.CommonData).SaveSDLink("1||1","^188^Y^20","18853")
ClassMethod SaveSDLink(CatDr, InString, UserID = "")
{
	s ^tmpwgy("SaveSDLink")=$lb(CatDr, InString, UserID)
	i UserID = ""
	{
		s:$D(%session) UserID = %session.Get("LOGON.USERID")
		s:UserID="" UserID=1
	}
	s err = ""
	s Properties = "QDSDParRef^QDSDSubjectCatDR^QDSDQustionDetailDR^QDSDActive^QDSDSort^QDSDUpdateDate^QDSDUpdateTime^QDSDUpdateUserDR"
	s $zt="SaveSDLinkErr"
	TS
	f i=1:1:$L(InString,$C(0))  q:err'=""  d
	.s info = $P(InString,$C(0),i)
	.s linkId = $P(info,"^",1)
	.s detailId = $P(info,"^",2)
	.s active =  $P(info,"^",3)
	.s sort = $P(info,"^",4)
	.s ValStr = +CatDr_"^"_CatDr_"^"_detailId_"^"_active_"^"_sort_"^"_+$H_"^"_$P($H,",",2)_"^"_UserID
	.s ret = ##class(User.DHCHMCQDSubjectDtl).SaveData(linkId,ValStr,Properties)
	.i +ret<0 s err = ret q
	i err'=""  Tro  q err
	TC
	q 0
SaveSDLinkErr
	s $Zt=""
	Tro
	q "-100^"_$ZE
}

/// Description:保存问卷基本内容
/// Input:   
/// 				ID：DHC_HM_CQuestionsDetail
/// 				Properties：属性集合
/// 				ValStr：值集合
/// 				Subject： S时DHC_HM_CQDSubjectCat  QS时DHC_HM_CQDSubject
/// 				UserID：操作员ID
/// 				SubjectType：S：DHC_HM_CQDSubject  QS：DHCHMCQuestionSubject
/// Return:		0^成功 非0^失败
/// Creator:	wangguoying
/// CreateDate:	2021-08-14
/// Debug: w ##class(web.DHCPE.CT.HM.CommonData).SaveDetail(1)
ClassMethod SaveDetail(ID, Properties, ValStr, Subject As %String = "", UserID As %String = "", SubjectType As %String = "S")
{
	i UserID = ""
	{
		s:$D(%session) UserID = %session.Get("LOGON.USERID")
		s:UserID="" UserID=1
	}
	s code = $P(ValStr,"^",1)
	s oldId = $O(^User.DHCHMCQuestionsDetailI("QDCodeIndex"," "_code,"")) 
	q:(oldId'="")&&((ID="")||(oldId'=ID)) "-1^编码已存在"
	s $ZT="QDSaveErr"
	tS
	s Properties = Properties_"^QDUpdateDate^QDUpdateTime^QDUpdateUserDR"
	s ValStr = ValStr_"^"_+$H_"^"_$P($H,",",2)_"^"_UserID
	set ret=##class(User.DHCHMCQuestionsDetail).SaveData(ID,ValStr,Properties)
	i +ret<0  tro  q ret
	s detailId = +ret
	i (Subject'="")&&(ID="")
	{
		i SubjectType = "S" d
		.s ret = ..SaveSDLink(Subject,"^"_detailId_"^Y^20",UserID)
		e  d
		.s ret = ..SaveQuesSDLink(Subject,"^"_detailId_"^Y^20",UserID)
		i +ret<0  tro  q ret
	}
	TC
	q 0
QDSaveErr
	s $zt=""
	Tro
	q "-100^"_$ZE
}

/// Description:获取问卷基本内容
/// Input:   
/// 				DetailID：DHC_HM_CQuestionsDetail
/// Return:		
/// Creator:	wangguoying
/// CreateDate:	2021-08-14
/// Debug: w ##class(web.DHCPE.CT.HM.CommonData).GetDetailJSON(1)
ClassMethod GetDetailJSON(DetailID)
{
	s obj = ##class(User.DHCHMCQuestionsDetail).%OpenId(DetailID)
	s extJson = ##class(ext.util.JsonObject).%New()
	s extJson.ContainNullValue = 1
	q ##class(ext.util.JsonObject).ObjToJson(obj,"",extJson)
}

/// Description: 查询问卷列表（使用数据，只有授权的科室才显示）
/// Input:		
/// Return:
/// Creator:	wangguoying
/// CreateDate:	2021-08-15
/// Debug：d ##class(%ResultSet).RunQuery("web.DHCPE.CT.HM.CommonData","FindQuestionnaire","")
Query FindQuestionnaire(LocID As %String = "", Active = "") As websys.Query(ROWSPEC = "QNID:%String:ID,QActive:%String:QActive,QCode:%String:QCode,QDesc:%String:QDesc,QRemark:%String:QRemark,QType:%String:QType")
{
}

ClassMethod FindQuestionnaireExecute(ByRef qHandle As %Binary, LocID As %String = "", Active = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1

	s ID=0
	f  s ID=$o(^User.DHCHMCQuestionnaireD(ID))  quit:ID=""  d
	.s powerFlg="Y"
	.i LocID'="" s powerFlg = ##class(User.DHCHMCQuestionnaire).GetLocShowDataFlag(ID , LocID)
	.q:powerFlg'="Y"
	.d BuildDataFindQuestion
	Quit $$$OK
BuildDataFindQuestion
	d ResetVariablesFindQuestion
	s obj=##class(User.DHCHMCQuestionnaire).%OpenId(ID)
	s QActive = obj.QActive
	q:(Active'="")&&(QActive'=Active)
	i QActive = "Y" s QActive = "true"
	e  s QActive = "false"
	s QCode = obj.QCode
	s QDesc = obj.QDesc
	s QRemark = obj.QRemark
	s QType = obj.QType
	d OutputRowFindQuestion
	quit
OutputRowFindQuestion
	s Data=$lb(ID,QActive,QCode,QDesc,QRemark,QType)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesFindQuestion
	s (QActive,QCode,QDesc,QRemark,QType)=""
	quit
}

/// Description: 查询问卷列表(维护数据，显示所有数据)
/// Input:		
/// Return:
/// Creator:	xueying
/// CreateDate:	2021-11-26
/// Debug：d ##class(%ResultSet).RunQuery("web.DHCPE.CT.HM.CommonData","FindQuestionnaireNew","152")
Query FindQuestionnaireNew(LocID As %String = "", Active = "") As websys.Query(ROWSPEC = "QNID:%String:ID,QActive:%String:QActive,QCode:%String:QCode,QDesc:%String:QDesc,QRemark:%String:QRemark,QType:%String:QType,TEmpower,TEffPowerFlag")
{
}

ClassMethod FindQuestionnaireNewExecute(ByRef qHandle As %Binary, LocID As %String = "", Active = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1

	s ID=0
	f  s ID=$o(^User.DHCHMCQuestionnaireD(ID))  quit:ID=""  d
	.d BuildDataFindQuestionNew
	Quit $$$OK
BuildDataFindQuestionNew
	d ResetVariablesFindQuestionNew
	s obj=##class(User.DHCHMCQuestionnaire).%OpenId(ID)
	s QActive = obj.QActive
	q:(Active'="")&&(QActive'=Active)
	i QActive = "Y" s QActive = "true"
	e  s QActive = "false"
	s QCode = obj.QCode
	s QDesc = obj.QDesc
	s QRemark = obj.QRemark
	s QType = obj.QType
    s LocShowDFlag=##class(User.DHCHMCQuestionnaire).GetLocShowDataFlag(ID,LocID)
    q:LocShowDFlag="N"
    s EmpowerStr=##class(User.DHCHMCQuestionnaire).GetEmpowerFlag(ID,LocID)
    s Empower=$p(EmpowerStr,"^",2)
    s EffPowerFlag=$s(LocShowDFlag="Y":"Y",1:"N")
	d OutputRowFindQuestionNew
	quit
OutputRowFindQuestionNew
	s Data=$lb(ID,QActive,QCode,QDesc,QRemark,QType,Empower,EffPowerFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesFindQuestionNew
	s (QActive,QCode,QDesc,QRemark,QType,Empower,EffPowerFlag)=""
	quit
}

/// Creator： xueying
/// CreatDate： 20211221
/// Description: 判断科室组下是否有重复的服务级别代码
/// Table： 服务级别表 DHC_HM_CServiceClass
/// Input: Code(服务级别编码),LocID(科室下拉列表值) 
/// Return： 0/1
/// Dubug： w ##class(web.DHCPE.CT.HM.CommonData).IsExsSrvClass("02","152")
ClassMethod IsExsSrvClass(Code As %String, LocID As %String)
{
	s ^tempdhcpe("IsExsSrvClass")=$lb(Code,LocID)
	s flag=0
	s SrvCID=""
	f  s SrvCID=$o(^User.DHCHMCServiceClassI("SCCodeIndex"," "_Code,SrvCID)) q:(SrvCID="")||(flag=1)  d
	.s LocShowDFlag=##class(User.DHCHMCServiceClass).GetLocShowDataFlag(SrvCID,LocID)
    .q:LocShowDFlag="N"
    .i SrvCID'="" s flag=1
    q flag
}

/// Description:保存服务级别
/// Input:   
/// 				ID：DHC_HM_CServiceClass
/// 				Properties：属性集合
/// 				ValStr：值集合
/// 				LocID：授权科室
/// 				UserID：操作员ID
/// Return:		0^成功 非0^失败
/// Creator:	wangguoying
/// CreateDate:	2021-08-15
/// Debug: w ##class(web.DHCPE.CT.HM.CommonData).SaveSrvClass(1)
ClassMethod SaveSrvClass(ID, Properties, ValStr, LocID As %String = "", UserID As %String = "", Empower As %String = "N")
{
	i UserID = ""
	{
		s:$D(%session) UserID = %session.Get("LOGON.USERID")
		s:UserID="" UserID=1
	}
	s Code = $P(ValStr,"^",2)
	//q:$D(^User.DHCHMCServiceClassI("SCCodeIndex",$C(32)_Code)) "-1^代码已被使用"
	s SVCCode=""
	i ID="" d
    .s obj=##class(User.DHCHMCServiceClass).%New()
    e  d
    .s obj=##class(User.DHCHMCServiceClass).%OpenId(ID)
    .s SVCCode=$lg($g(^User.DHCHMCServiceClassD(ID)),3)
    if (SVCCode'=Code){
		//由于服务级别是私有数据，因为不同科室组下面的代码有可能是重复的,
		//因此将代码索引的唯一性去掉,采用下面的方法进行判断
   	 	s ExsistFlag= ##class(web.DHCPE.CT.HM.CommonData).IsExsSrvClass(Code,LocID)
    	q:ExsistFlag=1 "-1^代码重复!"
    }

	s $ZT="SaveSrvClassErr"
	TS
	set ret=##class(User.DHCHMCServiceClass).SaveData(ID,ValStr,Properties)
	i +ret<0  tro  q ret
	//授权
	s ret = ##class(User.DHCHMCServiceClass).SaveDataToPowerControl(+ret,LocID,UserID,Empower)
	i +ret<0  tro  q ret
	TC
	q 0
SaveSrvClassErr
	s $zt=""
	Tro
	q "-100^"_$ZE
}

/// Creator：    xueying
/// CreatDate：  20220127
/// Description: 判断科室组下是否有重复的调查问卷代码
/// Table：      调查问卷主表 DHC_HM_CQuestionnaire
/// Input:       Type(调查问卷类型),Code(调查问卷编码),LocID(科室下拉列表值) 
/// Return：     0/1
/// Dubug： w ##class(web.DHCPE.CT.HM.CommonData).IsExsQuestionnaire("HM","001","152")
ClassMethod IsExsQuestionnaire(Type As %String, Code As %String, LocID As %String)
{
	s ^tempdhcpe("sExsQuestionnaire")=$lb(Type,Code,LocID)
	s flag=0
	s CQID=""
	f  s CQID=$o(^User.DHCHMCQuestionnaireI("TypeCodeIndex"," "_Type," "_Code,CQID)) q:(CQID="")||(flag=1)  d
	.s LocShowDFlag=##class(User.DHCHMCQuestionnaire).GetLocShowDataFlag(CQID,LocID)
    .q:LocShowDFlag="N"
    .i CQID'="" s flag=1
    q flag
}

/// Description:    保存问卷
/// Input:   
/// 				ID：DHC_HM_CQuestionnaire
/// 				Properties：属性集合
/// 				ValStr：值集合
/// 				LocID：授权科室
/// 				UserID：操作员ID
/// Return:		0^成功 非0^失败
/// Creator:	wangguoying
/// CreateDate:	2021-08-15
/// Debug: w ##class(web.DHCPE.CT.HM.CommonData).SaveQuestionnaire(1)
ClassMethod SaveQuestionnaire(ID, Properties, ValStr, LocID As %String = "", UserID As %String = "", Empower As %String = "N")
{
	i UserID = ""
	{
		s:$D(%session) UserID = %session.Get("LOGON.USERID")
		s:UserID="" UserID=1
	}
	s Code = $P(ValStr,"^",2)
	s Type = $P(ValStr,"^",5)
	//q:$D(^User.DHCHMCQuestionnaireI("TypeCodeIndex",$C(32)_Type,$C(32)_Code)) "-1^编码已存在"
	s CQCode=""
	i ID="" d
    .s obj=##class(User.DHCHMCQuestionnaire).%New()
    e  d
    .s obj=##class(User.DHCHMCQuestionnaire).%OpenId(ID)
    .s CQCode=$lg($g(^User.DHCHMCQuestionnaireD(ID)),3)
    if (CQCode'=Code){
		//由于调查问卷是私有数据，因为不同科室组下面的代码有可能是重复的,
		//因此将代码索引的唯一性去掉,采用下面的方法进行判断
   	 	s ExsistFlag= ##class(web.DHCPE.CT.HM.CommonData).IsExsQuestionnaire(Type,Code,LocID)
    	q:ExsistFlag=1 "-1^编码已存在!"
    }
	
	s $ZT="SaveQuestionnaireErr"
	TS
	set ret=##class(User.DHCHMCQuestionnaire).SaveData(ID,ValStr,Properties)
	i +ret<0  tro  q ret
	//授权
	s ret = ##class(User.DHCHMCQuestionnaire).SaveDataToPowerControl(+ret,LocID,UserID,Empower)
	i +ret<0  tro  q ret
	TC
	q 0
SaveQuestionnaireErr
	s $zt=""
	Tro
	q "-100^"_$ZE
}

/// Description:保存调查问卷问题与问题的关联关系
/// Input:   
/// 				ParRef：DHCHMCQuestionSubject
/// 				InString：关联ID^问题ID^激活^序号$C(0)
/// 				UserID：操作员ID
/// Return:		0^成功 非0^失败
/// Creator:	wangguoying
/// CreateDate:	2021-08-12
/// Debug: w ##class(web.DHCPE.CT.HM.CommonData).SaveQuesSDLink(1)
ClassMethod SaveQuesSDLink(ParRef, InString, UserID = "")
{
	i UserID = ""
	{
		s:$D(%session) UserID = %session.Get("LOGON.USERID")
		s:UserID="" UserID=1
	}
	s err = ""
	s Properties = "SDLParRef^SDLQuestionsDetailDR^SDLActive^SDLOrder"
	s $zt="SaveQSDLinkErr"
	TS
	f i=1:1:$L(InString,$C(0))  q:err'=""  d
	.s info = $P(InString,$C(0),i)
	.s linkId = $P(info,"^",1)
	.s detailId = $P(info,"^",2)
	.s active =  $P(info,"^",3)
	.s sort = $P(info,"^",4)
	.s ValStr = ParRef_"^"_detailId_"^"_active_"^"_sort
	.s ret = ##class(User.DHCHMCSDLink).SaveData(linkId,ValStr,Properties)
	.i +ret<0 s err = ret q
	i err'=""  Tro  q err
	TC
	q 0
SaveQSDLinkErr
	s $Zt=""
	Tro
	q "-100^"_$ZE
}

}
