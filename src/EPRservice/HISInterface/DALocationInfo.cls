Class EPRservice.HISInterface.DALocationInfo Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	获取医院科室或病区列表;
/// 		1)如果AType为"E"代表执行科室,则加载所有执行科室;如果此时LocID不为空,则加载该科室;如果ALocName不为空,则加载包含ALocName的科室;
/// 		2)如果AType为"W"代表科室病区,则加载所有科室病区;如果此时LocID不为空,则加载该科室下的病区;如果ALocName不为空,则加载包含ALocName的病区;
/// Input:	AType为位置类型(E:科室; W:病区);
/// 		ALocID为科室RowID,当需要获取某科室下病区列表时候用;
/// 		ALocName为科室或病区名称,模糊匹配时用;
/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.HISInterface.DALocationInfo","GetLocationList","E","","")
Query GetLocationList(AType As %String = "E", ALocID As %String = "", ALocName As %String = "", AHospID As %String = "") As %Query(ROWSPEC = "ID,Name")
{
}

ClassMethod GetLocationListExecute(ByRef qHandle As %Binary, AType As %String = "E", ALocID As %String = "", ALocName As %String = "", AHospID As %String = "") As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:($d(AType) = 0)||(AType = "") $$$OK
	
	s Type		 = $g(AType)
	s LocID		 = $g(ALocID)
	s LocName	 = $g(ALocName)
		
	s RowID = ""
	for {
		s RowID = $o(^CTLOC(0,"LocType",Type,RowID))
		q:(RowID = "")
		
		s locHospitalId = $p($g(^CTLOC(RowID)),"^",22)
		continue:((AHospID '= "")&&(AHospID '= locHospitalId))
		
		s objCtLoc = $g(^CTLOC(+RowID))
		
		s Desc = $p(objCtLoc,"^",2)
		//应用场景增加门诊科室，去掉科室过滤。
		//continue:(Desc [ "门诊")
		continue:(Desc [ "医院")					//华西医院专用
		s ContactName = $p(objCtLoc,"^",43)			//一些医院用于存储科室或病区拼音码
		
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

}
