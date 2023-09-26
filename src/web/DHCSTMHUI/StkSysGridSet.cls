Import sqluser

/// Descript:	Grid列设置
/// Creater:	XuChao
/// CreateDate:	2018-07-11
Class web.DHCSTMHUI.StkSysGridSet Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	保存grid 列设置
/// Creater:	XuChao
/// CreateDate:	2018-07-11
/// Table:DHC_StkSysGridSet
Query GetGridSet(Main As %String) As Query(ROWSPEC = "RowId,Name,Header,Width,Align,Hidden,EnterSort,Necessary,Frozen")
{
}

ClassMethod GetGridSetExecute(ByRef qHandle As %Binary, Main As %String) As %Status
{
	n (qHandle,Main)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Main)
	s AppName=PJobj.%Get("AppName")
	s GridId=PJobj.%Get("GridId")
	s SaveModule=PJobj.%Get("SaveModule")
	s SaveValue=PJobj.%Get("SaveValue")
	s CspName=PJobj.%Get("CspName")
	s GroupId=PJobj.%Get("gGroupId")
	s UserId=PJobj.%Get("gUserId")
	s HospId=PJobj.%Get("gHospId")
	s SaveModInfo=..GetSaveMod(AppName,GridId,CspName,GroupId,UserId,HospId)
	q:SaveModInfo="" $$$OK
	s SaveModule=$p(SaveModInfo,"^",1)
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
	s sql=sql_" FROM DHC_StkSysGridSet"
	s sql=sql_" where GS_SSA_ParRef->SSA_Code='"_AppName_"' AND GS_CspName='"_CspName_"' AND GS_GridID='"_GridId_"' and GS_SaveFor='"_SaveModule_"'"
	s sql=sql_"	and GS_Reference="_SaveValue_"order by GS_Order" 
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

/// Descript:	保存grid 列设置
/// Creater:	XuChao
/// CreateDate:	2018-07-11
/// Table:DHC_StkSysGridSet
/// Input:应用程序名称;grid Id,保存模式(SSUser,SSGroup,SITE), 保存模式值(用户id,安全组id,站点名称;)
/// rowid^顺序号^列id^列标题^宽度^对齐方式^是否排序^是否隐藏^名称^显示格式^数据类型,
///  ##class(web.DHCSTMHUI.StkSysGridSet).Save(^tmp1,^tmp2)
ClassMethod Save(Main As %String, Detail As %String) As %String
{
	n (Main,Detail)
	s RtnObj=##class(RtnObj).%New()
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Main)
	s AppName=PJobj.%Get("AppName")
	s GridId=PJobj.%Get("GridId")
	s SaveModule=PJobj.%Get("SaveModule")
	s SaveValue=PJobj.%Get("SaveValue")
	s CspName=PJobj.%Get("CspName")
	s GroupId=PJobj.%Get("gGroupId")
	s UserId=PJobj.%Get("gUserId")
	s HospId=PJobj.%Get("gHospId")
	i SaveModule="SSUser" s SaveValue=UserId
	i SaveModule="SSGroup" s SaveValue=GroupId
	i SaveModule="SITE" s SaveValue=HospId
	i AppName="" d RtnObj.Err(-1,"","不能为空!","",0) q RtnObj.Json()
	s AppName=$$ALPHAUP^SSUTIL4(AppName)
	s AppId=$o(^DHCSSA(0,"ACODE",AppName,0))
	i AppId="" d RtnObj.Err(-1,"","不能为空!","",0) q RtnObj.Json()
	i GridId="" d RtnObj.Err(-1,"","不能为空!","",0) q RtnObj.Json()
	i CspName="" d RtnObj.Err(-1,"","不能为空!","",0) q RtnObj.Json()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Detail)
	s Order=0
	&sql(select GS_RowId from DHC_StkSysGridSet  where  GS_SSA_ParRef->SSA_Code=:AppName AND GS_CspName=:CspName AND GS_GridID=:GridId and GS_SaveFor=:SaveModule
	and GS_Reference=:SaveValue)
	s InSertFlag="N"
	i SQLCODE'=0  s InSertFlag="Y"
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
		.s chl=1+$o(^DHCSSA(AppId,"GS",""),-1)
		.&sql(Insert into DHC_StkSysGridSet(GS_SSA_ParRef,GS_ChildSub,GS_GridID,GS_SaveFor,GS_Name,
		GS_Header,GS_Width,GS_Alignment,GS_Format,GS_Hidden,GS_Necessary,
		GS_Order,GS_DataType,GS_Reference,GS_CspName,GS_Sortable,GS_EnterSort,
		GS_IFCopy,GS_IFExport,GS_Frozen)
		values(:AppId,:chl,:GridId,:SaveModule,:Name,:Header,:Width,:Align,:Format,:Hide,
		:Necessary,:Order,:DataType,:SaveValue,:CspName,:Sort,:EnterSort,
		:IFCopy,:IFExport,:Frozen))
		.i SQLCODE'=0  d
		..d RtnObj.Err(-1,"","插入失败!")
		e  d
		.&sql(Update DHC_StkSysGridSet set GS_Name=:Name,GS_Header=:Header,GS_Width=:Width,
		GS_Alignment=:Align,GS_Format=:Format,GS_Hidden=:Hide,
		GS_DataType=:DataType,GS_Sortable=:Sort,GS_EnterSort=:EnterSort,GS_Necessary=:Necessary,
		GS_IFCopy=:IFCopy,GS_IFExport=:IFExport,GS_Order=:Order,GS_Frozen=:Frozen where GS_Rowid=:Rowid)
		.i SQLCODE'=0  d
		..d RtnObj.Err(-1,"","更新失败!")
		continue:RtnObj.success'=0
	}
	q:RtnObj.success'=0 RtnObj.Json()
	q RtnObj.Json()
}

/// Descript:	保存grid 列设置
/// Creater:	XuChao
/// CreateDate:	2018-07-11
/// Table:DHC_StkSysGridSet
/// Input:应用程序名称;grid Id,保存模式(SSUser,SSGroup,SITE), 保存模式值(用户id,安全组id,站点名称;)
/// rowid^顺序号^列id^列标题^宽度^对齐方式^是否排序^是否隐藏^名称^显示格式^数据类型,
/// Return：成功：0;其它：失败
ClassMethod Update(AppName As %String, GridId As %String, SaveModule As %String, SaveValue As %String, CspName As %String, Detail As %String) As RtnObj
{
	n (AppName,GridId,SaveModule,SaveValue,CspName,Detail)
	s RtnObj=##class(RtnObj).%New()
	i AppName="" d RtnObj.Err(-1,"","模块不能为空!","",0) q RtnObj
	i GridId="" d RtnObj.Err(-1,"","表格ID不能为空!","",0) q RtnObj
	s AppName=$$ALPHAUP^SSUTIL4(AppName)
	s AppId=$o(^DHCSSA(0,"ACODE",AppName,0))
	i AppId="" d RtnObj.Err(-1,"","模块不能为空!","",0) q RtnObj
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Detail)
	s No="N",Yes="Y"
	&sql(update DHC_StkSysGridSet set GS_SysFlag=:No
		where GS_SSA_ParRef->SSA_Code=:AppName AND GS_CspName=:CspName AND GS_GridID=:GridId
		and GS_SaveFor=:SaveModule and GS_Reference=:SaveValue
	)
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s Header=Obj.%Get("field")
		s Width=Obj.%Get("width")
		s Align=Obj.%Get("align")
		s Sort=Obj.%Get("sort")
		s Hide=Obj.%Get("hidden")
		s Name=Obj.%Get("title")
		s Format=Obj.%Get("Forat")
		s DataType=Obj.%Get("DataType")
		s EnterSort=Obj.%Get("EnterSort")
		s IFCopy=Obj.%Get("IFCopy")
		s IFExport=Obj.%Get("IFExport")
		s Necessary=Obj.%Get("necessary")
		s Frozen=Obj.%Get("frozen")
		
		s Hide=$s(Hide=1:"Y",1:"N")
		s Necessary=$s(Necessary=1:"Y",1:"N")
		s Frozen=$s(Frozen=1:"Y",1:"N")
		
		s Rowid=""
		&sql(select GS_RowId into :Rowid from DHC_StkSysGridSet
			where GS_SSA_ParRef->SSA_Code=:AppName AND GS_CspName=:CspName AND GS_GridID=:GridId
			and GS_SaveFor=:SaveModule and GS_Reference=:SaveValue and GS_Header=:Header
		)
		i SQLCODE=0  d
		.&sql(Update DHC_StkSysGridSet set GS_SysFlag=:Yes where GS_Rowid=:Rowid)
		.i SQLCODE'=0  d
		..d RtnObj.Err(-1,"","更新失败!")
		e  d
		.s chl=1+$o(^DHCSSA(AppId,"GS",""),-1)
		.s SeqNo=0
		.&sql(select max(GS_Order) into :SeqNo from DHC_StkSysGridSet
			where GS_SSA_ParRef->SSA_Code=:AppName AND GS_CspName=:CspName AND GS_GridID=:GridId
			and GS_SaveFor=:SaveModule and GS_Reference=:SaveValue)
		.s SeqNo=1+SeqNo
		.&sql(Insert into DHC_StkSysGridSet
			(GS_SSA_ParRef,GS_ChildSub,GS_GridID,GS_SaveFor,GS_Key,
			GS_Name,GS_Header,GS_Width,GS_Alignment,GS_Format,
			GS_Hidden,GS_Necessary,GS_Order,GS_DataType,GS_Reference,
			GS_CspName,GS_Sortable,GS_EnterSort,GS_IFCopy,GS_IFExport,
			GS_SysFlag,GS_Frozen)
			values
			(:AppId,:chl,:GridId,:SaveModule,:ColKey,
			:Name,:Header,:Width,:Align,:Format,
			:Hide,:Necessary,:SeqNo,:DataType,:SaveValue,
			:CspName,:Sort,:EnterSort,:IFCopy,:IFExport,
			:Yes,:Frozen)
		 )
		.i SQLCODE'=0 d
		..d RtnObj.Err(-1,"","插入失败!")
		continue:RtnObj.success'=0
	}
	q:RtnObj.success'=0 RtnObj
	&sql(delete from DHC_StkSysGridSet
		where GS_SSA_ParRef->SSA_Code=:AppName AND GS_CspName=:CspName AND GS_GridID=:GridId
		and GS_SaveFor=:SaveModule and GS_Reference=:SaveValue and GS_SysFlag=:No
	)
	q RtnObj
}

/// Descript:删除grid 列设置
/// Creater:	ZhangDongmei
/// CreateDate:	2011-06-13
/// Table:DHC_StkSysGridSet
/// Input:rowid,
/// 顺序号^列id^列标题^宽度^对齐方式^是否排序^是否隐藏^名称^显示格式^数据类型
/// 
/// Output:		
/// Return：成功：0;
ClassMethod Delete(Main) As %Library.String
{
	n (Main)
	s RtnObj=##class(RtnObj).%New()
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Main)
	s AppName=PJobj.%Get("AppName")
	s GridId=PJobj.%Get("GridId")
	s SaveModule=PJobj.%Get("SaveModule")
	s SaveValue=PJobj.%Get("SaveValue")
	s CspName=PJobj.%Get("CspName")
	s GroupId=PJobj.%Get("gGroupId")
	s UserId=PJobj.%Get("gUserId")
	s HospId=PJobj.%Get("gHospId")
	i SaveModule="SSUser" s SaveValue=UserId
	i SaveModule="SSGroup" s SaveValue=GroupId
	i SaveModule="SITE" s SaveValue=HospId

	s AppName=$$ALPHAUP^SSUTIL4(AppName)
	s AppId=$o(^DHCSSA(0,"ACODE",AppName,0))
	i AppId="" d RtnObj.Err(-1,"","模块不能为空!","",0) q RtnObj.Json()
	i GridId="" d RtnObj.Err(-1,"","表格ID不能为空!","",0) q RtnObj.Json()
	i SaveModule="" d RtnObj.Err(-1,"","保存模式不能为空!","",0) q RtnObj.Json()
	i SaveValue="" d RtnObj.Err(-1,"","保存模式值不能为空!","",0) q RtnObj.Json()
	i CspName="" d RtnObj.Err(-1,"","CSP不能为空!","",0) q RtnObj.Json()

	&sql(Select * from DHC_StkSysGridSet where GS_GridID=:GridId and GS_SaveFor=:SaveModule 
	and GS_Reference=:SaveValue and GS_CspName=:CspName and GS_SSA_ParRef=:AppId)
	i SQLCODE=100 d
	.d RtnObj.Err(-2,"","用户和安全组还未保存，不能删除!","",0)
	e  d
	&sql(Delete from DHC_StkSysGridSet where GS_GridID=:GridId and GS_SaveFor=:SaveModule 
	and GS_Reference=:SaveValue and GS_CspName=:CspName and GS_SSA_ParRef=:AppId)
	.i SQLCODE'=0 d
	..d RtnObj.Err(-1,"","删除失败!")
	q RtnObj.Json()
}

/// Descript:处理 列设置数据
/// Creater:XuChao
/// CreateDate:	2018-07-12
/// Table:DHC_StkSysGridSet
/// Input:Main (应用程序名称,GridId,保存模式,模式值)
/// 		  Detail 列设置数据
/// Return：列设置信息
/// w ##class(web.DHCSTMHUI.StkSysGridSet).Query
ClassMethod Query(Main As %String, Detail As %String) As %Library.String
{
	n (Main,Detail)
	s Rtn="[]"
	s RtnObj=##class(RtnObj).%New()
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Main)
	s AppName=PJobj.%Get("AppName")
	s GridId=PJobj.%Get("GridId")
	s SaveModule=PJobj.%Get("SaveModule")
	s SaveValue=PJobj.%Get("SaveValue")
	s CspName=PJobj.%Get("CspName")
	s GroupId=PJobj.%Get("gGroupId")
	s UserId=PJobj.%Get("gUserId")
	s HospId=PJobj.%Get("gHospId")
	q:AppName="" Rtn
	s AppName=$$ALPHAUP^SSUTIL4(AppName)
	s AppId=$o(^DHCSSA(0,"ACODE",AppName,0))
	q:AppId="" Rtn   		;不能为空
	q:GridId="" Rtn   		;不能为空
	q:CspName="" Rtn		;不能为空
	
	//1 检查是否存在列设置数据
	;&sql(SELECT GS_RowId FROM DHC_StkSysGridSet WHERE GS_SSA_ParRef->SSA_Code=:AppName AND GS_CspName=:CspName AND GS_GridID=:GridId )
	;i SQLCODE'=0 q Rtn
	//2 SaveMod为空  取最高权限
	i SaveModule="" d
	.s SaveModInfo=..GetSaveMod(AppName,GridId,CspName,GroupId,UserId,HospId)
	.i SaveModInfo="" s SaveModInfo="SITE"_"^"_HospId
	.s SaveModule=$p(SaveModInfo,"^",1)
	.s SaveValue=$p(SaveModInfo,"^",2)
	q:SaveModule="" Rtn		;不能为空
	q:SaveValue="" Rtn		;不能为空
	
	//3 保存
	s RtnObj=..Update(AppName,GridId,SaveModule,SaveValue,CspName,Detail)
	q:RtnObj.success'=0 Rtn
	s pid=..NewPid()
	s json = ##class(web.DHCSTMHUI.Common.JsonObj).%New()
	s i=0
	s Chl=0
	f  s Chl=$o(^DHCSSA(0,"GRID",GridId,SaveModule,SaveValue,$$ALPHAUP^SSUTIL4(CspName),AppId,Chl))  q:Chl=""  d
	.s Rowid=AppId_"||"_Chl
	.s ColKey=$p(^DHCSSA(AppId,"GS",Chl),"^",3)
	.s Name=$p(^DHCSSA(AppId,"GS",Chl),"^",4)
	.s Header=$p(^DHCSSA(AppId,"GS",Chl),"^",5)
	.s Width=$p(^DHCSSA(AppId,"GS",Chl),"^",6)
	.s Align=$p(^DHCSSA(AppId,"GS",Chl),"^",7)
	.s Format=$p(^DHCSSA(AppId,"GS",Chl),"^",8)
	.s DataType=$p(^DHCSSA(AppId,"GS",Chl),"^",11)
	.s Hidden=$p(^DHCSSA(AppId,"GS",Chl),"^",12)
	.s Nessary=$p(^DHCSSA(AppId,"GS",Chl),"^",14)
	.s SeqNo=$p(^DHCSSA(AppId,"GS",Chl),"^",16)
	.s Sort=$p(^DHCSSA(AppId,"GS",Chl),"^",22)
	.s EnterSort=+$p(^DHCSSA(AppId,"GS",Chl),"^",23)
	.s IFCopy=$p(^DHCSSA(AppId,"GS",Chl),"^",24)
	.s IFExport=$p(^DHCSSA(AppId,"GS",Chl),"^",25)
	.s Frozen=$p(^DHCSSA(AppId,"GS",Chl),"^",26)
	.i Sort="Y" d
	..s Sort="true"
	.e  d
	..s Sort=""
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
	.s data1=Rowid_"^"_Header_"^"_Name_"^"_Width_"^"_Align
	.s data2=EnterSort_"^"_Hidden_"^"_Nessary_"^"_Frozen
	.s ^TMPCOLSET(pid,"SeqNo",SeqNo,i)=data1_"^"_data2
	
	q:pid="" Rtn
	s num=0
	s sub=0
	f  s sub=$o(^TMPCOLSET(pid,"SeqNo",sub)) q:sub=""  d
	.s i=0
	.f  s i=$o(^TMPCOLSET(pid,"SeqNo",sub,i)) q:i=""  d
	..s data=^TMPCOLSET(pid,"SeqNo",sub,i)
	..s num=num+1
	..d json.InsertRowData(data)

	d json.getCbJsonData("rowid^field^title^width^align^enterSort^hidden^nessary^frozen")
 	k json
 	k ^TMPCOLSET(pid)
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
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Main)
	s AppName=PJobj.%Get("AppName")
	s GridId=PJobj.%Get("GridId")
	s SaveModule=PJobj.%Get("SaveModule")
	s SaveValue=PJobj.%Get("SaveValue")
	s CspName=PJobj.%Get("CspName")
	s GroupId=PJobj.%Get("gGroupId")
	s UserId=PJobj.%Get("gUserId")
	s HospId=PJobj.%Get("gHospId")
	s SaveModInfo=..GetSaveMod(AppName,GridId,CspName,GroupId,UserId,HospId)
	q SaveModInfo
}

/// Descript:取某应用程序某Grid的最高级别的保存模式
/// Creater:XuChao
/// CreateDate:	2018-05-22
/// Table:DHC_StkSysGridSet
/// Input:应用程序名称,GridId,安全组id,用户id;
/// Return：保存模式，模式值
/// W ##CLASS(web.DHCSTMHUI.StkSysGridSet).GetSaveMod("DHCSTCOMMONM","#ItmLocGrid","dhcstmhui.incitmloc.csp","277","6423","2")
ClassMethod GetSaveMod(AppName As %String, GridId As %String, CspName As %String, GroupId As %String, UserId As %String, SiteId As %String) As %Library.String
{
	n (AppName,GridId,CspName,GroupId,UserId,SiteId)
	s StrData=""
	q:AppName="" ""
	q:GridId="" ""
	s AppName=$$ALPHAUP^SSUTIL4(AppName)
	s AppId=$o(^DHCSSA(0,"ACODE",AppName,0))
	q:AppId="" ""
	s CspName=$$ALPHAUP^SSUTIL4(CspName)
	q:CspName="" ""
	
	s (SaveModule,ModValue)=""
	i UserId'="" d						;优先按用户取
	.s Chl=$o(^DHCSSA(0,"GRID",GridId,"SSUser",UserId,CspName,AppId,0))
	.i Chl'="" d
	..s SaveModule="SSUser"
	..s ModValue=UserId
	i (SaveModule="")&&(GroupId'="") d		;没有按用户定义的话，按安全组取
	.s Chl=$o(^DHCSSA(0,"GRID",GridId,"SSGroup",GroupId,CspName,AppId,0))
	.i Chl'=""  d
	..s SaveModule="SSGroup"
	..s ModValue=GroupId
	i (SaveModule="")&&(SiteId'="") d		;没有按用户和安全组定义的话，按站点取
	.s Chl=$o(^DHCSSA(0,"GRID",GridId,"SITE",SiteId,CspName,AppId,0))
	.i Chl'="" d
	..s SaveModule="SITE"
	..s ModValue=SiteId
	
	i SaveModule'="" d
	.s StrData=SaveModule_"^"_ModValue
	
	q StrData
}

}
