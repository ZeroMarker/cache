Import SQLUser

/// Creator：	Zhouyg
/// CreatDate：	20100311
/// Description:	公共表的相关函数
Class web.DHCSTCOMMO Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Descript:	List符合条件的信息
/// Creater:	Zhouyg
/// CreateDate:	20100311
/// Input:		input-StartRec-开始记录号,RecNum-记录数,Para-参数
/// Output:		PLIST
/// Return：	记录数
ClassMethod GetPList(StartRec As %String, RecNum As %String, Para As %String) As %String
{
 q
 //N (StartRec,RecNum,Para,PLIST)
 K PLIST
 S i=0
 F nn=StartRec:1 Q:RecNum'>0  D
 .S i=i+1
 .S PLIST(i)=^TMP("DHCST",$ZN,Para,nn)
 .S RecNum=RecNum-1
 Q i
}

/// Descript:	kill临时global
/// Creater:	Zhouyg
/// CreateDate:	20100311
/// Input:		Para-参数
ClassMethod KTmpGlobal(Para As %String) As %String
{
 //N (Para)
 K ^TMP("DHCST",$ZN,Para)
 Q
}

/// Creator：	Zhouyg
/// CreatDate：	20100311
/// Description:	按科室类型取科室
/// Table:		CT_Loc
/// Input:		LocType-科室类型,HospDr-医院ID
/// Output:		PLIST-科室ID^科室代码^科室名称
/// Return：		科室数
ClassMethod GetTypeLoc(LocType As %String, HospDr As %String) As %String
{
 //N (LocType,HospDr)
 Q:LocType="" 0
 D ..KTmpGlobal("LOCT")
 D ..KTmpGlobal("OLOCT")
 S LocDr="",i=0
 F  S LocDr=$O(^CTLOC(0,"LocType",LocType,LocDr)) Q:LocDr=""  D
 .S LocHospDr=$P(^CTLOC(LocDr),"^",22)
 .Q:(HospDr'="")&(HospDr'=LocHospDr)
 .S LocCode=$P(^CTLOC(LocDr),"^",1)
 .S LocDesc=$P(^CTLOC(LocDr),"^",2)
 .S i=i+1
 .S ^TMP("DHCST",$ZN,"OLOCT",LocDesc)=LocDr_"^"_LocCode_"^"_LocDesc
 S nn=0
 I i>0 D
 .S LocDesc=""
 .F  S LocDesc=$O(^TMP("DHCST",$ZN,"OLOCT",LocDesc)) Q:LocDesc=""  D
 ..S nn=nn+1
 ..S ^TMP("DHCST",$ZN,"LOCT",nn)=^TMP("DHCST",$ZN,"OLOCT",LocDesc)
 D ..KTmpGlobal("OLOCT")
 Q nn
}

/// Creator：	Zhouyg
/// CreatDate：	20100311
/// Description:	取用户
/// Table:		SS_User
/// Input:		LocDr-科室ID,HospDr-医院ID
/// Output:		PLIST-用户ID^用户代码^用户名称
/// Return：		科室数
ClassMethod GetLocUser(LocDr As %String, HospDr As %String) As %String
{
 //N (LocDr,HospDr)
 D ..KTmpGlobal("USER")
 D ..KTmpGlobal("OUSER")
 S UserDr="0",i=0
 F  S UserDr=$O(^SSU("SSUSR",UserDr)) Q:UserDr=""  D
 .S DefLocDr=$P(^SSU("SSUSR",UserDr),"^",4)
 .Q:(LocDr'="")&(LocDr'=DefLocDr)
 .S LocHospDr=""
 .I DefLocDr'="" D
 ..I $D(^CTLOC(DefLocDr)) S LocHospDr=$P(^CTLOC(DefLocDr),"^",22)
 .Q:(HospDr'="")&(HospDr'=LocHospDr)
 .S UserCode=$P(^SSU("SSUSR",UserDr),"^",1)
 .S UserName=$P(^SSU("SSUSR",UserDr),"^",2)
 .S i=i+1
 .S ^TMP("DHCST",$ZN,"OUSER",UserCode)=UserDr_"^"_UserCode_"^"_UserName
 S nn=0
 I i>0 D
 .S UserCode=""
 .F  S UserCode=$O(^TMP("DHCST",$ZN,"OUSER",UserCode)) Q:UserCode=""  D
 ..S nn=nn+1
 ..S ^TMP("DHCST",$ZN,"USER",nn)=^TMP("DHCST",$ZN,"OUSER",UserCode)
 D ..KTmpGlobal("OUSER")
 Q nn
}

/// Creator：	Zhouyg
/// CreatDate：	20100311
/// Description:	取所有的职称
/// Table:		CT_CarPrvTp
/// Input:		LocDr-科室ID,HospDr-医院ID
/// Output:		PLIST-用户ID^用户代码^用户名称
/// Return：		科室数
ClassMethod GetCarPrvTp() As %String
{
 //N 
 D ..KTmpGlobal("CPT")
 //D KTmpGlobal("OCPT")
 S CptDr="0",i=0
 F  S CptDr=$O(^CT("CPT",CptDr)) Q:CptDr=""  D
 .S CptCode=$P(^CT("CPT",CptDr),"^",1)
 .S CptName=$P(^CT("CPT",CptDr),"^",2)
 .S i=i+1
 .S ^TMP("DHCST",$ZN,"CPT",i)=CptDr_"^"_CptCode_"^"_CptName
 Q i
}

/// Creator：	Zhouyg
/// CreatDate：	20100313
/// Description:	根据职称描述取ID
/// Table:		CT_CarPrvTp
/// Input:		CtpDesc-职称描述
/// Output:		
/// Return：		职称RowID
ClassMethod GetCtpID(CtpDesc As %String) As %String
{
 //N (CtpDesc)
 S CtpDesc=$$ALPHAUP^SSUTIL4(CtpDesc)
 Q:CtpDesc="" ""
 S CptDr=$O(^CT("CPT",0,"Desc",CtpDesc,""))
 Q CptDr
}

/// Descript:检查字符串ListStr以delim分隔的数组里是否包含字符串SubStr
/// Creator：	Zhouyg
/// CreatDate：	2011-03-08
/// Table:		
/// Input:		ListStr-需检查的字符串,SubStr-被搜索的字符串,delim-分隔符
/// Output:
/// Return:0-不存在,其他返回数组位置
ClassMethod FindInList(ListStr As %String, SubStr As %String, delim As %String) As %String
{
 //n (ListStr,SubStr,delim)
 s lenList=$L(ListStr,delim)
 s i=1
 s Ret=0
 f  s TmpStr=$p(ListStr,delim,i) q:(i>lenList)!(Ret'=0)  d
 .i (TmpStr'="")&(SubStr=TmpStr) s Ret=i q
 .s i=i+1
 q Ret
}

/// Descript:	根据科室取DHC_STCustomer信息
/// Creator：	Zhouyg
/// CreatDate：	2011-03-08
/// Table:		ct_loc,DHC_StCustomer
/// Input:		LocID-科室ID
/// Output:		Return
/// Return:		STCUS_RowId^STCUS_ID^STCUS_Desc^STCUS_Flag^STCUS_HOSP_Dr
ClassMethod GetLocCust(LocID As %String) As %String
{
 //N (LocID)
 s RetCust=""
 s HospID=""
 i LocID'="" d
 .S HospID=$P($g(^CTLOC(LocID)),"^",22)
 //判断项目版本
 s ver=##Class(web.DHCSTCOMMPARA).GetSysAppVersion()
 i ver'="" d
 .s RetCust=HospID_"^"_""_"^"_""_"^"_""_"^"_HospID
 q:ver'="" RetCust
 I HospID'="" D
 .S CustID=$O(^STCUS(0,"HOSPID",HospID,"")) //用户所在科室维护了医院则有结果数据
 .Q:CustID=""
 .S RetCust=CustID_"^"_$G(^STCUS(CustID))
 i RetCust="" d
 .S RetCust=##Class(web.DHCSTCUSTOMER).GetCustomerStr() //用户科室未维护医院取默认的医院
 Q RetCust
}

/// Descript:	根据用户ID取DHC_STCustomer信息
/// Creator：	Zhouyg
/// CreatDate：	2011-03-08
/// Table:		ss_user,ct_loc,DHC_StCustomer
/// Input:		用户ID
/// Output:		Return
/// Return:		STCUS_RowId^STCUS_ID^STCUS_Desc^STCUS_Flag^STCUS_HOSP_Dr
ClassMethod GetUserCust(UserID As %String) As %String
{
 //N (UserID)
 Q:UserID="" ""
 S LocID=$P($G(^SSU("SSUSR",UserID)),"^",4)
 S RetCust=..GetLocCust(LocID)	
 //I RetCust="" S RetCust=$$GetCustomerStr^DHCSTCUSTOMER()
 Q RetCust
}

/// Descript:取医院ID(CT_Hospital)
/// CreateDate：2011-03-08
/// Creater：周永刚 
/// Table：	CT_Hospital
/// Input:	医院代码
/// Output:
/// Return:医院ID
ClassMethod GetCtHospID(HospCode As %String) As %String
{
 //N (HospCode)
 S HospCode=$$ALPHAUP^SSUTIL4(HospCode)
 Q:HospCode="" ""
 S HospID=$O(^CT("HOSP",0,"Code",HospCode,""))
 Q HospID
}

/// Descript:取医院信息
/// CreateDate：2011-03-08
/// Creater：周永刚 
/// Table：	CT_Hospital
/// Input:	医院ID
/// Output:
/// Return:医院表信息
ClassMethod GetCtHosp(HospID As %String) As %String
{
 //N (HospID)
 Q:HospID="" ""
 S HospStr=HospID_"^"_$G(^CT("HOSP",HospID))
 Q HospStr
}

/// Descript:	根据CT_Hospital的RowID找DHC_STCustomer的RowID
/// CreateDate：2011-03-16
/// Creater：	周永刚 
/// Table：		DHC_STCustomer
/// Input:		CT_Hospital的RowID
/// Output:
/// Return:		DHC_STCustomer的RowID
ClassMethod GetCusIDByHospID(HospID As %String) As %String
{
 //N (HospID)
 Q:HospID="" ""
 //判断项目版本
 s ver=##Class(web.DHCSTCOMMPARA).GetSysAppVersion()
 q:ver'="" HospID 
 S CustID=$O(^STCUS(0,"HOSPID",HospID,""))
 Q CustID
}

/// Descript:	根据医嘱取科室库存项批次ID的进程
/// CreateDate：2013-07-18
/// Creater：	zhouyg 
ClassMethod NewPidOEInclb() As %String
{
 q $I(^DHCSTPID("OEINCLB"))
}

}
