/// Description:门诊草药处方审方查询相关
/// Creator:    hulihua
/// CreateDate: 2018-12-14
/// Table:      
Class web.DHCOUTPHA.HMPrescPhaAudit.PrescPhaAuditQuery Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", ProcedureBlock ]
{

/// Description:获取门诊审方界面的相关显示数据
/// Creator:	hulihua
/// CreateDate:	2018-12-14
/// Table:      OE_OrdItem
/// Input:		就诊ID、处方号、插入人ID、药房ID
/// Output:	    
/// Return：	 
/// Others:     
/// Debug:		w ##class(web.DHCOUTPHA.HMPrescPhaAudit.PrescPhaAuditQuery).jsGetAdmPrescList("1","50","14/01/2019^16/01/2019^310^^")
ClassMethod jsGetAdmPrescList(page, rows, params) As %String
{
	s ^hlh($h)=$lb(page, rows, params)
	Q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
 	S EnPage=page*rows  //结束行
	S StPage=((page-1)*rows)+1 //开始行
	s DataDelim=##class(web.DHCINPHA.MTCommon.PublicCallMethod).RowDataDelim()
 	S StDate=$P(params,DataDelim,1)
 	S Endate=$P(params,DataDelim,2)
 	S Phalocdr=$P(params,DataDelim,3)
 	S PatNoInput=$P(params,DataDelim,4)
 	S OnlyAdt=$P(params,DataDelim,5) //已审标志
 	S StDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StDate)
	S EnDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(Endate)
	S pid=##class(web.DHCOUTPHA.Common.CommonUtil).NewPid($this)
	D ##class(web.DHCOUTPHA.Common.CommonUtil).ClearTmp($this,"jsGetAdmPrescList",pid)
	S h=0
	//获取未审处方
	I OnlyAdt'="Y" D
	.I PatNoInput'=""  D
	..S papmidr=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatNoInput),""),-1)
	..Q:papmidr=""
	..S admtype=""
	..F  S admtype=$o(^PAPERdr(papmidr,"ADM",admtype)) Q:admtype=""  D 
	...Q:admtype="I" 					;过滤住院
	...S adm="",exit=""
	...F  S adm=$o(^PAPERdr(papmidr,"ADM",admtype,adm),-1) Q:(adm="")||(exit="1")  D 
	....S admdate=$p(^PAADM(adm),"^",6) ;就诊日期
	....Q:admdate>EnDate
	....I admdate<StDate S exit="1" Q   ;就诊日期小于查询起始日期,不在遍历
	....F date=StDate:1:EnDate  D
	.....D GetOutPutData
	.E  D
	..F date=StDate:1:EnDate  D
    ...S typestr="O^E"
    ...S typecnt=$l(typestr,"^")
    ...F n=1:1:typecnt D
    ....S type=$p(typestr,"^",n)
    ....S adm=""
    ....F  S adm=$o(^PAADMi("NNType",type,date,adm)) Q:adm=""  D
    .....D GetOutPutData
    ....
    ...
    ..
    .
    //获取已审处方
    E  D
    .I PatNoInput="" D
    ..F Date=EnDate:-1:StDate D
    ...s phaomId=""
	...f  s phaomId=$o(^DHCPHORDM(0,"DateLoc",Date,Phalocdr,phaomId),-1) q:phaomId=""  d
	....s appType=$p(^DHCPHORDM(phaomId),"^",9)
	....q:appType'="OA"
	....s phaomCh=$o(^DHCPHORDM(phaomId,"I",""))
	....S prescNo=$p(^DHCPHORDM(phaomId,"I",phaomCh),"^",4)
	....Q:prescNo=""
	....s queId=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).PrescCYQueId(prescNo)
 	....q:queId=""							;非草药处方
	....s ord=$o(^OEORD(0,"PrescNo",prescNo,""),-1)
	....q:ord=""
	....s adm=$p(^OEORD(ord),"^",1) 
	....D GetOutPutData
	...
	..
	.E  D
	..S papmiDr=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatNoInput),""),-1)
	..Q:papmiDr=""
	..S admType=""
	..F  S admType=$o(^PAPERdr(papmiDr,"ADM",admType)) Q:admType=""  D 
	...Q:admType="I" 					;过滤住院
	...S adm=""
	...F  S adm=$o(^PAPERdr(papmiDr,"ADM",admType,adm),-1) Q:adm=""  D 
	....s phaomId=""
	....f  s phaomId=$o(^DHCPHORDM(0,"Adm",adm,phaomId),-1) q:phaomId=""  d
	.....s appType=$p(^DHCPHORDM(phaomId),"^",9)
	.....q:appType'="OA"
	.....s phaoLocId=$p(^DHCPHORDM(phaomId),"^",5)
	.....q:phaoLocId'=Phalocdr
	.....s phaomDate=$p(^DHCPHORDM(phaomId),"^",3)
	.....q:(phaomDate<StDate)||(phaomDate>EnDate)
	.....D GetOutPutData
	.
	.
    // .输出Json数据
	S countrecords=h
    Q:countrecords="0" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
    I EnPage>countrecords Set EnPage=countrecords
	S ColNameStr1="TPatLoc^TPrescNo^TAdm^TOeori^TAuditResult"
	S ColNameStr2="TDspStatus^TPrescType^TBillType^TEmergFlag^TPmiNo"
	S ColNameStr3="TPatName^TMR^TPatSex^TPatAge^TCookType"
	S ColNameStr4="TFactor^TPapmi^TPrescConfigId^TDocNote^TRefResult"
	S ColNameStr5="TMBDiagnos"
	S ColNameStr=ColNameStr1_"^"_ColNameStr2_"^"_ColNameStr3_"^"_ColNameStr4_"^"_ColNameStr5
 	S H="",Count=0
 	F  S H=$O(^TMP("DHCOUTPHA",$this,"jsGetAdmPrescList",pid,"PRESCNOLIST",H))  Q:H=""  D
	.S OutPutData=^TMP("DHCOUTPHA",$this,"jsGetAdmPrescList",pid,"PRESCNOLIST",H)	
	.S Count=Count+1
	.Q:(Count<StPage)||(Count>EnPage)
    .I Count=StPage D
	..W ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonStartStringJqGrid(countrecords,rows)
	..W ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(ColNameStr,OutPutData)
	.E  D
	..W ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(ColNameStr,OutPutData)
	.I Count=EnPage Write ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign()
	D ##class(web.DHCOUTPHA.Common.CommonUtil).ClearTmp($this,"jsGetAdmPrescList",pid)
	Q ""
GetOutPutData
    S ord=$o(^OEORD(0,"Adm",adm,"")) 
	Q:ord=""	 
    S Papmi=$p(^PAADM(adm),"^",1)
    S chl="" 		//完全按照就诊日期
    F  S chl=$o(^OEORD(ord,"I",chl)) Q:chl=""  D
	.Q:+chl=0
	.S oeori=ord_"||"_chl
	.Q:'$d(^OEORD(ord,"I",chl,3))
	.S reclocdr=$p(^OEORD(ord,"I",chl,3),"^",6)
	.Q:reclocdr'=Phalocdr
	.Q:'$d(^DHCOEDISQTY(0,"OEORI",oeori))
	.S dsprowid=$o(^DHCOEDISQTY(0,"OEORI",oeori,""),-1)
	.Q:dsprowid=""
	.S prescNo=$p(^OEORD(ord,"I",chl,1),"^",14) 
	.Q:prescNo=""
	.Q:$d(^TMP("DHCOUTPHA",$this,"jsGetAdmPrescList",pid,"PRESCNO",prescNo))
	.S queId=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).PrescCYQueId(prescNo)
 	.Q:queId=""
	.S dspstatus=$p(^DHCOEDISQTY(dsprowid),"^",7)
	.S result=##class(web.DHCSTCNTSCOMMON).CheckPrescNoStatus(prescNo,"OA")
	.//1拒绝  2申诉  3通过  0未审
    .Q:(OnlyAdt="Y")&((result=0)||(result=2))
    .Q:(OnlyAdt'="Y")&((result=3)||(result=1)||(result=4))
    .S statdr=$p(^OEORD(ord,"I",chl,1),"^",13)
	.S oeflag=$p(^OEC("OSTAT",statdr),"^",1) 
	.S payflag=$p(^OEORD(ord,"I",chl,3),"^",5) 
	.Q:(OnlyAdt'="Y")&&(payflag'="P")&&(oeflag'="V")&&(oeflag'="E") //yunhaibao20160303,未处方审核且未交费且停医嘱的不显示
	.S priordr=+$p(^OEORD(ord,"I",chl,1),"^",8) 
    .Q:priordr=0 
    .S priority=$p(^OECPR(priordr),"^",1) 			;医嘱优先级代码              
    .Q:priority["OM" ;自备药
    .S patInfo=##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).GetPatInfo(adm)
	.S PatNo=$P(patInfo,"^",1)
	.Q:(PatNoInput'="")&&(PatNoInput'=PatNo)
	.S PatName=$P(patInfo,"^",3)
	.S Diagnodesc=$P(patInfo,"^",9)
	.S Sex=$P(patInfo,"^",4)
	.S Age=$P(patInfo,"^",5)
	.S prescStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPaQueInfo(prescNo)
	.S Factor=$p(prescStr,"^",2)
	.S JYType=$p(prescStr,"^",7)
	.S PrescForm=$p(prescStr,"^",8)
	.S EmergFlag=$p(prescStr,"^",18)
	.S PrescConfigId=$p(prescStr,"^",22)
	.s preOrdStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPreOrdInfo(prescNo)
	.S deplocdesc=$p(preOrdStr,"^",1)
	.I deplocdesc["-" S deplocdesc=$p(deplocdesc,"-",2)
	.S BillType=##class(web.DHCOutPhCommon).GetPrescType(prescNo)
	.S MBDiagnos=##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetPrescMBDiagnos(prescNo)
	.S AusitResult=##class(web.DHCSTCNTSCOMMON).GetCurPhoResultByPresc(prescNo,"OA")
	.S DocNote="",RefResult=""
	.I AusitResult="申诉" D
	..S DocNote=##class(web.DHCSTCNTSCOMMON).GetOrdAppealReasonByPresc(prescNo,"OA")
	..S RefResult=##class(web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery).GetRefReasonByPresc(prescNo,"OA")
	.I AusitResult="拒绝" D
	..S RefResult=##class(web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery).GetRefReasonByPresc(prescNo,"OA")

	.S Data1=deplocdesc_"^"_prescNo_"^"_adm_"^"_oeori_"^"_AusitResult
	.S Data2=dspstatus_"^"_$G(PrescForm)_"^"_BillType_"^"_EmergFlag_"^"_PatNo
	.S Data3=PatName_"^"_Diagnodesc_"^"_Sex_"^"_Age_"^"_JYType
	.S Data4=Factor_"^"_Papmi_"^"_PrescConfigId_"^"_DocNote_"^"_RefResult
	.S Data5=MBDiagnos
	.S h=h+1
	.S ^TMP("DHCOUTPHA",$this,"jsGetAdmPrescList",pid,"PRESCNO",prescNo)=""
	.S ^TMP("DHCOUTPHA",$this,"jsGetAdmPrescList",pid,"PRESCNOLIST",h)=Data1_"^"_Data2_"^"_Data3_"^"_Data4_"^"_Data5
	Q
}

Storage Default
{
<Data name="PrescPhaAuditQueryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCOUTE912.PrescPhaAud129AD</DataLocation>
<DefaultData>PrescPhaAuditQueryDefaultData</DefaultData>
<IdLocation>^web.DHCOUTE912.PrescPhaAud129AD</IdLocation>
<IndexLocation>^web.DHCOUTE912.PrescPhaAud129AI</IndexLocation>
<StreamLocation>^web.DHCOUTE912.PrescPhaAud129AS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
