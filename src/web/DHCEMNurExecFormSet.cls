Import SQLUSER

Class web.DHCEMNurExecFormSet Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Creator: 		qqa
/// CreateDate: 	2019-11-22
/// Descript:		执行单查询
/// w ##class(web.DHCEMNurExecFormSet).QryExecOrder("12","1","")
ClassMethod QryExecOrder(rows As %String, page As %String, Params As %String) As %String
{
	N (rows,page,Params)
	s End = page*rows
	s Start=(page-1)*rows+1
	s QueryTypeCode=$p(Params,"^",1)
	s LgHospID=$p(Params,"^",2)
	s LgHospID = ##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("DHC_EmExecFormSet",LgHospID)
	
	k TmpItemDet
	s h=0,Count=0
	s ID=""
	f  s ID=$o(^DHCEMEFS(ID)) q:ID=""  d
	.q:+ID=0
	.s Date = ^DHCEMEFS(ID)
	.s Code=$p(Date,"^",1)
	.q:(QueryTypeCode'="")&&(QueryTypeCode'=Code)
	.s Name=$p(Date,"^",2)
	.s HospID=$p(Date,"^",3)
	.q:(LgHospID'="")&&(LgHospID'=HospID)
	.s HospDesc=""
	.s:HospID'=0 HospDesc=$p($G(^CT("HOSP",HospID)),"^",2)
	.s h=h+1
	.s ListData=ID_"^"_Code_"^"_Name_"^"_HospID_"^"_HospDesc
	.s TmpItemDet(h)=ListData
	i h=0 w ##class(web.DHCEMJsonCommon).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""
	
	///转换数据为Json格式
	s ListTitle="ID^Code^Name^HospID^HospDesc"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s Index=""
	F  s Index=$o(TmpItemDet(Index)) Q:Index=""  D
	.s ListData=$g(TmpItemDet(Index))
	.s Count = Count+1
	.Q:(Count<Start)||(Count>End)
	.I Count=Start D
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.e  D
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	w ##class(web.DHCEMJsonCommon).getJsonEndSign() //输出json结尾符
	Q ""
}

/// Creator: 		qqa
/// CreateDate: 	2019-11-22
/// Descript:		执行单查询
/// w ##class(web.DHCEMNurExecFormSet).JsonListColumns(3)
ClassMethod JsonListColumns(ExecFormID = "")
{
	n (ExecFormID)
	s FSIRowID = $o(^DHCEMEFSI(0,"ExecForm",+ExecFormID,"Column",""))
	s HasValue=""
	s:FSIRowID'="" HasValue=$p(^DHCEMEFSI(FSIRowID),"^",3)
	s InHasValue=""
	s:HasValue'="" InHasValue = "#"_HasValue_"#"

	s Count=0
	w "{"
	w """NoCheckDate"":"
	w "["
	s Len = ^DHCCLNurseExec("Var",0)
	f i=1:1:Len d
	.s ColumnsItm = $g(^DHCCLNurseExec("Var",i))
	.q:ColumnsItm=""
	.s ID = i
	.q:(InHasValue'="")&&(InHasValue[("#"_ID_"#"))
	.s Name = $p(ColumnsItm,"^",1)
	.s Code = $p(ColumnsItm,"^",2)
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.s ListData=ID_"^"_Name
	.w ##class(web.DHCEMJsonCommon).getJsonData("value^text",ListData)
	w "],"
	
	s Count=0
	w """CheckDate"":"
	w "["
	s HasValueLen=$l(HasValue,"#")
	f j=1:1:HasValueLen d
	.s HasVlaueItm = $p(HasValue,"#",j)
	.q:HasVlaueItm=""
	.s ColumnsItm = $g(^DHCCLNurseExec("Var",+HasVlaueItm))
	.q:ColumnsItm=""
	.s ID = HasVlaueItm
	.s Name = $p(ColumnsItm,"^",1)
	.s Code = $p(ColumnsItm,"^",2)
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.s ListData=ID_"^"_Name
	.w ##class(web.DHCEMJsonCommon).getJsonData("value^text",ListData)
	w "]"
	w "}"
	
	q ""
}

/// Creator: 		qqa
/// CreateDate: 	2019-11-22
/// Descript:		执行单查询:授权安全组设置
/// w ##class(web.DHCEMNurExecFormSet).JsonListGroup(1)
ClassMethod JsonListGroup(ExecFormID = "")
{
	n (ExecFormID)
	s HasGroup=""
	s FSIRowID = $o(^DHCEMEFSI(0,"ExecForm",+ExecFormID,"ShowAutGroup",""))
	s:FSIRowID'="" HasGroup=$p(^DHCEMEFSI(FSIRowID),"^",3)
	s:HasGroup'="" HasGroup="#"_HasGroup_"#"
	w "{"
	s Count=0
	w """AutGroupAll"":"
	w "["
	s ID=0
	f  s ID = $o(^SSU("SSGRP",ID)) q:ID=""  d
	.s ItmData = ^SSU("SSGRP",ID)
	.s Desc = $p(ItmData,"^",1)
	.q:Desc["停用"
	.s Code = ""
	.s IsHas=""
	.q:(HasGroup'="")&&(HasGroup[("#"_ID_"#")) 
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.s ListData=ID_"^"_Desc_"^"_IsHas
	.w ##class(web.DHCEMJsonCommon).getJsonData("value^text^IsHas",ListData)
	w "],"
	s Count=0
	s CheckGroupLen = $l(HasGroup,"#")
	w """AutGroupCheck"":"
	w "["
	f i=1:1:CheckGroupLen d
	.s ID = $p(HasGroup,"#",i)
	.q:+ID=0
	.s ItmData = ^SSU("SSGRP",ID)
	.s Desc = $p(ItmData,"^",1)
	.s Code = ""
	.s IsHas=""
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.s ListData=ID_"^"_Desc_"^"_IsHas
	.w ##class(web.DHCEMJsonCommon).getJsonData("value^text^IsHas",ListData)
	w "]"
	w "}"
	q ""
}

/// Creator: 		qqa
/// CreateDate: 	2020-04-21
/// Descript:		执行单查询:打印列设置
/// w ##class(web.DHCEMNurExecFormSet).QryEpstList(1)
ClassMethod QryEpstList(mID = "")
{
	n (mID)
	s HasData=""
	s FSIRowID = $o(^DHCEMEFSI(0,"ExecForm",+mID,"PrintSetList",""))
	s:FSIRowID'="" HasData=$p(^DHCEMEFSI(FSIRowID),"^",3)
	
	w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal()
	s Count=0
	s Num=$l(HasData,"##")
	f i=1:1:Num d
	.s ItmData=$p(HasData,"##",i)
	.q:ItmData=""
	.s RowName=$p(ItmData,"|",1)
	.s RowWidth=$p(ItmData,"|",2)
	.s OrdLinkID=$p(ItmData,"|",3)
	.s OrdLinkDesc=""
	.s:OrdLinkID'="" OrdLinkDesc=$p(^DHCCLNurseExec("Var",OrdLinkID),"^",1)
	.s IsMergeRow=$p(ItmData,"|",4)
	.s IsOnlyShowMain=$p(ItmData,"|",5)
	.s CustCode=$p(ItmData,"|",6)
	.s ListData=RowName_"^"_RowWidth_"^"_OrdLinkID_"^"_OrdLinkDesc_"^"_IsMergeRow_"^"_IsOnlyShowMain_"^"_CustCode
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.w ##class(web.DHCEMJsonCommon).getJsonData("RowName^RowWidth^OrdLinkID^OrdLinkDesc^IsMergeRow^IsOnlyShowMain^CustCode",ListData)
	
	w ##class(web.DHCEMJsonCommon).getJsonEndConTotal(Count)
	q ""
}

/// Creator: 		qqa
/// CreateDate: 	2019-11-22
/// Descript:		执行单查询:属性设置
/// w ##class(web.DHCEMNurExecFormSet).JsonListPro(7,2)
ClassMethod JsonListPro(ExecFormID = "", InHospID = "")
{
	n (ExecFormID,InHospID)
	
	s HasProDis="",HasProPro="",HasProCat="",HasProStat="",HasProPhi="",HasProSpec="",HasProRecLoc=""
	s HasAllowNull=""
	
	s FSIRowID = $o(^DHCEMEFSI(0,"ExecForm",+ExecFormID,"ExecDis",""))
	s:FSIRowID'="" HasProDis=$p(^DHCEMEFSI(FSIRowID),"^",3)
	s:HasProDis'="" HasProDis="#"_HasProDis_"#"
	
	s FSIRowID = $o(^DHCEMEFSI(0,"ExecForm",+ExecFormID,"ExecPro",""))
	s:FSIRowID'="" HasProPro=$p(^DHCEMEFSI(FSIRowID),"^",3)
	s:HasProPro'="" HasProPro="#"_HasProPro_"#"
	
	s FSIRowID = $o(^DHCEMEFSI(0,"ExecForm",+ExecFormID,"ExecCat","")) 
	s:FSIRowID'="" HasProCat=$p(^DHCEMEFSI(FSIRowID),"^",3)
	s:HasProCat'="" HasProCat="#"_HasProCat_"#"
	
	s FSIRowID = $o(^DHCEMEFSI(0,"ExecForm",+ExecFormID,"ExecStat",""))
	s:FSIRowID'="" HasProStat=$p(^DHCEMEFSI(FSIRowID),"^",3)
	s:HasProStat'="" HasProStat="#"_HasProStat_"#"
	
	s FSIRowID = $o(^DHCEMEFSI(0,"ExecForm",+ExecFormID,"ExecPhi",""))
	s:FSIRowID'="" HasProPhi=$p(^DHCEMEFSI(FSIRowID),"^",3)
	s:HasProPhi'="" HasProPhi="#"_HasProPhi_"#"
	
	s FSIRowID = $o(^DHCEMEFSI(0,"ExecForm",+ExecFormID,"ExecSpec",""))
	s:FSIRowID'="" HasProSpec=$p(^DHCEMEFSI(FSIRowID),"^",3)
	s:HasProSpec'="" HasProSpec="#"_HasProSpec_"#"
	
	s FSIRowID = $o(^DHCEMEFSI(0,"ExecForm",+ExecFormID,"ExecRecLoc",""))
	s:FSIRowID'="" HasProRecLoc=$p(^DHCEMEFSI(FSIRowID),"^",3)
	s:HasProRecLoc'="" HasProRecLoc="#"_HasProRecLoc_"#"
	
	s FSIRowID = $o(^DHCEMEFSI(0,"ExecForm",+ExecFormID,"AllowNull",""))
	s:FSIRowID'="" HasAllowNull=$p(^DHCEMEFSI(FSIRowID),"^",3)
	
	s Count=0
	w "{"
	w """ExecDis"":"
	w "["
	s ID=0
	f  s ID = $o(^DHCCLNurseExec("DisposeStat",ID)) q:ID=""  d
	.s ItmData = ^DHCCLNurseExec("DisposeStat",ID)
	.s Desc = $p(ItmData,"^",1)
	.s Code = $p(ItmData,"^",2)
	.s IsHas=""
	.s:(HasProDis'="")&&(HasProDis[("#"_ID_"#")) IsHas=1
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.s ListData=ID_"^"_Desc_"^"_IsHas
	.w ##class(web.DHCEMJsonCommon).getJsonData("value^text^IsHas",ListData)
	w "],"
	
	s Count=0
	w """ExecPro"":"
	w "["
	s ID=0
	f  s ID = $o(^OECPR(ID)) q:ID=""  d
	.s ItmData = ^OECPR(ID)
	.;s ShowFlag=##class(web.DHCEMCommonUtil).GetHospShowDataFlag("CT_Loc",ID,InHospID) //hxy 2020-06-09 注释 OEC_Priority 公有
	.;q:ShowFlag'="Y" //hxy 2020-06-09 注释
	.s Desc = $p(ItmData,"^",2)
	.s Code = $p(ItmData,"^",1)
	.s IsHas=""
	.s:(HasProPro'="")&&(HasProPro[("#"_ID_"#")) IsHas=1
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.s ListData=ID_"^"_Desc_"^"_IsHas
	.w ##class(web.DHCEMJsonCommon).getJsonData("value^text^IsHas",ListData)
	w "],"
	
	s Count=0
	i $g(^DHCCLSet("Exec","OrderSubCat"))="Y" d
	.s ArcicID=0
	.f  s ArcicID=$o(^ARC("IC",ArcicID)) q:ArcicID=""  d
	..s ArciDesc = $p(^ARC("IC",ArcicID),"^",2)
	..s ShowFlag=##class(web.DHCEMCommonUtil).GetHospShowDataFlag("ARC_ItemCat",ArcicID,InHospID)
	..q:ShowFlag'="Y"
	..q:ArcicID=""
	..s OrcatDesc=$p(^OEC("ORCAT",+$p(^ARC("IC",ArcicID),"^",8)),"^",2)
	..q:OrcatDesc=""
	..s TMPData($j,"CatDesc",OrcatDesc_"-"_ArciDesc)=ArcicID
	..
	i $g(^DHCCLSet("Exec","OrderSubCat"))'="Y" d
	.s ID=0  
	.f  s ID=$o(^OEC("ORCAT",ID))  q:ID=""  d
	..s ShowFlag=##class(web.DHCEMCommonUtil).GetHospShowDataFlag("OEC_OrderCategory",ID,InHospID)
	..q:ShowFlag'="Y"
 	..s Desc=$p(^OEC("ORCAT",ID),"^",2)
 	..s TMPData($j,"CatDesc",Desc)=ID
	w """ExecCat"":"
	w "["
	s Desc=""
	f  s Desc = $o(TMPData($j,"CatDesc",Desc)) q:Desc=""  d
	.s ID = TMPData($j,"CatDesc",Desc)
	.s IsHas=""
	.s:(HasProCat'="")&&(HasProCat[("#"_ID_"#")) IsHas=1
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.s ListData=ID_"^"_Desc_"^"_IsHas
	.w ##class(web.DHCEMJsonCommon).getJsonData("value^text^IsHas",ListData)
	w "],"
	
	s Count=0
	w """ExecStat"":"
	w "["
	s ID=0
	f  s ID = $o(^OEC("OSTAT",ID)) q:ID=""  d
	.s ItmData = ^OEC("OSTAT",ID)
	.s Active = $p(ItmData,"^",3)
	.q:Active'="Y"
	.s Desc = $p(ItmData,"^",2)
	.s Code = $p(ItmData,"^",1)
	.s IsHas=""
	.s:(HasProStat'="")&&(HasProStat[("#"_ID_"#")) IsHas=1
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.s ListData=ID_"^"_Desc_"^"_IsHas
	.w ##class(web.DHCEMJsonCommon).getJsonData("value^text^IsHas",ListData)
	w "],"
	
	s Count=0
	w """ExecPhi"":"
	w "["
	s ID=0
	f  s ID = $o(^PHCIN(ID)) q:ID=""  d
	.s ItmData = ^PHCIN(ID)
	.s Desc = $p(ItmData,"^",2)
	.s Code = $p(ItmData,"^",3)
	.s IsHas=""
	.s:(HasProPhi'="")&&(HasProPhi[("#"_ID_"#")) IsHas=1
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.s ListData=ID_"^"_Desc_"^"_IsHas
	.w ##class(web.DHCEMJsonCommon).getJsonData("value^text^IsHas",ListData)
	w "],"
	
	s Count=0
	w """ExecSpec"":"
	w "["
	s RetStr=..GetGroupHospSpecCode(InHospID) //hxy 2020-07-10 原：##Class(DHCLIS.DHCCommon).getSpeciamenList()
	 s RetLen=$L(RetStr,$c(1))
	f i=1:1:RetLen d
	 .s StrInfo=$p(RetStr,$c(1),i)
	.s StrInfoLen=$L(StrInfo,$c(2))
	.;q:StrInfoLen<4 //hxy 2020-07-10 注释
	.s Code=$p(StrInfo,$c(2),1)
	.s Desc=$P(StrInfo,$c(2),2)
	.q:(Code="")||(Desc="")
	.s IsHas=""
	.s:(HasProSpec'="")&&(HasProSpec[("#"_Code_"#")) IsHas=1
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.s ListData=Code_"^"_Desc_"^"_IsHas
	.w ##class(web.DHCEMJsonCommon).getJsonData("value^text^IsHas",ListData)
	w "],"
	
	s Count=0
	w """ExecRecLoc"":"
	w "["
	s hospID=0 //hxy 2020-07-10 st
 	f  s hospID=$o(^CTLOC(0,"Hosp",hospID)) q:hospID=""  d
	 .s ID=0
 	.f  s ID=$o(^CTLOC(0,"Hosp",hospID,ID)) q:ID=""  d
	..;s ID=0
	..;f  s ID = $o(^CTLOC(ID)) q:ID=""  d //ed
	..s ItmData = ^CTLOC(ID)
	..s CurDate=+$h
	..s LocActive=$p(ItmData,"^",14)
	..q:(LocActive'="")&&(LocActive'="Y")
	..s StDate = $p(ItmData,"^",24)
	..s EndDate = $p(ItmData,"^",25)
	..q:(StDate'="")&&(CurDate<StDate)
	..q:(EndDate'="")&&(CurDate>EndDate)
	..;q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("CT_Loc",ID,InHospID)'="Y" //hxy 2020-07-10 注释 总院需要显示西院的
	..s Desc = $p(ItmData,"^",2)
	..s Code = $p(ItmData,"^",1)
	..s HospID = $p(ItmData,"^",22)
	..s HospName=$p($g(^CT("HOSP",+HospID)),"^",2)
	..s:HospName'="" Desc = HospName_"-"_Desc
	..s IsHas=""
	..s:(HasProRecLoc'="")&&(HasProRecLoc[("#"_ID_"#")) IsHas=1
	..s Count=Count+1
	..w $case(Count,1:"",:",")
	..s ListData=ID_"^"_Desc_"^"_IsHas
	..w ##class(web.DHCEMJsonCommon).getJsonData("value^text^IsHas",ListData)
	w "],"
	w """AllowNull"":"
	w """"_HasAllowNull_""""
	w "}"
	q ""
}

/// Creator: 		qqa
/// CreateDate: 	2019-11-22
/// Descript:		新门急诊护士执行配置
/// w ##class(web.DHCEMNurExecFormSet).save("1^ZSDO^注射单^2")
ClassMethod save(mParam As %String) As %String
{
	n (mParam)
	s Err=0
	ts
	f i=1:1:$L(mParam,"$$") q:Err'=0  D
	.s mdata=$p(mParam,"$$",i)
	.s Err=..isExist(mdata)   /// 重复性判断
	.q:Err'=0
	.i $p(mdata,"^",1) ="" d
	..s Err=..insert(mdata)
	.e  d
	..s Err=..update(mdata)
	tro:Err'=0
	q:Err'=0 Err
	tc
	Q Err
}

/// Creator: 		qqa
/// CreateDate: 	2019-04-16
/// Descript:		检查代码、描述是否重复
/// w ##class(web.DHCEMNurExecFormSet).isExist("^SYDO^SYDO^2")
ClassMethod isExist(mParam As %String) As %String
{
	N (mParam)
	s ID=$p(mParam,"^",1)   	///ID
	s Code=$p(mParam,"^",2)   	///代码
	s Name=$p(mParam,"^",3)   	///描述
	s HospID=$p(mParam,"^",4)   ///医院ID
	s HasFlag=0
	s FSRowID=""
	f  s FSRowID=$o(^DHCEMEFS("0","Code",Code,FSRowID)) q:(FSRowID="")  d
	.q:(ID'="")&&(ID=FSRowID)
	.s FSHospID = $p(^DHCEMEFS(FSRowID),"^",3)
	.;q:FSHospID'=HospID //hxy 2023-02-01注释 私有数据医院组间代码不能重复
	.s HasFlag=-1
	
	Q HasFlag
}

/// Creator: 		qqa
/// CreateDate: 	2019-04-16
/// Descript:		增加
/// w ##class(web.DHCMDTGroup).insert("")
ClassMethod insert(mParam As %String) As %String
{
	n (mParam)
	s Code=$p(mParam,"^",2)   	///代码
	s Name=$p(mParam,"^",3)   	///描述
	s HospID=$p(mParam,"^",4)   ///医院ID
	s DocRet=##class(DHCDoc.OPDoc.AjaxTreatPrintConfigMain).CreatNewTreatPrintConfig(Name, Code, HospID)
	
 	&SQL(INSERT INTO DHC_EmExecFormSet(FS_Code, FS_Name, FS_Hosp_Dr ) 
 		VALUES(:Code,:Name,:HospID))
 	q SQLCODE
}

/// Creator: 		qqa
/// CreateDate: 	2019-04-16
/// Descript:		更新
/// w ##class(web.DHCMDTGroup).update("")
ClassMethod update(mParam As %String) As %String
{
	n (mParam)
	s ID=$p(mParam,"^",1)   	///ID
	s Code=$p(mParam,"^",2)   	///代码
	s Name=$p(mParam,"^",3)   	///描述
	s HospID=$p(mParam,"^",4)   ///医院ID
	s DocRet=##class(DHCDoc.OPDoc.AjaxTreatPrintConfigMain).CreatNewTreatPrintConfig(Name, Code, HospID)
	&SQL(Update DHC_EmExecFormSet Set FS_Code=:Code, FS_Name=:Name, FS_Hosp_Dr=:HospID
		WHERE FS_RowID=:ID )
 	q SQLCODE
}

/// Creator: 		qqa
/// CreateDate: 	2019-04-16
/// Descript:		删除
/// w ##class(web.DHCMDTGroup).delete("1")
ClassMethod delete(ID As %String) As %String
{
	N (ID)
	&SQL(Delete From DHC_EmExecFormSet Where FS_RowID=:ID)
	Q SQLCODE
}

/// Creator: 		qqa
/// CreateDate: 	2019-04-16
/// Descript:		保存字表
/// w ##class(web.DHCMDTGroup).SaveItm("1")
ClassMethod SaveItm(ExecFormID, Params, UpdFlag = "")
{
	n (ExecFormID,Params,UpdFlag)
	q:ExecFormID="" -1
	s FSITypeCode=$p(Params,$c(2),1)
	q:FSITypeCode="" -2
	s FSIPoniter=$p(Params,$c(2),2)
	s FSIRowID = $o(^DHCEMEFSI(0,"ExecForm",+ExecFormID,FSITypeCode,""))
	s HasValue=""
	s:FSIRowID'="" HasValue=$p(^DHCEMEFSI(FSIRowID),"^",3)
	s:(HasValue'="")&&(UpdFlag'=1) FSIPoniter = HasValue_"#"_FSIPoniter
	i FSIRowID'="" d
	.&SQL(UPDATE DHC_EmExecFormSetItm SET FSI_ExecFS_Dr=:ExecFormID, FSI_TypeCode=:FSITypeCode, FSI_Poniter=:FSIPoniter 
 		WHERE FSI_RowID=:FSIRowID)
 	i FSIRowID="" d
	.&SQL(INSERT INTO DHC_EmExecFormSetItm(FSI_ExecFS_Dr, FSI_TypeCode, FSI_Poniter ) 
 		VALUES(:ExecFormID,:FSITypeCode,:FSIPoniter))
 	q SQLCODE
}

/// Creator: 		qqa
/// CreateDate: 	2019-04-16
/// Descript:		保存字表
/// w ##class(web.DHCEMNurExecFormSet).SaveItms("3","",1)
ClassMethod SaveItms(ExecFormID, AllParams, UpdFlag = "")
{
	n (ExecFormID,AllParams,UpdFlag)
	s Err=0
	TS
	s Len = $l(AllParams,"!@!")
	f i=1:1:Len q:Err'=0  d
	.s ItmParams = $p(AllParams,"!@!",i)
	.s Err = ##class(web.DHCEMNurExecFormSet).SaveItm(ExecFormID,ItmParams,UpdFlag)
	tro:Err'=0
	tc:Err=0
 	q Err
}

/// Descript:js 获取医院字典信息
/// Creator:LiangQiang
/// CreateDate:2016-04-21
/// w ##Class(web.DHCMDTCom).GetHospDs()
ClassMethod GetHospDs() As %String
{
	s count=0
	w "["
	s hosprowid=""
	f  s hosprowid=$o(^CT("HOSP",hosprowid)) q:hosprowid=""  d
	.q:hosprowid=0
	.s hospdesc=$p(^CT("HOSP",hosprowid),"^",2) 
	.s tmp=hosprowid_"^"_hospdesc
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	w "]"
	q ""
}

ClassMethod GetGrpExecList(Params)
{
	n (Params)
	s HospID = $p(Params,"^",1)
	s ID=""
	f  s ID=$o(^DHCEMEFS(ID)) q:ID=""  d
	.s FSHospID = $p(^DHCEMEFS(ID),"^",3)
	.q:(HospID'="")&&(HospID'=FSHospID)
	.s ExecFormName= $p(^DHCEMEFS(ID),"^",3)
}

/// Descript:打印列医嘱关联
/// Creator:qqa
/// CreateDate:2020-04-21
/// w ##Class(web.DHCEMNurExecFormSet).JsonOrdLink("")
ClassMethod JsonOrdLink(q = "")
{
	n (q)
	s q=$$ALPHAUP^SSUTIL4(q)
	s Count=0
	w "["
	s ID=0
	f  s ID=$o(^DHCCLNurseExec("Var",ID)) q:ID=""  d
    .s Desc=$p(^DHCCLNurseExec("Var",ID),"^",1)
    .s Code=$p(^DHCCLNurseExec("Var",ID),"^",2)
    .s AllDesc=$$ALPHAUP^SSUTIL4(Code)_Desc
    .q:(q'="")&&(AllDesc'[q)
    .s Count=Count+1
    .w $case(Count,1:"",:",")
    .s TmpDate=ID_"^"_Desc
    .w ##class(web.DHCEMJsonCommon).getJsonData("value^text",TmpDate)
    w "]"
    q ""
}

/// Creator: WuJiang  update:hxy
/// CreatDate: 2020-07-06  update:2020-07-10 
/// Description: 取组医院标本类型
/// w ##class(web.DHCEMNurExecFormSet).GetGroupHospSpecCode(2)
ClassMethod GetGroupHospSpecCode(hospDR = "") As %String
{
	   s ret=""
    q:hospDR="" ret
    s hospList=##class(%ListOfDataTypes).%New()
    s defaultHosp=$p($g(^CT("HOSP",hospDR)),"^",41)    //默认医院    20200429 lkf
    s:defaultHosp="" defaultHosp=hospDR        //如果默认医院为空，则为它本身
    d hospList.Insert(defaultHosp)
    s hospDR=""
    f {
        s hospDR=$o(^CT("HOSP",hospDR))
        q:hospDR=""
        s defHosp=$p($g(^CT("HOSP",hospDR)),"^",41)
        i (defaultHosp=defHosp)&&(hospList.Find(hospDR)="") {
            d hospList.Insert(hospDR)
        }
    }
    ;w "{rowData:["
    s hospCount=hospList.Count()
    For j = 1:1:hospCount
    {
        s hospCode=$p($g(^CT("HOSP",hospList.GetAt(j))),"^",1)
        q:hospCode=""
        Set retStr=##Class(DHCLIS.DHCCommon).getSpeciamenList(hospCode)
        Set retLen=$L(retStr,$c(1))
        for i=1:1:retLen
        {
            Set strInfo=$p(retStr,$c(1),i)
            Set strInfoLen=$L(strInfo,$c(2))
            continue:(strInfoLen<4)
            Set SPECCode=$P(strInfo,$c(2),1)
            Set SPECDesc=$P(strInfo,$c(2),2)
            continue:(SPECCode="")||(SPECDesc="")
            i SPECDesc[$c(13) s SPECDesc=$replace(SPECDesc,$c(13),"")
            s ret=ret_SPECCode_$c(2)_SPECDesc_$c(2)
            i (i'=retLen)||(j'=hospCount) s ret=ret_$c(1)
            ;w "{ID:"""_SPECCode_""",DESC:"""_SPECDesc_"""}"
            ;i (i'=retLen)||(j'=hospCount)  w ","
        }
    }
    ;w "]}"
    q ret ;q ""
}

/// Creator: 		cy
/// CreateDate: 	2022-03-30
/// Descript:		获取执行单名称
/// w ##class(web.DHCEMNurExecFormSet).getNurExecFormName("WHDO","2")
ClassMethod getNurExecFormName(Code As %String, HospID As %String) As %String
{
	N (Code,HospID,%session)
	Q:Code="" ""
	s FSName=""
	s FSRowID=""
	f  s FSRowID=$o(^DHCEMEFS("0","Code",Code,FSRowID)) q:(FSRowID="")  d
	.q:(FSName'="")
	.s FSHospID = $p(^DHCEMEFS(FSRowID),"^",3)
	.q:(HospID'="")&&(FSHospID'="")&&(FSHospID'=HospID)
	.s FSName= $p(^DHCEMEFS(FSRowID),"^",2)
	s FSName=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCEmExecFormSet","FSName","",FSName)
	Q FSName
}

}
