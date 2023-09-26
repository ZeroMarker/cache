/// Function: 电子病历-身体部位 业务类
/// Creator:  基础数据平台组 sunfengchao
/// CreateDate: 2014-12-17
/// BODP_RowId BODP_Code BODP_Desc BODP_CTLOC_DR
Class web.DHCBL.CT.MRCBodyParts Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：基础数据平台组 孙凤超
/// CreatDate:2014-12-15
/// Description：查询电子病历-身体部位
/// Table： MRC_BodyParts
/// Input: rowid code desc
/// Output： BODPRowId BODPCode BODPDesc BODPCTLOCDR
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.MRCBodyParts","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "BODPRowId,BODPCode,BODPDesc,BODPCTLOCDR,BODPInfusionFlag,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s AuStr=##class(web.DHCBL.Authorize.MRCBodyParts).DHCGetDataByDefaultSession()
 s AuBODPCTLOCDRStr=##class(web.DHCBL.Authorize.CTLoc).DHCGetDataByDefaultSession()
 s AuFlag=0
 ;未授权情况下，默认显示全部数据
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
 s AuBODPCTLOCDRFlag=0
 if (AuBODPCTLOCDRStr="")||(AuBODPCTLOCDRStr["limited:0") s AuBODPCTLOCDRFlag=1
 s:code'="" code=$zcvt(code,"U")
 s:desc'="" desc=$zcvt(desc,"U")
 if (rowid'="")  
 {
  s BODPRowId=rowid
  s BODPCode=$p($g(^MRC("BODP",rowid)),"^",1) 
  s BODPDesc=$p($g(^MRC("BODP",rowid)),"^",2) 
  s BODPCTLOCDR=$p($g(^MRC("BODP",rowid)),"^",3)      
  s:BODPCTLOCDR'="" BODPCTLOCDR=$p($g(^CTLOC(BODPCTLOCDR)),"^",2)
  s BODPInfusionFlag=$p($g(^MRC("BODP",rowid)),"^",4)    
  s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
  s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("MRC_BodyParts",BODPRowId)
  s BDPInternalCode =$p($g(resultStr),"^",1)       
  s BDPInternalDesc = $p($g(resultStr),"^",2)  
  s BDPHospNationalCode=$p($g(resultStr),"^",3)         
  s BDPHospNationalDesc = $p($g(resultStr),"^",4) 
  d OutputRow
 }
 else
 {
  s BODPRowId=0
  for
  {  
   s BODPRowId=$o(^MRC("BODP",BODPRowId)) q:BODPRowId=""  
   s strBODPRowId="{ID:"_BODPRowId_"}"
   s BODPCTLOCDR=$p($g(^MRC("BODP",BODPRowId)),"^",3)      
   s strBODPCTLOCDR="{ID:"_BODPCTLOCDR_"}"
   if ((AuStr[strBODPRowId)||(AuFlag=1))&((AuBODPCTLOCDRStr[strBODPCTLOCDR)||(AuBODPCTLOCDRFlag=1))  
   { 
     s BODPCode=$p($g(^MRC("BODP",BODPRowId)),"^",1) 
     s BODPDesc=$p($g(^MRC("BODP",BODPRowId)),"^",2)  
     s:BODPCTLOCDR'="" BODPCTLOCDR=$p($g(^CTLOC(BODPCTLOCDR)),"^",2)
     s BODPInfusionFlag=$p($g(^MRC("BODP",BODPRowId)),"^",4) 
     s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
     s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("MRC_BodyParts",BODPRowId)
     s BDPInternalCode =$p($g(resultStr),"^",1)       
     s BDPInternalDesc = $p($g(resultStr),"^",2)  
     s BDPHospNationalCode=$p($g(resultStr),"^",3)         
     s BDPHospNationalDesc = $p($g(resultStr),"^",4)  
     if (desc'="")
     {
        ;需要对描述或者别名进行检索      
        s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("MRC_BodyParts",BODPRowId,BODPDesc,desc)
     }
     else
     {
        s AliasFlag= 1   
     }    
     if ($ZCVT(BODPCode,"U")[code)&(AliasFlag=1)  
     {
        d OutputRow
     }
    }
   }  
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(BODPRowId,BODPCode,BODPDesc,BODPCTLOCDR,BODPInfusionFlag,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Function:   为comb提供查询查询电子病历-身体部位信息的接口
/// CreateDate: 2014-12-17
/// Creator:    基础数据平台公共产品组 孙凤超
/// Table：     MRC_BodyParts
/// Input:      code, desc 
/// Output:     BODPRowId,BODPCode,BODPDesc
/// Others:     d ##class(%ResultSet).RunQuery("web.DHCBL.CT.MRCBodyParts","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "BODPRowId,BODPCode,BODPDesc")
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
  
  s AuStr=##class(web.DHCBL.Authorize.ARCBillGrp).DHCGetDataByDefaultSession()
  s AuFlag=0
   ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  s AuBODPCTLOCDRStr=##class(web.DHCBL.Authorize.CTLoc).DHCGetDataByDefaultSession()
  s AuBODPCTLOCDRFlag=0
  if (AuBODPCTLOCDRStr="")||(AuBODPCTLOCDRStr["limited:0") s AuBODPCTLOCDRFlag=1 
  if (rowid'="")  
  {
     s BODPRowId=rowid
     s BODPCode=$p($g(^MRC("BODP",rowid)),"^",1) 
     s BODPDesc=$p($g(^MRC("BODP",rowid)),"^",2) 
     d OutputRowCmb
  }
  else
  {
    s BODPRowId=0
    for
    {  
     s BODPRowId=$o(^MRC("BODP",BODPRowId)) q:BODPRowId=""  
     s strBODPRowId="{ID:"_BODPRowId_"}"
     s BODPCTLOCDR=$p($g(^MRC("BODP",BODPRowId)),"^",3)      
     s strBODPCTLOCDR="{ID:"_BODPCTLOCDR_"}"
     if ((AuStr[strBODPRowId)||(AuFlag=1))&((AuBODPCTLOCDRStr[strBODPCTLOCDR)||(AuBODPCTLOCDRFlag=1))  
     {
     
       s BODPCode=$p($g(^MRC("BODP",BODPRowId)),"^",1) 
       s BODPDesc=$p($g(^MRC("BODP",BODPRowId)),"^",2) 
       s BODPCTLOCDR=$p($g(^MRC("BODP",BODPRowId)),"^",3)      
       s:BODPCTLOCDR'="" BODPCTLOCDR=$p($g(^CTLOC(BODPCTLOCDR)),"^",2)
       if (desc'="")
       {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("MRC_BodyParts",BODPRowId,BODPDesc,desc)
       }
       else
       {
         s AliasFlag= 1   
       }    
       if ($ZCVT(BODPCode,"U")[code)&(AliasFlag=1)   
       {
           d OutputRowCmb
       }
      }
   }  
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(BODPRowId,BODPCode,BODPDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function: 打开数据
/// CreateDate: 2014-12-17
/// Creator: 基础数据平台公共产品组 孙凤超
/// Input:   输入id
/// Tables:  MRC_BodyParts
/// Others:  w ##Class(web.DHCBL.CT.MRCBodyParts).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
   s str=""
   s pobj = ##class(User.MRCBodyParts).%OpenId(id)
   s eobj = ##class(web.Entity.CT.MRCBodyParts).%New()
   s eobj.BODPRowId = id
   s eobj.BODPCode=pobj.BODPCode
   s eobj.BODPDesc= pobj.BODPDesc
   s:pobj.BODPCTLOCDR'="" eobj.BODPCTLOCDR=pobj.BODPCTLOCDR.%Id()
   s eobj.BODPInfusionFlag=pobj.BODPInfusionFlag
   if eobj.BODPInfusionFlag="Y" s eobj.BODPInfusionFlag="true"
   d pobj.%Close()
   k pobj
   s str = eobj.JsonS()
   s str = "{list:["_str_"]}"
   q str
}

/// Creator:高姗姗
/// CreatDate:2016-8-9
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// Other: w ##class(web.DHCBL.CT.MRCBodyParts).GetRefFlag(6)
ClassMethod GetRefFlag(id As %String) As %String
{
  s return="",myInfo=""
  
  s BODPCode=$p($g(^MRC("BODP",id)),"^",1) 
  i ($o(^DHCPHPACON(0,"HisCode",BODPCode,"")))
  {
    s myInfo=myInfo_"<检查部位和HIS部位对照表>"
  }
  
  i myInfo="" s return="0^未被引用可删除！"
  else  s return="1^在"_myInfo_"表里被引用,不能删除！"
  q return
}

/// Function:实现对身体部位的删除操作
/// Creator:基础数据平台-孙凤超
/// CreateDate:2014-12-17
/// Input: id
/// Output:success:'true',info:'删除成功！ 失败时输出删除失败！
/// Tables: MRC_BodyParts  
/// Others:do ##class(web.DHCBL.CT.MRCBodyParts).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
   s result="" 
   s re=##class(web.DHCBL.CT.MRCBodyParts).GetRefFlag(id)
   s RefFlag=$p(re,"^",1)
   if (RefFlag=0){
   Tstart
   s pobj = ##class(User.MRCBodyParts).%OpenId(id)
   s eobj = ##class(web.Entity.CT.MRCBodyParts).%New()
   s eobj.BODPRowId = id
   s eobj.BODPCode=pobj.BODPCode
   s eobj.BODPDesc= pobj.BODPDesc
   s:pobj.BODPCTLOCDR'="" eobj.BODPCTLOCDR=pobj.BODPCTLOCDR.%Id() 
   s:pobj.BODPCTLOCDR="" eobj.BODPCTLOCDR=""
   s eobj.BODPInfusionFlag=pobj.BODPInfusionFlag
   s sc=##class(User.MRCBodyParts).%DeleteId(id)
   if $$$ISOK(sc)
   {
     Tc
     s result="{success:'true',info:'删除成功！'}"
     d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MRC_BodyParts","User.MRCBodyParts","电子病例-身体部位",id,eobj.BODPDesc,"D",eobj)
     d eobj.%Close()
   }
   else
   {
     Trollback
     s result= "{success:'false',info:'删除失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
     s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("电子病例-身体部位","web.DHCBL.CT.MRCBodyParts","DeleteData",eobj)
     s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)     
   }
  }
  else{
    s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("电子病例-身体部位","web.DHCBL.CT.MRCBodyParts","DeleteData","")
    s ^ERRORLOGINFO(logid)=$p(re,"^",2) 
  }
   q result
}

/// Function:实现对 电子病例-身体部位 数据重复校验
///  Creator: 基础数据平台组 孙凤超
///  CreateDate:2014-12-17
/// Tables： MRC_BodyParts
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s flag="",flagc="",flagd=""
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //此处用于转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //此处用于转换成大写
  
 s:code'="" flagc=$d(^MRC("BODP",0,"Code",code))
 s:desc'="" flagd=$d(^MRC("BODP",0,"Desc",desc))
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
  s:code'="" idc=$o(^MRC("BODP",0,"Code",code,0))
  s:desc'="" idd=$o(^MRC("BODP",0,"Desc",desc,0))
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

/// Function: 实现对电子病理-身体部位的修改和保存操作
/// Creator:  基础数据平台组 孙凤超
/// CreateDate:2014-12-17
/// Output: success:'true',info:'添加成功！' 修改成功时输出修改成功！
///         success:'false',info:'添加失败' 修改失败时输出修改失败！
/// Tables:  MRC_BodyParts
ClassMethod SaveEntity(eobj As web.Entity.CT.MRCBodyParts) As %String
{
  s result=""
  Tstart
  s:eobj.BODPInfusionFlag="" eobj.BODPInfusionFlag="N"
  if (eobj.BODPRowId="")       
  {   
   s obj=##class(User.MRCBodyParts).%New()
  }
  else   
  {
   s obj=##class(User.MRCBodyParts).%OpenId(eobj.BODPRowId)
   s bobj=##class(web.Entity.CT.MRCBodyParts).%New()
   s bobj.BODPRowId=eobj.BODPRowId
   s bobj.BODPCode = obj.BODPCode                    
   s bobj.BODPDesc= obj.BODPDesc
   s:obj.BODPCTLOCDR="" bobj.BODPCTLOCDR=""
   s:obj.BODPCTLOCDR'="" bobj.BODPCTLOCDR=obj.BODPCTLOCDR.%Id()
   s bobj.BODPInfusionFlag=obj.BODPInfusionFlag
  }
   s obj.BODPCode = eobj.BODPCode                    
   s obj.BODPDesc= eobj.BODPDesc
   d obj.BODPCTLOCDRSetObjectId(eobj.BODPCTLOCDR)
   s obj.BODPInfusionFlag=eobj.BODPInfusionFlag
   s sc=obj.%Save()
   if $$$ISOK(sc)
   {
    Tcommit
    s id = obj.%Id()
    s result = "{success:'true',id:'"_id_"'}"       
    d:eobj.BODPRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MRC_BodyParts","User.MRCBodyParts","电子病例-身体部位",eobj.BODPRowId,eobj.BODPDesc,"U",eobj,bobj)
    d:eobj.BODPRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MRC_BodyParts","User.MRCBodyParts","电子病例-身体部位",id,eobj.BODPDesc,"A",eobj)
   }
   else
   {
    Trollback
    s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("电子病例-身体部位","web.DHCBL.CT.MRCBodyParts","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)      
  }
 q result
}

}
