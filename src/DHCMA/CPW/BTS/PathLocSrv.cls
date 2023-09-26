/// 名称: DHCMA.CPW.BTS.PathAdmitSrv
/// 描述: 维护 服务类
/// 编写者：chenjb
/// 编写日期: 2018-09-15
Class DHCMA.CPW.BTS.PathLocSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// //modify:     修改pathentity->pathmast by liuzhenhe 2015/11/14
/// Creator：     chenjb
/// CreatDate：   2018-09-15
/// Description:  查询临床路径字典
/// Table：       DHCMA.CPW.BT.PathMast
/// Input：       
/// output: 
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.PathLocSrv","QryPathMast","","02","2!!1","1","I")
Query QryPathMast(aTypeDr As %String = "", aKeyWord As %String = "", aHospID As %String = "", aIsQryCompl As %String = 0, aAdmType As %String = "", aFlag As %String = "") As %Query(ROWSPEC = "BTID:%String,BTCode:%String,BTDesc:%String,BTTypeID:%String,BTTypeDesc:%String,BTIsActive:%Boolean,BTActDate:%Date,BTActTime:%Time,BTActUserID:%String,BTAdmType:%String,BTAdmTypeDesc:%String,PathComplID:%String,PathComplDesc:%String")
{
}

ClassMethod QryPathMastExecute(ByRef qHandle As %Binary, aTypeDr As %String = "", aKeyWord As %String = "", aHospID As %String = "", aIsQryCompl As %String = 0, aAdmType As %String = "", aFlag As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1

 	Set xID=""
 	For {
	 	Set xID = $o(^DHCMA.CPW.BT.PathMastD(xID))
	 	Quit:xID=""

	 	Set obj = ##class(DHCMA.CPW.BT.PathMast).GetObjById(xID)
		Continue:'$IsObject(obj)
		//院区权限过滤
		Set flgChkHosp = ##class(DHCMA.CPW.BTS.PathFormSrv).CheckPathHospOID(xID,aHospID)
	 	Continue:'flgChkHosp
		
	 	Set Code = obj.BTCode
	 	Set Desc = obj.BTDesc
	 	Set TypeID="",TypeDr=""
	 	If $IsObject(obj.BTTypeDr) {
			Set TypeID  =obj.BTTypeDr.%Id()
	 		Set TypeDesc=obj.BTTypeDr.BTDesc
		}
		Continue:(aTypeDr'="")&(aTypeDr'=TypeID)
		Continue:(aKeyWord'="")&(Desc'[aKeyWord)
		Continue:(aFlag=1)&&(obj.BTIsActive=0)
	 	Set IsActiveDesc = $s(obj.BTIsActive=1:"是",1:"否")
	 	
	 	Set ActDate         = $ZD(obj.BTActDate,3)
	 	Set ActTime        	= $Zt(obj.BTActTime)  //,2)这个2会去掉秒的显示
	 	Set ActUserID       = obj.BTActUserID      
	 	Set AdmType 		= obj.BTAdmType
	 	Set AdmTypeDesc		= $s(AdmType="I":"住院",AdmType="O":"门诊",1:"")
	 	Continue:(aAdmType'="")&&(aAdmType'[AdmType)
	 	Set PathComplID="",PathComplDesc=""
	 	If $IsObject(obj.BTPathComplDr){
		 	Set PathComplID=obj.BTPathComplDr.%Id()
		 	Set PathComplDesc=obj.BTPathComplDr.BTDesc
		}
		If aIsQryCompl=1{		//查询合并症路径，则只返回合并症路径
			Continue:obj.BTTypeDr.BTDesc'="合并症"
		}ElseIf aIsQryCompl=0{	//检查普通路径,则过滤合并症
			Continue:obj.BTTypeDr.BTDesc="合并症"
		}ElseIf aIsQryCompl = 2{
			// 折中处理合并症，如果合并症已有科室关联，则不返回；未被关联则返回
			If obj.BTTypeDr.BTDesc="合并症"{
				Set retChk = ..ChkIsLinkedByPath(xID)
				Continue:+retChk=1	
			}
		}
	 	
		Set Data=$lb(xID,Code,Desc,TypeID,TypeDesc,IsActiveDesc,ActDate,ActTime,ActUserID,AdmType,AdmTypeDesc,PathComplID,PathComplDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryPathMastClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathMastExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathMastFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathMastExecute ]
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

/// Creator：     chenjb
/// CreatDate：   2018-09-15
/// Description:  查询临床路径字典
/// Table：       DHCMA.CPW.BT.PathMast
/// Input：       
/// output: 
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.PathLocSrv","QryPathByLoc","9!!1")
Query QryPathByLoc(aLocDr As %String = "") As %Query(ROWSPEC = "BTID:%String,MastID:%String,BTCode:%String,BTDesc:%String,BTTypeID:%String,BTTypeDesc:%String,BTIsActive:%Boolean,BTActDate:%Date,BTActTime:%Time,BTActUserID:%String,BTAdmType:%String,BTAdmTypeDesc:%String")
{
}

ClassMethod QryPathByLocExecute(ByRef qHandle As %Binary, aLocDr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	Quit:aLocDr="" $$$OK
 	Set xPathDr=""
 	For {
	 	Set xPathDr = $o(^DHCMA.CPW.BT.PathLocI("IdxofLocPath"," "_$zcvt(aLocDr,"U"),xPathDr))
	 	Quit:xPathDr=""

		Set xID = $o(^DHCMA.CPW.BT.PathLocI("IdxofLocPath"," "_$zcvt(aLocDr,"U"),xPathDr,0))
		Set objLoc = ##class(DHCMA.CPW.BT.PathLoc).GetObjById(xID)
		Continue:'$Isobject(objLoc)
	 	Set obj = ##class(DHCMA.CPW.BT.PathMast).GetObjById(xPathDr)
		Continue:'$IsObject(obj)
	 	Set Code = obj.BTCode
	 	Set Desc = obj.BTDesc
	 	Set TypeID="",TypeDr=""
	 	If $IsObject(obj.BTTypeDr) {  //这儿是为下拉框做准备
			Set TypeID  =obj.BTTypeDr.%Id()
	 		Set TypeDesc=obj.BTTypeDr.BTDesc
		}
	 	Set IsActiveDesc = $s(obj.BTIsActive=1:"是",1:"否")
	 	Set ActDate         = $ZD(obj.BTActDate,3)
	 	Set ActTime        = $Zt(obj.BTActTime)  //,2)这个2会去掉秒的显示
	 	Set ActUserID        = obj.BTActUserID      
	 	Set AdmType        = obj.BTAdmType
	 	Set AdmTypeDesc		= $s(AdmType="I":"住院",AdmType="O":"门诊",1:"")
	 	
		Set Data=$lb(xID,xPathDr,Code,Desc,TypeID,TypeDesc,IsActiveDesc,ActDate,ActTime,ActUserID,AdmType,AdmTypeDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryPathByLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathByLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathByLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathByLocExecute ]
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

/// Creator：     jiangpengpeng
/// CreatDate：   2019-12-13
/// Description:  查询临床路径字典
/// Table：       DHCMA.CPW.BT.PathMast
/// Input：       
/// output: 
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.PathLocSrv","QryPathByLocDesc","","乳腺","4216!!1","2!!1")
Query QryPathByLocDesc(aLocID As %String = "", aDesc As %String = "", aEpisodeID As %String = "", aHospID As %String = "") As %Query(ROWSPEC = "ind:%String,MastID:%String,MastDesc:%String,TmpDesc:%String")
{
}

ClassMethod QryPathByLocDescExecute(ByRef qHandle As %Binary, aLocID As %String = "", aDesc As %String = "", aEpisodeID As %String = "", aHospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
	
	Quit:(aLocID="")&&(aDesc="") $$$OK
	Set DiagsInfo="",AdmType=""
	Set:aEpisodeID'="" DiagsInfo=..GetDiagsInfo(aEpisodeID)
	Set:aEpisodeID'="" AdmType=$p($g(^PAADM($p(aEpisodeID,"!!",1))),"^",2) 
	
	Set IsCheckDiag=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWShowLocCPWListByDiag",aHospID)
	If aLocID'=""{
		Set xLocID=""
		For {
			Set xLocID=$o(^DHCMA.CPW.BT.PathLocI("IdxofLocPath",xLocID))
			Quit:xLocID=""
			Continue:aLocID'=$tr(xLocID," ")
			
			Set HospID=$p($g(^CTLOC($p($tr(xLocID," "),"!!",1))),"^",22)
	 		Continue:($p(aHospID,"!!",1)'="")&&($p(aHospID,"!!",1)'=HospID)
			
			Set LocDesc=""
			Set objLoc=##class(DHCMA.Util.EP.Location).GetObjByOID($tr(xLocID," "))
			Set:$IsObject(objLoc) LocDesc=objLoc.BTDesc
			Set:LocDesc'="" LocDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.CTLoc","CTLOCDesc",LocDesc,Languages)
			Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
		
			Set xPathID=""
			For {
				Set xPathID=$o(^DHCMA.CPW.BT.PathLocI("IdxofLocPath",xLocID,xPathID))
				Quit:xPathID=""
				
				Set xID=$o(^DHCMA.CPW.BT.PathLocI("IdxofLocPath",xLocID,xPathID,""))
				Set objPathLoc = ##class(DHCMA.CPW.BT.PathLoc).GetObjById(xID)
				Continue:'$Isobject(objPathLoc)
				Continue:'$IsObject(objPathLoc.PDPathDr)
				Continue:'objPathLoc.PDIsActive
				Continue:'objPathLoc.PDPathDr.BTIsActive
				
				Set PathDesc=objPathLoc.PDPathDr.BTDesc
				Set:PathDesc'="" PathDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathMast","BTDesc",PathDesc,LangID)
				Continue:(aDesc'="")&&(PathDesc'[aDesc)&&(LocDesc'[aDesc)
				Continue:(AdmType'="")&&(AdmType'=objPathLoc.PDPathDr.BTAdmType)
				
				If ((IsCheckDiag=1)||(IsCheckDiag="Y"))&&(DiagsInfo'="")&&(aEpisodeID'="") {
					Set IsMatched=..CheckIsMatched(xPathID,DiagsInfo,aHospID,1)
					Continue:IsMatched'=1
				}
				
				Set Data=$lb(ind,xPathID,PathDesc,LocDesc)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}	
	}Else{
		Set xPathID=""
		For {
			Set xPathID=$o(^DHCMA.CPW.BT.PathMastD(xPathID))
			Quit:xPathID=""
			
			Set objPathMast=##class(DHCMA.CPW.BT.PathMast).GetObjById(xPathID)
			Continue:'$IsObject(objPathMast)
			Continue:'objPathMast.BTIsActive
			Continue:'$IsObject(objPathMast.BTTypeDr)
			//Set TypeCode=objPathMast.BTCode
			Set TypeDesc=objPathMast.BTTypeDr.BTDesc
			Continue:TypeDesc="合并症"
			Set:TypeDesc'="" TypeDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathType","BTDesc",TypeDesc,LangID)
			
			//院区权限过滤
			Set flgChkHosp = ##class(DHCMA.CPW.BTS.PathFormSrv).CheckPathHospOID(xPathID,aHospID)
	 		Continue:'flgChkHosp
			
			//发布状态检查
			Set chkOpen=##class(DHCMA.CPW.BTS.PathFormSrv).GetFormByMast(xPathID,1)
			Continue:chkOpen=""
			
			Set PathDesc=objPathMast.BTDesc
			Set:PathDesc'="" PathDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathMast","BTDesc",PathDesc,LangID)
			Continue:(aDesc'="")&&(PathDesc'[aDesc)&&(TypeDesc'[aDesc)
			Continue:(AdmType'="")&&(AdmType'=objPathMast.BTAdmType)
			
			If ((IsCheckDiag=1)||(IsCheckDiag="Y"))&&(DiagsInfo'="")&&(aEpisodeID'="") {
				Set IsMatched=..CheckIsMatched(xPathID,DiagsInfo,aHospID,1)
				Continue:IsMatched'=1
			}
			
			Set Data=$lb(ind,xPathID,PathDesc,TypeDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
			
		}		
	}
	
	Quit $$$OK
}

ClassMethod QryPathByLocDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathByLocDescExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathByLocDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathByLocDescExecute ]
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

/// Creator:		yankai
/// CreateDate:		2020-12-14
/// Description:	获取本次就诊诊断信息
/// Input:			aEpisode As %String
/// Return:			DiagsList As %List
/// Debug:			w ##class(DHCMA.CPW.BTS.PathLocSrv).GetDiagsInfo(57)
ClassMethod GetDiagsInfo(aEpisodeID As %String) As %List
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
 	Set:aEpisodeID["!!" aEpisodeID=$p(aEpisodeID,"!!",1) 
 	Set MRAdm=$p($g(^PAADM(+aEpisodeID)),"^",61)
	Quit:MRAdm="" return
	
	Set xDiagID=0,DiagsList=""
	For {
		Set xDiagID=$o(^MR(MRAdm,"DIA",xDiagID))
		Quit:xDiagID=""
		
		Set tmpDiagnos=$g(^MR(MRAdm,"DIA",xDiagID))
		//Set DiaDate=$p(tmpDiagnos,"^",7)
		//Continue:DiaDate'=+$h												//只检查当天下的诊断
		
		Set ICDDxID=$p(tmpDiagnos,"^",1)
		Set ICD10=$p($g(^MRC("ID",+ICDDxID)),"^",4)							//ICD10代码
		Set ICDDesc=$tr($p($g(^MRC("ID",+ICDDxID)),"^",2)," ","")			//ICD诊断描述
		Set DesID=$o(^MR(MRAdm,"DIA",xDiagID,"DES",0))
		Set:DesID="" DesID=1
		Set ICDDHC=$g(^MR(MRAdm,"DIA",xDiagID,"DHC",DesID))					//???
		Set ICDDES=$g(^MR(MRAdm,"DIA",xDiagID,"DES",DesID))					//诊断备注
		
		Set MRDiagType=$o(^MR(MRAdm,"DIA",xDiagID,"TYP",0))
		Set TypeDesc=""
		If MRDiagType'="" {
			Set TypeDicID=$g(^MR(MRAdm,"DIA",xDiagID,"TYP",MRDiagType))
			Set TypeDesc=$p($g(^MRC("DTYP",+TypeDicID)),"^",2) 				//诊断类型
		}
		
		Set:ICDDES'="" ICDDesc=ICDDesc_" "_ICDDES
		Set:ICDDHC'="" ICDDesc=ICDDesc_" "_ICDDHC
		Set DiagPrefix=$p($g(^MR(MRAdm,"DIA",xDiagID,1)),"^",26)    		//诊断前缀
		Set:DiagPrefix'="" ICDDesc=DiagPrefix_" "_ICDDesc
		Set IsMainDiag=$p($g(^MR(MRAdm,"DIA",xDiagID,1)),"^",20)			//是否主诊断
		
		Set DiagInfo=ICD10_$c(1)_ICDDesc_$c(1)_TypeDesc_$c(1)_IsMainDiag
		Set DiagsList=DiagsList_$lb(DiagInfo)
	}
	Set:DiagsList'="" return=DiagsList
	Quit return
}

/// Creator:		yankai
/// CreateDate:		2020-12-14
/// Description:	检查某路径是否匹配当前就诊诊断
/// Input:			aPathMastID As %String, aDiagInfo As %List
/// 				aMatchType：匹配类型（1：入径规则匹配；2：不考虑诊断类型，仅匹配诊断）
/// Return:			1|0|""
/// w ##class(DHCMA.CPW.BTS.PathLocSrv).CheckIsMatched(2,)
ClassMethod CheckIsMatched(aPathMastID As %String, aDiagInfo As %List, aAdmHospID As %String, aMatchType As %String = 1) As %String
{
	New (aPathMastID,aDiagInfo,aAdmHospID,aMatchType)
	Set return=0
	Quit:(aPathMastID="")||(aDiagInfo="") return
	
	Set IsOnlyChkMainDiag=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWIsOnlyCheckMainDiag",aAdmHospID)		//获取配置，是否只检查患者主诊断
	Set IsIgnoreDISDiag=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWIsIgnoreDISDiag",aAdmHospID)			//获取配置，是否忽略出院诊断
	
	For i=1:1:$ll(aDiagInfo){
		Quit:return=1
		Set xICD10 = $p($li(aDiagInfo,i),$c(1),1)
		Set xICDDesc = $p($li(aDiagInfo,i),$c(1),2)
		Set xDiagType = $p($li(aDiagInfo,i),$c(1),3)
		Set xIsMain = $p($li(aDiagInfo,i),$c(1),4)
		
		If (aMatchType=1)&&(xDiagType'=""){				//按入径规则匹配
			Continue:(IsOnlyChkMainDiag="Y")&&(xIsMain'="Y")								//只检查主诊断，则其他诊断过滤
			Continue:(IsIgnoreDISDiag="Y")&&(xDiagType="出院诊断")							//过滤出院诊断，不检查出院诊断是否符合入径
			Set objDic=##class(DHCMA.Util.BT.Dictionary).GetObjByPCodeItemDesc("CPWAdmDiagType",xDiagType)
			Continue:(IsOnlyChkMainDiag'="Y")&&($IsObject(objDic))&&('objDic.BTIsActive)	//诊断类型存在且无效，退出
		}
		
		Set xTypeID=""
 		For {
 			Set xTypeID=$o(^DHCMA.CPW.BT.PathAdmitI("IdxofPathType",aPathMastID,xTypeID))
 			Quit:xTypeID=""
 			Quit:return=1
 			
 			Set xID=""
 			For {
	 			Set xID=$o(^DHCMA.CPW.BT.PathAdmitI("IdxofPathType",aPathMastID,xTypeID,xID))
 				Quit:xID=""
 				Quit:return=1
 				
 				Set obj = ##class(DHCMA.CPW.BT.PathAdmit).GetObjById(xID)
		 		Continue:'$IsObject(obj)
		 		Set IsActive=obj.BTIsActive
		 		Continue:IsActive=0
		 		Continue:'$IsObject(obj.BTPathDr)
		 		Continue:'obj.BTPathDr.BTIsActive
				
		 		If (aMatchType=1)&&(xDiagType'="") {
		 			Set TypeDesc=obj.BTTypeDr.BTDesc							//入径标准的诊断类型
		 			Continue:($IsObject(objDic))&&(xDiagType'=TypeDesc)		//过滤诊断类型存在且不匹配的
		 		}
		 		
		 		Set ICD10 =obj.BTICD10
			 	Set ICDKeys = obj.BTICDKeys
			 	Set OperICD = obj.BTOperICD
			 	Set OperKeys = obj.BTOperKeys
			 	Set IsICDAcc = obj.BTIsICDAcc									//中西医诊断组合符合
			 	Set IsOperAcc = obj.BTIsOperAcc									//诊断手术组合符合

			 	Set retICD=##Class(DHCMA.CPW.CPS.InterfaceSrv).CheckICDArea(xICD10,ICD10)
			 	Set retKey=##Class(DHCMA.CPW.CPS.InterfaceSrv).CheckKeyArea(xICDDesc,ICDKeys)
			 	
			 	Set:(retICD=1)||(retKey=1) return=1
			 	//w xDiagType_" "_xICDDesc_" "_ICD10_" "_ICDKeys_" "_aPathMastID_" "_return,!
 			}
 		}
	}
	
	Quit return
}

/// Creator:		yankai
/// CreateDate:		2023-02-27
/// Description:	检查某路径/合并症是否被关联
/// Input:			aPathID As %String 
/// Return:			已被关联：1^关联科室ID1,关联科室ID2……
/// 				未被关联：0^
/// w ##class(DHCMA.CPW.BTS.PathLocSrv).ChkIsLinkedByPath(5)
ClassMethod ChkIsLinkedByPath(aPathID As %String) As %String
{
	New (aPathID)
	Set return = ""
	Quit:aPathID="" return
	
	Set xLocID = "",isLinked = 0, strLocIDs = ""
	For {
		Set xLocID = $o(^DHCMA.CPW.BT.PathLocI("IdxofLocPath",xLocID))
		Quit:xLocID=""
		
		Continue:'$d(^DHCMA.CPW.BT.PathLocI("IdxofLocPath",xLocID,aPathID))
		Set isLinked = 1
		Set strLocIDs = strLocIDs_","_$tr(xLocID," ")	
	}
	Set:strLocIDs'="" strLocIDs = $e(strLocIDs,2,$l(strLocIDs))
	Set return = isLinked_"^"_strLocIDs
	Quit return
}

}
