Import SQLUser

/// Function: 资源定义维护
/// Creator:  基础数据平台组 孙凤超
/// CreateDate:2014-12-15
Class web.DHCBL.CT.RBResourceForOwn Extends %RegisteredObject
{

/// Creator：基础数据平台组 孙凤超
/// CreatDate:2014-12-15
/// Description：查询资源定义内容
/// Table： RB_Resource
/// Input：RowId1, Code, Desc, CTPCPCarPrvTpDR, ActiveFlag, InternalType
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.RBResourceForOwn","GetList","","","","3")
Query GetList(rowid, Code, desc, hospid As %String) As %Query(ROWSPEC = "RESRowId1,RESCTLOCDR,RESCTPCPDR,CTLOCDesc,CTPCPDesc,RESScheduleRequired,RESMRRequest,RESAdmittingRights,RESDateActiveFrom,RESDateActiveTo,RESIgnorePubHol,BDPInternalCode:%String,BDPInternalDesc:%String,BDPHospNationalCode:%String,BDPHospNationalDesc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, Code, desc, hospid As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 //s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag() 
 
 s AuStr=##class(web.DHCBL.Authorize.RBResourceForOwn).DHCGetDataByDefaultSession()
 s AuFlag=0
 ;未授权情况下，默认显示全部数据
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1  
 
 s AuRESCTLOCDRStr=##class(web.DHCBL.Authorize.CTLoc).DHCGetDataByDefaultSession()
 s AuRESCTLOCDRFlag=0
 
 ;未授权情况下，默认显示全部数据
 if (AuRESCTLOCDRStr="")||(AuRESCTLOCDRStr["limited:0") s AuRESCTLOCDRFlag=1  
 
 s AuRESCTPCPDRStr=##class(web.DHCBL.Authorize.CTCareProv).DHCGetDataByDefaultSession()
 s AuRESCTPCPDRFlag=0 
 if (AuRESCTPCPDRStr="")||(AuRESCTPCPDRStr["limited:0") s AuRESCTPCPDRFlag=1
  
 if (rowid'="")  
 {
  s RESRowId1=rowid
  s RESCTLOCDR=$p($g(^RB("RES",rowid)),"^",1)      
  s RESCTPCPDR=$p($g(^RB("RES",rowid)),"^",2)      
  s:RESCTLOCDR'="" CTLOCDesc=$p($g(^CTLOC(RESCTLOCDR)),"^",2)
  s:RESCTPCPDR'="" CTPCPDesc=$p($g(^CTPCP(RESCTPCPDR,1)),"^",2) 
  s RESEQDR=$p($g(^RB("RES",rowid)),"^",3)
  s RESScheduleRequired=$p($g(^RB("RES",rowid)),"^",6)
  s RESMRRequest=$p($g(^RB("RES",rowid)),"^",7)
  s RESDateTo=$p($g(^RB("RES",rowid)),"^",19)
  s RESAdmittingRights=$p($g(^RB("RES",rowid)),"^",20)
  S:RESAdmittingRights="" RESAdmittingRights="N"
  s RESIgnorePubHol=$p($g(^RB("RES",rowid)),"^",21)
  s:RESIgnorePubHol="" RESIgnorePubHol="N"
  s RESDateActiveFrom=$p($g(^RB("RES",rowid)),"^",22)
  s RESDateActiveTo=$p($g(^RB("RES",rowid)),"^",23)
  s:RESDateActiveFrom'="" RESDateActiveFrom=$zd(RESDateActiveFrom,1) 
  s:RESDateActiveTo'="" RESDateActiveTo=$zd(RESDateActiveTo,1)
  s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
  s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("RB_Resource",RESRowId1)
  s BDPInternalCode =$p($g(resultStr),"^",1)       
  s BDPInternalDesc = $p($g(resultStr),"^",2)  
  s BDPHospNationalCode=$p($g(resultStr),"^",3)         
  s BDPHospNationalDesc = $p($g(resultStr),"^",4)  

  d OutputRow
 }
 else
 {
  s RESRowId1=0
  for
  {  
     s RESRowId1=$o(^RB("RES",RESRowId1)) q:RESRowId1=""  
     s strRESRowId1="{ID:"_RESRowId1_"}"
     s RESCTLOCDR=""
     s RESCTLOCDR=$p($g(^RB("RES",RESRowId1)),"^",1) 
     s strRESCTLOCDR="{ID:"_RESCTLOCDR_"}"
     s RESCTPCPDR=$p($g(^RB("RES",RESRowId1)),"^",2)   
     s strRESCTPCPDR="{ID:"_RESCTPCPDR_"}"
     //s HospitalDR=$p($g(^CTLOC(RESCTLOCDR)),"^",22) 
     //s strHospitalID = "{ID:"_HospitalDR_"}"
     //if ((AuHospStr[strHospitalID)||(AuHospStr=1)||(AuHospStr="off")) 
     if ((AuStr[strRESRowId1)||(AuFlag=1))&((AuRESCTLOCDRStr[strRESCTLOCDR)||(AuRESCTLOCDRFlag=1)) &&((AuRESCTPCPDRStr[strRESCTPCPDR)||(AuRESCTPCPDRFlag=1))
     {   
       s RESCTLOCDR=$p($g(^RB("RES",RESRowId1)),"^",1)  
       s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_Loc",RESCTLOCDR,hospid)
       continue:showflag="N"       
       s:RESCTLOCDR'="" CTLOCDesc=$p($g(^CTLOC(RESCTLOCDR)),"^",2)
       s:RESCTLOCDR="" CTLOCDesc="" 
       s:RESCTPCPDR'="" CTPCPDesc=$p($g(^CTPCP(RESCTPCPDR,1)),"^",2) 
       s:RESCTPCPDR="" CTPCPDesc=""
       s RESEQDR=$p($g(^RB("RES",RESRowId1)),"^",3)
       s RESScheduleRequired=$p($g(^RB("RES",RESRowId1)),"^",6)
       s RESMRRequest=$p($g(^RB("RES",RESRowId1)),"^",7)
       s RESDateTo=$p($g(^RB("RES",RESRowId1)),"^",19)
       s RESAdmittingRights=$p($g(^RB("RES",RESRowId1)),"^",20)
       S:RESAdmittingRights="" RESAdmittingRights="N"
       s RESIgnorePubHol=$p($g(^RB("RES",RESRowId1)),"^",21)
       s:RESIgnorePubHol="" RESIgnorePubHol="N"
       s RESDateActiveFrom=$p($g(^RB("RES",RESRowId1)),"^",22)
       s RESDateActiveTo=$p($g(^RB("RES",RESRowId1)),"^",23)
       s:RESDateActiveFrom'="" RESDateActiveFrom=$zd(RESDateActiveFrom,1)  
       s:RESDateActiveTo'="" RESDateActiveTo=$zd(RESDateActiveTo,1)
       s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
       s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("RB_Resource",RESRowId1)
       s BDPInternalCode =$p($g(resultStr),"^",1)       
       s BDPInternalDesc = $p($g(resultStr),"^",2)  
       s BDPHospNationalCode=$p($g(resultStr),"^",3)         
       s BDPHospNationalDesc = $p($g(resultStr),"^",4) 
       if ((RESCTPCPDR'="")&(RESCTPCPDR=Code)||(Code="")&((desc="")||(RESCTLOCDR=desc))) 
       {
        d OutputRow
       }
     }
 }
}
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(RESRowId1,RESCTLOCDR,RESCTPCPDR,CTLOCDesc,CTPCPDesc,RESScheduleRequired,RESMRRequest,RESAdmittingRights,RESDateActiveFrom,RESDateActiveTo,RESIgnorePubHol,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Function: 后台分页 解决字符超长的问题
/// Other:    d ##class(web.DHCBL.CT.RBResourceForOwn).GetQuery("","","","","")
ClassMethod GetQuery(rowid As %String, code As %String, desc As %String, start As %String, limit As %String, hospid As %String) As %String
{
  s count=0 
  if (rowid'="")
  {  
      s count=1
      s RESRowId1=rowid
      s RESCTLOCDR=$p($g(^RB("RES",rowid)),"^",1)      
      s RESCTPCPDR=$p($g(^RB("RES",rowid)),"^",2)      
      s:RESCTLOCDR'="" CTLOCDesc=$p($g(^CTLOC(RESCTLOCDR)),"^",2)
      s:RESCTPCPDR'="" CTPCPDesc=$p($g(^CTPCP(RESCTPCPDR,1)),"^",2) 
      s RESEQDR=$p($g(^RB("RES",rowid)),"^",3)
      s RESScheduleRequired=$p($g(^RB("RES",rowid)),"^",6)
      s RESMRRequest=$p($g(^RB("RES",rowid)),"^",7)
      s RESDateTo=$p($g(^RB("RES",rowid)),"^",19)
      s RESAdmittingRights=$p($g(^RB("RES",rowid)),"^",20)
      S:RESAdmittingRights="" RESAdmittingRights="N"
      s RESIgnorePubHol=$p($g(^RB("RES",rowid)),"^",21)
      s:RESIgnorePubHol="" RESIgnorePubHol="N"
      s RESDateActiveFrom=$p($g(^RB("RES",rowid)),"^",22)
      s RESDateActiveTo=$p($g(^RB("RES",rowid)),"^",23)
      s:RESDateActiveFrom'="" RESDateActiveFrom=$zd(RESDateActiveFrom,1) 
      s:RESDateActiveTo'="" RESDateActiveTo=$zd(RESDateActiveTo,1)
      s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
      s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("RB_Resource",RESRowId1)
      s BDPInternalCode =$p($g(resultStr),"^",1)       
      s BDPInternalDesc = $p($g(resultStr),"^",2)  
      s BDPHospNationalCode=$p($g(resultStr),"^",3)         
      s BDPHospNationalDesc = $p($g(resultStr),"^",4)  
      w "{""RESRowId1"":"""_RESRowId1_""",""RESCTLOCDR"":"""_RESCTLOCDR_""",""RESCTPCPDR"":"""_RESCTPCPDR_""",""CTLOCDesc"":"""_CTLOCDesc_""",""CTPCPDesc"":"""_CTPCPDesc_",""_RESScheduleRequired"":"""_RESScheduleRequired_""",""RESMRRequest"":"""_RESMRRequest_""",""RESAdmittingRights"":"""_RESAdmittingRights_""",""RESDateActiveFrom"":"""_RESDateActiveFrom_""",""RESDateActiveTo"":"""_RESDateActiveTo_",""RESIgnorePubHol"":"""_RESIgnorePubHol _""",""BDPInternalCode"":"""_BDPInternalCode_""",""BDPInternalDesc"":"""_BDPInternalDesc_""",""BDPHospNationalCode"":"""_BDPHospNationalCode_""",""BDPHospNationalDesc"":"""_BDPHospNationalDesc_"""}"  
  }
  else
  {
    s:code'="" code=$ZCONVERT(code,"U")
    s:desc'="" desc=$ZCONVERT(desc,"U")
    if start="" s start=0
    if limit="" s limit=20
    s start=start+1
    s AuStr="" // ##class(web.DHCBL.Authorize.RBResourceForOwn).DHCGetDataByDefaultSession() 
    s AuFlag=0
    ;未授权情况下，默认显示全部数据
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1  
     
    s AuRESCTLOCDRStr=##class(web.DHCBL.Authorize.CTLoc).DHCGetDataByDefaultSession() 
    s AuRESCTLOCDRFlag=0
    ;未授权情况下，默认显示全部数据
    if (AuRESCTLOCDRStr="")||(AuRESCTLOCDRStr["limited:0") s AuRESCTLOCDRFlag=1  
     
    s CTCareProvDRStr=##class(web.DHCBL.Authorize.CTCareProv).DHCGetDataByDefaultSession() 
    s AuEQGroupDRFlag=0 
    if (CTCareProvDRStr="")||(CTCareProvDRStr["limited:0") s CTCareProvDRFlag=1   
    s RESRowId1=0
    for
    {  
       s RESRowId1=$o(^RB("RES",RESRowId1)) 
       q:RESRowId1=""  
       s strRESRowId1="{ID:"_RESRowId1_"}"
       s RESCTLOCDR=""
       s RESCTLOCDR=$p($g(^RB("RES",RESRowId1)),"^",1) 
       s strRESCTLOCDR="{ID:"_RESCTLOCDR_"}" 
       s RESCTPCPDR=$p($g(^RB("RES",RESRowId1)),"^",2) 
       s strCTCareProvDR="{ID:"_RESCTLOCDR_"}"
       s HospitalDR=$p($g(^CTLOC(RESCTLOCDR)),"^",22) 
       s strHospitalID = "{ID:"_HospitalDR_"}"
       if ((AuStr[strRESRowId1)||(AuFlag=1))&((AuRESCTLOCDRStr[strRESCTLOCDR)||(AuRESCTLOCDRFlag=1)) &&((CTCareProvDRStr[strCTCareProvDR)||(CTCareProvDRFlag=1))
       {
           s RESCTLOCDR=$p($g(^RB("RES",RESRowId1)),"^",1)         
           s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_Loc",RESCTLOCDR,hospid)
           continue:showflag="N"
           s:RESCTLOCDR'="" CTLOCDesc=$p($g(^CTLOC(RESCTLOCDR)),"^",2)
           s:RESCTLOCDR="" CTLOCDesc="" 
           s RESCTPCPDR=$p($g(^RB("RES",RESRowId1)),"^",2)   
           s:RESCTPCPDR'="" CTPCPDesc=$p($g(^CTPCP(RESCTPCPDR,1)),"^",2) 
           s:RESCTPCPDR="" CTPCPDesc="" 
           s RESEQDR=$p($g(^RB("RES",RESRowId1)),"^",3)
           if ((RESCTPCPDR'="")&(RESCTPCPDR=code)||(code="")&((desc="")||(RESCTLOCDR=desc))) 
           {
              s count=count+1
              if (count<start) continue
              if (count<(start+limit))
              {
                   s RESScheduleRequired=$p($g(^RB("RES",RESRowId1)),"^",6)
                   s RESMRRequest=$p($g(^RB("RES",RESRowId1)),"^",7)
                   s RESDateTo=$p($g(^RB("RES",RESRowId1)),"^",19)
                   s RESAdmittingRights=$p($g(^RB("RES",RESRowId1)),"^",20)
                   S:RESAdmittingRights="" RESAdmittingRights="N"
                   s RESIgnorePubHol=$p($g(^RB("RES",RESRowId1)),"^",21)
                   s:RESIgnorePubHol="" RESIgnorePubHol="N"  
                   s RESDateActiveFrom=$p($g(^RB("RES",RESRowId1)),"^",22)
                   s RESDateActiveTo=$p($g(^RB("RES",RESRowId1)),"^",23)
                   s:RESDateActiveFrom'="" RESDateActiveFrom=$zd(RESDateActiveFrom,1)  
                   s:RESDateActiveTo'="" RESDateActiveTo=$zd(RESDateActiveTo,1)
                   s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
                   s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("RB_Resource",RESRowId1)
                   s BDPInternalCode =$p($g(resultStr),"^",1)       
                   s BDPInternalDesc = $p($g(resultStr),"^",2)  
                   s BDPHospNationalCode=$p($g(resultStr),"^",3)         
                   s BDPHospNationalDesc = $p($g(resultStr),"^",4) 
                   if ((count#limit)=1)
                   {
                        w "{""RESRowId1"":"""_RESRowId1_""",""RESCTLOCDR"":"""_RESCTLOCDR_""",""RESCTPCPDR"":"""_RESCTPCPDR_""",""CTLOCDesc"":"""_CTLOCDesc_""",""CTPCPDesc"":"""_CTPCPDesc_""",""RESScheduleRequired"":"""_RESScheduleRequired_""",""RESMRRequest"":"""_RESMRRequest_""",""RESAdmittingRights"":"""_RESAdmittingRights_""",""RESDateActiveFrom"":"""_RESDateActiveFrom_""",""RESDateActiveTo"":"""_RESDateActiveTo_""",""RESIgnorePubHol"":"""_RESIgnorePubHol _""",""BDPInternalCode"":"""_BDPInternalCode_""",""BDPInternalDesc"":"""_BDPInternalDesc_""",""BDPHospNationalCode"":"""_BDPHospNationalCode_""",""BDPHospNationalDesc"":"""_BDPHospNationalDesc_"""}"  
         
                   }
                   else
                   {
                        w ",{""RESRowId1"":"""_RESRowId1_""",""RESCTLOCDR"":"""_RESCTLOCDR_""",""RESCTPCPDR"":"""_RESCTPCPDR_""",""CTLOCDesc"":"""_CTLOCDesc_""",""CTPCPDesc"":"""_CTPCPDesc_""",""RESScheduleRequired"":"""_RESScheduleRequired_""",""RESMRRequest"":"""_RESMRRequest_""",""RESAdmittingRights"":"""_RESAdmittingRights_""",""RESDateActiveFrom"":"""_RESDateActiveFrom_""",""RESDateActiveTo"":"""_RESDateActiveTo_""",""RESIgnorePubHol"":"""_RESIgnorePubHol _""",""BDPInternalCode"":"""_BDPInternalCode_""",""BDPInternalDesc"":"""_BDPInternalDesc_""",""BDPHospNationalCode"":"""_BDPHospNationalCode_""",""BDPHospNationalDesc"":"""_BDPHospNationalDesc_"""}"  
         
                   }
            }
         }
       }       
    }  
  }  
  s ^TMP("web.RBResourceForOwn","Count",$j)=count
}

/// Function: 调csp时拼装json串
/// CreateDate:2017-3-14
/// Creator:  sunfengchao
/// Debug:    d ##class(web.DHCBL.CT.RBResourceForOwn).GetList("","","","0","3")
ClassMethod GetList(rowid As %String, Code As %String, desc As %String, start As %String, limit As %String, hospid As %String) As %String
{
  s count=0
  w "{""success"":""true"",""data"":[" 
  d ..GetQuery(rowid,Code,desc,start,limit,hospid)
  w "]" 
  s count=$g(^TMP("web.RBResourceForOwn","Count",$j))
  w ",total:"_count
  w "}"
}

/// Creator：基础数据平台组 孙凤超
/// CreatDate:2014-12-15
/// Description：双击打开资源定义内容
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

/// Creator：基础数据平台组 孙凤超
/// CreatDate:2014-12-15
/// Description：验证重复：资源定义 
/// Table：RB_Resource
/// Dubug: d ##class(web.DHCBL.CT.RBResource).Validate("","","")
ClassMethod Validate(id As %String, CTPCP As %String, CTLOC As %String) As %String
{
 s flag="",flagd=""
 if (CTLOC="") q 0
 if (CTPCP="") q 0
 s flagd=$d(^RB("RES",0,"CTPCP",CTPCP,CTLOC))
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
  s idd=$o(^RB("RES",0,"CTPCP",CTPCP,CTLOC,0))
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

/// Function: check if allowed to delete resource
/// Creator:  基础数据平台组 孙凤超
/// CreateDate:  2014-12-15
/// Table:    RB_Resource
ClassMethod GetRefFlag(RowId As %String)
{
 &SQL(SELECT APPT_RowId
      FROM   RB_Appointment
      WHERE  APPT_AS_ParRef->AS_RES_ParRef=:RowId)
 q $s(SQLCODE:0,1:100)
}

/// Creator：基础数据平台组 孙凤超
/// CreatDate:2014-12-15
/// Description:根据id删除关联科室
/// Table: RB_Resource
/// Input:id(RBResource的RESRowId1) 
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.RBResource).DeleteData("546")
ClassMethod DeleteData(id As %String) As %String
{
  s result="",AsChildSub=0,flag=0
  f  s AsChildSub=$o(^RBAS(id,AsChildSub))  q:AsChildSub=""  d
  .s:($d(^RBAS(id,AsChildSub,"APPT"))'=0)&($o(^RBAS(id,AsChildSub,"APPT",0))'="") flag=1
  if (flag=1)
  {
   s result="{success:'false',info:'该条数据已被引用，无法删除！'}"
  }
  else
  {
    Tstart
    s eobj = ##class(web.Entity.CT.RBResourceForOwn).%New()
    s pobj = ##class(User.RBResource).%OpenId(id)
    s eobj.RESRowId1 = id
    s eobj.RESMRRequest = pobj.RESMRRequest
    s:pobj.RESCTPCPDR'="" eobj.RESCTPCPDR = pobj.RESCTPCPDR.%Id()
    s:pobj.RESCTLOCDR'="" eobj.RESCTLOCDR = pobj.RESCTLOCDR.%Id()
    s eobj.RESScheduleRequired = pobj.RESScheduleRequired
    s eobj.RESAdmittingRights = pobj.RESAdmittingRights 
    s eobj.RESIgnorePubHol=pobj.RESIgnorePubHol
    s CTLOCDesc=$p($g(^CTLOC(eobj.RESCTLOCDR)),"^",2)
    s CTPCPDesc=$p($g(^CTPCP(eobj.RESCTPCPDR,1)),"^",2) 
    s sc=##class(User.RBResource).%DeleteId(id)
    if $$$ISOK(sc)
    {
      Tcommit
      d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("RB_Resource","User.RBResource","资源定义",id,CTPCPDesc_"->"_CTLOCDesc,"D",eobj)
      s result="{success:'true',info:'删除成功！'}"  
    }
    else
    {
      Trollback
      s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
      s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("资源定义","web.DHCBL.CT.RBResourceForOwn","DeleteData",eobj)
      s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
     }
   }
   q result
}

/// Creator：基础数据平台组 孙凤超
/// CreatDate:2014-12-15
/// Description :新增或修改的数据
/// Table: RB_Resource
/// Input：web.Entity.CT.RBResource 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.RBResourceForOwn) As %String
{
  s result="",flag=""
  if eobj.RESDateActiveFrom'="" s eobj.RESDateActiveFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.RESDateActiveFrom)   
  if eobj.RESDateActiveTo'="" s eobj.RESDateActiveTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.RESDateActiveTo)      
  if eobj.RESDateActiveFrom="" s eobj.RESDateActiveFrom=+$h
  s flag=##class(web.DHCBL.CT.RBResource).Validate(eobj.RESRowId1,eobj.RESCTPCPDR,eobj.RESCTLOCDR)  
  if (flag=1)
  {
    s result = "{success:'false',errorinfo:'该医护人员已与科室进行关联！'}"
  }
  else
  {
    Tstart
    if (eobj.RESRowId1="")
    { 
      s obj=##class(User.RBResource).%New()
      s cobj=##class(User.CTCareProv).%OpenId(eobj.RESCTPCPDR)   
      s obj.RESCode = cobj.CTPCPCode 
      s obj.RESDesc = cobj.CTPCPDesc  
    }
    else 
    {
      s obj=##class(User.RBResource).%OpenId(eobj.RESRowId1)
      s bobj=##class(web.Entity.CT.RBResourceForOwn).%New()
      s bobj.RESRowId1=eobj.RESRowId1
      s:obj.RESCTPCPDR'="" bobj.RESCTPCPDR = obj.RESCTPCPDR.%Id()
      s:obj.RESCTLOCDR'="" bobj.RESCTLOCDR = obj.RESCTLOCDR.%Id()
      
      s:obj.RESAdmittingRights="" obj.RESAdmittingRights="N"
      s:obj.RESScheduleRequired="" obj.RESScheduleRequired="N"
      s:obj.RESMRRequest="" obj.RESMRRequest="N"
      s:obj.RESIgnorePubHol="" obj.RESIgnorePubHol="N"
      
      s bobj.RESAdmittingRights=obj.RESAdmittingRights
      s bobj.RESScheduleRequired=obj.RESScheduleRequired
      s bobj.RESMRRequest=obj.RESMRRequest
      s bobj.RESIgnorePubHol=obj.RESIgnorePubHol
      s bobj.RESDateActiveFrom=obj.RESDateActiveFrom 
      s bobj.RESDateActiveTo=obj.RESDateActiveTo
    }     
   d obj.RESCTPCPDRSetObjectId(eobj.RESCTPCPDR)
   if (obj.RESCTPCPDR'=eobj.RESCTPCPDR)
   {
     d obj.RESCTLOCDRSetObjectId(eobj.RESCTLOCDR)
     s cobj=##class(User.CTCareProv).%OpenId(eobj.RESCTPCPDR)
     s obj.RESCode = cobj.CTPCPCode 
     s obj.RESDesc = cobj.CTPCPDesc
   } 
  
   /// 不考虑公共假日
  s:eobj.RESIgnorePubHol="" eobj.RESIgnorePubHol="N"
  s obj.RESIgnorePubHol=eobj.RESIgnorePubHol
  
  //管理
  s:eobj.RESAdmittingRights="" eobj.RESAdmittingRights = "N"
  s obj.RESAdmittingRights=eobj.RESAdmittingRights 
  //需要排班
  s:eobj.RESScheduleRequired="" eobj.RESScheduleRequired = "N"
  s obj.RESScheduleRequired=eobj.RESScheduleRequired  
  //需要病历
  s:eobj.RESMRRequest="" eobj.RESMRRequest="N"
  s obj.RESMRRequest=eobj.RESMRRequest 
 
  
  s obj.RESDateActiveFrom =eobj.RESDateActiveFrom 
  s obj.RESDateActiveTo=eobj.RESDateActiveTo  
  s CTLOCDesc=$p($g(^CTLOC(eobj.RESCTLOCDR)),"^",2)
  s CTPCPDesc=$p($g(^CTPCP(eobj.RESCTPCPDR,1)),"^",2)
  s sc=obj.%Save()
  d obj.%Close()
  If $$$ISOK(sc)
  {
   Tc
   s id = obj.%Id()
   s result = "{success:'true',id:'"_id_"'}"          
   if (eobj.RESRowId1="")
   {
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("RB_Resource","User.RBResource","资源定义",id,CTPCPDesc_"->"_CTLOCDesc,"A",eobj)
   }
   else
   {
     d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("RB_Resource","User.RBResource","资源定义",id,CTPCPDesc_"->"_CTLOCDesc,"U",eobj,bobj)
   }
  }
  else
  {
    Trollback
    s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("资源定义","web.DHCBL.CT.RBResourceForOwn","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)  
  }
 }  
 q result
}

}
