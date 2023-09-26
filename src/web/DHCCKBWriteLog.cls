Import SQLUser

/// Author:Sunhuiyong
/// Desc:临床知识库-日志
/// Table：DHC_CKBDicLog
/// CreatDate:2020-01-18
Class web.DHCCKBWriteLog Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 日志表操作（公共方法-停用、核实、批量停用、复用、授权、新增、修改）
/// Input: 表名、记录ID、功能（stop、enable、confirm、grantAuth）、操作人、操作日期、操作时间、作用域、作用域值、IP、授权标识（acc/log）
/// Debug: d ##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBRuleData","57215","stop","11871","2021-01-21","18:12","D","2","","")
/// Table: DHC_CKBDicLog
/// w ##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBCommonDiction","6357","enable","11886","2020-12-09","15:27:41","","","222.132.155.206","log")
ClassMethod InsertDicLog(DicDr, dataDr, Function As %String, Operator As %String, OperateDate As %Date, OperateTime As %Time, Scope As %String, ScopeValue As %String, ClientIPAddress As %String, Type = "") As %String
{
	n (DicDr,dataDr,Function,Operator,OperateDate,OperateTime,Scope,ScopeValue,ClientIPAddress,Type)
	s failed=0
	q:(DicDr="")||(dataDr="")||(Function="")||(Operator="") "-11"
	//日期格式转换
	s:OperateDate'="" OperateDate=##class(web.DHCCKBCommonUtil).DateHtmlToLogical(OperateDate)
	s:OperateTime'="" OperateTime=##class(web.DHCCKBCommonUtil).TimeHtmlToLogical(OperateTime)
	s:OperateDate="" OperateDate=+$h
	s:OperateTime="" OperateTime=$p($h,",",2)
	//分类一：acc-授权
	i Type = "acc"  d 
	.s:(Scope="")||(ScopeValue="") failed=1
 	.q:(Scope="")||(ScopeValue="")
 	.s failed = ..InsertAuthLog(DicDr,dataDr,Function,Operator,OperateDate,OperateTime,Scope,ScopeValue,ClientIPAddress)
	q:failed'=0 failed
	s reference=..ifreference(dataDr)   //Function为stop时判断是否被引用  wangxin 2020-12-9
	q:(reference=1)&&(Function="stop") "-1"
	//分类二：log-停用日志(支持批量停用)
 	i (Type="log")&&((Function="stop")||(Function="enable"))  d
	.TS
	.//停用复用-不需要作用域/值
	.s failed = ..InsertStopLog(DicDr,dataDr,Function,Operator,OperateDate,OperateTime,Scope,ScopeValue,ClientIPAddress)
	.i failed'=0  d
	..TRO
	.e  d
	..TC
	//除停用复用外其他日志记录-作用域
	i (Type="log")&&(Function'="stop")&&(Function'="enable")  d
	.TS
	.s failed = ..InsertOtherLog(DicDr,dataDr,Function,Operator,OperateDate,OperateTime,Scope,ScopeValue,ClientIPAddress)
	.i failed'=0  d
	..TRO
	.e  d
	..TC
 q:failed'=0 failed
 q failed
}

/// Descript：药品编辑日志主表保存
/// 	Creater:  lidong
/// Input: listData
/// Debug: w ##class(web.DHCCKBWriteLog).InsertDicLogMain("","81646","125313","dicvalue","lastdicdatalog")
/// Table: DHC_CKBDicLog
/// w ##class(web.DHCCKBWriteLog).InsertDicLogMain("DHC_CKBDicLinkAttr","770441","edit","11863","2020-12-09","15:27:41","D","2","222.132.155.206","log")
ClassMethod InsertDicLogMain(DicDr, dataDr, Function As %String, Operator As %String, OperateDate As %Date, OperateTime As %Time, Scope As %String, ScopeValue As %String, ClientIPAddress As %String, Type = "", LogIDList = "") As %String
{
	n (DicDr,dataDr,Function,Operator,OperateDate,OperateTime,Scope,ScopeValue,ClientIPAddress,Type,LogIDList)

	s failed=0
	q:(DicDr="")||(dataDr="")||(Function="")||(Operator="") "-11"
	//日期格式转换
	s:OperateDate'="" OperateDate=##class(web.DHCCKBCommonUtil).DateHtmlToLogical(OperateDate)
	s:OperateTime'="" OperateTime=##class(web.DHCCKBCommonUtil).TimeHtmlToLogical(OperateTime)
	s:OperateDate="" OperateDate=+$h
	s:OperateTime="" OperateTime=$p($h,",",2) 
	s failed = ..InsertOtherLogMain(DicDr,dataDr,Function,Operator,OperateDate,OperateTime,Scope,ScopeValue,ClientIPAddress,.LogIDList)
	q:failed'=0 failed
 	q failed
}

/// Descript：药品编辑日志主表保存
/// 	Creater:  lidong
/// Input: listData
/// Debug: w ##class(web.DHCCKBWriteLog).InsertOtherLogMain("DHC_CKBDicLinkAttr","770441","edit","11863",65722,"55661","D","2","222.132.155.206")
/// Table: DHC_CKBDicLog 
ClassMethod InsertOtherLogMain(DicDr, dataDr, Function, Operator, OperateDate, OperateTime, Scope, ScopeValue, ClientIPAddress, LogIDList = "")
{
	n (DicDr,dataDr,Function,Operator,OperateDate,OperateTime,Scope,ScopeValue,ClientIPAddress,LogIDList)
	s failedflag=0
	s i=1
	f  s dataid=$p(dataDr,"^",i)  q:dataid=""  d
	.s i=i+1 
	.&SQL(INSERT INTO CKB_PDSS.DicLog VALUES (:DicDr,:dataid,:Function,:Operator,:OperateDate,:OperateTime,:Scope,:ScopeValue,:ClientIPAddress))
	.s:SQLCODE'=0 failedflag = 1
	.s ID = %ROWID
	.q:SQLCODE'=0  d ERRR
	.i LogIDList="" d
	..s LogIDList=ID
	.e  d
	..s LogIDList=LogIDList_"^"_ID
	
	q LogIDList
ERRR
 q SQLCODE
}

/// Descript：药品编辑日志子表保存
/// Input: listData
/// Debug: w ##class(web.DHCCKBWriteLog).InsertDicDataLog(1394053,"150","22365","0^150^39^^^^&&0^150^22365^3956^^2047496^&&0^150^22366^^1^2047496^&&0^150^22367^3933^^2047496^","lastdicdatalog","datagrid",4)
/// Table: DHC_CKBDicDataLog
/// 
ClassMethod InsertDicDataLog(ParrefID, EntyId, AttrCodeId, ListData, LastLogID, Type, Len)
{
	n (ParrefID,EntyId,AttrCodeId,ListData,LastLogID,Type,Len)
	s DicValue=""
	s ParrefID=$p(ParrefID,"^",1)
	i ((Type="datagrid")||(Type="tree")||(($p(ListData,"^",5)="")&&(Type=""))) d
	.i Len=1  d
	..s CDRowID=$p(ListData,"^",4)
	..i CDRowID'="" d
	...s DicValue=$lg($g(^CT.CKB.PDSS.CommonDictionD(CDRowID)),3)
	..e  d
	...s DicValue=$p(ListData,"^",5) 
	.i Len>1  d
	..s AttrCodeId=$p($p(ListData,"&&",1),"^",3)
	..f i=2:1:Len  d
	...s TempList=$p(ListData,"&&",i)
	...s CDRowID=$p(TempList,"^",4)
	...i CDRowID'="" d
	....s Value=$lg($g(^CT.CKB.PDSS.CommonDictionD(CDRowID)),3)
	...e  d
	....s Value=$p(TempList,"^",5) 
	...i DicValue=""  d
	....s DicValue=Value
	...e  d
	....s DicValue=DicValue_""_Value
	i ((Type="text")||(Type="textarea")) d
	.s DicValue=$p(ListData,"^",5)

	TS
	s LastLogID=$o(^CKB.PDSS.DicDataLogI("IndexEntyIDAttrID",EntyId,AttrCodeId,""),-1)
	s ret = ..InsDicDataLog(ParrefID,EntyId,AttrCodeId,DicValue,LastLogID,Type)
	i ret'=0  d
	.TRO
	e  d
	.TC
	q ret
}

/// Descript：日志子表插入
/// input：ParrefID,EntyId,AttrCodeId,DicDesc,DicValue,Type,LastLogID
/// table：DHC_CKBDicDataLog
ClassMethod InsDicDataLog(ParrefID, EntyId, AttrCodeId, DicValue, LastLogID, Type)
{
	n (ParrefID,EntyId,AttrCodeId,DicValue,LastLogID,Type)
	&sql(
	insert into CKB_PDSS.DicDataLog (DDL_Log,DDL_EntyID,DDL_AttrID,DDL_DicValue,DDL_LastDataLog)
	values (:ParrefID,:EntyId,:AttrCodeId,:DicValue,:LastLogID)
	     )
	Q SQLCODE
}

/// Desc:是否被引用
/// Debug: w ##class(web.DHCCKBWriteLog).ifreference("81302")
ClassMethod ifreference(dataDr) As %String
{
	n (dataDr)
	s reference=0
	q:dataDr=""
	s num=$d(^CT.CKB.PDSS.CommonDictionI("Link",dataDr))
	if (num>0){
		 s reference=1
		 q reference
	}
	q reference
}

/// Desc: 授权表插入操作
ClassMethod InsertAuthLog(DicDr, dataDr, Function, Operator, OperateDate, OperateTime, Scope, ScopeValue, ClientIPAddress) As %String
{
	n (DicDr,dataDr,Function,Operator,OperateDate,OperateTime,Scope,ScopeValue,ClientIPAddress)
	&SQL(
		INSERT INTO CKB_PDSS.DicLog VALUES (:DicDr,:dataDr,:Function,:Operator,:OperateDate,:OperateTime,:Scope,:ScopeValue,:ClientIPAddress)
	)
	q SQLCODE
}

/// Desc: 停用表插入操作
ClassMethod InsertStopLog(DicDr, dataDr, Function, Operator, OperateDate, OperateTime, Scope, ScopeValue, ClientIPAddress)
{
	n (DicDr,dataDr,Function,Operator,OperateDate,OperateTime,Scope,ScopeValue,ClientIPAddress)
	s failedflag=0
	s:Function'="" Scope=""
	s:Function'="" ScopeValue=""      //清空
	;i (Function'="stop")||(Function'="enable")  d 
	;.s SQLCODE = 1 
	;.d ERR
	s Available = ##class(web.DHCCKBCommon).GetAvailableData()
	i Function = "stop"  d
	.s YesFlagData = ##class(web.DHCCKBCommon).GetNoData()
	e  d
	.s YesFlagData = ##class(web.DHCCKBCommon).GetYesData()  //复用数据通过Function来区分-复用核实添加Y
	s i=1
	f  s dataid=$p(dataDr,"^",i)  q:dataid=""  d
	.s i=i+1 
	.s EnableFlag=""
	.//添加是否可用标记 Y/N -附加属性 Sunhuiyong 2020-3-25
	.&SQL(SELECT DLA_ROWID into :EnableFlag FROM CT_CKB_PDSS.DicLinkAttr WHERE DLA_Dic_Dr = :dataid AND DLA_AttrCode = :Available)
	.s params = dataid_"^"_Available_"^"_YesFlagData_"^"_YesFlagData
	.i EnableFlag=""  d
	..s flag = ##class(web.DHCCKBRangeCat).SaveUpdate(params,1)
	.e  d
	..s flag = ##class(web.DHCCKBRangeCat).UpdAttrLink(EnableFlag,params)
	.&SQL(INSERT INTO CKB_PDSS.DicLog VALUES (:DicDr,:dataid,:Function,:Operator,:OperateDate,:OperateTime,:Scope,:ScopeValue,:ClientIPAddress))
	.s:SQLCODE'=0 failedflag = 1
	.q:SQLCODE'=0  d ERRO
	q failedflag
ERRO
 q SQLCODE
}

/// Desc: 停用表插入操作
ClassMethod InsertOtherLog(DicDr, dataDr, Function, Operator, OperateDate, OperateTime, Scope, ScopeValue, ClientIPAddress)
{
	n (DicDr,dataDr,Function,Operator,OperateDate,OperateTime,Scope,ScopeValue,ClientIPAddress)
	s failedflag=0
	s i=1
	f  s dataid=$p(dataDr,"^",i)  q:dataid=""  d
	.s i=i+1 
	.&SQL(INSERT INTO CKB_PDSS.DicLog VALUES (:DicDr,:dataid,:Function,:Operator,:OperateDate,:OperateTime,:Scope,:ScopeValue,:ClientIPAddress))
	.s:SQLCODE'=0 failedflag = 1
	.q:SQLCODE'=0  d ERR
	q failedflag
ERR
 q SQLCODE
}

/// 日志表插入操作（不可用）
/// Input: 表ID、记录ID、功能、操作人、操作日期、操作时间、作用域、作用域值
/// Debug: d ##class(web.DHCCKBWriteLog).InsertLog("DHC_CKBCommonDiction","49581","stop","77655","","","","","222.132.155.206")
/// Output:
ClassMethod InsertLog(DicDr, dataDr, Function As %String, Operator As %String, OperateDate As %Date, OperateTime As %Time, Scope As %String, ScopeValue As %String, ClientIPAddress As %String) As %String
{
	//n (DicDr,dataDr,Function,Operator,OperateDate,OperateTime,Scope,ScopeValue)
	s failed=0
	q:(DicDr="")||(dataDr="")||(Function="")||(Operator="") "-11"
	s:OperateDate'="" OperateDate=##class(web.DHCCKBCommonUtil).DateHtmlToLogical(OperateDate)
	s:OperateTime'="" OperateTime=##class(web.DHCCKBCommonUtil).TimeHtmlToLogical(OperateTime)
	s:OperateDate="" OperateDate=+$h
	s:OperateTime="" OperateTime=$p($h,",",2)
	;q:(Scope="")||(ScopeValue="") "-12"
	s Available = ##class(web.DHCCKBCommon).GetAvailableData()
	s NoData = ##class(web.DHCCKBCommon).GetNoData()
	s enableflag=""
	//添加是否可用标记 Y/N -附加属性 Sunhuiyong 2020-3-25
	&SQL(
			SELECT DLA_ROWID into :enableflag FROM CT_CKB_PDSS.DicLinkAttr WHERE DLA_Dic_Dr = :dataDr AND DLA_AttrCode = :Available
		)
	;w enableflag_"^"_"shy"_"^"_+SQLCODE
	;s:SQLCODE'=0 failed = 1
	;q:SQLCODE'=0 "1"
	s params = dataDr_"^"_Available_"^"_NoData_"^"_NoData
	i enableflag=""  d
	.s flag = ##class(web.DHCCKBRangeCat).SaveUpdate(params,1)
	e  d
	.s flag = ##class(web.DHCCKBRangeCat).UpdAttrLink(enableflag,params)
	&SQL(
	INSERT INTO CKB_PDSS.DicLog VALUES (:DicDr,:dataDr,:Function,:Operator,:OperateDate,:OperateTime,:Scope,:ScopeValue,:ClientIPAddress) 
	)
	s:SQLCODE'=0 failed = 1
	q:SQLCODE'=0
    Quit failed
}

/// 日志表插入操作（不可用）多条数据 
/// Input: 表ID、记录ID、功能、操作人、操作日期、操作时间、作用域、作用域值
/// Debug: d ##class(web.DHCCKBWriteLog).InsertLogs("shy","777^888","不可用","张三","","","U","临床知识库")
/// Output:
ClassMethod InsertLogs(DicDr, dataDr, Function As %String, Operator As %String, OperateDate As %Date, OperateTime As %Time, Scope As %String, ScopeValue As %String, ClientIPAddress As %String, Type = "") As %String
{
	
	//n (DicDr,dataDr,Function,Operator,OperateDate,OperateTime,Scope,ScopeValue)
	s:OperateDate'="" OperateDate=##class(web.DHCCKBCommonUtil).DateHtmlToLogical(OperateDate)
	s:OperateTime'="" OperateTime=##class(web.DHCCKBCommonUtil).TimeHtmlToLogical(OperateTime)
	s:OperateDate="" OperateDate=+$h
	s:OperateTime="" OperateTime=$p($h,",",2)
	q:(DicDr="")||(dataDr="")||(Function="")||(Operator="") "-11"
	q:(Type="acc")&((Scope="")||(ScopeValue="")) "" //Sunhuiyong 作用域、作用域值为空	// qunianpeng 增加type:acc(授权)/log(日志),日志不需要作用域
	s dataid=""
	s DrugML=##class(web.DHCCKBCommon).GetDrugLibaryData()
	s i=1
	s failed = 0
	f  s dataid=$p(dataDr,"^",i)  q:dataid=""  d
	.s i=i+1 
	.q:($d(^CT.CKB.PDSS.CommonDictionD(dataid)))&&($lg($g(^CT.CKB.PDSS.CommonDictionD(dataid)),4)=DrugML)
	.&SQL(INSERT INTO CKB_PDSS.DicLog VALUES (:DicDr,:dataid,:Function,:Operator,:OperateDate,:OperateTime,:Scope,:ScopeValue,:ClientIPAddress))
	.s:SQLCODE'=0 failed = 1
	.q:SQLCODE'=0
    Quit failed
}

/// 日志表插入操作（授权）
/// Input: 表ID、记录ID、功能、操作人、操作日期、操作时间、作用域、作用域值
/// Debug: d ##class(web.DHCCKBWriteLog).InsertLogEmPower("DHC_CKBCommonDiction","49581","stop","77655","","","","","222.132.155.206","acc")
/// Output:
ClassMethod InsertLogEmPower(DicDr, dataDr, Function As %String, Operator As %String, OperateDate As %Date, OperateTime As %Time, Scope As %String, ScopeValue As %String, ClientIPAddress As %String, type = "") As %String
{
	//n (DicDr,dataDr,Function,Operator,OperateDate,OperateTime,Scope,ScopeValue)
	s failed=0
	q:(DicDr="")||(dataDr="")||(Function="")||(Operator="") "-11"
	s:OperateDate'="" OperateDate=##class(web.DHCCKBCommonUtil).DateHtmlToLogical(OperateDate)
	s:OperateTime'="" OperateTime=##class(web.DHCCKBCommonUtil).TimeHtmlToLogical(OperateTime)
	s:OperateDate="" OperateDate=+$h
	s:OperateTime="" OperateTime=$p($h,",",2)
	q:(Scope="")||(ScopeValue="") "-12"
	q:type'="acc" "-13"
	&SQL(
	INSERT INTO CKB_PDSS.DicLog VALUES (:DicDr,:dataDr,:Function,:Operator,:OperateDate,:OperateTime,:Scope,:ScopeValue,:ClientIPAddress) 
	)
	s:SQLCODE'=0 failed = 1
	q:SQLCODE'=0
    Quit failed
}

/// 日志表选中后加载停用表信息
/// Input: 
/// Debug: d ##class(web.DHCCKBWriteLog).GetStopDataList(20,1,"218151")
/// Output:
ClassMethod GetStopDataList(rows = 10, page = 1, DataID, table = "DHC_CKBCommonDiction", FunctionInfo = "") As %String
{
	n (rows,page,DataID,table,FunctionInfo)

	s End = page*rows
	s Start=(page-1)*rows+1
	
	s Count = 0
	w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal()
	s stopid=0
	F  s stopid=$o(^CKB.PDSS.DicLogI("DLGDataDr",DataID,stopid)) Q:stopid=""  D
	.s TmpData = $g(^CKB.PDSS.DicLogD(stopid))		
	.s Function= $lg(TmpData,4)
	.s DateTime=$zd($lg(TmpData,6),3)
	.s TimeTime=$zt($lg(TmpData,7),2)
	.s Scope= $lg(TmpData,8)
	.s ScopeValue= $lg(TmpData,9)
	.q:table'=$lg(TmpData,2) //sunhuiyong 20201110
	.s:Scope="U" ScopeValueData=$P($g(^SSU("SSUSR",+ScopeValue)),"^",2)
	.s:Scope="G" ScopeValueData=$P($g(^SSU("SSGRP",+ScopeValue)),"^",1)
	.s:Scope="L" ScopeValueData=$P($g(^CTLOC(+ScopeValue)),"^",2)
	.//s:Scope="D" ScopeValueData="DHC"
	.s:Scope="D" ScopeValueData=$p($g(^CT("HOSP",+ScopeValue)),"^",2) // ^CT("HOSP",{HOSP_RowId})
	.s:Scope="" ScopeValueData=""
	.s UserID=$lg(TmpData,5)
	.s UserName=$P($g(^SSU("SSUSR",UserID)),"^",2)
	.q:((FunctionInfo'="")&&(FunctionInfo'=Function))
	.s ListData = DataID_"^"_Function_"^"_DateTime_"^"_TimeTime_"^"_Scope_"^"_ScopeValueData_"^"_UserID_"^"_UserName_"^"_stopid
	.s Count = Count+1
	.q:(Count<Start)||(Count>End)
	.s ListString = "DataID^Function^DateTime^TimeTime^Scope^ScopeValue^UserID^UserName^ID"
	.//w $s(Count=Start:"",1:",")
	.i Count=Start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListString,ListData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListString,ListData)
	w ##class(web.DHCEMJsonCommon).getJsonEndConTotal(Count)
	q ""
}

/// Creator：      Sunhuiyong
/// CreatDate：    2020-01-20
/// Desc:          临床知识库获取系统当前时间
/// Input: "date"  "time"
/// Debug: d ##class(web.DHCCKBWriteLog).GetDateTime("date")
/// Output:
ClassMethod GetDateTime(flag As %String) As %String
{
	s datetime=""
	s:flag="date" datetime=$zd(+$h,3)
	s:flag="time" datetime=$zt($p($h,",",2))
 q datetime
}

/// Creator：      Sunhuiyong
/// CreatDate：    2020-01-20
/// Desc:          临床知识库-获取前置类型信息
/// Input: G L U D
/// Debug: d ##class(web.DHCCKBWriteLog).GetScopeValueDate("G")
/// Output:
ClassMethod GetScopeValueDate(type As %String, text, q) As %String
{
	 s HospDr = %session.Get("LOGON.HOSPID") ///不管前台给的，直接从session中获取
     i type="" w ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
     Q:type="" ""
	 if (type="G")
	 {
		w "["
		s count=0
		s phId=0
		f  s phId=$o(^SSU("SSGRP",phId)) q:phId=""  d
		.i $d(^SSU("SSGRP",phId,"HOSP")) d
		..i $d(^SSU("SSGRP",phId,"HOSP",0,"Hosp",HospDr)) d
		...s SAHospDesc=$P(^SSU("SSGRP",phId),"^",1)
		...s activeFlag=$P(^SSU("SSGRP",phId),"^",151)
		...q:(activeFlag'="")&&(activeFlag'="Y")
		...q:(SAHospDesc["停用")||(SAHospDesc["测试")||(SAHospDesc["作废")
		...s tmp=phId_"^"_SAHospDesc
		...q:(text'="")&(text'=SAHospDesc)
		...q:(q'="")&(SAHospDesc'[q)
		...s count = count+1
		...i count=1 d
		....w ##class(web.DHCEMJsonCommon).getJsonData("id^text",tmp)
		...e  d
		....w ","_##class(web.DHCEMJsonCommon).getJsonData("id^text",tmp)
		.else  d
		.i '$d(^SSU("SSGRP",phId,"HOSP",0,"Hosp")) d
		..s SAHospDesc=$P(^SSU("SSGRP",phId),"^",1)
		..s activeFlag=$P(^SSU("SSGRP",phId),"^",151)
		..q:(activeFlag'="")&&(activeFlag'="Y")
		..q:(SAHospDesc["停用")||(SAHospDesc["测试")||(SAHospDesc["作废")
		..s tmp=phId_"^"_SAHospDesc
		..q:(text'="")&(text'=SAHospDesc)
		..q:(q'="")&(SAHospDesc'[q)
		..s count = count+1
		..i count=1 d
		...w ##class(web.DHCEMJsonCommon).getJsonData("id^text",tmp)
		..e  d
		...w ","_##class(web.DHCEMJsonCommon).getJsonData("id^text",tmp)
		 w "]"
		 q ""	 

	 }elseif (type="L")
	 {
		s str=..ListLoc(text,q)	 
     }elseif(type="U")
     {
	    s str=..ListUser(text,q)	
	 }elseif(type="P")
	 {
		s str=..ListPrv(text,q)	 
	 }else
	 {
		s str=..ListDHC()
	 }
	
	 q ""
}

/// Creator：      Sunhuiyong
/// CreatDate：    2020-01-20
/// Description：  下拉列表显示
/// Table：        CT_Loc
/// Return
/// d ##class(web.DHCEMSysItmAut).ListLoc("L","")
ClassMethod ListLoc(text, q)
{
	 s HospDr = %session.Get("LOGON.HOSPID") ///不管前台给的，直接从session中获取
	 s q=$ZCONVERT(q,"U")
	 s jsonObj=##class(web.DHCAPPJsonObject).%New()
	 w "["
	 s count=0
	 s phId=0
     f  s phId=$o(^CTLOC(phId)) q:phId=""  d
	 .s Code=$P(^CTLOC(phId),"^",1)
	 .s LocDesc = $P(^CTLOC(phId),"^",2)
	 .s CTLOCHosDR=$P(^CTLOC(phId),"^",22)
	 .s ContactName=$p(^CTLOC(phId),"^",43)
	 .q:(LocDesc["停用")||(LocDesc["作废")||(LocDesc["测试")
	 .s ActiveFlag = $p(^CTLOC(phId),"^",14)
	 .q:(ActiveFlag'="")&&(ActiveFlag'="Y")
	 .s DateFrom = $p(^CTLOC(phId),"^",24)
	 .s DateTo = $p(^CTLOC(phId),"^",25)
	 .q:(DateFrom'="")&&(DateFrom>+$h)
	 .q:(DateTo'="")&&(DateTo<+$h)
	 .i (CTLOCHosDR=HospDr)!(CTLOCHosDR="")  d
	 ..s tmp=phId_"^"_LocDesc
	 ..;q:(text'="")&(text'=Code)
	 ..;q:(q'="")&(Code'[q)
	 ..Q:(LocDesc'[q)&&(ContactName'[q)
 	 ..s count = count+1
	 ..i count=1 d
	 ...w ##class(web.DHCEMJsonCommon).getJsonData("id^text",tmp)
	 ..e  d
	 ...w ","_##class(web.DHCEMJsonCommon).getJsonData("id^text",tmp)
	 w "]"
	 q ""
}

/// Creator：      Sunhuiyong
/// CreatDate：    2020-01-20
/// Description：  下拉列表显示
/// Table：        SS_User
/// Return
/// d ##class(web.DHCEMSysItmAut).ListUser()
ClassMethod ListUser(text, q)
{

	 w "["
	 s count=0
	 s phId=0
     f  s phId=$o(^SSU("SSUSR",phId)) q:phId=""  d
     .s Code=$P(^SSU("SSUSR",phId),"^",1)
     .s SSUSRHosDR=$P(^SSU("SSUSR",phId),"^",98)
     .i (SSUSRHosDR=HospDr)!(SSUSRHosDR="")  d
	 ..s Codename=$P(^SSU("SSUSR",phId),"^",2)
	 ..q:(Codename["停用")||(Codename["作废")||(Codename["测试")
	 ..s ActiveFlag = $P($G(^SSU("SSUSR",phId)),"^",19)
	 ..q:(ActiveFlag'="")&&(ActiveFlag'="Y")
	 ..s DateFrom = $P($G(^SSU("SSUSR",phId)),"^",96)
	 ..s DateTo = $P($G(^SSU("SSUSR",phId)),"^",97)
	 ..q:(DateFrom'="")&&(DateFrom>+$h)
	 ..q:(DateTo'="")&&(DateTo<+$h)
	 ..s Code=Codename_" ("_Code_")"
	 ..s tmp=phId_"^"_Code
	 ..q:(text'="")&(text'=Code)
	 ..q:(q'="")&(Code'[q)
	 ..s count = count+1
	 ..i count=1 d
	 ...w ##class(web.DHCEMJsonCommon).getJsonData("id^text",tmp)
	 ..e  d
	 ...w ","_##class(web.DHCEMJsonCommon).getJsonData("id^text",tmp)
	 w "]"
	 q ""
}

/// Creator：      Sunhuiyong
/// CreatDate：    2020-01-20
/// Description：  下拉列表显示
/// Table：        CTCarPrvTp
/// Return
/// d ##class(web.DHCEMSysItmAut).ListPrv()
ClassMethod ListPrv(text, q)
{
 	w "["
	 s count=0
	 s phId=0
     f  s phId=$o(^CT("CPT",phId)) q:phId=""  d
     .s Code=$P(^CT("CPT",phId),"^",1)
     .s Name=$P(^CT("CPT",phId),"^",2)
     .q:(Name["停用")||(Name["作废")||(Name["测试")
	 .s ActiveFlag = $P(^CT("CPT",phId),"^",3)
	 .q:(ActiveFlag'="")&&(ActiveFlag'="Y")
	 .s DateFrom = $P(^CT("CPT",phId),"^",5)
	 .s DateTo = $P(^CT("CPT",phId),"^",6)
	 .q:(DateFrom'="")&&(DateFrom>+$h)
	 .q:(DateTo'="")&&(DateTo<+$h) 
	 .s tmp=Code_"^"_Name
	 .s count = count+1
	 .i count=1 d
	 ..w ##class(web.DHCEMJsonCommon).getJsonData("id^text",tmp)
	 .e  d
	 ..w ","_##class(web.DHCEMJsonCommon).getJsonData("id^text",tmp)
	 w "]"
	 q ""
}

/// Creator：      Sunhuiyong
/// CreatDate：    2020-1-20
/// Description：  下拉列表显示
/// d ##class(web.DHCCKBWriteLog).ListDHC()
ClassMethod ListDHC()
{
	s count=0
	w "["
	s hosprowid=""
	f  s hosprowid=$o(^CT("HOSP",hosprowid)) q:hosprowid=""  d
	.q:hosprowid=0
	.s hospdesc= $p(^CT("HOSP",hosprowid),"^",2) 
	.q:(hospdesc["停用")||(hospdesc["作废")||(hospdesc["测试")
	.s DateFrom =  $p(^CT("HOSP",hosprowid),"^",9) 
	.s DateTo =  $p(^CT("HOSP",hosprowid),"^",10) 
	.q:(DateFrom'="")&&(DateFrom>+$h)
	.q:(DateTo'="")&&(DateTo<+$h) 
	.s tmp=hosprowid_"^"_hospdesc
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData("id^text",tmp)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData("id^text",tmp)
	w "]"
	q ""
	/*
	 w "["
	 w "{"
	 w """id"":"_""""_"2"_""""_","
	 w """text"":"_""""_"东华标准版数字化医院[总院]"_""""
	 w "}"
	 w "]"
	 q ""
	 */
	/*w "["
	s count=0
	s id = ##class(web.DHCCKBCommon).GetHospitalData()
	s dicID=""   f  s dicID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",id,dicID))   q:dicID=""  d
	.s dicCode= $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	.s dicDesc= $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	.s listData=dicCode_"^"_dicDesc
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData("id^text",listData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData("id^text",listData)	

	w "]"

	q ""
	*/
}

/// Description：  保存字典日志（记录更新、插入）
/// Creator：      kemaolin
/// CreatDate：    2020-03-04
/// Debug: d ##class(web.DHCCKBWriteLog).SaveDicLog()
ClassMethod SaveDicLog(dicID, LgUserID = "", LgHospID = "", function = "", ClientIPAddress = "")
{
	//表ID 记录ID 功能 操作人 操作日期 作用域 作用域值
	
	n (dicID,LgUserID,LgHospID,function,ClientIPAddress)
	s Err=0
	q:(+dicID=0)||(LgUserID="")||(function="") -1
	s DicDr="DHC_CKBCommonDiction"
	s DataId=dicID
	s Function=function
	s Operator=LgUserID
	s OperateDate=+$h
	s OperateTime=$p($h,",",2)
	s Scope="" //不存值
	s ScopeValue="" //LgHospID 不存值
	s ClientIPAddress=ClientIPAddress //需要修改为入参传入
	
	/*sufan 20202-03-27 修改为调公共方法*/
	s Err=..InsertDicLog(DicDr, DataId, Function, Operator, OperateDate, OperateTime, Scope, ScopeValue, ClientIPAddress,"log")
	 
	//&SQL(INSERT INTO CKB_PDSS.DicLog VALUES (:DicDr,:DataId,:Function,:Operator,:OperateDate,:OperateTime,:Scope,:ScopeValue,:ClientIPAddress))

    Quit Err
}

/// Debug: w ##class(web.DHCCKBWriteLog).GetStopDataValue("30","1","112","1","","")
ClassMethod GetStopDataValue(rows, page, DataID, flagValue, parDesc = "", q = "") As %String
{
	n (rows,page,DataID,flagValue,parDesc,q)
	i flagValue = 1  d
	.d ..GetStopDataByDic(rows,page,DataID,parDesc,q = "")
	e  d
	.d ..QueryStopByAuto(rows,page,DataID,parDesc,q = "")
	q ""
}

/// 获取停用列表信息-复用界面
/// Input: 
/// Debug: w ##class(web.DHCCKBWriteLog).GetStopDataByDic(100,1,"106")
/// Output:
ClassMethod GetStopDataByDic(rows, page, DataID, parDesc = "", q = "") As %String
{
	n (rows,page,DataID,parDesc,q)
	s End = page*rows
	s Start=(page-1)*rows+1
	q:DataID="" ""
	s Count = 0
	w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal()
	k SDataArray
	s id="" 		// 2020-03-06 sufan  修改 类似分类这些数据需要递归取
	for  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",DataID,id)) q:(id="")  d
	.s SDataArray(id)=id
	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",id))  d			
    ..d ..QuerySubItm(id,.SDataArray)
	
	s dicID=""   f  s dicID=$o(SDataArray(dicID))   q:dicID=""  d
	.s stopid=""
	.//过滤停用数据   入参新加：hospID, groupID, locID, userID
	.q:##class(web.DHCCKBCommon).GetStopDicDataByfunction(dicID,"stop")=0
	.s stopid=$o(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",dicID,"stop",stopid),-1)
	.s StopRowID = stopid
	.q:+stopid=0
	.s TmpData = $g(^CKB.PDSS.DicLogD(stopid))		
	.s DataDr = $lg(TmpData,3)
	.s:DataDr'="" DataDesc =$lg($g(^CT.CKB.PDSS.CommonDictionD(DataDr)),3)
	.s Function= $lg(TmpData,4)
	.q:Function'="stop"
	.s DateTime=$zd($lg(TmpData,6),3)
	.s TimeTime=$zt($lg(TmpData,7),2)
	.s Scope=$lg(TmpData,8)
	.s ScopeValue=$lg(TmpData,9)
	.s pinDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(DataDesc))
	.q:(parDesc'="")&(DataDesc'[parDesc)&(pinDesc'[$zcvt(parDesc,"U"))
	.s UserID=$lg(TmpData,5)
	.s ListData = DataID_"^"_Function_"^"_DateTime_"^"_TimeTime_"^"_Scope_"^"_ScopeValue_"^"_UserID_"^"_StopRowID_"^"_DataDesc_"^"_dicID
	.s Count = Count+1
	.q:(Count<Start)||(Count>End)
	.s ListString = "DataID^Function^DateTime^TimeTime^Scope^ScopeValue^UserID^StopRowID^DataDesc^dicID"
	.w $s(Count=Start:"",1:",")
	.w ##class(web.DHCEMJsonCommon).getJsonData(ListString,ListData)
	;d ..QueryStopByAuto(rows,page,DataID,parDesc,q)
	w ##class(web.DHCEMJsonCommon).getJsonEndConTotal(Count)
	k SDataArray
	q ""
}

/// Descript:	停用数据显示
/// Cretor:		Sunhuiyong
/// CreateDate:	2020-05-13
/// Input: 		
/// Output:		元素数组集
/// Others: 	w ##class(web.DHCCKBWriteLog).QueryStopByAuto(100,1,"106")
ClassMethod QueryStopByAuto(rows, page, DataID, parDesc = "", q = "")
{
	n (rows,page,DataID,parDesc,q)
	s End = page*rows
	s Start=(page-1)*rows+1
	q:DataID="" ""
	s Count = 0
	w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal()
	s dicID=""   f  s dicID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDic",dicID))   q:dicID=""  d
	.s stopid="" f  s stopid=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDic",dicID,stopid))   q:stopid=""  d
	..q:+stopid=0
	..q:'$d(^CT.CKB.PDSS.DicLinkAttrD(stopid))
	..q:$lg($g(^CT.CKB.PDSS.DicLinkAttrD(stopid)),4)'="25834"
	..q:##class(web.DHCCKBCommon).GetStopDicDataByfunction(dicID,"stop")=1
	..s StopRowID = "" 
	..s DataDr = "" 
	..s DataDesc = ""
	..q:dicID<=0
	..q:'$d(^CT.CKB.PDSS.CommonDictionD(dicID))
	..q:$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),4)'=DataID
	..s DataDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	..s Function= "stop" 
	..;q:Function'="stop"
	..s DateTime="" 
	..s TimeTime="" 
	..s Scope="" 
	..s ScopeValue="" 
	..s pinDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(DataDesc))
	..q:(parDesc'="")&(DataDesc'[parDesc)&(pinDesc'[$zcvt(parDesc,"U"))
	..s UserID= "" 
	..s ListData = DataID_"^"_Function_"^"_DateTime_"^"_TimeTime_"^"_Scope_"^"_ScopeValue_"^"_UserID_"^"_StopRowID_"^"_DataDesc_"^"_dicID
	..s Count = Count+1
	..q:(Count<Start)||(Count>End)
	..s ListString = "DataID^Function^DateTime^TimeTime^Scope^ScopeValue^UserID^StopRowID^DataDesc^dicID"
	..w $s(Count=Start:"",1:",")
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListString,ListData)
	w ##class(web.DHCEMJsonCommon).getJsonEndConTotal(Count)
	q ""
}

/// Descript:	递归取数据
/// Cretor:		sufan
/// CreateDate:	2020-03-26
/// Input: 		上级id，数组
/// Output:		元素数组集
/// Others: 	w ##class(web.DHCCKBWriteLog).QuerySubItm(1,.SDataArray)
ClassMethod QuerySubItm(Parref, SDataArray)
{
	n (Parref, SDataArray)
	s SubId=""
    for  s SubId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",Parref,SubId)) q:(SubId="")  d
    .q:+SubId=0
   	.s SDataArray(SubId)=SubId
   	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",SubId))  d			//取下级元素 sufan 2020-03-06
    ..d ..QuerySubItm(SubId,.SDataArray)
    Q ""
}

/// 复用按钮-复用界面
/// Input: 
/// Debug: w ##class(web.DHCCKBWriteLog).ReUseData("2577","75282","11874","2020-03-27","09:20:55","113.140.81.66")
/// Output:
ClassMethod ReUseData(StopRowID, DicID, LgUserID, OperateDate, OperateTime, ClientIPAddress) As %String
{
	n (StopRowID, DicID, LgUserID, OperateDate, OperateTime, ClientIPAddress)
	s flag=0
	q:StopRowID="" ""
	q:DicID="" ""
	TS		//sufan 2020-03-27 多表操作，加事务
	//添加是否可用标记 Y/N -附加属性 Sunhuiyong 2020-3-25
	s Available = ##class(web.DHCCKBCommon).GetAvailableData()
	s YesData = ##class(web.DHCCKBCommon).GetYesData()
	s params = DicID_"^"_Available_"^"_YesData_"^"_YesData
	s enableflag=""
	&SQL(
			SELECT DLA_ROWID into :enableflag FROM CT_CKB_PDSS.DicLinkAttr WHERE DLA_Dic_Dr = :DicID AND DLA_AttrCode = :Available
		)
	
	
	i enableflag=""  d
	.s flag = ##class(web.DHCCKBRangeCat).SaveUpdate(params,1)
	e  d
	.s flag = ##class(web.DHCCKBRangeCat).UpdAttrLink(enableflag,params)
	i flag'=0 tro
	Q:flag'=0 flag
	s DicDr = "DHC_CKBCommonDiction"
	s Function = "enable"
	s OperateDate=##class(web.DHCCKBCommonUtil).DateHtmlToLogical(OperateDate)		//2020-03-27 sufan 日期需要转换
	s OperateTime=##class(web.DHCCKBCommonUtil).TimeHtmlToLogical(OperateTime)		//2020-03-27 sufan 时间需要转换
	
	&SQL(
		INSERT INTO CKB_PDSS.DicLog VALUES (:DicDr,:DicID,:Function,:LgUserID,:OperateDate,:OperateTime,'','',:ClientIPAddress) 
		)
	//UPDATE CKB_PDSS.DicLog SET DLG_Function = 'enable' WHERE DLG_RowID = :StopRowID
	s flag=SQLCODE
	i flag'=0 tro
	Q:flag'=0 flag
	TC
	q 1
}

/// 获取作用域Combobox-作用域字典
/// Input: 
/// Debug: d ##class(web.DHCCKBWriteLog).GetScopeData()
/// Output:
ClassMethod GetScopeData() As %String
{
	//0,"Code",$$ALPHAUP({CD_Code}),{CD_Code}
	w "["
	s count=0
	s id = ##class(web.DHCCKBCommon).GetScopeData()
	s dicID=""   f  s dicID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",id,dicID))   q:dicID=""  d
	.s dicCode= $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	.s dicDesc= $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	.s listData=dicCode_"^"_dicDesc
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData("id^text",listData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData("id^text",listData)	

	w "]"

	q ""
}

/// 后台批量处理之前停用数据添加N/复用数据添加Y
/// d ##class(web.DHCCKBWriteLog).ResetFlag()
ClassMethod ResetFlag() As %String
{
	TS
	s stopID = 0
	f  s stopID=$o(^CKB.PDSS.DicLogD(stopID)) Q:stopID=""  D
	.q:'$d(^CKB.PDSS.DicLogD(stopID))
	.s listData = $g(^CKB.PDSS.DicLogD(stopID))
	.i $lg(listData,4)="stop"  d
	..s dataDr = $lg(listData,3)
	..s Available = ##class(web.DHCCKBCommon).GetAvailableData()
	..s NoData = ##class(web.DHCCKBCommon).GetNoData()
	..s enableflag=""
	..&SQL(SELECT DLA_ROWID into :enableflag FROM CT_CKB_PDSS.DicLinkAttr WHERE DLA_Dic_Dr = :dataDr AND DLA_AttrCode = :Available)
	..s params = dataDr_"^"_Available_"^"_NoData_"^"_NoData
	..i enableflag=""  d
	...s flag = ##class(web.DHCCKBRangeCat).SaveUpdate(params,1)
	..e  d
	...s flag = ##class(web.DHCCKBRangeCat).UpdAttrLink(enableflag,params)
	.i $lg(listData,4)="enable"  d
	..s dataDr = $lg(listData,3)
	..s Available = ##class(web.DHCCKBCommon).GetAvailableData()
	..s YesData = ##class(web.DHCCKBCommon).GetYesData()
	..s enableflag=""
	..&SQL(SELECT DLA_ROWID into :enableflag FROM CT_CKB_PDSS.DicLinkAttr WHERE DLA_Dic_Dr = :dataDr AND DLA_AttrCode = :Available)
	..s params = dataDr_"^"_Available_"^"_YesData_"^"_YesData
	..i enableflag=""  d
	...s flag = ##class(web.DHCCKBRangeCat).SaveUpdate(params,1)
	..e  d
	...s flag = ##class(web.DHCCKBRangeCat).UpdAttrLink(enableflag,params)
	q ""
}

/// 
/// d ##class(web.DHCCKBWriteLog).FindErrData()
ClassMethod FindErrData() As %String
{
	s writeData ="信息:"   //第一个需要+1
	s dataID = 0 f  s dataID=$o(^CT.CKB.PDSS.CommonDictionI("Parref","115",dataID)) q:dataID=""  d
	.s dataFlag = ..FindErrs(dataID)
	.i dataFlag'="N"  d
	..s writeData = writeData_"^"_$lg($g(^CT.CKB.PDSS.CommonDictionD(dataFlag-1)),2)
	q writeData
}

/// 
/// w ##class(web.DHCCKBWriteLog).FindErrs()
ClassMethod FindErrs(dicID) As %String
{
	n (dicID)
	s Flag = 0
	s writeDataID = "N"
	s dataID=0 f  s dataID=$o(^CT.CKB.PDSS.CommonDictionI("Parref","115",dataID)) q:(dataID="")||(Flag=1)  d
	.q:dataID=dicID
	.;b:dataID="84526"
	.s:($lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)_" ")=$lg($g(^CT.CKB.PDSS.CommonDictionD(dataID)),2) Flag=1
	.s SHY = ($lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)_" ")
	i Flag=1  d
	.s writeDataID = dataID
	q writeDataID
}

/// 获取停用列表信息-授权查询界面
/// Input: 
/// Debug: w ##class(web.DHCCKBWriteLog).GetgrantAuthDataByDic(100,1,"108")
/// Output:
ClassMethod GetgrantAuthDataByDic(rows, page, DataID, parDesc = "", q = "") As %String
{
	n (rows,page,DataID,parDesc,q)
	s End = page*rows
	s Start=(page-1)*rows+1
	q:DataID="" ""
	s Count = 0
	w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal()
	k SDataArray
	s id="" 		// 2020-03-06 sufan  修改 类似分类这些数据需要递归取
	for  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",DataID,id)) q:(id="")  d
	.s SDataArray(id)=id
	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",id))  d			
    ..d ..QuerySubItm(id,.SDataArray)
	
	s dicID=""   f  s dicID=$o(SDataArray(dicID))   q:dicID=""  d
	.s stopid=""
	.//过滤停用数据   入参新加：hospID, groupID, locID, userID
	.q:##class(web.DHCCKBCommon).GetStopDicDataByfunction(dicID,"stop")=0
	.s stopid=$o(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",dicID,"grantAuth",stopid),-1)
	.s StopRowID = stopid
	.q:+stopid=0
	.s TmpData = $g(^CKB.PDSS.DicLogD(stopid))		
	.s DataDr = $lg(TmpData,3) 
	.s:DataDr'="" DataDesc =$lg($g(^CT.CKB.PDSS.CommonDictionD(DataDr)),3)
	.s Function= $lg(TmpData,4) 
	.q:Function'="grantAuth"
	.s DateTime=$zd($lg(TmpData,6),3)
	.s TimeTime=$zt($lg(TmpData,7),2)
	.s Scope=$lg(TmpData,8)
	.s ScopeValueDesc=""
	.s ScopeValue=$lg(TmpData,9) 
	.b ; 111
	.s:Scope="D" ScopeValueDesc=$p($g(^CT("HOSP",ScopeValue)),"^",2)
	.s:Scope="G" ScopeValueDesc=$P(^SSU("SSGRP",ScopeValue),"^",1)
	.s pinDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(DataDesc))
	.q:(parDesc'="")&(DataDesc'[parDesc)&(pinDesc'[$zcvt(parDesc,"U"))
	.s UserID=$lg(TmpData,5)
	.s ListData = DataID_"^"_Function_"^"_DateTime_"^"_TimeTime_"^"_Scope_"^"_ScopeValue_"^"_UserID_"^"_StopRowID_"^"_DataDesc_"^"_dicID_"^"_ScopeValueDesc
	.s Count = Count+1
	.q:(Count<Start)||(Count>End)
	.s ListString = "DataID^Function^DateTime^TimeTime^Scope^ScopeValue^UserID^StopRowID^DataDesc^dicID^ScopeValueDesc"
	.w $s(Count=Start:"",1:",")
	.w ##class(web.DHCEMJsonCommon).getJsonData(ListString,ListData)
	;d ..QueryStopByAuto(rows,page,DataID,parDesc,q)
	w ##class(web.DHCEMJsonCommon).getJsonEndConTotal(Count)
	k SDataArray
	q ""
}

/// Description:	删除授权
/// Creator:		QuNianpeng 
/// CreateDate:		2019-10-12
/// Input:			logID
/// return:			0 成功 非0 失败
/// other:			
/// w ##class(web.DHCCKBWriteLog).DeleteGrantAuth()
ClassMethod DeleteGrantAuth(logID) As %String
{
	n (logID)
	
	&sql(delete from CKB_PDSS.DicLog where DLG_RowID=:logID)

	q SQLCODE
}

/// Description:	批量核对数据
/// Creator:		xww
/// CreateDate:		2021-08-23
/// Input:			
/// return:			0 成功 非0 失败
/// other:			
/// w ##class(web.DHCCKBWriteLog)InsertAllDicLog()
ClassMethod InsertAllDicLog(DicDr, params, Function As %String, Operator As %String, OperateDate As %Date, OperateTime As %Time, Scope As %String, ScopeValue As %String, ClientIPAddress As %String, Type = "") As %String
{
	n (DicDr,params,Function,Operator,OperateDate,OperateTime,Scope,ScopeValue,ClientIPAddress,Type)
	s ^TMPTEST("InsertAllDicLog")=$lb(DicDr,params,Function,Operator,OperateDate,OperateTime,Scope,ScopeValue,ClientIPAddress,Type)
	s err = 0
	TS
	s length = $l(params,"&&")
	for i=1:1:length  q:err'=0  d
	.s dataDr = $p(params,"&&",i)
	.s err = ##class(web.DHCCKBWriteLog).InsertDicLog(DicDr,dataDr,Function,Operator,OperateDate,OperateTime,Scope,ScopeValue,ClientIPAddress,Type)
	.Q:err'=0
	i err'=0 Tro
	Q:err'=0 err
	TC
	Q err
}

}
