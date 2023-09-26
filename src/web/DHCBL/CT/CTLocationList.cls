Import SQLUSER

/// CreateDate:2013-05-31
/// Creator:基础数据平台 ，孙凤超
/// Function:  科室列表 维护
Class web.DHCBL.CT.CTLocationList Extends %RegisteredObject [ ProcedureBlock ]
{

Parameter SQLTableName = "CT_LocationList";

/// Function:进行数据检索，查询科室列表维护
/// CreateDate:2013-05-31
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables:  CT_LocationList
/// Input: rowid, code, desc, 
/// Output:  LL_RowId LL_Code LL_Desc 
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTLocationList","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "LLRowId:%String,LLCode:%String,LLDesc:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s AuStr=##class(web.DHCBL.Authorize.CTLocationList).DHCGetDataByDefaultSession()
 s AuFlag=0
 ;未授权情况下，默认显示全部数据
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1
 if (rowid'="")  
 {
   s LLRowId=rowid
   s LLCode=$tr($p($g(^CT("LL",LLRowId)),"^",1),$c(13,10))
   s LLDesc=$tr($p($g(^CT("LL",LLRowId)),"^",2),$c(13,10))
   s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
   s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_LocationList",LLRowId)
   s BDPInternalCode =$p($g(resultStr),"^",1)       
   s BDPInternalDesc = $p($g(resultStr),"^",2)  
   s BDPHospNationalCode=$p($g(resultStr),"^",3)         
   s BDPHospNationalDesc = $p($g(resultStr),"^",4)
   d OutputRow
 }
 else
 {
   s:code'="" code=$ZCVT(code,"U") 
   s:desc'="" desc=$ZCVT(desc,"U")  
   s LLRowId=0
   for
   {
     s LLRowId=$o(^CT("LL",LLRowId)) q:LLRowId=""  
     s strLLRowId="{ID:"_LLRowId_"}"      
     if (AuStr[strLLRowId)||(AuFlag=1)
     {
	  s flag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag(..#SQLTableName,LLRowId)
      continue:flag="N"   
      s LLCode=$p($g(^CT("LL",LLRowId)),"^",1)
      s LLDesc=$p($g(^CT("LL",LLRowId)),"^",2) 
      s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
      s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_LocationList",LLRowId)
      s BDPInternalCode =$p($g(resultStr),"^",1)       
      s BDPInternalDesc = $p($g(resultStr),"^",2)  
      s BDPHospNationalCode=$p($g(resultStr),"^",3)         
      s BDPHospNationalDesc = $p($g(resultStr),"^",4)
      if (desc'="")
      {
        ;需要对描述或者别名进行检索      
        s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_LocationList",LLRowId,LLDesc,desc)
      }
      else
      {
        s AliasFlag= 1   
      }   
      if ($ZCVT(LLCode,"U")[code)&(AliasFlag=1) 
      {
        d OutputRow
      }
     }
   }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(LLRowId,LLCode,LLDesc,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Function:进行数据检索，为comb提供查询科室列表的接口
/// CreateDate:2013-05-31
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables: CT_LocationList
/// Input: code ,desc
/// Output: LL_RowId ,LL_Code, LL_Desc 
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTLocationList","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "LLRowId:%String, LLCode:%String,LLDesc:%String ")
{
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
  If ind="" {    // if there are no more rows, finish fetching
   Set AtEnd=1
   Set Row=""
  }
  Else      {    // fetch row
   Set Row=^CacheTemp(repid,ind)
  }
  s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
  Set repid=$I(^CacheTemp)
  s ind=1 
  s AuStr=##class(web.DHCBL.Authorize.CTLocationList).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  if (rowid'="")  
  {
   s LLRowId=rowid
   s LLCode=$tr($p($g(^CT("LL",LLRowId)),"^",1),$c(13,10))
   s LLDesc=$tr($p($g(^CT("LL",LLRowId)),"^",2),$c(13,10))
   d OutputRowCmb
  }
  else
  {
   s:code'="" code=$ZCVT(code,"U") 
   s:desc'="" desc=$ZCVT(desc,"U")  
   s LLRowId=0
   for
   {
     s LLRowId=$o(^CT("LL",LLRowId)) q:LLRowId=""      
     s strLLRowId="{ID:"_LLRowId_"}"
     if (AuStr[strLLRowId)||(AuFlag=1) ;用来筛选授权数据
     {
	  s flag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag(..#SQLTableName,LLRowId)
      continue:flag="N" 
      s LLCode=$tr($p($g(^CT("LL",LLRowId)),"^",1),$c(13,10))
      s LLDesc=$tr($p($g(^CT("LL",LLRowId)),"^",2),$c(13,10))
      if (desc'="")
      {
        ;需要对描述或者别名进行检索      
        s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_LocationList",LLRowId,LLDesc,desc)
      }
      else
      {
        s AliasFlag= 1   
      }   
      if ($ZCVT(LLCode,"U")[code)&(AliasFlag=1)
      {
        d OutputRowCmb
      }
    }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(LLRowId,LLCode,LLDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function:双击时显示科室列表
/// CreateDate:2013-05-31
/// Creator:基础数据平台公共产品组 孙凤超
/// Input:输入id
/// Tables: CT_LocationList
/// Others:w ##class(web.DHCBL.CT.CTLocationList).OpenData("3")
ClassMethod OpenData(id As %String) As %String
{
 s str=""
 s pobj = ##class(User.CTLocationList).%OpenId(id)
 s eobj = ##class(web.Entity.CT.CTLocationList).%New()
 s eobj.LLRowId=id 
 s eobj.LLCode =$tr(pobj.LLCode,$c(13,10))
 s eobj.LLDesc =$tr(pobj.LLDesc,$c(13,10))
 
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Function:实现删除操作
/// Creator:孙凤超
/// CreateDate: 2013-05-31
/// Desc:通过rowid号来删除科室列表
/// Output:success:'true',info:'删除成功！ 失败时输出删除成功！
/// Tables:  CT_LocationList
/// Others:d ##class(web.DHCBL.CT.CTLocationList).DeleteData("")
ClassMethod DeleteData(id As %String) As %String
{
    s result="",flag=""
    Tstart
    s pobj = ##class(User.CTLocationList).%OpenId(id)
    s eobj = ##class(web.Entity.CT.CTLocationList).%New()
    s eobj.LLRowId=id
    s eobj.LLCode = pobj.LLCode
    s eobj.LLDesc = pobj.LLDesc
    
    s sc=##class(User.CTLocationList).%DeleteId(id)
    IF $$$ISOK(sc)
   {
     Tc
     s result="{success:'true',info:'删除成功！'}"
     d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_LocationList","User.CTLocationList","科室列表",id,eobj.LLDesc,"D",eobj)
     d eobj.%Close()
   }
   else
  {
    Trollback
    s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("科室列表","web.DHCBL.CT.CTLocalityType","DeleteData",eobj)
    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
  }  
  q result
}

/// Creator：基础数据平台组 孙凤超
/// CreatDate: 2013-5-31
/// Description：数据重复校验： 
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s flag=0
    if $$ALPHAUP^SSUTIL4(code)'=""
    {
        s idc=0
        for
        {
            s idc=$o(^CT("LL",0,"Code",$$ALPHAUP^SSUTIL4(code),idc)) q:idc=""
            if (idc'=id)
            {
                s flag=1
            }
        }
    }
    
    if $$ALPHAUP^SSUTIL4(desc)'=""
    {
        s idd=0
        for
        {
    
            s idd=$o(^CT("LL",0,"Desc",$$ALPHAUP^SSUTIL4(desc),idd)) q:idd=""
            if (idd'=id)
            {
                s flag=1
            }
        }
    }
    q flag
}

/// Function:实现科室列表的修改增加操作
/// Creator:孙凤超
/// CreateDate:2013-05-31
/// Desc:通过rowid来修改科室列表，可以添加新的数据
/// Output: success:'true',info:'添加成功！' 失败时输出添加失败！
///         success:'false',info:'修改成功' 失败时输出修改失败！
/// Tables:  CT_LocationList   
ClassMethod SaveEntity(eobj As web.Entity.CT.CTLocationList) As %String
{
 s $zt="ERROR"
 s result=""
 if $IsObject(eobj)
 {
	s flag=..FormValidate(eobj.LLRowId,eobj.LLCode,eobj.LLDesc)  //调用重复验证
	if (flag=1)
	{
	    s result = "{success:'false',errorinfo:'该记录已经存在！'}"
	}
	else
	{
	  //如果RowId未赋值则增加
	  if (eobj.LLRowId="")       
	  {
	   //RowId未赋值,增加
	   s obj=##class(User.CTLocationList).%New()
	  }else {
	   //RowId已存在,修改
	    s obj=##class(User.CTLocationList).%OpenId(eobj.LLRowId)
	    s bobj=##class(web.Entity.CT.CTLocationList).%New()
	    s bobj.LLRowId=eobj.LLRowId
	    s bobj.LLCode = obj.LLCode                      
	    s bobj.LLDesc= obj.LLDesc    
	  } 
	   s obj.LLCode = eobj.LLCode                    
	   s obj.LLDesc= eobj.LLDesc                    
	    
	   Tstart
	   s sc=obj.%Save()
	   if $$$ISOK(sc)
	   {
	    Tcommit
	    s id = obj.%Id()
	    s result = "{success:'true',id:'"_id_"'}"          //保存数据后,通过RowId返回到这条数据
	    d:eobj.LLRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_LocationList","User.CTLocationList","科室列表",eobj.LLRowId,eobj.LLDesc,"U",eobj,bobj)
	    d:eobj.LLRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_LocationList","User.CTLocationList","科室列表",id,eobj.LLDesc,"A",eobj)
	   }
	   else
	   {
	      Trollback
	      s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    
	      s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("科室列表","web.DHCBL.CT.CTLocationList","SaveEntity",eobj)
	      s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	    } 
	}
 }
 else
 {
   s result = "{success:'false',errorinfo:'对象不存在！'}"
   s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("科室列表","web.DHCBL.CT.CTLocationList","SaveEntity","")
   s ^ERRORLOGINFO(logid)="对象不存在！"
 } 
 q result
ERROR
 s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("科室列表","web.DHCBL.CT.CTLocationList","SaveEntity",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q "{success:'false',errorinfo:'保存失败！'}"
}

}
