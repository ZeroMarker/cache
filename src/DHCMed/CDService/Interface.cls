/// 名称: DHCMed.CDService.Interface
/// 描述: 慢病接口
/// 编写者：jiangpengpeng
/// 编写日期: 2015-11-20
Class DHCMed.CDService.Interface Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// 获取Http服务器信息
/// Trakcare的服务器，不是Medtrak的
/// 	w ##Class(DHCMed.CDService.PrintService).GetServerInfo()
ClassMethod GetServerInfo()
{
	n
    Set CurrentNS=$ZNSPACE
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    //Set Server=Config.WebServer
    Set Server=$p(Config.LayoutManager,":",2)
    Set Path=Config.PathToReports
    Set LayOutManager=Config.LayoutManager
    Set WebServerAppURL = "http://"_Config.WebServer_Config.PathToApp //Modified By LiYang 2008-10-08 获取CSP服务器的IP地址以及程序路径
   // Set WebServerAppURL = "http://127.0.0.1"_Config.PathToApp //Modified By LiYang 2008-10-08 获取CSP服务器的IP地址以及程序路径
    d Config.%Close()
    s s=CurrentNS_$c(1)_MEDDATA_$c(1)_LABDATA_$c(1)_Server_$c(1)_Path_$c(1)_LayOutManager_$C(1)_WebServerAppURL
	q s
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-11-23
/// Description:  取医院编号
/// Table：       
/// Input：       
/// w ##class(DHCMed.CDService.Interface).GetHospCode("H")
ClassMethod GetHospCode(aType As %String) As %String
{
	New (aType)
	Quit:aType="" " "
	
	Set HospID="330802001"
	Set Date=$zd(+$H,3)
	Set Date=$tr(Date,"-","")
	If (aType="H") {
		Set HospInd=$i(^DHCMed.CD.Interface("HOSP"))
	}Else{
		Set HospInd=$g(^DHCMed.CD.Interface("HOSP"))
	}
	Set IndLen=6
	Set IndCode=""
	If (IndLen>$l(HospInd)) {
		set $p(IndCode,"0",IndLen+1-$l(HospInd))=HospInd
	}Else{
		Set IndCode=HospInd
	}
	Quit HospID_"-"_Date_"-"_IndCode
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-11-20
/// Description:  到处肿瘤报告主体信息
/// Table：       DHCMed.CD.CRReport
/// Input：       
/// w ##class(DHCMed.CDService.Interface).ExportZLKRepInfo("fillxlSheet","^6^9")
ClassMethod ExportZLKRepInfo(itmjs As %String, aRepIDStr As %String) As %String
{
	New (itmjs,aRepIDStr)
	Set return=""
	Quit:aRepIDStr="" return
	
	Set StartRow=2
	For ind=1:1:$l(aRepIDStr,"^") {
		Set xRepID=$p(aRepIDStr,"^",ind)
		//Continue:xRepID=""
		
		Set objRep=##class(DHCMed.CD.CRReport).GetObjById(xRepID)
		Continue:'$IsObject(objRep)
		Continue:objRep.CRReportType.CRFCode'="ZLK"
		Set EpisodeID=objRep.CREpisodeID
		
		Set objChild=##class(DHCMed.CD.CRReportZLK).GetObjByParRef(xRepID)
		Continue:'$IsObject(objChild)
		
		Set (HospCode,MZH,MrNo,PatID,ReportOrgan,ReportUser,ReportDate,CheckFlag)=""
		Set (BLH,BLXLX,BQYGZBR,BSZY,FHCD,JTSWYY,KPBH,SCZDRQ,SS,SSICD)=""
		Set (SWRQ,SWXXW,SWYY,SWZD,SYICD,TNMFQM,TNMFQN,TNMFQT)=""
		Set (XTX,XTXICD,YFBW,YZD,YZDICD,YZDRQ,ZD,ZDBW,ZDICD,ZDRQ,ZDYJ,ZGZDDW,ZGZDYJ)=""
		
		Set HospCode=..GetHospCode("H")	//"331082001-20120101-0001"
		Set objPat=##class(DHCMed.CD.CRReportPAT).GetObjByParRef(xRepID)
		If ($IsObject(objPat)) {
			Set MZH=objPat.CRDJH
		}
		Set MrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,"I","")
		Set PatID=""
		Set ReportOrgan="331082001"
		Set ReportUser=objRep.CRReportUser
		Set ReportDate=objRep.CRReportDate
		Set:ReportDate'="" ReportDate=$zd(ReportDate,3)
		Set CheckFlag=0
		Set:objRep.CRReportStatus.Description="审核" CheckFlag=1
		
		
		Set BLH=objChild.CRBLH
		Set BLXLX=objChild.CRBLXLX
		Set BQYGZBR=objChild.CRBQYGZBR.Code
		Set BSZY=objChild.CRBSZY
		Set FHCD=objChild.CRFHCD.Code
		Set JTSWYY=objChild.CRJTSWYY
		Set KPBH=objChild.CRKPBH
		Set SCZDRQ=objChild.CRSCZDRQ
		Set:SCZDRQ'="" SCZDRQ=$zd(SCZDRQ,3)
		Set SWRQ=objChild.CRSWRQ
		Set:SWRQ'="" SWRQ=$zd(SWRQ,3)
		Set SWYY=objChild.CRSWYY.Code
		Set SYICD=objChild.CRSYICD
		If (SYICD'="") {
			Set SYICD1=$p(SYICD,".",1)
			Set SYICD2=$p(SYICD,".",2)
			Set:SYICD2'="" SYICD2=$e(SYICD2,1,1)
			Set SYICD=SYICD1_"."_SYICD2
		}
		Set TNMFQM=objChild.CRTNMFQM.Code
		Set TNMFQN=objChild.CRTNMFQN.Code
		Set TNMFQT=objChild.CRTNMFQT.Code
		Set YZD=objChild.CRYZD
		/*
		Set tmp=""
		Set:YZD'="" tmp=$g(^MRC("ID",YZD))
		Set:tmp'="" YZD=$p(tmp,"^",2)
	    */
	    Set objICDDx = ##class(DHCMed.CD.CRICDDx).GetObjById(objChild.CRYZD)
		If ($IsObject(objICDDx)) {
			Set YZD = objICDDx.CRFullName
		}
		Set YZDICD=objChild.CRYZDICD
		If (YZDICD'="") {
			Set YZDICD1=$p(YZDICD,".",1)
			Set YZDICD2=$p(YZDICD,".",2)
			Set:YZDICD2'="" YZDICD2=$e(YZDICD2,1,1)
			Set YZDICD=YZDICD1_"."_YZDICD2
		}
		Set YZDRQ=objChild.CRYZDRQ
		Set:YZDRQ'="" YZDRQ=$zd(YZDRQ,3)
		Set ZD=objChild.CRZD
		/*
		Set tmp=""
		Set:ZD'="" tmp=$g(^MRC("ID",ZD))
		Set:tmp'="" ZD=$p(tmp,"^",2)
		*/
		Set objICDDx = ##class(DHCMed.CD.CRICDDx).GetObjById(objChild.CRZD)
		If ($IsObject(objICDDx)) {
			Set ZD = objICDDx.CRFullName
		}
		Set ZDBW=objChild.CRZDBW
		Set ZDICD=objChild.CRZDICD
		If (ZDICD'="") {
			Set ZDICD1=$p(ZDICD,".",1)
			Set ZDICD2=$p(ZDICD,".",2)
			Set:ZDICD2'="" ZDICD2=$e(ZDICD2,1,1)
			Set ZDICD=ZDICD1_"."_ZDICD2
		}
		Set ZDRQ=objChild.CRZDRQ
		Set:ZDRQ'="" ZDRQ=$zd(ZDRQ,3)
		Set ZDYJ=objChild.CRZDYJ
		Set ZDYJstr=""
		For indz=1:1:ZDYJ.Count() {
			Set objDic=ZDYJ.GetAt(indz)
			Continue:'$IsObject(objDic)
			Set ZDYJstr=ZDYJstr_","_objDic.Code
		}
		Set:ZDYJstr'="" ZDYJstr=$e(ZDYJstr,2,$l(ZDYJstr))
		
		Set ZGZDDW=objChild.CRZGZDDW.Code
		
		Set XX=""
		Set data=$lb(HospCode,BQYGZBR,MZH,MrNo,PatID,XX,XX,XX,XX,ZDICD,ZDBW,BLXLX,BLH)
		Set data=data_$lb(FHCD,TNMFQT,TNMFQN,TNMFQM,YZDRQ,ZDRQ,ZGZDDW,YZD,ReportOrgan)
		Set data=data_$lb(ReportUser,ReportDate,SWRQ,SWYY,SYICD,ZDYJstr,BSZY,JTSWYY,CheckFlag)
		
		for jnd=1:1:31 {
			Set retval=itmjs_"(xlSheet,'"_$ZCVT($list(data,jnd),"O","JS")_"',"_StartRow_","_jnd_");"
			&javascript<#(retval)#>
		}
		
		Set StartRow=StartRow+1
	}
	Set return=StartRow-1
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-11-20
/// Description:  到处肿瘤报告患者信息
/// Table：       DHCMed.CD.CRReport
/// Input：       
/// w ##class(DHCMed.CDService.Interface).ExportZLKPatInfo("fillxlSheet","^6^9")
ClassMethod ExportZLKPatInfo(itmjs As %String, aRepIDStr As %String) As %String
{
	New (itmjs,aRepIDStr)
	Set return=""
	Quit:aRepIDStr="" return
	
	Set StartRow=2
	For ind=1:1:$l(aRepIDStr,"^") {
		Set xRepID=$p(aRepIDStr,"^",ind)
		//Continue:xRepID=""
		
		Set objRep=##class(DHCMed.CD.CRReport).GetObjById(xRepID)
		Continue:'$IsObject(objRep)
		Continue:objRep.CRReportType.CRFCode'="ZLK"
		
		Set objPat=##class(DHCMed.CD.CRReportPAT).GetObjByParRef(xRepID)
		Continue:'$IsObject(objPat)
		
		Set (PatID,CRXM,CRXB,CRMZ,CRCSRQ,CRSFZH,CRLXDH,CRZY,CRGZDW)=""
		Set (CRGZ,CRHJDZS,CRHJDZS2,CRHJDZX,CRHJDZX2,CRHJDZC,CRHJDZXX)=""
		Set (SCRCZDZS,CRCZDZS2,CRCZDZX,CRCZDZX2,CRCZDZC,CRCZDZXX)=""
		
		Set PatID=..GetHospCode("P")	//"331082001-20120101-0001"
		
		Set CRXM=objPat.CRXM
		Set CRXB=objPat.CRXB
		Set:CRXB="男" CRXB=1
		Set:CRXB="女" CRXB=2
		Set CRMZ=objPat.CRMZ.Code
		Set CRCSRQ=objPat.CRCSRQ
		Set:CRCSRQ'="" CRCSRQ=$zd(CRCSRQ,3)
		Set CRSFZH=objPat.CRSFZH
		Set CRLXDH=objPat.CRLXDH
		Set CRZY=objPat.CRZY.Code
		Set CRGZDW=objPat.CRGZDW
		Set CRGZ=objPat.CRGZ.Code
		Set CRHJDZS=objPat.CRHJDZS.Code
		Set CRHJDZS2=objPat.CRHJDZS2.Code
		Set CRHJDZX=objPat.CRHJDZX.Code
		Set CRHJDZX2=objPat.CRHJDZX2.Code
		Set CRHJDZC=objPat.CRHJDZC
		Set CRHJDZXX=objPat.CRHJDZXX
		Set CRCZDZS=objPat.CRCZDZS.Code
		Set CRCZDZS2=objPat.CRCZDZS2.Code
		Set CRCZDZX=objPat.CRCZDZX.Code
		Set CRCZDZX2=objPat.CRCZDZX2.Code
		Set CRCZDZC=objPat.CRCZDZC
		Set CRCZDZXX=objPat.CRCZDZXX

		
		Set data=$lb(PatID,CRXM,CRXB,CRMZ,CRCSRQ,CRSFZH,CRLXDH,CRZY,CRGZDW)
		Set data=data_$lb(CRGZ,CRHJDZS,CRHJDZS2,CRHJDZX,CRHJDZX2,CRHJDZC,CRHJDZXX)
		Set data=data_$lb(SCRCZDZS,CRCZDZS2,CRCZDZX,CRCZDZX2,CRCZDZC,CRCZDZXX)
		
		for jnd=1:1:21 {
			Set retval=itmjs_"(xlSheet,'"_$ZCVT($list(data,jnd),"O","JS")_"',"_StartRow_","_jnd_");"
			&javascript<#(retval)#>
		}
		
		Set StartRow=StartRow+1
	}
	Set return=StartRow-1
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-11-24
/// Description:  导出糖尿病报告主体信息
/// Table：       DHCMed.CD.CRReport
/// Input：       
/// w ##class(DHCMed.CDService.Interface).ExportTNBRepInfo("fillxlSheet","^5")
ClassMethod ExportTNBRepInfo(itmjs As %String, aRepIDStr As %String) As %String
{
	New (itmjs,aRepIDStr)
	Set return=""
	Quit:aRepIDStr="" return
	
	Set StartRow=2
	For ind=1:1:$l(aRepIDStr,"^") {
		Set xRepID=$p(aRepIDStr,"^",ind)
		//Continue:xRepID=""
		
		Set objRep=##class(DHCMed.CD.CRReport).GetObjById(xRepID)
		Continue:'$IsObject(objRep)
		Continue:objRep.CRReportType.CRFCode'="TNB"
		Set EpisodeID=objRep.CREpisodeID
		
		Set objChild=##class(DHCMed.CD.CRReportTNB).GetObjByParRef(xRepID)
		Continue:'$IsObject(objChild)
		
		Set (HospCode,MZH,MrNo,PatID,ReportOrgan,ReportUser,ReportDate,CheckFlag)=""
		Set (CRZDICD,CRZDLX,CRWHYS,CRTZ,CRSG,CRJZS,CRRS,CRBFZ,CRLCBX,CRQTLCBX)=""
		Set (CRZYJCQK1,CRZYJCQK2,CRZYJCQK3,CRZYJCQK4,CRZYJCQK5,CRZYJCQK6)=""
		Set (CRZYJCQK7,CRZYJCQK8,CRZYJCQK9,XX,CRZDRQ,CRZGZDDW,CRSWRQ,CRSWYY,CRSWICD,CRJTSWYY)=""
		
		Set HospCode=..GetHospCode("H")	//"331082001-20120101-0001"
		Set objPat=##class(DHCMed.CD.CRReportPAT).GetObjByParRef(xRepID)
		If ($IsObject(objPat)) {
			Set MZH=objPat.CRDJH
		}
		Set MrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,"I","")
		Set PatID=..GetHospCode("P")
		Set ReportOrgan="331082001"
		Set ReportUser=objRep.CRReportUser
		Set ReportDate=objRep.CRReportDate
		Set:ReportDate'="" ReportDate=$zd(ReportDate,3)
		Set CheckFlag=0
		Set:objRep.CRReportStatus.Description="审核" CheckFlag=1
		
		
		Set CRZDICD=objChild.CRZDICD
		If (CRZDICD'="") {
			Set CRZDICD1=$p(CRZDICD,".",1)
			Set CRZDICD2=$p(CRZDICD,".",2)
			Set:CRZDICD2'="" CRZDICD2=$e(CRZDICD2,1,1)
			Set CRZDICD=CRZDICD1_"."_CRZDICD2
		}
		Set CRZDLX=objChild.CRZDLX.Code
		Set CRWHYS=objChild.CRWHYS
		Set WHYSstr=""
		For indw=1:1:CRWHYS.Count() {
			Set objDic=CRWHYS.GetAt(indw)
			Continue:'$IsObject(objDic)
			Set WHYSstr=WHYSstr_","_objDic.Code
		}
		Set:WHYSstr'="" WHYSstr=$e(WHYSstr,2,$l(WHYSstr))
		Set CRWHYS=WHYSstr
		
		Set CRTZ=objChild.CRTZ
		Set CRSG=objChild.CRSG
		Set CRJZS=objChild.CRJZS
		Set JZSstr=""
		For indj=1:1:CRJZS.Count() {
			Set objDic=CRJZS.GetAt(indj)
			Continue:'$IsObject(objDic)
			Set JZSstr=JZSstr_","_objDic.Code
		}
		Set:JZSstr'="" JZSstr=$e(JZSstr,2,$l(JZSstr))
		Set CRJZS=JZSstr
		
		Set CRRS=objChild.CRRS
		Set CRBFZ=objChild.CRBFZ
		Set BFZstr=""
		For indb=1:1:CRBFZ.Count() {
			Set objDic=CRBFZ.GetAt(indb)
			Continue:'$IsObject(objDic)
			Set BFZstr=BFZstr_","_objDic.Code
		}
		Set:BFZstr'="" BFZstr=$e(BFZstr,2,$l(BFZstr))
		Set CRBFZ=BFZstr
		
		Set CRLCBX=objChild.CRLCBX
		Set LCBXstr=""
		For indl=1:1:CRLCBX.Count() {
			Set objDic=CRLCBX.GetAt(indl)
			Continue:'$IsObject(objDic)
			Set LCBXstr=LCBXstr_","_objDic.%Id()
		}
		Set:LCBXstr'="" LCBXstr=$e(LCBXstr,2,$l(LCBXstr))
		Set CRLCBX=LCBXstr
		
		Set CRQTLCBX=objChild.CRQTLCBX
		Set CRZYJCQK1=objChild.CRZYJCQK1
		Set CRZYJCQK2=objChild.CRZYJCQK2
		Set CRZYJCQK3=objChild.CRZYJCQK3
		Set CRZYJCQK4=objChild.CRZYJCQK4
		Set CRZYJCQK5=objChild.CRZYJCQK5
		Set CRZYJCQK6=objChild.CRZYJCQK6
		Set CRZYJCQK7=objChild.CRZYJCQK7
		Set CRZYJCQK8=objChild.CRZYJCQK8
		Set CRZYJCQK9=objChild.CRZYJCQK9

		Set CRZDRQ=objChild.CRZDRQ
		Set:CRZDRQ'="" CRZDRQ=$zd(CRZDRQ,3)
		Set CRZGZDDW=objChild.CRZGZDDW.Code
		Set CRSWRQ=objChild.CRSWRQ
		Set:CRSWRQ'="" CRSWRQ=$zd(CRSWRQ,3)
		Set CRSWYY=objChild.CRSWYY.Code
		Set CRSWICD=objChild.CRSYICD
		If (CRSWICD'="") {
			Set CRSWICD1=$p(CRSWICD,".",1)
			Set CRSWICD2=$p(CRSWICD,".",2)
			Set:CRSWICD2'="" CRSWICD2=$e(CRSWICD2,1,1)
			Set CRSWICD=CRSWICD1_"."_CRSWICD2
		}
		Set CRJTSWYY=objChild.CRJTSWYY
		
		Set XX=""
		Set data=$lb(HospCode,CRZDICD,CRZDLX,CRWHYS,CRTZ,CRSG,CRJZS,CRRS,CRBFZ,CRLCBX,CRQTLCBX)
		Set data=data_$lb(CRZYJCQK1,CRZYJCQK2,CRZYJCQK3,CRZYJCQK4,CRZYJCQK5,CRZYJCQK6)
		Set data=data_$lb(CRZYJCQK7,CRZYJCQK8,CRZYJCQK9,XX,CRZDRQ,CRZGZDDW,ReportOrgan,ReportUser,ReportDate,CRSWRQ,CRSWYY,CRSWICD,CRJTSWYY)
		Set data=data_$lb(PatID,MrNo,MZH,CheckFlag)
		
		for jnd=1:1:34 {
			Set retval=itmjs_"(xlSheet,'"_$ZCVT($list(data,jnd),"O","JS")_"',"_StartRow_","_jnd_");"
			&javascript<#(retval)#>
		}
		
		Set StartRow=StartRow+1
	}
	Set return=StartRow-1
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-11-24
/// Description:  导出糖尿病报报告患者信息
/// Table：       DHCMed.CD.CRReport
/// Input：       
/// w ##class(DHCMed.CDService.Interface).ExportTNBPatInfo("fillxlSheet","^13")
ClassMethod ExportTNBPatInfo(itmjs As %String, aRepIDStr As %String) As %String
{
	New (itmjs,aRepIDStr)
	Set return=""
	Quit:aRepIDStr="" return
	
	Set StartRow=2
	For ind=1:1:$l(aRepIDStr,"^") {
		Set xRepID=$p(aRepIDStr,"^",ind)
		//Continue:xRepID=""
		
		Set objRep=##class(DHCMed.CD.CRReport).GetObjById(xRepID)
		Continue:'$IsObject(objRep)
		Continue:objRep.CRReportType.CRFCode'="TNB"
		
		Set objPat=##class(DHCMed.CD.CRReportPAT).GetObjByParRef(xRepID)
		Continue:'$IsObject(objPat)
		
		Set (PatID,CRXM,CRXB,CRMZ,CRWHCD,CRCSRQ,CRSFZH,CRLXDH,CRZY)=""
		Set (CRGZ,CRGZDW,CRHJDZS,CRHJDZS2,CRHJDZX,CRHJDZX2,CRHJDZC,CRHJDZXX)=""
		Set (SCRCZDZS,CRCZDZS2,CRCZDZX,CRCZDZX2,CRCZDZC,CRCZDZXX)=""
		
		Set PatID=..GetHospCode("P")	//"331082001-20120101-0001"
		
		Set CRXM=objPat.CRXM
		Set CRXB=objPat.CRXB
		Set:CRXB="男" CRXB=1
		Set:CRXB="女" CRXB=2
		Set CRMZ=objPat.CRMZ.Code
		Set CRWHCD=objPat.CRWHCD.Code
		Set CRCSRQ=objPat.CRCSRQ
		Set:CRCSRQ'="" CRCSRQ=$zd(CRCSRQ,3)
		Set CRSFZH=objPat.CRSFZH
		Set CRLXDH=objPat.CRJTDH
		Set CRZY=objPat.CRZY.Code
		Set CRGZDW=objPat.CRGZDW
		Set CRGZ=objPat.CRGZ.Code
		Set CRHJDZS=objPat.CRHJDZS.Code
		Set CRHJDZS2=objPat.CRHJDZS2.Code
		Set CRHJDZX=objPat.CRHJDZX.Code
		Set CRHJDZX2=objPat.CRHJDZX2.Code
		Set CRHJDZC=objPat.CRHJDZC
		Set CRHJDZXX=objPat.CRHJDZXX
		Set CRCZDZS=objPat.CRCZDZS.Code
		Set CRCZDZS2=objPat.CRCZDZS2.Code
		Set CRCZDZX=objPat.CRCZDZX.Code
		Set CRCZDZX2=objPat.CRCZDZX2.Code
		Set CRCZDZC=objPat.CRCZDZC
		Set CRCZDZXX=objPat.CRCZDZXX

		
		Set data=$lb(PatID,CRXM,CRXB,CRMZ,CRWHCD,CRCSRQ,CRSFZH,CRLXDH,CRZY)
		Set data=data_$lb(CRGZ,CRGZDW,CRHJDZS,CRHJDZS2,CRHJDZX,CRHJDZX2,CRHJDZC,CRHJDZXX)
		Set data=data_$lb(CRCZDZS,CRCZDZS2,CRCZDZX,CRCZDZX2,CRCZDZC,CRCZDZXX)
		
		for jnd=1:1:23 {
			Set retval=itmjs_"(xlSheet,'"_$ZCVT($list(data,jnd),"O","JS")_"',"_StartRow_","_jnd_");"
			&javascript<#(retval)#>
		}
		
		Set StartRow=StartRow+1
	}
	Set return=StartRow-1
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-11-24
/// Description:  导出心脑血管报告主体信息
/// Table：       DHCMed.CD.CRReport
/// Input：       
/// w ##class(DHCMed.CDService.Interface).ExportXNXGRepInfo("fillxlSheet","^7")
ClassMethod ExportXNXGRepInfo(itmjs As %String, aRepIDStr As %String) As %String
{
	New (itmjs,aRepIDStr)
	Set return=""
	Quit:aRepIDStr="" return
	
	Set StartRow=2
	For ind=1:1:$l(aRepIDStr,"^") {
		Set xRepID=$p(aRepIDStr,"^",ind)
		//Continue:xRepID=""
		
		Set objRep=##class(DHCMed.CD.CRReport).GetObjById(xRepID)
		Continue:'$IsObject(objRep)
		Continue:objRep.CRReportType.CRFCode'="XNXG"
		Set EpisodeID=objRep.CREpisodeID
		
		Set objChild=##class(DHCMed.CD.CRReportXNXG).GetObjByParRef(xRepID)
		Continue:'$IsObject(objChild)
		
		Set (HospCode,MZH,MrNo,CRXM,CRXB,CRHYZK,CRZDBM,CRCSRQ,CRZY,CRGZ)=""
		Set (CRSFZH,CRWHCD,CRMZ,CRLXDH,CRGZDW,CRHJDZS,CRHJDZS2,CRHJDZX)=""
		Set (CRHJDZX2,CRHJDZC,CRHJDZXX,CRCZDZS,CRCZDZS2,CRCZDZX,CRCZDZX2)=""
		Set (CRCZDZC,CRCZDZXX,CRZDMC1,CRZDMC2,CRZDYJ1,CRZDYJ2,CRZDYJ3,CRZDYJ4)=""
		Set (CRZDYJ5,CRZDYJ6,CRZDYJ7,CRZDYJ8,CRZDYJ9,CRZDYJ10,CRBS,CRSHTD,CRSJJG)=""
		Set (CRSYZZ,CRFBRQ,CRQZRQ,CRSFSCFB,CRQZDW,ReportOrgan,ReportUser,ReportDate)=""
		Set (CRSWRQ,CRSWYY,CRSYBM,CRSYMC,CRBSZY,CheckFlag)=""
		
		Set HospCode=..GetHospCode("H")	//"331082001-20120101-0001"
		Set objPat=##class(DHCMed.CD.CRReportPAT).GetObjByParRef(xRepID)
		If ($IsObject(objPat)) {
			Set MZH=objPat.CRDJH
		}
		Set MrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,"I","")
		Set PatID=..GetHospCode("P")
		Set ReportOrgan="331082001"
		Set ReportUser=objRep.CRReportUser
		Set ReportDate=objRep.CRReportDate
		Set:ReportDate'="" ReportDate=$zd(ReportDate,3)
		Set CheckFlag=0
		Set:objRep.CRReportStatus.Description="审核" CheckFlag=1
		
		Set CRXM=objPat.CRXM
		Set CRXB=objPat.CRXB
		Set:CRXB="男" CRXB=1
		Set:CRXB="女" CRXB=2
		Set CRHYZK=objPat.CRHYZK.Code
		Set CRMZ=objPat.CRMZ.Code
		Set CRWHCD=objPat.CRWHCD.Code
		Set CRCSRQ=objPat.CRCSRQ
		Set:CRCSRQ'="" CRCSRQ=$zd(CRCSRQ,3)
		Set CRSFZH=objPat.CRSFZH
		Set CRLXDH=objPat.CRLXDH
		Set CRZY=objPat.CRZY.Code
		Set CRGZDW=objPat.CRGZDW
		Set CRGZ=objPat.CRGZ.Code
		Set CRHJDZS=objPat.CRHJDZS.Code
		Set CRHJDZS2=objPat.CRHJDZS2.Code
		Set CRHJDZX=objPat.CRHJDZX.Code
		Set CRHJDZX2=objPat.CRHJDZX2.Code
		Set CRHJDZC=objPat.CRHJDZC
		Set CRHJDZXX=objPat.CRHJDZXX
		Set CRCZDZS=objPat.CRCZDZS.Code
		Set CRCZDZS2=objPat.CRCZDZS2.Code
		Set CRCZDZX=objPat.CRCZDZX.Code
		Set CRCZDZX2=objPat.CRCZDZX2.Code
		Set CRCZDZC=objPat.CRCZDZC
		Set CRCZDZXX=objPat.CRCZDZXX
		
		Set CRZDBM=objChild.CRZDBM
		If (CRZDBM'="") {
			Set CRZDBM1=$p(CRZDBM,".",1)
			Set CRZDBM2=$p(CRZDBM,".",2)
			Set:CRZDBM2'="" CRZDBM2=$e(CRZDBM2,1,1)
			Set CRZDBM=CRZDBM1_"."_CRZDBM2
		}
		Set CRZDMC=objChild.CRZDMC
		Set ZDType=$p(CRZDMC,"-",2)
		Set:ZDType="GXB" CRZDMC1=$p(CRZDMC,"-",1)
		Set:ZDType="NCZ" CRZDMC2=$p(CRZDMC,"-",1)
		
		Set ZDYJ=objChild.CRZDYJ
		Set ZDYJstr=""
		For indz=1:1:ZDYJ.Count() {
			Set objDic=ZDYJ.GetAt(indz)
			Continue:'$IsObject(objDic)
			Set ZDYJstr=ZDYJstr_","_objDic.Code
		}
		Set:ZDYJstr'="" ZDYJstr=$e(ZDYJstr,2,$l(ZDYJstr))
		Set CRZDYJ1=$p(ZDYJstr,",",1)
		Set CRZDYJ2=$p(ZDYJstr,",",3)
		Set CRZDYJ3=$p(ZDYJstr,",",5)
		Set CRZDYJ4=$p(ZDYJstr,",",7)
		Set CRZDYJ5=$p(ZDYJstr,",",9)
		Set CRZDYJ6=$p(ZDYJstr,",",2)
		Set CRZDYJ7=$p(ZDYJstr,",",4)
		Set CRZDYJ8=$p(ZDYJstr,",",6)
		Set CRZDYJ9=$p(ZDYJstr,",",8)
		Set CRZDYJ10=$p(ZDYJstr,",",10)
		Set CRBS=objChild.CRBS
		Set BSstr=""
		For indb=1:1:CRBS.Count() {
			Set objDic=CRBS.GetAt(indb)
			Continue:'$IsObject(objDic)
			Set BSstr=BSstr_","_objDic.Code
		}
		Set:BSstr'="" BSstr=$e(BSstr,2,$l(BSstr))
		Set CRBS=BSstr
		
		Set CRSHTD=objChild.CRSHTD.Code
		Set CRSJJG=objChild.CRSJJG.Code
		Set CRSYZZ=objChild.CRSYZZ
		Set SYZZstr=""
		For inds=1:1:CRSYZZ.Count() {
			Set objDic=CRSYZZ.GetAt(inds)
			Continue:'$IsObject(objDic)
			Set SYZZstr=SYZZstr_","_objDic.Code
		}
		Set:SYZZstr'="" SYZZstr=$e(SYZZstr,2,$l(SYZZstr))
		Set CRSYZZ=SYZZstr
		
		Set CRFBRQ=objChild.CRFBRQ
		Set:CRFBRQ'="" CRFBRQ=$zd(CRFBRQ,3)
		Set CRQZRQ=objChild.CRQZRQ
		Set:CRQZRQ'="" CRFBRQ=$zd(CRQZRQ,3)
		Set CRSFSCFB=objChild.CRSFSCFB
		If (CRSFSCFB) {
			Set CRSFSCFB=1
		}Else{
			Set CRSFSCFB=2
		}
		Set CRQZDW=objChild.CRQZDW.Code
		Set CRSWRQ=objChild.CRSWRQ
		Set:CRSWRQ'="" CRSWRQ=$zd(CRSWRQ,3)
		Set CRSWYY=objChild.CRSWYY.Code
		Set CRSYBM=objChild.CRSYBM
		If (CRSYBM'="") {
			Set CRSYBM1=$p(CRSYBM,".",1)
			Set CRSYBM2=$p(CRSYBM,".",2)
			Set:CRSYBM2'="" CRSYBM2=$e(CRSYBM2,1,1)
			Set CRSYBM=CRSYBM1_"."_CRSYBM2
		}
		Set CRSYMC=objChild.CRSYMC
		Set CRBSZY=objChild.CRBSZY
		
		Set XX=""
		Set data=$lb(HospCode,MZH,MrNo,CRXM,CRXB,CRHYZK,CRZDBM,CRCSRQ,CRZY,CRGZ)
		Set data=data_$lb(CRSFZH,CRWHCD,CRMZ,CRLXDH,CRGZDW,CRHJDZS,CRHJDZS2,CRHJDZX)
		Set data=data_$lb(CRHJDZX2,CRHJDZC,CRHJDZXX,CRCZDZS,CRCZDZS2,CRCZDZX,CRCZDZX2)
		Set data=data_$lb(CRCZDZC,CRCZDZXX,CRZDMC1,CRZDMC2,CRZDYJ1,CRZDYJ2,CRZDYJ3,CRZDYJ4)
		Set data=data_$lb(CRZDYJ5,CRZDYJ6,CRZDYJ7,CRZDYJ8,CRZDYJ9,CRZDYJ10,CRBS,CRSHTD,CRSJJG)
		Set data=data_$lb(CRSYZZ,CRFBRQ,CRQZRQ,CRSFSCFB,CRQZDW,ReportOrgan,ReportUser,ReportDate)
		Set data=data_$lb(CRSWRQ,CRSWYY,CRSYBM,CRSYMC,CRBSZY,CheckFlag)
		
		for jnd=1:1:56 {
			Set retval=itmjs_"(xlSheet,'"_$ZCVT($list(data,jnd),"O","JS")_"',"_StartRow_","_jnd_");"
			&javascript<#(retval)#>
		}
		
		Set StartRow=StartRow+1
	}
	Set return=StartRow-1
	Quit return
}

}
