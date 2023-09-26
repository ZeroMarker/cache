Import sqluser

Class web.DHCEMConsWorkFlow Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: 		qqa
/// CreateDate: 	2019-11-22
/// Descript:		执行单查询
/// w ##class(web.DHCEMConsWorkFlow).QryListMain("12","1","")
ClassMethod QryListMain(rows As %String, page As %String, Params As %String) As %String
{
	N (rows,page,Params)
	s End = page*rows
	s Start=(page-1)*rows+1
	s InCode=$p(Params,"^",1)
	s InDesc=$p(Params,"^",2)
	s InHospID=$p(Params,"^",3)
	s InHospID=##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("DHC_EmConsWorkFlow",InHospID)
	
	k TmpItemDet
	s h=0,Count=0
	s ID=""
	f  s ID=$o(^DHCEMCONWF(ID)) q:ID=""  d
	.q:+ID=0
	.s Date = ^DHCEMCONWF(ID)
	.s Code=$p(Date,"^",1)
	.s Desc=$p(Date,"^",2)
	.s HospID=$p(Date,"^",3)
	.q:(InHospID'="")&&(InHospID'=HospID)
	.s HospDesc=""
	.s:HospID'="" HospDesc=$p(^CT("HOSP",HospID),"^",2)
	.q:(InCode'="")&&(Code'[InCode)
	.q:(InDesc'="")&&(Desc'[InDesc)
	
	.s h=h+1
	.s ListData=ID_"^"_Code_"^"_Desc_"^"_HospID_"^"_HospDesc
	.s TmpItemDet(h)=ListData
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""
	
	///转换数据为Json格式
	s ListTitle="ID^Code^Desc^HospID^HospDesc"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s Index=""
	F  s Index=$o(TmpItemDet(Index)) Q:Index=""  D
	.s ListData=$g(TmpItemDet(Index))
	.s Count = Count+1
	.Q:(Count<Start)||(Count>End)
	.I Count=Start D
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  D
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	Q ""
}

/// Description: 保存[工作流项目定义]
/// Creator:     QQA
/// CreateDate:  2019-12-09
/// Table:		 DHC_EmConsWorkFlow
/// Input:  	 DataList:以字符"^"分割,格式为:id^代码^描述^类型描述^是否可用
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCEMConsWorkFlow).save("^111^222")
ClassMethod save(mParam As %String) As %String
{
	n (mParam)
	s Err=0
	F i=1:1:$L(mParam,"$$") Q:Err'=0  D
	.s mdata=$p(mParam,"$$",i)
	.s Err=..isExist(mdata)   /// 重复性判断
	.Q:Err'=0
	.i $p(mdata,"^",1) ="" d
	..s Err=..insert(mdata)
	.e  d
	..s Err=..update(mdata)
	Q Err
}

/// Creator: 		qqa
/// CreateDate: 	2019-04-16
/// Descript:		检查代码、描述是否重复^06^测试2^2
/// w ##class(web.DHCEMConsWorkFlow).isExist("^06^测试2^2")
ClassMethod isExist(mParam As %String) As %String
{
	N (mParam)
	s ID=$p(mParam,"^",1)   	///ID
	s Code=$p(mParam,"^",2)   	///代码
	s Desc=$p(mParam,"^",3)   	///描述
	s HospID=$p(mParam,"^",4)  	///医院
	s IsHas=0
	
	s RowID=""
	f  s RowID=$o(^DHCEMCONWF(0,"IndexCode",Code,RowID)) q:(RowID="")||(IsHas=1)  d
	.s RowHospID=$p(^DHCEMCONWF(RowID),"^",3)
	.;q:HospID'=RowHospID
	.q:ID=RowID
	.
	.s IsHas=1
	Q IsHas
}

/// Creator: 		qqa
/// CreateDate: 	2019-04-16
/// Descript:		增加
/// w ##class(web.DHCMDTGroup).insert("")
ClassMethod insert(mParam As %String) As %String
{
	n (mParam)
	s Code=$p(mParam,"^",2)   	///代码
	s Desc=$p(mParam,"^",3)   	///描述
	s HospID=$p(mParam,"^",4)   ///医院
	
 	&SQL(INSERT INTO DHC_EmConsWorkFlow(EC_Code, EC_Desc,EC_Hosp_Dr) 
 		VALUES(:Code,:Desc,:HospID))
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
	s Desc=$p(mParam,"^",3)   	///描述
	s HospID=$p(mParam,"^",4)   ///医院	
	
	&SQL(Update DHC_EmConsWorkFlow Set EC_Code=:Code, EC_Desc=:Desc,EC_Hosp_Dr=:HospID
		WHERE EC_RowID=:ID )
 	q SQLCODE
}

/// Creator: 		qqa
/// CreateDate: 	2019-04-16
/// Descript:		删除
/// w ##class(web.DHCMDTGroup).delete("1")
ClassMethod delete(ID As %String) As %String
{
	N (ID)
	&SQL(Delete From DHC_EmConsWorkFlow Where EC_RowID=:ID)
	Q SQLCODE
}

/// w ##class(web.DHCEMConsWorkFlow).GetStatusList("2")
ClassMethod GetStatusList(HospID)
{
	n (HospID)
	s Count=0
	w "["
	s ID=0
	f  s ID = $o(^DHCEMCONS(ID)) q:ID=""  d
	.s Code=$p(^DHCEMCONS(ID),"^",1)
	.s Desc=$p(^DHCEMCONS(ID),"^",2)
	.s Flag = $p(^DHCEMCONS(ID),"^",3) //hxy 2020-08-11 st
	.q:Flag'="Y" //ed
	.s HospDr = $p(^DHCEMCONS(ID),"^",4)
	.;q:(HospID'="")&&(HospID'=HospDr) //hxy 2020-06-04 注释
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.s ListData=ID_"^"_Desc
	.w ##class(web.DHCEMJsonCommon).getJsonData("value^text",ListData)
	w "]"
	q ""
}

/// w ##class(web.DHCEMConsWorkFlow).QryListMainItm("40","1","3")
ClassMethod QryListMainItm(rows As %String, page As %String, Params As %String)
{
	n (rows,page,Params)
	
	s End = page*rows
	s Start=(page-1)*rows+1
	s ParID=$p(Params,"^",1)
	q:+ParID=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
	
	k TmpItemDet
	s h=0,Count=0
	s Sub=""
	f  s Sub=$o(^DHCEMCONWF(ParID,"I",Sub)) q:Sub=""  d
	.q:+Sub=0
	.s ID = ParID_"||"_Sub
	.s Date = ^DHCEMCONWF(ParID,"I",Sub)
	.
	.s StatusDr=$p(Date,"^",1)
	.q:+StatusDr=0
	.s Status=$p(^DHCEMCONS(+StatusDr),"^",2)
	.s h=h+1
	.s ListData=ID_"^"_Status_"^"_StatusDr
	.s TmpItemDet(h)=ListData
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""
	
	///转换数据为Json格式
	s ListTitle="ID^Status^StatusDr"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s Index=""
	F  s Index=$o(TmpItemDet(Index)) Q:Index=""  D
	.s ListData=$g(TmpItemDet(Index))
	.s Count = Count+1
	.Q:(Count<Start)||(Count>End)
	.I Count=Start D
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.e  D
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	Q ""
}

ClassMethod QryListMainItmAut(rows As %String, page As %String, Params As %String)
{
	n (rows,page,Params)
	
	s End = page*rows
	s Start=(page-1)*rows+1
	s WorkFlowItemID=$p(Params,"^",1)
	q:+WorkFlowItemID=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
	
	k TmpItemDet
	s h=0,Count=0
	s ID=""
	f  s ID=$o(^DHCEMCONG(0,"WorkItem",WorkFlowItemID,ID)) q:ID=""  d
	.q:+ID=0
	.s Date = ^DHCEMCONG(ID)
	.s TypeID=$p(Date,"^",2)
	.s Type=$case(TypeID,"G":"安全组","L":"科室","U":"人员",:"")
	.s PointerID=$p(Date,"^",3)
	.s Pointer=""
	.s:TypeID="G" Pointer=$p(^SSU("SSGRP",PointerID),"^",1)
	.s:TypeID="L" Pointer=$p(^CTLOC(PointerID),"^",2)
	.s:TypeID="U" Pointer=$p(^SSU("SSUSR",PointerID),"^",2)
	.s h=h+1
	.s ListData=ID_"^"_TypeID_"^"_Type_"^"_PointerID_"^"_Pointer
	.s TmpItemDet(h)=ListData
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""
	
	///转换数据为Json格式
	s ListTitle="ID^TypeID^Type^PointID^Pointer"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s Index=""
	F  s Index=$o(TmpItemDet(Index)) Q:Index=""  D
	.s ListData=$g(TmpItemDet(Index))
	.s Count = Count+1
	.Q:(Count<Start)||(Count>End)
	.I Count=Start D
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  D
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	Q ""
}

/// Description: 保存[工作流项目定义]
/// Creator:     QQA
/// CreateDate:  2019-12-09
/// Table:		 DHC_EmConsWorkFlow
/// Input:  	 DataList:以字符"^"分割,格式为:id^代码^描述^类型描述^是否可用
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCEMConsWorkFlow).save("4||2^4^4")
ClassMethod saveItm(mParam As %String) As %String
{
	n (mParam)
	s Err=0
	F i=1:1:$L(mParam,"$$") Q:Err'=0  D
	.s mdata=$p(mParam,"$$",i)
	.s Err=..isItmExist(mdata)   /// 重复性判断
	.Q:Err'=0
	.i $p(mdata,"^",1) ="" d
	..s Err=..insertItm(mdata)
	.e  d
	..s Err=..updateItm(mdata)
	Q Err
}

/// Creator: 		qqa
/// CreateDate: 	2019-04-16
/// Descript:		检查代码、描述是否重复
/// w ##class(web.DHCEMNurExecFormSet).isExist("^SYDO^SYDO^2")
ClassMethod isItmExist(mParam As %String) As %String
{
	N (mParam)
	s ItemID=$P(mParam,"^",1) //hxy 2020-03-12 st
	s ID=$P(mParam,"^",2)
	s Status=$P(mParam,"^",3)
	q:(ItemID="")&($d(^DHCEMCONWF(0,"Status",Status,ID))) "-1"
	s IDCur=$o(^DHCEMCONWF(0,"Status",Status,ID,""))
	q:(ItemID'="")&(IDCur'="")&(IDCur'=($p(ItemID,"||",2))) "-3" //ed
	q 0
}

/// Creator: 		qqa
/// CreateDate: 	2019-04-16
/// Descript:		增加
/// w ##class(web.DHCMDTGroup).insert("")
ClassMethod insertItm(mParam As %String) As %String
{
	n (mParam)
	s ParID = $p(mParam,"^",2)
	s StatID=$p(mParam,"^",3)   ///描述
	s Sub=$o(^DHCEMCONWF(+ParID,"I",""),-1)+1
	
 	&SQL(INSERT INTO DHC_EmConsWorkFlowItem (EC_ParRef_Dr,EC_ChildSub, EC_Status_Dr)
 		VALUES(:ParID,:Sub,:StatID))
 	q SQLCODE
}

/// Creator: 		qqa
/// CreateDate: 	2019-04-16
/// Descript:		更新
/// w ##class(web.DHCMDTGroup).update("")
ClassMethod updateItm(mParam As %String) As %String
{
	n (mParam)
	s ID=$p(mParam,"^",1)   	///ID
	s ParID = $p(mParam,"^",2)
	s StatID=$p(mParam,"^",3)   ///描述
	s StatDr=$p(mParam,"^",4)   ///描述 //hxy 2020-08-05 st
	s:+StatDr'=0 StatID=StatDr //ed
	&SQL(Update DHC_EmConsWorkFlowItem Set EC_Status_Dr=:StatID
		WHERE EC_RowID=:ID )
 	q SQLCODE
}

/// Creator: 		qqa
/// CreateDate: 	2019-04-16
/// Descript:		删除
/// w ##class(web.DHCMDTGroup).delete("1")
ClassMethod deleteItm(ID As %String) As %String
{
	N (ID)
	;&SQL(Delete From DHC_EmConsWorkFlowItem Where EC_RowID=:ID) //hxy 2021-07-13 st
	s $Zt="Err"
	ts
	&SQL(Delete From DHC_EmConsWorkFlowItem Where EC_RowID=:ID)
	i SQLCODE'=0 tro
	q:SQLCODE'=0 SQLCODE
	&SQL(Delete From DHC_EmConsGrant Where EC_WF_Dr=:ID)
	s:SQLCODE=100 SQLCODE=0
	i SQLCODE'=0 tro
	q:SQLCODE'=0 SQLCODE
	tc
	Q SQLCODE
Err
	tro //ed
	Q SQLCODE
}

/// w ##class(web.DHCEMConsWorkFlow).QryListPointer("","G")
ClassMethod QryListPointer(q = "", Type, InHospID)
{
	n (q,Type,InHospID)
	
	k TmpItemDet
	s h=0
	i Type="G" d
	.s ID=""
	.f  s ID=$o(^SSU("SSGRP",ID)) q:ID=""  d
	..q:+ID=0
	..s ShowFlag=##class(web.DHCEMCommonUtil).GetHospShowDataFlag("SS_Group",ID,InHospID)
	..q:ShowFlag'="Y"
	..s Date = ^SSU("SSGRP",ID)
	..s Desc=$p(Date,"^",1)
	..s ActiveFlag=$p(Date,"^",151) //hxy 2022-10-10 有效标志
	..q:ActiveFlag="N"
	..s h=h+1
	..s ListData=ID_"^"_Desc_"^"_Desc
	..s TmpItemDet(h)=ListData
	i Type="L" d
	.s ID=""
	.f  s ID=$o(^CTLOC(ID)) q:ID=""  d
	..q:+ID=0
	..s ShowFlag=##class(web.DHCEMCommonUtil).GetHospShowDataFlag("CT_Loc",ID,InHospID)
	..q:ShowFlag'="Y"
	..s Date = ^CTLOC(ID)
	..s DateFrom=$p(^CTLOC(ID),"^",24)
	..s DateTo=$p(^CTLOC(ID),"^",25)
	..Q:(DateFrom>+$H)&(DateFrom'="")
	..Q:(DateTo<+$H)&(DateTo'="")
	..s Code=$p(Date,"^",43)
	..s Desc=$p(Date,"^",2)
	..s AllDesc=Code_Desc
	..s h=h+1
	..s ListData=ID_"^"_Desc_"^"_AllDesc
	..s TmpItemDet(h)=ListData
	
	i Type="U" d
	.s ID=""
	.f  s ID=$o(^SSU("SSUSR",ID)) q:ID=""  d
	..q:+ID=0
	..s ShowFlag=##class(web.DHCEMCommonUtil).GetHospShowDataFlag("SS_User",ID,InHospID)
	..q:ShowFlag'="Y"
	..s DateFrom=$p(^SSU("SSUSR",ID),"^",96)
	..s DateTo=$p(^SSU("SSUSR",ID),"^",97)
	..q:(DateFrom'="")&&(+$H<DateFrom)
	..q:(DateTo'="")&&(+$H>DateTo)
	..q:$p(^SSU("SSUSR",ID),"^",19)'="Y" //hxy 2022-10-10 用户未激活
	..s UserNo = $p(^SSU("SSUSR",ID),"^",1)
	..s Date = ^SSU("SSUSR",ID)
	..s Desc=$p(Date,"^",2)_"【"_UserNo_"】"
	..
	..s h=h+1
	..s ListData=ID_"^"_Desc_"^"_Desc
	..s TmpItemDet(h)=ListData
	
	s Count=0
	w "["
	s ID=0
	f  s ID = $o(TmpItemDet(ID)) q:ID=""  d
	.s RowID=$p(TmpItemDet(ID),"^",1)
	.s Desc=$p(TmpItemDet(ID),"^",2)
	.s AllDesc=$p(TmpItemDet(ID),"^",3)
	.s AllDesc=$$ALPHAUP^SSUTIL4(AllDesc)
	.s q=$$ALPHAUP^SSUTIL4(q)
	.s HospDr = $p(TmpItemDet(ID),"^",2)
	.q:(q'="")&&(AllDesc'[q)
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.s ListData=RowID_"^"_Desc
	.w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",ListData)
	w "]"
	q ""
}

/// Description: 保存[工作流项目定义]
/// Creator:     QQA
/// CreateDate:  2019-12-09
/// Table:		 DHC_EmConsWorkFlow
/// Input:  	 DataList:以字符"^"分割,格式为:id^代码^描述^类型描述^是否可用
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCEMConsWorkFlow).save("^111^222")
ClassMethod saveAutItm(mParam As %String) As %String
{
	n (mParam)
	s Err=0
	F i=1:1:$L(mParam,"$$") Q:Err'=0  D
	.s mdata=$p(mParam,"$$",i)
	.s Err=..isItmAutExist(mdata)   /// 重复性判断
	.Q:Err'=0
	.i $p(mdata,"^",1) ="" d
	..s Err=..insertItmAut(mdata)
	.e  d
	..s Err=..updateItmAut(mdata)
	Q Err
}

/// Creator: 		qqa
/// CreateDate: 	2019-04-16
/// Descript:		检查代码、描述是否重复
/// w ##class(web.DHCEMNurExecFormSet).isExist("^SYDO^SYDO^2")
ClassMethod isItmAutExist(mParam As %String) As %String
{
	N (mParam)
	s ItmAutID=$P(mParam,"^",1) //hxy 2022-10-13 st
	s WF=$P(mParam,"^",2)
	s Type=$P(mParam,"^",3)
	s Pointer=$P(mParam,"^",4)
	q:(ItmAutID="")&($d(^DHCEMCONG(0,"TypePointer",Type,Pointer,WF))) "-1"
	s IDCur=$o(^DHCEMCONG(0,"TypePointer",Type,Pointer,WF,""))
	q:(ItmAutID'="")&(IDCur'="")&(IDCur'=ItmAutID) "-3" //ed

	q 0
}

/// Creator: 		qqa
/// CreateDate: 	2019-04-16
/// Descript:		增加
/// w ##class(web.DHCMDTGroup).insert("")
ClassMethod insertItmAut(mParam As %String) As %String
{
	n (mParam)
	s WorkFlowItmID = $p(mParam,"^",2)
	s Type=$p(mParam,"^",3)   ///
	s Pointer=$p(mParam,"^",4)   ///
	
 	&SQL(INSERT INTO DHC_EmConsGrant (EC_WF_Dr, EC_Type, EC_Poniter)
 		VALUES(:WorkFlowItmID,:Type,:Pointer))
 	q SQLCODE
}

/// Creator: 		qqa
/// CreateDate: 	2019-04-16
/// Descript:		更新
/// w ##class(web.DHCMDTGroup).update("")
ClassMethod updateItmAut(mParam As %String) As %String
{
	n (mParam)
	s ID=$p(mParam,"^",1)   	///ID
	s WorkFlowItmID = $p(mParam,"^",2)
	s Type=$p(mParam,"^",3)   ///
	s Pointer=$p(mParam,"^",4)   ///
	&SQL(Update DHC_EmConsGrant Set EC_WF_Dr=:WorkFlowItmID,EC_Type=:Type,EC_Poniter=:Pointer
		WHERE EC_RowID=:ID)
 	q SQLCODE
}

/// Creator: 		qqa
/// CreateDate: 	2019-04-16
/// Descript:		删除
/// w ##class(web.DHCMDTGroup).delete("1")
ClassMethod deleteItmAut(ID As %String) As %String
{
	N (ID)
	&SQL(Delete From DHC_EmConsGrant Where EC_RowID=:ID)
	Q SQLCODE
}

}
