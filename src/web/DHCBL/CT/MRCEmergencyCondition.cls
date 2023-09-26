Import SQLUser

/// 名称: 急诊情况维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-sunfengchao
/// 编写日期: 2012-8-31
Class web.DHCBL.CT.MRCEmergencyCondition Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：sunfengchao
/// CreatDate: 2012-12-3
/// Description：修改时打开的数据
/// Table：User.MRCEmergencyCondition
/// Input：id
ClassMethod OpenData(id As %String) As %String
{
 s str="" 
 s eobj = ##class(web.Entity.CT.MRCEmergencyCondition).%New()
 s eobj.EMCRowId = id
 s eobj.EMCCode=$p($g(^MRC("EMC",eobj.EMCRowId)),"^",1)
 s eobj.EMCDesc=$p($g(^MRC("EMC",eobj.EMCRowId)),"^",2)
 s eobj.EMCDateFrom=$p($g(^MRC("EMC",eobj.EMCRowId)),"^",5)
 s eobj.EMCDateTo=$p($g(^MRC("EMC",eobj.EMCRowId)),"^",6)
 s:eobj.EMCDateFrom'="" eobj.EMCDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.EMCDateFrom) //转换日期格式
 s:eobj.EMCDateTo'="" eobj.EMCDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.EMCDateTo) //转换日期格式
 
 s str = eobj.JsonS() 
 d eobj.%Close()
 s str = "{list:["_str_"]}"
 q str
}

/// Creator：sunfengchao
/// CreatDate: 2012-12-3
/// Description：数据重复验证方法,js调用
/// Table：User.MRCEmergencyCondition
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s flag="",flagc="",flagd=""
 s:code'="" flagc=$d(^MRC("EMC",0,"Code",code))
 s:desc'="" flagd=$d(^MRC("EMC",0,"Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^MRC("EMC",0,"Code",code,0))
  s:desc'="" idd=$o(^MRC("EMC",0,"Desc",desc,0))
  if (desc="")
  {
   if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
   else  s flag=0 //返回不重复标志
  }
  elseif (code="")
  {
   if (idd'=id)&(flagd>0) s flag=1  //返回重复标志
   else  s flag=0 //返回不重复标志
  }
 }
 q flag
}

/// Creator：sunfengchao
/// CreatDate: 2012-11-7
/// Description：数据重复验证方法
/// Table：User.MRCEmergencyCondition
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s flag="",flagc="",flagd=""
 s:code'="" flagc=$d(^MRC("EMC",0,"Code",code))
 s:desc'="" flagd=$d(^MRC("EMC",0,"Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^MRC("EMC",0,"Code",code,0))
  s:desc'="" idd=$o(^MRC("EMC",0,"Desc",desc,0))
  if ((idc'=id)&(flagc>0))||((idd'=id)&(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 q flag
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-31
/// Description：保存修改急诊情况的内容
/// Table：User.MRCEmergencyCondition
/// Input：web.Entity.CT.MRCEmergencyCondition 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.MRCEmergencyCondition).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.MRCEmergencyCondition) As %String
{
 s $zt="ERROE"
 s result=""
 if $IsObject(eobj)
 {
  s:eobj.EMCDateFrom'="" eobj.EMCDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.EMCDateFrom)  //转换日期
  s:eobj.EMCDateTo'="" eobj.EMCDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.EMCDateTo)      //转换日期
  s:eobj.EMCDateFrom="" eobj.EMCDateFrom=+$h
  s flag=..Validate(eobj.EMCRowId,eobj.EMCCode,eobj.EMCDesc)  //调用重复验证
  if (flag=1)
  {
   s result = "{success:'false',errorinfo:'该记录已经存在！'}"
  }
  else
  {
   if (eobj.EMCRowId="") 
   {
    s obj=##class(User.MRCEmergencyCondition).%New()
   }
   else                 
   {
    s obj=##class(User.MRCEmergencyCondition).%OpenId(eobj.EMCRowId)
    s bobj=##class(web.Entity.CT.MRCEmergencyCondition).%New()
    s bobj.EMCRowId=eobj.EMCRowId
    s bobj.EMCCode = obj.EMCCode           
    s bobj.EMCDesc = obj.EMCDesc          
    s bobj.EMCDateFrom = obj.EMCDateFrom   
    s bobj.EMCDateTo = obj.EMCDateTo       
   }
   Ts          
   s obj.EMCCode = eobj.EMCCode          
   s obj.EMCDesc = eobj.EMCDesc           
   s obj.EMCDateFrom = eobj.EMCDateFrom  
   s obj.EMCDateTo = eobj.EMCDateTo      
   s sc=obj.%Save()
   d obj.%Close()
   If $$$ISOK(sc)
   {
    Tc
    s id = obj.%Id()
    s result= "{success:'true',id:'"_id_"'}"        
    //保存日志
    d:eobj.EMCRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MRC_EmergencyCondition","User.MRCEmergencyCondition","急诊情况",id,eobj.EMCDesc,"A",eobj)
    d:eobj.EMCRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MRC_EmergencyCondition","User.MRCEmergencyCondition","急诊情况",eobj.EMCRowId,eobj.EMCDesc,"U",eobj,bobj)
   }
   else
   {
    Trollback
    s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("急诊情况","web.DHCBL.CT.MRCEmergencyCondition","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   }
  }
 }
 else
 {
  s result= "{success:'false',errorinfo:'对象不存在！'}"
  s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("急诊情况","web.DHCBL.CT.MRCEmergencyCondition","SaveEntity","")
  s ^ERRORLOGINFO(logid)="对象不存在！"
 }
 q result
ERROE
 s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("急诊情况","web.DHCBL.CT.MRCEmergencyCondition","SaveEntity",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-31
/// Description：根据ID删除急诊情况的内容
/// Table：User.MRCEmergencyCondition
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
 s result=""
 s eobj = ##class(web.Entity.CT.MRCEmergencyCondition).%New()
 s eobj.EMCRowId = id
 s eobj.EMCCode=$p($g(^MRC("EMC",eobj.EMCRowId)),"^",1)
 s eobj.EMCDesc=$p($g(^MRC("EMC",eobj.EMCRowId)),"^",2)
 s eobj.EMCDateFrom=$p($g(^MRC("EMC",eobj.EMCRowId)),"^",5)
 s eobj.EMCDateTo=$p($g(^MRC("EMC",eobj.EMCRowId)),"^",6)
 
 s sc=##class(User.MRCEmergencyCondition).%DeleteId(id)
 if $$$ISOK(sc)
 {
  s result= "{success:'true',info:'删除成功！'}" 
  //保存日志
  d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MRC_EmergencyCondition","User.MRCEmergencyCondition","急诊情况",id,eobj.EMCDesc,"D",eobj)
  d eobj.%Close()
 }
 else 
 {
  s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
  s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("急诊情况","web.DHCBL.CT.MRCEmergencyCondition","DeleteData",eobj)
  s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
 }
 q result
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-31
/// Description：查询急诊情况的内容
/// Table：MRC_EmergencyCondition
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.MRCEmergencyCondition","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "EMCRowId:%String,EMCCode:%String,EMCDesc:%String,EMCDateFrom:%String,EMCDateTo:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc ")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
  s repid=$I(^CacheTemp)
  s ind=1
 
  //获取授权Json
  s AuStr=##class(web.DHCBL.Authorize.MRCEmergencyCondition).DHCGetDataByDefaultSession()
  s AuFlag=0
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
 
  if (rowid'="") //根据rowid返回该条记录
  {
    s EMCRowId=rowid
    s EMCCode=$p($g(^MRC("EMC",EMCRowId)),"^",1)
    s EMCDesc=$p($g(^MRC("EMC",EMCRowId)),"^",2)
    s EMCDateFrom=$p($g(^MRC("EMC",EMCRowId)),"^",5)
    s EMCDateTo=$p($g(^MRC("EMC",EMCRowId)),"^",6)
    s:EMCDateFrom'="" EMCDateFrom=$zd(EMCDateFrom,1) 
    s:EMCDateTo'="" EMCDateTo=$zd(EMCDateTo,1) 
    s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
    s BDPStandardRowId=$o(^User.BDPStandardCodeI("DataRef","MRC_EmergencyCondition",EMCRowId,0))  
    if (BDPStandardRowId'="")
    {
      s BDPInternalCode = $listget(^User.BDPStandardCodeD(BDPStandardRowId),6)          
      s BDPInternalDesc = $listget(^User.BDPStandardCodeD(BDPStandardRowId),7)
      s BDPHospNationalCode=$listget(^User.BDPStandardCodeD(BDPStandardRowId),8)          
      s BDPHospNationalDesc = $listget(^User.BDPStandardCodeD(BDPStandardRowId),9)
    } 
    d OutputRow
  }
  else
  {
    s:code'="" code=$$ALPHAUP^SSUTIL4(code) 
    s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) 
    s EMCRowId=0
    for
    {
       s EMCRowId=$o(^MRC("EMC",EMCRowId))
       q:EMCRowId=""
       ;筛选授权后的数据
       s strRowId="{ID:"_EMCRowId_"}"
       if (AuStr[strRowId)||(AuFlag=1) 
       {
         s EMCCode=$p($g(^MRC("EMC",EMCRowId)),"^",1)
         s EMCDesc=$p($g(^MRC("EMC",EMCRowId)),"^",2) 
         s EMCDateFrom=$p($g(^MRC("EMC",EMCRowId)),"^",5)
         s EMCDateTo=$p($g(^MRC("EMC",EMCRowId)),"^",6)
         s:EMCDateFrom'="" EMCDateFrom=$zd(EMCDateFrom,1)  
         s:EMCDateTo'="" EMCDateTo=$zd(EMCDateTo,1)  
         s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
         s BDPStandardRowId=$o(^User.BDPStandardCodeI("DataRef","MRC_EmergencyCondition",EMCRowId,0))  
         if (BDPStandardRowId'="")
         {
          s BDPInternalCode = $listget(^User.BDPStandardCodeD(BDPStandardRowId),6)          
          s BDPInternalDesc = $listget(^User.BDPStandardCodeD(BDPStandardRowId),7)
          s BDPHospNationalCode=$listget(^User.BDPStandardCodeD(BDPStandardRowId),8)          
          s BDPHospNationalDesc = $listget(^User.BDPStandardCodeD(BDPStandardRowId),9)
         } 
         if (desc'="")
         {
            ;需要对描述或者别名进行检索      
            s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("MRC_EmergencyCondition",EMCRowId,EMCDesc,desc)
         }
         else
         {
            s AliasFlag= 1   
         }    
         if ($ZCVT(EMCCode,"U")[code)&(AliasFlag=1)   
         {
            d OutputRow
         }
      }
    }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(EMCRowId,EMCCode,EMCDesc,EMCDateFrom,EMCDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc )
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

/// Creator：sunfengchao
/// CreatDate: 2012-12-10
/// Description：查询急诊情况的内容,用于combox查询
/// Table：User.MRCEmergencyCondition
/// Input：rowid,code,desc
/// Return：EMCRowId,EMCCode,EMCDesc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.MRCEmergencyCondition","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "EMCRowId:%String,EMCCode:%String,EMCDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 //获取授权Json
 s AuStr=##class(web.DHCBL.Authorize.MRCEmergencyCondition).DHCGetDataByDefaultSession()
 s AuFlag=0
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
 
 if (rowid'="") //根据rowid返回该条记录
 {
  s EMCRowId=rowid
  s EMCCode=$p($g(^MRC("EMC",EMCRowId)),"^",1)
  s EMCDesc=$p($g(^MRC("EMC",EMCRowId)),"^",2)
  d OutputRow2
 }
 else
 {
    s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
    s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
    s EMCRowId=0
    for
    {
      s EMCRowId=$o(^MRC("EMC",EMCRowId))
      q:EMCRowId=""
      s EMCDateFrom=$p($g(^MRC("EMC",EMCRowId)),"^",5)
      continue:(EMCDateFrom'="")&&(EMCDateFrom>+$h)
      s EMCDateTo=$p($g(^MRC("EMC",EMCRowId)),"^",6) 
      continue:(EMCDateTo'="")&&(EMCDateTo<+$h)
       //筛选授权后的数据
      s strRowId="{ID:"_EMCRowId_"}"
      if (AuStr[strRowId)||(AuFlag=1)
      {
         s EMCCode=$p($g(^MRC("EMC",EMCRowId)),"^",1)
         s EMCDesc=$p($g(^MRC("EMC",EMCRowId)),"^",2)
         if (desc'="")
         {
            ;需要对描述或者别名进行检索      
            s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("MRC_EmergencyCondition",EMCRowId,EMCDesc,desc)
         }
         else
         {
            s AliasFlag= 1   
         }    
         if ($ZCVT(EMCCode,"U")[code)&(AliasFlag=1)  
         {
           d OutputRow2
         }
      }
   }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2
    set Data=$lb(EMCRowId,EMCCode,EMCDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
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

}
