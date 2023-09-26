Import SQLUser

/// 传染病查询统计 DHCMedQuery.EXE
Class web.DHCMedEpidSta Extends (%Library.RegisteredObject, websys.Abstract) [ Inheritance = right ]
{

Parameter BUILD = 17;

ClassMethod QryEpidRepStaClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEpidRepStaExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QryEpidRepStaExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//^DHCMEPD("0","DateLoc",{MEPD_RepDate},{MEPD_Loc_DR},{MEPD_Rowid})
	q:(DateFrom="")||(DateTo="") $$$OK
	s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	s:DateFrom["/" DateFrom=$zdh(DateFrom,4)
	s DateFrom=+DateFrom
	s:DateTo["-" DateTo=$zdh(DateTo,3)
	s:DateTo["/" DateTo=$zdh(DateTo,4)
	s DateTo=+DateTo
	
	k ^CacheTemp("EpidRepSta",$j)
	s RepDate=DateFrom-1
	f  s RepDate=$o(^DHCMEPD("0","DateLoc",RepDate)) q:(RepDate="")||(RepDate>DateTo)  d
	.s RepLoc=""
	.f  s RepLoc=$o(^DHCMEPD("0","DateLoc",RepDate,RepLoc)) q:RepLoc=""  d
	..s RepRowid=0
	..f  s RepRowid=$o(^DHCMEPD("0","DateLoc",RepDate,RepLoc,RepRowid)) q:RepRowid=""  d
	...s tmpRep=$g(^DHCMEPD(+RepRowid))
	...q:tmpRep=""
	...q:($p(tmpRep,"^",15)="00")||($p(tmpRep,"^",15)="10")  //删除和被订状态的报告去掉
	...s RepICD=$p(tmpRep,"^",5)   //传染病诊断Rowid
	...q:RepICD=""
	...s ^CacheTemp("EpidRepSta",$j,RepLoc,RepICD)=(+$g(^CacheTemp("EpidRepSta",$j,RepLoc,RepICD)))+1
	...s ^CacheTemp("EpidRepSta",$j,RepLoc)=(+$g(^CacheTemp("EpidRepSta",$j,RepLoc)))+1
	
	s Loc=""
	f  s Loc=$o(^CacheTemp("EpidRepSta",$j,Loc)) q:Loc=""  d
	.s LocDesc=$p($g(^CTLOC(+Loc)),"^",2)
	.s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	.//1|鼠疫^2|霍乱^3|传染性非典型肺炎^4|艾滋病^5|HIV^6|病毒性甲型肝炎^7|病毒性乙型肝炎^8|病毒性丙型肝炎^9|病毒性戊型肝炎^10|病毒性肝炎未分型^
	.//11|脊髓灰质炎^12|人感染高致病性禽流感^13|麻疹^14|流行性出血热^15|狂犬病^16|流行性乙行脑炎^17|登革热^18|肺炭疽^19|皮肤炭疽^20|炭疽未分型^
	.//21|细菌性痢疾^22|阿米巴性痢疾^23|肺结核涂阳^24|肺结核仅培阳^25|肺结核菌阴^26|肺结核未痰检^27|伤寒^28|副伤寒^29|流行性脑脊髓膜炎^30|百日咳^
	.//31|白喉^32|新生儿破伤风^33|猩红热^34|布鲁氏菌病^35|淋病^36|梅毒Ⅰ期^37|梅毒Ⅱ期^38|梅毒Ⅲ期^39|胎传梅毒^40|隐性梅毒^
	.//41|钩端螺旋体病^42|血吸虫病^43|间日疟^44|恶性疟^45|疟疾未分型^46|流行性感冒^47|流行性腮腺炎^48|流行性和地方性斑疹伤寒^49|风疹^50|急性出血性结膜炎^
	.//51|麻风病^52|黑热病^53|包虫病^54|丝虫病^55|除霍乱、细菌性和阿米巴性痢疾、伤寒和副伤寒以外的感染性腹泻病^56|手足口病^57|非淋菌性尿道(宫颈)炎^58|尖锐湿疣^59|生殖器疱疹^60|生殖道沙眼衣原体感染^
	.//61|水痘^62|恙虫病^63|肝吸虫病^64|森林脑炎^65|结核性胸膜炎^66|人类感染猪链球菌^67|人粒细胞无形体病^68|不明原因肺炎^69|不明原因^70|其他
	.s ICD1=+$g(^CacheTemp("EpidRepSta",$j,Loc,1))
	.s ICD2=+$g(^CacheTemp("EpidRepSta",$j,Loc,2))
	.s ICD3=+$g(^CacheTemp("EpidRepSta",$j,Loc,3))
	.s ICD4=+$g(^CacheTemp("EpidRepSta",$j,Loc,4))
	.s ICD5=+$g(^CacheTemp("EpidRepSta",$j,Loc,5))
	.s ICD6=+$g(^CacheTemp("EpidRepSta",$j,Loc,6))
	.s ICD7=+$g(^CacheTemp("EpidRepSta",$j,Loc,7))
	.s ICD8=+$g(^CacheTemp("EpidRepSta",$j,Loc,8))
	.s ICD9=+$g(^CacheTemp("EpidRepSta",$j,Loc,9))
	.s ICD10=+$g(^CacheTemp("EpidRepSta",$j,Loc,10))
	.s ICD11=+$g(^CacheTemp("EpidRepSta",$j,Loc,11))
	.s ICD12=+$g(^CacheTemp("EpidRepSta",$j,Loc,12))
	.s ICD13=+$g(^CacheTemp("EpidRepSta",$j,Loc,13))
	.s ICD14=+$g(^CacheTemp("EpidRepSta",$j,Loc,14))
	.s ICD15=+$g(^CacheTemp("EpidRepSta",$j,Loc,15))
	.s ICD16=+$g(^CacheTemp("EpidRepSta",$j,Loc,16))
	.s ICD17=+$g(^CacheTemp("EpidRepSta",$j,Loc,17))
	.s ICD18=+$g(^CacheTemp("EpidRepSta",$j,Loc,18))
	.s ICD19=+$g(^CacheTemp("EpidRepSta",$j,Loc,19))
	.s ICD20=+$g(^CacheTemp("EpidRepSta",$j,Loc,20))
	.s ICD21=+$g(^CacheTemp("EpidRepSta",$j,Loc,21))
	.s ICD22=+$g(^CacheTemp("EpidRepSta",$j,Loc,22))
	.s ICD23=+$g(^CacheTemp("EpidRepSta",$j,Loc,23))
	.s ICD24=+$g(^CacheTemp("EpidRepSta",$j,Loc,24))
	.s ICD25=+$g(^CacheTemp("EpidRepSta",$j,Loc,25))
	.s ICD26=+$g(^CacheTemp("EpidRepSta",$j,Loc,26))
	.s ICD27=+$g(^CacheTemp("EpidRepSta",$j,Loc,27))
	.s ICD28=+$g(^CacheTemp("EpidRepSta",$j,Loc,28))
	.s ICD29=+$g(^CacheTemp("EpidRepSta",$j,Loc,29))
	.s ICD30=+$g(^CacheTemp("EpidRepSta",$j,Loc,30))
	.s ICD31=+$g(^CacheTemp("EpidRepSta",$j,Loc,31))
	.s ICD32=+$g(^CacheTemp("EpidRepSta",$j,Loc,32))
	.s ICD33=+$g(^CacheTemp("EpidRepSta",$j,Loc,33))
	.s ICD34=+$g(^CacheTemp("EpidRepSta",$j,Loc,34))
	.s ICD35=+$g(^CacheTemp("EpidRepSta",$j,Loc,35))
	.s ICD36=+$g(^CacheTemp("EpidRepSta",$j,Loc,36))
	.s ICD37=+$g(^CacheTemp("EpidRepSta",$j,Loc,37))
	.s ICD38=+$g(^CacheTemp("EpidRepSta",$j,Loc,38))
	.s ICD39=+$g(^CacheTemp("EpidRepSta",$j,Loc,39))
	.s ICD40=+$g(^CacheTemp("EpidRepSta",$j,Loc,40))
	.s ICD41=+$g(^CacheTemp("EpidRepSta",$j,Loc,41))
	.s ICD42=+$g(^CacheTemp("EpidRepSta",$j,Loc,42))
	.s ICD43=+$g(^CacheTemp("EpidRepSta",$j,Loc,43))
	.s ICD44=+$g(^CacheTemp("EpidRepSta",$j,Loc,44))
	.s ICD45=+$g(^CacheTemp("EpidRepSta",$j,Loc,45))
	.s ICD46=+$g(^CacheTemp("EpidRepSta",$j,Loc,46))
	.s ICD47=+$g(^CacheTemp("EpidRepSta",$j,Loc,47))
	.s ICD48=+$g(^CacheTemp("EpidRepSta",$j,Loc,48))
	.s ICD49=+$g(^CacheTemp("EpidRepSta",$j,Loc,49))
	.s ICD50=+$g(^CacheTemp("EpidRepSta",$j,Loc,50))
	.s ICD51=+$g(^CacheTemp("EpidRepSta",$j,Loc,51))
	.s ICD52=+$g(^CacheTemp("EpidRepSta",$j,Loc,52))
	.s ICD53=+$g(^CacheTemp("EpidRepSta",$j,Loc,53))
	.s ICD54=+$g(^CacheTemp("EpidRepSta",$j,Loc,54))
	.s ICD55=+$g(^CacheTemp("EpidRepSta",$j,Loc,55))
	.s ICD56=+$g(^CacheTemp("EpidRepSta",$j,Loc,56))
	.s ICD57=+$g(^CacheTemp("EpidRepSta",$j,Loc,57))
	.s ICD58=+$g(^CacheTemp("EpidRepSta",$j,Loc,58))
	.s ICD59=+$g(^CacheTemp("EpidRepSta",$j,Loc,59))
	.s ICD60=+$g(^CacheTemp("EpidRepSta",$j,Loc,60))
	.s ICD61=+$g(^CacheTemp("EpidRepSta",$j,Loc,61))
	.s ICD62=+$g(^CacheTemp("EpidRepSta",$j,Loc,62))
	.s ICD63=+$g(^CacheTemp("EpidRepSta",$j,Loc,63))
	.s ICD64=+$g(^CacheTemp("EpidRepSta",$j,Loc,64))
	.s ICD65=+$g(^CacheTemp("EpidRepSta",$j,Loc,65))
	.s ICD66=+$g(^CacheTemp("EpidRepSta",$j,Loc,66))
	.s ICD67=+$g(^CacheTemp("EpidRepSta",$j,Loc,67))
	.s ICD68=+$g(^CacheTemp("EpidRepSta",$j,Loc,68))
	.s ICD69=+$g(^CacheTemp("EpidRepSta",$j,Loc,69))
	.s ICD70=+$g(^CacheTemp("EpidRepSta",$j,Loc,70))
	.s Count=+$g(^CacheTemp("EpidRepSta",$j,Loc))
    .s Data=$lb(LocDesc,ICD1,ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8,ICD9,ICD10,ICD11,ICD12,ICD13,ICD14,ICD15,ICD16,ICD17,ICD18,ICD19,ICD20,ICD21,ICD22,ICD23,ICD24,ICD25,ICD26,ICD27,ICD28,ICD29,ICD30,ICD31,ICD32,ICD33,ICD34,ICD35,ICD36,ICD37,ICD38,ICD39,ICD40,ICD41,ICD42,ICD43,ICD44,ICD45,ICD46,ICD47,ICD48,ICD49,ICD50,ICD51,ICD52,ICD53,ICD54,ICD55,ICD56,ICD57,ICD58,ICD59,ICD60,ICD61,ICD62,ICD63,ICD64,ICD65,ICD66,ICD67,ICD68,ICD69,ICD70,Count)
    .s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	k ^CacheTemp("EpidRepSta",$j)
	
	Quit $$$OK
}

ClassMethod QryEpidRepStaFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEpidRepStaExecute ]
{
	
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

/// ********************************************************
/// 说明       :传染病报告统计
/// 参数       :
/// DateFrom   :开始日期
/// DateTo     :结束日期
/// 调试       :d ##Class(%ResultSet).RunQuery("web.DHCMedEpidSta","QryEpidRepSta",DateFrom,DateTo)
/// ********************************************************
Query QryEpidRepSta(DateFrom As %String, DateTo As %String) As %Query(ROWSPEC = "科室:%String,鼠疫:%String,霍乱:%String,传染性非典型肺炎:%String,艾滋病:%String,HIV:%String,病毒性甲型肝炎:%String,病毒性乙型肝炎:%String,病毒性丙型肝炎:%String,病毒性戊型肝炎:%String,病毒性肝炎未分型:%String,脊髓灰质炎:%String,人感染高致病性禽流感:%String,麻疹:%String,流行性出血热:%String,狂犬病:%String,流行性乙行脑炎:%String,登革热:%String,肺炭疽:%String,皮肤炭疽:%String,炭疽未分型:%String,细菌性痢疾:%String,阿米巴性痢疾:%String,肺结核涂阳:%String,肺结核仅培阳:%String,肺结核菌阴:%String,肺结核未痰检:%String,伤寒:%String,副伤寒:%String,流行性脑脊髓膜炎:%String,百日咳:%String,白喉:%String,新生儿破伤风:%String,猩红热:%String,布鲁氏菌病:%String,淋病:%String,梅毒1期:%String,梅毒2期:%String,梅毒3期:%String,胎传梅毒:%String,隐性梅毒:%String,钩端螺旋体病:%String,血吸虫病:%String,间日疟:%String,恶性疟:%String,疟疾未分型:%String,流行性感冒:%String,流行性腮腺炎:%String,流行性和地方性斑疹伤寒:%String,风疹:%String,急性出血性结膜炎:%String,麻风病:%String,黑热病:%String,包虫病:%String,丝虫病:%String,感染性腹泻病:%String,手足口病:%String,非淋菌性尿道炎:%String,尖锐湿疣:%String,生殖器疱疹:%String,生殖道沙眼衣原体感染:%String,水痘:%String,恙虫病:%String,肝吸虫病:%String,森林脑炎:%String,结核性胸膜炎:%String,人类感染猪链球菌:%String,人粒细胞无形体病:%String,不明原因肺炎:%String,不明原因:%String,其它:%String,合计:%String")
{
}

}
