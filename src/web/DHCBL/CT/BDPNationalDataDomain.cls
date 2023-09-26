/// Function： 国家标准数据源值域维护
/// Creator：  sunfengchao
/// CreateDate:2016-04-08
Class web.DHCBL.CT.BDPNationalDataDomain Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Function:进行数据检索，查询信息
/// CreateDate:2016-04-08
/// Creator:sunfengchao
/// Tables: BDP_NationalDataDomain 
/// Input: rowid, code, desc 
/// Output: BDPDomain_RowId BDP_DomainCode  BDP_DomainDesc  BDP_DomainValue BDP_DomainExpression  BDP_DomainType_DR BDP_DomainStatement BDP_DomainVersion BDP_DomainOther
/// Others:  w ##class(web.DHCBL.CT.BDPNationalDataDomain).GetList("","","","","",0,10)
ClassMethod GetList(rowid As %String, code As %String, desc As %String, value As %String, type As %String, start As %String, limit As %String) As %String
{
   s resultStr="",count=0
   if (rowid'="")  
   {
     s BDPDomainRowId=rowid
     s BDPDomainCode=$p($g(^BDPDATADOMAIN(BDPDomainRowId)),"^",1)
     s BDPDomainDescDR=$p($g(^BDPDATADOMAIN(BDPDomainRowId)),"^",2)
     s:BDPDomainDescDR="" BDPDomainDescDR=""
     s:BDPDomainDescDR'="" BDPDomainDescDR = $p($g(^BDPDOMAINTYPE(BDPDomainDescDR)),"^",5)
     s BDPDomainValue=$p($g(^BDPDATADOMAIN(BDPDomainRowId)),"^",3)
     s BDPDomainExpression=$p($g(^BDPDATADOMAIN(BDPDomainRowId)),"^",4)
     s BDPDomainType=$p($g(^BDPDATADOMAIN(BDPDomainRowId)),"^",5)
     s BDPDomainStatement =$p($g(^BDPDATADOMAIN(BDPDomainRowId)),"^",6)
     s BDPDomainVersion=$p($g(^BDPDATADOMAIN(BDPDomainRowId)),"^",7)
     s BDPDomainOther= $p($g(^BDPDATADOMAIN(BDPDomainRowId)),"^",8)
     s resultStr= "{""BDPDomainRowId"":"""_BDPDomainRowId_""",""BDPDomainCode"":"""_BDPDomainCode_""",""BDPDomainDescDR"":"""_BDPDomainDescDR_""",""BDPDomainValue"":"""_BDPDomainValue_""",""BDPDomainExpression"":"""_BDPDomainExpression_""",""BDPDomainType"":"""_BDPDomainType_""",""BDPDomainStatement"":"""_BDPDomainStatement_""",""BDPDomainVersion"":"""_BDPDomainVersion_""",""BDPDomainOther"":"""_BDPDomainOther_"""}"
     s resultStr="{""total"":""1"",""success"":""true"",""data"":["_resultStr_"]}" 
   }
   else
   {
      s:code'="" code=$ZCVT(code,"U")  
      if start="" s start=0
      if limit="" s limit=20
      s start=start+1
      s BDPDomainRowId=0
      for
      { 
         s BDPDomainRowId=$o(^BDPDATADOMAIN(BDPDomainRowId)) 
         q:BDPDomainRowId=""   
         s BDPDomainCode=$p($g(^BDPDATADOMAIN(BDPDomainRowId)),"^",1)
         s BDPDomainDescDR=$p($g(^BDPDATADOMAIN(BDPDomainRowId)),"^",2) 
         s:BDPDomainDescDR'="" BDPDomainDescDR = $p($g(^BDPDOMAINTYPE(BDPDomainDescDR)),"^",5)
         s:BDPDomainDescDR="" BDPDomainDescDR=""
         s BDPDomainType=$p($g(^BDPDATADOMAIN(BDPDomainRowId)),"^",5)
         s BDPDomainExpression=$p($g(^BDPDATADOMAIN(BDPDomainRowId)),"^",4)
       
         if (($ZCVT(BDPDomainCode,"U")[code))&(($p($g(^BDPDATADOMAIN(BDPDomainRowId)),"^",2)=desc)||(desc=""))&(($ZCVT(BDPDomainExpression,"U")[($zcvt(value,"U"))||(value="")))  
         {
            s count=count+1
            if (count<start) continue
            if ((count<(start+limit)))
            {
              s BDPDomainValue=$p($g(^BDPDATADOMAIN(BDPDomainRowId)),"^",3)
              s BDPDomainStatement =$p($g(^BDPDATADOMAIN(BDPDomainRowId)),"^",6)
              s BDPDomainVersion=$p($g(^BDPDATADOMAIN(BDPDomainRowId)),"^",7)
              s BDPDomainOther= $p($g(^BDPDATADOMAIN(BDPDomainRowId)),"^",8)
              if (resultStr="")
              {
                 s resultStr= "{""BDPDomainRowId"":"""_BDPDomainRowId_""",""BDPDomainCode"":"""_BDPDomainCode_""",""BDPDomainDescDR"":"""_BDPDomainDescDR_""",""BDPDomainValue"":"""_BDPDomainValue_""",""BDPDomainExpression"":"""_BDPDomainExpression_""",""BDPDomainType"":"""_BDPDomainType_""",""BDPDomainStatement"":"""_BDPDomainStatement_""",""BDPDomainVersion"":"""_BDPDomainVersion_""",""BDPDomainOther"":"""_BDPDomainOther_"""}"
              }
              else
              {
                 s resultStr= resultStr_",{""BDPDomainRowId"":"""_BDPDomainRowId_""",""BDPDomainCode"":"""_BDPDomainCode_""",""BDPDomainDescDR"":"""_BDPDomainDescDR_""",""BDPDomainValue"":"""_BDPDomainValue_""",""BDPDomainExpression"":"""_BDPDomainExpression_""",""BDPDomainType"":"""_BDPDomainType_""",""BDPDomainStatement"":"""_BDPDomainStatement_""",""BDPDomainVersion"":"""_BDPDomainVersion_""",""BDPDomainOther"":"""_BDPDomainOther_"""}"
              }
            }
           }
         }
        s resultStr="{""total"":"""_count_""",""success"":""true"",""data"":["_resultStr_"]}"
     }
     q resultStr
}

/// Function:进行数据检索 
/// CreateDate:2016-04-09
/// Creator:sunfengchao
/// Tables: BDP_NationalDataDomain
/// Input: rowid, code ，desc
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.BDPNationalDataDomain", "GetDataForCmb1","")
Query GetDataForCmb1(menuName As %String, desc As %String) As %Query(ROWSPEC = "BDPDomainRowId:%String,BDPDomainExpression:%String")
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

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, menuName As %String, desc As %String) As %Status
{
  Set repid=$I(^CacheTemp)
  s ind=1
  s:desc'="" desc=$zcvt(desc,"U")
  ; 如果对照了就取对照的数据，没有就取全部数据
  s falg=0
  s flag=$d(^User.BDPMenuNATDataTypeI("contrast"," "_$zcvt(menuName,"U")))
  if (flag>0)
  {
    s DataDomainCode=0
    for
    {
      s DataDomainCode=$o(^User.BDPMenuNATDataTypeI("contrast"," "_$zcvt(menuName,"U"),DataDomainCode))
      q:DataDomainCode=""
      s DataDomainTypeID=0
      s DataDomainTypeID=$o(^BDPDOMAINTYPE(0,"DomainCode",$tr($zcvt(DataDomainCode,"U")," ",""),0)) 
      q:DataDomainTypeID=""
      s BDPDomainRowId=0
      for
      { 
         s BDPDomainRowId=$o(^BDPDATADOMAIN(BDPDomainRowId)) 
         q:BDPDomainRowId=""   
         s BDPDomainDescDR=""  ; 取出 值名称
         s BDPDomainDescDR=$p($g(^BDPDATADOMAIN(BDPDomainRowId)),"^",2) 
         s BDPDomainExpression=$p($g(^BDPDATADOMAIN(BDPDomainRowId)),"^",4)
   
         if (($zcvt(BDPDomainExpression,"U")[desc)&(BDPDomainDescDR=DataDomainTypeID))
         {
           d OutputRow2
         }  
        }
       }
      }
     else
     {
      ; 取出所有数据  
      s BDPDomainRowId=0
      for
      { 
         s BDPDomainRowId=$o(^BDPDATADOMAIN(BDPDomainRowId)) 
         q:BDPDomainRowId=""  
         s BDPDomainExpression=$p($g(^BDPDATADOMAIN(BDPDomainRowId)),"^",4)
         if ($zcvt(BDPDomainExpression,"U")[desc)
         {
           d OutputRow2
         }
      }
    }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2
    set Data=$lb(BDPDomainRowId,BDPDomainExpression)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

/// Function: 通过 value找其他的字段
/// w ##class(web.DHCBL.CT.BDPNationalDataDomain).FindDataValue("")
ClassMethod FindDataValue(id As %String) As %String
{
   s CodeValue="",DescValue="",DataDomainCode=""
   s DataDominesc="",DataDominCodeVal=""
   s DataDomainCode=$p($g(^BDPDATADOMAIN(id)),"^",1)
   s DataDominCodeVal=$p($g(^BDPDATADOMAIN(id)),"^",3)
   s CodeValue=DataDomainCode_"#"_DataDominCodeVal
   s DataDominesc=$p($g(^BDPDATADOMAIN(id)),"^",4) 
   q CodeValue_"^"_DataDominesc
}

/// CreateDate:2016-04-08
/// Creator:   基础数据平台公共产品组 孙凤超
/// Input:     输入id
/// Tables:    BDP_NationalDataDomain  
/// Others:    w ##Class(web.DHCBL.CT.BDPNationalDataDomain).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
   n (id,%session)
   s str=""
   s pobj=##class(User.BDPNationalDataDomain).%OpenId(id)
   s eobj = ##class(web.Entity.CT.BDPNationalDataDomain).%New()
   s eobj.BDPDomainRowId = id
   s eobj.BDPDomainVersion=pobj.BDPDomainVersion
   s eobj.BDPDomainCode=pobj.BDPDomainCode
   s:pobj.BDPDomainDescDR'="" eobj.BDPDomainDescDR= pobj.BDPDomainDescDR.%Id()
   s eobj.BDPDomainValue=pobj.BDPDomainValue
   s eobj.BDPDomainExpression=pobj.BDPDomainExpression 
   s eobj.BDPDomainType = pobj.BDPDomainType 
   s eobj.BDPDomainStatement=pobj.BDPDomainStatement
   s eobj.BDPDomainOther=pobj.BDPDomainOther
   d pobj.%Close()
   k pobj
   s str = eobj.JsonS()
   s str = "{list:["_str_"]}"
   q str
}

/// Function:实现删除操作
/// Creator: sunfengchao
/// CreateDate:2016-04-08
/// Input:  id
/// Output: success:'true',info:'删除成功！ 失败时输出删除失败！
/// Tables: BDP_NationalDataDomain
/// Others: do ##class(web.DHCBL.CT.BDPNationalDataDomain).DeleteData("")
ClassMethod DeleteData(id As %String) As %String
{
   n (id,%session)
   s result="",flag=""
   Tstart
   s pobj = ##class(User.BDPNationalDataDomain).%OpenId(id)
   s eobj = ##class(web.Entity.CT.BDPNationalDataDomain).%New()
   s eobj.BDPDomainRowId = id
   s eobj.BDPDomainCode=pobj.BDPDomainCode
   s:pobj.BDPDomainDescDR'="" eobj.BDPDomainDescDR= pobj.BDPDomainDescDR.%Id()
   s eobj.BDPDomainExpression=pobj.BDPDomainExpression
   s eobj.BDPDomainStatement=pobj.BDPDomainStatement
   s eobj.BDPDomainValue=pobj.BDPDomainValue
   s eobj.BDPDomainVersion=pobj.BDPDomainVersion
   s eobj.BDPDomainOther=pobj.BDPDomainOther  
   s eobj.BDPDomainType = pobj.BDPDomainType
   s sc=##class(User.BDPNationalDataDomain).%DeleteId(id)
   if $$$ISOK(sc)
   {
     Tc
     s result="{success:'true',info:'删除成功！'}"
     s logdesc=$p($g(^BDPDOMAINTYPE(eobj.BDPDomainDescDR)),"^",2)  
     d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_NationalDataDomain","User.BDPNationalDataDomain","国家标准数据元值域",id,logdesc,"D",eobj)
     d eobj.%Close()
   }
   else
   {
     Trollback
     s result= "{success:'false',info:'删除失败！"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
   }
   q result
}

/// Function:实现对数据重复校验
/// Creator:基础数据平台组 孙凤超
/// CreateDate:2013-09-03
/// Tables： BDP_NationalDataDomain
/// Debug:   w ##class(web.DHCBL.CT.BDPNationalDataDomain).FormValidate("1","a2","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 n (id,code,desc,%session)
 s flag="",flagc="", flagd=""
 s:code'="" code=$$ALPHAUP^SSUTIL4(code)  
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc)    
 s:code'="" flagc=$d(^BDPDATADOMAIN(0,"Code",code))
 s:desc'="" flagd=$d(^BDPDATADOMAIN(0,"Desc",desc))
 if (id="") 
 {//如果为空，增加时的重复判断
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
  s:code'="" idc=$o(^BDPDATADOMAIN(0,"Code",code,0))
  s:desc'="" idd=$o(^BDPDATADOMAIN(0,"Desc",desc,0))
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
    if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
    else  s flag=0 //返回不重复标志
   }
  }
 }
 q flag
}

/// Function: 实现修改和保存操作
/// Creator:  sunfengchao
/// CreateDate:2016-04-08
/// Function: 通过rowid来修改或保存信息
/// Output: success:'true',info:'添加成功！' 修改成功时输出修改成功！
///         success:'false',info:'添加失败' 修改失败时输出修改失败！
/// Tables: BDP_NationalDataDomain
ClassMethod SaveEntity(eobj As web.Entity.CT.BDPNationalDataDomain) As %String
{
  n (eobj,%session)
  s result=""
  if (eobj.BDPDomainRowId="")       
  {   
   s obj=##class(User.BDPNationalDataDomain).%New()
  }
  else  
  {
   s obj=##class(User.BDPNationalDataDomain).%OpenId(eobj.BDPDomainRowId)
   s bobj=##class(web.Entity.CT.BDPNationalDataDomain).%New()
   s bobj.BDPDomainRowId=eobj.BDPDomainRowId
   s bobj.BDPDomainCode = obj.BDPDomainCode                      
   s:obj.BDPDomainDescDR'="" bobj.BDPDomainDescDR= obj.BDPDomainDescDR.%Id() 
   s bobj.BDPDomainValue=obj.BDPDomainValue
   s bobj.BDPDomainExpression=obj.BDPDomainExpression
   s bobj.BDPDomainType=obj.BDPDomainType 
   s bobj.BDPDomainStatement=obj.BDPDomainStatement
   s bobj.BDPDomainVersion=obj.BDPDomainVersion
   s bobj.BDPDomainOther=obj.BDPDomainOther
  }
   s obj.BDPDomainCode = eobj.BDPDomainCode                      
   d obj.BDPDomainDescDRSetObjectId(eobj.BDPDomainDescDR)
   s obj.BDPDomainValue=eobj.BDPDomainValue
   s obj.BDPDomainExpression=eobj.BDPDomainExpression
   s obj.BDPDomainType= eobj.BDPDomainType
   s obj.BDPDomainStatement=eobj.BDPDomainStatement
   s obj.BDPDomainVersion=eobj.BDPDomainVersion
   s obj.BDPDomainOther=eobj.BDPDomainOther
  
   Tstart
   s sc=obj.%Save()
   if $$$ISOK(sc){
    Tcommit
    s id = obj.%Id()
    s result = "{success:'true',id:'"_id_"'}"      
    s logdesc=$p($g(^BDPDOMAINTYPE(eobj.BDPDomainDescDR)),"^",2)  
    d:eobj.BDPDomainRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_NationalDataDomain","User.BDPNationalDataDomain","国家标准数据元值域",eobj.BDPDomainRowId,logdesc,"U",eobj,bobj)
    d:eobj.BDPDomainRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_NationalDataDomain","User.BDPNationalDataDomain","国家标准数据元值域",id,logdesc,"A",eobj)
   }else{
   Trollback
   s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"     
  }
 q result
}

/// Function:数据导入
/// CreateDate:2020-07-21
/// Creator: sunfengchao  
/// Debug:   w ##class(web.DHCBL.CT.BDPNationalDataDomain).ImportExcel("ICD-10诊断国标V2.0","") 
///          w ##class(web.DHCBL.CT.BDPNationalDataDomain).ImportExcel("ICD-10手术国标V2.0","ICD-10SS#ICD-10手术国标V2.0#00.0200x001x#心脏血管治疗性超声x#手术操作分类国家临床2.0")
ClassMethod ImportExcel(sheetname As %String, DataStr As %String) As %String
{
    s ^TMPDataStr=sheetname_"&"_DataStr
    q:(DataStr="") 0
    k ^TMP("BDPNationalDataDomainErr")
    s myVresult=""  
    s BDPDomainCode=$p(DataStr,"#",1) //   值域代码
    s BDPDomainDesc=$p(DataStr,"#",2) //  值域名称
    s BDPStandardRowId= $o(^BDPDOMAINTYPE(0,"Desc",BDPDomainDesc,0)) 
    q:BDPStandardRowId="" 0
    s BDPDomainValue=$p(DataStr,"#",3) // 值  
    s BDPDomainExpression=$p(DataStr,"#",4) //值含义 
    s BDPDomainType=$p(DataStr,"#",5) //类型
            
    s bobj=##class(web.Entity.CT.BDPNationalDataDomain).%New()
    if ($IsObject(bobj))
    { 
       s bobj.BDPDomainRowId=""
       s bobj.BDPDomainCode = BDPDomainCode                      
       s bobj.BDPDomainDescDR=BDPStandardRowId  
       s bobj.BDPDomainValue=BDPDomainValue
       s bobj.BDPDomainExpression=BDPDomainExpression
       s bobj.BDPDomainType= BDPDomainType 
       s sc=..SaveEntity(bobj)   
       if (sc'["true")
       {
           s order=$i(^TMP("BDPNationalDataDomainErr"))
           s ^TMP("BDPNationalDataDomainErr",order)=DataStr
           s RImportResult=0
       }
       else
       {
           s RImportResult=1
       }
    }     
    q RImportResult
}

}
