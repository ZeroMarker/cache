Class web.DHCENS.STBLL.Method.QueryReportInsu Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2021—12-16
/// Description：病理报告
/// Table：Ens_RISReportResult、Ens_RISItemResult、Ens_HOSDocument、Ens_RelOrderDocument
/// Input：AdmDr:就诊rowid,ExpDataAry:医保数组
/// Output:mdtrt_sn:就医流水号,mdtrt_id:就诊ID,psn_no:人员编号,palg_no:病理号,frez_no:冰冻号,cma_date:送检日期,rpt_date:报告日期,cma_matl:送检材料,clnc_diag:临床诊断,exam_fnd:检查所见,sabc:免疫组化,palg_diag:病理诊断,rpot_doc:报告医师,vali_flag:有效标志
/// Debug:d ##class(%ResultSet).RunQuery("web.DHCENS.STBLL.Method.QueryReportInsu","SelectPISRptInfoByAdm","285","")
Query SelectPISRptInfoByAdm(AdmDr As %String = "", ExpDataAry As %ArrayOfDataTypes = "") As %Query(ROWSPEC = "mdtrt_sn:%String,mdtrt_id:%String,psn_no:%String,palg_no:%String,frez_no:%String,cma_date:%String,rpt_date:%String,cma_matl:%String,clnc_diag:%String,exam_fnd:%String,sabc:%String,palg_diag:%String,rpot_doc:%String,vali_flag:%String")
{
}

ClassMethod SelectPISRptInfoByAdmExecute(ByRef qHandle As %Binary, AdmDr As %String = "", ExpDataAry As %ArrayOfDataTypes = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	s (mdtrtsn,mdtrtid,psnno,palgno,frezno,cmadate,rptdate,cmamatl,clncdiag,examfnd,sabc,palgdiag,rpotdoc,valiflag)=""
	if ($IsObject(ExpDataAry)) {
        //--按照医保接口文档字段命名
        s mdtrtsn = ExpDataAry.GetAt("mdtrt_sn")
        s mdtrtid=ExpDataAry.GetAt("mdtrt_id") //mdtrt_id 就诊ID(非HIS就诊ID) 
        s psnno = ExpDataAry.GetAt("psn_no") //psn_no 人员编号
    }else{
        Set mdtrtsn=AdmDr
        Set mdtrtid=AdmDr
        Set MethodExist=##class(websys.Conversions).IsValidMethodName("web.DHCINSUPort","GetInsuAdmInfoByAdm")
        If (MethodExist) {
            Set InsuAdmInfo=##Class(web.DHCINSUPort).GetInsuAdmInfoByAdm(AdmDr)   //医保接口 如果没有返回，请项目组问医保组要接口
            Set psnno=$PIECE(InsuAdmInfo,"^",1)
        }Else{
            Set psnno="无"
        }
    }
	If $g(ind)="" Set ind=1
	i $g(AdmDr)="" Quit $$$OK
	s OrderRowid=""	
 	s OrderRowid=$o(^OEORD(0,"Adm",AdmDr,OrderRowid))
  	i $g(OrderRowid)="" Set qHandle=$lb(0,repid,0)
 	q:$g(OrderRowid)="" $$$OK
 	
 	s drptdr="" f  s drptdr=$o(^Busi.ENS.EnsRISReportResultI("RISRVisitNumberIndex",AdmDr,drptdr)) q:(drptdr="")  d
	.s RISReportData=$g(^Busi.ENS.EnsRISReportResultD(drptdr))
	.s sysType=$lg(RISReportData,7)
	.q:sysType'="PIS"
	.s palgno=$lg(RISReportData,3) //病理号
	.s frezno=$lg(RISReportData,45) //冰冻号
	.s ordItemIDs=$lg(RISReportData,4) //医嘱号
	.s len=$l(ordItemIDs,"^")
	.for i=1:1:len d
	..s ordItemID=$p(ordItemIDs,"^",i)
	..q:ordItemID=""
	..s operateDate="",operateTime="",ESStatusCode=""
	..s ensStatusLogID=$o(^Busi.ENS.EnsStatusLogI("IndexESOrdItemIDExamIDESStatusCode"," "_$zcvt(ordItemID,"U")," "_$zcvt(palgno,"U")," SC"," AP",""))
	..s:ensStatusLogID'="" operateDate=$lg($g(^Busi.ENS.EnsStatusLogD(ensStatusLogID)),7)
	..s:ensStatusLogID'="" operateTime=$lg($g(^Busi.ENS.EnsStatusLogD(ensStatusLogID)),8)
	..s EnsStatusLogDr=$o(^Busi.ENS.EnsStatusLogI("IndexESOrdItemID"," "_$zcvt(ordItemID,"U"),""),-1)
    ..q:EnsStatusLogDr=""
    ..s ESStatusCode=$lg($g(^Busi.ENS.EnsStatusLogD(EnsStatusLogDr)),11)
	..q:(ESStatusCode'="RP")&&(ESStatusCode'="RD")&&(ESStatusCode'="RPV")
	..s:(operateDate'="")&&(operateTime'="") cmadate=$zd(operateDate,3)_" "_$zt(operateTime)
	..s reportDate=$lg(RISReportData,10) //报告日期
	..s reportTime=$lg(RISReportData,11) //报告时间
	..s:(reportDate'="")&&(reportTime'="") rptdate=$zd(reportDate,3)_" "_$zt(reportTime) //报告日期
	..s checkDate=$lg(RISReportData,14) //审核日期
	..s checkTime=$lg(RISReportData,15) //审核时间
	..s:(checkDate'="")&&(checkTime'="") rptdate=$zd(checkDate,3)_" "_$zt(checkTime) //报告审核日期
	..s cmamatl=$lg(RISReportData,46) //送检材料
	..s clncdiag=..GetDiagnoses(AdmDr) //临床诊断
	..s examfnd=$lg(RISReportData,24) //检查意见
	..s sabc=$lg(RISReportData,47) //免疫组化
	..s palgdiag=$lg(RISReportData,25) //病理诊断
	..s rpotdoc=$lg(RISReportData,9) //报告医师
	..s valiflag="1"
	..d OutOEItemInfo
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutOEItemInfo
	set Data=$lb(mdtrtsn,mdtrtid,psnno,palgno,frezno,cmadate,rptdate,cmamatl,clncdiag,examfnd,sabc,palgdiag,rpotdoc,valiflag)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SelectPISRptInfoByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectPISRptInfoByAdmExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SelectPISRptInfoByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectPISRptInfoByAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：ZhangXinying
/// CreatDate：2021—12-16
/// Description：检查记录
/// Table：Ens_RISReportResult、Ens_RISItemResult、Ens_HOSDocument、Ens_RelOrderDocument
/// Input：AdmDr:就诊rowid
/// Output:mdtrt_sn:就医流水号,mdtrt_id:就诊ID,psn_no:人员编号,appy_no:申请单号,appy_doc_name:申请人姓名,rpotc_no:报告单号,rpotc_type_code:报告单类别代码,exam_rpotc_name:检查报告单名称,exam_date:检查日期,rpt_date:报告日期,cma_date:送检日期,sapl_date:采样日期,spcm_no:标本号,spcm_name:标本名称,exam_type_code:检查类别代码,exam_item_code:检查-项目代码,exam_type_name:检查-类别名称,exam_item_name:检查-项目名称,inhosp_exam_item_code:院内检查-项目代码,inhosp_exam_item_name:院内检查-项目名称,exam_part:检查部位,exam_rslt_poit_flag:检查结果阳性标志,exam_rslt_abn:检查/检验结果异常标志,exam_ccls:检查结论,appy_org_name:申请机构名称,appy_dept_code:申请科室代码,exam_dept_code:检查科室代码,ipt_dept_code:住院科室代码,ipt_dept_name:住院科室名称,bilg_dr_codg:开单医生代码,bilg_dr_name:开单医生姓名,exe_org_name:执行机构名称,vali_flag:有效标志
/// Debug:d ##class(%ResultSet).RunQuery("web.DHCENS.STBLL.Method.QueryReportInsu","SelectRISExamInfoByAdm","285","","")
Query SelectRISExamInfoByAdm(AdmDr As %String = "", Rpotcno As %String = "", ExpDataAry As %ArrayOfDataTypes = "") As %Query(ROWSPEC = "mdtrt_sn:%String,mdtrt_id:%String,psn_no:%String,appy_no:%String,appy_doc_name:%String,rpotc_no:%String,rpotc_type_code:%String,exam_rpotc_name:%String,exam_date:%String,rpt_date:%String,cma_date:%String,sapl_date:%String,spcm_no:%String,spcm_name:%String,exam_type_code:%String,exam_item_code:%String,exam_type_name:%String,exam_item_name:%String,inhosp_exam_item_code:%String,inhosp_exam_item_name:%String,exam_part:%String,exam_rslt_poit_flag:%String,exam_rslt_abn:%String,exam_ccls:%String,appy_org_name:%String,appy_dept_code:%String,exam_dept_code:%String,ipt_dept_code:%String,ipt_dept_name:%String,bilg_dr_codg:%String,bilg_dr_name:%String,exe_org_name:%String,vali_flag:%String")
{
}

ClassMethod SelectRISExamInfoByAdmExecute(ByRef qHandle As %Binary, AdmDr As %String = "", Rpotcno As %String = "", ExpDataAry As %ArrayOfDataTypes = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	s (mdtrtsn,mdtrtid,psnno,appyno,appydocname,rpotcno,rpotctypecode,examrpotcname,examdate,rptdate,cmadate,sapldate,spcmno,spcmname,examtypecode,examitemcode,examtypename,examitemname,inhospexamitemcode,inhospexamitemname,exampart,examrsltpoitflag,examrsltabn,examccls,appyorgname,appydeptcode,examdeptcode,iptdeptcode,iptdeptname,bilgdrcodg,bilgdrname,exeorgname,valiflag)=""
	if ($IsObject(ExpDataAry)) {
        //--按照医保接口文档字段命名
        s mdtrtsn = ExpDataAry.GetAt("mdtrt_sn")
        s mdtrtid=ExpDataAry.GetAt("mdtrt_id") //mdtrt_id 就诊ID(非HIS就诊ID) 
        s psnno = ExpDataAry.GetAt("psn_no") //psn_no 人员编号
    }else{
        Set mdtrtsn=AdmDr
        Set mdtrtid=AdmDr
        Set MethodExist=##class(websys.Conversions).IsValidMethodName("web.DHCINSUPort","GetInsuAdmInfoByAdm")
        If (MethodExist) {
            Set InsuAdmInfo=##Class(web.DHCINSUPort).GetInsuAdmInfoByAdm(AdmDr)   //医保接口 如果没有返回，请项目组问医保组要接口
            Set psnno=$PIECE(InsuAdmInfo,"^",1)
        }Else{
            Set psnno="无"
        }
    }
	If $g(ind)="" Set ind=1
	
 	if AdmDr'="" d
	.d GetRISExamInfoByAdm 	
	else  if (AdmDr="")&&(Rpotcno'="") d
	.d GetRISExamInfoByRpt
	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
 	
GetRISExamInfoByAdm	
 	s drptdr="" f  s drptdr=$o(^Busi.ENS.EnsRISReportResultI("RISRVisitNumberIndex",AdmDr,drptdr)) q:(drptdr="")  d
	.s RISReportData=$g(^Busi.ENS.EnsRISReportResultD(drptdr))
	.s sysType=$lg(RISReportData,7) //系统类型
	.q:sysType="PIS"
	.s ordItemIDs=$lg(RISReportData,4) //医嘱号
	.s len=$l(ordItemIDs,"^")
	.s appydocname="",examitemcode="",examitemname=""
	.for i=1:1:len d
	..s ordItemID=$p(ordItemIDs,"^",i)
	..q:ordItemID=""
	..s arcim=$p($g(^OEORD(+ordItemID,"I",$p(ordItemID,"||",2),1)),"^",2)
	..q:arcim=""
	..s arReqID=$o(^DHCAPREP(0,"OrdItem",ordItemID,""))    /// 检查申请ID
	..q:arReqID=""
	..s appyno=$p($g(^DHCAPREP(arReqID)),"^",1) //申请单号
	..s arUserID=$p($g(^DHCAPREP(arReqID)),"^",4)          /// 申请人
	..;s:arUserID'="" appydocname=$p(^SSU("SSUSR",arUserID),"^",2)
	..if appydocname=""  s appydocname=$p($g(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1)),"^",2)
	..else  s appydocname=appydocname_"+"_$p($g(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1)),"^",2)
	..s rpotcno=$lg(RISReportData,2) //报告单号
	..q:(Rpotcno'="")&&(Rpotcno'=rpotcno)
	..s studyno=$lg(RISReportData,3) //检查号
	..s rpotctypecode=sysType //报告单类别代码
	..s examrpotcname=$lg(RISReportData,20) //检查报告单名称
	..if examrpotcname="" d
	...s examrpotcname=$p($g(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1)),"^",2)
	..s frezno=$lg(RISReportData,45) //冰冻号
	..s ordItemID=$lg(RISReportData,4) 
	..s operateDate="",operateTime="",ESStatusCode=""
	..s ensStatusLogID=$o(^Busi.ENS.EnsStatusLogI("IndexESOrdItemIDExamIDESStatusCode"," "_$zcvt(ordItemID,"U")," "_$zcvt(studyno,"U")," SC"," AP",""))
	..s:ensStatusLogID'="" operateDate=$lg($g(^Busi.ENS.EnsStatusLogD(ensStatusLogID)),7)
	..s:ensStatusLogID'="" operateTime=$lg($g(^Busi.ENS.EnsStatusLogD(ensStatusLogID)),8)
	..s:(operateDate'="")&&(operateTime'="") examdate=$zd(operateDate,3)_" "_$zt(operateTime)
	..s EnsStatusLogDr=$o(^Busi.ENS.EnsStatusLogI("IndexESOrdItemID"," "_$zcvt(ordItemID,"U"),""),-1)
    ..q:EnsStatusLogDr=""
    ..s ESStatusCode=$lg($g(^Busi.ENS.EnsStatusLogD(EnsStatusLogDr)),11)
	..q:(ESStatusCode'="RP")&&(ESStatusCode'="RD")&&(ESStatusCode'="RPV")
	..s reportDate=$lg(RISReportData,10) //报告日期
	..s reportTime=$lg(RISReportData,11) //报告时间
	..s:(reportDate'="")&&(reportTime'="") rptdate=$zd(reportDate,3)_" "_$zt(reportTime) //报告日期
	..s checkDate=$lg(RISReportData,14) //审核日期
	..s checkTime=$lg(RISReportData,15) //审核时间
	..s:(checkDate'="")&&(checkTime'="") rptdate=$zd(checkDate,3)_" "_$zt(checkTime) //报告审核日期
	..s cmadate="" //送检日期
	..s sapldate=examdate //采样日期
	..s spcmno="" //标本号
	..s spcmname="" //标本名称
	..s arcitmcatdr=$p($g(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1)),"^",10) //医嘱子分类rowid
	..s:arcitmcatdr'="" examtypecode=$p($g(^ARC("IC",arcitmcatdr)),"^",1) //检查类别代码
	..s:arcitmcatdr'="" examtypename=$p($g(^ARC("IC",arcitmcatdr)),"^",2) //检查类别名称
	..if examitemcode="" s examitemcode=$p($g(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1)),"^",1) //检查项目代码
	..else  s examitemcode=examitemcode_"+"_$p($g(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1)),"^",1)
	..if examitemname="" s examitemname=$p($g(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1)),"^",2) //检查项目名称
	..else  s examitemname=examitemname_"+"_$p($g(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1)),"^",2)
	..s inhospexamitemcode=examitemcode,inhospexamitemname=examitemname //院内检查-项目代码，院内检查-项目名称
	..s exampart=$o(^Busi.ENS.EnsStatusI("IndexESOrdItemIDExamIDPartID"," "_ordItemID," "_studyno,""))
	..s:exampart'="" exampart=$tr(exampart," ","")
	..s examrsltpoitflag=$lg(RISReportData,35) //检查结果阳性标志
	..s examrsltabn=$lg(RISReportData,36) //检查/检验结果异常标志
	..s examccls=$lg(RISReportData,25) //检查结论
	..s AdmLocDr=$p($g(^PAADM(AdmDr)),"^",4),HospDr=""
	..s:AdmLocDr'="" HospDr=$p($g(^CTLOC(AdmLocDr)),"^",22)
	..s:HospDr'="" appyorgname=$p($g(^CT("HOSP",HospDr)),"^",2) //申请机构名称
	..s ordDeptDr=$p($g(^OEORD(+ordItemID,"I",$p(ordItemID,"||",2),1)),"^",3)
	..s:ordDeptDr'="" appydeptcode=$p($g(^CTLOC(ordDeptDr)),"^",1) //申请科室代码
	..s recDeptDr=$p($g(^OEORD(+ordItemID,"I",$p(ordItemID,"||",2),3)),"^",6)
	..s:recDeptDr'="" examdeptcode=$p($g(^CTLOC(recDeptDr)),"^",1) //检查科室代码
	..s:AdmLocDr'="" iptdeptcode=$p($g(^CTLOC(AdmLocDr)),"^",1) //住院科室代码
	..s:AdmLocDr'="" iptdeptname=$p($g(^CTLOC(AdmLocDr)),"^",2) //住院科室名称
	..s:arUserID'="" bilgdrcodg=$p(^SSU("SSUSR",arUserID),"^",1) //开单医生代码
	..s:arUserID'="" bilgdrname=$p(^SSU("SSUSR",arUserID),"^",2) //开单医生姓名
	..s:HospDr'="" exeorgname=$p($g(^CT("HOSP",HospDr)),"^",2) //申请机构名称
	..s valiflag="1"
	..d OutOEItemInfo
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
 	
GetRISExamInfoByRpt
 	s drptdr=$o(^Busi.ENS.EnsRISReportResultI("RISREPORTPKey",$zcvt(Rpotcno,"U"),""))
 	q:drptdr=""
	s RISReportData=$g(^Busi.ENS.EnsRISReportResultD(drptdr))
	s sysType=$lg(RISReportData,7) //系统类型
	q:sysType="PIS"
	s ordItemIDs=$lg(RISReportData,4) //医嘱号
	s Adm=$lg(RISReportData,6) //就诊号 
	s len=$l(ordItemIDs,"^")
	s appydocname="",examitemcode="",examitemname=""
	for i=1:1:len d
	.s ordItemID=$p(ordItemIDs,"^",i)
	.q:ordItemID=""
	.s arcim=$p($g(^OEORD(+ordItemID,"I",$p(ordItemID,"||",2),1)),"^",2)
	.q:arcim=""
	.s arReqID=$o(^DHCAPREP(0,"OrdItem",ordItemID,""))    /// 检查申请ID
	.q:arReqID=""
	.s appyno=$p($g(^DHCAPREP(arReqID)),"^",1) //申请单号
	.s arUserID=$p($g(^DHCAPREP(arReqID)),"^",4)          /// 申请人
	.;s:arUserID'="" appydocname=$p(^SSU("SSUSR",arUserID),"^",2)
	.if appydocname=""  s appydocname=$p($g(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1)),"^",2)
	.else  s appydocname=appydocname_"+"_$p($g(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1)),"^",2)
	.s rpotcno=$lg(RISReportData,2) //报告单号
	.q:(Rpotcno'="")&&(Rpotcno'=rpotcno)
	.s studyno=$lg(RISReportData,3) //检查号
	.s rpotctypecode=sysType //报告单类别代码
	.s examrpotcname=$lg(RISReportData,20) //检查报告单名称
	.if examrpotcname="" d
	..s examrpotcname=$p($g(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1)),"^",2)
	.s frezno=$lg(RISReportData,45) //冰冻号
	.s ordItemID=$lg(RISReportData,4) 
	.s operateDate="",operateTime="",ESStatusCode=""
	.s ensStatusLogID=$o(^Busi.ENS.EnsStatusLogI("IndexESOrdItemIDExamIDESStatusCode"," "_$zcvt(ordItemID,"U")," "_$zcvt(studyno,"U")," SC"," AP",""))
	.s:ensStatusLogID'="" operateDate=$lg($g(^Busi.ENS.EnsStatusLogD(ensStatusLogID)),7)
	.s:ensStatusLogID'="" operateTime=$lg($g(^Busi.ENS.EnsStatusLogD(ensStatusLogID)),8)
	.s:(operateDate'="")&&(operateTime'="") examdate=$zd(operateDate,3)_" "_$zt(operateTime)
	.s EnsStatusLogDr=$o(^Busi.ENS.EnsStatusLogI("IndexESOrdItemID"," "_$zcvt(ordItemID,"U"),""),-1)
    .q:EnsStatusLogDr=""
    .s ESStatusCode=$lg($g(^Busi.ENS.EnsStatusLogD(EnsStatusLogDr)),11)
	.q:(ESStatusCode'="RP")&&(ESStatusCode'="RD")&&(ESStatusCode'="RPV")
	.s reportDate=$lg(RISReportData,10) //报告日期
	.s reportTime=$lg(RISReportData,11) //报告时间
	.s:(reportDate'="")&&(reportTime'="") rptdate=$zd(reportDate,3)_" "_$zt(reportTime) //报告日期
	.s checkDate=$lg(RISReportData,14) //审核日期
	.s checkTime=$lg(RISReportData,15) //审核时间
	.s:(checkDate'="")&&(checkTime'="") rptdate=$zd(checkDate,3)_" "_$zt(checkTime) //报告审核日期
	.s cmadate="" //送检日期
	.s sapldate=examdate //采样日期
	.s spcmno="" //标本号
	.s spcmname="" //标本名称
	.s arcitmcatdr=$p($g(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1)),"^",10) //医嘱子分类rowid
	.s:arcitmcatdr'="" examtypecode=$p($g(^ARC("IC",arcitmcatdr)),"^",1) //检查类别代码
	.s:arcitmcatdr'="" examtypename=$p($g(^ARC("IC",arcitmcatdr)),"^",2) //检查类别名称
	.if examitemcode="" s examitemcode=$p($g(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1)),"^",1) //检查项目代码
	.else  s examitemcode=examitemcode_"+"_$p($g(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1)),"^",1)
	.if examitemname="" s examitemname=$p($g(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1)),"^",2) //检查项目名称
	.else  s examitemname=examitemname_"+"_$p($g(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1)),"^",2)
	.s inhospexamitemcode=examitemcode,inhospexamitemname=examitemname //院内检查-项目代码，院内检查-项目名称
	.s exampart=$o(^Busi.ENS.EnsStatusI("IndexESOrdItemIDExamIDPartID"," "_ordItemID," "_studyno,""))
	.s:exampart'="" exampart=$tr(exampart," ","")
	.s examrsltpoitflag=$lg(RISReportData,35) //检查结果阳性标志
	.s examrsltabn=$lg(RISReportData,36) //检查/检验结果异常标志
	.s examccls=$lg(RISReportData,25) //检查结论
	.s AdmLocDr=$p($g(^PAADM(Adm)),"^",4),HospDr=""
	.s:AdmLocDr'="" HospDr=$p($g(^CTLOC(AdmLocDr)),"^",22)
	.s:HospDr'="" appyorgname=$p($g(^CT("HOSP",HospDr)),"^",2) //申请机构名称
	.s ordDeptDr=$p($g(^OEORD(+ordItemID,"I",$p(ordItemID,"||",2),1)),"^",3)
	.s:ordDeptDr'="" appydeptcode=$p($g(^CTLOC(ordDeptDr)),"^",1) //申请科室代码
	.s recDeptDr=$p($g(^OEORD(+ordItemID,"I",$p(ordItemID,"||",2),3)),"^",6)
	.s:recDeptDr'="" examdeptcode=$p($g(^CTLOC(recDeptDr)),"^",1) //检查科室代码
	.s:AdmLocDr'="" iptdeptcode=$p($g(^CTLOC(AdmLocDr)),"^",1) //住院科室代码
	.s:AdmLocDr'="" iptdeptname=$p($g(^CTLOC(AdmLocDr)),"^",2) //住院科室名称
	.s:arUserID'="" bilgdrcodg=$p(^SSU("SSUSR",arUserID),"^",1) //开单医生代码
	.s:arUserID'="" bilgdrname=$p(^SSU("SSUSR",arUserID),"^",2) //开单医生姓名
	.s:HospDr'="" exeorgname=$p($g(^CT("HOSP",HospDr)),"^",2) //申请机构名称
	.s valiflag="1"
	.d OutOEItemInfo
	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutOEItemInfo
	set Data=$lb(mdtrtsn,mdtrtid,psnno,appyno,appydocname,rpotcno,rpotctypecode,examrpotcname,examdate,rptdate,cmadate,sapldate,spcmno,spcmname,examtypecode,examitemcode,examtypename,examitemname,inhospexamitemcode,inhospexamitemname,exampart,examrsltpoitflag,examrsltabn,examccls,appyorgname,appydeptcode,examdeptcode,iptdeptcode,iptdeptname,bilgdrcodg,bilgdrname,exeorgname,valiflag)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SelectRISExamInfoByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectRISExamInfoByAdmExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SelectRISExamInfoByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectRISExamInfoByAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：ZhangXinying
/// CreatDate：2021—12-16
/// Description：检查项目信息
/// Table：Ens_RISReportResult、Ens_RISItemResult、Ens_HOSDocument、Ens_RelOrderDocument
/// Input：AdmDr:就诊rowid
/// Output:appy_no:申请单号,rpotc_no:报告单号,exam_item_code:检查-项目代码,exam_item_name:检查-项目名称,inhosp_exam_item_code:院内检查-项目代码,inhosp_exam_item_name:院内检查-项目名称,exam_charge:检查费用
/// Debug:d ##class(%ResultSet).RunQuery("web.DHCENS.STBLL.Method.QueryReportInsu","SelectRISItemInfoByAdm","285","")
Query SelectRISItemInfoByAdm(AdmDr As %String = "", Rpotcno As %String = "") As %Query(ROWSPEC = "appy_no:%String,rpotc_no:%String,exam_item_code:%String,exam_item_name:%String,inhosp_exam_item_code:%String,inhosp_exam_item_name:%String,exam_charge:%String")
{
}

ClassMethod SelectRISItemInfoByAdmExecute(ByRef qHandle As %Binary, AdmDr As %String, Rpotcno As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	s (appyno,rpotcno,examitemcode,examitemname,inhospexamitemcode,inhospexamitemname,examcharge)=""
	If $g(ind)="" Set ind=1
 	if AdmDr'="" d
	.d GetRISItemInfoByAdm 	
	else  if (AdmDr="")&&(Rpotcno'="") d
	.d GetRISItemInfoByRpt
	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
GetRISItemInfoByAdm
 	s drptdr="" f  s drptdr=$o(^Busi.ENS.EnsRISReportResultI("RISRVisitNumberIndex",AdmDr,drptdr)) q:(drptdr="")  d
	.s RISReportData=$g(^Busi.ENS.EnsRISReportResultD(drptdr))
	.s sysType=$lg(RISReportData,7) //系统类型
	.q:sysType="PIS"
	.s ordItemIDs=$lg(RISReportData,4) //医嘱号
	.s len=$l(ordItemIDs,"^")
	.s examitemcode="",examitemname="",examcharge=""
	.for i=1:1:len d
	..s ordItemID=$p(ordItemIDs,"^",i)
	..q:ordItemID=""
	..s arcim=$p($g(^OEORD(+ordItemIDs,"I",$p(ordItemIDs,"||",2),1)),"^",2)
	..q:arcim=""
	..s arReqID=$o(^DHCAPREP(0,"OrdItem",ordItemID,""))    /// 检查申请ID
	..q:arReqID=""
	..s appyno=$p($g(^DHCAPREP(arReqID)),"^",1) //申请单号
	..s EnsStatusLogDr=$o(^Busi.ENS.EnsStatusLogI("IndexESOrdItemID"," "_$zcvt(ordItemID,"U"),""),-1)
    ..q:EnsStatusLogDr=""
    ..s ESStatusCode=$lg($g(^Busi.ENS.EnsStatusLogD(EnsStatusLogDr)),11)
	..q:(ESStatusCode'="RP")&&(ESStatusCode'="RD")&&(ESStatusCode'="RPV")
	..s rpotcno=$lg(RISReportData,2) //报告单号
	..q:(Rpotcno'="")&&(Rpotcno'=rpotcno)
	..s studyno=$lg(RISReportData,3) //检查号
	..if examitemcode="" s examitemcode=$p($g(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1)),"^",1) //检查项目代码
	..else  s examitemcode=examitemcode_"+"_$p($g(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1)),"^",1)
	..if examitemname="" s examitemname=$p($g(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1)),"^",2) //检查项目名称
	..else  s examitemname=examitemname_"+"_$p($g(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1)),"^",2)
	..s inhospexamitemcode=examitemcode,inhospexamitemname=examitemname //院内检查-项目代码，院内检查-项目名称
	..s examcharge=examcharge+(..GetPrice(ordItemID))
	..d OutOEItemInfo
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
GetRISItemInfoByRpt
	s drptdr=$o(^Busi.ENS.EnsRISReportResultI("RISREPORTPKey",$zcvt(Rpotcno,"U"),""))
	q:drptdr=""
	s RISReportData=$g(^Busi.ENS.EnsRISReportResultD(drptdr))
	s sysType=$lg(RISReportData,7) //系统类型
	q:sysType="PIS"
	s ordItemIDs=$lg(RISReportData,4) //医嘱号
	s len=$l(ordItemIDs,"^")
	s examitemcode="",examitemname="",examcharge=""
	for i=1:1:len d
	.s ordItemID=$p(ordItemIDs,"^",i)
	.q:ordItemID=""
	.s arcim=$p($g(^OEORD(+ordItemIDs,"I",$p(ordItemIDs,"||",2),1)),"^",2)
	.q:arcim=""
	.s arReqID=$o(^DHCAPREP(0,"OrdItem",ordItemID,""))    /// 检查申请ID
	.q:arReqID=""
	.s appyno=$p($g(^DHCAPREP(arReqID)),"^",1) //申请单号
	.s EnsStatusLogDr=$o(^Busi.ENS.EnsStatusLogI("IndexESOrdItemID"," "_$zcvt(ordItemID,"U"),""),-1)
    .q:EnsStatusLogDr=""
    .s ESStatusCode=$lg($g(^Busi.ENS.EnsStatusLogD(EnsStatusLogDr)),11)
	.q:(ESStatusCode'="RP")&&(ESStatusCode'="RD")&&(ESStatusCode'="RPV")
	.s rpotcno=$lg(RISReportData,2) //报告单号
	.q:(Rpotcno'="")&&(Rpotcno'=rpotcno)
	.s studyno=$lg(RISReportData,3) //检查号
	.if examitemcode="" s examitemcode=$p($g(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1)),"^",1) //检查项目代码
	.else  s examitemcode=examitemcode_"+"_$p($g(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1)),"^",1)
	.if examitemname="" s examitemname=$p($g(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1)),"^",2) //检查项目名称
	.else  s examitemname=examitemname_"+"_$p($g(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1)),"^",2)
	.s inhospexamitemcode=examitemcode,inhospexamitemname=examitemname //院内检查-项目代码，院内检查-项目名称
	.s examcharge=examcharge+(..GetPrice(ordItemID))
	.d OutOEItemInfo
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutOEItemInfo
	set Data=$lb(appyno,rpotcno,examitemcode,examitemname,inhospexamitemcode,inhospexamitemname,examcharge)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SelectRISItemInfoByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectRISItemInfoByAdmExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SelectRISItemInfoByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectRISItemInfoByAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：ZhangXinying
/// CreatDate：2021—12-16
/// Description：检查标本信息
/// Table：Ens_RISReportResult、Ens_RISItemResult、Ens_HOSDocument、Ens_RelOrderDocument
/// Input：AdmDr:就诊rowid
/// Output:rpotc_no:报告单号,appy_no:申请单号,sapl_date:采样日期,spcm_no:标本号,spcm_name:标本名称
/// Debug:d ##class(%ResultSet).RunQuery("web.DHCENS.STBLL.Method.QueryReportInsu","SelectRISSampleInfoByAdm","285")
Query SelectRISSampleInfoByAdm(AdmDr As %String = "") As %Query(ROWSPEC = "rpotc_no:%String,appy_no:%String,sapl_date:%String,spcm_no:%String,spcm_name:%String")
{
}

ClassMethod SelectRISSampleInfoByAdmExecute(ByRef qHandle As %Binary, AdmDr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	s (rpotcno,appyno,sapldate,spcmno,spcmname)=""
	
	If $g(ind)="" Set ind=1
	i $g(AdmDr)="" Quit $$$OK
	s OrderRowid=""	
 	s OrderRowid=$o(^OEORD(0,"Adm",AdmDr,OrderRowid))
  	i $g(OrderRowid)="" Set qHandle=$lb(0,repid,0)
 	q:$g(OrderRowid)="" $$$OK
 	
 	s drptdr="" f  s drptdr=$o(^Busi.ENS.EnsRISReportResultI("RISRVisitNumberIndex",AdmDr,drptdr)) q:(drptdr="")  d
	.s RISReportData=$g(^Busi.ENS.EnsRISReportResultD(drptdr))
	.s sysType=$lg(RISReportData,7) //系统类型
	.q:sysType="PIS"
	.s ordItemIDs=$lg(RISReportData,4) //医嘱号
	.s len=$l(ordItemIDs,"^")
	.for i=1:1:len d
	..s ordItemID=$p(ordItemIDs,"^",i)
	..q:ordItemID=""
	..s arcim=$p($g(^OEORD(+ordItemID,"I",$p(ordItemID,"||",2),1)),"^",2)
	..q:ordItemID=""
	..s arReqID=$o(^DHCAPREP(0,"OrdItem",ordItemID,""))    /// 检查申请ID
	..q:arReqID=""
	..s appyno=$p($g(^DHCAPREP(arReqID)),"^",1) //申请单号
	..s EnsStatusLogDr=$o(^Busi.ENS.EnsStatusLogI("IndexESOrdItemID"," "_$zcvt(ordItemID,"U"),""),-1)
    ..q:EnsStatusLogDr=""
    ..s ESStatusCode=$lg($g(^Busi.ENS.EnsStatusLogD(EnsStatusLogDr)),11)
	..q:(ESStatusCode'="RP")&&(ESStatusCode'="RD")&&(ESStatusCode'="RPV")
	..s rpotcno=$lg(RISReportData,2) //报告单号
	..;s studyno=$lg(RISReportData,3) //检查号
	..s sapldate="" //采样日期
	..s spcmno="" //标本号
	..s spcmname="" //标本名称
	..d OutOEItemInfo
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutOEItemInfo
	set Data=$lb(rpotcno,appyno,sapldate,spcmno,spcmname)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SelectRISSampleInfoByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectRISSampleInfoByAdmExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SelectRISSampleInfoByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectRISSampleInfoByAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：ZhangXinying
/// CreatDate：2021—12-16
/// Description：检查图像信息
/// Table：Ens_RISReportResult、Ens_RISItemResult、Ens_HOSDocument、Ens_RelOrderDocument
/// Input：AdmDr:就诊rowid
/// Output:rpotc_no:报告单号,study_uid:全局唯一号,patient_id:检查号,patient_name:患者姓名,acession_no:图像流水号,study_time:检查时间,modality:检查类型,store_path:存储路径,series_count:序列数量,image_count:图像数量
/// Debug:d ##class(%ResultSet).RunQuery("web.DHCENS.STBLL.Method.QueryReportInsu","SelectRISImageInfoByAdm","285","")
Query SelectRISImageInfoByAdm(AdmDr As %String = "", Rpotcno As %String = "") As %Query(ROWSPEC = "rpotc_no:%String,study_uid:%String,patient_id:%String,patient_name:%String,acession_no:%String,study_time:%String,modality:%String,store_path:%String,series_count:%String,image_count:%String")
{
}

ClassMethod SelectRISImageInfoByAdmExecute(ByRef qHandle As %Binary, AdmDr As %String = "", Rpotcno As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	s (rpotcno,studyuid,patientid,patientname,acessionno,studytime,modality,storepath,seriescount,imagecount)=""
	If $g(ind)="" Set ind=1
	if AdmDr'="" d
	.d GetRISImageInfoByAdm 	
	else  if (AdmDr="")&&(Rpotcno'="") d
	.d GetRISImageInfoByRpt
	
GetRISImageInfoByAdm
 	s drptdr="" f  s drptdr=$o(^Busi.ENS.EnsRISReportResultI("RISRVisitNumberIndex",AdmDr,drptdr)) q:(drptdr="")  d
	.s RISReportData=$g(^Busi.ENS.EnsRISReportResultD(drptdr))
	.s sysType=$lg(RISReportData,7) //系统类型
	.q:sysType="PIS"
	.s ordItemIDs=$lg(RISReportData,4) //医嘱号
	.s len=$l(ordItemIDs,"^")
	.for i=1:1:len d
	..s ordItemID=$p(ordItemIDs,"^",i)
	..q:ordItemID=""
	..s arcim=$p($g(^OEORD(+ordItemID,"I",$p(ordItemID,"||",2),1)),"^",2)
	..q:ordItemID=""
	..s arReqID=$o(^DHCAPREP(0,"OrdItem",ordItemID,""))    /// 检查申请ID
	..q:arReqID=""
	..s appyno=$p($g(^DHCAPREP(arReqID)),"^",1) //申请单号
	..s EnsStatusLogDr=$o(^Busi.ENS.EnsStatusLogI("IndexESOrdItemID"," "_$zcvt(ordItemID,"U"),""),-1)
    ..q:EnsStatusLogDr=""
    ..s ESStatusCode=$lg($g(^Busi.ENS.EnsStatusLogD(EnsStatusLogDr)),11)
	..q:(ESStatusCode'="RP")&&(ESStatusCode'="RD")&&(ESStatusCode'="RPV")
	..s rpotcno=$lg(RISReportData,2) //报告单号
	..q:(Rpotcno'="")&&(Rpotcno'=rpotcno)
	..s studyuid=$lg(RISReportData,3) //图像中的study_uid
	..s RISRPatientID=$lg(RISReportData,5) //病人基本信息rowid
	..s:RISRPatientID'="" patientid=$p($g(^PAPER(RISRPatientID,"PAT",1)),"^",1) //病人ID
	..s:RISRPatientID'="" patientname=$p($g(^PAPER(RISRPatientID,"ALL")),"^",1)
	..s acessionno=$lg(RISReportData,3) ;"" //图像流水号
	..s checkDate=$lg(RISReportData,14),checkTime=$lg(RISReportData,15)
	..s:(checkDate'="")&&(checkTime'="") studytime=$zd(checkDate,3)_" "_$zt(checkTime) //检查时间
	..s modality=sysType //检查类型
	..s HOSDocuType=$case(sysType,"PACS":"02001","US":"02002","ES":"02003","EKG":"02004","PACS":"02005","PIS":"02006",:"")
	..s serialNumber=HOSDocuType_"_"_rpotcno_".xml"
	..s DocuID=$o(^Busi.ENS.EnsHOSDocumentI("HOSDOCUMENTSerialIndex",serialNumber,""))
	..q:DocuID=""
	..s storepath=$lg($g(^Busi.ENS.EnsHOSDocumentD(DocuID)),19) //存储路径
	..s serialNumberPdf=HOSDocuType_"_"_rpotcno_".pdf"
	..s DocuIDPdf=$o(^Busi.ENS.EnsHOSDocumentI("HOSDOCUMENTSerialIndex",serialNumber,""))
	..q:DocuIDPdf=""
	..s picpath=$lg($g(^Busi.ENS.EnsHOSDocumentD(DocuIDPdf)),21) //图像存储路径
	..s:picpath'="" seriescount=$l(picpath,"#")
	..s:picpath'="" imagecount=$l(picpath,"#")
	..d OutOEItemInfo
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
 	
GetRISImageInfoByRpt
 	s drptdr=$o(^Busi.ENS.EnsRISReportResultI("RISREPORTPKey",$zcvt(Rpotcno,"U"),""))
 	q:drptdr=""
	s RISReportData=$g(^Busi.ENS.EnsRISReportResultD(drptdr))
	s sysType=$lg(RISReportData,7) //系统类型
	q:sysType="PIS"
	s ordItemIDs=$lg(RISReportData,4) //医嘱号
	s len=$l(ordItemIDs,"^")
	for i=1:1:len d
	.s ordItemID=$p(ordItemIDs,"^",i)
	.q:ordItemID=""
	.s arcim=$p($g(^OEORD(+ordItemID,"I",$p(ordItemID,"||",2),1)),"^",2)
	.q:ordItemID=""
	.s arReqID=$o(^DHCAPREP(0,"OrdItem",ordItemID,""))    /// 检查申请ID
	.q:arReqID=""
	.s appyno=$p($g(^DHCAPREP(arReqID)),"^",1) //申请单号
	.s EnsStatusLogDr=$o(^Busi.ENS.EnsStatusLogI("IndexESOrdItemID"," "_$zcvt(ordItemID,"U"),""),-1)
    .q:EnsStatusLogDr=""
    .s ESStatusCode=$lg($g(^Busi.ENS.EnsStatusLogD(EnsStatusLogDr)),11)
	.q:(ESStatusCode'="RP")&&(ESStatusCode'="RD")&&(ESStatusCode'="RPV")
	.s rpotcno=$lg(RISReportData,2) //报告单号
	.q:(Rpotcno'="")&&(Rpotcno'=rpotcno)
	.s studyuid=$lg(RISReportData,3) //图像中的study_uid
	.s RISRPatientID=$lg(RISReportData,5) //病人基本信息rowid
	.s:RISRPatientID'="" patientid=$p($g(^PAPER(RISRPatientID,"PAT",1)),"^",1) //病人ID
	.s:RISRPatientID'="" patientname=$p($g(^PAPER(RISRPatientID,"ALL")),"^",1)
	.s acessionno=$lg(RISReportData,3) //图像流水号
	.s checkDate=$lg(RISReportData,14),checkTime=$lg(RISReportData,15)
	.s:(checkDate'="")&&(checkTime'="") studytime=$zd(checkDate,3)_" "_$zt(checkTime) //检查时间
	.s modality=sysType //检查类型
	.s HOSDocuType=$case(sysType,"PACS":"02001","US":"02002","ES":"02003","EKG":"02004","PACS":"02005","PIS":"02006",:"")
	.s serialNumber=HOSDocuType_"_"_rpotcno_".xml"
	.s DocuID=$o(^Busi.ENS.EnsHOSDocumentI("HOSDOCUMENTSerialIndex",serialNumber,""))
	.q:DocuID=""
	.s storepath=$lg($g(^Busi.ENS.EnsHOSDocumentD(DocuID)),19) //存储路径
	.s serialNumberPdf=HOSDocuType_"_"_rpotcno_".pdf"
	.s DocuIDPdf=$o(^Busi.ENS.EnsHOSDocumentI("HOSDOCUMENTSerialIndex",serialNumber,""))
	.q:DocuIDPdf=""
	.s picpath=$lg($g(^Busi.ENS.EnsHOSDocumentD(DocuIDPdf)),21) //图像存储路径
	.s:picpath'="" seriescount=$l(picpath,"#")
	.s:picpath'="" imagecount=$l(picpath,"#")
	.d OutOEItemInfo
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutOEItemInfo
	set Data=$lb(rpotcno,studyuid,patientid,patientname,acessionno,studytime,modality,storepath,seriescount,imagecount)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SelectRISImageInfoByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectRISImageInfoByAdmExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SelectRISImageInfoByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectRISImageInfoByAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：ZhangXinying
/// CreatDate：2021—12-16
/// Description：检验信息
/// Table：Ens_LISReportResult、Ens_LISItemResult、Ens_LISItemSenResult、Ens_HOSDocument、Ens_RelOrderDocument
/// Input：SDate:开始日期, EDate:结束日期, HospId:院区代码, RegNo:登记号, AdmDr:就诊号, VisitNumber:条码号, AdmType:就诊类型,Rpotcno:报告ID,ExpDataAry:医保数组
/// Output:mdtrt_sn:就医流水号,mdtrt_id:就诊ID,psn_no:人员编号,appy_no:申请单号,appy_org_code:申请机构代码,appy_org_name:申请机构名称,bilg_dr_codg:开单医生代码,bilg_dr_name:开单医生姓名,exam_org_code:检验机构代码,exam_org_name:检验机构名称,appy_dept_code:申请科室代码,exam_dept_code:检查科室代码,exam_mtd:检验方法,rpotc_no:报告单号,exam_item_code:检验项目代码,exam_item_name:检验项目名称,inhosp_exam_item_code:院内检验-项目代码,inhosp_exam_item_name:院内检验-项目名称,rpt_date:报告日期,rpot_doc:报告医师,exam_charge:检查费用,vali_flag:有效标志
/// Debug:d ##class(%ResultSet).RunQuery("web.DHCENS.STBLL.Method.QueryReportInsu","SelectLabInfo","","","","","528","","","","")
Query SelectLabInfo(SDate As %String = "", EDate As %String = "", HospId As %String = "", RegNo As %String = "", AdmDr As %String = "", VisitNumber As %String = "", AdmType As %String = "", Rpotcno As %String = "", ExpDataAry As %ArrayOfDataTypes = "") As %Query(ROWSPEC = "mdtrt_sn:%String,mdtrt_id:%String,psn_no:%String,appy_no:%String,appy_org_code:%String,appy_org_name:%String,bilg_dr_codg:%String,bilg_dr_name:%String,exam_org_code:%String,exam_org_name:%String,appy_dept_code:%String,exam_dept_code:%String,exam_mtd:%String,rpotc_no:%String,exam_item_code:%String,exam_item_name:%String,inhosp_exam_item_code:%String,inhosp_exam_item_name:%String,rpt_date:%String,rpot_doc:%String,exam_charge:%String,vali_flag:%String")
{
}

ClassMethod SelectLabInfoExecute(ByRef qHandle As %Binary, SDate As %String = "", EDate As %String = "", HospId As %String = "", RegNo As %String = "", AdmDr As %String = "", VisitNumber As %String = "", AdmType As %String = "", Rpotcno As %String = "", ExpDataAry As %ArrayOfDataTypes = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	s (mdtrtsn,mdtrtid,psnno,appyno,appyorgcode,appyorgname,bilgdrcodg,bilgdrname,examorgcode,examorgname,appydeptcode,examdeptcode,exammtd,rpotcno,examitemcode,examitemname,inhospexamitemcode,inhospexamitemname,rptdate,rpotdoc,examcharge,valiflag)=""
	if ($IsObject(ExpDataAry)) {
        //--按照医保接口文档字段命名
        s mdtrtsn = ExpDataAry.GetAt("mdtrt_sn")
        s mdtrtid=ExpDataAry.GetAt("mdtrt_id") //mdtrt_id 就诊ID(非HIS就诊ID) 
        s psnno = ExpDataAry.GetAt("psn_no") //psn_no 人员编号
    }else{
        Set mdtrtsn=AdmDr
        Set mdtrtid=AdmDr
        Set MethodExist=##class(websys.Conversions).IsValidMethodName("web.DHCINSUPort","GetInsuAdmInfoByAdm")
        If (MethodExist) {
            Set InsuAdmInfo=##Class(web.DHCINSUPort).GetInsuAdmInfoByAdm(AdmDr)   //医保接口 如果没有返回，请项目组问医保组要接口
            Set psnno=$PIECE(InsuAdmInfo,"^",1)
        }Else{
            Set psnno="无"
        }
    }
	If $g(ind)="" Set ind=1
	
 	if (SDate'="")&&(SDate["-") s SDate=$zdh(SDate,3)
 	if (EDate'="")&&(EDate["-") s EDate=$zdh(EDate,3)
 	if (SDate'="")&&(SDate["/") s SDate=$zdh(SDate,4)
 	if (EDate'="")&&(EDate["/") s EDate=$zdh(EDate,4)
 	if RegNo'="" d
 	.set PapmiDr=$o(^PAPERi("PAPMI_PatNo",RegNo,""))
 	.set PAAdmType="" for  s PAAdmType=$o(^PAPERdr(PapmiDr,"ADM",PAAdmType)) q:PAAdmType=""  d
 	..set Adm=""  for  s Adm=$o(^PAPERdr(PapmiDr,"ADM",PAAdmType,Adm)) q:Adm=""  d
 	...d GetTSInfoByAdm
 	s Adm=AdmDr
 	else  if (RegNo="")&&(Adm'="") d
 	.d GetTSInfoByAdm
 	else  if (Adm="")&&(Rpotcno'="") d
 	.d GetTSInfoByRpt
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
GetTSInfoByAdm
	s drptdr="" f  s drptdr=$o(^Busi.ENS.EnsLISReportResultI("LISRRVisitNumberIndex",Adm,drptdr)) q:(drptdr="")  d
	.s LISReportData=$g(^Busi.ENS.EnsLISReportResultD(drptdr))
	.s AdmLocDr=$p($g(^PAADM(Adm)),"^",4)
	.s HospDr=$p($g(^CTLOC(AdmLocDr)),"^",22)
	.s:HospDr'="" HospCode=$p($g(^CT("HOSP",HospDr)),"^",1)
	.q:(HospId'="")&&(HospId'=HospCode)
	.s LISRRPatientID=$lg(LISReportData,3)
	.s PapmiNo=$p($g(^PAPER(LISRRPatientID,"PAT",1)),"^",1)
	.q:(RegNo'="")&&(PapmiNo'=RegNo)
	.s LISRRVisitNumber=$lg(LISReportData,5)
	.q:(VisitNumber'="")&&(LISRRVisitNumber'=VisitNumber)
	.s LISRRCheckDate=$lg(LISReportData,107)
	.q:(SDate'="")&&(LISRRCheckDate<SDate)
	.q:(EDate'="")&&(LISRRCheckDate>EDate)
	.s LISRREncounterTypeCode=$lg(LISReportData,4)
	.q:(AdmType'="")&&(LISRREncounterTypeCode'=AdmType)
	.s LISRRReportID=$lg(LISReportData,2)
	.q:(Rpotcno'="")&&(Rpotcno'=LISRRReportID)
	.s LISSRSpecimenID=$o(^Busi.ENS.EnsLISSpecimenReportI("LISSPECIMENREPORTPKey"," "_$zcvt(LISRRReportID,"U"),""))
	.s:LISSRSpecimenID'="" appyno=$tr(LISSRSpecimenID," ","") //申请单号
	.s examitemcode="",examitemname="",examcharge=""
	.s LISSROrderItemID="" f  s LISSROrderItemID=$o(^Busi.ENS.EnsLISSpecimenReportI("LISSPECIMENREPORTPKey"," "_$zcvt(LISRRReportID,"U"),LISSRSpecimenID,LISSROrderItemID)) q:LISSROrderItemID=""  d
	..s EnsStatusLogDr=$o(^Busi.ENS.EnsStatusLogI("IndexESOrdItemID"," "_$zcvt(LISSROrderItemID,"U"),""),-1)
    ..q:EnsStatusLogDr=""
    ..s ESStatusCode=$lg($g(^Busi.ENS.EnsStatusLogD(EnsStatusLogDr)),11)
	..q:(ESStatusCode'="RP")&&(ESStatusCode'="RD")&&(ESStatusCode'="RPV")&&(ESStatusCode'="PRP")
	..s ordDeptDr="",ordDocDr=""
	..s:LISSROrderItemID'="" ordDeptDr=$p($g(^OEORD(+LISSROrderItemID,"I",$p(LISSROrderItemID,"||",2),1)),"^",3)
	..s:LISSROrderItemID'="" ordDocDr=$p($g(^OEORD(+LISSROrderItemID,"I",$p(LISSROrderItemID,"||",2),1)),"^",11)
	..s:LISSROrderItemID'="" examDeptDr=$p($g(^OEORD(+LISSROrderItemID,"I",$p(LISSROrderItemID,"||",2),3)),"^",6)
	..s appyorgcode=HospCode //申请机构代码
	..s:HospDr'="" appyorgname=$p($g(^CT("HOSP",HospDr)),"^",2) //申请机构名称
	..s:ordDocDr'="" bilgdrcodg=$p($g(^CTPCP(ordDocDr,1)),"^",1) //开单医生代码
	..s:ordDocDr'="" bilgdrname=$p($g(^CTPCP(ordDocDr,1)),"^",2) //开单医生姓名
	..s examorgcode=HospCode //检验机构代码
	..s:HospDr'="" examorgname=$p($g(^CT("HOSP",HospDr)),"^",2) //检验机构名称
	..s:ordDeptDr'="" appydeptcode=$p($g(^CTLOC(ordDeptDr)),"^",1) //申请科室代码
	..s:examDeptDr'="" examdeptcode=$p($g(^CTLOC(examDeptDr)),"^",1) //检查科室代码
	..s exammtd="" //检验方法
	..&SQL(select TOP 1 LISIR_TestMethod into :exammtd from SQLUser.Ens_LISItemResult where LISIR_ReportID=:LISRRReportID and LISIR_TestMethod is not null)
	..s rpotcno=LISRRReportID //报告单号
	..s ArcimID=$p($g(^OEORD(+LISSROrderItemID,"I",$p(LISSROrderItemID,"||",2),1)),"^",2) 
	..q:ArcimID=""
	..if examitemcode="" s examitemcode=$p($g(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1)),"^",1) //检验项目代码
	..else  s examitemcode=examitemcode_"+"_$p($g(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1)),"^",1)
	..if examitemname="" s examitemname=$p($g(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1)),"^",2) //检验项目名称
	..else  s examitemname=examitemname_"+"_$p($g(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1)),"^",2)
	..s inhospexamitemcode=examitemcode //院内检验-项目代码
	..s inhospexamitemname=examitemname //院内检验-项目名称
	..s LISRRCheckDate=$lg(LISReportData,107),LISRRCheckTime=$lg(LISReportData,108)
	..s:((LISRRCheckDate'="")&&(LISRRCheckTime'="")) rptdate=$zd(LISRRCheckDate,3)_" "_$zt(LISRRCheckTime) //报告日期
	..s rpotdoc=$lg(LISReportData,110) //报告医师
	..s examcharge=examcharge+(..GetPrice(LISSROrderItemID)) //检查费用
	..s valiflag="1"
	.d OutOEItemInfo
	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
 	
GetTSInfoByRpt
	s drptdr=$o(^Busi.ENS.EnsLISReportResultI("LISREPORTRESULTPKey",$zcvt(Rpotcno,"U"),""))
	q:drptdr=""
	s LISReportData=$g(^Busi.ENS.EnsLISReportResultD(drptdr))
	s Adm=$lg(LISReportData,5)
	q:Adm=""
	s AdmLocDr=$p($g(^PAADM(Adm)),"^",4)
	q:AdmLocDr=""
	s HospDr=$p($g(^CTLOC(AdmLocDr)),"^",22)
	s:HospDr'="" HospCode=$p($g(^CT("HOSP",HospDr)),"^",1)
	q:(HospId'="")&&(HospId'=HospCode)
	s LISRRPatientID=$lg(LISReportData,3)
	s PapmiNo=$p($g(^PAPER(LISRRPatientID,"PAT",1)),"^",1)
	q:(RegNo'="")&&(PapmiNo'=RegNo)
	s LISRRVisitNumber=$lg(LISReportData,5)
	q:(VisitNumber'="")&&(LISRRVisitNumber'=VisitNumber)
	s LISRRCheckDate=$lg(LISReportData,107)
	q:(SDate'="")&&(LISRRCheckDate<SDate)
	q:(EDate'="")&&(LISRRCheckDate>EDate)
	s LISRREncounterTypeCode=$lg(LISReportData,4)
	q:(AdmType'="")&&(LISRREncounterTypeCode'=AdmType)
	s LISRRReportID=$lg(LISReportData,2)
	q:(Rpotcno'="")&&(Rpotcno'=LISRRReportID)
	s LISSRSpecimenID=$o(^Busi.ENS.EnsLISSpecimenReportI("LISSPECIMENREPORTPKey"," "_$zcvt(LISRRReportID,"U"),""))
	s:LISSRSpecimenID'="" appyno=$tr(LISSRSpecimenID," ","") //申请单号
	s examitemcode="",examitemname="",examcharge=""
	s LISSROrderItemID="" f  s LISSROrderItemID=$o(^Busi.ENS.EnsLISSpecimenReportI("LISSPECIMENREPORTPKey"," "_$zcvt(LISRRReportID,"U"),LISSRSpecimenID,LISSROrderItemID)) q:LISSROrderItemID=""  d
	.s EnsStatusLogDr=$o(^Busi.ENS.EnsStatusLogI("IndexESOrdItemID"," "_$zcvt(LISSROrderItemID,"U"),""),-1)
    .q:EnsStatusLogDr=""
    .s ESStatusCode=$lg($g(^Busi.ENS.EnsStatusLogD(EnsStatusLogDr)),11)
	.q:(ESStatusCode'="RP")&&(ESStatusCode'="RD")&&(ESStatusCode'="RPV")&&(ESStatusCode'="PRP")
	.s ordDeptDr="",ordDocDr=""
	.s:LISSROrderItemID'="" ordDeptDr=$p($g(^OEORD(+LISSROrderItemID,"I",$p(LISSROrderItemID,"||",2),1)),"^",3)
	.s:LISSROrderItemID'="" ordDocDr=$p($g(^OEORD(+LISSROrderItemID,"I",$p(LISSROrderItemID,"||",2),1)),"^",11)
	.s:LISSROrderItemID'="" examDeptDr=$p($g(^OEORD(+LISSROrderItemID,"I",$p(LISSROrderItemID,"||",2),3)),"^",6)
	.s appyorgcode=HospCode //申请机构代码
	.s:HospDr'="" appyorgname=$p($g(^CT("HOSP",HospDr)),"^",2) //申请机构名称
	.s:ordDocDr'="" bilgdrcodg=$p($g(^CTPCP(ordDocDr,1)),"^",1) //开单医生代码
	.s:ordDocDr'="" bilgdrname=$p($g(^CTPCP(ordDocDr,1)),"^",2) //开单医生姓名
	.s examorgcode=HospCode //检验机构代码
	.s:HospDr'="" examorgname=$p($g(^CT("HOSP",HospDr)),"^",2) //检验机构名称
	.s:ordDeptDr'="" appydeptcode=$p($g(^CTLOC(ordDeptDr)),"^",1) //申请科室代码
	.s:examDeptDr'="" examdeptcode=$p($g(^CTLOC(examDeptDr)),"^",1) //检查科室代码
	.s exammtd="" //检验方法
	.&SQL(select TOP 1 LISIR_TestMethod into :exammtd from SQLUser.Ens_LISItemResult where LISIR_ReportID=:LISRRReportID and LISIR_TestMethod is not null)
	.s rpotcno=LISRRReportID //报告单号
	.s ArcimID=$p($g(^OEORD(+LISSROrderItemID,"I",$p(LISSROrderItemID,"||",2),1)),"^",2) 
	.q:ArcimID=""
	.if examitemcode="" s examitemcode=$p($g(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1)),"^",1) //检验项目代码
	.else  s examitemcode=examitemcode_"+"_$p($g(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1)),"^",1)
	.if examitemname="" s examitemname=$p($g(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1)),"^",2) //检验项目名称
	.else  s examitemname=examitemname_"+"_$p($g(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1)),"^",2)
	.s inhospexamitemcode=examitemcode //院内检验-项目代码
	.s inhospexamitemname=examitemname //院内检验-项目名称
	.s LISRRCheckDate=$lg(LISReportData,107),LISRRCheckTime=$lg(LISReportData,108)
	.s:((LISRRCheckDate'="")&&(LISRRCheckTime'="")) rptdate=$zd(LISRRCheckDate,3)_" "_$zt(LISRRCheckTime) //报告日期
	.s rpotdoc=$lg(LISReportData,110) //报告医师
	.s examcharge=examcharge+(..GetPrice(LISSROrderItemID)) //检查费用
	.s valiflag="1"
	d OutOEItemInfo
	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
 	
OutOEItemInfo
	set Data=$lb(mdtrtsn,mdtrtid,psnno,appyno,appyorgcode,appyorgname,bilgdrcodg,bilgdrname,examorgcode,examorgname,appydeptcode,examdeptcode,exammtd,rpotcno,examitemcode,examitemname,inhospexamitemcode,inhospexamitemname,rptdate,rpotdoc,examcharge,valiflag)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SelectLabInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectLabInfoExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SelectLabInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectLabInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：ZhangXinying
/// CreatDate：2021—12-16
/// Description：检验明细信息
/// Table：Ens_LISReportResult、Ens_LISItemResult、Ens_LISItemSenResult、Ens_HOSDocument、Ens_RelOrderDocument
/// Input：SDate:开始日期, EDate:结束日期, HospId:院区代码, RegNo:登记号,AdmDr:就诊rowid, VisitNumber:条码号,AdmType:就诊类型,Rpotcno:报告ID,ExpDataAry:医保数组
/// Output:rpotc_no:报告单号,appy_no:申请单号,exam_mtd:检验方法,ref_val:参考值,exam_unt:检验-计量单位,exam_rslt_val:检验-结果(数值),exam_rslt_dicm:检验 - 结果(定性),exam_item_detl_code:检验 - 项目明细代码,exam_item_detl_name:检验 - 项目明细名称,exam_rslt_abn:检验结果异常标识
/// Debug:d ##class(%ResultSet).RunQuery("web.DHCENS.STBLL.Method.QueryReportInsu","SelectLabItemInfo","","","","","582","","","")
Query SelectLabItemInfo(SDate As %String = "", EDate As %String = "", HospId As %String = "", RegNo As %String = "", AdmDr As %String = "", VisitNumber As %String = "", AdmType As %String = "", Rpotcno As %String = "") As %Query(ROWSPEC = "rpotc_no:%String,appy_no:%String,exam_mtd:%String,ref_val:%String,exam_unt:%String,exam_rslt_val:%String,exam_rslt_dicm:%String,exam_item_detl_code:%String,exam_item_detl_name:%String,exam_rslt_abn:%String")
{
}

ClassMethod SelectLabItemInfoExecute(ByRef qHandle As %Binary, SDate As %String = "", EDate As %String = "", HospId As %String = "", RegNo As %String = "", AdmDr As %String = "", VisitNumber As %String = "", AdmType As %String = "", Rpotcno As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	s (rpotcno,appyno,exammtd,refval,examunt,examrsltval,examrsltdicm,examitemdetlcode,examitemdetlname,examrsltabn)=""
	
	If $g(ind)="" Set ind=1
 	if (SDate'="")&&(SDate["-") s SDate=$zdh(SDate,3)
 	if (EDate'="")&&(EDate["-") s EDate=$zdh(EDate,3)
 	if (SDate'="")&&(SDate["/") s SDate=$zdh(SDate,4)
 	if (EDate'="")&&(EDate["/") s EDate=$zdh(EDate,4)
 	if RegNo'="" d
 	.set PapmiDr=$o(^PAPERi("PAPMI_PatNo",RegNo,""))
 	.set PAAdmType="" for  s PAAdmType=$o(^PAPERdr(PapmiDr,"ADM",PAAdmType)) q:PAAdmType=""  d
 	..set Adm=""  for  s Adm=$o(^PAPERdr(PapmiDr,"ADM",PAAdmType,Adm)) q:Adm=""  d
 	...d GetTSItemInfoByAdm
 	s Adm=AdmDr
 	else  if (RegNo="")&&(Adm'="") d
 	.d GetTSItemInfoByAdm
 	else  if (Adm="")&&(Rpotcno'="") d
 	.d GetTSItemInfoByRpt
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
GetTSItemInfoByAdm
	s drptdr="" f  s drptdr=$o(^Busi.ENS.EnsLISReportResultI("LISRRVisitNumberIndex",Adm,drptdr)) q:(drptdr="")  d
	.s LISReportData=$g(^Busi.ENS.EnsLISReportResultD(drptdr))
	.s LISRRISMcroorganism=$lg(LISReportData,103)
	.q:LISRRISMcroorganism="1" //过滤微生物结果
	.s AdmLocDr=$p($g(^PAADM(Adm)),"^",4)
	.q:AdmLocDr=""
	.s HospDr=$p($g(^CTLOC(AdmLocDr)),"^",22)
	.s:HospDr'="" HospCode=$p($g(^CT("HOSP",HospDr)),"^",1)
	.q:(HospId'="")&&(HospId'=HospCode)
	.s LISRRPatientID=$lg(LISReportData,3)
	.s PapmiNo=$p($g(^PAPER(LISRRPatientID,"PAT",1)),"^",1)
	.q:(RegNo'="")&&(PapmiNo'=RegNo)
	.s LISRRVisitNumber=$lg(LISReportData,5)
	.q:(VisitNumber'="")&&(LISRRVisitNumber'=VisitNumber)
	.s LISRRCheckDate=$lg(LISReportData,107)
	.q:(SDate'="")&&(LISRRCheckDate<SDate)
	.q:(EDate'="")&&(LISRRCheckDate>EDate)
	.s LISRREncounterTypeCode=$lg(LISReportData,4)
	.q:(AdmType'="")&&(LISRREncounterTypeCode'=AdmType)
	.s LISRRReportID=$lg(LISReportData,2)
	.q:(Rpotcno'="")&&(Rpotcno'=LISRRReportID)
	.s rpotcno=LISRRReportID
	.s LISSRSpecimenID=$o(^Busi.ENS.EnsLISSpecimenReportI("LISSPECIMENREPORTPKey"," "_$zcvt(LISRRReportID,"U"),""))
	.s:LISSRSpecimenID'="" appyno=$tr(LISSRSpecimenID," ","") //申请单号
	.s LISSROrderItemID=$o(^Busi.ENS.EnsLISSpecimenReportI("LISSPECIMENREPORTPKey"," "_$zcvt(LISRRReportID,"U"),LISSRSpecimenID,""))
	.s EnsStatusLogDr=$o(^Busi.ENS.EnsStatusLogI("IndexESOrdItemID"," "_$zcvt(LISSROrderItemID,"U"),""),-1)
    .q:EnsStatusLogDr=""
    .s ESStatusCode=$lg($g(^Busi.ENS.EnsStatusLogD(EnsStatusLogDr)),11)
	.q:(ESStatusCode'="RP")&&(ESStatusCode'="RD")&&(ESStatusCode'="RPV")&&(ESStatusCode'="PRP")
	.s LISIRItemCode=""  for  s LISIRItemCode=$o(^Busi.ENS.EnsLISItemResultI("IndexReportItem",$zcvt(LISRRReportID,"U"),LISIRItemCode)) q:LISIRItemCode=""  d
	..s LISItemResultID=""  for  s LISItemResultID=$o(^Busi.ENS.EnsLISItemResultI("IndexReportItem",$zcvt(LISRRReportID,"U"),LISIRItemCode,LISItemResultID)) q:LISItemResultID=""  d
	...s LISItemResultData=$g(^Busi.ENS.EnsLISItemResultD(LISItemResultID))
	...s exammtd=$lg(LISItemResultData,15) //检验方法
	...s refval=$lg(LISItemResultData,14) //参考值
	...s examunt=$lg(LISItemResultData,9) //检验-计量单位
	...s examrsltval=$lg(LISItemResultData,8) //检验结果-数值
	...s:examrsltval'="" examrsltval=$fn(examrsltval,"",0)
	...s examrsltdicm=$lg(LISItemResultData,10) //检验结果-定性
	...s examitemdetlcode=$lg(LISItemResultData,6) //检验项目明细代码
	...s examitemdetlname=$lg(LISItemResultData,7) //检验项目明细名称
	...s examrsltabn=$lg(LISItemResultData,13) //检验结果异常标志
	...d OutOEItemInfo
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
 	
GetTSItemInfoByRpt
	s drptdr=$o(^Busi.ENS.EnsLISReportResultI("LISREPORTRESULTPKey",$zcvt(Rpotcno,"U"),""))
	q:drptdr=""
	s LISReportData=$g(^Busi.ENS.EnsLISReportResultD(drptdr))
	s LISRRISMcroorganism=$lg(LISReportData,103)
	q:LISRRISMcroorganism="1" //过滤微生物结果
	
	q:(HospId'="")&&(HospId'=HospCode)
	s LISRRPatientID=$lg(LISReportData,3)
	s PapmiNo=$p($g(^PAPER(LISRRPatientID,"PAT",1)),"^",1)
	q:(RegNo'="")&&(PapmiNo'=RegNo)
	s LISRRVisitNumber=$lg(LISReportData,5)
	q:(VisitNumber'="")&&(LISRRVisitNumber'=VisitNumber)
	s AdmLocDr=$p($g(^PAADM(LISRRVisitNumber)),"^",4)
	q:AdmLocDr=""
	s HospDr=$p($g(^CTLOC(AdmLocDr)),"^",22)
	s LISRRCheckDate=$lg(LISReportData,107)
	q:(SDate'="")&&(LISRRCheckDate<SDate)
	q:(EDate'="")&&(LISRRCheckDate>EDate)
	s LISRREncounterTypeCode=$lg(LISReportData,4)
	q:(AdmType'="")&&(LISRREncounterTypeCode'=AdmType)
	s LISRRReportID=$lg(LISReportData,2)
	q:(Rpotcno'="")&&(Rpotcno'=LISRRReportID)
	s rpotcno=LISRRReportID
	s LISSRSpecimenID=$o(^Busi.ENS.EnsLISSpecimenReportI("LISSPECIMENREPORTPKey"," "_$zcvt(Rpotcno,"U"),""))
	s:LISSRSpecimenID'="" appyno=$tr(LISSRSpecimenID," ","") //申请单号
	s LISSROrderItemID=$o(^Busi.ENS.EnsLISSpecimenReportI("LISSPECIMENREPORTPKey"," "_$zcvt(Rpotcno,"U"),LISSRSpecimenID,""))
	s EnsStatusLogDr=$o(^Busi.ENS.EnsStatusLogI("IndexESOrdItemID"," "_$zcvt(LISSROrderItemID,"U"),""),-1)
    q:EnsStatusLogDr=""
    s ESStatusCode=$lg($g(^Busi.ENS.EnsStatusLogD(EnsStatusLogDr)),11)
	q:(ESStatusCode'="RP")&&(ESStatusCode'="RD")&&(ESStatusCode'="RPV")&&(ESStatusCode'="PRP")
	s LISIRItemCode=""  for  s LISIRItemCode=$o(^Busi.ENS.EnsLISItemResultI("IndexReportItem",$zcvt(Rpotcno,"U"),LISIRItemCode)) q:LISIRItemCode=""  d
	.s LISItemResultID=""  for  s LISItemResultID=$o(^Busi.ENS.EnsLISItemResultI("IndexReportItem",$zcvt(Rpotcno,"U"),LISIRItemCode,LISItemResultID)) q:LISItemResultID=""  d
	..s LISItemResultData=$g(^Busi.ENS.EnsLISItemResultD(LISItemResultID))
	..s exammtd=$lg(LISItemResultData,15) //检验方法
	..s refval=$lg(LISItemResultData,14) //参考值
	..s examunt=$lg(LISItemResultData,9) //检验-计量单位
	..s examrsltval=$lg(LISItemResultData,8) //检验结果-数值
	..s examrsltdicm=$lg(LISItemResultData,10) //检验结果-定性
	..s examitemdetlcode=$lg(LISItemResultData,6) //检验项目明细代码
	..s examitemdetlname=$lg(LISItemResultData,7) //检验项目明细名称
	..s examrsltabn=$lg(LISItemResultData,13) //检验结果异常标志
	..d OutOEItemInfo
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
 	
OutOEItemInfo
	set Data=$lb(rpotcno,appyno,exammtd,refval,examunt,examrsltval,examrsltdicm,examitemdetlcode,examitemdetlname,examrsltabn)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SelectLabItemInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectLabItemInfoExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SelectLabItemInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectLabItemInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：ZhangXinying
/// CreatDate：2021—12-16
/// Description：检验标本信息
/// Table：Ens_LISReportResult、Ens_LISItemResult、Ens_LISItemSenResult、Ens_HOSDocument、Ens_RelOrderDocument
/// Input：AdmDr
/// Output:rpotc_no:报告单号,appy_no:申请单号,sapl_date:采样日期,spcm_no:标本号,spcm_name:标本名称
/// Debug:d ##class(%ResultSet).RunQuery("web.DHCENS.STBLL.Method.QueryReportInsu","SelectLabSampleInfo","","","","","47","","","")
Query SelectLabSampleInfo(SDate As %String = "", EDate As %String = "", HospId As %String = "", RegNo As %String = "", AdmDr As %String = "", VisitNumber As %String = "", AdmType As %String = "", Rpotcno As %String = "") As %Query(ROWSPEC = "rpotc_no:%String,appy_no:%String,sapl_date:%String,spcm_no:%String,spcm_name:%String")
{
}

ClassMethod SelectLabSampleInfoExecute(ByRef qHandle As %Binary, SDate As %String = "", EDate As %String = "", HospId As %String = "", RegNo As %String = "", AdmDr As %String = "", VisitNumber As %String = "", AdmType As %String = "", Rpotcno As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	s (rpotcno,appyno,sapldate,spcmno,spcmname)=""
	If $g(ind)="" Set ind=1
	
 	if (SDate'="")&&(SDate["-") s SDate=$zdh(SDate,3)
 	if (EDate'="")&&(EDate["-") s EDate=$zdh(EDate,3)
 	if (SDate'="")&&(SDate["/") s SDate=$zdh(SDate,4)
 	if (EDate'="")&&(EDate["/") s EDate=$zdh(EDate,4)
 	if RegNo'="" d
 	.set PapmiDr=$o(^PAPERi("PAPMI_PatNo",RegNo,""))
 	.set PAAdmType="" for  s PAAdmType=$o(^PAPERdr(PapmiDr,"ADM",PAAdmType)) q:PAAdmType=""  d
 	..set Adm=""  for  s Adm=$o(^PAPERdr(PapmiDr,"ADM",PAAdmType,Adm)) q:Adm=""  d
 	...d GetTSSampleInfoByAdm
 	s Adm=AdmDr
 	else  if (RegNo="")&&(Adm'="") d
 	.d GetTSSampleInfoByAdm
 	else  if (Adm="")&&(Rpotcno'="") d
 	.d GetTSSampleInfoByRpt
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
GetTSSampleInfoByAdm
	s drptdr="" f  s drptdr=$o(^Busi.ENS.EnsLISReportResultI("LISRRVisitNumberIndex",Adm,drptdr)) q:(drptdr="")  d
	.s LISReportData=$g(^Busi.ENS.EnsLISReportResultD(drptdr))
	.s AdmLocDr=$p($g(^PAADM(Adm)),"^",4)
	.q:AdmLocDr=""
	.s HospDr=$p($g(^CTLOC(AdmLocDr)),"^",22)
	.s:HospDr'="" HospCode=$p($g(^CT("HOSP",HospDr)),"^",1)
	.q:(HospId'="")&&(HospId'=HospCode)
	.s LISRRPatientID=$lg(LISReportData,3)
	.s PapmiNo=$p($g(^PAPER(LISRRPatientID,"PAT",1)),"^",1)
	.q:(RegNo'="")&&(PapmiNo'=RegNo)
	.s LISRRVisitNumber=$lg(LISReportData,5)
	.q:(VisitNumber'="")&&(LISRRVisitNumber'=VisitNumber)
	.s LISRRCheckDate=$lg(LISReportData,107)
	.q:(SDate'="")&&(LISRRCheckDate<SDate)
	.q:(EDate'="")&&(LISRRCheckDate>EDate)
	.s LISRREncounterTypeCode=$lg(LISReportData,4)
	.q:(AdmType'="")&&(LISRREncounterTypeCode'=AdmType)
	.s LISRRReportID=$lg(LISReportData,2)
	.q:(Rpotcno'="")&&(Rpotcno'=LISRRReportID)
	.s rpotcno=LISRRReportID
	.s LISSRSpecimenID=$o(^Busi.ENS.EnsLISSpecimenReportI("LISSPECIMENREPORTPKey"," "_$zcvt(LISRRReportID,"U"),""))
	.s:LISSRSpecimenID'="" appyno=$tr(LISSRSpecimenID," ","") //申请单号
	.s LISSROrderItemID=$o(^Busi.ENS.EnsLISSpecimenReportI("LISSPECIMENREPORTPKey"," "_$zcvt(LISRRReportID,"U"),LISSRSpecimenID,""))
	.s EnsStatusLogDr=$o(^Busi.ENS.EnsStatusLogI("IndexESOrdItemID"," "_$zcvt(LISSROrderItemID,"U"),""),-1)
    .q:EnsStatusLogDr=""
    .s ESStatusCode=$lg($g(^Busi.ENS.EnsStatusLogD(EnsStatusLogDr)),11)
	.q:(ESStatusCode'="RP")&&(ESStatusCode'="RD")&&(ESStatusCode'="RPV")&&(ESStatusCode'="RPP")
	.s LISRRReceiveDate=$lg(LISReportData,65),LISRRReceiveTime=$lg(LISReportData,66)
	.s:(LISRRReceiveDate'="")&&(LISRRReceiveTime'="") sapldate=$zd(LISRRReceiveDate,3)_" "_$zt(LISRRReceiveTime)
	.s LISRRAcceptDate=$lg(LISReportData,125),LISRRAcceptTime=$lg(LISReportData,126)
	.s:(LISRRAcceptDate'="")&&(LISRRAcceptTime'="") sapldate=$zd(LISRRAcceptDate,3)_" "_$zt(LISRRAcceptTime)
	.s:LISSRSpecimenID'="" spcmno=$tr(LISSRSpecimenID," ","")
	.s spcmname=$lg(LISReportData,147)
	.d OutOEItemInfo
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
 
GetTSSampleInfoByRpt
	s drptdr=$o(^Busi.ENS.EnsLISReportResultI("LISREPORTRESULTPKey",$zcvt(Rpotcno,"U"),""))
	q:drptdr=""
	s LISReportData=$g(^Busi.ENS.EnsLISReportResultD(drptdr))
	s LISRRPatientID=$lg(LISReportData,3)
	s PapmiNo=$p($g(^PAPER(LISRRPatientID,"PAT",1)),"^",1)
	q:(RegNo'="")&&(PapmiNo'=RegNo)
	s LISRRVisitNumber=$lg(LISReportData,5)
	q:(VisitNumber'="")&&(LISRRVisitNumber'=VisitNumber)
	s AdmLocDr=$p($g(^PAADM(LISRRVisitNumber)),"^",4)
	q:AdmLocDr=""
	s HospDr=$p($g(^CTLOC(AdmLocDr)),"^",22)
	s:HospDr'="" HospCode=$p($g(^CT("HOSP",HospDr)),"^",1)
	q:(HospId'="")&&(HospId'=HospCode)
	s LISRRCheckDate=$lg(LISReportData,107)
	q:(SDate'="")&&(LISRRCheckDate<SDate)
	q:(EDate'="")&&(LISRRCheckDate>EDate)
	s LISRREncounterTypeCode=$lg(LISReportData,4)
	q:(AdmType'="")&&(LISRREncounterTypeCode'=AdmType)
	s LISSRSpecimenID=$o(^Busi.ENS.EnsLISSpecimenReportI("LISSPECIMENREPORTPKey"," "_$zcvt(Rpotcno,"U"),""))
	s:LISSRSpecimenID'="" appyno=$tr(LISSRSpecimenID," ","") //申请单号
	s LISSROrderItemID=$o(^Busi.ENS.EnsLISSpecimenReportI("LISSPECIMENREPORTPKey"," "_$zcvt(Rpotcno,"U"),LISSRSpecimenID,""))
	s EnsStatusLogDr=$o(^Busi.ENS.EnsStatusLogI("IndexESOrdItemID"," "_$zcvt(LISSROrderItemID,"U"),""),-1)
    q:EnsStatusLogDr=""
    s ESStatusCode=$lg($g(^Busi.ENS.EnsStatusLogD(EnsStatusLogDr)),11)
	q:(ESStatusCode'="RP")&&(ESStatusCode'="RD")&&(ESStatusCode'="RPV")&&(ESStatusCode'="RPP")
	s LISRRReceiveDate=$lg(LISReportData,65),LISRRReceiveTime=$lg(LISReportData,66)
	s:(LISRRReceiveDate'="")&&(LISRRReceiveTime'="") sapldate=$zd(LISRRReceiveDate,3)_" "_$zt(LISRRReceiveTime)
	s LISRRAcceptDate=$lg(LISReportData,125),LISRRAcceptTime=$lg(LISReportData,126)
	s:(LISRRAcceptDate'="")&&(LISRRAcceptTime'="") sapldate=$zd(LISRRAcceptDate,3)_" "_$zt(LISRRAcceptTime)
	s:LISSRSpecimenID'="" spcmno=$tr(LISSRSpecimenID," ","")
	s spcmname=$lg(LISReportData,147)
	d OutOEItemInfo
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
 	
OutOEItemInfo
	set Data=$lb(rpotcno,appyno,sapldate,spcmno,spcmname)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SelectLabSampleInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectLabSampleInfoExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SelectLabSampleInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectLabSampleInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：ZhangXinying
/// CreatDate：2021—12-16
/// Description：细菌培养信息
/// Table：Ens_LISReportResult、Ens_LISItemResult、Ens_LISItemSenResult、Ens_HOSDocument、Ens_RelOrderDocument
/// Input：SDate:开始日期, EDate:结束日期, HospId:院区代码, RegNo:登记号,AdmDr:就诊rowid, VisitNumber:条码号,AdmType:就诊类型,Rpotcno:报告ID,ExpDataAry:医保数组
/// Output:mdtrt_sn:就医流水号,mdtrt_id:就诊ID,psn_no:人员编号,appy_no:申请单号,rpotc_no:报告单号,germ_code:细菌代号,germ_name:细菌名称,coly_cntg:菌落计数,clte_medm:培养基,clte_time:培养时间,clte_cond:培养条件,exam_rslt:检验结果,fnd_way:发现方式,exam_org_name:检验机构名称,vali_flag:有效标志
/// Debug:d ##class(%ResultSet).RunQuery("web.DHCENS.STBLL.Method.QueryReportInsu","SelectLabMicroResult","","","","","47","","","","")
Query SelectLabMicroResult(SDate As %String = "", EDate As %String = "", HospId As %String = "", RegNo As %String = "", AdmDr As %String = "", VisitNumber As %String = "", AdmType As %String = "", Rpotcno As %String = "", ExpDataAry As %ArrayOfDataTypes = "") As %Query(ROWSPEC = "mdtrt_sn:%String,mdtrt_id:%String,psn_no:%String,appy_no:%String,rpotc_no:%String,germ_code:%String,germ_name:%String,coly_cntg:%String,clte_medm:%String,clte_time:%String,clte_cond:%String,exam_rslt:%String,fnd_way:%String,exam_org_name:%String,vali_flag:%String")
{
}

ClassMethod SelectLabMicroResultExecute(ByRef qHandle As %Binary, SDate As %String = "", EDate As %String = "", HospId As %String = "", RegNo As %String = "", AdmDr As %String = "", VisitNumber As %String = "", AdmType As %String = "", Rpotcno As %String = "", ExpDataAry As %ArrayOfDataTypes = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	s (mdtrtsn,mdtrtid,psnno,appyno,rpotcno,germcode,germname,colycntg,cltemedm,cltetime,cltecond,examrslt,fndway,examorgname,valiflag)=""
	if ($IsObject(ExpDataAry)) {
        //--按照医保接口文档字段命名
        s mdtrtsn = ExpDataAry.GetAt("mdtrt_sn")
        s mdtrtid=ExpDataAry.GetAt("mdtrt_id") //mdtrt_id 就诊ID(非HIS就诊ID) 
        s psnno = ExpDataAry.GetAt("psn_no") //psn_no 人员编号
    }else{
        Set mdtrtsn=AdmDr
        Set mdtrtid=AdmDr
        Set MethodExist=##class(websys.Conversions).IsValidMethodName("web.DHCINSUPort","GetInsuAdmInfoByAdm")
        If (MethodExist) {
            Set InsuAdmInfo=##Class(web.DHCINSUPort).GetInsuAdmInfoByAdm(AdmDr)   //医保接口 如果没有返回，请项目组问医保组要接口
            Set psnno=$PIECE(InsuAdmInfo,"^",1)
        }Else{
            Set psnno="无"
        }
    }
	If $g(ind)="" Set ind=1
	
 	if (SDate'="")&&(SDate["-") s SDate=$zdh(SDate,3)
 	if (EDate'="")&&(EDate["-") s EDate=$zdh(EDate,3)
 	if (SDate'="")&&(SDate["/") s SDate=$zdh(SDate,4)
 	if (EDate'="")&&(EDate["/") s EDate=$zdh(EDate,4)
 	if RegNo'="" d
 	.set PapmiDr=$o(^PAPERi("PAPMI_PatNo",RegNo,""))
 	.set PAAdmType="" for  s PAAdmType=$o(^PAPERdr(PapmiDr,"ADM",PAAdmType)) q:PAAdmType=""  d
 	..set Adm=""  for  s Adm=$o(^PAPERdr(PapmiDr,"ADM",PAAdmType,Adm)) q:Adm=""  d
 	...d GetTSMircoInfoByAdm
 	s Adm=AdmDr
 	else  if (RegNo="")&&(Adm'="")&&(Rpotcno="") d
 	.d GetTSMircoInfoByAdm
 	else  if (Rpotcno'="") d
 	.d GetTSMicroInfoByRpt
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
GetTSMircoInfoByAdm
	s drptdr="" f  s drptdr=$o(^Busi.ENS.EnsLISReportResultI("LISRRVisitNumberIndex",Adm,drptdr)) q:(drptdr="")  d
	.s LISReportData=$g(^Busi.ENS.EnsLISReportResultD(drptdr))
	.s LISRRISMcroorganism=$lg(LISReportData,103)
	.q:LISRRISMcroorganism'="1" //过滤普通检验结果
	.s AdmLocDr=$p($g(^PAADM(Adm)),"^",4)
	.q:AdmLocDr=""
	.s HospDr=$p($g(^CTLOC(AdmLocDr)),"^",22)
	.s:HospDr'="" HospCode=$p($g(^CT("HOSP",HospDr)),"^",1)
	.q:(HospId'="")&&(HospId'=HospCode)
	.s LISRRPatientID=$lg(LISReportData,3)
	.s PapmiNo=$p($g(^PAPER(LISRRPatientID,"PAT",1)),"^",1)
	.q:(RegNo'="")&&(PapmiNo'=RegNo)
	.s LISRRVisitNumber=$lg(LISReportData,5)
	.q:(VisitNumber'="")&&(LISRRVisitNumber'=VisitNumber)
	.s LISRRCheckDate=$lg(LISReportData,107)
	.q:(SDate'="")&&(LISRRCheckDate<SDate)
	.q:(EDate'="")&&(LISRRCheckDate>EDate)
	.s LISRREncounterTypeCode=$lg(LISReportData,4)
	.q:(AdmType'="")&&(LISRREncounterTypeCode'=AdmType)
	.s LISRRReportID=$lg(LISReportData,2)
	.;q:(Rpotcno'="")&&(Rpotcno'=LISRRReportID)
	.;s rpotcno=LISRRReportID
	.s LISSRSpecimenID=$o(^Busi.ENS.EnsLISSpecimenReportI("LISSPECIMENREPORTPKey"," "_$zcvt(LISRRReportID,"U"),""))
	.s:LISSRSpecimenID'="" appyno=$tr(LISSRSpecimenID," ","") //申请单号
	.s LISSROrderItemID=$o(^Busi.ENS.EnsLISSpecimenReportI("LISSPECIMENREPORTPKey"," "_$zcvt(LISRRReportID,"U"),LISSRSpecimenID,""))
	.s EnsStatusLogDr=$o(^Busi.ENS.EnsStatusLogI("IndexESOrdItemID"," "_$zcvt(LISSROrderItemID,"U"),""),-1)
    .q:EnsStatusLogDr=""
    .s ESStatusCode=$lg($g(^Busi.ENS.EnsStatusLogD(EnsStatusLogDr)),11)
	.q:(ESStatusCode'="RP")&&(ESStatusCode'="RD")&&(ESStatusCode'="RPV")&&(ESStatusCode'="RPP")
	.s LISIRItemCode=""  for  s LISIRItemCode=$o(^Busi.ENS.EnsLISItemResultI("IndexReportItem",$zcvt(LISRRReportID,"U"),LISIRItemCode)) q:LISIRItemCode=""  d
	..s LISItemResultID=""  for  s LISItemResultID=$o(^Busi.ENS.EnsLISItemResultI("IndexReportItem",$zcvt(LISRRReportID,"U"),LISIRItemCode,LISItemResultID)) q:LISItemResultID=""  d
	...s LISItemResultData=$g(^Busi.ENS.EnsLISItemResultD(LISItemResultID))
	...s rpotcno=LISRRReportID_"^"_LISItemResultID //细菌结果唯一标识
	...s germcode=$lg(LISItemResultData,6) //细菌代号
	...s germname=$lg(LISItemResultData,7) //细菌名称
	...s colycntg=$lg(LISItemResultData,22)  //菌落计数
	...s cltemedm=$lg(LISItemResultData,32)  //培养基
	...s cltetime="" //培养时间
	...s cltecond="" //培养条件
	...s examrslt=$lg(LISItemResultData,8) //检验结果
	...s fndway="" //发现方式
	...s:HospDr'="" examorgname=$p($g(^CT("HOSP",HospDr)),"^",2) //检验机构名称
	...s valiflag="1" //有效标志
	...d OutOEItemInfo
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
GetTSMicroInfoByRpt
	s RptID=$p(Rpotcno,"^",1),ItemResultID=$p(Rpotcno,"^",2) //国家医保接口按就诊查询到Rpotcno【格式为报告ID^细菌记录表rowid】，然后根据Rpotcno查询特定细菌培养记录
	s rpotcno=Rpotcno
	s drptdr=$o(^Busi.ENS.EnsLISReportResultI("LISREPORTRESULTPKey",$zcvt(RptID,"U"),""))
	q:drptdr=""
	s LISReportData=$g(^Busi.ENS.EnsLISReportResultD(drptdr))
	s LISRRISMcroorganism=$lg(LISReportData,103)
	q:LISRRISMcroorganism'="1" //过滤普通检验结果
	s Adm=$lg(LISReportData,5)
	q:Adm=""
	s AdmLocDr=$p($g(^PAADM(Adm)),"^",4)
	q:AdmLocDr=""
	s HospDr=$p($g(^CTLOC(AdmLocDr)),"^",22)
	s:HospDr'="" HospCode=$p($g(^CT("HOSP",HospDr)),"^",1)
	q:(HospId'="")&&(HospId'=HospCode)
	s LISRRPatientID=$lg(LISReportData,3)
	s PapmiNo=$p($g(^PAPER(LISRRPatientID,"PAT",1)),"^",1)
	q:(RegNo'="")&&(PapmiNo'=RegNo)
	s LISRRVisitNumber=$lg(LISReportData,5)
	q:(VisitNumber'="")&&(LISRRVisitNumber'=VisitNumber)
	s LISRRCheckDate=$lg(LISReportData,107)
	q:(SDate'="")&&(LISRRCheckDate<SDate)
	q:(EDate'="")&&(LISRRCheckDate>EDate)
	s LISRREncounterTypeCode=$lg(LISReportData,4)
	q:(AdmType'="")&&(LISRREncounterTypeCode'=AdmType)
	s LISRRReportID=$lg(LISReportData,2)
	;q:(Rpotcno'="")&&(Rpotcno'=LISRRReportID)
	q:(RptID'="")&&(RptID'=LISRRReportID)
	;s rpotcno=LISRRReportID
	s LISSRSpecimenID=$o(^Busi.ENS.EnsLISSpecimenReportI("LISSPECIMENREPORTPKey"," "_$zcvt(LISRRReportID,"U"),""))
	s:LISSRSpecimenID'="" appyno=$tr(LISSRSpecimenID," ","") //申请单号
	s LISSROrderItemID=$o(^Busi.ENS.EnsLISSpecimenReportI("LISSPECIMENREPORTPKey"," "_$zcvt(LISRRReportID,"U"),LISSRSpecimenID,""))
	s EnsStatusLogDr=$o(^Busi.ENS.EnsStatusLogI("IndexESOrdItemID"," "_$zcvt(LISSROrderItemID,"U"),""),-1)
    q:EnsStatusLogDr=""
    s ESStatusCode=$lg($g(^Busi.ENS.EnsStatusLogD(EnsStatusLogDr)),11)
	q:(ESStatusCode'="RP")&&(ESStatusCode'="RD")&&(ESStatusCode'="RPV")&&(ESStatusCode'="RPP")
	s LISIRItemCode=""  for  s LISIRItemCode=$o(^Busi.ENS.EnsLISItemResultI("IndexReportItem",$zcvt(LISRRReportID,"U"),LISIRItemCode)) q:LISIRItemCode=""  d
	.s LISItemResultID=""  for  s LISItemResultID=$o(^Busi.ENS.EnsLISItemResultI("IndexReportItem",$zcvt(LISRRReportID,"U"),LISIRItemCode,LISItemResultID)) q:LISItemResultID=""  d
	..q:(ItemResultID'="")&&(LISItemResultID'=ItemResultID)
	..s LISItemResultData=$g(^Busi.ENS.EnsLISItemResultD(LISItemResultID))
	..s germcode=$lg(LISItemResultData,6) //细菌代号
	..s germname=$lg(LISItemResultData,7) //细菌名称
	..s colycntg=$lg(LISItemResultData,22)  //菌落计数
	..s cltemedm=$lg(LISItemResultData,32)  //培养基
	..s cltetime="" //培养时间
	..s cltecond="" //培养条件
	..s examrslt=$lg(LISItemResultData,8) //检验结果
	..s fndway="" //发现方式
	..s:HospDr'="" examorgname=$p($g(^CT("HOSP",HospDr)),"^",2) //检验机构名称
	..s valiflag="1" //有效标志
	..d OutOEItemInfo
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutOEItemInfo
	set Data=$lb(mdtrtsn,mdtrtid,psnno,appyno,rpotcno,germcode,germname,colycntg,cltemedm,cltetime,cltecond,examrslt,fndway,examorgname,valiflag)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SelectLabMicroResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectLabMicroResultExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SelectLabMicroResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectLabMicroResultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：ZhangXinying
/// CreatDate：2021—12-16
/// Description：药敏结果信息
/// Table：Ens_LISReportResult、Ens_LISItemResult、Ens_LISItemSenResult、Ens_HOSDocument、Ens_RelOrderDocument
/// Input：SDate:开始日期, EDate:结束日期, HospId:院区代码, RegNo:登记号,AdmDr:就诊rowid, VisitNumber:条码号,AdmType:就诊类型,Rpotcno:报告ID,ExpDataAry:医保数组
/// Output:mdtrt_sn:就医流水号,mdtrt_id:就诊ID,psn_no:人员编号,appy_no:申请单号,rpotc_no:报告单号,germ_code:细菌代号,germ_name:细菌名称,sstb_code:药敏代码,sstb_name:药敏名称,reta_rslt_code:抗药结果代码,reta_rslt_name:抗药结果,ref_val:参考值,exam_mtd:检验方法,exam_rslt:检验结果,exam_org_name:检验机构名称,vali_flag:有效标志
/// Debug:d ##class(%ResultSet).RunQuery("web.DHCENS.STBLL.Method.QueryReportInsu","SelectLabItemSenResult","","","","","47","","","","")
Query SelectLabItemSenResult(SDate As %String = "", EDate As %String = "", HospId As %String = "", RegNo As %String = "", AdmDr As %String = "", VisitNumber As %String = "", AdmType As %String = "", Rpotcno As %String = "", ExpDataAry As %ArrayOfDataTypes = "") As %Query(ROWSPEC = "mdtrt_sn:%String,mdtrt_id:%String,psn_no:%String,appy_no:%String,rpotc_no:%String,germ_code:%String,germ_name:%String,sstb_code:%String,sstb_name:%String,reta_rslt_code:%String,reta_rslt_name:%String,ref_val:%String,exam_mtd:%String,exam_rslt:%String,exam_org_name:%String,vali_flag:%String")
{
}

ClassMethod SelectLabItemSenResultExecute(ByRef qHandle As %Binary, SDate As %String = "", EDate As %String = "", HospId As %String = "", RegNo As %String = "", AdmDr As %String = "", VisitNumber As %String = "", AdmType As %String = "", Rpotcno As %String = "", ExpDataAry As %ArrayOfDataTypes = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	s (mdtrtsn,mdtrtid,psnno,appyno,rpotcno,germcode,germname,sstbcode,sstbname,retarsltcode,retarsltname,refval,exammtd,examrslt,examorgname,valiflag)=""
	if ($IsObject(ExpDataAry)) {
        //--按照医保接口文档字段命名
        s mdtrtsn = ExpDataAry.GetAt("mdtrt_sn")
        s mdtrtid=ExpDataAry.GetAt("mdtrt_id") //mdtrt_id 就诊ID(非HIS就诊ID) 
        s psnno = ExpDataAry.GetAt("psn_no") //psn_no 人员编号
    }else{
        Set mdtrtsn=AdmDr
        Set mdtrtid=AdmDr
        Set MethodExist=##class(websys.Conversions).IsValidMethodName("web.DHCINSUPort","GetInsuAdmInfoByAdm")
        If (MethodExist) {
            Set InsuAdmInfo=##Class(web.DHCINSUPort).GetInsuAdmInfoByAdm(AdmDr)   //医保接口 如果没有返回，请项目组问医保组要接口
            Set psnno=$PIECE(InsuAdmInfo,"^",1)
        }Else{
            Set psnno="无"
        }
    }
	If $g(ind)="" Set ind=1
	
 	if (SDate'="")&&(SDate["-") s SDate=$zdh(SDate,3)
 	if (EDate'="")&&(EDate["-") s EDate=$zdh(EDate,3)
 	if (SDate'="")&&(SDate["/") s SDate=$zdh(SDate,4)
 	if (EDate'="")&&(EDate["/") s EDate=$zdh(EDate,4)
 	if RegNo'="" d
 	.set PapmiDr=$o(^PAPERi("PAPMI_PatNo",RegNo,""))
 	.set PAAdmType="" for  s PAAdmType=$o(^PAPERdr(PapmiDr,"ADM",PAAdmType)) q:PAAdmType=""  d
 	..set Adm=""  for  s Adm=$o(^PAPERdr(PapmiDr,"ADM",PAAdmType,Adm)) q:Adm=""  d
 	...d GetTSMircoSenResultByAdm
 	s Adm=AdmDr
 	else  if (RegNo="")&&(Adm'="")&&(Rpotcno="") d
 	.d GetTSMircoSenResultByAdm
 	else  if (Rpotcno'="") d
 	.d GetTSMicroSenResultByRpt
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
GetTSMircoSenResultByAdm
	s drptdr="" f  s drptdr=$o(^Busi.ENS.EnsLISReportResultI("LISRRVisitNumberIndex",Adm,drptdr)) q:(drptdr="")  d
	.s LISReportData=$g(^Busi.ENS.EnsLISReportResultD(drptdr))
	.s LISRRISMcroorganism=$lg(LISReportData,103)
	.q:LISRRISMcroorganism'="1" //过滤普通检验结果
	.s AdmLocDr=$p($g(^PAADM(Adm)),"^",4)
	.s HospDr=$p($g(^CTLOC(AdmLocDr)),"^",22)
	.s:HospDr'="" HospCode=$p($g(^CT("HOSP",HospDr)),"^",1)
	.q:(HospId'="")&&(HospId'=HospCode)
	.s LISRRPatientID=$lg(LISReportData,3)
	.s PapmiNo=$p($g(^PAPER(LISRRPatientID,"PAT",1)),"^",1)
	.q:(RegNo'="")&&(PapmiNo'=RegNo)
	.s LISRRVisitNumber=$lg(LISReportData,5)
	.q:(VisitNumber'="")&&(LISRRVisitNumber'=VisitNumber)
	.s LISRRCheckDate=$lg(LISReportData,107)
	.q:(SDate'="")&&(LISRRCheckDate<SDate)
	.q:(EDate'="")&&(LISRRCheckDate>EDate)
	.s LISRREncounterTypeCode=$lg(LISReportData,4)
	.q:(AdmType'="")&&(LISRREncounterTypeCode'=AdmType)
	.s LISRRReportID=$lg(LISReportData,2)
	.;q:(Rpotcno'="")&&(Rpotcno'=LISRRReportID)
	.;q:(RptID'="")&&(RptID'=LISRRReportID)
	.;s rpotcno=LISRRReportID
	.s LISSRSpecimenID=$o(^Busi.ENS.EnsLISSpecimenReportI("LISSPECIMENREPORTPKey"," "_$zcvt(LISRRReportID,"U"),""))
	.s:LISSRSpecimenID'="" appyno=$tr(LISSRSpecimenID," ","") //申请单号
	.s LISSROrderItemID=$o(^Busi.ENS.EnsLISSpecimenReportI("LISSPECIMENREPORTPKey"," "_$zcvt(LISRRReportID,"U"),LISSRSpecimenID,""))
	.s EnsStatusLogDr=$o(^Busi.ENS.EnsStatusLogI("IndexESOrdItemID"," "_$zcvt(LISSROrderItemID,"U"),""),-1)
    .q:EnsStatusLogDr=""
    .s ESStatusCode=$lg($g(^Busi.ENS.EnsStatusLogD(EnsStatusLogDr)),11)
	.q:(ESStatusCode'="RP")&&(ESStatusCode'="RD")&&(ESStatusCode'="RPV")&&(ESStatusCode'="RPP")
	.s LISIRItemCode=""  for  s LISIRItemCode=$o(^Busi.ENS.EnsLISItemResultI("IndexReportItem",$zcvt(LISRRReportID,"U"),LISIRItemCode)) q:LISIRItemCode=""  d
	..s LISItemResultID=""  for  s LISItemResultID=$o(^Busi.ENS.EnsLISItemResultI("IndexReportItem",$zcvt(LISRRReportID,"U"),LISIRItemCode,LISItemResultID)) q:LISItemResultID=""  d
	...s LISItemResultData=$g(^Busi.ENS.EnsLISItemResultD(LISItemResultID))
	...s LISISRResultID=$lg(LISItemResultData,2) //结果ID
	...s germcode=$lg(LISItemResultData,6) //细菌代号
	...s germname=$lg(LISItemResultData,7) //细菌名称
	...s LISISRAntibioticsCode=""  for  s LISISRAntibioticsCode=$o(^Busi.ENS.EnsLISItemSenResultI("PKHIPUSERLISITEMSENRESULT",LISISRResultID,LISISRAntibioticsCode)) q:LISISRAntibioticsCode=""  d
	....s LISItemSenResultID=""  for  s LISItemSenResultID=$o(^Busi.ENS.EnsLISItemSenResultI("PKHIPUSERLISITEMSENRESULT",LISISRResultID,LISISRAntibioticsCode,LISItemSenResultID)) q:LISItemSenResultID=""  d
	.....s rpotcno=LISRRReportID_"^"_LISItemSenResultID  //药敏结果唯一标识
	.....s LISItemSenResultData=$g(^Busi.ENS.EnsLISItemSenResultD(LISItemSenResultID))
	.....s sstbcode=$lg(LISItemSenResultData,6)  //药敏代码
	.....s sstbname=$lg(LISItemSenResultData,7)  //药敏名称
	.....s retarsltcode=$lg(LISItemSenResultData,14) //抗药结果代码
	.....s retarsltname=$lg(LISItemSenResultData,5) //抗药结果
	.....s:sstbcode="I" refval=$lg(LISItemSenResultData,8) //I折点范围
	.....s:sstbcode="S" refval=$lg(LISItemSenResultData,9) //S折点范围
	.....s:sstbcode="R" refval=$lg(LISItemSenResultData,10) //R折点范围
	.....s exammtd=$lg(LISItemSenResultData,12) //检验方法
	.....s examrslt=$lg(LISItemSenResultData,5) //检验结果
	.....s:HospDr'="" examorgname=$p($g(^CT("HOSP",HospDr)),"^",2) //检验机构名称
	.....s valiflag="1" //有效标志
	.....d OutOEItemInfo
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
 	
GetTSMicroSenResultByRpt
	s RptID=$p(Rpotcno,"^",1),ItemSenResultID=$p(Rpotcno,"^",2) //国家医保接口按就诊查询到Rpotcno【报告ID^药敏结果rowid】，然后根据Rpotcno查询特定细菌药敏结果
	s rpotcno=Rpotcno
	s drptdr=$o(^Busi.ENS.EnsLISReportResultI("LISREPORTRESULTPKey",$zcvt(RptID,"U"),""))
	q:drptdr=""
	s LISReportData=$g(^Busi.ENS.EnsLISReportResultD(drptdr))
	s LISRRISMcroorganism=$lg(LISReportData,103)
	q:LISRRISMcroorganism'="1" //过滤普通检验结果
	s Adm=$lg(LISReportData,5)
	q:Adm=""
	s AdmLocDr=$p($g(^PAADM(Adm)),"^",4)
	q:AdmLocDr=""
	s HospDr=$p($g(^CTLOC(AdmLocDr)),"^",22)
	s LISSRSpecimenID=$o(^Busi.ENS.EnsLISSpecimenReportI("LISSPECIMENREPORTPKey"," "_$zcvt(RptID,"U"),""))
	s:LISSRSpecimenID'="" appyno=$tr(LISSRSpecimenID," ","") //申请单号
 	s LISIRItemCode=""  for  s LISIRItemCode=$o(^Busi.ENS.EnsLISItemResultI("IndexReportItem",$zcvt(RptID,"U"),LISIRItemCode)) q:LISIRItemCode=""  d
	.s LISItemResultID=""  for  s LISItemResultID=$o(^Busi.ENS.EnsLISItemResultI("IndexReportItem",$zcvt(RptID,"U"),LISIRItemCode,LISItemResultID)) q:LISItemResultID=""  d
	..s LISItemResultData=$g(^Busi.ENS.EnsLISItemResultD(LISItemResultID))
	..s LISISRResultID=$lg(LISItemResultData,2) //结果ID
	..s germcode=$lg(LISItemResultData,6) //细菌代号
	..s germname=$lg(LISItemResultData,7) //细菌名称
	..s LISISRAntibioticsCode=""  for  s LISISRAntibioticsCode=$o(^Busi.ENS.EnsLISItemSenResultI("PKHIPUSERLISITEMSENRESULT",LISISRResultID,LISISRAntibioticsCode)) q:LISISRAntibioticsCode=""  d
	...s LISItemSenResultID=""  for  s LISItemSenResultID=$o(^Busi.ENS.EnsLISItemSenResultI("PKHIPUSERLISITEMSENRESULT",LISISRResultID,LISISRAntibioticsCode,LISItemSenResultID)) q:LISItemSenResultID=""  d
	....q:(ItemSenResultID'="")&&(LISItemSenResultID'=ItemSenResultID) //过滤药敏rowid不一致的数据
	....s LISItemSenResultData=$g(^Busi.ENS.EnsLISItemSenResultD(LISItemSenResultID))
	....s sstbcode=$lg(LISItemSenResultData,6)  //药敏代码
	....s sstbname=$lg(LISItemSenResultData,7)  //药敏名称
	....s retarsltcode=$lg(LISItemSenResultData,14) //抗药结果代码
	....s retarsltname=$lg(LISItemSenResultData,5) //抗药结果
	....s:sstbcode="I" refval=$lg(LISItemSenResultData,8) //I折点范围
	....s:sstbcode="S" refval=$lg(LISItemSenResultData,9) //S折点范围
	....s:sstbcode="R" refval=$lg(LISItemSenResultData,10) //R折点范围
	....s exammtd=$lg(LISItemSenResultData,12) //检验方法
	....s examrslt=$lg(LISItemSenResultData,5) //检验结果
	....s:HospDr'="" examorgname=$p($g(^CT("HOSP",HospDr)),"^",2) //检验机构名称
	....s valiflag="1" //有效标志
	....d OutOEItemInfo
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutOEItemInfo
	set Data=$lb(mdtrtsn,mdtrtid,psnno,appyno,rpotcno,germcode,germname,sstbcode,sstbname,retarsltcode,retarsltname,refval,exammtd,examrslt,examorgname,valiflag)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit $$$OK
}

ClassMethod SelectLabItemSenResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectLabItemSenResultExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SelectLabItemSenResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectLabItemSenResultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：ZhangXinying
/// CreatDate：2021—12-16
/// Description：诊断信息
/// Table：mr_diagnos
/// Input：AdmDr:就诊rowid
/// Output:诊断名称1,诊断名称2
/// Debug:w ##class(web.DHCENS.STBLL.Method.QueryReportInsu).GetDiagnoses("47")
ClassMethod GetDiagnoses(AdmDr As %String) As %String
{
	s mainmradmdr = $p($g(^PAADM(AdmDr)),"^",61)
	q:(mainmradmdr = "") ""
	q:($d(^MR(mainmradmdr)) = 0) ""
	
	s themrdiachildsub = ""
	s mrdiachildsub = ""
	s admDiagTypeCode="",admDiagTypeDesc="",PADDiagDesc=""
	s admDiagTypeDesc1="",PADDiagDesc1=""
	for {
		s mrdiachildsub=$o(^MR(mainmradmdr,"DIA",mrdiachildsub))
		q:(mrdiachildsub="")
		if (mrdiachildsub'=0) {
		    s admDiagTypeId=$g(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",1))
	        ;s:admDiagTypeId'="" admDiagTypeCode=$p($g(^MRC("DTYP",admDiagTypeId)),"^",1)
	        s:admDiagTypeId'="" admDiagTypeDesc=$p($g(^MRC("DTYP",admDiagTypeId)),"^",2)
		    s themrdiachildsub = mrdiachildsub
		    s mricdid = $p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",1)
	        if (mricdid="") {
		        set mricdCode=""
		        set mricdDesc=""
		    }
		    else {
		        s mricdCode = $p($g(^MRC("ID",mricdid)),"^",1)
		        s mricdDesc = $p($g(^MRC("ID",mricdid)),"^",2)
		    }
		    			
		    // MR_Diagnos  表的 MRDIA_DiagStat_DR
		    set PADDiagDesc=mricdDesc
		    /*
		    if admDiagTypeDesc1="" set admDiagTypeDesc1=admDiagTypeDesc
		    else  set admDiagTypeDesc1=admDiagTypeDesc1_","_admDiagTypeDesc
		    */
		    if PADDiagDesc1="" set PADDiagDesc1=PADDiagDesc
		    else  set PADDiagDesc1=PADDiagDesc1_","_PADDiagDesc
		}
	}
	q PADDiagDesc1
}

/// Description: 获取医嘱价格,支持多院区
/// Debug: w ##class(web.DHCENS.STBLL.LIS.METHOD.PatLisOrdInfo).GetPrice("1629||28")
ClassMethod GetPrice(rowid As %String) As %String
{
	set $zt="Exception"
    set EpissubtypeDR=""
    set tempRowid=##class(web.DHCENS.STBLL.UTIL.Common).ReplaceStr(rowid,"_","||")
    set tmpAdm=$p($g(^OEORD(+tempRowid)),"^",1)
    set EpissubtypeDR=$P($g(^PAADM(tmpAdm,1)),"^",6)
       
    // 取子医嘱中医嘱价格，当医嘱类型的子类是Price时，取医嘱表中OEORI_Price中价格，
    // 然后调用计费组方法set tmpchild=##CLASS(web.UDHCJFPRICE).GetOrderPrice(EpissubtypeDR,"",childarcimId,$P(childordstr3,"^",7),"","","",$p(childordstr3,"^",25))
    set childIndex="",childOrdPrice=0
    set ord=+rowid
    set arcimId = $P($g(^OEORD(ord,"I",$p(rowid,"||",2),1)),"^",2)
    set arcSub = $P(arcimId,"||",1)
    set arcVer = $P(arcimId,"||",2)
    
    f  s childIndex=$o(^OEORDi(0,"OEORI",ord,tempRowid,childIndex))  q:childIndex=""  d
	.set childordstr1 = $g(^OEORD(ord,"I",childIndex,1))
	.set childordstr3 = $g(^OEORD(ord,"I",childIndex,3))
	.set childarcimId = $P(childordstr1,"^",2)
	.set ItmMastFirst=$p(childarcimId,"||",1)
	.set ItmMastLast=$p(childarcimId,"||",2)
	.set ItemCatRowID=$p($g(^ARCIM(ItmMastFirst,ItmMastLast,1)),"^",10)
	
	.set ItmCatType=$p($g(^ARC("IC",ItemCatRowID)),"^",7)
	.set tmpchild=0
	.i ItmCatType="P" d
	..set tmpchild=##CLASS(web.UDHCJFPRICE).GetOrderPrice(EpissubtypeDR,"",childarcimId,$P(childordstr3,"^",7),"","","",$p(childordstr3,"^",25))
	.set childOrdPrice=+childOrdPrice++($P(tmpchild,"^",1))
	
	set OrdSubCatRowID=$p($g(^ARCIM(arcSub,arcVer,1)),"^",10)
    //取父医嘱价格信息，方式同取子医嘱类方法相同
	set CatType=$p($g(^ARC("IC",OrdSubCatRowID)),"^",7)
	set tmpPrice=""
	set VerifyDate=$P($g(^OEORD(ord,"I",$p(rowid,"||",2),3)),"^",7)
	set AdmID=$p($g(^OEORD(ord)),"^",1)
	q:AdmID="" ""
	set LocDr=$p($g(^PAADM(AdmID)),"^",4)
	q:LocDr="" ""
	set HospDr=$p($g(^CTLOC(LocDr)),"^",22)
	if (CatType="P") {
		s tmpPrice=$p(ordstr3,"^",25)
    	set price = ##CLASS(web.UDHCJFPRICE).GetOrderPrice(EpissubtypeDR,"",arcimId,VerifyDate,"","","",+tmpPrice,HospDr)
	}
	else {
    	set price = ##CLASS(web.UDHCJFPRICE).GetOrderPrice(EpissubtypeDR,"",arcimId,VerifyDate,"","","","",HospDr)
	}
    set TotalPrice=childOrdPrice+price
    Quit TotalPrice
Exception
	Quit "价格异常"
}

}
