/// 名称: DHCHAI.STATV2.DishTrendStat
/// 描述: 出院患者趋势表统计
/// 编写者: zhoubo
/// 编写日期: 2020-11-04
Class DHCHAI.STATV2.DishTrendStat Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：		zhoubo
/// CreateDate：	2022-12-08
/// Description:	出院患者人数、例次、治愈人数及例次、漏报人数及例次统计
/// Input:        	aHospIDs： 多个医院用"|"连接
/// 			  	aDateFrom：开始日期
/// 			  	aDateTo：  结束日期
///               	aLocID     : 科室/病区ID
/// 				aStatUnit：日期单位，1:月, 2:季度, 3:年
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.DishTrendStat","QryInfDishTrend","","2021","2021","3","")
Query QryInfDishTrend(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStatUnit As %String, aLocID As %Text) As %Query(ROWSPEC = "StatName:%String,PatAdmCnt:%Integer,InfPatCnt:%Integer,InfCaseCnt:%Integer,EffectCnt:%Integer,EffectCaseCnt:%Integer,NotRepCnt:%Integer,NotRepCaseCnt:%Integer,PatInfRatio:%String,PatInfCaseRatio:%String,InfEffectRatio:%String,InfEffectCaseRatio:%String,NotRepCaseRatio:%String,PatInfRatio1:%String,PatInfCaseRatio1:%String,InfEffectRatio1:%String,InfEffectCaseRatio1:%String,NotRepCaseRatio1:%String") [ SqlProc ]
{
}

ClassMethod QryInfDishTrendExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStatUnit As %String, aLocID As %Text) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
    do SetDateByStatUnit    // 1.时间分级
    Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
    Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
    Quit:(aDateFrom>aDateTo)
    Set:aLocID'="" aLocID=$tr(aLocID,",","|")
    Set aLocIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aLocID,"|")
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    
     // ↑↑↑入参解析完成   开始向下计算↓↓↓
    Set NIndex="QryInfDishTrend"
    Kill ^TMP($zn,$j,NIndex)
    Do Excute   // 2.执行任务
    // 3.输出
    Set xName=""
    For {
        Set xName=$o(^TMP($zn,$j,NIndex,xName))
        Quit:xName=""
        Set StatName = xName
        
        Set PatAdmCnt  =+$g(^TMP($zn,$j,NIndex,StatName,"DischPatSum"))          //出院人数
        Set InfPatCnt  =+$g(^TMP($zn,$j,NIndex,StatName,"InfPat"))       //感染人数
        Set InfCaseCnt =+$g(^TMP($zn,$j,NIndex,StatName,"InfCase"))      //感染例数
        Set EffectCnt  =+$g(^TMP($zn,$j,NIndex,StatName,"EffectPat"))    //治愈人数
        Set EffectCaseCnt=+$g(^TMP($zn,$j,NIndex,StatName,"EffectCase"))     //治愈例次数
        Set NotRepCnt  =+$g(^TMP($zn,$j,NIndex,StatName,"NotRepPat"))    //漏报人数
        Set NotRepCaseCnt=+$g(^TMP($zn,$j,NIndex,StatName,"NotRepCase"))    //漏报感染例次数
        Continue:PatAdmCnt=0                            //无效科室数据为空时过滤
        
        Set PatInfRatio="0.00%",PatInfCaseRatio="0.00%",InfEffectRatio="0.00%",InfEffectCaseRatio="0.00%",NotRepCaseRatio="0.00%"
        Set:PatAdmCnt>0 PatInfRatio=$fn((InfPatCnt/PatAdmCnt)*100,"",2)_"%"                 //感染率
        Set:PatAdmCnt>0 PatInfCaseRatio=$fn((InfCaseCnt/PatAdmCnt)*100,"",2)_"%"            //感染例次率
        Set:InfPatCnt>0 InfEffectRatio=$fn((EffectCnt/InfPatCnt)*100,"",2)_"%"              //医院感染治愈率
        Set:InfCaseCnt>0 InfEffectCaseRatio=$fn((EffectCaseCnt/InfCaseCnt)*100,"",2)_"%"    //医院感染治愈例次率
        Set:NotRepCaseCnt>0 NotRepCaseRatio=$fn((NotRepCnt/InfPatCnt)*100,"",2)_"%"     //漏报率
        
        Set PatInfRatio1        = +PatInfRatio
        Set PatInfCaseRatio1    = +PatInfCaseRatio
        Set InfEffectRatio1     = +InfEffectRatio
        Set InfEffectCaseRatio1 = +InfEffectCaseRatio
        Set NotRepCaseRatio1    = +NotRepCaseRatio
        
        
        Set Data=$lb(StatName,PatAdmCnt,InfPatCnt,InfCaseCnt,EffectCnt,EffectCaseCnt,NotRepCnt,NotRepCaseCnt,PatInfRatio,PatInfCaseRatio,InfEffectRatio,InfEffectCaseRatio,NotRepCaseRatio,PatInfRatio1,PatInfCaseRatio1,InfEffectRatio1,InfEffectCaseRatio1,NotRepCaseRatio1)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
    }
    Kill ^TMP($zn,$j,NIndex)
    Quit $$$OK
SetDateByStatUnit
	If (aStatUnit=1) {
		Set aDateFrom = aDateFrom_"-01"
		Set aDateTo   = aDateTo_"-01"
		Set aDateTo   = $zdh(aDateTo,3)
		Set aDateTo   = aDateTo+32
		Set aDateTo   = $zd(aDateTo,3)
		Set aDateTo   = $p(aDateTo,"-",1)_"-"_$p(aDateTo,"-",2)_"-01"
		Set aDateTo   = $zdh(aDateTo,3)-1
		Set aDateTo   = $zd(aDateTo,3)
	}elseIf(aStatUnit=2){
		Set StatMonth = $p(aDateFrom,"-",2)	
		Set aDateFrom = $s((+StatMonth)<4:+aDateFrom_"-01-01",(+StatMonth)<7:+aDateFrom_"-04-01",(+StatMonth)<10:+aDateFrom_"-07-01",1:+aDateFrom_"-10-01")
		Set StatMonth = $p(aDateTo,"-",2)	
		Set aDateTo = $s((+StatMonth)<4:+aDateTo_"-03-31",(+StatMonth)<7:+aDateTo_"-06-30",(+StatMonth)<10:+aDateTo_"-09-30",1:+aDateTo_"-12-31")
	}elseIf(aStatUnit=3){
		Set aDateFrom=aDateFrom_"-01-01"
		Set aDateTo=aDateTo_"-12-31"
	}

    Quit
Excute
 	
	// 查询出院患者
    Set xAdmType = "I"
    Quit:'$d(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
		For xDishDate = aDateFrom:1:aDateTo {
			Set xDishTime = ""
			For {
				Set xDishTime = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDishDate,xDishTime))
				Quit:xDishTime=""
				
				Set StatDate  = xDishDate
				Set StatDate  = $zd(StatDate,3)
				Set StatYear  = $p(StatDate,"-",1)
				Set StatMonth = $p(StatDate,"-",2)
				If (aStatUnit=1){ // 按月统计
					Set StatName = StatYear_"年"_StatMonth_"月" 
				}ElseIf (aStatUnit=2){ // 按季度统计
					Set StatName = StatYear_"年"_$s((+StatMonth)<4:"1",(+StatMonth)<7:"2",(+StatMonth)<10:"3",1:"4")_"季度"
				}Else {  // 按年统计
					Set StatName = StatYear_"年"
				}
				
				Set xPaadm = ""
				For {
					Set xPaadm = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDishDate,xDishTime,xPaadm))
					Quit:xPaadm=""
                do BuildTmpData
            }
        }
    }
    Quit
BuildTmpData
	//就诊信息
	Set AdmInfo=$g(^DHCHAI.DP.PAAdmD(xPaadm))
    quit:AdmInfo=""
	Set VisitStatus = $lg(AdmInfo,19)
	quit:(VisitStatus="P")||(VisitStatus="C")				
	//出院科室/病区
    Set DishLocID   = $List(AdmInfo,28)
    Set DishWardID  = $List(AdmInfo,29)
    Quit:DishLocID=""
    Quit:DishWardID=""
    Quit:(aLocIDs'="")&&(($listfind(aLocIDs,DishLocID)<1)&($listfind(aLocIDs,DishWardID)<1))  //允许增加科室入参查询
					
	//出院医院
	Set DishHospID=$List($g(^DHCHAI.BT.LocationD(DishLocID)),8)
    Quit:(aHospIDs'="")&(DishHospID'="")&($listfind(aHospIDs,DishHospID)<1)
					
	Set num=$i(^TMP($zn,$j,NIndex,"ssss",StatName,"DischPatSum")) 
	//在院区间感染信息
	Set AdmDate = $li(AdmInfo,20)
	Set DischDate = $li(AdmInfo,26)
    //出院人数
    if '$d(^TMP($zn,$j,NIndex,StatName,"DischPat",xPaadm)) {
        Set ^TMP($zn,$j,NIndex,StatName,"DischPat",xPaadm)=""
        Set num=$i(^TMP($zn,$j,NIndex,StatName,"DischPatSum")) 
    }else{
        quit   
    }
    // 感染人数 感染例数 治愈人数  治愈例次 漏报人数 漏报例次数 感染率 感染例次率 感染治愈率 感染治愈例次率 漏报率
    //Set InfPosInfo=..GetInfDiagRep(xPaadm,AdmDate,DischDate)
	Set InfPosInfo=..GetInfPosInfo(xPaadm,AdmDate,DischDate,1)	
    Quit:InfPosInfo=""
    If (InfPosInfo'="") {
        for InfNo=1:1:$L(InfPosInfo,"|") {
            Set InfPosMsg=$p(InfPosInfo,"|",InfNo)
			continue:InfPosMsg=""
            Set DiagID	    = $p(InfPosMsg,"^",1)
			Set InfDate	    = $p(InfPosMsg,"^",3)	//感染日期
			Set InfEffect   = $p(InfPosMsg,"^",5)
            Set InfType     = $p(InfPosMsg,"^",7)
			Continue:InfType="社区感染"
			Set infStatDate = $zd(InfDate,3)
			Set StatYear    = $p(InfDate,"-",1)
			Set StatMonth   = $p(InfDate,"-",2)
          	
            If '$d(^TMP($zn,$j,NIndex,StatName,"InfPat",xPaadm)) {         
                Set ^TMP($zn,$j,NIndex,StatName,"InfPat",xPaadm)=""
                Set num = $i(^TMP($zn,$j,NIndex,StatName,"InfPat")) //医院感染人数
			}		

            Set num=$i(^TMP($zn,$j,NIndex,StatName,"InfCase"))     //医院感染例次数
			If (InfEffect="治愈"){
				If ('$d(^TMP($zn,$j,NIndex,"EffectAdm",xPaadm))){
                    Set num=$i(^TMP($zn,$j,NIndex,StatName,"EffectPat"))    //治愈人数
				}
                Set num=$i(^TMP($zn,$j,NIndex,StatName,"EffectCase"))       //治愈例次数据  
			}
			//3.漏报报告
			//3.1.院感科代报
            //代报 + 出院后上报为漏报
            Set RepDate=$p(InfPosMsg,"^",9)
            Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(RepDate)
            Set ReplaceFlag= $p(InfPosMsg,"^",10)		//代报
            If (ReplaceFlag=1){
				If ('$d(^TMP($zn,$j,NIndex,StatName,"NotRep",xPaadm))){
					//记录漏报的就诊号
                    Set ^TMP($zn,$j,NIndex,StatName,"NotRep",xPaadm)=""
                    Set num=$i(^TMP($zn,$j,NIndex,StatName,"NotRepPat"))  
				}
                Set num=$i(^TMP($zn,$j,NIndex,StatName,"NotRepCase"))
            }Else{
	        	If ((DischDate'="")&&(DischDate<RepDate)){
		            //3.2.患者出院后补报(剔除手术部位感染)
	                Set PosDesc = $p(InfPosMsg,"^",2)       // 感染诊断
	                Continue:((PosDesc="表浅手术切口感染")||((PosDesc="深部手术切口感染"))||((PosDesc="器官和腔隙感染")))
	                If '$d(^TMP($zn,$j,NIndex,StatName,"NotRep",xPaadm)) {
						//记录漏报的就诊号
						Set ^TMP($zn,$j,NIndex,StatName,"NotRep",xPaadm)=""
	                    Set num=$i(^TMP($zn,$j,NIndex,StatName,"NotRepPat"))   //漏报人数
	                }
	                Set num=$i(^TMP($zn,$j,NIndex,StatName,"NotRepCase"))    //漏报例次数
	        	}
	        }
		}
	}
    Quit
}

ClassMethod QryInfDishTrendClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfDishTrendExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfDishTrendFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfDishTrendExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：		zhoubo
/// CreateDate：	2021-05-19
/// Description:	出院患者漏报明细
/// Input:        	aHospIDs： 多个医院用"|"连接
///               	aLocID     : 科室/病区ID
/// 				aStatUnit：日期单位，1:月, 2:季度, 3:年
///                 aDimensType :2012年
///                 aFlag : 1:查询漏报人数 2：治愈人数
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.DishTrendStat","QryDishMissDtl","","1","","2020年04月","1")
Query QryDishMissDtl(aHospIDs As %String, aStatUnit As %String, aLocID As %Text, aDimensType As %String, aFlag As %String) As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,DiagDr:%String,DiagDesc:%String,InfDate:%String,InfXDate:%String,InfEffect:%String,InfType:%String,RepDate:%String,RepUser:%String") [ SqlProc ]
{
}

ClassMethod QryDishMissDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aStatUnit As %String, aLocID As %Text, aDimensType As %String, aFlag As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	If (aStatUnit=1) {
		//2021年04月
		Set DateYM=+aDimensType_"-"_$e(aDimensType,6,7)
		Set DateInfo=##class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(DateYM)
		Set aDateFrom = $p(DateInfo,"^",1)
		Set aDateTo   = $p(DateInfo,"^",2)
		
	}ElseIf(aStatUnit=2){
		//2021年2季度
		Set JDIndex=$e(aDimensType,6)
		If (JDIndex=1){
			Set aDateFrom =+aDimensType_"-01-01"
			Set aDateTo   =+aDimensType_"-03-31"
		}ElseIf (JDIndex=2){
			Set aDateFrom =+aDimensType_"-04-01"
			Set aDateTo   =+aDimensType_"-06-30"
		}
		ElseIf (JDIndex=3){
			Set aDateFrom =+aDimensType_"-07-01"
			Set aDateTo   =+aDimensType_"-09-30"
		}
		Else{
			Set aDateFrom =+aDimensType_"-10-01"
			Set aDateTo   =+aDimensType_"-12-31"
		}
	}ElseIf(aStatUnit=3){
		Set aDateFrom=+aDimensType_"-01-01"
		Set aDateTo=+aDimensType_"-12-31"
	}
	Quit:(aDateFrom="")||(aDateTo="") $$$OK

	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
 	Set:aLocID'="" aLocID=$tr(aLocID,",","|")
 	Set aLocIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aLocID,"|")
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	
    Set NIndex="QryDishMissDtl"
	Kill ^TMP($zn,$j,NIndex)
	
	// 查询出院患者
	Set xAdmType = ""
    For {
		Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
		Quit:xAdmType=""
		Continue:xAdmType'="I"
		
		For xDishDate = aDateFrom:1:aDateTo {
			Set xDishTime = ""
			For {
				Set xDishTime = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDishDate,xDishTime))
				Quit:xDishTime=""
				
				Set StatDate  = xDishDate
				Set StatDate  = $zd(StatDate,3)
				Set StatYear  = $p(StatDate,"-",1)
				Set StatMonth = $p(StatDate,"-",2)
				If (aStatUnit=1){ // 按月统计
					Set StatName = StatYear_"年"_StatMonth_"月" 
				}ElseIf (aStatUnit=2){ // 按季度统计
					Set StatName = StatYear_"年"_$s((+StatMonth)<4:"1",(+StatMonth)<7:"2",(+StatMonth)<10:"3",1:"4")_"季度"
				}Else {  // 按年统计
					Set StatName = StatYear_"年"
				}
				
				Set xPaadm = ""
				For {
					Set xPaadm = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDishDate,xDishTime,xPaadm))
					Quit:xPaadm=""
					
					//就诊信息
					Set AdmInfo=$g(^DHCHAI.DP.PAAdmD(xPaadm))
					Continue:AdmInfo=""
					Set VisitStatus = $lg(AdmInfo,19)
					Continue:(VisitStatus="P")||(VisitStatus="C")
					//出院科室/病区
					Set DishLocID	= $List(AdmInfo,28)
					Set DishWardID	= $List(AdmInfo,29)
					Continue:DishLocID=""
					Continue:DishWardID=""
					Continue:(aLocIDs'="")&&(($listfind(aLocIDs,DishLocID)<1)&($listfind(aLocIDs,DishWardID)<1))  //允许增加科室入参查询
					
					//出院医院
					Set DishHospID=$List($g(^DHCHAI.BT.LocationD(DishLocID)),8)
					Continue:(aHospIDs'="")&(DishHospID'="")&($listfind(aHospIDs,DishHospID)<1)
					
					Set num=$i(^TMP($zn,$j,NIndex,"ssss",StatName,"DischPatSum")) 
					//患者信息
					Set PatData=..BuildPaadmData(xPaadm)
					Continue:PatData=""
					//在院区间感染信息
					Set AdmDate = $li(AdmInfo,20)
					Set DischDate = $li(AdmInfo,26)
					If (aFlag=2){
						Set InfPosDescs=..GetInfPosInfo(xPaadm,AdmDate,DischDate,1)
						If (InfPosDescs'="") {
							for InfNo=1:1:$L(InfPosDescs,"|") {
								Set InfPosMsg=$p(InfPosDescs,"|",InfNo)
								continue:InfPosMsg=""
								Set DiagDr    = $p(InfPosMsg,"^",1)
								Set DiagDesc  = $p(InfPosMsg,"^",2)
			                    Set InfDate   = $p(InfPosMsg,"^",3)
			                    Set InfXDate  = $p(InfPosMsg,"^",4)
			                    Set InfEffect = $p(InfPosMsg,"^",5)
			                    Set InfType   = $p(InfPosMsg,"^",7)
			                    Set RepUser   = $p(InfPosMsg,"^",11)
            					Set RepDate   = $p(InfPosMsg,"^",9)
			                    Set:InfDate'="" InfDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfDate)
			                    Set:InfXDate'="" InfXDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfXDate)
			                    
								
								If (InfEffect="治愈"){
									Set Data=PatData_$lb(DiagDr,DiagDesc,InfDate,InfXDate,InfEffect,InfType,RepDate,RepUser)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
							}
							
						}
                    }else{
                        do BuildMiss
					}
				}
			}
		}
	}
    Kill ^TMP($zn,$j,NIndex)
    Quit $$$OK
BuildMiss
    //Set InfPosInfo=..GetInfDiagRep(xPaadm,AdmDate,DischDate)
    Set InfPosInfo=..GetInfPosInfo(xPaadm,AdmDate,DischDate,1)
    Quit:InfPosInfo=""
    If (InfPosInfo'="") {
        for InfNo=1:1:$L(InfPosInfo,"|") {
            Set InfPosMsg=$p(InfPosInfo,"|",InfNo)
            continue:InfPosMsg=""
            Set DiagDr    = $p(InfPosMsg,"^",1)
			Set DiagDesc  = $p(InfPosMsg,"^",2)
            Set InfDate   = $p(InfPosMsg,"^",3)
            Set InfXDate  = $p(InfPosMsg,"^",4)
            Set InfEffect = $p(InfPosMsg,"^",5)
            Set InfType   = $p(InfPosMsg,"^",7)
            Set RepUser   = $p(InfPosMsg,"^",11)
            Set RepDate   = $p(InfPosMsg,"^",9)
            Set:InfDate'="" InfDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfDate)
            Set:InfXDate'="" InfXDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfXDate)
            Set tRepDate=""
			Set:RepDate'="" tRepDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(RepDate)
            Set infStatDate  = $zd(InfDate,3)
            Set StatYear  = $p(InfDate,"-",1)
            Set StatMonth = $p(InfDate,"-",2)
          
            //代报 + 出院后上报为漏报
            Set Flag=$p(InfPosMsg,"^",10)
            If (Flag=1){
	        	
		   		Continue:$d(^TMP($zn,$j,NIndex,"DiagDr",DiagDr)) // 输出去重
				Set ^TMP($zn,$j,NIndex,"DiagDr",DiagDr)=""
							
				Set Data=PatData_$lb(DiagDr,DiagDesc,InfDate,InfXDate,InfEffect,InfType,RepDate,RepUser)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
            }elseIf((DischDate'="")&&(DischDate<tRepDate)){
		   		Continue:$d(^TMP($zn,$j,NIndex,"DiagDr",DiagDr)) // 输出去重
				Set ^TMP($zn,$j,NIndex,"DiagDr",DiagDr)=""
				Continue:((DiagDesc="表浅手术切口感染")||((DiagDesc="深部手术切口感染"))||((DiagDesc="器官和腔隙感染")))
				
                Set Data=PatData_$lb(DiagDr,DiagDesc,InfDate,InfXDate,InfEffect,InfType,RepDate,RepUser)
                Set ^CacheTemp(repid,ind)=Data
                Set ind=ind+1
			}
		}
	}
}

ClassMethod QryDishMissDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDishMissDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDishMissDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDishMissDtlExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：		zhoubo
/// CreateDate：	2021-05-19
/// Description:	出院患者感染明细
/// Input:        	aHospIDs： 多个医院用"|"连接
///               	aLocID     : 科室/病区ID
/// 				aStatUnit：日期单位，1:月, 2:季度, 3:年
///                 aDimensType :2012年
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.DishTrendStat","QryDishInfDtl","","1","","2020年04月")
Query QryDishInfDtl(aHospIDs As %String, aStatUnit As %String, aLocID As %Text, aDimensType As %String) As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,InfPosDescs:%String,InfDates:%String,InfEffects:%String,InfLocDesc:%String,InfXDate:%String,InfType:%String,RepDate:%String,RepUser:%String,TransID:%String,TranLocDr:%String,TranLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String") [ SqlProc ]
{
}

ClassMethod QryDishInfDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aStatUnit As %String, aLocID As %Text, aDimensType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	If (aStatUnit=1) {
		//2021年04月
		Set DateYM=+aDimensType_"-"_$e(aDimensType,6,7)
		Set DateInfo=##class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(DateYM)
		Set aDateFrom = $p(DateInfo,"^",1)
		Set aDateTo   = $p(DateInfo,"^",2)
		
	}ElseIf(aStatUnit=2){
		//2021年2季度
		Set JDIndex=$e(aDimensType,6)
		If (JDIndex=1){
			Set aDateFrom =+aDimensType_"-01-01"
			Set aDateTo   =+aDimensType_"-03-31"
		}ElseIf (JDIndex=2){
			Set aDateFrom =+aDimensType_"-04-01"
			Set aDateTo   =+aDimensType_"-06-30"
		}
		ElseIf (JDIndex=3){
			Set aDateFrom =+aDimensType_"-07-01"
			Set aDateTo   =+aDimensType_"-09-30"
		}
		Else{
			Set aDateFrom =+aDimensType_"-10-01"
			Set aDateTo   =+aDimensType_"-12-31"
		}
	}ElseIf(aStatUnit=3){
		Set aDateFrom=+aDimensType_"-01-01"
		Set aDateTo=+aDimensType_"-12-31"
	}
	Quit:(aDateFrom="")||(aDateTo="") $$$OK

	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
 	Set:aLocID'="" aLocID=$tr(aLocID,",","|")
 	Set aLocIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aLocID,"|")
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	
    Set NIndex="QryDishInfDtl"
	Kill ^TMP($zn,$j,NIndex)
	
	// 查询出院患者
	Set xAdmType = ""
    For {
		Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
		Quit:xAdmType=""
		Continue:xAdmType'="I"
		
		For xDishDate = aDateFrom:1:aDateTo {
			Set xDishTime = ""
			For {
				Set xDishTime = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDishDate,xDishTime))
				Quit:xDishTime=""
				
				Set StatDate  = xDishDate
				Set StatDate  = $zd(StatDate,3)
				Set StatYear  = $p(StatDate,"-",1)
				Set StatMonth = $p(StatDate,"-",2)
				If (aStatUnit=1){ // 按月统计
					Set StatName = StatYear_"年"_StatMonth_"月" 
				}ElseIf (aStatUnit=2){ // 按季度统计
					Set StatName = StatYear_"年"_$s((+StatMonth)<4:"1",(+StatMonth)<7:"2",(+StatMonth)<10:"3",1:"4")_"季度"
				}Else {  // 按年统计
					Set StatName = StatYear_"年"
				}
				
				Set xPaadm = ""
				For {
					Set xPaadm = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDishDate,xDishTime,xPaadm))
					Quit:xPaadm=""
					
					//就诊信息
					Set AdmInfo=$g(^DHCHAI.DP.PAAdmD(xPaadm))
					Continue:AdmInfo=""
					Set VisitStatus = $lg(AdmInfo,19)
					Continue:(VisitStatus="P")||(VisitStatus="C")
					//出院科室/病区
					Set DishLocID	= $List(AdmInfo,28)
					Set DishWardID	= $List(AdmInfo,29)
					Continue:DishLocID=""
					Continue:DishWardID=""
					Continue:(aLocIDs'="")&&(($listfind(aLocIDs,DishLocID)<1)&($listfind(aLocIDs,DishWardID)<1))  //允许增加科室入参查询
					
					//出院医院
					Set DishHospID=$List($g(^DHCHAI.BT.LocationD(DishLocID)),8)
					Continue:(aHospIDs'="")&(DishHospID'="")&($listfind(aHospIDs,DishHospID)<1)
					//科室分类（执行科室、病房、其他）
					Set LocTypeCode=""
					Set BTTypeDr=$lg($g(^DHCHAI.BT.LocationD(DishLocID)),5)
					If (BTTypeDr'=""){
						Set LocTypeData=$g(^DHCHAI.BT.DictionaryD(BTTypeDr))
						Set LocTypeCode=$lg(LocTypeData,2)
					}
					Set num=$i(^TMP($zn,$j,NIndex,"ssss",StatName,"DischPatSum")) 
					//患者信息
					Set PatData=..BuildPaadmData(xPaadm)
					Continue:PatData=""
					//在院区间感染信息
					
					Set TransInfoArr =..GetTransInfo(xPaadm,"","",LocTypeCode)    //存在转科日期早于入院日期情况，取全部转科记录
					For TransInd=1:1:TransInfoArr.Count(){
						Set TransInfo=TransInfoArr.GetAt(TransInd)
						Set TransID     = $lg(TransInfo,1)
						Set TranData	= $g(^DHCHAI.DP.PAAdmTransD(TransID))
						Set TranLocDr   = $lg(TranData,5)
						Continue:TranLocDr=""
					    Set TransDate	= $lg(TranData,7)
					    Set OutLocDate	= $lg(TranData,10)
					    Set:OutLocDate="" OutLocDate=+$h
						//Set InfPosDescs=..GetInfDiagRep(xPaadm,TransDate,OutLocDate)
						Set InfPosDescs=..GetInfPosInfo(xPaadm,TransDate,OutLocDate,1)
						Continue:InfPosDescs=""
						For indxi=1:1:$l(InfPosDescs,"|") {
							Set tmpInfPos      	= $p(InfPosDescs,"|",indxi)
							Set tmpInfPosID    	= $p(tmpInfPos,"^",1)
							Set tmpInfPosDescs 	= $p(tmpInfPos,"^",2)	//感染诊断
							Set InfDate		   	= $p(tmpInfPos,"^",3)
							Set InfXDate	    = $p(tmpInfPos,"^",4)
							Set InfEffect	    = $p(tmpInfPos,"^",5)
							Set InfType			= $p(tmpInfPos,"^",7)
							Set RepUser         = $p(tmpInfPos,"^",11)
           					Set RepDate         = $p(tmpInfPos,"^",9)
           					Set InfLocDesc		= $p(tmpInfPos,"^",8)
							Continue:InfDate=""
							Set:InfDate'="" InfDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfDate)
            				Set:InfXDate'="" InfXDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfXDate)
							Continue:$d(^TMP($zn,$j,NIndex,"DiagDr",tmpInfPosID)) // 输出去重
							Set ^TMP($zn,$j,NIndex,"DiagDr",tmpInfPosID)=""
							Set InfData=$lb(tmpInfPosDescs,InfDate,InfEffect,InfLocDesc,InfXDate,InfType,RepDate,RepUser)
							Set Data=PatData_InfData_TransInfo
							Set ^CacheTemp(repid,ind)=Data
							Set ind=ind+1
						}
					}
				}
			}
		}
    }
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryDishInfDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDishInfDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDishInfDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDishInfDtlExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：		zhoubo
/// CreateDate：	2021-05-19
/// Description:	出院患者明细
/// Input:        	aHospIDs： 多个医院用"|"连接
///               	aLocID     : 科室/病区ID
/// 				aStatUnit：日期单位，1:月, 2:季度, 3:年
///                 aDimensType :2012年
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.DishTrendStat","QryInfTrendPatDtl","","1","","2022年01月")
Query QryInfTrendPatDtl(aHospIDs As %String, aStatUnit As %String, aLocID As %Text, aDimensType As %String, aLocType As %String = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%Integer,TransLocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,InfFlag:%String") [ SqlProc ]
{
}

ClassMethod QryInfTrendPatDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aStatUnit As %String, aLocID As %Text, aDimensType As %String, aLocType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	If (aStatUnit=1) {
		//2021年04月
		Set DateYM=+aDimensType_"-"_$e(aDimensType,6,7)
		Set DateInfo=##class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(DateYM)
		Set aDateFrom = $p(DateInfo,"^",1)
		Set aDateTo   = $p(DateInfo,"^",2)
		
	}ElseIf(aStatUnit=2){
		//2021年2季度
		Set JDIndex=$e(aDimensType,6)
		If (JDIndex=1){
			Set aDateFrom =+aDimensType_"-01-01"
			Set aDateTo   =+aDimensType_"-03-31"
		}ElseIf (JDIndex=2){
			Set aDateFrom =+aDimensType_"-04-01"
			Set aDateTo   =+aDimensType_"-06-30"
		}
		ElseIf (JDIndex=3){
			Set aDateFrom =+aDimensType_"-07-01"
			Set aDateTo   =+aDimensType_"-09-30"
		}
		Else{
			Set aDateFrom =+aDimensType_"-10-01"
			Set aDateTo   =+aDimensType_"-12-31"
		}
	}ElseIf(aStatUnit=3){
		Set aDateFrom=+aDimensType_"-01-01"
		Set aDateTo=+aDimensType_"-12-31"
	}
	Quit:(aDateFrom="")||(aDateTo="") $$$OK

	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
 	Set aLocIDs=aLocID
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	
    Set NIndex="QryInfTrendPatDtl"
	Kill ^TMP($zn,$j,NIndex)
	// 查询出院患者
	Set xAdmType = ""
    For {
		Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
		Quit:xAdmType=""
		Continue:xAdmType'="I"
		
		For xDishDate = aDateFrom:1:aDateTo {
			Set xDishTime = ""
			For {
				Set xDishTime = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDishDate,xDishTime))
				Quit:xDishTime=""
				
				Set xPaadm = ""
				For {
					Set xPaadm = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDishDate,xDishTime,xPaadm))
					Quit:xPaadm=""
					
					Set PAAdmData =$g(^DHCHAI.DP.PAAdmD(xPaadm))
					Continue:PAAdmData=""
					Set VisitStatus = $lg(PAAdmData,19)
					Continue:(VisitStatus="P")||(VisitStatus="C")
					//就诊开始结束日期
					Set AdmDate   = $lg(PAAdmData,20)
					Set DischDate = $lg(PAAdmData,26)
	            	Set AdmTimes  = $lg(PAAdmData,38)   //就诊次数

					// 出院科室/病区
					Set DishLocID  = $lg(PAAdmData,28)
				    Set DishWardID = $lg(PAAdmData,29)
				    Set LocDr=DishLocID
				    Set:aLocType="W" LocDr=DishWardID
				    Continue:LocDr=""
				    Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocDr_","))
				   
					Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
					Set LocDesc	= $lg(LocData,3)
					Set LocDesc2= $lg(LocData,4)
					Set:LocDesc2'="" LocDesc=LocDesc2
					Set HospDr=$lg(LocData,8)
					Continue:HospDr=""
					//医院过滤
					Continue:(aHospIDs'="")&($listfind(aHospIDs,HospDr)<1)
					//医院分组过滤
					Set HospInfo="",HospGroupDr=""
					Set HospInfo=$g(^DHCHAI.BT.HospitalD(HospDr))
					Set HospGroupDr=$lg(HospInfo,5) 
					Continue:HospGroupDr=""
					Set HospGrpInfo=$g(^DHCHAI.BT.HospGroupD(HospGroupDr))     
				
					Set GroupDr = $li(LocData,7)
					If GroupDr="" {
						Set GroupDesc = "其他科"
						Set GroupDr   = $o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
					}
					Set GroupData=$g(^DHCHAI.BT.LocGroupD(GroupDr))
					Set GroupDesc=$li(GroupData,3)
					//按科室组、科室/病区过滤
				   
				   	//取统计维度
					Set DimensDesc=LocDesc  //科室、病区名称
					
					Set PatData=..BuildPaadmData(xPaadm)
					Continue:PatData=""
					Set InfFlag="否"
					Set tInfFlag=##class(DHCHAI.STATV2.AbstractComm).GetInfPosInfo(xPaadm,aDateFrom,aDateTo,1)
					Set:tInfFlag'="" InfFlag="是"
					Set TransInfoArr =..GetTransInfo(xPaadm,"","",aLocType)    //存在转科日期早于入院日期情况，取全部转科记录
					For TransInd=1:1:TransInfoArr.Count(){
						Set TransInfo=TransInfoArr.GetAt(TransInd)

						Set Data=$lb(DimensDesc,AdmTimes)_PatData_TransInfo_$lb(InfFlag)
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
			}
		}
    }
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryInfTrendPatDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfTrendPatDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfTrendPatDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfTrendPatDtlExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
