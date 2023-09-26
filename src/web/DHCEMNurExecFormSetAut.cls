Import SQLUSER

Class web.DHCEMNurExecFormSetAut Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Descript:js 获取安全组字典信息
/// Creator:qqa
/// CreateDate:2016-04-21
/// w ##Class(web.DHCEMNurExecFormSetAut).GetGroupJsonList(30,1,"")
ClassMethod GetGroupJsonListTable(rows As %String, page As %String, Params = "") As %String
{
	n (rows,page,Params)
	
	s End = page*rows
	s Start=(page-1)*rows+1
	s PointID=$p(Params,"^",1)
	s LgHospID=$p(Params,"^",2)
	s Type=$p(Params,"^",3)
	s Point=$p(Params,"^",4)
	s Point=$$ALPHAUP^SSUTIL4(Point)
	
	k TmpItemDet
	s h=0,Count=0
	s ID=0
	i Type="Group" d
	.f  s ID=$o(^SSU("SSGRP",ID)) q:ID=""  d
	..q:+ID=0
	..s ShowFlag=##Class(web.DHCEMCommonUtil).GetHospShowDataFlag("SS_Group",ID,LgHospID)
	..q:ShowFlag'="Y"
	..q:(PointID'="")&&(PointID'=ID)
	..s Data = ^SSU("SSGRP",ID)
	..s Code=""
	..s Name=$p(Data,"^",1)
	..s FiName=$$ALPHAUP^SSUTIL4(Name) //hxy 2022-09-29
	..q:(Point'="")&&(FiName'[Point)
	..s HospID=$p(Data,"^",3)
	..s Active=$p(Data,"^",151)
	..q:Active'="Y"
	..d SetRowData
	
	s HospGroupStr=##class(web.DHCEMNurExecFormSetAut).GetHospGroupStr("USER.SSGROUP",LgHospID)
	i Type="Loc" d
	.f  s ID=$o(^CTLOC(ID)) q:ID=""  d
	..q:+ID=0
	..q:(PointID'="")&&(PointID'=ID)
	..s Data = ^CTLOC(ID)
	..s LocHospId = $p(Data,"^",22)
	..q:("^"_HospGroupStr_"^")'[("^"_LocHospId_"^")
	..s ActiveFlag = $p(Data,"^",14) //hxy 2023-03-20 st 有效
	..q:ActiveFlag'="Y" //ed
	..s StDate = $p(Data,"^",24)
	..s EndDate = $p(Data,"^",25)
	..q:(StDate'="")&&(+$h<StDate)
	..q:(EndDate'="")&&(+$h>EndDate)
	..s Code=""
	..s Name=$p(Data,"^",2)
	..s FiName=$$ALPHAUP^SSUTIL4(Name) //hxy 2022-09-29
	..s BrevCode=$p(Data,"^",51)
	..s AllName = BrevCode_FiName
	..q:(Point'="")&&(AllName'[Point)
	..s HospID=$p(Data,"^",22)
	..d SetRowData
	
	i h=0 w ##class(web.DHCEMJsonCommon).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""
	
	///转换数据为Json格式
	s ListTitle="ID^Code^Name"
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
	q ""
	
SetRowData
	s h=h+1
	s ListData=ID_"^"_Code_"^"_Name
	s TmpItemDet(h)=ListData
}

/// w ##Class(web.DHCEMNurExecFormSetAut).GetGroupJsonListCombo("Group")
ClassMethod GetGroupJsonListCombo(q = "", Type, HospID)
{
	s q = $$ALPHAUP^SSUTIL4(q)
	s Count=0
	w "["
	
	s ID=0
	i Type="Group" d
	.f  s ID = $o(^SSU("SSGRP",ID)) q:ID=""  d
	..s ShowFlag=##Class(web.DHCEMCommonUtil).GetHospShowDataFlag("SS_Group",ID,HospID)
	..q:ShowFlag'="Y"
	..s ItmData = ^SSU("SSGRP",ID)
	..s Desc = $p(ItmData,"^",1)
	..s FiDesc=$$ALPHAUP^SSUTIL4(Desc) //hxy 2022-10-09
	..q:(q'="")&&(FiDesc'[q)
	..q:Desc["停用"
	..s Active=$p(ItmData,"^",151)
	..q:Active'="Y"
	..s Code = ""
	..s IsHas=""
	..d OutPutRow
	
	s HospGroupStr=##class(web.DHCEMNurExecFormSetAut).GetHospGroupStr("USER.SSGROUP",HospID)
	
	i Type="Loc" d
	.f  s ID = $o(^CTLOC(ID)) q:ID=""  d
	..;s ShowFlag=##Class(web.DHCEMCommonUtil).GetHospShowDataFlag("CT_Loc",ID,HospID)
	..;q:ShowFlag'="Y"
	..s ItmData = ^CTLOC(ID)
	..s LocHospId = $p(ItmData,"^",22)
	..q:("^"_HospGroupStr_"^")'[("^"_LocHospId_"^")
	..s Desc = $p(ItmData,"^",2)
	..s BrevCode=$p(ItmData,"^",51)
	..s FiDesc=$$ALPHAUP^SSUTIL4(Desc) //hxy 2022-10-09
	..s AllName = BrevCode_FiDesc
	..q:Desc["停用"
	..q:(q'="")&&(AllName'[q)
	..s StDate = $p(ItmData,"^",24)
	..s EndDate = $p(ItmData,"^",25)
	..q:(StDate'="")&&(+$h<StDate)
	..q:(EndDate'="")&&(+$h>EndDate)
	..s Code = ""
	..s IsHas=""
	..d OutPutRow
	w "]"
	q ""
OutPutRow
	s Count=Count+1
	w $case(Count,1:"",:",")
	s ListData=ID_"^"_Desc
	w ##class(web.DHCEMJsonCommon).getJsonData("value^text^IsHas",ListData)
}

/// Creator: 		qqa
/// CreateDate: 	2019-11-22
/// Descript:		执行单查询
/// w ##class(web.DHCEMNurExecFormSetAut).JsonListExecForm(22,3)
ClassMethod JsonListExecForm(GroupID = "", InHospID = "", ThisType = "Group")
{
	n (GroupID,InHospID,ThisType)
	
	s FSARowID = ##class(web.DHCEMNurExecFormSetAut).GetExsitRowID(ThisType,GroupID,InHospID)
	
	
	s HasValue="",DefValue=""
	s:FSARowID'="" HasValue=$p(^DHCEMEFSAA(FSARowID),"^",2)
	s:FSARowID'="" DefValue = $p(^DHCEMEFSAA(FSARowID),"^",3)
	s InHasValue=""
	s:HasValue'="" InHasValue = "#"_HasValue_"#"
	
	s InHospID = ##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("DHC_EmExecFormSet",InHospID)
	
	s Count=0
	w "{"
	w """NoCheckDate"":"
	w "["
	s ID=""
	f  s ID=$o(^DHCEMEFS(ID)) q:ID=""  d
	.q:+ID=0
	.s Date = ^DHCEMEFS(ID)
	.q:(InHasValue'="")&&(InHasValue[("#"_ID_"#"))
	.s Name = $p(Date,"^",2)
	.s Code = $p(Date,"^",1)
	.s HospID=$p(Date,"^",3)
	.q:(InHospID'="")&&(InHospID'=HospID)
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
	.s Date = $g(^DHCEMEFS(+HasVlaueItm))
	.q:Date=""
	.s ID = HasVlaueItm
	.s Name = $p(Date,"^",2)
	.s Code = $p(Date,"^",1)
	.s HospID=$p(Date,"^",3)
	.q:(InHospID'="")&&(InHospID'=HospID)
	.s:DefValue=ID Name=Name_"<span style='color:red'>[默认]</span>"
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.s ListData=ID_"^"_Name
	.w ##class(web.DHCEMJsonCommon).getJsonData("value^text",ListData)
	w "]"
	w "}"
	
	q ""
}

/// Creator: 		qqa
/// CreateDate: 	2019-04-16
/// Descript:		保存字表
/// w ##class(web.DHCEMNurExecFormSetAut).SaveItm("175","3","")
ClassMethod SaveItm(GroupID, Params, UpdFlag = "", InHospID, ThisType = "Group")
{
	n (GroupID,Params,UpdFlag,InHospID,ThisType)
	q:GroupID="" -1
	s FSAPoniter=$p(Params,$c(2),1)
	
	s FSARowID = ##class(web.DHCEMNurExecFormSetAut).GetExsitRowID(ThisType,GroupID,InHospID)
	
	s HasValue=""
	s:FSARowID'="" HasValue=$p(^DHCEMEFSAA(FSARowID),"^",2)
	s:(HasValue'="")&&(UpdFlag'=1) FSAPoniter = HasValue_"#"_FSAPoniter
	
	s LocID=""
	s:ThisType="Loc" LocID=GroupID,GroupID="",InHospID="" ;绝对私有,不需要医院
	
	i FSARowID'="" d
	.i FSAPoniter="" d
	..&SQL(DELETE DHC_EmExecFormSetAut WHERE FSA_RowID=:FSARowID)
	.i FSAPoniter'="" d
	..&SQL(UPDATE DHC_EmExecFormSetAut SET FSA_Group_Dr=:GroupID,FSA_Loc_Dr=:LocID,FSA_Poniter=:FSAPoniter ,FSA_Hosp_Dr=:InHospID
 		WHERE FSA_RowID=:FSARowID)
 		
 	i FSARowID="" d
	.&SQL(INSERT INTO DHC_EmExecFormSetAut(FSA_Group_Dr,FSA_Loc_Dr,FSA_Poniter ,FSA_Hosp_Dr) 
 		VALUES(:GroupID,:LocID,:FSAPoniter,:InHospID))
 	
 	q SQLCODE
}

/// Creator: 		qqa
/// CreateDate: 	2019-04-16
/// Descript:		保存字表
/// w ##class(web.DHCMDTGroup).SaveItm("1")
ClassMethod SaveItmDefExecForm(GroupID, DefExecFormDr = "", InHospID, ThisType = "Group")
{
	n (GroupID,DefExecFormDr,InHospID,ThisType)
	
	s FSARowID = ##class(web.DHCEMNurExecFormSetAut).GetExsitRowID(ThisType,GroupID,InHospID)
	
	q:FSARowID="" "-1"
	
	&SQL(UPDATE DHC_EmExecFormSetAut SET FSA_DefExecForm_Dr=:DefExecFormDr
 		WHERE FSA_RowID=:FSARowID)

 	q SQLCODE
}

/// 安全组维护是否存在记录
/// w ##class(web.DHCEMNurExecFormSetAut).GetExsitRowID("Loc","1","2")
ClassMethod GetExsitRowID(ThisType, GroupID, InHospID)
{
	s FSARowID=""
	i ThisType="Group" d
	.s ID=""
	.f  s ID=$o(^DHCEMEFSAA(0,"IndexGroup",+GroupID,ID)) q:(ID="")||(FSARowID'="")  d
	..s HospID=$p(^DHCEMEFSAA(ID),"^",4)
	..q:(InHospID'="")&&(InHospID'=HospID)
	..s FSARowID=ID
	
	i ThisType="Loc" d
	.s ID=""
	.f  s ID=$o(^DHCEMEFSAA(0,"IndexLoc",+GroupID,ID)) q:(ID="")||(FSARowID'="")  d
	..s HospID=$p(^DHCEMEFSAA(ID),"^",4)
	..;q:(InHospID'="")&&(InHospID'=HospID)		;绝对私有，不需要医院
	..s FSARowID=ID	
	q FSARowID
}

/// w ##class(web.DHCEMNurExecFormSetAut).GetHospGroupStr("USER.SSGROUP","2")
ClassMethod GetHospGroupStr(TabUserName, HospID)
{
	s Ret=""
	s ExcHospStr=""
	s TableListRowId = $o(^User.BDPTableListI("UqIndex"," "_TabUserName,""))
	i TableListRowId'="" d
	.s ExcHospSub=0
	.f  s ExcHospSub=$o(^User.BDPTableListD(TableListRowId,"ChildExceptionHosp",ExcHospSub)) q:ExcHospSub=""  d
	..s ThisData = ^User.BDPTableListD(TableListRowId,"ChildExceptionHosp",ExcHospSub)
	..s ExcHospId = $lg(ThisData,2)
	..s ExcActive = $lg(ThisData,3)
	..q:ExcActive'="Y"
	..s:ExcHospStr'="" ExcHospStr=ExcHospStr_"^"_ExcHospId
	..s:ExcHospStr="" ExcHospStr=ExcHospId
	s:ExcHospStr'="" ExcHospStr="^"_ExcHospStr_"^"
	

	s HospRowId=""
	f  s HospRowId=$o(^CT("HOSP",HospRowId)) q:HospRowId=""  d
	.s DefaultHospitalDR = $p($g(^CT("HOSP",HospRowId)),"^",41)
	.q:DefaultHospitalDR'=HospID
	.q:(ExcHospStr'="")&&(ExcHospStr[("^"_HospRowId_"^"))
	.s:Ret'="" Ret=Ret_"^"_HospRowId
	.s:Ret="" Ret=HospRowId
	s:Ret="" Ret=HospID
	q Ret
}

}
