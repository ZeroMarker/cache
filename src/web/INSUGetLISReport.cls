Class web.INSUGetLISReport Extends %Library.RegisteredObject
{

/// 根据就诊号获取LIS报告列表
ClassMethod GetReportList(PAADM As %String, LABNS As %String) As %ListOfDataTypes
{
	Set $ZTrap = "GetReportListError"
	s rtnList=##class(%ListOfDataTypes).%New()
	q:+PAADM=0 rtnList
	s papmidr=$p(^PAADM(PAADM),"^",1)
	s debtor=$p(^PAPER(papmidr,"PAT",1),"^",1)
	;s iHospitalDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(PAADM)
	s iHospitalDR="" ; query有BUG,只能传空
	Set rset=##class(%ResultSet).%New("LISService.DataShare.LISReport:Report")
	do rset.Execute("","",iHospitalDR,"",PAADM,"","")
	Set columns = rset.GetColumnCount()
	Set tmpStream=##class(%GlobalCharacterStream).%New()
	While (rset.Next()) {
		s ReportDR=rset.GetDataByName("ReportDR")	;检验报告ID
		s tmpStream=##Class(LISService.Business.ReportOut).GetReport(ReportDR,"")
		s tmpXMLStr=tmpStream.Read()
		if tmpXMLStr'["<ReturnValue>0"{
			continue
		}
		s tmpobj=##class(LISService.entity.ReportData).%New()
		d ##class(web.INSUCacheXML).Deserialize(.tmpobj,"LISReport",tmpXMLStr)
		if tmpobj.ReturnValue="0" {
			d rtnList.Insert(tmpobj)
		}
	}
	d rset.Close()
	q rtnList
GetReportListError
	w "GetReportListError:"_$ZERROR
	q rtnList
}

/// 根据就诊号获取LIS报告列表
ClassMethod GetReportListBak(PAADM As %String, LABNS As %String) As %ListOfDataTypes
{
	s rtnList=##class(%ListOfDataTypes).%New()
	q:+PAADM=0 rtnList
	s papmidr=$p(^PAADM(PAADM),"^",1)
	s debtor=$p(^PAPER(papmidr,"PAT",1),"^",1)
	Set date="" For  Set date=$Order(^TDEBi(debtor,"DATE",date),-1) Quit:date=""  Do
	.;i Days>0,date+Days<+$h q  //得到指定天数内的报告
	.Set time=""  For  Set time=$Order(^TDEBi(debtor,"DATE",date,time),-1) Quit:time=""  Do
	..Set labno="" For  Set labno=$Order(^TDEBi(debtor,"DATE",date,time,labno)) Quit:labno=""  Do
	...;If $Piece(^TEPI(labno),"\",48)'=ReportType Quit //报告类型
	...Set ts=""  For  Set ts=$Order(^TEPI(labno,1,ts)) Quit:ts=""  Do
	....IF $Data(^TTAB("TS",ts,"XM")) Quit	///配血结果排除
	....;set lisrpt=##Class(web.INSUGetLISReport).GetReport(labno_"||"_ts_"||1","Labdata")	;HIS8.0以上用此函数
	....set lisrpt=##Class(web.INSUGetLISReport).GetReportOLD(labno_"||"_ts_"||1","Labdata")	;老LIS用此函数
	....i lisrpt.ReturnValue="0" d
	.....d rtnList.Insert(lisrpt)
	q rtnList
}

/// 根据LIS报告DR获取报告
/// w ##Class(web.INSUGetLISReport).GetReport("2","Labdata")
ClassMethod GetReportBak(ReportDR As %String, LABNS As %String) As web.INSULISReport
{
	s ReportDR=$g(ReportDR),LABNS=$g(LABNS)
	i '$l(LABNS) s LABNS="labdata"
	//Set $ZTrap = "ErrorHandle"
	//基本信息

	s obj=##Class(web.INSULISReport).%New()
	s obj.ReturnValue="无此报告"
	;q:'$l(ReportDR) obj
	;q:$l(ReportDR) obj
	s ReportData=$g(^dbo.RPVisitNumberReportD(ReportDR))
	s VisitNumberDR=$lg(ReportData,2)
	q:'$l(VisitNumberDR) obj
	s obj.ReturnValue="报告未审核"
	q:$lg(ReportData,22)'=3 obj
	s VisitNumberData=$g(^dbo.RPVisitNumberD(VisitNumberDR))
    s gName=$lg(VisitNumberData,14)
    s sName=$lg(VisitNumberData,13)
    s patname=gName_" "_sName
    i gName=sName s patname=gName
    s spname=""				;性别
    s SpeciesDR=$lg(VisitNumberData,15)
 	i $l(SpeciesDR) s spname=$lg(^dbo.BTSpeciesD(SpeciesDR),3)
    s patDOB=$lg(VisitNumberData,16)
    i (patDOB<10000000) s patDOB=$zd(patDOB,8)
	i $l(patDOB) s patDOB=##Class(LIS.Util.Common).FormatDate(patDOB)
    s patage=""
	s retAge=##Class(LISService.Business.ReportOut).GetAge(patDOB)
	i $l($p(retAge,"^",1)) s patage=$p(retAge,"^",1)_$p(retAge,"^",2) 
    //
    s SpecimenDR=$lg(VisitNumberData,56),specmen=""   ;标本类型
 	i $l(SpecimenDR) s specmen=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),3)  
 	s tsname="",TSCode=""
	s TestSetDR="" f  s TestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",VisitNumberDR,TestSetDR)) q:TestSetDR=""  d
	.i $l(tsname) s tsname=tsname_"+"_$lg(^dbo.BTTestSetD(TestSetDR),3),TSCode=TSCode_"+"_$lg(^dbo.BTTestSetD(TestSetDR),2)
	.e  s tsname=$lg(^dbo.BTTestSetD(TestSetDR),3),TSCode=$lg(^dbo.BTTestSetD(TestSetDR),2)
    i $l(specmen,"(")>1 s specmen=$p(specmen,"(",1)
    //
    s patloc=""					   ;科室
    s LocationDR=$lg(VisitNumberData,22)
    i $l(LocationDR) s patloc=$lg($g(^dbo.BTLocationD(LocationDR)),3)
    //申请日期
    s requestdate=$lg(VisitNumberData,24)
	i (requestdate<10000000) s requestdate=$zd(RequestDate,8) 
	i $l(requestdate) s requestdate=##Class(LIS.Util.Common).FormatDate(requestdate)
	
    //
    s (recdate,rectime,recusr,entrydate,entrytime,entryusr,authdate,authtime,authusr)=""
    s recdate=$lg(VisitNumberData,66)   ;接收日期
    s rectime=$lg(VisitNumberData,67)	;接收时间
	i $l(recdate) s recdate=##Class(LIS.Util.Common).FormatDate(recdate)
	i $l(rectime) s rectime=##Class(LIS.Util.Common).FormatTime(rectime)
    s ReceiveUserDR=$lg(VisitNumberData,68)
 	i $l(ReceiveUserDR) s recusr=$lg($g(^dbo.SYSUserD(ReceiveUserDR)),3) 
	s entrydate=$lg(ReportData,16)		;初审日期
	s entrytime=$lg(ReportData,17)		;初审时间
	i $l(entrydate) s entrydate=##Class(LIS.Util.Common).FormatDate(entrydate)
	i $l(entrytime) s entrytime=##Class(LIS.Util.Common).FormatTime(entrytime)
	
    s EntryUserDR=$lg(ReportData,18)
	i $l(EntryUserDR) s entryusr=$lg($g(^dbo.SYSUserD(EntryUserDR)),3)
    s authdate=$lg(ReportData,19)		;核收日期
    s authtime=$lg(ReportData,20)		;核收时间
	i $l(authdate) s authdate=##Class(LIS.Util.Common).FormatDate(authdate)
	i $l(authtime) s authtime=##Class(LIS.Util.Common).FormatTime(authtime)
    
    s AuthUserDR=$lg(ReportData,21)
	i $l(AuthUserDR) s authusr=$lg($g(^dbo.SYSUserD(AuthUserDR)),3)
    //
    s coldate=$lg(VisitNumberData,51)	;采集日期
	s coltime=$lg(VisitNumberData,52)	;采集时间
	i $l(coldate) s coldate=##Class(LIS.Util.Common).FormatDate(coldate)
	i $l(coltime) s coltime=##Class(LIS.Util.Common).FormatTime(coltime)
	
    s CollDT=""
    i $l(coldate) s CollDT=coldate_" "_coltime
    //
    s (recDT,entryDT,authDT)=""
    i $l(recdate) s recDT=recdate_" "_rectime
    i $l(entrydate) s entryDT=entrydate_" "_entrytime
    i $l(authdate) s authDT=authdate_" "_authtime
    //
    s debtor=$lg(VisitNumberData,3)  ;登记号
    s DoctorDR=$lg(VisitNumberData,23)
    s docname=""					;医生
    i $l(DoctorDR) s docname=$lg($g(^dbo.BTDoctorD(DoctorDR)),3)
    //诊断
    s patdiag=""
    s DiseaseDR="" f  s DiseaseDR=$o(^dbo.RPVisitNumberDiagnoseI("IndexMaster",VisitNumberDR,DiseaseDR)) q:DiseaseDR=""  d
	.i $l(patdiag) s patdiag=patdiag_"+"_$lg(^dbo.BTDiseaseD(DiseaseDR),4)
	.e  s patdiag=$lg(^dbo.BTDiseaseD(DiseaseDR),4)
    //仪器,病区,床号,流水号
    s Machine=""
    //s MachineDR=$lg(ResultData,14)
    //i $l(MachineDR) s Machine=$lg($g(^dbo.BTMIMachineParameterD(MachineDR)),3)
    s bed=$lg(VisitNumberData,27)	 ;床号
    s WardName=""
    s WardDR=$lg(VisitNumberData,26)
	i $l(WardDR) s WardName=$lg($g(^dbo.BTWardD(WardDR)),3)
    s episode=$lg(ReportData,8)
    s Depart=""
    s WorkGroupMachineDR=$lg(ReportData,4)
    i $l(WorkGroupMachineDR) s WorkGroupDR=$lg($g(^dbo.BTWorkGroupMachineD(WorkGroupMachineDR)),4)
	i $l(WorkGroupDR) s DepartPhone=$lg($g(^dbo.BTWorkGroupD(WorkGroupDR)),6)
    s AdmID=$lg(VisitNumberData,6)
    s AdmNo=$lg(VisitNumberData,5)
    s PatRowID=""
    i '$l(debtor) d
    .s PatRowID=$o(^dbo.RQPatientI("IndexRegNo",debtor,""))
	
	s obj.TSRowId=ReportDR
	s obj.TSCode=TSCode  ///???
	s obj.RegisterNo=debtor
	s obj.PatientName=patname
	s obj.Speceis=spname
	s obj.Age=patage
	s obj.DOB=patDOB
	s obj.Diag=patdiag
	s obj.Location=patloc
	s obj.Doctor=docname
	s obj.RequestDT=requestdate
	s obj.Ward=WardName
	s obj.Bed=bed
	s obj.TSName=tsname
	s obj.Specimen=specmen
	s obj.CollectionDT=CollDT
	s obj.ReceiveDT=recDT
	s obj.ReceiveUser=recusr
	s obj.EntryDT=entryDT
	s obj.EntryUser=entryusr
	s obj.AuthDT=authDT
	s obj.AuthUser=authusr
	s obj.Machine=Machine
	s obj.Episode=episode
	s obj.DepartPhone=DepartPhone
	//20141114 增加就诊号和病人ID huhm
	s obj.PatRowID=PatRowID
	s obj.AdmID=AdmID
	s obj.AdmNo=AdmNo
	//结果
 	Set result = ##class(%ResultSet).%New("LISService.Business.ReportResult:QryTestSetResult")
 	//Set columns = rset.GetColumnCount()
 	// Execute the query
	 Set sc = result.Execute(ReportDR)
 	//S result=##class(LISService.DataSet.TestSetResultDataSet).%New()
	//d result.SetArgs(TSRowId)
	//
 	While (result.Next(.sc)) // go to the next row of the result set
     {
        If ($SYSTEM.Status.IsOK(sc)) // check if this succeeded without errors
            {
	            ;SenResultId:细菌结果ID，如果ID不为空就是细菌结果。
	            s objRes=##Class(LISService.entity.ReportDataResult).%New()
                s TestCode=result.Data("TestCode")
                s objRes.TSCode=TSCode
                s objRes.TestCode=TestCode
                s objRes.TestName=result.Data("TestName")
                s TestSync=result.Data("TestSync")
                i '$l(TestSync) s TestSync=" "
                s objRes.TestSync=TestSync
                s objRes.Result=result.Data("Result")
                s ResFlag=result.Data("ResFlag")
                i '$l(ResFlag) s ResFlag="N"
                s objRes.ResFlag=ResFlag
                s Unit=result.Data("Unit")
                i '$l(Unit) s Unit=" "
                s objRes.Unit=Unit
                s Ranges=result.Data("Ranges")
                i '$l(Ranges) s Ranges=" "
                s objRes.Ranges=Ranges
                s objRes.Method=""
                s objRes.Sequence=result.Data("Sequence")
				s SenResultId=result.Data("SenResultId")
				i $l(SenResultId) 
				{
	                s sen=##class(%ResultSet).%New("LISService.Business.ReportResult:QryTestSetResultSen")
	                Set st = sen.Execute(TSRowId_"||"_TestCode)
	                While (sen.Next(.st))
	                {
		               If ($SYSTEM.Status.IsOK(st)) 
		               {
			               s objSen=##Class(LISService.entity.ReportDataResultSen).%New()
			               s objSen.AntibioCode=sen.Data("AntibioCode")
			               s objSen.AntibioName=sen.Data("AntibioName")
			               s objSen.SenResult=sen.Data("SenResult")
			               s objSen.mmResult=sen.Data("SenMethod")
			               s objSen.MicResult=sen.Data("SenValue")
			               d objRes.ResultSenDetails.Insert(objSen)
			              //
			           }
		            }
				}
                d obj.ResultDetails.Insert(objRes)
            }
     }
    s obj.ReturnValue="0"
 	If $SYSTEM.Status.IsError(sc) // if there was an error, process that
     {
	     s obj.ReturnValue="-1^查询失败"
     	// perform error processing
     }
	;d obj.XMLExportToStream(.ret)
	q obj	
ErrorHandle
	s err=$tr("查询异常.错误"_$tr($ZERROR,"^","--")_".错误代码:"_$ECODE,"<>")
	s obj.ReturnValue=err
    q obj
}

ClassMethod GetReportOLDBak(TSRowId As %String, LABNS As %String) As web.INSULISReport
{
	s TSRowId=$g(TSRowId),LABNS=$g(LABNS)
	i '$l(LABNS) s LABNS="labdata"
	//Set $ZTrap = "ErrorHandle"
	//基本信息
	s labno=$p(TSRowId,"||",1),ts=$p(TSRowId,"||",2),tscnt=$p(TSRowId,"||",3)
	s obj=##Class(web.INSULISReport).%New()
	s obj.ReturnValue="无此报告"
	s RetStr=""
	i '$d(^TEPI(labno,1,ts,tscnt)) q obj
	s resstatus=$p(^TEPI(labno,1,ts,tscnt),"\",31)
	i resstatus'="A" q obj
    s gName=$p(^TEPI(labno),"\",1)
    s sName=$p(^TEPI(labno),"\",2)
    s patname=gName_" "_sName
    i gName=sName s patname=gName
    s spname=""				;性别
    s spcode=$p(^TEPI(labno),"\",3)
    i spcode'="",$d(^TTAB("SP",spcode)) s spname=$p(^TTAB("SP",spcode),"\",1)
    s patDOB=$p(^TEPI(labno),"\",4)
    i $l(patDOB) s patDOB=$zd(patDOB,3)
    s patage=##Class(LISService.Business.LISReport).GetPatAge(patDOB,labno)
    //
    s specode=$p(^TEPI(labno,1,ts,tscnt),"\",46) ;标本类型
    s tsname=$p(^TTAB("TS",ts),"\",1)
    i specode'="",$d(^TTAB("SPEC",specode)) s specmen=$p(^TTAB("SPEC",specode),"\",1)
    i $l(specmen,"(")>1 s specmen=$p(specmen,"(",1) ;标本去掉"()"内的内容
    //
    s patloc=""					   ;科室
    s loccode=$p(^TEPI(labno),"\",36) 
    i loccode'="",$d(^TTAB("USLOC",loccode)) s patloc=$p($g(^TTAB("USLOC",loccode)),"\",1)
    s patloc1=$p(patloc,"-",1),patloc2=$p(patloc,"-",2)
    i $l(patloc2)  d
    .s patloc=patloc2
    e  d
    .s patloc=patloc1 
    //申请日期
    s requestdate=$p(^TEPI(labno),"\",12) 
    i $l(requestdate) s requestdate=$zd(requestdate,3) 
    //
    s recdate1=$p(^TEPI(labno,1,ts,tscnt),"\",21)
    s rectime1=$p(^TEPI(labno,1,ts,tscnt),"\",22)
    s recusr1=$p(^TEPI(labno,1,ts,tscnt),"\",36)
    s entrydate1=$p(^TEPI(labno,1,ts,tscnt),"\",1)
    s entrytime1=$p(^TEPI(labno,1,ts,tscnt),"\",2)
    s entryusr1=$p(^TEPI(labno,1,ts,tscnt),"\",3)
    s authdate1=$p(^TEPI(labno,1,ts,tscnt),"\",4)
    s authtime1=$p(^TEPI(labno,1,ts,tscnt),"\",5)
    s authusr1=$p(^TEPI(labno,1,ts,tscnt),"\",6) 
    //				
    s specode=$p(^TEPI(labno,1,ts,tscnt),"\",46) ;标本类型
    //s machdr=$p(^TEPI(labno,1,ts,tscnt),"\",27)
    //s print=$p(^TEPI(labno,1,ts,tscnt),"\",28)
    s coldate=$p(^TEPI(labno,1,ts,tscnt),"\",44)
    i coldate'="" s coldate=$zd(coldate,3)
    s coltime=$p(^TEPI(labno,1,ts,tscnt),"\",45)
    i coltime'="" s coltime=$zt(coltime,2)
    s CollDT=""
    i $l(coldate) s CollDT=coldate_" "_coltime
    //
    s debtor=$p(^TEPI(labno),"\",18) ;登记号
    s docname=""					;医生
    s doccode=$p(^TEPI(labno),"\",13)
    i doccode'="",$d(^TTAB("DR",doccode)) s docname=$p(^TTAB("DR",doccode),"\",1)
    i $l(docname,"(") s docname=$p(docname,"(",1)  
    //
    s (recdate,rectime,recusr,entrydate,entrytime,entryusr,authdate,authtime,authusr)=""
    i recdate1'="" s recdate=$zd(recdate1,3)  ;接收日期
    i rectime1'="" s rectime=$zt(rectime1*60,2)  ;接收时间
    i recusr1'="",$d(^[LABNS]SSU("SSUSR",1,recusr1)) s recusr=$p(^[LABNS]SSU("SSUSR",1,recusr1),"^",2)
    i entrydate1'="" s entrydate=$zd(entrydate1,3) ;录入日期
    i entrytime1'="" s entrytime=$zt(entrytime1*60,2) ;录入时间
    i entryusr1'="",$d(^[LABNS]SSU("SSUSR",1,entryusr1)) s entryusr=$p(^[LABNS]SSU("SSUSR",1,entryusr1),"^",2)
    i authdate1'="" s authdate=$zd(authdate1,3) ;核实日期
    i authtime1'="" s authtime=$zt(authtime1*60,2) ;核实时间
    i authusr1'="",$d(^[LABNS]SSU("SSUSR",1,authusr1)) s authusr=$p(^[LABNS]SSU("SSUSR",1,authusr1),"^",2)
    s (recDT,entryDT,authDT)=""
    i $l(recdate) s recDT=recdate_" "_rectime
    i $l(entrydate) s entryDT=entrydate_" "_entrytime
    i $l(authdate) s authDT=authdate_" "_authtime
    //诊断
    s patdiag=""
    i $d(^TEPI(labno,8)) s patdiag=$p(^TEPI(labno,8),"\",15)
    //仪器,病区,床号,流水号 20131018 huhm
    s Machine=""
    s MachDr=$p(^TEPI(labno,1,ts,tscnt),"\",27)
    i MachDr'="",$d(^TMIF(MachDr)) s Machine=$p(^TMIF(MachDr),"\",1)
    s bed=$p(^TEPI(labno,0),"\",29)	 ;床号
    s WardName=""
    s WardDr=$p(^TEPI(labno),"\",20)
    i $l(WardDr),$d(^TTAB("RH",WardDr)) s WardName=$p(^TTAB("RH",WardDr),"\",1)
    s episode=$p(^TEPI(labno,1,ts,tscnt),"\",12)
    //检验科-门诊检验组\Lab Manager#84322268
    s Depart=$g(^TTAB("DEP",$e(ts,1)))
    s DepartPhone=$p(Depart,"\",1)_"("_$p($p(Depart,"\",2),"#",2)_")"
    // 20141114
    s AdmID=$p($p(^TEPI(labno),"\",37),",",2)
    s AdmNo=$p($p(^TEPI(labno),"\",37),",",1)
    s PatRowID=""
    i '$l(AdmID) d
    .s OrderID=$o(^OEORD(0,"EpisNo",labno,""))
    .q:OrderID=""
    .s AdmID=$p($g(^OEORD(OrderID)),"^",1)
    .q:AdmID=""
    .s AdmNo=$P($g(^PAADM(AdmID)),"^",81)
    .s PatRowID=$P($g(^PAADM(AdmID)),"^",1)
    e  d
    .s PatRowID=$P($g(^PAADM(AdmID)),"^",1)
    //	
	//s obj=##Class(LISService.entity.ReportData).%New()
	s obj.RegisterNo=debtor
	s obj.PatientName=patname
	s obj.Speceis=spname
	s obj.Age=patage
	s obj.DOB=patDOB
	s obj.Diag=patdiag
	s obj.Location=patloc
	s obj.Doctor=docname
	s obj.RequestDT=requestdate
	s obj.Ward=WardName
	s obj.Bed=bed
	s obj.TSName=tsname
	s obj.Specimen=specmen
	s obj.CollectionDT=CollDT
	s obj.ReceiveDT=recDT
	s obj.ReceiveUser=recusr
	s obj.EntryDT=entryDT
	s obj.EntryUser=entryusr
	s obj.AuthDT=authDT
	s obj.AuthUser=authusr
	s obj.Machine=Machine
	s obj.Episode=episode
	s obj.DepartPhone=DepartPhone
	//20141114 增加就诊号和病人ID huhm
	s obj.PatRowID=PatRowID
	s obj.AdmID=AdmID
	s obj.AdmNo=AdmNo
	//结果
 	Set result = ##class(%ResultSet).%New("LISService.Business.ReportResult:QryTestSetResult")
 	//Set columns = rset.GetColumnCount()
 	// Execute the query
	 Set sc = result.Execute(TSRowId)
	
 	//S result=##class(LISService.DataSet.TestSetResultDataSet).%New()
	//d result.SetArgs(TSRowId)
	//debug
	//
 	While (result.Next(.sc)) // go to the next row of the result set
     {
        If ($SYSTEM.Status.IsOK(sc)) // check if this succeeded without errors
            {
	            s objRes=##Class(LISService.entity.ReportDataResult).%New()
                s TestCode=result.Data("TestCode")
                s objRes.TestCode=TestCode
                s objRes.TestName=result.Data("TestName")
                s objRes.TestSync=result.Data("TestSync")
                s objRes.Result=result.Data("Result")
                s objRes.ResFlag=result.Data("ResFlag")
                s objRes.Unit=result.Data("Unit")
                s objRes.Ranges=result.Data("Ranges")
                s objRes.Method=""
                s objRes.Sequence=result.Data("Sequence") //显示顺序 20141114 huhm
                S ^TMPREP(labno,TestCode)=result.Data("Sequence")
                s sen=##class(%ResultSet).%New("LISService.Business.ReportResult:QryTestSetResultSen")
                Set st = sen.Execute(TSRowId_"||"_TestCode)
                While (sen.Next(.st))
                {
	               If ($SYSTEM.Status.IsOK(st)) 
	               {
		               s objSen=##Class(LISService.entity.ReportDataResultSen).%New()
		               s objSen.AntibioCode=sen.Data("AntibioCode")
		               s objSen.AntibioName=sen.Data("AntibioName")
		               s objSen.SenResult=sen.Data("SenResult")
		               s objSen.mmResult=sen.Data("mmReult")
		               s objSen.MicResult=sen.Data("MicResult")
		               d objRes.ResultSenDetails.Insert(objSen)
		              //
		           }
	            }
                
                
                d obj.ResultDetails.Insert(objRes)
            }
     }
    //w debug1
    s obj.ReturnValue="0"
 	If $SYSTEM.Status.IsError(sc) // if there was an error, process that
     {
	     s obj.ReturnValue="-1^查询失败"
     	// perform error processing
     }
	q obj	
ErrorHandle
	s err=$tr("查询异常.错误"_$tr($ZERROR,"^","--")_".错误代码:"_$ECODE,"<>")
	s obj.ReturnValue=err
    q obj
}

}
