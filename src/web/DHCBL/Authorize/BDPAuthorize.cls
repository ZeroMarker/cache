Import SQLUser

/// 名称: 基础数据平台授权
/// 描述: 基础数据平台授权(组织结构显示)
/// 编写者：BDP-Caihaozhe
/// 编写日期: 2013-5-6
Class web.DHCBL.Authorize.BDPAuthorize Extends %RegisteredObject
{

/// 组织结构显示(用户、科室、安全组)
/// Creator：蔡昊哲
/// CreatDate: 2013-5-6
/// Description：获取用户列表
/// Table：User.SSUser
/// Input：RowId1, Code, Desc, CTPCPCarPrvTpDR, ActiveFlag, InternalType
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.Authorize.BDPAuthorize","GetUserList","","")
Query GetUserList(rowid, desc) As %Query(ROWSPEC = "SSUSRRowId,SSUSRName")
{
}

ClassMethod GetUserListExecute(ByRef qHandle As %Binary, rowid, desc) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	;if (rowid'="") //根据rowid返回该条记录
	;{
	;	s SSUSRRowId=rowid
	;	s SSUSRName=$p(^SSU("SSUSR",SSUSRRowId),"^",2)       //用户名
	;	d OutputRow
	;}
	;else
	;{
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s SSUSRRowId=0
		for
		{
			s SSUSRRowId=$o(^SSU("SSUSR",SSUSRRowId)) q:SSUSRRowId=""
			s SSUSRName=$p(^SSU("SSUSR",SSUSRRowId),"^",2)       //用户名
			s SSUSRNameB=$ZCONVERT(SSUSRName,"U")
			
			s SSUSRActive=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",19)      //是否激活
			s SSUSRDateFrom=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",96)  //开始日期
			s SSUSRDateTo=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",97)  //结束日期
			continue:SSUSRActive="N"
			continue:(SSUSRDateFrom'="")&&(SSUSRDateFrom>+$h)
			continue:(SSUSRDateTo'="")&&(SSUSRDateTo<+$h)
			i (SSUSRNameB[desc)
			{
				d OutputRow
			}
			
		}
		
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(SSUSRRowId,SSUSRName)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetUserListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUserListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetUserListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：蔡昊哲
/// CreatDate: 2013-5-7
/// Description：获取科室列表
/// Table：User.CTLoc
/// Input：RowId1, Code, Desc, CTPCPCarPrvTpDR, ActiveFlag, InternalType
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.Authorize.BDPAuthorize","GetLocList","","")
Query GetLocList(rowid, desc) As %Query(ROWSPEC = "CTLOCRowID,CTLOCDesc")
{
}

ClassMethod GetLocListExecute(ByRef qHandle As %Binary, rowid, desc) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s:desc'="" desc=$ZCONVERT(desc,"U")
	s CTLOCRowID=0
	for
	{
		s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""
		s CTLOCDesc=$p(^CTLOC(CTLOCRowID),"^",2)       //用户名
		s CTLOCDescB=$ZCONVERT(CTLOCDesc,"U")
		s CTLOCDateActiveFrom=$p($g(^CTLOC(CTLOCRowID)),"^",24)    //开始日期
	        s CTLOCDateActiveTo=$p($g(^CTLOC(CTLOCRowID)),"^",25)    //截止日期
	        continue:(CTLOCDateActiveFrom'="")&&(CTLOCDateActiveFrom>+$h)
	        continue:(CTLOCDateActiveTo'="")&&(CTLOCDateActiveTo<+$h)
		s CTLOCActiveFlag=$p($g(^CTLOC(CTLOCRowID)),"^",14)	//是否有效(Y/N)
		continue:CTLOCActiveFlag="N"
		 
		s Pinyin=$p($g(^CTLOC(CTLOCRowID)),"^",43)
		i ((CTLOCDescB[desc)||($ZCONVERT(Pinyin,"U")[desc))
		{
			d OutputRow
		} 
		
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(CTLOCRowID,CTLOCDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：蔡昊哲
/// CreatDate: 2013-5-6
/// Description：获取安全组列表
/// Table：User.SSGroup
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.Authorize.BDPAuthorize","GetGroupList","","")
Query GetGroupList(rowid, desc) As %Query(ROWSPEC = "SSGRPRowId,SSGRPDesc")
{
}

ClassMethod GetGroupListExecute(ByRef qHandle As %Binary, rowid, desc) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	;if (rowId'="")
	;{
	;	s SSGRPRowId=rowid
	;	s SSGRPDesc=$p($g(^SSU("SSGRP",SSGRPRowId)),"^",1)
	;	d OutputRow
	;}
	;else
	;{
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s SSGRPRowId=0
		for  
		{
			s SSGRPRowId=$o(^SSU("SSGRP",SSGRPRowId)) q:SSGRPRowId=""  d
			s SSGRPDesc=$p($g(^SSU("SSGRP",SSGRPRowId)),"^",1)
			continue:SSGRPDesc["停用"
			s SSGRPDescB=$ZCONVERT(SSGRPDesc,"U")
			s SSGRPActiveFlag=$p($g(^SSU("SSGRP",SSGRPRowId)),"^",151) //有效标志 2021-08-26 
			continue:(SSGRPActiveFlag="N")
			s SSGRPEndDate=$p($g(^SSU("SSGRP",SSGRPRowId)),"^",154)  //结束日期
			continue:(SSGRPEndDate'="")&&(SSGRPEndDate<+$h)
			i (SSGRPDescB[desc)
			{
				d OutputRow
			}
		}
		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(SSGRPRowId,SSGRPDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetGroupListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGroupListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetGroupListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGroupListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// by CaiHZ   		 
/// 2013/5/14
/// 将json存入list中，方便获取 list.GetAt(1)
ClassMethod ListFromJSON(jsonstr As %String) As %ListOfDataTypes
{
	;s list=##class(web.DHCBL.Authorize.BDPAuthorize).ListFromJSON("[{ID:2},{ID:3},{ID:5}]")
	if jsonstr="" Quit ""	
	set jsonlist=##class(%ListOfDataTypes).%New()	
	s jsonstrlen=$length(jsonstr)
	s tempstr=$EXTRACT(jsonstr,2,jsonstrlen-1)
	s len=$length(tempstr,",")
	for i=1:1:len {
		s idstr=$P(tempstr,",",i)
		s idstrlen=$length(idstr)
		s idstr=$EXTRACT(idstr,2,idstrlen-1)
		s id=$P(idstr,":",2)
		d jsonlist.Insert(id)
	}
	Q jsonlist
}

}
