Import sqluser

Class web.DHCSTMHUI.DHCTransferLocConf Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// 根据科室检索该科室的未配置的供应科室列表
/// Author:zhwh
/// Date:2014-01-09
/// 2014-03-10 添加科室名称过滤条件FilterDesc
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCTransferLocConf","NotTransferFrLoc","1,2,3,4","{""Description"":"""",""gUserId"":""6423"",""gLocId"":""163"",""gGroupId"":""277"",""gHospId"":""2"",""Type"":""F"",""Hospital"":""2""}")
Query NotTransferFrLoc(Params As %String) As Query(ROWSPEC = "RowId,Code,Description") [ SqlProc ]
{
}

ClassMethod NotTransferFrLocExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s PLoc=PJobj.%Get("Loc")
	s PDescription=PJobj.%Get("Description")
	s PType=PJobj.%Get("Type")
	s gHospId=PJobj.%Get("gHospId")
	s HospId=PJobj.%Get("Hospital")
	i HospId'="" s gHospId=HospId	//使用选择的医院ID
	
	//循环取补货科室的交集
	s LocLen=$l(PLoc,",")
	s FrLocId="",FrLocStr=""
	f  s FrLocId=$o(^DHCSTLOCCONF(0,"TypeFrLoc",PType,FrLocId)) q:FrLocId=""  d
	.s TrId="",len=0
	.f  s TrId=$o(^DHCSTLOCCONF(0,"TypeFrLoc",PType,FrLocId,TrId)) q:TrId=""  d
	..s TmpLocId=$p(^DHCSTLOCCONF(TrId),"^",1)
	..q:TmpLocId=""
	..q:(","_PLoc_",")'[(","_TmpLocId_",")
	..s len=len+1
	.i len=LocLen d
	..i FrLocStr="" s FrLocStr=FrLocId
	..e  s FrLocStr=FrLocStr_","_FrLocId
	
	s RowId=""
	f  s RowId=$o(^CTLOC(RowId))  q:RowId=""  d
	.q:(","_FrLocStr_",")[(","_RowId_",")
	.s ret=##class(web.DHCSTMHUI.CTLOC).LocOfHosp(RowId, gHospId)
	.q:(ret'=0)
	.s Code = $p(^CTLOC(RowId),"^",1)
	.s Description = $p(^CTLOC(RowId),"^",2)
	.s ContactName=$p(^CTLOC(RowId),"^",43)
	.q:(PDescription'="")&&($$ALPHAUP^SSUTIL4(Description)'[$$ALPHAUP^SSUTIL4(PDescription)&&($$ALPHAUP^SSUTIL4(ContactName)'[$$ALPHAUP^SSUTIL4(PDescription)))
	.s Description=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(Description)		
	.d OutPutRow3
	Quit $$$OK
OutPutRow3
	s Data=$lb(RowId,Code,Description)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 检索科室的配置供应科室的列表
/// Author: lihui
/// Date: 20191105
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCTransferLocConf","TransferLoc","{""Description"":"""",""gUserId"":""6423"",""gLocId"":""163"",""gGroupId"":""277"",""gHospId"":""2"",""Type"":""F"",""Loc"":""1,2"",""Hospital"":""2""}")
Query TransferLoc(Params As %String) As Query(ROWSPEC = "RowId,Code,Description,DefaultFlag") [ SqlProc ]
{
}

ClassMethod TransferLocExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s PLoc=PJobj.%Get("Loc")
	s PType=PJobj.%Get("Type")
	s gHospId=PJobj.%Get("gHospId")
	s HospId=PJobj.%Get("Hospital")
	i HospId'="" s gHospId=HospId	//使用选择的医院ID
	
	
	//循环取补货科室的交集
	s LocLen=$l(PLoc,",")
	s FrLocId="",FrLocStr=""
	f  s FrLocId=$o(^DHCSTLOCCONF(0,"TypeFrLoc",PType,FrLocId)) q:FrLocId=""  d
	.s TrId="",len=0,TrIdStr="",DefaultFlag="Y"
	.f  s TrId=$o(^DHCSTLOCCONF(0,"TypeFrLoc",PType,FrLocId,TrId)) q:TrId=""  d
	..s TmpLocId=$p(^DHCSTLOCCONF(TrId),"^",1)
	..q:TmpLocId=""
	..q:(","_PLoc_",")'[(","_TmpLocId_",")
	..s len=len+1
	..i TrIdStr="" s TrIdStr=TrId
	..e  s TrIdStr=TrIdStr_","_TrId
	..s TmpDefaultFlag=$p(^DHCSTLOCCONF(TrId),"^",5)
	..i (TmpDefaultFlag'="Y")&&(DefaultFlag'="N") s DefaultFlag="N"	//只要有一个不是默认就都不是默认
	.i len=LocLen d
	..s RowId=TrIdStr
	..s Code = $p(^CTLOC(FrLocId),"^",1)
	..s Description = $p(^CTLOC(FrLocId),"^",2)
	..d OutPutRowTransferLoc
	
	Quit $$$OK
OutPutRowTransferLoc
	s Data=$lb(RowId,Code,Description,DefaultFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 根据请求科室获取默认科室(供js调用) 
/// Author:lihui
/// Date:2016-06-02
/// w ##class(web.DHCSTMHUI.DHCTransferLocConf).GetDefLoc(3)
ClassMethod GetDefLoc(ReqLoc, GroupId = "") As %String
{
	n (ReqLoc,GroupId)
	q:ReqLoc="" ""
	s (STLOCid,FrLoc,FrLocdesc)=""
	s quitflag=0
	i ((GroupId'="")&&($d(^DHCSTLOCCONF(0,"STGroup",GroupId)))) d
	.f  s STLOCid=$o(^DHCSTLOCCONF(0,"STGroup",GroupId,STLOCid)) q:((STLOCid="")||(quitflag=1))  d
	..s DefFlag=$p(^DHCSTLOCCONF(STLOCid),"^",5)
	..s Type=$p(^DHCSTLOCCONF(STLOCid),"^",7)
	..q:Type'="F"
	..s:DefFlag="Y" quitflag=1
	..s:DefFlag="Y" FrLoc=$p(^DHCSTLOCCONF(STLOCid),"^",2)
	..s:FrLoc'="" FrLocdesc=$p(^CTLOC(FrLoc),"^",2),FrLocdesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(FrLocdesc)
	q:quitflag=1 FrLoc_"^"_FrLocdesc

	s STLOCid=0
	f  s STLOCid=$o(^DHCSTLOCCONF(0,"STLOC",ReqLoc,STLOCid)) q:((STLOCid="")||(quitflag=1))  d
	.s DefFlag=$p(^DHCSTLOCCONF(STLOCid),"^",5)
	.s Type=$p(^DHCSTLOCCONF(STLOCid),"^",7)
	.q:Type'="F"
	.s:DefFlag="Y" quitflag=1
	.s:DefFlag="Y" FrLoc=$p(^DHCSTLOCCONF(STLOCid),"^",2)
	.s:FrLoc'="" FrLocdesc=$p(^CTLOC(FrLoc),"^",2),FrLocdesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(FrLocdesc)
	q:quitflag=1 FrLoc_"^"_FrLocdesc

	;若仅有一个补货科室,默认
	s STLOCid=0,LocConfNum=0,FrLoc="",FrLocdesc=""
	f  s STLOCid=$o(^DHCSTLOCCONF(0,"STLOC",ReqLoc,STLOCid)) q:((STLOCid="")||(LocConfNum>1))  d
	.s Type=$p(^DHCSTLOCCONF(STLOCid),"^",7)
	.q:Type'="F"
	.s FrLocId=$p(^DHCSTLOCCONF(STLOCid),"^",2)
	.q:'$d(^CTLOC(FrLocId))
	.s FrLoc=FrLocId
	.s FrLocdesc=$p(^CTLOC(FrLoc),"^",2),FrLocdesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(FrLocdesc)
	.s LocConfNum=LocConfNum+1
	q FrLoc_"^"_FrLocdesc
}

/// 以下为HISUI新程序
/// Descript:	删除供应科室安全组授权信息
/// Creater:	zx
/// CreateDate:	2018-07-26
/// Table:		DHC_StockTransferLocConf
/// Input:		
/// Return：	消息Json串
/// w ##class(web.DHCSTMHUI.DHCPlanStatusInit).GroupRepeat("153","1")
ClassMethod Delete(Params As %String) As %Library.String
{
	n (Params,%session)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		q:RowId=""
		s len=$l(RowId,",")
		f i=1:1:len q:RtnObj.success'=0  d
		.s TmpRowId=$p(RowId,",",i)
		.s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_StockTransferLocConf",TmpRowId)
		.&sql(Delete from DHC_StockTransferLocConf where %id=:TmpRowId)
		.i SQLCODE'=0 d RtnObj.Err(-2,TmpRowId,$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
		.e  s RtnObj=##class(Log).SaveLog("DHC_StockTransferLocConf","User.DHCStockTransferLocConf","供货科室配置信息",TmpRowId,"","D",JsonStr)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:	保存供应科室安全组授权信息
/// Creater:	zx
/// CreateDate:	2018-07-26
/// Table:		DHC_StockTransferLocConf
/// Input:		 
/// Return：	消息Json串
/// w ##class(web.DHCSTMHUI.DHCTransferLocConf).SaveDefat(ListData)
ClassMethod SaveDefat(Rows) As %Library.String
{
	n (Rows,%session)
	s $ZT=..sssError()
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s sc=PJObj.%FromJSON(Rows)
	i sc'=0 d
	.s sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s ret=0
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s DefaultFlag=Obj.%Get("DefaultFlag")
		i RowId="" d RtnObj.Err(-1,"","请选择要设置的科室","",0)
		q:RtnObj.success'=0
		
		s len=$l(RowId,",")
		f i=1:1:len q:RtnObj.success'=0  d
		.s TmpRowId=$p(RowId,",",i)
		.s RtnObj=..Update(TmpRowId,DefaultFlag)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:	更新供应科室安全组授权信息
/// Creater:	zx
/// CreateDate:	2018-07-26
/// Table:		DHC_StockTransferLocConf
/// Input:		
/// Output:
/// Return：	RtnObj
ClassMethod Update(RowId As %String, DefaultFlag As %Integer) As RtnObj
{
	n (RowId,DefaultFlag,%session)
	s RtnObj=##class(RtnObj).%New()
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_StockTransferLocConf",RowId)
	&sql(Update DHC_StockTransferLocConf set STLOC_Default=:DefaultFlag where STLOC_RowId=:RowId)
	i SQLCODE'=0  d
	.s sc=RtnObj.Err(-1,RowId,$ClassName()_".Update:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RtnObj=##class(Log).SaveLog("DHC_StockTransferLocConf","User.DHCStockTransferLocConf","更新供应科室安全组授权信息",RowId,"","U","",OldJsonStr)
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// w ##class(web.DHCSTMHUI.DHCTransferLocConf).JsInsert(^templxt("JsInsert"))
ClassMethod JsInsert(Params As %String) As %Library.String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	ts
	s RtnObj=..Insert(Params)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:	保存供应科室安全组授权信息
/// Creater:	zx
/// CreateDate:	2018-07-30
/// Table:		DHC_StockTransferLocConf
/// Input:		 
/// Return：	消息Json串
ClassMethod Insert(Params As %String) As RtnObj
{
	n (Params)
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s MethodName=$CLASSNAME()_".Insert"
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s pType=PJObj.%Get("Type")		//类型F供货 T接收
	s pConLoc=PJObj.%Get("ConLoc")
	s pDatefrom=PJObj.%Get("Datefrom")
	s pDateto=PJObj.%Get("Dateto")
	s pGroupId=PJObj.%Get("GroupId")
	s pLocStr=PJObj.%Get("Loc")
	
	i ((pLocStr="")&&(pGroupId="")) q RtnObj.Err(-1,"",MethodName_":被配置项不能为空!","",0)
	
	i pConLoc="" q RtnObj.Err(-2,"",MethodName_":配置科室不能为空!","",0)
	
	s:pDatefrom'="" pDatefrom=..DH2L(pDatefrom)
	s:pDateto'="" pDateto=..DH2L(pDateto)
	
	i pLocStr'="" d
	.s len=$l(pLocStr,",")
	.f i=1:1:len q:RtnObj.success'=0  d
	..s LocId=$p(pLocStr,",",i)
	..s TrId=""
	..&sql(select %ID into :TrId from DHC_StockTransferLocConf where stloc_ctloc_dr=:LocId and stloc_frloc_dr=:pConLoc and STLOC_Group_DR=:pGroupId and STLOC_Type=:pType)
	..i SQLCODE'=0 s TrId=""
	..q:TrId'=""
	..&sql(insert into DHC_StockTransferLocConf(stloc_ctloc_dr,stloc_frloc_dr,stloc_datefrom,stloc_dateto,STLOC_Group_DR,STLOC_Type)
		values (:LocId,:pConLoc,:pDatefrom,:pDateto,:pGroupId,:pType))	
	..i SQLCODE'=0 d RtnObj.Err(-3,"",$ClassName()_".Insert:SQLCODE"_SQLCODE_":"_$g(%msg),"数据插入失败")
	e  d
	.s TrId=""
	.&sql(select %ID into :TrId from DHC_StockTransferLocConf where isnull(stloc_ctloc_dr,'')='' and stloc_frloc_dr=:pConLoc and STLOC_Group_DR=:pGroupId and STLOC_Type=:pType)
	.i SQLCODE'=0 s TrId=""
	.q:TrId'=""
	.&sql(insert into DHC_StockTransferLocConf(stloc_frloc_dr,stloc_datefrom,stloc_dateto,STLOC_Group_DR,STLOC_Type)
		values (:pConLoc,:pDatefrom,:pDateto,:pGroupId,:pType))	
	.i SQLCODE'=0 d RtnObj.Err(-3,"",$ClassName()_".Insert:SQLCODE"_SQLCODE_":"_$g(%msg),"数据插入失败")
	
	q RtnObj
}

/// Descript:	根据安全组检索该安全组未配置的供应科室列表
/// Creater:	zx
/// CreateDate:	2018-07-27
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCTransferLocConf","UnAuthorizedLoc","{""LocName"":"""",""gUserId"":""4668"",""gLocId"":""392"",""gGroupId"":""97"",""gHospId"":""2"",""Group"":""1""}")
Query UnAuthorizedLoc(Params As %String) As Query(ROWSPEC = "LocId,LocCode,LocDesc") [ SqlProc ]
{
}

ClassMethod UnAuthorizedLocExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s pGroupId=PJObj.%Get("Group") 
	s pLocName=PJObj.%Get("LocName") 
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("Hospital")
	s:pHospId="" pHospId=gHospId
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s SqlStr = "SELECT CTLOC_RowID AS Loc,CTLOC_Code AS LocCode,CTLOC_Desc AS LocDesc FROM CT_Loc"_
	 " WHERE  CTLOC_RowID not in (select stloc_frLoc_dr from DHC_StockTransferLocConf where STLOC_Group_DR="_pGroupId_" ) and CTLOC_Desc like '%"_pLocName_"%'"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{	
		s LocId = Result.Data("Loc")
		;s hospid=..sssHospId(LocId)
		;continue:(hospid'=pHospId)
		continue:(##class(web.DHCSTMHUI.CTLOC).LocOfHosp(LocId,pHospId)'=0)
		s LocCode=Result.Data("LocCode")
		s LocDesc = Result.Data("LocDesc")
		s LocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(LocDesc)
		d OutPutRow2
	}
	d Result.Close()
	Quit $$$OK
OutPutRow2
	s Data=$lb(LocId,LocCode,LocDesc)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	根据安全组检索该安全组的配置的供应科室列表
/// Creater:	zx
/// CreateDate:	2018-07-27RowId,LocId,LocCode,LocDesc,DefaultFlag
Query AuthorizedLoc(Params As %String) As Query(ROWSPEC = "RowId,LocId,LocCode,LocDesc,DefaultFlag") [ SqlProc ]
{
}

ClassMethod AuthorizedLocExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s pGroupId=PJObj.%Get("Group") 
	s pHospId=PJObj.%Get("Hospital")
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s SqlStr = "SELECT STLOC_RowId RowId, STLOC_FrLoc_DR LocId,STLOC_FrLoc_DR->CTLOC_Code AS LocCode,STLOC_FrLoc_DR->CTLOC_DESC AS LocDesc, STLOC_Default DefaultFlag FROM DHC_StockTransferLocConf WHERE STLOC_Group_DR="_pGroupId
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{	
		s RowId = Result.Data("RowId")
		s LocId = Result.Data("LocId")
		;s hospid=..sssHospId(LocId)
		;continue:(hospid'=pHospId)
		continue:(##class(web.DHCSTMHUI.CTLOC).LocOfHosp(LocId,pHospId)'=0)
		s LocCode = Result.Data("LocCode")
		s LocDesc = Result.Data("LocDesc")
		s DefaultFlag = Result.Data("DefaultFlag")
		s:DefaultFlag="" DefaultFlag="N"
		d OutPutRow
	}
	d Result.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,LocId,LocCode,LocDesc,DefaultFlag)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
