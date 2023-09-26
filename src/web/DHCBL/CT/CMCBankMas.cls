/// 名称: 银行代码维护 
/// 描述: 银行代码维护, 包含增删改查功能
/// 编写者：基础平台组、孙凤超
/// 编写日期: 2013-6-26 
/// 最后修改日期：2013-12-12 
Class web.DHCBL.CT.CMCBankMas Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：基础平台组、孙凤超
/// CreatDate: 2013-6-26
/// Description：查询银行代码的内容
/// Table： CMC_BankMas
/// Input：rowid,code,desc
/// Return：CMCBMRowId,CMCBMCode,CMCBMDesc,CMCBMDateFrom,CMCBMDateTo
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CMCBankMas", "GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CMCBMRowId:%String,CMCBMCode:%String,CMCBMDesc:%String,CMCBMDateFrom:%String,CMCBMDateTo:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc ")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
   s repid=$I(^CacheTemp)
   s ind=1
   s AuStr=##class(web.DHCBL.Authorize.CMCBankMas).DHCGetDataByDefaultSession()
   s AuFlag=0
   ;未授权情况下，默认显示全部数据
   if (AuStr="")||(AuStr["limited:0") s AuFlag=1
   if (rowid'="")  
   {
      s CMCBMRowId=rowid
      s CMCBMCode=$p($g(^CMC("CMCBM",rowid)),"^",1)
      s CMCBMDesc=$p($g(^CMC("CMCBM",rowid)),"^",2)
      s CMCBMDateFrom=$p($g(^CMC("CMCBM",rowid)),"^",5)
      s CMCBMDateTo=$p($g(^CMC("CMCBM",rowid)),"^",6)
      s:CMCBMDateFrom'="" CMCBMDateFrom=$zd(CMCBMDateFrom,1)
      s:CMCBMDateTo'="" CMCBMDateTo=$zd(CMCBMDateTo,1)
      s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
      s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CMC_BankMas",CMCBMRowId)
      s BDPInternalCode =$p($g(resultStr),"^",1)       
      s BDPInternalDesc = $p($g(resultStr),"^",2)  
      S BDPHospNationalCode=$p($g(resultStr),"^",3)         
      s BDPHospNationalDesc = $p($g(resultStr),"^",4)
      d OutputRow
    }
    else
    {
       s:code'="" code=$zcvt(code,"U")  
       s:desc'="" desc=$zcvt(desc,"U") 
       s CMCBMRowId=0
       for
       {
          s CMCBMRowId=$o(^CMC("CMCBM",CMCBMRowId)) q:CMCBMRowId=""   
          s strCMCBMRowId="{ID:"_CMCBMRowId_"}"
          if (AuStr[strCMCBMRowId)||(AuFlag=1) 
          {  
              s CMCBMCode=$p($g(^CMC("CMCBM",CMCBMRowId)),"^",1)
              s CMCBMDesc=$p($g(^CMC("CMCBM",CMCBMRowId)),"^",2) 
              s CMCBMDateFrom=$p($g(^CMC("CMCBM",CMCBMRowId)),"^",5)
              s CMCBMDateTo=$p($g(^CMC("CMCBM",CMCBMRowId)),"^",6)
              s:CMCBMDateFrom'="" CMCBMDateFrom=$zd(CMCBMDateFrom,1)
              s:CMCBMDateTo'="" CMCBMDateTo=$zd(CMCBMDateTo,1)
              s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
              s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CMC_BankMas",CMCBMRowId)
              s BDPInternalCode =$p($g(resultStr),"^",1)       
              s BDPInternalDesc = $p($g(resultStr),"^",2)  
              S BDPHospNationalCode=$p($g(resultStr),"^",3)         
              s BDPHospNationalDesc = $p($g(resultStr),"^",4)
              if (desc'="")
              {
                 ;需要对描述或者别名进行检索      
                 s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CMC_BankMas",CMCBMRowId,CMCBMDesc,desc)
              }
              else
              {
                s AliasFlag= 1   
              }   
              if (($ZCVT(CMCBMCode,"U")[code))&(AliasFlag=1) 
              {
                d OutputRow
              }
         }
     }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(CMCBMRowId,CMCBMCode,CMCBMDesc,CMCBMDateFrom,CMCBMDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc )
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

/// Function:进行数据检索，为combox查询银行代码提供接口 
/// CreateDate:2013-6-26
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables: User.CMCBankMas
/// Input:  code,desc  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CMCBankMas", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CMCBMRowId:%String,CMCBMCode:%String,CMCBMDesc:%String")
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
  s:code'="" code=$zcvt(code,"U")  
  s:desc'="" desc=$zcvt(desc,"U") 
  s AuStr=##class(web.DHCBL.Authorize.CMCBankMas).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
  if (rowid'="")  
  {
    s CMCBMRowId=rowid
    s CMCBMCode=$p($g(^CMC("CMCBM",rowid)),"^",1)
    s CMCBMDesc=$p($g(^CMC("CMCBM",rowid)),"^",2)
    d OutputRow2
  }
  else
  {
    s CMCBMRowId=0
    for
    {
      s CMCBMRowId=$o(^CMC("CMCBM",CMCBMRowId)) q:CMCBMRowId=""   
      s strCMCBMRowId="{ID:"_CMCBMRowId_"}"
      if (AuStr[strCMCBMRowId)||(AuFlag=1) 
      { 
       s CMCBMCode=$p($g(^CMC("CMCBM",CMCBMRowId)),"^",1)
       s CMCBMDesc=$p($g(^CMC("CMCBM",CMCBMRowId)),"^",2) 
       s CMCBMDateFrom=$p($g(^CMC("CMCBM",rowid)),"^",5)
       continue:(CMCBMDateFrom'="")&&(CMCBMDateFrom>+$h)
       s CMCBMDateTo=$p($g(^CMC("CMCBM",CMCBMRowId)),"^",6) 
       continue:(CMCBMDateTo'="")&&(CMCBMDateTo<+$h)
       if (desc'="")
       {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CMC_BankMas",CMCBMRowId,CMCBMDesc,desc)
       }
       else
       {
         s AliasFlag= 1   
       }   
       if (($ZCVT(CMCBMCode,"U")[code))&(AliasFlag=1) 
       {
         d OutputRow2
       }
    }
  }
}
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2   
 set Data=$lb(CMCBMRowId,CMCBMCode,CMCBMDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function:  用于数据删除时的逻辑判断
/// CreateDate:2020-5-13
/// Ctreator:Sunfengcho
/// Input:rowid  ^RB("RES",0,"EQ",{RES_EQ_DR},{RES_CTLOC_DR},{RES_RowId})
/// Output:返回一个标志位，0为未被引用，表示可以被删除，1表示已经被引用了，不能被删除
/// debug: w ##class(web.DHCBL.CT.CMCBankMas).GetRefFlag("")
ClassMethod GetRefFlag(id As %String) As %String
{
  s return=""
  s myInfo="" 
  // 对已被其他业务引用过的押金类型（在dhc_sfprintdetail表中），不允许删除 
  if $d(^DHCSFPRINTDETAIL(0,"Bank",id)) s myInfo=myInfo_"<住院押金表>" 
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

/// Creator：基础数据平台组 孙凤超
/// CreatDate: 2013-6-26
/// Description：根据ID删除银行代码的内容
/// Table：User.CMCBankMas
/// Input：id(CMCBankMas的rowid)
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id) As %String
{
  s result="",flag=""
  q:id="" "{success:'false',info:'id为空,删除失败！'}"
  s re=..GetRefFlag(id)
  s RefFlag=$p(re,"^",1)
  if (RefFlag=1)
  {
    s result="{success:'false',info:'"_$p(re,"^",2)_"'}"
  }
  else
  {
       Tstart
       s eobj = ##class(web.Entity.CT.CMCBankMas).%New()
       s eobj.CMCBMRowId = id
       S eobj.CMCBMCode=$p($g(^CMC("CMCBM",id)),"^",1)
       s eobj.CMCBMDesc= $p($g(^CMC("CMCBM",id)),"^",2)
       s eobj.CMCBMDateFrom= $p($g(^CMC("CMCBM",id)),"^",5)
       s eobj.CMCBMDateTo=$p($g(^CMC("CMCBM",id)),"^",6) 
       s:eobj.CMCBMDateFrom'="" eobj.CMCBMDateFrom=eobj.CMCBMDateFrom
       s:eobj.CMCBMDateTo'="" eobj.CMCBMDateTo=eobj.CMCBMDateTo
      
       s sc=##class(User.CMCBankMas).%DeleteId(id)
       IF $$$ISOK(sc)
       {
         Tc
         s result="{success:'true',info:'删除成功！'}"
         d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CMC_BankMas","User.CMCBankMas","银行代码",id,eobj.CMCBMDesc,"D",eobj)
         d eobj.%Close()
       }
       else
       {
        Trollback
        s result= "{success:'false',info:'删除失败！"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" 
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("银行代码","web.DHCBL.CT.CMCBankMas","DeleteData",eobj)
        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
       }
  }
   q result
}

/// Function:用于双击修改时的数据加载 
/// CreateDate:2013-6-26
/// Creator:基础数据平台公共产品组 孙凤超
/// Input:输入id
/// Others :w ##class(web.DHCBL.CT.CMCBankMas).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
 s str=""
 s pobj = ##class(User.CMCBankMas).%OpenId(id)
 s eobj = ##class(web.Entity.CT.CMCBankMas).%New()
 s eobj.CMCBMRowId = id
 S eobj.CMCBMCode=pobj.CMCBMCode
 s eobj.CMCBMDesc= pobj.CMCBMDesc
 s:pobj.CMCBMDateFrom'="" eobj.CMCBMDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.CMCBMDateFrom)
 s:pobj.CMCBMDateTo'="" eobj.CMCBMDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.CMCBMDateTo)
 
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Function:实现对银行代码修改增加操作
/// Creator: 基础数据平台组 孙凤超
/// CreateDate:2013-6-26
/// Output: success:'true',info:'添加成功！' 失败时输出添加失败！
///         success:'false',info:'修改成功' 失败时输出修改失败！
/// Tables: User.CMCBankMas
ClassMethod SaveEntity(eobj As web.Entity.CT.CMCBankMas) As %String
{
 s $zt="ERROR"
 s result=""
 if $IsObject(eobj)
 {
  s:eobj.CMCBMDateFrom="" eobj.CMCBMDateFrom=+$h
  s:eobj.CMCBMDateFrom'="" eobj.CMCBMDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CMCBMDateFrom)  
  s:eobj.CMCBMDateTo'="" eobj.CMCBMDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CMCBMDateTo)      
  //如果RowId未赋值则增加
  if (eobj.CMCBMRowId="")       
  {
    s obj=##class(User.CMCBankMas).%New()
  }
  else                           
  {
   s obj=##class(User.CMCBankMas).%OpenId(eobj.CMCBMRowId)
   ; bobj创建一个对象，用于记录原始数据
   s bobj=##class(web.Entity.CT.CMCBankMas).%New()
   s bobj.CMCBMRowId=eobj.CMCBMRowId
   s bobj.CMCBMCode = obj.CMCBMCode                      
   s bobj.CMCBMDesc= obj.CMCBMDesc                      
   s bobj.CMCBMDateFrom = obj.CMCBMDateFrom 
   s bobj.CMCBMDateTo= obj.CMCBMDateTo  
  }
   s obj.CMCBMCode = eobj.CMCBMCode                      
   s obj.CMCBMDesc= eobj.CMCBMDesc                       
   s obj.CMCBMDateFrom = eobj.CMCBMDateFrom 
   s obj.CMCBMDateTo=eobj.CMCBMDateTo
  
   Tstart
   s sc=obj.%Save()
   if $$$ISOK(sc){
    Tcommit
    s id = obj.%Id()
    s result = "{success:'true',id:'"_id_"'}"         //保存数据后,通过RowId返回到这条数据
    d:eobj.CMCBMRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CMC_BankMas","User.CMCBankMas","银行代码",eobj.CMCBMRowId,eobj.CMCBMDesc,"U",eobj,bobj)  
    d:eobj.CMCBMRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CMC_BankMas","User.CMCBankMas","银行代码",id,eobj.CMCBMDesc,"A",eobj,"")
   }
   else
   {
     Trollback
     s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
     s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("银行代码","web.DHCBL.CT.CMCBankMas","SaveEntity",eobj)
     s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   }
 }
 else
 {
    s result = "{success:'false',errorinfo:'对象不存在！'}"
 } 
  q result
ERROR
  s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("银行代码","web.DHCBL.CT.CMCBankMas","SaveEntity",eobj)
  s ^ERRORLOGINFO(logid)=$ze
  q "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator：基础数据平台组 孙凤超
/// CreatDate: 2013-6-26
/// Description：对银行代码维护中的代码，描述进行数据校验
/// Table：User.CMCBankMas
/// Input：id,code,desc
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s flag="",flagc="", flagd=""
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //此处用于转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //此处用于转换成大写
 s:code'="" flagc=$d(^CMC("CMCBM",0,"CMCBM_Code",code))
 s:desc'="" flagd=$d(^CMC("CMCBM",0,"CMCBM_Desc",desc))
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
  s idc=""
  s idd=""
  s:code'="" idc=$o(^CMC("CMCBM",0,"CMCBM_Code",code,0))
  s:desc'="" idd=$o(^CMC("CMCBM",0,"CMCBM_Desc",desc,0))
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

}
