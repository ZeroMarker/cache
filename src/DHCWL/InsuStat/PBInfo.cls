Class DHCWL.InsuStat.PBInfo Extends %RegisteredObject
{

/// 账单id
Property PBId As %String;

/// 就诊id
Property AdmId As %String;

/// 入院日期
Property AdmDATE As %Date;

/// 出院日期
Property DisDate As %Date;

/// 住院天数
Property InHosDays As %Integer;

/// 姓名
Property Name As %String;

/// 年龄
Property Age As %String;

/// 科室Id
Property DeptId As %String;

/// 科室
Property Dept As %String;

/// 住院病区Id
Property WardId As %String;

/// 住院病区
Property Ward As %String;

/// 病案号
Property MedNo As %String;

/// 病人登记号
Property PatNo As %String;

/// 人员类别
Property PatType As %String;

/// 医保类别Id
Property InsuTypeId As %String;

/// 医保类别
Property InsuType As %String;

/// 医保接口标志
Property NationCode As %String;

/// 医生
Property Doctor As %String;

/// 出院诊断
Property OutDiagDesc As %String;

/// 医保病种Id
Property InsudiaId As %String;

/// 医保病种
Property Insudiadesc As %String;

/// 医保病种细类
Property InsudiaFl As %String;

/// 病种差价
Property DiagCj As %String;

/// 分类总费用
Property TotalFee As %ArrayOfDataTypes;

/// 分类自付费用
Property PatFee As %ArrayOfDataTypes;

/// 分类医保费用
Property InsuFee As %ArrayOfDataTypes;

/// 总费用
Property PBFee As %Float;

/// 审核员
Property Shy As %String;

/// 结算状态
Property InsuStatus As %String;

/// 汇总医保总费用
Property TotalFeeYb As %Float;

/// 汇总医保支付费用
Property InsuFeeYb As %Float;

Method %OnNew(pbId As %String) As %Status
{
	s ..PBId=pbId
	s admId=$p(^DHCPB(pbId),"^",1)
	s admrea=$p(^PAADM(admId,1),"^",7)
	s ..AdmId=admId
	;s outStrInsu=##class(web.DHCINSUPort).GetDivideByPBDrToTJ(pbId,admrea)
	s outStrInsu=..GetDivideByPBDrToTJ(pbId,admrea)
    s ..TotalFeeYb=$p(outStrInsu,"|",15)
    s ..InsuFeeYb=$p(outStrInsu,"|",5)
	s ..DiagCj=$p(outStrInsu,"|",9)
	s DicInfo=$p(outStrInsu,"|",12)
	s ..InsudiaId=$p(DicInfo,"^",1)
	s ..InsudiaFl=$p(DicInfo,"^",5)
	s ..Insudiadesc=$p(DicInfo,"^",4)
	s ..Shy=$p(outStrInsu,"|",13)
	s ..InsuStatus=$p(outStrInsu,"|",14)
	s ..NationCode=$p(^PAC("ADMREA",admrea),"^",5) 
	s papmi=$p(^PAADM(admId),"^",1)
	s ..PatNo=$$GetPapmiNo^DHCWLCommon(papmi)
	s ..MedNo=$$GetPapmiMedtare^DHCWLCommon(papmi)
	s ..Name=$$GetPapmiName^DHCWLCommon(papmi)
	s ..InsuTypeId=admrea
	s ..InsuType=$$GetReason^DHCWLCommon(admId)
	s Brithday=$p(^PAPER(papmi,"ALL"),"^",6)  ;生日
	s ..Age=##class(web.DHCDTHealthCommon).GetAgeDesc(Brithday,+$h)
    s dischrdoc=$p(^PAADM(admId),"^",19)
    i dischrdoc'=""  d 
    .s ..Doctor=$p(^CTPCP(dischrdoc,1),"^",2 ) 
    e  d
    .s ..Doctor=""
	s dateFrom=$p(^DHCPB(pbId),"^",6)
	s dateTo=$p(^DHCPB(pbId),"^",7)
	s admDate=$p(^PAADM(admId),"^",6)
	s disDate=$p(^PAADM(admId),"^",17)
	s inHosDays=dateTo-dateFrom+1
	i inHosDays<0 d
	.s ..InHosDays=0
	e  d
	.s ..InHosDays=disDate-admDate+1
	i disDate="" s ..DisDate=""
	e  s ..DisDate=$zd(disDate,3)
	s ..AdmDATE=$zd(admDate,3)
	s dep=$p(^PAADM(admId),"^",4)
	i dep="" s deptsc=""
	e  s deptsc=$$GetDepDesc^DHCWLCommon(dep)
	s ..DeptId=dep
	s ..Dept=deptsc
	
	s wardep=$p(^PAADM(admId),"^",70)
	s wardLocDr=$p($g(^PAWARD(+wardep)),"^",5)
	i wardep="" s wardDesc=""
	e  s wardDesc=$$GetDepDesc^DHCWLCommon(wardLocDr)
	 
	s ..WardId=wardLocDr
	s ..Ward=wardDesc
	s ..OutDiagDesc=##class(EPRservice.BOScatterData).GetEPRData(admId,"#TYPE:Segment#TID:6#TVER:0#GCODE:G0070")
        
	q 1
}

Method SetPBFeeInfo() As %Float
{
	k totalData,insuData,patData,totalFee
	s pbId=..PBId
	s admId=$p(^DHCPB(pbId),"^",1)
	s admrea=$p(^PAADM(admId,1),"^",7)
	
	s pboId=0
	f  s pboId=$o(^DHCPB(pbId,"O",pboId)) q:pboId=""  d
	.s oeori=$p(^DHCPB(pbId,"O",pboId),"^",4)
	.s pbdId=0
	.f  s pbdId=$o(^DHCPB(pbId,"O",pboId,"D",pbdId)) q:pbdId=""  d
	..s tari=$p(^DHCPB(pbId,"O",pboId,"D",pbdId),"^",3)
	..s price=$p(^DHCPB(pbId,"O",pboId,"D",pbdId),"^",7)
	..i tari="" s accSubCat=""
	..e  s accSubCat=$p(^DHCTARI(tari),"^",14)
	..;s accCat=$p($g(^DHCTarC("IC",+accSubCat)),"^",3) ;住院分类
	..s accCat=accSubCat  ;住院子分类
	..s outStr=##class(web.DHCINSUPort).TarItmLinkInsu(tari,admrea,oeori,admId,"")
	..s insuFlag=$p(outStr,"^",1)
	..s totalData(accCat)=$g(totalData(accCat))+price
	..i insuFlag'=3 s insuData(accCat)=$g(insuData(accCat))+price
	..e  s patData(accCat)=$g(patData(accCat))+price
	..s totalFee=$g(totalFee)+price
	s ..TotalFee=##class(%ArrayOfDataTypes).%New()
	s ..PatFee=##class(%ArrayOfDataTypes).%New()
	s ..InsuFee=##class(%ArrayOfDataTypes).%New()

	d SetArrData(..TotalFee,.totalData)
	d SetArrData(..PatFee,.patData)
	d SetArrData(..InsuFee,.insuData)
	s ..PBFee=$g(totalFee)
	
	q $g(totalFee)

SetArrData(arr,data)
	s accCat=0
	f  s accCat=$o(data(accCat)) q:accCat=""  d
	.d arr.SetAt(+$g(data(accCat)),accCat)
	
	q 1
}

ClassMethod test(pbId) As %Status
{
	//w ##class(DHCWL.InsuStat.PBInfo).test("205917")
	;s pbId=204366
	s obj=..%New(pbId)
	s obj.PBId=pbId
	d obj.SetPBFeeInfo()
	w "TotalFee:",!
	s key=""
	FOR  SET value=obj.TotalFee.GetNext(.key) QUIT:key=""  WRITE key,":",value,!
	w "PatFee",!
	s key=""
	FOR  SET value=obj.PatFee.GetNext(.key) QUIT:key=""  WRITE key,":",value,!
	w "InsuFee",!
	s key=""
	FOR  SET value=obj.InsuFee.GetNext(.key) QUIT:key=""  WRITE key,":",value,!
	s obj=""
	q 1
}

/// Creator: liusf
/// Description:根据帐单号提取统计组所需要的数据
/// Input：BillNo,AdmReaDr
/// Others: w ##class(DHCWL.InsuStat.PBInfo).GetDivideByPBDrToTJ("5664328","")
/// Flag|DivdieRowid|现金支付|BillRowID |医保基金支付金额|个人帐户支付金额|大额支付|医保差价|病种差价|单病种生育标志|病种代码|字典信息|审核人
/// 字典信息是字符串  分割符为"^"  第四位为: 医保病种细类   第五位为:医保病种
ClassMethod GetDivideByPBDrToTJ(PBDr As %String, AdmReaDr As %String) As %String
{
	;n (PBDr,AdmReaDr)
	s ^HH("000")=PBDr_"!"_AdmReaDr
	s INSUDivStr="",Out="-1"
	s INSUDivStr=##class(web.DHCINSUDivideCtl).GetByBill(PBDr)
	s Flag=$p(INSUDivStr,"!",1)
	s DivStr=$p(INSUDivStr,"!",2)
    i Flag'="1" s Out="-1" 
	e  d
	.s INSUDr=$p(DivStr,"^",1)
	.s INPAYAdmDr=$p(DivStr,"^",2)
	.s InPAYStatus=$p(DivStr,"^",6) ;结算状态
	.s INPAYbcbxf0=$p(DivStr,"^",8)  ;总金额
	.s INPAYgrzfe0=$p(DivStr,"^",16)  ;现金
	.s INPAYjjzfe0=$p(DivStr,"^",20)   ;医保负担
	.s INPAYzhzfe0=$p(DivStr,"^",29)   ;个人帐户
	.s INPAYZstr06=$p(DivStr,"^",47)   ;医保差价
	.s INPAYZstr11=$p(DivStr,"^",52) 	;病种差价
	.s:INPAYZstr11="" INPAYZstr11=0
	.s INPAYZstr16=$p(DivStr,"^",57)  ;生育/单病种标志
	.s INPAYZstr17=$p(DivStr,"^",58)  ;生育或者病种代码
	.s AuditDr=$o(^DHCINAUD("0","PBDr",PBDr,""),-1)
	.s AuditName=""
	.s:AuditDr'="" AuditName=$p(^DHCINAUD(AuditDr),"^",13)
	.s DicInfo=$$QueryByCode^DHCINSUDicData(INPAYZstr16,INPAYZstr17)
	.;             INSUDr     个人支付                    医保负担        账户支付          现金             病种差价     单病种生育标志    
	.s Out="0"_"|"_INSUDr_"|"_INPAYgrzfe0_"|"_PBDr_"|"_INPAYjjzfe0_"|"_INPAYzhzfe0_"|0|"_INPAYZstr06_"|"_INPAYZstr11_"|"_INPAYZstr16_"|"_INPAYZstr17_"|"_DicInfo_"|"_AuditName_"|"_InPAYStatus_"|"_INPAYbcbxf0
	q Out
}

}
