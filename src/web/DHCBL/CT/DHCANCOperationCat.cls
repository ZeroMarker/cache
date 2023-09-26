Import SQLUser

/// 名称:手术和过程 手术分类
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - ybq
/// 编写日期: 2019-1-31
Class web.DHCBL.CT.DHCANCOperationCat Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:ybq
/// CreatDate:2019-1-31
/// Description:查询 手术分类
/// Table:User.DHCANCOperationCat
/// Input:rowid,code,desc,citydr
/// Return:ANCOCRowId,ANCOCCode,ANCOCDesc,ANCOCType
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCANCOperationCat","GetList","","","","")
Query GetList(rowid As %String, code As %String, desc As %String, type As %String) As %Query(ROWSPEC = "ANCOCRowId:%String,ANCOCCode:%String,ANCOCDesc:%String,ANCOCType:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, type As %String) As %Status
{
  s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
  s ind=1
  
  if (rowid'="")
  {
    s ANCOCRowId=rowid
    s ANCOCCode=$lg($g(^DHCANC("OperationCat",ANCOCRowId)),1)
    s ANCOCDesc=$lg($g(^DHCANC("OperationCat",ANCOCRowId)),2)
    s ANCOCType=$lg($g(^DHCANC("OperationCat",ANCOCRowId)),5)
    d OutputRow
  }
  else
  {
    s:code'="" code=$ZCONVERT(code,"U")
    s:desc'="" desc=$ZCONVERT(desc,"U")
    s ANCOCRowId=0
    for
    {
      	s ANCOCRowId=$o(^DHCANC("OperationCat",ANCOCRowId)) q:ANCOCRowId=""
      	s ANCOCCode=$lg($g(^DHCANC("OperationCat",ANCOCRowId)),1)
	    s ANCOCDesc=$lg($g(^DHCANC("OperationCat",ANCOCRowId)),2)
	    s ANCOCCode1=$ZCONVERT(ANCOCCode,"U")
	    s ANCOCDesc1=$ZCONVERT(ANCOCDesc,"U")
	    s ANCOCType=$lg($g(^DHCANC("OperationCat",ANCOCRowId)),5)
	    if (desc'="")
	    {
	    	;需要对描述或者别名进行检索      
	    	s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("DHC_ANC_OperationCat",ANCOCRowId,ANCOCDesc,desc)
	    }
	    else
	    {
	    	s AliasFlag= 1   
	    }  
	    if (ANCOCCode1[code) &(AliasFlag=1)&((ANCOCType=type)||(type=""))
	    {
	      d OutputRow
	    } 
        
    }
  }
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
OutputRow
    set Data=$lb(ANCOCRowId,ANCOCCode,ANCOCDesc,ANCOCType)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
  Set AtEnd=$LIST(qHandle,1)
  Set repid=$LIST(qHandle,2)
  Set ind=$LIST(qHandle,3)
  
  Set ind=$o(^CacheTemp(repid,ind))
  If ind=""
  {
    //if there are no more rows,finish fetching
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

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
  Set repid=$LIST(qHandle,2)
  Kill ^CacheTemp(repid)
  Quit $$$OK
}

/// Creator:ybq
/// CreatDate:2019-1-31
/// Description:为combobox查询取数据
/// Table:User.DHCANCOperationCat
/// Input:code,desc,citydr
/// Return:ANCOCRowId,ANCOCCode,ANCOCDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCANCOperationCat","GetDataForCmb1","","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ANCOCRowId:%String,ANCOCCode:%String,ANCOCDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
  s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
  s ind=1
  
  if (rowid'="")
  {
    s ANCOCRowId=rowid
    s ANCOCCode=$lg($g(^DHCANC("OperationCat",ANCOCRowId)),1)
    s ANCOCDesc=$lg($g(^DHCANC("OperationCat",ANCOCRowId)),2)
    d OutputRowCmb
  }
  else
  {
    s:code'="" code=$ZCONVERT(code,"U")
    s:desc'="" desc=$ZCONVERT(desc,"U")
    s ANCOCRowId=0
    for
    {
      	s ANCOCRowId=$o(^CT("ANCOC",ANCOCRowId)) q:ANCOCRowId=""
      	s ANCOCCode=$lg($g(^DHCANC("OperationCat",ANCOCRowId)),1)
	    s ANCOCDesc=$lg($g(^DHCANC("OperationCat",ANCOCRowId)),2)
	    s ANCOCCode1=$ZCONVERT(ANCOCCode,"U")
	    s ANCOCDesc1=$ZCONVERT(ANCOCDesc,"U")
	    if (desc'="")
	    {
	    	;需要对描述或者别名进行检索      
	    	s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("DHC_ANC_OperationCat",ANCOCRowId,ANCOCDesc,desc)
	    }
	    else
	    {
	    	s AliasFlag= 1   
	    }  
	    if (ANCOCCode1[code) &(AliasFlag=1)
	    {
	      d OutputRowCmb
	    } 
        
    }
  }
  
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
OutputRowCmb
    set Data=$lb(ANCOCRowId,ANCOCCode,ANCOCDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
  Set AtEnd=$LIST(qHandle,1)
  Set repid=$LIST(qHandle,2)
  Set ind=$LIST(qHandle,3)
  
  Set ind=$o(^CacheTemp(repid,ind))
  If ind=""
  {
    //if there are no more rows,finish fetching
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

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
  Set repid=$LIST(qHandle,2)
  Kill ^CacheTemp(repid)
  Quit $$$OK
}

/// Creator:ybq
/// CreatDate:2019-1-31
/// Description:数据重复验证方法,js调用
/// Table:User.DHCANCOperationCat
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.CT.DHCANCOperationCat).FormValidate("1","cs","cs")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	new (id,code,desc)
	s:code'="" code=$$ALPHAUP^SSUTIL4(code) //$ZCONVERT(code,"U")
	s:desc'="" code=$$ALPHAUP^SSUTIL4(desc) //$ZCONVERT(desc,"U")
	s flag=0
	s rowid=0
	for{
		s rowid=$o(^DHCANC("OperationCat",rowid))
		q:rowid=""
		s ANCOCCode=$lg($g(^DHCANC("OperationCat",rowid)),1)
		s ANCOCDesc=$lg($g(^DHCANC("OperationCat",rowid)),2)
		s ANCOCCode=$$ALPHAUP^SSUTIL4(ANCOCCode)
		s ANCOCDesc=$$ALPHAUP^SSUTIL4(ANCOCDesc)
		if ((ANCOCCode=code)||(ANCOCDesc=desc))&&(id'=rowid) s flag=1
	}
	q flag
}

/// Creator:ybq
/// CreatDate:2019-1-31
/// Description:双击修改时,从后台取数据
/// Table:User.DHCANCOperationCat
/// Input:id
/// Return:Json格式的字符串str={list:[ANCOCCode,ANCOCDesc,ANCOCType,ANCOCRowId]}
/// Other:d ##class(web.DHCBL.CT.DHCANCOperationCat).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
  n (id)
  s str=""
  s pobj = ##class(User.DHCANCOperationCat).%OpenId(id)
  s eobj = ##class(web.Entity.CT.DHCANCOperationCat).%New()
  s eobj.ANCOCRowId = id
  s eobj.ANCOCCode = pobj.ANCOCCode
  s eobj.ANCOCDesc = pobj.ANCOCDesc
  s eobj.ANCOCType = pobj.ANCOCType
  d pobj.%Close()
  k pobj
  s str = eobj.JsonS()
  s str = "{list:["_str_"]}"
  q str
}

/// Creator:ybq
/// CreatDate:2019-1-31
/// Description:增加/修改 手术分类
/// Table:User.DHCANCOperationCat
/// Input:web.Entity.CT.DHCANCOperationCat
/// Return:成功返回success:'true'和新增或修改的数据的ANCOCRowId;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.DHCANCOperationCat) As %String
{
    new (eobj,%session)
  s result=""
  if $IsObject(eobj)
  {
	  
	s flag=..FormValidate(eobj.ANCOCRowId,eobj.ANCOCCode,eobj.ANCOCDesc)  //调用重复验证
	if (flag=1)
	{
		s result = "{success:'false',errorinfo:'该代码或描述已经存在！'}"
	}
	else
	{
	    if (eobj.ANCOCRowId="")       
	    {
	      s obj=##class(User.DHCANCOperationCat).%New()
	    }
	    else                           
	    {
	      s obj=##class(User.DHCANCOperationCat).%OpenId(eobj.ANCOCRowId)
	      s bobj=##class(web.Entity.CT.DHCANCOperationCat).%New()
	      s bobj.ANCOCRowId = eobj.ANCOCRowId
	      s bobj.ANCOCCode = obj.ANCOCCode
	      s bobj.ANCOCDesc = obj.ANCOCDesc
	      s bobj.ANCOCType = obj.ANCOCType
  
	    }
	    s obj.ANCOCCode = eobj.ANCOCCode
	    s obj.ANCOCDesc = eobj.ANCOCDesc
	    s obj.ANCOCType = eobj.ANCOCType

	    Tstart
	    s sc=obj.%Save()
	    do obj.%Close()
	    if $$$ISOK(sc){
	      Tcommit
	      s id = obj.%Id()
	      s result = "{success:'true',id:'"_id_"'}"
	      d:eobj.ANCOCRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_ANC_OperationCat","User.DHCANCOperationCat","手术分类",id,eobj.ANCOCDesc,"A",eobj)
	      d:eobj.ANCOCRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_ANC_OperationCat","User.DHCANCOperationCat","手术分类",id,eobj.ANCOCDesc,"U",eobj,bobj)
	    }else{
	      Trollback
	      s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"    //返回错误信息
	      s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("手术分类","web.DHCBL.CT.DHCANCOperationCat","SaveEntity",eobj)
		  s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
	    }
	}
  }
  else
  {
    s result = "{success:'false',errorinfo:'对象不存在！'}"
  } 
  q result
}

/// Creator:ybq
/// CreatDate:2019-1-31
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.DHCBL.CT.DHCANCOperationCat).GetRefFlag("1")
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="0^未被引用可删除！"
  	s OPERRowId=0
  	for{
		s OPERRowId=$o(^ORC("OPER",OPERRowId))
		q:OPERRowId=""
		s OPERCategoryDr=$p($g(^ORC("OPER",OPERRowId,"DHC")),"^",16)
 		if (id=OPERCategoryDr) s return="1^在手术信息扩展表表里被引用,不能删除！" q
	}
  	q return
}

/// Creator:ybq
/// CreatDate:2019-1-31
/// Description:根据id删除 手术分类
/// Table:User.DHCANCOperationCat
/// Input:id(DHCANCOperationCat的ANCOCRowId) 
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.CT.DHCANCOperationCat).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	s RefFlag=..GetRefFlag(id)
	q:$p(RefFlag,"^",1)=1 "{success:'false',info:'"_$p(RefFlag,"^",2)_"'}" 
	s pobj = ##class(User.DHCANCOperationCat).%OpenId(id)
	s eobj = ##class(web.Entity.CT.DHCANCOperationCat).%New()
	s eobj.ANCOCRowId = id
	s eobj.ANCOCCode = pobj.ANCOCCode
	s eobj.ANCOCDesc = pobj.ANCOCDesc
	s eobj.ANCOCType =pobj.ANCOCType
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(User.DHCANCOperationCat).%DeleteId(id)
	if $$$ISOK(sc){
	Tcommit
	s result="{success:'true',info:'删除成功！'}"
	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_ANC_OperationCat","User.DHCANCOperationCat","手术分类",id,eobj.ANCOCDesc,"D",eobj)
	}
	else{
	Trollback
	s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
	s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("手术分类","web.DHCBL.CT.DHCANCOperationCat","DeleteData",eobj)
	s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
	}
	q result
}

}
