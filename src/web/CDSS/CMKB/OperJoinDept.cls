/// Creator:赵文伟
/// CreatDate:2022-05-23
/// Description：手术关联科室
Class web.CDSS.CMKB.OperJoinDept Extends %RegisteredObject
{

/// Creator:赵文伟
/// CreatDate:2022-05-23
/// Description:获取手术关联科室数据
/// Table: CT.WDT.CDSS.OperJoinDept
/// Input: OperationDR
/// Return:返回手术关联科室
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.OperJoinDept","GetList","")
Query GetList(operationDR As %String) As %Query(ROWSPEC = "RowId,OperationDR,DiseaseDeptDR,DeptName,OperationGrade,OperationGradeDesc,OperationCategory")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, operationDR As %String) As %Status
{
	
 	s repid=$I(^CacheTemp)
 	s ind=1
 	if (operationDR'=""){
		s RowId=""
		for
		{
			s RowId = $o(^CT.WDT.CDSS.OperJoinDeptI("OperationIndex",operationDR,RowId))
		
			q:RowId=""
			s OperationDR=operationDR
			s DiseaseDeptDR = $lg($g(^CT.WDT.CDSS.OperJoinDeptD(RowId)),3) 		//科室DR
			s DeptName=""
			s:DiseaseDeptDR'="" DeptName=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(DiseaseDeptDR)),3)	//科室名称
			s OperationGrade= $lg($g(^CT.WDT.CDSS.OperJoinDeptD(RowId)),4) 		//手术分级DR
			s OperationGradeDesc=""
			s:OperationGrade'="" OperationGradeDesc=$lg($g(^CT.WDT.CDSS.CommonDictD(OperationGrade)),4) //通用名名称[手术分级]
			s OperationCategory= $lg($g(^CT.WDT.CDSS.OperJoinDeptD(RowId)),5) 	//手术分类
			
		  	d OutputRow
		} 
	}

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,OperationDR,DiseaseDeptDR,DeptName,OperationGrade,OperationGradeDesc,OperationCategory)
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

/// Creator:赵文伟
/// CreatDate:2022-05-23
/// Description:数据重复校验
/// Table: CT.WDT.CDSS.OperJoinDept
/// Input: RowId、OperationDR、DiseaseDeptDR
/// Return："1"(数据重复),"0"(数据不重复)
/// w ##class(web.CDSS.CMKB.OperJoinDept).FormValidate("","","")
ClassMethod FormValidate(id As %String, operationDR As %String, diseaseDeptDR As %String) As %String
{
	
	s flag="",flagz=""
	if (operationDR'="")&(diseaseDeptDR){	
		s flagz=$d(^CT.WDT.CDSS.OperJoinDeptI("OperatDeptIndex",operationDR,diseaseDeptDR))
		
		if (id="")	//如果为空，增加时的重复判断
		{
			if (flagz>0) s flag=1	//返回重复标志
			else  s flag=0 			//返回不重复标志
			
		}
		else 		//如果不为空，修改时的重复判断
		{
			s idd=""
			s idd=$o(^CT.WDT.CDSS.OperJoinDeptI("OperatDeptIndex",operationDR,diseaseDeptDR,0))
			
			if (((idd'="")&(idd'=id)&(flagz>0))) s flag=1	//返回重复标志
			else  s flag=0 			//返回不重复标志								
		}	
	}
		q flag
}

/// Creator:赵文伟
/// CreatDate:2022-05-23
/// Description:保存手术关联科室
/// Table: CT.WDT.CDSS.OperJoinDept
/// Input: OperationDR
/// others:w ##class(web.CDSS.CMKB.OperJoinDept).SaveData()
ClassMethod SaveData(RowId, OperationDR, DiseaseDeptDR, OperationGrade, OperationCategory)
{
	
	s result=""
	s flag=..FormValidate(RowId,OperationDR,DiseaseDeptDR)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在'}"
			q result
		}
		
		if (RowId="")	//如果RowId未赋值则增加
		{
			s obj=##class(CT.WDT.CDSS.OperJoinDept).%New()	
		}
		else  			//如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.OperJoinDept).%OpenId(RowId)
			s bobj = ##class(web.CDSSEntity.CMKB.OperJoinDept).%New()
			
			s bobj.OperationDR = obj.OperationDR  			//手术指向
			s bobj.DiseaseDeptDR = obj.DiseaseDeptDR		//科室指向
			s bobj.OperationGrade = obj.OperationGrade		//手术分级 
			s bobj.OperationCategory = obj.OperationCategory	//手术分类
			
		}
		d obj.OperationDRSetObjectId(OperationDR)	
		d obj.DiseaseDeptDRSetObjectId(DiseaseDeptDR)	
		d obj.OperationGradeSetObjectId(OperationGrade)	
		//s obj.OperationGrade = OperationGrade
		s obj.OperationCategory = OperationCategory
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}		
	q result
}

/// Creator:赵文伟
/// CreatDate:2022-05-23
/// Description:通过id获取字典表内容
/// Table: CT.WDT.CDSS.OperJoinDept
/// Input: id 
/// Return: 字典表内容
/// others:w ##class(web.CDSS.CMKB.OperJoinDept).OpenData("1")
ClassMethod OpenData(operationDR As %String)
{
	s str=""
	s RowId=""
	s eobj = ##class(web.CDSSEntity.CMKB.OperJoinDept).%New()
	s RowId = $o(^CT.WDT.CDSS.OperJoinDeptI("OperationIndex",operationDR,RowId))	
	s eobj.RowId = RowId
    s eobj.OperationDR = $lg($g(^CT.WDT.CDSS.OperJoinDeptD(RowId)),2)
    
    s eobj.DiseaseDeptDR = $lg($g(^CT.WDT.CDSS.OperJoinDeptD(RowId)),3)
    s DeptName=""
	s:eobj.DiseaseDeptDR'="" DeptName=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(eobj.DiseaseDeptDR)),3)
    s eobj.OperationGrade = $lg($g(^CT.WDT.CDSS.OperJoinDeptD(RowId)),4)
    s OperationGradeDesc=""
    s:eobj.OperationGrade'="" OperationGradeDesc=$lg($g(^CT.WDT.CDSS.CommonDictD(eobj.OperationGrade)),4)   //通用名名称
    s eobj.OperationCategory = $lg($g(^CT.WDT.CDSS.OperJoinDeptD(RowId)),5)
    
	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

/// Creator:赵文伟
/// CreatDate:2022-05-23
/// Description:删除数据——根据手术关联科室表id删除
/// Table: CT.WDT.CDSS.OperJoinDept
/// Input: id 字典表id
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.OperJoinDept).DeleteData("1")
ClassMethod DeleteData(id As %String)
{
	s result=""
	
		s obj=##class(CT.WDT.CDSS.OperJoinDept).%OpenId(id)
		s bobj = ##class(web.CDSSEntity.CMKB.OperJoinDept).%New()
	    s bobj.OperationDR = obj.OperationDR
		s bobj.DiseaseDeptDR = obj.DiseaseDeptDR
		s bobj.OperationGrade = obj.OperationGrade
		s bobj.OperationCategory = obj.OperationCategory
		Ts	
			
		s sc=##class(CT.WDT.CDSS.OperJoinDept).%DeleteId(id)
		if $$$ISOK(sc)
		{
			Tc
			s result = "{success:'true',info:'删除成功！'}"	
			//保存日志
			d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMPreJoinMed","CT.WDT.CDSS.OperJoinDept","手术关联科室字典表",id,bobj.OperationDR,"D",bobj)
			
			d bobj.%Close()
		}
		else
		{
			Tro
			s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			
	       	s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("手术关联科室字典表","web.CDSS.CMKB.OperJoinDept","DeleteData",bobj)
	       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
    
	q result
}

/// Creator:赵文伟
/// CreatDate:2022-05-23
/// Description:删除数据【根据operationDR删除,手术字典中同步删除时调用】
/// Table: CT.WDT.CDSS.OperJoinDept
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.OperJoinDept).DeleteLinkData("1")
ClassMethod DeleteLinkData(operationDR As %String)
{
	for
	{
		s result=""
		s id=""
		s:operationDR'="" id = $o(^CT.WDT.CDSS.OperJoinDeptI("OperationIndex",operationDR,id)) q:id=""
		s obj=##class(CT.WDT.CDSS.OperJoinDept).%OpenId(id)
		s bobj = ##class(web.CDSSEntity.CMKB.OperJoinDept).%New()
	    s bobj.OperationDR = obj.OperationDR
		s bobj.DiseaseDeptDR = obj.DiseaseDeptDR
		s bobj.OperationGrade = obj.OperationGrade
		s bobj.OperationCategory = obj.OperationCategory
		
		Ts		
		s sc=##class(CT.WDT.CDSS.OperJoinDept).%DeleteId(id)
		if $$$ISOK(sc)
		{
			Tc
			s result = "{success:'true',info:'删除成功！'}"	
			//保存日志
			d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMPreJoinMed","CT.WDT.CDSS.OperJoinDept","手术关联科室字典表",id,bobj.OperationDR,"D",bobj)
			
			d bobj.%Close()
		}
		else
		{
			Tro
			s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			
	       	s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("手术关联科室字典表","web.CDSS.CMKB.OperJoinDept","DeleteData",bobj)
	       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	q result
}

}
