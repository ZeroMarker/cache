Import User

/// 名称: web.DHCCPW.MRC.ClinPathWaysSrv
/// 描述: 临床路径
/// 编写者：zhufei
/// 编写日期: 2010-05-13
Class web.DHCCPW.MRC.ClinPathWaysSrv Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     wuqk
/// CreatDate：   2010-06-03
/// Description:  根据Id取临床路径
/// Input：       User.DHCMRCClinPathWays.ID
/// w ##Class(web.DHCCPW.MRC.ClinPathWaysSrv).GetById(9)
ClassMethod GetById(id, separete) As %String
{
	new (id,separete)
	set ret=""
	set obj=##class(web.DHCCPW.MRC.CliPathWay).GetObjById(id)
	If $IsObject(obj){
		set:$g(separete)="" separete=..#SEPARATE
		set ret=id   //1
		set ret=ret_separete_obj.CPWCode  //2
		set ret=ret_separete_obj.CPWDesc  //3
		set ret=ret_separete_obj.CPWCPWTypeDR.%Id() //4
		set ret=ret_separete_$s(obj.CPWDateFrom="":"",1:##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(obj.CPWDateFrom))  //5
		set ret=ret_separete_$s(obj.CPWDateTo="":"",1:##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(obj.CPWDateTo))   //6
		set ret=ret_separete_obj.CPWICD  //7
		set ret=ret_separete_obj.CPWCost  //8
		set ret=ret_separete_obj.CPWDays  //9
		set ret=ret_separete_obj.CPWLabel  //10
		set ret=ret_separete_obj.CPWVarDesc  //11
		set ret=ret_separete_obj.CPWVersion  //12
		set ret=ret_separete_$s(obj.CPWVerDate="":"",1:##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(obj.CPWVerDate))  //13
		set ret=ret_separete_$s(obj.CPWVerTime="":"",1:$zt(obj.CPWVerTime,1))  //14
		set ret=ret_separete_obj.CPWVerUserDR  //15
		set ret=ret_separete_obj.CPWCPWDicDR.%Id()  //16
		
		set IsActive=obj.CPWActive
		set IsActive=$s(IsActive["Y":"Yes",1:"No")
		set ret=ret_separete_IsActive  //17
		set ret=ret_separete_obj.CPWCPWTypeDR.CLPTDesc  //18
		
		//add by wuqk 2011-07-21 是否分支型临床路径
		set IsOffShoot=obj.CPWOffShoot
		set IsOffShoot=$s(IsOffShoot["Y":"Yes",1:"No")
		set ret=ret_separete_IsOffShoot  //19
		set ret=ret_separete_obj.CPWCPWTypeDR.CLPTCode  //20
		set ret=ret_separete_""  //21
		set ret=ret_separete_""  //22
		set ret=ret_separete_obj.CPWKeys  //23
		set ret=ret_separete_obj.CPWOperICD  //24
		set ret=ret_separete_obj.CPWOperKeys  //25
	}
	quit ret
}

/// Creator：     wuqk
/// CreatDate：   2011-07-21
/// Description:  根据Id取临床路径帮助信息
/// Input：       User.DHCMRCClinPathWays.ID
/// w ##Class(web.DHCCPW.MRC.ClinPathWaysSrv).GetHelpById(9)
ClassMethod GetHelpById(id) As %String
{
	new (id)
	Set obj=##class(web.DHCCPW.MRC.CliPathWay).GetObjById(id)
	quit:'$IsObject(obj) 0
	set help=obj.CPWHelpFild
	set:help="nothing" help=""
	set:help="" help=obj.CPWDesc
	quit help
}

/// Creator：     wuqk
/// CreatDate：   2011-07-21
/// Description:  保存临床路径帮助信息
/// Input：       User.DHCMRCClinPathWays.ID
/// w ##Class(web.DHCCPW.MRC.ClinPathWaysSrv).UpdateHelp(9)
ClassMethod UpdateHelp(id, help) As %String
{
	new (id,help)
	Set obj=##class(User.DHCMRCClinPathWays).%OpenId(id)
	quit:'$IsObject(obj) 0
	set obj.CPWHelpFild=help
	set sc=obj.%Save()
	If $System.Status.IsError(sc) {                      //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	set obj=""
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2011-09-16
/// Description: 保存临床路径评估字典
/// Input：       User.DHCMRCClinPathWays.ID
/// w ##Class(web.DHCCPW.MRC.ClinPathWaysSrv).UpdateEvaluateList(9)
ClassMethod UpdateEvaluateList(id, eve) As %String
{
	new (id,eve)
	Set obj=##class(User.DHCMRCClinPathWays).%OpenId(id)
	quit:'$IsObject(obj) 0
	set len=$l(eve,"^")
	set list=$lb()
	for i=1:1:len {
		set $li(list,i)=$p(eve,"^",i)
	}
	set obj.CPWEvaluateList=list
	set sc=obj.%Save()
	If $System.Status.IsError(sc) {                      //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	set obj=""
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2011-09-16
/// Description:  根据Id取临床路径评估字典
/// Input：       User.DHCMRCClinPathWays.ID
/// w ##Class(web.DHCCPW.MRC.ClinPathWaysSrv).GetEvaluateListById(89)
ClassMethod GetEvaluateListById(id) As %String
{
	new (id)
	Set obj=##class(User.DHCMRCClinPathWays).%OpenId(id)
	quit:'$IsObject(obj) ""
	set ret="^"
	set list=obj.CPWEvaluateList
	quit:list="" list
	set len=$ll(list)
	for i=1:1:len {
		set ret=ret_$li(list,i)_"^"
	}
	Do obj.%Close()
	set obj=""
	quit ret
}

/// Creator：     zhufei
/// CreatDate：   2010-05-13
/// Description:  取科室常用临床路径
/// Input：       CT_Loc.ID
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.ClinPathWaysSrv","QryLocClinPathWays",argLocID)
Query QryLocClinPathWays(argLocID As %String) As %Query(ROWSPEC = "Rowid:%String,Desc:%String")
{
}

ClassMethod QryLocClinPathWaysExecute(ByRef qHandle As %Binary, argLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	//^DHCMRCi("DEPCPW",0,"IndexLoc",{LocID},{ID})
	Quit:argLocID="" $$$OK
	Quit:'$d(^DHCMRCi("DEPCPW",0,"IndexLoc"," "_argLocID)) $$$OK
	Set ID=0
	For {
		Set ID=$o(^DHCMRCi("DEPCPW",0,"IndexLoc"," "_argLocID,ID))
		Quit:ID=""
		
		Set objLocPathWay=##class(web.DHCCPW.MRC.DeptPahtWay).GetObjById(ID)
		If $IsObject(objLocPathWay)
		{
			If $IsObject(objLocPathWay.DCPWCPWDR)
			{
				Set IsActive=objLocPathWay.DCPWCPWDR.CPWDActive
				Set DateFrom=objLocPathWay.DCPWCPWDR.CPWDDateFrom
				Set DateTo=objLocPathWay.DCPWCPWDR.CPWDDateTo
				Set Version=objLocPathWay.DCPWCPWDR.CPWDVersion
				Set objCPW=##class(web.DHCCPW.MRC.CliPathWay).GetObjById(Version)
				Continue:'$IsObject(objCPW)
				Continue:IsActive'["Y"
				Continue:(IsActive["Y")&&(DateFrom'="")&&(DateFrom>+$h)
				Continue:(IsActive["Y")&&(DateTo'="")&&(DateTo<+$h)
				
				Set PathWayID=objCPW.%Id()
				Set PathWayDesc=objCPW.CPWDesc
				
				Set Data=$lb(PathWayID,PathWayDesc)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryLocClinPathWaysClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocClinPathWaysExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryLocClinPathWaysFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocClinPathWaysExecute ]
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
/// CreatDate：   2010-05-13
/// Description:  取临床路径字典
/// Input：       别名,类型
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.ClinPathWaysSrv","QryClinPathWays",argAlias,argType)
Query QryClinPathWays(argAlias As %String, argType As %String) As %Query(ROWSPEC = "Rowid:%String,Desc:%String")
{
}

ClassMethod QryClinPathWaysExecute(ByRef qHandle As %Binary, argAlias As %String, argType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	//^DHCMRC("CPWD",{Rowid})
	Set ID=0
	For {
		Set ID=$o(^DHCMRC("CPWD",ID))
		Quit:ID=""
		
		Set objCPWDic=##class(web.DHCCPW.MRC.ClinPathWaysDicSrv).GetObjById(ID)
		If $IsObject(objCPWDic)
		{
			Set IsActive=objCPWDic.CPWDActive
			Set DateFrom=objCPWDic.CPWDDateFrom
			Set DateTo=objCPWDic.CPWDDateTo
			Set Version=objCPWDic.CPWDVersion
			If $IsObject(objCPWDic.CPWDCPWTypeDR){
				Set CPWDTypeID=objCPWDic.CPWDCPWTypeDR.%Id()
				Set CPWDTypeCode=objCPWDic.CPWDCPWTypeDR.CLPTCode
				Continue:CPWDTypeCode="SYNDROME"
			}
			Set objCPW=##class(web.DHCCPW.MRC.CliPathWay).GetObjById(Version)
			Continue:'$IsObject(objCPW)
			Continue:IsActive'["Y"
			Continue:(IsActive["Y")&&(DateFrom'="")&&(DateFrom>+$h)
			Continue:(IsActive["Y")&&(DateTo'="")&&(DateTo<+$h)
			
			Set PathWayID=objCPW.%Id()
			Set PathWayDesc=objCPW.CPWDesc
			
			Set Data=$lb(PathWayID,PathWayDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryClinPathWaysClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryClinPathWaysExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryClinPathWaysFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryClinPathWaysExecute ]
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
/// CreatDate：   2010-05-13
/// Description:  取临床路径字典
/// Input：       
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.ClinPathWaysSrv","QryClinPathWayType")
Query QryClinPathWayType() As %Query(ROWSPEC = "Rowid:%String,Desc:%String")
{
}

ClassMethod QryClinPathWayTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set rset = ##class(%ResultSet).%New()
	Set rset.ClassName = "web.DHCCPW.MRC.PathWayType"
	Set rset.QueryName = "GetPathWayType"
	Set sc = rset.Execute()
	While (rset.Next(.sc))
	{
		If ($SYSTEM.Status.IsOK(sc))
		{
			Set Rowid=rset.Data("Rowid")
			Set Desc=rset.Data("desc")
			Set Data=$LB(Rowid,Desc)
			
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		} Else {
			Quit
		}
	}
	If $SYSTEM.Status.IsError(sc)
	{
    	Do $system.OBJ.DisplayError(sc)
	}
	
	Quit $$$OK
}

ClassMethod QryClinPathWayTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryClinPathWayTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryClinPathWayTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryClinPathWayTypeExecute ]
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

/// Creator：     wuqk
/// CreatDate：   2010-05-11
/// Description:  逐级查询临床路径，并按序号排序
/// Table：       User.DHCMRClinicalPathWay
/// Input：       User.DHCMRClinicalPathWay.Id
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.ClinPathWaysSrv","QueryCPWTree","72")
Query QueryCPWTree(ParentId As %String) As %Query(ROWSPEC = "id:%String,text:%String,leaf:%String")
{
}

ClassMethod QueryCPWTreeExecute(ByRef qHandle As %Binary, ParentId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set ZIndex=$zn,JIndex=$j
	kill ^TMP(ZIndex,JIndex)
	Set tempIndex=$I(^TMP(ZIndex,JIndex))
	
	set idDeep=$l(ParentId,"||")
	set cpwRowid=+ParentId
	if idDeep=1 {          //查询DHC_MRC_ClinPathWaysEp
		quit:'$d(^DHCMRC("CPW",cpwRowid,"EP")) $$$OK
		set epSub=$o(^DHCMRC("CPW",cpwRowid,"EP",""))
		while epSub'="" {
			set epRowid=cpwRowid_"||"_epSub
			set objEp=##class(web.DHCCPW.MRC.PathWayEp).GetObjById(epRowid)
			if $IsObject(objEp){
				set indexNo=+objEp.EPEpisode
				set id=""""_epRowid_""""
				//set text=""""_objEp.EPDesc_" "_objEp.EPEpisode_""""
				set text=""""_objEp.EPDesc_""""
				set data=$lb(id,text,"false")
				set ^TMP(ZIndex,JIndex,tempIndex,0,indexNo,id)=data
			}
			set epSub=$o(^DHCMRC("CPW",cpwRowid,"EP",epSub))
		}
	}elseif idDeep=2{       //查询DHC_MRC_ClinPathWaysEpStep
		set epSub=$p(ParentId,"||",2)
		quit:'$d(^DHCMRC("CPW",cpwRowid,"EP",epSub,"STEP")) $$$OK
		set stepSub=$o(^DHCMRC("CPW",cpwRowid,"EP",epSub,"STEP",""))
		while stepSub'="" {
			set stepRowid=cpwRowid_"||"_epSub_"||"_stepSub
			set objStep=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(stepRowid)
			if $IsObject(objStep){
				set indexNo=+objStep.CPWSDayNumber
				set id=""""_stepRowid_""""
				set text=""""_objStep.CPWSDesc_" "_objStep.CPWSDay_"days"_""""
				set data=$lb(id,text,"false")
				set ^TMP(ZIndex,JIndex,tempIndex,0,indexNo,id)=data
			}
			set stepSub=$o(^DHCMRC("CPW",cpwRowid,"EP",epSub,"STEP",stepSub))
		}
	}elseif idDeep=3{       //查询DHC_MRC_ClinPathWaysEpStepItem
		set epSub=$p(ParentId,"||",2)
		set stepSub=$p(ParentId,"||",3)
		quit:'$d(^DHCMRC("CPW",cpwRowid,"EP",epSub,"STEP",stepSub,"ITEM")) $$$OK
		set itemSub=$o(^DHCMRC("CPW",cpwRowid,"EP",epSub,"STEP",stepSub,"ITEM",""))
		while itemSub'="" {
			set itemRowid=cpwRowid_"||"_epSub_"||"_stepSub_"||"_itemSub
			set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(itemRowid)
			if $IsObject(objItem){
				set indexNo=+objItem.CPWSIGroupNo
				set id=""""_itemRowid_""""
				//*********************************************
				//update by zf 20101111
				Set ItemCategSubDesc="",ItemCategSubID=""
				If $IsObject(objItem.CPWSISubCategory){
					Set ItemCategSubID=objItem.CPWSISubCategory.%Id()
					Set ItemCategSubDesc=objItem.CPWSISubCategory.SISCDesc
				}
				Set:ItemCategSubDesc="" ItemCategSubDesc="未设置类型"
				Set:ItemCategSubID="" ItemCategSubID=0
				set text=""""_ItemCategSubDesc_"  "_indexNo_"  "_objItem.CPWSIDesc_""""
				set data=$lb(id,text,"true")
				set ^TMP(ZIndex,JIndex,tempIndex,ItemCategSubID,indexNo,id)=data
				//********************************************************
			}
			set itemSub=$o(^DHCMRC("CPW",cpwRowid,"EP",epSub,"STEP",stepSub,"ITEM",itemSub))
		}
	}
	set groupNo=""
	for {
		set groupNo=$o(^TMP(ZIndex,JIndex,tempIndex,groupNo))
		quit:groupNo=""
		
		set indexNo=$o(^TMP(ZIndex,JIndex,tempIndex,groupNo,""))
		while indexNo'="" {
			set id=$o(^TMP(ZIndex,JIndex,tempIndex,groupNo,indexNo,""))
			while id'="" {
				set ^CacheTemp(repid,ind)=$g(^TMP(ZIndex,JIndex,tempIndex,groupNo,indexNo,id))
				set ind=ind+1
				set id=$o(^TMP(ZIndex,JIndex,tempIndex,groupNo,indexNo,id))
			}
			set indexNo=$o(^TMP(ZIndex,JIndex,tempIndex,groupNo,indexNo))
		}
	}
	Kill ^TMP(ZIndex,JIndex)
	
	Quit $$$OK
}

ClassMethod QueryCPWTreeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCPWTreeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryCPWTreeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCPWTreeExecute ]
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

/// Creator：     wuqk
/// CreatDate：   2010-06-01
/// Description:  查询临床路径分类即路径名称
/// Table：       User.DHCMRClinicalPathWay
/// Input：       ParentId
/// Return：      
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.ClinPathWaysSrv","QueryCPWTypeTree","0")
Query QueryCPWTypeTree(ParentId As %String) As %Query(ROWSPEC = "id:%String,text:%String,leaf:%String")
{
}

ClassMethod QueryCPWTypeTreeExecute(ByRef qHandle As %Binary, ParentId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	if ParentId=0{
		//^DHCMRC("CLPT")
		set SqlStr="SELECT CLPT_RowId,CLPT_Desc from DHC_MRC_ClinPathType where CLPT_Code<>'SYNDROME'"
    	Set result=##class(%ResultSet).%New("%DynamicQuery:SQL")
    	Set sc=result.Prepare(SqlStr)
		If $$$ISERR(sc) q ret
		Set sc=result.Execute()
		If $$$ISERR(sc) q ret
		While result.Next(.sc) {
			If $$$ISERR(sc) Quit
			set id="""T"_result.Data("CLPT_RowId")_""""
			set desc=""""_result.Data("CLPT_Desc")_""""
			set ^CacheTemp(repid,ind)=$LB(id,desc,"false")
			set ind=ind+1
		}
		set ^CacheTemp(repid,ind)=$LB("""T""","""其它""","false")
		set ind=ind+1
	} ElseIf ParentId["T"{
		Set TypeID=$p(ParentId,"T",2)
		Set CPWID=0
		For {
			Set CPWID=$o(^DHCMRC("CPW",CPWID))
			Quit:CPWID=""
			
			Set (CPWTypeID,CPWDesc,DateFrom,DateTo,IsActive)=""
			Set objCPW=##Class(web.DHCCPW.MRC.CliPathWay).GetObjById(CPWID)
			If $IsObject(objCPW){
				If $IsObject(objCPW.CPWCPWTypeDR){
					Set CPWTypeID=objCPW.CPWCPWTypeDR.%Id()
				}
				Set IsActive=objCPW.CPWActive
				Set DateFrom=objCPW.CPWDateFrom
				Set DateTo=objCPW.CPWDateTo
				Set CPWDesc=objCPW.CPWDesc
			}
			Continue:CPWTypeID'=TypeID
			Continue:IsActive'["Y"
			Continue:(IsActive["Y")&&(DateFrom'="")&&(DateFrom>+$h)
			Continue:(IsActive["Y")&&(DateTo'="")&&(DateTo<+$h)
			
			Set CPWDicID=$o(^DHCMRCi("CPWD",0,"IndexVersion",CPWID,0))
			Continue:CPWDicID=""
			Set objCPWDic=##class(web.DHCCPW.MRC.ClinPathWaysDicSrv).GetObjById(CPWDicID)
			Continue:'$IsObject(objCPWDic)
			
			Set ID=""""_CPWID_""""
			Set Desc=""""_CPWDesc_""""
			Set Data=$lb(ID,Desc,"true")
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QueryCPWTypeTreeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCPWTypeTreeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryCPWTypeTreeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCPWTypeTreeExecute ]
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

/// Creator：     wuqk
/// CreatDate：   2010-06-01
/// Description:  按顺序构造临床路阶段
/// Table：       
/// Input：       cpwRowid
/// Return：      step List
/// Others:       
/// w ##class(web.DHCCPW.MRC.ClinPathWaysSrv).BuildSteps(9)
ClassMethod BuildSteps(cpwRowid) As %List
{
	new (cpwRowid)
	set stepList=$LB()
	quit:'$d(^DHCMRC("CPW",cpwRowid,"EP")) stepList
	set tempIndex=$I(^CacheTemp)
	set ind=1
	//查询DHC_MRC_ClinPathWaysEp
	set epSub=$o(^DHCMRC("CPW",cpwRowid,"EP",""))
	while epSub'="" {
		set epRowid=cpwRowid_"||"_epSub
		set objEp=##class(web.DHCCPW.MRC.PathWayEp).GetObjById(epRowid)
		if $IsObject(objEp){
			set EpNo=+objEp.EPEpisode
			set stepSub=$o(^DHCMRC("CPW",cpwRowid,"EP",epSub,"STEP",""))
			while stepSub'="" {
				set stepRowid=cpwRowid_"||"_epSub_"||"_stepSub
				set objStep=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(stepRowid)
				if $IsObject(objStep){
					set dayNo=+objStep.CPWSDayNumber
					set data=$lb(stepRowid,objStep.CPWSDesc,objStep.CPWSDay)
					//set data=stepRowid_"/"_objStep.CPWSDesc_"/"_objStep.CPWSDay
					set ^CacheTemp(tempIndex,EpNo,dayNo,stepRowid)=data
				}
				set stepSub=$o(^DHCMRC("CPW",cpwRowid,"EP",epSub,"STEP",stepSub))
			}
		}
		set epSub=$o(^DHCMRC("CPW",cpwRowid,"EP",epSub))
	}

	set EpNo=$o(^CacheTemp(tempIndex,""))
	while EpNo'="" {
		set dayNo=$o(^CacheTemp(tempIndex,EpNo,""))
		while dayNo'="" {
			set id=$o(^CacheTemp(tempIndex,EpNo,dayNo,""))
			while id'="" {
				set data=$g(^CacheTemp(tempIndex,EpNo,dayNo,id))
				set $Li(stepList,ind)=data
				//w !,ind,data
				set ind=ind+1
				set id=$o(^CacheTemp(tempIndex,EpNo,dayNo,id))
			}
			set dayNo=$o(^CacheTemp(tempIndex,EpNo,dayNo))
		}
		set EpNo=$o(^CacheTemp(tempIndex,EpNo))
	}
	Kill ^CacheTemp(tempIndex)
	Quit stepList
}

/// Creator：     zhufei
/// CreatDate：   2010-05-20
/// Description:  取临床路径阶段
/// Input：       
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.ClinPathWaysSrv","QryPathWayEp")
Query QryPathWayEp(argPathWayID As %String) As %Query(ROWSPEC = "Rowid:%String,Desc:%String,ChildSub:%String")
{
}

ClassMethod QryPathWayEpExecute(ByRef qHandle As %Binary, argPathWayID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	//^DHCMRCi("CPW",{Parref},"EP",{ChildSub})
	Quit:argPathWayID="" $$$OK
	Quit:'$d(^DHCMRC("CPW",argPathWayID,"EP")) $$$OK
	Set ChildSub=0
	For {
		Set ChildSub=$o(^DHCMRC("CPW",argPathWayID,"EP",ChildSub))
		Quit:ChildSub=""
		
		Set ID=argPathWayID_"||"_ChildSub
		Set objEp=##class(web.DHCCPW.MRC.PathWayEp).GetObjById(ID)
		If $IsObject(objEp)
		{
			Set EpID=objEp.%Id()
			Set EpDesc=objEp.EPDesc
			Set EpChildSub=ChildSub
		} Else {
			Quit
		}
		
		Set Data=$lb(EpID,EpDesc,EpChildSub)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryPathWayEpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathWayEpExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathWayEpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathWayEpExecute ]
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
/// CreatDate：   2010-05-20
/// Description:  取临床路径步骤
/// Input：       
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.ClinPathWaysSrv","QryPathWayEpStep","10||5")
Query QryPathWayEpStep(argPathWayEpID As %String) As %Query(ROWSPEC = "Rowid:%String,Desc:%String,ChildSub:%String")
{
}

ClassMethod QryPathWayEpStepExecute(ByRef qHandle As %Binary, argPathWayEpID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	
	//^DHCMRCi("CPW",{CPWID},"EP",{CPWEpID},"STEP",{ChildSub})
	Set CPWID=$p(argPathWayEpID,"||",1)
	Set CPWEpID=$p(argPathWayEpID,"||",2)
	Quit:(CPWID="")||(CPWEpID="") $$$OK
	Quit:'$d(^DHCMRC("CPW",CPWID,"EP",CPWEpID,"STEP")) $$$OK
	Set ChildSub=0
	For {
		Set ChildSub=$o(^DHCMRC("CPW",CPWID,"EP",CPWEpID,"STEP",ChildSub))
		Quit:ChildSub=""
		
		Set ID=argPathWayEpID_"||"_ChildSub
		Set objEpStep=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(ID)
		If $IsObject(objEpStep)
		{
			Set EpStepID=objEpStep.%Id()
			Set EpStepDesc=objEpStep.CPWSDesc
			Set EpStepChildSub=ChildSub
		} Else {
			Quit
		}
		
		Set Data=$lb(EpStepID,EpStepDesc,EpStepChildSub)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryPathWayEpStepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathWayEpStepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathWayEpStepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathWayEpStepExecute ]
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

ClassMethod GetSysDateTime() As %String
{
	Quit $zd(+$h,3)_" "_$zt($p($h,",",2),1)
}

/// Creator：     wuqk
/// CreatDate：   2010-06-03
/// Description:  根据Item Id取临床路径项目对应的医嘱项
/// Input：       User.DHCMRCClinPathWaysEpStepItem.ID
/// output:       $c(1) 分隔的 User.DHCMRCClinPathWaysARCIM项目
/// w ##Class(web.DHCCPW.MRC.ClinPathWaysSrv).GetItemDetailsById("70||1||1||6")
ClassMethod GetItemDetailsById(id) As %String
{
	new (id)
	set ret=""
	set:id["-" id=$p(id,"-",1)
	quit:id="" ret
	
	set $ZT="GetItemDetailsByIdErr"
	set ZIndex=$zn,JIndex=$j
	set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(id)
	if $IsObject(objItem){
		set orderSetId=objItem.CPWSIOrdSetDR
		set listARCIM=objItem.CPWSIARCIM
		quit:orderSetId'="" ret
		set listLen=listARCIM.Count()
		quit:listLen<1 ret
		
		//add by zf 20120214 增加是否必选项目(Y:可选,N:必选)
		Set isOptional=objItem.CPWSIIsMust
		Set isOptional=$s(isOptional["Y":"Y",1:"N")
		
		set itmString=""
		for index=1:1:listLen  {
			set objItemARCIM=listARCIM.GetAt(index)
			if $IsObject(objItemARCIM){
				set arcim=objItemARCIM.ITMARCIMDR
				continue:arcim=""
				set itmNo=objItemARCIM.ITMNo
				continue:itmNo=""
				set isActive=objItemARCIM.ITMIsActive
				continue:isActive["N"  //空和Y为有效医嘱
				set priority=objItemARCIM.ITMPriority
				set itmResume=objItemARCIM.ITMResume
				set itmLinkNo=objItemARCIM.ITMLinkNo
				set:itmLinkNo="" itmLinkNo=itmNo
				set default=objItemARCIM.ITMDefault
				//fix by liyi 2014-12-23 关联医嘱项目是否默认应与主医嘱项一致
				if itmLinkNo'=itmNo{
					for xIndex = 1:1:listLen {
						set objPrfItemARCIM=listARCIM.GetAt(xIndex)
						if $IsObject(objPrfItemARCIM){
							if (objPrfItemARCIM.ITMNo=itmLinkNo){
								set default=objPrfItemARCIM.ITMDefault
							}
						} 
					}
				}
				set:priority'="" priority=$p($g(^OECPR(+priority)),"^",2)
				set:priority="" priority="临时医嘱"
				if $l(arcim,"||")=2 {
					set arcimDesc=$p($g(^ARCIM(+$p(arcim,"||",1),+$p(arcim,"||",2),1)),"^",2)
					set effDateFrom=$p($g(^ARCIM(+$p(arcim,"||",1),+$p(arcim,"||",2),1)),"^",13)
					set:effDateFrom'="" effDateFrom=$p(effDateFrom,"Z",1)
					set effDateTo=$p($g(^ARCIM(+$p(arcim,"||",1),+$p(arcim,"||",2),7)),"^",1)
				}else{
					set arcimDesc=$p($g(^ARCOS(+arcim)),"^",2)
					set arcimDesc="[医嘱套]"_arcimDesc
					set effDateFrom=$p($g(^ARCOS(+arcim)),"^",15)
					set effDateTo=$p($g(^ARCOS(+arcim)),"^",16)
				}
				continue:arcimDesc=""
				set:itmResume'="" arcimDesc=arcimDesc_"("_itmResume_")"
				set arcimDesc="["_$tr(priority,"医嘱","")_"]"_arcimDesc
				
				set currDate=+$h,effInfo=""
				set:((effDateFrom'="")&&(effDateFrom>currDate)) effInfo="无效医嘱"
				set:((effDateTo'="")&&(effDateTo<currDate)) effInfo="无效医嘱"
				continue:effInfo'=""
				
				set itmString=index_"^"_arcim_"^"_arcimDesc_"^"_default_"^"_itmLinkNo_"^"_isOptional
				set num=$i(^TMP(ZIndex,JIndex,"GetItemDetailsById",+itmNo))
				set ^TMP(ZIndex,JIndex,"GetItemDetailsById",+itmNo,num)=itmString
			}
			kill objItemARCIM
		}
	}
	
	Set itmNo=""
	For {
		Set itmNo=$o(^TMP(ZIndex,JIndex,"GetItemDetailsById",itmNo))
		Quit:itmNo=""
		Set num=""
		For {
			Set num=$o(^TMP(ZIndex,JIndex,"GetItemDetailsById",itmNo,num))
			Quit:num=""
			Set itmString=$g(^TMP(ZIndex,JIndex,"GetItemDetailsById",itmNo,num))
			Set ret=ret_itmString_$c(1)
		}
	}
	Kill ^TMP(ZIndex,JIndex,"GetItemDetailsById")
	
	Quit ret
	
GetItemDetailsByIdErr
	Quit ""
}

/*
/// 创建者：李阳
/// 创建日期：2010-12-13
/// 获取临床路径字典项目
Query QryPathWaysDic() As %SQLQuery(ROWSPEC = "Rowid:%String,IsActive:%String,Code:%String,PathTypeID:%String,DateFrom:%String,DateTo:%String,Desc:%String,VersionDesc:%String")
{
SELECT %ID,CPWD_Active,CPWD_Code,CPWD_CPWType_DR->%ID,CPWD_DateFrom,CPWD_DateTo,CPWD_Desc,CPWD_Version FROM DHC_MRC_ClinPathWaysDic
 ORDER BY %ID
}
*/
/// 创建者：李阳
/// 创建日期：2010-12-18
/// 获取临床路径字典项目
/// VersionID:User.DHCMRCClinPathWays的Rowid
/// PublishUser:发布人
ClassMethod PublishPathWayVersion(VersionID As %String, PublishUser As %String) As %String
{
	New (VersionID,PublishUser)
	Set return=-1
	
	Set objVer=##class(User.DHCMRCClinPathWays).%OpenId(VersionID)
	Quit:'$IsObject(objVer) return
	Set objVer.CPWVerDate=+$h
	Set objVer.CPWVerTime=$p($h,",",2)
	Set objVer.CPWVerUserDR=+PublishUser
	Set sc=objVer.%Save()
	If $System.Status.IsError(sc) {          //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-2
	} Else {
		Set return=objVer.%Id()
	}
	Do objVer.%Close()
	Quit:return<0 return
	
	Set return=-3
	Set CPWID=objVer.%Id()
	Set objCPWDic=objVer.CPWCPWDicDR
	Quit:'$IsObject(objCPWDic) return
	Set objCPWDic.CPWDVersion=CPWID          //保存当前有效版本号
	Set sc=objCPWDic.%Save()
	If $System.Status.IsError(sc) {          //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-4
	} Else {
		Set return=objCPWDic.%Id()
	}
	Do objCPWDic.%Close()
	Quit:return<0 return
	
	Set return=CPWID
	Quit return
}

/// 创建者：李阳
/// 创建日期：2010-12-18
/// 获取临床路径字典项目
/// VersionID:User.DHCMRCClinPathWays的Rowid
/// PublishUser:发布人
ClassMethod UpdoPublishVersion(VersionID As %String, PublishUser As %String) As %String
{
	New (VersionID,PublishUser)
	Set return=-1
	
	Set objVer=##class(User.DHCMRCClinPathWays).%OpenId(VersionID)
	Quit:'$IsObject(objVer) return
	Set objVer.CPWVerDate=""
	Set objVer.CPWVerTime=""
	Set objVer.CPWVerUserDR=+PublishUser
	Set sc=objVer.%Save()
	If $System.Status.IsError(sc) {          //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-2
	} Else {
		Set return=objVer.%Id()
	}
	Do objVer.%Close()
	
	Quit return
}

/// 创建日期：2010-12-23
/// 复制版本
/// VersionID:需要复制的版本ID---------User.DHCMRCClinPathWays.%Id()
/// Debug:w ##class(web.DHCCPW.MRC.ClinPathWaysSrv).CopyPathWayVersion(67)
ClassMethod CopyPathWayVersion(argCPWID As %String) As %Integer
{
	New (argCPWID)
	Set return=-1
	Quit:argCPWID="" return
	
	Set objVer=##class(web.DHCCPW.MRC.CliPathWay).GetObjById(argCPWID)
	Quit:'$IsObject(objVer) return
	Set CPWDicID=objVer.CPWCPWDicDR.%Id()
	Set LastVer=+$o(^DHCMRCi("CPW",0,"IndexClinPathWaysDicVer",CPWDicID,""),-1)
	Set LastVer=$s(LastVer<0:1,1:LastVer+1)
	
	//复制版本内容
	Set objNewVer=##class(User.DHCMRCClinPathWays).%New()
	Set objNewVer.CPWActive="Y"
	Set objNewVer.CPWCPWTypeDR=objVer.CPWCPWTypeDR
	Set objNewVer.CPWCode=objVer.CPWCode
	Set objNewVer.CPWDateFrom=objVer.CPWDateFrom
	Set objNewVer.CPWDateTo=objVer.CPWDateTo
	Set objNewVer.CPWDesc=objVer.CPWDesc
	Set objNewVer.CPWCost=objVer.CPWCost
	Set objNewVer.CPWDays=objVer.CPWDays
	Set objNewVer.CPWICD=objVer.CPWICD
	Set objNewVer.CPWLabel=objVer.CPWLabel
	Set objNewVer.CPWVarDesc=objVer.CPWVarDesc
	Set objNewVer.CPWVersion=LastVer
	Set objNewVer.CPWVerDate=""
	Set objNewVer.CPWVerTime=""
	Set objNewVer.CPWVerUserDR=""
	Set objNewVer.CPWCPWDicDR=objVer.CPWCPWDicDR
	Set objNewVer.CPWOffShoot=objVer.CPWOffShoot    //add by wuqk 2011-07-21
	Set objNewVer.CPWHelpFild=objVer.CPWHelpFild
	Set objNewVer.CPWEvaluateList=objVer.CPWEvaluateList    //add by wuqk 2011-09-16
	
	Set sc=objNewVer.%Save()
	If $System.Status.IsError(sc) {          //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-2
	} Else {
		Set CPWID=objNewVer.%Id()
		
		//复制阶段内容
		Set EpID=0
		For {
			Set EpID=$o(^DHCMRC("CPW",argCPWID,"EP",EpID))
			Quit:EpID=""
			Set objEp=##class(web.DHCCPW.MRC.PathWayEp).GetObjById(argCPWID_"||"_EpID)
			Set objNewEp=##class(User.DHCMRCClinPathWaysEp).%New()
			Set objNewEp.EPParRef=objNewVer
			Set objNewEp.EPDesc=objEp.EPDesc
			Set objNewEp.EPEpisode=objEp.EPEpisode
			Set objNewEp.EPNotes=objEp.EPNotes
			Set sc=objNewEp.%Save()
			If $System.Status.IsError(sc) {          //检查Save是否成功
		   		Do $system.OBJ.DisplayError(sc) 
		   		Set return=-3
			} Else {
				Set EpRowID=objNewEp.%Id()
				
				//复制步骤内容
				Set StepID=0
				For {
					Set StepID=$o(^DHCMRC("CPW",argCPWID,"EP",EpID,"STEP",StepID))
					Quit:StepID=""
					Set objStep=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(argCPWID_"||"_EpID_"||"_StepID)
					Set objNewStep=##class(User.DHCMRCClinPathWaysEpStep).%New()
					Set objNewStep.CPWSParRef=objNewEp
					Set objNewStep.CPWSDayNumber=objStep.CPWSDayNumber
					Set objNewStep.CPWSDay=objStep.CPWSDay
					Set objNewStep.CPWSDesc=objStep.CPWSDesc
					Set objNewStep.CPWSUnit=objStep.CPWSUnit
					Set objNewStep.CPWSStepTypeCode=objStep.CPWSStepTypeCode  //add by wuqk 2012-04-24
					Set sc=objNewStep.%Save()
					If $System.Status.IsError(sc) {          //检查Save是否成功
				   		Do $system.OBJ.DisplayError(sc) 
				   		Set return=-4
					} Else {
						Set StepRowID=objNewStep.%Id()
						
						//复制项目内容
						Set ItemID=0
						For {
							Set ItemID=$o(^DHCMRC("CPW",argCPWID,"EP",EpID,"STEP",StepID,"ITEM",ItemID))
							Quit:ItemID=""
							Set objItm=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(argCPWID_"||"_EpID_"||"_StepID_"||"_ItemID)
							Set objNewItm=##class(User.DHCMRCClinPathWaysEpStepItem).%New()
							Set objNewItm.CPWSIARCIM=objItm.CPWSIARCIM
							Set objNewItm.CPWSICheckDesc=objItm.CPWSICheckDesc
							Set objNewItm.CPWSIParRef=objNewStep
							Set objNewItm.CPWSICheckPoint=objItm.CPWSICheckPoint
							Set objNewItm.CPWSIDesc=objItm.CPWSIDesc
							Set objNewItm.CPWSIGroupNo=objItm.CPWSIGroupNo
							Set objNewItm.CPWSIOrdSetDR=objItm.CPWSIOrdSetDR
							Set objNewItm.CPWSISubCategory=objItm.CPWSISubCategory
							Set objNewItm.CPWSIIsMust=objItm.CPWSIIsMust
							Set sc=objNewItm.%Save()
							If $System.Status.IsError(sc) {          //检查Save是否成功
						   		Do $system.OBJ.DisplayError(sc) 
						   		Set return=-5
							} Else {
								Set ItemRowID=objNewItm.%Id()
								
								//复制通用名内容
								Set GeneID=0
								For {
									Set GeneID=$o(^DHCMRC("CPW",argCPWID,"EP",EpID,"STEP",StepID,"ITEM",ItemID,"GENE",GeneID))
									Quit:GeneID=""
									Set objGene=##class(User.DHCMRCClinPathWaysItmGene).GetObjById(argCPWID_"||"_EpID_"||"_StepID_"||"_ItemID_"||"_GeneID)
									Continue:'$IsObject(objGene)
									Set objNewGene=##class(User.DHCMRCClinPathWaysItmGene).%New()
									Set objNewGene.IGParref=objNewItm
									Set objNewGene.IGNo=objGene.IGNo
									Set objNewGene.IGGeneID=objGene.IGGeneID
									Set objNewGene.IGGeneDesc=objGene.IGGeneDesc
									Set objNewGene.IGLinkNo=objGene.IGLinkNo
									Set objNewGene.IGPriority=objGene.IGPriority
									Set objNewGene.IGIsMain=objGene.IGIsMain
									Set objNewGene.IGArcimList=objGene.IGArcimList
									Set sc=objNewGene.%Save()
									If $System.Status.IsError(sc) {          //检查Save是否成功
								   		Do $system.OBJ.DisplayError(sc) 
								   		Set return=-6
									} Else {
										Set GeneRowID=objNewGene.%Id()
									}
									Do objNewGene.%Close()
								}
							}
							Do objNewItm.%Close()
						}
					}
					Do objNewStep.%Close()
				}
			}
			Do objNewEp.%Close()
		}
		Set return=CPWID
	}
	Do objNewVer.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2011-03-01
/// Description:  检查有几个未发布版本
/// Input：       User.DHCMRCClinPathWays.ID
/// output:       num
/// w ##Class(web.DHCCPW.MRC.ClinPathWaysSrv).GetNotPubVer(65)
ClassMethod GetNotPubVer(argCPWDicID As %String, argCPWID As %String) As %String
{
	New (argCPWDicID,argCPWID)
	Set return=0
	Quit:(argCPWDicID="")&&(argCPWID="") return
	
	If argCPWID'="" {
		Set objCPW=##class(web.DHCCPW.MRC.CliPathWay).GetObjById(argCPWID)
		If $IsObject(objCPW) {
			If $IsObject(objCPW.CPWCPWDicDR) {
				Set argCPWDicID=objCPW.CPWCPWDicDR.%Id()
			}
		}
	}
	
	Set Version=0
	For {
		Set Version=$o(^DHCMRCi("CPW",0,"IndexClinPathWaysDicVer",argCPWDicID,Version))
		Quit:Version=""
		Set CPWID=0
		For {
			Set CPWID=$o(^DHCMRCi("CPW",0,"IndexClinPathWaysDicVer",argCPWDicID,Version,CPWID))
			Quit:CPWID=""
			Set (VerDate,VerTime,VerUser)=""
			Set objCPW=##class(web.DHCCPW.MRC.CliPathWay).GetObjById(CPWID)
			If $IsObject(objCPW) {
				Set VerDate=objCPW.CPWVerDate
				Set VerTime=objCPW.CPWVerTime
				Set VerUser=objCPW.CPWVerUserDR
				Continue:(VerDate'="")&&(VerUser'="")
				Set return=return+1
			}
		}
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2011-07-27
/// Description:  取科室常用临床路径/全部临床路径
/// Input：       CT_Loc.ID
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.ClinPathWaysSrv","QryCPWToInPathWay",8)
Query QryCPWToInPathWay(argLocID As %String) As %Query(ROWSPEC = "CPWID:%String,CPWDesc:%String,CPWType:%String,CPWOffShoot:%String")
{
}

ClassMethod QryCPWToInPathWayExecute(ByRef qHandle As %Binary, argLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	If argLocID'="" {
		//^DHCMRCi("DEPCPW",0,"IndexLoc",{LocID},{ID})
		Set ID=0
		For {
			Set ID=$o(^DHCMRCi("DEPCPW",0,"IndexLoc"," "_argLocID,ID))
			Quit:ID=""
			
			Set objLocPathWay=##class(web.DHCCPW.MRC.DeptPahtWay).GetObjById(ID)
			If $IsObject(objLocPathWay)
			{
				If $IsObject(objLocPathWay.DCPWCPWDR)
				{
					If $IsObject(objLocPathWay.DCPWCPWDR.CPWDCPWTypeDR){
						Set CPWDType=objLocPathWay.DCPWCPWDR.CPWDCPWTypeDR.CLPTDesc
						Continue:objLocPathWay.DCPWCPWDR.CPWDCPWTypeDR.CLPTCode="SYNDROME"
					}Else{
						Set CPWDType="其他"
					}
					Set IsActive=objLocPathWay.DCPWCPWDR.CPWDActive
					Set DateFrom=objLocPathWay.DCPWCPWDR.CPWDDateFrom
					Set DateTo=objLocPathWay.DCPWCPWDR.CPWDDateTo
					Set Version=objLocPathWay.DCPWCPWDR.CPWDVersion
					Set objCPW=##class(web.DHCCPW.MRC.CliPathWay).GetObjById(Version)
					Continue:'$IsObject(objCPW)
					Continue:IsActive'["Y"
					Continue:(IsActive["Y")&&(DateFrom'="")&&(DateFrom>+$h)
					Continue:(IsActive["Y")&&(DateTo'="")&&(DateTo<+$h)
					
					Set CPWID=objCPW.%Id()
					Set CPWDesc=objCPW.CPWDesc
					Set CPWOffShoot=objCPW.CPWOffShoot
					Set CPWOffShoot=$s(CPWOffShoot["Y":"是",1:"否")
					
					Set Data=$lb(CPWID,CPWDesc,CPWDType,CPWOffShoot)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	}Else{
		Set CPWDicID=0
		For {
			Set CPWDicID=$o(^DHCMRC("CPWD",CPWDicID))
			Quit:CPWDicID=""
			Set objCPWDic=##class(web.DHCCPW.MRC.ClinPathWaysDicSrv).GetObjById(CPWDicID)
			Continue:'$IsObject(objCPWDic)
			If $IsObject(objCPWDic.CPWDCPWTypeDR){
				Continue:objCPWDic.CPWDCPWTypeDR.CLPTCode="SYNDROME"
				Set CPWDType=objCPWDic.CPWDCPWTypeDR.CLPTDesc
			}Else{
				Set CPWDType="其他"
			}
			Set IsActive=objCPWDic.CPWDActive
			Set DateFrom=objCPWDic.CPWDDateFrom
			Set DateTo=objCPWDic.CPWDDateTo
			Set Version=objCPWDic.CPWDVersion
			Set objCPW=##class(web.DHCCPW.MRC.CliPathWay).GetObjById(Version)
			Continue:'$IsObject(objCPW)
			Continue:IsActive'["Y"
			Continue:(IsActive["Y")&&(DateFrom'="")&&(DateFrom>+$h)
			Continue:(IsActive["Y")&&(DateTo'="")&&(DateTo<+$h)
			
			Set CPWID=objCPW.%Id()
			Set CPWDesc=objCPW.CPWDesc
			Set CPWOffShoot=objCPW.CPWOffShoot
			Set CPWOffShoot=$s(CPWOffShoot["Y":"是",1:"否")
			
			Set Data=$lb(CPWID,CPWDesc,CPWDType,CPWOffShoot)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryCPWToInPathWayClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWToInPathWayExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCPWToInPathWayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWToInPathWayExecute ]
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

/// by   :  wuqk
/// Date :  2011-10-26
/// desc :  将路径版本另存为新路径
/// input:
///       CPWID  :当前路径版本Id  User.DHCMRCClinPathWays.%Id
///       NewName:新路径名称
/// return: 
///       >0:成功，返回新版本Id
///       <0:失败
/// w ##class(web.DHCCPW.MRC.ClinPathWaysSrv).SaveAsNew(CPWID,NewName)
ClassMethod SaveAsNew(CPWID, NewName)
{
	new (CPWID,NewName)
	q:CPWID="" -1
	q:NewName="" -1
	
	Set tmpCPWDicID=0,IsSameName="N"
	For {
		Set tmpCPWDicID=$o(^DHCMRC("CPWD",tmpCPWDicID))
		Quit:tmpCPWDicID=""
		Quit:IsSameName="Y"
		Set objCPWDic=##class(web.DHCCPW.MRC.ClinPathWaysDicSrv).GetObjById(tmpCPWDicID)
		Continue:'$IsObject(objCPWDic)
		Set tmpCPWDicName=objCPWDic.CPWDDesc
		Continue:tmpCPWDicName'=NewName
		Set IsSameName="Y"
	}
	Quit:IsSameName="Y" -101
	
	s objVer=##class(User.DHCMRCClinPathWays).%OpenId(CPWID)
	q:'$IsObject(objVer) -2
	s return=""
	TStart
	s cpwDicId=objVer.CPWCPWDicDR.%Id()
	//^DHCMRC("CPWD")
	s objDicNew=##class(User.DHCMRCClinPathWaysDic).%New()
	s sc=objDicNew.%Save()
	If $System.Status.IsError(sc) {                      //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-13
   		TRollBack
	} Else {
		Set return=objDicNew.%Id()
	}
	s objDicNew=""
	q:return<0 return
	s cpwDicIdNew=return
	s newCode=$$GetNewDicNO()
	m ^DHCMRC("CPWD",cpwDicIdNew)=^DHCMRC("CPWD",cpwDicId)
	s objDicNew=##class(User.DHCMRCClinPathWaysDic).%OpenId(cpwDicIdNew)
	s objDicNew.CPWDCode=newCode
	s objDicNew.CPWDDesc=NewName
	s objDicNew.CPWDVersion=""
	s sc=objDicNew.%Save()
	If $System.Status.IsError(sc) {                      //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-14
   		TRollBack
	}
	q:return<0 return
	
	s objVerNew=##class(User.DHCMRCClinPathWays).%New()
	s sc=objVerNew.%Save()
	If $System.Status.IsError(sc) {                      //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-23
   		TRollBack
	} Else {
		Set return=objVerNew.%Id()
	}
	s objVerNew=""
	q:return<0 return
	s verIdNew=return
	m ^DHCMRC("CPW",verIdNew)=^DHCMRC("CPW",CPWID)
	s objVerNew=##class(User.DHCMRCClinPathWays).%OpenId(verIdNew)
	s objVerNew.CPWCPWDicDR=objDicNew
	s objVerNew.CPWCode=newCode
	s objVerNew.CPWDesc=NewName
	s objVerNew.CPWVersion="1"
	s objVerNew.CPWVerDate=""
	s objVerNew.CPWVerTime=""
	s objVerNew.CPWVerUserDR=""
	s sc=objVerNew.%Save()
	If $System.Status.IsError(sc) {                      //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-24
   		TRollBack
	}
	q:return<0 return

	Do ##class(User.DHCMRCClinPathWaysItmGene).%BuildIndices()
	Do ##class(User.DHCMRCClinPathWaysEpStepItem).%BuildIndices()	//update by liuyh 2017-03-22

	TCommit
	q verIdNew
	
GetNewDicNO()
	Set Head=$tr($zd(+$h,3),"-","")
	Set tmp=""
	Set Num=$i(^DHCMRCTD("FormInd",Head))
	Set $p(tmp,"0",5-$l(Num))=Num
	Set tmp=Head_tmp
	quit tmp
}

/// w ##class(web.DHCCPW.MRC.ClinPathWaysSrv).cntEpStepItem(5)
ClassMethod cntEpStepItem(CPWID As %String) As %String
{
	New (CPWID)
	Set $zt="cntEpStepItemErr"
	Set (cntEp,cntStep,cntItem,cntItem01,cntItem02,cntItem03)=0
	Set ret=cntEp_"^"_cntStep_"^"_cntItem_"^"_cntItem01_"^"_cntItem02_"^"_cntItem03
	Quit:(+CPWID=0) ret
	Set EpID=""
	For {
		Set EpID=$o(^DHCMRC("CPW",CPWID,"EP",EpID))
		Quit:(+EpID=0)
		Set EpRowID=CPWID_"||"_EpID
		Set objEp=##class(web.DHCCPW.MRC.PathWayEp).GetObjById(EpRowID)
		Continue:'$IsObject(objEp)
		Set cntEp=$i(cntEp)
		Set StepID=""
		For {
			Set StepID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID))
			Quit:(+StepID)=0
			Set StepRowID=CPWID_"||"_EpID_"||"_StepID
			Set objStep=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(StepRowID)
			Continue:'$IsObject(objStep)
			Set cntStep=$i(cntStep)
			Set ItemID=""
			For {
				Set ItemID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID,"ITEM",ItemID))
				Quit:(+ItemID=0)
				Set ItemRowID=CPWID_"||"_EpID_"||"_StepID_"||"_ItemID
				Set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(ItemRowID)
				Continue:'$IsObject(objItem)
				Set cntItem=$i(cntItem)
				Set (SubCategID,SubCategDesc,CategID)=""
				If $IsObject(objItem.CPWSISubCategory) {
					Set SubCategID=objItem.CPWSISubCategory.%Id()
					Set SubCategDesc=objItem.CPWSISubCategory.SISCDesc
					Set:$IsObject(objItem.CPWSISubCategory.SISCParRef) CategID=objItem.CPWSISubCategory.SISCParRef.%Id()
					If $IsObject(objItem.CPWSISubCategory.SISCParRef) {
						Set CategID=objItem.CPWSISubCategory.SISCParRef.%Id()
						Set CategCode=objItem.CPWSISubCategory.SISCParRef.SICCode
					}
				}
				Set:(CategCode="01") cntItem01=$i(cntItem01)
				Set:(CategCode="02") cntItem02=$i(cntItem02)
				Set:(CategCode="03") cntItem03=$i(cntItem03)
			}
		}
	}
	Set ret=cntEp_"^"_cntStep_"^"_cntItem_"^"_cntItem01_"^"_cntItem02_"^"_cntItem03
	Quit ret
cntEpStepItemErr
	Set ret="-1^-1^-1^-1^-1^-1"
	Quit ret
}

Storage Default
{
<Data name="ClinPathWaysSrvDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCCPW435.ClinPathWays5F2D</DataLocation>
<DefaultData>ClinPathWaysSrvDefaultData</DefaultData>
<IdLocation>^web.DHCCPW435.ClinPathWays5F2D</IdLocation>
<IndexLocation>^web.DHCCPW435.ClinPathWays5F2I</IndexLocation>
<StreamLocation>^web.DHCCPW435.ClinPathWays5F2S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
