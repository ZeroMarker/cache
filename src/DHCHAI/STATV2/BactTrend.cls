/// 名称: DHCHAI.STATV2.BactTrend
/// 描述: 病原体耐药性趋势分析
/// 编写者：zhoubo
/// 编写日期: 2020-11-16
Class DHCHAI.STATV2.BactTrend Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2020-11-16
/// Description:  病原体耐药性趋势分析
/// Table：       DHCHAI.IR.CCResult
/// Input:        aHospIDs   : 多个医院用"|"连接
///               aDateType  : 日期类型 1：送检日期
/// 			  aDateFrom  ：开始日期
/// 			  aDateTo    : 结束日期
///               aLocID     : 科室/病区ID
///               aBactID    : 细菌字典ID
///               aDrugLevel : 耐药级别 1：多耐菌 2：敏感
///               aStatUnit  : 统计单位 1：月   2：季度 3：年
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.BactTrend","QryMRBRstTrend","1|2","1","2019-07","2020-11","","278","","1","亚胺培南")
Query QryMRBRstTrend(aHospIDs As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aBactID As %String, aDrugLevel As %String, aStatUnit As %String, aAntDesc As %String, aTypeCode As %String) As %Query(ROWSPEC = "AntDesc:%String,StatName:%String,AntSum:%Integer,ZJCSum:%Integer,SenSum:%Integer,MDRSum:%Integer,StatSum:%Integer,StatRatio:%String") [ SqlProc ]
{
}

ClassMethod QryMRBRstTrendExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aBactID As %String, aDrugLevel As %String, aStatUnit As %String, aAntDesc As %String, aTypeCode As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="")||(aStatUnit="") $$$OK
	If (aStatUnit=3){ //年
		Set aDateFrom = aDateFrom_"-01-01"
		Set aDateTo   = aDateTo_"-12-31"
	}Else{ // 月、季度
		Set aDateFrom = aDateFrom_"-01"
		Set aDateTo   = aDateTo_"-01"
		Set aDateTo   = $zdh(aDateTo,3)
		Set aDateTo   = aDateTo+32
		Set aDateTo   = $zd(aDateTo,3)
		Set aDateTo   = $p(aDateTo,"-",1)_"-"_$p(aDateTo,"-",2)_"-01"
		Set aDateTo   = $zdh(aDateTo,3)-1
		Set aDateTo   = $zd(aDateTo,3)
	}
    Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom>aDateTo) $$$OK
 	Set:aDateFrom>+$h aDateFrom=+$h
 	Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	
 	Set:aLocID'="" aLocID=$tr(aLocID,",","|")
 	Set aLocIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aLocID,"|")
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    Set NIndex="QryMRBRstTrend"
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
				Set StatDate  = xDate
				Set StatDate  = $zd(StatDate,3)
				Set StatYear  = $p(StatDate,"-",1)
				Set StatMonth = $p(StatDate,"-",2)
				If (aStatUnit=1){ // 按月统计
					Set StatName = StatYear_"年"_StatMonth_"月" 
				}ElseIf (aStatUnit=2){ // 按季度统计
					Set StatName = StatYear_"年"_$s((+StatMonth)<4:"一",(+StatMonth)<7:"二",(+StatMonth)<10:"三",1:"四")_"季度"
				}Else {  // 按年统计
					Set StatName = StatYear_"年"
				}
				Set ^TMP($zn,$j,NIndex,"AntDesc",StatName)=""
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID,xDate,xID))
					Quit:xID=""
					
					Do BuildRstTrendData
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
				Set StatDate  = xDate
				Set StatDate  = $zd(StatDate,3)
				Set StatYear  = $p(StatDate,"-",1)
				Set StatMonth = $p(StatDate,"-",2)
				If (aStatUnit=1){ // 按月统计
					Set StatName = StatYear_"年"_StatMonth_"月" 
				}ElseIf (aStatUnit=2){ // 按季度统计
					Set StatName = StatYear_"年"_$s((+StatMonth)<4:"一",(+StatMonth)<7:"二",(+StatMonth)<10:"三",1:"四")_"季度"
				}Else {  // 按年统计
					Set StatName = StatYear_"年"
				}
				Set ^TMP($zn,$j,NIndex,"AntDesc",StatName)=""
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID,xDate,xID))
					Quit:xID=""
					
					Do BuildRstTrendData
				}
			}
		}
	}
	
	// 输出
	Set xName=""
	For {
		Set xName=$o(^TMP($zn,$j,NIndex,"AntDesc",xName))
		Quit:xName=""
		Set StatName = xName
		If ($o(^TMP($zn,$j,NIndex,"AntDesc",StatName,""))=""){
			Set Data=$lb("",StatName,"","","","","","0.00%")
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
		Set xAnt=""
		For {
			Set xAnt=$o(^TMP($zn,$j,NIndex,"AntDesc",StatName,xAnt))
			Quit:xAnt=""
			Set AntDesc = xAnt
			Set MDRDataSums = $g(^TMP($zn,$j,NIndex,"AntDesc",StatName,xAnt))
			
			Set MDRSum  =+$g(^TMP($zn,$j,NIndex,"AntDesc",StatName,xAnt,"耐药")) // 耐药数
			Set ZJCSum  =+$g(^TMP($zn,$j,NIndex,"AntDesc",StatName,xAnt,"中介")) // 中介数
			Set SenSum  =+$g(^TMP($zn,$j,NIndex,"AntDesc",StatName,xAnt,"敏感")) // 敏感数
			
			Set AntSum = MDRSum+ZJCSum+SenSum
			Set MDRRatio="0.00%",SenRatio="0.00%"
			Set:AntSum>0 MDRRatio=$fn(((MDRSum+ZJCSum)/AntSum)*100,"",2)_"%" 	//耐药率
			Set:AntSum>0 SenRatio=$fn((SenSum/AntSum)*100,"",2)_"%" 	        //敏感率
			
			Set StatSum   = (MDRSum+ZJCSum)
			Set StatRatio = MDRRatio  // 耐药率
		
			Set Data=$lb(AntDesc,StatName,AntSum,ZJCSum,SenSum,MDRSum,StatSum,StatRatio)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
		
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
BuildRstTrendData
	Set RstData = $g(^DHCHAI.IR.CCResultD(xID))
	Quit:RstData=""
	Quit:$li(RstData,14)'=1
	Set IsAbFlag = $li(RstData,21)   //异常标志
	//Quit:IsAbFlag'=1 //过滤非耐药菌
	//过滤耐药级别
	Set CCMRBTpDr = $li(RstData,24)  // 是否是多耐菌
	If (aDrugLevel="1"){
		Quit:CCMRBTpDr=""
	}ElseIf (aDrugLevel="2"){
		Quit:CCMRBTpDr'=""
	}
	Set AdmID = $li(RstData,2)
	Set ResultID =$p( $li(RstData,19),"=",2)  //检验结果ID：DHCHAI.DP.LabVisitRepResult
	Quit:ResultID=""
	Set RepRstData=$g(^DHCHAI.DP.LabVisitRepResultD(ResultID))
	Quit:RepRstData=""
	Set MakeInfType=$lg(RepRstData,13)
	Quit:(aTypeCode'="")&&(aTypeCode'=MakeInfType)  // 过滤感染类型
	Set SCode = $li(RstData,17)   //子系统代码
	Set PAadmData=$g(^DHCHAI.DP.PAAdmD(AdmID))
	Quit:PAadmData=""
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
	
	Set Bacteria = $li(RstData,23)   //原始细菌名称
	Set BacDesc=""
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
	Quit:(aBactID'="")&&(BacID'=aBactID)  // 细菌过滤
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
        Continue:(aAntDesc'="")&&(aAntDesc'=AntDesc)
        
        Set num=$i(^TMP($zn,$j,NIndex,"AntDesc",StatName,AntDesc,SenDicDesc))  
	}
	Quit
}

ClassMethod QryMRBRstTrendClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBRstTrendExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryMRBRstTrendFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBRstTrendExecute ]
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

}
