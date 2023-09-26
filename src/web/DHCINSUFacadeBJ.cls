Import SQLUser

Class web.DHCINSUFacadeBJ Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 2497;

//此文件用于北京地坛医院医保欠费帐,20080624,LOU

//卡支付

ClassMethod GetInsuZyjsInfoBJ(Name3 As %String, iAmount As %String) As %String
{
	s GetInsuZyjsInfoBJ=$$GetInsuZyjsInfoBJ^DHCINSUFacadeBJ(Name3,iAmount)
	q GetInsuZyjsInfoBJ
}

//w ##class(web.DHCINSUFacadeBJ).InsertDivSubDue("474^1^0115400108083100005G^张秀荣^2008-10-6^23175.77^^^0")

ClassMethod InsertDivSubDue(Str As %String) As %String
{
	n (Str)
	s INPAYrowid=$p(Str,"^",1)
	s ChildSub=$p(Str,"^",2)
	s INDSDrowid=0,Flag="N"
	f  s INDSDrowid=$o(^DHCINDSD(0,"DivideDr",INPAYrowid,INDSDrowid)) q:INDSDrowid=""  d
	.s Child=$p($g(^DHCINDSD(INDSDrowid)),"^",10)
	.s BillDate=""
	.s BillDate=$p($g(^DHCINDSD(INDSDrowid)),"^",9)
	.i Child=ChildSub s Flag="Y"
	.q:Flag="Y"
	i Flag="Y" d
	.;s InsertDivSubDue=$$UpdateDivSubDue^DHCINSUFacadeBJ(Str)
	.s InsertDivSubDue=0 ;LOU 2008-12-26
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
	.;s SaveInsuPayBack=$$UpdateInsuPayBack^DHCINSUFacadeBJ(INDivrowid)
	.;s SaveInsuPayBack=$$InsertInsuPayBack^DHCINSUFacadeBJ(Str)
	.s SaveInsuPayBack=0
	e  d
	.s SaveInsuPayBack=$$InsertInsuPayBack^DHCINSUFacadeBJ(Str)
	q SaveInsuPayBack
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

Query QueryINSUDueList(BegDate As %String, EndDate As %String, District As %String, PatNO As %String, iAmount As %String, qfPat As %String, BackType As %String, JSPqfPat As %String, HKPat As %String, RefusePat As %String) As %Query(ROWSPEC = "TDate:%String,TBingQu:%String,TSummary:%String,TPatName:%String,TJieFang:%String,TDaiFang:%String,TFlag:%String,TBalance:%String,TDistrict:%String,TName3:%String,INPAYRowid:%String")
{
}

ClassMethod QueryINSUDueListExecute(ByRef qHandle As %Binary, BegDate As %String, EndDate As %String, District As %String, PatNO As %String, iAmount As %String, qfPat As %String, BackType As %String, JSPqfPat As %String, HKPat As %String, RefusePat As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
    if (EndDate="") Set qHandle=$lb(0,repid,0) Quit $$$OK
    if (BegDate="") set BegDate="61220"
    s BegDate=$zd(BegDate,3),EndDate=$zd(EndDate,3) //lou 
    
    //BackType为是首信回款还是金算盘回款，on为首信
    //d ..GetAllDistrictList(BegDate,EndDate,BingQu, PatNO, PatType,qfPat,BackType)
    s BingQu="",PatType="" ;LOU 2008-12-28 去掉这两个筛选条件
    d ..QueryList(BegDate, EndDate, District, BingQu, PatNO, PatType, iAmount, qfPat, BackType,JSPqfPat,HKPat,RefusePat)
    s TDate="",TBingQu="",TSummary="",TPatName="",TJieFang="",TDaiFang="",TFlag="",TBalance=""
    s TDistrict=0,JieSum=0,DaiSum=0
    f  s TDistrict=$o(^CacheTemp($j,"InsuDueList",TDistrict)) q:TDistrict=""   d
    .;w "1=",District_"^"_TDistrict,!
    .s intDate=0
    .f  s intDate=$o(^CacheTemp($j,"InsuDueList",TDistrict,intDate)) q:intDate=""  d
	..s i=""
	..f  s i=$o(^CacheTemp($j,"InsuDueList",TDistrict,intDate,i)) q:i=""  d
	...s TJieFang="",TDaiFang="",TBalance=""
	...s mCurrRowAll=$g(^CacheTemp($j,"InsuDueList",TDistrict,intDate,i))
	...s TDate=$p(mCurrRowAll,"^",1)
	...s TBingQu=$p(mCurrRowAll,"^",2)
	...s TSummary=$p(mCurrRowAll,"^",3)
	...s TPatName=$p(mCurrRowAll,"^",4)
	...s INPAYRowid=$p(mCurrRowAll,"^",11) ;LOU 2008-12-28 用于手工输入贷方
	...i $p(mCurrRowAll,"^",5)'="" s TJieFang=$j($p(mCurrRowAll,"^",5),3,2) ;这个判断是为了不显示0.00金额
	...i $p(mCurrRowAll,"^",6)'="" s TDaiFang=$j($p(mCurrRowAll,"^",6),3,2)
	...s TFlag=$p(mCurrRowAll,"^",7) 
	...i $p(mCurrRowAll,"^",8)'="" s TBalance=$j($p(mCurrRowAll,"^",8),3,2) ;同上 余额
	...q:(TJieFang="0.00")&&(TDaiFang="0.00")&&(TSummary'="本月合计")&&(TSummary'="本年累计")
	...s TName3=$p(mCurrRowAll,"^",10)
	...q:(iAmount'="")&&(TJieFang'=iAmount) ;筛选金额
	...;i RefusePat="on"  s TJieFang=TDaiFang,TDaiFang=0 ;如果查找医保拒付的病人，则将只会有贷方 将贷方金额显示在借方的位置
	...d OutputRow2
	...s JieSum=JieSum+TJieFang,DaiSum=DaiSum+TDaiFang
	;如果没有日结，显示合计,最好日期从最初开始,人工控制
	i (qfPat="on")||(JSPqfPat="on")||(HKPat="on")||(RefusePat="on")||(District="") d
	.s TDate="",TBingQu="",TPatName="",TFlag="",TBalance="",TDistrict="",TName3=""
	.s TSummary="合计",TJieFang=JieSum,TDaiFang=DaiSum
	.d OutputRow2
	;k ^CacheTemp($j,"NoDistrict")
	k ^CacheTemp($j,"InsuDueList")
	k ^INSUUpDateFlag
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(TDate,TBingQu,TSummary,TPatName,TJieFang,TDaiFang,TFlag,TBalance,TDistrict,TName3,INPAYRowid)
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

//w ##class(web.DHCINSUFacadeBJ).QueryList("2008-08-01","2008-11-22","","","","","","","","","","")

ClassMethod QueryList(BegDate As %String, EndDate As %String, District As %String, iBingQu As %String, PatNO As %String, PatType As %String, iAmount As %String, qfPat As %String, BackType As %String, JSPqfPat As %String, HKPat As %String, RefusePat As %String) As %String
{
	k ^CacheTemp($j,"InsuDueList")
	s ^liusf(1236)="BegDate="_BegDate_"EndDate="_EndDate_"District="_District_"iBingQu="_iBingQu_"PatNO="_PatNO_"PatType="_PatType_"iAmount="_iAmount_"qfPat="_qfPat_"BackType="_BackType_"JSPqfPat="_JSPqfPat_"HKPat="_HKPat_"RefusePat="_RefusePat
	s ^liusf(1236,1)=BegDate_","_EndDate_","_District_","_iBingQu_","_PatNO_","_PatType_","_iAmount_","_qfPat_","_BackType_","_JSPqfPat_","_HKPat_","_RefusePat
	s i=0
	;modify by LOU 2008-12-23 修改各个查询判断条件
    ;w $j
    ;查询首信回款欠费帐
    i BackType="on" d
    .;w !,"1"
    .d ..GetDivInfo(BegDate, EndDate, iBingQu, PatNO, PatType, District,qfPat,JSPqfPat,BackType,"") //获得结算信息
    .d ..GetInsuBackInfo(BegDate, EndDate, iBingQu, PatNO, PatType, District,RefusePat,"","",BackType) //获得首信回款
    
    ;查询金算盘回款欠费帐
    i (BackType'="on")&&(qfPat'="on")&&(JSPqfPat'="on")&&(HKPat'="on")&&(RefusePat'="on") d //增加后面的条件是因为当不勾上回款类别时,下面的四个查询勾可以勾上,增加这个判断当查询勾上时不走此处的程序
    .;w !,"2"
    .d ..GetInsuBackInfo(BegDate, EndDate, iBingQu, PatNO, PatType, District,RefusePat,"","",BackType) //获得首信回款
    .d ..GetJSPBackInfo(BegDate, EndDate, iBingQu, PatNO, PatType, District,RefusePat,"") //获得金算盘回款
    
    ;若只查询首信未回款的病人
    i qfPat="on"  d
    .;w !,"3"
    .d ..GetDivInfo(BegDate, EndDate, iBingQu, PatNO, PatType, District,qfPat,JSPqfPat,BackType,"") //获得结算信息
    
    ;查询已回款但未到账的病人
    i JSPqfPat="on" d
    .;w !,"4"
    .d ..GetInsuBackInfo(BegDate, EndDate, iBingQu, PatNO, PatType, District,RefusePat,"",JSPqfPat,BackType) //获得首信回款
    
    ;查询已到账的病人
	i HKPat="on"  d   ;金算盘回款
	.;w !,"5"
	.d ..GetJSPBackInfo(BegDate, EndDate, iBingQu, PatNO, PatType, District,RefusePat,"")
	
	;查询医保拒付病人
	i RefusePat="on" d
	.;w !,"6"
	.d ..GetRefuseSumInfo(BegDate, EndDate, District, BackType) //拒付的进行计算余额等内容
    
    q:(qfPat="on")||(JSPqfPat="on")||(HKPat="on")||(RefusePat="on")||(District="") ;不选择区县时不显示日结，查出所有区县的欠费和回款,选择了4个查询条件时不显示日结
    q:(PatNO'="")||(iAmount'="")
    ;w !,"7"
    d ..GetDailyInfo(BegDate, EndDate, District, BackType) //获得日结
    d ..GetlastBalance(BegDate, District, BackType) //取上期余额

    ;取月计
    ;q:(qfPat="on")||(JSPqfPat="on")||(HKPat="on")||(RefusePat="on")||(District="") 
    ;d ..GetMonthInfo()
}

//为日结获得借方贷方等信息

ClassMethod GetListInfoForDaily(BegDate As %String, EndDate As %String, BackType As %String) As %String
{
	k ^CacheTemp($j,"InsuDueList")
	s i=0
	;BackType="1" 首信,"0" 金算盘
	;modify by LOU 2008-12-23 修改判断条件,使做金算盘的日结时借方为首信回款
	i BackType=1 s BackType="on"
	i BackType=0 s BackType="off"
	i BackType="on" d
	.d ..GetDivInfo(BegDate, EndDate, "", "", "", "","","",BackType,"B") //获得结算信息
	.;w "11=",BackType,!
	.d ..GetInsuBackInfo(BegDate, EndDate, "", "", "", "","","B","",BackType) //获得首信回款
	i BackType'="on" d
	.d ..GetInsuBackInfo(BegDate, EndDate, "", "", "", "","","B","",BackType) //获得首信回款
	.d ..GetJSPBackInfo(BegDate, EndDate, "", "", "", "","","B") //获得金算盘回款
	q i
}

//取欠费记录

//w ##class(web.DHCINSUFacadeBJ).GetDivInfo("2008-11-20","2008-11-22","","","","","on","")

ClassMethod GetDivInfo(BegDate As %String, EndDate As %String, iBingQu As %String, PatNO As %String, PatType As %String, District As %String, qfPat As %String, JSPqfPat As %String, BackType As %String, BillFlag As %String) As %String
{
	;s i=0
	s ^liusf(123)="BegDate="_BegDate_"EndDate="_EndDate_"iBingQu="_iBingQu_"PatNO="_PatNO_"PatType="_PatType_"District="_District_"qfPat="_qfPat_"JSPqfPat="_JSPqfPat
	s ^liusf(123,1)=BegDate_","_EndDate_","_iBingQu_","_PatNO_","_PatType_","_District_","_qfPat_","_JSPqfPat
	s BegDate=$zdh(BegDate,3) //lou
	s EndDate=$zdh(EndDate,3)
	k ^CacheTemp($j,"NoDistrict")
	s TDistrict="",PatName="",Name3=""
    f intDate=BegDate:1:EndDate  d
    .;w "intdate=",intDate,!
    .s INPAYRowid=0 
    .f  s INPAYRowid=$o(^DHCINDIVPre(0,"iDate",intDate,INPAYRowid)) q:INPAYRowid=""  d
    ..s mCurrRow=$g(^DHCINDIVPre(INPAYRowid))
    ..;q:($p(mCurrRow,"^",5)="bestrike")
    ..q:(BillFlag="B")&&($p(mCurrRow,"^",49)'="") ;49-Zstr14存做账日期有值表示已做过日结，此处退出是不再参与日结LOU 2008-12-22
    ..s inpaybackrowid="",childsub="",INDSDRowid=""
    ..q:(qfPat="on")&&($o(^DHCINPAB("0","DivideDr",INPAYRowid,inpaybackrowid))) ;筛选首信未回款的病人,insu_payback表中有的就退出
    ..;筛选首信已回款金算盘未回款的病人,insu_payback中没有的退出,insu_dividesubdue中有的退出
    ..q:(JSPqfPat="on")&&('$o(^DHCINPAB("0","DivideDr",INPAYRowid,inpaybackrowid)))
    ..q:(JSPqfPat="on")&&($o(^DHCINDSD(0,"DivideDr",INPAYRowid,INDSDRowid))) 
    ..s iDate=$zd($p(mCurrRow,"^",16),3)
    ..s TDistrict=$p(mCurrRow,"^",8)  ; ##class(EPRservice.BOScatterData).GetEPRData(AdmDr,"住院病案摘要.病案首页.一般情况.首页一般情况.病人来源 #TYPE:Simple#TID:66#TVER:0#SCODE:O0074#VTYPE:V") ;区县 取自电子病历组
    ..q:(District'="")&&(District'=TDistrict)&&(TDistrict'="")
    ..;q:TDistrict["外省"
    ..s PapmiDr="" ;$p($g(^PAADM(AdmDr)),"^",1)
    ..s PatName=$p(mCurrRow,"^",27)   ;$p($g(^PAPER(PapmiDr,"ALL")),"^",1)
    ..;!!!!有时候病案首页没有保存,先去地址找区县,再没有就设为无!!!!!!!!!!!!!!!!!!!!!!!!!!
    ..;i TDistrict="" d
    ...;s PaStname=$g(^PAPER(PapmiDr,"PER","ADD",1)) //地址
    ...;q:PaStname=""  s TDistrict=""
    ...;s InsuDistrictStr=$$GetDistrict^DHCINSUFacadeBJ()
    ...;q:InsuDistrictStr=""  s TDistrict=""
    ...;f districtnum=1:1:$l(InsuDistrictStr,"^") d
    ....;s InsuDistrict=$p(InsuDistrictStr,"^",districtnum)
    ....;i PaStname[InsuDistrict  s TDistrict=InsuDistrict
    ....;q:TDistrict'=""
    ..;i TDistrict=""  d
    ...;s ^CacheTemp($j,"NoDistrict")=PatName_"^"_TDistrict_"^"_$zd(intDate,3) //将没有区县的病人保存以便查看
    ...;s TDistrict="无"
    ..;!!!!!!!!!!!end lou 081105
    ..s Name3=$p(mCurrRow,"^",18) ;$p($g(^PAPER(PapmiDr,"ALL")),"^",19)
    ..i PatType'="" d
    ...s AdmReasonDr=$p($g(^PAADM(AdmDr,"1")),"^",7)
    ...s AdmReason=$p(^PAC("ADMREA",AdmReasonDr),"^",2)
    
    ..;lou 注释下面几行 2008-12-23 ,原来作用是如果勾上了金算盘,则去取金算盘的借方,现在如果勾上不会走到此方法
    ..;q:(BackType'="on")&($d(^DHCINPAB("0","DivideDr",INPAYRowid))=0)  ;取金算盘借方
    ..;i BackType="on" d
    ...;s jjzfe=+$p(mCurrRow,"^",34)+$p(mCurrRow,"^",36) ; $p(mCurrRow,"^",19)
    ..;e     d
    ...;s INPABrowid=$o(^DHCINPAB("0","DivideDr",INPAYRowid,""))
    ...;s jjzfe=(+$p($g(^DHCINPAB(INPABrowid)),"^",7))+(+$p($g(^DHCINPAB(INPABrowid)),"^",8)) 
    ..s jjzfe=+$p(mCurrRow,"^",34)+$p(mCurrRow,"^",36)
    
    ..;insu和bestrike都显示正数来累计，strike用负数来累计,bestrike为原来的,strike为新插入一条一样的数据
    ..i $p(mCurrRow,"^",5)="strike" s jjzfe=0-jjzfe
    ..;s CurrentWardDR=$p($g(^PAADM(AdmDr)),"^",70)   ;+ liusf  取科室
    ..s BingQu=""  ; $p(^PAWARD(CurrentWardDR),"^",1) ;pac_ward表
    ..q:(iBingQu'="")&&(BingQu'=iBingQu) ;筛选病区
    ..q:(PatNO'="")&&(Name3'=PatNO) ;筛选医保号
    ..q:(PatType'="")&&(AdmReason'=PatType) ;筛选病人类型
    ..s i=i+1
    ..s ^CacheTemp($j,"InsuDueList",TDistrict,intDate,i)=iDate_"^"_BingQu_"^"_"应收医保欠费"_"^"_PatName_"^"_jjzfe_"^"_""_"^"_""_"^"_""_"^"_TDistrict_"^"_Name3_"^"_INPAYRowid
    ..s ^INSUUpDateFlag("Div",$j,i)=INPAYRowid //add by LOU 2008-12-22用于日结后更新标志
    q $j_"^"_i
}

//下面取金算盘医保回款记录

//w ##class(web.DHCINSUFacadeBJ).GetJSPBackInfo("2008-08-01","2008-11-22","","","","","")

ClassMethod GetJSPBackInfo(BegDate As %String, EndDate As %String, iBingQu As %String, PatNO As %String, PatType As %String, District As %String, RefusePat As %String, BillFlag As %String) As %String
{
	;s i=0   ;+liusf   -lou 2008-12-23
	s ^liusf(1234)="BegDate="_BegDate_"EndDate="_EndDate_"iBingQu="_iBingQu_"PatNO="_PatNO_"PatType="_PatType_"District="_District_"RefusePat="_RefusePat
	s ^liusf(1234,1)=BegDate_","_EndDate_","_iBingQu_","_PatNO_","_PatType_","_District_","_RefusePat
    s BegDate=$zdh(BegDate,3) //lou
	s EndDate=$zdh(EndDate,3)
	s TDistrict="",PatName="",Name3="",Name31=""
    f intDate=BegDate:1:EndDate  d
	.s INDSDRowid=0 
	.;目前以insertdate为回款日期,因为日结的时候只能以导入日期来日结lou 081020
    .f  s INDSDRowid=$o(^DHCINDSD(0,"InsertDate",intDate,INDSDRowid)) q:INDSDRowid=""  d
    ..s mCurrRowDue=$g(^DHCINDSD(INDSDRowid))
    ..s INPAYRowid=$p(mCurrRowDue,"^",8)
    ..s mCurrRow=$g(^DHCINDIVPre(INPAYRowid))  ;+  liusf
    ..s PatName1=$p(mCurrRow,"^",27) ;$p(mCurrRowDue,"^",2)
    ..s BackDate=$zd(intDate,3)
    ..s BackAmount=$p(mCurrRowDue,"^",4)
    ..s District1=$p(mCurrRow,"^",8) ;$p(mCurrRowDue,"^",5)
    ..q:(District'="")&&(District'=District1)
    ..;s AdmDr1=$p(^DHCINDIVPre(INPAYRowid),"^",1)
    ..;s PapmiDr1=$p($g(^PAADM(AdmDr1)),"^",1)
    ..s Name31=$p(mCurrRow,"^",18)  ;$p($g(^PAPER(PapmiDr1,"ALL")),"^",19)   ;手册号
    ..i PatType'="" d
    ...s AdmReasonDr1=$p($g(^PAADM(AdmDr1,"1")),"^",7)
    ...s AdmReason1=$p(^PAC("ADMREA",AdmReasonDr1),"^",2)
    ..;s CurrentWardDR1=$p($g(^PAADM(AdmDr1)),"^",70)
    ..s BingQu1="" ; $p(^PAWARD(CurrentWardDR1),"^",1) ;pac_ward表
    ..s Flag=$p(mCurrRowDue,"^",6) ;回款标志,0为回款 ,1为拒付
    ..q:(BillFlag="B")&&($p(mCurrRowDue,"^",9)'="") ;9字段存做账日期 有值表示已做过日结，此处退出是不再参与日结LOU 2008-12-22
    ..q:(iBingQu'="")&&(BingQu1'=iBingQu) ;筛选病区
    ..q:(PatNO'="")&&(Name31'=PatNO) ;筛选医保号
    ..q:(PatType'="")&&(AdmReason1'=PatType) ;筛选病人类型
    ..q:(RefusePat="on")&&(Flag'="1") //只查询拒付的病人
    ..s i=i+1
    ..i Flag=1 d
    ...s ^CacheTemp($j,"InsuDueList",District1,intDate,i)=BackDate_"^"_BingQu1_"^"_"结转银行拒付"_"^"_PatName1_"^"_""_"^"_BackAmount_"^"_""_"^"_""_"^"_District1_"^"_Name31_"^"_INPAYRowid
    ..i Flag=0  d
    ...s ^CacheTemp($j,"InsuDueList",District1,intDate,i)=BackDate_"^"_BingQu1_"^"_"银行回款"_"^"_PatName1_"^"_""_"^"_BackAmount_"^"_""_"^"_""_"^"_District1_"^"_Name31_"^"_INPAYRowid
    ..s ^INSUUpDateFlag("JSP",$j,i)=INDSDRowid //add by LOU 2008-12-22用于日结后更新标志
    q $j_"^"_i
}

//取首信回款信息

//w ##class(web.DHCINSUFacadeBJ).GetInsuBackInfo("2008-10-01","2008-11-22","","","","","")

ClassMethod GetInsuBackInfo(BegDate As %String, EndDate As %String, iBingQu As %String, PatNO As %String, PatType As %String, District As %String, RefusePat As %String, BillFlag As %String, JSPqfPat As %String, BackType As %String) As %String
{
	s ^liusf(1235)="BegDate="_BegDate_"EndDate="_EndDate_"iBingQu="_iBingQu_"PatNO="_PatNO_"PatType="_PatType_"District="_District_"RefusePat="_RefusePat
	s ^liusf(1235,1)=BegDate_","_EndDate_","_iBingQu_","_PatNO_","_PatType_","_District_","_RefusePat
	s BegDate=$zdh(BegDate,3) //lou
	s EndDate=$zdh(EndDate,3)
    s PayBackInfo="",TDistrict="",BackDate="",BingQu=""
    f intDate=BegDate:1:EndDate  d
	.s CurrentWardDR1="",AdmDr="",DivideDr="",PapmiDr="",Name3="",PatName=""
	.s AdmReasonDr="",AdmReason="",RefuseAmount="",BackAmount="",RefuseDesc=""
    .s INPABrowid=0
    .;目前以insertdate为回款日期,因为日结的时候只能以导入日期来日结lou 081020
    .s DateFlag="IDate"
    .;i BillFlag="B" s DateFlag="IDate"
    .;e  s DateFlag="BackDate"
	.f  s INPABrowid=$o(^DHCINPAB("0",DateFlag,intDate,INPABrowid)) q:INPABrowid=""  d
	..s PayBackInfo=$g(^DHCINPAB(INPABrowid))
	..q:(PayBackInfo="")
	..q:(BillFlag="B")&&(BackType="on")&&($p(PayBackInfo,"^",15)'="") ;15字段有值表示已做过日结，此处退出是不再参与日结LOU 2008-12-22
	..q:(BillFlag="B")&&(BackType'="on")&&($p(PayBackInfo,"^",16)'="") ;金算盘账的时候16字段有值表示做过账了lou 2008-12-27
	..s BackDate=$zd(intDate,3)
	..;s BackDate=$zd($p(PayBackInfo,"^",5),3)
	..s DivideDr=$p(PayBackInfo,"^",1)
	..q:DivideDr=""
	..s mCurrRow=$g(^DHCINDIVPre(DivideDr))  ;+  liusf
	..s TDistrict=$p(mCurrRow,"^",8) ;$p(PayBackInfo,"^",4)
	..q:(JSPqfPat="on")&&($o(^DHCINDSD(0,"DivideDr",DivideDr,0))'="") //2008-12-23 查询已回款但未到账的病人
	..q:(District'="")&&(District'=TDistrict)
	..s PatName=$p(PayBackInfo,"^",2)
	..s BackAmount=(+$p(PayBackInfo,"^",7))+(+$p(PayBackInfo,"^",8)) //统筹加上大额
	..s RefuseAmount=+$p(PayBackInfo,"^",9) //拒付金额
	..q:(RefusePat="on")&&(RefuseAmount=0) //只查询拒付的病人
	..s RefuseDesc=$p(PayBackInfo,"^",10) //拒付原因
	..s Name3=$p(PayBackInfo,"^",3)
	..;s AdmDr=$p(^DHCINDIVPre(DivideDr),"^",1)
	..;s AdmReasonDr=$p($g(^PAADM(AdmDr,"1")),"^",7)
	..;s AdmReason=$p(^PAC("ADMREA",AdmReasonDr),"^",2)
	..;s PapmiDr=$p($g(^PAADM(AdmDr)),"^",1)
	..;s CurrentWardDR1=$p($g(^PAADM(AdmDr)),"^",70)
	..s BingQu="" ;$p(^PAWARD(CurrentWardDR1),"^",1) ;pac_ward表
	..q:(iBingQu'="")&&(BingQu'=iBingQu) ;筛选病区
	..q:(PatNO'="")&&(Name3'=PatNO) ;筛选医保号
	..q:(PatType'="")&&(AdmReason'=PatType) ;筛选病人类型
	
	..;如果是首信回款欠费帐,回款金额为贷方,如果是金算盘欠费帐,回款金额为借方LOU 2008-12-23
	..s JieFang="",DaiFang=""
	..i BackType="on" d
	...s DaiFang=BackAmount
	..i (BackType'="on") d
	...s JieFang=BackAmount
	
	..s i=i+1
	..i BackType="on" s TSummary="医保回款"
	..e  s TSummary="应收医保欠费"
	..s ^CacheTemp($j,"InsuDueList",TDistrict,intDate,i)=BackDate_"^"_BingQu_"^"_TSummary_"^"_PatName_"^"_JieFang_"^"_DaiFang_"^"_""_"^"_""_"^"_TDistrict_"^"_Name3_"^"_DivideDr
	..i (RefuseAmount'=0)&&(RefuseAmount'="") d //有医保拒付发生时
	...s i=i+1
	...i RefuseDesc="" s RefuseDesc="结转医保拒付"
	...e  s RefuseDesc="结转医保拒付("_RefuseDesc_")"
	...s JieFang="",DaiFang=""
	...i BackType="on" d
	....s DaiFang=RefuseAmount
	...i (BackType'="on") d
	....s JieFang=RefuseAmount
	...s ^CacheTemp($j,"InsuDueList",TDistrict,intDate,i)=BackDate_"^"_BingQu_"^"_RefuseDesc_"^"_PatName_"^"_JieFang_"^"_DaiFang_"^"_""_"^"_""_"^"_TDistrict_"^"_Name3_"^"_DivideDr
    
    ..s ^INSUUpDateFlag("INSUBack",$j,i)=INPABrowid //add by LOU 2008-12-22用于日结后更新标志
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
    ..s Demo=$p(mCorr,"^",7)
    ..s JieFang=$p(mCorr,"^",1)
    ..s DaiFang=$p(mCorr,"^",2)
    ..q:(JieFang=0)&&(DaiFang=0)&&(Demo="")
    ..s Balance=$p(mCorr,"^",3)
    ..s DailyFlag=$p(mCorr,"^",5)
    ..i DailyFlag="J"  s DailyFlag="借"
    ..i DailyFlag="D"  s DailyFlag="贷"
    ..i DailyFlag="P"  s DailyFlag="平"
    ..i Demo="" s Demo="日计"
    ..s i=i+1
    ..s ^CacheTemp($j,"InsuDueList",DistrictDaily,intDate,i)=""_"^"_""_"^"_Demo_"^"_""_"^"_JieFang_"^"_DaiFang_"^"_DailyFlag_"^"_Balance_"^"_DistrictDaily
    ..;后台如果存本年累计时也显示一条相同的数据叫本月合计,即最后一天的日计=本月合计=本年累计
    ..;i Demo'="" d  ;本月合计,本年累计
    ...;s i=i+1
    ...;s ^CacheTemp($j,"InsuDueList",DistrictDaily,intDate,i)=""_"^"_""_"^"_"本月合计"_"^"_""_"^"_JieFang_"^"_DaiFang_"^"_DailyFlag_"^"_Balance_"^"_DistrictDaily
    
    .;下面取前一天的余额
    .;s INDUDRowid=0,lastBalance=0,lastDistrict=""
    .;f  s INDUDRowid=$o(^DHCINDUD(0,"Date",(intDate-1),INDUDRowid)) q:INDUDRowid=""  d
    ..;s lastDistrict=$p(^DHCINDUD(INDUDRowid),"^",6)
    ..;s BackTypeDaily=$p(^DHCINDUD(INDUDRowid),"^",8)
    ..;q:(BackType'="")&&(BackType'=BackTypeDaily) ;筛选是首信回款还是金算盘回款日结
    ..;q:(District'="")&&(District'=lastDistrict)
    ..;q:(District'="")&&(District'=DistrictDaily)
    ..;s lastBalance=$p(^DHCINDUD(INDUDRowid),"^",3)
    ..;s lastDate=$zd((intDate-1),3)
    ..;s ^CacheTemp($j,"InsuDueList",lastDistrict,intDate,0)=lastDate_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_lastBalance_"^"_lastDistrict
       
    q $j_"^"_i
}

//计算出拒付的日结数据及余额数据

ClassMethod GetRefuseSumInfo(BegDate As %String, EndDate As %String, District As %String, BackType As %String) As %String
{
	s BegDate=$zdh(BegDate,3) 
	s EndDate=$zdh(EndDate,3)
	s RefuseAmount=0,RefuseAmtSum=0,LastRefuseSum=0,TheRefuseSum=0
	s BackType="on" ;LOU 2008-12-28 查询医保拒付
	f intDate=BegDate:1:EndDate d
	.s INPABRowID=0
	.f  s INPABRowID=$o(^DHCINPAB("0","IDate",intDate,INPABRowID)) q:INPABRowID=""  d
	..s PayBackInfo=$g(^DHCINPAB(INPABRowID))
	..s RefuseAmount=+$p(PayBackInfo,"^",9)
	..s PatName=$p(PayBackInfo,"^",2)
	..s Name3=$p(PayBackInfo,"^",3)
	..s RefuseDesc=""
	..s RefuseDesc=$p(PayBackInfo,"^",10) //拒付原因
	..s RefuseDesc="结转医保拒付("_RefuseDesc_")"
	..s DivideDr=$p(PayBackInfo,"^",1)
	..q:($g(^DHCINDIVPre(DivideDr))="")
	..q:(RefuseAmount=0)
	..s TDistrict=$p(PayBackInfo,"^",4)
	..q:(District'="")&&(District'=TDistrict)
	..s RefuseAmtSum=RefuseAmtSum+RefuseAmount
	..s IDate=$p(PayBackInfo,"^",13)
	..if IDate=BegDate s LastRefuseSum=RefuseAmtSum //此开始日期之前的余额
	..s i=i+1
	..s ^CacheTemp($j,"InsuDueList",TDistrict,intDate,i)=$zd(intDate,3)_"^"_""_"^"_RefuseDesc_"^"_PatName_"^"_RefuseAmount_"^"_""_"^"_""_"^"_""_"^"_TDistrict_"^"_Name3_"^"_DivideDr
    q 0


	/*i BackType="on" d //首信回款
	.s INPABRowID=0
	.f  s INPABRowID=$o(^DHCINPAB(INPABRowID)) q:INPABRowID=""  d
	..s PayBackInfo=$g(^DHCINPAB(INPABRowID))
	..s RefuseAmount=+$p(PayBackInfo,"^",9)
	..s DivideDr=$p(PayBackInfo,"^",1)
	..q:(RefuseAmount=0)
	..s TDistrict=$p(PayBackInfo,"^",4)
	..q:(District'="")&&(District'=TDistrict)
	..s RefuseAmtSum=RefuseAmtSum+RefuseAmount
	..s IDate=$p(PayBackInfo,"^",13)
	..if IDate=BegDate s LastRefuseSum=RefuseAmtSum //此开始日期之前的余额
	..q:IDate=EndDate //查询到此结束日期为止
	e   d
	.s INDSDRowid=0
	.f  s INDSDRowid=$o(^DHCINDSD(INDSDRowid)) q:INDSDRowid=""  d
	..s mCurrRowDue=$g(^DHCINDSD(INDSDRowid))
	..s DivideDr=$p(mCurrRowDue,"^",8)
	..s ChildSub=$p(mCurrRowDue,"^",10)
	..q:ChildSub'="2" ;此字段1表示全部回款2表示有拒付
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
	s i=i+1
	s TheRefuseSum=LastRefuseSum+RefuseAmtSum
    s ^CacheTemp($j,"InsuDueList",TDistrict,intDate,i)=""_"^"_""_"^"_"合计"_"^"_""_"^"_RefuseAmtSum_"^"_""_"^"_"借"_"^"_TheRefuseSum_"^"_TDistrict_"^"_""_"^"_DivideDr	*/
}

ClassMethod GetMonthInfo()
{
	s District="",Date=""
	f  s District=$o(^CacheTemp($j,"InsuDueList",District)) q:District=""  d
	.s intDate=0
	.s JieFang=0,DaiFang=0,DailyFlag="",JieFangSum=0,DaiFangSum=0
	.f  s intDate=$o(^CacheTemp($j,"InsuDueList",District,intDate)) q:intDate=""  d
	..s n=0
	..f  s n=$o(^CacheTemp($j,"InsuDueList",District,intDate,n)) q:n=""  d
	...s mCorr=""
	...s mCorr=$g(^CacheTemp($j,"InsuDueList",District,intDate,n))
	...q:($p(mCorr,"^",3)'="日计")
	...s JieFangSum=JieFangSum+$p(mCorr,"^",5)
	...s DaiFangSum=DaiFangSum+$p(mCorr,"^",6)
	...i (Date'="")&&($p($zd(Date,3),"-",2)'=$p($zd(intDate,3),"-",2)) d ;此判断表示前一条记录为月末
	....w !,JieFangSum_"^"_DaiFangSum
	....s JieFang=JieFangSum-$p(mCorr,"^",5) ;如果上一条是月末,需减去本条的金额
	....s DaiFang=DaiFangSum-$p(mCorr,"^",6)
	....i JieFang>DaiFang s DailyFlag="借"
	....i JieFang=DaiFang s DailyFlag="平"
	....i JieFang<DaiFang s DailyFlag="贷"
	....s m=0
	....f  s m=$o(^CacheTemp($j,"InsuDueList",District,Date,m)) q:m=""  d
	.....s mCorr1=$g(^CacheTemp($j,"InsuDueList",District,Date,m))
	....s Balance=$p(mCorr1,"^",8)
	....s i=i+1
	....s ^CacheTemp($j,"InsuDueList",District,Date,i)=""_"^"_""_"^"_"本月合计"_"^"_""_"^"_JieFang_"^"_DaiFang_"^"_DailyFlag_"^"_Balance_"^"_District
	....s JieFang=0,DaiFang=0,DailyFlag="" 
	....s JieFangSum=$p(mCorr,"^",5),DaiFangSum=$p(mCorr,"^",6)
	...s Date=intDate
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
	;获得此区县的上一次做账的余额 LOU 2008-12-22
	n (District,BackType,Date)
	s INDUDrowid=0,Balance=""
	/*s Date=$zdh(Date,3)-1
	f  s INDUDrowid=$o(^DHCINDUD(0,"Date",Date,INDUDrowid)) q:INDUDrowid=""  d
	.s mCorrRow=$g(^DHCINDUD(INDUDrowid))
	.s DailyDistrict=$p(mCorrRow,"^",6)
	.s BackTypeDaily=$p(mCorrRow,"^",8)
	.q:(BackTypeDaily'=BackType) ;首信还是金算盘
	.q:(DailyDistrict'=District)
	.s Balance=$p(mCorrRow,"^",3)*/
	f  s INDUDrowid=$o(^DHCINDUD(0,"District",District,INDUDrowid)) q:INDUDrowid=""  d
	.s mCorrRow=$g(^DHCINDUD(INDUDrowid))
	.s BackTypeDaily=$p(mCorrRow,"^",8)
	.q:(BackTypeDaily'=BackType) ;首信还是金算盘
	.s Balance=$p(mCorrRow,"^",3)
	.s Demo=$p(mCorrRow,"^",7)
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
	..s Demo=$p(mCorrRow,"^",7)
	..q:Demo'="" ;LOU 2008-12-24退出本月合计的记录
	..s TDistrict=$p(mCorrRow,"^",6)
	..s JieFang=$j($p(mCorrRow,"^",1),3,2)
	..s DaiFang=$j($p(mCorrRow,"^",2),3,2)
	..s Balance=$j($p(mCorrRow,"^",3),3,2)
	..s TBackType=$p(mCorrRow,"^",8)
	..q:(TBackType'=BackType)
	..s TJieFangsum=TJieFangsum+JieFang
	..s TDaiFangsum=TDaiFangsum+DaiFang
	..s TBalancesum=TBalancesum+Balance
	..i TDistrict["无" s TDistrict="空区县"
	..i JieFang'="0.00" d
	...s TSummary="应收"_TDistrict_"医保欠费",TJieFang=JieFang,TDaiFang=""
	...d OutputRow3
	..i DaiFang'="0.00" d
	...s TSummary=TDistrict_"医保回款",TDaiFang=DaiFang,TJieFang=""
	...i BackType="0" s TSummary=TDistrict_"银行回款"
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
	.q:(TJieFang="0.00")&&(TDaiFang="0.00")&&(Demo'="本月合计") ;当天没有发生任何费用时不显示出来
	.i TJieFang>TDaiFang s TFlag="借"
	.i TJieFang=TDaiFang s TFlag="平"
	.i TJieFang<TDaiFang s TFlag="贷"
	.i (TJieFang="0.00")&&(TDaiFang="0.00") d
	.e  d OutputRow3
	
	.;Modify by LOU 2008-12-24 修改取本月合计
	.i Demo="本月合计" d
	..s TSummary="本月合计"
	..s TJieFang=0,TDaiFang=0,TBalance=0
	..s Mon=$p($zd(intDate,3),"-",2)
	..s BegDate1=$p($zd(intDate,3),"-",1)_"-"_Mon_"-01"
	..s BegDate1=$zdh(BegDate1,3)
	..f intDate1=BegDate1:1:intDate d
	...s INDUDRowid=0
	...f  s INDUDRowid=$o(^DHCINDUD(0,"Date",intDate1,INDUDRowid)) q:INDUDRowid=""  d
	....s Corr=$g(^DHCINDUD(INDUDRowid))
	....q:Corr=""
	....s TBackType=$p(Corr,"^",8)
	....q:(TBackType'=BackType)
	....q:($p(Corr,"^",1)=0)&&($p(Corr,"^",2)=0)
	....q:($p(Corr,"^",7)'="本月合计")
	....s TJieFang=$j(TJieFang+$p(Corr,"^",1),3,2)
	....s TDaiFang=$j(TDaiFang+$p(Corr,"^",2),3,2)
	....s TBalance=$j(TBalance+$p(Corr,"^",3),3,2)
	..i TJieFang>TDaiFang s TFlag="借"
	..i TJieFang=TDaiFang s TFlag="平"
	..i TJieFang<TDaiFang s TFlag="贷"
	..q:(TJieFang=0)&&(TDaiFang=0)
	..d OutputRow3

	.;后台如果存本年累计时也显示一条相同的数据叫本月合计,即最后一天的日计=本月合计=本年累计
	.;i Demo'="" d
	..;s TSummary="本月合计"
	..;d OutputRow3
	.;i Demo="本年累计" d
	..;s TSummary="本年累计"
	..;d OutputRow3
	
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

//w ##class(web.DHCINSUFacadeBJ).DailyCountAll()

//日结主程序2008-12-27 LOU 对某段时期内的账进行日结,按两本不同的账来走

ClassMethod DailyCountAll(StDate As %String, EndDate As %String, BackType As %String) As %String
{
	;BackType="1" 首信,"0" 金算盘
	i $e(StDate,3,3)="/" d
	.s StDate=$zdh(StDate,4)
	.s EndDate=$zdh(EndDate,4)
	q:(StDate="")||(EndDate="")
	s Flag=""
    f Date=StDate:1:EndDate d
    .q:Date=""
    .s Flag=##class(web.DHCINSUFacadeBJ).DailyCount($zd(Date,3),BackType)
    q Flag
}

//日结主程序,凌晨两点自动执行,查询前一天的数据

//w ##class(web.DHCINSUFacadeBJ).DailyCount()

//Date => '22/12/2008'

ClassMethod DailyCount(Date As %String, BackType As %String) As %String
{
	;s Date=$p($h,",",1)-1 ;查询昨天的数据
	;s Date=$zd(Date,3)
	;s Date="2008-08-07"
	;BackType="1" 首信,"0" 金算盘
	
	;转换日期格式
	i $e(Date,3,3)="/" d ;Date => '22/12/2008'
	.s Date=$p(Date,"/",3)_"-"_$p(Date,"/",2)_"-"_$p(Date,"/",1) ;=> "2008-12-22"
	
	k ^INSUUpDateFlag
    s num=..GetListInfoForDaily(Date, Date, BackType)
    s InsuDistrictStr=$$GetDistrict^DHCINSUFacadeBJ()
    q:InsuDistrictStr="" ""
    f j=1:1:$l(InsuDistrictStr,"^") d
    .s TDistrict=$p(InsuDistrictStr,"^",j)
    .s TDate="",TBingQu="",TSummary="",TPatName="",TJieFang=0.00,Demo=""
    .s TDaiFang=0.00,TFlag="",TBalance=0.00,JieDaiBalance=0.00,Balance=0.00
    .s intDate=0
    .f  s intDate=$o(^CacheTemp($j,"InsuDueList",TDistrict,intDate)) q:intDate=""  d
	..s i=0
	..f  s i=$o(^CacheTemp($j,"InsuDueList",TDistrict,intDate,i)) q:i=""  d
	...s mCurrRowAll=$g(^CacheTemp($j,"InsuDueList",TDistrict,intDate,i))
	...s TJieFang=$j(TJieFang,3,2)+$j($p(mCurrRowAll,"^",5),3,2)
	...s TDaiFang=$j(TDaiFang,3,2)+$j($p(mCurrRowAll,"^",6),3,2)
	.s TBalance=$j(..GetBalanceByDistrict(TDistrict,BackType,Date),3,2) ;取上一次做账的余额
	.s JieDaiBalance=$j((TJieFang-TDaiFang),3,2) ;借贷差额
	.s Balance=TBalance+JieDaiBalance 
	.if JieDaiBalance>0.00 s TFlag="J" ;借
	.if JieDaiBalance=0.00 s TFlag="P" ;平
	.if JieDaiBalance<0.00 s TFlag="D" ;贷
	
	.s Demo="" ;modify by LOU 2008-12-23 本月合计和本年累计在界面中算出来
	.;s Month=$p(Date,"-",2)
	.;i $p($zd($zdh(Date,3)+1,3),"-",2)'=Month d ;如果明天的月份不等于今天的月份表示今天为月末
	..;s Demo="本月合计"
	..;i Month="12" s Demo="本年累计" ;表示为十二月末
	
	.q:num=0 ;如果没有回款或没有上传发生则不保存 LOU 2008-12-25
	.s strDaily=TJieFang_"^"_TDaiFang_"^"_Balance_"^"_Date_"^"_TFlag_"^"_TDistrict_"^"_Demo_"^"_BackType
	.d ..SaveDaily(strDaily)
	d ..UpDateFlag($j,BackType) ;add by LOU 2008-12-22
	;k ^CacheTemp($j,"InsuDueList")
	q $j
}

ClassMethod QueryIPFootPatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryIPFootPatListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryIPFootPatListExecute(ByRef qHandle As %Binary, Date As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	//i StDate="" Set qHandle=$lb(0,repid,0) 	Quit $$$OK
	s Tnum="",TPatName="",TName3="",TDistrict="",DistrictInfo=""
	s INPAYID=0,i=0,AmountSum=0
	f  s INPAYID=$o(^DHCINDIVPre("0","iDate",Date,INPAYID)) q:INPAYID=""  d
	.s str=""
	.s mCorr=$g(^DHCINDIVPre(INPAYID))
	.s TAmount=$p(mCorr,"^",34)+$p(mCorr,"^",36)
	.s AmountSum=AmountSum+TAmount
	.s TPatName=$p(mCorr,"^",27)
	.s TDistrict=$p(mCorr,"^",8)
	.s DistrictInfo=..GetDistrictInfoByDesc(TDistrict)
	.s TDistrict=$p(DistrictInfo,"^",5)
	.s lsh=$p(mCorr,"^",30)
	.s lsh=$e(lsh,9,19)
	.s TName3=TDistrict_lsh
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

Query QueryIPFootPatList(Date As %String) As %Query(ROWSPEC = "Tnum:%String,TPatName:%String,TName3:%String,TDistrict:%String,TAmount:%String")
{
}

//用于更新日结标志,insudividepre,insudividesubdue,insupayback中更新做账日期字段

//LOU 2008-12-22

ClassMethod UpDateFlag(Jinfo As %String, BackType As %String) As %String
{
	s Date=$zd($p($h,",",1),3)
	s tDate=$p($h,",",1)
	q:(Jinfo="")
	s i=0
    f  s i=$o(^INSUUpDateFlag("Div",Jinfo,i)) q:i=""  d
    .s INPAYRowid=""
    .s INPAYRowid=$g(^INSUUpDateFlag("Div",Jinfo,i))
    .q:INPAYRowid=""
    .s mCorr=""
    .s mCorr=$g(^DHCINDIVPre(INPAYRowid))
    .q:mCorr=""
    .q:($p(mCorr,"^",5)="B")
    .&sql(Update INSU_DividePre set INPAY_Zstr14=:Date where INPAY_Rowid=:INPAYRowid)
    s j=0
    f  s j=$o(^INSUUpDateFlag("JSP",Jinfo,j)) q:j=""  d
    .s INDSDRowid=""
    .s INDSDRowid=$g(^INSUUpDateFlag("JSP",Jinfo,j))
    .q:INDSDRowid=""
    .s mCorr=""
    .s mCorr=$g(^DHCINDSD(INDSDRowid))
    .q:mCorr=""
    .s INPAYRowid=""
    .s INPAYRowid=$p(mCorr,"^",8)
    .&sql(Update INSU_DivideSubDue set INDSD_BillDate=:tDate where INDSD_DivideDr=:INPAYRowid)
    s k=0
    f  s k=$o(^INSUUpDateFlag("INSUBack",Jinfo,k)) q:k=""  d
    .s INPABRowid=""
    .s INPABRowid=$g(^INSUUpDateFlag("INSUBack",Jinfo,k))
    .q:INPABRowid=""
    .s mCorr=""
    .s mCorr=$g(^DHCINPAB(INPABRowid))
    .q:mCorr=""
    .i BackType="1" d
    ..&sql(Update INSU_PayBack set INPAB_BillDate=:tDate where INPAB_RowID=:INPABRowid)
    .i BackType="0" d
    ..&sql(Update INSU_PayBack set INPAB_BillDate1=:tDate where INPAB_RowID=:INPABRowid)
    q 0
}

//做月结用

//;Modify by LOU 2008-12-24 修改取本月合计

ClassMethod MonthCount(BegDate As %String, EndDate As %String, BackType As %String) As %String
{
	n (BegDate,EndDate,BackType)
	s Flag="-1"
	q:($p(BegDate,"/",2)'=$p(EndDate,"/",2)) ;如果开始日期和结束日期的月份不一致则退出
	s Mon=$p(BegDate,"/",2)
	i Mon="12" s Mon="01"
	e  s Mon=Mon+1
	s Year=$p(BegDate,"/",3)
	i $p(BegDate,"/",2)="12" s Year=Year+1 ;如果是12月则年进一
	s NextFirstDay=Year_"-"_Mon_"-"_"01" ;获得下月第一天
	s LastDay=$zdh(NextFirstDay,3)-1 ;下月第一天减一为本月最后一天
	s StDate=Year_"-"_(Mon-1)_"-"_"01"
	s EndDate=LastDay //取得本月最后一天
	s BegDate=$zdh(StDate,3) //取得本月第一天 这样可以保证数据的准确性
	

	i $e(BegDate,3,3)="/" d
	.s BegDate=$zdh(BegDate,4)
	.s EndDate=$zdh(EndDate,4)
	s intDate="",Str=""
	s InsuDistrictStr=$$GetDistrict^DHCINSUFacadeBJ()
    q:InsuDistrictStr=""
    f j=1:1:$l(InsuDistrictStr,"^") d
    .s TDistrict=$p(InsuDistrictStr,"^",j)
    .s DaiFang=0,JieFang=0,Balance=0
	.f intDate=BegDate:1:EndDate d
    ..s INDUDRowid=0,BackT="",District=""
    ..f  s INDUDRowid=$o(^DHCINDUD(0,"Date",intDate,INDUDRowid)) q:INDUDRowid=""  d
    ...s mCorr=$g(^DHCINDUD(INDUDRowid))
    ...q:mCorr=""
    ...s District=$p(mCorr,"^",6)
    ...s BackT=$p(mCorr,"^",8)
    ...q:(BackType'="")&&(BackT'=BackType)
    ...q:(District'=TDistrict)
    ...q:($p(mCorr,"^",1)=0)&&($p(mCorr,"^",2)=0)
    ...s JieFang=JieFang+$p(mCorr,"^",1)
    ...s DaiFang=DaiFang+$p(mCorr,"^",2)
    ...s Balance=$p(mCorr,"^",3)
    ...;i TDistrict["朝阳区" w "2=",JieFang_"^"_DaiFang,!
    .s Demo="本月合计"
	.s JieDaiBalance=JieFang-DaiFang ;借贷差额
	.if JieDaiBalance>0 s TFlag="J" ;借
	.if JieDaiBalance=0 s TFlag="P" ;平
	.if JieDaiBalance<0 s TFlag="D" ;贷
    .s Str=JieFang_"^"_DaiFang_"^"_Balance_"^"_$zd(EndDate,3)_"^"_TFlag_"^"_TDistrict_"^"_Demo_"^"_BackType
    .q:Str=""
    .q:$o(^DHCINDUD(0,"Date",EndDate,-1))=1
    .s Flag= ..SaveDaily(Str)
    q Flag
}

//做账时给出一个默认的做账日期

ClassMethod GetDefaultBillDate(BackType) As %String
{
	n (BackType)
	s INDUDRowid=0,Date=""
    f  s INDUDRowid=$o(^DHCINDUD(INDUDRowid)) q:INDUDRowid=""  d
    .s mCorr=$g(^DHCINDUD(INDUDRowid))
    .s Demo=$p(mCorr,"^",7)
    .q:Demo'=""
    .s Type=$p(mCorr,"^",8)
    .q:Type=""
    .q:(BackType'="")&&(BackType'=Type)
    .i ($p(mCorr,"^",4)>Date) d
    ..s Date=$p(mCorr,"^",4)
    s Date=$zd(Date+1,4) ;=>23/11/2008
    q Date
}

//做账时判断是否已经做过账

ClassMethod CanBillOrNot(BillDate As %String, BackType As %String) As %String
{
	n (BillDate,BackType) ;格式=>23/11/2008
	q:$e(BillDate,3,3)'="/" "F"
	s DefaultDate=..GetDefaultBillDate(BackType)
	q:$e(DefaultDate,3,3)'="/" "F"
	s DefaultDate=$zdh(DefaultDate,4)
	s DefaultDate=DefaultDate-1 //表示已做过账的最后日期
	i $zdh(BillDate,4)>DefaultDate  s Flag="T" //只有当做账日期大于最后已做账日期才可以做账
	e  s Flag="F"
	q Flag
}

//判断是否已经做过月结 

ClassMethod CanMonthBillorNot(StDate As %String, EndDate As %String, BackType As %String) As %String
{
	n (StDate, EndDate,BackType) ;格式=>23/11/2008
	q:($p(StDate,"/",2)'=$p(EndDate,"/",2)) "F" ;如果开始日期和结束日期的月份不一致则退出
	s Mon=$p(StDate,"/",2)
	i Mon="12" s Mon="01"
	e  s Mon=Mon+1
	s Year=$p(StDate,"/",3)
	i $p(StDate,"/",2)="12" s Year=Year+1 ;如果是12月则年进一
	s NextFirstDay=Year_"-"_Mon_"-"_"01" ;获得下月第一天
	s LastDay=$zdh(NextFirstDay,3)-1 ;下月第一天减一为本月最后一天
	s INDUDRowid="",Flag="F"
	q:($o(^DHCINDUD(0,"Date",LastDay,-1))="") "T" ;当本月最后一天在日结表中没有数据则表示可以月结
	f  s INDUDRowid=$o(^DHCINDUD(0,"Date",LastDay,INDUDRowid)) q:INDUDRowid=""  d
	.s Demo=$p($g(^DHCINDUD(INDUDRowid)),"^",7)
	.s Type=$p($g(^DHCINDUD(INDUDRowid)),"^",8)
	.i (Demo="本月合计")&&(Type=BackType) d ;如果此回款类别有本月合计则不能做月结
	..s Flag="F"
	.;当日结表中有本月最后一天的记录,并且不是本月合计则可以做月结
	.;或者当有本月合计的记录,但不是此回款类别的
	.i (Demo'="本月合计")||((Demo="本月合计")&&(Type'=BackType)) d
	..s Flag="T"
	q Flag
}

Query QueryINSUDistrictList() As %Query(ROWSPEC = "TDistrictCode:%String,TDistrictDesc:%String,TDemo1:%String,TRowid:%String")
{
}

ClassMethod QueryINSUDistrictListExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s INDSTRowid=0
	f  s INDSTRowid=$o(^DHCINDST(INDSTRowid)) q:INDSTRowid=""  d
	.s mCorr=$g(^DHCINDST(INDSTRowid))
	.q:mCorr=""
	.s TCode=$p(mCorr,"^",1)
	.s TDesc=$p(mCorr,"^",2)
	.s TDemo=$p(mCorr,"^",5)
	.d OutputDistrictRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputDistrictRow
	set Data=$lb(TCode,TDesc,TDemo,INDSTRowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryINSUDistrictListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryINSUDistrictListExecute ]
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

ClassMethod QueryINSUDistrictListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryINSUDistrictListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

//由区县名称获得代码

ClassMethod GetDistrictInfoByDesc(Desc As %String) As %String
{
	n (Desc)
	s mCorr=""
	s INDSTRowid=0
	f  s INDSTRowid=$o(^DHCINDST("0","DistrictDesc",Desc,INDSTRowid)) q:INDSTRowid=""  d
	.s mCorr=$g(^DHCINDST(INDSTRowid))
	.q:mCorr=""
	q mCorr
}

ClassMethod UpdateDistrict(Code As %String, Desc As %String, Demo As %String, Rowid As %String) As %String
{
	n (Code,Desc,Demo,Rowid)
	s SQLCODE=""
	&sql(update INSU_District set INDST_DistrictCode=:Code,INDST_DistrictDesc=:Desc,INDST_IUser=:Demo where INDST_Rowid=:Rowid)
	q SQLCODE
}

ClassMethod UpdateDate()
{
    //用于调试用LOU 2008-12-27
	s INPABrowid=0
	f  s INPABrowid=$o(^DHCINPAB(INPABrowid)) q:INPABrowid=""  d
	.s PayBackInfo=$g(^DHCINPAB(INPABrowid))
	.q:(INPABrowid<35)||(INPABrowid>42)
	.q:PayBackInfo=""
	.s BackDate=$p(PayBackInfo,"^",11)
	.s BillDate=$p(PayBackInfo,"^",15)
	.q:BillDate'=""
	.&sql(update INSU_PayBack set INPAB_IDate=:BackDate where INPAB_RowID=:INPABrowid)
	q
}

//银行回款时如果是未加流水号的数据,先根据姓名和金额到首信回款表中找到流水号

ClassMethod GetzylshByNameAndAmount(Name As %String, Amount As %String) As %String
{
	n (Name,Amount)
	s INPABRowID=0,zylsh=""
	f  s INPABRowID=$o(^DHCINPAB("0","PatName",Name,INPABRowID)) q:INPABRowID=""  d
	.s Info=""
	.s DivideDr="",TCAmount="",DeAmount="",jjzf=""
	.s Info=$g(^DHCINPAB(INPABRowID))
	.q:Info=""
	.s TCAmount=$p(Info,"^",7)
	.s DeAmount=$p(Info,"^",8)
	.s jjzf=TCAmount+DeAmount
	.q:($j(Amount,3,2)'=$j(jjzf,3,2))
	.;w jjzf_"^"_Amount,!
	.s DivideDr=$p(Info,"^",1)
	.q:($g(^DHCINDIVPre(DivideDr))="")
	.q:zylsh'=""
	.s zylsh=$p($g(^DHCINDIVPre(DivideDr)),"^",30)
	.s zylsh=$e(zylsh,9,19)
	q zylsh
}

//手工输入金算盘回款时根据DIVIDEPreID组织dividesubdue的数据 LOU 2008-12-28

ClassMethod GetPatInfoByDivID(INPAYRowid)
{
	n (INPAYRowid)
	q:(INPAYRowid="") ""
	s mCorr=""
	s mCorr=$g(^DHCINDIVPre(INPAYRowid))
	q:mCorr="" ""
	s District=$p(mCorr,"^",8)
	s TcAmount=$p(mCorr,"^",34)
	s DeAmount=$p(mCorr,"^",36)
	s jjzf=TcAmount+DeAmount
	s lsh0=$p(mCorr,"^",30)
	s PatName=$p(mCorr,"^",27)
	s Info=""
	s Info=INPAYRowid_"^"_lsh0_"^"_PatName_"^"_jjzf
	q Info
}

//往金算盘回款表中手工插入回款数据	lou 2008-12-28

ClassMethod InsertSubDueDaiFang(Str)
{
	;Str=INPAYRowid_"^"_lsh0_"^"_PatName_"^"_jjzf_"^"_DaiFang
	;DivideSubDueInfo=DivideDr^ChildSub^PatInsuNo^PatName^BackDate^BackAmount^District^iAmount^Flag
	n (Str)
	q:Str="" -1
	s DivideSubDueInfo=""
    s today=$zd($p($h,",",1),3)
 	s DivideSubDueInfo=$p(Str,"^",1)_"^"_"1"_"^"_$p(Str,"^",2)_"^"_$p(Str,"^",3)_"^"_""_"^"_$p(Str,"^",5)_"^"_""_"^"_""_"^"_"0"
    s Balance=$p(Str,"^",4)-$p(Str,"^",5) //借方减去贷方
    s Balance=$j(Balance,3,2)
    s Flag="-1"
	s Flag=..InsertDivSubDue(DivideSubDueInfo)
    i Balance>0 d //如果有拒付发生则
	.s DivideSubDueInfo=$p(Str,"^",1)_"^"_"2"_"^"_$p(Str,"^",2)_"^"_$p(Str,"^",3)_"^"_""_"^"_Balance_"^"_""_"^"_""_"^"_"1"
	.s Flag=..InsertDivSubDue(DivideSubDueInfo)
	q Flag
}

//取上期余额

ClassMethod GetlastBalance(BegDate, District, BackType)
{
    ;LOU 2008-12-28修改取上期余额
    i BackType="on" s BackType="1"
    e  s BackType="0"
    s BegDate=$zdh(BegDate,3)
    s Date="",lastBalance=""
    s INDUDRowid=0
    f  s INDUDRowid=$o(^DHCINDUD(INDUDRowid)) q:INDUDRowid=""  d
    .s mCorr=$g(^DHCINDUD(INDUDRowid))
    .s lastDate=$p(mCorr,"^",4)
    .q:(lastDate>BegDate)||(lastDate=BegDate) 
    .s lastDistrict=$p(mCorr,"^",6)
    .q:(District'=lastDistrict)
    .s Type=$p(mCorr,"^",8)
    .q:(BackType'="")&&(BackType'=Type)
    .s Demo=$p(mCorr,"^",7)
    .q:Demo'=""
    .s lastBalance=$p(mCorr,"^",3)
    .s Date=lastDate
    q:lastBalance=""
    s ^CacheTemp($j,"InsuDueList",District,Date,0)=$zd(Date,3)_"^"_""_"^"_"上期余额"_"^"_""_"^"_""_"^"_""_"^"_""_"^"_lastBalance_"^"_District
    q
}

/// ----------------以下为北京门诊实时结算的程序 LOU 2009-02-16----------------
/// 根据INVPRT取处方信息
ClassMethod GetRecipeInfoByInvprtdr(InvprtDr As %String) As %String
{
	//"179131^1^O12103000010^20121030^0000^^^^^传染科门诊^^^2"
	s GetRecipeInfoByInvprtdr=$$GetRecipeInfoByInvprtdr^DHCINSUFacadeBJ(InvprtDr)
	q GetRecipeInfoByInvprtdr
}

}
