/// 名称: DHCMed.NINFService.Srv.CommonCls
/// 描述: 公用方法
/// 编写者：zhufei
/// 编写日期: 2012-05-16
Class DHCMed.NINFService.Srv.CommonCls Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// 把字符串转换为大写
/// w ##Class(DHCMed.NINFService.Srv.CommonCls).ALPHAUP()
ClassMethod ALPHAUP(Alias)
{
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
	s ret=$$ALPHAUP^SSUTIL4(Alias)
	zn CurrentNS
	q ret
}

/// 页面显示 按照配置转换日期格式
ClassMethod ChangeDateFormatToHtml(aValue As %String) As %String
{
	New (aValue,aFormat)
	Set return=""
	Quit:aValue="" return
	Set:aValue["-" aValue=$zdh(aValue,3)
	Set return=##class(DHCMed.SSService.CommonCls).DateLogicalToHtml(aValue)
	Quit return
}

/// 转换日期格式
/// w ##Class(DHCMed.NINFService.Srv.CommonCls).ChangeDateFormat(+$h,3)
ClassMethod ChangeDateFormat(aValue As %String, aFormat As %String = "3") As %String
{
	New (aValue,aFormat)
	Set return=""
	Quit:aValue="" return
	Set aFormat=+aFormat
	Quit:(aFormat'=3)&&(aFormat'=4) return
	Set:aValue["-" aValue=$zdh(aValue,3)
	Set:aValue["/" aValue=$zdh(aValue,4)
	Set return=$zd(aValue,aFormat)
	Quit return
}

/// 转换时间格式
/// w ##Class(DHCMed.NINFService.Srv.CommonCls).ChangeTimeFormat($p($h,",",2),1)
ClassMethod ChangeTimeFormat(aValue As %String, aFormat As %String = "1") As %String
{
	New (aValue,aFormat)
	Set return=""
	Quit:aValue="" return
	Set aFormat=+aFormat
	Quit:(aFormat'=1)&&(aFormat'=2) return
	Set:aValue[":" aValue=$zth(aValue,1)
	Set return=$zt(+aValue,aFormat)
	Quit return
}

/// w ##class(DHCMed.NINFService.Srv.CommonCls).GetEpisodeID(4939742)
ClassMethod GetEpisodeID(argMRAdm As %String) As %String
{
	New (argMRAdm)
	Set return=$p($g(^MR(+argMRAdm,"PRO",1)),"^",9)
	Quit return
}

/// w ##class(DHCMed.NINFService.Srv.CommonCls).GetMRAdm(4939148)
ClassMethod GetMRAdm(argEpisodeID As %String) As %String
{
	New (argEpisodeID)
	Set return=$p($g(^PAADM(+argEpisodeID)),"^",61)
	Quit return
}

/// w ##Class(DHCMed.NINFService.Srv.CommonCls).GetDicsByType("OperationType")
ClassMethod GetDicsByType(aType As %String, aActive As %String = "1") As %String
{
	New (aType,aActive)
	Set return=""
	
	Set aType=$ZCVT($g(aType),"U")
 	Set RowID=0
 	For {
	 	Set RowID=$o(^DHCMed.SS.DictionaryI("IdxofType"," "_aType,RowID))
	 	Quit:RowID=""
	 	Set objDic=##class(DHCMed.SS.Dictionary).%OpenId(RowID)
		If $IsObject(objDic){
		 	Set Code=objDic.Code
			Set Description=objDic.Description
			Set Type=objDic.Type
			Continue:(aType'="")&&(aType'=$ZCVT($g(Type),"U"))
			Set Active=objDic.Active
			Continue:(aActive'="")&&(Active'=aActive)
			If (Active="1"){
				Set Active="Yes"  
			}Else{
			  	Set Active="No"
			}
			Set HospitalDr=objDic.HospitalDr
			Set HispsDescs=$p($g(^CT("HOSP",+HospitalDr)),"^",2)
			Set DateFrom=objDic.DateFrom
			Set DateTo=objDic.DateTo
			If (DateFrom'=""){
				Set DateFrom=$zd(DateFrom,1)
			}
			If (DateTo'=""){
		    	Set DateTo=$zd(DateTo,1)
			}
			
			Set return=return_RowID_$c(2)_Description_$c(1)
		}
		If objDic'="" Do objDic.%Close()
	}
	Set:return'="" return=$e(return,1,$l(return)-1)
	
	Quit return
}

/// w ##Class(DHCMed.NINFService.Srv.CommonCls).GetDicIDByDesc(argType,argDesc)
ClassMethod GetDicIDByDesc(argType As %String, argDesc As %String) As %String
{
	New (argType,argDesc)
	Set return=""
	Quit:(argType="")||(argDesc="") return
	
	Set Rowid=""
	For {
		Set Rowid=$o(^DHCMed.SS.DictionaryI("IndexTypeDesc"," "_$ZCVT(argType,"U")," "_$ZCVT(argDesc,"U"),Rowid))
		Quit:Rowid=""
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(Rowid)
		Continue:'$IsObject(objDic)
		Set IsActive=objDic.Active
		Continue:IsActive'=1
		Set Desc=objDic.Description
		Continue:argDesc'=Desc
		Set return=Rowid
	}
	Quit return
}

/// Creator：     wuwj
/// CreatDate：   2010-04-14
/// Description:  查询所有的字典或者字典项
/// Table：       DHCMed.SS.Dictionary
/// Input：       
/// output:       所有的字典或者某一个字典项      
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Srv.CommonCls","QryDictionary","EpidemicNotAdmToGo")
Query QryDictionary(aDicType As %String, aAddItem As %String = "") As %Query(ROWSPEC = "DicRowId:%String,DicCode:%String,DicDesc:%String")
{
}

ClassMethod QryDictionaryExecute(ByRef qHandle As %Binary, aDicType As %String, aAddItem As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set aDicType=$ZCVT(aDicType,"U")
 	Quit:aDicType="" $$$OK
 	
 	//add by zf 20130225 增加附加选项
	If aAddItem'="" {
		Set addItemCode=$p(aAddItem,"^",1)
		Set addItemDesc=$p(aAddItem,"^",2)
		Set Data=$lb(addItemCode,addItemCode,addItemDesc)
    	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
 	Set DicRowID=0
 	For {
	 	Set DicRowID=$o(^DHCMed.SS.DictionaryI("IdxofType"," "_aDicType,DicRowID))
	 	Quit:DicRowID=""
	 	
	 	Set objDic=##class(DHCMed.SS.Dictionary).%OpenId(DicRowID)
		If $IsObject(objDic){
		 	Set DicCode=objDic.Code
			Set DicDesc=objDic.Description
			Set DicType=objDic.Type
			Continue:(aDicType'="")&&(aDicType'=$ZCVT(DicType,"U"))
			Set DicActive=objDic.Active
			Continue:DicActive'=1
			
			Set Data=$lb(DicRowID,DicCode,DicDesc)
	        Set ^CacheTemp(repid,ind)=Data
	        Set ind=ind+1
		}
		If objDic'="" Do objDic.%Close()
	}
	
	Quit $$$OK
}

ClassMethod QryDictionaryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDictionaryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDictionaryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDictionaryExecute ]
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

/// 查询科室列表
/// d ##Class(%ResultSet).RunQuery("DHCMed.NINFService.Srv.CommonCls","QueryLoction","","","","E","I")
Query QueryLoction(aAlias As %String, aDepGroup As %String, aLinkLoc As %String, aLocType As %String, aAdmType As %String = "", aAddItem As %String = "") As %Query(ROWSPEC = "LocRowId:%String,LocDesc:%String,LocDesc1:%String")
{
}

ClassMethod QueryLoctionExecute(ByRef qHandle As %Binary, aAlias As %String, aDepGroup As %String, aLinkLoc As %String, aLocType As %String, aAdmType As %String, aAddItem As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:aLocType'="" aLocType=$ZCVT($g(aLocType),"U")
	Set:aAdmType'="" aAdmType=$ZCVT($g(aAdmType),"U")
	
 	//add by zf 20130225 增加附加选项
	If (aAddItem'="")&&(aAlias="") {
		Set addItemCode=$p(aAddItem,"^",1)
		Set addItemDesc=$p(aAddItem,"^",2)
		Set Data=$lb(addItemCode,addItemCode,addItemDesc)
    	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Set lnkLocType=""
	If aLinkLoc'="" {
		Set lnkLocType=$p($g(^CTLOC(aLinkLoc)),"^",13)
		Set:(lnkLocType'="E")&&(lnkLocType'="W") lnkLocType=aLocType
	}
	
	Set LocID=0
	For {
		Set LocID=$o(^CTLOC(LocID))
		Quit:LocID=""
		Set tmpLoc=$g(^CTLOC(LocID))
		Set LocDesc=$p(tmpLoc,"^",2)
		Set LocDep=$p(tmpLoc,"^",19)
		Set LocType=$p(tmpLoc,"^",13)
		Continue:(aAlias'="")&&($zcvt(LocDesc,"U")'[$zcvt(aAlias,"U"))           //别名
		Continue:(aDepGroup'="")&&(LocDep'=aDepGroup)                            //部门组
		Continue:(aLocType'="")&&(LocType'=aLocType)                             //科室类型
		//Continue:(aLinkLoc'="")&&('$d(^CTLOC(+aLinkLoc,"LINK",0,"Loc",LocID)))   //关联科室
		Continue:(aLinkLoc'="")&&(aLocType'=lnkLocType)&&('$d(^CTLOC(+aLinkLoc,"LINK",0,"Loc",LocID)))   //关联科室
		
		//add by zf 20130225 增加科室按门诊、住院、急诊分类的过滤
		If (aLocType'="W")&&(aAdmType'="") {
			Continue:'$d(^PAC("ADMLOC",0,"AdmType",aAdmType,LocID))
		}
		
		Set LocDesc1=LocDesc
		Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
		
		Set Data=$lb(LocID,LocDesc,LocDesc1)
    	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QueryLoctionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLoctionExecute ]
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

ClassMethod QueryLoctionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLoctionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2012-05-12
/// Description:  查询诊断字典 By别名
/// Table：       MRC_ICDDx
/// Input:        aAlias
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Srv.CommonCls","QryICDDxByAlias","hl")
Query QryICDDxByAlias(aAlias As %String) As %Query(ROWSPEC = "ICDRowID:%String,ICD10:%String,ICDDesc:%String")
{
}

ClassMethod QryICDDxByAliasExecute(ByRef qHandle As %Binary, aAlias As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aAlias=$zcvt(aAlias,"U")
	Quit:aAlias="" $$$OK
	
	Set ZIndex=$zn,JIndex=$j,NIndex="QryICDDxByAlias"
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	Set Count=0
	Set xAlias=$o(^MRC("ID",0,"ALIAS",aAlias),-1)
	For {
		Set xAlias=$o(^MRC("ID",0,"ALIAS",xAlias))
		Quit:xAlias=""
		Quit:$e(xAlias,1,$l(aAlias))'=aAlias
		
		Set ICDRowID=0
		For {
			Set ICDRowID=$o(^MRC("ID",0,"ALIAS",xAlias,ICDRowID))
			Quit:ICDRowID=""
			
			Continue:$d(^TMP(ZIndex,JIndex,NIndex,ICDRowID))
			
			Set tmp=$g(^MRC("ID",ICDRowID))
			Continue:tmp=""
			Set ICDCode=$p(tmp,"^",1)
			Set ICDDesc=$p(tmp,"^",2)
			Set ICD10=$p(tmp,"^",4)
			
			Set Count=Count+1
			Set ^TMP(ZIndex,JIndex,NIndex,ICDRowID)=""
			
			Set Data=$lb(ICDRowID,ICDCode,ICDDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Set xDesc=$o(^MRC("ID",0,"Desc",aAlias),-1)
	For {
		Set xDesc=$o(^MRC("ID",0,"Desc",xDesc))
		Quit:xDesc=""
		Quit:$e(xDesc,1,$l(aAlias))'=aAlias
		
		Set ICDRowID=0
		For {
			Set ICDRowID=$o(^MRC("ID",0,"Desc",xDesc,ICDRowID))
			Quit:ICDRowID=""
			
			Continue:$d(^TMP(ZIndex,JIndex,NIndex,ICDRowID))
			
			Set tmp=$g(^MRC("ID",ICDRowID))
			Continue:tmp=""
			Set ICDCode=$p(tmp,"^",1)
			Set ICDDesc=$p(tmp,"^",2)
			Set ICD10=$p(tmp,"^",4)
			
			Set Count=Count+1
			Set ^TMP(ZIndex,JIndex,NIndex,ICDRowID)=""
			
			Set Data=$lb(ICDRowID,ICDCode,ICDDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Set ICDRowID=0
	For {
		Set ICDRowID=$o(^MRC("ID",ICDRowID))
		Quit:ICDRowID=""
		Quit:Count>50
		
		Continue:$d(^TMP(ZIndex,JIndex,NIndex,ICDRowID))
		
		Set tmp=$g(^MRC("ID",ICDRowID))
		Continue:tmp=""
		Set ICDCode=$p(tmp,"^",1)
		Set ICDDesc=$p(tmp,"^",2)
		Set ICD10=$p(tmp,"^",4)
		Continue:$zcvt(ICDDesc,"U")'[aAlias
		
		Set Count=Count+1
		Set ^TMP(ZIndex,JIndex,NIndex,ICDRowID)=""
		
		Set Data=$lb(ICDRowID,ICDCode,ICDDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	Quit $$$OK
}

ClassMethod QryICDDxByAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryICDDxByAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryICDDxByAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryICDDxByAliasExecute ]
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

/// 查询手术列表
/// d ##Class(%ResultSet).RunQuery("DHCMed.NINFService.Srv.CommonCls","QueryOperation","")
Query QueryOperation(aAlias As %String) As %Query(ROWSPEC = "OperRowId:%String,OperDesc:%String,OperCM3:%String")
{
}

ClassMethod QueryOperationExecute(ByRef qHandle As %Binary, aAlias As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aAlias=##Class(DHCMed.NINFService.Srv.CommonCls).ALPHAUP(aAlias)
	Quit:aAlias="" $$$OK
	
	Set Count=0
	//^ORC("OPER",0,"ALIAS",$$ALPHAUP({ALIAS_Text}),{ORC_Operation.OPER_RowId},{ALIAS_Childsub})
	Set xAlias=$o(^ORC("OPER",0,"ALIAS",aAlias),-1)
	For {
		Set xAlias=$o(^ORC("OPER",0,"ALIAS",xAlias))
		Quit:xAlias=""
		Quit:$e(xAlias,1,$l(aAlias))'=aAlias
		
		Set OperRowId=0
		For {
			Set OperRowId=$o(^ORC("OPER",0,"ALIAS",xAlias,OperRowId))
			Quit:OperRowId=""
			Set tmpOperation=$g(^ORC("OPER",OperRowId))
			Set OperDesc=$p(tmpOperation,"^",2)
			Set OperCM3=$p(tmpOperation,"^",21)
			
			Set Count=Count+1
			Quit:Count>50
			
			Set Data=$lb(OperRowId,OperDesc,OperCM3)
	    	Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QueryOperationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOperationExecute ]
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

ClassMethod QueryOperationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOperationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-19
/// Description:  查询病人所有诊断的信息
/// Table：       DHCMed.INF.InfDiagnose
/// Input：       Alias ： 别名
/// output:       符合条件的项            
/// Return：      1:Rowid 2:Code 3:Name 4:CtlocDr 5:CtlocDesc 6:SSGroupDr 7:SSGroupDesc 8:CtpcpDr
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Srv.CommonCls","QryUserByAlias","58008")
Query QryUserByAlias(Alias As %String = "") As %Query(ROWSPEC = "Rowid:%String,Code:%String,Name:%String,CtlocDr:%String,CtlocDesc:%String,SSGroupDr:%String,SSGroupDesc:%String,CtpcpDr:%String")
{
}

ClassMethod QryUserByAliasExecute(ByRef qHandle As %Binary, Alias As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set Alias=$ZCVT(Alias,"U")
 	Set UserID=0
 	For {
		Set UserID=$o(^SSU("SSUSR",UserID))
		Quit:UserID=""
		
		Set UserCode=$p($g(^SSU("SSUSR",+UserID)),"^",1)
		Set UserName=$p($g(^SSU("SSUSR",+UserID)),"^",2)
		Set UserAlias=$p($g(^SSU("SSUSR",+UserID)),"^",11)
		//add by wuqk 2012-1-18 能根据医护人员拼音码查询
		Set CTPCP=+$p($g(^SSU("SSUSR",+UserID)),"^",14)
		Set CTPCPOtherName=""
		Set:CTPCP>0 CTPCPOtherName=$p($g(^CTPCP(CTPCP,3)),"^",28)  //CTPCPOtherName
		Continue:($ZCVT(UserCode,"U")'[Alias)&&($ZCVT(UserName,"U")'[Alias)&&($ZCVT(UserAlias,"U")'[Alias)&&($ZCVT(CTPCPOtherName,"U")'[Alias)
		
		Set xUserInfo=##Class(DHCMed.Base.SSUser).GetStringById(+UserID)
		Continue:xUserInfo=""
		Set Data=$lb("")
		For iBuild=1:1:$l(xUserInfo,"^")
		{
			Set $li(Data,iBuild)=$p(xUserInfo,"^",iBuild)
		}
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryUserByAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryUserByAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryUserByAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryUserByAliasExecute ]
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

/// Creator：     pylian
/// CreatDate：   2015-09-17
/// Description:  查询医护人员列表
/// Table：       SS_User
/// Input：       Alias ： 别名  , Ctloc :科室
/// output:       符合条件的项            
/// Return：      1:Rowid 2:Code 3:Name 4:CtlocDr 5:CtlocDesc 6:SSGroupDr 7:SSGroupDesc 8:CtpcpDr
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Srv.CommonCls","QryUserByAliasLoc","w","9")
Query QryUserByAliasLoc(Alias As %String = "", Ctloc As %String = "") As %Query(ROWSPEC = "Rowid:%String,Code:%String,Name:%String,CtlocDr:%String,CtlocDesc:%String,SSGroupDr:%String,SSGroupDesc:%String,CtpcpDr:%String")
{
}

ClassMethod QryUserByAliasLocExecute(ByRef qHandle As %Binary, Alias As %String = "", Ctloc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set Alias=$ZCVT(Alias,"U")
 	Set UserID=0
 	For {
		Set UserID=$o(^SSU("SSUSR",UserID))
		Quit:UserID=""
		
		Set UserCode=$p($g(^SSU("SSUSR",+UserID)),"^",1)
		Set UserName=$p($g(^SSU("SSUSR",+UserID)),"^",2)
		Set UserAlias=$p($g(^SSU("SSUSR",+UserID)),"^",11)
		//add by wuqk 2012-1-18 能根据医护人员拼音码查询
		Set CTPCP=+$p($g(^SSU("SSUSR",+UserID)),"^",14)
		Set CTPCPOtherName=""
		Set:CTPCP>0 CTPCPOtherName=$p($g(^CTPCP(CTPCP,3)),"^",28)  //CTPCPOtherName
		Continue:($ZCVT(UserCode,"U")'[Alias)&&($ZCVT(UserName,"U")'[Alias)&&($ZCVT(UserAlias,"U")'[Alias)&&($ZCVT(CTPCPOtherName,"U")'[Alias)
		
		Set CtlocID=+$p($g(^SSU("SSUSR",+UserID)),"^",4)
		Continue:(Ctloc'="")&(CtlocID'=Ctloc)
		
		Set xUserInfo=##Class(DHCMed.Base.SSUser).GetStringById(+UserID)
		Continue:xUserInfo=""
		Set Data=$lb("")
		For iBuild=1:1:$l(xUserInfo,"^")
		{
			Set $li(Data,iBuild)=$p(xUserInfo,"^",iBuild)
		}
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryUserByAliasLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryUserByAliasLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryUserByAliasLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryUserByAliasLocExecute ]
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
/// CreatDate：   2012-06-10
/// Description:  查询就诊转科记录
/// Table：       
/// Input：       aInHosp      : 在院标志
///               aLocID       : 科室
///               aWardID      : 病区
///               aPatientStr  : 病人基本信息
///               aTransType   : 转科类型(科室/病区)
///               aLogLoc      : 登录科室
/// w ##class(DHCMed.NINFService.Srv.CommonCls).BuildAdmTransJson("Y",13,"","^^","W","","")
ClassMethod BuildAdmTransJson(aInHosp As %String, aLocID As %String, aWardID As %String, aPatientStr As %String, aTransType As %String, aLogLoc As %String, aHospital As %String = "") As %String
{
	New (aInHosp,aLocID,aWardID,aPatientStr,aTransType,aLogLoc,aHospital)
	Set return="[]"
	Set $ZT="BuildAdmTransJsonErr"
	
	Set aRegNo=$p(aPatientStr,"^",1)
	Set aMrNo=$p(aPatientStr,"^",2)
	Set aPatName=$p(aPatientStr,"^",3)
	
	// 号码或姓名查询,不检查科室
	If (aRegNo'="")||(aMrNo'="")||(aPatName'="") {
		Set aLocID=""
		Set aWardID=""
		Set aLogLoc=""
	}
	
	Set ZIndex=$zn,JIndex=$j,NIndex="BuildAdmTransJson"
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	If aRegNo'="" {    //登记号不为空
		Set RegNo=""
		Set PATCFId=$o(^CF("PATCF",""))
		Set RegNoLen=$p($g(^CF("PATCF",+PATCFId,3)),"^",5)
		Set:RegNoLen="" RegNoLen=10
		Set $p(RegNo,"0",RegNoLen-$l(+aRegNo)+1)=(+aRegNo)
		Set PatientID=$o(^PAPERi("PAPMI_PatNo",RegNo,""))
		Set AdmType=""
		For {
			Set AdmType=$o(^PAPERdr(+PatientID,"ADM",AdmType))
			Quit:AdmType=""
			Set Paadm=0
			For {
				Set Paadm=$o(^PAPERdr(+PatientID,"ADM",AdmType,Paadm))
				Quit:Paadm=""
				Do BuildPaadmListTMP
			}
		}
	} ElseIf aPatName'="" {    //病人姓名不为空
		Set PatName=$zcvt(aPatName,"U")
		Set PatientID=0
		For {
			Set PatientID=$o(^PAPERi("PAPER_PatName",PatName,PatientID))
			Quit:PatientID=""
			Set AdmType=""
			For {
				Set AdmType=$o(^PAPERdr(+PatientID,"ADM",AdmType))
				Quit:AdmType=""
				Set Paadm=0
				For {
					Set Paadm=$o(^PAPERdr(+PatientID,"ADM",AdmType,Paadm))
					Quit:Paadm=""
					Do BuildPaadmListTMP
				}
			}
		}
	} ElseIf aMrNo'="" {    //病案号不为空
		Set MrNo=$zcvt(aMrNo,"U")
		Set PatientID=0
		For {
			Set PatientID=$o(^PAPERi("Medicare1",MrNo,PatientID))
			Quit:PatientID=""
			Set AdmType=""
			For {
				Set AdmType=$o(^PAPERdr(+PatientID,"ADM",AdmType))
				Quit:AdmType=""
				Set Paadm=0
				For {
					Set Paadm=$o(^PAPERdr(+PatientID,"ADM",AdmType,Paadm))
					Quit:Paadm=""
					Do BuildPaadmListTMP
				}
			}
		}
		
		//病案系统接口调用：病案号取病人ID接口
		Set PatientIDs=##Class(DHCWMR.IO.OutService).IGetPatientIDByMrNo(MrNo,"I","","")
		For indPat=1:1:$l(PatientIDs,",") {
			Set PatientID=$p(PatientIDs,",",indPat)
			Continue:PatientID=""
			Set AdmType=""
			For {
				Set AdmType=$o(^PAPERdr(+PatientID,"ADM",AdmType))
				Quit:AdmType=""
				Set Paadm=0
				For {
					Set Paadm=$o(^PAPERdr(+PatientID,"ADM",AdmType,Paadm))
					Quit:Paadm=""
					Do BuildPaadmListTMP
				}
			}
		}
	} Else {
		//科室在院患者查询
		//Quit:(aInHosp'="Y")||((aLocID="")&&(aWardID="")) return
		//Quit:(aInHosp'="Y")||(aHospital="")
		Quit:(aInHosp'="Y")	//修改为可以通过科室和病区进行查询
		Set xWardID=""
		For {
			Set xWardID=$o(^PAADMi("CurrWard",xWardID))
			Quit:xWardID=""
			Set xRoomID=""
			For {
				Set xRoomID=$o(^PAADMi("CurrWard",xWardID,xRoomID))
				Quit:xRoomID=""
				
				Set Paadm=""
				For {
					Set Paadm=$o(^PAADMi("CurrWard",xWardID,xRoomID,Paadm))
					Quit:Paadm=""
					Do BuildPaadmListTMP
				}
			}
		}
	}
	
	Set xAdmLoc=0,jsonLoc=""
	For {
		Set xAdmLoc=$o(^TMP(ZIndex,JIndex,NIndex,xAdmLoc))
		Quit:xAdmLoc=""
		
		Set xBed="",jsonAdm=""
		For {
			Set xBed=$o(^TMP(ZIndex,JIndex,NIndex,xAdmLoc,xBed))
			Quit:xBed=""
			
			Set xPaadm=0
			For {
				Set xPaadm=$o(^TMP(ZIndex,JIndex,NIndex,xAdmLoc,xBed,xPaadm))
				Quit:xPaadm=""
				
				Set objPaadm=##class(DHCMed.Base.PatientAdm).GetObjById(xPaadm)
				Continue:'$IsObject(objPaadm)
				
				Set AdmitDate=objPaadm.AdmitDate
				Set AdmLocID=objPaadm.DepartmentID
				Set AdmLoc=objPaadm.Department
				Set:AdmLoc["-" AdmLoc=$p(AdmLoc,"-",2)
				Set AdmWardID=objPaadm.WardID
				Set:AdmWardID'="" AdmWardID=$p($g(^PAWARD(AdmWardID)),"^",5)
				Set AdmWard=objPaadm.Ward
				Set:AdmWard["-" AdmWard=$p(AdmWard,"-",2)
				Set AdmBed=objPaadm.Bed
				Set:AdmBed'["床" AdmBed=AdmBed_"床"
				Set PatientID=objPaadm.PatientID
				Continue:PatientID=""
				Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
				Continue:'$IsObject(objPatient)
				Set PatName=objPatient.PatientName
				Set PapmiNo=objPatient.PapmiNo
				Set PatSex=objPatient.Sex
				
				Set:jsonAdm'="" jsonAdm=jsonAdm_","
				Set jsonTrans=""
				Set TransNum=+$g(^TMP(ZIndex,JIndex,NIndex,xAdmLoc,xBed,xPaadm))
				If (TransNum>1) {
					Set TransID=0
					For {
						Set TransID=$o(^TMP(ZIndex,JIndex,NIndex,xAdmLoc,xBed,xPaadm,TransID))
						Quit:TransID=""
						
						Set TransLoc=$o(^TMP(ZIndex,JIndex,NIndex,xAdmLoc,xBed,xPaadm,TransID,0))
						Continue:TransLoc=""
						Set TransLocDesc=$p($g(^CTLOC(+TransLoc)),"^",2)
						Set:$p(TransLocDesc,"-",2)'="" TransLocDesc=$p(TransLocDesc,"-",2)
						Continue:TransLocDesc=""
						Set TransInDate=$p($g(^PAADM(xPaadm,"TRANS",TransID)),"^",1)
						;Set:TransInDate'="" TransInDate=$zd(TransInDate,3)
						Set:TransInDate'="" TransInDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(TransInDate)
						Set TransInTime=$p($g(^PAADM(xPaadm,"TRANS",TransID)),"^",2)
						Set:TransInTime'="" TransInTime=$zt(TransInTime,2)
						
						Set:jsonTrans'="" jsonTrans=jsonTrans_","
						Set jsonTrans=jsonTrans_"{"
						Set jsonTrans=jsonTrans_"""id"":"""_xPaadm_"||"_TransID_"-AdmTrans-"_TransLoc_""","
						Set jsonTrans=jsonTrans_"""text"":"""_TransLocDesc_" "_TransInDate_" "_TransInTime_""","
						Set jsonTrans=jsonTrans_"""leaf"":true"
						Set jsonTrans=jsonTrans_"}"
					}
					Set jsonAdm=jsonAdm_"{"
					Set jsonAdm=jsonAdm_"""id"":"""_xPaadm_"-"_"Adm"_""","
					Set jsonAdm=jsonAdm_"""text"":"""_PapmiNo_" "_PatName
					If AdmBed'="" {
						Set jsonAdm=jsonAdm_" "_AdmBed_""","
					} Else {
						Set jsonAdm=jsonAdm_""","
					}
					Set:PatSex="男" jsonAdm=jsonAdm_"""iconCls"":""icon-man"","
					Set:PatSex="女" jsonAdm=jsonAdm_"""iconCls"":""icon-woman"","
					Set jsonAdm=jsonAdm_"""leaf"":false,"
					Set jsonAdm=jsonAdm_"""children"":["_jsonTrans_"]"
					Set jsonAdm=jsonAdm_"}"
				} Else {
					Set TransID=$o(^TMP(ZIndex,JIndex,NIndex,xAdmLoc,xBed,xPaadm,0))
					Continue:TransID=""
					
					Set TransLoc=$o(^TMP(ZIndex,JIndex,NIndex,xAdmLoc,xBed,xPaadm,TransID,0))
					Continue:TransLoc=""
					
					Set jsonAdm=jsonAdm_"{"
					Set jsonAdm=jsonAdm_"""id"":"""_xPaadm_"||"_TransID_"-AdmTrans-"_TransLoc_""","
					Set jsonAdm=jsonAdm_"""text"":"""_PapmiNo_" "_PatName
					If AdmBed'="" {
						Set jsonAdm=jsonAdm_" "_AdmBed_""","
					} Else {
						Set jsonAdm=jsonAdm_""","
					}
					Set:PatSex="男" jsonAdm=jsonAdm_"""iconCls"":""icon-man"","
					Set:PatSex="女" jsonAdm=jsonAdm_"""iconCls"":""icon-woman"","
					Set jsonAdm=jsonAdm_"""leaf"":false,"
					Set jsonAdm=jsonAdm_"""children"":["_jsonTrans_"]"
					Set jsonAdm=jsonAdm_"}"
				}
			}
		}
		
		Set objAdmLoc=##class(DHCMed.Base.Ctloc).GetObjById(xAdmLoc)
		Continue:'$IsObject(objAdmLoc)
		Set AdmLocDesc=objAdmLoc.Descs
		Set:$p(AdmLocDesc,"-",2)'="" AdmLocDesc=$p(AdmLocDesc,"-",2)
		Continue:AdmLocDesc=""
		
		Set:jsonLoc'="" jsonLoc=jsonLoc_","
		Set jsonLoc=jsonLoc_"{"
		Set jsonLoc=jsonLoc_"""id"":"""_xAdmLoc_"-"_"Loc"_""","
		Set jsonLoc=jsonLoc_"""text"":"""_AdmLocDesc_""","
		Set jsonLoc=jsonLoc_"""leaf"":false,"
		Set jsonLoc=jsonLoc_"""children"":["_jsonAdm_"]"
		Set jsonLoc=jsonLoc_"}"
	}
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	Quit "["_jsonLoc_"]"
	
BuildPaadmListTMP
	//就诊类型
	Set AdmType=$p($g(^PAADM(+Paadm)),"^",2)
	Quit:AdmType'="I"
	
	//在院状态
	Set VisitStatus=$p($g(^PAADM(+Paadm)),"^",20)
	Quit:VisitStatus="C"
	Quit:(aInHosp="Y")&&(VisitStatus'="A")
	
	Set BedDesc=""
	Set BedID=$p($g(^PAADM(+Paadm)),"^",73)
	If BedID'="" {
		Set BedDesc=$p($g(^PAWARD(+BedID,"BED",+$p(BedID,"||",2))),"^",1)
	}
	
	//科室,病区
	Set AdmLocID=$p($g(^PAADM(+Paadm)),"^",4)
	Set AdmHostpital=##class(DHCMed.SSService.HospitalSrv).GetCTHospID(AdmLocID)
	Set AdmWardID=$p($g(^PAADM(+Paadm)),"^",70)
	Set:AdmWardID'="" AdmWardID=$p($g(^PAWARD(AdmWardID)),"^",5)

	Quit:(aLocID'="")&&(aLocID'=AdmLocID)
	Quit:(aHospital'="")&&(aHospital'[AdmHostpital)
	Quit:(aWardID'="")&&(aWardID'=AdmWardID)
	Set TransID=0,PreTransLoc=""
	For {
		Set TransID=$o(^PAADM(Paadm,"TRANS",TransID))
		Quit:TransID=""
		
		//报告科室=科室/病区  由"科室类型"决定
		If aTransType="E" {
			Set RepLocID=AdmLocID
			Set TransLoc=$p($g(^PAADM(Paadm,"TRANS",TransID)),"^",6)
		} Else {
			Set RepLocID=AdmWardID
			Set TransLoc=$p($g(^PAADM(Paadm,"TRANS",TransID)),"^",8)
			Set:TransLoc'="" TransLoc=$p(TransLoc,"||",1)
			Set:TransLoc'="" TransLoc=$p($g(^PAWARD(TransLoc)),"^",5)
		}
		Continue:TransLoc=""
		Continue:TransLoc=PreTransLoc
		If aLogLoc'="" {
			Continue:(aLogLoc'=TransLoc)&&'$d(^CTLOC(+TransLoc,"LINK",0,"Loc",+aLogLoc))
		}
		
		Set PreTransLoc=TransLoc
		
		Set num=$i(^TMP(ZIndex,JIndex,NIndex,RepLocID," "_BedDesc,Paadm))
		Set ^TMP(ZIndex,JIndex,NIndex,RepLocID," "_BedDesc,Paadm,TransID,TransLoc)=""
	}
	Quit
	
BuildAdmTransJsonErr
	Quit "[]"
}

/// w ##Class(DHCMed.NINFService.Srv.CommonCls).GetAdmTransByAdm("34080","16","E")
ClassMethod GetAdmTransByAdm(aEpisodeID As %String, aLocID As %String, aTransType As %String) As %String
{
	New (aEpisodeID,aLocID,aTransType)
	Set return=""
	Quit:(aEpisodeID="")||((aTransType="")&&(aLocID="")) return
	
	If aTransType="" {
		Set aTransType=$p($g(^CTLOC(+aLocID)),"^",13)
	}
	Quit:(aTransType'="E")&&(aTransType'="W") return
	
	Set TransID=0,PreTransLoc=""
	For {
		Set TransID=$o(^PAADM(aEpisodeID,"TRANS",TransID))
		Quit:TransID=""
		
		If aTransType="E" {
			Set TransLoc=$p($g(^PAADM(aEpisodeID,"TRANS",TransID)),"^",6)
		}
		If aTransType="W" {
			Set TransLoc=$p($g(^PAADM(aEpisodeID,"TRANS",TransID)),"^",8)  //取床位字段
			Set:TransLoc'="" TransLoc=$p(TransLoc,"||",1)
			Set:TransLoc'="" TransLoc=$p($g(^PAWARD(TransLoc)),"^",5)
		}
		Continue:TransLoc=""
		Continue:TransLoc=PreTransLoc
		Set PreTransLoc=TransLoc
		
		//科室非空,取科室最新转科记录
		//科室为空,取最新转科记录
		Continue:(aLocID'="")&&(TransLoc'=aLocID)
		Set return=aEpisodeID_"||"_TransID_"^"_TransLoc
	}
	
	Quit return
}

/// w ##Class(DHCMed.NINFService.Srv.CommonCls).GetAdmTrans("21976031||2",120)
ClassMethod GetAdmTrans(aTransID As %String, aTransLoc As %String) As %String
{
	New (aTransID,aTransLoc)
	Set return=""
	
	Set (TransLocID,TransLocDesc,TransType)=""
	Set (TransFromLocID,TransFromLocDesc,TransToLocID,TransToLocDesc)=""
	Set (TransStartDate,TransStartTime,TransEndDate,TransEndTime)=""
	
	Set Paadm=+aTransID,TransSubID=+$p(aTransID,"||",2)
	Set tmpTrans=$g(^PAADM(Paadm,"TRANS",TransSubID))
	Quit:tmpTrans="" return
	Set:aTransLoc="" aTransLoc=$p(tmpTrans,"^",6)
	
	Set TransLocID=aTransLoc
	Set TransLocDesc=$p($g(^CTLOC(+TransLocID)),"^",2)
	Set:$p(TransLocDesc,"-",2)'="" TransLocDesc=$p(TransLocDesc,"-",2)
	Set TransType=$p($g(^CTLOC(+aTransLoc)),"^",13)
	
	Set TransStartDate=$p(tmpTrans,"^",1)
	Set:TransStartDate'="" TransStartDate=$zd(+TransStartDate,3)
	Set TransStartTime=$p(tmpTrans,"^",2)
	Set:TransStartTime'="" TransStartTime=$zt(+TransStartTime,1)
	
	//入科来源
	Set xTransID=TransSubID
	For {
		Set xTransID=$o(^PAADM(Paadm,"TRANS",xTransID),-1)
		Quit:xTransID=""
		
		Set xTmpTrans=$g(^PAADM(Paadm,"TRANS",xTransID))
		Continue:xTmpTrans=""
		If TransType="E" {
			Set xTransLocID=$p(xTmpTrans,"^",6)
		} Else {
			Set xTransLocID=$p(xTmpTrans,"^",8)
			Set:xTransLocID'="" xTransLocID=$p(xTransLocID,"||",1)
			Set:xTransLocID'="" xTransLocID=$p($g(^PAWARD(xTransLocID)),"^",5)
		}
		Continue:xTransLocID=""
		Continue:xTransLocID=TransLocID

		Set TransFormLocID=xTransLocID
		Set TransFormLocDesc=$p($g(^CTLOC(+TransFormLocID)),"^",2)
		Set:$p(TransFormLocDesc,"-",2)'="" TransFormLocDesc=$p(TransFormLocDesc,"-",2)

		Quit
	}
	
	//转出时间、出科去向
	Set TransEndDate="",TransEndTime=""
	Set xTransID=TransSubID
	For {
		Set xTransID=$o(^PAADM(Paadm,"TRANS",xTransID))
		Quit:xTransID=""
		
		Set xTmpTrans=$g(^PAADM(Paadm,"TRANS",xTransID))
		Continue:xTmpTrans=""
		If TransType="E" {
			Set xTransLocID=$p(xTmpTrans,"^",6)
		} Else {
			Set xTransLocID=$p(xTmpTrans,"^",8)
			Set:xTransLocID'="" xTransLocID=$p(xTransLocID,"||",1)
			Set:xTransLocID'="" xTransLocID=$p($g(^PAWARD(xTransLocID)),"^",5)
		}
		Continue:xTransLocID=""
		Continue:xTransLocID=TransLocID
		
		Set TransToLocID=xTransLocID
		Set TransToLocDesc=$p($g(^CTLOC(+TransToLocID)),"^",2)
		Set:$p(TransToLocDesc,"-",2)'="" TransToLocDesc=$p(TransToLocDesc,"-",2)
		Set TransEndDate=$p(xTmpTrans,"^",1)
		Set:TransEndDate'="" TransEndDate=$zd(+TransEndDate,3)
		Set TransEndTime=$p(xTmpTrans,"^",2)
		Set:TransEndTime'="" TransEndTime=$zt(+TransEndTime,1)
		Quit
	}
	If TransEndDate="" {  //最终结算时间
		//Update by pylian 2016-01-21 修改出院时间取值方式
		Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(Paadm)
		Set TransEndDate=$p(DischDateTime,"^",1)
		Set TransEndTime=$p(DischDateTime,"^",2)	
		//Set TransEndDate=$p($g(^PAADM(Paadm)),"^",17)
		Set:TransEndDate'="" TransEndDate=$zd(+TransEndDate,3)
		//Set TransEndTime=$p($g(^PAADM(Paadm)),"^",18)
		Set:TransEndTime'="" TransEndTime=$zt(+TransEndTime,1)
	
	
	}
	If (TransEndDate'="")
	{
		Set TransLocDays=$zdh(TransEndDate,3)-$zdh(TransStartDate,3)+1
	} Else {
		Set TransLocDays=(+$h)-$zdh(TransStartDate,3)+1
	}
	Set TransLocDiagnos=""
	Set:TransFromLocDesc="" TransFromLocDesc="入院"
	Set:TransLocDays<1 TransLocDays=1
	Set TransLocDays=TransLocDays_"天"
	
	Set return=TransLocID_$c(1)_TransLocDesc
	Set return=return_$c(1)_TransFromLocID_$c(1)_TransFromLocDesc
	Set return=return_$c(1)_TransToLocID_$c(1)_TransToLocDesc
	Set return=return_$c(1)_TransStartDate_$c(1)_TransStartTime
	Set return=return_$c(1)_TransEndDate_$c(1)_TransEndTime
	Set return=return_$c(1)_TransLocDays_$c(1)_TransLocDiagnos
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-06-24
/// Description:  查询医嘱剂量单位
/// Table：       
/// Input：       aArcimID : 医嘱项ID
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Srv.CommonCls","QryDoseUnit","1||1")
Query QryDoseUnit(aArcimID As %String) As %Query(ROWSPEC = "UnitID:%String,UnitDesc:%String")
{
}

ClassMethod QryDoseUnitExecute(ByRef qHandle As %Binary, aArcimID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Quit:aArcimID="" $$$OK
	
	Set DrgFormID=$p($g(^ARCIM(+aArcimID,+$p(aArcimID,"||",2),1)),"^",12)  //剂量
	Set DMID=$P(DrgFormID,"||",1)
	Set DFSub=$P(DrgFormID,"||",2)
	Quit:(DMID="")||(DFSub="") $$$OK
	
	Set UnitID=$p($g(^PHCD(DMID,"DF",DFSub,2)),"^",4)
	Set UnitDesc=$p($g(^CT("UOM",+UnitID)),"^",2)
	Set Data=$lb(UnitID,UnitDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	
	Set EQSub=0
	For {
		Set EQSub=$o(^PHCD(DMID,"DF",DFSub,"EQ",EQSub))
		Quit:EQSub=""
		
		Set EQRec=$g(^PHCD(DMID,"DF",DFSub,"EQ",EQSub))
		Set UnitID=$p(EQRec,"^",1)
		Set UnitDesc=$p($g(^CT("UOM",UnitID)),"^",2)
		Set Data=$lb(UnitID,UnitDesc)
	 	Set ^CacheTemp(repid,ind)=Data
	 	Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryDoseUnitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDoseUnitExecute ]
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
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryDoseUnitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDoseUnitExecute ]
{
	Set repid=$LIST($g(qHandle),2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2012-06-24
/// Description:  查询医嘱项
/// Table：       
/// Input：       argAlias    : 别名
///               argItemCat  : 类型
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Srv.CommonCls","QryArcimByAlias","qms","R")
Query QryArcimByAlias(argAlias As %String, argItemCat As %String) As %Query(ROWSPEC = "ArcimID:%String,ArcimCode:%String,ArcimDesc:%String,ARCItemCat:%String,ARCOrderType:%String,ARCOrderCat:%String")
{
}

ClassMethod QryArcimByAliasExecute(ByRef qHandle As %Binary, argAlias As %String, argItemCat As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set ZIndex=$zn,JIndex=$j,NIndex="QryArcimByAlias"
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	//医嘱别名查询医嘱项
	//^ARC("ALIAS",0,"Desc",$$ALPHAUP({ALIAS_Text})_" ",$$ALPHAUP({ALIAS_Desc}),{ALIAS_RowId},1)
	s argAlias=$$ALPHAUP^SSUTIL4(argAlias)
	s Alias=$o(^ARC("ALIAS",0,"Desc",argAlias),-1)
	f  s Alias=$o(^ARC("ALIAS",0,"Desc",Alias)) q:(Alias="")||($e(Alias,1,$l(argAlias))'=argAlias)  d
	.s ARCDesc=""
	.f  s ARCDesc=$o(^ARC("ALIAS",0,"Desc",Alias,ARCDesc)) q:ARCDesc=""  d
	..s ARCRowid=0
	..f  s ARCRowid=$o(^ARC("ALIAS",0,"Desc",Alias,ARCDesc,ARCRowid)) q:ARCRowid=""  d
	...q:'$d(^ARC("ALIAS",ARCRowid))
	...s ARCType=$p(^ARC("ALIAS",ARCRowid),"^",5)
	...q:ARCType'="ARCIM"
	...s ARCAlias=$p(^ARC("ALIAS",ARCRowid),"^",6)
	...s ARCAlias=$$ALPHAUP^SSUTIL4(ARCAlias)
	...q:$e(ARCAlias,1,$l(argAlias))'=argAlias
	...s ARCItemID=$p(^ARC("ALIAS",ARCRowid),"^",1)
	...q:ARCItemID=""
	...q:$d(^TMP(ZIndex,JIndex,NIndex,ARCItemID))
	...d BuildDataToARCIM
	...s ^TMP(ZIndex,JIndex,NIndex,ARCItemID)=""
	
	//医嘱名称查询医嘱项
	//^ARCIM(0,"Desc",$$ALPHAUP({ARCIM_Desc}),{ARCIM_Subscript},{ARCIM_Version})
	s Alias=$o(^ARCIM(0,"Desc",argAlias),-1)
	f  s Alias=$o(^ARCIM(0,"Desc",Alias)) q:(Alias="")||($e(Alias,1,$l(argAlias))'=argAlias)  d
	.s ItemSub=0
	.f  s ItemSub=$o(^ARCIM(0,"Desc",Alias,ItemSub)) q:ItemSub=""  d
	..s ItemVer=0
	..f  s ItemVer=$o(^ARCIM(0,"Desc",Alias,ItemSub,ItemVer)) q:ItemVer=""  d
	...s ARCItemID=ItemSub_"||"_ItemVer
	...q:$d(^TMP(ZIndex,JIndex,NIndex,ARCItemID))
	...d BuildDataToARCIM
	...s ^TMP(ZIndex,JIndex,NIndex,ARCItemID)=""
	
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	Quit $$$OK
	
BuildDataToARCIM
	s ARCItemSub=$p(ARCItemID,"||",1)
	s ARCItemVer=$p(ARCItemID,"||",2)
	q:(ARCItemSub="")||(ARCItemVer="")
	s ARCItemCat=$p($g(^ARCIM(ARCItemSub,ARCItemVer,1)),"^",10)
	s ARCItemType=$p($g(^ARC("IC",+ARCItemCat)),"^",7)
	q:(argItemCat'="")&&(ARCItemType'=argItemCat)  //判断医嘱类型(L,R)
	s ARCItemCode=$p($g(^ARCIM(ARCItemSub,ARCItemVer,1)),"^",1)
	s ARCItemDesc=$p($g(^ARCIM(ARCItemSub,ARCItemVer,1)),"^",2)
	s ARCItemCode=$tr(ARCItemCode,$c(13),"")
	s ARCItemCode=$tr(ARCItemCode,$c(13),"")
	s ARCItemDesc=$tr(ARCItemDesc,$c(13),"")
	s ARCItemDesc=$tr(ARCItemDesc,$c(10),"")
	q:ARCItemDesc=""
	s OrderOnItsOwn=$p($g(^ARCIM(ARCItemSub,ARCItemVer,7)),"^",13)
	q:(OrderOnItsOwn'["Y")
	s ARCItemEffDateTo=$p($g(^ARCIM(ARCItemSub,ARCItemVer,7)),"^",1)
	q:(ARCItemEffDateTo'="")&(ARCItemEffDateTo<=$p($h,",",1))
	//判断医嘱项是否有效(有效日期,截止日期)
	s effDateFrom=$p($g(^ARCIM(ARCItemSub,ARCItemVer,1)),"^",13)
	s:effDateFrom'="" effDateFrom=$p(effDateFrom,"Z",1)
	s effDateTo=$p($g(^ARCIM(ARCItemSub,ARCItemVer,7)),"^",1)
	s currDate=+$h
	q:((effDateFrom'="")&&(effDateFrom>currDate))
	q:((effDateTo'="")&&(effDateTo<currDate))
	
	//查询ARC_ItemCat医嘱子类
	s ItemCatID=$p($g(^ARCIM(ARCItemSub,ARCItemVer,1)),"^",10)
	s ItemCatCode=$p($g(^ARC("IC",+ItemCatID)),"^",1)
	s ItemCatDesc=$p($g(^ARC("IC",+ItemCatID)),"^",2)
	s OrderCatID=$p($g(^ARC("IC",+ItemCatID)),"^",8)
	s OrderType=$p($g(^ARC("IC",+ItemCatID)),"^",7)
	//查询OEC_OrderCategory医嘱大类
	s OrderCatCode=$p($g(^OEC("ORCAT",+OrderCatID)),"^",1)
	s OrderCatDesc=$p($g(^OEC("ORCAT",+OrderCatID)),"^",2) 
	
	s Data=$lb(ARCItemID,ARCItemCode,ARCItemDesc,ItemCatDesc,OrderType,OrderCatDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod QryArcimByAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryArcimByAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryArcimByAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryArcimByAliasExecute ]
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
/// CreatDate：   2012-06-24
/// Description:  查询医嘱频次
/// Table：       
/// Input：       argDesc : 名字
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Srv.CommonCls","QryFreqByAlias","qd")
Query QryFreqByAlias(argDesc As %String) As %Query(ROWSPEC = "FreqID:%String,FreqDesc:%String")
{
}

ClassMethod QryFreqByAliasExecute(ByRef qHandle As %Binary, argDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set argDesc=$ZCVT(argDesc,"U")
	Set tmpDesc=0
	For {
		Set tmpDesc=$o(^PHCFR(0,"Desc1",tmpDesc))
		Quit:tmpDesc=""
		Continue:(argDesc'="")&&(tmpDesc'[argDesc)
		Set FreqID=0
		For {
			Set FreqID=$o(^PHCFR(0,"Desc1",tmpDesc,FreqID))
			Quit:FreqID=""
			Set FreqDesc=$p($g(^PHCFR(FreqID)),"^",3)
			Set Data=$lb(FreqID,FreqDesc)
		 	Set ^CacheTemp(repid,ind)=Data
		 	Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryFreqByAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryFreqByAliasExecute ]
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
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryFreqByAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryFreqByAliasExecute ]
{
	Set repid=$LIST($g(qHandle),2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// 获取模板文件存放目录
/// w ##class(DHCMed.NINFService.Srv.CommonCls).GetTemplatePath()
ClassMethod GetTemplatePath() As %String
{
	New
	Set strPath=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("NINFTemplatePath")
	If strPath="" {
		Set objConfig=##class(websys.Configuration).%OpenId(1)
		Do objConfig.%Close()
		Set strPath=objConfig.PathToReports
	} Else {
		Set strPath=$tr(strPath,"/","\")
	}
	Quit strPath
}

/// w ##class(DHCMed.NINFService.Srv.CommonCls).GetSSDicList("NINFInfReportStatus","")
ClassMethod GetSSDicList(argTypeCode As %String, argActive As %String) As %String
{
	New (argTypeCode,argActive)
	Set return=""
	
 	Set RowID=0
 	For {
	 	Set RowID=$o(^DHCMed.SS.DictionaryI("IdxofType"," "_$ZCVT($g(argTypeCode),"U"),RowID))
	 	Quit:RowID=""
	 	Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(RowID)
	 	Continue:'$IsObject(objDic)
	 	Continue:(argActive'="")&&(argActive'=objDic.Active)
	 	
	 	Set return=return_$c(1)_objDic.%Id()
	}
	Set:return'="" return=$e(return,2,$l(return))
	
	Quit return
}

/// w ##class(DHCMed.NINFService.Srv.CommonCls).GetMrNoByAdm(3782456)
ClassMethod GetMrNoByAdm(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	//病案系统接口调用：就诊取病案号接口
	Set return=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(aEpisodeID,"I","")
	Quit return
}

/// 取病区转出日期
/// 科室转出日期暂时不通过此方法处理
/// w ##Class(DHCMed.NINFService.Srv.CommonCls).getWardTransOutDate()
ClassMethod getWardTransOutDate(aTransID As %String) As %String
{
	New (aTransID)
	Set return=""
	Quit:aTransID="" return
	
	Set tmpTrans=$g(^PAADM(+aTransID,"TRANS",+$p(aTransID,"||",2)))
	Set TransLocID=$p(tmpTrans,"^",8)
	Set:TransLocID'="" TransLocID=$p(TransLocID,"||",1)
	Set:TransLocID'="" TransLocID=$p($g(^PAWARD(TransLocID)),"^",5)
	
	Set TransDate=""
	Set xTransID=$p(aTransID,"||",2)
	For {
		Set xTransID=$o(^PAADM(+aTransID,"TRANS",xTransID))
		Quit:xTransID=""
		Set tmpTrans=$g(^PAADM(+aTransID,"TRANS",xTransID))
		Set xTransLocID=$p(tmpTrans,"^",8)
		Set:xTransLocID'="" xTransLocID=$p(xTransLocID,"||",1)
		Set:xTransLocID'="" xTransLocID=$p($g(^PAWARD(xTransLocID)),"^",5)
		Continue:xTransLocID=""
		Continue:xTransLocID=TransLocID
		Set TransDate=$p(tmpTrans,"^",2)
		Quit:TransDate'=""
	}
	
	If TransDate'="" {
		Set return=TransDate
	} Else {
		//Set DischDate=$p($g(^PAADM(+TransID)),"^",17)  //最终结算时间
		//Set DischDate=$p($g(^PAADM(+aTransID)),"^",59)  //医疗结算时间
		//Update by pylian 2016-01-22 修改出院时间取值方式
		Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(aTransID)
		Set DischDate=$p(DischDateTime,"^",1)
		Set return=DischDate
	}
	
	Quit return
}

/// 查询患者转科列表
/// w ##Class(DHCMed.NINFService.Srv.CommonCls).GetTransLocList(20074316,"W")
ClassMethod GetTransLocList(aEpisodeID As %String, aTransType As %String) As %String
{
	New (aEpisodeID, aTransType)
	Set return="[]"
	Quit:(aEpisodeID="")||(aTransType="") return
	
	Set $ZT="GetTransLocListErr"
	
	Set NIndex="GetTransLocList"
	Kill ^TMP($zn,$j,NIndex)
	Set TransID="",PrevTransLoc=""
	For {
		Set TransID=$o(^PAADM(aEpisodeID,"TRANS",TransID))
		Quit:TransID=""
		
		Set tmpTrans=$g(^PAADM(aEpisodeID,"TRANS",TransID))
		Continue:tmpTrans=""
		
		If aTransType="W" {
			Set TransLoc=$p($p(tmpTrans,"^",8),"||",1)
			Continue:TransLoc=""
			Set TransLoc=$p($g(^PAWARD(TransLoc)),"^",5)
		} Else {
			Set TransLoc=$p(tmpTrans,"^",6)
			Continue:TransLoc=""
		}
		Continue:PrevTransLoc=TransLoc
		Set PrevTransLoc=TransLoc
		Set TransLocDesc=$p($g(^CTLOC(+TransLoc)),"^",2)
		Set:$p(TransLocDesc,"-",2)'="" TransLocDesc=$p(TransLocDesc,"-",2)
		Set TransDate=$p($g(^PAADM(aEpisodeID,"TRANS",TransID)),"^",1)
		Set TransTime=$p($g(^PAADM(aEpisodeID,"TRANS",TransID)),"^",2)
		;Set:TransDate'="" TransDate=$zd(TransDate,3)
		Set:TransDate'="" TransDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(TransDate)
		Set:TransTime'="" TransTime=$zt(TransTime,2)
		Set ^TMP($zn,$j,NIndex,TransID)=$lb(aEpisodeID_"||"_TransID,TransLoc,TransLocDesc,TransDate_" "_TransTime)
	}
	
	Set AdmStatus=$p($g(^PAADM(aEpisodeID)),"^",20)
	//Set DischDate=$p($g(^PAADM(aEpisodeID)),"^",17)
	//Set DischTime=$p($g(^PAADM(aEpisodeID)),"^",18)
	//Update by pylian 2016-01-21 修改出院时间取值方式
	Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(aEpisodeID)
	Set DischDate=$p(DischDateTime,"^",1)
	Set DischTime=$p(DischDateTime,"^",2)
	Set:DischDate'="" DischDate=$zd(DischDate,3)
	Set:DischTime'="" DischTime=$zt(DischTime,2)
	
	Set JsonStr="",Count=0
	Set TransID=0
	For {
		Set TransID=$o(^TMP($zn,$j,NIndex,TransID))
		Quit:TransID=""
		
		Set (PrevTransLocID,PrevTransLocDesc,NextTransDate,NextTransLocID,NextTransLocDesc)=""
		Set PrevTransID=$o(^TMP($zn,$j,NIndex,TransID),-1)
		If PrevTransID'="" {
			Set PrevData=$g(^TMP($zn,$j,NIndex,PrevTransID))
			Set PrevTransLocID=$list(PrevData,2)
			Set PrevTransLocDesc=$list(PrevData,3)
		}
		Set:PrevTransLocDesc="" PrevTransLocDesc="入院"
		
		Set NextTransID=$o(^TMP($zn,$j,NIndex,TransID))
		If NextTransID'="" {
			Set NextData=$g(^TMP($zn,$j,NIndex,NextTransID))
			Set NextTransLocID=$list(NextData,2)
			Set NextTransLocDesc=$list(NextData,3)
			Set NextTransDate=$list(NextData,4)
		} Else {
			If AdmStatus="D" {
				Set NextTransLocDesc="出院"
				Set NextTransDate=DischDate_" "_DischTime
			}
		}
		
		Set tmpData=$g(^TMP($zn,$j,NIndex,TransID))
		Set TransRowID=$list(tmpData,1)
		Set TransLocID=$list(tmpData,2)
		Set TransLocDesc=$list(tmpData,3)
		Set TransDate=$list(tmpData,4)
		
		Set Count=Count+1
		Set:JsonStr'="" JsonStr=JsonStr_","
		Set JsonStr=JsonStr_"['"_TransRowID_"','"_TransLocID_"','"_$zcvt(TransLocDesc,"O","HTML")_"','"_TransDate_"','"_NextTransDate_"','"_PrevTransLocID_"','"_$zcvt(PrevTransLocDesc,"O","HTML")_"','"_NextTransLocID_"','"_$zcvt(NextTransLocDesc,"O","HTML")_"']"
	}
	Kill ^TMP($zn,$j,NIndex)
	
	Set return="["_JsonStr_"]"
	Quit return
	
GetTransLocListErr
	Set return="[]"
	Quit return
}

/// d ##Class(%ResultSet).RunQuery("DHCMed.NINFService.Srv.CommonCls","QryTransLoc",20074316,"E")
Query QryTransLoc(aEpisodeID As %String, aTransType As %String) As %Query(ROWSPEC = "TransID:%String,TransLocID:%String,TransLocDesc:%String,TransInTime:%String,TransOutTime:%String,PrevLocID:%String,PrevLocDesc:%String,NextLocID:%String,NextLocDesc:%String")
{
}

ClassMethod QryTransLocExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aTransType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aEpisodeID="")||(aTransType="") $$$OK
	
	Set NIndex="QryTransLoc"
	Kill ^TMP($zn,$j,NIndex)
	Set TransID="",PrevTransLoc=""
	For {
		Set TransID=$o(^PAADM(aEpisodeID,"TRANS",TransID))
		Quit:TransID=""
		
		Set tmpTrans=$g(^PAADM(aEpisodeID,"TRANS",TransID))
		Continue:tmpTrans=""
		
		If aTransType="W" {
			Set TransLoc=$p($p(tmpTrans,"^",8),"||",1)
			Continue:TransLoc=""
			Set TransLoc=$p($g(^PAWARD(TransLoc)),"^",5)
		} Else {
			Set TransLoc=$p(tmpTrans,"^",6)
			Continue:TransLoc=""
		}
		Continue:PrevTransLoc=TransLoc
		Set PrevTransLoc=TransLoc
		Set TransLocDesc=$p($g(^CTLOC(+TransLoc)),"^",2)
		Set:$p(TransLocDesc,"-",2)'="" TransLocDesc=$p(TransLocDesc,"-",2)
		Set TransDate=$p($g(^PAADM(aEpisodeID,"TRANS",TransID)),"^",1)
		Set TransTime=$p($g(^PAADM(aEpisodeID,"TRANS",TransID)),"^",2)
		Set:TransDate'="" TransDate=$zd(TransDate,3)
		Set:TransTime'="" TransTime=$zt(TransTime,2)
		Set ^TMP($zn,$j,NIndex,TransID)=$lb(aEpisodeID_"||"_TransID,TransLoc,TransLocDesc,TransDate_" "_TransTime)
	}
	
	Set AdmStatus=$p($g(^PAADM(aEpisodeID)),"^",20)
	//Set DischDate=$p($g(^PAADM(aEpisodeID)),"^",17)
	//Set DischTime=$p($g(^PAADM(aEpisodeID)),"^",18)
	//Update by pylian 2016-01-21 修改出院时间取值方式
	Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(aEpisodeID)
	Set DischDate=$p(DischDateTime,"^",1)
	Set DischTime=$p(DischDateTime,"^",2)
	Set:DischDate'="" DischDate=$zd(DischDate,3)
	Set:DischTime'="" DischTime=$zt(DischTime,2)
	
	Set TransID=0
	For {
		Set TransID=$o(^TMP($zn,$j,NIndex,TransID))
		Quit:TransID=""
		
		Set (PrevTransLocID,PrevTransLocDesc,NextTransDate,NextTransLocID,NextTransLocDesc)=""
		Set PrevTransID=$o(^TMP($zn,$j,NIndex,TransID),-1)
		If PrevTransID'="" {
			Set PrevData=$g(^TMP($zn,$j,NIndex,PrevTransID))
			Set PrevTransLocID=$list(PrevData,2)
			Set PrevTransLocDesc=$list(PrevData,3)
		}
		Set:PrevTransLocDesc="" PrevTransLocDesc="入院"
		
		Set NextTransID=$o(^TMP($zn,$j,NIndex,TransID))
		If NextTransID'="" {
			Set NextData=$g(^TMP($zn,$j,NIndex,NextTransID))
			Set NextTransLocID=$list(NextData,2)
			Set NextTransLocDesc=$list(NextData,3)
			Set NextTransDate=$list(NextData,4)
		} Else {
			If AdmStatus="D" {
				Set NextTransLocDesc="出院"
				Set NextTransDate=DischDate_" "_DischTime
			}
		}
		
		Set Data=$g(^TMP($zn,$j,NIndex,TransID))_$lb(NextTransDate,PrevTransLocID,PrevTransLocDesc,NextTransLocID,NextTransLocDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,NIndex)
	
	Quit $$$OK
}

ClassMethod QryTransLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTransLocExecute ]
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

ClassMethod QryTransLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTransLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2013-05-29
/// Description:  根据就诊号取转科列表
/// Table：       
/// Input：       EpisodeID 就诊号    TransType 转科类型
/// Return：      返回%List
/// w ##class(DHCMed.NINFService.Srv.CommonCls).GetTransLocListNew(20074316,"E")
ClassMethod GetTransLocListNew(aEpisodeID As %String, aTransType As %String) As %List
{
	New (aEpisodeID,aTransType)
	Set return=""
	Quit:(aEpisodeID="")||(aTransType="") return
	
	Set NIndex="GetTransLocListNew"
	Kill ^TMP($zn,$j,NIndex)
	Set TransID="",PrevTransLoc=""
	For {
		Set TransID=$o(^PAADM(aEpisodeID,"TRANS",TransID))
		Quit:TransID=""
		
		Set tmpTrans=$g(^PAADM(aEpisodeID,"TRANS",TransID))
		Continue:tmpTrans=""
		
		If aTransType="W" {
			Set TransLoc=$p($p(tmpTrans,"^",8),"||",1)
			Continue:TransLoc=""
			Set TransLoc=$p($g(^PAWARD(TransLoc)),"^",5)
		} Else {
			Set TransLoc=$p(tmpTrans,"^",6)
			Continue:TransLoc=""
		}
		Continue:PrevTransLoc=TransLoc
		Set PrevTransLoc=TransLoc
		Set TransLocDesc=$p($g(^CTLOC(+TransLoc)),"^",2)
		Set:$p(TransLocDesc,"-",2)'="" TransLocDesc=$p(TransLocDesc,"-",2)
		Set TransDate=$p($g(^PAADM(aEpisodeID,"TRANS",TransID)),"^",1)
		Set TransTime=$p($g(^PAADM(aEpisodeID,"TRANS",TransID)),"^",2)
		Set:TransDate'="" TransDate=$zd(TransDate,3)
		Set:TransTime'="" TransTime=$zt(TransTime,2)
		Set ^TMP($zn,$j,NIndex,TransID)=$lb(aEpisodeID_"||"_TransID,TransLoc,TransLocDesc,TransDate_" "_TransTime)
	}
	
	Set AdmStatus=$p($g(^PAADM(aEpisodeID)),"^",20)
	//Set DischDate=$p($g(^PAADM(aEpisodeID)),"^",17)
	//Set DischTime=$p($g(^PAADM(aEpisodeID)),"^",18)
	//Update by pylian 2016-01-21 修改出院时间取值方式
	Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(aEpisodeID)
	Set DischDate=$p(DischDateTime,"^",1)
	Set DischTime=$p(DischDateTime,"^",2)
	Set:DischDate'="" DischDate=$zd(DischDate,3)
	Set:DischTime'="" DischTime=$zt(DischTime,2)
	
	Set TransID=0
	For {
		Set TransID=$o(^TMP($zn,$j,NIndex,TransID))
		Quit:TransID=""
		
		Set (PrevTransLocID,PrevTransLocDesc,NextTransDate,NextTransLocID,NextTransLocDesc)=""
		Set PrevTransID=$o(^TMP($zn,$j,NIndex,TransID),-1)
		If PrevTransID'="" {
			Set PrevData=$g(^TMP($zn,$j,NIndex,PrevTransID))
			Set PrevTransLocID=$list(PrevData,2)
			Set PrevTransLocDesc=$list(PrevData,3)
		}
		Set:PrevTransLocDesc="" PrevTransLocDesc="入院"
		
		Set NextTransID=$o(^TMP($zn,$j,NIndex,TransID))
		If NextTransID'="" {
			Set NextData=$g(^TMP($zn,$j,NIndex,NextTransID))
			Set NextTransLocID=$list(NextData,2)
			Set NextTransLocDesc=$list(NextData,3)
			Set NextTransDate=$list(NextData,4)
		} Else {
			If AdmStatus="D" {
				Set NextTransLocDesc="出院"
				Set NextTransDate=DischDate_" "_DischTime
			}
		}
		
		Set Data=$g(^TMP($zn,$j,NIndex,TransID))_$lb(NextTransDate,PrevTransLocID,PrevTransLocDesc,NextTransLocID,NextTransLocDesc)
		Set return=return_$lb(Data)
	}
	Kill ^TMP($zn,$j,NIndex)
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2013-05-29
/// Description:  根据就诊号取转科记录
/// Table：       
/// Input：       TransID 转科表ID
/// Return：      返回%List
/// w ##class(DHCMed.NINFService.Srv.CommonCls).GetTransLocByID("20074316||10")
ClassMethod GetTransLocByID(aTransID As %String) As %String
{
	New (aTransID)
	Set return=""
	Quit:(aTransID="") return
	
	Set EpisodeID=$p(aTransID,"||",1)
	Set TransID=$p(aTransID,"||",2)
	Quit:(EpisodeID="")||(TransID="") return
	
	Set tmpTrans=$g(^PAADM(EpisodeID,"TRANS",TransID))
	Quit:tmpTrans="" return
	Set TransLoc=$p(tmpTrans,"^",6)
	If TransLoc'="" {
		Set TransType="E"
	} Else {
		Set TransType="W"
	}
	
	Set NIndex="GetTransLocByID"
	Kill ^TMP($zn,$j,NIndex)
	Set TransID="",PrevTransLoc=""
	For {
		Set TransID=$o(^PAADM(EpisodeID,"TRANS",TransID))
		Quit:TransID=""
		
		Set tmpTrans=$g(^PAADM(EpisodeID,"TRANS",TransID))
		Continue:tmpTrans=""
		
		If TransType="W" {
			Set TransLoc=$p($p(tmpTrans,"^",8),"||",1)
			Continue:TransLoc=""
			Set TransLoc=$p($g(^PAWARD(TransLoc)),"^",5)
		} Else {
			Set TransLoc=$p(tmpTrans,"^",6)
			Continue:TransLoc=""
		}
		Continue:PrevTransLoc=TransLoc
		Set PrevTransLoc=TransLoc
		Set TransLocDesc=$p($g(^CTLOC(+TransLoc)),"^",2)
		Set:$p(TransLocDesc,"-",2)'="" TransLocDesc=$p(TransLocDesc,"-",2)
		Set TransDate=$p($g(^PAADM(EpisodeID,"TRANS",TransID)),"^",1)
		Set TransTime=$p($g(^PAADM(EpisodeID,"TRANS",TransID)),"^",2)
		Set:TransDate'="" TransDate=$zd(TransDate,3)
		Set:TransTime'="" TransTime=$zt(TransTime,2)
		Set ^TMP($zn,$j,NIndex,TransID)=$lb(EpisodeID_"||"_TransID,TransLoc,TransLocDesc,TransDate_" "_TransTime)
	}
	
	Set AdmStatus=$p($g(^PAADM(EpisodeID)),"^",20)
	//Set DischDate=$p($g(^PAADM(EpisodeID)),"^",17)
	//Set DischTime=$p($g(^PAADM(EpisodeID)),"^",18)
	//Update by pylian 2016-01-21 修改出院时间取值方式
	Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(EpisodeID)
	Set DischDate=$p(DischDateTime,"^",1)
	Set DischTime=$p(DischDateTime,"^",2)
	Set:DischDate'="" DischDate=$zd(DischDate,3)
	Set:DischTime'="" DischTime=$zt(DischTime,2)
	
	Set TransID=0
	For {
		Set TransID=$o(^TMP($zn,$j,NIndex,TransID))
		Quit:TransID=""
		
		Continue:$p(aTransID,"||",2)'=TransID
		
		Set (PrevTransLocID,PrevTransLocDesc,NextTransDate,NextTransLocID,NextTransLocDesc)=""
		Set PrevTransID=$o(^TMP($zn,$j,NIndex,TransID),-1)
		If PrevTransID'="" {
			Set PrevData=$g(^TMP($zn,$j,NIndex,PrevTransID))
			Set PrevTransLocID=$list(PrevData,2)
			Set PrevTransLocDesc=$list(PrevData,3)
		}
		Set:PrevTransLocDesc="" PrevTransLocDesc="入院"
		
		Set NextTransID=$o(^TMP($zn,$j,NIndex,TransID))
		If NextTransID'="" {
			Set NextData=$g(^TMP($zn,$j,NIndex,NextTransID))
			Set NextTransLocID=$list(NextData,2)
			Set NextTransLocDesc=$list(NextData,3)
			Set NextTransDate=$list(NextData,4)
		} Else {
			If AdmStatus="D" {
				Set NextTransLocDesc="出院"
				Set NextTransDate=DischDate_" "_DischTime
			}
		}
		
		Set tmpData=$g(^TMP($zn,$j,NIndex,TransID))
		Set TransRowID=$list(tmpData,1)
		Set TransLoc=$list(tmpData,2)
		Set TransLocDesc=$list(tmpData,3)
		Set TransInTime=$list(tmpData,4)
		Set return=TransRowID_"^"_TransLoc_"^"_TransLocDesc_"^"_TransInTime_"^"_NextTransDate_"^"_PrevTransLocID_"^"_PrevTransLocDesc_"^"_NextTransLocID_"^"_NextTransLocDesc
	}
	Kill ^TMP($zn,$j,NIndex)
	
	Quit return
}

/// 去除字符串前后空格，内部空格不删除
/// w ##class(DHCMed.NINFService.Srv.CommonCls).Trim("   aaa    ")
ClassMethod Trim(str As %String) As %String
{
	New (str)
	
	Set str=##Class(DHCMed.NINFService.Srv.CommonCls).Translate(str,"\n","")
	
	Set FromIndex=1
	Set ToIndex=$l(str)
	For i=1:1:$l(str)
	{
		Quit:($ASCII(str,i)'=32)&&($ASCII(str,i)'=9)&&($ASCII(str,i)'=10)&&($ASCII(str,i)'=13)
		Set FromIndex=FromIndex+1
	}
	For i=$l(str):-1:1
	{
		Quit:($ASCII(str,i)'=32)&&($ASCII(str,i)'=9)&&($ASCII(str,i)'=10)&&($ASCII(str,i)'=13)
		Set ToIndex=ToIndex-1
	}
	Quit:ToIndex<FromIndex ""
	Quit $e(str,FromIndex,ToIndex)
}

/// w ##Class(DHCMed.NINFService.Srv.CommonCls).Translate("aaaa\nbbb","\n","")
ClassMethod Translate(string As %String, identifier As %String, associator As %String) As %String
{
	New (string,identifier,associator)
	Set return=""
	Quit:(string="")||(identifier="") return
	
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

/// add by zf 20130808
/// 查询检验系统科室列表
/// d ##Class(%ResultSet).RunQuery("DHCMed.NINFService.Srv.CommonCls","QueryLabUserLoc","")
Query QueryLabUserLoc(aAlias As %String, aSSHospCode As %String) As %Query(ROWSPEC = "LocRowId:%String,LocDesc:%String,LocDesc1:%String")
{
}

ClassMethod QueryLabUserLocExecute(ByRef qHandle As %Binary, aAlias As %String, aSSHospCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xHospCode=""
	For {
		Set xHospCode=$o(^DHCMed.DC.BTLocI("IndexCode",xHospCode))
		Quit:xHospCode=""
		Continue:'$d(^DHCMed.DC.BTHospitalI("IndexSCode",xHospCode," "_$zcvt(aSSHospCode,"U"),1))
		
		Set xCode=""
		For {
			Set xCode=$o(^DHCMed.DC.BTLocI("IndexCode",xHospCode,xCode))
			Quit:xCode=""
			
			Set xID=0
			For {
				Set xID=$o(^DHCMed.DC.BTLocI("IndexCode",xHospCode,xCode,xID))
				Quit:xID=""
				
				Set obj=##class(DHCMed.DC.BTLoc).GetObjById(xID)
				Continue:'$IsObject(obj)
				
				Set LocDesc=obj.CName
				Continue:(aAlias'="")&&($zcvt(LocDesc,"U")'[$zcvt(aAlias,"U")) //别名
				Set LocDesc1=LocDesc
				Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
				
				Set LocID=obj.Code
				Set LocID=$tr(LocID,$c(13),"")
				Set LocID=$tr(LocID,$c(10),"")
				
				Set Data=$lb(LocID,LocDesc,LocDesc1)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QueryLabUserLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLabUserLocExecute ]
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

ClassMethod QueryLabUserLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLabUserLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// 取药学大类、药学子类、管制分类
/// w ##class(DHCMed.NINFService.Srv.CommonCls).GetPHCCat(ArcimID)
ClassMethod GetPHCCat(aArcimID As %String) As %String
{
	New (aArcimID)
	Set return=""
	Quit:aArcimID="" return
	
	Set DrgFormID=$p($g(^ARCIM(+aArcimID,1,1)),"^",12)  //PHC_DrgForm:药学形态
	Set DrgMastID=+DrgFormID                            //PHC_DrgMast药理学项
	Quit:DrgMastID=0 return
	
	Set AntiFlag=$p($g(^PHCD(+DrgFormID,"DF",$p(DrgFormID,"||",2),"DHC")),"^",8)
	Set AntiFlag=$s(AntiFlag="Y":AntiFlag="ANTI",1:"")
	
	Set SubCatID=$p($g(^PHCD(DrgMastID,1)),"^",3)       //PHC_SubCat药理学子分类
	Set SubCatCode=$p($g(^PHCC(+SubCatID,"SC",+$p(SubCatID,"||",2))),"^",1)
	Set SubCatDesc=$p($g(^PHCC(+SubCatID,"SC",+$p(SubCatID,"||",2))),"^",2)
	
	Set MinCatID=$p($g(^PHCD(DrgMastID,1)),"^",6)       //PHC_MinorSubCat药理学最小分类
	
	Set PHCCatID=+SubCatID                              //PHC_Cat药理学分类
	Set PHCCatCode=$p($g(^PHCC(PHCCatID)),"^",1)
	Set PHCCatDesc=$p($g(^PHCC(PHCCatID)),"^",2)
	
	Set PoisonID=$p($g(^PHCD(DrgMastID,1)),"^",4)      //PHC_Poison  管制分类
	Set PoisonCode=$p($g(^PHCPO(+PoisonID)),"^",1)
	Set PoisonDesc=$p($g(^PHCPO(+PoisonID)),"^",2)
	
	Set return=PHCCatID_$c(2)_PHCCatCode_$c(2)_PHCCatDesc
	Set return=return_$c(1)_SubCatID_$c(2)_SubCatCode_$c(2)_SubCatDesc
	Set return=return_$c(1)_PoisonID_$c(2)_PoisonCode_$c(2)_PoisonDesc
	Set return=return_$c(1)_AntiFlag
	Quit return
}

/// 取对照民科字典值，取之为空返回默认值
/// w ##class(DHCMed.NINFService.Srv.CommonCls).GetMapping()
ClassMethod GetMapping(aMappingType As %String, aSrcValue As %String, aSrcDesc As %String, aDefaultValue As %String = "") As %String
{
	New (aMappingType,aSrcValue,aSrcDesc,aDefaultValue)
	Set return=##class(DHCMed.NINFService.Srv.ExportMinkeSrv).GetMapping(aMappingType,aSrcValue,aSrcDesc,aDefaultValue)
	Quit return
}

}
