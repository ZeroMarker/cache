/// 名称:评估表关联评估结果表维护界面
/// 描述:包含增删改查功能
/// 编写者:基础数据平台 - Xuwenhu
/// 编写日期:2022-10-10
Class web.CDSS.Access.AssConResult Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：Xuwenhu 		
/// CreatDate: 2022-10-10
/// Description：查询数据 
/// Table:CT.WDT.CDSS.AssConResult
/// Input:rowid, assdesc(评估表名称),assres(评估结果)
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.Access.AssConResult","GetList","","","")
Query GetList(rowid As %String, assdesc As %String, assres As %String) As %Query(ROWSPEC = "RowId,AssDR,AssDesc,AssResDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, assdesc As %String, assres As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权
    //s AuStr=##class(web.DHCBL.Authorize.DHCPHLibaryAssessel).DHCGetDataByDefaultSession()
    //s AuFlag=0
    //if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s RowId=rowid
        s AssDR=$lg($g(^CT.WDT.CDSS.AssConResultD(ID)),2) 			//评估表ID
        s AssDesc=$lg($g(^CT.WDT.CDSS.AssBaseD(AssDR)),3) 		//评估表名称
	    s AssResDR=$lg($g(^CT.WDT.CDSS.AssConResultD(ID)),3) 		//评估结果ID
	    s AssResDesc=$lg($g(^CT.WDT.CDSS.AssessResultDictD(AssResDR)),3) 	//评估结果名称

        d OutputRow
    }
    else
    {
	    
        s RowId=0
        for {
            s RowId=$o(^CT.WDT.CDSS.AssConResultD(RowId))
			q:RowId=""
			s AssDR=$lg($g(^CT.WDT.CDSS.AssConResultD(RowId)),2) //评估表ID
			continue:((assdesc'="")&&(AssDR'=assdesc))
        	s AssDesc=$lg($g(^CT.WDT.CDSS.AssBaseD(AssDR)),3) //评估表名称
	    	s AssResDR=$lg($g(^CT.WDT.CDSS.AssConResultD(RowId)),3) //评估结果ID
	    	s AssResDesc=$lg($g(^CT.WDT.CDSS.AssessResultDictD(AssResDR)),3) //评估结果名称
	    	continue:((assres'="")&&(AssResDR'[assres))
	    	
			d OutputRow
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(RowId,AssDR,AssDesc,AssResDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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

/// Creator：Xuwenhu
/// CreatDate:2022-10-10
/// Description：数据重复验证方法
/// Table：User.DHCDSSAssBasicInfo
/// Input：id,desc(描述)
/// Return："1"(数据重复),"0"(数据不重复)
/// other:w ##class(web.CDSS.Access.AssConResult).FormValidate("","")
ClassMethod FormValidate(id As %String, AssDR As %String, AssResDR As %String) As %String
{
	if (AssDR="")||(AssResDR="") q ""
	s flag="",flagc=""
	s flagc=$d(^CT.WDT.CDSS.AssConResultI("AssResIndex",AssDR,AssResDR))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		s:AssDR'="" idc=$o(^CT.WDT.CDSS.AssConResultI("AssResIndex",AssDR,AssResDR,0))
		if ((idc'=id)&(flagc>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator:Xuwenhu
/// CreatDate:2022-10-10
/// Description：保存评估表关联评估结果表的内容
/// Table：CT.WDT.CDSS.AssConResult
/// Input：assid-评估表基础信息表，AssResidstr-评估结果表id
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: w ##class(web.CDSS.Access.AssConResult).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.Access.AssConResult) As %String
{
    s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    {   
        s flag=..FormValidate(eobj.RowId,eobj.AssDR,eobj.ResultDR)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        else
        {
            if (eobj.RowId="")  //如果RowId未赋值则增加
            {
                s obj=##class(CT.WDT.CDSS.AssConResult).%New()             
            }
            else                     //如果RowId已赋值则修改
            {
                s obj=##class(CT.WDT.CDSS.AssConResult).%OpenId(eobj.RowId) 				
                
                s bobj = ##class(web.CDSSEntity.Access.AssConResult).%New()
				s bobj.AssDR=obj.AssDR.%Id()					//评估表名称
				s bobj.ResultDR=obj.ResultDR.%Id()
            }
            Ts
            d obj.AssDRSetObjectId(eobj.AssDR)						//评估表名称
			d obj.ResultDRSetObjectId(eobj.ResultDR)
			
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"  //返回RowId
                //保存日志
				d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.AssConResult","CT.WDT.CDSS.AssConResult","评估表关联评估结果表",id,eobj.AssDR,"A",eobj)
				d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.AssConResult","CT.WDT.CDSS.AssConResult","评估表关联评估结果表",eobj.RowId,eobj.AssDR,"U",eobj,bobj)
            }
            else
            {
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("评估表关联评估结果表","web.CDSS.Access.AssConResult","SaveData",eobj)
       	    	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
            }
        }               
    }
    else
    {
        s result = "{success:'false',errorinfo:'对象不存在！'}"
    }
    q result
ERROE
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("评估表关联评估结果表","web.CDSS.Access.AssConResult","SaveData",eobj)
 	s ^ERRORLOGINFO(logid)=$ze 
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator:Xuwenhu
/// CreatDate:2021-04—01
/// Description：根据ID删除评估表关联评估结果表的内容
/// Table：CT.WDT.CDSS.AssConResult
/// Input：id-评估表关联评估结果表的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.CDSS.Access.AssConResult).DeleteAssRes("7")
ClassMethod DeleteData(id As %String) As %String
{
    s result="" 
    s obj=##class(CT.WDT.CDSS.AssConResult).%OpenId(id)  
    s bobj = ##class(web.CDSSEntity.Access.AssConResult).%New()
    s bobj.RowId=id
	s bobj.AssDR=obj.AssDR.%Id() 			 //评估表名称
	s bobj.ResultDR=obj.ResultDR.%Id()
	d obj.%Close()
    k obj  
    Tstart
    s sc=##class(CT.WDT.CDSS.AssConResult).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.AssConResult","CT.WDT.CDSS.AssConResult","评估表关联评估结果表",id,bobj.RowId,"D",bobj)
        d bobj.%Close() 
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("评估表基本信息表","web.CDSS.Access.AssConResult","DeleteData")
        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
     }
     q result
}

/// Creator：Xuwenhu
/// CreatDate: 2022-10-11
/// Description：数据打开方法
/// Table：CT.WDT.CDSS.AssConResult
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.CDSS.Access.AssConResult).OpenData("3")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	
	s obj=##class(CT.WDT.CDSS.AssConResult).%OpenId(id)  
    s bobj = ##class(web.CDSSEntity.Access.AssConResult).%New()
    s bobj.RowId=id
	s bobj.AssDR=obj.AssDR.%Id() 					//评估表名称
	s bobj.ResultDR=obj.ResultDR.%Id()
	d obj.%Close()		
	k obj	
	
	s str = bobj.JsonS()	
	q str
}

/// Creator：Xuwenhu
/// CreatDate: 2023-03-14
/// Description：根据评估表ID获取评估表关联结论名
/// Table：CT.WDT.CDSS.AssConResult
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.CDSS.Access.AssConResult).GetResultName("3")
ClassMethod GetResultName(id As %String) As %String
{
	s ResultID=0
	s ResultName=""
	for
	{
		s ResultID=$o(^CT.WDT.CDSS.AssConResultI("AssResIndex",id,ResultID))
		q:ResultID=""
		
		s ResultName=$lg($g(^CT.WDT.CDSS.AssessResultDictD(ResultID)),3)		//评估结论名
		
	}
	q ResultName
}

}
