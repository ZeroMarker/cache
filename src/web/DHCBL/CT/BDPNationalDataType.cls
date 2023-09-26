Class web.DHCBL.CT.BDPNationalDataType Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function：查询国家/地区标准数据类型
/// Creator： sunfengchao
/// CreatDate: 2016-4-7
/// Table：  BDP_NationalDataType
/// Others:  d ##class(%ResultSet).RunQuery("web.DHCBL.CT.BDPNationalDataType", "GetList","","","","")
Query GetList(rowid As %String, code As %String, desc As %String, NationalCode As %String, NationalDesc As %String) As websys.Query(ROWSPEC = "BDPStandardRowId:%String,BDPStandardCode:%String,BDPStandardDesc:%String,BDPStandardSearchCode:%String,BDPStandardDomainCode:%String,BDPStandardDomainDesc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, NationalCode As %String, NationalDesc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1  
 if (rowid'="")  
 {  
  s BDPStandardRowId=rowid
  s BDPStandardCode=$p($g(^BDPDOMAINTYPE(BDPStandardRowId)),"^",1)
  s BDPStandardDesc=$p($g(^BDPDOMAINTYPE(BDPStandardRowId)),"^",2)
  s BDPStandardSearchCode=$p($g(^BDPDOMAINTYPE(BDPStandardRowId)),"^",3)
  s BDPStandardDomainCode=$p($g(^BDPDOMAINTYPE(BDPStandardRowId)),"^",4) 
  s BDPStandardDomainDesc=$p($g(^BDPDOMAINTYPE(BDPStandardRowId)),"^",5)
  d OutputRow
 }
 else
 {
   s:code'="" code=$ZCVT(code,"U")  
   s:desc'="" desc=$ZCVT(desc,"U")  
   s:NationalCode'="" NationalCode=$zcvt(NationalCode,"U")
   s:NationalDesc'="" NationalDesc=$zcvt(NationalDesc,"U")
   s BDPStandardRowId=0
   for
   { 
      s BDPStandardRowId=$o(^BDPDOMAINTYPE(BDPStandardRowId))
      q:BDPStandardRowId=""   
      s BDPStandardCode=$p($g(^BDPDOMAINTYPE(BDPStandardRowId)),"^",1)
      s BDPStandardDesc=$p($g(^BDPDOMAINTYPE(BDPStandardRowId)),"^",2)
      s BDPStandardSearchCode=$p($g(^BDPDOMAINTYPE(BDPStandardRowId)),"^",3)
      s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(BDPStandardDesc) 
      s BDPStandardDomainCode=$p($g(^BDPDOMAINTYPE(BDPStandardRowId)),"^",4) 
      s BDPStandardDomainDesc=$p($g(^BDPDOMAINTYPE(BDPStandardRowId)),"^",5) 
      if (($ZCVT(BDPStandardCode,"U")[code))&((($ZCVT(BDPStandardDesc,"U")[desc)||(PINYINCODE[desc))||($zcvt(BDPStandardSearchCode,"U")[desc))&(($ZCVT(BDPStandardDomainCode,"U")[NationalCode))&(($ZCVT(BDPStandardDomainDesc,"U")[NationalDesc))
      {
       d OutputRow
      }
   }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(BDPStandardRowId,BDPStandardCode,BDPStandardDesc,BDPStandardSearchCode,BDPStandardDomainCode,BDPStandardDomainDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

/// Function:   进行数据检索,为combo提供查国家/地区标准数据源类别的接口
/// CreateDate: 2016-4-8
/// Creator:    sunfengchao
/// Tables:     BDP_NationalDataType 
/// Input:      code，desc
/// Others:     d ##class(%ResultSet).RunQuery("web.DHCBL.CT.BDPNationalDataType", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "BDPStandardRowId:%String,BDPStandardDomainCode:%String,BDPStandardDomainDesc:%String")
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
  if (rowid'="")  
  {  
    s BDPStandardRowId=rowid
    s BDPStandardDomainCode=$p($g(^BDPDOMAINTYPE(BDPStandardRowId)),"^",4) 
    s BDPStandardDomainDesc=$p($g(^BDPDOMAINTYPE(BDPStandardRowId)),"^",5) 
    d OutputRow2
  }
  else
  {
   s:code'="" code=$ZCVT(code,"U")  
   s:desc'="" desc=$ZCVT(desc,"U")  
   
   s BDPStandardRowId=0
   for
   { 
      s BDPStandardRowId=$o(^BDPDOMAINTYPE(BDPStandardRowId))
      q:BDPStandardRowId=""   
      s BDPStandardDomainCode=$p($g(^BDPDOMAINTYPE(BDPStandardRowId)),"^",4) 
      s BDPStandardDomainDesc=$p($g(^BDPDOMAINTYPE(BDPStandardRowId)),"^",5) 
      if ((BDPStandardDomainCode="")&&(BDPStandardDomainDesc="")){
         continue
      }
      else
      {
       s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(BDPStandardDomainDesc)  
       if (($ZCVT(BDPStandardDomainCode,"U")[code))&(($ZCVT(BDPStandardDomainDesc,"U")[desc)||(PINYINCODE[desc)) 
       {
        d OutputRow2
       }
      }
    }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2   
  set Data=$lb(BDPStandardRowId,BDPStandardDomainCode,BDPStandardDomainDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function： 数据重复校验
/// Creator:  sunfengchao
/// CreatDate: 2016-4-8
/// Table： BDP_NationalDataType
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
  s flag="",flagc="", flagd=""
  s:code'="" code=$$ALPHAUP^SSUTIL4(code)  
  s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc)  
  s:code'="" flagc=$d(^BDPDOMAINTYPE(0,"Code",code))
  s:desc'="" flagd=$d(^BDPDOMAINTYPE(0,"Desc",desc))
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
  s:code'="" idc=$o(^BDPDOMAINTYPE(0,"Code",code,0))
  s:desc'="" idd=$o(^BDPDOMAINTYPE(0,"Desc",desc,0))
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
    if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1 s flag=1  //返回重复标志
    else  s flag=0 //返回不重复标志
   }
  }
 }
 q flag
}

/// Creator：基础数据平台组 孙凤超
/// CreatDate: 2012-8-3
/// Description：双击时打开国家/地区标准数据源类别
/// Table：BDP_NationalDataType
/// Others:d ##class(web.DHCBL.CT.BDPNationalDataType).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str = ""
    s prbj = ##class(User.BDPNationalDataType).%OpenId(id)
    s eobj = ##class(web.Entity.CT.BDPNationalDataType).%New()
    s eobj.BDPStandardRowId = id
    s eobj.BDPStandardCode  = prbj.BDPStandardCode
    s eobj.BDPStandardDesc = prbj.BDPStandardDesc
    s eobj.BDPStandardSearchCode=prbj.BDPStandardSearchCode
    s eobj.BDPStandardDomainCode = prbj.BDPStandardDomainCode
    s eobj.BDPStandardDomainDesc=prbj.BDPStandardDomainDesc
    kill prbj
    s str = eobj.JsonS()
    s str = "{list:["_str_"]}"
    q str
}

/// Creator：基础数据平台组
/// CreatDate: 2012-8-3
/// Description：保存修改国家/地区标准数据类型 
/// Table： BDP_NationalDataType
ClassMethod SaveEntity(eobj As web.Entity.CT.BDPNationalDataType) As %String
{
 s result="",jsonstr=""
 if $IsObject(eobj)
 { 
  if (eobj.BDPStandardRowId="")                             
  { 
    s obj=##class(User.BDPNationalDataType).%New()
  }
  else                                                  
  {
   s obj=##class(User.BDPNationalDataType).%OpenId(eobj.BDPStandardRowId)
   s bobj=##class(web.Entity.CT.BDPNationalDataType).%New()
   s bobj.BDPStandardRowId=eobj.BDPStandardRowId
   s bobj.BDPStandardCode = obj.BDPStandardCode                     
   s bobj.BDPStandardDesc = obj.BDPStandardDesc 
   s bobj.BDPStandardSearchCode=obj.BDPStandardSearchCode  
   s bobj.BDPStandardDomainCode = obj.BDPStandardDomainCode 
   s bobj.BDPStandardDomainDesc=obj.BDPStandardDomainDesc 
  } 
  s obj.BDPStandardCode = eobj.BDPStandardCode                     
  s obj.BDPStandardDesc = eobj.BDPStandardDesc                      
  s obj.BDPStandardSearchCode=eobj.BDPStandardSearchCode 
  s obj.BDPStandardDomainCode = eobj.BDPStandardDomainCode                      
  s obj.BDPStandardDomainDesc=eobj.BDPStandardDomainDesc  
  Ts
  s sc=obj.%Save()
  d obj.%Close()
  If $$$ISOK(sc){
   Tc
   s id = obj.%Id()
   s result = "{success:'true',id:'"_id_"'}"         
   d:eobj.BDPStandardRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_NationalDataType","User.BDPNationalDataType","国家/地区标准数据源类别",id,eobj.BDPStandardDesc,"A",eobj)
   d:eobj.BDPStandardRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_NationalDataType","User.BDPNationalDataType","国家/地区标准数据源类别",eobj.BDPStandardRowId,eobj.BDPStandardDesc,"U",eobj,bobj)
  }
  else
  {
   Trollback
   s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"     
  }   
 }
 else
 {
  s result = "{success:'false',errorinfo:'对象不存在！'}"
 } 
 q result
}

/// Function: 删除前的逻辑判断
/// Crretor:  sunfengchao
/// CreateDate:2016-4-8
/// Debug:  w ##class(web.DHCBL.CT.BDPNationalDataType).GetRefFlag()
ClassMethod GetRefFlag(id As %String) As %String
{
   s return="",myInfo="" 
   s flagc=0
   ;; 先在 国家/地区标准编码类别里取出 国家/地区标准编码code  再去国家/地区标准编码数据里找看是否有这个code的索引 
   ;; 如果有数据已经别引用不能被删除 
   s BDPStandardDomainCode=$p($g(^BDPDOMAINTYPE(id)),"^",4) 
   s BDPStandardDomainDesc=$p($g(^BDPDOMAINTYPE(id)),"^",5) 
   s:BDPStandardDomainCode'="" BDPStandardDomainCode=$$ALPHAUP^SSUTIL4(BDPStandardDomainCode)  
   s:BDPStandardDomainCode'="" flagc=$d(^BDPDATADOMAIN(0,"Code",BDPStandardDomainCode))

   if (flagc>0) 
   {
      s myInfo=myInfo_"<国家/地区标准数据元值域>"
      s return="1^在"_myInfo_"表里被引用,不能删除!"
   }
   else
   {
       s return="0^未被引用可删除！"
   }   
    q return
}

/// Creator：基础数据平台组 孙凤超
/// CreatDate: 2012-8-3
/// Description：删除国家/地区标准数据源类别内容
/// Table： BDP_NationalDataType
/// Debug: w ##class(web.DHCBL.CT.BDPNationalDataType).DeleteData("3")
ClassMethod DeleteData(id) As %String
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
    s obj=##class(User.BDPNationalDataType).%OpenId(id)
    s eobj = ##class(web.Entity.CT.BDPNationalDataType).%New()
    s eobj.BDPStandardRowId = id
    s eobj.BDPStandardCode  = obj.BDPStandardCode
    s eobj.BDPStandardDesc = obj.BDPStandardDesc
    s eobj.BDPStandardSearchCode=obj.BDPStandardSearchCode
    s eobj.BDPStandardDomainCode = obj.BDPStandardDomainCode
    s eobj.BDPStandardDomainDesc=obj.BDPStandardDomainDesc
    s sc=##class(User.BDPNationalDataType).%DeleteId(id)
    IF $$$ISOK(sc)
    {
       Tc
       s result="{success:'true',info:'删除成功！'}"
       d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_NationalDataType","User.BDPNationalDataType","国家/地区标准数据源类别",id,eobj.BDPStandardDesc,"D",eobj)
    }
    else
    {
       Trollback
       s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
    }
  } 
 q result
}

/// Function: 根据类型表的id返回值域的代码 名称,用于源值域页面
/// Creator:  Sunfengchao
/// CreateDate: 2016-6-20
/// Debug:    w ##class(web.DHCBL.CT.BDPNationalDataType).GetDomainByType("1")
ClassMethod GetDomainByType(id As %String)
{
  s result=""
  s BDPStandardDomainCode="", BDPStandardDomainDesc=""
  s BDPStandardDomainCode=$p($g(^BDPDOMAINTYPE(id)),"^",4) 
  s BDPStandardDomainDesc=$p($g(^BDPDOMAINTYPE(id)),"^",2) 
  s result=BDPStandardDomainCode_"^"_BDPStandardDomainDesc
  q result
}

}
