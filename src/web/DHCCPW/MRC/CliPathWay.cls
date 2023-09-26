/// 名称: web.DHCCPW.MRC.CliPathWay
/// 描述：对临床路径的各种操作分别有添加，删除，修改，查询等操作
/// 编写者：李宇峰
/// 编写日期：2010-04-27
Class web.DHCCPW.MRC.CliPathWay Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2010-10-29
/// Description:  根据ID取临床路径字典
/// Table：       User.DHCMRCClinPathWays
/// Input：       ID:    User.DHCMRCClinPathWays.Id
/// Return：      返回object
/// w ##class(web.DHCCPW.MRC.CliPathWay).GetObjById(1)
ClassMethod GetObjById(argId As %String) As User.DHCMRCClinPathWays
{
	New (argId)
	Set objCPW=##Class(User.DHCMRCClinPathWays).%OpenId(argId)
	If $IsObject(objCPW){
		If $IsObject(objCPW.CPWCPWDicDR){
			Set objCPW.CPWCode=objCPW.CPWCPWDicDR.CPWDCode
			Set objCPW.CPWDesc=objCPW.CPWCPWDicDR.CPWDDesc
			Set objCPW.CPWCPWTypeDR=objCPW.CPWCPWDicDR.CPWDCPWTypeDR
			Set objCPW.CPWActive=objCPW.CPWCPWDicDR.CPWDActive
			Set objCPW.CPWDateFrom=objCPW.CPWCPWDicDR.CPWDDateFrom
			Set objCPW.CPWDateTo=objCPW.CPWCPWDicDR.CPWDDateTo
		}
	}
	Do:objCPW'="" objCPW.%Close()
	Set return=objCPW
	Quit return
}

ClassMethod GetStringById(id As %String, separete As %String) As %String
{
	new (id,separete)
	set return=""
	set:$g(separete)="" separete=..#SEPARATE
	set obj=..GetObjById(id)
	if $IsObject(obj){
		set return=obj.%Id()_separete
		set return=return_obj.CPWActive_separete
		set TypeID="",TypeDesc=""
		if $IsObject(obj.CPWCPWTypeDR){
			set TypeID=obj.CPWCPWTypeDR.%Id()
			set TypeDesc=obj.CPWCPWTypeDR.CLPTDesc
		}
		set return=return_TypeID_separete
		set DateFrom=obj.CPWDateFrom
		set:DateFrom'="" DateFrom=$zd(DateFrom,3)
		set return=return_DateFrom_separete
		set DateTo=obj.CPWDateTo
		set:DateTo'="" DateTo=$zd(DateTo,3)
		set return=return_DateTo_separete
		set return=return_obj.CPWDesc_separete
		set return=return_obj.CPWCost_separete
		set return=return_obj.CPWDays_separete
		set return=return_obj.CPWICD_separete
		set return=return_obj.CPWLabel_separete
		set return=return_obj.CPWVarDesc_separete
		set return=return_obj.CPWVersion_separete
		set VerDate=obj.CPWVerDate
		set:VerDate'="" VerDate=$zd(VerDate,3)
		set return=return_VerDate_separete
		set VerTime=obj.CPWVerTime
		set:VerTime'="" VerTime=$zt(VerTime,1)
		set return=return_VerTime_separete
		set return=return_obj.CPWVerUserDR_separete
		set CPWDicID="",CPWDicDesc=""
		if $IsObject(obj.CPWCPWDicDR){
			set CPWDicID=obj.CPWCPWDicDR.%Id()
			set CPWDicDesc=obj.CPWCPWDicDR.CPWDDesc
		}
		set return=return_CPWDicID_separete
		
		set return=return_obj.CPWCode_separete
		set return=return_obj.CPWDesc_separete
		set return=return_TypeDesc_separete
		set return=return_CPWDicDesc_separete
	}
	quit return
}

/// Creator：     李宇峰
/// CreatDate：   2010-04-27
/// Description:  此Query是用来得到临床路径的全部记录
/// Table:        User.DHCMRCClinPathWays
/// Input：       argTypeID 临床路径类型
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.CliPathWay","GetPathWays","")
Query GetPathWays(argTypeID As %String) As %Query(ROWSPEC = "Rowid:%String,code:%String,desc:%String,active:%String,dateFrom:%String,dateTo:%String,type:%String,typeDesc:%String,cost:%String,CPWDays:%String,CPWICD:%String,CPWLabel:%String")
{
}

ClassMethod GetPathWaysExecute(ByRef qHandle As %Binary, argTypeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set:argTypeID<0 argTypeID=""
	Set CPWID=0
	For {
		Set CPWID=$o(^DHCMRC("CPW",CPWID))
		Quit:CPWID=""
		
		Set objCPW=..GetObjById(CPWID)
		If $IsObject(objCPW) {
			Set Code=objCPW.CPWCode
			Set Desc=objCPW.CPWDesc
			Set IsActive=objCPW.CPWActive
			Set IsActive=$s(IsActive["Y":"Yes",1:"No")
			Set DateFrom=objCPW.CPWDateFrom
			Set:DateFrom'="" DateFrom=$zd(DateFrom,3)
			Set DateTo=objCPW.CPWDateTo
			Set:DateTo'="" DateTo=$zd(DateTo,3)
			If $IsObject(objCPW.CPWCPWTypeDR) {
				Set TypeID=objCPW.CPWCPWTypeDR.%Id()
				Set TypeDesc=objCPW.CPWCPWTypeDR.CLPTDesc
				Continue:(argTypeID'="")&&(argTypeID'="0")&&(TypeID'=argTypeID)
				Continue:(argTypeID="0")&&(TypeID'="")
			}
			Set Cost=objCPW.CPWCost
			Set Days=objCPW.CPWDays
			Set ICD=objCPW.CPWICD
			Set Label=objCPW.CPWLabel
			
			Set Data=$lb(CPWID,Code,Desc,IsActive,DateFrom,DateTo,TypeID,TypeDesc,Cost,Days,ICD,Label)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	
	Quit $$$OK
}

ClassMethod GetPathWaysClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPathWaysExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetPathWaysFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPathWaysExecute ]
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

/// w ##class(web.DHCCPW.MRC.CliPathWay).CheckPathCode("201011050001",1)
ClassMethod CheckPathCode(argCode As %String, argCPWID As %String)
{
	New (argCode,argCPWID)
	Set return=0
	Quit:argCode="" return
	
	Set CPWID=0
	For {
		Set CPWID=$o(^DHCMRC("CPW",CPWID))
		Quit:(CPWID="")||(return=1)
		Continue:(argCPWID'="")&&(argCPWID=CPWID)
		Set objCPW=..GetObjById(CPWID)
		If $IsObject(objCPW){
			Set Code=objCPW.CPWCode
			Continue:argCode'=Code
			Set return=1
		}
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-11-01
/// Description:  增加或修改临床路径
/// Table：       User.DHCMRCClinPathWays
/// Input：       argInput: 临床路径信息
/// Return：      CPWID: 临床路径ID
/// w ##class(web.DHCCPW.MRC.CliPathWay).Update("")
ClassMethod Update(argInput As %String) As %String
{
	New (argInput)
	Set return=-1
	
	Set ID=$p(argInput,"^",1)
	If ID="" {
		Set obj=##class(User.DHCMRCClinPathWays).%New()
	} Else {
		Set obj=##class(User.DHCMRCClinPathWays).%OpenId(ID)
		Quit:obj="" return
	}
	
	Set CPWDID=$p(argInput,"^",2)
	Set objCPWDic=##class(web.DHCCPW.MRC.ClinPathWaysDicSrv).GetObjById(CPWDID)
	Quit:'$IsObject(objCPWDic) return
	Set LastVer=+$o(^DHCMRCi("CPW",0,"IndexClinPathWaysDicVer",CPWDID,""),-1)
	Set LastVer=$s(LastVer<0:1,1:LastVer+1)
	
	Set obj.CPWCode=objCPWDic.CPWDCode
	Set obj.CPWDesc=objCPWDic.CPWDDesc
	Set obj.CPWCPWTypeDR=objCPWDic.CPWDCPWTypeDR
	Set obj.CPWActive=objCPWDic.CPWDActive
	Set obj.CPWDateFrom=objCPWDic.CPWDDateFrom
	Set obj.CPWDateTo=objCPWDic.CPWDDateTo
	Set obj.CPWCost=$p(argInput,"^",3)               // 参考费用
	Set obj.CPWDays=$p(argInput,"^",4)               // 参考天数
	Set obj.CPWICD=$p(argInput,"^",5)                // 准入诊断ICD
	Set obj.CPWLabel=$p(argInput,"^",6)              // 准入提示
	Set obj.CPWVarDesc=$p(argInput,"^",7)            // 变异分析
	Set:obj.CPWVersion="" obj.CPWVersion=LastVer     // 版本信息
	Set obj.CPWCPWDicDR=objCPWDic                    // 临床路径字典
	Set obj.CPWOffShoot=$s($p(argInput,"^",8)="true":"Y",1:"N")       // 是否分支型临床路径 //add by wuqk 2011-07-21
	Set obj.CPWKeys=$p(argInput,"^",9)               // 准入诊断关键字
	Set obj.CPWOperICD=$p(argInput,"^",10)           // 准入手术ICD
	Set obj.CPWOperKeys=$p(argInput,"^",11)          // 准入手术关键字
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {                      //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Quit return
}

/// Creator：     LiYang
/// CreatDate：   2010-12-28
/// Description:  删除临床路径版本（打上删除标记）
/// Table：       User.DHCMRCClinPathWays
/// Input：       argInput: 临床路径信息
/// Return：      CPWID: 临床路径ID
/// w ##class(web.DHCCPW.MRC.CliPathWay).Delete(VerID)
ClassMethod Delete(VerID As %String) As %String
{
	New (VerID)
	Set return=-1
	
	Set obj=##class(User.DHCMRCClinPathWays).%OpenId(VerID)
	Quit:'$IsObject(obj) return
	Quit:obj.CPWVerUserDR'="" return
	
	Set sc = ##class(User.DHCMRCClinPathWays).%DeleteId(VerID)
	If $System.Status.IsError(sc) {                      //检查Delete是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Creator:李宇峰
/// CreatDate:2010-04-28
/// Description:GetPathByType方法是用来修改一个临床路径
/// Table:User.DHCMRCClinPathWays
ClassMethod GetPathByType(argType As %String)
{
	New (argType)
	Set return=""
	
	Set CPWID=0
	For {
		Set CPWID=$o(^DHCMRC("CPW",CPWID))
		Quit:CPWID=""
		Set objCPW=..GetObjById(CPWID)
		If $IsObject(objCPW){
			If $IsObject(objCPW.CPWCPWTypeDR){
				Set CPWTypeID=objCPW.CPWCPWTypeDR.%Id()
			}
			Set CPWDesc=objCPW.CPWDesc
			Set CPWActive=objCPW.CPWActive
			Set CPWDateFrom=objCPW.CPWDateFrom
			Set CPWDateTo=objCPW.CPWDateTo
			If CPWActive'["Y" {
				Set CPWDesc="(已停用)"_CPWDesc
			}Else{
				If (CPWDateFrom'="")&&(CPWDateFrom>+$h) {
					Set CPWDesc="(未启用)"_CPWDesc
				}
				If (CPWDateTo'="")&&(CPWDateTo<+$h) {
					Set CPWDesc="(未启用)"_CPWDesc
				}
			}
		}
		Continue:(argType="Other")&&($g(CPWTypeID)'="")||('$d(^DHCMRC("CLPT",CPWTypeID)))
		Continue:(argType'="Other")&&($g(CPWTypeID)'=argType)
		Set return=return_","_CPWID_"^"_$g(CPWDesc)
	}
	
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
}

/// Creator:李宇峰
/// CreatDate:2010-06-4
/// Description:GetPathNum得到以pathRowid为id号的记录是第几条记录。
/// Table:User.DHCMRCClinPathWays
/// w ##class(web.DHCCPW.MRC.CliPathWay).GetPathNum(9)
ClassMethod GetPathNum(argCPWID As %String)
{
	New (argCPWID)
	Set return=0
	Quit:argCPWID="" return
	
	Set CPWID=0,Flg=0,Num=0
	For {
		Set CPWID=$o(^DHCMRC("CPW",CPWID))
		Quit:(CPWID="")||(Flg=1)
		Set Num=Num+1
		Continue:CPWID'=argCPWID
		Set Flg=1
	}
	Set:Flg=1 return=Num
	
	Quit return
}

}
