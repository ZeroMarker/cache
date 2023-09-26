Import SQLUser

/// Creator: 		bianshuai
/// CreateDate: 	2019-07-10
/// Descript: 		mdt会诊模板
Class web.DHCMDTOpiTemp Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: 		bianshuai
/// CreateDate: 	2019-07-10
/// Descript:		mdt会诊模板
/// w ##class(web.DHCMDTOpiTemp).save("^01^请各科协助完善患者病情评估，指导下一步治疗方案。^D")
ClassMethod save(mParam As %String) As %String
{
	n (mParam)
	s Err=0
	F i=1:1:$L(mParam,"$$") Q:Err'=0  D
	.s mdata=$p(mParam,"$$",i)
	.i $p(mdata,"^",1) ="" d
	..s Err=..insert(mdata)
	.e  d
	..s Err=..update(mdata)
	Q Err
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-07-10
/// Descript:		增加
/// w ##class(web.DHCMDTOpiTemp).insert("")
ClassMethod insert(mParam As %String) As %String
{
	n (mParam)
	s Title=$p(mParam,"^",2)   	/// 标题
	s Text=$p(mParam,"^",3)   	/// 内容
	s Type=$p(mParam,"^",4)   	/// 类型
	s Pointer=$p(mParam,"^",5)  /// 指针
	s MTHospDr=$p(mParam,"^",6)  /// 医院
 	&SQL(INSERT INTO DHC_MDTOpiTemp(MT_Title, MT_Text, MT_Type, MT_Pointer,MT_Hosp_Dr) VALUES(:Title,:Text,:Type,:Pointer,:MTHospDr))
 	q SQLCODE
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-07-10
/// Descript:		更新
/// w ##class(web.DHCMDTOpiTemp).update("")
ClassMethod update(mParam As %String) As %String
{
	n (mParam)
	s ID=$p(mParam,"^",1)   	/// ID
	s Title=$p(mParam,"^",2)   	/// 标题
	s Text=$p(mParam,"^",3)   	/// 内容
	s Type=$p(mParam,"^",4)   	/// 类型
	s Pointer=$p(mParam,"^",5)  /// 指针
	s MTHospDr=$p(mParam,"^",6)  /// 医院

	&SQL(Update DHC_MDTOpiTemp Set MT_Title=:Title, MT_Text=:Text, MT_Type=:Type, MT_Pointer=:Pointer, MT_Hosp_Dr=:MTHospDr WHERE MT_RowID=:ID)
 	q SQLCODE
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-07-10
/// Descript:		删除
/// w ##class(web.DHCMDTOpiTemp).delete("1")
ClassMethod delete(ID As %String) As %String
{
	N (ID)
	&SQL(Delete From DHC_MDTOpiTemp Where MT_RowID=:ID)
	Q SQLCODE
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-07-10
/// Descript:		查询
/// w ##class(web.DHCMDTOpiTemp).QryOpiTemp("30","1","3","3^191^299^876")
ClassMethod QryOpiTemp(rows As %String, page As %String, Type As %String, LgParam As %String) As %String
{
	N (rows, page, Type, LgParam)
	s End = page*rows
	s Start=(page-1)*rows+1
	k TmpItemDet
	s h=0,count=0
	s ID=0
	s hospId = $p(LgParam,"^",1)
	F  s ID=$o(^DHCMDTOT(ID)) Q:ID=""  D
	.s Title=$p(^DHCMDTOT(ID),"^",1)    /// 标题
	.s Text=$p(^DHCMDTOT(ID),"^",2)     /// 描述
	.;s Type=$p(^DHCMDTOT(ID),"^",3)     /// 类型
	.s Pointer=$p(^DHCMDTOT(ID),"^",4)  /// 指针
	.s HospID=$p(^DHCMDTOT(ID),"^",5)  //医院
	.q:hospId'=HospID
	.q:(Type'=Pointer)&&(Pointer'="")
	.s h=h+1
	.s ListData=ID_"^"_Title_"^"_Text
	.s TmpItemDet(h)=ListData
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""
	
	///转换数据为Json格式
	s ListTitle="ID^Title^Text"
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
