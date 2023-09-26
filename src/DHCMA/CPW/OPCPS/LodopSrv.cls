/// 名称: DHCMA.CPW.OPCPS.LodopSrv
/// 描述: 临床路径Lodop打印相关服务
/// 编写者：jiangpengpeng
/// 编写日期: 2019-11-12
Class DHCMA.CPW.OPCPS.LodopSrv Extends %RegisteredObject [ Abstract, ClassType = "", Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2019-12-12
/// Description:  获取用户签名图片base64代码
/// Table：       
/// Input：       aUserID  
/// w ##Class(DHCMA.CPW.OPCPS.LodopSrv).GetUserImg("97!!1")
ClassMethod GetUserImg(aUserID As %String) As %String
{
	New (aUserID)
	Set return=""
	Quit:aUserID="" return
	
	Set objCA=##Class(CA.UsrSignatureInfo).GetInUseInfo(aUserID)
	Quit:'$IsObject(objCA) return
	Set return =objCA.SignImage
	
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2019-11-12
/// Description:  获取表单头部信息
/// Table：       DHCMA.CPW.CP.PathwayVisit
/// Input：       aEpisodeID就诊ID
/// Return：      路径名称、入径标准、患者信息、出入院日期   
/// zw ##Class(DHCMA.CPW.OPCPS.LodopSrv).GetHeadInfo("97!!1")
ClassMethod GetHeadInfo(aEpisodeID As %String) As %List
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	If (aEpisodeID'["!!") {
		Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
		Set aEpisodeID=aEpisodeID_"!!"_SYSDr
	}
	Set PathwayVisitID=$o(^DHCMA.CPW.CP.PathwayVisitI("IdxOfEpisodeID"," "_aEpisodeID,""),-1)	//取最新一条记录
	Quit:PathwayVisitID="" return
	
	Set objPathwayVisit=##class(DHCMA.CPW.CP.PathwayVisit).GetObjById(PathwayVisitID)
	Quit:'$IsObject(objPathwayVisit) return
	
	set objPat=##class(DHCMA.Util.EP.Episode).GetObjByOID(aEpisodeID)
	Quit:'$IsObject(objPat) return
	
	Set CPWDesc=objPathwayVisit.CPFormDr.FormPathDr.BTDesc_"临床路执行记录单"	//路径名称
	Set CPWAdmit="入径标准："
	Set AdmitStr=..GetCPWAdmit(objPathwayVisit.CPFormDr.FormPathDr.%Id())
	Set CPWAdmit=CPWAdmit_AdmitStr
	Set FormDays=objPathwayVisit.CPFormDr.FormDays_"天"	//标准住院日
	
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
	Set PatInfo="患者姓名："_PatName_"   性别："_PatSex_"   年龄："_PatAge
	Set DaysInfo="标准治疗日："_FormDays
	
	Set return=$lb(CPWDesc,CPWAdmit,PatInfo,DaysInfo)
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2019-11-13
/// Description:  获取表单项目执行信息
/// Table：       DHCMA.CPW.CP.Pathway
/// Input：       aEpisodeID就诊ID
/// Return：        
/// zw ##Class(DHCMA.CPW.OPCPS.LodopSrv).GetImplInfo("41!!1")
ClassMethod GetImplInfo(aEpisodeID As %String) As %List
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	If (aEpisodeID'["!!") {
		Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
		Set aEpisodeID=aEpisodeID_"!!"_SYSDr
	}
	Set PathwayVisitID=$o(^DHCMA.CPW.CP.PathwayVisitI("IdxOfEpisodeID"," "_aEpisodeID,""),-1)	//取最新一条记录
	Quit:PathwayVisitID="" return
	
	Set objPathwayVisit=##class(DHCMA.CPW.CP.PathwayVisit).GetObjById(PathwayVisitID)
	Quit:'$IsObject(objPathwayVisit) return
	
	Set PathwayID = objPathwayVisit.CPPathwayDr.%Id()
	
	Set NIndex="GetImplInfo"
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
	
	
	Set (EpisDescList,TimeList,DocSignList,NurSignList,ItemZLList,ItemYZList,ItemHLList,VarList)=""
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
				
				//项目执行信息
				Set (ItemZL,ItemYZ,ItemHL)=""
				Set xImplID=""
				For {
					Set xImplID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParRef",PathwayID,PathwayID_"||"_xEpisID,xImplID))
					Quit:xImplID=""
					
					Set objImpl=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(PathwayID_"||"_xImplID)
		 			Continue:'$IsObject(objImpl)
			 		Set IsActive=objImpl.CPIsActive
			 		Continue:'IsActive
			 		
			 		Set TypeDesc=objImpl.CPFormItemDr.ItemCatDr.BTTypeDr.BTDesc		//项目类型描述
			 		Set ItemDesc=objImpl.CPFormItemDr.ItemDesc		//项目描述
			 		Set IsImp=+objImpl.CPIsImp		//是否执行

			 		If (TypeDesc="主要诊疗工作") {
				 		Set ItemZL=ItemZL_$lb(IsImp,ItemDesc)
			 		} ElseIf (TypeDesc="重点医嘱") {
				 		Set ItemYZ=ItemYZ_$lb(IsImp,ItemDesc)
						
				 	} ElseIf (TypeDesc="主要护理工作") {
				 		Set ItemHL=ItemHL_$lb(IsImp,ItemDesc)
				 	} Else {}
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
	Set EpisData=$ListBuild(EpisNo,EpisDescList,TimeList,DocSignList,NurSignList,ItemZLList,ItemYZList,ItemHLList,VarList)
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
		 	
		 	Set ICDList=ICDList_","_BTICDKeys_"（ICD10："_BTICD10_"）"
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
/// w ##Class(DHCMA.CPW.OPCPS.LodopSrv).GetConsent("202!!1")
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

}
