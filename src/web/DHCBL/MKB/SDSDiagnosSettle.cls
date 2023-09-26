/// Creator:高姗姗
/// CreatDate:2019-10-09
/// Description：结构化诊断数据整理
/// Table：User.SDSDiagnos
Class web.DHCBL.MKB.SDSDiagnosSettle Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2019-10-09
/// Description：导入整理诊断：医生站门急诊、住院近两年诊断
/// Table：User.SDSDiagnos
/// Input：rowid, desc
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnosSettle).ImportZLDiag("2019-01-31","2019-04-17") //本地
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnosSettle).ImportZLDiag("2017-01-01","2019-10-29") //腾讯云/医大一
ClassMethod ImportZLDiag(DateFrom As %String, DateTo As %String) As %String
{
	;d ..ExportMRDiag(DateFrom,DateTo)
	
	s PatNo=""
	for {
		s PatNo=$o(^TMPSDSDIAGNOS("ExportMRDateDiag",PatNo)) q:PatNo=""
		s PMIDR=##class(web.DHCBL.MKB.SDSPatMas).SaveData(PatNo)
		s DiagDate=""
		for {
			s DiagDate=$o(^TMPSDSDIAGNOS("ExportMRDateDiag",PatNo,DiagDate)) q:DiagDate=""
			s DiagDesc=""
			for {
				s DiagDesc=$o(^TMPSDSDIAGNOS("ExportMRDateDiag",PatNo,DiagDate,DiagDesc)) q:DiagDesc=""
				s OtherInfo=$G(^TMPSDSDIAGNOS("ExportMRDateDiag",PatNo,DiagDate,DiagDesc))
				s DiagType=$p(OtherInfo,"^",1)
				s DiagStatus=$p(OtherInfo,"^",2)
				
				
				s wordVersion=##class(web.DHCBL.MKB.SDSDiagnos).GetWordVersion()
				if (wordVersion["ICD"){ //版本对照
					s resFactory=##class(web.DHCBL.MKB.MKBICDContrastInterface).GetSameDiag(wordVersion,DiagDesc)
				}else{ //数据处理工厂
					s resFactory=##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GetSameDiag(wordVersion,DiagDesc)
				}
				
				continue:resFactory=""
				s WordDR="",IcdCode="",IcdDesc="",TermDR="",Value="",Supplement=""
				s WordDR=$p(resFactory,"^",1)
				s IcdCode=$p(resFactory,"^",2)
				s IcdDesc=$p(resFactory,"^",3)
				s TermDR=$p(resFactory,"^",4)
				s Value=$p(resFactory,"^",5)
				s Supplement=$p(resFactory,"^",6)
				
				s eobj=##class(web.Entity.MKB.SDSDiagnos).%New()
				s eobj.SDSRowId=""
				s eobj.SDSIcdCode=IcdCode
				s eobj.SDSIcdDesc=IcdDesc
				s eobj.SDSMainDiagFlag="N"
				s eobj.SDSOpenDate=DiagDate
				s eobj.SDSTermDR=TermDR
				s eobj.SDSValue=Value
				s eobj.SDSSupplement=Supplement
				s eobj.SDSWordDR=WordDR
				s eobj.SDSSequence=""
				s eobj.SDSTagDR=##class(web.DHCBL.MKB.SDSDiagnos).GetTermIdByDesc("整理")
				s eobj.SDSLevel="1"
				s eobj.SDSOnsetDate=DiagDate
				s eobj.SDSTypeDR=##class(web.DHCBL.MKB.SDSDiagnos).GetDefaultInfo("Type",DiagType)
				s eobj.SDSStatusDR=##class(web.DHCBL.MKB.SDSDiagnos).GetDefaultInfo("Status",DiagStatus)
	
				s eobj.SDSPMIDR=PMIDR
				s eobj.SDSAdmDR=""
				s res=##class(web.DHCBL.MKB.SDSDiagnos).SaveEntity(eobj)
				w res,!
			}
		}		
	}
	q "ok"
}

/// Creator：高姗姗
/// CreatDate: 2019-10-09
/// Description：导出医生站诊断：医生站门急诊、住院近两年诊断
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnosSettle).ExportMRDiag("2019-01-31","2019-04-17") //本地
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnosSettle).ExportMRDiag("2017-01-01","2019-10-29") //腾讯云/医大一
ClassMethod ExportMRDiag(DateFrom As %String, DateTo As %String) As %String
{
   k ^TMPSDSDIAGNOS("ExportMRDiagDate")
   k ^TMPSDSDIAGNOS("ExportMRDateDiag")
   s DateFrom=$ZDH(DateFrom,3)
   s DateTo=$ZDH(DateTo,3)
   s Num=0 
   f Date=DateFrom:1:DateTo d
   .s AdmRowid=0 f  s AdmRowid=$o(^PAADMi("PAADM_AdmDate",Date,AdmRowid)) q:AdmRowid=""  d   // UpdDate yx 20140421
   ..s AdmType=$p(^PAADM(AdmRowid),"^",2)
   ..s AdmStatus=$p(^PAADM(AdmRowid),"^",20)
   ..;;患者基本信息
   ..s PAPMIID=$P($G(^PAADM(AdmRowid)),"^",1)
   ..s Name=$p(^PAPER(PAPMIID,"ALL"),"^",1) ;姓名
   ..s DOB=+$p(^PAPER(PAPMIID,"ALL"),"^",6) ;出生日期
   ..s Sex=+$p(^PAPER(PAPMIID,"ALL"),"^",7) ;性别
   ..s Sex=$P($G(^CT("SEX",Sex)),"^",2)
   ..s:DOB'="" DOB=$ZD(DOB,3)
   ..s PatNo=$p(^PAPER(PAPMIID,"PAT",1),"^",2) ;登记号
   ..s patDep=$P($G(^PAADM(AdmRowid)),"^",4)
   ..i patDep'="" s CTLocDesc=$P($G(^CTLOC(patDep)),"^",2)  ;就诊科室
   ..;s AdmReasonId=$p(^PAADM(AdmRowid,1),"^",7)
   ..;i AdmReasonId'="" s AdmReason=$p(^PAC("ADMREA",AdmReasonId),"^",2) ;费别
   ..s PatDiag=..GetMRDiagnosToEMR(AdmRowid) ;诊断
   ..q:PatDiag=""
   ..s diagLen=$Length(PatDiag,"&")
   ..f i=1:1:diagLen d
   ...s DiagInfo=$p(PatDiag,"&",i)
   ...s DiagDesc=$p(DiagInfo,"^",1)
   ...s DiagDate=$p(DiagInfo,"^",2)
   ...s DiagType=$p(DiagInfo,"^",3)
   ...s DiagStatus=$p(DiagInfo,"^",4)
   ...q:$d(^TMPSDSDIAGNOS("ExportMRDiagDate",PatNo,DiagDesc)) //去重，保留最近日期诊断
   ...s Num=Num+1
   ...w Num,!
   ...s ^TMPSDSDIAGNOS("ExportMRDiagDate",PatNo,DiagDesc,DiagDate)=DiagType_"^"_DiagStatus //登记号，诊断，日期=类型^状态
   ...s ^TMPSDSDIAGNOS("ExportMRDateDiag",PatNo,DiagDate,DiagDesc)=DiagType_"^"_DiagStatus //登记号，日期，诊断=类型^状态
   q "ok"
}

/// 根据就诊rowid获取患者诊断
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnosSettle).GetMRDiagnosToEMR(3)
/// 参照w ##class(web.DHCBL.BDP.ExportDiag).GetMRDiagnosToEMR(50506360)
ClassMethod GetMRDiagnosToEMR(EpisodeID As %String)
{

	//lxz 05-29 和界面显示使用相同的接口
	s mradm=$p(^PAADM(EpisodeID),"^",61)   //MR_Adm RowId
	if mradm="" q ""
	s ret=""

	s ret=""
	s rets=""                  // fwk
	s rets2=""                 // fwk
	s sub=""
	for  s sub=$o(^MR(mradm,"DIA",sub),-1) Quit:sub=""  do //倒序，返回值按日期倒序返回
	.q:$d(^MR(mradm,"DIA",sub))="10"
	.s desc=""
	.s desid=$g(^MR(mradm,"DIA",sub,"DES",0))
	.if +desid'=0 Set desc=^MR(mradm,"DIA",sub,"DES",desid)
	.s ICDId=$p(^MR(mradm,"DIA",sub),"^",1)
	.s DIADate=$p(^MR(mradm,"DIA",sub),"^",7)
	.Q:DIADate=""
	.s DIADate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DIADate)
	.s ICDCode="无"             //fwk
	.s ICDDesc="无"             //fwk
	.if ICDId'="" do
	..;lxz  电子病历需要备注信息
	..s ICDCode = $p(^MRC("ID",ICDId),"^",4)                   //fwk
	..s ICDDesc=$p(^MRC("ID",ICDId),"^",2)
	..s desc=ICDDesc 
	..;if desc'="" s desc=ICDDesc_"["_desc_"]"
	..;else  s desc=ICDDesc
	.//处理诊断知识库录入的诊断
	.///s DiagPRowId=$o(^MRi("DIAGP",mradm_"||"_sub,""))
	.///i DiagPRowId'="" s desc=##class(web.DHCMRDiagnosNew).GetDiagFormateDesc(DiagPRowId)   ？？？
	.;w DiagPRowId,!
	.Quit:((desc="")||(desc="无")||(desc["="))
	.s MRDiagnosTypeDesc=""
	.s MRDiagnosTypeDr=""
	.S SubRowid=$G(^MR(mradm,"DIA",sub,"TYP",0))
	.s:SubRowid'="" MRDiagnosTypeDr=$G(^MR(mradm,"DIA",sub,"TYP",SubRowid))
	.I MRDiagnosTypeDr'="" Set MRDiagnosTypeDesc=$P($G(^MRC("DTYP",MRDiagnosTypeDr)),"^",2)
	.s DiagStat=""
	.s DiagStatDr=$p($g(^MR(mradm,"DIA",sub)),"^",9)
	.if DiagStatDr'="" s DiagStat=$p($g(^MRC("DSTAT",DiagStatDr)),"^",2)
	.if ret="" s ret=desc_"^"_DIADate_"^"_MRDiagnosTypeDesc_"^"_DiagStat
	.else  s ret=ret_"&"_desc_"^"_DIADate_"^"_MRDiagnosTypeDesc_"^"_DiagStat
	Quit ret
}

/// Creator：高姗姗
/// CreatDate: 2019-12-10
/// Description：导出病案首页诊断
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnosSettle).ExportEMRDiag("2017-01-01","2019-11-30") 
ClassMethod ExportEMRDiag(DateFrom As %String, DateTo As %String) As %String
{
   k ^TMPSDSDIAGNOS("ExportMRDiagDate")
   k ^TMPSDSDIAGNOS("ExportMRDateDiag")
   s DateFrom=$ZDH(DateFrom,3)
   s DateTo=$ZDH(DateTo,3)
   s Num=0 
   f Date=DateFrom:1:DateTo d
   .s AdmRowid=0 f  s AdmRowid=$o(^PAADMi("PAADM_AdmDate",Date,AdmRowid)) q:AdmRowid=""  d   // UpdDate yx 20140421
   ..s AdmType=$p(^PAADM(AdmRowid),"^",2)
   ..q:AdmType'="I" //住院
   ..s AdmStatus=$p(^PAADM(AdmRowid),"^",20)
   ..q:((AdmStatus'="D")&&(AdmStatus'="A"))	//出院/在院 
   ..;;患者基本信息
   ..s PAPMIID=$P($G(^PAADM(AdmRowid)),"^",1)
   ..s Name=$p(^PAPER(PAPMIID,"ALL"),"^",1) ;姓名
   ..s DOB=+$p(^PAPER(PAPMIID,"ALL"),"^",6) ;出生日期
   ..s Sex=+$p(^PAPER(PAPMIID,"ALL"),"^",7) ;性别
   ..s Sex=$P($G(^CT("SEX",Sex)),"^",2)
   ..s:DOB'="" DOB=$ZD(DOB,3)
   ..s PatNo=$p(^PAPER(PAPMIID,"PAT",1),"^",2) ;登记号
   ..s patDep=$P($G(^PAADM(AdmRowid)),"^",4)
   ..i patDep'="" s CTLocDesc=$P($G(^CTLOC(patDep)),"^",2)  ;就诊科室
   ..;s AdmReasonId=$p(^PAADM(AdmRowid,1),"^",7)
   ..;i AdmReasonId'="" s AdmReason=$p(^PAC("ADMREA",AdmReasonId),"^",2) ;费别
   ..s arr = ##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(AdmRowid,"HDSD00.11","")
   ..q:arr=""
   ..s DiagDate=arr.GetAt("HDSD00.11.019") //出院日期
   ..s:DiagDate="" DiagDate=arr.GetAt("HDSD00.11.085") //入院日期
   ..q:DiagDate=""
   ..s DiagDate=$p(DiagDate," ",1) //本地
   ..;s DiagDate=$p(DiagDate,"T",1) //腾讯云
   ..;s DiagDate=$e(DiagDate,1,4)_"-"_$e(DiagDate,5,6)_"-"_$e(DiagDate,7,8)
   ..//主要诊断^其他诊断^其他诊断2^诊断3^……^诊断26
   ..s DiagCodeStr="HDSD00.11.024^HDSD00.11.021^HDSD00.11.306^HDSD00.11.310^HDSD00.11.314^HDSD00.11.318^HDSD00.11.322^HDSD00.11.326^HDSD00.11.330^HDSD00.11.334^HDSD00.11.338^HDSD00.11.342^HDSD00.11.346^HDSD00.11.350^HDSD00.11.354^HDSD00.11.358^HDSD00.11.362^HDSD00.11.366^HDSD00.11.370^HDSD00.11.374^HDSD00.11.378^HDSD00.11.382^HDSD00.11.386^HDSD00.11.390^HDSD00.11.394^HDSD00.11.398^HDSD00.11.402"
   ..s DiagLen=$Length(DiagCodeStr,"^")
   ..f i=1:1:DiagLen d
   ...s DiagCode=$p(DiagCodeStr,"^",i)
   ...s DiagDesc=arr.GetAt(DiagCode)  
   ...q:DiagDesc=""
   ...q:$d(^TMPSDSDIAGNOS("ExportMRDiagDate",PatNo,DiagDesc)) //去重，保留最近日期诊断
   ...s Num=Num+1
   ...w Num,!
   ...s DiagType="初步诊断"
   ...s DiagStatus="待诊"
   ...s ^TMPSDSDIAGNOS("ExportMRDiagDate",PatNo,DiagDesc,DiagDate)=DiagType_"^"_DiagStatus //登记号，诊断，日期=类型^状态
   ...s ^TMPSDSDIAGNOS("ExportMRDateDiag",PatNo,DiagDate,DiagDesc)=DiagType_"^"_DiagStatus //登记号，日期，诊断=类型^状态
   q "ok"
}

/// Other: w ##class(web.DHCBL.MKB.SDSDiagnosSettle).ExportZLDiagToCSV() 
ClassMethod ExportZLDiagToCSV() As %String
{
	;一个excel最多显示1048576行
	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1)
	s Date=$zd($p($h,",",1),3)
	
	s P1=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\医大一整理诊断(1)"_Date_".csv"
	s file1=##class(%File).%New(P1)  
	d file1.Open("NWS")
	d file1.Write("患者登记号,"_"诊断日期,"_"原始诊断,"_"结构化诊断")
	d file1.WriteLine()
	
	s P2=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\医大一整理诊断(2)"_Date_".csv"
	s file2=##class(%File).%New(P2)  
	d file2.Open("NWS")
	d file2.Write("患者登记号,"_"诊断日期,"_"原始诊断,"_"结构化诊断")
	d file2.WriteLine()
	
	s num=0
	s PatNo=""
	for {
		s PatNo=$o(^TMPSDSDIAGNOS("ExportMRDateDiag",PatNo)) q:PatNo=""
		s PMIDR=##class(web.DHCBL.MKB.SDSPatMas).SaveData(PatNo)
		s DiagDate=""
		for {
			s DiagDate=$o(^TMPSDSDIAGNOS("ExportMRDateDiag",PatNo,DiagDate)) q:DiagDate=""
			s DiagDesc=""
			for {
				s DiagDesc=$o(^TMPSDSDIAGNOS("ExportMRDateDiag",PatNo,DiagDate,DiagDesc)) q:DiagDesc=""
				s OtherInfo=$G(^TMPSDSDIAGNOS("ExportMRDateDiag",PatNo,DiagDate,DiagDesc))
				s DiagType=$p(OtherInfo,"^",1)
				s DiagStatus=$p(OtherInfo,"^",2)
				
				;调用数据处理工厂接口
				s wordVersion=##class(web.DHCBL.MKB.SDSDiagnos).GetWordVersion()
				s resFactory=##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GetSameDiag(wordVersion,DiagDesc)
				if (resFactory=""){
					s DisplayName=""
				}else{
					s TermDR=$p(resFactory,"^",4)
					s Value=$p(resFactory,"^",5)
					s Supplement=$p(resFactory,"^",6)
					s DisplayName=##class(web.DHCBL.MKB.MKBStructuredData).StdGetChiForNewSeqStrucIDs(Value,TermDR)
					if (Supplement'=""){
						s DisplayName=$p(DisplayName,"]",1)
						s DisplayName=DisplayName_"("_Supplement_")]"
					}
					s DisplayName=$tr(DisplayName,",","，")
				}
				if (num<999999){
					d file1.Write(PatNo_",")
					d file1.Write(DiagDate_",")
					d file1.Write(DiagDesc_",")
					d file1.Write(DisplayName)
					d file1.WriteLine()
				}else{
					d file2.Write(PatNo_",")
					d file2.Write(DiagDate_",")
					d file2.Write(DiagDesc_",")
					d file2.Write(DisplayName)
					d file2.WriteLine()
				}
				s num=num+1
				w num,!
			}
		}		
	}
	d file1.%Save()
	d file1.%Close()
	
	d file2.%Save()
	d file2.%Close()
	q "ok"
}

ClassMethod KillDiagGlobal()
{
	;w ##class(web.DHCBL.MKB.SDSDiagnosSettle).KillDiagGlobal()

	k ^User.SDSAdmD
	k ^User.SDSAdmI
	k ^User.SDSPatMasD
	k ^User.SDSPatMasI
	k ^User.SDSAssessmentD
	k ^User.SDSAssessmentI
	k ^User.SDSDiagnosD
	k ^User.SDSDiagnosI
	k ^User.SDSDiagnosDelLogD
	k ^User.SDSDiagnosDelLogI
	k ^User.SDSDiagnosLinkD
	k ^User.SDSDiagnosLinkI
	k ^User.SDSDiagnosLogD
	k ^User.SDSDiagnosLogI
	k ^User.SDSDiagnosPropertyI
 	
	q "ok"
}

}
