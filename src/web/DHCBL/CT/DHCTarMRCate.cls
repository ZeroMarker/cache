/// Function: 病案首页子类
/// Creator:  sunfengchao
/// CreateDate:2016-12-5
Class web.DHCBL.CT.DHCTarMRCate Extends %RegisteredObject [ ProcedureBlock ]
{

/// update2020-02-11
Parameter SQLTableName = "DHC_TarMRCate";

/// Function:查询病案首页子类
/// CreateDate:2016-12-5
/// Creator:基础数据平台 sunfengchao
/// Table:  DHC_TarMRCate
/// Input:  rowid, code, desc 
/// Output: TARMC_RowId TARMC_Code  TARMC_Desc  TARMC_TARTMC_DR
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCTarMRCate", "GetList","","","","")
Query GetList(rowid As %String, code As %String, desc As %String, taremcdr As %String, hospid As %String) As %Query(ROWSPEC = "TARMCRowId:%String,TARMCCode:%String,TARMCDesc:%String,TARMCTARTMCDR:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
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

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, taremcdr As %String, hospid As %String) As %Status
{
  Set repid=$I(^CacheTemp)
  s ind=1
  s ret=0
  s AuStr= ##class(web.DHCBL.Authorize.DHCTarMRCate).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  if (rowid'="")  
  {  
    s TARMCRowId=rowid
    s TARMCCode=$p($g(^DHCTarC("MC",rowid)),"^",1)
    s TARMCDesc=$p($g(^DHCTarC("MC",rowid)),"^",2)
    s TARMCTARTMCDR=$p($g(^DHCTarC("MC",rowid)),"^",3)
    s:TARMCTARTMCDR'="" TARMCTARTMCDR=$p($g(^DHCTarC("TMC",TARMCTARTMCDR)),"^",2)
    s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""
    s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("DHC_TarMRCate",TARMCRowId)
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
   s TARMCRowId=0
   for
   { 
    s TARMCRowId=$o(^DHCTarC("MC",TARMCRowId)) 
    q:TARMCRowId=""    
    s strTARMCRowId="{ID:"_TARMCRowId_"}"
    if (AuStr[strTARMCRowId)||(AuFlag=1)
    {
	    s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,TARMCRowId,hospid)
		continue:showflag="N"
      s TARMCCode=$p($g(^DHCTarC("MC",TARMCRowId)),"^",1)
      s TARMCDesc=$p($g(^DHCTarC("MC",TARMCRowId)),"^",2) 
      s TARMCTARTMCDR=$p($g(^DHCTarC("MC",TARMCRowId)),"^",3) 
      s TARCRowId=TARMCTARTMCDR
      if ((TARMCTARTMCDR'="")&&($d(^DHCTarC("TMC",TARMCTARTMCDR))>0))
      {
        s TARMCTARTMCDR=$p($g(^DHCTarC("TMC",TARMCTARTMCDR)),"^",2)
      } 
      s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""
      s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("DHC_TarMRCate",TARMCRowId)
      s BDPInternalCode =$p($g(resultStr),"^",1)       
      s BDPInternalDesc = $p($g(resultStr),"^",2)  
      s BDPHospNationalCode=$p($g(resultStr),"^",3)         
      s BDPHospNationalDesc = $p($g(resultStr),"^",4)
      if (desc'="")
      {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("DHC_TarMRCate",TARMCRowId,TARMCDesc,desc)
      }
      else
      {
         s AliasFlag= 1   
      }    
      if ($ZCVT(TARMCCode,"U")[code)&(AliasFlag=1)&((taremcdr="")||(TARCRowId=taremcdr))  
      {
        d OutputRow
      }
    }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(TARMCRowId,TARMCCode,TARMCDesc,TARMCTARTMCDR,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc )
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

/// Function:   为combo提供查询入院费用子类的接口
/// CreateDate: 2016-12-2
/// Creator:    基础数据平台 孙凤超
/// Tables:     DHC_TarMRCate
/// Input:      desc
/// Output:     TAREC_RowId    TAREC_Desc   
/// Others:     d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCTarMRCate","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "TARMCRowId:%String, TARMCCode:%String,TARMCDesc:%String")
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
  s AuStr= ##class(web.DHCBL.Authorize.DHCTarMRCate).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  if (rowid'="")  
  {  
    s TARMCRowId=rowid
    s TARMCCode=$p($g(^DHCTarC("MC",rowid)),"^",1)
    s TARMCDesc=$p($g(^DHCTarC("MC",rowid)),"^",2)
    d OutputRowCmb
  }
  else
 {
   s:code'="" code=$ZCVT(code,"U") 
   s:desc'="" desc=$ZCVT(desc,"U")  
   s TARMCRowId=0
   for
   { 
    s TARMCRowId=$o(^DHCTarC("MC",TARMCRowId)) 
    q:TARMCRowId=""    
    s strTARMCRowId="{ID:"_TARMCRowId_"}"
    if (AuStr[strTARMCRowId)||(AuFlag=1)
    {
	   s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,TARMCRowId,hospid)
		continue:showflag="N"
      s TARMCCode=$p($g(^DHCTarC("MC",TARMCRowId)),"^",1)
      s TARMCDesc=$p($g(^DHCTarC("MC",TARMCRowId)),"^",2)
      if (desc'="")
      {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("DHC_TarMRCate",TARMCRowId,TARMCDesc,desc)
      }
      else
      {
         s AliasFlag= 1   
      } 
      if (($ZCVT(TARMCCode,"U")[code))&(AliasFlag=1)  
      {
        d OutputRowCmb
      }
    }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(TARMCRowId,TARMCCode,TARMCDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function:   双击修改时的数据加载 
/// CreateDate: 2016-12-2
/// Creator:    基础数据平台 sunfengchao
/// Input:      id 
/// Others:     w ##class(web.DHCBL.CT.DHCTarMRCate).OpenData("2") 
ClassMethod OpenData(id As %String) As %String
{
 s str=""
 s pobj = ##class(User.DHCTarMRCate).%OpenId(id)
 s eobj = ##class(web.Entity.CT.DHCTarMRCate).%New()
 s eobj.TARMCRowId = id
 S eobj.TARMCCode=pobj.TARMCCode
 s eobj.TARMCDesc= pobj.TARMCDesc
 if $IsObject(pobj.TARMCTARTMCDR) {
	s eobj.TARMCTARTMCDR=pobj.TARMCTARTMCDR.%Id()
 }
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

///  ^DHCTARI(0,"MR",35,3456)
/// Function:   用于删除时的逻辑判断 
/// Creator:    基础数据平台组 sunfengchao
/// CreateDate: 2016-11-8
/// Debug:      w ##class(web.DHCBL.CT.DHCTarMRCate).GetRefFlag("1")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="", myInfo=""
    s found1=0
    if ($d( ^DHCTARI(0,"MR",+id)))  s found1=1
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
/// Tables:     DHC_TarMRCate
/// Others:     d ##class(web.DHCBL.CT.DHCTarMRCate).DeleteData("")
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
         
         
	     s pobj = ##class(User.DHCTarMRCate).%OpenId(id)
	     s eobj = ##class(web.Entity.CT.DHCTarMRCate).%New()
	     s eobj.TARMCRowId = id
	     s eobj.TARMCCode=pobj.TARMCCode
	     s eobj.TARMCDesc= pobj.TARMCDesc
	     if $IsObject(pobj.TARMCTARTMCDR) {
			s eobj.TARMCTARTMCDR=pobj.TARMCTARTMCDR.%Id()
		 }
		 Tstart
     	 s sc=##class(User.DHCTarMRCate).%DeleteId(id)
         if $$$ISOK(sc)
         {
           Tc
           d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarMRCate","User.DHCTarMRCate","病案首页子类",id,eobj.TARMCDesc,"D",eobj)
           s result="{success:'true',info:'删除成功！'}"
           d eobj.%Close()
         }
         else
         {
           Trollback
           s result= "{success:'false',info:'删除失败！"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
           s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("病案首页子类","web.DHCBL.CT.DHCTarMRCate","DeleteData",eobj)
           s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
         } 
    }
   q result
}

/// Function:   实现对收费项目子类修改增加操作
/// Creator:    基础数据平台 sunfengchao
/// CreateDate: 2016-12-2
/// Output:     success:'true',info:'添加成功！' 失败时输出添加失败！
/// Tables:     DHC_TarMRCate
ClassMethod SaveEntity(eobj As web.Entity.CT.DHCTarMRCate) As %String
{
  ;s $zt="ERROR"
  s result=""
  if $IsObject(eobj)
  {
	  s flag=..FormValidate(eobj.TARMCRowId,eobj.TARMCCode,eobj.TARMCDesc,eobj.LinkHospId)  //调用重复验证
	  if (flag=1)
	  {
		  s result = "{success:'false',errorinfo:'该记录已经存在！'}"
	  }
	  else
	  {
		  if (eobj.TARMCRowId="")  
		  {    
		    s obj=##class(User.DHCTarMRCate).%New() 
		  }   
		  else  
		  { 
		   s obj=##class(User.DHCTarMRCate).%OpenId(eobj.TARMCRowId)
		   s bobj=##class(web.Entity.CT.DHCTarMRCate).%New() 
		   s bobj.TARMCRowId=eobj.TARMCRowId
		   s bobj.TARMCCode = obj.TARMCCode                      
		   s bobj.TARMCDesc= obj.TARMCDesc                     
		   if $IsObject(obj.TARMCTARTMCDR) {
			s bobj.TARMCTARTMCDR=obj.TARMCTARTMCDR.%Id()
		   }
		  }
		   s obj.TARMCCode = eobj.TARMCCode                      
		   s obj.TARMCDesc= eobj.TARMCDesc                     
		   d obj.TARMCTARTMCDRSetObjectId(eobj.TARMCTARTMCDR)
		   Tstart
		   s sc=obj.%Save()
		   if $$$ISOK(sc)
		   {
		       Tcommit
		       s id = obj.%Id()
		       s result = "{success:'true',id:'"_id_"'}"        
		       d:eobj.TARMCRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarMRCate","User.DHCTarMRCate","病案首页子类",eobj.TARMCRowId,eobj.TARMCDesc,"U",eobj,bobj)
		       d:eobj.TARMCRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarMRCate","User.DHCTarMRCate","病案首页子类",id,eobj.TARMCDesc,"A",eobj)
		   }
		   else
		   {
		       Trollback
		       s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
		       s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("病案首页子类","web.DHCBL.CT.DHCTarMRCate","SaveEntity",eobj)
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
 ;s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("病案首页子类","web.DHCBL.CT.DHCTarMRCate","SaveEntity",eobj)
 ;s ^ERRORLOGINFO(logid)=$ze
 ;q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Function:   进行数据重复校验功能，并返回一个标志位
/// Creator:    基础数据平台组 sunfengchao
/// CreateDate: 2016-12-2
/// Table:      DHC_TarMRCate
/// Debug:      w ##class(web.DHCBL.CT.DHCTarMRCate).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String, hospid As %String = "") As %String
{
	s flag=0
	if code'=""
	{
		s idc=0
		for
		{
			s idc=$o(^DHCTarC("MC",0,"Code",code,idc)) q:idc=""
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
			s idd=$o(^DHCTarC("MC",0,"Desc",desc,idd)) q:idd=""
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
