Import SQLUser

/// Creator: 		bianshuai
/// CreateDate: 	2018-08-28
/// Descript: 		会诊外院科室关联维护
Class web.DHCEMConsHosLoc Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:	外院科室关联维护
/// w ##class(web.DHCEMConsHosLoc).save("^1^16^14")
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
/// w ##class(web.DHCEMConsHosLoc).insert("")
ClassMethod insert(mParam As %String) As %String
{
	n (mParam)
	s HospID=$p(mParam,"^",2)    /// 医院
	s LocID=$p(mParam,"^",3)     /// 科室
 	&SQL(INSERT INTO DHC_EmConsHosLoc(EC_Hosp_Dr, EC_Loc_Dr) VALUES(:HospID,:LocID))
 	q SQLCODE
}

/// Descript:	更新
/// w ##class(web.DHCEMConsHosLoc).update("")
ClassMethod update(mParam As %String) As %String
{
	n (mParam)
	s ID=$p(mParam,"^",1)   	 /// ID
	s HospID=$p(mParam,"^",2)    /// 医院
	s LocID=$p(mParam,"^",3)     /// 科室
	&SQL(Update DHC_EmConsHosLoc Set EC_Hosp_Dr=:HospID, EC_Loc_Dr=:LocID WHERE EC_RowID=:ID)
 	q SQLCODE
}

/// Descript:	删除
/// w ##class(web.DHCEMConsHosLoc).delete("1")
ClassMethod delete(ID As %String) As %String
{
	N (ID)
	&SQL(Delete From DHC_EmConsHosLoc Where EC_RowID=:ID)
	Q SQLCODE
}

/// Descript:	查询
/// w ##class(web.DHCEMConsHosLoc).QryEmConsHosLoc("12","1","2")
ClassMethod QryEmConsHosLoc(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	s End = page*rows
	s Start=(page-1)*rows+1
	s HospID=$p(params,"^",1) //hxy 2020-05-28
	k TmpItemDet
	s h=0,count=0
	s ID="0"
	F  s ID=$o(^DHCEMCHL(ID)) Q:ID=""  D
	.s itmHosID=$p(^DHCEMCHL(ID),"^",1)  /// 医院
	.s itmHosp=$p($g(^DHCEMCDI(+itmHosID)),"^",2) //hxy 2021-03-29 $g
	.s itmLocID=$p(^DHCEMCHL(ID),"^",2)  /// 科室
	.s itmLoc=$p($g(^DHCEMCDI(+itmLocID)),"^",2) //hxy 2020-09-22 $g
    .s HospDr=$P($g(^DHCEMCDI(+itmHosID)),"^",4) //hxy 2020-05-28
    .q:(HospDr'="")&(HospDr'=HospID) //ed
	.s h=h+1
	.s ListData=ID_"^"_itmHosID_"^"_itmHosp_"^"_itmLocID_"^"_itmLoc
	.s TmpItemDet(h)=ListData
	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""
	
	///转换数据为Json格式
	s ListTitle="ID^itmHosID^itmHosp^itmLocID^itmLoc"
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

/// Descript:	外院科室
/// w ##class(web.DHCEMConsHosLoc).JsonDicLoc("")
ClassMethod JsonDicLoc(HospID As %String) As %String
{
	n (HospID,%session)
	s count=0
	w "["
	s ID=""
	F  s ID=$o(^DHCEMCHL(0,"HospID",HospID,ID)) Q:ID=""  D
	.s ItmID=$p(^DHCEMCHL(ID),"^",2)  /// 科室
	.s ItmDesc=$p(^DHCEMCDI(ItmID),"^",2)
	.s ItmDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.DHCEmConsDicItem","ECDesc","",ItmDesc)
	.s tmp=ItmID_"^"_ItmDesc
	.s count = count+1
	.I count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	.E  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	w "]"
	Q ""
}

/// Descript:  检查是否重复
ClassMethod isExist(mParam As %String) As %String
{
	N (mParam)
	s HospID=$p(mParam,"^",2)    /// 医院
	s LocID=$p(mParam,"^",3)     /// 科室
	s ID="", QuitFlag=0
	F  s ID=$o(^DHCEMCHL(0,"HospID",HospID,ID)) Q:(ID="")||(QuitFlag=1)  D
	.s ItmID=$p(^DHCEMCHL(ID),"^",2)  /// 科室
	.Q:ItmID'=LocID
	.s QuitFlag=1
	.
	Q:QuitFlag=1 "-1"
	Q QuitFlag
}

}
