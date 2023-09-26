Class web.DHCENS.STBLL.DRUG.METHOD.OPDrugOrdInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// Description：发送HIS中药品医嘱信息
/// Table：DHC_PHDISPEN
/// Input：药品发药表ROWID
/// Return：0^成功  
/// Others：w ##class(web.DHCENS.STBLL.DRUG.METHOD.OPDrugOrdInfo).DispenseOPDrugInfo("2060||3^2060||4^2060||5@3673")
/// Others：w ##class(web.DHCENS.STBLL.DRUG.METHOD.OPDrugOrdInfo).DispenseOPDrugInfo("1216||6").OutputToDevice()
ClassMethod DispenseOPDrugInfo(Input As %String) As %GlobalCharacterStream
{
	set $zt="SendMessageET"
	set request=##class(web.DHCENS.STBLL.DRUG.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.DRUG.MODEL.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set request.header=header
	set success="0"
	set body=##class(web.DHCENS.STBLL.DRUG.MODEL.Body).%New()
	// 发票号
	set Invoice=..GetInvprtByOeordRowID(Input)
	// 医嘱ROWID
	set OrdRowIds=$p(Input,"@",1)
	;根据医嘱号得到处方号，返回值进程号
	set pid=..GetPrescNoByOEORIRowId(OrdRowIds)
	s tmpPrescNo=""  f  s tmpPrescNo=$o(^TMP("DHCENS","SendPrescNo",pid,tmpPrescNo)) q:tmpPrescNo=""  d
	.s PrescNoStr=$g(^TMP("DHCENS","SendPrescNo",pid,tmpPrescNo))
	.;调用药房组方法取出门诊发药主表相关信息，返回值：患者信息!!医嘱信息1@医嘱信息2
	.set DrugOrdStr=##class(web.DHCSTInterfacePH).GetPrescInfoByOrd(PrescNoStr,Invoice)
	.if (DrugOrdStr'="")  d
	..set MainObj=$p(DrugOrdStr,"!!",1)
	..set DetailObj=$p(DrugOrdStr,"!!",2)
	..set Length=$L(DetailObj,"@")
	..f i=1:1:Length  d      //web.DHCENS.STBLL.DRUG.MODEL.OPDrugOrdInfo
	...set DrugOrdInfo=##class(web.DHCENS.STBLL.DRUG.MODEL.OPDrugOrdInfo).%New()
	...set TmpStr=$P(DetailObj,"@",i)
	...set DrugOrdInfo.PatId=$P(MainObj,"^",1)
	...set DrugOrdInfo.Name=$P(MainObj,"^",2)
	...set DrugOrdInfo.Age=+$P(MainObj,"^",3)
	...set DrugOrdInfo.Sex=$P(MainObj,"^",4)
	...set DrugOrdInfo.DiagnoDesc=$P(MainObj,"^",5)
	...set DrugOrdInfo.PatHeight=$P(MainObj,"^",6)
	...set DrugOrdInfo.PName=$P(MainObj,"^",7)
	...set DrugOrdInfo.FName=$P(MainObj,"^",8)
	...set DrugOrdInfo.PDateTime=$P(MainObj,"^",9)
	...set DrugOrdInfo.FDateTime=$P(MainObj,"^",33)
	...set DrugOrdInfo.DateTime=$P(MainObj,"^",11)	
	...set DrugOrdInfo.RecCtLoc=$P(MainObj,"^",12)
	...set DrugOrdInfo.PatCompany=$P(MainObj,"^",13)
	...set DrugOrdInfo.AdmDateTime=$P(MainObj,"^",14)	
	...set DrugOrdInfo.AdmCardNo=$P(MainObj,"^",15)
	...set DrugOrdInfo.PrescNo=$P(MainObj,"^",16)
	...set DrugOrdInfo.AdmCtLoc=$P(MainObj,"^",17)
	...set DrugOrdInfo.AdmCtLocCode=$P(MainObj,"^",35)
	...set DrugOrdInfo.WindowNo=$P(MainObj,"^",38)
	...set DrugOrdInfo.TelePhone=$P(MainObj,"^",19)
	...set DrugOrdInfo.Address=$P(MainObj,"^",20)
	...set DrugOrdInfo.PrescMake=$P(MainObj,"^",21)
	...set DrugOrdInfo.PrescNum=$P(MainObj,"^",22)
	...set DrugOrdInfo.PrescType=$P(MainObj,"^",23)
	...set DrugOrdInfo.DocCtLoc=$P(MainObj,"^",24)
	...set DrugOrdInfo.Doctor=$P(MainObj,"^",25)		
	...set DrugOrdInfo.HerbPrescMake=$P(MainObj,"^",26)
	...set DrugOrdInfo.HerbPrescNum=$P(MainObj,"^",27)	
	...set DrugOrdInfo.HerbPrescStartDate=$P(MainObj,"^",28)
	...set DrugOrdInfo.HerbPrescStopDate=$P(MainObj,"^",29)
	...set DrugOrdInfo.PrescNote=$P(MainObj,"^",30)
	...set DrugOrdInfo.OrdDateTime=$P(MainObj,"^",31)		
	...set DrugOrdInfo.BalanceDateTime=$P(MainObj,"^",32)
	...set DrugOrdInfo.DrugCode=$P(TmpStr,"^",14)
	...set DrugOrdInfo.DrugName=$P(TmpStr,"^",1)
	...set DrugOrdInfo.Qty=$P(TmpStr,"^",16) ;$P(TmpStr,"^",2)
	...set DrugOrdInfo.Unit=$P(TmpStr,"^",3)
	...set DrugOrdInfo.Dosage=$P(TmpStr,"^",4)
	...set DrugOrdInfo.DosageUnit=$P(TmpStr,"^",18)
	...set DrugOrdInfo.Common=$P(TmpStr,"^",5)
	...set DrugOrdInfo.Freq=$P(TmpStr,"^",6)
	...set DrugOrdInfo.Phdur=$P(TmpStr,"^",7)
	...set DrugOrdInfo.Price=$P(TmpStr,"^",8)
	...set DrugOrdInfo.TotalPrice=$P(TmpStr,"^",9)
	...set DrugOrdInfo.Skintest=$P(TmpStr,"^",10)
	...set DrugOrdInfo.OrdreMark=$P(TmpStr,"^",11)
	...set DrugOrdInfo.Specinst=$P(TmpStr,"^",12)
	...set DrugOrdInfo.Manuactory=$P(TmpStr,"^",16)
	...set DrugOrdInfo.Specification=$P(TmpStr,"^",15)
	...set DrugOrdInfo.quotiety=$P(TmpStr,"^",19) 
	...set DrugOrdInfo.Invoice=$P(TmpStr,"^",17)
	...d body.OPDrugOrds.Insert(DrugOrdInfo)
	s request.body=body
	d request.XMLExportToStream(.RetStr)
	k ^TMP("DHCENS","SendPrescNo",pid)
	q RetStr
		
SendMessageET
  	k ^TMP("DHCENS","SendPrescNo",$j)
  	s stream=##class(%GlobalCharacterStream).%New()
  	d stream.Write("-1^程序异常"_$ze)
  	q stream
}

/// Creator：WuXianPu
/// CreatDate：2012—03-06
/// Description：根据医嘱ROWID得到处方号
/// Table：Oe_orditem
/// Input：患者医嘱号
/// Return：0^处方号
/// Others：w ##class(web.DHCENS.BLL.Drug.Method.OPDrugOrdInfo).GetPrescNoByOEORIRowId(""1482||12^1482||13^1482||14^@2858")
ClassMethod GetPrescNoByOEORIRowId(Input As %String) As %String
{
	set $zt="GetErrMsg"
	k ^TMP("DHCENS","SendPrescNo",$j)
	q:Input="" ""
	set Length=$L(Input,"^")
	set i=0
	for i=1:1:Length
	{
		set OEORIRowId=$P(Input,"^",i)
		continue:OEORIRowId=""
		set tmpFirst=$P(OEORIRowId,"||",1)
		set Childsub=$P(OEORIRowId,"||",2)
		set PrescNo=$P($g(^OEORD(tmpFirst,"I",Childsub,1)),"^",14)
		s:PrescNo'="" ^TMP("DHCENS","SendPrescNo",$j,PrescNo)=PrescNo
	}
	q $j
GetErrMsg
	b ;b1
	q "-1^"_$ze
}

/// w ##class(web.DHCENS.BLL.Drug.Method.OPDrugOrdInfo).GetStr("2347665||4^2347665||5^2347665||6^")
ClassMethod GetStr(Input As %String) As %String
{
	set $zt="GetErrMsg"
	s Length=$L(Input,"^")
	s Str=$e(Input,1,Length)
	q Str
GetErrMsg
	q "-1^"_$ze
}

/// w ##class(web.DHCENS.STBLL.DRUG.METHOD.OPDrugOrdInfo).GetInvprtByOeordRowID("2060||4")
ClassMethod GetInvprtByOeordRowID(OeordRowID As %String) As %String
{
	q:OeordRowID="" ""
	s PatientBillDr=$o(^DHCPBi(0,"OEORI",$p(OeordRowID,"^",1),""),-1)
	q:PatientBillDr="" ""
	s DHCBCIDr=$o(^DHCBCI(0,"Bill",PatientBillDr,""),-1)
	q:DHCBCIDr="" ""
	s PrtDr=$p($g(^DHCBCI(DHCBCIDr)),"^")
	q PrtDr
}

}
