Import SQLUser

Class web.DHCPE.PreGTeamNew Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 118;

/// d ##class(%ResultSet).RunQuery("web.DHCPE.PreGTeam","SearchGTeam",8)
Query SearchGTeam(ParRef As %String = "") As %Query(ROWSPEC = "PGT_ParRef:%String, PGT_RowId:%String, PGT_ChildSub:%String, PGT_ParRef_Name:%String, PGT_Desc:%String, PGT_Sex:%String, PGT_Sex_Desc:%String, PGT_UpperLimit:%String, PGT_LowerLimit:%String, PGT_Married:%String, PGT_Married_Desc:%String, PGT_UpdateUser_DR:%String, PGT_UpdateUser_DR_Name:%String, PGT_UpdateDate:%String, PGT_AddOrdItem:%String, PGT_AddOrdItemLimit:%String, PGT_AddOrdItemAmount:%String, PGT_AddPhcItem:%String, PGT_AddPhcItemLimit:%String, PGT_AddPhcItemAmount:%String, PGT_GReportSend:%String, PGT_GReportSend_Name:%String, PGT_IReportSend:%String, PGT_IReportSend_Name:%String, PGT_DisChargedMode:%String, PGT_DisChargedMode_Name:%String, PGT_BookDateBegin:%String, PGT_BookDateEnd:%String, PGT_BookTime:%String, PGT_PEDeskClerk_DR:%String, PGT_PEDeskClerk_DR_Name:%String,TTotalPerson:%String")
{
}

ClassMethod SearchGTeamExecute(ByRef qHandle As %Binary, ParRef As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)

 	s ind=1
 	s id="0"
 	i ""'=ParRef  d
	.f  s id=$O(^DHCPEPreGADM(ParRef,"Team",id)) q:id=""  d
	..s CurData=$g(^DHCPEPreGADM(ParRef,"Team",id))
	..s ParRefName=""
	..
	..s iLLoop=1
	..// 1 PGT_Desc	分组名称 
	..s PGTDesc=$p(CurData,"^",iLLoop)
	..s iLLoop=iLLoop+1
	..
	..// 17 PGT_BookDateBegin
	..s PGTBookDateBegin = $p(CurData,"^",iLLoop)
	..i (""'=PGTBookDateBegin) s PGTBookDateBegin=$ZD(PGTBookDateBegin,4)
	..s iLLoop=iLLoop+1 
	..
	..
	..// 18 PGT_BookDateEnd
	..s PGTBookDateEnd=$p(CurData,"^",iLLoop)
	..i ""'=PGTBookDateEnd s PGTBookDateEnd=$ZD(PGTBookDateEnd,4)
	..s iLLoop=iLLoop+1
	..
	..// 19 PGT_BookTime	预约时间
	..s PGTBookTime=$p(CurData,"^",iLLoop)
	..i ""'=PGTBookTime s PGTBookTime=$ZT(PGTBookTime,2)
	..s iLLoop=iLLoop+1
	..
	..// 20 PGT_PEDeskClerk_DR	
	..s PGTPEDeskClerkDR=$p(CurData,"^",iLLoop)
	..// 20 PGT_PEDeskClerk_DR_Name	
	..s PGTPEDeskClerkDR=$p(CurData,"^",iLLoop)
	..i (""'=PGTPEDeskClerkDR)  d // 7
  	...s PGTPEDeskClerkDRName=$p($g(^SSU("SSUSR",PGTPEDeskClerkDR)),"^",2)
	..e  d
	...s PGTPEDeskClerkDRName=""
	..s iLLoop=iLLoop+1
	..
	..// 8 PGT_AddOrdItem	公费加项 
	..s PGTAddOrdItem=$p(CurData,"^",iLLoop)
	..s iLLoop=iLLoop+1
	..
	..// 9 PGT_AddOrdItemLimit	加项金额限制 
	..s PGTAddOrdItemLimit=$p(CurData,"^",iLLoop)
	..s iLLoop=iLLoop+1
	..
	..// 10 PGT_AddOrdItemAmount	公费加项金额 
	..s PGTAddOrdItemAmount=$p(CurData,"^",iLLoop)
	..s iLLoop=iLLoop+1
	..
	..// 11 PGT_AddPhcItem	允许加药 
	..s PGTAddPhcItem=$p(CurData,"^",iLLoop)
	..s iLLoop=iLLoop+1
	..
	..// 12 PGT_AddPhcItemLimit	加药金额限制 
	..s PGTAddPhcItemLimit=$p(CurData,"^",iLLoop)
	..s iLLoop=iLLoop+1
	..
	..// 13 PGT_AddPhcItemAmount	允许加药金额 
	..s PGTAddPhcItemAmount=$p(CurData,"^",iLLoop)
	..s iLLoop=iLLoop+1
	..
	..// 2 PGT_Sex	性别
	..s PGTSex=$p(CurData,"^",iLLoop)
	..s PGTSexDesc=""
	..i ("Male"=PGTSex)||("M"=PGTSex) s PGTSexDesc="男"
	..i ("Female"=PGTSex)||("F"=PGTSex) s PGTSexDesc="女"
	..i ("No"=PGTSex)||("N"=PGTSex) s PGTSexDesc="不限"
	..
	..s iLLoop=iLLoop+1
	..// 3 PGT_UpperLimit	年龄上限
	..s PGTUpperLimit=$p(CurData,"^",iLLoop)
	..
	..s iLLoop=iLLoop+1
	..// 4 PGT_LowerLimit	年龄下限
	..s PGTLowerLimit=$p(CurData,"^",iLLoop)
	..
	..s iLLoop=iLLoop+1
	..// 5 PGT_Married	婚姻状况
	..s PGTMarried=$p(CurData,"^",iLLoop)
	..s PGTMarriedDesc=""
	..i ("Unmarried"=PGTMarried)||("UM"=PGTMarried) s PGTMarriedDesc="未婚"
	..i ("Married"=PGTMarried)||("M"=PGTMarried) s PGTMarriedDesc="已婚"
	..i ("Married"=PGTMarried)||("N"=PGTMarried) s PGTMarriedDesc="不限"
	
	..s PGTDisChargedMode=$p(CurData,"^",19)
	..s CurData=$g(^DHCPEPreGADM(ParRef))
	..	
	..// 14 PGT_GReportSend	团体报告发送 
	..s PGTGReportSend=$p(CurData,"^",14)
	..s:(""'=PGTGReportSend) PGTGReportSendName =##Class(web.DHCPE.PreCommon).TransGReportSend(PGTGReportSend)
	..s:(""=PGTGReportSend) PGTGReportSendName = ""
	..s iLLoop=iLLoop+1
	..
	..// 15 PGT_IReportSend	个人报告发送 
	..s PGTIReportSend=$p(CurData,"^",15)
	..s:(""'=PGTIReportSend) PGTIReportSendName =##Class(web.DHCPE.PreCommon).TransIReportSend(PGTIReportSend)
	..s:(""=PGTIReportSend) PGTIReportSendName = ""
	..s iLLoop=iLLoop+1
	..
	..// 16 PGT_DisChargedMode	结算方式 
	..s:PGTDisChargedMode="" PGTDisChargedMode=$p(CurData,"^",16)
	..s:(""'=PGTDisChargedMode) PGTDisChargedModeName =##Class(web.DHCPE.PreCommon).TransDisChargedMode(PGTDisChargedMode)
	..s:(""=PGTDisChargedMode) PGTDisChargedModeName = ""
	..s iLLoop=iLLoop+1
	..
	..//取得站点名称
	..s CurData=$g(^DHCPEST(ParRef))
	..s iParRefName=$p(CurData,"^",2)
	..s Person=..GetTotalPersonByItem(ParRef_"||"_id)
	..s TTotalPerson="共"_+Person_"人,已检"_$p(Person,"^",2)_"人"
	..s CancelPerson=$p(Person,"^",3)
	..i CancelPerson'=0 s TTotalPerson=TTotalPerson_",取消"_$p(Person,"^",3)_"人"
	..//s THadCheckTotal=$p(Person,"^",2)
    ..d Build	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build
	//			PGT_ParRef, PGT_RowId, PGT_ChildSub, PGT_ParRef_Name, PGT_Desc, PGT_Sex, PGT_UpperLimit, PGT_LowerLimit, PGT_Married, PGT_Married_Desc ,PGT_UpdateUser_DR, PGT_UpdateUser_DR_Name, PGT_UpdateDate
	set Data=$lb(ParRef, ParRef_"||"_id, id, ParRefName, PGTDesc, PGTSex, PGTSexDesc, PGTUpperLimit, PGTLowerLimit, PGTMarried, PGTMarriedDesc, PGTUpdateUserDR, PGTUpdateUserDRName, PGTUpdateDate, PGTAddOrdItem, PGTAddOrdItemLimit, PGTAddOrdItemAmount, PGTAddPhcItem, PGTAddPhcItemLimit, PGTAddPhcItemAmount, PGTGReportSend, PGTGReportSendName, PGTIReportSend, PGTIReportSendName, PGTDisChargedMode, PGTDisChargedModeName, PGTBookDateBegin, PGTBookDateEnd, PGTBookTime, PGTPEDeskClerkDR, PGTPEDeskClerkDRName,TTotalPerson)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchGTeamFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchGTeamExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchGTeamClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchGTeamExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 存在已执行医嘱就算是一个已检人员
ClassMethod GetTotalPersonByItem(id)
{
	new i,j,k,Status
	s i=0
	s j=0
	s k=0
	S m=0
	s iAdm=0
	f  s iAdm=$o(^DHCPEPreIADM(0,"PGTeam",id,iAdm)) q:iAdm=""  d
	.s Status=$p(^DHCPEPreIADM(iAdm),"^",8)
	.q:Status="CANCELPE"
	.s i=i+1
	.i Status="CANCELPREREG" s k=k+1
	.i Status="CANCELPE"  S m=m+1
	.s PEIADM=$o(^DHCPEIADM(0,"CRMADM",iAdm,0))
	.q:PEIADM=""
	.s PAADM=$p($G(^DHCPEIADM(PEIADM)),"^",1)
	.q:PAADM=""
	.//q:..OrderIsExecByPAAdm(PAADM)=0 //存在已执行项目即算是已检
	.s RLTDR=$o(^DHCPERLT(0,"ADM",PAADM,0))
	.q:RLTDR=""
	.s j=j+1
	q i_"^"_j_"^"_k_"^"_m
}

/// 判断一个人的医嘱是否存在已经执行的
ClassMethod OrderIsExecByPAAdm(ADM)
{
	new flag,sub,stat
	s flag=0
	s OEOrdId=$o(^OEORD(0,"Adm",ADM,0))
	q:OEOrdId="" flag
	s sub=0
	f  s sub=$o(^OEORD(OEOrdId,"I",sub)) q:(sub="")||(flag=1)  d
	.s stat=$p($G(^OEORD(OEOrdId,"I",sub,1)),"^",13)
	.q:stat="4"
	.s:stat="6" flag=1
	q flag
}

/// 增加组的成员
/// d ##Class(web.DHCPE.PreGTeam).AppendIADM("","","")
ClassMethod AppendIADM(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	//验证新增人员是否符合组的条件 
	// 个人基本信息表DHC_PE_PreIBaseInfo
	s PIBIDR=$p(InString,"^",1)
	// 团体分组表 DHC_PE_PreGTeam
	s PGTeamDR=$p(InString,"^",3)

	s CurData=$G(^DHCPEPreGADM(PGTRowId,"Team", PGTChildSub))


	s PGTSex=+$P(CurData,"^",2)
	s PGTUpperLimit=+$P(CurData,"^",3)
	s PGTLowerLimit=$P(CurData,"^",4)
	s PGTMarried=$P(CurData,"^",5)

	//	DHC_PE_PreIBaseInfo.{PIBI_Sex_DR}	性别
	s PIBISexDR=$p($g(^DHCPEPreIBI(PIBIDR)),"^",3)
	
	//	DHC_PE_PreIBaseInfo.{PIBI_DOB}	生日
	s PIBIDOB=$p($g(^DHCPEPreIBI(PIBIDR)),"^",4)

	// DHC_PE_PreIBaseInfo.{PIBI_Married_DR }
	s PIBIDOB=$p($g(^DHCPEPreIBI(PIBIDR)),"^",17)
	
	
	s ret=##Class(web.DHCPE.PreIADM).Save(itmjs,itmjsex,InString)
}

// **********************************************************************

/// w ##class(web.DHCPE.PreGTeam).GetPreGTeam(8,2,"^")
ClassMethod GetPreGTeam(ParRef As %Library.String = "", Childsub As %Library.String = "", Delim As %Library.String = "")
{
	new DataStr,OneData,UserName,GlobalLength
	s GlobalLength=18
	i ""=Delim s Delim="^"
	
	//PGT_PGBI_DR DHC_PE_PreGADM
	s PGTPGBIDR=$p($G(^DHCPEPreGADM(ParRef)),"^",1)
	// DHC_PE_PreGBaseInfo
	s ParRefName=$p($G(^DHCPEPreGBI(PGTPGBIDR)),"^",2)
	
	s DSMode=""
	i ""=ParRefName d
	.s CurData=""	//没有对应的团体
	e  d
	.s CurData=$G(^DHCPEPreGADM(ParRef,"Team",Childsub))
	.s DSMode=$p(CurData,"^",19)
	.s CurData=$p(CurData,"^",1,GlobalLength)
	s id=ParRef_"||"_Childsub
	s DataStr=ParRef_"^"_id_"^"_Childsub
	
	i ""'=CurData
	{
		i $p(CurData,"^",2)'="" s $p(CurData,"^",2)=$ZD($p(CurData,"^",2),4)
		i $p(CurData,"^",3)'="" s $p(CurData,"^",3)=$ZD($p(CurData,"^",3),4)
		i $p(CurData,"^",4)'="" s $p(CurData,"^",4)=$ZT($p(CurData,"^",4),2)
		s DataStr=DataStr_"^"_CurData
		s DataStr=DataStr_"^"_ParRefName
		s GADMInfo=$g(^DHCPEPreGADM(ParRef))
		s DataStr=DataStr_"^"_$p(GADMInfo,"^",14)
		s DataStr=DataStr_"^"_$p(GADMInfo,"^",15)
		i DSMode="" s DSMode=$p(GADMInfo,"^",16)
		s DataStr=DataStr_"^"_DSMode //$p(GADMInfo,"^",16)
		s UserName=$p(CurData,"^",5)
		i UserName'="" s UserName=$p($G(^SSU("SSUSR",UserName)),"^",2)
		s DataStr=DataStr_"^"_UserName
		s VipLevel=$g(^DHCPECBVIPLevel("PGT",id))
		s DataStr=DataStr_"^"_VipLevel
		s TeamLevel=$g(^DHCPEDataEx("DHCPEPreGADM","TeamLevel",id))
		s DataStr=DataStr_"^"_TeamLevel
		s ADMFeeTypes=$g(^DHCPEDataEx("DHCPEPreGADM","ADMFeeType",id))
		s DataStr=DataStr_"^"_ADMFeeTypes
		s NoInclude=$g(^DHCPEDataEx("DHCPEPreGTeam","NoInclude",id))
		s DataStr=DataStr_"^"_NoInclude
	}
	else
	{
		s DataStr=""
	}
	q DataStr
}

/// 获取团体信息
/// test w ##Class(web.DHCPE.PreGTeam).DocListBroker("","","5^^4")
ClassMethod DocListBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	s ParRef=$p(InString,"^",1)
	s RowId=$p(InString,"^",2)
	s Childsub=$p(InString,"^",3)
	Q:(""=Childsub) ""
	i (""'=ParRef)||(""'=Childsub)  d
	.s Data=..GetPreGTeam(ParRef,Childsub,"^")
	e  d
	.s Data="0^"_ParRef_"^"_Childsub_"^"_"未找到记录"
	i ""'=itmjs d
	.s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	.&javascript<#(retval)#>
	q Data
}

/// 功能	验证团体组成员是否符合团体组的限制条件
/// 使用	##class(web.DHCPE.PreIBIUpdate).ISave()
/// 测试 w ##class(web.DHCPE.PreGTeam).IsValidGTeamIADM(3152,"35||7")
ClassMethod IsValidGTeamIADM(PIBIDR As %String = "", PGTeamDR As %String = "")
{
	Q:(""=PIBIDR)&(""=PGTeamDR) "0"
	
	s ParRef=$P(PGTeamDR,"||",1)
	s Childsub=$P(PGTeamDR,"||",2)
	s TCurData=$G(^DHCPEPreGADM(ParRef,"Team",Childsub))

	s ICurData=$g(^DHCPEPreIBI(PIBIDR))  

	s ret=""
	// 2 PGT_Sex	性别
	s PGTSex = $p(TCurData,"^",12)
	i '((""=PGTSex)||("N"=PGTSex)||("No"=PGTSex)) d
	.//	PIBI_Sex_DR	性别
	.s PIBISexDR=$p(ICurData,"^",3)  
	.i (""=PIBISexDR) s ret="No Valid Sex"
	.//CT_Sex	CTSEX_Desc
	.s PIBISexDRName=$p($G(^CT("SEX",PIBISexDR)),"^",2)
	.i ((("Female"=PGTSex)||("F"=PGTSex))&(PIBISexDRName'["女")) s ret="Sex Err"
	.i ((("Male"=PGTSex)||("M"=PGTSex))&(PIBISexDRName'["男")) s ret="Sex Err "
	Q:(""'=ret) ret
	
	// 3 PGT_UpperLimit	年龄上限
	s PGTUpperLimit = $p(TCurData,"^",13)
	// 4 PGT_LowerLimit	年龄下限
	s PGTLowerLimit = $p(TCurData,"^",14)
	
	
	//	PIBI_DOB	生日
	s PIBIDOB=$p(ICurData,"^",4)
	i (""'=PIBIDOB) d
 	.s PIBIDOB=##class(web.DHCLCNUREXCUTE).CalAge(PIBIDOB,+$h)
 	.s PIBIDOB=+$P(PIBIDOB,"Y",1)
	
	i (""'=PGTLowerLimit)&(""'=PIBIDOB)&(+PIBIDOB<+PGTLowerLimit) s ret="LowerLimit Err"
	i (""'=PGTUpperLimit)&(""'=PIBIDOB)&(+PIBIDOB>+PGTUpperLimit) s ret="UpperLimit Err"
	Q:(""'=ret) ret

	// 5 PGT_Married	婚姻状况
	s PGTMarried = $p(TCurData,"^",15)
	i '((""=PGTMarried)||("N"=PGTMarried)||("No"=PGTMarried)) d
	.//	PIBI_Married	婚姻状况
	.s PIBIMarriedDR=$p(ICurData,"^",17)
	.i ""=PIBIMarriedDR s ret="No Valid Married "
	.q:PIBIMarriedDR=""
	.//CT_Marital	CTMAR_Desc
	.s PIBIMarriedDRName=$p($G(^CT("MAR",PIBIMarriedDR)),"^",2)
	.i ((("Unmarried"=PGTMarried)||("UM"=PGTMarried))&(PIBIMarriedDRName'["未婚")) s ret="Married Err"
	.i ((("Married"=PGTMarried)||("M"=PGTMarried))&(PIBIMarriedDRName'["已婚")) s ret="Married Err"
	Q:(""'=ret) ret
	Q ""
}

/// 生成一个页面元素　显示当前的团体组列表 使用组件 DHCPEPreIADM.Team
ClassMethod GTeamList(ParRef As %Library.String = "", width As %Library.String = "") As %String
{
	//下拉列表
	w "<select name='GTeamList' id='GTeamList' style='width:"_width_"' HEIGHT=0>",!
	w "<option value=>  </option>",!
	
	s id=0	
	f  s id=$O(^DHCPEPreGADM(ParRef,"Team",id)) q:id=""  d
	.s CurData=$g(^DHCPEPreGADM(ParRef,"Team",id))
	.s iLLoop=1
	.// PGT_Desc	分组名称 
	.s PGTDesc=$p(CurData,"^",iLLoop)
	.
	.d OutputList
		
	w "</select>",!
	Quit $$$OK
	
OutputList
	w "<option value="_ParRef_"||"_$G(id)_">"_PGTDesc_"</option>",!
 	q
}

/// 辅助函数 取得团体组的预约时间或者日期 使用组件 DHCPEPreIADM.Team.PEDate (1) DHCPEPreIADM.Team.PETime (2)
/// w ##Class(web.DHCPE.PreGTeam).GetGTeamBook("","","5||4^Date")
ClassMethod GetGTeamBook(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	s RowId=$P(InString,"^",1)
	s BookType=$P(InString,"^",2)
	S ParRef=$P(RowId,"||",1)
	s Childsub=$P(RowId,"||",2)
	s CurData=$G(^DHCPEPreGADM(ParRef,"Team",Childsub))
	s ret=""
	
	i "Date"=BookType d
	.s ret=$p(CurData,"^",8)
	.i ""'=ret s ret=$ZD(ret,4)

	
	i "Time"=BookType d
	.s ret=$p(CurData,"^",9)
	.i ""'=ret s ret=$ZT(ret,2)
	
	Q ret
}

/// 删除函数 
/// test w ##Class(web.DHCPE.PreGTeam).Delete("","","955||4")
ClassMethod Delete(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	s ^sxt("szc")=InString
	;q
	s GTeamRowId=$p(InString,"^",1)
	TStart
	i ($d(^DHCPEPreIADM(0,"PGTeam",GTeamRowId)))  d
	.b ;1
	.s ret="2"
	.goto DeleteErr
	e  d
	.
	.&sql( delete from DHC_PE_PreGTeam where PGT_RowId = :GTeamRowId)
	.s ret=SQLCODE
	.b ;2
	.;w "ret:"_ret,!
	.i (("0"=ret)||("100"=ret))  d
	..
	.e  d
	..goto DeleteErr
	.	
	.
	.// 删除团体组成员
	.//s ID="3"_"^"_GTeamRowId
	.//s ret=##Class(web.DHCPE.PreIADM).Delete(itmjs,itmjsex,ID)
	i "0"'=ret goto DeleteErr
	/*0331
	// 重新计算团体费用
	s Ret=##Class(web.DHCPE.PreItemList).UpdateAmount(GTeamRowId,"TEAM")
	i ""'=Ret goto DeleteErr
	*/
	TCOMMIT
	q ret

DeleteErr
	TROLLBACK
	q ret
}

/// 提供给Web页面 检验医嘱列表 给DHCPEStationOrderCom组件的“项目编码”查询列表输入框用
/// 更新函数 具有跟新（修改）和插入的功能 
/// d ##Class(web.DHCPE.PreGTeam).Save2("","","8^8||2^2^kkkk^F^25^10^UM^3565^^N^N^^N^N^^AsCharged^GSend^GD^11/03/2007^15/03/2007^11:00^á?oì")
ClassMethod Save2(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	new Data,User,Time,StartDate,EndDate
	s Date=+$H
	s Time=$p($h,",",2)
	s:($d(%session)) User=%session.Get("LOGON.USERID")
	s:'$d(%session) User=5918
	s VipLevel=$p(InString,"^",19)
	s TeamLevel=$p(InString,"^",20)
	s ADMFeeType=$p(InString,"^",21)
	s NoInCludeGroup=$p(InString,"^",22)
	s DSMode=$p(InString,"^",23)
	s RoomPlace=$p(InString,"^",24)
	q:'$d(^DHCPEPreGADM(+InString))   
	i DSMode="" s DSMode=$P(^DHCPEPreGADM(+InString),"^",16)
	for i=0:1:17
	{
		s PLIST(i)=$p(InString,"^",i+1)
	}
	i PLIST(2)="" k PLIST(2)
	
	i PLIST(4)'="" s PLIST(4)=##class(websys.Conversions).DateHtmlToLogical(PLIST(4))
	i PLIST(5)'="" s PLIST(5)=##class(websys.Conversions).DateHtmlToLogical(PLIST(5))

	s StartDate=PLIST(4)
	s EndDate=PLIST(5)
	i StartDate="" s StartDate=0
	i EndDate="" s EndDate=0
	i EndDate<StartDate q "Err Date"
	
	i PLIST(6)'="" s PLIST(6)=$ZTH(PLIST(6),2)
	s PLIST(18)=User
	s PLIST(19)=Date
	s PLIST(20)=Time
	s PLIST(21)=DSMode
	i 0=$D(PLIST(2))
	{
		s SQLCODE=..Insert2()
	}
	else
	{
		s SQLCODE=..Update2()
	}
	q SQLCODE
}

/// 插入新的记录 使用PLIST 实现
ClassMethod Insert2()
{
	k PLIST(1)
	k PLIST(2)
	TSTART
	&SQL(Insert Into SQLUSER.DHC_PE_PreGTeam Values :PLIST())
	i SQLCODE=0
	{
		s GTeamID=$G(%ROWID)
		s ^DHCPECBVIPLevel("PGT",GTeamID)=VipLevel
		s PreGID=+GTeamID
		s GID=$o(^DHCPEGADM(0,"CRMGADM",PreGID,0))
		i GID'=""
		{
			&SQL(insert into SQLUSER.dhc_pe_GTEAM 
			(GT_ParRef, GT_Desc, GT_CRMTeam,GT_AddOrdItem,GT_AddOrdItemLimit,GT_AddOrdItemAmount,GT_AddPhcItem,GT_AddPhcItemLimit,GT_AddPhcItemAmount,GT_Sex,GT_UpperLimit,GT_LowerLimit,GT_Married)
		 select :GID,PGT_Desc,PGT_RowId,PGT_AddOrdItem,PGT_AddOrdItemLimit,PGT_AddOrdItemAmount,PGT_AddPhcItem,PGT_AddPhcItemLimit,PGT_AddPhcItemAmount,PGT_Sex,PGT_UpperLimit,PGT_LowerLimit,PGT_Married
		  from SQLUSER.DHC_PE_PreGTeam
		   Where PGT_RowId=:GTeamID )
		}
		s ^DHCPEDataEx("DHCPEPreGADM","TeamLevel",GTeamID)=TeamLevel
		s ^DHCPEDataEx("DHCPEPreGADM","ADMFeeType",GTeamID)=ADMFeeType
		s ^DHCPEDataEx("DHCPEPreGTeam","NoInclude",GTeamID)=$G(NoInCludeGroup)
		s ^DHCPEDataEx("DHCPEPreGTeam","RoomPlace",GTeamID)=$G(RoomPlace)
		d ##class(web.DHCPE.GAdmRecordManager).Insert(PreGID,"P","TeamInsert",PLIST(18),GTeamID) 
	}
	i SQLCODE'=0
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	
	q SQLCODE
}

/// 更改数据 使用PLIST 实现
ClassMethod Update2()
{
	new tOldInfo,RowId,iAdm
	s RowId=PLIST(1)
	s tOldInfo=$G(^DHCPEPreGADM(PLIST(0),"Team",PLIST(2)))
	
	s OldVipLevel=$G(^DHCPECBVIPLevel("PGT",RowId))
	s ADMTypeChangeFlag=""
	s ADMTypeChangeFlag=##class(web.DHCPE.PreGADM).GetADMTypeChargedFlag(RowId,ADMFeeType,"T")
	Q:ADMTypeChangeFlag'="" ADMTypeChangeFlag
	TStart
	k PLIST(0)
	k PLIST(1)
	k PLIST(2)
	s SQLCODE=0
	i $p(tOldInfo,"^",19)'=PLIST(21) d
	.s SQLCODE=##class(web.DHCPE.PreGADM).UpdateChargedMode(+RowId, PLIST(21),RowId)
	s ret=SQLCODE
	i '(("0"=ret)||("100"=ret)) goto UpdateErr
	
	
	&SQL(Update SQLUSER.DHC_PE_PreGTeam Values :PLIST() 
		where PGT_RowId = :RowId)
	s ret=SQLCODE
	i '(("0"=ret)||("100"=ret)) goto UpdateErr
	i (OldVipLevel'=VipLevel)||($p(tOldInfo,"^",19)'=PLIST(21)) d
	.&SQL(update sqluser.DHC_PE_PreIADM set PIADM_Vip=:VipLevel,PIADM_DisChargedMode=:PLIST(21) where PIADM_PGTeam_DR=:RowId)
	s ret=SQLCODE
	i '(("0"=ret)||("100"=ret)) goto UpdateErr
	s ^DHCPECBVIPLevel("PGT",RowId)=VipLevel
	s ^DHCPEDataEx("DHCPEPreGADM","TeamLevel",RowId)=TeamLevel
	s OldGTADMFeeType=^DHCPEDataEx("DHCPEPreGADM","ADMFeeType",RowId)
	s ^DHCPEDataEx("DHCPEPreGADM","ADMFeeType",RowId)=ADMFeeType
	s ^DHCPEDataEx("DHCPEPreGTeam","NoInclude",RowId)=$G(NoInCludeGroup)
	s ^DHCPEDataEx("DHCPEPreGTeam","RoomPlace",RowId)=$G(RoomPlace)
	s GTeamID=RowId
	s PreGID=+GTeamID
	s GID=$o(^DHCPEGADM(0,"CRMGADM",PreGID,0))
	i GID'=""
	{
		s GTLIST(3)=PLIST(3)
		s GTLIST(5)=PLIST(8)
		s GTLIST(6)=PLIST(9)
		s GTLIST(7)=PLIST(10)
		s GTLIST(8)=PLIST(11)
		s GTLIST(9)=PLIST(12)
		s GTLIST(10)=PLIST(13)
		s GTLIST(11)=PLIST(14)
		s GTLIST(12)=PLIST(15)
		s GTLIST(13)=PLIST(16)
		s GTLIST(14)=PLIST(17)
		&SQL(update sqluser.dhc_pe_gteam values :GTLIST() where GT_CRMTeam=:GTeamID)
	}
	s ret=SQLCODE
	i '(("0"=ret)||("100"=ret)) goto UpdateErr
	
	s ret=..GTeamUpdateDate(RowId,tOldInfo)
	i '(("0"=ret)||("100"=ret)) goto UpdateErr	
	s ret=0
	s OldLimitFee=$p(tOldInfo,"^",8)
	s OldAddOrdItem=$p(tOldInfo,"^",6)
	i OldLimitFee'=PLIST(10)||(OldAddOrdItem'=PLIST(8)) d
	.s iAdm=0
	.f  s iAdm=$o(^DHCPEPreIADM(0,"PGTeam",RowId,iAdm)) q:(iAdm="")||(SQLCODE'=0)  d
	..s SQLCODE=##class(web.DHCPE.PreAudit).UpdateFeeRecord(iAdm,"LimitFee")
	.q:SQLCODE
	.s ret=##class(web.DHCPE.PreIADM).UpdateGroupAuditAmount(+RowId)
	i ("0"'=ret) goto UpdateErr
	//修改就诊类型处理个人和团体费用
	//修改个人体检者项目或套餐对应的就诊类型
	i OldGTADMFeeType'=ADMFeeType  d
    .s SQLCODE=##class(web.DHCPE.PreIADM).UpdateItemFeeType(RowId,"TEAM",ADMFeeType)
	TCOMMIT
	Q 0
UpdateErr
	TROLLBACK
	Q ret
}

/// 当团体组更改预约时间，更新其下所有成员的预约时间
ClassMethod GTeamUpdateDate(RowID, tOldInfo)
{
	new Date,Time,User,tInfo,GADM,tSub,iADM,iPLIST
	new EndDate,DelayDate,PEDeskClerk
	new tEndDate,tOldEndDate,tPEDeskClerk,tOldPEDeskClerk
	s SQLCODE=0
	s (EndDate,PEDeskClerk)=0
	s Date=+$H
	s Time=$p($H,",",2)
	s User=%session.Get("LOGON.USERID")
	s GADM=$p(RowID,"||",1)
	s tSub=$p(RowID,"||",2)
	s tInfo=$G(^DHCPEPreGADM(GADM,"Team",tSub))
	s tEndDate=$p(tInfo,"^",3)
	i tEndDate="" s tEndDate=0
	s tOldEndDate=$p(tOldInfo,"^",3)
	i tOldEndDate="" s tOldEndDate=0
	i tEndDate'=tOldEndDate s EndDate=1
	s tPEDeskClerk=$p(tInfo,"^",5)
	s tOldPEDeskClerk=$p(tOldInfo,"^",5)
	i tPEDeskClerk'=tOldPEDeskClerk s PEDeskClerk=1
	s OldLimitFee=$p(tOldInfo,"^",8)
	s OldLimit=$p(tOldInfo,"^",6)
	s iADM=0
	f  s iADM=$o(^DHCPEPreIADM(0,"PGTeam",RowID,iADM)) q:(iADM=""||SQLCODE'=0)  d
	.k iPLIST
	.s iInfo=$g(^DHCPEPreIADM(iADM))
	.s iPLIST(5)=..GetInfoByOrder(tInfo,2) //BeginDate
	.s iEndDate=..GetInfoByOrder(iInfo,5)
	.i iEndDate="" s iEndDate=0
	.i (iEndDate<tEndDate)&&(1=EndDate) s iPLIST(6)=tEndDate //EndDate
	.s iPEDeskClerk=..GetInfoByOrder(iInfo,7)
	.i (tPEDeskClerk'=iPEDeskClerk)&&(1=PEDeskClerk) s iPLIST(8)=tPEDeskClerk
	.if (OldLimitFee'=..GetInfoByOrder(tInfo,8)||(OldLimit'=..GetInfoByOrder(tInfo,6)))  d
	..s iPLIST(11)=..GetInfoByOrder(tInfo,6)
	..s iPLIST(12)=..GetInfoByOrder(tInfo,7)
	..s iPLIST(13)=..GetInfoByOrder(tInfo,8)
	.s iPLIST(14)=..GetInfoByOrder(tInfo,9)
	.s iPLIST(15)=..GetInfoByOrder(tInfo,10)
	.s iPLIST(16)=..GetInfoByOrder(tInfo,11)
	.
	.s iPLIST(23)=Date
	.s iPLIST(22)=User
	.s iPLIST(24)=Time
	.&SQL(update sqluser.DHC_PE_PreIADM values :iPLIST() where PIADM_RowId=:iADM)
	.i SQLCODE=0  d
	..s ADMFeeType=$g(^DHCPEDataEx("DHCPEPreGADM","ADMFeeType",RowID))
	..s ^DHCPEDataEx("DHCPEPreIADM","ADMFeeType",iADM)=ADMFeeType
	q SQLCODE
	
	
	
	q 0
	s CurData=$G(^DHCPEPreGADM(PLIST(0),"Team",PLIST(2)))
	s OBookDate=$p(CurData,"^",8)	//	旧预约日期
	s OBookTime=$p(CurData,"^",9)	//	旧预约时间
	
	s UBookDate=PLIST(10)			//	新预约日期
	s UBookTime=PLIST(11)			//	新预约时间
	s ret="0"
	i OBookDate'=UBookDate d
	.&sql(update DHC_PE_PreIADM
		set PIADM_BookDateBegin = :UBookDate
		where PIADM_PGTeam_DR = :RowId
		)
	.s ret=SQLCODE
	Q:('(("0"=ret)||("100"=ret))) ret
	
	s ret="0"
	i OBookTime'=UBookTime d
	.&sql(update DHC_PE_PreIADM
		set PIADM_BookTime = :UBookTime
		where PIADM_PGTeam_DR = :RowId
		)
	.s ret=SQLCODE
	Q ret
}

ClassMethod GetInfoByOrder(Info, Order)
{
	i Info="" q ""
	q $p(Info,"^",Order)
}

ClassMethod GTeamUpdateDateOld()
{
	q 0
	s CurData=$G(^DHCPEPreGADM(PLIST(0),"Team",PLIST(2)))
	s OBookDate=$p(CurData,"^",8)	//	旧预约日期
	s OBookTime=$p(CurData,"^",9)	//	旧预约时间
	
	s UBookDate=PLIST(10)			//	新预约日期
	s UBookTime=PLIST(11)			//	新预约时间
	s ret="0"
	i OBookDate'=UBookDate d
	.&sql(update DHC_PE_PreIADM
		set PIADM_BookDateBegin = :UBookDate
		where PIADM_PGTeam_DR = :RowId
		)
	.s ret=SQLCODE
	Q:('(("0"=ret)||("100"=ret))) ret
	
	s ret="0"
	i OBookTime'=UBookTime d
	.&sql(update DHC_PE_PreIADM
		set PIADM_BookTime = :UBookTime
		where PIADM_PGTeam_DR = :RowId
		)
	.s ret=SQLCODE
	Q ret
}

/// 提供给团体分组，团体的预约信息
/// w ##Class(web.DHCPE.PreGTeam).GetPreGTeamInfor("8||1")
ClassMethod GetPreGTeamInfor(id As %Library.String = "")
{
	Q:(""=id) ""
	s ParRef=$P(id,"||",1)
	s id=$P(id,"||",2)
	s CurData=$g(^DHCPEPreGADM(ParRef,"Team",id))

	s Data=""
	
	i ""'=CurData  d
	.
	.// PGT_Desc
	.s PGTDesc = $p(CurData,"^",1)
	.
	.// PGT_PEDeskClerk_DR 预约接待人员
	.s PGTPEDeskClerkDR = $p(CurData,"^",20)
	.i (""'=PGTPEDeskClerkDR)  d // 15.1
  	..s PGTPEDeskClerkDRName=$p($g(^SSU("SSUSR",PGTPEDeskClerkDR)),"^",2)
	.e  d    		
	..s PGTPEDeskClerkDRName=""
	.
	.// PGT_AddOrdItem	允许加项
	.s PGTAddOrdItem=$p(CurData,"^",8)
	.
	.// PGT_AddOrdItemLimit	加项金额限制
	.s PGTAddOrdItemLimit=$p(CurData,"^",9)
	.
	.// PGT_AddOrdItemAmount	允许加项金额
	.s PGTAddOrdItemAmount=$p(CurData,"^",10)
	.
	.// PGT_AddPhcItem	允许加药
	.s PGTAddPhcItem=$p(CurData,"^",11)
	.
	.// PGT_AddPhcItemLimit	加药金额限制
	.s PGTAddPhcItemLimit=$p(CurData,"^",12)
	.
	.// PGT_AddPhcItemAmount	允许加药金额 
	.s PGTAddPhcItemAmount=$p(CurData,"^",13)
	.
	.// PGT_GReportSend	团体报告发送
	.s PGTGReportSend=$p(CurData,"^",14)
	.s:(""'=PGTGReportSend) PGTGReportSendName =##Class(web.DHCPE.PreCommon).TransGReportSend(PGTGReportSend)
	.s:(""=PGTGReportSend) PGTGReportSendName = ""
	.
	.// PGT_IReportSend	个人报告发送
	.s PGTIReportSend=$p(CurData,"^",15)
	.s:(""'=PGTIReportSend) PGTIReportSendName =##Class(web.DHCPE.PreCommon).TransIReportSend(PGTIReportSend)
	.s:(""=PGTIReportSend) PGTIReportSendName = ""
	.
	.// PGT_DisChargedMode	结算方式
	.s PGTDisChargedMode=$p(CurData,"^",16)
	.s:(""'=PGTDisChargedMode) PGTDisChargedModeName =##Class(web.DHCPE.PreCommon).TransDisChargedMode(PGTDisChargedMode)
	.s:(""=PGTDisChargedMode) PGTDisChargedModeName = ""
	.
	.// PGT_BookDateBegin 预约日期
	.s PGTBookDateBegin = $p(CurData,"^",17)
	.i (""'=PGTBookDateBegin) s PGTBookDateBegin=$ZD(PGTBookDateBegin,4)
	.
	.// PGT_BookDateEnd
	.s PGTBookDateEnd = $p(CurData,"^",18)
	.i (""'=PGTBookDateEnd) s PGTBookDateEnd=$ZD(PGTBookDateEnd,4)
	.
	.// PGT_BookTime 预约时间
	.s PGTBookTime = $p(CurData,"^",19)
	.i (""'=PGTBookTime) s PGTBookTime=$ZT(PGTBookTime,2)
	.
	.//		0			1					2					3						4						5				6					6.1						7				8							9							10					11						12					13					13.1						14					14.1							15					15.1							16						16.1	
	.s Data=$G(id)_"^"_""_"^"_PGTDesc_"^"_PGTBookDateBegin_"^"_PGTBookDateEnd_"^"_PGTBookTime_"^"_PGTPEDeskClerkDR_"^"_PGTPEDeskClerkDRName_"^"_PGTAddOrdItem_"^"_PGTAddOrdItemLimit_"^"_PGTAddOrdItemAmount_"^"_PGTAddPhcItem_"^"_PGTAddPhcItemLimit_"^"_PGTAddPhcItemAmount_"^"_PGTGReportSend_"^"_PGTGReportSendName_"^"_PGTIReportSend_"^"_PGTIReportSendName_"^"_PGTDisChargedMode_"^"_PGTDisChargedModeName
	.
	q Data
}

ClassMethod TeamPreOver(TeamId)
{
	new iAdm,Status,Str
	s SQLCODE=0
	s iAdm=0
	f  s iAdm=$o(^DHCPEPreIADM(0,"PGTeam",TeamId,iAdm)) q:(iAdm="")||(SQLCODE'=0)  d
	.s Status=$p(^DHCPEPreIADM(iAdm),"^",8)
	.q:Status'="PREREG"
	.s Str=iAdm_"^PREREGED"
	.s SQLCODE=##class(web.DHCPE.PreIADM).CancelAdm("","",Str)
	q SQLCODE
}

Query PreTeamList(GID As %String) As %SQLQuery(ROWSPEC = "GT_Desc:%String, GT_RowId:%String")
{
	select PGT_Desc,PGT_RowId 
	From DHC_PE_PreGTeam 
	where PGT_ParRef=:GID
}

/// ##Class(web.DHCPE.PreGTeam).GetGAdmDesc(GAdm)
ClassMethod GetGAdmDesc(GAdm)
{
	s gAdmDesc=""
	if GAdm="" q gAdmDesc
	s gBaseInfoId=$p($g(^DHCPEPreGADM(GAdm)),"^",1)
	if gBaseInfoId="" q gAdmDesc
	s gAdmDesc=$p($g(^DHCPEPreGBI(gBaseInfoId)),"^",2)
	q gAdmDesc
}

/// ##Class(web.DHCPE.PreGTeam).GetGTeamDesc(GTeam)
ClassMethod GetGTeamDesc(GTeam)
{
	if GTeam="" q ""
	q $p($g(^DHCPEPreGADM($p(GTeam,"||",1),"Team",$p(GTeam,"||",2))),"^",1)
}

ClassMethod CopyTeamData(GTRowId)
{
    
    s Date=+$h,Time=$p($h,",",2)
    //s UserID=%session.Get("LOGON.USERID")
    s UserID=1
    s Data=$g(^DHCPEPreGADM($p($g(GTRowId),"||",1),"Team", $p($g(GTRowId),"||",2))) 
    s PLIST(0)=$p(GTRowId,"||",1)
    k PLIST(1)
    k PLIST(2)
    s PLIST(3)="新建分组"
    //预约开始日期,  结束日期,预约时间，PGT_PEDeskClerk_DR，
   //PGT_AddOrdItem,  GT_AddOrdItemLimi,PGT_AddOrdItemAmou，PGT_AddPhcItem，PGT_AddPhcItemLimit ,PGT_AddPhcItemAmount 
    //PGT_Sex ,  PGT_UpperLimit,PGT_LowerLimit ，PGT_Married ,PGT_UpdateUser_DR ,GT_UpdateDate, PGT_UpdateTime ,
    s PLIST(4)=Date,PLIST(5)=$p(Data,"^",3) ,PLIST(6)=Time , PLIST(7)=$p(Data,"^",5)
    s PLIST(8)=$p(Data,"^",6),PLIST(9)=$p(Data,"^",7) ,PLIST(10)=$p(Data,"^",8) , PLIST(11)=$p(Data,"^",9),PLIST(12)=$p(Data,"^",10) , PLIST(13)=$p(Data,"^",11)
    s PLIST(14)=$p(Data,"^",12),PLIST(15)=$p(Data,"^",13) ,PLIST(16)=$p(Data,"^",14) , PLIST(17)=$p(Data,"^",15),PLIST(18)=UserID , PLIST(19)=Date, PLIST(20)=Time
  	TSTART
	&SQL(Insert Into SQLUSER.DHC_PE_PreGTeam Values :PLIST())
	i SQLCODE=0
	{
		s GTeamID=$G(%ROWID)
	    s PreGID=+GTeamID
		s ^DHCPECBVIPLevel("PGT",GTeamID)=$g(^DHCPECBVIPLevel("PGT",GTRowId))
		s GID=$o(^DHCPEGADM(0,"CRMGADM",PreGID,0))
		i GID'=""
		{
			&SQL(insert into SQLUSER.dhc_pe_GTEAM 
			(GT_ParRef, GT_Desc, GT_CRMTeam,GT_AddOrdItem,GT_AddOrdItemLimit,GT_AddOrdItemAmount,GT_AddPhcItem,GT_AddPhcItemLimit,GT_AddPhcItemAmount,GT_Sex,GT_UpperLimit,GT_LowerLimit,GT_Married)
		 select :GID,PGT_Desc,PGT_RowId,PGT_AddOrdItem,PGT_AddOrdItemLimit,PGT_AddOrdItemAmount,PGT_AddPhcItem,PGT_AddPhcItemLimit,PGT_AddPhcItemAmount,PGT_Sex,PGT_UpperLimit,PGT_LowerLimit,PGT_Married
		  from SQLUSER.DHC_PE_PreGTeam
		   Where PGT_RowId=:GTeamID )
		}
	}
	i SQLCODE'=0
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	s retVal=""
	//复制医嘱
	i SQLCODE=0
	{
    s ChildSub=0
	f  s ChildSub=$o(^DHCPEPreGADM($p(GTRowId,"||",1),"Team", $p(GTRowId,"||",2) ,"ORDITEM",ChildSub))  q:ChildSub=""  d
	.s OrderSetsDR=""
	.s ItmMastDR=$p(^DHCPEPreGADM($p(GTRowId,"||",1),"Team", $p(GTRowId,"||",2) ,"ORDITEM",ChildSub),"^",1)
    .s PGTOIItemStat=$p(^DHCPEPreGADM($p(GTRowId,"||",1),"Team", $p(GTRowId,"||",2) ,"ORDITEM",ChildSub),"^",13)
    .q:PGTOIItemStat'=1
    .s PGTOIOrdEntDR=$p(^DHCPEPreGADM($p(GTRowId,"||",1),"Team", $p(GTRowId,"||",2) ,"ORDITEM",ChildSub),"^",2)
    .i PGTOIOrdEntDR'=""  s OrderSetsDR=$p(^DHCPEPreGADM($p(PGTOIOrdEntDR,"||",1),"Team", $p(PGTOIOrdEntDR,"||",2),"ORDENT", $p(PGTOIOrdEntDR,"||",3)),"^",1)
    .i OrderSetsDR="" s retVal=##class(web.DHCPE.PreItemList).IInsertItem(GTeamID,"TEAM","PRE",ItmMastDR,"",UserID)
    
    s ChildEntSub=0
    f  s ChildEntSub=$o(^DHCPEPreGADM($p(GTRowId,"||",1),"Team",$p(GTRowId,"||",2),"ORDENT",ChildEntSub))  q:ChildEntSub=""  d
    .s OrderSetsDR=$p(^DHCPEPreGADM($p(GTRowId,"||",1),"Team", $p(GTRowId,"||",2),"ORDENT", ChildEntSub),"^",1)
    .s PGTOEItemStat=$p(^DHCPEPreGADM($p(GTRowId,"||",1),"Team", $p(GTRowId,"||",2),"ORDENT",ChildEntSub),"^",7)
    .q:PGTOEItemStat'=1
    .q:OrderSetsDR=""
    .s retVal=##class(web.DHCPE.PreItemList).IInsertItem(GTeamID,"TEAM","PRE","",OrderSetsDR,UserID)
  
    }
 q retVal
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.PreGTeam","SearchGDepart",13,"","PRE")
Query SearchGDepart(GID As %String = "", TeamID As %String = "", Type As %String = "", Depart) As %Query(ROWSPEC = "DepartName:%String")
{
}

ClassMethod SearchGDepartExecute(ByRef qHandle As %Binary, GID As %String = "", TeamID As %String = "", Type As %String = "", vDepart As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	i (GID="")
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s Job=$J
 	s ind=1
 	if Type=""
 	{
 		s teamID=""
 		f  s teamID=$O(^DHCPEIADM(0,"GADM",GID,teamID)) q:teamID=""  d
 		.q:(TeamID'="")&&(TeamID'=teamID)
 		.s id=""
 		.f  s id=$O(^DHCPEIADM(0,"GADM",GID,teamID,id)) q:id=""  d
 		..s crmID=$P(^DHCPEIADM(id),"^",4)
 		..s Depart=$G(^DHCPEDataEx("DHCPEPreIADM","Position",crmID))
 		..q:Depart=""
 		..q:(vDepart'="")&&(Depart'[vDepart)
 		..s ^TempDHCPE(Job,Depart)=""
	
 	}
 	else
 	{
	 	s ctype="PGADM"
	 	s cid=GID
	 	i TeamID'="" d
	 	.s ctype="PGTeam"
	 	.s cid=TeamID
	 	s id=""
 		f  s id=$O(^DHCPEPreIADM(0,ctype,cid,id)) q:id=""  d
 		.s Depart=$G(^DHCPEDataEx("DHCPEPreIADM","Position",id))
 		.q:Depart=""
 		.q:(vDepart'="")&&(Depart'[vDepart)
 		.s ^TempDHCPE(Job,Depart)=""
 	}
 	s Depart=""
	f  s Depart=$O(^TempDHCPE(Job,Depart)) q:Depart=""  d
	.d SearchGDepartBuild
	k ^TempDHCPE(Job)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
SearchGDepartBuild
	//			PGT_ParRef, PGT_RowId, PGT_ChildSub, PGT_ParRef_Name, PGT_Desc, PGT_Sex, PGT_UpperLimit, PGT_LowerLimit, PGT_Married, PGT_Married_Desc ,PGT_UpdateUser_DR, PGT_UpdateUser_DR_Name, PGT_UpdateDate
	set Data=$lb(Depart)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchGDepartFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchGDepartExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchGDepartClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchGDepartExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 判断组Team或者个人Person是否出现在团体中
ClassMethod IsIncludeGroup(ID, Type)
{
	;q:##class(web.DHCPE.PreGTeam).IsIncludeGroup(ID, "Team")="0"
	s Flag=1
	i Type="Team"{
		
	}else{
		s ID=$P($G(^DHCPEPreIADM(ID)),"^",3)
	}
	i ID'=""{
		s NoIncludeFlag=$g(^DHCPEDataEx("DHCPEPreGTeam","NoInclude",ID))
		s:NoIncludeFlag="1" Flag=0
	}
	q Flag
}

/// for team Template
/// 
/// Component:DHCPEPreGTeam.Edit
ClassMethod GTeamTempSet(InStr, ID, Type As %Library.String)
{
	s flag=0
	i Type="Set" d
    .s ^DHCPEDataEX("DHCPEGTeamTemplateRowId")=$G(^DHCPEDataEX("DHCPEGTeamTemplateRowId"))+1
    .s SetRowId=$G(^DHCPEDataEX("DHCPEGTeamTemplateRowId"))
    .s Desc=$P($G(InStr),"^",1)
    .s AgeFrom=$P($G(InStr),"^",2)
    .s AgeTo=$P($G(InStr),"^",3)
    .s Sex=$P($G(InStr),"^",4)
    .s Married=$P($G(InStr),"^",5)
    .s ^DHCPEDataEX("DHCPEGTeamTemplate",SetRowId)=Desc_"^"_AgeFrom_"^"_AgeTo_"^"_Sex_"^"_Married_"^^^^^^^^^"
    .s flag=1
	e  i Type="Del"  d
	.k ^DHCPEDataEX("DHCPEGTeamTemplate",ID)
	.s flag=1
    i flag=1 q 0
    e  q "None has been changed"
}

/// d ##class(web.DHCPE.PreGTeam).OutGTeamTempSetBtn()
ClassMethod OutGTeamTempSetBtn(ID)
{
	s disabled=""
		w "<button style='width:99%' onclick='DelGTeamTemp(this)' id='"_ID_"' name='BtnDel' "_disabled_">删除</button>"
	q $$$OK
}

/// 功能:分组预制模板
/// 测试：d ##class(%ResultSet).RunQuery("web.DHCPE.PreGTeam","GetGTeamTempSet","","","")
Query GetGTeamTempSet(VIP As %Library.String = "") As %Query(ROWSPEC = "TID:%String,TAgeFrom:%String,TAgeTo:%String,TSex:%String,THouse:%String,TDesc:%String")
{
}

ClassMethod GetGTeamTempSetExecute(ByRef qHandle As %Binary, VIP As %Library.String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	s ind=1

 	s id=0
 	f  s id=$O(^DHCPEDataEX("DHCPEGTeamTemplate",id)) q:id=""  d
 	.d Clear
 	.s Str=$G(^DHCPEDataEX("DHCPEGTeamTemplate",id))
 	.s TID=id
 	.s TAgeFrom=$P(Str,"^",2)
 	.s TAgeTo=$P(Str,"^",3)
 	.s TSex=$P(Str,"^",4)
 	.s THouse=$P(Str,"^",5)
 	.s TDesc=$P(Str,"^",1)
 	.d FindBuild

	
	Set qHandle=$lb(0,repid,0)	
	Quit $$$OK
		
Clear
	s (TID,TAgeFrom,TAgeTo,TSex,THouse,TDesc)=""
	q 
FindBuild
	set Data=$lb(TID,TAgeFrom,TAgeTo,TSex,THouse,TDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetGTeamTempSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGTeamTempSetExecute ]
{
	s repid=$List(qHandle,2)
	kill ^CacheTmp(repid)
	Quit $$$OK
}

ClassMethod GetGTeamTempSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGTeamTempSetExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPreGInfo(PreGAdm)
{
 
	q:PreGAdm="" ""
	s Data=$g(^DHCPEPreGADM(PreGAdm))
	q Data
}

}
