Class web.CDSS.Config.SysErrorLog Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Function:处理影响JSON格式的字符
/// Creator:  zww
/// CreateDate:2021-12-08
/// Debug:  w ##class(web.CDSS.Config.SysErrorLog).GetEvalJSON("")
ClassMethod GetEvalJSON(value) As %String
{
    s value=$tr(value,$c(10))   ;替换换行符
    s value=$tr(value,$c(13))   ;替换回车符
    s value=$Replace(value,"\\","")
    s value=$Replace(value,"'","") 
    q value
}

/// Creator:徐 凯  
/// CreatDate:2021-10-26
/// Description：MKB错误日志管理界面按条件查询
/// d ##class(%ResultSet).RunQuery("web.CDSS.Config.SysErrorLog","GetList","","",65000,67000)
/// d ##class(%ResultSet).RunQuery("web.CDSS.Config.SysErrorLog","GetList","","","","")
Query GetList(bdperapp, bdperclassinfo, datefrom, dateto) As %Query(ROWSPEC = "ID, BDPERDate, BDPERTime, BDPERApp, BDPERClassInfo, BDPERModule, BDPERErrInfo, BDPERKeyValue, BDPERIPAddress, BDPERSSUSRDR")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, bdperapp, bdperclassinfo, datefrom, dateto) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1 
 	s ID ="" 
 	
 	if ((datefrom="")&&(dateto="")){
	 	for
	 	{	
	 		s ID=$o(^CF.WDT.CDSS.SysErrorLogD(ID),-1)
			q:ID=""
			s BDPERDate = $lg($g(^CF.WDT.CDSS.SysErrorLogD(ID)),2)
			s BDPERDate = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(BDPERDate)
			s BDPERTime = $lg($g(^CF.WDT.CDSS.SysErrorLogD(ID)),3)
			s BDPERTime = ##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(BDPERTime)
			s BDPERApp = $lg($g(^CF.WDT.CDSS.SysErrorLogD(ID)),4)
			s BDPERClassInfo = $lg($g(^CF.WDT.CDSS.SysErrorLogD(ID)),5)
			s BDPERModule = $lg($g(^CF.WDT.CDSS.SysErrorLogD(ID)),6)
			s BDPERErrInfo = $lg($g(^CF.WDT.CDSS.SysErrorLogD(ID)),7)
			
			s:BDPERErrInfo="" BDPERErrInfo=$g(^ERRORLOGINFO(ID))
			s BDPERErrInfo=..GetEvalJSON(BDPERErrInfo) 
            s BDPERErrInfo= ##class(web.DHCBL.BDP.FunLib).EvalJSON(BDPERErrInfo)
            
			s BDPERKeyValue = $lg($g(^CF.WDT.CDSS.SysErrorLogD(ID)),8)
			s BDPERIPAddress = $lg($g(^CF.WDT.CDSS.SysErrorLogD(ID)),9)
			s BDPERSSUSRDR = $lg($g(^CF.WDT.CDSS.SysErrorLogD(ID)),10)
			s:BDPERSSUSRDR'="" BDPERSSUSRDR=$p($g(^SSU("SSUSR",BDPERSSUSRDR)),"^",2) 
			//s BDPERBrowserInfo = $lg($g(^CF.WDT.CDSS.SysErrorLogD(ID)),11)
			
			
			d OutputRow
	 		}
	 	}
	else
	{    
		s:datefrom'="" datefrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(datefrom)
		s:dateto'="" dateto=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(dateto)
	    s Date=dateto+1
	    for
	    { 
	      	s Date=$o(^CF.WDT.CDSS.SysErrorLogI("BDPERDateIndex",Date),-1)
	        q:(Date<datefrom)||(Date="")
		    s ID=""
	        for
	        {
		        s ID=$o(^CF.WDT.CDSS.SysErrorLogI("BDPERDateIndex",Date,ID),-1)
		        q:ID=""
				s BDPERDateTemp = $lg($g(^CF.WDT.CDSS.SysErrorLogD(ID)),2)
				s BDPERDate = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(BDPERDateTemp)
				s BDPERTime = $lg($g(^CF.WDT.CDSS.SysErrorLogD(ID)),3)
				s BDPERTime = ##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(BDPERTime)
				s BDPERApp = $lg($g(^CF.WDT.CDSS.SysErrorLogD(ID)),4)
				s BDPERClassInfo = $lg($g(^CF.WDT.CDSS.SysErrorLogD(ID)),5)
				s BDPERModule = $lg($g(^CF.WDT.CDSS.SysErrorLogD(ID)),6)
				s BDPERErrInfo = $lg($g(^CF.WDT.CDSS.SysErrorLogD(ID)),7)
				
				s:BDPERErrInfo="" BDPERErrInfo=$g(^ERRORLOGINFO(ID))
				s BDPERErrInfo=..GetEvalJSON(BDPERErrInfo) 
            	s BDPERErrInfo= ##class(web.DHCBL.BDP.FunLib).EvalJSON(BDPERErrInfo)
				
				s BDPERKeyValue = $lg($g(^CF.WDT.CDSS.SysErrorLogD(ID)),8)
				s BDPERIPAddress = $lg($g(^CF.WDT.CDSS.SysErrorLogD(ID)),9)
				s BDPERSSUSRDR = $lg($g(^CF.WDT.CDSS.SysErrorLogD(ID)),10)
				s:BDPERSSUSRDR'="" BDPERSSUSRDR=$p($g(^SSU("SSUSR",BDPERSSUSRDR)),"^",2) 
				//s BDPERBrowserInfo = $lg($g(^CF.WDT.CDSS.SysErrorLogD(ID)),11)
	            if ((BDPERDateTemp>=datefrom)&&(BDPERDateTemp<=dateto)&&((bdperapp="")||((bdperapp'="")&&(($zcvt(BDPERApp,"U")[$zcvt(bdperapp,"U")	))))&&((bdperclassinfo="")||((bdperclassinfo'="")&&($zcvt(BDPERClassInfo,"U")[$zcvt(bdperclassinfo,"U")))))  
	            {																
		        	d OutputRow
	            }
			 }
  	    }
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(ID, BDPERDate, BDPERTime, BDPERApp, BDPERClassInfo, BDPERModule, BDPERErrInfo, BDPERKeyValue, BDPERIPAddress, BDPERSSUSRDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Function: 保存错误日志
/// Creator:  sunfengchao 徐 凯
/// CreateDate:2016-6-22  2021-10-28
/// Debug: s logid=d ##class(web.CDSS.Config.SysErrorLog).SaveLog("疾病字典","web.CDSS.CMKB.DiseaseDict","SaveData",eobj)
/// w ##class(web.CDSS.Config.SysErrorLog).SaveLog()
ClassMethod SaveLog(BDPERApp As %String = "", BDPERClassInfo As %String = "", BDPERModule As %String = "", BDPERKeyValue As %String = "")
{
   new (BDPERApp,BDPERClassInfo,BDPERModule,BDPERKeyValue,%session)
   s id=0 
   if ('$d(%session))
   { 
      q "获取不到session!"
   }
   else
   { 
      s browerinfo=""
      s IPAddress=$Get(%session.Data("REMOTE_ADDR"))
      //if (IPAddress'="")  s browerinfo=$g(^TMP("dhc.bdp.errorlog",IPAddress))
      s obj=##class(CF.WDT.CDSS.SysErrorLog).%New()
      s obj.BDPERDate=+$h 
      s obj.BDPERTime=$p($h,",",2)
      s obj.BDPERApp=BDPERApp
      s obj.BDPERClassInfo=BDPERClassInfo
      s obj.BDPERModule=BDPERModule
      
      //s obj.BDPERErrInfo=BDPERErrInfo
      if (BDPERKeyValue["@web")
      {
        s obj.BDPERKeyValue=BDPERKeyValue.JsonS()
      }
      else
      {
        s obj.BDPERKeyValue=BDPERKeyValue
      }
      s obj.BDPERIPAddress =IPAddress
      d obj.BDPERSSUSRDRSetObjectId($Get(%session.Data("LOGON.USERID")))
      //s obj.BDPERBrowserInfo=browerinfo
      s sc=obj.%Save()
      If $$$ISOK(sc) 
      { 
        s id=obj.%Id() 
      }
      d obj.%Close()
   }
   q id
}

/// Function:查看数据明细
/// Creator: sunfengchao 徐 凯
/// CreateDate:2016-6-28 2021-10-29
/// Debug:  d ##class(web.CDSS.Config.SysErrorLog).QueryDataDetail(1)
ClassMethod QueryDataDetail(id As %String) As %String
{
  if (id="")
  {
    q "ID为空,没法查看数据明细!"
  }
  else
  { 
     w "<table border=""1"" bordercolor=""#CCCCCC"" height=""340px"" style=""font-size:14px;"" align=center valign=bottom >"  //bgcolor=""#CEE4FF""
     w "<tr>" 
     
     w "<th width=""20%"" height=""10%"" bgcolor=""#F4F6F5"">出错模块</th>"
     w "<th width=""20%"" height=""10%"" bgcolor=""#F4F6F5"">业务类 </th>"
     w "<th width=""20%"" height=""10%"" bgcolor=""#F4F6F5"">出错方法</th>"
     w "<th width=""20%"" height=""10%"" bgcolor=""#F4F6F5"">详细信息</th>"  
   
     s BDPERApp=$list($g(^CF.WDT.CDSS.SysErrorLogD(id)),4)
     //s BDPERApp=##class(web.BDP.util.String).EvalJSON(BDPERApp) 
     s BDPERClassInfo=$list($g(^CF.WDT.CDSS.SysErrorLogD(id)),5)
     //s BDPERClassInfo=##class(web.BDP.util.String).EvalJSON(BDPERClassInfo) 
     s BDPERModule=$list($g(^CF.WDT.CDSS.SysErrorLogD(id)),6)
     //s BDPERModule=##class(web.BDP.util.String).EvalJSON(BDPERModule) 
     s BDPERErrInfo=$list($g(^CF.WDT.CDSS.SysErrorLogD(id)),7)
   	 
   	 
   	 s:BDPERErrInfo="" BDPERErrInfo=$g(^ERRORLOGINFO(id))
	 s BDPERErrInfo=..GetEvalJSON(BDPERErrInfo) 
     s BDPERErrInfo= ##class(web.DHCBL.BDP.FunLib).EvalJSON(BDPERErrInfo)
   	 
     //s BDPERErrInfo=##class(web.BDP.util.String).EvalJSON(BDPERErrInfo) 
     s BDPERKeyValue=$list($g(^CF.WDT.CDSS.SysErrorLogD(id)),8)
     //s BDPERKeyValue=##class(web.BDP.util.String).EvalJSON(BDPERKeyValue) 
     w "<th width=""20%"" height=""10%"" bgcolor=""#F4F6F5"">原数据值</th>"
     w "</tr>"
     w "<tr>"
     w "<td >"_BDPERApp_"</td>"
     w "<td >"_BDPERClassInfo_"</td>"
     w "<td >"_BDPERModule_"</td>"
     w "<td style=""word-break:break-all"" >"_BDPERErrInfo_"</td>"
     w "<td style=""word-break:break-all"" >"_BDPERKeyValue_"</td>"
     w "</tr>"
     w "</table>"
  }
}

/// Function:测试方法
/// Creator: 徐 凯
/// CreateDate: 2021-10-29
/// Debug:  d ##class(web.CDSS.Config.SysErrorLog).Test()
ClassMethod Test()
{
	s eobj = ##class(web.CDSSEntity.CMKB.DiseaseDict).%New()
    	s eobj.DiseaseCode = "testxk5877"
		s eobj.DiseaseName = "测试xk5"
		s eobj.DiseaseEnName = "EnName5"
		s eobj.DiseaseDeptName = "Dep789tName"
		s eobj.DiseaseAliasName ="AliasName" 
		s eobj.ICD9Code = "ICD9Co769de2"
		s eobj.ICD9Name = "ICD9Name2"
		s eobj.ICD10Code = "10Code2"
		s eobj.ICD10Name = "10Nam897e2"
		s eobj.ICD10LocalCode = "10LocalCode2"
		s eobj.ICD10LocaName = "10Loca897Name2"
		s eobj.ICD11Code = "11Cod8e2"
		s eobj.ICD11Name = "11Nam6e2"
		s eobj.RareDiseaseFlag="Diseas6eFlag"
		s eobj.UseFlag = "UseFla6g"
		s eobj.CreateDate="Dat6e"
		s eobj.CreateUserID = "2"
		s eobj.Remarks = "Rema6rks"
		s eobj.Version = "V6ersion"	
		s eobj.QuoteFlag = "QuoteFlag"
		s eobj.KnowledgeTotal = "Total"
	d ..SaveLog("疾病字典","web.CDSS.CMKB.DiseaseDict","SaveData",eobj)
	q ""
}

///  Function： 获取浏览器信息
///  Creator:   sunfengchao
///  CreateDate:  2016-6-28
///  Debug:   w ##class(web.CDSS.Config.SysErrorLog).GetBrowerInfo()
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

/// Creator:赵文伟
/// CreatDate:2023-02-23
/// Description:获得数据详情
/// Table: 
/// Input: RowId
/// Return:返回数据详情
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.Config.SysErrorLog","GetDetailLogList","10")
Query GetDetailLogList(RowId As %String) As %Query(ROWSPEC = "RowId,BDPERApp,BDPERClassInfo,BDPERModule,BDPERErrInfo,BDPERKeyValue")
{
}

ClassMethod GetDetailLogListExecute(ByRef qHandle As %Binary, RowId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s str=""
 	if (RowId'="")
 	{    s id=RowId
		 s BDPERApp=$list($g(^CF.WDT.CDSS.SysErrorLogD(id)),4)
	     //s BDPERApp=##class(web.BDP.util.String).EvalJSON(BDPERApp) 
	     s BDPERClassInfo=$list($g(^CF.WDT.CDSS.SysErrorLogD(id)),5)
	     //s BDPERClassInfo=##class(web.BDP.util.String).EvalJSON(BDPERClassInfo) 
	     s BDPERModule=$list($g(^CF.WDT.CDSS.SysErrorLogD(id)),6)
	     //s BDPERModule=##class(web.BDP.util.String).EvalJSON(BDPERModule) 
	     s BDPERErrInfo=$list($g(^CF.WDT.CDSS.SysErrorLogD(id)),7)
	   	 
	   	 
	   	 s:BDPERErrInfo="" BDPERErrInfo=$g(^ERRORLOGINFO(id))
		 s BDPERErrInfo=..GetEvalJSON(BDPERErrInfo) 
	     s BDPERErrInfo= ##class(web.DHCBL.BDP.FunLib).EvalJSON(BDPERErrInfo)
	   	 
	     s BDPERKeyValue=$list($g(^CF.WDT.CDSS.SysErrorLogD(id)),8)
	     d OutputRowLog
	    
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowLog
	set Data=$lb(RowId,BDPERApp,BDPERClassInfo,BDPERModule,BDPERErrInfo,BDPERKeyValue)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetDetailLogListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDetailLogListExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDetailLogListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDetailLogListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
