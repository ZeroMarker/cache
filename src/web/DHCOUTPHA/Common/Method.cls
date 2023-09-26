/// Description:门诊药房公共类方法
/// Creator: 	hulihua
/// CreateDate: 2019-01-28
Class web.DHCOUTPHA.Common.Method Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTOUTPH";

/// Description:获取门诊药房相关参数配置属性
/// Creator：   hulihua
/// CreatDate： 2019-01-28
/// Table：     DHC_StkSysAProp
/// Input：     安全组id,科室id,用户id
/// Output：       
/// Return：	皮试发药标志、配药打印	       
/// Others： 
/// Debug:		w ##class(web.DHCOUTPHA.Common.Method).GetParamProp("142","102","590")
ClassMethod GetParamProp(GroupId As %String, LocId As %String, UserId As %String) As %Library.String
{
    s:LocId'="" hospId=$p(^CTLOC(LocId),"^",22)
    s paramStr=GroupId_"^"_LocId_"^"_UserId_"^"_$g(hospId)
    s appName=..%GetParameter("AppName")
	s needSkinTest=##class(web.DHCST.Common.AppCommon).GetAppPropValue(appName,"SKINTESTFLAG",paramStr)
	s pyPrintType=##class(web.DHCST.Common.AppCommon).GetAppPropValue(appName,"PYPrintType",paramStr)
    s data1=needSkinTest_"^"_pyPrintType
    s data=data1
    q data
}

/// description: 是否不需要走计费缴费发药,本意为先发药后交费
/// 			 目前为急诊留观押金模式、科研用药、体检,绿色通道、免费药发药
/// input:		 Oeori(就诊类型非住院的医嘱Id) 对应处方的任一记录即可
/// return:		 Y(不需要)
/// Debug:		w ##class(web.DHCOUTPHA.Common.Method).GetDispBeforePay()
ClassMethod GetDispBeforePay(Oeori, AdmType = "")
{
	s ordId=+Oeori
	s ordItm=+$p(Oeori,"||",2)
	s recLocId=$p(^OEORD(ordId,"I",ordItm,3),"^",6)
	s hospId=$P(^CTLOC(recLocId),"^",22)
	s payMode=##class(web.DHCSTInterfaceFromElse).IStayPayModeByEpisodeID(hospId)	
	s emLGflag=$p($g(^OEORD(ordId,"I",ordItm,"DHC")),"^",17)							//急诊留观押金模式
	q:(emLGflag="1")&&(payMode="1") "Y"
	s readyToBill=$p($g(^OEORD(ordId,"I",ordItm,12)),"^",26)
	q:readyToBill="Y" "Y"																//先诊疗后收费
	s studyId=$p($g(^OEORD(ordId,"I",ordItm,"DHC")),"^",10)								//科研用药
	q:studyId'="" "Y"
	s admId=$p(^OEORD(ordId),"^",1)
	i AdmType="" d
	.s AdmType=$p(^PAADM(admId),"^",1)
	s payFlag=$p(^OEORD(ordId,"I",ordItm,3),"^",5) 
	q:(AdmType="H")&&(payFlag="P") "Y"													//体检病人并且已经付款
	q:(##class(web.DHCPHACOM.ComInterface.FaceInFromDHC).CheckGreenRec(admId)=1) "Y"	//绿色通道
	s arcimDr=$p($g(^OEORD(ordId,"I",ordItm,1)),"^",2)	
	s freeDrugFlag=##class(web.DHCST.Common.DrugInfoCommon).CheckIfFreeDrug(arcimDr)	//免费药发药
	q:freeDrugFlag="Y" "Y"
	q "N"
}

/// w ##class(web.DHCOUTPHA.Common.Method).GetLocFrUser(578)
ClassMethod GetLocFrUser(userid)
{
	s ret=""
	s ctloc="",ctlocdesc=""
	i userid="" q ret
	s ctloc=+$p(^SSU("SSUSR",userid),"^",4)
	s ctlocdesc=$p($g(^CTLOC(ctloc)),"^",2)
	i ctlocdesc["-" s ctlocdesc=$p(ctlocdesc,"-",2) 
	s lstr=$p($g(^CTLOC(ctloc)),"^",43)
	s ret=ctloc_$C(1)_ctlocdesc
	s GetLocFrUserArr(ctloc)=""
	s othusr="0",th=0
	f  s othusr=$o(^SSU("SSUSR",userid,"OTHLL",othusr)) q:(othusr="")!(othusr="0")  d
	.s loc="",CTDesc=""
	.s loc=+$p(^SSU("SSUSR",userid,"OTHLL",othusr),"^",1)
	.q:loc=0
	.s ctloctype=""
	.s lstr=$p($g(^CTLOC(loc)),"^",43)
	.s ctloctype=$p($g(^CTLOC(loc)),"^",13)
	.q:ctloctype'["D"
	.s CTDesc=$p($g(^CTLOC(loc)),"^",2)
	.i CTDesc["-" s CTDesc=$p(CTDesc,"-",2)
	.q:$d(GetLocFrUserArr(loc))
	.s GetLocFrUserArr(loc)=""
	.i ret'="" s ret=ret_"^"_loc_$C(1)_CTDesc
	.e  s ret=loc_$C(1)_CTDesc
	q ret
}

/// Descript:	通过处方号获取处方置为可退信息
/// Creator:	hulihua
/// Table:		DHC_PHACollected-发药主表
/// CreateDate:	2019-01-09
/// Input:		PrescNo-处方号
/// Output:		
/// Return:     可退标志、置为可退人ID、置为可退人、置为可退日期、置为可退备注
/// Debug 		w ##class(web.DHCOUTPHA.Common.Method).GetPhdAgreeRetInfo("O210302000031")
ClassMethod GetPhdAgreeRetInfo(PrescNo As %String) As %String
{
	q:PrescNo="" ""

	s phdId = +$o(^DHCPHDISPi("PRESCNO", PrescNo, ""),-1)	
	q:(phdId = 0) ""
	s phdData = $g(^DHCPHDISP(phdId,2))
	q:(phdData = "") ""
	s agreeRetFlag=$p(phdData, "^", 18)
	s agreeRetUserDr=$p(phdData, "^", 19)
	s agreeRetDate=$p(phdData, "^", 20)
	s agreeRetTime = $p(phdData, "^", 21)
	s agreeRetRemark = $p(phdData, "^", 22)
	
	s agreeRetName = $p($g(^SSU("SSUSR", +agreeRetUserDr)), "^", 2)
	s agreeRetDate = ##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(agreeRetDate)
	s agreeRetTime = ##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(agreeRetTime)
	s:agreeRetDate'="" agreeRetDate = agreeRetDate_" "_agreeRetTime

	s retStr=agreeRetFlag _"^"_ agreeRetUserDr _"^"_ agreeRetName _"^"_ agreeRetDate _"^"_ agreeRetRemark
	q retStr
}

Storage Default
{
<Data name="MethodDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCOUTPHA.Common.MethodD</DataLocation>
<DefaultData>MethodDefaultData</DefaultData>
<IdLocation>^web.DHCOUTPHA.Common.MethodD</IdLocation>
<IndexLocation>^web.DHCOUTPHA.Common.MethodI</IndexLocation>
<StreamLocation>^web.DHCOUTPHA.Common.MethodS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
