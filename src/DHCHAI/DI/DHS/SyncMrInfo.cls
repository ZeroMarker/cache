/// 名称: DHCHAI.DI.DHS.SyncMrInfo
/// 描述: 同步东华病案编目数据
/// 编写者：liyi
/// 编写日期: 2017-07-04
Class DHCHAI.DI.DHS.SyncMrInfo Extends (%RegisteredObject, DHCHAI.Abstract, User.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2017-07-05
/// Description:  根据日期同步东华手术编目信息
/// Input：       aDateFrom : 开始日期
/// 			  aDateTo：结束日期
/// Return：      处理同步手术编目的数量
/// w ##class(DHCHAI.DI.DHS.SyncMrInfo).SyncWMROperByDateAdm("MRS01","HIS01||141","2022-01-01","2022-11-10")
ClassMethod SyncWMROperByDateAdm(aSCode As %String, aEpisodeIDX As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aSCode,aEpisodeIDX,aDateFrom,aDateTo)
	Set return=0,Count=0
	Quit:aSCode="" return
	Quit:(aEpisodeIDX="")||(aDateFrom="")||(aDateTo="") return
	
	Set EpisodeID=$p(aEpisodeIDX,"||",2)
	Set HISCode=$p(aEpisodeIDX,"||",1)
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Quit:HISCode'=objSYS.BTHISCode return
	Set SYSType=objSYS.BTTypeDr.BTCode
	Quit:SYSType'="MRS" return  //病案管理系统（编目）
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	//就诊记录检查
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(aEpisodeIDX)
	Quit:'$IsObject(objAdm) return
	Set EpisodeDr=objAdm.%Id()
	
	Set WMRSystemVer=##class(DHCHAI.BT.Config).GetValByCode("DPWMRSystemVer")
	Quit:( WMRSystemVer'="WMR3.0")&&(WMRSystemVer'="WMR4.0") return
	Set sc=""
	Set rs=""
	Set rowData=##Class(%ArrayOfDataTypes).%New()
	If rowData'="" Do rowData.%Close()
	If WMRSystemVer="WMR3.0" {
		Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DIO.FromMrSrv:QryWMROprList")
		Set sc=rs.Execute(EpisodeID)
		If $$$ISERR(sc) {
	  		Do $System.Status.DisplayError(sc)
	  		Quit return
  		}
  		While (rs.Next()){
	    Do rowData.Clear()  //清空数组
	    Do rowData.SetAt(EpisodeID,"EpisodeID")
	    Do rowData.SetAt(EpisodeDr,"EpisodeDr")                  // 就诊号（DHCHAI.DP.PAAdm.ID）
		Do rowData.SetAt(rs.Data("OperID"),"OperID")             // 手术ID
		Do rowData.SetAt(rs.Data("OperICD"),"OperICD")           // 手术编码
		Do rowData.SetAt(rs.Data("OperDesc"),"OperDesc")         // 手术名称
		Do rowData.SetAt(rs.Data("OperType"),"OperType")         // 手术类型
		Do rowData.SetAt(rs.Data("OperDate"),"OperDate")         // 手术日期
		Do rowData.SetAt(rs.Data("SttTime"),"StartTime")         // 手术开始时间
		Do rowData.SetAt(rs.Data("EndDate"),"EndDate")           // 手术结束日期
		Do rowData.SetAt(rs.Data("EndTime"),"EndTime")           // 手术结束时间
		Do rowData.SetAt(rs.Data("OperHour"),"OperHour")         // 手术时长
		Do rowData.SetAt(rs.Data("OperLocCode"),"OperLocCode")   // 手术科室代码
		Do rowData.SetAt(rs.Data("OperLocDesc"),"OperLocDesc")   // 手术科室 
		Do rowData.SetAt(rs.Data("OpertorCode"),"OpertorCode")   // 术者代码
		Do rowData.SetAt(rs.Data("OpertorName"),"OpertorName")   // 术者名称
		Do rowData.SetAt(rs.Data("Assistant1"),"Assistant1")     // 一助
		Do rowData.SetAt(rs.Data("Assistant2"),"Assistant2")     // 二助
		Do rowData.SetAt(rs.Data("IncisionCode"),"IncisionCode") // 切口类型代码
		Do rowData.SetAt(rs.Data("Incision"),"Incision")         // 切口类型
		Set:rs.Data("Healing")="-" rs.Data("Healing")=""
		if (rs.Data("HealingCode")=""){							 //愈合情况代码
			Do rowData.SetAt(rs.Data("Healing"),"HealingCode")
		}else{
			Do rowData.SetAt(rs.Data("HealingCode"),"HealingCode") 
		}
		Do rowData.SetAt(rs.Data("Healing"),"Healing")           // 愈合情况
		Set:rs.Data("AnesMethod")="-" rs.Data("AnesMethod")=""
		if (rs.Data("AnesMethodCode")=""){						     // 麻醉方式代码	
			Do rowData.SetAt(rs.Data("AnesMethod"),"AnesMethodCode") 
		}else{
			Do rowData.SetAt(rs.Data("AnesMethodCode"),"AnesMethodCode") 
		}
		Do rowData.SetAt(rs.Data("AnesMethod"),"AnesMethod")     // 麻醉方式
		Do rowData.SetAt(rs.Data("Anesthesia"),"Anesthesia")     // 麻醉医生
		Do rowData.SetAt(rs.Data("ASAScore"),"ASAScore")         // ASA评分
		Do rowData.SetAt(rs.Data("NNISGrade"),"NNISGrade")       // NNIS分级
		Do rowData.SetAt("F","DataSource")                       // 数据来源（病案编目）
		
		//检查手术是否有效
		Set OperDesc=rowData.GetAt("OperDesc")
		Set Num =$L(OperDesc)
		Set FnOperDesc=OperDesc
		Set:Num>50 FnOperDesc=$e(OperDesc,1,50) //截取前50个字符
		Set objOperDxMap=##class(DHCHAI.DP.OROperDxMap).GetObjByOperDesc(aSCode,FnOperDesc)
		If $IsObject(objOperDxMap) {
			Continue:objOperDxMap.BTIsActive'=1
		}
		
		//保存手麻记录
		Set OperationDr=..SaveOperInfo(rowData,aSCode)
		Continue:(+OperationDr)<1
		
		//计数
		Set Count=Count+1
    	}
	} 
	If WMRSystemVer="WMR4.0" {
		Set DPMRSystemVer=##class(DHCHAI.BT.Config).GetValByCode("DPMRSystemVer")
		If (DPMRSystemVer="MRS2.0"){
	
		Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DIO.FromMrSrv:QryIPMROprList")
		Set sc=rs.Execute(EpisodeID)
	  	If $$$ISERR(sc) {
		  	Do $System.Status.DisplayError(sc)
		  	Quit return
	  	}
		Set rowData=##Class(%ArrayOfDataTypes).%New()
		If rowData'="" Do rowData.%Close()
	
	    While (rs.Next()){    
	    Do rowData.Clear()  //清空数组
	    Do rowData.SetAt(EpisodeID,"EpisodeID")
	    Do rowData.SetAt(EpisodeDr,"EpisodeDr")                  // 就诊号（DHCHAI.DP.PAAdm.ID）
		Do rowData.SetAt(rs.Data("OperID"),"OperID")             // 手术ID
		Do rowData.SetAt(rs.Data("OperICD"),"OperICD")           // 手术编码
		Do rowData.SetAt(rs.Data("OperDesc"),"OperDesc")         // 手术名称
		Do rowData.SetAt(rs.Data("OperType"),"OperType")         // 手术类型
		Do rowData.SetAt(rs.Data("OperDate"),"OperDate")         // 手术日期
		Do rowData.SetAt(rs.Data("SttTime"),"StartTime")         // 手术开始时间
		Do rowData.SetAt(rs.Data("EndDate"),"EndDate")           // 手术结束日期
		Do rowData.SetAt(rs.Data("EndTime"),"EndTime")           // 手术结束时间
		Do rowData.SetAt(rs.Data("OperHour"),"OperHour")         // 手术时长
		Do rowData.SetAt(rs.Data("OperLocCode"),"OperLocCode")   // 手术科室代码
		Do rowData.SetAt(rs.Data("OperLocDesc"),"OperLocDesc")   // 手术科室 
		Do rowData.SetAt(rs.Data("OpertorCode"),"OpertorCode")   // 术者代码
		Do rowData.SetAt(rs.Data("OpertorName"),"OpertorName")   // 术者名称
		Do rowData.SetAt(rs.Data("Assistant1"),"Assistant1")     // 一助
		Do rowData.SetAt(rs.Data("Assistant2"),"Assistant2")     // 二助
		Do rowData.SetAt(rs.Data("IncisionCode"),"IncisionCode") // 切口类型代码
		Do rowData.SetAt(rs.Data("Incision"),"Incision")         // 切口类型
		Set:rs.Data("Healing")="-" rs.Data("Healing")=""
		if (rs.Data("HealingCode")=""){							 //愈合情况代码
			Do rowData.SetAt(rs.Data("Healing"),"HealingCode")
		}else{
			Do rowData.SetAt(rs.Data("HealingCode"),"HealingCode") 
		}
		Do rowData.SetAt(rs.Data("Healing"),"Healing")           // 愈合情况
		Set:rs.Data("AnesMethod")="-" rs.Data("AnesMethod")=""
		if (rs.Data("AnesMethodCode")=""){						     // 麻醉方式代码	
			Do rowData.SetAt(rs.Data("AnesMethod"),"AnesMethodCode") 
		}else{
			Do rowData.SetAt(rs.Data("AnesMethodCode"),"AnesMethodCode") 
		}
		Do rowData.SetAt(rs.Data("AnesMethod"),"AnesMethod")     // 麻醉方式
		Do rowData.SetAt(rs.Data("Anesthesia"),"Anesthesia")     // 麻醉医生
		Do rowData.SetAt(rs.Data("ASAScore"),"ASAScore")         // ASA评分
		Do rowData.SetAt(rs.Data("NNISGrade"),"NNISGrade")       // NNIS分级
		Do rowData.SetAt("F","DataSource")                       // 数据来源（病案编目）
		
		//检查手术是否有效
		Set OperDesc=rowData.GetAt("OperDesc")
		Set Num =$L(OperDesc)
		Set FnOperDesc=OperDesc
		Set:Num>50 FnOperDesc=$e(OperDesc,1,50) //截取前50个字符
		Set objOperDxMap=##class(DHCHAI.DP.OROperDxMap).GetObjByOperDesc(aSCode,FnOperDesc)
		If $IsObject(objOperDxMap) {
			Continue:objOperDxMap.BTIsActive'=1
		}
	
		//保存手麻记录
		Set OperationDr=..SaveOperInfo(rowData,aSCode)
		Continue:(+OperationDr)<1
		
		//计数
		Set Count=Count+1
		}
	}
		If (DPMRSystemVer="MRS3.0"){
		Set rs=##Class(MA.IPMR.IO.OutService).GetICDAllByAdm(EpisodeID,"O")
		for ind = 1:1:$l(rs,$c(1)) {
			Set icdStr=$p(rs,$c(1),ind)
			Do rowData.Clear()  //清空数组
		    Do rowData.SetAt(EpisodeID,"EpisodeID")
		    Do rowData.SetAt(EpisodeDr,"EpisodeDr")                      	 // 就诊号（DHCHAI.DP.PAAdm.ID）
			Do rowData.SetAt($p(icdStr,$c(2),1),"OperICD")               	 // 手术ICD
			Do rowData.SetAt($p(icdStr,$c(2),2),"OperDesc")              	 // 手术名称
			Do rowData.SetAt($p(icdStr,$c(2),3),"OperDate")              	 // 手术日期
			Do rowData.SetAt($p(icdStr,$c(2),4),"IncisionCode")          	 // 切口类型代码
			Do rowData.SetAt($p(icdStr,$c(2),5),"Incision")              	 // 切口类型
			Do rowData.SetAt($p(icdStr,$c(2),6),"HealingCode")           	 // 愈合情况代码
			Do rowData.SetAt($p(icdStr,$c(2),7),"Healing")               	 // 愈合情况
			Do rowData.SetAt($p(icdStr,$c(2),8),"OperatorID")            	 // 术者ID
			Do rowData.SetAt($p(icdStr,$c(2),9),"OpertorName")			 	 // 术者
			Do rowData.SetAt($p(icdStr,$c(2),10),"AnesMethodCode")       	 // 麻醉方式代码
			Do rowData.SetAt($p(icdStr,$c(2),11),"AnesMethod")     	         // 麻醉方式
			Do rowData.SetAt($p(icdStr,$c(2),12),"IsSubOper")			 	 // 是否附加手术
			Do rowData.SetAt($p(icdStr,$c(2),13),"Assistant1ID")		 	 // 一助ID
			Do rowData.SetAt($p(icdStr,$c(2),14),"Assistant1")			     // 一助
			Do rowData.SetAt($p(icdStr,$c(2),15),"Assistant2ID")			 // 二助ID
			Do rowData.SetAt($p(icdStr,$c(2),16),"Assistant2")			 	 // 二助
			Do rowData.SetAt($p(icdStr,$c(2),17),"NarcosisDocID")			 // 麻醉医师ID
			Do rowData.SetAt($p(icdStr,$c(2),18),"Anesthesia")		 		 // 麻醉医师
			Do rowData.SetAt($p(icdStr,$c(2),19),"OperLevelCode")		 	 // 手术级别代码
			Do rowData.SetAt($p(icdStr,$c(2),20),"OperLevelDesc")		     // 手术级别
			Do rowData.SetAt($p(icdStr,$c(2),21),"StartTime")				 // 手术开始时间
			Do rowData.SetAt($p(icdStr,$c(2),22),"EndTime")				 	 // 手术结束时间
			Do rowData.SetAt($p(icdStr,$c(2),23),"EndDate")				 	 // 手术结束日期
			Do rowData.SetAt($p(icdStr,$c(2),24),"MainOperCode")			 // 是否主手术代码
			Do rowData.SetAt($p(icdStr,$c(2),25),"MainOperDesc")			 // 是否主手术
			Do rowData.SetAt($p(icdStr,$c(2),26),"TypeCode")				 // 手术类型代码
			Do rowData.SetAt($p(icdStr,$c(2),27),"TypeDesc")				 // 手术类型描述
			Do rowData.SetAt($p(icdStr,$c(2),28),"Index")				 	 // 手术序号
			Do rowData.SetAt($p(icdStr,$c(2),29),"AisOperID")			     // 临床手术ID
			Do rowData.SetAt($p(icdStr,$c(2),30),"NarcosisLevelCode")	     // 麻醉分级代码
			Do rowData.SetAt($p(icdStr,$c(2),31),"HealiNarcosisLevelDescng") // 麻醉分级描述
			Do rowData.SetAt($p(icdStr,$c(2),32),"OperSiteCode")			 // 手术部位代码
			Do rowData.SetAt($p(icdStr,$c(2),33),"OperSiteDesc")			 // 手术部位描述
			Do rowData.SetAt($p(icdStr,$c(2),34),"OperLocCode")				 // 术者所在科室代码
	        Do rowData.SetAt($p(icdStr,$c(2),35),"OperLocDesc")				 // 术者所在科室描述
	        Do rowData.SetAt($p(icdStr,$c(2),36),"BackOperCode")			 // 非计划重返手术代码
	        Do rowData.SetAt($p(icdStr,$c(2),37),"BackOperDesc")			 // 非计划重返手术描述
	        Do rowData.SetAt($p(icdStr,$c(2),38),"NNISLevelCode")			 // 手术风险等级代码
	        Do rowData.SetAt($p(icdStr,$c(2),39),"NNISLevelDesc")			 // 手术风险等级描述
	        Do rowData.SetAt($p(icdStr,$c(2),40),"OperTypeCode")			 // 手术类别代码
	        Do rowData.SetAt($p(icdStr,$c(2),41),"OperType")				 // 手术类别描述
	        Do rowData.SetAt($p(icdStr,$c(2),42),"OperHour")			     // 手术持续时间
	        Do rowData.SetAt($p(icdStr,$c(2),43),"IsEmergencyCode")			 // 是否急诊手术代码
	        Do rowData.SetAt($p(icdStr,$c(2),44),"IsEmergencyDesc")			 // 是否急诊手术描述
	        Do rowData.SetAt($p(icdStr,$c(2),45),"IsMiniInvaCode")			 // 是否微创手术代码
	        Do rowData.SetAt($p(icdStr,$c(2),46),"IsMiniInvaDesc")			 // 是否微创手术描述
	        Do rowData.SetAt($p(icdStr,$c(2),47),"IsChooseDateCode")		 // 是否择期手术代码
	        Do rowData.SetAt($p(icdStr,$c(2),48),"IsChooseDateDesc")		 // 是否择期手术描述
	        Do rowData.SetAt($p(icdStr,$c(2),49),"NarcosisSttDate")			 // 麻醉开始日期
	        Do rowData.SetAt($p(icdStr,$c(2),50),"NarcosisSttTime")			 // 麻醉开始时间
	        Do rowData.SetAt($p(icdStr,$c(2),51),"NarcosisEndDate")			 // 麻醉结束日期
	        Do rowData.SetAt($p(icdStr,$c(2),52),"NarcosisEndTime")			 // 麻醉结束时间
	        Do rowData.SetAt($p(icdStr,$c(2),53),"OperID")					 // 编目手术ID
	        Do rowData.SetAt("F","DataSource")                               //数据源
	        //检查手术是否有效
			Set OperDesc=rowData.GetAt("OperDesc")
			Set objOperDxMap=##class(DHCHAI.DP.OROperDxMap).GetObjByOperDesc(aSCode,OperDesc)
			If $IsObject(objOperDxMap) {
				Continue:objOperDxMap.BTIsActive'=1
			}
			//保存手麻记录
			Set OperationDr=..SaveOperInfo(rowData,aSCode)
			Continue:(+OperationDr)<1
			
			//计数
			Set Count=Count+1
			}	
		} 
	}
	Set return=Count
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2017-07-07
/// Description:  根据日期同步东华首页手术信息
/// Input：       aDateFrom : 开始日期
/// 			  aDateTo：结束日期
/// Return：      处理同步首页手术的数量
/// w ##class(DHCHAI.DI.DHS.SyncMrInfo).SyncEMROperByDateAdm("EMR01","HIS01||4","2022-07-11","2022-07-11")
ClassMethod SyncEMROperByDateAdm(aSCode As %String, aEpisodeIDX As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aSCode,aEpisodeIDX,aDateFrom,aDateTo)
	Set return=0,Count=0
	Quit:aSCode="" return
	Quit:(aEpisodeIDX="")||(aDateFrom="")||(aDateTo="") return
	
	Set EpisodeID=$p(aEpisodeIDX,"||",2)
	Set HISCode=$p(aEpisodeIDX,"||",1)
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Quit:HISCode'=objSYS.BTHISCode return
	Set SYSType=objSYS.BTTypeDr.BTCode
	Quit:SYSType'="EMR" return  //电子病历系统（首页）
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	//就诊记录检查
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(aEpisodeIDX)
	Quit:'$IsObject(objAdm) return
	Set EpisodeDr=objAdm.%Id()
	Set IsSyncTCMPage = ##class(DHCHAI.BT.Config).GetValByCode("DPEmrIsSyncTCMPage")  // 1：同步

 	Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DIO.FromMrSrv:QryEMROprList")
  	Set sc=rs.Execute(EpisodeID)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
    Set Flag=rs.Next()
  	If (Flag=0)&&(IsSyncTCMPage=1) {
	  	Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DIO.FromMrSrv:QryTCMEMROprList")    //中医住院病案首页
	  	Set sc=rs.Execute(EpisodeID)
	  	If $$$ISERR(sc) {
		  	Do $System.Status.DisplayError(sc)
		  	Quit return
	  	}
  	}
	Set rowData=##Class(%ArrayOfDataTypes).%New()
	If rowData'="" Do rowData.%Close()
    While (Flag||rs.Next()){
		Set Flag=0

	    Do rowData.Clear()  //清空数组
	    Do rowData.SetAt(EpisodeID,"EpisodeID")
	    Do rowData.SetAt(EpisodeDr,"EpisodeDr")                  // 就诊号（DHCHAI.DP.PAAdm.ID）
		Do rowData.SetAt(rs.Data("OperID"),"OperID")             // 手术ID
		Do rowData.SetAt(rs.Data("OperICD"),"OperICD")           // 手术编码
		Do rowData.SetAt(rs.Data("OperDesc"),"OperDesc")         // 手术名称
		Do rowData.SetAt(rs.Data("OperType"),"OperType")         // 手术类型
		Do rowData.SetAt(rs.Data("OperDate"),"OperDate")         // 手术日期
		Do rowData.SetAt(rs.Data("SttTime"),"StartTime")         // 手术开始时间
		Do rowData.SetAt(rs.Data("EndDate"),"EndDate")           // 手术结束日期
		Do rowData.SetAt(rs.Data("EndTime"),"EndTime")           // 手术结束时间
		Do rowData.SetAt(rs.Data("OperHour"),"OperHour")         // 手术时长
		Do rowData.SetAt(rs.Data("OperLocCode"),"OperLocCode")   // 手术科室代码
		Do rowData.SetAt(rs.Data("OperLocDesc"),"OperLocDesc")   // 手术科室 
		Do rowData.SetAt(rs.Data("OpertorCode"),"OpertorCode")   // 术者代码
		Do rowData.SetAt(rs.Data("OpertorName"),"OpertorName")   // 术者名称
		Do rowData.SetAt(rs.Data("Assistant1"),"Assistant1")     // 一助
		Do rowData.SetAt(rs.Data("Assistant2"),"Assistant2")     // 二助
		Do rowData.SetAt(rs.Data("IncisionCode"),"IncisionCode") // 切口类型代码
		Do rowData.SetAt(rs.Data("Incision"),"Incision")         // 切口类型
		Set:rs.Data("Healing")="-" rs.Data("Healing")=""
		if (rs.Data("HealingCode")=""){							 //愈合情况代码
			Do rowData.SetAt(rs.Data("Healing"),"HealingCode")
		}else{
			Do rowData.SetAt(rs.Data("HealingCode"),"HealingCode") 
		}
		Do rowData.SetAt(rs.Data("Healing"),"Healing")           // 愈合情况
		Set:rs.Data("AnesMethod")="-" rs.Data("AnesMethod")=""
		if (rs.Data("AnesMethodCode")=""){						     // 麻醉方式代码	
			Do rowData.SetAt(rs.Data("AnesMethod"),"AnesMethodCode")
		}else{
			Do rowData.SetAt(rs.Data("AnesMethodCode"),"AnesMethodCode") 
		}
		Do rowData.SetAt(rs.Data("AnesMethod"),"AnesMethod")     // 麻醉方式
		Do rowData.SetAt(rs.Data("Anesthesia"),"Anesthesia")     // 麻醉医生
		Do rowData.SetAt(rs.Data("ASAScore"),"ASAScore")         // ASA评分
		Do rowData.SetAt(rs.Data("NNISGrade"),"NNISGrade")       // NNIS分级
		Do rowData.SetAt("E","DataSource")                       // 数据来源（电子病历）
		
		//检查手术是否有效
		Set OperDesc=rowData.GetAt("OperDesc")
		Set Num =$L(OperDesc)
		Set FnOperDesc=OperDesc
		Set:Num>50 FnOperDesc=$e(OperDesc,1,50) //截取前50个字符
		Set objOperDxMap=##class(DHCHAI.DP.OROperDxMap).GetObjByOperDesc(aSCode,FnOperDesc)
		If $IsObject(objOperDxMap) {
			Continue:objOperDxMap.BTIsActive'=1
		}
		
		//保存首页手术记录
		Set OperationDr=..SaveOperInfo(rowData,aSCode)
		Continue:(+OperationDr)<1
		
		//计数
		Set Count=Count+1
    }
    
	Set return=Count
	Quit return
}

ClassMethod SaveOperInfo(rd As %ArrayOfDataTypes, aSCode As %String) As %String
{
	New (rd,aSCode)
	Set return=0
	Quit:(rd="")||(aSCode="") return
	
	Set $ZT="SaveOperInfoErr"
	
	Set EpisodeID      = rd.GetAt("EpisodeID")
	Set EpisodeDr      = rd.GetAt("EpisodeDr")
	Set XCode          = rd.GetAt("OperID")         // 手术记录ID
	Set OperICD        = rd.GetAt("OperICD")        // 手术编码
	Set OperDesc       = rd.GetAt("OperDesc")       // 手术名称
	Set OperType       = rd.GetAt("OperType")       // 手术类型
	Set OperDate       = rd.GetAt("OperDate")       // 手术日期
	Set StartTime      = rd.GetAt("StartTime")      // 手术开始时间
	Set EndDate        = rd.GetAt("EndDate")        // 手术结束日期
	Set EndTime        = rd.GetAt("EndTime")        // 手术结束时间
	Set OperHour       = rd.GetAt("OperHour")       // 手术时长
	Set OperLocID      = ""
	Set OperLocCode    = rd.GetAt("OperLocCode")    // 手术科室代码
	Set OperLocDesc    = rd.GetAt("OperLocDesc")    // 手术科室 
	Set OpertorID      = ""
	Set:rd.GetAt("OperatorID")'="" OperorID=rd.GetAt("OperatorID") //术者ID
	Set OpertorCode    = rd.GetAt("OpertorCode")    
	Set:rd.GetAt("OpertorCode")'="" OpertorCode=rd.GetAt("OpertorCode") //术者代码
	Set OpertorName    = rd.GetAt("OpertorName")    // 术者名称
	Set Assistant1     = rd.GetAt("Assistant1")     // 一助
	Set Assistant2     = rd.GetAt("Assistant2")     // 二助
	Set IncisionCode   = rd.GetAt("IncisionCode")   // 切口类型代码
	Set Incision       = rd.GetAt("Incision")       // 切口类型
	Set:Incision["/" Incision=$p(Incision,"/",1)
	Set HealingCode    = rd.GetAt("HealingCode")    // 愈合情况代码
	Set Healing        = rd.GetAt("Healing")        // 愈合情况
	Set:HealingCode["/" HealingCode=$p(HealingCode,"/",1)
	If (Incision="")&&(Healing["/") {
		Set Incision=$p(Healing,"/",1)
	}
	Set:Healing["/" Healing=$p(Healing,"/",2)
	Set:Healing="-" Healing=""
	Set AnesMethodCode = rd.GetAt("AnesMethodCode") // 麻醉方式代码
	Set AnesMethod     = rd.GetAt("AnesMethod")     // 麻醉方式
	Set:AnesMethod="-" AnesMethod=""
	Set Anesthesia     = rd.GetAt("Anesthesia")     // 麻醉医生
	Set:Anesthesia["^" Anesthesia=$tr(Anesthesia,"^","")
	Set:Anesthesia="-" Anesthesia=""
	Set ASAScore= ""
	Set:rd.GetAt("ASAScore")'="" ASAScore= rd.GetAt("ASAScore")       // ASA评分
	Set NNISGrade = ""
	Set:rd.GetAt("NNISGrade")'="" NNISGrade= rd.GetAt("NNISGrade")      // NNIS分级
	Set DataSource     = rd.GetAt("DataSource")     // 数据来源
	//补充新版数据
	Set OperTypeCode    	  = rd.GetAt("OperTypeCode")     			// 手术类别代码
	Set IsSubOper     	 	  = rd.GetAt("IsSubOper")          			// 是否附加手术
	Set Assistant1ID     	  = rd.GetAt("Assistant1ID")				// 一助ID
	Set Assistant2ID     	  = rd.GetAt("Assistant2ID")				// 二助ID
	Set NarcosisDocID     	  = rd.GetAt("NarcosisDocID") 				// 麻醉医师ID
	Set OperLevelCode     	  = rd.GetAt("OperLevelCode")				// 手术级别代码
	Set OperLevelDesc     	  = rd.GetAt("OperLevelDesc")				// 手术级别
	Set MainOperCode     	  = rd.GetAt("MainOperCode")				// 是否主手术代码
	Set MainOperDesc          = rd.GetAt("MainOperDesc")				// 是否主手术
	Set TypeCode    		  = rd.GetAt("TypeCode")					// 手术类型代码
	Set TypeDesc     		  = rd.GetAt("TypeDesc")					// 手术类型描述(操作，手术)
	Set Index     			  = rd.GetAt("Index")						// 手术序号
	Set AisOperID    		  = rd.GetAt("AisOperID")					// 临床手术ID(手麻表id)
	Set NarcosisLevelCode     = rd.GetAt("NarcosisLevelCode")			// 麻醉分级代码
	Set NarcosisLevelDesc 	  = rd.GetAt("NarcosisLevelDesc")			// 麻醉分级描述
	Set OperSiteCode     	  = rd.GetAt("OperSiteCode")				// 手术部位代码
	Set OperSiteDesc     	  = rd.GetAt("OperSiteDesc")				// 手术部位描述
	Set BackOperCode     	  = rd.GetAt("BackOperCode")				// 非计划重返手术代码
	Set BackOperDesc     	  = rd.GetAt("BackOperDesc")				// 非计划重返手术描述
	Set NNISLevelCode    	  = rd.GetAt("NNISLevelCode")				// 手术风险等级代码
	Set NNISLevelDesc    	  = rd.GetAt("NNISLevelDesc")				// 手术风险等级描述
	Set IsEmergencyCode       = rd.GetAt("IsEmergencyCode")				// 是否急诊手术代码
	Set IsEmergencyDesc       = rd.GetAt("IsEmergencyDesc")				// 是否急诊手术描述
	Set IsMiniInvaCode        = rd.GetAt("IsMiniInvaCode")				// 是否微创手术代码
	Set IsMiniInvaDesc        = rd.GetAt("IsMiniInvaDesc")				// 是否微创手术描述
	Set IsChooseDateCode      = rd.GetAt("IsChooseDateCode")			// 是否择期手术代码
	Set IsChooseDateDesc      = rd.GetAt("IsChooseDateDesc")			// 是否择期手术描述	
	Set NarcosisSttDate       = rd.GetAt("NarcosisSttDate")				// 麻醉开始日期
	Set NarcosisSttTime       = rd.GetAt("NarcosisSttTime")				// 麻醉开始时间
	Set NarcosisEndDate       = rd.GetAt("NarcosisEndDate")				// 麻醉结束日期
	Set NarcosisEndTime       = rd.GetAt("NarcosisEndTime")				// 麻醉结束时间
	Set:IncisionCode="" IncisionCode=Incision
	Quit:(XCode="")||(EpisodeDr="")||(OperDesc="")||(OperDate="") return
	
	//Set:StartTime="" StartTime=0
	//手术科室取手术时间时的就诊科室
	Set OperLocID=""
	
	Set OperLocInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,OperDate,StartTime)
	If (OperLocInfo'=""){
		Set OperLocType=##class(DHCHAI.BT.Config).GetValByCode("OPSDisplayLocType")
		Set indexNum=$CASE(OperLocType,"E":1,"W":2,:1) 			//1科室 2病区 默认1
		Set OperLocID=$p(OperLocInfo,"^",2) //病区
	}
	Set OperationDr=""
	Set objOperation=##class(DHCHAI.DP.OROperation).GetObjByXCode(aSCode,XCode)
	If $isobject(objOperation){
		Set OperationDr=objOperation.%Id()
	}
	
	//日期处理
	Set:EndDate="-" EndDate=""
	Set:EndDate["年" EndDate=$tr(EndDate,"年","-")
	Set:EndDate["月" EndDate=$tr(EndDate,"月","-")
	Set:EndDate["日" EndDate=$tr(EndDate,"日","")
	
	Set:EndTime["时" EndTime=$tr(EndTime,"时",":")
	Set:EndTime["分" EndTime=$tr(EndTime,"分",":")
	Set:EndTime["秒" EndTime=$tr(EndTime,"秒","")
	
	Set InputStr = OperationDr
	Set InputStr = InputStr_"^"_EpisodeDr
	Set InputStr = InputStr_"^"_OperICD
	Set InputStr = InputStr_"^"_OperDesc
	Set InputStr = InputStr_"^"_OperType
	Set InputStr = InputStr_"^"_OperDate
	Set InputStr = InputStr_"^"_StartTime
	Set InputStr = InputStr_"^"_EndDate
	Set InputStr = InputStr_"^"_EndTime
	Set InputStr = InputStr_"^"_OperHour
	Set InputStr = InputStr_"^"_OperLocID
	Set InputStr = InputStr_"^"_OperLocID_"|"_OperLocCode_"|"_OperLocDesc
	Set InputStr = InputStr_"^"_OpertorID_"|"_OpertorCode_"|"_OpertorName
	Set InputStr = InputStr_"^"_""_"|"_""_"|"_Assistant1
	Set InputStr = InputStr_"^"_""_"|"_""_"|"_Assistant2
	Set InputStr = InputStr_"^"_Incision
	Set InputStr = InputStr_"^"_Healing
	Set InputStr = InputStr_"^"_AnesMethod
	Set InputStr = InputStr_"^"_""_"|"_""_"|"_Anesthesia
	Set InputStr = InputStr_"^"_ASAScore
	Set InputStr = InputStr_"^"_NNISGrade
	Set InputStr = InputStr_"^"_DataSource
	Set InputStr = InputStr_"^"_aSCode
	Set InputStr = InputStr_"^"_XCode
	Set InputStr = InputStr_"^"_1     //是否有效
	Set InputStr = InputStr_"^"_+$h
	Set InputStr = InputStr_"^"_$p($h,",",2)
	
	Set InputStr = InputStr_"^"_OperTypeCode
	Set InputStr = InputStr_"^"_IsSubOper
	Set InputStr = InputStr_"^"_Assistant1ID
	Set InputStr = InputStr_"^"_Assistant2ID
	Set InputStr = InputStr_"^"_NarcosisDocID
	Set InputStr = InputStr_"^"_OperLevelCode
	Set InputStr = InputStr_"^"_OperLevelDesc
	Set InputStr = InputStr_"^"_MainOperCode
	Set InputStr = InputStr_"^"_MainOperDesc
	Set InputStr = InputStr_"^"_TypeCode
	Set InputStr = InputStr_"^"_TypeDesc
	Set InputStr = InputStr_"^"_Index
	Set InputStr = InputStr_"^"_AisOperID
	Set InputStr = InputStr_"^"_NarcosisLevelCode
	Set InputStr = InputStr_"^"_NarcosisLevelDesc
	Set InputStr = InputStr_"^"_OperSiteCode
	Set InputStr = InputStr_"^"_OperSiteDesc
	Set InputStr = InputStr_"^"_BackOperCode
	Set InputStr = InputStr_"^"_BackOperDesc
	Set InputStr = InputStr_"^"_NNISLevelCode
	Set InputStr = InputStr_"^"_NNISLevelDesc
	Set InputStr = InputStr_"^"_IsEmergencyCode
	Set InputStr = InputStr_"^"_IsEmergencyDesc
	Set InputStr = InputStr_"^"_IsMiniInvaCode
	Set InputStr = InputStr_"^"_IsMiniInvaDesc
	Set InputStr = InputStr_"^"_IsChooseDateCode
	Set InputStr = InputStr_"^"_IsChooseDateDesc
	Set InputStr = InputStr_"^"_NarcosisSttDate
	Set InputStr = InputStr_"^"_NarcosisSttTime
	Set InputStr = InputStr_"^"_NarcosisEndDate
	Set InputStr = InputStr_"^"_NarcosisEndTime
	Set OperationDr=##class(DHCHAI.DP.OROperation).Update(InputStr,"^")
	If (+OperationDr)<1 {
		//记录错误日志
		Set ErrClass  = "DHCHAI.DP.OROperation"
		Set ErrMethod = "Update"
		Set ErrArgStr = $lb(InputStr,"^")
		Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
	}
	Quit:(+OperationDr)<1 return
	Set return=OperationDr

	//保存手术对照（重复记录不再处理）
	If OperDesc'="" {
		//保存手术对照
		Set Num =$L(OperDesc)
		Set FnOperDesc=OperDesc
		Set:Num>50 FnOperDesc=$e(OperDesc,1,50) //截取前50个字符
		Set objOperDxMap=##class(DHCHAI.DP.OROperDxMap).GetObjByOperDesc(aSCode,FnOperDesc)
		If '$isobject(objOperDxMap){
			Set MapOperDxDr=""
			Set objMapOperDx=##class(DHCHAI.DP.OROperDx).GetObjByCodeDesc("",FnOperDesc)
			Set:$IsObject(objMapOperDx) MapOperDxDr=objMapOperDx.%Id()
			
			Set InputStr = ""
			Set InputStr = InputStr_"^"_FnOperDesc		// 手术名称
			Set InputStr = InputStr_"^"_MapOperDxDr		// 标准手术名称
			Set InputStr = InputStr_"^"_""				// 标准备注
			Set InputStr = InputStr_"^"_aSCode			// 子系统代码
			Set InputStr = InputStr_"^"_1				// 有效标志
			Set InputStr = InputStr_"^"_""				// 处置日期
			Set InputStr = InputStr_"^"_""				// 处置时间
			Set InputStr = InputStr_"^"_""				// 处置人
			Set OperDxMapDr=##class(DHCHAI.DP.OROperDxMap).Update(InputStr,"^")
			If (+OperDxMapDr)<1 {
				//记录错误日志
				Set ErrClass  = "DHCHAI.DP.OROperDxMap"
				Set ErrMethod = "Update"
				Set ErrArgStr = $lb(InputStr,"^")
				Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
			}
		}
	}
	
	// 手术类型对照（重复记录不再处理）
	If OperType'="" {
		Set InputStr=""
		Set $p(InputStr,"^",1)="OperType"  // 手术类型
		Set $p(InputStr,"^",2)=OperType
		Set $p(InputStr,"^",3)=OperType
		Set PhraseMapDr=##class(DHCHAI.DPS.PhraseMapSrv).SavePhraseMap(InputStr,aSCode)
		Set InputStr1=""
		Set $p(InputStr1,"^",1)="OperType"  // 手术类型
		Set $p(InputStr1,"^",2)=aSCode_"||"_OperType
		Set $p(InputStr1,"^",3)=OperType
		Set PhraseMapDr1=##class(DHCHAI.DPS.PhraseMapSrv).SaveMRPhraseMap(InputStr1,aSCode)
		If (+PhraseMapDr||+PhraseMapDr1)<1 {
			//记录错误日志
			Set ErrClass  = "DHCHAI.DPS.PhraseMapSrv"
			Set ErrMethod = "SavePhraseMap"
			Set ErrArgStr = $lb(InputStr,aSCode)
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
		}
	}
	
	//切口类型对照（重复记录不再处理）
	If Incision'="" {
		Set InputStr=""
		Set $p(InputStr,"^",1)="CuteType"  //切口类型
		Set $p(InputStr,"^",2)=IncisionCode
		Set $p(InputStr,"^",3)=Incision
		Set PhraseMapDr=##class(DHCHAI.DPS.PhraseMapSrv).SavePhraseMap(InputStr,aSCode)
		Set $p(InputStr,"^",2)=aSCode_"||"_IncisionCode
		
		Set InputStr1=""
		Set $p(InputStr1,"^",1)="CuteType"  // 手术类型
		Set $p(InputStr1,"^",2)=aSCode_"||"_IncisionCode
		Set $p(InputStr1,"^",3)=Incision
		Set PhraseMapDr1=##class(DHCHAI.DPS.PhraseMapSrv).SaveMRPhraseMap(InputStr1,aSCode)
		If (+PhraseMapDr||+PhraseMapDr1)<1 {
			//记录错误日志
			Set ErrClass  = "DHCHAI.DPS.PhraseMapSrv"
			Set ErrMethod = "SavePhraseMap"
			Set ErrArgStr = $lb(InputStr,aSCode)
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
		}
	}
	
	//愈合情况对照（重复记录不再处理）
	If Healing'="" {
		Set InputStr=""
		Set $p(InputStr,"^",1)="CuteHealing"  //愈合情况
		Set $p(InputStr,"^",2)=HealingCode
		Set $p(InputStr,"^",3)=Healing
		Set PhraseMapDr=##class(DHCHAI.DPS.PhraseMapSrv).SavePhraseMap(InputStr,aSCode)
		Set InputStr1=""
		Set $p(InputStr1,"^",1)="CuteHealing"  // 
		Set $p(InputStr1,"^",2)=aSCode_"||"_HealingCode
		Set $p(InputStr1,"^",3)=Healing
		Set PhraseMapDr1=##class(DHCHAI.DPS.PhraseMapSrv).SaveMRPhraseMap(InputStr1,aSCode)
		If (+PhraseMapDr||+PhraseMapDr1)<1 {
			//记录错误日志
			Set ErrClass  = "DHCHAI.DPS.PhraseMapSrv"
			Set ErrMethod = "SavePhraseMap"
			Set ErrArgStr = $lb(InputStr,aSCode)
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
		}
	}
	
	//麻醉方式对照（重复记录不再处理）
	If AnesMethod'="" {
		Set InputStr=""
		Set $p(InputStr,"^",1)="Anesthesia"  //麻醉方式
		Set $p(InputStr,"^",2)=AnesMethodCode
		Set $p(InputStr,"^",3)=AnesMethod
		Set PhraseMapDr=##class(DHCHAI.DPS.PhraseMapSrv).SavePhraseMap(InputStr,aSCode)
		Set InputStr1=""
		Set $p(InputStr1,"^",1)="Anesthesia"  // 
		Set $p(InputStr1,"^",2)=aSCode_"||"_AnesMethodCode
		Set $p(InputStr1,"^",3)=AnesMethod
		Set PhraseMapDr1=##class(DHCHAI.DPS.PhraseMapSrv).SaveMRPhraseMap(InputStr1,aSCode)
		If (+PhraseMapDr||+PhraseMapDr1)<1 {
			//记录错误日志
			Set ErrClass  = "DHCHAI.DPS.PhraseMapSrv"
			Set ErrMethod = "SavePhraseMap"
			Set ErrArgStr = $lb(InputStr,aSCode)
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
		}
	}
	
	//ASA评分对照（重复记录不再处理）
	If ASAScore'="" {
		Set InputStr=""
		Set $p(InputStr,"^",1)="ASAScore"  //ASA评分
		Set $p(InputStr,"^",2)=ASAScore
		Set $p(InputStr,"^",3)=ASAScore
		Set PhraseMapDr=##class(DHCHAI.DPS.PhraseMapSrv).SavePhraseMap(InputStr,aSCode)
		Set InputStr1=""
		Set $p(InputStr1,"^",1)="ASAScore"  // 手术类型
		Set $p(InputStr1,"^",2)=aSCode_"||"_ASAScore
		Set $p(InputStr1,"^",3)=ASAScore
		If (+PhraseMapDr||+PhraseMapDr1)<1 {
			//记录错误日志
			Set ErrClass  = "DHCHAI.DPS.PhraseMapSrv"
			Set ErrMethod = "SavePhraseMap"
			Set ErrArgStr = $lb(InputStr,aSCode)
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
		}
	}
	
	//NNIS分级对照（重复记录不再处理）
	If NNISGrade'="" {
		Set InputStr=""
		Set $p(InputStr,"^",1)="NNISLevel"  //NNIS分级
		Set $p(InputStr,"^",2)=NNISGrade
		Set $p(InputStr,"^",3)=NNISGrade
		Set PhraseMapDr=##class(DHCHAI.DPS.PhraseMapSrv).SavePhraseMap(InputStr,aSCode)
		Set InputStr1=""
		Set $p(InputStr1,"^",1)="NNISLevel"  // 手术类型
		Set $p(InputStr1,"^",2)=aSCode_"||"_NNISGrade
		Set $p(InputStr1,"^",3)=NNISGrade
		If (+PhraseMapDr||+PhraseMapDr1)<1 {
			//记录错误日志
			Set ErrClass  = "DHCHAI.DPS.PhraseMapSrv"
			Set ErrMethod = "SavePhraseMap"
			Set ErrArgStr = $lb(InputStr,aSCode)
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
		}
	}
	
	Quit return
	
SaveOperInfoErr
	Set return="-999^"_$ZError
	Quit return
}

}
