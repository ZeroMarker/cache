/// 名称: DHCMed.CCService.Lib.MRBLib
/// 描述: 与多重耐药菌相关的函数库
/// 编写者：zhufei
/// 编写日期: 2013-06-27
Class DHCMed.CCService.Lib.MRBLib Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.CCService.Lib.MRBLib).Test()
ClassMethod Test()
{
	New
	
	/*
	Set %EpisodeID=20358797
	Set %ExtraData=""
	Set %ErrorData=""
	Set %FromDate=+$h-10
	Set %ToDate=+$h
	Set return=..CheckIsMRB("R")
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	*/
	
	Set %EpisodeID=20771909
	Set %ExtraData=""
	Set %ErrorData=""
	Set %FromDate=+$h-100
	Set %ToDate=+$h
	Set return=..CheckIsESBLs("检验||M0270|等于|阳性||||超广谱β-内酰胺酶ESBL等于阳性","MDRPY012")
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	
	Quit "Over"
}

/// Creator：     zhufei
/// CreatDate：   2013-06-27
/// Description:  通过检验药敏结果检测是否为多重耐药菌
/// Table：       
/// Input：       aSenFlag  : 耐药标志
/// Return：      返回多重耐药菌结果  ret=-1:Error
/// w ##class(DHCMed.CCService.Lib.MRBLib).CheckIsMRB("R")
ClassMethod CheckIsMRB(aSenFlag As %String = "") As %Integer
{
	New (aSenFlag,%EpisodeID,%ExtraData,%ErrorData,%FromDate,%ToDate)
	Set return=0,Count=0
	Set aSenFlag=$g(aSenFlag)
	Set:aSenFlag="" aSenFlag="R"  //默认耐药代码为R
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	Set %FromDate=$g(%FromDate)
	Set %ToDate=$g(%ToDate)
	
	Set PatientID=$p($g(^PAADM(%EpisodeID)),"^",1)
	
	Set xOrdID=$o(^OEORD(0,"Adm",+%EpisodeID,""))
	Set xArcimID=""
	For {
	 	Set xArcimID=$o(^OEORDi(0,"ARCIM",+xOrdID,xArcimID))
	 	Quit:xArcimID=""
	 	
	 	Set objArcim=##Class(DHCMed.Base.Arcim).GetObjById(xArcimID)
	 	Continue:'$IsObject(objArcim)
	 	Set ArcimType=objArcim.ARCICOrderType
	 	Continue:ArcimType'="L"
	 	Set ArcimSubCat=objArcim.ARCICDesc
	 	Continue:ArcimSubCat=""
	 	Set ArcimID=xArcimID
	 	Set ArcimDesc=objArcim.ARCIMDesc
 		
	 	Set xOrdDate=0
	 	For {
		 	Set xOrdDate=$o(^OEORDi(0,"ARCIM",+xOrdID,xArcimID,xOrdDate))
		 	Quit:xOrdDate=""
		 	
		 	Set xSubID=0,return=0
		 	For {
			 	Set xSubID=$o(^OEORDi(0,"ARCIM",+xOrdID,xArcimID,xOrdDate,xSubID))
			 	Quit:xSubID=""
			 	
			 	Set OEItemID=xOrdID_"||"_xSubID
			 	Set objOEItem=##class(DHCMed.Base.OrdItem).GetObjById(OEItemID)
			 	Continue:'$IsObject(objOEItem)
			 	Set OEItemStatus=objOEItem.OSTATCode
				Set OSTATDesc=objOEItem.OSTATDesc
			 	Continue:(OSTATDesc'="执行")&&(OSTATDesc'="核实")
			 	Continue:(OEItemStatus="D")||(OEItemStatus="S")  //检查医嘱状态
				
			 	Set TestSetRow=objOEItem.OEORILabEpisodeNo
			 	Set Epis=$p(TestSetRow,"||",1)
			 	Set TS=$p(TestSetRow,"||",2)
			 	Set TSCount=$p(TestSetRow,"||",3)
			 	Continue:(Epis="")||(TS="")||(TSCount="")
			 	
				//update by lyh 2013-2-6 把检验医嘱日期 改成 报告日期
			 	Continue:$p($g(^TEPI(Epis,1,TS,TSCount)),"\",31)'="A"
				Set SubmissionDate=$p($g(^TEPI(Epis,1,TS,TSCount)),"\",69)
				Set SubmissionTime=$p($g(^TEPI(Epis,1,TS,TSCount)),"\",70)
				If SubmissionDate="" {
					//Set SubmissionDate=$p($g(^TEPI(Epis,1,TS,TSCount)),"\",1)
					//Set SubmissionTime=$p($g(^TEPI(Epis,1,TS,TSCount)),"\",2)
					Set SubmissionDate=$p($g(^TEPI(Epis,1,TS,TSCount)),"\",4)
					Set SubmissionTime=$p($g(^TEPI(Epis,1,TS,TSCount)),"\",5)
				}
				Continue:SubmissionDate=""
				Continue:(%FromDate'="")&&(SubmissionDate<%FromDate)
				Continue:(%ToDate'="")&&(SubmissionDate>%ToDate)
				
				//add by zf 2014-01-24 发生日期和发生时间
				Set OccurDate=$p($g(^OEORD(xOrdID,"I",xSubID,1)),"^",9)  //医嘱开始日期
				Set OccurTime=$p($g(^OEORD(xOrdID,"I",xSubID,1)),"^",10) //医嘱开始时间
				
				Set SenResult="",xPyResult=""
				Set ItmCode=""
				For {
					Set ItmCode=$o(^TEPI(Epis,1,TS,TSCount,"DATA",ItmCode))
					Quit:ItmCode=""
					Set RstType=$p($g(^TTAB("TC",ItmCode)),"\",3)
					Continue:RstType'="V"
					
					Continue:'$d(^TEPI(Epis,1,TS,TSCount,"DATA",ItmCode,"ANT"))
					
					Set Result=$p($g(^TEPI(Epis,1,TS,TSCount,"DATA",ItmCode)),"\",1)
					Continue:Result=""
					Set tmpResult=$P($g(^TTAB("BUG",Result)),"\",1)           //细菌名称
					Continue:tmpResult=""
					
					Set xPyResult=xPyResult_","_tmpResult
					
					//多耐菌
					Set MRBPathogeny=Result
					
					//多耐抗生素
					Set MRBAntiList=""
					Set xSenResult=tmpResult_" 耐药:["
					Set Anti=""
					For {
						Set Anti=$o(^TEPI(Epis,1,TS,TSCount,"DATA",ItmCode,"ANT",Anti))
						Quit:Anti=""
						
						Set (AntiName,SenTestID,SenTestDesc)=""
						Set AntiName=$p($g(^TTAB("ANT",Anti)),"\",1)
						Continue:AntiName=""
						
						Set tmpSenTest=$g(^TEPI(Epis,1,TS,TSCount,"DATA",ItmCode,"ANT",Anti))
						Set SenTestCode=$p(tmpSenTest,"\",1)
						Continue:(SenTestCode="")
						Continue:(aSenFlag'[SenTestCode)
						
						//多耐抗生素
						Set MRBAntiList=MRBAntiList_$lb(Anti)
						
						Set SenTestDesc=$p(^TTAB("SENS",SenTestCode),"\",1)
						Set xSenResult=xSenResult_AntiName_";"
						Set flg=1
					}
					Set xSenResult=xSenResult_"]"
					
					//多重耐药菌检测
					Set MRBStr=##class(DHCMed.NINFService.Dic.MRBSrv).CheckIsMRB(MRBPathogeny,MRBAntiList)
					Continue:MRBStr=""
					
					Set SenResult=SenResult_","_MRBStr_"  "_xSenResult
				}
				Continue:SenResult=""
				Set SenResult=$e(SenResult,2,$l(SenResult))
				Set UserName=$p($g(^TTAB("DR",$p($g(^TEPI(Epis)),"\",13))),"\",1) //医师信息
				Set:UserName'="" SenResult=SenResult_"("_UserName_")"
				Set:xPyResult'="" xPyResult=$e(xPyResult,2,$l(xPyResult))
				
				Set Count=Count+1
				
				Set TempData=""
				Set $p(TempData,$c(3),1)=ArcimDesc_"("_SenResult_")"
				Set $p(TempData,$c(3),2)=+SubmissionDate
				Set $p(TempData,$c(3),3)=+SubmissionTime
				Set $p(TempData,$c(3),4)=xPyResult
				Set $p(TempData,$c(3),5)=OEItemID
				Set $p(TempData,$c(3),6)=""
				
				//update by lyh 2012-11-28 拼凑检验表达式
				Set $p(TempData,$c(3),7)="PatientBanner=1&PatientID="_PatientID_"&TestSetRow="_TestSetRow_"&OrderID="_OEItemID
				
				Set $p(TempData,$c(3),8)=OccurDate
				Set $p(TempData,$c(3),9)=OccurTime
				
				Set %ExtraData=%ExtraData_$lb(TempData)
			}
		}
	}
	
	Set return=Count
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2013-07-05
/// Description:  通过Lab表达式取ESBLs多耐
/// Table：       
/// Input：       LabExp : 检验项目检查表达式
/// Return：      返回检验项目数量  ret=-1:Error
/// w ##class(DHCMed.CCService.Lib.LisReport).CheckIsESBLs("","")
ClassMethod CheckIsESBLs(aLabExp As %String, aCateCode As %String) As %String
{
	New (aLabExp,aCateCode,%EpisodeID,%ExtraData,%ErrorData,%FromDate,%ToDate)
	Set return=0,Count=0
	Quit:(aLabExp="")||(aCateCode="") return
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	Set %FromDate=$g(%FromDate)
	Set %ToDate=$g(%ToDate)
	
	Set LabExp2=$p(aLabExp,"||",2)
	Set LabExp3=$p(aLabExp,"||",3)
	Set TestCode=$p(LabExp2,"|",1)
	Set ComCode=$p(LabExp2,"|",2)
	Set ComValue=$p(LabExp2,"|",3)
	Set ComArcimDesc=$p(LabExp2,"|",4)
	Set ComSpecimenDesc=$p(LabExp2,"|",5)
	Quit:(TestCode="")||(ComCode="") return
	Set PatientID=$p($g(^PAADM(%EpisodeID)),"^",1)
	
	Set xOrdID=$o(^OEORD(0,"Adm",+%EpisodeID,""))
	Set xArcimID=""
	For {
	 	Set xArcimID=$o(^OEORDi(0,"ARCIM",+xOrdID,xArcimID))
	 	Quit:xArcimID=""
	 	
	 	Set objArcim=##Class(DHCMed.Base.Arcim).GetObjById(xArcimID)
	 	Continue:'$IsObject(objArcim)
	 	Set ArcimType=objArcim.ARCICOrderType
	 	Continue:ArcimType'="L"
	 	Set ArcimSubCat=objArcim.ARCICDesc
	 	Continue:ArcimSubCat=""
	 	Set ArcimID=xArcimID
	 	Set ArcimDesc=objArcim.ARCIMDesc
 		
	 	Set xOrdDate=0
	 	For {
		 	Set xOrdDate=$o(^OEORDi(0,"ARCIM",+xOrdID,xArcimID,xOrdDate))
		 	Quit:xOrdDate=""
		 	
		 	Set xSubID=0,return=0
		 	For {
			 	Set xSubID=$o(^OEORDi(0,"ARCIM",+xOrdID,xArcimID,xOrdDate,xSubID))
			 	Quit:xSubID=""
			 	
			 	Set OEItemID=xOrdID_"||"_xSubID
			 	Set objOEItem=##class(DHCMed.Base.OrdItem).GetObjById(OEItemID)
			 	Continue:'$IsObject(objOEItem)
			 	Set OEItemStatus=objOEItem.OSTATCode
				Set OSTATDesc=objOEItem.OSTATDesc
			 	Continue:(OSTATDesc'="执行")&&(OSTATDesc'="核实")
			 	Continue:(OEItemStatus="D")||(OEItemStatus="S")  //检查医嘱状态
				
			 	Set TestSetRow=objOEItem.OEORILabEpisodeNo
			 	Set Epis=$p(TestSetRow,"||",1)
			 	Set TS=$p(TestSetRow,"||",2)
			 	Set TSCount=$p(TestSetRow,"||",3)
			 	Continue:(Epis="")||(TS="")||(TSCount="")
			 	
			 	//*****************************************************
			 	//检测“超广谱β-内酰胺酶（ESBLs）细菌”结果
			 	Continue:'$d(^TEPI(Epis,1,TS,TSCount,"DATA",TestCode))
			 	Set tmpResult=$g(^TEPI(Epis,1,TS,TSCount,"DATA",TestCode))
				Set tmpResult=$p(tmpResult,"\",1)
				Set LabResult=##Class(DHCMed.CCService.Lib.LisReport).GetTestCodeResult(Epis,TestCode,tmpResult)
				Set ItemDesc=$p(LabResult,$c(2),2)    //检验项目描述
				Set ItemResult=$p(LabResult,$c(2),3)  //结果
				Continue:##Class(DHCMed.CCService.Lib.LisReport).ComResult(ItemResult,ComCode,ComValue)=0
				Set ItemUnit=$p(LabResult,$c(2),4)    //检验项目的单位
				Set AbnorFlag=$p(LabResult,$c(2),5)   //异常标记
			 	//*****************************************************
			 	
				//update by lyh 2013-2-6 把检验医嘱日期 改成 报告日期
			 	Continue:$p($g(^TEPI(Epis,1,TS,TSCount)),"\",31)'="A"
				Set SubmissionDate=$p($g(^TEPI(Epis,1,TS,TSCount)),"\",69)
				Set SubmissionTime=$p($g(^TEPI(Epis,1,TS,TSCount)),"\",70)
				If SubmissionDate="" {
					//Set SubmissionDate=$p($g(^TEPI(Epis,1,TS,TSCount)),"\",1)
					//Set SubmissionTime=$p($g(^TEPI(Epis,1,TS,TSCount)),"\",2)
					Set SubmissionDate=$p($g(^TEPI(Epis,1,TS,TSCount)),"\",4)
					Set SubmissionTime=$p($g(^TEPI(Epis,1,TS,TSCount)),"\",5)
				}
				Continue:SubmissionDate=""
				Continue:(%FromDate'="")&&(SubmissionDate<%FromDate)
				Continue:(%ToDate'="")&&(SubmissionDate>%ToDate)
				
				//add by zf 2014-01-24 发生日期和发生时间
				Set OccurDate=$p($g(^OEORD(xOrdID,"I",xSubID,1)),"^",9)  //医嘱开始日期
				Set OccurTime=$p($g(^OEORD(xOrdID,"I",xSubID,1)),"^",10) //医嘱开始时间
				
				Set SenResult="",xPyResult=""
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
					
					Set xPyResult=xPyResult_","_tmpResult
					
					//ESBLs细菌检测
					Set ESBLsPYFlg=##class(DHCMed.NINFService.Dic.MRBSrv).CheckIsESBLs(Result,aCateCode)
					Continue:ESBLsPYFlg=0
					Set SenResult=SenResult_","_tmpResult
				}
				Continue:SenResult=""
				Set SenResult=$e(SenResult,2,$l(SenResult))
				Set UserName=$p($g(^TTAB("DR",$p($g(^TEPI(Epis)),"\",13))),"\",1) //医师信息
				Set:UserName'="" SenResult=SenResult_"("_UserName_")"
				Set:xPyResult'="" xPyResult=$e(xPyResult,2,$l(xPyResult))
				
				Set Count=Count+1
				
				Set TempData=""
				Set $p(TempData,$c(3),1)=ArcimDesc_"("_"产超广谱β-内酰胺酶（ESBLs）细菌  "_SenResult_")"
				Set $p(TempData,$c(3),2)=+SubmissionDate
				Set $p(TempData,$c(3),3)=+SubmissionTime
				Set $p(TempData,$c(3),4)=xPyResult
				Set $p(TempData,$c(3),5)=OEItemID
				Set $p(TempData,$c(3),6)=""
				
				//update by lyh 2012-11-28 拼凑检验表达式
				Set $p(TempData,$c(3),7)="PatientBanner=1&PatientID="_PatientID_"&TestSetRow="_TestSetRow_"&OrderID="_OEItemID
				
				Set $p(TempData,$c(3),8)=OccurDate
				Set $p(TempData,$c(3),9)=OccurTime
				
				Set %ExtraData=%ExtraData_$lb(TempData)
			}
		}
	}
	
	Set return=Count
	Quit return
}

}
