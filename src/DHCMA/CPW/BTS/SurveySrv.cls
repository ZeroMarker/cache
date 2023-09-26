Class DHCMA.CPW.BTS.SurveySrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zqy
/// CreatDate：   2021-12-15
/// Description:  查询临床路径标题
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.SurveySrv","QrySurvey")
Query QrySurvey(aHospID As %String = "") As %Query(ROWSPEC = "BTID:%String,BTCode:%String,BTTitle:%String,BTResume:%String")
{
}

ClassMethod QrySurveyExecute(ByRef qHandle As %Binary, aHospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set IsOpen=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIsOpenMultiHospMode",aHospID)
 	Set xID=""
 	For {
	 	Set xID      = $o(^DHCMA.CPW.BT.SurveyD(xID))
	 	Quit:xID=""
	 	Set obj         = ##class(DHCMA.CPW.BT.Survey).GetObjById(xID)
	 	continue:'$IsObject(obj)
	 	If (IsOpen="Y")&&(aHospID'=""){
		 	Set retFlg=##class(DHCMA.Util.IO.MultiHospInterface).IsShowOneDataByHosp("DHCMA_CPW_BT.Survey",xID,aHospID)
		 	Continue:retFlg'="Y"
		}
	 	Set Code          = obj.SQCode
	 	Set Title         = obj.SQTitle
	 	Set Resume        = obj.SQResume
		Set Data=$lb(xID,Code,Title,Resume)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QrySurveyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySurveyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySurveyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySurveyExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description:  取患者信息
/// Table：       
/// Input：       EpisodeID
/// Return：      返回List
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.SurveySrv","QryPatData","895!!1","SurQuestion")
Query QryPatData(aEpisodeID As %String, aCode As %String) As %Query(ROWSPEC = "EpisodeID:%String,PatientID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,PatSex:%String,PatAge:%String,AdmDate:%String,DischDate:%String,InHospDate:%String,PatCost:%String,PAAdmType:%String,AdmLoc:%String,AdmLocDesc:%String,AdmNo:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,Title:%String")
{
}

ClassMethod QryPatDataExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set return=0
 	
 	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
	Set SuiDesc= ##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("Bill.Com.Age","岁",LangID)	
	Set YueDesc= ##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("Bill.Com.Age","月",LangID)	
	Set TianDesc= ##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("Bill.Com.Age","天",LangID)	
	Set XiaoShiDesc = ##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("Bill.Com.Age","小时",LangID)	
	Set FenDesc= ##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("Bill.Com.Age","分",LangID)	
	Set WeiZhiDesc = ##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("Bill.Com.Age","未知",LangID)	
	Set YuanDesc= ##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("dhcma.cpw.cp.survey.csp","元",LangID)	
	
	Quit:aEpisodeID="" $$$OK
	Set objPat=##class(DHCMA.Util.EP.Episode).GetObjByOID(aEpisodeID)
	Quit:'$IsObject(objPat) return
	
	Set PatientID=objPat.PAPatientID	//病人ID
	Set PapmiNo=objPat.PAPapmiNo		//登记号
	Set MrNo=objPat.PAMrNo				//病案号
	Set PatName=objPat.PAPatName		//姓名
	Set PatSex=objPat.PASex				//性别
	Set PatSex=$Case(PatSex,"F":"女","M":"男",:"")
	Set:PatSex'="" PatSex=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.CTSex","CTSEXDesc",PatSex,Languages)
	
	Set PatAge=objPat.PAAge				//年龄
	Set:PatAge["岁" PatAge=$replace(PatAge,"岁",SuiDesc)
	Set:PatAge["月" PatAge=$replace(PatAge,"月",SuiDesc)
	Set:PatAge["天" PatAge=$replace(PatAge,"天",SuiDesc)
	Set:PatAge["小时" PatAge=$replace(PatAge,"小时",XiaoShiDesc) 
	Set:PatAge["分" PatAge=$replace(PatAge,"分",FenDesc)
	Set:PatAge["未知" PatAge=$replace(PatAge,"未知",WeiZhiDesc) 
	
	Set AdmDate=objPat.PAAdmDate		//入院日期
	Set DischDate=objPat.PADischDate	//出院日期
	Set AdmLoc=objPat.PAAdmLocID		//就诊科室
	Set AdmLocDesc=objPat.PAAdmLocDesc	//就诊科室Desc					
	Set:AdmLocDesc="" objLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(AdmLoc)
	Set:(AdmLocDesc="")&&($IsObject(objLoc)) AdmLocDesc=objLoc.BTDesc		//更新科室
	Set:AdmLocDesc'="" AdmLocDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.CTLoc","CTLOCDesc",AdmLocDesc,Languages)
	
	Set AdmNo=objPat.PAAdmNo			//住院号
	Set AdmWardID=objPat.PAAdmWardID
	Set AdmWardDesc=objPat.PAAdmWardDesc //病区Desc
	Set:AdmWardDesc="" objWard=##class(DHCMA.Util.EP.Location).GetObjByOID(AdmWardID)
	Set:(AdmWardDesc="")&&($IsObject(objWard)) AdmWardDesc=objWard.BTDesc
	Set:AdmWardDesc'="" AdmWardDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.CTLoc","CTLOCDesc",AdmWardDesc,Languages)
	
	Set AdmRoom=objPat.PAAdmRoom	//就诊房间
	Set AdmBed=objPat.PAAdmBed		//床位
	Set InHospDate=$Case(DischDate'="",1: DischDate-AdmDate,0:+$H-AdmDate)   //住院天数
	Set:InHospDate=0 InHospDate=1
	Set InHospDate=InHospDate_"("_TianDesc_")"
	Set AdmDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set DischDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	
	Set paadm=$p(aEpisodeID,"!!",1)
	Set Feestr=##class(web.DHCCPW.MR.Interface).GetAdmCateFee(paadm)
	Set PatCost=$p(Feestr,"^",1)_YuanDesc		//住院总费用。。。
	//增加过滤门诊
	Set PAAdmType=objPat.PAAdmType
	Set SurveyID=##class(DHCMA.CPW.BT.Survey).CheckSQCode(aCode)	
	Quit:SurveyID=0 return
	Set objSurvey=##class(DHCMA.CPW.BT.Survey).GetObjById(SurveyID)
	Set Title=objSurvey.SQTitle
	Set:Title'="" Title=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.Survey","SQTitle",Title,LangID)
	
	Set Data=$lb(aEpisodeID,PatientID,PapmiNo,MrNo,PatName,PatSex,PatAge,AdmDate,DischDate,InHospDate,PatCost,PAAdmType,AdmLoc,AdmLocDesc,AdmNo,AdmWardDesc,AdmRoom,AdmBed,Title)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
 		
	Quit $$$OK
}

ClassMethod QryPatDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPatDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPatDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPatDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zqy
/// CreatDate：   2021-12-15
/// Description:  临床路径调查问卷
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.SurveySrv","QrySurveyQ","SurQuestion")
Query QrySurveyQ(aCode As %String) As %Query(ROWSPEC = "BTDesc:%String,BTType:%String,BTScore:%String,QuesId:%String")
{
}

ClassMethod QrySurveyQExecute(ByRef qHandle As %Binary, aCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
 	
 	Quit:aCode="" $$$OK
	Set SurveyID=##class(DHCMA.CPW.BT.Survey).CheckSQCode(aCode)	
	Quit:SurveyID=0
	//题目
	Set xItemNo=""
	For{
		Set xItemNo=$o(^DHCMA.CPW.BT.SurveyI("QST","IdxofPItemNo",SurveyID,xItemNo))
		Quit:xItemNo=""
		Set xQID=""
		For{
			Set xQID=$o(^DHCMA.CPW.BT.SurveyI("QST","IdxofPItemNo",SurveyID,xItemNo,xQID))
			Quit:xQID=""
			Set objQues=##class(DHCMA.CPW.BT.SurveyQuestion).GetObjById(SurveyID_"||"_xQID)
			Quit:'$IsObject(objQues)
			Set ItemDesc=objQues.SQItemDesc				//描述
			Set:ItemDesc'="" ItemDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("DHCMA.CPW.BT.SurveyQuestion","SQItemDesc",ItemDesc,Languages)
			Set ItemType=objQues.SQItemType.BTCode		//类型
			Set ItemScore=objQues.SQItemScore			//分值
			Set QuesId=SurveyID_"||"_xQID
			Set Data=$lb(ItemDesc,ItemType,ItemScore,QuesId)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
		
	}
	
	Quit $$$OK
}

ClassMethod QrySurveyQClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySurveyQExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySurveyQFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySurveyQExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// w ##Class(DHCMA.CPW.BTS.SurveySrv).GetOptionIDByQues("1||5")
ClassMethod GetOptionIDByQues(QuestionID As %String) As %String
{
	New (QuestionID)
	Set return=""
	
 	Set xOptionNo=""
 	Set SurveyID=$p(QuestionID,"||",1)
 	Set QID=$p(QuestionID,"||",2)
 	Quit:((SurveyID="")||(QID="")) $$$OK
	For{
		Set xOptionNo=$o(^DHCMA.CPW.BT.SurveyI("OPT","IdxofPOptionNo",SurveyID,QID,xOptionNo))
		Quit:xOptionNo=""
		Set xOID=""
		For{
			Set xOID=$o(^DHCMA.CPW.BT.SurveyI("OPT","IdxofPOptionNo",SurveyID,QID,xOptionNo,xOID))
			Quit:xOID=""
			Set objOption=##class(DHCMA.CPW.BT.SurveyOption).GetObjById(SurveyID_"||"_QID_"||"_xOID)
			Quit:'$IsObject(objOption)
			Set objQues=##class(DHCMA.CPW.BT.SurveyQuestion).GetObjById(SurveyID_"||"_QID)
			Quit:'$IsObject(objQues)
			if (objQues.SQItemType.BTCode["Check"){
				Set OptionNo=objOption.SQOptionNo		//描述
				Set ItemDesc=objOption.SQOptionDesc		//描述
				Set ItemScore=objOption.SQOptionScore		//分值
				Set OID=SurveyID_"-"_QID_"-"_xOID
				Set return=return_OID_$c(2)_ItemDesc_$c(1)
			}else{
				Set OptionNo=objOption.SQOptionNo		//描述
				Set ItemDesc=objOption.SQOptionDesc		//描述
				Set ItemScore=objOption.SQOptionScore		//分值
				Set OID=SurveyID_"||"_QID_"||"_xOID
				Set return=return_OID_$c(2)_ItemDesc_$c(1)
			}
			
		}
	}
 	Set:return'="" return=$e(return,1,$l(return)-1)
	Quit return
}

}
