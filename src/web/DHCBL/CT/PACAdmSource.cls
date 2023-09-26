Import SQLUser

/// 名称: 入院途径维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-sunfengchao
/// 编写日期: 2012-8-31
Class web.DHCBL.CT.PACAdmSource Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：sunfengchao
/// CreatDate: 2012-12-3
/// Description：修改时打开的数据
/// Table：User.PACAdmSource
/// Input：id
ClassMethod OpenData(id As %String) As %String
{
 s str="" 
 s eobj = ##class(web.Entity.CT.PACAdmSource).%New()
 s eobj.ADSOURowId = id
 s eobj.ADSOUCode=$p($g(^PAC("ADSOU",eobj.ADSOURowId)),"^",1)     ; 代码
 s eobj.ADSOUDesc=$p($g(^PAC("ADSOU",eobj.ADSOURowId)),"^",2)     ;描述
 s eobj.ADSOUDateFrom=$p($g(^PAC("ADSOU",eobj.ADSOURowId)),"^",4) ;开始日期
 s eobj.ADSOUDateTo=$p($g(^PAC("ADSOU",eobj.ADSOURowId)),"^",5)   ;结束日期
 s eobj.ADSOUEpisodeType=$p($g(^PAC("ADSOU",eobj.ADSOURowId)),"^",7) ;就诊类型
 s:eobj.ADSOUDateFrom'="" eobj.ADSOUDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.ADSOUDateFrom) //转换日期格式
 s:eobj.ADSOUDateTo'="" eobj.ADSOUDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.ADSOUDateTo) //转换日期格式
 
 s str = eobj.JsonS() 
 d eobj.%Close()
 s str = "{list:["_str_"]}"
 q str
}

/// Creator：sunfengchao
/// CreatDate: 2012-12-3
/// Description：数据重复验证方法,js调用
/// Table：User.PACAdmSource
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s flag="",flagc="",flagd=""
 s:code'="" flagc=$d(^PAC("ADSOU",0,"ADSOU_Code",code))
 s:desc'="" flagd=$d(^PAC("ADSOU",0,"ADSOU_Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^PAC("ADSOU",0,"ADSOU_Code",code,0))
  s:desc'="" idd=$o(^PAC("ADSOU",0,"ADSOU_Desc",desc,0))
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
/// Table：User.PACAdmSource
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s flag="",flagc="",flagd=""
 s:code'="" flagc=$d(^PAC("ADSOU",0,"ADSOU_Code",code))
 s:desc'="" flagd=$d(^PAC("ADSOU",0,"ADSOU_Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^PAC("ADSOU",0,"ADSOU_Code",code,0))
  s:desc'="" idd=$o(^PAC("ADSOU",0,"ADSOU_Desc",desc,0))
  if ((idc'=id)&(flagc>0))||((idd'=id)&(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 q flag
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-31
/// Description：保存修改入院途径的内容
/// Table：User.PACAdmSource
/// Input：web.Entity.CT.PACAdmSource 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.PACAdmSource).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.PACAdmSource) As %String
{
 s $zt="ERROE"
 s result=""
 if $IsObject(eobj)
 {
  s:eobj.ADSOUDateFrom'="" eobj.ADSOUDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ADSOUDateFrom)  //转换日期
  s:eobj.ADSOUDateTo'="" eobj.ADSOUDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ADSOUDateTo)      //转换日期
  s:eobj.ADSOUDateFrom="" eobj.ADSOUDateFrom=+$h
  s flag=..Validate(eobj.ADSOURowId,eobj.ADSOUCode,eobj.ADSOUDesc)  //调用重复验证
  if (flag=1)
  {
   s result = "{success:'false',errorinfo:'该记录已经存在！'}"
  }
  else
  {
   if (eobj.ADSOURowId="")  //如果RowId未赋值则增加
   {
    s obj=##class(User.PACAdmSource).%New()
   }
   else                     //如果RowId已赋值则修改
   {
    s obj=##class(User.PACAdmSource).%OpenId(eobj.ADSOURowId)
    s bobj=##class(web.Entity.CT.PACAdmSource).%New()
    s bobj.ADSOURowId=eobj.ADSOURowId
    s bobj.ADSOUCode = obj.ADSOUCode          
    s bobj.ADSOUDesc = obj.ADSOUDesc           
    s bobj.ADSOUDateFrom = obj.ADSOUDateFrom   
    s bobj.ADSOUDateTo = obj.ADSOUDateTo      
    s bobj.ADSOUEpisodeType = obj.ADSOUEpisodeType
   }
   Ts                    
   s obj.ADSOUCode = eobj.ADSOUCode          //修改代码
   s obj.ADSOUDesc = eobj.ADSOUDesc          //修改描述
   s obj.ADSOUDateFrom = eobj.ADSOUDateFrom  //修改开始日期
   s obj.ADSOUDateTo = eobj.ADSOUDateTo      //修改结束日期
   s obj.ADSOUEpisodeType = eobj.ADSOUEpisodeType ;就诊类型
   s sc=obj.%Save()
   d obj.%Close()
   If $$$ISOK(sc)
   {
    Tc
    s id = obj.%Id()
    s result= "{success:'true',id:'"_id_"'}"         //返回RowId
    //保存日志
    d:eobj.ADSOURowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_AdmSource","User.PACAdmSource","入院途径",id,eobj.ADSOUDesc,"A",eobj)
    d:eobj.ADSOURowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_AdmSource","User.PACAdmSource","入院途径",eobj.ADSOURowId,eobj.ADSOUDesc,"U",eobj,bobj)
   }
   else
   {
    Trollback
    s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("入院途径","web.DHCBL.CT.PACAdmSource","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   }
  }  
 }
 else
 {
  s result= "{success:'false',errorinfo:'对象不存在！'}"
  s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("入院途径","web.DHCBL.CT.PACAdmSource","SaveEntity","")
  s ^ERRORLOGINFO(logid)="对象不存在！"
 }
 q result
ERROE
  s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("入院途径","web.DHCBL.CT.PACAdmSource","SaveEntity",eobj)
  s ^ERRORLOGINFO(logid)= $ze
 q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-31
/// Description：根据ID删除入院途径的内容
/// Table：User.PACAdmSource
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
 s result=""
 s eobj = ##class(web.Entity.CT.PACAdmSource).%New()
 s eobj.ADSOURowId = id
 s eobj.ADSOUCode=$p($g(^PAC("ADSOU",eobj.ADSOURowId)),"^",1)
 s eobj.ADSOUDesc=$p($g(^PAC("ADSOU",eobj.ADSOURowId)),"^",2)
 s eobj.ADSOUDateFrom=$p($g(^PAC("ADSOU",eobj.ADSOURowId)),"^",4)
 s eobj.ADSOUDateTo=$p($g(^PAC("ADSOU",eobj.ADSOURowId)),"^",5)
 s eobj.ADSOUEpisodeType=$p($g(^PAC("ADSOU",eobj.ADSOURowId)),"^",7)
 
 s sc=##class(User.PACAdmSource).%DeleteId(id)
 if $$$ISOK(sc)
 {
  s result= "{success:'true',info:'删除成功！'}" 
  //保存日志
  d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_AdmSource","User.PACAdmSource","入院途径",id,eobj.ADSOUDesc,"D",eobj)
  d eobj.%Close()
 }
 else 
 {
  s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
  s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("入院途径","web.DHCBL.CT.PACAdmSource","DeleteData",eobj)
  s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
 }
 q result
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-31
/// Description：查询入院途径的内容
/// Table： PAC_AdmSource
/// Input：rowid,code,desc,EpisodeType
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACAdmSource","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String, EpisodeType As %String) As %Query(ROWSPEC = "ADSOURowId:%String,ADSOUCode:%String,ADSOUDesc:%String,ADSOUDateFrom:%String,ADSOUDateTo:%String,ADSOUEpisodeType:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, EpisodeType As %String) As %Status
{
  s repid=$I(^CacheTemp)
  s ind=1
 
  //获取授权Json
  s AuStr=##class(web.DHCBL.Authorize.PACAdmSource).DHCGetDataByDefaultSession()
  s AuFlag=0
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
 
  if (rowid'="")   
  {
    s ADSOURowId=rowid
    s ADSOUCode=$p($g(^PAC("ADSOU",ADSOURowId)),"^",1)
    s ADSOUDesc=$p($g(^PAC("ADSOU",ADSOURowId)),"^",2)
    s ADSOUDateFrom=$p($g(^PAC("ADSOU",ADSOURowId)),"^",4)
    s ADSOUDateTo=$p($g(^PAC("ADSOU",ADSOURowId)),"^",5)
    s ADSOUEpisodeType=$p($g(^PAC("ADSOU",ADSOURowId)),"^",7)
    s:ADSOUDateFrom'="" ADSOUDateFrom=$zd(ADSOUDateFrom,1) 
    s:ADSOUDateTo'="" ADSOUDateTo=$zd(ADSOUDateTo,1)  
    s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="" 
    s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_AdmSource",ADSOURowId)
    s BDPInternalCode =$p($g(resultStr),"^",1)       
    s BDPInternalDesc = $p($g(resultStr),"^",2)  
    s BDPHospNationalCode=$p($g(resultStr),"^",3)         
    s BDPHospNationalDesc = $p($g(resultStr),"^",4)
    d OutputRow
 }
 else
 {
    s:code'="" code=$$ALPHAUP^SSUTIL4(code)  
    s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc)  
    s ADSOURowId=0
    for
    {
      s ADSOURowId=$o(^PAC("ADSOU",ADSOURowId))
      q:ADSOURowId=""
      ;筛选授权后的数据
      s strRowId="{ID:"_ADSOURowId_"}"
      if (AuStr[strRowId)||(AuFlag=1) 
      {
         s ADSOUCode=$p($g(^PAC("ADSOU",ADSOURowId)),"^",1)
         s ADSOUDesc=$p($g(^PAC("ADSOU",ADSOURowId)),"^",2) 
         s ADSOUDateFrom=$p($g(^PAC("ADSOU",ADSOURowId)),"^",4)
         s ADSOUDateTo=$p($g(^PAC("ADSOU",ADSOURowId)),"^",5)
         s ADSOUEpisodeType=$p($g(^PAC("ADSOU",ADSOURowId)),"^",7)
         s:ADSOUDateFrom'="" ADSOUDateFrom=$zd(ADSOUDateFrom,1)  
         s:ADSOUDateTo'="" ADSOUDateTo=$zd(ADSOUDateTo,1)  
         s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="" 
         s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_AdmSource",ADSOURowId)
         s BDPInternalCode =$p($g(resultStr),"^",1)       
         s BDPInternalDesc = $p($g(resultStr),"^",2)  
         s BDPHospNationalCode=$p($g(resultStr),"^",3)         
         s BDPHospNationalDesc = $p($g(resultStr),"^",4)
         if (desc'="")
         {
            ;需要对描述或者别名进行检索      
            s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_AdmSource",ADSOURowId,ADSOUDesc,desc)
         }
        else
        {
            s AliasFlag= 1   
        }    
        if ($ZCVT(ADSOUCode,"U")[code)&(AliasFlag=1)&((ADSOUEpisodeType=EpisodeType)||(EpisodeType=""))   
        {
           d OutputRow
        }
      }
    }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(ADSOURowId,ADSOUCode,ADSOUDesc,ADSOUDateFrom,ADSOUDateTo,ADSOUEpisodeType,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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
/// Description：查询入院途径的内容,用于combox查询
/// Table：User.PACAdmSource
/// Input：rowid,code,desc
/// Return：ADSOURowId,ADSOUCode,ADSOUDesc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACAdmSource","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ADSOURowId:%String,ADSOUCode:%String,ADSOUDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 //获取授权Json
 s AuStr=##class(web.DHCBL.Authorize.PACAdmSource).DHCGetDataByDefaultSession()
 s AuFlag=0
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
 
 if (rowid'="") //根据rowid返回该条记录
 {
    s ADSOURowId=rowid
    s ADSOUCode=$p($g(^PAC("ADSOU",ADSOURowId)),"^",1)
    s ADSOUDesc=$p($g(^PAC("ADSOU",ADSOURowId)),"^",2)
    d OutputRow2
 }
 else
 {
    s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
    s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
    s ADSOURowId=0
    for
    {
      s ADSOURowId=$o(^PAC("ADSOU",ADSOURowId))
      q:ADSOURowId=""
      s ADSOUDateFrom=$p($g(^PAC("ADSOU",ADSOURowId)),"^",4)
      continue:(ADSOUDateFrom'="")&&(ADSOUDateFrom>+$h)
      s ADSOUDateTo=$p($g(^PAC("ADSOU",ADSOURowId)),"^",5) 
      continue:(ADSOUDateTo'="")&&(ADSOUDateTo<+$h)
      //筛选授权后的数据
      s strRowId="{ID:"_ADSOURowId_"}"
      if (AuStr[strRowId)||(AuFlag=1)
      {
          s ADSOUCode=$p($g(^PAC("ADSOU",ADSOURowId)),"^",1)
          s ADSOUDesc=$p($g(^PAC("ADSOU",ADSOURowId)),"^",2)
          if (desc'="")
          {
            ;需要对描述或者别名进行检索      
            s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_AdmSource",ADSOURowId,ADSOUDesc,desc)
          }
          else
          {
            s AliasFlag= 1   
          }    
          if ($ZCVT(ADSOUCode,"U")[code)&(AliasFlag=1)  
          {
            d OutputRow2
          }
       }
   }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2
    set Data=$lb(ADSOURowId,ADSOUCode,ADSOUDesc)
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
