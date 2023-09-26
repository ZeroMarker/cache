/// 名称:   新病案首页大类 业务类
/// 编写者：基础数据平台组-sunfengchao
/// 编写日期: 2016-12-4
Class web.DHCBL.CT.DHCNewTarMC Extends %RegisteredObject [ ProcedureBlock ]
{

/// update2020-02-11
Parameter SQLTableName = "DHC_TarMCNew";

Parameter ClassName = "User.DHCTarMCNew";

/// Function:查询新病案首页大类
/// CreateDate:2016-12-5
/// Creator:基础数据平台 sunfengchao
/// Table: DHC_TarMCNew
/// Input:  rowid, code, desc 
/// Output: NTARTMC_RowId   NTARTMC_Code NTARTMC_Desc
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCNewTarMC", "GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "NTARTMCRowId:%String,NTARTMCCode:%String,NTARTMCDesc:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
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
  s AuStr= ##class(web.DHCBL.Authorize.DHCNewTarMC).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  if (rowid'="")  
  {  
    s NTARTMCRowId=rowid
    s NTARTMCCode=$p($g(^DHCTarC("TMCNew",rowid)),"^",1)
    s NTARTMCDesc=$p($g(^DHCTarC("TMCNew",rowid)),"^",2)
   
    s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""
    s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("DHC_TarMCNew",NTARTMCRowId)
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
   s NTARTMCRowId=0
   for
   { 
    s NTARTMCRowId=$o(^DHCTarC("TMCNew",NTARTMCRowId)) 
    q:NTARTMCRowId=""    
    s strNTARTMCRowId="{ID:"_NTARTMCRowId_"}"
    if (AuStr[strNTARTMCRowId)||(AuFlag=1)
    {
	  s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,NTARTMCRowId,hospid)
	  continue:showflag="N"
	  
      s NTARTMCCode=$p($g(^DHCTarC("TMCNew",NTARTMCRowId)),"^",1)
      s NTARTMCDesc=$p($g(^DHCTarC("TMCNew",NTARTMCRowId)),"^",2) 
      s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""
      s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("DHC_TarMCNew",NTARTMCRowId)
      s BDPInternalCode =$p($g(resultStr),"^",1)       
      s BDPInternalDesc = $p($g(resultStr),"^",2)  
      s BDPHospNationalCode=$p($g(resultStr),"^",3)         
      s BDPHospNationalDesc = $p($g(resultStr),"^",4)
      if (desc'="")
      {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("DHC_TarMCNew",NTARTMCRowId,NTARTMCDesc,desc)
      }
      else
      {
         s AliasFlag= 1   
      }    
      if (($zcvt(NTARTMCCode,"U")[code)||(code=""))&(AliasFlag=1) 
      {
        d OutputRow
      }
    }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(NTARTMCRowId,NTARTMCCode,NTARTMCDesc,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc )
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

/// Function: 为combo提供查询新病案首页大类的接口
/// CreateDate:2016-12-2
/// Creator:  基础数据平台sunfengchao
/// Tables:   DHC_TarMCNew
/// Input:    rowid code  desc
/// Output:   NTARTMCRowId NTARTMCCode  NTARTMCDesc   
/// Others:   d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCNewTarMC","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "NTARTMCRowId:%String,NTARTMCDesc:%String ")
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
  s AuStr= ##class(web.DHCBL.Authorize.DHCNewTarMC).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  if (rowid'="")  
  {  
    s NTARTMCRowId=rowid
    s NTARTMCDesc=$p($g(^DHCTarC("TMCNew",rowid)),"^",2)
    d OutputRowCmb
  }
  else
 {
   s:code'="" code=$ZCVT(code,"U") 
   s:desc'="" desc=$ZCVT(desc,"U")  
   s NTARTMCRowId=0
   for
   { 
    s NTARTMCRowId=$o(^DHCTarC("TMCNew",NTARTMCRowId)) 
    q:NTARTMCRowId=""    
    s strNTARTMCRowId="{ID:"_NTARTMCRowId_"}"
    if (AuStr[strNTARTMCRowId)||(AuFlag=1)
    {
	  s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,NTARTMCRowId,hospid)
	  continue:showflag="N"
	    
	  s NTARTMCCode=$p($g(^DHCTarC("TMCNew",NTARTMCRowId)),"^",1)  
      s NTARTMCDesc=$p($g(^DHCTarC("TMCNew",NTARTMCRowId)),"^",2)
      if (desc'="")
      {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("DHC_TarMCNew",NTARTMCRowId,NTARTMCDesc,desc)
      }
      else
      {
         s AliasFlag= 1   
      }    
      if (($zcvt(NTARTMCCode,"U")[code)||(code=""))&(AliasFlag=1)    
      {
        d OutputRowCmb
      }
    }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(NTARTMCRowId,NTARTMCDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function:   双击修改时的数据加载 
/// CreateDate: 2016-12-2
/// Creator:    基础数据平台 sunfengchao
/// Input:      id 
/// Others:     w ##class(web.DHCBL.CT.DHCNewTarMC).OpenData("2") 
ClassMethod OpenData(id As %String) As %String
{
 s str=""
 s pobj = ##class(User.DHCTarMCNew).%OpenId(id)
 s eobj = ##class(web.Entity.CT.DHCNewTarMC).%New()
 s eobj.NTARTMCRowId = id
 S eobj.NTARTMCCode= pobj.TARTMCNewCode //$p($g(^DHCTarC("TMCNew",id)),"^",1) 
 s eobj.NTARTMCDesc= pobj.TARTMCNewDesc //$p($g(^DHCTarC("TMCNew",id)),"^",2)
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
   s NTARMCRowId=0
   for
   { 
    s NTARMCRowId=$o(^DHCTarC("MCNew",NTARMCRowId)) 
    q:NTARMCRowId=""      
    s NTARMCDR=$p($g(^DHCTarC("MCNew",NTARMCRowId)),"^",3)
    if NTARMCDR=id s found1=1
   }
   if (found1=1)  s myInfo=myInfo_"<新病案首页子类>"
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
/// Tables:     DHC_TarMCNew
/// Others:     d ##class(web.DHCBL.CT.DHCNewTarMC).DeleteData(6)
ClassMethod DeleteData(id As %String) As %String
{
   s result="",flag=""
   s re=##class(web.DHCBL.CT.DHCNewTarMC).GetRefFlag(id)
   s RefFlag=$p(re,"^",1)
   if (RefFlag=1)
   {
     s result="{success:'false',info:'"_$p(re,"^",2)_"'}"
   }
   else
   { 
     s pobj = ##class(User.DHCTarMCNew).%OpenId(id)
     s eobj = ##class(web.Entity.CT.DHCNewTarMC).%New()
     s eobj.NTARTMCRowId = id
     s eobj.NTARTMCCode=pobj.TARTMCNewCode //$p($g(^DHCTarC("TMCNew",id)),"^",1) 
     s eobj.NTARTMCDesc=pobj.TARTMCNewDesc //$p($g(^DHCTarC("TMCNew",id)),"^",2)
     Tstart
     s sc=##class(User.DHCTarMCNew).%DeleteId(id) //k ^DHCTarC("TMCNew",id)
     if $$$ISOK(sc)
     {
       Tc
       d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarMCNew","User.DHCTarMCNew","新病案首页大类",id,eobj.NTARTMCDesc,"D",eobj)
       s result="{success:'true',info:'删除成功！'}"
       d eobj.%Close()
     }
    else
    {
       Trollback
       s result= "{success:'false',info:'删除失败！"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
       s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("新病案首页大类","web.DHCBL.CT.DHCNewTarMC","DeleteData",eobj)
       s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
    } 
   }
     q result
}

/// Function:   实现对新病案首页大类修改增加操作
/// Creator:    基础数据平台 sunfengchao
/// CreateDate: 2016-12-2
/// Output:     success:'true',info:'添加成功！' 失败时输出添加失败！
///             success:'false',info:'修改成功' 失败时输出修改失败！
/// Tables:     DHC_TarMCNew
ClassMethod SaveEntity(eobj As web.Entity.CT.DHCNewTarMC) As %String
{
	s result=""
	s flag= ..FormValidate(eobj.NTARTMCRowId,eobj.NTARTMCCode,eobj.NTARTMCDesc,eobj.LinkHospId)   
	if (flag=1)
	{
		s result = "{success:'false',errorinfo:'该记录已经存在！'}"
	}
	else
	{
		if (eobj.NTARTMCRowId="")
		{
			s obj=##class(User.DHCTarMCNew).%New() 
		}
		else
		{
			s obj=##class(User.DHCTarMCNew).%OpenId(eobj.NTARTMCRowId)
			s bobj=##class(web.Entity.CT.DHCNewTarMC).%New() 
			s bobj.NTARTMCRowId = eobj.NTARTMCRowId
			s bobj.NTARTMCCode = obj.TARTMCNewCode
			s bobj.NTARTMCDesc = obj.TARTMCNewDesc
		}
		s obj.TARTMCNewCode = eobj.NTARTMCCode                      
		s obj.TARTMCNewDesc = eobj.NTARTMCDesc                     
		Tstart
		s sc=obj.%Save()
		if $$$ISOK(sc)
		{
			Tcommit
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"        
			d:eobj.NTARTMCRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarMCNew","User.DHCTarMCNew","新病案首页大类",eobj.NTARTMCRowId,eobj.NTARTMCDesc,"U",eobj,bobj)
			d:eobj.NTARTMCRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarMCNew","User.DHCTarMCNew","新病案首页大类",id,eobj.NTARTMCDesc,"A",eobj)
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("新病案首页大类","web.DHCBL.CT.DHCNewTarMC","SaveEntity",eobj)
		} 
	}
	q result
	
	/*
  s $zt="ERROR"
  s result=""
  if (eobj.NTARTMCRowId="")  
  {    
    Set RowID=$o(^DHCTarC("TMCNew",""),-1)
    Set RowID=(+$g(RowID))+1
    Set ^DHCTarC("TMCNew",RowID)=eobj.NTARTMCCode_"^"_eobj.NTARTMCDesc
    Set ^DHCTARMCNEW(0,"Code",eobj.NTARTMCCode,RowID)=""
    Set ^DHCTARMCNEW(0,"Desc",eobj.NTARTMCDesc,RowID)=""
    s result = "{success:'true',id:'"_RowID_"'}"   
    d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("^DHCTarC(""TMCNew"")","^DHCTarC(""TMCNew"")","新病案首页大类",RowID,eobj.NTARTMCDesc,"A",eobj)
    
  }   
  else  
  { 
   s bobj=##class(web.Entity.CT.DHCNewTarMC).%New() 
   s bobj.NTARTMCRowId=eobj.NTARTMCRowId
   s bobj.NTARTMCCode= $p($g(^DHCTarC("TMCNew",eobj.NTARTMCRowId)),"^",1) 
   s bobj.NTARTMCDesc= $p($g(^DHCTarC("TMCNew",eobj.NTARTMCRowId)),"^",2)  
   k ^DHCTARMCNEW(0,"Code",bobj.NTARTMCCode,eobj.NTARTMCRowId)
   k ^DHCTARMCNEW(0,"Desc",bobj.NTARTMCDesc,eobj.NTARTMCRowId)  
   Set ^DHCTarC("TMCNew",eobj.NTARTMCRowId)=eobj.NTARTMCCode_"^"_eobj.NTARTMCDesc
   Set ^DHCTARMCNEW(0,"Code",eobj.NTARTMCCode,eobj.NTARTMCRowId)=""
   Set ^DHCTARMCNEW(0,"Desc",eobj.NTARTMCDesc,eobj.NTARTMCRowId)=""
   d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("^DHCTarC(""TMCNew"")","^DHCTarC(""TMCNew"")","新病案首页大类",eobj.NTARTMCRowId,eobj.NTARTMCDesc,"U",eobj,bobj)              
   s result = "{success:'true',id:'"_eobj.NTARTMCRowId_"'}"
  } 
  q result
ERROR
 s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("新病案首页大类","web.DHCBL.CT.DHCNewTarMC","SaveEntity",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
 */
}

/// Function:   进行数据重复校验功能，并返回一个标志位
/// Creator:    基础数据平台组 sunfengchao
/// CreateDate: 2016-12-2
/// Table:      DHC_TarMCNew
/// Debug:      w ##class(web.DHCBL.CT.DHCNewTarMC).FormValidate("4","其他费","其他费")
ClassMethod FormValidate(id As %String, code As %String, desc As %String, hospid As %String = "") As %String
{
	s flag=0
    if code'=""
    { 
        s idc=0
        for
        {
            s idc=$o(^DHCTARMCNEW(0,"Code",code,idc)) q:idc=""  
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
            s idd=$o(^DHCTARMCNEW(0,"Desc",desc,idd)) q:idd=""
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
