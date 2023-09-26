/// 名称:   会计费用大类 业务类
/// 编写者：基础数据平台组-sunfengchao
/// 编写日期: 2016-12-2
Class web.DHCBL.CT.DHCTarAC Extends %RegisteredObject [ ProcedureBlock ]
{

/// update2020-02-11
Parameter SQLTableName = "DHC_TarAC";

/// Function:查询会计费用大类
/// CreateDate:2016-12-2
/// Creator:基础数据平台 sunfengchao
/// Table:  DHC_TarAC
/// Input:  rowid, code, desc 
/// Output: TARTAC_RowId    TARTAC_Code TARTAC_Desc 
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCTarAC", "GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "TARTACRowId:%String,TARTACCode:%String,TARTACDesc:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
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
  s AuStr= ##class(web.DHCBL.Authorize.DHCTarAC).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  if (rowid'="")  
  {  
    s TARTACRowId=rowid
    s TARTACCode=$p($g(^DHCTarC("TAC",rowid)),"^",1)
    s TARTACDesc=$p($g(^DHCTarC("TAC",rowid)),"^",2)
   
    s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""
    s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("DHC_TarAC",TARTACRowId)
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
   s TARTACRowId=0
   for
   { 
    s TARTACRowId=$o(^DHCTarC("TAC",TARTACRowId)) 
    q:TARTACRowId=""    
    s strTARTACRowId="{ID:"_TARTACRowId_"}"
    if (AuStr[strTARTACRowId)||(AuFlag=1)
    {
	    
		 s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,TARTACRowId,hospid)
		continue:showflag="N"
      s TARTACCode=$p($g(^DHCTarC("TAC",TARTACRowId)),"^",1)
      s TARTACDesc=$p($g(^DHCTarC("TAC",TARTACRowId)),"^",2) 
      s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""
      s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("DHC_TarAC",TARTACRowId)
      s BDPInternalCode =$p($g(resultStr),"^",1)       
      s BDPInternalDesc = $p($g(resultStr),"^",2)  
      s BDPHospNationalCode=$p($g(resultStr),"^",3)         
      s BDPHospNationalDesc = $p($g(resultStr),"^",4)
      if (desc'="")
      {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("DHC_TarAC",TARTACRowId,TARTACDesc,desc)
      }
      else
      {
         s AliasFlag= 1   
      }   
      if ($ZCVT(TARTACCode,"U")[code)&(AliasFlag=1) 
      {
        d OutputRow
      }
    }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(TARTACRowId,TARTACCode,TARTACDesc,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc )
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

/// Function: 为combo提供查询会计费用大类的接口
/// CreateDate:2016-12-2
/// Creator:  基础数据平台sunfengchao
/// Tables:   DHC_TarAC
/// Input:    rowid code  desc
/// Output:   DLMTHRowId  DLMTH_Desc   
/// Others:   d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCTarAC","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "TARTACRowId:%String,TARTACDesc:%String ")
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
  s AuStr=  ##class(web.DHCBL.Authorize.DHCTarAC).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  if (rowid'="")  
  {  
    s TARTACRowId=rowid
    s TARTACCode=$p($g(^DHCTarc("TAC",rowid)),"^",1)
    s TARTACDesc=$p($g(^DHCTarC("TAC",rowid)),"^",2)
    d OutputRowCmb
  }
  else
 {
   s:code'="" code=$ZCVT(code,"U") 
   s:desc'="" desc=$ZCVT(desc,"U")  
   s TARTACRowId=0
   for
   { 
    s TARTACRowId=$o(^DHCTarC("TAC",TARTACRowId)) 
    q:TARTACRowId=""    
    s strTARTACRowId="{ID:"_TARTACRowId_"}"
    if (AuStr[strTARTACRowId)||(AuFlag=1)
    {
	    
		s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,TARTACRowId,hospid)
		continue:showflag="N"
      s TARTACDesc=$p($g(^DHCTarC("TAC",TARTACRowId)),"^",2)
      s TARTACCode=$p($g(^DHCTarc("TAC",TARTACRowId)),"^",1)
      if (desc'="")
      {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("DHC_TarAC",TARTACRowId,TARTACDesc,desc)
      }
      else
      {
         s AliasFlag= 1   
      }   
      if ($ZCVT(TARTACCode,"U")[code)&(AliasFlag=1) 
      {
        d OutputRowCmb
      }
    }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(TARTACRowId,TARTACDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function:   双击修改时的数据加载 
/// CreateDate: 2016-12-2
/// Creator:    基础数据平台 sunfengchao
/// Input:      id 
/// Others:     w ##class(web.DHCBL.CT.DHCTarAC).OpenData("2") 
ClassMethod OpenData(id As %String) As %String
{
 s str=""
 s pobj = ##class(User.DHCTarAC).%OpenId(id)
 s eobj = ##class(web.Entity.CT.DHCTarAC).%New()
 s eobj.TARTACRowId = id
 S eobj.TARTACCode=pobj.TARTACCode
 s eobj.TARTACDesc= pobj.TARTACDesc
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
   s TARACRowId=0,found1=0
   for
   { 
    s TARACRowId=$o(^DHCTarC("AC",TARACRowId)) 
    q:TARACRowId="" 
     s TARACTARTACDR=$p($g(^DHCTarC("AC",TARACRowId)),"^",3) 
    if TARACTARTACDR=id s found1=1
   }
   if (found1=1)  s myInfo=myInfo_"<会计费用子类>"
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
/// Tables:     DHC_TarAC
/// Others:     d ##class(web.DHCBL.CT.DHCTarAC).DeleteData("")
ClassMethod DeleteData(id As %String) As %String
{
   s result="",flag=""
   s re=##class(web.DHCBL.CT.DHCTarAC).GetRefFlag(id)
   s RefFlag=$p(re,"^",1)
   if (RefFlag=1)
   {
     s result="{success:'false',info:'"_$p(re,"^",2)_"'}"
   }
   else
   {  
     Tstart
     s pobj = ##class(User.DHCTarAC).%OpenId(id)
     s eobj = ##class(web.Entity.CT.DHCTarAC).%New()
     s eobj.TARTACRowId = id
     s eobj.TARTACCode=pobj.TARTACCode
     s eobj.TARTACDesc= pobj.TARTACDesc
     s sc=##class(User.DHCTarAC).%DeleteId(id)
     if $$$ISOK(sc)
     {
       Tc
       d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarAC","User.DHCTarAC","会计费用大类",id,eobj.TARTACDesc,"D",eobj)
       s result="{success:'true',info:'删除成功！'}"
       d eobj.%Close()
     }
    else
    {
       Trollback
       s result= "{success:'false',info:'删除失败！"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
       s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("会计费用大类","web.DHCBL.CT.DHCTarAC","DeleteData",eobj)
       s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
    } 
  }
   q result
}

/// Function:   实现对会计费用大类修改增加操作
/// Creator:    基础数据平台 sunfengchao
/// CreateDate: 2016-12-2
/// Output:     success:'true',info:'添加成功！' 失败时输出添加失败！
///             success:'false',info:'修改成功' 失败时输出修改失败！
/// Tables:     DHC_TarAC
ClassMethod SaveEntity(eobj As web.Entity.CT.DHCTarAC) As %String
{
  ;s $zt="ERROR"
  s result=""
  if $IsObject(eobj)
  {
	  s flag=..FormValidate(eobj.TARTACRowId,eobj.TARTACCode,eobj.TARTACDesc,eobj.LinkHospId)  //调用重复验证
	  if (flag=1)
	  {
		  s result = "{success:'false',errorinfo:'该记录已经存在！'}"
	  }
	  else
	  {
		  if (eobj.TARTACRowId="")  
		  {    
		    s obj=##class(User.DHCTarAC).%New() 
		  }   
		  else  
		  { 
		   s obj=##class(User.DHCTarAC).%OpenId(eobj.TARTACRowId)
		   s bobj=##class(web.Entity.CT.DHCTarAC).%New() 
		   s bobj.TARTACRowId=eobj.TARTACRowId
		   s bobj.TARTACCode = obj.TARTACCode                      
		   s bobj.TARTACDesc= obj.TARTACDesc                     
		  }
		   s obj.TARTACCode = eobj.TARTACCode                      
		   s obj.TARTACDesc= eobj.TARTACDesc                     
		   Tstart
		   s sc=obj.%Save()
		   if $$$ISOK(sc)
		   {
		      Tcommit
		      s id = obj.%Id()
		      s result = "{success:'true',id:'"_id_"'}"        
		      d:eobj.TARTACRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarAC","User.DHCTarAC","会计费用大类",eobj.TARTACRowId,eobj.TARTACDesc,"U",eobj,bobj)
		      d:eobj.TARTACRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarAC","User.DHCTarAC","会计费用大类",id,eobj.TARTACDesc,"A",eobj)
		   }
		   else
		   {
		       Trollback
		       s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
		       s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("会计费用大类","web.DHCBL.CT.DHCTarAC","SaveEntity",eobj)
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
 ;s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("会计费用大类","web.DHCBL.CT.DHCTarAC","SaveEntity",eobj)
 ;s ^ERRORLOGINFO(logid)=$ze
 ;q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Function:   进行数据重复校验功能，并返回一个标志位
/// Creator:    基础数据平台组 sunfengchao
/// CreateDate: 2016-12-2
/// Table:      DHC_TarAC
/// Debug:      w ##class(web.DHCBL.CT.DHCTarAC).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String, hospid As %String = "") As %String
{
	s flag=0
	if code'=""
	{
		s idc=0
		for
		{
			s idc=$o(^DHCTarC("TAC",0,"Code",code,idc)) q:idc=""
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
			s idd=$o(^DHCTarC("TAC",0,"Desc",desc,idd)) q:idd=""
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
