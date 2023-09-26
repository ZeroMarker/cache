/// CreateDate:2013-6-22
/// Creator:基础数据平台 孙凤超
/// Function:支付方式维护
/// Tables: CT_PayMode
Class web.DHCBL.CT.CTPayMode Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function:进行数据检索 查询支付方式
/// CreateDate:2013-6-22
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables:  CT_PayMode
/// Output: CTPMRowId CTPMCode CTPMDesc CTPMDateFrom  CTPMDateTo  CTPMGrpCode     
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTPayMode", "GetList","","","","")
Query GetList(rowid As %String, code As %String, desc As %String, type As %String) As %Query(ROWSPEC = "CTPMRowId:%String,CTPMCode:%String ,CTPMDesc:%String,CTPMDateFrom:%String,CTPMDateTo:%String,CTPMGrpCode:%String,CTPMNotUseFlag:%String,CTPMChangeGiven:%String, BDPInternalCode ,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, type As %String) As %Status
{
   s repid=$I(^CacheTemp)
   s ind=1
   s AuStr=##class(web.DHCBL.Authorize.CTPayMode).DHCGetDataByDefaultSession()
   s AuFlag=0
   ;未授权情况下，默认显示全部数据
   if (AuStr="")||(AuStr["limited:0") s AuFlag=1
   if (rowid'="")  
   {
     s CTPMRowId=rowid
     s CTPMCode=$p($g(^CT("CTPM",CTPMRowId)),"^",1)
     s CTPMDesc=$p($g(^CT("CTPM",CTPMRowId)),"^",2)
     s CTPMDateFrom=$p($g(^CT("CTPM",CTPMRowId)),"^",5)
     s:CTPMDateFrom'="" CTPMDateFrom=$zd(CTPMDateFrom,1)
     s CTPMDateTo=$p($g(^CT("CTPM",CTPMRowId)),"^",6)
     s:CTPMDateTo'="" CTPMDateTo=$zd(CTPMDateTo,1)
     s CTPMGrpCode=$p($g(^CT("CTPM",CTPMRowId)),"^",4)
     s:CTPMGrpCode="CH" CTPMGrpCode="Cash"
     s:CTPMGrpCode="CC" CTPMGrpCode="Card"
     s:CTPMGrpCode="CQ" CTPMGrpCode="Cheque"
     s:CTPMGrpCode="DP" CTPMGrpCode="DirectPayment"
     s CTPMNotUseFlag =$p($g(^CT("CTPM",CTPMRowId)),"^",3)
     s CTPMChangeGiven=$p($g(^CT("CTPM",CTPMRowId)),"^",7)
     s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
     s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_PayMode",CTPMRowId)
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
     s CTPMRowId=0
     for
     {
       s CTPMRowId=$o(^CT("CTPM",CTPMRowId)) q:CTPMRowId=""   
       s strCTPMRowId="{ID:"_CTPMRowId_"}"
       if (AuStr[strCTPMRowId)||(AuFlag=1) 
       { 
         s CTPMCode=$p($g(^CT("CTPM",CTPMRowId)),"^",1)
         s CTPMDesc=$p($g(^CT("CTPM",CTPMRowId)),"^",2) 
         s CTPMGrpCode=$p($g(^CT("CTPM",CTPMRowId)),"^",4)
         s:CTPMGrpCode="CH" CTPMGrpCode="Cash"
         s:CTPMGrpCode="CC" CTPMGrpCode="Card"
         s:CTPMGrpCode="CQ" CTPMGrpCode="Cheque"
         s:CTPMGrpCode="DP" CTPMGrpCode="DirectPayment"
         s CTPMDateFrom=$p($g(^CT("CTPM",CTPMRowId)),"^",5)
         s CTPMDateTo=$p($g(^CT("CTPM",CTPMRowId)),"^",6)
  
         s:CTPMDateFrom'="" CTPMDateFrom=$zd(CTPMDateFrom,1)
         s:CTPMDateTo'="" CTPMDateTo=$zd(CTPMDateTo,1)
         s:type="CQ" type="Cheque"
         s:type="CH" type="Cash"
         s:type="CC" type="Card"
         s:type="DP" type="DirectPayment"
         s CTPMNotUseFlag =$p($g(^CT("CTPM",CTPMRowId)),"^",3)
         s CTPMChangeGiven=$p($g(^CT("CTPM",CTPMRowId)),"^",7)
         s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
         s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_PayMode",CTPMRowId)
         s BDPInternalCode =$p($g(resultStr),"^",1)       
         s BDPInternalDesc = $p($g(resultStr),"^",2)  
         s BDPHospNationalCode=$p($g(resultStr),"^",3)         
         s BDPHospNationalDesc = $p($g(resultStr),"^",4)
         if (desc'="")
         {
            ;需要对描述或者别名进行检索      
            s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_PayMode",CTPMRowId,CTPMDesc,desc)
         }
         else
         {
            s AliasFlag= 1   
         }   
         if (CTPMGrpCode[type)&($ZCVT(CTPMCode,"U")[code)&&(AliasFlag=1)  
         {
           d OutputRow
         }
      }
   }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(CTPMRowId,CTPMCode,CTPMDesc,CTPMDateFrom,CTPMDateTo,CTPMGrpCode,CTPMNotUseFlag,CTPMChangeGiven, BDPInternalCode ,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Function:进行数据检索，查询comb支付方式提供接口 
/// CreateDate:2013-6-22
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables: CT_PayMode
/// Input:  code,desc
/// Output: CTPMRowId CTPMCode CTPMDesc    
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTPayMode", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CTPMRowId:%String,CTPMCode:%String,CTPMDesc:%String ")
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
 s AuStr=##class(web.DHCBL.Authorize.CTPayMode).DHCGetDataByDefaultSession()
 s AuFlag=0
 ;未授权情况下，默认显示全部数据
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1
 if (rowid'="")  
 {
  s CTPMRowId=rowid
  s CTPMCode=$p($g(^CT("CTPM",CTPMRowId)),"^",1)
  s CTPMDesc=$p($g(^CT("CTPM",CTPMRowId)),"^",2)
  d OutputRow2
 }
 else
 {
   s CTPMRowId=0
   for
   {
    s CTPMRowId=$o(^CT("CTPM",CTPMRowId)) 
    q:CTPMRowId=""  
    
    s CTPMDateFrom=$p($g(^CT("CTPM",CTPMRowId)),"^",5)
    continue:(CTPMDateFrom'="")&&(CTPMDateFrom>+$h)
    s CTPMDateTo=$p($g(^CT("CTPM",CTPMRowId)),"^",6)
    continue:(CTPMDateTo'="")&&(CTPMDateTo<+$h)
    s strCTPMRowId="{ID:"_CTPMRowId_"}"
    if (AuStr[strCTPMRowId)||(AuFlag=1) 
    { 
       s CTPMCode=$p($g(^CT("CTPM",CTPMRowId)),"^",1)
       s CTPMDesc=$p($g(^CT("CTPM",CTPMRowId)),"^",2)
       if (desc'="")
       {
          ;需要对描述或者别名进行检索      
          s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_PayMode",CTPMRowId,CTPMDesc,desc)
       }
       else
       {
          s AliasFlag= 1   
       }    
       if (($ZCVT(CTPMCode,"U")[code))&&(AliasFlag=1)
       {
         d OutputRow2
       }
     } 
    }
   }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2   
 set Data=$lb(CTPMRowId,CTPMCode,CTPMDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function:用于双击修改时的数据加载 
/// CreateDate:2013-6-22
/// Creator:基础数据平台公共产品组 孙凤超
/// Input:输入id
/// Tables:  CT_PayMode
/// Others :w ##class(web.DHCBL.CT.CTPayMode).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
 s str=""
 s pobj = ##class(User.CTPayMode).%OpenId(id)
 s eobj = ##class(web.Entity.CT.CTPayMode).%New()
 s eobj.CTPMRowId = id
 S eobj.CTPMCode=pobj.CTPMCode
 s eobj.CTPMDesc= pobj.CTPMDesc
 s eobj.CTPMGrpCode=pobj.CTPMGrpCode
 s:pobj.CTPMDateFrom'="" eobj.CTPMDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.CTPMDateFrom)
 s:pobj.CTPMDateTo'="" eobj.CTPMDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.CTPMDateTo)
 s eobj.CTPMChangeGiven=pobj.CTPMChangeGiven
 s eobj.CTPMNotUseFlag=pobj.CTPMNotUseFlag
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Function:用于数据删除时的逻辑判断  （在AR_RcptPayMode表中），不允许删除 
/// CreateDate:2015-5-13
/// Ctreator:Sunfengchao
/// Input:  ^ARRCP({AR_Receipts.ARRCP_RowId},"PAYM",{PAYM_Childsub})
/// Output:返回一个标志位，0为未被引用，表示可以被删除，1表示已经被引用了，不能被删除
/// debug: w ##class(web.DHCBL.CT.CTPayMode).GetRefFlag("")
ClassMethod GetRefFlag(id As %String) As %String
{
  s return="",myInfo=""
  s found1=0
  s ARRCPRowId=0
  for
  {
    s ARRCPRowId=$O(^ARRCP(ARRCPRowId)) q:ARRCPRowId=""
    s PAYMChildsub=0
    for
    {
        s PAYMChildsub =$O(^ARRCP(ARRCPRowId,"PAYM",PAYMChildsub)) q:PAYMChildsub=""
        s PAYMCMBankDR=""
        s PAYMCMBankDR=$p($g(^ARRCP(ARRCPRowId,"PAYM",PAYMChildsub)),"^",2)
        if (PAYMCMBankDR=id)
        {
          s found1=1
          q
        }
    }   
  }
  if (found1=1)  s myInfo=myInfo_"<AR_RcptPayMode>"  
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

/// PAYM_ParRef
/// Function:实现对支付方式的删除操作
/// Creator:孙凤超
/// CreateDate:2013-06-26
/// Desc:通过rowid号来删除支付方式
/// Output:success:'true',info:'删除成功！ 失败时输出删除成功！
/// Tables: CT_PayMode
/// Others:d ##class(web.DHCBL.CT.CTPayMode).DeleteData("")
ClassMethod DeleteData(id As %String) As %String
{
 
  s result=""
  s flag=""
  s re=..GetRefFlag(id)
  s RefFlag=$p(re,"^",1)
  if (RefFlag=1)
  {
    s result="{success:'false',info:'"_$p(re,"^",2)_"'}"
  }
  else
  {
    Tstart
    s pobj = ##class(User.CTPayMode).%OpenId(id)
    s eobj = ##class(web.Entity.CT.CTPayMode).%New()
    s eobj.CTPMRowId = id
    S eobj.CTPMCode=pobj.CTPMCode
    s eobj.CTPMDesc= pobj.CTPMDesc
    s:eobj.CTPMGrpCode="CH" pobj.CTPMGrpCode="Cash"
    s:eobj.CTPMGrpCode="CC" pobj.CTPMGrpCode="Card"
    s:eobj.CTPMGrpCode="CQ" pobj.CTPMGrpCode="Cheque"
    s:eobj.CTPMGrpCode="DP" pobj.CTPMGrpCode="DirectPayment"
    s:pobj.CTPMDateFrom'="" eobj.CTPMDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.CTPMDateFrom)
    s:pobj.CTPMDateTo'="" eobj.CTPMDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.CTPMDateTo)
    s eobj.CTPMChangeGiven=pobj.CTPMChangeGiven
    s eobj.CTPMNotUseFlag=pobj.CTPMNotUseFlag
    s sc=##class(User.CTPayMode).%DeleteId(id)
    if $$$ISOK(sc)
    {
     Tc
     s result="{success:'true',info:'删除成功！'}"
     d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_PayMode","User.CTPayMode","支付方式",id,eobj.CTPMDesc,"D",eobj)
    }
    else
    {
     Trollback
     s result= "{success:'false',info:'删除失败！"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息 
     s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("支付方式","web.DHCBL.CT.CTPayMode","DeleteData",eobj)
     s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
    }
  }
   q result
}

/// Creator：基础数据平台 孙凤超
/// CreatDate: 2012-11-28
/// Description：数据校验功能
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s flag=""
 s flagc=""
 s flagd=""
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //此处用于转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //此处用于转换成大写
 s:code'="" flagc=$d(^CT("CTPM",0,"Code",code))
 s:desc'="" flagd=$d(^CT("CTPM",0,"Desc",desc))
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
  s:code'="" idc=$o(^CT("CTPM",0,"Code",code,0))
  s:desc'="" idd=$o(^CT("CTPM",0,"Desc",desc,0))
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

/// Function:实现对支付类型的修改增加操作
/// Creator:孙凤超
/// CreateDate:2012-06-26
/// Output: success:'true',info:'添加成功！' 失败时输出添加失败！
///         success:'false',info:'修改成功' 失败时输出修改失败！
/// Tables: CT_PayMode
ClassMethod SaveEntity(eobj As web.Entity.CT.CTPayMode) As %String
{
 s $zt="ERROR"
 s result=""
 if $IsObject(eobj)
 {
   s:eobj.CTPMDateFrom'="" eobj.CTPMDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTPMDateFrom)  //转换日期
   s:eobj.CTPMDateTo'="" eobj.CTPMDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTPMDateTo)      //转换日期
   s:eobj.CTPMDateFrom="" eobj.CTPMDateFrom=+$h
  //如果RowId未赋值则增加
  if (eobj.CTPMRowId="")       
  {
   s obj=##class(User.CTPayMode).%New()
  }else                           
  {
    s obj=##class(User.CTPayMode).%OpenId(eobj.CTPMRowId)
    s bobj=##class(web.Entity.CT.CTPayMode).%New()
    s bobj.CTPMRowId=eobj.CTPMRowId
    s bobj.CTPMCode = obj.CTPMCode                      
    s bobj.CTPMDesc= obj.CTPMDesc                       
    s bobj.CTPMDateFrom = obj.CTPMDateFrom 
    s bobj.CTPMDateTo=obj.CTPMDateTo
    s bobj.CTPMGrpCode=obj.CTPMGrpCode
    s bobj.CTPMChangeGiven=obj.CTPMChangeGiven
    s bobj.CTPMNotUseFlag=obj.CTPMNotUseFlag 
  }
   s obj.CTPMCode = eobj.CTPMCode                      
   s obj.CTPMDesc= eobj.CTPMDesc                    
   s obj.CTPMDateFrom = eobj.CTPMDateFrom 
   s obj.CTPMDateTo=eobj.CTPMDateTo
   s:eobj.CTPMGrpCode="Cash" eobj.CTPMGrpCode="CH"
   s:eobj.CTPMGrpCode="Card" eobj.CTPMGrpCode="CC"
   s:eobj.CTPMGrpCode="Cheque" eobj.CTPMGrpCode="CQ"
   s:eobj.CTPMGrpCode="DirectPayment" eobj.CTPMGrpCode="DP"
   s obj.CTPMGrpCode=eobj.CTPMGrpCode
   s:eobj.CTPMChangeGiven="" eobj.CTPMChangeGiven="N"
   s:eobj.CTPMNotUseFlag="" eobj.CTPMNotUseFlag="N"
   s obj.CTPMChangeGiven=eobj.CTPMChangeGiven
   s obj.CTPMNotUseFlag=eobj.CTPMNotUseFlag
   Tstart
   s sc=obj.%Save()
   if $$$ISOK(sc){
    Tcommit
    s id = obj.%Id()
    s result = "{success:'true',id:'"_id_"'}"         //保存数据后,通过RowId返回到这条数据
    d:eobj.CTPMRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_PayMode","User.CTPayMode","支付方式",eobj.CTPMRowId,eobj.CTPMDesc,"U",eobj,bobj)
    d:eobj.CTPMRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_PayMode","User.CTPayMode","支付方式",id,eobj.CTPMDesc,"A",eobj)
   }
   else
   {
      Trollback
      s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    
      s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("支付方式","web.DHCBL.CT.CTPayMode","SaveEntity",eobj)
      s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
    }
  }
  else
  {
    s result = "{success:'false',errorinfo:'对象不存在！'}"
    s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("支付方式","web.DHCBL.CT.CTPayMode","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)="对象不存在！"
  } 
  q result
ERROR
  s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("支付方式","web.DHCBL.CT.CTPayMode","SaveEntity",eobj)
  s ^ERRORLOGINFO(logid)=$ze
  q "{success:'false',errorinfo:'保存失败！'}"
}

}
