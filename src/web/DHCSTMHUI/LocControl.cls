Import sqluser

/// Descript: 界面科室授权配置
/// Creater:	wxj
/// CreateDate:	20220217
Class web.DHCSTMHUI.LocControl Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	安全组
/// Creater:	wxj
/// CreateDate:	20220217
/// Table: ss_group
/// Input: 
/// Output:		
/// Return：安全组id,代码,名称
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.LocControl","GetGroup","{""GroupDescription"":""mat"",""gUserId"":""6423"",""gLocId"":""163"",""gGroupId"":""277"",""gHospId"":""2""}")
Query GetGroup(Params As %String) As websys.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetGroupExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s sc=PJObj.%FromJSON(Params)
	i sc'=0 d
	.s sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 $$$OK
	s desc=PJObj.%Get("GroupDescription")
	s StrSql="SELECT SSGRP_RowId AS RowId, SSGRP_Desc AS Description FROM SS_Group where 1=1"
	i desc'=""  d
	.s StrSql=StrSql_" and SSGRP_Desc like '%"_desc_"%'"
	s json = ##class(Code.JsonObj).%New()
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(StrSql)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	If err  q $$$OK
	While(result.Next())
	{
		s RowId = result.Data("RowId")
	    s Description = result.Data("Description")
		d OutPutGroup
	}
	Quit $$$OK
OutPutGroup
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	安全组下菜单
/// Creater:	wxj
/// CreateDate:	20220222
/// Table: websys.menu
/// Input: 
/// Output:		
/// Return：安全组id
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.LocControl","GetMenu","")
Query GetMenu(q) As websys.Query(ROWSPEC = "MenuCode,MenuDesc,LinkUrl") [ SqlProc ]
{
}

ClassMethod GetMenuExecute(ByRef qHandle As %Binary, q) As %Status
{
	n (qHandle,q)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s pMenuCode="DHCSTMHUI"
	s Input=q
	s:Input'="" Input="%"_$$ALPHAUP^SSUTIL4(Input)_"%"
	s StrSql="SELECT Name,Caption,LinkUrl FROM websys.menu WHERE LinkUrl IS NOT NULL And Name LIKE '"_pMenuCode_"%'"
	s:Input'="" StrSql=StrSql_" And( Name Like '"_Input_"' OR Caption Like '"_Input_"')"
	s json = ##class(Code.JsonObj).%New()
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(StrSql)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	If err  q $$$OK
	While(result.Next())
	{
		s MenuCode = result.Data("Name")
	    s MenuDesc = result.Data("Caption")
	    s LinkUrl = result.Data("LinkUrl")
		d OutPutMenu
	}
	Quit $$$OK
OutPutMenu
	s Data=$lb(MenuCode,MenuDesc,LinkUrl)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	保存/更新菜单
/// Creater:	wxj
/// CreateDate:	20210831
/// Table: CF_HRP_MAT.LocConfig
/// Input: 安全组id
/// Output:		
/// Return：0：成功，非0：保存失败
/// w ##class(web.DHCSTMHUI.LocControl).Save("277","[{""MenuCode"":""DHCSTMHUI.OutStat"",""MenuDesc"":""出库汇总"",""LinkUrl"":""dhcstmhui.outstatcondition.csp"",""Desc"":""关联科室"",""Components"":""PhaLoc"",""LocType"":""LinkLoc"",""Active"":""N""}]")
ClassMethod Save(GroupId As %String, Params As %String) As %Library.String
{
	n (GroupId,Params,%session)
	s ^tempxj(1)=$lb(GroupId,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s sc=PJObj.%FromJSON(Params)
	i sc'=0 d
	.s sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s MenuCode=Obj.%Get("MenuCode")
		q:MenuCode=""
		s MenuDesc=Obj.%Get("MenuDesc")
		s LinkUrl=Obj.%Get("LinkUrl")
		s Components=Obj.%Get("Components")
		s Active=Obj.%Get("Active")	
		s LocType=Obj.%Get("LocType")
		i (LocType="")  d RtnObj.Err(-3,"","科室类型不能为空","",0)
		s Tempid="" 
		s StrSql="SELECT %ID as Tempid FROM CF_HRP_MAT.LocConfig WHERE LC_Group_DR='"_GroupId_"' AND LC_MenuCode='"_MenuCode_"'"
		i Components'="" d
		.s StrSql=StrSql_" AND LC_Components='"_Components_"'"
		s result = ##class(%Library.ResultSet).%New()
		d result.RuntimeModeSet(0)
		d result.Prepare(StrSql)
		s psc=result.Execute()
		q:$$$ISERR(psc)
		While(result.Next())
		{
			s Tempid=result.Data("Tempid")
			continue:(RowId'="")&(+Tempid>0)&(RowId=+Tempid)				;非新增，数据修改
			d:+Tempid>0 RtnObj.Err(-2,"","存在重复记录","",0)
		}
		continue:RtnObj.success<0
		i RowId="" d
		.s Obj=##class(CF.HRP.MAT.LocConfig).%New()
		e  d
		.s Obj=##class(CF.HRP.MAT.LocConfig).%OpenId(RowId)
		d Obj.LCGroupDRSetObjectId(GroupId)
		s Obj.LCMenuCode=MenuCode
		s Obj.LCMenuDesc=MenuDesc
		s Obj.LCComponents=Components
		s Obj.LCLocType=LocType
		s Obj.LCActiveFlag=Active
		s Obj.LCLinkUrl=LinkUrl
		s Sc=Obj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-3,RowId,"保存失败:"_Sc)
		continue:RtnObj.success<0
		s:RowId="" RowId=Obj.%Id()
		
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:	删除
/// Creater:	wxj
/// CreateDate:	20210831
/// Table: CF_HRP_MAT.LocConfig
/// Input: rowid
/// Output:		
/// Return：0,成功,
/// w ##class(web.DHCSTMHUI.LocControl).Delete(^tmplh(555))
ClassMethod Delete(Params As %String) As RtnObj
{
	n (Params,%session)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	ts
 	s $ZT=..sssError()
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		q:RowId=""
		s Code=Obj.%Get("Code")
		s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("CF_HRP_MAT.LocConfig",RowId)
		&sql(Delete from CF_HRP_MAT.LocConfig where ID=:RowId)
		i SQLCODE'=0  d
		.s sc=RtnObj.Err(-2,RowId,$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
		e  d
		.s RtnObj=##class(Log).SaveLog("CF_HRP_MAT.LocConfig","CF.HRP.MAT.LocConfig","界面科室控制配置",RowId,"","D",JsonStr)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:	查询某安全组对应的界面科室控制配置数据
/// Creater:	wxj
/// CreateDate:	20210831
/// Table: CF_HRP_MAT.LocConfig
/// Input: 安全组id
/// Output:		
/// Return：Rowid^支配科室id^支配科室代码^支配科室描述
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.LocControl","QueryMenuInfo",97)
Query QueryMenuInfo(GroupId As %String) As websys.Query(ROWSPEC = "RowId,MenuCode,MenuDesc,Components,LocType,Active,LinkUrl") [ SqlProc ]
{
}

ClassMethod QueryMenuInfoExecute(ByRef qHandle As %Binary, GroupId As %String) As %Status
{
	n (qHandle,GroupId)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:GroupId="" $$$OK
	s MenuCode=""
	f  s MenuCode=$o(^CF.HRP.MAT.LocConfigI("GroupCode",GroupId,MenuCode)) q:MenuCode=""  d
	.s RowId=""
	.f  s RowId=$o(^CF.HRP.MAT.LocConfigI("GroupCode",GroupId,MenuCode,RowId)) q:RowId=""  d
	..s MenuInfo=^CF.HRP.MAT.LocConfigD(RowId)
	..s MenuDesc=$lg(MenuInfo,4)
	..s Components=$lg(MenuInfo,5)
	..s LocType=$lg(MenuInfo,6)
	..s Active=$lg(MenuInfo,7)
	..s LinkUrl=$lg(MenuInfo,8)
	..d OutPutMenuInfo
	
	Quit $$$OK
OutPutMenuInfo
	s Data=$lb(RowId,MenuCode,MenuDesc,Components,LocType,Active,LinkUrl)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creater:	wxj
/// CreateDate:	20220218
/// w ##class(web.DHCSTMHUI.LocControl).GetMenuLimit("277","57976","PhaLoc")
ClassMethod GetMenuLimit(GroupId As %String, MENUID As %String, Element As %String = "") As RtnObj
{
	n (GroupId,MENUID,Element,%session)
	q:GroupId="" ""
	q:MENUID="" ""
	S MenuCode="",MenuDesc=""
	&sql(SELECT Name, Caption into :MenuCode,:MenuDesc FROM websys.menu WHERE ID=:MENUID )
	q:MenuCode="" ""
	s RowId="",LocType=""
	f  s RowId=$o(^CF.HRP.MAT.LocConfigI("GroupCode",GroupId,MenuCode,RowId)) q:((RowId="")||(LocType'=""))  d
	.s Info=^CF.HRP.MAT.LocConfigD(RowId)
	.s ActiveFlag=$lg(Info,7)
	.q:ActiveFlag'="Y"
	.s Components=$lg(Info,5)
	.q:(Element'="")&&(Components'=Element)
	.s LocType=$lg(Info,6)
	q LocType
}

}
