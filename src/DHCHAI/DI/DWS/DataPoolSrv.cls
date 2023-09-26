/// Name:         DHCHAI.DI.DWS.DataPoolSrv
/// Creator：     zhoubo
/// CreatDate：   2017-07-20
/// Description:  东华数字医疗-医院感染系统信息服务
Class DHCHAI.DI.DWS.DataPoolSrv Extends (%RegisteredObject, DHCHAI.Abstract, User.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2017-07-13
/// Description:  三方系统,保存患者日常病程信息
/// Input：       XML格式的患者日常病程信息
/// Return：      处理数据条数
/// w ##class(DHCHAI.DI.DWS.DataPoolSrv).SyncDailyCourseByXML("")
ClassMethod SyncDailyCourseByXML(aSCode As %String, aInput As %String) As %String
{
	New (aSCode,aInput)
	Set return=""
	Quit:(aSCode="")||(aInput="") return
	
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Set SYSType=objSYS.BTTypeDr.BTCode
	
	Kill arrData
	//Set aInput = "<Response><Item><CourseID>1</CourseID><EpisodeID>20</EpisodeID><Title>主治医师查房记录</Title><CourseDate>2017-07-12</CourseDate><Course>内容</Course><ActDate>2017-07-11</ActDate><ActTime>12:23:23</ActTime><ActUser>记录人员</ActUser><IsActive>1</IsActive></Item></Response>"
	Do ##Class(DHCHAI.Utils.XMLReaderSrv).GetListByXML(aInput,.arrData)
	Set Count=0
	Set xItmID=""
	For {
		Set xItmID=$o(arrData(xItmID))
		Quit:xItmID=""
		
		Set XCode      	= $g(arrData(xItmID,"CourseID"))      // 病程记录ID
		Set EpisodeID   = $g(arrData(xItmID,"EpisodeID"))     // HIS就诊ID
		Set (EpisodeDr,DailyCourseDr) =""
		Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(aSCode_"||"_EpisodeID)
		If $IsObject(objAdm){
			Set EpisodeDr=objAdm.%Id()
		}
		Set objDailyCourse = ##class(DHCHAI.DP.EmrDailyCourse).GetObjByXCode(aSCode,XCode)
		If $IsObject(objDailyCourse){
			Set DailyCourseDr=objDailyCourse.%Id()
		}
		Set InputStr = DailyCourseDr
		Set InputStr = InputStr_..#SEPARATE_EpisodeDr							// 就诊记录指针
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"Title"))         // 标题
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"CourseDate"))    // 病程日期
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"Course"))        // 病程内容
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"ActDate"))       // 发生日期
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"ActTime"))       // 发生时间
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"ActUser"))       // 记录医生
		Set InputStr = InputStr_..#SEPARATE_aSCode								// 子系统代码
		Set InputStr = InputStr_..#SEPARATE_XCode								// 记录索引码
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"IsActive")) 		// 有效标志
		Set InputStr = InputStr_..#SEPARATE_+$h
		Set InputStr = InputStr_..#SEPARATE_+$p($h,",",2)
		Set ret = ##class(DHCHAI.DP.EmrDailyCourse).Update(InputStr,..#SEPARATE)
		if ret>0 {
			// 保存成功！
			Set Count = Count+1
		}else{
			//记录错误日志
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,"DHCHAI.DP.EmrDailyCourse","Update",$lb(InputStr,..#SEPARATE))
		}
	}
	Kill arrData
	Quit Count
}

/// Creator：     zhoubo
/// CreatDate：   2017-07-13
/// Description:  三方系统,保存患者首次病程信息
/// Input：       XML格式的患者首次病程信息
/// Return：      处理数据条数
/// w ##class(DHCHAI.DI.DWS.DataPoolSrv).SyncFirstCourseByXML("")
ClassMethod SyncFirstCourseByXML(aSCode As %String, aInput As %String) As %String
{
	New (aSCode,aInput)
	Set return=""
	Quit:(aSCode="")||(aInput="") return
	
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Set SYSType=objSYS.BTTypeDr.BTCode
	
	Kill arrData
	//Set aInput="<Response><Item><CourseID>1</CourseID><EpisodeID>20</EpisodeID><Course>内容</Course><ActDate>2017-07-12</ActDate><ActTime>12:23:23</ActTime><ActUser>记录人员</ActUser><IsActive>1</IsActive></Item></Response>"
	Do ##Class(DHCHAI.Utils.XMLReaderSrv).GetListByXML(aInput,.arrData)
	Set Count=0
	Set xItmID=""
	For {
		Set xItmID=$o(arrData(xItmID))
		Quit:xItmID=""
		
		Set XCode	      = $g(arrData(xItmID,"CourseID"))      // 病程记录ID
		Set EpisodeID     = $g(arrData(xItmID,"EpisodeID"))     // HIS就诊ID
		Set (EpisodeDr,FirstCourseDr) =""
		Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(aSCode_"||"_EpisodeID)
		If $IsObject(objAdm){
			Set EpisodeDr=objAdm.%Id()
		}
		Set objFirstCourse = ##class(DHCHAI.DP.EmrFirstCourse).GetObjByXCode(aSCode,XCode)
		If $IsObject(objFirstCourse){
			Set FirstCourseDr=objFirstCourse.%Id()
		}
		Set InputStr = FirstCourseDr
		Set InputStr = InputStr_..#SEPARATE_EpisodeDr							// 就诊记录指针
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"Course"))        // 病程内容
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"ActDate"))       // 发生日期
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"ActTime"))       // 发生时间
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"ActUser"))       // 记录医生
		Set InputStr = InputStr_..#SEPARATE_aSCode								// 子系统代码
		Set InputStr = InputStr_..#SEPARATE_XCode								// 记录索引码
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"IsActive")) 		// 有效标志
		Set InputStr = InputStr_..#SEPARATE_+$h
		Set InputStr = InputStr_..#SEPARATE_+$p($h,",",2)
		Set ret = ##class(DHCHAI.DP.EmrFirstCourse).Update(InputStr,..#SEPARATE)
		if ret>0 {
			// 保存成功！
			Set Count = Count+1
		}else{
			//记录错误日志
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,"DHCHAI.DP.EmrFirstCourse","Update",$lb(InputStr,..#SEPARATE))
		}
	}
	Kill arrData
	Quit Count
}

/// Creator：     zhoubo
/// CreatDate：   2017-07-13
/// Description:  三方系统,保存患者病案编目手术信息
/// Input：       XML格式的患者病案编目手术信息
/// Return：      处理数据条数
/// w ##class(DHCHAI.DI.DWS.DataPoolSrv).SyncWMROperByXML("")
ClassMethod SyncWMROperByXML(aSCode As %String, aInput As %String) As %String
{
	New (aSCode,aInput)
	Set return=""
	Quit:(aSCode="")||(aInput="") return
	
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Set SYSType=objSYS.BTTypeDr.BTCode
	
	Kill arrData
	//Set aInput = "<Response><Item><OperID>2||2</OperID><EpisodeID>20</EpisodeID><OperICD>342D.342</OperICD><OperDesc>阑尾炎切除手术</OperDesc><OperType>急诊</OperType><StartDate>2017-07-13</StartDate><StartTime>09:34:34</StartTime><EndDate>2017-07-13</EndDate><EndTime>10:34:34</EndTime><OperHour>4</OperHour><OperLocCode>LocCode</OperLocCode><OperLocDesc>手术科室1</OperLocDesc><OpertorCode>Code001</OpertorCode><OpertorName>周波</OpertorName><Assistant1>周波1</Assistant1><Assistant2>周波2</Assistant2><IncisionCode>1</IncisionCode><Incision>I</Incision><HealingCode>1</HealingCode><Healing>愈合情况1</Healing><AnesMethodCode>1</AnesMethodCode><AnesMethod>麻醉方式1</AnesMethod><Anesthesia>麻醉医师周波</Anesthesia><ASAScore>99</ASAScore><NNISGrade>一级</NNISGrade></Item><Item><OperID>2||11</OperID><EpisodeID>49</EpisodeID><OperICD>342D.342</OperICD><OperDesc>阑尾炎的顶顶顶顶顶切除手术</OperDesc><OperType>急ddd诊</OperType><StartDate>2017-07-13</StartDate><StartTime>09:34:34</StartTime><EndDate>2017-07-13</EndDate><EndTime>10:34:34</EndTime><OperHour>4</OperHour><OperLocCode>LocCode</OperLocCode><OperLocDesc>手术科室1</OperLocDesc><OpertorCode>Code001</OpertorCode><OpertorName>周波</OpertorName><Assistant1>周波1</Assistant1><Assistant2>周波2</Assistant2><IncisionCode>1</IncisionCode><Incision>I</Incision><HealingCode>1</HealingCode><Healing>愈合情况1</Healing><AnesMethodCode>1</AnesMethodCode><AnesMethod>麻醉方式1</AnesMethod><Anesthesia>麻醉医师周波</Anesthesia><ASAScore>99</ASAScore><NNISGrade>一级</NNISGrade></Item></Response>"
	Do ##Class(DHCHAI.Utils.XMLReaderSrv).GetListByXML(aInput,.arrData)
	Set Count=0
	
	Set xItmID=""
	For {
		Set xItmID=$o(arrData(xItmID))
		Quit:xItmID=""
		
		Do SaveOperation
		
		Set CuteTypeCode  = $g(arrData(xItmID,"IncisionCode"))     	// 切口类型代码
		Set CuteTypeDesc  = $g(arrData(xItmID,"Incision"))     		// 切口类型名称
		Set:CuteTypeCode="" CuteTypeCode=CuteTypeDesc     			// 切口类型
		Do SavePhraseMap(aSCode,"CuteType",CuteTypeCode,CuteTypeDesc)
		
		Set OperTypeCode     = $g(arrData(xItmID,"OperType"))           // 手术类型代码
		Set OperTypeDesc     = $g(arrData(xItmID,"OperType"))           // 手术类型名称
		Do SavePhraseMap(aSCode,"OperType",OperTypeCode,OperTypeDesc)
		
		Set CuteHealingCode  = $g(arrData(xItmID,"HealingCode"))    // 愈合情况代码
		Set CuteHealingDesc  = $g(arrData(xItmID,"Healing"))        // 愈合情况名称
		Set:CuteHealingCode="" CuteHealingCode=CuteHealingDesc      // 愈合情况
		Do SavePhraseMap(aSCode,"CuteHealing",CuteHealingCode,CuteHealingDesc)
		
		Set AnesthesiaCode  = $g(arrData(xItmID,"AnesMethodCode"))  // 麻醉方式代码
		Set AnesthesiaDesc  = $g(arrData(xItmID,"AnesMethod"))      // 麻醉方式名称
		Set:AnesthesiaCode="" AnesthesiaCode=AnesthesiaDesc         // 麻醉方式
		Do SavePhraseMap(aSCode,"Anesthesia",AnesthesiaCode,AnesthesiaDesc)
		
		Set ASAScoreCode  = $g(arrData(xItmID,"ASAScore"))           // ASA评分代码  代码和名称一样P1、P2....
		Set ASAScoreDesc  = $g(arrData(xItmID,"ASAScore"))           // ASA评分名称
		Set:ASAScoreCode="" ASAScoreCode=ASAScoreDesc                // ASA评分
		Do SavePhraseMap(aSCode,"ASAScore",ASAScoreCode,ASAScoreDesc)
		
		Set NNISLevelCode  = $g(arrData(xItmID,"NNISGrade"))         // NNIS分级代码  NNIS分级代码名称一样
		Set NNISLevelDesc  = $g(arrData(xItmID,"NNISGrade"))         // NNIS分级名称
		Set:NNISLevelCode="" NNISLevelCode=NNISLevelDesc             // NNIS分级
		Do SavePhraseMap(aSCode,"NNISLevel",NNISLevelCode,NNISLevelDesc)
	}
	Kill arrData
	Quit Count
	
SaveOperation
	Set XCode       = $g(arrData(xItmID,"OperID"))		// 手术记录ID
	Set EpisodeID   = $g(arrData(xItmID,"EpisodeID")) 	// HIS就诊ID
	Set OperLocID   = ""
	Set OperLocCode = $g(arrData(xItmID,"OperLocCode")) // 手术科室代码
	Set OperLocDesc = $g(arrData(xItmID,"OperLocDesc")) // 手术科室
	Set OpertorID   = ""
	Set OpertorName = $g(arrData(xItmID,"OpertorName")) // 术者
	Set OpertorCode = $g(arrData(xItmID,"OpertorCode")) // 术者代码
	
	Set OperLocDr=""
	Set objOperLoc=##class(DHCHAI.BT.Location).GetObjByLocCode(aSCode,OperLocCode)
	If $IsObject(objOperLoc) {
		Set OperLocDr=objOperLoc.%Id()
	}
		
	Set OROperationDr=""
	Set objOROperation = ##class(DHCHAI.DP.OROperation).GetObjByXCode(aSCode,XCode)
	If $IsObject(objOROperation){
		Set OROperationDr=objOROperation.%Id()
	}
	Set EpisodeDr=""
	Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(aSCode_"||"_EpisodeID)
	If $IsObject(objAdm){
		Set EpisodeDr=objAdm.%Id()
	}
	Set InputStr = OROperationDr
	Set InputStr = InputStr_..#SEPARATE_EpisodeDr
	Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"OperICD"))	  // 手术编码
	Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"OperDesc"))	  // 手术名称
	Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"OperType"))	  // 手术类型
	Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"StartDate"))   // 手术开始日期
	Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"StartTime"))   // 手术开始时间
	Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"EndDate"))	  // 手术结束日期
	Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"EndTime")) 	  // 手术结束时间
	Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"OperHour")) 	  // 手术时长(小时)
	Set InputStr = InputStr_..#SEPARATE_OperLocDr                         // 手术科室
	Set InputStr = InputStr_..#SEPARATE_OperLocID_"|"_OperLocCode_"|"_OperLocDesc // 手术科室
	Set InputStr = InputStr_..#SEPARATE_OpertorID_"|"_OpertorCode_"|"_OpertorName // 术者
	Set InputStr = InputStr_..#SEPARATE_""_"|"_""_"|"_$g(arrData(xItmID,"Assistant1"))  // 1助
	Set InputStr = InputStr_..#SEPARATE_""_"|"_""_"|"_$g(arrData(xItmID,"Assistant2"))  // 2助
	Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"Incision"))	  // 切口等级
	Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"Healing")) 	  // 愈合情况
	Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"AnesMethod"))  // 麻醉方式
	Set InputStr = InputStr_..#SEPARATE_""_"|"_""_"|"_$g(arrData(xItmID,"Anesthesia"))  // 麻醉医师
	Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"ASAScore"))    // ASA评分
	Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"NNISGrade"))   // NNIS分级
	Set InputStr = InputStr_..#SEPARATE_"F"   						      // 手术来源编目
	Set InputStr = InputStr_..#SEPARATE_aSCode						      // 子系统代码
	Set InputStr = InputStr_..#SEPARATE_XCode						      // 记录索引码
	Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"IsActive")) 	  // 有效标志
	Set InputStr = InputStr_..#SEPARATE_+$h
	Set InputStr = InputStr_..#SEPARATE_+$p($h,",",2)
	Set ret = ##class(DHCHAI.DP.OROperation).Update(InputStr,..#SEPARATE)
	if ret>0 {
		Set Count = Count+1
	}else{
		//记录错误日志
		Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,"DHCHAI.DP.OROperation","Update",$lb(InputStr,..#SEPARATE))
	}
	Quit ret
	
SavePhraseMap(aSCode,PhraseType,PhraseCode,PhraseDesc)
	//New (aSCode,PhraseType,PhraseCode,PhraseDesc)
	Set (PhraseMapDr,PhraseTypeDr) = ""
	Quit:(aSCode="")||(PhraseType="")||(PhraseCode="")||(PhraseDesc="") PhraseMapDr
	
	Set objPhraseType = ##class(DHCHAI.DP.PhraseType).GetObjByCodeDesc(PhraseType,"")
	If $Isobject(objPhraseType){
		Set PhraseTypeDr = objPhraseType.%Id()
	}
	Quit:PhraseTypeDr="" PhraseMapDr
	
	Set objPhraseMap = ##class(DHCHAI.DP.PhraseMap).GetObjByCode(aSCode,PhraseTypeDr,PhraseCode)
	If $isobject(objPhraseMap){
		Set PhraseMapDr = objPhraseMap.%Id()
	}else{
		Set InputStr = PhraseMapDr
		Set InputStr = InputStr_..#SEPARATE_PhraseCode
		Set InputStr = InputStr_..#SEPARATE_PhraseDesc
		Set InputStr = InputStr_..#SEPARATE_PhraseTypeDr
		Set InputStr = InputStr_..#SEPARATE_""
		Set InputStr = InputStr_..#SEPARATE_aSCode
		Set InputStr = InputStr_..#SEPARATE_1
		Set InputStr = InputStr_..#SEPARATE_+$h
		Set InputStr = InputStr_..#SEPARATE_$p($h,",",2)
		Set InputStr = InputStr_..#SEPARATE_""
		Set PhraseMapDr = ##class(DHCHAI.DP.PhraseMap).Update(InputStr,..#SEPARATE)
		If (PhraseMapDr<=0) {
			// 记录错误日志
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,"DHCHAI.DP.PhraseMap","Update",$lb(InputStr,..#SEPARATE))
		}
	}
	Quit PhraseMapDr
}

/// Creator：     zhoubo
/// CreatDate：   2017-07-17
/// Description:  三方系统,保存患者电子病历手术信息
/// Input：       XML格式的患者电子病历手术信息
/// Return：      处理数据条数
/// w ##class(DHCHAI.DI.DWS.DataPoolSrv).SyncEMROperByXML("")
ClassMethod SyncEMROperByXML(aSCode As %String, aInput As %String) As %String
{
	New (aSCode,aInput)
	Set return=""
	Quit:(aSCode="")||(aInput="") return
	
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Set SYSType=objSYS.BTTypeDr.BTCode
	
	Kill arrData
	//Set aInput="<Response><Item><OperID>2||2</OperID><EpisodeID>60</EpisodeID><OperICD>342D11.342</OperICD><OperDesc>阑尾炎切除手术</OperDesc><OperType>择期</OperType><StartDate>2017-08-31</StartDate><StartTime>09:34:34</StartTime><EndDate>2017-08-31</EndDate><EndTime>10:34:34</EndTime><OperHour>4</OperHour><OperLocCode>LocCode</OperLocCode><OperLocDesc>内一科</OperLocDesc><OpertorCode>Code001</OpertorCode><OpertorName>周波</OpertorName><Assistant1>周波1</Assistant1><Assistant2>周波2</Assistant2><IncisionCode>1</IncisionCode><Incision>I</Incision><HealingCode>1</HealingCode><Healing>愈合情况1</Healing><AnesMethodCode>1</AnesMethodCode><AnesMethod>麻醉方式1</AnesMethod><Anesthesia>麻醉医师周波</Anesthesia><ASAScore>99</ASAScore><NNISGrade>一级</NNISGrade></Item><Item><OperID>21||11</OperID><EpisodeID>68</EpisodeID><OperICD>342D.342</OperICD><OperDesc>阑尾炎的顶顶顶顶顶切除手术</OperDesc><OperType>急ddd诊</OperType><StartDate>2017-08-31</StartDate><StartTime>09:34:34</StartTime><EndDate>2017-08-31</EndDate><EndTime>10:34:34</EndTime><OperHour>4</OperHour><OperLocCode>LocCode</OperLocCode><OperLocDesc>产科</OperLocDesc><OpertorCode>Code001</OpertorCode><OpertorName>周波</OpertorName><Assistant1>周波1</Assistant1><Assistant2>周波2</Assistant2><IncisionCode>1</IncisionCode><Incision>I</Incision><HealingCode>1</HealingCode><Healing>愈合情况1</Healing><AnesMethodCode>1</AnesMethodCode><AnesMethod>麻醉方式1</AnesMethod><Anesthesia>麻醉医师周波</Anesthesia><ASAScore>99</ASAScore><NNISGrade>一级</NNISGrade></Item></Response>"
	Do ##Class(DHCHAI.Utils.XMLReaderSrv).GetListByXML(aInput,.arrData)
	Set Count=0
	
	Set xItmID=""
	For {
		Set xItmID=$o(arrData(xItmID))
		Quit:xItmID=""
		
		Do SaveOperation
		
		Set CuteTypeCode  = $g(arrData(xItmID,"IncisionCode"))         	 // 切口类型代码
		Set CuteTypeDesc  = $g(arrData(xItmID,"Incision"))     		     // 切口类型名称
		Set:CuteTypeCode="" CuteTypeCode=CuteTypeDesc     			     // 切口类型
		Do SavePhraseMap(aSCode,"CuteType",CuteTypeCode,CuteTypeDesc)
		
		Set CuteHealingCode  = $g(arrData(xItmID,"HealingCode"))         // 愈合情况代码
		Set CuteHealingDesc  = $g(arrData(xItmID,"Healing"))             // 愈合情况名称
		Set:CuteHealingCode="" CuteHealingCode=CuteHealingDesc           // 愈合情况
		Do SavePhraseMap(aSCode,"CuteHealing",CuteHealingCode,CuteHealingDesc)
		
		Set AnesthesiaCode  = $g(arrData(xItmID,"AnesMethodCode"))       // 麻醉方式代码
		Set AnesthesiaDesc  = $g(arrData(xItmID,"AnesMethod"))           // 麻醉方式名称
		Set:AnesthesiaCode="" AnesthesiaCode=AnesthesiaDesc              // 麻醉方式
		Do SavePhraseMap(aSCode,"Anesthesia",AnesthesiaCode,AnesthesiaDesc)
		
		Set ASAScoreCode  = $g(arrData(xItmID,"ASAScore"))               // ASA评分代码  代码和名称一样P1、P2....
		Set ASAScoreDesc  = $g(arrData(xItmID,"ASAScore"))               // ASA评分名称
		Set:ASAScoreCode="" ASAScoreCode=ASAScoreDesc                    // ASA评分
		Do SavePhraseMap(aSCode,"ASAScore",ASAScoreCode,ASAScoreDesc)
		
		Set NNISLevelCode  = $g(arrData(xItmID,"NNISGrade"))             // NNIS分级代码  NNIS分级代码名称一样
		Set NNISLevelDesc  = $g(arrData(xItmID,"NNISGrade"))             // NNIS分级名称
		Set:NNISLevelCode="" NNISLevelCode=NNISLevelDesc                 // NNIS分级
		Do SavePhraseMap(aSCode,"NNISLevel",NNISLevelCode,NNISLevelDesc)
	}
	Kill arrData
	Quit Count
}

/// Creator：     zhoubo
/// CreatDate：   2017-07-12
/// Description:  三方系统,保存患者护理信息
/// Input：       XML格式的患者护理信息
/// Return：      处理数据条数
/// w ##class(DHCHAI.DI.DWS.DataPoolSrv).SyncNisInfoByXML("")
ClassMethod SyncNisInfoByXML(aSCode As %String, aInput As %String) As %String
{
	New (aSCode,aInput)
	Set return=""
	Quit:(aSCode="")||(aInput="") return
	
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Set SYSType=objSYS.BTTypeDr.BTCode
	
	Kill arrData
	
	//Set aInput="<Response><Item><TempID>2||1</TempID><EpisodeID>20</EpisodeID><Code>NISCowwwwwwwwwwde2</Code><Desc>NISNaw3333333333333me2</Desc><Value>39℃</Value><EntryDate>2017-07-04</EntryDate><EntryTime>12:12:34</EntryTime><EntryUserCode>INPCode</EntryUserCode><EntryUser>INPName</EntryUser><IsActive>1</IsActive></Item><Item><TempID>3||3</TempID><EpisodeID>49</EpisodeID><Code>NISC11111ode2</Code><Desc>NISN2222ame2</Desc><Value>35℃</Value><EntryDate>2017-07-11</EntryDate><EntryTime>12:13:34</EntryTime><EntryUserCode>INPCo33333de</EntryUserCode><EntryUser>INPName3333</EntryUser><IsActive>1</IsActive></Item></Response>"
	Do ##Class(DHCHAI.Utils.XMLReaderSrv).GetListByXML(aInput,.arrData)
	Set Count=0
	Set xItmID=""
	For {
		Set xItmID=$o(arrData(xItmID))
		Quit:xItmID=""
		
		Set XCode    	  = $g(arrData(xItmID,"TempID")) 		// 护理记录ID
		Set EpisodeID     = $g(arrData(xItmID,"EpisodeID"))     // HIS就诊ID
		Set ItemCode      = $g(arrData(xItmID,"Code"))          // 护理项目代码
		Set ItemName      = $g(arrData(xItmID,"Desc"))          // 护理项目描述
		Set EntryUserID   = ""
		Set EntryUserCode = $g(arrData(xItmID,"EntryUserCode")) // 录入人工号
		Set EntryUserDesc = $g(arrData(xItmID,"EntryUser"))     // 录入人姓名
		Set (EpisodeDr,MrObservationsDr)=""
		Set objMrObservations = ##class(DHCHAI.DP.MRObservations).GetObjByXCode(aSCode,XCode)
		If $isobject(objMrObservations){
			Set MrObservationsDr = objMrObservations.%Id()
		}
		Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(aSCode_"||"_EpisodeID)
		If $IsObject(objAdm){
			Set EpisodeDr=objAdm.%Id()
		}
		Set InputStr = MrObservationsDr
		Set InputStr = InputStr_..#SEPARATE_EpisodeDr
		Set InputStr = InputStr_..#SEPARATE_ItemCode
		Set InputStr = InputStr_..#SEPARATE_ItemName
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"Value"))         // 项目值
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"EntryDate"))     // 录入日期
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"EntryTime"))     // 录入时间
		Set InputStr = InputStr_..#SEPARATE_EntryUserID_"|"_EntryUserCode_"|"_EntryUserDesc     // 录入人
		Set InputStr = InputStr_..#SEPARATE_aSCode                   			// 子系统代码
		Set InputStr = InputStr_..#SEPARATE_XCode				    			// 记录索引码
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"IsActive"))      // 有效标志
		Set InputStr = InputStr_..#SEPARATE_+$h
		Set InputStr = InputStr_..#SEPARATE_+$p($h,",",2)
		Set ret = ##class(DHCHAI.DP.MRObservations).Update(InputStr,..#SEPARATE)
		if ret>0 {
			Set Count = Count+1
			//保存护理项目对照
			Set objMROBSItemMap = ##class(DHCHAI.DP.MROBSItemMap).GetObjByItemDesc(aSCode,ItemName)
			If '$isobject(objMROBSItemMap){
				Set MapItemDr = ""
				Set objMROBSItem = ##class(DHCHAI.DP.MROBSItem).GetObjByCodeDesc("",ItemName)
				Set:$isobject(objMROBSItem) MapItemDr = objMROBSItem.%Id()
				Set InputStr = ""
				Set InputStr = InputStr_..#SEPARATE_ItemName					// 护理项目名称
				Set InputStr = InputStr_..#SEPARATE_MapItemDr					// 标准项目名称
				Set InputStr = InputStr_..#SEPARATE_""							// 标准备注
				Set InputStr = InputStr_..#SEPARATE_aSCode						// 子系统代码
				Set InputStr = InputStr_..#SEPARATE_1							// 有效标志
				Set InputStr = InputStr_..#SEPARATE_""							// 处置日期
				Set InputStr = InputStr_..#SEPARATE_""							// 处置时间
				Set InputStr = InputStr_..#SEPARATE_""							// 处置人
				Set ret = ##class(DHCHAI.DP.MROBSItemMap).Update(InputStr,..#SEPARATE)
				if ret<1{
					//记录错误日志
					Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,"DHCHAI.DP.MROBSItemMap","Update",$lb(InputStr,..#SEPARATE))
				}
			}
		}else{
			//记录错误日志
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,"DHCHAI.DP.MRObservations","Update",$lb(InputStr,..#SEPARATE))
		}
	}
	Kill arrData
	Quit Count
}

/// Creator：     zhoubo
/// CreatDate：   2017-07-13
/// Description:  三方系统,保存患者Pacs影像信息
/// Input：       XML格式的患者Pacs影像信息
/// Return：      处理数据条数
/// w ##class(DHCHAI.DI.DWS.DataPoolSrv).SyncPacsInfoByXML("")
ClassMethod SyncPacsInfoByXML(aSCode As %String, aInput As %String) As %String
{
	New (aSCode,aInput)
	Set return=""
	Quit:(aSCode="")||(aInput="") return
	
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Set SYSType=objSYS.BTTypeDr.BTCode
	
	Kill arrData
	
	//Set aInput="<Response><Item><ReportID>412315454</ReportID><EpisodeID>20</EpisodeID><StudyNo>2131||31||231</StudyNo><ChkStatus>审核</ChkStatus><CheckItem>检查项目</CheckItem><ExamDesc>检查所见有细菌</ExamDesc><ResultDesc>诊断意见</ResultDesc><RegDate>2017-07-12</RegDate><RegTime>12:23:23</RegTime><RegUser>周波</RegUser><RepDate>2017-07-13</RepDate><RepTime>12:23:23</RepTime><RepUser>周波2</RepUser><IsActive>1</IsActive></Item><Item><ReportID>411115454</ReportID><EpisodeID>20</EpisodeID><StudyNo>2131||31||231</StudyNo><ChkStatus>审核</ChkStatus><CheckItem>检查项目</CheckItem><ExamDesc>检查所见有细菌</ExamDesc><ResultDesc>诊断意见</ResultDesc><RegDate>2017-07-12</RegDate><RegTime>12:23:23</RegTime><RegUser>周波</RegUser><RepDate>2017-07-13</RepDate><RepTime>12:23:23</RepTime><RepUser>周波2</RepUser><IsActive>1</IsActive></Item><Item><ReportID>45422222254</ReportID><EpisodeID>20</EpisodeID><StudyNo>2131||31||231</StudyNo><ChkStatus>审核</ChkStatus><CheckItem>检查项目</CheckItem><ExamDesc>检查所见有细菌</ExamDesc><ResultDesc>诊断意见</ResultDesc><RegDate>2017-07-12</RegDate><RegTime>12:23:23</RegTime><RegUser>周波</RegUser><RepDate>2017-07-13</RepDate><RepTime>12:23:23</RepTime><RepUser>周波2</RepUser><IsActive>1</IsActive></Item><Item><ReportID>454512121214</ReportID><EpisodeID>20</EpisodeID><StudyNo>2131||31||231</StudyNo><ChkStatus>审核</ChkStatus><CheckItem>检查项目</CheckItem><ExamDesc>检查所见有细菌</ExamDesc><ResultDesc>诊断意见</ResultDesc><RegDate>2017-07-12</RegDate><RegTime>12:23:23</RegTime><RegUser>周波</RegUser><RepDate>2017-07-13</RepDate><RepTime>12:23:23</RepTime><RepUser>周波2</RepUser><IsActive>1</IsActive></Item></Response>"
	Do ##Class(DHCHAI.Utils.XMLReaderSrv).GetListByXML(aInput,.arrData)
	Set Count=0
	Set xItmID=""
	For {
		Set xItmID=$o(arrData(xItmID))
		Quit:xItmID=""
		
		Set XCode	      = $g(arrData(xItmID,"ReportID"))       // 报告ID
		Set EpisodeID     = $g(arrData(xItmID,"EpisodeID"))      // HIS就诊ID
		Set RegUserID     = ""
		Set RegUserCode   = ""
		Set RegUserDesc   = $g(arrData(xItmID,"RegUser"))        // 登记人
		Set RepUserID     = ""
		Set RepUserCode   = ""
		Set RepUserDesc   = $g(arrData(xItmID,"RepUser"))        // 报告人
		Set (RBReportDr,EpisodeDr)=""
		Set objRBReport = ##class(DHCHAI.DP.RBReport).GetObjByXCode(aSCode,XCode)
		If $IsObject(objRBReport){
			Set RBReportDr=objRBReport.%Id()
		}
		Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(aSCode_"||"_EpisodeID)
		If $IsObject(objAdm){
			Set EpisodeDr=objAdm.%Id()
		}
		Set InputStr = RBReportDr
		Set InputStr = InputStr_..#SEPARATE_EpisodeDr
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"StudyNo"))        // 检查号
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"ChkStatus"))      // 状态
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"CheckItem"))      // 检查项目
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"ExamDesc"))       // 检查所见
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"ResultDesc"))     // 诊断意见
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"RegDate"))        // 登记日期
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"RegTime"))        // 登记时间
		Set InputStr = InputStr_..#SEPARATE_RegUserID_"|"_RegUserCode_"|"_RegUserDesc  // 登记人
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"RepDate"))        // 报告日期
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"RepTime"))        // 报告时间
		Set InputStr = InputStr_..#SEPARATE_RepUserID_"|"_RepUserCode_"|"_RepUserDesc  // 报告人
		Set InputStr = InputStr_..#SEPARATE_aSCode                                // 子系统代码
		Set InputStr = InputStr_..#SEPARATE_XCode				                 // 记录索引码
		Set InputStr = InputStr_..#SEPARATE_+$h
		Set InputStr = InputStr_..#SEPARATE_+$p($h,",",2)
		Set ret = ##class(DHCHAI.DP.RBReport).Update(InputStr,..#SEPARATE)
		if ret>0 {
			Set Count = Count+1
			//保存检查分类对照
			Set objRBItmMastMap = ##class(DHCHAI.DP.RBItmMastMap).GetObjByItemDesc(aSCode,$g(arrData(xItmID,"CheckItem")))
			If '$isobject(objRBItmMastMap){
				Set MapItemDr = ""
				Set objRBItmMast = ##class(DHCHAI.DP.RBItmMast).GetObjByCodeName("",$g(arrData(xItmID,"CheckItem")))
				Set:$isobject(objRBItmMast) MapItemDr = objRBItmMast.%Id()
				Set InputStr = ""
				Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"CheckItem"))	 // 护理项目名称
				Set InputStr = InputStr_..#SEPARATE_MapItemDr					// 标准项目名称
				Set InputStr = InputStr_..#SEPARATE_""							// 标准备注
				Set InputStr = InputStr_..#SEPARATE_aSCode						// 子系统代码
				Set InputStr = InputStr_..#SEPARATE_1							// 有效标志
				Set InputStr = InputStr_..#SEPARATE_""							// 处置日期
				Set InputStr = InputStr_..#SEPARATE_""							// 处置时间
				Set InputStr = InputStr_..#SEPARATE_""							// 处置人
				Set ret = ##class(DHCHAI.DP.RBItmMastMap).Update(InputStr,..#SEPARATE)
				if ret<1{
					//记录错误日志
					Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,"DHCHAI.DP.RBItmMastMap","Update",$lb(InputStr,..#SEPARATE))
				}
			}
		}else{
			//记录错误日志
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,"DHCHAI.DP.RBReport","Update",$lb(InputStr,..#SEPARATE))
		}
	}
	Kill arrData
	Quit Count
}

/// Creator：     zhoubo
/// CreatDate：   2017-07-13
/// Description:  三方系统,保存患者手麻信息
/// Input：       XML格式的患者手麻信息
/// Return：      处理数据条数
/// w ##class(DHCHAI.DI.DWS.DataPoolSrv).SyncOperAnaesByXML("")
ClassMethod SyncOperAnaesByXML(aSCode As %String, aInput As %String) As %String
{
	New (aSCode,aInput)
	Set return=""
	Quit:(aSCode="")||(aInput="") return
	
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Set SYSType=objSYS.BTTypeDr.BTCode
	
	Kill arrData
		
	//Set aInput="<Response><Item><OperID>2||2</OperID><EpisodeID>20</EpisodeID><OperICD>342D.342</OperICD><OperDesc>阑尾炎切除手术</OperDesc><OperType>急诊</OperType><StartDate>2017-07-13</StartDate><StartTime>09:34:34</StartTime><EndDate>2017-07-13</EndDate><EndTime>10:34:34</EndTime><OperHour>4</OperHour><OperLocCode>LocCode</OperLocCode><OperLocDesc>手术科室1</OperLocDesc><OpertorCode>Code001</OpertorCode><OpertorName>周波</OpertorName><Assistant1>周波1</Assistant1><Assistant2>周波2</Assistant2><IncisionCode>1</IncisionCode><Incision>I</Incision><HealingCode>1</HealingCode><Healing>愈合情况1</Healing><AnesMethodCode>1</AnesMethodCode><AnesMethod>麻醉方式1</AnesMethod><Anesthesia>麻醉医师周波</Anesthesia><ASAScore>99</ASAScore><NNISGrade>一级</NNISGrade><WBC>23</WBC><IncisionNum>88</IncisionNum><IsSightGlass>1</IsSightGlass><IsImplants>1</IsImplants><LoseBlood>23</LoseBlood><GotBlood>24</GotBlood><Complication>1</Complication><IsActive>1</IsActive></Item></Response>"
	Do ##Class(DHCHAI.Utils.XMLReaderSrv).GetListByXML(aInput,.arrData)
	Set Count=0
	Set xItmID=""
	For {
		Set xItmID=$o(arrData(xItmID))
		Quit:xItmID=""
		
		Set XCode         = $g(arrData(xItmID,"OperID"))      // 手麻记录ID
		Set EpisodeID     = $g(arrData(xItmID,"EpisodeID"))   // HIS就诊ID
		Set OperLocID     = ""
		Set OperLocCode   = $g(arrData(xItmID,"OperLocCode")) // 手术科室代码
		Set OperLocDesc   = $g(arrData(xItmID,"OperLocDesc")) // 手术科室
		Set OpertorID     = ""
		Set OpertorCode   = $g(arrData(xItmID,"OpertorCode")) // 术者代码
		Set OpertorName   = $g(arrData(xItmID,"OpertorName")) // 术者
		
		Set OperLocDr=""
		Set objOperLoc=##class(DHCHAI.BT.Location).GetObjByLocCode(aSCode,OperLocCode)
		If $IsObject(objOperLoc) {
			Set OperLocDr=objOperLoc.%Id()
		}
		
		Set (OperAnaesDr,PaadmAdmDr)=""
		Set objOperAnaes = ##class(DHCHAI.DP.OROperAnaes).GetObjByXCode(aSCode,XCode)
		If $IsObject(objOperAnaes){
			Set OperAnaesDr=objOperAnaes.%Id()
		}
		Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(aSCode_"||"_EpisodeID)
		If $IsObject(objAdm){
			Set PaadmAdmDr=objAdm.%Id()
		}
		
		Set InputStr = OperAnaesDr
		Set InputStr = InputStr_..#SEPARATE_PaadmAdmDr
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"OperICD"))        // 手术编码
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"OperDesc"))       // 手术名称
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"OperType"))       // 手术类型
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"StartDate"))      // 手术开始日期
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"StartTime"))      // 手术开始时间
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"EndDate"))        // 手术结束日期
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"EndTime"))        // 手术结束时间
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"OperHour"))       // 手术时长
		Set InputStr = InputStr_..#SEPARATE_OperLocDr                            // 手术科室
		Set InputStr = InputStr_..#SEPARATE_OperLocID_"|"_OperLocCode_"|"_OperLocName  //手术科室
		Set InputStr = InputStr_..#SEPARATE_OpertorID_"|"_OpertorCode_"|"_OpertorName  //术者
		Set InputStr = InputStr_..#SEPARATE_""_"|"_""_"|"_$g(arrData(xItmID,"Assistant1"))     // 一助
		Set InputStr = InputStr_..#SEPARATE_""_"|"_""_"|"_$g(arrData(xItmID,"Assistant2"))     // 二助
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"Incision"))       // 切口类型
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"Healing"))        // 愈合情况
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"AnesMethod"))     // 麻醉方式
		Set InputStr = InputStr_..#SEPARATE_""_"|"_""_"|"_$g(arrData(xItmID,"Anesthesia"))     // 麻醉医生
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"ASAScore"))       // ASA评分
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"NNISGrade"))      // NINS分级
		Set InputStr = InputStr_..#SEPARATE_aSCode
		Set InputStr = InputStr_..#SEPARATE_XCode
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"WBC"))            // 术前外周WBC计数
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"IncisionNum"))    // 切口个数
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"IsSightGlass"))   // 是否使用窥镜
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"IsImplants"))     // 是否有植入物
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"LoseBlood"))      // 失血量
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"GotBlood"))       // 输血量
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"Complication"))   // 术后并发症
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"IsActive"))       // 有效标志
		Set InputStr = InputStr_..#SEPARATE_+$h
		Set InputStr = InputStr_..#SEPARATE_+$p($h,",",2)
		Set ret = ##class(DHCHAI.DP.OROperAnaes).Update(InputStr,..#SEPARATE)
		if ret>0 {
			// 保存成功！
			Set Count = Count+1
			Set CuteTypeCode  = $g(arrData(xItmID,"IncisionCode"))     	   // 切口类型代码
			Set CuteTypeDesc  = $g(arrData(xItmID,"Incision"))     		   // 切口类型名称
			Set:CuteTypeCode="" CuteTypeCode=CuteTypeDesc     			   // 切口类型
			Do SavePhraseMap(aSCode,"CuteType",CuteTypeCode,CuteTypeDesc)
			
			Set OperTypeCode     = $g(arrData(xItmID,"OperType"))           // 手术类型代码
			Set OperTypeDesc     = $g(arrData(xItmID,"OperType"))           // 手术类型名称
			Do SavePhraseMap(aSCode,"OperType",OperTypeCode,OperTypeDesc)
			
			Set CuteHealingCode  = $g(arrData(xItmID,"HealingCode"))        // 愈合情况代码
			Set CuteHealingDesc  = $g(arrData(xItmID,"Healing"))            // 愈合情况名称
			Set:CuteHealingCode="" CuteHealingCode=CuteHealingDesc          // 愈合情况
			Do SavePhraseMap(aSCode,"CuteHealing",CuteHealingCode,CuteHealingDesc)
			
			Set AnesthesiaCode  = $g(arrData(xItmID,"AnesMethodCode"))      // 麻醉方式代码
			Set AnesthesiaDesc  = $g(arrData(xItmID,"AnesMethod"))          // 麻醉方式名称
			Set:AnesthesiaCode="" AnesthesiaCode=AnesthesiaDesc             // 麻醉方式
			Do SavePhraseMap(aSCode,"Anesthesia",AnesthesiaCode,AnesthesiaDesc)
			
			Set ASAScoreCode  = $g(arrData(xItmID,"ASAScore"))              // ASA评分代码  代码和名称一样P1、P2....
			Set ASAScoreDesc  = $g(arrData(xItmID,"ASAScore"))              // ASA评分名称
			Set:ASAScoreCode="" ASAScoreCode=ASAScoreDesc                   // ASA评分
			Do SavePhraseMap(aSCode,"ASAScore",ASAScoreCode,ASAScoreDesc)
			
			Set NNISLevelCode  = $g(arrData(xItmID,"NNISGrade"))            // NNIS分级代码  NNIS分级代码名称一样
			Set NNISLevelDesc  = $g(arrData(xItmID,"NNISGrade"))            // NNIS分级名称
			Set:NNISLevelCode="" NNISLevelCode=NNISLevelDesc                // NNIS分级
			Do SavePhraseMap(aSCode,"NNISLevel",NNISLevelCode,NNISLevelDesc)
			
		}else{
			//记录错误日志
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,"DHCHAI.DP.OROperAnaes","Update",$lb(InputStr,..#SEPARATE))
		}
	}
	Kill arrData
	Quit Count
}

/// Creator：     liyi
/// CreatDate：   2017-07-24
/// Description:  三方系统,保存就诊信息
/// Input：       XML格式的就诊信息
/// Return：      处理数据条数
/// w ##class(DHCHAI.DI.DWS.DataPoolSrv).SyncPAAdmByXML("")
ClassMethod SyncPAAdmByXML(aSCode As %String, aInput As %String) As %String
{
	New (aSCode,aInput)
	Set return=""
	Quit:(aSCode="")||(aInput="") return
	
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Set SYSType=objSYS.BTTypeDr.BTCode
	
	Kill arrData
	//Set aInput="<Response><Item><Age>12</Age><EpisodeID>1</EpisodeID><PatientID>1</PatientID><PapmiNo>000032141</PapmiNo><MrNo>1241451</MrNo><PatName>王鑫</PatName><Sex>M</Sex><Nation>汉</Nation><Birthday>1989-09-20</Birthday><IdentityCode>51102319890920119X</IdentityCode><HomeAddress>四川省成都市</HomeAddress><Company>东华软件</Company><RelativeName>刘长春</RelativeName><RelativeTel>18508205822</RelativeTel><IsDeath>0</IsDeath><DeathDate></DeathDate><DeathTime></DeathTime><AdmType>I</AdmType><VisitStatus>D</VisitStatus><AdmDate>2017-07-21</AdmDate><AdmTime>12:00:00</AdmTime><AdmLocCode>中西医结合一科</AdmLocCode><AdmLoc>ZXYJHYK-中西医结合一科</AdmLoc><AdmWardCode>中西医结合一科护理单元</AdmWardCode><AdmWard>ZXYJHYKHLDY-中西医结合一科护理单元</AdmWard><AdmRoom>12房</AdmRoom><AdmBed>4床</AdmBed><DischDate>2017-07-28</DischDate><DischTime>14:00:00</DischTime><DischLocCode>中西医结合二科</DischLocCode><DischLoc>ZXYJHEK-中西医结合二科</DischLoc><DischWardCode>中西医结合二科护理单元</DischWardCode><DischWard>ZXYJHEKHLDY-中西医结合二科护理单元</DischWard><IsNewBaby>0</IsNewBaby><BirthWeight></BirthWeight><AdmitWeight></AdmitWeight><IsActive>1</IsActive></Item></Response>"
	Do ##Class(DHCHAI.Utils.XMLReaderSrv).GetListByXML(aInput,.arrData)
	
	Set Count=0
	Set xItmID=""
	For {
		Set xItmID=$o(arrData(xItmID))
		Quit:xItmID=""
		Set EpisodeIDX 		= $g(arrData(xItmID,"EpisodeID"))       // HIS就诊ID
		Set AdmLocCode  	= $g(arrData(xItmID,"AdmLocCode"))      // 当前科室代码
		Set AdmWardCode 	= $g(arrData(xItmID,"AdmWardCode"))     // 当前病区代码
		Set DischLocCode 	= $g(arrData(xItmID,"DischLocCode"))    // 出院科室代码
		Set DischWardCode 	= $g(arrData(xItmID,"DischWardCode"))   // 出院病区代码
		Set IsActive 		= $g(arrData(xItmID,"IsActive"))        // 有效标记
		Set (AdmLocDr,AdmWardDr,DischLocDr,DischWardDr)=""
		
		Set objAdmLoc=##class(DHCHAI.BT.Location).GetObjByLocCode(aSCode,AdmLocCode)
		Set objAdmWard=##class(DHCHAI.BT.Location).GetObjByLocCode(aSCode,AdmWardCode)
		Set objDischLoc=##class(DHCHAI.BT.Location).GetObjByLocCode(aSCode,DischLocCode)
		Set objDischWard=##class(DHCHAI.BT.Location).GetObjByLocCode(aSCode,DischWardCode)
		if $isobject(objAdmLoc) {
			Set AdmLocDr=objAdmLoc.%Id()
		}
		if $isobject(objAdmWard) {
			Set AdmWardDr=objAdmWard.%Id()
		}
		if $isobject(objDischLoc) {
			Set DischLocDr=objDischLoc.%Id()
		}
		if $isobject(objDischWard) {
			Set DischWardDr=objDischWard.%Id()
		}
		Set PaadmAdmID =""
		Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(aSCode_"||"_EpisodeIDX)
		If $IsObject(objAdm){
			Set PaadmAdmID=objAdm.%Id()
		}
		Set DischDate = $g(arrData(xItmID,"DischDate"))
		Set AdmDate = $g(arrData(xItmID,"AdmDate"))
		Set:DischDate["-" DischDate = $zdh(DischDate,3)
		Set:AdmDate["-" AdmDate = $zdh(AdmDate,3)
		If DischDate'="" {
			Set AdmDays=DischDate-AdmDate+1
			Set:AdmDays<1 AdmDays=1
		} Else {
			Set AdmDays=-1
		}
		Set InputStr = PaadmAdmID
		Set InputStr = InputStr_..#SEPARATE_EpisodeIDX							// 就诊序号
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"PatientID"))		// 病人主索引
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"PapmiNo"))		// 登记号
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"MrNo"))			// 病案号
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"PatName")) 		// 姓名
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"Sex")) 			// 性别（M男、F女、O其他）
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"Nation"))		// 民族
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"Birthday")) 		// 出生日期
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"Age")) 			// 年龄
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"IdentityCode")) 	// 身份证号码
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"HomeAddress")) 	// 现住址
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"Company")) 		// 工作单位
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"RelativeName"))	// 联系人
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"RelativeTel"))	// 联系人电话
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"IsDeath"))		// 死亡标志
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"DeathDate"))		// 死亡日期
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"DeathTime")) 	// 死亡时间
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"AdmType"))  		// 就诊类型
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"VisitStatus"))	// 就诊状态
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"AdmDate")) 		// 入院日期
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"AdmTime")) 		// 入院时间
		Set InputStr = InputStr_..#SEPARATE_AdmLocDr							// 就诊科室
		Set InputStr = InputStr_..#SEPARATE_AdmWardDr							// 就诊病区
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"AdmRoom"))		// 就诊房间
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"AdmBed"))		// 就诊床位
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"DischDate")) 	// 出院日期
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"DischTime")) 	// 出院时间
		Set InputStr = InputStr_..#SEPARATE_DischLocDr							// 出院科室
		Set InputStr = InputStr_..#SEPARATE_DischWardDr							// 出院病区
		Set InputStr = InputStr_..#SEPARATE_AdmDays								// 住院天数
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"IsNewBaby"))		// 新生儿标志
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"BirthWeight"))	// 新生儿出生体重
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"AdmitWeight"))	// 新生儿入院体重
		Set InputStr = InputStr_..#SEPARATE_+$h
		Set InputStr = InputStr_..#SEPARATE_+$p($h,",",2)
		Set ret = ##class(DHCHAI.DP.PAAdm).Update(InputStr,..#SEPARATE)
		if ret>0 {
			Set Count = Count+1
		}else{
			// 记录错误日志
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeIDX,"DHCHAI.DP.PAAdm","Update",$lb(InputStr,..#SEPARATE))
		}
	}
	Kill arrData
	Quit Count
}

/// Creator：     liyi
/// CreatDate：   2017-07-24
/// Description:  三方系统,保存诊断信息
/// Input：       XML格式的诊断信息
/// Return：      处理数据条数
/// w ##class(DHCHAI.DI.DWS.DataPoolSrv).SyncDiagsByXML("")
ClassMethod SyncDiagsByXML(aSCode As %String, aInput As %String) As %String
{
	New (aSCode,aInput)
	Set return=""
	Quit:(aSCode="")||(aInput="") return
	
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Set SYSType=objSYS.BTTypeDr.BTCode
	
	Kill arrData
	//Set aInput="<Response><Item><EpisodeID>1</EpisodeID><MrDiagID>1||1</MrDiagID><DiagICD10>E14.001</DiagICD10><DiagDesc>糖尿病</DiagDesc><DiagNote>长期糖尿病</DiagNote><DiagTpCode>1</DiagTpCode><DiagTpDesc>主要诊断</DiagTpDesc><DiagDate>2017-07-21</DiagDate><DiagTime>12:00:00</DiagTime><IsActive>1</IsActive></Item></Response>"
	Do ##Class(DHCHAI.Utils.XMLReaderSrv).GetListByXML(aInput,.arrData)
	Set Count=0
	Set xItmID=""
	For {
		Set xItmID=$o(arrData(xItmID))
		Quit:xItmID=""
		
		Set EpisodeID 	= $g(arrData(xItmID,"EpisodeID"))       // HIS就诊ID
		Set xCode		= $g(arrData(xItmID,"MrDiagID"))       	// 诊断记录ID
		Set (EpisodeDr,MrDiagnosDr)=""
        Set objDiagnos = ##class(DHCHAI.DP.MRDiagnos).GetObjByXCode(aSCode,xCode)
        If $IsObject(objDiagnos) {
	        Set MrDiagnosDr=objDiagnos.%Id()
        }
		Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(aSCode_"||"_EpisodeID)
		If $IsObject(objAdm){
			Set EpisodeDr=objAdm.%Id()
		}
        Set InputStr = MrDiagnosDr
		Set InputStr = InputStr_..#SEPARATE_EpisodeDr						 // 就诊记录指针
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"DiagICD10"))	 // 诊断ICD10
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"DiagDesc"))	 // 诊断名称
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"DiagNote"))	 // 诊断备注
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"DiagTpCode")) // 诊断类型代码
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"DiagTpDesc")) // 诊断类型描述
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"DiagDate"))	 // 诊断日期
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"DiagTime"))	 // 诊断时间
		Set InputStr = InputStr_..#SEPARATE_"C"								 // 诊断来源（C临床、E首页、F编目）
		Set InputStr = InputStr_..#SEPARATE_aSCode							 // 子系统代码
		Set InputStr = InputStr_..#SEPARATE_xCode						     // 记录索引码
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"IsActive"))	 // 有效标志
		Set InputStr = InputStr_..#SEPARATE_+$h
		Set InputStr = InputStr_..#SEPARATE_+$p($h,",",2)
		Set ret = ##class(DHCHAI.DP.MRDiagnos).Update(InputStr,..#SEPARATE)
		if ret>0 {
			Set Count = Count+1
			//诊断名称存入对照表 
			Set objMRICDDxMap = ##class(DHCHAI.DP.MRICDDxMap).GetObjByDiagDesc(aSCode,$g(arrData(xItmID,"DiagDesc")))
			If '$isobject(objMRICDDxMap){
				Set MapItemDr = ""
				Set objMapItem = ##class(DHCHAI.DP.MRICDDx).GetObjByCodeDesc("",$g(arrData(xItmID,"DiagDesc")))
				Set:$isobject(objMapItem) MapItemDr = objMapItem.%Id()
				Set InputStr = ""
				Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"DiagDesc")) 	// 诊断名称
				Set InputStr = InputStr_..#SEPARATE_MapItemDr						// 标准名称
				Set InputStr = InputStr_..#SEPARATE_""								// 标准备注
				Set InputStr = InputStr_..#SEPARATE_aSCode							// 子系统代码
				Set InputStr = InputStr_..#SEPARATE_1								// 有效标志
				Set InputStr = InputStr_..#SEPARATE_""								// 处置日期
				Set InputStr = InputStr_..#SEPARATE_""								// 处置时间
				Set InputStr = InputStr_..#SEPARATE_""								// 处置人
				Set ret = ##class(DHCHAI.DP.MRICDDxMap).Update(InputStr,..#SEPARATE)
				if ret<1{
					//记录错误日志
					Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,"DHCHAI.DP.MRICDDxMap","Update",$lb(InputStr,..#SEPARATE))
				}
			}
		}else{
			//记录错误日志
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,"DHCHAI.DP.MRDiagnos","Update",$lb(InputStr,..#SEPARATE))
		}
	}
	Kill arrData
	Quit Count
}

/// Creator：     liyi
/// CreatDate：   2017-07-24
/// Description:  三方系统,保存转科记录
/// Input：       XML格式的转科记录
/// Return：      处理数据条数
/// w ##class(DHCHAI.DI.DWS.DataPoolSrv).SyncTransByXML("")
ClassMethod SyncTransByXML(aSCode As %String, aInput As %String) As %String
{
	New (aSCode,aInput)
	Set return=""
	Quit:(aSCode="")||(aInput="") return
	
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Set SYSType=objSYS.BTTypeDr.BTCode
	
	Kill arrData
	//Set aInput="<Response><Item><TransID>1||1</TransID><EpisodeID>1</EpisodeID><TransLocCode>中西医结合一科</TransLocCode><TransLocDesc>ZXYJHYK-中西医结合一科</TransLocDesc><IsICUFlag>0</IsICUFlag><TransDate>2017-07-23</TransDate><TransTime>12:00:00</TransTime><OutLocDate>2017-07-25</OutLocDate><OutLocTime>14:00:00</OutLocTime></Item></Response>"
	Do ##Class(DHCHAI.Utils.XMLReaderSrv).GetListByXML(aInput,.arrData)
	Set Count=0
	
	Set xItmID=""
	For {
		Set xItmID=$o(arrData(xItmID))
		Quit:xItmID=""
		
		Set EpisodeID 	= $g(arrData(xItmID,"EpisodeID"))       // HIS就诊ID
		Set TransID		= $g(arrData(xItmID,"TransID"))       	// 转科记录ID
		Set TransLocCode= $g(arrData(xItmID,"TransLocCode"))    // 转科科室代码
		Set TransDate	= $g(arrData(xItmID,"TransDate"))		// 转科日期
		Set OutLocDate	= $g(arrData(xItmID,"OutLocDate"))		// 出科日期
		
		Set (TranLocDr,TransDr,EpisodeDr) =""
		Set objTranLoc=##class(DHCHAI.BT.Location).GetObjByLocCode(aSCode,TransLocCode)
		if $isobject(objTranLoc) {
			Set TranLocDr=objTranLoc.%Id()
		}
        Set objTrans = ##class(DHCHAI.DP.PAAdmTrans).GetObjByTransID(TransID)
        If $isobject(objTrans) {
	        Set TransDr=objTrans.%Id()
        }
		Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(aSCode_"||"_EpisodeID)
		If $IsObject(objAdm){
			Set EpisodeDr=objAdm.%Id()
		}
		Set:TransDate["-" TransDate = $zdh(TransDate,3)
		Set:OutLocDate["-" OutLocDate = $zdh(OutLocDate,3)
		If OutLocDate'="" {
			Set TransDays=OutLocDate-TransDate+1
			Set:TransDays<1 TransDays=1
		} Else {
			Set TransDays=-1
		}
        Set InputStr = TransDr
        Set InputStr = InputStr_..#SEPARATE_TransID							 // HIS转科ID
		Set InputStr = InputStr_..#SEPARATE_EpisodeDr						 // 就诊记录指针
		Set InputStr = InputStr_..#SEPARATE_TranLocDr						 // 转科科室/病区ID
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"IsICUFlag"))	 // 转入ICU/NICU标记
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"TransDate"))	 // 转科日期
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"TransTime"))	 // 转科时间
		Set InputStr = InputStr_..#SEPARATE_TransDays						 // 在科天数
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"OutLocDate")) // 出科日期
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"OutLocTime")) // 出科时间
		Set InputStr = InputStr_..#SEPARATE_+$h
		Set InputStr = InputStr_..#SEPARATE_+$p($h,",",2)
		Set ret = ##class(DHCHAI.DP.PAAdmTrans).Update(InputStr,..#SEPARATE)
		Set ^LIYI =InputStr
		if ret>0 {
			Set Count = Count+1
		}else{
			//记录错误日志
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,"DHCHAI.DP.PAAdmTrans","Update",$lb(InputStr,..#SEPARATE))
		}
	}
	Kill arrData
	Quit Count
}

/// Creator：     liyi
/// CreatDate：   2017-07-24
/// Description:  三方系统,保存医嘱记录
/// Input：       XML格式的医嘱记录
/// Return：      处理数据条数
/// w ##class(DHCHAI.DI.DWS.DataPoolSrv).SyncOEOrdItemByXML("")
ClassMethod SyncOEOrdItemByXML(aSCode As %String, aInput As %String) As %String
{
	New (aSCode,aInput)
	Set return=""
	Quit:(aSCode="")||(aInput="") return
	
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Set SYSType=objSYS.BTTypeDr.BTCode
	
	Kill arrData
	
	//Set aInput="<Response><Item><OEOrdID>1||1</OEOrdID><EpisodeID>1</EpisodeID><OrdCode>A0101</OrdCode><OrdDesc>青霉素注射液5ML</OrdDesc><OrdType>R</OrdType><OrdCat>西药</OrdCat><OrdSubCat>青霉素</OrdSubCat><Priority>临时医嘱</Priority><IsThreeOrder>0</IsThreeOrder><OrdStatus>审核</OrdStatus><OrdDate>2017-07-22</OrdDate><OrdTime>13:00:00</OrdTime><OrdLocID>4</OrdLocID><OrdLocDesc>NYK-内一科</OrdLocDesc><DocCode>zhuguohang</DocCode><DocName>杨慧</DocName><SttDate>2017-07-23</SttDate><SttTime>14:00:00</SttTime><EndDate>2017-07-24</EndDate><EndTime>15:00:00</EndTime><Generic>青霉素1</Generic><Instruc>肌肉注射</Instruc><DoseQty>5</DoseQty><DoseQtyUom>ml</DoseQtyUom><FreqDesc>bid</FreqDesc><IsActive>1</IsActive></Item><Item><OEOrdID>1||2</OEOrdID><EpisodeID>1</EpisodeID><OrdCode>A01011</OrdCode><OrdDesc>青霉素注射液10ML</OrdDesc><OrdType>R</OrdType><OrdCat>西药</OrdCat><OrdSubCat>青霉素</OrdSubCat><Priority>临时医嘱</Priority><IsThreeOrder>1</IsThreeOrder><OrdStatus>审核</OrdStatus><OrdDate>2017-07-22</OrdDate><OrdTime>13:00:00</OrdTime><OrdLocID>4</OrdLocID><OrdLocDesc>NYK-内一科</OrdLocDesc><DocCode>zhuguohang</DocCode><DocName>杨慧</DocName><SttDate>2017-07-23</SttDate><SttTime>14:00:00</SttTime><EndDate>2017-07-24</EndDate><EndTime>15:00:00</EndTime><Generic>青霉素1</Generic><Instruc>肌肉注射</Instruc><DoseQty>5</DoseQty><DoseQtyUom>ml</DoseQtyUom><FreqDesc>bid</FreqDesc><IsActive>1</IsActive></Item></Response>"
	Do ##Class(DHCHAI.Utils.XMLReaderSrv).GetListByXML(aInput,.arrData)
	Set Count=0

	Set xItmID=""
	For {
		Set xItmID=$o(arrData(xItmID))
		Quit:xItmID=""
		
		Set EpisodeID 	= $g(arrData(xItmID,"EpisodeID"))       // HIS就诊ID
		Set XCode		= $g(arrData(xItmID,"OEOrdID"))       	// HIS医嘱ID
		Set OrdLocID	= $g(arrData(xItmID,"OrdLocID"))       	// 开医嘱科室ID
		Set OrdLocCode  = ""
		Set OrdLocDesc  = ""
		Set OrdDocID    = ""
		Set OrdDocCode	= $g(arrData(xItmID,"DocCode")) 		// 开医嘱医生工号
		Set OrdDocName	= $g(arrData(xItmID,"DocName")) 		// 开医嘱医生姓名
		Set ThreeOrderFlg= $g(arrData(xItmID,"IsThreeOrder"))   // 是否三管医嘱
		Set (OEOrdLocDr,EpisodeDr,OrdItemDr) =""
		Set objOrdLoc = ##class(DHCHAI.BT.Location).GetObjByLocCode(aSCode,OrdLocID)
		if $isobject(objOrdLoc) {
			Set OEOrdLocDr=objOrdLoc.%Id()
		}
		Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(aSCode_"||"_EpisodeID)
		If $IsObject(objAdm){
			Set EpisodeDr=objAdm.%Id()
		}
		Set objOrdItem = ##class(DHCHAI.DP.OEOrdItem).GetObjByXCode(XCode)
		If $IsObject(objOrdItem){
			Set OrdItemDr=objOrdItem.%Id()
		}
		Set InputStr = OrdItemDr
		Set InputStr = InputStr_..#SEPARATE_EpisodeDr							// 就诊记录指针
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"OrdCode")) 		// 医嘱代码
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"OrdDesc")) 		// 医嘱名称
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"OrdType")) 		// 医嘱分类
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"OrdCat")) 		// 医嘱大类
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"OrdSubCat")) 	// 医嘱子类
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"Priority")) 		// 医嘱类型
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"OrdStatus")) 	// 医嘱状态
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"OrdDate")) 		// 开医嘱日期
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"OrdTime")) 		// 开医嘱时间
		Set InputStr = InputStr_..#SEPARATE_OEOrdLocDr				    		// 开医嘱科室
		Set InputStr = InputStr_..#SEPARATE_OrdLocID_"|"_OrdLocCode_"|"_OrdLocDesc  // 开医嘱科室
		Set InputStr = InputStr_..#SEPARATE_OrdDocID_"|"_OrdDocCode_"|"_OrdDocName  // 开医嘱医生
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"SttDate")) 		// 医嘱开始日期
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"SttTime")) 		// 医嘱开始时间
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"EndDate")) 		// 停医嘱日期
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"EndTime")) 		// 停医嘱时间
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"Generic")) 		// 药品通用名
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"Instruc")) 		// 给药途径
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"DoseQty")) 		// 单次剂量
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"DoseQtyUom")) 	// 剂量单位
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"FreqDesc")) 		// 频次
		Set InputStr = InputStr_..#SEPARATE_aSCode								// 子系统代码
		Set InputStr = InputStr_..#SEPARATE_XCode								// 记录索引码
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"IsActive")) 	    // 有效标志
		Set InputStr = InputStr_..#SEPARATE_+$h
		Set InputStr = InputStr_..#SEPARATE_+$p($h,",",2)
		Set ret = ##class(DHCHAI.DP.OEOrdItem).Update(InputStr,..#SEPARATE)
		if ret>0 {
			Set Count = Count+1
			if ThreeOrderFlg = 1{	// 三管医嘱写入对照表
				Set objOEItmMastMap =  ##class(DHCHAI.DP.OEItmMastMap).GetObjByOrdDesc(aSCode,$g(arrData(xItmID,"OrdDesc")))
				If '$Isobject(objOEItmMastMap){
					Set MapItemDr = ""
					Set objOEItmMast = ##class(DHCHAI.DP.OEItmMast).GetObjByCodeDesc("",$g(arrData(xItmID,"OrdDesc")))
					Set:$isobject(objOEItmMast) MapItemDr = objOEItmMast.%Id()
					Set InputStr = ""
					Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"OrdDesc"))	 //医嘱名称
					Set InputStr = InputStr_..#SEPARATE_MapItemDr						 // 标准名称
					Set InputStr = InputStr_..#SEPARATE_""							// 标准备注
					Set InputStr = InputStr_..#SEPARATE_aSCode						// 子系统代码
					Set InputStr = InputStr_..#SEPARATE_1							// 有效标志
					Set InputStr = InputStr_..#SEPARATE_""							// 处置日期
					Set InputStr = InputStr_..#SEPARATE_""							// 处置时间
					Set InputStr = InputStr_..#SEPARATE_""							// 处置人
					Set ret = ##class(DHCHAI.DP.OEItmMastMap).Update(InputStr,..#SEPARATE)
					if ret<1{
						//记录错误日志
						Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,"DHCHAI.DP.OEItmMastMap","Update",$lb(InputStr,..#SEPARATE))
					}
				}
			}
		}else{
			//记录错误日志
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,"DHCHAI.DP.OEOrdItem","Update",$lb(InputStr,..#SEPARATE))
		}
	}
	Kill arrData
	Quit Count
}

/// Creator：     liyi
/// CreatDate：   2017-07-24
/// Description:  三方系统,保存抗菌药物使用记录
/// Input：       XML格式的抗菌药物使用记录
/// Return：      处理数据条数
/// w ##class(DHCHAI.DI.DWS.DataPoolSrv).SyncAntUseByXML("<Response><Item><AntUseID>1</AntUseID><EpisodeID>20</EpisodeID><AntiCode>A00001</AntiCode><AntiDesc>阿奇霉素颗粒</AntiDesc><OrdID>11||1</OrdID><DrgPoison>KISS1</DrgPoison><UsePurpose>预防+治疗</UsePurpose><OthPurpose>预防</OthPurpose><IsSubmission>1</IsSubmission><InfPos>肺部</InfPos><UseDate>2017-09-01</UseDate><UseTime>12:00:00</UseTime><IsActive>1</IsActive></Item></Response>")
ClassMethod SyncAntUseByXML(aSCode As %String, aInput As %String) As %String
{
	New (aSCode,aInput)
	Set return=""
	Quit:(aSCode="")||(aInput="") return
	
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Set SYSType=objSYS.BTTypeDr.BTCode
	
	Kill arrData
	
	//Set aInput="<Response><Item><AntUseID>1</AntUseID><EpisodeID>20</EpisodeID><AntiCode>A00001</AntiCode><AntiDesc>阿奇霉素颗粒</AntiDesc><OrdID>11||1</OrdID><DrgPoison>KISS1</DrgPoison><UsePurpose>预防+治疗</UsePurpose><OthPurpose>预防</OthPurpose><IsSubmission>1</IsSubmission><InfPos>肺部</InfPos><UseDate>2017-09-01</UseDate><UseTime>12:00:00</UseTime><IsActive>1</IsActive></Item></Response>"
	Do ##Class(DHCHAI.Utils.XMLReaderSrv).GetListByXML(aInput,.arrData)
	Set Count=0

	Set xItmID=""
	For {
		Set xItmID=$o(arrData(xItmID))
		Quit:xItmID=""
		
		Set EpisodeID 	= $g(arrData(xItmID,"EpisodeID"))       // HIS就诊ID
		Set XCode		= $g(arrData(xItmID,"AntUseID"))       	// 抗菌药物使用记录ID
		Set (EpisodeDr,AntUseDr) =""
		Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(aSCode_"||"_EpisodeID)
		If $IsObject(objAdm){
			Set EpisodeDr=objAdm.%Id()
		}
		Set objAntUse = ##class(DHCHAI.DP.OEOrdItem).GetObjByXCode(aSCode,XCode)
		If $IsObject(objAntUse){
			Set AntUseDr=objAntUse.%Id()
		}
		Set InputStr = AntUseDr
		Set InputStr = InputStr_..#SEPARATE_EpisodeDr							// 就诊记录指针
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"AntiCode")) 		// 抗菌药物代码
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"AntiDesc")) 		// 抗菌药物名称
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"DrgPoison")) 	// 管制分类级别
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"UsePurpose")) 	// 使用目的
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"OthPurpose")) 	// 其他目的
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"IsSubmission")) 	// 是否送检
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"InfPos")) 		// 感染部位
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"UseDate")) 		// 使用日期
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"UseTime")) 		// 使用时间
		Set InputStr = InputStr_..#SEPARATE_aSCode								// 子系统代码
		Set InputStr = InputStr_..#SEPARATE_XCode								// 记录索引码
		Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"IsActive")) 		// 有效标志
		Set InputStr = InputStr_..#SEPARATE_+$h
		Set InputStr = InputStr_..#SEPARATE_+$p($h,",",2)
		Set ret = ##class(DHCHAI.DP.OEOrdItem).Update(InputStr,..#SEPARATE)
		if ret>0 {
			Set Count = Count+1
			//抗菌药物写入对照表
			Set objAntiMastMap =  ##class(DHCHAI.DP.OEAntiMastMap).GetObjByAntiDesc(aSCode,$g(arrData(xItmID,"AntiDesc")))
			If '$Isobject(objAntiMastMap){
				Set MapItemDr = ""
				Set objOEAntiMast = ##class(DHCHAI.DP.OEAntiMast).GetObjByCode($g(arrData(xItmID,"AntiCode")))
				Set:$isobject(objOEAntiMast) MapItemDr = objOEAntiMast.%Id()
				Set InputStr = ""
				Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"AntiDesc"))	 // 抗菌药物名称
				Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"PHCGeneric")) // 药品通用名 add by zf 20171128
				Set InputStr = InputStr_..#SEPARATE_$g(arrData(xItmID,"PHChemical")) // 药品化学名 add by zf 20171128
				Set InputStr = InputStr_..#SEPARATE_MapItemDr						 // 标准抗菌药物名称
				Set InputStr = InputStr_..#SEPARATE_""							// 标准备注
				Set InputStr = InputStr_..#SEPARATE_aSCode						// 子系统代码
				Set InputStr = InputStr_..#SEPARATE_1							// 有效标志
				Set InputStr = InputStr_..#SEPARATE_""							// 处置日期
				Set InputStr = InputStr_..#SEPARATE_""							// 处置时间
				Set InputStr = InputStr_..#SEPARATE_""							// 处置人
				Set ret = ##class(DHCHAI.DP.OEAntiMastMap).Update(InputStr,..#SEPARATE)
				if ret<1{
					//记录错误日志
					Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,"DHCHAI.DP.OEAntiMastMap","Update",$lb(InputStr,..#SEPARATE))
				}
			}
		}else{
			//记录错误日志
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,"DHCHAI.DP.OEOrdItem","Update",$lb(InputStr,..#SEPARATE))
		}
	}
	Kill arrData
	Quit Count
}

}
