/// 名称: EPRservice.BIL.BIToWMR
/// 描述: 给医政组的数据接口
/// 编写者：HouJian
/// 编写日期: 2011-12-26
Class EPRservice.BIL.BIToWMR Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod GetInstanceInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInstanceInfoExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetInstanceInfoExecute(ByRef qHandle As %Binary, AEpisodeID As %String, ACategoryID As %String, ADTFlag As %String, AStartDate As %String, AStartTime As %String, AEndDate As %String, AEndTime As %String) As %Status
{
	//b "s"
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:(AEpisodeID="")||(ACategoryID="") $$$OK
	
	//处理新页面框架情况
	s ecRecordID = $O(^DHCEPRI.ECRecordI("IdxEpisodeIDCategoryID", " "_AEpisodeID, " "_ACategoryID, ""))
	q:(ecRecordID="") $$$OK
	
	s objListECRecord = $g(^DHCEPRI.ECRecordD(ecRecordID))
	q:(objListECRecord="") $$$OK
	
	s chartItemType = $list(objListECRecord,3)
	
	s childSub = ""
	for {
		//b "s"
		s childSub = $O(^DHCEPRI.InstanceDataI("IdxECRecord",ecRecordID,childSub))
		q:(childSub="")
		
		s instanceDataID = ecRecordID_"||"_childSub
		
		s objInstance = ##Class(EPRinstance.InstanceData).%OpenId(instanceDataID)
		continue:(objInstance = "")
		
		continue:(objInstance.Status="UnSave")||(objInstance.Status="")
		
		s templateID = objInstance.TemplateID
		s title = objInstance.Title
		s createUserID = objInstance.CreateUser
		s createDate = objInstance.CreateDate
		s createTime = objInstance.CreateTime
		if (chartItemType = "Single")
		{
			s happenDate = createDate
			s happenTime = createTime
		}
		else
		{
			s happenDate = objInstance.HappenDate
			s happenTime = objInstance.HappenTime
		}
		
		s isValid = "1"
		if (ADTFlag = "Create")
		{
			s isValid = $$IsDateTimeValid(createDate,createTime,AStartDate,AStartTime,AEndDate,AEndTime)
		}
		elseif (ADTFlag = "Happen")
		{
			s isValid = $$IsDateTimeValid(happenDate,happenTime,AStartDate,AStartTime,AEndDate,AEndTime)
		}
		continue:(isValid = "0")
		
		s ^CacheTemp(repid,ind) = $LB(instanceDataID,templateID,title,createUserID,createDate,createTime,happenDate,happenTime)
		s ind = ind + 1
	}
	
	Quit $$$OK

IsDateTimeValid(date, time, fromDate, fromTime, toDate, toTime)
	//b "s"
	q:(date < fromDate) "0"
	q:(date = fromDate)&&(time < fromTime) "0"
	q:(date > toDate) "0"
	q:(date = toDate)&&(time > toTime) "0"
	q "1"
}

ClassMethod GetInstanceInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInstanceInfoExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:	HouJian
/// CreatDate:	2011-12-26
/// Desc:：   	获取指定实例数据相关信息，包括模板ID、标题、创建人、创建日期时间、发生日期时间
/// Table：		无
/// Input：     AEpisodeID ：就诊指针
/// 			ACategoryID ：界面模板目录ID
/// 			ADTFlag ：做筛选条件的日期时间标识，Create表示创建时间，Happen表示发生时间，空值表示不使用日期时间做筛选条件
/// 			AStartDate ：起始日期，格式为Cache内部逻辑值（如$H的日期部分）
/// 			AStartTime ：起始时间，格式为Cache内部逻辑值（如$H的时间部分）
/// 			AEndDate : 截止日期，格式为Cache内部逻辑值（如$H的日期部分）
/// 			AEndTime : 截止时间，格式为Cache内部逻辑值（如$H的时间部分）
/// Output:		InstanceDataID : 实例数据ID,
/// 			TemplateID : 界面模板ID,
/// 			Title : 实例数据标题,
/// 			CreateUserID : 创建者ID,
/// 			CreateDate : 创建日期,格式为Cache内部逻辑值（如$H的日期部分）,
/// 			CreateTime : 创建时间,格式为Cache内部逻辑值（如$H的时间部分）,
/// 			HappenDate : 发生日期,格式为Cache内部逻辑值（如$H的日期部分）,
/// 			HappenTime : 发生时间,格式为Cache内部逻辑值（如$H的时间部分）,
/// Return:		无
/// Others：    d ##Class(%ResultSet).RunQuery("EPRservice.BIL.BIToWMR","GetInstanceInfo","1","81","","","","","")	
Query GetInstanceInfo(AEpisodeID As %String, ACategoryID As %String, ADTFlag As %String, AStartDate As %String, AStartTime As %String, AEndDate As %String, AEndTime As %String) As %Query(ROWSPEC = "InstanceDataID:%String,TemplateID:%String,Title:%String,CreateUserID:%String,CreateDate:%String,CreateTime:%String,HappenDate:%String,HappenTime:%String")
{
}

ClassMethod GetTemplateCateogryInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTemplateCateogryInfoExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetTemplateCateogryInfoExecute(ByRef qHandle As %Binary, ACategoryID As %String, AIsRecursive As %String) As %Status
{
	//b "s"
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:(ACategoryID="") $$$OK
	
	d ..GetChildCategory(repid, ind, "0", AIsRecursive)
	
	Quit $$$OK
}

ClassMethod GetTemplateCateogryInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTemplateCateogryInfoExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:	HouJian
/// CreatDate:	2011-12-26
/// Desc:：   	获取指定界面模板目录下子目录信息，包括模板目录ID、模板父目录ID、目录名称、目录类型、包含界面模板数量
/// Table：		无
/// Input：     ACategoryID ：界面模板目录ID，根目录ID值为"0"
/// 			AIsRecursive ：是否递归获取指定目录下所有子目录信息，"1" 递归获取指定目录下所有子目录信息，
/// 			                                                     "0" 只获取指定目录下第一级子目录信息
/// Output:		CategoryID : 界面模板目录ID,
/// 			ParentCategoryID : 父界面模板目录ID,
/// 			CategoryName : 目录名称,
/// 			CategoryType : 目录类型, 枚举值域：Main、Normal、Group、GroupItem
/// 			ResChildCount : 目录下包含界面模板数量，只有直接包含界面模板的目录此值才大于0
/// Return:		无
/// Others:		d ##Class(%ResultSet).RunQuery("EPRservice.BIL.BIToWMR","GetTemplateCateogryInfo","0","0")	
Query GetTemplateCateogryInfo(ACategoryID As %String, AIsRecursive As %String) As %Query(ROWSPEC = "CategoryID:%String,ParentCategoryID:%String,CategoryName:%String,CategoryType:%String,ResChildCount:%String")
{
}

ClassMethod GetChildCategory(AUniqueGlobalID As %String, AGlobalIndex As %String, ACategoryID As %String, AIsRecursive As %String) As %Integer
{
	q:(ACategoryID="") AGlobalIndex
	
	s rowId = ""
	for {
		//b "s"
		s rowId = $O(^DHCEPRM.TemplateCategoryI("IdxParentId"," "_ACategoryID,rowId))
		q:(rowId = "")
		
		s listTemplateCategory = $G(^DHCEPRM.TemplateCategoryD(rowId))
		q:(listTemplateCategory="")
		
		s name = $List(listTemplateCategory,3)
		s resChildCount = $List(listTemplateCategory,5)
		s type = $List(listTemplateCategory,7)
		
		s ^CacheTemp(AUniqueGlobalID, AGlobalIndex) = $LB(rowId, ACategoryID, name, type, resChildCount) 
		s AGlobalIndex = AGlobalIndex + 1
		
		if (resChildCount '> 0)&&(AIsRecursive = "1")
		{
			s AGlobalIndex = ..GetChildCategory(AUniqueGlobalID, AGlobalIndex, rowId, AIsRecursive)
		}	
	}
	
	q AGlobalIndex
}

}
