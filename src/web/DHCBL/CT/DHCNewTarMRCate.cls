/// Function: 新病案首页子类
/// Creator:  sunfengchao
/// CreateDate: 2016-12-7
Class web.DHCBL.CT.DHCNewTarMRCate Extends %RegisteredObject [ ProcedureBlock ]
{

/// update2020-02-11
Parameter SQLTableName = "DHC_TarMCCateNew";

Parameter ClassName = "User.DHCTarMCCateNew";

/// Function:查询新病案首页子类
/// CreateDate:2016-12-5
/// Creator:基础数据平台 sunfengchao
/// Input:  rowid, code, desc 
/// Output: NTARMCRowId   NTARMCCode NTARMCDesc NTARMCDR
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCNewTarMRCate", "GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String, taremcdr As %String, hospid As %String) As %Query(ROWSPEC = "NTARMCRowId:%String,NTARMCCode:%String,NTARMCDesc:%String,NTARMCDR:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
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
  s AuStr=##class(web.DHCBL.Authorize.DHCNewTarMRCate).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  if (rowid'="")  
  {  
    s NTARMCRowId=rowid
    s NTARMCCode=$p($g(^DHCTarC("MCNew",rowid)),"^",1)
    s NTARMCDesc=$p($g(^DHCTarC("MCNew",rowid)),"^",2)
    s NTARMCDR=$p($g(^DHCTarC("MCNew",rowid)),"^",3)
    s:NTARMCDR'="" NTARMCDR=$p($g(^DHCTarC("TMCNew",NTARMCDR)),"^",2)
    s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""
    s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("DHC_TarMCCateNew",NTARMCRowId)
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
   s NTARMCRowId=0
   for
   { 
    s NTARMCRowId=$o(^DHCTarC("MCNew",NTARMCRowId)) 
    q:NTARMCRowId=""    
    s strNTARMCRowId="{ID:"_NTARMCRowId_"}"
    if (AuStr[strNTARMCRowId)||(AuFlag=1)
    {
	  s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,NTARMCRowId,hospid)
	  continue:showflag="N"
	  
      s NTARMCCode=$p($g(^DHCTarC("MCNew",NTARMCRowId)),"^",1)
      s NTARMCDesc=$p($g(^DHCTarC("MCNew",NTARMCRowId)),"^",2) 
      s NTARMCDR=$p($g(^DHCTarC("MCNew",NTARMCRowId)),"^",3)
      s NTARMCDRRowId=NTARMCDR
      s:NTARMCDR'="" NTARMCDR=$p($g(^DHCTarC("TMCNew",NTARMCDR)),"^",2)
      s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""
      s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("DHC_TarMCCateNew",NTARMCRowId)
      s BDPInternalCode =$p($g(resultStr),"^",1)       
      s BDPInternalDesc = $p($g(resultStr),"^",2)  
      s BDPHospNationalCode=$p($g(resultStr),"^",3)         
      s BDPHospNationalDesc = $p($g(resultStr),"^",4)
      if (desc'="")
      {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("DHC_TarMCCateNew",NTARMCRowId,NTARMCDesc,desc)
      }
      else
      {
         s AliasFlag= 1   
      }     
      if (($ZCVT(NTARMCCode,"U")[code)&(AliasFlag=1)&((NTARMCDRRowId =taremcdr)||(taremcdr="")))
      {
        d OutputRow
      }
    }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(NTARMCRowId,NTARMCCode,NTARMCDesc,NTARMCDR,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc )
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

/// Function: 为combo提供查询新病案首页子类的接口
/// CreateDate:2016-12-2
/// Creator:  基础数据平台sunfengchao
/// Tables:   DHC_TarMCCateNew
/// Input:    rowid code  desc
/// Output:   DLMTHRowId  DLMTHDesc   
/// Others:   d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCNewTarMRCate","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "NTARMCRowId:%String,NTARMCCode,NTARMCDesc:%String ")
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
  s AuStr=##class(web.DHCBL.Authorize.DHCNewTarMRCate).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  if (rowid'="")  
  {  
    s NTARMCRowId=rowid
    s NTARMCCode=$p($g(^DHCTarC("MCNew",NTARMCRowId)),"^",1)
    s NTARMCDesc=$p($g(^DHCTarC("MCNew",rowid)),"^",2)
    d OutputRowCmb
  }
  else
 {
   s:code'="" code=$ZCVT(code,"U") 
   s:desc'="" desc=$ZCVT(desc,"U")  
   s NTARMCRowId=0
   for
   { 
    s NTARMCRowId=$o(^DHCTarC("MCNew",NTARMCRowId)) 
    q:NTARMCRowId=""    
    s strNTARMCRowId="{ID:"_NTARMCRowId_"}"
    if (AuStr[strNTARMCRowId)||(AuFlag=1)
    {
	  s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,NTARMCRowId,hospid)
	  continue:showflag="N"
	    
      s NTARMCCode=$p($g(^DHCTarC("MCNew",NTARMCRowId)),"^",1)
      s NTARMCDesc=$p($g(^DHCTarC("MCNew",NTARMCRowId)),"^",2)
      if (desc'="")
      {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("DHC_TarMCCateNew",NTARMCRowId,NTARMCDesc,desc)
      }
      else
      {
         s AliasFlag= 1   
      }     
      if (AliasFlag= 1)  
      {
        d OutputRowCmb
      }
    }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(NTARMCRowId,NTARMCCode,NTARMCDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function:   双击修改时的数据加载 
/// CreateDate: 2016-12-2
/// Creator:    基础数据平台 sunfengchao
/// Input:      id 
/// Others:     w ##class(web.DHCBL.CT.DHCNewTarMRCate).OpenData("2") 
ClassMethod OpenData(id As %String) As %String
{
 s str=""
 s pobj = ##class(User.DHCTarMCCateNew).%OpenId(id)
 s eobj = ##class(web.Entity.CT.DHCNewTarMRCate).%New()
 s eobj.NTARMCRowId = id
 S eobj.NTARMCCode=pobj.TARMCCNewCode //$p($g(^DHCTarC("MCNew",id)),"^",1) 
 s eobj.NTARMCDesc=pobj.TARMCCNewDesc //$p($g(^DHCTarC("MCNew",id)),"^",2)
 if $IsObject(pobj.TARMCCNewTARTMCDR) {
	 s eobj.NTARMCDR=pobj.TARMCCNewTARTMCDR.%Id() //$p($g(^DHCTarC("MCNew",id)),"^",3)
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
/// Debug:      w ##class(web.DHCBL.CT.DHCNewTarMRCate).GetRefFlag(2)
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="", myInfo=""
    s found1=0,TARIRowId=0
    for
    {
       s TARIRowId=$o(^DHCTARI(TARIRowId)) q:((TARIRowId="")||(found1=1))
       s SubCate=$p($g(^DHCTARI(TARIRowId)),"^",30) ///新病案首页子类
       if (SubCate=id) 
       {
           s found1=1
           s myInfo=myInfo_"<收费项目>"
           q 
       }
       else 
       {
            continue
       }
    }
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
/// Tables:     DHC_TarMCCateNew
/// Others:     d ##class(web.DHCBL.CT.DHCNewTarMRCate).DeleteData(6)
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
	     s eobj = ##class(web.Entity.CT.DHCNewTarMRCate).%New()
	     s pobj = ##class(User.DHCTarMCCateNew).%OpenId(id)
	     s eobj.NTARMCRowId = id
	     s eobj.NTARMCCode=pobj.TARMCCNewCode //$p($g(^DHCTarC("MCNew",id)),"^",1) 
	     s eobj.NTARMCDesc=pobj.TARMCCNewDesc //$p($g(^DHCTarC("MCNew",id)),"^",2)
	     if $IsObject(pobj.TARMCCNewTARTMCDR) {
			s eobj.NTARMCDR=pobj.TARMCCNewTARTMCDR.%Id() //$p($g(^DHCTarC("MCNew",id)),"^",3)
		}
	     Ts
	     s sc=##class(User.DHCTarMCCateNew).%DeleteId(id)
	     if $$$ISOK(sc)
	     {
	     	 Tc
	         d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarMCCateNew","User.DHCTarMCCateNew","新病案首页子类",id,eobj.NTARMCDesc,"D",eobj)
	         s result="{success:'true',info:'删除成功！'}"
	         d eobj.%Close()
	     }
	     else
         {
             Trollback
             s result= "{success:'false',info:'删除失败！"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
             s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("新病案首页子类","web.DHCBL.CT.DHCNewTarMRCate","DeleteData",eobj)
             s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
         } 
     }
     q result
}

/// Function:   实现对新病案首页子类修改增加操作
/// Creator:    基础数据平台 sunfengchao
/// CreateDate: 2016-12-2
/// Output:     success:'true',info:'添加成功！' 失败时输出添加失败！
///             success:'false',info:'修改成功' 失败时输出修改失败！
/// Tables:     DHC_TarMCCateNew
ClassMethod SaveEntity(eobj As web.Entity.CT.DHCNewTarMRCate) As %String
{
	s result=""
    s flag= ..FormValidate(eobj.NTARMCRowId,eobj.NTARMCCode,eobj.NTARMCDesc,eobj.LinkHospId)   
    if (flag=1)
    {
       s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {   

		if (eobj.NTARMCRowId="")
		{
			s obj=##class(User.DHCTarMCCateNew).%New() 
		}
		else
		{
			s obj=##class(User.DHCTarMCCateNew).%OpenId(eobj.NTARMCRowId)
			s bobj=##class(web.Entity.CT.DHCNewTarMRCate).%New() 
			s bobj.NTARMCRowId=eobj.NTARMCRowId
			s bobj.NTARMCCode = obj.TARMCCNewCode                      
			s bobj.NTARMCDesc = obj.TARMCCNewDesc
			if $IsObject(obj.TARMCCNewTARTMCDR)
			{
				s bobj.NTARMCDR=obj.TARMCCNewTARTMCDR.%Id()
			}
		}
		s obj.TARMCCNewCode = eobj.NTARMCCode                      
		s obj.TARMCCNewDesc= eobj.NTARMCDesc        
		d obj.TARMCCNewTARTMCDRSetObjectId(eobj.NTARMCDR)             
		Tstart
		s sc=obj.%Save()
		if $$$ISOK(sc)
		{
			Tcommit
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"        
			d:eobj.NTARMCRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarMCCateNew","User.DHCTarMCCateNew","新病案首页子类",eobj.NTARMCRowId,eobj.NTARMCDesc,"U",eobj,bobj)
			d:eobj.NTARMCRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarMCCateNew","User.DHCTarMCCateNew","新病案首页子类",id,eobj.NTARMCDesc,"A",eobj)
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("新病案首页子类","web.DHCBL.CT.DHCNewTarMRCate","SaveEntity",eobj)
		} 
    }
	q result
}

/// Function:   进行数据重复校验功能，并返回一个标志位
/// Creator:    基础数据平台组 sunfengchao
/// CreateDate: 2016-12-2
/// Table:      DHC_TarMCCateNew
/// Debug:      w ##class(web.DHCBL.CT.DHCNewTarMRCate).FormValidate("","其他费","其他费")
ClassMethod FormValidate(id As %String, code As %String, desc As %String, hospid As %String = "") As %String
{
	s flag=0
    if code'=""
    { 
        s idc=0
        for
        {
            s idc=$o(^DHCTARMRCATENEW(0,"Code",code,idc)) q:idc=""  
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
            s idd=$o(^DHCTARMRCATENEW(0,"Desc",desc,idd)) q:idd=""
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
