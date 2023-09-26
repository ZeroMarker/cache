/// 名称: web.DHCCPW.MR.SysBaseSrv
/// 描述: 临床路径基础类
/// 编写者：zhufei
/// 编写日期: 2010-07-01
Class web.DHCCPW.MR.SysBaseSrv Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2010-07-01
/// Description:  查询科室/病区
/// Input：       Type(类型:E-执行科室,W-病区),LocID(关联科室:科室找病区或病区找科室)
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.SysBaseSrv","QryCTLoc","","E","")
Query QryCTLoc(argDesc As %String, argType As %String, argLocID As %String) As %Query(ROWSPEC = "CTLocID:%String,CTLocCode:%String,CTLocDesc:%String")
{
}

ClassMethod QryCTLocExecute(ByRef qHandle As %Binary, argDesc As %String, argType As %String, argLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	/* Note by zhaoyu 2013-03-13
	Set:argDesc'="" argDesc=$$ALPHAUP^SSUTIL4(argDesc)
	//^CTLOC({CTLOC_RowID})
	//^CTLOC({CT_Loc.CTLOC_RowID},"LINK",0,"Loc",{LINK_CTLOC_DR},{LINK_Childsub})
	Set CTLocID=0
	For {
		Set CTLocID=$o(^CTLOC(CTLocID))
		Quit:CTLocID=""
		Set tmp=$g(^CTLOC(CTLocID))
		Set CTLocCode=$p(tmp,"^",1)
		Set CTLocDesc=$p(tmp,"^",2)
		Set CTLocType=$p(tmp,"^",13)
		Continue:(argType'="")&&(CTLocType'=argType)
		Continue:(argLocID'="")&&'$d(^CTLOC(+argLocID,"LINK",0,"Loc",CTLocID))
		Set tmpLocDesc=$$ALPHAUP^SSUTIL4(CTLocDesc)
		Continue:(argDesc'="")&&(tmpLocDesc'[argDesc)
		Set:$p(CTLocDesc,"-",2)'="" CTLocDesc=$p(CTLocDesc,"-",2)
		Set Data=$lb(CTLocID,CTLocCode,CTLocDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	*/
	//******** Add by zhaoyu 2013-03-13
	//add by zf 20110808 增加医院判断
	Set tmp=argLocID
	Set argLocID=$p(tmp,"-",1)
	Set argHospID=$p(tmp,"-",2)
	
	Set:argDesc'="" argDesc=$$ALPHAUP^SSUTIL4(argDesc)
	//^CTLOC({CTLOC_RowID})
	//^CTLOC({CT_Loc.CTLOC_RowID},"LINK",0,"Loc",{LINK_CTLOC_DR},{LINK_Childsub})
	Set CTLocID=0
	For {
		Set CTLocID=$o(^CTLOC(CTLocID))
		Quit:CTLocID=""
		Set tmp=$g(^CTLOC(CTLocID))
		Set CTLocCode=$p(tmp,"^",1)
		Set CTLocDesc=$p(tmp,"^",2)
		Set CTLocType=$p(tmp,"^",13)
		Continue:(argType'="")&&(CTLocType'=argType)
		Continue:(argLocID'="")&&'$d(^CTLOC(+argLocID,"LINK",0,"Loc",CTLocID))
		Set tmpLocDesc=$$ALPHAUP^SSUTIL4(CTLocDesc)
		Continue:(argDesc'="")&&(tmpLocDesc'[argDesc)
		//add by zf 20110808 增加医院判断
		Set HospID=$p(tmp,"^",22)
		Continue:(argHospID'="")&&(HospID'=argHospID)
		//add by mxp 2013-02-21 判断该科室是否为指定的访问类型
		Continue:(argType="E")&&('$d(^PAC("ADMLOC",0,"AdmType","I",CTLocID)))
		Set:CTLocDesc["-" CTLocDesc=$p(CTLocDesc,"-",2)
		
		Set Data=$lb(CTLocID,CTLocCode,CTLocDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	//********************************************************
	
	Quit $$$OK
}

ClassMethod QryCTLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCTLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCTLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCTLocExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2010-12-04
/// Description:  取科室字典信息
/// Input：       
/// w ##Class(web.DHCCPW.MR.SysBaseSrv).GetLocByID(1,"$")
ClassMethod GetLocByID(argID As %String, argSeparete As %String) As %String
{
	New (argID,argSeparete)
	Set return=""
	Quit:argID="" return
	
	Set $ZT="GetLocByIDErr"
	Set:$g(argSeparete)="" argSeparete=..#SEPARATE
	
	Set objLoc=##Class(User.CTLoc).%OpenId(argID)
	If $IsObject(objLoc)
	{
		Set LocID=objLoc.%Id()
		Set LocCode=objLoc.CTLOCCode
		Set LocDesc=objLoc.CTLOCDesc
		If $p(LocDesc,"-",2)'="" {
			Set xLocDesc=$p(LocDesc,"-",2)
			Set:$l(xLocDesc)>1 LocDesc=xLocDesc
		}
		Set LocType=objLoc.CTLOCType
		
		Set return=LocID_argSeparete_LocCode_argSeparete_LocDesc_argSeparete_LocType
	}
	If objLoc'="" Do objLoc.%Close()
	
	Quit return
	
GetLocByIDErr
	Quit ""
}

/// Creator：     zhufei
/// CreatDate：   2010-07-01
/// Description:  查询临床路径字典
/// Input：       
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.SysBaseSrv","QryCPWType")
Query QryCPWType() As %Query(ROWSPEC = "CPWTypeID:%String,CPWTypeCode:%String,CPWTypeDesc:%String")
{
}

ClassMethod QryCPWTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set Data=$lb("","I","入径")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("","O","出径")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("","C","完成")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Quit $$$OK
}

ClassMethod QryCPWTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCPWTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWTypeExecute ]
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

/// 准入ICD范围检查方法
/// w ##Class(web.DHCCPW.MR.SysBaseSrv).CheckICDArea("D57 ","C00-D48,D98-E78,D57")
ClassMethod CheckICDArea(argICD As %String, argArea As %String) As %String
{
	New (argICD,argArea)
	Set return=-1
	Quit:(argArea="")||(argICD="") return
	
	Set argArea=$tr(argArea,"，",",")
	Set argArea=$tr(argArea,"－","-")
	Set argArea=$tr(argArea,"~","-")
	For Index=1:1:$l(argArea,",") {
		Set Area=$p(argArea,",",Index)
		Continue:Area=""
		Set Area1=$p(Area,"-",1)
		Set Area2=$p(Area,"-",2)
		If (Area1'="")&&(Area2'="") {
			Kill ICD,ICDO
			Set ICD(" "_Area1)=""
			Set ICD(" "_Area2)=""
			If $o(ICD(" "_Area1))="" {
				Set Areatmp=Area1
				Set Area1=Area2
				Set Area2=Areatmp
			}
			Set ICD=$o(ICD(" "_argICD),-1)
			Set ICDO=$e(ICD,2,$l(ICD))
			Set:(ICDO=Area1) return=1
			Set:(ICDO=Area2)&&($e(argICD,1,$l(Area2))=Area2) return=1
		} Else {
			Set:$e(argICD,1,$l(Area))=Area return=1
		}
	}
	
	Quit return
}

/// 准入关键词范围检查方法
/// w ##Class(web.DHCCPW.MR.SysBaseSrv).CheckKeysArea("CCC","AAA,BBB")
ClassMethod CheckKeysArea(argDiagDesc As %String, argArea As %String) As %String
{
	New (argDiagDesc,argArea)
	Set return=-1
	Quit:(argArea="")||(argDiagDesc="") return
	
	Set argArea=$tr(argArea,"，",",")
	Set argArea=$tr(argArea,"－","-")
	Set argArea=$tr(argArea,"~","-")
	Set argDiagDesc=$tr(argDiagDesc,"，",",")
	Set argDiagDesc=$tr(argDiagDesc,"－","-")
	Set argDiagDesc=$tr(argDiagDesc,"~","-")
	For Index=1:1:$l(argArea,",") {
		Set Area=$p(argArea,",",Index)
		Continue:Area=""
		Continue:argDiagDesc'[Area
		Set return=1
		Quit:return=1
	}
	
	Quit return
}

/// 取HIS诊断字典串
/// w ##Class(web.DHCCPW.MR.SysBaseSrv).GetMRCICDDX(5020)
ClassMethod GetMRCICDDX(argID As %String) As %String
{
	New (argID)
	Set return=""
	Quit:argID="" return
	Quit:'$d(^MRC("ID",argID)) return
	Set tmpICD=$g(^MRC("ID",argID))
	Set Code=$p(tmpICD,"^",1)
	Set Desc=$p(tmpICD,"^",2)
    Set ICD10=$p(tmpICD,"^",4)    //MRC_ICDDx.MRCID_ICD9CM_Code  对应维护界面：ICD10
    Set ICD9=$p(tmpICD,"^",35)    //MRC_ICDDx.MRCID_ICD9_Map     对应维护界面：ICD9
    Set Verion=""
    Set Resume=""
    Set IsActive="Yes"
    Set DateFrom=$p(tmpICD,"^",6)
    Set DateTo=$p(tmpICD,"^",7)
    Set return=argID_"^"_Code_"^"_Desc_"^"_ICD10_"^"_ICD9_"^"_Verion_"^"_Resume_"^"_IsActive_"^"_DateFrom_"^"_DateTo
	Set return=$tr(return,$c(13),"")
	Set return=$tr(return,$c(10),"")
	Set return=$tr(return,$c(0),"")
	Quit return
}

/// 获取Http服务器信息,Trakcare的服务器,不是Medtrak的服务器
/// w ##Class(web.DHCCPW.MR.SysBaseSrv).GetServerInfo()
ClassMethod GetServerInfo() As %String
{
	New
	Set return=""
	
	Set Config=##Class(websys.Configuration).%OpenId(1)
	If $IsObject(Config){
		Set CurrentNS=$ZNSPACE
		Set MEDDATA=Config.DataNamespace
	    Set LABDATA=Config.LabDataNamespace
	    Set DBServer=$p(Config.LayoutManager,":",2)
	    Set PrintPath=Config.PathToReports
	    If $zcvt(PrintPath,"U")'["HTTP" {
		    Set PrintPath=Config.URLToCrystalReports
	    }
	    //特殊情况打印模板路径走设置
	    Set PathToReports=##class(web.DHCCPW.MRC.BaseConfig).GetValueByCode("PathToReports")
		Set:PathToReports'="" PrintPath=PathToReports
		
	    Set LayOutManager=Config.LayoutManager
	    //获取CSP服务器的IP地址以及程序路径
	    Set WebServerAppURL = "http://"_Config.WebServer_Config.PathToApp
		// Set WebServerAppURL = "http://127.0.0.1"_Config.PathToApp
	}
	If Config'="" Do Config.%Close()
	
    Set return=$g(CurrentNS)_$c(1)_$g(MEDDATA)_$c(1)_$g(LABDATA)_$c(1)_$g(DBServer)_$c(1)_$g(PrintPath)_$c(1)_$g(LayOutManager)_$C(1)_$g(WebServerAppURL)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-12-08
/// Description:  查询医嘱子类字典
/// Input：       argDesc：别名  argType：医嘱大类ID
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.SysBaseSrv","QryARCItemSubCat","","5")
Query QryARCItemSubCat(argDesc As %String, argType As %String) As %Query(ROWSPEC = "SubCatID:%String,SubCatCode:%String,SubCatDesc:%String")
{
}

ClassMethod QryARCItemSubCatExecute(ByRef qHandle As %Binary, argDesc As %String, argType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set:argDesc'="" argDesc=$$ALPHAUP^SSUTIL4(argDesc)
	//^ARC("IC",{ARCIC_RowId})
	Set SubCatID=0
	For {
		Set SubCatID=$o(^ARC("IC",SubCatID))
		Quit:SubCatID=""
		Set tmp=$g(^ARC("IC",SubCatID))
		Set SubCatCode=$p(tmp,"^",1)
		Set SubCatDesc=$p(tmp,"^",2)
		Set SubCatType=$p(tmp,"^",8)
		Continue:(argType'="")&&(SubCatType'=argType)
		Set tmpSubCatDesc=$$ALPHAUP^SSUTIL4(SubCatDesc)
		Continue:(argDesc'="")&&(tmpSubCatDesc'[argDesc)
		
		Set Data=$lb(SubCatID,SubCatCode,SubCatDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryARCItemSubCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryARCItemSubCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryARCItemSubCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryARCItemSubCatExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2010-12-08
/// Description:  查询医嘱大类字典
/// Input：       argDesc：别名
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.SysBaseSrv","QryARCItemCat","")
Query QryARCItemCat(argDesc As %String) As %Query(ROWSPEC = "CatID:%String,CatCode:%String,CatDesc:%String")
{
}

ClassMethod QryARCItemCatExecute(ByRef qHandle As %Binary, argDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set:argDesc'="" argDesc=$$ALPHAUP^SSUTIL4(argDesc)
	//^OEC("ORCAT",{ORCAT_RowId})
	Set CatID=0
	For {
		Set CatID=$o(^OEC("ORCAT",CatID))
		Quit:CatID=""
		Set tmp=$g(^OEC("ORCAT",CatID))
		Set CatCode=$p(tmp,"^",1)
		Set CatDesc=$p(tmp,"^",2)
		Set tmpCatDesc=$$ALPHAUP^SSUTIL4(CatDesc)
		Continue:(argDesc'="")&&(tmpCatDesc'[argDesc)
		
		Set Data=$lb(CatID,CatCode,CatDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryARCItemCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryARCItemCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryARCItemCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryARCItemCatExecute ]
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

/// 字符串替换
ClassMethod ReplaceString(Str, OldStr, NewStr)
{
	n (Str, OldStr, NewStr)
	set intCounter = 1
	while (1)
	{
		set tmp =$e(Str, intCounter, intCounter + $l(OldStr) - 1) 
		if (tmp = OldStr)
		{
			 set $e(Str, intCounter, intCounter + $l(OldStr) - 1) = NewStr
			 set intCounter = intCounter + $l(NewStr) - $l(OldStr)
		}
		quit:intCounter>=$l(Str)
		set intCounter = intCounter + 1
	}
	quit Str
}

/// Description:  检查安全组对指定菜单操作是否有权限访问
///               是一个空方法
/// Input：       groupId  安全组Id
///               menuOperaId   菜单操作Id
/// Return：      1：有权限，0：无权限
ClassMethod CheckAuthority(groupId As %String, menuOperaId As %String)
{
	new (groupId, menuOperaId)
	set authority=0
	
	quit +authority
}

/// w ##Class(web.DHCCPW.MR.SysBaseSrv).Translate()
ClassMethod Translate(string As %String, identifier As %String, associator As %String) As %String
{
	New (string,identifier,associator)
	Set return=""
	Quit:(string="")||(identifier="")||(associator="") return
	
	For Ind=1:1:$l(string,identifier)
	{
		Set tmp=$p(string,identifier,Ind)
		If return="" {
			Set return=tmp
		}Else{
			Set return=return_associator_tmp
		}
	}
	
	Quit return
}

/// w ##class(web.DHCCPW.MR.SysBaseSrv).GetJsonById(1)
ClassMethod GetJsonById(aEpisodeID As %String, aPathWayID As %String) As %String
{
	New (aEpisodeID,aPathWayID)
	Set return=""
	
	Set Json="{PatName:'筱筱',Sex:'男'}"
	
	Set return=Json
	Quit return
}

/// 把字符串转换为大写
/// W ##Class(web.DHCCPW.MR.SysBaseSrv).ALPHAUP("600-4")
ClassMethod ALPHAUP(Alias)
{
	/* update by zf 20111216
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
	s ret=$$ALPHAUP^SSUTIL4(Alias)
	zn CurrentNS
	*/
	s ret=$$ALPHAUP^SSUTIL4(Alias)
	q ret
}

/// 与$ListFromString等价
/// w ##Class(web.DHCCPW.MR.SysBaseSrv).GetListFromString(Value,Char)
ClassMethod GetListFromString(Value As %String, Char As %String) As %List
{
	New (Value,Char)
	Set ret=""
	Set $ZT="GetListFromStringErr"
	Set:$g(Char)="" Char=","
	Set tmpVal="",tmpRet=""
	For Ind=1:1:$l(Value,Char)
	{
		Set tmpVal=$p(Value,Char,Ind)
		Set tmpRet=tmpRet_$listbuild(tmpVal)
	}
	Set ret=tmpRet
	Quit ret
GetListFromStringErr
   Quit ""
}

/// 与$ListToString等价
/// w ##Class(web.DHCCPW.MR.SysBaseSrv).GetListToString(Value,Char)
ClassMethod GetListToString(Value As %String, Char As %String) As %String
{
	New (Value,Char)
	Set ret=""
	Set $ZT="GetListToStringErr"
	Set:$g(Char)="" Char=","
	Set tmpVal="",tmpRet=""
	For Ind=1:1:$listlength(Value)
	{
		Set tmpVal=$listget(Value,Ind)
		Set tmpRet=tmpRet_Char_tmpVal
	}
	Set ret=$e(tmpRet,$l(Char)+1,$l(tmpRet))
	Quit ret
GetListToStringErr
   Quit ""
}

/// ##class(web.DHCCPW.MR.SysBaseSrv).GetInMedicare("",Paadm)
ClassMethod GetInMedicare(aPatientID As %String, aEpisodeID As %String)
{
	New (aPatientID,aEpisodeID)
	Set return=""
	
	If aEpisodeID'=""
	{
		Set PatientID=$p($g(^PAADM(+aEpisodeID)),"^",1)
		Set EpisodeID=aEpisodeID
	} Else {
		Set PatientID=aPatientID
		Set EpisodeID=""
	}
	
	Set GetInMedicareField=##class(web.DHCCPW.MRC.BaseConfig).GetValueByCode("GetInMedicareField")
	If GetInMedicareField="GovernCardNo"
	{
		Set return=$p($g(^PAPER(PatientID,"PER",4)),"^",4)
	} Else {
		Set return=$p($g(^PAPER(PatientID,"PAT",1)),"^",22)
	}
	
	Quit return
}

/// session['LOGON.SITECODE']='DHCHEALTH';
/// session['LOGON.USERID']='3879';
/// session['LOGON.GROUPID']='314';
/// session['LOGON.CTLOCID']='1595';
/// session['LOGON.HOSPID']='2';
/// w ##Class(web.DHCCPW.MR.SysBaseSrv).CopyPreferencesToCPWWF("DHCHEALTH",3879,314,1599,2)
ClassMethod CopyPreferencesToCPWWF(aSiteCode As %String, aSSUser As %String, aSSGroup As %String, aCTLoc As %String, aCTHospital As %String) As %String
{
	New (aSiteCode,aSSUser,aSSGroup,aCTLoc,aCTHospital)
	
	Set $ZT="CopyPreferencesToCPWWFErr"
	
	Set DocWFID=$o(^websys.WorkFlowI("UniqueNameIndex"," "_$ZCVT("DHC.Doc.OrderEntry","U"),0))
	If DocWFID="" {
		Set DocWFID=$o(^websys.WorkFlowI("UniqueNameIndex"," "_$ZCVT("DHC.EPR OP ListOrderEntry","U"),0))
	}
	Quit:DocWFID="" 0
	
	Set CPWWFID=$o(^websys.WorkFlowI("UniqueNameIndex"," "_$ZCVT("DHCCPW.OrderEntry","U"),0))
	Quit:CPWWFID="" 0
	
	If aSiteCode'=""
	{
		Set DocPreId=$o(^websys.PreferencesI("Index","SYS",aSiteCode,"ORDERW"_DocWFID,"OEOrder.PrefTabs.EditList",0))
		If DocPreId'=""
		{
			Set CPWPreID=$o(^websys.PreferencesI("Index","SYS",aSiteCode,"ORDERW"_CPWWFID,"OEOrder.PrefTabs.EditList",0))
			Set flg=..UpdateWebsysPreferences(DocPreId,CPWPreID,"ORDERW"_CPWWFID)
		}
		Set DocPreId=$o(^websys.PreferencesI("Index","SITE",aSiteCode,"ORDERW"_DocWFID,"OEOrder.PrefTabs.EditList",0))
		If DocPreId'=""
		{
			Set CPWPreID=$o(^websys.PreferencesI("Index","SITE",aSiteCode,"ORDERW"_CPWWFID,"OEOrder.PrefTabs.EditList",0))
			Set flg=..UpdateWebsysPreferences(DocPreId,CPWPreID,"ORDERW"_CPWWFID)
		}
	}
	
	If aCTLoc'=""
	{
		Set DocPreId=$o(^websys.PreferencesI("Index","User.CTLoc",aCTLoc,"ORDERW"_DocWFID,"OEOrder.PrefTabs.EditList",0))
		If DocPreId'=""
		{
			Set CPWPreID=$o(^websys.PreferencesI("Index","User.CTLoc",aCTLoc,"ORDERW"_CPWWFID,"OEOrder.PrefTabs.EditList",0))
			Set flg=..UpdateWebsysPreferences(DocPreId,CPWPreID,"ORDERW"_CPWWFID)
		}
	}
	
	If aCTHospital'=""
	{
		Set DocPreId=$o(^websys.PreferencesI("Index","User.CTHospital",aCTHospital,"ORDERW"_DocWFID,"OEOrder.PrefTabs.EditList",0))
		If DocPreId'=""
		{
			Set CPWPreID=$o(^websys.PreferencesI("Index","User.CTHospital",aCTHospital,"ORDERW"_CPWWFID,"OEOrder.PrefTabs.EditList",0))
			Set flg=..UpdateWebsysPreferences(DocPreId,CPWPreID,"ORDERW"_CPWWFID)
		}
	}
	
	If aSSUser'=""
	{
		Set DocPreId=$o(^websys.PreferencesI("Index","User.SSUser",aSSUser,"ORDERW"_DocWFID,"OEOrder.PrefTabs.EditList",0))
		If DocPreId'=""
		{
			Set CPWPreID=$o(^websys.PreferencesI("Index","User.SSUser",aSSUser,"ORDERW"_CPWWFID,"OEOrder.PrefTabs.EditList",0))
			Set flg=..UpdateWebsysPreferences(DocPreId,CPWPreID,"ORDERW"_CPWWFID)
		}
	}
	
	If aSSGroup'=""
	{
		Set DocPreId=$o(^websys.PreferencesI("Index","User.SSGroup",aSSGroup,"ORDERW"_DocWFID,"OEOrder.PrefTabs.EditList",0))
		If DocPreId'=""
		{
			Set CPWPreID=$o(^websys.PreferencesI("Index","User.SSGroup",aSSGroup,"ORDERW"_CPWWFID,"OEOrder.PrefTabs.EditList",0))
			Set flg=..UpdateWebsysPreferences(DocPreId,CPWPreID,"ORDERW"_CPWWFID)
		}
	}
	
	Quit 1
CopyPreferencesToCPWWFErr
	//w $ZError,!
	Set $ZT=""
	Quit -999
}

ClassMethod UpdateWebsysPreferences(aFromPreId As %String, aToPreId As %String, aAppKey As %String) As %String
{
	New (aFromPreId,aToPreId,aAppKey)
	Set return=0
	Quit:(aFromPreId="")||(aAppKey="") return
	
	Set $ZT="UpdateWebsysPreferencesErr"
	
	Set objFormPre=##Class(websys.Preferences).%OpenId(aFromPreId)
	Quit:'$IsObject(objFormPre) return
	Do objFormPre.%Close()
	
	If aToPreId=""
	{
		Set objToPre=##Class(websys.Preferences).%New()
	}Else{
		Set objToPre=##Class(websys.Preferences).%OpenId(aToPreId)
	}
	Quit:'$IsObject(objToPre) return
	
	Set objToPre.ObjectType=objFormPre.ObjectType
	Set objToPre.ObjectReference=objFormPre.ObjectReference
	Set objToPre.AppKey=aAppKey
	Set objToPre.AppSubKey=objFormPre.AppSubKey
	Set objToPre.Data=objFormPre.Data
	Set sc=objToPre.%Save()
	If $System.Status.IsError(sc) {                      //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=objToPre.%Id()
	}
	Do objToPre.%Close()
	Quit return
	
UpdateWebsysPreferencesErr
	w $ZError,!
	Set $ZT=""
	Quit -999
}

/// 取患者安床时间（安床时间作为入院时间）
/// w ##Class(web.DHCCPW.MR.SysBaseSrv).GetAdmDate(4)
ClassMethod GetAdmDate(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set xTransID=0
	For {
		Set xTransID=$o(^PAADM(aEpisodeID,"TRANS",xTransID))
		Quit:xTransID=""
		
		Set TransLoc=$p($g(^PAADM(aEpisodeID,"TRANS",xTransID)),"^",8)  //取床位字段
		Continue:TransLoc=""
		Set TransDate=$p($g(^PAADM(aEpisodeID,"TRANS",xTransID)),"^",1)
		Set TransTime=$p($g(^PAADM(aEpisodeID,"TRANS",xTransID)),"^",2)
		Set return=TransDate_","_TransTime
	}
	
	Quit return
}

}
