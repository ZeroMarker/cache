Import sqluser

/// Creator: 	qqa
/// CreateDate: 2019-04-15
/// Descript: 	MDT会诊权限
Class web.DHCMDTReqJurisdiction Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:	会诊申请状态字典
/// w ##class(web.DHCMDTReqJurisdiction).save("8^000003^测试000003^N^65")
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
	q Err
}

/// Descript:	增加 会诊申请状态字典
/// w ##class(web.DHCEMConsStatus).insert("")
ClassMethod insert(mParam As %String) As %String
{
	n (mParam)
	s LocID=$p(mParam,"^",2)   	///科室ID
	s ProvTpID=$p(mParam,"^",3)   	///职称
	s HospID=$p(mParam,"^",4)  ///医院ID
 	&SQL(INSERT INTO DHC_MDTDocAut(MD_Loc_Dr, MD_ProvTp_Dr, MD_Hosp_Dr) VALUES(:LocID,:ProvTpID,:HospID))
 	q SQLCODE
}

/// Descript:	更新 会诊申请状态字典
/// w ##class(web.DHCMDTReqJurisdiction).update("")
ClassMethod update(mParam As %String) As %String
{
	n (mParam)
	s ID=$p(mParam,"^",1)   	///ID
	s LocID=$p(mParam,"^",2)   	///科室ID
	s ProvTpID=$p(mParam,"^",3) ///职称
	s HospID=$p(mParam,"^",4)   ///医院ID
	&SQL(Update DHC_MDTDocAut Set MD_Loc_Dr=:LocID,MD_ProvTp_Dr=:ProvTpID,MD_Hosp_Dr=:HospID WHERE MD_RowID=:ID)
 	q SQLCODE
}

/// Descript:检查代码、描述是否重复
/// w ##class(web.DHCMDTReqJurisdiction).isExist("^ALL^1^2")
ClassMethod isExist(mParam As %String) As %String
{
	N (mParam)
	s HasDate=0
	s ID=$p(mParam,"^",1)   	///ID
	s LocID=$p(mParam,"^",2)   	///科室ID
	s ProvTpID=$p(mParam,"^",3) ///职称
	s HospID=$p(mParam,"^",4)   ///医院ID
	s MDRowID=""
	f  s MDRowID=$o(^DHCMDTDA(0,"Loc",LocID,MDRowID)) q:(MDRowID="")||(HasDate'=0)  d
	.s HasProvTpID = $p(^DHCMDTDA(MDRowID),"^",2)
	.s HasHospID = $p(^DHCMDTDA(MDRowID),"^",3)
	.s:(HasProvTpID=ProvTpID)&&(HasHospID=HospID)&&(ID'=MDRowID) HasDate=-1
	Q HasDate
}

/// Descript:	删除 会诊申请状态字典
/// w ##class(web.DHCMDTReqJurisdiction).delete("1")
ClassMethod delete(ID As %String) As %String
{
	N (ID)
	&SQL(Delete From DHC_MDTDocAut Where MD_RowID=:ID)
	Q SQLCODE
}

/// Descript:查询
/// w ##class(web.DHCMDTReqJurisdiction).QryList("12","1","")
ClassMethod QryList(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	s End = page*rows
	s Start=(page-1)*rows+1
	k TmpItemDet
	s h=0,count=0
	s ID="0"
	F  s ID=$o(^DHCMDTDA(ID)) Q:ID=""  D
	.s Loc=""
	.s LocID=$p(^DHCMDTDA(ID),"^",1)    //代码
	.s:LocID="ALL" Loc="全院通用"
	.s:(LocID'="")&&(LocID'="ALL") Loc = $p(^CTLOC(LocID),"^",2)
	.s CarPrvTp=""
	.s CarPrvTpID=$p(^DHCMDTDA(ID),"^",2)    //描述
	.b ;err
	.s:CarPrvTpID'="" CarPrvTp = $p(^CT("CPT",CarPrvTpID),"^",2)
	.s HospID=$p(^DHCMDTDA(ID),"^",3) //可用标志
	.s Hosp=""
	.s:HospID'="" Hosp=$p(^CT("HOSP",HospID),"^",2)
	.s h=h+1
	.s ListData=ID_"^"_LocID_"^"_Loc_"^"_CarPrvTpID_"^"_CarPrvTp_"^"_HospID_"^"_Hosp
	.s TmpItemDet(h)=ListData
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""
	
	///转换数据为Json格式
	s ListTitle="ID^LocID^Loc^CarPrvTpID^CarPrvTp^HospID^Hosp"
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

}
