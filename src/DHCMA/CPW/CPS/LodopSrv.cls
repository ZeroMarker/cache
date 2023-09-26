/// 名称: DHCMA.CPW.CPS.LodopSrv
/// 描述: 临床路径Lodop打印相关服务
/// 编写者：jiangpengpeng
/// 编写日期: 2019-11-12
Class DHCMA.CPW.CPS.LodopSrv Extends %RegisteredObject [ Abstract, ClassType = "", Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2019-12-12
/// Description:  获取用户签名图片base64代码
/// Table：       
/// Input：       aUserID  
/// w ##Class(DHCMA.CPW.CPS.LodopSrv).GetUserImg("18881!!1","40||1","DS")
ClassMethod GetUserImg(aUserID As %String, aCPEpisID As %String = "", aOperType As %String = "") As %String
{
	New (aUserID,aCPEpisID,aOperType,%session)
	Set return=""
	Quit:aUserID="" return
	
	Set aUserID=$p(aUserID,"!!",1),HospID=""
	Set:$d(%session) HospID=$g(%session.Data("LOGON.HOSPID"))
	Set SourceType=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWFormSignImgSource",HospID)
	If SourceType=1{
		Set isExist=##class(%Dictionary.MethodDefinition).%ExistsId("DHCMed.CA.SignVerify||GetObjByReportOpr")
		If isExist{
			Set objSV=##class(DHCMed.CA.SignVerify).GetObjByReportOpr("CPW","CPW",aCPEpisID,aOperType)
			Quit:'$IsObject(objSV) return
			Quit:'$IsObject(objSV.SVDigitalSignatureDR) return
			Set SignInfoID=objSV.SVDigitalSignatureDR.UsrSignInfoID
			Set objSignInfo=##class(CA.UsrSignatureInfo).%OpenId(SignInfoID)
			Quit:'$IsObject(objSignInfo) return
			Quit objSignInfo.SignImage
		}	
	}Else{
		Set objCA=##Class(CA.UsrSignatureInfo).GetInUseInfo(aUserID)
		Quit:'$IsObject(objCA) return
		Set return =objCA.SignImage	
	}
	
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2019-11-12
/// Description:  获取表单头部信息
/// Table：       DHCMA.CPW.CP.Pathway
/// Input：       aEpisodeID就诊ID
/// Return：      路径名称、入径标准、患者信息、出入院日期   
/// zw ##Class(DHCMA.CPW.CPS.LodopSrv).GetHeadInfo("97!!1")
ClassMethod GetHeadInfo(aEpisodeID As %String) As %List
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	If (aEpisodeID'["!!") {
		Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
		Set aEpisodeID=aEpisodeID_"!!"_SYSDr
	}
	Set PathwayID=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",aEpisodeID,""),-1)	//取最新一条记录
	Quit:PathwayID="" return
	
	Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(PathwayID)
	Quit:'$IsObject(objPathway) return
	
	//调用前先同步患者最新信息,避免当天出院病人没有出院日期的情况 Modefied by yankai 20220519
	Set flg=##class(DHCMA.Util.EP.Episode).xSetByOID(aEpisodeID)
	Quit:+flg<1 return
	Set objPat=##class(DHCMA.Util.EP.Episode).GetObjByOID(aEpisodeID)
	Quit:'$IsObject(objPat) return
	
	Set CPWDesc=objPathway.CPFormDr.FormPathDr.BTDesc_"临床路执行记录单"	//路径名称
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
	
	Set return=$lb(CPWDesc,CPWAdmit,PatInfo,DaysInfo)
	Quit return
}

/// Creator：     zqy
/// CreatDate：   2022-1-5
/// Description:  获取表单头部信息(只输出数据)
/// Table：       DHCMA.CPW.CP.Pathway
/// Input：       aEpisodeID就诊ID
/// Return：      路径名称、入径标准、患者信息、出入院日期   
/// zw ##Class(DHCMA.CPW.CPS.LodopSrv).GetHeadDataInfo("5839!!1")
ClassMethod GetHeadDataInfo(aEpisodeID As %String) As %List
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	If (aEpisodeID'["!!") {
		Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
		Set aEpisodeID=aEpisodeID_"!!"_SYSDr
	}
	Set PathwayID=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",aEpisodeID,""),-1)	//取最新一条记录
	Quit:PathwayID="" return
	
	Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(PathwayID)
	Quit:'$IsObject(objPathway) return
	
	//调用前先同步患者最新信息,避免当天出院病人没有出院日期的情况 Modefied by yankai 20220519
	Set flg=##class(DHCMA.Util.EP.Episode).xSetByOID(aEpisodeID)
	Quit:+flg<1 return
	Set objPat=##class(DHCMA.Util.EP.Episode).GetObjByOID(aEpisodeID)
	Quit:'$IsObject(objPat) return
	
	Set CPWDesc=objPathway.CPFormDr.FormPathDr.BTDesc_"临床路执行记录单"	//路径名称
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
	Set:DischDate="" DischDate=""
	Set PatInfo=PatName_"^"_PatSex_"^"_PatAge_"^"_MrNo
	Set DaysInfo=AdmDate_"^"_DischDate_"^"_FormDays
	
	Set return=$lb(CPWDesc,CPWAdmit,PatInfo,DaysInfo)
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2019-11-13
/// Description:  获取表单项目执行信息
/// Table：       DHCMA.CPW.CP.Pathway
/// Input：       aEpisodeID就诊ID
/// Return：        
/// zw ##Class(DHCMA.CPW.CPS.LodopSrv).GetImplInfo("41!!1")
ClassMethod GetImplInfo(aEpisodeID As %String) As %List
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
	If (aEpisodeID'["!!") {
		Set aEpisodeID=aEpisodeID_"!!"_SYSDr
	}
 	Set LocID=$p($g(^PAADM($p(aEpisodeID,"!!",1))),"^",4)  //就诊科室
 	Set AdmLocID=LocID_"!!"_SYSDr
 	Set HospID=$p($g(^CTLOC(LocID)),"^",22)
 	Set AdmHospID=HospID_"!!"_SYSDr
 	// 检查配置是否显示合并症执行的项目
 	Set IsShowComplItem=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWIsShowComplItem",AdmHospID)
	
	Set PathwayID=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",aEpisodeID,""),-1)	//取最新一条记录
	Quit:PathwayID="" return
	
	Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(PathwayID)
	Quit:'$IsObject(objPathway) return
	
    Set IsPrintAll=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWCheckIsPrintAll",AdmHospID)	//是否打印全部内容
	
	Set NIndex="GetImplInfo",MIndex="SortImpByIndNo"
    Kill ^TMP($zn,$j,NIndex)
    Kill ^TMP($zn,$j,MIndex)
    
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
		
		If (IsPrintAll'="Y") {
			//过滤未确认阶段
			Continue:'objEpis.CPIsConfirm
		}
		
		Set IndNo=objEpis.CPIndNo
		Set BTFormEpID=objEpis.CPFormEpDr.%Id()
		Set BTFormID=$p(BTFormEpID,"||",1)
		If (PreBTFormID'=BTFormID) {
			Set IsExec=IsExec+1
			Set PreBTFormID=BTFormID
		}
		Set ^TMP($zn,$j,NIndex,IsExec,IndNo,xEpisID)=""
	}
	
	
	Set (EpisDescList,EpisIDList,TimeList,DocSignList,NurSignList,ItemZLList,ItemYZList,ItemHLList,VarList)=""
	Set EpisData=""
	Set indEpis=1
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
				Set $List(EpisDescList,indEpis)=EpisDesc
				Set $List(EpisIDList,indEpis)=PathwayID_"||"_xEpisID
				
				Set SttDate=objEpis.CPSttDate
				Set EndDate=objEpis.CPEndDate
				Set:SttDate'="" SttDate=$zd(SttDate,3)
				Set:EndDate'="" EndDate=$zd(EndDate,3)
				Set TimeInfo=SttDate_"至"_EndDate
				Set $List(TimeList,indEpis)=TimeInfo
				
				Set (SignDoc,SignNur)=""
				Set SignDocID=objEpis.CPSignDocID
				Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(SignDocID)
				Set:$IsObject(objUser) SignDoc=objUser.BTDesc
				Set SignNurID=objEpis.CPSignNurID
				Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(SignNurID)
				Set:$IsObject(objUser) SignNur=objUser.BTDesc
				Set $List(DocSignList,indEpis)=$lb(SignDocID,SignDoc)
				Set $List(NurSignList,indEpis)=$lb(SignNurID,SignNur)
				
				Kill ^TMP($zn,$j,MIndex)
				//项目执行信息
				Set xImplID=""
				For {
					Set xImplID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParRef",PathwayID,PathwayID_"||"_xEpisID,xImplID))
					Quit:xImplID=""
					
					Set objImpl=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(PathwayID_"||"_xImplID)
		 			Continue:'$IsObject(objImpl)
			 		Set IsActive=objImpl.CPIsActive
			 		Continue:'IsActive
			 		Continue:('+IsShowComplItem)&&(objImpl.CPPathwayComplDr'="")	//不显示时过滤合并症执行的项目
			 		
			 		Set TypeDesc=objImpl.CPFormItemDr.ItemCatDr.BTTypeDr.BTDesc		//项目类型描述
			 		Set ItemDesc=objImpl.CPFormItemDr.ItemDesc		//项目描述
			 		Set:objImpl.CPPathwayComplDr'="" ItemDesc="【合】"_ItemDesc
			 		Set IsImp=+objImpl.CPIsImp		//是否执行
			 		Set ItemIndNo=objImpl.CPFormItemDr.ItemIndNo		//顺序号

				 	If (TypeDesc="主要诊疗工作") {
				 		If $d(^TMP($zn,$j,MIndex,1,ItemIndNo)){
					 		Set count=$o(^TMP($zn,$j,MIndex,1,ItemIndNo,""),-1)
					 		Set ^TMP($zn,$j,MIndex,1,ItemIndNo,count+1)=$lb(IsImp,ItemDesc)	
					 	}else{
						 	Set ^TMP($zn,$j,MIndex,1,ItemIndNo,1)=$lb(IsImp,ItemDesc)
						}		
			 		} ElseIf (TypeDesc="重点医嘱") {
				 		If $d(^TMP($zn,$j,MIndex,2,ItemIndNo)){
					 		Set count=$o(^TMP($zn,$j,MIndex,2,ItemIndNo,""),-1)
					 		Set ^TMP($zn,$j,MIndex,2,ItemIndNo,count+1)=$lb(IsImp,ItemDesc)	
					 	}else{
						 	Set ^TMP($zn,$j,MIndex,2,ItemIndNo,1)=$lb(IsImp,ItemDesc)
						}
				 	} ElseIf (TypeDesc="主要护理工作") {
					 	If $d(^TMP($zn,$j,MIndex,3,ItemIndNo)){
					 		Set count=$o(^TMP($zn,$j,MIndex,3,ItemIndNo,""),-1)
					 		Set ^TMP($zn,$j,MIndex,3,ItemIndNo,count+1)=$lb(IsImp,ItemDesc)	
					 	}else{
						 	Set ^TMP($zn,$j,MIndex,3,ItemIndNo,1)=$lb(IsImp,ItemDesc)
						}
				 	} Else {}
				}
				
				Set ItemZL="",ItemYZ="",ItemHL=""
				Set xItemType=""
				For{
					Set xItemType=$o(^TMP($zn,$j,MIndex,xItemType))
					Quit:xItemType=""
			
					Set xItemIndNo=""
					For {
						Set xItemIndNo=$o(^TMP($zn,$j,MIndex,xItemType,xItemIndNo))
						Quit:xItemIndNo=""
							
						Set xCount=""
						For {
							Set xCount=$o(^TMP($zn,$j,MIndex,xItemType,xItemIndNo,xCount))
							Quit:xCount=""
								
							Set Data=$g(^TMP($zn,$j,MIndex,xItemType,xItemIndNo,xCount))
							Set:xItemType=1 ItemZL=ItemZL_Data
							Set:xItemType=2 ItemYZ=ItemYZ_Data
							Set:xItemType=3 ItemHL=ItemHL_Data
						}
					}
				}
				
				Set $List(ItemZLList,indEpis)=ItemZL
				Set $List(ItemYZList,indEpis)=ItemYZ
				Set $List(ItemHLList,indEpis)=ItemHL
				
				//变异信息
				Set indVar=1
				Set xVarList=""
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
			 		Set $List(xVarList,indVar)=VarStr
				 	Set indVar=indVar+1
				}
				Set $List(VarList,indEpis)=xVarList
				
				Set indEpis=indEpis+1
			}
		}
	}
	
	Set EpisNo=indEpis-1
	Set EpisData=$ListBuild(EpisNo,EpisDescList,TimeList,DocSignList,NurSignList,ItemZLList,ItemYZList,ItemHLList,VarList,EpisIDList)
	Set return=EpisData
	Quit return
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
		 	
		 	Set ICDList=ICDList_","_BTICDKeys_"（ICD10:"_BTICD10_"）"
	 	}
 	}
 	Set:ICDList'="" ICDList=$e(ICDList,2,$l(ICDList))
 	Set return=ICDList
 	
 	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2019-12-12
/// Description:  获取基本信息
/// Table：       
/// Input：       aEpisodeID  
/// w ##Class(DHCMA.CPW.CPS.LodopSrv).GetConsent("202!!1")
ClassMethod GetConsent(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	set objPat=##class(DHCMA.Util.EP.Episode).GetObjByOID(aEpisodeID)
	Quit:'$IsObject(objPat) return
	
	Set MrNo=objPat.PAMrNo
	Set PatName=objPat.PAPatName
	Set PatSex=objPat.PASex
	Set PatSex=$Case(PatSex,"F":"女","M":"男",:"")
	Set PatAge=objPat.PAAge
	Set AdmLocDesc=""
	Set AdmLocID=objPat.PAAdmLocID
	Set:AdmLocID'="" objLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(AdmLocID)
	Set:$IsObject(objLoc) AdmLocDesc=objLoc.BTDesc
	
	Set return=PatName_"^"_PatSex_"^"_PatAge_"^"_AdmLocDesc_"^"_MrNo
	Quit return
}

/// Creator：     zqy
/// CreatDate：   2023-1-5
/// Description:  获取院区信息
/// Table：       
/// Input：       aHospID  
/// w ##Class(DHCMA.CPW.CPS.LodopSrv).GetHospDesc("2!!1")
ClassMethod GetHospDesc(aHospID As %String) As %String
{
	New (aHospID)
	Set return=""
	Quit:aHospID="" return
	
	set obj=##class(DHCMA.Util.EP.Hospital).GetObjByOID(aHospID)
	Quit:'$IsObject(obj) return
	
	Set return=obj.BTDesc
	Quit return
}

}
