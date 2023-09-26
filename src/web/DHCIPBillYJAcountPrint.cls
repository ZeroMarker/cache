/// 名称: web.DHCIPBillYJAcountPrint.cls
/// 编写者: zhli
/// 描述: 住院预交金账报表类
/// 编写日期：2018-07-19
Class web.DHCIPBillYJAcountPrint Extends %RegisteredObject
{

/// Creator: zhli
/// CreatDate: 2018-07-19
/// Description: 统计住院预交金账汇总
/// Input: stDate:开始日期(不能为空), endDate:结束日期(不能为空), hospId:医院Id
/// Output: ThandDate:做账日期,TlastRemain:上期余额,TjfSum:借方金额,dfSum:贷方金额,currRemain:本期余额
/// Return: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillYJAcountPrint","GetIPBillYJAcountHZReport", "2021-07-01", "2021-11-22", 2)
Query GetIPBillYJAcountHZReport(stDate As %String, endDate As %String, hospId As %String) As websys.Query(ROWSPEC = "ThandDate:%String:做账日期,TlastRemain:%Float:上期余额,TjfSum:%Float:借方金额,dfSum:%Float:贷方金额,currRemain:%Float:本期余额") [ SqlProc ]
{
}

ClassMethod GetIPBillYJAcountHZReportExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, hospId As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
	if ((stDate="")||(endDate=""))  quit $$$OK
	
	if (stDate["-") set stDate=$zdh(stDate,3)
	if (endDate["-") set endDate=$zdh(endDate,3)
	if (stDate["/") set stDate=$zdh(stDate,4)
	if (endDate["/") set endDate=$zdh(endDate,4)
		
	for prtdate=stDate:1:endDate {
		set accId=0
		while($o(^DHCJFYJACOUNT(0,"ENDDATE",prtdate,accId))) {
			set accId=$o(^DHCJFYJACOUNT(0,"ENDDATE",prtdate,accId))
			set accData=$g(^DHCJFYJACOUNT(accId))
		    set acctflag=$p(accData,"^",9)
			continue:(acctflag'="YJACOUNT")
			set hospDR=$p(accData,"^",16)
		    continue:(hospDR'=hospId)
		    set lastRemain=$p(accData,"^",1)
		    set jfSum=$p(accData,"^",2)
		    set dfSum=$p(accData,"^",3)
		    set currRemain=$p(accData,"^",4)
		    set handDate=##class(websys.Conversions).DateLogicalToHtml(prtdate)
			set data=$lb(handDate,lastRemain,jfSum,dfSum,currRemain)
			set ^CacheTemp(repid,$i(ind))=data
		}
	}
	quit $$$OK
}

/// Creator: zhli
/// CreatDate: 2018-07-19
/// Description: 统计住院预交金账明细
/// Input: stDate:开始日期(不能为空), endDate:结束日期(不能为空), hospId:医院Id
/// Output: zyno:住院号,papname:姓名,admDate:入院日期,patloc:就诊科室,prebal:上期余额,addamt:交退押金,refamt:结算押金,curbal:本期余额
/// Return: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillYJAcountPrint","GetIPBillYJAcountDetailReport", "2021-09-09", "2021-11-22", 2)
Query GetIPBillYJAcountDetailReport(stDate As %String, endDate As %String, hospId As %String) As websys.Query(ROWSPEC = "zyno:%String:住院号,papname:%String:姓名,admDate:%String:入院日期,patloc:%String:就诊科室,prebal:%Float:上期余额,addamt:%Float:交退押金,refamt:%Float:结算押金,curbal:%Float:本期余额") [ SqlProc ]
{
}

ClassMethod GetIPBillYJAcountDetailReportExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, hospId As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
	if ((stDate="")||(endDate=""))  quit $$$OK
	
	if (stDate["-") set stDate=$zdh(stDate,3)
	if (endDate["-") set endDate=$zdh(endDate,3)
	if (stDate["/") set stDate=$zdh(stDate,4)
	if (endDate["/") set endDate=$zdh(endDate,4)
		
	for prtdate=stDate:1:endDate {
		set accId=0
		while($o(^DHCJFYJACOUNT(0,"ENDDATE",prtdate,accId))) {
			set accId=$o(^DHCJFYJACOUNT(0,"ENDDATE",prtdate,accId))
			set accData=$g(^DHCJFYJACOUNT(accId))
		    set acctflag=$p(accData,"^",9)
			continue:(acctflag'="YJACOUNT")
		    set hospDR=$p(accData,"^",16)
		    continue:(hospDR'=hospId)
		    set sub=0
		    while($o(^DHCIPBillDeptAcountD(accId,"SUB",sub))) {
			    set sub=$o(^DHCIPBillDeptAcountD(accId,"SUB",sub))
				set subData=$g(^DHCIPBillDeptAcountD(accId,"SUB",sub))
				set adm=$p(subData,"^",1)
				set prebal=$p(subData,"^",2)
				set addamt=$p(subData,"^",3)     //交退押金
				set refamt=$p(subData,"^",4)     //结算押金
				set curbal=$p(subData,"^",6)
				set papmi=$p(^PAADM(adm),"^",1)
			   	set papname=$p(^PAPER(papmi,"ALL"),"^",1)
			   	set papno=$p(^PAPER(papmi,"PAT",1),"^",1)
				set mrNo=##class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(adm, "I", "")
				set admInOutDateInfo=##class(web.UDHCJFBaseCommon).GetOutAdmInOutDateInfo(adm)
				set admDate=$p(admInOutDateInfo,"^",5)
				set admDate=##class(websys.Conversions).DateLogicalToHtml(admDate)
				set deptDR=$p(^PAADM(adm),"^",4)
				set patloc=$s((deptDR'=""):$p(^CTLOC(deptDR),"^",2),1:"")
				set data=$lb(mrNo,papname,admDate,patloc,prebal,addamt,refamt,curbal)
				set ^CacheTemp(repid,$i(ind))=data
			}
		}
	}
	
	quit $$$OK
}

}
