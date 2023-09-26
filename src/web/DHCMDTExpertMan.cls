Import SQLUser

/// Creator: 		bianshuai
/// CreateDate: 	2020-08-18
/// Descript: 		MDT专家管理后台类
Class web.DHCMDTExpertMan Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: 		bianshuai
/// CreateDate: 	2020-08-18
/// Descript:		MDT专家字典表
/// w ##class(web.DHCMDTExpertMan).save("")
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
	..i Err>0 s Err=0
	.e  d
	..s Err=..update(mdata)
	Q Err
}

/// Creator: 		bianshuai
/// CreateDate: 	2020-08-18
/// Descript:		增加
/// w ##class(web.DHCMDTExpertMan).insert("")
ClassMethod insert(mParam As %String) As %String
{
	n (mParam)
	s userCode=$p(mParam,"^",2)   /// 工号
	s userName=$p(mParam,"^",3)   /// 姓名
	s sexID=$p(mParam,"^",4)      /// 性别
	s prvTpID=$p(mParam,"^",5)    /// 职称
	s idCard=$p(mParam,"^",6)     /// 身份证
	s locID=$p(mParam,"^",7)      /// 科室ID
	s phone=$p(mParam,"^",8)      /// 电话
	s actCode=$p(mParam,"^",9)    /// 是否可以
	s hospID=$p(mParam,"^",10)    /// 医院ID
 	&SQL(INSERT INTO DHC_MDTOuterExpert(MD_Code, MD_Name, MD_Sex_Dr, MD_ProvTp_Dr, MD_IDCard, MD_Loc_Dr, MD_Phone, MD_ActiveFlag, MD_Hosp_Dr) 
 		VALUES(:userCode,:userName,:sexID,:prvTpID,:idCard,:locID,:phone,:actCode,:hospID))
 	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Creator: 		bianshuai
/// CreateDate: 	2020-08-18
/// Descript:		更新
/// w ##class(web.DHCMDTExpertMan).update("")
ClassMethod update(mParam As %String) As %String
{
	n (mParam)
	s ID=$p(mParam,"^",1)   	  /// ID
	s userCode=$p(mParam,"^",2)   /// 工号
	s userName=$p(mParam,"^",3)   /// 姓名
	s sexID=$p(mParam,"^",4)      /// 性别
	s prvTpID=$p(mParam,"^",5)    /// 职称
	s idCard=$p(mParam,"^",6)     /// 身份证
	s locID=$p(mParam,"^",7)      /// 科室ID
	s phone=$p(mParam,"^",8)      /// 电话
	s actCode=$p(mParam,"^",9)    /// 是否可以
	s hospID=$p(mParam,"^",10)    /// 医院ID
	&SQL(Update DHC_MDTOuterExpert Set MD_Code=:userCode, MD_Name=:userName, MD_Sex_Dr=:sexID, MD_ProvTp_Dr=:prvTpID, MD_IDCard=:idCard,
		 MD_Loc_Dr=:locID, MD_Phone=:phone, MD_ActiveFlag=:actCode, MD_Hosp_Dr=:hospID WHERE MD_RowID=:ID)
 	Q SQLCODE
}

/// Creator: 		bianshuai
/// CreateDate: 	2020-08-18
/// Descript:		删除
/// w ##class(web.DHCMDTExpertMan).delete("1")
ClassMethod delete(ID As %String) As %String
{
	n (ID)
	Q:..IsDel(ID) -1
	&SQL(Delete From DHC_MDTOuterExpert Where MD_RowID=:ID)
	Q SQLCODE
}

/// Creator: 		bianshuai
/// CreateDate: 	2020-08-18
/// Descript:		查询
/// w ##Class(web.DHCMDTExpertMan).JsQryExpMan("12","1")
ClassMethod JsQryExpMan(rows As %String, page As %String, GropHospID = "") As %String
{
	n (rows, page ,GropHospID)
	s End = page*rows
	s Start=(page-1)*rows+1
	k TmpArr
	s h=0,count=0
	s ID="0"
	F  s ID=$o(^DHCMDTOUTEXP(ID)) Q:ID=""  D
	.s userCode=$p(^DHCMDTOUTEXP(ID),"^",1)    /// 工号
	.s userName=$p(^DHCMDTOUTEXP(ID),"^",2)    /// 姓名
	.s sexId=$p(^DHCMDTOUTEXP(ID),"^",3)       /// 姓别
	.s userSex=$p($g(^CT("SEX",+sexId)),"^",2)
	.s idCard=$p(^DHCMDTOUTEXP(ID),"^",5)      /// 身份证
	.s prvTpID=$p(^DHCMDTOUTEXP(ID),"^",4)     /// 职称
	.s prvTp=$p($g(^CT("CPT",+prvTpID)),"^",2)
	.s locID=$p(^DHCMDTOUTEXP(ID),"^",6)       /// 科室ID
	.s locDesc=$p($g(^DHCMDTDI(+locID)),"^",2)
	.s ParID=$p($g(^DHCMDTDI(+locID)),"^",6)
	.s OutHosp=$p($g(^DHCMDTDI(+ParID)),"^",2)
	.s phone=$p(^DHCMDTOUTEXP(ID),"^",7)       /// 电话
	.s actCode=$p(^DHCMDTOUTEXP(ID),"^",8)     /// 可用标志
	.s actDesc=$s(actCode="Y":"是",actCode="N":"否",1:"")
	.s hospID=$p(^DHCMDTOUTEXP(ID),"^",9)      /// 医院
	.q:(GropHospID'="")&&(GropHospID'=hospID)
	.s hospDesc=$p($g(^CT("HOSP",+hospID)),"^",2)
	.s h=h+1
	.s ListData=ID_"^"_userCode_"^"_userName_"^"_sexId_"^"_userSex_"^"_idCard_"^"_prvTpID_"^"_prvTp
	.s ListData=ListData_"^"_locID_"^"_locDesc_"^"_OutHosp_"^"_phone_"^"_actCode_"^"_actDesc_"^"_hospID_"^"_hospDesc
	.s TmpArr(h)=ListData
	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""
	
	///转换数据为Json格式
	s ListTitle="ID^userCode^userName^sexID^userSex^idCard^prvTpID^prvTp^locID^locDesc^OutHosp^phone^actCode^actDesc^hospID^hospDesc"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	F  s index=$o(TmpArr(index)) Q:index=""  D
	.s ListData=$g(TmpArr(index))
	.s count = count+1
	.Q:(count<Start)||(count>End)
	.I count=Start D
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  D
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符

	Q ""
}

/// Creator: 		bianshuai
/// CreateDate: 	2020-08-18
/// Descript:		检查工号、姓名是否重复
ClassMethod isExist(mParam As %String) As %String
{
	n (mParam)
	s ID=$p(mParam,"^",1)   	    /// ID
	s userCode=$p(mParam,"^",2)   	/// 代码
	s userName=$p(mParam,"^",3)   	/// 描述
	s HospID=$p(mParam,"^",10)      /// 医院ID
	/// 新记录
	Q:(ID="")&($d(^DHCMDTOUTEXP(0,"userCode",$$ALPHAUP^SSUTIL4(userCode),HospID))) "-1"
	Q:(ID="")&($d(^DHCMDTOUTEXP(0,"userName",$$ALPHAUP^SSUTIL4(userName),HospID))) "-2"
	Q:ID="" 0
	
	/// 修改记录
	s TmpCode=$p($g(^DHCMDTOUTEXP(ID)),"^",1)    //代码
	s TmpDesc=$p($g(^DHCMDTOUTEXP(ID)),"^",2)    //描述
	Q:(TmpCode'=userCode)&($d(^DHCMDTOUTEXP(0,"userCode",$$ALPHAUP^SSUTIL4(userCode),HospID))) "-3"
	Q:(TmpDesc'=userName)&($d(^DHCMDTOUTEXP(0,"userName",$$ALPHAUP^SSUTIL4(userName),HospID))) "-4"
	Q 0
}

ClassMethod hasDataId(Params)
{
	n (Params)
	s UserName=$p(Params,"^",3)
	s HospId=$p(Params,"^",4)
	s HasId=$o(^DHCMDTOUTEXP(0,"userName",$$ALPHAUP^SSUTIL4(UserName),HospId,""),-1)
	q HasId
}

/// Creator: 		bianshuai
/// CreateDate: 	2020-08-18
/// Descritp:		是否允许删除字典项目
/// w ##Class(web.DHCMDTExpertMan).IsDel("11")
ClassMethod IsDel(ID As %String) As %String
{
	n (ID)
	
	Q 0
}

}
