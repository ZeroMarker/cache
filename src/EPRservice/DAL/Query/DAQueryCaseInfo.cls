/// Desc:     实现“查询方案”的 增、删、改、查 等相关操作
/// Creator： 牛才才
Class EPRservice.DAL.Query.DAQueryCaseInfo Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 保存新方案名称
/// 返回值： -1：保存失败or名称为空(前台已限制);  >0的整数 : 保存成功
ClassMethod AddCaseName(CaseNameObj As EPRservice.entity.Query.EQueryCaseName)
{
	s return=-1
	Quit:(CaseNameObj.Name="") return
	
	s obj= ##Class(EPRmeta.Query.QueryCaseName).%New()
	s obj.Name=CaseNameObj.Name
	s obj.UserID=CaseNameObj.UserID
	s obj.UserName=CaseNameObj.UserName
	s obj.CTLocIDStr=CaseNameObj.CTLocIDStr
	s obj.GroupIDStr=CaseNameObj.GroupIDStr
	
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                      //检查Save是否成功
   		do $system.OBJ.DisplayError(sc) 
   		s ^CacheTemp("ERROR","EPRservice.DAL.Query.DAQueryCaseInfo.AddCaseName")=CaseNameObj.Name_"$"_CaseNameObj.UserID_"$"_CaseNameObj.UserName_"$"_CaseNameObj.CTLocIDStr_"$"_CaseNameObj.GroupIDStr
   		s return=-1
	} else {
		s return=obj.%Id()
	}
	do obj.%Close()
	s obj = ""        //彻底关掉对象
	
	Quit return
}

/// 修改后保存方案名称
/// 返回值： -1：保存失败or名称为空(前台已限制);  >0的整数 : 保存成功
ClassMethod SaveCaseName(curCaseID As %String, CaseNameObj As EPRservice.entity.Query.EQueryCaseName)
{
	s return=-1
	Quit:(CaseNameObj.Name="") return
	
	s obj= ##Class(EPRmeta.Query.QueryCaseName).%OpenId(curCaseID)
	s obj.Name=CaseNameObj.Name
	s obj.UserID=CaseNameObj.UserID
	s obj.UserName=CaseNameObj.UserName
	s obj.CTLocIDStr=CaseNameObj.CTLocIDStr
	s obj.GroupIDStr=CaseNameObj.GroupIDStr
	
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                      //检查Save是否成功
   		do $system.OBJ.DisplayError(sc) 
   		s ^CacheTemp("ERROR","EPRservice.DAL.Query.DAQueryCaseInfo.SaveCaseName")=CaseNameObj.Name_"$"_CaseNameObj.UserID_"$"_CaseNameObj.UserName_"$"_CaseNameObj.CTLocIDStr_"$"_CaseNameObj.GroupIDStr
   		s return=-1
	} else {
		s return=obj.%Id()
	}
	do obj.%Close()
	s obj = ""        //彻底关掉对象
	
	Quit return
}

/// 向表中插数据,保存查询条件
/// 返回值：-1：保存失败; >0整数：保存成功
ClassMethod AddCondition(ConditionObj As EPRservice.entity.Query.EQueryCaseCondition)
{
	s return=-1
	Quit:(ConditionObj.CNId="") return
	
	s obj=##class(EPRmeta.Query.QueryCaseCondition).%New()
	s obj.ORCode=ConditionObj.ORCode
	s obj.ItemCode=ConditionObj.ItemCode
	s obj.ItemName=ConditionObj.ItemName
	s obj.OPCode=ConditionObj.OPCode
	s obj.txtValue=ConditionObj.txtValue
	s obj.CNId=ConditionObj.CNId
	
	s sc=obj.%Save()
	if $system.Status.IsError(sc) {                      //检查Save是否成功
   		do $system.OBJ.DisplayError(sc) 
   		s ^CacheTemp("ERROR","EPRservice.DAL.Query.DAQueryCaseInfo.AddCondition")=ConditionObj.ORCode_"$"_ConditionObj.ItemCode_"$"_ConditionObj.ItemName_"$"_ConditionObj.OPCode_"$"_ConditionObj.txtValue_"$"_ConditionObj.CNId
   		s return=-1
	} else {
		s return=obj.%Id()
	}
	do obj.%Close()
	s obj = ""
	
	Quit return
}

/// 向表中插数据，保存结果列
/// 返回值：-1：保存失败; >0整数：保存成功
ClassMethod AddResultCols(ResultColsObj As EPRservice.entity.Query.EQueryCaseResultCols)
{
	s return=-1
	Quit:(ResultColsObj.CNId="") return
	
	s obj=##class(EPRmeta.Query.QueryCaseResultCols).%New()
	s obj.IsDisabled=ResultColsObj.IsDisabled
	s obj.ColsName=ResultColsObj.ColsName
	s obj.ColsCode=ResultColsObj.ColsCode
	s obj.CNId=ResultColsObj.CNId
	
	s sc=obj.%Save()
	if $system.Status.IsError(sc) {                      //检查Save是否成功
   		do $system.OBJ.DisplayError(sc) 
   		s ^CacheTemp("ERROR","EPRservice.DAL.Query.DAQueryCaseInfo.AddResultCols")=ResultColsObj.IsDisabled_"$"_ResultColsObj.ColsName_"$"_ResultColsObj.ColsCode_"$"_ResultColsObj.CNId
   		s return=-1
	} else {
		s return=obj.%Id()
	}
	do obj.%Close()
	s obj = ""
	
	Quit return
}

/// 检验方案名称是否存在，
/// 返回值：0: 名称不存在; 1: 名称已存在
ClassMethod CheckCaseName(curCaseID As %String, CaseNameObj As EPRservice.entity.Query.EQueryCaseName) As EPRservice.entity.Query.EQueryCaseName [ WebMethod ]
{
	s return=0
	Quit:CaseNameObj.Name="" return
	
	s CaseID=0
	For {
		s CaseID=$o(^DHCEPRM.QueryCaseNameD(CaseID))
		Quit:CaseID=""
		Continue:CaseID=curCaseID             //修改已有方案时，可以和修改前名称相同，所以不判断当前ID的名称
		
		s obj = ##Class(EPRmeta.Query.QueryCaseName).%OpenId(CaseID)
		Continue:CaseNameObj.Name'=obj.Name
		s return=1
		
		do obj.%Close()
		s obj = ""
		Quit
	}
	Quit return
}

/// 检验方案ID是否存在，
/// 返回值：0: 不存在; 1: 存在
ClassMethod CheckCaseID(curCaseID As %String)
{
	s return=0
	Quit:curCaseID="" return
	
	s CaseID=0
	For {
		s CaseID=$o(^DHCEPRM.QueryCaseNameD(CaseID))
		Quit:CaseID=""
		Continue:CaseID'=curCaseID             
			
		s return=1
	}
	quit return
}

/// 此Query是用来得到 查询方案--名称 的全部记录
/// 表:EPRmeta_Query.QueryCaseName
Query GetCaseName(DescArg As %String, QueryAreaName As %String, QueryAreaID As %String) As %Query(ROWSPEC = "Rowid:%String,desc:%String,SaveUserID:%String,SaveUserName:%String")
{
}

ClassMethod GetCaseNameExecute(ByRef qHandle As %Binary, DescArg As %String, QueryAreaName As %String, QueryAreaID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set DescArg=$g(DescArg) 
	Set QueryAreaName=$g(QueryAreaName)
	Set QueryAreaID=$g(QueryAreaID)
	// 查询当前用户可见的方案
	if (QueryAreaName="userID")
	{
		Set CaseID=0
			
		Set UserID=QueryAreaID
		for {
			Set CaseID=$o(^DHCEPRM.QueryCaseNameI("IdxUserID"," "_UserID,CaseID))
			Quit:CaseID=""
			
			set obj = ##Class(EPRmeta.Query.QueryCaseName).%OpenId(CaseID)
			set Desc = obj.Name
			continue:Desc'[DescArg
			Set SaveUserName = obj.UserName
			Set SaveUserID = obj.UserID
			do obj.%Close()
			s obj = ""
			
			Set Data=$lb(CaseID,Desc,SaveUserID,SaveUserName)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}	
	}elseif (QueryAreaName="ctLocID")
	// 查询当前科室可见的方案
	{
		Set CaseID=0
		For {
			Set CaseID=$o(^DHCEPRM.QueryCaseNameD(CaseID))
			Quit:CaseID=""
			
			set obj = ##Class(EPRmeta.Query.QueryCaseName).%OpenId(CaseID)
			Set CTLocIDStr = obj.CTLocIDStr
			continue:CTLocIDStr=""
				
			Set CurrentNum = 1
			For {
				Set CTLocID = $p(CTLocIDStr,"^",CurrentNum)
				Set CurrentNum = CurrentNum + 1
				Quit:CTLocID=""
					
				If (CTLocID = QueryAreaID)
				{
					set Desc = obj.Name
					continue:Desc'[DescArg
					Set SaveUserName = obj.UserName
					Set SaveUserID = obj.UserID
						
					Set Data=$lb(CaseID,Desc,SaveUserID,SaveUserName)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
			do obj.%Close()
			s obj = ""
		}
			
	}elseif (QueryAreaName="groupID")
	// 查询当前安全组可见的方案
	{
		Set CaseID=0
		For {
			Set CaseID=$o(^DHCEPRM.QueryCaseNameD(CaseID))
			Quit:CaseID=""
			
			set obj = ##Class(EPRmeta.Query.QueryCaseName).%OpenId(CaseID)	
			Set GroupIDStr = obj.GroupIDStr
			continue:GroupIDStr=""
				
			Set CurrentNum = 1
			For {
				Set GroupID = $p(GroupIDStr,"^",CurrentNum)
				Set CurrentNum = CurrentNum + 1
				Quit:GroupID=""
					
				If (GroupID = QueryAreaID)
				{
					set Desc = obj.Name
					continue:Desc'[DescArg
					Set SaveUserName = obj.UserName
					Set SaveUserID = obj.UserID
						
					Set Data=$lb(CaseID,Desc,SaveUserID,SaveUserName)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
			do obj.%Close()
			s obj = ""
		}
	}
	Quit $$$OK
}

ClassMethod GetCaseNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCaseNameExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
		Kill ^CacheTemp(repid)  //如果使用“DataSet”方法来获取数据，不会执行Query的Close方法，所以此行必有
	}Else{				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCaseNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCaseNameExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 此Query是用来得到 查询方案--查询条件 的全部记录
/// 表：EPRmeta_Query.QueryCaseCondition
Query GetCaseCondition(CaseID As %String) As %Query(ROWSPEC = "ORCode:%String,ItemCode:%String,ItemName:%String,OPCode:%String,textValue:%String")
{
}

ClassMethod GetCaseConditionExecute(ByRef qHandle As %Binary, CaseID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set RowID=0
	For {
		Set RowID=$o(^DHCEPRM.QueryCaseConditionI("IdxCNId"," "_CaseID,RowID))
		Quit:RowID=""
		
		set obj = ##Class(EPRmeta.Query.QueryCaseCondition).%OpenId(RowID)
		set ORCode = obj.ORCode
		set ItemCode = obj.ItemCode
		set ItemName = obj.ItemName
		set OPCode = obj.OPCode
		set txtValue = obj.txtValue
		
		do obj.%Close()
		s obj = ""
		
		Set Data=$lb(ORCode,ItemCode,ItemName,OPCode,txtValue)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod GetCaseConditionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCaseConditionExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}Else{				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCaseConditionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCaseConditionExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 此Query是用来得到 查询方案--结果列 的全部记录
/// 表:EPRmeta_Query.QueryCaseResultCols
Query GetCaseResultCols(CaseID As %String) As %Query(ROWSPEC = "IsDisabled:%String,ColsName:%String,ColsCode:%String")
{
}

ClassMethod GetCaseResultColsExecute(ByRef qHandle As %Binary, CaseID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	s CaseID=$g(CaseID) 
	Set RowID=0
	For {
		Set RowID=$o(^DHCEPRM.QueryCaseResultColsI("IdxCNId"," "_CaseID,RowID))
		Quit:RowID=""
		
		set obj = ##Class(EPRmeta.Query.QueryCaseResultCols).%OpenId(RowID)
		set IsDisabled = obj.IsDisabled
		set ColsName = obj.ColsName
		set ColsCode = obj.ColsCode
		;set CNId = obj.CNId
		do obj.%Close()
		s obj = ""
		
		Set Data=$lb(IsDisabled,ColsName,ColsCode)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod GetCaseResultColsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCaseResultColsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}Else{				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCaseResultColsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCaseResultColsExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 删除方案
/// 返回值：0：删除成功; -1：删除方案名称失败;
ClassMethod DeleteCaseById(CaseID As %String) As %String
{
	set return=0
	Quit:CaseID=""
	
	Set $ZT="ERROR"		       //定义错误处理函数
	
	TSTART
	Set sc = ##class(EPRmeta.Query.QueryCaseName).%DeleteId(CaseID)
	if $system.Status.IsError(sc) {         //检查删除是否成功
   		do $system.OBJ.DisplayError(sc)
   		set ^CacheTemp("ERROR","EPRservice.DAL.Query.DAQueryCaseInfo.DeleteCaseById")=CaseID 
   		set return=-1
	}
	if return=0{
		s retA = ..DeleteConditionByCaseID(CaseID)
		s retB = ..DeleteResultColsByCaseID(CaseID)
		if (retA'=0 || retB'=0)
		{
			TROLLBACK
		}
		else
		{
			TCOMMIT
		}
	}
	quit return
	
ERROR	 
	Set ErrorMsg=$ZE	        //得到系统返回的错误消息
 	TROLLBACK		            //回滚事务
 	Quit "<ERROR>"_ErrorMsg     //返回错误消息 ;
}

/// 删除方案查询条件
/// 返回值：0：删除成功; -2：删除失败
ClassMethod DeleteConditionByCaseID(CaseID As %String) As %String
{
	set return=0
	set RowID=0
	For {
		Set RowID=$o(^DHCEPRM.QueryCaseConditionI("IdxCNId"," "_CaseID,RowID))
		Quit:RowID=""
		
		set sc = ##class(EPRmeta.Query.QueryCaseCondition).%DeleteId(RowID)
		if $system.Status.IsError(sc) {         //检查删除是否成功
   			do $system.OBJ.DisplayError(sc)
   			set ^CacheTemp("ERROR","EPRservice.DAL.Query.DAQueryCaseInfo.DeleteConditionByCaseID")=CaseID_"$"_RowID
   			set return=-2
		}
	}
	quit return
}

/// 删除方案结果列
/// 返回值：0：删除成功; -3：删除失败
ClassMethod DeleteResultColsByCaseID(CaseID As %String) As %String
{
	set return=0
	set RowID=0
	For {
		Set RowID=$o(^DHCEPRM.QueryCaseResultColsI("IdxCNId"," "_CaseID,RowID))
		Quit:RowID=""
		
		set sc = ##class(EPRmeta.Query.QueryCaseResultCols).%DeleteId(RowID)
		if $system.Status.IsError(sc) {         //检查删除是否成功
   			do $system.OBJ.DisplayError(sc)
   			set ^CacheTemp("ERROR","EPRservice.DAL.Query.DAQueryCaseInfo.DeleteResultColsByCaseID")=CaseID_"$"_RowID  
   			set return=-3
		}
	}
	quit return
}

/// 此Query是用来得到 安全组 的全部记录
/// 表:SS_Group
/// d ##Class(%ResultSet).RunQuery("EPRservice.DAL.Query.DAQueryCaseInfo","GetAllGroup")
Query GetAllGroup() As %Query(ROWSPEC = "RowId:%String,Desc:%String")
{
}

ClassMethod GetAllGroupExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set RowId=0
	For {
		Set RowId=$o(^SSU("SSGRP",RowId))
		QUIT:RowId=""
		Set Desc=$p($g(^SSU("SSGRP",RowId)),"^",1)
		Set Data=$lb(RowId,Desc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod GetAllGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllGroupExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}Else{				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAllGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 此Query是用来得到 当前方案的可见科室 信息
Query getCTLocByCaseID(CaseID As %String) As %Query(ROWSPEC = "CTLocID:%String,CTLocDesc:%String")
{
}

ClassMethod getCTLocByCaseIDExecute(ByRef qHandle As %Binary, CaseID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set obj = ##Class(EPRmeta.Query.QueryCaseName).%OpenId(CaseID)
	Set CTLocIDStr = obj.CTLocIDStr
	Set CurrentNum = 1
	For {
		Set CTLocID = $p(CTLocIDStr,"^",CurrentNum)
		Set CurrentNum = CurrentNum + 1
		Quit:CTLocID=""
		
		set CTLocDesc = $p($g(^CTLOC(CTLocID)),"^",2)
						
		Set Data=$lb(CTLocID,CTLocDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	do obj.%Close()
	s obj = ""
	Quit $$$OK
}

ClassMethod getCTLocByCaseIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getCTLocByCaseIDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}Else{				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod getCTLocByCaseIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getCTLocByCaseIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 此Query是用来得到 当前方案的可见科室 信息
Query getGroupByCaseID(CaseID As %String) As %Query(ROWSPEC = "GroupID:%String,GroupDesc:%String")
{
}

ClassMethod getGroupByCaseIDExecute(ByRef qHandle As %Binary, CaseID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set obj = ##Class(EPRmeta.Query.QueryCaseName).%OpenId(CaseID)
	Set GroupIDStr = obj.GroupIDStr
	Set CurrentNum = 1
	For {
		Set GroupID = $p(GroupIDStr,"^",CurrentNum)
		Set CurrentNum = CurrentNum + 1
		Quit:GroupID=""
		
		set GroupDesc = $p($g(^SSU("SSGRP",GroupID)),"^",1)
						
		Set Data=$lb(GroupID,GroupDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	do obj.%Close()
	s obj = ""
	Quit $$$OK
}

ClassMethod getGroupByCaseIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getGroupByCaseIDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}Else{				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod getGroupByCaseIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getGroupByCaseIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
