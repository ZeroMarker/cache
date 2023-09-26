/// Description:封箱前复核转病区揭药信息查询相关
/// Creator:    hulihua
/// CreateDate: 2017-09-21
/// Table:      DHC_PhaMedBroth-揭药主表、DHC_PhaMedBrothItm-揭药子表
Class web.DHCINPHA.HMBSealReCheck.BSealReCheckQuery Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Description:获取封箱前复核转病区揭药的处方列表
/// Creator:	hulihua
/// CreateDate:	2017-09-21
/// Table:      DHC_PhaMedBroth-揭药主表、DHC_PhaMedBrothItm-揭药子表
/// Input:
/// Output:		住院号、登记号、姓名、床号、处方号、揭药时间、揭药袋数、揭药人、转科之前病区、转科之后病区、子表ID
/// Return：    
/// Others:
/// w ##class(web.DHCINPHA.HMBSealReCheck.BSealReCheckQuery).GetBSealPrescnoList("100","1","2022-01-11^2022-02-17^^183")
ClassMethod GetBSealPrescnoList(rows, page, params) As %String
{
	n (rows, page, params)
	//s ^PHATMP("MYQ",$this,"GetBSealPrescnoList")=$Lb(rows, page, params)
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	i $g(page)="" s page=1
	i $g(rows)="" s rows=50
	s End = page*rows
	s Start=(page-1)*rows+1
	s StartDate=$p(params,"^",1)
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=$p(params,"^",2)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s WardLocId=$p(params,"^",3)
	s LogonLocId=$p(params,"^",4)
	s LogonHospId=$p($g(^CTLOC(+LogonLocId)),"^",22)
	s NurseAuditFlag="N"							;护士未审核
	S pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid("web.DHCINPHA.HMBSealReCheck.BSealReCheckQuery")
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.HMBSealReCheck.BSealReCheckQuery","GetBSealPrescnoList",pid,"Prescno")
	s n=0
	f Date=StartDate:1:EndDate d
	.i WardLocId'=""  d
	..s PhmbID=""
	..f  s PhmbID=$o(^DHCPHAMEDBi("NurseFlagWardLocDate",NurseAuditFlag,WardLocId,Date,PhmbID)) q:PhmbID=""  d
	...s AdmDr=$p(^DHCPHAMEDB(PhmbID),"^",2)
	...s AdmType=$p($g(^PAADM(AdmDr)),"^",2)
	...q:AdmType'="I"
	...s AdmWard=$p(^PAADM(AdmDr),"^",70)  			;病人当前所在的病区
	...s AdmWardLoc=$p(^PAWARD(AdmWard),"^",5)
	...q:AdmWardLoc=WardLocId						;未转病区的过滤
	...s PhmbCh=""
	...f  s PhmbCh=$o(^DHCPHAMEDBi("NurseFlagWardLocDate",NurseAuditFlag,WardLocId,Date,PhmbID,PhmbCh))  q:PhmbCh=""  d
	....s UncovMedFlag=$p(^DHCPHAMEDB(PhmbID,"I",PhmbCh),"^",5)
	....q:UncovMedFlag'="Y"							;未揭的过滤 
	....s PhBoxId=$p(^DHCPHAMEDB(PhmbID,"I",PhmbCh),"^",16)
	....q:(+PhBoxId = 0)
	....s PhBoxStatus=$p($G(^DHCPHBOX(PhBoxId)),"^",13)
	....q:PhBoxStatus>20							;发放的过滤 
	....s index=WardLocId_","_PhmbID_"||"_PhmbCh
	....s n=n+1
	....s ^TMP("DHCINPHA","web.DHCINPHA.HMBSealReCheck.BSealReCheckQuery","GetBSealPrescnoList",pid,"Prescno",index)=""
	...
	..
	.e  d
	..s WardLocId=""
	..f  s WardLocId=$o(^DHCPHAMEDBi("NurseFlagWardLocDate",NurseAuditFlag,WardLocId))  q:WardLocId=""  d
	...s PhmbID=""
	...f  s PhmbID=$o(^DHCPHAMEDBi("NurseFlagWardLocDate",NurseAuditFlag,WardLocId,Date,PhmbID)) q:PhmbID=""  d
	....s AdmDr=$p(^DHCPHAMEDB(PhmbID),"^",2)
	....s AdmType=$p($g(^PAADM(AdmDr)),"^",2)
	....q:AdmType'="I"
	....s AdmWard=$p(^PAADM(AdmDr),"^",70)  			;病人当前所在的病区
	....s AdmWardLoc=$p(^PAWARD(AdmWard),"^",5)
	....q:AdmWardLoc=WardLocId							;未转病区的过滤
	....s PhmbCh=""
	....f  s PhmbCh=$o(^DHCPHAMEDBi("NurseFlagWardLocDate",NurseAuditFlag,WardLocId,Date,PhmbID,PhmbCh))  q:PhmbCh=""  d
	.....s UncovMedFlag=$p(^DHCPHAMEDB(PhmbID,"I",PhmbCh),"^",5)
	.....q:UncovMedFlag'="Y"							;未揭的过滤 
	.....s PhBoxId=$p(^DHCPHAMEDB(PhmbID,"I",PhmbCh),"^",16)
	.....q:(+PhBoxId = 0)
	.....s PhBoxStatus=$p($G(^DHCPHBOX(PhBoxId)),"^",13)
	.....q:PhBoxStatus>20								;发放的过滤 
	.....s index=WardLocId_","_PhmbID_"||"_PhmbCh
	.....s n=n+1
	.....s ^TMP("DHCINPHA","web.DHCINPHA.HMBSealReCheck.BSealReCheckQuery","GetBSealPrescnoList",pid,"Prescno",index)=""
	....
	...
	..
	. 
	q:n=0 ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(n) //输出空的json串
 	i End>n s End=n
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonStartStringJqGrid(n,rows) //输出json前缀串
	s count=0
	s index=""
	f  s index=$o(^TMP("DHCINPHA","web.DHCINPHA.HMBSealReCheck.BSealReCheckQuery","GetBSealPrescnoList",pid,"Prescno",index)) q:index=""  d
	.s WardLocId=$p(index,",")
	.s WardHospId=$p($g(^CTLOC(+WardLocId)),"^",22)	
    .q:(LogonHospId'="")&&(LogonHospId'=WardHospId)
	.s Phmbi=$p(index,",",2)
	.s AdmDr=$p(^DHCPHAMEDB(+Phmbi),"^",2)
	.s patInfo=##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).GetPatInfo(AdmDr)
	.s PatNo=$p(patInfo,"^",1)
	.s PatCardNo=$p(patInfo,"^",12)
	.s PatName=$p(patInfo,"^",3)
	.s BedId=$p(^PAADM(AdmDr),"^",73)	//未转病区则取当前床位，转病区则床号为空
 	.s Bed=$S(BedId'="":$p($g(^PAWARD($p(BedId,"||",1),"BED",$p(BedId,"||",2))),"^",1),1:"")
	.s AdmWard=$p(^PAADM(AdmDr),"^",70)  			
	.s AdmWardLocDr=$p(^PAWARD(AdmWard),"^",5)
	.s PrescNo=$p(^DHCPHAMEDB(+Phmbi),"^",4)
	.s OldWardLocDr=$p(^DHCPHAMEDB(+Phmbi,"I",$p(Phmbi,"||",2)),"^",1)
	.s AdmWardLoc=$s(OldWardLocDr'="":$p(^CTLOC(AdmWardLocDr),"^",2),1:"") 
	.s OldWardLoc=$s(OldWardLocDr'="":$p(^CTLOC(OldWardLocDr),"^",2),1:"")
	.s ActUncovMedDate=$p(^DHCPHAMEDB(+Phmbi,"I",$p(Phmbi,"||",2)),"^",3)	//揭药日期
    .s ActUncovMedDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ActUncovMedDate)
    .s ActUncovMedTime=$p(^DHCPHAMEDB(+Phmbi,"I",$p(Phmbi,"||",2)),"^",4)	//揭药时间
    .s ActUncovMedTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(ActUncovMedTime)
	.s ActUncovMedDate=ActUncovMedDate_" "_ActUncovMedTime
    .s ActUncovMedPocNum=$p(^DHCPHAMEDB(+Phmbi,"I",$p(Phmbi,"||",2)),"^",7)	//揭药袋数
    .s BrothDispUserDR=$p(^DHCPHAMEDB(+Phmbi,"I",$p(Phmbi,"||",2)),"^",9)	//揭药人
    .s BrothDispUser=$s(BrothDispUserDR'="":$p(^SSU("SSUSR",BrothDispUserDR),"^",2),1:"")
	.s Data1=PatCardNo_"^"_PatNo_"^"_PatName_"^"_Bed_"^"_PrescNo
	.s Data2=ActUncovMedPocNum_"^"_ActUncovMedDate_"^"_BrothDispUser_"^"_OldWardLoc_"^"_AdmWardLoc
	.s Data3=Phmbi_"^"_OldWardLocDr_"^"_AdmWardLocDr
	.s mdata=Data1_"^"_Data2_"^"_Data3
	.s count = count+1
	.s Title1="TPatCardNo^TPatNo^TPatName^TBed^TPrescNo"
	.s Title2="TActUncovMedPocNum^TActUncovMedDate^TBrothDispUser^TOldWardLoc^TAdmWardLoc"
	.s Title3="TPhmbi^TOldWardLocDr^TAdmWardLocDr"
	.s Title=Title1_"^"_Title2_"^"_Title3
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign() //输出json结尾符
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.HMBSealReCheck.BSealReCheckQuery","GetBSealPrescnoList",pid,"Prescno")
	q ""
}

/// Description:保存颗粒剂护士接收信息
/// Creator:	hulihua
/// CreateDate:	2017-09-21
/// Table:      DHC_PHACollected
/// Input:		发药主表ID串&&接收人
/// Output:		
/// Return：	0-成功，非0-失败    
/// Others:
/// w ##class(web.DHCINPHA.HMBSealReCheck.BSealReCheckQuery).SaveBSealPre("207&&349")
ClassMethod SaveBSealPre(listData As %String) As %String
{
	n (listData)
	q:listData="" "-1^未选中需要复核的信息，请核实!"
	s len=$l(listData,"&&")
	s ret=0
	f i=1:1:len  q:ret'=0  d
	.s Phmbi=$p(listData,"&&",i)
	.s UncovMedFlag=$p(^DHCPHAMEDB(+Phmbi,"I",$p(Phmbi,"||",2)),"^",5)
	.s:UncovMedFlag'="Y" ret="-2^该揭药信息还未揭药，请核实!"	
	.q:ret'=0
	.s PhBoxId=$p(^DHCPHAMEDB(+Phmbi,"I",$p(Phmbi,"||",2)),"^",16)
	.s PhBoxStatus=$p($G(^DHCPHBOX(PhBoxId)),"^",13)
	.s:PhBoxStatus>20 ret="-3^该揭药信息已发放!"								
	.q:ret'=0 
	.s err=##class(web.DHCINPHA.HMMedBroth.SqlDbBrothDisp).UpChPatWardLoc(Phmbi)
	.s:err'=0 ret="-4^处理表结构失败，请联系信息部!"
	q:ret'=0 ret
	q ret
}

}
