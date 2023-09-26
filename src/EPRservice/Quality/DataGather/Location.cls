Class EPRservice.Quality.DataGather.Location Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Desc:	获取科室组列表(华西在用,主要应用质控报表);
/// Input:	AGroupDesc为科室组描述;
/// Debug: 	d ##Class(%ResultSet).RunQuery("EPRservice.Quality.DataGather.Location","GetLocGroupList")
Query GetLocGroupList(AGroupDesc As %String) As %Query(ROWSPEC = "RowID,Description")
{
}

ClassMethod GetLocGroupListExecute(ByRef qHandle As %Binary, AGroupDesc As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s RowID = 0
	for {
		s RowID = $o(^CT("LL",RowID))
		q:(RowID = "")
		
		s GroupInfo = $g(^CT("LL",RowID))
		//s Code = $p(GroupInfo,"^",1)
		s Desc = $p(GroupInfo,"^",2)
		continue:(AGroupDesc '= "")&&( Desc '[ AGroupDesc)
		
		s Data = $lb(RowID,Desc)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1 	
	}
	
	q $$$OK
}

ClassMethod GetLocGroupListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocGroupListExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{			
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{				
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetLocGroupListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocGroupListExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid) 	
 	q $$$OK
}

/// Desc:	Get departments or wards, if assigned <ADepartmentID>, then get all wards under this <ADepartmentID>
/// Input:	AType represents the type of location,E means executable department, W means ward
/// 		ALocID represents one executable department
/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.Quality.DataGather.Location","GetLocationList","E","","")
Query GetLocationList(AType As %String, ALocID As %String = "", ALocName As %String = "", AHospitalID As %String = "") As %Query(ROWSPEC = "ID:%String,Name:%String") [ SqlProc ]
{
}

ClassMethod GetLocationListExecute(ByRef qHandle As %Binary, AType As %String, ALocID As %String = "", ALocName As %String = "", AHospitalID As %String = "") As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)

	q:($d(AType) = 0)||(AType = "") $$$OK
	
	
	// 业务逻辑：
	// 如果AType为“E”代表执行科室，则加载所有执行科室；如果此时LocID不为空，则加载该科室；如果ALocName不为空，则加载包含ALocName的科室；
	// 如果AType为“W”代表科室病区，则加载所有科室病区；如果此时LocID不为空，则加载该科室下的病区；如果ALocName不为空，则加载包含ALocName的病区；
	
	s Type		 = $g(AType)
	s LocID		 = $g(ALocID)
	s LocName	 = $g(ALocName)
		
	s RowID = ""
	for {
		s RowID = $o(^CTLOC(0,"LocType",Type,RowID))
		q:(RowID = "")
		
		s objCtLoc = $g(^CTLOC(+RowID))
		s objCtLoc = $g(^CTLOC(+RowID))
		s HspID = $P(objCtLoc,"^",22)
		continue:(HspID'="")&&(AHospitalID'="")&&(AHospitalID'=HspID)
		s Desc = $p(objCtLoc,"^",2)
		continue:(Desc [ "门诊")
		continue:(Desc [ "医院")					//华西医院专用
		s ContactName = $p(objCtLoc,"^",43)			//一些医院用于存储科室或病区拼音码
		//New Added By HKY
		s enddate=$P(objCtLoc,"^",25)
        //判断科室是否过期
        if ((enddate="")||((enddate-$P($h,",",1) >=0)))
        {
            s isActive=1
        }
        else
        {
            s isActive=0
        }
        
        //判断是否关联病区
        s pacid=""
        s pacid=$O(^CTLOC(RowID,"LINK",0,""))
        
       
        if (pacid)="" s isActive=0
   
        continue:(isActive=0)
		
		// 匹配科室或者病区名称，包括拼音码
		continue:(LocName '= "")&&( Desc '[ LocName)&&( $zcvt(ContactName,"U") '[ $zcvt(LocName,"U"))
		
		s:(Desc [ "-") Desc = $p(Desc,"-",2) 
        s Desc=##class(EMRservice.HISInterface.Translation).GetTranByDesc("User.CTLoc","CTLOCDesc",Desc)
		// 匹配科室ID，如果Type为E，则只需要找到
		if (LocID '= "")
		{
			if (Type = "E")
			{
				continue:(LocID '= RowID)	
				
				s Data = $lb(RowID,Desc)
				s ^CacheTemp(repid,ind) = Data
				s ind = ind+1		
			}
			else
			{
				// 找指定科室下的病区
				
				//根据科室遍历病区^CTLOC({CT_Loc.CTLOC_RowID},"LINK",0,"Loc",{LINK_CTLOC_DR},{LINK_Childsub})
				s WardID = ""
				for { 
					s WardID = $o(^CTLOC(LocID,"LINK",0,"Loc",WardID))
					q:(WardID = "")
					
					continue:(WardID '= RowID)
										
					s Title = $p(^CTLOC(+WardID),"^",2)
					s:(Title [ "-") Title = $p(Title,"-",2)
					
					s Data = $lb(WardID,Title)
					s ^CacheTemp(repid,ind) = Data
					s ind = ind + 1
				}
			}
		}
		else
		{
			s Data = $lb(RowID,Desc)
			s ^CacheTemp(repid,ind) = Data
			s ind = ind + 1		
		}	
	}
	q $$$OK
}

ClassMethod GetLocationListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocationListExecute ]
{
 	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{			
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{				
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetLocationListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocationListExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid) 	
 	q $$$OK
}

/// Debug: w ##Class(EPRservice.Quality.DataGather.Location).GetLocStringByLocGroupID(1)
ClassMethod GetLocStringByLocGroupID(ALocGroupID As %String) As %String
{
	s ret = "", IsFirst = 0
	
	s RowID = ""
	for {
		s RowID = $o(^CTLOC(0,"LocType","E",RowID))
		q:(RowID = "")
		
		continue:(ALocGroupID '= "")&&('$d(^CT("LL",ALocGroupID,"LOC",0,"Loc",RowID)))	
		
		s objCtLoc = $g(^CTLOC(+RowID))
		
		s Desc = $p(objCtLoc,"^",2)
		continue:(Desc [ "门诊")
		continue:(Desc [ "医院")
		
		s:(Desc [ "-") Desc = $p(Desc,"-",2)
		
		if (IsFirst = 0)
		{
			s ret = RowID_"^"_Desc
			s IsFirst = 1	
		}
		else
		{
			s ret = ret_"|"_RowID_"^"_Desc	
		} 
	}
	
	q ret
}

/// new added by HKY
/// modify by candy 修改可查询条目的实现方式，由原来做为质控标准改了条目的一个属性，查出所有条目查询属性为Y
/// d ##Class(%ResultSet).RunQuery("EPRservice.Quality.DataGather.Location","GetEntryIDandPoolTitle")
Query GetEntryIDandPoolTitle() As %Query(ROWSPEC = "EntryID,Title") [ SqlProc ]
{
}

ClassMethod GetEntryIDandPoolTitleExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s PoolID = ""
	for {
		s PoolID = $o(^DHCEPRM.QualityPoolI("IdxIsQuery"," Y",PoolID))  //条目属性为Y的记录
		q:(PoolID = "")
		s objPool=##class(EPRmeta.Quality.QualityPool).%OpenId(PoolID)
		continue:(objPool = "")
		s EntryFlag=0
		s EntryID=""
		for
		{
			s EntryID=$o(^DHCEPRM.QualityEntryI("IdxPoolDR"," "_PoolID,EntryID))
			q:(EntryID="")
			s objEntryID=##class(EPRmeta.Quality.QualityEntry).%OpenId(EntryID)
			continue:(objEntryID.IsActive'="Y")
			s EntryFlag=1
		}
		continue:(EntryFlag=0)
		s Title = objPool.Title
	    s Data=$lb(PoolID,Title)
	    s ^CacheTemp(repid,ind)=Data
	    s ind=ind+1
	}
	Quit $$$OK
}

ClassMethod GetEntryIDandPoolTitleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEntryIDandPoolTitleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetEntryIDandPoolTitleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEntryIDandPoolTitleExecute ]
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
	
	Quit $$$OK
}

/// 根据科室组取科室
/// Add by HKY
Query GetLocStringByLocGroupID() As %Query(ROWSPEC = "GroupID,RowID,Desc")
{
}

ClassMethod GetLocStringByLocGroupIDExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	  
    s ret = "", IsFirst = 0

     s RowID = ""
       for {

		s RowID = $o(^CTLOC(0,"LocType","E",RowID)) 
		
		q:(RowID = "")
		
		//continue:(ALocGroupID '= "")&&('$d(^CT("LL",ALocGroupID,"LOC",0,"Loc",RowID)))
	    s RID = ""
	     for {
		    s RID = $o(^CT("LL",RID))
		    q:(RID = "")
		     if ($d(^CT("LL",RID,"LOC",0,"Loc",RowID)) '= 0)
		     {  
		    s objCtLoc = $g(^CTLOC(+RowID))
		
		    s Desc = $p(objCtLoc,"^",2)
		
		    //continue:(Desc [ "门诊")
		   // continue:(Desc [ "医院")
		
		    s:(Desc [ "-") Desc = $p(Desc,"-",2)
		    s Data = $lb(RID,RowID,Desc)
		    s ^CacheTemp(repid,ind) = Data
		    s ind = ind + 1 
		     }
		 }
	
	}
     
	Quit $$$OK
}

ClassMethod GetLocStringByLocGroupIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocStringByLocGroupIDExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetLocStringByLocGroupIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocStringByLocGroupIDExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{			
 		s AtEnd = 1
 		s Row = ""

 	} 
 	else 
 	{				
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
 	
	Quit $$$OK
}

/// Desc:根据科室ID取其描述值
/// Creator:candyxu
/// Createdate:2013-02-27
/// Input:科室ID
/// OutPut:科室描述值
/// Debug:w ##Class(EPRservice.Quality.DataGather.Location).GetLocDescByID(6)
ClassMethod GetLocDescByID(LocID As %String) As %String
{
	s result = ""
	q:(LocID = "") result
	q:($d(^CTLOC(LocID))= 0) result
	s result = $p($p(^CTLOC(LocID),"^",2),"-",2)
	q result
}

/// Desc: 取执行科室列表（Type默认为"E",不包含入参，供报表统计用）
/// Debug:d ##Class(%ResultSet).RunQuery("EPRservice.Quality.DataGather.Location","GetLocationListNew")
Query GetLocationListNew() As %Query(ROWSPEC = "ID:%String,Name:%String") [ SqlProc ]
{
}

ClassMethod GetLocationListNewExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s RowID = ""
	for {
		s RowID = $o(^CTLOC(0,"LocType","E",RowID))
		q:(RowID = "")
		
		s objCtLoc = $g(^CTLOC(+RowID))
		
		s Desc = $p(objCtLoc,"^",2)
		continue:(Desc [ "门诊")
		continue:(Desc [ "医院")					
		s ContactName = $p(objCtLoc,"^",43)			
		
		s enddate=$P(objCtLoc,"^",25)
        //判断科室是否过期
        if ((enddate="")||((enddate-$P($h,",",1) >=0)))
        {
            s isActive=1
        }
        else
        {
            s isActive=0
        }
        
        //判断是否关联病区
        s pacid=""
        s pacid=$O(^CTLOC(RowID,"LINK",0,""))
        
       
        if (pacid)="" s isActive=0
   
        continue:(isActive=0)
        s Data = $lb(RowID,Desc)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1		
        
	}
	Quit $$$OK
}

ClassMethod GetLocationListNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocationListNewExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid) 	
	
	Quit $$$OK
}

ClassMethod GetLocationListNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocationListNewExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{			
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{				
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Desc:	取门诊执行科室列表
/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.Quality.DataGather.Location","GetMZLocationList","E","","",AHospitalID)
Query GetMZLocationList(AType As %String, ALocID As %String = "", ALocName As %String = "", AHospitalID As %String = "") As %Query(ROWSPEC = "ID:%String,Name:%String") [ SqlProc ]
{
}

ClassMethod GetMZLocationListExecute(ByRef qHandle As %Binary, AType As %String, ALocID As %String = "", ALocName As %String = "", AHospitalID As %String = "") As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	s AType="O"
	q:($d(AType) = 0)||(AType = "") $$$OK
	
	
	
	
	// 业务逻辑：
	// 如果AType为“E”代表执行科室，则加载所有执行科室；如果此时LocID不为空，则加载该科室；如果ALocName不为空，则加载包含ALocName的科室；
	// 如果AType为“W”代表科室病区，则加载所有科室病区；如果此时LocID不为空，则加载该科室下的病区；如果ALocName不为空，则加载包含ALocName的病区；
	
	s Type		 = $g(AType)
	s LocID		 = $g(ALocID)
	s LocName	 = $g(ALocName)
	s RowID = ""
	for {
		s RowID = $o(^PAC("ADMLOC",0,"AdmType",Type,RowID))
		q:(RowID = "")
		
		s objCtLoc = $g(^CTLOC(+RowID))
		s HospitalDR = $p(^CTLOC(+RowID),"^",22)
		continue:(AHospitalID'="")&&(HospitalDR'=AHospitalID)
		s Desc = $p(objCtLoc,"^",2)
		continue:(Desc [ "医院")					
		s ContactName = $p(objCtLoc,"^",43)			//一些医院用于存储科室或病区拼音码
		
		// 匹配科室或者病区名称，包括拼音码
		continue:(LocName '= "")&&( Desc '[ LocName)&&( $zcvt(ContactName,"U") '[ $zcvt(LocName,"U"))
		
		s:(Desc [ "-") Desc = $p(Desc,"-",2) 
	     s Desc=##class(EMRservice.HISInterface.Translation).GetTranByDesc("User.CTLoc","CTLOCDesc",Desc)
		// 匹配科室ID，如果Type为E，则只需要找到
	   if (LocID'="")
	   {	
	    if (Type = "E")
		{
		  continue:(LocID '= RowID)	
				
		  s Data = $lb(RowID,Desc)
		  s ^CacheTemp(repid,ind) = Data
		  s ind = ind+1		
		}
		else
		{
		  // 找指定科室下的病区
		  //根据科室遍历病区^CTLOC({CT_Loc.CTLOC_RowID},"LINK",0,"Loc",{LINK_CTLOC_DR},{LINK_Childsub})
		  s WardID = ""
		  for { 
				s WardID = $o(^CTLOC(LocID,"LINK",0,"Loc",WardID))
				q:(WardID = "")
					
				continue:(WardID '= RowID)
										
				s Title = $p(^CTLOC(+WardID),"^",2)
				s:(Title [ "-") Title = $p(Title,"-",2)
					
				s Data = $lb(WardID,Title)
				s ^CacheTemp(repid,ind) = Data
				s ind = ind + 1
			  }
		 }
	  }
	  else
	  {
		  s Data = $lb(RowID,Desc)
		  s ^CacheTemp(repid,ind) = Data
		  s ind = ind+1	 
	  }
	}
	
	q $$$OK
}

ClassMethod GetMZLocationListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMZLocationListExecute ]
{
 	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{			
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{				
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GeMZLocationListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMZLocationListExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid) 	
 	q $$$OK
}

/// Desc:	Get departments or wards, if assigned <ADepartmentID>, then get all wards under this <ADepartmentID>
/// Input:	AType represents the type of location,E means executable department, W means ward
/// 		ALocID represents one executable department
/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.Quality.DataGather.Location","GetAllLocationList","E","","")
Query GetAllLocationList(AType As %String, ALocID As %String = "", ALocName As %String = "", AHospitalID As %String = "") As %Query(ROWSPEC = "ID:%String,Name:%String") [ SqlProc ]
{
}

ClassMethod GetAllLocationListExecute(ByRef qHandle As %Binary, AType As %String, ALocID As %String = "", ALocName As %String = "", AHospitalID As %String = "") As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)

	q:($d(AType) = 0)||(AType = "") $$$OK
	
	s ^KKTemp=$lb(AType,ALocID,ALocName,AHospitalID)
	// 业务逻辑：
	// 如果AType为“E”代表执行科室，则加载所有执行科室；如果此时LocID不为空，则加载该科室；如果ALocName不为空，则加载包含ALocName的科室；
	// 如果AType为“W”代表科室病区，则加载所有科室病区；如果此时LocID不为空，则加载该科室下的病区；如果ALocName不为空，则加载包含ALocName的病区；
	
	s Type		 = $g(AType)
	s LocID		 = $g(ALocID)
	s LocName	 = $g(ALocName)
		
	s RowID = ""
	for {
		s RowID = $o(^CTLOC(0,"LocType",Type,RowID))
		q:(RowID = "")
		
		s objCtLoc = $g(^CTLOC(+RowID))
		s objCtLoc = $g(^CTLOC(+RowID))
		s HspID = $P(objCtLoc,"^",22)
		continue:(HspID'="")&&(AHospitalID'="")&&(AHospitalID'=HspID)
		s Desc = $p(objCtLoc,"^",2)
		//continue:(Desc [ "门诊")
		continue:(Desc [ "医院")					//华西医院专用
		s ContactName = $p(objCtLoc,"^",43)			//一些医院用于存储科室或病区拼音码
		//New Added By HKY
		s enddate=$P(objCtLoc,"^",25)
		
        //判断科室是否过期
        if ((enddate="")||((enddate-$P($h,",",1) >=0)))
        {
            s isActive=1
        }
        else
        {
            s isActive=0
        }
        
        //判断是否关联病区
        s pacid=""
        s pacid=$O(^CTLOC(RowID,"LINK",0,""))
        
       
        //if (pacid)="" s isActive=0
   		
        continue:(isActive=0)
		
		// 匹配科室或者病区名称，包括拼音码
		continue:(LocName '= "")&&( Desc '[ LocName)&&( $zcvt(ContactName,"U") '[ $zcvt(LocName,"U"))
		
		s:(Desc [ "-") Desc = $p(Desc,"-",2) 
		
		// 匹配科室ID，如果Type为E，则只需要找到
		if (LocID '= "")
		{
			if (Type = "E")
			{
				continue:(LocID '= RowID)	
				
				s Data = $lb(RowID,Desc)
				s ^CacheTemp(repid,ind) = Data
				s ind = ind+1		
			}
			else
			{
				// 找指定科室下的病区
				
				//根据科室遍历病区^CTLOC({CT_Loc.CTLOC_RowID},"LINK",0,"Loc",{LINK_CTLOC_DR},{LINK_Childsub})
				s WardID = ""
				for { 
					s WardID = $o(^CTLOC(LocID,"LINK",0,"Loc",WardID))
					q:(WardID = "")
					
					continue:(WardID '= RowID)
										
					s Title = $p(^CTLOC(+WardID),"^",2)
					s:(Title [ "-") Title = $p(Title,"-",2)
				
					s Data = $lb(WardID,Title)
					s ^CacheTemp(repid,ind) = Data
					s ind = ind + 1
				}
			}
		}
		else
		{
			s Data = $lb(RowID,Desc)
			s ^CacheTemp(repid,ind) = Data
			s ind = ind + 1		
		}	
	}
	q $$$OK
}

ClassMethod GetAllLocationListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllLocationListExecute ]
{
 	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{			
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{				
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetAllLocationListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllLocationListExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid) 	
 	q $$$OK
}

/// Desc:	Get departments or wards, if assigned <ADepartmentID>, then get all wards under this <ADepartmentID>
/// Input:	AType represents the type of location,E means executable department, W means ward
/// 		ALocID represents one executable department
/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.Quality.DataGather.Location","GetOPLocationList","E","","")
Query GetOPLocationList(AType As %String, ALocID As %String = "", ALocName As %String = "") As %Query(ROWSPEC = "ID:%String,Name:%String") [ SqlProc ]
{
}

ClassMethod GetOPLocationListExecute(ByRef qHandle As %Binary, AType As %String, ALocID As %String = "", ALocName As %String = "") As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)

	q:($d(AType) = 0)||(AType = "") $$$OK
	
	// 业务逻辑：
	// 如果AType为“E”代表执行科室，则加载所有执行科室；如果此时LocID不为空，则加载该科室；如果ALocName不为空，则加载包含ALocName的科室；
	// 如果AType为“W”代表科室病区，则加载所有科室病区；如果此时LocID不为空，则加载该科室下的病区；如果ALocName不为空，则加载包含ALocName的病区；
	
	s Type		 = $g(AType)
	s LocID		 = $g(ALocID)
	s LocName	 = $g(ALocName)
	
	for I=1:1:$l(Type,"^")
	{
	s LocType=$p(Type,"^",I)
	s RowID = ""
	for {
		s RowID = $o(^CTLOC(0,"LocType",LocType,RowID))
		q:(RowID = "")
		
		s objCtLoc = $g(^CTLOC(+RowID))
		
		s Desc = $p(objCtLoc,"^",2)
		continue:(Desc '[ "门诊")
		continue:(Desc [ "医院")					//华西医院专用
		s ContactName = $p(objCtLoc,"^",43)			//一些医院用于存储科室或病区拼音码
		//New Added By HKY
		s enddate=$P(objCtLoc,"^",25)
        //判断科室是否过期
        if ((enddate="")||((enddate-$P($h,",",1) >=0)))
        {
            s isActive=1
        }
        else
        {
            s isActive=0
        }
        
        continue:(isActive=0)
		
		// 匹配科室或者病区名称，包括拼音码
		continue:(LocName '= "")&&( Desc '[ LocName)&&( $zcvt(ContactName,"U") '[ $zcvt(LocName,"U"))
		s:(Desc [ "-") Desc = $p(Desc,"-",2)

		// 匹配科室ID，如果Type为E，则只需要找到
		if (LocID '= "")
		{
			if (Type = "E")
			{
				continue:(LocID '= RowID)	
				
				s Data = $lb(RowID,Desc)
				s ^CacheTemp(repid,ind) = Data
				s ind = ind+1		
			}
			
		}
		else
		{
			s Data = $lb(RowID,Desc)
			s ^CacheTemp(repid,ind) = Data
			s ind = ind + 1		
		}	
	}
	}
	q $$$OK
}

ClassMethod GetOPLocationListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOPLocationListExecute ]
{
 	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{			
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{				
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetOPLocationListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOPLocationListExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid) 	
 	q $$$OK
}

/// Desc: 取内涵条目列表（供报表统计用）
/// Debug:d ##Class(%ResultSet).RunQuery("EPRservice.Quality.DataGather.Location","GetEntryList")
Query GetEntryList(AIsActive As %String = "") As %Query(ROWSPEC = "ID1,Name1,PoolDR") [ SqlProc ]
{
}

ClassMethod GetEntryListExecute(ByRef qHandle As %Binary, AIsActive As %String = "") As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	s EntryID=""
	for
	{
		s RuleID=$o(^DHCEPRM.QualityRuleI("IdxCode","N",""))
		s EntryID=$o(^DHCEPRM.QualityEntryI("IdxRuleDR"," "_RuleID,EntryID))
		q:(EntryID="")
		s EntryObj = ##class(EPRmeta.Quality.QualityEntry).%OpenId(EntryID)
		//continue:(EntryObj.IsActive'="Y")
		continue:(AIsActive'="")&&(AIsActive'=EntryObj.IsActive)
		s PoolObj = ##class(EPRmeta.Quality.QualityPool).%OpenId(EntryObj.PoolDR)
		s Title = PoolObj.Title
		s ^CacheTemp(repid,ind) = $lb(EntryID,Title,EntryObj.PoolDR)
		s ind = ind + 1	
	}	
	Quit $$$OK
}

ClassMethod GetEntryListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEntryListExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid) 	
	
	Quit $$$OK
}

ClassMethod GetEntryListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEntryListExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{			
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{				
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
