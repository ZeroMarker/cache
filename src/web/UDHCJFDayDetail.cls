Import SQLUser

/// 病区日清明细
Class web.UDHCJFDayDetail Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 692;

Query FindWard() As websys.Query(ROWSPEC = "warddesc:%String,rowid:%String")
{
}

/// do ##class(%ResultSet).RunQuery("web.UDHCJFDayDetail","FindWard")
ClassMethod FindWardExecute(ByRef qHandle As %Binary) As %Status
{
	set repid=$I(^CacheTemp)
    set ind=1
    set rowid="0"
    for  set rowid=$o(^PAWARD(rowid)) quit:(rowid="")  do
    .set wardInfo=$g(^PAWARD(rowid))
    .quit:(wardInfo="")
    .set usrname=$p(wardInfo,"^",2)
    .do OutputRow
    
    set qHandle=$lb(0,repid,0)
	quit $$$OK
OutputRow
	set Data=$lb(usrname,rowid)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

Query FindType() As websys.Query(ROWSPEC = "type:%String,rowid:%String")
{
}

ClassMethod FindTypeExecute(ByRef qHandle As %Binary) As %Status
{
	set repid=$I(^CacheTemp)
    set ind=1
    set rowid="0"
    for  set rowid=$o(^DHCTarC("TIC",rowid)) quit:(rowid="")  do
    .set tarcInfo=$g(^DHCTarC("TIC",rowid))
    .quit:(tarcInfo="")
    .set type=$p(tarcInfo,"^",2)
    .do OutputRow1
    
    set qHandle=$lb(0,repid,0)
	quit $$$OK
OutputRow1
	set Data=$lb(type,rowid)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

Query FindDetail(stdate As %String, enddate As %String, wardid As %String, typeid As %String, RegNo As %String, hbflag As %String, orddeptid As %String, orddept As %String, DepGroup As %String, DepGroupid As %String, Guser, RegAdm As %String = "", type) As websys.Query(ROWSPEC = "Tpatname:%String,Ttype:%String,Titm:%String,Tqty:%String,Tuom:%String,Tunitprice:%String,Tsum:%String,Tjob:%String,Tdate:%String,Ttime:%String,Tzfbl:%String,TYBFL:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.UDHCJFDayDetail","FindDetail",64613,64657,"","","0000009377",1,"","","","",671,"","")
ClassMethod FindDetailExecute(ByRef qHandle As %Binary, stdate As %String, enddate As %String, wardid As %String, typeid As %String, RegNo As %String, hbflag As %String, orddeptid As %String, orddept As %String, DepGroup As %String, DepGroupid As %String, Guser, RegAdm As %String = "", type) As %Status
{
	set repid=$I(^CacheTemp)
    set ind=1
	set gnum=0
    if ($g(Guser)="") set Guser=%session.Get("LOGON.USERID")
   	s stdate=##class(websys.Conversions).DateHtmlToLogical(stdate)
	s enddate=##class(websys.Conversions).DateHtmlToLogical(enddate)
	
    k ^mtemp(Guser,$j,"Detail")
    k ^mtemp(Guser,$j,"PackNum")
    k ^mtemp(Guser,$j,"PackUom")
    k ^TMP("UDHCJFDay","PRINT",Guser)
    k ^TMP("UDHCJFDay","final","PRINT",Guser)
    k ^TMP("Details",Guser,$j)
    s ^TMP("RegNo",Guser,$j)=""
    d ..GetTICInfo()
    
    f j=1:1:$g(^DHCICGRP) d
    .s ^catefee(+RegNo,$p(^DHCICGRP(j),"#",1))=0
    
    i (RegNo'="") d
    .k ^TMP("Details",Guser,$j)
    .d ..GetPatDetail(RegNo,stdate,enddate,typeid,RegNo,orddeptid,DepGroupid,RegAdm)
    i ((wardid'="")&&(RegNo="")) d
    .k ^TMP("Details",Guser,$j)
    .s patnostr=..GetDeptPat(wardid,stdate,enddate)
    .s num=$l(patnostr,"^")
    .s no=""
    .f  s no=$o(^TMP("ZYJFBED",Guser,$j,no)) q:(no="")  d
    ..s RegNo=^TMP("ZYJFBED",Guser,$j,no)
    ..f j=1:1:$g(^DHCICGRP) d
    ...s ^catefee(+RegNo,$p(^DHCICGRP(j),"#",1))=0
    ..d ..GetPatDetail(RegNo,stdate,enddate,typeid,wardid,orddeptid,DepGroupid,RegAdm)

	k ^TMP("ZYJFBED",Guser,$j)  
	set qHandle=$lb(0,repid,0)
	quit $$$OK
}

ClassMethod FetchLocInfo(LocTypeDesc As %String)
{
	s DATAID=0
	s P1=0
	k PLIST
 	&sql(DECLARE LocCur CURSOR	FOR select LOC_CTLOC_DR, LOC_CTLOC_DR->CTLOC_DESC
	    from CT_LocationList_Locations WHERE LOC_PARREF=:TypeRowID)
 	s TypeRowID=""
 	&sql(SELECT LL_ROWID INTO :TypeRowID FROM CT_LocationList WHERE LL_DESC=:LocTypeDesc)
	q:(TypeRowID="")
 	&sql(open LocCur)
 	f  &sql(fetch LocCur into :LocID,:Locname ) q:SQLCODE  d
  	.i (Locname'="")  d
    ..s DATAID=DATAID+1
    ..s PLIST(DATAID)=LocID_"#"_Locname
 	&sql(close LocCur)
 	s PLIST=DATAID
 	s P1=DATAID
 	q
}

ClassMethod GetTICInfo()
{
 	k PLIST
 	s Num=0
 	k ^DHCICGRP
 	s rowid=0
 	f  s rowid=$o(^DHCTarC("TIC",rowid)) q:(rowid="")  d
 	.s BillGrpDesc=$p(^DHCTarC("TIC",rowid),"^",2)
 	.s BillGrpCode=$p(^DHCTarC("TIC",rowid),"^",1)
 	.q:(BillGrpDesc="")
 	.s Num=Num+1
 	.s PLIST(Num)=BillGrpDesc_"#"_BillGrpCode_"#Y"
 	.s ^DHCICGRP(Num)=BillGrpDesc_"#"_BillGrpCode_"#Y"
 	.s ^DHCICGRP=Num

 	s PLIST=Num
 	s ^DHCICGRP=Num
 	s P1=Num
 	q
}

ClassMethod GetName(RegNo As %String)
{
 	s P1=""
 	&sql(select PAPMI_NAME  into :P1 FROM PA_PATMAS WHERE PAPMI_NO=:RegNo )
 	q 0
}

/// 找出病区所有符合条件的病人登记号
ClassMethod GetDeptPat(wardId As %String, stdate As %String, enddate As %String) As %String
{
 	k ^mtemp(Guser,$j,"DetailRes"), ^TMP("Details",Guser,$j), ^TMP("ZYJFBED",Guser,$j)
 	s P1=""
	//s admId=""
	//f  s admId=$o(^PAADMi("AdmTypeCurr","I",admId)) q:(admId="")  d
    q:(wardId="") ""
    s RoomId="0"
	f  s RoomId=$O(^PAADMi("CurrWard",wardId,RoomId)) quit:(RoomId="")  d
	.q:(+RoomId=0)
	.s admId=""
	.f  s admId=$O(^PAADMi("CurrWard",wardId,RoomId,admId)) q:(admId="")  d
	..s num=+$g(num)+1
	..q:'$d(^PAADM(admId))
	..s curWardId=$p(^PAADM(admId),"^",70) 
	..s visitstatus=$p(^PAADM(admId),"^",20)
	..q:visitstatus="C"
	..//q:curWardId=""
	..//q:(curWardId'=wardId)
	..s admdate=$p(^PAADM(admId),"^",6)
	..//q:admdate>enddate
	..s disdate=$p(^PAADM(admId),"^",17)
	..//q:(disdate<enddate)&(disdate'="")
	..//q:(disdate'="")&(disdate<+$H) 
	..s bedrowid=$p(^PAADM(admId),"^",73)
	..//q:(bedrowid="")
	..s bedname=num
	..i ($g(bedrowid)'="")  d
	...s wardid=$p(bedrowid,"||",1),bedid=$p(bedrowid,"||",2)
	...s bedname=$p(^PAWARD(wardid,"BED",bedid),"^",1)
	...i (bedname["+") s bedname="加"_$Number(bedname)
	...e  i ($Number(bedname)'="")  s bedname=$Number(bedname)
	..s papno=$p(^PAPER(+^PAADM(admId),"PAT",1),"^",1)
	..s ^TMP("ZYJFBED",Guser,$j,bedname)=papno
	i $d(^TMP("ZYJFBED",Guser,$j)) d
	.s bedname=""
	.f  s bedname=$o(^TMP("ZYJFBED",Guser,$j,bedname)) q:(bedname="")  d
	..s papno=^TMP("ZYJFBED",Guser,$j,bedname)
	..i (P1'="") s P1=P1_"^"_papno
	..e  s P1=papno
    
	q P1
}

/// w ##class(web.UDHCJFDayDetail).GetPatDetail("0000022014","63572","63573","","0000022014","","")
ClassMethod GetPatDetail(RegNo As %String, stdate As %String, enddate As %String, typeid As %String, bq As %String, orddeptid, DepGroupid, regAdm As %String = "")
{
	k P1,P3
	s RowID=0,sum=0
	s PatFeeByDate=0
 	q:(RegNo="")
 	s Tmpname="",Tmpbed=""
 	q:'$d(^PAPERi("PAPMI_PatNo",RegNo))
 	s papmi=$o(^PAPERi("PAPMI_PatNo",RegNo,""))  //papmi_rowid
 	s papname=$p(^PAPER(papmi,"ALL"),"^",1)      //病人姓名
  	//add by wangjian 2015-01-15 增加病人密级和级别
    s EncryptLevel="",PatLevel=""
    s PatEncryptLevel=##class(web.UDHCJFBaseCommon).GetPatEncryptLevel(papmi, "")
    s EncryptLevel=$p(PatEncryptLevel,"^",1)
    s PatLevel=$p(PatEncryptLevel,"^",2)
    //end
 	s Tmpname=papname
 	s myRegAdm=regAdm
	i (myRegAdm="") s myRegAdm=..GetCurAdm(RegNo)
 	s admId=0
 	s deposit=0
 	f  s admId=$o(^PAPERdr(papmi,"ADM","I",admId)) q:(admId="")  d     //取住院病人admId
 	.q:'$d(^PAADM(admId))
 	.q:((myRegAdm'=admId)&&(myRegAdm'=""))
 	.s Admreasomdr=$p(^PAADM(admId,1),"^",7)
 	.s deprowid=$p(^PAADM(admId),"^",4)
 	.s locname=""
 	.i (deprowid'="") s locname=$p(^CTLOC(deprowid),"^",2)
 	.s wardid=$p(^PAADM(admId),"^",70)
	.s ward=""
 	.i (wardid'="") s ward=$p(^PAWARD(wardid),"^",2)
 	.i (ward["-") s ward=$p(ward,"-",2)
 	.s visitstatus=$p($g(^PAADM(admId)),"^",20)
 	.s bedrowid=$p(^PAADM(admId),"^",73)
 	.s bedname=""
 	.i (visitstatus="A") d
 	..i (bedrowid'="")  d
 	...s wardid=$p(bedrowid,"||",1),bedid=$p(bedrowid,"||",2)
 	...s bedname=$p(^PAWARD(wardid,"BED",bedid),"^",1)
 	...i (bedname["+") s bedname="加"_$number(bedname)
 	...s Tmpbed=bedname         //保存临时
 	...s papname=papname_" 床号:"_bedname   ;_" 级别:"_PatLevel_" [密级:"_EncryptLevel_"]"  先注释
 	.e  d
 	..s bedname="已出院"
 	.i (Tmpbed="") s TmpBed="无床位"
 	.//q:(visitstatus'="A")          //yyx,去掉后可以查出院病人的日清明细。
 	.//s deposit=##class(web.UDHCJFORDCHK).deposit(admId)
 	.s bill=0
 	.s oeqty=0,patfee=0,patshare=0,paidfee=0
 	.f  s bill=$o(^DHCPB(0,"ADM",admId,bill)) q:(bill="")  d  
 	..d ..GetPatFeeInfo(admId,bill)  ;根据病人取帐单号
 	..s payedflag=$p(^DHCPB(bill),"^",16)
 	..//q:(payedflag="P")
 	..s expflag="", billtot=0, pvtot=0, expamt=0, billflag1=""
 	..s order=0 
 	..f  s order=$o(^DHCPB(bill,"O",order)) q:(order="")  d
 	...q:($d(^DHCPB(bill,"O",order))=10)
 	...s prtordflag="N"
 	...s oerowid=$p($g(^DHCPB(+bill,"O",order)),"^",4)    //YYX增加，判断医嘱不存在，则过滤掉
 	...q:(oerowid="")
 	...q:'$d(^OEORD($p(oerowid,"||",1),"I",$p(oerowid,"||",2)))
 	...s CP=..GetCP(admId, oerowid)    //获取计费点
 	...s orddept=$p($g(^OEORD($p(oerowid,"||",1),"I",$p(oerowid,"||",2),7)),"^",2)
 	...s OrdStDate=$p($g(^OEORD($p(oerowid,"||",1),"I",$p(oerowid,"||",2),1)),"^",9)     //医嘱开始日期
 	...s OrdXDate=$p($g(^OEORD($p(oerowid,"||",1),"I",$p(oerowid,"||",2),3)),"^",34)     //医嘱停止日期
 	...s excrowid=$p($g(^DHCPB(+bill,"O",order)),"^",20) 
 	...s ExcStDate=$p(^OEORD($p(excrowid,"||",1),"I",$p(excrowid,"||",2),"X",$p(excrowid,"||",3)),"^",1)
 	...s ExcXDate=$p(^OEORD($p(excrowid,"||",1),"I",$p(excrowid,"||",2),"X",$p(excrowid,"||",3)),"^",12)
 	...q:((orddept'=orddeptid)&&(orddeptid'=""))
 	...i (orddept'="") s ordgrp=$p(^CTLOC(orddept),"^",19)
 	...q:($g(DepGroupid)'=$g(ordgrp))&&($g(DepGroupid)'="")
 	...s PackStr=##class(web.DHCNurDrugAudit).GetPackQty(+oerowid,$p(oerowid,"||",2))
 	...//s billdesc=$p(^OEORD(+oerowid,"I",$p(oerowid,"||",2),2),"^",12)
 	...//取收费项目明细
 	...s itm=0 
 	...f  s itm=$o(^DHCPB(+bill,"O",order,"D",itm)) q:((itm="")||(prtordflag="Y"))  s s=^(itm) d   //收费项目明细
 	....s tariDesc=""
 	....s itmrowid=bill_"||"_order_"||"_itm
 	....s billdate=$p(s,"^",11),billtime=$p(s,"^",12),billstatus=$p(s,"^",14)   //yyx 06-12-07
 	....s PBDFee=$p(s,"^",7)
 	....i ((CP="OD")&&(ExcStDate>ExcXDate)&&(ExcXDate'=0)) s billdate=ExcStDate
 	....i (billdate<=enddate) s PatFeeByDate=PatFeeByDate+PBDFee
 	....q:((billdate<stdate)||(billdate>enddate))
 	....s taritm=$p(s,"^",3)
 	....q:(taritm="")
 	....s tarinpat=$p(^DHCTARI(taritm),"^",14)
 	....s tariChargeBasis=$p(^DHCTARI(taritm),"^",20)       //取物价编码
 	....i (tarinpat'="")  d
 	.....s taric=$p(^DHCTarC("IC",tarinpat),"^",3)          //收费项目住院分类
 	....q:((typeid'="")&&(typeid'=taric))
 	....//判断如果医嘱子类定义了打印医嘱项则按照医嘱项打印，否则打印收费项目
 	....s arcimid=$p($g(^DHCPB(bill,"O",order)),"^",3)
 	....s itemcat=$p(^ARCIM(+arcimid,$p(arcimid,"||",2),1),"^",10)
 	....i ($d(^DHCJFORDITEMCATSET(0,"ItemCat",itemcat))) d
 	.....//打印医嘱项
	.....s prtordflag="Y"
 	.....d ..GetOrder(bill, order)
 	....e  d
 	.....//打印收费项
 	.....d ..GetDetail(bill, order, itm, Admreasomdr, admId)

 	i (hbflag="1") d
 	.d ..ListHz(RegNo,sum,hbflag,bq,deposit,Tmpname,Tmpbed)
 	i (hbflag="0") d
 	.d ..ListDetail(RegNo,sum,hbflag,bq,deposit,Tmpname,Tmpbed)
 	
 	q
}

ClassMethod GetPatFeeInfo(admId, bill)
{
	s admreason=$p($g(^PAADM(admId,1)),"^",7)
	s admreasondesc="自费"
	i (admreason'="") d
	.s admreasondesc=$P(^PAC("ADMREA",admreason),"^",2)

	s deposit=##class(web.UDHCJFBaseCommon).deposit(admId)
	s patfee1=0,patshare1=0,insuzfsum=0
	s feestr=..Computing(bill, "", enddate)
	s patfee1=+$p(feestr,"^",1)
	s patshare1=+$p(feestr,"^",4)
	s insuzfsum=+$p(feestr,"^",5)
	s patfee=patfee+patfee1
	s patshare=patshare+patshare1

	q
}

/// 找到病区的所有病人
ClassMethod List(num As %String, jj As %String)
{
	s P2=$g(^mtemp(jj,"DetailRes",num))
	i num=$o(^mtemp(jj,"DetailRes",""),-1) k ^mtemp(jj)
	q P2
}

ClassMethod ListPat(RegNo As %String, sum As %String, hbflag As %String)
{
 	i (hbflag="0") d
	.d ..ListHz()
	i (hbflag="1") d
	.d ..ListDetail()
	q
}

ClassMethod getpatno(jj, Guser)
{
 	s patstr=$g(^TMP("RegNo",Guser,jj))
 	q patstr
}

ClassMethod getNo(jj, Guser)
{
	s No=$o(^TMP("Details",Guser,jj,""))
	q No
}

ClassMethod getnum(itmjs As %Library.String = "", itmjsex As %Library.String = "", jj, bq, regno, Guser)
{
  	s gnum=$o(^TMP("Details",Guser,jj,bq,regno,""),-1)
  	q gnum
}

ClassMethod getdata(itmjs As %Library.String = "", itmjsex As %Library.String = "", jj, bq, regno, num, Guser)
{
	s str=^TMP("Details",Guser,jj,bq,regno,num)
	q str
}

ClassMethod ListHz(regNo, sum, hbflag, bq, deposit, Tmpname, Tmpbed)
{
 	k TaricSum
 	s gnum=0
 	i $d(^mtemp(Guser,$j,"Detail",+regNo)) d
 	.i (^TMP("RegNo",Guser,$j)="") d
 	..i (sum'=0) s ^TMP("RegNo",Guser,$j)=regNo
 	.e  d
 	..i (sum'=0) s ^TMP("RegNo",Guser,$j)=$g(^TMP("RegNo",Guser,$j))_"^"_regNo
 	s curid=0, oerowid=""
 	s type=""
 	i (bq="") s bq=regNo
 	s job=$j
 	s papno=regNo
	s discount="0", regNo=+regNo 
 	s ^TMP("Details",Guser,$j,bq,regNo,gnum)="发票类型"_"^"_"项目"_"^"_"数量"_"^"_"单位"_"^"_"单价"_"^"_"金额"_"^"_"自负"_"^"_"病历号"_"^"_"姓名"
 	s OutAdm=""
 	f  s OutAdm=$o(^mtemp(Guser,$j,"Detail",regNo,OutAdm)) q:(OutAdm="")  d 
  	.s cat=""
  	.f  s cat=$o(^mtemp(Guser,$j,"Detail",regNo,OutAdm,cat)) q:(cat="")  d 
  	..s taricID=""
  	..f  s taricID=$o(^mtemp(Guser,$j,"Detail",regNo,OutAdm,cat,taricID)) q:(taricID="")  d   //分类Id
  	...s oldtaricDesc="",tarisum=0
  	...s tariID=""
  	...f  s tariID=$o(^mtemp(Guser,$j,"Detail",regNo,OutAdm,cat,taricID,tariID)) q:(tariID="")  d   //项目ID
  	....s priceamt=""
  	....f  s priceamt=$o(^mtemp(Guser,$j,"Detail",regNo,OutAdm,cat,taricID,tariID,priceamt)) q:(priceamt="")  d   //金额
  	.....//s gnum=gnum+1
  	.....s price=priceamt
  	.....i (cat="IPCat") d
  	......s taricDesc=""
  	......i ($d(^DHCTarC("TIC",taricID))) d
  	.......s taricDesc=$p(^DHCTarC("TIC",taricID),"^",2)
  	......s tariDesc=$p(^DHCTARI(tariID),"^",2)
  	......s tariChargeBasis=$p(^DHCTARI(tariID),"^",20)     //取物价编码
  	.....i (cat="ItemCat") d
  	......//s taricDesc=$p(^ARC("IC",taricID),"^",2)
	......s taricDesc=$p(^OEC("ORCAT",taricID),"^",2)
  	......s tariDesc=$p(^ARCIM(+tariID,$p(tariID,"||",2),1),"^",2)
  	.....s babyflag=$p(^mtemp(Guser,$j,"Detail",regNo,OutAdm,cat,taricID,tariID,price),"^",6)
  	.....s billstatus=$p(^mtemp(Guser,$j,"Detail",regNo,OutAdm,cat,taricID,tariID,price),"^",7)
  	.....s qty=$p(^mtemp(Guser,$j,"Detail",regNo,OutAdm,cat,taricID,tariID,price),"^",1)
  	.....s total=$j($p(^mtemp(Guser,$j,"Detail",regNo,OutAdm,cat,taricID,tariID,price),"^",2),3,2)
  	.....q:(+total=0)
  	.....s uomDesc=$p(^mtemp(Guser,$j,"Detail",regNo,OutAdm,cat,taricID,tariID,price),"^",3)
  	.....s date=$p(^mtemp(Guser,$j,"Detail",regNo,OutAdm,cat,taricID,tariID,price),"^",4)
  	.....s time=$p(^mtemp(Guser,$j,"Detail",regNo,OutAdm,cat,taricID,tariID,price),"^",5)
  	.....s tarisum=tarisum+total
  	.....s ybzfbl=$p(^mtemp(Guser,$j,"Detail",regNo,OutAdm,cat,taricID,tariID,price),"^",6)
  	.....s YBFL=$p(^mtemp(Guser,$j,"Detail",regNo,OutAdm,cat,taricID,tariID,price),"^",7)
	.....i (oldtaricDesc'=taricDesc) d  
  	......s oldtaricDesc=taricDesc
  	.....e  s taricDesc=""
  	.....d OutputRow3
  	.....s papname=""
	...;add tangtao 2010-11-18 计算小计
  	...q:(+tarisum=0)
  	...s papname="",taricDesc="小计",taricode="",tariDesc="",qty="",uomDesc="",price="",total=tarisum
  	...s ybzfbl="",tariChargeBasis="",YBFL=""
  	...;end
  	...d OutputRow3
	q:(+sum=0) gnum
	s papname="",taricDesc="总计",taricode="",tariDesc="",qty="",uomDesc="",price="",total=$j(sum,3,2)
  	s ybzfbl="",tariChargeBasis="",YBFL=""
	d OutputRow3
  	s papname="",taricDesc="预缴款",tariDesc=$j(deposit,3,2),qty="费用",uomDesc=$j(patfee,3,2)_"(其中已结算)"_paidfee
	s ybzfbl="",tariChargeBasis="",YBFL=""
	s price="自付费用",total=$j(patshare,3,2),date="余额",time=$j((deposit-(patfee-paidfee)-$g(insuzfsum)),3,2),discount=""
  	i (Tmpbed'="") s ^TMP("UDHCJFDay","PRINT",Guser,Tmpbed)=+RegNo_"^"_Tmpname_"^"_Tmpbed_"^"_$j(deposit,3,2)_"^"_$j(patfee,3,2)_"^"_paidfee_"^"_total_"^"_time
    
OutputRow3
	set Data=$lb(papname,taricDesc,tariDesc,qty,uomDesc,price,total,job,date,time,ybzfbl,YBFL)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
 	set gnum=gnum+1
 	set papname=$p(papname,"[",1)
 	if (gnum=1) do
	.set ^TMP("Details",Guser,$j,bq,papno,gnum)=taricDesc_"^"_tariDesc_"^"_qty_"^"_uomDesc_"^"_price_"^"_total_"^"_discount_"^"_papno_"^"_$g(papname)_"^"_$j(deposit,3,2)_"^"_$j(patshare,3,2)_"^"_$j((deposit-(patfee-paidfee)-$g(insuzfsum)),3,2)_"^"_ybzfbl_"^"_YBFL_"^"_tariChargeBasis_"^"_ward
	else  do
	.set ^TMP("Details",Guser,$j,bq,papno,gnum)=taricDesc_"^"_tariDesc_"^"_qty_"^"_uomDesc_"^"_price_"^"_total_"^"_discount_"^"_papno_"^"_$g(papname)_"^"_""_"^"_""_"^"_""_"^"_ybzfbl_"^"_YBFL_"^"_tariChargeBasis_"^"_ward
	
	quit
}

ClassMethod ListDetail(RegNo, sum, hbflag, bq, deposit, Tmpname, Tmpbed)
{
	s gnum=0
	s patno=RegNo

	s papno=RegNo
	i $d(^mtemp(Guser,$j,"Detail",+RegNo)) d
	.i (^TMP("RegNo",Guser,$j)="") d
	..i (sum'=0) s ^TMP("RegNo",Guser,$j)=RegNo
 	.e  d
 	..i (sum'=0) s ^TMP("RegNo",Guser,$j)=$g(^TMP("RegNo",Guser,$j))_"^"_RegNo
 	s regNo=+RegNo
 	s curid=0, oerowid=""
 	i (bq="") s bq=RegNo
 	s job=$j
 	s discount=0
  	s myadm=""
  	f  s myadm=$o(^mtemp(Guser,$j,"Detail",regNo,myadm)) q:(myadm="")  d 
  	.s cat=""
	.f  s cat=$o(^mtemp(Guser,$j,"Detail",regNo,myadm,cat)) q:(cat="")  d 
  	..s taricID=""
  	..f  s taricID=$o(^mtemp(Guser,$j,"Detail",regNo,myadm,cat,taricID)) q:(taricID="")  d  //分类Id
  	...s oldtaricDesc="", tarisum=0
  	...s tariID=""
	...f  s tariID=$o(^mtemp(Guser,$j,"Detail",regNo,myadm,cat,taricID,tariID)) q:(tariID="")  d  //项目ID
  	....s oerowid=""
  	....f  s oerowid=$o(^mtemp(Guser,$j,"Detail",regNo,myadm,cat,taricID,tariID,oerowid)) q:(oerowid="")  d
  	.....s priceamt=""
  	.....f  s priceamt=$o(^mtemp(Guser,$j,"Detail",regNo,myadm,cat,taricID,tariID,oerowid,priceamt)) q:(priceamt="")  d  //金额
  	......//s gnum=gnum+1
  	......s price=priceamt
  	......i (cat="IPCat") d
  	.......s taricDesc=""
  	.......i ($d(^DHCTarC("TIC",taricID))) d
  	........s taricDesc=$p(^DHCTarC("TIC",taricID),"^",2)
  	.......s tariDesc=$p(^DHCTARI(tariID),"^",2)
  	.......s tariChargeBasis=$p(^DHCTARI(tariID),"^",20)
  	......i (cat="ItemCat") d
  	.......//s taricDesc=$p(^ARC("IC",taricID),"^",2)
  	.......s taricDesc=$p(^OEC("ORCAT",taricID),"^",2)
  	.......s tariDesc=$p(^ARCIM(+tariID,$p(tariID,"||",2),1),"^",2)
  	......s babyflag=$p(^mtemp(Guser,$j,"Detail",regNo,myadm,cat,taricID,tariID,oerowid,price),"^",6)
	......s billstatus=$p(^mtemp(Guser,$j,"Detail",regNo,myadm,cat,taricID,tariID,oerowid,price),"^",7)
  	......s qty=$p(^mtemp(Guser,$j,"Detail",regNo,myadm,cat,taricID,tariID,oerowid,price),"^",1)
  	......s total=$j($p(^mtemp(Guser,$j,"Detail",regNo,myadm,cat,taricID,tariID,oerowid,price),"^",2),3,2)
  	......q:(+total="0")
  	......s uomDesc=$p(^mtemp(Guser,$j,"Detail",regNo,myadm,cat,taricID,tariID,oerowid,price),"^",3)
  	......s date=$p(^mtemp(Guser,$j,"Detail",regNo,myadm,cat,taricID,tariID,oerowid,price),"^",4)
  	......s time=$p(^mtemp(Guser,$j,"Detail",regNo,myadm,cat,taricID,tariID,oerowid,price),"^",5)
  	......s tarisum=tarisum+total
  	......s ybzfbl=$p(^mtemp(Guser,$j,"Detail",regNo,myadm,cat,taricID,tariID,oerowid,price),"^",6)
  	......s YBFL=$p(^mtemp(Guser,$j,"Detail",regNo,myadm,cat,taricID,tariID,oerowid,price),"^",7)
  	......i (oldtaricDesc'=taricDesc) d
  	.......s oldtaricDesc=taricDesc
  	......e  s taricDesc=""
  	......d OutputRow4
  	......s papname=""  
  	...//add tangtao 2010-11-18 计算小计
  	...q:+tarisum="0"
  	...s papname="",taricDesc="小计",taricode="",tariDesc="",qty="",uomDesc="",price="",total=tarisum,date="",time=""
  	...s ybzfbl="",tariChargeBasis="",YBFL=""
  	...//end
  	...d OutputRow4 
 	q:(+sum=0) gnum
 	
 	s papname="",taricDesc="总计",taricode="",tariDesc="",qty="",uomDesc="",price="",total=$j(sum,3,2),discount=""
 	s ybzfbl="",tariChargeBasis="",YBFL="",date="",time=""
 	d OutputRow4
 	
 	s papname="",taricDesc="预缴款",tariDesc=$j(deposit,3,2),qty="费用",uomDesc=$j(patfee,3,2)_"(其中已结算)"_paidfee
 	s ybzfbl="",tariChargeBasis="",YBFL=""
	s price="自付费用",total=$j(patshare,3,2),date="余额",time=$j((deposit-(patfee-paidfee)-$g(insuzfsum)),3,2),discount="" 
 	i (Tmpbed'="") d
 	.s ^TMP("UDHCJFDay","PRINT",Guser,Tmpbed)=+RegNo_"^"_Tmpname_"^"_Tmpbed_"^"_$j(deposit,3,2)_"^"_$j(patfee,3,2)_"^"_paidfee_"^"_total_"^"_time
 
OutputRow4
	if ((price'="自付费用")&&(price'="")) set price=$j(price,6,4)
	set Data=$lb(papname,taricDesc,tariDesc,qty,uomDesc,price,total,job,date,time,ybzfbl,YBFL)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1 	
 	set gnum=gnum+1
 	set papname=$p(papname,"[",1)
 	if (gnum=1) do
	.set ^TMP("Details",Guser,$j,bq,papno,gnum)=taricDesc_"^"_tariDesc_"^"_qty_"^"_uomDesc_"^"_price_"^"_total_"^"_date_"^"_time_"^"_tariChargeBasis_"^"_discount_"^"_papno_"^"_papname_"^"_$j(deposit,3,2)_"^"_$j(patshare,3,2)_"^"_$j((deposit-(patfee-paidfee)-$g(insuzfsum)),3,2)_"^"_ybzfbl_"^"_YBFL_"^"_ward
	else  do
 	.set ^TMP("Details",Guser,$j,bq,papno,gnum)=taricDesc_"^"_tariDesc_"^"_qty_"^"_uomDesc_"^"_price_"^"_total_"^"_date_"^"_time_"^"_tariChargeBasis_"^"_discount_"^"_papno_"^"_papname_"^"_""_"^"_""_"^"_""_"^"_ybzfbl_"^"_YBFL_"^"_tariChargeBasis

 	quit
}

Query Findpapname(getwardid As %String) As websys.Query(ROWSPEC = "papno:%String,papname:%String,bedname")
{
}

ClassMethod FindpapnameExecute(ByRef qHandle As %Binary, getwardid As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind=1
    kill ^TMP("UDHCJFDAYDETAIL",$j)
	set admId="0"
    f  set admId=$o(^PAADMi("PAADM_Type","I",admId)) quit:(admId="")  do
	.q:'$d(^PAADM(admId))
	.set curWardId=$p(^PAADM(admId),"^",70)
	.quit:((curWardId="")||((getwardid'="")&&(curWardId'=getwardid)))
	.set visitstatus=$p(^PAADM(admId),"^",20)
	.quit:(visitstatus'="A")
	.set papno=$p(^PAPER(+^PAADM(admId),"PAT",1),"^",1)
	.set papname=$p(^PAPER(+^PAADM(admId),"ALL"),"^",1)
	.set bedrowid=$p(^PAADM(admId),"^",73)
	.if (bedrowid'="")  do
	..set wardid=$p(bedrowid,"||",1),bedid=$p(bedrowid,"||",2)
	..set bedname=$p(^PAWARD(wardid,"BED",bedid),"^",1)
	..if (bedname'["床") do
	...set bedname=bedname_"床"   
	..set ^TMP("UDHCJFDAYDETAIL",$j,bedname)=papno_"^"_papname  
	
	set BedName=""
	for   set BedName=$o(^TMP("UDHCJFDAYDETAIL",$j,BedName)) quit:(BedName="")  do
	.set papno=$p(^TMP("UDHCJFDAYDETAIL",$j,BedName),"^",1)
	.set papname=$p(^TMP("UDHCJFDAYDETAIL",$j,BedName),"^",2)
	.set bedname=BedName
	.do OutputRow5
     
     set qHandle=$lb(0,repid,0)
	 quit $$$OK
OutputRow5
	set Data=$lb(papno,papname,$g(bedname))
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

ClassMethod Computing(billno, frmdat, todat)
{
	;n (frmdat,todat,billno)
	i billno="" q 100
	i todat="" s todat=+$h
	i frmdat="" s frmdat=0
	s billno=+$g(billno),frmdat=$g(frmdat),todat=$g(todat)
    s YBZFPay=##Class(web.DHCINSUPort).GetDividePreByPBDr(billno)    ;医保预结算
	s pat=0,totsum=0,discsum=0,patsum=0,payorsum=0 
	s payedflag=$p(^DHCPB(billno),"^",16)       ;add tangtao 2011-01-06 不计算已结算的账单
	f  s pat=$o(^DHCPB(billno,"O",pat)) q:pat=""  d
	.s arcim=$p($g(^DHCPB(billno,"O",pat)),"^",3)  
	.q:arcim=""
	.s arcgrp=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",10)          ;医嘱子类
	.s catgrp=$p($g(^ARC("IC",arcgrp)),"^",8)                           ;大类             
	.s ordCateType=$p($g(^ARC("IC",arcgrp)),"^",7)                      ;医嘱类型
	.s excrowid=$p(^DHCPB(billno,"O",pat),"^",20) 
	.s oerowid=$p($g(^DHCPB(billno,"O",pat)),"^",4)
	.q:oerowid=""
	.s Conf=""
	.s Conf=$o(^DHCTarC("CF",Conf))
	.s DefaultCP=$p(^DHCTarC("CF",Conf),"^",9)
	.i DefaultCP="" s DefaultCP="OD"
	.s Condition=$o(^DHCTarC("BC",0,arcgrp,""))
	.i Condition'="" s CP=$p(^DHCTarC("BC",Condition),"^",2)
	.e  s CP=DefaultCP
	.i (CP="CR")&(ordCateType="R") d
	..s LinkFlag=##class(web.UDHCJFBILLIP).GetUserLocLinkRecLoc(oerowid)
	..i LinkFlag="Y" s CP="OD"
	.s detailid=0
	.f  s detailid=$o(^DHCPB(billno,"O",pat,"D",detailid)) q:detailid=""  s s=^(detailid) d
	..s totfee=0,discfee=0,patientfee=0,payorfee=0 
	..;yyx
	..s paidflag=$p(s,"^",14)
	..s totfee=$p(s,"^",7),dat=$p(s,"^",11)
	..s discfee=$p(s,"^",8)
	..s patientfee=$p(s,"^",10)
	..s payorfee=$p(s,"^",9)
	..s ExcStDate=$p(^OEORD($p(excrowid,"||",1),"I",$p(excrowid,"||",2),"X",$p(excrowid,"||",3)),"^",1)
	..s ExcXDate=$p(^OEORD($p(excrowid,"||",1),"I",$p(excrowid,"||",2),"X",$p(excrowid,"||",3)),"^",12)
	..i ((CP="OD")&(ExcStDate>ExcXDate)&(ExcXDate'=0)) s dat=ExcStDate
	..q:((dat<frmdat)!(dat>todat))
	..s totsum=totsum+totfee
	..s discsum=discsum+discfee
	..s patsum=patsum+patientfee
	..s payorsum=payorsum+payorfee 
	..i paidflag="P" s paidfee=paidfee+totfee
	q totsum_"^"_discsum_"^"_payorsum_"^"_patsum_"^"_+$g(YBZFPay)
}

Query Findpat(getwardid As %String, stdate As %String, enddate As %String, RegNo) As websys.Query(ROWSPEC = "papno:%String")
{
}

ClassMethod FindpatExecute(ByRef qHandle As %Binary, getwardid As %String, stdate As %String, enddate As %String, RegNo) As %Status
{
	set repid=$I(^CacheTemp)
	set ind=1
	set qHandle=$lb(0,repid,0)
	if ((getwardid="")&&(RegNo=""))  quit $$$OK
	
    if (stdate["/") set stdate=$zdh(stdate,4)
    if (enddate["/") set enddate=$zdh(enddate,4)
    
    kill ^TMP("IPBED",$j)
    set admId="0"      
    for  set admId=$o(^PAADMi("AdmTypeCurr","I",admId)) quit:(admId="")  do
	.quit:'$d(^PAADM(admId))
	.set curWardId=$p(^PAADM(admId),"^",70)      
	.quit:((curWardId="")||((getwardid'="")&&(curWardId'=getwardid)))
	.set admdate=$p(^PAADM(admId),"^",6)     
	.//quit:(admdate>enddate)
	.set disdate=$p(^PAADM(admId),"^",17)     
	.//quit:((disdate<enddate)&(disdate'=""))
	.//quit:((disdate'="")&(disdate<+$h))
	.set visitstatus=$p(^PAADM(admId),"^",20)
	.quit:(visitstatus="C")
 	.set papno=$p(^PAPER(+^PAADM(admId),"PAT",1),"^",1)
	.set papname=$p(^PAPER(+^PAADM(admId),"ALL"),"^",1)
 	.set bedrowid=$p(^PAADM(admId),"^",73)
	.quit:(bedrowid="")
	.if (bedrowid'="")  do
	..set wardid=$p(bedrowid,"||",1),bedid=$p(bedrowid,"||",2)
 	..set bedname=$p(^PAWARD(wardid,"BED",bedid),"^",1)
	..if (bedname["+") set bedname="加"_$Number(bedname)
 	..else  if ($Number(bedname)'="")  set bedname=$Number(bedname)
	.if ($g(bedname)'="") do
	.set ^TMP("IPBED",$j,bedname)=papno_"^"_papname_"^"_bedname
     
     if ($d(^TMP("IPBED",$j))) do
     .set bedname=""
     .for  set bedname=$o(^TMP("IPBED",$j,bedname)) quit:(bedname="")  do
     ..set str=$g(^TMP("IPBED",$j,bedname))
     ..do OutputRowpat
    
     if (RegNo'="") do
     .set PapmiID=$o(^PAPERi("PAPMI_PatNo",RegNo,""))
     .set papname=$p(^PAPER(PapmiID,"ALL"),"^",1)
     .set str=RegNo_"^"_papname_"^"_"已出院"
     .do OutputRowpat
     
     kill ^TMP("IPBED",$j)
     
     set qHandle=$lb(0,repid,0)
	 quit $$$OK
OutputRowpat
	set Data=$lb(str)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

Query Depgroup(DepGroup) As websys.Query(ROWSPEC = "type:%String,rowid:%String")
{
}

ClassMethod DepgroupExecute(ByRef qHandle As %Binary, DepGroup) As %Status
{
	set repid=$I(^CacheTemp)
    set ind=1
    set rowid="0"
    for  set rowid=$o(^RBC("DEP",rowid)) quit:(rowid="")  do
    .set rbcInfo=$g(^RBC("DEP",rowid))
    .quit:(rbcInfo="")
    .set type=$p(rbcInfo,"^",2)
    .quit:((DepGroup'="")&&(type'[DepGroup))
    .set dateFrom=$p(rbcInfo,"^",3)
    .set dateTo=$p(rbcInfo,"^",4)
    .quit:((dateFrom'="")&&(dateFrom>+$h))
    .quit:((dateTo'="")&&(dateTo<+$h))
    .do OutputRowDe
    
    set qHandle=$lb(0,repid,0)
	quit $$$OK
OutputRowDe
	set Data=$lb(type,rowid)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

ClassMethod getwarddesc(itmjs As %Library.String = "", itmjsex As %Library.String = "", wardid)
{
	s wardid=$g(wardid)
	q:(wardid="") "^"
	s rowid=""
  	s rowid=$o(^PAWARD(0,"WARD_LocationDR",wardid,rowid))
	q:(rowid="") "^"
	s warddesc=$p(^PAWARD(rowid),"^",2)
	i ($f(warddesc,"-")'=0)  d
	.s warddesc=$p(warddesc,"-",2)
	s str=rowid_"^"_warddesc
	q str
}

ClassMethod GetOrder(BillNo, pboSub)
{
    s Adm=$p(^DHCPB(+BillNo),"^",1)
    s arcimid=$p($g(^DHCPB(BillNo,"O",pboSub)),"^",3)
    s DrugCommonDesc=##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId(arcimid)
    s:DrugCommonDesc'="" orddesc=$g(DrugCommonDesc)
    s itemcat=$p(^ARCIM(+arcimid,$p(arcimid,"||",2),1),"^",10)
	s ordcatid=$p(^ARC("IC",itemcat),"^",8)
	s ordcatdesc=$p(^OEC("ORCAT",ordcatid),"^",2)
	s orddesc=$p(^ARCIM(+arcimid,$p(arcimid,"||",2),1),"^",2)
	s oerowid=$p($g(^DHCPB(BillNo,"O",pboSub)),"^",4)
	s ordprice=$p($g(^DHCPB(BillNo,"O",pboSub)),"^",7)
	s ordtot=$p($g(^DHCPB(BillNo,"O",pboSub)),"^",8)
	s ordbillqty=$p($g(^DHCPB(BillNo,"O",pboSub)),"^",5)
	s ordrefqty=$p($g(^DHCPB(BillNo,"O",pboSub)),"^",6)
	s ordqty=ordbillqty+ordrefqty
	//+2018-02-11 ZhYW 取整包装单位、数量
	s uomDesc=##class(web.DHCBillCommon).GetPackUom(arcimid, oerowid)
	s confac=##class(web.DHCBillCommon).GetUomConvFactor(arcimid, oerowid)
	s ordqty=ordqty/confac
	//
    d ..GetBabyFlag(oerowid)
	i (admmotflag'="") s orddesc=orddesc_"("_"婴儿"_")"
    i (billstatus="P") s orddesc=orddesc_"("_"已结算"_")"
    s sum=sum+ordtot       //总计
    s ybzfbl=""
    
	i (hbflag="1") d
	.//合并
	.s $p(^mtemp(Guser,$j,"Detail",+RegNo,Adm,"ItemCat",ordcatid,arcimid,ordprice),"^",1)=$p($g(^mtemp(Guser,$j,"Detail",+RegNo,Adm,"ItemCat",ordcatid,arcimid,ordprice)),"^",1)+ordqty
	.s $p(^mtemp(Guser,$j,"Detail",+RegNo,Adm,"ItemCat",ordcatid,arcimid,ordprice),"^",2)=$p($g(^mtemp(Guser,$j,"Detail",+RegNo,Adm,"ItemCat",ordcatid,arcimid,ordprice)),"^",2)+ordtot
	.s $p(^mtemp(Guser,$j,"Detail",+RegNo,Adm,"ItemCat",ordcatid,arcimid,ordprice),"^",3)=uomDesc
	.s $p(^mtemp(Guser,$j,"Detail",+RegNo,Adm,"ItemCat",ordcatid,arcimid,ordprice),"^",4)=""
	.s $p(^mtemp(Guser,$j,"Detail",+RegNo,Adm,"ItemCat",ordcatid,arcimid,ordprice),"^",5)=""
	.s $p(^mtemp(Guser,$j,"Detail",+RegNo,Adm,"ItemCat",ordcatid,arcimid,ordprice),"^",6)=ybzfbl
	.s $p(^mtemp(Guser,$j,"Detail",+RegNo,Adm,"ItemCat",ordcatid,arcimid,ordprice),"^",7)=admmotflag
	.s $p(^mtemp(Guser,$j,"Detail",+RegNo,Adm,"ItemCat",ordcatid,arcimid,ordprice),"^",8)=billstatus
	e  d
	.//不合并
	.s $p(^mtemp(Guser,$j,"Detail",+RegNo,Adm,"ItemCat",ordcatid,arcimid,oerowid,ordprice),"^",1)=$p($g(^mtemp(Guser,$j,"Detail",+RegNo,Adm,"ItemCat",ordcatid,arcimid,oerowid,ordprice)),"^",1)+ordqty
	.s $p(^mtemp(Guser,$j,"Detail",+RegNo,Adm,"ItemCat",ordcatid,arcimid,oerowid,ordprice),"^",2)=$p($g(^mtemp(Guser,$j,"Detail",+RegNo,Adm,"ItemCat",ordcatid,arcimid,oerowid,ordprice)),"^",2)+ordtot
	.s $p(^mtemp(Guser,$j,"Detail",+RegNo,Adm,"ItemCat",ordcatid,arcimid,oerowid,ordprice),"^",3)=uomDesc
	.s $p(^mtemp(Guser,$j,"Detail",+RegNo,Adm,"ItemCat",ordcatid,arcimid,oerowid,ordprice),"^",4)=##class(websys.Conversions).DateLogicalToHtml(billdate)
	.s $p(^mtemp(Guser,$j,"Detail",+RegNo,Adm,"ItemCat",ordcatid,arcimid,oerowid,ordprice),"^",5)=##class(websys.Conversions).TimeLogicalToHtml(billtime, 1)
	.s $p(^mtemp(Guser,$j,"Detail",+RegNo,Adm,"ItemCat",ordcatid,arcimid,oerowid,ordprice),"^",6)=ybzfbl
	.s $p(^mtemp(Guser,$j,"Detail",+RegNo,Adm,"ItemCat",ordcatid,arcimid,oerowid,ordprice),"^",7)=admmotflag
	.s $p(^mtemp(Guser,$j,"Detail",+RegNo,Adm,"ItemCat",ordcatid,arcimid,oerowid,ordprice),"^",8)=billstatus

	q
}

ClassMethod GetDetail(BillNo, pboSub, Itm, Admreasomdr, admId)
{
    s Adm=$p(^DHCPB(+BillNo),"^",1)
    s oerowid=$p($g(^DHCPB(+BillNo,"O",pboSub)),"^",4)
    s ExecRowID=$p($g(^DHCPB(+BillNo,"O",pboSub)),"^",20)
    d ..GetBabyFlag(oerowid)
    s Tmp=^DHCPB(+BillNo,"O",pboSub,"D",Itm)
    s PBDRowID=BillNo_"||"_pboSub_"||"_Itm
    s taritm=$p(Tmp,"^",3)                     //PBD_TARI_DR,收费项目住院分类
    q:'$d(^DHCTARI(taritm))
    s tariDesc=$p(^DHCTARI(taritm),"^",2)      //收费项目名称
    i (admmotflag'="") s tariDesc=tariDesc_"("_"婴儿"_")"
    i (billstatus="P") s tariDesc=tariDesc_"("_"已结算"_")"
    i $d(^OEORD(+oerowid,"I",$p(oerowid,"||",2),2)) d
    .s billdesc=$p(^OEORD(+oerowid,"I",$p(oerowid,"||",2),2),"^",12)
    i ($g(billdesc)'="")  d
    .s tariDesc=billdesc
    e  d
    .s arcim=$p($g(^DHCPB(+BillNo,"O",pboSub)),"^",3)
    .s DrugCommonDesc=##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId(arcim)
    .s:(DrugCommonDesc'="") tariDesc=$g(DrugCommonDesc)
    .s arcgrp=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",10)          //子类arc_itemcat
    .s catgrp=$p(^ARC("IC",arcgrp),"^",8)                        //OEC_OrderCategory
    .s catgrpdesc=$p(^OEC("ORCAT",catgrp),"^",2)
    .i ((catgrpdesc="检验")||(catgrpdesc="医技检查")) d
    ..s ordstatus=$p(^OEORD($p(oerowid,"||",1),"I",$p(oerowid,"||",2),1),"^",13) //oec_orderstatus
    ..s ordstatus=$p(^OEC("OSTAT",ordstatus),"^",1)
    ..//i ordstatus="V" s tariDesc=tariDesc_"(预收)"
    ..i (ordstatus="V") s tariDesc=tariDesc

    s taricdesc=$p(^DHCTarC("TIC",taric),"^",2)   //收费项目住院分类名称
    s date=$p(s,"^",11)                           //pbd_billdate
    s qty=$p(s,"^",5)                             //pbd_billqty
    s price=$j($p(s,"^",4),6,4)                   //pbd_unitprice
    s tot=$fn(price*qty,"",2)                     //pbd_totalamount
    q:(+tot=0)
    s tariUom=$p(^DHCTARI(taritm),"^",3)          //单位
    s uomDesc=""
    i (tariUom'="") s uomDesc=$p(^CT("UOM",tariUom),"^",2)    //单位
    s ^catefee(+RegNo,taricdesc)=$g(^catefee(+RegNo,taricdesc))+tot
    s sum=sum+tot   //总计
    s getinsustr=##class(web.DHCINSUPort).TarItmLinkInsu(taritm, Admreasomdr, "", admId, price)
    s YBFL=$p(getinsustr,"^",1)
    s ybzfbl=$p(getinsustr,"^",2)
    i (+ybzfbl<1) s ybzfbl=(+ybzfbl*100)_"%"
    i (hbflag="1") d
    .//合并
	.s $p(^mtemp(Guser,$j,"Detail",+RegNo,Adm,"IPCat",taric,taritm,price),"^",1)=$p($g(^mtemp(Guser,$j,"Detail",+RegNo,Adm,"IPCat",taric,taritm,price)),"^",1)+qty
	.s $p(^mtemp(Guser,$j,"Detail",+RegNo,Adm,"IPCat",taric,taritm,price),"^",2)=$p($g(^mtemp(Guser,$j,"Detail",+RegNo,Adm,"IPCat",taric,taritm,price)),"^",2)+tot
	.s $p(^mtemp(Guser,$j,"Detail",+RegNo,Adm,"IPCat",taric,taritm,price),"^",3)=uomDesc
	.s $p(^mtemp(Guser,$j,"Detail",+RegNo,Adm,"IPCat",taric,taritm,price),"^",4)=""
	.s $p(^mtemp(Guser,$j,"Detail",+RegNo,Adm,"IPCat",taric,taritm,price),"^",5)=""
	.s $p(^mtemp(Guser,$j,"Detail",+RegNo,Adm,"IPCat",taric,taritm,price),"^",6)=ybzfbl
	.s $p(^mtemp(Guser,$j,"Detail",+RegNo,Adm,"IPCat",taric,taritm,price),"^",7)=YBFL
	i (hbflag="0") d
	.//不合并
	.s $p(^mtemp(Guser,$j,"Detail",+RegNo,Adm,"IPCat",taric,taritm,PBDRowID,price),"^",1)=qty
	.s $p(^mtemp(Guser,$j,"Detail",+RegNo,Adm,"IPCat",taric,taritm,PBDRowID,price),"^",2)=tot
	.s $p(^mtemp(Guser,$j,"Detail",+RegNo,Adm,"IPCat",taric,taritm,PBDRowID,price),"^",3)=uomDesc
	.s $p(^mtemp(Guser,$j,"Detail",+RegNo,Adm,"IPCat",taric,taritm,PBDRowID,price),"^",4)=##class(websys.Conversions).DateLogicalToHtml(billdate)
	.s $p(^mtemp(Guser,$j,"Detail",+RegNo,Adm,"IPCat",taric,taritm,PBDRowID,price),"^",5)=##class(websys.Conversions).TimeLogicalToHtml(billtime,1)
	.s $p(^mtemp(Guser,$j,"Detail",+RegNo,Adm,"IPCat",taric,taritm,PBDRowID,price),"^",6)=ybzfbl
	.s $p(^mtemp(Guser,$j,"Detail",+RegNo,Adm,"IPCat",taric,taritm,PBDRowID,price),"^",7)=YBFL
	
	q
}

ClassMethod GetBabyFlag(oerowid)
{
	s admmotflag=""
    s admorddr=$p(oerowid,"||",1)
    s admmotdr=$p(^OEORD(admorddr),"^",1)
    s admmotflag=$p(^PAADM(admmotdr),"^",75)
    q
}

ClassMethod ReDayData(Guser)
{
	s Guser=$g(%session.Data("LOGON.USERID"))
	s num=0
	s bedname=""
	f  s bedname=$o(^TMP("UDHCJFDay","PRINT",Guser,bedname)) q:bedname=""  d //獲取數據	
	.s bedno=$p(^TMP("UDHCJFDay","PRINT",Guser,bedname),"^",3)
	.s str=^TMP("UDHCJFDay","PRINT",Guser,bedname)
	.s num=num+1
	.s ^TMP("UDHCJFDay","final","PRINT",$j,num)=num_"^"_str
	q num
}

ClassMethod GetDayData(num)
{
	s str=""
	i $d(^TMP("UDHCJFDay","final","PRINT",$j))  d
	.s str=^TMP("UDHCJFDay","final","PRINT",$j,num)
	q str
}

ClassMethod GetPath(itmjs As %Library.String = "", itmjsex As %Library.String = "")
{
	&sql(select pathtoreports into :path from websys.configuration)
	q path
}

ClassMethod GetCurAdm(RegNo)
{
	s papmi=$o(^PAPERi("PAPMI_PatNo",RegNo,"")) ;papmi_rowid
	s admId=0,CurAdm1="",CurAdm2=""
	f  s admId=$o(^PAPERdr(papmi,"ADM","I",admId)) q:admId=""  d  ;取住院病人admId
	.q:'$d(^PAADM(admId))
	.s VisStaus=$p(^PAADM(admId),"^",20)
	.q:(VisStaus="C")
	.s CurAdm2=admId	;无在院取最后的出院就诊
	.i (VisStaus="A") d
	..s CurAdm1=admId	;有在院取在院就诊
	
	q:(CurAdm1'="") CurAdm1	;有在院取在院就诊
	q CurAdm2	;无在院取最后的出院就诊
}

/// 获取医嘱的计费点
/// w ##class(web.UDHCJFDayDetail).GetCP("241||10")
ClassMethod GetCP(adm, oeitm)
{
	n (adm, oeitm)
	s arcim=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1)),"^",2)  
 	s arcgrp=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",10)          ;医嘱子类
 	s catgrp=$p($g(^ARC("IC",arcgrp)),"^",8)                           ;大类             
 	s ordCateType=$p($g(^ARC("IC",arcgrp)),"^",7)                      ;医嘱类型
 	s Conf=""
 	s Conf=$o(^DHCTarC("CF",Conf))
 	s DefaultCP=$p(^DHCTarC("CF",Conf),"^",9)
 	i (DefaultCP="") s DefaultCP="OD"
 	s Condition=$o(^DHCTarC("BC",0,arcgrp,""))
 	i (Condition'="") s CP=$p(^DHCTarC("BC",Condition),"^",2)
 	e  s CP=DefaultCP
 	i (CP="CR")&&(ordCateType="R") {
	 	s linkFlag=##class(web.UDHCJFBILLIP).GetUserLocLinkRecLoc(oeitm)
	 	i (linkFlag="Y") s CP="OD"
	}
 	s prioDr=$p(^OEORD($p(oeitm,"||",1),"I",$p(oeitm,"||",2),1),"^",8)
 	s priority=""
 	i (prioDr'="") s priority=$p(^OECPR(prioDr),"^",1)
 	i (priority="OUT") {
	 	s phOutFlag=##class(web.UDHCJFBILLIP).GetPhOutFlag(adm)
	 	i (phOutFlag="N") s CP="OD"
	}
 	q CP
}

}
