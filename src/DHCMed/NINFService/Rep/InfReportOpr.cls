/// 名称: DHCMed.NINFService.Rep.InfReportOpr
/// 描述: 医院感染报告 手术信息
/// 编写者：zhufei
/// 编写日期: 2011-06-21
Class DHCMed.NINFService.Rep.InfReportOpr Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2012-06-21
/// Description:  取医院感染报告 手术信息
/// Table：       DHCMed.NINF.Rep.InfReportOpr
/// Input：       DHCMed.NINF.Rep.InfReportOpr.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINFService.Rep.InfReportOpr).GetSubRec(1)
ClassMethod GetSubRec(aRepID As %String) As DHCMed.NINF.Rep.InfReportOpr
{
	New (aRepID)
	Set return=""
	Quit:aRepID="" return
	
	Set SubID=0
	For {
		Set SubID=$o(^DHCMed.NINF("InfRep",aRepID,"Opr",SubID))
		Quit:SubID=""
		Set return=return_$c(1)_aRepID_"||"_SubID
	}
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-06-21
/// Description:  取医院感染报告 手术信息
/// Table：       DHCMed.NINF.Rep.InfReportOpr
/// Input：       DHCMed.NINF.Rep.InfReportOpr.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINFService.Rep.InfReportOpr).GetSubObj(1)
ClassMethod GetSubObj(aId As %String) As DHCMed.NINF.Rep.InfReportOpr
{
	New (aId)
	Set return=""
	
	Set obj=##Class(DHCMed.NINF.Rep.InfReportOpr).GetObjById(aId)
	If $IsObject(obj) {
		Set return=obj
	} Else {
		Set obj=##Class(DHCMed.NINF.Rep.InfReportOpr).%New()
		If obj'="" Do obj.%Close()
		set return=obj
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2013-01-09
/// Description:  取医院感染报告 手术信息
///               主要处理"List"类型数据
/// Table：       DHCMed.NINF.Rep.InfReportOpr
/// Input：       DHCMed.NINF.Rep.InfReportOpr.ID
/// Return：      返回String
/// w ##class(DHCMed.NINFService.Rep.InfReportOpr).GetFieldById(1,"PostoperComps")
ClassMethod GetFieldById(aId As %String, aFieldName As %String) As %String
{
	New (aId,aFieldName)
	Set return=""
	Quit:(aId="")||(aFieldName="") return
	
	Set $ZT="GetFieldByIdErr"
	
	Set obj=##Class(DHCMed.NINF.Rep.InfReportOpr).GetObjById(aId)
	Quit:'$IsObject(obj) return
	
	If aFieldName="PostoperComps" {
		For ind=1:1:obj.PostoperComps.Count() {
			Set objDic=obj.PostoperComps.GetAt(ind)
			Continue:'$IsObject(objDic)
			Set return=return_$c(1)_objDic.%Id()
		}
		Set:return'="" return=$e(return,2,$l(return))
	} Else {
		Set valExpress="Set return=obj."_aFieldName
		X valExpress
	}
	
	Quit return
	
GetFieldByIdErr
	Quit ""
}

/// Creator：     zhufei
/// CreatDate：   2012-06-26
/// Description:  删除医院感染报告 手术信息
/// Table：       DHCMed.NINF.Rep.InfReportOpr
/// Input：       DHCMed.NINF.Rep.InfReport.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINFService.Rep.InfReportOpr).DelSubRec(1)
ClassMethod DelSubRec(aId As %String) As %String
{
	New (aId)
	Set return=##Class(DHCMed.NINF.Rep.InfReportOpr).DeleteById(aId)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-06-26
/// Description:  保存医院感染报告 手术信息
/// Table：       DHCMed.NINF.Rep.InfReportOpr
/// Input：       
/// Return：      返回ID
/// w ##class(DHCMed.NINFService.Rep.InfReportOpr).SaveSubRec("6^^^522^胸腺病损切除术^2013-01-09^00:00^2013-01-09^00:00^2^6008^6002^6013^6018^6080^6021^6025^^22^6245^6251^6253^6256^6259^11^6262^221^6268/6269","^,/")
ClassMethod SaveSubRec(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set $ZT="SaveSubRecErr"
	
	Set CHR1=$p(aSeparate,",",1)
	Set CHR2=$p(aSeparate,",",2)
	Quit:(CHR1="")||(CHR2="") return
	
	Set RepID=$p(aInput,CHR1,1)
	Quit:RepID="" return
	Quit:'$d(^DHCMed.NINF("InfRep",RepID)) return
	
	Set OperationDesc=$p(aInput,CHR1,5)
	Quit:OperationDesc="" return
	
	Set StartDate=$p(aInput,CHR1,6)
	;Set:StartDate["-" StartDate=$zdh(StartDate,3)
	Set:StartDate'="" StartDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(StartDate)
	Set StartTime=$p(aInput,CHR1,7)
	Set:StartTime[":" StartTime=$zth(StartTime,1)
	Set EndDate=$p(aInput,CHR1,8)
	;Set:EndDate["-" EndDate=$zdh(EndDate,3)
	Set:EndDate'="" EndDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(EndDate)
	Set EndTime=$p(aInput,CHR1,9)
	Set:EndTime[":" EndTime=$zth(EndTime,1)
	
	Set $p(aInput,CHR1,6)=StartDate
	Set $p(aInput,CHR1,7)=StartTime
	Set $p(aInput,CHR1,8)=EndDate
	Set $p(aInput,CHR1,9)=EndTime
	
	Set return=##Class(DHCMed.NINF.Rep.InfReportOpr).Update(aInput,aSeparate)
	Quit return
	
SaveSubRecErr
	Quit -999
}

/// Creator：     zhufei
/// CreatDate：   2012-05-26
/// Description:  查询手术信息
/// Table：       DHCMed.NINF.Rep.InfReportOpr
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.InfReportOpr","QrySubRec","","19994431")
Query QrySubRec(aReportID As %String, aEpisodeID As %String) As %Query(ROWSPEC = "RepID:%String,SubID:%String,OperationID:%String,OperationDesc:%String,OperDocID:%String,OperDocDesc:%String,OperStartDate:%String,OperStartTime:%String,OperEndDate:%String,OperEndTime:%String,OperationTypeID:%String,OperationTypeDesc:%String,AnesthesiaID:%String,AnesthesiaDesc:%String,CuteTypeID:%String,CuteTypeDesc:%String,CuteHealingID:%String,CuteHealingDesc:%String,CuteInfFlagID:%String,CuteInfFlagDesc:%String,OperInfTypeID:%String,OperInfTypeDesc:%String,InHospInfFlagID:%String,InHospInfFlagDesc:%String,ASAScoreID:%String,ASAScoreDesc:%String,DataSource:%String,PreoperWBC:%String,CuteNumberID:%String,CuteNumberDesc:%String,EndoscopeFlagID:%String,EndoscopeFlagDesc:%String,ImplantFlagID:%String,ImplantFlagDesc:%String,PreoperAntiFlagID:%String,PreoperAntiFlagDesc:%String,BloodLossFlagID:%String,BloodLossFlagDesc:%String,BloodLoss:%String,BloodTransFlagID:%String,BloodTransFlagDesc:%String,BloodTrans:%String,PostoperComps:%String,PostoperCompsDesc:%String") [ SqlProc ]
{
}

ClassMethod QrySubRecExecute(ByRef qHandle As %Binary, aReportID As %String, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aReportID="")&&(aEpisodeID="") $$$OK
	
	If aReportID'="" {
		Set xSubID=0
		For {
			Set xSubID=$o(^DHCMed.NINF("InfRep",aReportID,"Opr",xSubID))
			Quit:xSubID=""
			
			Set objSub=##class(DHCMed.NINF.Rep.InfReportOpr).GetObjById(aReportID_"||"_xSubID)
			Continue:'$IsObject(objSub)
			
			Set (OperationID,OperationDesc,OperDocID,OperDocDesc)=""
			Set (OperStartDate,OperStartTime,OperEndDate,OperEndTime)=""
			Set (OperationTypeID,OperationTypeDesc,AnesthesiaID,AnesthesiaDesc)=""
			Set (CuteTypeID,CuteTypeDesc,CuteHealingID,CuteHealingDesc)=""
			Set (CuteInfFlagID,CuteInfFlagDesc,OperInfTypeID,OperInfTypeDesc,InHospInfFlagID,InHospInfFlagDesc)=""
			Set (ASAScoreID,ASAScoreDesc,DataSource)=""
			Set (PreoperWBC,CuteNumberID,CuteNumberDesc)=""
			Set (EndoscopeFlagID,EndoscopeFlagDesc,ImplantFlagID,ImplantFlagDesc,PreoperAntiFlagID,PreoperAntiFlagDesc)=""
			Set (BloodLossFlagID,BloodLossFlagDesc,BloodLoss,BloodTransFlagID,BloodTransFlagDesc,BloodTrans,PostoperComps,PostoperCompsDesc)=""
			
			Set OperationID=objSub.OperationID
			Set OperationDesc=objSub.OperationDesc
			
			Set OperStartDate=objSub.OperStartDate
			If (OperStartDate'="") {
				;Set OperStartDate=$zd(OperStartDate,3)
				Set OperStartDate=##class(DHCMed.SSService.CommonCls).DateLogicalToHtml(OperStartDate)
				Set OperStartTime=objSub.OperStartTime
				Set OperStartTime=$zt(+OperStartTime,2)
			}
			Set OperEndDate=objSub.OperEndDate
			If (OperEndDate'="") {
				;Set OperEndDate=$zd(OperEndDate,3)
				Set OperEndDate=##class(DHCMed.SSService.CommonCls).DateLogicalToHtml(OperEndDate)
				Set OperEndTime=objSub.OperEndTime
				Set OperEndTime=$zt(+OperEndTime,2)
			}
			
			Set OperDoc=objSub.OperDoc
			Set objSSUser=##class(DHCMed.Base.SSUser).GetObjById(OperDoc)
			If $IsObject(objSSUser) {
				Set OperDocID=objSSUser.Rowid
				Set OperDocDesc=objSSUser.Name
			}
			If $IsObject(objSub.OperationType) {
				Set OperationTypeID=objSub.OperationType.%Id()
				Set OperationTypeDesc=objSub.OperationType.Description
			}
			If $IsObject(objSub.Anesthesia) {
				Set AnesthesiaID=objSub.Anesthesia.%Id()
				Set AnesthesiaDesc=objSub.Anesthesia.Description
			}
			If $IsObject(objSub.CuteType) {
				Set CuteTypeID=objSub.CuteType.%Id()
				Set CuteTypeDesc=objSub.CuteType.Description
			}
			If $IsObject(objSub.CuteHealing) {
				Set CuteHealingID=objSub.CuteHealing.%Id()
				Set CuteHealingDesc=objSub.CuteHealing.Description
			}
			If $IsObject(objSub.CuteInfFlag) {
				Set CuteInfFlagID=objSub.CuteInfFlag.%Id()
				Set CuteInfFlagDesc=objSub.CuteInfFlag.Description
			}
			If $IsObject(objSub.OperInfType) {
				Set OperInfTypeID=objSub.OperInfType.%Id()
				Set OperInfTypeDesc=objSub.OperInfType.Description
			}
			If $IsObject(objSub.InHospInfFlag) {
				Set InHospInfFlagID=objSub.InHospInfFlag.%Id()
				Set InHospInfFlagDesc=objSub.InHospInfFlag.Description
			}
			If $IsObject(objSub.ASAScore) {
				Set ASAScoreID=objSub.ASAScore.%Id()
				Set ASAScoreDesc=objSub.ASAScore.Description
			}
			
			Set DataSource=objSub.DataSource
			
			Set Data=$lb(aReportID,xSubID)
			Set Data=Data_$lb(OperationID,OperationDesc,OperDocID,OperDocDesc)
			Set Data=Data_$lb(OperStartDate,OperStartTime,OperEndDate,OperEndTime)
			Set Data=Data_$lb(OperationTypeID,OperationTypeDesc,AnesthesiaID,AnesthesiaDesc)
			Set Data=Data_$lb(CuteTypeID,CuteTypeDesc,CuteHealingID,CuteHealingDesc)
			Set Data=Data_$lb(CuteInfFlagID,CuteInfFlagDesc,OperInfTypeID,OperInfTypeDesc,InHospInfFlagID,InHospInfFlagDesc)
			Set Data=Data_$lb(ASAScoreID,ASAScoreDesc,DataSource)
			Set Data=Data_$lb(PreoperWBC,CuteNumberID,CuteNumberDesc)
			Set Data=Data_$lb(EndoscopeFlagID,EndoscopeFlagDesc,ImplantFlagID,ImplantFlagDesc,PreoperAntiFlagID,PreoperAntiFlagDesc)
			Set Data=Data_$lb(BloodLossFlagID,BloodLossFlagDesc,BloodLoss,BloodTransFlagID,BloodTransFlagDesc,BloodTrans,PostoperComps,PostoperCompsDesc)
			
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	} Else {
		Set OrdsOperFlag=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("NINFInfOperDataSource","")
	 	Set OrdsOperFlag=+OrdsOperFlag
	 	If OrdsOperFlag=1 {        //取安贞手术申请信息
	 		//略    
	 	} ElseIf OrdsOperFlag=2 {  //取手术麻醉系统信息
	 		//手术排班表DHC_AN_OPArrange    ^DHCANOPArrange(0,"Adm",{OPA_Adm_dr},{OPA_RowId})
			//麻醉表OR_Anaesthesia          ^OR({PA_Adm.PAADM_RowID},"ANA",{ANA_Childsub})  
			//手术表OR_Anaest_Operation     ^OR({PA_Adm.PAADM_RowID},"ANA",{Childsub},"OP",{ANAOP_Childsub})
    		Set OperArr=0
    		For {
	    		Set OperArr=$o(^DHCANOPArrange(0,"Adm",+aEpisodeID,OperArr))
	    		Quit:OperArr=""
	    		
	    		Set OperStatus=$p($g(^DHCANOPArrange(OperArr)),"^",27)
	    		Continue:OperStatus="NotApp"
	    		Set AnaRowID=$p($g(^DHCANOPArrange(OperArr)),"^",2)
	    		Set Paadm=$p(AnaRowID,"||",1)
	    		Set AnaChild=$p(AnaRowID,"||",2)
	    		Continue:(AnaChild="")||(Paadm="")
	    		Set OperStartDate=$p($g(^DHCANOPArrange(OperArr)),"^",14)
	    		If OperStartDate'="" {
		    		;Set OperStartDate=$zd(OperStartDate,3)
		    		Set OperStartDate=##class(DHCMed.SSService.CommonCls).DateLogicalToHtml(OperStartDate)
		    		Set OperStartTime=$p($g(^DHCANOPArrange(OperArr)),"^",15)
	    			Set OperStartTime=$zt(+OperStartTime,2)
		    	} Else {
			    	Set OperStartTime=""
			    }
	    		Set OperEndDate=$p($g(^DHCANOPArrange(OperArr)),"^",16)
	    		If OperEndDate'="" {
		    		;Set OperEndDate=$zd(OperEndDate,3)
		    		Set OperEndDate=##class(DHCMed.SSService.CommonCls).DateLogicalToHtml(OperEndDate)
		    		Set OperEndTime=$p($g(^DHCANOPArrange(OperArr)),"^",17)
	    			Set OperEndTime=$zt(+OperEndTime,2)
		    	} Else {
			    	Set OperEndTime=""
			    }
			    
	    		Set OPChild=0
	    		For {
		    		Set OPChild=$o(^OR(Paadm,"ANA",AnaChild,"OP",OPChild))
		    		Quit:OPChild=""
		    		
		    		Set AnaOpRowID=Paadm_"||"_AnaChild_"||"_OPChild
		    		Set tmpOper=$g(^OR(Paadm,"ANA",AnaChild,"OP",OPChild))
		    		Continue:tmpOper=""
		    		
		    		Set (OperationID,OperationDesc,OperDocID,OperDocDesc)=""
					Set (OperationTypeID,OperationTypeDesc,AnesthesiaID,AnesthesiaDesc)=""
					Set (CuteTypeID,CuteTypeDesc,CuteHealingID,CuteHealingDesc)=""
					Set (CuteInfFlagID,CuteInfFlagDesc,OperInfTypeID,OperInfTypeDesc,InHospInfFlagID,InHospInfFlagDesc)=""
					Set (ASAScoreID,ASAScoreDesc,DataSource)=""
					Set (PreoperWBC,CuteNumberID,CuteNumberDesc)=""
					Set (EndoscopeFlagID,EndoscopeFlagDesc,ImplantFlagID,ImplantFlagDesc,PreoperAntiFlagID,PreoperAntiFlagDesc)=""
					Set (BloodLossFlagID,BloodLossFlagDesc,BloodLoss,BloodTransFlagID,BloodTransFlagDesc,BloodTrans,PostoperComps,PostoperCompsDesc)=""
					
					
					//update by zf 2012-01-13 手术麻醉系统,手术名称存的是描述,不是字典
		    		Set OperationID=$p(tmpOper,"^",6)
					If OperationID'="" {
						Set OperationDesc=$p($g(^ORC("OPER",OperationID)),"^",2)
		    		} Else {
			    		Set RemSubID=$o(^OR(Paadm,"ANA",AnaChild,"OP",OPChild,"REM",""),-1)
			    		Set:(+RemSubID)>0 OperationDesc=$g(^OR(Paadm,"ANA",AnaChild,"OP",OPChild,"REM",RemSubID))
					}
					
		    		Set OperDoc=$p(tmpOper,"^",8)
		    		Set tmpOperDocDesc=$p($g(^CTPCP(+OperDoc)),"^",2)
					Set:OperDoc'="" OperDoc=$o(^SSU("SSUSR",0,"CTPCP",OperDoc,0))
					Set objSSUser=##class(DHCMed.Base.SSUser).GetObjById(OperDoc)
					If $IsObject(objSSUser) {
						Set OperDocID=objSSUser.Rowid
						Set OperDocDesc=objSSUser.Name
					}
					Set:(OperDocDesc="")&&(tmpOperDocDesc'="") OperDocDesc="*"_tmpOperDocDesc
					
					Set AnesthesiaDesc=$p($g(^OR(Paadm,"ANA",AnaChild)),"^",5)
					Set:AnesthesiaDesc'="" AnesthesiaDesc=$p(^ORC("ANMET",+AnesthesiaDesc),"^",2)
					Set:$p(AnesthesiaDesc,"-",2)'="" AnesthesiaDesc=$p(AnesthesiaDesc,"-",2)
					If (AnesthesiaDesc'="") {
						Set AnesthesiaID=##Class(DHCMed.NINFService.Srv.CommonCls).GetDicIDByDesc("NINFInfAnesthesia",AnesthesiaDesc)
						Set:AnesthesiaID="" AnesthesiaDesc="*"_AnesthesiaDesc
					}
					
					//切口类型
					Set tmpCuteTypeDesc=""
					//Set tmpCuteTypeID=$p($g(^OR(Paadm,"ANA",AnaChild)),"^",28)
					Set tmpCuteTypeID=$p($g(^OR(Paadm,"ANA",AnaChild,"OP",OPChild)),"^",9) //切口类型 Modified By LiYang 2014-12-24 FixBug:2122 公共卫生事件-医院感染报告-医院感染报告/手术切口监测，手术提取中选择一条切口不空的手术，手术相关-编辑界面，切口类型显示空
					Set:tmpCuteTypeID'="" tmpCuteTypeDesc=$p($g(^ORC("BLDTP",tmpCuteTypeID)),"^",2)
					Set:(tmpCuteTypeDesc["清洁")&&(tmpCuteTypeDesc'["污染") CuteTypeDesc="1"
					Set:(tmpCuteTypeDesc["清洁")&&(tmpCuteTypeDesc["污染") CuteTypeDesc="2"
					Set:(tmpCuteTypeDesc'["清洁")&&(tmpCuteTypeDesc["污染") CuteTypeDesc="3"
					Set:tmpCuteTypeDesc="小" CuteTypeDesc="1"
					Set:tmpCuteTypeDesc="中" CuteTypeDesc="2"
					Set:tmpCuteTypeDesc="大" CuteTypeDesc="3"
					Set:tmpCuteTypeDesc="特大" CuteTypeDesc="3"
					Set:tmpCuteTypeDesc="Ⅰ" CuteTypeDesc="1"
					Set:tmpCuteTypeDesc="Ⅱ" CuteTypeDesc="2"
					Set:tmpCuteTypeDesc="Ⅲ" CuteTypeDesc="3"
					Set:tmpCuteTypeDesc="Ⅳ" CuteTypeDesc="4"
					//modify by mxp 20160427 提取手术切口等级ID 描述
					Set:tmpCuteTypeDesc["0" CuteTypeDesc="0"
					Set:tmpCuteTypeDesc["Ⅰ" CuteTypeDesc="1"
					Set:tmpCuteTypeDesc["Ⅱ" CuteTypeDesc="2"
					Set:tmpCuteTypeDesc["Ⅲ" CuteTypeDesc="3"
					Set:tmpCuteTypeDesc["Ⅳ" CuteTypeDesc="4"
					//add by likai 2012-12-19
					set:tmpCuteTypeDesc="" CuteTypeDesc="0"
					//Set CuteTypeID=##Class(DHCMed.NINFService.Srv.CommonCls).GetDicIDByDesc("NINFInfCuteType",CuteTypeDesc)
					Set CuteTypeID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(CuteTypeDesc,"NINFInfCuteType")
					If CuteTypeID="" {
						Set:tmpCuteTypeDesc'="" CuteTypeDesc="*"_tmpCuteTypeDesc
					}
					else {
						Set objCuteType=##class(DHCMed.SS.Dictionary).GetObjById(CuteTypeID)
						Set CuteTypeDesc=objCuteType.Description
					}
					
					//急诊 择期 损伤
					Set OperationType=$p($g(^OR(Paadm,"ANA",AnaChild)),"^",32)
					Set:OperationType="E" OperationTypeDesc="急诊"
					Set:OperationType="B" OperationTypeDesc="择期"
					Set OperationTypeID=##Class(DHCMed.NINFService.Srv.CommonCls).GetDicIDByDesc("NINFInfOperationType",OperationTypeDesc)
					
					Set DataSource="OPANA:"_AnaOpRowID
					
					Set Data=$lb("","")
					Set Data=Data_$lb(OperationID,OperationDesc,OperDocID,OperDocDesc)
					Set Data=Data_$lb(OperStartDate,OperStartTime,OperEndDate,OperEndTime)
					Set Data=Data_$lb(OperationTypeID,OperationTypeDesc,AnesthesiaID,AnesthesiaDesc)
					Set Data=Data_$lb(CuteTypeID,CuteTypeDesc,CuteHealingID,CuteHealingDesc)
					Set Data=Data_$lb(CuteInfFlagID,CuteInfFlagDesc,OperInfTypeID,OperInfTypeDesc,InHospInfFlagID,InHospInfFlagDesc)
					Set Data=Data_$lb(ASAScoreID,ASAScoreDesc,DataSource)
					Set Data=Data_$lb(PreoperWBC,CuteNumberID,CuteNumberDesc)
					Set Data=Data_$lb(EndoscopeFlagID,EndoscopeFlagDesc,ImplantFlagID,ImplantFlagDesc,PreoperAntiFlagID,PreoperAntiFlagDesc)
					Set Data=Data_$lb(BloodLossFlagID,BloodLossFlagDesc,BloodLoss,BloodTransFlagID,BloodTransFlagDesc,BloodTrans,PostoperComps,PostoperCompsDesc)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
		    	}
	    	}
	 	} ElseIf OrdsOperFlag=3 {  //取电子病历系统信息
	 		//略
		} ElseIf OrdsOperFlag=5{   //手术接口
		  ;^DHCMed.NINFSi("OperationInfo",0,"IndexOfEpisodeID"," 13956941",240)	
		  Set OperationID=0
		  For {
			  Set OperationID=$O(^DHCMed.NINFSi("OperationInfo",0,"IndexOfEpisodeID"," "_aEpisodeID,OperationID))
			  Quit:OperationID=""
			  
			  Set OperObj=##Class(DHCMed.NINF.Srv.OperationInfo).GetObjectByID(OperationID)
			  Continue:'$IsObject(OperObj)
			  
			  Set (OperationDesc,OperDocID,OperDocDesc)=""
			  Set (OperationTypeID,OperationTypeDesc,AnesthesiaID,AnesthesiaDesc)=""
			  Set (CuteTypeID,CuteTypeDesc,CuteHealingID,CuteHealingDesc)=""
			  Set (CuteInfFlagID,CuteInfFlagDesc,OperInfTypeID,OperInfTypeDesc,InHospInfFlagID,InHospInfFlagDesc)=""
			  Set (ASAScoreID,ASAScoreDesc,DataSource)=""
			  Set (PreoperWBC,CuteNumberID,CuteNumberDesc)=""
			  Set (EndoscopeFlagID,EndoscopeFlagDesc,ImplantFlagID,ImplantFlagDesc,PreoperAntiFlagID,PreoperAntiFlagDesc)=""
			  Set (BloodLossFlagID,BloodLossFlagDesc,BloodLoss,BloodTransFlagID,BloodTransFlagDesc,BloodTrans,PostoperComps,PostoperCompsDesc)=""
			  
			  Set OperationDesc=OperObj.OperationName
			  Set OperDocID=OperObj.OperatorCode
			  Set OperDocDesc=OperObj.OperatorName
			  Set:OperDocID="" OperDocDesc="*"_OperDocDesc
			  Set OperationType=OperObj.OperationType
			  Set:OperationType="E" OperationTypeDesc="急诊"
			  Set:(OperationType="B")||(OperationType="") OperationTypeDesc="择期"
			  Set:OperationType="I" OperationTypeDesc="损伤"
			  Set OperationTypeID=##Class(DHCMed.NINFService.Srv.CommonCls).GetDicIDByDesc("NINFInfOperationType",OperationTypeDesc)
			  Set:OperationTypeID="" OperationTypeDesc="*"_OperationTypeDesc
			  Set AnesthesiaDesc=OperObj.NarcosisModeDesc
			  Set:AnesthesiaDesc="" AnesthesiaDesc="无"
			  If AnesthesiaDesc'="" {
				Set objTmp=##class(DHCMed.NINF.Srv.MKDicMapping).GetMappingData("InfDicAnesthesia",AnesthesiaDesc)
				If $IsObject(objTmp) {
					Set AnesthesiaDesc=objTmp.TargetDesc
				}
			  }
			  Set AnesthesiaID=##Class(DHCMed.NINFService.Srv.CommonCls).GetDicIDByDesc("NINFInfAnesthesia",AnesthesiaDesc)
			  Set:AnesthesiaID="" AnesthesiaDesc="*"_AnesthesiaDesc
			  Set CuteTypeDesc=OperObj.CutGradeDesc
			  Set:CuteTypeDesc="" CuteTypeDesc="无"
			  Set CuteTypeID=##Class(DHCMed.NINFService.Srv.CommonCls).GetDicIDByDesc("NINFInfCuteType",CuteTypeDesc)
			  Set:CuteTypeID="" CuteTypeDesc="*"_CuteTypeDesc
			  Set CuteHealingID=""
			  Set CuteHealingDesc=""
			  Set CuteInfFlagID=""
              Set CuteInfFlagDesc=""
              Set OperInfTypeID=""
              Set OperInfTypeDesc=""
              Set InHospInfFlagID=""
              Set InHospInfFlagDesc=""
              ;Set OperStartDate=$zd(OperObj.StartDate,3)
              Set OperStartDate=##class(DHCMed.SSService.CommonCls).DateLogicalToHtml(OperObj.StartDate)
              Set OperStartTime=$zt(OperObj.StartTime,2)
              ;Set OperEndDate=$zd(OperObj.EndDate,3)
              Set OperEndDate=##class(DHCMed.SSService.CommonCls).DateLogicalToHtml(OperObj.EndDate)
              Set OperEndTime=$zt(OperObj.EndTime,2)
              Set ASAScoreDesc=OperObj.NarcosisFraction
	          Set:ASAScoreDesc["Ⅰ" ASAScoreDesc="P1"
	          Set:ASAScoreDesc["Ⅱ" ASAScoreDesc="P2"
	          Set:ASAScoreDesc["Ⅲ" ASAScoreDesc="P3"
	          Set:ASAScoreDesc["Ⅳ" ASAScoreDesc="P4"
	          Set:ASAScoreDesc["Ⅴ" ASAScoreDesc="P5"
	          Set:ASAScoreDesc["Ⅵ" ASAScoreDesc="P6"
	          Set ASAScoreID=##Class(DHCMed.NINFService.Srv.CommonCls).GetDicIDByDesc("NINFInfOperationType",ASAScoreDesc) 
	          Set:ASAScoreID="" ASAScoreDesc="*"_ASAScoreDesc
	          Set DataSource="OperationInterface:"_OperationID
	          Set NarcosisFractionDesc=""
	          Set PreoperWBC=OperObj.OperationWBC
	          Set CuteNumberID=""
	          Set CuteNumberDesc=""
	          
	          Set Data=$lb("","")
			  Set Data=Data_$lb(OperationID,OperationDesc,OperDocID,OperDocDesc)
			  Set Data=Data_$lb(OperStartDate,OperStartTime,OperEndDate,OperEndTime)
			  Set Data=Data_$lb(OperationTypeID,OperationTypeDesc,AnesthesiaID,AnesthesiaDesc)
			  Set Data=Data_$lb(CuteTypeID,CuteTypeDesc,CuteHealingID,CuteHealingDesc)
			  Set Data=Data_$lb(CuteInfFlagID,CuteInfFlagDesc,OperInfTypeID,OperInfTypeDesc,InHospInfFlagID,InHospInfFlagDesc)
			  Set Data=Data_$lb(ASAScoreID,ASAScoreDesc,DataSource)
			  Set Data=Data_$lb(PreoperWBC,CuteNumberID,CuteNumberDesc)
			  Set Data=Data_$lb(EndoscopeFlagID,EndoscopeFlagDesc,ImplantFlagID,ImplantFlagDesc,PreoperAntiFlagID,PreoperAntiFlagDesc)
			  Set Data=Data_$lb(BloodLossFlagID,BloodLossFlagDesc,BloodLoss,BloodTransFlagID,BloodTransFlagDesc,BloodTrans,PostoperComps,PostoperCompsDesc)
			  Set ^CacheTemp(repid,ind)=Data
			  Set ind=ind+1
		  }
		} Else {                   //取手术医嘱信息
			Set xOrdID=$o(^OEORD(0,"Adm",+aEpisodeID,""))
			Set xArcimID=""
			For {
				Set xArcimID=$o(^OEORDi(0,"ARCIM",+xOrdID,xArcimID))
				Quit:xArcimID=""
				
				Set objArcim=##class(DHCMed.Base.Arcim).GetObjById(xArcimID)
				Continue:'$IsObject(objArcim)
				
				Set ARCItmSubCatDesc=objArcim.ARCICDesc
				Set ARCItmCatDesc=objArcim.ORCATDesc
				Continue:ARCItmCatDesc'["手术"
				Continue:ARCItmSubCatDesc["其它手术"
				
				Set ArcimID=xArcimID
				Set ArcimDesc=objArcim.ARCIMDesc
				
				Set xOrdDate=0
				For {
					Set xOrdDate=$o(^OEORDi(0,"ARCIM",+xOrdID,xArcimID,xOrdDate))
					Quit:xOrdDate=""
					Set xSubID=0
					For {
						Set xSubID=$o(^OEORDi(0,"ARCIM",+xOrdID,xArcimID,xOrdDate,xSubID))
						Quit:xSubID=""
						
						Set OEItemID=xOrdID_"||"_xSubID
						Set objOEItem=##class(DHCMed.Base.OrdItem).GetObjById(OEItemID)
						Continue:'$IsObject(objOEItem)
						
						Set StatusCode=objOEItem.OSTATCode
						Continue:(StatusCode="D")||(StatusCode="S")
						
						Set (OperationID,OperationDesc,OperDocID,OperDocDesc)=""
						Set (OperStartDate,OperStartTime,OperEndDate,OperEndTime)=""
						Set (OperationTypeID,OperationTypeDesc,AnesthesiaID,AnesthesiaDesc)=""
						Set (CuteTypeID,CuteTypeDesc,CuteHealingID,CuteHealingDesc)=""
						Set (CuteInfFlagID,CuteInfFlagDesc,OperInfTypeID,OperInfTypeDesc,InHospInfFlagID,InHospInfFlagDesc)=""
						Set (ASAScoreID,ASAScoreDesc,DataSource)=""
						Set (PreoperWBC,CuteNumberID,CuteNumberDesc)=""
						Set (EndoscopeFlagID,EndoscopeFlagDesc,ImplantFlagID,ImplantFlagDesc,PreoperAntiFlagID,PreoperAntiFlagDesc)=""
						Set (BloodLossFlagID,BloodLossFlagDesc,BloodLoss,BloodTransFlagID,BloodTransFlagDesc,BloodTrans,PostoperComps,PostoperCompsDesc)=""
						
						Set OperationDesc=ArcimDesc
						Set OperDoc=objOEItem.OEORIDoctorDR
						Set:OperDoc'="" OperDoc=$o(^SSU("SSUSR",0,"CTPCP",OperDoc,0))
						Set objSSUser=##class(DHCMed.Base.SSUser).GetObjById(OperDoc)
						If $IsObject(objSSUser) {
							Set OperDocID=objSSUser.Rowid
							Set OperDocDesc=objSSUser.Name
						}
						
					 	Set OEStartDate=objOEItem.OEORISttDat
					 	Set OperStartDate=OEStartDate
					 	If (OperStartDate'="") {
						 	;Set OperStartDate=$zd(+OperStartDate,3)
						 	Set OperStartDate=##class(DHCMed.SSService.CommonCls).DateLogicalToHtml(+OperStartDate)
						 	Set OperStartTime=$zt(0,2)
						} Else {
							Set OperStartTime=""
						}
					 	Set OperEndDate=OperStartDate
					 	Set OperEndTime=OperStartTime
					 	
					 	Set DataSource="OEITEM:"_OEItemID
					 	
					 	Set Data=$lb("","")
						Set Data=Data_$lb(OperationID,OperationDesc,OperDocID,OperDocDesc)
						Set Data=Data_$lb(OperStartDate,OperStartTime,OperEndDate,OperEndTime)
						Set Data=Data_$lb(OperationTypeID,OperationTypeDesc,AnesthesiaID,AnesthesiaDesc)
						Set Data=Data_$lb(CuteTypeID,CuteTypeDesc,CuteHealingID,CuteHealingDesc)
						Set Data=Data_$lb(CuteInfFlagID,CuteInfFlagDesc,OperInfTypeID,OperInfTypeDesc,InHospInfFlagID,InHospInfFlagDesc)
						Set Data=Data_$lb(ASAScoreID,ASAScoreDesc,DataSource)
						Set Data=Data_$lb(PreoperWBC,CuteNumberID,CuteNumberDesc)
						Set Data=Data_$lb(EndoscopeFlagID,EndoscopeFlagDesc,ImplantFlagID,ImplantFlagDesc,PreoperAntiFlagID,PreoperAntiFlagDesc)
						Set Data=Data_$lb(BloodLossFlagID,BloodLossFlagDesc,BloodLoss,BloodTransFlagID,BloodTransFlagDesc,BloodTrans,PostoperComps,PostoperCompsDesc)
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
			}
		}
	}
	Quit $$$OK
}

ClassMethod QrySubRecClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySubRecExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QrySubRecFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySubRecExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If (ind="")||($isvalidnum(ind)=0) {				// if there are no more rows, finish fetching
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

/// Creator：     zhufei
/// CreatDate：   2012-08-10
/// Description:  检查是否手术患者
/// Table：       
/// Input：       aEpisodeID  就诊号
/// Return：      return<=0:否  return>0:是
/// w ##class(DHCMed.NINFService.Rep.InfReportOpr).IsCheckOpr("47235")
ClassMethod IsCheckOpr(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=0,Count=0
	Quit:aEpisodeID="" return
	
	Set rs=##Class(%ResultSet).%New("DHCMed.NINFService.Rep.InfReportOpr:QrySubRec")
	Do rs.Execute("",aEpisodeID)
	While (rs.Next()){
		Set Count=Count+1
	}
	Do rs.Close()
	
	Set return=Count
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-10-18
/// Description:  检查是否入住ICU(ICU和重症监护可是都属于ICU可是)
/// Table：       
/// Input：       aEpisodeID  就诊号
/// Return：      return<=0:否  return>0:是
/// w ##class(DHCMed.NINFService.Rep.InfReportOpr).IsCheckICU(19677683)
ClassMethod IsCheckICU(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=0
	Quit:aEpisodeID="" return
	
	Set TransID=0,CPWLocID="",CPWLoc=""
	For {
		Set TransID=$o(^PAADM(aEpisodeID,"TRANS",TransID))
		Quit:TransID=""
		
		Set CPWLocID=$p($g(^PAADM(aEpisodeID,"TRANS",TransID)),"^",6)
		Set CPWLoc=$p($g(^CTLOC(+CPWLocID)),"^",2)
		Set:$p(CPWLoc,"-",2)'="" CPWLoc=$p(CPWLoc,"-",2)
		Continue:CPWLoc=""
		
		Set:($zcvt(CPWLoc,"U")["ICU")||($zcvt(CPWLoc,"U")["CCU")||($zcvt(CPWLoc,"U")["重症") return=1
	}
	
	Quit return
}

}
