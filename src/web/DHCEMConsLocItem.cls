Import SQLUser

/// Creator: 		bianshuai
/// CreateDate: 	2018-08-28
/// Descript: 		科室亚专业/指症关联维护
Class web.DHCEMConsLocItem Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:	科室亚专业/指症
/// w ##class(web.DHCEMConsLocItem).save("^113^17^15")
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

/// Descript:	增加
/// w ##class(web.DHCEMConsLocItem).insert("")
ClassMethod insert(mParam As %String) As %String
{
	n (mParam)
	s LocID=$p(mParam,"^",2)   	 /// 科室ID
	s SubMarID=$p(mParam,"^",3)  /// 亚专业
	s IndItmID=$p(mParam,"^",4)  /// 专业指针
 	&SQL(INSERT INTO DHC_EmConsLocItm(EC_Loc_Dr, EC_SubMar_Dr, EC_IndItm_Dr) VALUES(:LocID,:SubMarID,:IndItmID))
 	q SQLCODE
}

/// Descript:	更新
/// w ##class(web.DHCEMConsLocItem).update("")
ClassMethod update(mParam As %String) As %String
{
	n (mParam)
	s ID=$p(mParam,"^",1)   	 /// ID
	s LocID=$p(mParam,"^",2)   	 /// 科室ID
	s SubMarID=$p(mParam,"^",3)  /// 亚专业
	s IndItmID=$p(mParam,"^",4)  /// 专业指针
	&SQL(Update DHC_EmConsLocItm Set EC_Loc_Dr=:LocID, EC_SubMar_Dr=:SubMarID, EC_IndItm_Dr=:IndItmID WHERE EC_RowID=:ID)
 	q SQLCODE
}

/// Descript:检查代码、描述是否重复
ClassMethod isExist(mParam As %String) As %String
{
	N (mParam)
	s ID=$p(mParam,"^",1)   	 /// ID
	s LocID=$p(mParam,"^",2)   	 /// 科室ID
	s SubMarID=$p(mParam,"^",3)  /// 亚专业
	s IndItmID=$p(mParam,"^",4)  /// 专业指针
	s Ret=0
	s CLIRowID=0
	f  s CLIRowID=$o(^DHCEMCLI(0,"Loc",LocID,CLIRowID)) q:(CLIRowID="")||(Ret'=0)  d
	.s ThisMarID=$p(^DHCEMCLI(CLIRowID),"^",2)
	.s ThisIndItmID=$p(^DHCEMCLI(CLIRowID),"^",3)
	.s:(SubMarID=ThisMarID)&&(IndItmID=ThisIndItmID)&(ID'=CLIRowID) Ret=-1
	Q Ret
}

/// Descript:	删除
/// w ##class(web.DHCEMConsLocItem).delete("1")
ClassMethod delete(ID As %String) As %String
{
	N (ID)
	&SQL(Delete From DHC_EmConsLocItm Where EC_RowID=:ID)
	Q SQLCODE
}

/// Descript:	查询
/// w ##class(web.DHCEMConsLocItem).QryEmConsLocItem("12","1","")
ClassMethod QryEmConsLocItem(rows As %String, page As %String, Params As %String) As %String
{
	N (rows,page,Params)
	s InHospID=$p(Params,"^",1)
	s End = page*rows
	s Start=(page-1)*rows+1
	k TmpItemDet
	s h=0,count=0
	s ID="0"
	F  s ID=$o(^DHCEMCLI(ID)) Q:ID=""  D
	.s LocID=$p(^DHCEMCLI(ID),"^",1)     /// 科室ID
	.s ShowFlag=##class(web.DHCEMCommonUtil).GetHospShowDataFlag("CT_Loc",LocID,InHospID)
	.q:ShowFlag'="Y"
	.s LocDesc = $p(^CTLOC(LocID),"^",2)
	.s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	.s SubMarID=$p(^DHCEMCLI(ID),"^",2)  /// 亚专业
	.s SubMar=$p($g(^DHCEMCDI(+SubMarID)),"^",2)
	.s IndItmID=$p(^DHCEMCLI(ID),"^",3)  /// 专业指针
	.s IndItem=$p($g(^DHCEMCDI(+IndItmID)),"^",2)
	.s h=h+1
	.s ListData=ID_"^"_LocID_"^"_LocDesc_"^"_SubMarID_"^"_SubMar_"^"_IndItmID_"^"_IndItem
	.s TmpItemDet(h)=ListData
	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""
	
	///转换数据为Json格式
	s ListTitle="ID^LocID^LocDesc^MarID^MarDesc^ItmID^ItmDesc"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	F  s index=$o(TmpItemDet(index)) Q:index=""  D
	.s ListData=$g(TmpItemDet(index))
	.s count = count+1
	.Q:(count<Start)||(count>End)
	.I count=Start D
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  D
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符

	Q ""
}

/// Descript:	亚专业
/// w ##class(web.DHCEMConsLocItem).JsonSubMar("")
ClassMethod JsonSubMar(LocID As %String) As %String
{
	n (LocID,%session)
	s count=0
	k TMPSubMarArr
	w "["
	s ID=""
	F  s ID=$o(^DHCEMCLI(0,"Loc",+LocID,ID)) Q:ID=""  D
	.s SubMarID=$p(^DHCEMCLI(ID),"^",2)  /// 亚专业
	.s SubMar=$p(^DHCEMCDI(SubMarID),"^",2)
	.Q:$d(TMPSubMarArr(SubMarID))
	.s TMPSubMarArr(SubMarID)=""
	.s SubMar=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.DHCEmConsDicItem","ECDesc","",SubMar)
	.s tmp=SubMarID_"^"_SubMar
	.s count = count+1
	.I count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	.E  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	w "]"
	Q ""
}

/// Descript:	亚专业对应指征
/// w ##class(web.DHCEMConsLocItem).JsonSubMarInd("")
ClassMethod JsonSubMarInd(MarID As %String, LocID As %String) As %String
{
	n (MarID, LocID)
	s count=0
	w "["
	s ID=0
	F  s ID=$o(^DHCEMCLI(0,"SubMar",+MarID,ID)) Q:ID=""  D
	.Q:LocID'=$p(^DHCEMCLI(ID),"^",1)
	.s itmID=$p(^DHCEMCLI(ID),"^",3)  /// 指征
	.s itmDesc=$p(^DHCEMCDI(itmID),"^",2)
	.s tmp=itmID_"^"_itmDesc
	.s count = count+1
	.I count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	.E  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	w "]"
	Q ""
}

}
