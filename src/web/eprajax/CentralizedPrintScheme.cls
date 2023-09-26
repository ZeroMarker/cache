Class web.eprajax.CentralizedPrintScheme Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s episodeID = $Get(%request.Data("EpisodeID",1),"")
	s patientID = $Get(%request.Data("PatientID",1),"")
	s schemeName = $Get(%request.Data("SchemeName",1),"")
	s schemeDesc = $Get(%request.Data("SchemeDesc",1),"")
	s schemeItems = $Get(%request.Data("SchemeItems",1),"")
	s schemeIDs = $Get(%request.Data("SchemeIDs",1),"")
	s schemeID = $Get(%request.Data("SchemeID",1),"")
	s nodeID = $Get(%request.Data("NodeID",1),"")
	s userID = $Get(%request.Data("UserID",1),"")
	s pageNumber = $Get(%request.Data("PageNumber",1),"")
	s isPageQueue = $Get(%request.Data("IsPageQueue",1),"")
	s idInfo = $Get(%request.Data("AID",1),"")
	s itemIDs = $Get(%request.Data("ItemIDs",1),"")
	s indexID = $Get(%request.Data("IndexID",1),"")
	s startDateTime = $Get(%request.Data("StartDateTime",1),"")
	s pageInfoID = $Get(%request.Data("PageInfoID",1),"")
	s action = $Get(%request.Data("Action",1),"")
	
	if (action = "getscheme"){
		d ..IsFirstTimeRun(episodeID)
		d ..GetScheme(episodeID, userID)
	}
	elseif (action = "deletescheme"){
		w ..DeleteScheme(schemeIDs, userID)
	}
	elseif (action = "setdefault"){
		w ..SetDefault(schemeID)	
	}
	elseif (action = "setdefaultpdf"){
		w ..SetDefaultPdf(schemeID)	
	}
	elseif (action = "getdefault"){
		w ..GetDefault()	
	}
	elseif (action = "additems"){
		w ..AddItems(schemeID,schemeItems,userID)
	}
	elseif (action = "deleteitems"){
		if (schemeID = "") s schemeID = ..GetDefault()
		w ..DeleteItems(schemeID,itemIDs,userID)	
	}
	elseif (action = "moveup"){
		if (schemeID = "") s schemeID = ..GetDefault()
		w ..Move(schemeID,itemIDs,userID,"up")	
	}
	elseif (action = "movedown"){
		if (schemeID = "") s schemeID = ..GetDefault()
		w ..Move(schemeID,itemIDs,userID,"down")	
	}
	elseif (action = "movetop"){
		if (schemeID = "") s schemeID = ..GetDefault()
		w ..Move(schemeID,itemIDs,userID,"top")	
	}
	elseif (action = "movebottom"){
		if (schemeID = "") s schemeID = ..GetDefault()
		w ..Move(schemeID,itemIDs,userID,"bottom")	
	}
	elseif (action = "moveupscheme"){
		w ..MoveScheme(schemeID,"up")	
	}
	elseif (action = "movedownscheme"){
		w ..MoveScheme(schemeID,"down")	
	}
	elseif (action = "setpageinfo"){
		w ..SetPageInfo(idInfo, userID, isPageQueue, pageInfoID)
	}
	elseif (action = "initpageinfo"){
		w ..InitPageInfo(userID, isPageQueue)	
	}
	elseif (action = "afterprint"){
		w ..AfterPrint(userID,episodeID,patientID,itemIDs,startDateTime,pageInfoID)	
	}
	elseif (action = "addscheme"){
		w ..AddScheme(schemeName, schemeDesc, userID)	
	}	
	elseif (action = "modifyscheme"){
		w ..ModifyScheme(schemeID, schemeName, schemeDesc, userID)	
	}
	elseif (action = "getschemeinfo"){
		w ..GetSchemeInfo()	
	}
	elseif (action = "loadschemeitems"){
		if (schemeID = "") s schemeID = ..GetDefault()
		d ..LoadSchemeItems(schemeID, episodeID, userID)	
	}
	elseif (action = "loaddefault"){
		d ..IsFirstTimeRun(episodeID)
		s schemeID = ..GetDefault()
		d ..LoadSchemeItems(schemeID, episodeID, userID)
	}
	
	Quit $$$OK
}

/// Desc:	获取所有方案
/// Input：	episodeID - 病人就诊号
/// 		userID - 操作用户ID
/// Output: 方案表格Json
/// 		SchemeID - 方案ID
/// 		SchemeName - 方案名称
/// 		SchemeDesc - 方案描述
/// 		CreateUserID - 创建者ID
/// 		CreateUserName - 创建者姓名
/// 		Order - 序列号
/// 		CreateDateTime - 方案创建日期时间
/// 		ModifyDateTime - 方案最近修改日期时间
/// 		IsDefault - 是否是当前打印方案
/// Debug: d ##class(web.eprajax.CentralizedPrintScheme).GetScheme("201868","5972")
ClassMethod GetScheme(episodeID As %String, userID As %String) As %String
{
	w "["
	s count = 0	
	s rowID = ""
	for {
		s rowID=$o(^DHCEPRM.CentralizedPrintSchemeD(rowID))
		q:rowID=""
		
		s obj = ##Class(EPRmeta.CentralizedPrint.CentralizedPrintScheme).%OpenId(rowID)
		if (obj.IsDefault '= "noDefault")
		{
			s count = count + 1
			//SchemeOrder列是后加的，为了兼容SchemeOrder为空的情况
			//若SchemeOrder为空则为当前的最大Order+1（Order一定是连续的，增加删除都会重新改变Order值来保证Order为连续）
			if (obj.SchemeOrder = ""){
				s maxNum = 0
				s order = 0
				for {
					s order = $O(^DHCEPRM.CentralizedPrintSchemeI("IdxSchemeOrder", order))
					q:(order = "") 
					s maxNum = order
				}
				s obj.SchemeOrder = maxNum + 1
				d obj.%Save()	
			}
			if (count > 1)
			{
				w ","
			} 
			w "{SchemeName:'"_obj.SchemeName_"'"
			w ",SchemeDesc:'"_obj.SchemeDesc_"'"
			s userName = ##class(EPRmeta.Privilege.PowerUser).GetUserName(obj.CreateUserID)
			w ",CreateUserID:'"_obj.CreateUserID_"'"
			w ",CreateUserName:'"_userName_"'"
			w ",SchemeID:'"_rowID_"'"
			w ",Order:'"_obj.SchemeOrder_"'"
			s CreateDate = obj.CreateDate
			if (CreateDate '= "")
			{	
				s CreateDate = $zd(CreateDate,3)
				s CreateDate = ##class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("ChangeToFormat","Date",CreateDate)
			}
			s CreateTime = obj.CreateTime
			if (CreateTime '= "")
			{	
				s CreateTime = $zt(CreateTime,3)
				s CreateTime= ##class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("ChangeToFormat","Time",CreateTime)
			}
			w ",CreateDateTime:'"_CreateDate_" "_CreateTime_"'"
			
			s ModifyDate = obj.ModifyDate
			if (ModifyDate '= "")
			{	s ModifyDate = $zd(ModifyDate,3)
				s ModifyDate = ##class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ModifyDate)
			}
			s ModifyTime = obj.ModifyTime
			if (ModifyTime '= "")
			{	
				s ModifyTime = $zt(ModifyTime,3)
				s ModifyTime= ##class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ModifyTime)
			}
			w ",ModifyDateTime:'"_ModifyDate_" "_ModifyTime_"'"
			s default = "no"
			if (obj.IsDefault = "default")
			{
				s default = "yes"
			}
			w ",IsDefault:'"_default_"'"
			s pdf = "no"
			if (obj.IsPDF = "defaultpdf")
			{
				s pdf = "yes"
			}
			w ",IsPDF:'"_pdf_"'}"
		}
		d obj.%Close()
	}
	w "]"
}

/// Desc:	新建空方案
/// Input：	ASchemeName - 方案名称
/// 		ASchemeDesc - 方案描述
/// 		AUserID - 创建者ID
/// Output: 成功- 方案ID 
/// 		失败 - -1
ClassMethod AddScheme(ASchemeName As %String, ASchemeDesc As %String, AUserID As %String) As %String
{
	s totalCount = 0
	&sql(select COUNT(*) into :totalCount from EPRmeta_CentralizedPrint.CentralizedPrintScheme where IsDefault = 'DEFAULT' or IsDefault is null)
	
	s objScheme = ##class(EPRmeta.CentralizedPrint.CentralizedPrintScheme).%New()	
	q:(objScheme="") "-1"
	
	s objScheme.SchemeName = ASchemeName
	s objScheme.SchemeDesc = ASchemeDesc
	s objScheme.CreateUserID = AUserID
	s objScheme.CreateDate = $p($H,",",1)
	s objScheme.CreateTime = $p($H,",",2)
	s objScheme.ModifyDate = $p($H,",",1)
	s objScheme.ModifyTime = $p($H,",",2)
	s objScheme.SchemeOrder = totalCount + 1
	
	s sc = objScheme.%Save()
	s id = objScheme.%Id()
	
	d objScheme.%Close()
	q:($$$ISOK(sc)) id
	q "-1"
}

/// Desc:	修改方案名称，描述
/// Input：	ASchemeID - 欲修改方案ID
/// 		ASchemeName - 方案名称
/// 		ASchemeDesc - 方案描述
/// 		AUserID - 操作者ID
/// Output: 成功 - ASchemeID_"^"_ASchemeName_"^"_ASchemeDesc
/// 		无操作权限 - "nopower"
/// 		失败 - -1
ClassMethod ModifyScheme(ASchemeID As %String, ASchemeName As %String, ASchemeDesc As %String, AUserID As %String) As %String
{
	s checkPower = "false"	
	s checkPower = ..CheckPower(ASchemeID,AUserID)
	if (checkPower = "true")
	{
		s objScheme = ##class(EPRmeta.CentralizedPrint.CentralizedPrintScheme).%OpenId(ASchemeID)
		q:(objScheme="") "-1"
		
		s objScheme.SchemeName = ASchemeName
		s objScheme.SchemeDesc = ASchemeDesc
		s objScheme.ModifyDate = $p($H,",",1)
		s objScheme.ModifyTime = $p($H,",",2)

		s sc = objScheme.%Save()
	
		d objScheme.%Close()
		q:($$$ISOK(sc)) ASchemeID_"^"_ASchemeName_"^"_ASchemeDesc
		q "-1"
	}
	else
	{
		q "nopower"	
	}
}

/// Desc:	获取当前打印方案信息
/// Input：
/// Output: 设置当前打印方案 - SchemeName^SchemeDesc^CreateUserName^CreateDateTime^ModifyDateTiem
/// 		没设置当前打印方案 - "nodefault"
ClassMethod GetSchemeInfo() As %String
{
	s schemeInfo = ""
	s count = ""
	s rowID = ""
	for {
		s rowID=$o(^DHCEPRM.CentralizedPrintSchemeD(rowID))
		q:rowID=""
		
		s obj = ##Class(EPRmeta.CentralizedPrint.CentralizedPrintScheme).%OpenId(rowID)
		if (obj.IsDefault = "default")
		{
			s count = count + 1
			s userName = ##class(EPRmeta.Privilege.PowerUser).GetUserName(obj.CreateUserID)
			s schemeInfo = obj.SchemeName_"^"_obj.SchemeDesc_"^"_userName_"^"_##class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",$ZD(obj.CreateDate,3)_" "_$ZT(obj.CreateTime))_"^"_##class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",$ZD(obj.ModifyDate,3)_" "_$ZT(obj.ModifyTime))
		}
		d obj.%Close()	
	}

	//无默认方案，
	if ((count = 0) && (schemeInfo = ""))
	{
		q "nodefault"
	}
	else
	{
		q schemeInfo	
	}
}

/// Desc:	方案中添加打印项目
/// Input：	ASchemeID - 欲添加打印项目方案ID
/// 		ASchemeItems - 添加的打印项目ID串
/// 		AUserID - 操作者ID
/// Output: 成功 - 方案ID
/// 		无操作权限 - "nopower"
/// 		失败 - -1
ClassMethod AddItems(ASchemeID As %String, ASchemeItems As %String, AUserID As %String) As %String
{
	s checkPower = "false"	
	s checkPower = ..CheckPower(ASchemeID,AUserID)
	if (checkPower = "true")
	{
		s objScheme = ##class(EPRmeta.CentralizedPrint.CentralizedPrintScheme).%OpenId(ASchemeID)
		q:(objScheme="") "-1"
		
		if (objScheme.SchemeItems = ""){
			s objScheme.SchemeItems = ASchemeItems
		}
		else
		{
			//已经设有打印项目，则添加在结尾，若添加项已存在则跳过
			s originalItems = objScheme.SchemeItems
			for i=1:1:$l(ASchemeItems,"^")
			{
				continue:($f(originalItems,$p(ASchemeItems,"^",i))>0)	
				s originalItems = originalItems_"^"_$p(ASchemeItems,"^",i)
			}
			s objScheme.SchemeItems = originalItems
		}
		s objScheme.ModifyDate = $p($H,",",1)
		s objScheme.ModifyTime = $p($H,",",2)
	
		s sc = objScheme.%Save()
		s id = objScheme.%Id()
	
		d objScheme.%Close()
		q:($$$ISOK(sc)) id
		q "-1"
	}
	else
	{
		q "nopower"	
	}
}

/// Desc:	方案中删除打印项目
/// Input：	schemeID - 欲删除打印项目方案ID
/// 		itemIDs - 欲删除的打印项目ID串
/// 		userID - 操作者ID
/// Output: 成功 - 1
/// 		无操作权限 - "nopower"
/// 		失败 - -1
ClassMethod DeleteItems(schemeID As %String, itemIDs As %String, userID As %String) As %String
{
	s checkPower = "false"	
	s checkPower = ..CheckPower(schemeID,userID)
	if (checkPower = "true")
	{
		s objScheme = ##class(EPRmeta.CentralizedPrint.CentralizedPrintScheme).%OpenId(schemeID)
		q:(objScheme="") "-1"
		
		s originalItems = objScheme.SchemeItems
		
		for i=1:1:$l(itemIDs,"^")
		{
			s locationEnd = ($f(originalItems,$p(itemIDs,"^",i)) - 1)
			s locationBegin = locationEnd - $l($p(itemIDs,"^",i))
			//第一项
			if (locationBegin = 0)
			{
				s originalItems = $e(originalItems,(locationEnd+2),$l(originalItems))
			}
			else
			{
				s originalItems = $e(originalItems,1,(locationBegin-1))_$e(originalItems,(locationEnd+1),$l(originalItems))
			}	
		}
		s objScheme.SchemeItems = originalItems
		s objScheme.ModifyDate = $p($H,",",1)
		s objScheme.ModifyTime = $p($H,",",2)
		
		s sc = objScheme.%Save()
		s id = objScheme.%Id()
	
		d objScheme.%Close()
		q:($$$ISOK(sc)) "1"
		q "-1"
	}
	else
	{
		q "nopower"	
	}
}

/// Desc:	调整方案中打印项目位置（上移，下移，置顶，置底）
/// Input：	schemeID - 欲调整打印项目方案ID
/// 		itemIDs - 欲调整的打印项目ID串
/// 		userID - 操作者ID
/// 		op - 操作类型 （up - 上移 | down - 下移 | top - 置顶 | bottom - 置底）
/// Output: 成功 - itemIDs，为了调用后重新勾选
/// 		无操作权限 - "nopower"
/// 		失败 - -1
/// Debug:  w ##class(web.eprajax.CentralizedPrintScheme).Move("17","CG01#CD0101^CG02#CD0202^CG03#CD0303^CG05#CD0505","5972","down")
ClassMethod Move(schemeID As %String, itemIDs As %String, userID As %String, op As %String) As %String
{
	s checkPower = "false"	
	s checkPower = ..CheckPower(schemeID,userID)
	if (checkPower = "true")
	{
		s objScheme = ##class(EPRmeta.CentralizedPrint.CentralizedPrintScheme).%OpenId(schemeID)
		q:(objScheme="") "-1"
		
		s originalItems = objScheme.SchemeItems
		//上移
		if (op = "up")
		{
			for i=1:1:$l(itemIDs,"^")
			{		
				s itemID = $p(itemIDs,"^",i)
				for j=1:1:$l(originalItems,"^")
				{
					if (itemID = $p(originalItems,"^",j))
					{
						//前端已保证不是第一项
						s itemTmp = $p(originalItems,"^",(j-1))
						s $p(originalItems,"^",(j-1)) = itemID
						s $p(originalItems,"^",j) = itemTmp
					}	
				}
			}
		}
		//下移
		elseif (op = "down")
		{
			for i=$l(itemIDs,"^"):(-1):1
			{		
				s itemID = $p(itemIDs,"^",i)
				for j=$l(originalItems,"^"):(-1):1
				{
					if (itemID = $p(originalItems,"^",j))
					{						
						//前端已保证不是最后一项
						s itemTmp = $p(originalItems,"^",(j+1))
						s $p(originalItems,"^",j) = itemTmp	
						s $p(originalItems,"^",(j+1)) = itemID
								
					}	
				}
			}
		}
		//置顶，置底
		else
		{
			for k=1:1:$l(itemIDs,"^")
			{
				//把原来的删除
				s locationEnd = ($f(originalItems,$p(itemIDs,"^",k)) - 1)
				s locationBegin = locationEnd - $l($p(itemIDs,"^",k))
				//第一项
				if (locationBegin = 0)
				{
					s originalItems = $e(originalItems,(locationEnd+2),$l(originalItems))
				}
				else
				{
					s originalItems = $e(originalItems,1,(locationBegin-1))_$e(originalItems,(locationEnd+1),$l(originalItems))
				}
			}
			//置顶，接在头
			if (op = "top")
			{
				s originalItems = itemIDs_"^"_originalItems
			}
			//置底，接在尾
			else
			{
				//op = "bottom"
				s originalItems = originalItems_"^"_itemIDs
			}
		}
		s objScheme.SchemeItems = originalItems
		s objScheme.ModifyDate = $p($H,",",1)
		s objScheme.ModifyTime = $p($H,",",2)
		s sc = objScheme.%Save()
	
		d objScheme.%Close()
		q:($$$ISOK(sc)) itemIDs
		q "-1"
	}
	else
	{
		q "nopower"	
	}
}

/// Desc:	调整方案项目位置（上移，下移）
/// Input：	schemeID - 欲调整打印项目方案ID
/// 		op - 操作类型 （up - 上移 | down - 下移）
/// Output: 成功 - schemeID，为了调用后重新勾选
/// 		失败 - -1
/// Debug:  w ##class(web.eprajax.CentralizedPrintScheme).MoveScheme("20","up")
ClassMethod MoveScheme(ASchemeID As %String, op As %String) As %String
{
	
	s objScheme = ##class(EPRmeta.CentralizedPrint.CentralizedPrintScheme).%OpenId(ASchemeID)
	q:(objScheme="") "-1"
		
	s schemeOrder = objScheme.SchemeOrder
	
	//上移（前端已保证不是第一项）
	if (op = "up")
	{
		s rowID = ""
		s order = schemeOrder - 1
		s rowID = $O(^DHCEPRM.CentralizedPrintSchemeI("IdxSchemeOrder", order, rowID))
		q:(rowID = "") 
		s schemeObjBefore = ##Class(EPRmeta.CentralizedPrint.CentralizedPrintScheme).%OpenId(rowID)
		s schemeObjBefore.SchemeOrder = schemeOrder
		s objScheme.SchemeOrder = order
		s sc = objScheme.%Save()
		s sc1 = schemeObjBefore.%Save()
		d objScheme.%Close()
		d schemeObjBefore.%Close()
	}
	//下移
	elseif (op = "down")
	{
		s rowID = ""
		s order = schemeOrder + 1
		s rowID = $O(^DHCEPRM.CentralizedPrintSchemeI("IdxSchemeOrder", order, rowID))
		q:(rowID = "") 
		s schemeObjAfter = ##Class(EPRmeta.CentralizedPrint.CentralizedPrintScheme).%OpenId(rowID)
		s schemeObjAfter.SchemeOrder = schemeOrder
		s objScheme.SchemeOrder = order
		s sc = objScheme.%Save()
		s sc1 = schemeObjAfter.%Save()
		d objScheme.%Close()
		d schemeObjAfter.%Close()
	}
	q:($$$ISOK(sc)) ASchemeID
	q "-1"
}

/// Desc:	删除方案
/// Input：	ASchemeIDs - 欲删除的方案ID串
/// 		AUserID - 操作者ID
/// Output: 成功 - 当前打印方案的schemeID^schemeName^schemeDesc，删除后加载成当前打印方案
/// 		无操作权限 - "nopower"
/// 		失败 - -1
ClassMethod DeleteScheme(ASchemeIDs As %String, AUserID As %String) As %String
{
	s checkPower = "false"	
	s length = $l(ASchemeIDs, "^")
	for index=1:1:length 
	{	
		s ID = $p(ASchemeIDs,"^",index)
		
		s checkPower = ..CheckPower(ID,AUserID)
		if (checkPower = "true")
		{
			d ..UpdateSchemeOrder(ID)
			//删除
			s result=##class(EPRmeta.CentralizedPrint.CentralizedPrintScheme).%DeleteId(ID)
			//设当前方案为默认方案
			s schemeID = ..GetDefault()
			s objScheme = ##class(EPRmeta.CentralizedPrint.CentralizedPrintScheme).%OpenId(schemeID)
			q:(objScheme="")
			
			s schemeName = objScheme.SchemeName
			s schemeDesc = objScheme.SchemeDesc
		}
		else
		{
			q 	
		}
	}
	if (checkPower = "false")
	{
		q "nopower"	
	}
	q schemeID_"^"_schemeName_"^"_schemeDesc
}

/// Desc:	设置当前打印方案
/// Input：	ASchemeID - 欲设置的方案ID
/// Output: ASchemeID，为了前端勾选
ClassMethod SetDefault(ASchemeID As %String) As %String
{
	//将之前的当前打印方案置空
	s rowID = ""
	for {
		s rowID = $O(^DHCEPRM.CentralizedPrintSchemeI("IdxIsDefault", " DEFAULT", rowID))
		q:(rowID = "")
		s objScheme = ##class(EPRmeta.CentralizedPrint.CentralizedPrintScheme).%OpenId(rowID)
		s objScheme.IsDefault = ""
		s sc = objScheme.%Save()
	
		d objScheme.%Close()
	}
	//设置新当前打印方案
	s objSchemeNew = ##class(EPRmeta.CentralizedPrint.CentralizedPrintScheme).%OpenId(ASchemeID)
	s objSchemeNew.IsDefault = "default"
	s sc = objSchemeNew.%Save()
	
	d objSchemeNew.%Close()
	
	q ASchemeID
}

/// Desc:	设置当前打印方案
/// Input：	ASchemeID - 欲设置的方案ID
/// Output: ASchemeID，为了前端勾选
ClassMethod SetDefaultPdf(ASchemeID As %String) As %String
{
	//将之前的当前打印方案置空
	s rowID = ""
	for {
		s rowID = $O(^DHCEPRM.CentralizedPrintSchemeI("IdxIsPDF", " DEFAULTPDF", rowID))
		q:(rowID = "")
		s objScheme = ##class(EPRmeta.CentralizedPrint.CentralizedPrintScheme).%OpenId(rowID)
		s objScheme.IsPDF = ""
		s sc = objScheme.%Save()
	
		d objScheme.%Close()
	}
	//设置新当前打印方案
	s objSchemeNew = ##class(EPRmeta.CentralizedPrint.CentralizedPrintScheme).%OpenId(ASchemeID)
	s objSchemeNew.IsPDF = "defaultpdf"
	s sc = objSchemeNew.%Save()
	
	d objSchemeNew.%Close()
	
	q ASchemeID
}

/// Desc:	获取当前打印方案
/// Input：			
/// Output: schemeID - 当前打印方案方案ID
ClassMethod GetDefault() As %String
{
	s rowID = ""
	s default = 0
	for {
		s rowID = $O(^DHCEPRM.CentralizedPrintSchemeI("IdxIsDefault", " DEFAULT", rowID))
		q:(rowID = "")
		s default = default + 1
	}
	
	//若设置了当前打印方案，获得当前打印方案ID
	if (default > 0)
	{
		s rowID = ""
		s schemeID = ""
		for {
			s rowID = $O(^DHCEPRM.CentralizedPrintSchemeI("IdxIsDefault", " DEFAULT", rowID))
			q:(rowID = "") 
		
			s schemeID = rowID
			q 
		}	
	}
	//若不存在默认，获取NODEFAULT项ID
	else
	{
		s rowID = ""
		s schemeID = ""
		for {
			s rowID = $O(^DHCEPRM.CentralizedPrintSchemeI("IdxIsDefault", " NODEFAULT", rowID))
			q:(rowID = "") 
		
			s schemeID = rowID
			q 
		}	
	}
	q schemeID
}

/// Desc:	检查操作权限
/// Input：	ASchemeID - 当前方案ID
/// 		AUserID - 进行操作的用户		
/// Output: true - 可进行操作
/// 		false - 不能进行操作
ClassMethod CheckPower(ASchemeID As %String, AUserID As %String) As %String
{
	s scheme = ##Class(EPRmeta.CentralizedPrint.CentralizedPrintScheme).%OpenId(ASchemeID)
	q:(scheme = "")
	
	s createUserID = scheme.CreateUserID
	if (createUserID = AUserID)
	{
		q "true"	
	}
	else
	{
		q "false"	
	}
}

/// Desc:	方案打印项表格
/// Input：	ASchemeID - 方案ID
/// 		AEpisodeID - 就诊号
/// 		AUserID - 进行操作的用户		
/// Output: json串
/// Debug d ##class(web.eprajax.CentralizedPrintScheme).LoadSchemeItems("34","201871","5972")
ClassMethod LoadSchemeItems(ASchemeID As %String, AEpisodeID As %String, AUserID As %String) As %String
{
	s total = 0
	s count = 0
	s nameString = ""
	s scheme = ##class(EPRmeta.CentralizedPrint.CentralizedPrintScheme).%OpenId(ASchemeID)
	q:(scheme = "") 
	
	s items = scheme.SchemeItems
	
	w "["
	
	if (items '= "")
	{
		s total = $l(items,"^")
		
		for i=1:1:total
		{
			//ID形式：CG01#CD0101形式
			s category = $p(items,"^",i)
			s categoryIDNum = $e(category,3,4)
			if (categoryIDNum '= "07")
			{
				s rowID = ""
				for {
					s rowID = $O(^DHCEPRM.CentralizedPrintItemI("IdxCategoryID", " "_categoryIDNum, rowID))
					q:(rowID = "")
				
					s objItem = ##Class(EPRmeta.CentralizedPrint.CentralizedPrintItem).%OpenId(rowID)
	
					s desc = objItem.CategoryDesc_"."_objItem.CategoryDesc
					s id = category
					s count = count + 1
					if (i>1) w ","
					w "{"
					w "id:'"_id_"'"
					w ",text:'"_desc_"'"
					w ",order:'"_count_"'"
					w "}"
				}
			}
			else
			{
				s count = ..GetEPRItem(category,i, AEpisodeID, AUserID,count)
			}
		}
	}
	w "]"
}

/// Desc:	方案打印项表格-07病历文书下的项目
/// Input：	AItem - 项目ID - 形式：CG07#CD07范畴ID
/// 		AFlag - 判断是否第一项（用于json逗号）
/// 		AEpisodeID - 就诊号
/// 		AUserID - 进行操作的用户
/// 		ACount - 序列号		
/// Output: json串
/// 		ACount - 序列号
/// debug d ##class(web.eprajax.CentralizedPrintEdit).GetEPRItem("CG07#CD#1#11","1","201871","5972")
ClassMethod GetEPRItem(AItem As %String, AFlag As %String, AEpisodeID As %String, AUserID As %String, ACount As %String) As %String
{
	s patientID = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
	
	s cgID = $p(AItem,"#",3)
	s ccID = $p(AItem,"#",4)

	s cgDesc = ..GetEPRTemplateCategoryDesc(cgID)	
	s ccDesc = ..GetEPRTemplateCategoryDesc(ccID)
			
	s allID = AItem
	s desc = cgDesc_"."_ccDesc

	if (AFlag '= 1) w ","
	s ACount = ACount + 1
	w "{"
	w "id:'"_allID_"'"
	w ",order:'"_ACount_"'"
	w ",text:'"_desc_"'"	
	w "}"
	q ACount
}

/// Desc:	07病历文书下的模板目录的文字描述
/// Input：	ACategoryChapterDocID - 模板目录ID	
/// Output: ccDesc - 模板目录的文字描述
ClassMethod GetEPRTemplateCategoryDesc(ACategoryChapterDocID As %String) As %String
{
	s obj = ##Class(EPRmeta.EPRTemplateCategory).%OpenId(ACategoryChapterDocID)
	q:(obj = "") ""
	s ccDesc = obj.CategoryName
	s ccDesc = $tr(ccDesc, $c(10), "")
	s ccDesc = $tr(ccDesc, $c(13), "")
	s ccDesc = $tr(ccDesc, "'", "")
	
	q ccDesc
}

/// Desc:	设置页码信息
/// Input：	AIDInfo - 节点ID
/// 		AUserID - 操作用户
/// 		AIsPageQueue - 是否启用页码大排队		
/// Output: 1 - 成功
/// 		-1 - 失败
ClassMethod SetPageInfo(AIDInfo As %String, AUserID As %String, AIsPageQueue As %String, pageInfoID) As %String
{
	s pageInfo = ##Class(EPRmeta.CentralizedPrint.CentralizedPrintInfo).%OpenId(pageInfoID)
	q:(pageInfo = "") "-1"
	s pageNumber = pageInfo.PageNumber
	
	//形式为节点ID|起始页码|结束页码
	//第一项，其实页码为1
	if (pageInfo.PageInfo = "")
	{
		s endPageNumber = pageNumber - 1
		s pageInfo.PageInfo = AIDInfo_"|1|"_endPageNumber
	}
	else
	{
		s length = $l(pageInfo.PageInfo,"^")
		//不启用页码排队
		if (AIsPageQueue = "false"){
			s startPageNumber = 1		
		}
		//启用页码排队
		else {
			s startPageNumber = $p($p(pageInfo.PageInfo,"^",length),"|",3) + 1
		}
		s endPageNumber = pageNumber - 1
		s pageInfo.PageInfo = pageInfo.PageInfo_"^"_AIDInfo_"|"_startPageNumber_"|"_endPageNumber
	}

	s sc = pageInfo.%Save()
	d pageInfo.%Close()
	
	q:($$$ISOK(sc)) "1"
	q "-1"
}

/// Desc:	初始化页码信息
/// Input：	userID - 操作用户
/// 		isPageQueue - 是否启用页码大排队		
/// Output: pageInfoID - 成功
/// 		-1 - 失败
ClassMethod InitPageInfo(userID As %String, isPageQueue As %String) As %String
{
	//获得当前打印方案ID
	s schemeID = ..GetDefault()
	
	s obj = ##class(EPRmeta.CentralizedPrint.CentralizedPrintInfo).%New()
	q:(obj="") "-1"
	//设置起始页码为1
	s obj.SchemeID = schemeID
	s obj.UserID = userID
	s obj.PageInfo = ""
	s obj.PageNumber = "1"
	s obj.IsQueue = isPageQueue
	
	s sc = obj.%Save()
	s pageInfoID = obj.%Id()
	d obj.%Close()
	s startDateTime = $H
	
	q:($$$ISOK(sc)) pageInfoID_"###"_startDateTime
	q "-1"
}

/// Desc:	打印后操作
/// Input：	userID - 操作用户
/// 		episodeID - 就诊号	
/// 		patientID - 病人ID	
/// 		itemIDs - 已打印项目
/// 		startDateTime - 开始执行打印的时间
/// Output: 1 - 成功
/// 		-1 - 失败
ClassMethod AfterPrint(userID As %String, episodeID As %String, patientID As %String, itemIDs As %String, startDateTime As %String, pageInfoID As %String) As %String
{
	//清理
	s result=##class(EPRmeta.CentralizedPrint.CentralizedPrintInfo).%DeleteId(pageInfoID)
	
	//打印记录
	s obj = ##class(EPRinstance.CentralizedPrintRecord).%New()
	q:(obj="") "-1"
	
	s PapmiDR = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(episodeID)
	s RegisterNo = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
	s Name=##Class(EPRservice.HISInterface.PatientInfoAssist).Name(PapmiDR)
	
	s obj.UserID = userID
	s obj.EpisodeID = episodeID
	s obj.PatientID = patientID
	s obj.PrintItemsID = itemIDs
	s obj.StartDate = $p(startDateTime,",",1)
	s obj.StartTime = $p(startDateTime,",",2)
	s obj.FinishDate = $p($H,",",1)
	s obj.FinishTime = $p($H,",",2)
	s obj.RegisterNo=RegisterNo
	s obj.Name=Name
	
	s sc = obj.%Save()
	
	d obj.%Close()
	q:($$$ISOK(sc)) "1"
	q "-1"
}

ClassMethod IsFirstTimeRun(AEpisodeID As %String)
{
	s rowID = ""
	s default = 0
	for {
		s rowID = $O(^DHCEPRM.CentralizedPrintSchemeI("IdxIsDefault", " DEFAULT", rowID))
		q:(rowID = "") 
		
		s default = default + 1
	}	
	
	s rowID = ""
	s noDefault = 0
	for {
		s rowID = $O(^DHCEPRM.CentralizedPrintSchemeI("IdxIsDefault", " NODEFAULT", rowID))
		q:(rowID = "") 
		
		s noDefault = noDefault + 1
	}

	if ((default = 0) && (noDefault = 0))
	{
		s items = ##class(web.eprajax.CentralizedPrintDisplay).AllPrintItem(AEpisodeID)
		s objScheme = ##class(EPRmeta.CentralizedPrint.CentralizedPrintScheme).%New()
		q:(objScheme="") "-1"
		s objScheme.IsDefault = "noDefault"
		s objScheme.SchemeItems = items
		
		s sc = objScheme.%Save()
	
		d objScheme.%Close()		
	}
}

ClassMethod UpdateSchemeOrder(ASchemeID As %String) As %String
{
	s schemeObj = ##Class(EPRmeta.CentralizedPrint.CentralizedPrintScheme).%OpenId(ASchemeID)
	s order = schemeObj.SchemeOrder
	d schemeObj.%Close()
	
	s rowID = ASchemeID
	for {
		s order = order + 1
		s rowID = $O(^DHCEPRM.CentralizedPrintSchemeI("IdxSchemeOrder", order, rowID))
		q:(rowID = "") 
		s schemeObj = ##Class(EPRmeta.CentralizedPrint.CentralizedPrintScheme).%OpenId(rowID)
		s schemeObj.SchemeOrder = order - 1
		s sc = schemeObj.%Save()
		d schemeObj.%Close()
	}
	q "1"
}

}
