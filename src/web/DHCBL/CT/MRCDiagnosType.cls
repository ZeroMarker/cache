/// 名称: 电子病例-诊断类型
/// 描述: 业务类
/// 编写者：基础数据平台组-sunfengchao
/// 编写日期: 2014-12-11
Class web.DHCBL.CT.MRCDiagnosType Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function:进行数据检索，查询诊断类型
/// CreateDate:2014-12-11
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables:  MRC_DiagnosType
/// Output: DTYP_RowId DTYP_Code DTYP_Desc DTYP_NoSendToCoding
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.MRCDiagnosType", "GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "DTYPRowId:%String,DTYPCode:%String ,DTYPDesc:%String,DTYPNoSendToCoding:%String,DTYPClinicType,DTYPDateFrom,DTYPDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
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
   
   s AuStr=##class(web.DHCBL.Authorize.MRCDiagnosType).DHCGetDataByDefaultSession()
   s AuFlag=0
   ;未授权情况下，默认显示全部数据
   if (AuStr="")||(AuStr["limited:0") s AuFlag=1
   
   if (rowid'="")  
   {
     s DTYPRowId=rowid
     s DTYPCode=$p($g(^MRC("DTYP",rowid)),"^",1)
     s DTYPDesc=$p($g(^MRC("DTYP",rowid)),"^",2)
     s DTYPNoSendToCoding =$p($g(^MRC("DTYP",rowid)),"^",3)
     s DTYPClinicType=$p($g(^MRC("DTYP",rowid)),"^",4)
     s DTYPClinicType=##class(web.DHCBL.CT.PHCFreq).GetClinicType(DTYPClinicType)
	 s DTYPDateFrom = $p($g(^MRC("DTYP",rowid)),"^",5)
	 s:DTYPDateFrom'="" DTYPDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DTYPDateFrom)    
	 s DTYPDateTo =$p($g(^MRC("DTYP",rowid)),"^",6)
	 s:DTYPDateTo'="" DTYPDateTo= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DTYPDateTo)
 
     s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="" 
     s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("MRC_DiagnosType",DTYPRowId)
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
     s DTYPRowId=0
     for
     {
       s DTYPRowId=$o(^MRC("DTYP",DTYPRowId)) q:DTYPRowId=""   
       s strDTYPRowId="{ID:"_DTYPRowId_"}"
       if (AuStr[strDTYPRowId)||(AuFlag=1) 
       { 
         s DTYPCode=$p($g(^MRC("DTYP",DTYPRowId)),"^",1)
         s DTYPDesc=$p($g(^MRC("DTYP",DTYPRowId)),"^",2) 
         s DTYPNoSendToCoding =$p($g(^MRC("DTYP",DTYPRowId)),"^",3)
         s DTYPClinicType=$p($g(^MRC("DTYP",DTYPRowId)),"^",4)
	     s DTYPClinicType=##class(web.DHCBL.CT.PHCFreq).GetClinicType(DTYPClinicType)
		 s DTYPDateFrom = $p($g(^MRC("DTYP",DTYPRowId)),"^",5)
		 s:DTYPDateFrom'="" DTYPDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DTYPDateFrom)    
		 s DTYPDateTo =$p($g(^MRC("DTYP",DTYPRowId)),"^",6)
		 s:DTYPDateTo'="" DTYPDateTo= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DTYPDateTo)
	 
         s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="" 
         s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("MRC_DiagnosType",DTYPRowId)
         s BDPInternalCode =$p($g(resultStr),"^",1)       
         s BDPInternalDesc = $p($g(resultStr),"^",2)  
         s BDPHospNationalCode=$p($g(resultStr),"^",3)         
         s BDPHospNationalDesc = $p($g(resultStr),"^",4)
         if (desc'="")
         {
            ;需要对描述或者别名进行检索      
            s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("MRC_DiagnosType",DTYPRowId,DTYPDesc,desc)
         }
         else
         {
            s AliasFlag= 1   
         }    
         if ($ZCVT(DTYPCode,"U")[code)&(AliasFlag=1)     
         {
           d OutputRow
         }
     }
   }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(DTYPRowId,DTYPCode,DTYPDesc,DTYPNoSendToCoding,DTYPClinicType,DTYPDateFrom,DTYPDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Function:  进行数据检索，查询comb诊断类型提供接口 
/// CreateDate:2014-12-11
/// Creator:   基础数据平台公共产品组 孙凤超
/// Tables:    MRC_DiagnosType
/// Input:     code,desc
/// Output:    DTYPRowId DTYPCode DTYPDesc    
/// Others:    d ##class(%ResultSet).RunQuery("web.DHCBL.CT.MRCDiagnosType", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "DTYPRowId:%String,DTYPCode:%String,DTYPDesc:%String ")
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
  s AuStr=##class(web.DHCBL.Authorize.MRCDiagnosType).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  if (rowid'="")  
  {
    s DTYPRowId=rowid
    s DTYPCode=$p($g(^MRC("DTYP",rowid)),"^",1)
    s DTYPDesc=$p($g(^MRC("DTYP",rowid)),"^",2)
    d OutputRowCmb
  }
  else
  {
    s:code'="" code=$ZCVT(code,"U")  
    s:desc'="" desc=$ZCVT(desc,"U")
    s DTYPRowId=0
    for
    {
       s DTYPRowId=$o(^MRC("DTYP",DTYPRowId)) q:DTYPRowId=""   
       s strDTYPRowId="{ID:"_DTYPRowId_"}"
       if (AuStr[strDTYPRowId)||(AuFlag=1) 
       { 
         s DTYPCode=$p($g(^MRC("DTYP",DTYPRowId)),"^",1)
         s DTYPDesc=$p($g(^MRC("DTYP",DTYPRowId)),"^",2)
         if (desc'="")
         {
            ;需要对描述或者别名进行检索      
            s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("MRC_DiagnosType",DTYPRowId,DTYPDesc,desc)
         }
         else
         {
            s AliasFlag= 1   
         }    
         if ($ZCVT(DTYPCode,"U")[code)&(AliasFlag=1)     
         {
           d OutputRowCmb
         }
     }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(DTYPRowId,DTYPCode,DTYPDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function:   用于双击修改时的数据加载 
/// CreateDate: 2014-12-11
/// Creator:    基础数据平台公共产品组 孙凤超
/// Input:      输入id
/// Tables:     MRC_DiagnosType
/// Others :   w ##class(web.DHCBL.CT.MRCDiagnosType).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
 s str=""
 s pobj = ##class(User.MRCDiagnosType).%OpenId(id)
 s eobj = ##class(web.Entity.CT.MRCDiagnosType).%New()
 s eobj.DTYPRowId = id
 S eobj.DTYPCode=pobj.DTYPCode
 s eobj.DTYPDesc= pobj.DTYPDesc
 s eobj.DTYPNoSendToCoding=pobj.DTYPNoSendToCoding
 s eobj.DTYPClinicType=pobj.DTYPClinicType
 if eobj.DTYPClinicType="" s eobj.DTYPClinicType = "O,E,I,H,N"   //就诊类型为空时 默认门诊。急诊。住院。体检都可以开
 if eobj.DTYPClinicType["O" s eobj.DTYPClinicTypeO="O"  // 就诊类型 门诊
 if eobj.DTYPClinicType["E" s eobj.DTYPClinicTypeE="E"  // 就诊类型 急诊
 if eobj.DTYPClinicType["I" s eobj.DTYPClinicTypeI="I"  // 就诊类型 住院
 if eobj.DTYPClinicType["H" s eobj.DTYPClinicTypeH="H"  // 就诊类型 体检
 if eobj.DTYPClinicType["N" s eobj.DTYPClinicTypeN="N"  // 就诊类型 新生儿
 s:pobj.DTYPDateFrom'="" eobj.DTYPDateFrom = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.DTYPDateFrom)    
 s:pobj.DTYPDateTo'="" eobj.DTYPDateTo =  ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.DTYPDateTo)
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Function:实现对诊断类型的删除操作
/// Creator: 孙凤超
/// CreateDate:2014-12-11
/// Output:success:'true',info:'删除成功！ 失败时输出删除成功！
/// Tables: MRC_DiagnosType
/// Others:d ##class(web.DHCBL.CT.MRCDiagnosType).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    s result="",flag=""
    Tstart
    s pobj = ##class(User.MRCDiagnosType).%OpenId(id)
    s eobj = ##class(web.Entity.CT.MRCDiagnosType).%New()
    s eobj.DTYPRowId = id
    S eobj.DTYPCode=pobj.DTYPCode
    s eobj.DTYPDesc= pobj.DTYPDesc
    s eobj.DTYPNoSendToCoding=pobj.DTYPNoSendToCoding
    s eobj.DTYPClinicType=pobj.DTYPClinicType
    s eobj.DTYPDateFrom=pobj.DTYPDateFrom
    s eobj.DTYPDateTo=pobj.DTYPDateTo
    s sc=##class(User.MRCDiagnosType).%DeleteId(id)
    if $$$ISOK(sc)
    {
     Tc
     s result="{success:'true',info:'删除成功！'}"
     d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MRC_DiagnosType","User.MRCDiagnosType","诊断类型",id,eobj.DTYPDesc,"D",eobj)
    }
    else
    {
     Trollback
     s result= "{success:'false',info:'删除失败！"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
     s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("诊断类型","web.DHCBL.CT.MRCDiagnosType","DeleteData",eobj)
     s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)      
    }
   q result
}

/// Creator：基础数据平台 孙凤超
/// CreatDate: 2012-11-28
/// Description：数据校验功能
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s flag="",flagc="",flagd=""
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //此处用于转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //此处用于转换成大写 
 s:code'="" flagc=$d(^MRC("DTYP",0,"Code",code))
 s:desc'="" flagd=$d(^MRC("DTYP",0,"Desc",desc))
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
  s:code'="" idc=$o(^MRC("DTYP",0,"Code",code,0))
  s:desc'="" idd=$o(^MRC("DTYP",0,"Desc",desc,0))
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

/// Function: 实现对诊断类型的修改增加操作
/// Creator:  孙凤超
/// CreateDate:2012-06-26
/// Output: success:'true',info:'添加成功！' 失败时输出添加失败！
///         success:'false',info:'修改成功' 失败时输出修改失败！
/// Tables: MRC_DiagnosType
ClassMethod SaveEntity(eobj As web.Entity.CT.MRCDiagnosType) As %String
{
 s $zt="ERROR"
 s result=""
 if $IsObject(eobj)
 {
	 s:eobj.DTYPDateFrom'="" eobj.DTYPDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.DTYPDateFrom)   
	  s:eobj.DTYPDateTo'="" eobj.DTYPDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.DTYPDateTo)       
	  s:eobj.DTYPDateFrom="" eobj.DTYPDateFrom=+$h
  	if eobj.DTYPClinicType["门诊" s eobj.DTYPClinicTypeO="O"
	if eobj.DTYPClinicType["急诊" s eobj.DTYPClinicTypeE="E"
	if eobj.DTYPClinicType["住院" s eobj.DTYPClinicTypeI="I"
	if eobj.DTYPClinicType["体检" s eobj.DTYPClinicTypeH="H"
	if eobj.DTYPClinicType["新生儿" s eobj.DTYPClinicTypeN="N"
	///将就诊类型拼起来， 用,分隔  
	s eobj.DTYPClinicType=eobj.DTYPClinicTypeO_","_eobj.DTYPClinicTypeE_","_eobj.DTYPClinicTypeI_","_eobj.DTYPClinicTypeH_","_eobj.DTYPClinicTypeN
        
        
  if (eobj.DTYPRowId="")       
  {
   s obj=##class(User.MRCDiagnosType).%New()
  }
  else                           
  {
    s obj=##class(User.MRCDiagnosType).%OpenId(eobj.DTYPRowId)
    s bobj=##class(web.Entity.CT.MRCDiagnosType).%New()
    s bobj.DTYPRowId=eobj.DTYPRowId
    s bobj.DTYPCode = obj.DTYPCode                      
    s bobj.DTYPDesc= obj.DTYPDesc                       
    s bobj.DTYPNoSendToCoding=obj.DTYPNoSendToCoding 
    s bobj.DTYPClinicType=obj.DTYPClinicType
    s bobj.DTYPDateFrom=obj.DTYPDateFrom
    s bobj.DTYPDateTo=obj.DTYPDateTo
  }
   s obj.DTYPCode = eobj.DTYPCode                      
   s obj.DTYPDesc= eobj.DTYPDesc                    
   s:eobj.DTYPNoSendToCoding="" eobj.DTYPNoSendToCoding="N"
   s obj.DTYPNoSendToCoding=eobj.DTYPNoSendToCoding
   s obj.DTYPClinicType=eobj.DTYPClinicType
    s obj.DTYPDateFrom=eobj.DTYPDateFrom
    s obj.DTYPDateTo=eobj.DTYPDateTo
    
   Tstart
   s sc=obj.%Save()
   if $$$ISOK(sc){
    Tcommit
    s id = obj.%Id()
    s result = "{success:'true',id:'"_id_"'}"       
    d:eobj.DTYPRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MRC_DiagnosType","User.MRCDiagnosType","诊断类型",eobj.DTYPRowId,eobj.DTYPDesc,"U",eobj,bobj)
    d:eobj.DTYPRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MRC_DiagnosType","User.MRCDiagnosType","诊断类型",id,eobj.DTYPDesc,"A",eobj)
   }
   else
   {
     Trollback
     s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"     
     s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("诊断类型","web.DHCBL.CT.MRCDiagnosType","SaveEntity",eobj)
     s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)      
   }
  }
  else
  {
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("诊断类型","web.DHCBL.CT.MRCDiagnosType","SaveEntity","")
    s ^ERRORLOGINFO(logid)="对象不存在！" 
    s result = "{success:'false',errorinfo:'对象不存在！'}"
  } 
  q result
ERROR
 s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("诊断类型","web.DHCBL.CT.MRCDiagnosType","SaveEntity",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q "{success:'false',errorinfo:'保存失败！'}"
}

}
