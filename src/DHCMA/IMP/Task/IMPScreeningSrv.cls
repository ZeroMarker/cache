/// 名称: DHCMA.IMP.Task.IMPScreeningSrv
/// 描述: 重点患者筛查任务
/// 编写者：zhufei
/// 编写日期: 2020-9-25
Class DHCMA.IMP.Task.IMPScreeningSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhangdc
/// CreatDate：   2020-06-09
/// Description:  筛查所有重点病人（只筛查在院病人）
/// Table：       PA_Adm
/// Others:  	  返回筛查出多少条
/// w ##class(DHCMA.IMP.Task.IMPScreeningSrv).ScrKeyPatientsAll()
ClassMethod ScrKeyPatientsAll() As %String
{
	
	Set return=0
	Set $ZT="ScrKeyPatientsAllErr"
	
	//在院患者列表
	Set xWardID="",Count=0
	For {
		Set xWardID=$o(^PAADMi("CurrWard",xWardID))
		Quit:xWardID=""
		
		Set xRoomID=""
		For {
			Set xRoomID=$o(^PAADMi("CurrWard",xWardID,xRoomID))
			Quit:xRoomID=""
			
			Set xEpisodeID=""
			For {
				Set xEpisodeID=$o(^PAADMi("CurrWard",xWardID,xRoomID,xEpisodeID))
				Quit:xEpisodeID=""
				
				Set AdmInfo=$g(^PAADM(xEpisodeID))
				Continue:$p(AdmInfo,"^",2)'="I"      //就诊类型过滤  o门诊 I住院
				Continue:$p(AdmInfo,"^",20)="C"      //就诊状态过滤
				
				Set flg=..ScrByRules(xEpisodeID)
				Set:flg>0 Count=Count+1
			}
		}
	}
	Set return=Count
	Quit return
	
ScrKeyPatientsAllErr
	Set return="-999^"_$ZError
	Quit return
}

/// Creator：     zhangdc
/// CreatDate：   2020-06-09
/// Description:  根据日期筛查重点病人（只筛查在院病人）
/// Table：       PA_Adm
/// Input：       aFromDate：开始日期
///               aToDate：结束日期
/// Others:  	  返回筛查出多少条
/// w ##class(DHCMA.IMP.Task.IMPScreeningSrv).ScrKeyPatientsByDate("2016-01-01","2019-03-01")
ClassMethod ScrKeyPatientsByDate(aDateFrom As %String, aDateTo As %String) As %String
{
	New (aDateFrom,aDateTo)
	Set return=0,Count=0
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo'="" aDateTo=+aDateTo
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set $ZT="ScrKeyPatientsByDateErr"
	
	//出院患者列表
	For xDate=aDateFrom:1:aDateTo {
		Set xEpisodeID=0
		For {
			Set xEpisodeID=$o(^PAADMi("DischDate",xDate,xEpisodeID))
			Quit:xEpisodeID=""
			
			Set AdmInfo=$g(^PAADM(xEpisodeID))
			Continue:$p(AdmInfo,"^",2)'="I"      //就诊类型过滤  o门诊 I住院
			Continue:$p(AdmInfo,"^",20)="C"      //就诊状态过滤
			
			Set flg=..ScrByRules(xEpisodeID)
			Set:flg>0 Count=Count+1
		}
	}
	Set return=Count
	Quit return
	
ScrKeyPatientsByDateErr
	Set return="-999^"_$ZError
	Quit return
}

/// Creator：     zhangdc
/// CreatDate：   2020-06-09
/// Description:  根据筛查规则筛查病人
/// Table：       PA_Adm
/// Others:  	  标记成功>0,筛查失败<0,不筛查返回0
/// w ##class(DHCMA.IMP.Task.IMPScreeningSrv).ScrByRules(3)
ClassMethod ScrByRules(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=0, Count=0, ECount=0
	Quit:aEpisodeID="" return
	
	Set TypeExclude=##class(DHCMA.Util.BT.Dictionary).GetObjByPCodeItemDesc("IMPRuleType","排除条件")
	Set:$IsObject(TypeExclude) TypeExclude=TypeExclude.%Id()
	Set TypeRule=##class(DHCMA.Util.BT.Dictionary).GetObjByPCodeItemDesc("IMPRuleType","筛查规则")
	Set:$IsObject(TypeRule) TypeRule=TypeRule.%Id()
	
	Set Parref=""
	For {
		Set Parref=$o(^CT.MA.IMP.BTIMPCategoryD(Parref))
		Quit:Parref=""
		Set KeyWord = ##class(DHCMA.IMP.BTS.SemanticWordSrv).QrySemanticWByCategory(Parref)
		
		k tmpRuleInfo
		Set childSub=""
		Set ind=1
		For {
			Set childSub=$o(^CT.MA.IMP.BTIMPCategoryD(Parref,"Rules",childSub))
			Quit:childSub=""
			Set RuleID = Parref_"||"_childSub
			Set ObjRule = ##class(DHCMA.IMP.BT.IMPCateRules).GetObjById(RuleID)
			Set IsActive          	= ObjRule.BTIsActive
			Continue:IsActive'=1
			Set RuleType          	= ObjRule.BTTypeDr.%Id()
			Set RuleMethod          = ObjRule.BTExpress
			Set ind=ind+1
			Set tmpRuleInfo(RuleType,ind)=$lb(RuleID,RuleMethod)
		}
		
		if ($d(tmpRuleInfo(TypeRule))){	//有筛查规则，才进行判断
			Set xInd="",ret="N",cnt=0,num=0,BTKeyWord="",BTKeyWordOID=""
			For {
				Set xInd=$o(tmpRuleInfo(TypeRule,xInd)) 
			 	Quit:xInd=""
			 	Set xRuleID=$lg(tmpRuleInfo(TypeRule,xInd),1)
			 	Set RuleMethod=$lg(tmpRuleInfo(TypeRule,xInd),2)
			 	Set RuleMethod=$Replace(RuleMethod,"()","")
			 	Continue:RuleMethod'["##"
			 	Set exp="Set ret="_RuleMethod_"("""_aEpisodeID_""")"
			 	x exp
			 	Set num=num+1
			 	Set:ret="Y" cnt=cnt+1
			}
			
			if ((ret="Y")&&(num=cnt)){	//有筛查规则，并且都满足，再进行排除判断
				if ($d(tmpRuleInfo(TypeExclude))){	//排除规则符合则不标记，不符合标记
					Set Ind="",xcnt=0
					For {
						Set Ind=$o(tmpRuleInfo(TypeExclude,Ind)) 
			 			Quit:Ind=""
			 			Set xRuleID=$lg(tmpRuleInfo(TypeExclude,Ind),1)
			 			Set RuleMethod=$lg(tmpRuleInfo(TypeExclude,Ind),2)
			 			Set RuleMethod=$Replace(RuleMethod,"()","")
			 			Continue:RuleMethod'["##"
			 			Set exp="Set ret="_RuleMethod_"("""_aEpisodeID_""")"
			 			x exp
			 			Set:ret="N" xcnt=xcnt+1
						}
					
					if ((ret="Y")&&(xcnt=0)){
						Set result=..updateByCatAndEpis(aEpisodeID,Parref)
						if (result>0){
							Set Count=Count+1
						}else{
							Set ECount=ECount+1
						}
					}
				}else{	//没有排除规则标记重点患者
					//增加关键词筛查
					
					Set result=..updateByCatAndEpis(aEpisodeID,Parref)
					
					if (result>0){
						Set Count=Count+1
					}else{
						Set ECount=ECount+1
					}
				}
			}
		}elseif('$d(tmpRuleInfo(TypeRule))&&(KeyWord'="")){//手术并发症
			Set KeywordScr = ##class(DHCMA.IMP.Task.IMPScreeningSrv).KeywordMatching(aEpisodeID,KeyWord)
			if (KeywordScr'=""){
				Set result=..updateByCatAndEpis(aEpisodeID,Parref)
				if (result>0){
					Set Count=Count+1
				}else{
					Set ECount=ECount+1
				}
			}
		}
	}
	Set return=Count
	Quit return
}

/// Creator：     zhangdc
/// CreatDate：   2020-06-11
/// Description:  根据分类和就诊id保存记录
/// Table：       DHCMA.IMP.IP.IMPRecord
/// Others:  	  成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.IMP.Task.IMPScreeningSrv).updateByCatAndEpis(67,4)
ClassMethod updateByCatAndEpis(aEpisodeID As %String, Category As %String) As %String
{
	New (aEpisodeID,Category)
	Set return=0,returnLog=0
	Quit:(aEpisodeID="")||(Category="") return
	
	//Set objCategory = ##class(DHCMA.IMP.BT.IMPCategory).GetObjById(Category)
	Set objReMark = $o(^MA.IMP.IPIMPRecordI("IndexEpisCateOrdNo"," "_$zcvt(aEpisodeID,"U"),Category,-1))
	//Set ReMake=objCategory.BTIsReMark
	Quit:objReMark'="" -222
	
	Set AdmDoc=$p($g(^PAADM(aEpisodeID)),"^",9)
	Set AdmLoc=$p($g(^PAADM(aEpisodeID)),"^",4)
	Set AdmWard=$p($g(^PAADM(aEpisodeID)),"^",70)
	Set:AdmWard'="" AdmWard=$p($g(^PAWARD(AdmWard)),"^",5)
	
	Set KeyWord = ##class(DHCMA.IMP.BTS.SemanticWordSrv).QrySemanticWByCategory(Category)
	
	Set KeywordScr=""
	Set:KeyWord'="" KeywordScr = ##class(DHCMA.IMP.Task.IMPScreeningSrv).KeywordMatching(aEpisodeID,KeyWord)
	
	//危重病例 记录码：医嘱ID
	//非计划重返住院 记录码：就诊号
	//非计划重返手术室 记录码：手麻记录ID
	//非计划重返ICU 记录码：转科记录ID
	//长期住院 记录码：就诊号
	Set IMPOrdNo = ##class(DHCMA.IMP.Task.IMPScreeningSrv).getOrdNo(aEpisodeID,Category)
	Set HappenDateAndTime = ##class(DHCMA.IMP.Task.IMPScreeningSrv).getHappenDateAndTime(aEpisodeID,Category)
	Set HappenDate=$p(HappenDateAndTime,",",1)
	Set HappenTime=$p(HappenDateAndTime,",",2)
	
	Set ID=""
	Set ID=$o(^MA.IMP.IPIMPRecordI("IndexEpisCateOrdNo"," "_$zcvt(aEpisodeID,"U"),Category," "_$zcvt(IMPOrdNo,"U"),ID))
	if ID'=""{
		Set objRecord=##class(DHCMA.IMP.IP.IMPRecord).GetObjById(ID)
		Quit:'$IsObject(objRecord)
		Set LnkEpisInfo 	= objRecord.LnkEpisInfo
		Set LnkOperInfo 	= objRecord.LnkOperInfo
		Set IMPReasonDr		= objRecord.IMPReasonDr
		Set OccuLocID		= AdmLoc
		Set OccuWardID		= AdmWard
		Set OccuDocID		= AdmDoc
		Set HappenDate 		= HappenDate
		Set HappenTime 		= HappenTime
		Set StatusDr 		= objRecord.StatusDr.%Id()
		Set Opinion 	  	=objRecord.Opinion
		set aInputStr=ID_"^"_aEpisodeID_"^"_LnkEpisInfo_"^"_LnkOperInfo_"^"_Category_"^"_IMPOrdNo_"^"_KeywordScr_"^"_IMPReasonDr_"^"_OccuLocID_"^"_OccuWardID_"^"_OccuDocID_"^"_HappenDate_"^"_HappenTime_"^"_StatusDr_"^"_Opinion_"^"_+$h_"^"_$p($h,",",2)_"^"_""_"^"_1
		set return=##class(DHCMA.IMP.IP.IMPRecord).Update(aInputStr)
	}else{
		Set Status=##class(DHCMA.Util.BT.Dictionary).GetObjByPCodeItemDesc("IMPStatus","自动标记")
		Set:$IsObject(Status) Status=Status.%Id()
		Set LinkedEpisodeID=..getLastEpisodeID(aEpisodeID)
		Set LinkedSurInfoID=..getLastSurInfoID(aEpisodeID)
		set aInputStr=""_"^"_aEpisodeID_"^"_LinkedEpisodeID_"^"_LinkedSurInfoID_"^"_Category_"^"_IMPOrdNo_"^"_KeywordScr_"^"_""_"^"_AdmLoc_"^"_AdmWard_"^"_AdmDoc_"^"_HappenDate_"^"_HappenTime_"^"_Status_"^"_""_"^"_+$h_"^"_$p($h,",",2)_"^"_""_"^"_1
		set return=##class(DHCMA.IMP.IP.IMPRecord).Update(aInputStr)
		}
		
	if (return>0){
		set aLogInputStr=return_"^"_""_"^"_""_"^"_""_"^"_3_"^"_""_"^"_""_"^"_""_"^"_""
		set returnLog=##class(DHCMA.IMP.IP.IMPRecordLog).Update(aLogInputStr)
	}
	
	Quit return
}

/// Creator：     zhangdc
/// CreatDate：   2020-06-15
/// Description:  根据本次就诊id获取上次就诊id
/// Table：       PA_Adm、PA_PatMas
/// Others:  	  存在：返回id，没有：返回0
/// w ##class(DHCMA.IMP.Task.IMPScreeningSrv).getLastEpisodeID(653)
ClassMethod getLastEpisodeID(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=0
	Quit:(aEpisodeID="") return
	
	Set PAADMPAPMIDR=$p($g(^PAADM(aEpisodeID)),"^",1)		//PA_Patmas
	Quit:PAADMPAPMIDR="" return
	
	Set PAADMPAPMIDR=$p($g(^PAADM(aEpisodeID)),"^",1)		//PA_Patmas
	Quit:(PAADMPAPMIDR="")
	Set xAdmType=""
	Set NearID=0
	For {
	    Set xAdmType=$o(^PAADM(+PAADMPAPMIDR,"ADM",xAdmType))
	    Quit:(xAdmType="")
	    Set xADMId=""
	    For{
		    Set xADMId=$o(^PAADM(+PAADMPAPMIDR,"ADM",xAdmType,xADMId))
		    Quit:(xADMId="")
		    Continue:(xADMId>=aEpisodeID)
		    Set:(NearID<xADMId) NearID=xADMId
		}
	}
	Set:(NearID'=0) return=NearID
	
	/*Set LastEpisodeID = $o(^PAADM(aEpisodeID),-1)
	Set PAADMPAPMIDRLast=$p($g(^PAADM(LastEpisodeID)),"^",1)
	if (PAADMPAPMIDRLast=PAADMPAPMIDR){
		Set return=LastEpisodeID
	}else{
		For {
			Set LastEpisodeID = $o(^PAADM(LastEpisodeID),-1)
			Quit:LastEpisodeID=""
			Set PAADMPAPMIDRLast=$p($g(^PAADM(LastEpisodeID)),"^",1)
			if (PAADMPAPMIDRLast=PAADMPAPMIDR){ 
				Set return=LastEpisodeID
				quit
			}
		}
	} */
	Quit return
}

/// Creator：     dengshaopeng
/// CreatDate：   2020-11-20
/// Description:  根据本次就诊id获取上次住院就诊id
/// Table：       PA_Adm、PA_PatMas
/// Others:  	  存在：返回id，没有：返回0
/// w ##class(DHCMA.IMP.Task.IMPScreeningSrv).getLastHospEpisodeID(653)
ClassMethod getLastHospEpisodeID(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=0
	Quit:(aEpisodeID="") return
	
	Set PAADMPAPMIDR=$p($g(^PAADM(aEpisodeID)),"^",1)		//PA_Patmas
	Quit:PAADMPAPMIDR="" return
	
	Set LastEpisodeID = $o(^PAADM(aEpisodeID),-1)
	Set PAADMPAPMIDRLast=$p($g(^PAADM(LastEpisodeID)),"^",1)
	Set AdmType = $p($g(^PAADM(LastEpisodeID)),"^",2)
	
	if ((PAADMPAPMIDRLast=PAADMPAPMIDR)&(AdmType["I")){
		Set return=LastEpisodeID
	}else{
		For {
			Set LastEpisodeID = $o(^PAADM(LastEpisodeID),-1)
			Quit:LastEpisodeID=""
			Set PAADMPAPMIDRLast=$p($g(^PAADM(LastEpisodeID)),"^",1)
			Set LastAdmType = $p($g(^PAADM(LastEpisodeID)),"^",2)
			if ((PAADMPAPMIDRLast=PAADMPAPMIDR)&(LastAdmType["I")){ 
				Set return=LastEpisodeID
				quit
			}
		}
	} 
	Quit return
}

/// Creator：     zhangdc
/// CreatDate：   2020-06-15
/// Description:  根据本次就诊id获取本次手术id
/// Table：       PA_Adm、PA_PatMas
/// Others:  	  存在：返回id，没有：返回0
/// w ##class(DHCMA.IMP.Task.IMPScreeningSrv).getLastSurInfoID(5)
ClassMethod getLastSurInfoID(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=0
	Quit:(aEpisodeID="") return
	
	Set OperArr=""
	Set OperArr=$o(^DHCANOPArrange(0,"Adm",aEpisodeID,OperArr),-1)			//手术排班表 DHC_AN_OPArrange
	
	Set return=OperArr
	Quit return
}

/// Creator：     zhangdc
/// CreatDate：   2020-06-30
/// Description:  语义分析返回值
/// Table：       
/// Others:  	  
/// w ##class(DHCMA.IMP.Task.IMPScreeningSrv).KeywordScreening(4)
ClassMethod KeywordScreening(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:(aEpisodeID="") return
	
	Set data1="",data2="",data3=""
	//本次入院记录	HDSD00.13.114
	Set data1=##class(DHCMA.Util.IO.FromEmrNewSrv).GetDataByGlossaryXStr(aEpisodeID,"HDSD00.13.114")
	
	//首次病程记录	HDSD00.14.137
	Set data2=##class(DHCMA.Util.IO.FromEmrNewSrv).GetDataByGlossaryXStr(aEpisodeID,"HDSD00.14.137")
	//上次出院记录  HDSD00.16.007
	set LinkedEpisodeID = ##class(DHCMA.IMP.Task.IMPScreeningSrv).getLastEpisodeID(aEpisodeID)
	Set data3=##class(DHCMA.Util.IO.FromEmrNewSrv).GetDataByGlossaryXStr(aEpisodeID,"HDSD00.16.007")
	
	Set arrData1=##Class(%Library.ArrayOfDataTypes).%New()
	Set arrData2=##Class(%Library.ArrayOfDataTypes).%New()
	Set arrData3=##Class(%Library.ArrayOfDataTypes).%New()
	
	Set name1="",name2="",name3=""
	
	Set arrData1 = ##class(DHCMA.Util.IO.AnalyDHCSrv).GetJsonResult(data1)
	
	if (arrData1.Count() > 0){
		For idx=0:1:arrData1.Count()-1{
			Set name1=name1_","_arrData1.GetAt(idx).GetAt("name")
		}
		Set:name1'="" name1="入院记录:"_""_$e(name1,2,$l(name1))
	}
	Set arrData2 = ##class(DHCMA.Util.IO.AnalyDHCSrv).GetJsonResult(data2)
	
	if (arrData2.Count() > 0){
		For idx=0:1:arrData2.Count()-1{
			Set name2=name2_","_arrData2.GetAt(idx).GetAt("name")
		}
		Set:name2'="" name2="首次病程记录:"_""_$e(name2,2,$l(name2))
	}
	Set arrData3 = ##class(DHCMA.Util.IO.AnalyDHCSrv).GetJsonResult(data3)
	if (arrData3.Count() > 0){
		For idx=0:1:arrData3.Count()-1{
			Set name3=name3_","_arrData3.GetAt(idx).GetAt("name")
		}
		Set:name3'="" name3="上次出院记录:"_""_$e(name3,2,$l(name3))
	}
	Set return=name1_";"_name2_";"_name3
	Quit return
}

/// Creator：     zhangdc
/// CreatDate：   2020-07-01
/// Description:  语义分析返回值匹配判断规则关键词
/// Table：       
/// Others:  	  
/// w ##class(DHCMA.IMP.Task.IMPScreeningSrv).KeywordMatching(638,"出血,血肿,伤口愈合不良,伤口裂开,伤口感染,发热,肠瘘,胆瘘,胰瘘,腹腔感染,胸腔感染,引流管脱落,腹痛,胸痛,胸闷,静脉血栓,胃瘫,胃排空障碍,胸腔积液,腰痛,脑脓肿,咳血,下肢肿胀,造口旁疝,关节脱位,关节感染,肠梗阻,直肠阴道瘘,脑脊液瘘,吻合口瘘,支架术后胸痛,胸闷,心悸,术后视力下降,乳糜瘘,败血症,腹腔积液,感染性休克")
ClassMethod KeywordMatching(aEpisodeID As %String, KeyWord As %String) As %String
{
	New (aEpisodeID,KeyWord)
	Set return=""
	Quit:(aEpisodeID="")||(KeyWord="") return
	
	Set data = ##class(DHCMA.IMP.Task.IMPScreeningSrv).KeywordScreening(aEpisodeID)
	for idx=1:1:3{
		Set datas=$p(data,";",idx)
		continue:datas=""
		Set datas1=$p(datas,":",1)
		Set datas2=$p(datas,":",2)
		Set mac=""
		For i=1:1:$l(datas2,","){
			Set:$F(KeyWord,$p(datas2,",",i))>0 mac=mac_","_$p(datas2,",",i)
		}
		Set:mac'="" mac=$e(mac,2,$l(mac)) 
		Set:mac'="" return=return_";"_datas1_":"_mac
	}
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
}

/// Creator：     zhangdc
/// CreatDate：   2020-10-9
/// Description:  根据就诊id和患者分类获取唯一记录码
/// Table：       
/// Others:  	  存在：返回记录码，没有：返回空
/// w ##class(DHCMA.IMP.Task.IMPScreeningSrv).getOrdNo(5)
ClassMethod getOrdNo(aEpisodeID As %String, aCateDr As %String) As %String
{
	New (aEpisodeID,aCateDr)
	Set return=""
	Quit:(aEpisodeID="")||(aCateDr="") return
	
	//危重病例 记录码：医嘱ID
	//非计划重返住院 记录码：就诊号
	//非计划重返手术室 记录码：手麻记录ID
	//非计划重返ICU 记录码：转科记录ID
	//手术并发症 记录码：手麻记录ID
	Set CategoryDesc=""
	Set CatCode=""
	Set Category = ##class(DHCMA.IMP.BT.IMPCategory).GetObjById(aCateDr)
	Set:$IsObject(Category) CategoryDesc=Category.BTDesc,CatCode=Category.BTCode
	Set TimeFlg =$h
	Set return=aEpisodeID_"!!"_CatCode_"!!"_TimeFlg
	/*if (CategoryDesc="危重病例"){
		Set OrderID=$o(^OEORD(0,"Adm",aEpisodeID,""))	//医嘱ID
		Set return=OrderID
	}elseif((CategoryDesc="非计划重返住院") || (CategoryDesc="长期住院")){
		Set return=aEpisodeID
	}elseif((CategoryDesc="非计划重返手术") || (CategoryDesc="手术并发症")){
		Set opaId=$O(^DHCANOPArrange(0,"Adm",aEpisodeID,""))		//手麻记录ID
		Set return=opaId
	}elseif(CategoryDesc="非计划重返ICU"){
		Set TransRecordIdNew = $o(^Nur.Data.TransRecordI("TransEpisodeID"," "_aEpisodeID,""),-1)	//转科表Nur_Data.transRecord
		Set ToLocID   = $lg(^Nur.Data.TransRecordD(TransRecordIdNew),4)			//转入科室ID
		Set return=ToLocID
	}*/
	Quit return
}

/// Creator：     zhangdc
/// CreatDate：   2020-10-9
/// Description:  根据就诊id和患者分类获取发生日期和发生时间
/// Table：       
/// Others:  	  
/// w ##class(DHCMA.IMP.Task.IMPScreeningSrv).getHappenDateAndTime(131,3)
ClassMethod getHappenDateAndTime(aEpisodeID As %String, aCateDr As %String) As %String
{
	New (aEpisodeID,aCateDr)
	Set return=""
	Quit:(aEpisodeID="")||(aCateDr="") return
	
	//危重病例发生日期是医嘱开始时间；
	//非计划重返手术发生日期是手术日期（手术开始时间）；
	//手术并发症发生日期是手术日期（手术开始时间）；
	//非计划重返住院发生日期是住院日期（就诊时间）；
	//非计划重返ICU发生日期是转入日期；
	//长期住院发生日期是住院日期（就诊时间）；
	Set (CategoryDesc,StartTime,SDate,STime)=""
	Set Category = ##class(DHCMA.IMP.BT.IMPCategory).GetObjById(aCateDr)
	Set:$IsObject(Category) CategoryDesc=Category.BTDesc
	if (CategoryDesc="危重病例"){
		Set OrderID=$o(^OEORD(0,"Adm",aEpisodeID,""))						//医嘱表OE_Order
		Quit:OrderID="" return
		Set xID = 0
		For {
			Set xID = $o(^OEORD(OrderID,"I",xID))							//医嘱明细表OE_OrdItem 
			Quit:xID=""
			Set OEORIItemStatDR=$p($G(^OEORD(OrderID,"I",xID,1)),"^",13)	//OEORIItemStatDR->医嘱状态OEC_OrderStatus
			Set OSTATCode=$p($G(^OEC("OSTAT",OEORIItemStatDR)),"^",1)		//医嘱状态
			Continue:OSTATCode'="V"											//过滤为非核实状态的
			Set OEORIItmMastDR = $p($G(^OEORD(OrderID,"I",xID,1)),"^",2)	//OEORIItmMastDR->医嘱项ARC_ItmMast
			Continue:OEORIItmMastDR=""
			Set Code1=$p(OEORIItmMastDR,"||",1)				
			Set Code2=$p(OEORIItmMastDR,"||",2)
			Set Desc = $p(^ARCIM(Code1,Code2,1),"^",2)						//ARCIMDesc
			if ((Desc="病危") || (Desc="病重")){
				Set SttDat = $p($G(^OEORD(OrderID,"I",xID,1)),"^",9)
				Set:SttDat'="" SttDat=$zd(SttDat,3)
				Set SttTim = $p($G(^OEORD(OrderID,"I",xID,1)),"^",10)
				Set:SttTim'="" SttTim=$zt(SttTim,1)	
				Set StartTime = SttDat_","_SttTim
				Quit
			}
		}
		Set return=StartTime
	}elseif((CategoryDesc="非计划重返住院") || (CategoryDesc="长期住院")){
		Set AdmInfo=$g(^PAADM(aEpisodeID))
		Set AdmitDate=$p(AdmInfo,"^",6)
		Set:AdmitDate'="" AdmitDate=$zd(AdmitDate,3)
		Set AdmitTime=$p(AdmInfo,"^",7)
		Set:AdmitTime'="" AdmitTime=$zt(AdmitTime,1)
		Set StartTime = AdmitDate_","_AdmitTime
		Set return=StartTime
	}elseif((CategoryDesc="非计划重返手术")||(CategoryDesc="手术并发症")){
		Set rs=##Class(%Library.ResultSet).%New("DHCMA.IMP.IPS.OperCompRegSrv:GetAnOpListForM")
		Do rs.Execute("","",aEpisodeID)
		while(rs.Next()){
			Set SDate=rs.GetData(6)
			Set STime=rs.GetData(7)
			Set StartTime = SDate_","_STime
			Quit
		}
		Set return=StartTime
	}elseif(CategoryDesc="非计划重返ICU"){
		Set TransRecordIdNew = $o(^Nur.Data.TransRecordI("TransEpisodeID"," "_aEpisodeID,""),-1)	//转科表Nur_Data.transRecord
		Set:TransRecordIdNew'="" SDate = $lg(^Nur.Data.TransRecordD(TransRecordIdNew),12)			
		Set:TransRecordIdNew'="" STime = $lg(^Nur.Data.TransRecordD(TransRecordIdNew),13)			
		Set StartTime = SDate_","_STime
		Set return=StartTime
	}
	Quit return
}

}
