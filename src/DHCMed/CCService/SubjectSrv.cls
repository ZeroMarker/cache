/// 名称: DHCMed.CCService.SubjectSrv
/// 描述: DHCMed.CC.Subject 监控主题常用方法
/// 编写者：liuyh
/// 编写日期: 2010-09-26
Class DHCMed.CCService.SubjectSrv Extends (%RegisteredObject, DHCMed.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuyh
/// CreatDate：   2010-09-26
/// Description:  查询监控主题信息
/// Table：       DHCMed.CC.Subject
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.SubjectSrv","QuerySubjectInfo","")
Query QuerySubjectInfo(title As %String) As %Query(ROWSPEC = "rowid:%String,Title:%String,Code:%String,Desc:%String,IsActive:%String,IsActiveDesc:%String,Categroy:%String,Expression:%String,ResumeText:%String")
{
}

ClassMethod QuerySubjectInfoExecute(ByRef qHandle As %Binary, title As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s rowid=""
	f  s rowid=$o(^DHCMed.CC.SubjectD(rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.CC.Subject).%OpenId(rowid)
	.q:'$IsObject(obj)
	.q:((title'="")&(obj.Title'[title))
	.s $li(data,1)=rowid
	.s $li(data,2)=obj.Title
	.s $li(data,3)=obj.Code
	.s $li(data,4)=obj.Description
	.s $li(data,5)=obj.IsActive
	.s $li(data,6)="否"
	.s:obj.IsActive=1 $li(data,6)="是"
	.s $li(data,7)=obj.Categroy
	.s $li(data,8)=obj.Expression
	.s $li(data,9)=obj.ResumeText
 	.s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    .d obj.%Close()
	q $$$OK
}

ClassMethod QuerySubjectInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySubjectInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QuerySubjectInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySubjectInfoExecute ]
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

/// Creator：     liuyh
/// CreatDate：   2010-09-26
/// Description:  查询监控主题项目信息
/// Table：       DHCMed.CC.SubjectItm
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.SubjectSrv","QuerySubjectItmInfo","1")
Query QuerySubjectItmInfo(SubjectID As %String) As %Query(ROWSPEC = "rowid:%String,Code:%String,ItemDic:%String,IsActive:%String,IsActiveDesc:%String,ResumeText:%String,Score:%String,IDDesc:%String,active:%String,MultiTimes:%String,MultiTimesDesc:%String")
{
}

ClassMethod QuerySubjectItmInfoExecute(ByRef qHandle As %Binary, SubjectID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s SubjectID=+SubjectID
	q:SubjectID<1 $$$OK
	s IsActive=""
	f  s IsActive=$o(^DHCMed.CC.SubjectItmI("IndexSubjectID",SubjectID,IsActive)) q:IsActive=""  d
	.s rowid=""
	.f  s rowid=$o(^DHCMed.CC.SubjectItmI("IndexSubjectID",SubjectID,IsActive,rowid)) q:rowid=""  d
	..s obj=##class(DHCMed.CC.SubjectItm).%OpenId(rowid)
	..q:'$IsObject(obj)
	..s $li(data,1)=rowid
	..s $li(data,2)=obj.Code
	..s $li(data,3)=obj.ItemDic
	..s $li(data,4)=obj.IsActive
	..s $li(data,5)="否"
	..s:obj.IsActive=1 $li(data,5)="是"
	..s $li(data,6)=obj.ResumeText
	..s $li(data,7)=obj.Score
	..s objItemDic=##class(DHCMed.CC.ItemDic).GetObjById(obj.ItemDic)
	..s $li(data,8)=""
	..s:$IsObject(objItemDic) $li(data,8)=objItemDic.IDDesc
	..s $li(data,9)="false"
	..s:obj.IsActive=1 $li(data,9)="true"
	..s $li(data,10)=obj.MultiTimes
	..s $li(data,11)="否"
	..s:obj.MultiTimes=1 $li(data,11)="是"
 	..s ^CacheTemp(repid,ind)=data
    ..s ind=ind+1
    ..d obj.%Close()
	q $$$OK
}

ClassMethod QuerySubjectItmInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySubjectItmInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QuerySubjectItmInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySubjectItmInfoExecute ]
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

/// Creator：     liuyh
/// CreatDate：   2010-10-19
/// Description:  查询监控主题项目信息
/// Table：       DHCMed.CC.SubjectItm
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.SubjectSrv","QuerySubItmForIMP","1")
Query QuerySubItmForIMP(SubjectID As %String) As %Query(ROWSPEC = "rowid:%String,Code:%String,Score:%String,IDDesc:%String,active:%String")
{
}

ClassMethod QuerySubItmForIMPExecute(ByRef qHandle As %Binary, SubjectID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s SubjectID=+SubjectID
	q:SubjectID<1 $$$OK
	s IsActive=""
	f  s IsActive=$o(^DHCMed.CC.SubjectItmI("IndexSubjectID",SubjectID,IsActive)) q:IsActive=""  d
	.s rowid=""
	.f  s rowid=$o(^DHCMed.CC.SubjectItmI("IndexSubjectID",SubjectID,IsActive,rowid)) q:rowid=""  d
	..s obj=##class(DHCMed.CC.SubjectItm).%OpenId(rowid)
	..q:'$IsObject(obj)
	..q:obj.IsActive'=1
	..s $li(data,1)=rowid
	..s $li(data,2)=obj.Code
	..s $li(data,3)=obj.Score
	..s objItemDic=##class(DHCMed.CC.ItemDic).GetObjById(obj.ItemDic)
	..s $li(data,4)=""
	..s:$IsObject(objItemDic) $li(data,4)=objItemDic.IDDesc
	..s $li(data,5)="true"
 	..s ^CacheTemp(repid,ind)=data
    ..s ind=ind+1
    ..d obj.%Close()
	q $$$OK
}

ClassMethod QuerySubItmForIMPClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySubItmForIMPExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QuerySubItmForIMPFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySubItmForIMPExecute ]
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

/// Creator：     liuyh
/// CreatDate：   2010-09-27
/// Description:  查询与Subject相关的监控虚拟机加载初始化配置
/// Table：       DHCMed.CC.SubjectVMStartConfig
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.SubjectSrv","QuerySubjectVMSConfig",3)
Query QuerySubjectVMSConfig(SubjectID As %String) As %Query(ROWSPEC = "rowid:%String,SubjectID:%String,Code:%String,Desc:%String,IsActive:%String,IsActiveDesc:%String,StartIndex:%String,Expression:%String,ResumeText:%String,RunType:%String,VarName:%String")
{
}

ClassMethod QuerySubjectVMSConfigExecute(ByRef qHandle As %Binary, SubjectID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s SubjectID=+SubjectID
	q:SubjectID<1 $$$OK
	s rowid=""
	f  s rowid=$o(^DHCMed.CC.SubjectVMSta7D7D(rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.CC.SubjectVMStartConfig).%OpenId(rowid)
	.q:'$IsObject(obj)
	.q:obj.SubjectID'=SubjectID
	.s $li(data,1)=rowid
	.s $li(data,2)=obj.SubjectID
	.s $li(data,3)=obj.Code
	.s $li(data,4)=obj.Description
	.s $li(data,5)=obj.IsActive
	.s $li(data,6)="否"
	.s:obj.IsActive=1 $li(data,6)="是"
	.s $li(data,7)=obj.StartIndex
	.s $li(data,8)=obj.Expression
	.s $li(data,9)=obj.ResumeText
	.s $li(data,10)=obj.RunType
	.s $li(data,11)=obj.VarName
 	.s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    .d obj.%Close()
	q $$$OK
}

ClassMethod QuerySubjectVMSConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySubjectVMSConfigExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QuerySubjectVMSConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySubjectVMSConfigExecute ]
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

/// Creator：     liuyh
/// CreatDate：   2010-09-30
/// Description:  通过项目子类查询项目字典
/// Table：       DHCMed.CC.ItemDic
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.SubjectSrv","QueryItemDicInfo",1)
Query QueryItemDicInfo(ItemSubCatID As %String) As %Query(ROWSPEC = "rowid:%String,Desc:%String,Code:%String,Expression:%String,Range:%String,Resume:%String")
{
}

ClassMethod QueryItemDicInfoExecute(ByRef qHandle As %Binary, ItemSubCatID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s ItemSubCatID=+ItemSubCatID
	q:ItemSubCatID<1 $$$OK
	q:'$d(^DHCMed.CC.ItemDicI("IDSubCatDrIndex",ItemSubCatID)) $$$OK
	s rowid=""
	f  s rowid=$o(^DHCMed.CC.ItemDicI("IDSubCatDrIndex",ItemSubCatID,rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.CC.ItemDic).%OpenId(rowid)
	.q:'$IsObject(obj)
	.s $li(data,1)=rowid
	.s $li(data,2)=obj.IDDesc
	.s $li(data,3)=obj.IDCode
	.s $li(data,4)=obj.IDExpression
	.s $li(data,5)=obj.IDRange
	.s $li(data,6)=obj.IDResume
 	.s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    .d obj.%Close()
	q $$$OK
}

ClassMethod QueryItemDicInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryItemDicInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryItemDicInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryItemDicInfoExecute ]
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

/// Creator：     liuyh
/// CreatDate：   2010-09-30
/// Description:  
/// Table：       DHCMed.CC.ItemCat
/// Input：      
/// Return：    
/// w ##class(DHCMed.CCService.SubjectSrv).GetItemCatInfo()
ClassMethod GetItemCatInfo() As %String
{
	s ret=""
	s rowid=""
	f  s rowid=$o(^DHCMed.CC.ItemCatD(rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.CC.ItemCat).%OpenId(rowid)
	.q:'$IsObject(obj)
	.s:ret'="" ret=ret_"<$C1>"_rowid_"^"_obj.ICDesc
	.s:ret="" ret=rowid_"^"_obj.ICDesc
	
	q ret
}

/// Creator：     liuyh
/// CreatDate：   2010-09-30
/// Description:  根据监控大类ID查询监控子类信息
/// Table：       DHCMed.CC.ItemCat 、DHCMed.CC.ItemSubCat
/// Input：       ItemCatId  监控大类Id
/// Return：      返回json格式的菜单信息，
/// Others:       此方法内部递归调用，构建菜单树
/// w ##class(DHCMed.CCService.SubjectSrv).BuildSubjectJson(1)
ClassMethod BuildSubjectJson(ItemCatId As %String) As %String
{
	;new (ItemCatId)
	set json=""
 	quit:'$d(^DHCMed.CC.ItemSubCatI("ISCCodeIndex",+ItemCatId)) "[]"
 	set index=$o(^DHCMed.CC.ItemSubCatI("ISCCodeIndex",+ItemCatId,""))
 	set ItemSubCatId=""
 	while (index'="") {
	 	set ItemSubCatId=$o(^DHCMed.CC.ItemSubCatI("ISCCodeIndex",+ItemCatId,index,""))
	 	while (ItemSubCatId'=""){
		 	set obj=##class(DHCMed.CC.ItemSubCat).%OpenId(ItemSubCatId)
		 	set ISCDesc=obj.ISCDesc
	 		set:json'="" json=json_","
			set json=json_"{"
			set json=json_"""id"":"""_ItemSubCatId_""",""text"":"""_ISCDesc_""","
			//set json=json_"""iconCls"":"""_IconClass_""","
	    	//set json=json_"""iconCls"":""icon-forumt"","   ;""linkurl"":"""_LinkUrl_""","
		    set json=json_"""leaf"":true" //,""cls"":""forum"",""href"":""http://www.google.com"""
	    	set json=json_"}"
			
			set ItemSubCatId=$o(^DHCMed.CC.ItemSubCatI("ISCCodeIndex",+ItemCatId,index,ItemSubCatId))
			}
			set index=$o(^DHCMed.CC.ItemSubCatI("ISCCodeIndex",+ItemCatId,index))
		 }
		 
	quit "["_json_"]"
}

/// Creator：     liuyh
/// CreatDate：   2010-11-03
/// Description:  查询所有监控主题
/// Table：       DHCMed.CC.Subject
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.SubjectSrv","QuerySubjectDesc")
Query QuerySubjectDesc() As %Query(ROWSPEC = "rowid:%String,Title:%String")
{
}

ClassMethod QuerySubjectDescExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""
	f  s rowid=$o(^DHCMed.CC.SubjectD(rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.CC.Subject).%OpenId(rowid)
	.q:'$IsObject(obj)
	.q:obj.IsActive'=1
	.s $li(data,1)=rowid
	.s $li(data,2)=obj.Title
 	.s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    .d obj.%Close()
	q $$$OK
}

ClassMethod QuerySubjectDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySubjectDescExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QuerySubjectDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySubjectDescExecute ]
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

/// Creator：     liuyh
/// CreatDate：   2010-11-16
/// Description:  根据项目子类获取字典项 json树信息
/// Table：       DHCMed.CC.ItemDic，DHCMed.CC.ItemSubCat
/// Input：       ItemSubID : 子类ID
/// Output:       subChildJson  字典项json树信息
/// Return：      
/// Others:       此方法内部递归调用，构建子类树
/// w ##class(DHCMed.CCService.SubjectSrv).BuildItemDicJson(3,.childJson)
ClassMethod BuildItemDicJson(ItemSubID As %String, subChildJson As %String) As %String
{
	new (ItemSubID,subChildJson)
	set json=""
	set retFlag=0
 	quit:'$d(^DHCMed.CC.ItemDicI("IDSubCatDrIndex",ItemSubID)) "[]"
 	set itemDicID=$o(^DHCMed.CC.ItemDicI("IDSubCatDrIndex",ItemSubID,""))
	while (itemDicID'=""){
		//w "   itemSubID="_itemSubID
		set obj=##class(DHCMed.CC.ItemDic).%OpenId(itemDicID)
		if $IsObject(obj)
		{
			set IDCode=obj.IDCode
		 	set IDDesc=obj.IDDesc
	 		set:json'="" json=json_","
			set json=json_"{"
			set json=json_"""id"":"""_itemDicID_"L"",""text"":"""_IDDesc_""","
			set json=json_"""expanded"":true,"
			//set json=json_"""iconCls"":""icon-menu"","	
			//set json=json_"""checked"":false,"
	   
			set json=json_"""leaf"":true"
	    	set json=json_"}"
		 }
		set itemDicID=$o(^DHCMed.CC.ItemDicI("IDSubCatDrIndex",ItemSubID,itemDicID))
	}
	 
	set subChildJson="["_json_"]"
	quit retFlag
}

/// Creator：     liuyh
/// CreatDate：   2010-11-03
/// Description:  根据项目大类获取项目子类 json树信息
/// Table：       DHCMed.CC.ItemDic，DHCMed.CC.ItemSubCat
/// Input：       ItemCatID : 项目大类ID
/// Output:       childJson: 项目子类 json树信息
/// Return：      
/// Others:       此方法内部递归调用，构建子类树
/// w ##class(DHCMed.CCService.SubjectSrv).BuildItemSubJson(3,.childJson)
ClassMethod BuildItemSubJson(ItemCatID As %String, childJson As %String) As %String
{
	new (ItemCatID,childJson)
	set json=""
	set retFlag=0
 	quit:'$d(^DHCMed.CC.ItemSubCatI("ISCCodeIndex",ItemCatID)) "[]"
 	set index=$o(^DHCMed.CC.ItemSubCatI("ISCCodeIndex",ItemCatID,""))
 	set itemSubID=""
 	while (index'="") {
	 	//w !,"index="_index
	 	set itemSubID=$o(^DHCMed.CC.ItemSubCatI("ISCCodeIndex",ItemCatID,index,""))
	 	while (itemSubID'=""){
		 	//w "   itemSubID="_itemSubID
		 	set obj=##class(DHCMed.CC.ItemSubCat).%OpenId(itemSubID)
		 	if $IsObject(obj)
		 	{
		 		set ISCCode=obj.ISCCode
		 		set ISCDesc=obj.ISCDesc
	 			set:json'="" json=json_","
				set subJson="{"_"""id"":"""_itemSubID_"M"",""text"":"""_ISCDesc_""","
				set subJson=subJson_"""expanded"":true,"
				set subChildJson="[]"
				d:$d(^DHCMed.CC.ItemDicI("IDSubCatDrIndex",itemSubID)) ..BuildItemDicJson(itemSubID,.subChildJson)
				set subJson=subJson_"""children"":"_subChildJson
				set json=json_subJson
	    		set json=json_"}"
		 	}
			set itemSubID=$o(^DHCMed.CC.ItemSubCatI("ISCCodeIndex",ItemCatID,index,itemSubID))
		 }
		 set index=$o(^DHCMed.CC.ItemSubCatI("ISCCodeIndex",ItemCatID,index))
	 }
	set childJson="["_json_"]"
	quit retFlag
}

/// Creator：     liuyh
/// CreatDate：   2010-11-03
/// Description:  根据监控主题Id构造项目大类、子类的树形结构json串
/// Table：       DHCMed.CC.ItemCat、DHCMed.CC.ItemSubCat
/// Input：       subjectID：  监控主题ID
/// Return：      返回树形结构json串
/// Others:       此方法内部递归调用，构建菜单树
/// w ##class(DHCMed.CCService.SubjectSrv).BuildItemJson(8)
ClassMethod BuildItemJson(subjectID As %String) As %String
{
	new (subjectID)
	quit:'$d(^DHCMed.CC.ItemCatI("SubjectIndex",subjectID)) "[]"
	set json=""
		set itemID=$o(^DHCMed.CC.ItemCatI("SubjectIndex",subjectID,""))	
		while itemID'=""{
			set obj=##class(DHCMed.CC.ItemCat).%OpenId(itemID)
				set:json'="" json=json_","
				set itemJson="{"_"""id"":"""_itemID_"P"",""text"":"""_obj.ICDesc_""","
				//set itemJson=itemJson_"""iconCls"":""icon-pro"","
				set itemJson=itemJson_"""expanded"":true,"
				set secFlag=0,childJson="[]"
				d:$d(^DHCMed.CC.ItemSubCatI("ISCCodeIndex",itemID)) ..BuildItemSubJson(itemID,.childJson)
				//set itemJson=itemJson_"""checked"":false,"
				set itemJson=itemJson_"""children"":"_childJson_"}"
				set json=json_itemJson
			
			set itemID=$o(^DHCMed.CC.ItemCatI("SubjectIndex",subjectID,itemID))
			}
	quit "["_json_"]"
}

/// Creator：     liuyh
/// CreatDate：   2010-11-04
/// Description:  通过主题ID查询主题颜色信息
/// Table：       DHCMed.CC.SubjectColor
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.SubjectSrv","QrySubColorByID","1")
Query QrySubColorByID(SubjectID As %String) As %Query(ROWSPEC = "rowid:%String,ColorRGB:%String,SubjectDr:%String,Score:%String")
{
}

ClassMethod QrySubColorByIDExecute(ByRef qHandle As %Binary, SubjectID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:'$d(^DHCMed.CC.SubjectColorI("SubjectIndex",SubjectID)) $$$OK
	s rowid=""
	f  s rowid=$o(^DHCMed.CC.SubjectColorI("SubjectIndex",SubjectID,rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.CC.SubjectColor).%OpenId(rowid)
	.q:'$IsObject(obj)
	.s $li(data,1)=rowid
	.s $li(data,2)=obj.ColorRGB
	.s $li(data,3)=obj.SubjectDr
	.s $li(data,4)=obj.Score
 	.s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    .d obj.%Close()
	q $$$OK
}

ClassMethod QrySubColorByIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySubColorByIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySubColorByIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySubColorByIDExecute ]
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

/// Creator：     jiangpengpeng
/// CreatDate：   2014-7-4
/// Description:  导入主题配置
/// Table：       DHCMed.CC.SubjectConfig
/// w ##class(DHCMed.CCService.SubjectSrv).ImportSubject()
ClassMethod ImportSubject(InStr As %String, separete As %String) As %String
{
	new (InStr,separete)
	Set Return=""
	Quit:(InStr="")||(separete="") return
	
	Set SubjectCode=$p(InStr,separete,1)
	Set Code=$p(InStr,separete,2)
	Set Description=$p(InStr,separete,3)
	Set IsActive=$p(InStr,separete,4)
	Set ResumeText=$p(InStr,separete,5)
	
	Set ID=$o(^DHCMed.CC.SubjectConfigI("IndexCode"," "_$zcvt(Code,"U"),""))
	Set InputStr=ID_"^"_SubjectCode_"^"_Code_"^"_Description_"^"_IsActive_"^"_ResumeText
	Set Return=##class(DHCMed.CC.SubjectConfig).Update(InputStr)
	Quit Return
}

}
