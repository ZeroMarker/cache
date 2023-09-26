Class DHCWL.Stat.Service Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：      ycm
/// CreatDate：    2017-12-28
/// Description:   统计室系统手术模块中手术指标的封装函数
/// Table：       
/// Input：        rptId:手术指标选择,startDate:开始日期,endDate:结束日期,PatTypeList:病人类型,HospList:院区,REAList:患者身份,isGrpLoc:是否科室归组
/// Output：  
/// Return：      
/// Others：   	   rptId:手术指标选择,具有维度一致性,如：<病人类型,病人科室,病人病区,病人身份>
///                isGrpLoc:Loc:科室,Ward:病区,PatType:就诊类型,REA:病人身份,OpGrpLoc:科室组
///                为提供输出效率,不涉及日期的时候：mode="CS"
///                默认手术科室归组：OpGrpLoc
/// d ##class(%ResultSet).RunQuery("DHCWL.Stat.Service","GetOpKpiData","1","2017-12-01","2017-12-01","I,O,E,H","","","OpGrpLoc")
Query GetOpKpiData(rptId As %Text, startDate As %String, endDate As %String, PatTypeList As %String = "", HospList As %String = "", REAList As %Text = "", isGrpLoc As %String = "", dateType As %String = "", mode As %String = "", contractType As %String = "", filterRule As %Text = "") As %Query(ROWSPEC = "monthId,contractTye,monDesc,kpiId,kpiCode,kpiDesc,dimId,dimDesc,value:%Float,remark") [ SqlProc ]
{
}

ClassMethod GetOpKpiDataExecute(ByRef qHandle As %Binary, rptId As %Text, startDate As %String, endDate As %String, PatTypeList As %String = "", HospList As %String = "", REAList As %Text = "", isGrpLoc As %String = "", dateType As %String = "", mode As %String = "", contractType As %String = "", filterRule As %Text = "") As %Status
{
	n (qHandle,rptId,startDate,endDate,PatTypeList,HospList,REAList,isGrpLoc,dateType,mode,contractType,filterRule)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    ;;s ^yu($H)=rptId_"||"_startDate_"||"_endDate_"||"_PatTypeList_"||"_HospList_"||"_REAList_"||"_isGrpLoc_"||"_dateType_"||"_mode_"||"_contractType_"||"_filterRule
    quit:(rptId="")||(startDate="")||(endDate="") $$$OK
    
    k ^TEMPDHCWL($j)
    k ^TEMPDHCWL("S",$j)   ///过滤临时global
    
    s kpiCode=##Class(DHCWL.Stat.Service).GetkpiCode(rptId)   ///选择指标串
    
    quit:kpiCode="" $$$OK
    
    ///拆分过滤条件
    d ##Class(DHCWL.Stat.Common).split(PatTypeList,",","PatType")
    d ##Class(DHCWL.Stat.Common).split(HospList,",","Hosp")
    d ##Class(DHCWL.Stat.Common).split(REAList,",","REA")
    
    
    Set count=0
    Set rset = ##class(%ResultSet).%New()
 	Set rset.ClassName = "DHCWL.MKPIService.MKPIQuery"
 	Set rset.QueryName = "QueryKpiWithContract"
 	d rset.Execute(kpiCode,startDate,endDate,dateType,mode,contractType,filterRule)
 	While (rset.Next(.sc)) 
 	{
 	   If ($SYSTEM.Status.IsOK(sc))
         {
               s monthId=rset.Data("monthId")
	 		   s contractTye=rset.Data("contractTye")
	 		   s monDesc=rset.Data("monDesc")
	 		   s kpiId=rset.Data("kpiId")
               s kpiCode=rset.Data("kpiCode")
	 		   s kpiDesc=rset.Data("kpiDesc")
	 		   s dimId=rset.Data("dimId")
               s dimDesc=rset.Data("dimDesc")
	 		   s value=rset.Data("value")
	 		   s count=count+1
	 		   s ^TEMPDHCWL($j,"count",count)=monthId_"^"_contractTye_"^"_monDesc_"^"_kpiId_"^"_kpiCode_"^"_kpiDesc_"^"_dimId_"^"_dimDesc_"^"_value
         }
 	}
	Do rset.Close()
	
	s count=""
	f  s count=$O(^TEMPDHCWL($j,"count",count)) q:count=""  d
 	.s ret=$g(^TEMPDHCWL($j,"count",count))
 	.s monthId=$P(ret,"^",1)
 	.s contractTye=$P(ret,"^",2)
 	.s monDesc=$P(ret,"^",3)
 	.s kpiId=$P(ret,"^",4)
 	.s kpiCode=$P(ret,"^",5)
 	.s kpiDesc=$P(ret,"^",6)
 	.s dimId=$P(ret,"^",7)
 	.s dimDesc=$P(ret,"^",8)
 	.s value=$P(ret,"^",9)
 	.s flag=0
 	.s flag=..Getfilter()  ///过滤规则
 	.q:+flag=1
 	.s remark=..GetRemark()  ///取备注信息    
    .s Data=$lb(monthId,contractTye,monDesc,kpiId,kpiCode,kpiDesc,dimId,dimDesc,value,remark)
    .i ind="" s ind=1
    .s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
 	.q
 	
    k ^TEMPDHCWL($j)
    k ^TEMPDHCWL("S",$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod GetOpKpiDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOpKpiDataExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetOpKpiDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOpKpiDataExecute ]
{
	n (qHandle,Row,AtEnd)
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

/// 根据rptId的值获取指标Code
ClassMethod GetkpiCode(rptId As %String) As %String
{
	n (rptId)
	s kpiCode=""
	
	i +rptId=1 s kpiCode="SK0156,SK0171,SK0172"   ///科室手术工作量
	
	i +rptId=2 s kpiCode="SK0157,SK0158,SK0159"  ///医生手术工作量
	
	i +rptId=3 s kpiCode="SK0160,SK0161"   ///护士手术工作量
	
	i +rptId=4 s kpiCode="SK0162"          ///主麻醉工作量
	
	i +rptId=5 s kpiCode="SK0163"          ///手术级别、手术名称
	
	i +rptId=6 s kpiCode="SK0164"     ///手术费用
	
	i +rptId=7 s kpiCode="SK0173"          ///全部麻醉工作量
	
	
	q kpiCode
}

/// 过滤判断 ,0:不过滤,1:过滤
ClassMethod Getfilter() As %String
{
	s isfilter=0

	i +rptId<8 d
	.s PatType=$P(dimId,",",1)
	.s LocId=$P(dimId,",",2)
	.s REARowid=$P(dimId,",",4)
	.i $d(^TEMPDHCWL("S",$j,"PatType"))  d
	..q:$d(^TEMPDHCWL("S",$j,"PatType",PatType))
	..s isfilter=1
	.i $d(^TEMPDHCWL("S",$j,"Hosp"))  d
	..s HospId=$P($g(^CTLOC(+LocId)),"^",22)
	..q:$d(^TEMPDHCWL("S",$j,"Hosp",+HospId))
	..s isfilter=1
	.i $d(^TEMPDHCWL("S",$j,"REA"))  d
	..q:$d(^TEMPDHCWL("S",$j,"REA",+REARowid))
	..s isfilter=1
	
	q isfilter
}

/// 取备注信息
ClassMethod GetRemark() As %String
{
	s remark=""
	
	i (+rptId=1)||(+rptId=4)||(+rptId=5)||(+rptId=6)||(+rptId=7) d
	.i isGrpLoc="PatType" s remark=$P(dimDesc,",",1)
	.i isGrpLoc="Loc" s remark=$P(dimDesc,",",2)
	.i isGrpLoc="Ward" s remark=$P(dimDesc,",",3)
	.i isGrpLoc="REA" s remark=$P(dimDesc,",",4)
	.i isGrpLoc="OpGrpLoc" d
	..s LocId=$P(dimId,",",2)
	..s ret=##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpByItemDr(LocId,"OpGrpLoc","")  
	..s remark=$P(ret,"^",1)
	..s remark=$tr(remark,"NULL","Null")
	
	q remark
}

/// Creator：      ycm
/// CreatDate：    2017-12-28
/// Description:   统计室系统手术模块中手术病人明细查询
/// Table：       
/// Input：        startDate:开始日期,endDate:结束日期,PatTypeList:病人类型,HospList:院区,REAList:患者身份,PatDepList:病人科室
/// Output：  
/// Return：      
/// Others：   	   
/// d ##class(%ResultSet).RunQuery("DHCWL.Stat.Service","GetOpPatDetails","2017-12-01","2017-12-01","I,O,E,H","","","")
Query GetOpPatDetails(startDate As %String, endDate As %String, PatTypeList As %String = "", HospList As %String = "", REAList As %Text = "", PatDepList As %Text = "") As %Query(ROWSPEC = "PatDepdr,PatDepDesc,PatWardDesc,Admid,PatName,PatNo,PatId,PatSex,PatAge,READesc,OpName,OperDocDr,OperDocDesc,AssistDocDesc1,AssistDocDesc2,CirNursedDesc,ScrNursedDesc,AnaMethodDesc,AnDocDesc,OpLevel,OpDate,SourceType") [ SqlProc ]
{
}

ClassMethod GetOpPatDetailsExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, PatTypeList As %String = "", HospList As %String = "", REAList As %Text = "", PatDepList As %Text = "") As %Status
{
	n (qHandle,startDate,endDate,PatTypeList,HospList,REAList,PatDepList)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    q:(startDate="")||(endDate="") $$$OK
    
    k ^TEMPDHCWL($j)
    k ^TEMPDHCWL("S",$j)   ///过滤临时global
    
    ///拆分过滤条件
    d ##Class(DHCWL.Stat.Common).split(PatTypeList,",","PatType")
    d ##Class(DHCWL.Stat.Common).split(HospList,",","Hosp")
    d ##Class(DHCWL.Stat.Common).split(REAList,",","REA")
    d ##Class(DHCWL.Stat.Common).split(PatDepList,",","PatDep")

    s startDate=$ZDH(startDate,3)
    s endDate=$ZDH(endDate,3)
    
    f day=startDate:1:endDate d 
	.s WLANRowid=0 f  s WLANRowid=$o(^DHCWLAnaesthesia(0,"STATDATE",day,WLANRowid)) q:WLANRowid=""  d
    ..s PatDepdr=$p(^DHCWLAnaesthesia(WLANRowid),"^",5)       	///病人科室
    ..q:(PatDepList'="")&&('$d(^TEMPDHCWL("S",$j,"PatDep",+PatDepdr)))
    ..s PatWardr=$p(^DHCWLAnaesthesia(WLANRowid),"^",6)       	///病人病区
    ..s HospId=$P($g(^CTLOC(+PatDepdr)),"^",22)
    ..q:(HospList'="")&&('$d(^TEMPDHCWL("S",$j,"Hosp",+HospId)))
	..s OPARowid=$p(^DHCWLAnaesthesia(WLANRowid),"^",66)        /// DHC_AN_OPArrange
	..s Anaestdr=$p(^DHCANOPArrange(OPARowid),"^",2)
 	..s Admid=$p(Anaestdr,"||",1)
 	..s AnSubDr=$p(Anaestdr,"||",2)
	..s PatType=$P(^PAADM(Admid),"^",2)
    ..q:(PatTypeList'="")&&('$d(^TEMPDHCWL("S",$j,"PatType",PatType)))
    ..s REARowid=$P(^PAADM(Admid,1),"^",7)
    ..q:(REAList'="")&&('$d(^TEMPDHCWL("S",$j,"REA",+REARowid)))
    ..s OPLevelDr=$p(^DHCWLAnaesthesia(WLANRowid),"^",72)    	///手术级别
    ..s AnaestMethodDr=$p(^DHCWLAnaesthesia(WLANRowid),"^",8)   ///麻醉方式
	..s OPERRowid=$p(^DHCWLAnaesthesia(WLANRowid),"^",42)       ///手术姓名
	..s OpName=$p(^ORC("OPER",OPERRowid),"^",2)
	..s OperDocDr=$p(^DHCWLAnaesthesia(WLANRowid),"^",50)    ;主刀医生  	    
	..s AssistDocdr1=$p(^DHCWLAnaesthesia(WLANRowid),"^",52)    ;手术助理1 
    ..s AssistDocdr2=$p(^DHCWLAnaesthesia(WLANRowid),"^",53)    ;手术助理2 
    ..s CirNursedr1=$p(^DHCWLAnaesthesia(WLANRowid),"^",58)    ;巡回护士
    ..s CirNursedr2=$p(^DHCWLAnaesthesia(WLANRowid),"^",59)    ;巡回护士
    ..s ScrNursedr1=$p(^DHCWLAnaesthesia(WLANRowid),"^",60)    ;器械护士 
    ..s ScrNursedr2=$p(^DHCWLAnaesthesia(WLANRowid),"^",61)    ;器械护士 
    ..s AnDoc=+$p(^DHCWLAnaesthesia(WLANRowid),"^",9)     ;麻醉医生1
    ..s AnDoc1=+$p(^DHCWLAnaesthesia(WLANRowid),"^",55)   ;麻醉医生2
	..
 	..s OperSTime=$p(^OR(Admid,"ANA",AnSubDr),"^",40)
 	..s OperSDay=$p(^OR(Admid,"ANA",AnSubDr),"^",39)
 	..s SourceType=$p(^OR(Admid,"ANA",AnSubDr),"^",32)   ///急诊择期
 	../// 麻醉方式修改
 	..s AnaestMethodDr=$P(^OR(Admid,"ANA",AnSubDr),"^",5)
 	..s AnaMethodDesc=""
 	..f i=1:1:$l(AnaestMethodDr,"|") d
 	...s AnaMethodId=$P(AnaestMethodDr,"|",i)
 	...q:+AnaMethodId=0
 	...s MethodDesc=$P($g(^ORC("ANMET",+AnaMethodId)),"^",2)
 	...s AnaMethodDesc=AnaMethodDesc_" "_MethodDesc
	..
 	../// end 
 	..s PatDepDesc=##Class(DHCWL.Stat.Common).GetLocDesc(PatDepdr)
 	..s PatWardDesc=##Class(DHCWL.Stat.Common).GetLocDesc(PatWardr)
 	..s OperDocDesc=##Class(DHCWL.Stat.Common).GetCTPCPDesc(OperDocDr)
 	..s AssistDocDesc1=##Class(DHCWL.Stat.Common).GetCTPCPDesc(AssistDocdr1)
 	..s AssistDocDesc2=##Class(DHCWL.Stat.Common).GetCTPCPDesc(AssistDocdr2)
 	..s CirNursedDesc1=##Class(DHCWL.Stat.Common).GetCTPCPDesc(CirNursedr1)
 	..s CirNursedDesc2=##Class(DHCWL.Stat.Common).GetCTPCPDesc(CirNursedr2)
 	..s CirNursedDesc=CirNursedDesc1_" "_CirNursedDesc2
 	..s ScrNursedDesc1=##Class(DHCWL.Stat.Common).GetCTPCPDesc(ScrNursedr1)
 	..s ScrNursedDesc2=##Class(DHCWL.Stat.Common).GetCTPCPDesc(ScrNursedr2)
 	..s ScrNursedDesc=ScrNursedDesc1_" "_ScrNursedDesc2
 	..s AnDocDesc1=##Class(DHCWL.Stat.Common).GetCTPCPDesc(AnDoc)
 	..s AnDocDesc2=##Class(DHCWL.Stat.Common).GetCTPCPDesc(AnDoc1)
 	..;s AnDocDesc=AnDocDesc1_" "_AnDocDesc2
 	..s AnDocDesc=AnDocDesc1
 	..s Papmidr=$P(^PAADM(Admid),"^",1)
 	..s PatName=$$GetPapmiName^DHCWLCommon(Papmidr)
 	..s PatNo=$$GetPapmiNo^DHCWLCommon(Papmidr)
 	..s PatId=##class(web.DHCWLStatisticsInterface).GetMedNoByAdm(Admid)
 	..s PatSex=$$GetSex^DHCWLCommon(Papmidr)
 	..;s PatAge=$$GetAge^DHCWLCommon(Papmidr)
 	..s PatAge=##class(web.DHCBillInterface).GetPapmiAge(Papmidr,Admid)
 	..s READesc=$$GetReason^DHCWLCommon(Admid)
 	..s SourceType=$Case(SourceType,"E":"急诊","B":"择期",:"")
 	..s OpLevel=$p($g(^ORC("CATEG",+OPLevelDr)),"^",2) 
 	..s OpDate=$ZD(day,3)
 	..s Data=$lb(PatDepdr,PatDepDesc,PatWardDesc,Admid,PatName,PatNo,PatId,PatSex,PatAge,READesc,OpName,OperDocDr,OperDocDesc,AssistDocDesc1,AssistDocDesc2,CirNursedDesc,ScrNursedDesc,AnaMethodDesc,AnDocDesc,OpLevel,OpDate,SourceType)
    ..s ^CacheTemp(repid,ind)=Data
 	..s ind=ind+1
	..q
 
    k ^TEMPDHCWL($j)
    k ^TEMPDHCWL("S",$j)   
    
    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
}

ClassMethod GetOpPatDetailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOpPatDetailsExecute ]
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

ClassMethod GetOpPatDetailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOpPatDetailsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
