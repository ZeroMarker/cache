/// Function: 病人管理-- 患者级别  
/// CreateDate: 2015-2-5
/// Creator: 基础数据平台  sunfengchao
Class web.DHCBL.CT.CTEmpFunc Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function:进行数据检索，查询 患者级别
/// CreateDate:2015-2-5
/// Creator:sunfengchao
/// Tables:  CT_EmpFunc 
/// Output:  CTEMF_RowID CTEMF_Code CTEMF_Desc
/// Others:  d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTEmpFunc","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CTEMFRowID:%String,CTEMFCode:%String,CTEMFDesc:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
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
 s AuStr=##class(web.DHCBL.Authorize.CTEmpFunc).DHCGetDataByDefaultSession()
 s AuFlag=0
 ;未授权情况下，默认显示全部数据
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1
 if (rowid'="")  
 {
  s CTEMFRowID=rowid   
  s CTEMFCode=$p($g(^CT("EMF",rowid)),"^",1)
  s CTEMFDesc=$p($g(^CT("EMF",rowid)),"^",2)
  s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
  s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_EmpFunc",CTEMFRowID)
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
   s CTEMFRowID=0
   for
   {
     s CTEMFRowID=$o(^CT("EMF",CTEMFRowID)) q:CTEMFRowID=""  
     s strCTEMFRowID="{ID:"_CTEMFRowID_"}"
     if (AuStr[strCTEMFRowID)||(AuFlag=1)
     { 
       s CTEMFCode=$p($g(^CT("EMF",CTEMFRowID)),"^",1)
       s CTEMFDesc=$p($g(^CT("EMF",CTEMFRowID)),"^",2)  
       s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
       s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_EmpFunc",CTEMFRowID)
       s BDPInternalCode =$p($g(resultStr),"^",1)       
       s BDPInternalDesc = $p($g(resultStr),"^",2)  
       s BDPHospNationalCode=$p($g(resultStr),"^",3)         
       s BDPHospNationalDesc = $p($g(resultStr),"^",4) 
       if (desc'="")
       {
        ;需要对描述或者别名进行检索      
        s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_EmpFunc",CTEMFRowID,CTEMFDesc,desc)
       }
       else
       {
         s AliasFlag= 1   
       }  
       if ($ZCVT(CTEMFCode,"U")[code)&(AliasFlag=1)  
       {
         d OutputRow
       }
     }
   }
  }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(CTEMFRowID,CTEMFCode,CTEMFDesc,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Function:进行数据检索，为comb提供查询接口
/// CreateDate:2015-02-05
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables: CT_EmpFunc 
/// Input:  code,desc
/// Output: CTEMF_RowID CTEMF_Code CTEMF_Desc  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTEmpFunc","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CTEMFRowID:%String,CTEMFCode:%String,CTEMFDesc:%String")
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
 s AuStr=##class(web.DHCBL.Authorize.CTEmpFunc).DHCGetDataByDefaultSession()
 s AuFlag=0
 ;未授权情况下，默认显示全部数据
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1
 if (rowid'="")  
 {
  s CTEMFRowID=rowid   
  s CTEMFCode=$p($g(^CT("EMF",rowid)),"^",1)
  s CTEMFDesc=$p($g(^CT("EMF",rowid)),"^",2)
  d OutputRow2
 }
 else
 {
   s:code'="" code=$ZCVT(code,"U") 
   s:desc'="" desc=$ZCVT(desc,"U")  
   s CTEMFRowID=0
   for
   {
     s CTEMFRowID=$o(^CT("EMF",CTEMFRowID)) q:CTEMFRowID=""  
     s strCTEMFRowID="{ID:"_CTEMFRowID_"}"
     if (AuStr[strMTHROCRowId)||(AuFlag=1)
     { 
       s CTEMFCode=$p($g(^CT("EMF",CTEMFRowID)),"^",1)
       s CTEMFDesc=$p($g(^CT("EMF",CTEMFRowID)),"^",2) 
       if (desc'="")
       {
        ;需要对描述或者别名进行检索      
        s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_EmpFunc",CTEMFRowID,CTEMFDesc,desc)
       }
       else
       {
         s AliasFlag= 1   
       }  
       if ($ZCVT(CTEMFCode,"U")[code)&(AliasFlag=1)  
       {
         d OutputRow2
       }
     }
   }
  }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2   
   
 set Data=$lb(CTEMFRowID,CTEMFCode,CTEMFDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function:双击时弹窗显示信息
/// CreateDate:2015-02-05
/// Creator:sunfengchao
/// Input:  id
/// Tables: CT_EmpFunc
/// Other: w ##class(web.DHCBL.CT.CTEmpFunc).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
 s str=""
 s pobj = ##class(User.CTEmpFunc).%OpenId(id)
 s eobj = ##class(web.Entity.CT.CTEmpFunc).%New()
 
 s eobj.CTEMFRowID=id
 s eobj.CTEMFCode = pobj.CTEMFCode 
 s eobj.CTEMFDesc= pobj.CTEMFDesc
 
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Function:    实现删除操作
/// Creator:     sunfengchao
/// CreateDate:  2015-02-5
/// Output:      success:'true',info:'删除成功’
/// Tables:      CT_EmpFunc 
/// Others:      d ##class(web.DHCBL.CT.CTEmpFunc).DeleteData("")
ClassMethod DeleteData(id As %String) As %String
{
    s result="",flag=""
    Tstart 
    s pobj = ##class(User.CTEmpFunc).%OpenId(id)
    s eobj = ##class(web.Entity.CT.CTEmpFunc).%New()
    s eobj.CTEMFRowID=id
    s eobj.CTEMFCode = pobj.CTEMFCode 
    s eobj.CTEMFDesc = pobj.CTEMFDesc
   
    s sc=##class(User.CTEmpFunc).%DeleteId(id)
    IF $$$ISOK(sc)
   {
      Tc
      s result="{success:'true',info:'删除成功！'}"
      d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_EmpFunc","User.CTEmpFunc","患者级别",id,eobj.CTEMFDesc,"D",eobj)
      d eobj.%Close()
   }
   else
  {
     Trollback
     s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
     s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("患者级别","web.DHCBL.CT.CTEmpFunc","DeleteData",eobj)
     s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
  }
  q result
}

/// Function：对code,desc的数据重复校验
/// Creator：sunfengchao
/// CreatDate: 2015-01-05
/// Table：CT_EmpFunc
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s flag="", flagc="",flagd=""
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //此处用于转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //此处用于转换成大写
 s:code'="" flagc=$d(^CT("EMF",0,"Code",code))
 s:desc'="" flagd=$d(^CT("EMF",0,"Desc",desc))
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
  s idc="",idd=""
  
  s:code'="" idc=$o(^CT("EMF",0,"Code",code,0))
  s:desc'="" idd=$o(^CT("EMF",0,"Desc",desc,0))
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

/// Function:实现对分娩结果的修改增加操作
/// Creator: sunfengchao
/// CreateDate:2015-02-05
/// Output: success:'true',info:'添加成功！' 失败时输出添加失败！
///         success:'false',info:'修改成功' 失败时输出修改失败！
/// Tables: CT_EmpFunc
ClassMethod SaveEntity(eobj As web.Entity.CT.CTEmpFunc) As %String
{
   s result=""
   if $IsObject(eobj)
   {
     if (eobj.CTEMFRowID="")       
     {
       s obj=##class(User.CTEmpFunc).%New()
     }
     else                           
     {
       s obj=##class(User.CTEmpFunc).%OpenId(eobj.CTEMFRowID)
       s bobj=##class(web.Entity.CT.CTEmpFunc).%New()
       s bobj.CTEMFRowID=eobj.CTEMFRowID
       s bobj.CTEMFCode = obj.CTEMFCode                    
       s bobj.CTEMFDesc= obj.CTEMFDesc       
     }
    s obj.CTEMFCode = eobj.CTEMFCode                    
    s obj.CTEMFDesc= eobj.CTEMFDesc                     
    Tstart
    s sc=obj.%Save()
    if $$$ISOK(sc)
    {
      Tcommit
      s id = obj.%Id()
      s result = "{success:'true',id:'"_id_"'}"       
      d:eobj.CTEMFRowID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_EmpFunc","User.CTEmpFunc","患者级别",eobj.CTEMFRowID,eobj.CTEMFDesc,"U",eobj,bobj)
      d:eobj.CTEMFRowID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_EmpFunc","User.CTEmpFunc","患者级别",id,eobj.CTEMFDesc,"A",eobj)
    }
    else
    {
      Trollback
      s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"     
      s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("患者级别","web.DHCBL.CT.CTEmpFunc","SaveEntity",eobj)
      s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
    }   
  }
  else
  {
   s result = "{success:'false',errorinfo:'对象不存在！'}"
   s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("患者级别","web.DHCBL.CT.CTEmpFunc","SaveEntity","")
   s ^ERRORLOGINFO(logid)="对象不存在！"
  } 
  q result
}

}
