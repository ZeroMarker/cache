/// 名称: 就诊分类维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-sunfengchao
/// 编写日期: 2012-8-31
Class web.DHCBL.CT.PACAdmCategory Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：sunfengchao
/// CreatDate: 2012-12-3
/// Description：修改时打开的数据
/// Table：User.PACAdmCategory
/// Input：id
ClassMethod OpenData(id As %String) As %String
{
 s str="" 
 s eobj = ##class(web.Entity.CT.PACAdmCategory).%New()
 s eobj.ADMCATRowId = id
 s eobj.ADMCATCode=$p($g(^PAC("ADMCAT",id)),"^",1)
 s eobj.ADMCATDesc=$p($g(^PAC("ADMCAT",id)),"^",2)
 s eobj.ADMCATDateFrom=$p($g(^PAC("ADMCAT",id)),"^",3)
 s eobj.ADMCATDateTo=$p($g(^PAC("ADMCAT",id)),"^",4)
 s eobj.ADMCATIsPayAfterTrea=$p($g(^PAC("ADMCAT",id)),"^",5)
 
 s:eobj.ADMCATDateFrom'="" eobj.ADMCATDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.ADMCATDateFrom) //转换日期格式
 s:eobj.ADMCATDateTo'="" eobj.ADMCATDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.ADMCATDateTo) //转换日期格式
 s:eobj.ADMCATIsPayAfterTrea="Y" eobj.ADMCATIsPayAfterTrea="true"
 s str = eobj.JsonS() 
 d eobj.%Close()
 s str = "{list:["_str_"]}"
 q str
}

/// Creator：sunfengchao
/// CreatDate: 2012-12-3
/// Description：数据重复验证方法,js调用
/// Table：User.PACAdmCategory
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s flag="",flagc="",flagd=""
 s:code'="" flagc=$d(^PAC("ADMCAT",0,"Code",code))
 s:desc'="" flagd=$d(^PAC("ADMCAT",0,"Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^PAC("ADMCAT",0,"Code",code,0))
  s:desc'="" idd=$o(^PAC("ADMCAT",0,"Desc",desc,0))
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
/// Table：User.PACAdmCategory
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s flag="",flagc="",flagd=""
 s:code'="" flagc=$d(^PAC("ADMCAT",0,"Code",code))
 s:desc'="" flagd=$d(^PAC("ADMCAT",0,"Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^PAC("ADMCAT",0,"Code",code,0))
  s:desc'="" idd=$o(^PAC("ADMCAT",0,"Desc",desc,0))
  if ((idc'=id)&(flagc>0))||((idd'=id)&(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 q flag
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-31
/// Description：保存修改就诊分类的内容
/// Table：User.PACAdmCategory
/// Input：web.Entity.CT.PACAdmCategory 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.PACAdmCategory).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.PACAdmCategory) As %String
{
 s $zt="ERROE"
 s result=""
 if $IsObject(eobj)
 {
  s:eobj.ADMCATDateFrom'="" eobj.ADMCATDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ADMCATDateFrom)  //转换日期
  s:eobj.ADMCATDateTo'="" eobj.ADMCATDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ADMCATDateTo)      //转换日期
  s:eobj.ADMCATDateFrom="" eobj.ADMCATDateFrom=+$h
  s flag=..Validate(eobj.ADMCATRowId,eobj.ADMCATCode,eobj.ADMCATDesc)  //调用重复验证
  if (flag=1)
  {
   s result = "{success:'false',errorinfo:'该记录已经存在！'}"
  }
  else
  {
   if (eobj.ADMCATRowId="")  //如果RowId未赋值则增加
   {
    s obj=##class(User.PACAdmCategory).%New()
   }
   else                      //如果RowId已赋值则修改
   {
    s obj=##class(User.PACAdmCategory).%OpenId(eobj.ADMCATRowId)
    s bobj=##class(web.Entity.CT.PACAdmCategory).%New()
    s bobj.ADMCATRowId=eobj.ADMCATRowId
    s bobj.ADMCATCode = obj.ADMCATCode          
    s bobj.ADMCATDesc = obj.ADMCATDesc           
    s bobj.ADMCATDateFrom = obj.ADMCATDateFrom   
    s bobj.ADMCATDateTo = obj.ADMCATDateTo      
    s bobj.ADMCATIsPayAfterTrea = obj.ADMCATIsPayAfterTrea
   }
   Ts          
   s obj.ADMCATCode = eobj.ADMCATCode          
   s obj.ADMCATDesc = eobj.ADMCATDesc          
   s obj.ADMCATDateFrom = eobj.ADMCATDateFrom  
   s obj.ADMCATDateTo = eobj.ADMCATDateTo      
   s obj.ADMCATIsPayAfterTrea = $case(eobj.ADMCATIsPayAfterTrea,"Y":"Y","true":"Y",:"N")
   s sc=obj.%Save()
   d obj.%Close()
   If $$$ISOK(sc)
   {
    Tc
    s id = obj.%Id()
    s result= "{success:'true',id:'"_id_"'}"         //返回RowId
    //保存日志
    d:eobj.ADMCATRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_AdmCategory","User.PACAdmCategory","就诊分类",id,eobj.ADMCATDesc,"A",eobj)
    d:eobj.ADMCATRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_AdmCategory","User.PACAdmCategory","就诊分类",eobj.ADMCATRowId,eobj.ADMCATDesc,"U",eobj,bobj)
   }
   else
   {
    Trollback
    s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
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

/// Creator：sunfengchao
/// CreatDate: 2012-8-31
/// Description：根据ID删除就诊分类的内容
/// Table：User.PACAdmCategory
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
 s result=""
 s eobj = ##class(web.Entity.CT.PACAdmCategory).%New()
 s eobj.ADMCATRowId = id
 s eobj.ADMCATCode=$p($g(^PAC("ADMCAT",id)),"^",1)
 s eobj.ADMCATDesc=$p($g(^PAC("ADMCAT",id)),"^",2)
 s eobj.ADMCATDateFrom=$p($g(^PAC("ADMCAT",id)),"^",3)
 s eobj.ADMCATDateTo=$p($g(^PAC("ADMCAT",id)),"^",4)
 s eobj.ADMCATIsPayAfterTrea=$p($g(^PAC("ADMCAT",id)),"^",5)
 
 s sc=##class(User.PACAdmCategory).%DeleteId(id)
 if $$$ISOK(sc)
 {
  s result= "{success:'true',info:'删除成功！'}" 
  //保存日志
  d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_AdmCategory","User.PACAdmCategory","就诊分类",id,eobj.ADMCATDesc,"D",eobj)
  d eobj.%Close()
 }
 else 
 {
  s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
 }
 q result
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-31
/// Description：查询就诊分类的内容
/// Table：PAC_AdmCategory
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACAdmCategory","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ADMCATRowId:%String,ADMCATCode:%String,ADMCATDesc:%String,ADMCATDateFrom:%String,ADMCATDateTo:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc,ADMCATIsPayAfterTrea")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
  s repid=$I(^CacheTemp)
  s ind=1
 
  //获取授权Json
  s AuStr=##class(web.DHCBL.Authorize.PACAdmCategory).DHCGetDataByDefaultSession()
  s AuFlag=0
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
 
  if (rowid'="") //根据rowid返回该条记录
  {
    s ADMCATRowId=rowid
    s ADMCATCode=$p($g(^PAC("ADMCAT",ADMCATRowId)),"^",1)
    s ADMCATDesc=$p($g(^PAC("ADMCAT",ADMCATRowId)),"^",2)
    s ADMCATDateFrom=$p($g(^PAC("ADMCAT",ADMCATRowId)),"^",3)
    s ADMCATDateTo=$p($g(^PAC("ADMCAT",ADMCATRowId)),"^",4)
    s ADMCATIsPayAfterTrea=$p($g(^PAC("ADMCAT",ADMCATRowId)),"^",5)
    s:ADMCATDateFrom'="" ADMCATDateFrom=$zd(ADMCATDateFrom,1)  
    s:ADMCATDateTo'="" ADMCATDateTo=$zd(ADMCATDateTo,1) 
    s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
    s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_AdmCategory",ADMCATRowId)
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
    s ADMCATRowId=0
    for
    {
      s ADMCATRowId=$o(^PAC("ADMCAT",ADMCATRowId))
      q:ADMCATRowId=""
      ;筛选授权后的数据
      s strRowId="{ID:"_ADMCATRowId_"}"
      if (AuStr[strRowId)||(AuFlag=1) 
      {
        s ADMCATCode=$p($g(^PAC("ADMCAT",ADMCATRowId)),"^",1)
        s ADMCATDesc=$p($g(^PAC("ADMCAT",ADMCATRowId)),"^",2) 
        s ADMCATDateFrom=$p($g(^PAC("ADMCAT",ADMCATRowId)),"^",3)
        s ADMCATDateTo=$p($g(^PAC("ADMCAT",ADMCATRowId)),"^",4)
        s ADMCATIsPayAfterTrea=$p($g(^PAC("ADMCAT",ADMCATRowId)),"^",5)
        s:ADMCATDateFrom'="" ADMCATDateFrom=$zd(ADMCATDateFrom,1)  
        s:ADMCATDateTo'="" ADMCATDateTo=$zd(ADMCATDateTo,1) 
        s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
        s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_AdmCategory",ADMCATRowId)
        s BDPInternalCode =$p($g(resultStr),"^",1)       
        s BDPInternalDesc = $p($g(resultStr),"^",2)  
        s BDPHospNationalCode=$p($g(resultStr),"^",3)         
        s BDPHospNationalDesc = $p($g(resultStr),"^",4)
        if (desc'="")
        {
            ;需要对描述或者别名进行检索      
            s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_AdmCategory",ADMCATRowId,ADMCATDesc,desc)
        }
        else
        {
            s AliasFlag= 1   
        }    
        if ($ZCVT(ADMCATCode,"U")[code)&(AliasFlag=1)   
        {
            d OutputRow
        }
     }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(ADMCATRowId,ADMCATCode,ADMCATDesc,ADMCATDateFrom,ADMCATDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc,ADMCATIsPayAfterTrea)
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
/// Description：查询就诊分类的内容,用于combox查询
/// Table：User.PACAdmCategory
/// Input：rowid,code,desc
/// Return：ADMCATRowId,ADMCATCode,ADMCATDesc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACAdmCategory","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ADMCATRowId:%String,ADMCATCode:%String,ADMCATDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 //获取授权Json
 s AuStr=##class(web.DHCBL.Authorize.PACAdmCategory).DHCGetDataByDefaultSession()
 s AuFlag=0
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
 
 if (rowid'="") //根据rowid返回该条记录
 {
  s ADMCATRowId=rowid
  s ADMCATCode=$p($g(^PAC("ADMCAT",ADMCATRowId)),"^",1)
  s ADMCATDesc=$p($g(^PAC("ADMCAT",ADMCATRowId)),"^",2)
  d OutputRow2
 }
 else
 {
  s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
  s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
  s ADMCATRowId=0
  for
  {
   s ADMCATRowId=$o(^PAC("ADMCAT",ADMCATRowId))
   q:ADMCATRowId=""
   s ADMCATDateFrom=$p($g(^PAC("ADMCAT",ADMCATRowId)),"^",3)
   continue:(ADMCATDateFrom'="")&&(ADMCATDateFrom>+$h)
   s ADMCATDateTo=$p($g(^PAC("ADMCAT",ADMCATRowId)),"^",4) 
   continue:(ADMCATDateTo'="")&&(ADMCATDateTo<+$h)
   //筛选授权后的数据
   s strRowId="{ID:"_ADMCATRowId_"}"
   if (AuStr[strRowId)||(AuFlag=1)
   {
      s ADMCATCode=$p($g(^PAC("ADMCAT",ADMCATRowId)),"^",1)
      s ADMCATDesc=$p($g(^PAC("ADMCAT",ADMCATRowId)),"^",2)
      if (desc'="")
      {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_AdmCategory",ADMCATRowId,ADMCATDesc,desc)
      }
      else
      {
         s AliasFlag= 1   
      }    
      if ($ZCVT(ADMCATCode,"U")[code)&(AliasFlag=1)   
      {
        d OutputRow2
      }
    }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2
    set Data=$lb(ADMCATRowId,ADMCATCode,ADMCATDesc)
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
