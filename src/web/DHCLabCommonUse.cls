Class web.DHCLabCommonUse Extends %Persistent
{

//根据条码号检索病人姓名

/// 基础公共函数
/// ##class(web.DHCLabCommonUse).GetPatName()  根据条码号检索病人姓名
/// ##class(web.DHCLabCommonUse).GetSndLabNo()  根据条码好得到预值条码
/// ##class(web.DHCLabCommonUse).GetHospnoByDebno()  根据登记号取病案号
/// ##class(web.DHCLabCommonUse).GetDebnoByHospno() 根据病案号取登记号
/// ##class(web.DHCLabCommonUse).AgeOut()  年龄计算
/// ##class(web.DHCLabCommonUse).GetPatAge()  根据条码号取年龄
/// ##class(web.DHCLabCommonUse).CalTestSetFee()  医嘱费用计算
/// ##class(web.DHCLabCommonUse).GetPatAgeByAdm 根据adm号取年龄
/// ##class(web.DHCLabCommonUse).EpisNoToAdm 根条码号取adm号
ClassMethod GetPatName(labno As %String) As %String
{
  S labno=$G(labno)
  S (ret,FirstName,GiveName)=""
  I $D(^TEPI(labno)) S FirstName=$P(^TEPI(labno),"\",1),GiveName=$P(^TEPI(labno),"\",2)
  I FirstName=GiveName S ret=FirstName
  I FirstName'=GiveName S ret=FirstName_GiveName
  Q ret
}

//根据条码好得到预值条码

ClassMethod GetSndLabNo(Labno As %String, NameSpace As %String) As %String
{
   S Labno=$g(Labno),NameSpace=$G(NameSpace)
   I '$L(NameSpace) S NameSpace="LABDATA"
   ;如果在DHC_SndLabNo中有则删除
   I $D(^[NameSpace]DHCSecondLabNo(Labno)),$d(^DHCSndLabNo(Labno)) D
   .S SndLabNo=$o(^[NameSpace]DHCSecondLabNo(Labno,""))
   .I $L(SndLabNo) D
   ..ZN NameSpace
   ..D delete^DHCLABSecondLabNo(Labno_"||"_SndLabNo)
   ..ZN "DHC-APP" 
   ;
   S SndLabNo=""
   I $P(^[NameSpace]CF("LAB",1),"^",60)="Y" D
   .I $D(^[NameSpace]DHCSecondLabNo(Labno))>0 S SndLabNo=$O(^[NameSpace]DHCSecondLabNo(Labno,""))
   .;i $l(SndLabNo)=0,$p(^TEPI(Labno),"\",48)="GP" s SndLabNo=Labno
   E  D
   .S SndLabNo=Labno 
   ;在^DHCSndLabNo中查询
   I '$L(SndLabNo) D
   .I $P(^[NameSpace]CF("LAB",1),"^",60)="Y",$D(^[NameSpace]DHCSndLabNo(Labno)) S SndLabNo=$P(^[NameSpace]DHCSndLabNo(Labno),"\",1)
   .E  S SndLabNo=Labno
   Q SndLabNo
}

//根据登记号取病案号

ClassMethod GetHospnoByDebno(Debno As %String) As %String
{
    S Debno=$G(Debno)
    I Debno="" Q ""
    S Hospno=$O(^TDEBi(Debno,"HOSPITAL",""),-1)
    ;add 20080108
    I $L(Debno)=10 S Hospno=$E(Hospno,2,$L(Hospno)) 
    S HospNO=""
    I $D(^PAPERi("PAPMI_PatNo",Debno)) D
    .S PaperID=$O(^PAPERi("PAPMI_PatNo",Debno,""))
    .I $D(^PAPER(PaperID,"PAT",1)) D
    ..S HospNO=$P(^PAPER(PaperID,"PAT",1),"^",22)
    I $L(HospNO) S Hospno=HospNO  
    Q Hospno
}

//根据病案号取登记号HIS

ClassMethod GetDebnoByHospnoHIS(hospNo As %String) As %String
{
    S hospNo=$G(hospNo)
    S ret=""
    I hospNo="" Q ret
    I '$D(^PAPERi("Medicare1",hospNo)) Q ret
    S Debno=$O(^PAPERi("Medicare1",hospNo,""))
    S Debno=$TR($J(Debno,10)," ","0")
    Q Debno
}

ClassMethod GetDebnoByHospno(HospNo As %String) As %String
{
	S HospNo=$TR($g(HospNo)," ")
	I HospNo="" Q ""
	S Debtor=$O(^TDEBj("HOSPITAL",HospNo,""),-1)	
	Q Debtor
}

//年龄计算

ClassMethod AgeOut(InAge As %String) As %String
{
  S InAge=$G(InAge)
  S ret=""
  S PatAge=$P(InAge,$C(1),1),AgeType=$P(InAge,$C(1),2)
  ;b
  I $L(PatAge),$P(PatAge,".",1)="" S PatAge="0"_PatAge
  ;b
  I '$L(PatAge) Q ret
  I AgeType="0" S ret=PatAge_"岁"
  I AgeType="1" S ret=PatAge_"月"
  I AgeType="2" S ret=PatAge_"天"
  I AgeType="3" S ret=PatAge_"小时"
  Q ret
}

//根据条码号取年龄

ClassMethod GetPatAge(Labno As %String) As %String
{
  S Labno=$G(Labno)
  S ret1="",ret2=""
  S Age=$P(^TEPI(Labno),"\",25)
  I Age="0" S Age=""
  S temAgeUnit=""
  ;年龄单位  6.3->6.4
  I $D(^TEPI(Labno,8)) S temAgeUnit=$P(^TEPI(Labno,8),"\",17)   ;6.4
  ;b
  I $L(temAgeUnit) D
  .I temAgeUnit="0" s ret1=Age
  .I temAgeUnit="1",$L(Age) S ret1=(Age*1000)/30
  .I temAgeUnit="2",$L(Age) S ret1=Age*1000
  .I temAgeUnit="3",$L(Age) S ret1=Age*100000
  .S ret2=temAgeUnit
  E  D
  .I $L(Age) D
  ..I Age'<1 D
  ...S ret1=Age
  ...S ret2="0"
  ..E  D
  ...S ret1=Age*1000
  ...I ret1'<1  D
  ....S ret2="2"
  ...E  D
  ....S ret1=ret1*100
  ....S ret2="3"
  Q ret1_$C(1)_ret2
}

/// 医嘱费用计算
ClassMethod CalTestSetFee(VisitNumber As %String, TestSetRowID As %String, NameSpace As %String, cDate As %String) As %String
{
 S VisitNumber=$G(VisitNumber),TestSetRowID=$G(TestSetRowID),NameSpace=$G(NameSpace),cDate=$G(cDate)
 S TestsetPrice=0
 I $D(^[NameSpace]DHCTestSetDetails(VisitNumber,$P(TestSetRowID,"||",2)))'=0 D
 .S TestsetPrice=$P(^[NameSpace]DHCTestSetDetails(VisitNumber,$P(TestSetRowID,"||",2)),"\",2) 
 ;I $e($P(TestSetRowID,"||",2),1)="G" S TestsetPrice=0   ;liuzF 微生物价格重取
 I '$L(TestsetPrice) S TestsetPrice=0
 I TestsetPrice=0 D
 .S ORDID="" F  S ORDID=$O(^OEORD(0,"EpisNo",VisitNumber,ORDID)) Q:ORDID=""  D
 ..S ORDCHL="" F  S ORDCHL=$O(^OEORD(0,"EpisNo",VisitNumber,ORDID,ORDCHL)) Q:ORDCHL=""  D
 ...S arcimId=$P($G(^OEORD(ORDID,"I",ORDCHL,1)),"^",2)
 ...S sttDate=$P($G(^OEORD(ORDID,"I",ORDCHL,1)),"^",9) //keep Dup
 ...S oeoriPrice=$P($G(^OEORD(ORDID,"I",ORDCHL,3)),"^",25)
 ...S LabTestSetRow=$P($G(^OEORD(ORDID,"I",ORDCHL,3)),"^",35)
 ...S ARCOS=$P($G(^OEORD(ORDID,"I",ORDCHL,3)),"^",10)
 ...I TestSetRowID=LabTestSetRow D
 ....S TestsetPrice=+##CLASS(web.UDHCJFPRICE).GetOrderPrice("","",arcimId,sttDate,"","","",oeoriPrice)
 Q TestsetPrice
}

ClassMethod GetPatAgeByAdm(AdmId As %String) As %String
{
  s ret1="",ret2="",age=""
  s OrdId="" f  s OrdId=$o(^OEORD(0,"Adm",AdmId,OrdId)) q:OrdId=""  d
  .s OrdSubId="" f  s OrdSubId=$o(^OEORDi(0,"LabNotRead",OrdId,OrdSubId)) q:OrdSubId=""  d
  ..s TSRow=$p(^OEORD(OrdId,"I",OrdSubId,3),"^",35)
  ..i '$l(TSRow) q
  ..s labno=$p(TSRow,"||",1)
  ..Q:labno=""
  ..I $D(^TEPI(labno)) s age=$p(^TEPI(labno),"\",25)
  ..i age="0" s age=""
  ..s temageunit=""
  ..i $d(^TEPI(labno,8)) s temageunit=$p(^TEPI(labno,8),"\",17)   ;6.4
  ..i $l(temageunit) d
  ...i temageunit="0" s ret1=age
  ...i temageunit="1",$l(age) s ret1=(age*1000)/30
  ...i temageunit="2",$l(age) s ret1=age*1000
  ...i temageunit="3",$l(age) s ret1=age*100000
  ...s ret2=temageunit
  ..e  d
  ...i $l(age) d
  ....i age'<1 d
  .....s ret1=age
  .....s ret2="0"
  ....e  d
  .....s ret1=age*1000
  .....i ret1'<1  d
  ......s ret2="2"
  .....e  d
  ......s ret1=ret1*100
  ......s ret2="3"
  q ret1_$c(1)_ret2
}

ClassMethod EpisNoToAdm(LabNo As %String) As %String
{
  s LabNo=$g(LabNo),CurAdm=""
  i $d(^OEORD(0,"EpisNo",LabNo)) d
  .s OrdItmId=$o(^OEORD(0,"EpisNo",LabNo,""))
  .s CurAdm=$p(^OEORD(OrdItmId),"^",1)
  q CurAdm
}

Storage Default
{
<Data name="DHCLabCommonUseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCLabCommonUseD</DataLocation>
<DefaultData>DHCLabCommonUseDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCLabCommonUseD</IdLocation>
<IndexLocation>^web.DHCLabCommonUseI</IndexLocation>
<StreamLocation>^web.DHCLabCommonUseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
