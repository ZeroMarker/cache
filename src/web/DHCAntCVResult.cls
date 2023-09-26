/// 名称:     web.DHCAntCVResult
/// 描述:     危急报告结果
/// 编写者：  huhm
/// 编写日期: 20120710
Class web.DHCAntCVResult Extends %RegisteredObject
{

/// Creator：      huhm
/// CreatDate：    20131009
/// Description:： 保存危急值报告
/// Table：        DHC_PanicReport
/// Input：        报告类型:ReportType(1:检验,2病理,3心电,4超声,5内镜,6放射),
///                检查号:ExamNo
///                就诊号:Adm
///                医嘱ID:OEOrdId
///                报告审核信息:ReportInfo(审核日期^审核时间^审核人^审核说明^报告审核科室)
///                报告结果:Result
///                检验传过来的id：LisRowid
///                后续添加串:OtherInfo  申请人^申请日期时间^采集人^采集日期时间^接收人^接收日期时间^预警日期时间^复核人^复核日期时间^报告人^报告日期时间(审核日期时间)^标本类型^危机说明^备注     (时间格式：YYYY-MM-DD  hh:mm:ss)
/// 			   2020-07-17 TestItems		检验项目结果 $lb($lb(项目代码,项目名称,缩写,结果,单位,结果异常标志,范围,仪器,备注),$lb(项目代码,项目名称,缩写,结果,单位,结果异常标志,范围,仪器,备注))
/// Output：       
/// Return：        0:成功,失败:-1^失败原因
/// Others：      ##Class(web.DHCAntCVResult).Save(2,19,83,"61||42","2022-01-27^16:42:05^2646^恶性病变!恶性病变","ww")/// Others：      ##Class(web.DHCAntCVResult).Save(6,"CS20160122-001",1073,"988||4","2016-1-22^14:11:36^687^","ww")
ClassMethod Save(ReportType As %String, ExamNo As %String, Adm As %String, OEOrdId As %String, ReportInfo As %String, Result As %String, LisRowid As %String = "", OrderInfo As %String = "", TestItems = "") As %String
{
	s ReportType=$g(ReportType),ExamNo=$g(ExamNo),Adm=$g(Adm),OEOrdId=$g(OEOrdId),ReportInfo=$g(ReportInfo),Result=$g(Result)
	//s ^tlsj("A002")=ReportType_"!"_ExamNo_"!"_Adm_"!"_OEOrdId_"!"_ReportInfo_"!"_Result
	s ADate=$p(ReportInfo,"^",1),ATime=$p(ReportInfo,"^",2),AUser=$p(ReportInfo,"^",3)
	s Comment=$p(ReportInfo,"^",4)

	s Comment=$tr(Comment,"\",""),OrderInfo=$tr(OrderInfo,"\","")  //由于storage的分隔符时反斜杠,所以要去除\  2019-1-31
	
	i '$l(OEOrdId) q "-1^医嘱ID为空"
	i '$l(ExamNo) q "-1^检查号为空"
	i '$l(AUser) q "-1^审核人为空"
	i '$l(Result)&&(ReportType'=1) q "-1^结果为空"
	/*
	s OrdId=$p(OEOrdId,"||",1),OrdSub=$p(OEOrdId,"||",2)
	i '$l(OrdId) q "-1^医嘱ID非法"
	i '$l(OrdSub) q "-1^医嘱ID非法"
	i '$d(^OEORD(OrdId,"I",OrdSub)) q "-1^医嘱ID不存在"*/
	s checkOrd= ..CheckOrdItems(OEOrdId) //支持多个医嘱ID 合管医嘱 2019-07-25
	if checkOrd'=1 q "-1^"_checkOrd
	
	if Adm="" s Adm=$p(^OEORD(+OEOrdId),"^",1) //就诊ID为,根据医嘱取
	

	i '$l(ADate) q "-1^审核日期为空"
	i '$l(ATime) q "-1^审核时间为空"
	if ADate["-" s ADate=$zdh(ADate,3),ATime=$zth(ATime,1)	
	k PLIST
	s ExamNo=$replace(ExamNo,"||","--") //$tr(ExamNo,"||","-") //改为只转双竖线
	s order=+$o(^DHCAntCVReport(ReportType,ExamNo,""),-1)+1
	
	s ReportDate=ADate,ReportTime=ATime
	s nowDateTime=$h,ADate=+nowDateTime,ATime=+$p(nowDateTime,",",2) //原日期时间字段记录系统当前日期时间 新增报告日期时间字段存储传过来的日期时间 cryze 2020-05-29
	
	s ReportLoc=$tr($p(ReportInfo,"^",5),"\") //增加报告科室字段 用于记录报告科室 有时直接使用医嘱接收科室不准确
	if ReportLoc'="",'$d(^CTLOC(ReportLoc)) s ReportLoc="^"_ReportLoc
	s ReportTel=$tr($p(ReportInfo,"^",6),"\") //报告电话
	s AdmLoc=$p(^PAADM(Adm),"^",4)
	s PatientID=$p(^PAADM(Adm),"^",1)
	s Ward=$p(^PAADM(Adm),"^",70)
	s AdmDoc=$p(^PAADM(Adm),"^",9)
	
  	TS
  	&SQL(insert into SQLUser.DHC_AntCVReport set DPRP_LabNo=:ExamNo,DPRP_Order=:order,DPRP_Date=:ADate,DPRP_Time=:ATime,
  		DPRP_UserDR=:AUser,DPRP_Adm=:Adm,DPRP_Comment=:Comment,DPRP_Status="C",DPRP_Type=:ReportType,DPRP_Result=:Result,
  		DPRP_OEOrdItemID=:OEOrdId,DPRP_LisExamRowid=:LisRowid,DPRP_OtherInfo=:OrderInfo,
  		DPRP_ReportDate=:ReportDate,DPRP_ReportTime=:ReportTime,DPRP_ReportLoc=:ReportLoc,DPRP_ReportTel=:ReportTel,
  		DPRP_IsEnd=0,DPRP_PatientID=:PatientID,DPRP_OriginalLoc=:AdmLoc,DPRP_OriginalWard=:Ward,DPRP_FinalAdm=:Adm,DPRP_FinalLoc=:AdmLoc,DPRP_FinalWard=:Ward,
  		DPRP_OriginalDoc=:AdmDoc)
  	i SQLCODE {
	  	//q "-1^"_SQLCODE_$s('SQLCODE:"",SQLCODE'=100:" "_$g(%msg)_" "_$g(%mdiag(1)),1:"") 
	  	//TRO
	  	s errRet="-1^"_SQLCODE_$s('SQLCODE:"",SQLCODE'=100:" "_$g(%msg)_" "_$g(%mdiag(1)),1:"")
	  	tro
	  	q errRet  //先回滚 再q 2019-1-31
	}
  	TC
  	
  	s reportID=%ROWID
	d ..SaveTestItems(reportID,TestItems) //保存项目表
	
	//新电子病历发送信息 2021-04-13
	d ..SaveEMREventData(reportID,Adm,Result,ADate,ATime,OEOrdId)
  	
  	//2016-5-11统一封装处理对外消息
  	//s ^tempAntDatalsj("1")=%ROWID_"!"_Adm_"!"_AUser_"!"_OEOrdId
  	d ##class(web.DHCAntCVSend).SendAntCVInfo(reportID,Adm,AUser,OEOrdId)
  	
  	d ..RefreshRepLocData(OEOrdId,ReportLoc)
  	
	//新电子病历发送信息
	//
	//s rtn=..InterfaceForEMR(ExamNo,OEOrdId,ADate,ATime,ReportType,order)
	
	
	q SQLCODE
}

/// 刷新报告科室数据  
/// 危急值产生后，将报告科室数据存到User.DHCAntCVOptions中去
ClassMethod RefreshRepLocData(OEOrdId, ReportLoc = "")
{
	s code="",desc=""
	if ReportLoc'="" {
		if $p(ReportLoc,"^",1)'="" {
			s code=$p(ReportLoc,"^",1)
		}elseif $p(ReportLoc,"^",2)'="" {
			s code=$p(ReportLoc,"^",2)
		}
	}
	if code="" {  //字段取不到 取医嘱接收科室
		s code=$p($g(^OEORD(+OEOrdId,"I",+$p(OEOrdId,"||",2),3)),"^",6)
	}
	
	s ret=0
	
	if code'="" {
		if $d(^CTLOC(code)) s desc=$p(^CTLOC(code),"^",2)
		else  s desc=code
		
		if ##class(web.DHCAntCVOptions).GetValue("RepLocData",code)="" {
			
			d ##class(web.DHCAntCVOptions).Save("RepLocData",code,desc,$s(code=desc:"未获取到科室ID",1:""),"")	
			s ret="1^"_code_"^"_desc
		}
	}
	q ret
}

/// 向病历插入危急值事件
ClassMethod SaveEMREventData(reportID, Adm, Result, ADate, ATime, OEOrdId)
{
	
	//d ##Class(EMRservice.HISInterface.Event.CriticalValue).SetDataByReport(APatientID , AEpisodeID, AFromCode , AContent , AReportDate , AReportTime)
	s ordDesc=##class(web.DHCAntCVReportSearch).GetOrdItems(OEOrdId,",","+")
	s PatientID=$p(^PAADM(Adm),"^",1)
	s ret= ##Class(EMRservice.HISInterface.Event.CriticalValue).SetDataByReport(PatientID,Adm,reportID,Result,ADate,ATime,ordDesc)
	//s ^cryze("emr")=$lb(PatientID,Adm,reportID,Result,ADate,ATime,ordDesc,ret)
	q ret
}

/// $lb($lb(项目代码,项目名称,缩写,结果,单位,结果异常标志,范围,仪器,备注),$lb(项目代码,项目名称,缩写,结果,单位,结果异常标志,范围,仪器,备注))
ClassMethod SaveTestItems(reportID, TestItems = "")
{
	s $zt="SaveTestItemsErr"
	s ret=""
	
	q:TestItems="" "-1^TestItems为空"
	q:'$lv(TestItems) "-1^TestItems不是正确的list格式"
	
	q:($p(reportID,"||",1)="")||($p(reportID,"||",2)="")||($p(reportID,"||",3)="")||'$d(^DHCAntCVReport($p(reportID,"||",1),$p(reportID,"||",2),$p(reportID,"||",3))) "-1^reportID="_reportID_"不正确"
	s len=$ll(TestItems)
	for i=1:1:len{
		s item=$lg(TestItems,i)
		continue:(item="")||('$lv(item)) //元素也要是list格式
		
		s code=$lg(item,1)
		continue:(code="")||$d(^DHCAntCVReport($p(reportID,"||",1),$p(reportID,"||",2),$p(reportID,"||",3),"TC",code)) //代码为空 或此代码已存在
		s obj=##class(User.DHCAntCVReportItems).%New()
		d obj.DPRIParRefSetObjectId(reportID)
	
		s obj.DPRITestCodeDR=code //代码   做id
		s obj.DPRITestName=$lg(item,2)  //名称
		s obj.DPRIEngName=$lg(item,3)  //简称
		s obj.DPRIResult=$lg(item,4)  //结果
		s obj.DPRIUnit=$lg(item,5)  //单位
		s obj.DPRIFlag=$lg(item,6)  //结果异常标注
		s obj.DPRIRefRanges=$lg(item,7)  //范围
		s obj.DPRIMachine=$lg(item,8)  //仪器
		s obj.DPRIComment=$lg(item,9)  //备注
		s sc=obj.%Save()
		if $$$ISERR(sc){
			s ret=$system.Status.GetErrorText(sc)	
		}
		s obj=""
		
	}
	q 1
SaveTestItemsErr
	q "-1^"_$ze
}

ClassMethod GetRepResult(reportID, hideRange = 0)
{
	s repType=$p(reportID,"||",1),repLabno=$p(reportID,"||",2),repOrder=$p(reportID,"||",3)
	s repResult=""
	s code="",ind=1
	for {
		s code=$o(^DHCAntCVReport(repType,repLabno,repOrder,"TC",code))
		q:code=""
		s itemInfo=^DHCAntCVReport(repType,repLabno,repOrder,"TC",code)
		s TestName=$p(itemInfo,"\",8)
		s TestResult=$p(itemInfo,"\",2)
		s TestUnit=$p(itemInfo,"\",3)
		s TestRange=$p(itemInfo,"\",5)
		if $e(TestUnit,1)>0 s TestUnit="*"_TestUnit
		
		if hideRange=1{
			s itemStr="项目名称："_TestName_" 结果："_TestResult_TestUnit
		}else {
			s itemStr="项目名称："_TestName_" 结果："_TestResult_TestUnit_" 参考范围："_TestRange_TestUnit
		}
		if ind=1 s repResult=itemStr
		else  s repResult=repResult_"、"_itemStr
		s ind=ind+1
	}
	if repResult="" s repResult=$g(^DHCAntCVReport(repType,repLabno,repOrder,"Result"))
	q repResult
}

/// creator   ： shp
/// CreateDate: 2015-9-26
/// Input:      APatientID 病人ID
///              AEpisodeID 就诊号
///             ALabNo 标本号
///             AValue  危机值
///             ADesc 危机值描述
///             AValueDate(cache内部格式) 报告日期
///             AValueTime(cache内部格式) 报告时间
///             AOEordItemID 医嘱ID
///             AOEordItemDesc 医嘱描述
///             AItemRanges 值范围
///             AItemUnit 单位
/// Output:     result 1成功 0失败
ClassMethod InterfaceForEMR(ExamNo, OEOrdId, ADate, ATime, RptType, order)
{
	s ret=0
	s oe=+OEOrdId
	s chl=$P(OEOrdId,"||",2)
	s adm=$p(^OEORD(oe),"^",1)
	s patientID=$p(^PAADM(adm),"^",1)
	S ArcIm=$p(^OEORD(oe,"I",chl,1),"^",2)
	S orderName=$p(^ARCIM(+ArcIm,$P(ArcIm,"||",2),1),"^",2)
	if RptType=1 {
		Set Config=##Class(websys.Configuration).%OpenId(1)
		Set LabData=Config.LabDataNamespace
		If '$Length(LabData) Set LabData="labdata"
		for {
			s tc=$o(^[LabData]DHCPanicReport(RptType,ExamNo,order,"TC",tc))  
			q:tc=""
			s TestItem=$p(^TTAB("TC",tc),"\",1)
			s value=$P(^[LabData]DHCPanicReport(RType,spis,ord,"TC",tc),"\",2)
			s Unit=$p(^[LabData]DHCPanicReport(RType,spis,ord,"TC",tc),"\",3)
			s Ranges=$p(^[LabData]DHCPanicReport(RType,spis,ord,"TC",tc),"\",5)   //(1,2)标准参考范围，(3,4)危急值参考范围
			i Ranges[$C(3){
				S RangeStart=$p(Ranges,$C(3),1)  
				S RangeEnd=$p(Ranges,$C(3),2) 
				
				i (RangeStart="")&&(RangeEnd="") s Ranges=""
				e  i (RangeStart'="")&&(RangeEnd="") s Ranges=RangeStart
				e  i (RangeStart="")&&(RangeEnd'="") s Ranges=RangeEnd
				e  s Ranges=RangeStart_"-"_RangeEnd
			}
			s ret=##Class(EMRservice.BL.Event.BLCriticalValue).SetData(patientID,adm,ExamNo,TestItem,value,ADate,ATime,OEOrdId,orderName,Ranges,Unit)
		}
	}else {
		s ret=##Class(EMRservice.BL.Event.BLCriticalValue).SetData(patientID,adm,ExamNo,"","",ADate,ATime,OEOrdId,orderName,"","")
	}
	q ret
}

/// Creator：      huhm
/// CreatDate：    20120715
/// Description:： 根据检验号查询危急报告结果
/// Table：        DHC_PanicReport,DHC_PanicReportItems
/// Input：        检验号
/// Output：       报告时间,报告用户,说明,项目,结果,异常标记,单位,参考范围,ROWID
/// Return：        
/// Others：        其它说明
Query GetPanicResult(LabEpis As %String) As %Query(ROWSPEC = "ReportTime:%String,ReportUser:%String,Remark:%String,TestItem:%String,Result:%String,Flag:%String,Unit:%String,Ranges:%String,RowId:%String")
{
}

ClassMethod GetPanicResultExecute(ByRef qHandle As %Binary, LabEpis As %String) As %Status
{
 	Set LabEpis=$Get(LabEpis)
 	s ^TMPADM=LabEpis
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set LabData=Config.LabDataNamespace
	If '$Length(LabData) Set LabData="labdata"
	If '$Length(LabEpis) Set qHandle=$lb(0,repid,0)	 Quit $$$OK
	s RType=1
	//
	s ord="" f  s ord=$o(^[LabData]DHCPanicReport(RType,LabEpis,ord)) q:ord=""  d
	.s RDate=$p(^[LabData]DHCPanicReport(RType,LabEpis,ord),"\",1)
	.s RTime=$p(^[LabData]DHCPanicReport(RType,LabEpis,ord),"\",2)
	.s RUser=$p(^[LabData]DHCPanicReport(RType,LabEpis,ord),"\",3)
	.s ReptTime="",ReptUser=""
	.i $l(RDate),$l(RTime) s ReptTime=$zd(RDate,3)_" "_$zt(RTime)
	.i $l(RUser) s ReptUser=$p(^[LabData]SSU("SSUSR",1,RUser),"^",2)
	.s tc="" f  s tc=$o(^[LabData]DHCPanicReport(RType,LabEpis,ord,"TC",tc)) q:tc=""  d
	..s TestItem=$p(^TTAB("TC",tc),"\",1)
	..s Result=$P(^[LabData]DHCPanicReport(RType,LabEpis,ord,"TC",tc),"\",2)
	..s Flag=$p(^[LabData]DHCPanicReport(RType,LabEpis,ord,"TC",tc),"\",3)
	..s Unit=$p(^[LabData]DHCPanicReport(RType,LabEpis,ord,"TC",tc),"\",4)
	..s Ranges=$p(^[LabData]DHCPanicReport(RType,LabEpis,ord,"TC",tc),"\",5)
	..s RowId=LabEpis_"||"_ord
	..d OutputRow
	//
	Set qHandle=$lb(0,repid,0)	
	Quit $$$OK
OutputRow
	set Data=$lb(ReptTime,ReptUser,$g(Remark),TestItem,Result,$g(Flag),$g(Unit),$g(Ranges),RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPanicResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPanicResultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPanicResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPanicResultExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// creator   :  shp
/// description : 给Lis提供插入DHC_AntCVReportItems表中数据方法
/// input     ：  ParRef： 危急值表ID
/// 				 tc    :  项目
///              TCStr ： 插入信息
/// debug     :w ##class(web.DHCAntCVResult).SaveItems("1||100047||1",tc,"WBC\3.00\10~9/L\RU\100.00"_$c(3)_"300.00"_$c(3)_"50.00"_$c(3)_"400.00"_$c(3,3,3,3,3,3)_"\CD-1700三分类血液分析仪\")
ClassMethod SaveItems(ParRef, tc, TCStr) As %String
{
	s sync=$p(TCStr,"\",1)
	s res=$p(TCStr,"\",2)
	s unit=$p(TCStr,"\",3)
	s flag=$p(TCStr,"\",4)
	s rang=$p(TCStr,"\",5)
	s mi=$p(TCStr,"\",6)
	s com=$p(TCStr,"\",7)
	k PLIST
	s PLIST(0)=ParRef
	s PLIST(2)=tc
	s PLIST(3)=sync
	s PLIST(4)=res
	s PLIST(5)=unit
	s PLIST(6)=flag
	s PLIST(7)=rang
	s PLIST(8)=mi
	s PLIST(9)=com
  	TS
  	&SQL(insert into SQLUser.DHC_AntCVReportItems values :PLIST())
  	i SQLCODE {
	  	q "-1^"_SQLCODE_$s('SQLCODE:"",SQLCODE'=100:" "_$g(%msg)_" "_$g(%mdiag(1)),1:"") 
	  	TRO
	}
  	TC
	q SQLCODE
}

/// Creator:		cryze
/// CreatDate:		2019-07-25
/// Description:	校验医嘱ID是否正确
/// Table:			被访问的表（此项仅对于牵扯到数据库操作的程序
/// Input:			ordIds 医嘱ID 多个以英文,分隔
/// Return:			正确1  错误返回说明
ClassMethod CheckOrdItems(ordIds = "")
{
	s flag=1,oneOrdPar="",msg=""
	for i=1:1:$l(ordIds,",") {
		s ordId=$p(ordIds,",",i)
		s ordPar=$p(ordId,"||",1)
		s ordSub=$p(ordId,"||",2)
		if oneOrdPar="" s oneOrdPar=ordPar
		if (ordId="")||(ordPar="") s flag=0,msg="存在空医嘱ID" q
		if '$d(^OEORD(ordPar,"I",ordSub)) s flag=0,msg="存在非法医嘱ID"_ordId q
		if oneOrdPar'=ordPar s flag=0,msg="多个医嘱ID的主表ID不一致" q
		
	}
	if flag q 1
	else  q msg
}

/// 当保存危急值病程时 病历组调用危急值接口保存关联关系 此时也可以对危急值做点事情
ClassMethod OnSaveEMR(reportID, userid)
{
	s $zt="OnSaveEMRErr"
	q 1
OnSaveEMRErr
	q "-1^"_$ze
}

}
