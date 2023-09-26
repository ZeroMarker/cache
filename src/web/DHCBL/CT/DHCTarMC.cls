/// 名称:   病案首页大类 业务类
/// 编写者：基础数据平台组-sunfengchao
/// 编写日期: 2016-12-2
Class web.DHCBL.CT.DHCTarMC Extends %RegisteredObject [ ProcedureBlock ]
{

/// update2020-02-11
Parameter SQLTableName = "DHC_TarMC";

/// Function:查询病案首页大类
/// CreateDate:2016-12-2
/// Creator:基础数据平台 sunfengchao
/// Table:  DHC_TarMC
/// Input:  rowid, code, desc 
/// Output: TARTMC_RowId   TARTMC_Code TARTMC_Desc
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCTarMC", "GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "TARTMCRowId:%String,TARTMCCode:%String,TARTMCDesc:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
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

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, hospid As %String) As %Status
{
  Set repid=$I(^CacheTemp)
  s ind=1
  s ret=0
  s AuStr=##class(web.DHCBL.Authorize.DHCTarMC).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  if (rowid'="")  
  {  
    s TARTMCRowId=rowid
    s TARTMCCode=$p($g(^DHCTarC("TMC",rowid)),"^",1)
    s TARTMCDesc=$p($g(^DHCTarC("TMC",rowid)),"^",2)
   
    s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""
    s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("DHC_TarMC",TARTMCRowId)
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
   s TARTMCRowId=0
   for
   { 
    s TARTMCRowId=$o(^DHCTarC("TMC",TARTMCRowId)) 
    q:TARTMCRowId=""    
    s strTARTMCRowId="{ID:"_TARTMCRowId_"}"
    if (AuStr[strTARTMCRowId)||(AuFlag=1)
    {
	     s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,TARTMCRowId,hospid)
		continue:showflag="N"
      s TARTMCCode=$p($g(^DHCTarC("TMC",TARTMCRowId)),"^",1)
      s TARTMCDesc=$p($g(^DHCTarC("TMC",TARTMCRowId)),"^",2)
 
      s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""
      s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("DHC_TarMC",TARTMCRowId)
      s BDPInternalCode =$p($g(resultStr),"^",1)       
      s BDPInternalDesc = $p($g(resultStr),"^",2)  
      s BDPHospNationalCode=$p($g(resultStr),"^",3)         
      s BDPHospNationalDesc = $p($g(resultStr),"^",4)
      if (desc'="")
      {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("DHC_TarMC",TARTMCRowId,TARTMCDesc,desc)
      }
      else
      {
         s AliasFlag= 1   
      }    
      if ($ZCVT(TARTMCCode,"U")[code)&(AliasFlag=1) 
      {
        d OutputRow
      }
    }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(TARTMCRowId,TARTMCCode,TARTMCDesc,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc )
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

/// Function: 为combo提供查询病案首页大类的接口
/// CreateDate:2016-12-2
/// Creator:  基础数据平台sunfengchao
/// Tables:   DHC_TarMC
/// Input:    rowid code  desc
/// Output:   DLMTHRowId  DLMTH_Desc   
/// Others:   d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCTarMC","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "TARTMCRowId:%String,TARTMCDesc:%String ")
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

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, hospid As %String) As %Status
{
  Set repid=$I(^CacheTemp)
  s ind=1
  s AuStr= ##class(web.DHCBL.Authorize.DHCTarMC).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  if (rowid'="")  
  {  
    s TARTMCRowId=rowid
    s TARTMCDesc=$p($g(^DHCTarC("TMC",rowid)),"^",2)
    d OutputRowCmb
  }
  else
 {
   s:code'="" code=$ZCVT(code,"U") 
   s:desc'="" desc=$ZCVT(desc,"U")  
   s TARTMCRowId=0
   for
   { 
    s TARTMCRowId=$o(^DHCTarC("TMC",TARTMCRowId)) 
    q:TARTMCRowId=""    
    s strTARTMCRowId="{ID:"_TARTMCRowId_"}"
    if (AuStr[strTARTMCRowId)||(AuFlag=1)
    {
	    s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,TARTMCRowId,hospid)
		continue:showflag="N"
      s TARTMCDesc=$p($g(^DHCTarC("TMC",TARTMCRowId)),"^",2)
      s TARTMCCode=$p($g(^DHCTarC("TMC",TARTMCRowId)),"^",1)
      if (desc'="")
      {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("DHC_TarMC",TARTMCRowId,TARTMCDesc,desc)
      }
      else
      {
         s AliasFlag= 1   
      }    
      if ($ZCVT(TARTMCCode,"U")[code)&(AliasFlag=1) 
      {
        d OutputRowCmb
     }
    }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(TARTMCRowId,TARTMCDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function:   双击修改时的数据加载 
/// CreateDate: 2016-12-2
/// Creator:    基础数据平台 sunfengchao
/// Input:      id 
/// Others:     w ##class(web.DHCBL.CT.DHCTarMC).OpenData("2") 
ClassMethod OpenData(id As %String) As %String
{
 s str=""
 s pobj = ##class(User.DHCTarMC).%OpenId(id)
 s eobj = ##class(web.Entity.CT.DHCTarMC).%New()
 s eobj.TARTMCRowId = id
 S eobj.TARTMCCode=pobj.TARTMCCode
 s eobj.TARTMCDesc= pobj.TARTMCDesc
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Function:   用于删除时的逻辑判断 
/// Creator:    基础数据平台组 sunfengchao
/// CreateDate: 2016-11-8
/// Debug:      w ##class(web.DHCBL.CT.DHCTarCate).GetRefFlag("1")
ClassMethod GetRefFlag(id As %String) As %String
{
   s return="", myInfo=""
   s TARMCRowId=0,found1=0
   for
   { 
    s TARMCRowId=$o(^DHCTarC("MC",TARMCRowId)) 
    q:TARMCRowId=""    
    s TARMCTARTMCDR=$p($g(^DHCTarC("MC",TARMCRowId)),"^",3) 
    if TARMCTARTMCDR=id s found1=1
   }
   if (found1=1)  s myInfo=myInfo_"<病案首页子类>"
   if (myInfo="")
   {
    s return="0^未被引用可删除！"
   }
   else 
   {
    s return="1^在"_myInfo_"表里被引用,不能删除!"
   }
   q return
}

/// Function:   实现删除操作
/// Creator:    基础数据平台 sunfengchao
/// CreateDate: 2016-12-2 
/// Output:     success:'true',info:'删除成功！ 失败时输出删除成功！
/// Tables:     DHC_TarMC
/// Others:     d ##class(web.DHCBL.CT.DHCTarMC).DeleteData("")
ClassMethod DeleteData(id As %String) As %String
{
   s result="",flag=""
   s re=##class(web.DHCBL.CT.DHCTarMC).GetRefFlag(id)
   s RefFlag=$p(re,"^",1)
   if (RefFlag=1)
   {
     s result="{success:'false',info:'"_$p(re,"^",2)_"'}"
   }
   else
   {   
     Tstart
     s pobj = ##class(User.DHCTarMC).%OpenId(id)
     s eobj = ##class(web.Entity.CT.DHCTarMC).%New()
     s eobj.TARTMCRowId = id
     s eobj.TARTMCCode=pobj.TARTMCCode
     s eobj.TARTMCDesc= pobj.TARTMCDesc
     s sc=##class(User.DHCTarMC).%DeleteId(id)
     if $$$ISOK(sc)
     {
       Tc
       d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarMC","User.DHCTarMC","病案首页大类",id,eobj.TARTMCDesc,"D",eobj)
       s result="{success:'true',info:'删除成功！'}"
       d eobj.%Close()
     }
    else
    {
       Trollback
       s result= "{success:'false',info:'删除失败！"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
       s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("病案首页大类","web.DHCBL.CT.DHCTarMC","DeleteData",eobj)
       s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
    } 
  }
  q result
}

/// Function:   实现对病案首页大类修改增加操作
/// Creator:    基础数据平台 sunfengchao
/// CreateDate: 2016-12-2
/// Output:     success:'true',info:'添加成功！' 失败时输出添加失败！
///             success:'false',info:'修改成功' 失败时输出修改失败！
/// Tables:     DHC_TarMC
ClassMethod SaveEntity(eobj As web.Entity.CT.DHCTarMC) As %String
{
  ;s $zt="ERROR"
  s result=""
  if $IsObject(eobj)
  {
	  s flag=..FormValidate(eobj.TARTMCRowId,eobj.TARTMCCode,eobj.TARTMCDesc,eobj.LinkHospId)  //调用重复验证
	  if (flag=1)
	  {
		  s result = "{success:'false',errorinfo:'该记录已经存在！'}"
	  }
	  else
	  {
		  if (eobj.TARTMCRowId="")  
		  {    
		    s obj=##class(User.DHCTarMC).%New() 
		  }   
		  else  
		  { 
		   s obj=##class(User.DHCTarMC).%OpenId(eobj.TARTMCRowId)
		   s bobj=##class(web.Entity.CT.DHCTarMC).%New() 
		   s bobj.TARTMCRowId=eobj.TARTMCRowId
		   s bobj.TARTMCCode = obj.TARTMCCode                      
		   s bobj.TARTMCDesc= obj.TARTMCDesc                     
		  }
		   s obj.TARTMCCode = eobj.TARTMCCode                      
		   s obj.TARTMCDesc= eobj.TARTMCDesc                     
		   Tstart
		   s sc=obj.%Save()
		   if $$$ISOK(sc)
		   {
		      Tcommit
		      s id = obj.%Id()
		      s result = "{success:'true',id:'"_id_"'}"        
		      d:eobj.TARTMCRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarMC","User.DHCTarMC","病案首页大类",eobj.TARTMCRowId,eobj.TARTMCDesc,"U",eobj,bobj)
		      d:eobj.TARTMCRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarMC","User.DHCTarMC","病案首页大类",id,eobj.TARTMCDesc,"A",eobj)
		   }
		   else
		   {
		       Trollback
		       s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
		       s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("病案首页大类","web.DHCBL.CT.DHCTarMC","SaveEntity",eobj)
		       s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		   }
   	   }
   }
   else
   {
	  s result = "{success:'false',errorinfo:'对象不存在！'}"
   }  
 q result
 ;ERROR
 ;s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("病案首页大类","web.DHCBL.CT.DHCTarMC","SaveEntity",eobj)
 ;s ^ERRORLOGINFO(logid)=$ze
 ;q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Function:   进行数据重复校验功能，并返回一个标志位
/// Creator:    基础数据平台组 sunfengchao
/// CreateDate: 2016-12-2
/// Table:      DHC_TarMC
/// Debug:      w ##class(web.DHCBL.CT.DHCTarMC).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String, hospid As %String = "") As %String
{
	s flag=0
	if code'=""
	{
		s idc=0
		for
		{
			s idc=$o(^DHCTarC("TMC",0,"Code",code,idc)) q:idc=""
			if (idc'=id)
			{
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,idc,hospid)
				continue:showflag="N"
				s flag=1
			}
		}
	}
	if desc'=""
	{
		s idd=0
		for
		{
			s idd=$o(^DHCTarC("TMC",0,"Desc",desc,idd)) q:idd=""
			if (idd'=id)
			{
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,idd,hospid)
				continue:showflag="N"
				s flag=1
			}
		}
	}
	q flag
}

}
