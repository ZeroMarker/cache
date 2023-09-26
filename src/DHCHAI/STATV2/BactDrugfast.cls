/// 名称: DHCHAI.STATV2.BactDrugfast
/// 描述: 病原体耐药性统计
/// 编写者：zhoubo
/// 编写日期: 2020-11-12
Class DHCHAI.STATV2.BactDrugfast Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2020-11-12
/// Description:  病原体耐药性统计
/// Table：       DHCHAI.IR.CCResult
/// Input:        aHospIDs   : 多个医院用"|"连接
///               aDateType  : 日期类型 1：送检日期
/// 			  aDateFrom  ：开始日期
/// 			  aDateTo    : 结束日期
/// 			  aLocType   : 科室类型
///               aLocIDs    : 科室/病区ID
///               aBactID    : 细菌字典ID
/// 			  aTypeCode  ：感染类型
///               aDrugLevel : 耐药级别 1：多耐菌 2：敏感
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.BactDrugfast","QryMRBResult","","","2018-04-01","2020-11-12","","278")
Query QryMRBResult(aHospIDs As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aLocIDs As %String, aBactID As %String, aTypeCode As %String, aDrugLevel As %String) As %Query(ROWSPEC = "DrugLevel:%String,AntDesc:%String,AntSum:%Integer,ZJCSum:%Integer,SenSum:%Integer,SenRatio:%String,MDRSum:%Integer,MDRRatio:%String") [ SqlProc ]
{
}

ClassMethod QryMRBResultExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aLocIDs As %String, aBactID As %String, aTypeCode As %String, aDrugLevel As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	 
    Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom>aDateTo) $$$OK
 	Set:aDateFrom>+$h aDateFrom=+$h
 	Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	
    Set NIndex="QryMRBResult"
	Kill ^TMP($zn,$j,NIndex)
	//是否去重：-0：不去重，1：去重
	Set IsUnRepeat=##class(DHCHAI.BT.Config).GetValByCode("IsUnRepeat")
	//去重判断方式-1：保留第一珠菌/多耐,2:保留同标本第一珠菌/多耐
	Set UnRepeatType=##class(DHCHAI.BT.Config).GetValByCode("UnRepeatType")
	
    //送检日期
    If aDateType=1{
	    Set xItemID=""
		For {
			Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID))
			Quit:xItemID=""
			Set ItemData=$g(^DHCHAI.IR.CCItmMastD(xItemID))
			Continue:ItemData=""
			Set ItemCode = $li(ItemData,2)
			Continue:(ItemCode'="LAB-Bacteria")&(ItemCode'="LAB-TestAb")
			
			Set xDate=aDateFrom-1
			For {
				Set xDate=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID,xDate))
				Quit:xDate=""
				Quit:(xDate>aDateTo)
				
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID,xDate,xID))
					Quit:xID=""
					
					Do BuildMRBData
				}
			}
		}
	} Else { //报告日期
		Set xItemID=""
		For {
			Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID))
			Quit:xItemID=""
			
			Set ItemData=$g(^DHCHAI.IR.CCItmMastD(xItemID))
			Continue:ItemData=""
			Set ItemCode = $li(ItemData,2)
			Continue:(ItemCode'="LAB-Bacteria")&(ItemCode'="LAB-TestAb")  //检验-常规检验异常;检验-检出菌
			
			Set xDate=aDateFrom-1
			For {
				Set xDate=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID,xDate))
				Quit:xDate=""
				Quit:(xDate>aDateTo)
				
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID,xDate,xID))
					Quit:xID=""
					
					Do BuildMRBData
				}
			}
		}
	}
	// 耐药率排序
	Set xAnt=""
	For {
		Set xAnt=$o(^TMP($zn,$j,NIndex,"AntDesc",xAnt))
		Quit:xAnt=""
		Set AntDesc = xAnt
		Set MDRSum  =+$g(^TMP($zn,$j,NIndex,"AntDesc",AntDesc,"耐药")) // 耐药数
		Set ZJCSum  =+$g(^TMP($zn,$j,NIndex,"AntDesc",AntDesc,"中介")) // 中介数
		Set SenSum  =+$g(^TMP($zn,$j,NIndex,"AntDesc",AntDesc,"敏感")) // 敏感数
		Set AntSum = MDRSum+ZJCSum+SenSum
		Set MDRRatio="0.00%",SenRatio="0.00%"
		Set:AntSum>0 MDRRatio=$fn(((MDRSum+ZJCSum)/AntSum)*100,"",2)_"%" 	//耐药率
		Set:AntSum>0 SenRatio=$fn((SenSum/AntSum)*100,"",2)_"%" 	        //敏感率
		Set AntMDRRatio=0
		Set:AntSum>0 AntMDRRatio=(MDRSum+ZJCSum)/AntSum
		
		If (AntMDRRatio>0.75){
			Set DrugLevel=1
		}ElseIf (AntMDRRatio>0.5){
			Set DrugLevel=2
		}ElseIf (AntMDRRatio>0.4){
			Set DrugLevel=3
		}ElseIf (AntMDRRatio>0.3){
			Set DrugLevel=4
		}Else{
			Set DrugLevel=5
		}
		Set AntMDRRatio=AntMDRRatio*100
		Set ^TMP($zn,$j,NIndex,"MDRRatio",AntMDRRatio,AntDesc)=$lb(DrugLevel,AntDesc,AntSum,ZJCSum,SenSum,SenRatio,MDRSum,MDRRatio)
	}
	// 输出
	Set xLevel=""
	For {
		Set xLevel=$o(^TMP($zn,$j,NIndex,"MDRRatio",xLevel),-1)
		Quit:xLevel=""
		Set xAnt=""
		For {
			Set xAnt=$o(^TMP($zn,$j,NIndex,"MDRRatio",xLevel,xAnt))
			Quit:xAnt=""
			Set Data=$g(^TMP($zn,$j,NIndex,"MDRRatio",xLevel,xAnt))
			Continue:Data=""
			
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
BuildMRBData
	Set RstData = $g(^DHCHAI.IR.CCResultD(xID))
	Quit:RstData=""
	//过滤无效数据
	Quit:$lg(RstData,14)'=1
	//过滤耐药级别(耐药or敏感)-->aDrugLevel	
	Set MRBTpDr = $li(RstData,24)		//多耐类型-1
	Set MRBTp2Dr=$lg(RstData,31)		//多耐类型-2
	If (aDrugLevel="1"){	//耐药
		Quit:(MRBTpDr="")&&(MRBTp2Dr="")
	}ElseIf (aDrugLevel="2"){	//敏感
		Quit:(MRBTpDr'="")||(MRBTp2Dr'="")
	}
	//过滤院区-->aHospIDs
	Set AdmID = $li(RstData,2)
	Set ActDate=$lg(RstData,8)			//送检日期		
	Set ActTime=$lg(RstData,9)			//送检时间
	Set RepDate =$lg(RstData,11)		//报告日期
	Set RepTime =$lg(RstData,12)		//报告时间
	If (aDateType=1){	//送检科室
		Set TransInfo  = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(AdmID,ActDate,ActTime)
		Set ActLocID = $p(TransInfo,"^",1)
		Quit:ActLocID=""
		Set ActWardID = $p(TransInfo,"^",2)
		//过滤科室-->aLocIDs
  		Quit:(aLocIDs'="")&((","_aLocIDs_",")'[(","_ActLocID_","))&((","_aLocIDs_",")'[(","_ActWardID_","))	
		
		Set ActLocData  = $g(^DHCHAI.BT.LocationD(ActLocID))
		Set HospID = $li(ActLocData,8)
	}					
	else{				//报告科室
		Set TransInfo  = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(AdmID,RepDate,RepTime)
		Set RepLocID = $p(TransInfo,"^",1)
		Quit:RepLocID=""
		Set RepWardID = $p(TransInfo,"^",2)
		//过滤科室-->aLocIDs
  		Quit:(aLocIDs'="")&((","_aLocIDs_",")'[(","_RepLocID_","))&((","_aLocIDs_",")'[(","_RepWardID_","))	
  		
  		Set RepLocData  = $g(^DHCHAI.BT.LocationD(RepLocID))
		Set HospID = $li(RepLocData,8)
	}
	Quit:(aHospIDs'="")&&($listfind(aHospIDs,HospID)<1) 	//医院过滤
	//过滤感染类型-->aTypeCode
	Set ResultID =$p( $li(RstData,19),"=",2)  		//检验结果ID：DHCHAI.DP.LabVisitRepResult
	Quit:ResultID=""
	Set RepRstData=$g(^DHCHAI.DP.LabVisitRepResultD(ResultID))
	Quit:RepRstData=""
	Set MakeInfType=$lg(RepRstData,13)
	Quit:(aTypeCode'="")&&(aTypeCode'=MakeInfType)  // 过滤感染类型	
	//过滤细菌-->aBactID
	Set (BacID,BacDesc)=""			//细菌名称(标准名)
	Set SCode = $li(RstData,17)   	//子系统代码
	Set Bacteria = $li(RstData,23)   				//原始细菌名称
	Set Bacteria=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Bacteria)  //去掉特殊字符
	Quit:Bacteria=""
	Set MapItemDr=$o(^DHCHAI.DP.LabBactMapI("IndexSCodeBacteria",SCode,Bacteria,""))
	If MapItemDr'="" {
		Set BactMapData=$g(^DHCHAI.DP.LabBactMapD(MapItemDr))
		If BactMapData'=""{
			Set IsActive = $li(BactMapData,7)
			Quit:IsActive'=1
			Set BacID=$li(BactMapData,3)
			If (BacID'=""){
				Set LabBacteriaData=$g(^DHCHAI.DP.LabBacteriaD(BacID))
				Set:LabBacteriaData'="" BacDesc=$li(LabBacteriaData,3)
			}
		}
	}
	Quit:BacDesc="" 	// 过滤未对照细菌
	Quit:(aBactID'="")&&(BacID'=aBactID)  			// 过滤细菌
	//去重
	If (IsUnRepeat="1"){
		Set UnBact="1"					//细菌
		Set:aDrugLevel="1" UnBact="2"	//多耐
		
		Set IsFirstSend=##Class(DHCHAI.STATV2.S040MRBInf).IsFirstSend(AdmID,xID,UnRepeatType,UnBact)
		Quit:IsFirstSend'=1
	}
	//查询药敏
	Set xSenID = ""
	For {
    	Set xSenID =$o(^DHCHAI.DP.LabVisitRepRstSenI("IndexLabResultDr",ResultID,xSenID))
    	Quit:xSenID=""
		Set SenData=$g(^DHCHAI.DP.LabVisitRepRstSenD(xSenID))
		Continue:SenData=""
	    
		Set AntCode     = $li(SenData,3)
		Set AntDesc     = $li(SenData,4)
		Set Sensitivity = $li(SenData,5)
		//药敏需要获取标准药敏字典，未对照的不统计
		Set MapSenInfo = ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"LABTestRstSen",Sensitivity)
        Continue:MapSenInfo=""
        Set SenDicDesc = $p(MapSenInfo,"^",3)
        Set:SenDicDesc="SDD" SenDicDesc="敏感"
        Set num=$i(^TMP($zn,$j,NIndex,"AntDesc",AntDesc,SenDicDesc))  
	}
	Quit
}

ClassMethod QryMRBResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBResultExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryMRBResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBResultExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhoubo
/// CreatDate：   2020-11-12
/// Description:  病原体耐药明细
/// Table：       DHCHAI.IR.CCResult
/// Input:        aHospIDs   : 多个医院用"|"连接
///               aDateType  : 日期类型 1：送检日期
/// 			  aDateFrom  ：开始日期
/// 			  aDateTo    : 结束日期
/// 			  aLocType   : 科室类型
///               aLocIDs    : 科室/病区ID
///               aBactID    : 细菌字典ID
///               aStatLevel ：1：总数2:敏感3：中介4：耐药
/// 			  aAntDesc   ：抗菌药
/// 			  aTypeCode  : 感染类型
///               aDrugLevel : 耐药级别 1：多耐菌 2：敏感
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.BactDrugfast","QryMRBResultDtl","1","1","2020-01-01","2020-05-12","W","","","1","","","")
Query QryMRBResultDtl(aHospIDs As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aLocIDs As %String, aBactID As %String, aStatLevel As %String, aAntDesc As %String, aTypeCode As %String, aDrugLevel As %String) As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DishLocDesc:%String,DishWardDesc:%String,TransID:%String,GroupID:%String,GroupDesc:%String,LocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,ResID:%String,LabEpisodeNo:%String,LabTestSet:%String,ActDateTime:%String,RepDateTime:%String,MRBDesc:%String,SpeDesc:%String,BacDesc:%String,InfType:%String,RstSenID:%String,AntDesc:%String,SenDicDesc:%String") [ SqlProc ]
{
}

ClassMethod QryMRBResultDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aLocIDs As %String, aBactID As %String, aStatLevel As %String, aAntDesc As %String, aTypeCode As %String, aDrugLevel As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    
    Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom>aDateTo) $$$OK
 	Set:aDateFrom>+$h aDateFrom=+$h
 	Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
   
    Set NIndex="QryMRBResult"
	Kill ^TMP($zn,$j,NIndex)
	//是否去重：-0：不去重，1：去重
	Set IsUnRepeat=##class(DHCHAI.BT.Config).GetValByCode("IsUnRepeat")
	//去重判断方式-1：保留第一珠菌/多耐,2:保留同标本第一珠菌/多耐
	Set UnRepeatType=##class(DHCHAI.BT.Config).GetValByCode("UnRepeatType")
	
    //送检日期
    If aDateType=1{
	    Set xItemID=""
		For {
			Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID))
			Quit:xItemID=""
			Set ItemData=$g(^DHCHAI.IR.CCItmMastD(xItemID))
			Continue:ItemData=""
			Set ItemCode = $li(ItemData,2)
			Continue:(ItemCode'="LAB-Bacteria")&(ItemCode'="LAB-TestAb")
			
			Set xDate=aDateFrom-1
			For {
				Set xDate=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID,xDate))
				Quit:xDate=""
				Quit:(xDate>aDateTo)
				
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID,xDate,xID))
					Quit:xID=""
					
					Do BuildMRBDtlData
				}
			}
		}
	} Else { //报告日期
		Set xItemID=""
		For {
			Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID))
			Quit:xItemID=""
			
			Set ItemData=$g(^DHCHAI.IR.CCItmMastD(xItemID))
			Continue:ItemData=""
			Set ItemCode = $li(ItemData,2)
			Continue:(ItemCode'="LAB-Bacteria")&(ItemCode'="LAB-TestAb")  //检验-常规检验异常;检验-检出菌
			
			Set xDate=aDateFrom-1
			For {
				Set xDate=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID,xDate))
				Quit:xDate=""
				Quit:(xDate>aDateTo)
				
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID,xDate,xID))
					Quit:xID=""
					
					Do BuildMRBDtlData
				}
			}
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
BuildMRBDtlData
	Set RstData = $g(^DHCHAI.IR.CCResultD(xID))
	Quit:RstData=""
	//过滤无效数据
	Quit:$li(RstData,14)'=1
	//过滤耐药级别(耐药or敏感)-->aDrugLevel	
	Set MRBTpDr = $li(RstData,24)		//多耐类型-1
	Set MRBTp2Dr=$lg(RstData,31)		//多耐类型-2
	If (aDrugLevel="1"){	//耐药
		Quit:(MRBTpDr="")&&(MRBTp2Dr="")
	}ElseIf (aDrugLevel="2"){	//敏感
		Quit:(MRBTpDr'="")||(MRBTp2Dr'="")
	}
	//过滤院区-->aHospIDs
	Set AdmID = $li(RstData,2)
	Set ActDate=$lg(RstData,8)			//送检日期		
	Set ActTime=$lg(RstData,9)			//送检时间
	Set RepDate =$lg(RstData,11)		//报告日期
	Set RepTime =$lg(RstData,12)		//报告时间
	If (aDateType=1){	//送检科室
		Set TransInfo  = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(AdmID,ActDate,ActTime)
		Set ActLocID = $p(TransInfo,"^",1)
		Quit:ActLocID=""
		Set ActWardID = $p(TransInfo,"^",2)
		//过滤科室-->aLocIDs
  		Quit:(aLocIDs'="")&((","_aLocIDs_",")'[(","_ActLocID_","))&((","_aLocIDs_",")'[(","_ActWardID_","))	
		
		Set ActLocData  = $g(^DHCHAI.BT.LocationD(ActLocID))
		Set HospID = $li(ActLocData,8)
		//取转科信息
		Set TransInfo=..GetLocInfoByDate(AdmID,aLocType,ActDate,ActTime)
	}					
	else{				//报告科室
		Set TransInfo  = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(AdmID,RepDate,RepTime)
		Set RepLocID = $p(TransInfo,"^",1)
		Quit:RepLocID=""
		Set RepWardID = $p(TransInfo,"^",2)
		//过滤科室-->aLocIDs
  		Quit:(aLocIDs'="")&((","_aLocIDs_",")'[(","_RepLocID_","))&((","_aLocIDs_",")'[(","_RepWardID_","))	
  		
  		Set RepLocData  = $g(^DHCHAI.BT.LocationD(RepLocID))
		Set HospID = $li(RepLocData,8)
		//取转科信息
		Set TransInfo=..GetLocInfoByDate(AdmID,aLocType,RepDate,RepTime)
	}
	Quit:(aHospIDs'="")&&($listfind(aHospIDs,HospID)<1) 	//医院过滤
	//过滤感染类型-->aTypeCode
	Set ResultID =$p( $li(RstData,19),"=",2)  		//检验结果ID：DHCHAI.DP.LabVisitRepResult
	Quit:ResultID=""
	Set RepRstData=$g(^DHCHAI.DP.LabVisitRepResultD(ResultID))
	Quit:RepRstData=""
	Set MakeInfType=$lg(RepRstData,13)
	Quit:(aTypeCode'="")&&(aTypeCode'=MakeInfType)  // 过滤感染类型	
	//过滤细菌-->aBactID
	Set (BacID,BacDesc)=""			//细菌名称(标准名)
	Set SCode = $li(RstData,17)   	//子系统代码
	Set Bacteria = $li(RstData,23)   				//原始细菌名称
	Set Bacteria=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Bacteria)  //去掉特殊字符
	Quit:Bacteria=""
	Set MapItemDr=$o(^DHCHAI.DP.LabBactMapI("IndexSCodeBacteria",SCode,Bacteria,""))
	If MapItemDr'="" {
		Set BactMapData=$g(^DHCHAI.DP.LabBactMapD(MapItemDr))
		If BactMapData'=""{
			Set IsActive = $li(BactMapData,7)
			Quit:IsActive'=1
			Set BacID=$li(BactMapData,3)
			If (BacID'=""){
				Set LabBacteriaData=$g(^DHCHAI.DP.LabBacteriaD(BacID))
				Set:LabBacteriaData'="" BacDesc=$li(LabBacteriaData,3)
			}
		}
	}
	Quit:BacDesc="" 	// 过滤未对照细菌
	Quit:(aBactID'="")&&(BacID'=aBactID)  			// 过滤细菌
	
	//送检标本号
	Set LabReportID     = $lg(RepRstData,2)			//检验报告		
	Set LabReportData   = $g(^DHCHAI.DP.LabVisitReportD(LabReportID))
	Quit:LabReportData=""			
	Set LabVisitID  	= $lg(LabReportData,2)		//检验标本
	Set LabVisitData   	= $g(^DHCHAI.DP.LabVisitNumberD(LabVisitID))
	Quit:LabVisitData=""	
	Set LabEpisodeNo	= $lg(LabVisitData,3)		//标本号
	//检验医嘱
	Set LabTestSet=""	
	Set LabTestSetID	= $lg(LabReportData,13)		//指向检验医嘱
	If (LabTestSetID'=""){
		Set LabTestSet=$lg($g(^DHCHAI.DP.LabVisitTestSetD(LabTestSetID)),3)
	}
	//采样时间(日期+时间)
	Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
	Set:ActTime'="" ActTime=$zt(ActTime,1)
	Set ActDateTime=ActDate_" "_ActTime
	//报告时间(日期+时间)
	Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
	Set:RepTime'="" RepTime=$zt(RepTime,1)
	Set RepDateTime=RepDate_" "_RepTime
	//耐药级别
	Set (MRBID,MRBCode,MRBDesc,MRB2ID,MRB2Code,MRB2Desc)=""
	Set MRBTpDr=$lg(RstData,24)			//多耐类型-1
	If (MRBTpDr) {
		Set MRBInfo=$g(^DHCHAI.IR.CRuleMRBD(MRBTpDr))
		Set MRBID    = MRBTpDr
		Set MRBDesc  = $lg(MRBInfo,3)
		Set MRBCode  = $lg(MRBInfo,2)
	}
	Set MRBTp2Dr=$lg(RstData,31)		//多耐类型-2
	If (MRBTp2Dr) {
		Set MRB2Info=$g(^DHCHAI.IR.CRuleMRBD(MRBTp2Dr))
		Set MRB2ID    = MRBTp2Dr
		Set MRB2Desc  = $lg(MRB2Info,3)
		Set MRB2Code  = $lg(MRB2Info,2)
	}
	Set:MRB2Desc'="" MRBDesc=MRBDesc_","_MRB2Desc		//合并
	//标本
	Set (SpeID,SpeDesc)=""			//标本名称(标准名)
	Set Specimen = $lg(RstData,22)	//原始标本名称
	Set SpeMapID = $o(^DHCHAI.DP.LabSpecMapI("IndexSCodeSpecDesc",SCode,Specimen,0))
	If (SpeMapID'="") {
		Set SpecMapData = $g(^DHCHAI.DP.LabSpecMapD(SpeMapID))
		Set MapItemDr = $lg(SpecMapData,3)
		If (MapItemDr'="") {
			Set SpeID=MapItemDr
			Set SpecData=$g(^DHCHAI.DP.LabSpecimenD(MapItemDr))
			Set:SpecData'="" SpeDesc = $lg(SpecData,3)		//标本名称(对照后)
		}
	}
	Set:SpeDesc="" SpeDesc=Specimen		//未对照取原始标本名称
	//感染类型
	Set InfType=""
	Set:MakeInfType="1" InfType="HA(院内感染)"
	Set:MakeInfType="2" InfType="CA(社区感染)"
	Set:MakeInfType="3" InfType="定植"
	Set:MakeInfType="4" InfType="污染"
	Set:MakeInfType="5" InfType="HA重复"
	Set:MakeInfType="6" InfType="CA重复"
	Set:MakeInfType="7" InfType="定植重复"
	//去重
	If (IsUnRepeat="1"){
		Set UnBact="1"					//细菌
		Set:aDrugLevel="1" UnBact="2"	//多耐
		
		Set IsFirstSend=##Class(DHCHAI.STATV2.S040MRBInf).IsFirstSend(AdmID,xID,UnRepeatType,UnBact)
		Quit:IsFirstSend'=1
	}
	//输出1-患者基本信息
	Set PatData =..BuildPaadmData(AdmID)
	Quit:PatData=""
	Set AdmData   = $g(^DHCHAI.DP.PAAdmD(AdmID))
	Quit:AdmData=""
	Set AdmTimes = $lg(AdmData,38)   	//就诊次数
	//输出2-患者转科信息
	Set TransID		=$p(TransInfo,"^",1)
	Set GroupID		=$p(TransInfo,"^",2)
	Set GroupDesc	=$p(TransInfo,"^",3)
	Set LocID		=$p(TransInfo,"^",4)
	Set LocDesc		=$p(TransInfo,"^",5)
	Set TransDate	= $p(TransInfo,"^",6)
    Set OutLocDate	= $p(TransInfo,"^",7)
	Set TransTime	= $p(TransInfo,"^",8)
	Set OutLocTime	= $p(TransInfo,"^",9)
	//转换转科日期格式
	Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
	Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
	Set:TransTime'="" TransTime=$zt(TransTime)
	Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
	Set TransDateTime =TransDate_" "_TransTime
	Set OutLocDateTime =OutLocDate_" "_OutLocTime
					
	Set TransInfo=$lb(TransID,GroupID,GroupDesc,LocID,LocDesc,TransDateTime,OutLocDateTime)
	//输出3-患者送检信息
	Set LabInfo=$lb(xID,LabEpisodeNo,LabTestSet,ActDateTime,RepDateTime,MRBDesc,SpeDesc,BacDesc,InfType)
	
	//查询药敏
	Set xSenID = ""
	For {
    	Set xSenID =$o(^DHCHAI.DP.LabVisitRepRstSenI("IndexLabResultDr",ResultID,xSenID))
    	Quit:xSenID=""
    	
		Set SenData=$g(^DHCHAI.DP.LabVisitRepRstSenD(xSenID))
		Continue:SenData=""
	    
		Set AntCode     = $li(SenData,3)			//抗菌药代码
		Set AntDesc     = $li(SenData,4)			//抗菌药名称
		//过滤抗菌药名称-->aAntDesc
		Continue:(aAntDesc'="")&&(aAntDesc'=AntDesc)
		
		Set Sensitivity = $li(SenData,5)			//药敏结果
		Set MapSenInfo = ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"LABTestRstSen",Sensitivity)	
        Continue:MapSenInfo=""		//取标准名,未对照的不统计
		Set SenDicDesc = $p(MapSenInfo,"^",3)		//药敏结果(标准名)
		//过滤药敏结果-->aStatLevel(1:总数,2:敏感,3:中介,4:耐药)
		Continue:(aStatLevel=2)&&(SenDicDesc'="敏感")  
        Continue:(aStatLevel=3)&&(SenDicDesc'="中介")  
        Continue:(aStatLevel=4)&&(SenDicDesc'="耐药")  
		
		Set Data = $lb(BacDesc,AdmTimes)_PatData_TransInfo_LabInfo_$lb(RstSenID,AntDesc,SenDicDesc)
		
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1 
	}
	Quit
}

ClassMethod QryMRBResultDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBResultDtlExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryMRBResultDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBResultDtlExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     chenjb
/// CreatDate：   2022-03-17
/// Description:  取细菌描述
///               aBactID    : 细菌字典ID
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.BactDrugfast","QryBactByIDForFast","")
Query QryBactByIDForFast(aBactID As %String) As %Query(ROWSPEC = "BactID:%String,BactDesc:%String") [ SqlProc ]
{
}

ClassMethod QryBactByIDForFastExecute(ByRef qHandle As %Binary, aBactID As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
    
    Set aRstBact = "" 	
	If (aBactID'=""){
		Set rstBactData=$g(^DHCHAI.DP.LabBacteriaD(aBactID))
		Set:rstBactData'="" aRstBact=$li(rstBactData,3)
	}
	Set ^CacheTemp(repid,ind)=$lb(aBactID,aRstBact)
	Set ind=ind+1
	
	Quit $$$OK
}

ClassMethod QryBactByIDForFastClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBactByIDForFastExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryBactByIDForFastFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBactByIDForFastExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     ShenC
/// CreatDate：   2022-12-05
/// Description:  根据日期时间点，获取某日患者当前转科基本信息
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input：       aEpisodeDr : 就诊号
/// 				  aLocType：病区or科室
///               aDate : 日期
///               aTime : 时间
/// Return：      返回%String
/// w ##class(DHCHAI.STATV2.BactDrugfast).GetLocInfoByDate("638","W","2018-04-11","")
ClassMethod GetLocInfoByDate(aEpisodeDr As %String, aLocType As %String, aDate As %String, aTime As %String = "") As %String
{
	New (aEpisodeDr,aLocType,aDate,aTime)
	Set return=""
	Quit:(aEpisodeDr="")||(aLocType="")||(aDate="") return
	
	Set aDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDate)
	Set:aTime[":" aTime=$zth(aTime,1)
	Set:aTime="" aTime=$zth("00:00:01",1) 		//默认时间点改为00:00:01
	
	//初始化基本信息
	Set TransLocInfo=""
	
	Set xDate=aDate+1
	For {
		Set xDate=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisTransDateTime",aLocType,aEpisodeDr,xDate),-1)
		Quit:xDate=""
		Quit:TransLocInfo'=""
		
		Set xTime=$s(xDate=aDate:(+aTime+1),1:"")
		For {
			Set xTime=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisTransDateTime",aLocType,aEpisodeDr,xDate,xTime),-1)
			Quit:xTime=""
			Quit:TransLocInfo'=""
			
			Set xTransID=""
			For {
				Set xTransID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisTransDateTime",aLocType,aEpisodeDr,xDate,xTime,xTransID),-1)
				Quit:xTransID=""
				Quit:TransLocInfo'=""
				
				Set TransData=$g(^DHCHAI.DP.PAAdmTransD(xTransID))
				Continue:TransData=""
				Continue:$lg(TransData,5)=""
				
				Set LocID=$lg(TransData,5)
				Set LocData = $g(^DHCHAI.BT.LocationD(LocID))
				Set LocDesc	= $lg(LocData,3)
				Set LocDesc2= $lg(LocData,4)
				Set:LocDesc2'="" LocDesc=LocDesc2		//转科科室or病区
				Set GroupID  = $lg(LocData,7)			//转科科室组
				If GroupID="" {
					Set GroupDesc="其他科"
					Set GroupID=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
				}
				Set GroupData=$g(^DHCHAI.BT.LocGroupD(GroupID))
				Set GroupDesc=$li(GroupData,3)
				
				Set TransDate	= $lg(TransData,7)		//转科日期
			 	Set OutLocDate	= $lg(TransData,10)		//转科时间
				Set TransTime	= $lg(TransData,8)		//出科日期
				Set OutLocTime	= $lg(TransData,11)		//出科时间
					
				Set TransLocInfo=xTransID_"^"_GroupID_"^"_GroupDesc_"^"_LocID_"^"_LocDesc_"^"_TransDate_"^"_OutLocDate_"^"_TransTime_"^"_OutLocTime
			}
		}
	}
	Quit TransLocInfo
}

}
