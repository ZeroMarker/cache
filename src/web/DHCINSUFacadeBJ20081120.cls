Import SQLUser

Class web.DHCINSUFacadeBJ20081120 Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 1588;

//此文件用于北京地坛医院医保欠费帐,20080624,LOU

//卡支付

ClassMethod GetInsuZyjsInfoBJ(Name3 As %String, iAmount As %String) As %String
{
	s GetInsuZyjsInfoBJ=$$GetInsuZyjsInfoBJ^DHCINSUFacadeBJ(Name3,iAmount)
	q GetInsuZyjsInfoBJ
}

ClassMethod InsertDivSubDue(Str As %String) As %String
{
	n (Str)
	s INPAYrowid=$p(Str,"^",1)
	s ChildSub=$p(Str,"^",2)
	i $d(^DHCINDSD(INPAYrowid,"ChildSub",ChildSub)) d
	.s InsertDivSubDue=$$UpdateDivSubDue^DHCINSUFacadeBJ(Str)
	e  d
	.s InsertDivSubDue=$$InsertDivSubDue^DHCINSUFacadeBJ(Str)
	q InsertDivSubDue
}

ClassMethod SaveDaily(Str As %String) As %String
{
	n (Str)
	s SaveDaily=$$SaveDaily^DHCINSUFacadeBJ(Str)
	q SaveDaily
}

ClassMethod SaveInsuPayBack(Str As %String) As %String
{
	n (Str)
	s INDivrowid=$p(Str,"^",1)
	i $d(^DHCINPAB("0","DivideDr",INDivrowid)) d
	.w "1,",!
	.s InsertDivSubDue=$$UpdateInsuPayBack^DHCINSUFacadeBJ(INDivrowid)
	.s InsertDivSubDue=$$InsertInsuPayBack^DHCINSUFacadeBJ(Str)
	e  d
	.s InsertDivSubDue=$$InsertInsuPayBack^DHCINSUFacadeBJ(Str)
	q InsertDivSubDue
}

ClassMethod IsDailyExist(date As %String) As %String
{
    ;判断是否已经存在日结数据,不用
	n (date)
	s date=$zdh(date,3)
	s INDUDrowid=0,s="N"
	f  s INDUDrowid=$o(^DHCINDUD(0,"Date",date,INDUDrowid)) q:INDUDrowid=""  d
	.s mCorr=$g(^DHCINDUD(0,"Date",date,INDUDrowid))
    .i mCorr'="" d
    ..s Flag=$p(mCorr,"^",5)
    ..q:(Flag="strike")
    ..s s="Y" 
	q s
}

ClassMethod StrikeDaily(date As %String) As %String
{
	;如果日结已经进行过则将原来的日结数据作废,不用
	n (date)
	q:(date="")
	s flag=$$StrikeDaily^DHCINSUFacadeBJ(date)
	q flag
}

Query QueryINSUDueList(BegDate As %String, EndDate As %String, District As %String, BingQu As %String, PatNO As %String, PatType As %String, iAmount As %String, qfPat As %String, BackType As %String, JSPqfPat As %String, HKPat As %String, RefusePat As %String) As %Query(ROWSPEC = "TDate:%String,TBingQu:%String,TSummary:%String,TPatName:%String,TJieFang:%String,TDaiFang:%String,TFlag:%String,TBalance:%String,TDistrict:%String,TName3:%String")
{
}

ClassMethod QueryINSUDueListExecute(ByRef qHandle As %Binary, BegDate As %String, EndDate As %String, District As %String, BingQu As %String, PatNO As %String, PatType As %String, iAmount As %String, qfPat As %String, BackType As %String, JSPqfPat As %String, HKPat As %String, RefusePat As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
    if (EndDate="") Set qHandle=$lb(0,repid,0) Quit $$$OK
    if (BegDate="") set BegDate="61220"
    s BegDate=$zd(BegDate,3),EndDate=$zd(EndDate,3) //lou 
    
    //BackType为是首信回款还是金算盘回款，on为首信
    //d ..GetAllDistrictList(BegDate,EndDate,BingQu, PatNO, PatType,qfPat,BackType)
    d ..QueryList(BegDate, EndDate, District, BingQu, PatNO, PatType, iAmount, qfPat, BackType,JSPqfPat,HKPat,RefusePat)
    s TDate="",TBingQu="",TSummary="",TPatName="",TJieFang="",TDaiFang="",TFlag="",TBalance=""
    s TDistrict=0,JieSum=0,DaiSum=0
    f  s TDistrict=$o(^CacheTemp($j,"InsuDueList",TDistrict)) q:TDistrict=""   d
    .;w "1=",District_"^"_TDistrict,!
    .s intDate=0
    .f  s intDate=$o(^CacheTemp($j,"InsuDueList",TDistrict,intDate)) q:intDate=""  d
	..s i=0
	..f  s i=$o(^CacheTemp($j,"InsuDueList",TDistrict,intDate,i)) q:i=""  d
	...s TJieFang="",TDaiFang="",TBalance=""
	...s mCurrRowAll=$g(^CacheTemp($j,"InsuDueList",TDistrict,intDate,i))
	...s TDate=$p(mCurrRowAll,"^",1)
	...s TBingQu=$p(mCurrRowAll,"^",2)
	...s TSummary=$p(mCurrRowAll,"^",3)
	...s TPatName=$p(mCurrRowAll,"^",4)
	...i $p(mCurrRowAll,"^",5)'="" s TJieFang=$j($p(mCurrRowAll,"^",5),3,2) ;这个判断是为了不显示0.00金额
	...i $p(mCurrRowAll,"^",6)'="" s TDaiFang=$j($p(mCurrRowAll,"^",6),3,2)
	...s TFlag=$p(mCurrRowAll,"^",7) 
	...q:(TJieFang="0.00")&&(TDaiFang="0.00")
	...i $p(mCurrRowAll,"^",8)'="" s TBalance=$j($p(mCurrRowAll,"^",8),3,2) ;同上 余额
	...s TName3=$p(mCurrRowAll,"^",10)
	...q:(iAmount'="")&&(TJieFang'=iAmount) ;筛选金额
	...i RefusePat="on"  s TJieFang=TDaiFang,TDaiFang=0 ;如果查找医保拒付的病人，则将只会有贷方 将贷方金额显示在借方的位置
	...d OutputRow2
	...s JieSum=JieSum+TJieFang,DaiSum=DaiSum+TDaiFang
	;如果没有日结，显示合计,最好日期从最初开始,人工控制
	i (qfPat="on")||(JSPqfPat="on")||(HKPat="on")||(RefusePat="on")||(District="") d
	.s TDate="",TBingQu="",TPatName="",TFlag="",TBalance="",TDistrict="",TName3=""
	.s TSummary="合计",TJieFang=JieSum,TDaiFang=DaiSum
	.d OutputRow2
	;k ^CacheTemp($j,"NoDistrict")
	;k ^CacheTemp($j,"InsuDueList")
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(TDate,TBingQu,TSummary,TPatName,TJieFang,TDaiFang,TFlag,TBalance,TDistrict,TName3)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryINSUDueListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryINSUDueListExecute ]
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

ClassMethod QueryINSUDueListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryINSUDueListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

//根据日期查询不同区县的医保欠费明细

ClassMethod QueryList(BegDate As %String, EndDate As %String, District As %String, iBingQu As %String, PatNO As %String, PatType As %String, iAmount As %String, qfPat As %String, BackType As %String, JSPqfPat As %String, HKPat As %String, RefusePat As %String) As %String
{
	k ^CacheTemp($j,"InsuDueList")
	s i=0
	i HKPat="on"  d
	.d ..GetJSPBackInfo(BegDate, EndDate, iBingQu, PatNO, PatType, District,RefusePat)
	q:(HKPat="on") ;查询已到账的病人
	i RefusePat'="on" d ..GetDivInfo(BegDate, EndDate, iBingQu, PatNO, PatType, District,qfPat,JSPqfPat) //获得结算信息
    q:(qfPat="on") ;若只查询欠费病人
    q:(JSPqfPat="on")
    i BackType'="on"  d ..GetJSPBackInfo(BegDate, EndDate, iBingQu, PatNO, PatType, District,RefusePat) //获得金算盘回款
    i BackType="on"  d ..GetInsuBackInfo(BegDate, EndDate, iBingQu, PatNO, PatType, District,RefusePat) //获得首信回款
    q:(District="") ;不选择区县时不显示日结，查出所有区县的欠费和回款
    i RefusePat="on" d ..GetRefuseSumInfo(BegDate, EndDate, District, BackType) //拒付的进行计算余额等内容
    q:RefusePat="on"
    d ..GetDailyInfo(BegDate, EndDate, District, BackType) //获得日结
}

//为日结获得借方贷方等信息

ClassMethod GetListInfoForDaily(BegDate As %String, EndDate As %String, BackType As %String) As %String
{
	k ^CacheTemp($j,"InsuDueList")
	d ..GetDivInfo(BegDate, EndDate, "", "", "", "","","") //获得结算信息
	i BackType="0"  d ..GetJSPBackInfo(BegDate, EndDate, "", "", "", "","") //获得金算盘回款
	i BackType="1"  d ..GetInsuBackInfo(BegDate, EndDate, "", "", "", "","") //获得首信回款
}

//,不用

ClassMethod GetAllDistrictList(BegDate As %String, EndDate As %String, iBingQu As %String, PatNO As %String, PatType As %String, qfPat As %String, BackType As %String) As %String
{
	k ^CacheTemp($j,"InsuDueList")
	s i=0
	s BegDate=$zdh(BegDate,3) //lou
	s EndDate=$zdh(EndDate,3)
	s TDistrict="",PatName="",Name3="",Name31=""
    f intDate=BegDate:1:EndDate  d
    .;下面取医保欠费记录
    .;w "intdate=",intDate,!
    .s INPAYRowid=0 
    .f  s INPAYRowid=$o(^DHCINDIV("0","IDate",intDate,INPAYRowid)) q:INPAYRowid=""  d
    ..;w "INPAYRowid=",INPAYRowid,!
    ..s childsub=0,inpaybackrowid=0
    ..q:(qfPat="on")&&(BackType'="on")&&($o(^DHCINDSD(INPAYRowid,"ChildSub",childsub))) ;筛选未回款的病人
    ..q:(qfPat="on")&&(BackType="on")&&($o(^DHCINPAB("0","DivideDr",INPAYRowid,inpaybackrowid)))
    ..s mCurrRow=$g(^DHCINDIV(INPAYRowid))
    ..q:($p(mCurrRow,"^",5)'="insu")
    ..s iDate=$zd($p(mCurrRow,"^",16),3)
    ..s BillDr=$p(mCurrRow,"^",3)
    ..if BillDr="" s PatName=""
    ..e  d
    ...s AdmDr=$p($g(^DHCPB(BillDr)),"^",1)
    ...s PapmiDr=$p($g(^PAADM(AdmDr)),"^",1)
    ...s PatName=$p($g(^PAPER(PapmiDr,"ALL")),"^",1)
    ...s Name3=$p($g(^PAPER(PapmiDr,"ALL")),"^",19)
    ...i PatType'="" d
    ....s AdmReasonDr=$p($g(^PAADM(AdmDr,"1")),"^",7)
    ....s AdmReason=$p(^PAC("ADMREA",AdmReasonDr),"^",2)
    ..s jjzfe=$p(mCurrRow,"^",19)
    ..s CurrentWardDR=$p($g(^PAADM(AdmDr)),"^",70)
    ..s BingQu=$p(^PAWARD(CurrentWardDR),"^",1) ;pac_ward表
    ..q:(iBingQu'="")&&(BingQu'=iBingQu) ;筛选病区
    ..s TDistrict=##class(EPRservice.BOScatterData).GetEPRData(AdmDr,"住院病案摘要.病案首页.一般情况.首页一般情况.病人来源 #TYPE:Simple#TID:66#TVER:0#SCODE:O0074#VTYPE:V") ;区县 取自电子病历组
    ..;w "TDistrict=",TDistrict,!
    ..q:(PatNO'="")&&(Name3'=PatNO) ;筛选医保号
    ..q:(PatType'="")&&(AdmReason'=PatType) ;筛选病人类型
    ..s i=i+1
    ..s ^CacheTemp($j,"InsuDueList",TDistrict,intDate,i)=iDate_"^"_BingQu_"^"_"应收医保欠费"_"^"_PatName_"^"_jjzfe_"^"_""_"^"_""_"^"_""_"^"_TDistrict_"^"_Name3
    .q:(qfPat="on")
    .i (BackType="on") d ..GetInsuBackInfo(intDate,iBingQu,PatNO,PatType) //查询首信回款信息
    .;i (BackType="on") d ..GetInsuBackDaily(intDate)
    .q:(BackType="on")
    .;下面取金算盘医保回款记录
    .s INPAYRowid=0 
    .f  s INPAYRowid=$o(^DHCINDSD(0,"Date",intDate,INPAYRowid)) q:INPAYRowid=""  d
    ..s ChildSub=0
    ..f  s ChildSub=$o(^DHCINDSD(0,"Date",intDate,INPAYRowid,ChildSub)) q:ChildSub=""  d
    ...s mCurrRowDue=$g(^DHCINDSD(INPAYRowid,"ChildSub",ChildSub))
    ...s PatName1=$p(mCurrRowDue,"^",2)
    ...s BackDate=$zd(intDate,3)
    ...s BackAmount=$p(mCurrRowDue,"^",4)
    ...s District1=$p(mCurrRowDue,"^",5)
    ...s AdmDr1=$p(^DHCINDIV(INPAYRowid),"^",1)
    ...s PapmiDr1=$p($g(^PAADM(AdmDr1)),"^",1)
    ...s Name31=$p($g(^PAPER(PapmiDr1,"ALL")),"^",19)
    ...i PatType'="" d
    ....s AdmReasonDr1=$p($g(^PAADM(AdmDr1,"1")),"^",7)
    ....s AdmReason1=$p(^PAC("ADMREA",AdmReasonDr1),"^",2)
    ...s CurrentWardDR1=$p($g(^PAADM(AdmDr1)),"^",70)
    ...s BingQu1=$p(^PAWARD(CurrentWardDR1),"^",1) ;pac_ward表
    ...s Flag=$p(mCurrRowDue,"^",6) ;回款标志,0为回款 ,1为拒付
    ...q:(iBingQu'="")&&(BingQu1'=iBingQu) ;筛选病区
    ...q:(PatNO'="")&&(Name31'=PatNO) ;筛选医保号
    ...q:(PatType'="")&&(AdmReason1'=PatType) ;筛选病人类型
    ...s i=i+1
    ...i Flag=1 d
    ....s ^CacheTemp($j,"InsuDueList",District1,intDate,i)=BackDate_"^"_BingQu1_"^"_"结转医保拒付"_"^"_PatName1_"^"_""_"^"_BackAmount_"^"_""_"^"_""_"^"_District1_"^"_Name31
    ...e  d
    ....s ^CacheTemp($j,"InsuDueList",District1,intDate,i)=BackDate_"^"_BingQu1_"^"_"医保回款"_"^"_PatName1_"^"_""_"^"_BackAmount_"^"_""_"^"_""_"^"_District1_"^"_Name31
    .q:(PatNO'="")
    .q:(iBingQu'="")
    .q:(PatType'="")
    .;下面取日计信息
    .s District2=0
    .f  s District2=$o(^CacheTemp($j,"InsuDueList",District2)) q:District2=""  d
    ..s INDUDRowid=0
    ..f  s INDUDRowid=$o(^DHCINDUD(0,"Date",intDate,INDUDRowid)) q:INDUDRowid=""  d
    ...s mCorr=$g(^DHCINDUD(INDUDRowid))
    ...q:mCorr=""
    ...s DistrictDaily=$p(mCorr,"^",6)
    ...q:District2'=DistrictDaily
    ...s i=i+1
    ...s JieFang=$p(mCorr,"^",1)
    ...s DaiFang=$p(mCorr,"^",2)
    ...s Balance=$p(mCorr,"^",3)
    ...s DailyFlag=$p(mCorr,"^",5)
    ...i DailyFlag="J"  s DailyFlag="借"
    ...i DailyFlag="D"  s DailyFlag="贷"
    ...i DailyFlag="P"  s DailyFlag="平"
    ...;s DailyDate=$zd(intDate,3)
    ...s ^CacheTemp($j,"InsuDueList",District2,intDate,i)=""_"^"_"日计"_"^"_""_"^"_""_"^"_JieFang_"^"_DaiFang_"^"_DailyFlag_"^"_Balance_"^"_District2
    ...s Demo=$p(mCorr,"^",7)
    ...i Demo'="" d  ;本月合计
    ....s i=i+1
    ....s ^CacheTemp($j,"InsuDueList",District2,intDate,i)=""_"^"_"本月合计"_"^"_""_"^"_""_"^"_JieFang_"^"_DaiFang_"^"_DailyFlag_"^"_Balance_"^"_District2
    ...i Demo="本年累计" d
    ....s i=i+1
    ....s ^CacheTemp($j,"InsuDueList",District2,intDate,i)=""_"^"_"本年累计"_"^"_""_"^"_""_"^"_JieFang_"^"_DaiFang_"^"_DailyFlag_"^"_Balance_"^"_District2
    ..;下面取前一天的余额
    ..s INDUDRowid=0,lastBalance=0,lastDistrict=""
    ..f  s INDUDRowid=$o(^DHCINDUD(0,"Date",(intDate-1),INDUDRowid)) q:INDUDRowid=""  d
    ...s lastDistrict=$p(^DHCINDUD(INDUDRowid),"^",6)
    ...;w District_"^"_lastDistrict,!
    ...q:District2'=lastDistrict
    ...s lastBalance=$p(^DHCINDUD(INDUDRowid),"^",3)
    ...s lastDate=$zd((intDate-1),3)
    ...s ^CacheTemp($j,"InsuDueList",District2,intDate,0)=lastDate_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_lastBalance_"^"_District2
	q $j_"^"_i
}

//取欠费记录

ClassMethod GetDivInfo(BegDate As %String, EndDate As %String, iBingQu As %String, PatNO As %String, PatType As %String, District As %String, qfPat As %String, JSPqfPat As %String) As %String
{
	s i=0
	s BegDate=$zdh(BegDate,3) //lou
	s EndDate=$zdh(EndDate,3)
	k ^CacheTemp($j,"NoDistrict")
	s TDistrict="",PatName="",Name3=""
    f intDate=BegDate:1:EndDate  d
    .;w "intdate=",intDate,!
    .s INPAYRowid=0 
    .f  s INPAYRowid=$o(^DHCINDIV("0","IDate",intDate,INPAYRowid)) q:INPAYRowid=""  d
    ..s mCurrRow=$g(^DHCINDIV(INPAYRowid))
    ..;q:($p(mCurrRow,"^",5)="bestrike")
    ..s inpaybackrowid="",childsub="",INDSDRowid=""
    ..q:(qfPat="on")&&($o(^DHCINPAB("0","DivideDr",INPAYRowid,inpaybackrowid))) ;筛选首信未回款的病人,insu_payback表中有的就退出
    ..;w INPAYRowid,!
    ..;筛选首信已回款金算盘未回款的病人,insu_payback中没有的退出,insu_dividesubdue中有的退出
    ..q:(JSPqfPat="on")&&('$o(^DHCINPAB("0","DivideDr",INPAYRowid,inpaybackrowid)))
    ..q:(JSPqfPat="on")&&($o(^DHCINDSD(INPAYRowid,"ChildSub",INDSDRowid))) 
    ..s iDate=$zd($p(mCurrRow,"^",16),3)
    ..s AdmDr=$p(mCurrRow,"^",1)
    ..q:AdmDr=""
    ..s TDistrict=##class(EPRservice.BOScatterData).GetEPRData(AdmDr,"住院病案摘要.病案首页.一般情况.首页一般情况.病人来源 #TYPE:Simple#TID:66#TVER:0#SCODE:O0074#VTYPE:V") ;区县 取自电子病历组
    ..q:(District'="")&&(District'=TDistrict)
    ..q:TDistrict["外省"
    ..s PapmiDr=$p($g(^PAADM(AdmDr)),"^",1)
    ..s PatName=$p($g(^PAPER(PapmiDr,"ALL")),"^",1)
    ..;!!!!有时候病案首页没有保存,先去地址找区县,再没有就设为无!!!!!!!!!!!!!!!!!!!!!!!!!!
    ..i TDistrict="" d
    ...s PaStname=$g(^PAPER(PapmiDr,"PER","ADD",1)) //地址
    ...q:PaStname=""  s TDistrict=""
    ...s InsuDistrictStr=$$GetDistrict^DHCINSUFacadeBJ()
    ...q:InsuDistrictStr=""  s TDistrict=""
    ...f districtnum=1:1:$l(InsuDistrictStr,"^") d
    ....s InsuDistrict=$p(InsuDistrictStr,"^",districtnum)
    ....i PaStname[InsuDistrict  s TDistrict=InsuDistrict
    ....q:TDistrict'=""
    ..i TDistrict=""  d
    ...s ^CacheTemp($j,"NoDistrict",AdmDr)=PatName_"^"_TDistrict_"^"_$zd(intDate,3) //将没有区县的病人保存以便查看
    ...s TDistrict="无"
    ..;!!!!!!!!!!!end lou 081105
    ..s Name3=$p($g(^PAPER(PapmiDr,"ALL")),"^",19)
    ..i PatType'="" d
    ...s AdmReasonDr=$p($g(^PAADM(AdmDr,"1")),"^",7)
    ...s AdmReason=$p(^PAC("ADMREA",AdmReasonDr),"^",2)
    ..s jjzfe=$p(mCurrRow,"^",19)
    ..;insu和bestrike都显示正数来累计，strike用负数来累计,bestrike为原来的,strike为新插入一条一样的数据
    ..i $p(mCurrRow,"^",5)="strike" s jjzfe=0-jjzfe
    ..s CurrentWardDR=$p($g(^PAADM(AdmDr)),"^",70)
    ..s BingQu=$p(^PAWARD(CurrentWardDR),"^",1) ;pac_ward表
    ..q:(iBingQu'="")&&(BingQu'=iBingQu) ;筛选病区
    ..q:(PatNO'="")&&(Name3'=PatNO) ;筛选医保号
    ..q:(PatType'="")&&(AdmReason'=PatType) ;筛选病人类型
    ..s i=i+1
    ..s ^CacheTemp($j,"InsuDueList",TDistrict,intDate,i)=iDate_"^"_BingQu_"^"_"应收医保欠费"_"^"_PatName_"^"_jjzfe_"^"_""_"^"_""_"^"_""_"^"_TDistrict_"^"_Name3
    q $j_"^"_i
}

//下面取金算盘医保回款记录

ClassMethod GetJSPBackInfo(BegDate As %String, EndDate As %String, iBingQu As %String, PatNO As %String, PatType As %String, District As %String, RefusePat As %String) As %String
{
	
    s BegDate=$zdh(BegDate,3) //lou
	s EndDate=$zdh(EndDate,3)
	s TDistrict="",PatName="",Name3="",Name31=""
    f intDate=BegDate:1:EndDate  d
	.s INPAYRowid=0 
	.;目前以insertdate为回款日期,因为日结的时候只能以导入日期来日结lou 081020
    .f  s INPAYRowid=$o(^DHCINDSD(0,"InsertDate",intDate,INPAYRowid)) q:INPAYRowid=""  d
    ..s ChildSub=0
    ..f  s ChildSub=$o(^DHCINDSD(0,"InsertDate",intDate,INPAYRowid,ChildSub)) q:ChildSub=""  d
    ...s mCurrRowDue=$g(^DHCINDSD(INPAYRowid,"ChildSub",ChildSub))
    ...s PatName1=$p(mCurrRowDue,"^",2)
    ...s BackDate=$zd(intDate,3)
    ...s BackAmount=$p(mCurrRowDue,"^",4)
    ...s District1=$p(mCurrRowDue,"^",5)
    ...q:(District'="")&&(District'=District1)
    ...s AdmDr1=$p(^DHCINDIV(INPAYRowid),"^",1)
    ...s PapmiDr1=$p($g(^PAADM(AdmDr1)),"^",1)
    ...s Name31=$p($g(^PAPER(PapmiDr1,"ALL")),"^",19)
    ...i PatType'="" d
    ....s AdmReasonDr1=$p($g(^PAADM(AdmDr1,"1")),"^",7)
    ....s AdmReason1=$p(^PAC("ADMREA",AdmReasonDr1),"^",2)
    ...s CurrentWardDR1=$p($g(^PAADM(AdmDr1)),"^",70)
    ...s BingQu1=$p(^PAWARD(CurrentWardDR1),"^",1) ;pac_ward表
    ...s Flag=$p(mCurrRowDue,"^",6) ;回款标志,0为回款 ,1为拒付
    ...q:(iBingQu'="")&&(BingQu1'=iBingQu) ;筛选病区
    ...q:(PatNO'="")&&(Name31'=PatNO) ;筛选医保号
    ...q:(PatType'="")&&(AdmReason1'=PatType) ;筛选病人类型
    ...q:(RefusePat="on")&&(Flag'="1") //只查询拒付的病人
    ...s i=i+1
    ...i Flag=1 d
    ....s ^CacheTemp($j,"InsuDueList",District1,intDate,i)=BackDate_"^"_BingQu1_"^"_"结转医保拒付"_"^"_PatName1_"^"_""_"^"_BackAmount_"^"_""_"^"_""_"^"_District1_"^"_Name31
    ...e  d
    ....s ^CacheTemp($j,"InsuDueList",District1,intDate,i)=BackDate_"^"_BingQu1_"^"_"医保回款"_"^"_PatName1_"^"_""_"^"_BackAmount_"^"_""_"^"_""_"^"_District1_"^"_Name31
    q $j_"^"_i
}

//取首信回款信息

ClassMethod GetInsuBackInfo(BegDate As %String, EndDate As %String, iBingQu As %String, PatNO As %String, PatType As %String, District As %String, RefusePat As %String) As %String
{
	s BegDate=$zdh(BegDate,3) //lou
	s EndDate=$zdh(EndDate,3)
    s PayBackInfo="",TDistrict="",BackDate="",BingQu=""
    f intDate=BegDate:1:EndDate  d
	.s CurrentWardDR1="",AdmDr="",DivideDr="",PapmiDr="",Name3="",PatName=""
	.s AdmReasonDr="",AdmReason="",RefuseAmount="",BackAmount="",RefuseDesc=""
    .s INPABrowid=0
    .;目前以insertdate为回款日期,因为日结的时候只能以导入日期来日结lou 081020
	.f  s INPABrowid=$o(^DHCINPAB("0","IDate",intDate,INPABrowid)) q:INPABrowid=""  d
	..s PayBackInfo=$g(^DHCINPAB(INPABrowid))
	..q:(PayBackInfo="")
	..s BackDate=$zd(intDate,3)
	..s DivideDr=$p(PayBackInfo,"^",1)
	..s TDistrict=$p(PayBackInfo,"^",4)
	..q:(District'="")&&(District'=TDistrict)
	..s PatName=$p(PayBackInfo,"^",2)
	..s BackAmount=(+$p(PayBackInfo,"^",7))+(+$p(PayBackInfo,"^",8)) //统筹加上大额
	..s RefuseAmount=+$p(PayBackInfo,"^",9) //拒付金额
	..q:(RefusePat="on")&&(RefuseAmount=0) //只查询拒付的病人
	..s RefuseDesc=$p(PayBackInfo,"^",10) //拒付原因
	..s Name3=$p(PayBackInfo,"^",3)
	..s AdmDr=$p(^DHCINDIV(DivideDr),"^",1)
	..s AdmReasonDr=$p($g(^PAADM(AdmDr,"1")),"^",7)
	..s AdmReason=$p(^PAC("ADMREA",AdmReasonDr),"^",2)
	..s PapmiDr=$p($g(^PAADM(AdmDr)),"^",1)
	..s CurrentWardDR1=$p($g(^PAADM(AdmDr)),"^",70)
	..s BingQu=$p(^PAWARD(CurrentWardDR1),"^",1) ;pac_ward表
	..q:(iBingQu'="")&&(BingQu'=iBingQu) ;筛选病区
	..q:(PatNO'="")&&(Name3'=PatNO) ;筛选医保号
	..q:(PatType'="")&&(AdmReason'=PatType) ;筛选病人类型
	..s i=i+1
	..s ^CacheTemp($j,"InsuDueList",TDistrict,intDate,i)=BackDate_"^"_BingQu_"^"_"医保回款"_"^"_PatName_"^"_""_"^"_BackAmount_"^"_""_"^"_""_"^"_TDistrict_"^"_Name3
	..i RefuseAmount'=0 d //有医保拒付发生时
	...s i=i+1
	...i RefuseDesc="" s RefuseDesc="结转医保拒付"
	...e  s RefuseDesc="结转医保拒付("_RefuseDesc_")"
	...s ^CacheTemp($j,"InsuDueList",TDistrict,intDate,i)=BackDate_"^"_BingQu_"^"_RefuseDesc_"^"_PatName_"^"_""_"^"_RefuseAmount_"^"_""_"^"_""_"^"_TDistrict_"^"_Name3
    q $j_"^"_i
}

//取日结信息

ClassMethod GetDailyInfo(BegDate As %String, EndDate As %String, District As %String, BackType As %String) As %String
{
	s BegDate=$zdh(BegDate,3) //lou
	s EndDate=$zdh(EndDate,3)
	if BackType="on" s BackType="1" ;首信回款
	e  s BackType="0" ;金算盘回款
    f intDate=BegDate:1:EndDate  d
    .s INDUDRowid=0
    .f  s INDUDRowid=$o(^DHCINDUD(0,"Date",intDate,INDUDRowid)) q:INDUDRowid=""  d
    ..s mCorr=$g(^DHCINDUD(INDUDRowid))
    ..q:mCorr=""
    ..s DistrictDaily=$p(mCorr,"^",6)
    ..s BackTypeDaily=$p(mCorr,"^",8)
    ..q:(BackType'="")&&(BackType'=BackTypeDaily) ;筛选是首信回款还是金算盘回款日结
    ..q:(District'="")&&(District'=DistrictDaily) ;筛选区县
    ..s JieFang=$p(mCorr,"^",1)
    ..s DaiFang=$p(mCorr,"^",2)
    ..s Balance=$p(mCorr,"^",3)
    ..s DailyFlag=$p(mCorr,"^",5)
    ..i DailyFlag="J"  s DailyFlag="借"
    ..i DailyFlag="D"  s DailyFlag="贷"
    ..i DailyFlag="P"  s DailyFlag="平"
    ..s i=i+1
    ..s ^CacheTemp($j,"InsuDueList",DistrictDaily,intDate,i)=""_"^"_"日计"_"^"_""_"^"_""_"^"_JieFang_"^"_DaiFang_"^"_DailyFlag_"^"_Balance_"^"_DistrictDaily
    ..s Demo=$p(mCorr,"^",7)
    ..;后台如果存本年累计时也显示一条相同的数据叫本月合计,即最后一天的日计=本月合计=本年累计
    ..i Demo'="" d  ;本月合计,本年累计
    ...s i=i+1
    ...s ^CacheTemp($j,"InsuDueList",DistrictDaily,intDate,i)=""_"^"_"本月合计"_"^"_""_"^"_""_"^"_JieFang_"^"_DaiFang_"^"_DailyFlag_"^"_Balance_"^"_DistrictDaily
    ..i Demo="本年累计"
    ...s i=i+1
    ...s ^CacheTemp($j,"InsuDueList",DistrictDaily,intDate,i)=""_"^"_Demo_"^"_""_"^"_""_"^"_JieFang_"^"_DaiFang_"^"_DailyFlag_"^"_Balance_"^"_DistrictDaily
    .;下面取前一天的余额
    .s INDUDRowid=0,lastBalance=0,lastDistrict=""
    .f  s INDUDRowid=$o(^DHCINDUD(0,"Date",(intDate-1),INDUDRowid)) q:INDUDRowid=""  d
    ..s lastDistrict=$p(^DHCINDUD(INDUDRowid),"^",6)
    ..s BackTypeDaily=$p(^DHCINDUD(INDUDRowid),"^",8)
    ..q:(BackType'="")&&(BackType'=BackTypeDaily) ;筛选是首信回款还是金算盘回款日结
    ..q:(District'="")&&(District'=lastDistrict)
    ..s lastBalance=$p(^DHCINDUD(INDUDRowid),"^",3)
    ..s lastDate=$zd((intDate-1),3)
    ..s ^CacheTemp($j,"InsuDueList",DistrictDaily,intDate,0)=lastDate_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_lastBalance_"^"_DistrictDaily
    q $j_"^"_i
}

//计算出拒付的日结数据及余额数据

ClassMethod GetRefuseSumInfo(BegDate As %String, EndDate As %String, District As %String, BackType As %String) As %String
{
	s BegDate=$zdh(BegDate,3) 
	s EndDate=$zdh(EndDate,3)
	s RefuseAmount=0,RefuseAmtSum=0,LastRefuseSum=0,TheRefuseSum=0
	i BackType="on" d //首信回款
	.s INPABRowID=0
	.f  s INPABRowID=$o(^DHCINPAB(INPABRowID)) q:INPABRowID=""  d
	..s PayBackInfo=$g(^DHCINPAB(INPABrowid))
	..s RefuseAmount=+$p(PayBackInfo,"^",9)
	..q:(RefuseAmount=0)
	..s TDistrict=$p(PayBackInfo,"^",4)
	..q:(District'="")&&(District'=TDistrict)
	..s RefuseAmtSum=RefuseAmtSum+RefuseAmount
	..s BackDate=$p(PayBackInfo,"^",11)
	..if BackDate=BegDate s LastRefuseSum=RefuseAmtSum //此开始日期之前的余额
	..q:BackDate=EndDate //查询到此结束日期为止
	e   d
	.s INPAYRowid=0
	.f  s INPAYRowid=$o(^DHCINDSD(INPAYRowid,"ChildSub",2)) q:INPAYRowid=""  d
	..s mCurrRowDue=$g(^DHCINDSD(INPAYRowid,"ChildSub",2))
	..s BackAmount=$p(mCurrRowDue,"^",4)
	..s Flag=$p(mCurrRowDue,"^",6) ;回款标志,0为回款 ,1为拒付
	..q:(Flag'="1")
	..s TDistrict=$p(mCurrRowDue,"^",5)
	..q:(District'="")&&(District'=TDistrict)
	..s RefuseAmtSum=RefuseAmtSum+BackAmount
	..s BackDate=$p(mCurrRowDue,"^",3)
	..if BackDate=BegDate s LastRefuseSum=RefuseAmtSum
	..q:BackDate=EndDate //查询到此结束日期为止
	q:(RefuseAmtSum=0)
	s ^CacheTemp($j,"InsuDueList",TDistrict,intDate,0)=$zd(intDate,3)_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_LastRefuseSum_"^"_TDistrict
	s i=i+1
	s TheRefuseSum=LastRefuseSum+RefuseAmtSum
    s ^CacheTemp($j,"InsuDueList",TDistrict,intDate,i)=""_"^"_"日计"_"^"_""_"^"_""_"^"_RefuseAmtSum_"^"_""_"^"_"借"_"^"_TheRefuseSum_"^"_TDistrict	//f intDate=0:1:BegDate  d //计算此开始日期之前的余额
	//f intDate=BegDate:1:EndDate  d
}

ClassMethod GetAllFromCacheTemp(ID As %String, District As %String, intDate As %String, i As %String) As %String
{
	new (ID,i,District,intDate)
	s intDate=$zdh(intDate,3)
	s GetAllFromCacheTemp=""
	s GetAllFromCacheTemp=$g(^CacheTemp(ID,"InsuDueList",District ,intDate,i))
	q GetAllFromCacheTemp
}

Query LookUpBingQu() As %Query(ROWSPEC = "病区:%String")
{
}

ClassMethod LookUpBingQuExecute(ByRef qHandle As %Binary) As %Status
{
	set repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s WARDRowID=0
	f  s WARDRowID=$o(^PAWARD(WARDRowID)) q:WARDRowID=""  d
	.s mCorr=$g(^PAWARD(WARDRowID))
	.s WARDCode=$p(mCorr,"^",1)
	.d Build
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build
	set Data=$lb(WARDCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod LookUpBingQuFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpBingQuExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod LookUpBingQuClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpBingQuExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

Query LookUpPatType() As %Query(ROWSPEC = "病人类别:%String,代码:%String")
{
}

ClassMethod LookUpPatTypeExecute(ByRef qHandle As %Binary) As %Status
{
	set repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s REARowId=0
	f  s REARowId=$o(^PAC("ADMREA",REARowId)) q:REARowId=""  d
	.s PatType=$p($g(^PAC("ADMREA",REARowId)),"^",1)
	.q:PatType="01"
	.s PatTypeDesc=$p($g(^PAC("ADMREA",REARowId)),"^",2)
	.d OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(PatTypeDesc,PatType)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod LookUpPatTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpPatTypeExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod LookUpPatTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpPatTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod GetBalanceByDate(iDate As %String) As %String
{
	n (iDate)
	s INDUDrowid=0,Balance=""
	f  s INDUDrowid=$o(^DHCINDUD(0,"Date",iDate,INDUDrowid)) q:INDUDrowid=""  d
	.s mCorrRow=$g(^DHCINDUD(INDUDrowid))
	.s Balance=$p(mCorrRow,"^",3)
	q Balance
}

ClassMethod GetBalanceByDistrict(District As %String, BackType As %String, Date As %String) As %String
{
	;获得此区县的前天的余额
	n (District,BackType,Date)
	s INDUDrowid=0,Balance=""
	s Date=$zdh(Date,3)-1
	f  s INDUDrowid=$o(^DHCINDUD(0,"Date",Date,INDUDrowid)) q:INDUDrowid=""  d
	.s mCorrRow=$g(^DHCINDUD(INDUDrowid))
	.s DailyDistrict=$p(mCorrRow,"^",6)
	.s BackTypeDaily=$p(mCorrRow,"^",8)
	.q:(BackTypeDaily'=BackType) ;首信还是金算盘
	.q:(DailyDistrict'=District)
	.s Balance=$p(mCorrRow,"^",3)
	q Balance
}

Query QueryINSUDueSum(BegDate As %String, EndDate As %String, District As %String, BackType As %String) As %Query(ROWSPEC = "TDate:%String,TSummary:%String,TJieFang:%String,TDaiFang:%String,TFlag:%String,TBalance:%String")
{
}

ClassMethod QueryINSUDueSumExecute(ByRef qHandle As %Binary, BegDate As %String, EndDate As %String, s As %String, BackType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	if (BegDate="")||(EndDate="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	s TBalancesum=0
	;1为首信，0为金算盘
	i BackType="on" s BackType="1"
	e   s BackType="0"
	f intDate=BegDate:1:EndDate  d
	.s INDUDRowid=0
	.q:$o(^DHCINDUD(0,"Date",intDate,INDUDRowid))="" ;日计表没数据时退出
	.;s lastBalancesum=0,lastBalance=0,TBackType="",mCorrRow=""
	.;s lastDate=intDate-1 ;下面取前一天的余额
	.;f  s INDUDRowid=$o(^DHCINDUD(0,"Date",lastDate,INDUDRowid)) q:INDUDRowid=""  d
	..;s mCorrRow=$g(^DHCINDUD(INDUDRowid))
	..;s TBackType=$p(mCorrRow,"^",8)
	..;q:(TBackType'=BackType)
	..;s lastBalance=$j($p(mCorrRow,"^",3),3,2)
	..;s lastBalancesum=lastBalancesum+lastBalance ;将各个区县的前一天余额累计
	.;下面取当天的信息
	.s TBalance="",TFlag="",TJieFangsum=0,TDaiFangsum=0,TDate=""
	.s TSummary="",Demo="",TBackType="",mCorrRow="",Balance="",TBalancesum=0
	.s TJieFang=0,DaiFang=0,TDaiFang=0
	.f  s INDUDRowid=$o(^DHCINDUD(0,"Date",intDate,INDUDRowid)) q:INDUDRowid=""  d
	..s mCorrRow=$g(^DHCINDUD(INDUDRowid))
	..q:mCorrRow=""
	..s TDate=$zd(intDate,3)
	..s TDistrict=$p(mCorrRow,"^",6)
	..s JieFang=$j($p(mCorrRow,"^",1),3,2)
	..s DaiFang=$j($p(mCorrRow,"^",2),3,2)
	..s Balance=$j($p(mCorrRow,"^",3),3,2)
	..s TBackType=$p(mCorrRow,"^",8)
	..q:(TBackType'=BackType)
	..s TJieFangsum=TJieFangsum+JieFang
	..s TDaiFangsum=TDaiFangsum+DaiFang
	..s TBalancesum=TBalancesum+Balance
	..s Demo=$p(mCorrRow,"^",7)
	..i TDistrict["无" s TDistrict="空区县"
	..i JieFang'="0.00" d
	...s TSummary="应收"_TDistrict_"医保欠费",TJieFang=JieFang,TDaiFang=""
	...d OutputRow3
	..i DaiFang'="0.00" d
	...s TSummary=TDistrict_"医保回款",TDaiFang=DaiFang,TJieFang=""
	...d OutputRow3
	.;对上面的解释:如果有借方则显示应收医保欠费不显示贷方,如果有贷方显示医保回款,不显示借方
	.q:$o(^DHCINDUD(0,"Date",intDate,INDUDRowid))=""  
	.s TDate=""
	.;s TBalancesum=TBalancesum+TJieFangsum-TDaiFangsum
	.;s TBalancesum=TBalancesum+lastBalancesum
	.s TBalance=$j(TBalancesum,3,2)
	.s TSummary="日计"
	.s TJieFang=$j(TJieFangsum,3,2)
	.s TDaiFang=$j(TDaiFangsum,3,2)
	.q:(TJieFang="0.00")&&(TDaiFang="0.00") ;当天没有发生任何费用时不显示出来
	.i TJieFang>TDaiFang s TFlag="借"
	.i TJieFang=TDaiFang s TFlag="平"
	.i TJieFang<TDaiFang s TFlag="贷"
	.d OutputRow3
	.;后台如果存本年累计时也显示一条相同的数据叫本月合计,即最后一天的日计=本月合计=本年累计
	.i Demo'="" d
	..s TSummary="本月合计"
	..d OutputRow3
	.i Demo="本年累计" d
	..s TSummary="本年累计"
	..d OutputRow3
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow3
	set Data=$lb(TDate,TSummary,TJieFang,TDaiFang,TFlag,TBalance)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryINSUDueSumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryINSUDueSumExecute ]
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

ClassMethod QueryINSUDueSumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryINSUDueSumExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query LookUpDistrict() As %Query(ROWSPEC = "区县:%String")
{
}

ClassMethod LookUpDistrictExecute(ByRef qHandle As %Binary) As %Status
{
	set repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
    s strDistrict=$$GetDistrict^DHCINSUFacadeBJ()
    f i=1:1:$l(strDistrict,"^") d
    .s District =$p(strDistrict,"^",i)
    .d LookUpDistrict
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
LookUpDistrict
	set Data=$lb(District)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod LookUpDistrictFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpDistrictExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod LookUpDistrictClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpDistrictExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

//日结主程序,凌晨两点自动执行,查询前一天的数据

ClassMethod DailyCount() As %String
{
	s Date=$p($h,",",1)-1 ;查询昨天的数据
	s Date=$zd(Date,3)
	//s Date="2008-11-6"
	;BackType="1" 首信,"0" 金算盘
	f BackType=0:1:1 d
	.;w BackType,!
    .d ..GetListInfoForDaily(Date, Date, BackType)
    .//f j=1:1:18 d
    ..//s TDistrict=..DistrictList(j) ;循环每个区县
    .s InsuDistrictStr=$$GetDistrict^DHCINSUFacadeBJ()
    .q:InsuDistrictStr=""  s TDistrict=""
    .f j=1:1:$l(InsuDistrictStr,"^") d
    ..s TDistrict=$p(InsuDistrictStr,"^",j)
    ..s TDate="",TBingQu="",TSummary="",TPatName="",TJieFang=0.00,Demo=""
    ..s TDaiFang=0.00,TFlag="",TBalance=0.00,JieDaiBalance=0.00,Balance=0.00
    ..s intDate=0
    ..f  s intDate=$o(^CacheTemp($j,"InsuDueList",TDistrict,intDate)) q:intDate=""  d
	...s i=0
	...f  s i=$o(^CacheTemp($j,"InsuDueList",TDistrict,intDate,i)) q:i=""  d
	....s mCurrRowAll=$g(^CacheTemp($j,"InsuDueList",TDistrict,intDate,i))
	....s TJieFang=$j(TJieFang,3,2)+$j($p(mCurrRowAll,"^",5),3,2)
	....s TDaiFang=$j(TDaiFang,3,2)+$j($p(mCurrRowAll,"^",6),3,2)
	..s TBalance=$j(..GetBalanceByDistrict(TDistrict,BackType,Date),3,2) ;取前天余额
	..s JieDaiBalance=$j((TJieFang-TDaiFang),3,2) ;借贷差额
	..s Balance=TBalance+JieDaiBalance ;算出昨天的余额
	..if JieDaiBalance>0.00 s TFlag="J" ;借
	..if JieDaiBalance=0.00 s TFlag="P" ;平
	..if JieDaiBalance<0.00 s TFlag="D" ;贷
	..s Month=$p(Date,"-",2)
	..i $p($zd($zdh(Date,3)+1,3),"-",2)'=Month d ;如果明天的月份不等于今天的月份表示今天为月末
	...s Demo="本月合计"
	...i Month="12" s Demo="本年累计" ;表示为十二月末
	..s strDaily=TJieFang_"^"_TDaiFang_"^"_Balance_"^"_Date_"^"_TFlag_"^"_TDistrict_"^"_Demo_"^"_BackType
	..;w strDaily,!
	..d ..SaveDaily(strDaily)
	k ^CacheTemp($j,"InsuDueList")
}

ClassMethod QueryIPFootPatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryIPFootPatListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryIPFootPatListExecute(ByRef qHandle As %Binary, Date As %String, PatType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	//i StDate="" Set qHandle=$lb(0,repid,0) 	Quit $$$OK
	s Tnum="",TPatName="",TName3="",TDistrict=""
	s INPAYID=0,i=0,AmountSum=0
	f  s INPAYID=$o(^DHCINDIV("0","IDate",Date,INPAYID)) q:INPAYID=""  d
	.s str=""
	.s mCorr=$g(^DHCINDIV(INPAYID))
	.s PAADMDr=$p(mCorr,"^",1)
	.s PapmiDr=$p($g(^PAADM(PAADMDr)),"^",1)
	.q:PapmiDr=""
	.s AdmReasonDR=$p(^PAADM(PAADMDr,1),"^",7)
	.q:AdmReasonDR=""
	.s AdmReasonDesc=$p($g(^PAC("ADMREA",AdmReasonDR)),"^",2)
	.q:(AdmReasonDesc'=PatType)
	.s TPatName=$p(^PAPER(PapmiDr,"ALL"),"^",1)
	.s TName3=$p(^PAPER(PapmiDr,"ALL"),"^",19)
	.s TAmount=$p(mCorr,"^",19)
	.s AmountSum=AmountSum+TAmount
	.s TDistrict=##class(EPRservice.BOScatterData).GetEPRData(PAADMDr,"住院病案摘要.病案首页.一般情况.首页一般情况.病人来源 #TYPE:Simple#TID:66#TVER:0#SCODE:O0074#VTYPE:V") ;区县 取自电子病历组
	.i TDistrict="" s TDistrict="无"
	.s str=TPatName_"^"_TName3_"^"_TDistrict_"^"_TAmount
	.s i=i+1
	.s ^InsuIPFootPatList($j,TDistrict,i)=str
	s District="",TPatName="",TName3="",TDistrict="",TAmount="",Tnum="",j=0
	f  s District=$o(^InsuIPFootPatList($j,District)) q:District=""  d
	.s num=0
	.f  s num=$o(^InsuIPFootPatList($j,District,num)) q:num=""  d
	..s mCorrRow=$g(^InsuIPFootPatList($j,District,num))
	..q:mCorrRow=""
	..s j=j+1
	..s TPatName=$p(mCorrRow,"^",1)
	..s TName3=$p(mCorrRow,"^",2)
	..s TDistrict=$p(mCorrRow,"^",3)
	..s TAmount=$p(mCorrRow,"^",4)
	..s Tnum=j
	..d BuildIPFootPatList
	k ^InsuIPFootPatList
	s TAmount=AmountSum
	s Tnum="合计",TPatName="",TName3="",TDistrict=""
	d BuildIPFootPatList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildIPFootPatList      
	set Data=$lb(Tnum,TPatName,TName3,TDistrict,TAmount)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryIPFootPatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryIPFootPatListExecute ]
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

Query QueryIPFootPatList(Date As %String, PatType As %String) As %Query(ROWSPEC = "Tnum:%String,TPatName:%String,TName3:%String,TDistrict:%String,TAmount:%String")
{
}

}
