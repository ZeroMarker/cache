Class DHCLIS.DHCLISInterface Extends %RegisteredObject
{

// 通过入参为c_patient_id(登记号)与c_visit_id（就诊号）查询并反馈病人在我们系统中产生的申请号（testno），报告项目代码（itemno），报告项目名称(itemname)，检验结果(testresult)，检验医生(testman),检测仪器(instrument),结果标志(resultflag：H＝偏高、M=正常、L＝偏低、P＝阳性、Q＝弱阳性、N=阴性、E＝错误),单位(units(菌，药)),参考范围(ranges),结果时间(resulttime),申请项目代码(sqxmdh),申请项目名称(sqxmmc),样本类型(yblx),采样时间(cysj)

/// Creator：      SZW
/// CreatDate：    20170406
/// Description:： 根据登记号、就诊号查询检验相关信息
/// Table：        
/// Input：        
/// Output：        医院代码,登记号,就诊号,医嘱RowID
/// 					报告项目代码 报告项目名称,检验结果 检验医生 检测仪器 结果标志：H＝偏高、M=正常、L＝偏低、P＝阳性、Q＝弱阳性、N=阴性、E＝错误
///    				单位(菌，药) 参考范围 结果时间 申请项目代码 申请项目名称 样本类型 采样时间
/// Return：       
/// Others：  
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCLISInterface","QryLisResultList","","","223")
Query QryLisResultList(CTHosp As %String, InPatNo As %String, Adm As %String) As %Query(ROWSPEC = "HospitalCode,InPatNo,Adm,OrdRowId,TestCodeCode,TestCodeName,TextResult,AcceptUser,MachineParameterDesc,ResultFalg,Unit,RefRanges,AuthDateTime,labno,OrdNames,SpecName,SpecDateTime") [ SqlName = mdc2_mz_lab_view, SqlProc ]
{
}

ClassMethod QryLisResultListExecute(ByRef qHandle As %Binary, CTHosp As %String, InPatNo As %String, Adm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
	k ^TMP($zn,$i,$j)
 	
 	;病人ID（病人卡号）门诊号 申请号 报告项目代码 报告项目名称
    ;检验结果 检验医生 检测仪器 结果标志：H＝偏高、M=正常、L＝偏低、P＝阳性、Q＝弱阳性、N=阴性、E＝错误
    ;单位(菌，药) 参考范围 结果时间 申请项目代码 申请项目名称
    ;样本类型 采样时间
    
    i $l(Adm) d GetOrderByEpisode(Adm)

	i '$l(Adm),$l(InPatNo) d
	.s type="" f  s type=$o(^PAPERdr(InPatNo,"ADM",type)) q:type=""  d
	..s ADMId="" f  s ADMId=$o(^PAPERdr(InPatNo,"ADM",type,ADMId),-1) q:ADMId=""  d
	...s AdmLoc=$p(^PAADM(ADMId),"^",4)
	...s AdmDate=$p(^PAADM(ADMId),"^",6)
	...d GetOrderByEpisode(ADMId)
    
    s num=0
	s labno="" f  s labno=$o(^TMP($zn,$i,$j,"LabNo",labno),-1) q:labno=""  d
	.s ItmStat="" f  s ItmStat=$o(^TMP($zn,$i,$j,"LabNo",labno,ItmStat)) q:ItmStat=""  d
	..s WorkGroupMachineDR="" f  s WorkGroupMachineDR=$o(^TMP($zn,$i,$j,"LabNo",labno,ItmStat,WorkGroupMachineDR)) q:WorkGroupMachineDR=""  d
	...s (OrdRowIds,OrdNames,ReqDateTime,ResultStatus,StatusDesc,LabEpisode,LabTestSetRow,SpecName,SpecDateTime,RecDateTime,AuthDateTime,ReportFlag,TransComm,TSResultAnomaly,TSMemo,EpisodeNo,AdmDate,AdmLoc,AdmType,ReadFlag,ReceiveNotes,MajorConclusion,PlacerNo)=""
	...s OrdRowId="" f  s OrdRowId=$o(^TMP($zn,$i,$j,"LabNo",labno,ItmStat,WorkGroupMachineDR,OrdRowId)) q:OrdRowId=""  d
	....s OrdId=$p(OrdRowId,"||",1),SubId=$p(OrdRowId,"||",2)
	....s stat=$p(^OEORD(OrdId,"I",SubId,1),"^",13)
	....q:stat=4	//停止
	....q:stat=2	//作废
	....q:stat=12	//撤销
	....s LabEpisode=labno
	....//取状态描述
	....s stdesc="" f  s stdesc=$o(^OEC("OSTAT",0,"Desc",stdesc)) q:stdesc=""  d
	.....s curst="" f  s curst=$o(^OEC("OSTAT",0,"Desc",stdesc,curst)) q:curst=""  d
	......i curst=stat s StatusDesc=stdesc
	....//病人所属医院
	....s Adm=$p(^OEORD(OrdId),"^",1),locCode="",HospID="",HospitalCode="",AdmLoc=""
	....i $l(Adm),$d(^PAADM(Adm)) s locCode=$p(^PAADM(Adm),"^",4)
	....i $l(locCode) s HospID=$p(^CTLOC(locCode),"^",22),AdmLoc=$p(^CTLOC(locCode),"^",2)
	....i AdmLoc["-" s AdmLoc=$p(AdmLoc,"-",2)
	....i $l(HospID) s HospitalCode=$p(^CT("HOSP",HospID),"^",1)
	....//就诊日期
	....s AdmDate=$p(^PAADM(Adm),"^",6)
	....i $l(AdmDate) s AdmDate=$zd(AdmDate,3)
	....s AdmType=$p(^PAADM(Adm),"^",2)
	....i AdmType="O" s AdmType="门诊"
	....i AdmType="I" s AdmType="住院"
	....i AdmType="E" s AdmType="急诊"
	....i AdmType="H" s AdmType="体检"
	....s OrdStr1=$g(^OEORD(OrdId,"I",SubId,1))
	....s OrdStr3=$g(^OEORD(OrdId,"I",SubId,3))
	....s ItmMastDr=$p(OrdStr1,"^",2)
	....s OrdName=$p($g(^ARCIM(+ItmMastDr,$p(ItmMastDr,"||",2),1)),"^",2)
	....i $l(OrdRowIds) s OrdRowIds=OrdRowIds_","_OrdRowId
	....e  s OrdRowIds=OrdRowId
	....i $l(OrdNames) s OrdNames=OrdNames_"+"_OrdName
	....e  s OrdNames=OrdName
	....//申请日期时间
	....s ReqDate=$p(OrdStr3,"^",7)
	....s ReqTime=$p(OrdStr1,"^",17)
	....s OGTTGroupReqDate=ReqDate
	....i $l(ReqDate) s ReqDate=$zd(ReqDate,3)
	....i $l(ReqTime) s ReqTime=$zt(ReqTime)
	....s ReqDateTime=ReqDate_" "_ReqTime
	....s LabTestSetRow=$p(OrdStr3,"^",35)
	....s LabTestSetRow=$tr(LabTestSetRow,$c(0))
	....//标本类型
	....s SpecDr=$o(^OEORD(OrdId,"I",SubId,"SPEC",""),-1)
	....s (SpecCode,SpecName)=""
	....i $l(SpecDr) s SpecCode=$p(^OEORD(OrdId,"I",SubId,"SPEC",SpecDr),"^",1)
	....i $l(SpecCode) s SpecName=$p(##Class(DHCLIS.DHCCommon).GetSpecimen(SpecCode,HospitalCode),$c(2),2)
	....//采集日期时间Collection
	....s (SpecDate,SpecTime)=""
	....s retval=##Class(web.DHCNurSpecerNo).GetspecCollDatetime(OrdRowId)
	....i $l(retval) d
	.....s SpecDate=$p(retval,"^",2)
	.....i $l(SpecDate) s SpecDate=$zd(SpecDate,3)
	.....s SpecTime=$p(retval,"^",3)
	.....i $l(SpecTime) s SpecTime=$zt(SpecTime)
	....s SpecDateTime=SpecDate_" "_SpecTime
	....//接收日期
	....s VisitNumberDR=$g(^TMP($zn,$i,$j,"LabNo",labno,ItmStat,WorkGroupMachineDR,OrdRowId))
	....s VisitNumberReportDR="",TSMemo="",PrintFlag=""
	....i $l(VisitNumberDR) d
	.....s RecDate=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),66)
	.....s RecTime=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),67)
	.....i $l(RecTime) s RecTime=$zt(RecTime)
	.....i $l(RecDate) s RecDateTime=$e(RecDate,1,4)_"-"_$e(RecDate,5,6)_"-"_$e(RecDate,7,8)_" "_RecTime
	.....///审核日期
	.....s Order="" f  s Order=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,Order)) q:Order=""  d
	......s VisitNumberReportDR=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,Order,""))
	......s AuthDate=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),19)
	......s AuthTime=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),20)
	......i $l(AuthTime) s AuthTime=$zt(AuthTime)
	......i $l(AuthDate) s AuthDateTime=$e(AuthDate,1,4)_"-"_$e(AuthDate,5,6)_"-"_$e(AuthDate,7,8)_" "_AuthTime
	......//核收者
	......s AcceptUserDR=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),11),AcceptUser=""
	......i $l(AcceptUserDR) s AcceptUser=$lg($g(^dbo.SYSUserD(AcceptUserDR)),3)
	......//审核者
	......s AuthUserDR=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),21),AuthUser=""
	......i $l(AuthUserDR) s AuthUser=$lg($g(^dbo.SYSUserD(AuthUserDR)),3)

	......s ResultStatus=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),22)   //(1登记，2初审，3审核，4复查，5取消审核，6作废，O其他)  报告状态
	......i ResultStatus'=3 q
	......//查询报告结果
	......s TestCodeDR=""  f  s TestCodeDR = $o(^dbo.RPVisitNumberReportResultI("IndexReportItem",VisitNumberReportDR,TestCodeDR))  q:TestCodeDR=""  d
	.......s ResultDR = $o(^dbo.RPVisitNumberReportResultI("IndexReportItem",VisitNumberReportDR,TestCodeDR,""))
	.......s TestCodeData = $g(^dbo.BTTestCodeD(TestCodeDR))
	.......//报告项目代码 报告项目名称
	.......s TestCodeCode = $lg(TestCodeData,2) s TestCodeName = $lg(TestCodeData,3)
	.......s ResultData = $g(^dbo.RPVisitNumberReportResultD(ResultDR))
	.......//;检验结果
	.......s TextResult=$lg(ResultData,5)
	.......s RefRanges = $lg(ResultData,12) //参考范围
	.......s MachineParameterDR =$lg(ResultData,14),MachineParameterDesc=""
	.......i $l(MachineParameterDR) s MachineParameterDesc=$lg($g(^dbo.BTMIMachineParameterD(MachineParameterDR)),3)
	.......s AbFlag=$lg(ResultData,9),ResultFalg=""
	.......i AbFlag="" s ResultFalg="M"
	.......i AbFlag="H" s ResultFalg="H"
	.......i AbFlag="L" s ResultFalg="L"
	.......i TextResult="阳性" s ResultFalg="P"
	.......i TextResult="弱阳性" s ResultFalg="Q"
	.......i TextResult="阴性" s ResultFalg="N"
	.......i TextResult="错误" s ResultFalg="E"
	.......s Unit=$lg(ResultData,11)
	.......s Data = $lb(HospitalCode,InPatNo,Adm,OrdRowId,TestCodeCode,TestCodeName,TextResult,AcceptUser,MachineParameterDesc,ResultFalg,Unit,RefRanges,AuthDateTime,labno,OrdNames,SpecName,SpecDateTime)
	.......d OutputRow

	k ^TMP($zn,$i,$j)
	
 	Set qHandle=$lb(0,repid,0)
    q $$$OK
 	
GetOrderByEpisode(EpisodeNo)
	s OrdId=""  f  s OrdId=$o(^OEORD(0,"Adm",EpisodeNo,OrdId)) q:OrdId=""  d
	.s SubId=""	f  s SubId=$o(^OEORD(OrdId,"I",SubId),-1) q:SubId=""  d
	..s OrdRowId=OrdId_"||"_SubId
	..s OrdStr1=$g(^OEORD(OrdId,"I",SubId,1))
	..s OrdStr3=$g(^OEORD(OrdId,"I",SubId,3))
	..s ItmMastDr=$p(OrdStr1,"^",2)
	..i '$l(ItmMastDr) q
	..i '##Class(web.DHCLabOrder).isLabTS(ItmMastDr) q
	..s OrdName=$p($g(^ARCIM(+ItmMastDr,$p(ItmMastDr,"||",2),1)),"^",2)
	..//检验号
	..s LabEpisode=$p(OrdStr3,"^",20)
	..i '$l(LabEpisode) q
	..//报告ID
	..s LabTestSetRow=$p(OrdStr3,"^",35)
	..s LabTestSetRow=$tr(LabTestSetRow,$c(0))
	..s ItmStat=$p(OrdStr1,"^",13)
	..i '$l(ItmStat) q
	..s WorkGroupMachineDR=""
	..s VisitNumberDR=$o(^dbo.RPVisitNumberI("IndexVisitNumber",##Class(LIS.Util.Common).IndexData(LabEpisode),""))
	..i $l(LabTestSetRow) s WorkGroupMachineDR=$lg($g(^dbo.RPVisitNumberTestSetD(LabTestSetRow)),5)
	..i '$l(WorkGroupMachineDR) q
	..s ^TMP($zn,$i,$j,"LabNo",LabEpisode,ItmStat,WorkGroupMachineDR,OrdRowId)=VisitNumberDR
	q
	
OutputRow
	set ColFields=""
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QryLisResultListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLisResultListExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLisResultListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLisResultListExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      SZW
/// CreatDate：    
/// Description:：根据检验号获取标本是否拒收
/// Table：        
/// Input：        检验号
/// Return：       是否拒收  1已拒收 0未拒收 2未接收
/// w ##CLASS(DHCLIS.DHCLISInterface).GetIsReject(1707190001)
ClassMethod GetIsReject(Visitnumber)
{
	s VisitNumberDR=$o(^dbo.RPVisitNumberI("IndexVisitNumber",##Class(LIS.Util.Common).IndexData(Visitnumber),""))
	i '$l(VisitNumberDR) q 2
	i '$d(^dbo.RPVisitNumberRecordI("IndexMaster",VisitNumberDR)) q 0
	s OutStorageType = $lg(^dbo.RPVisitNumberD(VisitNumberDR),77)
	i OutStorageType'=3 q 0
	q 1
}

/// Creator：      SZW
/// CreatDate：    20150127
/// Description:： 查询未及时阅读的报告 ，急查出报告后半小时内未及时阅读的、其他检验24小时未及时阅读的
/// Table：        
/// Input：        
/// Output：       
/// Return：       
/// Others：  
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCLISInterface","QryUnReadedReport","2017-01-01","2018-01-31","","","","","","","","","","",20,1,"106^10^^13^1")
Query QryUnReadedReport(fSttDate, fEndDate, fLocationDR, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "ReportDR,Labno,SurName,TestSetDesc,Doctor,Location,Ward,BedNo,patAge,AuthDate,AuthTime,AuthUser,patSex,Urgent")
{
}

ClassMethod QryUnReadedReportExecute(ByRef qHandle As %Binary, fSttDate, fEndDate, fLocationDR, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
	//Session数据
	Set UserID=$p(Sessions,"^",1),WorkGroupDR=$p(Sessions,"^",2),HospitalDR=$p(Sessions,"^",5),LocationDR=$p(Sessions,"^",3)
    //总数与分页
	s RowCount=0
 	s PageSize=+$g(PageSize),PageIndex=+$g(PageIndex),ToRow=0,FormRow=0
 	i PageIndex>0,PageSize>0 s ToRow=PageIndex*PageSize,FormRow=ToRow-PageSize+1
 	
	s fSttDate = $tr(fSttDate,"-","") s fEndDate= $tr(fEndDate,"-","")

	i ('$ISVALIDNUM(fSttDate)||'$ISVALIDNUM(fEndDate)) goto END
	i fEndDate<fSttDate goto END
	s CurrentDate = $tr($ZD($h,3),"-")
	s CurrentTime = $p($h,",",2)
	
	s AuthDate = fSttDate-1
	
	for {
		s AuthDate = AuthDate+1
		q:AuthDate>fEndDate
		s fWorkGroupMachineDR=""
		for {
			s fWorkGroupMachineDR = $o(^dbo.RPVisitNumberReportI("IndexAuthDate",fWorkGroupMachineDR))
			q:fWorkGroupMachineDR=""
			i '$d(^dbo.RPVisitNumberReportI("IndexAuthDate",fWorkGroupMachineDR,AuthDate)) continue
			s ReportDR=""
			for {
				s ReportDR = $o(^dbo.RPVisitNumberReportI("IndexAuthDate",fWorkGroupMachineDR,AuthDate,ReportDR))
				q:ReportDR=""
				s AuthDate=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),19)
			    s AuthTime=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),20)
			    s ReportReaded = $lg($g(^dbo.RPVisitNumberReportD(ReportDR)),31)
			    i ReportReaded=1 continue
			    //判断是否超时
				s VisitNumberDR=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),2)
				s RPVisitNumberData = $g(^dbo.RPVisitNumberD(VisitNumberDR))
				s AdmissionTypeDR = $lg(RPVisitNumberData,4)
  				s Labno=$lg(RPVisitNumberData,2)
  				s WorkGroupMachineDR=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),4)
  				s TestSetDesc=""
			    s TestSetDR="" f  s TestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",VisitNumberDR,TestSetDR)) q:(TestSetDR="")  d
			   .i '$d(^dbo.RPVisitNumberTestSetI("IndexReportID",ReportDR,TestSetDR)) Q
			   .s VSRowID=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",VisitNumberDR,TestSetDR,""))
			   .s tWorkGroupMachineDR=$LG($G(^dbo.RPVisitNumberTestSetD(VSRowID)),5)
			   .i tWorkGroupMachineDR'=WorkGroupMachineDR q
			   .i $l(TestSetDesc) s TestSetDesc=TestSetDesc_"+"_$lg(^dbo.BTTestSetD(TestSetDR),3)
  			   .e  s TestSetDesc=$lg(^dbo.BTTestSetD(TestSetDR),3)
  			   s SurName=$lg(RPVisitNumberData,13)
			   s GivenName=$lg(RPVisitNumberData,14)
			   i SurName=GivenName s PatName=SurName
			   e  s PatName=SurName_GivenName
			   s SpeciesDR=$lg(RPVisitNumberData,15),patSex=""
			   i $l(SpeciesDR) s patSex=$lg($g(^dbo.BTSpeciesD(SpeciesDR)),3)
			   s BirthDate=$lg(RPVisitNumberData,16)
			   s Age=$lg(RPVisitNumberData,18)
			   s AgeUnitDR=$lg(RPVisitNumberData,19),AgeUnit=""
			   i $l(AgeUnitDR) s AgeUnit=$lg($g(^dbo.BTAgeUnitD(AgeUnitDR)),3)
			   s patAge=Age_AgeUnit
			   s LocationDR=$lg(RPVisitNumberData,22),Location=""
			   i $l(fLocationDR),(fLocationDR'=LocationDR) continue
			   i $l(LocationDR) s Location=$lg($g(^dbo.BTLocationD(LocationDR)),3)
			   i Location["-" s Location=$p(Location,"-",2)
			   s WardDR=$lg(RPVisitNumberData,26),Ward=""
			   i $l(WardDR) s Ward=$lg($g(^dbo.BTWardD(WardDR)),3)
			   i Ward["-" s Ward=$p(Ward,"-",2)
			   s BedNo=$lg(RPVisitNumberData,27)
			   s DoctorDR=$lg(RPVisitNumberData,23),Doctor=""
			   i $l(DoctorDR) s Doctor=$lg($g(^dbo.BTDoctorD(DoctorDR)),3)
			   s AuthDate=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),19)
			   s AuthTime=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),20)
			   s Urgent=$lg(RPVisitNumberData,50)
			   
			   //加急的标本查询半个小时未阅读的
			   i Urgent=1,(((CurrentDate-AuthDate)*24*60*60+CurrentTime-AuthTime)<(60*30)) continue
			   i Urgent'=1,(((CurrentDate-AuthDate)*24*60*60+CurrentTime-AuthTime)<(60*60*24)) continue
			   s AuthUserDR=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),21),AuthUser="",AuthUserCode=""
			   s ReAuthUserDR=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),26)
			   i $l(ReAuthUserDR) s AuthUserDR=ReAuthUserDR
			   i $l(AuthUserDR) s AuthUser=$lg($g(^dbo.SYSUserD(AuthUserDR)),3),AuthUserCode=$lg($g(^dbo.SYSUserD(AuthUserDR)),2)
			   
			   s Data = $lb(ReportDR,Labno,SurName,TestSetDesc,Doctor,Location,Ward,BedNo,patAge,AuthDate,AuthTime,AuthUser,patSex,Urgent)
			   d OutPut
			}

		}
	}
	

    
END
 	Set qHandle=$lb(0,repid,0)
    q $$$OK
 	
OutPut
	set ColFields="ReportDR,Labno,SurName,TestSetDesc,Doctor,Location,Ward,BedNo,patAge,AuthDate,AuthTime,AuthUser,patSex,Urgent"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QryUnReadedReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryUnReadedReportExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryUnReadedReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryUnReadedReportExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 判断标本是否多耐
/// w ##CLASS(DHCLIS.DHCLISInterface).IsMultipleResistant("1708160001")
ClassMethod IsMultipleResistant(LabNo As %String)
{
	s LabNo = $g(LabNo)
	s ret = 0
	i '$l(LabNo) q 0
	i '$d(^dbo.RPVisitNumberI("IndexVisitNumber",##Class(LIS.Util.Common).IndexData(LabNo))) q 0
	s VisitNumberDR = $o(^dbo.RPVisitNumberI("IndexVisitNumber",##Class(LIS.Util.Common).IndexData(LabNo),""))
	s WorkGroupMachineDR=""
	for {
		s WorkGroupMachineDR=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR))
		q:WorkGroupMachineDR=""
		s Order=""
		for {
			s Order = $o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,Order))
			q:Order=""
			s ReportDR = $o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,Order,""))
			s TesCodeDR=""
			for {
				s TesCodeDR = $o(^dbo.RPVisitNumberReportResultI("IndexReportItem",ReportDR,TesCodeDR))
				q:TesCodeDR=""
				s ResultDR= $o(^dbo.RPVisitNumberReportResultI("IndexReportItem",ReportDR,TesCodeDR,""))
				s MultipleResistant = $lg(^dbo.RPVisitNumberReportResultD(ResultDR),27)
				i MultipleResistant=1 s ret=1
			}
		}
	}
	q ret
}

/// Creator： 	 WangShiKai
/// Description: 判断报告是否未阅读
/// CreatDate：  20180905
/// Input：		 admNo:就诊号,DoctorCode:医生代码,HospitalCode:医院代码
/// Output:      Flag=0表示没有未阅读的报告，Flag=1表示有未阅读的报告
/// w ##class(DHCLIS.DHCLISInterface).ReportReadFlag("","YS01","DHSZHYYZY")
ClassMethod ReportReadFlag(admNo As %String, DoctorCode As %String, HospitalCode As %String) As %String
{
	s Flag=0
    s HospitalCode=$g(HospitalCode)
	s DoctorCode=$g(DoctorCode)
	s admNo=$g(admNo)
	i admNo="" q Flag
	i '$l(DoctorCode) q Flag

	s admNo=" "_admNo
	s DoctorCode=" "_DoctorCode
	s DoctorDR=0
	s HospitalDR=""
	i $l(HospitalCode) 
	{
	    s HospitalCode=" "_HospitalCode
	   	s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",HospitalCode,""))
	   	i '$l(HospitalDR) s HospitalDR=$o(^dbo.BTHospitalD(""))
	}
	i '$l(HospitalDR) q Flag
	s DoctorDR=$o(^dbo.BTDoctorI("IndexCode",HospitalDR,DoctorCode,DoctorDR))   
	
	s RequestDate=""
	for {
		s RequestDate=$o(^dbo.RPVisitNumberI("IndexAdmNo",admNo,RequestDate))
		q:RequestDate=""
		s VisitNumberDR=""
		for {
			s VisitNumberDR=$o(^dbo.RPVisitNumberI("IndexAdmNo",admNo,RequestDate,VisitNumberDR))
			q:VisitNumberDR=""
			s WorkGroupMachineDR=""
			for {
				s WorkGroupMachineDR=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR)) 
				q:WorkGroupMachineDR=""
				s OrderNo=""
				for {
					s OrderNo=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,OrderNo)) 
					q:OrderNo=""
					s VisitNumbeReportrDR=""
					for {
						s VisitNumbeReportrDR=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,OrderNo,VisitNumbeReportrDR)) 
						q:VisitNumbeReportrDR=""
						s Status=$lg($g(^dbo.RPVisitNumberReportD(VisitNumbeReportrDR)),22)
						i (Status'="3") q
						i '$D(^dbo.RPVisitNumberReportReadI("IndexReadDoctor",VisitNumbeReportrDR,DoctorDR))
						{   
							s Flag=1
							q:Flag
					
							} 
						}
					}
				}
			}
		}
	q Flag
}

/// Creator：      zyn
/// CreatDate：    20200415
/// Description:： 根据登记号获取报告DR
/// Table：        
/// Input：        
/// Output：       
/// Return：       
/// Others：  
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCLISInterface","QryReportDR","0000000017","","","","","","","","","","","","","","")
Query QryReportDR(RegNo, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "ReportDR")
{
}

ClassMethod QryReportDRExecute(ByRef qHandle As %Binary, RegNo, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    I '$L(RegNo) s qHandle=$lb(0,repid,0) q $$$OK
    S AddDate="" F  S AddDate=$O(^dbo.RPVisitNumberI("IndexPatientAddDate",##Class(LIS.Util.Common).IndexData(RegNo),AddDate)) Q:'$L(AddDate)  D
    .S VisitNumberDR=""  F  S VisitNumberDR=$O(^dbo.RPVisitNumberI("IndexPatientAddDate",##Class(LIS.Util.Common).IndexData(RegNo),AddDate,VisitNumberDR)) Q:'$L(VisitNumberDR)  D
    ..S WorkGroupMachineDR="" F  S WorkGroupMachineDR=$O(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR)) Q:'$L(WorkGroupMachineDR)  D
    ...S OrderNo="" F  S OrderNo=$O(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,OrderNo)) Q:'$L(OrderNo)  D
 	....S ReportDR="" F  S ReportDR=$O(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,OrderNo,ReportDR)) Q:'$L(ReportDR)  D
 	.....i $lg(^dbo.RPVisitNumberReportD(ReportDR),22)'=3 Q
 	.....set Data=$lb(ReportDR)
 	.....d OutPut
 	s qHandle=$lb(0,repid,0) 
	q $$$OK
	
OutPut
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QryReportDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReportDRExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryReportDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReportDRExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      zyn
/// CreatDate：    20200426
/// Description:： 根据AdmNo获取危急值信息
/// Table：        
/// Input：        
/// Output：       
/// Return：       
/// Others：  
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCLISInterface","QryReportDR","0000000017","","","","","","","","","","","","","","")
Query QryPanicReport(AdmNo, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "TestName,Result")
{
}

ClassMethod QryPanicReportExecute(ByRef qHandle As %Binary, AdmNo, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    I '$L(AdmNo) s qHandle=$lb(0,repid,0) q $$$OK
    S RequestDate="" F  S RequestDate=$O(^dbo.RPVisitNumberI("IndexAdmNo",##Class(LIS.Util.Common).IndexData(AdmNo),RequestDate)) Q:'$L(RequestDate)  D
    .S VisitNumberDR=""  F  S VisitNumberDR=$O(^dbo.RPVisitNumberI("IndexAdmNo",##Class(LIS.Util.Common).IndexData(RegNo),RequestDate,VisitNumberDR)) Q:'$L(VisitNumberDR)  D
    ..S WorkGroupMachineDR="" F  S WorkGroupMachineDR=$O(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR)) Q:'$L(WorkGroupMachineDR)  D
    ...S OrderNo="" F  S OrderNo=$O(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,OrderNo)) Q:'$L(OrderNo)  D
 	....S ReportDR="" F  S ReportDR=$O(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,OrderNo,ReportDR)) Q:'$L(ReportDR)  D
 	.....i $lg(^dbo.RPVisitNumberReportD(ReportDR),22)'=3 Q
 	.....i $d(^dbo.RPVisitNumberPanicReportI("IndexReportID",ReportDR)) d
 	......s AddDate="" F  S AddDate=$O(^dbo.RPVisitNumberPanicReportI("IndexReportID",ReportDR,AddDate)) Q:'$L(AddDate)  D
 	.......S AddTime=""  F  S AddTime=$O(^dbo.RPVisitNumberPanicReportI("IndexReportID",ReportDR,AddDate,AddTime)) Q:'$L(AddTime)  D
 	........S PanicReportDR="" F  S PanicReportDR=$O(^dbo.RPVisitNumberPanicReportI("IndexReportID",ReportDR,AddDate,AddTime,PanicReportDR)) Q:'$L(PanicReportDR)  D
 	.........S TestCodeDR="" F  S TestCodeDR=$O(^dbo.RPVisitNumberPanicResultI("IndexMaster",PanicReportDR,TestCodeDR)) Q:'$L(TestCodeDR)  D
 	..........S PanicResultDR="" F  S PanicResultDR=$O(^dbo.RPVisitNumberPanicResultI("IndexMaster",PanicReportDR,TestCodeDR,PanicResultDR)) Q:'$L(PanicResultDR)  D
 	...........S PanicResult=$g(^dbo.RPVisitNumberPanicResultD(PanicResultDR))
 	...........S TestCode=$lg(PanicResult,3)
 	...........S TestName=$lg(^dbo.BTTestCodeD(TestCode),3)
 	...........S Result=$lg(PanicResult,4)
 	...........set Data=$lb(TestName,Result)
 	.....d OutPut
 	s qHandle=$lb(0,repid,0) 
	q $$$OK
	
OutPut
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QryPanicReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPanicReportExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryPanicReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPanicReportExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
