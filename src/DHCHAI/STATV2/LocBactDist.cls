/// 名称: DHCHAI.STATV2.LocBactDist
/// 描述: 科室检出菌分布统计
/// 编写者: zhoubo
/// 编写日期: 2021-04-01
Class DHCHAI.STATV2.LocBactDist Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2021-04-01
/// Description:  科室检出菌分布统计
/// Table：       DHCHAI.IR.CCResult
/// Input:        aHospIDs   : 多个医院用"|"连接
///               aDateType  : 日期类型 1：送检日期
/// 			  aDateFrom  ：开始日期
/// 			  aDateTo    : 结束日期
///               aSpecID    : 标本字典ID
///               aDrugLevel : 耐药级别 1：多耐菌 2：敏感
///               aTypeCode  : 感染类型Code
///               aStatNum   : 统计数量
///               aStatUnit  : 统计单位 1：病区2：科室
///               aLocDesc   : 科室描述
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.LocBactDist","QryBactDist","","1","2018-04-01","2021-03-12","","","","5","1","内分泌科护理单元")
Query QryBactDist(aHospIDs As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aSpecID As %String, aDrugLevel As %String, aTypeCode As %String, aStatNum As %String, aStatUnit As %String, aLocDesc As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "SortSum:%String,xLocDesc:%String,xBacDesc:%String,BactNum:%Integer,BactNumSum:%Integer") [ SqlProc ]
{
}

ClassMethod QryBactDistExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aSpecID As %String, aDrugLevel As %String, aTypeCode As %String, aStatNum As %String, aStatUnit As %String, aLocDesc As %String = "", aLocIDs As %Text = "") As %Status
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
 	Set LocCount=$l(aLocIDs,",")  //科室、病区入参个数
 	Set aLocType="W"
    Set:aStatUnit'="1" aLocType="E"
   
    Set NIndex="QryBactDist"
    Set:aStatNum="" aStatNum=5
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

	// 菌株数排序
	Set xLocDesc=""
	For {
		Set xLocDesc=$o(^TMP($zn,$j,NIndex,"BactStat",xLocDesc))
		Quit:xLocDesc=""
		Set xBacDesc=""
		For {
			Set xBacDesc=$o(^TMP($zn,$j,NIndex,"BactStat",xLocDesc,xBacDesc))
			Quit:xBacDesc=""
			Set BactNum    = +$g(^TMP($zn,$j,NIndex,"BactStat",xLocDesc,xBacDesc))
			Set BactNumSum = +$g(^TMP($zn,$j,NIndex,"BactStatSum",xLocDesc))
			Set tmpLocDesc = xLocDesc
			Set:xLocDesc="A全院" tmpLocDesc="全院"
			Set:(xLocDesc="A全院")&&(aLocIDs'="") tmpLocDesc="全部"
			Set Data = $lb(tmpLocDesc,xBacDesc,BactNum,BactNumSum)
			
			Set ^TMP($zn,$j,NIndex,"BactNum",xLocDesc,BactNum,xBacDesc)=Data
		}
	}
	// 输出
	Set SortSum=0
	Set xLocDesc=""
	For {
		Set xLocDesc=$o(^TMP($zn,$j,NIndex,"BactNum",xLocDesc))
		Quit:xLocDesc=""
		Set Count=0
		Set SortSum=SortSum+1
		Set xBactNum=""
		For {
			Set xBactNum=$o(^TMP($zn,$j,NIndex,"BactNum",xLocDesc,xBactNum),-1)
			Quit:xBactNum=""
			Set xBacDesc=""
			For {
				Set xBacDesc=$o(^TMP($zn,$j,NIndex,"BactNum",xLocDesc,xBactNum,xBacDesc))
				Quit:xBacDesc=""
				
				Set Data = $g(^TMP($zn,$j,NIndex,"BactNum",xLocDesc,xBactNum,xBacDesc))
				Set Count=Count+1
				
				Quit:Count>aStatNum
				Set ^CacheTemp(repid,ind)=$lb(SortSum)_Data
				Set ind=ind+1
			}
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
BuildMRBData
	Set RstData = $g(^DHCHAI.IR.CCResultD(xID))
	Quit:RstData=""
	//过滤无效数据
	Quit:$lg(RstData,14)'=1
	Set CCMRBTpDr = $li(RstData,24)  // 是否是多耐菌
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
		Quit:ActWardID=""
		If (aLocType="W"){
			Set ActLocData  = $g(^DHCHAI.BT.LocationD(ActWardID))
			Quit:(aLocIDs'="")&((","_aLocIDs_",")'[(","_ActWardID_","))
		}
		else{
			Set ActLocData  = $g(^DHCHAI.BT.LocationD(ActLocID))
			Quit:(aLocIDs'="")&((","_aLocIDs_",")'[(","_ActLocID_","))
		}
		Set HospID = $li(ActLocData,8)
		
		Set LocDesc  = $li(ActLocData,3)		//送检科室
		Set LocDesc2 = $li(ActLocData,4)
		Set:LocDesc2'="" LocDesc=LocDesc2
	}					
	else{				//报告科室
		Set TransInfo  = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(AdmID,RepDate,RepTime)
		Set RepLocID = $p(TransInfo,"^",1)
		Quit:RepLocID=""
		Set RepWardID = $p(TransInfo,"^",2)
		Quit:RepWardID=""
  		If (aLocType="W"){
			Set RepLocData  = $g(^DHCHAI.BT.LocationD(RepWardID))
			Quit:(aLocIDs'="")&((","_aLocIDs_",")'[(","_RepWardID_","))
		}
		else{
			Set RepLocData  = $g(^DHCHAI.BT.LocationD(RepLocID))
			Quit:(aLocIDs'="")&((","_aLocIDs_",")'[(","_RepLocID_","))
		}
		Set HospID = $li(RepLocData,8)
		
		Set LocDesc  = $li(RepLocData,3)		//报告科室
		Set LocDesc2 = $li(RepLocData,4)
		Set:LocDesc2'="" LocDesc=LocDesc2
	}
	Quit:(aHospIDs'="")&&($listfind(aHospIDs,HospID)<1) 	//医院过滤
	//过滤感染类型-->aTypeCode
	Set ResultID =$p( $li(RstData,19),"=",2)  		//检验结果ID：DHCHAI.DP.LabVisitRepResult
	Quit:ResultID=""
	Set RepRstData=$g(^DHCHAI.DP.LabVisitRepResultD(ResultID))
	Quit:RepRstData=""
	Set MakeInfType=$lg(RepRstData,13)
	Quit:(aTypeCode'="")&&(aTypeCode'=MakeInfType)  // 过滤感染类型	
	//过滤标本-->aSpecID
	Set (SpeID,SpeDesc)=""			//标本名称(标准名)
	Set SCode    = $li(RstData,17)  //子系统代码
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
	Quit:(aSpecID'="")&&(aSpecID'=SpeID) 	//标本过滤
	//过滤未对照细菌
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
	Quit:BacDesc="" 
	//去重
	If (IsUnRepeat="1"){
		Set UnBact="1"					//细菌
		Set:aDrugLevel="1" UnBact="2"	//多耐
		
		Set IsFirstSend=##Class(DHCHAI.STATV2.S040MRBInf).IsFirstSend(AdmID,xID,UnRepeatType,UnBact)
		Quit:IsFirstSend'=1
	}
	
	If (aLocDesc'=""){
		If (aLocDesc="全院")||(aLocDesc="全部"){
			Set num=$i(^TMP($zn,$j,NIndex,"BactStat","A全院",BacDesc))
		}Else{
			Quit:(LocDesc'=aLocDesc)
			Set num=$i(^TMP($zn,$j,NIndex,"BactStat",LocDesc,BacDesc))
		}
	}Else{
		Set num=$i(^TMP($zn,$j,NIndex,"BactStat","A全院",BacDesc))
		Set num=$i(^TMP($zn,$j,NIndex,"BactStat",LocDesc,BacDesc))  
		
		Set num=$i(^TMP($zn,$j,NIndex,"BactStatSum","A全院"))
		Set num=$i(^TMP($zn,$j,NIndex,"BactStatSum",LocDesc))
	}
	Quit
}

ClassMethod QryBactDistClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBactDistExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryBactDistFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBactDistExecute ]
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
/// CreatDate：   2021-04-02
/// Description:  科室检出菌分布统计患者明细
/// Table：       DHCHAI.IR.CCResult
/// Input:        aHospIDs   : 多个医院用"|"连接
///               aDateType  : 日期类型 1：送检日期
/// 			  aDateFrom  ：开始日期
/// 			  aDateTo    : 结束日期
///               aSpecID    : 标本字典ID
///               aDrugLevel : 耐药级别 1：多耐菌 2：敏感
///               aTypeCode  : 感染类型Code
///               aStatNum   : 统计数量
///               aStatUnit  : 统计单位 1：病区2：科室
///               aLocDesc   : 科室/护理单元
///               aBacDesc   : 细菌
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.LocBactDist","QryBactDistDtl","1","1","2020-01-01","2020-06-12","","","","5","1","","")
Query QryBactDistDtl(aHospIDs As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aSpecID As %String, aDrugLevel As %String, aTypeCode As %String, aStatNum As %String, aStatUnit As %String, aLocDesc As %String, aBacDesc As %String) As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DishLocDesc:%String,DishWardDesc:%String,TransID:%String,GroupID:%String,GroupDesc:%String,LocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,ResID:%String,LabEpisodeNo:%String,LabTestSet:%String,ActDateTime:%String,RepDateTime:%String,MRBDesc:%String,SpeDesc:%String,BacDesc:%String,InfType:%String") [ SqlProc ]
{
}

ClassMethod QryBactDistDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aSpecID As %String, aDrugLevel As %String, aTypeCode As %String, aStatNum As %String, aStatUnit As %String, aLocDesc As %String, aBacDesc As %String) As %Status
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
    
    Set:aStatNum="" aStatNum=5
    Set:aLocDesc="全院" aLocDesc=""
    Set:aLocDesc="全部" aLocDesc=""
    Set aLocType="W"
    Set:aStatUnit'="1" aLocType="E"
    
    Set NIndex="QryBactDistDtl"
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
	Quit:$lg(RstData,14)'=1
	Set CCMRBTpDr = $li(RstData,24)  // 是否是多耐菌
	//过滤耐药级别(耐药or敏感)-->aDrugLevel	
	Set MRBTpDr = $lg(RstData,24)		//多耐类型-1
	Set MRBTp2Dr=$lg(RstData,31)		//多耐类型-2
	If (aDrugLevel="1"){	//耐药
		Quit:(MRBTpDr="")&&(MRBTp2Dr="")
	}ElseIf (aDrugLevel="2"){	//敏感
		Quit:(MRBTpDr'="")||(MRBTp2Dr'="")
	}
	//过滤感染类型-->aTypeCode
	Set ResultID =$p( $li(RstData,19),"=",2)  		//检验结果ID：DHCHAI.DP.LabVisitRepResult
	Quit:ResultID=""
	Set RepRstData=$g(^DHCHAI.DP.LabVisitRepResultD(ResultID))
	Quit:RepRstData=""
	Set MakeInfType=$lg(RepRstData,13)
	Quit:(aTypeCode'="")&&(aTypeCode'=MakeInfType)  // 过滤感染类型	
	//过滤标本-->aSpecID
	Set (SpeID,SpeDesc)=""			//标本名称(标准名)
	Set SCode    = $li(RstData,17)  //子系统代码
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
	Quit:(aSpecID'="")&&(aSpecID'=SpeID) 	//标本过滤
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
		Quit:ActWardID=""
		If (aLocType="W"){
			Set ActLocData  = $g(^DHCHAI.BT.LocationD(ActWardID))
		}
		else{
			Set ActLocData  = $g(^DHCHAI.BT.LocationD(ActLocID))
		}
		Set HospID = $li(ActLocData,8)
		
		Set LocDesc  = $li(ActLocData,3)		//送检科室
		Set LocDesc2 = $li(ActLocData,4)
		Set:LocDesc2'="" LocDesc=LocDesc2
		//取转科信息
		Set TransInfo=##class(DHCHAI.STATV2.BactDrugfast).GetLocInfoByDate(AdmID,aLocType,ActDate,ActTime)
	}					
	else{				//报告科室
		Set TransInfo  = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(AdmID,RepDate,RepTime)
		Set RepLocID = $p(TransInfo,"^",1)
		Quit:RepLocID=""
		Set RepWardID = $p(TransInfo,"^",2)
		
  		Set RepLocData  = $g(^DHCHAI.BT.LocationD(RepLocID))
		Set HospID = $li(RepLocData,8)
		
		Set LocDesc  = $li(RepLocData,3)		//报告科室
		Set LocDesc2 = $li(RepLocData,4)
		Set:LocDesc2'="" LocDesc=LocDesc2
		//取转科信息
		Set TransInfo=##class(DHCHAI.STATV2.BactDrugfast).GetLocInfoByDate(AdmID,aLocType,RepDate,RepTime)
	}
	Quit:(aHospIDs'="")&&($listfind(aHospIDs,HospID)<1) 	//医院过滤
	//过滤科室-->aLocDesc
	Quit:(aLocDesc'="")&&(aLocDesc'=LocDesc)
	//过滤细菌-->aBacDesc
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
	Quit:BacDesc="" 	//过滤未对照细菌
	Quit:(aBacDesc'="")&&(BacDesc'=aBacDesc)		//过滤细菌
		
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
	
	Set Data = $lb(BacDesc,AdmTimes)_PatData_TransInfo_LabInfo
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod QryBactDistDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBactDistDtlExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryBactDistDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBactDistDtlExecute ]
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
