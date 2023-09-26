/// Creator:高姗姗
/// CreatDate:2019-07-23
/// Description：结构化诊断删除日志表
/// Table：User.SDSDiagnosDelLog
Class web.DHCBL.MKB.SDSDiagnosDelLog Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2018-06-04
/// Description：查询诊断列表内容,诊断标记封闭的数据不显示
/// Table：User.SDSDiagnos
/// Input：mradm,rowid
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.SDSDiagnosDelLog","GetList","460")
Query GetList(PatientID As %String) As %Query(ROWSPEC = "SDSRowId,SDSTermDR,SDSDisplayName,SDSOpenDate,SDSIcdCode,SDSIcdDesc,SDSWordDR,SDSWordDesc,SDSDiagnosId,SDSMainDiagFlag,SDSInsertUserDR,SDSInsertUser,SDSInsertDate,SDSInsertTime,SDSUpdateUserDR,SDSUpdateUser,SDSUpdateDate,SDSUpdateTime")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, PatientID As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 if (PatientID'=""){
	  s SDSRowId=""
	  for{  
	  	  s SDSRowId=$o(^User.SDSDiagnosDelLogI("PMIIndex",PatientID,SDSRowId))
		  q:SDSRowId=""  
		  s SDSTermDR=$LISTGET($G(^User.SDSDiagnosDelLogD(SDSRowId)),2)
		  s SDSOpenDate=$LISTGET($G(^User.SDSDiagnosDelLogD(SDSRowId)),8)
		  s:SDSOpenDate'="" SDSOpenDate = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(SDSOpenDate)
		  s SDSIcdCode=$LISTGET($G(^User.SDSDiagnosDelLogD(SDSRowId)),5)
		  s SDSIcdDesc=$LISTGET($G(^User.SDSDiagnosDelLogD(SDSRowId)),6)
		  s SDSWordDR=$LISTGET($G(^User.SDSDiagnosDelLogD(SDSRowId)),7)
		  s SDSWordDesc=""
		  s version=##class(web.DHCBL.MKB.SDSDiagnos).GetWordVersion()
		  if ((version="A")||(version="B")||(version="C")||(version="D")){ //取自各版本icd对照
			  s:SDSWordDR'="" SDSWordDesc=$listGet($g(^User.MKBICDContrastD(SDSWordDR)),3)
		  }else{ //取自数据处理工厂
			  s:SDSWordDR'="" SDSWordDesc=$listGet($g(^User.MKBStructuredDataD(SDSWordDR)),2)
		  }
		  
  		  s SDSDiagnosId=$LISTGET($G(^User.SDSDiagnosDelLogD(SDSRowId)),10)
  		  s SDSDisplayName=$LISTGET($G(^User.SDSDiagnosDelLogD(SDSRowId)),12)
  		  s SDSMainDiagFlag=$LISTGET($G(^User.SDSDiagnosDelLogD(SDSRowId)),13)
  		  
  		  s SDSInsertUserDR=$LISTGET($G(^User.SDSDiagnosDelLogD(SDSRowId)),14)
  		  s:SDSInsertUserDR'="" SDSInsertUser=$p($g(^SSU("SSUSR",SDSInsertUserDR)),"^",2)
		  s:SDSInsertUserDR="" SDSInsertUser=""
  		  s SDSInsertDate=$LISTGET($G(^User.SDSDiagnosDelLogD(SDSRowId)),15)
  		  s:SDSInsertDate'="" SDSInsertDate = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(SDSInsertDate)
  		  s SDSInsertTime=$LISTGET($G(^User.SDSDiagnosDelLogD(SDSRowId)),16)
  		  s:SDSInsertTime'="" SDSInsertTime=$zt(SDSInsertTime,1)
  		  s SDSUpdateUserDR=$LISTGET($G(^User.SDSDiagnosDelLogD(SDSRowId)),17)
  		  s:SDSUpdateUserDR'="" SDSUpdateUser=$p($g(^SSU("SSUSR",SDSUpdateUserDR)),"^",2)
		  s:SDSUpdateUserDR="" SDSUpdateUser=""
  		  s SDSUpdateDate=$LISTGET($G(^User.SDSDiagnosDelLogD(SDSRowId)),18)
  		  s:SDSUpdateDate'="" SDSUpdateDate = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(SDSUpdateDate)
  		  s SDSUpdateTime=$LISTGET($G(^User.SDSDiagnosDelLogD(SDSRowId)),19)
  		  s:SDSUpdateTime'="" SDSUpdateTime=$zt(SDSUpdateTime,1)
  		  
		  d OutputRow
	  } 
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(SDSRowId,SDSTermDR,SDSDisplayName,SDSOpenDate,SDSIcdCode,SDSIcdDesc,SDSWordDR,SDSWordDesc,SDSDiagnosId,SDSMainDiagFlag,SDSInsertUserDR,SDSInsertUser,SDSInsertDate,SDSInsertTime,SDSUpdateUserDR,SDSUpdateUser,SDSUpdateDate,SDSUpdateTime)
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

/// Creator:高姗姗
/// CreatDate:2019-5-30
/// Description：保存结构化诊断删除日志
/// Table：User.SDSDiagnosDelLog
/// Input：rowid:结构化诊断id 
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnosDelLog).SaveData("2")
ClassMethod SaveData(rowid) As %String
{
	s result=""
	s pobj = ##class(User.SDSDiagnos).%OpenId(rowid)
	if $IsObject(pobj){
		s PatientID="",SDSWordDR="",SDSTermDR="",SDSSupplement="",SDSOpenDate="",SDSIcdCode="",SDSIcdDesc="",SDSSequence="",SDSMainDiagFlag=""
		s PatientID=pobj.SDSPMIDR.%Id()
		s SDSWordDR=pobj.SDSWordDR
		s:pobj.SDSTermDR'="" SDSTermDR = pobj.SDSTermDR.%Id()
		s:pobj.SDSTermDR="" SDSTermDR = ""
		s SDSSupplement = pobj.SDSSupplement
		s:pobj.SDSOpenDate'="" SDSOpenDate = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.SDSOpenDate)
		s SDSIcdCode=pobj.SDSIcdCode
		s SDSIcdDesc=pobj.SDSIcdDesc
		s SDSSequence=pobj.SDSSequence
		s SDSMainDiagFlag=pobj.SDSMainDiagFlag
		//根据历史记录获取录入诊断的操作人、日期、时间
		s SDSInsertUserDR="",SDSInsertDate="",SDSInsertTime="" 
		s subLog=$o(^User.SDSDiagnosD(rowid,"ChildLog",0))  
		if (subLog'=""){
			s SDSInsertUserDR=$LISTGET($G(^User.SDSDiagnosD(rowid,"ChildLog",subLog)),2)
			s SDSInsertDate=$LISTGET($G(^User.SDSDiagnosD(rowid,"ChildLog",subLog)),3)
			s SDSInsertTime=$LISTGET($G(^User.SDSDiagnosD(rowid,"ChildLog",subLog)),4)
		}
		
		
		;保存诊断删除日志信息
		s SDSUpdateUserDR=$Get(%session.Data("LOGON.USERID"))
		s SDSUpdateDate=+$H
		s SDSUpdateTime=$P($H,",",2)
		s obj=##class(User.SDSDiagnosDelLog).%New()
		d:PatientID'="" obj.SDSPMIDRSetObjectId(PatientID)
		d:PatientID="" obj.SDSPMIDRSetObjectId("")
		d:SDSTermDR'="" obj.SDSTermDRSetObjectId(SDSTermDR)
		d:SDSTermDR="" obj.SDSTermDRSetObjectId("")
		s obj.SDSWordDR=SDSWordDR
		
		s obj.SDSSupplement=SDSSupplement
		i SDSOpenDate'=""
		{
			s obj.SDSOpenDate = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(SDSOpenDate) 
		}
		else
		{s obj.SDSOpenDate=""}
		s obj.SDSIcdCode=SDSIcdCode
		s obj.SDSIcdDesc=SDSIcdDesc
		s obj.SDSSequence=SDSSequence
		
		s obj.SDSDiagnosId=rowid
		s obj.SDSValue=$p(##class(web.DHCBL.MKB.SDSDiagnosProperty).GetParamStr(rowid),"-",2)
		s obj.SDSDisplayName=##class(web.DHCBL.MKB.SDSDiagnos).GetDiagName(rowid)
		
		s obj.SDSMainDiagFlag=SDSMainDiagFlag
		
		d obj.SDSInsertUserDRSetObjectId(SDSInsertUserDR)
		s obj.SDSInsertDate=SDSInsertDate
		s obj.SDSInsertTime=SDSInsertTime
		
		d obj.SDSUpdateUserDRSetObjectId(SDSUpdateUserDR)
		s obj.SDSUpdateDate=SDSUpdateDate
		s obj.SDSUpdateTime=SDSUpdateTime
		
		
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
		}else{
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
		}
		
	}else{
		s result = "{success:'false',errorinfo:'对象不存在'}"	
	}
	q result
}

}
