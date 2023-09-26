Import sqluser

/// Descript:Grid列设置
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-07
Class web.DHCST.StkSysGridSet Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:   保存grid 列设置
/// Creater:    ZhangDongmei
/// CreateDate: 2011-04-13
/// Table:DHC_StkSysGridSet
/// Input:应用程序名称;grid Id,保存模式(SSUser,SSGroup,SITE), 保存模式值(用户id,安全组id,站点名称;)
/// rowid^顺序号^列id^列标题^宽度^对齐方式^是否排序^是否隐藏^名称^显示格式^数据类型,
/// rowid^顺序号^列id^列标题^宽度^对齐方式^是否排序^是否隐藏^名称^显示格式^数据类型
/// 
/// Output:     
/// Return：成功：0;其它：失败
ClassMethod Save(AppName As %String, GridId As %String, SaveModule As %String, SaveValue As %String, CspName As %String, listColumnData As %String) As %Library.String
{
    n (AppName,GridId,SaveModule,SaveValue,CspName,listColumnData)
    q:AppName="" ""
    q:GridId="" ""
    s AppName=$$ALPHAUP^SSUTIL4(AppName)
    s AppId=$o(^DHCSSA(0,"ACODE",AppName,0))
    q:AppId="" ""
    s InsertFlag=0
    i '$d(^DHCSSA(0,"GRID",GridId,SaveModule,SaveValue,$$ALPHAUP^SSUTIL4(CspName),AppId))  d
    .s InsertFlag=1
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    s len=$l(listColumnData,rowDelim)
    s Err=0
    tstart
    s $ZT="Error^DHCSTERROR"                        ;增加错误处理
    ;
    f i=1:1:len  q:Err'=0  d
    .s data=$p(listColumnData,rowDelim,i)
    .s Rowid=$p(data,"^",1)
    .s data=$p(data,"^",2,$l(data,"^"))
    .i (Rowid'="")&(InsertFlag'=1)  d
    ..s ret=..Update(Rowid,data)
    ..s:ret'=0 Err=-3
    .e  d
    ..s Id=..Insert(AppId,GridId,SaveModule,SaveValue,CspName,data)
    ..s:Id="" Err=-2
    .
    i Err'=0 trollback
    q:Err'=0 Err
    tcommit
    q 0
}

/// Descript:保存grid 列设置
/// Creater:    ZhangDongmei
/// CreateDate: 2011-06-07
/// Table:DHC_StkSysGridSet
/// Input:App id,grid Id,保存模式(SSUser,SSGroup,SITE), 保存模式值(用户id,安全组id,站点名称;), 
/// 顺序号^列id^列标题^宽度^对齐方式^是否排序^是否隐藏^名称^显示格式^数据类型^回车跳转
/// 
/// Output:     
/// Return：成功：DHC_StkSysGridSet表rowid
ClassMethod Insert(AppId As %String, GridId As %String, SaveModule As %String, SaveValue As %String, CspName As %String, listData As %String) As %Library.String
{
    n (AppId,GridId,SaveModule,SaveValue,CspName,listData)
    q:AppId="" ""
    q:GridId="" ""
    s SeqNo=$p(listData,"^",1)
    s ColKey=$p(listData,"^",2)
    q:ColKey="" ""
    s Header=$p(listData,"^",3)
    s Width=$p(listData,"^",4)
    s Align=$p(listData,"^",5)
    s Sort=$p(listData,"^",6)
    s Hide=$p(listData,"^",7)
    s Name=$p(listData,"^",8)
    s Format=$p(listData,"^",9)
    s DataType=$p(listData,"^",10)
    s EnterSort=$p(listData,"^",11)
    i EnterSort="Y" s EnterSort=1
    e  s EnterSort=""
    s Necessary=""
    ;
    s Err=0
    s chl=1+$o(^DHCSSA(AppId,"GS",""),-1)
    &sql(Insert into DHC_StkSysGridSet(GS_SSA_ParRef,GS_ChildSub,GS_GridID,GS_SaveFor,GS_Key,GS_Name,
    GS_Header,GS_Width,GS_Alignment,GS_Format,GS_Hidden,GS_Necessary,
    GS_Order,GS_DataType,GS_Reference,GS_CspName,GS_Sortable,GS_EnterSort)
    values(:AppId,:chl,:GridId,:SaveModule,:ColKey,:Name,:Header,:Width,:Align,:Format,:Hide,
    :Necessary,:SeqNo,:DataType,:SaveValue,:CspName,:Sort,:EnterSort))
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("DHC_StkSysGridSet:insert",ColKey,SQLCODE_":"_%msg)
    .s Err=-1
    q:Err'=0 ""
    q $p(%ROWID,$c(1))
}

/// Descript:更新grid 列设置
/// Creater:    ZhangDongmei
/// CreateDate: 2011-06-07
/// Table:DHC_StkSysGridSet
/// Input:rowid,
/// 顺序号^列id^列标题^宽度^对齐方式^是否排序^是否隐藏^名称^显示格式^数据类型^回车跳转
/// 
/// Output:     
/// Return：成功：0;
ClassMethod Update(DetailId As %String, listData As %String) As %Library.String
{
    n (DetailId,listData)
    q:DetailId="" -1
    q:listData="" -1
    s SeqNo=$p(listData,"^",1)
    s ColKey=$p(listData,"^",2)
    q:ColKey="" -1
    s Header=$p(listData,"^",3)
    s Width=$p(listData,"^",4)
    s Align=$p(listData,"^",5)
    s Sort=$p(listData,"^",6)
    s Hide=$p(listData,"^",7)
    s Name=$p(listData,"^",8)
    s Format=$p(listData,"^",9)
    s DataType=$p(listData,"^",10)
    s EnterSort=$p(listData,"^",11)
    i EnterSort="Y" s EnterSort=1
    e  s EnterSort=""
    s Err=0
    &sql(Update DHC_StkSysGridSet set GS_Header=:Header,GS_Width=:Width,
    GS_Alignment=:Align,GS_Format=:Format,GS_Hidden=:Hide,GS_Necessary=:Necessary,
    GS_Order=:SeqNo,GS_DataType=:DataType,GS_Sortable=:Sort,GS_EnterSort=:EnterSort where GS_Rowid=:DetailId)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("DHC_StkSysGridSet:update",DetailId,SQLCODE_":"_%msg)
    .s Err=-1
    q Err
}

/// Descript:删除grid 列设置
/// Creater:    ZhangDongmei
/// CreateDate: 2011-06-13
/// Table:DHC_StkSysGridSet
/// Input:rowid,
/// 顺序号^列id^列标题^宽度^对齐方式^是否排序^是否隐藏^名称^显示格式^数据类型
/// 
/// Output:     
/// Return：成功：0;
/// w ##class(web.DHCST.StkSysGridSet).Delete(92,"DetailGrid","SSUser","药房01","dhcst.ingdrec.csp")
ClassMethod Delete(AppId As %String, GridId As %String, SaveMod As %String, SaveValue As %String, CspName As %String) As %Library.String
{
    n (AppId,GridId,SaveMod,SaveValue,CspName)
    q:AppId="" -1
    q:GridId="" -1
    q:SaveMod="" -1
    q:SaveValue="" -1
    q:CspName="" -1
    ;
    s Err=0
    &sql(Delete from DHC_StkSysGridSet where GS_GridID=:GridId and GS_SaveFor=:SaveMod 
    and GS_Reference=:SaveValue and GS_CspName=:CspName and GS_SSA_ParRef=:AppId)
    ;b ;sql
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("DHC_StkSysGridSet:Delete",GridId,SQLCODE_":"_$g(%msg))
    .s Err=-1
    q Err
}

/// Descript:检查是否已存在相同数据
/// Creater:    ZhangDongmei
/// CreateDate: 2011-06-07
/// Table:DHC_StkSysGridSet
/// Input:app id;grid Id;保存模式;保存模式值;
/// Output:     
/// Return：存在:1，不存在：0
/// Save中调用
ClassMethod CheckVsfgData(AppId As %String, GridId As %String, SaveMod As %String, SaveValue As %String, CspName As %String) As %Library.String
{
    n (AppId,GridId,SaveMod,SaveValue,CspName)  
    q:AppId="" 0
    q:GridId="" 0
    q:SaveMod="" 0
    q:SaveValue="" 0
    q:CspName="" 0
    s Flag=0
    s Chl=$o(^DHCSSA(0,"GRID",GridId,SaveMod,SaveValue,$$ALLPHAUP^SSUTIL4(CspName),AppId,0))  
    s:Chl'="" Flag=1
    ;
    q Flag
}

/// Descript:取某应用程序的grid
/// Creater:ZhangDongmei
/// CreateDate: 2012-06-07
/// Table:DHC_StkSysGridSet
/// Input:应用程序名称
/// Output:     
/// Return：Grid^保存模式^模式值
ClassMethod GetVsfgInfo(AppName As %String) As %Library.String
{
    n (AppName) 
    q:AppName="" ""
    s AppName=$$ALPHAUP^SSUTIL4(AppName)
    ;s ^zdm("GetVsfgInfo")=AppName
    s AppId=$o(^DHCSSA(0,"ACODE",AppName,0))
    q:AppId="" ""
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT Distinct GS_GridID,GS_SaveFor,GS_Reference,GS_CspName"_  
    " FROM DHC_StkSysGridSet where GS_SSA_ParRef="_AppId
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {   
        s GridId = result.Data("GS_GridID")
        s SaveMod = result.Data("GS_SaveFor")
        s SaveValue = result.Data("GS_Reference")
        s SaveValueDesc = $s(
        	SaveMod="SSGroup":$p($g(^SSU("SSGRP",SaveValue)),"^",1),
        	SaveMod="SSUser":$p($g(^SSU("SSUSR",SaveValue)),"^",2),
        	1:SaveValue
        )
        s SaveValueID=SaveValue
        s:SaveValueDesc'="" SaveValue = SaveValueDesc //Huxt 2020-02-24
        s CspName=result.Data("GS_CspName")
        ;
        s tmp=GridId_"^"_SaveMod_"^"_SaveValue_"^"_CspName_"^"_SaveValueID
        s count = count+1       
        d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("GridId^SaveMod^SaveValue^CspName^SaveValueID",count)
    k json
    Q resultString
}

/// Descript:取某Grid列设置信息
/// Creater:ZhangDongmei
/// CreateDate: 2011-06-07
/// Table:DHC_StkSysGridSet
/// Input:应用程序名称,GridId,保存模式,模式值
/// Output:     
/// Return：列设置信息
/// w ##class(web.DHCST.StkSysGridSet).Query("DHCSTPURPLANAUDIT","ext-comp-1043","SSUser","药房01","dhcst.inpurplan.csp")
/// w ##class(web.DHCST.StkSysGridSet).Query("DHCSTPURPLANAUDIT","ext-comp-1043","SITE","DHCHEALTH","dhcst.inpurplan.csp")
ClassMethod Query(AppName As %String, GridId As %String, SaveMod As %String, SaveValue As %String, CspName As %String) As %Library.String
{
    n (AppName,GridId,SaveMod,SaveValue,CspName)
    s pid=..NewPid()
    Set json = ##class(Code.JsonObj).%New()
    q:AppName="" ""
    s AppName=$$ALPHAUP^SSUTIL4(AppName)
    s AppId=$o(^DHCSSA(0,"ACODE",AppName,0))
    q:AppId="" ""           ;不能为空
    q:GridId="" ""          ;不能为空
    q:SaveMod="" ""         ;不能为空
    q:SaveValue="" ""       ;不能为空
    q:CspName="" ""         ;不能为空
    s i=0

    s Chl=0
    f  s Chl=$o(^DHCSSA(0,"GRID",GridId,SaveMod,SaveValue,$$ALPHAUP^SSUTIL4(CspName),AppId,Chl))  q:Chl=""  d
    .s Rowid=AppId_"||"_Chl
    .s ColKey=$p(^DHCSSA(AppId,"GS",Chl),"^",3)
    .s Name=$p(^DHCSSA(AppId,"GS",Chl),"^",4)
    .s Header=$p(^DHCSSA(AppId,"GS",Chl),"^",5)
    .s Width=$p(^DHCSSA(AppId,"GS",Chl),"^",6)
    .s Align=$p(^DHCSSA(AppId,"GS",Chl),"^",7)
    .s Format=$p(^DHCSSA(AppId,"GS",Chl),"^",8)
    .s DataType=$p(^DHCSSA(AppId,"GS",Chl),"^",11)
    .s Hide=$p(^DHCSSA(AppId,"GS",Chl),"^",12)
    .s Nessary=$p(^DHCSSA(AppId,"GS",Chl),"^",14)
    .s SeqNo=$p(^DHCSSA(AppId,"GS",Chl),"^",16)
    .s Sort=$p(^DHCSSA(AppId,"GS",Chl),"^",22)
    .s EnterSort=$p(^DHCSSA(AppId,"GS",Chl),"^",23)
    .i EnterSort>0 s EnterSort="Y"
    .e  s EnterSort="N" 
    .s i=i+1
    .s data1=Rowid_"^"_ColKey_"^"_Name_"^"_Header_"^"_Width_"^"_Align
    .s data2=Format_"^"_Hide_"^"_Nessary_"^"_SeqNo_"^"_DataType_"^"_Sort_"^"_EnterSort
    .s ^TMPCOLSET(pid,"SeqNo",SeqNo,i)=data1_"^"_data2
    q:pid="" ""
    s num=0
    s sub=0
    f  s sub=$o(^TMPCOLSET(pid,"SeqNo",sub)) q:sub=""  d
    .s i=0
    .f  s i=$o(^TMPCOLSET(pid,"SeqNo",sub,i)) q:i=""  d
    ..s data=^TMPCOLSET(pid,"SeqNo",sub,i)
    ..s num=num+1
    ..d json.InsertRowData(data)
    .
    s DetailInfo=json.getJsonData("rowid^id^name^header^width^align^format^hidden^nessary^seqno^datatype^sortable^entersort",num)
    k json 
    k ^TMPCOLSET(pid)      
    q DetailInfo
}

/// Descript:取某Grid列设置信息
/// Creater:ZhangDongmei
/// CreateDate: 2011-06-08
/// Table:DHC_StkSysGridSet
/// Input:应用程序名称,GridId,保存模式,模式值
/// Output:     
/// Return：列设置信息,动态设置列属性调用
ClassMethod GetGridColSet(AppName As %String, CspName As %String, GridId As %String, GroupId As %String, UserId As %String, SiteCode As %String) As %Library.String
{
    n (AppName,CspName,GridId,GroupId,UserId,SiteCode)
    ;
    q:AppName="" ""
    s AppName=$$ALPHAUP^SSUTIL4(AppName)
    s AppId=$o(^DHCSSA(0,"ACODE",AppName,0))
    s pid=..NewPid()
    q:AppId="" ""           ;不能为空
    q:GridId="" ""          ;不能为空
    s SaveInfo=..GetSaveMod(AppName,GridId,CspName,GroupId,UserId,SiteCode)
    s SaveMod=$p(SaveInfo,"^",1)
    s SaveValue=$p(SaveInfo,"^",2)
    q:SaveMod="" ""     ;不能为空
    q:SaveValue="" ""       ;不能为空
    
    s CspName=$$ALPHAUP^SSUTIL4(CspName)
    s i=0
    s Chl=0
    f  s Chl=$o(^DHCSSA(0,"GRID",GridId,SaveMod,SaveValue,CspName,AppId,Chl)) q:Chl=""  d
    .s ColKey=$p(^DHCSSA(AppId,"GS",Chl),"^",3)
    .s Name=$p(^DHCSSA(AppId,"GS",Chl),"^",4)
    .s Header=$p(^DHCSSA(AppId,"GS",Chl),"^",5)
    .s Width=$p(^DHCSSA(AppId,"GS",Chl),"^",6)
    .s Align=$p(^DHCSSA(AppId,"GS",Chl),"^",7)
    .s Format=$p(^DHCSSA(AppId,"GS",Chl),"^",8)
    .s DataType=$p(^DHCSSA(AppId,"GS",Chl),"^",11)
    .s Hide=$p(^DHCSSA(AppId,"GS",Chl),"^",12)
    .s Nessary=$p(^DHCSSA(AppId,"GS",Chl),"^",14)
    .s SeqNo=$p(^DHCSSA(AppId,"GS",Chl),"^",16)
    .s Sortable=$p(^DHCSSA(AppId,"GS",Chl),"^",22)
    .s EnterSort=$p(^DHCSSA(AppId,"GS",Chl),"^",23)
    .s i=i+1
    .s data1=ColKey_"^"_Name_"^"_Header_"^"_Width_"^"_Align
    .s data2=Format_"^"_Hide_"^"_Nessary_"^"_SeqNo_"^"_DataType_"^"_Sortable_"^"_EnterSort
    .s ^TMPCOLSET(pid,"SeqNo",SeqNo,i)=data1_"^"_data2
    .;b ;i  
    ;
    ;b ;str
    s StrData=""
    q:pid="" ""
    s num=0
    s sub=0
    f  s sub=$o(^TMPCOLSET(pid,"SeqNo",sub)) q:sub=""  d
    .s i=0
    .f  s i=$o(^TMPCOLSET(pid,"SeqNo",sub,i)) q:i=""  d
    ..s data=^TMPCOLSET(pid,"SeqNo",sub,i)
    ..s num=num+1
    ..;d json.InsertRowData(data)
    ..i StrData="" d
    ...s StrData=data
    ..e  d
    ...s StrData=StrData_","_data
    .
    ;s DetailInfo=json.getJsonData("colkey^name^header^width^align^format^hidden^nessary^seqno^datatype",num)
    ;k json 
    k ^TMPCOLSET(pid)      
    q StrData
}

/// Descript:取某应用程序某Grid的最高级别的保存模式
/// Creater:ZhangDongmei
/// CreateDate: 2011-06-08
/// Table:DHC_StkSysGridSet
/// Input:应用程序名称,GridId,安全组id,用户id;
/// Output:     
/// Return：保存模式，模式值
ClassMethod GetSaveMod(AppName As %String, GridId As %String, CspName As %String, GroupId As %String, UserId As %String, SiteCode As %String) As %Library.String
{
    n (AppName,GridId,CspName,GroupId,UserId,SiteCode)
    s StrData=""
    s ^zdm("GetSaveMod")=AppName_"^"_GridId_"^"_CspName_"^"_GroupId_"^"_UserId_"^"_SiteCode
    ;
    q:AppName="" ""
    q:GridId="" ""
    s AppName=$$ALPHAUP^SSUTIL4(AppName)
    s AppId=$o(^DHCSSA(0,"ACODE",AppName,0))
    q:AppId="" ""
    s CspName=$$ALPHAUP^SSUTIL4(CspName)
    q:CspName="" ""
    s SaveMod=""
    s ModValue=""
    i UserId'=""  d      ;优先按用户取
    .s Chl=$o(^DHCSSA(0,"GRID",GridId,"SSUser",UserId,CspName,AppId,0))
    .i Chl'=""  d
    ..s SaveMod="SSUser"
    ..s ModValue=UserId
    i (GroupId'="")&(SaveMod="")  d  ;没有按用户定义的话，按安全组取
    .s Chl=$o(^DHCSSA(0,"GRID",GridId,"SSGroup",GroupId,CspName,AppId,0))
    .i Chl'=""  d
    ..s SaveMod="SSGroup"
    ..s ModValue=GroupId
    i (SiteCode'="")& (SaveMod="") d  ;没有按用户和安全组定义的话，按站点取
    .s Chl=$o(^DHCSSA(0,"GRID",GridId,"SITE",SiteCode,CspName,AppId,0))
    .i Chl'=""  d
    ..s SaveMod="SITE"
    ..s ModValue=SiteCode
    .
    i SaveMod'=""  d
    .s StrData=SaveMod_"^"_ModValue
    .
    q StrData
}

/// =====================================
/// Huxt 2020-09-02
/// 以下新增两个方法满足hisui
/// w ##class(web.DHCST.StkSysGridSet).HisuiGetVsfgInfo()
ClassMethod HisuiGetVsfgInfo(AppName As %String) As %Library.String
{
    n (AppName) 
    q:AppName="" ##class(PHA.COM.JSONUtils).EmptyJSON("total")
    s AppName = $$ALPHAUP^SSUTIL4(AppName)
    s AppId = $o(^DHCSSA(0,"ACODE",AppName,0))
    q:AppId="" ##class(PHA.COM.JSONUtils).EmptyJSON("total")
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT Distinct GS_GridID As GridId,GS_SaveFor As SaveMod,GS_Reference As SaveValue,GS_CspName As CspName"_
    	" FROM DHC_StkSysGridSet where GS_SSA_ParRef="_AppId
    d result.Prepare(sqlStr)
    d result.Execute()
    s colLen = result.GetColumnCount()
    s total = 0
   	s rows = []
    while (result.%Next()) {
		s oneRow = {}
		f i=1:1:colLen d
        .s outVal = result.GetData(i)
 		.s outKey = result.GetColumnName(i)
 		.d oneRow.%Set(outKey,outVal)
 		s SaveMod = result.GetDataByName("SaveMod")
 		s SaveValue = result.GetDataByName("SaveValue")
 		s oneRow.SaveModDesc = ..GetSaveModDesc(SaveMod)
 		s oneRow.SaveValueDesc = ..GetSaveValueDesc(SaveMod, SaveValue)
 		d rows.%Push(oneRow)
 		s total = total + 1
    }
    s retJson = {}
    s retJson.rows = rows
    s retJson.total = total
    q retJson.%ToJSON()
}

/// w ##class(web.DHCST.StkSysGridSet).HisuiQuery()
ClassMethod HisuiQuery(AppName As %String, GridId As %String, SaveMod As %String, SaveValue As %String, CspName As %String) As %Library.String
{
    n (AppName,GridId,SaveMod,SaveValue,CspName)
    s pid = ..NewPid()
    q:AppName="" ##class(PHA.COM.JSONUtils).EmptyJSON("total")
    s AppName = $$ALPHAUP^SSUTIL4(AppName)
    s AppId = $o(^DHCSSA(0,"ACODE",AppName,0))
    q:AppId="" ##class(PHA.COM.JSONUtils).EmptyJSON("total")
    q:GridId="" ##class(PHA.COM.JSONUtils).EmptyJSON("total")
    q:SaveMod="" ##class(PHA.COM.JSONUtils).EmptyJSON("total")
    q:SaveValue="" ##class(PHA.COM.JSONUtils).EmptyJSON("total")
    q:CspName="" ##class(PHA.COM.JSONUtils).EmptyJSON("total")
    s i = 0
    s Chl = 0
    f  s Chl = $o(^DHCSSA(0,"GRID",GridId,SaveMod,SaveValue,$$ALPHAUP^SSUTIL4(CspName),AppId,Chl)) q:Chl=""  d
    .s Rowid = AppId_"||"_Chl
    .s ColKey = $p(^DHCSSA(AppId,"GS",Chl),"^",3)
    .s Name = $p(^DHCSSA(AppId,"GS",Chl),"^",4)
    .s Header = $p(^DHCSSA(AppId,"GS",Chl),"^",5)
    .s Width = $p(^DHCSSA(AppId,"GS",Chl),"^",6)
    .s Align = $p(^DHCSSA(AppId,"GS",Chl),"^",7)
    .s Format = $p(^DHCSSA(AppId,"GS",Chl),"^",8)
    .s DataType = $p(^DHCSSA(AppId,"GS",Chl),"^",11)
    .s Hide = $p(^DHCSSA(AppId,"GS",Chl),"^",12)
    .s Nessary = $p(^DHCSSA(AppId,"GS",Chl),"^",14)
    .s SeqNo = $p(^DHCSSA(AppId,"GS",Chl),"^",16)
    .s Sort = $p(^DHCSSA(AppId,"GS",Chl),"^",22)
    .s EnterSort = $p(^DHCSSA(AppId,"GS",Chl),"^",23)
    .i EnterSort>0 s EnterSort = "Y"
    .e  s EnterSort = "N" 
    .s i = i + 1
    .s oneRow = {}
    .s oneRow.rowid = Rowid
    .s oneRow.id = ColKey
    .s oneRow.name = Name
    .s oneRow.header = Header
    .s oneRow.width = Width
    .s oneRow.align = Align
    .s oneRow.format = Format
    .s oneRow.hidden = Hide
    .s oneRow.nessary = Nessary
    .s oneRow.seqno = SeqNo
    .s oneRow.datatype = DataType
    .s oneRow.sortable = Sort
    .s oneRow.entersort = EnterSort
    .s sortArr(pid, "SeqNo", SeqNo, i) = oneRow
    q:pid="" ""
    
    // 按顺序
    s rows = []
    s total = 0
    s sub = 0
    f  s sub = $o(sortArr(pid,"SeqNo",sub)) q:sub=""  d
    .s i = 0
    .f  s i = $o(sortArr(pid,"SeqNo",sub,i)) q:i=""  d
    ..s oneRow = sortArr(pid,"SeqNo",sub,i)
    ..s total = total + 1
    ..d rows.%Push(oneRow)
    
    s retJson = {}
    s retJson.rows = rows
    s retJson.total = total
    q retJson.%ToJSON()
}

ClassMethod GetSaveModDesc(SaveMod)
{
	q:SaveMod="SITE" "站点"
	q:SaveMod="SSUser" "用户"
	q:SaveMod="SSGroup" "安全组"
	q SaveMod
}

ClassMethod GetSaveValueDesc(SaveMod, SaveValue)
{
	s SaveValueDesc = SaveValue
	i SaveMod="SSUser" d
	.s SaveValueDesc = $p($g(^SSU("SSUSR",+SaveValue)),"^",2)
	i SaveMod="SSGroup" d
	.s SaveValueDesc = $p($g(^SSU("SSGRP",+SaveValue)),"^",1)
	q SaveValueDesc
}

ClassMethod NewPid() As %String
{
  q $I(^DHCSTPID("ColSet"))
}

}
