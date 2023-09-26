Import sqluser

/// Creator: 	bianshuai
/// CreateDate: 2018-11-16
/// Descript: 	急诊分诊区日工作量记录
Class web.DHCEMTriageDailyWordLoad Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descritp:  插入急诊分诊区日工作量表
/// Input:     mListData-登记内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCEMTriageDailyWordLoad).Insert("16","^1301^夜班^2018-11-16^T1336@2#T1337@897#T1353@456#T1377@23")
ClassMethod Insert(WLID As %String, mListData As %String) As %String
{
	n (WLID, mListData)
	i WLID="" Q:..isExist(mListData) "-1"
	i WLID="" D
	.s WLID=..InsTriMas(mListData)
	E  D
	.s WLID=..UpdTriMas(WLID, mListData)
	Q WLID
}

/// Descritp:  插入急诊分诊区日工作量表
/// Input:     mListData-登记内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCEMTriageDailyWordLoad).InsTriMas("")
ClassMethod InsTriMas(mListData As %String) As %String
{
	N (mListData)
	s Err=0
	TS

	/// 插入工作量主表
	s WLID=..InsTriDailyMas(mListData)
	i WLID<0 tro
	Q:WLID<0 WLID

	/// 插入工作量子表
	s ListData=$p(mListData,"^",6)
	s Err=..InsTriItem(WLID, ListData)
	i Err'=0 tro
	Q:Err'=0 "-11"
	
	TC
	Q WLID
}

/// Descritp:  修改插入急诊分诊区日工作量表
/// Input:     mListData-登记内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCEMTriageDailyWordLoad).UpdTriMas("")
ClassMethod UpdTriMas(WLID As %String, mListData As %String) As %String
{
	N (WLID, mListData)
	s Err=0
	TS

	/// 修改工作量主表
	s WLID=..UpdTriDailyMas(WLID,mListData)
	i WLID<0 tro
	Q:WLID<0 WLID

	/// 删除相关字表内容重新插入
	s Err=..DelMasSubTable(WLID)
	i Err'=0 tro
	Q:Err'=0 "-11"
	
	/// 插入工作量子表
	s ListData=$p(mListData,"^",6)
	s Err=..InsTriItem(WLID, ListData)
	i Err'=0 tro
	Q:Err'=0 "-12"
	
	TC
	Q WLID
}

/// Descritp:  插入登记主表
ClassMethod InsTriDailyMas(mListData As %String) As %String
{
	n (mListData)
	s CrLocID=$p(mListData,"^",1)    /// 科室ID
	s CrUserID=$p(mListData,"^",2)   /// 用户ID
	s Schedule=$p(mListData,"^",3)   /// 班次
	s WrDate=$p(mListData,"^",4)     /// 填写日期
	s Type=$p(mListData,"^",5)       /// 类型
	i WrDate'="" s WrDate=##class(web.DHCAPPCommonUtil).DateHtmlToLogical(WrDate)
	s CrDate=+$H   		             /// 申请日期
	s CrTime=$p($H,",",2)            /// 申请时间
	&SQL(Insert Into DHC_EmDailyWorkLoad(EM_CrLoc_Dr,EM_CrDate,EM_CrTime,EM_CrUser_Dr,EM_Schedule,EM_WrDate,EM_Type)
		values(:CrLocID,:CrDate,:CrTime,:CrUserID,:Schedule,:WrDate,:Type))
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Descritp:  修改登记主表
ClassMethod UpdTriDailyMas(WLID As %String, mListData As %String) As %String
{
	n (WLID, mListData)
	s CrLocID=$p(mListData,"^",1)    /// 科室ID
	s Schedule=$p(mListData,"^",3)   /// 班次
	s WrDate=$p(mListData,"^",4)     /// 填写日期
	i WrDate'="" s WrDate=##class(web.DHCAPPCommonUtil).DateHtmlToLogical(WrDate)
	&SQL(Update DHC_EmDailyWorkLoad Set EM_CrLoc_Dr=:CrLocID,EM_Schedule=:Schedule,EM_WrDate=:WrDate Where EM_RowID=:WLID)
	Q WLID
}

/// Descritp:  插入工作量子表
ClassMethod InsTriItem(arParref As %String, mListData As %String) As %String
{
	n (arParref, mListData)
	s Len = $L(mListData,"#")
	s quitflag=0
	F i=1:1:Len Q:quitflag'="0"  D
	.s mdata=$p(mListData,"#",i) /// 项目列表
	.s ItemID=$p(mdata,"@",1)    /// 项目ID
	.s ItemID=$tr(ItemID,"T","")
	.s ItemVal=$p(mdata,"@",2)   /// 项目值
	.Q:ItemVal=""
	.s arChildSub=$o(^DHCEMDWL(arParref,"I",""),-1)+1
	.
	.&SQL(Insert Into DHC_EmDailyWorkLoadItem(EM_ParRef_Dr,EM_ChildSub,EM_Item_Dr,EM_ItemVal)
		values(:arParref,:arChildSub,:ItemID,:ItemVal))
	.i SQLCODE'=0 s quitflag="1"
	Q quitflag
}

/// Descript: 删除子表和关联表数据
/// w ##Class(web.DHCEMConsult).DelMasSubTable("24")
ClassMethod DelMasSubTable(WLID As %String) As %String
{
	n (WLID)
	
	s SQLCODE=0
	///  工作量子表子表
	i $o(^DHCEMDWL(WLID,"I","")) D
	.&SQL(delete from DHC_EmDailyWorkLoadItem where EM_ParRef_Dr=:WLID)
	Q:SQLCODE'=0 SQLCODE
	
	Q SQLCODE
}

/// Descript:  取急诊救护车派车管理数据
/// W ##Class(web.DHCEMDisAmbMan).GetDisAmbManInfo("")
ClassMethod GetWorkLoad(StartDate As %String, EndDate As %String) As %String
{
	n (StartDate, EndDate)
	s ListData=ListData_"^"_MaID_"^"_MtType_"^"_MtNotes
	s ListTitle="PatientID^EpisodeID^PatNo^PatName^PatSex^PatAge^PatBDay^PatDiags^PatType^PatSLv^PatLv^mradm^PatBed^BillType^LvDate^LvTime^AdmDays^PatDoc^MaID^MtType^MtNotes"
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	Q ""
}

/// Descript:	动态提取设置列
/// w ##Class(web.DHCEMTriageDailyWordLoad).JsGetTriColumns("DWL","2")
ClassMethod JsGetTriColumns(mCode As %String, HospID As %String) As %String
{
	n (mCode, HospID,%session)
	s mID=$o(^DHCEMCDT(0,"Code",$$ALPHAUP^SSUTIL4(mCode),HospID,""))
	Q:mID="" "[[]]"
	s ListTitle="field^title^width^align"
	w "[["
	s ID="",count=0
	F  s ID=$o(^DHCEMCDI(0,"Type",mID,ID)) Q:ID=""  D
	.s Code=$p(^DHCEMCDI(ID),"^",1)    /// 代码
	.s Desc=$p(^DHCEMCDI(ID),"^",2)    /// 描述
	.s Desc=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCEmConsDicItem","ECDesc","",Desc) //hxy 2022-12-15 
	.Q:$p(^DHCEMCDI(ID),"^",3)'="Y"    /// 可用标志
	.Q:$p(^DHCEMCDI(ID),"^",4)'=HospID /// 医院
	.s ListData="T"_ID_"^"_Desc_"^140^center"
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.
	w "]]"
	Q ""
}

/// Descript: 取急诊分诊工作量数据
/// w ##Class(web.DHCEMTriageDailyWordLoad).JsGetTriWorkLoadList("10","1","2019-11-25^2019-12-06^2^DWL")
ClassMethod JsGetTriWorkLoadList(rows As %String, page As %String, Params As %String) As %String
{
	n (rows,page,Params)

	s End = page*rows
	s Start=(page-1)*rows+1
	
	s StartDate=$p(Params,"^",1) /// 开始日期
	s:StartDate'="" StartDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StartDate)
	i StartDate="" s StartDate=$H-1
    s EndDate=$p(Params,"^",2)   /// 结束日期
	s:EndDate'="" EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	i EndDate="" s EndDate=$H
	s HospID=$p(Params,"^",3)    /// 医院ID
	s mCode=$p(Params,"^",4)     /// 类型代码
	s mLocID=$p(Params,"^",5)    /// 科室ID
	
	k TmpItemDet
	s mID=$o(^DHCEMCDT(0,"Code",$$ALPHAUP^SSUTIL4(mCode),HospID,""))
	
	s ListTitle="ID^CreateDate^CreateTime^Schedule^CreateUser^CrLocID^CrLoc^CrBusDate"
	s itmID=""
	f  s itmID=$o(^DHCEMCDI(0,"Type",+mID,itmID)) Q:itmID=""  D
	.Q:$p(^DHCEMCDI(itmID),"^",3)'="Y"
	.s itmCode=$p(^DHCEMCDI(itmID),"^",1)  //项目代码
	.s itmDesc=$p(^DHCEMCDI(itmID),"^",2)  //项目描述
	.s ListTitle=$s(ListTitle="":"T"_itmID,1:ListTitle_"^"_"T"_itmID)
	.
	
    s Num=0
	F dd=StartDate:1:EndDate D
	.s WLID=""
	.F  s WLID=$o(^DHCEMDWL(0,"WriteDate",dd,WLID)) Q:WLID=""  D
	..s CrLoc=""
	..s CrLocID=$p(^DHCEMDWL(WLID),"^",1)    /// 科室ID
	..Q:(mLocID'="")&(mLocID'=CrLocID)
	..Q:$p(^DHCEMDWL(WLID),"^",7)'=mCode     /// 类型
	..Q:(mCode="WWL")&(CrLocID="")
	..;Q:(mCode="DWL")&(CrLocID'="")
	..s CrHospID=$p($g(^CTLOC(+CrLocID)),"^",22) //hxy 2020-06-16 区分院区
	..q:(CrHospID'="")&&(HospID'=CrHospID)
	..s:CrLocID'="" CrLoc=$p(^CTLOC(CrLocID),"^",2)
	..s CrDate=$p(^DHCEMDWL(WLID),"^",2)     /// 创建日期
	..s:CrDate'="" CrDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(CrDate)
	..s CrTime=$p(^DHCEMDWL(WLID),"^",3)     /// 创建时间
	..s:CrTime'="" CrTime=$zt(CrTime,1)
	..s CrUser=""
	..s CrUserID=$p(^DHCEMDWL(WLID),"^",4)   /// 用户ID
	..s:CrUserID'="" CrUser=$p(^SSU("SSUSR",CrUserID),"^",2)
	..s Schedule=$p(^DHCEMDWL(WLID),"^",5)   /// 班次
	..s CrBusDate=$p(^DHCEMDWL(WLID),"^",6)     /// 业务日期
	..s:CrBusDate'="" CrBusDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(CrBusDate)
	..s CrLoc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",CrLoc) //hxy 2022-12-15 st
	..s CrUser=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",CrUser) //ed
	..s ListData=WLID_"^"_CrDate_"^"_CrTime_"^"_Schedule_"^"_CrUser_"^"_CrLocID_"^"_CrLoc_"^"_CrBusDate
	..s itmID=""
	..f  s itmID=$o(^DHCEMCDI(0,"Type",+mID,itmID)) Q:itmID=""  D
	...Q:$p(^DHCEMCDI(itmID),"^",3)'="Y"
	...s itmVal=""
	...s CH=$o(^DHCEMDWL(0,"ItemDr",itmID,WLID,""))
	...i CH'="" s itmVal=$p(^DHCEMDWL(WLID,"I",CH),"^",2)
	...s ListData=$s(ListData="":itmVal,1:ListData_"^"_itmVal)
	..s Num=Num+1
	..s TmpItemDet(Num)=ListData
	..
	
	i Num=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(Num) //输出json结尾符
	Q:Num=0 ""
	
	///转换数据为Json格式
	W ##class(web.DHCAPPJsonCommon).getJsonStartSign(Num) //输出json前缀串
	s index="",count=0
	F  s index=$o(TmpItemDet(index),-1) Q:index=""  D
	.s ListData=$g(TmpItemDet(index))
	.Q:ListData=""
	.s count = count+1
	.Q:(count<Start)||(count>End)
	.i count=Start D
	..W ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	W "]}"
	Q ""
}

/// Descript: 是否重复填写
/// w ##Class(web.DHCEMTriageDailyWordLoad).GetIfRepWrite("WWL",617,"2019-08-13","早班")
ClassMethod GetIfRepWrite(InType As %String, InWard As %String, InDate As %String, InSchedule As %String) As %String
{
	n (InType,InWard,InDate,InSchedule)
	s InDate=##Class(web.DHCEMCommonUtil).DateHtmlToLogical(InDate)
	
	s WLID="",Flag=0
	F  s WLID=$o(^DHCEMDWL(0,"WriteDate",InDate,WLID)) Q:WLID=""  D
	.s CrLocID=$p(^DHCEMDWL(WLID),"^",1)		/// 科室ID
	.s Schedule=$p(^DHCEMDWL(WLID),"^",5)		/// 班次
	.s Type=$p(^DHCEMDWL(WLID),"^",7)			/// 班次
	.I InType="WWL" D
	..I (InWard=CrLocID)&(InSchedule=Schedule) s Flag=1
	.I InType="DWL" D
	..I InSchedule=Schedule s Flag=1
	Q Flag
}

/// Descript: 获取上次的工作量信息
/// w ##Class(web.DHCEMTriageDailyWordLoad).GetLastTriWorkLoadInfo("618","WWL","WWL04",1)
ClassMethod GetLastTriWorkLoadInfo(mWardId As %String, mType As %String, mCode As %String, mHosId As %String) As %String
{
	n (mWardId,mType,mCode,mHosId)
	
	s mCodeId="",LastWLId="",rtn=""
	s:mCode'="" mCodeId=$o(^DHCEMCDI(0,"Code",$$ALPHAUP^SSUTIL4(mCode),mHosId,""))
	q:mCodeId="" rtn
	q:(mWardId="")||(mType="") rtn
	
	//获取上次的工作量主表Id
	s WLId=""
	f  s WLId=$o(^DHCEMDWL(WLId),-1) q:(+WLId=0)||(LastWLId'="")  d
	.s WardId=$p(^DHCEMDWL(WLId),"^",1)
	.q:mWardId'=WardId
	.s Type=$p(^DHCEMDWL(WLId),"^",7)
	.q:mType'=Type
	.s LastWLId=WLId
	q:+LastWLId=0 rtn
	
	//获取上次的工作量明细表数据
	s WLItmSub=$o(^DHCEMDWL(0,"ItemDr",mCodeId,LastWLId,""))
	q:+WLItmSub=0 rtn
	s rtn=$p(^DHCEMDWL(LastWLId,"I",WLItmSub),"^",2)
	q rtn
}

/// Descritp:  插入急诊分诊区日工作量表
/// Input:     mListData-登记内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCEMTriageDailyWordLoad).isExist()
ClassMethod isExist(mListData As %String) As %String
{
	n (mListData)
	s CrLocID=$p(mListData,"^",1)    /// 科室ID
	s CrUserID=$p(mListData,"^",2)   /// 用户ID
	s Schedule=$p(mListData,"^",3)   /// 班次
	s WrDate=$p(mListData,"^",4)     /// 填写日期
	s InType=$p(mListData,"^",5)     /// 类型
	s WrDate=##Class(web.DHCEMCommonUtil).DateHtmlToLogical(WrDate)
	s WLID="",Flag=0
	F  s WLID=$o(^DHCEMDWL(0,"WriteDate",WrDate,WLID)) Q:(WLID="")||(Flag'=0)  D
	.Q:$p(^DHCEMDWL(WLID),"^",1)'=CrLocID		/// 科室ID
	.Q:$p(^DHCEMDWL(WLID),"^",5)'=Schedule		/// 班次
	.Q:$p(^DHCEMDWL(WLID),"^",7)'=InType	    /// 类型
	.s Flag=1
	.
	Q Flag
}

/// 2023-03-03 22库方法
/// Descript: 取急诊分诊工作量数据
/// w ##Class(web.DHCEMTriageDailyWordLoad).JsGetTriWorkLoad("2^DWL")
ClassMethod JsGetTriWorkLoad(Params As %String) As %String
{
	n (Params)

	s HospID=$p(Params,"^",1)    /// 医院ID
	s mCode=$p(Params,"^",2)     /// 类型代码
	
	s mID=$o(^DHCEMCDT(0,"Code",$$ALPHAUP^SSUTIL4(mCode),HospID,""))
	
	s ListTitle="ID^CreateDate^CreateTime^Schedule^CreateUser^CrLocID^CrLoc^CrBusDate"
	s itmID=""
	F  s itmID=$o(^DHCEMCDI(0,"Type",+mID,itmID)) Q:itmID=""  D
	.Q:$p(^DHCEMCDI(itmID),"^",3)'="Y"
	.s itmCode=$p(^DHCEMCDI(itmID),"^",1)  //项目代码
	.s itmDesc=$p(^DHCEMCDI(itmID),"^",2)  //项目描述
	.s ListTitle=$s(ListTitle="":"T"_itmID,1:ListTitle_"^"_"T"_itmID)
	.
	
	s dd=$o(^DHCEMDWL(0,"WriteDate","")) 
	Q:dd="" ""
	s WLID=$o(^DHCEMDWL(0,"WriteDate",dd,"")) 
	Q:WLID="" ""
	s CrLoc=""
	s CrLocID=$p(^DHCEMDWL(WLID),"^",1)       /// 科室ID
	Q:$p(^DHCEMDWL(WLID),"^",7)'=mCode ""     /// 类型
	//Q:(mCode="WWL")&(CrLocID="") ""
	s CrHospID=$p($g(^CTLOC(+CrLocID)),"^",22) //hxy 2020-06-16 区分院区
	Q:(CrHospID'="")&&(HospID'=CrHospID) ""
	s:CrLocID'="" CrLoc=$p(^CTLOC(CrLocID),"^",2)
	s CrDate=$p(^DHCEMDWL(WLID),"^",2)     /// 创建日期
	s:CrDate'="" CrDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(CrDate)
	s CrTime=$p(^DHCEMDWL(WLID),"^",3)     /// 创建时间
	s:CrTime'="" CrTime=$zt(CrTime,1)
	s CrUser=""
	s CrUserID=$p(^DHCEMDWL(WLID),"^",4)   /// 用户ID
	s:CrUserID'="" CrUser=$p(^SSU("SSUSR",CrUserID),"^",2)
	s Schedule=$p(^DHCEMDWL(WLID),"^",5)   /// 班次
	s CrBusDate=$p(^DHCEMDWL(WLID),"^",6)     /// 业务日期
	s:CrBusDate'="" CrBusDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(CrBusDate)
	s ListData=WLID_"^"_CrDate_"^"_CrTime_"^"_Schedule_"^"_CrUser_"^"_CrLocID_"^"_CrLoc_"^"_CrBusDate
	s itmID=""
	F  s itmID=$o(^DHCEMCDI(0,"Type",+mID,itmID)) Q:itmID=""  D
	.Q:$p(^DHCEMCDI(itmID),"^",3)'="Y"
	.s itmVal=""
	.s CH=$o(^DHCEMDWL(0,"ItemDr",itmID,WLID,""))
	.i CH'="" s itmVal=$p(^DHCEMDWL(WLID,"I",CH),"^",2)
	.s ListData=$s(ListData="":itmVal,1:ListData_"^"_itmVal)
	w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	Q ""
}

Storage Default
{
<Data name="DHCEMTriageDailyWordLoadDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEMTriageDailyWordLoadD</DataLocation>
<DefaultData>DHCEMTriageDailyWordLoadDefaultData</DefaultData>
<IdLocation>^web.DHCEMTriageDailyWordLoadD</IdLocation>
<IndexLocation>^web.DHCEMTriageDailyWordLoadI</IndexLocation>
<StreamLocation>^web.DHCEMTriageDailyWordLoadS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
