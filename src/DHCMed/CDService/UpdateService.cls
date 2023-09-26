/// 名称: DHCMed.CDService.UpdateService
/// 描述: 慢病报卡信息保存服务
/// 编写者：jiangpengpeng
/// 编写日期: 2015-08-27
Class DHCMed.CDService.UpdateService Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2015-08-27
/// Description:  保存主卡信息
/// Table：       DHCMed.CD.CRReport等
/// Input：       ParRefInfo:父表信息,ChildInfo:子表信息,PatInfo:患者信息
/// Return：      返回String
/// w ##class(DHCMed.CDService.UpdateService).SaveParRefData()
ClassMethod SaveRepData(ParRefInfo As %String, ChildInfo As %String, PatInfo As %String, ExtraInfo As %String = "") As %String
{
	New (ParRefInfo,ChildInfo,PatInfo,ExtraInfo)
	Set return="0^数据不全"
	Quit:(ParRefInfo="")||(ChildInfo="")||(PatInfo="") return
	
	Set return="-1^报卡类型不对"
	Set ReportType=$p(ParRefInfo,"^",3)   //ZLK,XNXG,FZYCO,SHK,TNB
	If (ReportType="ZLK") {
		Set return=..SaveRepDataZLK(ParRefInfo,ChildInfo,PatInfo)
	} ElseIf (ReportType="XNXG") {
		Set return=..SaveRepDataXNXG(ParRefInfo,ChildInfo,PatInfo)
	} ElseIf (ReportType="SHK") {
		Set return=..SaveRepDataSHK(ParRefInfo,ChildInfo,PatInfo,ExtraInfo)
	} ElseIf (ReportType="NYZD") {
		Set return=..SaveRepDataNYZD(ParRefInfo,ChildInfo,PatInfo,ExtraInfo)
	} ElseIf (ReportType="GWZS") {
		Set return=..SaveRepDataGWZS(ParRefInfo,ChildInfo,PatInfo)
	} ElseIf (ReportType="FZYCO") {
		Set return=..SaveRepDataFZYCO(ParRefInfo,ChildInfo,PatInfo,ExtraInfo)
	} ElseIf (ReportType="YSZYB") {
		Set return=..SaveRepDataYSZYB(ParRefInfo,ChildInfo,PatInfo)
	} ElseIf (ReportType="TNB") {
		Set return=..SaveRepDataTNB(ParRefInfo,ChildInfo,PatInfo)
	} ElseIf (ReportType="GXY") {
		Set return=..SaveRepDataGXY(ParRefInfo,ChildInfo,PatInfo)
	} ElseIf (ReportType="MBBK") {
		Set return=..SaveRepDataMBBK(ParRefInfo,ChildInfo,PatInfo)
	} ElseIf (ReportType="CSQX") {
		Set return=..SaveRepDataCSQX(ParRefInfo,ChildInfo,PatInfo)
	}ElseIf (ReportType="ETSH") {
		Set return=..SaveRepDataETSH(ParRefInfo,ChildInfo,PatInfo)
	}Else {
	}
	
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-08-27
/// Description:  保存主卡信息
/// Table：       DHCMed.CD.CRReport等
/// Input：       ParRefInfo:父表信息,ChildInfo:子表信息,PatInfo:患者信息
/// Return：      返回String
/// w ##class(DHCMed.CDService.UpdateService).SaveRepDataZLK("^^ZLK^1^6^med^地坛医院^2015-08-28^9^117","^10001^8604^^D48.900^8737^qwe^123^2015-08-28^^2015-07-28^8630^2015-07-27^I51.900^^病史摘要^8619,8623,8624^发作","2")
ClassMethod SaveRepDataZLK(ParRefInfo As %String, ChildInfo As %String, PatInfo As %String) As %String
{
	New (ParRefInfo,ChildInfo,PatInfo)
	Set return="-2.1^主卡信息保存错误"
	
	TStart
	
	Set InputStr=$p(ParRefInfo,"^",1)				//RepID
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",2)	//CREpisodeID
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",3)	//CRRepTypeCode
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",4)	//CRReportStatus
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",5)	//CRReportLoc
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",6)	//CRReportUser
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",7)	//CRReportOrgan
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",8)	//CRReportDate
	Set InputStr=InputStr_"^"_""					//CRReportTime
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",9)	//CRUpdateUser(UserID)
	Set InputStr=InputStr_"^"_""					//CRUpdateDate
	Set InputStr=InputStr_"^"_""					//CRUpdateTime
	Set InputStr=InputStr_"^"_""					//CRCheckFlag
	Set InputStr=InputStr_"^"_""					//CRCheckUser
	Set InputStr=InputStr_"^"_""					//CRCheckDate
	Set InputStr=InputStr_"^"_""					//CRCheckTime
	Set InputStr=InputStr_"^"_""					//CRExportFlag
	Set InputStr=InputStr_"^"_""					//CRExportUser
	Set InputStr=InputStr_"^"_""					//CRExportDate
	Set InputStr=InputStr_"^"_""					//CRExportTime
	Set InputStr=InputStr_"^"_""					//CRResume
 	Set ret=##class(DHCMed.CD.CRReport).Update(InputStr,"^")
 	If (+ret)<1 {
		TRollback
		Quit return
	}
	Set return="-2.2^子卡信息保存错误"
	Set RepID=ret
	Set InputStrZLK=RepID
	Set InputStrZLK=InputStrZLK_"^"_$p(ChildInfo,"^",2)		//CRKPBH
	Set InputStrZLK=InputStrZLK_"^"_$p(ChildInfo,"^",3)		//CRBQYGZBR
	Set InputStrZLK=InputStrZLK_"^"_$p(ChildInfo,"^",4)		//CRZD
	Set InputStrZLK=InputStrZLK_"^"_$p(ChildInfo,"^",5)		//CRZDICD
	Set InputStrZLK=InputStrZLK_"^"_$p(ChildInfo,"^",6)		//CRZDBW
	Set InputStrZLK=InputStrZLK_"^"_""						//CRYFBW
	Set InputStrZLK=InputStrZLK_"^"_$p(ChildInfo,"^",7)		//CRBLXLX
	Set InputStrZLK=InputStrZLK_"^"_$p(ChildInfo,"^",8)		//CRBLH
	Set InputStrZLK=InputStrZLK_"^"_""						//CRSWXXW
	Set InputStrZLK=InputStrZLK_"^"_$p(ChildInfo,"^",22)	//CRFHCD
	Set InputStrZLK=InputStrZLK_"^"_$p(ChildInfo,"^",19)	//CRTNMFQT
	Set InputStrZLK=InputStrZLK_"^"_$p(ChildInfo,"^",20)	//CRTNMFQN
	Set InputStrZLK=InputStrZLK_"^"_$p(ChildInfo,"^",21)	//CRTNMFQM
	Set InputStrZLK=InputStrZLK_"^"_$p(ChildInfo,"^",9)		//CRZDRQ
	Set InputStrZLK=InputStrZLK_"^"_""						//CRSCZDRQ
	Set InputStrZLK=InputStrZLK_"^"_$p(ChildInfo,"^",17)	//CRZDYJ
	Set InputStrZLK=InputStrZLK_"^"_""						//CRZGZDYJ
	Set InputStrZLK=InputStrZLK_"^"_$p(ChildInfo,"^",12)	//CRZGZDDW
	Set InputStrZLK=InputStrZLK_"^"_""						//CRSS
	Set InputStrZLK=InputStrZLK_"^"_""						//CRSSICD
	Set InputStrZLK=InputStrZLK_"^"_""						//CRXTX
	Set InputStrZLK=InputStrZLK_"^"_""						//CRXTXICD
	Set InputStrZLK=InputStrZLK_"^"_$p(ChildInfo,"^",10)	//CRYZD
	Set InputStrZLK=InputStrZLK_"^"_""						//CRYZDICD
	Set InputStrZLK=InputStrZLK_"^"_$p(ChildInfo,"^",11)	//CRYZDRQ
	Set InputStrZLK=InputStrZLK_"^"_$p(ChildInfo,"^",13)	//CRSWRQ
	Set InputStrZLK=InputStrZLK_"^"_$p(ChildInfo,"^",15)	//CRSWYY
	Set InputStrZLK=InputStrZLK_"^"_$p(ChildInfo,"^",18)	//CRJTSWYY
	Set InputStrZLK=InputStrZLK_"^"_$p(ChildInfo,"^",14)	//CRSYICD
	Set InputStrZLK=InputStrZLK_"^"_$p(ChildInfo,"^",16)	//CRBSZY
	Set InputStrZLK=InputStrZLK_"^"_$p(ChildInfo,"^",23)	//CRSWZD
	//add 2019-02-21
	Set InputStrZLK=InputStrZLK_"^"_$p(ChildInfo,"^",24)	//CRZDBWDr
	Set InputStrZLK=InputStrZLK_"^"_$p(ChildInfo,"^",25)	//CRBLXLXDr
	//add 2020-02-25
	Set InputStrZLK=InputStrZLK_"^"_$p(ChildInfo,"^",26)	//CRJPXBMDr
	
	Set InputStrZLK=InputStrZLK_"^"_$p(ChildInfo,"^",27)	//  add  by chenr 2021-12-08
	Set InputStrZLK=InputStrZLK_"^"_$p(ChildInfo,"^",28)	
	Set InputStrZLK=InputStrZLK_"^"_$p(ChildInfo,"^",29)	
	Set InputStrZLK=InputStrZLK_"^"_$p(ChildInfo,"^",30)	
	Set InputStrZLK=InputStrZLK_"^"_$p(ChildInfo,"^",31)	
	Set InputStrZLK=InputStrZLK_"^"_$p(ChildInfo,"^",32)	
	Set InputStrZLK=InputStrZLK_"^"_$p(ChildInfo,"^",33)	
	Set InputStrZLK=InputStrZLK_"^"_$p(ChildInfo,"^",34)	
	Set InputStrZLK=InputStrZLK_"^"_$p(ChildInfo,"^",35)	
	Set InputStrZLK=InputStrZLK_"^"_$p(ChildInfo,"^",36)	
	Set InputStrZLK=InputStrZLK_"^"_$p(ChildInfo,"^",37)	
	Set InputStrZLK=InputStrZLK_"^"_$p(ChildInfo,"^",38)	
	
	
	Set retzlk=##class(DHCMed.CD.CRReportZLK).Update(InputStrZLK,"^")
	//Quit:retzlk<1 return
	If (+retzlk)<1 {
		TRollback
		Quit return
	}
	Set return="-2.3^患者基本信息保存错误"
	Set InputStrPAT=RepID
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",2)	//CRPatientID
	Set InputStrPAT=InputStrPAT_"^"_""					//CRMZH
	Set InputStrPAT=InputStrPAT_"^"_""					//CRZYH
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",3)	//CRDJH
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",4)	//CRXM
	Set InputStrPAT=InputStrPAT_"^"_""					//CRJZXM
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",6)	//CRXB
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",9)	//CRCSRQ
	
	Set (AgeS,AgeY,AgeT)=""
	Set Age=$p(PatInfo,"^",7)
	Set AgeDW=$p(PatInfo,"^",8)
	
	//If ($IsObject(objAge)) {
		If (AgeDW="岁"){
			Set AgeS=Age
			Set AgeY=""
			Set AgeT=""
		} ElseIf (AgeDW="月") {
			Set AgeY=Age
			Set AgeS=""
			Set AgeT=""
			
		} Else {
			Set AgeT=Age
			Set AgeY=""
			Set AgeS=""
		}
	//}
	Set InputStrPAT=InputStrPAT_"^"_AgeS	//CRNLS
	Set InputStrPAT=InputStrPAT_"^"_AgeY	//CRNLY
	Set InputStrPAT=InputStrPAT_"^"_AgeT	//CRNLT
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",5)	//CRSFZH
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",13)	//CRJTDH
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",11)	//CRMZ
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",28)	//CRHYZK
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",27)  //CRWHCD
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",10)	//CRZY
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",12)	//CRGZ
	Set InputStrPAT=InputStrPAT_"^"_""					//CRLXR
	Set InputStrPAT=InputStrPAT_"^"_""					//CRYBRGX
	Set InputStrPAT=InputStrPAT_"^"_""					//CRLXDH
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",14)	//CRGZDW
	Set InputStrPAT=InputStrPAT_"^"_""					//CRHJ
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",21)	//CRHJDZS
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",22)	//CRHJDZS2
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",23)	//CRHJDZX
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",24)	//CRHJDZX2
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",25)	//CRHJDZC
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",26)	//CRHJDZXX
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",15)	//CRCZDZS
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",16)	//CRCZDZS2
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",17)	//CRCZDZX
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",18)	//CRCZDZX2
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",19)	//CRCZDZC
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",20)	//CRCZDZXX
	Set retpat=##class(DHCMed.CD.CRReportPAT).Update(InputStrPAT,"^")
	//Quit:retpat<1 return
	If (+retpat)<1 {
		TRollback
		Quit return
	}
	Set return="-2.4^日志信息保存错误"
	Set InputStrLOG=RepID
	Set InputStrLOG=InputStrLOG_"^"_$p(ParRefInfo,"^",4)
	Set InputStrLOG=InputStrLOG_"^"_$p(ParRefInfo,"^",10)
	Set InputStrLOG=InputStrLOG_"^"_$p(ParRefInfo,"^",9)
	Set InputStrLOG=InputStrLOG_"^"_+$H
	Set InputStrLOG=InputStrLOG_"^"_$p($H,",",2)
	Set InputStrLOG=InputStrLOG_"^"_"UPDATE"
	Set retlog=##class(DHCMed.CD.CRReportLOG).Update(InputStrLOG,"^")
	//Quit:retlog<1 return
	If (+retlog)<1 {
		TRollback
		Quit return
	}
	TCommit
	Set return=RepID	//RepID
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-09-06
/// Description:  保存主卡信息
/// Table：       DHCMed.CD.CRReport等
/// Input：       ParRefInfo:父表信息,ChildInfo:子表信息,PatInfo:患者信息
/// Return：      返回String
/// w ##class(DHCMed.CDService.UpdateService).SaveRepDataXNXG("","","")
ClassMethod SaveRepDataXNXG(ParRefInfo As %String, ChildInfo As %String, PatInfo As %String) As %String
{
	New (ParRefInfo,ChildInfo,PatInfo)
	Set return="-2.1^主卡信息保存错误"
	
	TStart 
	
	Set ret=##class(DHCMed.CD.CRReport).Update(ParRefInfo,"^")
	//Quit:ret<1 return
	If (+ret)<1 {
		TRollback
		Quit return
	}
	Set return="-2.2^子卡信息保存错误"
	Set RepID=ret
	Set $p(ChildInfo,"^",1)=RepID
	Set retXNXG=##class(DHCMed.CD.CRReportXNXG).Update(ChildInfo,"^")
	//Quit:retXNXG<1 return
	If (+retXNXG)<1 {
		TRollback
		Quit return
	}
	Set return="-2.3^患者基本信息保存错误"
	Set $p(PatInfo,"^",1)=RepID
	Set retpat=##class(DHCMed.CD.CRReportPAT).Update(PatInfo,"^")
	//Quit:retpat<1 return
	If (+retpat)<1 {
		TRollback
		Quit return
	}
	Set return="-2.4^日志信息保存错误"
	Set InputStrLOG=RepID
	Set InputStrLOG=InputStrLOG_"^"_"1"
	Set InputStrLOG=InputStrLOG_"^"_$p(ParRefInfo,"^",22)
	Set InputStrLOG=InputStrLOG_"^"_$p(ParRefInfo,"^",10)
	Set InputStrLOG=InputStrLOG_"^"_+$H
	Set InputStrLOG=InputStrLOG_"^"_$p($H,",",2)
	Set InputStrLOG=InputStrLOG_"^"_"UPDATE"
	Set retlog=##class(DHCMed.CD.CRReportLOG).Update(InputStrLOG,"^")
	//Quit:retlog<1 return
	If (+retlog)<1 {
		TRollback
		Quit return
	}
	
	Tcommit
	
	Set return=RepID	//RepID
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-09-15
/// Description:  保存主卡信息
/// Table：       DHCMed.CD.CRReport等
/// Input：       ParRefInfo:父表信息,ChildInfo:子表信息,PatInfo:患者信息,ExtraInfo:其他信息
/// Return：      返回String
/// w ##class(DHCMed.CDService.UpdateService).SaveRepDataSHK("","","","")
ClassMethod SaveRepDataSHK(ParRefInfo As %String, ChildInfo As %String, PatInfo As %String, ExtraInfo As %String) As %String
{
	New (ParRefInfo,ChildInfo,PatInfo,ExtraInfo)
	Set return="-2.1^主卡信息保存错误"
	TStart
	Set InputStr=$p(ParRefInfo,"^",1)				//RepID
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",2)	//CREpisodeID
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",3)	//CRRepTypeCode
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",4)	//CRReportStatus
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",5)	//CRReportLoc
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",6)	//CRReportUser
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",7)	//CRReportOrgan
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",8)	//CRReportDate
	Set InputStr=InputStr_"^"_""					//CRReportTime
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",9)	//CRUpdateUser(UserID)
	Set InputStr=InputStr_"^"_""					//CRUpdateDate
	Set InputStr=InputStr_"^"_""					//CRUpdateTime
	Set InputStr=InputStr_"^"_""					//CRCheckFlag
	Set InputStr=InputStr_"^"_""					//CRCheckUser
	Set InputStr=InputStr_"^"_""					//CRCheckDate
	Set InputStr=InputStr_"^"_""					//CRCheckTime
	Set InputStr=InputStr_"^"_""					//CRExportFlag
	Set InputStr=InputStr_"^"_""					//CRExportUser
	Set InputStr=InputStr_"^"_""					//CRExportDate
	Set InputStr=InputStr_"^"_""					//CRExportTime
	Set InputStr=InputStr_"^"_""					//CRResume
 	Set ret=##class(DHCMed.CD.CRReport).Update(InputStr,"^")
	//Quit:ret<1 return
	If (+ret)<1 {
		TRollback
		Quit return
	}
	Set return="-2.2^子卡信息保存错误"
	Set RepID=ret
	Set InputStrSHK=RepID
	Set InputStrSHK=InputStrSHK_"^"_$p(ChildInfo,"^",2)		//CRYYBH
	Set InputStrSHK=InputStrSHK_"^"_$p(ChildInfo,"^",3)		//CRCPBH
	Set InputStrSHK=InputStrSHK_"^"_$p(ChildInfo,"^",4)		//CRSHFSRQ
	Set InputStrSHK=InputStrSHK_"^"_$p(ChildInfo,"^",5)		//CRSHFSSJ
	Set InputStrSHK=InputStrSHK_"^"_$p(ChildInfo,"^",6)		//CRHZJZRQ
	Set InputStrSHK=InputStrSHK_"^"_$p(ChildInfo,"^",7)		//CRHZJZSJ
	Set InputStrSHK=InputStrSHK_"^"_$p(ChildInfo,"^",8)		//CRSHFSYY
	Set InputStrSHK=InputStrSHK_"^"_$p(ChildInfo,"^",9)		//CRSHFSDD
	Set InputStrSHK=InputStrSHK_"^"_$p(ChildInfo,"^",10)		//CRSHFSSHD
	Set InputStrSHK=InputStrSHK_"^"_$p(ChildInfo,"^",11)		//CRSHSFGY
	Set InputStrSHK=InputStrSHK_"^"_$p(ChildInfo,"^",12)		//CRSHXZ
	Set InputStrSHK=InputStrSHK_"^"_$p(ChildInfo,"^",13)		//CRSHBW
	Set InputStrSHK=InputStrSHK_"^"_$p(ChildInfo,"^",14)		//CRSHYZCD
	Set InputStrSHK=InputStrSHK_"^"_$p(ChildInfo,"^",15)		//CRSHZD
	Set InputStrSHK=InputStrSHK_"^"_$p(ChildInfo,"^",16)		//CRSHJJ
	Set InputStrSHK=InputStrSHK_"^"_$p(ChildInfo,"^",17)		//CRCPMC1
	Set InputStrSHK=InputStrSHK_"^"_$p(ChildInfo,"^",18)		//CRCPXH1
	Set InputStrSHK=InputStrSHK_"^"_$p(ChildInfo,"^",19)		//CRCPFL1
	Set InputStrSHK=InputStrSHK_"^"_$p(ChildInfo,"^",20)		//CRCPMC2
	Set InputStrSHK=InputStrSHK_"^"_$p(ChildInfo,"^",21)		//CRCPXH2
	Set InputStrSHK=InputStrSHK_"^"_$p(ChildInfo,"^",22)		//CRCPFL2
	Set InputStrSHK=InputStrSHK_"^"_$p(ChildInfo,"^",23)		//CRDXAL
	Set retshk=##class(DHCMed.CD.CRReportSHK).Update(InputStrSHK,"^")
	//Quit:retshk<1 return
	If (+retshk)<1 {
		TRollback
		Quit return
	}
	Set return="-2.3^患者基本信息保存错误"
	Set InputStrPAT=RepID
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",2)	//CRPatientID
	Set InputStrPAT=InputStrPAT_"^"_""					//CRMZH
	Set InputStrPAT=InputStrPAT_"^"_""					//CRZYH
	Set InputStrPAT=InputStrPAT_"^"_""					//CRDJH
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",3)	//CRXM
	Set InputStrPAT=InputStrPAT_"^"_""					//CRJZXM
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",5)	//CRXB
	Set InputStrPAT=InputStrPAT_"^"_""	//CRCSRQ
	
	Set (AgeS,AgeY,AgeT)=""
	Set Age=$p(PatInfo,"^",6)
	Set AgeDW=$p(PatInfo,"^",7)
	/*Set objAge=##class(DHCMed.SS.Dictionary).GetObjById(AgeDW)
	If ($IsObject(objAge)) {
		If (objAge.Description="岁"){
			Set AgeS=Age
		} ElseIf (objAge.Description="月") {
			Set AgeY=Age
		} Else {
			Set AgeT=Age
		}
	}*/
	If (AgeDW="岁"){
		Set AgeS=Age
	} ElseIf (AgeDW="月") {
		Set AgeY=Age
	} Else {
		Set AgeT=Age
	}
	Set InputStrPAT=InputStrPAT_"^"_AgeS	//CRNLS
	Set InputStrPAT=InputStrPAT_"^"_AgeY	//CRNLY
	Set InputStrPAT=InputStrPAT_"^"_AgeT	//CRNLT
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",4)	//CRSFZH
	Set InputStrPAT=InputStrPAT_"^"_""	//CRJTDH
	Set InputStrPAT=InputStrPAT_"^"_""	//CRMZ
	Set InputStrPAT=InputStrPAT_"^"_""					//CRHYZK
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",10)  //CRWHCD
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",11)	//CRZY
	Set InputStrPAT=InputStrPAT_"^"_""	//CRGZ
	Set InputStrPAT=InputStrPAT_"^"_""					//CRLXR
	Set InputStrPAT=InputStrPAT_"^"_""					//CRYBRGX
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",8)	//CRLXDH
	Set InputStrPAT=InputStrPAT_"^"_""	//CRGZDW
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",9)	//CRHJ
	Set InputStrPAT=InputStrPAT_"^"_""	//CRHJDZS
	Set InputStrPAT=InputStrPAT_"^"_""	//CRHJDZS2
	Set InputStrPAT=InputStrPAT_"^"_""	//CRHJDZX
	Set InputStrPAT=InputStrPAT_"^"_""	//CRHJDZX2
	Set InputStrPAT=InputStrPAT_"^"_""	//CRHJDZC
	Set InputStrPAT=InputStrPAT_"^"_""	//CRHJDZXX
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",12)	//CRCZDZS
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",13) 	//CRCZDZS2
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",14) 	//CRCZDZX
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",15) 	//CRCZDZX2
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",16) 	//CRCZDZC
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",17) 	//CRCZDZXX
	Set retpat=##class(DHCMed.CD.CRReportPAT).Update(InputStrPAT,"^")
	//Quit:retpat<1 return
	If (+retpat)<1 {
		TRollback
		Quit return
	}
	Set return="-2.4^日志信息保存错误"
	Set InputStrLOG=RepID
	Set InputStrLOG=InputStrLOG_"^"_$p(ParRefInfo,"^",4)
	Set InputStrLOG=InputStrLOG_"^"_$p(ParRefInfo,"^",10)
	Set InputStrLOG=InputStrLOG_"^"_$p(ParRefInfo,"^",9)
	Set InputStrLOG=InputStrLOG_"^"_+$H
	Set InputStrLOG=InputStrLOG_"^"_$p($H,",",2)
	Set InputStrLOG=InputStrLOG_"^"_"UPDATE"
	Set retlog=##class(DHCMed.CD.CRReportLOG).Update(InputStrLOG,"^")
	//Quit:retlog<1 return
	If (+retlog)<1 {
		TRollback
		Quit return
	}
	Set return="-2.5^其他信息保存错误"
	Set InputStrExt=RepID
	Set ExtLen=$l(ExtraInfo,"^")
	For ind=1:1:ExtLen {
		Set UpKey=1
		Set Extinfo=$p(ExtraInfo,"^",ind)
		Set InputStrExt=RepID
		Set InputStrExt=InputStrExt_"^"_$p(Extinfo,$c(1),1)
		Set InputStrExt=InputStrExt_"^"_$p(Extinfo,$c(1),2)
		Set InputStrExt=InputStrExt_"^"_$p(Extinfo,$c(1),3)
		Set retext=##class(DHCMed.CD.CRReportBZQT).Update(InputStrExt,"^")
		Set:retext<1 UpKey=0
		Quit:retext<1 
	}
	//Quit:UpKey=0 return
	If (UpKey=0) {
		TRollback
		Quit return
	}
	TCommit
	Set return=RepID	//RepID
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-09-15
/// Description:  保存主卡信息
/// Table：       DHCMed.CD.CRReport等
/// Input：       ParRefInfo:父表信息,ChildInfo:子表信息,PatInfo:患者信息,ExtraInfo:其他信息
/// Return：      返回String
/// w ##class(DHCMed.CDService.UpdateService).SaveRepDataNYZD("","","","")
ClassMethod SaveRepDataNYZD(ParRefInfo As %String, ChildInfo As %String, PatInfo As %String, ExtraInfo As %String) As %String
{
	New (ParRefInfo,ChildInfo,PatInfo,ExtraInfo)
	Set return="-2.1^主卡信息保存错误"
	TStart
	Set InputStr=$p(ParRefInfo,"^",1)				//RepID
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",2)	//CREpisodeID
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",3)	//CRRepTypeCode
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",4)	//CRReportStatus
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",5)	//CRReportLoc
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",6)	//CRReportUser
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",7)	//CRReportOrgan
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",8)	//CRReportDate
	Set InputStr=InputStr_"^"_""					//CRReportTime
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",9)	//CRUpdateUser(UserID)
	Set InputStr=InputStr_"^"_""					//CRUpdateDate
	Set InputStr=InputStr_"^"_""					//CRUpdateTime
	Set InputStr=InputStr_"^"_""					//CRCheckFlag
	Set InputStr=InputStr_"^"_""					//CRCheckUser
	Set InputStr=InputStr_"^"_""					//CRCheckDate
	Set InputStr=InputStr_"^"_""					//CRCheckTime
	Set InputStr=InputStr_"^"_""					//CRExportFlag
	Set InputStr=InputStr_"^"_""					//CRExportUser
	Set InputStr=InputStr_"^"_""					//CRExportDate
	Set InputStr=InputStr_"^"_""					//CRExportTime
	Set InputStr=InputStr_"^"_""					//CRResume
 	Set ret=##class(DHCMed.CD.CRReport).Update(InputStr,"^")
	//Quit:ret<1 return
	If (+ret)<1 {
		TRollback
		Quit return
	}
	Set return="-2.2^子卡信息保存错误"
	Set RepID=ret
	Set InputStrNYZD=RepID
	Set InputStrNYZD=InputStrNYZD_"^"_$p(ChildInfo,"^",2)		//CRKPBH
	Set InputStrNYZD=InputStrNYZD_"^"_$p(ChildInfo,"^",3)		//ZDNYMC
	Set InputStrNYZD=InputStrNYZD_"^"_$p(ChildInfo,"^",4)		//CRNYZLSL
	Set InputStrNYZD=InputStrNYZD_"^"_$p(ChildInfo,"^",5)		//CRZDYY
	Set InputStrNYZD=InputStrNYZD_"^"_$p(ChildInfo,"^",6)		//CRZSPX
	Set InputStrNYZD=InputStrNYZD_"^"_$p(ChildInfo,"^",7)		//CRSYFS
	Set InputStrNYZD=InputStrNYZD_"^"_$p(ChildInfo,"^",8)		//CRWXXW
	Set InputStrNYZD=InputStrNYZD_"^"_$p(ChildInfo,"^",9)		//CRZDZG
	Set InputStrNYZD=InputStrNYZD_"^"_$p(ChildInfo,"^",10)		//CRZDQR
	Set InputStrNYZD=InputStrNYZD_"^"_$p(ChildInfo,"^",11)		//CRSWRQ
	Set retnyzd=##class(DHCMed.CD.CRReportNYZD).Update(InputStrNYZD,"^")
	//Quit:retnyzd<1 return
	If (+retnyzd)<1 {
		TRollback
		Quit return
	}
	Set return="-2.3^患者基本信息保存错误"
	Set InputStrPAT=RepID
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",2)	//CRPatientID
	Set InputStrPAT=InputStrPAT_"^"_""					//CRMZH
	Set InputStrPAT=InputStrPAT_"^"_""					//CRZYH
	Set InputStrPAT=InputStrPAT_"^"_""					//CRDJH
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",3)	//CRXM
	Set InputStrPAT=InputStrPAT_"^"_""					//CRJZXM
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",5)	//CRXB
	Set InputStrPAT=InputStrPAT_"^"_""	//CRCSRQ
	
	Set (AgeS,AgeY,AgeT)=""
	Set Age=$p(PatInfo,"^",6)
	Set AgeDW=$p(PatInfo,"^",7)
	/*Set objAge=##class(DHCMed.SS.Dictionary).GetObjById(AgeDW)
	If ($IsObject(objAge)) {
		If (objAge.Description="岁"){
			Set AgeS=Age
		} ElseIf (objAge.Description="月") {
			Set AgeY=Age
		} Else {
			Set AgeT=Age
		}
	}*/
	If (AgeDW="岁"){
		Set AgeS=Age
	} ElseIf (AgeDW="月") {
		Set AgeY=Age
	} Else {
		Set AgeT=Age
	}
	Set InputStrPAT=InputStrPAT_"^"_AgeS	//CRNLS
	Set InputStrPAT=InputStrPAT_"^"_AgeY	//CRNLY
	Set InputStrPAT=InputStrPAT_"^"_AgeT	//CRNLT
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",4)	//CRSFZH
	Set InputStrPAT=InputStrPAT_"^"_""	//CRJTDH
	Set InputStrPAT=InputStrPAT_"^"_""	//CRMZ
	Set InputStrPAT=InputStrPAT_"^"_""					//CRHYZK
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",10)  //CRWHCD
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",11)	//CRZY
	Set InputStrPAT=InputStrPAT_"^"_""	//CRGZ
	Set InputStrPAT=InputStrPAT_"^"_""					//CRLXR
	Set InputStrPAT=InputStrPAT_"^"_""					//CRYBRGX
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",8)	//CRLXDH
	Set InputStrPAT=InputStrPAT_"^"_""	//CRGZDW
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",9)	//CRHJ
	Set InputStrPAT=InputStrPAT_"^"_""	//CRHJDZS
	Set InputStrPAT=InputStrPAT_"^"_""	//CRHJDZS2
	Set InputStrPAT=InputStrPAT_"^"_""	//CRHJDZX
	Set InputStrPAT=InputStrPAT_"^"_""	//CRHJDZX2
	Set InputStrPAT=InputStrPAT_"^"_""	//CRHJDZC
	Set InputStrPAT=InputStrPAT_"^"_""	//CRHJDZXX
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",12)	//CRCZDZS
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",13) 	//CRCZDZS2
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",14) 	//CRCZDZX
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",15) 	//CRCZDZX2
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",16) 	//CRCZDZC
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",17) 	//CRCZDZXX
	Set retpat=##class(DHCMed.CD.CRReportPAT).Update(InputStrPAT,"^")
	//Quit:retpat<1 return
	If (+retpat)<1 {
		TRollback
		Quit return
	}
	Set return="-2.4^日志信息保存错误"
	Set InputStrLOG=RepID
	Set InputStrLOG=InputStrLOG_"^"_$p(ParRefInfo,"^",4)
	Set InputStrLOG=InputStrLOG_"^"_$p(ParRefInfo,"^",10)
	Set InputStrLOG=InputStrLOG_"^"_$p(ParRefInfo,"^",9)
	Set InputStrLOG=InputStrLOG_"^"_+$H
	Set InputStrLOG=InputStrLOG_"^"_$p($H,",",2)
	Set InputStrLOG=InputStrLOG_"^"_"UPDATE"
	Set retlog=##class(DHCMed.CD.CRReportLOG).Update(InputStrLOG,"^")
	//Quit:retlog<1 return
	If (+retlog)<1 {
		TRollback
		Quit return
	}
	Set return="-2.5^其他信息保存错误"
	Set InputStrExt=RepID
	Set ExtLen=$l(ExtraInfo,"^")
	For ind=1:1:ExtLen {
		Set UpKey=1
		Set Extinfo=$p(ExtraInfo,"^",ind)
		Set InputStrExt=RepID
		Set InputStrExt=InputStrExt_"^"_$p(Extinfo,$c(1),1)
		Set InputStrExt=InputStrExt_"^"_$p(Extinfo,$c(1),2)
		Set InputStrExt=InputStrExt_"^"_$p(Extinfo,$c(1),3)
		Set retext=##class(DHCMed.CD.CRReportBZQT).Update(InputStrExt,"^")
		Set:retext<1 UpKey=0
		Quit:retext<1 
	}
	Quit:UpKey=0 return
	If (UpKey=0) {
		TRollback
		Quit return
	}
	TCommit
	Set return=RepID	//RepID
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-09-17
/// Description:  保存主卡信息
/// Table：       DHCMed.CD.CRReport等
/// Input：       ParRefInfo:父表信息,ChildInfo:子表信息,PatInfo:患者信息,ExtraInfo:其他信息
/// Return：      返回String
/// w ##class(DHCMed.CDService.UpdateService).SaveRepDataGWZS("","","")
ClassMethod SaveRepDataGWZS(ParRefInfo As %String, ChildInfo As %String, PatInfo As %String) As %String
{
	New (ParRefInfo,ChildInfo,PatInfo,ExtraInfo)
	Set return="-2.1^主卡信息保存错误"
	TStart
	Set InputStr=$p(ParRefInfo,"^",1)				//RepID
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",2)	//CREpisodeID
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",3)	//CRRepTypeCode
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",4)	//CRReportStatus
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",5)	//CRReportLoc
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",6)	//CRReportUser
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",7)	//CRReportOrgan
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",8)	//CRReportDate
	Set InputStr=InputStr_"^"_""					//CRReportTime
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",9)	//CRUpdateUser(UserID)
	Set InputStr=InputStr_"^"_""					//CRUpdateDate
	Set InputStr=InputStr_"^"_""					//CRUpdateTime
	Set InputStr=InputStr_"^"_""					//CRCheckFlag
	Set InputStr=InputStr_"^"_""					//CRCheckUser
	Set InputStr=InputStr_"^"_""					//CRCheckDate
	Set InputStr=InputStr_"^"_""					//CRCheckTime
	Set InputStr=InputStr_"^"_""					//CRExportFlag
	Set InputStr=InputStr_"^"_""					//CRExportUser
	Set InputStr=InputStr_"^"_""					//CRExportDate
	Set InputStr=InputStr_"^"_""					//CRExportTime
	Set InputStr=InputStr_"^"_""					//CRResume
 	Set ret=##class(DHCMed.CD.CRReport).Update(InputStr,"^")
	//Quit:ret<1 return
	If (+ret)<1 {
		TRollback
		Quit return
	}
	Set return="-2.2^子卡信息保存错误"
	Set RepID=ret
	Set InputStrGWZS=RepID
	Set InputStrGWZS=InputStrGWZS_"^"_$p(ChildInfo,"^",2)		//CRKPBH
	Set InputStrGWZS=InputStrGWZS_"^"_$p(ChildInfo,"^",3)		//CRZSXZ
	Set InputStrGWZS=InputStrGWZS_"^"_$p(ChildInfo,"^",4)		//CRZSDD
	Set InputStrGWZS=InputStrGWZS_"^"_$p(ChildInfo,"^",5)		//CRZSLCBX
	Set InputStrGWZS=InputStrGWZS_"^"_$p(ChildInfo,"^",6)		//CRZSZD
	Set InputStrGWZS=InputStrGWZS_"^"_$p(ChildInfo,"^",7)		//CRZLGY
	Set InputStrGWZS=InputStrGWZS_"^"_$p(ChildInfo,"^",8)		//CRZSZG
	Set InputStrGWZS=InputStrGWZS_"^"_$p(ChildInfo,"^",9)		//CRZDRQ
	Set InputStrGWZS=InputStrGWZS_"^"_$p(ChildInfo,"^",10)		//CRSWRQ
	Set retgwzs=##class(DHCMed.CD.CRReportGWZS).Update(InputStrGWZS,"^")
	//Quit:retgwzs<1 return
	If (+retgwzs)<1 {
		TRollback
		Quit return
	}
	Set return="-2.3^患者基本信息保存错误"
	Set InputStrPAT=RepID
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",2)	//CRPatientID
	Set InputStrPAT=InputStrPAT_"^"_""					//CRMZH
	Set InputStrPAT=InputStrPAT_"^"_""					//CRZYH
	Set InputStrPAT=InputStrPAT_"^"_""					//CRDJH
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",3)	//CRXM
	Set InputStrPAT=InputStrPAT_"^"_""					//CRJZXM
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",5)	//CRXB
	Set InputStrPAT=InputStrPAT_"^"_""	//CRCSRQ
	
	Set (AgeS,AgeY,AgeT)=""
	Set Age=$p(PatInfo,"^",6)
	Set AgeDW=$p(PatInfo,"^",7)
	/*Set objAge=##class(DHCMed.SS.Dictionary).GetObjById(AgeDW)
	If ($IsObject(objAge)) {
		If (objAge.Description="岁"){
			Set AgeS=Age
		} ElseIf (objAge.Description="月") {
			Set AgeY=Age
		} Else {
			Set AgeT=Age
		}
	}*/
	If (AgeDW="岁"){
		Set AgeS=Age
	} ElseIf (AgeDW="月") {
		Set AgeY=Age
	} Else {
		Set AgeT=Age
	}
	Set InputStrPAT=InputStrPAT_"^"_AgeS	//CRNLS
	Set InputStrPAT=InputStrPAT_"^"_AgeY	//CRNLY
	Set InputStrPAT=InputStrPAT_"^"_AgeT	//CRNLT
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",4)	//CRSFZH
	Set InputStrPAT=InputStrPAT_"^"_""	//CRJTDH
	Set InputStrPAT=InputStrPAT_"^"_""	//CRMZ
	Set InputStrPAT=InputStrPAT_"^"_""					//CRHYZK
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",10)  //CRWHCD
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",11)	//CRZY
	Set InputStrPAT=InputStrPAT_"^"_""	//CRGZ
	Set InputStrPAT=InputStrPAT_"^"_""					//CRLXR
	Set InputStrPAT=InputStrPAT_"^"_""					//CRYBRGX
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",8)	//CRLXDH
	Set InputStrPAT=InputStrPAT_"^"_""	//CRGZDW
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",9)	//CRHJ
	Set InputStrPAT=InputStrPAT_"^"_""	//CRHJDZS
	Set InputStrPAT=InputStrPAT_"^"_""	//CRHJDZS2
	Set InputStrPAT=InputStrPAT_"^"_""	//CRHJDZX
	Set InputStrPAT=InputStrPAT_"^"_""	//CRHJDZX2
	Set InputStrPAT=InputStrPAT_"^"_""	//CRHJDZC
	Set InputStrPAT=InputStrPAT_"^"_""	//CRHJDZXX
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",12)	//CRCZDZS
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",13) 	//CRCZDZS2
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",14) 	//CRCZDZX
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",15) 	//CRCZDZX2
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",16) 	//CRCZDZC
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",17) 	//CRCZDZXX
	Set retpat=##class(DHCMed.CD.CRReportPAT).Update(InputStrPAT,"^")
	//Quit:retpat<1 return
	If (+retpat)<1 {
		TRollback
		Quit return
	}
	Set return="-2.4^日志信息保存错误"
	Set InputStrLOG=RepID
	Set InputStrLOG=InputStrLOG_"^"_$p(ParRefInfo,"^",4)
	Set InputStrLOG=InputStrLOG_"^"_$p(ParRefInfo,"^",10)
	Set InputStrLOG=InputStrLOG_"^"_$p(ParRefInfo,"^",9)
	Set InputStrLOG=InputStrLOG_"^"_+$H
	Set InputStrLOG=InputStrLOG_"^"_$p($H,",",2)
	Set InputStrLOG=InputStrLOG_"^"_"UPDATE"
	Set retlog=##class(DHCMed.CD.CRReportLOG).Update(InputStrLOG,"^")
	//Quit:retlog<1 return
	If (+retlog)<1 {
		TRollback
		Quit return
	}
	TCommit
	Set return=RepID	//RepID
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-09-18
/// Description:  保存主卡信息
/// Table：       DHCMed.CD.CRReport等
/// Input：       ParRefInfo:父表信息,ChildInfo:子表信息,PatInfo:患者信息,ExtraInfo:其他信息
/// Return：      返回String
/// w ##class(DHCMed.CDService.UpdateService).SaveRepDataFZYCO("","","")
ClassMethod SaveRepDataFZYCO(ParRefInfo As %String, ChildInfo As %String, PatInfo As %String, ExtraInfo As %String) As %String
{
	New (ParRefInfo,ChildInfo,PatInfo,ExtraInfo)
	Set return="-2.1^主卡信息保存错误"
	TStart
	Set InputStr=$p(ParRefInfo,"^",1)				//RepID
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",2)	//CREpisodeID
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",3)	//CRRepTypeCode
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",4)	//CRReportStatus
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",5)	//CRReportLoc
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",6)	//CRReportUser
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",7)	//CRReportOrgan
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",8)	//CRReportDate
	Set InputStr=InputStr_"^"_""					//CRReportTime
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",9)	//CRUpdateUser(UserID)
	Set InputStr=InputStr_"^"_""					//CRUpdateDate
	Set InputStr=InputStr_"^"_""					//CRUpdateTime
	Set InputStr=InputStr_"^"_""					//CRCheckFlag
	Set InputStr=InputStr_"^"_""					//CRCheckUser
	Set InputStr=InputStr_"^"_""					//CRCheckDate
	Set InputStr=InputStr_"^"_""					//CRCheckTime
	Set InputStr=InputStr_"^"_""					//CRExportFlag
	Set InputStr=InputStr_"^"_""					//CRExportUser
	Set InputStr=InputStr_"^"_""					//CRExportDate
	Set InputStr=InputStr_"^"_""					//CRExportTime
	Set InputStr=InputStr_"^"_""					//CRResume
 	Set ret=##class(DHCMed.CD.CRReport).Update(InputStr,"^")
	//Quit:ret<1 return
	If (+ret)<1 {
		TRollback
		Quit return
	}
	Set return="-2.2^子卡信息保存错误"
	Set RepID=ret
	Set InputStrFZYCO=RepID
	Set InputStrFZYCO=InputStrFZYCO_"^"_$p(ChildInfo,"^",2)		//CRKPBH
	Set InputStrFZYCO=InputStrFZYCO_"^"_$p(ChildInfo,"^",3)		//CRCOZDRQ
	Set InputStrFZYCO=InputStrFZYCO_"^"_$p(ChildInfo,"^",4)		//CRCOZDSJ
	Set InputStrFZYCO=InputStrFZYCO_"^"_$p(ChildInfo,"^",5)		//CRZDYY
	Set InputStrFZYCO=InputStrFZYCO_"^"_$p(ChildInfo,"^",6)		//CRZDCS
	Set InputStrFZYCO=InputStrFZYCO_"^"_$p(ChildInfo,"^",7)		//CRZDYS
	Set InputStrFZYCO=InputStrFZYCO_"^"_$p(ChildInfo,"^",8)		//CRZYZZ
	Set InputStrFZYCO=InputStrFZYCO_"^"_$p(ChildInfo,"^",9)		//CRZDZD
	Set InputStrFZYCO=InputStrFZYCO_"^"_$p(ChildInfo,"^",10)		//CRJZCS
	Set InputStrFZYCO=InputStrFZYCO_"^"_$p(ChildInfo,"^",11)		//CRCOZG
	Set InputStrFZYCO=InputStrFZYCO_"^"_$p(ChildInfo,"^",12)		//CRZDRQ
	Set InputStrFZYCO=InputStrFZYCO_"^"_$p(ChildInfo,"^",13)		//CRSWRQ
	Set retfzyco=##class(DHCMed.CD.CRReportFZYCO).Update(InputStrFZYCO,"^")
	//Quit:retfzyco<1 return
	If (+retfzyco)<1 {
		TRollback
		Quit return
	}
	Set return="-2.3^患者基本信息保存错误"
	Set InputStrPAT=RepID
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",2)	//CRPatientID
	Set InputStrPAT=InputStrPAT_"^"_""					//CRMZH
	Set InputStrPAT=InputStrPAT_"^"_""					//CRZYH
	Set InputStrPAT=InputStrPAT_"^"_""					//CRDJH
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",3)	//CRXM
	Set InputStrPAT=InputStrPAT_"^"_""					//CRJZXM
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",5)	//CRXB
	Set InputStrPAT=InputStrPAT_"^"_""	//CRCSRQ
	
	Set (AgeS,AgeY,AgeT)=""
	Set Age=$p(PatInfo,"^",6)
	Set AgeDW=$p(PatInfo,"^",7)
	/*Set objAge=##class(DHCMed.SS.Dictionary).GetObjById(AgeDW)
	If ($IsObject(objAge)) {
		If (objAge.Description="岁"){
			Set AgeS=Age
		} ElseIf (objAge.Description="月") {
			Set AgeY=Age
		} Else {
			Set AgeT=Age
		}
	}*/
	If (AgeDW="岁"){
		Set AgeS=Age
	} ElseIf (AgeDW="月") {
		Set AgeY=Age
	} Else {
		Set AgeT=Age
	}
	Set InputStrPAT=InputStrPAT_"^"_AgeS	//CRNLS
	Set InputStrPAT=InputStrPAT_"^"_AgeY	//CRNLY
	Set InputStrPAT=InputStrPAT_"^"_AgeT	//CRNLT
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",4)	//CRSFZH
	Set InputStrPAT=InputStrPAT_"^"_""	//CRJTDH
	Set InputStrPAT=InputStrPAT_"^"_""	//CRMZ
	Set InputStrPAT=InputStrPAT_"^"_""					//CRHYZK
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",10)  //CRWHCD
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",11)	//CRZY
	Set InputStrPAT=InputStrPAT_"^"_""	//CRGZ
	Set InputStrPAT=InputStrPAT_"^"_""					//CRLXR
	Set InputStrPAT=InputStrPAT_"^"_""					//CRYBRGX
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",8)	//CRLXDH
	Set InputStrPAT=InputStrPAT_"^"_""	//CRGZDW
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",9)	//CRHJ
	Set InputStrPAT=InputStrPAT_"^"_""	//CRHJDZS
	Set InputStrPAT=InputStrPAT_"^"_""	//CRHJDZS2
	Set InputStrPAT=InputStrPAT_"^"_""	//CRHJDZX
	Set InputStrPAT=InputStrPAT_"^"_""	//CRHJDZX2
	Set InputStrPAT=InputStrPAT_"^"_""	//CRHJDZC
	Set InputStrPAT=InputStrPAT_"^"_""	//CRHJDZXX
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",12)	//CRCZDZS
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",13) 	//CRCZDZS2
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",14) 	//CRCZDZX
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",15) 	//CRCZDZX2
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",16) 	//CRCZDZC
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",17) 	//CRCZDZXX
	Set retpat=##class(DHCMed.CD.CRReportPAT).Update(InputStrPAT,"^")
	//Quit:retpat<1 return
	If (+retpat)<1 {
		TRollback
		Quit return
	}
	Set return="-2.4^日志信息保存错误"
	Set InputStrLOG=RepID
	Set InputStrLOG=InputStrLOG_"^"_$p(ParRefInfo,"^",4)
	Set InputStrLOG=InputStrLOG_"^"_$p(ParRefInfo,"^",10)
	Set InputStrLOG=InputStrLOG_"^"_$p(ParRefInfo,"^",9)
	Set InputStrLOG=InputStrLOG_"^"_+$H
	Set InputStrLOG=InputStrLOG_"^"_$p($H,",",2)
	Set InputStrLOG=InputStrLOG_"^"_"UPDATE"
	Set retlog=##class(DHCMed.CD.CRReportLOG).Update(InputStrLOG,"^")
	//Quit:retlog<1 return
	If (+retlog)<1 {
		TRollback
		Quit return
	}
	Set return="-2.5^其他信息保存错误"
	Set InputStrExt=RepID
	Set ExtLen=$l(ExtraInfo,"^")
	For ind=1:1:ExtLen {
		Set UpKey=1
		Set Extinfo=$p(ExtraInfo,"^",ind)
		Set InputStrExt=RepID
		Set InputStrExt=InputStrExt_"^"_$p(Extinfo,$c(1),1)
		Set InputStrExt=InputStrExt_"^"_$p(Extinfo,$c(1),2)
		Set InputStrExt=InputStrExt_"^"_$p(Extinfo,$c(1),3)
		Set retext=##class(DHCMed.CD.CRReportBZQT).Update(InputStrExt,"^")
		Set:retext<1 UpKey=0
		Quit:retext<1 
	}
	//Quit:UpKey=0 return
	If (UpKey=0) {
		TRollback
		Quit return
	}
	TCommit
	Set return=RepID	//RepID
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-09-22
/// Description:  保存主卡信息
/// Table：       DHCMed.CD.CRReport等
/// Input：       ParRefInfo:父表信息,ChildInfo:子表信息,PatInfo:患者信息,ExtraInfo:其他信息
/// Return：      返回String
/// w ##class(DHCMed.CDService.UpdateService).SaveRepDataYSZYB("","","")
ClassMethod SaveRepDataYSZYB(ParRefInfo As %String, ChildInfo As %String, PatInfo As %String, ExtraInfo As %String) As %String
{
	New (ParRefInfo,ChildInfo,PatInfo,ExtraInfo)
	Set return="-2.1^主卡信息保存错误"
	TStart
	Set InputStr=$p(ParRefInfo,"^",1)				//RepID
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",2)	//CREpisodeID
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",3)	//CRRepTypeCode
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",4)	//CRReportStatus
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",5)	//CRReportLoc
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",6)	//CRReportUser
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",7)	//CRReportOrgan
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",8)	//CRReportDate
	Set InputStr=InputStr_"^"_""					//CRReportTime
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",9)	//CRUpdateUser(UserID)
	Set InputStr=InputStr_"^"_""					//CRUpdateDate
	Set InputStr=InputStr_"^"_""					//CRUpdateTime
	Set InputStr=InputStr_"^"_""					//CRCheckFlag
	Set InputStr=InputStr_"^"_""					//CRCheckUser
	Set InputStr=InputStr_"^"_""					//CRCheckDate
	Set InputStr=InputStr_"^"_""					//CRCheckTime
	Set InputStr=InputStr_"^"_""					//CRExportFlag
	Set InputStr=InputStr_"^"_""					//CRExportUser
	Set InputStr=InputStr_"^"_""					//CRExportDate
	Set InputStr=InputStr_"^"_""					//CRExportTime
	Set InputStr=InputStr_"^"_""					//CRResume
 	Set ret=##class(DHCMed.CD.CRReport).Update(InputStr,"^")
	//Quit:ret<1 return
	If (+ret)<1 {
		TRollback
		Quit return
	}
	Set return="-2.2^子卡信息保存错误"
	Set RepID=ret
	Set InputStrYSZYB=RepID
	Set InputStrYSZYB=InputStrYSZYB_"^"_$p(ChildInfo,"^",2)		//CRKPBH
	Set InputStrYSZYB=InputStrYSZYB_"^"_$p(ChildInfo,"^",3)		//CRYRDWMC
	Set InputStrYSZYB=InputStrYSZYB_"^"_$p(ChildInfo,"^",4)		//CRYRDWDZ
	Set InputStrYSZYB=InputStrYSZYB_"^"_$p(ChildInfo,"^",5)		//CRYRDWYB
	Set InputStrYSZYB=InputStrYSZYB_"^"_$p(ChildInfo,"^",6)		//CRYRDWLXR
	Set InputStrYSZYB=InputStrYSZYB_"^"_$p(ChildInfo,"^",7)		//CRYRDWLXRDH
	Set InputStrYSZYB=InputStrYSZYB_"^"_$p(ChildInfo,"^",8)		//CRJJLX
	Set InputStrYSZYB=InputStrYSZYB_"^"_$p(ChildInfo,"^",9)		//CRDWHY
	Set InputStrYSZYB=InputStrYSZYB_"^"_$p(ChildInfo,"^",10)		//CRQYGM
	Set InputStrYSZYB=InputStrYSZYB_"^"_$p(ChildInfo,"^",11)		//CRBRLY
	Set InputStrYSZYB=InputStrYSZYB_"^"_$p(ChildInfo,"^",12)		//CRZYBZL
	Set InputStrYSZYB=InputStrYSZYB_"^"_$p(ChildInfo,"^",13)		//CRJTBM
	Set InputStrYSZYB=InputStrYSZYB_"^"_$p(ChildInfo,"^",14)		//CRZDSGBM
	Set InputStrYSZYB=InputStrYSZYB_"^"_$p(ChildInfo,"^",15)		//CRTSZDRS
	Set InputStrYSZYB=InputStrYSZYB_"^"_$p(ChildInfo,"^",16)		//CRTJGZ
	Set InputStrYSZYB=InputStrYSZYB_"^"_$p(ChildInfo,"^",17)		//CRZYGLN
	Set InputStrYSZYB=InputStrYSZYB_"^"_$p(ChildInfo,"^",18)		//CRZYGLY
	Set InputStrYSZYB=InputStrYSZYB_"^"_$p(ChildInfo,"^",19)		//CRJCSJT
	Set InputStrYSZYB=InputStrYSZYB_"^"_$p(ChildInfo,"^",20)		//CRJCSJS
	Set InputStrYSZYB=InputStrYSZYB_"^"_$p(ChildInfo,"^",21)		//CRJCSJF
	Set InputStrYSZYB=InputStrYSZYB_"^"_$p(ChildInfo,"^",22)		//CRFSRQ
	Set InputStrYSZYB=InputStrYSZYB_"^"_$p(ChildInfo,"^",23)		//CRZDRQ
	Set InputStrYSZYB=InputStrYSZYB_"^"_$p(ChildInfo,"^",24)		//CRSWRQ
	Set retyszyb=##class(DHCMed.CD.CRReportYSZYB).Update(InputStrYSZYB,"^")
	//Quit:retyszyb<1 return
	If (+retyszyb)<1 {
		TRollback
		Quit return
	}
	Set return="-2.3^患者基本信息保存错误"
	Set InputStrPAT=RepID
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",2)	//CRPatientID
	Set InputStrPAT=InputStrPAT_"^"_""					//CRMZH
	Set InputStrPAT=InputStrPAT_"^"_""					//CRZYH
	Set InputStrPAT=InputStrPAT_"^"_""					//CRDJH
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",3)	//CRXM
	Set InputStrPAT=InputStrPAT_"^"_""					//CRJZXM
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",5)	//CRXB
	Set InputStrPAT=InputStrPAT_"^"_""	//CRCSRQ
	
	Set (AgeS,AgeY,AgeT)=""
	Set Age=$p(PatInfo,"^",6)
	Set AgeDW=$p(PatInfo,"^",7)
	/*Set objAge=##class(DHCMed.SS.Dictionary).GetObjById(AgeDW)
	If ($IsObject(objAge)) {
		If (objAge.Description="岁"){
			Set AgeS=Age
		} ElseIf (objAge.Description="月") {
			Set AgeY=Age
		} Else {
			Set AgeT=Age
		}
	}*/
	If (AgeDW="岁"){
		Set AgeS=Age
	} ElseIf (AgeDW="月") {
		Set AgeY=Age
	} Else {
		Set AgeT=Age
	}
	Set InputStrPAT=InputStrPAT_"^"_AgeS	//CRNLS
	Set InputStrPAT=InputStrPAT_"^"_AgeY	//CRNLY
	Set InputStrPAT=InputStrPAT_"^"_AgeT	//CRNLT
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",4)	//CRSFZH
	Set InputStrPAT=InputStrPAT_"^"_""	//CRJTDH
	Set InputStrPAT=InputStrPAT_"^"_""	//CRMZ
	Set InputStrPAT=InputStrPAT_"^"_""					//CRHYZK
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",10)  //CRWHCD
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",11)	//CRZY
	Set InputStrPAT=InputStrPAT_"^"_""	//CRGZ
	Set InputStrPAT=InputStrPAT_"^"_""					//CRLXR
	Set InputStrPAT=InputStrPAT_"^"_""					//CRYBRGX
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",8)	//CRLXDH
	Set InputStrPAT=InputStrPAT_"^"_""	//CRGZDW
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",9)	//CRHJ
	Set InputStrPAT=InputStrPAT_"^"_""	//CRHJDZS
	Set InputStrPAT=InputStrPAT_"^"_""	//CRHJDZS2
	Set InputStrPAT=InputStrPAT_"^"_""	//CRHJDZX
	Set InputStrPAT=InputStrPAT_"^"_""	//CRHJDZX2
	Set InputStrPAT=InputStrPAT_"^"_""	//CRHJDZC
	Set InputStrPAT=InputStrPAT_"^"_""	//CRHJDZXX
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",12)	//CRCZDZS
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",13) 	//CRCZDZS2
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",14) 	//CRCZDZX
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",15) 	//CRCZDZX2
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",16) 	//CRCZDZC
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",17) 	//CRCZDZXX
	Set retpat=##class(DHCMed.CD.CRReportPAT).Update(InputStrPAT,"^")
	//Quit:retpat<1 return
	If (+retpat)<1 {
		TRollback
		Quit return
	}
	Set return="-2.4^日志信息保存错误"
	Set InputStrLOG=RepID
	Set InputStrLOG=InputStrLOG_"^"_$p(ParRefInfo,"^",4)
	Set InputStrLOG=InputStrLOG_"^"_$p(ParRefInfo,"^",10)
	Set InputStrLOG=InputStrLOG_"^"_$p(ParRefInfo,"^",9)
	Set InputStrLOG=InputStrLOG_"^"_+$H
	Set InputStrLOG=InputStrLOG_"^"_$p($H,",",2)
	Set InputStrLOG=InputStrLOG_"^"_"UPDATE"
	Set retlog=##class(DHCMed.CD.CRReportLOG).Update(InputStrLOG,"^")
	//Quit:retlog<1 return
	If (+retlog)<1 {
		TRollback
		Quit return
	}
	TCommit
	Set return=RepID	//RepID
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-11-12
/// Description:  保存主卡信息
/// Table：       DHCMed.CD.CRReport等
/// Input：       ParRefInfo:父表信息,ChildInfo:子表信息,PatInfo:患者信息
/// Return：      返回String
/// w ##class(DHCMed.CDService.UpdateService).SaveRepDataTNB("","","")
ClassMethod SaveRepDataTNB(ParRefInfo As %String, ChildInfo As %String, PatInfo As %String) As %String
{
	New (ParRefInfo,ChildInfo,PatInfo)
	Set return="-2.1^主卡信息保存错误"
	TStart
	Set InputStr=$p(ParRefInfo,"^",1)				//RepID
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",2)	//CREpisodeID
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",3)	//CRRepTypeCode
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",4)	//CRReportStatus
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",5)	//CRReportLoc
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",6)	//CRReportUser
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",7)	//CRReportOrgan
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",8)	//CRReportDate
	Set InputStr=InputStr_"^"_""					//CRReportTime
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",9)	//CRUpdateUser(UserID)
	Set InputStr=InputStr_"^"_""					//CRUpdateDate
	Set InputStr=InputStr_"^"_""					//CRUpdateTime
	Set InputStr=InputStr_"^"_""					//CRCheckFlag
	Set InputStr=InputStr_"^"_""					//CRCheckUser
	Set InputStr=InputStr_"^"_""					//CRCheckDate
	Set InputStr=InputStr_"^"_""					//CRCheckTime
	Set InputStr=InputStr_"^"_""					//CRExportFlag
	Set InputStr=InputStr_"^"_""					//CRExportUser
	Set InputStr=InputStr_"^"_""					//CRExportDate
	Set InputStr=InputStr_"^"_""					//CRExportTime
	Set InputStr=InputStr_"^"_""					//CRResume
 	Set ret=##class(DHCMed.CD.CRReport).Update(InputStr,"^")
	//Quit:ret<1 return
	If (+ret)<1 {
		TRollback
		Quit return
	}
	Set return="-2.2^子卡信息保存错误"
	Set RepID=ret
	Set InputStrTNB=RepID
	Set InputStrTNB=InputStrTNB_"^"_$p(ChildInfo,"^",2)		//CRKPBH
	Set InputStrTNB=InputStrTNB_"^"_$p(ChildInfo,"^",3)		//CRZDLX
	Set InputStrTNB=InputStrTNB_"^"_$p(ChildInfo,"^",4)		//CRZD
	Set InputStrTNB=InputStrTNB_"^"_$p(ChildInfo,"^",5)		//CRZDICD
	Set InputStrTNB=InputStrTNB_"^"_$p(ChildInfo,"^",6)		//CRBFZ
	Set InputStrTNB=InputStrTNB_"^"_$p(ChildInfo,"^",7)		//CRWHYS
	Set InputStrTNB=InputStrTNB_"^"_$p(ChildInfo,"^",8)		//CRTZ
	Set InputStrTNB=InputStrTNB_"^"_$p(ChildInfo,"^",9)		//CRSG
	Set InputStrTNB=InputStrTNB_"^"_$p(ChildInfo,"^",10)	//CRJZS
	Set InputStrTNB=InputStrTNB_"^"_$p(ChildInfo,"^",11)	//CRRS
	Set InputStrTNB=InputStrTNB_"^"_$p(ChildInfo,"^",12)	//CRZDDate
	Set InputStrTNB=InputStrTNB_"^"_$p(ChildInfo,"^",14)	//CRSWYY
	Set InputStrTNB=InputStrTNB_"^"_$p(ChildInfo,"^",13)	//CRSWRQ
	Set InputStrTNB=InputStrTNB_"^"_$p(ChildInfo,"^",15)	//CRSYICD
	Set InputStrTNB=InputStrTNB_"^"_$p(ChildInfo,"^",16)	//CRSWJTYY
	Set InputStrTNB=InputStrTNB_"^"_$p(ChildInfo,"^",17)	//CRSWZD
	Set InputStrTNB=InputStrTNB_"^"_$p(ChildInfo,"^",18)	//CRLCBX
	Set InputStrTNB=InputStrTNB_"^"_$p(ChildInfo,"^",19)	//CRQTLCBX
	Set InputStrTNB=InputStrTNB_"^"_$p(ChildInfo,"^",20)	//
	Set InputStrTNB=InputStrTNB_"^"_$p(ChildInfo,"^",21)	//txtCRZYJCQK1
	Set InputStrTNB=InputStrTNB_"^"_$p(ChildInfo,"^",22)	//txtCRZYJCQK2
	Set InputStrTNB=InputStrTNB_"^"_$p(ChildInfo,"^",23)	//txtCRZYJCQK3
	Set InputStrTNB=InputStrTNB_"^"_$p(ChildInfo,"^",24)	//txtCRZYJCQK4
	Set InputStrTNB=InputStrTNB_"^"_$p(ChildInfo,"^",25)	//txtCRZYJCQK5
	Set InputStrTNB=InputStrTNB_"^"_$p(ChildInfo,"^",26)	//txtCRZYJCQK6
	Set InputStrTNB=InputStrTNB_"^"_$p(ChildInfo,"^",27)	//txtCRZYJCQK7
	Set InputStrTNB=InputStrTNB_"^"_$p(ChildInfo,"^",28)	//txtCRZYJCQK8
	Set InputStrTNB=InputStrTNB_"^"_$p(ChildInfo,"^",29)	//txtCRZYJCQK9
	Set rettnb=##class(DHCMed.CD.CRReportTNB).Update(InputStrTNB,"^")
	//Quit:rettnb<1 return
	If (+rettnb)<1 {
		TRollback
		Quit return
	}
	Set return="-2.3^患者基本信息保存错误"
	Set InputStrPAT=RepID
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",2)	//CRPatientID
	Set InputStrPAT=InputStrPAT_"^"_""					//CRMZH
	Set InputStrPAT=InputStrPAT_"^"_""					//CRZYH
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",3)	//CRDJH
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",4)	//CRXM
	Set InputStrPAT=InputStrPAT_"^"_""					//CRJZXM
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",6)	//CRXB
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",9)	//CRCSRQ
	
	Set (AgeS,AgeY,AgeT)=""
	Set Age=$p(PatInfo,"^",7)
	Set AgeDW=$p(PatInfo,"^",8)
	If (AgeDW="岁"){
		Set AgeS=Age
		Set AgeY=""
		Set AgeT=""
	} ElseIf (AgeDW="月") {
		Set AgeY=Age
		Set AgeS=""
		Set AgeT=""
	} Else {
		Set AgeT=Age
		Set AgeY=""
		Set AgeS=""
	}
	Set InputStrPAT=InputStrPAT_"^"_AgeS	//CRNLS
	Set InputStrPAT=InputStrPAT_"^"_AgeY	//CRNLY
	Set InputStrPAT=InputStrPAT_"^"_AgeT	//CRNLT
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",5)	//CRSFZH
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",13)	//CRJTDH
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",11)	//CRMZ
	Set InputStrPAT=InputStrPAT_"^"_""					//CRHYZK
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",27)	//CRWHCD
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",10)	//CRZY
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",12)	//CRGZ
	Set InputStrPAT=InputStrPAT_"^"_""					//CRLXR
	Set InputStrPAT=InputStrPAT_"^"_""					//CRYBRGX
	Set InputStrPAT=InputStrPAT_"^"_""					//CRLXDH
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",14)	//CRGZDW
	Set InputStrPAT=InputStrPAT_"^"_""					//CRHJ
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",21)	//CRHJDZS
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",22)	//CRHJDZS2
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",23)	//CRHJDZX
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",24)	//CRHJDZX2
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",25)	//CRHJDZC
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",26)	//CRHJDZXX
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",15)	//CRCZDZS
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",16)	//CRCZDZS2
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",17)	//CRCZDZX
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",18)	//CRCZDZX2
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",19)	//CRCZDZC
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",20)	//CRCZDZXX
	Set retpat=##class(DHCMed.CD.CRReportPAT).Update(InputStrPAT,"^")
	//Quit:retpat<1 return
	If (+retpat)<1 {
		TRollback
		Quit return
	}
	Set return="-2.4^日志信息保存错误"
	Set InputStrLOG=RepID
	Set InputStrLOG=InputStrLOG_"^"_$p(ParRefInfo,"^",4)
	Set InputStrLOG=InputStrLOG_"^"_$p(ParRefInfo,"^",10)
	Set InputStrLOG=InputStrLOG_"^"_$p(ParRefInfo,"^",9)
	Set InputStrLOG=InputStrLOG_"^"_+$H
	Set InputStrLOG=InputStrLOG_"^"_$p($H,",",2)
	Set InputStrLOG=InputStrLOG_"^"_"UPDATE"
	Set retlog=##class(DHCMed.CD.CRReportLOG).Update(InputStrLOG,"^")
	//Quit:retlog<1 return
	If (+retlog)<1 {
		TRollback
		Quit return
	}
	TCommit
	Set return=RepID	//RepID
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-11-12
/// Description:  保存高血压主卡信息
/// Table：       DHCMed.CD.CRReport等
/// Input：       ParRefInfo:父表信息,ChildInfo:子表信息,PatInfo:患者信息
/// Return：      返回String
/// w ##class(DHCMed.CDService.UpdateService).SaveRepDataGXY("^24^GXY^1^95^医生01^东华标准版数字化医院[总院]^2022-06-21^^10209^^^0^^^^0^^^^^95","^^监狱^2^8549,8550^undefined^I10.x03^58^178^8555,8560^88^99^58^其他","^37^^^0000000037^住院00^^未知性别^1993-01-31^29^^^510125199811133878^^815^^^^^^^^^^^^^^^^665^666^667^668^89^河北省石家庄市长安区建北街道办事处89")
ClassMethod SaveRepDataGXY(ParRefInfo As %String, ChildInfo As %String, PatInfo As %String) As %String
{
	New (ParRefInfo,ChildInfo,PatInfo)
	Set return="-2.1^主卡信息保存错误"
	TStart
	Set InputStr=$p(ParRefInfo,"^",1)				//RepID
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",2)	//CREpisodeID
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",3)	//CRRepTypeCode
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",4)	//CRReportStatus
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",5)	//CRReportLoc
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",6)	//CRReportUser
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",7)	//CRReportOrgan
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",8)	//CRReportDate
	Set InputStr=InputStr_"^"_""					//CRReportTime
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",9)	//CRUpdateUser(UserID)
	Set InputStr=InputStr_"^"_""					//CRUpdateDate
	Set InputStr=InputStr_"^"_""					//CRUpdateTime
	Set InputStr=InputStr_"^"_""					//CRCheckFlag
	Set InputStr=InputStr_"^"_""					//CRCheckUser
	Set InputStr=InputStr_"^"_""					//CRCheckDate
	Set InputStr=InputStr_"^"_""					//CRCheckTime
	Set InputStr=InputStr_"^"_""					//CRExportFlag
	Set InputStr=InputStr_"^"_""					//CRExportUser
	Set InputStr=InputStr_"^"_""					//CRExportDate
	Set InputStr=InputStr_"^"_""					//CRExportTime
	Set InputStr=InputStr_"^"_""					//CRResume
 	Set ret=##class(DHCMed.CD.CRReport).Update(InputStr,"^")
	//Quit:ret<1 return
	If (+ret)<1 {
		TRollback
		Quit return
	}
	Set return="-2.2^子卡信息保存错误"
	Set RepID=ret
	Set InputStrGXY=RepID
	Set InputStrGXY=InputStrGXY_"^"_$p(ChildInfo,"^",2)		// CRKPBH
	Set InputStrGXY=InputStrGXY_"^"_$p(ChildInfo,"^",3)		// PatStatus
	Set InputStrGXY=InputStrGXY_"^"_$p(ChildInfo,"^",4)		// 家族史
	Set InputStrGXY=InputStrGXY_"^"_$p(ChildInfo,"^",5)		// 有高血压的是什么关系
	Set InputStrGXY=InputStrGXY_"^"_$p(ChildInfo,"^",6)		// 高血压诊断
	Set InputStrGXY=InputStrGXY_"^"_$p(ChildInfo,"^",7)		// 诊断ICD-10
	Set InputStrGXY=InputStrGXY_"^"_$p(ChildInfo,"^",8)		// 体重
	Set InputStrGXY=InputStrGXY_"^"_$p(ChildInfo,"^",9)		// 身高
	Set InputStrGXY=InputStrGXY_"^"_$p(ChildInfo,"^",10)	// 症状
	Set InputStrGXY=InputStrGXY_"^"_$p(ChildInfo,"^",11)	// 收缩压
	Set InputStrGXY=InputStrGXY_"^"_$p(ChildInfo,"^",12)	// 舒张压
	Set InputStrGXY=InputStrGXY_"^"_$p(ChildInfo,"^",13)	// 心率
	Set InputStrGXY=InputStrGXY_"^"_$p(ChildInfo,"^",14)	// 其他
	
	Set rettnb=##class(DHCMed.CD.CRReportGXY).Update(InputStrGXY,"^")
	//Quit:rettnb<1 return
	If (+rettnb)<1 {
		TRollback
		Quit return
	}
	Set return="-2.3^患者基本信息保存错误"
	Set InputStrPAT=RepID
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",2)	//CRPatientID
	Set InputStrPAT=InputStrPAT_"^"_""					//CRMZH
	Set InputStrPAT=InputStrPAT_"^"_""					//CRZYH
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",5)	//CRDJH
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",6)	//CRXM
	Set InputStrPAT=InputStrPAT_"^"_""					//CRJZXM
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",8)	//CRXB
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",9)	//CRCSRQ
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",10)	//CRNLS
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",11)	//CRNLY
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",12)	//CRNLT
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",13)	//CRSFZH
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",14)	//CRJTDH
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",15)	//CRMZ
	Set InputStrPAT=InputStrPAT_"^"_""					//CRHYZK
	Set InputStrPAT=InputStrPAT_"^"_""					//CRWHCD
	Set InputStrPAT=InputStrPAT_"^"_""					//CRZY
	Set InputStrPAT=InputStrPAT_"^"_""					//CRGZ
	Set InputStrPAT=InputStrPAT_"^"_""					//CRLXR
	Set InputStrPAT=InputStrPAT_"^"_""					//CRYBRGX
	Set InputStrPAT=InputStrPAT_"^"_""					//CRLXDH
	Set InputStrPAT=InputStrPAT_"^"_""					//CRGZDW
	Set InputStrPAT=InputStrPAT_"^"_""					//CRHJ
	Set InputStrPAT=InputStrPAT_"^"_""					//CRHJDZS
	Set InputStrPAT=InputStrPAT_"^"_""					//CRHJDZS2
	Set InputStrPAT=InputStrPAT_"^"_""					//CRHJDZX
	Set InputStrPAT=InputStrPAT_"^"_""					//CRHJDZX2
	Set InputStrPAT=InputStrPAT_"^"_""					//CRHJDZC
	Set InputStrPAT=InputStrPAT_"^"_""					//CRHJDZXX
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",31)	//CRCZDZS
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",32)	//CRCZDZS2
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",33)	//CRCZDZX
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",34)	//CRCZDZX2
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",35)	//CRCZDZC
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",36)	//CRCZDZXX
	Set retpat=##class(DHCMed.CD.CRReportPAT).Update(InputStrPAT,"^")
	//Quit:retpat<1 return
	If (+retpat)<1 {
		TRollback
		Quit return
	}
	Set return="-2.4^日志信息保存错误"
	Set InputStrLOG=RepID
	Set InputStrLOG=InputStrLOG_"^"_$p(ParRefInfo,"^",4)
	Set InputStrLOG=InputStrLOG_"^"_$p(ParRefInfo,"^",10)
	Set InputStrLOG=InputStrLOG_"^"_$p(ParRefInfo,"^",9)
	Set InputStrLOG=InputStrLOG_"^"_+$H
	Set InputStrLOG=InputStrLOG_"^"_$p($H,",",2)
	Set InputStrLOG=InputStrLOG_"^"_"UPDATE"
	Set retlog=##class(DHCMed.CD.CRReportLOG).Update(InputStrLOG,"^")
	//Quit:retlog<1 return
	If (+retlog)<1 {
		TRollback
		Quit return
	}
	TCommit
	Set return=RepID	//RepID
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2016-04-27
/// Description:  保存主卡信息
/// Table：       DHCMed.CD.CRReport等
/// Input：       ParRefInfo:父表信息,ChildInfo:子表信息,PatInfo:患者信息
/// Return：      返回String
/// w ##class(DHCMed.CDService.UpdateService).SaveRepDataMBBK("^","2")
ClassMethod SaveRepDataMBBK(ParRefInfo As %String, ChildInfo As %String, PatInfo As %String) As %String
{
	New (ParRefInfo,ChildInfo,PatInfo)
	Set return="-2.1^主卡信息保存错误"
	TStart
	Set InputStr=$p(ParRefInfo,"^",1)				//RepID
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",2)	//CREpisodeID
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",3)	//CRRepTypeCode
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",4)	//CRReportStatus
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",5)	//CRReportLoc
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",6)	//CRReportUser
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",7)	//CRReportOrgan
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",8)	//CRReportDate
	Set InputStr=InputStr_"^"_""					//CRReportTime
	Set InputStr=InputStr_"^"_$p(ParRefInfo,"^",9)	//CRUpdateUser(UserID)
	Set InputStr=InputStr_"^"_""					//CRUpdateDate
	Set InputStr=InputStr_"^"_""					//CRUpdateTime
	Set InputStr=InputStr_"^"_""					//CRCheckFlag
	Set InputStr=InputStr_"^"_""					//CRCheckUser
	Set InputStr=InputStr_"^"_""					//CRCheckDate
	Set InputStr=InputStr_"^"_""					//CRCheckTime
	Set InputStr=InputStr_"^"_""					//CRExportFlag
	Set InputStr=InputStr_"^"_""					//CRExportUser
	Set InputStr=InputStr_"^"_""					//CRExportDate
	Set InputStr=InputStr_"^"_""					//CRExportTime
	Set InputStr=InputStr_"^"_""					//CRResume
 	Set ret=##class(DHCMed.CD.CRReport).Update(InputStr,"^")
	//Quit:ret<1 return
	If (+ret)<1 {
		TRollback
		Quit return
	}
	Set return="-2.2^子卡信息保存错误"
	Set RepID=ret
	Set InputStrMBBK=RepID
	Set InputStrMBBK=InputStrMBBK_"^"_$p(ChildInfo,"^",2)		//CRKPBH
	Set InputStrMBBK=InputStrMBBK_"^"_$p(ChildInfo,"^",3)		//CRBGKLX
	Set InputStrMBBK=InputStrMBBK_"^"_$p(ChildInfo,"^",4)		//CRFBRQ
	Set InputStrMBBK=InputStrMBBK_"^"_$p(ChildInfo,"^",5)		//CRSFFBRQGJ
	Set InputStrMBBK=InputStrMBBK_"^"_$p(ChildInfo,"^",6)		//CRQZRQ
	Set InputStrMBBK=InputStrMBBK_"^"_$p(ChildInfo,"^",7)		//CRSWRQ
	Set InputStrMBBK=InputStrMBBK_"^"_""		                //CRSWYY
	Set InputStrMBBK=InputStrMBBK_"^"_$p(ChildInfo,"^",8)		//CRJTSWYY
	Set InputStrMBBK=InputStrMBBK_"^"_""						//CRSWZD
	Set InputStrMBBK=InputStrMBBK_"^"_""						//CRSWICD
	Set InputStrMBBK=InputStrMBBK_"^"_$p(ChildInfo,"^",9)	    //CRZDYJ
	Set InputStrMBBK=InputStrMBBK_"^"_$p(ChildInfo,"^",10)	    //CRZDDW
	Set InputStrMBBK=InputStrMBBK_"^"_$p(ChildInfo,"^",11)	     //CRGXBZD
	Set InputStrMBBK=InputStrMBBK_"^"_$p(ChildInfo,"^",12)       //CRNCZZD
	Set InputStrMBBK=InputStrMBBK_"^"_$p(ChildInfo,"^",13)		//CRTNBZD
    Set InputStrMBBK=InputStrMBBK_"^"_$p(ChildInfo,"^",14)	//CRZDBM
	Set InputStrMBBK=InputStrMBBK_"^"_$p(ChildInfo,"^",15)	//CRZDMC
	
	Set InputStrMBBK=InputStrMBBK_"^"_$p(ChildInfo,"^",16)	//CRGZZD
	Set CRGZZD=##class(DHCMed.CD.CRReportMBBK).GetICDDescByID(+$p(ChildInfo,"^",16))
	Set GZZDICD=$p(CRGZZD,$c(1),3)
	Set InputStrMBBK=InputStrMBBK_"^"_GZZDICD                	//CRGZZDICD
	Set InputStrMBBK=InputStrMBBK_"^"_""	                //CRGZZDRQ
	
	Set InputStrMBBK=InputStrMBBK_"^"_$p(ChildInfo,"^",17)	//CRFYBW
	Set InputStrMBBK=InputStrMBBK_"^"_$p(ChildInfo,"^",18)	//CRJFBW
    Set InputStrMBBK=InputStrMBBK_"^"_$p(ChildInfo,"^",19)	//CRBLXLX
	Set InputStrMBBK=InputStrMBBK_"^"_$p(ChildInfo,"^",20)  //CRBLH

	Set retMBBK=##class(DHCMed.CD.CRReportMBBK).Update(InputStrMBBK,"^")
	//Quit:retMBBK<1 return
	If (+retMBBK)<1 {
		TRollback
		Quit return
	}
	Set return="-2.3^患者基本信息保存错误"
	Set InputStrPAT=RepID
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",2)	//CRPatientID
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",3)	 //CRMZH
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",4)    //CRZYH
	Set InputStrPAT=InputStrPAT_"^"_""					//CRDJH
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",5)	//CRXM
	Set InputStrPAT=InputStrPAT_"^"_""					//CRJZXM
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",6)	//CRXB
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",7)	//CRCSRQ
	
	Set (AgeS,AgeY,AgeT)=""
	Set Age=$p(PatInfo,"^",9)
	Set AgeDW=$p(PatInfo,"^",10)

	If (AgeDW="岁"){
		Set AgeS=Age
		Set AgeY=""
		Set AgeT=""
	} ElseIf (AgeDW="月") {
		Set AgeY=Age
		Set AgeS=""
		Set AgeT=""
		
	} Else {
		Set AgeT=Age
		Set AgeY=""
		Set AgeS=""
	}	
	Set InputStrPAT=InputStrPAT_"^"_AgeS	//CRNLS
	Set InputStrPAT=InputStrPAT_"^"_AgeY	//CRNLY
	Set InputStrPAT=InputStrPAT_"^"_AgeT	//CRNLT
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",13)	//CRSFZH
	Set InputStrPAT=InputStrPAT_"^"_""	                //CRJTDH
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",8)	//CRMZ
	Set InputStrPAT=InputStrPAT_"^"_""					//CRHYZK
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",11)  //CRWHCD
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",12)	//CRZY
	Set InputStrPAT=InputStrPAT_"^"_""	                //CRGZ
	Set InputStrPAT=InputStrPAT_"^"_""					//CRLXR
	Set InputStrPAT=InputStrPAT_"^"_""					//CRYBRGX
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",14)	//CRLXDH
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",15)	//CRGZDW
	Set InputStrPAT=InputStrPAT_"^"_""					//CRHJ
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",16)	//CRHJDZS
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",17)	//CRHJDZS2
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",18)	//CRHJDZX
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",19)	//CRHJDZX2
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",20)	//CRHJDZC
	Set InputStrPAT=InputStrPAT_"^"_""                   //CRHJDZXX
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",21)	//CRCZDZS
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",22)	//CRCZDZS2
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",23)	//CRCZDZX
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",24)	//CRCZDZX2
	Set InputStrPAT=InputStrPAT_"^"_$p(PatInfo,"^",25)	//CRCZDZC
	Set InputStrPAT=InputStrPAT_"^"_""                	//CRCZDZXX
	Set retpat=##class(DHCMed.CD.CRReportPAT).Update(InputStrPAT,"^")
	//Quit:retpat<1 return
	If (+retpat)<1 {
		TRollback
		Quit return
	}
	Set return="-2.4^日志信息保存错误"
	Set InputStrLOG=RepID
	Set InputStrLOG=InputStrLOG_"^"_$p(ParRefInfo,"^",4)
	Set InputStrLOG=InputStrLOG_"^"_$p(ParRefInfo,"^",10)
	Set InputStrLOG=InputStrLOG_"^"_$p(ParRefInfo,"^",9)
	Set InputStrLOG=InputStrLOG_"^"_+$H
	Set InputStrLOG=InputStrLOG_"^"_$p($H,",",2)
	Set InputStrLOG=InputStrLOG_"^"_"UPDATE"
	Set retlog=##class(DHCMed.CD.CRReportLOG).Update(InputStrLOG,"^")
	//Quit:retlog<1 return
	If (+retlog)<1 {
		TRollback
		Quit return
	}
	TCommit
	Set return=RepID	//RepID
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2019-12-04
/// Description:  保存主卡信息
/// Table：       DHCMed.CD.CRReport等
/// Input：       ParRefInfo:父表信息,ChildInfo:子表信息,PatInfo:患者信息
/// Return：      返回String
/// w ##class(DHCMed.CDService.UpdateService).SaveRepDataCSQX("","","")
ClassMethod SaveRepDataCSQX(ParRefInfo As %String, ChildInfo As %String, PatInfo As %String) As %String
{
	New (ParRefInfo,ChildInfo,PatInfo)
	Set return="-2.1^主卡信息保存错误"
	TStart
	Set ret=##class(DHCMed.CD.CRReport).Update(ParRefInfo,"^")
	//Quit:ret<1 return
	If (+ret)<1 {
		TRollback
		Quit return
	}
	Set return="-2.2^子卡信息保存错误"
	Set RepID=ret
	Set $p(ChildInfo,"^",1)=RepID
	Set retCSQX=##class(DHCMed.CD.CRReportCSQX).Update(ChildInfo,"^")
	//Quit:retCSQX<1 return
	If (+retCSQX)<1 {
		TRollback
		Quit return
	}
	Set return="-2.3^患者基本信息保存错误"
	Set $p(PatInfo,"^",1)=RepID
	Set retpat=##class(DHCMed.CD.CRReportPAT).Update(PatInfo,"^")
	//Quit:retpat<1 return
	If (+retpat)<1 {
		TRollback
		Quit return
	}
	Set return="-2.4^日志信息保存错误"
	Set InputStrLOG=RepID
	Set InputStrLOG=InputStrLOG_"^"_"1"
	Set InputStrLOG=InputStrLOG_"^"_$p(ParRefInfo,"^",22)
	Set InputStrLOG=InputStrLOG_"^"_$p(ParRefInfo,"^",10)
	Set InputStrLOG=InputStrLOG_"^"_+$H
	Set InputStrLOG=InputStrLOG_"^"_$p($H,",",2)
	Set InputStrLOG=InputStrLOG_"^"_"UPDATE"
	Set retlog=##class(DHCMed.CD.CRReportLOG).Update(InputStrLOG,"^")
	//Quit:retlog<1 return
	If (+retlog)<1 {
		TRollback
		Quit return
	}
	TCommit
	Set return=RepID	//RepID
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2021-10-13
/// Description:  保存主卡信息
/// Table：       DHCMed.CD.CRReport等
/// Input：       ParRefInfo:父表信息,ChildInfo:子表信息,PatInfo:患者信息
/// Return：      返回String
/// w ##class(DHCMed.CDService.UpdateService).SaveRepDataETSH("","","")
ClassMethod SaveRepDataETSH(ParRefInfo As %String, ChildInfo As %String, PatInfo As %String) As %String
{
	New (ParRefInfo,ChildInfo,PatInfo)
	Set return="-2.1^主卡信息保存错误"
	
	Set ret=##class(DHCMed.CD.CRReport).Update(ParRefInfo,"^")
	Quit:ret<1 return
	
	Set return="-2.2^子卡信息保存错误"
	Set RepID=ret
	Set $p(ChildInfo,"^",1)=RepID
	Set retETSH=##class(DHCMed.CD.CRReportETSH).Update(ChildInfo,"^")
	Quit:retETSH<1 return
	
	Set return="-2.3^患者基本信息保存错误"
	Set $p(PatInfo,"^",1)=RepID
	Set retpat=##class(DHCMed.CD.CRReportPAT).Update(PatInfo,"^")
	Quit:retpat<1 return
	
	Set return="-2.4^日志信息保存错误"
	Set InputStrLOG=RepID
	Set InputStrLOG=InputStrLOG_"^"_"1"
	Set InputStrLOG=InputStrLOG_"^"_$p(ParRefInfo,"^",22)
	Set InputStrLOG=InputStrLOG_"^"_$p(ParRefInfo,"^",10)
	Set InputStrLOG=InputStrLOG_"^"_+$H
	Set InputStrLOG=InputStrLOG_"^"_$p($H,",",2)
	Set InputStrLOG=InputStrLOG_"^"_"UPDATE"
	Set retlog=##class(DHCMed.CD.CRReportLOG).Update(InputStrLOG,"^")
	Quit:retlog<1 return
	
	Set return=RepID	//RepID
	Quit return
}

}
