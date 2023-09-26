/// 名称: 就诊子类型维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-sunfengchao
/// 编写日期: 2012-8-30
Class web.DHCBL.CT.PACEpisodeSubType Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：sunfengchao
/// CreatDate: 2012-12-3
/// Description：修改时打开的数据
/// Table：User.PACEpisodeSubType
/// Input：id
ClassMethod OpenData(id As %String) As %String
{
 s str="" 
 s eobj = ##class(web.Entity.CT.PACEpisodeSubType).%New()
 s eobj.SUBTRowId = id
 s eobj.SUBTCode=$p($g(^PAC("SUBT",id)),"^",1)
 s eobj.SUBTDesc=$p($g(^PAC("SUBT",id)),"^",2)
 s eobj.SUBTAdmType=$p($g(^PAC("SUBT",id)),"^",3)
 s eobj.SUBTDateFrom=$p($g(^PAC("SUBT",id)),"^",8)
 s eobj.SUBTDateTo=$p($g(^PAC("SUBT",id)),"^",9)
 s eobj.SUBTDaySurgery=$p($g(^PAC("SUBT",id)),"^",4)
 s eobj.SUBTFirstRegDayNight=$p($g(^PAC("SUBT",id)),"^",5)
 s:eobj.SUBTDateFrom'="" eobj.SUBTDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.SUBTDateFrom) //转换日期格式
 s:eobj.SUBTDateTo'="" eobj.SUBTDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.SUBTDateTo) //转换日期格式
 s str = eobj.JsonS() 
 d eobj.%Close()
 s str = "{list:["_str_"]}"
 q str
}

/// Creator：sunfengchao
/// CreatDate: 2012-12-3
/// Description：数据重复验证方法,js调用
/// Table：User.PACEpisodeSubType
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s flag="",flagc="",flagd=""
 s:code'="" flagc=$d(^PAC("SUBT",0,"Code",code))
 s:desc'="" flagd=$d(^PAC("SUBT",0,"Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^PAC("SUBT",0,"Code",code,0))
  s:desc'="" idd=$o(^PAC("SUBT",0,"Desc",desc,0))
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

/// Creator：   sunfengchao
/// CreatDate:  2012-11-7
/// Description 数据重复验证方法
/// Table：     User.PACEpisodeSubType
/// Input：     id, code, desc
/// Return：    "1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s flag="",flagc="",flagd=""
 s:code'="" flagc=$d(^PAC("SUBT",0,"Code",code))
 s:desc'="" flagd=$d(^PAC("SUBT",0,"Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^PAC("SUBT",0,"Code",code,0))
  s:desc'="" idd=$o(^PAC("SUBT",0,"Desc",desc,0))
  if ((idc'=id)&(flagc>0))||((idd'=id)&(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 q flag
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-30
/// Description：保存修改就诊子类型的内容
/// Table：User.PACEpisodeSubType
/// Input：web.Entity.CT.PACEpisodeSubType 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.PACEpisodeSubType).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.PACEpisodeSubType) As %String
{
 s $zt="ERROE"
 s result=""
 if $IsObject(eobj)
 {
  s:eobj.SUBTDateFrom'="" eobj.SUBTDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.SUBTDateFrom)  //转换日期
  s:eobj.SUBTDateTo'="" eobj.SUBTDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.SUBTDateTo)      //转换日期
  s:eobj.SUBTDateFrom="" eobj.SUBTDateFrom=+$h
  s flag=..Validate(eobj.SUBTRowId,eobj.SUBTCode,eobj.SUBTDesc)  //调用重复验证
  if (flag=1)
  {
   s result = "{success:'false',errorinfo:'该记录已经存在！'}"
  }
  else
  {
   if (eobj.SUBTRowId="")  //如果RowId未赋值则增加
   {
    s obj=##class(User.PACEpisodeSubType).%New()
   }
   else                    //如果RowId已赋值则修改
   {
    s obj=##class(User.PACEpisodeSubType).%OpenId(eobj.SUBTRowId)
    s bobj=##class(web.Entity.CT.PACEpisodeSubType).%New()
    s bobj.SUBTRowId=eobj.SUBTRowId
    s bobj.SUBTCode = obj.SUBTCode          
    s bobj.SUBTDesc = obj.SUBTDesc          
    s bobj.SUBTAdmType = obj.SUBTAdmType
    s bobj.SUBTDateFrom = obj.SUBTDateFrom 
    s bobj.SUBTDateTo = obj.SUBTDateTo 
    s bobj.SUBTDaySurgery= obj.SUBTDaySurgery
    s bobj.SUBTFirstRegDayNight=obj.SUBTFirstRegDayNight    
   }
   Ts                    
   s obj.SUBTCode = eobj.SUBTCode          //修改代码
   s obj.SUBTDesc = eobj.SUBTDesc          //修改描述
   s obj.SUBTAdmType = eobj.SUBTAdmType
   s obj.SUBTDateFrom = eobj.SUBTDateFrom  //修改开始日期
   s obj.SUBTDateTo = eobj.SUBTDateTo      //修改结束日期
   s:eobj.SUBTDaySurgery="" eobj.SUBTDaySurgery="N"
   s obj.SUBTDaySurgery=eobj.SUBTDaySurgery
   s obj.SUBTFirstRegDayNight=eobj.SUBTFirstRegDayNight
   s sc=obj.%Save()
   d obj.%Close()
   If $$$ISOK(sc)
   {
    Tc
    s id = obj.%Id()
    s result= "{success:'true',id:'"_id_"'}"         //返回RowId
    //保存日志
    d:eobj.SUBTRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_EpisodeSubType","User.PACEpisodeSubType","就诊子类型",id,eobj.SUBTDesc,"A",eobj)
    d:eobj.SUBTRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_EpisodeSubType","User.PACEpisodeSubType","就诊子类型",eobj.SUBTRowId,eobj.SUBTDesc,"U",eobj,bobj)
   }
   else
   {
    Trollback
    s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
    d ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("就诊子类型","web.DHCBL.CT.PACEpisodeSubType","SaveEntity",eobj) 
   }
  }    
 }
 else
 {
  s result= "{success:'false',errorinfo:'对象不存在！'}"
 }
 q result
ERROE
 q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// CreatDate:2017-1-23
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
   s return="",myInfo=""
   if ($d(^DHCTAREP(0,"EP",id))) 
   {
      s myInfo=myInfo_"<病人就诊类别与标准价格>"
      s return="1^在"_myInfo_"表里被引用,不能删除!"
   }
   else
   {
       s return="0^未被引用可删除！"
   }   
    q return
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-30
/// Description：根据ID删除就诊子类型的内容
/// Table：User.PACEpisodeSubType
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
 s result=""
 s eobj = ##class(web.Entity.CT.PACEpisodeSubType).%New()
 s eobj.SUBTRowId = id
 s eobj.SUBTCode=$p($g(^PAC("SUBT",id)),"^",1)
 s eobj.SUBTDesc=$p($g(^PAC("SUBT",id)),"^",2)
 s eobj.SUBTAdmType=$p($g(^PAC("SUBT",id)),"^",3)
 s eobj.SUBTDaySurgery=$p($g(^PAC("SUBT",id)),"^",4)
 s eobj.SUBTFirstRegDayNight=$p($g(^PAC("SUBT",id)),"^",5)
 s eobj.SUBTDateFrom=$p($g(^PAC("SUBT",id)),"^",8)
 s eobj.SUBTDateTo=$p($g(^PAC("SUBT",id)),"^",9)
 s re=..GetRefFlag(id)
 s RefFlag=$p(re,"^",1)
 if (RefFlag=1)
 {
    s result="{success:'false',info:'"_$p(re,"^",2)_"'}"
    s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("就诊子类型","web.DHCBL.CT.PACEpisodeSubType","DeleteData",eobj)
    s ^ERRORLOGINFO(logid)= "删除失败:<病人就诊类别与标准价格>表里被引用,不能删除!"
 }
 else
 {
     s sc=##class(User.PACEpisodeSubType).%DeleteId(id)
     if $$$ISOK(sc)
     {
          s result= "{success:'true',info:'删除成功！'}" 
          //保存日志
          d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_EpisodeSubType","User.PACEpisodeSubType","就诊子类型",id,eobj.SUBTDesc,"D",eobj)
          d eobj.%Close()
     }
     else 
     {
          s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
          s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("就诊子类型","web.DHCBL.CT.PACEpisodeSubType","DeleteData",eobj)
          s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
     }
 }
    q result
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-30
/// Description：查询就诊子类型的内容
/// Table： PAC_EpisodeSubType
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACEpisodeSubType","GetList","","","","")
Query GetList(rowid As %String, code As %String, desc As %String, AdmType As %String) As %Query(ROWSPEC = "SUBTRowId:%String,SUBTCode:%String,SUBTDesc:%String,SUBTAdmType:%String,SUBTDaySurgery,SUBTFirstRegDayNight,SUBTDateFrom:%String,SUBTDateTo:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, AdmType As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 //获取授权Json
 s AuStr=##class(web.DHCBL.Authorize.PACEpisodeSubType).DHCGetDataByDefaultSession()
 s AuFlag=0
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
 
 if (rowid'="") //根据rowid返回该条记录
 {
   s SUBTRowId=rowid
   s SUBTCode=$p($g(^PAC("SUBT",SUBTRowId)),"^",1)
   s SUBTDesc=$p($g(^PAC("SUBT",SUBTRowId)),"^",2)
   s SUBTAdmType=$p($g(^PAC("SUBT",SUBTRowId)),"^",3)
   s SUBTDaySurgery=$p($g(^PAC("SUBT",SUBTRowId)),"^",4)
   s SUBTFirstRegDayNight=$p($g(^PAC("SUBT",SUBTRowId)),"^",5)
   s SUBTDateFrom=$p($g(^PAC("SUBT",SUBTRowId)),"^",8)
   s SUBTDateTo=$p($g(^PAC("SUBT",SUBTRowId)),"^",9)
   s:SUBTDateFrom'="" SUBTDateFrom=$zd(SUBTDateFrom,1)  
   s:SUBTDateTo'="" SUBTDateTo=$zd(SUBTDateTo,1)  
   s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
   s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_EpisodeSubType",SUBTRowId)
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
  s SUBTRowId=0
  for
  {
    s SUBTRowId=$o(^PAC("SUBT",SUBTRowId))
    q:SUBTRowId=""
    ;筛选授权后的数据
    s strRowId="{ID:"_SUBTRowId_"}"
    if (AuStr[strRowId)||(AuFlag=1)
    {
      s SUBTCode=$p($g(^PAC("SUBT",SUBTRowId)),"^",1)
      s SUBTDesc=$p($g(^PAC("SUBT",SUBTRowId)),"^",2) 
      s SUBTAdmType=$p($g(^PAC("SUBT",SUBTRowId)),"^",3)
      s SUBTDaySurgery=$p($g(^PAC("SUBT",SUBTRowId)),"^",4)
      s SUBTFirstRegDayNight=$p($g(^PAC("SUBT",SUBTRowId)),"^",5)
      s SUBTDateFrom=$p($g(^PAC("SUBT",SUBTRowId)),"^",8)
      s SUBTDateTo=$p($g(^PAC("SUBT",SUBTRowId)),"^",9)
      s:SUBTDateFrom'="" SUBTDateFrom=$zd(SUBTDateFrom,1)  
      s:SUBTDateTo'="" SUBTDateTo=$zd(SUBTDateTo,1) 
      s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
      s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_EpisodeSubType",SUBTRowId)
      s BDPInternalCode =$p($g(resultStr),"^",1)       
      s BDPInternalDesc = $p($g(resultStr),"^",2)  
      s BDPHospNationalCode=$p($g(resultStr),"^",3)         
      s BDPHospNationalDesc = $p($g(resultStr),"^",4)
      if (desc'="")
      {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_EpisodeSubType",SUBTRowId,SUBTDesc,desc)
      }
      else
      {
         s AliasFlag=1   
      } 
      if ($ZCVT(SUBTCode,"U")[code)&(AliasFlag=1)&((SUBTAdmType=AdmType)||(AdmType=""))  
      {
        d OutputRow
      }
    }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(SUBTRowId,SUBTCode,SUBTDesc,SUBTAdmType,SUBTDaySurgery,SUBTFirstRegDayNight,SUBTDateFrom,SUBTDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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
/// Description：查询就诊子类型的内容,用于combox查询
/// Table：User.PACEpisodeSubType
/// Input：rowid,code,desc
/// Return：SUBTRowId,SUBTCode,SUBTDesc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACEpisodeSubType","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "SUBTRowId:%String,SUBTCode:%String,SUBTDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 //获取授权Json
 s AuStr=##class(web.DHCBL.Authorize.PACEpisodeSubType).DHCGetDataByDefaultSession()
 s AuFlag=0
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
 
 if (rowid'="") //根据rowid返回该条记录
 {
  s SUBTRowId=rowid
  s SUBTCode=$p($g(^PAC("SUBT",SUBTRowId)),"^",1)
  s SUBTDesc=$p($g(^PAC("SUBT",SUBTRowId)),"^",2)
  d OutputRow2
 }
 else
 {
  s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
  s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
  s SUBTRowId=0
  for
  {
   s SUBTRowId=$o(^PAC("SUBT",SUBTRowId))
   q:SUBTRowId=""
   
   s SUBTDateFrom=$p($g(^PAC("SUBT",SUBTRowId)),"^",8) 
   continue:(SUBTDateFrom'="")&&(SUBTDateFrom>+$h)
   s SUBTDateTo=$p($g(^PAC("SUBT",SUBTRowId)),"^",9)
   continue:(SUBTDateTo'="")&&(SUBTDateTo<+$h)
   s strRowId="{ID:"_SUBTRowId_"}"
   if (AuStr[strRowId)||(AuFlag=1) 
   {
    s SUBTCode=$p($g(^PAC("SUBT",SUBTRowId)),"^",1)
    s SUBTDesc=$p($g(^PAC("SUBT",SUBTRowId)),"^",2)
    if (desc'="")
    {
        ;需要对描述或者别名进行检索      
        s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_EpisodeSubType",SUBTRowId,SUBTDesc,desc)
    }
    else
    {
        s AliasFlag=1   
    } 
    if ($ZCVT(SUBTCode,"U")[code)&(AliasFlag=1)  
    {
        d OutputRow2
    }
   }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2
    set Data=$lb(SUBTRowId,SUBTCode,SUBTDesc)
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
