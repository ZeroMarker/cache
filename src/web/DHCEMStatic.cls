Class web.DHCEMStatic Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// 获取死亡医嘱id串
/// w ##class(web.DHCEMStatic).GetDeathArcimStr()
ClassMethod GetDeathArcimStr()
{
	q "20221||1^20222||1"
}

/// 根据类型汇总医嘱
/// w ##class(web.DHCEMStatic).PutOrdByType(1)
ClassMethod PutOrdByType(adm As %String, type, pid)
{
	n (adm,type,pid)
	//尸体料理医嘱
	i type="DEATH" d
	.s arcimStr=##class(web.DHCEMStatic).GetDeathArcimStr()
	//心肺复苏医嘱
	i type="CPR" d
	.s arcimStr="14970||1"
	//抢救医嘱
	i (type="STAY_HOURS")||(type="STATUS_Salvage") d
	.s arcimStr="20409||1" //"19914||1^19977||1^19979||1"
	s person=$p(^PAADM(adm),"^",1)
	
	
	//入院日期，时间
	s InDateTime=""
	s inId=##class(web.DHCEMStatic).CheckIn(adm)
	i inId>0 d
	.s InDate=$LG(^Nur.DHCMoudDataD(inId),4)
	.s InTime=$LG(^Nur.DHCMoudDataD(inId),5)
	.s InDateTime=$zd(InDate,3)_" "_$zt(InTime)
	//留观日期
	s stayDateTime=##class(web.DHCEMStatic).ChecStatus(adm,"Stay")
	//离院日期
	s dischargeDateTime=##class(web.DHCEMStatic).ChecStatus(adm,"Discharge")
	//绿色通道日期
	s greenDateTime=##class(web.DHCEMStatic).ChecStatus(adm,"lstd")
	//死亡日期
	s deathDateTime=##class(web.DHCEMStatic).CheckDeath(adm)
	
	//抢救室滞留时间中位数 不计算死亡病人
	q:("STAY_HOURS"=type)&&(deathDateTime'="")
		
	s ord="" f  s ord=$o(^OEORD(0,"Adm",adm,ord)) q:ord=""  d
	.f i=1:1:$l(arcimStr,"^") d
	..s arcim=$p(arcimStr,"^",i)
	..s stt="" f  s stt=$o(^OEORDi(0,"ARCIM",ord,arcim,stt)) q:stt=""  d
	...s itm="" f  s itm=$o(^OEORDi(0,"ARCIM",ord,arcim,stt,itm)) q:itm=""  d
	....s ordDate=$p($g(^OEORD(ord,"I",itm,1)),"^",9)
	....s ordTime=$p($g(^OEORD(ord,"I",itm,1)),"^",10)
	....s ordDateTime=$zd(ordDate,3)_" "_$zt(ordTime)
	....//s lastDate=$o(^TMP("web.DHCEMStatic","Query",pid,type,person,ordDate_" "_ordTime),-1)
	....
	....//CPR 不满24小时的医嘱只算一次
	....i type="CPR" d
	.....s lastDate=ordDate
	.....s lastTime=$o(^TMP("web.DHCEMStatic","Query",pid,type,person,lastDate,""),-1)
	.....s:lastTime="" lastDate=lastDate-1,lastTime=$o(^TMP("web.DHCEMStatic","Query",pid,type,person,lastDate,""),-1)
	.....
	.....i lastTime="" d
	......s ^TMP("web.DHCEMStatic","Query",pid,type,person,ordDate,ordTime)=ord_"||"_itm
	.....e  d
	......s diffHour=$SYSTEM.SQL.DATEDIFF("hour",$zd(lastDate,3)_" "_$zt(lastTime),ordDateTime)
	......s:diffHour>=24 ^TMP("web.DHCEMStatic","Query",pid,type,person,ordDate,ordTime)=ord_"||"_itm
	....//急诊留观患者停留时间
	....e  i type="STAY_HOURS" d
	.....s diffHour=0
	.....//入院小时数
	.....i InDateTime'="" d
	......s diffHour=$SYSTEM.SQL.DATEDIFF("hour",ordDateTime,InDateTime)
	.....//留观小时数
	.....i stayDateTime'="" d
	......s stayHour=$SYSTEM.SQL.DATEDIFF("hour",ordDateTime,stayDateTime)
	......s:(stayHour<diffHour)||(diffHour=0) diffHour=stayHour
	.....//离院小时数
	.....i dischargeDateTime'="" d
	......s dischargeHour=$SYSTEM.SQL.DATEDIFF("hour",ordDateTime,dischargeDateTime)
	......s:(dischargeHour<diffHour)||(diffHour=0) diffHour=dischargeHour
	.....i diffHour<0 d
	......//w InDateTime_"^"_stayDateTime_"^"_dischargeDateTime_"^"_ordDateTime_"^"_adm,!
	.....s ^TMP("web.DHCEMStatic","Query",pid,type,adm)=diffHour_"^"_adm_"^"_ordDateTime_"^"_InDateTime_"^"_stayDateTime_"^"_dischargeDateTime
	....e  d
	.....s ^TMP("web.DHCEMStatic","Query",pid,type,person,ordDate,ordTime)=ord_"||"_itm
}

/// 判断病人是否入院
ClassMethod CheckIn(adm)
{
	n (adm)
	q +$o(^Nur.DHCMoudDataI("EmrCode"," DHCNURZKJJ"," "_adm,""))
}

/// 判断病人死亡
/// w ##class(web.DHCEMStatic).CheckDeath()
ClassMethod CheckDeath(adm)
{
	n (adm)
	s ret=""
	s arcimStr=##class(web.DHCEMStatic).GetDeathArcimStr()
	s ord=$o(^OEORD(0,"Adm",adm,""))
	f i=1:1:$l(arcimStr,"^") d
	.s arcim=$p(arcimStr,"^",i)
	.s stt=+$o(^OEORDi(0,"ARCIM",ord,arcim,""))
	.q:stt=0
	.s itm=$o(^OEORDi(0,"ARCIM",ord,arcim,stt,""))
	.s ordDate=$p($g(^OEORD(ord,"I",itm,1)),"^",9)
	.s ordTime=$p($g(^OEORD(ord,"I",itm,1)),"^",10)
	.s ret=$zd(ordDate,3)_" "_$zt(ordTime)
	q ret
}

/// 急诊高危患者收入院比例
/// w ##class(web.DHCEMStatic).PutHighRiskIn()
ClassMethod PutHighRiskIn(adm As %String, pid)
{
	n (adm,pid)
	//q:##class(web.DHCEMStatic).CheckGreen(adm)=0
	
	s inFlag=##class(web.DHCEMStatic).CheckIn(adm)
	s MRAdmDr=$p(^PAADM(adm),"^",61)
	
	s MRDiaDr="" f  s MRDiaDr=$o(^MR(MRAdmDr,"DIA",MRDiaDr)) q:MRDiaDr=""  d
    .s ICDDR=$p(^MR(MRAdmDr,"DIA",MRDiaDr),"^",1)     //ICDDR
    .q:+ICDDR=0 
    .q:'$d(^MRC("ID",ICDDR))
    .s MedCondCode=$p(^MRC("ID",ICDDR),"^",1)   //疾病编码【ICD-9 Code】///2014-10-17由ICD改为code
	.q:##class(web.DHCEMStatic).CheckHighRiskICD(MedCondCode)=0
	.s ^TMP("web.DHCEMStatic","Query",pid,"Green",adm)=inFlag
}

/// w ##class(web.DHCEMStatic).PutHighRiskStayHour()
ClassMethod PutHighRiskStayHour(adm As %String, pid)
{
	n (adm,pid)
	q:##class(web.DHCEMStatic).ChecStatus(adm,"lstd")=""
	
	//入院日期，时间
	s InDateTime=""
	s inId=##class(web.DHCEMStatic).CheckIn(adm)
	i inId>0 d
	.s InDate=$LG(^Nur.DHCMoudDataD(inId),4)
	.s InTime=$LG(^Nur.DHCMoudDataD(inId),5)
	.s InDateTime=$zd(InDate,3)_" "_$zt(InTime)
	//留观日期
	s stayDateTime=##class(web.DHCEMStatic).ChecStatus(adm,"Stay")
	//离院日期
	s dischargeDateTime=##class(web.DHCEMStatic).ChecStatus(adm,"Discharge")
	//绿色通道日期
	s greenDateTime=##class(web.DHCEMStatic).ChecStatus(adm,"lstd")
	//死亡日期
	s deathDateTime=##class(web.DHCEMStatic).CheckDeath(adm)
	
	s MRAdmDr=$p(^PAADM(adm),"^",61)
	
	s MRDiaDr="" f  s MRDiaDr=$o(^MR(MRAdmDr,"DIA",MRDiaDr)) q:MRDiaDr=""  d
    .s ICDDR=$p(^MR(MRAdmDr,"DIA",MRDiaDr),"^",1)     //ICDDR
    .q:+ICDDR=0 
    .q:'$d(^MRC("ID",ICDDR))
    .s MedCondCode=$p(^MRC("ID",ICDDR),"^",1)   //疾病编码【ICD-9 Code】///2014-10-17由ICD改为code
    .s MedCondDesc=$p(^MRC("ID",ICDDR),"^",2)
	.q:##class(web.DHCEMStatic).CheckHighRiskICD(MedCondCode)=0
	.
	.s key=MedCondCode_"^"_MedCondDesc
	.s tmpStr=$g(^TMP("web.DHCEMStatic","Query",pid,"HighRiskStayHour",key))
	.
	.s diffHour=0     //停留时间
	.s InNum=0    	  //入院人数
	.s StayNum=0  	  //留观人数
	.s DischargeNum=0 //离院人数
	.s DeathNum=0     //死亡人数
	.//入院小时数
	.i InDateTime'="" d
	..s diffHour=$SYSTEM.SQL.DATEDIFF("hour",greenDateTime,InDateTime)
	..s InNum=1
	..//留观小时数
	.i stayDateTime'="" d
	..s stayHour=$SYSTEM.SQL.DATEDIFF("hour",greenDateTime,stayDateTime)
	..s:(stayHour<diffHour)||(diffHour=0) diffHour=stayHour,StayNum=1,InNum=0,DischargeNum=0,DeathNum=0
	.//离院小时数
	.i dischargeDateTime'="" d
	..s dischargeHour=$SYSTEM.SQL.DATEDIFF("hour",greenDateTime,dischargeDateTime)
	..s:(dischargeHour<diffHour)||(diffHour=0) diffHour=dischargeHour,StayNum=0,InNum=0,DischargeNum=1,DeathNum=0
	.//死亡小时数
	.i deathDateTime'="" d
	..s deathHour=$SYSTEM.SQL.DATEDIFF("hour",greenDateTime,deathDateTime)
	..s:(deathHour<diffHour)||(diffHour=0) diffHour=deathHour,StayNum=0,InNum=0,DischargeNum=0,DeathNum=1
	.i diffHour=0 d
	..s diffHour=$SYSTEM.SQL.DATEDIFF("hour",greenDateTime,$zdt($h,3))

	.i diffHour<0 d
	..s person=$p(^PAADM(adm),"^",1)
	..s patName=$p($g(^PAPER(person,"ALL")),"^",1)
	..w patName_":"_greenDateTime_":"_adm,!
	.s $p(tmpStr,"^",1)=1+$p(tmpStr,"^",1)            //急诊绿色通道总人数
	.s $p(tmpStr,"^",2)=InNum+$p(tmpStr,"^",2)        //住院人数    
	.s $p(tmpStr,"^",3)=StayNum+$p(tmpStr,"^",3)      //留观人数
	.s $p(tmpStr,"^",4)=DischargeNum+$p(tmpStr,"^",4) //离院人数
	.s $p(tmpStr,"^",5)=DeathNum+$p(tmpStr,"^",5)     //死亡人数
	.s $p(tmpStr,"^",6)=diffHour+$p(tmpStr,"^",6)     //绿色通道停留平均时间
	.s:InNum=1 $p(tmpStr,"^",7)=diffHour+$p(tmpStr,"^",7)     //住院患者绿色通道平均停留时间
	.s ^TMP("web.DHCEMStatic","Query",pid,"HighRiskStayHour",key)=tmpStr
}

ClassMethod ChecStatus(adm, status)
{
	n (adm,status)
	s ret=""
	s avsId="" f  s avsId=$o(^DHCADMVisitStatus(0,"PAADM",adm,avsId)) q:avsId=""  d
    .s patVisitStat=$p(^DHCPACVisitStatus($p($g(^DHCADMVisitStatus(avsId)),"^",2)),"^",1) //病人状态
    .s statDate=$p(^DHCADMVisitStatus(avsId),"^",5) 	   //变更状态日期
    .s statTime=$p(^DHCADMVisitStatus(avsId),"^",6)      //变更状态时间
    .s:patVisitStat=status ret=$zd(statDate,3)_" "_$zt(statTime)
    
    q ret
}

ClassMethod CheckHighRiskICD(icd)
{
	n (icd)
	//急性创伤
	s ret="S01,S02,S05,S07,S08,S11,S12,S14,S15,S18,S21,S25,S26,S27,S28,S31,S35,S36,S37,S38,S45,S48,S55,S58,S75,S85,T00,T01,T02,T03,T04,T05,T06,T07,T17,T26,T27,T28"
	//急性心肌梗死
	s ret=ret_",I21.0,I21.1,I21.2,I21.3,I21.4,I21.9,I22"
	//急性心力衰竭
	s ret=ret_",I50"
	//急性脑卒中
	s ret=ret_",I60,I61,I62,I63"
	//急性颅脑损伤
	s ret=ret_",S06"
	//急性呼吸衰竭
	s ret=ret_",J96.0"
	//急性消化道出血
	s ret=ret_",K25.0,K25.2,K25.4,K25.6,K26.2,K26.4,K26.6,K27.2,K27.4,K27.6,K28.2,K28.4,K28.6,K29.0,K92.2"
	//主动脉夹层
	s ret=ret_",I71"
	//急性肺栓塞
	s ret=ret_",I26"	
	//急性创伤
	s ret=ret_",S06.5,S06.6,S26,S27.0,S27.2,S36"
	s flag=0
	f i=1:1:$l(ret,",") d
	.s tmpIcd=$p(ret,",",i)
	.s:$f(icd,tmpIcd)>0 flag=1		
	q flag
}

Query HighRiskStayHour(st As %String, ed As %String) As websys.Query(ROWSPEC = "icd:%String,highRiskGreen:%String,In:%String,death:%String,stay:%String,discharge:%String,greenHour:%String,inHour:%String") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCEMStatic","HighRiskStayHour","2018-01-01","2018-03-03")
ClassMethod HighRiskStayHourExecute(ByRef qHandle As %Binary, st As %String = "", ed As %String = "") As %Status
{
	n (qHandle,st,ed)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:st="" $$$OK
	q:ed="" $$$OK
	s pid=$i(^DHCEM("DHCEMStatic"))
	k ^TMP("web.DHCEMStatic","Query",pid)
	s st=$zdh(st,3)
	s ed=$zdh(ed,3)
	f date=st:1:ed d
	.s admTime="" f  s admTime=$o(^PAADMi("TypeDate","E",date,admTime)) q:admTime=""  d
	..s adm="" f  s adm=$o(^PAADMi("TypeDate","E",date,admTime,adm))  q:adm=""  d
	...d ##class(web.DHCEMStatic).PutHighRiskStayHour(adm,pid) 
	
	s icd=""  f  s icd=$o(^TMP("web.DHCEMStatic","Query",pid,"HighRiskStayHour",icd))  q:icd=""  d
	.s str=^TMP("web.DHCEMStatic","Query",pid,"HighRiskStayHour",icd)
	.s highRiskGreen=$p(str,"^",1)
	.s In=$p(str,"^",2)
	.s death=$p(str,"^",3)
	.s stay=$p(str,"^",4)
	.s discharge=$p(str,"^",5)
	.s greenHour=$p(str,"^",6)
	.s inHour=$p(str,"^",7)
	.s greenHourAvg=greenHour/highRiskGreen
	.s inHourAvg=0
	.s:In'=0 inHourAvg=inHour/In
	.s greenHourAvg=$fn(greenHourAvg,"",2)
	.s inHourAvg=$fn(inHourAvg,"",2)
	.s Data=$lb($p(icd,"^",2),highRiskGreen,In,death,stay,discharge,greenHourAvg,inHourAvg)
	.s ^CacheTemp(repid,ind)=Data    
	.s ind=ind+1
	Quit $$$OK
}

/// /急诊高危患者收入院比例
Query HighRiskIn(st As %String, ed As %String) As websys.Query(ROWSPEC = "inNum:%String,highRisk:%String,inRate:%String") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCEMStatic","HighRiskIn","2018-01-01","2018-03-03")
ClassMethod HighRiskInExecute(ByRef qHandle As %Binary, st As %String = "", ed As %String = "") As %Status
{
	n (qHandle,st,ed)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:st="" $$$OK
	q:ed="" $$$OK
	
	s pid=$i(^DHCEM("DHCEMStatic"))
	k ^TMP("web.DHCEMStatic","Query",pid)
	s st=$zdh(st,3)
	s ed=$zdh(ed,3)
	f date=st:1:ed d
	.s admTime="" f  s admTime=$o(^PAADMi("TypeDate","E",date,admTime)) q:admTime=""  d
	..s adm="" f  s adm=$o(^PAADMi("TypeDate","E",date,admTime,adm))  q:adm=""  d
	...d ##class(web.DHCEMStatic).PutHighRiskIn(adm,pid) 
	
	/// 急诊高危患者收入院比例
	s GreenNum=0,GreenInNum=0
	s tmp="" f  s tmp=$o(^TMP("web.DHCEMStatic","Query",pid,"Green",tmp)) q:tmp=""  d
	.s:^TMP("web.DHCEMStatic","Query",pid,"Green",tmp)'="" GreenInNum=GreenInNum+1
	.s GreenNum=GreenNum+1
	b ;err
	s:GreenNum'=0 GreenInRate=100*GreenInNum/GreenNum
	s:GreenNum'=0 GreenInRate=$fn(GreenInRate,"",2)_"%"
	s:GreenNum=0 GreenInRate="0%"
	s Data=$lb(GreenInNum,GreenNum,GreenInRate)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	Quit $$$OK
}

/// /抢救室滞留时间中位数
Query SalvageMed(st As %String, ed As %String) As websys.Query(ROWSPEC = "patNo:%String,patName:%String,num:%String,ordDateTime:%String,InDateTime:%String,stayDateTime:%String,dischargeDateTime:%String") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCEMStatic","SalvageMed","2018-01-01","2018-03-03")
ClassMethod SalvageMedExecute(ByRef qHandle As %Binary, st As %String = "", ed As %String = "") As %Status
{
	n (qHandle,st,ed)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:st="" $$$OK
	q:ed="" $$$OK
	
	s pid=$i(^DHCEM("DHCEMStatic"))
	k ^TMP("web.DHCEMStatic","Query",pid)
	s st=$zdh(st,3)
	s ed=$zdh(ed,3)
	f date=st:1:ed d
	.s admTime="" f  s admTime=$o(^PAADMi("TypeDate","E",date,admTime)) q:admTime=""  d
	..s adm="" f  s adm=$o(^PAADMi("TypeDate","E",date,admTime,adm))  q:adm=""  d
	...d ##class(web.DHCEMStatic).PutOrdByType(adm,"STAY_HOURS",pid) 
	
	
	///抢救室滞留时间中位数统计
	k stayHourList
	
	s tmp="",i=0 f  s tmp=$o(^TMP("web.DHCEMStatic","Query",pid,"STAY_HOURS",tmp)) q:tmp=""  d
	.s str=^TMP("web.DHCEMStatic","Query",pid,"STAY_HOURS",tmp)
	.s num=$p(str,"^",1)
	.q:+num<=0
	.s i=i+1
	.s stayHourList(num,i)=str
	
	s stayHourStr="",sort=0
	s num="" f  s num=$o(stayHourList(num)) q:num=""  d
	.s i="" f  s i=$o(stayHourList(num,i)) q:i=""  d
	..s str=stayHourList(num,i)
	..s adm=$p(str,"^",2)
	..s ordDateTime=$p(str,"^",3)
	..s InDateTime=$p(str,"^",4)
	..s stayDateTime=$p(str,"^",5)
	..s dischargeDateTime=$p(str,"^",6)
	..
	..s person=$p(^PAADM(adm),"^",1)
	..s patName=$p($g(^PAPER(person,"ALL")),"^",1)
	..s patNo=$p(^PAPER(person,"PAT",1),"^",2)
	..s sort=sort+1
	..s $p(stayHourStr,",",sort)=num
	..s ind=ind+1
	..s Data=$lb(patNo,patName,num,ordDateTime,InDateTime,stayDateTime,dischargeDateTime)
	..s ^CacheTemp(repid,ind)=Data 
	k stayHourList
	
	s stayNum=$l(stayHourStr,",")
	s stayModNum=stayNum\2
	s stayDivNum=stayNum/2
	i stayModNum=stayDivNum d
	.//偶数
	.s med1=$p(stayHourStr,",",stayDivNum)
	.s med2=$p(stayHourStr,",",stayDivNum+1)
	.s med=(med1+med2)/2
	e  d
	.//奇数
	.s med=$p(stayHourStr,",",stayDivNum+1)

	s Data=$lb("","中位数",med)
	s ^CacheTemp(repid,1)=Data    
	s ind=ind+1
	Quit $$$OK
}

/// /心脏复苏成功率及患者明细
Query CPR(st As %String, ed As %String) As websys.Query(ROWSPEC = "patNo:%String,patName:%String,Result:%String,CPRDate:%String,DeathDate:%String") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCEMStatic","CPR","2018-01-01","2018-03-03")
ClassMethod CPRExecute(ByRef qHandle As %Binary, st As %String = "", ed As %String = "") As %Status
{
	n (qHandle,st,ed)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:st="" $$$OK
	q:ed="" $$$OK
	
	s pid=$i(^DHCEM("DHCEMStatic"))
	k ^TMP("web.DHCEMStatic","Query",pid)
	s st=$zdh(st,3)
	s ed=$zdh(ed,3)
	f date=st:1:ed d
	.s admTime="" f  s admTime=$o(^PAADMi("TypeDate","E",date,admTime)) q:admTime=""  d
	..s adm="" f  s adm=$o(^PAADMi("TypeDate","E",date,admTime,adm))  q:adm=""  d
	...d ##class(web.DHCEMStatic).PutOrdByType(adm,"DEATH",pid)  			//死亡病人
	...d ##class(web.DHCEMStatic).PutOrdByType(adm,"CPR",pid)    			//心肺复苏医嘱病人
	
	//CPR,心肺复苏死亡率统计
	s CPRNum=0,CPRSuccessNum=0
	s per="" f  s per=$o(^TMP("web.DHCEMStatic","Query",pid,"CPR",per)) q:per=""  d
	.s date="" f  s date=$o(^TMP("web.DHCEMStatic","Query",pid,"CPR",per,date)) q:date=""  d
	..s time="" f  s time=$o(^TMP("web.DHCEMStatic","Query",pid,"CPR",per,date,time)) q:time=""  d
	...
	...s death=0,deathDateTime=""
	...s deathDate="" f  s deathDate=$o(^TMP("web.DHCEMStatic","Query",pid,"DEATH",per,deathDate)) q:deathDate=""  d
	....s deathTime="" f  s deathTime=$o(^TMP("web.DHCEMStatic","Query",pid,"DEATH",per,deathDate,deathTime)) q:deathTime=""  d
	.....s hour=$SYSTEM.SQL.DATEDIFF("hour",$zd(date,3)_" "_$zt(time),$zd(deathDate,3)_" "_$zt(deathTime))
	.....s:hour<24 death=1,deathDateTime=$zd(deathDate,3)_" "_$zt(deathTime)
	...s CPRNum=CPRNum+1
	...s:death=0 CPRSuccessNum=CPRSuccessNum+1
	...s patName=$p($g(^PAPER(per,"ALL")),"^",1)
	...s patNo=$p(^PAPER(per,"PAT",1),"^",2) 
	...s result="成功"
	...s:death=0 result="失败"
	...s ind=ind+1
	...s Data=$lb(patNo,patName,result,$zd(date,3)_" "_$zt(time),deathDateTime)
	..s ^CacheTemp(repid,ind)=Data 
	

	s succcess=100*CPRSuccessNum/CPRNum
	s succcess=$fn(succcess,"",2)
	s Data=$lb("成功率","",succcess_"%")
	s ^CacheTemp(repid,1)=Data    
	s ind=ind+1
	Quit $$$OK
}

/// /非计划重返抢救室率
Query Return(st As %String, ed As %String) As websys.Query(ROWSPEC = "returnNum:%String,stayNum:%String,InNum:%String,dischargeNum:%String,returnRate:%String") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCEMStatic","Return","2018-01-01","2018-03-03")
ClassMethod ReturnExecute(ByRef qHandle As %Binary, st As %String = "", ed As %String = "") As %Status
{
	n (qHandle,st,ed)
	
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	q:st="" $$$OK
	q:ed="" $$$OK
	s pid=$i(^DHCEM("DHCEMStatic"))
	k ^TMP("web.DHCEMStatic","Query",pid)
	
	s st=$zdh(st,3)
	s ed=$zdh(ed,3)
	s statusIdStr="5^6^7"
	

	
	f date=st:1:ed d
	.s admTime="" f  s admTime=$o(^PAADMi("TypeDate","E",date,admTime)) q:admTime=""  d
	..s adm="" f  s adm=$o(^PAADMi("TypeDate","E",date,admTime,adm))  q:adm=""  d
	...d ##class(web.DHCEMStatic).PutOrdByType(adm,"STATUS_Salvage",pid)
	...s inId=##class(web.DHCEMStatic).CheckIn(adm)
	...i inId>0 d
	....s InDate=$LG(^Nur.DHCMoudDataD(inId),4)
	....s InTime=$LG(^Nur.DHCMoudDataD(inId),5)
	....s ^TMP("web.DHCEMStatic","Query",pid,"STATUS_IN",$p(^PAADM(adm),"^",1),InDate,InTime)=adm
	

	//计算72小时前只留观状态病人
	s beforeSt=st-4
	f date=beforeSt:1:ed d
	.
	.f i=1:1:$l(statusIdStr,"^") d
	..s statusId=$p(statusIdStr,"^",i)
	..s avsId="" f  s avsId=$o(^DHCADMVisitStatus(0,"DateStatus",date,statusId,avsId)) q:avsId=""  d
    ...s patVisitStat=$p(^DHCPACVisitStatus(statusId),"^",1) //病人状态
    ...s statDate=$p(^DHCADMVisitStatus(avsId),"^",5) 	   //变更状态日期
    ...s statTime=$p(^DHCADMVisitStatus(avsId),"^",6)      //变更状态时间
    ...s adm=$p(^DHCADMVisitStatus(avsId),"^",1)
    ...s person=$p(^PAADM(adm),"^",1)    
    ...//72小时重返
    ...i patVisitStat="Stay" d
    ....s returnDateTime=""
    ....s returnDate=statDate-1
    ....s returnDate=$o(^TMP("web.DHCEMStatic","Query",pid,"STATUS_Salvage",person,returnDate))
    ....i +returnDate'=0 d
    .....s returnTime=$o(^TMP("web.DHCEMStatic","Query",pid,"STATUS_Salvage",person,returnDate,""))
    .....s diffHour=$SYSTEM.SQL.DATEDIFF("hour",$zd(statDate,3)_" "_$zt(statTime),$zd(returnDate,3)_" "_$zt(returnTime))
    .....i (diffHour>0)&&(diffHour<=72) d
    ......s ^TMP("web.DHCEMStatic","Query",pid,"STATUS_RETURN",person,returnDate,returnTime)=adm
    ...q:statDate<st
    ...//留观
    ...i patVisitStat="Stay" d
    ....s ^TMP("web.DHCEMStatic","Query",pid,"STATUS_STAY",person,statDate,statTime)=adm
    ...//出院
    ...i patVisitStat="Discharge" d
    ....s ^TMP("web.DHCEMStatic","Query",pid,"STATUS_Discharge",person,statDate,statTime)=adm
    
    
    
    

	s ind=1
    s returnNum=0,stayNum=0,dischargeNum=0,inNUm=0
    
    

    
    s statusStr="STATUS_RETURN^STATUS_STAY^STATUS_Discharge^STATUS_IN"
    f i=1:1:$l(statusStr,"^") d
    .s status=$p(statusStr,"^",i)
    .
    .i status="STATUS_RETURN" d
    ..s ind=ind+1
    ..s Data=$lb("72小时重返病人明细")
    ..s ^CacheTemp(repid,ind)=Data
    ..s ind=ind+1
    ..s Data=$lb("登记号","姓名","重返日期")
    ..s ^CacheTemp(repid,ind)=Data
    .
    .i status="STATUS_STAY" d
    ..s ind=ind+1
    ..s Data=$lb("留观病人明细")
    ..s ^CacheTemp(repid,ind)=Data
    ..s ind=ind+1
    ..s Data=$lb("登记号","姓名","留观日期")
    ..s ^CacheTemp(repid,ind)=Data
    .
    .i status="STATUS_Discharge" d
    ..s ind=ind+1
    ..s Data=$lb("离院病人明细")
    ..s ^CacheTemp(repid,ind)=Data
    ..s ind=ind+1
    ..s Data=$lb("登记号","姓名","离院日期")
    ..s ^CacheTemp(repid,ind)=Data
    .
    .i status="STATUS_IN" d
    ..s ind=ind+1
    ..s Data=$lb("入院病人明细")
    ..s ^CacheTemp(repid,ind)=Data
    ..s ind=ind+1
    ..s Data=$lb("登记号","姓名","入院日期")
    ..s ^CacheTemp(repid,ind)=Data
    .s per="" f  s per=$o(^TMP("web.DHCEMStatic","Query",pid,status,per)) q:per=""  d
    ..s date="" f  s date=$o(^TMP("web.DHCEMStatic","Query",pid,status,per,date)) q:date=""  d
    ...s time="" f  s time=$o(^TMP("web.DHCEMStatic","Query",pid,status,per,date,time)) q:time=""  d
    ....
    ....s:status="STATUS_IN" inNUm=inNUm+1
    ....s:status="STATUS_Discharge" dischargeNum=dischargeNum+1
    ....s:status="STATUS_STAY" stayNum=stayNum+1
    ....s:status="STATUS_RETURN" returnNum=returnNum+1
    ....s patName=$p($g(^PAPER(per,"ALL")),"^",1)
	....s patNo=$p(^PAPER(per,"PAT",1),"^",2) 
	....s ind=ind+1
	....
	....s Data=$lb(patNo,patName,$zd(date,3)_" "_$zt(time))
	....s ^CacheTemp(repid,ind)=Data 
	
	s returnRate=0
	i returnNum'=0 d
	.s total=stayNum+dischargeNum+inNUm
	.s returnRate=1000*returnNum/total
	s returnRate=$fn(returnRate,"",2)_"%"
	s Data=$lb("72小时重返人数,"_returnNum,"留观病人数,"_stayNum,"离院病人数,"_dischargeNum,"入院病人数,"_inNUm,"重返率,"_returnRate)
	s ^CacheTemp(repid,1)=Data    
	s ind=ind+1
	Quit $$$OK
}

/// 急诊创伤患者实施“严重程度评估”比率
Query Hurt(st As %String, ed As %String) As websys.Query(ROWSPEC = "returnNum:%String,stayNum:%String,InNum:%String,dischargeNum:%String,returnRate:%String") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCEMStatic","Hurt","2018-01-01","2018-03-03")
ClassMethod HurtExecute(ByRef qHandle As %Binary, st As %String, ed As %String) As %Status
{
	n (qHandle,st,ed)
	
	s pid=$i(^DHCEM("DHCEMStatic"))
	k ^TMP("web.DHCEMStatic","Query",pid)
	s st=$zdh(st,3)
	s ed=$zdh(ed,3)
	
	f date=st:1:ed d
	.
	.s pcl=""  f  s pcl=$o(^DHCEMPCL(0,"PCL_CreateDate",date,pcl)) q:pcl=""  d
	..
	..
	..    

 
    f i=1:1:$l(statusStr,"^") d
    .s status=$p(statusStr,"^",i)
    .
	.s ind=ind+1
	.s Data=$lb(patNo,patName,$zd(date,3)_" "_$zt(time))
	.s ^CacheTemp(repid,ind)=Data 
	

	Quit $$$OK
}

}
