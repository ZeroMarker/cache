Import SQLUser

Class web.DHCMDTCommonTemp Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: 		bianshuai
/// CreateDate: 	2019-07-10
/// Descript:		mdt会诊模板
/// w ##class(web.DHCMDTemp).save("^1^asd^ada"")
ClassMethod save(mParam As %String) As %String
{
	n (mParam)
	s ^tempyzyy("32")=$lb(mParam)
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
/// w ##class(web.DHCMDTemp).insert("")
ClassMethod insert(mParam As %String) As %String
{
	n (mParam)
	s ^tempyyz("212")=$lb(mParam)
	s Title=$p(mParam,"^",2)   	/// 标题
	s Text=$p(mParam,"^",3)   	/// 内容
	s hosp=$p(mParam,"^",4)   	/// 医院
	;s Type=$p(mParam,"^",4)   	/// 类型
	;s Pointer=$p(mParam,"^",2)  /// 指针
 	&SQL(INSERT INTO DHC_MDTOpiTemp(MT_Title, MT_Text, MT_Pointer,MT_Hosp_Dr) VALUES(:Title,:Text,:Pointer,:hosp))
 	q SQLCODE
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-07-10
/// Descript:		更新
/// w ##class(web.DHCMDTemp).update("")
ClassMethod update(mParam As %String) As %String
{
	n (mParam)
	s ID=$p(mParam,"^",1)   	/// ID
	s Title=$p(mParam,"^",2)   	/// 标题
	s Text=$p(mParam,"^",3)   	/// 内容
	s hosp=$p(mParam,"^",4)   	/// 医院

	;s Type=$p(mParam,"^",4)   	/// 类型
	;s Pointer=$p(mParam,"^",2)  /// 指针
	&SQL(Update DHC_MDTOpiTemp Set MT_Title=:Title, MT_Text=:Text,MT_Pointer=:Pointer,MT_Hosp_Dr=:hosp WHERE MT_RowID=:ID)
 	q SQLCODE
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-07-10
/// Descript:		删除
/// w ##class(web.DHCMDTemp).delete("1")
ClassMethod delete(ID As %String) As %String
{
	N (ID)
	&SQL(Delete From DHC_MDTOpiTemp Where MT_RowID=:ID)
	Q SQLCODE
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-07-10
/// Descript:		查询
/// w ##class(web.DHCMDTemp).QryOpiTemp("12","1","2")
ClassMethod QryOpiTemp(rows As %String, page As %String, params As %String) As %String
{
	N (rows, page, params)
	s End = page*rows
	s Start=(page-1)*rows+1
	k TmpItemDet
	s h=0,count=0
	s hospId = $p(params,"^",1)

	s ID="0"
	F  s ID=$o(^DHCMDTOT(ID)) Q:ID=""  D
	.q:'$d(^DHCMDTOT(ID))
	.s Title=$p(^DHCMDTOT(ID),"^",1)    /// 标题
	.s Text=$p(^DHCMDTOT(ID),"^",2)     /// 描述
	.;s Type=$p(^DHCMDTOT(ID),"^",3)     /// 类型
	.s Pointer=$p(^DHCMDTOT(ID),"^",4)  /// 指针
	.s HospID=$p(^DHCMDTOT(ID),"^",5)  //医院
	.q:hospId'=HospID
	.q:Pointer'=""
	.s h=h+1
	.s ListData=ID_"^"_Pointer_"^"_Title_"^"_Text _"^"_HospID
	.s TmpItemDet(h)=ListData
	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""
	
	///转换数据为Json格式
	s ListTitle="ID^Pointer^Title^Text^HospID"
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
