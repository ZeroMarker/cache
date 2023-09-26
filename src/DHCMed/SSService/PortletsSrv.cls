/// 描述:		自定义页签维护
/// 创建人:		maxp 
/// 创建时间:	2012-09-18 
Class DHCMed.SSService.PortletsSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     maxp
/// CreatDate：   2012-09-18
/// Description:  通过页签代码查询页签信息
/// Table：       DHCMed.SS.Portlets
/// Input：       PorCode：页签代码 
/// 
/// modify by maxp 2012-09-19 删除查询条件	
/// d ##class(%ResultSet).RunQuery("DHCMed.SSService.PortletsSrv","QryPortlets")
Query QryPortlets() As %Query(ROWSPEC = "Rowid:%String,Code:%String,Description:%String,Height:%String,AutoRefreash:%String,Frequency:%String,Resume:%String,IsActive:%String,Message:%String,MsgClassMethod:%String,MsgMenuDr:%String,MsgURL:%String,QueryName:%String,DtlMenuDr:%String,DtlURL:%String,DtlShowType:%String,DtlShowConfig:%String")
{
}

ClassMethod QryPortletsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPortletsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryPortletsExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
 	s qHandle=$lb(0,repid,0)
 	s index=1
 	
	s rowid=0
	f  s rowid=$o(^DHCMed.SS.PortletsD(rowid)) q:rowid=""  d
 	.s obj=##class(DHCMed.SS.Portlets).%OpenId(rowid)
 	.;q:((PorCode'="")&(obj.Code'[PorCode))
 	.d SetAllInfo
		 
   do obj.%Close()
   Quit $$$OK
   
SetAllInfo
 s Rowid=rowid
 s Code=obj.Code
 s Description=obj.Description
 s Height=obj.Height
 s AutoRefreash=$s(obj.AutoRefreash=0:"否",1:"是")
 i AutoRefreash=0  d 
  .s Frequency=""
 e  d
  .s Frequency=obj.Frequency_"分钟"
 s Resume=obj.Resume
 s IsActive=$s(obj.IsActive=0:"否",1:"是")
 s Message=obj.Message
 s MsgClassMethod=obj.MsgClassMethod
 s MsgMenuDr=obj.MsgMenuDr
 s MsgURL=obj.MsgURL
 s QueryName=obj.QueryName
 s DtlMenuDr=obj.DtlMenuDr
 s DtlURL=obj.DtlURL
 s DtlShowType=obj.DtlShowType
 s DtlShowConfig=obj.DtlShowConfig
 d OutAllInfo
 Q    
 
OutAllInfo
 s Data=$lb(Rowid,Code,Description,Height,AutoRefreash,Frequency,Resume,IsActive,Message,MsgClassMethod,MsgMenuDr,MsgURL,QueryName,DtlMenuDr,DtlURL,DtlShowType,DtlShowConfig)
 s ^CacheTemp(repid,index)=Data
 s index=index+1
 quit
}

ClassMethod QryPortletsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPortletsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set index=$LIST(qHandle,3)
 	Set index=$o(^CacheTemp(repid,index))
 	If index="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,index)
 	}
 	s qHandle=$lb(AtEnd,repid,index)
	Quit $$$OK
}

/// Creator：     maxp
/// CreatDate：   2012-09-20
/// Description:  通过页签Id查询页签信息
/// Table：       DHCMed.SS.Portlets
/// Input：       Id：页签Id 
/// 
/// modify by maxp 2012-10-12 添加showConfig处理	
/// w ##Class(DHCMed.SSService.PortletsSrv).GetPortletInfoById(1)
ClassMethod GetPortletInfoById(PortletsId As %String) As %String
{
 	new (PortletsId)
	
	set return="",PReturn="",MReturn="",DReturn=""
	quit:PortletsId="" return
	
	quit:'$d(^DHCMed.SS.PortletsD(PortletsId)) return
	set obj=##class(DHCMed.SS.Portlets).%OpenId(PortletsId)
	
	set:obj.MsgMenuDr'="" MReturn=##Class(DHCMed.SS.Menus).GetObjById(obj.MsgMenuDr)	
	set:(obj.MsgMenuDr="")&(obj.DtlMenuDr'="") MReturn=##Class(DHCMed.SS.Menus).GetObjById(obj.DtlMenuDr)
	;set:obj.DtlMenuDr'="" DReturn=##Class(DHCMed.SS.Menus).GetObjById(obj.DtlMenuDr)
	
	set return=PortletsId_"^"
	set return=return_obj.Code_"^"
	set return=return_obj.Description_"^"
	set return=return_obj.Height_"^"
	set return=return_obj.AutoRefreash_"^"
	set return=return_obj.Frequency_"^"
	set return=return_obj.Resume_"^"
	set return=return_obj.IsActive_"^"
	set return=return_obj.Message_"^"
	set return=return_obj.MsgClassMethod_"^"
	set return=return_obj.MsgMenuDr_"^"
	set return=return_obj.MsgURL_"^"
	set return=return_obj.QueryName_"^"
	set return=return_obj.DtlMenuDr_"^"
	set return=return_obj.DtlURL_"^"
	set return=return_obj.DtlShowType_"^"
	s showConfig=obj.DtlShowConfig
    s obj.DtlShowConfig=##class(DHCMed.SS.Portlets).ShowConfigToString(showConfig)
	
	set return=return_obj.DtlShowConfig_"^"
	
	if $IsObject(MReturn){
	 	set:obj.MsgMenuDr'="" return=return_MReturn.MenuCaption_"^"
	 	set:obj.MsgMenuDr="" return=return_"^"
	 	set return=return_MReturn.ProductDr_"^"
	 	set:MReturn.ProductDr'="" PReturn=##Class(DHCMed.SS.Products).GetObjById(MReturn.ProductDr)
	 	set:$IsObject(PReturn) return=return_PReturn.ProName_"^"
	 	set:obj.DtlMenuDr'="" return=return_MReturn.MenuCaption
	 }
	 else{
		set return=return_"^^^" 
	 }
	do obj.%Close()
	quit return
}

///  Creator：     maxp
///  CreatDate：   2012-10-12
///  Description:  通过页签Id查询页签明细设置中表格类型的设置信息
///  Table：       DHCMed.SS.Portlets
///  Input：       Id：页签Id,  queryName  
/// modify by maxp 2013-1-31 : 添加入参queryName	
///  d ##class(%ResultSet).RunQuery("DHCMed.SSService.PortletsSrv","GetGridInfoById","","DHCMed.SSService.StudentSrv||QueryStudents")
Query GetGridInfoById(PortletId As %String, queryName As %String) As %Query(ROWSPEC = "colName:%String,dataIndex:%String,colHeader:%String,isHidden:%Integer")
{
}

ClassMethod GetGridInfoByIdExecute(ByRef qHandle As %Binary, PortletId As %String, queryName As %String) As %Status
{
	s repid=$I(^CacheTemp)
 	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	if PortletId'=""{
	 	s obj=##class(DHCMed.SS.Portlets).%OpenId(PortletId)
	 	s gridInfo=obj.DtlShowConfig
	 	q:obj.QueryName="" $$$OK
	 	if obj.QueryName=queryName{  //queryName没有改变
		 	if gridInfo=""{
		 		s queryName=obj.QueryName
		 		d GetGridInfo
		 	}
		 	else{
			 	s len=$ll(gridInfo)
			 	f i=2:1:len {
				 	s colInfo=$li(gridInfo,i)
				 	s $li(data,1)=$li(colInfo,1)
				 	s $li(data,2)=$li(colInfo,2)
				 	s $li(data,3)=$li(colInfo,3)
				 	s $li(data,4)=+$li(colInfo,4)
				 	s ^CacheTemp(repid,ind)=data
			    	s ind=ind+1
			 	}
		 	}
	 	}
	 	else{  //queryName改变
	 		d GetGridInfo
	 	}
		do obj.%Close()
 	}
 	else { //新建页签时
	 	d GetGridInfo
 	}
	Quit $$$OK
	
GetGridInfo
	Quit:queryName="" $$$OK		 		
		set qdf = ##class(%Dictionary.QueryDefinition).%OpenId(queryName)
		set columns = qdf.Parameters.GetAt("ROWSPEC")
		
	    f i=1:1:$l(columns,",") {
		    s name=$p($p(columns,",",i),":",1)
		    s header=name
		    s:$l($p(columns,",",i))=3 header=$p($p(columns,",",i),":",3)
		    s $li(data,1)=name
		    s $li(data,2)=name
		    s $li(data,3)=header
			s $li(data,4)=0
		 	s ^CacheTemp(repid,ind)=data
	    	s ind=ind+1
	 	}
}

ClassMethod GetGridInfoByIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGridInfoByIdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetGridInfoByIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGridInfoByIdExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set index=$LIST(qHandle,3)
 	Set index=$o(^CacheTemp(repid,index))
 	If index="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,index)
 	}
 	s qHandle=$lb(AtEnd,repid,index)

	Quit $$$OK
}

///   Creator：     maxp
///   CreatDate：   2012-12-6
///   Description:  通过页签Id查询要显示的表格列名称
///   Table：       DHCMed.SS.Portlets
///   Input：       Id：页签Id 
///   Return：	   字符串形式的columnName	
///   w ##class(DHCMed.SSService.PortletsSrv).getColumnsString(18)
ClassMethod getColumnsString(id)
{
	new (id)
	s str=""
	s columnName=""
	s columnHeader=""
	s obj=##class(DHCMed.SS.Portlets).%OpenId(+id)
 	s gridInfo=obj.DtlShowConfig
 	Q:gridInfo="" str
	s len=$ll(gridInfo)
	f i=2:1:len {
		
		s colInfo=$li(gridInfo,i)
		s name=$li(colInfo,2)
		s header=$li(colInfo,3)
		s flag=+$li(colInfo,4)
		if flag>0 d
		.s:columnName'="" columnName=columnName_"^"
		.s:columnHeader'="" columnHeader=columnHeader_"^"
		.s columnName=columnName_name
		.s columnHeader=columnHeader_header
		;w !,name_"$"_header_"$"_flag
	}
	s str= columnName_"#"_columnHeader
	q str
}

}
