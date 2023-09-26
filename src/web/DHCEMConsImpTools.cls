Import sqluser

/// Creator: 	bianshuai
/// CreateDate: 2018-11-07
/// Descript: 	会诊申请工具类
Class web.DHCEMConsImpTools Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:	会诊数据导入导入
/// docaut:		请会诊医生权限维护
/// mar.txt:	请会诊亚专业
/// ind.txt:	请会诊指针 
/// locitm.txt:	科室-亚专业-指针关联关系
/// w ##Class(web.DHCEMConsImpTools).ImportItems("d:\temp\locitm.txt")
ClassMethod ImportItems(filepath As %String) As %String
{
	N (filepath)
	s Num=0,SucNum=0
	Q:filepath="" "-2"
	s del="^"
	o filepath:"RS":2
	u filepath
	s end=0
	d $ZU(68,40,1)
	f  d  q:end'=0
	.R onerow
	.s end=$ZEOF
	.q:end'=0
	.q:onerow=""
	.s mListData=$tr(onerow,$c(9),del)
	.s Num=Num+1
	.//s Err=..ImpDocAut(mListData)    /// 导入请会诊医生权限维护
	.//s Err=..ImpCsMar(mListData)     /// 导入请会诊亚专业
	.//s Err=..ImpCsInd(mListData)     /// 导入请会诊指针
	.s Err=..ImpCsLocItm(mListData)    /// 导入科室-亚专业-指针 关联关系
	.i Err=0 s SucNum=SucNum+1
	c filepath 
	Q "总数："_Num_"成功数："_SucNum
}

/// Descript:  导入请会诊医生权限维护
/// w ##Class(web.DHCEMConsImpTools).ImpDocAut("1^单科会诊^院际会诊")
ClassMethod ImpDocAut(ListData As %String) As %String
{
	n (ListData)
	s userCode=$p(ListData,"^",1)       /// 代码
	s userID=$o(^SSU("SSUSR",0,"CTPCP",userCode,""))
	//s userID=##Class(web.DHCEMInterface).GetUserID(userCode)
	Q:userID="" "-1"
	s mListData=$p(ListData,"^",2,6)   /// 会诊类型串
	s HospID=1  				       /// 医院ID
	s Err=0
	F i=1:1:$L(mListData,"^")  D
	.s itmDesc=$p(mListData,"^",i)     /// 类型描述
	.Q:itmDesc=0
	.s itmID=$o(^DHCEMCDI(0,"Desc",$$ALPHAUP^SSUTIL4(itmDesc),HospID,""))
	.Q:itmID=""
	.s Err=##Class(web.DHCEMConsDocAut).insert(userID, itmID)
	Q Err
}

/// Descript:  导入请会诊亚专业
/// w ##Class(web.DHCEMConsImpTools).ImpCsMar("^^M001^变态反应及皮肤感染")
ClassMethod ImpCsMar(ListData As %String) As %String
{
	n (ListData)
	s Code=$p(ListData,"^",1)       /// 代码
	s Desc=$p(ListData,"^",2)       /// 描述
	Q:$d(^DHCEMCDI(0,"Code",$$ALPHAUP^SSUTIL4(Code),1)) 0
	;Q:$d(^DHCEMCDI(0,"Desc",$$ALPHAUP^SSUTIL4(Desc),1)) 0
	s mListData="^"_Code_"^"_Desc_"^Y^1^8"
	s Err=##class(web.DHCEMConsDicItem).insert(mListData)
	Q Err
}

/// Descript:  导入请会诊指针
/// w ##Class(web.DHCEMConsImpTools).ImpCsInd("^^M001^变态反应及皮肤感染")
ClassMethod ImpCsInd(ListData As %String) As %String
{
	n (ListData)
	s Code=$p(ListData,"^",1)       /// 代码
	s Desc=$p(ListData,"^",2)       /// 描述
	Q:Desc="" ""
	Q:$d(^DHCEMCDI(0,"Code",$$ALPHAUP^SSUTIL4(Code),1)) 0
	;Q:$d(^DHCEMCDI(0,"Desc",$$ALPHAUP^SSUTIL4(Desc),1)) 0
	s mListData="^"_Code_"^"_Desc_"^Y^1^7"
	s Err=##class(web.DHCEMConsDicItem).insert(mListData)
	Q Err
}

/// Descript:  导入科室-亚专业-指针 关联关系
/// w ##Class(web.DHCEMConsImpTools).ImpCsLocItm("4401^^M001^^I0016")
ClassMethod ImpCsLocItm(ListData As %String) As %String
{
	n (ListData)
	s LocCode=$p(ListData,"^",1)       /// 科室代码
	s MarCode=$p(ListData,"^",2)       /// 亚专业代码
	s IndCode=$p(ListData,"^",3)       /// 指针代码
	s LocID=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(LocCode),""))
	Q:LocID="" ""
	s MarID=$o(^DHCEMCDI(0,"Code",$$ALPHAUP^SSUTIL4(MarCode),1,""))
	Q:MarID="" ""
	s IndID=""
	i IndCode'="" s IndID=$o(^DHCEMCDI(0,"Code",$$ALPHAUP^SSUTIL4(IndCode),1,""))
	Q:(IndCode'="")&(IndID="") ""
	s mListData="^"_LocID_"^"_MarID_"^"_IndID
	s Err=##class(web.DHCEMConsLocItem).insert(mListData)
	Q Err
}

Storage Default
{
<Data name="DHCEMConsImpToolsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEMConsImpToolsD</DataLocation>
<DefaultData>DHCEMConsImpToolsDefaultData</DefaultData>
<IdLocation>^web.DHCEMConsImpToolsD</IdLocation>
<IndexLocation>^web.DHCEMConsImpToolsI</IndexLocation>
<StreamLocation>^web.DHCEMConsImpToolsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
