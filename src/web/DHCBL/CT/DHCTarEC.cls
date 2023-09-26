/// 名称: 经济核算大类 业务类
/// 编写者：基础数据平台组-sunfengchao
/// 编写日期: 2016-12-2
Class web.DHCBL.CT.DHCTarEC Extends %RegisteredObject [ ProcedureBlock ]
{

/// update2020-02-11
Parameter SQLTableName = "DHC_TarEC";

/// Function:查询经济核算大类
/// CreateDate:2016-12-2
/// Creator:基础数据平台 sunfengchao
/// Table:  DHC_TarEC
/// Input:  rowid, code, desc 
/// Output: TARTECRowId  TARTECCode TARTECDesc
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCTarEC", "GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "TARTECRowId:%String,TARTECCode:%String,TARTECDesc:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
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
  s AuStr=##class(web.DHCBL.Authorize.DHCTarEC).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  if (rowid'="")  
  {  
    s TARTECRowId=rowid
    s TARTECCode=$p($g(^DHCTarC("TEC",rowid)),"^",1)
    s TARTECDesc=$p($g(^DHCTarC("TEC",rowid)),"^",2)
   
    s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""
    s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("DHC_TarEC",TARTECRowId)
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
   s TARTECRowId=0
   for
   { 
    s TARTECRowId=$o(^DHCTarC("TEC",TARTECRowId)) 
    q:TARTECRowId=""    
    s strTARTECRowId="{ID:"_TARTECRowId_"}"
    if (AuStr[strTARTECRowId)||(AuFlag=1)
    {
	    s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,TARTECRowId,hospid)
		continue:showflag="N"
	    
      s TARTECCode=$p($g(^DHCTarC("TEC",TARTECRowId)),"^",1)
      s TARTECDesc=$p($g(^DHCTarC("TEC",TARTECRowId)),"^",2) 
      s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""
      s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("DHC_TarEC",TARTECRowId)
      s BDPInternalCode =$p($g(resultStr),"^",1)       
      s BDPInternalDesc = $p($g(resultStr),"^",2)  
      s BDPHospNationalCode=$p($g(resultStr),"^",3)         
      s BDPHospNationalDesc = $p($g(resultStr),"^",4)
      if (desc'="")
      {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("DHC_TarEC",TARTECRowId,TARTECDesc,desc)
      }
      else
      {
         s AliasFlag= 1   
      }   
      if ($ZCVT(TARTECCode,"U")[code)&(AliasFlag=1) 
      {
        d OutputRow
      }
    }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(TARTECRowId,TARTECCode,TARTECDesc,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc )
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

/// Function: 为combo提供查询经济核算大类的接口
/// CreateDate:2016-12-2
/// Creator:  基础数据平台sunfengchao
/// Tables:   DHC_TarEC
/// Input:    rowid code  desc
/// Output:   DLMTHRowId  DLMTH_Desc   
/// Others:   d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCTarEC","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "TARTECRowId:%String,TARTECDesc:%String ")
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
  s AuStr= ##class(web.DHCBL.Authorize.DHCTarEC).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  if (rowid'="")  
  {  
    s TARTECRowId=rowid
    s TARTECDesc=$p($g(^DHCTarC("TEC",rowid)),"^",2)
    d OutputRowCmb
  }
  else
 {
   s:code'="" code=$ZCVT(code,"U") 
   s:desc'="" desc=$ZCVT(desc,"U")  
   s TARTECRowId=0
   for
   { 
    s TARTECRowId=$o(^DHCTarC("TEC",TARTECRowId)) 
    q:TARTECRowId=""    
    s strTARTECRowId="{ID:"_TARTECRowId_"}"
    if (AuStr[strTARTECRowId)||(AuFlag=1)
    {
	    s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,TARTECRowId,hospid)
		continue:showflag="N"
	    
      s TARTECDesc=$p($g(^DHCTarC("TEC",TARTECRowId)),"^",2)
      if (desc'="")
      {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("DHC_TarEC",TARTECRowId,TARTECDesc,desc)
      }
      else
      {
         s AliasFlag= 1   
      }   
      if (AliasFlag=1) 
      {
        d OutputRowCmb
      }
    }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(TARTECRowId,TARTECDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function:   双击修改时的数据加载 
/// CreateDate: 2016-12-2
/// Creator:    基础数据平台 sunfengchao
/// Input:      id 
/// Others:     w ##class(web.DHCBL.CT.DHCTarEC).OpenData("2") 
ClassMethod OpenData(id As %String) As %String
{
 s str=""
 s pobj = ##class(User.DHCTarEC).%OpenId(id)
 s eobj = ##class(web.Entity.CT.DHCTarEC).%New()
 s eobj.TARTECRowId = id
 S eobj.TARTECCode=pobj.TARTECCode
 s eobj.TARTECDesc= pobj.TARTECDesc
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Function:   用于删除时的逻辑判断 
/// Creator:    基础数据平台组 sunfengchao
/// CreateDate: 2016-11-8
/// Debug:      w ##class(web.DHCBL.CT.DHCTarEC).GetRefFlag("1")
ClassMethod GetRefFlag(id As %String) As %String
{
   s return="", myInfo=""
   s TARECRowId=0,found1=0
   for
   { 
    s TARECRowId=$o(^DHCTarC("EC",TARECRowId)) 
    q:TARECRowId=""      
    s TARECTARTECDR=$p($g(^DHCTarC("EC",TARECRowId)),"^",3) 
    if TARECTARTECDR=id s found1=1
   }
   if (found1=1)  s myInfo=myInfo_"<经济核算子类>"
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
/// Tables:     DHC_TarEC
/// Others:     d ##class(web.DHCBL.CT.DHCTarEC).DeleteData("")
ClassMethod DeleteData(id As %String) As %String
{
   s result="",flag=""
   s re=##class(web.DHCBL.CT.DHCTarEC).GetRefFlag(id)
   s RefFlag=$p(re,"^",1)
   if (RefFlag=1)
   {
     s result="{success:'false',info:'"_$p(re,"^",2)_"'}"
   }
   else
   {   
     Tstart
     s pobj = ##class(User.DHCTarEC).%OpenId(id)
     s eobj = ##class(web.Entity.CT.DHCTarEC).%New()
     s eobj.TARTECRowId = id
     s eobj.TARTECCode=pobj.TARTECCode
     s eobj.TARTECDesc= pobj.TARTECDesc
     s sc=##class(User.DHCTarEC).%DeleteId(id)
     if $$$ISOK(sc)
     {
       Tc
       d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarEC","User.DHCTarEC","经济核算大类",id,eobj.TARTECDesc,"D",eobj)
       s result="{success:'true',info:'删除成功！'}"
       d eobj.%Close()
     }
    else
    {
       Trollback
       s result= "{success:'false',info:'删除失败！"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
       s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("经济核算大类","web.DHCBL.CT.DHCTarEC","DeleteData",eobj)
       s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
    }
   } 
   q result
}

/// Function:   实现对经济核算大类修改增加操作
/// Creator:    基础数据平台 sunfengchao
/// CreateDate: 2016-12-2
/// Output:     success:'true',info:'添加成功！' 失败时输出添加失败！
///             success:'false',info:'修改成功' 失败时输出修改失败！
/// Tables:     DHC_TarEC
ClassMethod SaveEntity(eobj As web.Entity.CT.DHCTarEC) As %String
{
  ;s $zt="ERROR"
  s result=""
  if $IsObject(eobj)
  {
	  s flag=..FormValidate(eobj.TARTECRowId,eobj.TARTECCode,eobj.TARTECDesc,eobj.LinkHospId)  //调用重复验证
	  if (flag=1)
	  {
		  s result = "{success:'false',errorinfo:'该记录已经存在！'}"
	  }
	  else
	  {
		  if (eobj.TARTECRowId="")  
		  {    
		    s obj=##class(User.DHCTarEC).%New() 
		  }   
		  else  
		  { 
		   s obj=##class(User.DHCTarEC).%OpenId(eobj.TARTECRowId)
		   s bobj=##class(web.Entity.CT.DHCTarEC).%New() 
		   s bobj.TARTECRowId=eobj.TARTECRowId
		   s bobj.TARTECCode = obj.TARTECCode                      
		   s bobj.TARTECDesc= obj.TARTECDesc                     
		  }
		   s obj.TARTECCode = eobj.TARTECCode                      
		   s obj.TARTECDesc= eobj.TARTECDesc                     
		   Tstart
		   s sc=obj.%Save()
		   if $$$ISOK(sc)
		   {
		      Tcommit
		      s id = obj.%Id()
		      s result = "{success:'true',id:'"_id_"'}"        
		      d:eobj.TARTECRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarEC","User.DHCTarEC","经济核算大类",eobj.TARTECRowId,eobj.TARTECDesc,"U",eobj,bobj)
		      d:eobj.TARTECRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarEC","User.DHCTarEC","经济核算大类",id,eobj.TARTECDesc,"A",eobj)
		   }
		   else
		   {
		       Trollback
		       s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
		       s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("经济核算大类","web.DHCBL.CT.DHCTarEC","SaveEntity",eobj)
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
 ;s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("经济核算大类","web.DHCBL.CT.DHCTarEC","SaveEntity",eobj)
 ;s ^ERRORLOGINFO(logid)=$ze
 ;q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Function:   进行数据重复校验功能，并返回一个标志位
/// Creator:    基础数据平台组 sunfengchao
/// CreateDate: 2016-12-2
/// Table:      DHC_TarEC
/// Debug:      w ##class(web.DHCBL.CT.DHCTarEC).FormValidate("","","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String, hospid As %String = "") As %String
{
 	s flag=0
	if code'=""
	{
		s idc=0
		for
		{
			s idc=$o(^DHCTarC("TEC",0,"Code",code,idc)) q:idc=""
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
			s idd=$o(^DHCTarC("TEC",0,"Desc",desc,idd)) q:idd=""
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
