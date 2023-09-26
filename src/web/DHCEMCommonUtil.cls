/// Creator: 	huaxiaoying
/// CreateDate: 2016-05-10
/// Descript: 	公共类
Class web.DHCEMCommonUtil Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:js 获取医院字典信息
/// Creator:LiangQiang
/// CreateDate:2016-04-21
/// w ##Class(web.DHCEMCommonUtil).GetHospDs()
ClassMethod GetHospDs() As %String
{
	s count=0
	w "["
	s hosprowid=""
	f  s hosprowid=$o(^CT("HOSP",hosprowid)) q:hosprowid=""  d
	.q:hosprowid=0
	.s hospdesc=$p(^CT("HOSP",hosprowid),"^",2) 
	.s hospDateTo=$p(^CT("HOSP",hosprowid),"^",10) ;huaxiaoying 2017-1-6
	.i hospDateTo'=""  q:hospDateTo<+$h ;huaxiaoying 2017-1-6
	.s tmp=hosprowid_"^"_hospdesc
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	w "]"
	q ""
}

/// Description: 公共 (页面日期 转为 M中的日期数字)
/// Creator:     huaxiaoying
/// CreateDate:  2017-03-03
/// Table: 		 
/// Input:       页面日期  例如：2017-03-03、28/2/2017等
/// Output:  	 M中日期数字 64338
/// Others:	w ##class(web.DHCEMCommonUtil).DateHtmlToLogical("2017-03-03")	
ClassMethod DateHtmlToLogical(date As %String) As %String
{
	N (date)
	q:date=""""
	s DHCEMCommonDate=""
	s DHCEMCommonDate=##class(websys.Conversions).DateHtmlToLogical(date)
	q DHCEMCommonDate
}

/// Description: 公共 (M中的日期数字 转为 demo配置日期)
/// Creator:     huaxiaoying
/// CreateDate:  2017-03-03
/// Table: 		 
/// Input:       M中日期数字 64345
/// Output:  	 demo配置的日期格式
/// Others:	w ##class(web.DHCEMCommonUtil).DateLogicalToHtml("64345")	
ClassMethod DateLogicalToHtml(date As %String) As %String
{
	N (date)
	q:date=""""
	s DHCEMCommonDate=""
	s DHCEMCommonDate=##class(websys.Conversions).DateLogicalToHtml(date)
	q DHCEMCommonDate
}

/// Description: 公共 (获取系统日期格式配置)
/// Creator:     huaxiaoying
/// CreateDate:  2017-03-06
/// @return 
///    1 MM/DD/YYYY
///    3 YYYY-MM-DD
///    4 DD/MM/YYYY
/// Others:	w ##class(web.DHCEMCommonUtil).DateFormat()
ClassMethod DateFormat()
{
	s dateformat=$lg(^websys.ConfigurationD(1),10)
	s datesper=$lg(^websys.ConfigurationD(1),4)
	i (dateformat="DMY")&&(datesper="/") Quit 4
	i (dateformat="YMD")&&(datesper="-") Quit 3
	i (dateformat="MDY")&&(datesper="/") Quit 1
	Quit 4
}

/// Description: 公共 (js配置日期)
/// Creator:     huaxiaoying
/// CreateDate:  2017-03-06 	
ClassMethod WriteDateFormat()
{
	Set format = ..DateFormat()
	w "<script type='text/javascript'>",!
	w "$.fn.datepicker.dates['zh-CN'] = {",!
	w "days: ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'],",!
	w "daysShort: ['周日', '周一', '周二', '周三', '周四', '周五', '周六'],",!
	w "daysMin: ['日', '一', '二', '三', '四', '五', '六'],",!
	w "months: ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月'],",!
	w "monthsShort: ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月'],",!
	w "today: "_"""今天"""_",",!
	w "clear: "_"""清除"""_",",!
	//w "format: 'dd/mm/yyyy',",!
	w:format=3 "format: 'yyyy-mm-dd',",!
	w:format=4 "format: 'dd/mm/yyyy',",!
	w "titleFormat: 'MM yyyy',",!
	w "weekStart: 0",!
	w "};",!
	w "$.fn.dhccDate=function(_options){",!
	w "	options={",!
	w "		autoclose:true,",!
	w "		language: 'zh-CN',",!
	w "		todayHighlight:true,",!
	w "		todayBtn:'linked'",!
	w "	}",!
	w "	var opts = $.extend({},options, _options);",!
	w "	return $(this).datepicker(opts);",!
	w "}",!
	w "$.fn.extend({ ",!
	w "	getDate: function () {",! 
	//w "		return $(this).datepicker('getDate').Format('dd/MM/yyyy')",!
	w:format=3 "		return $(this).datepicker('getDate').Format('yyyy-MM-dd')",!
	w:format=4 "		return $(this).datepicker('getDate').Format('dd/MM/yyyy')",!
	w "	},",!
	w "	setDate:function(date){",!
	w "		$(this).datepicker('setDate', date);",!
	w "	},",!  //hxy 2017-03-29 start w "	}",!
	w "setCurDate:function(){"
    w:format=3 "		return $(this).datepicker('setDate', new Date().Format('yyyy-MM-dd'))",!
    w:format=4 "		return $(this).datepicker('setDate', new Date().Format('dd/MM/yyyy'))",!        
    w "	}",!   //hxy 2017-03-29 end
	w "});",! 
	w "</"_"script>",!
}

/// Description: 公共 (js配置DateRange日期)
/// Creator:     huaxiaoying
/// CreateDate:  2017-03-08	
ClassMethod WriteDateRangeFormat()
{
	Set format = ..DateFormat()
	w "<script type='text/javascript'>",!
	w "$.fn.dhccDateRange=function(_options,cb){",!
	w "    options={}",!
	w "	options.locale = {",!
	w:format=3 "      format: 'YYYY-MM-DD',",!
	w:format=4 "      format: 'DD/MM/YYYY',",!
	w:format=3 "      separator: ' / ',",!
	w:format=4 "      separator: ' - ',",!
	w "     applyLabel: '确认',",!
	w "   cancelLabel: '取消',",!
	w "      fromLabel: '从',",!
	w "      toLabel: '到',",!
	w "      customRangeLabel: 'Custom',",!
	w "      daysOfWeek: ['日', '一', '二', '三', '四', '五','六'],",!
	w "      monthNames: ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月'],",!
	w "      firstDay: 1",!
    w "  	};",!
	w "	var opts = $.extend({},options, _options);",!
	w "	return $(this).daterangepicker(opts,cb);",!
	w "}",!
	w "</"_"script>",!
}

/// Description: 五级四区 
/// Creator:     huaxiaoying
/// CreateDate:  2020-02-21
/// Others:	w ##class(web.DHCEMCommonUtil).LevFormat(1)
ClassMethod LevFormat(Lev)
{
	s ret=""
	s:Lev="1" ret="Ⅰ"
	s:Lev="2" ret="Ⅱ"
	s:Lev="3" ret="Ⅲ"
	s:Lev="4" ret="Ⅳa"
	s:Lev="5" ret="Ⅳb"
	s:Lev="1级" ret="Ⅰ级"
	s:Lev="2级" ret="Ⅱ级"
	s:Lev="3级" ret="Ⅲ级"
	s:Lev="4级" ret="Ⅳa级"
	s:Lev="5级" ret="Ⅳb级"
	q ret
}

/// Creator:    qqa
/// CreateDate: 2020-05-07
/// Descript:   取病案号
/// InPut:      EpisodeID- 就诊ID
/// OutPut:     病案号
/// w ##Class(web.DHCEMCommonUtil).GetMrNo("16")
ClassMethod GetMrNo(EpisodeID As %String) As %String
{
	n (EpisodeID)
	q:(+EpisodeID=0) ""
	q:'$d(^PAADM(EpisodeID)) ""
	s MrNo=""
	s MedType=$p($g(^PAADM(+EpisodeID)),"^",2)	
	s IfHaveMethodByEpis=##class(websys.Conversions).IsValidMethodName("DHCWMR.IO.OutService","IGetMrNoByEpisodeID")
	i IfHaveMethodByEpis=1 d
	.s MrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,MedType,.ErrMsg)
    e  d
    .s MrNo=##Class(web.DHCWMRService).IGetMrNoByEpisodeID(EpisodeID)
	q MrNo
}

/// Creator:    hxy
/// CreateDate: 2020-05-12
/// Descript:   将数据保存到基础数据平台数据医院关联表中
/// InPut:      表名、数据ID、医院ID（单个医院）
/// OutPut:     0:成功,<0:失败
/// w ##Class(web.DHCEMCommonUtil).SaveHOSP("","",2)
ClassMethod SaveHOSP(TableName, DataReference, Hospital) As %String
{
	n (TableName, DataReference, Hospital)
	s HospAutflag = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut")
	q:HospAutflag'="Y" 0
	s Ret=##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP(TableName,DataReference,Hospital)
	q:+Ret<0 +Ret
	q 0
}

/// Creator:    hxy
/// CreateDate: 2020-05-12
/// Descript:   判断该条数据是否要显示到界面上
/// InPut:      表名、数据ID、选择医院ID、日期
/// OutPut:     Y/N
/// w ##Class(web.DHCEMCommonUtil).GetHospShowDataFlag()
ClassMethod GetHospShowDataFlag(TableName, DataReference, Hospital, Date = "") As %String
{
	n (TableName, DataReference, Hospital,Date)
	s ret=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(TableName, DataReference, Hospital,Date)
	q ret
}

/// Creator:    hxy
/// CreateDate: 2020-05-12
/// Descript:   删除通用医院关联表的表结构及关联医院保存方法
/// InPut:      表名、数据ID
/// OutPut:     成功：1  失败：-1^关联医院表数据删除失败
/// w ##Class(web.DHCEMCommonUtil).GetHospShowDataFlag()
ClassMethod DeleteHospitals(TableName, DataReference) As %String
{
	n (TableName, DataReference)
	s ret=##class(web.DHCBL.BDP.BDPMappingHOSP).DeleteHospitals(TableName,DataReference)
	q ret
}

/// Creator:    hxy
/// CreateDate: 2020-05-21
/// Descript:   获取医院接口（配置数据用）根据表名、业务数据中的医院、日期取要取哪个医院的配置。
/// InPut:      表名/配置名、医院ID、日期
/// OutPut:     医院ID
/// w ##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName()
ClassMethod GetDefHospIdByTableName(TableName, HospID, Date = "") As %String
{
	n (TableName, HospID,Date)
	s ret=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName(TableName,HospID,Date)
	q ret
}

/// Creator:    qqa
/// CreateDate: 2020-06-04
/// Description: 获取急诊留观收费模式
/// Input: 就诊ID
/// Return: 0:普通收费模式, 1:押金收费模式
/// Debug: w ##class(web.DHCEMCommonUtil).IGetStayPayModeByAdmID(2)
ClassMethod IGetStayPayModeByAdmID(EpisodeID)
{
	n (EpisodeID)
	s AdmHospDR=##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
	s ChargeMode=##class(web.DHCBillInterface).IGetStayPayMode(AdmHospDR)
	q ChargeMode
}

/// Creator:    qqa
/// CreateDate: 2020-06-04
/// Description: 获取急诊留观收费模式
/// Input:  医嘱ID
/// Return: 0:普通收费模式, 1:押金收费模式
/// Debug: w ##class(web.DHCEMCommonUtil).IGetStayPayModeByOrdItm("1")
ClassMethod IGetStayPayModeByOrdItm(OrderID)
{
	n (OrderID)
	s EpisodeID=+^OEORD(+OrderID)
	s ChargeMode=##class(web.DHCEMCommonUtil).IGetStayPayModeByAdmID(EpisodeID)
	q ChargeMode
}

/// Creator:    qqa
/// CreateDate: 2020-06-04
/// Description: 根据病人ID和就诊ID获取病人年龄
/// Input: 	就诊ID
/// Return: 年龄显示字符串
/// Debug: w ##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID("1")
ClassMethod GetPapmiAgeByAdmID(EpisodeID)
{
	n (EpisodeID,%session)
	s PatientID=+^PAADM(+EpisodeID)
	s AdmHospDR=##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
	s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID,"",AdmHospDR)
	s:PatAge="未知" PatAge=##class(web.DHCEMCommonUtil).GetTrans("web.DHCEMCommonUtil","未知") //hxy 2022-12-06
	;s PatAge=##Class(web.DHCSTKUTIL).GetAge(PatientID)
	q PatAge
}

/// Creator:    qqa
/// CreateDate: 2020-06-04
/// Description: 根据病人ID和就诊ID获取病人年龄
/// Input: 	就诊ID
/// Return: 年龄显示字符串
/// Debug: w ##class(web.DHCEMCommonUtil).GetPapmiAgeByPatCheckLevID("1")
ClassMethod GetPapmiAgeByPatCheckLevID(PCLRowID)
{
	n (PatientID,PCLRowID)
	s PatientID=$p(^DHCEMPCL(PCLRowID),"^",1)
	s PCLLocID=$p(^DHCEMPCL(PCLRowID),"^",10)
	s PCLHospID=$p(^CTLOC(PCLLocID),"^",22)
	s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID,"",PCLHospID)
	q PatAge
}

/// Creator：       乔庆澳
/// CreatDate：     2020-06-09
/// Description:：  根据就诊Rowid取其所在医院的RowID
/// Table：       
/// Input：         就诊Rowid
/// Output：          
/// Return：        医院的RowID
/// Others：  w ##class(web.DHCEMCommonUtil).GetHospitalByAdm(adm)
ClassMethod GetHospitalByAdm(adm)
{
	q:adm="" ""
	s AdmDep=$p(^PAADM(adm),"^",4)
	s HospID=##class(web.DHCEMCommonUtil).GetHospitalIDByLocID(AdmDep)
	q $g(HospID)
}

/// Creator：       乔庆澳
/// CreatDate：      2020-06-09
/// Description:：  根据科室RowID取其所在医院的RowID
/// Table：       
/// Input：         科室RowID 
/// Output：          
/// Return：        医院的RowID
/// Others： w ##class(web.DHCEMCommonUtil).GetHospitalIDByLocID(adm)       
ClassMethod GetHospitalIDByLocID(LocID As %String = "") As %String
{
	new (LocID)
	set HospitalID=""
	if LocID="" quit HospitalID
	set HospitalID=$piece($get(^CTLOC(LocID)),"^",22)
	quit HospitalID
}

/// Creator:      qqa
/// CreatDate:    2020-09-17
/// Description:  获取本次就诊诊断记录
/// Table:        
/// Input:        入参：就诊ID,(1:中医,空或0:西医),(空:获取全部,不为空:获取指定诊断代码的诊断)
/// Return:       出参：ICD描述 诊断表ID ICD诊断ID 诊断注释 ICDCode 诊断类型 诊断注释 日期 发病日期 诊断状态描述 诊断级别(数字)
/// Others:  w ##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(63,"","")  
ClassMethod GetMRDiagnosDesc(AdmID, ICDType = "", DiagnosTypeCode = "", Limit = "", MoreLanguage = "")
{
	n (AdmID,ICDType,DiagnosTypeCode,Limit,MoreLanguage,%session)
	;s Ret=""
	;i ##class(websys.Conversions).IsValidMethodName("web.DHCDocInterfaceMethod","DHCDocHisInterface") d
	;.s Ret = ##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.diag.GetAdmDiagDesc",AdmID, "", "") ;
	;q:Ret Ret
	
	s:Limit="" Limit=","
	s Ret=""
	s MRAdmID=$p(^PAADM(AdmID),"^",61)
	Set Result=##class(%Library.ResultSet).%New("DHCDoc.Interface.Inside.Service:DiagnosList")
 	Set Sc=Result.Execute(MRAdmID, ICDType, DiagnosTypeCode)
 	If $$$ISERR(Sc) Quit ""
	While(Result.Next()){
		s DiagnosDesc=Result.Data("SDSDesc")  /// 结构化诊断
		i DiagnosDesc="" D
		.s DiagnosDesc=Result.Data("DiagnosDesc")
		s:DiagnosDesc'="" DiagnosDesc=$replace(DiagnosDesc,"&nbsp","")
		s DiagnosDesc = ##class(web.DHCEMCommonUtil).GetTransDesc("User.MRCICDDx","MRCIDDesc","",DiagnosDesc)
		s DiagnosMRDesc=Result.Data("DiagnosMRDesc")
		s DiagnosPrefix=Result.Data("DiagnosPrefix")
		s:Ret'="" Ret=Ret_Limit_DiagnosPrefix_DiagnosDesc_DiagnosMRDesc
		s:Ret="" Ret=DiagnosPrefix_DiagnosDesc_DiagnosMRDesc
	}
	q Ret
}

/// Creator:      qqa
/// CreatDate:    2020-09-17
/// Description:  获取本次就诊诊断记录:润乾报表使用
/// Table:        
/// Input:        入参：就诊ID,(1:中医,空或0:西医),(空:获取全部,不为空:获取指定诊断代码的诊断)
/// Return:       出参：ICD描述 诊断表ID ICD诊断ID 诊断注释 ICDCode 诊断类型 诊断注释 日期 发病日期 诊断状态描述 诊断级别(数字)
/// Others:  w ##class(web.DHCEMCommonUtil).GetMRDiagnosDescForRunQian(38,"","")  
ClassMethod GetMRDiagnosDescForRunQian(AdmID, ICDType = "", DiagnosTypeCode = "", Limit = "")
{
	n (AdmID,ICDType,DiagnosTypeCode,Limit,%session)
	s:Limit="" Limit=","
	s Ret=""
	s MRAdmID=$p(^PAADM(AdmID),"^",61)
	Set Result=##class(%Library.ResultSet).%New("DHCDoc.Interface.Inside.Service:DiagnosList")
 	Set Sc=Result.Execute(MRAdmID, ICDType, DiagnosTypeCode)
 	If $$$ISERR(Sc) Quit ""
 	s Count=0
	While(Result.Next()){
		s Count=Count+1
		s DiagnosDesc=Result.Data("DiagnosDesc")
		s:DiagnosDesc'="" DiagnosDesc=$replace(DiagnosDesc,"&nbsp","")
		s DiagnosMRDesc=Result.Data("DiagnosMRDesc")
		s DiagnosPrefix=Result.Data("DiagnosPrefix")
		s:Ret'="" Ret=Ret_Limit_Count_"."_DiagnosPrefix_DiagnosDesc_DiagnosMRDesc
		s:Ret="" Ret=Count_"."_DiagnosPrefix_DiagnosDesc_DiagnosMRDesc
	}
	q $ZCVT(Ret,"O","JS")
}

/// Creator:      qqa
/// CreatDate:    2020-09-17
/// Description:  获取用户是否有当前医院的登录权限
/// Table:        
/// Input:        入参：用户code,用户Id,医院Id
/// Return:       出参：Y/N/""
/// Others:  w ##class(web.DHCEMCommonUtil).UserIsHasThisHospManag("","1","2") 
ClassMethod UserIsHasThisHospManag(UserCode, UserId, HospId)
{
	n (UserCode,UserId,HospId)
	s:(UserId="")&&(UserCode'="") UserId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserCode),""))
	q:+UserId=0 ""
	s Ret="N"
	s OTHLLSub=0
	f  s OTHLLSub=$o(^SSU("SSUSR",UserId,"OTHLL",OTHLLSub)) q:(OTHLLSub="")||(Ret'="N")  d
	.s OTHLLCTLocID=$p(^SSU("SSUSR",UserId,"OTHLL",OTHLLSub),"^",1)
	.s OTHLLCTLocHospID=##class(web.DHCEMCommonUtil).GetHospitalIDByLocID(OTHLLCTLocID)
	.q:OTHLLCTLocHospID'=HospId
	.s Ret="Y"
	q Ret
}

/// Creator:      hxy
/// CreatDate:    2022-07-20
/// Description:  由绿通ID获取医院ID
/// Table:        
/// Input:        入参：绿通ID
/// Return:       出参：医院Id
/// Others:  w ##class(web.DHCEMCommonUtil).GetHospitalIDByGreID("1") 
ClassMethod GetHospitalIDByGreID(GreID)
{
	n (GreID)
	s ret=""
	s ChkID=$p(^DHCEMPGR(GreID),"^",1)
	s AdmID=$p(^DHCEMPGR(GreID),"^",6)
	s LoDr=$p($g(^PAADM(+AdmID)),"^",4)
	i LoDr="" d 
	.s EmPccID=$o(^DHCEMPCC(0,"PatCheckLev",ChkID,""))
	.i EmPccID'="" s LoDr=$p(^DHCEMPCC(EmPccID),"^",3)
	s ret=##class(web.DHCEMCommonUtil).GetHospitalIDByLocID(LoDr)
	q ret
}

/// Description:根据医嘱ID获取医嘱剂量(无单位),单位为原医嘱子表剂量单位
/// Creator:    hxy
/// CreateDate: 2022-10-12
/// Return：    不带单位的剂量,多种剂量格式为(200-300)
/// Version:    V8.3.3+(V8.5.3+)
/// Provider:   医生站
/// Caller:     
/// Others:     该版本后的医嘱可修改某天某次剂量,取值调用医生站接口
/// Debug:      w ##class(web.DHCEMCommonUtil).GetOrdDoseQty()
ClassMethod GetOrdDoseQty(oeori, searchDate = "")
{
	n (oeori,searchDate)
    q ##class(DHCDoc.Interface.Inside.ServiceOrd).GetOrdDoseQty(oeori,searchDate)
}

/// Creator:      hxy
/// CreatDate:    2022-10-18
/// Description:  由就诊ID获取患者ID
/// Table:        
/// Input:        入参：就诊ID
/// Return:       出参：患者ID
/// Others:  w ##class(web.DHCEMCommonUtil).GetPatientID("3345") 
ClassMethod GetPatientID(EpisodeID)
{
	n (EpisodeID)
	q:EpisodeID="" ""
	s PatientID=""
	s PatientID=$p($g(^PAADM(+EpisodeID)),"^",1) 
	q PatientID
}

/// Creator:      hxy
/// CreatDate:    2022-10-19
/// Description:  由就诊ID获取患者登记号
/// Table:        
/// Input:        入参：就诊ID
/// Return:       出参：患者登记号
/// Others:  w ##class(web.DHCEMCommonUtil).GetRegNo("3592") 
ClassMethod GetRegNo(EpisodeID)
{
	n (EpisodeID)
	q:EpisodeID="" ""
	s RegNo=""
	s PatientID=$p($g(^PAADM(+EpisodeID)),"^",1)
	s RegNo=$p($g(^PAPER(+PatientID,"PAT",1)),"^",1) // 登记号
	q RegNo
}

/// Creator:      bianshuai
/// CreateDate:   2020-05-11
/// Descript:     多语言支持
/// InPut:        
/// OutPut:       
/// w ##Class(web.DHCEMCommonUtil).GetTransDesc("2","30","","")
ClassMethod GetTransDesc(TableName As %String, FieldName As %String, Languages As %String, FieldDesc As %String) As %String
{
	n (TableName, FieldName, Languages, FieldDesc,%session)
	i $d(%session)&&(Languages="") d
	.s LanguagesDr=$g(%session.Data("LOGON.LANGID"))
    .s:LanguagesDr'="" Languages=$p($g(^SS("LAN",LanguagesDr)),"^",1)
	
	Q:(TableName="")||(FieldName="")||(Languages="")||(FieldDesc="") FieldDesc
	s $ZT="TrsErrMsg"
	s BTTransDesc=""
	s:Languages'="CH" BTTransDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc(TableName, FieldName, Languages, FieldDesc)
	s:Languages="CH" BTTransDesc=..GetBeforeTransDesc(TableName, FieldName, "EN", FieldDesc)
	Q BTTransDesc
TrsErrMsg
	Q FieldDesc
}

/// Creator:      hxy
/// CreateDate:   2022-11-30
/// Descript:     多语言后台页面翻译
/// InPut:        @param String  page为当前csp名字,@param String  item为要翻译的键,@param Int langid语言ID
/// OutPut:       
/// w ##Class(web.DHCEMCommonUtil).GetTrans("2","30","","")
ClassMethod GetTrans(Page As %String, Item As %String) As %String
{
	n (Page, Item, %session)
	
	Q:(Item="") ""
	s $ZT="TrsErrMsg"
	s Trans=##class(websys.Translation).Get(Page,Item)
	Q Trans
TrsErr
	Q Item
}

/// Creator:      cy
/// CreateDate:   2023-02-20
/// Descript:     根据表名，字段名，语言和翻译后内容，返回翻译前内容
/// InPut:        表名，字段名，语言和翻译后内容
/// OutPut:       翻译前内容
/// w ##Class(web.DHCEMCommonUtil).GetBeforeTransDesc("User.DHCPACVisitStatus","PVSDesc","EN","Arrive")
ClassMethod GetBeforeTransDesc(TableName As %String, FieldName As %String, Languages As %String, FieldDesc As %String) As %String
{
	n (TableName, FieldName, Languages, FieldDesc,%session)
	i $d(%session)&&(Languages="") d
	.s LanguagesDr=$g(%session.Data("LOGON.LANGID"))
    .s:LanguagesDr'="" Languages=$p($g(^SS("LAN",LanguagesDr)),"^",1)
	s:Languages="CH" Languages="EN"
	Q:(TableName="")||(FieldName="")||(Languages="")||(FieldDesc="") FieldDesc
	s $ZT="TrsBefErrMsg"
	s BTTransDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetBeforeTransDesc(TableName, FieldName, Languages, FieldDesc)
	Q BTTransDesc
TrsBefErrMsg
	Q FieldDesc
}

/// Creator:      hxy
/// CreateDate:   2023-02-07
/// Descript:     护理组维护的PPD医嘱接口
/// InPut:        医嘱ID
/// OutPut:       Y:是 N:否
/// w ##Class(web.DHCEMCommonUtil).IfPPDOrder("3254||16")
ClassMethod IfPPDOrder(Order As %String) As %String
{
	n (Order,%session)
	Q:(Order="") ""
	s Ret=##class(Nur.NIS.Service.Base.OrderHandle).IfPPDOrder(Order)
	Q Ret
}

/// Creator:      hxy
/// CreateDate:   2023-03-21
/// Descript:     判断是否未婴儿床
/// InPut:        BedTypeCode
/// OutPut:       Y:是 N:否
/// w ##Class(web.DHCEMCommonUtil).IfBabyBed("MATERNALBABY")
ClassMethod IfBabyBed(BedTypeCode As %String) As %String
{
	n (BedTypeCode,%session)
	s Ret=##class(Nur.NIS.Service.Base.Bed).ifBabyBed(BedTypeCode)
	Q Ret
}

}
