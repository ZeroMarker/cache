Include webimport

IncludeGenerator webimport

Class web.DHCBldRequisition Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 126;

ClassMethod DHCBldRequisitionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCBldRequisitionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod DHCBldRequisitionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCBldRequisitionExecute ]
{
 	// Restore QHandle
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)

 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}

 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod DHCBldRequisitionExecute(ByRef qHandle As %Binary, admId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    d ..DHCBldRequisitionInfo(repid,admId)
	Quit $$$OK
}

ClassMethod DHCBldRequisitionInfo(repid As %String, admId As %String)
{
  s admId=$g(admId)
  q:admId=""
  s ordRowid=$o(^OEORD(0,"Adm",admId,""))
  i ordRowid="" q 0
  s k=0
  s childsub="" f  s childsub=$o(^OEORD(ordRowid,"I",childsub)) q:childsub=""  d
  .i $d(^OEORD(ordRowid,"I",childsub,3)) d
  ..s labno=$p(^OEORD(ordRowid,"I",childsub,3),"^",20)
  ..q:labno=""
  ..s armRowid=$p(^OEORD(ordRowid,"I",childsub,1),"^",2)
  ..q:armRowid=""
  ..s armId=$p(armRowid,"||",1)
  ..s armchl=$p(armRowid,"||",2)
  ..q:'$d(^ARCIM(armId,armchl,"EXT",1))
  ..s ts=$p(^ARCIM(armId,armchl,"EXT",1),"^",4)
  ..;i $e(ts,1,1)'="K" q
  ..;i ts="K003" q
  ..i '$d(^TTAB("TS",ts,"XM")) q
  ..s labTS=labno_"||"_ts
  ..;i $$selEpisTS^DHCBldRqOrd(labTS)=0 q
  ..s debtor=$p(^OEORD(ordRowid,"I",childsub,3),"^",9)
  ..s b=0
  ..i $d(^DHCBldReqOrd(debtor)) d
  ...s id="" f  s id=$o(^DHCBldReqOrd(debtor,id)) q:id=""  d
  ....s no="" f  s no=$o(^DHCBldReqOrd(debtor,id,no)) q:no=""  d
  .....i $p(^DHCBldReqOrd(debtor,id,no),"^",2)=labTS s b=1
  .....q:b=1
  ..q:b=1  ;医嘱已打印不显示
  ..s itmDesc=$p(^ARCIM(armId,armchl,1),"^",2)
  ..s unit="",OrdItmRowId="",arcSub=""
  ..s unitcode=$p(^ARCIM(armId,armchl,8),"^",14)
  ..i unitcode'="" s unit=$p(^CT("UOM",unitcode),"^",2)
  ..s k=k+1
  ..s memo=""
  ..s rowid=ordRowid_"||"_childsub
  ..s ^CacheTemp(repid,k)=$lb($g(k),$g(rowid),$g(labTS),$g(itmDesc),$g(memo),$g(unit))
  q 0
}

Query DHCBldRequisition(admId As %String) As %Query(ROWSPEC = "tNo:%String,tRowId:%String,tLabno:%String,tOrderItem:%String,tMemo:%String,tUnit:%String")
{
}

ClassMethod GetPatDetailBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", curId As %Library.String = "")
{
  q:curId=""
  s admId=$p(curId,"^",2)
  s curId=$p(curId,"^")
  q:(curId="")&(admId="")
  i admId="" d
  .s oriSub=$p(curId,"||",2)
  .i oriSub'="" d //医嘱项
  ..s oeordId=$p(curId,"||",1)
  ..s admId=$p($g(^OEORD(oeordId)),"^",1)
  .e  d  ;登记号
  ..s papmiId=""
  ..s papmiId=$o(^PAPERi("PAPMI_PatNo",curId,"")) 
  ..i papmiId="" s admId="" q
  ..s admType="",preAdm=""
  ..f  s admType=$o(^PAPERdr(papmiId,"ADM",admType),-1) q:admType=""  d
  ...s admId="" f  s admId=$o(^PAPERdr(papmiId,"ADM",admType,admId)) q:(admId="")  d
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
  i ctlocDesc["-" s ctlocDesc=$p(ctlocDesc,"-",2)
  s roomId=$p(^PAADM(admId),"^",69)
  i (roomId'="") s room=$p(^PAROOM(roomId),"^",2)
  s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
  s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
  i $d(^PAPER(papmiId,"PAT",1)) s safetyNetCardNo=$p(^PAPER(papmiId,"PAT",1),"^",22) ;病案号
  e  s safetyNetCardNo=""
  s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
  S homeAddres=$g(^PAPER(papmiId,"PER","ADD")) // 住址
  s homeTel=$p($g(^PAPER(papmiId,"PER",1)),"^",11)  //家庭电话
  s workTel=$p($g(^PAPER(papmiId,"PER",1)),"^",9)  //工作电话
  s handtel=$p($g(^PAPER(papmiId,"PER",4)),"^",21)  //手机
  //医生
  Set Doctor=$P($g(^PAADM(admId)),"^",9)
  If Doctor'="" Set PAAdmDocCodeDR=$P($g(^CTPCP(Doctor,1)),"^",2)
  Else  Set PAAdmDocCodeDR=""
  
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
  i NationDesc["-" s NationDesc=$p(NationDesc,"-",2)
  //籍贯
  s ProvinceCode=$p(^PAPER(papmiId,"PER",2),"^",11)
  s ProvinceDesc=""
  i $l(ProvinceCode) s ProvinceDesc=$p(^CT("PROV",ProvinceCode),"^",2)
  s ProvinceType="外阜"                        ;1->外阜;0->本市
  i ProvinceDesc["北京" s ProvinceType="本市"  
  i '$l(ProvinceCode)  s ProvinceType=""       ;"未知"
  //取最后一次诊断
  s Diagnos=""     //$$GetDiag^DHCLabGetDiag(admId)
  Set mradm=$P(^PAADM(admId),"^",61)
  If $g(mradm)'="" Set Diagnos=..GetMRAdmDiagnosis(mradm)
  Else  Set Diagnos=""
  
  i patType="O" s patType="门诊"
  i patType="I" s patType="住院"
  s retStr=admId_"^"_regNo_"^"_ctlocDesc_"^"_$g(room)_"^"_$g(sex)_"^"_$g(patName)_"^"_$g(safetyNetCardNo)_"^"_$g(bedCode)_"^"_birth_"^"_$g(age)_"^"_$g(wardDesc)_"^"_homeAddres_"^"_homeTel_"  "_workTel_"  "_handtel
  s retStr=retStr_"^"_cardid_"^"_patType_"^"_CountryDesc_"^"_NationDesc_"^"_Diagnos_"^"_ProvinceType
  
  s retval=itmjs_"('"_$ZCVT(retStr,"O","JS")_"');"
  &javascript<#(retval)#>
  q retStr
}

ClassMethod GetMRAdmDiagnosis(MRAdm As %String) As %String
{
 Quit:$g(MRAdm)="" ""
 Set DiagStr=""
 Set Diag=0
 For  Set Diag=$O(^MR(MRAdm,"DIA",Diag)) Quit:Diag=""  Do
 .Set DiagID=$P($g(^MR(MRAdm,"DIA",Diag)),"^",1)
 .Quit:$g(DiagID)=""
 .Set DiagDesc=$P($g(^MRC("ID",DiagID)),"^",2)
 .If DiagDesc["-" Set DiagDesc=$P(DiagDesc,"_",2)
 .If DiagStr="" Set DiagStr=DiagDesc
 .Else  Set DiagStr=DiagStr_","_DiagDesc
 Quit DiagStr
}

ClassMethod ReqHistroyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReqHistroyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod ReqHistroyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReqHistroyExecute ]
{
 	// Restore QHandle
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)

 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}

 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ReqHistroyExecute(ByRef qHandle As %Binary, HisDebtor As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    d ..ReqHistroyInfo(repid,HisDebtor)
	Quit $$$OK
}

ClassMethod ReqHistroyInfo(repid As %String, HisDebtor As %String)
{
  s k=0
  q:HisDebtor=""
  s chl="" f  s chl=$o(^DHCBldRequest(HisDebtor,chl)) q:chl=""  d
  .s tHisNo=chl
  .s tHisUser=$p(^DHCBldRequest(HisDebtor,chl),"\",14)
  .s tHisDate=$p(^DHCBldRequest(HisDebtor,chl),"\",15)
  .s tHisTime=$p(^DHCBldRequest(HisDebtor,chl),"\",16)
  .i $l(tHisUser) s tHisUser=$p(^SSU("SSUSR",tHisUser),"^",2)
  .i $l(tHisDate) s tHisDate=$zd(tHisDate,3)
  .i $l(tHisTime) s tHisTime=$zt(tHisTime,3)
  .s k=k+1
  .s ^CacheTemp(repid,k)=$lb($g(tHisNo),$g(tHisUser),$g(tHisDate),$g(tHisTime))
  q 0
}

Query ReqHistroy(HisDebtor As %String) As %Query(ROWSPEC = "tHisNo:%String,tHisUser:%String,tHisDate:%String,tHisTime:%String")
{
}

ClassMethod SaveHistroy(itmjs As %Library.String = "", itmjsex As %Library.String = "", debtor As %Library.String = "", User As %Library.String = "", List As %Library.String = "", ordList As %Library.String = "")
{
 Set Config=##Class(websys.Configuration).%OpenId(1)
 Set MEDDATA=Config.DataNamespace
 Set LABDATA=Config.LabDataNamespace
 Set CurrentNS=$ZNSPACE
 ZN MEDDATA
 Set Ret=$$save^DHCBldRequest(debtor,User,List,ordList)
 ZN CurrentNS
 s retval=itmjs_"('"_$ZCVT(Ret,"O","JS")_"');"
 i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT(Ret,"O","JS")_"');"
 &javascript<#(retval)#>
 q 1
}

ClassMethod GetHisOrdItm(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowId As %Library.String = "")
{
 Set Config=##Class(websys.Configuration).%OpenId(1)
 Set MEDDATA=Config.DataNamespace
 Set LABDATA=Config.LabDataNamespace
 Set CurrentNS=$ZNSPACE
 ZN MEDDATA
 s Ret=""
 s deb=$p(rowId,"||",1)
 s chl=$p(rowId,"||",2)
 i $d(^DHCBldReqOrd(deb,chl)) d
 .s iNo="" f  s iNo=$o(^DHCBldReqOrd(deb,chl,iNo)) q:iNo=""  d
 ..s Ret=Ret_"~"_$g(^DHCBldReqOrd(deb,chl,iNo))_"^"_iNo
 ZN CurrentNS
 s retval=itmjs_"('"_$ZCVT(Ret,"O","JS")_"');"
 i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT(Ret,"O","JS")_"');"
 &javascript<#(retval)#>
 q Ret
}

ClassMethod GetHisReqInfo(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowId As %Library.String = "")
{
 Set Config=##Class(websys.Configuration).%OpenId(1)
 Set MEDDATA=Config.DataNamespace
 Set LABDATA=Config.LabDataNamespace
 Set CurrentNS=$ZNSPACE
 ZN MEDDATA
 s Ret=""
 s deb=$p(rowId,"||",1)
 s chl=$p(rowId,"||",2)
 i $d(^DHCBldRequest(deb,chl)) s Ret=$g(^DHCBldRequest(deb,chl))_"\"_$g(^DHCBldRequest(deb,chl,"Lab"))
 s rqDate=$p(Ret,"\",2)
 i rqDate'="""" s $p(Ret,"\",2)=$zd(rqDate,3)
 s prtDate=$p(Ret,"\",15)
 i prtDate'="""" s $p(Ret,"\",15)=$zd(prtDate,3)
 s usrname=$p(Ret,"\",14)
 i usrname'="""" s $p(Ret,"\",14)=$p(^SSU("SSUSR",usrname),"^",2)
 ZN CurrentNS
 s retval=itmjs_"('"_$ZCVT(Ret,"O","JS")_"');"
 i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT(Ret,"O","JS")_"');"
 &javascript<#(retval)#>
 q Ret
}

}
