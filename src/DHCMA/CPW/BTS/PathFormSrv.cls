/// 名称: DHCMA.CPW.BTS.PathFormSrv
/// 描述: 路径表单维护 服务类
/// 编写者：chenjb
/// 编写日期: 2018-08-28
Class DHCMA.CPW.BTS.PathFormSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 处理科室、常用临床路径、版本的三级查询
/// d ##Class(%ResultSet).RunQuery("DHCMA.CPW.BTS.PathFormSrv","QryLocPathVer","10-Path-18-Type","","","2!!1","","","1")
Query QryLocPathVer(argNodeID As %String, argLocID As %String = "", argAdmType As %String = "", argHospID As %String = "", argDesc As %String = "", argKeyWords As %String = "", argPathVer As %String = "-1") As %Query(ROWSPEC = "id:%String,text:%String,iconCls:%String,checked:%String,state:%String,attributes:%String")
{
}

ClassMethod QryLocPathVerExecute(ByRef qHandle As %Binary, argNodeID As %String, argLocID As %String = "", argAdmType As %String = "", argHospID As %String = "", argDesc As %String = "", argKeyWords As %String = "", argPathVer As %String = "-1") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	//Set ^TEMPYK("QryLocPathVer")=$LB(argNodeID,argLocID,argAdmType,argHospID,argDesc,argKeyWords,argPathVer)
	
	Set QryType=$p(argNodeID,"-",2)
	If QryType="root" {  //查询临床路径类别
		//临床路径版本树的结构改为：类别-临床路径字典-版本
		Set ZIndex=$zn,JIndex=$j
		Kill ^TMP(ZIndex,JIndex,"QryLocPathVerTMP")
		
		Set CPWDicID=0
		For {
			Set CPWDicID=$o(^DHCMA.CPW.BT.PathMastD(CPWDicID))
			Quit:CPWDicID=""
			Set objCPWDic=##class(DHCMA.CPW.BT.PathMast).GetObjById(CPWDicID)
			Continue:'$IsObject(objCPWDic)
			Continue:'$IsObject(objCPWDic.BTTypeDr)
			Continue:(argAdmType'="")&&(objCPWDic.BTAdmType'[argAdmType)		//路径适用就诊类型过滤
			Continue:(argKeyWords'["NotActive")&&(objCPWDic.BTIsActive=0) //临床路径维护--基础字典维护-路径字典维护-路径修改为不生效后,科室路径维护没有及时刷新 临床路径类别列表中显示的是ID，不是版本号
			Set CPWDicTypeID=objCPWDic.BTTypeDr.%Id()
			Continue:CPWDicTypeID=""
			Continue:(argDesc'="")&&(objCPWDic.BTDesc'[argDesc)
			Set flag=..CheckFormIC(CPWDicID)
			Continue:flag=0	//过滤web页面未完成表单
			
			// 路径特征过滤
			Set retFilter=..ChkCPWByKeyIDs(argKeyWords,CPWDicID,argPathVer)
			Continue:retFilter'=1
			
			//按关联医院过滤
			Set IsHosp=..CheckPathHospOID(CPWDicID,argHospID)
			Continue:'IsHosp
			
			//管理员或者在常用临床路径列表中
			If argLocID=0 {
				Set ^TMP(ZIndex,JIndex,"QryLocPathVerTMP",CPWDicTypeID,CPWDicID)=""
			}Else{
				Set LPID=$o(^DHCMA.CPW.BT.PathLocI("IdxofLocPath"," "_argLocID,CPWDicID,""))
				Continue:LPID<1		//过滤没有跟科室关联的路径
				
				Set ^TMP(ZIndex,JIndex,"QryLocPathVerTMP",CPWDicTypeID,CPWDicID)=""
			}
		}
		Set TypeID=""
		For {
			Set TypeID=$o(^TMP(ZIndex,JIndex,"QryLocPathVerTMP",TypeID))
			Quit:TypeID=""
			Set objCPWDicType=##class(DHCMA.CPW.BT.PathType).GetObjById(TypeID)
			Continue:'$IsObject(objCPWDicType)
			Set Desc=objCPWDicType.BTDesc
			Set NodeID=TypeID_"-Type"
			Set iconCls=""
			Set check="false"
			Set state="closed"
			Set attributes =""
			Set Data=$lb(NodeID,Desc,iconCls,check,state,attributes)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
		Kill ^TMP(ZIndex,JIndex,"QryLocPathVerTMP")
	}
	
	If QryType="Type" {   //查询科室路径
		Set LocID=argLocID
		Set TypeID=+argNodeID
		Set CPWID=""
		For {
			Set CPWID=$o(^DHCMA.CPW.BT.PathMastD(CPWID))
			Quit:CPWID=""
			
			Set objCPW=##class(DHCMA.CPW.BT.PathMast).GetObjById(CPWID)
			Continue:'$IsObject(objCPW)
			Continue:'$IsObject(objCPW.BTTypeDr)
			Set CPWDTypeID=objCPW.BTTypeDr.%Id()
			Continue:CPWDTypeID'=TypeID
			Continue:(argKeyWords'["NotActive")&&(objCPW.BTIsActive=0)
			Continue:(argAdmType'="")&&(objCPW.BTAdmType'[argAdmType)		//路径适用就诊类型过滤
			Continue:(argDesc'="")&&(objCPW.BTDesc'[argDesc)
			Set flag=..CheckFormIC(CPWID)
			Continue:flag=0 	//过滤web页面未完成表单
			
			// 路径特征过滤
			Set retFilter=..ChkCPWByKeyIDs(argKeyWords,CPWID,argPathVer)
			Continue:retFilter'=1
			
			//走科室关联路径参数过滤
			If (LocID'="")&&(LocID'=0) {
				Continue:'$d(^DHCMA.CPW.BT.PathLocI("IdxofLocPath"," "_LocID,CPWID))
				Set PathLocID=$o(^DHCMA.CPW.BT.PathLocI("IdxofLocPath"," "_LocID,CPWID,""))
				Set objPathLoc=##class(DHCMA.CPW.BT.PathLoc).GetObjById(PathLocID)
				
				Continue:'$IsObject(objPathLoc)
				Continue:'objPathLoc.PDIsActive
			}
			
			//按关联医院过滤
			Set IsHosp=..CheckPathHospOID(CPWID,argHospID)
			Continue:'IsHosp
			
			//Set NodeID=CPWID_"-Path"_"-"_LocID_"-Type"
			Set NodeID=CPWID_"-Path"_"-"_CPWDTypeID_"-Type"			
			Set Desc=objCPW.BTDesc
			Set iconCls=""
			Set check="false"
			Set state="closed"
			Set attributes =""
			Set Data=$lb(NodeID,Desc,iconCls,check,state,attributes)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	If QryType="Path" {    //查询临床路径版本
		
		//Set PathKeyIDs=$p(argKeyWords,"^",1)													  //路径特征
		Set FormKeyIDs = $e(argKeyWords,$l($p(argKeyWords,"^",1))+1+1,$l(argKeyWords))			// 版本特征
		Set CPWDicID=$p(argNodeID,"-",1)
		
		Set objCPWDic=##class(DHCMA.CPW.BT.PathMast).GetObjById(CPWDicID)
		Quit:'$IsObject(objCPWDic) $$$OK
		If argPathVer="-1"{			// -1时查询全部版本
			Set VerNum=0
			For {
				Set VerNum=$o(^DHCMA.CPW.BT.PathFormI("IdxofVersion",CPWDicID,VerNum))
				Quit:VerNum=""
				
				Set FormID=0
				For {
					Set FormID=$o(^DHCMA.CPW.BT.PathFormI("IdxofVersion",CPWDicID,VerNum,FormID))
					Quit:FormID=""			
					
					Set retFilter = ..FilterVerKeyIDs(FormID,FormKeyIDs)
					Continue:retFilter'=1
					Do GetLocPathVerInfo(FormID)
				}
			}	
		}
		Else{
			Set IsFormActive=1
			Set:argPathVer="2" IsFormActive=""									//只有查询的版本状态含作废时，才支持返回作废状态的版本
			Set FormStr=##class(DHCMA.CPW.BTS.PathFormSrv).GetFormByMast(CPWDicID,argPathVer,IsFormActive)		//FormID_"^"_Version
			Set FormID=$p(FormStr,"^",1)
			
			Set retFilter = ..FilterVerKeyIDs(FormID,FormKeyIDs)
			Quit:retFilter'=1 $$$OK
			Do GetLocPathVerInfo(FormID)
		}
	}
	Quit $$$OK
	
GetLocPathVerInfo(aFormID)
	Set (IsActive,DateFrom,DateTo,FormVerDate,FormVerTime)=""
	Set objVersion=##class(DHCMA.CPW.BT.PathForm).GetObjById(aFormID)
	If $IsObject(objVersion){
		Set Version=+objVersion.FormVersion
		Set IsActive=objVersion.FormIsActive
		Set IsOpen = objVersion.FormIsOpen
		Set FormVerDate=objVersion.FormVerDate
		Set:FormVerDate'="" FormVerDate=$zd(FormVerDate,3)
		Set FormVerTime=objVersion.FormVerTime
		Set PublicUser=objVersion.FormVerUserID
	}
	//Continue:'IsActive
	If (IsActive) {
		Set NodeID=aFormID_"-Ver-"_(+FormVerDate>0)_"-"_$p(argNodeID,"-",3)_"-Dep"
		If FormVerDate="" {
			Set Desc="V"_Version_".0 未发布"
		} Else {
			Set Desc="V"_Version_".0 "_FormVerDate
		}
		If IsOpen {
			Set Desc=Desc_"(正使用)"
		}
	} Else {
		Set NodeID=aFormID_"-Ver-"_(+FormVerDate>0)_"-"_$p(argNodeID,"-",3)_"-Dep" 
		Set Desc="V"_Version_".0 (作废)"
	}
	Set iconCls=""
	Set check=""
	Set state=""
	Set attributes =""
	Set Data=$lb(NodeID,Desc,iconCls,check,state,attributes)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
}

ClassMethod QryLocPathVerClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocPathVerExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryLocPathVerFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocPathVerExecute ]
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

/// Creator：     jiangpengpeng
/// CreatDate：   2020-06-24
/// Description:  判断路径是否关联医院
/// Table：       DHCMA.CPW.BT.PathHosp
/// Input：       路径ID：aPathID
/// Return：      
/// w ##class(DHCMA.CPW.BTS.PathFormSrv).CheckPathHospOID("9","2!!1")
ClassMethod CheckPathHospOID(aPathID As %String, aHospOID As %String) As %String
{
	New (aPathID,aHospOID)
	Set return=""
	Quit:(aPathID="")||(aHospOID="") return
	
	Set IsHosp=0
	Set IsOpen=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIsOpenMultiHospMode",aHospOID)
	If (IsOpen="Y")&&(aHospOID'=""){
		 Set retFlg=##class(DHCMA.Util.IO.MultiHospInterface).IsShowOneDataByHosp("DHCMA_CPW_BT.PathMast",aPathID,aHospOID)
		 Set:retFlg="Y" IsHosp=1	
	}else{
		Set xPathHpID=""
		For {
			Set xPathHpID=$o(^DHCMA.CPW.BT.PathMastD(aPathID,"HOSP",xPathHpID))
			Quit:xPathHpID=""
			
			Set objPathHp=##class(DHCMA.CPW.BT.PathHosp).GetObjById(aPathID_"||"_xPathHpID)
			Continue:'$IsObject(objPathHp)
			Continue:'objPathHp.BTIsActive
			
			Set HospOID=objPathHp.BTHospID
			Set:aHospOID[HospOID IsHosp=1
			
			Quit:IsHosp
		}	
	}
	
	Set return=IsHosp
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2018-08-24
/// Description:  更新实体对象
/// Table：       DHCMA.CPW.BT.PathForm
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 
/// w ##class(DHCMA.CPW.BTS.PathFormSrv).ActiveFalse("1")
ClassMethod ActiveFalse(aFormVerID As %String = "") As %String
{
	New (aFormVerID)
	Set return=0
	Quit:aFormVerID="" return
	Set obj=##class(DHCMA.CPW.BT.PathForm).%OpenId(aFormVerID)
	Quit:'$IsObject(obj) return
	
	Set obj.FormIsActive = 0
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2018-08-24
/// Description:  更新实体对象
/// Table：       DHCMA.CPW.BT.PathForm
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 
/// w ##class(DHCMA.CPW.BTS.PathFormSrv).PathFormPub("1")
ClassMethod PathFormPub(aFormVerID As %String = "", aUserID As %String) As %String
{
	New (aFormVerID,aUserID)
	Set return=0
	Quit:aFormVerID="" return
	
	//增加阶段为空检查
	Set isNullEp=$o(^DHCMA.CPW.BT.PathFormD(aFormVerID,"EP",""))
	Quit:isNullEp="" -4
	
	//增加阶段下项目内容检查，存在空项目阶段不允许发布
	Set xFormEpID="",isNullItem=""
	For {
		Set xFormEpID=$o(^DHCMA.CPW.BT.PathFormD(aFormVerID,"EP",xFormEpID))
		Quit:xFormEpID=""
		Quit:return<0
		
		Set objFormEp=##class(DHCMA.CPW.BT.PathFormEp).GetObjById(aFormVerID_"||"_xFormEpID)
		Continue:'$IsObject(objFormEp)
		Continue:'objFormEp.EpIsActive
		Set isNullItem=$o(^DHCMA.CPW.BT.PathFormD(aFormVerID,"EP",xFormEpID,"ITM",""))
		Set:isNullItem="" return=-3
	}
	Quit:return<0 return
	
	Set obj=##class(DHCMA.CPW.BT.PathForm).%OpenId(aFormVerID)
	Quit:'$IsObject(obj) return
	Set MastID=obj.FormPathDr.%Id()
	Set flg=..GetFormByMast(MastID,1)
	Quit:flg'="" -2		//存在已发布版本，应先作废
	
	Set VerActDate=+$h
	Set VerActTime=$p($h,",",2)
	Set obj.FormIsActive = 1
	Set obj.FormIsOpen =1
	Set obj.FormVerUserID = aUserID
	Set obj.FormVerDate = VerActDate
	Set obj.FormVerTime = VerActTime
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-12
/// Description:  获取表单文档信息
/// Table：       DHCMA.CPW.BT.PathForm
/// Input：       
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.BTS.PathFormSrv).GetHelpDoc(1)
ClassMethod GetHelpDoc(aFormID As %String) As %String
{
	New (aFormID)
	Set return=""
	Quit:aFormID="" return
	
	Set objForm=##class(DHCMA.CPW.BT.PathForm).GetObjById(aFormID)
	Quit:'$IsObject(objForm) return
	
	Set return=objForm.FormHelpDoc
	Set:return="" return=objForm.FormApply
	
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-12
/// Description:  查询正在使用临床路径
/// Table：       DHCMA.CPW.BT.PathForm
/// Input：       aMastID : 临床路径字典ID
/// 			  aIO=1,查询已经发布的版本，用于入径提示
/// 			  aIO=0,如果有发布的版本则返回发布版本，没有则返回最新未发布版本
/// 			  aIO=2,不考虑是否发布，只显示最新版本
/// 			  aIsActive:有效性检查，默认返回有效
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.BTS.PathFormSrv).GetFormByMast(1)
ClassMethod GetFormByMast(aMastID As %String, aIO As %String = "0", aIsActive As %String = "1") As %String
{
	New (aMastID,aIO,aIsActive)
	Set return=""
	Quit:aMastID="" return
	
	Set PathForm=""
	Set xVer=""
	For {
		Set xVer=$o(^DHCMA.CPW.BT.PathFormI("IdxofVersion",aMastID,xVer))
		Quit:xVer=""
		
		Set IsOpen=0
		Set xFormID=0
		For {
			Set xFormID=$o(^DHCMA.CPW.BT.PathFormI("IdxofVersion",aMastID,xVer,xFormID))
			Quit:xFormID=""
			
			Set objForm=##class(DHCMA.CPW.BT.PathForm).GetObjById(xFormID)
			Continue:'$IsObject(objForm)
			
			Set IsActive=objForm.FormIsActive
			Continue:(aIsActive'="")&&(aIsActive'=IsActive)
			Set IsOpen=objForm.FormIsOpen			// 是否发布
			Continue:(aIO=1)&&(IsOpen'=1)			// 只返回发布的
			Set Version=objForm.FormVersion
			Set:Version'="" Version="V"_$fn(Version,"",1)
			
			Set PathForm=xFormID_"^"_Version
		}
		Quit:(aIO'=2)&&(IsOpen)
	}
	Set return=PathForm
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2019-02-14
/// Description:  检查当前路径表单版本
///               用于表单修改权限控制，返回为“空”允许修改
/// Table：       DHCMA.CPW.BT.PathForm
/// Input：       aFormID : 临床路径表单ID
/// Return：      
/// w ##class(DHCMA.CPW.BTS.PathFormSrv).CheckFormVerAct(17)
ClassMethod CheckFormVerAct(aFormID As %String) As %String
{
	New (aFormID)
	Set return=""
	Quit:aFormID="" return
	
	Set objForm=##class(DHCMA.CPW.BT.PathForm).GetObjById(aFormID)
	Quit:'$IsObject(objForm) return
	Quit:'$IsObject(objForm.FormPathDr) return
	Set PathDesc=objForm.FormPathDr.BTDesc
	Set PathIsAct=objForm.FormPathDr.BTIsActive
	Set IsActive=objForm.FormIsActive  //0已作废
	Set IsOpen=objForm.FormIsOpen      //1已发布
	Set Version=objForm.FormVersion
	Set Version="v"_Version
	
	Set:PathIsAct'=1 IsActive=0  //如果路径无效，所有表单都无效
	
	Set return=aFormID_"^"_PathDesc_"^"_Version_"^"_IsActive_"^"_IsOpen
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-11-15
/// Description:  新增版本
/// Table：       DHCMA.CPW.BT.PathForm
/// Input：       
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.BTS.PathFormSrv).AddNewVer(2,"9!!1")
ClassMethod AddNewVer(aMastID As %String, aUserID As %String) As %String
{
	New (aMastID,aUserID)
	Set return=""
	Quit:(aMastID="") return
	
	Set objMast=##class(DHCMA.CPW.BT.PathMast).GetObjById(aMastID)
	Quit:'$IsObject(objMast) -1
	Set FormStr=..GetFormByMast(aMastID)
	Set aPathFormID=$p(FormStr,"^",1)
	Set objLastVer=##class(DHCMA.CPW.BT.PathForm).GetObjById(aPathFormID)
	
	Set $ZT="AddNewVerErr"
	TStart
	
	Set objNewF=##class(DHCMA.CPW.BT.PathForm).%New()
	Set objNewF.FormPathDr=objMast
	Set objNewF.FormCost=$s($IsObject(objLastVer):objLastVer.FormCost,1:"")
	Set objNewF.FormDays=$s($IsObject(objLastVer):objLastVer.FormDays,1:"")
	Set objNewF.FormApply=$s($IsObject(objLastVer):objLastVer.FormApply,1:"")
	Set objNewF.FormHelpDoc=$s($IsObject(objLastVer):objLastVer.FormHelpDoc,1:"")
	Set objNewF.FormIsActive=1
	Set objNewF.FormActDate=+$h
	Set objNewF.FormActTime=$p($h,",",2)
	Set objNewF.FormActUserID=aUserID
	Set objNewF.FormIsOpen=0
	Set objNewF.FormVerDate=""
	Set objNewF.FormVerTime=""
	Set objNewF.FormVerUserID=""
	Set objNewF.FormOID=""
	Set FormVersion=+$o(^DHCMA.CPW.BT.PathFormI("IdxofVersion",objMast.%Id(),""),-1)
	Set FormVersion=$s(FormVersion<0:1,1:FormVersion+1)
	Set objNewF.FormVersion=FormVersion
	Set sc=objNewF.%Save()
	If $System.Status.IsError(sc) {                      //检查Save是否成功
   		//Do $system.OBJ.DisplayError(sc) 
   		TRollBack
   		Set return=-6
	} Else {
		Set return=objNewF.%Id()
		If aPathFormID'=""{
			M ^DHCMA.CPW.BT.PathFormD(return,"EP")=^DHCMA.CPW.BT.PathFormD(aPathFormID,"EP")
			M ^DHCMA.CPW.BT.PathFormD(return,"SYMP")=^DHCMA.CPW.BT.PathFormD(aPathFormID,"SYMP")
			M ^DHCMA.CPW.BT.PathFormI("EP","IdxofIndNo",return)=^DHCMA.CPW.BT.PathFormI("EP","IdxofIndNo",aPathFormID)
			M ^DHCMA.CPW.BT.PathFormI("ITM","IdxofCatDrIndNo",return)=^DHCMA.CPW.BT.PathFormI("ITM","IdxofCatDrIndNo",aPathFormID)
		}
	}
	Quit:return<0 return
	
	If $TLevel>0 TCommit
	Quit return

AddNewVerErr
	If $TLevel>0 TRollBack 		//如果存在事务，回滚事务
	Set $ZT="" 					//去除错误方法关联，此句必须写
	Quit "-999"_$ZE 			//返回错误消息
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-11-15
/// Description:  复制为新路径
/// Table：       DHCMA.CPW.BT.PathForm
/// Input：       
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.BTS.PathFormSrv).CopyFormAsNew("19","啦啦啦","9!!1","2!!1")
ClassMethod CopyFormAsNew(aPathFormID As %String, aNewName As %String, aUserID As %String, aSelHospID As %String, aLocID As %String = "") As %String
{
	New (aPathFormID,aNewName,aUserID,aSelHospID,aLocID)
	Set return=""
	Quit:(aPathFormID="")||(aNewName="") return
	
	Set IsSame=0
	Set xMastID=""
	For {
		Set xMastID=$o(^DHCMA.CPW.BT.PathMastD(xMastID))
		Quit:xMastID=""
		
		Set objMast=##class(DHCMA.CPW.BT.PathMast).GetObjById(xMastID)
		Continue:'$IsObject(objMast)
		
		Set xBTDesc=objMast.BTDesc
		If (aNewName=xBTDesc) {
			Set IsSame=1
			Quit
		}
	}
	Quit:IsSame -2
	
	//复制路径字典
	Set objForm=##class(DHCMA.CPW.BT.PathForm).GetObjById(aPathFormID)
	Quit:'$IsObject(objForm) -3
	
	//获取多院区配置，根据配置决定如何复制医院信息
	Set IsOpen=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIsOpenMultiHospMode",aSelHospID)
	
	Set $ZT="CopyFormAsNewError"
	TStart
	
	Set objNewM=##class(DHCMA.CPW.BT.PathMast).%New()
	Set objNewM.BTCode=$tr($zd(+$h,3),"-")_$tr($zt($p($h,",",2),1),":")
	Set objNewM.BTDesc=aNewName
	Set objNewM.BTTypeDr=objForm.FormPathDr.BTTypeDr
	Set objNewM.BTEntityDr=objForm.FormPathDr.BTEntityDr
	Set objNewM.BTPCEntityDr=objForm.FormPathDr.BTPCEntityDr
	Set objNewM.BTQCEntityDr=objForm.FormPathDr.BTQCEntityDr
	Set objNewM.BTPathComplDr=objForm.FormPathDr.BTPathComplDr
	Set objNewM.BTAdmType=objForm.FormPathDr.BTAdmType
	Set objNewM.BTIsActive=1
	Set objNewM.BTActDate=+$h
	Set objNewM.BTActTime=$p($h,",",2)
	Set objNewM.BTActUserID=aUserID
	
	Set sc=objNewM.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		//Do $system.OBJ.DisplayError(sc) 
   		TRollBack
		Set return=-4
	} Else {
		Set return=objNewM.%Id()
		//数据院区关联处理 add by yankai20210803
		If (+return>0)&&(IsOpen="Y"){
			Do ##class(DHCMA.Util.IO.MultiHospInterface).SaveDataRelHosp("DHCMA_CPW_BT.PathMast",return,aSelHospID)	
		}
	}
	Quit:return<0 return
	
	Set aBTPathDr=objForm.FormPathDr.%Id()
	Set NewPathID=objNewM.%Id()
	
	If IsOpen'="Y"{
		//复制院区信息
		Set xPathHpID=""
		For {
			Set xPathHpID=$o(^DHCMA.CPW.BT.PathMastD(aBTPathDr,"HOSP",xPathHpID))
			Quit:xPathHpID=""
			
			Set objPathHp=##class(DHCMA.CPW.BT.PathHosp).GetObjById(aBTPathDr_"||"_xPathHpID)
			Continue:'$IsObject(objPathHp)
			Continue:'objPathHp.BTIsActive
			
			Set HospOID=objPathHp.BTHospID
			
			Set Inputs=NewPathID_"^^"_HospOID_"^1^"_aUserID
			Set ret=##class(DHCMA.CPW.BT.PathHosp).Update(Inputs)
			If +ret<=0{
				TRollBack
				Set return=-5
				Quit	
			} 
		}
		Quit:return<0 return	
	}
	
	//复制入径标准
	Set xTypeID=""
 	For {
	 	Set xTypeID = $o(^DHCMA.CPW.BT.PathAdmitI("IdxofPathType",aBTPathDr,xTypeID))
	 	Quit:xTypeID=""
	 	
		Set objDict = ##class(DHCMA.Util.BT.Dictionary).GetObjById(xTypeID)
		Continue:'$IsObject(objDict)
	 	Set xID = ""
	 	For {
		 	Set xID = $o(^DHCMA.CPW.BT.PathAdmitI("IdxofPathType",aBTPathDr,xTypeID,xID))
		 	Quit:xID=""
		 	
		 	Set objPath = ##class(DHCMA.CPW.BT.PathAdmit).GetObjById(xID)
		 	Continue:'$IsObject(objPath)
		 	Set MOrdFlag="",OOrdFlag=""
		 	if ($d(^DHCMA.CPW.BT.PathAdmit("ORD","IdxofParrType",xID," M"))){
			 	Set OrdID=""
			 	For{
				 	Set OrdID=$o(^DHCMA.CPW.BT.PathAdmit("ORD","IdxofParrType",xID," M",OrdID))
				 	Quit:OrdID=""
				 	Set objMOrd = ##class(DHCMA.CPW.BT.PathAdmitOrds).GetObjById(xID_"||"_OrdID)
	 				Continue:'$IsObject(objMOrd)
	 				Set MOrdFlag="1"
			 	}
			 }
			 if ($d(^DHCMA.CPW.BT.PathAdmit("ORD","IdxofParrType",xID," O"))){
				Set OrdID=""
			 	For{
				 	Set OrdID=$o(^DHCMA.CPW.BT.PathAdmit("ORD","IdxofParrType",xID," O",OrdID))
				 	Quit:OrdID=""
				 	Set objOOrd = ##class(DHCMA.CPW.BT.PathAdmitOrds).GetObjById(xID_"||"_OrdID)
	 				Continue:'$IsObject(objOOrd)
	 				Set OOrdFlag="1"
			 	}
			}
			Set inupts="^"_NewPathID_"^"_xTypeID_"^"_objPath.BTICD10_"^"_objPath.BTICDKeys
			Set inupts=inupts_"^"_objPath.BTOperICD_"^"_objPath.BTOperKeys_"^"_objPath.BTIsICDAcc_"^"_objPath.BTIsOperAcc
			Set inupts=inupts_"^"_1_"^^^"_objPath.BTActUserID
			Set ret=##class(DHCMA.CPW.BT.PathAdmit).Update(inupts)
			If +ret<=0{
				TRollBack
				Set return=-6
				Quit	
			} 
			if (OOrdFlag="1"){
				Set ordinupts=ret_"^"_""_"^"_objOOrd.OrdMORcID_"^"_objOOrd.OrdIcd_"^"_"O"
				Set Oret=##class(DHCMA.CPW.BT.PathAdmitOrds).Update(ordinupts)
				If +Oret<=0{
					TRollBack
					Set return=-7
					Quit	
				} 
			}
			if (MOrdFlag="1"){
				Set ordinupts=ret_"^"_""_"^"_objMOrd.OrdMORcID_"^"_objMOrd.OrdIcd_"^"_"M"
				Set Mret=##class(DHCMA.CPW.BT.PathAdmitOrds).Update(ordinupts)
				If +Mret<=0{
					TRollBack
					Set return=-8
					Quit	
				} 
			}
	 	}
	 	Quit:return<0
 	}
	Quit:return<0 return
	
	//复制表单内容
	Set objNewF=##class(DHCMA.CPW.BT.PathForm).%New()
	Set objNewF.FormPathDr=objNewM
	Set objNewF.FormCost=objForm.FormCost
	Set objNewF.FormDays=objForm.FormDays
	Set objNewF.FormApply=objForm.FormApply
	Set objNewF.FormHelpDoc=objForm.FormHelpDoc
	Set objNewF.FormIsActive=1
	Set objNewF.FormActDate=+$h
	Set objNewF.FormActTime=$p($h,",",2)
	Set objNewF.FormActUserID=aUserID
	Set objNewF.FormIsOpen=0
	Set objNewF.FormVerDate=""
	Set objNewF.FormVerTime=""
	Set objNewF.FormVerUserID=""
	Set objNewF.FormOID=""
	Set objNewF.FormVersion=1
	Set sc=objNewF.%Save()
	If $System.Status.IsError(sc) {                      //检查Save是否成功
   		//Do $system.OBJ.DisplayError(sc) 
   		TRollBack
   		Set return=-6
	} Else {
		Set return=objNewF.%Id()
		M ^DHCMA.CPW.BT.PathFormD(return,"EP")=^DHCMA.CPW.BT.PathFormD(aPathFormID,"EP")
		M ^DHCMA.CPW.BT.PathFormD(return,"SYMP")=^DHCMA.CPW.BT.PathFormD(aPathFormID,"SYMP")
		M ^DHCMA.CPW.BT.PathFormI("SYMP","IdxofFormTCMDr",return)=^DHCMA.CPW.BT.PathFormI("SYMP","IdxofFormTCMDr",aPathFormID)
		M ^DHCMA.CPW.BT.PathFormI("EP","IdxofIndNo",return)=^DHCMA.CPW.BT.PathFormI("EP","IdxofIndNo",aPathFormID)
		M ^DHCMA.CPW.BT.PathFormI("ITM","IdxofCatDrIndNo",return)=^DHCMA.CPW.BT.PathFormI("ITM","IdxofCatDrIndNo",aPathFormID)

	}
	Quit:return<0 return
	
	If (aLocID'=0)&&(aLocID'=""){				// 非管理科室复制时，自动关联科室
		Set valAutoLink = ##class(DHCMA.Util.BT.Config).GetValueByCode("CPWAutoLinkPathAndLoc",aSelHospID)
		If valAutoLink="Y"{
			Set InputStr = "^"_aLocID_"^"_NewPathID_"^"_1_"^^^"_aUserID
			Set retAutoLink = ##class(DHCMA.CPW.BT.PathLoc).Update(InputStr,"^")
			If +retAutoLink<=0{
				TRollBack
				Set return =-7	
			}	
		}	
	}
	Quit:return<0 return
	
	If $TLevel>0 TCommit
	Quit return
	
CopyFormAsNewError
	If $TLevel>0 TRollBack 		//如果存在事务，回滚事务
	Set $ZT="" 					//去除错误方法关联，此句必须写
	Quit "-999"_$ZE 			//返回错误消息
}

/// Creator：     yankai
/// CreatDate：   2019-06-20
/// Description:  [门诊]检查指定字典路径的有效出入径记录中最后一次就诊入径信息
/// Table：       DHCMA.CPW.CP.PathwayVisit
/// Input：       
/// Return：   	  返回版本ID^路径描述（版本）^历史入径Visit记录ID
/// w ##Class(DHCMA.CPW.BTS.PathFormSrv).GetHistoryFormInfo("709","20")
ClassMethod GetHistoryFormInfo(aEpisodeID As %String, aPathID As %String) As %String
{
	New (aEpisodeID,aPathID)
	Set return=""
	Quit:(aEpisodeID="")||(aPathID="") return
	
	Set xEpisodeID=aEpisodeID
	Set:aEpisodeID["!!" xEpisodeID=$p(aEpisodeID,"!!",1)
	Set PatientID=$p($g(^PAADM(xEpisodeID)),"^",1)
	Quit:PatientID="" return
	Set AdmHospID=##class(DHCMA.CPW.IO.FromDoc).GetAdmHospOID(aEpisodeID)		//就诊院区
	Set PatInfo=##Class(DHCMA.CPW.IO.FromDoc).GetPatIDAndIDCardCode(aEpisodeID)
	Set IdentityCode=$p(PatInfo,"^",2)
	
	Set xPathwayID="",xVisitID="",FormID="",VisitID=""
	For {
		Set xPathwayID=$o(^DHCMA.CPW.CP.PathwayVisitI("IdxOfPatIDPathwayDr",PatientID,xPathwayID))
		Quit:return'=""
		Quit:xPathwayID=""
				
		//只取每条路径最后一次产生的有效Visit记录
		Set xVisitID=""
		For {
			Set xVisitID=$o(^DHCMA.CPW.CP.PathwayVisitI("IdxOfPatIDPathwayDr",PatientID,xPathwayID,xVisitID),-1)
			Quit:return'=""
			Quit:xVisitID=""
			
			Set objVisit=##class(DHCMA.CPW.CP.PathwayVisit).GetObjById(xVisitID)
			Continue:'$IsObject(objVisit)
			Continue:'$IsObject(objVisit.CPPathwayDr)
			Continue:'$IsObject(objVisit.CPEpisDr)
		
			Set EpisodeID=objVisit.CPEpisodeID
			Set PathwayStatus=objVisit.CPPathwayDr.CPStatus
			Quit:PathwayStatus'="I"	
			Continue:objVisit.CPStatus'="I"
							
			Set PathID=objVisit.CPPathwayDr.CPFormDr.FormPathDr.%Id()
			Continue:(aPathID'="")&&(PathID'=aPathID)
			Set FormID=objVisit.CPPathwayDr.CPFormDr.%Id()
			Set Version=objVisit.CPPathwayDr.CPFormDr.FormVersion
		
			Set Version="v"_Version
			Set VisitID=xVisitID	
			Set return=FormID_"^"_Version_"^"_VisitID
		}
	}
	
	Set IsCheck=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWOPIsChkHistByCardID",AdmHospID)
	If (IsCheck="Y")&&(IdentityCode'="")&&(return="") {			//通过PatientID检查无数据时再通过身份证号检查
		Set xPathwayID="",xVisitID=""
		For {
			Set xPathwayID=$o(^DHCMA.CPW.CP.PathwayVisitI("IdxOfIDCodePathwayDr",IdentityCode,xPathwayID))
			Quit:return'=""
			Quit:xPathwayID=""
					
			//只取每条路径最后一次产生的有效Visit记录
			For {
				Set xVisitID=$o(^DHCMA.CPW.CP.PathwayVisitI("IdxOfPathwayDr",xPathwayID,xVisitID),-1)
				Quit:return'=""
				Quit:xVisitID=""
				
				Set objVisit=##class(DHCMA.CPW.CP.PathwayVisit).GetObjById(xVisitID)
				Continue:'$IsObject(objVisit)
				Continue:'$IsObject(objVisit.CPPathwayDr)
				Continue:'$IsObject(objVisit.CPEpisDr)
			
				Set EpisodeID=objVisit.CPEpisodeID
				Set PathwayStatus=objVisit.CPPathwayDr.CPStatus
				Quit:PathwayStatus'="I"	
				Continue:objVisit.CPStatus'="I"
								
				Set PathID=objVisit.CPPathwayDr.CPFormDr.FormPathDr.%Id()
				Continue:(aPathID'="")&&(PathID'=aPathID)
				Set FormID=objVisit.CPPathwayDr.CPFormDr.%Id()
				Set Version=objVisit.CPPathwayDr.CPFormDr.FormVersion
			
				Set Version="v"_Version
				Set VisitID=xVisitID	
				Set return=FormID_"^"_Version_"^"_VisitID
			}
		}	
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2019-07-18
/// Description:  查询路径版本信息
/// Table：       DHCMA.CPW.BT.PathForm
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.PathFormSrv","QryPathForm",2)
Query QryPathForm(aPathMastDr As %String) As %Query(ROWSPEC = "FormID:%String,FormVerDesc:%String")
{
}

ClassMethod QryPathFormExecute(ByRef qHandle As %Binary, aPathMastDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aPathMastDr="" $$$OK
 	
 	Set xFormVer=""
 	For {
	 	Set xFormVer=$o(^DHCMA.CPW.BT.PathFormI("IdxofVersion",aPathMastDr,xFormVer))
	 	Quit:xFormVer=""
	 	Continue:xFormVer<0
	 	
	 	Set xID=0
	 	For {
		 	Set xID=$o(^DHCMA.CPW.BT.PathFormI("IdxofVersion",aPathMastDr,xFormVer,xID))
	 		Quit:xID=""
	 		
	 		Set objForm=##class(DHCMA.CPW.BT.PathForm).GetObjById(xID)
	 		Continue:'$IsObject(objForm)
	 		
	 		Set FormVerDesc=objForm.FormVersion
	 		Set FormVerDesc="v"_FormVerDesc_".0"
	 		Set FormIsActive=objForm.FormIsActive
	 		If FormIsActive<1 {
		 		Set FormVerDesc=FormVerDesc_"(作废)"
	 		} Else {
	 			Set FormIsOpen=objForm.FormIsOpen
		 		Set:FormIsOpen>0 FormVerDesc=FormVerDesc_"(已发布)"
		 	}
	 		
			Set Data=$lb(xID,FormVerDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryPathFormClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathFormExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathFormFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathFormExecute ]
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

/// Creator：     yankai
/// CreatDate：   2022-11-23
/// Description:  多条件过滤路径
/// Table：       
/// w ##class(DHCMA.CPW.BTS.PathFormSrv).ChkCPWByKeyIDs("^^^",10,1)
ClassMethod ChkCPWByKeyIDs(aKeyIDs As %String, aMastID As %String, aFlagVer As %String) As %String
{
	New (aKeyIDs,aMastID,aFlagVer)
	Set return=0
	
	Set PathKeyIDs = $p(aKeyIDs,"^",1)									// 路径特征
	Set FormKeyIDs = $e(aKeyIDs,$l(PathKeyIDs)+1+1,$l(aKeyIDs))			// 版本特征
	
	Set retPath = ..FilterPathKeyIDs(aMastID, PathKeyIDs)				// 路径过滤
	Quit:retPath'=1 return

	If aFlagVer="-1" {													// 版本过滤-全部版本查询
		If '$d(^DHCMA.CPW.BT.PathFormI("IdxofVersion",aMastID))&&($tr(FormKeyIDs,"^")=""){
			Set return=1												// 全部查询时无版本的也返回	
		}Else{
			Set xVerNum = 0
			For {
				Set xVerNum = $o(^DHCMA.CPW.BT.PathFormI("IdxofVersion",aMastID,xVerNum))
				Quit:xVerNum=""
				Quit:return=1
				
				Set xFormID = ""
				For {
					Set xFormID = $o(^DHCMA.CPW.BT.PathFormI("IdxofVersion",aMastID,xVerNum,xFormID))
					Quit:xFormID=""
					Quit:return=1	
					
					Set objForm = ##class(DHCMA.CPW.BT.PathForm).%OpenId(xFormID)
					Continue:'$IsObject(objForm)
					
					Set retFilterForm = ..FilterVerKeyIDs(xFormID,FormKeyIDs)
					Continue:retFilterForm'=1
					Set return=1
				}
			}	
		}
	}ElseIf aFlagVer="-2"{												// 查询无版本的路径
		If '$d(^DHCMA.CPW.BT.PathFormI("IdxofVersion",aMastID)){
			Set return=1
		}Else{
			Set return=0
		} 
	}Else {
		Set IsFormActive=1
		Set:aFlagVer=2 IsFormActive=""									//只有查询的版本状态含作废时，才支持返回作废状态的版本
		Set FormStr=##class(DHCMA.CPW.BTS.PathFormSrv).GetFormByMast(aMastID,aFlagVer,IsFormActive)		//FormID_"^"_Version
		Set FormID=$p(FormStr,"^",1)
		
		Set retFilterForm = ..FilterVerKeyIDs(FormID,FormKeyIDs)
		Set:retFilterForm=1 return=1	
	}
	
	Quit return
}

/// Creator：     yankai
/// CreatDate：   2022-11-22
/// Description:  对路径特征过滤
/// Table：       
/// w ##class(DHCMA.CPW.BTS.PathFormSrv).FilterPathKeyIDs(13,"")
ClassMethod FilterPathKeyIDs(aMastID As %String, aKeyIDs As %String) As %String
{
	New (aMastID, aKeyIDs)
	Set return = 0
	Quit:aMastID="" return
	Quit:$tr(aKeyIDs,"^")="" 1 
	
	Set objCPW=##class(DHCMA.CPW.BT.PathMast).GetObjById(aMastID)
	Quit:'$IsObject(objCPW) return
	
	Set listKeyIDs=$lfs(aKeyIDs,",")
	
	// 特征部分
	Quit:$lf(listKeyIDs,"NotActive")&&objCPW.BTIsActive return							//无效路径
	Quit:$lf(listKeyIDs,"NotEntity")&&$IsObject(objCPW.BTEntityDr) return				//无单病种
	Quit:$lf(listKeyIDs,"NotPCEntity")&&(objCPW.BTPCEntityDr'="") return				//无付费病种
	Quit:$lf(listKeyIDs,"NotQCEntity")&&(objCPW.BTQCEntityDr'="") return				//无质控病种
	Quit:$lf(listKeyIDs,"ComplPath")&&(objCPW.BTIsAsCompl'=1) return					//合并症路径
	Quit:$lf(listKeyIDs,"OperPath")&&(objCPW.BTIsOper'=1) return						//手术路径
	
	// 未关联科室
	If $lf(listKeyIDs,"NotLinkLoc"){
		Set xLinkLocID="",isLinkLoc=0
		For {
			Set xLinkLocID=$o(^DHCMA.CPW.BT.PathLocI("IdxofLocPath",xLinkLocID))
			Quit:xLinkLocID=""
			Quit:isLinkLoc=1
			
			Continue:'$d(^DHCMA.CPW.BT.PathLocI("IdxofLocPath",xLinkLocID,aMastID))
			Set LinkID=$o(^DHCMA.CPW.BT.PathLocI("IdxofLocPath",xLinkLocID,aMastID,""))
			Set objLink=##class(DHCMA.CPW.BT.PathLoc).GetObjById(LinkID)
			Continue:'$IsObject(objLink)
			Set:objLink.PDIsActive isLinkLoc=1
				
		}
		Quit:isLinkLoc=1 return	
	}
	
	//无准入信息
	If $lf(listKeyIDs,"NotDiag"){
		Set xDiagTypeID="",isExistAdmitRec=0
		For {
			Set xDiagTypeID=$o(^DHCMA.CPW.BT.PathAdmitI("IdxofPathType",aMastID,xDiagTypeID))
			Quit:xDiagTypeID=""
			
			Set xAdmitID=""
			For {
				Set xAdmitID=$o(^DHCMA.CPW.BT.PathAdmitI("IdxofPathType",aMastID,xDiagTypeID,xAdmitID))
				Quit:xAdmitID=""
				
				Set objAdmit=##class(DHCMA.CPW.BT.PathAdmit).GetObjById(xAdmitID)
				Continue:'$IsObject(objAdmit)
				Continue:'objAdmit.BTIsActive
				Set:objAdmit.BTIsActive=1 isExistAdmitRec=1
				Quit:isExistAdmitRec=1	
			}
			Quit:isExistAdmitRec=1	
		}
		Quit:isExistAdmitRec=1 return	
	}
	
	Quit 1
}

/// Creator：     yankai
/// CreatDate：   2022-11-22
/// Description:  对版本特征过滤
/// Table：       
/// w ##class(DHCMA.CPW.BTS.PathFormSrv).FilterVerKeyIDs("2","NotOrder^^")
ClassMethod FilterVerKeyIDs(aFormID As %String, aKeyIDs As %String) As %String
{
	New (aFormID, aKeyIDs)
	Set return = 0
	Quit:aFormID="" return
	Quit:$tr(aKeyIDs,"^")="" 1
	
	Set objForm=##class(DHCMA.CPW.BT.PathForm).GetObjById(aFormID)
	Quit:'$IsObject(objForm) return	
	
	// 1、版本特征
	Set listKeyIDs=$lfs($p(aKeyIDs,"^",1),",")
	Quit:($lf(listKeyIDs,"NotApplyDoc"))&&(objForm.FormApply'="") return		//无适用对象文档
	Quit:$lf(listKeyIDs,"NotAdmitDoc")&&(objForm.FormHelpDoc'="") return	//无进入路径标准
	Quit:$lf(listKeyIDs,"NotDays")&&(objForm.FormDays'="") return		//无参考天数
	Quit:$lf(listKeyIDs,"NotFees")&&(objForm.FormCost'="") return		//无参考费用

	//有方剂证型(表单关联证型）
	If $lf(listKeyIDs,"LinkSymp"){
		Quit:'$d(^DHCMA.CPW.BT.PathFormI("SYMP","IdxofFormTCMDr",aFormID)) return	
	}
	
	//未关联医嘱
	If $lf(listKeyIDs,"NotOrder"){
		Set xItemCatID="",isLinkOrder=0
		For {
			Set xItemCatID=$o(^DHCMA.CPW.BT.PathItemCatD(xItemCatID))
			Quit:xItemCatID=""
			
			Set objItemCat=##class(DHCMA.CPW.BT.PathItemCat).GetObjById(xItemCatID)
			Continue:'$IsObject(objItemCat)
			Continue:'objItemCat.BTTypeDr.BTIsActive
			Continue:objItemCat.BTTypeDr.BTDesc'["重点医嘱"
			
			Set xEpisID=""
			For {
				Set xEpisID=$o(^DHCMA.CPW.BT.PathFormI("ITM","IdxofCatDrIndNo",aFormID,xEpisID))
				Quit:xEpisID=""
				
				Set xIndNo=""
				For {
					Set xIndNo=$o(^DHCMA.CPW.BT.PathFormI("ITM","IdxofCatDrIndNo",aFormID,xEpisID,xItemCatID,xIndNo))
					Quit:xIndNo=""
					
					Set xSubItemID=""
					For {
						Set xSubItemID=$o(^DHCMA.CPW.BT.PathFormI("ITM","IdxofCatDrIndNo",aFormID,1,xItemCatID,xIndNo,xSubItemID))
						Quit:xSubItemID=""
						
						Set BTItemID=aFormID_"||"_xEpisID_"||"_xSubItemID
						Set objItem=##class(DHCMA.CPW.BT.PathFormItem).GetObjById(BTItemID)
						Continue:'$IsObject(objItem)
						Continue:'objItem.ItemIsActive
						Set:$d(^DHCMA.CPW.BT.PathFormD(aFormID,"EP",xEpisID,"ITM",xSubItemID,"ORD")) isLinkOrder=1
						Quit:isLinkOrder=1
					}
					Quit:isLinkOrder=1
				}
				Quit:isLinkOrder=1	
			}
			Quit:isLinkOrder=1
		}
		Quit:isLinkOrder=1 return
	}
	
	// 2.申请状态部分
	If $p(aKeyIDs,"^",2) '= ""{
		Set listKeyIDs=$lfs($p(aKeyIDs,"^",2),",")
		Set ApplyResult = ##class(DHCMA.CPW.BTS.ApplyExamRecSrv).GetLastExamResult(aFormID)   //通过：1；未通过：0；申请中：-1；未申请:-2；其他：-9
		Quit:$lf(listKeyIDs,"NoApply")&&(ApplyResult'=-2) return
		Quit:$lf(listKeyIDs,"Applying")&&(ApplyResult'=-1) return
		Quit:$lf(listKeyIDs,"ApplyRefused")&&(ApplyResult'=0) return
		Quit:$lf(listKeyIDs,"ApplyPass")&&(ApplyResult'=1) return
	}
	
	// 3.发布状态部分
	If $p(aKeyIDs,"^",3) '= ""{
		Set listKeyIDs=$lfs($p(aKeyIDs,"^",3),",")
		Quit:$lf(listKeyIDs,"Cancel")&&(objForm.FormIsActive=1) return		//版本作废,过滤有效
		Quit:$lf(listKeyIDs,"NotOpen")&&((objForm.FormIsOpen=1)||(objForm.FormIsActive=0)) return		//未发布
		Quit:$lf(listKeyIDs,"Using")&&((objForm.FormIsOpen'=1)||(objForm.FormIsActive=0)) return		//正使用中路径(即发布状态路径)
	}
	
	Quit 1
}

/// Creator：     zhufei
/// CreatDate：   2021-10-28
/// Description:  查询路径表单
/// Table：       DHCMA.CPW.BT.PathForm
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.PathFormSrv","QryPathFormNowUse")
Query QryPathFormNowUse(aHospID As %String) As %Query(ROWSPEC = "FormID:%String,FormVerDesc:%String,PathFormDesc:%String")
{
}

ClassMethod QryPathFormNowUseExecute(ByRef qHandle As %Binary, aHospID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set IsOpen=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIsOpenMultiHospMode",aHospID)
 	
 	Set xPathMastDr=""
 	For{
	 	Set xPathMastDr=$o(^DHCMA.CPW.BT.PathFormI("IdxofVersion",xPathMastDr))
	 	Quit:xPathMastDr=""
 	
 	Set xFormVer=""
 	For {
	 	Set xFormVer=$o(^DHCMA.CPW.BT.PathFormI("IdxofVersion",xPathMastDr,xFormVer))
	 	Quit:xFormVer=""
	 	Continue:xFormVer<0
	 	
	 	Set xID=0
	 	For {
		 	Set xID=$o(^DHCMA.CPW.BT.PathFormI("IdxofVersion",xPathMastDr,xFormVer,xID))
	 		Quit:xID=""
	 		
	 		Set objForm=##class(DHCMA.CPW.BT.PathForm).GetObjById(xID)
	 		Continue:'$IsObject(objForm)
	 		
	 		Set FormVerDesc=objForm.FormVersion
	 		Set FormVerDesc="v"_FormVerDesc_".0"
	 		Set FormIsActive=objForm.FormIsActive
	 		Set FormIsOpen=objForm.FormIsOpen
	 		Set PathFormDesc = objForm.FormPathDr.BTDesc
	 		//Set aID = objForm.FormPathDr.BTEntityDr.%Id()
	 		If (IsOpen="Y")&&(aHospID'=""){
			 	Set retFlg=##class(DHCMA.Util.IO.MultiHospInterface).IsShowOneDataByHosp("DHCMA.CPW.BT.PathForm",xID,aHospID)
			 	Continue:retFlg'="Y"
			}
	 		If FormIsActive<1 {
		 		Set FormVerDesc=FormVerDesc_"(作废)"
	 		} Else {
	 			Set FormIsOpen=objForm.FormIsOpen
		 		Set:FormIsOpen>0 FormVerDesc=FormVerDesc_"(已发布)"
		 	}
		 	Continue:FormIsOpen<1
		 	Continue:FormIsActive<1
	 		
			Set Data=$lb(xID,FormVerDesc,PathFormDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
 	}
	Quit $$$OK
}

ClassMethod QryPathFormNowUseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathFormNowUseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathFormNowUseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathFormNowUseExecute ]
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

/// Creator：     yankai
/// CreatDate：   2022-04-22
/// Description:  通过表单获取路径信息
/// Table：       
/// w ##class(DHCMA.CPW.BTS.PathFormSrv).GetPathInfoByForm(13)
ClassMethod GetPathInfoByForm(aPathFormID As %String) As %String
{
	New (aPathFormID)
	Set return=""
	Quit:aPathFormID="" return
	
	Set objForm=##class(DHCMA.CPW.BT.PathForm).%OpenId(aPathFormID)
	Quit:'$IsObject(objForm) return

	Set objPathInfo = ##class(%DynamicObject).%New()
	Set objPathInfo.ID=objForm.%Id()
	Set objPathInfo.PathName=objForm.FormPathDr.BTDesc
	Set objPathInfo.PathType=objForm.FormPathDr.BTTypeDr.BTDesc
	Set objPathInfo.FormDays=objForm.FormDays
	Set objPathInfo.FormCost=objForm.FormCost
	Set objPathInfo.IsVaild=objForm.FormIsActive
	Set objPathInfo.IsOpen=objForm.FormIsOpen
	Set objPathInfo.FormVer=objForm.FormVersion
	
	Set (FormVerDate,FormVerTime,FormVerUser) = ""
	Set FormVerDate = ##class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(objForm.FormVerDate)
	Set FormVerTime = ##Class(DHCMA.Util.IO.FromHisSrv).ChangeTimeFormat(objForm.FormVerTime,1)
	Set objPathInfo.VerDate=FormVerDate
	Set objPathInfo.VerTime=FormVerTime
	
	Set objVerUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(objForm.FormVerUserID)
	Set:$IsObject(objVerUser) FormVerUser=objVerUser.BTDesc
	Set objPathInfo.VerUser=FormVerUser
	
	Quit objPathInfo.%ToJSON()
}

/// Creator：     zqy
/// Description:  判断表单是否是web创建且是否完成
/// Table：       
/// w ##class(DHCMA.CPW.BTS.PathFormSrv).CheckFormIC(13)
ClassMethod CheckFormIC(aMastId As %String) As %String
{
	New (aMastId)
	Set return=""
	Quit:aMastId="" return
	Quit:'$d(^DHCMA.CPW.BT.PathFormI("IdxofVersion",aMastId)) 1
	Set Version=""
	For{
		Set Version=$o(^DHCMA.CPW.BT.PathFormI("IdxofVersion",aMastId,Version))	
		Quit:Version=""
		Set FormID=""
		For{
			Set FormID=$o(^DHCMA.CPW.BT.PathFormI("IdxofVersion",aMastId,Version,FormID))	
			Quit:FormID=""
			Set return=0
			if ('$d(^DHCMA.CPW.BT.PathWebCreateI("IdxofPathForm",FormID))){
				Set return=1
				Quit
			}
			Set xID=$o(^DHCMA.CPW.BT.PathWebCreateI("IdxofPathForm",FormID,""),-1)
			Quit:xID=""
			Set obj=##class(DHCMA.CPW.BT.PathWebCreate).GetObjById(xID)
			Quit:'$IsObject(obj)
			Set:obj.BTStatus="C" return=1
		}
	}
	Quit return
}

}
