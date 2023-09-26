/// 名称: DHCMed.INFService.RepItemSrv
/// 描述:  维护报告附加项的部分类
/// 编写者：ChenJB
/// 编写日期: 2010-06-25
Class DHCMed.INFService.RepItemSrv Extends (%RegisteredObject, DHCMed.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// Creator：     ChenJB
/// CreatDate：   2010-06-25
/// Description:  查询附加项的信息
/// Table：       DHCMed.INF.RepItem
/// Input：       Alias ： 别名
/// output:       符合条件的项            
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCMed.INFService.RepItemSrv","QryInfDiaByAlias","")
/// myid,Code,Description,DataType,IsActive,DicName,MultChoice,ResumeText
Query QryInfDiaByAlias(Alias As %String = "") As %Query(ROWSPEC = "Rowid:%String,Code:%String,Description:%String,DataType:%String,IsActive:%String,DicName:%String,MultChoice:%String,ResumeText:%String,DataTypeDesc:%String,DicNameDesc:%String")
{
}

ClassMethod QryInfDiaByAliasExecute(ByRef qHandle As %Binary, Alias As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	//^DHCMed.INF.InfDiagnoseD
 	//^DHCMed.INF.InfDiagnoseI("Alias",{Alias},{RowID})
 	//1:Rowid 2: ICD 3:DiseaseName 4:Type 5:Active 6:Alias 7:ResumeText
 	s Alias=$$ALPHAUP^SSUTIL4(Alias)
 	if (Alias="")
 	{
	 	s myid=$o(^DHCMed.INF.RepItemD(""))
 	    while (myid'="")
 	    {
	     s myInfDia=##class(DHCMed.INF.RepItem).%OpenId(myid)
	     if ($IsObject(myInfDia))
	     {        
 	        q:'$IsObject(myInfDia)
 	        s Code=myInfDia.Code
 	        s Description=myInfDia.Description
 	        s DataType=myInfDia.DataType
 	        s IsActive=myInfDia.IsActive
 	        s DicName=myInfDia.DicName
 	        s MultChoice=myInfDia.MultChoice
 	        s ResumeText=myInfDia.ResumeText
 	        s DataTypeDesc=""
 	        s DicNameDesc=""
 	        i DataType'="" d
 	        .s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(DataType,"InfectionRepDataType")
 	        .s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
 	        .i $IsObject(objDic) s DataTypeDesc=objDic.Description
 	        i DicName'="" d
 	        .s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(DicName,"SYS")
 	        .s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
 	        .i $IsObject(objDic) s DicNameDesc=objDic.Description
 	        s Data=$lb(myid,Code,Description,DataType,IsActive,DicName,MultChoice,ResumeText,DataTypeDesc,DicNameDesc)
 	        s ^CacheTemp(repid,ind)=Data
 	        s ind=ind+1
		  } 	
	      s myid=$o(^DHCMed.INF.RepItemD(myid))
	 	}
	}
 	else
 	{
 	s idxAlias=" "_Alias
 	i $d(^DHCMed.INF.RepItemI("Alias",idxAlias)) d
 	.s tmpRowid=""
 	.f  s tmpRowid=$o(^DHCMed.INF.RepItemI("Alias",idxAlias,tmpRowid)) q:(+tmpRowid=0)  d
 	..s myInfDia=##class(DHCMed.INF.RepItem).%OpenId(tmpRowid)
 	..q:'$IsObject(myInfDia)
    ..s Code=myInfDia.Code
 	..s Description=myInfDia.Description
 	..s DataType=myInfDia.DataType
 	..s IsActive=myInfDia.IsActive
 	..s DicName=myInfDia.DicName
 	..s MultChoice=myInfDia.MultChoice
 	..s ResumeText=myInfDia.ResumeText
 	..s Data=$lb(myid,Code,Description,DataType,IsActive,DicName,MultChoice,ResumeText)
 	..s ^CacheTemp(repid,ind)=Data
 	..s ind=ind+1
 	f  s idxAlias=$o(^DHCMed.INF.RepItemI("Alias",idxAlias)) q:idxAlias'[Alias  d
 	.s tmpRowid=""
 	.f  s tmpRowid=$o(^DHCMed.INF.RepItemI("Alias",idxAlias,tmpRowid)) q:(+tmpRowid=0)  d
 	..s myInfDia=##class(DHCMed.INF.RepItem).%OpenId(tmpRowid)
 	..q:'$IsObject(myInfDia)
    ..s Code=myInfDia.Code
 	..s Description=myInfDia.Description
 	..s DataType=myInfDia.DataType
 	..s IsActive=myInfDia.IsActive
 	..s DicName=myInfDia.DicName
 	..s MultChoice=myInfDia.MultChoice
 	..s ResumeText=myInfDia.ResumeText
 	..s Data=$lb(myid,Code,Description,DataType,IsActive,DicName,MultChoice,ResumeText)
 	..s ^CacheTemp(repid,ind)=Data
 	..s ind=ind+1
 	}
 	
	Quit $$$OK
}

ClassMethod QryInfDiaByAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfDiaByAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfDiaByAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfDiaByAliasExecute ]
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

/// Creator：     陈剑波
/// CreatDate：   2010-05-28
/// Description:  查询所有的感染相关项目
/// Table：       DHCMed.SS.Dictionary
/// Input：       
/// output:       某一个字典项      
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCMed.INFService.RepItemSrv","QryTypeConfig","1")
Query QryTypeConfig(TypeCode As %String) As %Query(ROWSPEC = "myid:%String,TypeCode:%String,TypeDesc:%String,AppendID:%String,Code:%String,Description:%String,DataType:%String,DicName:%String,ItmIsActive:%String,ItmMultChoice:%String,IsRequired:%String,DefaultValue:%String,Positions:%String,IsActive:%String,ToolTip:%String,ResumeText:%String")
{
}

ClassMethod QryTypeConfigExecute(ByRef qHandle As %Binary, TypeCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1	
    q:TypeCode="" $$$OK
    s TypeCodeIdx=" "_$ZCVT(TypeCode,"U")
    s tmpPos=""
    f  s tmpPos=$o(^DHCMed.INF.TypeAppenI("TypesDrPos",TypeCodeIdx,tmpPos)) q:tmpPos=""  d
    .s dicID=""
 	.f  s dicID=$o(^DHCMed.INF.TypeAppenI("TypesDrPos",TypeCodeIdx,tmpPos,dicID)) q:+dicID=0  d
 	..s objDic=##class(DHCMed.INF.TypeAppen).%OpenId(dicID)
	..q:'$IsObject(objDic)
	..s TypeDesc=""
	..s dicIDN=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(TypeCode,"InfectionType")
	..s objDicN=##class(DHCMed.SS.Dictionary).GetObjById(dicIDN)
	..i $IsObject(objDicN)  d
	...s TypeDesc=objDicN.Description
	...k objDicN
	..s AppendID=objDic.ItemTypeDr
	..s objCls=##class(DHCMed.INF.RepItem).%OpenId(AppendID)
	..q:'$IsObject(objCls)
	..s Code=objCls.Code
	..s Description=objCls.Description
	..s DataType=objCls.DataType
	..s DicName=objCls.DicName
	..s ItmIsActive=objCls.IsActive
	..s ItmMultChoice=objCls.MultChoice
	..s IsRequired=objDic.IsRequired
	..s DefaultValue=objDic.DefaultValue
	..s Positions=objDic.Positions
	..s IsActive=objDic.IsActive
	..s ToolTip=objDic.ToolTip
	..s ResumeText=objDic.ResumeText
	..s Data=$lb(dicID,TypeCode,TypeDesc,AppendID,Code,Description,DataType,DicName,ItmIsActive,ItmMultChoice,IsRequired,DefaultValue,Positions,IsActive,ToolTip,ResumeText)
    ..s ^CacheTemp(repid,ind)=Data
    ..s ind=ind+1
	Quit $$$OK
}

ClassMethod QryTypeConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTypeConfigExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryTypeConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTypeConfigExecute ]
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

/// Creator：     陈剑波
/// CreatDate：   2010-05-28
/// Description:  查询所有的感染相关模块
/// Table：       DHCMed.SS.Dictionary
/// Input：       
/// output:       某一个字典项      
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCMed.INFService.RepItemSrv","QryTypeItems",51104,"1")
Query QryTypeItems(Paadm As %String = "", TypeCode As %String = "", InfRepDr As %String = "") As %Query(ROWSPEC = "name:%String,value:%String,rowid:%String,code:%String,csID:%String,DataType:%String")
{
}

ClassMethod QryTypeItemsExecute(ByRef qHandle As %Binary, Paadm As %String = "", TypeCode As %String = "", InfRepDr As %String = "") As %Status
{
	Set repidN=$I(^CacheTemp)
	Set qHandle=$lb(0,repidN,0)
 	s indN=1
 	q:+Paadm=0 $$$OK
 	q:TypeCode="" $$$OK
 	s TypeCodeIdx=" "_$ZCVT(TypeCode,"U")
 	//s repDr=##class(DHCMed.INFService.InfReportSrv).GetReportID(+Paadm,TypeCode)
 	s repDr=InfRepDr
 	i repDr="" d
 	.s rSet=##class(%ResultSet).%New("DHCMed.INFService.RepItemSrv:QryTypeConfig")
 	.s rc=rSet.Execute(TypeCode)
 	.f  q:'rSet.Next()  d
 	..s itemID=rSet.Data("AppendID")
 	..s Code=rSet.Data("Code")
 	..s Description=rSet.Data("Description")
 	..s DataType=rSet.Data("DataType")
 	..s DicName=rSet.Data("DicName")
 	..s ItmMultChoice=rSet.Data("ItmMultChoice")
 	..s IsRequired=rSet.Data("IsRequired")
 	..s DefaultValue=rSet.Data("DefaultValue")  
 	..s ToolTip=rSet.Data("ToolTip")
 	..s ResumeText=rSet.Data("ResumeText")
 	..i DataType="D" d
 	...s Data=$lb()
 	...s:DefaultValue'="" Data=$lb(Description,"new Date(Date.parse('"_DefaultValue_"'))",itemID,Code,"",DataType)
 	...s:DefaultValue="" Data=$lb(Description,"new Date()",itemID,Code,"",DataType)
 	...s ^CacheTemp(repidN,indN)=Data
    ...s indN=indN+1
 	..e  i DataType="B" d
 	...//b //B/
 	...s Data=$lb(Description,"true",itemID,Code,"",DataType)
 	...s ^CacheTemp(repidN,indN)=Data
    ...s indN=indN+1
 	..e  d
 	...//b // O
 	...s Data=$lb(Description,"'"_DefaultValue_"'",itemID,Code,"",DataType)
    ...s ^CacheTemp(repidN,indN)=Data
    ...s indN=indN+1
    e  d
    .s csID=""
    .f  s csID=$o(^DHCMed.INF.RepAppenI("InfRepDr",repDr,csID)) q:csID=""  d
    ..s objRepApp=##class(DHCMed.INF.RepAppen).GetObjById(csID)
    ..q:'$IsObject(objRepApp)
    ..s objItm=##class(DHCMed.INF.RepItem).GetObjById(objRepApp.ItemsDr)
    ..q:'$IsObject(objItm)
    ..s itemID=objRepApp.ItemsDr
    ..s Code=objItm.Code
 	..s Description=objItm.Description
 	..s DataType=objItm.DataType
 	..s valuess=objRepApp.ItemsValue
    ..i DataType="D" d
 	...s Data=$lb()
 	...s:valuess'="" Data=$lb(Description,"new Date(Date.parse('"_valuess_"'))",itemID,Code,csID,DataType)
 	...s:valuess="" Data=$lb(Description,"new Date()",itemID,Code,"",DataType)
 	...s ^CacheTemp(repidN,indN)=Data
    ...s indN=indN+1
 	..e  i DataType="B" d
 	...//b //B/
 	...s Data=$lb(Description,valuess,itemID,Code,csID,DataType)
 	...s ^CacheTemp(repidN,indN)=Data
    ...s indN=indN+1
 	..e  d
 	...//b // O
 	...s Data=$lb(Description,"'"_valuess_"'",itemID,Code,csID,DataType)
    ...s ^CacheTemp(repidN,indN)=Data
    ...s indN=indN+1
	Quit $$$OK
}

ClassMethod QryTypeItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTypeItemsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryTypeItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTypeItemsExecute ]
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

/// Creator：     陈剑波
/// CreatDate：   2010-07-22
/// Description:  查询所有的感染相关项目
/// Table：       DHCMed.SS.Dictionary
/// Input：       报告类型 , 时间 , 科室 
/// output:       某一个字典项      
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCMed.INFService.RepItemSrv","QryTypeLocInfo","1")
Query QryTypeLocInfo(TypeCode As %String, SurgDate As %String = "", Ctloc As %String = "") As %Query(ROWSPEC = "ID:%String,TypeCode:%String,TypeDesc:%String,SurgDt:%String,Ctloc:%String,CtlocDesc:%String,Count:%String")
{
}

ClassMethod QryTypeLocInfoExecute(ByRef qHandle As %Binary, TypeCode As %String, SurgDate As %String = "", Ctloc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1	
    q:TypeCode="" $$$OK
    s TypeCodeIdx=" "_$ZCVT(TypeCode,"U")
    s:SurgDate["-" SurgDate=$zdh(SurgDate,3)
	s:SurgDate["/" SurgDate=$zdh(SurgDate,4)
	//^DHCMed.INF.TypeLocConfigI("TypeMainIdx"
	i SurgDate="" d
    .f  s SurgDate=$o(^DHCMed.INF.TypeLocConfigI("TypeMainIdx",TypeCodeIdx,SurgDate)) q:SurgDate=""  d
    ..s ID=""
 	..f  s ID=$o(^DHCMed.INF.TypeLocConfigI("TypeMainIdx",TypeCodeIdx,SurgDate,ID)) q:+ID=0  d
 	...s objDic=##class(DHCMed.INF.TypeLocConfig).%OpenId(ID)
	...q:'$IsObject(objDic)
	...s tmpCtloc=objDic.CtLoc
	...s tmpCtlocDesc=""
	...q:(Ctloc'="")&(Ctloc'=tmpCtloc)
	...s TypeDesc=""
	...s dicIDN=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(TypeCode,"InfectionType")
	...s objDicN=##class(DHCMed.SS.Dictionary).GetObjById(dicIDN)
	...i $IsObject(objDicN)  d
	....s TypeDesc=objDicN.Description
	....k objDicN
	...s objTmp=##class(DHCMed.Base.Ctloc).GetObjById(tmpCtloc)
	...s:$IsObject(objTmp) tmpCtlocDesc=objTmp.Descs
	...s tmpSurgDt=objDic.SurveryDate
	...s tmpSurgDt=$zd(+tmpSurgDt,3)
	...s count=objDic.SurPatiCount
	...s Data=$lb(ID,TypeCode,TypeDesc,tmpSurgDt,tmpCtloc,tmpCtlocDesc,count)
    ...s ^CacheTemp(repid,ind)=Data
    ...s ind=ind+1
    e  d
    .s ID=""
    .f  s ID=$o(^DHCMed.INF.TypeLocConfigI("TypeMainIdx",TypeCodeIdx,SurgDate,ID)) q:+ID=0  d
	..s objDic=##class(DHCMed.INF.TypeLocConfig).%OpenId(ID)
	..q:'$IsObject(objDic)
	..s tmpCtloc=objDic.CtLoc
	..s tmpCtlocDesc=""
	..q:(Ctloc'="")&(Ctloc'=tmpCtloc)
	..s TypeDesc=""
	..s dicIDN=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(TypeCode,"InfectionType")
	..s objDicN=##class(DHCMed.SS.Dictionary).GetObjById(dicIDN)
	..i $IsObject(objDicN)  d
	...s TypeDesc=objDicN.Description
	...k objDicN
	..s objTmp=##class(DHCMed.Base.Ctloc).GetObjById(tmpCtloc)
	..s:$IsObject(objTmp) tmpCtlocDesc=objTmp.Descs
	..s tmpSurgDt=objDic.SurveryDate
	..s tmpSurgDt=$zd(+tmpSurgDt,3)
	..s count=objDic.SurPatiCount
	..s Data=$lb(ID,TypeCode,TypeDesc,tmpSurgDt,tmpCtloc,tmpCtlocDesc,count)
    ..s ^CacheTemp(repid,ind)=Data
    ..s ind=ind+1
	Quit $$$OK
}

ClassMethod QryTypeLocInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTypeLocInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryTypeLocInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTypeLocInfoExecute ]
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

/// 在前台 根据出参 构建Ext 元素
/// w ##class(DHCMed.INFService.RepItemSrv).GetAppendixString(4,51104,"")
ClassMethod GetAppendixString(TypeCode As %String, EpisodeID As %String, RepID As %String) As %String
{
	n (TypeCode,EpisodeID,RepID)
	s ret=""
	q:+EpisodeID=0 ret
 	q:TypeCode="" ret
 	s TypeCodeIdx=" "_$ZCVT(TypeCode,"U")
 	//s repDr=##class(DHCMed.INFService.InfReportSrv).GetReportID(+Paadm,TypeCode)
 	i RepID="" d
 	.s apID=""
 	.s rSet=##class(%ResultSet).%New("DHCMed.INFService.RepItemSrv:QryTypeConfig")
 	.s rc=rSet.Execute(TypeCode)
 	.f  q:'rSet.Next()  d
 	..s itemID=rSet.Data("AppendID")
 	..s Code=rSet.Data("Code")
 	..s Description=rSet.Data("Description")
 	..s DataType=rSet.Data("DataType")
 	..s DicName=rSet.Data("DicName")
 	..s ItmMultChoice=rSet.Data("ItmMultChoice")
 	..s IsRequired=rSet.Data("IsRequired")
 	..s DefaultValue=rSet.Data("DefaultValue")  
 	..s ToolTip=rSet.Data("ToolTip")
 	..s ResumeText=rSet.Data("ResumeText")
 	..s:ret'="" ret=ret_$c(1)_apID_","_Description_","_DefaultValue_","_itemID_","_DataType_","_DicName
 	..s:ret="" ret=apID_","_Description_","_DefaultValue_","_itemID_","_DataType_","_DicName 	
	e  d
	.s apID=""
    .f  s apID=$o(^DHCMed.INF.RepAppenI("InfRepDr",RepID,apID)) q:apID=""  d
    ..s objRepApp=##class(DHCMed.INF.RepAppen).GetObjById(apID)
    ..q:'$IsObject(objRepApp)
    ..s objItm=##class(DHCMed.INF.RepItem).GetObjById(objRepApp.ItemsDr)
    ..q:'$IsObject(objItm)
    ..s itemID=objRepApp.ItemsDr
    ..s Code=objItm.Code
 	..s Description=objItm.Description
 	..s DataType=objItm.DataType
 	..s DicName=objItm.DicName
 	..s valuess=objRepApp.ItemsValue
 	..s:ret'="" ret=ret_$c(1)_apID_","_Description_","_valuess_","_itemID_","_DataType_","_DicName
 	..s:ret="" ret=apID_","_Description_","_valuess_","_itemID_","_DataType_","_DicName 	
	q ret
}

}
