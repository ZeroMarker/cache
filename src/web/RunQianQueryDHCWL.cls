Import SQLUser

Class web.RunQianQueryDHCWL Extends %RegisteredObject [ Not ProcedureBlock ]
{

// 检查项目月报

// d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL","GetJcXmYb","2012-04-02","2012-04-16","1610,1231,1619")	

ClassMethod GetJcXmYbExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String, recdep As %String) As %Status
{
	;n (SDate,EDate,recdep)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
   
    q:SDate="" $$$OK
 	q:EDate="" $$$OK
   	q:recdep="" $$$OK
  	
    k ^temp($j)
    
	s SDate=$zdh(SDate,3)
	s EDate=$zdh(EDate,3)
	f OrdDate=SDate:1:EDate d
	.s WLRowid=0
	.f  s WLRowid=$o(^DHCWorkLoad(0,"ORDDATE",OrdDate,WLRowid)) q:WLRowid=""  d
	..s RecLoc=$p(^DHCWorkLoad(WLRowid),"^",1)  ;接收科室
	..q:$F(","_recdep_",",","_RecLoc_",")=0  
    ..s Fee=$p(^DHCWorkLoad(WLRowid),"^",16)    ;该医嘱发生的费用
    ..s Counts=$p(^DHCWorkLoad(WLRowid),"^",15)             ;医嘱次数   
    ..s taritemdr=$p(^DHCWorkLoad(WLRowid),"^",22)  ;收费项目
	..s TarCate=$p(^DHCTARI(taritemdr),"^",4)       ;收费子分类
	..s ^temp($j,RecLoc,TarCate,taritemdr,"Fee")=$g(^temp($j,RecLoc,TarCate,taritemdr,"Fee"))+Fee
	..s ^temp($j,RecLoc,TarCate,taritemdr,"Qty")=$g(^temp($j,RecLoc,TarCate,taritemdr,"Qty"))+Counts

	s loc=0 f  s loc=$o(^temp($j,loc)) q:loc=""  d
    .s cat=0 f  s cat=$o(^temp($j,loc,cat)) q:cat=""  d
    ..s itm=0 f  s itm=$o(^temp($j,loc,cat,itm)) q:itm=""  d
    ...s income=$g(^temp($j,loc,cat,itm,"Fee")) 
    ...s qty=$g(^temp($j,loc,cat,itm,"Qty")) 
    ...d OutputRow1
    k ^temp($j)
 	q $$$OK	
OutputRow1
    i $d(^CTLOC(loc)) d
    .s DepName1=$P($G(^CTLOC(loc)),"^",2)  
    .i DepName1 [ "-" s DepName=$p(DepName1,"-",2)
    .e  s DepName=DepName1
    
    i $d(^DHCTarC("SC",cat)) s catDesc=$p(^DHCTarC("SC",cat),"^",2)  
    i $d(^DHCTARI(itm)) s itmdesc=$p(^DHCTARI(itm),"^",2) 
   
    s Data=$lb(loc,DepName,cat,catDesc,itm,itmdesc,$fn(income,"",2),$fn(qty,"",2))
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetJcXmYbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetJcXmYbExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetJcXmYbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetJcXmYbExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetJcXmYb(SDate As %String, EDate As %String, recdep As %String) As %Query(ROWSPEC = "loc:%Integer,DepName:%String,cat:%Integer,catDesc:%String,itm:%Integer,itmdesc:%String,income:%Float,qty:%Float") [ SqlProc ]
{
}

// 手术费用明细

// d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL","GetOpIncomeMx","2012-03-02","2012-03-02","")	

ClassMethod GetOpIncomeMxExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String, Xmmc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
   
    q:SDate="" $$$OK
 	q:EDate="" $$$OK
   
	s SDate=$zdh(SDate,3)
	s EDate=$zdh(EDate,3)
	f OrdDate=SDate:1:EDate d
	.s WLRowid=0
	.f  s WLRowid=$o(^DHCWorkLoad(0,"ORDDATE",OrdDate,WLRowid)) q:WLRowid=""  d
	..s ResLoc=$p(^DHCWorkLoad(WLRowid),"^",23)   ;开单科室
	..s resLocType=$p($g(^CTLOC(+ResLoc)),"^",13)
	..s RecLoc=$p(^DHCWorkLoad(WLRowid),"^",1)  ;接收科室
	..i RecLoc="" s RecLoc=ResLoc
	..;s recLocType=$p($g(^CTLOC(+RecLoc)),"^",13)
	..;q:recLocType'="E"
	..s ResLoc=$p(^DHCWorkLoad(WLRowid),"^",23)   ;开单科室
	..s resLocType=$p($g(^CTLOC(+ResLoc)),"^",13)
	..q:resLocType'="OP"
	..s Ward=$p(^DHCWorkLoad(WLRowid),"^",24) q:Ward=""  ;病人病区
	..s Ordate=$p(^DHCWorkLoad(WLRowid),"^",5)  ;医嘱日期
	..s Ordate=$zd(Ordate,3)
	..s Time=$p(^DHCWorkLoad(WLRowid),"^",6)    ;医嘱时间
	..s Time=$zt(Time,1)
	..s qty=$p(^DHCWorkLoad(WLRowid),"^",15)  q:qty=0 ;收费项目数量 
    ..s income=$p(^DHCWorkLoad(WLRowid),"^",16)    ;该医嘱发生的费用
    ..s resdocdr=$p(^DHCWorkLoad(WLRowid),"^",19)    ;下医嘱医生
    ..s itm=$p(^DHCWorkLoad(WLRowid),"^",22)  ;收费项目
    ..s TarCate=$p(^DHCWorkLoad(WLRowid),"^",41) q:TarCate'="7"   ;核算子分类为手术收入
    ..;s arci=$p(^DHCWorkLoad(WLRowid),"^",2)  ;医嘱项
    ..;s ARCIMRowid=$P(arci,"||",1)
    ..;s ARCIMSub=$P(arci,"||",2)
    ..;s arccode=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",1) 
    ..;s ss=$$IsOperItem^DHCWLQueryWorkLoad(ARCIMRowid)
    ..;q:ss=0
    ..s iPatNo=$p(^DHCWorkLoad(WLRowid),"^",13)  ;PAPMI_RowId
    ..s zyh=$$GetPapmiMedtare^DHCWLCommon(iPatNo) //通过PA_PatMas.PAPMI_RowId得到病人住院号
    ..s name=$$GetPapmiName^DHCWLCommon(iPatNo)  //通过PA_PatMas.PAPMI_RowId得到病人姓名
    ..d OutputRow2
 	q $$$OK	
OutputRow2
    
    i $d(^CTLOC(ResLoc)) d
    .s hos=$P($G(^CTLOC(ResLoc)),"^",22)
    
    i $d(^CTLOC(RecLoc)) d
    .s recdesc1=$P($G(^CTLOC(RecLoc)),"^",2)  
    .i recdesc1 [ "-" s recdesc=$p(recdesc1,"-",2)
    .e  s recdesc=recdesc1
    
    i $d(^CTLOC(Ward)) d
    .s warddesc1=$P($G(^CTLOC(Ward)),"^",2)
    .i warddesc1 [ "-" s warddesc=$p(warddesc1,"-",2)
    .e  s warddesc=warddesc1
    
    i $d(^CTPCP(resdocdr)) s resdoc=$p(^CTPCP(resdocdr,1),"^",2)
    i $d(^DHCTARI(itm)) s itmdesc=$p(^DHCTARI(itm),"^",2) 
    i itmdesc [ " " s itmdesc=$tr(itmdesc," ","")   //把空格去掉
    s itmdesc=$p(^DHCTARI(itm),"^",2)
    i Xmmc="" s itmdesc=$p(^DHCTARI(itm),"^",2)
    e  q:itmdesc'[Xmmc 
       
    s ord=Ordate_" "_Time
    s Data=$lb(ord,Ward,warddesc,zyh,name,itm,itmdesc,$fn(qty,"",2),$fn(income,"",2),RecLoc,recdesc,resdocdr,resdoc,hos)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetOpIncomeMxFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOpIncomeMxExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetOpIncomeMxClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOpIncomeMxExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetOpIncomeMx(SDate As %String, EDate As %String, Xmmc As %String) As %Query(ROWSPEC = "ord:%String,Ward:%Integer,warddesc:%String,zyh:%String,name:%String,itm:%Integer,itmdesc:%String,qty:%Float,income:%Float,RecLoc:%Integer,recdesc:%String,resdocdr:%Integer,resdoc:%String,hos:%Integer") [ SqlProc ]
{
}

// 用户权限报表

// d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL","GetDHCWLUserRpt","3901")	

ClassMethod GetDHCWLUserRptExecute(ByRef qHandle As %Binary, useId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
    q:useId="" $$$OK
    
    s hosRowId=$g(^DHCWLInitStat("Hospital")) 
    s outdata=$$GetReportByCon^DHCWLUSGroup(useId) 
    f num=1:1:outdata-1 d
    .s Rptrowid=$p(mPLIST(num),"^",1)
    .s Rpttype=$p(mPLIST(num),"^",2)
    .s Rptname=$p(mPLIST(num),"^",3)
    .s Rptdesc=$p(mPLIST(num),"^",4)
    .s RptMon=$p(mPLIST(num),"^",5)
    .d OutputRow3   
 	q $$$OK	

OutputRow3

    s outdata=$$ParseCondResRec^DHCWLPeriodParseCondRq(Rptrowid)
    s tjks=$p(outdata,"^",1)
    s AdmType=$p(outdata,"^",2)
    s DateType=$p(outdata,"^",19)
    s RowidXm=$p(outdata,"^",14)
   	
    s Data=$lb(Rptrowid,Rpttype,Rptname,Rptdesc,RptMon,tjks,AdmType,DateType,RowidXm)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetDHCWLUserRptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDHCWLUserRptExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDHCWLUserRptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDHCWLUserRptExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDHCWLUserRpt(useId As %String) As %Query(ROWSPEC = "Rptrowid:%Integer,Rpttype:%String,Rptname:%String,Rptdesc:%String,RptMon:%String,tjks:%String,AdmType:%String,DateType:%String,RowidXm:%String")
{
}

// 固定科室收入调取模式

// d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL","GetDHCWLDeptIncome","2012-06-03","2012-06-03","1")	

ClassMethod GetDHCWLDeptIncomeExecute(ByRef qHandle As %Binary, sday As %String, eday As %String, RptID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
   
    q:sday="" $$$OK
 	q:eday="" $$$OK
  	q:RptID="" $$$OK
  	
  	k ^temp($j)
   	
  	d GetData^DHCWLPeriodReportCreate(RptID,"",sday,eday,.mPLIST,.PLIST)
    s len=$l(PLIST(0),"^")
    s num=0
    f  s num=$o(PLIST(num)) q:num=""  d
    .s loc=$p(PLIST(num),"^",1)
    .q:loc="合计"
    .f i=2:1:len d
    ..s type=$p(PLIST(0),"^",i)
    ..s fee=$p(PLIST(num),"^",i)
    ..d OutputRow13
    
    k ^temp($j)
 	q $$$OK	
OutputRow13
    
    s Data=$lb(type,loc,fee)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetDHCWLDeptIncomeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDHCWLDeptIncomeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDHCWLDeptIncomeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDHCWLDeptIncomeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDHCWLDeptIncome(sday As %String, eday As %String, RptID As %String) As %Query(ROWSPEC = "tpye:%String,loc:%String,fee:%String") [ SqlProc ]
{
}

// 34手术费月报/35非麻醉科费用月报/36手术室开药品统计/37非药品收入

// 四表通用此Query,字段名称代表含义不一。warddesc对于(36手术室开药品统计/37非药品收入)指项目。

// d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL","GetOpIncomeMonth","2012-04-10","2012-04-12","35")	

ClassMethod GetOpIncomeMonthExecute(ByRef qHandle As %Binary, sday As %String, eday As %String, RptID As %String, Xmmc As %Text) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
   
    q:sday="" $$$OK
 	q:eday="" $$$OK
  	q:RptID="" $$$OK
  	
  	k ^temp($j)
  	
    s para=$p($$ParseCondWorkLoadQuery^DHCWLPeriodParseCond(RptID),"%%")
    s outdata=$$WorkLoadQuery^DHCWLQueryWorkLoad(para,$p($$ParseCondWorkLoadQuery^DHCWLPeriodParseCond(RptID),"%%",2),$p($$ParseCondWorkLoadQuery^DHCWLPeriodParseCond(RptID),"%%",3))
    /*
    //11手术费月报 DHC-APP>zw ^yx(2) 提取条件
    i RptID="11" s para="ORDDATE$SelectPara!"_sday_"#"_eday_"!IsPatDepOper.IsPatDepOper#OP!IsRecDepOper.IsRecDepOper#E!IsOPOrdItem.IsOPOrdItem#1$ColPara!Null#Null#Null$RowPara!RecDep#Dep#ALL!PatWard#Dep#ALL!TarItemNew#TarItemNew#ALL$StatPara!14#总费用!52#医嘱条数"
	//24非麻醉科费用月报
	i RptID="24" s para="ORDDATE$SelectPara!"_sday_"#"_eday_"!IsPatDepOper.IsPatDepOper#OP!IsRecDepOper.IsRecDepOper#E!IsOPOrdItem.IsOPOrdItem#0$ColPara!Null#Null#Null$RowPara!RecDep#Dep#ALL!PatWard#Dep#ALL!OrdItem#OrdItem#ALL$StatPara!14#总费用!52#医嘱条数"
	s outdata=$$WorkLoadQuery^DHCWLQueryWorkLoad(para,"","","")
    */
    f num=2:1:outdata d
    .s recdesc=$p(mPLIST(num),"^",2)
    .s warddesc=$p(mPLIST(num),"^",3)
    .s itmdesc=$p(mPLIST(num),"^",4)
    .s kdks=$p(mPLIST(num),"^",5)
    .s income=$p(mPLIST(num),"^",6)
    .s yzts=$p(mPLIST(num),"^",7)
    .s ^temp($j,recdesc,warddesc,itmdesc,kdks,"Fee")=$g(^temp($j,recdesc,warddesc,itmdesc,kdks,"Fee"))+income
	.s ^temp($j,recdesc,warddesc,itmdesc,kdks,"Qty")=$g(^temp($j,recdesc,warddesc,itmdesc,kdks,"Qty"))+yzts

	s rec=0 f  s rec=$o(^temp($j,rec)) q:rec=""  d
    .s war=0 f  s war=$o(^temp($j,rec,war)) q:war=""  d
    ..s itm=0 f  s itm=$o(^temp($j,rec,war,itm)) q:itm=""  d
    ...s res=0 f  s res=$o(^temp($j,rec,war,itm,res)) q:res=""  d
    ....s income=$g(^temp($j,rec,war,itm,res,"Fee")) 
    ....s yzts=$g(^temp($j,rec,war,itm,res,"Qty")) 
    ....d OutputRow4
    k ^temp($j)
    
 	q $$$OK	
OutputRow4
    s loc=0  f  s loc=$o(^CTLOC(loc))  q:loc=""  d
    .s recdesc1=$P($G(^CTLOC(loc)),"^",2) 
    .s recdesc=$p(recdesc1,"-",2) 
    .i ((RptID'="34") && (RptID'="35"))  q:recdesc'=res  s dep=res
    .e  q:recdesc'=rec  s dep=rec   
    .s hos=$P($G(^CTLOC(loc)),"^",22)
    i itm [ " " s itm=$tr(itm," ","")   //把空格去掉
    i Xmmc="" s itm=itm
    e  q:itm'[Xmmc 
       
    s Data=$lb(dep,war,itm,$fn(yzts,"",2),$fn(income,"",2),hos)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetOpIncomeMonthFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOpIncomeMonthExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetOpIncomeMonthClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOpIncomeMonthExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetOpIncomeMonth(sday As %String, eday As %String, RptID As %String, Xmmc As %Text) As %Query(ROWSPEC = "rec:%String,war:%String,itm:%String,yzts:%Float,income:%Float,hos:%Integer") [ SqlProc ]
{
}

// 手术例数数据明细

// d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL","GetOpLsMx","2012-06-01","2012-06-30")	

ClassMethod GetOpLsMxExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
   
    q:SDate="" $$$OK
 	q:EDate="" $$$OK
  	
    
	s SDate=$zdh(SDate,3)
	s EDate=$zdh(EDate,3)
	f OrdDate=SDate:1:EDate d
	.s WLRowid=0
	.f  s WLRowid=$o(^DHCWLAnaesthesia(0,"STATDATE",OrdDate,WLRowid)) q:WLRowid=""  d
    ..s iPatNo=$p(^DHCWLAnaesthesia(WLRowid),"^",2)  ;PAPMI_RowId
    ..s zyh=$$GetPapmiMedtare^DHCWLCommon(iPatNo) //通过PA_PatMas.PAPMI_RowId得到病人住院号
    ..s name=$$GetPapmiName^DHCWLCommon(iPatNo)  //通过PA_PatMas.PAPMI_RowId得到病人姓名
    ..s adm=$p(^DHCWLAnaesthesia(WLRowid),"^",1)  ;PAPMI_RowId
    ..s inNums=$p($g(^PAADM(adm)),"^",29)   //住院次数
    ..s date=$p(^DHCWLAnaesthesia(WLRowid),"^",10)  ;麻醉日期
    ..s time=$p(^DHCWLAnaesthesia(WLRowid),"^",11)  ;麻醉时间
    ..s date=$zd(date,3)
	..s time=$zt(time,1)
	..s rq=date_" "_time
	..s opid=$p(^DHCWLAnaesthesia(WLRowid),"^",42)  ;手术名称ID
	..i $d(^ORC("OPER",opid)) s opcode=$p(^ORC("OPER",opid),"^",1),opna=$p(^ORC("OPER",opid),"^",2)
    ..q:$E(opcode,1,1)'="O" 
    ..s arcim=""
    ..s opcode=$$ALPHAUP^SSUTIL4(opcode)
    ..f  s arcim=$O(^ARCIM(0,"Code",opcode,arcim))  q:arcim=""  d
    ...s statParaValue=arcim_"||"_1
    ...s rValue=##class(web.UDHCJFPRICE).GetOrderPrice("","",statParaValue,+$h,"","","","")
    ...s price=$p(rValue,"^",1)  //医嘱单价
    ..s income=$p(^DHCWLAnaesthesia(WLRowid),"^",33)  ;手术金额
    ..s ssqty=$p(^DHCWLAnaesthesia(WLRowid),"^",32)  ;手术例数
	..s patward=$p(^DHCWLAnaesthesia(WLRowid),"^",6) ;病人所在病区
    ..i $d(^PAWARD(patward)) d
    ...s wardcode=$p(^PAWARD(patward),"^",1) ;病人所在病区code
    ...s wdepgrploc=$p(^PAWARD(patward),"^",5)
    ...s wdepgrpid=$p(^CTLOC(wdepgrploc),"^",19)
    ...s wgrpcode=$p(^RBC("DEP",wdepgrpid),"^",1),wgrpdesc=$p(^RBC("DEP",wdepgrpid),"^",2) 
    ..s sdocdep=$p(^DHCWLAnaesthesia(WLRowid),"^",51) ;q:sdocdep'="43"  ;手术医生所在科室
    ..s sdocdepcode="",sdocdepdesc=""
    ..i $d(^CTLOC(sdocdep)) d 
    ...s sdocdepcode=$p(^CTLOC(sdocdep),"^",1) ;手术医生所在科室code
    ...s sdocdepdesc1=$p(^CTLOC(sdocdep),"^",2) ;手术医生所在科室desc 
	...i sdocdepdesc1 [ "-" s sdocdepdesc=$p(sdocdepdesc1,"-",2)
     
    ..s recloc=$p(^DHCWLAnaesthesia(WLRowid),"^",63)   ;接收科室
    ..s hos=$P($G(^CTLOC(recloc)),"^",22)
    ..;s patloc=$p(^DHCWLAnaesthesia(WLRowid),"^",5)  q:patloc="" ;病人科室
    ..;s sdocdepcode="",sdocdepdesc=""
    ..;i $d(^CTLOC(patloc)) d 
    ...;s patcode=$p(^CTLOC(patloc),"^",1) ;病人科室code
    ...;s patdesc=$p(^CTLOC(patloc),"^",2) ;病人科室desc
    ..s opdoc=$p(^DHCWLAnaesthesia(WLRowid),"^",50)  ;手术医生
    ..s sdoccode="",sdocname=""
    ..i $d(^CTPCP(opdoc)) d 
    ...s sdoccode=$p(^CTPCP(opdoc,1),"^",1) ;手术医生工号
    ...s sdocname=$p(^CTPCP(opdoc,1),"^",2) ;手术医生名称
    ..d OutputRow5
 	q $$$OK	
OutputRow5
    
    s Data=$lb(zyh,name,inNums,rq,opid,opcode,opna,price,$fn(income,"",2),wgrpcode,wardcode,sdocdepcode,sdocdepdesc,ssqty,sdoccode,sdocname,hos)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetOpLsMxFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOpLsMxExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetOpLsMxClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOpLsMxExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetOpLsMx(SDate As %String, EDate As %String) As %Query(ROWSPEC = "zyh:%String,name:%String,inNums:%String,rq:%String,opid:%String,opcode:%String,opna:%String,price:%Float,income:%Float,wgrpcode:%String,wardcode:%String,sdocdepcode:%String,sdocdepdesc:%String,ssqty:%Float,sdoccode:%String,sdocname:%String,hos:%Integer") [ SqlProc ]
{
}

// 手术例数报表、非手术例数报表

// d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL","GetOpLsRp","2012-06-01","2012-06-30","O")	

ClassMethod GetOpLsRpExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String, type As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
   
    q:SDate="" $$$OK
 	q:EDate="" $$$OK
    q:type="" $$$OK
    
    k ^temp($j)
	s SDate=$zdh(SDate,3)
	s EDate=$zdh(EDate,3)
	f OrdDate=SDate:1:EDate d
	.s WLRowid=0
	.f  s WLRowid=$o(^DHCWLAnaesthesia(0,"STATDATE",OrdDate,WLRowid)) q:WLRowid=""  d
    ..s opid=$p(^DHCWLAnaesthesia(WLRowid),"^",42)  ;手术名称ID
	..i $d(^ORC("OPER",opid)) s opcode=$p(^ORC("OPER",opid),"^",1) 
	..i type="O" q:$E(opcode,1,1)'="O"  
    ..i type'="O" q:$E(opcode,1,1)="O" 
    ..s ssqty=$p(^DHCWLAnaesthesia(WLRowid),"^",32)  ;手术例数
  	..s patward=$p(^DHCWLAnaesthesia(WLRowid),"^",6) ;病人所在病区
    ..;s patloc=$p(^DHCWLAnaesthesia(WLRowid),"^",5)  q:patloc="" ;病人科室
    ..s patloc=$p(^DHCWLAnaesthesia(WLRowid),"^",51)  q:patloc="" ;申请科室 2012-05-02 
    ..s recloc=$p(^DHCWLAnaesthesia(WLRowid),"^",63)   ;接收科室
    ..s hos=$P($G(^CTLOC(recloc)),"^",22)
    ..s ^temp($j,patloc,patward,opid,hos)=$g(^temp($j,patloc,patward,opid,hos))+ssqty
    
    s pat=0 f  s pat=$o(^temp($j,pat)) q:pat=""  d
    .s war=0 f  s war=$o(^temp($j,pat,war)) q:war=""  d
    ..s opi=0 f  s opi=$o(^temp($j,pat,war,opi)) q:opi=""  d
    ...s hos=0 f  s hos=$o(^temp($j,pat,war,opi,hos)) q:hos=""  d
    ....s qty=$g(^temp($j,pat,war,opi,hos)) 
    ....d OutputRow6
    k ^temp($j)
 	q $$$OK	
OutputRow6
     
    i $d(^CTLOC(pat)) d
    .s patdesc1=$p(^CTLOC(pat),"^",2) ;病人科室desc
    .i patdesc1 [ "-" s patdesc=$p(patdesc1,"-",2)
    .e  s patdesc=patdesc1
        
    i $d(^PAWARD(war)) d
    .s wardesc1=$p(^PAWARD(war),"^",2) ;病人所在病区desc
    .i wardesc1 [ "-" s wardesc=$p(wardesc1,"-",2)
    .e  s wardesc=wardesc1

    i $d(^ORC("OPER",opi)) s opna=$p(^ORC("OPER",opi),"^",2)
    s Data=$lb(pat,patdesc,war,wardesc,opi,opna,$fn(qty,"",2),hos)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetOpLsRpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOpLsRpExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetOpLsRpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOpLsRpExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetOpLsRp(SDate As %String, EDate As %String, type As %String) As %Query(ROWSPEC = "pat:%Integer,patdesc:%String,war:%Integer,wardesc:%String,opi:%String,opna:%String,qty:%Float,hos:%Integer") [ SqlProc ]
{
}

// 手术急诊报表

// d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL","GetOpJzRp","2012-03-01","2012-03-05")	

ClassMethod GetOpJzRpExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
   
    q:SDate="" $$$OK
 	q:EDate="" $$$OK
    
    k ^temp($j)
	s SDate=$zdh(SDate,3)
	s EDate=$zdh(EDate,3)
	f OrdDate=SDate:1:EDate d
	.s WLRowid=0
	.f  s WLRowid=$o(^DHCWLAnaesthesia(0,"STATDATE",OrdDate,WLRowid)) q:WLRowid=""  d
	..s iPatNo=$p(^DHCWLAnaesthesia(WLRowid),"^",2)  ;PAPMI_RowId
    ..s OPType=$p(^DHCWLAnaesthesia(WLRowid),"^",65) q:OPType'=1 ;0普通1急诊2超时
    ..s ssqty=$p(^DHCWLAnaesthesia(WLRowid),"^",32)  ;手术例数
	..s patward=$p(^DHCWLAnaesthesia(WLRowid),"^",6) ;病人所在病区
    ..;s patloc=$p(^DHCWLAnaesthesia(WLRowid),"^",5)  q:patloc="" ;病人科室
    ..s patloc=$p(^DHCWLAnaesthesia(WLRowid),"^",51)  q:patloc="" ;申请科室 2012-05-02 
    ..s recloc=$p(^DHCWLAnaesthesia(WLRowid),"^",63)   ;接收科室
    ..s hos=$P($G(^CTLOC(recloc)),"^",22)
    ..s ^temp($j,patloc,patward,iPatNo,hos)=$g(^temp($j,patloc,patward,iPatNo,hos))+ssqty  
    
    s pat=0 f  s pat=$o(^temp($j,pat)) q:pat=""  d
    .s war=0 f  s war=$o(^temp($j,pat,war)) q:war=""  d
    ..s reg=0 f  s reg=$o(^temp($j,pat,war,reg)) q:reg=""  d
    ...s hos=0 f  s hos=$o(^temp($j,pat,war,reg,hos)) q:hos=""  d
    ....s qty=$g(^temp($j,pat,war,reg,hos)) 
    ....d OutputRow7
   
    k ^temp($j)
 	q $$$OK	
OutputRow7
     
    i $d(^CTLOC(pat)) d
    .s patdesc1=$p(^CTLOC(pat),"^",2) ;病人科室desc
    .i patdesc1 [ "-" s patdesc=$p(patdesc1,"-",2)
    .e  s patdesc=patdesc1
        
    i $d(^PAWARD(war)) d
    .s wardesc1=$p(^PAWARD(war),"^",2) ;病人所在病区desc
    .i wardesc1 [ "-" s wardesc=$p(wardesc1,"-",2)
    .e  s wardesc=wardesc1
    
    s zyh=$$GetPapmiMedtare^DHCWLCommon(reg) //通过PA_PatMas.PAPMI_RowId得到病人住院号
    s name=$$GetPapmiName^DHCWLCommon(reg)  //通过PA_PatMas.PAPMI_RowId得到病人姓名
       
    s Data=$lb(pat,patdesc,war,wardesc,zyh,name,$fn(qty,"",2),hos)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetOpJzRpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOpJzRpExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetOpJzRpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOpJzRpExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetOpJzRp(SDate As %String, EDate As %String) As %Query(ROWSPEC = "pat:%Integer,patdesc:%String,war:%Integer,wardesc:%String,zyh:%String,name:%String,qty:%Float,hos:%Integer") [ SqlProc ]
{
}

// 手术超时报表

// d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL","GetOpCsRp","2012-03-01","2012-03-05")	

ClassMethod GetOpCsRpExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
   
    q:SDate="" $$$OK
 	q:EDate="" $$$OK
    
    k ^temp($j)
	s SDate=$zdh(SDate,3)
	s EDate=$zdh(EDate,3)
	s cat="17,7,76"  //麻醉费、手术费、术后镇痛
	f OrdDate=SDate:1:EDate d
	.s WLRowid=0
	.f  s WLRowid=$o(^DHCWLAnaesthesia(0,"STATDATE",OrdDate,WLRowid)) q:WLRowid=""  d
	..s iPatNo=$p(^DHCWLAnaesthesia(WLRowid),"^",2)  ;PAPMI_RowId
    ..s OPType=$p(^DHCWLAnaesthesia(WLRowid),"^",65) q:OPType'=2 ;0普通1急诊2超时
    ..s ssqty=$p(^DHCWLAnaesthesia(WLRowid),"^",32)  ;手术例数
	..s patward=$p(^DHCWLAnaesthesia(WLRowid),"^",6) ;病人所在病区
    ..;s patloc=$p(^DHCWLAnaesthesia(WLRowid),"^",5)  q:patloc="" ;病人科室
    ..s patloc=$p(^DHCWLAnaesthesia(WLRowid),"^",51)  q:patloc="" ;申请科室 2012-05-02 
    ..s recloc=$p(^DHCWLAnaesthesia(WLRowid),"^",63)   ;接收科室
    ..s hos=$P($G(^CTLOC(recloc)),"^",22)
    ..;手术费、麻醉费、术后镇痛
    ..s arraId=$p(^DHCWLAnaesthesia(WLRowid),"^",66) ;手术排班
	..s anaestdr=$p(^DHCANOPArrange(arraId),"^",2)  ;麻醉记录
	..s ord=0
	..f  s ord=$o(^OEORDi(0,"Ana",anaestdr,ord)) q:ord=""  d 
	...s ordSub=0
	...f  s ordSub=$o(^OEORDi(0,"Ana",anaestdr,ord,ordSub)) q:ordSub=""  d
	....s oeori=ord_"||"_ordSub
	....s wlId=0
	....f  s wlId=$o(^DHCWorkLoad(0,"OEORI",oeori,wlId)) q:wlId=""  d
	.....s Fee=$p(^DHCWorkLoad(wlId),"^",16)    ;该医嘱发生的费用
    .....s TarCate=$p(^DHCWorkLoad(wlId),"^",41)  ;核算子分类
    .....q:$F(","_cat_",",","_TarCate_",")=0  
    .....s ^temp($j,patloc,patward,iPatNo,TarCate,hos)=$g(^temp($j,patloc,patward,iPatNo,TarCate,hos))+Fee
    ..s ^temp($j,patloc,patward,iPatNo,"SSLS",hos)=$g(^temp($j,patloc,patward,iPatNo,"SSLS",hos))+ssqty  
    
    s pat=0 f  s pat=$o(^temp($j,pat)) q:pat=""  d
    .s war=0 f  s war=$o(^temp($j,pat,war)) q:war=""  d
    ..s reg=0 f  s reg=$o(^temp($j,pat,war,reg)) q:reg=""  d
    ...s type=0 f  s type=$o(^temp($j,pat,war,reg,type)) q:type=""  d
    ....s hos=0 f  s hos=$o(^temp($j,pat,war,reg,type,hos)) q:hos=""  d
    .....s outdata=$g(^temp($j,pat,war,reg,type,hos)) 
    .....d OutputRow8
    
    k ^temp($j)
 	q $$$OK	
OutputRow8
     
    i $d(^CTLOC(pat)) d
    .s patdesc1=$p(^CTLOC(pat),"^",2) ;病人科室desc
    .i patdesc1 [ "-" s patdesc=$p(patdesc1,"-",2)
    .e  s patdesc=patdesc1
        
    i $d(^PAWARD(war)) d
    .s wardesc1=$p(^PAWARD(war),"^",2) ;病人所在病区desc
    .i wardesc1 [ "-" s wardesc=$p(wardesc1,"-",2)
    .e  s wardesc=wardesc1
    
    s zyh=$$GetPapmiMedtare^DHCWLCommon(reg) //通过PA_PatMas.PAPMI_RowId得到病人住院号
    s name=$$GetPapmiName^DHCWLCommon(reg)  //通过PA_PatMas.PAPMI_RowId得到病人姓名
    i type="SSLS" s catdesc="手术例数"
    i type="7" s catdesc="手术费"
    i type="17" s catdesc="麻醉费"
    i type="76" s catdesc="术后镇痛"
    s Data=$lb(pat,patdesc,war,wardesc,zyh,name,type,catdesc,$fn(outdata,"",2),hos)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetOpCsRpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOpCsRpExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetOpCsRpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOpCsRpExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetOpCsRp(SDate As %String, EDate As %String) As %Query(ROWSPEC = "pat:%Integer,patdesc:%String,war:%Integer,wardesc:%String,zyh:%String,name:%String,type:%String,catdesc:%String,outdata:%Float,hos:%Integer") [ SqlProc ]
{
}

// 抗菌药物使用统计

// d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL","GetPatAntiDrugInfo","2012-04-01","2012-04-30")	

// 注释：DHCWLAntiPatLoad.mac中取的值恰恰是“1类切口预防抗菌药物时间>24h"的，所以以下值为>24h的，剩下的由报表前端进行了处理！！lxc0813

ClassMethod GetPatAntiDrugInfoExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
   
    q:SDate="" $$$OK
 	q:EDate="" $$$OK
    
    k ^temp($j)
	s SDate=$zdh(SDate,3)
	s EDate=$zdh(EDate,3)
	f DisDate=SDate:1:EDate d
	.s PADRowid="",ts=""
	.f  s PADRowid=$o(^DHCWLPADI(0,"DisDate",DisDate,PADRowid)) q:PADRowid=""  d
    ..s admdr=$p(^DHCWLPADI(PADRowid),"^",1)    ;PAADMDR
    ..s admdate=$p(^DHCWLPADI(PADRowid),"^",3)  ;入院日期
    ..;s disdate=$p(^DHCWLPADI(PADRowid),"^",4) ;出院日期
    ..s dept=$p(^DHCWLPADI(PADRowid),"^",5) ;出院科室
    ..s AntiFlag=$p(^DHCWLPADI(PADRowid),"^",9) ;抗菌药物使用标志
    ..s AntiDDD=$p(^DHCWLPADI(PADRowid),"^",12)  ;抗菌药物总DDD值
    ..s OperHealLeve=$p(^DHCWLPADI(PADRowid),"^",26) ;主手术切口愈合等级
    ..s OperPreTime=$p(^DHCWLPADI(PADRowid),"^",27) ;术前预防使用抗菌药物时间
    ..s OperConTime=$p(^DHCWLPADI(PADRowid),"^",28) ;手术预防使用抗菌药物持续时间
    ..s EtiExaFlag=$p(^DHCWLPADI(PADRowid),"^",29) ;病原学检查标志
    ..s IsMedAnti=$p(^DHCWLPADI(PADRowid),"^",30)  ;基本治疗使用标志
    
    ..s SpMedAnti=$p(^DHCWLPADI(PADRowid),"^",32)  ;特殊抗菌药物治疗使用标志
    ..s SpAntFlag=$p(^DHCWLPADI(PADRowid),"^",17)  ;特殊抗菌药物使用标志
    ..s SpAntDDD=$p(^DHCWLPADI(PADRowid),"^",20)  ;特殊抗菌药物总DDD值
    
    ..s LimMedAnti=$p(^DHCWLPADI(PADRowid),"^",31)  ;限制抗菌药物治疗使用标志
    ..s LimAntFlag=$p(^DHCWLPADI(PADRowid),"^",33)  ;限制抗菌药物使用标志
    ..s LimAntDDD=$p(^DHCWLPADI(PADRowid),"^",34)  ;限制抗菌药物总DDD值
    
    ..s ^temp($j,"总人数",dept)=$g(^temp($j,"总人数",dept))+1
    ..i (AntiFlag="1")  s ^temp($j,"抗菌药物使用",dept)=$g(^temp($j,"抗菌药物使用",dept))+1
    ..i ((AntiFlag="1") && (SpAntFlag="1"))  s ^temp($j,"特殊使用抗菌药物",dept)=$g(^temp($j,"特殊使用抗菌药物",dept))+1
    ..i ((AntiFlag="1") && (LimAntFlag="1"))  s ^temp($j,"限制使用抗菌药物",dept)=$g(^temp($j,"限制使用抗菌药物",dept))+1
    ..i (OperHealLeve="1") s ^temp($j,"1类切口总",dept)=$g(^temp($j,"1类切口总",dept))+1
    ..i ((AntiFlag="1") && (OperHealLeve="1") && (OperPreTime'="")) s ^temp($j,"1类切口预防",dept)=$g(^temp($j,"1类切口预防",dept))+1
    ..i ((AntiFlag="1") && (OperHealLeve="1") && (OperConTime="1")) s ^temp($j,"1类切口预防抗菌药物时间≤24h",dept)=$g(^temp($j,"1类切口预防抗菌药物时间≤24h",dept))+1     
    ..i ((AntiFlag="1") && (IsMedAnti="1")) s ^temp($j,"同期使用抗菌药物总例数",dept)=$g(^temp($j,"同期使用抗菌药物总例数",dept))+1
    ..i ((AntiFlag="1") && (EtiExaFlag="1") && (IsMedAnti="1")) s ^temp($j,"病原学检查送检例数",dept)=$g(^temp($j,"病原学检查送检例数",dept))+1
    
    ..i ((AntiFlag="1") && (SpAntFlag="1") && (EtiExaFlag="1") && (SpMedAnti="1")) s ^temp($j,"特殊使用抗菌药物患者病原学检查送检例数",dept)=$g(^temp($j,"特殊使用抗菌药物患者病原学检查送检例数",dept))+1
    ..i ((AntiFlag="1") && (LimAntFlag="1") && (EtiExaFlag="1") && (LimAntFlag="1")) s ^temp($j,"限制使用抗菌药物患者病原学检查送检例数",dept)=$g(^temp($j,"限制使用抗菌药物患者病原学检查送检例数",dept))+1
    
    ..s ^temp($j,"DDD",dept)=$g(^temp($j,"DDD",dept))+AntiDDD
    ..i ((AntiFlag="1") && (SpAntFlag="1")) s ^temp($j,"特殊使用抗菌药物DDD",dept)=$g(^temp($j,"特殊使用抗菌药物DDD",dept))+SpAntDDD
    ..s ts=DisDate-admdate
    ..s ^temp($j,"人天数",dept)=$g(^temp($j,"人天数",dept))+ts
       
    s type=0 f  s type=$o(^temp($j,type)) q:type=""  d
    .s dept=0 f  s dept=$o(^temp($j,type,dept)) q:dept=""  d
    ..s outdata=$g(^temp($j,type,dept)) 
    ..d OutputRow9
    
    k ^temp($j)
 	q $$$OK	
OutputRow9
    i $d(^CTLOC(dept)) d
    .s hos=$P($G(^CTLOC(dept)),"^",22)
    .s patdesc1=$p(^CTLOC(dept),"^",2) ;病人科室desc
    .i patdesc1 [ "-" s patdesc=$p(patdesc1,"-",2)
    .e  s patdesc=patdesc1
    
    s Data=$lb(type,dept,patdesc,outdata)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetPatAntiDrugInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatAntiDrugInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPatAntiDrugInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatAntiDrugInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetPatAntiDrugInfo(SDate As %String, EDate As %String) As %Query(ROWSPEC = "type:%String,dept:%Integer,patdesc:%String,outdata:%Float") [ SqlProc ]
{
}

// 手术分级明细

// d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL","GetOpLsFjMx","2012-03-01","2012-03-12")	

ClassMethod GetOpLsFjMxExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    k ^temp($j)
    q:SDate="" $$$OK
 	q:EDate="" $$$OK
    
	s SDate=$zdh(SDate,3)
	s EDate=$zdh(EDate,3)
	f OrdDate=SDate:1:EDate d
	.s WLRowid=0
	.f  s WLRowid=$o(^DHCWLAnaesthesia(0,"STATDATE",OrdDate,WLRowid)) q:WLRowid=""  d
   	..s opid=$p(^DHCWLAnaesthesia(WLRowid),"^",42)  ;手术名称ID
	..i $d(^ORC("OPER",opid)) s opcode=$p(^ORC("OPER",opid),"^",1)
    ..s arcim=""
    ..s opcode=$$ALPHAUP^SSUTIL4(opcode)
    ..f  s arcim=$O(^ARCIM(0,"Code",opcode,arcim))  q:arcim=""  d
    ...s statParaValue=arcim_"||"_1
    ...s rValue=##class(web.UDHCJFPRICE).GetOrderPrice("","",statParaValue,+$h,"","","","")
    ...s price=$p(rValue,"^",1)  //医嘱单价
    ..s ssqty=$p(^DHCWLAnaesthesia(WLRowid),"^",32)  ;手术例数
    ..s sdocdep=$p(^DHCWLAnaesthesia(WLRowid),"^",51)  ;手术医生所在科室
    ..s opdoc=$p(^DHCWLAnaesthesia(WLRowid),"^",50)  ;手术医生
    ..s recloc=$p(^DHCWLAnaesthesia(WLRowid),"^",63)   ;接收科室
    ..s hos=$P($G(^CTLOC(recloc)),"^",22)
    ..s ^temp($j,sdocdep,opdoc,opid,price,hos)=$g(^temp($j,sdocdep,opdoc,opid,price,hos))+ssqty 
    
    s sdocdep=0 f  s sdocdep=$o(^temp($j,sdocdep)) q:sdocdep=""  d
    .s opdoc=0 f  s opdoc=$o(^temp($j,sdocdep,opdoc)) q:opdoc=""  d
    ..s opid=0 f  s opid=$o(^temp($j,sdocdep,opdoc,opid)) q:opid=""  d
    ...s price=0 f  s price=$o(^temp($j,sdocdep,opdoc,opid,price)) q:price=""  d
    ....s hos=0 f  s hos=$o(^temp($j,sdocdep,opdoc,opid,price,hos)) q:hos=""  d
    .....s outdata=$g(^temp($j,sdocdep,opdoc,opid,price,hos)) 
    .....d OutputRow10
    k ^temp($j)
 	q $$$OK	
OutputRow10
    s sdocname=""
    i $d(^CTPCP(opdoc)) s sdocname=$p(^CTPCP(opdoc,1),"^",2) ;手术医生名称
    
    s sdocdepdesc=""
    i $d(^CTLOC(sdocdep)) d
    .s sdocdepdesc1=$p(^CTLOC(sdocdep),"^",2) ;手术医生所在科室desc
    .i sdocdepdesc1 [ "-" s sdocdepdesc=$p(sdocdepdesc1,"-",2)
    .e  s sdocdepdesc=sdocdepdesc1
    
    s opna=""
    i $d(^ORC("OPER",opid)) s opna=$p(^ORC("OPER",opid),"^",2)
    
    s Data=$lb(sdocdep,sdocdepdesc,opdoc,sdocname,opid,opna,price,ssqty,hos)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetOpLsFjMxFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOpLsFjMxExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetOpLsFjMxClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOpLsFjMxExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetOpLsFjMx(SDate As %String, EDate As %String) As %Query(ROWSPEC = "sdocdep:%Integer,sdocdepdesc:%String,opdoc:%Integer,sdocname:%String,opid:%Integer,opna:%String,price:%Float,ssqty:%Float,hos:%Integer") [ SqlProc ]
{
}

// 患者费用信息

// d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL","GetPatFeeXX","9","")	

ClassMethod GetPatFeeXXExecute(ByRef qHandle As %Binary, ADMRowID As %Integer, Xmmc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
   
    q:ADMRowID="" $$$OK
	s WLRowid=0
	f  s WLRowid=$o(^DHCWorkLoad(0,"PAADM",ADMRowID,WLRowid)) q:WLRowid=""  d
	.s Ordate1=$p(^DHCWorkLoad(WLRowid),"^",5)  ;医嘱日期
	.s Ordate=$zd(Ordate1,3)
	.s Time=$p(^DHCWorkLoad(WLRowid),"^",6)    ;医嘱时间
	.s Time=$zt(Time,1)
	.s SubCate=$p(^DHCWorkLoad(WLRowid),"^",40)  ;会计子分类
	.s Tarcate=$p(^DHCTarC("AC",SubCate),"^",3)  ;会计大类
	.s qty=$p(^DHCWorkLoad(WLRowid),"^",15)  q:qty=0 ;收费项目数量 
    .s Fee=$p(^DHCWorkLoad(WLRowid),"^",16)    ;该医嘱发生的费用
    .s itm=$p(^DHCWorkLoad(WLRowid),"^",22)  ;收费项目
    .s itmdesc=$p(^DHCTARI(itm),"^",2)
    .i Xmmc="" s itmdesc=$p(^DHCTARI(itm),"^",2)
    .e  q:itmdesc'[Xmmc 
    .d OutputRow11
 	q $$$OK	

OutputRow11
    
    s jfdate=Ordate_" "_Time
    s Subdesc=$p(^DHCTarC("AC",SubCate),"^",2)  ;子类名称
    s Tardesc=$p(^DHCTarC("TAC",Tarcate),"^",2) ;大类名称 
    ;i $d(^DHCTARI(itm)) s itmdesc=$p(^DHCTARI(itm),"^",2)
     
    s Data=$lb(WLRowid,Ordate1,Ordate,jfdate,Tardesc,Subdesc,itm,itmdesc,qty,Fee)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetPatFeeXXFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatFeeXXExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPatFeeXXClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatFeeXXExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetPatFeeXX(ADMRowID As %Integer, Xmmc As %String) As %Query(ROWSPEC = "WLRowid:%Integer,Ordate1:%Integer,Ordate:%String,jfdate:%String,Tardesc:%String,Subdesc:%String,itm:%Integer,itmdesc:%String,qty:%Float,Fee:%Float") [ SqlProc ]
{
}

// 出院患者费用核对(DHC_PatientBill和DHC_workload)

// d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL","GetPatFeeHd","2013-01-08","2013-01-08")	

ClassMethod GetPatFeeHdExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    
    k ^temp($j)
    q:SDate="" $$$OK
 	q:EDate="" $$$OK
   
	s SDate=$zdh(SDate,3)
	s EDate=$zdh(EDate,3)
	f chrDate=SDate:1:EDate d
	.s ADMRowID=0,WLRowid=0,PBRowid=0
	.f  s ADMRowID=$o(^PAADMi("DischDate",chrDate,ADMRowID)) q:ADMRowID=""  d
	..s PAADMType=$p(^PAADM(ADMRowID),"^",2) q:PAADMType'="I"
	..s iPatNo=$p(^PAADM(ADMRowID),"^",1) //PA_PatMas.PAPMI_RowId
	..f  s WLRowid=$o(^DHCWorkLoad(0,"PAADM",ADMRowID,WLRowid)) q:WLRowid=""  d
    ...s WFee=$p(^DHCWorkLoad(WLRowid),"^",16)    ;该医嘱发生的费用
    ...s ^temp($j,iPatNo,ADMRowID,"WlR")=$g(^temp($j,iPatNo,ADMRowID,"WlR"))+WFee 
    ..f  s PBRowid=$o(^DHCPB(0,"ADM",ADMRowID,PBRowid)) q:PBRowid=""  d
    ...s PFee=$p(^DHCPB(PBRowid),"^",8)    ;该医嘱发生的账单费用
    ...s ^temp($j,iPatNo,ADMRowID,"PBR")=$g(^temp($j,iPatNo,ADMRowID,"PBR"))+PFee 
    
    s iPatNo=0 f  s iPatNo=$o(^temp($j,iPatNo)) q:iPatNo=""  d
    .s ADMRowID=0 f  s ADMRowID=$o(^temp($j,iPatNo,ADMRowID)) q:ADMRowID=""  d
    ..s outdata=$g(^temp($j,iPatNo,ADMRowID,"WlR"))_"^"_$g(^temp($j,iPatNo,ADMRowID,"PBR"))
    ..s Wlfee=$p(outdata,"^",1)  
    ..s PBfee=$p(outdata,"^",2)  
    ..d OutputRow12
    k ^temp($j)
 	q $$$OK	

OutputRow12
    
   	s name=$$GetPapmiName^DHCWLCommon(iPatNo)  //通过PA_PatMas.PAPMI_RowId得到病人姓名
   	s ybtype=$$GetReason^DHCWLCommon(ADMRowID)   //通过PA_Adm.PAADM_RowID获得病人的人员类别
    s zyh=$$GetPapmiMedtare^DHCWLCommon(iPatNo)  //通过PA_PatMas.PAPMI_RowId得到病人住院号
    s ADMDate=$p(^PAADM(ADMRowID),"^",6) //入院日期
	s:ADMDate'="" ADMDate=$zd(ADMDate,3)
	s CyDate=$p(^PAADM(ADMRowID),"^",17) //出院日期
	s:CyDate'="" CyDate=$zd(CyDate,3)
	
	s admPayFlag=1,admPayDate=0
	s pbId=0
	f  s pbId=$o(^DHCPB(0,"ADM",ADMRowID,pbId)) q:pbId=""  d
	.s payFlag=$p(^DHCPB(pbId),"^",16) ;计费状态(Paid,Bill)
	.s pbDate=$p(^DHCPB(pbId),"^",19) ;账单日期
	.i payFlag="B" s admPayFlag=0
	.i payFlag="P" d
	..i pbDate>admPayDate s admPayDate=pbDate   ;取结算日期的最大值
	
	i (admPayFlag=1)&&(admPayDate>0) d
	.s DischgDate=$zd(admPayDate,3)
	e  d
	.s DischgDate=""
	
    s DepID=$p(^PAADM(ADMRowID),"^",4) //
	i (DepID="")    d
	.s Depcode=""
	.s DepDesc=""
	e            d
	.i ('$d(^CTLOC(DepID)))  d
	..s Depcode=""
	..s DepDesc=""
	.e    d
	..s Depcode=$p(^CTLOC(DepID),"^",1) //科室编号
	..s DepDesc1=$p(^CTLOC(DepID),"^",2) //科室
	..i DepDesc1 [ "-" s DepDesc=$p(DepDesc1,"-",2)
   
	s RoomID=""
	s RoomID=$p(^PAADM(ADMRowID),"^",69) //病房
	i (RoomID="") d
	.s RoomCode="" 
	.s RoomDesc="" 
	e        d
	.i $d(^PAROOM(RoomID))   d
	..s RoomCode=$p(^PAROOM(RoomID),"^",1)
	..s RoomDesc=$p(^PAROOM(RoomID),"^",2)
	.e  s RoomCode="",RoomDesc=""
	s WardID=$p(^PAADM(ADMRowID),"^",70) //病区
	i (WardID="") d
	.s WardCode="" 
	.s WardDesc="" 
	e          d
	.i ('$d(^PAWARD(WardID)))    d
	..s WardCode=""
	..s WardDesc=""
	.e       d
	..s WardCode=$p(^PAWARD(WardID),"^",1)
	..s WardDesc1=$p(^PAWARD(WardID),"^",2)
	..i WardDesc1 [ "-" s WardDesc=$p(WardDesc1,"-",2)
	s BedID=$p(^PAADM(ADMRowID),"^",73) //床位
	s BedRowid=$P(BedID,"||",1)
    s BedSub=$P(BedID,"||",2)
	i (BedID="")!(WardID="") d
	.s BedCode=""
	e       d
	.i ('$d(^PAWARD(WardID,"BED",BedSub)))  d
	..s BedCode=""   d
	.e        d
    ..s BedCode=$P($G(^PAWARD(WardID,"BED",BedSub)),"^",1) 
    
    s Data=$lb(zyh,name,ybtype,DepDesc,WardDesc,BedCode,ADMDate,CyDate,DischgDate,ADMRowID,$fn(Wlfee,"",2),$fn(PBfee,"",2))
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetPatFeeHdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatFeeHdExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPatFeeHdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatFeeHdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetPatFeeHd(SDate As %String, EDate As %String) As %Query(ROWSPEC = "zyh:%String,name:%String,ybtype:%String,DepDesc:%String,WardDesc:%String,BedCode:%String,ADMDate:%String,CyDate:%String,DischgDate:%String,ADMRowID:%Integer,WLfee:%Float,PBfee:%Float") [ SqlProc ]
{
}

// 出院医保患者费用明细报表

// d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL","GetDisPatInsu","2012-4-10","2012-4-10","","","","","","")

ClassMethod GetDisPatInsuExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dept As %Text, ward As %Text, insutype As %Text, shy As %Text, insudiafl As %Text, insudiadesc As %Text) As %Status
{
	n (qHandle,startDate,endDate,dept,ward,insutype,shy,insudiafl,insudiadesc)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
 	;k ^lxc2,^lxc1
 	;s ^lxc2=startDate_"^"_endDate_"^"_dept_"^"_ward_"^"_insutype_"^"_shy_"^"_insudiafl_"^"_insudiadesc
	q:startDate="" $$$OK
	q:endDate="" $$$OK
	d SplitMulitData(dept,,.deptData)
	d SplitMulitData(ward,,.wardData)
	d SplitMulitData(insutype,,.insuData)
	d SplitMulitData(shy,,.shyData)
	d SplietDoubleDetmData(insudiafl,,.diaflData)
	d SplitMulitData(insudiadesc,,.diadescData)
	;m ^lxc1=deptData
	s startDate=$zdh(startDate,3)
	s endDate=$zdh(endDate,3)
	f date=startDate:1:endDate  d
	.s prtId=0
	.f  s prtId=$o(^DHCINVPRTZY(0,"DATE",date,prtId)) q:prtId=""  d
	..s flag=$p(^DHCINVPRTZY(prtId),"^",8) q:flag="A"
	..s pbId=$p(^DHCINVPRTZY(prtId),"^",5)
	..s admInfo=##class(DHCWL.InsuStat.PBInfo).%New(pbId)
	..s code=admInfo.NationCode  
	..q:code=""
	..//判断科室是否为所选科室
	..s dep=admInfo.DeptId 
	..q:(dept'="")&&(dep="") 
	..q:(dept'="")&&('$d(deptData(dep)))
	..//判断病区是否为所选病区
	..;i admWard=
	..s admWard=admInfo.WardId
	..;i admInfo.WardId
	..q:(ward'="")&&(admWard="")
	..q:(ward'="")&&('$d(wardData(admWard)))
	..//判断费别是否为所选费别
	..s admRea=admInfo.InsuTypeId
	..q:(admRea="")&&(insutype'="")
	..q:(insutype'="")&&('$d(insuData(admRea)))
    ..//判断审核员是否为所选审核员
	..s shyr=admInfo.Shy
	..q:(shy'="")&&(shyr="")
	..q:(shy'="")&&(shyr'="")&&('$d(shyData(shyr)))
	..//判断单病种分类是否为所选单病种分类
	..s diafl=admInfo.InsudiaId
	..;w !,diafl_"^"_admInfo.InsudiaFl_"^"_admInfo.Insudiadesc
	..q:(diafl="")&&(insudiafl'="")
	..q:(insudiafl'="")&&('$d(diaflData(diafl)))
	..//判断单病种是否为所选单病种
	..s diadesc=admInfo.InsudiaId
	..q:(diadesc="")&&(insudiadesc'="")
	..q:(insudiadesc'="")&&('$d(diadescData(diadesc)))
	..d admInfo.SetPBFeeInfo()
	..s catId=0
	..f  s catId=$o(^DHCTarC("TIC",catId)) q:catId=""  d
	...s catDesc=$p(^DHCTarC("TIC",catId),"^",2)
	...d OutputRow14
	..s admInfo=""
	    
  	q $$$OK
OutputRow14
	s Data=$lb(admInfo.PBId,admInfo.MedNo,admInfo.PatNo,admInfo.Name,admInfo.Age,admInfo.AdmDATE,admInfo.DisDate,admInfo.Dept,admInfo.Ward,admInfo.InsuType,admInfo.Doctor,admInfo.PBFee,+$g(admInfo.TotalFee.Data(catId)),+$g(admInfo.InsuFee.Data(catId)),+$g(admInfo.PatFee.Data(catId)),catDesc,admInfo.DiagCj,admInfo.InsudiaFl,admInfo.Insudiadesc,admInfo.Shy,admInfo.OutDiagDesc)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q

SplitMulitData(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
	
	q
SplietDoubleDetmData(multiStr,detm=",^",multiData)
	n (multiStr,detm,multiData)
	s detmData(1)=$e(detm,1)
	s detmData(2)=$e(detm,2)
	
	s multiLen=$l(multiStr,detmData(1))
	f len=1:1:multiLen d
	.s data1=$p(multiStr,detmData(1),len)
	.s multiLen2=$l(data1,detmData(2))
	.f len2=1:1:multiLen2 d
	..s data2=$p(data1,detmData(2),len2)
	..q:data2=""
	..s multiData(data2)=""
	
	
	
	q
}

ClassMethod GetDisPatInsuFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDisPatInsuExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDisPatInsuClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDisPatInsuExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDisPatInsu(startDate As %String, endDate As %String, dept As %Text, ward As %Text, insutype As %Text, shy As %Text, insudiafl As %Text, insudiadesc As %Text) As %Query(ROWSPEC = "PBId:%String,MedNo:%String,PatNo:%String,Name:%String,Age:%String,AdmDATE:%String,DisDate:%String,Dept:%String,Ward:%String,InsuType:%String,Doctor:%String,PBFee:%Float,TotalFee:%Float,InsuFee:%Float,PatFee:%Float,catDesc:%String,DiagCj:%Float,InsudiaFl:%String,Insudiadesc:%String,Shy:%String,OutDiagDesc:%String") [ SqlProc ]
{
}

// 协和患者明细输出

// d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL","GetOutDataXHRQ","2012-03-02","2012-03-02")	

ClassMethod GetOutDataXHRQExecute(ByRef qHandle As %Binary, stDate As %String, enDate As %String) As %Status
{
	n (qHandle,stDate,enDate)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
   
    q:stDate="" $$$OK
 	q:enDate="" $$$OK
  	s Num=""
  	;k ^TMPDHCARqLxc("DHCWL","XH","hisdata",$j)
    d OutDataXHRQ^DHCWLToWangHai(stDate,enDate)
    f  s Num=$o(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num)) q:Num=""  d
	.s 关键字=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",1)
	.s 登记号=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",2)
    .s 病人病历号=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",3)
	.s 病人姓名=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",4)
	.s 病人所属医生工号=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",5)
	.s 病人所属医生姓名=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",6)
	.s 开单医师工号=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",7)
	.s 开单医师姓名=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",8)
	.s 病人所在东西院标识=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",9)
	.s 病人所在科室一级科室代码=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",10)
	.s 病人所在科室一级科室名称=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",11)
	.s 病人所在科室二级科室代码=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",12)
	.s 病人所在科室二级科室名称=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",13)
	.s 病人病区东西院标识=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",14)
	.s 病人所在病区代码=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",15)
	.s 病人所在病区名称=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",16)
	.s 病人开单东西院标识=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",17)
	.s 病人开单科室一级科室代码=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",18)
	.s 病人开单科室一级科室名称=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",19)
	.s 病人开单科室二级科室代码=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",20)
	.s 病人开单科室二级科室名称=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",21)
	.s 病人执行东西院标识=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",22)
	.s 病人执行科室一级科室代码=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",23)
	.s 病人执行科室一级科室名称=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",24)
	.s 病人执行科室二级科室代码=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",25)
	.s 病人执行科室二级科室名称=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",26)
	.s 收费项目代码=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",27)
	.s 收费项目名称=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",28)
	.s 数量=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",29)
	.s 金额=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",30) 
    .s 计费日期=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",31)
    .s 门诊收费员工号=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",32)
    .s 门诊收费员名称=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",33)
    .s 病人类型=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",34)
    .s 病人就诊ID=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",35)
    .s 住院次数=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",36)
    .s 核算项目代码=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",37)
    .s 核算项目名称=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",38)
    .s 会计大类代码=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",39)
    .s 会计大类名称=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",40)
    .s 会计子类代码=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",41)
    .s 会计子类名称=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",42)
    .s 门诊子类代码=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",43)
    .s 门诊子类名称=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",44)
    .s 住院子类代码=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",45)
    .s 住院子类名称=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",46)
    .s 单价=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",47)
    .s 医嘱流水=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",48)
    .s 医嘱描述=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",49)
    .s 医嘱代码=$p(^TMPDHCARqLxc("DHCWL","XH","hisdata",$j,Num),"^",50)
    .d OutputRow15
 
    k ^TMPDHCARqLxc("DHCWL","XH","hisdata",$j)
 	q $$$OK	
OutputRow15
    s Data=$lb(关键字,登记号,病人病历号,病人姓名,病人所属医生工号,病人所属医生姓名,开单医师工号,开单医师姓名,病人所在东西院标识,病人所在科室一级科室代码,病人所在科室一级科室名称,病人所在科室二级科室代码,病人所在科室二级科室名称,病人病区东西院标识,病人所在病区代码,病人所在病区名称,病人开单东西院标识,病人开单科室一级科室代码,病人开单科室一级科室名称,病人开单科室二级科室代码,病人开单科室二级科室名称,病人执行东西院标识,病人执行科室一级科室代码,病人执行科室一级科室名称,病人执行科室二级科室代码,病人执行科室二级科室名称,收费项目代码,收费项目名称,数量,金额,计费日期,门诊收费员工号,门诊收费员名称,病人类型,病人就诊ID,住院次数,核算项目代码,核算项目名称,会计大类代码,会计大类名称,会计子类代码,会计子类名称,门诊子类代码,门诊子类名称,住院子类代码,住院子类名称,单价,医嘱流水,医嘱描述,医嘱代码)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetOutDataXHRQFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOutDataXHRQExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetOutDataXHRQClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOutDataXHRQExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetOutDataXHRQ(stDate As %String, enDate As %String) As %Query(ROWSPEC = "关键字:%String,登记号:%String,病人病历号:%String,病人姓名:%String,病人所属医生工号:%String,病人所属医生姓名:%String,开单医师工号:%String,开单医师姓名:%String,病人所在东西院标识:%String,病人所在科室一级科室代码:%String,病人所在科室一级科室名称:%String,病人所在科室二级科室代码:%String,病人所在科室二级科室名称:%String,病人病区东西院标识:%String,病人所在病区代码:%String,病人所在病区名称:%String,病人开单东西院标识:%String,病人开单科室一级科室代码:%String,病人开单科室一级科室名称:%String,病人开单科室二级科室代码:%String,病人开单科室二级科室名称:%String,病人执行东西院标识:%String,病人执行科室一级科室代码:%String,病人执行科室一级科室名称:%String,病人执行科室二级科室代码:%String,病人执行科室二级科室名称:%String,收费项目代码:%String,收费项目名称:%String,数量:%Float,金额:%Float,计费日期:%String,门诊收费员工号:%String,门诊收费员名称:%String,病人类型:%String,病人就诊ID:%String,住院次数:%String,核算项目代码:%String,核算项目名称:%String,会计大类代码:%String,会计大类名称:%String,会计子类代码:%String,会计子类名称:%String,门诊子类代码:%String,门诊子类名称:%String,住院子类代码:%String,住院子类名称:%String,单价:%Float,医嘱流水:%String,医嘱描述:%String,医嘱代码:%String") [ SqlProc ]
{
}

// 非手术费用明细

// d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL","GetFOpIncomeMx","2012-03-02","2012-03-02","")	

ClassMethod GetFOpIncomeMxExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String, Xmmc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
   
    q:SDate="" $$$OK
 	q:EDate="" $$$OK
   
	s SDate=$zdh(SDate,3)
	s EDate=$zdh(EDate,3)
	f OrdDate=SDate:1:EDate d
	.s WLRowid=0
	.f  s WLRowid=$o(^DHCWorkLoad(0,"ORDDATE",OrdDate,WLRowid)) q:WLRowid=""  d
	..s ResLoc=$p(^DHCWorkLoad(WLRowid),"^",23)   ;开单科室
	..s resLocType=$p($g(^CTLOC(+ResLoc)),"^",13)
	..q:resLocType'="OP"
	..s RecLoc=$p(^DHCWorkLoad(WLRowid),"^",1)  ;接收科室
	..i RecLoc="" s RecLoc=ResLoc
	..s recLocType=$p($g(^CTLOC(+RecLoc)),"^",13)
	..q:recLocType'="E"
	..s Ward=$p(^DHCWorkLoad(WLRowid),"^",24) q:Ward=""  ;病人病区
	..s Ordate=$p(^DHCWorkLoad(WLRowid),"^",5)  ;医嘱日期
	..s Ordate=$zd(Ordate,3)
	..s Time=$p(^DHCWorkLoad(WLRowid),"^",6)    ;医嘱时间
	..s Time=$zt(Time,1)
	..s qty=$p(^DHCWorkLoad(WLRowid),"^",15)  q:qty=0 ;收费项目数量 
    ..s income=$p(^DHCWorkLoad(WLRowid),"^",16)    ;该医嘱发生的费用
    ..s resdocdr=$p(^DHCWorkLoad(WLRowid),"^",19)    ;下医嘱医生
    ..s itm=$p(^DHCWorkLoad(WLRowid),"^",22)  ;收费项目
    ..s TarCate=$p(^DHCWorkLoad(WLRowid),"^",41) q:TarCate="7"   ;核算子分类为非手术收入
    ..;s arci=$p(^DHCWorkLoad(WLRowid),"^",2)  ;医嘱项
    ..;s ARCIMRowid=$P(arci,"||",1)
    ..;s ARCIMSub=$P(arci,"||",2)
    ..;s arccode=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",1) 
    ..;s ss=$$IsOperItem^DHCWLQueryWorkLoad(ARCIMRowid)
    ..;q:ss=0
    ..s iPatNo=$p(^DHCWorkLoad(WLRowid),"^",13)  ;PAPMI_RowId
    ..s zyh=$$GetPapmiMedtare^DHCWLCommon(iPatNo) //通过PA_PatMas.PAPMI_RowId得到病人住院号
    ..s name=$$GetPapmiName^DHCWLCommon(iPatNo)  //通过PA_PatMas.PAPMI_RowId得到病人姓名
    ..d OutputRow16
 	q $$$OK	
OutputRow16
    
    i $d(^CTLOC(ResLoc)) d
    .s hos=$P($G(^CTLOC(ResLoc)),"^",22)
    
    i $d(^CTLOC(RecLoc)) d
    .s recdesc1=$P($G(^CTLOC(RecLoc)),"^",2)  
    .i recdesc1 [ "-" s recdesc=$p(recdesc1,"-",2)
    .e  s recdesc=recdesc1
    
    i $d(^CTLOC(Ward)) d
    .s warddesc1=$P($G(^CTLOC(Ward)),"^",2)
    .i warddesc1 [ "-" s warddesc=$p(warddesc1,"-",2)
    .e  s warddesc=warddesc1
    
    i $d(^CTPCP(resdocdr)) s resdoc=$p(^CTPCP(resdocdr,1),"^",2)
    i $d(^DHCTARI(itm)) s itmdesc=$p(^DHCTARI(itm),"^",2) 
    s itmdesc=$p(^DHCTARI(itm),"^",2)
    i Xmmc="" s itmdesc=$p(^DHCTARI(itm),"^",2)
    e  q:itmdesc'[Xmmc 
       
    s ord=Ordate_" "_Time
    s Data=$lb(ord,Ward,warddesc,zyh,name,itm,itmdesc,$fn(qty,"",2),$fn(income,"",2),RecLoc,recdesc,resdocdr,resdoc,hos)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetFOpIncomeMxFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFOpIncomeMxExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetFOpIncomeMxClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFOpIncomeMxExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetFOpIncomeMx(SDate As %String, EDate As %String, Xmmc As %String) As %Query(ROWSPEC = "ord:%String,Ward:%Integer,warddesc:%String,zyh:%String,name:%String,itm:%Integer,itmdesc:%String,qty:%Float,income:%Float,RecLoc:%Integer,recdesc:%String,resdocdr:%Integer,resdoc:%String,hos:%Integer") [ SqlProc ]
{
}

// 用友收入接口

// d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL","GetFYonYIncome","2012-03-02","2012-03-02","I")	

ClassMethod GetFYonYIncomeExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String, type As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
   
    q:SDate="" $$$OK
 	q:EDate="" $$$OK
 	q:type="" $$$OK
   
	;s SDate=$zdh(SDate,3)
	;s EDate=$zdh(EDate,3)
	s Num=""
	d OutPutData^DHCWLToWangHai(SDate,EDate,"ORDDATE",type)
    f  s Num=$o(^TMPDHCALXY("dhc","ca","hisdata",$j,Num)) q:Num=""  d
	.s ym=$p(^TMPDHCALXY("dhc","ca","hisdata",$j,Num),"^",1)
	.s 收费类别编码=$p(^TMPDHCALXY("dhc","ca","hisdata",$j,Num),"^",2)
	.s 收费类别名称=$p(^TMPDHCALXY("dhc","ca","hisdata",$j,Num),"^",3)
	.s 开单科室代码=$p(^TMPDHCALXY("dhc","ca","hisdata",$j,Num),"^",10)
	.s 开单科室描述=$p(^TMPDHCALXY("dhc","ca","hisdata",$j,Num),"^",11)
	.s 开单病区代码=$p(^TMPDHCALXY("dhc","ca","hisdata",$j,Num),"^",12)
	.s 开单病区描述=$p(^TMPDHCALXY("dhc","ca","hisdata",$j,Num),"^",13)
	.s 执行科室编码=$p(^TMPDHCALXY("dhc","ca","hisdata",$j,Num),"^",8)
	.s 执行科室名称=$p(^TMPDHCALXY("dhc","ca","hisdata",$j,Num),"^",9)
	.s 金额=$p(^TMPDHCALXY("dhc","ca","hisdata",$j,Num),"^",5)
    
    .d OutputRow17
    k ^TMPDHCALXY("dhc","ca","hisdata",$j)
 	q $$$OK	
OutputRow17
    s 年度=$e(ym,1,4)
    s 月份=+$e(ym,5,$l(ym))_"月"
    s Data=$lb(年度,月份,收费类别编码,收费类别名称,开单科室代码,开单科室描述,开单病区代码,开单病区描述,执行科室编码,执行科室名称,$fn(金额,"",2))
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetFYonYIncomeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFYonYIncomeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetFYonYIncomeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFYonYIncomeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetFYonYIncome(SDate As %String, EDate As %String, type As %String) As %Query(ROWSPEC = "年度:%String,月份:%String,收费类别编码:%String,收费类别名称:%String,开单科室代码:%String,开单科室描述:%String,开单病区代码:%String,开单病区描述:%String,执行科室编码:%String,执行科室名称:%String,金额:%Float") [ SqlProc ]
{
}

// 用友-住院床日总数-接口

// d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL","GetFYonYGzl","2012-03-01","2012-03-31")	

ClassMethod GetFYonYGzlExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
   
    q:SDate="" $$$OK
 	q:EDate="" $$$OK
  	k data
  	s patward=""
  	d GetZYRS^DHCWLToWangHai(SDate,EDate,.data)
    s loc=0
    f  s loc=$o(data(loc)) q:loc=""  d
    .s ward=0
    .f  s ward=$o(data(loc,ward)) q:ward=""  d
    ..s zyrs=data(loc,ward)
    ..q:+zyrs=0
    ..d OutputRow18
   
 	q $$$OK	
OutputRow18
    s wardDesc=$p(^PAWARD(ward),"^",2) ;病人所在病区desc
    s wardCode=$p(^PAWARD(ward),"^",1) ;病人所在病区code
    s locDesc=$p(^CTLOC(loc),"^",2)	;病人所在科室desc
    s locCode=$p(^CTLOC(loc),"^",1)	;病人所在科室Code
    
    s year=$e(EDate,1,4)
    s ym=$e(EDate,1,7)
    s mon=+$p(ym,"-",2)_"月"
   
    s gzxmbm="ZyCrs"
    s gzxmmc="实际占用住院床日数"
    s Data=$lb(year,mon,locCode,locDesc,wardCode,wardDesc,gzxmbm,gzxmmc,zyrs)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetFYonYGzlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFYonYGzlExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetFYonYGzlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFYonYGzlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetFYonYGzl(SDate As %String, EDate As %String) As %Query(ROWSPEC = "年度:%String,月份:%String,科室代码:%String,科室描述:%String,病区代码:%String,病区描述:%String,工作项目编码:%String,工作项目名称:%String,工作量:%Float") [ SqlProc ]
{
}

// 按接收科室统计某个病区的某一个项目的总数量以及明细,可按医嘱时间或结算时间统计。

// d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL","GetWardItmTj","2012-07-01","2012-07-31","ORDDATE","654","14621") FlagDate

// d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL","GetWardItmTj","2012-04-19","2012-04-19","ORDDATE","112","30152||1")

ClassMethod GetWardItmTjExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String, DateType As %String, recdep As %Text, Xmmc As %Text) As %Status
{
	;n (qHandle,SDate,EDate,DateType,recdep,Xmmc)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
   
    q:SDate="" $$$OK
 	q:EDate="" $$$OK
 	q:DateType="" $$$OK
    q:recdep="" $$$OK
	s SDate=$zdh(SDate,3)
	s EDate=$zdh(EDate,3)
	
	f OrdDate=SDate:1:EDate d
	.s WLRowid=0
	.f  s WLRowid=$o(^DHCWorkLoad(0,DateType,OrdDate,WLRowid)) q:WLRowid=""  d
	..s PAADMType=$p(^DHCWorkLoad(WLRowid),"^",4)
	..q:PAADMType'="I"
	..s RecLoc=$p(^DHCWorkLoad(WLRowid),"^",1)  ;接收科室
	..q:$F(","_recdep_",",","_RecLoc_",")=0  
	..s ResLoc=$p(^DHCWorkLoad(WLRowid),"^",23)   ;开单科室
	..;s Ward=$p(^DHCWorkLoad(WLRowid),"^",24) q:Ward=""  ;病人病区
	..s Ordate=$p(^DHCWorkLoad(WLRowid),"^",5)  ;医嘱日期
	..s Ordate=$zd(Ordate,3)
	..s Time=$p(^DHCWorkLoad(WLRowid),"^",6)    ;医嘱时间
	..s Time=$zt(Time,1)
	..s qty=$p(^DHCWorkLoad(WLRowid),"^",15)  q:qty=0 ;收费项目数量 
    ..s income=$p(^DHCWorkLoad(WLRowid),"^",16)    ;该医嘱发生的费用
    ..s resdocdr=$p(^DHCWorkLoad(WLRowid),"^",19)    ;下医嘱医生
    ..s iPatNo=$p(^DHCWorkLoad(WLRowid),"^",13)  ;PAPMI_RowId
    ..s zyh=$$GetPapmiMedtare^DHCWLCommon(iPatNo) //通过PA_PatMas.PAPMI_RowId得到病人住院号
    ..s name=$$GetPapmiName^DHCWLCommon(iPatNo)  //通过PA_PatMas.PAPMI_RowId得到病人姓名
    ..s taritemdr=$p(^DHCWorkLoad(WLRowid),"^",22)  ;收费项目
	..s TarCate=$p(^DHCTARI(taritemdr),"^",4)       ;收费子分类
	..s arci=$p(^DHCWorkLoad(WLRowid),"^",2)  ;医嘱项 
    ..i Xmmc'="" q:taritemdr'=Xmmc 
 
	..d OutputRow19

 	q $$$OK	

OutputRow19
    
    i $d(^CTLOC(RecLoc)) d
    .s recdesc1=$P($G(^CTLOC(RecLoc)),"^",2)  
    .i recdesc1 [ "-" s recdesc=$p(recdesc1,"-",2)
    .e  s recdesc=recdesc1
    
    i $d(^CTLOC(ResLoc)) d
    .s resdesc1=$P($G(^CTLOC(ResLoc)),"^",2)
    .i resdesc1 [ "-" s resdesc=$p(resdesc1,"-",2)
    .e  s resdesc=resdesc1
    
    i $d(^CTPCP(resdocdr)) s resdoc=$p(^CTPCP(resdocdr,1),"^",2)
    ;i $d(^DHCTARI(taritemdr)) s itmdesc=$p(^DHCTARI(taritemdr),"^",2) 
    ;i itmdesc [ " " s itmdesc=$tr(itmdesc," ","")   //把空格去掉
    ;s itmdesc=$p(^DHCTARI(taritemdr),"^",2)
    ;i Xmmc="" s itmdesc=$p(^DHCTARI(taritemdr),"^",2)
    ;e  q:itmdesc'[Xmmc 
        
    
    i $d(^DHCTARI(taritemdr)) s itmdesc=$p(^DHCTARI(taritemdr),"^",2) 
 
    i $d(^DHCTarC("SC",TarCate)) s catDesc=$p(^DHCTarC("SC",TarCate),"^",2)     
    s ord=Ordate_" "_Time
    
    s ARCIMRowid=$P(arci,"||",1)
    s ARCIMSub=$P(arci,"||",2)
    s arcdesc=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2) 
   
    s Data=$lb(ord,ResLoc,resdesc,zyh,name,TarCate,catDesc,arci,arcdesc,taritemdr,itmdesc,$fn(qty,"",2),$fn(income,"",2),RecLoc,recdesc,resdocdr,resdoc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetWardItmTjFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWardItmTjExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetWardItmTjClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWardItmTjExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetWardItmTj(SDate As %String, EDate As %String, DateType As %String, recdep As %Text, Xmmc As %Text) As %Query(ROWSPEC = "ord:%String,ResLoc:%Integer,resdesc:%String,zyh:%String,name:%String,TarCate:%Integer,catDesc:%String,arci:%String,arcdesc:%String,taritemdr:%Integer,itmdesc:%String,qty:%Float,income:%Float,RecLoc:%Integer,recdesc:%String,resdocdr:%Integer,resdoc:%String") [ SqlProc ]
{
}

// 手术室工作月报明细

// d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL","GetSssMonMx","2012-04-23","2012-04-23","经鼻.口腔吸痰")	

ClassMethod GetSssMonMxExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String, Xmmc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
   
    q:SDate="" $$$OK
 	q:EDate="" $$$OK
   
	s SDate=$zdh(SDate,3)
	s EDate=$zdh(EDate,3)
	f OrdDate=SDate:1:EDate d
	.s WLRowid=0
	.f  s WLRowid=$o(^DHCWorkLoad(0,"ORDDATE",OrdDate,WLRowid)) q:WLRowid=""  d
	..s ResLoc=$p(^DHCWorkLoad(WLRowid),"^",23)   ;开单科室
	..s resLocType=$p($g(^CTLOC(+ResLoc)),"^",13)
	..q:resLocType'="OP"
	..s RecLoc=$p(^DHCWorkLoad(WLRowid),"^",1)  ;接收科室
	..i RecLoc="" s RecLoc=ResLoc
    ..s recLocType=$p($g(^CTLOC(+RecLoc)),"^",13)
	..q:recLocType'="OP"
	..s Ward=$p(^DHCWorkLoad(WLRowid),"^",24) q:Ward=""  ;病人病区
	..s Ordate=$p(^DHCWorkLoad(WLRowid),"^",5)  ;医嘱日期
	..s Ordate=$zd(Ordate,3)
	..s Time=$p(^DHCWorkLoad(WLRowid),"^",6)    ;医嘱时间
	..s Time=$zt(Time,1)
	..s qty=$p(^DHCWorkLoad(WLRowid),"^",15)  q:qty=0 ;收费项目数量 
    ..s income=$p(^DHCWorkLoad(WLRowid),"^",16)    ;该医嘱发生的费用
    ..s resdocdr=$p(^DHCWorkLoad(WLRowid),"^",19)    ;下医嘱医生
    ..s itm=$p(^DHCWorkLoad(WLRowid),"^",22)  ;收费项目
    ..s TarCate=$p(^DHCWorkLoad(WLRowid),"^",41) 
    ..;s arci=$p(^DHCWorkLoad(WLRowid),"^",2)  ;医嘱项
    ..;s ARCIMRowid=$P(arci,"||",1)
    ..;s ARCIMSub=$P(arci,"||",2)
    ..;s arccode=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",1) 
    ..;s ss=$$IsOperItem^DHCWLQueryWorkLoad(ARCIMRowid)
    ..;q:ss=0
    ..s iPatNo=$p(^DHCWorkLoad(WLRowid),"^",13)  ;PAPMI_RowId
    ..s zyh=$$GetPapmiMedtare^DHCWLCommon(iPatNo) //通过PA_PatMas.PAPMI_RowId得到病人住院号
    ..s name=$$GetPapmiName^DHCWLCommon(iPatNo)  //通过PA_PatMas.PAPMI_RowId得到病人姓名
    ..d OutputRow20
 	q $$$OK	
OutputRow20
    
    i $d(^CTLOC(ResLoc)) d
    .s hos=$P($G(^CTLOC(ResLoc)),"^",22)
    .s resdesc1=$P($G(^CTLOC(ResLoc)),"^",2)  
    .i resdesc1 [ "-" s resdesc=$p(resdesc1,"-",2)
    .e  s resdesc=resdesc1
    
    i $d(^CTLOC(RecLoc)) d
    .s recdesc1=$P($G(^CTLOC(RecLoc)),"^",2)  
    .i recdesc1 [ "-" s recdesc=$p(recdesc1,"-",2)
    .e  s recdesc=recdesc1
    
    i $d(^CTLOC(Ward)) d
    .s warddesc1=$P($G(^CTLOC(Ward)),"^",2)
    .i warddesc1 [ "-" s warddesc=$p(warddesc1,"-",2)
    .e  s warddesc=warddesc1
    
    i $d(^CTPCP(resdocdr)) s resdoc=$p(^CTPCP(resdocdr,1),"^",2)
    i $d(^DHCTARI(itm)) s itmdesc=$p(^DHCTARI(itm),"^",2) 
    i itmdesc [ " " s itmdesc=$tr(itmdesc," ","")   //把空格去掉
    s itmdesc=$p(^DHCTARI(itm),"^",2)
    i Xmmc="" s itmdesc=$p(^DHCTARI(itm),"^",2)
    e  q:itmdesc'[Xmmc 
       
    s ord=Ordate_" "_Time
    s Data=$lb(ord,Ward,warddesc,zyh,name,itm,itmdesc,$fn(qty,"",2),$fn(income,"",2),ResLoc,resdesc,resdocdr,resdoc,hos)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetSssMonMxFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSssMonMxExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetSssMonMxClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSssMonMxExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetSssMonMx(SDate As %String, EDate As %String, Xmmc As %String) As %Query(ROWSPEC = "ord:%String,Ward:%Integer,warddesc:%String,zyh:%String,name:%String,itm:%Integer,itmdesc:%String,qty:%Float,income:%Float,ResLoc:%Integer,resdesc:%String,resdocdr:%Integer,resdoc:%String,hos:%Integer") [ SqlProc ]
{
}

// 手术费用明细-为MEDTRAK用,去掉Xmmc条件

// d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL","GetOpIncomeMxmMED","2012-04-01","2012-04-30")	

ClassMethod GetOpIncomeMxmMEDExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
   
    q:SDate="" $$$OK
 	q:EDate="" $$$OK
   
	s SDate=$zdh(SDate,3)
	s EDate=$zdh(EDate,3)
	f OrdDate=SDate:1:EDate d
	.s WLRowid=0
	.f  s WLRowid=$o(^DHCWorkLoad(0,"ORDDATE",OrdDate,WLRowid)) q:WLRowid=""  d
	..s ResLoc=$p(^DHCWorkLoad(WLRowid),"^",23)   ;开单科室
	..s resLocType=$p($g(^CTLOC(+ResLoc)),"^",13)
	..s RecLoc=$p(^DHCWorkLoad(WLRowid),"^",1)  ;接收科室
	..i RecLoc="" s RecLoc=ResLoc
	..;s recLocType=$p($g(^CTLOC(+RecLoc)),"^",13)
	..;q:recLocType'="E"
	..q:resLocType'="OP"
	..s Ward=$p(^DHCWorkLoad(WLRowid),"^",24) q:Ward=""  ;病人病区
	..s Ordate=$p(^DHCWorkLoad(WLRowid),"^",5)  ;医嘱日期
	..s Ordate=$zd(Ordate,3)
	..s Time=$p(^DHCWorkLoad(WLRowid),"^",6)    ;医嘱时间
	..s Time=$zt(Time,1)
	..s qty=$p(^DHCWorkLoad(WLRowid),"^",15)  q:qty=0 ;收费项目数量 
    ..s income=$p(^DHCWorkLoad(WLRowid),"^",16)    ;该医嘱发生的费用
    ..s resdocdr=$p(^DHCWorkLoad(WLRowid),"^",19)    ;下医嘱医生
    ..s itm=$p(^DHCWorkLoad(WLRowid),"^",22)  ;收费项目
    ..s TarCate=$p(^DHCWorkLoad(WLRowid),"^",41) q:TarCate'="7"   ;核算子分类为手术收入
    ..;s arci=$p(^DHCWorkLoad(WLRowid),"^",2)  ;医嘱项
    ..;s ARCIMRowid=$P(arci,"||",1)
    ..;s ARCIMSub=$P(arci,"||",2)
    ..;s arccode=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",1) 
    ..;s ss=$$IsOperItem^DHCWLQueryWorkLoad(ARCIMRowid)
    ..;q:ss=0
    ..s iPatNo=$p(^DHCWorkLoad(WLRowid),"^",13)  ;PAPMI_RowId
    ..s zyh=$$GetPapmiMedtare^DHCWLCommon(iPatNo) //通过PA_PatMas.PAPMI_RowId得到病人住院号
    ..s name=$$GetPapmiName^DHCWLCommon(iPatNo)  //通过PA_PatMas.PAPMI_RowId得到病人姓名
    ..d OutputRow21
 	q $$$OK	
OutputRow21
    
    i $d(^CTLOC(ResLoc)) d
    .s hos=$P($G(^CTLOC(ResLoc)),"^",22)
    
    i $d(^CTLOC(RecLoc)) d
    .s recdesc1=$P($G(^CTLOC(RecLoc)),"^",2)  
    .i recdesc1 [ "-" s recdesc=$p(recdesc1,"-",2)
    .e  s recdesc=recdesc1
    
    i $d(^CTLOC(Ward)) d
    .s warddesc1=$P($G(^CTLOC(Ward)),"^",2)
    .i warddesc1 [ "-" s warddesc=$p(warddesc1,"-",2)
    .e  s warddesc=warddesc1
    
    i $d(^CTPCP(resdocdr)) s resdoc=$p(^CTPCP(resdocdr,1),"^",2)
    i $d(^DHCTARI(itm)) s itmdesc=$p(^DHCTARI(itm),"^",2) 
    i itmdesc [ " " s itmdesc=$tr(itmdesc," ","")   //把空格去掉
    s itmdesc=$p(^DHCTARI(itm),"^",2)
    ;i Xmmc="" s itmdesc=$p(^DHCTARI(itm),"^",2)
    ;e  q:itmdesc'[Xmmc 
       
    s ord=Ordate_" "_Time
    s Data=$lb(ord,Ward,warddesc,zyh,name,itm,itmdesc,$fn(qty,"",2),$fn(income,"",2),RecLoc,recdesc,resdocdr,resdoc,hos)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetOpIncomeMxmMEDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOpIncomeMxmMEDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetOpIncomeMxmMEDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOpIncomeMxmMEDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetOpIncomeMxmMED(SDate As %String, EDate As %String) As %Query(ROWSPEC = "ord:%String,Ward:%Integer,warddesc:%String,zyh:%String,name:%String,itm:%Integer,itmdesc:%String,qty:%Float,income:%Float,RecLoc:%Integer,recdesc:%String,resdocdr:%Integer,resdoc:%String,hos:%Integer") [ SqlProc ]
{
}

// 住院处分项统计报表

// d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL","GetZycfxtj","2012-07-20","2012-08-07","PatWardHsf")	

ClassMethod GetZycfxtjExecute(ByRef qHandle As %Binary, sday As %String, eday As %String, type As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
   
    q:sday="" $$$OK
 	q:eday="" $$$OK 
    
    //mPLIST(0)="序号^科室代码^科室描述^床位收入^小计^诊察收入^小计^CT收入^核磁收入^B超收入^放射收入^其他^小计^化验收入^小计^治疗收入^小计^手术收入^小计^护理收入^小计^卫生材料收入^小计^西药^中成药^中草药^小计^药事服务收入^小计^输血收入^输氧收入^抢救费收入^会诊费收入^取暖费收入^伙食收入^其他^小计^结算差额^小计^合计"
    i type="Loc"  s outdata=$$GetLocFee^DHCWLGetPatStatFee(sday,eday)
    //mPLIST(0)="序号^科室代码^科室描述^病区代码^病区描述^床位收入^小计^诊察收入^小计^CT收入^核磁收入^B超收入^放射收入^其他^小计^化验收入^小计^治疗收入^小计^手术收入^小计^护理收入^小计^卫生材料收入^小计^西药^中成药^中草药^小计^药事服务收入^小计^输血收入^输氧收入^抢救费收入^会诊费收入^取暖费收入^伙食收入^其他^小计^结算差额^小计^合计"
    i type="Ward"  s outdata=$$GetLocWardFee^DHCWLGetPatStatFee(sday,eday)
    //mPLIST(0)="序号^科室代码^科室描述^病区代码^病区描述^伙食费^小计^合计
    i type="WardHsf"  s outdata=$$GetLocWardHsfFee^DHCWLGetPatStatFee(sday,eday)
    //mPLIST(0)="序号^科室代码^科室描述^病区代码^病区描述^病人姓名^病案号^床位收入^小计^诊察收入^小计^CT收入^核磁收入^B超收入^放射收入^其他^小计^化验收入^小计^治疗收入^小计^手术收入^小计^护理收入^小计^卫生材料收入^小计^西药^中成药^中草药^小计^药事服务收入^小计^输血收入^输氧收入^抢救费收入^会诊费收入^取暖费收入^伙食收入^其他^小计^结算差额^小计^合计
    i type="PatWard"  s outdata=$$GetPatWardFee^DHCWLGetPatStatFee(sday,eday)
    //mPLIST(0)="序号^科室代码^科室描述^病区代码^病区描述^病人姓名^病案号^伙食费^小计^合计
    i type="PatWardHsf"  s outdata=$$GetPatWardHsfFee^DHCWLGetPatStatFee(sday,eday)
    f num=0:1:outdata-1 d
    .s data1=$p(mPLIST(num),"^",1)
    .s data2=$p(mPLIST(num),"^",2)
    .s data3=$p(mPLIST(num),"^",3)
    .s data4=$p(mPLIST(num),"^",4)
    .s data5=$p(mPLIST(num),"^",5)
    .s data6=$p(mPLIST(num),"^",6)
    .s data7=$p(mPLIST(num),"^",7)
    .s data8=$p(mPLIST(num),"^",8)
    .s data9=$p(mPLIST(num),"^",9)
    .s data10=$p(mPLIST(num),"^",10)
    .s data11=$p(mPLIST(num),"^",11)
    .s data12=$p(mPLIST(num),"^",12)
    .s data13=$p(mPLIST(num),"^",13)
    .s data14=$p(mPLIST(num),"^",14)
    .s data15=$p(mPLIST(num),"^",15)
    .s data16=$p(mPLIST(num),"^",16)
    .s data17=$p(mPLIST(num),"^",17)
    .s data18=$p(mPLIST(num),"^",18)
    .s data19=$p(mPLIST(num),"^",19)
    .s data20=$p(mPLIST(num),"^",20)
    .s data21=$p(mPLIST(num),"^",21)
    .s data22=$p(mPLIST(num),"^",22)
    .s data23=$p(mPLIST(num),"^",23)
    .s data24=$p(mPLIST(num),"^",24)
    .s data25=$p(mPLIST(num),"^",25)
    .s data26=$p(mPLIST(num),"^",26)
    .s data27=$p(mPLIST(num),"^",27)
    .s data28=$p(mPLIST(num),"^",28)
    .s data29=$p(mPLIST(num),"^",29)
    .s data30=$p(mPLIST(num),"^",30)
    .s data31=$p(mPLIST(num),"^",31)
    .s data32=$p(mPLIST(num),"^",32)
    .s data33=$p(mPLIST(num),"^",33)
    .s data34=$p(mPLIST(num),"^",34)
    .s data35=$p(mPLIST(num),"^",35)
    .s data36=$p(mPLIST(num),"^",36)
    .s data37=$p(mPLIST(num),"^",37)
    .s data38=$p(mPLIST(num),"^",38)
    .s data39=$p(mPLIST(num),"^",39)
    .s data40=$p(mPLIST(num),"^",40)
    .s data41=$p(mPLIST(num),"^",41)
    .s data42=$p(mPLIST(num),"^",42)
    .s data43=$p(mPLIST(num),"^",43)
    .s data44=$p(mPLIST(num),"^",44)
    .d OutputRow22
    
 	q $$$OK	
OutputRow22
    
    s Data=$lb(data1,data2,data3,data4,data5,data6,data7,data8,data9,data10,data11,data12,data13,data14,data15,data16,data17,data18,data19,data20,data21,data22,data23,data24,data25,data26,data27,data28,data29,data30,data31,data32,data33,data34,data35,data36,data37,data38,data39,data40,data41,data42,data43,data44)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetZycfxtjFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetZycfxtjExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetZycfxtjClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetZycfxtjExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetZycfxtj(sday As %String, eday As %String, type As %String) As %Query(ROWSPEC = "data1:%String,data2:%String,data3:%String,data4:%String,data5:%String,data6:%String,data7:%String,data8:%String,data9:%String,data10:%String,data11:%String,data12:%String,data13:%String,data14:%String,data15:%String,data16:%String,data17:%String,data18:%String,data19:%String,data20:%String,data21:%String,data22:%String,data23:%String,data24:%String,data25:%String,data26:%String,data27:%String,data28:%String,data29:%String,data30:%String,data31:%String,data32:%String,data33:%String,data34:%String,data35:%String,data36:%String,data37:%String,data38:%String,data39:%String,data40:%String,data41:%String,data42:%String,data43:%String,data44:%String") [ SqlProc ]
{
}

// 用户权限报表分配

// d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL","GetDHCWLUserRptFp")	

ClassMethod GetDHCWLUserRptFpExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
    s USGrpImRowid=""
    f  s USGrpImRowid=$o(^DHCWLUserStatGrpItem(USGrpImRowid))   q:USGrpImRowid=""   d
    .q:((USGrpImRowid=0) || (USGrpImRowid="GROUP") || (USGrpImRowid="SSUser"))
    .s useId=$p(^DHCWLUserStatGrpItem(USGrpImRowid),"^",1)
    .s tjz=$p(^DHCWLUserStatGrpItem(USGrpImRowid),"^",3)
    .s usercode=$p(^SSU("SSUSR",useId),"^",1)
    .s username=$p(^SSU("SSUSR",useId),"^",2)
    
    .s hosRowId=$g(^DHCWLInitStat("Hospital")) 
    .s outdata=$$GetReportByCon^DHCWLUSGroup(useId) 
    .f num=1:1:outdata-1 d
    ..s Rptrowid=$p(mPLIST(num),"^",1)
    ..s Rpttype=$p(mPLIST(num),"^",2)
    ..s Rptname=$p(mPLIST(num),"^",3)
    ..s Rptdesc=$p(mPLIST(num),"^",4)
    ..d OutputRow23   
 	q $$$OK	

OutputRow23

    s outdata=$$ParseCondResRec^DHCWLPeriodParseCondRq(Rptrowid)
      	
    s Data=$lb(usercode,username,tjz,Rptrowid,Rpttype,Rptname,Rptdesc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetDHCWLUserRptFpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDHCWLUserRptFpExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDHCWLUserRptFpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDHCWLUserRptFpExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDHCWLUserRptFp() As %Query(ROWSPEC = "usercode:%String,username:%String,tjz:%String,Rptrowid:%String,Rpttype:%String,Rptname:%String,Rptdesc:%String") [ SqlProc ]
{
}

// 抗菌药物使用明细统计

// d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL","GetPatAntiDrugInfoMx","2012-06-01","2012-06-30")	

ClassMethod GetPatAntiDrugInfoMxExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
   
    q:SDate="" $$$OK
 	q:EDate="" $$$OK
    
    k ^temp($j)
	s SDate=$zdh(SDate,3)
	s EDate=$zdh(EDate,3)
	f DisDate=SDate:1:EDate d
	.s PADRowid="",ts=""
	.f  s PADRowid=$o(^DHCWLPADI(0,"DisDate",DisDate,PADRowid)) q:PADRowid=""  d
    ..s admId=$p(^DHCWLPADI(PADRowid),"^",1)  q:'$d(^PAADM(admId))  ;PAADMDR
    ..s PAPMI=$P(^PAADM(admId),"^",1) 
	..s PatNo=$$GetPapmiNo^DHCWLCommon(PAPMI) //通过PA_PatMas.PAPMI_RowId得到病人登记号
    ..s MEDICA=$$GetPapmiMedtare^DHCWLCommon(PAPMI) //通过PA_PatMas.PAPMI_RowId得到病人住院号
    ..s NAME=$$GetPapmiName^DHCWLCommon(PAPMI)  //通过PA_PatMas.PAPMI_RowId得到病人姓名 
    ..s admdate=$p(^DHCWLPADI(PADRowid),"^",3)  ;入院日期
    ..s admdate=$zd(admdate,3)
    ..;s disdate=$p(^DHCWLPADI(PADRowid),"^",4) ;出院日期
    ..s dept=$p(^DHCWLPADI(PADRowid),"^",5) ;出院科室
    ..s AntiFlag=$p(^DHCWLPADI(PADRowid),"^",9) ;抗菌药物使用标志
    ..s AntiDDD=$p(^DHCWLPADI(PADRowid),"^",12)  ;抗菌药物总DDD值
    ..s OperHealLeve=$p(^DHCWLPADI(PADRowid),"^",26) ;主手术切口愈合等级
    ..s OperPreTime=$p(^DHCWLPADI(PADRowid),"^",27) ;术前预防使用抗菌药物时间
    ..s OperConTime=$p(^DHCWLPADI(PADRowid),"^",28) ;手术预防使用抗菌药物持续时间
    ..s EtiExaFlag=$p(^DHCWLPADI(PADRowid),"^",29) ;病原学检查标志
    ..s IsMedAnti=$p(^DHCWLPADI(PADRowid),"^",30)  ;基本治疗使用标志
    
    ..s SpMedAnti=$p(^DHCWLPADI(PADRowid),"^",32)  ;特殊抗菌药物治疗使用标志
    ..s SpAntFlag=$p(^DHCWLPADI(PADRowid),"^",17)  ;特殊抗菌药物使用标志
    ..s SpAntDDD=$p(^DHCWLPADI(PADRowid),"^",20)  ;特殊抗菌药物总DDD值
    
    ..s LimMedAnti=$p(^DHCWLPADI(PADRowid),"^",31)  ;限制抗菌药物治疗使用标志
    ..s LimAntFlag=$p(^DHCWLPADI(PADRowid),"^",33)  ;q:LimAntFlag'="1" ;限制抗菌药物使用标志
    ..s LimAntDDD=$p(^DHCWLPADI(PADRowid),"^",34)  ;限制抗菌药物总DDD值
   
    ..d OutputRow24
    
    k ^temp($j)
 	q $$$OK	
OutputRow24
     
    i $d(^CTLOC(dept)) d
    .s patdesc1=$p(^CTLOC(dept),"^",2) ;病人科室desc
    .i patdesc1 [ "-" s patdesc=$p(patdesc1,"-",2)
    .e  s patdesc=patdesc1
    
    s Data=$lb(admId,PatNo,MEDICA,NAME,admdate,patdesc,AntiFlag,AntiDDD,OperHealLeve,OperPreTime,OperConTime,EtiExaFlag,IsMedAnti,SpMedAnti,SpAntFlag,SpAntDDD,LimMedAnti,LimAntFlag,LimAntDDD)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetPatAntiDrugInfoMxFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatAntiDrugInfoMxExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPatAntiDrugInfoMxClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatAntiDrugInfoMxExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetPatAntiDrugInfoMx(SDate As %String, EDate As %String) As %Query(ROWSPEC = "admId:%String,PatNo:%String,MEDICA:%String,NAME:%String,admdate:%String,patdesc:%String,AntiFlag:%String,AntiDDD:%String,OperHealLeve:%String,OperPreTime:%String,OperConTime:%String,EtiExaFlag:%String,IsMedAnti:%String,SpMedAnti:%String,SpAntFlag:%String,SpAntDDD:%String,LimMedAnti:%String,LimAntFlag:%String,LimAntDDD:%String") [ SqlProc ]
{
}

// 按接收科室统计某一个医嘱项的总数量以及明细,可按医嘱时间或结算时间统计。

// d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL","GetDeptItmTj","2012-08-02","2012-08-02","ORDDATE","654","22067||1") 

// d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL","GetDeptItmTj","2012-07-16","2012-07-16","ORDDATE","322","30152||1")

ClassMethod GetDeptItmTjExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String, DateType As %String, recdep As %Text, Xmmc As %Text) As %Status
{
	;n (qHandle,SDate,EDate,DateType,recdep,Xmmc)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
   
    q:SDate="" $$$OK
 	q:EDate="" $$$OK
 	q:DateType="" $$$OK
    q:recdep="" $$$OK
	s SDate=$zdh(SDate,3)
	s EDate=$zdh(EDate,3)
	K ^temp($j,"ArPric"),^temp($j,"DhcWork")
	
	f OrdDate=SDate:1:EDate d
	.s WLRowid=0,income=0
	.f  s WLRowid=$o(^DHCWorkLoad(0,DateType,OrdDate,WLRowid)) q:WLRowid=""  d
	..s PAADMType=$p(^DHCWorkLoad(WLRowid),"^",4)
	..s RecLoc=$p(^DHCWorkLoad(WLRowid),"^",1)  ;接收科室
	..q:$F(","_recdep_",",","_RecLoc_",")=0  
	..s ResLoc=$p(^DHCWorkLoad(WLRowid),"^",23)   ;开单科室
	..s Ordate=$p(^DHCWorkLoad(WLRowid),"^",5)  ;医嘱日期
	..s Ordate=$zd(Ordate,3)
	..s Time=$p(^DHCWorkLoad(WLRowid),"^",6)    ;医嘱时间
	..s Time=$zt(Time,1)
	..s ord=Ordate_" "_Time 
	..;s qty=$p(^DHCWorkLoad(WLRowid),"^",15)  q:qty=0 ;收费项目数量 
    ..s income=$p(^DHCWorkLoad(WLRowid),"^",16)    ;该医嘱发生的费用
    ..s resdocdr=$p(^DHCWorkLoad(WLRowid),"^",19)    ;执行医生18、下医嘱医生19
    ..i resdocdr="" s resdocdr=99999
    ..s iPatNo=$p(^DHCWorkLoad(WLRowid),"^",13)  ;PAPMI_RowId
    ..s taritemdr=$p(^DHCWorkLoad(WLRowid),"^",22)  ;收费项目
    ..s TarSubCate=$p(^DHCWorkLoad(WLRowid),"^",41)       ;核算子分类
    ..i TarSubCate="" s TarSubCate=99999
	..s TarCate=$p(^DHCTarC("EC",TarSubCate),"^",3)  ;DHC_TarEMCCate 核算大类
    ..i TarCate="" s TarCate=99999
	..s arci=$p(^DHCWorkLoad(WLRowid),"^",2)  ;医嘱项 
    ..i ((Xmmc'="null")&&(Xmmc'="")) q:arci'=Xmmc 
    ..s ^temp($j,"DhcWork",ord,ResLoc,iPatNo,TarCate,RecLoc,resdocdr,arci,taritemdr)=$g(^temp($j,"DhcWork",ord,ResLoc,iPatNo,TarCate,RecLoc,resdocdr,arci,taritemdr))+income
    ..s oedate=$p(^DHCWorkLoad(WLRowid),"^",5) 
    ..s oeordIdd=$p(^DHCWorkLoad(WLRowid),"^",21)    ;医嘱
    ..s oeordId=$P(oeordIdd,"||",1)
    ..s oeoriSub=0 f  s oeoriSub=$o(^OEORD(oeordId,"I",oeoriSub)) q:oeoriSub=""  d
    ...s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
    ...s oeoriPrice=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",25)
    ...s price=+##CLASS(UDHCJFPRICE).GetOrderPrice("","",arcimId,oedate,"","","",oeoriPrice)
    ...s price=$fn(price,"",2)
    ...s ^temp($j,"ArPric",arcimId)=price 
	
    s ord="" f  s ord=$o(^temp($j,"DhcWork",ord)) q:ord=""  d
	.s ResLoc="" f  s ResLoc=$o(^temp($j,"DhcWork",ord,ResLoc)) q:ResLoc=""  d
	..s iPatNo="" f  s iPatNo=$o(^temp($j,"DhcWork",ord,ResLoc,iPatNo)) q:iPatNo=""  d
	...s TarCate="" f  s TarCate=$o(^temp($j,"DhcWork",ord,ResLoc,iPatNo,TarCate)) q:TarCate=""  d
	....s RecLoc="" f  s RecLoc=$o(^temp($j,"DhcWork",ord,ResLoc,iPatNo,TarCate,RecLoc)) q:RecLoc=""  d
	.....s resdocdr="" f  s resdocdr=$o(^temp($j,"DhcWork",ord,ResLoc,iPatNo,TarCate,RecLoc,resdocdr)) q:resdocdr=""  d
	......s arci="" f  s arci=$o(^temp($j,"DhcWork",ord,ResLoc,iPatNo,TarCate,RecLoc,resdocdr,arci)) q:arci=""  d
	.......s taritemdr="" f  s taritemdr=$o(^temp($j,"DhcWork",ord,ResLoc,iPatNo,TarCate,RecLoc,resdocdr,arci,taritemdr)) q:taritemdr=""  d
	........s income=$g(^temp($j,"DhcWork",ord,ResLoc,iPatNo,TarCate,RecLoc,resdocdr,arci,taritemdr))
    ........d OutputRow25
    K ^temp($j,"ArPric"),^temp($j,"DhcWork")
 	q $$$OK	

OutputRow25
   
    s zyh=$$GetPapmiNo^DHCWLCommon(iPatNo) //通过PA_PatMas.PAPMI_RowId得到病人登记号
    s name=$$GetPapmiName^DHCWLCommon(iPatNo)  //通过PA_PatMas.PAPMI_RowId得到病人姓名
    
    i $d(^CTLOC(RecLoc)) d
    .s recdesc1=$P($G(^CTLOC(RecLoc)),"^",2)  
    .i recdesc1 [ "-" s recdesc=$p(recdesc1,"-",2)
    .e  s recdesc=recdesc1
    
    i $d(^CTLOC(ResLoc)) d
    .s resdesc1=$P($G(^CTLOC(ResLoc)),"^",2)
    .i resdesc1 [ "-" s resdesc=$p(resdesc1,"-",2)
    .e  s resdesc=resdesc1
    
    i $d(^CTPCP(resdocdr)) s resdoc=$p(^CTPCP(resdocdr,1),"^",2)
    ;i $d(^DHCTARI(taritemdr)) s itmdesc=$p(^DHCTARI(taritemdr),"^",2) 
    ;i itmdesc [ " " s itmdesc=$tr(itmdesc," ","")   //把空格去掉
    ;s itmdesc=$p(^DHCTARI(taritemdr),"^",2)
    ;i Xmmc="" s itmdesc=$p(^DHCTARI(taritemdr),"^",2)
    ;e  q:itmdesc'[Xmmc 
        
    s ARCIMRowid=$P(arci,"||",1)
    s ARCIMSub=$P(arci,"||",2)
    s arcdesc=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2) 
    i $d(^temp($j,"ArPric",arci)) s pri=$p(^temp($j,"ArPric",arci),"^",1)  q:pri="0.00"   
    i $d(^DHCTARI(taritemdr)) s itmdesc=$p(^DHCTARI(taritemdr),"^",2) 
    i $d(^DHCTarC("TEC",TarCate)) s catDesc=$p(^DHCTarC("TEC",TarCate),"^",2)  //核算大类
    
    s Data=$lb(ord,ResLoc,resdesc,zyh,name,TarCate,catDesc,arci,arcdesc,pri,taritemdr,itmdesc,$fn(income,"",2),RecLoc,recdesc,resdocdr,resdoc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetDeptItmTjFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDeptItmTjExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDeptItmTjClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDeptItmTjExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDeptItmTj(SDate As %String, EDate As %String, DateType As %String, recdep As %Text, Xmmc As %Text) As %Query(ROWSPEC = "ord:%String,ResLoc:%Integer,resdesc:%String,zyh:%String,name:%String,TarCate:%Integer,catDesc:%String,arci:%String,arcdesc:%String,pri:%Float,taritemdr:%Integer,itmdesc:%String,income:%Float,RecLoc:%Integer,recdesc:%String,resdocdr:%Integer,resdoc:%String") [ SqlProc ]
{
}

// 工作量对照,此部分用来对照工作量主表的”在院人数“与明细表的”在院人数“是否一致。如不一致则考虑重新生成数据。

// d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL","GetGzlDZ","2012-10-01","2012-10-18")	

// d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL","GetGzlDZ","2012-01-31","2013-01-31")

ClassMethod GetGzlDZExecute(ByRef qHandle As %Binary, mSDate As %String, mEDate As %String, hosId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    
    q:mSDate="" $$$OK
 	q:mEDate="" $$$OK
 	//q:hosId="" $$$OK
 	
    k ^temp($j),^temp1($j)
    s mSDate=$zdh(mSDate,3)
    s mEDate=$zdh(mEDate,3)
        
	f mDate=mSDate:1:mEDate d
	.s mId="",mXYRS=0,mLocDr=0
	.f  s mId=$o(^MRIPdaily("MRIP_DATE",mDate,mId)) q:mId=""  d
    ..s brloc=$p($g(^MRIPdaily(mId)),"^",7)  ;科室
    ..s brward=$p($g(^MRIPdaily(mId)),"^",19)  ;病房
    ..i brloc'="" s hosDr=$p(^CTLOC(brloc),"^",22)
    ..e  d
    ...s wardLocDr=$p(^PAWARD(brward),"^",5)
    ...s hosDr=$p(^CTLOC(wardLocDr),"^",22)
    ..q:((","_hosId_",")'[(","_hosDr_","))&&(hosId'="")
	..s mXYRS=$p($g(^MRIPdaily(mId)),"^",18)
	..i brloc'="" s ^temp($j,mDate,brloc,"hz")=$g(^temp($j,mDate,brloc,"hz"))+mXYRS
	..i brward'="" s ^temp1($j,mDate,brward,"hz")=$g(^temp1($j,mDate,brward,"hz"))+mXYRS
	..s mDetailSum=0
	..s mSubId=0
	..f  s mSubId=$o(^DHCMRIPDetail(0,"IPDay",mId,mSubId)) q:$g(mSubId)=""  d
	...s mDetailType=$p($g(^DHCMRIPDetail(mSubId)),"^",2)
	...q:$g(mDetailType)'="ZYRS"
    ...i brloc'="" s ^temp($j,mDate,brloc,"mx")=$g(^temp($j,mDate,brloc,"mx"))+1
    ...i brward'="" s ^temp1($j,mDate,brward,"mx")=$g(^temp1($j,mDate,brward,"mx"))+1
    
    s Date=0 f   s Date=$o(^temp($j,Date))  q:Date=""  d
    .s mLocDr=0 f  s mLocDr=$o(^temp($j,Date,mLocDr))  q:mLocDr=""  d
    ..s outdata=$g(^temp($j,Date,mLocDr,"hz"))_"^"_$g(^temp($j,Date,mLocDr,"mx"))
    ..s hz=$p(outdata,"^",1)
    ..s mx=$p(outdata,"^",2)
    ..q:hz-mx=0
    ..s locDesc=$p(^CTLOC(mLocDr),"^",2)	;病人所在科室desc
    ..d OutputRow26
    k ^temp($j)
    s Date=0 f   s Date=$o(^temp1($j,Date))  q:Date=""  d
    .s mLocDr=0 f  s mLocDr=$o(^temp1($j,Date,mLocDr))  q:mLocDr=""  d
    ..s outdata=$g(^temp1($j,Date,mLocDr,"hz"))_"^"_$g(^temp1($j,Date,mLocDr,"mx"))
    ..s hz=$p(outdata,"^",1)
    ..s mx=$p(outdata,"^",2)
    ..q:hz-mx=0
    ..s locDesc=$p(^PAWARD(mLocDr),"^",2)	;病人所在科室desc
    ..d OutputRow26
    k ^temp1($j)
 	q $$$OK	
OutputRow26
   
    s date1=$zd(Date,3)
    s Data=$lb(date1,mLocDr,locDesc,outdata)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetGzlDZFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGzlDZExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetGzlDZClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGzlDZExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetGzlDZ(mSDate As %String, mEDate As %String, hosId As %String) As %Query(ROWSPEC = "Date:%String,mLocDr:%String,locDesc:%String,outdata:%String") [ SqlProc ]
{
}

// 集成平台对账

// d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL","GetJCPTDz","2012-07-01","2012-07-01")	

ClassMethod GetJCPTDzExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
   
    q:SDate="" $$$OK
 	q:EDate="" $$$OK
 	k ^TEMPDHCWL($j)
    d OutDataToEnsemble^DHCWLToWangHai(SDate,EDate)

    s len=$l(^TEMPDHCWL($j,0),"^")
    s num=""
    f  s num=$o(^TEMPDHCWL($j,num)) q:num=""  d
    .f i=2:1:len d
    ..s type=$p(^TEMPDHCWL($j,0),"^",i)
    ..s fee=$p(^TEMPDHCWL($j,num),"^",i)

    ..d OutputRow27
 	q $$$OK	
OutputRow27
   
    s Data=$lb(type,fee)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetJCPTDzFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetJCPTDzExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetJCPTDzClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetJCPTDzExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetJCPTDz(SDate As %String, EDate As %String) As %Query(ROWSPEC = "type:%String,fee:%String") [ SqlProc ]
{
}

// 在院患者费用核对(DHC_PatientBill和DHC_workload)

// d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL","GetIPatFeeHd","2012-01-28","2013-01-08")	

ClassMethod GetIPatFeeHdExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    
    k ^temp($j)
    i SDate'="" d
	.s ADMRowID=0,WLRowid=0,PBRowid=0
	.f  s ADMRowID=$o(^PAADMi("PAADM_VisitStatus","A",ADMRowID)) q:ADMRowID=""  d
	..s PAADMType=$p(^PAADM(ADMRowID),"^",2) q:PAADMType'="I"
    ..s chrDate=$p(^PAADM(ADMRowID),"^",17) q:chrDate'=""
	..s iPatNo=$p(^PAADM(ADMRowID),"^",1) //PA_PatMas.PAPMI_RowId
	..f  s WLRowid=$o(^DHCWorkLoad(0,"PAADM",ADMRowID,WLRowid)) q:WLRowid=""  d
    ...s WFee=$p(^DHCWorkLoad(WLRowid),"^",16)    ;该医嘱发生的费用
    ...s WLId=$p(^DHCWorkLoad(WLRowid),"^",20)    ;该医嘱发生的账单号
    ...q:$d(^DHCBillCancelOld(+$h,WLId)) ;撤销中结
    ...q:$d(^DHCBILLDEL(+$h,WLId)) ;撤销中结
    ...s ^temp($j,iPatNo,ADMRowID,WLId,"WlR")=$g(^temp($j,iPatNo,ADMRowID,WLId,"WlR"))+WFee 
    ..f  s PBRowid=$o(^DHCPB(0,"ADM",ADMRowID,PBRowid)) q:PBRowid=""  d
    ...s PFee=$p(^DHCPB(PBRowid),"^",8)    ;该医嘱发生的账单费用
    ...s ^temp($j,iPatNo,ADMRowID,PBRowid,"PBR")=$g(^temp($j,iPatNo,ADMRowID,PBRowid,"PBR"))+PFee 
    
    s iPatNo=0 f  s iPatNo=$o(^temp($j,iPatNo)) q:iPatNo=""  d
    .s ADMRowID=0 f  s ADMRowID=$o(^temp($j,iPatNo,ADMRowID)) q:ADMRowID=""  d
    ..s WLId=0 f  s WLId=$o(^temp($j,iPatNo,ADMRowID,WLId)) q:WLId=""  d
    ...s Wlfee=$g(^temp($j,iPatNo,ADMRowID,WLId,"WlR"))
    ...s PBfee=$g(^temp($j,iPatNo,ADMRowID,WLId,"PBR"))
    ...i ((Wlfee'="")&&(PBfee="")&&(Wlfee'=0))  d
    ....d OutputRow121
    k ^temp($j)
 	q $$$OK	

OutputRow121
    
   	s name=$$GetPapmiName^DHCWLCommon(iPatNo)  //通过PA_PatMas.PAPMI_RowId得到病人姓名
   	s ybtype=$$GetReason^DHCWLCommon(ADMRowID)   //通过PA_Adm.PAADM_RowID获得病人的人员类别
    s zyh=$$GetPapmiMedtare^DHCWLCommon(iPatNo)  //通过PA_PatMas.PAPMI_RowId得到病人住院号
    s ADMDate=$p(^PAADM(ADMRowID),"^",6) //入院日期
	s:ADMDate'="" ADMDate=$zd(ADMDate,3)
	s CyDate="" //出院日期
	
	s DischgDate=""
	
    s DepID=$p(^PAADM(ADMRowID),"^",4) //
	i (DepID="")    d
	.s Depcode=""
	.s DepDesc=""
	e            d
	.i ('$d(^CTLOC(DepID)))  d
	..s Depcode=""
	..s DepDesc=""
	.e    d
	..s Depcode=$p(^CTLOC(DepID),"^",1) //科室编号
	..s DepDesc1=$p(^CTLOC(DepID),"^",2) //科室
	..i DepDesc1 [ "-" s DepDesc=$p(DepDesc1,"-",2)
   
	s RoomID=""
	s RoomID=$p(^PAADM(ADMRowID),"^",69) //病房
	i (RoomID="") d
	.s RoomCode="" 
	.s RoomDesc="" 
	e        d
	.i $d(^PAROOM(RoomID))   d
	..s RoomCode=$p(^PAROOM(RoomID),"^",1)
	..s RoomDesc=$p(^PAROOM(RoomID),"^",2)
	.e  s RoomCode="",RoomDesc=""
	s WardID=$p(^PAADM(ADMRowID),"^",70) //病区
	i (WardID="") d
	.s WardCode="" 
	.s WardDesc="" 
	e          d
	.i ('$d(^PAWARD(WardID)))    d
	..s WardCode=""
	..s WardDesc=""
	.e       d
	..s WardCode=$p(^PAWARD(WardID),"^",1)
	..s WardDesc1=$p(^PAWARD(WardID),"^",2)
	..i WardDesc1 [ "-" s WardDesc=$p(WardDesc1,"-",2)
	s BedID=$p(^PAADM(ADMRowID),"^",73) //床位
	s BedRowid=$P(BedID,"||",1)
    s BedSub=$P(BedID,"||",2)
	i (BedID="")!(WardID="") d
	.s BedCode=""
	e       d
	.i ('$d(^PAWARD(WardID,"BED",BedSub)))  d
	..s BedCode=""   d
	.e        d
    ..s BedCode=$P($G(^PAWARD(WardID,"BED",BedSub)),"^",1) 
    
    s Data=$lb(zyh,name,ybtype,DepDesc,WardDesc,BedCode,ADMDate,CyDate,DischgDate,WLId,ADMRowID,$fn(Wlfee,"",2),$fn(PBfee,"",2))
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetIPatFeeHdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIPatFeeHdExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetIPatFeeHdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIPatFeeHdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetIPatFeeHd(SDate As %String, EDate As %String) As %Query(ROWSPEC = "zyh:%String,name:%String,ybtype:%String,DepDesc:%String,WardDesc:%String,BedCode:%String,ADMDate:%String,CyDate:%String,DischgDate:%String,WLId:%Integer,ADMRowID:%Integer,WLfee:%Float,PBfee:%Float") [ SqlProc ]
{
}

// 账单对比

// d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL","GetPatBill","40937")

ClassMethod GetPatBillExecute(ByRef qHandle As %Binary, ADMRowID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    
    k ^temp($j)
    s WLRowid=0,PBRowid=0
	f  s WLRowid=$o(^DHCWorkLoad(0,"PAADM",ADMRowID,WLRowid)) q:WLRowid=""  d
    .s WFee=$p(^DHCWorkLoad(WLRowid),"^",16)    ;该医嘱发生的费用
    .s WLId=$p(^DHCWorkLoad(WLRowid),"^",20)    ;该医嘱发生的账单号
    .s ^temp($j,WLId,"WlR")=$g(^temp($j,WLId,"WlR"))+WFee 
    f  s PBRowid=$o(^DHCPB(0,"ADM",ADMRowID,PBRowid)) q:PBRowid=""  d
    .s PFee=$p(^DHCPB(PBRowid),"^",8)    ;该医嘱发生的账单费用
    .s ^temp($j,PBRowid,"PBR")=$g(^temp($j,PBRowid ,"PBR"))+PFee 
    
    s Bill=0 f  s Bill=$o(^temp($j,Bill)) q:Bill=""  d
    .s outdata=$g(^temp($j,Bill,"WlR"))_"^"_$g(^temp($j,Bill,"PBR"))
    .s Wlfee=$p(outdata,"^",1)  
    .s PBfee=$p(outdata,"^",2)  
    .d OutputRow122
    k ^temp($j)
 	q $$$OK	

OutputRow122
    
    s Data=$lb(Bill,$fn(Wlfee,"",2),$fn(PBfee,"",2))
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetPatBillFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatBillExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPatBillClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatBillExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetPatBill(ADMRowID As %String) As %Query(ROWSPEC = "Bill:%Integer,WLfee:%Float,PBfee:%Float") [ SqlProc ]
{
}

// 预约挂号报表

// d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL","GetYYGHRp","2012-09-27","2012-09-27")	

ClassMethod GetYYGHRpExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
   
    q:SDate="" $$$OK
 	q:EDate="" $$$OK
    s num=1
    k mPLIST
	s outdata=$$MainQuery^DHCWLResAdmApp(SDate,EDate)
    f num=1:1:outdata-1 d
    .s data1=$p(mPLIST(num),"^",1) 
    .s data2=$p(mPLIST(num),"^",2)
    .s data3=$p(mPLIST(num),"^",3)
    .s data4=$p(mPLIST(num),"^",4)
    .s data5=$p(mPLIST(num),"^",5)
    .s data6=$p(mPLIST(num),"^",6)
    .s data7=$p(mPLIST(num),"^",7)
    .s data8=$p(mPLIST(num),"^",8)
    .s data9=$p(mPLIST(num),"^",9)
    .s data10=$p(mPLIST(num),"^",10)
    .s data11=$p(mPLIST(num),"^",11)
    .s data12=$p(mPLIST(num),"^",12)
    .s data13=$p(mPLIST(num),"^",13)
    .s data14=$p(mPLIST(num),"^",14)
    .s data15=$p(mPLIST(num),"^",15)
    .s data16=$p(mPLIST(num),"^",16)
    .s data17=$p(mPLIST(num),"^",17)
    .s data18=$p(mPLIST(num),"^",18)
    .s data19=$p(mPLIST(num),"^",19)
    .s data20=$p(mPLIST(num),"^",20)
    .s data21=$p(mPLIST(num),"^",21)
    .s data22=$p(mPLIST(num),"^",22)
    .s data23=$p(mPLIST(num),"^",23)
    .s data24=$p(mPLIST(num),"^",24)
    .s data25=$p(mPLIST(num),"^",25)
    .s data26=$p(mPLIST(num),"^",26)
    .s data27=$p(mPLIST(num),"^",27)
    .s data28=$p(mPLIST(num),"^",28)
    .s data29=$p(mPLIST(num),"^",29)
    .s data30=$p(mPLIST(num),"^",30)
    .s data31=$p(mPLIST(num),"^",31)
    .s data32=$p(mPLIST(num),"^",32)
 
    .d OutputRow32
 	q $$$OK	
OutputRow32
  
    s Data=$lb(data1,data2,data3,data4,data5,data6,data7,data8,data9,data10,data11,data12,data13,data14,data15,data16,data17,data18,data19,data20,data21,data22,data23,data24,data25,data26,data27,data28,data29,data30,data31,data32)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetYYGHRpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetYYGHRpExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetYYGHRpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetYYGHRpExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetYYGHRp(SDate As %String, EDate As %String) As %Query(ROWSPEC = "data1:%Integer,data2:%String,data3:%String,data4:%Float,data5:%Float,data6:%Float,data7:%Float,data8:%Float,data9:%Float,data10:%Float,data11:%Float,data12:%Float,data13:%Float,data14:%Float,data15:%Float,data16:%Float,data17:%Float,data18:%Float,data19:%Float,data20:%Float,data21:%Float,data22:%Float,data23:%Float,data24:%Float,data25:%Float,data26:%Float,data27:%Float,data28:%Float,data29:%Float,data30:%Float,data31:%Float,data32:%Float") [ SqlProc ]
{
}

}
