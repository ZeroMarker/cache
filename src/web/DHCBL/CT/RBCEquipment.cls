Class web.DHCBL.CT.RBCEquipment Extends %RegisteredObject [ ProcedureBlock ]
{

/// update2020-02-11
Parameter SQLTableName = "RBC_Equipment";

/// Function:进行数据检索，查询规定资源信息
/// CreateDate:2012-09-03
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables: RBC_Equipment
/// Input: rowid, code, desc, query
/// Output:EQ_RowId EQ_Code EQ_Desc EQ_Group_DR EQ_DateFrom EQ_DateTo 
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.RBCEquipment", "GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "EQRowId:%String,EQCode:%String,EQDesc:%String,EQGroupDR:%String,EQDateFrom:%String,EQDateTo:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
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
 s AuStr=##class(web.DHCBL.Authorize.RBCEquipment).DHCGetDataByDefaultSession()
 s AuEQGroupDRStr=##class(web.DHCBL.Authorize.RBCEquipmentGroup).DHCGetDataByDefaultSession()
 
 s AuFlag=0
 ;未授权情况下，默认显示全部数据
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
 
 s AuEQGroupDRFlag=0 
 if (AuEQGroupDRStr="")||(AuEQGroupDRStr["limited:0") s AuEQGroupDRFlag=1
 if (rowid'="")  
 {
   s EQRowId=rowid
   s EQCode=$p($g(^RBC("EQ",EQRowId)),"^",1)
   s EQDesc=$p($g(^RBC("EQ",EQRowId)),"^",2) 
   s EQGroupDR=$p($g(^RBC("EQ",EQRowId)),"^",3)
   s:EQGroupDR'="" EQGroupDR=$p($g(^RBC("GRP",EQGroupDR)),"^",2) 
   s:EQGroupDR="" EQGroupDR=""
   s EQDateFrom=$p($g(^RBC("EQ",EQRowId)),"^",4)
   s:EQDateFrom'="" EQDateFrom=$zd(EQDateFrom,1)
   s EQDateTo=$p($g(^RBC("EQ",EQRowId)),"^",5)
   s:EQDateTo'="" EQDateTo=$zd(EQDateTo,1)
   s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="" 
   s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("RBC_Equipment",EQRowId)
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
    
    s EQRowId=0
    for 
    {
       s EQRowId=$o(^RBC("EQ",EQRowId))  
       q:EQRowId=""   
       s EQGroupDR=$p($g(^RBC("EQ",EQRowId)),"^",3)    
       s strEQRowId="{ID:"_EQRowId_"}"
       s strEQGroupDR="{ID:"_EQGroupDR_"}"
       if ((AuStr[strEQRowId)||(AuFlag=1))&((AuEQGroupDRStr[strEQGroupDR)||(AuEQGroupDRFlag=1))
       {
         s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,EQRowId,hospid)
         continue:showflag="N"
         s EQCode=$p($g(^RBC("EQ",EQRowId)),"^",1)
         s EQDesc=$p($g(^RBC("EQ",EQRowId)),"^",2)  
         s:EQGroupDR'="" EQGroupDR=$p($g(^RBC("GRP",EQGroupDR)),"^",2)
         s:EQGroupDR="" EQGroupDR=""
         s EQDateFrom=$p($g(^RBC("EQ",EQRowId)),"^",4)
         s EQDateTo=$p($g(^RBC("EQ",EQRowId)),"^",5)
         s:EQDateFrom'="" EQDateFrom=$zd(EQDateFrom,1)
         s:EQDateTo'="" EQDateTo=$zd(EQDateTo,1)
         s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="" 
         s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("RBC_Equipment",EQRowId)
         s BDPInternalCode =$p($g(resultStr),"^",1)       
         s BDPInternalDesc = $p($g(resultStr),"^",2)  
         s BDPHospNationalCode=$p($g(resultStr),"^",3)         
         s BDPHospNationalDesc = $p($g(resultStr),"^",4)
         if (desc'="")
         {
            ;需要对描述或者别名进行检索      
            s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("RBC_Equipment",EQRowId,EQDesc,desc)
         }
         else
         {
            s AliasFlag=1   
         } 
         if ($ZCVT(EQCode,"U")[code)&(AliasFlag=1) 
         {
           d OutputRow
         }
      }
   }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(EQRowId,EQCode,EQDesc,EQGroupDR,EQDateFrom,EQDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Function:进行数据检索，为comb提供查询规定资源信息的接口
/// CreateDate:2012-12-10
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables:RBC_Equipment
/// Input: rowid, code, desc, query
/// Output:EQ_RowId EQ_Code EQ_Desc  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.RBCEquipment","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "EQRowId:%String, EQCode:%String,EQDesc:%String ")
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
   s:code'="" code=$ZCVT(code,"U")  
   s:desc'="" desc=$ZCVT(desc,"U") 
   s AuStr=##class(web.DHCBL.Authorize.RBCEquipment).DHCGetDataByDefaultSession()
   s AuFlag=0
   ;未授权情况下，默认显示全部数据
   if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
   s AuEQGroupDRStr=##class(web.DHCBL.Authorize.RBCEquipmentGroup).DHCGetDataByDefaultSession()
   s AuEQGroupDRFlag=0 
   if (AuEQGroupDRStr="")||(AuEQGroupDRStr["limited:0") s AuEQGroupDRFlag=1
   if (rowid'="")  
   {
     s EQRowId=rowid
     s EQCode=$p($g(^RBC("EQ",EQRowId)),"^",1)
     s EQDesc=$p($g(^RBC("EQ",EQRowId)),"^",2) 
     d OutputRow2
   }
  else
  {
    s EQRowId=0
    for 
    {
     s EQRowId=$o(^RBC("EQ",EQRowId))  
     q:EQRowId=""   
     s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,EQRowId,hospid)
     continue:showflag="N"
     s EQDateFrom=$p($g(^RBC("EQ",EQRowId)),"^",4)
     continue:(EQDateFrom'="")&&(EQDateFrom>+$h)
     s EQDateTo=$p($g(^RBC("EQ",EQRowId)),"^",5)
     continue:(EQDateTo'="")&&(EQDateTo<+$h)
     s strEQRowId="{ID:"_EQRowId_"}"
     s EQGroupDR=$p($g(^RBC("EQ",EQRowId)),"^",3)  
     s strEQGroupDR="{ID:"_EQGroupDR_"}"
     if ((AuStr[strEQRowId)||(AuFlag=1))&((AuEQGroupDRStr[strEQGroupDR)||(AuEQGroupDRFlag=1))
     {
       s EQCode=$p($g(^RBC("EQ",EQRowId)),"^",1)
       s EQDesc=$p($g(^RBC("EQ",EQRowId)),"^",2) 
       if (desc'="")
       {
          ;需要对描述或者别名进行检索      
          s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("RBC_Equipment",EQRowId,EQDesc,desc)
       }
       else
       {
          s AliasFlag=1   
       } 
       if ($ZCVT(EQCode,"U")[code)&(AliasFlag=1) 
       {
         d OutputRow2
       }
     }
   }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2   
   
 set Data=$lb(EQRowId,EQCode,EQDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// 显示规定资源信息
/// CreateDate:2012-09-10
/// Creator:基础数据平台公共产品组 孙凤超
/// Input:输入sid
/// Tables:RBC_Equipment  
/// Others:w ##Class(web.DHCBL.CT.RBCEquipment).OpenData("1")
ClassMethod OpenData(sid As %String) As %String
{
   s str=""
   s pobj = ##class(User.RBCEquipment).%OpenId(sid)
   s eobj = ##class(web.Entity.CT.RBCEquipment).%New()
   s eobj.EQRowId = sid
   s eobj.EQCode=pobj.EQCode
   s eobj.EQDesc= pobj.EQDesc
   if (pobj.EQGroupDR'="")
   { 
     s eobj.EQGroupDR=pobj.EQGroupDR.%Id()
   } 
   else 
   {    
     s eobj.EQGroupDR=""
   }
  s:pobj.EQDateFrom'="" eobj.EQDateFrom =##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.EQDateFrom)   //从后台去数据为61999的数字格式,转化成日期格式
  s:pobj.EQDateTo'="" eobj.EQDateTo = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.EQDateTo)
  
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Function:用于数据删除时的逻辑判断
/// CreateDate:2013-8-27
/// Ctreator:BDP-Sunfengchao
/// Input:rowid  ^RB("RES",0,"EQ",{RES_EQ_DR},{RES_CTLOC_DR},{RES_RowId})
/// Output:返回一个标志位，0为未被引用，表示可以被删除，1表示已经被引用了，不能被删除
ClassMethod GetRefFlag(id As %String) As %String
{
  s return="",myInfo=""
  s found1=0
  if ($d(^RB("RES",0,"EQ",+id))) s found1=1
  if (found1=1)  s myInfo=myInfo_"<医护人员>"
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
/// Tables: RBC_Equipment
/// Others:do ##class(web.DHCBL.CT.RBCEquipment).DeleteData("")
ClassMethod DeleteData(id As %String) As %String
{
  s result="",flag="",RefFlag=""
  Tstart
  s pobj = ##class(User.RBCEquipment).%OpenId(id)
  s eobj = ##class(web.Entity.CT.RBCEquipment).%New()
  s eobj.EQRowId = id
  s eobj.EQCode=pobj.EQCode
  s eobj.EQDesc= pobj.EQDesc
  if (pobj.EQGroupDR'="")
  { 
   s eobj.EQGroupDR=pobj.EQGroupDR.%Id()
  }
  else 
  {    
    s eobj.EQGroupDR=""
  }
  s:pobj.EQDateFrom'="" eobj.EQDateFrom =pobj.EQDateFrom
  s:pobj.EQDateTo'="" eobj.EQDateTo = pobj.EQDateTo
  s re=##class(web.DHCBL.CT.RBCEquipment).GetRefFlag(id)
  s RefFlag=$p(re,"^",1)
  if (RefFlag=1)
  {
   s result="{success:'false',info:'"_$p(re,"^",2)_"'}"
  }
  else
  {
     s sc=##class(User.RBCEquipment).%DeleteId(id)
     if $$$ISOK(sc)
     {
       Tc
       s result="{success:'true',info:'删除成功！'}"
       d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("RBC_Equipment","User.RBCEquipment","规定资源",id,eobj.EQDesc,"D",eobj)
       d eobj.%Close()
     }
     else
     {
       Trollback
       s result= "{success:'false',info:'删除失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
       s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("规定资源","web.DHCBL.CT.RBCEquipment","DeleteData",eobj)
       s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
     }
  }
   q result
}

/// Function:实现数据重复校验
/// Creator:孙凤超
/// CreateDate:2012-11-07
/// Tables：RBC_Equipment
ClassMethod FormValidate(id As %String, code As %String, desc As %String, hospid As %String = "") As %String
{
    s flag=0
    if $$ALPHAUP^SSUTIL4(code)'=""
    {
        s idc=0
        for
        {
            s idc=$o(^RBC("EQ",0,"Code",$$ALPHAUP^SSUTIL4(code),idc)) q:idc=""
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
    
            s idd=$o(^RBC("EQ",0,"Desc",$$ALPHAUP^SSUTIL4(desc),idd)) q:idd=""
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

/// Function:实现对资源组规定资源的修改和保存操作
/// Creator:孙凤超
/// CreateDate:2012-08-29
/// Desc:通过rowid来修改或保存规定资源信息
/// Output: success:'true',info:'添加成功！' 失败时输出添加失败！
///         success:'false',info:'修改成功' 失败时输出修改失败！
/// Tables: RBC_Equipment
ClassMethod SaveEntity(eobj As web.Entity.CT.RBCEquipment) As %String
{
    s result=""
    s:eobj.EQDateFrom'="" eobj.EQDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.EQDateFrom)   
    s:eobj.EQDateTo'="" eobj.EQDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.EQDateTo)      
    s:eobj.EQDateFrom="" eobj.EQDateFrom=+$h
    s flag=..FormValidate(eobj.EQRowId,eobj.EQCode,eobj.EQDesc,eobj.LinkHospId)  //调用重复验证
    if (flag=1)
    {
        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
      if (eobj.EQRowId="")       
      {  
       s obj=##class(User.RBCEquipment).%New()
      }
      else  
      {
        s obj=##class(User.RBCEquipment).%OpenId(eobj.EQRowId)
        s bobj=##class(web.Entity.CT.RBCEquipment).%New()
        s bobj.EQRowId=eobj.EQRowId
        s bobj.EQCode = obj.EQCode                     
        s bobj.EQDesc= obj.EQDesc
        s:obj.EQGroupDR'="" bobj.EQGroupDR=obj.EQGroupDR.%Id()
        s:obj.EQGroupDR="" bobj.EQGroupDR=""
        s bobj.EQDateFrom=obj.EQDateFrom
        s bobj.EQDateTo=obj.EQDateTo
      }
       s obj.EQCode = eobj.EQCode                      
       s obj.EQDesc= eobj.EQDesc
       d obj.EQGroupDRSetObjectId(eobj.EQGroupDR)
       s obj.EQDateFrom=eobj.EQDateFrom
       s obj.EQDateTo=eobj.EQDateTo
       Tstart
       s sc=obj.%Save()
       if $$$ISOK(sc)
       {
        Tcommit
        s id = obj.%Id()
        s result = "{success:'true',id:'"_id_"'}"         //保存数据后,通过RowId返回到这条数据
        d:eobj.EQRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("RBC_Equipment","User.RBCEquipment","规定资源",eobj.EQRowId,eobj.EQDesc,"U",eobj,bobj)
        d:eobj.EQRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("RBC_Equipment","User.RBCEquipment","规定资源",id,eobj.EQDesc,"A",eobj)
       }
       else
       {
        Trollback
        s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
        s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("规定资源","web.DHCBL.CT.RBCEquipment","SaveEntity",eobj)
        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
       }  
    }
 q result
}

}
