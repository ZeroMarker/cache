/// 医保服务查询界面权限管理类
/// DingSH 20200116
Class DHCINSU.ServQry.Manager Extends %RegisteredObject
{

/// w ##class(DHCINSU.ServQry.Manager).GetServQryCSP()
/// ???做个界面新增挂菜单(需要新增配置表)
/// ???根据安全组分配菜单
ClassMethod GetServQryCSP()
{
	s $zt="GetServQryCSPEx"
	s csp=        "人员信息获取-1101|dhcinsu.insupsninfo.csp"
	s csp=csp_"^"_"人员待遇享受检查-2001|dhcinsu.insutrtinfo.csp"
    s csp=csp_"^"_"人员慢特病用药记录查询-5205|dhcinsu.insumtfeedetail.csp"
    s csp=csp_"^"_"人员定点信息查询-5302|dhcinsu.insupsnfixmedin.csp"
    s csp=csp_"^"_"在院信息查询-5303|dhcinsu.insureginfo.csp"
    s csp=csp_"^"_"结算信息查询-5203|dhcinsu.insusetlinfo.csp"
    s csp=csp_"^"_"费用明细查询-5204|dhcinsu.insufileinfo.csp"
    s csp=csp_"^"_"就诊信息查询-5201|dhcinsu.insumdtrtinfo.csp"
    s csp=csp_"^"_"诊断信息查询-5202|dhcinsu.insuzdinfo.csp"
    s csp=csp_"^"_"门慢特病查询-5301|dhcinsu.insuopspdiseqry.csp"
    s csp=csp_"^"_"转院信息查询-5304|dhcinsu.insureferralInfoqry.csp"
      
	q csp
GetServQryCSPEx
 s $zt=""
 q ""
}

/// w ##class(DHCINSU.ServQry.Manager).GetServQryCSPMenu()
/// ???做个界面新增挂菜单(需要新增配置表)
/// ???根据安全组分配菜单
/// w ##class(DHCINSU.ServQry.Manager).GetServQryCSPMenu()
/// ???做个界面新增挂菜单(需要新增配置表)
/// ???根据安全组分配菜单
/// w ##class(DHCINSU.ServQry.Manager).GetServQryCSPMenu("1","2")
/// ???做个界面新增挂菜单(需要新增配置表)
/// ???根据安全组分配菜单
ClassMethod GetServQryCSPMenu(SecdClass, HospDr) As %String
{
	s $zt="GetServQryCSPMenuEx"
	s CSPTitle=""
	#; i SecdClass=""
	#; .w "<a href='javascript:void(0);' src='dhcinsu.insupsninfo.csp' class='cs-navi-tab'>人员信息获取-1101</a>",!
	#; .w "<a href='javascript:void(0);' src='dhcinsu.insuopspdiseqry.csp' class='cs-navi-tab'>门慢特病查询-5301</a>",!
	#; .w "<a href='javascript:void(0);' src='dhcinsu.insupsnfixmedin.csp' class='cs-navi-tab'>人员定点信息查询-5302</a>",!
	#; .w "<a href='javascript:void(0);' src='dhcinsu.insureginfo.csp' class='cs-navi-tab'>在院信息查询-5303</a>",!
	#; .w "<a href='javascript:void(0);' src='dhcinsu.insusetlinfo.csp' class='cs-navi-tab'>结算信息查询-5203</a>",!
	#; .w "<a href='javascript:void(0);' src='dhcinsu.insufileinfo.csp' class='cs-navi-tab'>费用明细查询-5204</a>",!
	#; .w "<a href='javascript:void(0);' src='dhcinsu.insumdtrtinfo.csp' class='cs-navi-tab'>就诊信息查询-5201</a>",!
	#; .w "<a href='javascript:void(0);' src='dhcinsu.insuzdinfo.csp' class='cs-navi-tab'>诊断信息查询-5202</a>",!
	#; .w "<a href='javascript:void(0);' src='dhcinsu.insumtfeedetail.csp' class='cs-navi-tab'>慢特病用药查询-5205</a>",!
	#; .w "<a href='javascript:void(0);' src='dhcinsu.insutrtinfo.csp' class='cs-navi-tab'>人员待遇享受检查-2001</a>",!
	#; .w "<a href='javascript:void(0);' src='dhcinsu.insureferralInfoqry.csp' class='cs-navi-tab'>转院信息查询-5304</a>",!
	#; .w "<a href='javascript:void(0);' src='dhcinsu.insudicinfo.csp' class='cs-navi-tab'>字典表查询-1901</a>",!
	#; .w "<a href='javascript:void(0);' src='dhcinsu.medinsinfo.csp' class='cs-navi-tab'>医药机构查询-1201</a>",!
	#; e  d
	#; .s DicStr=##class(web.INSUDicDataCom).GetDicBybillAndInd("infoquryCon00A",SecdClass,0,HospDr)
    #; .s CCnt=$l(DicStr,"$")
    #; .f i=1:1:CCnt d
    #; ..s DicInfo=$P(DicStr,"$",i)
    #; ..s DicBill1=$P(DicInfo,"^",6)
    #; ..q:DicBill1'=SecdClass
    #; ..s DicCode=$P(DicInfo,"^",3)
    #; ..s DicDesc=$P(DicInfo,"^",4)
    #; ..s CSPTitle=$P(DicInfo,"^",7)
    #; ..w "<a href='javascript:void(0);' src='"_DicCode_"' class='cs-navi-tab'>"_DicDesc_"</a>",!
	s DicStr=##class(web.INSUDicDataCom).GetDicBybillAndInd("infoquryCon00A",SecdClass,0,HospDr)
    s CCnt=$l(DicStr,"$")
    f i=1:1:CCnt d
    .s DicInfo=$P(DicStr,"$",i)
    .s DicBill1=$P(DicInfo,"^",6)
    .;q:DicBill1'=SecdClass
    .s DicCode=$P(DicInfo,"^",3)
    .s DicDesc=$P(DicInfo,"^",4)
    .s CSPTitle=$P(DicInfo,"^",7)
    .w "<a href='javascript:void(0);' src='"_DicCode_"' class='cs-navi-tab'>"_DicDesc_"</a>",!
	s:SecdClass="" CSPTitle="信息查询"
    q CSPTitle
GetServQryCSPMenuEx
 s $zt=""
 q ""
}

/// do ##class(%ResultSet).RunQuery("DHCINSU.ServQry.Manager","FindAdmList", "26","2","")
Query FindAdmList(papmi As %String, hospId As %String, HisType As %String) As websys.Query(ROWSPEC = "admNo:%String,regNo:%String,patName:%String,admDate:%String,admTime:%String,admDept:%String,admWard:%String,admBed:%String,admStatus:%String,admId:%String,PaSex,PAPMIHealthFundNo")
{
}

ClassMethod FindAdmListExecute(ByRef qHandle As %Binary, papmi As %String, hospId As %String, HisType As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
	if (papmi="")  quit $$$OK
	s ^CacheTemp("FindAdmListExecute")=$lb(papmi,hospId,HisType)
  	set regNo=$p($g(^PAPER(papmi,"PAT",1)),"^",1)
	set patName=$p($g(^PAPER(papmi,"ALL")),"^",1)
 	s PaSex=$p(^PAPER(papmi,"ALL"),"^",7) //
 	s PAPMIHealthFundNo=$p($G(^PAPER(papmi,"PAT",3)),"^",12) //医保手册号
 	k ^CacheTemp("AdmDateInd",$j)
 	
	set AdmType=""
	for  set AdmType=$o(^PAPERdr(papmi,"ADM",AdmType))  quit:(AdmType="")  do
	.q:(HisType'="")&&(("^"_HisType_"^")'[("^"_AdmType_"^")) //DingSH  20210104
	.set rowId=""
	.for  set rowId=$o(^PAPERdr(papmi,"ADM",AdmType,rowId),-1)  quit:(rowId="")  do
	..set admDeptDR=$p(^PAADM(rowId),"^",4)
	..set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(admDeptDR)
	..quit:((hospId'="")&&(hospId'=admHospDR))
	..q:AdmType="H"    //体检去掉  20210929 DingSH
	..d AdmDateInd

    set rowId=""
	for  set rowId=$o(^CacheTemp("AdmDateInd",$j,rowId),-1)  quit:(rowId="")  do
    .d BudInfo
    
    k ^CacheTemp("AdmDateInd",$j)
    quit $$$OK
AdmDateInd
  s ^CacheTemp("AdmDateInd",$j,rowId)=rowId
 q
	
    
BudInfo	
    set AdmType = $p(^PAADM(rowId),"^",2)
	set admNo=$p(^PAADM(rowId),"^",81)
	set admDate=$p(^PAADM(rowId),"^",6)
	set admDate=##class(websys.Conversions).DateLogicalToHtml(admDate)
	set admTime=$p(^PAADM(rowId),"^",7)
	set admTime=##class(websys.Conversions).TimeLogicalToHtml(admTime, 1)
    set admDeptDR=$p(^PAADM(rowId),"^",4)
	set admDept=$p($g(^CTLOC(admDeptDR)),"^",2)
	set admDept=$s(($f(admDept,"-")'=0):$p(admDept,"-",2),1:admDept)
	set admWardDR=$p(^PAADM(rowId),"^",70)
	set admWard=""
	set:admWardDR'="" admWard=$p($g(^PAWARD(admWardDR)),"^",2)
	set:admWardDR'="" admWard=$s(($f(admWard,"-")'=0):$p(admWard,"-",2),1:admWard)
	set admBed=##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(rowId)
	s admStatus=""
	if (AdmType="I") set admStatus="住院"
	if (AdmType="O") set admStatus="门诊"
	if (AdmType="E") set admStatus="急诊"
	//if (AdmType="H") set admStatus="体检"
	s:admStatus="" admStatus=AdmType
	do OutputAdmList
    q 
	
OutputAdmList
	set Data=$lb(admNo,regNo,patName,admDate,admTime,admDept,admWard,admBed,admStatus,rowId,PaSex,PAPMIHealthFundNo)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator:卢俊晖
/// Date：2022-10-24
/// 根据登记号查人员编号
/// 入参：papmiNo：登记号
/// 出参：InsuId:人员编号
/// w ##class(DHCINSU.ServQry.Manager).GetInsuIdByPapmiNo("0000000001")
ClassMethod GetInsuIdByPapmiNo(papmiNo As %String) As %String
{
	q:papmiNo=""
	s papmiId=""
	s papmiId=$o(^PAPERi("PAPMI_PatNo",papmiNo,""),-1) 
	q:papmiId=""
	s admDr=""
	s InsuAdmDr=""
	s admTypeStr="O^E^I"
	s ind=""
	s InsuId=""
	f ind=1:1:3  d  
	.s admType=$p(admTypeStr,"^",ind)
	.f  s:admType'="" admDr=$o(^PAPERdr(papmiId,"ADM",admType,admDr)) q:(admDr="")||(InsuId'="")  d	
	..s InsuAdmDr=$O(^DHCINADM("0","ADM",admDr,InsuAdmDr),-1)
	..s:InsuAdmDr'="" InsuId=$p($g(^DHCINADM(InsuAdmDr)),"^",2)
	q InsuId
}

/// do ##class(%ResultSet).RunQuery("DHCINSU.ServQry.Manager","FindInsuAdmList", "4","2","")
Query FindInsuAdmList(papmi As %String, hospId As %String, HisType As %String) As websys.Query(ROWSPEC = "admNo:%String,regNo:%String,patName:%String,admDate:%String,admTime:%String,admDept:%String,admWard:%String,admBed:%String,admStatus:%String,admId:%String,PaSex,PAPMIHealthFundNo,inadmId,psnNo,admdvs,mdtrtId")
{
}

ClassMethod FindInsuAdmListExecute(ByRef qHandle As %Binary, papmi As %String, hospId As %String, HisType As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
	if (papmi="")  quit $$$OK
	s ^CacheTemp("FindAdmListExecute")=$lb(papmi,hospId,HisType)
  	set regNo=$p($g(^PAPER(papmi,"PAT",1)),"^",1)
	set patName=$p($g(^PAPER(papmi,"ALL")),"^",1)
 	s PaSex=$p(^PAPER(papmi,"ALL"),"^",7) //
 	s PAPMIHealthFundNo=$p($G(^PAPER(papmi,"PAT",3)),"^",12) //医保手册号
 	k ^CacheTemp("AdmDateInd",$j)
 	
	set AdmType=""
	for  set AdmType=$o(^PAPERdr(papmi,"ADM",AdmType))  quit:(AdmType="")  do
	.q:(HisType'="")&&(("^"_HisType_"^")'[("^"_AdmType_"^")) //DingSH  20210104
	.set rowId=""
	.for  set rowId=$o(^PAPERdr(papmi,"ADM",AdmType,rowId),-1)  quit:(rowId="")  do
	..set admDeptDR=$p(^PAADM(rowId),"^",4)
	..set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(admDeptDR)
	..quit:((hospId'="")&&(hospId'=admHospDR))
	..q:AdmType="H"    //体检去掉  20210929 DingSH
	..d AdmDateInd

    set rowId=""
	for  set rowId=$o(^CacheTemp("AdmDateInd",$j,rowId),-1)  quit:(rowId="")  do
    .d BudInfo
    
    k ^CacheTemp("AdmDateInd",$j)
    quit $$$OK
AdmDateInd
  s ^CacheTemp("AdmDateInd",$j,rowId)=rowId
 q
BudInfo	
    s rtn=##class(web.DHCINSUIPReg).GetInfoByAdm("","",rowId)
	s flag=$p(rtn,"!",1)
	q:flag'="1"
	s InsuAdmInfo=$p(rtn,"!",2)
	q:(InsuAdmInfo="")
	s INADMActiveFlag=$p(InsuAdmInfo,"^",12)
	q:(INADMActiveFlag'="A")&&(INADMActiveFlag'="O")
    set AdmType = $p(^PAADM(rowId),"^",2)
	set admNo=$p(^PAADM(rowId),"^",81)
	set admDate=$p(^PAADM(rowId),"^",6)
	set admDate=##class(websys.Conversions).DateLogicalToHtml(admDate)
	set admTime=$p(^PAADM(rowId),"^",7)
	set admTime=##class(websys.Conversions).TimeLogicalToHtml(admTime, 1)
    set admDeptDR=$p(^PAADM(rowId),"^",4)
	set admDept=$p($g(^CTLOC(admDeptDR)),"^",2)
	set admDept=$s(($f(admDept,"-")'=0):$p(admDept,"-",2),1:admDept)
	set admWardDR=$p(^PAADM(rowId),"^",70)
	set admWard=""
	set:admWardDR'="" admWard=$p($g(^PAWARD(admWardDR)),"^",2)
	set:admWardDR'="" admWard=$s(($f(admWard,"-")'=0):$p(admWard,"-",2),1:admWard)
	set admBed=##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(rowId)
	s admStatus=""
	if (AdmType="I") set admStatus="住院"
	if (AdmType="O") set admStatus="门诊"
	if (AdmType="E") set admStatus="急诊"
	//if (AdmType="H") set admStatus="体检"
	s:admStatus="" admStatus=AdmType
	//s rtn=##class(web.DHCINSUIPReg).GetInfoByAdm("","",rowId)
	//s flag=$p(rtn,"!",1)
	//q:flag'="1"
	//s InsuAdmInfo=$p(rtn,"!",2)
	s inadmId=$p(InsuAdmInfo,"^",2)
	s psnNo=$p(InsuAdmInfo,"^",3)
	s admdvs=$p(InsuAdmInfo,"^",9)
	s mdtrtId=$p(InsuAdmInfo,"^",11)
	do OutputAdmList
    q 
	
OutputAdmList
	set Data=$lb(admNo,regNo,patName,admDate,admTime,admDept,admWard,admBed,admStatus,rowId,PaSex,PAPMIHealthFundNo,inadmId,psnNo,admdvs,mdtrtId)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// 根据登记号取PapmiDr
/// w ##class(DHCINSU.ServQry.Manager).GetPapmiDrByPAPMINo("1")
ClassMethod GetPapmiDrByPAPMINo(PAPMINo As %String) As %String
{
	q:(PAPMINo="") ""
	s PapmiDr=""
	s RegNo=##class(web.UDHCJFBaseCommon).regnocon(PAPMINo)
	s PapmiDr=$o(^PAPERi("PAPMI_PatNo",RegNo,PapmiDr))
 	q PapmiDr
}

}
