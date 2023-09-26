/// CreateDate: 2012-08-30
/// Creator: 基础数据平台孙凤超
/// Function: 资源组维护
/// Tables: RBC_EquipmentGroup 
Class web.DHCBL.CT.RBCEquipmentGroup Extends %RegisteredObject [ ProcedureBlock ]
{

Parameter SQLTableName = "RBC_EquipmentGroup";

/// Function:进行数据检索，查询资源组信息
/// CreateDate:2012-08-30
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables: RBC_EquipmentGroup 
/// Input: rowid, code, desc, query，datefrom,dateto
/// Output:GRP_RowId， GRP_Code， GRP_Desc ，GRP_DateFrom ，GRP_DateTo 
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.RBCEquipmentGroup", "GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "GRPRowId:%String,GRPCode:%String,GRPDesc:%String,GRPDateFrom:%String,GRPDateTo:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, hospid As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s AuStr=##class(web.DHCBL.Authorize.RBCEquipmentGroup).DHCGetDataByDefaultSession()
 s AuFlag=0
 ;未授权情况下，默认显示全部数据
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
 if (rowid'="")  
 {
   s GRPRowId=rowid
   s GRPCode=$p($g(^RBC("GRP",GRPRowId)),"^",1)
   s GRPDesc=$p($g(^RBC("GRP",GRPRowId)),"^",2) 
   s GRPDateFrom=$p($g(^RBC("GRP",GRPRowId)),"^",3)
   s:GRPDateFrom'="" GRPDateFrom=$zd(GRPDateFrom,1)
   s GRPDateTo=$p($g(^RBC("GRP",GRPRowId)),"^",4)
   s:GRPDateTo'="" GRPDateTo=$zd(GRPDateTo,1)
   s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="" 
   s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("RBC_EquipmentGroup",GRPRowId)
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
    
   s GRPRowId=0
   for
   {
     s GRPRowId=$o(^RBC("GRP",GRPRowId)) q:GRPRowId=""   
     s strGRPRowId="{ID:"_GRPRowId_"}"
     if (AuStr[strGRPRowId)||(AuFlag=1)
     {
           s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,GRPRowId,hospid)
           continue:showflag="N"
           s GRPCode=$p($g(^RBC("GRP",GRPRowId)),"^",1)
           s GRPDesc=$p($g(^RBC("GRP",GRPRowId)),"^",2)  
           s GRPDateFrom=$p($g(^RBC("GRP",GRPRowId)),"^",3)
           s:GRPDateFrom'="" GRPDateFrom=$zd(GRPDateFrom,1)
           s GRPDateTo=$p($g(^RBC("GRP",GRPRowId)),"^",4)
           s:GRPDateTo'="" GRPDateTo=$zd(GRPDateTo,1) 
           s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="" 
           s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("RBC_EquipmentGroup",GRPRowId)
           s BDPInternalCode =$p($g(resultStr),"^",1)       
           s BDPInternalDesc = $p($g(resultStr),"^",2)  
           s BDPHospNationalCode=$p($g(resultStr),"^",3)         
           s BDPHospNationalDesc = $p($g(resultStr),"^",4)
           if (desc'="")
           {
                ;需要对描述或者别名进行检索      
                s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("RBC_EquipmentGroup",GRPRowId,GRPDesc,desc)
           }
           else
           {
                s AliasFlag=1   
           } 
           if ($ZCVT(GRPCode,"U")[code)&(AliasFlag=1)  
           {
              d OutputRow
           }
        }
    }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(GRPRowId,GRPCode,GRPDesc,GRPDateFrom,GRPDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Function:显示打开窗口资源组信息 
/// CreateDate:2012-08-30
/// Creator:基础数据平台公共产品组 孙凤超
/// Input:输入sid
/// Tables: RBC_EquipmentGroup 
/// Others:w ##class(web.DHCBL.CT.RBCEquipmentGroup).OpenData("1")
ClassMethod OpenData(sid As %String) As %String
{
 s str=""
 s pobj = ##class(User.RBCEquipmentGroup).%OpenId(sid)
 s eobj = ##class(web.Entity.CT.RBCEquipmentGroup).%New()
 s eobj.GRPRowId=sid
 s eobj.GRPCode = pobj.GRPCode
 s eobj.GRPDesc = pobj.GRPDesc
 s:pobj.GRPDateFrom'="" eobj.GRPDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.GRPDateFrom)
 s:pobj.GRPDateTo'="" eobj.GRPDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.GRPDateTo)
 
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Creator:孙凤超
/// CreatDate:2013-8-27
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// Others:w ##class(web.DHCBL.CT.RBCEquipmentGroup).GetRefFlag("1")
ClassMethod GetRefFlag(id As %String) As %String
{
     s return="",myInfo=""
     s found1=0
     if ($d(^RBC("EQ",0,"Group",+id))) s found1=1
     if (found1=1)  s myInfo=myInfo_"<规定资源>"
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

/// Function:实现对资源组的删除操作
/// Creator:孙凤超
/// CreateDate:2012-08-30
/// Desc:通过rowid来删除资源组信息
/// Input: rowid
/// Output:success:'true',info:'删除成功！ 失败时输出删除成功！
/// Tables: RBC_EquipmentGroup 
/// Others:do ##class( web.DHCBL.CT.RBCEquipmentGroup).DeleteData("")
ClassMethod DeleteData(id As %String) As %String
{
  s result=""
  Tstart
  s pobj = ##class(User.RBCEquipmentGroup).%OpenId(id)
  s eobj = ##class(web.Entity.CT.RBCEquipmentGroup).%New()
  s eobj.GRPRowId=id
  s eobj.GRPCode = pobj.GRPCode
  s eobj.GRPDesc = pobj.GRPDesc
  s:pobj.GRPDateFrom'="" eobj.GRPDateFrom= pobj.GRPDateFrom  
  s:pobj.GRPDateTo'="" eobj.GRPDateTo=pobj.GRPDateTo  
  s re=##class(web.DHCBL.CT.RBCEquipmentGroup).GetRefFlag(id)
  s RefFlag=$p(re,"^",1)
  if (RefFlag=1)
 {
  s result="{success:'false',info:'"_$p(re,"^",2)_"'}"
 }
 else
 {
   s sc=##class(User.RBCEquipmentGroup).%DeleteId(id)
   IF $$$ISOK(sc)
   {
    Tc
    s result="{success:'true',info:'删除成功！'}"
    d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("RBC_EquipmentGroup","User.RBCEquipmentGroup","资源组",id,eobj.GRPDesc,"D",eobj)
    d eobj.%Close()
   }
   else
   {
     Trollback
     s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
     s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("资源组","web.DHCBL.CT.RBCEquipmentGroup","DeleteData",eobj)
     s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   }
  }
 q result
}

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 孙凤超
/// CreateDate:2012-11-17
/// Table: RBC_EquipmentGroup
ClassMethod FormValidate(id As %String, code As %String, desc As %String, hospid As %String = "") As %String
{
    s flag=0
    if $$ALPHAUP^SSUTIL4(code)'=""
    {
        s idc=0
        for
        {
            s idc=$o(^RBC("GRP",0,"Code",$$ALPHAUP^SSUTIL4(code),idc)) q:idc=""
            if (idc'=id)
            {
	            //2022-12-30限制代码跨院区也不能重复
                //s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,idc,hospid)
                //continue:showflag="N"
                s flag=1
            }
        }
    }
    
    if $$ALPHAUP^SSUTIL4(desc)'=""
    {
        s idd=0
        for
        {
    
            s idd=$o(^RBC("GRP",0,"Desc",$$ALPHAUP^SSUTIL4(desc),idd)) q:idd=""
            if (idd'=id)
            {
                s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,idd,hospid)
                continue:showflag="N"
                s flag=1
            }
        }
    }
    q flag
}

/// Function:实现对资源组的修改和保存操作
/// Creator:孙凤超
/// CreateDate:2012-08-29
/// Desc:通过rowid来修改或保存资源组信息
/// Input: 
/// Output: success:'true',info:'添加成功！' 失败时输出添加失败！
///         success:'false',info:'修改成功' 失败时输出修改失败！
/// Tables: RBC_EquipmentGroup
ClassMethod SaveEntity(eobj As web.Entity.CT.RBCEquipmentGroup) As %String
{
    s result=""
    s:eobj.GRPDateFrom'="" eobj.GRPDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.GRPDateFrom) 
    s:eobj.GRPDateTo'="" eobj.GRPDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.GRPDateTo)       
    s:eobj.GRPDateFrom="" eobj.GRPDateFrom=+$h
    s flag=..FormValidate(eobj.GRPRowId,eobj.GRPCode,eobj.GRPDesc,eobj.LinkHospId)  //调用重复验证
    if (flag=1)
    {
        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
      if (eobj.GRPRowId="")       
      { 
       s obj=##class(User.RBCEquipmentGroup).%New()
      } 
      else                           
      {
        s obj=##class(User.RBCEquipmentGroup).%OpenId(eobj.GRPRowId)
        s bobj=##class(web.Entity.CT.RBCEquipmentGroup).%New()
        s bobj.GRPRowId=eobj.GRPRowId
        s bobj.GRPCode = obj.GRPCode                     
        s bobj.GRPDesc= obj.GRPDesc                      
        s bobj.GRPDateFrom=obj.GRPDateFrom
        s bobj.GRPDateTo=obj.GRPDateTo
      }
      s obj.GRPCode = eobj.GRPCode                       
      s obj.GRPDesc= eobj.GRPDesc                       
      s obj.GRPDateFrom=eobj.GRPDateFrom
      s obj.GRPDateTo=eobj.GRPDateTo
      Tstart
      s sc=obj.%Save()
      if $$$ISOK(sc)
      {
        Tcommit
        s id = obj.%Id()
        s result = "{success:'true',id:'"_id_"'}"         
        d:eobj.GRPRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("RBC_EquipmentGroup","User.RBCEquipmentGroup","资源组",eobj.GRPRowId,eobj.GRPDesc,"U",eobj,bobj)
        d:eobj.GRPRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("RBC_EquipmentGroup","User.RBCEquipmentGroup","资源组",id,eobj.GRPDesc,"A",eobj)
        }
        else
        {
         Trollback
         s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
         s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("资源组","web.DHCBL.CT.RBCEquipmentGroup","SaveEntity",eobj)
         s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
        } 
    }
    q result
}

/// Function:进行数据检索，查询资源组信息
/// CreateDate:2012-08-30
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables:RBC_EquipmentGroup 
/// Input: rowid, code 
/// Output:GRP_RowId， GRP_Code， GRP_Desc ，GRP_DateFrom ，GRP_DateTo 
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.RBCEquipmentGroup", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "GRPRowId:%String,GRPCode:%String,GRPDesc:%String")
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

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, hospid As %String) As %Status
{
  Set repid=$I(^CacheTemp)
  s ind=1
  s:desc'="" desc=$ZCONVERT(desc,"U")
  s:code'="" code=$zconvert(code,"U")
  s AuStr= ##class(web.DHCBL.Authorize.RBCEquipmentGroup).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
  if (rowid'="")  
  { 
    s GRPRowId=rowid
    s GRPCode=$p($g(^RBC("GRP",rowid)),"^",1)
    s GRPDesc=$p($g(^RBC("GRP",rowid)),"^",2) 
    d OutputRowCmb
  }
  else
 {
   s GRPRowId=0
   for
   {
     s GRPRowId=$o(^RBC("GRP",GRPRowId)) 
     q:GRPRowId=""
     s GRPDateFrom=$p($g(^RBC("GRP",GRPRowId)),"^",3)
     continue:(GRPDateFrom'="")&&(GRPDateFrom>+$h)   
     s GRPDateTo=$p($g(^RBC("GRP",GRPRowId)),"^",4) 
     continue:(GRPDateTo'="")&&(GRPDateTo<+$h)   
     s strGRPRowId="{ID:"_GRPRowId_"}"
     if (AuStr[strGRPRowId)||(AuFlag=1)
     {
       s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,GRPRowId,hospid)
       continue:showflag="N"
       s GRPCode=$p($g(^RBC("GRP",GRPRowId)),"^",1)
       s GRPDesc=$p($g(^RBC("GRP",GRPRowId)),"^",2) 
       if (desc'="")
       {
           ;需要对描述或者别名进行检索      
           s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("RBC_EquipmentGroup",GRPRowId,GRPDesc,desc)
       }
       else
       {
           s AliasFlag=1   
       } 
       if ($ZCVT(GRPCode,"U")[code)&(AliasFlag=1)  
       {
         d OutputRowCmb
       }
    }
 }
}
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(GRPRowId,GRPCode,GRPDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

}
