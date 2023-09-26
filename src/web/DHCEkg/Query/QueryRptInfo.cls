Class web.DHCEkg.Query.QueryRptInfo Extends %RegisteredObject
{

/// 查询符合条件的检查信息
/// 入参： 登记号，就诊号，开始日期，结束日期
/// 返回值： 检查号，检查名称，报告地址
/// d ##class(%ResultSet).RunQuery("web.DHCEkg.Query.QueryRptInfo","GetRptList","0000000350","","2020-1-1","2020-8-25")
Query GetRptList(PatRegNo As %String, AdmNo As %String, StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "DocumentID:%String,DocumentPath:%String,DocumentTitle:%String,DocumentType:%String,UpdateUser:%String,UpdateDate:%String,UpdateTime:%String")
{
}

ClassMethod GetRptListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetConOderExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetRptListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetConOderExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod GetRptListExecute(ByRef qHandle As %Binary, PatRegNo As %String, AdmNo As %String, StartDate As %String, EndDate As %String) As %Status
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkg.Query.QueryRptInfo","GetRptList",$zd($h,3),$zt($p($h,",",2),1),PatRegNo_"^"_AdmNo_"^"_StartDate_"^"_EndDate,"params")
	new $namespace
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
	i (StartDate="") s StartDate=$p($h,",",1)
	e  s StartDate=$zdh(StartDate,3)
	i (EndDate="") s EndDate=$p($h,",",1)
	e  s EndDate=$zdh(EndDate,3)
	d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	
	//获取ftp的http路径
	s httpUrl=""
	s configId=$o(^dbo.tblConfigureI("idxKey"," FTPHTTPURL",""))						
	i (configId'="") 
	{
		s configInfo=^dbo.tblConfigureD(configId)
		i (configInfo'="") s httpUrl=$listget(configInfo,6,"")
	}
	
	i (AdmNo'="")
	{
		s tmpReqId=""
		s tmpReqId=$o(^dbo.tblRequestI("idxAppointNo",AdmNo,tmpReqId))
		while(tmpReqId'="")
		{
			s reqInfo=$g(^dbo.tblRequestD(tmpReqId))
			i (reqInfo'="")
			{
				s reqTime=$listget(reqInfo,18)
				s reqDate=$zdh(reqTime,3)
				i ((reqDate>=StartDate)&&(reqDate<=EndDate))
				{
					s (tmpExamId,examId)=""
					s tmpExamId=$o(^dbo.tblExaminationI("idxRequestID",tmpReqId,tmpExamId))
					s flag=1
					while((tmpExamId'="")&&flag)
					{
						s examInfo=$g(^dbo.tblExaminationD(tmpExamId))
						i (examInfo'="")
						{
							s statusCode=$listget(examInfo,20)
							i (statusCode="15")!(statusCode="17")
							{
								s examId=tmpExamId
								s flag=0 ;查找到有效检查记录
						
							}
						}
						s tmpExamId=$o(^dbo.tblExaminationI("idxRequestID",tmpReqId,tmpExamId))
					}
					i (examId'="")
					{
						d GetDocInfo
						d OutputRowList
					}
				}
			}
			s tmpReqId=$o(^dbo.tblRequestI("idxAppointNo",AdmNo,tmpReqId))
		}
	}
	elseif (PatRegNo'="")
	{
		s patId=""
		s patId=$o(^dbo.tblPatientI("indexPatientCode"," "_PatRegNo,patId))
		while(patId'="")
		{
			s tmpReqId=""
			s tmpReqId=$o(^dbo.tblRequestI("idxPatientID",patId,tmpReqId))
			while(tmpReqId'="")
			{
				s reqInfo=$g(^dbo.tblRequestD(tmpReqId))
				i (reqInfo'="")
				{
					s reqTime=$listget(reqInfo,18)
					s reqDate=$zdh(reqTime,3)
					i ((reqDate>=StartDate)&&(reqDate<=EndDate))
					{
						s (tmpExamId,examId)=""
						s tmpExamId=$o(^dbo.tblExaminationI("idxRequestID",tmpReqId,tmpExamId))
						s flag=1
						while((tmpExamId'="")&&flag)
						{
							s examInfo=$g(^dbo.tblExaminationD(tmpExamId))
							i (examInfo'="")
							{
								s statusCode=$listget(examInfo,20)
								i (statusCode="15")!(statusCode="17")
								{
									s examId=tmpExamId
									s flag=0 ;查找到有效检查记录
							
								}
							}
							s tmpExamId=$o(^dbo.tblExaminationI("idxRequestID",tmpReqId,tmpExamId))
						}
						i (examId'="")
						{
							d GetDocInfo
							d OutputRowList
						}
					}
				}
				s tmpReqId=$o(^dbo.tblRequestI("idxPatientID",patId,tmpReqId))
			}
			s patId=$o(^dbo.tblPatientI("indexPatientCode"," "_PatRegNo,patId))
		}
	}
	
 	s qHandle=$lb(0,repid,0)
	q $$$OK
GetDocInfo

	;
	s (DocumentID,DocumentPath,DocumentTitle,DocumentType,UpdateUser,UpdateDate,UpdateTime)=""
	s DocumentID=examId
	s examInfo=$g(^dbo.tblExaminationD(examId))
	s reqId=$listget(examInfo,19)
	s reqInfo=$g(^dbo.tblRequestD(reqId))
	s examItemCode=$listget(reqInfo,11)
	i (examItemCode'="")
	{
		s examItemId=$o(^dbo.tblDictExamItemI("idxExamItemCode"," "_$zcvt(examItemCode,"u"),""))
		i (examItemId'="") s DocumentTitle=$listget($g(^dbo.tblDictExamItemD(examItemId)),6)
	}
	s testtype=""
	s devId=$listget(examInfo,10)
	i (devId'="")
	{
		s testtype=$listget($g(^dbo.tblDeviceD(devId)),3)
	}
	s fileId=""
	s fileId=$o(^dbo.tblFilePathI("idxExaminationID",examId,fileId),-1)
	while(fileId'="")
	{
		s fileInfo=$g(^dbo.tblFilePathD(fileId))
		i (fileInfo'="")
		{
			s reservedName=$listget(fileInfo,6)
			i (reservedName'="") 
			{
				s pdfPath=httpUrl_reservedName
				i (DocumentPath'="") s DocumentPath=DocumentPath_"^"_pdfPath
				e  s DocumentPath=pdfPath
			}
		}
		q:(testtype'="1") ;非静息类型，只取最新的一条
		s fileId=$o(^dbo.tblFilePathI("idxExaminationID",examId,fileId),-1)
	}
	q
OutputRowList
	zn "dhc-app"
	s Data=$lb(DocumentID,DocumentPath,DocumentTitle,DocumentType,UpdateUser,UpdateDate,UpdateTime)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	q
}

}
