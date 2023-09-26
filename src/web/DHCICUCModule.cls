/// 代码表Query
Class web.DHCICUCModule Extends %RegisteredObject
{

/// Creator：        yuanlin
/// CreatDate：      2021-04-06
/// Description：    查询评分数据模块
/// Table：          User.DHCICUCModule
/// Input:           filterDesc:数据模块名称筛选字符串，parentModuleId:父模块ID
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCICUCModule","FindDataModule","1","1")
Query FindDataModule(filterDesc As %String, parentModuleId As %String, moduleCode As %String = "", needActive As %String = "N") As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
       Code,
       Description,
       ParentModule,
       ParentModule As _parentId,
       ParentModule->Description As ParentModuleDesc,
       UrL,
       Icon,
       Params,
       Active,
       %External(Active) As ActiveDesc,
       SeqNo
       from SQLUSER.DHC_ICUC_Module
       where ((UPPER(Description) like UPPER('%'_:filterDesc)) or (:filterDesc is null))
       and ((ParentModule=:parentModuleId) or ((not :parentModuleId is null) and (ParentModule is null) and (RowId=:parentModuleId)) or (:parentModuleId is null))
       and ((Code=:moduleCode) or (:moduleCode is null))
       order by SeqNo
}

/// Creator：        yuanlin
/// CreatDate：      2021-04-06
/// Description：    查询菜单项
/// Table：          User.DHCICUCModule
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCICUCModule","FindMenuItem","OPWSMenu")
Query FindMenuItem(menuCode As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
       Code As MenuItemCode,
       Description As MenuItemDesc,
       Description As DisplayName,
       ParentModule As ModuleCode,
       ParentModule->Description As MainItemDesc,
       ParentModule->Description As MainItemDisplayName,
       UrL,
       Icon,
       Params,
       SeqNo
	   from SQLUSER.DHC_ICUC_Module where Active="Y"
	   order by SeqNo
}

/// Creator：        yuanlin
/// CreatDate：      2021-04-06
/// Description：    查询单条重症监护记录
/// Table：          User.DHCICUArrange
/// Input:          
/// Output: 		 重症记录表各字段值
/// d ##class(%ResultSet).RunQuery("web.DHCICUCModule","FindIcuArrangeById","1")
Query FindIcuArrangeById(icuaId As %String) As %Query(ROWSPEC = "EpisodeID:%String,PatientID:%String,RegNo:%String,medCareNo:%String,PatName:%String,birth:%String,PatAge:%String,PatGender:%String,AdmReason:%String") [ SqlProc ]
{
}

ClassMethod FindIcuArrangeByIdExecute(ByRef qHandle As %Binary, icuaId As %String) As %Status
{
  	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s AdmReason=""
	s EpisodeID=$p($g(^DHCICUArrange(+icuaId)),"^",1)
	s PatientID=+$g(^PAADM(+EpisodeID))
	s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	s paadmtype=$p($g(^PAADM(EpisodeID)),"^",2)
	s RegNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s medCareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,paadmtype,.ErrMsg)
	s PatName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	s PatAge=##class(web.DHCBillInterface).GetPapmiAge(papmiId,EpisodeID)
	s PatGender=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	d OutPutOrdStat
 	s qHandle=$lb(0,repid,0)
	q $$$OK

OutPutOrdStat
	s Data=$lb(EpisodeID,PatientID,RegNo,medCareNo,PatName,birth,PatAge,PatGender,AdmReason)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindIcuArrangeByIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindIcuArrangeByIdExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindIcuArrangeByIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindIcuArrangeByIdExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

}
