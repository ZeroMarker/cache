Import SQLUser

Class web.DHCLabInterface Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 52;

ClassMethod GetPatInfo(curId As %String, Labno As %String) As %String
{
  //病人基本信息;
  //入参:1. "^"分隔第二部分为admId?第一个分隔部分为登记号或OEORI_ROWID
  //2. 如果admId为空,按登记号或OEORI_ROWID取
  //3. 登记号根据最后一个ADM取信息?
  ;n (curId,PLIST,Labno,retStr,r)
  s ^lzf=Labno
  k PLIST
  s retStr=$$episode^MVBOEITM(Labno)
  q:retStr'=0 "-100"
  s admId=PLIST(3)
  ;q:curId=""
  ;s admId=$p(curId,"^",2)
  ;s curId=$p(curId,"^")
  q:(curId="")&(admId="") "-100"
  i admId="" d
  .s oriSub=$p(curId,"||",2)
  .i oriSub'="" d //医嘱项
  ..s oeordId=$p(curId,"||",1)
  ..s admId=$p($g(^OEORD(oeordId)),"^",1)
  .e  d  ;登记号
  ..s papmiId=""
  ..s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(curId),"")) 
  ..i papmiId="" s admId="" q
  ..s admType="",preAdm=""
  ..f  s admType=$o(^PAPERdr(papmiId,"ADM",admType),-1) q:admType=""  d
  ...s admId="" f  s admId=$o(^PAPERdr(papmiId,"ADM",admType,admId),-1) q:(admId="")  d
  ....s pavisit=$p($g(^PAADM(admId)),"^",20)
  ....q:pavisit'="A"
  ....i $l(preAdm),(preAdm>admId) s admId=preAdm
  ....s preAdm=admId
  ....;s admId=0,admType=0
  ..s admId=preAdm  //重置admId
  q:admId="" ""  //ypz 060516
  s patType=$p(^PAADM(admId),"^",2)
  s papmiId=+^PAADM(admId)
  s ctlocId=$p(^PAADM(admId),"^",4)
  s ctlocDesc=""
  i $d(^CTLOC(+ctlocId)) s ctlocDesc=$p(^CTLOC(+ctlocId),"^",2)  
  //医生
  s docId=$p(^PAADM(admId),"^",9)
  s doctorId=""
  s doctor=""
  s defDepId=""
  s defDepDesc=""
  i $l(docId),$d(^CTPCP(docId)) d
  .s doctorId=$p(^CTPCP(docId,1),"^",1)
  .s doctor=$p(^CTPCP(docId,1),"^",2)
  .//医生所在科室
  .s usrId=$o(^SSU("SSUSR",0,"SSUSR_Initials",doctorId,""))
  .s defDepId=$p(^SSU("SSUSR",usrId),"^",4)
  .i $d(^CTLOC(defDepId)) s defDepDesc=$p(^CTLOC(defDepId),"^",2)  
  //病房号
  s room=""
  s roomId=$p(^PAADM(admId),"^",69)
  i (roomId'="") s room=$p(^PAROOM(roomId),"^",2)
  s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
  s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
  i $d(^PAPER(papmiId,"PAT",3)) s safetyNetCardNo=$p(^PAPER(papmiId,"PAT",3),"^",4) ;病案号
  e  s safetyNetCardNo=""
  s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
  S homeAddres=$g(^PAPER(papmiId,"PER","ADD")) // 住址
  s homeTel=$p($g(^PAPER(papmiId,"PER",1)),"^",11)  //家庭电话
  s workTel=$p($g(^PAPER(papmiId,"PER",1)),"^",9)  //工作电话
  s handtel=$p($g(^PAPER(papmiId,"PER",4)),"^",21)  //手机
  s bedSub=$p($p($g(^PAADM(admId)),"^",73),"||",2)
  s curWardId=$p($g(^PAADM(admId)),"^",70)  
  i curWardId'="" s wardDesc=$p(^PAWARD(curWardId),"^",1)
  i bedSub'="" s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
  e  s bedCode=""
  s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
  s age=((+$h)-(+birth))/365
  s age=$p(age,".")_"岁"
  s birth=$zd(birth,3)
  s cardid=$p($g(^PAPER(papmiId,"ALL")),"^",9)  //身份证号
  //国家
  s CountryCode=$p(^PAPER(papmiId,"PER",1),"^",8)
  s CountryDesc=""
  i $l(CountryCode) s CountryDesc=$p(^CT("COU",CountryCode),"^",2)
  //民族 
  s NationCode=$p(^PAPER(papmiId,"PER",2),"^",1)           
  s NationDesc=""
  i $l(NationCode) s NationDesc=$p(^CT("NAT",NationCode),"^",2)
  //取最后一次诊断
  s No=$o(^MR(admId,"DIA",""),-1)
  s DiagnosCode=""
  i $l(No) s DiagnosCode=$p(^MR(admId,"DIA",No),"^",1)
  s Diagnos=""
  i $l(DiagnosCode) s Diagnos=$p(^MRC("ID",DiagnosCode),"^",2)
  //取检验医嘱列表
  s r=..GetLabOrdItem(Labno)
  s retStr=safetyNetCardNo_"~"_""_"~"_patType_"~"_regNo_"~"_patName_"~"_cardid_"~"_CountryDesc_"~"_homeAddres_"~"_""_"~"_regNo_"~"_""_"~"_Labno_"~"_""
  s retStr=retStr_"~"_r
  s retStr=retStr_"~"_sex_"~"_birth_"~"_""_"~"_""_"~"_Diagnos_"~"_defDepId_","_defDepDesc_"~"_ctlocId_","_ctlocDesc_"~"_roomId_","_room
  s retStr=retStr_"~"_bedCode_"~"_doctorId_","_doctor_"~"_spec_"~"_""_"~"_""_"~"_SttDate_" "_SttTime_"~"_""_"~"_""
  s retStr=retStr_"~"_""_"~"_""_"~"_""_"~"_""_"~"_""_"~"_""_"~"_""_"~"_""
  q retStr
}

//取检验医嘱

ClassMethod GetLabOrdItem(Labno)
{
  s ret=""
  s SttDate=""
  s SttTime=""
  s ordRowid="" f  s ordRowid=$o(^OEORD(0,"EpisNo",Labno,ordRowid)) q:ordRowid=""  d
  .s childsub="" f  s childsub=$o(^OEORD(0,"EpisNo",Labno,ordRowid,childsub)) q:childsub=""  d
  ..s itmRowid=$p(^OEORD(ordRowid,"I",childsub,1),"^",2)
  ..s itmId=$p(itmRowid,"||",1)
  ..s itmSub=$p(itmRowid,"||",2)
  ..s itmDesc=$p(^ARCIM(itmId,itmSub,1),"^",2)
  ..s arcimId=$p($g(^OEORD(ordRowid,"I",childsub,1)),"^",2)
  ..s sttDate=$p($g(^OEORD(ordRowid,"I",childsub,1)),"^",9) //keep dup
  ..s oeoriPrice=$p($g(^OEORD(ordRowid,"I",childsub,3)),"^",25)
  ..s TestsetPrice=0
  ..;zn "websource"
  ..;s TestsetPrice=+##CLASS(web.UDHCJFPRICE).GetOrderPrice("","",arcimId,sttDate,"","","",oeoriPrice)
  ..;zn "whmeddata"
  ..s ret=ret_"^"_ordRowid_"||"_childsub_","_itmDesc_","_itmRowid_","_TestsetPrice
  ..s SttDate=$p(^OEORD(ordRowid,"I",childsub,1),"^",9)
  ..s SttTime=$p(^OEORD(ordRowid,"I",childsub,1),"^",10)
  ..i $l(SttDate) s SttDate=$zd(SttDate,3)
  ..i $l(SttTime) s SttTime=$zt(SttTime)
  ..s spec=$p(^OEORD(ordRowid,"I",childsub,"SPEC",1),"^",1)
  q $p(ret,"^",2,$l(ret,"^"))
}

ClassMethod OrdItmExecute(OrdIds As %String, userId As %String, OrderStatus As %String) As %String
{
  k PLIST
  s ^zLABOrdItmExe($zn,$j,$h,$p($h,",",2))=OrdIds_"999"_userId_"999"_OrderStatus
  s ret=""
  s OrdStatId=""
  s OrdStatId=$o(^OEC("OSTAT",0,"Code",OrderStatus,OrdStatId),-1)
  q:OrdStatId="" -1
  s UpdateDate=+$h
  s UpdateTime=$p($h,",",2)
  i userId'="" s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userId),""))  //wkz   071023
  i userId=""  s userId=583    //新河LIS传的人员同HIS没对应 
  f k=1:1:$l(OrdIds,"^") d
  .s OrdRowId=$p(OrdIds,"^",k)
  .s OrdRowId1=$P(OrdRowId,"@",1)        //wkz  071017 S
  .s OrdRowId2=$P(OrdRowId,"@",2)
  .s OrdRowId=OrdRowId1_"||"_OrdRowId2   //wkz  071017 E
  .i '$l(OrdRowId) d
  ..b
  ..s ret=ret_"1"_"^"
  .e  d
  ..b
  ..s PLIST(0)=OrdRowId
  ..s PLIST(3)=UpdateDate
  ..s PLIST(4)=UpdateTime
  ..s PLIST(5)=OrdStatId
  ..s PLIST(6)=userId
  ..;&sql(Update OE_OrdItem set OEORI_UpdateDate=:UpdateDate,OEORI_UpdateTime=:UpdateTime,OEORI_ItemStat_DR=:OrdStatId,OEORI_UserUpdate=:userId where OEORI_RowId=:OrdRowId and OEORI_ItemStat_DR="1")           //WKZ 071026
  ..s verStat=1
  ..&sql(Update OE_OrdItem set OEORI_EpisArriveDate=:UpdateDate,OEORI_EpisArriveTime=:UpdateTime,OEORI_UpdateDate=:UpdateDate,OEORI_UserUpdate=:userId,OEORI_UpdateTime=:UpdateTime,OEORI_ItemStat_DR=:OrdStatId,OEORI_UserExecuted=:userId where OEORI_RowId=:OrdRowId and OEORI_ItemStat_DR=:verStat)
  ..i SQLCODE  q
  ..&sql(insert into oe_ordstatus values PLIST() )
  ..i SQLCODE=0 d 
  ...s rtemp=0
  ..e  d 
  ...s rtemp=1
  ..s ret=ret_rtemp_"^"
  i $l(ret) s ret=$p(ret,"^",1,$l(ret,"^")-1)
  q ret
}

}
