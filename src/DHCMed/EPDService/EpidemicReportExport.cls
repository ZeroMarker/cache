/// 创建者：李阳
/// 创建日期：2011-06-22
/// 功能：用来处理传染病导出时需要的附加字典信息等
/// 
Class DHCMed.EPDService.EpidemicReportExport Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2016-07-08
/// Description:  通过登录用户ID获取CA签名图片
/// Table：       
/// Input：       aDocId: 
/// Return：      返回Object
/// w ##Class(DHCMed.EPDService.EpidemicReportExport).GetDocSignGif(105)
ClassMethod GetDocSignGif(aUserID As %String) As %String
{
	New (aUserID)
	Set return=""
	Set UserObj=##Class(CA.UsrSignatureInfo).GetInUseInfo(aUserID)
	Quit:'$IsObject(UserObj) return
	Set return =UserObj.SignImage
	Quit return
}

ClassMethod GetDic(argType As %String, argIsActive) As %String
{
	New (argType,argIsActive)
	Set return=""
	Quit:(argType="") return
	Set argType=$$ALPHAUP^SSUTIL4(argType)
	Quit:'$d(^DHCMed.SS.DictionaryI("IndexTypeCode"," "_argType)) return
	Set Rowid=""
	Set argCode=""
	For {
		Set argCode=$o(^DHCMed.SS.DictionaryI("IndexTypeCode"," "_argType,argCode))
		Quit:argCode=""
		For {
			Set Rowid=$o(^DHCMed.SS.DictionaryI("IndexTypeCode"," "_argType,argCode,Rowid))
			Quit:Rowid=""
			Set objDic=##class(DHCMed.SS.Dictionary).%OpenId(Rowid)
			do objDic.%Close()
			Set Code=objDic.Code
			Set Desc=objDic.Description
			Set IsActive=objDic.Active
			Set objDic=""
			Kill objDic
			Continue:(argIsActive'="")&&(IsActive'=argIsActive)
			Set:return'="" return=return_$c(1)
			Set return=return_Code_"^"_Desc
		}
	}
	Quit return
}

/// w ##Class(DHCMed.EPDService.EpidemicReportExport).GetEpidemicDic()
ClassMethod GetEpidemicDic()
{
	Set return=""
	Set RowID=""
	For {
		Set RowID=$o(^DHCMed.EPDC("IF",RowID))
		Quit:RowID=""
		set objInfDic=##class(DHCMed.EPD.Infection).GetObjById(RowID)
		Continue:'$IsObject(objInfDic)
		Continue:objInfDic.MIFIsActive'="Y"
		Set:return'="" return=return_$c(1)
		Set return=return_RowID_"^"_objInfDic.MIFDisease
		set objInfDic=""
		Kill objInfDic
	}
	Quit return
}

/// w ##Class(DHCMed.EPDService.EpidemicReportExport).GetAppendixDic()
ClassMethod GetAppendixDic()
{
	Set return=""
	Set RowID=""
	For {
		Set RowID=$o(^DHCMed.EPDC("AC",RowID)) 
		Quit:RowID=""
		Set objAppendix=##class(DHCMed.EPD.AppendixCard).GetObjById(RowID)
		Continue:'$IsObject(objAppendix)
		Set:return'="" return=return_$c(1)
		Set return=return_RowID_"^"_objAppendix.MACCode_"^"_objAppendix.MACDesc
		Set objAppendix=""
		Kill objAppendix
	}
	Quit return
}

/// 获取传染病副卡项目内容
ClassMethod GetAppendixContents(ReportID)
{
	n (ReportID)
	Set return=""
	
	set childSub=""
	while 1
	{
		set childSub=$o(^DHCMed.EPD("EPD",ReportID,"I",childSub))
		quit:childSub=""
		set objChild=##class(DHCMed.EPD.EpidemicSub).GetObjById(ReportID_"||"_childSub)
		continue:$IsObject(objChild)=0
		Set rowData=""
		do objChild.%Close()
		set objAppendixItm=##class(DHCMed.EPD.AppendixCardSub).%OpenId(objChild.MEPDSAppendixItemID)
	    continue:'$IsObject(objAppendixItm)  //add by pylian 20160308 修改传染病附卡打印报错
		d objAppendixItm.%Close()
		set $p(rowData,"^",1)=ReportID_"||"_childSub //RowID
		set $p(rowData,"^",2)=objAppendixItm.MACIName //名称
		set $p(rowData,"^",3)=objChild.MEPDSValue //显示值
		set $p(rowData,"^",4)=objAppendixItm.MACIDataType //数据类型
		set $p(rowData,"^",5)=objAppendixItm.MACIDicName //辅助字典名称
		set $p(rowData,"^",6)=objAppendixItm.%Id() //附卡项目ID
		Set:return'="" return=return_$c(1)
		Set return=return_rowData
		set objChild=""
		kill objChild
		set objAppendixItm=""
		Kill objAppendixItm
	}
	Quit return
}

/// 获取模板文件存放目录
/// w ##class(DHCMed.EPDService.EpidemicReportExport).GetTemplatePath()
ClassMethod GetTemplatePath() As %String
{
	New
	Set strPath=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("EPDTemplatePath")
	If strPath="" {
		Set objConfig=##class(websys.Configuration).%OpenId(1)
		Do objConfig.%Close()
		Set strPath=objConfig.PathToReports
	} Else {
		Set strPath=$tr(strPath,"/","\")
	}
	Quit strPath
}

/// 转换现住址取值(根据设置取现住址或取国标现住址)
/// w ##Class(DHCMed.EPDService.EpidemicReportExport).GetPrintAddress(1)
ClassMethod GetPrintAddress(aReportID As %String) As %String
{
	New (aReportID)
	Set return=""
	
	Set objReport=##Class(DHCMed.EPD.Epidemic).GetObjById(aReportID)
	Quit:'$IsObject(objReport) return
	
	Set GetAddressType=##Class(DHCMed.SSService.ConfigSrv).GetGlobalValueByKeyHosp("EpdPrintAddressType","")
	If GetAddressType="1" {  //取国标现住址
		Set Province=objReport.MEPDProvince
		Set objAddressDic=##Class(DHCMed.EPD.AreaDic).GetObjById(Province)
		Set:$IsObject(objAddressDic) Province=objAddressDic.ShortDesc
		
		Set City=objReport.MEPDCity
		Set objAddressDic=##Class(DHCMed.EPD.AreaDic).GetObjById(City)
		Set:$IsObject(objAddressDic) City=objAddressDic.ShortDesc
		Set:City="县" City=""
		Set:City="市" City=""
		Set:City="市辖区" City=""
		
		Set County=objReport.MEPDCounty
		Set objAddressDic=##Class(DHCMed.EPD.AreaDic).GetObjById(County)
		Set:$IsObject(objAddressDic) County=objAddressDic.ShortDesc
		
		Set Village=objReport.MEPDVillage
		Set objAddressDic=##Class(DHCMed.EPD.AreaDic).GetObjById(Village)
		Set:$IsObject(objAddressDic) Village=objAddressDic.ShortDesc
		
		Set Road=objReport.MEPDRoad
		
		Set return=Province
		Set:City'="" return=return_City
		Set:County'="" return=return_County
		Set:Village'="" return=return_Village
		Set:Road'="" return=return_Road
		
		Set:return="" return=objReport.MEPDAddress  //如果详细地址没有,存现住址
		
	} Else {  //取现住址
		Set return=objReport.MEPDAddress
	}
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2018-11-28
/// Description:  打印传染病报告
/// Table：       DHCMed.EPD.Epidemic
/// Input：       
/// Return：      
/// w ##class(DHCMed.EPDService.EpidemicReportExport).ExportEpidemic("fillxlSheet","15")
ClassMethod ExportEpidemic(itmjs As %String, aRepID As %String) As %String
{
	New (itmjs,aRepID)
	Set Count=0

	Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(aRepID)
	Quit:'$IsObject(objRep) Count
	Set PatientID = objRep.MEPDPapmiDR
	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	Quit:'$IsObject(objPatient) Count
	Set Paadm = objRep.MEPDText1
	Set objPaadm=##class(DHCMed.Base.PatientAdm).GetObjById(Paadm)
	Quit:'$IsObject(objPaadm) Count
	Set objLastRep=""
    If (objRep.MEPDStatus = 3)&(objRep.MEPDMepdDR'= ""){
		Set objLastRep =##class(DHCMed.EPD.Epidemic).GetObjById(objRep.MEPDMepdDR)  
		Quit:'$IsObject(objLastRep) Count
	}
	
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.MEPDText2,"O","JS")_"',3,5);"  //卡片编号
	&javascript<#(retval)#>
	Set chkY="☑",chkN="□"
	
	//订正原因 add by mayanpeng 2023-04-11
	Set ReviseReason=""
	Set DicRowID = 0
	For {
		Set DicRowID = $o(^DHCMed.SS.DictionaryI("IdxofType"," "_$ZCVT("EpidemicReviseReason","U"),DicRowID))
		Quit:DicRowID=""
		Set objDic = ##class(DHCMed.SS.Dictionary).GetObjById(DicRowID)
		Continue:'$IsObject(objDic)
		
		// 仅加载标记为有效的基础字典数据
		Set Active = objDic.Active
		Continue:Active'=1
		Set Description = objDic.Description
		Set ReviseReason = ReviseReason_$s((objRep.MEPDMepdDR'="")&&(Description=objRep.MEPDDelReason):chkY,1:chkN)_Description
	}
	
	If (objRep.MEPDMepdDR'= "") { //报卡类别
		Set EPDType = "1、"_chkN_"初次报告"_" 2、"_chkY_"订正报告"
		Set EPDType = EPDType_"("_ReviseReason_")"
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(EPDType,"O","JS")_"',3,19);"  
		&javascript<#(retval)#>
	} Else {
		Set EPDType = "1、"_chkY_"初次报告"_" 2、"_chkN_"订正报告"
		Set EPDType = EPDType_"("_ReviseReason_")"
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(EPDType,"O","JS")_"',3,19);"  
		&javascript<#(retval)#>
	}
	//基本信息
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPatient.PatientName,"O","JS")_"',6,4);"  //姓名
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.MEPDFamName,"O","JS")_"',6,23);"     //家长姓名
	&javascript<#(retval)#>
	
	//对有效证件号打印的处理
	Set PersonalID = objPatient.PersonalID  //身份证号
	Set CardNo   = objRep.MEPDText5
	Set CardType = objRep.MEPDText4	
	If ((CardNo'="")&&(CardType'="")){
		Set PersonalID = CardNo
	}
    Set retval=itmjs_"(xlSheet,'"_$ZCVT($e(PersonalID,1),"O","JS")_"',8,6);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($e(PersonalID,2),"O","JS")_"',8,8);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($e(PersonalID,3),"O","JS")_"',8,10);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($e(PersonalID,4),"O","JS")_"',8,12);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($e(PersonalID,5),"O","JS")_"',8,14);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($e(PersonalID,6),"O","JS")_"',8,16);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($e(PersonalID,7),"O","JS")_"',8,18);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($e(PersonalID,8),"O","JS")_"',8,20);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($e(PersonalID,9),"O","JS")_"',8,22);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($e(PersonalID,10),"O","JS")_"',8,24);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($e(PersonalID,11),"O","JS")_"',8,26);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($e(PersonalID,12),"O","JS")_"',8,28);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($e(PersonalID,13),"O","JS")_"',8,30);"
	&javascript<#(retval)#>
    Set retval=itmjs_"(xlSheet,'"_$ZCVT($e(PersonalID,14),"O","JS")_"',8,32);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($e(PersonalID,15),"O","JS")_"',8,34);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($e(PersonalID,16),"O","JS")_"',8,36);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($e(PersonalID,17),"O","JS")_"',8,38);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($e(PersonalID,18),"O","JS")_"',8,40);"
	&javascript<#(retval)#>
	
	Set Sex = objPatient.Sex
	If (Sex="男") {
		Set Sex = chkY_"男"_" "_chkN_"女"
       	Set retval=itmjs_"(xlSheet,'"_$ZCVT(Sex,"O","JS")_"',8,44);"  
		&javascript<#(retval)#>
	}Else {
		Set Sex = chkN_"男"_" "_chkY_"女"
       	Set retval=itmjs_"(xlSheet,'"_$ZCVT(Sex,"O","JS")_"',8,44);"  
		&javascript<#(retval)#>
	}
	
	Set Birthday = objPatient.Birthday
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(Birthday,"O","JS")_"',10,5);"  //出生日期
	&javascript<#(retval)#>
	//年龄
	Set PatAge = ##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(objRep.MEPDPapmiDR,objRep.MEPDText1,objPaadm.AdmitDate,objPaadm.AdmitTime)		
		If (PatAge["岁"){
		Set PatAge = $p(PatAge,"岁",1)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(PatAge,"O","JS")_"',10,32);"
		&javascript<#(retval)#>
		Set Age = chkY_"岁"_" "_chkN_"月"_" "_chkN_"天"
       	Set retval=itmjs_"(xlSheet,'"_$ZCVT(Age,"O","JS")_"',10,42);"  
		&javascript<#(retval)#>
	}ElseIf (PatAge["月"){
		Set PatAge = $p(PatAge,"月",1)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(PatAge,"O","JS")_"',10,32);"
		&javascript<#(retval)#>
		Set Age = chkN_"岁"_" "_chkY_"月"_" "_chkN_"天"
       	Set retval=itmjs_"(xlSheet,'"_$ZCVT(Age,"O","JS")_"',10,42);"  

		&javascript<#(retval)#>
	}ElseIf ((PatAge'["月")&&(PatAge["天")) {
		Set PatAge = $p(PatAge,"天",1)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(PatAge,"O","JS")_"',10,32);"
		&javascript<#(retval)#>
		Set Age = chkN_"岁"_" "_chkN_"月"_" "_chkY_"天"
       	Set retval=itmjs_"(xlSheet,'"_$ZCVT(Age,"O","JS")_"',10,42);"  
		&javascript<#(retval)#>
	}Else {
		Set retval=itmjs_"(xlSheet,'1',10,32);"   //update 20200206 年龄为小时打印错误修改
		&javascript<#(retval)#>
		Set Age = chkN_"岁"_" "_chkN_"月"_" "_chkY_"天"
       	Set retval=itmjs_"(xlSheet,'"_$ZCVT(Age,"O","JS")_"',10,42);"  
		&javascript<#(retval)#>
	}		
	
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.MEPDCompany,"O","JS")_"',12,9);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.MEPDTelPhone,"O","JS")_"',12,42);"
	&javascript<#(retval)#>
	
	Set chkY="☑",chkN="□"   //病人属于
	Set Area=objRep.MEPDArea
	Set AreaList = ""
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("EpidemicReportRegion","1")
	While rs.Next() {
		Set DicCode=rs.Get("Code")
		Set DicDesc=rs.Get("Description")
		Set AreaList =AreaList_"  "_ $s(DicCode=Area:chkY,1:chkN)_DicDesc
	}
	Set:AreaList'="" AreaList=$e(AreaList,2,$l(AreaList))
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(AreaList,"O","JS")_"',14,5);"
	&javascript<#(retval)#>
	Do rs.Close()
	
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.MEPDAddress,"O","JS")_"',15,9);"
	&javascript<#(retval)#>
	
	Set chkY="☑",chkN="□"   //人群分类
	Set Occupation=objRep.MEPDOccupation
	Set OccText=objRep.MEPDText6
	Set DicDescList=""
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("Career","1")
	While rs.Next() {
		Set DicCode=rs.Get("Code")
		Set DicDesc=rs.Get("Description")
		Set:(DicDesc="其他")&(DicCode=Occupation) DicDesc=DicDesc_"（"_OccText_"）"
		Set DicDescList=DicDescList_"、"_$s(DicCode=Occupation:chkY,1:chkN)_DicDesc
		
	}
	Set:DicDescList'="" DicDescList=$e(DicDescList,2,$l(DicDescList))
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDescList,"O","JS")_"',18,2);"
	&javascript<#(retval)#>
	Do rs.Close()
	
	Set chkY="☑",chkN="□"  //诊断分类
	Set DiagDegree=objRep.MEPDDiagDegree
	Set DicDescList=""
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("EpidemicDiagnoseDegree","1")
	While rs.Next() {
		Set DicCode=rs.Get("Code")
		Set DicDesc=rs.Get("Description")
		Set DicDescList=DicDescList_"、"_$s(DicCode=DiagDegree:chkY,1:chkN)_DicDesc
	}
	Set:DicDescList'="" DicDescList=$e(DicDescList,2,$l(DicDescList))
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDescList,"O","JS")_"',19,7);"
	&javascript<#(retval)#>
	Do rs.Close()
	
	Set chkY="☑",chkN="□"  //发病程度
	Set SickKind=objRep.MEPDSickKind
	Set DicDescList=""
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("EpidemicSickQuality","1")
	While rs.Next() {
		Set DicCode=rs.Get("Code")
		Set DicDesc=rs.Get("Description")
		Set DicDescList=DicDescList_"、"_$s(DicCode=SickKind:chkY,1:chkN)_DicDesc
	}
	Set:DicDescList'="" DicDescList=$e(DicDescList,2,$l(DicDescList))
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDescList,"O","JS")_"',20,7);"
	&javascript<#(retval)#>
	Do rs.Close()
	
	//add 20200203
	Set chkY="☑",chkN="□"   //临床严重程度
	Set Severity=objRep.MEPDSeverity
	Set SeverityList = ""
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("EpidemicSeverity","1")
	While rs.Next() {
		Set DicCode=rs.Get("Code")
		Set DicDesc=rs.Get("Description")
		Set SeverityList =SeverityList_"  "_ $s(DicCode=Severity:chkY,1:chkN)_DicDesc
	}
	Set:SeverityList'="" SeverityList=$e(SeverityList,2,$l(SeverityList))
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(SeverityList,"O","JS")_"',21,7);"
	&javascript<#(retval)#>
	Do rs.Close()
    
    // 是否为输入病例
    Set chkY="☑",chkN="□"   //临床严重程度
	Set IsInEPDDesc="" 
	Set objRepMEPDIsInEPD=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPDIsCheck",objRep.MEPDIsInEPD,"")
	If $IsObject(objRepMEPDIsInEPD){
		Set IsInEPDDesc=objRepMEPDIsInEPD.Description
	}
	If (IsInEPDDesc="是") {
		Set IsInEPDDesc = chkY_"是"_"  "_chkN_"否"
       	Set retval=itmjs_"(xlSheet,'"_$ZCVT(IsInEPDDesc,"O","JS")_"',24,8);"  
		&javascript<#(retval)#>
	}Else {
		Set IsInEPDDesc = chkN_"是"_"  "_chkY_"否"
       	Set retval=itmjs_"(xlSheet,'"_$ZCVT(IsInEPDDesc,"O","JS")_"',24,8);"  
		&javascript<#(retval)#>
	}
	// 入境前居住国家或地区
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.MEPDContr,"O","JS")_"',24,39);" 
	&javascript<#(retval)#>
	
	Set SickDate = objRep.MEPDSickDate
	Set:SickDate'="" SickDate=$zd(SickDate,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(SickDate,"-",1),"O","JS")_"',22,5);"  //发病日期
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(SickDate,"-",2),"O","JS")_"',22,9);"  //发病日期
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(SickDate,"-",3),"O","JS")_"',22,13);"  //发病日期
	&javascript<#(retval)#>
	Set DiagDate = objRep.MEPDDiagDate
	Set:DiagDate'="" DiagDate=$zd(DiagDate,3)
	Set DiagDateTime = objRep.MEPDDiagDateTime
	
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(DiagDate,"-",1),"O","JS")_"',22,27);"  //诊断日期时间
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(DiagDate,"-",2),"O","JS")_"',22,33);"  //诊断日期时间
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(DiagDate,"-",3),"O","JS")_"',22,37);"  //诊断日期时间
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($p($p(DiagDateTime," ",2),":",1),"O","JS")_"',22,42);"  //诊断日期时间
	&javascript<#(retval)#>
	Set DeathDate = objRep.MEPDDeathDate
	Set:DeathDate'="" DeathDate=$zd(DeathDate,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(DeathDate,"-",1),"O","JS")_"',26,5);"  //死亡日期
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(DeathDate,"-",2),"O","JS")_"',26,9);"  //死亡日期
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(DeathDate,"-",3),"O","JS")_"',26,13);"  //死亡日期
	&javascript<#(retval)#>

	Set RepDisease=objRep.MEPDICDDR.MIFDisease	//传染病诊断名称
	Set RepKindID = objRep.MEPDICDDR.MIFKind
	Set RepKind=""
	Set objRepKind=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPDEMICTYPE",RepKindID,"")
	If $IsObject(objRepKind){
		Set RepKind=objRepKind.Description
	}
	Set:RepKind="AFP" RepDisease=RepKind
	Set DiseaseList = ..GetEpidemic(RepDisease)
  
	Set ListA =$p(DiseaseList,"^",1)  //甲类传染病
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(ListA,"O","JS")_"',29,2);"  //传染病诊断
	&javascript<#(retval)#>
	Set ListB =$p(DiseaseList,"^",2)  //乙类传染病
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(ListB,"O","JS")_"',31,2);"  //传染病诊断
	&javascript<#(retval)#>
	Set ListC =$p(DiseaseList,"^",3)  //丙类传染病
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(ListC,"O","JS")_"',33,2);"  //传染病诊断
	&javascript<#(retval)#>
	Set ListD =$p(DiseaseList,"^",4)  //其他传染病
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(ListD,"O","JS")_"',35,2);"  //传染病诊断
	&javascript<#(retval)#>
	
	If (objRep.MEPDStatus = "3")&($IsObject(objLastRep)) { //修订报告 
        Set Disease =  objLastRep.MEPDICDDR.MIFDisease
        Set retval=itmjs_"(xlSheet,'"_$ZCVT(Disease,"O","JS")_"',36,5);"  //订正病名
		&javascript<#(retval)#>
	}
	Set RepLoc = objRep.MEPDLocDR
	Set HospID=$p($g(^CTLOC(RepLoc)),"^",22)
	Set HospDesc=""
	Set:HospID'="" HospDesc=$p($g(^CT("HOSP",HospID)),"^",2)
	Set RepLocDesc=""
	Set LocTelephone = ""
	Set objRepLoc=##class(DHCMed.Base.Ctloc).GetObjById(RepLoc)
	If $IsObject(objRepLoc){
		Set RepLocDesc=objRepLoc.Descs
		Set LocTelephone = objRepLoc.Telephone
	}
	Set:HospDesc'="" RepLocDesc=HospDesc
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(RepLocDesc,"O","JS")_"',37,5);"  //报告单位
	&javascript<#(retval)#>
	Set RepUser=objRep.MEPDRepUsrDR                 //报告人
	Set RepUserName=""
	Set objRepUser=##class(DHCMed.Base.SSUser).GetObjById(RepUser)
	If $IsObject(objRepUser){
		Set RepUserCode=objRepUser.Code
		Set RepUserName=objRepUser.Name
	}
	//打印电子签名（判断报告是否进行CA认证）
	Set IsSign=##Class(DHCMed.CA.SignVerify).GetRepIsSign("EPD","EPD",aRepID,"S")
	Set:IsSign=1 RepUserName=""

	Set retval=itmjs_"(xlSheet,'"_$ZCVT(RepUserName,"O","JS")_"',38,5);"  //填卡医生
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.MEPDDelReason,"O","JS")_"',36,41);"  //退卡原因
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(LocTelephone,"O","JS")_"',37,41);"  //联系电话
	&javascript<#(retval)#>
	Set RepDate= objRep.MEPDRepDate
	Set:RepDate'="" RepDate=$zd(RepDate,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(RepDate,"O","JS")_"',38,41);"  //填卡日期
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.MEPDDemo,"O","JS")_"',41,2);"  //备注
	&javascript<#(retval)#>
	

	q Count
}

/// w ##Class(DHCMed.EPDService.EpidemicReportExport).Test("□鼠疫、□霍乱","霍乱")
ClassMethod Test(aStr As %String, aDesc As %String) As %String
{
	New (aStr,aDesc)
	
	Set Len =$l(aStr,"、")
	Set Str=""
	For ind=1:1:Len {
		Set TmpStr=$p(aStr,"、",ind)
		Set:TmpStr[aDesc TmpStr = $tr(TmpStr,"□","☑")
		Set Str=Str_""_TmpStr
	}
	Quit Str
}

/// w ##Class(DHCMed.EPDService.EpidemicReportExport).GetEpidemic("伤寒")
ClassMethod GetEpidemic(aDesc As %String, aDICDesc As %String = "") As %String
{
	New (aDesc,aDICDesc)
	Set StringA="鼠疫>鼠疫,霍乱>霍乱"
	Set StringB="传染性非典型肺炎>传染性非典型肺炎,艾滋病（艾滋病>艾滋病病人,HIV>HIV）,病毒性肝炎（甲型病毒性肝炎>甲型,乙型病毒性肝炎>乙型,丙型病毒性肝炎>丙型,丁型病毒性肝炎>丁型,戊型病毒性肝炎>戊型,病毒性肝炎未分型>未分型）,脊髓灰质炎>脊髓灰质炎,人感染高致病性禽流感>人感染高致病性禽流感,麻疹>麻疹,流行性出血热>流行性出血热,狂犬病>狂犬病,流行性乙型脑炎>流行性乙型脑炎,登革热>登革热,炭疽（肺炭疽>肺炭疽,皮肤炭疽>皮肤炭疽,炭疽未分型>未分型）,痢疾（细菌性痢疾>细菌性,阿米巴性痢疾>阿米巴性）,肺结核（肺结核利福平耐药>利福平耐药,肺结核病原学阳性>病原学阳性,肺结核病原学阴性>病原学阴性,肺结核无病原学结果>无病原学结果）,伤寒（伤寒>伤寒,副伤寒>副伤寒）,流行性脑脊髓膜炎>流行性脑脊髓膜炎,百日咳>百日咳,白喉>白喉,新生儿破伤风>新生儿破伤风,猩红热>猩红热,布鲁氏菌病>布鲁氏菌病,淋病>淋病,梅毒（梅毒Ⅰ期>I期,梅毒Ⅱ期>II期,梅毒Ⅲ期>III期,胎传梅毒>胎传,隐性梅毒>隐性）,钩端螺旋体病>钩端螺旋体病,血吸虫病>血吸虫病,疟疾（间日疟>间日疟,恶性疟>恶性疟,疟疾未分型>未分型）,人感染H7N9禽流感>人感染H7N9禽流感,新型冠状病毒感染>新型冠状病毒感染"
	Set StringC="流行性感冒>流行性感冒,流行性腮腺炎>流行性腮腺炎,风疹>风疹,急性出血性结膜炎>急性出血性结膜炎,麻风病>麻风病,流行性和地方性斑疹伤寒>流行性和地方性斑疹伤寒,黑热病>黑热病,包虫病>包虫病,丝虫病>丝虫病,其它感染性腹泻病>除霍乱、细菌性和阿米巴性痢疾、伤寒和副伤寒以外的感染性腹泻病,手足口病>手足口病"
	Set StringD="非淋菌性尿道炎>非淋菌性尿道炎,尖锐湿疣>尖锐湿疣,生殖器疱疹>生殖器疱疹,水痘>水痘,恙虫病>恙虫病,生殖道沙眼衣原体感染>生殖道沙眼衣原体感染,肝吸虫病>肝吸虫病,森林脑炎>森林脑炎,人感染猪链球菌>人感染猪链球菌,不明原因肺炎>不明原因肺炎,AFP>AFP,发热伴血小板减少综合征>发热伴血小板减少综合征,人粒细胞无形体病>人粒细胞无形体病,埃博拉出血热>埃博拉出血热,猴痘>猴痘,其它>其它"
	Set LenA =$l(StringA,",")
	Set LenB =$l(StringB,",")
	Set LenC =$l(StringC,",")
	Set LenD =$l(StringD,",")
	Set StringNCP = "（轻症病例>轻型,普通肺炎>中型,重症肺炎>重型,危重症肺炎>危重型）"
	Set LenNCP =$l(StringNCP,",")
	Set (StrA,StrB,StrC,StrD,StrNCP)=""
	For indA=1:1:LenA {
		Set TmpStr=$p(StringA,",",indA)
		Set Str=""
		If (TmpStr["（")  {
			Set Str=$p(TmpStr,"（",1)_"（"
			Set TmpStr = $p(TmpStr,"（",2)
		}
		If ($p(TmpStr,">",1)=aDesc) {
			Set TmpStr =Str_"☑"_$p(TmpStr,">",2)
		}ELse {
			Set TmpStr =Str_"□"_$p(TmpStr,">",2)
		}
		Set StrA=StrA_"、"_TmpStr
	}
    Set:StrA'="" StrA=$e(StrA,2,$l(StrA))
	For indB=1:1:LenB {
		Set TmpStr=$p(StringB,",",indB)
		Set Str=""
		If (TmpStr["（")  {
			Set Str=$p(TmpStr,"（",1)_"（"
			Set TmpStr = $p(TmpStr,"（",2)
		}
		If ($p(TmpStr,">",1)=aDesc) {
			Set TmpStr =Str_"☑"_$p(TmpStr,">",2)
		}ELse {
			Set TmpStr =Str_"□"_$p(TmpStr,">",2)
		}
		Set StrB=StrB_"、"_TmpStr
	}
	Set:StrB'="" StrB=$e(StrB,2,$l(StrB))
	
	
	For indNCP=1:1:LenNCP {
		Set TmpStr=$p(StringNCP,",",indNCP)
		Set Str=""
		If (TmpStr["（")  {
			Set Str=$p(TmpStr,"（",1)_"（"
			Set TmpStr = $p(TmpStr,"（",2)
		}
		If ($p(TmpStr,">",1)=aDICDesc) {
			Set TmpStr =Str_"☑"_$p(TmpStr,">",2)
		}ELse {
			Set TmpStr =Str_"□"_$p(TmpStr,">",2)
		}
		Set StrNCP=StrNCP_"、"_TmpStr
	}
	Set:StrNCP'="" StrNCP=$e(StrNCP,2,$l(StrNCP))
	For indC=1:1:LenC {
		Set TmpStr=$p(StringC,",",indC)
		Set Str=""
		If (TmpStr["（")  {
			Set Str=$p(TmpStr,"（",1)_"（"
			Set TmpStr = $p(TmpStr,"（",2)
		}
		If ($p(TmpStr,">",1)=aDesc) {
			Set TmpStr =Str_"☑"_$p(TmpStr,">",2)
		}ELse {
			Set TmpStr =Str_"□"_$p(TmpStr,">",2)
		}
		Set StrC=StrC_"、"_TmpStr
	}
	Set:StrC'="" StrC=$e(StrC,2,$l(StrC))
	For indD=1:1:LenD {
		Set TmpStr=$p(StringD,",",indD)
		Set Str=""
		If (TmpStr["（")  {
			Set Str=$p(TmpStr,"（",1)_"（"
			Set TmpStr = $p(TmpStr,"（",2)			
		}
		If ($p(TmpStr,">",1)=aDesc) {
			Set TmpStr =Str_"☑"_$p(TmpStr,">",2)
		}ELse {
			Set TmpStr =Str_"□"_$p(TmpStr,">",2)
		}
		Set StrD=StrD_"、"_TmpStr
	}
	Set:StrD'="" StrD=$e(StrD,2,$l(StrD))
	Quit StrA_"^"_StrB_StrNCP_"^"_StrC_"^"_StrD
}

/// Creator：     pylian
/// CreatDate：   2018-12-08
/// Description:  打印传染病报告艾滋病附卡
/// Table：       DHCMed.EPD.Epidemic
/// Input：       
/// Return：      
/// w ##class(DHCMed.EPDService.EpidemicReportExport).ExportHIVEpd("fillxlSheet","2")
ClassMethod ExportHIVEpd(itmjs As %String, aRepID As %String) As %String
{
	New (itmjs,aRepID)
	Set Count=0
	
	Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(aRepID)
	Quit:'$IsObject(objRep) Count
	Set PatientID = objRep.MEPDPapmiDR
	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	Quit:'$IsObject(objPatient) Count
	Set Paadm = objRep.MEPDText1
	Set objPaadm=##class(DHCMed.Base.PatientAdm).GetObjById(Paadm)
	Quit:'$IsObject(objPaadm) Count 

	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.MEPDText2,"O","JS")_"',4,6);"  //卡片编号
	&javascript<#(retval)#>
	
	//基本信息
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPatient.PatientName,"O","JS")_"',6,5);"  //姓名
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.MEPDFamName,"O","JS")_"',6,16);"     //家长姓名
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPatient.Nation,"O","JS")_"',6,29);"      //民族
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.MEPDAddress,"O","JS")_"',9,5);"
	&javascript<#(retval)#>
	Set RepLoc = objRep.MEPDLocDR
	Set RepLocDesc=""
	Set LocTelephone = ""
	Set objRepLoc=##class(DHCMed.Base.Ctloc).GetObjById(RepLoc)
	If $IsObject(objRepLoc){
		Set RepLocDesc=objRepLoc.Descs
		Set LocTelephone = objRepLoc.Telephone
	}
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(RepLocDesc,"O","JS")_"',42,8);"  //报告单位
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(LocTelephone,"O","JS")_"',42,27);"  //联系电话
	&javascript<#(retval)#>
	Set RepUser=objRep.MEPDRepUsrDR                 //报告人
	Set RepUserName=""
	Set objRepUser=##class(DHCMed.Base.SSUser).GetObjById(RepUser)
	If $IsObject(objRepUser){
		Set RepUserCode=objRepUser.Code
		Set RepUserName=objRepUser.Name
	}
	
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(RepUserName,"O","JS")_"',43,6);"  //填卡医生
	&javascript<#(retval)#>

	Set RepDate= objRep.MEPDRepDate
	Set:RepDate'="" RepDate=$zd(RepDate,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(RepDate,"O","JS")_"',43,23);"  //填卡日期
	&javascript<#(retval)#>	
	Set ds=##Class(%ResultSet).%New("DHCMed.EPDService.EpidemicSubSrv:QryEpidemicSubInfo")
	Do ds.Execute(aRepID)
	While ds.Next() {
		Set ItemCode=ds.Data("ItemCode")
		Set ItemValue=ds.Data("ItemValue")
		Set ItemDic=ds.Data("ItemDic")
		Set HiddenValue=ds.Data("HiddenValue")
		
		Set chkY="☑",chkN="□"   
		If (ItemCode="cboHIVMarriage") { //婚姻状况
		    set row=7, col=5			
			Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
			Do rs.Execute(ItemDic,"1")
			While rs.Next() {
				Set DicCode=rs.Get("Code")
				Set DicDesc=rs.Get("Description")
				Set DicDesc=$s(DicCode=HiddenValue:chkY,1:chkN)_DicDesc							
				Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
				&javascript<#(retval)#>
				Set col=col+5
			}
			Do rs.Close()
		}
	
		If (ItemCode="cboHIVEducation") { //文化程度		
			Set row=8, col=5	
			Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
			Do rs.Execute(ItemDic,"1")
	
			While rs.Next() {
				Set DicCode=rs.Get("Code")
				Set DicDesc=rs.Get("Description")
				Set DicDesc=$s(DicCode=HiddenValue:chkY,1:chkN)_DicDesc							
				Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
				&javascript<#(retval)#>
				Set col=col+5
			}
			Do rs.Close()
		}
		If (ItemCode="chkHIVDiaTypeList") { //疾病名称	
		    For ind=1:1:$l(ItemValue,",") {
				Set Value=$p(ItemValue,",",ind)
				If (Value="艾滋病病毒感染"){
			 		Set retval=itmjs_"(xlSheet,'☑',12,2);"
					&javascript<#(retval)#>
				}
			    If (Value="艾滋病"){
			 		Set retval=itmjs_"(xlSheet,'☑',12,24);"
					&javascript<#(retval)#>
				}
				If (Value="淋病"){
			 		Set retval=itmjs_"(xlSheet,'☑',13,24);"
					&javascript<#(retval)#>
				}
				If (Value="尖锐湿疣"){
			 		Set retval=itmjs_"(xlSheet,'☑',14,23);"
					&javascript<#(retval)#>
				}
				If (Value="生殖器疱疹"){
			 		Set retval=itmjs_"(xlSheet,'☑',14,29);"
					&javascript<#(retval)#>
				}			
		    }
		}
		If (ItemCode="radHIVSexPeriodList") {   //梅毒分期
		 	If (ItemValue["一期"){
			 	Set retval=itmjs_"(xlSheet,'☑',13,4);"
				&javascript<#(retval)#>
			}
			If (ItemValue["二期"){
		 		Set retval=itmjs_"(xlSheet,'☑',13,8);"
				&javascript<#(retval)#>
			}
			If (ItemValue["三期"){
		 		Set retval=itmjs_"(xlSheet,'☑',13,12);"
				&javascript<#(retval)#>
			}
			If (ItemValue["胎传"){
		 		Set retval=itmjs_"(xlSheet,'☑',13,16);"
				&javascript<#(retval)#>
			}
			If (ItemValue["隐性"){
		 		Set retval=itmjs_"(xlSheet,'☑',13,20);"
				&javascript<#(retval)#>
			}
	    }
	    If (ItemCode="radHIVTrachomaInfList") {   //生殖道沙眼衣原体感染    
		 	If (ItemValue="确诊病例"){
		 		Set retval=itmjs_"(xlSheet,'☑',14,9);"
				&javascript<#(retval)#>
			}
			If (ItemValue="无症状感染"){
		 		Set retval=itmjs_"(xlSheet,'☑',14,14);"
				&javascript<#(retval)#>
			}
	    }
	  
	    If (ItemCode="chk-HIVDrugHistory")&&(HiddenValue=1) {   //注射毒品史    
		 	Set retval=itmjs_"(xlSheet,'☑',16,2);"
			&javascript<#(retval)#>
	    }
	    If (ItemCode="num-HIVInjection") {   //共用过注射器人数    
		 	Set retval=itmjs_"(xlSheet,'"_$ZCVT(HiddenValue,"O","JS")_"',16,11);"
			&javascript<#(retval)#>
	    }
	    If (ItemCode="chk-HIVUnmarHistory")&&(HiddenValue=1) {   //非婚异性性接触史   
		 	Set retval=itmjs_"(xlSheet,'☑',17,2);"
			&javascript<#(retval)#>
	    }
	    If (ItemCode="num-HIVUnmarried") {   //非婚性行为人数   
		 	Set retval=itmjs_"(xlSheet,'"_$ZCVT(HiddenValue,"O","JS")_"',17,13);"
			&javascript<#(retval)#>
	    }
	    If (ItemCode="chk-HIVFixedCom")&&(HiddenValue=1) {   //配偶/固定性伴阳性    
		 	Set retval=itmjs_"(xlSheet,'☑',18,2);"
			&javascript<#(retval)#>
	    }
	    If (ItemCode="chk-HIVMSMHistory")&&(HiddenValue=1) {   //男男性行为史    
		 	Set retval=itmjs_"(xlSheet,'☑',19,2);"
			&javascript<#(retval)#>
	    }
	    If (ItemCode="num-HIVMSM") {   //同性性行为人数    
		 	Set retval=itmjs_"(xlSheet,'"_$ZCVT(HiddenValue,"O","JS")_"',19,12);"
			&javascript<#(retval)#>
	    }
	    If (ItemCode="chk-HIVBloodDona")&&(HiddenValue=1) {   //献血(浆)史    
		 	Set retval=itmjs_"(xlSheet,'☑',20,2);"
			&javascript<#(retval)#>
	    }
	    If (ItemCode="chk-HIVBloodTran")&&(HiddenValue=1) {   //输血/血制品史    
		 	Set retval=itmjs_"(xlSheet,'☑',20,10);"
			&javascript<#(retval)#>
	    }
	    If (ItemCode="chk-HIVMotherPose")&&(HiddenValue=1) {   //母亲阳性    
		 	Set retval=itmjs_"(xlSheet,'☑',20,20);"
			&javascript<#(retval)#>
	    }
        If (ItemCode="chk-HIVBloodTran")&&(HiddenValue=1) {   //职业暴露史    
		 	Set retval=itmjs_"(xlSheet,'☑',20,28);"
			&javascript<#(retval)#>
	    }
	    If (ItemCode="chk-HIVOperation")&&(HiddenValue=1) {   //手术史    
		 	Set retval=itmjs_"(xlSheet,'☑',21,2);"
			&javascript<#(retval)#>
	    }
	    If (ItemCode="chk-HIVQtResume")&&(HiddenValue=1) {   //接触史其他    
		 	Set retval=itmjs_"(xlSheet,'☑',21,10);"
			&javascript<#(retval)#>
	    }
	    If (ItemCode="txt-HIVQtResume") {   //其他详细说明   
		 	Set retval=itmjs_"(xlSheet,'"_$ZCVT(HiddenValue,"O","JS")_"',21,13);"
			&javascript<#(retval)#>
	    }
	    If (ItemCode="chk-HIVUnknown")&&(HiddenValue=1) {   //接触史不详    
		 	Set retval=itmjs_"(xlSheet,'☑',21,20);"
			&javascript<#(retval)#>
	    }	
		If (ItemCode="cboHIVStdHistory") { //性病史	
		    Set row=23, col=5
			Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
			Do rs.Execute(ItemDic,"1")
			While rs.Next() {
				Set DicCode=rs.Get("Code")
				Set DicDesc=rs.Get("Description")
				Set DicDesc=$s(DicCode=HiddenValue:chkY,1:chkN)_DicDesc							
				Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
				&javascript<#(retval)#>
				Set col=col+5
			}
			Do rs.Close()
		}
		
		If (ItemCode="radHIVPobSourceList") { //最可能的感染途径	
			Set row=25,col=2,count=0		
			Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
			Do rs.Execute(ItemDic,"1")
			While rs.Next() {
				Set DicCode=rs.Get("Code")
				Set DicDesc=rs.Get("Description")
				Set DicDesc=$s(DicCode=HiddenValue:chkY,1:chkN)_DicDesc
				Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
				&javascript<#(retval)#>
				Set col=col+8 
				Set count=count+1
				Set:count#4=0 row=row+1,col=2
			}
			Do rs.Close()
		}
		If (ItemCode="txtHIVPosSource") {   //最可能的感染途径其他说明    
		 	Set retval=itmjs_"(xlSheet,'"_$ZCVT(HiddenValue,"O","JS")_"',27,4);"
			&javascript<#(retval)#>
	    }
		If (ItemCode="radHIVSimSourceList") { //检测样本来源		
			Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
			Do rs.Execute(ItemDic,"1")
			Set row=30,col=2,count=0	
			While rs.Next() {
				Set DicCode=rs.Get("Code")
				Set DicDesc=rs.Get("Description")
				Set DicDesc=$s(DicCode=HiddenValue:chkY,1:chkN)_DicDesc
				Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
				&javascript<#(retval)#>
				Set col=col+8 
				Set count=count+1
				Set:count#4=0 row=row+1,col=2
			}
			Do rs.Close()
		}
	     If (ItemCode="txtHIVSimSource") {   //检测样本来源其他说明    
		 	Set retval=itmjs_"(xlSheet,'"_$ZCVT(HiddenValue,"O","JS")_"',34,28);"
			&javascript<#(retval)#>
	    }
		If (ItemCode="cboHIVTestResult") { //实验室检测结论		
			Set row=36,col=8	
			Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
			Do rs.Execute(ItemDic,"1")
			Set TestResult = ""
			While rs.Next() {
				Set DicCode=rs.Get("Code")
				Set DicDesc=rs.Get("Description")
				Set DicDesc=$s(DicCode=HiddenValue:chkY,1:chkN)_DicDesc
				Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
				&javascript<#(retval)#>
				Set col=col+$l(DicDesc)
			}
			Do rs.Close()
		}
	
		If (ItemCode="dtHIVResultDate") {   //确认(替代策略)检测阳性日期  
			If (HiddenValue["/") {	
		 		Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(HiddenValue,"/",3),"O","JS")_"',37,12);"
				&javascript<#(retval)#>
				Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(HiddenValue,"/",2),"O","JS")_"',37,15);"
				&javascript<#(retval)#>
				Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(HiddenValue,"/",1),"O","JS")_"',37,17);"
				&javascript<#(retval)#>
			}Else {
				Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(HiddenValue,"-",1),"O","JS")_"',37,12);"
				&javascript<#(retval)#>
				Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(HiddenValue,"-",2),"O","JS")_"',37,15);"
				&javascript<#(retval)#>
				Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(HiddenValue,"-",3),"O","JS")_"',37,17);"
				&javascript<#(retval)#>
				
			}
	    }
		If (ItemCode="txtHIVTestCompany") {   //确认(替代策略)检测单位    
		 	Set retval=itmjs_"(xlSheet,'"_$ZCVT(HiddenValue,"O","JS")_"',38,11);"
			&javascript<#(retval)#>
	    }
		If (ItemCode="dtHIVDigSureDate") {   //艾滋病确诊日期  
			If (HiddenValue["/") {	
		 		Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(HiddenValue,"/",3),"O","JS")_"',40,8);"
				&javascript<#(retval)#>
				Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(HiddenValue,"/",2),"O","JS")_"',40,11);"
				&javascript<#(retval)#>
				Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(HiddenValue,"/",1),"O","JS")_"',40,13);"
				&javascript<#(retval)#>
			}Else {
				Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(HiddenValue,"-",1),"O","JS")_"',40,8);"
				&javascript<#(retval)#>
				Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(HiddenValue,"-",2),"O","JS")_"',40,11);"
				&javascript<#(retval)#>
				Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(HiddenValue,"-",3),"O","JS")_"',40,13);"
				&javascript<#(retval)#>
				
			}
	    }
		If (ItemCode="txt-HIVResume") {   //备注   
		 	Set retval=itmjs_"(xlSheet,'"_$ZCVT(HiddenValue,"O","JS")_"',45,5);"
			&javascript<#(retval)#>
	    }
		
	}
	Do ds.Close()
	
	q Count
}

/// Creator：     pylian
/// CreatDate：   2018-12-08
/// Description:  打印传染病报告艾滋病性病附卡
/// Table：       DHCMed.EPD.Epidemic
/// Input：       
/// Return：      
/// w ##class(DHCMed.EPDService.EpidemicReportExport).ExportSTDEpd("fillxlSheet","16")
ClassMethod ExportSTDEpd(itmjs As %String, aRepID As %String) As %String
{
	New (itmjs,aRepID)
	Set Count=0

	Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(aRepID)
	Quit:'$IsObject(objRep) Count
	Set PatientID = objRep.MEPDPapmiDR
	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	Quit:'$IsObject(objPatient) Count
	Set Paadm = objRep.MEPDText1
	Set objPaadm=##class(DHCMed.Base.PatientAdm).GetObjById(Paadm)
	Quit:'$IsObject(objPaadm) Count 

	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.MEPDText2,"O","JS")_"',4,6);"  //卡片编号
	&javascript<#(retval)#>
	
	//基本信息
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPatient.PatientName,"O","JS")_"',6,5);"  //姓名
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.MEPDFamName,"O","JS")_"',6,16);"     //家长姓名
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPatient.Nation,"O","JS")_"',6,29);"      //民族
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.MEPDAddress,"O","JS")_"',9,5);"
	&javascript<#(retval)#>
	
	Set chkY="☑",chkN="□"  
	Set row=53, col=10	
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("EpidemicContact","1")
	While rs.Next() {
		Set DicCode=rs.Get("Code")
		Set DicDesc=rs.Get("Description")
		Set DicDesc=$s(DicCode=objRep.MEPDIntimateCode:chkY,1:chkN)_DicDesc							
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+6
	}
	Do rs.Close()
	
	Set ds=##Class(%ResultSet).%New("DHCMed.EPDService.EpidemicSubSrv:QryEpidemicSubInfo")
	Do ds.Execute(aRepID)
	While ds.Next() {
		Set ItemCode=ds.Data("ItemCode")
		Set ItemValue=ds.Data("ItemValue")
		Set ItemDic=ds.Data("ItemDic")
		Set HiddenValue=ds.Data("HiddenValue")
		 
		If (ItemCode="cboSTDMarriage") { //婚姻状况
		    set row=7, col=5			
			Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
			Do rs.Execute(ItemDic,"1")
			While rs.Next() {
				Set DicCode=rs.Get("Code")
				Set DicDesc=rs.Get("Description")
				Set DicDesc=$s(DicCode=HiddenValue:chkY,1:chkN)_DicDesc							
				Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
				&javascript<#(retval)#>
				Set col=col+5
			}
			Do rs.Close()
		}
	
		If (ItemCode="cboSTDEducation") { //文化程度		
			Set row=8, col=5	
			Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
			Do rs.Execute(ItemDic,"1")
	
			While rs.Next() {
				Set DicCode=rs.Get("Code")
				Set DicDesc=rs.Get("Description")
				Set DicDesc=$s(DicCode=HiddenValue:chkY,1:chkN)_DicDesc							
				Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
				&javascript<#(retval)#>
				Set col=col+5
			}
			Do rs.Close()
		}
		If (ItemCode="chkSTDDiaTypeList") { //疾病名称	
		    For ind=1:1:$l(ItemValue,",") {
				Set Value=$p(ItemValue,",",ind)
				If (Value="艾滋病病毒感染"){
			 		Set retval=itmjs_"(xlSheet,'☑',12,2);"
					&javascript<#(retval)#>
				}
			    If (Value="艾滋病"){
			 		Set retval=itmjs_"(xlSheet,'☑',12,10);"
					&javascript<#(retval)#>
				}
				If (Value="淋病"){
			 		Set retval=itmjs_"(xlSheet,'☑',13,24);"
					&javascript<#(retval)#>
				}
				If (Value="尖锐湿疣"){
			 		Set retval=itmjs_"(xlSheet,'☑',14,23);"
					&javascript<#(retval)#>
				}
				If (Value="生殖器疱疹"){
			 		Set retval=itmjs_"(xlSheet,'☑',14,29);"
					&javascript<#(retval)#>
				}			
		    }
		}
		If (ItemCode="radSTDSexPeriodList") {   //梅毒分期
		 	If (ItemValue["一期"){
			 	Set retval=itmjs_"(xlSheet,'☑',13,4);"
				&javascript<#(retval)#>
			}
			If (ItemValue["二期"){
		 		Set retval=itmjs_"(xlSheet,'☑',13,8);"
				&javascript<#(retval)#>
			}
			If (ItemValue["三期"){
		 		Set retval=itmjs_"(xlSheet,'☑',13,12);"
				&javascript<#(retval)#>
			}
			If (ItemValue["胎传"){
		 		Set retval=itmjs_"(xlSheet,'☑',13,16);"
				&javascript<#(retval)#>
			}
			If (ItemValue["隐性"){
		 		Set retval=itmjs_"(xlSheet,'☑',13,20);"
				&javascript<#(retval)#>
			}
	    }
	    If (ItemCode="radSTDTrachomaInfList") {   //生殖道沙眼衣原体感染    
		 	If (ItemValue="确诊病例"){
		 		Set retval=itmjs_"(xlSheet,'☑',13,9);"
				&javascript<#(retval)#>
			}
			If (ItemValue="无症状感染"){
		 		Set retval=itmjs_"(xlSheet,'☑',13,14);"
				&javascript<#(retval)#>
			}
	    }
	    If (ItemCode="dtSTDDigSureDate") {   //艾滋病确诊日期  
			If (HiddenValue["/") {	
		 		Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(HiddenValue,"/",3),"O","JS")_"',12,17);"
				&javascript<#(retval)#>
				Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(HiddenValue,"/",2),"O","JS")_"',12,20);"
				&javascript<#(retval)#>
				Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(HiddenValue,"/",1),"O","JS")_"',12,22);"
				&javascript<#(retval)#>
			}Else {
				Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(HiddenValue,"-",1),"O","JS")_"',12,17);"
				&javascript<#(retval)#>
				Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(HiddenValue,"-",2),"O","JS")_"',12,20);"
				&javascript<#(retval)#>
				Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(HiddenValue,"-",3),"O","JS")_"',12,22);"
				&javascript<#(retval)#>
				
			}
	    }
	    If (ItemCode="chk-STDDrugHistory")&&(HiddenValue=1) {   //注射毒品史    
		 	Set retval=itmjs_"(xlSheet,'☑',16,2);"
			&javascript<#(retval)#>
	    }
	    If (ItemCode="num-STDInjection") {   //共用过注射器人数    
		 	Set retval=itmjs_"(xlSheet,'"_$ZCVT(HiddenValue,"O","JS")_"',16,11);"
			&javascript<#(retval)#>
	    }
	    If (ItemCode="chk-STDUnmarHistory")&&(HiddenValue=1) {   //非婚异性性接触史   
		 	Set retval=itmjs_"(xlSheet,'☑',17,2);"
			&javascript<#(retval)#>
	    }
	    If (ItemCode="num-STDUnmarried") {   //非婚性行为人数   
		 	Set retval=itmjs_"(xlSheet,'"_$ZCVT(HiddenValue,"O","JS")_"',17,22);"
			&javascript<#(retval)#>
	    }
	    If (ItemCode="chk-STDFixedCom")&&(HiddenValue=1) {   //配偶/固定性伴阳性    
		 	Set retval=itmjs_"(xlSheet,'☑',18,2);"
			&javascript<#(retval)#>
	    }
	    If (ItemCode="chk-STDMSMHistory")&&(HiddenValue=1) {   //男男性行为史    
		 	Set retval=itmjs_"(xlSheet,'☑',19,2);"
			&javascript<#(retval)#>
	    }
	    If (ItemCode="num-STDMSM") {   //同性性行为人数    
		 	Set retval=itmjs_"(xlSheet,'"_$ZCVT(HiddenValue,"O","JS")_"',19,12);"
			&javascript<#(retval)#>
	    }
	    If (ItemCode="chk-STDBloodDona")&&(HiddenValue=1) {   //献血(浆)史    
		 	Set retval=itmjs_"(xlSheet,'☑',20,2);"
			&javascript<#(retval)#>
	    }
	    If (ItemCode="chk-STDBloodTran")&&(HiddenValue=1) {   //输血/血制品史    
		 	Set retval=itmjs_"(xlSheet,'☑',20,10);"
			&javascript<#(retval)#>
	    }
	    If (ItemCode="chk-STDMotherPose")&&(HiddenValue=1) {   //母亲阳性    
		 	Set retval=itmjs_"(xlSheet,'☑',20,20);"
			&javascript<#(retval)#>
	    }
        If (ItemCode="chk-STDBloodTran")&&(HiddenValue=1) {   //职业暴露史    
		 	Set retval=itmjs_"(xlSheet,'☑',20,28);"
			&javascript<#(retval)#>
	    }
	    If (ItemCode="chk-STDOperation")&&(HiddenValue=1) {   //手术史    
		 	Set retval=itmjs_"(xlSheet,'☑',21,2);"
			&javascript<#(retval)#>
	    }
	    If (ItemCode="chk-STDQtResume")&&(HiddenValue=1) {   //接触史其他    
		 	Set retval=itmjs_"(xlSheet,'☑',21,10);"
			&javascript<#(retval)#>
	    }
	    If (ItemCode="txt-STDQtResume") {   //其他详细说明   
		 	Set retval=itmjs_"(xlSheet,'"_$ZCVT(HiddenValue,"O","JS")_"',21,13);"
			&javascript<#(retval)#>
	    }
	    If (ItemCode="chk-STDUnknown")&&(HiddenValue=1) {   //接触史不详    
		 	Set retval=itmjs_"(xlSheet,'☑',21,20);"
			&javascript<#(retval)#>
	    }	
		If (ItemCode="cboSTDStdHistory") { //性病史	
		    Set row=23, col=5
			Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
			Do rs.Execute(ItemDic,"1")
			While rs.Next() {
				Set DicCode=rs.Get("Code")
				Set DicDesc=rs.Get("Description")
				Set DicDesc=$s(DicCode=HiddenValue:chkY,1:chkN)_DicDesc							
				Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
				&javascript<#(retval)#>
				Set col=col+5
			}
			Do rs.Close()
		}
		
		If (ItemCode="radSTDPobSourceList") { //最可能的感染途径	
			Set row=25,col=2,count=0		
			Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
			Do rs.Execute(ItemDic,"1")
			While rs.Next() {
				Set DicCode=rs.Get("Code")
				Set DicDesc=rs.Get("Description")
				Set DicDesc=$s(DicCode=HiddenValue:chkY,1:chkN)_DicDesc
				Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
				&javascript<#(retval)#>
				Set col=col+8 
				Set count=count+1
				Set:count#4=0 row=row+1,col=2
			}
			Do rs.Close()
		}
		If (ItemCode="txtSTDPosSource") {   //最可能的感染途径其他说明    
		 	Set retval=itmjs_"(xlSheet,'"_$ZCVT(HiddenValue,"O","JS")_"',27,4);"
			&javascript<#(retval)#>
	    }
		If (ItemCode="radSTDSimSourceList") { //检测样本来源		
			Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
			Do rs.Execute(ItemDic,"1")
			Set row=30,col=2,count=0	
			While rs.Next() {
				Set DicCode=rs.Get("Code")
				Set DicDesc=rs.Get("Description")
				Set DicDesc=$s(DicCode=HiddenValue:chkY,1:chkN)_DicDesc
				Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
				&javascript<#(retval)#>
				Set col=col+8 
				Set count=count+1
				Set:count#4=0 row=row+1,col=2
			}
			Do rs.Close()
		}
	     If (ItemCode="txtSTDSimSource") {   //检测样本来源其他说明    
		 	Set retval=itmjs_"(xlSheet,'"_$ZCVT(HiddenValue,"O","JS")_"',34,28);"
			&javascript<#(retval)#>
	    }
		If (ItemCode="cboSTDTestResult") { //实验室检测结论		
			Set row=36,col=8	
			Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
			Do rs.Execute(ItemDic,"1")
			Set TestResult = ""
			While rs.Next() {
				Set DicCode=rs.Get("Code")
				Set DicDesc=rs.Get("Description")
				Set DicDesc=$s(DicCode=HiddenValue:chkY,1:chkN)_DicDesc
				Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
				&javascript<#(retval)#>
				Set col=col+$l(DicDesc)
			}
			Do rs.Close()
		}
	
		If (ItemCode="dtSTDResultDate") {   //确认(替代策略)检测阳性日期  
			If (HiddenValue["/") {	
		 		Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(HiddenValue,"/",3),"O","JS")_"',37,14);"
				&javascript<#(retval)#>
				Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(HiddenValue,"/",2),"O","JS")_"',37,17);"
				&javascript<#(retval)#>
				Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(HiddenValue,"/",1),"O","JS")_"',37,19);"
				&javascript<#(retval)#>
			}Else {
				Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(HiddenValue,"-",1),"O","JS")_"',37,14);"
				&javascript<#(retval)#>
				Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(HiddenValue,"-",2),"O","JS")_"',37,17);"
				&javascript<#(retval)#>
				Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(HiddenValue,"-",3),"O","JS")_"',37,19);"
				&javascript<#(retval)#>				
			}
	    }

		If (ItemCode="txtSTDTestCompany") {   //确认(替代策略)检测单位    
		 	Set retval=itmjs_"(xlSheet,'"_$ZCVT(HiddenValue,"O","JS")_"',38,12);"
			&javascript<#(retval)#>
	    }
		If (ItemCode="radSTDLabResultList") {   //RPR/TRUST定性    	 	
		    If (HiddenValue'="") {
			    Set retval=itmjs_"(xlSheet,'☑',42,2);"
				&javascript<#(retval)#>
		    }	
		    Set row=42,col=8
			Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
			Do rs.Execute(ItemDic,"1")
			While rs.Next() {
				Set DicCode=rs.Get("Code")
				Set DicDesc=rs.Get("Description")
				Set DicDesc=$s(DicCode=HiddenValue:chkY,1:chkN)_DicDesc
				Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
				&javascript<#(retval)#>
				Set col=col+$l(DicDesc)
			}
			Do rs.Close()
	    }
	    
	    If (ItemCode="chk-STDUnDo")&&(HiddenValue=1) {   //RPR/TRUST定性滴度未做    
			Set retval=itmjs_"(xlSheet,'☑',42,20);"
			&javascript<#(retval)#>
	    }
	    If (ItemCode="num-STDDt") {   //RPR/TRUST定性滴度   
			Set retval=itmjs_"(xlSheet,'"_$ZCVT(HiddenValue,"O","JS")_"',42,24);"
			&javascript<#(retval)#>
	    }
	    If (ItemCode="radSTDTPResultList") {   //TP暗视野镜检    	 
		 	If (HiddenValue'="") {
			    Set retval=itmjs_"(xlSheet,'☑',43,2);"
				&javascript<#(retval)#>
		    }	
		    Set row=43,col=7	
			Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
			Do rs.Execute(ItemDic,"1")
			While rs.Next() {
				Set DicCode=rs.Get("Code")
				Set DicDesc=rs.Get("Description")
				Set DicDesc=$s(DicCode=HiddenValue:chkY,1:chkN)_DicDesc
				Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
				&javascript<#(retval)#>
				Set col=col+$l(DicDesc)
			}
			Do rs.Close()
	    }
	    If (ItemCode="radSTDTPHAResultList") {   //TPPA/TPHA    
		 		
		 	If (HiddenValue'="") {
			    Set retval=itmjs_"(xlSheet,'☑',43,18);"
				&javascript<#(retval)#>
		    }
		    Set row=43,col=23	
			Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
			Do rs.Execute(ItemDic,"1")
			While rs.Next() {
				Set DicCode=rs.Get("Code")
				Set DicDesc=rs.Get("Description")
				Set DicDesc=$s(DicCode=HiddenValue:chkY,1:chkN)_DicDesc
				Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
				&javascript<#(retval)#>
				Set col=col+$l(DicDesc)
			}
			Do rs.Close()
	    }
	    If (ItemCode="radSTDELISAResultList") {   //TP-ELISA     		
		 	If (HiddenValue'="") {
			    Set retval=itmjs_"(xlSheet,'☑',44,2);"
				&javascript<#(retval)#>
		    }	
		    Set row=44,col=6
			Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
			Do rs.Execute(ItemDic,"1")
			While rs.Next() {
				Set DicCode=rs.Get("Code")
				Set DicDesc=rs.Get("Description")
				Set DicDesc=$s(DicCode=HiddenValue:chkY,1:chkN)_DicDesc
				Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
				&javascript<#(retval)#>
				Set col=col+$l(DicDesc)
			}
			Do rs.Close()
	    }
	    If (ItemCode="txt-STDQtTest") {   //其它检测方法  
		 	Set retval=itmjs_"(xlSheet,'"_$ZCVT(HiddenValue,"O","JS")_"',44,21);"
			&javascript<#(retval)#>
	    }
	    If (ItemCode="radSTDQTResultList") {   //其它检测方法结果   
		 	If (HiddenValue'="") {
			    Set retval=itmjs_"(xlSheet,'☑',44,15);"
				&javascript<#(retval)#>
		    }
		    Set row=44,col=25		
			Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
			Do rs.Execute(ItemDic,"1")
			While rs.Next() {
				Set DicCode=rs.Get("Code")
				Set DicDesc=rs.Get("Description")
				Set DicDesc=$s(DicCode=HiddenValue:chkY,1:chkN)_DicDesc
				Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
				&javascript<#(retval)#>
				Set col=col+$l(DicDesc)
			}
			Do rs.Close()
	    }
	    If (ItemCode="radSTDMLabResultList") {   //患儿生母RPR/TRUST定性    	 
		 	If (HiddenValue'="") {
			    Set retval=itmjs_"(xlSheet,'☑',46,2);"
				&javascript<#(retval)#>
		    }
		    Set row=46,col=8		
			Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
			Do rs.Execute(ItemDic,"1")
			While rs.Next() {
				Set DicCode=rs.Get("Code")
				Set DicDesc=rs.Get("Description")
				Set DicDesc=$s(DicCode=HiddenValue:chkY,1:chkN)_DicDesc
				Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
				&javascript<#(retval)#>
				Set col=col+$l(DicDesc)
			}
			Do rs.Close()
	    }
	    
	    If (ItemCode="chk-STDMUnDo")&&(HiddenValue=1) {   //患儿生母RPR/TRUST定性滴度未做    
			Set retval=itmjs_"(xlSheet,'☑',46,20);"
			&javascript<#(retval)#>
	    }
	    If (ItemCode="num-STDMDt") {   //RPR/TRUST患儿生母定性滴度   
			Set retval=itmjs_"(xlSheet,'"_$ZCVT(HiddenValue,"O","JS")_"',46,24);"
			&javascript<#(retval)#>
	    }
	    If (ItemCode="radSTDMTPResultList") {   //患儿生母TP暗视野镜检    		
		 	If (HiddenValue'="") {
			    Set retval=itmjs_"(xlSheet,'☑',47,2);"
				&javascript<#(retval)#>
		    }
		    Set row=47,col=7		
			Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
			Do rs.Execute(ItemDic,"1")
			While rs.Next() {
				Set DicCode=rs.Get("Code")
				Set DicDesc=rs.Get("Description")
				Set DicDesc=$s(DicCode=HiddenValue:chkY,1:chkN)_DicDesc
				Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
				&javascript<#(retval)#>
				Set col=col+$l(DicDesc)
			}
			Do rs.Close()
	    }
	    If (ItemCode="radSTDMTPHAResultList") {   //患儿生母TPPA/TPHA    
		 	If (HiddenValue'="") {
			    Set retval=itmjs_"(xlSheet,'☑',47,18);"
				&javascript<#(retval)#>
		    }
		    Set row=47,col=23		
			Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
			Do rs.Execute(ItemDic,"1")
			While rs.Next() {
				Set DicCode=rs.Get("Code")
				Set DicDesc=rs.Get("Description")
				Set DicDesc=$s(DicCode=HiddenValue:chkY,1:chkN)_DicDesc
				Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
				&javascript<#(retval)#>
				Set col=col+$l(DicDesc)
			}
			Do rs.Close()
	    }
	    If (ItemCode="radSTDMELISAResultList") {   //患儿生母TP-ELISA    
		 	If (HiddenValue'="") {
			    Set retval=itmjs_"(xlSheet,'☑',48,2);"
				&javascript<#(retval)#>
		    }	
		    Set row=48,col=6	
			Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
			Do rs.Execute(ItemDic,"1")
			While rs.Next() {
				Set DicCode=rs.Get("Code")
				Set DicDesc=rs.Get("Description")
				Set DicDesc=$s(DicCode=HiddenValue:chkY,1:chkN)_DicDesc
				Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
				&javascript<#(retval)#>
				Set col=col+$l(DicDesc)
			}
			Do rs.Close()
	    }
	    If (ItemCode="txt-STDMQtTest") {   //患儿生母其它检测方法  
		 	Set retval=itmjs_"(xlSheet,'"_$ZCVT(HiddenValue,"O","JS")_"',48,21);"
			&javascript<#(retval)#>
	    }
	    If (ItemCode="radSTDMQTResultList") {   //患儿生母其它检测方法结果   
		 	If (HiddenValue'="") {
			    Set retval=itmjs_"(xlSheet,'☑',48,15);"
				&javascript<#(retval)#>
		    }
		    Set row=48,col=25		
			Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
			Do rs.Execute(ItemDic,"1")
			While rs.Next() {
				Set DicCode=rs.Get("Code")
				Set DicDesc=rs.Get("Description")
				Set DicDesc=$s(DicCode=HiddenValue:chkY,1:chkN)_DicDesc
				Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
				&javascript<#(retval)#>
				Set col=col+$l(DicDesc)
			}
			Do rs.Close()
	    }
	    If (ItemCode="radSTDHaveList") {   //梅毒临床表现   
		 	Set row=50,col=2	
			Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
			Do rs.Execute(ItemDic,"1")
			While rs.Next() {
				Set DicCode=rs.Get("Code")
				Set DicDesc=rs.Get("Description")
				Set DicDesc=$s(DicCode=HiddenValue:chkY,1:chkN)_DicDesc
				Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
				&javascript<#(retval)#>
				Set col=col+2
			}
			Do rs.Close()
	    }
	    If (ItemCode="chkSTDSymbolList") {   //梅毒临床表现症状   
		 	Set row=50,col=7	
			Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
			Do rs.Execute(ItemDic,"1")
			While rs.Next() {
				Set DicCode=rs.Get("Code")
				Set DicDesc=rs.Get("Description")
				Set CheckFlg=0
				For ind=1:1:$l(HiddenValue,",") {
					Set Value=$p(HiddenValue,",",ind)
					Continue:Value=""
					Set:Value=DicCode CheckFlg=1
				}
				Set DicDesc=$s(CheckFlg:chkY,1:chkN)_DicDesc
				Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
				&javascript<#(retval)#>
				Set col=col+6 
				Set count=count+1
				Set:count#4=0 row=row+1,col=7
			}
			Do rs.Close()
	    }
	    If (ItemCode="txt-STDQtSymbol") {   //梅毒临床表现其他症状   
		 	Set retval=itmjs_"(xlSheet,'"_$ZCVT(HiddenValue,"O","JS")_"',51,27);"
			&javascript<#(retval)#>
	    }
		If (ItemCode="txt-STDResume") {   //备注   
		 	Set retval=itmjs_"(xlSheet,'"_$ZCVT(HiddenValue,"O","JS")_"',54,4);"
			&javascript<#(retval)#>
	    }
		
	}
	Do ds.Close()
	
	q Count
}

/// Creator：     pylian
/// CreatDate：   2018-12-28
/// Description:  打印传染病报告乙肝附卡
/// Table：       DHCMed.EPD.Epidemic
/// Input：       
/// Return：      
/// w ##class(DHCMed.EPDService.EpidemicReportExport).ExportHBVEpd("fillxlSheet","17")
ClassMethod ExportHBVEpd(itmjs As %String, aRepID As %String) As %String
{
	New (itmjs,aRepID)
	Set Count=0
	
	Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(aRepID)
	Quit:'$IsObject(objRep) Count
	Set PatientID = objRep.MEPDPapmiDR
	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	Quit:'$IsObject(objPatient) Count
	Set Paadm = objRep.MEPDText1
	
	//基本信息
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPatient.PatientName,"O","JS")_"',2,4);"  //姓名
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPatient.Sex,"O","JS")_"',2,10);"  //性别
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objPatient.Birthday,"O","JS")_"',2,16);"  //生日
	&javascript<#(retval)#>
	Set chkY="☑",chkN="□"  
	Set row=9, col=8	
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("EpidemicContact","1")
	While rs.Next() {
		Set DicCode=rs.Get("Code")
		Set DicDesc=rs.Get("Description")
		Set DicDesc=$s(DicCode=objRep.MEPDIntimateCode:chkY,1:chkN)_DicDesc							
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+5
	}
	Do rs.Close()
	Set ds=##Class(%ResultSet).%New("DHCMed.EPDService.EpidemicSubSrv:QryEpidemicSubInfo")
	Do ds.Execute(aRepID)
	While ds.Next() {
		Set ItemCode=ds.Data("ItemCode")
		Set ItemValue=ds.Data("ItemValue")
		Set ItemDic=ds.Data("ItemDic")
		Set HiddenValue=ds.Data("HiddenValue")
		
		If (ItemCode="cboHBVHBsAgPositive") { //HBsAg阳性时间
			Set row=3,col=6	
			Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
			Do rs.Execute(ItemDic,"1")
			While rs.Next() {
				Set DicCode=rs.Get("Code")
				Set DicDesc=rs.Get("Description")
				Set DicDesc=$s(DicCode=HiddenValue:chkY,1:chkN)_DicDesc
				Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
				&javascript<#(retval)#>
				Set col=col+3
			}
			Do rs.Close()
		}
		If (ItemCode="dtHBVSymbolDate") { //首次出现乙肝症状和体征的时间
			If (HiddenValue["/") {	
		 		Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(HiddenValue,"/",3),"O","JS")_"',4,9);"
				&javascript<#(retval)#>
				Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(HiddenValue,"/",2),"O","JS")_"',4,12);"
				&javascript<#(retval)#>
			}Else {
				Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(HiddenValue,"-",1),"O","JS")_"',4,9);"
				&javascript<#(retval)#>	
				Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(HiddenValue,"-",2),"O","JS")_"',4,12);"
				&javascript<#(retval)#>
			}
		}
		If (ItemCode="chk-HBVSymbol")&&(HiddenValue=1) { //无症状
			Set retval=itmjs_"(xlSheet,'☑',4,14);"
			&javascript<#(retval)#>		
		}
		If (ItemCode="chk-HBVUnknown")&&(HiddenValue=1) { //不详
			Set retval=itmjs_"(xlSheet,'☑',4,18);"
			&javascript<#(retval)#>		
		}
	
		If (ItemCode="txtHBVALT") { //本次ALT
			Set retval=itmjs_"(xlSheet,'"_$ZCVT(HiddenValue,"O","JS")_"',5,5);"
			&javascript<#(retval)#>		
		}
	
		If (ItemCode="radHBVDiluteList") { //抗-HBc  IgM 1:1000稀释检测结果
			Set row=6,col=6	
			Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
			Do rs.Execute(ItemDic,"1")
			While rs.Next() {
				Set DicCode=rs.Get("Code")
				Set DicDesc=rs.Get("Description")
				Set DicDesc=$s(DicCode=HiddenValue:chkY,1:chkN)_DicDesc
				Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
				&javascript<#(retval)#>
				Set col=col+$l(DicDesc)
			}
			Do rs.Close()
		}
		If (ItemCode="cboHBVLiverResult") { //肝组织穿刺检测结果
			Set row=7,col=7	
			Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
			Do rs.Execute(ItemDic,"1")
			While rs.Next() {
				Set DicCode=rs.Get("Code")
				Set DicDesc=rs.Get("Description")
				Set DicDesc=$s(DicCode=HiddenValue:chkY,1:chkN)_DicDesc
				Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
				&javascript<#(retval)#>
				Set col=col+$l(DicDesc)
			}
			Do rs.Close()
		}
		If (ItemCode="radHBVSerumList") { //恢复期血清HBsAg阴转,抗HBs阳转
			Set row=8,col=10	
			Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
			Do rs.Execute(ItemDic,"1")
			While rs.Next() {
				Set DicCode=rs.Get("Code")
				Set DicDesc=rs.Get("Description")
				Set DicDesc=$s(DicCode=HiddenValue:chkY,1:chkN)_DicDesc
				Set retval=itmjs_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
				&javascript<#(retval)#>
				Set col=col+$l(DicDesc)
			}
			Do rs.Close()
		}
	}
	Do ds.Close()
	q Count
}

}
