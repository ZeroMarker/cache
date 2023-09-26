/// Function: 计费-收费项目大类 
/// Creator:  sunfengchao
/// CreateDate:2016-12-2
Class web.DHCBL.CT.DHCTarCate Extends %RegisteredObject [ ProcedureBlock ]
{

Parameter SQLTableName = "DHC_TarCate";

/// Function:查询收费项目大类 
/// CreateDate:2016-12-2
/// Creator:基础数据平台 sunfengchao
/// Table:  DHC_TarCate
/// Input:  rowid, code, desc 
/// Output: TARC_RowId  TARC_Code   TARC_Desc 
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCTarCate", "GetList","","","","")
Query GetList(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "TARCRowId:%String,TARCCode:%String,TARCDesc:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
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
  s AuStr= ##class(web.DHCBL.Authorize.DHCTarCate).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  if (rowid'="")  
  {  
    s TARCRowId=rowid
    s TARCCode=$p($g(^DHCTarC("CC",rowid)),"^",1)
    s TARCDesc=$p($g(^DHCTarC("CC",rowid)),"^",2)
   
    s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""
    s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("DHC_TarCate",TARCRowId)
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
   s TARCRowId=0
   for
   { 
    s TARCRowId=$o(^DHCTarC("CC",TARCRowId)) 
    q:TARCRowId=""    
    s strTARCRowId="{ID:"_TARCRowId_"}"
    if (AuStr[strTARCRowId)||(AuFlag=1)
    {
	    
		s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,TARCRowId,hospid)
		continue:showflag="N"
      s TARCCode=$p($g(^DHCTarC("CC",TARCRowId)),"^",1)
      s TARCDesc=$p($g(^DHCTarC("CC",TARCRowId)),"^",2)
      s AliasRowId=0,ALIASText1=""
      for
      {
         s AliasRowId=$o(^User.BDPAliasI("DataRef","DHC_TarCate",TARCRowId,AliasRowId))
         q:AliasRowId=""
         S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
         ; 查询出对应rowid下的所有别名，用"^"进行连接
         s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
      }
      s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(TARCDesc)  
     
      s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""
      s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("DHC_TarCate",TARCRowId)
      s BDPInternalCode =$p($g(resultStr),"^",1)       
      s BDPInternalDesc = $p($g(resultStr),"^",2)  
      s BDPHospNationalCode=$p($g(resultStr),"^",3)         
      s BDPHospNationalDesc = $p($g(resultStr),"^",4)
      if (($ZCVT(TARCCode,"U")[code))&(($ZCVT(TARCDesc,"U")[desc)||(ALIASText1[desc)||(PINYINCODE[desc))  
      {
        d OutputRow
      }
    }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(TARCRowId,TARCCode,TARCDesc,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc )
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

/// Function:进行数据检索，为combo提供查询收费项目大类的接口
/// CreateDate:2012-12-10
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables:DHC_TarCate
/// Input: desc
/// Output: DLMTH_RowId DLMTH_Code DLMTH_Desc   
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCTarCate","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "TARCRowId:%String, TARCCode:%String,TARCDesc:%String ")
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
  s AuStr= ##class(web.DHCBL.Authorize.DHCTarCate).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  if (rowid'="")  
  {  
    s TARCRowId=rowid
    s TARCCode=$p($g(^DHCTarC("CC",rowid)),"^",1)
    s TARCDesc=$p($g(^DHCTarC("CC",rowid)),"^",2)
    d OutputRowCmb
  }
  else
 {
   s:code'="" code=$ZCVT(code,"U") 
   s:desc'="" desc=$ZCVT(desc,"U")  
   s TARCRowId=0
   for
   { 
    s TARCRowId=$o(^DHCTarC("CC",TARCRowId)) 
    q:TARCRowId=""    
    s strTARCRowId="{ID:"_TARCRowId_"}"
    if (AuStr[strTARCRowId)||(AuFlag=1)
    {
	    s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,TARCRowId,hospid)
		continue:showflag="N"
		
      s TARCCode=$p($g(^DHCTarC("CC",TARCRowId)),"^",1)
      s TARCDesc=$p($g(^DHCTarC("CC",TARCRowId)),"^",2)
      s AliasRowId=0,ALIASText1=""
      for
      {
         s AliasRowId=$o(^User.BDPAliasI("DataRef","DHC_TarCate",TARCRowId,AliasRowId))
         q:AliasRowId=""
         S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
         ; 查询出对应rowid下的所有别名，用"^"进行连接
         s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
      }
      s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(TARCDesc)  
      if (($ZCVT(TARCCode,"U")[code))&(($ZCVT(TARCDesc,"U")[desc)||(ALIASText1[desc)||(PINYINCODE[desc))  
      {
        d OutputRowCmb
      }
    }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(TARCRowId,TARCCode,TARCDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function:   双击修改时的数据加载 
/// CreateDate: 2016-12-2
/// Creator:    基础数据平台 sunfengchao
/// Input:      id 
/// Others:     w ##class(web.DHCBL.CT.DHCTarCate).OpenData("2") 
ClassMethod OpenData(id As %String) As %String
{
 s str=""
 s pobj = ##class(User.DHCTarCate).%OpenId(id)
 s eobj = ##class(web.Entity.CT.DHCTarCate).%New()
 s eobj.TARCRowId = id
 S eobj.TARCCode=pobj.TARCCode
 s eobj.TARCDesc= pobj.TARCDesc
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
   s TARSCRowId=0,found1=0
   for
   { 
    s TARSCRowId=$o(^DHCTarC("SC",TARSCRowId)) 
    q:TARSCRowId=""    
    s TARSCTARCDR=$p($g(^DHCTarC("SC",TARSCRowId)),"^",3) 
    if TARSCTARCDR=id s found1=1
   }
   if (found1=1)  s myInfo=myInfo_"<收费项目子类>"
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
/// Tables:     DHC_TarCate
/// Others:     d ##class(web.DHCBL.CT.DHCTarCate).DeleteData("")
ClassMethod DeleteData(id As %String) As %String
{
   s result="",flag=""
   s re=##class(web.DHCBL.CT.DHCTarCate).GetRefFlag(id)
   s RefFlag=$p(re,"^",1)
   if (RefFlag=1)
   {
     s result="{success:'false',info:'"_$p(re,"^",2)_"'}"
   }
   else
   {   
     Tstart
     s pobj = ##class(User.DHCTarCate).%OpenId(id)
     s eobj = ##class(web.Entity.CT.DHCTarCate).%New()
     s eobj.TARCRowId = id
     s eobj.TARCCode=pobj.TARCCode
     s eobj.TARCDesc= pobj.TARCDesc
     s sc=##class(User.DHCTarCate).%DeleteId(id)
     if $$$ISOK(sc)
     {
       Tc
       d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarCate","User.DHCTarCate","收费项目大类",id,eobj.TARCDesc,"D",eobj)
       s result="{success:'true',info:'删除成功！'}"
       d eobj.%Close()
     }
    else
   {
    Trollback
    s result= "{success:'false',info:'删除失败！"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
    s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("收费项目大类","web.DHCBL.CT.DHCTarCate","DeleteData",eobj)
    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   } 
  }
   q result
}

/// Function:   实现对收费项目大类修改增加操作
/// Creator:    基础数据平台 sunfengchao
/// CreateDate: 2016-12-2
/// Output:     success:'true',info:'添加成功！' 失败时输出添加失败！
///             success:'false',info:'修改成功' 失败时输出修改失败！
/// Tables:     DHC_TarCate
ClassMethod SaveEntity(eobj As web.Entity.CT.DHCTarCate) As %String
{
  //s $zt="ERROR"
  s result=""
  if $IsObject(eobj)
  {
	  s flag=..FormValidate(eobj.TARCRowId,eobj.TARCCode,eobj.TARCDesc,eobj.LinkHospId)  //调用重复验证
	  if (flag=1)
	  {
		  s result = "{success:'false',errorinfo:'该记录已经存在！'}"
	  }
	  else
	  {
		  if (eobj.TARCRowId="")  
		  {    
		    s obj=##class(User.DHCTarCate).%New() 
		  }   
		  else  
		  { 
		   s obj=##class(User.DHCTarCate).%OpenId(eobj.TARCRowId)
		   s bobj=##class(web.Entity.CT.DHCTarCate).%New() 
		   s bobj.TARCRowId=eobj.TARCRowId
		   s bobj.TARCCode = obj.TARCCode                      
		   s bobj.TARCDesc= obj.TARCDesc                     
		   
		  }
		   s obj.TARCCode = eobj.TARCCode                      
		   s obj.TARCDesc= eobj.TARCDesc                     
		   
		   Tstart
		    s sc=obj.%Save()
		    if $$$ISOK(sc)
		    {
		       Tcommit
		       s id = obj.%Id()
		       s result = "{success:'true',id:'"_id_"'}"        
		       d:eobj.TARCRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarCate","User.DHCTarCate","收费项目大类",eobj.TARCRowId,eobj.TARCDesc,"U",eobj,bobj)
		       d:eobj.TARCRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarCate","User.DHCTarCate","收费项目大类",id,eobj.TARCDesc,"A",eobj)
		   }
		   else
		   {
		       Trollback
		       s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
		       s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("收费项目大类","web.DHCBL.CT.DHCTarCate","SaveEntity",eobj)
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
 ;s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("收费项目大类","web.DHCBL.CT.DHCTarCate","SaveEntity",eobj)
 ;s ^ERRORLOGINFO(logid)=$ze
 ;q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Function:   进行数据重复校验功能，并返回一个标志位
/// Creator:    基础数据平台组 sunfengchao
/// CreateDate: 2016-12-2
/// Table:      DHC_TarCate
/// Debug:      w ##class(web.DHCBL.CT.DHCTarCate).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String, hospid As %String = "") As %String
{
	s flag=0
	if code'=""
	{
		s idc=0
		for
		{
			s idc=$o(^DHCTarC("CC",0,"Code",code,idc)) q:idc=""
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
	
			s idd=$o(^DHCTarC("CC",0,"Desc",desc,idd)) q:idd=""
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
