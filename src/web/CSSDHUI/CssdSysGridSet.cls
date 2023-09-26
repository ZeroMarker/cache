Import sqluser

/// Descript: Grid列设置
/// Creater: ban
/// CreateDate: 2019-11-12
Class web.CSSDHUI.CssdSysGridSet Extends (%RegisteredObject, CSSDType) [ Not ProcedureBlock ]
{

/// Descript: 保存grid 列设置
/// Creater:
/// CreateDate: 2019-11-12
/// Table:CSSD_SysGridSet
Query GetGridSet(Main As %String, Detail As %String) As Query(ROWSPEC = "RowId:%Integer,Name,Header,Width,Align,Hidden,EnterSort,Necessary,Frozen") [ SqlProc ]
{
}

ClassMethod GetGridSetExecute(ByRef qHandle As %Binary, Main As %String, Detail As %String) As %Status
{
	n (qHandle,Main,Detail)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJobj=##class(web.CSSDHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Main)
	s AppName=PJobj.%Get("AppName")
	s GridId=PJobj.%Get("GridId")
	s SaveMod=PJobj.%Get("SaveMod")
	s SaveValue=PJobj.%Get("SaveValue")
	s CspName=PJobj.%Get("CspName")
	s GroupId=PJobj.%Get("gGroupId")
	s UserId=PJobj.%Get("gUserId")
	s HospId=PJobj.%Get("gHospId")
	s SaveModInfo=..GetSaveMod(AppName,GridId,CspName,GroupId,UserId,HospId)
	s SaveMod=$p(SaveModInfo,"^",1)
	s SaveValue=$p(SaveModInfo,"^",2)
	s sql="select GS_RowId RowId,"
	s sql=sql_"GS_Name Name,"
	s sql=sql_"GS_Header Header,"
	s sql=sql_"GS_Width Width,"
	s sql=sql_"GS_Alignment Align,"
	s sql=sql_"GS_Hidden Hidden,"
	s sql=sql_"GS_Necessary Necessary,"
	s sql=sql_"GS_Frozen Frozen,"
	s sql=sql_"GS_EnterSort EnterSort"
	s sql=sql_" FROM CSSD_SysGridSet"
	s sql=sql_" where GS_CspName="""_CspName_""" AND GS_GridID="""_GridId_""" and GS_SaveFor="""_SaveMod_"""" 
	s sql=sql_" and GS_Reference="_SaveValue_" " 
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(sql)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s RowId=xrs.Data("RowId")
		s Name=xrs.Data("Name")
		s Header=xrs.Data("Header")
		s Width=xrs.Data("Width")
		s Align=xrs.Data("Align")
		s Hidden=xrs.Data("Hidden")
		s EnterSort=xrs.Data("EnterSort")
		s Necessary=xrs.Data("Necessary")
		s Frozen=xrs.Data("Frozen")
		d OutPutRow1
	}
	Quit $$$OK

OutPutRow1
	s Data=$lb(RowId,Name,Header,Width,Align,Hidden,EnterSort,Necessary,Frozen)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript: 保存grid 列设置
/// Creater:
/// CreateDate: 2019-11-12
/// Table:CSSD_SysGridSet
/// Input:应用程序名称;grid Id,保存模式(SSUser,SSGroup,SITE), 保存模式值(用户id,安全组id,站点名称;)
/// rowid^顺序号^列id^列标题^宽度^对齐方式^是否排序^是否隐藏^名称^显示格式^数据类型,
///  ##class(web.CSSDHUI.CssdSysGridSet).Save(^tmp1,^tmp2)
ClassMethod Save(Main As %String, Detail As %String) As %String
{
	n (Main,Detail)
	s RtnObj=##class(RtnObj).%New()
	s PJobj=##class(web.CSSDHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Main)
	s AppName=PJobj.%Get("AppName")
	s GridId=PJobj.%Get("GridId")
	s SaveModule=PJobj.%Get("SaveMod")
	s SaveValue=PJobj.%Get("SaveValue")
	s CspName=PJobj.%Get("CspName")
	s GroupId=PJobj.%Get("gGroupId")
	s UserId=PJobj.%Get("gUserId")
	s HospId=PJobj.%Get("gHospId")
	i SaveModule="SSUser" s SaveValue=UserId
	i SaveModule="SSGroup" s SaveValue=GroupId
	i SaveModule="SITE" s SaveValue=HospId
	i GridId="" d RtnObj.Err(-1,"","不能为空!") q RtnObj.Json()
	i CspName="" d RtnObj.Err(-1,"","不能为空!") q RtnObj.Json()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Detail)
	s Order=0
	&sql(select GS_RowId from CSSD_SysGridSet where GS_CspName=:CspName AND GS_GridID=:GridId and GS_SaveFor=:SaveModule 
		and GS_Reference=:SaveValue)
	s InSertFlag="N"
	i SQLCODE'=0 s InSertFlag="Y"
	while(RtnObj.success=0){
		s Order=Order+1
		s Obj=PJObj.%Pop()
		q:Obj=""
		s Rowid=Obj.%Get("RowId")
		s Header=Obj.%Get("Header")
		s Width=Obj.%Get("Width")
		s Align=Obj.%Get("Align")
		s Sort=Obj.%Get("Sort")
		s Hide=Obj.%Get("Hidden")
		s Name=Obj.%Get("Name")
		s Format=Obj.%Get("Format")
		s DataType=Obj.%Get("DataType")
		s EnterSort=Obj.%Get("EnterSort")
		s IFCopy=Obj.%Get("IFCopy")
		s IFExport=Obj.%Get("IFExport")
		s Necessary=Obj.%Get("Necessary")
		s Frozen=Obj.%Get("Frozen")
		i InSertFlag="Y" d
		.&sql(Insert into CSSD_SysGridSet(GS_GridID,GS_SaveFor,GS_Name,GS_Header,GS_Width,GS_Alignment,GS_Format,GS_Hidden,GS_Necessary,
			GS_Order,GS_DataType,GS_Reference,GS_CspName,GS_Sortable,GS_EnterSort,GS_IFCopy,GS_IFExport,GS_Frozen)
			values(:GridId,:SaveModule,:Name,:Header,:Width,:Align,:Format,:Hide,
			:Necessary,:Order,:DataType,:SaveValue,:CspName,:Sort,:EnterSort,:IFCopy,:IFExport,:Frozen))
		.i SQLCODE'=0 d
		..d RtnObj.Err(-1,"","插入失败!")
		e  d
		.&sql(Update CSSD_SysGridSet set GS_Header=:Header,GS_Width=:Width,
		GS_Alignment=:Align,GS_Format=:Format,GS_Hidden=:Hide,
		GS_DataType=:DataType,GS_Sortable=:Sort,GS_EnterSort=:EnterSort,GS_Necessary=:Necessary,
		GS_IFCopy=:IFCopy,GS_IFExport=:IFExport,GS_Order=:Order,GS_Frozen=:Frozen where GS_Rowid=:Rowid)
		.i SQLCODE'=0 d
		..d RtnObj.Err(-1,"","更新失败!")
		continue:RtnObj.success'=0
	}
	q:RtnObj.success'=0 RtnObj.Json()
	q RtnObj.Json()
}

/// Descript:	修改grid 列设置
/// Creater:
/// CreateDate:	2019-11-12
/// Table:CSSD_SysGridSet
/// Input:应用程序名称;grid Id,保存模式(SSUser,SSGroup,SITE), 保存模式值(用户id,安全组id,站点名称;)
/// rowid^顺序号^列id^列标题^宽度^对齐方式^是否排序^是否隐藏^名称^显示格式^数据类型,
/// Return：成功：0;其它：失败
ClassMethod Update(AppName As %String, GridId As %String, SaveModule As %String, SaveValue As %String, CspName As %String, Detail As %String) As RtnObj
{
	n (AppName,GridId,SaveModule,SaveValue,CspName,Detail)
	s RtnObj=##class(RtnObj).%New()
	i AppName="" d RtnObj.Err(-1,"","模块不能为空!") q RtnObj
	i GridId="" d RtnObj.Err(-1,"","表格ID不能为空!") q RtnObj
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Detail)
	s No="N",Yes="Y"
	&sql(update CSSD_SysGridSet set GS_SysFlag=:No where GS_CspName=:CspName and GS_SaveFor=:SaveMod 
	and GS_Reference=:SaveValue AND GS_GridID=:GridId)
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s Header=Obj.%Get("field")
		s Width=Obj.%Get("width")
		s Align=Obj.%Get("align")
		s Sort=Obj.%Get("sort")
		s Hide=Obj.%Get("hidden")
		i Hide=1 d 
		.s Hide="Y"
		e  d
		.s Hide="N"
		s Name=Obj.%Get("title")
		s Format=Obj.%Get("Forat")
		s DataType=Obj.%Get("DataType")
		s EnterSort=Obj.%Get("EnterSort")
		s IFCopy=Obj.%Get("IFCopy")
		s IFExport=Obj.%Get("IFExport")
		s Necessary=Obj.%Get("necessary")
		i Necessary=1 d 
		.s Necessary="Y"
		e  d
		.s Necessary="N"
		s Frozen=Obj.%Get("frozen")
		i Frozen=1 d 
		.s Frozen="Y"
		e  d
		.s Frozen="N"
		s Rowid=""
		&sql(select GS_RowId into :Rowid from CSSD_SysGridSet where GS_CspName=:CspName AND GS_GridID=:GridId and GS_SaveFor=:SaveModule 
		and GS_Reference=:SaveValue and GS_Header=:Header)
		i SQLCODE=0 d
		.&sql(Update CSSD_SysGridSet set GS_SysFlag=:Yes where GS_Rowid=:Rowid)
		.i SQLCODE'=0 d
		..d RtnObj.Err(-1,"","更新失败!")
		e  d
		.s SeqNo=0
		.&sql(select max(GS_Order) into :SeqNo from CSSD_SysGridSet where GS_CspName=:CspName and GS_SaveFor=:SaveModule
		and GS_Reference=:SaveValue AND GS_GridID=:GridId)
		.s SeqNo=1+SeqNo
		.&sql(Insert into CSSD_SysGridSet(GS_GridID,GS_SaveFor,GS_Key,GS_Name,
		GS_Header,GS_Width,GS_Alignment,GS_Format,GS_Hidden,GS_Necessary,
		GS_Order,GS_DataType,GS_Reference,GS_CspName,GS_Sortable,GS_EnterSort,GS_IFCopy,GS_IFExport,GS_SysFlag,GS_Frozen)
		values(:GridId,:SaveModule,:ColKey,:Name,:Header,:Width,:Align,:Format,:Hide,
		:Necessary,:SeqNo,:DataType,:SaveValue,:CspName,:Sort,:EnterSort,:IFCopy,:IFExport,:Yes,:Frozen))
		.i SQLCODE'=0 d
		..d RtnObj.Err(-1,"","插入失败!")
		continue:RtnObj.success'=0
	}
	q:RtnObj.success'=0 RtnObj
	&sql(delete from CSSD_SysGridSet where GS_CspName=:CspName AND GS_GridID=:GridId and GS_SaveFor=:SaveModule
	and GS_Reference=:SaveValue and GS_SysFlag=:No)
	q RtnObj
}

/// Descript:删除grid 列设置
/// Creater:	ban
/// CreateDate:	2019-11-23
/// Table:	CSSD_SysGridSet
/// Input:rowid,
/// 顺序号^列id^列标题^宽度^对齐方式^是否排序^是否隐藏^名称^显示格式^数据类型
/// 
/// Output:
/// Return：成功：0;
ClassMethod Delete(Main) As %Library.String
{
	n (Main)
	s RtnObj=##class(RtnObj).%New()
	s PJobj=##class(web.CSSDHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Main)
	s AppName=PJobj.%Get("AppName")
	s GridId=PJobj.%Get("GridId")
	s SaveMod=PJobj.%Get("SaveMod")
	s SaveValue=PJobj.%Get("SaveValue")
	s CspName=PJobj.%Get("CspName")
	s GroupId=PJobj.%Get("gGroupId")
	s UserId=PJobj.%Get("gUserId")
	s HospId=PJobj.%Get("gHospId")
	i SaveMod="SSUser" s SaveValue=UserId
	i SaveMod="SSGroup" s SaveValue=GroupId
	i SaveMod="SITE" s SaveValue=HospId
	i GridId="" d RtnObj.Err(-1,"","表格ID不能为空!") q RtnObj.Json()
	i SaveMod="" d RtnObj.Err(-1,"","保存模式不能为空!") q RtnObj.Json()
	i SaveValue="" d RtnObj.Err(-1,"","保存模式值不能为空!") q RtnObj.Json()
	i CspName="" d RtnObj.Err(-1,"","CSP不能为空!") q RtnObj.Json()
	&sql(Delete from CSSD_SysGridSet where GS_GridID=:GridId and GS_SaveFor=:SaveMod 
		and GS_Reference=:SaveValue and GS_CspName=:CspName )
	i SQLCODE'=0 d
	.d RtnObj.Err(-1,"","删除失败!")
	q RtnObj.Json()
}

/// Descript:处理 列设置数据
/// Creater:ban
/// CreateDate: 2019-11-12
/// Table:CSSD_SysGridSet
/// Input:Main (应用程序名称,GridId,保存模式,模式值)
/// Detail 列设置数据
/// Return：列设置信息
/// w ##class(web.CSSDHUI.CssdSysGridSet).Query("{""AppName"":""CSSDPACKAGE"",""CspName"":""cssdhui.packageinfo.packagemaintain.csp"",""GridId"":""#PackageList"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2""}","[{""title"":""器械总数"",""field"":""ItmQty"",""align"":""right"",""width"":80},{""title"":""备注"",""field"":""Remark"",""align"":""left"",""width"":100,""sortable"":true},{""title"":""是否外来器械"",""field"":""IsExt"",""width"":100,""align"":""center"",""sortable"":true},{""title"":""是否可用"",""field"":""NotUseFlag"",""width"":100,""align"":""center"",""sortable"":true},{""title"":""是否启用生物监测"",""field"":""NotBioFlag"",""width"":100,""align"":""center"",""sortable"":true},{""title"":""厂商"",""field"":""FirmDesc"",""align"":""left"",""width"":100,""sortable"":true},{""title"":""科室"",""field"":""LocDesc"",""align"":""left"",""width"":100,""sortable"":true},{""title"":""最大使用次数"",""field"":""WorkTimes"",""align"":""right"",""width"":100,""sortable"":true},{""title"":""单位"",""field"":""UomDesc"",""align"":""left"",""width"":100,""sortable"":true},{""title"":""灭菌方式"",""field"":""SterTypeDesc"",""width"":100,""align"":""left"",""sortable"":true},{""title"":""有效期"",""field"":""Length"",""align"":""right"",""width"":100,""sortable"":true},{""title"":""单价"",""field"":""Price"",""align"":""right"",""width"":100,""sortable"":true},{""title"":""包装材料"",""field"":""MaterialDesc"",""align"":""left"",""width"":100,""sortable"":true},{""title"":""包装材料"",""field"":""MaterialId"",""align"":""left"",""width"":100,""sortable"":true,""hidden"":true},{""title"":""消毒包分类"",""field"":""PkgClassDesc"",""align"":""left"",""width"":100,""sortable"":true},{""title"":""包属性"",""field"":""AttributeDesc"",""align"":""left"",""width"":100,""sortable"":true},{""title"":""包属性"",""field"":""AttributeId"",""align"":""left"",""width"":100,""sortable"":true,""hidden"":true},{""title"":""规格"",""field"":""SpecDesc"",""align"":""left"",""width"":80,""sortable"":true},{""title"":""别名"",""field"":""PkgAlias"",""align"":""left"",""width"":100,""sortable"":true},{""title"":""消毒包"",""field"":""PkgDesc"",""align"":""left"",""width"":200,""sortable"":true},{""title"":""代码"",""field"":""PkgCode"",""align"":""left"",""width"":50,""sortable"":true},{""title"":""RowId"",""field"":""RowId"",""align"":""left"",""width"":100,""hidden"":true},{""field"":""operate"",""title"":""操作"",""frozen"":true,""align"":""center"",""width"":100,""allowExport"":false}]")
ClassMethod Query(Main As %String, Detail As %String) As %Library.String
{
	n (Main,Detail)
	s Rtn="[]"
	s RtnObj=##class(RtnObj).%New()
	s PJobj=##class(web.CSSDHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Main)
	s AppName=PJobj.%Get("AppName")
	s GridId=PJobj.%Get("GridId")
	s SaveMod=PJobj.%Get("SaveMod")
	s SaveValue=PJobj.%Get("SaveValue")
	s CspName=PJobj.%Get("CspName")
	s GroupId=PJobj.%Get("gGroupId")
	s UserId=PJobj.%Get("gUserId")
	s HospId=PJobj.%Get("gHospId")
	q:GridId="" Rtn	;不能为空
	q:CspName="" Rtn	;不能为空
	//1 检查是否存在列设置数据
	&sql(SELECT GS_RowId FROM CSSD_SysGridSet WHERE GS_CspName=:CspName AND GS_GridID=:GridId )
	;i SQLCODE'=0 q Rtn
	//2 SaveMod为空取最高权限
	i SaveMod="" d
	.s SaveModInfo=..GetSaveMod(AppName,GridId,CspName,GroupId,UserId,HospId)
	.s SaveMod=$p(SaveModInfo,"^",1)
	.s SaveValue=$p(SaveModInfo,"^",2)
	///3 保存
	q:SaveMod="" Rtn	;院区、安全组、用户不能为空
	q:SaveValue="" Rtn	;院区Id、安全组Id、用户Id不能为空
	s RtnObj=..Update(AppName,GridId,SaveMod,SaveValue,CspName,Detail)
	q:RtnObj.success'=0 Rtn
	s pid=..NewPid()
	s json = ##class(web.CSSDHUI.Common.JsonObj).%New()
	s i=0
	s Chl=0
	f  s Chl=$o(^User.CSSDSysGridSetI("IndexGrid",GridId,SaveMod,SaveValue,CspName,Chl)) q:Chl=""  d
	.s Rowid=Chl
	.s ColKey=$lg(^User.CSSDSysGridSetD(Chl),4)
	.s Name=$lg(^User.CSSDSysGridSetD(Chl),5)
	.s Header=$lg(^User.CSSDSysGridSetD(Chl),6)
	.s Width=$lg(^User.CSSDSysGridSetD(Chl),7)
	.s Align=$lg(^User.CSSDSysGridSetD(Chl),8)
	.s Format=$lg(^User.CSSDSysGridSetD(Chl),9)
	.s DataType=$lg(^User.CSSDSysGridSetD(Chl),12)
	.s Hidden=$lg(^User.CSSDSysGridSetD(Chl),13)
	.s Nessary=$lg(^User.CSSDSysGridSetD(Chl),15)
	.s SeqNo=$lg(^User.CSSDSysGridSetD(Chl),17)
	.s Sort=$lg(^User.CSSDSysGridSetD(Chl),23)
	.s EnterSort=+$lg(^User.CSSDSysGridSetD(Chl),24)
	.s IFCopy=$lg(^User.CSSDSysGridSetD(Chl),25)
	.s IFExport=$lg(^User.CSSDSysGridSetD(Chl),26)
	.s Frozen=$lg(^User.CSSDSysGridSetD(Chl),27)
	.i Hidden="Y" d
	..s Hidden="true"
	.e  d
	..s Hidden=""
	.i Frozen="Y" d
	..s Frozen="true"
	.e  d
	..s Frozen=""
	.s:Nessary="Y" Name=..Nessary(Name)
	.s i=i+1
	.s ^TMPCSSDGridSET(pid,"SeqNo",SeqNo,i)=Rowid_"^"_Header_"^"_Name_"^"_Width_"^"_Align_"^"_EnterSort_"^"_Hidden_"^"_Nessary_"^"_Frozen
	q:pid="" Rtn
	s num=0
	s sub=0
	f  s sub=$o(^TMPCSSDGridSET(pid,"SeqNo",sub)) q:sub=""  d
	.s i=0
	.f  s i=$o(^TMPCSSDGridSET(pid,"SeqNo",sub,i)) q:i=""  d
	..s data=^TMPCSSDGridSET(pid,"SeqNo",sub,i)
	..s num=num+1
	..d json.InsertRowData(data)
	d json.getCbJsonData("rowid^field^title^width^align^enterSort^hidden^nessary^frozen")
	k json 
	k ^TMPCSSDGridSET(pid)
	q ""
}

ClassMethod Nessary(Header)
{
	n (Header)
	s Header="<font color=red>*</font>"_Header
	q Header
}

ClassMethod JsGetSaveMod(Main As %String) As %Library.String
{
	n (Main)
	s PJobj=##class(web.CSSDHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Main)
	s AppName=PJobj.%Get("AppName")
	s GridId=PJobj.%Get("GridId")
	s SaveMod=PJobj.%Get("SaveMod")
	s SaveValue=PJobj.%Get("SaveValue")
	s CspName=PJobj.%Get("CspName")
	s GroupId=PJobj.%Get("gGroupId")
	s UserId=PJobj.%Get("gUserId")
	s HospId=PJobj.%Get("gHospId")
	s SaveModInfo=..GetSaveMod(AppName,GridId,CspName,GroupId,UserId,HospId)
	q SaveModInfo
}

/// Descript:取某应用程序某Grid的最高级别的保存模式
/// Creater:ban
/// CreateDate: 2019-11-22
/// Table:CSSD_SysGridSet
/// Input:应用程序名称,GridId,安全组id,用户id;
/// Return：保存模式，模式值
ClassMethod GetSaveMod(AppName As %String, GridId As %String, CspName As %String, GroupId As %String, UserId As %String, SiteId As %String) As %Library.String
{
	n (AppName,GridId,CspName,GroupId,UserId,SiteId)
	s StrData=""
	q:AppName="" ""
	q:GridId="" ""
	s AppName=$$ALPHAUP^SSUTIL4(AppName)
	s CspName=$$ALPHAUP^SSUTIL4(CspName)
	q:CspName="" ""
	s SaveMod=""
	s ModValue=""
	i UserId'="" d	;优先按用户取
	.s Chl=$o(^User.CSSDSysGridSetI("IndexGrid",GridId,"SSUser",UserId,CspName,0))
	.i Chl'="" d
	..s SaveMod="SSUser"
	..s ModValue=UserId
	i (GroupId'="")&(SaveMod="") d	;没有按用户定义的话，按安全组取
	.s Chl=$o(^User.CSSDSysGridSetI("IndexGrid",GridId,"SSGroup",GroupId,CspName,0))
	.i Chl'="" d
	..s SaveMod="SSGroup"
	..s ModValue=GroupId
	i (SiteId'="")& (SaveMod="") d	;没有按用户和安全组定义的话，按站点取
	.s Chl=$o(^User.CSSDSysGridSetI("IndexGrid",GridId,"SITE",SiteId,CspName,0))
	.s SaveMod="SITE"
	.s ModValue=SiteId
	i SaveMod'="" d
	.s StrData=SaveMod_"^"_ModValue
	q StrData
}

ClassMethod ReSet()
{
	&sql(select %id from CSSD_SysGridSet)
	q:SQLCODE'=0 ""
	
	&sql(delete from CSSD_SysGridSet)
	i SQLCODE'=0 q "重置失败"
	
	q ""
}

}
