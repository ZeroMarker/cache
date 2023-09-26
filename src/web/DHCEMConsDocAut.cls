Import SQLUser

/// Creator: 		bianshuai
/// CreateDate: 	2018-08-23
/// Descript: 		请会诊医生权限维护
Class web.DHCEMConsDocAut Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:	医生权限维护
/// w ##class(web.DHCEMConsDocAut).save("4634","8:N^9:Y^10:N^11:Y^12:N")
ClassMethod save(userID As %String, mParam As %String, HospID As %String) As %String
{
	n (userID, mParam,HospID)

	s Err=0
	F i=1:1:$L(mParam,"^") Q:Err'=0  D
	.s mdata=$p(mParam,"^",i)
	.s itmID=$p(mdata,":",1) ,itmFlag=$p(mdata,":",2)
	.;s ID=$o(^DHCEMCDA(0,"User",userID,itmID,"")) //hxy 2021-06-02 st 会诊基础字典界面 不动(本身设计等同绝对私有)改造为 私有[之前本身的itmID区分了医院，改造后不一定能]
	.s ID=..getID(userID,itmID,HospID) //ed
	.i (ID ="")&(itmFlag="Y") d
	..s Err=..insert(userID, itmID,HospID)
	.i (ID '="")&(itmFlag="N") d
	..s Err=..delete(ID)
	
	Q Err
}

/// Descript:	增加
/// w ##class(web.DHCEMConsDocAut).insert("")
ClassMethod insert(userID As %String, itmID As %String, HospID As %String) As %String
{
	n (userID, itmID,HospID)
 	&SQL(INSERT INTO DHC_EmConsDocAut(EC_User_Dr, EC_Itm_Dr,EC_Hosp_Dr) VALUES(:userID,:itmID,:HospID))
 	q SQLCODE
}

/// Descript:	更新
/// w ##class(web.DHCEMConsDocAut).update("")
ClassMethod update(ID As %String, userID As %String, itmID As %String) As %String
{
	n (ID, userID, itmID)
	&SQL(Update DHC_EmConsDocAut Set EC_User_Dr=:userID, EC_Itm_Dr=:itmID WHERE EC_RowID=:ID)
 	q SQLCODE
}

/// Descript:	删除
/// w ##class(web.DHCEMConsDocAut).delete("1")
ClassMethod delete(ID As %String) As %String
{
	N (ID)
	&SQL(Delete From DHC_EmConsDocAut Where EC_RowID=:ID)
	Q SQLCODE
}

/// Descript:查询
/// w ##class(web.DHCEMConsDocAut).QryConsDocAut("12","1","2")
ClassMethod QryConsDocAut(rows As %String, page As %String, mUserID As %String, HospID As %String) As %String
{
	N (rows, page, mUserID, HospID)
	s End = page*rows
	s Start=(page-1)*rows+1
	k TmpItemDet
	s LgHosp=##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("DHC_EmConsDicType",HospID) //hxy 2021-06-02 多院区 add
	s mID=$o(^DHCEMCDT(0,"Code",$$ALPHAUP^SSUTIL4("CYT"),LgHosp,""))  //HospID->LgHosp
	Q:mID="" "{total:0,rows:[]}" //hxy 2020-05-28 "{total:0,rows:[]}"
	
	q:'$d(^DHCEMCDA(0,"HospUser",HospID)) "{total:0,rows:[]}" //hxy 2020-05-28
	
	s ListTitle="userID^userCode^userName^ProvType"
	s itmID=""
	F  s itmID=$o(^DHCEMCDI(0,"Type",mID,itmID)) Q:itmID=""  D
	.Q:$p(^DHCEMCDI(itmID),"^",3)'="Y"
	.s itmCode=$p(^DHCEMCDI(itmID),"^",1)  //项目代码
	.s itmDesc=$p(^DHCEMCDI(itmID),"^",2)  //项目描述
	.s ListTitle=$s(ListTitle="":"T"_itmID,1:ListTitle_"^"_"T"_itmID)
	.

	s userID="",h=0
	F  s userID=$o(^DHCEMCDA(0,"User",userID)) Q:userID=""  D
	.Q:(mUserID'="")&(mUserID'=userID)
	.q:$o(^DHCEMCDA(0,"HospUser",HospID,userID,""))="" //hxy 2020-05-28
	.s userCode=$p(^SSU("SSUSR",userID),"^",1) ///用户工号
	.s userName=$p(^SSU("SSUSR",userID),"^",2) ///用户姓名
	.s CarePrvID=$p(^SSU("SSUSR",userID),"^",14) ///用户
	.s ProvTypeID=$p($g(^CTPCP(+CarePrvID,1)),"^",4)
	.s ProvType=$p($g(^CT("CPT",+ProvTypeID)),"^",4)
	.s ListData=userID_"^"_userCode_"^"_userName_"^"_$E(ProvType,1,3)
	.s itmID=""
	.F  s itmID=$o(^DHCEMCDI(0,"Type",mID,itmID)) Q:itmID=""  D
	..Q:$p(^DHCEMCDI(itmID),"^",3)'="Y"
	..s Flag="否"
	..s itmCode=$p(^DHCEMCDI(itmID),"^",1)  //项目代码
	..s itmDesc=$p(^DHCEMCDI(itmID),"^",2)  //项目描述
	..;i $o(^DHCEMCDA(0,"User",userID,itmID,"")) s Flag="是" //hxy 2021-06-02 st 会诊基础字典界面 不动(本身设计等同绝对私有)改造为 私有
	..i (..getID(userID,itmID,HospID)) s Flag="是" //ed
	..s ListData=$s(ListData="":Flag,1:ListData_"^"_Flag)
	.s h=h+1
	.s TmpItemDet(h)=ListData
	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""
	
	///转换数据为Json格式
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index="",count=0
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

/// Descript:	会诊类型
/// w ##Class(web.DHCEMConsDocAut).jsonConsItem("CYT","2")
ClassMethod jsonConsItem(mCode As %String, HospID As %String) As %String
{
	n (mCode, HospID)
	s HospID=##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("DHC_EmConsDicType",HospID) //hxy 2021-06-02 多院区 add
	s mID=$o(^DHCEMCDT(0,"Code",$$ALPHAUP^SSUTIL4(mCode),HospID,""))
	Q:mID="" "[]" //hxy 2020-05-28 "[]"
	s ListTitle="field^title^width^align"
	w "[["
	s ID="",count=0
	F  s ID=$o(^DHCEMCDI(0,"Type",mID,ID)) Q:ID=""  D
	.s Code=$p(^DHCEMCDI(ID),"^",1)    //代码
	.s Desc=$p(^DHCEMCDI(ID),"^",2)    //描述
	.s ActCode=$p(^DHCEMCDI(ID),"^",3) //可用标志
	.q:ActCode'="Y" //hxy 2020-08-11
	.s ActDesc=$s(ActCode="Y":"是",ActCode="N":"否",1:"")
	.s HospID=$p(^DHCEMCDI(ID),"^",4)  //医院
	.s HospDesc=""
	.s:HospID'="" HospDesc=$p(^CT("HOSP",HospID),"^",2)
	.s mID=$p(^DHCEMCDI(ID),"^",5)    //类型ID
	.s ListData="T"_ID_"^"_Desc_"^140^center"
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.
	w "]]"
	Q ""
}

///  Descript:	根据工号查询用户信息
///  w ##Class(web.DHCEMConsDocAut).JsonUserInfo("15")
ClassMethod JsonUserInfo(userCode As %String, HospID) As %String
{
	n (userCode,HospID)
	s UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userCode),""))
	i UserID="" w "{}"
	Q:UserID="" ""
	i ##class(web.DHCEMCommonUtil).GetHospShowDataFlag("SS_User",UserID,HospID)'="Y" w "{}" //hxy 2020-05-28 st
	Q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("SS_User",UserID,HospID)'="Y" "" //ed
	s DateFrom=$p(^SSU("SSUSR",UserID),"^",96) //hxy 2021-12-22 st 用户过期无法登陆
	s DateTo=$p(^SSU("SSUSR",UserID),"^",97)
	q:(DateFrom'="")&&(+$h<DateFrom) "{}"
	q:(DateTo'="")&&(+$h>DateTo) "{}" 
	s Active=$p($g(^SSU("SSUSR",+UserID)),"^",19) //是否激活
	q:Active'="Y" "{}" //ed
	s UserCode=$p(^SSU("SSUSR",UserID),"^",1) ///用户工号
	s UserName=$p(^SSU("SSUSR",UserID),"^",2) ///用户姓名
	s CarePrvID=$p(^SSU("SSUSR",UserID),"^",14) ///用户
	s ProvTypeID=$p($g(^CTPCP(+CarePrvID,1)),"^",4)
	s ProvType=$p($g(^CT("CPT",+ProvTypeID)),"^",4)
	s ListData=UserID_"^"_UserCode_"^"_UserName_"^"_$E(ProvType,1,3)
 	s ListTitle="UserID^UserCode^UserName^ProvType"
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
 	Q ""
}

/// Creator:      hxy
/// CreateDate:   2021-06-02
/// Descript:	  根据userID、itmID、对应医院HospID取ID
/// w ##class(web.DHCEMConsDocAut).save("12176","1:Y^2:Y^3:N^4:N^5:N^354:N","9")
ClassMethod getID(userID As %String, itmID As %String, HospID As %String) As %String
{
	n (userID,itmID,HospID)
	s ret=""
	s AID=""
	F  s AID=$o(^DHCEMCDA(0,"User",userID,itmID,AID)) Q:AID=""  D
	.s THospID=$p(^DHCEMCDA(AID),"^",3)
	.q:THospID'=HospID
	.s ret=AID
	Q ret
}

}
