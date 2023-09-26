/// Function: 资源预约-分配资源到科室 业务类
/// Creator:  sunfengchao
/// CreateDate: 2015-4-9
Class web.DHCBL.CT.RBResourceForEQ Extends %RegisteredObject
{

Parameter SQLTableName = "RB_Resource";

/// Function：查询分配资源到科室
/// Creator： sunfengchao
/// CreatDate:2015-4-9
/// Table：RB_Resource
/// Input：rowid, Code, desc
/// Other: d ##class(%ResultSet).RunQuery("web.a 45`12CBL.CT.RBResourceForEQ","GetList","","","")
Query GetList(rowid, Code, desc, hospid As %String) As %Query(ROWSPEC = "RESRowId1,RESCTLOCDR,RESEQDR,RESDateActiveFrom,RESDateActiveTo,RESCTLOCRowid,RESEQRowid")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, Code, desc, hospid As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s AuStr=##class(web.DHCBL.Authorize.RBResourceForEQ).DHCGetDataByDefaultSession()
 s AuFlag=0
 ;未授权情况下，默认显示全部数据
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1  
 
 s AuRESCTLOCDRStr=##class(web.DHCBL.Authorize.CTLoc).DHCGetDataByDefaultSession()
 s AuRESCTLOCDRFlag=0
 ;未授权情况下，默认显示全部数据
 if (AuRESCTLOCDRStr="")||(AuRESCTLOCDRStr["limited:0") s AuRESCTLOCDRFlag=1  
 
 s AuEQGroupDRStr=##class(web.DHCBL.Authorize.RBCEquipment).DHCGetDataByDefaultSession()
 s AuEQGroupDRFlag=0 
 if (AuEQGroupDRStr="")||(AuEQGroupDRStr["limited:0") s AuEQGroupDRFlag=1
 if (rowid'="")  
 {
  s RESRowId1=rowid
  s RESCTLOCDR="",RESCTLOCRowid=""
  s RESCTLOCDR=$p($g(^RB("RES",rowid)),"^",1)     
  s RESCTLOCRowid= RESCTLOCDR
  s:RESCTLOCDR'="" RESCTLOCDR=$p($g(^CTLOC(RESCTLOCDR)),"^",2)
  
  s RESEQDR="",RESEQRowid=""
  s RESEQDR=$p($g(^RB("RES",rowid)),"^",3)
  s RESEQRowid=RESEQDR
  s:RESEQDR'="" RESEQDR=$p($g(^RBC("EQ",RESEQDR)),"^",2)
   
  s RESDateActiveFrom=$p($g(^RB("RES",rowid)),"^",22)
  s RESDateActiveTo=$p($g(^RB("RES",rowid)),"^",23)
  s:RESDateActiveFrom'="" RESDateActiveFrom=$zd(RESDateActiveFrom,1) 
  s:RESDateActiveTo'="" RESDateActiveTo=$zd(RESDateActiveTo,1) 
  d OutputRow
 }
 else
 {
  s RESRowId1=0
  for
  {  
     s RESRowId1=$o(^RB("RES",RESRowId1)) q:RESRowId1=""  
     s strRESRowId1="{ID:"_RESRowId1_"}"
     s RESCTLOCDR=$p($g(^RB("RES",RESRowId1)),"^",1) 
     s strRESCTLOCDR="{ID:"_RESCTLOCDR_"}"
     s RESEQDR=$p($g(^RB("RES",RESRowId1)),"^",3)
     s strEQGroupDR="{ID:"_RESEQDR_"}"
     if ((AuStr[strRESRowId1)||(AuFlag=1))&((AuRESCTLOCDRStr[strRESCTLOCDR)||(AuRESCTLOCDRFlag=1)) &&((AuEQGroupDRStr[strEQGroupDR)||(AuEQGroupDRFlag=1))
     {
    /*   
     s RESCTLOCDR=""
     s RESCTLOCDR=$p($g(^RB("RES",RESRowId1)),"^",1) 
     s HospitalDR=$p($g(^CTLOC(RESCTLOCDR)),"^",22) 
     s strHospitalID = "{ID:"_HospitalDR_"}"
     if ((AuHospStr[strHospitalID)||(AuHospStr=1)||(AuHospStr="off")) 
     {    
     */
     	
       s RESCTLOCRowid="", RESEQRowid="" 
       s RESCTLOCRowid= RESCTLOCDR
       s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_Loc",RESCTLOCDR,hospid)
	   continue:showflag="N"        
       s:RESCTLOCDR'="" RESCTLOCDR=$p($g(^CTLOC(RESCTLOCDR)),"^",2)
       
       s RESEQRowid=RESEQDR
       s:RESEQDR'="" RESEQDR=$p($g(^RBC("EQ",RESEQDR)),"^",2) 
       if (RESEQDR'="")
       {
         s RESDateActiveFrom=$p($g(^RB("RES",RESRowId1)),"^",22)
         s RESDateActiveTo=$p($g(^RB("RES",RESRowId1)),"^",23)
         s:RESDateActiveFrom'="" RESDateActiveFrom=$zd(RESDateActiveFrom,1)  
         s:RESDateActiveTo'="" RESDateActiveTo=$zd(RESDateActiveTo,1)
         if ((desc="")||(RESCTLOCRowid=desc))&&((Code="")||(RESEQRowid=Code))
         {
           d OutputRow
         }
      } 
    }
   }
  }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(RESRowId1,RESCTLOCDR,RESEQDR,RESDateActiveFrom,RESDateActiveTo,RESCTLOCRowid,RESEQRowid)
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

/// Function：验证重复
/// Creator：Sunfengchao
/// CreatDate:2015-4-10 
/// Table：RB_Resource
/// Dubug: d ##class(web.DHCBL.CT.RBResource).Validate("","","")
ClassMethod Validate(id As %String, CTEQ As %String, CTLOC As %String) As %String
{
 s flag="",flagd=""
 if (CTLOC="") q 0
 if (CTEQ="") q 0
 s flagd=$d(^RB("RES",0,"EQ",CTEQ,CTLOC))
 if (id="") //如果为空，增加时的重复判断
 {
  if (flagd>0)
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
  s idd="" 
  s idd=$o(^RB("RES",0,"EQ",CTEQ,CTLOC,0))
  if ((idd'=id)&(flagd>0))
  {
   s flag=1  //返回重复标志
  }
  else
  {
   s flag=0 //返回不重复标志
  }
 }
 q flag
}

/// Function:根据id删除分配资源到科室
/// Creator： sunfengchao
/// CreatDate:2015-4-9
/// Table: RB_Resource
/// Input:id(RBResource的RESRowId1) 
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.RBResourceForEQ).DeleteData("546")
ClassMethod DeleteData(id As %String) As %String
{
    s result="" 
    Tstart
    s eobj = ##class(web.Entity.CT.RBResourceForEQ).%New()
    s pobj = ##class(User.RBResource).%OpenId(id)
    s eobj.RESRowId1 = id
    s:pobj.RESCTLOCDR'="" eobj.RESCTLOCDR = pobj.RESCTLOCDR.%Id()
    s:pobj.RESEQDR'="" eobj.RESEQDR=pobj.RESEQDR.%Id()
    s:pobj.RESDateActiveFrom'="" eobj.RESDateActiveFrom = $zd(pobj.RESDateActiveFrom,3)
    s:pobj.RESDateActiveTo'="" eobj.RESDateActiveTo = $zd(pobj.RESDateActiveTo,3)
    s sc=##class(User.RBResource).%DeleteId(id)
    if $$$ISOK(sc)
    {
      Tcommit
      d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("RB_Resource","User.RBResource","资源分配科室",id,eobj.RESCTLOCDR ,"D",eobj)
      s result="{success:'true',info:'删除成功！'}"  
    }
    else
    {
      Trollback
      s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
      s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("资源分配科室","web.DHCBL.CT.RBResourceForEQ","DeleteData",eobj)
      s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
     }
   q result
}

/// Function :新增或修改的数据
/// Creator：sunfengchao
/// CreatDate:2015-4-9
/// Table: RB_Resource
/// Input：web.Entity.CT.RBResource 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.RBResourceForEQ) As %String
{
  s result="",flag=""
  if eobj.RESDateActiveFrom'="" s eobj.RESDateActiveFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.RESDateActiveFrom)   
  if eobj.RESDateActiveTo'="" s eobj.RESDateActiveTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.RESDateActiveTo)      
  s flag=##class(web.DHCBL.CT.RBResourceForEQ).Validate(eobj.RESRowId1,eobj.RESEQDR,eobj.RESCTLOCDR)  
  if (flag=1)
  {
    s result = "{success:'false',errorinfo:'资源已分配到该科室下！'}"
  }
  else
  { 
    if (eobj.RESRowId1="")
    { 
      s obj=##class(User.RBResource).%New()
    }
    else 
    {  
      s obj=##class(User.RBResource).%OpenId(eobj.RESRowId1)
      s bobj=##class(web.Entity.CT.RBResourceForEQ).%New()
      s bobj.RESRowId1=eobj.RESRowId1
      s:obj.RESCTLOCDR'="" bobj.RESCTLOCDR = obj.RESCTLOCDR.%Id()
      s:obj.RESEQDR'="" bobj.RESEQDR=obj.RESEQDR.%Id()
      s bobj.RESDateActiveTo=obj.RESDateActiveTo
      s bobj.RESDateActiveFrom=obj.RESDateActiveFrom 
    }     
  Tstart  
  d obj.RESCTLOCDRSetObjectId(eobj.RESCTLOCDR)
  d obj.RESEQDRSetObjectId(eobj.RESEQDR)
  s obj.RESDesc=$$CO07^at8038a("",eobj.RESEQDR)  // 保存 ResDesc
  if (eobj.RESDateActiveFrom="") s eobj.RESDateActiveFrom = ""
  s obj.RESDateActiveFrom = eobj.RESDateActiveFrom 
  if eobj.RESDateActiveTo=""  s obj.RESDateActiveTo = "" 
  s obj.RESDateActiveTo =eobj.RESDateActiveTo 
  s sc=obj.%Save()
  d obj.%Close()
  If $$$ISOK(sc)
  {
   Tc
   s id = obj.%Id()
   s result = "{success:'true',id:'"_id_"'}"  
   s CTLOCDesc=$p($g(^CTLOC(eobj.RESCTLOCDR)),"^",2)    
   if (eobj.RESRowId1="")
   {
     d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("RB_Resource","User.RBResource","指定资源到科室",id,CTLOCDesc,"A",eobj)
   }
   else
   {
     d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("RB_Resource","User.RBResource","指定资源到科室",id,CTLOCDesc,"U",eobj,bobj)
   }
  }
  else
  {
    Trollback
    s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("资源定义","web.DHCBL.CT.RBResourceForEQ","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)  
  }
}
 q result
}

/// Creator：基础数据平台组 孙凤超
/// CreatDate:2014-12-15
/// Description：分配资源到科室内容
/// Table：RB_Resource
/// Input：RowId1, Code, Desc, CTPCPCarPrvTpDR, ActiveFlag, InternalType
/// Debug: w ##(web.DHCBL.CT.RBResourceForOwn ).OpenData("1")
ClassMethod OpenData(RowId As %String) As %String
{
 s str="" 
 s eobj = ##class(web.Entity.CT.RBResource).%New()
 s pobj = ##class(User.RBResource).%OpenId(RowId)
 s eobj.RESRowId1 = RowId
 s eobj.RESMRRequest = pobj.RESMRRequest
 s:pobj.RESCTPCPDR'="" eobj.RESCTPCPDR = pobj.RESCTPCPDR.%Id()
 s:pobj.RESCTLOCDR'="" eobj.RESCTLOCDR = pobj.RESCTLOCDR.%Id()
 s eobj.RESScheduleRequired = pobj.RESScheduleRequired
 s eobj.RESAdmittingRights = pobj.RESAdmittingRights 
 s eobj.RESIgnorePubHol=pobj.RESIgnorePubHol
 s:pobj.RESDateActiveFrom'="" eobj.RESDateActiveFrom = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.RESDateActiveFrom)
 s:pobj.RESDateActiveTo'="" eobj.RESDateActiveTo = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.RESDateActiveTo)
 s:eobj.RESMRRequest="Y" eobj.RESMRRequest="true"
 s:eobj.RESScheduleRequired="Y" eobj.RESScheduleRequired="true" 
 s:eobj.RESAdmittingRights="Y" eobj.RESAdmittingRights="true" 
 s:eobj.RESIgnorePubHol="Y" eobj.RESIgnorePubHol="true"
 s str = eobj.JsonS() 
 s str = "{data:["_str_"]}"
 d pobj.%Close() 
 k pobj 
 q str
}

}
