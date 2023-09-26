Class web.INSUINFOGetUploadDetails Extends (%RegisteredObject, %XML.Adaptor)
{

/// 根据就诊号或账单号生成医嘱上传信息流
/// PAADM:就诊号,BILLNO:账单号,xjType:数据格式类型(XML,STR,JSON),ExpStr:扩展字符串
/// s CS=##class(web.INSUINFOGetUploadDetails).GetOrderDetails("",266659,"XML","")
ClassMethod GetOrderDetails(PAADM As %String = "", BILLNO As %String = "", xjType As %String = "XML", ExpStr As %String) As %CharacterStream
{
	;k ^zmc("testd")
	;K ^zmc("testd","index")
	s dh0=$p($h,",",2)
	s dh1=$p($zts,",",2)
	s objstream = ##class(%Stream.GlobalCharacter).%New()
	d objstream.Clear()
	q:(PAADM="")&(BILLNO="") objstream
	
	s mCurrRowPatientBill=$g(^DHCPB(BILLNO))
	s:PAADM="" PAADM=$p(mCurrRowPatientBill,"^",1)
	s AdmreasonDr=$p($g(^PAADM(PAADM,1)),"^",7)
	s InsuType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToTariType",AdmreasonDr,6)	;Zhan 20160525
	s hospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(PAADM)
	s oeobjlist=##class(%ListOfDataTypes).%New()
	s oeobjlist=##class(web.INSUINFOUploadDetails).GetOEORDINFO(BILLNO)
	s dh2=$p($zts,",",2)
	;s ^zmc("testd","GetOEORDINFO")=dh2-dh1
	s oeCount=+oeobjlist.Size
	q:oeCount<1 objstream
	s rootstr=ExpStr
	s:rootstr="" rootstr="YB_BODY"	;根节点
	s subnode=##class(web.INSUINFOParser).GetIDLIST(InsuType,"INSUOEUPLOAD",hospDR)
	;d objstream.Clear()
	f i=1:1:oeCount d
	.s tmpoestr=""
	.s dh1=$p($zts,",",2)
	.s tmpoeobj=##class(web.INSUOEORDInfo).%New()
	.s tmpoeobj=oeobjlist.GetAt(i)
	.m ^||INSUOEORDINFTOXML=^||INSUOEORDINFTOXMLOLE
	.;s dh2=$p($zts,",",2)	
	.;s ^zmc("testd","index")=i
	.s tmpinfostr=##class(web.INSUINFOParser).GetINSUUPLOADINFTO(xjType,subnode,tmpoeobj,"")
	.;w tmpoestr,!
	.;b ;zhan 1
	.;s dh3=$p($zts,",",2)	
	.;s ^zmc("testd","for",i)=(dh2-dh1)_"_"_(dh3-dh2)
	.;s:tmpoestr'="" tmpoestr="<"_rootstr_">"_tmpoestr_"</"_rootstr_">"
	.;w "tmpoeobj.OEORIExe.Count():"_tmpoeobj.OEORIExe.Count()
	.i (tmpinfostr'="")&(xjType="JSON") d
	..i oeCount>1 d
	...i i=1 d
	....s tmpinfostr=$p(tmpinfostr,"}]}",1)_"}"
	...i i>1 d
	....s tmpinfostr=",{"_$p(tmpinfostr,"[{",2)
	....s tmpinfostr=$p(tmpinfostr,"}]}",1)_"}"
	...s:i=oeCount tmpinfostr=tmpinfostr_"]}"
	..d objstream.Write(tmpinfostr)
	.e  d:tmpinfostr'="" objstream.Write(tmpinfostr_$c(0))
	;s ^zmc("testd","Tol")=$p($h,",",2)-dh0
	q objstream
}

/// 根据就诊号或账单号生成诊断上传信息流
/// PAADM:就诊号,BILLNO:账单号,xjType:数据格式类型(XML,STR,JSON),ExpStr:扩展字符串
/// s CS=##class(web.INSUINFOGetUploadDetails).GetDiagnosisdetails("189082",220801,"XML","YB_BODY")
/// w ##class(web.INSUINFOGetUploadDetails).GetDiagnosisdetails("193",220801,"XML","YB_BODY")
ClassMethod GetDiagnosisdetails(PAADM As %String = "", BILLNO As %String = "", xjType As %String = "XML", ExpStr As %String) As %String
{

	s objstream ="" ; ##class(%Stream.GlobalCharacter).%New()
	;d objstream.Clear()
	q:PAADM="" objstream
	s hospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(PAADM)
	s AdmreasonDr=$p($g(^PAADM(PAADM,1)),"^",7)
	s InsuType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToTariType",AdmreasonDr,6)	;Zhan 20160525
	s objectlist=##class(%ListOfDataTypes).%New()
	s objectlist=##class(web.INSUINFOUploadDetails).GetDiagnosINFO(PAADM)
	s oeCount=+objectlist.Size
	q:oeCount<1 objstream
	s rootstr=ExpStr
	s:rootstr="" rootstr="YB_BODY"	;根节点
	s subnode=##class(web.INSUINFOParser).GetIDLIST(InsuType,"INSUDIAGUPLOAD",hospDR)
	f i=1:1:oeCount d
	.s tmpoestr=""
	.s tmpobject=##class(web.INSUDIAGsInfo).%New()
	.s tmpobject=objectlist.GetAt(i)
	.m ^||INSUOEORDINFTOXML=^||INSUOEORDINFTOXMLOLE
	.s tmpinfostr=##class(web.INSUINFOParser).GetINSUUPLOADINFTO(xjType,subnode,tmpobject,"")
	.i (tmpinfostr'="")&(xjType="JSON") d
	..i oeCount>1 d
	...i i=1 d
	....s tmpinfostr=$p(tmpinfostr,"}]}",1)_"}"
	...i i>1 d
	....s tmpinfostr=",{"_$p(tmpinfostr,"[{",2)
	....s tmpinfostr=$p(tmpinfostr,"}]}",1)_"}"
	...s:i=oeCount tmpinfostr=tmpinfostr_"]}"
	..d objstream.Write(tmpinfostr)
	.e  d:tmpinfostr'="" objstream.Write(tmpinfostr_$c(0))
	q objstream
}

/// 根据就诊号或账单号生成手术上传信息流
/// PAADM:就诊号,BILLNO:账单号,xjType:数据格式类型(XML,STR,JSON),ExpStr:扩展字符串
/// s CS=##class(web.INSUINFOGetUploadDetails).GetOPTInfodetails("3401250",5478068,"JSON","")
/// w ##class(web.INSUINFOGetUploadDetails).GetOPTInfodetails("",25304100,"XML","")
ClassMethod GetOPTInfodetails(PAADM As %String = "", BILLNO As %String = "", xjType As %String = "XML", ExpStr As %String) As %CharacterStream
{

	s objstream = ##class(%Stream.GlobalCharacter).%New()
	d objstream.Clear()
	q:PAADM="" objstream
	s hospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(PAADM)
	s AdmreasonDr=$p($g(^PAADM(PAADM,1)),"^",7)
	s InsuType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToTariType",AdmreasonDr,6)	;Zhan 20160525
	s objectlist=##class(%ListOfDataTypes).%New()
	s objectlist=##class(web.INSUOPSInfoUpload).GetOPSINFO(PAADM)
	s oeCount=+objectlist.Size
	q:oeCount<1 objstream
	s rootstr=ExpStr
	s:rootstr="" rootstr="YB_BODY"	;根节点
	s subnode=##class(web.INSUINFOParser).GetIDLIST(InsuType,"INSUOPTUPLOAD",hospDR)
	f i=1:1:oeCount d
	.s tmpoestr=""
	.s tmpobject=##class(web.INSUOPSInfo).%New()
	.s tmpobject=objectlist.GetAt(i)
	.m ^||INSUOEORDINFTOXML=^||INSUOEORDINFTOXMLOLE
	.s tmpinfostr=##class(web.INSUINFOParser).GetINSUUPLOADINFTO(xjType,subnode,tmpobject,"")
	.i (tmpinfostr'="")&(xjType="JSON") d
	..i oeCount>1 d
	...i i=1 d
	....s tmpinfostr=$p(tmpinfostr,"}]}",1)_"}"
	...i i>1 d
	....s tmpinfostr=",[{"_$p(tmpinfostr,"[{",2)
	....s tmpinfostr=$p(tmpinfostr,"}]}",$l(tmpinfostr,"}]}")-1)
	...s:i=oeCount tmpinfostr=tmpinfostr_"]}"
	..d objstream.Write(tmpinfostr)
	.e  d:tmpinfostr'="" objstream.Write(tmpinfostr_$c(0))
	q objstream
}

/// 根据就诊号或账单号生成检验上传信息流
/// PAADM:就诊号,BILLNO:账单号,xjType:数据格式类型(XML,STR,JSON),ExpStr:扩展字符串
/// s CS=##class(web.INSUINFOGetUploadDetails).GetLisInfodetails("189082",224530,"XML","YB_BODY")
/// w ##class(web.INSUINFOGetUploadDetails).GetLisInfodetails("193",220801,"XML","YB_BODY")
ClassMethod GetLisInfodetails(PAADM As %String = "", BILLNO As %String = "", xjType As %String = "XML", ExpStr As %String) As %CharacterStream
{

	s objstream = ##class(%Stream.GlobalCharacter).%New()
	d objstream.Clear()
	q:PAADM="" objstream
	s hospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(PAADM)
	s AdmreasonDr=$p($g(^PAADM(PAADM,1)),"^",7)
	s InsuType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToTariType",AdmreasonDr,6)	;Zhan 20160525
	s listobjlist=##class(%ListOfDataTypes).%New()
	s listobjlist=##Class(web.INSUGetLISReport).GetReportList(PAADM,"Labdata")
	s oeCount=+listobjlist.Size
	q:oeCount<1 objstream
	s rootstr=ExpStr
	s:rootstr="" rootstr="YB_BODY"	;根节点
	s HeadInfo= ##class(web.INSUINFOGetUploadDetails).GetHeadInfo(PAADM,"3301")
	q:HeadInfo="" objstream
	s subnode=##class(web.INSUINFOParser).GetIDLIST(InsuType,"INSULISREPORTUPLOAD",hospDR)
	f i=1:1:oeCount d
	.s tmpoestr=""
	.s tmpobject=##class(web.INSULISReport).%New()
	.s tmpobject=listobjlist.GetAt(i)
	.m ^||INSUOEORDINFTOXML=^||INSUOEORDINFTOXMLOLE
	.s tmpinfostr=##class(web.INSUINFOParser).GetINSUUPLOADINFTO(xjType,subnode,tmpobject,"")
	.i (tmpinfostr'="")&(xjType="JSON") d
	..i oeCount>1 d
	...i i=1 d
	....s tmpinfostr=$p(tmpinfostr,"}]}",1)_"}"
	...i i>1 d
	....s tmpinfostr=",{"_$p(tmpinfostr,"[{",2)
	....s tmpinfostr=$p(tmpinfostr,"}]}",1)_"}"
	...s:i=oeCount tmpinfostr=tmpinfostr_"]}"
	..d objstream.Write(tmpinfostr)
	.e  d:tmpinfostr'="" objstream.Write(tmpinfostr_$c(0))
	q objstream
}

/// 根据就诊号或账单号生成检查上传信息流
/// PAADM:就诊号,BILLNO:账单号,xjType:数据格式类型(XML,STR,JSON),ExpStr:扩展字符串
/// s CS=##class(web.INSUINFOGetUploadDetails).GetPACSInfodetails("189082",224530,"XML","YB_BODY")
/// w ##class(web.INSUINFOGetUploadDetails).GetPACSInfodetails("193",220801,"XML","YB_BODY")
ClassMethod GetPACSInfodetails(PAADM As %String = "", BILLNO As %String = "", xjType As %String = "XML", ExpStr As %String) As %CharacterStream
{

	s objstream = ##class(%Stream.GlobalCharacter).%New()
	d objstream.Clear()
	q:PAADM="" objstream
	s hospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(PAADM)
	s AdmreasonDr=$p($g(^PAADM(PAADM,1)),"^",7)
	s InsuType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToTariType",AdmreasonDr,6)	;Zhan 20160525
	s PACSobjlist=##class(%ListOfDataTypes).%New()
	s PACSobjlist=##Class(RISService.InvokeRISService).HCSReportInfobyPaadmdr(PAADM)
	s oeCount=+PACSobjlist.ReportList.Size
	b ;zhan
	q:oeCount<1 objstream
	s rootstr=ExpStr
	s:rootstr="" rootstr="YB_BODY"	;根节点
	s subnode=##class(web.INSUINFOParser).GetIDLIST(InsuType,"INSUPACSUPLOAD",hospDR)
	;s HeadInfo= ##class(web.INSUINFOGetUploadDetails).GetHeadInfo(PAADM,"3302")
	q:HeadInfo="" objstream
	f i=1:1:oeCount d
	.s tmpoestr=""
	.s tmpPACSobj=##class(RISService.HealthCareSystemClass.PACSReport).%New()
	.s tmpPACSobj=PACSobjlist.ReportList.GetAt(i)
	.m ^||INSUOEORDINFTOXML=^||INSUOEORDINFTOXMLOLE
	.s tmpinfostr=##class(web.INSUINFOParser).GetINSUUPLOADINFTO(xjType,subnode,tmpPACSobj,"")
	.i (tmpinfostr'="")&(xjType="JSON") d
	..i oeCount>1 d
	...i i=1 d
	....s tmpinfostr=$p(tmpinfostr,"}]}",1)_"}"
	...i i>1 d
	....s tmpinfostr=",{"_$p(tmpinfostr,"[{",2)
	....s tmpinfostr=$p(tmpinfostr,"}]}",1)_"}"
	...s:i=oeCount tmpinfostr=tmpinfostr_"]}"
	..d objstream.Write(tmpinfostr)
	.e  d:tmpinfostr'="" objstream.Write(tmpinfostr_$c(0))
	q objstream
}

/// 根据就诊号或账单号生成病案首页上传信息流
/// PAADM:就诊号,BILLNO:账单号,xjType:数据格式类型(XML,STR,JSON),ExpStr:扩展字符串
/// s CS=##class(web.INSUINFOGetUploadDetails).GetEPRInfodetails("189082","","XML","YB_BODY")
/// w ##class(web.INSUINFOGetUploadDetails).GetEPRInfodetails("193",220801,"XML","YB_BODY")
ClassMethod GetEPRInfodetails(PAADM As %String = "", BILLNO As %String = "", xjType As %String = "XML", ExpStr As %String) As %CharacterStream
{

	s objstream = ##class(%Stream.GlobalCharacter).%New()
	d objstream.Clear()
	q:PAADM="" objstream
	s hospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(PAADM)
	s AdmreasonDr=$p($g(^PAADM(PAADM,1)),"^",7)
	s InsuType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToTariType",AdmreasonDr,6)	;Zhan 20160525
	;s EPRobjlist=##class(%ListOfDataTypes).%New()
	;s EPRobjlist=##Class(RISService.InvokeRISService).HCSReportInfobyPaadmdr(PAADM)
	;s oeCount=+EPRobjlist.ReportList.Size
	;q:oeCount<1 objstream
	s eprXML=##class(EMRmeta.Data.Method.InterfaceMethod).GetFirstPageInfo(PAADM,"WMR")	//调用电子病历接口,生成XML。如果没有此接口请让实施联系电子病历组
	q:tmpXMLStr'["<Response>" objstream
	s tmpEPRobj=##class(web.INSUEPRInfo).%New()
	d ##class(web.INSUCacheXML).Deserialize(.tmpEPRobj,"Response",tmpXMLStr)
	
	s rootstr=ExpStr
	s:rootstr="" rootstr="YB_BODY"	;根节点
	;s HeadInfo= ##class(web.INSUINFOGetUploadDetails).GetHeadInfo(PAADM,"3303")
	s subnode=##class(web.INSUINFOParser).GetIDLIST(InsuType,"INSUEPRUPLOAD",hospDR)
	s tmpoestr=""

	m ^||INSUOEORDINFTOXML=^||INSUOEORDINFTOXMLOLE
	s tmpinfostr=##class(web.INSUINFOParser).GetINSUUPLOADINFTO(xjType,subnode,tmpEPRobj,"")
	;s DigStr=##class(web.INSUINFOGetUploadDetails).GetDiagnosisdetails(PAADM,BILLNO,xjType,ExpStr)

	;d:tmpoestr'="" objstream.Write(tmpoestr_$c(0))
	d:tmpinfostr'="" objstream.Write(tmpinfostr)
	k ^||TMPEPRAR(PAADM)
	q objstream
}

/// 根据就诊号或账单号生成病案首页上传信息流(编目后)
/// PAADM:就诊号,BILLNO:账单号,xjType:数据格式类型(XML,STR,JSON),ExpStr:扩展字符串
/// s CS=##class(web.INSUINFOGetUploadDetails).GetEPRInfodetails("189082","","XML","YB_BODY")
/// w ##class(web.INSUINFOGetUploadDetails).GetEPRInfodetails("193",220801,"XML","YB_BODY")
ClassMethod GetWMRInfodetails(PAADM As %String = "", BILLNO As %String = "", xjType As %String = "XML", ExpStr As %String) As %CharacterStream
{

	s objstream = ##class(%Stream.GlobalCharacter).%New()
	d objstream.Clear()
	q:PAADM="" objstream
	s hospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(PAADM)
	s AdmreasonDr=$p($g(^PAADM(PAADM,1)),"^",7)
	s InsuType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToTariType",AdmreasonDr,6)	;Zhan 20160525
	;s EPRobjlist=##class(%ListOfDataTypes).%New()
	;s EPRobjlist=##Class(RISService.InvokeRISService).HCSReportInfobyPaadmdr(PAADM)
	;s oeCount=+EPRobjlist.ReportList.Size
	;q:oeCount<1 objstream
	//s eprXML=##class(EMRmeta.Data.Method.InterfaceMethod).GetFirstPageInfo(PAADM,"WMR")	//调用电子病历接口,生成XML。如果没有此接口请让实施联系电子病历组
	Set tmparr=##Class(%ArrayOfDataTypes).%New()
	s tmparr=##Class(DHCMRQ.MRService.GetDataService).GetArrayOfDataByAdm("Coding","",PAADM)
	q:tmparr.Count()<1 objstream
	s tmpEPRobj=##class(DHCMRQ.MR.FrontPageAll).%New()
	d ##class(web.INSUCacheJSON).RtnObjectFromJSON(.tmpEPRobj,tmparr)
	b ;1
	s rootstr=ExpStr
	s:rootstr="" rootstr="YB_BODY"	;根节点
	;s HeadInfo= ##class(web.INSUINFOGetUploadDetails).GetHeadInfo(PAADM,"3303")
	s subnode=##class(web.INSUINFOParser).GetIDLIST(InsuType,"INSUWMRUPLOAD",hospDR)
	s tmpoestr=""

	m ^||INSUOEORDINFTOXML=^||INSUOEORDINFTOXMLOLE
	s tmpinfostr=##class(web.INSUINFOParser).GetINSUUPLOADINFTO(xjType,subnode,tmpEPRobj,"")
	;s DigStr=##class(web.INSUINFOGetUploadDetails).GetDiagnosisdetails(PAADM,BILLNO,xjType,ExpStr)

	;d:tmpoestr'="" objstream.Write(tmpoestr_$c(0))
	d:tmpinfostr'="" objstream.Write(tmpinfostr)
	k ^||TMPEPRAR(PAADM)
	q objstream
}

/// 根据就诊号或账单号生成出院小结上传信息流,暂时没用
/// PAADM:就诊号,BILLNO:账单号,xjType:数据格式类型(XML,STR,JSON),ExpStr:扩展字符串
/// s CS=##class(web.INSUINFOGetUploadDetails).GetEPRSUMInfodetails("189082",224530,"XML","YB_BODY")
/// w ##class(web.INSUINFOGetUploadDetails).GetEPRSUMInfodetails("193",220801,"XML","YB_BODY")
ClassMethod GetEPRSUMInfodetails(PAADM As %String = "", BILLNO As %String = "", xjType As %String = "XML", ExpStr As %String) As %CharacterStream
{

	s objstream = ##class(%Stream.GlobalCharacter).%New()
	d objstream.Clear()
	q:PAADM="" objstream
	s hospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(PAADM)
	s AdmreasonDr=$p($g(^PAADM(PAADM,1)),"^",7)
	s InsuType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToTariType",AdmreasonDr,6)	;Zhan 20160525
	;s EPRobjlist=##class(%ListOfDataTypes).%New()
	;s EPRobjlist=##Class(RISService.InvokeRISService).HCSReportInfobyPaadmdr(PAADM)
	;s oeCount=+EPRobjlist.ReportList.Size
	;q:oeCount<1 objstream
	s rootstr=ExpStr
	s:rootstr="" rootstr="YB_BODY"	;根节点
	s HeadInfo= ##class(web.INSUINFOGetUploadDetails).GetHeadInfo(PAADM,"3304")
	s subnode=##class(web.INSUINFOParser).GetIDLIST(InsuType,"INSUEPRSUMUPLOAD",hospDR)
	s tmpoestr=""
	s tmpEPRobj=##class(web.INSUEPRInfo).%New()
	s tmpEPRobj.PAADM=PAADM
	m ^||INSUOEORDINFTOXML=^||INSUOEORDINFTOXMLOLE
	s tmpinfostr=##class(web.INSUINFOParser).GetINSUUPLOADINFTO(xjType,subnode,tmpEPRobj,"")
	d:tmpinfostr'="" objstream.Write(tmpinfostr)
	q objstream
}

/// 根据就诊号ID拼接消息头,看项目要求,可不用
/// w ##class(web.INSUINFOGetUploadDetails).GetHeadInfo("8","3302")
ClassMethod GetHeadInfo(PAADM As %String, Action As %String) As %String
{
	;s objstream = ##class(%Stream.GlobalCharacter).%New()
	;d objstream.Clear()
	;q:PAADM="" objstream

	s hIP=##CLASS(%SYS.ProcessQuery).%OpenId($J).ClientIPAddressGet()
	s InsuAdm=##class(web.DHCINSUPort).GetInsuAdmInfoByAdmDr(PAADM)
	s Time=$zt($p($h,",",2))
	
	;s TransData=##class(web.INSUINFOGetUploadDetails).GetPACSInfodetails(PAADM,220801,"XML","YB_BODY")
	
 	s input = "<?xml version="_""""_"1.0"_""""_" encoding="_""""_"UTF-8"_""""_"?>"
 	s input = input_"<MSG>"
 	s input = input_"<HEAD>"
 	s input = input_"<VER>"_"1.0"_"</VER>"            ;版本号， 中心提供
 	s input = input_"<YLJGDM>"_"106700"_"</YLJGDM>"            ;医疗机构代码
 	s input = input_"<AGENTIP>"_hIP_"</AGENTIP>"              ;操作设备IP地址
 	s input = input_"<AGENTMAC>"_"00-00-00-00-00-00"_"</AGENTMAC>"      ;操作设备MAC地址
 	s input = input_"<SHBZH>"_$p(InsuAdm,"^",34)_"</SHBZH>"          ;社会保障号
 	s input = input_"<JZWYBH>"_$p(InsuAdm,"^",10)_"</JZWYBH>"            ;就诊编号，挂号或登记时从中心获取
 	s input = input_"<XXLXM>"_Action_"</XXLXM>"          ;见消息类型
 	s input = input_"<JYSJ>"_$zd($h,8)_"/"_$p(Time,":",1)_$p(Time,":",2)_$p(Time,":",3)_"/"_"</JYSJ>"  ;交易时间（格式：年月日/时分秒/）YYYYMMDD/HHMISS/
	s input = input_"</HEAD>"
	;s input = input_TransData         ;根据消息类型，传递不同的接口内容
 	;s input = input_"</MSG>"
 	
 	;d objstream.Write(input)
	q input
}

/*
/// ?	时间日期格式A：16位
/// ?	格式：YYYYMMDD/HHNNSS/
/// ?	例如：20110401/152030，表示2011年4月1日下午15点20分30秒
/// ?	时间日期格式B：8位
/// ?	格式：YYYYMMDD
/// ?	例如：20110401，表示2011年4月1日
/// 根据就诊号ID拼接消息头
/// w ##class(web.INSUINFOGetUploadDetails).DateType("2016-08-26 08:44:24","A")
ClassMethod DateType(Str As %String, Type As %String) As %String
{
	s BackString=""
	s ^tmptmp("Str",Str)=Str
	q:Str="" BackString
	i Type="A" d
	.s Date=$p(Str," ",1)
	.s Time=$p(Str," ",2)
	.s:Time="" Time="00:00:00"
	.i $l(Time,":")="2"  s Time=Time_":00"
	.s BackString=$p(Date,"-",1)_$p(Date,"-",2)_$p(Date,"-",3)_"/"_$p(Time,":",1)_$p(Time,":",2)_$p(Time,":",3)_"/"
	
	i Type="B" d
	.s Date=$p(Str," ",1)
	.s Time=$p(Str," ",2)
	.s BackString=$p(Date,"-",1)_$p(Date,"-",2)_$p(Date,"-",3)
	
	q BackString
}

/// ///##class(web.INSUINFOGetUploadDetails).GetInfoByOEOrdItem({OEITEMID},"2")
/// w ##class(web.INSUINFOGetUploadDetails).GetInfoByOEOrdItem("188220||16","2")
ClassMethod GetInfoByOEOrdItem(OEOrdItem As %String, in As %String) As %String
{
	s BackString=""
	s ^tmptmp("OEOrdItem",OEOrdItem)=OEOrdItem
	q:OEOrdItem="" BackString
	;b ;GetInfoByOEOrdItem
	s PatBillDr=$o(^DHCPBi(0,"OEORI",OEOrdItem,""))
	
	s PaadmDr=$p($g(^DHCPB(PatBillDr)),"^",1)
	s Paadm=$g(^PAADM(PaadmDr))
	
	s InsuDivideDr="",jslsh=""
	
	s PaadmType=$p(Paadm,"^",2)
	i PaadmType="I" d
	.f  s InsuDivideDr=$o(^DHCINDIV("0","DHCPB",PatBillDr,InsuDivideDr),-1) q:InsuDivideDr=""  d
	..s InsuDivide=$g(^DHCINDIV(InsuDivideDr))
	..q:$p(InsuDivide,"^",5)'="I"
	..s jslsh=$p(InsuDivide,"^",8)
	e  d
	
	.s DHCBillConInvDr=$o(^DHCBCI(0,"Bill",PatBillDr,""))
	.s DHCBillConInv=$g(^DHCBCI(DHCBillConInvDr))
	.s DHCInvPrtDr=$p(DHCBillConInv,"^",1)
	.f  s InsuDivideDr=$o(^DHCINDIV("0","DHCInvPrt",DHCInvPrtDr,InsuDivideDr),-1)  q:InsuDivideDr=""  d
	..s InsuDivide=$g(^DHCINDIV(InsuDivideDr))
	..q:$p(InsuDivide,"^",5)'="I"
	..s jslsh=$p(InsuDivide,"^",8)
	
	s InsuAdmInfoDr="",jzlx=""
	f  s InsuAdmInfoDr=$o(^DHCINADM("0","ADM",PaadmDr,InsuAdmInfoDr),-1) q:InsuAdmInfoDr=""  d
	.s InsuAdmInfo=$g(^DHCINADM(InsuAdmInfoDr))
	.q:$p(InsuAdmInfo,"^",11)'="A"
	.i PaadmType="I" s jzlx=$p(InsuAdmInfo,"^",40)
	.e  s jzlx=$p(InsuAdmInfo,"^",14)
	.;AKA130NBA
	.s jzlx=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AKA130NBA",jzlx,7)
		
	s ordId=$p(OEOrdItem,"||",1)
	s chlsub=$p(OEOrdItem,"||",2)
	s ArcIMRowid=$p($g(^OEORD(ordId,"I",chlsub,1)),"^",2)
	s TarStr=##class(web.DHCINSUPortUse).GetTariDrByArcimRowid(ArcIMRowid,"")
	s TarConStr=##class(web.INSUTarContrastCom).GetInsuTarConInfoNBA($p(TarStr,"^",1),"NBA")
	s ConRowid="NBA"_$p($p(TarConStr,"!",2),"^",1)
		
	s BackString=jslsh_"@"_jzlx_"@"_ConRowid
		
	i in'="" d
	.s BackString=$p(BackString,"@",in)
	q BackString
}

/// w ##class(web.INSUINFOGetUploadDetails).ConString("188220||39","2")
ClassMethod ConString(Str1 As %String, Str2 As %String) As %String
{
	q Str1_Str2
}

/// w ##class(web.INSUINFOGetUploadDetails).GetAdmInfoByAdmID("189082",4)
ClassMethod GetAdmInfoByAdmID(Paadm As %String, Ind As %Integer) As %String
{
	s BackStr=""
	q:Paadm="" BackStr
	s Rtn=##class(web.DHCINSUPatInfo).GetAdmInfoByAdmID(Paadm)
	q:$p(Rtn,"!",1)'="1" BackStr
	s AdmInfo=$p(Rtn,"!",2)
	
	s BackStr= $p(AdmInfo,"^",Ind)
	q BackStr
}
*/
}
