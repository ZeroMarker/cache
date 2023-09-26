/// Function:  证件类型维护 
/// Creator:   sunfengchao
/// CreateDate:2016-6-23 
Class web.DHCBL.CT.DHCCredType Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function: 进行数据检索，查询证件类型的信息
/// CreateDate:2016-6-23 
/// Creator:  sunfengchao
/// Tables:   DHC_CredType
/// Input:    rowid, code, desc 
/// Output:   CRTRowID CRTCode  CRTDesc  CRTdefault CRTActive  CRTDateFrom  CRTDateTo  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCCredType", "GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CRTRowID:%String,CRTCode:%String,CRTDesc:%String,CRTdefault:%String,CRTActive:%String,CRTDateFrom:%String,CRTDateTo:%String,BDPInternalCode:%String,BDPInternalDesc:%String,BDPHospNationalCode:%String,BDPHospNationalDesc:%String")
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
   s AuStr= ##class(web.DHCBL.Authorize.DHCCredType).DHCGetDataByDefaultSession()
   s AuFlag=0
   ;未授权情况下，默认显示全部数据
   if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
   if (rowid'="")  
   {
     s CRTRowID=rowid
     s CRTCode=$p($g(^PAC("CARD",CRTRowID)),"^",1)
     s CRTDesc=$p($g(^PAC("CARD",CRTRowID)),"^",2)
     s CRTDateFrom=$p($g(^PAC("CARD",CRTRowID)),"^",3) 
     s CRTDateTo=$p($g(^PAC("CARD",CRTRowID)),"^",4)
     s:CRTDateFrom'="" CRTDateFrom=$zd(CRTDateFrom,1)
     s:CRTDateTo'="" CRTDateTo=$zd(CRTDateTo,1)
     s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CRTDesc)
     s CRTdefault=$p($g(^PAC("CARD",CRTRowID,"DHC")),"^",2)
     s CRTActive=$p($g(^PAC("CARD",CRTRowID,"DHC")),"^",1)
     s:CRTdefault="" CRTdefault="N"
     s:CRTActive="" CRTActive="N"
    
     s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
     s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("DHC_CredType",CRTRowID)
     s BDPInternalCode =$p($g(resultStr),"^",1)       
     s BDPInternalDesc = $p($g(resultStr),"^",2)  
     s BDPHospNationalCode=$p($g(resultStr),"^",3)         
     s BDPHospNationalDesc = $p($g(resultStr),"^",4)  
     d OutputRow
   }
   else
   {
     s:code'="" code=$zcvt(code,"U")
     s:desc'="" desc=$zcvt(desc,"u")
     s CRTRowID=0
     for
     {
       s CRTRowID=$o(^PAC("CARD",CRTRowID)) 
       q:(CRTRowID="")   
       s strCRTRowID="{ID:"_CRTRowID_"}"
       if (AuStr[strCRTRowID)||(AuFlag=1) 
       { 
         s CRTCode=$p($g(^PAC("CARD",CRTRowID)),"^",1)
         s CRTDesc=$p($g(^PAC("CARD",CRTRowID)),"^",2)
      
         s CRTDateFrom=$p($g(^PAC("CARD",CRTRowID)),"^",3) 
         s CRTDateTo=$p($g(^PAC("CARD",CRTRowID)),"^",4)
         s:CRTDateFrom'="" CRTDateFrom=$zd(CRTDateFrom,1)
         s:CRTDateTo'="" CRTDateTo=$zd(CRTDateTo,1)
         s CRTdefault=$p($g(^PAC("CARD",CRTRowID,"DHC")),"^",2)
         s CRTActive=$p($g(^PAC("CARD",CRTRowID,"DHC")),"^",1)
         s:CRTdefault="" CRTdefault="N"
         s:CRTActive="" CRTActive="N"
    
         s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
         s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("DHC_CredType",CRTRowID)
         s BDPInternalCode =$p($g(resultStr),"^",1)       
         s BDPInternalDesc = $p($g(resultStr),"^",2)  
         s BDPHospNationalCode=$p($g(resultStr),"^",3)         
         s BDPHospNationalDesc = $p($g(resultStr),"^",4)  
         if (desc'="")
         {
             ;需要对描述或者别名进行检索      
             s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("DHC_CredType",CRTRowID,CRTDesc,desc)
         }
         else
         {
             s AliasFlag= 1   
         }   
         if ($ZCVT(CRTCode,"U")[code)&(AliasFlag=1)    
         {
           d OutputRow
         }
      }
   }  
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(CRTRowID,CRTCode,CRTDesc,CRTdefault,CRTActive,CRTDateFrom,CRTDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Function: 进行数据检索，为comb提供查询证件类型信息的接口
/// CreateDate:2016-6-23
/// Creator:  sunfengchao
/// Table：   DHC_CredType
/// Input:    code, desc 
/// Others:   d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCCredType","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CRTRowID:%String,CRTCode:%String,CRTDesc:%String")
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
  s AuStr=##class(web.DHCBL.Authorize.DHCCredType).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  if (rowid'="")  
  {
     s CRTRowID=rowid
     s CRTCode=$p($g(^PAC("CARD",CRTRowID)),"^",1)
     s CRTDesc=$p($g(^PAC("CARD",CRTRowID)),"^",2)
     d OutputRowCmb
   }
 else
 {
   s CRTRowID=0
   for
   {
      s CRTRowID=$o(^PAC("CARD",CRTRowID)) 
      q:(CRTRowID="")  
      s CRTDateTo=$p($g(^PAC("CARD",CRTRowID)),"^",4)
      continue:(CRTDateTo'="")&&(CRTDateTo<+$h)
      s strCRTRowID="{ID:"_CRTRowID_"}"
      if (AuStr[strCRTRowID)||(AuFlag=1) 
      { 
         s CRTCode=$p($g(^PAC("CARD",CRTRowID)),"^",1)
         s CRTDesc=$p($g(^PAC("CARD",CRTRowID)),"^",2)
         if (desc'="")
         {
             ;需要对描述或者别名进行检索      
             s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("DHC_CredType",CRTRowID,CRTDesc,desc)
         }
         else
         {
             s AliasFlag= 1   
         }   
         if ($ZCVT(CRTCode,"U")[code)&(AliasFlag=1)  
         {
            d OutputRowCmb
         }
      }
   }  
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
   
 set Data=$lb(CRTRowID,CRTCode,CRTDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function:   显示证件类型信息的打开窗口
/// CreateDate: 2016-6-23 
/// Creator:    基础数据平台公共产品组 孙凤超
/// Input:      id
/// Tables:     DHC_CredType
/// Other:      w ##class(web.DHCBL.CT.DHCCredType).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
 s str=""
 s pobj = ##class(User.DHCCredType).%OpenId(id)
 s eobj = ##class(web.Entity.CT.DHCCredType).%New()
 s eobj.CRTRowID=id
 s eobj.CRTCode = pobj.CRTCode
 s eobj.CRTDesc= pobj.CRTDesc
 s:pobj.CRTDateFrom'="" eobj.CRTDateFrom = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.CRTDateFrom)
 s:pobj.CRTDateTo'="" eobj.CRTDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.CRTDateTo)
 s eobj.CRTActive=pobj.CRTActive
 s:eobj.CRTActive=""||eobj.CRTActive="N" eobj.CRTActive="false"
 s:eobj.CRTActive="Y" eobj.CRTActive="true"
 s eobj.CRTdefault = pobj.CRTdefault
 s:eobj.CRTdefault=""||eobj.CRTdefault="N" eobj.CRTdefault="false"
 s:eobj.CRTdefault="Y" eobj.CRTdefault="true"
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Function:数据重复校验
/// Creator：   sunfengchao
/// CreatDate:  2016-6-24
/// Table：     DHC_CredType
/// Input：     id, code, desc
/// Return：    "1"(数据重复),"0"(数据不重复)
/// Debug:w ##class(web.DHCBL.CT.DHCCredType).FormValidate("98","23","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s flag="",flagc="", flagd=""
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //此处用于转换成大写
 s:code'="" flagc=$d(^DHCACCCredType(0,"Code",code)) ;  ^DHCACCCredType(0,"Code","01",1)
 s:desc'="" flagd=$d(^DHCACCCredType(0,"Desc",desc))
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
  s idc="", idd=""
  s:code'="" idc=$o(^DHCACCCredType(0,"Code",code,0))
  s:desc'="" idd=$o(^DHCACCCredType(0,"Desc",desc,0))
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

/// Function: 实现对证件类型信息的删除操作
/// Creator:  sunfengchao
/// CreateDate:2016-6-23 
/// Desc:     通过id删除 
/// Output:   success:'true',info:'删除成功！ 失败时输出删除成功！
/// Tables:   DHC_CredType 
/// Others:   d ##class(web.DHCBL.CT.DHCCredType).DeleteData("1")
ClassMethod DeleteData(id) As %String
{
  s result="",flag=""
  TStart
  s obj = ##class(User.DHCCredType).%OpenId(id)
  s eobj = ##class(web.Entity.CT.DHCCredType).%New()
  s eobj.CRTRowID=id
  s eobj.CRTCode = obj.CRTCode
  s eobj.CRTDesc= obj.CRTDesc
  s eobj.CRTDateFrom=obj.CRTDateFrom
  s eobj.CRTDateTo=obj.CRTDateTo
  s eobj.CRTActive=obj.CRTActive
  s eobj.CRTdefault = obj.CRTdefault
  s:eobj.CRTActive="" eobj.CRTActive="N"
  s:eobj.CRTdefault="" eobj.CRTdefault="N"
 
  s sc=##class(User.DHCCredType).%DeleteId(id)
  if $$$ISOK(sc)
  {
     Tc
     s result="{success:'true',info:'删除成功！'}"
     d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_CredType","User.DHCCredType","证件类型",id,eobj.CRTDesc,"D",eobj)
     d eobj.%Close()
  }
  else
  {
     Trollback
     s result= "{success:'false',info:'删除失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
     s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("证件类型","web.DHCBL.CT.DHCCredType","DeleteData",eobj)
     s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
 }
 q result
}

/// Function:   对证件类型数据进行保存
/// CreateDate: 2016-6-23 
/// Creator:    基础数据平台组 孙凤超
/// Table:      DHC_CredType
/// Input：     web.Entity.CT.DHCCredType
/// Return：    成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:      d ##class(web.DHCBL.CT.DHCCredType).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.DHCCredType) As %String
{
 s $zt="ERROE"
 s result=""
 if $IsObject(eobj)
 {
   if eobj.CRTDateFrom'="" s eobj.CRTDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CRTDateFrom)   
   if eobj.CRTDateTo'="" s eobj.CRTDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CRTDateTo)     
   if eobj.CRTDateFrom="" s eobj.CRTDateFrom=+$h
   if (eobj.CRTRowID="")   
   {
    s obj = ##class(User.DHCCredType).%New()
   }
   else                    
   {
     s obj=##class(User.DHCCredType).%OpenId(eobj.CRTRowID)
     s bobj=##class(web.Entity.CT.DHCCredType).%New()
     s bobj.CRTRowID=eobj.CRTRowID
     s bobj.CRTCode = obj.CRTCode          
     s bobj.CRTDesc = obj.CRTDesc   
     s bobj.CRTDateFrom=obj.CRTDateFrom
     s bobj.CRTDateTo=obj.CRTDateTo
     s bobj.CRTActive=obj.CRTActive
     s:bobj.CRTActive="" bobj.CRTActive="N"        
     s bobj.CRTdefault = obj.CRTdefault  
     s:bobj.CRTdefault="" bobj.CRTdefault="N"
   }                    
   s obj.CRTCode = eobj.CRTCode          
   s obj.CRTDesc = eobj.CRTDesc     
   s obj.CRTDateFrom=eobj.CRTDateFrom
   s obj.CRTDateTo=eobj.CRTDateTo  
   s:eobj.CRTActive="" eobj.CRTActive="N"          
   s:eobj.CRTdefault="" eobj.CRTdefault="N"    
   s obj.CRTdefault = eobj.CRTdefault
   s obj.CRTActive=eobj.CRTActive   
   Tstart
   s sc = obj.%Save()
   d obj.%Close()
   If $$$ISOK(sc)
   {
   Tcommit
   s id = obj.%Id()
   s result = "{success:'true',id:'"_id_"'}"        
   d:eobj.CRTRowID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_CredType","User.DHCCredType","证件类型",id,eobj.CRTDesc,"A",eobj)
   d:eobj.CRTRowID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_CredType","User.DHCCredType","证件类型",eobj.CRTRowID,eobj.CRTDesc,"U",eobj,bobj)
   }
   else
   {
    Trollback  
    s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"     
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("证件类型","web.DHCBL.CT.DHCCredType","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
   }
 }
 else
 {
   s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("证件类型","web.DHCBL.CT.DHCCredType","SaveEntity",eobj)
   s ^ERRORLOGINFO(logid)="对象不存在！"
   s result = "{success:'false',errorinfo:'对象不存在！'}"
 }
 q result
ERROE
 s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("证件类型","web.DHCBL.CT.DHCCredType","SaveEntity",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q "{success:'false',errorinfo:'保存失败！'}"
}

}
