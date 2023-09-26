Import SQLUser

/// 名称: 患者类别
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-sunfengchao
/// 编写日期: 2012-8-30
Class web.DHCBL.CT.CTSocialStatus Extends %RegisteredObject [ ProcedureBlock ]
{

Parameter SQLTableName = "CT_SocialStatus";

/// Creator：sunfengchao
/// CreatDate: 2012-12-3
/// Description：修改时打开的数据
/// Table：User.CTSocialStatus
/// Input：id
ClassMethod OpenData(id As %String) As %String
{
 s str="" 
 s eobj = ##class(web.Entity.CT.CTSocialStatus).%New()
 s eobj.SSRowId = id
 s eobj.SSCode=$p($g(^CT("SS",id)),"^",1)
 s eobj.SSDesc=$p($g(^CT("SS",id)),"^",2)
 
 s str = eobj.JsonS() 
 d eobj.%Close()
 s str = "{list:["_str_"]}"
 q str
}

/// Creator：sunfengchao
/// CreatDate: 2012-12-3
/// Description：数据重复验证方法,js调用
/// Table：User.CTSocialStatus
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String, hospid As %String = "") As %String
{
    s flag=0
    if $$ALPHAUP^SSUTIL4(code)'=""
    {
        s idc=0
        for
        {
            s idc=$o(^CT("SS",0,"Code",$$ALPHAUP^SSUTIL4(code),idc)) q:idc=""
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
    
            s idd=$o(^CT("SS",0,"Desc",$$ALPHAUP^SSUTIL4(desc),idd)) q:idd=""
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

/// Creator：sunfengchao
/// CreatDate: 2012-11-7
/// Description：数据重复验证方法
/// Table：User.CTSocialStatus
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s flag="",flagc="",flagd=""
 s:code'="" flagc=$d(^CT("SS",0,"Code",code))
 s:desc'="" flagd=$d(^CT("SS",0,"Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^CT("SS",0,"Code",code,0))
  s:desc'="" idd=$o(^CT("SS",0,"Desc",desc,0))
  if ((idc'=id)&(flagc>0))||((idd'=id)&(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 q flag
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-30
/// Description：保存修改患者类别的内容
/// Table：User.CTSocialStatus
/// Input：web.Entity.CT.CTSocialStatus 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.CTSocialStatus).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.CTSocialStatus) As %String
{
 s $zt="ERROE"
 s result=""
 if $IsObject(eobj)
 {
  s flag=..FormValidate(eobj.SSRowId,eobj.SSCode,eobj.SSDesc,eobj.LinkHospId)  //调用重复验证
  if (flag=1)
  {
   s result = "{success:'false',errorinfo:'该记录已经存在！'}"
  }
  else
  {
   if (eobj.SSRowId="")  //如果RowId未赋值则增加
   {
    s obj=##class(User.CTSocialStatus).%New()
   }
   else      //如果RowId已赋值则修改
   {
    s obj=##class(User.CTSocialStatus).%OpenId(eobj.SSRowId)
    s bobj=##class(web.Entity.CT.CTSocialStatus).%New()
    s bobj.SSRowId=eobj.SSRowId
    s bobj.SSCode = obj.SSCode         
    s bobj.SSDesc = obj.SSDesc          
   }
   Ts   
   s obj.SSCode = eobj.SSCode          //修改代码
   s obj.SSDesc = eobj.SSDesc          //修改描述  
   s sc=obj.%Save()
   d obj.%Close()
   If $$$ISOK(sc)
   {
    Tc
    s id = obj.%Id()
    s result= "{success:'true',id:'"_id_"'}"         //返回RowId
    //保存日志
    d:eobj.SSRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_SocialStatus","User.CTSocialStatus","患者类别",id,eobj.SSDesc,"A",eobj)
    d:eobj.SSRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_SocialStatus","User.CTSocialStatus","患者类别",eobj.SSRowId,eobj.SSDesc,"U",eobj,bobj)
   }
   else
   {
    Trollback
    s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" 
    s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("患者类别","web.DHCBL.CT.CTSocialStatus","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   }
  }  
 }
 else
 {
  s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("患者类别","web.DHCBL.CT.CTSocialStatus","SaveEntity","")
  s ^ERRORLOGINFO(logid)="对象不存在！"
  s result= "{success:'false',errorinfo:'对象不存在！'}"
 }
 q result
ERROE
 s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("患者类别","web.DHCBL.CT.CTSocialStatus","SaveEntity",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Function:用于数据删除时的逻辑判断
/// CreateDate:2020-06-29
/// Ctreator:chenying
/// Input:rowid 
/// Output:返回一个标志位，0为未被引用，表示可以被删除，1表示已经被引用了，不能被删除
/// debug: w ##class(web.DHCBL.CT.CTSocialStatus).GetRefFlag("")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    if $d(^DHCPACADM(0,"Socal",id)) s myInfo=myInfo_"<病人类别与费别对照>"   //DHC_PACADM
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

/// Creator：sunfengchao
/// CreatDate: 2012-8-30
/// Description：根据ID删除患者类别的内容
/// Table：User.CTSocialStatus
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
    s result=""
    s re=..GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag=1)
    {
        s result="{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    else
    {
        s eobj = ##class(web.Entity.CT.CTSocialStatus).%New()
        s eobj.SSRowId = id
        s eobj.SSCode=$p($g(^CT("SS",id)),"^",1)
        s eobj.SSDesc=$p($g(^CT("SS",id)),"^",2)

        s sc=##class(User.CTSocialStatus).%DeleteId(id)
        if $$$ISOK(sc)
        {
            s result= "{success:'true',info:'删除成功！'}"
            //保存日志
            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_SocialStatus","User.CTSocialStatus","患者类别",id,eobj.SSDesc,"D",eobj)
            d eobj.%Close()
        }
        else
        {
            s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("患者类别","web.DHCBL.CT.CTSocialStatus","DeleteData",eobj)
            s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
        }
    }
    q result
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-30
/// Description：查询患者类别的内容
/// Table： CT_SocialStatus
/// Input：rowid,code,desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTSocialStatus","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "SSRowId:%String,SSCode:%String,SSDesc:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, hospid As %String) As %Status
{
  s repid=$I(^CacheTemp)
  s ind=1
 
  //获取授权Json
  s AuStr=##class(web.DHCBL.Authorize.CTSocialStatus).DHCGetDataByDefaultSession()
  s AuFlag=0
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
 
  if (rowid'="") //根据rowid返回该条记录
  {
    s SSRowId=rowid
    s SSCode=$p($g(^CT("SS",SSRowId)),"^",1)
    s SSDesc=$p($g(^CT("SS",SSRowId)),"^",2)
    s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""
    s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_SocialStatus",SSRowId)
    s BDPInternalCode =$p($g(resultStr),"^",1)       
    s BDPInternalDesc = $p($g(resultStr),"^",2)  
    s BDPHospNationalCode=$p($g(resultStr),"^",3)         
    s BDPHospNationalDesc = $p($g(resultStr),"^",4) 
    d OutputRow
  }
  else
  {
    s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
    s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
    s SSRowId=0
    for
    {
      s SSRowId=$o(^CT("SS",SSRowId))
      q:SSRowId=""
      //筛选授权后的数据
      s strRowId="{ID:"_SSRowId_"}"
      if (AuStr[strRowId)||(AuFlag=1) {
      s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,SSRowId,hospid)
      continue:showflag="N"
      
      s SSCode=$p($g(^CT("SS",SSRowId)),"^",1)
      s SSDesc=$p($g(^CT("SS",SSRowId)),"^",2) 
      s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""
      s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_SocialStatus",SSRowId)
      s BDPInternalCode =$p($g(resultStr),"^",1)       
      s BDPInternalDesc = $p($g(resultStr),"^",2)  
      s BDPHospNationalCode=$p($g(resultStr),"^",3)         
      s BDPHospNationalDesc = $p($g(resultStr),"^",4) 
      if (desc'="")
      {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_SocialStatus",SSRowId,SSDesc,desc)
      }
      else
      {
         s AliasFlag= 1   
      }   
      if ($ZCVT(SSCode,"U")[code)&(AliasFlag=1)  
      {
        d OutputRow
      }
    }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(SSRowId,SSCode,SSDesc,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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
/// Description：查询患者类别的内容,用于combox查询
/// Table：User.CTSocialStatus
/// Input：rowid,code,desc
/// Return：SSRowId,SSCode,SSDesc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTSocialStatus","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "SSRowId:%String,SSCode:%String,SSDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, hospid As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 //获取授权Json
 s AuStr=##class(web.DHCBL.Authorize.CTSocialStatus).DHCGetDataByDefaultSession()
 s AuFlag=0
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
 
 if (rowid'="") //根据rowid返回该条记录
 {
  s SSRowId=rowid
  s SSCode=$p($g(^CT("SS",SSRowId)),"^",1)
  s SSDesc=$p($g(^CT("SS",SSRowId)),"^",2)
  d OutputRow2
 }
 else
 {
  s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
  s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
  s SSRowId=0
  for
  {
   s SSRowId=$o(^CT("SS",SSRowId))
   q:SSRowId=""
   //筛选授权后的数据
   s strRowId="{ID:"_SSRowId_"}"
   if (AuStr[strRowId)||(AuFlag=1) 
   {
      s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,SSRowId,hospid)
      continue:showflag="N"
      
      s SSCode=$p($g(^CT("SS",SSRowId)),"^",1)
      s SSDesc=$p($g(^CT("SS",SSRowId)),"^",2)
      if (desc'="")
      {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_SocialStatus",SSRowId,SSDesc,desc)
      }
      else
      {
         s AliasFlag= 1   
      }   
      if ($ZCVT(SSCode,"U")[code)&(AliasFlag=1) 
      {
        d OutputRow2
      }
    }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2
    set Data=$lb(SSRowId,SSCode,SSDesc)
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
