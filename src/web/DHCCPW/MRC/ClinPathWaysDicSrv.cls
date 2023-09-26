/// 创建者：李阳
/// 创建日期：2010-12-14
/// 临床路径字典处理
Class web.DHCCPW.MRC.ClinPathWaysDicSrv Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2010-10-29
/// Description:  根据ID取临床路径字典
/// Table：       User.DHCMRCClinPathWaysDic
/// Input：       ID:    User.DHCMRCClinPathWaysDic.Id
/// Return：      返回object
/// w ##class(web.DHCCPW.MRC.ClinPathWaysDicSrv).GetObjById(1)
ClassMethod GetObjById(argId As %String) As User.DHCMRCClinPathWaysDic
{
	New (argId)
	Set return=##Class(User.DHCMRCClinPathWaysDic).%OpenId(argId)
	Do:return'="" return.%Close()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-10-29
/// Description:  根据ID取临床路径字典
/// Table：       User.DHCMRCClinPathWaysDic
/// Input：       ID:    User.DHCMRCClinPathWaysDic.Id
/// Return：      返回String
/// w ##class(web.DHCCPW.MRC.ClinPathWaysDicSrv).GetStringById(1)
ClassMethod GetStringById(id As %String, separete As %String) As %String
{
	New (id,separete)
	Set return="",strCPWD=""
	
	Set:$g(separete)="" separete=..#SEPARATE
	Set obj=..GetObjById(id)
	If $IsObject(obj){
		Set ID=obj.%Id()
		Set Code=obj.CPWDCode
		Set Desc=obj.CPWDDesc
		Set TypeDR="",TypeDesc=""
		If $IsObject(obj.CPWDCPWTypeDR){
			set TypeDR=obj.CPWDCPWTypeDR.%Id()
			set TypeDesc=obj.CPWDCPWTypeDR.CLPTDesc
		}
		Set Active=$s(obj.CPWDActive["Y":"Yes",1:"No")
		Set DateFrom=obj.CPWDDateFrom
		Set:DateFrom'="" DateFrom=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DateFrom)
		Set DateTo=obj.CPWDDateTo
		Set:DateTo'="" DateTo=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DateTo)
		Set Version=obj.CPWDVersion
		Set IsOpCPW=$s(obj.CPWDIsOpCPW["Y":"Yes",1:"No")
		
		Set strCPWD=ID_separete
		Set strCPWD=strCPWD_Code_separete
		Set strCPWD=strCPWD_Desc_separete
		Set strCPWD=strCPWD_TypeDR_separete
		Set strCPWD=strCPWD_Active_separete
		Set strCPWD=strCPWD_DateFrom_separete
		Set strCPWD=strCPWD_DateTo_separete
		Set strCPWD=strCPWD_Version_separete
		Set strCPWD=strCPWD_TypeDesc
		Set strCPWD=strCPWD_separete_IsOpCPW
	}
	
	Set return=strCPWD
	Quit return
}

ClassMethod IsExistsCPWD(argName As %String) As %String
{
	New (argName)
	Set return=0
	Quit:argName="" return
	Set CPWDID=0
	For {
		Set CPWDID=$o(^DHCMRC("CPWD",CPWDID))
		Quit:CPWDID=""
		Quit:return>0
		Set objCPWD=##class(web.DHCCPW.MRC.ClinPathWaysDicSrv).GetObjById(CPWDID)
		Continue:'$IsObject(objCPWD)
		Continue:objCPWD.CPWDDesc'=argName
		Set return=CPWDID
	}
	Quit return
}

/// Creator：     LiYang
/// CreatDate：   2010-12-14
/// Description:  更新临床路径字典
/// Table：       User.DHCMRCClinPathWaysDic
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:MenuCode 3:MenuCaption 4:LinkUrl 5:Expression 6:ProductDr 7:ShowIndex 8:IconClass 9:ParentMenuDr
/// w ##Class(web.DHCCPW.MRC.ClinPathWaysDicSrv).Update("13^201011050013^特发性血小板减少性紫癜^6^Y^2010-11-05^^","201011050013","特发性血小板减少性紫癜")
ClassMethod Update(InStr, Code, Desc) As %String
{
	New (InStr,Code, Desc)
	Set return=-1
	
	Set ID=$p(InStr,"^",1)
	Set tmpID=..IsExistsCPWD($p(InStr,"^",3))
	Set:tmpID>0 ID=tmpID
	If ID="" {
		Set obj=##class(User.DHCMRCClinPathWaysDic).%New()
	}Else{
		Set obj=##class(User.DHCMRCClinPathWaysDic).%OpenId(ID)
		Quit:obj="" return
	}
	Set obj.CPWDCode=$p(InStr,"^",2)
	Set obj.CPWDDesc=$p(InStr,"^",3)
	Set objPathType=##class(web.DHCCPW.MRC.PathWayType).GetObjById($p(InStr,"^",4))
	Set obj.CPWDCPWTypeDR=objPathType
	Set obj.CPWDActive=$p(InStr,"^",5)
	Set DateFrom=$p(InStr,"^",6)
	;Set:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	;Set:DateFrom["/" DateFrom=$zdh(DateFrom,4)
	Set:DateFrom'="" DateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(DateFrom)
	Set DateTo=$p(InStr,"^",7)
	;Set:DateTo["-" DateTo=$zdh(DateTo,3)
	;Set:DateTo["/" DateTo=$zdh(DateTo,4)
	Set:DateTo'="" DateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(DateTo)
	Set obj.CPWDDateFrom=DateFrom
	Set obj.CPWDDateTo=DateTo
	Set:$p(InStr,"^",8)'="" obj.CPWDVersion=$p(InStr,"^",8)  //更新临床路径字典时不更新当前版本
	Set obj.CPWDIsOpCPW=$p(InStr,"^",9)
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

/// 
/// 查询所有临床路径字典
/// 增加参数：                ///by wuqk 2011-07-21
///     noSyndrome : 是否包含并发症类型，默认为空，包含；为N，不包含
///     IsActive   : 路径是否生效
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.ClinPathWaysDicSrv","QryClinPathWayDic")
Query QryClinPathWayDic(noSyndrome As %String, IsActive As %String, CPWDDesc As %String = "", LocID As %String = "Null", CPWType As %String = "") As %Query(ROWSPEC = "ID:%String,Code:%String:代码,Desc:%String:描述,TypeID:%String:路径类型ID,TypeDesc:%String:临床路径类型,IsActive:%String:生效,DateFrom:%String:生效日期,DateTo:%String:废止日期,CurrVersion:%String:当前版本,IsOpCPW:%String:是否门诊临床路径")
{
}

ClassMethod QryClinPathWayDicExecute(ByRef qHandle As %Binary, noSyndrome As %String, IsActive As %String, CPWDDesc As %String = "", LocID As %String = "Null", CPWType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set noSyndrome=$g(noSyndrome)
	Set IsActive=$g(IsActive)
	
	If $d(^PAC("ADMLOC",0,"AdmType","I",LocID)) {
		Set LocType="No"
	} ElseIf $d(^PAC("ADMLOC",0,"AdmType","O",LocID)) {
		Set LocType="Yes"
	} Else {
		Set LocType="Err"
	}
	Set:(LocID="Null") LocType=""
	
	Set CPWDID=0
	For {
		Set CPWDID=$o(^DHCMRC("CPWD",CPWDID))
		Quit:CPWDID=""
		
		Set objCPWD=..GetObjById(CPWDID)
		If $IsObject(objCPWD){
			Set Code=objCPWD.CPWDCode
			Set Desc=objCPWD.CPWDDesc
			Continue:(CPWDDesc'="")&&(Desc'[CPWDDesc)
			Set (TypeID,TypeDesc)=""
			If $IsObject(objCPWD.CPWDCPWTypeDR){
				Set TypeID=objCPWD.CPWDCPWTypeDR.%Id()
				continue:(CPWType'="")&&(TypeID'=CPWType)
				// add by wuqk 2011-07-21 科室临床路径维护模块，过滤并发症
				continue:(noSyndrome="N")&&(objCPWD.CPWDCPWTypeDR.CLPTCode="SYNDROME")   
				Set TypeDesc=objCPWD.CPWDCPWTypeDR.CLPTDesc
			}
			Set Active=$s(objCPWD.CPWDActive["Y":"Yes",1:"No")
			Continue:(IsActive'="")&(Active'[IsActive)  //add by wuqk 2011-11-17
			Set IsOpCPW=$s(objCPWD.CPWDIsOpCPW["Y":"Yes",1:"No")
			Continue:(LocType'="")&&(LocType'=IsOpCPW)
			Set DateFrom=objCPWD.CPWDDateFrom
			Set DateTo=objCPWD.CPWDDateTo
			Continue:(IsActive["Y")&&(DateFrom'="")&&(DateFrom>+$h)
			Continue:(IsActive["Y")&&(DateTo'="")&&(DateTo<+$h)
			Set:DateFrom'="" DateFrom=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DateFrom)
			Set:DateTo'="" DateTo=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DateTo)
			Set Version=""
			set verID=objCPWD.CPWDVersion
			set objVer=##class(web.DHCCPW.MRC.CliPathWay).GetObjById(verID) //Add By LiYang FixBug:72 临床路径类别列表中显示的是ID，不是版本号
			if ($IsObject(objVer))
			{
				Set PublicDate=objVer.CPWVerDate
				;Set:PublicDate'="" PublicDate=$zd(PublicDate,3)
				Set:PublicDate'="" PublicDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(PublicDate)
				Set Version="V"_objVer.CPWVersion _ ".0 " _ PublicDate
				d objVer.%Close()			
				k objVer
			}
			Set Data=$lb(CPWDID,Code,Desc,TypeID,TypeDesc,Active,DateFrom,DateTo,Version,IsOpCPW)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryClinPathWayDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryClinPathWayDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryClinPathWayDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryClinPathWayDicExecute ]
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

/// Add By LiYang 2011-02-26,Modified By LiYang 2011-05-22 
/// 判断临床路径字典是否重复
/// 参数:
///    Code：临床路径字典代码
///    Desc: 临床路径字典描述
/// 返回值：如果Code 值重复，返回1，否则返回0
///  Update By NiuCaicai 2011-07-22 FixBug:90 临床路径维护--基础信息维护-临床路径字典-通过修改已存在的路径纪录可重复添加相同的临床路径
///  返回值：返回一个字符串，供 Update(InStr,Code, Desc) 调用
ClassMethod IsClinPathWayDicExists(Code, Desc)
{
	/*
	n (Code,Desc)
	s ret=0
	s rowid="" f  s rowid=$o(^DHCMRC("CPWD",rowid)) q:rowid=""  d
	.s obj=##class(User.DHCMRCClinPathWaysDic).%OpenId(rowid)
	.q:obj=""
	.d obj.%Close()
	.s:obj.CPWDCode=Code ret=1
	.s:obj.CPWDDesc=Desc ret=1
	.k obj
	q ret
	*/
	n (Code,Desc)
	s ret1=0
	s ret2=0
	s codeSID=0
	s descSID=0
	s rowid="" f  s rowid=$o(^DHCMRC("CPWD",rowid)) q:rowid=""  d
	.s obj=##class(User.DHCMRCClinPathWaysDic).%OpenId(rowid)
	.q:obj=""
	.d obj.%Close()
	.if (obj.CPWDCode=Code) do  
	 ..s ret1=ret1+1
	 ..s codeSID=rowid
	.if (obj.CPWDDesc=Desc) do
	 ..s ret2=ret2+1
	 ..s descSID=rowid
	.k obj 
	.q:(ret1=1)!(ret2=1)                                      //有一次重复时退出，去做判断
	q ret1_"^"_ret2_"^"_codeSID_"^"_descSID
}

/// Creator：     赵宇
/// CreatDate：   2013-04-26
/// Description:  检查CPWDCode是否重复  临床路径定义-新增记录（代码、描述和界面中的某记录重复），修改原来记录信息 244
/// Table：       DHC_MRC_ClinPathWaysDic
/// Input：       DHC_MRC_ClinPathWaysDic.Id
/// Return：      如果重复：返回1，不重复：返回0
/// w ##class(web.DHCCPW.MRC.ClinPathWaysDicSrv).CheckCPWDicCode("")
ClassMethod CheckCPWDicCode(argStr As %String) As %String
{
	New (argStr)
	Set return=0
	Set argStr=$g(argStr),argRowid=$p(argStr,"^",1),argCode=$p(argStr,"^",2)
	Quit:(argStr="")||(argCode="") return
	// ^DHCMRC("CPWD",1)
	Set CPWDicRowid=""
	For {
		Set CPWDicRowid=$o(^DHCMRC("CPWD",CPWDicRowid))
		Quit:(CPWDicRowid="")||(return=1)
		Set objCPWDic=..GetObjById(CPWDicRowid)
		Set CPWDCode=objCPWDic.CPWDCode
		Continue:(argRowid'="")&&(argRowid=CPWDicRowid)
		Continue:CPWDCode'=argCode
		Set return=1
	}
	Quit return
}

}
