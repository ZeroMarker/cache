Class DHCMed.CDService.PrintService Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2015-09-11
/// Description:  打印肿瘤报告卡
/// Table：       DHCMed.CD.CRReport
/// Input：       
/// Return：      
/// w ##class(DHCMed.CDService.PrintService).ExportCRRepZLk("fillxlSheet","1")
/// fix bug191725方法名和js中不一致导致无法打印导出
ClassMethod ExportCRRepZLk(itmjs As %String, strArguments As %String) As %String
{
	New (itmjs,strArguments)
	Set Count=0
	
	Set RepID=+$p(strArguments,"^",1)
	Set objRep=##class(DHCMed.CD.CRReport).GetObjById(RepID)
	Quit:'$IsObject(objRep) Count
	Set objPAT=##class(DHCMed.CD.CRReportPAT).GetObjByParRef(RepID)
	Quit:'$IsObject(objPAT) Count
	Set objZLK=##class(DHCMed.CD.CRReportZLK).GetObjByParRef(RepID)
	Quit:'$IsObject(objZLK) Count
	
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objZLK.CRKPBH,"O","JS")_"',3,4);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRDJH,"O","JS")_"',3,14);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objZLK.CRBQYGZBR.Description,"O","JS")_"',3,25);"
	&javascript<#(retval)#>
	
	//病人基本信息
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRXM,"O","JS")_"',5,3);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRSFZH,"O","JS")_"',5,9);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRXB,"O","JS")_"',5,18);"
	&javascript<#(retval)#>
	Set PatAge=""
	If (objPAT.CRNLS'="") {
		Set PatAge=objPAT.CRNLS_"岁"
	} ElseIf (objPAT.CRNLY'="") {
		Set PatAge=objPAT.CRNLS_"月"
	} ElseIf (objPAT.CRNLT'="") {
		Set PatAge=objPAT.CRNLT_"天"
	}
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(PatAge,"O","JS")_"',5,21);"
	&javascript<#(retval)#>
	Set CSRQ=objPAT.CRCSRQ
	Set:CSRQ'="" CSRQ=$zd(CSRQ,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(CSRQ,"O","JS")_"',5,26);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRZY.Description,"O","JS")_"',6,3);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRGZ.Description,"O","JS")_"',6,15);"  //工种改为字典类型
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRMZ.Description,"O","JS")_"',7,3);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRJTDH,"O","JS")_"',7,10);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRGZDW,"O","JS")_"',7,20);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZS.ShortDesc,"O","JS")_"',8,7);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZS2.ShortDesc,"O","JS")_"',8,11);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZX.ShortDesc,"O","JS")_"',8,15);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZX2.ShortDesc,"O","JS")_"',8,19);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZC,"O","JS")_"',8,24);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZXX,"O","JS")_"',9,6);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRHJDZS.ShortDesc,"O","JS")_"',10,7);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRHJDZS2.ShortDesc,"O","JS")_"',10,11);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRHJDZX.ShortDesc,"O","JS")_"',10,15);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRHJDZX2.ShortDesc,"O","JS")_"',10,19);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRHJDZC,"O","JS")_"',10,24);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRHJDZXX,"O","JS")_"',11,6);"
	&javascript<#(retval)#>
	
	//诊断、报告信息
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objZLK.CRZDBW,"O","JS")_"',14,4);"  //诊断部位
	&javascript<#(retval)#>
	Set ZDStr=##class(DHCMed.CD.CRICDDx).GetDescByID(objZLK.CRZD)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(ZDStr,$c(1),2),"O","JS")_"',15,3);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objZLK.CRZDICD,"O","JS")_"',15,15);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objZLK.CRBLXLX,"O","JS")_"',16,5);"
	&javascript<#(retval)#>
	Set YZD=##class(DHCMed.CD.CRICDDx).GetDescByID(objZLK.CRYZD)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(YZD,$c(1),2),"O","JS")_"',16,23);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objZLK.CRBLH,"O","JS")_"',17,4);"
	&javascript<#(retval)#>
	Set YZDRQ=objZLK.CRYZDRQ
	Set:YZDRQ'="" YZDRQ=$zd(YZDRQ,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(YZDRQ,"O","JS")_"',17,24);"
	&javascript<#(retval)#>
	
	//确认时期别
	Set (TNMFQT,TNMFQN,TNMFQM,FHCD)=""
	Set:$IsObject(objZLK.CRTNMFQT) TNMFQT=objZLK.CRTNMFQT.Description
	Set:$IsObject(objZLK.CRTNMFQN) TNMFQN=objZLK.CRTNMFQN.Description
	Set:$IsObject(objZLK.CRTNMFQM) TNMFQM=objZLK.CRTNMFQM.Description
	Set:$IsObject(objZLK.CRFHCD) FHCD=objZLK.CRFHCD.Description
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(TNMFQT,"O","JS")_"',18,6);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(TNMFQN,"O","JS")_"',18,9);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(TNMFQM,"O","JS")_"',18,12);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(FHCD,"O","JS")_"',18,16);"
	&javascript<#(retval)#>
	
	Set ZDRQ=objZLK.CRZDRQ
	Set:ZDRQ'="" ZDRQ=$zd(ZDRQ,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(ZDRQ,"O","JS")_"',19,4);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objZLK.CRZGZDDW.Description,"O","JS")_"',19,13);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.CRReportOrgan,"O","JS")_"',21,4);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.CRReportUser,"O","JS")_"',22,4);"
	&javascript<#(retval)#>
	Set ReportDate=objRep.CRReportDate
	Set:ReportDate'="" ReportDate=$zd(ReportDate,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(ReportDate,"O","JS")_"',23,4);"
	&javascript<#(retval)#>
	Set SWRQ=objZLK.CRSWRQ
	Set:SWRQ'="" SWRQ=$zd(SWRQ,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(SWRQ,"O","JS")_"',24,4);"
	&javascript<#(retval)#>
	//Set CRSWYYStr=##class(DHCMed.CD.CRReportZLK).GetICDDescByID(objZLK.CRSWYY)
	//Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(CRSWYYStr,$c(1),2),"O","JS")_"',25,4);"
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objZLK.CRSWYY.Description,"O","JS")_"',25,4);" //死亡原因取值
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objZLK.CRSYICD,"O","JS")_"',26,5);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objZLK.CRJTSWYY,"O","JS")_"',28,6);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objZLK.CRBSZY,"O","JS")_"',30,3);"
	&javascript<#(retval)#>
	
	//诊断依据
	For ind=1:1:objZLK.CRZDYJ.Count() {
		Set objDic=objZLK.CRZDYJ.GetAt(ind)
		Continue:'$IsObject(objDic)
		Set xCode=objDic.Code
		Set Position=..GetPosition("HIVManifestation",xCode)
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("","O","JS")_"',"_$p(Position,"^",1)_","_$p(Position,"^",2)_");"
		&javascript<#(retval)#>
	}
	
	q Count
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-09-11
/// Description:  取元素在模版上的位置
/// Table：       
/// Input：       字典分类，元素名Desc
/// Return：      X_"^"_Y
/// w ##class(DHCMed.CDService.PrintService).GetPosition("CRZDYJ","1")
ClassMethod GetPosition(aDicType As %String, aFieldDesc As %String) As %String
{
	New (aDicType,aFieldDesc)
	Set return="0^0"
	Quit:(aDicType="")||(aFieldDesc="") return
	
	Set ZDYJList=$lb("1","23","22")
	Set ZDYJList=ZDYJList_$lb("2","24","22")
	Set ZDYJList=ZDYJList_$lb("3","25","22")
	Set ZDYJList=ZDYJList_$lb("4","26","22")
	Set ZDYJList=ZDYJList_$lb("5","27","22")
	Set ZDYJList=ZDYJList_$lb("6","23","28")
	Set ZDYJList=ZDYJList_$lb("7","24","28")
	Set ZDYJList=ZDYJList_$lb("8","25","28")
	Set ZDYJList=ZDYJList_$lb("9","26","28")
	Set ZDYJList=ZDYJList_$lb("10","27","28")
	
	Set ind=$ListFind(ZDYJList,aFieldDesc)
	Quit:ind<1 return
	Set return=$List(ZDYJList,ind+1)_"^"_$List(ZDYJList,ind+2)
	
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-11-26
/// Description:  打印非职业一氧化碳中毒报告卡
/// Table：       DHCMed.CD.CRReport
/// Input：       
/// Return：      
/// w ##class(DHCMed.CDService.PrintService).ExportCRRepFZYCO("fillxlSheet","1")
ClassMethod ExportCRRepFZYCO11(itmjs As %String, strArguments As %String) As %String
{
	New (itmjs,strArguments)
	Set Count=0
	
	Set RepID=+$p(strArguments,"^",1)
	Set objRep=##class(DHCMed.CD.CRReport).GetObjById(RepID)
	Quit:'$IsObject(objRep) Count
	Set objPAT=##class(DHCMed.CD.CRReportPAT).GetObjByParRef(RepID)
	Quit:'$IsObject(objPAT) Count
	Set objCO=##class(DHCMed.CD.CRReportFZYCO).GetObjByParRef(RepID)
	Quit:'$IsObject(objZLK) Count
	
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objCO.CRKPBH,"O","JS")_"',3,4);"
	&javascript<#(retval)#>
	
	//病人基本信息
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRXM,"O","JS")_"',5,3);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRXB,"O","JS")_"',5,9);"
	&javascript<#(retval)#>
	Set PatAge=""
	If (objPAT.CRNLS'="") {
		Set PatAge=objPAT.CRNLS_"岁"
	} ElseIf (objPAT.CRNLY'="") {
		Set PatAge=objPAT.CRNLS_"月"
	} ElseIf (objPAT.CRNLT'="") {
		Set PatAge=objPAT.CRNLT_"天"
	}
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(PatAge,"O","JS")_"',5,13);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRJTDH,"O","JS")_"',5,18);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRSFZH,"O","JS")_"',6,4);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZS.ShortDesc,"O","JS")_"',7,5);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZS2.ShortDesc,"O","JS")_"',7,9);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZX.ShortDesc,"O","JS")_"',7,13);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZX2.ShortDesc,"O","JS")_"',7,17);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZC,"O","JS")_"',7,22);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZXX,"O","JS")_"',8,4);"
	&javascript<#(retval)#>
	
	//中毒情况
	Set COZDRQ=objCO.CRCOZDRQ
	Set:COZDRQ'="" COZDRQ=$zd(COZDRQ,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(COZDRQ,"O","JS")_"',10,4);"
	&javascript<#(retval)#>
	Set COZDSJ=objCO.CRCOZDSJ
	Set:COZDSJ'="" COZDSJ=$zt(COZDSJ,2)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(COZDSJ,"O","JS")_"',10,14);"
	&javascript<#(retval)#>
	Set ZDYY=objCO.CRZDYY.Description
	Set Position=..GetPositionFZYCO("ZDYYList",ZDYY)
	Set retval=itmjs_"(xlSheet,'☑',"_$p(Position,"^",1)_","_$p(Position,"^",2)_");"
	&javascript<#(retval)#>
	Set ZDCS=objCO.CRZDCS.Description
	Set Position=..GetPositionFZYCO("ZDCSList",ZDCS)
	Set retval=itmjs_"(xlSheet,'☑',"_$p(Position,"^",1)_","_$p(Position,"^",2)_");"
	&javascript<#(retval)#>
	Set ZDYS=objCO.CRZDYS.Description
	Set Position=..GetPositionFZYCO("ZDYSList",ZDYS)
	Set retval=itmjs_"(xlSheet,'☑',"_$p(Position,"^",1)_","_$p(Position,"^",2)_");"
	&javascript<#(retval)#>
	
	For ind=1:1:objCO.CRZYZZ.Count() {
		Set objDic=objCO.CRZYZZ.GetAt(ind)
		Continue:'$IsObject(objDic)
		Set Position=..GetPositionFZYCO("ZYZZList",objDic.Description)
		Set retval=itmjs_"(xlSheet,'☑',"_$p(Position,"^",1)_","_$p(Position,"^",2)_");"
		&javascript<#(retval)#>
	}
	
	Set ZDZD=objCO.CRZDZD.Description
	Set Position=..GetPositionFZYCO("ZDZDList",ZDZD)
	Set retval=itmjs_"(xlSheet,'☑',"_$p(Position,"^",1)_","_$p(Position,"^",2)_");"
	&javascript<#(retval)#>
	
	For ind=1:1:objCO.CRJZCS.Count() {
		Set objDic=objCO.CRJZCS.GetAt(ind)
		Continue:'$IsObject(objDic)
		Set Position=..GetPositionFZYCO("JZCSList",objDic.Description)
		Set retval=itmjs_"(xlSheet,'☑',"_$p(Position,"^",1)_","_$p(Position,"^",2)_");"
		&javascript<#(retval)#>
	}
	
	Set COZG=objCO.CRCOZG.Description
	Set Position=..GetPositionFZYCO("COZGList",COZG)
	Set retval=itmjs_"(xlSheet,'☑',"_$p(Position,"^",1)_","_$p(Position,"^",2)_");"
	&javascript<#(retval)#>
	
	//报告信息
	Set ZDRQ=objCO.CRZDRQ
	Set:ZDRQ'="" ZDRQ=$zd(ZDRQ,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(ZDRQ,"O","JS")_"',33,4);"
	&javascript<#(retval)#>
	Set SWRQ=objCO.CRSWRQ
	Set:SWRQ'="" SWRQ=$zd(SWRQ,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(SWRQ,"O","JS")_"',33,14);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.CRReportOrgan,"O","JS")_"',35,12);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.CRReportUser,"O","JS")_"',35,3);"
	&javascript<#(retval)#>
	Set ReportDate=objRep.CRReportDate
	Set:ReportDate'="" ReportDate=$zd(ReportDate,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(ReportDate,"O","JS")_"',35,22);"
	&javascript<#(retval)#>
	
	
	q Count
}

/// Creator：     maxp
/// CreatDate：   2016-04-19
/// Description:  打印非职业一氧化碳中毒报告卡
/// Table：       DHCMed.CD.CRReport
/// Input：       
/// Return：      
/// w ##class(DHCMed.CDService.PrintService).ExportCRRepFZYCO("fillxlSheet","1")
ClassMethod ExportCRRepFZYCO(itmjs As %String, strArguments As %String) As %String
{
	New (itmjs,strArguments)
	Set Count=0
	
	Set RepID=+$p(strArguments,"^",1)
	Set objRep=##class(DHCMed.CD.CRReport).GetObjById(RepID)
	Quit:'$IsObject(objRep) Count
	Set objPAT=##class(DHCMed.CD.CRReportPAT).GetObjByParRef(RepID)
	Quit:'$IsObject(objPAT) Count
	Set objCO=##class(DHCMed.CD.CRReportFZYCO).GetObjByParRef(RepID)
	Quit:'$IsObject(objCO) Count
	
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objCO.CRKPBH,"O","JS")_"',3,4);"
	&javascript<#(retval)#>
	
	//病人基本信息
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRXM,"O","JS")_"',5,3);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRXB,"O","JS")_"',5,9);"
	&javascript<#(retval)#>
	Set PatAge=""
	If (objPAT.CRNLS'="") {
		Set PatAge=objPAT.CRNLS_"岁"
	} ElseIf (objPAT.CRNLY'="") {
		Set PatAge=objPAT.CRNLS_"月"
	} ElseIf (objPAT.CRNLT'="") {
		Set PatAge=objPAT.CRNLT_"天"
	}
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(PatAge,"O","JS")_"',5,13);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRLXDH,"O","JS")_"',5,18);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRSFZH,"O","JS")_"',6,4);"
	&javascript<#(retval)#>
	//职业
	Set COZY=objPAT.CRZY.Description
	Set:COZY="" COZY=##class(DHCMed.CD.CRReportBZQT).GetByPaCode(RepID,"CRQTZY")
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(COZY,"O","JS")_"',6,18);"
	&javascript<#(retval)#>
	
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZS.ShortDesc,"O","JS")_"',7,5);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZS2.ShortDesc,"O","JS")_"',7,9);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZX.ShortDesc,"O","JS")_"',7,13);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZX2.ShortDesc,"O","JS")_"',7,17);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZC,"O","JS")_"',7,22);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZXX,"O","JS")_"',8,5);"
	&javascript<#(retval)#>
	
	//中毒情况
	Set COZDRQ=objCO.CRCOZDRQ
	Set:COZDRQ'="" COZDRQ=$zd(COZDRQ,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(COZDRQ,"O","JS")_"',10,4);"
	&javascript<#(retval)#>
	Set COZDSJ=objCO.CRCOZDSJ
	Set:COZDSJ'="" COZDSJ=$zt(COZDSJ,2)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(COZDSJ,"O","JS")_"',10,12);"
	&javascript<#(retval)#>
	
	Set chkY="☑",chkN="□"
	Set row=11,col=4,count=0
	Set ZDYY=objCO.CRZDYY.%Id() //中毒原因
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("CRCOZDYY","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set DicDesc=$s(DicID=ZDYY:chkY,1:chkN)_DicDesc
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+7
		Set count=count+1
		Set:count#3=0 row=row+1,col=4
	}
	Do rs.Close()
	
	Set row=13,col=4,count=0
	Set ZDCS=objCO.CRZDCS.%Id() //中毒场所
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("CRZDCS","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set DicDesc=$s(DicID=ZDCS:chkY,1:chkN)_DicDesc
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+7
		Set count=count+1
		Set:count#3=0 row=row+1,col=4
	}
	Do rs.Close()
	
	Set row=15,col=4,count=0
	Set ZDYS=objCO.CRZDYS.%Id() //中毒因素
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("CRZDYS","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set DicDesc=$s(DicID=ZDYS:chkY,1:chkN)_DicDesc
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+7
		Set count=count+1
		Set:count#3=0 row=row+1,col=4
	}
	Do rs.Close()
	
	//主要症状	
	Set row=17,col=4,count=0
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("CRZYZZ","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set CheckFlg=0
		For ind=1:1:objCO.CRZYZZ.Count() {
			Set objDic=objCO.CRZYZZ.GetAt(ind)
			Continue:'$IsObject(objDic)
			Set SubID=objDic.%Id()
			Set:SubID=DicID CheckFlg=1
		}
		Set DicDesc=$s(CheckFlg:chkY,1:chkN)_DicDesc
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+7
		Set count=count+1
		Set:count#3=0 row=row+1,col=4
	}
	Do rs.Close()
	Set QTZZ=##class(DHCMed.CD.CRReportBZQT).GetByPaCode(RepID,"CRQTZZ")
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(QTZZ,"O","JS")_"',20,4);"
	&javascript<#(retval)#>
	
	Set row=21,col=4
	Set ZDZD=objCO.CRZDZD.%Id() //中毒诊断
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("CRZDZD","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set DicDesc=$s(DicID=ZDZD:chkY,1:chkN)_DicDesc
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+$l(DicDesc)
	}
	Do rs.Close()
	
	//救治措施	
	Set row=22,col=4,count=0
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("CRJZCS","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set CheckFlg=0
		For ind=1:1:objCO.CRJZCS.Count() {
			Set objDic=objCO.CRJZCS.GetAt(ind)
			Continue:'$IsObject(objDic)
			Set SubID=objDic.%Id()
			Set:SubID=DicID CheckFlg=1
		}
		Set DicDesc=$s(CheckFlg:chkY,1:chkN)_DicDesc
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+7
		Set count=count+1
		Set:count#4=0 row=row+1,col=4
	}
	Do rs.Close()

	Set row=24,col=4
	Set COZG=objCO.CRCOZG.%Id() //转归
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("CRCOZG","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set DicDesc=$s(DicID=COZG:chkY,1:chkN)_DicDesc
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+$l(DicDesc)
	}
	Do rs.Close()
	
	//报告信息
	Set ZDRQ=objCO.CRZDRQ
	Set:ZDRQ'="" ZDRQ=$zd(ZDRQ,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(ZDRQ,"O","JS")_"',26,4);"
	&javascript<#(retval)#>
	Set SWRQ=objCO.CRSWRQ
	Set:SWRQ'="" SWRQ=$zd(SWRQ,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(SWRQ,"O","JS")_"',26,14);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.CRReportOrgan,"O","JS")_"',28,12);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.CRReportUser,"O","JS")_"',28,4);"
	&javascript<#(retval)#>
	Set ReportDate=objRep.CRReportDate
	Set:ReportDate'="" ReportDate=$zd(ReportDate,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(ReportDate,"O","JS")_"',28,23);"
	&javascript<#(retval)#>
	
	
	q Count
}

/// Creator：     maxp
/// CreatDate：   2016-04-19
/// Description:  打印伤害监测报告卡
/// Table：       DHCMed.CD.CRReport
/// Input：       
/// Return：      
/// w ##class(DHCMed.CDService.PrintService).ExportCRRepSHK("fillxlSheet","1")
ClassMethod ExportCRRepSHK(itmjs As %String, strArguments As %String) As %String
{
	New (itmjs,strArguments)
	Set Count=0
	
	Set RepID=+$p(strArguments,"^",1)
	Set objRep=##class(DHCMed.CD.CRReport).GetObjById(RepID)
	Quit:'$IsObject(objRep) Count
	Set objPAT=##class(DHCMed.CD.CRReportPAT).GetObjByParRef(RepID)
	Quit:'$IsObject(objPAT) Count
	Set objSHK=##class(DHCMed.CD.CRReportSHK).GetObjByParRef(RepID)
	Quit:'$IsObject(objSHK) Count
	
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objSHK.CRYYBH,"O","JS")_"',3,7);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objSHK.CRKPBH,"O","JS")_"',3,20);"
	&javascript<#(retval)#>
	
	//病人基本信息
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRXM,"O","JS")_"',5,3);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRXB,"O","JS")_"',5,9);"
	&javascript<#(retval)#>
	Set PatAge=""
	If (objPAT.CRNLS'="") {
		Set PatAge=objPAT.CRNLS_"岁"
	} ElseIf (objPAT.CRNLY'="") {
		Set PatAge=objPAT.CRNLS_"月"
	} ElseIf (objPAT.CRNLT'="") {
		Set PatAge=objPAT.CRNLT_"天"
	}
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(PatAge,"O","JS")_"',5,14);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRLXDH,"O","JS")_"',5,21);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRSFZH,"O","JS")_"',6,5);"
	&javascript<#(retval)#>
	
	//户籍
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRHJ.Description,"O","JS")_"',6,19);"
	&javascript<#(retval)#>
	
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZS.ShortDesc,"O","JS")_"',7,7);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZS2.ShortDesc,"O","JS")_"',7,11);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZX.ShortDesc,"O","JS")_"',7,15);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZX2.ShortDesc,"O","JS")_"',7,20);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZC,"O","JS")_"',7,26);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZXX,"O","JS")_"',8,6);"
	&javascript<#(retval)#>
	
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRWHCD.Description,"O","JS")_"',9,13);"
	&javascript<#(retval)#>
	//职业
	Set SHZY=objPAT.CRZY.Description
	Set:SHZY="" SHZY=##class(DHCMed.CD.CRReportBZQT).GetByPaCode(RepID,"CRQTZY")
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(SHZY,"O","JS")_"',9,22);"
	&javascript<#(retval)#>
	
	//伤害发生日期
	Set CRSHFSRQ=objSHK.CRSHFSRQ
	Set:CRSHFSRQ'="" CRSHFSRQ=$zd(CRSHFSRQ,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(CRSHFSRQ,"O","JS")_"',12,7);"
	&javascript<#(retval)#>
	//Set CRSHFSSJ=objSHK.CRSHFSSJ
	//Set:CRSHFSSJ'="" CRSHFSSJ=$zt(CRSHFSSJ,2)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objSHK.CRSHFSSJ,"O","JS")_"',12,12);"
	&javascript<#(retval)#>
	
	Set CRHZJZRQ=objSHK.CRHZJZRQ
	Set:CRHZJZRQ'="" CRHZJZRQ=$zd(CRHZJZRQ,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(CRHZJZRQ,"O","JS")_"',13,7);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objSHK.CRHZJZSJ,"O","JS")_"',13,12);"
	&javascript<#(retval)#>
	
	// 伤害发生原因
	Set CRSHFSYY=objSHK.CRSHFSYY.Description
	Set:CRSHFSYY="" CRSHFSYY=##class(DHCMed.CD.CRReportBZQT).GetByPaCode(RepID,"CRQTYY")
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(CRSHFSYY,"O","JS")_"',14,7);"
	&javascript<#(retval)#>
	// 伤害发生地点
	Set CRSHFSDD=objSHK.CRSHFSDD.Description
	Set:CRSHFSDD="" CRSHFSYY=##class(DHCMed.CD.CRReportBZQT).GetByPaCode(RepID,"CRQTDD")
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(CRSHFSDD,"O","JS")_"',15,7);"
	&javascript<#(retval)#>
	// 伤害发生时活动
	Set CRSHFSSHD=objSHK.CRSHFSSHD.Description
	Set:CRSHFSSHD="" CRSHFSYY=##class(DHCMed.CD.CRReportBZQT).GetByPaCode(RepID,"CRQTHD")
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(CRSHFSSHD,"O","JS")_"',16,8);"
	&javascript<#(retval)#>
	
	Set chkY="☑",chkN="□"
	Set row=17,col=5
	Set CRSHSFGY=objSHK.CRSHSFGY.%Id() // 伤害是否故意
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("CRSHSFGY","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set DicDesc=$s(DicID=CRSHSFGY:chkY,1:chkN)_DicDesc
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+$l(DicDesc)
	}
	Do rs.Close()
	
	// 伤害性质
	Set CRSHXZ=objSHK.CRSHXZ.Description
	Set:CRSHXZ="" CRSHXZ=##class(DHCMed.CD.CRReportBZQT).GetByPaCode(RepID,"CRQTXZ")
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(CRSHXZ,"O","JS")_"',20,13);"
	&javascript<#(retval)#>
	// 伤害部位
	Set CRSHBW=objSHK.CRSHBW.Description
	Set:CRSHBW="" CRSHBW=##class(DHCMed.CD.CRReportBZQT).GetByPaCode(RepID,"CRQTBW")
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(CRSHBW,"O","JS")_"',21,14);"
	&javascript<#(retval)#>
	
	Set row=22,col=7
	Set CRSHYZCD=objSHK.CRSHYZCD.%Id() // 伤害严重程度
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("CRSHYZCD","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set DicDesc=$s(DicID=CRSHYZCD:chkY,1:chkN)_DicDesc
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+$l(DicDesc)
	}
	Do rs.Close()
	
	Set ICDstr=##class(DHCMed.CD.CRReportSHK).GetICDDescByID(objSHK.CRSHZD)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(ICDstr,$c(1),2),"O","JS")_"',23,7);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(ICDstr,$c(1),3),"O","JS")_"',23,18);"
	&javascript<#(retval)#>
	
	Set row=24,col=5
	Set CRSHJJ=objSHK.CRSHJJ.%Id() // 伤害结局
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("CRSHJJ","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set DicDesc=$s(DicID=CRSHJJ:chkY,1:chkN)_DicDesc
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+$l(DicDesc)
	}
	Do rs.Close()
	
	// 产品信息
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objSHK.CRCPMC1,"O","JS")_"',27,6);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objSHK.CRCPXH1,"O","JS")_"',27,17);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objSHK.CRCPFL1.Description,"O","JS")_"',27,27);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objSHK.CRCPMC2,"O","JS")_"',28,6);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objSHK.CRCPXH2,"O","JS")_"',28,17);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objSHK.CRCPFL2.Description,"O","JS")_"',28,27);"
	&javascript<#(retval)#>
	
	
	//报告信息
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.CRReportUser,"O","JS")_"',30,4);"
	&javascript<#(retval)#>
	Set ReportDate=objRep.CRReportDate
	Set:ReportDate'="" ReportDate=$zd(ReportDate,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(ReportDate,"O","JS")_"',30,16);"
	&javascript<#(retval)#>
	//典型案例	
	Set row=31,col=5
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("CRSHDYAL","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set CheckFlg=0
		For ind=1:1:objSHK.CRDXAL.Count() {
			Set objDic=objSHK.CRDXAL.GetAt(ind)
			Continue:'$IsObject(objDic)
			Set SubID=objDic.%Id()
			Set:SubID=DicID CheckFlg=1
		}
		Set DicDesc=$s(CheckFlg:chkY,1:chkN)_DicDesc
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+$l(DicDesc)
	}
	Do rs.Close()
	
	q Count
}

/// Creator：     maxp
/// CreatDate：   2016-04-19
/// Description:  打印疑似职业病报告卡
/// Table：       DHCMed.CD.CRReport
/// Input：       
/// Return：      
/// w ##class(DHCMed.CDService.PrintService).ExportCRRepYSZYB("fillxlSheet","1")
ClassMethod ExportCRRepYSZYB(itmjs As %String, strArguments As %String) As %String
{
	New (itmjs,strArguments)
	Set Count=0
	
	Set RepID=+$p(strArguments,"^",1)
	Set objRep=##class(DHCMed.CD.CRReport).GetObjById(RepID)
	Quit:'$IsObject(objRep) Count
	Set objPAT=##class(DHCMed.CD.CRReportPAT).GetObjByParRef(RepID)
	Quit:'$IsObject(objPAT) Count
	Set objYSZYB=##class(DHCMed.CD.CRReportYSZYB).GetObjByParRef(RepID)
	Quit:'$IsObject(objYSZYB) Count
	
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objYSZYB.CRKPBH,"O","JS")_"',3,5);"
	&javascript<#(retval)#>
	
	//病人基本信息
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRXM,"O","JS")_"',5,3);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRXB,"O","JS")_"',5,9);"
	&javascript<#(retval)#>
	Set PatAge=""
	If (objPAT.CRNLS'="") {
		Set PatAge=objPAT.CRNLS_"岁"
	} ElseIf (objPAT.CRNLY'="") {
		Set PatAge=objPAT.CRNLS_"月"
	} ElseIf (objPAT.CRNLT'="") {
		Set PatAge=objPAT.CRNLT_"天"
	}
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(PatAge,"O","JS")_"',5,13);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRLXDH,"O","JS")_"',5,19);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRSFZH,"O","JS")_"',6,5);"
	&javascript<#(retval)#>
	
	//职业
	Set SHZY=objPAT.CRZY.Description
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(SHZY,"O","JS")_"',6,19);"
	&javascript<#(retval)#>
	
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZS.ShortDesc,"O","JS")_"',7,7);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZS2.ShortDesc,"O","JS")_"',7,11);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZX.ShortDesc,"O","JS")_"',7,15);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZX2.ShortDesc,"O","JS")_"',7,20);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZC,"O","JS")_"',7,26);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZXX,"O","JS")_"',8,6);"
	&javascript<#(retval)#>
	
	// 用人单位信息
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objYSZYB.CRYRDWMC,"O","JS")_"',10,7);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objYSZYB.CRYRDWDZ,"O","JS")_"',11,7);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objYSZYB.CRYRDWYB,"O","JS")_"',11,20);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objYSZYB.CRYRDWLXR,"O","JS")_"',12,7);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objYSZYB.CRYRDWLXRDH,"O","JS")_"',12,20);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objYSZYB.CRJJLX,"O","JS")_"',13,7);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objYSZYB.CRDWHY,"O","JS")_"',14,7);"
	&javascript<#(retval)#>
	
	Set chkY="☑",chkN="□"
	Set row=15,col=7
	Set CRQYGM=objYSZYB.CRQYGM.%Id() // 企业规模
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("CRQYGM","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set DicDesc=$s(DicID=CRQYGM:chkY,1:chkN)_DicDesc
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+4
	}
	Do rs.Close()
		
	Set row=17,col=6
	Set CRBRLY=objYSZYB.CRBRLY.%Id() // 病人来源
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("CRBRLY","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set DicDesc=$s(DicID=CRBRLY:chkY,1:chkN)_DicDesc
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+5
	}
	Do rs.Close()
	
	//职业病种类
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objYSZYB.CRZYBZL,"O","JS")_"',18,6);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objYSZYB.CRJTBM,"O","JS")_"',18,19);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objYSZYB.CRZDSGBM,"O","JS")_"',19,7);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objYSZYB.CRTSZDRS,"O","JS")_"',19,21);"
	&javascript<#(retval)#>	
		
	Set row=20,col=5
	Set CRTJGZ=objYSZYB.CRTJGZ.%Id() // 统计工种
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("CRTJGZ","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set DicDesc=$s(DicID=CRTJGZ:chkY,1:chkN)_DicDesc
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+4
	}
	Do rs.Close()
	
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objYSZYB.CRZYGLN,"O","JS")_"',20,22);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objYSZYB.CRZYGLY,"O","JS")_"',20,25);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objYSZYB.CRJCSJT,"O","JS")_"',21,5);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objYSZYB.CRJCSJS,"O","JS")_"',21,8);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objYSZYB.CRJCSJF,"O","JS")_"',21,11);"
	&javascript<#(retval)#>
	
	// 发生日期
	Set CRFSRQ=objYSZYB.CRFSRQ
	Set:CRFSRQ'="" CRFSRQ=$zd(CRFSRQ,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(CRFSRQ,"O","JS")_"',23,5);"
	&javascript<#(retval)#>
	
	Set CRZDRQ=objYSZYB.CRZDRQ
	Set:CRZDRQ'="" CRZDRQ=$zd(CRZDRQ,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(CRZDRQ,"O","JS")_"',23,15);"
	&javascript<#(retval)#>
	Set CRSWRQ=objYSZYB.CRSWRQ
	Set:CRSWRQ'="" CRSWRQ=$zd(CRSWRQ,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(CRSWRQ,"O","JS")_"',23,25);"
	&javascript<#(retval)#>
	
	//报告信息
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.CRReportUser,"O","JS")_"',25,4);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.CRReportOrgan,"O","JS")_"',25,14);"
	&javascript<#(retval)#>
	Set ReportDate=objRep.CRReportDate
	Set:ReportDate'="" ReportDate=$zd(ReportDate,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(ReportDate,"O","JS")_"',25,26);"
	&javascript<#(retval)#>
	
	q Count
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-11-26
/// Description:  取元素在模版上的位置
/// Table：       
/// Input：       字典分类，元素名Desc
/// Return：      X_"^"_Y
/// w ##class(DHCMed.CDService.PrintService).GetPositionFZYCO("ZDYYList","炭火取暖")
ClassMethod GetPositionFZYCO(aDicType As %String, aFieldDesc As %String) As %String
{
	New (aDicType,aFieldDesc)
	Set (PositionX,PositionY)=0
	Set return=PositionX_"^"_PositionY
	Quit:(aDicType="")||(aFieldDesc="") return
	
	Set ZDYYList=$lb("燃煤取暖","12","6")
	Set ZDYYList=ZDYYList_$lb("炭火取暖","12","12")
	Set ZDYYList=ZDYYList_$lb("煤气热水器使用不当","12","17")
	Set ZDYYList=ZDYYList_$lb("人工煤气泄漏","13","6")
	Set ZDYYList=ZDYYList_$lb("汽车尾气","13","12")
	Set ZDYYList=ZDYYList_$lb("其他","13","17")
	
	Set ZDCSList=$lb("学校","15","6")
	Set ZDCSList=ZDCSList_$lb("家庭","15","12")
	Set ZDCSList=ZDCSList_$lb("公共场所","15","17")
	Set ZDCSList=ZDCSList_$lb("办公场所","16","6")
	Set ZDCSList=ZDCSList_$lb("其他","16","12")
	
	Set ZDYSList=$lb("一氧化碳","18","6")
	Set ZDYSList=ZDYSList_$lb("天然气","18","12")
	Set ZDYSList=ZDYSList_$lb("液化气","18","17")
	Set ZDYSList=ZDYSList_$lb("二氧化碳","19","6")
	Set ZDYSList=ZDYSList_$lb("硫化氢","19","12")
	
	Set ZYZZList=$lb("乏力","21","6")
	Set ZYZZList=ZYZZList_$lb("头痛","21","12")
	Set ZYZZList=ZYZZList_$lb("眩晕","21","17")
	Set ZYZZList=ZYZZList_$lb("恶心","22","6")
	Set ZYZZList=ZYZZList_$lb("意识模糊","22","12")
	Set ZYZZList=ZYZZList_$lb("昏迷","22","17")
	Set ZYZZList=ZYZZList_$lb("休克","23","6")
	Set ZYZZList=ZYZZList_$lb("呕吐","23","12")
	Set ZYZZList=ZYZZList_$lb("其他","23","17")
	
	Set ZDZDList=$lb("轻度中毒","25","6")
	Set ZDZDList=ZDZDList_$lb("中度中毒","25","12")
	Set ZDZDList=ZDZDList_$lb("重度中毒","25","17")
	
	Set JZCSList=$lb("脱离现场","27","6")
	Set JZCSList=JZCSList_$lb("吸入氧气","27","12")
	Set JZCSList=JZCSList_$lb("高压氧治疗","27","17")
	Set JZCSList=JZCSList_$lb("糖皮质激素","28","6")
	Set JZCSList=JZCSList_$lb("血管扩张剂","28","12")
	Set JZCSList=JZCSList_$lb("对症相关支持治疗","28","17")
	Set JZCSList=JZCSList_$lb("神经细胞营养液","29","6")
	Set JZCSList=JZCSList_$lb("其他","29","12")
	
	Set COZGList=$lb("治愈","31","6")
	Set COZGList=COZGList_$lb("好转","31","12")
	Set COZGList=COZGList_$lb("死亡","31","17")
	
	
	Set valExpress="Set ind=$ListFind("_aDicType_",aFieldDesc)"
	X valExpress
	Quit:ind<1 return
	Set valExpressX="Set PositionX=$List("_aDicType_",ind+1)"
	X valExpressX
	Set valExpressY="Set PositionY=$List("_aDicType_",ind+2)"
	X valExpressY
	
	Set return=PositionX_"^"_PositionY
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-11-26
/// Description:  打印农药中毒报告卡
/// Table：       DHCMed.CD.CRReport
/// Input：       
/// Return：      
/// w ##class(DHCMed.CDService.PrintService).ExportCRRepNYZD("fillxlSheet","1")
ClassMethod ExportCRRepNYZD(itmjs As %String, strArguments As %String) As %String
{
	New (itmjs,strArguments)
	Set Count=0
	
	Set RepID=+$p(strArguments,"^",1)
	Set objRep=##class(DHCMed.CD.CRReport).GetObjById(RepID)
	Quit:'$IsObject(objRep) Count
	Set objPAT=##class(DHCMed.CD.CRReportPAT).GetObjByParRef(RepID)
	Quit:'$IsObject(objPAT) Count
	Set objNY=##class(DHCMed.CD.CRReportNYZD).GetObjByParRef(RepID)
	Quit:'$IsObject(objNY) Count
	
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objNY.CRKPBH,"O","JS")_"',3,5);"
	&javascript<#(retval)#>
	
	//病人基本信息
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRXM,"O","JS")_"',5,3);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRXB,"O","JS")_"',5,9);"
	&javascript<#(retval)#>
	Set PatAge=""
	If (objPAT.CRNLS'="") {
		Set PatAge=objPAT.CRNLS_"岁"
	} ElseIf (objPAT.CRNLY'="") {
		Set PatAge=objPAT.CRNLS_"月"
	} ElseIf (objPAT.CRNLT'="") {
		Set PatAge=objPAT.CRNLT_"天"
	}
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(PatAge,"O","JS")_"',5,13);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRLXDH,"O","JS")_"',5,19);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRSFZH,"O","JS")_"',6,5);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZS.ShortDesc,"O","JS")_"',7,7);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZS2.ShortDesc,"O","JS")_"',7,11);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZX.ShortDesc,"O","JS")_"',7,15);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZX2.ShortDesc,"O","JS")_"',7,20);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZC,"O","JS")_"',7,26);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZXX,"O","JS")_"',8,6);"
	&javascript<#(retval)#>
	
	//中毒信息
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objNY.CRZDNYMC,"O","JS")_"',10,7);"
	&javascript<#(retval)#>
	Set NYZLSL=objNY.CRNYZLSL.Description
	If (NYZLSL="单一") {
		Set retval=itmjs_"(xlSheet,'☑',10,22);"
		&javascript<#(retval)#>
	}ElseIf (NYZLSL="两种及以上") {
		Set retval=itmjs_"(xlSheet,'☑',10,26);"
		&javascript<#(retval)#>
	}
	Set ZDYY=objNY.CRZDYY.Description
	Set Position=..GetPositionNYZD("ZDYYList",ZDYY)
	Set retval=itmjs_"(xlSheet,'☑',"_$p(Position,"^",1)_","_$p(Position,"^",2)_");"
	&javascript<#(retval)#>
	Set ZSPX=objNY.CRZSPX.Description
	If (ZSPX="未接受培训") {
		Set retval=itmjs_"(xlSheet,'☑',14,11);"
		&javascript<#(retval)#>
	}ElseIf (ZSPX="接受培训") {
		Set retval=itmjs_"(xlSheet,'☑',14,19);"
		&javascript<#(retval)#>
	}
	Set SYFS=objNY.CRSYFS.Description
	If (SYFS="隔行打药") {
		Set retval=itmjs_"(xlSheet,'☑',16,6);"
		&javascript<#(retval)#>
	}ElseIf (SYFS="退步打药") {
		Set retval=itmjs_"(xlSheet,'☑',16,13);"
		&javascript<#(retval)#>
	}ElseIf (SYFS="顺风打药") {
		Set retval=itmjs_"(xlSheet,'☑',16,19);"
		&javascript<#(retval)#>
	}
	
	For ind=1:1:objNY.CRWXXW.Count() {
		Set objDic=objNY.CRWXXW.GetAt(ind)
		Continue:'$IsObject(objDic)
		Set Position=..GetPositionNYZD("WXXWList",objDic.Description)
		Set retval=itmjs_"(xlSheet,'☑',"_$p(Position,"^",1)_","_$p(Position,"^",2)_");"
		&javascript<#(retval)#>
	}
	
	Set ZDZG=objNY.CRZDZG.Description
	Set Position=..GetPositionNYZD("ZDZGList",ZDZG)
	if (Position'="0^0") {
	Set retval=itmjs_"(xlSheet,'☑',"_$p(Position,"^",1)_","_$p(Position,"^",2)_");"
	&javascript<#(retval)#>
	}
	//报告信息
	Set ZDRQ=objNY.CRZDRQ
	Set:ZDRQ'="" ZDRQ=$zd(ZDRQ,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(ZDRQ,"O","JS")_"',24,5);"
	&javascript<#(retval)#>
	Set SWRQ=objNY.CRSWRQ
	Set:SWRQ'="" SWRQ=$zd(SWRQ,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(SWRQ,"O","JS")_"',24,16);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.CRReportOrgan,"O","JS")_"',26,15);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.CRReportUser,"O","JS")_"',26,4);"
	&javascript<#(retval)#>
	Set ReportDate=objRep.CRReportDate
	Set:ReportDate'="" ReportDate=$zd(ReportDate,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(ReportDate,"O","JS")_"',26,28);"
	&javascript<#(retval)#>
	
	
	q Count
}

/// Creator：     maxp
/// CreatDate：   2016-04-19
/// Description:  打印糖尿病报告卡
/// Table：       DHCMed.CD.CRReport
/// Input：       
/// Return：      
/// w ##class(DHCMed.CDService.PrintService).ExportCRRepTNB("fillxlSheet","1")
ClassMethod ExportCRRepTNB(itmjs As %String, strArguments As %String) As %String
{
	New (itmjs,strArguments)
	Set Count=0
	
	Set RepID=+$p(strArguments,"^",1)
	Set objRep=##class(DHCMed.CD.CRReport).GetObjById(RepID)
	Quit:'$IsObject(objRep) Count
	Set objPAT=##class(DHCMed.CD.CRReportPAT).GetObjByParRef(RepID)
	Quit:'$IsObject(objPAT) Count
	Set objTNB=##class(DHCMed.CD.CRReportTNB).GetObjByParRef(RepID)
	Quit:'$IsObject(objTNB) Count
	
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objTNB.CRKPBH,"O","JS")_"',3,4);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRDJH,"O","JS")_"',3,14);"
	&javascript<#(retval)#>
	
	//病人基本信息
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRXM,"O","JS")_"',5,3);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRSFZH,"O","JS")_"',5,9);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRXB,"O","JS")_"',5,18);"
	&javascript<#(retval)#>
	Set PatAge=""
	If (objPAT.CRNLS'="") {
		Set PatAge=objPAT.CRNLS_"岁"
	} ElseIf (objPAT.CRNLY'="") {
		Set PatAge=objPAT.CRNLS_"月"
	} ElseIf (objPAT.CRNLT'="") {
		Set PatAge=objPAT.CRNLT_"天"
	}
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(PatAge,"O","JS")_"',5,21);"
	&javascript<#(retval)#>
	Set CSRQ=objPAT.CRCSRQ
	Set:CSRQ'="" CSRQ=$zd(CSRQ,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(CSRQ,"O","JS")_"',5,26);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRZY.Description,"O","JS")_"',6,3);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRGZ.Description,"O","JS")_"',6,15);"  //工种改为字典类型
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRWHCD.Description,"O","JS")_"',6,25);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRMZ.Description,"O","JS")_"',7,3);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRJTDH,"O","JS")_"',7,10);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRGZDW,"O","JS")_"',7,20);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZS.ShortDesc,"O","JS")_"',8,7);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZS2.ShortDesc,"O","JS")_"',8,11);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZX.ShortDesc,"O","JS")_"',8,15);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZX2.ShortDesc,"O","JS")_"',8,19);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZC,"O","JS")_"',8,24);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZXX,"O","JS")_"',9,6);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRHJDZS.ShortDesc,"O","JS")_"',10,7);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRHJDZS2.ShortDesc,"O","JS")_"',10,11);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRHJDZX.ShortDesc,"O","JS")_"',10,15);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRHJDZX2.ShortDesc,"O","JS")_"',10,19);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRHJDZC,"O","JS")_"',10,24);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRHJDZXX,"O","JS")_"',11,6);"
	&javascript<#(retval)#>
	
	//诊断、报告信息
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objTNB.CRZDLX.Description,"O","JS")_"',14,5);"  //糖尿病类型
	&javascript<#(retval)#>
	Set ZDStr=##class(DHCMed.CD.CRReportTNB).GetICDDescByID(objTNB.CRZD)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(ZDStr,$c(1),2),"O","JS")_"',15,3);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objTNB.CRZDICD,"O","JS")_"',15,14);"
	&javascript<#(retval)#>
	
	Set chkY="☑",chkN="□"
	Set row=16,col=4 // 并发症
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("CRBFZ","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set CheckFlg=0
		For ind=1:1:objTNB.CRBFZ.Count() {
			Set objDic=objTNB.CRBFZ.GetAt(ind)
			Continue:'$IsObject(objDic)
			Set SubID=objDic.%Id()
			Set:SubID=DicID CheckFlg=1
		}
		Set DicDesc=$s(CheckFlg:chkY,1:chkN)_DicDesc
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+$l(DicDesc)-1
	}
	Do rs.Close()
	
	Set row=17,col=4 // 危害因素
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("CRWHYS","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set CheckFlg=0
		For ind=1:1:objTNB.CRWHYS.Count() {
			Set objDic=objTNB.CRWHYS.GetAt(ind)
			Continue:'$IsObject(objDic)
			Set SubID=objDic.%Id()
			Set:SubID=DicID CheckFlg=1
		}
		Set DicDesc=$s(CheckFlg:chkY,1:chkN)_DicDesc
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+$l(DicDesc)
	}
	Do rs.Close()
	
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objTNB.CRTZ,"O","JS")_"',18,7);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objTNB.CRSG,"O","JS")_"',18,14);"
	&javascript<#(retval)#>
	
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objTNB.CRRS,"O","JS")_"',19,9);"
	&javascript<#(retval)#>
	Set row=19,col=18
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("CRJZS","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set CheckFlg=0
		For ind=1:1:objTNB.CRJZS.Count() {
			Set objDic=objTNB.CRJZS.GetAt(ind)
			Continue:'$IsObject(objDic)
			Set SubID=objDic.%Id()
			Set:SubID=DicID CheckFlg=1
		}
		Set DicDesc=$s(CheckFlg:chkY,1:chkN)_DicDesc
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+$l(DicDesc)
	}
	Do rs.Close()
	
	Set row=20,col=4,count=0
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("CRLCBX","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set CheckFlg=0
		For ind=1:1:objTNB.CRLCBX.Count() {
			Set objDic=objTNB.CRLCBX.GetAt(ind)
			Continue:'$IsObject(objDic)
			Set SubID=objDic.%Id()
			Set:SubID=DicID CheckFlg=1
		}
		Set DicDesc=$s(CheckFlg:chkY,1:chkN)_DicDesc
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+7 //$l(DicDesc)*2/3
		Set count=count+1
		set:count#4=0 row=row+1,col=4
	}
	Do rs.Close()
	
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objTNB.CRQTLCBX,"O","JS")_"',23,6);"
	&javascript<#(retval)#>
	
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objTNB.CRZYJCQK1,"O","JS")_"',24,14);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objTNB.CRZYJCQK2,"O","JS")_"',24,26);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objTNB.CRZYJCQK3,"O","JS")_"',25,14);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objTNB.CRZYJCQK4,"O","JS")_"',25,26);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objTNB.CRZYJCQK5,"O","JS")_"',26,14);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objTNB.CRZYJCQK6,"O","JS")_"',26,26);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objTNB.CRZYJCQK7,"O","JS")_"',27,14);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objTNB.CRZYJCQK8,"O","JS")_"',27,26);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objTNB.CRZYJCQK9,"O","JS")_"',28,14);"
	&javascript<#(retval)#>
	
	
	&javascript<#(retval)#>
	Set ZDRQ=objTNB.CRZDRQ
	Set:ZDRQ'="" ZDRQ=$zd(ZDRQ,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(ZDRQ,"O","JS")_"',31,4);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objTNB.CRZGZDDW.Description,"O","JS")_"',31,13);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.CRReportOrgan,"O","JS")_"',32,4);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.CRReportUser,"O","JS")_"',32,14);"
	&javascript<#(retval)#>
	Set ReportDate=objRep.CRReportDate
	Set:ReportDate'="" ReportDate=$zd(ReportDate,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(ReportDate,"O","JS")_"',32,23);"
	&javascript<#(retval)#>
	Set SWRQ=objTNB.CRSWRQ
	Set:SWRQ'="" SWRQ=$zd(SWRQ,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(SWRQ,"O","JS")_"',34,4);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objTNB.CRSWYY.Description,"O","JS")_"',34,13);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objTNB.CRSYICD,"O","JS")_"',34,23);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objTNB.CRJTSWYY,"O","JS")_"',35,6);"
	&javascript<#(retval)#>
	
	q Count
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-11-26
/// Description:  取元素在模版上的位置
/// Table：       
/// Input：       字典分类，元素名Desc
/// Return：      X_"^"_Y
/// w ##class(DHCMed.CDService.PrintService).GetPositionNYZD("","")
ClassMethod GetPositionNYZD(aDicType As %String, aFieldDesc As %String) As %String
{
	New (aDicType,aFieldDesc)
	Set (PositionX,PositionY)=0
	Set return=PositionX_"^"_PositionY
	Quit:(aDicType="")||(aFieldDesc="") return
	
	Set ZDYYList=$lb("生产自用","12","6")
	Set ZDYYList=ZDYYList_$lb("生产性受雇","12","12")
	Set ZDYYList=ZDYYList_$lb("生活性误服(用)","12","19")
	Set ZDYYList=ZDYYList_$lb("生活性自服","12","27")
	
	Set WXXWList=$lb("阅读标签","18","6")
	Set WXXWList=WXXWList_$lb("徒手配药","18","12")
	Set WXXWList=WXXWList_$lb("使用防护用品","18","18")
	Set WXXWList=WXXWList_$lb("施药时吸烟","18","26")
	Set WXXWList=WXXWList_$lb("施药时进食","19","6")
	Set WXXWList=WXXWList_$lb("用手擦汗","19","12")
	Set WXXWList=WXXWList_$lb("药械滴漏","19","18")
	Set WXXWList=WXXWList_$lb("身体被农药污染","19","26")
	Set WXXWList=WXXWList_$lb("打药结束后清洗","20","6")
	Set WXXWList=WXXWList_$lb("感觉不适继续工作","20","14")
	
	Set ZDZGList=$lb("治愈","22","4")
	Set ZDZGList=ZDZGList_$lb("好转","22","8")
	Set ZDZGList=ZDZGList_$lb("死亡","22","12")
	Set ZDZGList=ZDZGList_$lb("其他","22","16")
	
	Set valExpress="Set ind=$ListFind("_aDicType_",aFieldDesc)"
	X valExpress
	Quit:ind<1 return
	Set valExpressX="Set PositionX=$List("_aDicType_",ind+1)"
	X valExpressX
	Set valExpressY="Set PositionY=$List("_aDicType_",ind+2)"
	X valExpressY
	
	Set return=PositionX_"^"_PositionY
	Quit return
}

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

/// Creator：     mxp
/// CreatDate：   2015-09-11
/// Description:  打印心脑血管报告卡
/// Table：       DHCMed.CD.CRReport
/// Input：       
/// Return：      
/// w ##class(DHCMed.CDService.PrintService).ExportCRRepXNXG("fillxlSheet","1")
ClassMethod ExportCRRepXNXG(itmjs As %String, strArguments As %String) As %String
{
	New (itmjs,strArguments)
	Set Count=0
	
	Set RepID=+$p(strArguments,"^",1)
	Set objRep=##class(DHCMed.CD.CRReport).GetObjById(RepID)
	Quit:'$IsObject(objRep) Count
	Set objPAT=##class(DHCMed.CD.CRReportPAT).GetObjByParRef(RepID)
	Quit:'$IsObject(objPAT) Count
	Set objXNXG=##class(DHCMed.CD.CRReportXNXG).GetObjByParRef(RepID)
	Quit:'$IsObject(objXNXG) Count
	
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objXNXG.CRKPBH,"O","JS")_"',3,4);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRDJH,"O","JS")_"',3,13);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objXNXG.CRBGKLX.Description,"O","JS")_"',3,21);"
	&javascript<#(retval)#>
	
	//病人基本信息
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRXM,"O","JS")_"',5,3);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRSFZH,"O","JS")_"',5,9);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRXB,"O","JS")_"',5,18);"
	&javascript<#(retval)#>
	Set PatAge=""
	If (objPAT.CRNLS'="") {
		Set PatAge=objPAT.CRNLS_"岁"
	} ElseIf (objPAT.CRNLY'="") {
		Set PatAge=objPAT.CRNLS_"月"
	} ElseIf (objPAT.CRNLT'="") {
		Set PatAge=objPAT.CRNLT_"天"
	}
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(PatAge,"O","JS")_"',5,21);"
	&javascript<#(retval)#>
	Set CSRQ=objPAT.CRCSRQ
	Set:CSRQ'="" CSRQ=$zd(CSRQ,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(CSRQ,"O","JS")_"',5,26);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRZY.Description,"O","JS")_"',6,3);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRGZ.Description,"O","JS")_"',6,14);"  //工种改为字典类型
	&javascript<#(retval)#>	
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRWHCD.Description,"O","JS")_"',6,24);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRMZ.Description,"O","JS")_"',7,3);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRHYZK.Description,"O","JS")_"',7,8);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRLXDH,"O","JS")_"',7,14);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRGZDW,"O","JS")_"',7,22);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZS.ShortDesc,"O","JS")_"',8,7);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZS2.ShortDesc,"O","JS")_"',8,11);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZX.ShortDesc,"O","JS")_"',8,15);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZX2.ShortDesc,"O","JS")_"',8,19);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZC,"O","JS")_"',8,24);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZXX,"O","JS")_"',9,6);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRHJDZS.ShortDesc,"O","JS")_"',10,7);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRHJDZS2.ShortDesc,"O","JS")_"',10,11);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRHJDZX.ShortDesc,"O","JS")_"',10,15);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRHJDZX2.ShortDesc,"O","JS")_"',10,19);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRHJDZC,"O","JS")_"',10,24);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRHJDZXX,"O","JS")_"',11,6);"
	&javascript<#(retval)#>
	
	//诊断、报告信息
	Set ZDStr=##class(DHCMed.CD.CRReportXNXG).GetICDDescByID(objXNXG.CRZDID)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(ZDStr,$c(1),2),"O","JS")_"',14,3);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objXNXG.CRZDBM,"O","JS")_"',14,14);"
	&javascript<#(retval)#>
	Set CRZDMC = objXNXG.CRZDMC
	Set GXBZD="",NCZZD=""
	Set:$p(CRZDMC,"-",2)="GXB" GXBZD=$p(CRZDMC,"-",1)
	Set:$p(CRZDMC,"-",2)="NCZ" NCZZD=$p(CRZDMC,"-",1)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(GXBZD,"O","JS")_"',15,5);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(NCZZD,"O","JS")_"',15,18);"
	&javascript<#(retval)#>
	
	Set chkY="☑",chkN="□"
	Set row=16,col=8
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("CRSYZZ","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set CheckFlg=0
		For ind=1:1:objXNXG.CRSYZZ.Count() {
			Set objDic=objXNXG.CRSYZZ.GetAt(ind)
			Continue:'$IsObject(objDic)
			Set SubID=objDic.%Id()
			Set:SubID=DicID CheckFlg=1
		}
		Set DicDesc=$s(CheckFlg:chkY,1:chkN)_DicDesc
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+$l(DicDesc)
	}
	Do rs.Close()
	
	Set row=17,col=3,count=0
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("CRZDBS","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set CheckFlg=0
		For ind=1:1:objXNXG.CRBS.Count() {
			Set objDic=objXNXG.CRBS.GetAt(ind)
			Continue:'$IsObject(objDic)
			Set SubID=objDic.%Id()
			Set:SubID=DicID CheckFlg=1
		}
		Set DicDesc=$s(CheckFlg:chkY,1:chkN)_DicDesc
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+8
		Set count=count+1
		Set:count#3=0 row=row+1,col=3
	}
	Do rs.Close()
	
	
	Set CRFBRQ=objXNXG.CRFBRQ
	Set:CRFBRQ'="" CRFBRQ=$zd(CRFBRQ,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(CRFBRQ,"O","JS")_"',19,4);"
	&javascript<#(retval)#>
	Set CRQZRQ=objXNXG.CRQZRQ
	Set:CRQZRQ'="" CRQZRQ=$zd(CRQZRQ,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(CRQZRQ,"O","JS")_"',19,11);"
	&javascript<#(retval)#>
	
	Set CRSFSCFB=$s(objXNXG.CRSFSCFB=1:chkY,1:chkN)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(CRSFSCFB,"O","JS")_"',20,6);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objXNXG.CRQZDW.Description,"O","JS")_"',20,11);"
	&javascript<#(retval)#>
	
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.CRReportOrgan,"O","JS")_"',21,4);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.CRReportUser,"O","JS")_"',22,4);"
	&javascript<#(retval)#>
	Set ReportDate=objRep.CRReportDate
	Set:ReportDate'="" ReportDate=$zd(ReportDate,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(ReportDate,"O","JS")_"',23,4);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objXNXG.CRSJJG.Description,"O","JS")_"',24,9);"
	&javascript<#(retval)#>
	
	//诊断依据
	Set row=20,col=20,count=0
	For ind=1:1:objXNXG.CRZDYJ.Count() {
		Set objDic=objXNXG.CRZDYJ.GetAt(ind)
		Continue:'$IsObject(objDic)		
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(objDic.Description,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set count=count+1
		Set:count#2=0 row=row+1,col=20
		Set:count#2=1 col=27
	}
	
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objXNXG.CRSHTD.Description,"O","JS")_"',26,20);"
	&javascript<#(retval)#>
	
	Set SWRQ=objXNXG.CRSWRQ
	Set:SWRQ'="" SWRQ=$zd(SWRQ,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(SWRQ,"O","JS")_"',28,4);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objXNXG.CRSWYY.Description,"O","JS")_"',28,13);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objXNXG.CRSYBM,"O","JS")_"',28,23);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objXNXG.CRSYMC,"O","JS")_"',29,6);" //死亡具体原因
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objXNXG.CRBSZY,"O","JS")_"',31,3);"
	&javascript<#(retval)#>
	
	
	q Count
}

/// Creator：     mxp
/// CreatDate：   2015-09-11
/// Description:  打印高温中暑报告卡
/// Table：       DHCMed.CD.CRReport
/// Input：       
/// Return：      
/// w ##class(DHCMed.CDService.PrintService).ExportCRRepGWZS("fillxlSheet","1")
ClassMethod ExportCRRepGWZS(itmjs As %String, strArguments As %String) As %String
{
	New (itmjs,strArguments)
	Set Count=0
	
	Set RepID=+$p(strArguments,"^",1)
	Set objRep=##class(DHCMed.CD.CRReport).GetObjById(RepID)
	Quit:'$IsObject(objRep) Count
	Set objPAT=##class(DHCMed.CD.CRReportPAT).GetObjByParRef(RepID)
	Quit:'$IsObject(objPAT) Count
	Set objGWZS=##class(DHCMed.CD.CRReportGWZS).GetObjByParRef(RepID)
	Quit:'$IsObject(objGWZS) Count
	
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objGWZS.CRKPBH,"O","JS")_"',3,4);"
	&javascript<#(retval)#>
	
	//病人基本信息
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRXM,"O","JS")_"',5,3);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRXB,"O","JS")_"',5,10);"
	&javascript<#(retval)#>
	Set PatAge=""
	If (objPAT.CRNLS'="") {
		Set PatAge=objPAT.CRNLS_"岁"
	} ElseIf (objPAT.CRNLY'="") {
		Set PatAge=objPAT.CRNLS_"月"
	} ElseIf (objPAT.CRNLT'="") {
		Set PatAge=objPAT.CRNLT_"天"
	}
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(PatAge,"O","JS")_"',5,14);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRLXDH,"O","JS")_"',5,20);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRSFZH,"O","JS")_"',6,4);"
	&javascript<#(retval)#>
	
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZS.ShortDesc,"O","JS")_"',7,6);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZS2.ShortDesc,"O","JS")_"',7,10);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZX.ShortDesc,"O","JS")_"',7,14);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZX2.ShortDesc,"O","JS")_"',7,18);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZC,"O","JS")_"',7,23);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRCZDZXX,"O","JS")_"',8,5);"
	&javascript<#(retval)#>
	
	//报告信息
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objGWZS.CRZSDD,"O","JS")_"',11,18);"
	&javascript<#(retval)#>
	
	Set chkY="☑",chkN="□"
	Set row=11,col=4
	Set ZSXZ=objGWZS.CRZSXZ.%Id()
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("CRZSXZ","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set DicDesc=$s(DicID=ZSXZ:chkY,1:chkN)_DicDesc
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+$l(DicDesc)
	}
	Do rs.Close()
	
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objGWZS.CRZSLCBX,"O","JS")_"',13,4);"
	&javascript<#(retval)#>
	
	Set row=16,col=4
	Set ZSZD=objGWZS.CRZSZD.%Id()
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("CRZSZD","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set DicDesc=$s(DicID=ZSZD:chkY,1:chkN)_DicDesc
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+$l(DicDesc)
	}
	Do rs.Close()
	
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objGWZS.CRZSLCBX,"O","JS")_"',17,4);"
	&javascript<#(retval)#>
	
	Set row=20,col=4
	Set ZSZG=objGWZS.CRZSZG.%Id()
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("CRZSZG","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set DicDesc=$s(DicID=ZSZG:chkY,1:chkN)_DicDesc
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+$l(DicDesc)
	}
	Do rs.Close()
	
	Set CRZDRQ=objGWZS.CRZDRQ
	Set:CRZDRQ'="" CRZDRQ=$zd(CRZDRQ,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(CRZDRQ,"O","JS")_"',22,4);"
	&javascript<#(retval)#>
	Set CRSWRQ=objGWZS.CRSWRQ
	Set:CRSWRQ'="" CRSWRQ=$zd(CRSWRQ,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(CRSWRQ,"O","JS")_"',22,14);"
	&javascript<#(retval)#>	
	
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.CRReportUser,"O","JS")_"',24,4);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.CRReportOrgan,"O","JS")_"',24,13);"
	&javascript<#(retval)#>
	Set ReportDate=objRep.CRReportDate
	Set:ReportDate'="" ReportDate=$zd(ReportDate,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(ReportDate,"O","JS")_"',24,24);"
	&javascript<#(retval)#>
	
	q Count
}

/// Creator：     pylian
/// CreatDate：   2016-04-28
/// Description:  打印慢性病报告卡
/// Table：       DHCMed.CD.CRReport
/// Input：       
/// Return：      
/// w ##class(DHCMed.CDService.PrintService).ExportCRRepMBBK("fillxlSheet","14")
ClassMethod ExportCRRepMBBK(itmjs As %String, strArguments As %String) As %String
{
	New (itmjs,strArguments)
	Set Count=0
	
	Set RepID=+$p(strArguments,"^",1)
	Set Flag=$p(strArguments,"^",2)
	Set objRep=##class(DHCMed.CD.CRReport).GetObjById(RepID)
	Quit:'$IsObject(objRep) Count
	Set objPAT=##class(DHCMed.CD.CRReportPAT).GetObjByParRef(RepID)
	Quit:'$IsObject(objPAT) Count
	Set objMBBK=##class(DHCMed.CD.CRReportMBBK).GetObjByParRef(RepID)
	Quit:'$IsObject(objMBBK) Count
	
	
	Set chkY="√"
	Set row=2,col=5   //报告类型
	Set CRBGKLX=objMBBK.CRBGKLX.%Id()
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("CRMBReportType","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set DicDesc=$s(DicID=CRBGKLX:chkY,1:"")
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+4
	}
	Do rs.Close()
	
	
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objMBBK.CRKPBH,"O","JS")_"',2,32);"
	&javascript<#(retval)#>

	//病人基本信息
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRMZH,"O","JS")_"',6,7);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRZYH,"O","JS")_"',6,16);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRXM,"O","JS")_"',7,7);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRXB,"O","JS")_"',7,15);"
	&javascript<#(retval)#>
	Set CSRQ=objPAT.CRCSRQ
	Set:CSRQ'="" CSRQ=$zd(CSRQ,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(CSRQ,"O","JS")_"',7,20);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRMZ.Description,"O","JS")_"',8,5);"
	&javascript<#(retval)#>
	
	Set PatAge=""
	If (objPAT.CRNLS'="") {
		Set PatAge=objPAT.CRNLS_"岁"
	} ElseIf (objPAT.CRNLY'="") {
		Set PatAge=objPAT.CRNLS_"月"
	} ElseIf (objPAT.CRNLT'="") {
		Set PatAge=objPAT.CRNLT_"天"
	}
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(PatAge,"O","JS")_"',8,10);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRWHCD.Description,"O","JS")_"',8,16);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRZY.Description,"O","JS")_"',8,23);"
	&javascript<#(retval)#>
	//身份证号
    Set retval=itmjs_"(xlSheet,'"_$ZCVT($e(objPAT.CRSFZH,1),"O","JS")_"',9,7);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($e(objPAT.CRSFZH,2),"O","JS")_"',9,8);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($e(objPAT.CRSFZH,3),"O","JS")_"',9,9);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($e(objPAT.CRSFZH,4),"O","JS")_"',9,10);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($e(objPAT.CRSFZH,5),"O","JS")_"',9,11);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($e(objPAT.CRSFZH,6),"O","JS")_"',9,12);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($e(objPAT.CRSFZH,7),"O","JS")_"',9,13);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($e(objPAT.CRSFZH,8),"O","JS")_"',9,14);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($e(objPAT.CRSFZH,9),"O","JS")_"',9,15);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($e(objPAT.CRSFZH,10),"O","JS")_"',9,16);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($e(objPAT.CRSFZH,11),"O","JS")_"',9,17);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($e(objPAT.CRSFZH,12),"O","JS")_"',9,18);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($e(objPAT.CRSFZH,13),"O","JS")_"',9,19);"
	&javascript<#(retval)#>
    Set retval=itmjs_"(xlSheet,'"_$ZCVT($e(objPAT.CRSFZH,14),"O","JS")_"',9,20);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($e(objPAT.CRSFZH,15),"O","JS")_"',9,21);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($e(objPAT.CRSFZH,16),"O","JS")_"',9,22);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($e(objPAT.CRSFZH,17),"O","JS")_"',9,23);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($e(objPAT.CRSFZH,18),"O","JS")_"',9,24);"
	&javascript<#(retval)#>
	
    //户口
    Set CRHJDZS=objPAT.CRHJDZS.ShortDesc_objPAT.CRHJDZS2.ShortDesc_objPAT.CRHJDZX.ShortDesc_objPAT.CRHJDZX2.ShortDesc_objPAT.CRHJDZC
    Set retval=itmjs_"(xlSheet,'"_$ZCVT(CRHJDZS,"O","JS")_"',10,7);"
	&javascript<#(retval)#>
	//常住
	Set CRCZDZS=objPAT.CRCZDZS.ShortDesc_objPAT.CRCZDZS2.ShortDesc_objPAT.CRCZDZX.ShortDesc_objPAT.CRCZDZX2.ShortDesc_objPAT.CRCZDZC
    Set retval=itmjs_"(xlSheet,'"_$ZCVT(CRCZDZS,"O","JS")_"',11,7);"
	&javascript<#(retval)#>
	
    Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRGZDW,"O","JS")_"',12,8);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPAT.CRLXDH,"O","JS")_"',12,23);"
	&javascript<#(retval)#>
	
	
	//诊断、报告信息
	Set FBRQ=objMBBK.CRFBRQ
	Set:FBRQ'="" FBRQ=$zd(FBRQ,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(FBRQ,"O","JS")_"',13,7);"
	&javascript<#(retval)#>
	
	Set chkY="☑",chkN="□"
	Set row=13,col=17   //是否发病日期为估计
	Set CRSFFBRQGJ=objMBBK.CRSFFBRQGJ.%Id()
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("CRMBSFFBRQGJ","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set DicDesc=$s(DicID=CRSFFBRQGJ:chkY,1:chkN)_DicDesc
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+$l(DicDesc)
	}
	Do rs.Close()
	
	
	Set QZRQ=objMBBK.CRQZRQ
	Set:QZRQ'="" QZRQ=$zd(QZRQ,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(QZRQ,"O","JS")_"',14,7);"
	&javascript<#(retval)#>
	
	Set SWRQ=objMBBK.CRSWRQ
	Set:SWRQ'="" SWRQ=$zd(SWRQ,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(SWRQ,"O","JS")_"',15,7);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objMBBK.CRJTSWYY,"O","JS")_"',15,21);"
	&javascript<#(retval)#>
	
	//诊断依据
	Set row=16,col=7,count=0
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("CRMBZDYJ","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set CheckFlg=0
		For ind=1:1:objMBBK.CRZDYJ.Count() {
			Set objDic=objMBBK.CRZDYJ.GetAt(ind)
			Continue:'$IsObject(objDic)
			Set SubID=objDic.%Id()
			Set:SubID=DicID CheckFlg=1
		}
		Set DicDesc=$s(CheckFlg:chkY,1:chkN)_DicDesc
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+3 
		Set count=count+1
		set:count#7=0 row=row+1,col=7
	}
	Do rs.Close()
	
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objMBBK.CRQZDW.Description,"O","JS")_"',18,7);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.CRReportOrgan,"O","JS")_"',19,7);"
	&javascript<#(retval)#>
	Set LocID=objRep.CRReportLoc
	Set LocDesc=$p($g(^CTLOC(+LocID)),"^",2)
	Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)               
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(LocDesc,"O","JS")_"',19,18);"
	&javascript<#(retval)#>
	
	Set chkY="☑",chkN="□"
	Set row=19,col=23   //上报位置（病房、门诊）
	Set CRSBWZ=objMBBK.CRSBWZ
	Set:$IsObject(CRSBWZ) CRSBWZ=CRSBWZ.%Id()
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("CRMBSBWZ","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set DicDesc=$s(DicID=CRSBWZ:chkY,1:chkN)_DicDesc
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+$l(DicDesc)
	}
	Do rs.Close()
	
	Set ReportDate=objRep.CRReportDate
	Set:ReportDate'="" ReportDate=$zd(ReportDate,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(ReportDate,"O","JS")_"',20,7);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.CRReportUser,"O","JS")_"',20,19);"
	&javascript<#(retval)#>
    
    If (Flag=1) {
	    Set objMBBK.CRNCZZD=""
   		Set objMBBK.CRTNBZD=""
   		Set objMBBK.CRZDMC=""
   		Set objMBBK.CRYFBW=""
		Set objMBBK.CRJFBW=""
		Set objMBBK.CRBLXLX=""
		Set objMBBK.CRZDBM=""
	    
    }
    If (Flag=2) {
	    Set objMBBK.CRGXBZD=""
	    Set objMBBK.CRTNBZD=""
   		Set objMBBK.CRZDMC=""
   		Set objMBBK.CRYFBW=""
		Set objMBBK.CRJFBW=""
		Set objMBBK.CRBLXLX=""
		Set objMBBK.CRZDBM=""
   		
    }
    If (Flag=3) {
	    Set objMBBK.CRGXBZD=""
	    Set objMBBK.CRNCZZD=""
	    Set objMBBK.CRZDMC=""
	    Set objMBBK.CRYFBW=""
		Set objMBBK.CRJFBW=""
		Set objMBBK.CRBLXLX=""
		Set objMBBK.CRZDBM=""
    }
    If (Flag=4) {
	     Set objMBBK.CRGXBZD=""
	     Set objMBBK.CRNCZZD=""
	     Set objMBBK.CRTNBZD=""
	    
    }Else {}
    Set Type=1
	Set ReportType=objMBBK.CRBGKLX.Description
	If ((ReportType="更正")&&(objMBBK.CRGZZD'="")) {
		Set Type=0
	}
	Set chkY="√"
	Set:Type=0 chkY="×"
	Set row=6,col=33   //冠心病诊断
	Set CRGXBZD=objMBBK.CRGXBZD
	Set:CRGXBZD'="" CRGXBZD=objMBBK.CRGXBZD.%Id()
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("CRMBGXBZD","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set DicDesc=$s(DicID=CRGXBZD:chkY,1:"")
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set row=row+1
	}
	Do rs.Close()

	Set row=10,col=33   //脑卒中诊断
	Set CRNCZZD=objMBBK.CRNCZZD
	Set:CRNCZZD'="" CRNCZZD=objMBBK.CRNCZZD.%Id()
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("CRMBNCZZD","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set DicDesc=$s(DicID=CRNCZZD:chkY,1:"")
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set row=row+1
	}
	Do rs.Close()

	Set row=14,col=33   //糖尿病诊断
	Set CRTNBZD=objMBBK.CRTNBZD
	Set:CRTNBZD'="" CRTNBZD=objMBBK.CRTNBZD.%Id()
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("CRMBTNBZD","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set DicDesc=$s(DicID=CRTNBZD:chkY,1:"")
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set row=row+1
	}
	Do rs.Close()
	
	Set CRGZZD=##class(DHCMed.CD.CRReportXNXG).GetICDDescByID(objMBBK.CRGZZD)  //更正诊断
	Set CRGZZD=$p(CRGZZD,$c(1),2)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(CRGZZD,"O","JS")_"',18,31);"
	&javascript<#(retval)#>
	Set ZDMC=##class(DHCMed.CD.CRReportXNXG).GetICDDescByID(objMBBK.CRZDMC)  //肿瘤诊断
	Set ZDMC=$p(ZDMC,$c(1),2)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(ZDMC,"O","JS")_"',19,31);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(ZDMC,"O","JS")_"',30,29);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objMBBK.CRYFBW,"O","JS")_"',32,29);"  
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objMBBK.CRJFBW,"O","JS")_"',35,29);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objMBBK.CRBLXLX,"O","JS")_"',37,29);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objMBBK.CRZDBM,"O","JS")_"',40,29);"
	&javascript<#(retval)#>	
	
	q Count
}

}
