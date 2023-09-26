/// Function: 错误日志维护
/// Creator:  sunfengchao
/// CreateDate:2016-6-22
Class web.DHCBL.BDP.BDPSysErrorLog Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Function:处理影响JSON格式的字符
/// Creator:  sunfengchao
/// CreateDate:2021-1-29
/// Debug:  w ##class(web.DHCBL.BDP.BDPSysErrorLog).GetEvalJSON("")
ClassMethod GetEvalJSON(value) As %String
{
    s value=$tr(value,$c(10))   ;替换换行符
    s value=$tr(value,$c(13))   ;替换回车符
    s value=$Replace(value,"\\","")
    s value=$Replace(value,"'","") 
    q value
}

/// Function: 查询错误日志,可根据日期范围去查看
/// Creator:  sunfengchao
/// CreateDate:2016-6-22
/// Debug:  w ##class(web.DHCBL.BDP.BDPSysErrorLog).GetList("",0,10)
ClassMethod GetList(datefrom As %String, dateto As %String, start As %String, limit As %String) As %String
{
    s resultStr="",count=0,total=0
    s:start="" start=0
    s:limit="" limit=20
    s:datefrom'="" datefrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(datefrom)
    s:dateto'="" dateto=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(dateto)
    if ((datefrom'="")&&(dateto=""))
    {
       s dateto=+$h
    }
    if ((dateto'="")&&(datefrom=""))
    {
       s datefrom="14122"
    }  
    s BDPERRowId="",del="^"
    for
    {
        s BDPERRowId=$O(^BDPERROR(BDPERRowId),-1)
        q:((BDPERRowId="")||(BDPERRowId=0))
        continue:BDPERRowId=914
        s BDPERDate=$p($g(^BDPERROR(BDPERRowId)),del,1)
        if (((BDPERDate>=datefrom)&(BDPERDate<=dateto))||((datefrom="")||(dateto=""))&(BDPERRowId'=0))
        {
          s count=count+1
          if ((count>start)&&(count<=(start+limit)))
          {
            s:BDPERDate'="" BDPERDate=$zd(BDPERDate,1)
            s BDPERTime=$p($g(^BDPERROR(BDPERRowId)),del,2)
            s:BDPERTime'="" BDPERTime=$zt(BDPERTime,1)
            s BDPERApp=$p($g(^BDPERROR(BDPERRowId)),del,3)
            s BDPERClassInfo= $p($g(^BDPERROR(BDPERRowId)),del,4)
            s BDPERModule= $p($g(^BDPERROR(BDPERRowId)),del,5)
            s BDPERErrInfo=$g(^ERRORLOGINFO(BDPERRowId)) // $p($g(^BDPERROR(BDPERRowId)),del,6)
            s BDPERKeyValue=$p($g(^BDPERROR(BDPERRowId)),del,7)
            s BDPERIPAddress=$p($g(^BDPERROR(BDPERRowId)),del,8)
            s BDPERSSUSRDR=$p($g(^BDPERROR(BDPERRowId)),del,9)
            s:BDPERSSUSRDR'="" BDPERSSUSRDR=$p($g(^SSU("SSUSR",BDPERSSUSRDR)),"^",2) 
            s:BDPERSSUSRDR="" BDPERSSUSRDR=""
            s BDPBrowserInfo=$p($g(^BDPERROR(BDPERRowId)),del,10)
            s BDPERErrInfo=..GetEvalJSON(BDPERErrInfo) 
            s BDPERErrInfo= ##class(web.DHCBL.BDP.FunLib).EvalJSON(BDPERErrInfo)
            if (resultStr="")
            {
              s resultStr= "{BDPERRowId:'"_BDPERRowId_"',BDPERDate:'"_BDPERDate_"',BDPERTime:'"_BDPERTime_"',BDPERApp:'"_BDPERApp_"',BDPERModule:'"_BDPERModule_"',BDPERErrInfo:'"_BDPERErrInfo_"',BDPERKeyValue:'"_BDPERKeyValue_"',BDPERIPAddress:'"_BDPERIPAddress_"',BDPERSSUSRDR:'"_BDPERSSUSRDR_ "',BDPERClassInfo:'"_BDPERClassInfo_"',BDPBrowserInfo:'"_BDPBrowserInfo_"'}" 
            }
            else
            {
              s resultStr=resultStr_",{BDPERRowId:'"_BDPERRowId_"',BDPERDate:'"_BDPERDate_"',BDPERTime:'"_BDPERTime_"',BDPERApp:'"_BDPERApp_"',BDPERModule:'"_BDPERModule_"',BDPERErrInfo:'"_BDPERErrInfo_"',BDPERKeyValue:'"_BDPERKeyValue_"',BDPERIPAddress:'"_BDPERIPAddress_"',BDPERSSUSRDR:'"_BDPERSSUSRDR_ "',BDPERClassInfo:'"_BDPERClassInfo_"',BDPBrowserInfo:'"_BDPBrowserInfo_"'}" 
            }
          }
        } 
      }
      s resultStr="{""success"":""true"",""data"":["_resultStr_"],"_"""total"":"""_count_""""_"}"
      q resultStr
}

/// Function: 保存错误日志
/// Creator:  sunfengchao
/// CreateDate:2016-6-22
/// Debug: d ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("账单组","web.DHCBL.CT.ARCBillGrp","DeleteData",$p(re,"^",2),eobj,"")
ClassMethod SaveLog(BDPERApp As %String = "", BDPERClassInfo As %String = "", BDPERModule As %String = "", BDPERKeyValue As %String = "")
{
   new (BDPERApp,BDPERClassInfo,BDPERModule,BDPERKeyValue,%session)
   s $ZT="ERROR"
   s id=0 
   if ('$d(%session))
   { 
      q "获取不到session!"
   }
   else
   { 
      s browerinfo=""
      s IPAddress=$Get(%session.Data("REMOTE_ADDR"))
      if (IPAddress'="")  s browerinfo=$g(^TMP("dhc.bdp.errorlog",IPAddress))
      s obj=##class(User.BDPSysErrorLog).%New()
      s obj.BDPERDate=+$h 
      s obj.BDPERTime=$p($h,",",2)
      s obj.BDPERApp=BDPERApp
      s obj.BDPERClassInfo=BDPERClassInfo
      s obj.BDPERModule=BDPERModule
      if (BDPERKeyValue["@web.Entity")
      {
        s obj.BDPERKeyValue=BDPERKeyValue.JsonS()
      }
      else
      {
        s obj.BDPERKeyValue=BDPERKeyValue
      }
      s obj.BDPERIPAddress =IPAddress
      d obj.BDPERSSUSRDRSetObjectId($Get(%session.Data("LOGON.USERID")))
      s obj.BDPERBrowserInfo=browerinfo
      s sc=obj.%Save()
      If $$$ISOK(sc) 
      { 
        s id=obj.%Id() 
      }
      d obj.%Close()
   }
   q id
ERROR
	Q 0
}

///  Function： 获取浏览器信息
///  Creator:   sunfengchao
///  CreateDate:  2016-6-28
///  Debug:   w ##class(web.DHCBL.BDP.BDPSysErrorLog).GetBrowerInfo()
ClassMethod SaveBrowerInfo(browerInfo)
{
   if ('$d(%session))
   { 
      q "获取不到session!"
   }
   else
   { 
     s IPAddress=$Get(%session.Data("REMOTE_ADDR"))
     if (IPAddress'=""){
        k ^TMP("dhc.bdp.errorlog",IPAddress)
        s ^TMP("dhc.bdp.errorlog",IPAddress)=browerInfo
    } 
   }
   q ""
}

/// Function:查看数据明细
/// Creator: sunfengchao
/// CreateDate:2016-6-28
/// Debug:  d ##class(web.DHCBL.BDP.BDPSysErrorLog).QueryDataDetail(1)
ClassMethod QueryDataDetail(id As %String) As %String
{
  if (id="")
  {
    q "ID为空,没法查看数据明细!"
  }
  else
  { 
     w "<table  border=""1"" width=""970px"">"
     w "<tr>"  
     w "<th width=""10%"">序号</th>"
     w "<th width=""20%"">字段 </th>"
     w "<th width=""20%"">名称</th>"     
   
     s BDPERKeyValue=$p($g(^BDPERROR(id)),"^",7) 
      s str="",Property="",PropertyValueNew="",BDPERKeyValue1="",newstr="",StrJson="" 
      w "<th width=""25%"">数据明细</th>"
      w "</tr>"
      s Property=""
      s BDPERKeyValue1=$e(BDPERKeyValue,2,$length(BDPERKeyValue)-1)
      s StrJson=BDPERKeyValue1 
      for k=1:1:$l(BDPERKeyValue1,",") 
      {
        s newstr=$p(BDPERKeyValue1,",",k)
        s Property=$tr($p(newstr,":",1),"""","")
        s PropertyValue=$tr($p(newstr,":",2),"""","")
        s ClassN=$p($g(^BDPERROR(id)),"^",4) 
        if (ClassN["web.DHCBL.") s ClassN="User."_$P(ClassN,".",$l(ClassN,"."))
        s PropertyValue=##class(web.DHCBL.BDP.BDPTableList).GetPropValue(ClassN,Property,PropertyValue)
        s PropertyTr=##class(web.DHCBL.BDP.BDPTableList).GetPropDescByCode(ClassN,Property) 
        s PropertyValue=$tr(PropertyValue,"""","")
        
        w "<tr>"
        w "<td>"_k_"</td>"
        w "<td>"_Property_"</td>"
        w "<td>"_PropertyTr _"</td>"
        w "<td style=""word-break:break-all"">"_PropertyValue_"</td>"
        w "</tr>"
      }  
     }
     w "</table>"
}

}
