/// 抗菌素敏感性监控函数类库(嵌入式监控)
/// 创建者：李阳
/// 创建日期：2013-06-16
Class DHCMed.CCService.Lib.Embed.DrugSenLib Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// <H3>功能：测试是否有培养出细菌</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>//BugList</B>：细菌名列表，之间可以用任何分隔符分开</LI>
/// <LI><B>BugList</B>：细菌名或者WHONet码列表，之间可以用任何分隔符分开</LI>
/// 	<LI><B>%Value:LabEpisodeNo</B></LI>
/// </OL>
/// <H4>返回值:</H4>
/// 1--检测出细菌  0--正常
/// </OL>
/// <H4>备注：</H4>
/// <OL>
/// <LI>如果不指明细菌，则查询任何阳性菌。</LI>
/// <LI>//removed by wuqk 培养结果如果是：未检出致病菌、未检查出菌、无菌生长 系统会自动排除。</LI>
/// <LI>add by wuqk 2012-08-31 培养结果的WHONet代码如果是：xxx ，系统会自动排除。</LI>
/// </OL>
/// w ##class(DHCMed.CCService.Lib.DrugSenLib).HasBugs("")
ClassMethod HasBugs(BugList As %String = "") As %Integer
{
	New (BugList,%EpisodeID,%ExtraData,%ErrorData,%Value)
	Set return=0,Count=0
	Set BugList=$g(BugList)
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set PatientID=$p($g(^PAADM(%EpisodeID)),"^",1)
	Set TestSetRow=%Value
	Set OEItemID=..GetOrderItemIDByTestSetRow(TestSetRow)
	Set objOEItem=##class(DHCMed.Base.OrdItem).GetObjById(OEItemID)
	Quit:'$IsObject(objOEItem) return
	Set OEItemStatus=objOEItem.OSTATCode
	Set OSTATDesc=objOEItem.OSTATDesc
	Quit:(OSTATDesc'="执行")&&(OSTATDesc'="核实") return
	Quit:(OEItemStatus="D")||(OEItemStatus="S") return //检查医嘱状态
		
	Set TestSetRow=objOEItem.OEORILabEpisodeNo
	Set Epis=$p(TestSetRow,"||",1)
	Set TS=$p(TestSetRow,"||",2)
	Set TSCount=$p(TestSetRow,"||",3)
	Quit:(Epis="")||(TS="")||(TSCount="") return
				
	//update by lyh 2013-2-6 把检验医嘱日期 改成 报告日期
	Quit:$p($g(^TEPI(Epis,1,TS,TSCount)),"\",31)'="A" return
			 	
	Set SubmissionDate=$p($g(^TEPI(Epis,1,TS,TSCount)),"\",69)
	Set SubmissionTime=$p($g(^TEPI(Epis,1,TS,TSCount)),"\",70)
	If SubmissionDate="" {
		Set SubmissionDate=$p($g(^TEPI(Epis,1,TS,TSCount)),"\",1)
		Set SubmissionTime=$p($g(^TEPI(Epis,1,TS,TSCount)),"\",2)
	}
	
	Set BugResult="",flg=0
	Set ItmCode=""
	For {
		Set ItmCode=$o(^TEPI(Epis,1,TS,TSCount,"DATA",ItmCode))
		Quit:ItmCode=""
		
		Set RstType=$p($g(^TTAB("TC",ItmCode)),"\",3)
		Continue:RstType'="V"
		Set Result=$p($g(^TEPI(Epis,1,TS,TSCount,"DATA",ItmCode)),"\",1)
		Continue:Result=""
		Set tmpResult=$P($g(^TTAB("BUG",Result)),"\",1)           //细菌名称
		Continue:tmpResult=""
					
		//细菌whonet码 表：CT _Bugs  字段：CTBUG_Synonym
		Set tmpWHONetCode=$P($g(^TTAB("BUG",Result)),"\",8)
		If tmpWHONetCode'="" {
			Continue:tmpWHONetCode="xxx"
			Continue:(tmpWHONetCode["正常")||(tmpWHONetCode["无细菌生长")
			Continue:((BugList'[tmpWHONetCode)&&(BugList'=""))
		} Else {
			Continue:(tmpResult["[]")||(tmpResult["正常")||(tmpResult["疑似")
			Continue:(tmpResult["无细菌")||(tmpResult["无菌")
			Continue:(tmpResult["未检出")||(tmpResult["未检查出")
			Continue:((BugList'[tmpResult)&&(BugList'=""))
		}
					
		Set BugResult=BugResult_tmpResult_";"
		Set flg=1
	}
	Quit:flg=0 return
	Set UserName=$p($g(^TTAB("DR",$p($g(^TEPI(Epis)),"\",13))),"\",1) //医师信息
	Set:UserName'="" BugResult=BugResult_"("_UserName_")"
	
	Set Count=Count+1
	
	Set TempData=""
	Set $p(TempData,$c(3),1)=ArcimDesc_"("_BugResult_")"
	Set $p(TempData,$c(3),2)=+SubmissionDate
	Set $p(TempData,$c(3),3)=+SubmissionTime
	Set $p(TempData,$c(3),4)=tmpResult
	Set $p(TempData,$c(3),5)=OEItemID
	Set $p(TempData,$c(3),6)=""
	
	Set OEItemID=..GetOrderItemIDByTestSetRow(TestSetRow)
	Set $p(tmp,$c(3),7)="PatientBanner=1&PatientID="_PatientID_"&TestSetRow="_TestSetRow_"&OrderID="_OEItemID
				
	Set %ExtraData=%ExtraData_$lb(TempData)
	
	Set return=Count
	Quit return
}

/// <H3>功能：测试培养出的细菌是否对某种抗菌素敏感</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>BugList</B>：细菌列表，之间可以用任何分隔符分开</LI>
/// <LI><B>AntiList</B>：抗菌素列表，之间可以用任何分隔符分开</LI>
/// <LI><B>SenFlag</B>：药敏结果列表，之间可以用任何分隔符分开 add by wuqk 2012-08-31 </LI>
/// </OL>
/// <H4>返回值:</H4>
/// 1--检测出细菌  0--正常
/// </OL>
/// <H4>备注：</H4>
/// <OL>
/// <LI>如果不指明细菌，则查询所有阳性菌。</LI>
/// <LI>如果不指明抗菌素，则查询所有抗生素。</LI>
/// <LI>//removed by wuqk 培养结果如果是：未检出致病菌、未检查出菌、无菌生长 系统会自动排除。</LI>
/// <LI>add by wuqk 2012-08-31 培养结果的WHONet代码如果是：xxx ，系统会自动排除。</LI>
/// </OL>
/// w ##class(DHCMed.CCService.Lib.DrugSenLib).DrugSen()
ClassMethod DrugSen(BugList As %String, AntiList As %String, SenFlag As %String) As %Integer
{
	New (BugList,AntiList,SenFlag,%EpisodeID,%ExtraData,%ErrorData,%Value)
	Set return=0,Count=0
	Set BugList=$g(BugList)
	Set AntiList=$g(AntiList)
	Set SenFlag=$g(SenFlag)
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set PatientID=$p($g(^PAADM(%EpisodeID)),"^",1)
	Set TestSetRow=%Value
	Set OEItemID=..GetOrderItemIDByTestSetRow(TestSetRow)
	Set objOEItem=##class(DHCMed.Base.OrdItem).GetObjById(OEItemID)
	Quit:'$IsObject(objOEItem) return
	Set OEItemStatus=objOEItem.OSTATCode
	Set OSTATDesc=objOEItem.OSTATDesc
	Quit:(OSTATDesc'="执行")&&(OSTATDesc'="核实") return
	Quit:(OEItemStatus="D")||(OEItemStatus="S") return //检查医嘱状态
	Set Epis=$p(TestSetRow,"||",1)
	Set TS=$p(TestSetRow,"||",2)
	Set TSCount=$p(TestSetRow,"||",3)
	Quit:(Epis="")||(TS="")||(TSCount="") return
			 	
	//update by lyh 2013-2-6 把检验医嘱日期 改成 报告日期
	Quit:$p($g(^TEPI(Epis,1,TS,TSCount)),"\",31)'="A" return
	Set SubmissionDate=$p($g(^TEPI(Epis,1,TS,TSCount)),"\",69)
	Set SubmissionTime=$p($g(^TEPI(Epis,1,TS,TSCount)),"\",70)
	If SubmissionDate="" {
		Set SubmissionDate=$p($g(^TEPI(Epis,1,TS,TSCount)),"\",1)
		Set SubmissionTime=$p($g(^TEPI(Epis,1,TS,TSCount)),"\",2)
	}
	
	Set SenResult="",flg=0
	Set ItmCode=""
	For {
		Set ItmCode=$o(^TEPI(Epis,1,TS,TSCount,"DATA",ItmCode))
		Quit:ItmCode=""
		Set RstType=$p($g(^TTAB("TC",ItmCode)),"\",3)
		Continue:RstType'="V"
		
		//update by zf 2013-04-12
		//药敏结果存储Global
		//如果Global不存在说明没有药敏结果
		Continue:'$d(^TEPI(Epis,1,TS,TSCount,"DATA",ItmCode,"ANT"))
		
		Set Result=$p($g(^TEPI(Epis,1,TS,TSCount,"DATA",ItmCode)),"\",1)
		Continue:Result=""
		Set tmpResult=$P($g(^TTAB("BUG",Result)),"\",1)           //细菌名称
		Continue:tmpResult=""
		
		//细菌whonet码 表：CT _Bugs  字段：CTBUG_Synonym
		Set tmpWHONetCode=$P($g(^TTAB("BUG",Result)),"\",8)
		If tmpWHONetCode'="" {
			Continue:tmpWHONetCode="xxx"
			Continue:(tmpWHONetCode["正常")||(tmpWHONetCode["无细菌生长")
			Continue:((BugList'[tmpWHONetCode)&&(BugList'=""))
		} Else {
			Continue:(tmpResult["[]")||(tmpResult["正常")||(tmpResult["疑似")
			Continue:(tmpResult["无细菌")||(tmpResult["无菌")
			Continue:(tmpResult["未检出")||(tmpResult["未检查出")
			Continue:((BugList'[tmpResult)&&(BugList'=""))
		}
					
		Set SenResult=SenResult_tmpResult_" 耐药:["
		Set Anti=""
		For {
			Set Anti=$o(^TEPI(Epis,1,TS,TSCount,"DATA",ItmCode,"ANT",Anti))
			Quit:Anti=""
			
			Set (AntiName,SenTestID,SenTestDesc)=""
			Set AntiName=$p($g(^TTAB("ANT",Anti)),"\",1)
			Continue:AntiName=""
			Continue:((AntiList[AntiName)&&(AntiName'[AntiList)) //过滤药物
			
			Set tmpSenTest=$g(^TEPI(Epis,1,TS,TSCount,"DATA",ItmCode,"ANT",Anti))
			Set SenTestCode=$p(tmpSenTest,"\",1)
			Continue:(SenTestCode="")
			Continue:(SenFlag'[SenTestCode)
			Set SenTestDesc=$p(^TTAB("SENS",SenTestCode),"\",1)
			Set SenResult=SenResult_AntiName_";"
			Set flg=1
		}
		Set SenResult=SenResult_"]"
		
		Continue:flg=0
		Set UserName=$p($g(^TTAB("DR",$p($g(^TEPI(Epis)),"\",13))),"\",1) //医师信息
		Set:UserName'="" SenResult=SenResult_"("_UserName_")"
				
		Set Count=Count+1
				
		Set TempData=""
		Set $p(TempData,$c(3),1)=ArcimDesc_"("_SenResult_")"
		Set $p(TempData,$c(3),2)=+SubmissionDate
		Set $p(TempData,$c(3),3)=+SubmissionTime
		Set $p(TempData,$c(3),4)=tmpResult
		Set $p(TempData,$c(3),5)=OEItemID
		Set $p(TempData,$c(3),6)=""
				
		Set OEItemID=..GetOrderItemIDByTestSetRow(TestSetRow)
		Set $p(TempData,$c(3),7)="PatientBanner=1&PatientID="_PatientID_"&TestSetRow="_TestSetRow_"&OrderID="_OEItemID
				
		Set %ExtraData=%ExtraData_$lb(TempData)
	}
	Set return=Count
	Quit return
}

ClassMethod MultiDrugSen(BugList As %String, AntiList As %String, SenFlag As %String) As %Integer
{
	n (BugList,AntiList,SenFlag,%EpisodeID,%ExtraData,%ErrorData,%Value)
	Set ret=0	
	Set TestSetRow=%Value
	Set OEItemID=..GetOrderItemIDByTestSetRow(TestSetRow)
	Set objOEItem=##class(DHCMed.Base.OrdItem).GetObjById(OEItemID)
	Quit:'$IsObject(objOEItem) ret
	Set OEItemStatus=objOEItem.OSTATCode
	Set OSTATDesc=objOEItem.OSTATDesc
	Quit:(OSTATDesc'="执行")&&(OSTATDesc'="核实") ret
	Quit:(OEItemStatus="D")||(OEItemStatus="S") ret //检查医嘱状态
			 		
 	Set Epis=$p(TestSetRow,"||",1)
 	Set TS=$p(TestSetRow,"||",2)
 	Set TSCount=$p(TestSetRow,"||",3)
 	Quit:(Epis="")||(TS="")||(TSCount="") ret
			 	
	//update by lyh 2013-2-6 把检验医嘱日期 改成 报告日期
 	Quit:$p($g(^TEPI(Epis,1,TS,TSCount)),"\",31)'="A" ret
	Set SubmissionDate=$p($g(^TEPI(Epis,1,TS,TSCount)),"\",69)
	Set SubmissionTime=$p($g(^TEPI(Epis,1,TS,TSCount)),"\",70)
				
	Set ItmCode=""
	For {
		Set ItmCode=$o(^TEPI(Epis,1,TS,TSCount,"DATA",ItmCode))
		Quit:ItmCode=""
		Set RstType=$p($g(^TTAB("TC",ItmCode)),"\",3)
		Continue:RstType'="V"
		Set Result=$p($g(^TEPI(Epis,1,TS,TSCount,"DATA",ItmCode)),"\",1)
		Set tmpResult=$P($g(^TTAB("BUG",Result)),"\",1)
		Continue:"未检出致病菌^未检查出菌^无菌生长"[tmpResult
		Continue:tmpResult=""
		Continue:(tmpResult["正常")||(tmpResult["无细菌生长")
		Continue:((BugList'[tmpResult)&&(BugList'="")) //过滤细菌
		Set Anti=""
		For {
			Set Anti=$o(^TEPI(Epis,1,TS,TSCount,"DATA",ItmCode,"ANT",Anti))
			Quit:Anti=""
			
			Set (AntiName,SenTestID,SenTestDesc)=""
			Set AntiName=$p($g(^TTAB("ANT",Anti)),"\",1)
			Continue:AntiName=""
			Continue:((AntiList[AntiName)&&(AntiName'[AntiList)) //过滤药物
			Set tmpSenTest=$g(^TEPI(Epis,1,TS,TSCount,"DATA",ItmCode,"ANT",Anti))
			Set SenTestDesc=$p(tmpSenTest,"\",1)
			Set:SenTestDesc'="" SenTestDesc=$p(^TTAB("SENS",SenTestDesc),"\",1)
			Continue:(SenFlag'[SenTestDesc)
			Set:BugFoundList'[tmpResult BugFoundList=BugFoundList_"^"_tmpResult //组织阳性菌列表
			Set:AntiFoundList'[AntiName AntiFoundList=AntiFoundList_"^"_AntiName //组织敏感抗生素列表
		}
	}


	//汇总结果
	Set repid=$$PrepareSenDic(BugList,AntiList)
	Set SenCateCnt=$$GetSenCateResult(repid,BugFoundList,AntiFoundList) //药敏种类
	Set Summary="细菌："_$tr(BugFoundList,"^","、")_"，抗菌素："_$tr(AntiFoundList,"^","、")
	Set tmp=$$BuildMultiDrugSenResult(Summary)
	Set %ExtraData=%ExtraData_$lb(tmp)
	
	Quit ret
PrepareSenDic(BugList,AntiList)
	n (BugList,AntiList)
	Set repid1=$I(^CacheTemp)
	For i=1:1:$l(BugList,"#") {
		Set Type="Type"_i
		Set ^CacheTemp(repid1,"BugType",Type)=""
		Set List=$p(BugList,"#",i)
		For j=1:1:$l(List,"^") {
			Set bug=$p(List,"^",j)
			Continue:bug=""
			Set ^CacheTemp(repid1,"Bug",bug)=Type
		}
	}
	For i=1:1:$l(AntiList,"#") {
		Set Type="Type"_i
		Set ^CacheTemp(repid1,"AntiType",Type)=""
		Set List=$p(AntiList,"#",i)
		For j=1:1:$l(List,"^") {
			Set anti=$p(List,"^",j)
			Continue:anti=""
			Set ^CacheTemp(repid1,"Anti",anti)=Type
		}
	}	
	Quit repid1
	
GetSenCateResult(repid,BugList,AntiList)
	n (repid,BugList,AntiList)
	Set ret=0
	Set repid1=$I(^CacheTemp)
	For i=1:1:$l(BugList,"^") {
		Set bug=$p(BugList,"^",i)
		Continue:bug=""
		Set bugType=$o(^CacheTemp(repid,"Bug",bug,""))
		For j=1:1:$l(AntiList,"^") {
			Set anti=$p(AntiList,"^",j)
			Continue:anti=""
			Set AntiType=$o(^CacheTemp(repid,"Anti",anti,""))	
			Set ^CacheTemp(repid1,"Found",AntiType)=""
		}
	}
	Set AntiType=""
	For {
		Set AntiType=$o(^CacheTemp(repid1,"Found",AntiType))	
		Quit:AntiType=""
		Set ret=ret+1
	}
	Kill ^CacheTemp(repid1)
	Quit ret
	
BuildMultiDrugSenResult(SummaryInfo) //Add By LiYang 2012-06-20
	//ExtraData=$lb(Summary,ActDate,ActTime,DataValue,ObjectID,UserID,Parameters)
	Set User=$g(^TTAB("DR",+$p($g(^TEPI(Epis)),"\",13))) //医师信息
	Set $p(tmp,$c(3),1)="多重耐药结果："_SummaryInfo	//_" 报告人:"_$p(User,"\",1)_" 报告日期:"_$zd(+SubmissionDate,3)_" 报告时间:"_$zt(SubmissionTime,1) update by liuyh 2013-02-27
	Set $p(tmp,$c(3),2)=+SubmissionDate
	Set $p(tmp,$c(3),3)=+SubmissionTime
	Set $p(tmp,$c(3),4)=SummaryInfo
	Set $p(tmp,$c(3),5)=objOEItem.OEORILabEpisodeNo
	Set $p(tmp,$c(3),6)=+$p($g(^TEPI(Epis)),"\",13)
	//update by lyh 2012-11-28 拼凑检验表达式
	Set PatientID=$p($g(^PAADM(%EpisodeID)),"^",1)
	Set $p(tmp,$c(3),7)="PatientBanner=1&PatientID="_PatientID_"&TestSetRow="_TestSetRow_"&OrderID="_OEItemID
	
	//Set $p(tmp,$c(3),7)="BugList:"_BugList_"AntiList:"_AntiList
	Quit tmp
}

/// w ##class(DHCMed.CCService.Lib.DrugSenLib).MultiRDrugSen()
ClassMethod MultiRDrugSen() As %Integer
{
	New (%EpisodeID,%ExtraData,%ErrorData)
	Set ret=0	
	Set TestSetRow=%Value
	Set OEItemID=..GetOrderItemIDByTestSetRow(TestSetRow)
	Set objOEItem=##class(DHCMed.Base.OrdItem).GetObjById(OEItemID)
	Quit:'$IsObject(objOEItem) ret
	Set OEItemStatus=objOEItem.OSTATCode
	Set OSTATDesc=objOEItem.OSTATDesc
	Quit:(OSTATDesc'="执行")&&(OSTATDesc'="核实") ret
	Quit:(OEItemStatus="D")||(OEItemStatus="S") ret //检查医嘱状态
			 		
	Quit:$p($g(^TEPI(Epis,1,TS,TSCount)),"\",31)'="A" ret
	Set SubmissionDate=$p($g(^TEPI(Epis,1,TS,TSCount)),"\",69)
	Set SubmissionTime=$p($g(^TEPI(Epis,1,TS,TSCount)),"\",70)

	Set SenResult=""
	Set ItmCode=""
	For {
		Set ItmCode=$o(^TEPI(Epis,1,TS,TSCount,"DATA",ItmCode))
		Quit:ItmCode=""
		Set RstType=$p($g(^TTAB("TC",ItmCode)),"\",3)
		Continue:RstType'="V"
		Set Result=$p($g(^TEPI(Epis,1,TS,TSCount,"DATA",ItmCode)),"\",1)
		Continue:Result=""
		Set tmpResult=$P($g(^TTAB("BUG",Result)),"\",1)           //细菌名称
		Set tmpWHONetCode=$P($g(^TTAB("BUG",Result)),"\",8)
		
		If (tmpResult'="")&&(tmpWHONetCode="")
		{
			Continue:'$d(^DHCMed.NINFDi("Py",0,"IndexDesc"," "_tmpResult))
			Set PathID=$o(^DHCMed.NINFDi("Py",0,"IndexDesc"," "_tmpResult,""),-1)
			Continue:PathID=""
			Set PathObj=##class(DHCMed.NINF.Dic.Pathogeny).GetObjById(PathID)
			Continue:'$IsObject(PathObj)
			Set tmpWHONetCode=PathObj.PYWhonet
		} 
					
		Continue:(tmpWHONetCode="xxx")||(tmpWHONetCode="")                              
					
		Continue:tmpResult=""
		Continue:(tmpWHONetCode["正常")||(tmpWHONetCode["无细菌生长")

		Set SenResult="多重耐药菌："_SenResult_"["_tmpResult_"]"_" 耐药抗菌药物:"
		Set Anti="",AntiList=""
		For {
			Set Anti=$o(^TEPI(Epis,1,TS,TSCount,"DATA",ItmCode,"ANT",Anti))
			Quit:Anti=""
			Set (AntiName,SenTestID,SenTestDesc)=""
			Set AntiName=$p($g(^TTAB("ANT",Anti)),"\",1)
			Continue:AntiName=""
			Set tmpSenTest=$g(^TEPI(Epis,1,TS,TSCount,"DATA",ItmCode,"ANT",Anti))
			Set SenTestCode=$p(tmpSenTest,"\",1)
				
			Set AntiWHONetCode=Anti
			If +AntiWHONetCode'=0
			{
				Continue:'$d(^DHCMed.NINFDi("Anti",0,"IndexDesc"," "_AntiName))
				Set AntiID=$o(^DHCMed.NINFDi("Anti",0,"IndexDesc"," "_AntiName,""),-1)
				Continue:AntiID=""
				Set AntiObj=##class(DHCMed.NINF.Dic.Antibiotics).GetObjById(AntiID)
				Continue:'$IsObject(AntiObj)
				Set AntiWHONetCode=AntiObj.ANTWhonet
			} 
					
			Continue:(SenTestCode="")
			Continue:(SenFlag'[SenTestCode)
			Set SenTestDesc=$p(^TTAB("SENS",SenTestCode),"\",1)
			Set SenResult=SenResult_" "_AntiName_";"
			
			Set AntiList=AntiList_"^"_AntiWHONetCode
		}
		Set return=##class(DHCMed.CCService.Lib.MRBLib).CheckIsMRB(tmpWHONetCode,AntiList)
		If return=1
		{
			Set ret=1
		}Else{	
			Set SenResult=""
		}
					
	}
	Quit:SenResult="" ret
	if return=1 {
		set Result=$$BuildRDrugSenResult(SenResult)
		Quit:(Result["[]")||(Result["无")||(Result["正常")||(Result["未检")||(Result["疑似") ret
		Set:$l(%ExtraData)<30000 %ExtraData=%ExtraData_$lb(Result)
	}
	Quit ret
BuildRDrugSenResult(SenResult)
	Set Summary=SenResult
	Set tmp=""
	Set $p(tmp,$c(3),1)=Summary
	Set $p(tmp,$c(3),2)=+SubmissionDate
	Set $p(tmp,$c(3),3)=+SubmissionTime
	Set $p(tmp,$c(3),4)=tmpResult
	Set $p(tmp,$c(3),5)=objOEItem.OEORILabEpisodeNo
	Set $p(tmp,$c(3),6)=+$p($g(^TEPI(Epis)),"\",13)
	

	Set PatientID=$p($g(^PAADM(%EpisodeID)),"^",1)
	Set $p(tmp,$c(3),7)="PatientBanner=1&PatientID="_PatientID_"&TestSetRow="_TestSetRow_"&OrderID="_OEItemID
	
	Quit tmp
}

ClassMethod GetOrderItemIDByTestSetRow(TestSetRow As %String) As %String
{
	n (TestSetRow)
	Set ret=""
	Quit:TestSetRow="" ret
	Set EpisNo=$p(TestSetRow,"||",1)
	Set OrderID=""
	For {
		Set OrderID=$o(^OEORD(0,"EpisNo",EpisNo,OrderID))
		Quit:OrderID=""
		Set ChildSub=""
		For {
			Set ChildSub=$o(^OEORD(0,"EpisNo",EpisNo,OrderID,ChildSub))
			Quit:ChildSub=""
			Set ItemID=OrderID_"||"_ChildSub
			Set objItm=##class(DHCMed.Base.OrdItem).GetObjById(ItemID)
			Continue:'$IsObject(objItm)
			Do objItm.%Close()
			Continue:objItm.OEORILabEpisodeNo'=TestSetRow
			Set ret=ItemID
		}
	}
	Quit ret=""
}

}
