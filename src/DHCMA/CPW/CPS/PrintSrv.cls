/// 名称: DHCMA.CPW.CPS.PrintSrv
/// 描述: 临床路径打印相关服务
/// 编写者：jiangpengpeng
/// 编写日期: 2019-3-6
Class DHCMA.CPW.CPS.PrintSrv Extends %RegisteredObject [ Abstract, ClassType = "", Not ProcedureBlock ]
{

/// 获取Http服务器信息的模板存放地址
/// Trakcare的服务器，不是Medtrak的
/// w ##Class(DHCMA.CPW.CPS.PrintSrv).GetTemplatePath()
ClassMethod GetTemplatePath()
{
	n
    // Set CurrentNS=$ZNSPACE  获取名字空间
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set Path=Config.PathToReports
    d Config.%Close()
	q Path
}

/// 打印临床路径患者通知单
/// w ##Class(DHCMA.CPW.CPS.PrintSrv).PrintCPWInformedConsert("xlheet","97!!1")
ClassMethod PrintCPWInformedConsert(aItmjs As %String, aEpisodeID As %String, aLocID As %String, aHospID As %String) As %String
{
	New (aItmjs,aEpisodeID,aLocID,aHospID)
	set objPat=##class(DHCMA.Util.EP.Episode).GetObjByOID(aEpisodeID)
	Quit:'$IsObject(objPat)
	Set PatName=objPat.PAPatName
	Set PatSex=objPat.PASex
	Set PatSex=$Case(PatSex,"F":"女","M":"男",:"")
	Set PatAge=objPat.PAAge
	Set MrNo=objPat.PAMrNo
	Set LocDesc=""
	Set objLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(aLocID)
	Set:$IsObject(objLoc) LocDesc=objLoc.BTDesc
	Set HospDesc=""
	Set objHosp=##class(DHCMA.Util.EP.Hospital).GetObjByOID(aHospID)
	Set:$IsObject(objLoc) HospDesc=objHosp.BTDesc
	Set retval=aItmjs_"(xlSheet,'"_$ZCVT(PatName,"O","JS")_"',5,5);"
	&javascript<#(retval)#>
	Set retval=aItmjs_"(xlSheet,'"_$ZCVT(PatSex,"O","JS")_"',5,19);"
	&javascript<#(retval)#>
	Set retval=aItmjs_"(xlSheet,'"_$ZCVT(PatAge,"O","JS")_"',5,25);"
	&javascript<#(retval)#>
	Set retval=aItmjs_"(xlSheet,'"_$ZCVT(LocDesc,"O","JS")_"',7,5);"
	&javascript<#(retval)#>
	Set retval=aItmjs_"(xlSheet,'"_$ZCVT(MrNo,"O","JS")_"',7,25);"
	&javascript<#(retval)#>
	Set retval=aItmjs_"(xlSheet,'"_$ZCVT(HospDesc,"O","JS")_"',42,21);"
	&javascript<#(retval)#>
	Set Date=$zd(+$H,3)
	Set Year=$p(Date,"-",1)
	Set retval=aItmjs_"(xlSheet,'"_$ZCVT(Year,"O","JS")_"',44,21);"
	&javascript<#(retval)#>
	q "1"
}

/// Creator：     jiangpengpeng
/// CreatDate：   2019-3-7
/// Description:  打印表单执行信息
/// Table：       DHCMA.CPW.CP.Pathway
/// Input：       
///               
/// Return：      返回ROWSPEC
/// w ##Class(DHCMA.CPW.CPS.PrintSrv).PrintCPWImpl("xlheet","97!!1")
ClassMethod PrintCPWImpl(aItmjs As %String, aEpisodeID As %String) As %String
{
	New (aItmjs,aEpisodeID)
	Quit:aEpisodeID="" ""
	
	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
	If (aEpisodeID'["!!") {
		Set aEpisodeID=aEpisodeID_"!!"_SYSDr
	}
	Set LocID=$p($g(^PAADM($p(aEpisodeID,"!!",1))),"^",4)  //就诊科室
 	Set HospID=$p($g(^CTLOC(LocID)),"^",22)
 	Set AdmHospID=HospID_"!!"_SYSDr
 	// 检查配置是否显示合并症执行的项目
 	Set IsShowComplItem=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWIsShowComplItem",AdmHospID)
	
	Set PathwayID=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",aEpisodeID,""),-1)	//取最新一条记录
	Quit:PathwayID="" return
	
	Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(PathwayID)
	Quit:'$IsObject(objPathway) return
	
	set objPat=##class(DHCMA.Util.EP.Episode).GetObjByOID(aEpisodeID)
	Quit:'$IsObject(objPat) return
	
	Set CPWDesc=objPathway.CPFormDr.FormPathDr.BTDesc_"临床路径表单"	//路径名称
	Set CPWAdmit="入径标准："
	Set AdmitStr=..GetCPWAdmit(objPathway.CPFormDr.FormPathDr.%Id())
	Set CPWAdmit=CPWAdmit_AdmitStr
	Set FormDays=objPathway.CPFormDr.FormDays_"天"	//标准住院日
	
	Set MrNo=objPat.PAMrNo
	Set PatName=objPat.PAPatName
	Set PatSex=objPat.PASex
	Set PatSex=$Case(PatSex,"F":"女","M":"男",:"")
	Set PatAge=objPat.PAAge
	Set AdmDate=objPat.PAAdmDate
	Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
	Set DischDate=objPat.PADischDate
	Set:DischDate'="" DischDate=$zd(DischDate,3)
	Set:DischDate="" DischDate="     "
	Set PatInfo="患者姓名："_PatName_"   性别："_PatSex_"   年龄："_PatAge_"   住院号："_MrNo
	Set DaysInfo="入院日期："_AdmDate_"   出院日期："_DischDate_"   标准住院日："_FormDays
	
	/*路径信息、患者信息*/
	Set retval=aItmjs_"(xlSheet,'"_$ZCVT(CPWDesc,"O","JS")_"',1,1);"
	&javascript<#(retval)#>
	Set retval=aItmjs_"(xlSheet,'"_$ZCVT(CPWAdmit,"O","JS")_"',2,1);"
	&javascript<#(retval)#>
	Set retval=aItmjs_"(xlSheet,'"_$ZCVT(PatInfo,"O","JS")_"',3,1);"
	&javascript<#(retval)#>
	Set retval=aItmjs_"(xlSheet,'"_$ZCVT(DaysInfo,"O","JS")_"',4,1);"
	&javascript<#(retval)#>
	
	Set NIndex="PrintCPWImpl"
    Kill ^TMP($zn,$j,NIndex)
	Set IsExec=0
    Set PreBTFormID=""
	Set xEpisID=""
	For {
		Set xEpisID=$o(^DHCMA.CPW.CP.PathwayD(PathwayID,"EPIS",xEpisID))
		Quit:xEpisID=""
			
		Set objEpis=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(PathwayID_"||"_xEpisID)
		Continue:'$IsObject(objEpis)
		
		Set IsActive=objEpis.CPIsActive
		Continue:'IsActive
		
		Set IndNo=objEpis.CPIndNo
		Set BTFormEpID=objEpis.CPFormEpDr.%Id()
		Set BTFormID=$p(BTFormEpID,"||",1)
		If (PreBTFormID'=BTFormID) {
			Set IsExec=IsExec+1
			Set PreBTFormID=BTFormID
		}
		Set ^TMP($zn,$j,NIndex,IsExec,IndNo,xEpisID)=""
	}
	
	
	/*各阶段项目、变异、签名*/
	Set start=4			//从第5行开始
	Set indEpis=0		//记录阶段名称行数
	Set rowItem=0		//记录项目行数
	Set rowSign=0		//签名行数
	
	Set xIsExec=""
	For {
		Set xIsExec=$o(^TMP($zn,$j,NIndex,xIsExec))
		Quit:xIsExec=""
		
		Set xIndNo=""
		For {
			Set xIndNo=$o(^TMP($zn,$j,NIndex,xIsExec,xIndNo))
			Quit:xIndNo=""
			
			Set xEpisID=""
			For {
				Set xEpisID=$o(^TMP($zn,$j,NIndex,xIsExec,xIndNo,xEpisID))
				Quit:xEpisID=""
		
				Set objEpis=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(PathwayID_"||"_xEpisID)
				Continue:'$IsObject(objEpis)
				
				Set IsActive=objEpis.CPIsActive
				Continue:'IsActive
				Set EpisDesc=objEpis.CPFormEpDr.EpDesc	//阶段描述
				
				Set rowEpis=start+indEpis+rowItem+rowSign+1
				Set retval="MergCells(xlSheet,"_rowEpis_",1,"_rowEpis_",4);"	//合并
				&javascript<#(retval)#>
				Set retval="HorizontCells(xlSheet,"_rowEpis_",1,"_rowEpis_",4,-4108);"	//居中
				&javascript<#(retval)#>
				Set retval=aItmjs_"(xlSheet,'"_$ZCVT(EpisDesc,"O","JS")_"',"_rowEpis_",1);"
				&javascript<#(retval)#>
				Set indEpis=indEpis+1
				
				Set row=rowEpis+1
				Set retval=aItmjs_"(xlSheet,'"_$ZCVT("主要诊疗工作","O","JS")_"',"_row_",1);"
				&javascript<#(retval)#>
				Set retval="HorizontCells(xlSheet,"_row_",1,"_row_",1,-4108);"	//居中
				&javascript<#(retval)#>
				Set retval=aItmjs_"(xlSheet,'"_$ZCVT("重点医嘱","O","JS")_"',"_row_",2);"
				&javascript<#(retval)#>
				Set retval="HorizontCells(xlSheet,"_row_",2,"_row_",2,-4108);"	//居中
				&javascript<#(retval)#>
				Set retval=aItmjs_"(xlSheet,'"_$ZCVT("主要护理工作","O","JS")_"',"_row_",3);"
				&javascript<#(retval)#>
				Set retval="HorizontCells(xlSheet,"_row_",3,"_row_",3,-4108);"	//居中
				&javascript<#(retval)#>
				Set retval=aItmjs_"(xlSheet,'"_$ZCVT("变异信息","O","JS")_"',"_row_",4);"
				&javascript<#(retval)#>
				Set retval="HorizontCells(xlSheet,"_row_",4,"_row_",4,-4108);"	//居中
				&javascript<#(retval)#>
				
				
				Set SignStr=##class(DHCMA.CPW.CPS.ImplementSrv).GetStepSign(PathwayID_"||"_xEpisID)
				Set SignDoc=$p(SignStr,"^",1)
				Set SignNur=$p(SignStr,"^",2)
				Set:SignDoc="" SignDoc="   "
				Set:SignNur="" SignNur="   "
				Set SignInfo="医生签名："_SignDoc_"   护士签名:"_SignNur
				
				//项目执行信息
				Set (indZL,indYZ,indHL)=0
				Set xImplID=""
				For {
					Set xImplID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParRef",PathwayID,PathwayID_"||"_xEpisID,xImplID))
					Quit:xImplID=""
					
					Set objImpl=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(PathwayID_"||"_xImplID)
		 			Continue:'$IsObject(objImpl)
			 		Set IsActive=objImpl.CPIsActive
			 		Continue:'IsActive
			 		Continue:('+IsShowComplItem)&&(objImpl.CPPathwayComplDr'="")	//不显示时过滤合并症执行的项目
			 		
					Set ItemZL="",ItemYZ="",ItemHL=""
			 		Set TypeDesc=objImpl.CPFormItemDr.ItemCatDr.BTTypeDr.BTDesc		//项目类型描述
			 		Set:objImpl.CPPathwayComplDr'="" ItemDesc="【合】"_ItemDesc
			 		Set IsImp=objImpl.CPIsImp		//是否执行
			 		Set Imp=" □"
			 		Set:IsImp Imp=" ☑"
			 		If (TypeDesc="主要诊疗工作") {
				 		Set ItemZL=Imp_ItemDesc
					 	Set indZL=indZL+1
					 	Set row=rowEpis+indZL+1
						Set retval=aItmjs_"(xlSheet,'"_$ZCVT(ItemZL,"O","JS")_"',"_row_",1);"
						&javascript<#(retval)#>
			 		} ElseIf (TypeDesc="重点医嘱") {
				 		Set ItemYZ=Imp_ItemDesc
					 	Set indYZ=indYZ+1
					 	Set row=rowEpis+indYZ+1
						Set retval=aItmjs_"(xlSheet,'"_$ZCVT(ItemYZ,"O","JS")_"',"_row_",2);"
						&javascript<#(retval)#>
				 	} ElseIf (TypeDesc="主要护理工作") {
				 		Set ItemHL=Imp_ItemDesc
					 	Set indHL=indHL+1
					 	Set row=rowEpis+indHL+1
						Set retval=aItmjs_"(xlSheet,'"_$ZCVT(ItemHL,"O","JS")_"',"_row_",3);"
						&javascript<#(retval)#>
				 	} Else {}
				 	
				}
				
				//变异信息
				Set indVar=0
				Set xVarID=""
				For {
					Set xVarID=$o(^DHCMA.CPW.CP.PathwayI("VAR","IdxofPwEp",PathwayID,PathwayID_"||"_xEpisID,xVarID))
					Quit:xVarID=""
					
					Set (VariatTxt,VariatCat)=""
					Set objVar=##class(DHCMA.CPW.CP.PathwayVar).GetObjById(PathwayID_"||"_xVarID)
			 		Continue:'$IsObject(objVar)
				 	Continue:'objVar.CPIsActive
				 	
			 		Set VariatTxt=objVar.CPVariatTxt
			 		Set VariatCat=objVar.CPVariatDr.BTDesc
			 		Continue:(VariatTxt="")&&(VariatCat="")
			 		Set VarStr=VariatCat
			 		Set:VariatTxt'="" VarStr=VariatCat_","_VariatTxt
				 	Set indVar=indVar+1
				 	Set row=rowEpis+indVar+1
					Set retval=aItmjs_"(xlSheet,'"_$ZCVT(VarStr,"O","JS")_"',"_row_",4);"
					&javascript<#(retval)#>
				}
				Set ItemMax=indZL
				Set:indYZ>ItemMax ItemMax=indYZ
				Set:indHL>ItemMax ItemMax=indHL
				Set:indVar>ItemMax ItemMax=indVar
				Set rowItem=rowItem+ItemMax
				
				Set rowSign=rowSign+1
				Set row=rowEpis+ItemMax+1+1
				Set retval="MergCells(xlSheet,"_row_",1,"_row_",4);"	//合并
				&javascript<#(retval)#>
				Set retval=aItmjs_"(xlSheet,'"_$ZCVT(SignInfo,"O","JS")_"',"_row_",1);"
				&javascript<#(retval)#>
				
				Set rowItem=rowItem+1
			}
		}
	}
	
	Quit 1
}

ClassMethod GetCPWAdmit(aMastID As %String) As %String
{
	New (aMastID)
	Set return=""
	Quit:aMastID="" return
	
	Set ICDList=""
	Set xTypeID=""
 	For {
	 	Set xTypeID = $o(^DHCMA.CPW.BT.PathAdmitI("IdxofPathType",aMastID,xTypeID))
	 	Quit:xTypeID=""
		
	 	Set xID = ""
	 	For {
		 	Set xID = $o(^DHCMA.CPW.BT.PathAdmitI("IdxofPathType",aMastID,xTypeID,xID))
		 	Quit:xID=""
		 	Set obj = ##class(DHCMA.CPW.BT.PathAdmit).GetObjById(xID)
		 	Continue:'$IsObject(obj)
		 	Continue:'obj.BTIsActive
		 	
		 	Set BTICD10 =obj.BTICD10
		 	Set BTICDKeys = obj.BTICDKeys
		 	
		 	Set ICDList=ICDList_","_BTICDKeys_"（ICD10："_BTICD10_"）"
	 	}
 	}
 	Set:ICDList'="" ICDList=$e(ICDList,2,$l(ICDList))
 	Set return=ICDList
 	
 	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2019-8-20
/// Description:  导出表单-路径信息
/// Table：       DHCMA.CPW.BT.PathForm
/// Input：       
///               
/// Return：      返回ROWSPEC
/// w ##Class(DHCMA.CPW.CPS.PrintSrv).ExportFormHead("xlheet","1")
ClassMethod ExportFormHead(aItmjs As %String, aFormID As %String) As %String
{
	New (aItmjs,aFormID)
	Set return=""
	Quit:aFormID="" return
	
	Set objForm=##class(DHCMA.CPW.BT.PathForm).GetObjById(aFormID)
	Quit:'$IsObject(objForm) return
	Quit:'$IsObject(objForm.FormPathDr) return
	
	Set FormDesc=objForm.FormPathDr.BTDesc
	Set FormType=objForm.FormPathDr.BTTypeDr.BTDesc
	
	Set retval=aItmjs_"(xlSheet,'"_$ZCVT(FormDesc,"O","JS")_"',1,2);"
	&javascript<#(retval)#>
	Set retval=aItmjs_"(xlSheet,'"_$ZCVT(FormType,"O","JS")_"',2,2);"
	&javascript<#(retval)#>
	Set FormHelpDoc=objForm.FormHelpDoc
	Set retval=aItmjs_"(xlSheet,'"_$ZCVT(FormHelpDoc,"O","JS")_"',3,2);"
	&javascript<#(retval)#>
	
	Set MastID=objForm.FormPathDr.%Id()
	Set (ICD10s,ICDKeys)=""
	Set xTypeID=""
 	For {
	 	Set xTypeID = $o(^DHCMA.CPW.BT.PathAdmitI("IdxofPathType",MastID,xTypeID))
	 	Quit:xTypeID=""
		
	 	Set xID = ""
	 	For {
		 	Set xID = $o(^DHCMA.CPW.BT.PathAdmitI("IdxofPathType",MastID,xTypeID,xID))
		 	Quit:xID=""
		 	Set obj = ##class(DHCMA.CPW.BT.PathAdmit).GetObjById(xID)
		 	Continue:'$IsObject(obj)
		 	Continue:'obj.BTIsActive
		 	
		 	Set BTICD10 =obj.BTICD10
		 	Set BTICDKeys = obj.BTICDKeys
		 	
		 	Set ICD10s=ICD10s_","_BTICD10
		 	Set ICDKeys=ICDKeys_","_BTICDKeys
	 	}
 	}
	Set:ICD10s'="" ICD10s=$e(ICD10s,2,$l(ICD10s))
	Set:ICDKeys'="" ICDKeys=$e(ICDKeys,2,$l(ICDKeys))
	Set retval=aItmjs_"(xlSheet,'"_$ZCVT(ICD10s,"O","JS")_"',4,2);"
	&javascript<#(retval)#>
	Set retval=aItmjs_"(xlSheet,'"_$ZCVT(ICDKeys,"O","JS")_"',5,2);"
	&javascript<#(retval)#>
	
	Set FormCost=objForm.FormCost
	Set FormDays=objForm.FormDays
	Set retval=aItmjs_"(xlSheet,'"_$ZCVT(FormCost,"O","JS")_"',8,2);"
	&javascript<#(retval)#>
	Set retval=aItmjs_"(xlSheet,'"_$ZCVT(FormDays,"O","JS")_"',9,2);"
	&javascript<#(retval)#>
	Set FormApply=objForm.FormApply
	Set retval=aItmjs_"(xlSheet,'"_$ZCVT(FormApply,"O","JS")_"',10,2);"
	&javascript<#(retval)#>
	
	Quit 1
}

/// Creator：     jiangpengpeng
/// CreatDate：   2019-8-20
/// Description:  导出表单-表单信息
/// Table：       DHCMA.CPW.BT.PathForm
/// Input：       
///               
/// Return：      返回ROWSPEC
/// w ##Class(DHCMA.CPW.CPS.PrintSrv).ExportFormContent("xlheet","2")
ClassMethod ExportFormContent(aItmjs As %String, aFormID As %String) As %String
{
	New (aItmjs,aFormID)
	Set return=""
	Quit:aFormID="" return
	
	Set objForm=##class(DHCMA.CPW.BT.PathForm).GetObjById(aFormID)
	Quit:'$IsObject(objForm) return
	Quit:'$IsObject(objForm.FormPathDr) return
	
	Set indexEp=1
	Set xEpID=""
 	For {
	 	Set xEpID = $o(^DHCMA.CPW.BT.PathFormD(aFormID,"EP",xEpID))
	 	Quit:xEpID=""
	 	
		Set objEp = ##class(DHCMA.CPW.BT.PathFormEp).GetObjById(aFormID_"||"_xEpID)
		Continue:'$IsObject(objEp)
		Continue:'objEp.EpIsActive
	 	Set EpDesc = objEp.EpDesc
	 	Set EpDays = objEp.EpDays
	 	
	 	Set indexEp=indexEp+1
	 	Set retval=aItmjs_"(xlSheet,'"_$ZCVT(EpDesc,"O","JS")_"',1,"_indexEp_");"
		&javascript<#(retval)#>
		Set retval=aItmjs_"(xlSheet,'"_$ZCVT(EpDays,"O","JS")_"',2,"_indexEp_");"
		&javascript<#(retval)#>
		
		Set (ItemListA,ItemListB,ItemListB1,ItemListB2,ItemListC)=""
		Set xItemID=""
		For {
		 	Set xItemID = $o(^DHCMA.CPW.BT.PathFormD(aFormID,"EP",xEpID,"ITM",xItemID))
		 	Quit:xItemID=""
		 	
			Set objItem = ##class(DHCMA.CPW.BT.PathFormItem).GetObjById(aFormID_"||"_xEpID_"||"_xItemID)
			Continue:'$IsObject(objItem)
			Continue:'objItem.ItemIsActive
			
			Set ItemCat=objItem.ItemCatDr.BTTypeDr.BTCode
		 	Set ItemDesc = objItem.ItemDesc
		 	Set IsOption = objItem.ItemIsOption
		 	Set ItemH=$s(IsOption:"【】",1:"【*】")
		 	
		 	If (ItemCat="A") {
		 		Set ItemListA=ItemListA_""""_ItemH_ItemDesc_""""_"&CHAR(10)&"
		 	} ElseIf (ItemCat="C") {
		 		Set ItemListC=ItemListC_""""_ItemH_ItemDesc_""""_"&CHAR(10)&"
		 	} Else {
			 	Set SubCatCode=objItem.ItemCatDr.BTCode
			 	If ($e(SubCatCode,1,3)="B01"){
		 			Set ItemListB1=ItemListB1_""""_ItemH_ItemDesc_""""_"&CHAR(10)&"
			 	} Else {
			 		Set ItemListB2=ItemListB2_""""_ItemH_ItemDesc_""""_"&CHAR(10)&"
			 	}
		 	}
		}
		Set ItemListB1="""长期医嘱"""_"&CHAR(10)&"_ItemListB1
		Set ItemListB2="""临时医嘱"""_"&CHAR(10)&"_ItemListB2
		Set ItemListB=ItemListB1_ItemListB2
		
		Set:ItemListA'="" ItemListA="="_$e(ItemListA,1,$l(ItemListA)-1)
		Set:ItemListB'="" ItemListB="="_$e(ItemListB,1,$l(ItemListB)-1)
		Set:ItemListC'="" ItemListC="="_$e(ItemListC,1,$l(ItemListC)-1)
		
		Set retval=aItmjs_"(xlSheet,'"_$ZCVT(ItemListA,"O","JS")_"',3,"_indexEp_");"
		&javascript<#(retval)#>
		Set retval=aItmjs_"(xlSheet,'"_$ZCVT(ItemListB,"O","JS")_"',4,"_indexEp_");"
		&javascript<#(retval)#>
		Set retval=aItmjs_"(xlSheet,'"_$ZCVT(ItemListC,"O","JS")_"',5,"_indexEp_");"
		&javascript<#(retval)#>
 	}
 	Quit 1
}

}
