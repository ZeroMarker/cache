/// 名称:     web.UDHCOPBillTallyDetail
/// 描述:     实现门诊记账的统计 
/// 编写者：  王刚
/// 编写日期: 2008.10.15
Class web.UDHCOPBillTallyDetail Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：      王刚
/// CreatDate：    2008.10.16
/// Description:： 一段日期内记帐的公司
/// Table：        pa_person
/// Input：        开始日期，结束日期，所选的公司
/// Output：       公司的具体费用情况
/// Return：       Query
Query FindCompany(startDate, endDate) As %Query(ROWSPEC = "desc:%String,code:%String")
{
}

ClassMethod FindCompanyExecute(ByRef qHandle As %Binary, startDate, endDate) As %Status
{
  
  s repid=$I(^CacheTemp)
  s ind=1
  s hcpRowId=0
  f  s hcpRowId=$o(^CT("HCP",hcpRowId)) q:hcpRowId=""  d
  .s desc=$p(^CT("HCP",hcpRowId),"^",2)
  .s code=$p(^CT("HCP",hcpRowId),"^",1)
  .do OutPut
  S qHandle=$lb(0,repid,0)
  Q $$$OK
OutPut 
    s Data=$lb(desc,code)
 	S ^CacheTemp(repid,ind)=Data
 	S ind=ind+1
	q
}

ClassMethod FindCompanyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCompanyExecute ]
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

ClassMethod FindCompanyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCompanyExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：      王刚
/// CreatDate：    2008.10.16
/// Description:： 门诊单位医药费记账明细表
/// Table：        pa_person,dhc_invprt,dhc_billconinv,dhc_patientbill,dhc_patbillorder,dhc_patbilldetail,pa_adm,pa_patmas,dhc_taritem,DHC_TarOutpatCate 
/// Input：        开始日期，结束日期，所选的公司
/// Output：       每个人的具体费用情况
/// Return：       Query
Query FindInfo(startDate, endDate, company) As %Query(ROWSPEC = "DATE:%String,NAME:%String,ZCYAll:%Float,ZCHYAll:%Float,XYFAll:%Float,SSFAll:%Float,HYFAll:%Float,JCFAll:%Float,ZLFAll:%Float,SXFAll:%Float,SYFAll:%Float,XGFAll:%Float,QTAll:%Float,HJAll:%Float,Tjob:%String") [ SqlProc ]
{
}

ClassMethod FindInfoExecute(ByRef qHandle As %Binary, startDate, endDate, company) As %Status
{
  s repid=$I(^CacheTemp)
  s ind=1
  k ^TMP("OPJF",$j)
  s startDate=##class(websys.Conversions).DateHtmlToLogical(startDate)
  s endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
  ;w startDate_","_endDate_","_company,!
  ; d ##class(%ResultSet).RunQuery("web.UDHCOPBillTallyDetail","FindInfo",63790,63791,"MIC合同单位001")
  ;s startDate=$zdh(startDate,3),endDate=$zdh(endDate,3)
  k ArrBillNo
  i company'="" d
  .f prtDate=startDate:1:endDate d
  ..s prtRowid=0
  ..f  s prtRowid=$o(^DHCINVPRT(0,"Date",prtDate,prtRowid)) q:prtRowid=""  d
  ...;q:$p(^DHCINVPRT(prtRowid),"^",8)'="N"    //不为正常的去掉
  ...s ipmSub=0,payModeRowId=0,CCPFlag=0
  ...f  s ipmSub=$o(^DHCINVPRT(prtRowid,"P",ipmSub)) q:ipmSub=""  d
  ....s payModeRowId=$p(^DHCINVPRT(prtRowid,"P",ipmSub),"^",1)
  ....i $p(^CT("CTPM",payModeRowId),"^",1)="CCP" s CCPFlag=1
 
  ...q:CCPFlag'=1
  ...;q:payModeRowId=""
  ...;q:$p(^CT("CTPM",payModeRowId),"^",1)'="CCP"
  ...s papMiDr=""
  ...s papMiDr=$p(^DHCINVPRT(prtRowid),"^",15)   //指向个人信息表--->pa_patmas
  ...i $d(^PAPER(papMiDr)) d  s paperRowId=papMiDr     //pa_patmas<----pa_person
  ...s cmp=""
  ...;s cmp=$p(^PAPER(paperRowId,"PER",4),"^",18)     //得到公司名称
  ...s userRowId=paperRowId                //病人Rowid
  ...s hcpRowId=""
  ...s hcpRowId=$p(^PAPER(papMiDr,"PER",4),"^",17) //--->CT_HealthCareProvider
  ...i hcpRowId'=""  d
  ....s cmp=$p(^CT("HCP",hcpRowId),"^",2)
 
  ...q:cmp'=company
  ...s paadmRowID=0
  ...f  s paadmRowID=$o(^PAPERdr(paperRowId,"ADM","O",paadmRowID)) q:paadmRowID=""  d 
  ....s dhcbciRowid=0
  ....f  s dhcbciRowid=$o(^DHCBCI(0,"ADM",paadmRowID,dhcbciRowid)) q:dhcbciRowid=""  d         //关联dhc_patientbill和dhc_invprt
  .....s paAdmRowId=$p(^DHCBCI(dhcbciRowid),"^",3)                    //指向pa_adm.rowid
  .....s tPrtRowid=$p(^DHCBCI(dhcbciRowid),"^",1)                    //指向DHCINVPRT
  .....q:$p(^PAADM(paAdmRowId),"^",1)'=papMiDr                        //不是同一个人退出
  .....s PrtDate=$p(^DHCINVPRT(tPrtRowid),"^",5)
  .....q:(PrtDate<startDate)!(PrtDate>endDate)
  .....s billRowId=""
  .....s billRowId=$p(^DHCBCI(dhcbciRowid),"^",2)           //得到帐单号的dhc_patientbill.Rowid
  .....q:$d(ArrBillNo(billRowId))
  .....s ArrBillNo(billRowId)=billRowId
  .....s pboChildSub=0                         //dhc_patbillorder 病人遗嘱明细
  .....f  s pboChildSub=$o(^DHCPB(billRowId,"O",pboChildSub)) q:pboChildSub=""  d                     //dhc_patbillorder
  ......s pbdChildSub=0
  ......f  s pbdChildSub=$o(^DHCPB(billRowId,"O",pboChildSub,"D",pbdChildSub)) q:pbdChildSub=""  d   //dhc_patbliidetail
  .......s tariRowId=$p(^DHCPB(billRowId,"O",pboChildSub,"D",pbdChildSub),"^",3) 
  .......i $d(^DHCTARI(tariRowId)) d  s outpatCateRowId=$p(^DHCTARI(tariRowId),"^",15)   //指向 DHC_TarOutpatCate
  .......i $d(^DHCTarC("OC",outpatCateRowId)) d  s trorcRowid=$p(^DHCTarC("OC",outpatCateRowId),"^",3)         //收费项目Rowid
  .......s payOrShare=$p(^DHCPB(billRowId,"O",pboChildSub,"D",pbdChildSub),"^",7)    //记账数
  .......i $p(^DHCTarC("TOC",trorcRowid),"^",2)="中草药" d  s ^TMP("OPJF",$j,userRowId,prtDate,"ZCY")=+$g(^TMP("OPJF",$j,userRowId,prtDate,"ZCY"))+payOrShare
  .......e  i $p(^DHCTarC("TOC",trorcRowid),"^",2)="中成药" d  s ^TMP("OPJF",$j,userRowId,prtDate,"ZCHY")=+$g(^TMP("OPJF",$j,userRowId,prtDate,"ZCHY"))+payOrShare
  .......e  i $p(^DHCTarC("TOC",trorcRowid),"^",2)="西药" d  s ^TMP("OPJF",$j,userRowId,prtDate,"XYF")=+$g(^TMP("OPJF",$j,userRowId,prtDate,"XYF"))+payOrShare
  .......e  i $p(^DHCTarC("TOC",trorcRowid),"^",2)="手术费" d  s ^TMP("OPJF",$j,userRowId,prtDate,"SSF")=+$g(^TMP("OPJF",$j,userRowId,prtDate,"SSF"))+payOrShare
  .......e  i $p(^DHCTarC("TOC",trorcRowid),"^",2)="化验费" d  s ^TMP("OPJF",$j,userRowId,prtDate,"HYF")=+$g(^TMP("OPJF",$j,userRowId,prtDate,"HYF"))+payOrShare
  .......e  i $p(^DHCTarC("TOC",trorcRowid),"^",2)="检查费" d  s ^TMP("OPJF",$j,userRowId,prtDate,"JCF")=+$g(^TMP("OPJF",$j,userRowId,prtDate,"JCF"))+payOrShare
  .......e  i $p(^DHCTarC("TOC",trorcRowid),"^",2)="治疗费" d  s ^TMP("OPJF",$j,userRowId,prtDate,"ZLF")=+$g(^TMP("OPJF",$j,userRowId,prtDate,"ZLF"))+payOrShare
  .......e  i $p(^DHCTarC("TOC",trorcRowid),"^",2)="血透费" d  s ^TMP("OPJF",$j,userRowId,prtDate,"SXF")=+$g(^TMP("OPJF",$j,userRowId,prtDate,"SXF"))+payOrShare
  .......e  i $p(^DHCTarC("TOC",trorcRowid),"^",2)="输氧费" d  s ^TMP("OPJF",$j,userRowId,prtDate,"SYF")=+$g(^TMP("OPJF",$j,userRowId,prtDate,"SYF"))+payOrShare
  .......e  i $p(^DHCTarC("TOC",trorcRowid),"^",2)="X光费"  d  s ^TMP("OPJF",$j,userRowId,prtDate,"XGF")=+$g(^TMP("OPJF",$j,userRowId,prtDate,"XGF"))+payOrShare
  .......e  d  s ^TMP("OPJF",$j,userRowId,prtDate,"QT")=+$g(^TMP("OPJF",$j,userRowId,prtDate,"QT"))+payOrShare
 
  
  s userRowId=0,prtDate=0
  s num=0
  s sumZCY=0,sumZCHY=0,sumXYF=0,sumSSF=0,sumHYF=0,sumJCF=0,sumZLF=0,sumSXF=0,sumSYF=0,sumXGF=0,sumQT=0,sumHJ=0
  f  s userRowId=$o(^TMP("OPJF",$j,userRowId)) q:userRowId=""  d
  .s DATE="",NAME="",XJZCY=0,XJZCHY=0,XJXYF=0,XJSSF=0,XJHYF=0,XJJCF=0,XJZLF=0,XJSXF=0,XJSYF=0,XJXGF=0,XJQT=0,XJHJ=0
  .s ZCYAll=0,ZCHYAll=0,XYFAll=0,SSFAll=0,HYFAll=0,JCFAll=0,ZLFAll=0,SXFAll=0,SYFAll=0,XGFAll=0,QTAll=0,HJAll=0
  .f  s prtDate=$o(^TMP("OPJF",$j,userRowId,prtDate)) q:prtDate=""  d
  ..s DATE=##class(websys.Conversions).DateLogicalToHtml(prtDate)
  ..s NAME=$p(^PAPER(userRowId,"ALL"),"^",1)
  ..s ZCYAll=+$g(^TMP("OPJF",$j,userRowId,prtDate,"ZCY"))
  ..s ZCHYAll=+$g(^TMP("OPJF",$j,userRowId,prtDate,"ZCHY"))
  ..s XYFAll=+$g(^TMP("OPJF",$j,userRowId,prtDate,"XYF"))
  ..s SSFAll=+$g(^TMP("OPJF",$j,userRowId,prtDate,"SSF"))
  ..s HYFAll=+$g(^TMP("OPJF",$j,userRowId,prtDate,"HYF"))
  ..s JCFAll=+$g(^TMP("OPJF",$j,userRowId,prtDate,"JCF"))
  ..s ZLFAll=+$g(^TMP("OPJF",$j,userRowId,prtDate,"ZLF"))
  ..s SXFAll=+$g(^TMP("OPJF",$j,userRowId,prtDate,"SXF"))
  ..s SYFAll=+$g(^TMP("OPJF",$j,userRowId,prtDate,"SYF"))
  ..s XGFAll=+$g(^TMP("OPJF",$j,userRowId,prtDate,"XGF"))
  ..s QTAll=+$g(^TMP("OPJF",$j,userRowId,prtDate,"QT"))
  ..s HJAll=ZCYAll+ZCHYAll+XYFAll+SSFAll+HYFAll+JCFAll+ZLFAll+SXFAll+SYFAll+XGFAll+QTAll
  ..do OutPut
  ..s XJZCY=XJZCY+ZCYAll
  ..s XJZCHY=XJZCHY+ZCHYAll
  ..s XJXYF=XJXYF+XYFAll
  ..s XJSSF=XJSSF+SSFAll
  ..s XJHYF=XJHYF+HYFAll
  ..s XJJCF=XJJCF+JCFAll
  ..s XJZLF=XJZLF+ZLFAll
  ..s XJSXF=XJSXF+SXFAll
  ..s XJSYF=XJSYF+SYFAll
  ..s XJXGF=XJXGF+XGFAll
  ..s XJQT=XJQT+QTAll
  ..s XJHJ=XJHJ+HJAll
  ..s prtDateT=$o(^TMP("OPJF",$j,userRowId,prtDate))
  ..i prtDateT="" d
  ...do OutPut1
  ...s sumZCY=sumZCY+XJZCY
  ...s sumZCHY=sumZCHY+XJZCHY
  ...s sumXYF=sumXYF+XJXYF
  ...s sumSSF=sumSSF+XJSSF
  ...s sumHYF=sumHYF+XJHYF
  ...s sumJCF=sumJCF+XJJCF
  ...s sumZLF=sumZLF+XJZLF
  ...s sumSXF=sumSXF+XJSXF
  ...s sumSYF=sumSYF+XJSYF
  ...s sumXGF=sumXGF+XJXGF
  ...s sumQT=sumQT+XJQT
  ...s sumHJ=sumHJ+XJHJ
  d OutPut2 
  
  S qHandle=$lb(0,repid,0)
  Q $$$OK
OutPut
    s ^TMP("OPJFLINE",$J,ind)=DATE_"^"_NAME_"^"_ZCYAll_"^"_ZCHYAll_"^"_XYFAll_"^"_SSFAll_"^"_HYFAll_"^"_JCFAll_"^"_ZLFAll_"^"_SXFAll_"^"_SYFAll_"^"_XGFAll_"^"_QTAll_"^"_HJAll
    s Data=$lb(DATE,NAME,ZCYAll,ZCHYAll,XYFAll,SSFAll,HYFAll,JCFAll,ZLFAll,SXFAll,SYFAll,XGFAll,QTAll,HJAll,$j)
 	S ^CacheTemp(repid,ind)=Data
 	S ind=ind+1
	q
OutPut1
    s ^TMP("OPJFLINE",$J,ind)=""_"^"_"小计"_"^"_XJZCY_"^"_XJZCHY_"^"_XJXYF_"^"_XJSSF_"^"_XJHYF_"^"_XJJCF_"^"_XJZLF_"^"_XJSXF_"^"_XJSYF_"^"_XJXGF_"^"_XJQT_"^"_XJHJ
    s Data=$lb("","小计",XJZCY,XJZCHY,XJXYF,XJSSF,XJHYF,XJJCF,XJZLF,XJSXF,XJSYF,XJXGF,XJQT,XJHJ,$j)
 	S ^CacheTemp(repid,ind)=Data
 	S ind=ind+1
	q
OutPut2	
    s ^TMP("OPJFLINE",$J,ind)=""_"^"_"合计"_"^"_sumZCY_"^"_sumZCHY_"^"_sumXYF_"^"_sumSSF_"^"_sumHYF_"^"_sumJCF_"^"_sumZLF_"^"_sumSXF_"^"_sumSYF_"^"_sumXGF_"^"_sumQT_"^"_sumHJ
    s Data=$lb("","合计",sumZCY,sumZCHY,sumXYF,sumSSF,sumHYF,sumJCF,sumZLF,sumSXF,sumSYF,sumXGF,sumQT,sumHJ,$j)
 	S ^CacheTemp(repid,ind)=Data
 	S ind=ind+1
	q
}

ClassMethod FindInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInfoExecute ]
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

ClassMethod FindInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：         王刚
/// CreatDate：       2008.10.16
/// Description：     得到行数
/// Input：           Job进程号
ClassMethod GetNum(itmjs As %Library.String = "", itmjsex As %Library.String = "", job)
{
 s job=$g(job)
 s num=$o(^TMP("OPJFLINE",job,""),-1)
 q num
}

/// Creator：         王刚
/// CreatDate：       2008.10.16
/// Description：     得到某个病人的预交金Query的每行的记录
/// Input：           Job进程号
/// Output，Return：  得到一行的记录^TMP("ZYJF",$j,ind)=rcptno_"^"_prtdate_"^"_prttime_"^"_payamt_"^"_paymode_"^"_prtstatus_"^"_rcptdr_"^"_arpbl_"^"_adduser_"^"_cardno_"^"_company_"^"_bank_"^"_Adm_"^"_rowid_"^"_jkflag_"^"_select_"^"_paystatus_"^"_deposittype
ClassMethod List(itmjs As %Library.String = "", itmjsex As %Library.String = "", job, num)
{
 s str=^TMP("OPJFLINE",job,num)
 q str
}

/// Creator：         王刚
/// CreatDate：       2008.10.16
/// Description：     Kill ^TMP("ZYJF",$j)
ClassMethod KillTmp(job)
{
  k ^TMP("OPJFLINE",job)
}

}
