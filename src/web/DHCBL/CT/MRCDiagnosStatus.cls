Import SQLUser

/// 名称:诊断状态
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 丁亚男
/// 编写日期: 2017-12-21 
Class web.DHCBL.CT.MRCDiagnosStatus Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：dingyanan
/// CreatDate: 2017-12-21
/// Description：修改时打开的数据
/// Table：User.MRCDiagnosStatus
/// Input：id
ClassMethod OpenData(id As %String) As %String
{
 s str="" 
 s eobj = ##class(web.Entity.CT.MRCDiagnosStatus).%New()
 s eobj.DSTATRowId = id
 s eobj.DSTATCode = $p($g(^MRC("DSTAT",id)),"^",1)
 s eobj.DSTATDesc = $p($g(^MRC("DSTAT",id)),"^",2)
  
 s str = eobj.JsonS() 
 d eobj.%Close()
 s str = "{list:["_str_"]}"
 q str
}

/// Creator：dingyanan
/// CreatDate: 2017-12-21
/// Description：数据重复验证方法,js调用
/// Table：User.MRCDiagnosStatus
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s flag="",flagc="",flagd=""
 s:code'="" flagc=$d(^MRC("DSTAT",0,"Code",code))
 s:desc'="" flagd=$d(^MRC("DSTAT",0,"Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^MRC("DSTAT",0,"Code",code,0))
  s:desc'="" idd=$o(^MRC("DSTAT",0,"Desc",desc,0))
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

/// Creator：dingyanan
/// CreatDate: 2017-12-21
/// Description：数据重复验证方法
/// Table：User.MRCDiagnosStatus
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s flag="",flagc="",flagd=""
 s:code'="" flagc=$d(^MRC("DSTAT",0,"Code",code))
 s:desc'="" flagd=$d(^MRC("DSTAT",0,"Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^MRC("DSTAT",0,"Code",code,0))
  s:desc'="" idd=$o(^MRC("DSTAT",0,"Desc",desc,0))
  if ((idc'=id)&(flagc>0))||((idd'=id)&(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 q flag
}

/// Creator：dingyanan
/// CreatDate: 2017-12-21
/// Description：保存修改诊断状态的内容
/// Table：User.MRCDiagnosStatus
/// Input：web.Entity.CT.MRCDiagnosStatus 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.MRCDiagnosStatus).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.MRCDiagnosStatus) As %String
{
 s $zt="ERROE"
 s result="",flag=""
 if $IsObject(eobj)
 {
  s flag=..Validate(eobj.DSTATRowId,eobj.DSTATCode,eobj.DSTATDesc)  //调用重复验证
  if (flag=1)
  {
   s result = "{success:'false',errorinfo:'该记录已经存在！'}"
  }
  else
  {
   if (eobj.DSTATRowId="")  //如果RowId未赋值则增加
   {
    s obj=##class(User.MRCDiagnosStatus).%New()
   }
   else                        //如果RowId已赋值则修改
   {
    s obj=##class(User.MRCDiagnosStatus).%OpenId(eobj.DSTATRowId)
    s bobj=##class(web.Entity.CT.MRCDiagnosStatus).%New()
    s bobj.DSTATRowId=eobj.DSTATRowId
    s bobj.DSTATCode = obj.DSTATCode 
    s bobj.DSTATDesc=obj.DSTATDesc
   }
   Ts                    
   s obj.DSTATCode = eobj.DSTATCode          //修改代码
   s obj.DSTATDesc = eobj.DSTATDesc          //修改描述  
   s sc=obj.%Save()
   d obj.%Close()
   If $$$ISOK(sc)
   {
    Tc
    s id = obj.%Id()
    s result= "{success:'true',id:'"_id_"'}"         //返回RowId
    //保存日志
    d:eobj.DSTATRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MRC_DiagnosStatus","User.MRCDiagnosStatus","诊断状态",id,eobj.DSTATDesc,"A",eobj)
    d:eobj.DSTATRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MRC_DiagnosStatus","User.MRCDiagnosStatus","诊断状态",eobj.DSTATRowId,eobj.DSTATDesc,"U",eobj,bobj)
   }
   else
   {
    Trollback
    s result= "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"    
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("诊断状态","web.DHCBL.CT.MRCDiagnosStatus","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
   }
  }  
 }
 else
 {
   s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("诊断状态","web.DHCBL.CT.MRCDiagnosStatus","SaveEntity","")
   s ^ERRORLOGINFO(logid)="对象不存在！"
   s result= "{success:'false',errorinfo:'对象不存在！'}"
 }
 q result
ERROE
 s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("诊断状态","web.DHCBL.CT.MRCDiagnosStatus","SaveEntity",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator:dingyanan
/// CreatDate: 2017-12-21
/// Description：根据ID删除诊断状态的内容
/// Table：User.MRCDiagnosStatus
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
 s result=""
 s eobj = ##class(web.Entity.CT.MRCDiagnosStatus).%New()
 s eobj.DSTATRowId = id
 s eobj.DSTATCode = $p($g(^MRC("DSTAT",id)),"^",1)
 s eobj.DSTATDesc = $p($g(^MRC("DSTAT",id)),"^",2) 
 
 s sc=##class(User.MRCDiagnosStatus).%DeleteId(id)
 if $$$ISOK(sc)
 {
  s result= "{success:'true',info:'删除成功！'}"
  //保存日志
  d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MRC_DiagnosStatus","User.MRCDiagnosStatus","诊断状态",id,eobj.DSTATDesc,"D",eobj)
  d eobj.%Close()
 }
 else
 {
  s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"   
  s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("诊断状态","web.DHCBL.CT.MRCDiagnosStatus","DeleteData",eobj)
  s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
 }
 q result
}

/// Creator：dingyanan
/// CreatDate: 2017-12-21
/// Description：查询诊断状态的内容
/// Table： MRC_DiagnosStatus
/// Input：rowid,code,desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.MRCDiagnosStatus","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "DSTATRowId:%String,DSTATCode:%String,DSTATDesc:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 //获取授权Json
 s AuStr=##class(web.DHCBL.Authorize.MRCDiagnosStatus).DHCGetDataByDefaultSession()
 s AuFlag=0
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
 
 if (rowid'="") //根据rowid返回该条记录
 {
  s DSTATRowId=rowid
  s DSTATCode=$p($g(^MRC("DSTAT",DSTATRowId)),"^",1)
  s DSTATDesc=$p($g(^MRC("DSTAT",DSTATRowId)),"^",2)
  s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="" 
  s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("MRC_DiagnosStatus",DSTATRowId)
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
  s DSTATRowId=0
  for {
   s DSTATRowId=$o(^MRC("DSTAT",DSTATRowId))
   q:DSTATRowId=""
   //筛选授权后的数据
   s strRowId="{ID:"_DSTATRowId_"}"
   if (AuStr[strRowId)||(AuFlag=1) 
   {
     s DSTATCode=$p($g(^MRC("DSTAT",DSTATRowId)),"^",1)
     s DSTATDesc=$p($g(^MRC("DSTAT",DSTATRowId)),"^",2) 
     s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="" 
     s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("MRC_DiagnosStatus",DSTATRowId)
     s BDPInternalCode =$p($g(resultStr),"^",1)       
     s BDPInternalDesc = $p($g(resultStr),"^",2)  
     s BDPHospNationalCode=$p($g(resultStr),"^",3)         
     s BDPHospNationalDesc = $p($g(resultStr),"^",4)
     if (desc'="")
     {
       ;需要对描述或者别名进行检索      
       s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("MRC_DiagnosStatus",DSTATRowId,DSTATDesc,desc)
     }
     else
     {
       s AliasFlag=1   
     } 
     if ($ZCVT(DSTATCode,"U")[code)&(AliasFlag=1)   
     {
       d OutputRow
     }
   }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(DSTATRowId,DSTATCode,DSTATDesc,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Creator：dingyanan
/// CreatDate: 2017-12-21
/// Description：查询诊断状态的内容,用于combox查询
/// Table：User.MRCDiagnosStatus
/// Input：rowid,code,desc
/// Return：DSTATRowId,DSTATCode,DSTATDesc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.MRCDiagnosStatus","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "DSTATRowId:%String,DSTATCode:%String,DSTATDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 //获取授权Json
 s AuStr=##class(web.DHCBL.Authorize.MRCDiagnosStatus).DHCGetDataByDefaultSession()
 s AuFlag=0
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
 
 if (rowid'="") //根据rowid返回该条记录
 {
  s DSTATRowId=rowid
  s DSTATCode=$p($g(^MRC("DSTAT",DSTATRowId)),"^",1)
  s DSTATDesc=$p($g(^MRC("DSTAT",DSTATRowId)),"^",2)
  d OutputRow2
 }
 else
 {
  s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
  s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
  s DSTATRowId=0
  for
  {
   s DSTATRowId=$o(^MRC("DSTAT",DSTATRowId))
   q:DSTATRowId=""
   //筛选授权后的数据
   s strRowId="{ID:"_DSTATRowId_"}"
   if (AuStr[strRowId)||(AuFlag=1) 
   {
     s DSTATCode=$p($g(^MRC("DSTAT",DSTATRowId)),"^",1)
     s DSTATDesc=$p($g(^MRC("DSTAT",DSTATRowId)),"^",2)
     if (desc'="")
     {
       ;需要对描述或者别名进行检索      
       s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("MRC_DiagnosStatus",DSTATRowId,DSTATDesc,desc)
     }
     else
     {
       s AliasFlag=1   
     } 
     if ($ZCVT(DSTATCode,"U")[code)&(AliasFlag=1) 
     {
       d OutputRow2
     }
    }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2
    set Data=$lb(DSTATRowId,DSTATCode,DSTATDesc)
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
