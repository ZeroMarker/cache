/// 名称:评估表关联文献表
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 阚延新
/// 编写日期:2021-03-20
Class web.CDSS.Access.AssConDoc Extends %RegisteredObject
{

/// Creator：阚延新	
/// CreatDate: 2021-03-20
/// Description：查询 评估表关联文献表 
/// Table:CT.WDT.CDSS.AssConDoc 评估表关联文献表
/// Input:id, code,desc
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.Access.AssConDoc","GetList","","812","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID,AssDR,NewDocDR")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	//s:code'="" code=$lg($g(^CT.WDT.CDSS.AssBaseD(code)),3)
	s:desc'="" desc=$lg($g(^CT.WDT.CDSS.DocuManageD(desc)),3)
	if (rowid'="") //根据rowid返回该条记录
	{
		s ID=rowid
		s AssDR= $lg($g(^CT.WDT.CDSS.AssBaseD($lg($g(^CT.WDT.CDSS.AssConDocD(ID)),2))),3)
		//s DocDR= $lg($g(^User.MKBDocManageD($lg($g(^CT.WDT.CDSS.AssConDocD(ID)),3))),3)
		s NewDocDR=$lg($g(^CT.WDT.CDSS.DocuManageD($lg($g(^CT.WDT.CDSS.AssConDocD(ID)),4))),3)
	}
	else
	{
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.AssConDocD(ID))
			q:ID=""
            s AssID=$lg($g(^CT.WDT.CDSS.AssConDocD(ID)),2)
            continue:((code'="")&&(AssID'=code))
            s AssDR= $lg($g(^CT.WDT.CDSS.AssBaseD($lg($g(^CT.WDT.CDSS.AssConDocD(ID)),2))),3)
            s DocID=$lg($g(^CT.WDT.CDSS.AssConDocD(ID)),3)
			//s:DocID'="" DocDR= $lg($g(^User.MKBDocManageD(DocID)),3)
			s NewDocDR=""
			s NewDocId=$lg($g(^CT.WDT.CDSS.AssConDocD(ID)),4)
			s:NewDocId'="" NewDocDR=$lg($g(^CT.WDT.CDSS.DocuManageD(NewDocId)),3)
		    i (NewDocDR[desc)
			{
				d OutputRow
			}	
		}
						
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ID,AssDR,NewDocDR)
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

/// Creator:阚延新
/// CreatDate:2021-03-20
/// Description:数据重复验证方法,js调用
/// Table:CT.WDT.CDSS.AssConDoc 评估表关联文献表
/// Input:id, 
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.Access.AssConDoc).FormValidate("10","111","31")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	
	s flag=0
	s idc=$o(^CT.WDT.CDSS.AssConDocI("NewAssDocIndex",code,desc,0))
	if (id="")
	{
	   if (idc'="")
	   {
		  s flag=1  //返回重复标志 
	   }
	}
	else	//如果不为空，修改时的重复判断
	{
		
	 	if ((idc'=id)&&(idc'=""))
	 	{
		 	
		 	s flag=1  //返回重复标志
	 	}
	} 
	q flag
}

/// Creator:阚延新
/// CreatDate: 2021-03-21
/// Description：评估表关联文献
/// Table:CT.WDT.CDSS.AssConDoc 
/// Input: eobj As web.CDSSEntity.Access.AssConDoc
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.CDSS.Access.AssConDoc).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.CDSSEntity.Access.AssConDoc) As %String
{
	s result=""
	if $IsObject(eobj)
	{	
		s flag=..FormValidate(eobj.ID,eobj.AssDR,eobj.NewDocDR)  //调用重复验证
		if (flag=1)	//校验重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.ID="")	//新增
		{	
	        s obj=##class(CT.WDT.CDSS.AssConDoc).%New()
		}else	//修改
		{
			s obj=##class(CT.WDT.CDSS.AssConDoc).%OpenId(eobj.ID)
			s bobj = ##class(web.CDSSEntity.Access.AssConDoc).%New()
			s bobj.ID = eobj.ID
			s bobj.AssDR = obj.AssDR   //评估表名称		
			s bobj.DocDR = obj.DocDR	//文献名称
			s bobj.NewDocDR= obj.NewDocDR.%Id()		
		}
		d:eobj.AssDR'="" obj.AssDRSetObjectId(eobj.AssDR)   //评估表名称		
		d:eobj.AssDR="" obj.AssDRSetObjectId("")
		//d:eobj.DocDR'="" obj.DocDRSetObjectId(eobj.DocDR)	//文献名称	
		//d:eobj.DocDR="" obj.DocDRSetObjectId("")
		s obj.DocDR=eobj.DocDR
		d:eobj.NewDocDR'="" obj.NewDocDRSetObjectId(eobj.NewDocDR)
		d:eobj.NewDocDR="" obj.NewDocDRSetObjectId("")
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.AssConDoc","CT.WDT.CDSS.AssConDoc","评估表关联文献表",id,eobj.AssDR_"-"_eobj.NewDocDR,"A",eobj)
			d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.AssConDoc","CT.WDT.CDSS.AssConDoc","评估表关联文献表",eobj.ID,eobj.AssDR_"-"_eobj.NewDocDR,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("评估表关联文献表","web.CDSS.Access.AssConDoc","SaveEntity",eobj)
    		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		}	
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator:阚延新
/// CreatDate: 2021-03-21
/// Description：修改时打开的数据
/// Table:CT.WDT.CDSS.AssConDoc 评估表关联文献表
/// Input：id
/// Return:Json格式的字符串{"PHLIActiveFlag":"Y","PHLICode":"PUBLIC","PHLIDesc":"公共","PHLIRowId":"9"}
/// Other: w ##class(web.CDSS.Access.AssConDoc).NewOpenData("2")
ClassMethod NewOpenData(Id As %String) As %String
{
    s str="" 
    s eobj=##class(web.CDSSEntity.Access.AssConDoc).%New()
    s eobj.ID=Id
    s eobj.AssDR=$lg($g(^CT.WDT.CDSS.AssConDocD(Id)),2)
    s eobj.DocDR=$lg($g(^CT.WDT.CDSS.AssConDocD(Id)),3)
    s eobj.NewDocDR=$lg($g(^CT.WDT.CDSS.AssConDocD(Id)),4)
    s str = eobj.JsonS()    
    d eobj.%Close()
    q str
}

/// Creator:阚延新
/// CreatDate: 2021-03-21
/// Description：根据ID删除
/// Table:CT.WDT.CDSS.AssConDoc 评估表关联文献表
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Others:w ##class(web.CDSS.Access.AssConDoc).DeleteData("4")
ClassMethod DeleteData(Id As %String) As %String
{
	s result=""
	Quit:Id="" "{success:'false',info:'删除失败,入参为空！'}"  
	s obj=##class(CT.WDT.CDSS.AssConDoc).%OpenId(Id)  
    s bobj = ##class(web.CDSSEntity.Access.AssConDoc).%New()
    s bobj.ID=Id
	s bobj.AssDR=obj.AssDR.%Id() 			 //评估表名称
	s bobj.DocDR=obj.DocDR
	s bobj.NewDocDR=obj.NewDocDR.%Id()
	d obj.%Close()
    k obj  
	TSTART
	s sc=##class(CT.WDT.CDSS.AssConDoc).%DeleteId(Id)
	if ($$$ISOK(sc))
	{
		TCOMMIT
		s result="{success:'true',info:'删除成功！'}"  
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.AssConDoc","CT.WDT.CDSS.AssConDoc","评估表关联文献表",Id,bobj.ID,"D",bobj)
        d bobj.%Close()
	}
	else
	{
		TROLLBACK
		s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("评估表关联文献表","web.CDSS.Access.AssConDoc","DeleteData")
        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	Quit result
}

/// Creator:Xuwenhu
/// CreatDate: 2022-03-29
/// Description：迁移数据，关联2.0文献表
/// Table:CT.WDT.CDSS.AssConDoc CT.WDT.CDSS.DocuManage
/// Input：
/// Return：success OR false
/// Others:w ##class(web.CDSS.Access.AssConDoc).CopyToDocu()
ClassMethod CopyToDocu()
{
	TS
	s DocId=0
	for
	{
		s DocId=$o(^CT.WDT.CDSS.AssConDocD(DocId))
		q:DocId=""
		
		s AssDR=$lg($g(^CT.WDT.CDSS.AssConDocD(DocId)),2)
		s DocDR=$lg($g(^CT.WDT.CDSS.AssConDocD(DocId)),3)
		s DocDesc=$lg($g(^User.MKBDocManageD(DocDR)),3)
		if DocDesc[".pdf"
		{
			s Desc=$e(DocDesc,1,$locate(DocDesc,".pdf")-1)
		}
		else
		{
			s Desc=DocDesc	
		}
		s NewDocId=$o(^CT.WDT.CDSS.DocuManageI("DescIndex",Desc,0))
		
		if NewDocId=""
		{
			w AssDR_"   ",DocId,Desc,!	
		}
		else
		{
			s obj=##class(CT.WDT.CDSS.AssConDoc).%OpenId(DocId)
			d obj.AssDRSetObjectId(AssDR)
			s obj.DocDR=DocDR
			d obj.NewDocDRSetObjectId(NewDocId)
			s sc=obj.%Save()
			d obj.%Close()	
		}
	}	
	q "success"
}

}
