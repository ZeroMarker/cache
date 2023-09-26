/// 创建日期：2013-09-03
/// 创建人：基础数据平台组 孙凤超
/// 功能： 电子病历-2 过敏原
/// 表： PAC_Allergy
Class web.DHCBL.CT.PACAllergy Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function:进行数据检索，查询过敏原信息
/// CreateDate:2013-09-03
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables:  PAC_Allergy 
/// Input: rowid, code, desc 
/// Output: ALGRowId ALGCode ALGDesc ALGTypeDR ALGDateFrom ALGDateTo ALGAllergyCategoryDR
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACAllergy", "GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ALGRowId:%String,ALGCode:%String,ALGDesc:%String,ALGTypeDR:%String,ALGDateFrom:%String,ALGDateTo:%String,ALGAllergyDR,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
   s repid=$I(^CacheTemp)
   s ind=1
   s AuStr= ##class(web.DHCBL.Authorize.PACAllergy).DHCGetDataByDefaultSession()
   s AuFlag=0
   ;未授权情况下，默认显示全部数据
   if (AuStr="")||(AuStr["limited:0") s AuFlag=1
   if (rowid'="")  
   {
     s ALGRowId=rowid
     s ALGCode=$p($g(^PAC("ALG",ALGRowId)),"^",1)
     s ALGDesc=$p($g(^PAC("ALG",ALGRowId)),"^",2)
     s ALGTypeDR2=$p($g(^PAC("ALG",ALGRowId)),"^",3)
     s:ALGTypeDR2'="" ALGTypeDR=$p($g(^MRC("AT",ALGTypeDR2)),"^",2)
     s:ALGTypeDR2="" ALGTypeDR=""
     s ALGDateFrom=$p($g(^PAC("ALG",ALGRowId)),"^",4)
     s:ALGDateFrom'="" ALGDateFrom=$zd(ALGDateFrom,1)
     s ALGDateTo=$p($g(^PAC("ALG",ALGRowId)),"^",5)
     s:ALGDateTo'="" ALGDateTo=$zd(ALGDateTo,1)
     s ALGAllergyDR=$p($g(^PAC("ALG",ALGRowId)),"^",7) // 过敏原指向
     s:ALGAllergyDR'="" ALGAllergyDR=$p($g(^PAC("ALG",ALGAllergyDR)),"^",2) 
     s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
     s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_Allergy",ALGRowId)
     s BDPInternalCode =$p($g(resultStr),"^",1)       
     s BDPInternalDesc = $p($g(resultStr),"^",2)  
     s BDPHospNationalCode=$p($g(resultStr),"^",3)         
     s BDPHospNationalDesc = $p($g(resultStr),"^",4)  
     d OutputRow
   }
    else
   {
      s:code'="" code=$ZCVT(code,"U")  
      s:desc'="" desc=$ZCVT(desc,"U")
      s ALGRowId=0
      for
      { 
         s ALGRowId=$o(^PAC("ALG",ALGRowId)) q:ALGRowId=""   
         s strALGRowId="{ID:"_ALGRowId_"}"
         if (AuStr[strALGRowId)||(AuFlag=1) 
         { 
            s ALGCode=$p($g(^PAC("ALG",ALGRowId)),"^",1)
            s ALGDesc=$p($g(^PAC("ALG",ALGRowId)),"^",2) 
            s ALGTypeDR=$p($g(^PAC("ALG",ALGRowId)),"^",3)
            s:ALGTypeDR'="" ALGTypeDR=$p($g(^MRC("AT",ALGTypeDR)),"^",2)
            s:ALGTypeDR="" ALGTypeDR=""
            s ALGDateFrom=$p($g(^PAC("ALG",ALGRowId)),"^",4)
            s:ALGDateFrom'="" ALGDateFrom=$zd(ALGDateFrom,1)
            s ALGDateTo=$p($g(^PAC("ALG",ALGRowId)),"^",5)
            s:ALGDateTo'="" ALGDateTo=$zd(ALGDateTo,1)
            s ALGAllergyDR=$p($g(^PAC("ALG",ALGRowId)),"^",7) // 过敏原指向
            s:ALGAllergyDR'="" ALGAllergyDR=$p($g(^PAC("ALG",ALGAllergyDR)),"^",2) 
            s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
            s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_Allergy",ALGRowId)
            s BDPInternalCode =$p($g(resultStr),"^",1)       
            s BDPInternalDesc = $p($g(resultStr),"^",2)  
            s BDPHospNationalCode=$p($g(resultStr),"^",3)         
            s BDPHospNationalDesc = $p($g(resultStr),"^",4)
            if (desc'="")
            {
                ;需要对描述或者别名进行检索      
                s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_Allergy",ALGRowId,ALGDesc,desc)
            }
            else
            {
                s AliasFlag= 1   
            }    
            if ($ZCVT(ALGCode,"U")[code)&(AliasFlag=1)   
            {
              d OutputRow
            }
       }
   }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(ALGRowId,ALGCode,ALGDesc,ALGTypeDR,ALGDateFrom,ALGDateTo,ALGAllergyDR,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
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

/// Function:进行数据检索，为查询过敏原信息提供接口
/// CreateDate:2013-09-03
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables: PAC_Allergy
/// Input: rowid, code ，desc
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACAllergy", "GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ALGRowId:%String,ALGCode:%String,ALGDesc:%String")
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
   s:code'="" code=$ZCVT(code,"U")  
   s:desc'="" desc=$ZCVT(desc,"U")
   s AuStr=##class(web.DHCBL.Authorize.PACAllergy).DHCGetDataByDefaultSession()
   s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  if (rowid'="")  
 {
  s ALGRowId=rowid
  s ALGCode=$p($g(^PAC("ALG",ALGRowId)),"^",1)
  s ALGDesc=$p($g(^PAC("ALG",ALGRowId)),"^",2)
  d OutputRow2
 }
 else
 {
  s ALGRowId=0
  for
  { 
   s ALGRowId=$o(^PAC("ALG",ALGRowId)) 
   q:ALGRowId="" 
   s ALGDateFrom=$p($g(^PAC("ALG",ALGRowId)),"^",4) 
   continue:(ALGDateFrom'="")&&(ALGDateFrom>+$h)
   s ALGDateTo=$p($g(^PAC("ALG",ALGRowId)),"^",5) 
   continue:(ALGDateTo'="")&&(ALGDateTo<+$h)
   s strALGRowId="{ID:"_ALGRowId_"}"
   if (AuStr[strALGRowId)||(AuFlag=1) 
   { 
     s ALGCode=$p($g(^PAC("ALG",ALGRowId)),"^",1)
     s ALGDesc=$p($g(^PAC("ALG",ALGRowId)),"^",2)
     if (desc'="")
     {
        ;需要对描述或者别名进行检索      
        s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_Allergy",ALGRowId,ALGDesc,desc)
     }
     else
     {
        s AliasFlag= 1   
     }    
     if ($ZCVT(ALGCode,"U")[code)&(AliasFlag=1) 
     {
        d OutputRow2
     }
    }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2
    set Data=$lb(ALGRowId,ALGCode,ALGDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

/// Function:进行数据检索，为查询过敏原AllergyCategory提供接口
/// CreateDate:2013-09-03
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables: MRC_AllType
/// Input: rowid, code ，desc
/// Output: ALRGCAT_RowId ALRGCAT_Code ALRGCAT_Desc
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACAllergy", "GetCategoryDRList","","","") 
Query GetCategoryDRList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ALRGCATRowId:%String, ALRGCATCode:%String, ALRGCATDesc:%String")
{
}

ClassMethod GetCategoryDRListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCategoryDRListExecute ]
{
 Set repid=$LIST(qHandle,2)
  Kill ^CacheTemp(repid)  
  Quit $$$OK
}

ClassMethod GetCategoryDRListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCategoryDRListExecute ]
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

ClassMethod GetCategoryDRListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 s ind=1
 if (rowid'="")  
 {
  s ALRGCATRowId=rowid
  s ALRGCATCode=$p($g(^PAC("ALRGCAT",ALRGCATRowId)),"^",1)
  s ALRGCATDesc=$p($g(^PAC("ALRGCAT",ALRGCATRowId)),"^",2)
  d OutputRow
 }
 else
 {
  s:code'="" code=$ZCVT(code,"U")  
  s:desc'="" desc=$ZCVT(desc,"U")  
  s ALRGCATRowId=0
  f  s ALRGCATRowId=$o(^PAC("ALRGCAT",ALRGCATRowId)) q:ALRGCATRowId=""  d 
  .s ALRGCATCode=$p($g(^PAC("ALRGCAT",ALRGCATRowId)),"^",1)
  .s ALRGCATDesc=$p($g(^PAC("ALRGCAT",ALRGCATRowId)),"^",2)
  .i (($ZCVT(ALRGCATCode,"U")[code))&(($ZCVT(ALRGCATDesc,"U")[desc)) d
  ..d OutputRow
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(ALRGCATRowId,ALRGCATCode,ALRGCATDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

/// CreateDate:2013-09-03
/// Creator:   基础数据平台公共产品组 孙凤超
/// Input:     输入id
/// Tables:    PAC_Allergy  
/// Others:    w ##Class(web.DHCBL.CT.PACAllergy).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
   s str=""
   s pobj = ##class(User.PACAllergy).%OpenId(id)
   s eobj = ##class(web.Entity.CT.PACAllergy).%New()
   s eobj.ALGRowId = id
   s eobj.ALGCode=pobj.ALGCode
   s eobj.ALGDesc= pobj.ALGDesc
   if $IsObject(pobj.ALGTypeDR){
   s eobj.ALGTypeDR = pobj.ALGTypeDR.%Id() 
  }
  if $IsObject(pobj.ALGAllergyDR) s eobj.ALGAllergyDR=pobj.ALGAllergyDR.%Id() 
  s:pobj.ALGDateFrom'="" eobj.ALGDateFrom = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.ALGDateFrom)    
  s:pobj.ALGDateTo'="" eobj.ALGDateTo = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.ALGDateTo)
  d pobj.%Close()
  k pobj
  s str = eobj.JsonS()
  s str = "{list:["_str_"]}"
  q str
}

/// Function:实现对过敏原的删除操作
/// Creator:孙凤超
/// CreateDate:2013-09-03
/// Desc:通过rowid来删除过敏原信息
/// Input: id
/// Output:success:'true',info:'删除成功！ 失败时输出删除失败！
/// Tables: PAC_Allergy
/// Others:do ##class(web.DHCBL.CT.PACAllergy).DeleteData("")
ClassMethod DeleteData(id As %String) As %String
{
   s result="",flag=""
   Tstart
   s pobj = ##class(User.PACAllergy).%OpenId(id)
   s eobj = ##class(web.Entity.CT.PACAllergy).%New()
   s eobj.ALGRowId = id
   s eobj.ALGCode=pobj.ALGCode
   s eobj.ALGDesc= pobj.ALGDesc
   if $IsObject(pobj.ALGTypeDR){
   s eobj.ALGTypeDR = pobj.ALGTypeDR.%Id() 
  }
  if $IsObject(pobj.ALGAllergyDR) s eobj.ALGAllergyDR=pobj.ALGAllergyDR.%Id() 
  s:pobj.ALGDateFrom'="" eobj.ALGDateFrom =pobj.ALGDateFrom    
  s:pobj.ALGDateTo'="" eobj.ALGDateTo = pobj.ALGDateTo
  s sc=##class(User.PACAllergy).%DeleteId(id)
  if $$$ISOK(sc)
  {
   Tc
   s result="{success:'true',info:'删除成功！'}"
   d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_Allergy","User.PACAllergy","过敏原",id,eobj.ALGDesc,"D",eobj)
   d eobj.%Close()
 }
  else
 {
    Trollback
    s result= "{success:'false',info:'删除失败！"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
    s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("过敏原","web.DHCBL.CT.PACAllergy","DeleteData",eobj)
    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
 }
 q result
}

/// Function:实现对数据重复校验
/// Creator:基础数据平台组 孙凤超
/// CreateDate:2013-09-03
/// Tables： PAC_Allergy
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s flag="",flagc="",flagd=""
 s:code'="" code=$ZCVT(code,"U")  
 s:desc'="" desc=$ZCVT(desc,"U")  
 s:code'="" flagc=$d(^PAC("ALG",0,"Code",code))
 s:desc'="" flagd=$d(^PAC("ALG",0,"Desc",desc))
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
  s:code'="" idc=$o(^PAC("ALG",0,"Code",code,0))
  s:desc'="" idd=$o(^PAC("ALG",0,"Desc",desc,0))
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

/// Function:实现对过敏原的修改和保存操作
/// Creator:基础数据平台组 孙凤超
/// CreateDate:2013-09-3
/// Function: 通过rowid来修改或保存 
/// Output: success:'true',info:'添加成功！' 修改成功时输出修改成功！
///         success:'false',info:'添加失败' 修改失败时输出修改失败！
/// Tables: PAC_Allergy
ClassMethod SaveEntity(eobj As web.Entity.CT.PACAllergy) As %String
{
  s result=""
  s:eobj.ALGDateFrom'="" eobj.ALGDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ALGDateFrom)   
  s:eobj.ALGDateTo'="" eobj.ALGDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ALGDateTo)       
  s:eobj.ALGDateFrom="" eobj.ALGDateFrom=+$h
  if (eobj.ALGRowId="")       
  {   
   s obj=##class(User.PACAllergy).%New()
  }
  else  //如果RowId已赋值则修改
  {
   s obj=##class(User.PACAllergy).%OpenId(eobj.ALGRowId)
   s bobj=##class(web.Entity.CT.PACAllergy).%New()
   s bobj.ALGRowId=eobj.ALGRowId
   s bobj.ALGCode = obj.ALGCode                      
   s bobj.ALGDesc= obj.ALGDesc
   s:obj.ALGTypeDR'="" bobj.ALGTypeDR=obj.ALGTypeDR.%Id() 
   if $IsObject(obj.ALGAllergyDR) s bobj.ALGAllergyDR=obj.ALGAllergyDR.%Id() 
   s bobj.ALGDateFrom=obj.ALGDateFrom
   s bobj.ALGDateTo=obj.ALGDateTo
  }
   s obj.ALGCode = eobj.ALGCode                      
   s obj.ALGDesc= eobj.ALGDesc
   d obj.ALGTypeDRSetObjectId(eobj.ALGTypeDR)
   d obj.ALGAllergyDRSetObjectId(eobj.ALGAllergyDR) 
   s obj.ALGDateFrom=eobj.ALGDateFrom
   s obj.ALGDateTo=eobj.ALGDateTo
  ; s ALGNoteText=##class(%ListOfDataTypes).%New()
  ; do ALGNoteText.Insert(eobj.ALGNoteText)
  ; s obj.ALGNoteText = ALGNoteText         
   Tstart
   s sc=obj.%Save()
   if (sc=1)
   {
    Tcommit
    s id = obj.%Id()
    s result = "{success:'true',id:'"_id_"'}"          
    d:eobj.ALGRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_Allergy","User.PACAllergy","过敏原",eobj.ALGRowId,eobj.ALGDesc,"U",eobj,bobj)
    d:eobj.ALGRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_Allergy","User.PACAllergy","过敏原",id,eobj.ALGDesc,"A",eobj)
   }
   else
   {
    Trollback
    s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("过敏原","web.DHCBL.CT.PACAllergy","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
  }
 q result
}

/// CreatDate:2014-10-16
/// Description:查询数据(医嘱项)  
/// Table: ARC_ItmMast
/// Input:ordercat(医嘱大类desc),subcat(医嘱子类id),code,desc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ARCItmMast","GetDataForCmb1","","","","")
Query GetOrderList(rowid As %String, ordercat As %String, subcat As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ARCIMRowId:%String,ARCIMCode:%String,ARCIMDesc:%String")
{
}

ClassMethod GetOrderListExecute(ByRef qHandle As %Binary, rowid As %String, ordercat As %String, subcat As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
 s ind=1
 
 s:code'="" code=$ZCONVERT(code,"U")
 s:desc'="" desc=$ZCONVERT(desc,"U")
 
 //获取授权Json
 s AuStr=##class(web.DHCBL.Authorize.ARCItmMast).DHCGetDataByDefaultSession()
 if ($l(AuStr,"#")=1) {
  s Limited=0
  s AutBit=""
 }
 elseif ($l(AuStr,"#")=2) {
  s Limited=$p(AuStr,"#",1)
  s AutBit=$p(AuStr,"#",2)
 }
 s AuFlag=0
 if (AuStr="")||((AuStr'="")&(Limited=0)) s AuFlag=1 //判断是否有授权,如果没有则全部显示
 
 if (rowid'="") {
  s ARCIMSubscript=$p(rowid, "||", 1)
  s ARCIMVersion=$p(rowid, "||", 2)
  s ARCIMRowId=rowid
  s ARCIMCode=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)
  s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
  d OutputRowARCIM
 }
 else {
  
 s ARCIMSubscript=0
 f {
  s ARCIMSubscript=$o(^ARCIM(ARCIMSubscript))
  q:ARCIMSubscript=""
  //筛选授权后的数据
  if ($bit(AutBit,ARCIMSubscript)=1)||(AuFlag=1) {
   s ARCIMVersion=0
   f {
    s ARCIMVersion=$o(^ARCIM(ARCIMSubscript,ARCIMVersion))
    q:ARCIMVersion=""
    s ARCIMRowId=ARCIMSubscript_"||"_ARCIMVersion
    s ARCIMCode=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)
    s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
    s ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10) //医嘱子类id
    s ARCICOrdCatDR=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",8) //医嘱大类id
    s ORCATDesc = $p($g(^OEC("ORCAT",ARCICOrdCatDR)),"^",2) //医嘱大类描述
    //通过医嘱项别名检索
    s ALIASRowId=0
    s aliasFlag=0
    f {
     s ALIASRowId=$o(^ARC("ALIAS",0,"ARCIM",ARCIMRowId,ALIASRowId))
     q:ALIASRowId=""
     s ALIASText=$p($g(^ARC("ALIAS",ALIASRowId)),"^",6)
     i ($ZCONVERT(ALIASText,"U")[desc) {
      s aliasFlag=1
      q
     }
    }
    i ($ZCONVERT(ARCIMCode,"U")[code)&(($ZCONVERT(ARCIMDesc,"U")[desc)||(aliasFlag=1))&((ARCIMItemCatDR=subcat)||(subcat=""))&($ZCONVERT(ORCATDesc,"U")[ordercat)
    {
     d OutputRowARCIM
    }
   }
  }
 }
}
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
 
OutputRowARCIM
    set Data=$lb(ARCIMRowId,ARCIMCode,ARCIMDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetOrderListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrderListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 
 Set ind=$o(^CacheTemp(repid,ind))
 If ind=""
 {
  //if there are no more rows,finish fetching
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

ClassMethod GetOrderListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrderListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

}
