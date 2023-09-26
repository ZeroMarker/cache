/// Function: 入院病情维护
/// Creator:  sunfengchao
/// CreateDate: 2016-1-13
Class web.DHCBL.CT.PACReferralPriority Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Function:查询入院病情
/// Creator:sunfengchao
/// CreatDate:2016-1-13
/// Input:rowid,code,desc
/// Output: REFPRI_RowId REFPRI_Code REFPRI_Desc REFPRI_NationalCode REFPRI_IconName REFPRI_IconPriority REFPRI_MaxDaysWaitAppt  REFPRI_AdmissionType  REFPRI_DateFrom REFPRI_DateTo
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACReferralPriority","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "REFPRIRowId,REFPRICode,REFPRIDesc,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
  s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
  s ind=1
  
  if (rowid'="")
  {  
    s REFPRIRowId=rowid
    s REFPRICode=$p($g(^PAC("REFPRI",REFPRIRowId)),"^",1)
    s REFPRIDesc=$p($g(^PAC("REFPRI",REFPRIRowId)),"^",2)
    s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
    s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_ReferralPriority",REFPRIRowId)
    s BDPInternalCode =$p($g(resultStr),"^",1)       
    s BDPInternalDesc = $p($g(resultStr),"^",2)  
    s BDPHospNationalCode=$p($g(resultStr),"^",3)         
    s BDPHospNationalDesc = $p($g(resultStr),"^",4)
    d OutputRow
  }
  else
  {
    s:code'="" code=$ZCONVERT(code,"U")
    s:desc'="" desc=$ZCONVERT(desc,"U") 
    s AuStr=##class(web.DHCBL.Authorize.PACReferralPriority).DHCGetDataByDefaultSession()
    s AuFlag=0
    ;未授权情况下，默认显示全部数据
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1
    s REFPRIRowId=0
    for
    {
      s REFPRIRowId=$o(^PAC("REFPRI",REFPRIRowId)) 
      q:REFPRIRowId=""  
      s strRowId="{ID:"_REFPRIRowId_"}"
    
      if ((AuStr[strRowId)||(AuFlag=1)) 
      {
          s REFPRICode=$p($g(^PAC("REFPRI",REFPRIRowId)),"^",1)
          s REFPRIDesc=$p($g(^PAC("REFPRI",REFPRIRowId)),"^",2)   
          s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
          s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_ReferralPriority",REFPRIRowId)
          s BDPInternalCode =$p($g(resultStr),"^",1)       
          s BDPInternalDesc = $p($g(resultStr),"^",2)  
          s BDPHospNationalCode=$p($g(resultStr),"^",3)         
          s BDPHospNationalDesc = $p($g(resultStr),"^",4)
          if (desc'="")
          {
           ;需要对描述或者别名进行检索      
           s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_ReferralPriority",REFPRIRowId,REFPRIDesc,desc)
          }
          else
          {
           s AliasFlag=1   
          } 
          if ($ZCVT(REFPRICode,"U")[code)&(AliasFlag=1) 
          {
            d OutputRow
          }
      }
    }
  }
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
OutputRow
    set Data=$lb(REFPRIRowId,REFPRICode,REFPRIDesc,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
  Set AtEnd=$LIST(qHandle,1)
  Set repid=$LIST(qHandle,2)
  Set ind=$LIST(qHandle,3)
  
  Set ind=$o(^CacheTemp(repid,ind))
  If ind=""
  {
    //if there are no more rows,finish fetching
    Set AtEnd=1
    Set Row=""
  }
  Else
  {
    Set Row=^CacheTemp(repid,ind)
  }
  s qHandle=$lb(AtEnd,repid,ind)
  Quit $$$OK
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
  Set repid=$LIST(qHandle,2)
  Kill ^CacheTemp(repid)
  Quit $$$OK
}

/// Creator: 
/// CreatDate: 
/// Description:为combobox查询取数据
/// Input:code,desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACReferralPriority","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "REFPRIRowId:%String,REFPRICode:%String,REFPRIDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
  s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
  s ind=1
  if (rowid'="")
  {  
    s REFPRIRowId=rowid
    s REFPRICode=$p($g(^PAC("REFPRI",REFPRIRowId)),"^",1)
    s REFPRIDesc=$p($g(^PAC("REFPRI",REFPRIRowId)),"^",2)
    d OutputRow
  }
  else
  {
    s:code'="" code=$ZCONVERT(code,"U")
    s:desc'="" desc=$ZCONVERT(desc,"U") 
    s AuStr=##class(web.DHCBL.Authorize.PACReferralPriority).DHCGetDataByDefaultSession()
    s AuFlag=0
    ;未授权情况下，默认显示全部数据
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1
    s REFPRIRowId=0
    for
    {
      s REFPRIRowId=$o(^PAC("REFPRI",REFPRIRowId)) 
      q:REFPRIRowId=""  
      s strRowId="{ID:"_REFPRIRowId_"}"
    
      if ((AuStr[strRowId)||(AuFlag=1)) 
      {
        s REFPRICode=$p($g(^PAC("REFPRI",REFPRIRowId)),"^",1)
        s REFPRIDesc=$p($g(^PAC("REFPRI",REFPRIRowId)),"^",2)
        if (desc'="")
        {
           ;需要对描述或者别名进行检索      
           s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_ReferralPriority",REFPRIRowId,REFPRIDesc,desc)
        }
        else
        {
           s AliasFlag=1   
        } 
        if ($ZCVT(REFPRICode,"U")[code)&(AliasFlag=1)
        {
          d OutputRow
        }
      }
    }
  }
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
OutputRowCmb
    set Data=$lb(REFPRIRowId,REFPRICode,REFPRIDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
  Set AtEnd=$LIST(qHandle,1)
  Set repid=$LIST(qHandle,2)
  Set ind=$LIST(qHandle,3)
  
  Set ind=$o(^CacheTemp(repid,ind))
  If ind=""
  {
    //if there are no more rows,finish fetching
    Set AtEnd=1
    Set Row=""
  }
  Else
  {
    Set Row=^CacheTemp(repid,ind)
  }
  s qHandle=$lb(AtEnd,repid,ind)
  Quit $$$OK
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
  Set repid=$LIST(qHandle,2)
  Kill ^CacheTemp(repid)
  Quit $$$OK
}

/// Function:数据重复验证方法,js调用
/// Creator: sunfengchao 
/// CreatDate: 2016-1-12
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.PACReferralPriority).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
  s flag="", flagc="",flagd=""
  s:code'="" code=$$ALPHAUP^SSUTIL4(code)  
  s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc)  
  s:code'="" flagc=$d(^PAC("REFPRI",0,"Code",code))
  s:desc'="" flagd=$d(^PAC("REFPRI",0,"Desc",desc))
  if (id="")  
  {
    if ((flagc>0)||(flagd>0))
    {
      s flag=1  
    }
    else
    {
      s flag=0  
    }
  }
  else 
  {
    s idc="", idd=""
    s:code'="" idc=$o(^PAC("REFPRI",0,"Code",code,0))
    s:desc'="" idd=$o(^PAC("REFPRI",0,"Desc",desc,0))
    if (desc="")
    {
      if (idc'=id)&(flagc>0) s flag=1   
      else  s flag=0 
    }
    else
    {
      if (code="")
      {
        if (idd'=id)&(flagd>0) s flag=1   
        else  s flag=0 
      }
      else
      {
        if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1 //返回重复标志
        else  s flag=0  
      }
    }
  }
  q flag
}

/// Function:双击修改时,从后台取数据
/// Creator: sunfengchao
/// CreatDate: 2016-11-13
/// Other:d ##class(web.DHCBL.CT.PACReferralPriority).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
  s str=""
  s pobj = ##class(User.PACReferralPriority).%OpenId(id)
  s eobj = ##class(web.Entity.CT.PACReferralPriority).%New()
  s eobj.REFPRIRowId = id
  s eobj.REFPRICode = pobj.REFPRICode
  s eobj.REFPRIDesc = pobj.REFPRIDesc
  d pobj.%Close()
  k pobj
  s str = eobj.JsonS()
  s str = "{list:["_str_"]}"
  q str
}

/// Function:用于数据删除时的逻辑判断
/// Ctreator: Sunfengchao
/// CreateDate:2016-3-3
/// Input:rowid 
/// Output:返回一个标志位，0为未被引用，表示可以被删除;1表示已经被引用了,不能被删除
ClassMethod GetRefFlag(id As %String) As %String
{
  s return="",myInfo=""
  s found1=0  ;^PAADMi("Priority",0,"62561,30772",276)
  if ($d(^PAADMi("Priority",+id))) s found1=1
  if (found1=1)  s myInfo=myInfo_"<患者>"
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

/// Creator: sunfengchao
/// CreatDate: 2016-1-13
/// Description:根据id删除 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.CT.PACReferralPriority).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
  s result=""
 /* s re=..GetRefFlag(id)
  s RefFlag=$p(re,"^",1)
  if (RefFlag=1)
  {
    s result="{success:'false',info:'"_$p(re,"^",2)_"'}"
  }
  else
  {   */
    s pobj = ##class(User.PACReferralPriority).%OpenId(id)
    s eobj = ##class(web.Entity.CT.PACReferralPriority).%New()
    s eobj.REFPRIRowId = id
    s eobj.REFPRICode = pobj.REFPRICode
    s eobj.REFPRIDesc = pobj.REFPRIDesc
    d pobj.%Close()
    k pobj
    Tstart
    s sc=##class(User.PACReferralPriority).%DeleteId(id)
    if $$$ISOK(sc)
    {
      Tcommit
      s result="{success:'true',info:'删除成功！'}"
      d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_ReferralPriority","User.PACReferralPriority","入院病情",id,eobj.REFPRIDesc,"D",eobj)
    }
    else
    {
      Trollback
      s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
      s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("入院病情","web.DHCBL.CT.PACReferralPriority","DeleteData",eobj)
      s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
    }
  //}
   q result
}

/// Description:保存功能
/// Creator:sunfengchao
/// CreatDate:2016-1-13
/// Return:成功返回success:'true'和新增或修改的数据的OPERRowId;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.PACReferralPriority) As %String
{
  s result=""
  if (eobj.REFPRIRowId="")       
  {
    s obj=##class(User.PACReferralPriority).%New()
  }
  else                           
  {
    s obj=##class(User.PACReferralPriority).%OpenId(eobj.REFPRIRowId)
    s bobj = ##class(web.Entity.CT.PACReferralPriority).%New()
    s bobj.REFPRIRowId = eobj.REFPRIRowId
    s bobj.REFPRICode = eobj.REFPRICode
    s bobj.REFPRIDesc = eobj.REFPRIDesc
  }
  s obj.REFPRICode = eobj.REFPRICode
  s obj.REFPRIDesc = eobj.REFPRIDesc
  Tstart
  s sc=obj.%Save()
  do obj.%Close()
  if $$$ISOK(sc)
  {
    Tcommit
    s id = obj.%Id()
    s result = "{success:'true',id:'"_id_"'}"
    d:eobj.REFPRIRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_ReferralPriority","User.PACReferralPriority","入院病情",id,eobj.REFPRIDesc,"A",eobj)
    d:eobj.REFPRIRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_ReferralPriority","User.PACReferralPriority","入院病情",id,eobj.REFPRIDesc,"U",eobj,bobj)
  }
  else
  {
    Trollback
    s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("入院病情","web.DHCBL.CT.PACReferralPriority","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
  }
  q result
}

}
