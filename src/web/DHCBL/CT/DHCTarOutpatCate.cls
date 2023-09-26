/// 名称: 门诊费用子类 业务类
/// 编写者：基础数据平台组-sunfengchao
/// 编写日期: 2016-12-2
Class web.DHCBL.CT.DHCTarOutpatCate Extends %RegisteredObject [ ProcedureBlock ]
{

Parameter SQLTableName = "DHC_TarOutpatCate";

/// Function:查询门诊费用子类
/// CreateDate:2016-12-2
/// Creator:基础数据平台 sunfengchao
/// Table:  DHC_TarOutpatCate
/// Input:  rowid, code, desc 
/// Output: TAROCRowId TAROCCode  TAROCDesc  TAROCTARTOCDR
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCTarOutpatCate", "GetList","","","","")
Query GetList(rowid As %String, code As %String, desc As %String, taroutdr As %String, hospid As %String) As %Query(ROWSPEC = "TAROCRowId:%String,TAROCCode:%String,TAROCDesc:%String,TAROCTARTOCDR:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
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

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, taroutdr As %String, hospid As %String) As %Status
{
  Set repid=$I(^CacheTemp)
  s ind=1
  s ret=0
  s AuStr=##class(web.DHCBL.Authorize.DHCTarOutpatCate).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  if (rowid'="")  
  {  
    s TAROCRowId=rowid
    s TAROCCode=$p($g(^DHCTarC("OC",rowid)),"^",1)
    s TAROCDesc=$p($g(^DHCTarC("OC",rowid)),"^",2)
    s TAROCTARTOCDR=$p($g(^DHCTarC("OC",rowid)),"^",3)
    s:TAROCTARTOCDR'="" TAROCTARTOCDR=$p($g(^DHCTarC("TOC",TAROCTARTOCDR)),"^",2)
    s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""
    s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("DHC_TarOutpatCate",TAROCRowId)
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
   s TAROCRowId=0
   for
   { 
    s TAROCRowId=$o(^DHCTarC("OC",TAROCRowId)) 
    q:TAROCRowId=""    
    s strTAROCRowId="{ID:"_TAROCRowId_"}"
    if (AuStr[strTAROCRowId)||(AuFlag=1)
    {
	  s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,TAROCRowId,hospid)
		continue:showflag="N"
	  
      s TAROCCode=$p($g(^DHCTarC("OC",TAROCRowId)),"^",1)
      s TAROCDesc=$p($g(^DHCTarC("OC",TAROCRowId)),"^",2) 
      s TAROCTARTOCDR=$p($g(^DHCTarC("OC",TAROCRowId)),"^",3) 
      s TARCRowId=TAROCTARTOCDR
      if ((TAROCTARTOCDR'="")&&($d(^DHCTarC("TOC",TAROCTARTOCDR))>0))
      {
        s TAROCTARTOCDR=$p($g(^DHCTarC("TOC",TAROCTARTOCDR)),"^",2)
      } 
      s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""
      s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("DHC_TarOutpatCate",TAROCRowId)
      s BDPInternalCode =$p($g(resultStr),"^",1)       
      s BDPInternalDesc = $p($g(resultStr),"^",2)  
      s BDPHospNationalCode=$p($g(resultStr),"^",3)         
      s BDPHospNationalDesc = $p($g(resultStr),"^",4)
      if (desc'="")
      {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("DHC_TarOutpatCate",TAROCRowId,TAROCDesc,desc)
      }
      else
      {
         s AliasFlag= 1   
      }    
      if ($ZCVT(TAROCCode,"U")[code)&(AliasFlag=1)&((taroutdr="")||(TARCRowId=taroutdr))  
      {
        d OutputRow
      }
    }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(TAROCRowId,TAROCCode,TAROCDesc,TAROCTARTOCDR,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc )
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

/// Function:   为combo提供查询入院费用子类的接口
/// CreateDate: 2016-12-2
/// Creator:    基础数据平台 孙凤超
/// Tables:     DHC_TarOutpatCate
/// Input:      desc
/// Output:     TARIC_RowId   TARIC_Desc 
/// Others:     d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCTarOutpatCate","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "TAROCRowId:%String, TAROCCode:%String,TAROCDesc:%String")
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
  s AuStr= ##class(web.DHCBL.Authorize.DHCTarOutpatCate).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  if (rowid'="")  
  {  
    s TAROCRowId=rowid
    s TAROCCode=$p($g(^DHCTarC("OC",rowid)),"^",1)
    s TAROCDesc=$p($g(^DHCTarC("OC",rowid)),"^",2)
    d OutputRowCmb
  }
  else
 {
   s:code'="" code=$ZCVT(code,"U") 
   s:desc'="" desc=$ZCVT(desc,"U")  
   s TAROCRowId=0
   for
   { 
    s TAROCRowId=$o(^DHCTarC("OC",TAROCRowId)) 
    q:TAROCRowId=""    
    s strTAROCRowId="{ID:"_TAROCRowId_"}"
    if (AuStr[strTAROCRowId)||(AuFlag=1)
    {
	  s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,TAROCRowId,hospid)
		continue:showflag="N"
	  
      s TAROCCode=$p($g(^DHCTarC("OC",TAROCRowId)),"^",1)
      s TAROCDesc=$p($g(^DHCTarC("OC",TAROCRowId)),"^",2)
      if (desc'="")
      {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("DHC_TarOutpatCate",TAROCRowId,TAROCDesc,desc)
      }
      else
      {
         s AliasFlag= 1   
      }    
      if ($ZCVT(TAROCCode,"U")[code)&(AliasFlag=1)  
      {
        d OutputRowCmb
      }
    }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(TAROCRowId,TAROCCode,TAROCDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function:   双击修改时的数据加载 
/// CreateDate: 2016-12-2
/// Creator:    基础数据平台 sunfengchao
/// Input:      id 
/// Others:     w ##class(web.DHCBL.CT.DHCTarOutpatCate).OpenData("2") 
ClassMethod OpenData(id As %String) As %String
{
 s str=""
 s pobj = ##class(User.DHCTarOutpatCate).%OpenId(id)
 s eobj = ##class(web.Entity.CT.DHCTarOutpatCate).%New()
 s eobj.TAROCRowId = id
 S eobj.TAROCCode=pobj.TAROCCode
 s eobj.TAROCDesc= pobj.TAROCDesc
 if $IsObject(pobj.TAROCTARTOCDR) {
	s eobj.TAROCTARTOCDR=pobj.TAROCTARTOCDR.%Id()
 }
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Creator:    
/// CreatDate:2013-8-27
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
 s return="",myInfo=""
 s found1=0
 if ($d(^DHCTARI(0,"OC",+id)))  s found1=1
 if (found1=1)  s myInfo=myInfo_"<收费项目>"
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
/// Tables:     DHC_TarOutpatCate
/// Others:     d ##class(web.DHCBL.CT.DHCTarOutpatCate).DeleteData("")
ClassMethod DeleteData(id As %String) As %String
{
     s result="",flag=""
     s re=..GetRefFlag(id)
     s RefFlag=$p(re,"^",1)
     if (RefFlag=1)
     { 
        s result="{success:'false',info:'"_$p(re,"^",2)_"'}"
     }
	 else
	 { 
         
	     s pobj = ##class(User.DHCTarOutpatCate).%OpenId(id)
	     s eobj = ##class(web.Entity.CT.DHCTarOutpatCate).%New()
	     s eobj.TAROCRowId = id
	     s eobj.TAROCCode=pobj.TAROCCode
	     s eobj.TAROCDesc= pobj.TAROCDesc
	     if $IsObject(pobj.TAROCTARTOCDR) {
			s eobj.TAROCTARTOCDR=pobj.TAROCTARTOCDR.%Id()
		 }
	     Tstart
	     s sc=##class(User.DHCTarOutpatCate).%DeleteId(id)
         if $$$ISOK(sc)
         {
           Tc
           d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarOutpatCate","User.DHCTarOutpatCate","门诊费用子类",id,eobj.TAROCDesc,"D",eobj)
           s result="{success:'true',info:'删除成功！'}"
           d eobj.%Close()
         }
         else
         {
           Trollback
           s result= "{success:'false',info:'删除失败！"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
           s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("门诊费用子类","web.DHCBL.CT.DHCTarOutpatCate","DeleteData",eobj)
           s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
        } 
     }
   q result
}

/// Function:   实现对收费项目子类修改增加操作
/// Creator:    基础数据平台 sunfengchao
/// CreateDate: 2016-12-2
/// Output:     success:'true',info:'添加成功！' 失败时输出添加失败！
/// Tables:     DHC_TarOutpatCate
ClassMethod SaveEntity(eobj As web.Entity.CT.DHCTarOutpatCate) As %String
{
  ;s $zt="ERROR"
  s result=""
  if $IsObject(eobj)
  {
	  s flag=..FormValidate(eobj.TAROCRowId,eobj.TAROCCode,eobj.TAROCDesc,eobj.LinkHospId)  //调用重复验证
	  if (flag=1)
	  {
		  s result = "{success:'false',errorinfo:'该记录已经存在！'}"
	  }
	  else
	  {
		  if (eobj.TAROCRowId="")  
		  {    
		    s obj=##class(User.DHCTarOutpatCate).%New() 
		  }   
		  else  
		  { 
		   s obj=##class(User.DHCTarOutpatCate).%OpenId(eobj.TAROCRowId)
		   s bobj=##class(web.Entity.CT.DHCTarOutpatCate).%New() 
		   s bobj.TAROCRowId=eobj.TAROCRowId
		   s bobj.TAROCCode = obj.TAROCCode                      
		   s bobj.TAROCDesc= obj.TAROCDesc                     
		   if $IsObject(obj.TAROCTARTOCDR) {
			s bobj.TAROCTARTOCDR=obj.TAROCTARTOCDR.%Id()
		   }
		  }
		   s obj.TAROCCode = eobj.TAROCCode                      
		   s obj.TAROCDesc= eobj.TAROCDesc                     
		   d obj.TAROCTARTOCDRSetObjectId(eobj.TAROCTARTOCDR)
		   Tstart
		   s sc=obj.%Save()
		   if $$$ISOK(sc)
		   {
		       Tcommit
		       s id = obj.%Id()
		       s result = "{success:'true',id:'"_id_"'}"        
		       d:eobj.TAROCRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarOutpatCate","User.DHCTarOutpatCate","门诊费用子类",eobj.TAROCRowId,eobj.TAROCDesc,"U",eobj,bobj)
		       d:eobj.TAROCRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarOutpatCate","User.DHCTarOutpatCate","门诊费用子类",id,eobj.TAROCDesc,"A",eobj)
		   }
		   else
		   {
		       Trollback
		       s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
		       s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("门诊费用子类","web.DHCBL.CT.DHCTarOutpatCate","SaveEntity",eobj)
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
 ;s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("门诊费用子类","web.DHCBL.CT.DHCTarOutpatCate","SaveEntity",eobj)
 ;s ^ERRORLOGINFO(logid)=$ze
 ;q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Function:   进行数据重复校验功能，并返回一个标志位
/// Creator:    基础数据平台组 sunfengchao
/// CreateDate: 2016-12-2
/// Table:      DHC_TarOutpatCate
/// Debug:      w ##class(web.DHCBL.CT.DHCTarOutpatCate).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String, hospid As %String = "") As %String
{
	s flag=0
	if code'=""
	{
		s idc=0
		for
		{
			s idc=$o(^DHCTarC("OC",0,"Code",code,idc)) q:idc=""
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
	
			s idd=$o(^DHCTarC("OC",0,"Desc",desc,idd)) q:idd=""
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
