Import SQLUser

/// 名称: ICD诊断分类	
/// 描述: ICD诊断分类，包含增删改查功能
/// 编写者：基础数据平台组 、ybq
/// 创建日期: 2019-4-2
/// 最后修改日期：2019-4-2
Class web.DHCBL.CT.MRCICDDxType Extends %RegisteredObject
{

/// Creator：ybq
/// CreatDate: 2019-04-20
/// Description：查询ICD诊断分类的内容
/// Table：User.MRCICDDxType
/// Input：rowid,code,desc(用于combox查询)
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ICDTYPERowId,ICDTYPECode,ICDTYPEDesc,ICDTYPEDateFrom,ICDTYPEDateTo")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	
	
	s:code'="" code=$ZCONVERT(code,"U")
	s:desc'="" desc=$ZCONVERT(desc,"U")
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s ICDTYPERowId=rowid
		s ICDTYPECode=$p($g(^MRC("ICDTYPE",ICDTYPERowId)),"^",1)
		s ICDTYPEDesc=$p($g(^MRC("ICDTYPE",ICDTYPERowId)),"^",2)
		s ICDTYPEDateFrom=$p($g(^MRC("ICDTYPE",ICDTYPERowId)),"^",3)
		s ICDTYPEDateTo=$p($g(^MRC("ICDTYPE",ICDTYPERowId)),"^",4)
		s:ICDTYPEDateFrom'="" ICDTYPEDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ICDTYPEDateFrom)
    	s:ICDTYPEDateTo'="" ICDTYPEDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ICDTYPEDateTo)
		d OutputRow
	}
	else
	{
		//获取授权
		s AuStr=##class(web.DHCBL.Authorize.MRCICDDxType).DHCGetDataByDefaultSession()
		s AuFlag=0
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
		s ICDTYPERowId=0
		for  
		{	
			s ICDTYPERowId=$o(^MRC("ICDTYPE",ICDTYPERowId)) q:ICDTYPERowId=""
			s strRowId="{ID:"_ICDTYPERowId_"}"
			if '((AuStr[strRowId)||(AuFlag=1)) continue
			s ICDTYPECode=$p($g(^MRC("ICDTYPE",ICDTYPERowId)),"^",1)
			s ICDTYPEDesc=$p($g(^MRC("ICDTYPE",ICDTYPERowId)),"^",2)
			s ICDTYPEDateFrom=$p($g(^MRC("ICDTYPE",ICDTYPERowId)),"^",3)
			s ICDTYPEDateTo=$p($g(^MRC("ICDTYPE",ICDTYPERowId)),"^",4)
			s:ICDTYPEDateFrom'="" ICDTYPEDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ICDTYPEDateFrom)
    		s:ICDTYPEDateTo'="" ICDTYPEDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ICDTYPEDateTo)
			
			if (desc'="")
	       {
		        ;需要对描述或者别名进行检索      
		        s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("MRC_ICDDxType",ICDTYPERowId,ICDTYPEDesc,desc)
	       }
		   	else
	       {
	         	s AliasFlag= 1   
	       } 
			
			i ($ZCONVERT(ICDTYPECode,"U")[code)&(AliasFlag=1) 
			{
				d OutputRow
			}
			
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ICDTYPERowId,ICDTYPECode,ICDTYPEDesc,ICDTYPEDateFrom,ICDTYPEDateTo)
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

/// Function:进行数据检索，为combo查询提供接口
/// CreateDate:2019-04-20
/// Creator:基础数据平台公共产品组  ybq 
/// Table:User.MRCICDDxType
/// Input: rowid, code 
/// Output:  RNAV_RowId,RNAV_Code,RNAV_Desc
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.MRCICDDxType", "GetDataForCmb1","")
/// 获取ICD诊断分类信息
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ICDTYPERowId,ICDTYPECode,ICDTYPEDesc")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s:code'="" code=$ZCONVERT(code,"U")
	s:desc'="" desc=$ZCONVERT(desc,"U")
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s ICDTYPERowId=rowid
		s ICDTYPECode=$p($g(^MRC("ICDTYPE",ICDTYPERowId)),"^",1)
		s ICDTYPEDesc=$p($g(^MRC("ICDTYPE",ICDTYPERowId)),"^",2)
		d OutputRowCmb1
	}
	else
	{
		//获取授权
		s AuStr=##class(web.DHCBL.Authorize.MRCICDDxType).DHCGetDataByDefaultSession()
		s AuFlag=0
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
		s ICDTYPERowId=0
		for  
		{	
			s ICDTYPERowId=$o(^MRC("ICDTYPE",ICDTYPERowId)) q:ICDTYPERowId=""
			s strRowId="{ID:"_ICDTYPERowId_"}"
			if '((AuStr[strRowId)||(AuFlag=1)) continue
			s ICDTYPECode=$p($g(^MRC("ICDTYPE",ICDTYPERowId)),"^",1)
			s ICDTYPEDesc=$p($g(^MRC("ICDTYPE",ICDTYPERowId)),"^",2)
			s ICDTYPEDateFrom=$p($g(^MRC("ICDTYPE",ICDTYPERowId)),"^",3)
			continue:(ICDTYPEDateFrom'="")&&(ICDTYPEDateFrom>+$h)
			s ICDTYPEDateTo=$p($g(^MRC("ICDTYPE",ICDTYPERowId)),"^",4)
			continue:(ICDTYPEDateTo'="")&&(ICDTYPEDateTo<+$h)
			
			if (desc'="")
	       {
		        ;需要对描述或者别名进行检索      
		        s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("MRC_ICDDxType",ICDTYPERowId,ICDTYPEDesc,desc)
	       }
		   	else
	       {
	         	s AliasFlag= 1   
	       } 
			/*(($$ALPHAUP^SSUTIL4(ICDTYPEDesc)[desc)||(ALIASText1[desc)||(PINYIN[desc))*/
				
			i ($$ALPHAUP^SSUTIL4(ICDTYPECode)[code)&(AliasFlag=1)
			{
				d OutputRowCmb1
			}
			
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb1
    set Data=$lb(ICDTYPERowId,ICDTYPECode,ICDTYPEDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
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

/// Creator:ybq
/// CreatDate:2019-04-20
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class("web.DHCBL.CT.MRCICDDxType").GetRefFlag(50)
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	if $d(^MRC("ID",0,"TypeDR",id)) 
	{
		s myInfo=myInfo_"<ICD诊断代码>"
	}
 	
 	i myInfo="" s return="0^未被引用可删除!"
 	else  s return="1^在"_myInfo_"表里被引用,不能删除!"
	q return
}

/// Creator：ybq
/// CreatDate: 2019-04-20
/// Description：根据ID删除ICD诊断分类
/// Table：User.MRCICDDxType
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	s result = ""
	
	s re=##class(web.DHCBL.CT.MRCICDDxType).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=1){
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	else
	{
		Ts
		s pobj = ##class(User.MRCICDDxType).%OpenId(id)
		s eobj = ##class(web.Entity.CT.MRCICDDxType).%New()
		s eobj.ICDTYPECode = id
		s eobj.ICDTYPEDesc = pobj.ICDTYPEDesc
		s eobj.ICDTYPEDateFrom= pobj.ICDTYPEDateFrom
	    s eobj.ICDTYPEDateTo= pobj.ICDTYPEDateTo
		s sc=##class(User.MRCICDDxType).%DeleteId(id)
		if $$$ISOK(sc)
		{
			tc
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MRC_ICDDxType","User.MRCICDDxType","ICD诊断分类",id,eobj.ICDTYPEDesc,"D",eobj)
			s result = "{success:'true',info:'删除成功！'}"
		}
		else
		{
			tro
			s result = "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("ICD诊断分类","web.DHCBL.CT.MRCICDDxType","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
		}
	}
	
	q result
}

/// Function:双击时显示弹出窗口的信息
/// CreateDate:2019-04-20
/// Creator:基础数据平台公共产品组 ybq
/// Input:输入sid
/// Table:User.MRCICDDxType
/// Other:w ##class(web.DHCBL.CT.MRCICDDxType).OpenData(52)
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	s pobj = ##class(User.MRCICDDxType).%OpenId(id)
	s eobj = ##class(web.Entity.CT.MRCICDDxType).%New()
	s eobj.ICDTYPERowId=id
	s eobj.ICDTYPECode = pobj.ICDTYPECode
	s eobj.ICDTYPEDesc = pobj.ICDTYPEDesc
    s:pobj.ICDTYPEDateFrom'="" eobj.ICDTYPEDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.ICDTYPEDateFrom)
    s:pobj.ICDTYPEDateTo'="" eobj.ICDTYPEDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.ICDTYPEDateTo)
    d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 ybq 
/// CreateDate:2019-04-20
/// Table:MRC_ICDDxType    
/// w ##class(web.DHCBL.CT.MRCICDDxType).FormValidate("50","BJDTYY","北京地坛ICD诊断分类")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s flag=0
	if ($$ALPHAUP^SSUTIL4(code)'="")
	{
		s rowid=0
		for
		{
			s rowid=$o(^MRC("ICDTYPE",0,"Code",$$ALPHAUP^SSUTIL4(code),rowid)) q:rowid=""
			s ICDTYPECode=$p($g(^MRC("ICDTYPE",rowid)),"^",1)
			if (ICDTYPECode=code)&&(id'=rowid)
			{
				s flag=1
				
			}
		}
	}
	if ($$ALPHAUP^SSUTIL4(desc)'="")
	{
		s rowid=0
		for
		{
			s rowid=$o(^MRC("ICDTYPE",0,"Desc",$$ALPHAUP^SSUTIL4(desc),rowid)) q:rowid=""
			s ICDTYPEDesc=$p($g(^MRC("ICDTYPE",rowid)),"^",2)
			if (ICDTYPEDesc=code)&&(id'=rowid)
			{
				s flag=1
				
			}
		}
	}
	q flag
}

/// Creator：ybq
/// CreatDate: 2019-04-20
/// Description：保存ICD诊断分类信息
/// Table：User.MRCICDDxType
/// Input：Entity
ClassMethod SaveEntity(eobj As web.Entity.CT.MRCICDDxType) As %String
{
    s result=""
	
	s flag=..FormValidate(eobj.ICDTYPERowId,eobj.ICDTYPECode,eobj.ICDTYPEDesc)  //调用重复验证
	if (flag=1)
	{
		s result = "{success:'false',errorinfo:'该记录已经存在！'}"
	}
	else
	{
		if $IsObject(eobj)
		{	
			s:eobj.ICDTYPEDateFrom="" eobj.ICDTYPEDateFrom=+$h
		  	s:eobj.ICDTYPEDateFrom'="" eobj.ICDTYPEDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ICDTYPEDateFrom)  //转换日期
  			s:eobj.ICDTYPEDateTo'="" eobj.ICDTYPEDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ICDTYPEDateTo)      //转换日期
			if ((eobj.ICDTYPERowId)="")                             //如果RowId未赋值则增加
			{	
		        s obj=##class(User.MRCICDDxType).%New()
			}
			else                                                  //如果RowId已赋值则修改
			{
				s obj=##class(User.MRCICDDxType).%OpenId(eobj.ICDTYPERowId)
				s bobj=##class(web.Entity.CT.MRCICDDxType).%New()
				s bobj.ICDTYPERowId = eobj.ICDTYPERowId
				s bobj.ICDTYPECode = obj.ICDTYPECode                      // 代码
				s bobj.ICDTYPEDesc = obj.ICDTYPEDesc                      // 描述
				s bobj.ICDTYPEDateFrom = obj.ICDTYPEDateFrom            
				s bobj.ICDTYPEDateTo = obj.ICDTYPEDateTo                      
			
			}	
			s obj.ICDTYPECode = eobj.ICDTYPECode                      // 代码
			s obj.ICDTYPEDesc = eobj.ICDTYPEDesc                      // 描述
			s obj.ICDTYPEDateFrom = eobj.ICDTYPEDateFrom  // 开始日期
			s obj.ICDTYPEDateTo = eobj.ICDTYPEDateTo      // 结束日期     
				
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc){
				Tc
				s id = obj.%Id()
				d:eobj.ICDTYPERowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MRC_ICDDxType","User.MRCICDDxType","ICD诊断分类",eobj.ICDTYPERowId,eobj.ICDTYPEDesc,"U",eobj,bobj)
				d:eobj.ICDTYPERowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MRC_ICDDxType","User.MRCICDDxType","ICD诊断分类",id,eobj.ICDTYPEDesc,"A",eobj)
				s result = "{success:'true',id:'"_id_"'}"         //返回RowId
			}else{
				Trollback
				s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"    //返回错误信息
				s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("ICD诊断分类","web.DHCBL.CT.MRCICDDxType","SaveEntity",eobj)
				s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")  
			}
   		
		}
		else
		{
			s result = "{success:'false',errorinfo:'对象不存在！'}"
		}
	}	
	q result
}

}
