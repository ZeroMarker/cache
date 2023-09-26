Import SQLUser

Class DHCINSU.Adaper.BJ.AdaperINSUBJ Extends %RegisteredObject
{

/// w ##class(DHCINSU.Adaper.BJ.AdaperINSUBJ).ReadCard("","")
ClassMethod ReadCard(InputXml As %String, InputObj As DHCINSU.Model.BJ.INSUCardInfo) As %Boolean
{
	s OutStr="-1"
	//s InputXml=##class(DHCINSU.Adaper.BJ.AdapterINSUBJTestInStr).XMLToStringForPersonOutput("D:\InsuOPDividePersonInfoXml.Xml")
	s InputObj=##class(DHCINSU.Model.BJ.INSUCardInfo).%New()
	d InputObj.XMLNodeDeserialize(.InputObj, "output", InputXml)
	i InputObj.ic.icno="" d
	.d InputObj.%Close()
	//w "InputObj.ic.cardno="_InputObj.ic.cardno,!
	q:(InputObj.ic.icno="") OutStr
	q 0
}

/// w ##class(DHCINSU.Adaper.BJ.AdaperINSUBJ).InsuOPBillPre("")
ClassMethod InsuOPBillPre(InputXml As %String, InputObj As DHCINSU.Model.BJ.INSUDivideOutput) As %Boolean
{
	s OutStr="-1"
	//s InputXml=##class(DHCINSU.Adaper.BJ.AdapterINSUBJTestInStr).XMLToStringForDivideOutput("D:\InsuOPDivideDivideXml.Xml")
	s InputObj=##class(DHCINSU.Model.BJ.INSUDivideOutput).%New()
	d InputObj.XMLNodeDeserialize(.InputObj, "output", InputXml)
	i InputObj.tradeinfo.tradeno="" d
	.d InputObj.%Close()
	q:(InputObj.tradeinfo.tradeno="") OutStr
	/*
	w "tradeno="_InputObj.tradeinfo.tradeno,!
	w "feeno="_InputObj.tradeinfo.feeno,!
	w "tradedate="_InputObj.tradeinfo.tradedate,!
	w "tradeno="_InputObj.sumpay.feeall,!
	w "tradeno="_InputObj.sumpay.fund,!
	w "tradeno="_InputObj.sumpay.cash,!
	w "tradeno="_InputObj.sumpay.personcountpay,!
	w "tradeno="_InputObj.sumpay.personcount,!


	Set Lenth=InputObj.recipearray.recipe.Count()
    For i=1:1:Lenth d
	.Set recipeObj=##class(DHCINSU.Model.BJ.INSURecipe).%New()
	.Set recipeObj=InputObj.recipearray.recipe.GetAt(i)
	.w recipeObj.hissectionname,!
	
	
	s Lenth=InputObj.feeitemarray.feeitem.Count()
    f i=1:1:Lenth d
	.s Obj=##class(DHCINSU.Model.BJ.INSUFeeitem).%New()
	.s Obj=InputObj.feeitemarray.feeitem.GetAt(i)
	.w "Obj.itemname="_Obj.itemname,!
	*/
	
	q 0
}

/// w ##class(DHCINSU.Adaper.BJ.AdaperINSUBJ).InsuOPBill("","")
ClassMethod InsuOPBill(InputXml As %String, InputObj As DHCINSU.Model.BJ.INSUTradeOutput) As %Boolean
{
	s OutStr="-1"
	//s InputXml=##class(DHCINSU.Adaper.BJ.AdapterINSUBJTestInStr).XMLToStringForTradeOutput("D:\InsuOPDivideTradeXml.Xml")
	s InputObj=##class(DHCINSU.Model.BJ.INSUTradeOutput).%New()
	d InputObj.XMLNodeDeserialize(.InputObj, "output", InputXml)
	i InputObj.certid ="" d
	.d InputObj.%Close()
	q:(InputObj.certid="") OutStr

	//w "InputObj.certid="_InputObj.certid,!
	q 0
}

/// w ##class(DHCINSU.Adaper.BJ.AdaperINSUBJ).InsuOPBillStrikePre("")
ClassMethod InsuOPBillStrikePre(InputXml As %String, InputObj As DHCINSU.Model.BJ.INSUDivideOutput) As %Boolean
{
	s OutStr="-1"
	//s InputXml=##class(DHCINSU.Adaper.BJ.AdapterINSUBJTestInStr).XMLToStringForRefundmentDivideOutput("D:\RefundmentDivideOut.xml")
	s InputObj=##class(DHCINSU.Model.BJ.INSUDivideOutput).%New()
	d InputObj.XMLNodeDeserialize(.InputObj, "output", InputXml)
	
	i InputObj.tradeinfo.tradeno="" d
	.d InputObj.%Close()
	q:(InputObj.tradeinfo.tradeno="") OutStr
	
	s Lenth=InputObj.feeitemarray.feeitem.Count()
    f i=1:1:Lenth d
	.s Obj=##class(DHCINSU.Model.BJ.INSUFeeitem).%New()
	.s Obj=InputObj.feeitemarray.feeitem.GetAt(i)
	.;w "Obj.itemname="_Obj.itemname,!
	q 0
}

/// w ##class(DHCINSU.Adaper.BJ.AdaperINSUBJ).InsuOPBillStrike("","")
ClassMethod InsuOPBillStrike(InputXml As %String, InputObj As DHCINSU.Model.BJ.INSUTradeOutput) As %Boolean
{
	q ##class(DHCINSU.Adaper.BJ.AdaperINSUBJ).InsuOPBill(InputXml,.InputObj)
}

/// w ##class(DHCINSU.Adaper.BJ.AdaperINSUBJ).BuildInsuAdm("","")
ClassMethod BuildInsuAdm(UserId As %String, objINSUOPRegInfo As DHCINSU.Model.BJ.INSUOPRegInfo, objINSUCardInfo As DHCINSU.Model.BJ.INSUCardInfo, objINSUDivideOutput As DHCINSU.Model.BJ.INSUDivideOutput, objINSUTradeOutput As DHCINSU.Model.BJ.INSUTradeOutput, objINSUAdm As User.INSUAdmInfo) As %Boolean
{
	
    ;s objINSUAdm.INADMAdmDr=objPAAdm            ;	// '指向PAADM的指针
    s objINSUAdm.INADMInsuId=objINSUCardInfo.ic.icno            ;	//  '医疗保险号
    s objINSUAdm.INADMCardNo=objINSUCardInfo.ic.cardno            ;	//  '医保卡号
    s objINSUAdm.INADMPatType=   objINSUCardInfo.net.persontype        ;	//   '人员类别
    s objINSUAdm.INADMCardStatus=  objINSUCardInfo.ic.idno      ;	//      'IC卡状态
    s objINSUAdm.INADMCompany=  objINSUCardInfo.ic.personname         ;	//   '单位
    s objINSUAdm.INADMStates =   objINSUCardInfo.ic.sex        ;	//  '地区
    s objINSUAdm.INADMCenter =objINSUCardInfo.ic.birthday          ;	//  '所属分中心
    s objINSUAdm.INADMAccount=  objINSUCardInfo.net.personcount         ;	//     '个人帐户余额
    s objINSUAdm.INADMAdmSeriNo=objINSUDivideOutput.tradeinfo.tradeno        ;	//      '医保就诊流水号
    s objINSUAdm.INADMActiveFlag="A"        ;	//       '有效标志
    s objINSUAdm.INADMAdmDate=$zdh(objINSUOPRegInfo.PAADMAdmDate,3)           ;	//    '入院日期
    s objINSUAdm.INADMAdmTime=$zth(objINSUOPRegInfo.PAADMAdmTime)           ;	//    '入院时间
    s objINSUAdm.INADMAdmType=objINSUOPRegInfo.PAADMType           ;	//    '入院类别
    s objINSUAdm.INADMDeptDesc= objINSUOPRegInfo.PAADMDepCode        ;	//     '就诊科室名称
    s objINSUAdm.INADMInsuUser="PT"          ;	//     '入院登记人
    s objINSUAdm.INADMIpTimes=0          ;	//      '住院次数
    s objINSUAdm.INADMInsuType=objINSUCardInfo.ic.fundtype          ;	//    a '医保类别
    s objINSUAdm.INADMAdmCancelNo=""       ;	//        '冲销流水号
    s objINSUAdm.INADMOutDate=""           ;	//    '出院日期
    s objINSUAdm.INADMOutTime=""           ;	//    '出院时间
    s objINSUAdm.INADMOutUser=""           ;	//    '出院操作员
    s objINSUAdm.INADMUserDr=##class(User.SSUser).%OpenId(UserId)            ;	//   '操作员指针
    s objINSUAdm.INADMFunDate=$p($h,",",1)           ;	//     '操作日期
    s objINSUAdm.INADMFunTime=$p($h,",",2)           ;	//     '操作时间
    s objINSUAdm.INADMXString1=objINSUDivideOutput.sumpay.feeall          ;	//     '预留串
    s objINSUAdm.INADMXString2=objINSUDivideOutput.sumpay.cash               ;	//     '预留串
    s objINSUAdm.INADMXString3=objINSUDivideOutput.sumpay.fund          ;	//     '预留串
    s objINSUAdm.INADMXString4=objINSUDivideOutput.sumpay.personcountpay          ;	//     '预留串
    s objINSUAdm.INADMXFloat1=+objINSUDivideOutput.payinfo.mzfee           ;	//     '预留串
    s objINSUAdm.INADMXFloat2=+objINSUDivideOutput.payinfo.mzfeein           ;	//     '预留串
    s objINSUAdm.INADMXFloat3=+objINSUDivideOutput.payinfo.mzfeeout           ;	//     '预留串
    s objINSUAdm.INADMXFloat4=+objINSUDivideOutput.payinfo.mzpayfirst           ;	//     '预留串	
    s objINSUAdm.INADMXString5=objINSUDivideOutput.payinfo.mzselfpay2          ;	//     '预留串
    s objINSUAdm.INADMXString6=objINSUDivideOutput.payinfo.mzbigpay          ;	//     '预留串
    s objINSUAdm.INADMXString7=objINSUDivideOutput.payinfo.mzbigselfpay          ;	//     '预留串
    s objINSUAdm.INADMXString8=objINSUDivideOutput.payinfo.mzoutofbig          ;	//     '预留串
    s objINSUAdm.INADMXString9=objINSUDivideOutput.payinfo.bcpay          ;	//     '预留串
    s objINSUAdm.INADMXString10=objINSUDivideOutput.payinfo.jcbz         ;	//      '预留串
    s objINSUAdm.INADMXString11=objINSUDivideOutput.tradeinfo.feeno        ;	//      '预留串
    s objINSUAdm.INADMXString12=""         ;	//      '预留串
    ;s objINSUAdm.INADMXString13=""         ;	//     'add by lilizhi  2013-06-17   存储自助挂号标志   Y-自助挂号
    
    q 0
}

/// w ##class(DHCINSU.Adaper.BJ.AdaperINSUBJ).BuildInsuAdm("","")
ClassMethod BuildInsuAdmStrike(UserId As %String, objPAAdm As User.PAAdm, objINSUCardInfo As DHCINSU.Model.BJ.INSUCardInfo, objINSUDivideOutput As DHCINSU.Model.BJ.INSUDivideOutput, objINSUTradeOutput As DHCINSU.Model.BJ.INSUTradeOutput, objINSUAdmNew As User.INSUAdmInfo, objINSUAdmOLD As User.INSUAdmInfo) As %Boolean
{
	s objINSUAdmNew.INADMAdmDr=objINSUAdmOLD.INADMAdmDr        ;	// '指向PAADM的指针
    s objINSUAdmNew.INADMInsuId=objINSUAdmOLD.INADMInsuId           ;	//  '医疗保险号
    s objINSUAdmNew.INADMCardNo=objINSUAdmOLD.INADMCardNo            ;	//  '医保卡号
    s objINSUAdmNew.INADMPatType=objINSUAdmOLD.INADMPatType        ;	//   '人员类别
    s objINSUAdmNew.INADMCardStatus=objINSUAdmOLD.INADMCardStatus      ;	//      'IC卡状态
    s objINSUAdmNew.INADMCompany=objINSUAdmOLD.INADMCompany         ;	//   '单位
    s objINSUAdmNew.INADMStates =objINSUAdmOLD.INADMStates        ;	//  '地区
    s objINSUAdmNew.INADMCenter =objINSUAdmOLD.INADMCenter          ;	//  '所属分中心
    s objINSUAdmNew.INADMAccount=objINSUAdmOLD.INADMAccount         ;	//     '个人帐户余额
    s objINSUAdmNew.INADMAdmSeriNo=objINSUAdmOLD.INADMAdmSeriNo        ;	//      '医保就诊流水号
    s objINSUAdmNew.INADMActiveFlag="I"        ;	//       '有效标志
    s objINSUAdmNew.INADMAdmDate=objINSUAdmOLD.INADMAdmDate           ;	//    '入院日期
    s objINSUAdmNew.INADMAdmTime=objINSUAdmOLD.INADMAdmTime           ;	//    '入院时间
    s objINSUAdmNew.INADMAdmType=objINSUAdmOLD.INADMAdmType           ;	//    '入院类别
    s objINSUAdmNew.INADMDeptDesc=objINSUAdmOLD.INADMDeptDesc        ;	//     '就诊科室名称
    s objINSUAdmNew.INADMInsuUser=objINSUAdmOLD.INADMInsuUser          ;	//     '入院登记人
    s objINSUAdmNew.INADMIpTimes=0          ;	//      '住院次数
    s objINSUAdmNew.INADMInsuType=objINSUAdmOLD.INADMInsuType          ;	//    a '医保类别
    s objINSUAdmNew.INADMAdmCancelNo=objINSUAdmOLD.%Id()        ;	//        '冲销流水号
    s objINSUAdmNew.INADMOutDate=""           ;	//    '出院日期
    s objINSUAdmNew.INADMOutTime=""           ;	//    '出院时间
    s objINSUAdmNew.INADMOutUser=""           ;	//    '出院操作员
    s objINSUAdmNew.INADMUserDr=##class(User.SSUser).%OpenId(UserId)            ;	//   '操作员指针
    s objINSUAdmNew.INADMFunDate=$p($h,",",1)           ;	//     '操作日期
    s objINSUAdmNew.INADMFunTime=$p($h,",",2)           ;	//     '操作时间
    s objINSUAdmNew.INADMXString1=objINSUDivideOutput.sumpay.feeall          ;	//     '预留串
    s objINSUAdmNew.INADMXString2=objINSUDivideOutput.sumpay.cash               ;	//     '预留串
    s objINSUAdmNew.INADMXString3=objINSUDivideOutput.sumpay.fund          ;	//     '预留串
    s objINSUAdmNew.INADMXString4=objINSUDivideOutput.sumpay.personcountpay          ;	//     '预留串
    s objINSUAdmNew.INADMXFloat1=+objINSUDivideOutput.payinfo.mzfee           ;	//     '预留串
    s objINSUAdmNew.INADMXFloat2=+objINSUDivideOutput.payinfo.mzfeein           ;	//     '预留串
    s objINSUAdmNew.INADMXFloat3=+objINSUDivideOutput.payinfo.mzfeeout           ;	//     '预留串
    s objINSUAdmNew.INADMXFloat4=+objINSUDivideOutput.payinfo.mzpayfirst           ;	//     '预留串	
    s objINSUAdmNew.INADMXString5=objINSUDivideOutput.payinfo.mzselfpay2          ;	//     '预留串
    s objINSUAdmNew.INADMXString6=objINSUDivideOutput.payinfo.mzbigpay          ;	//     '预留串
    s objINSUAdmNew.INADMXString7=objINSUDivideOutput.payinfo.mzbigselfpay          ;	//     '预留串
    s objINSUAdmNew.INADMXString8=objINSUDivideOutput.payinfo.mzoutofbig          ;	//     '预留串
    s objINSUAdmNew.INADMXString9=objINSUDivideOutput.payinfo.bcpay          ;	//     '预留串
    s objINSUAdmNew.INADMXString10=objINSUDivideOutput.payinfo.jcbz         ;	//      '预留串
    s objINSUAdmNew.INADMXString11=objINSUDivideOutput.tradeinfo.feeno        ;	//      '预留串
    s objINSUAdmNew.INADMXString12=""         ;	//      '预留串
    //s objINSUAdmNew.INADMXString13=""         ;	//     'add by lilizhi  2013-06-17   存储自助挂号标志   Y-自助挂号
    
	q 0
}

/*
/// w ##class(DHCINSU.Adaper.BJ.AdaperINSUBJ).ObjtoDivideInfoXMLOPReg("","")
ClassMethod ObjtoDivideInfoXMLOPReg(InputXml As %String, InputObj As DHCINSU.Model.BJ.INSUDivideInput) As %Boolean
{
	
	s OutStr="-1"
	s InputXml=##class(DHCINSU.Adaper.BJ.AdapterINSUBJTestInStr).XMLToStringForDivideInput("D:\DivideIn.xml")
	w InputXml,!
	s InputObj=##class(DHCINSU.Model.BJ.INSUDivideInput).%New()
	d InputObj.XMLNodeDeserialize(.InputObj, "input", InputXml)
	
	i InputObj.tradeinfo.feeno="" d
	.d InputObj.%Close()
	q:(InputObj.tradeinfo.feeno="") OutStr
	
	w "tradeno="_InputObj.tradeinfo.tradeno,!
	w "feeno="_InputObj.tradeinfo.feeno,!
	w "tradedate="_InputObj.tradeinfo.tradedate,!

	Set Lenth=InputObj.recipearray.recipe.Count()
    For i=1:1:Lenth d
	.Set recipeObj=##class(DHCINSU.Model.BJ.INSURecipe).%New()
	.Set recipeObj=InputObj.recipearray.recipe.GetAt(i)
	.w recipeObj.hissectionname,!
	
	
	s Lenth=InputObj.feeitemarray.feeitem.Count()
    f i=1:1:Lenth d
	.s Obj=##class(DHCINSU.Model.BJ.INSUFeeitem).%New()
	.s Obj=InputObj.feeitemarray.feeitem.GetAt(i)
	.w "Obj.itemname="_Obj.itemname,!
	
	q 0
}
*/
ClassMethod InsuGetOPDivideInStr(UserId As %String, objPAAdm As User.PAAdm, objInvPrt As DHCINSU.InvPrt, InputObj As DHCINSU.Model.BJ.INSUDivideInput) As %Boolean
{
	
	s objINSUTradeinfo=##class(DHCINSU.Model.BJ.INSUTradeinfo).%New()
	s objINSURecipearray=##class(DHCINSU.Model.BJ.INSURecipearray).%New()
	s objINSUFeeitemarray=##class(DHCINSU.Model.BJ.INSUFeeitemarray).%New()
		
	//取数据时，是把一张发票下所有账单当作一个账单使用，所以此处只有一个objPatientBill
	s objPatientBill=##class(DHCINSU.PatientBill).%New()
	s objPatientBill=objInvPrt.PatientBill.GetAt(1)
	
	//交易信息Tradeinfo
	s objINSUTradeinfo.curetype="11"
    i objPAAdm.PAADMType="O" d
    .s objINSUTradeinfo.curetype="11"
    i objPAAdm.PAADMType="E" d
    .s objINSUTradeinfo.curetype="19"
	s objINSUTradeinfo.illtype=0
	s objINSUTradeinfo.feeno=objInvPrt.TmpInvRowid
	s objINSUTradeinfo.operator=UserId
	s InputObj.tradeinfo=objINSUTradeinfo
	//end
	s INSUOPDiagCount=objInvPrt.INSUOPDiagInfoCol.Count()
	f INSUOPDiagIndex=1:1:INSUOPDiagCount d
	.s objINSURecipe=##class(DHCINSU.Model.BJ.INSURecipe).%New()
	.s objINSUOPDiagInfo=##class(DHCINSU.Model.BJ.INSUOPDiagInfo).%New()
	.s objINSUOPDiagInfo=objInvPrt.INSUOPDiagInfoCol.GetAt(INSUOPDiagIndex)
	.//Recipearray
	.//1-5
	.s objINSURecipe.diagnoseno=objINSUOPDiagInfo.DiagIdx
	.s objINSURecipe.recipeno=objINSUOPDiagInfo.OeordDR
	.s objINSURecipe.recipedate=objINSUOPDiagInfo.OeordDate
	.s objINSURecipe.diagnosecode=objINSUOPDiagInfo.DiagCode
	.s objINSURecipe.diagnosename=$e(objINSUOPDiagInfo.DiagDesc,1,80)
	.//6-10
	.s objINSURecipe.medicalrecord=objINSUOPDiagInfo.PatEPRInfo
	.s objINSURecipe.sectioncode=objINSUOPDiagInfo.BasDicDepCode
	.s objINSURecipe.sectionname=objINSUOPDiagInfo.BasDicDepDesc
	.s objINSURecipe.hissectionname=$e(objINSUOPDiagInfo.AdmDepDesc,1,40)
	.s objINSURecipe.drid=objINSUOPDiagInfo.DocCode
	.//11-15
	.s objINSURecipe.drname=objINSUOPDiagInfo.DocName
	.s objINSURecipe.recipetype=objINSUOPDiagInfo.OeordType
	.s objINSURecipe.helpmedicineflag=0
	.s objINSURecipe.remark=objINSUOPDiagInfo.remark
	.s objINSURecipe.registertradeno=objINSUOPDiagInfo.registertradeno
	.//
	.s objINSURecipe.billstype=objINSUOPDiagInfo.billstype
	.d objINSURecipearray.recipe.Insert(objINSURecipe)
	
	s InputObj.recipearray=objINSURecipearray
	
	//Feeitemarray
	s PBDetailsCount=objPatientBill.PatBillDetails.Count()
	f PBDetailsIndex=1:1:PBDetailsCount d
	.s objPatBillDetails=##class(DHCINSU.PatBillDetails).%New()
	.s objPatBillDetails=objPatientBill.PatBillDetails.GetAt(PBDetailsIndex)
	.s objINSUFeeitem=##class(DHCINSU.Model.BJ.INSUFeeitem).%New()
	.//1-5
    .s objINSUFeeitem.itemno=PBDetailsIndex
    .s objINSUFeeitem.recipeno=objPatBillDetails.OeordInfo.PrescNo
    .s objINSUFeeitem.hiscode=objPatBillDetails.HisTarItemInfo.TARICode
    .s objINSUFeeitem.itemname=objPatBillDetails.HisTarItemInfo.TARIDesc
    .s objINSUFeeitem.itemtype=objPatBillDetails.InsuTarItemInfo.INTIMsfdlbm
    .i (objINSUFeeitem.itemtype="Null")||(objINSUFeeitem.itemtype="") d
    ..s objINSUFeeitem.itemtype=1
    ..s:objPatBillDetails.HisTarItemInfo.DrugFlag=1 objINSUFeeitem.itemtype=0
    .//6-10
    .s objINSUFeeitem.unitprice=objPatBillDetails.UnitPrice
    .s objINSUFeeitem.count=objPatBillDetails.BillQty
    .s objINSUFeeitem.fee=objPatBillDetails.TotalAmount
    .s objINSUFeeitem.dose=objPatBillDetails.InsuTarItemInfo.INTIMjx
    .s objINSUFeeitem.specification=objPatBillDetails.InsuTarItemInfo.INTIMgg
    .//11-15
    .s objINSUFeeitem.unit=objPatBillDetails.OeordInfo.ARCIMBillingUOMdes
    .s objINSUFeeitem.howtouse=objPatBillDetails.OeordInfo.OEORIPHFreq
    .s objINSUFeeitem.dosage=objPatBillDetails.OeordInfo.DoseQty
    .i (objINSUFeeitem.dosage="Null")||(objINSUFeeitem.dosage="") d
    ..s objINSUFeeitem.dosage=0
    .s objINSUFeeitem.packaging=objPatBillDetails.OeordInfo.ARCIMBillingUOMdes
    .s objINSUFeeitem.minpackage=objPatBillDetails.OeordInfo.OEORIUnitDes
    .i (objINSUFeeitem.minpackage="Null")||(objINSUFeeitem.minpackage="") d
    ..s objINSUFeeitem.minpackage=objPatBillDetails.OeordInfo.UomDesc
    .//16-20
    .s objINSUFeeitem.conversion=objPatBillDetails.OeordInfo.Factor
    .s objINSUFeeitem.days=objPatBillDetails.OeordInfo.PHCDUDesc
    .s objINSUFeeitem.babyflag=0
    .s objINSUFeeitem.drugapprovalnumber=objPatBillDetails.OeordInfo.DrugApprovalNumber
 	.d objINSUFeeitemarray.feeitem.Insert(objINSUFeeitem) //每取到一个处方明细，就把它插入到主体Obj中
 	.;w objINSUFeeitemarray.feeitem.GetAt(PBDetailsIndex).hiscode,!
	s InputObj.feeitemarray=objINSUFeeitemarray
	
	q 0
}

/// w ##class(DHCINSU.Adaper.BJ.AdaperINSUBJ).BuildInsuDivide
ClassMethod BuildInsuDivide(UserId As %String, InvPrtDr As %String, objPAAdm As User.PAAdm, objINSUAdmInfo As User.INSUAdmInfo, objINSUCardInfo As DHCINSU.Model.BJ.INSUCardInfo, objINSUDivideOutput As DHCINSU.Model.BJ.INSUDivideOutput, objINSUTradeOutput As DHCINSU.Model.BJ.INSUTradeOutput, objINSUDivide As User.INSUDivide) As %Boolean
{
	s objINSUDivide.INPAYAdmDr = objPAAdm.%Id()        		//'指向PAADM的指针User.PAAdm          
	s objINSUDivide.INPAYAdmInfoDr = objINSUAdmInfo.%Id()    //'指针User.INSUAdmInfo           
	//s objINSUDivide.INPAYDHCpblDr = ""     					//'指向DHC_PatientBill的指针       
	s objINSUDivide.INPAYDhcInvPrtDr = InvPrtDr  			//'Dhc_InvPrt的指针             
	s objINSUDivide.INPAYFlag = "insu"         				//'结算状态（divide,insu,strike,bestrike）       
	s objINSUDivide.INPAYINSUDivideDr = "" 					//'被冲销的指针                
	s objINSUDivide.INPAYbcbxf0 = +objINSUDivideOutput.sumpay.feeall      //'总费用                           *
	s objINSUDivide.INPAYdjlsh0 = objINSUDivideOutput.tradeinfo.tradeno  //'单据流水号    -----------存交易流水号 
	//s objINSUDivide'.INPAYbckbcs = ""      							//'本次看病次数(即视同住院次数)      *    Integer
	s objINSUDivide.INPAYbqbm00 = objINSUDivideOutput.tradeinfo.feeno    //'病种编码    -------------存收费单据号    
	s objINSUDivide.INPAYbrnl00 = 1      								//'年龄                              *    Integer ------------1为门诊,2为住院  
	s objINSUDivide.INPAYcardno = objINSUCardInfo.ic.cardno        		//'卡号      
	//s objINSUDivide'.INPAYcfxms0 = ""      '收费项目数                  Integer       
	//s objINSUDivide'.INPAYcrbcts = ""      '传染病床天数                Integer       
	s objINSUDivide.INPAYgrzfe0 = +objINSUDivideOutput.sumpay.cash         //'个人现金支付额                    
	s objINSUDivide.INPAYiDate = $p($h,",",1)        				//'操作日期       
	s objINSUDivide.INPAYiTime = $p($h,",",2)        				//'操作时间       
	s objINSUDivide.INPAYid0000 = objINSUCardInfo.ic.icno  					//'医保号        
	s objINSUDivide.INPAYjjzfe0 = +objINSUDivideOutput.sumpay.fund			//       '基金支付额                         
	//s objINSUDivide'.ptbcts = ""      '普通病床天数                Integer      
	s objINSUDivide.INPAYsUserDr = UserId      							//'操作员User.SSUser
	s objINSUDivide.INPAYsfrq00 = objINSUDivideOutput.tradeinfo.tradedate       //'收费日期  -----------存了交易日期,格式为：YYYYMMDDHHMMSS    
	//s objINSUDivide.sfrxm0 = ""       '收费人姓名    
	//s objINSUDivide.sfsj00 = ""       '收费时间      
	//s objINSUDivide.sftsbz = ""       '是否特殊病种  
	s objINSUDivide.INPAYxbie00 = "PT"       //'性别   
	s objINSUDivide.INPAYxming0 = objINSUCardInfo.ic.personname        //'姓名          
	s objINSUDivide.INPAYzhzfe0 =+objINSUDivideOutput.sumpay.personcountpay 	//'帐户支付额                        
	//s objINSUDivide.zyksmc = ""       '住院科室名称  
	//s objINSUDivide.zylsh0 = ""       '入院登记流水号
	s objINSUDivide.INPAYInsuPay1 =+objINSUDivideOutput.payinfo.mzfee	//'	费用总金额     '医保支付方式                      
	s objINSUDivide.INPAYInsuPay2 =+objINSUDivideOutput.payinfo.mzfeein	//'	医保内总金额     '医保支付方式                      
	s objINSUDivide.INPAYInsuPay3 =+objINSUDivideOutput.payinfo.mzfeeout	//'	医保外总金额     '医保支付方式                      
	s objINSUDivide.INPAYInsuPay4 =+objINSUDivideOutput.payinfo.mzpayfirst	//'	本次付起付线金额     '医保支付方式                      
	s objINSUDivide.INPAYInsuPay5 =+objINSUDivideOutput.payinfo.mzselfpay2	//'	个人自付2     '医保支付方式                      
	s objINSUDivide.INPAYZstr01 =+objINSUDivideOutput.payinfo.mzbigpay 		//'	门诊大额支付金额       '预留
	s objINSUDivide.INPAYZstr02 =+objINSUDivideOutput.payinfo.mzbigselfpay 	//'	门诊大额自付金额       '预留
	s objINSUDivide.INPAYZstr03 =+objINSUDivideOutput.payinfo.mzoutofbig 	//'	超大额自付金额       '预留
	s objINSUDivide.INPAYZstr04 =+objINSUDivideOutput.payinfo.bcpay  		//'	补充保险支付金额       '预留
	s objINSUDivide.INPAYZstr05 =+objINSUDivideOutput.payinfo.jcbz  	//'	军残补助保险金额       '预留
	s objINSUDivide.INPAYZstr06 =objINSUCardInfo.net.personcount		//'预留--存了交易确认前账户余额
	s objINSUDivide.INPAYZstr07 =objINSUTradeOutput.personcountaftersub	//'预留--存了交易确认后账户余额
	s objINSUDivide.INPAYZstr08 = objINSUTradeOutput.certid        //'预留-------------个人数字证书编码 这两个是加密用的，首信要求保存
	s objINSUDivide.INPAYZstr09 = objINSUTradeOutput.sign        //'预留---------------交易数字签名,长度256,注意要将表结构中的字段长度放大
    q 0
}

}
