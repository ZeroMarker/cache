/// 名称: DHCHAI.IRS.BactDailySrv
/// 描述: 细菌检出日报相关服务
/// 编写者：pylian
/// 编写日期: 2021-06-01
Class DHCHAI.IRS.BactDailySrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2021-06-01
/// Description:  获取日报条件树
/// Table：       DHCMed.EPD.SuspInfectDic
/// Input：       
/// w ##class(DHCHAI.IRS.BactDailySrv).GetResultTree("1","2021-03-05")
ClassMethod GetResultTree(aHospIDs As %String, aRepDate As %String) As %String
{
	new (aHospIDs,aRepDate)
	Set return="[]"
	
	Set:(aRepDate="") aRepDate=+$h
    Set aRepDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aRepDate) 	
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")

	Set NIndex="GetResultTree"	
	Kill ^TMP($zn,$j,NIndex)
	Set xItemID=""
	For {
		Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID))
		Quit:xItemID=""
		
		Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
		Continue:'$IsObject(objItem)
		Set ItemCode=objItem.CCCode //监控项目代码
		Continue:(ItemCode'="LAB-Bacteria")&(ItemCode'="LAB-TestAb")  //检验-常规检验异常;检验-检出菌
		
		Set xID=""
		For {
			Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID,aRepDate,xID))
			Quit:xID=""
			
			Set RstData = $g(^DHCHAI.IR.CCResultD(xID))
			Continue:RstData=""
			Continue:$lg(RstData,14)'=1
			Set EpisodeDr = $lg(RstData,2)
			Set ActDate   = $lg(RstData,8)
			Set ActTime   = $lg(RstData,9)
			Set Bacteria  = $lg(RstData,23)
			Continue:Bacteria=""
			Set ActLocDr  = $lg(RstData,7)    // 送检科室		
			If (ActLocDr=""){
			 	Set TransInfo  = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,ActDate,ActTime)
				Set ActLocDr = $p(TransInfo,"^",1)
			 }
			Continue:ActLocDr=""
			Set LabLocData  = $g(^DHCHAI.BT.LocationD(ActLocDr))
			Continue:LabLocData=""
			Set HospDr = $lg(LabLocData,8)
			Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1) //医院过滤
			
			Set MRBTypeDr = $lg(RstData,24)
			Set LabResultID=$p($lg(RstData,19),"=",2)
			Set RepRstData = $g(^DHCHAI.DP.LabVisitRepResultD(LabResultID))
			Continue:RepRstData=""
			Set LabReportDr  = $lg(RepRstData,2)
			Continue:LabReportDr=""
			Set InfType      = $lg(RepRstData,13)
		    Set:InfType="" InfType=0
		    
		    Set num=$i(^TMP($zn,$j,NIndex,"InfTypeStat",InfType))   
			If (MRBTypeDr'="") {  //多耐
				Set num=$i(^TMP($zn,$j,NIndex,"MRBTypeStat","R"))   
			}Else {    //非多耐
				Set num=$i(^TMP($zn,$j,NIndex,"MRBTypeStat","S")) 
			}
		}
	}
	
	
	Set TypeRNum = +$g(^TMP($zn,$j,NIndex,"MRBTypeStat","R"))    	//多耐
	Set TypeSNum = +$g(^TMP($zn,$j,NIndex,"MRBTypeStat","S"))    	//非多耐
	Set InfType0 = +$g(^TMP($zn,$j,NIndex,"InfTypeStat",0))   		//未知
	Set InfType1 = +$g(^TMP($zn,$j,NIndex,"InfTypeStat",1))   		//HA(医院感染)
	Set InfType2 = +$g(^TMP($zn,$j,NIndex,"InfTypeStat",2))   		//CA(社区感染)
	Set InfType3 = +$g(^TMP($zn,$j,NIndex,"InfTypeStat",3))   		//定植
	Set InfType4 = +$g(^TMP($zn,$j,NIndex,"InfTypeStat",4))   		//污染
	Set InfType5 = +$g(^TMP($zn,$j,NIndex,"InfTypeStat",5))   		//HA重复
	Set InfType6 = +$g(^TMP($zn,$j,NIndex,"InfTypeStat",6))   		//CA重复
	Set InfType7 = +$g(^TMP($zn,$j,NIndex,"InfTypeStat",7))   		//定植重复
	Set Sum = TypeRNum+TypeSNum
					
	Set treeJson="["
	Set treeJson=treeJson_"{"
	Set treeJson=treeJson_"""id"":"""","
	Set treeJson=treeJson_"""text"":""送检检出（"_Sum_"株）"","
	Set treeJson=treeJson_"""state"":""open"","
	Set treeJson=treeJson_"""children"":[{"
	Set treeJson=treeJson_"""id"":""InfType_0"","
	Set treeJson=treeJson_"""text"":"""_"未知（"_InfType0_"株）"""
	Set treeJson=treeJson_"},{"
    Set treeJson=treeJson_"""id"":""InfType_1"","
	Set treeJson=treeJson_"""text"":"""_"HA(医院感染)（"_InfType1_"株）"""
	Set treeJson=treeJson_"},{"
    Set treeJson=treeJson_"""id"":""InfType_2"","
	Set treeJson=treeJson_"""text"":"""_"CA(社区感染)（"_InfType2_"株）"""
	Set treeJson=treeJson_"},{"
    Set treeJson=treeJson_"""id"":""InfType_3"","
	Set treeJson=treeJson_"""text"":"""_"定植（"_InfType3_"株）"""
	Set treeJson=treeJson_"},{"
    Set treeJson=treeJson_"""id"":""InfType_4"","
	Set treeJson=treeJson_"""text"":"""_"污染（"_InfType4_"株）"""
	Set treeJson=treeJson_"},{"
    Set treeJson=treeJson_"""id"":""InfType_5"","
	Set treeJson=treeJson_"""text"":"""_"HA重复（"_InfType5_"株）"""
	Set treeJson=treeJson_"},{"
    Set treeJson=treeJson_"""id"":""InfType_6"","
	Set treeJson=treeJson_"""text"":"""_"CA重复（"_InfType6_"株）"""
	Set treeJson=treeJson_"},{"
    Set treeJson=treeJson_"""id"":""InfType_7"","
	Set treeJson=treeJson_"""text"":"""_"定植重复（"_InfType7_"株）"""
	Set treeJson=treeJson_"}]"
	Set treeJson=treeJson_"},{"
	Set treeJson=treeJson_"""id"":"""","
	Set treeJson=treeJson_"""text"":""耐药级别（"_Sum_"株）"","
	Set treeJson=treeJson_"""state"":""open"","
	Set treeJson=treeJson_"""children"":[{"
	Set treeJson=treeJson_"""id"":""MRBType_R"","
	Set treeJson=treeJson_"""text"":"""_"多耐（"_TypeRNum_"株）"""
	Set treeJson=treeJson_"},{"
    Set treeJson=treeJson_"""id"":""MRBType_S"","
	Set treeJson=treeJson_"""text"":"""_"敏感（"_TypeSNum_"株）"""
	Set treeJson=treeJson_"}]"
	Set treeJson=treeJson_"}]"
	
 	Set return=treeJson
 	
 	Kill ^TMP($zn,$j,NIndex)
 	Quit return
}

/// Creator：     pylian
/// CreatDate：   2021-06-01
/// Description:  获取日报条件树
/// Table：       DHCMed.EPD.SuspInfectDic
/// Input：       
/// w ##class(DHCHAI.IRS.BactDailySrv).GetTreeData("1","2021-03-05")
ClassMethod GetTreeData(aHospIDs As %String, aRepDate As %String) As %String
{
	new (aHospIDs,aRepDate)
	Set return=""
	
	Set:(aRepDate="") aRepDate=+$h
    Set aRepDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aRepDate) 	
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")

	Set NIndex="GetResultTree"	
	Kill ^TMP($zn,$j,NIndex)
	Set xItemID=""
	For {
		Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID))
		Quit:xItemID=""
		
		Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
		Continue:'$IsObject(objItem)
		Set ItemCode=objItem.CCCode //监控项目代码
		Continue:(ItemCode'="LAB-Bacteria")&(ItemCode'="LAB-TestAb")  //检验-常规检验异常;检验-检出菌
		
		Set xID=""
		For {
			Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID,aRepDate,xID))
			Quit:xID=""
			
			Set RstData = $g(^DHCHAI.IR.CCResultD(xID))
			Continue:RstData=""
			Continue:$lg(RstData,14)'=1
			Set EpisodeDr = $lg(RstData,2)
			Set ActDate   = $lg(RstData,8)
			Set ActTime   = $lg(RstData,9)
			Set Bacteria  = $lg(RstData,23)
			Continue:Bacteria=""
			Set ActLocDr  = $lg(RstData,7)    // 送检科室		
			If (ActLocDr=""){
			 	Set TransInfo  = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,ActDate,ActTime)
				Set ActLocDr = $p(TransInfo,"^",1)
			 }
			Continue:ActLocDr=""
			Set LabLocData  = $g(^DHCHAI.BT.LocationD(ActLocDr))
			Continue:LabLocData=""
			Set HospDr = $lg(LabLocData,8)
			Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1) //医院过滤
			
			Set MRBTypeDr = $lg(RstData,24)
			Set LabResultID=$p($lg(RstData,19),"=",2)
			Set RepRstData = $g(^DHCHAI.DP.LabVisitRepResultD(LabResultID))
			Continue:RepRstData=""
			Set LabReportDr  = $lg(RepRstData,2)
			Continue:LabReportDr=""
			Set InfType      = $lg(RepRstData,13)
		    Set:InfType="" InfType=0
		    
		    Set num=$i(^TMP($zn,$j,NIndex,"InfTypeStat",InfType))   
			If (MRBTypeDr'="") {  //多耐
				Set num=$i(^TMP($zn,$j,NIndex,"MRBTypeStat","R"))   
			}Else {    //非多耐
				Set num=$i(^TMP($zn,$j,NIndex,"MRBTypeStat","S")) 
			}
		}
	}
	
	
	Set TypeRNum = +$g(^TMP($zn,$j,NIndex,"MRBTypeStat","R"))    	//多耐
	Set TypeSNum = +$g(^TMP($zn,$j,NIndex,"MRBTypeStat","S"))    	//非多耐
	Set InfType0 = +$g(^TMP($zn,$j,NIndex,"InfTypeStat",0))   		//未知
	Set InfType1 = +$g(^TMP($zn,$j,NIndex,"InfTypeStat",1))   		//HA(医院感染)
	Set InfType2 = +$g(^TMP($zn,$j,NIndex,"InfTypeStat",2))   		//CA(社区感染)
	Set InfType3 = +$g(^TMP($zn,$j,NIndex,"InfTypeStat",3))   		//定植
	Set InfType4 = +$g(^TMP($zn,$j,NIndex,"InfTypeStat",4))   		//污染
	Set InfType5 = +$g(^TMP($zn,$j,NIndex,"InfTypeStat",5))   		//HA重复
	Set InfType6 = +$g(^TMP($zn,$j,NIndex,"InfTypeStat",6))   		//CA重复
	Set InfType7 = +$g(^TMP($zn,$j,NIndex,"InfTypeStat",7))   		//定植重复
	Set Sum = TypeRNum+TypeSNum
	
 	Set return=InfType0_"^"_InfType1_"^"_InfType2_"^"_InfType3_"^"_InfType4_"^"_InfType5_"^"_InfType6_"^"_InfType7_"^"_TypeSNum_"^"_TypeRNum_"^"_Sum
 	
 	Kill ^TMP($zn,$j,NIndex)
 	Quit return
}

/// Creator：     pylian
/// CreatDate：   2021-06-01
/// Description:  获取日报条件树
/// Table：       DHCMed.EPD.SuspInfectDic
/// Input：       
/// w ##class(DHCHAI.IRS.BactDailySrv).ResultTree("1","2021-03-05")
ClassMethod ResultTree() As %String
{
	Set return="[]"
	
	Set treeJson="["
	Set treeJson=treeJson_"{"
	Set treeJson=treeJson_"""id"":""root_1"","
	Set treeJson=treeJson_"""text"":""送检检出（"_"<span id='InfSum'></span>"_"株）"","
	Set treeJson=treeJson_"""state"":""open"","
	Set treeJson=treeJson_"""children"":[{"
	Set treeJson=treeJson_"""id"":""InfType_0"","
	Set treeJson=treeJson_"""text"":"""_"未知（"_"<span id='InfType0'></span>"_"株）"""
	Set treeJson=treeJson_"},{"
    Set treeJson=treeJson_"""id"":""InfType_1"","
	Set treeJson=treeJson_"""text"":"""_"HA(医院感染)（"_"<span id='InfType1'></span>"_"株）"""
	Set treeJson=treeJson_"},{"
    Set treeJson=treeJson_"""id"":""InfType_2"","
	Set treeJson=treeJson_"""text"":"""_"CA(社区感染)（"_"<span id='InfType2'></span>"_"株）"""
	Set treeJson=treeJson_"},{"
    Set treeJson=treeJson_"""id"":""InfType_3"","
	Set treeJson=treeJson_"""text"":"""_"定植（"_"<span id='InfType3'></span>"_"株）"""
	Set treeJson=treeJson_"},{"
    Set treeJson=treeJson_"""id"":""InfType_4"","
	Set treeJson=treeJson_"""text"":"""_"污染（"_"<span id='InfType4'></span>"_"株）"""
	Set treeJson=treeJson_"},{"
    Set treeJson=treeJson_"""id"":""InfType_5"","
	Set treeJson=treeJson_"""text"":"""_"HA重复（"_"<span id='InfType5'></span>"_"株）"""
	Set treeJson=treeJson_"},{"
    Set treeJson=treeJson_"""id"":""InfType_6"","
	Set treeJson=treeJson_"""text"":"""_"CA重复（"_"<span id='InfType6'></span>"_"株）"""
	Set treeJson=treeJson_"},{"
    Set treeJson=treeJson_"""id"":""InfType_7"","
	Set treeJson=treeJson_"""text"":"""_"定植重复（"_"<span id='InfType7'></span>"_"株）"""
	Set treeJson=treeJson_"}]"
	Set treeJson=treeJson_"},{"
	Set treeJson=treeJson_"""id"":""root_2"","
	Set treeJson=treeJson_"""text"":""耐药级别（"_"<span id='TypeSum'></span>"_"株）"","
	Set treeJson=treeJson_"""state"":""open"","
	Set treeJson=treeJson_"""children"":[{"
	Set treeJson=treeJson_"""id"":""MRBType_R"","
	Set treeJson=treeJson_"""text"":"""_"多耐（"_"<span id='TypeRNum'></span>"_"株）"""
	Set treeJson=treeJson_"},{"
    Set treeJson=treeJson_"""id"":""MRBType_S"","
	Set treeJson=treeJson_"""text"":"""_"敏感（"_"<span id='TypeSNum'></span>"_"株）"""
	Set treeJson=treeJson_"}]"
	Set treeJson=treeJson_"}]"
	
 	Set return=treeJson
 	Quit return
}

/// Creator：     pylian
/// CreatDate：   2021-06-01
/// Description:  查询细菌每日检出情况
/// Table：       DHCHAI.IR.CCResult
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.BactDailySrv","QryDailyResult","1","2021-03-05","","")
Query QryDailyResult(aHospIDs As %String, aRepDate As %String, aInfType As %String = "", aMRBType As %String = "") As %Query(ROWSPEC = "ID:%String,EpisodeDr:%String,EpisodeID:%String,PatientID:%String,MrNo:%String,PapmiNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,AdmBed:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmDate:%String,AdmTime:%String,DischDate:%String,DischTime:%String,LabVisitNumberID:%String,LabReportID:%String,LabResultID:%String,ActLocDr:%String,LabLocDesc:%String,LabWardDr:%String,LabWardDesc:%String,RecDate:%String,RecTime:%String,RepDate:%String,RepTime:%String,Specimen:%String,Bacteria:%String,MRBDesc:%String,InfType:%String,InfTypeDesc:%String") [ SqlProc ]
{
}

ClassMethod QryDailyResultExecute(ByRef qHandle As %Binary, aHospIDs As %String, aRepDate As %String, aInfType As %String = "", aMRBType As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aRepDate="") $$$OK
    Set aRepDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aRepDate) 	
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    
	Set xItemID=""
	For {
		Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID))
		Quit:xItemID=""
		
		Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
		Continue:'$IsObject(objItem)
		Set ItemCode=objItem.CCCode //监控项目代码
		Continue:(ItemCode'="LAB-Bacteria")&(ItemCode'="LAB-TestAb")  //检验-常规检验异常;检验-检出菌
		
		Set xID=""
		For {
			Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID,aRepDate,xID))
			Quit:xID=""
			
			Set RstData = $g(^DHCHAI.IR.CCResultD(xID))
			Continue:RstData=""
			Continue:$lg(RstData,14)'=1
			Set EpisodeDr = $lg(RstData,2)
			Set ActDate   = $lg(RstData,8)
			Set ActTime   = $lg(RstData,9)
			Set RepDate   = $lg(RstData,11)
			Set RepTime   = $lg(RstData,12)
			Set SCode     = $lg(RstData,17)
			Set Specimen  = $lg(RstData,22)
			Set Bacteria  = $lg(RstData,23)
			Continue:Bacteria=""
			Set ActLocDr  = $lg(RstData,7)    // 送检科室		
			If (ActLocDr=""){
			 	Set TransInfo  = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,ActDate,ActTime)
				Set ActLocDr = $p(TransInfo,"^",1)
			}
			Continue:ActLocDr=""
			Set LabLocData  = $g(^DHCHAI.BT.LocationD(ActLocDr))
			Set HospDr = $lg(LabLocData,8)
			Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1) //医院过滤
			
			Set MRBTypeDr = $lg(RstData,24)
			Set MRBTypeDr2 = $lg(RstData,31)
			Set MRBDesc="",MRBDesc2=""
			If (MRBTypeDr'="") {
				Set MRBData  = $g(^DHCHAI.IR.CRuleMRBD(MRBTypeDr))
				Set MRBCode= $lg(MRBData,2)
				Set MRBDesc= $lg(MRBData,3)
			}
			If (MRBTypeDr2'="") {
				Set MRBData2  = $g(^DHCHAI.IR.CRuleMRBD(MRBTypeDr2))
				Set MRBCode2= $lg(MRBData2,2)
				Set MRBDesc2= $lg(MRBData2,3)
			}
			Set:MRBDesc2'="" MRBDesc=MRBDesc_","_MRBDesc2
			Continue:(aMRBType="R")&&(MRBTypeDr="")
			Continue:(aMRBType="S")&&(MRBTypeDr'="")
						
			Set LabResultID=$p($lg(RstData,19),"=",2)
			Set RepRstData = $g(^DHCHAI.DP.LabVisitRepResultD(LabResultID))
			Continue:RepRstData=""
			Set LabReportDr  = $lg(RepRstData,2)
			Continue:LabReportDr=""
			Set InfType      = $lg(RepRstData,13)
		    Set:InfType="" InfType=0
		    Continue:(aInfType'="")&&(aInfType'=InfType)
		    Set InfTypeDesc=""
		    Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjByCode("IRInfType",InfType)
		    If $IsObject(objDic) {
			    Set InfTypeDesc = objDic.BTDesc
		    }
		    Set LabReportData    = $g(^DHCHAI.DP.LabVisitReportD(LabReportDr))
			Continue:LabReportData=""
			Set LabVisitNumberDr = $lg(LabReportData,2)
			Continue:LabVisitNumberDr=""
		    Set LabVisitData    = $g(^DHCHAI.DP.LabVisitNumberD(LabVisitNumberDr))
			Continue:LabVisitData=""
		    Set LabWardDr =  $lg(LabVisitData,19)
		    If (LabWardDr=""){
				Set LabWardDr = $p(TransInfo,"^",2)
			}
			Continue:LabWardDr=""
			Set LabWardData  = $g(^DHCHAI.BT.LocationD(LabWardDr))
			Set LabLocDesc="",LabWardDesc=""
			If LabLocData'="" {
				Set LocDesc2 = $li(LabLocData,4)
				Set LocDesc  = $li(LabLocData,3)
				Set LabLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
			}
			If LabWardData'="" {
				Set WardDesc2 = $li(LabWardData,4)
				Set WardDesc  = $li(LabWardData,3)
				Set LabWardDesc = $s(WardDesc2'="":WardDesc2,1:WardDesc)
			}
			
		    Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(EpisodeDr))
			Continue:PAAdmData="" 
			Set EpisodeIDx = $li(PAAdmData,2)
			Set EpisodeID = $p(EpisodeIDx,"||",2)
			Set PatientIDx = $li(PAAdmData,3)
			Set PapmiNo = $li(PAAdmData,4)
			Set MrNo = $li(PAAdmData,5)
			Set PatName = $li(PAAdmData,6)
			Set Sex = $li(PAAdmData,7)
			Set Sex = $s(Sex="M":"男",Sex="F":"女",1:"")
			Set Age = $li(PAAdmData,37)
			Set AdmType = $li(PAAdmData,18)
            // O门诊、E急诊、EP急诊留观、I住院
			If AdmType="I"{
				Set AdmType="住院"
			}ElseIf AdmType="O" {
				Set AdmType="门诊"
			}ElseIf AdmType="E" {
				Set AdmType="急诊"
			}ElseIf AdmType="EP" {
				Set AdmType="急诊留观"
			}
			Set VisitStatus = $li(PAAdmData,19)
			Set AdmDate = $li(PAAdmData,20)
			Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
			Set AdmTime = $li(PAAdmData,21)
			Set:AdmTime'="" AdmTime=$zt(AdmTime)
			
			Set AdmLocDr = $li(PAAdmData,22)
			Set AdmLocDesc=""
			Set LocData = $g(^DHCHAI.BT.LocationD(AdmLocDr))
			If LocData'="" {
				Set LocDesc2 = $li(LocData,4)
				Set LocDesc  = $li(LocData,3)
				Set AdmLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
			}
			
			Set AdmWardDr = +$li(PAAdmData,23)
			Set WardData = $g(^DHCHAI.BT.LocationD(AdmWardDr))
			Set AdmWardDesc=""
			If WardData'="" {
				Set WardDesc2 = $li(WardData,4)
				Set WardDesc  = $li(WardData,3)
				Set AdmWardDesc = $s(WardDesc2'="":WardDesc2,1:WardDesc)
			}
			Set AdmRoom  = $li(PAAdmData,24)
			Set AdmBedDr = $li(PAAdmData,25)
			Set AdmBedData=""
			If (AdmBedDr'="") {
				Set AdmBedData=$g(^DHCHAI.BT.PACBedD(AdmBedDr))
			}
			Set AdmBed=""
			If AdmBedData'="" {
				Set AdmBed = $li(AdmBedData,3)
			}
			Set DischDate = $li(PAAdmData,26)
			Set:DischDate'="" DischDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
			Set DischTime = $li(PAAdmData,27)
			Set:DischTime'="" DischTime=$zt(DischTime)
    		
    		Set:ActDate'="" ActDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
    		Set:ActTime'="" ActTime=$zt(ActTime)
    		Set:RepDate'="" RepDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
    		Set:RepTime'="" RepTime=$zt(RepTime)
			Set Data = $lb(xID,EpisodeDr,EpisodeID,PatientIDx,MrNo,PapmiNo,PatName,Sex,Age,AdmType,AdmBed,AdmLocDesc,AdmWardDesc,AdmDate,AdmTime,DischDate,DischTime)
			Set Data = Data_$lb(LabVisitNumberDr,LabReportDr,LabResultID,ActLocDr,LabLocDesc,LabWardDr,LabWardDesc,ActDate,ActTime,RepDate,RepTime,Specimen,Bacteria,MRBDesc,InfType,InfTypeDesc)

			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1

		}
		
	}
	
	Quit $$$OK
}

ClassMethod QryDailyResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDailyResultExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDailyResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDailyResultExecute ]
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
