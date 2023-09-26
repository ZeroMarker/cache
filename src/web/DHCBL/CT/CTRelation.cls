/// 名称: 家庭关系维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-sunfengchao
/// 编写日期: 2012-8-30
Class web.DHCBL.CT.CTRelation Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：sunfengchao
/// CreatDate: 2012-12-3
/// Description：修改时打开的数据
/// Table：User.CTRelation
/// Input：id
ClassMethod OpenData(id As %String) As %String
{
 s str="" 
 s eobj = ##class(web.Entity.CT.CTRelation).%New()
 s eobj.CTRLTRowId = id
 s eobj.CTRLTCode=$p($g(^CT("RLT",id)),"^",1)
 s eobj.CTRLTDesc=$p($g(^CT("RLT",id)),"^",2)
 s eobj.CTRLTDateFrom=$p($g(^CT("RLT",id)),"^",3)
 s eobj.CTRLTDateTo=$p($g(^CT("RLT",id)),"^",4)
  
 s:eobj.CTRLTDateFrom'="" eobj.CTRLTDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.CTRLTDateFrom) //转换日期格式
 s:eobj.CTRLTDateTo'="" eobj.CTRLTDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.CTRLTDateTo) //转换日期格式
 
 s str = eobj.JsonS() 
 d eobj.%Close()
 s str = "{list:["_str_"]}"
 q str
}

/// Creator：sunfengchao
/// CreatDate: 2012-12-3
/// Description：数据重复验证方法,js调用
/// Table：User.CTRelation
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s flag="",flagc="",flagd=""
 s:code'="" flagc=$d(^CT("RLT",0,"Code",code))
 s:desc'="" flagd=$d(^CT("RLT",0,"Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^CT("RLT",0,"Code",code,0))
  s:desc'="" idd=$o(^CT("RLT",0,"Desc",desc,0))
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
/// Table：User.CTRelation
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s flag="",flagc="",flagd=""
 s:code'="" flagc=$d(^CT("RLT",0,"Code",code))
 s:desc'="" flagd=$d(^CT("RLT",0,"Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^CT("RLT",0,"Code",code,0))
  s:desc'="" idd=$o(^CT("RLT",0,"Desc",desc,0))
  if ((idc'=id)&(flagc>0))||((idd'=id)&(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 q flag
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-30
/// Description：保存修改家庭关系的内容
/// Table：User.CTRelation
/// Input：web.Entity.CT.CTRelation 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.CTRelation).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.CTRelation) As %String
{
 s $zt="ERROE"
 s result=""
 if $IsObject(eobj)
 {
  s:eobj.CTRLTDateFrom'="" eobj.CTRLTDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTRLTDateFrom) //转换日期
  s:eobj.CTRLTDateTo'="" eobj.CTRLTDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTRLTDateTo)      //转换日期
  s:eobj.CTRLTDateFrom="" eobj.CTRLTDateFrom=+$h
  s flag=..Validate(eobj.CTRLTRowId,eobj.CTRLTCode,eobj.CTRLTDesc)  //调用重复验证
  if (flag=1)
  {
   s result = "{success:'false',errorinfo:'该记录已经存在！'}"
  }
  else
  {
   if (eobj.CTRLTRowId="")  //如果RowId未赋值则增加
   {
    s obj=##class(User.CTRelation).%New()
   }
   else                     //如果RowId已赋值则修改
   {
     s obj=##class(User.CTRelation).%OpenId(eobj.CTRLTRowId)
     s bobj=##class(web.Entity.CT.CTRelation).%New()
     s bobj.CTRLTRowId=eobj.CTRLTRowId
     s bobj.CTRLTCode = obj.CTRLTCode          
     s bobj.CTRLTDesc = obj.CTRLTDesc          
     s bobj.CTRLTDateFrom = obj.CTRLTDateFrom   
     s bobj.CTRLTDateTo = obj.CTRLTDateTo      
   }
   Ts          
   s obj.CTRLTCode = eobj.CTRLTCode          //修改代码
   s obj.CTRLTDesc = eobj.CTRLTDesc          //修改描述
   s obj.CTRLTDateFrom = eobj.CTRLTDateFrom  //修改开始日期
   s obj.CTRLTDateTo = eobj.CTRLTDateTo      //修改结束日期
   s sc=obj.%Save()
   d obj.%Close()
   If $$$ISOK(sc)
   {
    Tc
    s id = obj.%Id()
    s result= "{success:'true',id:'"_id_"'}"         //返回RowId
    //保存日志
    d:eobj.CTRLTRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Relation","User.CTRelation","家庭关系",id,eobj.CTRLTDesc,"A",eobj)
    d:eobj.CTRLTRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Relation","User.CTRelation","家庭关系",eobj.CTRLTRowId,eobj.CTRLTDesc,"U",eobj,bobj)
   }
   else
   {
    Trollback
    s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    
    s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("家庭关系","web.DHCBL.CT.CTRelation","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   }
  }   
 }
 else
 {
  s result= "{success:'false',errorinfo:'对象不存在！'}"
  s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("家庭关系","web.DHCBL.CT.CTRelation","SaveEntity",eobj)
  s ^ERRORLOGINFO(logid)="对象不存在！"
 }
 q result
ERROE
  s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("家庭关系","web.DHCBL.CT.CTRelation","SaveEntity",eobj)
  s ^ERRORLOGINFO(logid)=$ze
  q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Function: 用于删除时的逻辑判断 
/// Creator:  sunfengchao
/// CreateDate: 2018-11-13
/// Debug:w ##class(web.DHCBL.CT.CTRelation).GetRefFlag("1")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return=""
    s myInfo=""
    s found1=0
    s PAPERRowId=0 
    for
    {
      s PAPERRowId=$o(^PAPER(PAPERRowId))  
      q:PAPERRowId=""  
      q:found1=1
      s PAPERCTRLTDR=$p($g(^PAPER(PAPERRowId,"EMP")),"^",4) 
      if PAPERCTRLTDR=id s found1=1
   }
   if (found1=1)  s myInfo=myInfo_"<患者基本信息>"
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
/// Description：根据ID删除家庭关系的内容
/// Table：User.CTRelation
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
 s result=""
 s re=##class(web.DHCBL.CT.CTRelation).GetRefFlag(id)
 s RefFlag=$p(re,"^",1)
 if (RefFlag=1)
 {
    s result="{success:'false',info:'"_$p(re,"^",2)_"'}"
 }
 else
 {  
     s eobj = ##class(web.Entity.CT.CTRelation).%New()
     s eobj.CTRLTRowId = id
     s eobj.CTRLTCode=$p($g(^CT("RLT",id)),"^",1)
     s eobj.CTRLTDesc=$p($g(^CT("RLT",id)),"^",2)
     s eobj.CTRLTDateFrom=$p($g(^CT("RLT",id)),"^",3)
     s eobj.CTRLTDateTo=$p($g(^CT("RLT",id)),"^",4) 
     s sc= ##class(User.CTRelation).%DeleteId(id)
     if $$$ISOK(sc)
     {
        s result= "{success:'true',info:'删除成功！'}"  
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Relation","User.CTRelation","家庭关系",id,eobj.CTRLTDesc,"D",eobj)
        d eobj.%Close()
     }
     else 
     {
        s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("家庭关系","web.DHCBL.CT.CTRelation","DeleteData",eobj)
        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
     }
 }
 q result
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-30
/// Description：查询家庭关系的内容
/// Table： CT_Relation
/// Input：rowid,code,desc
/// Update: update by sunfengchao 
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTRelation","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CTRLTRowId:%String,CTRLTCode:%String,CTRLTDesc:%String,CTRLTDateFrom:%String,CTRLTDateTo:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc ")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 //获取授权Json
 s AuStr=##class(web.DHCBL.Authorize.CTRelation).DHCGetDataByDefaultSession()
 s AuFlag=0
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
 
 if (rowid'="") //根据rowid返回该条记录
 {
  s CTRLTRowId=rowid
  s CTRLTCode=$p($g(^CT("RLT",CTRLTRowId)),"^",1)
  s CTRLTDesc=$p($g(^CT("RLT",CTRLTRowId)),"^",2)
  s CTRLTDateFrom=$p($g(^CT("RLT",CTRLTRowId)),"^",3)
  s CTRLTDateTo=$p($g(^CT("RLT",CTRLTRowId)),"^",4)
  s:CTRLTDateFrom'="" CTRLTDateFrom=$zd(CTRLTDateFrom,1)  
  s:CTRLTDateTo'="" CTRLTDateTo=$zd(CTRLTDateTo,1)  
  s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""
  s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_Relation",CTRLTRowId)
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
   s CTRLTRowId=0
   for {
   s CTRLTRowId=$o(^CT("RLT",CTRLTRowId))
   q:CTRLTRowId=""
   //筛选授权后的数据
   s strRowId="{ID:"_CTRLTRowId_"}"
   if (AuStr[strRowId)||(AuFlag=1) {
    s CTRLTCode=$p($g(^CT("RLT",CTRLTRowId)),"^",1)
    s CTRLTDesc=$p($g(^CT("RLT",CTRLTRowId)),"^",2) 
    s CTRLTDateFrom=$p($g(^CT("RLT",CTRLTRowId)),"^",3)
    s CTRLTDateTo=$p($g(^CT("RLT",CTRLTRowId)),"^",4)
    s:CTRLTDateFrom'="" CTRLTDateFrom=$zd(CTRLTDateFrom,1) 
    s:CTRLTDateTo'="" CTRLTDateTo=$zd(CTRLTDateTo,1)  
    s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""
    s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_Relation",CTRLTRowId)
    s BDPInternalCode =$p($g(resultStr),"^",1)       
    s BDPInternalDesc = $p($g(resultStr),"^",2)  
    s BDPHospNationalCode=$p($g(resultStr),"^",3)         
    s BDPHospNationalDesc = $p($g(resultStr),"^",4)
    if (desc'="")
    {
        ;需要对描述或者别名进行检索      
        s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Relation",CTRLTRowId,CTRLTDesc,desc)
    }
    else
    {
        s AliasFlag= 1   
    }   
    if ($ZCVT(CTRLTCode,"U")[code)&(AliasFlag=1) 
    {
        d OutputRow
    }
   }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(CTRLTRowId,CTRLTCode,CTRLTDesc,CTRLTDateFrom,CTRLTDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc )
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
/// Description：查询家庭关系的内容,用于combox查询
/// Table：User.CTRelation
/// Input：rowid,code,desc
/// Return：CTRLTRowId,CTRLTCode,CTRLTDesc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTRelation","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CTRLTRowId:%String,CTRLTCode:%String,CTRLTDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 //获取授权Json
 s AuStr=##class(web.DHCBL.Authorize.CTRelation).DHCGetDataByDefaultSession()
 s AuFlag=0
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
 
 if (rowid'="") //根据rowid返回该条记录
 {
  s CTRLTRowId=rowid
  s CTRLTCode=$p($g(^CT("RLT",CTRLTRowId)),"^",1)
  s CTRLTDesc=$p($g(^CT("RLT",CTRLTRowId)),"^",2)
  d OutputRow2
 }
 else
 {
  s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
  s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
  s CTRLTRowId=0
  for
  {
   s CTRLTRowId=$o(^CT("RLT",CTRLTRowId))
   q:CTRLTRowId=""
   s CTRLTDateFrom=$p($g(^CT("RLT",CTRLTRowId)),"^",3)
   continue:(CTRLTDateFrom'="")&&(CTRLTDateFrom>+$h)
   s CTRLTDateTo=$p($g(^CT("RLT",CTRLTRowId)),"^",4) 
   continue:(CTRLTDateTo'="")&&(CTRLTDateTo<+$h)
   //筛选授权后的数据
   s strRowId="{ID:"_CTRLTRowId_"}"
   if (AuStr[strRowId)||(AuFlag=1) 
   {
    s CTRLTCode=$p($g(^CT("RLT",CTRLTRowId)),"^",1)
    s CTRLTDesc=$p($g(^CT("RLT",CTRLTRowId)),"^",2)
    if (desc'="")
    {
        ;需要对描述或者别名进行检索      
        s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Relation",CTRLTRowId,CTRLTDesc,desc)
    }
    else
    {
        s AliasFlag= 1   
    }   
    if ($ZCVT(CTRLTCode,"U")[code)&(AliasFlag=1)  
    {
        d OutputRow2
    }
   }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2
    set Data=$lb(CTRLTRowId,CTRLTCode,CTRLTDesc)
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
