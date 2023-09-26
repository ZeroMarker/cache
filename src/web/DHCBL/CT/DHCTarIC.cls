/// Function: 计费-住院费用大类 业务类
/// Creator:  sunfengchao
/// CreateDate:2016-12-2
Class web.DHCBL.CT.DHCTarIC Extends %RegisteredObject [ ProcedureBlock ]
{

Parameter SQLTableName = "DHC_TarIC";

/// Function:查询住院费用大类 
/// CreateDate:2016-12-2
/// Creator:基础数据平台 sunfengchao
/// Table:  DHC_TarIC
/// Input:  rowid, code, desc 
/// Output: TARTIC_RowId   TARTIC_Code TARTIC_Desc
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCTarIC", "GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "TARTICRowId:%String,TARTICCode:%String,TARTICDesc:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
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
  s AuStr= ##class(web.DHCBL.Authorize.DHCTarIC).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  if (rowid'="")  
  {  
    s TARTICRowId=rowid
    s TARTICCode=$p($g(^DHCTarC("TIC",rowid)),"^",1)
    s TARTICDesc=$p($g(^DHCTarC("TIC",rowid)),"^",2)
   
    s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""
    s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("DHC_TarIC",TARTICRowId)
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
   s TARTICRowId=0
   for
   { 
    s TARTICRowId=$o(^DHCTarC("TIC",TARTICRowId)) 
    q:TARTICRowId=""    
    s strTARTICRowId="{ID:"_TARTICRowId_"}"
    if (AuStr[strTARTICRowId)||(AuFlag=1)
    {
	  s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,TARTICRowId,hospid)
		continue:showflag="N"
	  
      s TARTICCode=$p($g(^DHCTarC("TIC",TARTICRowId)),"^",1)
      s TARTICDesc=$p($g(^DHCTarC("TIC",TARTICRowId)),"^",2)
      s AliasRowId=0,ALIASText1=""
      for
      {
         s AliasRowId=$o(^User.BDPAliasI("DataRef","DHC_TarIC",TARTICRowId,AliasRowId))
         q:AliasRowId=""
         S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
         ; 查询出对应rowid下的所有别名，用"^"进行连接
         s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
      }
      s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(TARTICDesc)  
     
      s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""
      s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("DHC_TarIC",TARTICRowId)
      s BDPInternalCode =$p($g(resultStr),"^",1)       
      s BDPInternalDesc = $p($g(resultStr),"^",2)  
      s BDPHospNationalCode=$p($g(resultStr),"^",3)         
      s BDPHospNationalDesc = $p($g(resultStr),"^",4)
      if (($ZCVT(TARTICCode,"U")[code))&(($ZCVT(TARTICDesc,"U")[desc)||(ALIASText1[desc)||(PINYINCODE[desc))  
      {
        d OutputRow
      }
    }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(TARTICRowId,TARTICCode,TARTICDesc,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc )
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

/// Function:  为combo提供查询住院费用大类的接口
/// CreateDate:2016-12-2
/// Creator:   基础数据平台sunfnegchao
/// Tables:    DHC_TarIC
/// Input:     code desc
/// Output:    TARTIC_RowId  TARTIC_Desc
/// Others:    d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCTarIC","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "TARTICRowId:%String, TARTICCode:%String,TARTICDesc:%String ")
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
  s AuStr= ##class(web.DHCBL.Authorize.DHCTarIC).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  if (rowid'="")  
  {  
    s TARTICRowId=rowid
    s TARTICCode=$p($g(^DHCTarC("TIC",rowid)),"^",1)
    s TARTICDesc=$p($g(^DHCTarC("TIC",rowid)),"^",2)
    d OutputRowCmb
  }
  else
 {
   s:code'="" code=$ZCVT(code,"U") 
   s:desc'="" desc=$ZCVT(desc,"U")  
   s TARTICRowId=0
   for
   { 
    s TARTICRowId=$o(^DHCTarC("TIC",TARTICRowId)) 
    q:TARTICRowId=""    
    s strTARTICRowId="{ID:"_TARTICRowId_"}"
    if (AuStr[strTARTICRowId)||(AuFlag=1)
    {
	  s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,TARTICRowId,hospid)
		continue:showflag="N"
				
      s TARTICCode=$p($g(^DHCTarC("TIC",TARTICRowId)),"^",1)
      s TARTICDesc=$p($g(^DHCTarC("TIC",TARTICRowId)),"^",2)
      s AliasRowId=0,ALIASText1=""
      for
      {
         s AliasRowId=$o(^User.BDPAliasI("DataRef","DHC_TarIC",TARTICRowId,AliasRowId))
         q:AliasRowId=""
         S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
         ; 查询出对应rowid下的所有别名，用"^"进行连接
         s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
      }
      s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(TARTICDesc)  
      if (($ZCVT(TARTICCode,"U")[code))&(($ZCVT(TARTICDesc,"U")[desc)||(ALIASText1[desc)||(PINYINCODE[desc))  
      {
        d OutputRowCmb
      }
    }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(TARTICRowId,TARTICCode,TARTICDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function:   双击修改时的数据加载 
/// CreateDate: 2016-12-2
/// Creator:    基础数据平台 sunfengchao
/// Input:      id 
/// Others:     w ##class(web.DHCBL.CT.DHCTarIC).OpenData("2") 
ClassMethod OpenData(id As %String) As %String
{
 s str=""
 s pobj = ##class(User.DHCTarIC).%OpenId(id)
 s eobj = ##class(web.Entity.CT.DHCTarIC).%New()
 s eobj.TARTICRowId = id
 S eobj.TARTICCode=pobj.TARTICCode
 s eobj.TARTICDesc= pobj.TARTICDesc
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Function:   删除时的逻辑判断 
/// Creator:    基础数据平台组 sunfengchao
/// CreateDate: 2016-11-8
/// Debug:      w ##class(web.DHCBL.CT.DHCTarIC).GetRefFlag("1")
ClassMethod GetRefFlag(id As %String) As %String
{
   s return="", myInfo=""
   s TARICRowId=0,found1=0
   for
   { 
    s TARICRowId=$o(^DHCTarC("IC",TARICRowId)) 
    q:TARICRowId=""    
    s TARICTARTICDR=$p($g(^DHCTarC("IC",TARICRowId)),"^",3) 
    if TARICTARTICDR=id s found1=1
   }
   if (found1=1)  s myInfo=myInfo_"<住院费用子类>"
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
/// Tables:     DHC_TarIC
/// Others:     d ##class(web.DHCBL.CT.DHCTarIC).DeleteData("")
ClassMethod DeleteData(id As %String) As %String
{
   s result="",flag=""
   s re=##class(web.DHCBL.CT.DHCTarIC).GetRefFlag(id)
   s RefFlag=$p(re,"^",1)
   if (RefFlag=1)
   {
     s result="{success:'false',info:'"_$p(re,"^",2)_"'}"
   }
   else
   {   
     Tstart
     s pobj = ##class(User.DHCTarIC).%OpenId(id)
     s eobj = ##class(web.Entity.CT.DHCTarIC).%New()
     s eobj.TARTICRowId = id
     s eobj.TARTICCode=pobj.TARTICCode
     s eobj.TARTICDesc= pobj.TARTICDesc
     s sc=##class(User.DHCTarIC).%DeleteId(id)
     if $$$ISOK(sc)
     {
       Tc
       d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarIC","User.DHCTarIC","住院费用大类",id,eobj.TARTICDesc,"D",eobj)
       s result="{success:'true',info:'删除成功！'}"
       d eobj.%Close()
     }
    else
    {
       Trollback
       s result= "{success:'false',info:'删除失败！"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
       s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("住院费用大类","web.DHCBL.CT.DHCTarIC","DeleteData",eobj)
       s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
    } 
   }
   q result
}

/// Function:   实现对住院费用大类修改增加操作
/// Creator:    基础数据平台 sunfengchao
/// CreateDate: 2016-12-2
/// Output:     success:'true',info:'添加成功！' 失败时输出添加失败！
///             success:'false',info:'修改成功' 失败时输出修改失败！
/// Tables:     DHC_TarIC
ClassMethod SaveEntity(eobj As web.Entity.CT.DHCTarIC) As %String
{
  ;s $zt="ERROR"
  s result=""
  if $IsObject(eobj)
  {
	  s flag=..FormValidate(eobj.TARTICRowId,eobj.TARTICCode,eobj.TARTICDesc,eobj.LinkHospId)  //调用重复验证
	  if (flag=1)
	  {
		  s result = "{success:'false',errorinfo:'该记录已经存在！'}"
	  }
	  else
	  {
		  if (eobj.TARTICRowId="")  
		  {    
		    s obj=##class(User.DHCTarIC).%New() 
		  }   
		  else  
		  { 
		   s obj=##class(User.DHCTarIC).%OpenId(eobj.TARTICRowId)
		   s bobj=##class(web.Entity.CT.DHCTarIC).%New() 
		   s bobj.TARTICRowId=eobj.TARTICRowId
		   s bobj.TARTICCode = obj.TARTICCode                      
		   s bobj.TARTICDesc= obj.TARTICDesc                        
		  }
		   s obj.TARTICCode = eobj.TARTICCode                      
		   s obj.TARTICDesc= eobj.TARTICDesc                     
		   
		   Tstart
		   s sc=obj.%Save()
		   if $$$ISOK(sc)
		   {
		       Tcommit
		       s id = obj.%Id()
		       s result = "{success:'true',id:'"_id_"'}"        
		       d:eobj.TARTICRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarIC","User.DHCTarIC","住院费用大类",eobj.TARTICRowId,eobj.TARTICDesc,"U",eobj,bobj)
		       d:eobj.TARTICRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarIC","User.DHCTarIC","住院费用大类",id,eobj.TARTICDesc,"A",eobj)
		   }
		   else
		   {
		       Trollback
		       s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
		       s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("住院费用大类","web.DHCBL.CT.DHCTarIC","SaveEntity",eobj)
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
 ;s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("住院费用大类","web.DHCBL.CT.DHCTarIC","SaveEntity",eobj)
 ;s ^ERRORLOGINFO(logid)=$ze
 ;q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Function:   进行数据重复校验功能，并返回一个标志位
/// Creator:    基础数据平台组 sunfengchao
/// CreateDate: 2016-12-2
/// Table:      DHC_TarIC
/// Debug:      w ##class(web.DHCBL.CT.DHCTarIC).FormValidate("","测试","测试","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String, hospid As %String = "") As %String
{
	s flag=0
	if code'=""
	{
		s idc=0
		for
		{
			s idc=$o(^DHCTarC("TIC",0,"Code",code,idc)) q:idc=""
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
	
			s idd=$o(^DHCTarC("TIC",0,"Desc",desc,idd)) q:idd=""
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
