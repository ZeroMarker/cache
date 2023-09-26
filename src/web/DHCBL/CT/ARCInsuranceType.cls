Class web.DHCBL.CT.ARCInsuranceType Extends %RegisteredObject [ ProcedureBlock ]
{

Parameter SQLTableName = "ARC_InsuranceType";

/// Function:进行数据检索，查询付款人信息
/// CreateDate:2013-05-13
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables:  ARC_InsuranceType
/// Input: rowid, code, desc ,hospid(医院id)
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ARCInsuranceType", "GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "INSTRowId:%String,INSTCode:%String,INSTDesc:%String,INSTDateFrom:%String,INSTDateTo:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, hospid As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s:code'="" code=$zcvt(code,"U")  
 s:desc'="" desc=$zcvt(desc,"U") 
 s AuStr=##class(web.DHCBL.Authorize.ARCInsuranceType).DHCGetDataByDefaultSession()
 s AuFlag=0
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1  
 if (rowid'="")  
 {
  s INSTRowId=rowid
  s INSTCode=$p($g(^ARC("INST",INSTRowId)),"^",1)
  s INSTDesc=$p($g(^ARC("INST",INSTRowId)),"^",2) 
  s INSTDateFrom=$p($g(^ARC("INST",INSTRowId)),"^",13)
  s:INSTDateFrom'="" INSTDateFrom= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(INSTDateFrom) 
    // $zd(INSTDateFrom,1)
  s INSTVDateTo=$p($g(^ARC("INST",INSTRowId)),"^",14)
  s:INSTVDateTo'="" INSTVDateTo= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(INSTVDateTo) 
  s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""
  s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("ARC_InsuranceType",INSTRowId)
  s BDPInternalCode =$p($g(resultStr),"^",1)       
  s BDPInternalDesc = $p($g(resultStr),"^",2)  
  S BDPHospNationalCode=$p($g(resultStr),"^",3)         
  s BDPHospNationalDesc = $p($g(resultStr),"^",4)
  d OutputRow
 }
 else
 {
  s INSTRowId=0
  for
  {
   s INSTRowId=$o(^ARC("INST",INSTRowId))  q:INSTRowId=""   
   s strINSTRowId="{ID:"_INSTRowId_"}"
   if (AuStr[strINSTRowId)||(AuFlag=1) 
   {
    s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,INSTRowId,hospid)
    continue:showflag="N"    
    s INSTCode=$p($g(^ARC("INST",INSTRowId)),"^",1)
    s INSTDesc=$p($g(^ARC("INST",INSTRowId)),"^",2)  
    s INSTDateFrom=$p($g(^ARC("INST",INSTRowId)),"^",13)
    s:INSTDateFrom'="" INSTDateFrom=$zd(INSTDateFrom,1)
    s INSTVDateTo=$p($g(^ARC("INST",INSTRowId)),"^",14)
    s:INSTVDateTo'="" INSTVDateTo=$zd(INSTVDateTo,1)
    s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""
    s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("ARC_InsuranceType",INSTRowId)
    s BDPInternalCode =$p($g(resultStr),"^",1)       
    s BDPInternalDesc = $p($g(resultStr),"^",2)  
    S BDPHospNationalCode=$p($g(resultStr),"^",3)         
    s BDPHospNationalDesc = $p($g(resultStr),"^",4)
    if (desc'="")
    {
        ;需要对描述或者别名进行检索      
        s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("ARC_InsuranceType",INSTRowId,INSTDesc,desc)
    }
    else
    {
        s AliasFlag= 1   
    }   
    if ($$ALPHAUP^SSUTIL4(INSTCode)[code)&(AliasFlag= 1) 
    {
      d OutputRow
    }
  }
 }
}
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(INSTRowId,INSTCode,INSTDesc,INSTDateFrom,INSTVDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc )
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
  //if there are no more rows,finish fetching...
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

/// Function:进行数据检索，为comb提供查询规定资源信息的接口
/// CreateDate:2012-12-10
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables: User.ARCInsuranceType
/// Input:  code, desc ,hospid(医院id)
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ARCInsuranceType","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "INSTRowId:%String, INSTCode:%String,INSTDesc:%String ")
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
  s:code'="" code=$zcvt(code,"U")  
  s:desc'="" desc=$zcvt(desc,"U") 
  s AuStr=##class(web.DHCBL.Authorize.ARCInsuranceType).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  if (rowid'="")  
  {
   s INSTRowId=rowid
   s INSTCode=$p($g(^ARC("INST",INSTRowId)),"^",1)
   s INSTDesc=$p($g(^ARC("INST",INSTRowId)),"^",2) 
   d OutputRow2
  }
  else
  {
    s INSTRowId=0
    for
    {
      s INSTRowId=$o(^ARC("INST",INSTRowId))  
      q:INSTRowId=""   
      s strINSTRowId="{ID:"_INSTRowId_"}"
      if (AuStr[strINSTRowId)||(AuFlag=1) 
      {

        s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,INSTRowId,hospid)
        continue:showflag="N" 
        s INSTCode=$p($g(^ARC("INST",INSTRowId)),"^",1)
        s INSTDesc=$p($g(^ARC("INST",INSTRowId)),"^",2) 
        s INSTDateFrom=$p($g(^ARC("INST",INSTRowId)),"^",13)
        continue:(INSTDateFrom'="")&&(INSTDateFrom>+$h)
        s INSTVDateTo=$p($g(^ARC("INST",INSTRowId)),"^",14) 
        continue:(INSTVDateTo'="")&&(INSTVDateTo<+$h) 
        if (desc'="")
        {
            ;需要对描述或者别名进行检索      
            s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("ARC_InsuranceType",INSTRowId,INSTDesc,desc)
        }
        else
        {
            s AliasFlag= 1   
        }   
        if ($$ALPHAUP^SSUTIL4(INSTCode)[code)&(AliasFlag=1) 
        {
            d OutputRow2
        }
    }
  }
} 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2   
   
  set Data=$lb(INSTRowId,INSTCode,INSTDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function:双击时弹出显示付款人信息
/// CreateDate:2012-09-10
/// Creator:基础数据平台公共产品组 孙凤超
/// Input:输入id
/// Tables: User.ARCInsuranceType
/// Others:w ##Class(web.DHCBL.CT.ARCInsuranceType).OpenData("23")
ClassMethod OpenData(id As %String) As %String
{
 s str=""
 s pobj = ##class(User.ARCInsuranceType).%OpenId(id)
 s eobj = ##class(web.Entity.CT.ARCInsuranceType).%New()
 s eobj.INSTRowId = id
 s eobj.INSTCode = pobj.INSTCode
 s eobj.INSTDesc = pobj.INSTDesc
 s:pobj.INSTDateFrom'="" eobj.INSTDateFrom =##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.INSTDateFrom)
 s:pobj.INSTDateTo'="" eobj.INSTDateTo = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.INSTDateTo)
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Function:用于数据删除时的逻辑判断
/// CreateDate:2015-5-13
/// Ctreator:Sunfengchao
/// Input:rowid  ^RB("RES",0,"EQ",{RES_EQ_DR},{RES_CTLOC_DR},{RES_RowId})
/// Output:返回一个标志位，0为未被引用，表示可以被删除，1表示已经被引用了，不能被删除
/// debug: w ##class(web.DHCBL.CT.ARCInsuranceType).GetRefFlag("")
ClassMethod GetRefFlag(id As %String) As %String
{
  s return="",myInfo=""
  s found1=0
  s rowid=0
  for
  {
   s rowid=$O(^PAPER(rowid))
   q:rowid=""
   s PAPERInsTypeDR=""
   s PAPERInsTypeDR=$p($g(^PAPER(1,"PER",rowid)),"^",22)
   if (PAPERInsTypeDR=id)
   {
    s found1=1
   }
  }   
  if (found1=1)  s myInfo=myInfo_"<患者就诊表>" 
  
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

/// Function:实现删除操作
/// Creator:孙凤超
/// CreateDate:2012-08-30
/// Desc:通过rowid来删除信息
/// Input: rowid
/// Output:success:'true',info:'删除成功！ 失败时输出删除成功！
/// Other:d ##class(web.DHCBL.CT.ARCInsuranceType).DeleteData("23")
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
      Tstart
      s eobj = ##class(web.Entity.CT.ARCInsuranceType).%New()
      s obj=##class(User.ARCInsuranceType).%OpenId(id)
      s eobj.INSTRowId=id
      s eobj.INSTCode=obj.INSTCode
      s eobj.INSTDesc=obj.INSTDesc
      s eobj.INSTDateFrom=obj.INSTDateFrom
      s eobj.INSTDateTo=obj.INSTDateTo

       s sc=##class(User.ARCInsuranceType).%DeleteId(id)
       IF $$$ISOK(sc){
       Tc
       s result="{success:'true',info:'删除成功！'}"
       d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_InsuranceType","User.ARCInsuranceType","付款人",id,eobj.INSTDesc,"D",eobj)
       d eobj.%Close()
     }
      else{
      Trollback
      s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" 
      s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("付款人","web.DHCBL.CT.ARCInsuranceType","DeleteData",eobj)
      s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
     }
  }
 q result
}

/// Function:实现数据重复校验
/// Creator:孙凤超
/// CreateDate:2012-11-07
/// Input：id, code, desc,hospid(医院id)
/// Tables：ARC_InsuranceType
ClassMethod FormValidate(id As %String, code As %String, desc As %String, hospid As %String = "") As %String
{
    s flag=0
    if $$ALPHAUP^SSUTIL4(code)'=""
    {
        s idc=0
        for
        {
            s idc=$o(^ARC("INST",0,"Code",$$ALPHAUP^SSUTIL4(code),idc)) q:idc=""
            if (idc'=id)
            {
                ///私有数据
                s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,idc,hospid)
                continue:showflag="N"
                s flag=1
            }
        }
    }
    
    if $$ALPHAUP^SSUTIL4(desc)'=""
    {
        s idd=0
        for
        {
    
            s idd=$o(^ARC("INST",0,"Desc",$$ALPHAUP^SSUTIL4(desc),idd)) q:idd=""
            if (idd'=id)
            {
                ///私有数据
                s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,idd,hospid)
                continue:showflag="N"
                s flag=1
            }
        }
    }
    q flag
}

/// Function:实现对付款人信息的修改和保存操作
/// Creator:孙凤超
/// CreateDate:2012-08-29
/// Desc:通过rowid来修改或保存付款人类型信息
/// Output: success:'true',info:'添加成功！' 失败时输出添加失败！
///         success:'false',info:'修改成功' 失败时输出修改失败！
/// Tables:  ARC_InsuranceType
ClassMethod SaveEntity(eobj As web.Entity.CT.ARCInsuranceType) As %String
{
 s $zt="ERROR"
 s result=""
 if $IsObject(eobj)
 {
  s:eobj.INSTDateFrom="" eobj.INSTDateFrom= +$h
  s:eobj.INSTDateFrom'="" eobj.INSTDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.INSTDateFrom)   
  s:eobj.INSTDateTo'="" eobj.INSTDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.INSTDateTo)      
  if (eobj.INSTRowId="")       
  {   
    s obj=##class(User.ARCInsuranceType).%New()
  }else  //如果RowId已赋值则修改
  {
    s obj=##class(User.ARCInsuranceType).%OpenId(eobj.INSTRowId)
    s bobj=##class(web.Entity.CT.ARCInsuranceType).%New()
    s bobj.INSTRowId=eobj.INSTRowId
    s bobj.INSTCode = obj.INSTCode                      
    s bobj.INSTDesc= obj.INSTDesc
    s bobj.INSTDateFrom=obj.INSTDateFrom
    s bobj.INSTDateTo=obj.INSTDateTo
  }
   s obj.INSTCode = eobj.INSTCode                     
   s obj.INSTDesc= eobj.INSTDesc
   s obj.INSTDateFrom=eobj.INSTDateFrom
   s obj.INSTDateTo=eobj.INSTDateTo
   Tstart
   s sc=obj.%Save()
   if $$$ISOK(sc)
   {
    Tcommit
    s id = obj.%Id()
    s result = "{success:'true',id:'"_id_"'}"      
    d:eobj.INSTRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_InsuranceType","User.ARCInsuranceType","付款人",id,eobj.INSTDesc,"A",eobj)
    d:eobj.INSTRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_InsuranceType","User.ARCInsuranceType","付款人",eobj.INSTRowId,eobj.INSTDesc,"U",eobj,bobj)
   }
   else
   {
     Trollback
     s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
     s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("付款人","web.DHCBL.CT.ARCInsuranceType","SaveEntity",eobj)
     s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
   } 
  }
  else
  {
    s result = "{success:'false',errorinfo:'对象不存在！'}"
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("付款人","web.DHCBL.CT.ARCInsuranceType","SaveEntity","")
    s ^ERRORLOGINFO(logid)="对象不存在！"
  } 
 q result
ERROR
 s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("付款人","web.DHCBL.CT.ARCInsuranceType","SaveEntity",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q "{success:'false',errorinfo:'保存失败！'}"
}

}
