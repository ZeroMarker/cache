Class web.DHCFHQ.DHCFHQTOOLS Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

ClassMethod FHQ()
{
	S RowId=""
 f  s RowId=$o(^FHQIQIQFHQIQIQ(RowId)) q:RowId=""  d
 .s CardNo=##class(web.DHCFBCM).ConvertStr(RowId_"^0^15")
	.IF '$d(^DHCCARDi("CF",0,"CardNo",CardNo))  D
	..s ^FHQNUM=$I(^FHQNUM)
	..S ^FHQIQIQNO(RowId)=$G(FHQIQIQFHQIQIQ(RowId))
	Q $G(^FHQNUM)
}

ClassMethod SearchNum()
{
 S RowId=""
 k ^FHQNUM
 f  s RowId=$o(^FHQIQIQ0109(RowId)) q:RowId=""  d
 .s ^FHQNUM=$I(^FHQNUM)
 Q $G(^FHQNUM)
}

ClassMethod UpOrdDoc()
{
   ;D ##class(web.DHCFHQTOOLS).UpOrdDoc()
	s del="^"
	s PaAdmId=0
	S PaAdmId=565800
	s i=0 
	f  s PaAdmId=$o(^PAADM(PaAdmId)) Q:((PaAdmId="")!(PaAdmId>565924))  D
	.
	.S DocId=$p(^PAADM(PaAdmId),del,9)
	.q:$g(DocId)=""
	.s OrdId1=$o(^OEORD(0,"Adm",PaAdmId,0))
	.q:$g(OrdId1)=""
	.s OrdId2=0
	.f  s OrdId2=$o(^OEORD(OrdId1,"I",OrdId2)) q:OrdId2=""  d
	..s OrdDocDr=$p(^OEORD(OrdId1,"I",OrdId2,1),del,11)
	..q:$g(OrdDocDr)'=""
	..s OrdId=OrdId1_"||"_OrdId2
	..&sql(update sqluser.Oe_OrdItem set OEORI_Doctor_DR=:DocId where OEORI_RowId=:OrdId )
	..w SQLCODE,"^"
	..s i=i+1
	w i
	Q
}

ClassMethod CHANGESTOCKaa()
{

 s del="^"
 s FromDate=$h-2
 S LocDescs="心理卫生中心药房"_del_"利康药房"
 s i=1
 f  s LocDesc=$p(LocDescs,del,i) q:LocDesc=""  d
 .s i=i+1
 .s ^FHQTMP("InitStock",LocDesc,$zd($h,3))=$zt($p($h,",",2))
 .s Result=$$CHANGERESVERQTY^DHCFINCI(LocDesc,FromDate)
 .s ^FHQTMP("InitStock",LocDesc,$zd($h,3))=^FHQTMP("InitStock",LocDesc,$zd($h,3))_"^"_$zt($p($h,",",2))
 .if Result'="" s ^FHQTMP("CHANGESTOCK",LocDesc)=Result
 q
}

ClassMethod CHANGERESVERQTY(LocDesc, FromDate)
{
 K ^FHQTMP($j)
 s del="^"
 S LocId=$O(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(LocDesc),""))
 Q:$G(LocId)="" "科室指针为空"_LocDesc
 s IncId=0,OeoriSTTime=0
 f  s OeoriSTTime=$o(^OEORDi(0,"LocStDtTm",LocId,FromDate,OeoriSTTime)) q:OeoriSTTime=""  d
 .s OrdId1=0
 .f  s OrdId1=$o(^OEORDi(0,"LocStDtTm",LocId,FromDate,OeoriSTTime,OrdId1)) q:OrdId1=""  d
 ..s OrdId2=0
 ..f  s OrdId2=$o(^OEORDi(0,"LocStDtTm",LocId,FromDate,OeoriSTTime,OrdId1,OrdId2)) q:OrdId2=""  d
 ...s BillFlag=$p(^OEORD(OrdId1,"I",OrdId2,3),del,5)
 ...s OrdStatus=$p(^OEORD(OrdId1,"I",OrdId2,1),del,13)
 ...s AdmId=$p(^OEORD(OrdId1),del,1)
 ...s AdmType=$p(^PAADM(AdmId),del,2)
 ...s CircleFlag=0
 ...if (($g(BillFlag)="TB")&(OrdStatus=1)) s CircleFlag=1
 ...IF (($g(BillFlag)="B")&($G(AdmType)="O")) s CircleFlag=1
 ...q:CircleFlag=0
 ...s DHCOeDispId=$o(^DHCOEDISQTY(0,"OEORI",OrdId1_"||"_OrdId2,0))
 ...s Qty=$p(^DHCOEDISQTY(DHCOeDispId),del,5)
 ...q:(+Qty=0)
 ...s ArcimId=$p(^OEORD(OrdId1,"I",OrdId2,1),del,2)
 ...q:$g(ArcimId)=""
 ...s IncId=$o(^INCI(0,"ARCIM_DR",$p(ArcimId,"||",1),0))
 ...q:$g(IncId)=""
 ...if $d(^FHQTMP($j,ArcimId)) s ^FHQTMP($j,ArcimId,IncId)=$g(^FHQTMP($j,ArcimId,IncId))+Qty
 ...if '$d(^FHQTMP($j,ArcimId)) s ^FHQTMP($j,ArcimId,IncId)=+Qty
 s ArcimId=0,IncId=0
 f  s ArcimId=$o(^FHQTMP($j,ArcimId)) q:ArcimId=""  d
 .s IncId=0
 .f  s IncId=$o(^FHQTMP($j,ArcimId,IncId)) q:IncId=""  d
 ..s Qty=$g(^FHQTMP($j,ArcimId,IncId))
 ..q:(+Qty=0)
 ..s IncLocSubId=$o(^INCI("IL_LOC",LocId,IncId,0))
 ..q:$g(IncLocSubId)=""
 ..s IncLocId=IncId_"||"_IncLocSubId
 ..s ResQty=$p(^INCI(IncId,"IL",IncLocSubId),del,10)
 ..q:(+ResQty<1)
 ..IF (ResQty<Qty) D
 ...s $p(^INCI(IncId,"IL",IncLocSubId),del,10)=0
 ..e  d
 ...s $p(^INCI(IncId,"IL",IncLocSubId),del,10)=ResQty-Qty
 ..;w "1"_Qty_"^"_ResQty,!
 K ^FHQTMP($j)
 q ""
}

ClassMethod aa(aa)
{
 s desc=$ZCONVERT(desc,"U")
  Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    s Description="",Code=""
  s ^fhqalia(+$g(^fhqalia1))=desc
  s ^fhqalia1=+$g(^fhqalia1)+1
  s CircleFlag=1
  s tmpAilas=$o(^MRC("ID",0,"ALIAS",$$ALPHAUP^SSUTIL4(desc)),-1)
	f  s tmpAilas=$o(^MRC("ID",0,"ALIAS",$$ALPHAUP^SSUTIL4(tmpAilas))) q:((tmpAilas="")!(CircleFlag'=1))  d
	.if ($e($$ALPHAUP^SSUTIL4(tmpAilas),1,$l($$ALPHAUP^SSUTIL4(desc)))'=$$ALPHAUP^SSUTIL4(desc)) d
	..s CircleFlag=0
	.q:CircleFlag'=1
  .s ICDRowid=""  
  .f  s ICDRowid=$o(^MRC("ID",0,"ALIAS",$$ALPHAUP^SSUTIL4(tmpAilas),ICDRowid)) q:ICDRowid=""  d
  ..s Description=$p(^MRC("ID",ICDRowid),"^",2)
	..s Code=$p(^MRC("ID",ICDRowid),"^",1)
	..Do OutputRow
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	 set Data=$lb(Description,ICDRowid,Code)
	 Set ^CacheTemp(repid,ind)=Data
	 Set ind=ind+1
	 Quit
}

ClassMethod CHECKID(Id)
{
   s del="^"
   ;S Id="510122197301104360"
   s PapmiId=0,CircleFlag=1
   f  s PapmiId=$o(^PAPER(PapmiId)) Q:((PapmiId="")!(CircleFlag'=1))  d
   .s id=$p(^PAPER(PapmiId,"ALL"),del,9)
   .if id=Id s CircleFlag=0
   .if CircleFlag=0 w PapmiId,!
   .q:(CircleFlag'=1)
   .if $d(^PAPER(PapmiId,"PAT",3))  d
   ..s divno=$p(^PAPER(PapmiId,"PAT",3),del,6)
   ..if divno=Id s CircleFlag=0 w PapmiId,!
   ..q:CircleFlag'=1
  q
}

ClassMethod UPBED()
{
 
	s WardId=0,del="^"
	s left=5,top=5,width=155,height=120,colnum=8
	s DateTmp=+$h
	f  s WardId=$o(^PAWARD(WardId)) q:WardId=""  d
	.//增加等代床
	.q:WardId<89
	.q:WardId>96
	.if '$d(^PAWARD(WardId,"ROOM"))=1 d
	..&sql(insert into sqluser.pac_wardroom (ROOM_ParRef,ROOM_Room_DR,ROOM_PositionLeft,ROOM_PositionTop,ROOM_PositionWidth,ROOM_PositionHeight,ROOM_DateFrom) values(:WardId,1,1270,5,150,610,:DateTmp)) 
	.q
	.s BedId=0,colnumtmp=0,rownum=0
	.f  s BedId=$o(^PAWARD(WardId,"BED",BedId)) q:BedId=""  d
	..s BedDesc=$p(^PAWARD(WardId,"BED",BedId),del,1)
	..;q:$l(BedDesc,"加")>1
	..q:BedDesc="无效床位"
	..s BedFlag=$p(^PAWARD(WardId,"BED",BedId),del,4)
	..q:$g(BedFlag)="N"
    ..;W BedFlag,"^",BedDesc,!
	..s id=WardId_"||"_BedId
	..s lefttmp=left+(colnumtmp*(width+3)),toptmp=top+((height+3)*rownum)
	..&sql(update sqluser.pac_bed set BED_PositionLeft=:lefttmp,BED_PositionTop=:toptmp,BED_PositionWidth=:width,BED_PositionHeight=:height where BED_RowID=:id)
	..s colnumtmp=colnumtmp+1
	..if (colnumtmp#colnum)=0 s rownum=rownum+1,colnumtmp=0
	.Q
	.S BedId=0
	.f  s BedId=$o(^PAWARD(WardId,"BED",BedId)) q:BedId=""  d
	..s BedDesc=$p(^PAWARD(WardId,"BED",BedId),del,1)
	..q:$l(BedDesc,"加")<2
	..q:BedDesc="无效床位"
	..s BedFlag=$p(^PAWARD(WardId,"BED",BedId),del,4)
	..q:$g(BedFlag)="N"
    ..;W BedFlag,"^",BedDesc,!
	..s id=WardId_"||"_BedId
	..s lefttmp=left+(colnumtmp*(width+3)),toptmp=top+((height+3)*rownum)
	..&sql(update sqluser.pac_bed set BED_PositionLeft=:lefttmp,BED_PositionTop=:toptmp,BED_PositionWidth=:width,BED_PositionHeight=:height where BED_RowID=:id)
	..s colnumtmp=colnumtmp+1
	..if (colnumtmp#colnum)=0 s rownum=rownum+1,colnumtmp=0
}

ClassMethod test()
{
	s adm="2"
 s SQLCODE=0
 ;zn "epr"
 s fmethod="",regno="",name="",sex="",marry="",birthday="",work="",birthpl="",age="",Nation="",Country="",ID="",workaddres="",worktel="",hukaddres="",hukpost="",lxman="",lxrelt="",lxaddres="",LinkPhone="",doc="",worktel=""
 s InYear="",InMonth="",InDay="" ,Nation="",marr="",hukaddres="",fkmethod="",workaddres2=""

 s papmidr=$P(^PAADM(adm),"^",1)
 ;s argPaperDR=papmidr
 s GetPaperDR=##Class(EPRservice.HISInterface.PatientInfoAssist).GetPaperDR(papmidr,"JiShuiTan")
 s lxman=$P($g(^PAPER(papmidr,"PER",2)),"^",13)   ;;;///联系人  ;paper_foreignaddress
 s lxaddres=$P($g(^PAPER(papmidr,"PER",1)),"^",1)    ;;;///联系人地址  ;s lxaddres=$P($g(^PAPER(papmidr,"ALL")),"^",5)     ;联系人地址
 s lxrelt=##Class(EPRservice.HISInterface.PatientInfoAssist).LinkmanRelation(papmidr,"JiShuiTan")     ;;$P($g(^PAPER(papmidr,"ALL")),"^",4)  ;关系 
 s worktel=$P($g(^PAPER(papmidr,"PER",1)),"^",11) ;;;///联系人电话
 s lxtel=worktel ;;;///联系人电话?工作电话

 s fmethod=##Class(EPRservice.HISInterface.PatientInfoAssist).PayType(papmidr,"JiShuiTan")
 ;;;///工作单位及地址
 s workaddres=##Class(EPRservice.HISInterface.PatientInfoAssist).WorkAddress(GetPaperDR,"JiShuiTan")
 ; workaddres2


 s name=$P($g(^PAPER(papmidr,"ALL")),"^",1) ;;;///姓名 
 ;s birthday=$P($g(^PAPER(papmidr,"ALL")),"^",6) ;;;///生日

 s argbirthday="",birthday=""  ////argbirthday是一个重要参数不能修改变量名
 s argbirthday=##Class(EPRservice.HISInterface.PatientInfoAssist).Birthday(papmidr)  ;;(argPapmiDR
 s birthday=$zd(argbirthday,3)

 s EPRPAID=$P($g(^PAPER(papmidr,"ALL")),"^",9) ;;;///身份证---标记编
 s Bah=""
 s Bah=$P($g(^PAPER(papmidr,"PAT",1)),"^",22) ;;;///病案号

 ;;;////性别
 s sex=##Class(EPRservice.HISInterface.PatientInfoAssist).Gender(papmidr)
 s sexppp=$p($g(sex),"^",2) ///打印直接用的性别

 s REGID=$P($g(^PAPER(papmidr,"PAT",1)),"^",1)  ;;;///登记号
 ;;;//// ;职业(返回代码描述)
 s work=##Class(EPRservice.HISInterface.PatientInfoAssist).Occupation(GetPaperDR,"JiShuiTan")
 s workppp=$P(work,"-",2) ///打印直接用的职业
 s work=0_"^"_workppp

 s prv=$P($g(^PAPER(papmidr,"PER",1)),"^",8)   ;;国家 ;PAPER_ct_Province_DR 
 i prv'="" d
 .s Country=$P($g(^CT("COU",prv)),"^",2) 
 . s Countryppp=$p($g(Country),"-",2) ///打印直接用的国家
 e  s Country=""
 ;; s Country=##Class(EPRservice.HISInterface.PatientInfoAssist).Country(papmidr,"JiShuiTan")

 //////户口地址
 i $d(^PAPER(papmidr,"PER",1))=1 d
 .s hukaddres=$P($g(^PAPER(papmidr,"PER",1)),"^",5) ;PAPER_CityCode_DR户口地址
 .i hukaddres'="" s hukaddres=$p($g(^CT("CIT",hukaddres)),"^",2)
 s hukaddresppp=hukaddres   ;;;$p(hukaddres,"-",2) ///打印直接用的户口地址


 ;;;///户口邮编
 ;;;&sql(select ctzip_rowid into :hukaddres1 from SQLUser.CT_Zip where ctzip_city_dr=:hukaddres )
 ;s hukpost=##Class(EPRservice.HISInterface.PatientInfoAssist).ResidentPostCode(argPaperDR,"JiShuiTan")
 s hukaddres3=$p($G(^PAPER(papmidr,"PER",1)),"^",7)
 ;i hukaddres3'="" s hukpost=$P($g(^CT("ZIP",hukaddres2)),"^",1)_"^"_$P($g(^CT("ZIP",hukaddres2)),"^",1)
 i hukaddres3'="" s hukpost=$P($g(^CT("ZIP",hukaddres3)),"^",1)

 ///住家(家庭)地址//现住址
 f de=1:1:$g(^PAPER(papmidr,"PER","ADD",0)) d 
 .s hukaddres2=$P($G(^PAPER(papmidr,"PER",4)),"^",18)
 .s hukaddres2=$g(^PAPER(papmidr,"PER","ADD",de)) ; ;paper_stnameline1 
 ;.s workaddres2=$g(workaddres)_$g(^PAPER(papmidr,"PER","ADD",de)) ; ;paper_stnameline1 
 ////出生地址
 s birthpl=$P($g(^PAPER(papmidr,"ALL")),"^",18) ;;;///出生地
 s chushengdirowid=birthpl                      ///取省直辖市
 i birthpl'="" s birthpl=birthpl_"^"_$p($g(^CT("CIT",birthpl)),"^",2)
 s birthpl=$P($g(birthpl),"^",2)
 s birthpl=$P($g(birthpl),"-",2)
 f birthpl="" d      ///如无出生地址就用籍贯
 .s birthpl=hukaddres  //华西二院无出生地址
 ;s birthpl=hukaddres2
 s hukaddres=hukaddres2

 ////籍贯///
 s EPRJiGuan="",eprProvrowid="",eprProvrowida=""
 k SQLCODE 
 &sql(select CTCIT_Province_DR->PROV_Desc into :eprProvrowid from SQLUser.CT_City where CTCIT_RowId=:chushengdirowid)
 if SQLCODE=0 s eprProvrowida=$P($g(eprProvrowid),"-",2)

 s EPRJiGuan=eprProvrowida      ////$P(^CT("PROV",prv),"^",3)省
 ;s EPRJiGuan=birthpl_" "_EPRJiGuan ////华西二院合成籍贯 "地区"加"省"
 s EPRJiGuan="1"_"^"_EPRJiGuan ////单独籍贯"省"
 ///////;民族
 ;s ^aachushengdirowid=chushengdirowid_"!"_birthpl_"!!"_eprProvrowid
 if $d(^PAPER(papmidr,"PER",2))=1  d
 .s Nation=$P($g(^PAPER(papmidr,"PER",2)),"^",1)       
 .i Nation'="" s Nation=$p($g(^CT("NAT",Nation)),"^",1)_"^"_$p($p($g(^CT("NAT",Nation)),"^",2),"-",2)
 s Nationppp=$p($g(Nation),"^",2) ///打印直接用的民族


 ;;;///主治医生
 s doc=$P($g(^PAADM(adm)),"^",9) ;^CTPCP({CTPCP_RowId}) 
 i doc'="" s doc=$P($g(^CTPCP(doc,1)),"^",1)_"^"_$P($g(^CTPCP(doc,1)),"^",2)

 ;婚姻状况
 ;s marr=$p($g(^PAADM(adm,1)),"^",1)
 s marry=##Class(EPRservice.HISInterface.PatientInfoAssist).MaritalStatus(papmidr)
 ;.s marry=$p($g(^CT("MAR",marr)),"^",1)_"^"_$p($g(^CT("MAR",marr)),"^",2)
 ;
 s PPPmarital=$P($G(^PAPER(papmidr,"PER",2)),"^",3)
 i PPPmarital'=""  {s PPPmarital=$p($g(^CT("MAR",PPPmarital)),"^",2)
 }
 ;	i marital'=""  {s marital=$p($g(^CT("MAR",marital)),"^",4)_"^"_$p($g(^CT("MAR",marital)),"^",2)}

 ;;;///入院日期?时间////argadmdate是一个重要参数不能修改变量名
 s argadmDateTime=##Class(EPRservice.HISInterface.PatientInfoAssist).AdmDateTime(adm,"JiShuiTan")
 s argadmdate="",argadmtime="",admtime="",admdate=""
 s argadmtime=$p($g(argadmDateTime),",",2)
 s argadmdate=$p($g(argadmDateTime),",",1)  ;;;///前面的日期后面的是时间
 s admtime=$zt(argadmtime,1)
 s admdate=$zd(argadmdate,3)
 s admDateTime=admdate_" "_admtime

 //;;///年龄/ not different from hospitals ;;///年龄(岁/月或者月/天,$zd/$zt 不带单位)///w $zdh("2006-3-3",3)
 s age=##Class(EPRservice.HISInterface.PatientInfoAssist).Ageorg(argbirthday,argadmdate,"DHC-DATA",adm)
 ;;;s ^aasargbirthday=argbirthday_""_argadmdate
 ;;;///转科情况Ageorg("60816","60838","MEDDATA","113")
 ;
 ;;;///就诊科室
 s sdep=##Class(EPRservice.HISInterface.PatientInfoAssist).AdmDept(adm)
 s sdepppp=$p($g(sdep),"^",2) ;;////打印直接用的就诊科室
 ;s zdep=##Class(EPRservice.HISInterface.PatientInfoAssist).TransDept(adm)                                               ;i edept'="" d
 ;s ^aasdep=sdep_""_zdep
 ;.s zdep=cdep ;?a?????e
 ;;;///出院科室(返回代码描述)
 s outdep=##Class(EPRservice.HISInterface.PatientInfoAssist).DisDept(adm) 
 s outdepppp=$p($g(outdep),"^",2) ///打印直接用的

 ;;;///出院病区(返回代码描述)
 s outward=##Class(EPRservice.HISInterface.PatientInfoAssist).DisWard(adm)

 ;;;///转床情况
 s room=""
 s roomAll=##Class(EPRservice.HISInterface.PAADM).transroom(adm)
 s room=$p($g(roomAll),"^",2)
 i room'="" d
 .s room=$p($g(^PAROOM(room)),"",1)_"^"_$p($g(^PAROOM(room)),"",2)

 ;;;///入院次数
 s EPRNo=##Class(EPRservice.HISInterface.PatientInfoAssist).InTimes(papmidr) 
 ;;;///入院病区
 s ward=##Class(EPRservice.HISInterface.PatientInfoAssist).AdmWard(adm)
 s wardppp=$p($g(ward),"^",2) ///打印直接用的入院病区


 ;s ^aaEPRLogonUserNAME = EPRLogonUserNAME_"!!"_temp122_""_hukaddres2
 ;;;///床号 ;取入院科室,病区,床号,日期,时间
 s admdatex="",admtimex="",admDateTimex="",admbedx="",tmpAdmdatex="",admDeptx=""
 d ##class(EPRservice.SystemData).GetLocWardBedAdmdatetime(adm,.admDeptx,.admWardx,.admbedx,.tmpAdmdatex,.admtimex)
 s dmbedx=$p($g(^PAADM(adm)),"^",73)
 i dmbedx'="" d
 .s admbeda=$p($g(dmbedx),"||",1) 
 .s admbedb=$p($g(dmbedx),"||",2)
 .s admbedx=$p($g(^PAWARD(admbeda,"BED",admbedb)),"^",1)
 ////门诊诊断(出院诊断)
 ;s PAOutDiag=##Class(EPRservice.HISInterface.PatientInfoAssist).OutDiag(Adm,"JiShuiTan","MEDDATA")
 ;;;///住院号//医疗保险
 s medicare=""
 s medicare=$P($g(^PAPER(papmidr,"PAT",1)),"^",22)   ;medicare
 ///出院日期
 set TmpDisDateTime=##class(EPRservice.HISInterface.PatientInfoAssist).DisDateTime(adm)
 ///住院天数
 i TmpDisDateTime'=""  d
 .set PAResidentDays=##class(EPRservice.HISInterface.PatientInfoAssist).ResidentDays(TmpAdmDateTime,TmpDisDateTime)


 ///取住院费用InPatCostTrakCare
 s ZYFY="",ZYFYa="",ZYFYb=""
 s ZYFY=##class(EPRservice.HISInterface.PatientInfoAssist).InPatCostTrakCare(adm)
 s FeeNum=$l(ZYFY,"!")
 set MQueryPat=$LB("",fmethod,REGID,name,sex,marry,birthday,work,birthpl,age,Nation,Country,EPRPAID,workaddres,worktel,"",hukaddres2,hukaddres,hukpost,lxman,lxrelt,lxaddres,lxtel,doc,InYear,InMonth,InDay,admdate,admtime,sdep,zdep,room,ward,Bah,medicare,admDateTime,outdep,outward,EPRNo,admbedx,PAOutDiag,EPRJiGuan,TmpDisDateTime,PAResidentDays,sexppp,Nationppp,sdepppp,wardppp,workppp,Countryppp,hukaddresppp,outdepppp,PPPmarital)
 ;set xxMQueryPat=$LB("",fmethod,REGID,name,sex,marry,birthday,work,birthpl,age,Nation,Country,EPRPAID,workaddres,worktel,"",workaddres2,hukaddres,hukpost,lxman,lxrelt,lxaddres,lxtel,doc,InYear,InMonth,InDay,admdate,admtime,sdep,zdep,room,ward,Bah,medicare,admDateTime,outdep,outward,EPRNo,admbedx,PAOutDiag,EPRJiGuan,sexppp,Nationppp,sdepppp,wardppp)
 ;s ^aage1argbirthday=age_""_argbirthday_"^"_name_"-papmidr-"_papmidr_"--"_Nation_"--"_Country_"--"_lxman_"-doc-"_doc_"adm"_adm
 ;s i=0,FeeList="",tmpFee=""
 ;f i=1:1:(FeeNum) d
 ;.s tmpFee=$p(ZYFY,"!",i)
 ;.i tmpFee'="" {s MQueryPat=MQueryPat_$lb($p($p(ZYFY,"!",i),"^",2))}

 s ^aatempxue1=MQueryPat
 ;;s ^aatmpFee=ZYFY_"!!!"_tmpFee
}

ClassMethod UpOrderBill(ArcimCode)
{
 
	s del="^"
	q:ArcimCode=""
	s ArcimId1=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcimCode),""))
	q:ArcimId1="" "1"
	s ArcimId2=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcimCode),ArcimId1,""))
	q:ArcimId2="" "2"
	s ArcimId=ArcimId1_"||"_ArcimId2
	s OrdId1=0,OrdId2=0
	s OrdSttDate=6126
	f  s OrdSttDate=$o(^OEORDi(0,"LocStDtArr","107",0,OrdSttDate)) q:OrdSttDate=""  d
	.f  s OrdId1=$o(^OEORDi(0,"LocStDtArr","107",0,OrdSttDate,OrdId1)) q:OrdId1=""  d
	..f  s OrdId2=$o(^OEORDi(0,"LocStDtArr","107",0,OrdSttDate,OrdId1,OrdId2)) q:OrdId2=""  d
	...s ordstr1=$g(^OEORD(OrdId1,"I",OrdId2,1))
	...s OrdArcimId=$p(ordstr1,del,2)
	...q:$g(OrdArcimId)'=$g(ArcimId)
	...s ordstr2=$g(^OEORD(OrdId1,"I",OrdId2,2))
	...s ordstr3=$g(^OEORD(OrdId1,"I",OrdId2,3))
	...s ordstr9=$g(^OEORD(OrdId1,"I",OrdId2,9))
	...s billstatus=$p(ordstr3,del,5)
	...q:($G(billstatus)'="B")
	...q:(OrdStdate<6127)
	...q:(OrdStdate>6138)
	...s OrdStatus=$p(ordstr1,del,13)
	...Q:($G(OrdStatus)'=1)
	...s UnitCosts=$p(ordstr2,del,13)
	...s OrdStdate=$p(ordstr1,del,9)
	...q:(+UnitCosts'=0)
	...s OrdId=OrdId1_"||"_OrdId2
	...s DspId=0,circleflag=1
	...f  s DspId=$o(^DHCOEDISQTY(0,"OEORI",OrdId,DspId)) q:((DspId="")!(circleflag'=1))  d
	....s DspFlag=$p(^DHCOEDISQTY(DspId),del,7)
	....if DspFlag="C" s circleflag=0
	...q:($g(DspFlag)'="C")
	...;q:OrdId'="2430352||123"
	...w OrdId_"^"_UnitCosts,!
	...;&sql(update sqluser.OE_OrdItem set OEORI_Billed='TB' where Oeori_rowid=:OrdId)
	if ($g(DspFlag)="C") w ArcimCode,!
}

ClassMethod Up()
{
	;s aa="150224B632258^010134B982127^030202BIO2330^030204B232318^030205B570030^030103B461613^100101B210922^100204A932358^140101M253019^140106M531815^140217BSB2189^140225BBK1819^140226B820204^140228BLQ0136^140231BGA0204^250420N050436^2704CIB572391^150311L051653^070439AAU1813^070437A262532^070103B530750^010127BEU8628^010115B3721CB^010132B930758^010156B3721BK^010156B376613^010159BNT4605^010168A180274^010173BAS2259^010306BJO16BP^020609B411626^020115BQQ2291^020406B412202^020301BAG8603^020683BAS2258^030301BDA5801^271635M172804^271802E0121AG^010160B522328^160011B5716BA"
	S aa="030204B232318^030205B570030^100101B210922^140231BGA0204^250420N050436^2704CIB572391^070103B530750^010127BEU8628^010156B3721BK^010156B376613^010168A180274^010173BAS2259^010306BJO16BP^020406B412202^020301BAG8603^020683BAS2258^160011B5716BA"
	s i=1,del="^"
	f  s aaa=$p(aa,del,i) q:aaa=""  d
	.d ..UpOrderBill(aaa)
	.s i=i+1
}

ClassMethod OrdCount()
{
	s Stdate=+$h+1,OrdId1=0,OrdId2=0,i=0
	s del="^"
	f  s OrdId1=$o(^OEORDi(0,"StDt",Stdate,OrdId1)) q:OrdId1=""  d
	.s OrdId2=0
	.;q:OrdId1'=2615629
	.f  s OrdId2=$o(^OEORDi(0,"StDt",Stdate,OrdId1,OrdId2)) q:OrdId2=""  d
	..
	..s Prio=$p(^OEORD(OrdId1,"I",OrdId2,1),del,8)
	..q:((Prio'=5)&(Prio'=8))
	..s charcim=$p(^OEORD(OrdId1,"I",OrdId2,1),"^",2)
	..s ItemCatDR=$p(^ARCIM(+charcim,$p(charcim,"||",2),1),"^",10)
	..s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	..Q:(OrderType="R")
	..s OrdId=OrdId1_"||"_OrdId2
	..;w OrdId,!
	..S DA=$G(A)
	..&SQL(UPDATE sqluser.OE_OrdExec set OEORE_TimeExecuted=:NULL,OEORE_DateExecuted=:DA,OEORE_CTPCP_DR="" WHERE OEORE_OEORI_ParRef=:OrdId)
	..w SQLCODE_" "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)
	..s i=i+1
	w i
}

ClassMethod GetCurrentAdm()
{
	
	s WardId=0,RomId=0,AdmId=0,del="^"
	f  s WardId=$o(^PAADMi("CurrWard",WardId)) q:WardId=""  d
	.s RomId=0
	.f  s RomId=$o(^PAADMi("CurrWard",WardId,RomId)) q:RomId=""  d
	..s AdmId=0
	..f  s AdmId=$o(^PAADMi("CurrWard",WardId,RomId,AdmId)) q:AdmId=""  d
	...;s ^FHQADM(WardId,AdmId)=WardId_"^"_AdmId
	...;s ^FHQADM=$g(^FHQADM)+1
	W $g(^FHQADM)
	q $g(^FHQADM)
}

ClassMethod getsum(adm As %String)
{
  ;d ##class(web.DHCFHQ.DHCFHQTOOLS).getsum("2441076") 
  s rowid="",del="^"
  
  q:'$d(^DHCPB(0,"ADM",adm))
  f  s rowid=$o(^DHCPB(0,"ADM",adm,rowid)) q:rowid=""  d
  .;s PBAmount=$p(^DHCPB(rowid),"^",8)
  .;s PBFlag=$p(^DHCPB(rowid),"^",16)
  .;w !,adm_"^"_PBAmount_"^"_PBFlag
  .s PapmiId=$p(^PAADM(adm),del,1)
  .s PatNo=$p(^PAPER(PapmiId,"PAT",1),del,1)
  .
  .S PatName=$p(^PAPER(PapmiId,"ALL"),del,1)
  .s pbochild=0
  .f  s pbochild=$o(^DHCPB(rowid,"O",pbochild)) q:pbochild=""  d 
  ..s child=0
  ..q:'$d(^DHCPB(rowid,"O",pbochild))
  ..s OrdStDate=$p(^DHCPB(rowid,"O",pbochild),del,12)
  ..q:OrdStDate>61361
  ..f  s child=$o(^DHCPB(rowid,"O",pbochild,"D",child)) q:child=""  d 
  ...s tarrowid=$p(^DHCPB(rowid,"O",pbochild,"D",child),"^",3)
  ...q:tarrowid=""
  ...s TarAcctDr=$p(^DHCTARI(tarrowid),"^",5)
  ...if $g(TarAcctDr)'="" d
  ....s TarAcDr=$p(^DHCTarC("AC",TarAcctDr),del,3)
  ....if $g(TarAcDr)'="" s TarAc=$p(^DHCTarC("TAC",TarAcDr),del,2)
  ....else  s TarAc="无大类对照"
  ...else  s TarAc="无对照"
  ...s PbdBillDate=$p(^DHCPB(rowid,"O",pbochild,"D",child),"^",11)
  ...q:PbdBillDate>61361
  ...s PbdCreateDate=$p(^DHCPB(rowid,"O",pbochild,"D",child),"^",15)
  ...q:(PbdCreateDate>61362)
  ...s PBDUnitPrice=$p(^DHCPB(rowid,"O",pbochild,"D",child),"^",4)
  ...s PBDBillQty=$p(^DHCPB(rowid,"O",pbochild,"D",child),"^",5)
  ...s BDTotalAmount=$p(^DHCPB(rowid,"O",pbochild,"D",child),"^",7)
  ...if $d(^FHQADMPATNO(PatNo,TarAc)) S $p(^FHQADMPATNO(PatNo,TarAc),del,4)=$p(^FHQADMPATNO(PatNo,TarAc),del,4)+BDTotalAmount
  ...ELSE  S ^FHQADMPATNO(PatNo,TarAc)=PatNo_del_PatName_del_TarAc_del_BDTotalAmount
  ...s ^patsum=$g(^patsum)+BDTotalAmount
  ...if BDTotalAmount<0 s ^fhqsuma=$g(^fhqsuma)+BDTotalAmount
  ...s PBDBillStatus=$p(^DHCPB(rowid,"O",pbochild,"D",child),"^",14)
  ...;w !,desc_"^"_PBDUnitPrice_"^"_PBDBillQty_"^"_BDTotalAmount_"^"_PBDBillStatus
  ...;w rowid_"||"_pbochild_"||"
  q 0
}

ClassMethod GetCurrentCosts()
{
   
	;d ##class(web.DHCFHQ.DHCFHQTOOLS).GetCurrentCosts()
	s WardId=0,AdmId=0
	;k ^FHQADMPATNO
	;k ^patsum
	;f  s WardId=$o(^FHQADM(WardId)) q:WardId=""  d
	;.s AdmId=0
	;.f  s AdmId=$o(^FHQADM(WardId,AdmId)) q:AdmId=""  d
	;..s RetStr=..getsum(AdmId)
	S PatNo=0
	f  s PatNo=$o(^FHQADMPATNO(PatNo)) q:PatNo=""  d
	.s TarAc=0
	.f  s TarAc=$o(^FHQADMPATNO(PatNo,TarAc)) q:TarAc=""  d
	..w $g(^FHQADMPATNO(PatNo,TarAc)),!
}

ClassMethod Getnopb()
{
   
	s del="^"
	S PbId=5070000
	;S PbId=5336120
	f  s PbId=$o(^|"DHC-TEST"|DHCPB(PbId)) q:PbId=""  d
	.S TMP=$G(^|"DHC-TEST"|DHCPB(PbId))
	.;w PbId_"^"_TMP,!
	.q:$d(^DHCPB(PbId))
	.if $d(^DHCBCI(0,"Bill",PbId)) w PbId_"^"_TMP,!
	.;m ^DHCPB(PbId)=^|"DHC-TEST"|DHCPB(PbId)
	.;s PbSubId=0
	.;f  s PbSubId=$o(^|"DHC-TEST"|DHCPB(PbId,"O",PbSubId)) q:PbSubId=""  d
	.;.;s ArcimId=$p(^|"DHC-TEST"|DHCPB(PbId,"O",PbSubId),del,3)
	.;.;s OrdId=$p(^|"DHC-TEST"|DHCPB(PbId,"O",PbSubId),del,4)
	.;.;s ^DHCPBi(0,"ARCIM",ArcimId,PbId,PbSubId)=""
	.;.;s ^DHCPBi(0,"OEORI",OrdId,PbId,PbSubId)=""
	.
}

ClassMethod Getinv()
{
   
	s del="^"
	s prtdate=61424
	f  s prtdate=$o(^DHCINVPRT(0,"Date",prtdate)) q:prtdate=""  d
	.s invid=0
	.
	.f  s invid=$o(^DHCINVPRT(0,"Date",prtdate,invid)) q:invid=""  d
	..s invamount=0,amount=0
	..s invamount=$p(^DHCINVPRT(invid),del,1)
	..s bciid=0,amount1=0
	..f  s bciid=$o(^DHCBCI(0,"INV",invid,bciid)) q:bciid=""  d
	...s pbid=$p(^DHCBCI(bciid),del,2)
	...s pboid=0
	...f  s pboid=$o(^DHCPB(pbid,"O",pboid)) q:pboid=""  d
	....s pbdid=0
	....f  s pbdid=$o(^DHCPB(pbid,"O",pboid,"D",pbdid)) q:pbdid=""  d
	.....s amount=$p(^DHCPB(pbid,"O",pboid,"D",pbdid),del,7)
	.....s amount1=amount1+amount
	...if pbid="5333769" w "aaa"
	...if $g(pbid)="" w bciid,!
	...if '$d(^DHCPB(pbid)) w invid_"^"_pbid,!
	...;q:$d(^DHCBCI(0,"INV",invid))
	...;w invid_" "
	..if invamount'=amount1 w invid_"^"_amount1_"^"_invamount,!
}

ClassMethod GetCardInfo()
{
	//d ##class(web.DHCFHQ.DHCFHQTOOLS).GetCardInfo()
	s del="^"
	s CfId=0,CardTypeDr=0
	f  s CardTypeDr=$o(^DHCCARDi("CF",0,"CardTypeNo",CardTypeDr)) q:CardTypeDr=""  d
	.q:CardTypeDr=16
	.s CardNo=0
	.f  s CardNo=$o(^DHCCARDi("CF",0,"CardTypeNo",CardTypeDr,CardNo)) q:CardNo=""  d
	..s CfId=0
	..f  s CfId=$o(^DHCCARDi("CF",0,"CardTypeNo",CardTypeDr,CardNo,CfId)) q:CfId=""  d
	...s PapmiId=$p(^DHCCARD("CF",CfId),del,4)
	...q:$g(PapmiId)=""
	...S Country="1",Province="1",City="1"
	...s CountryId=$p(^PAPER(PapmiId,"PER",1),del,8)
	...if $g(CountryId)'="" S Country=$p($g(^CT("COU",CountryId)),del,2)
	...s ProvinceId=$p($G(^PAPER(PapmiId,"PER",4)),del,2)
	...if $g(ProvinceId)'="" s Province=$p($g(^CT("PROV",ProvinceId)),del,2)
	...else  s Province="1"
	...s CityId=$p($G(^PAPER(PapmiId,"PER",1)),del,5)
	...if $g(CityId)'="" s City=$p($g(^CT("CIT",CityId)),del,2)
	...else  s City="1"
	...s ^DHCFHQP(CardTypeDr,$g(Country),$g(Province),$g(City))=+$g(^DHCFHQP(CardTypeDr,$g(Country),$g(Province),$g(City)))+1
	...;if '$d(^DHCPAPER(CardTypeDr,CountryId,ProvinceId,CityId)) s ^DHCPAPER(CardTypeDr,CountryId,ProvinceId,CityId)=1
}

ClassMethod DepositFind()
{
	s i=112108
	f  s i=i+1 q:i>113029  d
	.d ##class(web.DHCFHQ.DHCFHQTOOLS).UpDepositIndex(i)
}

ClassMethod UpDepositIndex(PrtRowid)
{
	//d ##class(web.DHCFHQ.DHCFHQTOOLS).UpDepositIndex(115748)
	 //112270  115748 	
 // UPDEPINDEX(PrtRowid)
  //d UPDEPINDEX^FHQTOOLS(112270)
	 //112270
	  s PrtRowid=$g(PrtRowid)
	  s del="^"
  q:(PrtRowid="") "Null"
  //prtadduserid
  s prtadduserid=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",14)
  i $g(prtadduserid)'=""  d
  .IF '$D(^DHCSFPRINTDETAIL(0,"AddUser",prtadduserid,PrtRowid)) D
  ..W " "_PrtRowid_del_prtadduserid
  
  //prtadmdr
  s prtadmdr=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",4)
  i $g(prtadmdr)'=""  d
  .IF '$D(^DHCSFPRINTDETAIL(0,"adm",prtadmdr,PrtRowid)) D
  ..W " "_PrtRowid_del_prtadmdr 
  s AdmLocDr=$p(^PAADM(prtadmdr),del,4)
  s PapmiId=$p(^PAADM(prtadmdr),del,1)
  //prtbank
  s prtbank=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",10)
  i $g(prtbank)'=""  d
  .IF '$D(^DHCSFPRINTDETAIL(0,"Bank",prtbank,PrtRowid)) D
  ..W " "_PrtRowid_del_prtbank
  
  //prtcardno
  s prtcardno=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",11)
  i $g(prtcardno)'=""  d
  .IF '$D(^DHCSFPRINTDETAIL(0,"CardNo",prtcardno,PrtRowid)) D
  ..W " "_PrtRowid_del_prtcardno
  
  //prtcomment1
  s prtcomment1=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",32)
  i $g(prtcomment1)'=""  d
  .IF '$D(^DHCSFPRINTDETAIL(0,"COM1",prtcomment1,PrtRowid)) D
  ..W " "_PrtRowid_del_prtcomment1
  
  //prtcomment2
  s prtcomment2=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",33)
  i $g(prtcomment2)'=""  d
  .IF '$D(^DHCSFPRINTDETAIL(0,"COM2",prtcomment2,PrtRowid)) D
  ..W " "_PrtRowid_del_prtcomment2
  
  //prtcomment3
  s prtcomment3=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",34)
  i $g(prtcomment3)'=""  d
  .IF '$D(^DHCSFPRINTDETAIL(0,"COMM3",prtcomment3,PrtRowid)) D
  ..W " "_PrtRowid_del_prtcomment3
  
  //prtcomment4
  s prtcomment4=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",35)
  i $g(prtcomment4)'=""  d
  ..IF '$D(^DHCSFPRINTDETAIL(0,"COM4",prtcomment4,PrtRowid)) D
  ..W " "_PrtRowid_del_prtcomment4
  
  //prtcompany
  s prtcompany=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",12)
  i $g(prtcompany)'=""  d
  .IF '$D(^DHCSFPRINTDETAIL(0,"Company",prtcompany,PrtRowid)) D
  ..W " "_PrtRowid_del_prtcompany
  
  //prtcurrdeptdr
  s prtcurrdeptdr=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",37)
  i $g(prtcurrdeptdr)'=""  d  
  .IF '$D(^DHCSFPRINTDETAIL(0,"CurrDept",prtcurrdeptdr,PrtRowid)) D
  ..W " "_PrtRowid_del_prtcurrdeptdr
  
  //prtcurrwarddr
  s prtcurrwarddr=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",36)
  i $g(prtcurrwarddr)'=""  d
  .IF '$D(^DHCSFPRINTDETAIL(0,"CurrWard",prtcurrwarddr,PrtRowid)) D
  ..W " "_PrtRowid_del_prtcurrwarddr
  
  //prtdepositdr
  s prtdepositdr=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",13)
  i $g(prtdepositdr)'=""  d
  .IF '$D(^DHCSFPRINTDETAIL(0,"DepType",prtdepositdr,PrtRowid)) D
  ..W " "_PrtRowid_del_prtdepositdr
  
  //prtjkdate
  s prtjkdate=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",21)
  i $g(prtjkdate)'=""  d
  .IF '$D(^DHCSFPRINTDETAIL(0,"JkDate",prtjkdate,PrtRowid)) D
  ..W " "_PrtRowid_del_prtjkdate 
  
  //prtjkdr
  s prtjkdr=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",30)
  i $g(prtjkdr)=""  d
  .IF '$D(^DHCSFPRINTDETAIL(0,"JKDR",prtjkdr,PrtRowid)) D
  ..W " "_PrtRowid_del_prtjkdr 
  
  //prtjkuser
  s prtjkuser=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",20)
  i $g(prtjkuser)'=""  d
  .IF '$D(^DHCSFPRINTDETAIL(0,"JkUser",prtjkuser,PrtRowid)) D
  ..W " "_PrtRowid_del_prtjkuser 
  
  //prtpayamount
  s prtpayamount=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",6)
  i $g(prtpayamount)'=""  d
  .IF '$D(^DHCSFPRINTDETAIL(0,"PayAmt",prtpayamount,PrtRowid)) D
  ..W " "_PrtRowid_del_prtpayamount
  
  //prtpaymode
  s prtpaymode=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",9)
  i $g(prtpaymode)'=""  d
  .IF '$D(^DHCSFPRINTDETAIL(0,"PayMode",prtpaymode,PrtRowid)) D
  ..W " "_PrtRowid_del_prtpaymode
  
  //prtprintdate
  s prtprintdate=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",2)
  i $g(prtprintdate)'=""  d
  .IF '$D(^DHCSFPRINTDETAIL(0,"PrtDate",prtprintdate,PrtRowid)) D
  ..W " "_PrtRowid_del_prtprintdate 
  
  //prtprinttime
  s prtprinttime=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",3)
  i $g(prtprinttime)'=""  d
  .IF '$D(^DHCSFPRINTDETAIL(0,"PrtTime",prtprinttime,PrtRowid)) D
  ..W " "_PrtRowid_del_prtprinttime
  
  //prtrcptdr
  s prtrcptdr=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",5)
  i $g(prtrcptdr)'=""  d
  .s ^DHCSFPRINTDETAIL(0,"RcptDR",prtrcptdr,PrtRowid)=""
  .;补ar_rcptalloc 表arral_admission_dr索引
  .i $g(prtadmdr)'=""  d
  ..if (('$d(^ARRCP(prtrcptdr,"RAL",1)))!('($D(^ARRCP(prtrcptdr,"PAYM",1))))) d 
  ...w "&"_prtrcptdr
 s prtrcptno=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",1)
 i $g(prtrcptno)'=""  d  
 .IF '$D(^DHCSFPRINTDETAIL(0,"RcptNo",prtrcptno,PrtRowid)) D
 ..W " "_PrtRowid_del_prtrcptno 
 
 //prtrefundrcpt
 s prtrefundrcpt=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",7)
 i $g(prtrefundrcpt)'=""  d
 .IF '$D(^DHCSFPRINTDETAIL(0,"RefundRcpt",prtrefundrcpt,PrtRowid)) D
  ..W " "_PrtRowid_del_prtrefundrcpt 
 
 //prtstatus
 s prtstatus=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",8)
 i $g(prtstatus)'=""  d
 .IF '$D(^DHCSFPRINTDETAIL(0,"Status",prtstatus,PrtRowid)) D
  ..W " "_PrtRowid_del_prtstatus 
 
 //prtyjrefreasondr
 s prtyjrefreasondr=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",31)
 i $g(prtyjrefreasondr)'=""  d
 .IF '$D(^DHCSFPRINTDETAIL(0,"RReason",prtyjrefreasondr,PrtRowid)) D
 ..W " "_PrtRowid_del_prtyjrefreasondr,!
 q
}

ClassMethod UpPaadm(AdmId)
{
	//d ##class(web.DHCFHQ.DHCFHQTOOLS).UpPaadm(4257180)
	//4257180 
	s del="^"
 q:AdmId="" ""
 s papmirid=""
 s papmirid=$p(^PAADM(AdmId),del,1)
 s AdmType=$p(^PAADM(AdmId),del,2)
 if papmirid'="" s ^PAPERdr(papmirid,"ADM",AdmType,AdmId)=""
 if AdmType'="" s ^PAADMi("PAADM_Type",AdmType,AdmId)=""
 s patno=+$p(^PAPER(papmirid,"PAT",1),del,1)
 s patname=$p(^PAPER(papmirid,"ALL"),del,1)
 s patname2=$p(^PAPER(papmirid,"ALL"),del,2)
 s sexrid=$p(^PAPER(papmirid,"ALL"),del,7)
 S sex=$p(^CT("SEX",sexrid),del,2)
 S telh=$p(^PAPER(papmirid,"PER",1),del,11)
 s meddiscdate=""
 s finaldiscdate=$p(^PAADM(AdmId),"^",17)
 s birthday=$P(^PAPER(papmirid,"ALL"),del,6)
 s age=$e($zd($H,8),1,4)-$e($zd(birthday,8),1,4)
 s birthday=$zd(birthday,3)
 s admdate=$p(^PAADM(AdmId),del,6)
 IF admdate'="" s ^PAADMi("PAADM_AdmDate",admdate,AdmId)=""
 s admtime=$p(^PAADM(AdmId),del,7)
 s admlocrid=$p(^PAADM(AdmId),del,4)
 if admlocrid'="" s ^PAADMi("CurrLoc",admlocrid,admdate,admtime,AdmId)=""

 S insutype=$p(^PAADM(AdmId,1),del,6)
 s pattype=$p(^PAADM(AdmId,1),del,7)
 s patstatus=$p(^PAADM(AdmId),del,20)
 if patstatus'="" s ^PAADMi("PAADM_VisitStatus",patstatus,AdmId)=""
 S doctor=$p(^PAADM(AdmId),del,9) 
 S wardrid=$p(^PAADM(AdmId),del,70)
 s roomrid=$p(^PAADM(AdmId),del,69)
 s bedrid=$p(^PAADM(AdmId),del,73)
 if wardrid'="" s ^PAADMi("CurrWard",wardrid,+roomrid,AdmId)=""
 q
}

ClassMethod SetTable()
{
	s StartStr="Tmpwebsys.ComponentTableItems"
	s EndStr="XML.Abstract",i=1
	f  s StartStr=$o(^oddCOM(StartStr)) q:StartStr=EndStr  d
	.s ^FhqTable(i)=$g(^oddCOM(StartStr,53))
	.s i=i+1
}

ClassMethod UserDev(paras)
{
	s i=0
	s del="^"
	s RoleStr=$p(paras,del,1),Operator=$p(paras,del,2)
	q:RoleStr="" "role 为空"
	q:Operator="" "operator 为空"
	q:((Operator'="i")&(Operator'="u")&(Operator'="s")&(Operator'="d")) Operator_"操作符不存在"
	Q:'$d(^["%SYS"]SYS("Security","RolesD",RoleStr)) RoleStr_"不存在"
	f  s i=$o(^FhqTable(i)) q:i=""  d
	.q:$g(^FhqTable(i))=""
	.s TableTmp=1_","_$g(^FhqTable(i))
	.s TempStr=TableTmp_"||"_Operator_"||"_RoleStr_"||_SYSTEM"
	.S ^["%SYS"]SYS("Security","SQL","priv","DHC-APP",0,TableTmp,Operator,RoleStr,"_SYSTEM") = 0
    .s ^["%SYS"]SYS("Security","SQL","priv","DHC-APP","m",RoleStr,TempStr) = ""
}

}
