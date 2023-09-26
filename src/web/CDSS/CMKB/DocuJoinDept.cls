/// Creator:高姗姗
/// CreatDate:2020-12-23
/// Description：文献关联科室
Class web.CDSS.CMKB.DocuJoinDept Extends %RegisteredObject
{

/// Creator:高姗姗
/// CreatDate:2020-12-23
/// Description:获得文献关联科室
/// Table: CT.WDT.CDSS.DocuJoinDept
/// Input: DocuDR 
/// Return:返回文献关联科室
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DocuJoinDept","GetList","")
Query GetList(DocuDR) As %Query(ROWSPEC = "RowId,DeptDR,DeptName")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, DocuDR) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	if (DocuDR'=""){
		s RowId=""
		for
		{
			s RowId = $o(^CT.WDT.CDSS.DocuJoinDeptI("DocuIndex",DocuDR,RowId))
			q:RowId=""
			s DeptDR = $lg($g(^CT.WDT.CDSS.DocuJoinDeptD(RowId)),3) //科室指向
			s DeptName=""
			s:DeptDR'="" DeptName=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(DeptDR)),3)
		  	d OutputRow
		} 
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,DeptDR,DeptName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:高姗姗
/// CreatDate:2020-12-25
/// Description:保存文献关联科室
/// Table: CT.WDT.CDSS.DocuJoinDept
/// Input: DocuDR, DeptStr
/// others:w ##class(web.CDSS.CMKB.DocuJoinDept).SaveData(1,"^3,^5")
ClassMethod SaveData(DocuDR, DeptStr)
{
	q:DocuDR="" ""
	Ts
	s result=""
	s len=$Length(DeptStr,",")
	for i=1:1:len{
		s Dept=$p(DeptStr,",",i)
		s RowId=$p(Dept,"^",1)
		s DeptDR=$p(Dept,"^",2)
		continue:(DeptDR="")
		if (RowId=""){ //文献关联科室新增
			s objDept=##class(CT.WDT.CDSS.DocuJoinDept).%New()
			d objDept.DocuDRSetObjectId(DocuDR)
			d:DeptDR'="" objDept.DeptDRSetObjectId(DeptDR)
			d:DeptDR="" objDept.DeptDRSetObjectId("")
			s scAdd=objDept.%Save() 
			d objDept.%Close()
			If $$$ISOK(scAdd) //新增数据存入数组
			{
				s arrExist(DocuDR,objDept.%Id())=""
			}else{
				s result="false"
				Trollback
			}
			
		}else{ //前台原有数据存入数组
			s arrExist(DocuDR,RowId)=""
		}	
	}
	
	s id=""
	for{
		s id=$o(^CT.WDT.CDSS.DocuJoinDeptI("DocuIndex",DocuDR,id)) q:id=""
		continue:$d(arrExist(DocuDR,id))	 //过滤现有数据
		//关联科室删除
		s scDel=##class(CT.WDT.CDSS.DocuJoinDept).%DeleteId(id)
		If $$$ISERR(scDel)
		{	
			s result="false"
			Trollback
		}
	}
	if (result="false"){
		s result = "{success:'false'}"
	}else{
		Tc
		s result = "{success:'true'}"
	}
	q result
}

}
