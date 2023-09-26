Class EPRservice.DAL.Query.DAQueryItemInfo Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	根据检索项目分类节点RowID获取子项目集合;
/// Input:	ACategoryID为父节点RowID;
/// 		AIsActive指是否有效,如果为空,则不判断有效性;					
/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.DAL.Query.DAQueryItemInfo","GetQueryItemsByCatID",1,"Y")
Query GetQueryItemsByCatID(ACategoryID As %String, AIsActive As %String = "") As %Query(ROWSPEC = "ID,Code,Name,Title,Sequence,IsActive,TypeCode,Remark,StdDic,Rules")
{
}

ClassMethod GetQueryItemsByCatIDExecute(ByRef qHandle As %Binary, ACategoryID As %String, AIsActive As %String = "") As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:($g(ACategoryID) = "") $$$OK
	
	s UniqueKey = $i(^CacheTempDHCEPR)
	
	k ^CacheTempDHCEPR(UniqueKey)
	
	d ..RecursiveQueryItems(UniqueKey,ACategoryID,AIsActive)
	
	s RowID = ""
	for {
		s RowID = $o(^CacheTempDHCEPR(UniqueKey,RowID))
		q:(RowID = "")
		
		s tmpQueryItem = $g(^CacheTempDHCEPR(UniqueKey,RowID))
		s Code = $list(tmpQueryItem,1)
		s Name = $list(tmpQueryItem,2)
		s Title = $list(tmpQueryItem,3)
		s Sequence = $list(tmpQueryItem,4)
		s IsActive = $list(tmpQueryItem,5)
		s TypeCode = $list(tmpQueryItem,6)
		s Remark = $list(tmpQueryItem,7)
		s:(Remark=$c(0)) Remark=""
		s StdDic = $list(tmpQueryItem,8)
		s rules = $list(tmpQueryItem,9)
		
		s Data = $lb(RowID,Code,Name,Title,Sequence,IsActive,TypeCode,Remark,StdDic,rules)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1
	}
	
	k ^CacheTempDHCEPR(UniqueKey)
	
	q $$$OK
}

ClassMethod GetQueryItemsByCatIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetQueryItemsByCatIDExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") {				
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} else {				
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetQueryItemsByCatIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetQueryItemsByCatIDExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Desc:	获取父节点下子节点集合,并保存在一个临时Global中
/// Input:	AUniqueKey为^CacheTempDHCEPR的下一个唯一节点标识;
/// 		ACategoryID为检索项目分类RowID;
/// 		AIsActive指是否有效,如果为空,则不判断有效性;
/// Output:	返回值为临时Global,格式为^CacheTempDHCEPR(UniqueKey,ID)=$lb(Code,Name,Title,Sequence,IsActive,Remark,StdDic)
/// Debug:	d ##Class(EPRservice.DAL.Query.DACategoryInfo).RecursiveQueryItems(111,0,"Y")
ClassMethod RecursiveQueryItems(AUniqueKey As %String, ACategoryID As %String, AIsActive As %String = "")
{
	s RowID = ""
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	for {
		s RowID = $o(^DHCEPRM.QueryItemI("IdxCategoryID",ACategoryID,RowID))
		q:(RowID = "")
		
		s objQueryItem = ##class(EPRmeta.Query.QueryItem).%OpenId(RowID)
		s IsActive = objQueryItem.IsActive
		continue:($g(AIsActive) '= "")&&(IsActive '= AIsActive)
		
		s Code = objQueryItem.Code
		s Name = objQueryItem.Name
		s Title = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EPRmeta.Query.QueryItem","Title",objQueryItem.Title,langid)
		s Sequence = objQueryItem.Sequence
		s TypeID = objQueryItem.QueryItemTypeID
		s objQueryItemType = ##class(EPRmeta.Query.QueryItemType).%OpenId(TypeID)
		s TypeCode=objQueryItemType.Code
		s Remark = objQueryItem.Remark
		s StdDic = objQueryItem.StdDic
		s rules = objQueryItem.Rules
		
		s ^CacheTempDHCEPR(AUniqueKey,RowID) = $lb(Code,Name,Title,Sequence,IsActive,TypeCode,Remark,StdDic,rules)	
	}
}

}
