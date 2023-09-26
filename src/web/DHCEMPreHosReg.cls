Import sqluser

/// Creator: 	yangyongyao
/// CreateDate: 2019-12-07
/// Descript: 	急诊院前登记登记表
Class web.DHCEMPreHosReg Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descritp:  插入急诊院前登记信息
/// Input:     mListData-登记内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCEMPreHosReg).Insert("","^10211^^^"_$c(2)_"ArrDate^2019-12-08@ArrTime^05:24")
ClassMethod Insert(RegID As %String, mListData As %String) As %String
{
	n (RegID, mListData)
	//s ^yangyongtao("web.DHCEMPreHosReg","Insert")=mListData
	i RegID="" D
	.s RegID=..InsHosReg(mListData)
	E  D
	.s RegID=..UpdHosReg(RegID, mListData)
	Q RegID
}

/// Descritp:  插入急诊院前登记信息
/// Input:     mListData-院前登记内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCEMPreHosReg).InsHosReg("")
ClassMethod InsHosReg(mListData As %String) As %String
{
	N (mListData)
	s Err=0
	TS

	/// 插入院前登记主表
	s ListData=$p(mListData,$C(2),1)
	s RegID=..InsPreHosReg(ListData)
	i RegID<0 tro
	Q:RegID<0 RegID
	
	///是否能保存子表
	s ListData=$p(mListData,$C(2),2)
	s Err=..ValidInsRegItm(ListData)
	i Err'=0 tro
	Q:Err'=0 Err
	
	///保存子表
	s Err=..InsRegItm(RegID, ListData)
	i Err'=0 tro
	Q:Err'=0 "-11"

	TC
	Q RegID
}

/// Descritp:  修改院前登记信息
/// Input:     mListData-院前登记内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCEMPreHosReg).UpdHosReg("")
ClassMethod UpdHosReg(RegID As %String, mListData As %String) As %String
{
	N (RegID, mListData)
	s Err=0
	TS

	/// 修改院前登记主表
	s RegID=..UpdPreHosReg(RegID,mListData)
	i RegID<0 tro
	Q:RegID<0 RegID
	
	///是否能保存子表
	s ListData=$p(mListData,$C(2),2)
	s Err=..ValidInsRegItm(ListData)
	i Err'=0 tro
	Q:Err'=0 Err
	
	/// 删除相关字表内容重新插入
	s Err=..DelRegSubTable(RegID)
	i Err'=0 tro
	Q:Err'=0 "-11"
	
	s Err=..InsRegItm(RegID, ListData)
	i Err'=0 tro
	Q:Err'=0 "-12"

	TC
	Q RegID
}

/// Descritp:  插入登记主表
ClassMethod InsPreHosReg(mListData As %String) As %String
{
	n (mListData)
	s EpisodeID=$p(mListData,"^",1)   	/// 就诊ID
	s CrateUser=$p(mListData,"^",2)   	/// 登记人
	s EmParRefDr=$p(mListData,"^",3)   	/// 关联派车ID
	s CreateDate=+$H   		            /// 登记日期
	s CreateTime=$p($H,",",2)           /// 登记时间
	&SQL(Insert Into DHC_EmPreHosReg(EM_Adm_Dr,EM_RUser_Dr,EM_RDate,EM_RTime,EM_ParRef_Dr)
		values(:EpisodeID,:CrateUser,:CreateDate,:CreateTime,:EmParRefDr))
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Descritp:  修改登记主表
ClassMethod UpdPreHosReg(RegID As %String, mListData As %String) As %String
{

	s EpisodeID=$p(mListData,"^",1)   	/// 登记人
	s CrateUser=$p(mListData,"^",2)   	/// 登记人
	s EmParRefDr=$p(mListData,"^",3)   	/// 关联派车ID
	&SQL(Update DHC_EmPreHosReg Set EM_Adm_Dr=:EpisodeID,EM_RUser_Dr=:CrateUser,EM_ParRef_Dr=:EmParRefDr Where EM_RowID=:RegID)
	Q RegID
}

/// Descritp:  取消关联就诊
ClassMethod CancelRelAdm(RegID As %String) As %String
{
	s EpisodeID=""
	&SQL(Update DHC_EmPreHosReg Set EM_Adm_Dr=:EpisodeID Where EM_RowID=:RegID)
	Q SQLCODE
}

/// Descritp:判断是否能保存数据
/// w ##class(web.DHCEMPreHosReg).ValidInsRegItm("ArrDate^11/03/2020@ArrTime^11:11@@@BackDate^11/03/2020@BackTime^12:22")
ClassMethod ValidInsRegItm(ListData)
{
	n (ListData)
	s Len = $L(ListData,"@")
	s TMPData=""
	f i=1:1:Len  D
	.s ItmData=$p(ListData,"@",i)    	/// 项目列表
	.s ItemCode=$p(ItmData,"^",1)    	/// 项目代码
	.s ItemVal=$p(ItmData,"^",2)    	/// 项目值
	.q:ItemCode=""
	.s TMPData(ItemCode)=ItemVal
	
	s CurDate=+$h
	s CurTime=$p($h,",",2)
	s ArrDate=$g(TMPData("ArrDate"))
	s:ArrDate'="" ArrDate=##class(web.DHCAPPCommonUtil).DateHtmlToLogical(ArrDate)
	s:ArrDate="" ArrDate=CurDate
	s ArrTime=$g(TMPData("ArrTime"))
	s:ArrTime'="" ArrTime=$zth(ArrTime)
	s:ArrTime="" ArrTime=CurTime
	
	s BackDate=$g(TMPData("BackDate"))
	s:BackDate'="" BackDate=##class(web.DHCAPPCommonUtil).DateHtmlToLogical(BackDate)
	s:BackDate="" BackDate=CurDate
	s BackTime=$g(TMPData("BackTime"))
	s:BackTime'="" BackTime=$zth(BackTime)
	s:BackTime="" BackTime=CurTime
	

	q:(ArrDate>CurDate) "-1001"
	q:(ArrDate=CurDate)&&(ArrTime>CurTime) "-1001"
	q:(BackDate>CurDate) "-1002"
	q:(BackDate=CurDate)&&(BackTime>CurTime) "-1002"
	
	q:(ArrDate>BackDate) "-1003"
	q:(ArrDate=BackDate)&&(ArrTime>BackTime) "-1003"
	q 0
}

/// Descritp:  插入会诊子表内容
ClassMethod InsRegItm(arParref As %String, mListData As %String) As %String
{
	n (arParref, mListData)
	s Len = $L(mListData,"@")
	s quitflag=0
	F i=1:1:Len Q:quitflag'="0"  D
	.s ListData=$p(mListData,"@",i)    	/// 项目列表
	.s ItemCode=$p(ListData,"^",1)    	/// 项目代码
	.s ItemVal=$p(ListData,"^",2)    	/// 项目值
	.s arChildSub=$o(^DHCEMPHRI(arParref,"I",""),-1)+1
	.&SQL(Insert Into DHC_EmPreHosRegItem(EW_ParRef_Dr,EM_ChildSub,EM_Item_Code,EM_ItemVal)
		values(:arParref,:arChildSub,:ItemCode,:ItemVal))
	.i SQLCODE'=0 s quitflag="1"
	Q quitflag
}

/// Descript: 删除登记子表表数据
/// w ##Class(web.DHCEMPreHosReg).DelCstMasSubTable("24")
ClassMethod DelRegSubTable(RegID) As %String
{
	n (RegID)
	s SQLCODE=0
	///  登记子表
	i $o(^DHCEMPHRI(RegID,"I","")) D
	.&SQL(delete from DHC_EmPreHosRegItem where EW_ParRef_Dr=:RegID)
	Q:SQLCODE'=0 SQLCODE
	
	Q SQLCODE
}

/// Descript:  取急诊院前登记数据
/// W ##Class(web.DHCEMPreHosReg).GetPreHosRegInfo("25")
ClassMethod GetPreHosRegInfo(MaID As %String) As %String
{
	n (MaID)
	S RegID=$o(^DHCEMPHR(0,"DISAMB",MaID,""))
	Q:RegID=""
	Q:'$D(^DHCEMPHR(RegID)) ""
	s EpisodeID=$p(^DHCEMPHR(RegID),"^",1)
	s CreateUser=$p(^DHCEMPHR(RegID),"^",4)   	/// 登记人
	S:CreateUser'="" CreateUser=$p(^SSU("SSUSR",CreateUser),"^",2)
	s CreateDate=$p(^DHCEMPHR(RegID),"^",2)   	/// 登记日期
	s:CreateDate'="" CreateDate=##Class(web.DHCAPPCommonUtil).DateLogicalToHtml(CreateDate)
	s CreateTime=$p(^DHCEMPHR(RegID),"^",3)     /// 登记时间
	s:CreateTime'="" CreateTime=$zt(CreateTime,2)
	s ArrDate="",ArrTime="",DepartDate="",DepartTime=""
	s ItemData=##Class(web.DHCEMPreHosReg).GetHosRegItem(RegID)
	s ArrDate=$p(ItemData,"^",1)
	s ArrTime=$p(ItemData,"^",2)
	s DepartDate=$p(ItemData,"^",3)
	s DepartTime=$p(ItemData,"^",4)
	s BackDate=$p(ItemData,"^",5)
	s BackTime=$p(ItemData,"^",6)
	
	s ListData=EpisodeID_"^"_CreateUser_"^"_CreateDate_"^"_CreateTime_"^"_RegID_"^"_ArrDate_"^"_ArrTime_"^"_DepartDate_"^"_DepartTime_"^"_BackDate_"^"_BackTime
	s ListTitle="EpisodeID^CreateUser^CreateDate^CreateTime^RegID^ArrDate^ArrTime^DepartDate^DepartTime^BackDate^BackTime"
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	Q ""
}

/// 获取子表信息
/// W ##Class(web.DHCEMPreHosReg).GetHosRegItem("27")
ClassMethod GetHosRegItem(RegID As %String)
{
	
	n (RegID)
	s ItemData=##Class(web.DHCEMPreHosReg).GetHosRegItemNew(RegID)
	s Len =$L(ItemData,"@")
	f i=1:1:Len d
	.s ItmData = $p(ItemData,"@",i)
	.s ItmCode=$p(ItmData,"^",1)
	.s ItmValue=$p(ItmData,"^",2)
	.q:ItmCode=""
	.s TMPData("RegItemData",ItmCode)=ItmValue
	
	s ArrDate=$g(TMPData("RegItemData","ArrDate"))
	s ArrTime=$g(TMPData("RegItemData","ArrTime"))
	s DepartDate=$g(TMPData("RegItemData","DepartDate"))
	s DepartTime=$g(TMPData("RegItemData","DepartTime"))
	s BackDate=$g(TMPData("RegItemData","BackDate"))
	s BackTime=$g(TMPData("RegItemData","BackTime"))
	s:ArrDate["-" ArrDate=$zdh(ArrDate,3)
	s:ArrDate["/" ArrDate=$zdh(ArrDate,4)
	s:DepartDate["-" DepartDate=$zdh(DepartDate,3)
	s:DepartDate["/" DepartDate=$zdh(DepartDate,4)
	s:BackDate["-" BackDate=$zdh(BackDate,3)
	s:BackDate["/" BackDate=$zdh(BackDate,4)
	s:ArrDate'="" ArrDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(ArrDate)
	s:DepartDate'="" DepartDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(DepartDate)
	s:BackDate'="" BackDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(BackDate)

	s ItemStr=ArrDate_"^"_ArrTime_"^"_DepartDate_"^"_DepartTime_"^"_BackDate_"^"_BackTime
	Q ItemStr
}

/// 获取子表信息
/// W ##Class(web.DHCEMPreHosReg).GetHosRegItem("1")
ClassMethod GetHosRegItemNew(RegID As %String)
{
	n (RegID)
	s ItemStr=""
	s CH=""
	F  s CH=$o(^DHCEMPHRI(RegID,"I",CH)) Q:CH=""  D
	.s ItemData=^DHCEMPHRI(RegID,"I",CH)
	.Q:$p(ItemData,"^",1)=""
	.i ItemStr="" s ItemStr=ItemData
	.E  s ItemStr=ItemStr_"@"_ItemData
	
	Q ItemStr
}

/// Descritp:	获取系统日期时间
/// w ##Class(web.DHCEMPreHosReg).GetSystemTime()
ClassMethod GetSystemTime() As %String
{
	s SystemDate=+$H
	s SystemDate=##Class(web.DHCAPPCommonUtil).DateLogicalToHtml(SystemDate)
	s SystemTime=$zt($p($H,",",2),2)
	s ListData=SystemDate_"^"_SystemTime
	w ##class(web.DHCAPPJsonCommon).getJsonData("SystemDate^SystemTime",SystemDate_"^"_SystemTime)
	q ""
}

}
