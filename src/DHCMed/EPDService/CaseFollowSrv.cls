/// 名称: DHCMed.EPDService.CaseFollowSrv
/// 描述: 导出HIV个案随访表到Excel
/// 编写者：jiangpengpeng
/// 编写日期: 2015-08-12
Class DHCMed.EPDService.CaseFollowSrv Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2015-08-12
/// Description:  打印HIV个案随访表
/// Table：       DHCMed.EPD.CaseFollow
/// Input：       
/// Return：      
/// w ##class(DHCMed.EPDService.CaseFollowSrv).ExportHIVCaseRep("fillxlSheet","2")
ClassMethod ExportHIVCaseRep(itmjs As %String, strArguments As %String) As %String
{
	New (itmjs,strArguments)
	Set Count=0
	
	Set RepID=+$p(strArguments,"^",1)
	Set obj=##class(DHCMed.EPD.CaseFollow).GetObjById(RepID)
	Quit:'$IsObject(obj) Count
	
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(obj.FollowNo,"O","JS")_"',"_3_",5);"
	&javascript<#(retval)#>
	
	If (obj.FollowStatus.Description="随访") {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("随访","O","JS")_"',"_4_",5);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(obj.FollowTimes,"O","JS")_"',"_4_",9);"
		&javascript<#(retval)#>
		If (obj.IsCustody.Description="是") {
			Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("是","O","JS")_"',"_4_",16);"
			&javascript<#(retval)#>
		} Else {
			Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("否)","O","JS")_"',"_4_",18);"
			&javascript<#(retval)#>
		}
	} ElseIf (obj.FollowStatus.Description="失访") {
		s retval=itmjs_"(xlSheet,'☑"_$ZCVT("失访","O","JS")_"',"_5_",5);"
		&javascript<#(retval)#>
		If (obj.Reasons.Description="外出") {
			Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("外出","O","JS")_"',"_5_",11);"
			&javascript<#(retval)#>
		} ElseIf (obj.Reasons.Description="决绝随访") {
			Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("决绝随访","O","JS")_"',"_5_",14);"
			&javascript<#(retval)#>
		} ElseIf (obj.Reasons.Description="羁押") {
			Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("羁押","O","JS")_"',"_5_",18);"
			&javascript<#(retval)#>
		} Else {
			Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("转入时地址不详.此次随访结束)","O","JS")_"',"_5_",21);"
			&javascript<#(retval)#>
		}
		
	} Else {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("查无此人","O","JS")_"',"_6_",5);"
		&javascript<#(retval)#>
	}
	
	//基本信息DHCMed.Base.Patient
	Set objPat=##class(DHCMed.Base.Patient).GetObjById(obj.PatientID)
	If ($IsObject(objPat)){
		Set PatName=objPat.PatientName
		//Set PatCardID=objPat.PersonalID
		Set PatSex=objPat.Sex
	}
	Set FamilyName=obj.EPDSuper.MEPDFamName
	Set PatCardID=obj.FollowText1
	Set PhoneNo=obj.EPDSuper.MEPDTelPhone
	Set Address=obj.EPDSuper.MEPDAddress
	Set:Address'="" Address=Address_"号"
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(PatName,"O","JS")_"',"_7_",5);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(FamilyName,"O","JS")_"',"_7_",15);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(PatCardID,"O","JS")_"',"_8_",5);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(PhoneNo,"O","JS")_"',"_9_",5);"
	&javascript<#(retval)#>
	If (PatSex="男") {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT(PatSex,"O","JS")_"',"_9_",15);"
		&javascript<#(retval)#>
	} Else {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT(PatSex,"O","JS")_"',"_9_",17);"
		&javascript<#(retval)#>
	}
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(Address,"O","JS")_"',"_10_",8);"
	&javascript<#(retval)#>
	
	//HIV检测
	If (obj.IsHIVTest.Description="是") {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT(obj.IsHIVTest.Description,"O","JS")_"',"_13_",15);"
		&javascript<#(retval)#>
	} Else {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT(obj.IsHIVTest.Description,"O","JS")_"',"_13_",17);"
		&javascript<#(retval)#>
	}
	If (obj.LastHIVTestDate'="") {
		Set fLastHIVTestDate=$zd(obj.LastHIVTestDate,3)
		Set fLastHIVTestDate=$p(fLastHIVTestDate,"-",1)_"年"_$p(fLastHIVTestDate,"-",2)_"月"
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(fLastHIVTestDate,"O","JS")_"',"_14_",11);"
		&javascript<#(retval)#>
	}
	If (obj.NeverHIVTest=1) {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("无HIV阴性检测史","O","JS")_"',"_14_",17);"
		&javascript<#(retval)#>
	}
	If (obj.FirstHIVTestDate'="") {
		Set fFirstHIVTestDate=$zd(obj.FirstHIVTestDate,3)
		Set fFirstHIVTestDate=$p(fFirstHIVTestDate,"-",1)_"年"_$p(fFirstHIVTestDate,"-",2)_"月"
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(fFirstHIVTestDate,"O","JS")_"',"_15_",11);"
		&javascript<#(retval)#>
	}
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(obj.HIVTestTimes,"O","JS")_"',"_16_",18);"
	&javascript<#(retval)#>
	
	//死亡信息
	If (obj.IsDead.Description="是") {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("是","O","JS")_"',"_19_",5);"
		&javascript<#(retval)#>
		Set fDeathDate=$zd(obj.DeathDate,3)
		Set fDeathDate=$p(fDeathDate,"-",1)_"年"_$p(fDeathDate,"-",2)_"月"_$p(fDeathDate,"-",3)_"日"
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(fDeathDate,"O","JS")_"',"_19_",11);"
		&javascript<#(retval)#>
		If (obj.DeathStage.Description="艾滋病病毒感染者") {
			Set retval=itmjs_"(xlSheet,'☑"_$ZCVT(obj.DeathStage.Description,"O","JS")_"',"_20_",7);"
			&javascript<#(retval)#>
		} Else {
			Set retval=itmjs_"(xlSheet,'☑"_$ZCVT(obj.DeathStage.Description,"O","JS")_"',"_20_",13);"
			&javascript<#(retval)#>
		}
		If (obj.DeathPlace.Description="医疗机构"){
			Set retval=itmjs_"(xlSheet,'☑"_$ZCVT(obj.DeathPlace.Description,"O","JS")_"',"_21_",7);"
			&javascript<#(retval)#>
		} ElseIf (obj.DeathPlace.Description="家中或赴医院死亡") {
			Set retval=itmjs_"(xlSheet,'☑"_$ZCVT(obj.DeathPlace.Description,"O","JS")_"',"_21_",11);"
			&javascript<#(retval)#>
		} ElseIf (obj.DeathPlace.Description="外地") {
			Set retval=itmjs_"(xlSheet,'☑"_$ZCVT(obj.DeathPlace.Description,"O","JS")_"',"_21_",17);"
			&javascript<#(retval)#>
		} ElseIf (obj.DeathPlace.Description="不详") {
			Set retval=itmjs_"(xlSheet,'☑"_$ZCVT(obj.DeathPlace.Description,"O","JS")_"',"_21_",20);"
			&javascript<#(retval)#>
		} Else {
			Set retval=itmjs_"(xlSheet,'☑"_$ZCVT(obj.DeathPlace.Description,"O","JS")_"',"_21_",23);"
			&javascript<#(retval)#>
			Set retval=itmjs_"(xlSheet,'"_$ZCVT(obj.DeathOtherPlace,"O","JS")_"',"_21_",27);"
			&javascript<#(retval)#>
		}
		For ind=1:1:obj.DeathReasonSource.Count() {
			Set objDic=obj.DeathReasonSource.GetAt(ind)
			Continue:'$IsObject(objDic)
			Set xDesc=objDic.Description
			Set Position=..GetPosition("DeathReasonSource",xDesc)
			Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("","O","JS")_"',"_$p(Position,"^",1)_","_$p(Position,"^",2)_");"
			&javascript<#(retval)#>
			If (xDesc="其他信息来源") {
				Set retval=itmjs_"(xlSheet,'"_$ZCVT(obj.DeathOtherSource,"O","JS")_"',"_24_",8);"
				&javascript<#(retval)#>
			}
		}
		If (obj.DeathReason.Description="艾滋病相关疾病死亡") {
			Set retval=itmjs_"(xlSheet,'☑"_$ZCVT(obj.DeathReason.Description,"O","JS")_"',"_26_",1);"
			&javascript<#(retval)#>
			For ind=1:1:obj.DeathReasonHIV.Count() {
				Set objDic=obj.DeathReasonHIV.GetAt(ind)
				Continue:'$IsObject(objDic)
				Set xDesc=objDic.Description
				Set Position=..GetPosition("DeathReasonHIV",xDesc)
				Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("","O","JS")_"',"_$p(Position,"^",1)_","_$p(Position,"^",2)_");"
				&javascript<#(retval)#>
			}
		} ElseIf (obj.DeathReason.Description="艾滋病无关死亡") {
			Set retval=itmjs_"(xlSheet,'☑"_$ZCVT(obj.DeathReason.Description,"O","JS")_"',"_38_",1);"
			&javascript<#(retval)#>
			For ind=1:1:obj.DeathReasonOthers.Count() {
				Set objDic=obj.DeathReasonOthers.GetAt(ind)
				Continue:'$IsObject(objDic)
				Set xDesc=objDic.Description
				Set Position=..GetPosition("DeathReasonOthers",xDesc)
				Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("","O","JS")_"',"_$p(Position,"^",1)_","_$p(Position,"^",2)_");"
				&javascript<#(retval)#>
			}
		} ElseIf (obj.DeathReason.Description="艾滋病抗病毒治疗药物毒副反应") {
			Set retval=itmjs_"(xlSheet,'☑"_$ZCVT(obj.DeathReason.Description,"O","JS")_"',"_42_",1);"
			&javascript<#(retval)#>
		} Else {
			Set retval=itmjs_"(xlSheet,'☑"_$ZCVT(obj.DeathReason.Description,"O","JS")_"',"_43_",1);"
			&javascript<#(retval)#>
		}
	} Else {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("否","O","JS")_"',"_19_",18);"
		&javascript<#(retval)#>
	}
	
	//HIV临床表现
	For ind=1:1:obj.HIVManifestation.Count() {
		Set objDic=obj.HIVManifestation.GetAt(ind)
		Continue:'$IsObject(objDic)
		Set xDesc=objDic.Description
		Set Position=..GetPosition("HIVManifestation",xDesc)
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("","O","JS")_"',"_$p(Position,"^",1)_","_$p(Position,"^",2)_");"
		&javascript<#(retval)#>
	}
	
	//随访调查
	If (obj.CourseStage.Description="艾滋病病毒感染者") {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT(obj.CourseStage.Description,"O","JS")_"',"_52_",5);"
		&javascript<#(retval)#>
	} Else {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT(obj.CourseStage.Description,"O","JS")_"',"_52_",12);"
		&javascript<#(retval)#>
		If (obj.HIVDate'="") {
			Set fHIVDate=$zd(obj.HIVDate,3)
			Set fHIVDate=$p(fHIVDate,"-",1)_"年"_$p(fHIVDate,"-",2)_"月"_$p(fHIVDate,"-",3)_"日"
			Set retval=itmjs_"(xlSheet,'"_$ZCVT(fHIVDate,"O","JS")_"',"_52_",22);"
			&javascript<#(retval)#>
		}
	}
	Set xDesc=obj.SpouseSituation.Description
	if (xDesc'=""){
		Set Position=..GetPosition("SpouseSituation",xDesc)
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("","O","JS")_"',"_$p(Position,"^",1)_","_$p(Position,"^",2)_");"
		&javascript<#(retval)#>
	}
	If (obj.SpouseHIV.Description["未查") {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("","O","JS")_"',"_57_","_11_");"
		&javascript<#(retval)#>
	} ElseIf (obj.SpouseHIV.Description="阴性") {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("","O","JS")_"',"_57_","_16_");"
		&javascript<#(retval)#>
	} ElseIf (obj.SpouseHIV.Description="阳性") {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("","O","JS")_"',"_57_","_20_");"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(obj.SpouseCaseNo,"O","JS")_"',"_59_","_18_");"
		&javascript<#(retval)#>
	} Else {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("","O","JS")_"',"_57_","_24_");"
		&javascript<#(retval)#>
	}
	If (obj.SpouseHIVDate'="") {
		Set fSpouseHIVDate=$zd(obj.SpouseHIVDate,3)
		Set fSpouseHIVDate=$p(fSpouseHIVDate,"-",1)_"年"_$p(fSpouseHIVDate,"-",2)_"月"_$p(fSpouseHIVDate,"-",3)_"日"
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(fSpouseHIVDate,"O","JS")_"',"_58_",9);"
		&javascript<#(retval)#>
	}
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(obj.Children,"O","JS")_"',"_60_","_9_");"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(obj.Children1,"O","JS")_"',"_60_","_13_");"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(obj.Children2,"O","JS")_"',"_60_","_16_");"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(obj.Children3,"O","JS")_"',"_60_","_23_");"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(obj.Children4,"O","JS")_"',"_60_","_28_");"
	&javascript<#(retval)#>
	
	If (obj.HIVSurvey1.Description="是") {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("是","O","JS")_"',"_61_","_9_");"
		&javascript<#(retval)#>
	} Else {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("否","O","JS")_"',"_61_","_12_");"
		&javascript<#(retval)#>
	}
	If (obj.HIVSurvey2.Description="是") {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("是","O","JS")_"',"_62_","_15_");"
		&javascript<#(retval)#>
	} ElseIf (obj.HIVSurvey2.Description="否") {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("否","O","JS")_"',"_62_","_17_");"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(obj.HIVSurvey2No,"O","JS")_"',"_63_","_13_");"
		&javascript<#(retval)#>
	} Else {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT(obj.HIVSurvey2.Description,"O","JS")_"',"_61_","_20_");"
		&javascript<#(retval)#>
	}
	If (obj.HIVSurvey3.Description="是") {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("是","O","JS")_"',"_64_","_20_");"
		&javascript<#(retval)#>
	} ElseIf (obj.HIVSurvey3.Description="否") {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("否","O","JS")_"',"_64_","_22_");"
		&javascript<#(retval)#>
	} Else {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("未发生性行为","O","JS")_"',"_64_","_24_");"
		&javascript<#(retval)#>
	}
	If (obj.HIVSurvey4.Description="是") {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("是","O","JS")_"',"_65_","_14_");"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(obj.HIVSurvey4No,"O","JS")_"',"_66_","_13_");"
		&javascript<#(retval)#>
	} ElseIf (obj.HIVSurvey4.Description="否") {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("否","O","JS")_"',"_65_","_16_");"
		&javascript<#(retval)#>
	} Else {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT(obj.HIVSurvey4.Description,"O","JS")_"',"_65_","_18_");"
		&javascript<#(retval)#>
	}
	
	If (obj.HIVSurvey5.Description="是") {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("是","O","JS")_"',"_67_","_12_");"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(obj.HIVSurvey5No,"O","JS")_"',"_68_","_14_");"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(obj.HIVSurvey5No1,"O","JS")_"',"_68_","_19_");"
		&javascript<#(retval)#>
	} ElseIf (obj.HIVSurvey5.Description="否") {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("否","O","JS")_"',"_67_","_14_");"
		&javascript<#(retval)#>
	} Else {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT(obj.HIVSurvey5.Description,"O","JS")_"',"_67_","_16_");"
		&javascript<#(retval)#>
	}
	
	If (obj.HIVSurvey6.Description="是") {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("是","O","JS")_"',"_70_","_2_");"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(obj.HIVSurvey6No,"O","JS")_"',"_70_","_13_");"
		&javascript<#(retval)#>
	} Else {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("否","O","JS")_"',"_70_","_24_");"
		&javascript<#(retval)#>
	}
	If (obj.HIVSurvey7.Description="孕期") {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("孕期","O","JS")_"',"_71_","_9_");"
		&javascript<#(retval)#>
	} ElseIf (obj.HIVSurvey7.Description="产后") {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("产后","O","JS")_"',"_71_","_12_");"
		&javascript<#(retval)#>
	} Else {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT(obj.HIVSurvey7.Description,"O","JS")_"',"_71_","_15_");"
		&javascript<#(retval)#>
	}
	If (obj.IsHIVSurvey7.Description="是") {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("是","O","JS")_"',"_72_","_28_");"
		&javascript<#(retval)#>
	} ElseIf (obj.IsHIVSurvey7.Description="否") {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("否","O","JS")_"',"_72_","_29_");"
		&javascript<#(retval)#>
	} 
	
	If (obj.HIVSurvey8a.Description="是") {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("是","O","JS")_"',"_74_","_13_");"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(obj.HIVSurvey8aNo1,"O","JS")_"',"_74_","_19_");"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(obj.HIVSurvey8aNo2,"O","JS")_"',"_74_","_26_");"
		&javascript<#(retval)#>
	} ElseIf (obj.HIVSurvey8a.Description="否") {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("否","O","JS")_"',"_74_","_28_");"
		&javascript<#(retval)#>
	} 
	If (obj.HIVSurvey8b.Description="是") {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("是","O","JS")_"',"_75_","_13_");"
		&javascript<#(retval)#>
	} ElseIf (obj.HIVSurvey8b.Description="否") {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("否","O","JS")_"',"_75_","_19_");"
		&javascript<#(retval)#>
	} 
	If (obj.HIVSurvey8c.Description="是") {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("是","O","JS")_"',"_76_","_13_");"
		&javascript<#(retval)#>
	} ElseIf (obj.HIVSurvey8c.Description="否") {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("否","O","JS")_"',"_76_","_19_");"
		&javascript<#(retval)#>
	} 
	
	For ind=1:1:obj.HIVSurvey9.Count() {
		Set objDic=obj.HIVSurvey9.GetAt(ind)
		Continue:'$IsObject(objDic)
		Set xDesc=objDic.Description
		Set Position=..GetPosition("HIVSurvey9",xDesc)
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("是","O","JS")_"',"_$p(Position,"^",1)_","_$p(Position,"^",2)_");"
		&javascript<#(retval)#>
		Set Position2=+$p(Position,"^",2)+2
		Set retval=itmjs_"(xlSheet,'□"_$ZCVT("否","O","JS")_"',"_$p(Position,"^",1)_","_Position2_");"
		&javascript<#(retval)#>
	}
	
	If (obj.IsHIVSurvey10.Description="是") {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("是","O","JS")_"',"_82_","_12_");"
		&javascript<#(retval)#>
		Set xDesc=obj.HIVSurvey10.Description
		Set Position=..GetPosition("HIVSurvey10",xDesc)
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT(xDesc,"O","JS")_"',"_$p(Position,"^",1)_","_$p(Position,"^",2)_");"
		&javascript<#(retval)#>
	} ElseIf (obj.IsHIVSurvey10.Description="否") {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("否","O","JS")_"',"_82_","_29_");"
		&javascript<#(retval)#>
	} 
	
	If (obj.IsHIVSurvey11.Description="是") {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("是","O","JS")_"',"_83_","_14_");"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(obj.IsHIVSurvey11No,"O","JS")_"',"_83_","_21_");"
		&javascript<#(retval)#>
	} ElseIf (obj.IsHIVSurvey11.Description="否") {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("否","O","JS")_"',"_83_","_29_");"
		&javascript<#(retval)#>
	} 
	
	//CD4检测
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(obj.CD4TestTimes,"O","JS")_"',"_85_","_11_");"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(obj.CD4TestResult,"O","JS")_"',"_85_","_20_");"
	&javascript<#(retval)#>
	If (obj.CD4TestDate'="") {
		Set fCD4TestDate=$zd(obj.CD4TestDate,3)
		Set fCD4TestDate=$p(fCD4TestDate,"-",1)_"年"_$p(fCD4TestDate,"-",2)_"月"_$p(fCD4TestDate,"-",3)_"日"
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(fCD4TestDate,"O","JS")_"',"_85_","_27_");"
		&javascript<#(retval)#>
	}
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(obj.CD4TestUnit,"O","JS")_"',"_86_","_5_");"
	&javascript<#(retval)#>
	
	//随访信息
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(obj.SurveyOrgan,"O","JS")_"',"_88_","_6_");"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(obj.SurveyName,"O","JS")_"',"_88_","_19_");"
	&javascript<#(retval)#>
	If (obj.SurveyDate'="") {
		Set fSurveyDate=$zd(obj.SurveyDate,3)
		Set fSurveyDate=$p(fSurveyDate,"-",1)_"年"_$p(fSurveyDate,"-",2)_"月"_$p(fSurveyDate,"-",3)_"日"
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(fSurveyDate,"O","JS")_"',"_88_","_27_");"
		&javascript<#(retval)#>
	}
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(obj.Comments,"O","JS")_"',"_90_","_3_");"
	&javascript<#(retval)#>
	
	q Count
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-08-13
/// Description:  取元素在模版上的位置
/// Table：       
/// Input：       字典分类，元素名Desc
/// Return：      X_"^"_Y
/// w ##class(DHCMed.EPDService.CaseFollowSrv).GetPosition("DeathReasonSource","住院记录")
ClassMethod GetPosition(aDicType As %String, aFieldDesc As %String) As %String
{
	New (aDicType,aFieldDesc)
	Set return="0^0"
	Quit:(aDicType="")||(aFieldDesc="") return
	
	Set DRSList=$lb("住院记录","22","10")
	Set DRSList=DRSList_$lb("门诊记录","22","14")
	Set DRSList=DRSList_$lb("尸检报告","22","18")
	Set DRSList=DRSList_$lb("死亡医学证明书","22","22")
	Set DRSList=DRSList_$lb("出院记录","23","2")
	Set DRSList=DRSList_$lb("临床医生","23","8")
	Set DRSList=DRSList_$lb("乡/镇/村卫生院医生","23","14")
	Set DRSList=DRSList_$lb("患者家属或朋友","23","22")
	Set DRSList=DRSList_$lb("其他信息来源","24","2")
	
	Set DRHList=$lb("肺孢子菌肺炎(PCP)","27","2")
	Set DRHList=DRHList_$lb("组织胞浆菌病","28","2")
	Set DRHList=DRHList_$lb("肺外结核病","29","2")
	Set DRHList=DRHList_$lb("弓形虫脑病","30","2")
	Set DRHList=DRHList_$lb("慢性等孢子虫病","31","2")
	Set DRHList=DRHList_$lb("卡波西肉瘤","32","2")
	Set DRHList=DRHList_$lb("侵润性子宫颈癌","33","2")
	Set DRHList=DRHList_$lb("消瘦综合征","34","2")
	Set DRHList=DRHList_$lb("播散性非结核分枝杆菌病(鸟分枝杆菌-堪萨斯分枝杆菌病)","35","2")
	Set DRHList=DRHList_$lb("急性艾滋病感染综合征","36","2")
	Set DRHList=DRHList_$lb("其他艾滋病相关特指疾病和综合征","37","2")
	Set DRHList=DRHList_$lb("扩散性或肺外球孢子菌感染","27","9")
	Set DRHList=DRHList_$lb("结核分枝杆菌感染(肺内)","28","9")
	Set DRHList=DRHList_$lb("反复发生的细菌性肺炎","29","9")
	Set DRHList=DRHList_$lb("非典型播散性利什曼病","30","9")
	Set DRHList=DRHList_$lb("伯基特淋巴瘤","31","9")
	Set DRHList=DRHList_$lb("霍奇金淋巴瘤","32","9")
	Set DRHList=DRHList_$lb("其他艾滋病相关性肿瘤","33","9")
	Set DRHList=DRHList_$lb("进行性多灶性脑白质病","34","9")
	Set DRHList=DRHList_$lb("隐球菌病(隐球菌病脑膜炎、肺外隐球菌病)","27","17")
	Set DRHList=DRHList_$lb("念珠菌感染(食管或肺、气管、支气管)","28","17")
	Set DRHList=DRHList_$lb("巨细胞病毒感染(除肝、脾、淋巴结以外)","29","17")
	Set DRHList=DRHList_$lb("单纯疱疹病毒感染(口唇、生殖器或肛门直肠)","30","17")
	Set DRHList=DRHList_$lb("任何的内脏器官单纯疱疹病毒感染","31","17")
	Set DRHList=DRHList_$lb("淋巴组织间质性肺炎(多见于儿童)","32","17")
	Set DRHList=DRHList_$lb("反复发生的非伤寒沙门菌败血症","33","17")
	Set DRHList=DRHList_$lb("慢性隐孢子虫病(肠道，伴腹泻持续>1个月)","34","17")
	Set DRHList=DRHList_$lb("其他非霍奇金淋巴瘤(脑或B细胞)","35","17")
	Set DRHList=DRHList_$lb("多发性恶性肿瘤(转移性肿瘤，淋巴瘤无法诊断)","36","17")
	Set DRHList=DRHList_$lb("HIV脑病(艾滋病相关性脑病或痴呆综合征ADC)","37","17")
	
	Set DROList=$lb("心脑血管疾病","39","2")
	Set DROList=DROList_$lb("恶性肿瘤","39","10")
	Set DROList=DROList_$lb("呼吸系统疾病","39","15")
	Set DROList=DROList_$lb("内分泌营养代谢疾病","39","22")
	Set DROList=DROList_$lb("丙型或乙型肝炎","40","2")
	Set DROList=DROList_$lb("其他消化系统疾病","40","10")
	Set DROList=DROList_$lb("其他艾滋病无关疾病死亡","40","22")
	Set DROList=DROList_$lb("自杀","40","15")
	Set DROList=DROList_$lb("吸毒过量","41","2")
	Set DROList=DROList_$lb("药物毒副反应","41","10")
	Set DROList=DROList_$lb("其他非疾病外因死亡(损伤等)","41","15")
	
	Set HMFList=$lb("无不适临床表现","46","2")
	Set HMFList=HMFList_$lb("原因不明发热持续1个月及以上","46","10")
	Set HMFList=HMFList_$lb("原因不明腹泻持续1个月及以上","46","17")
	Set HMFList=HMFList_$lb("最近3个月内体重下降10%以上","47","19")
	Set HMFList=HMFList_$lb("成人鹅口疮","47","2")
	Set HMFList=HMFList_$lb("反复发作的单纯疱疹","47","17")
	Set HMFList=HMFList_$lb("半年内活动性肺结核或/和肺外结核","48","17")
	Set HMFList=HMFList_$lb("咳嗽、咳痰持续1个月及以上","48","10")
	Set HMFList=HMFList_$lb("其他艾滋病相关性疾病","48","2")
	
	Set HS9List=$lb("咳嗽、咳痰持续2周以上","78","11")
	Set HS9List=HS9List_$lb("反复咳出的痰中带血","78","24")
	Set HS9List=HS9List_$lb("反复发热持续2周以上","79","11")
	Set HS9List=HS9List_$lb("夜间经常出汗","79","24")
	Set HS9List=HS9List_$lb("无法解释的体重明显下降","80","11")
	Set HS9List=HS9List_$lb("经常容易疲劳或呼吸短促","80","24")
	Set HS9List=HS9List_$lb("淋巴结肿大","81","11")
	
	Set SPSList=$lb("既往有配偶/固定性伴，现无配偶/固定性伴","54","2")
	Set SPSList=SPSList_$lb("仍无配偶/固定性伴","54","17")
	Set SPSList=SPSList_$lb("既往有配偶/固定性伴且配偶/固定性伴未变更","55","2")
	Set SPSList=SPSList_$lb("既往有配偶/固定性伴但配偶/固定性伴已变更","55","17")
	Set SPSList=SPSList_$lb("既往无配偶/固定性伴，现有配偶/固定性伴","56","2")
	
	Set HS10List=$lb("肺结核","82","14")
	Set HS10List=HS10List_$lb("肺外结核","82","17")
	Set HS10List=HS10List_$lb("未患结核","82","21")
	Set HS10List=HS10List_$lb("结果不清楚","82","25")
	
	If (aDicType="DeathReasonSource") {
		Set ind=$ListFind(DRSList,aFieldDesc)
		Quit:ind<1 return
		Set return=$List(DRSList,ind+1)_"^"_$List(DRSList,ind+2)
	}ElseIf(aDicType="DeathReasonHIV") {
		Set ind=$ListFind(DRHList,aFieldDesc)
		Quit:ind<1 return
		Set return=$List(DRHList,ind+1)_"^"_$List(DRHList,ind+2)
	}ElseIf(aDicType="DeathReasonOthers") {
		Set ind=$ListFind(DROList,aFieldDesc)
		Quit:ind<1 return
		Set return=$List(DROList,ind+1)_"^"_$List(DROList,ind+2)
	}ElseIf(aDicType="HIVManifestation") {
		Set ind=$ListFind(HMFList,aFieldDesc)
		Quit:ind<1 return
		Set return=$List(HMFList,ind+1)_"^"_$List(HMFList,ind+2)
	}ElseIf(aDicType="HIVSurvey9") {
		Set ind=$ListFind(HS9List,aFieldDesc)
		Quit:ind<1 return
		Set return=$List(HS9List,ind+1)_"^"_$List(HS9List,ind+2)
	}ElseIf(aDicType="SpouseSituation") {
		Set ind=$ListFind(SPSList,aFieldDesc)
		Quit:ind<1 return
		Set return=$List(SPSList,ind+1)_"^"_$List(SPSList,ind+2)
	}ElseIf(aDicType="HIVSurvey10") {
		Set ind=$ListFind(HS10List,aFieldDesc)
		Quit:ind<1 return
		Set return=$List(HS10List,ind+1)_"^"_$List(HS10List,ind+2)
	}
	
	
	Quit return
}

/// 获取Http服务器信息
/// Trakcare的服务器，不是Medtrak的
/// 	w ##Class(DHCMed.EPDService.Service).GetServerInfo()
ClassMethod GetServerInfo()
{
	n
    Set CurrentNS=$ZNSPACE
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    //Set Server=Config.WebServer
    Set Server=$p(Config.LayoutManager,":",2)
    Set Path=Config.PathToReports
    Set LayOutManager=Config.LayoutManager
    Set WebServerAppURL = "http://"_Config.WebServer_Config.PathToApp //Modified By LiYang 2008-10-08 获取CSP服务器的IP地址以及程序路径
   // Set WebServerAppURL = "http://127.0.0.1"_Config.PathToApp //Modified By LiYang 2008-10-08 获取CSP服务器的IP地址以及程序路径
    d Config.%Close()
    s s=CurrentNS_$c(1)_MEDDATA_$c(1)_LABDATA_$c(1)_Server_$c(1)_Path_$c(1)_LayOutManager_$C(1)_WebServerAppURL
	q s
}

/// Creator：     yukai
/// CreatDate：   2019-06-03
/// Description:  根据随访日期查询HIV随访单
/// Table：       DHCMed.EPD.CaseFollow
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.EPDService.CaseFollowSrv","QryHIVRepByDate","2019-07-19","2019-07-19","")
Query QryHIVRepByDate(aFromDate As %String, aToDate As %String, aFollowStatus As %String, aHosp As %String) As %Query(ROWSPEC = "ind:%String,ReportID:%String,PatientID:%String,FollowStaDesc:%String,FollowTimes:%String,IsDead:%String,SurveyOrgan:%String,SurveyName:%String,SurveyDate:%String,Comments:%String,EpisodeID:%String,PatientName:%String,PatientSex:%String,Birthday:%String")
{
}

ClassMethod QryHIVRepByDateExecute(ByRef qHandle As %Binary, aFromDate As %String, aToDate As %String, aFollowStatus As %String, aHosp As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aFromDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aToDate)
	Quit:(aFromDate="")||(aToDate="") $$$OK
	

	For xDate=aFromDate:1:aToDate {
		Set xRepID=""
		For {
			Set xRepID=$o(^DHCMed.EPD.CaseFollowI("HIVSurveyDateIndex"," "_xDate,xRepID))
			Quit:xRepID=""
			Set objHIVRep=##class(DHCMed.EPD.CaseFollow).GetObjById(xRepID)
			Continue:'$IsObject(objHIVRep)
			
			
			Set aLoc = objHIVRep.EPDSuper.MEPDLocDR
			if (aHosp'=""){
				set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(aLoc,aHosp)
				continue:flg<1
			}
			Set (PatientID,FollowStatus,FollowTimes,IsDead,SurveyOrgan,SurveyName,SurveyDate,Comments)=""
			Set (EpisodeID,PatientName,PatientSex,Birthday)=""
			
			Set PatientID=objHIVRep.PatientID
			Set FollowStaDesc=objHIVRep.FollowStatus.Description
			Set FollowStatus=objHIVRep.FollowStatus.%Id()
			continue:(aFollowStatus'="")&&(aFollowStatus'[FollowStatus)
			Set FollowTimes=objHIVRep.FollowTimes
			Set SurveyOrgan=objHIVRep.SurveyOrgan
			Set SurveyName=objHIVRep.SurveyName
			Set SurveyDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(objHIVRep.SurveyDate)
			Set IsDead=objHIVRep.IsDead.Description
			Set Comments=objHIVRep.Comments
			Set EpisodeID=objHIVRep.EpisodeID
			Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
			Set PatientName=objPatient.PatientName      //姓名
			Set PatientSex=objPatient.Sex               //性别
			Set Birthday=objPatient.Birthday
			
			
			Set Data=$lb(ind,xRepID,PatientID,FollowStaDesc,FollowTimes,IsDead,SurveyOrgan,SurveyName,SurveyDate,Comments)
			Set Data=Data_$lb(EpisodeID,PatientName,PatientSex,Birthday)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryHIVRepByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryILIRepByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHIVRepByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryILIRepByDateExecute ]
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
