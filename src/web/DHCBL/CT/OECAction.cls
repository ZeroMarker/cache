Import SQLUser

/// 名称: 皮试备注维护 
/// 描述: 包含增删改查功能
/// 编写者：基础平台组 孙凤超
/// 编写日期: 2017-2-28
Class web.DHCBL.CT.OECAction Extends %RegisteredObject [ ProcedureBlock ]
{

/// Description：查询 皮试备注的内容
/// Table：      OEC_Action
/// Input：      rowid,code,desc 
/// Debug:       d ##class(%ResultSet).RunQuery("web.DHCBL.CT.OECAction","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ACTRowId:%String,ACTCode:%String,ACTDesc:%String,ACTDateFrom:%String,ACTDateTo:%String,BDPInternalCode:%String,BDPInternalDesc:%String,BDPHospNationalCode:%String,BDPHospNationalDesc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
   s repid=$I(^CacheTemp)
   s ind=1
   s resultStr="",BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""
   s AuStr= ##class(web.DHCBL.Authorize.OECAction).DHCGetDataByDefaultSession()
   s AuFlag=0
   ;未授权情况下，默认显示全部数据
   if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
   if (rowid'="") //根据rowid返回该条记录
   {
     s ACTRowId=rowid
     s ACTCode=$p($g(^OEC("ACT",ACTRowId)),"^",1)
     s ACTDesc=$p($g(^OEC("ACT",ACTRowId)),"^",2)
     s ACTDateFrom=$p($g(^OEC("ACT",ACTRowId)),"^",3)
     s ACTDateTo=$p($g(^OEC("ACT",ACTRowId)),"^",4)
     s:ACTDateFrom ACTDateFrom=$zd(ACTDateFrom,1)   
     s:ACTDateTo ACTDateTo=$zd(ACTDateTo,1)  

     s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("OEC_Action",ACTRowId)
     s BDPInternalCode =$p($g(resultStr),"^",1)       
     s BDPInternalDesc = $p($g(resultStr),"^",2)  
     s BDPHospNationalCode=$p($g(resultStr),"^",3)         
     s BDPHospNationalDesc = $p($g(resultStr),"^",4)  
     d OutputRow
   }
   else
   {
     s:code'="" code=$zcvt(code,"U")
     s:desc'="" desc=$zcvt(desc,"U")  
     s ACTRowId=0
     for
     {  
        s ACTRowId=$o(^OEC("ACT",ACTRowId)) q:ACTRowId=""   
        s strACTRowId="{ID:"_ACTRowId_"}"
        if (AuStr[strACTRowId)||(AuFlag=1) 
        {
           s ACTCode=$p($g(^OEC("ACT",ACTRowId)),"^",1)
           s ACTDesc=$p($g(^OEC("ACT",ACTRowId)),"^",2) 
           s ACTDateFrom=$p($g(^OEC("ACT",ACTRowId)),"^",3)
           s ACTDateTo=$p($g(^OEC("ACT",ACTRowId)),"^",4)
           s:ACTDateFrom ACTDateFrom=$zd(ACTDateFrom,1) //转换日期格式
           s:ACTDateTo ACTDateTo=$zd(ACTDateTo,1) //转换日期格式
           s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("OEC_Action",ACTRowId) 
           s BDPInternalCode =$p($g(resultStr),"^",1)       
           s BDPInternalDesc = $p($g(resultStr),"^",2)  
           s BDPHospNationalCode=$p($g(resultStr),"^",3)         
           s BDPHospNationalDesc =$p($g(resultStr),"^",4) 
           if (desc'="")
           {
            ;需要对描述或者别名进行检索      
            s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("OEC_Action",ACTRowId,ACTDesc,desc)
           }
           else
           {
            s AliasFlag= 1   
           }    
           if ($ZCVT(ACTCode,"U")[code)&(AliasFlag=1)  
           {
              d OutputRow
           }
        }
    }
}
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(ACTRowId,ACTCode,ACTDesc,ACTDateFrom,ACTDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
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

/// Function:进行数据检索,为combo提供查询皮试备注的接口
/// CreateDate:2013-5-13
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables: User.OECAction
/// Input:  code, desc  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.OECAction", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ACTRowId:%String,ACTCode:%String,ACTDesc:%String")
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

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
  Set repid=$I(^CacheTemp)
  s ind=1  
  s AuStr=##class(web.DHCBL.Authorize.OECAction).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
  if (rowid'="") //根据rowid返回该条记录
  {
    s ACTRowId=rowid
    s ACTCode=$p($g(^OEC("ACT",ACTRowId)),"^",1)
    s ACTDesc=$p($g(^OEC("ACT",ACTRowId)),"^",2)
    d OutputRowCmb
  }
  else
  {
    s:code'="" code=$$ALPHAUP^SSUTIL4(code) 
    s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) 
    s ACTRowId=0
    for
    {  
      s ACTRowId=$o(^OEC("ACT",ACTRowId)) 
      q:ACTRowId=""  
      s ACTDateFrom=$p($g(^OEC("ACT",ACTRowId)),"^",3) 
      continue:(ACTDateFrom'="")&&(ACTDateFrom>+$h)
      s ACTDateTo=$p($g(^OEC("ACT",ACTRowId)),"^",4) 
      continue:(ACTDateTo'="")&&(ACTDateTo<+$h)
      s strACTRowId="{ID:"_ACTRowId_"}"
      if (AuStr[strACTRowId)||(AuFlag=1) 
      {
        s ACTCode=$p($g(^OEC("ACT",ACTRowId)),"^",1)
        s ACTDesc=$p($g(^OEC("ACT",ACTRowId)),"^",2)
        if (desc'="")
        {
          ;需要对描述或者别名进行检索      
          s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("OEC_Action",ACTRowId,ACTDesc,desc)
        }
        else
        {
          s AliasFlag= 1   
        }    
        if ($ZCVT(ACTCode,"U")[code)&(AliasFlag=1)  
        {
            d OutputRowCmb
        }
    }
  }
}
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(ACTRowId,ACTCode,ACTDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function:双击时显示皮试备注的内容
/// CreateDate:2013-5-13
/// Creator:基础数据平台公共产品组 孙凤超
/// Input:输入id
/// Tables: User.OECAction
/// Others:w ##class(web.DHCBL.CT.OECAction).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
 s str=""
 s pobj = ##class(User.OECAction).%OpenId(id)
 s eobj = ##class(web.Entity.CT.OECAction).%New()
 s eobj.ACTRowId=id
 s eobj.ACTCode= pobj.ACTCode
 s eobj.ACTDesc = pobj.ACTDesc
 s:pobj.ACTDateFrom'="" eobj.ACTDateFrom = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.ACTDateFrom)
 s:pobj.ACTDateTo'="" eobj.ACTDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.ACTDateTo)
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Function:实现对皮试备注删除操作
/// Creator:孙凤超
/// CreateDate:2013-05-13
/// Desc:通过rowid号来删除皮试备注 
/// Output:success:'true',info:'删除成功！ 失败时输出删除成功！
/// Tables:  User.OECAction  
/// Others:d ##class(web.DHCBL.CT.OECAction)DeleteData("")
ClassMethod DeleteData(id As %String) As %String
{
    s result="",flag=""
    Tstart
    s eobj = ##class(web.Entity.CT.OECAction).%New()
    s obj = ##class(User.OECAction).%OpenId(id)
    s eobj.ACTRowId=id
    s eobj.ACTCode = obj.ACTCode
    s eobj.ACTDesc= obj.ACTDesc
    s eobj.ACTDateFrom = obj.ACTDateFrom
    s eobj.ACTDateTo=obj.ACTDateTo
   
    s sc=##class(User.OECAction).%DeleteId(id)
    IF $$$ISOK(sc)
    {
      Tc
      s result="{success:'true',info:'删除成功！'}"
      d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("OEC_Action","User.OECAction","皮试备注",id,eobj.ACTDesc,"D",eobj)
      d eobj.%Close()
    }
    else
    {
     Trollback
     s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
     s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("皮试备注","web.DHCBL.CT.OECAction","DeleteData",eobj)
     s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
    }
    q result
}

/// Creator：基础数据平台组 孙凤超
/// CreatDate: 2013-5-13
/// Description：数据重复校验
/// Table： OEC_Action
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s flag="",flagc="", flagd=""
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //此处用于转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //此处用于转换成大写
 s:code'="" flagc=$d(^OEC("ACT",0,"Code",code))
 s:desc'="" flagd=$d(^OEC("ACT",0,"Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0))
  {
   s flag=1  //返回重复标志
  }
  else
  {
   s flag=0 //返回不重复标志
  }
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^OEC("ACT",0,"Code",code,0))
  s:desc'="" idd=$o(^OEC("ACT",0,"Desc",desc,0))
  if (desc="")
  {
   if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
   else  s flag=0 //返回不重复标志
  }
  else
  {
   if (code="")
   {
    if (idd'=id)&(flagd>0) s flag=1  //返回重复标志
    else  s flag=0 //返回不重复标志
   }
   else
   {
    if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1 //返回重复标志
    else  s flag=0 //返回不重复标志
   }
  }
 }
 q flag
}

/// Creator：基础数据平台组 孙凤超
/// CreatDate: 2013-05-13
/// Description：保存修改皮试备注的内容
/// Table：User.OECAction
/// Input：web.Entity.CT.OECAction 实体类
/// Others: d ##class(web.DHCBL.CT.OECAction).SaveEntity()
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.OECAction, ACTCode As %String = "") As %String
{
 s $zt="ERROR"
 s result=""
 if $IsObject(eobj)
 {
  if eobj.ACTDateFrom'="" s eobj.ACTDateFrom= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ACTDateFrom)   
  if eobj.ACTDateTo'="" s eobj.ACTDateTo= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ACTDateTo)      
  if eobj.ACTDateFrom="" s eobj.ACTDateFrom=+$h
  if (eobj.ACTRowId="")       
  {
   s obj=##class(User.OECAction).%New()
  }
  else                           
  {   
    s obj=##class(User.OECAction).%OpenId(eobj.ACTRowId)
    s bobj=##class(web.Entity.CT.OECAction).%New()
    s bobj.ACTRowId=eobj.ACTRowId
    s bobj.ACTCode = obj.ACTCode                      
    s bobj.ACTDesc= obj.ACTDesc                     
    s bobj.ACTDateFrom = obj.ACTDateFrom 
    s bobj.ACTDateTo=obj.ACTDateTo 
  }
   s obj.ACTCode =  ACTCode                      
   s obj.ACTDesc= eobj.ACTDesc                      
   s obj.ACTDateFrom = eobj.ACTDateFrom 
   s obj.ACTDateTo=eobj.ACTDateTo
   Tstart
   s sc=obj.%Save()
   if $$$ISOK(sc)
   {
     Tcommit
     s id = obj.%Id()
     s result = "{success:'true',id:'"_id_"'}"          
     d:eobj.ACTRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("OEC_Action","User.OECAction","皮试备注",id,eobj.ACTDesc,"A",eobj)
     d:eobj.ACTRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("OEC_Action","User.OECAction","皮试备注",eobj.ACTRowId,eobj.ACTDesc,"U",eobj,bobj)
   }
   else
   {
      Trollback
      s logid="",errorinfo=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
      s ^tmp("errrorinfo1")=errorinfo
      s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("皮试备注","web.DHCBL.CT.OECAction","SaveEntity",eobj)
      s ^ERRORLOGINFO(logid)=errorinfo   
      s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
   } 
  }
  else
  {
   s result = "{success:'false',errorinfo:'对象不存在！'}"
  } 
  q result
ERROR
  s logid="",errorinfo="保存失败！"
  s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("皮试备注","web.DHCBL.CT.OECAction","SaveEntity",eobj)
  s ^ERRORLOGINFO(logid)=errorinfo  
  q result= "{success:'false',errorinfo:'保存失败！'}"
}

}
