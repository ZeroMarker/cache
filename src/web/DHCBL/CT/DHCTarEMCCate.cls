/// 名称: 经济核算子类 业务类
/// 编写者：基础数据平台组-sunfengchao
/// 编写日期: 2016-12-2
Class web.DHCBL.CT.DHCTarEMCCate Extends %RegisteredObject [ ProcedureBlock ]
{

/// update2020-02-11
Parameter SQLTableName = "DHC_TarEMCCate";

/// Function:查询经济核算子类
/// CreateDate:2016-12-2
/// Creator:基础数据平台 sunfengchao
/// Table:  DHC_TarEMCCate
/// Input:  rowid, code, desc 
/// Output: TAREC_RowId TAREC_Code  TAREC_Desc  TAREC_TARTEC_DR
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCTarEMCCate", "GetList","","","","")
Query GetList(rowid As %String, code As %String, desc As %String, taremcdr As %String, hospid As %String) As %Query(ROWSPEC = "TARECRowId:%String,TARECCode:%String,TARECDesc:%String,TARECTARTECDR:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
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
  s AuStr=##class(web.DHCBL.Authorize.DHCTarEMCCate).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  if (rowid'="")  
  {  
    s TARECRowId=rowid
    s TARECCode=$p($g(^DHCTarC("EC",rowid)),"^",1)
    s TARECDesc=$p($g(^DHCTarC("EC",rowid)),"^",2)
    s TARECTARTECDR=$p($g(^DHCTarC("EC",rowid)),"^",3)
    s:TARECTARTECDR'="" TARECTARTECDR=$p($g(^DHCTarC("TEC",TARECTARTECDR)),"^",2)
    s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""
    s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("DHC_TarEMCCate",TARECRowId)
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
   s TARECRowId=0
   for
   { 
    s TARECRowId=$o(^DHCTarC("EC",TARECRowId)) 
    q:TARECRowId=""    
    s strTARECRowId="{ID:"_TARECRowId_"}"
    if (AuStr[strTARECRowId)||(AuFlag=1)
    {
	   s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,TARECRowId,hospid)
		continue:showflag="N"
		
      s TARECCode=$p($g(^DHCTarC("EC",TARECRowId)),"^",1)
      s TARECDesc=$p($g(^DHCTarC("EC",TARECRowId)),"^",2) 
      s TARECTARTECDR=$p($g(^DHCTarC("EC",TARECRowId)),"^",3) 
      s TARCRowId=TARECTARTECDR
      if ((TARECTARTECDR'="")&&($d(^DHCTarC("TEC",TARECTARTECDR))>0))
      {
        s TARECTARTECDR=$p($g(^DHCTarC("TEC",TARECTARTECDR)),"^",2)
      }  
      s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""
      s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("DHC_TarEMCCate",TARECRowId)
      s BDPInternalCode =$p($g(resultStr),"^",1)       
      s BDPInternalDesc = $p($g(resultStr),"^",2)  
      s BDPHospNationalCode=$p($g(resultStr),"^",3)         
      s BDPHospNationalDesc = $p($g(resultStr),"^",4)
      if (desc'="")
      {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("DHC_TarEMCCate",TARECRowId,TARECDesc,desc) 
      }
      else
      {
         s AliasFlag= 1   
      }   
      if ($ZCVT(TARECCode,"U")[code)&(AliasFlag=1)&((taremcdr="")||(TARCRowId=taremcdr)) 
      {
        d OutputRow
      }
    }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(TARECRowId,TARECCode,TARECDesc,TARECTARTECDR,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc )
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

/// Function:   为combo提供查询入院费用子类的接口
/// CreateDate: 2016-12-2
/// Creator:    基础数据平台 孙凤超
/// Tables:     DHC_TarEMCCate
/// Input:      desc
/// Output:     TAREC_RowId    TAREC_Desc   
/// Others:     d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCTarEMCCate","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "TARECRowId:%String, TARECCode:%String,TARECDesc:%String")
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
  s AuStr=##class(web.DHCBL.Authorize.DHCTarEMCCate).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  if (rowid'="")  
  {  
    s TARECRowId=rowid
    s TARECCode=$p($g(^DHCTarC("EC",rowid)),"^",1)
    s TARECDesc=$p($g(^DHCTarC("EC",rowid)),"^",2)
    d OutputRowCmb
  }
  else
 {
   s:code'="" code=$ZCVT(code,"U") 
   s:desc'="" desc=$ZCVT(desc,"U")  
   s TARECRowId=0
   for
   { 
    s TARECRowId=$o(^DHCTarC("EC",TARECRowId)) 
    q:TARECRowId=""    
    s strTARECRowId="{ID:"_TARECRowId_"}"
    if (AuStr[strTARECRowId)||(AuFlag=1)
    {
	   s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,TARECRowId,hospid)
		continue:showflag="N"
		
      s TARECCode=$p($g(^DHCTarC("EC",TARECRowId)),"^",1)
      s TARECDesc=$p($g(^DHCTarC("EC",TARECRowId)),"^",2)
    
      if (desc'="")
      {  
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("DHC_TarEMCCate",TARECRowId,TARECDesc,desc) 
      }
      else
      {
         s AliasFlag= 1   
      }   
      if ($ZCVT(TARECCode,"U")[code)&(AliasFlag=1) 
      {
        d OutputRowCmb
      }
    }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(TARECRowId,TARECCode,TARECDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function:   双击修改时的数据加载 
/// CreateDate: 2016-12-2
/// Creator:    基础数据平台 sunfengchao
/// Input:      id 
/// Others:     w ##class(web.DHCBL.CT.DHCTarEMCCate).OpenData("2") 
ClassMethod OpenData(id As %String) As %String
{
 s str=""
 s pobj = ##class(User.DHCTarEMCCate).%OpenId(id)
 s eobj = ##class(web.Entity.CT.DHCTarEMCCate).%New()
 s eobj.TARECRowId = id
 S eobj.TARECCode=pobj.TARECCode
 s eobj.TARECDesc= pobj.TARECDesc
 if $IsObject(pobj.TARECTARTECDR) {
		s eobj.TARECTARTECDR=pobj.TARECTARTECDR.%Id()
	}
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Function:   用于删除时的逻辑判断 
/// Creator:    基础数据平台组 sunfengchao
/// CreateDate: 2016-11-8
/// Debug:      w ##class(web.DHCBL.CT.DHCTarMRCate).GetRefFlag("1")
ClassMethod GetRefFlag(id As %String) As %String
{
     s return="", myInfo=""
     s found1=0
     if ($d( ^DHCTARI(0,"EC",+id)))  s found1=1
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
/// Tables:     DHC_TarEMCCate
/// Others:     d ##class(web.DHCBL.CT.DHCTarEMCCate).DeleteData("")
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

		s pobj = ##class(User.DHCTarEMCCate).%OpenId(id)
		s eobj = ##class(web.Entity.CT.DHCTarEMCCate).%New()
		s eobj.TARECRowId = id
		s eobj.TARECCode=pobj.TARECCode
		s eobj.TARECDesc= pobj.TARECDesc
		if $IsObject(pobj.TARECTARTECDR) {
			s eobj.TARECTARTECDR=pobj.TARECTARTECDR.%Id()
		}
		Tstart
		s sc=##class(User.DHCTarEMCCate).%DeleteId(id)
		if $$$ISOK(sc)
		{
			Tc
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarEMCCate","User.DHCTarEMCCate","经济核算子类",id,eobj.TARECDesc,"D",eobj)
			s result="{success:'true',info:'删除成功！'}"
			d eobj.%Close()
		}
		else
		{
			Trollback
			s result= "{success:'false',info:'删除失败！"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("经济核算子类","web.DHCBL.CT.DHCTarEMCCate","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		} 
	}
	q result
}

/// Function:   实现对收费项目子类修改增加操作
/// Creator:    基础数据平台 sunfengchao
/// CreateDate: 2016-12-2
/// Output:     success:'true',info:'添加成功！' 失败时输出添加失败！
/// Tables:     DHC_TarEMCCate
ClassMethod SaveEntity(eobj As web.Entity.CT.DHCTarEMCCate) As %String
{
  ;s $zt="ERROR"
  s result=""
  if $IsObject(eobj)
  {
	  s flag=..FormValidate(eobj.TARECRowId,eobj.TARECCode,eobj.TARECDesc,eobj.LinkHospId)  //调用重复验证
	  if (flag=1)
	  {
		  s result = "{success:'false',errorinfo:'该记录已经存在！'}"
	  }
	  else
	  {
		  if (eobj.TARECRowId="")  
		  {    
		    s obj=##class(User.DHCTarEMCCate).%New() 
		  }   
		  else  
		  { 
		   s obj=##class(User.DHCTarEMCCate).%OpenId(eobj.TARECRowId)
		   s bobj=##class(web.Entity.CT.DHCTarEMCCate).%New() 
		   s bobj.TARECRowId=eobj.TARECRowId
		   s bobj.TARECCode = obj.TARECCode                      
		   s bobj.TARECDesc= obj.TARECDesc                     
		   if $IsObject(obj.TARECTARTECDR) {
			s bobj.TARECTARTECDR=obj.TARECTARTECDR.%Id()
		   }
		  }
		   s obj.TARECCode = eobj.TARECCode                      
		   s obj.TARECDesc= eobj.TARECDesc                     
		   d obj.TARECTARTECDRSetObjectId(eobj.TARECTARTECDR)
		   Tstart
		   s sc=obj.%Save()
		   if $$$ISOK(sc)
		   {
		       Tcommit
		       s id = obj.%Id()
		       s result = "{success:'true',id:'"_id_"'}"        
		       d:eobj.TARECRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarEMCCate","User.DHCTarEMCCate","经济核算子类",eobj.TARECRowId,eobj.TARECDesc,"U",eobj,bobj)
		       d:eobj.TARECRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarEMCCate","User.DHCTarEMCCate","经济核算子类",id,eobj.TARECDesc,"A",eobj)
		   }
		   else
		   {
		       Trollback
		       s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
		       s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("经济核算子类","web.DHCBL.CT.DHCTarEMCCate","SaveEntity",eobj)
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
 ;s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("经济核算子类","web.DHCBL.CT.DHCTarEMCCate","SaveEntity",eobj)
 ;s ^ERRORLOGINFO(logid)=$ze
 ;q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Function:   进行数据重复校验功能，并返回一个标志位
/// Creator:    基础数据平台组 sunfengchao
/// CreateDate: 2016-12-2
/// Table:      DHC_TarEMCCate
/// Debug:      w ##class(web.DHCBL.CT.DHCTarEMCCate).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String, hospid As %String = "") As %String
{
	s flag=0
	if code'=""
	{
		s idc=0
		for
		{
			s idc=$o(^DHCTarC("EC",0,"Code",code,idc)) q:idc=""
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
			s idd=$o(^DHCTarC("EC",0,"Desc",desc,idd)) q:idd=""
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
