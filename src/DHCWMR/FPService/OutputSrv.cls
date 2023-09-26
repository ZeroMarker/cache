/// 名称: DHCWMR.FPService.OutputSrv
/// 描述: 病案编目接口服务
/// 编写者：zhufei
/// 编写日期: 2014-12-08
Class DHCWMR.FPService.OutputSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2017-02-21
/// Description:  取病案编目病人信息
/// Table：       DHCWMR.FP.FrontPage
/// Input：       EpisodeID:就诊号
/// Return：      返回流数据
/// w ##class(DHCWMR.FPService.OutputSrv).GetFrontPagePatInfo(93,"F")
ClassMethod GetFrontPagePatInfo(aEpisodeID As %String, aFPCode As %String = "F") As %GlobalCharacterStream
{
	New (aEpisodeID,aFPCode)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set objVol=##Class(DHCWMR.SS.Volume).GetObjByPaadm(aEpisodeID)
	Quit:'$IsObject(objVol) return
	Set VolumeID=objVol.%Id()
	
	Set objFrontPage=##class(DHCWMR.FP.FrontPage).GetObjByVolId(VolumeID,aFPCode)
	Quit:'$IsObject(objFrontPage) return
	Quit:objFrontPage.FPIsFinish'=1 return //未完成
	Set FrontPageID=objFrontPage.%Id()
	
	Set xCode=""
	For {
		Set xCode=$o(^DHCWMR.FP.FrontPageI("FPA","IndexParCode",FrontPageID,xCode))
		Quit:xCode=""
		
		Set xID=0
		For {
			Set xID=$o(^DHCWMR.FP.FrontPageI("FPA","IndexParCode",FrontPageID,xCode,xID))
			Quit:xID=""
			
			Set obj=##class(DHCWMR.FP.FPAdmitInfo).GetObjById(FrontPageID_"||"_xID)
			Continue:'$IsObject(obj)
			Set AIInfo=obj.AICode_$c(2)_obj.AIValue
			If return="" {
				Set return=AIInfo
			} Else {
				Set return=return_$c(1)_AIInfo
			}
		}
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-08
/// Description:  取病案编目(诊断、手术)接口方法
/// Table：       DHCWMR.FP.FrontPage
/// Input：       EpisodeID:就诊号
///               GetType:类型
///               -------:诊断(D/1:主要诊断、D/2:次要诊断、D/3:医院感染诊断、D/4:病理诊断、D/5:损伤中毒的外部因素、D/6:门急诊诊断、D/7:入院诊断、D/8:肿瘤编码)
///               -------:手术(O/1:手术、O/2:操作)
///               RowIndex:顺序号
///               FPCode:编目代码(主要是处理多次编目情况,指向工作流项目系统操作代码)
/// Return：      返回String
///               -------:诊断(ICD10 $c(2) 诊断描述 $c(2) 出院情况)
///               -------:手术(ICD10_$c(2)_手术名称)_$c(2)_手术操作日期_$c(2)_切口编号_$c(2)_切口_$c(2)_愈合编目_$c(2)_愈合_$c(2)_手术医生编号_$c(2)_手术医师_$c(2)_麻醉方式编号_$c(2)_麻醉方式_$c(2)_是否附加手术_$c(2)_1助编号_$c(2)_1助姓名_$c(2)_2助编号_$c(2)_2助姓名_$c(2)_麻醉医生编号_$c(2)_麻醉医生_$c(2)_手术级别编码_$c(2)_手术级别)
/// w ##class(DHCWMR.FPService.OutputSrv).GetFrontPageICD(5920325,"D/1",1)
ClassMethod GetFrontPageICD(aEpisodeID As %String, aGetType As %String, aRowIndex As %String = "1", aFPCode As %String = "F") As %String
{
	New (aEpisodeID,aGetType,aRowIndex,aFPCode)
	Set return=""
	Quit:(aEpisodeID="")||(aGetType="")||(aFPCode="") return
	
	Set ICDType=$p(aGetType,"/",1)
	Set ICDSubType=$p(aGetType,"/",2)
	Quit:(ICDType'="D")&&(ICDType'="O") return
	Quit:ICDSubType="" return
	
	Set aRowIndex=+aRowIndex
	Set:aRowIndex<1 aRowIndex=1
	
	Set objVol=##Class(DHCWMR.SS.Volume).GetObjByPaadm(aEpisodeID)
	Quit:'$IsObject(objVol) return
	Set VolumeID=objVol.%Id()
	
	Set objFrontPage=##class(DHCWMR.FP.FrontPage).GetObjByVolId(VolumeID,aFPCode)
	Quit:'$IsObject(objFrontPage) return
	Quit:objFrontPage.FPIsFinish'=1 return //未完成
	Set FrontPageID=objFrontPage.%Id()
	
	Set RowIndex=1
	If ICDType="D" {  //诊断
		Set xTypeID=0
		For {
			Set xTypeID=$o(^DHCWMR.FP.FrontPageI("FPD","IndexTypeIndex",FrontPageID,xTypeID))
			Quit:xTypeID=""
			Quit:RowIndex>aRowIndex
			
			Set objType=##class(DHCWMR.SS.Dictionary).GetObjById(xTypeID)
			Continue:'$IsObject(objType)
			Continue:objType.SDCode'=ICDSubType
			
			Set xIndex=""
			For {
				Set xIndex=$o(^DHCWMR.FP.FrontPageI("FPD","IndexTypeIndex",FrontPageID,xTypeID,xIndex))
				Quit:xIndex=""
				Quit:RowIndex>aRowIndex
				
				Set xSubID=0
				For {
					Set xSubID=$o(^DHCWMR.FP.FrontPageI("FPD","IndexTypeIndex",FrontPageID,xTypeID,xIndex,xSubID))
					Quit:xSubID=""
					Quit:RowIndex>aRowIndex
					
					If RowIndex=aRowIndex {
						Set tmpStr=..GetDiagnosStr(FrontPageID_"||"_xSubID)
						Continue:tmpStr=""
						Set return=tmpStr_$c(2)_ICDSubType
					}
					Set RowIndex=RowIndex+1
				}
			}
		}
	} Else {  //手术
		Set xTypeID=0
		For {
			Set xTypeID=$o(^DHCWMR.FP.FrontPageI("FPO","IndexTypeIndex",FrontPageID,xTypeID))
			Quit:xTypeID=""
			Quit:RowIndex>aRowIndex
			
			Set objType=##class(DHCWMR.SS.Dictionary).GetObjById(xTypeID)
			Continue:'$IsObject(objType)
			Continue:objType.SDCode'=ICDSubType
			
			Set xIndex=""
			For {
				Set xIndex=$o(^DHCWMR.FP.FrontPageI("FPO","IndexTypeIndex",FrontPageID,xTypeID,xIndex))
				Quit:xIndex=""
				Quit:RowIndex>aRowIndex
				
				Set xSubID=0
				For {
					Set xSubID=$o(^DHCWMR.FP.FrontPageI("FPO","IndexTypeIndex",FrontPageID,xTypeID,xIndex,xSubID))
					Quit:xSubID=""
					Quit:RowIndex>aRowIndex
					
					If RowIndex=aRowIndex {
						Set tmpStr=..GetOperationStr(FrontPageID_"||"_xSubID)
						Continue:tmpStr=""
						Set return=return_tmpStr
					}
					Set RowIndex=RowIndex+1
				}
			}
		}
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-08
/// Description:  取病案编目(诊断、手术)接口方法
/// Table：       DHCWMR.FP.FrontPage
/// Input：       EpisodeID:就诊号
///               GetType:类型
///               -------:诊断(D/1:主要诊断、D/2:次要诊断、D/3:医院感染诊断、D/4:病理诊断、D/5:损伤中毒的外部因素、D/6:门急诊诊断、D/7:入院诊断、D/8:肿瘤编码)
///               -------:手术(O/1:手术、O/2:操作)
///               FPCode:编目代码(主要是处理多次编目情况,指向工作流项目系统操作代码)
/// Return：      返回String
///               -------:诊断(ICD10 $c(2) 诊断描述 $c(2) 出院情况)
///               -------:手术(ICD10_$c(2)_手术名称)_$c(2)_手术操作日期_$c(2)_切口编号_$c(2)_切口_$c(2)_愈合编目_$c(2)_愈合_$c(2)_手术医生编号_$c(2)_手术医师_$c(2)_麻醉方式编号_$c(2)_麻醉方式_$c(2)_是否附加手术_$c(2)_1助编号_$c(2)_1助姓名_$c(2)_2助编号_$c(2)_2助姓名_$c(2)_麻醉医生编号_$c(2)_麻醉医生_$c(2)_手术级别编码_$c(2)_手术级别)
/// w ##class(DHCWMR.FPService.OutputSrv).GetFrontPageICDAll(5920325,"D/1")
ClassMethod GetFrontPageICDAll(aEpisodeID As %String, aGetType As %String, aFPCode As %String = "F") As %String
{
	New (aEpisodeID,aGetType,aFPCode)
	Set return=""
	Quit:(aEpisodeID="")||(aGetType="")||(aFPCode="") return
	
	Set ICDType=$p(aGetType,"/",1)
	Set ICDSubType=$p(aGetType,"/",2)
	Quit:(ICDType'="D")&&(ICDType'="O") return
	Quit:(ICDType="O")&((ICDSubType'="1")&(ICDSubType'="2")) return		//update by zhouruimeng 20150408
	
	Set objVol=##Class(DHCWMR.SS.Volume).GetObjByPaadm(aEpisodeID)
	Quit:'$IsObject(objVol) return
	Set VolumeID=objVol.%Id()
	
	Set objFrontPage=##class(DHCWMR.FP.FrontPage).GetObjByVolId(VolumeID,aFPCode)
	Quit:'$IsObject(objFrontPage) return
	Quit:objFrontPage.FPIsFinish'=1 return //未完成
	Set FrontPageID=objFrontPage.%Id()
	
	If ICDType="D" {  //诊断
		Set xTypeID=0
		For {
			Set xTypeID=$o(^DHCWMR.FP.FrontPageI("FPD","IndexTypeIndex",FrontPageID,xTypeID))
			Quit:xTypeID=""
			
			Set objType=##class(DHCWMR.SS.Dictionary).GetObjById(xTypeID)
			Continue:'$IsObject(objType)
			//Continue:objType.SDCode'=ICDSubType
			
			Set xIndex=""
			For {
				Set xIndex=$o(^DHCWMR.FP.FrontPageI("FPD","IndexTypeIndex",FrontPageID,xTypeID,xIndex))
				Quit:xIndex=""
				
				Set xSubID=0
				For {
					Set xSubID=$o(^DHCWMR.FP.FrontPageI("FPD","IndexTypeIndex",FrontPageID,xTypeID,xIndex,xSubID))
					Quit:xSubID=""
					
					Set tmpStr=..GetDiagnosStr(FrontPageID_"||"_xSubID)
					Continue:tmpStr=""
					Set tmpStr=tmpStr_$c(2)_objType.SDCode
					Set:return'="" return=return_$c(1)
					Set return=return_tmpStr
				}
			}
		}
	} Else {  //手术
		Set xTypeID=0
		For {
			Set xTypeID=$o(^DHCWMR.FP.FrontPageI("FPO","IndexTypeIndex",FrontPageID,xTypeID))
			Quit:xTypeID=""
			Set objType=##class(DHCWMR.SS.Dictionary).GetObjById(xTypeID)
			Continue:'$IsObject(objType)
			Continue:objType.SDCode'=ICDSubType
			Set xIndex=""
			For {
				Set xIndex=$o(^DHCWMR.FP.FrontPageI("FPO","IndexTypeIndex",FrontPageID,xTypeID,xIndex))
				Quit:xIndex=""
				Set xSubID=0
				For {
					Set xSubID=$o(^DHCWMR.FP.FrontPageI("FPO","IndexTypeIndex",FrontPageID,xTypeID,xIndex,xSubID))
					Quit:xSubID=""
					Set tmpStr=..GetOperationStr(FrontPageID_"||"_xSubID)
					Continue:tmpStr=""
					Set:return'="" return=return_$c(1)
					Set return=return_tmpStr
				}
			}
		}
	}
	
	Quit return
}

ClassMethod GetDiagnosStr(aFPDiagnosID As %String) As %String
{
	New (aFPDiagnosID)
	Set return=""     //将reutrn改成return
	Quit:aFPDiagnosID="" return
	
	Set obj=##class(DHCWMR.FP.FPDiagnos).GetObjById(aFPDiagnosID)
	Quit:'$IsObject(obj) return
	
	If $IsObject(obj.FPDICDDr){
		Set ICD10=obj.FPDICDDr.IDICD10
		Set ICDDesc=obj.FPDICDDr.IDDesc
	}
	If $IsObject(obj.FPDDischCond){
		Set DischCondCode=obj.FPDDischCond.SDCode
		Set DischCondDesc=obj.FPDDischCond.SDDesc
	}
	If $IsObject(obj.FPDAdmitCond){
		Set AdmitCondCode=obj.FPDAdmitCond.SDCode
		Set AdmitCondDesc=obj.FPDAdmitCond.SDDesc
	}
	If $IsObject(obj.FPDIsDefinite){
		Set IsDefiniteCode=obj.FPDIsDefinite.SDCode
		Set IsDefiniteDesc=obj.FPDIsDefinite.SDDesc
	}
	Set return=$g(ICD10)                        //ICD10
	Set return=return_$c(2)_$g(ICDDesc)         //诊断描述
	Set return=return_$c(2)_$g(DischCondCode)   //出院情况
	Set return=return_$c(2)_$g(DischCondDesc)   //出院情况
	Set return=return_$c(2)_$g(AdmitCondCode)   //入院病情
	Set return=return_$c(2)_$g(AdmitCondDesc)   //入院病情
	Set return=return_$c(2)_$g(IsDefiniteCode)  //怀疑诊断
	Set return=return_$c(2)_$g(IsDefiniteDesc)  //怀疑诊断
	
	Quit return
}

ClassMethod GetOperationStr(aFPOperaID As %String) As %String
{
	New (aFPOperaID)
	Set return=""  //将reutrn改成return
	Quit:aFPOperaID="" return
	
	Set obj=##class(DHCWMR.FP.FPOperation).GetObjById(aFPOperaID)
	Quit:'$IsObject(obj) return
	If $IsObject(obj.FPOICDDr){   //update by niepeng 20150120 FPDICDDr->FPOICDDr
		Set ICD10=obj.FPOICDDr.IDICD10
		Set ICDDesc=obj.FPOICDDr.IDDesc
	}
	Set OperDate=obj.FPOSttDate
	Set:OperDate'="" OperDate=$zd(OperDate,3)
	Set OperatorCode=obj.FPOOperator
	Set OperatorName=obj.FPOOperatorTxt
	Set Ass1Code=obj.FPOAssistant1
	Set Ass1Name=obj.FPOAssistant1Txt
	Set Ass2Code=obj.FPOAssistant2
	Set Ass2Name=obj.FPOAssistant2Txt
	Set NarcDocCode=obj.FPONarcosisDoc
	Set NarcDocDesc=obj.FPONarcosisDocTxt
	If $IsObject(obj.FPONarcosisType){
		Set NarcTypeCode=obj.FPONarcosisType.SDCode
		Set NarcTypeDesc=obj.FPONarcosisType.SDDesc
	}
	If $IsObject(obj.FPOCutType){
		Set CutTypeCode=obj.FPOCutType.SDCode
		Set CutTypeDesc=obj.FPOCutType.SDDesc
	}
	If $IsObject(obj.FPOHealing){
		Set HealingCode=obj.FPOHealing.SDCode
		Set HealingDesc=obj.FPOHealing.SDDesc
	}
	//把切口类型与愈合情况合并
	Set CloseUpCode=$g(CutTypeCode)_"/"_$g(HealingCode)
	Set CloseUpDesc=$g(CutTypeDesc)_"/"_$g(HealingDesc)
	
	If $IsObject(obj.FPOOperLevel){
		Set OperLevelCode=obj.FPOOperLevel.SDCode
		Set OperLevelDesc=obj.FPOOperLevel.SDDesc
	}
	
	
	Set return=$g(ICD10)                        //手术CM3
	Set return=return_$c(2)_$g(ICDDesc)         //手术名称
	Set return=return_$c(2)_$g(OperDate)        //手术日期
	Set return=return_$c(2)_""                  //切口类型代码
	Set return=return_$c(2)_""                  //切口类型
	Set return=return_$c(2)_$g(CloseUpCode)     //愈合情况代码
	Set return=return_$c(2)_$g(CloseUpDesc)     //愈合情况
	Set return=return_$c(2)_$g(OperatorCode)    //术者代码
	Set return=return_$c(2)_$g(OperatorName)    //术者
	If ##class(DHCWMR.IO.FromHisSrv).ALPHAUP(OperatorName)="" {
		Set OperatorCode="", OperatorName=""
	}
	Set return=return_$c(2)_$g(NarcTypeCode)    //麻醉类型代码
	Set return=return_$c(2)_$g(NarcTypeDesc)    //麻醉类型
	Set return=return_$c(2)_""                  //是否附加手术
	Set return=return_$c(2)_$g(Ass1Code)        //1助代码
	Set return=return_$c(2)_$g(Ass1Name)        //1助
	If ##class(DHCWMR.IO.FromHisSrv).ALPHAUP(Ass1Name)="" {
		Set Ass1Code="", Ass1Name=""
	}
	Set return=return_$c(2)_$g(Ass2Code)        //2助代码
	Set return=return_$c(2)_$g(Ass2Name)        //2助
	If ##class(DHCWMR.IO.FromHisSrv).ALPHAUP(Ass2Name)="" {
		Set Ass2Code="", Ass2Name=""
	}
	Set return=return_$c(2)_$g(NarcDocCode)     //麻醉医师代码
	Set return=return_$c(2)_$g(NarcDocDesc)     //麻醉医师
	If ##class(DHCWMR.IO.FromHisSrv).ALPHAUP(NarcDocDesc)="" {
		Set NarcDocCode="", NarcDocDesc=""
	}
	Set return=return_$c(2)_$g(OperLevelCode)   //手术级别代码
	Set return=return_$c(2)_$g(OperLevelDesc)   //手术级别
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-01-09
/// Description:  取病案编码员信息
/// Input：       EpisodeID : 就诊号
/// Return：      返回String
/// w ##class(DHCWMR.FPService.OutputSrv).GetCodingUser(5920325)
ClassMethod GetCodingUser(aEpisodeID As %String, aFPCode As %String = "F") As %String
{
	New (aEpisodeID,aFPCode)
	Set return=""
	Quit:(aEpisodeID="")||(aFPCode="") return
	
	Set objVol=##Class(DHCWMR.SS.Volume).GetObjByPaadm(aEpisodeID)
	Quit:'$IsObject(objVol) return
	Set VolumeID=objVol.%Id()
	
	Set objFrontPage=##class(DHCWMR.FP.FrontPage).GetObjByVolId(VolumeID,aFPCode)
	Quit:'$IsObject(objFrontPage) return
	Quit:objFrontPage.FPIsFinish'=1 return //未完成
	Set FrontPageID=objFrontPage.%Id()
	Set CodingUserID=objFrontPage.FPUpdateUser
	Set CodingUserCode=$p($g(^SSU("SSUSR",CodingUserID)),"^",1)
	Set CodingUserDesc=$p($g(^SSU("SSUSR",CodingUserID)),"^",2)
	Quit:CodingUserDesc="" return
	Set return=CodingUserID_$c(1)_CodingUserCode_$c(1)_CodingUserDesc
	Quit return
}

}
