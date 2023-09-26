Class DHCWL.DM.I.RaqService Extends %RegisteredObject
{

// d ##class(DHCWL.DM.I.RaqService).Test()

ClassMethod Test()
{
	s cql="rs1:{"_
        "from: /workload.t,"_
        "dims :WorkLoad_Type,WorkLoad_RecDep_DR->LocCode,WorkLoad_PAPMI_DR,WorkLoad_PAPMI_DR->PAPMI_Name as Name,"_
        "metrics: sum(WorkLoad_TotalPrice) price,sum(WorkLoad_TotalPrice) ON (WorkLoad_Type) As AdmSumPrice,sum(WorkLoad_TotalPrice) ON (null) allPrice,"_
        "filter:  WorkLoad_OrdDate between(2018-03-23,2018-03-23) ,"_  // &&  WorkLoad_Type contain([O]) && WorkLoad_PAPMI_DR >= (4) && WorkLoad_PAPMI_DR <= (88) 
        "print:true,"_
      "};"
    ;s cql=^lhh
    s cql="rs1:{from: /DW/DHCWorkLoad.t , dims: AdmType AS AdmType,PatDep->CTD_Code AS dim2,PatDep->CTD_Desc AS dim3,PatDoc AS PatDoc , metrics: sum(TotleFee) AS test2 , filter: OrdDate between(2016-06-22,2016-06-22) && AdmType =(I)}"
    s cql="rs0:{from: /DW/DHCWorkLoad.t , dims: AdmType AS 就诊类型,PatDep->CTD_Desc AS 科室,TecSubCat->CTEMCCC_Desc AS 核算子类,TecCat->CTEMCC_Desc AS 核算大类 , metrics: sum(TotleFee) AS 总费用 , filter: OrdDate->M_DAY_CODE between(,) && AdmType =(O,E,I,H)}"
    s cql="rs0:{from: /DW/DHCWorkLoad.t , dims: PatDep->CTD_Code AS dim1 , metrics: sum(TotleFee) AS N020001,sum(TotleFee) AS S0010001,sum(Quantity) AS S0010005 , filter: OrdDate->M_DAY_CODE between(2016-06-01,2016-07-01) && PatDepHos->CTH_Code =('BFCode||2','BFCode||3') && PatDep->CTD_Code =('BFCode||1','BFCode||2','BFCode||3','BFCode||4','BFCode||5','BFCode||6','BFCode||7','BFCode||8','BFCode||9','BFCode||10','BFCode||11','BFCode||12','BFCode||13','BFCode||14','BFCode||15','BFCode||16','BFCode||17','BFCode||18','BFCode||19','BFCode||20','BFCode||21','BFCode||22','BFCode||23','BFCode||24','BFCode||25','BFCode||26','BFCode||27','BFCode||28','BFCode||29','BFCode||30','BFCode||31','BFCode||32','BFCode||33','BFCode||34','BFCode||35','BFCode||36','BFCode||37','BFCode||38','BFCode||39','BFCode||40','BFCode||41','BFCode||42','BFCode||43','BFCode||44','BFCode||45','BFCode||46','BFCode||47','BFCode||48','BFCode||49','BFCode||50','BFCode||51','BFCode||52','BFCode||53','BFCode||54','BFCode||55','BFCode||56','BFCode||57','BFCode||58','BFCode||59','BFCode||60','BFCode||61','BFCode||62','BFCode||63','BFCode||64','BFCode||65','BFCode||66','BFCode||67','BFCode||68','BFCode||69','BFCode||70','BFCode||71','BFCode||72','BFCode||73','BFCode||74','BFCode||75','BFCode||76','BFCode||77','BFCode||78','BFCode||79','BFCode||80','BFCode||81','BFCode||82','BFCode||83','BFCode||84','BFCode||85','BFCode||86','BFCode||87','BFCode||88','BFCode||89','BFCode||90','BFCode||91','BFCode||92','BFCode||93','BFCode||94','BFCode||95','BFCode||96','BFCode||97','BFCode||98','BFCode||99','BFCode||100','BFCode||101','BFCode||102','BFCode||103','BFCode||104','BFCode||105','BFCode||106','BFCode||107','BFCode||108','BFCode||109','BFCode||110','BFCode||111','BFCode||112','BFCode||113','BFCode||114','BFCode||115','BFCode||116','BFCode||117','BFCode||118','BFCode||119','BFCode||120','BFCode||121','BFCode||122','BFCode||123','BFCode||124','BFCode||125','BFCode||126','BFCode||127','BFCode||128','BFCode||129','BFCode||130','BFCode||131','BFCode||132','BFCode||133','BFCode||134','BFCode||136','BFCode||137','BFCode||138','BFCode||139','BFCode||140','BFCode||141','BFCode||142','BFCode||143','BFCode||144','BFCode||145','BFCode||146','BFCode||147','BFCode||148','BFCode||149','BFCode||150','BFCode||151','BFCode||152','BFCode||153','BFCode||154','BFCode||159','BFCode||161','BFCode||162','BFCode||163','BFCode||164','BFCode||165','BFCode||166','BFCode||167','BFCode||168','BFCode||169','BFCode||170','BFCode||171','BFCode||172','BFCode||173','BFCode||174','BFCode||175','BFCode||176','BFCode||177','BFCode||178','BFCode||179','BFCode||181','BFCode||182','BFCode||183','BFCode||184','BFCode||185','BFCode||186','BFCode||187','BFCode||188','BFCode||189','BFCode||190','BFCode||191','BFCode||192','BFCode||193','BFCode||194','BFCode||195','BFCode||196','BFCode||197','BFCode||198','BFCode||199','BFCode||200','BFCode||201','BFCode||202','BFCode||203','BFCode||204','BFCode||205','BFCode||206','BFCode||207','BFCode||208','BFCode||209','BFCode||210','BFCode||211','BFCode||212','BFCode||213','BFCode||214','BFCode||215','BFCode||216','BFCode||217','BFCode||218','BFCode||219','BFCode||220','BFCode||221','BFCode||222','BFCode||223','BFCode||224','BFCode||225','BFCode||226','BFCode||227','BFCode||228','BFCode||229','BFCode||230','BFCode||231','BFCode||232','BFCode||233','BFCode||234','BFCode||235','BFCode||236','BFCode||237','BFCode||238','BFCode||239','BFCode||240','BFCode||241','BFCode||242','BFCode||243','BFCode||244','BFCode||245','BFCode||246','BFCode||247','BFCode||248','BFCode||249','BFCode||250','BFCode||251','BFCode||252','BFCode||254','BFCode||255','BFCode||256','BFCode||258','BFCode||259','BFCode||260','BFCode||261','BFCode||262','BFCode||263','BFCode||264','BFCode||265','BFCode||266','BFCode||267','BFCode||268','BFCode||269','BFCode||270','BFCode||271','BFCode||272','BFCode||273','BFCode||274','BFCode||275','BFCode||276','BFCode||277','BFCode||278','BFCode||279','BFCode||280','BFCode||281','BFCode||282','BFCode||283','BFCode||284','BFCode||285','BFCode||289','BFCode||290','BFCode||291','BFCode||293','BFCode||303','BFCode||305','BFCode||307','BFCode||312','BFCode||313','BFCode||315','BFCode||328','BFCode||329','BFCode||330','BFCode||331','BFCode||332','BFCode||336','BFCode||337','BFCode||338','BFCode||339','BFCode||340','BFCode||342','BFCode||344','BFCode||345','BFCode||347','BFCode||348','BFCode||349','BFCode||350','BFCode||351','BFCode||352','BFCode||354','BFCode||355','BFCode||356','BFCode||357','BFCode||358','BFCode||359','BFCode||360','BFCode||361','BFCode||363','BFCode||364','BFCode||366','BFCode||367','BFCode||369','BFCode||370','BFCode||371','BFCode||372','BFCode||373','BFCode||374','BFCode||375','BFCode||376','BFCode||377','BFCode||378','BFCode||379','BFCode||380','BFCode||381','BFCode||382','BFCode||383','BFCode||384','BFCode||385','BFCode||387','BFCode||390','BFCode||391','BFCode||392','BFCode||393','BFCode||394','BFCode||396','BFCode||397','BFCode||398','BFCode||399','BFCode||400','BFCode||401','BFCode||402','BFCode||405','BFCode||408','BFCode||411','BFCode||412','BFCode||424','BFCode||425','BFCode||426','BFCode||427','BFCode||428','BFCode||429','BFCode||430','BFCode||434','BFCode||436')}"
    s cql="rs0:{from: /DW/DHCWorkLoad.t , dims: PatDepHos->CTH_Code AS dim1,AdmType AS 就诊类型,PatDep->CTD_Desc AS 科室,TecCat->CTEMCC_Desc AS 核算大类,TecSubCat->CTEMCCC_Code AS 核算子类,TecSubCat->Group(tarecGrp,desc) AS 核算子类分组 , metrics: sum(TotleFee) AS 总费用 , filter: OrdDate->M_DAY_CODE between(2016-01-01,2018-10-23) && PatDepHos->CTH_Code =('BFCode||2','BFCode||67','BFCode||16')}"
    s cql="rs1:{from: /DW/DHCWorkLoad.t , dims: PatDep->CTD_Code AS dim1 , metrics: sum(TotleFee) AS N020001,sum(TotleFee) AS S0010001,sum(Quantity) AS S0010005 , filter: OrdDate->M_DAY_CODE between(2016-06-01,2016-07-01) && AdmType =(I,O,E,H) && PatDepHos->CTH_Code =('BFCode||2','BFCode||3') && PatDep->CTD_Code =('BFCode||1','BFCode||2','BFCode||3','BFCode||4','BFCode||5','BFCode||6','BFCode||7','BFCode||8','BFCode||9','BFCode||10','BFCode||11','BFCode||12','BFCode||13','BFCode||14','BFCode||15','BFCode||16','BFCode||17','BFCode||18','BFCode||19','BFCode||20','BFCode||21','BFCode||22','BFCode||23','BFCode||24','BFCode||25','BFCode||26','BFCode||27','BFCode||28','BFCode||29','BFCode||30','BFCode||31','BFCode||32','BFCode||33','BFCode||34','BFCode||35','BFCode||36','BFCode||37','BFCode||38','BFCode||39','BFCode||40','BFCode||41','BFCode||42','BFCode||43','BFCode||44','BFCode||45','BFCode||46','BFCode||47','BFCode||48','BFCode||49','BFCode||50','BFCode||51','BFCode||52','BFCode||53','BFCode||54','BFCode||55','BFCode||56','BFCode||57','BFCode||58','BFCode||59','BFCode||60','BFCode||61','BFCode||62','BFCode||63','BFCode||64','BFCode||65','BFCode||66','BFCode||67','BFCode||68','BFCode||69','BFCode||70','BFCode||71','BFCode||72','BFCode||73','BFCode||74','BFCode||75','BFCode||76','BFCode||77','BFCode||78','BFCode||79','BFCode||80','BFCode||81','BFCode||82','BFCode||83','BFCode||84','BFCode||85','BFCode||86','BFCode||87','BFCode||88','BFCode||89','BFCode||90','BFCode||91','BFCode||92','BFCode||93','BFCode||94','BFCode||95','BFCode||96','BFCode||97','BFCode||98','BFCode||99','BFCode||100','BFCode||101','BFCode||102','BFCode||103','BFCode||104','BFCode||105','BFCode||106','BFCode||107','BFCode||108','BFCode||109','BFCode||110','BFCode||111','BFCode||112','BFCode||113','BFCode||114','BFCode||115','BFCode||116','BFCode||117','BFCode||118','BFCode||119','BFCode||120','BFCode||121','BFCode||122','BFCode||123','BFCode||124','BFCode||125','BFCode||126','BFCode||127','BFCode||128','BFCode||129','BFCode||130','BFCode||131','BFCode||132','BFCode||133','BFCode||134','BFCode||136','BFCode||137','BFCode||138','BFCode||139','BFCode||140','BFCode||141','BFCode||142','BFCode||143','BFCode||144','BFCode||145','BFCode||146','BFCode||147','BFCode||148','BFCode||149','BFCode||150','BFCode||151','BFCode||152','BFCode||153','BFCode||154','BFCode||159','BFCode||161','BFCode||162','BFCode||163','BFCode||164','BFCode||165','BFCode||166','BFCode||167','BFCode||168','BFCode||169','BFCode||170','BFCode||171','BFCode||172','BFCode||173','BFCode||174','BFCode||175','BFCode||176','BFCode||177','BFCode||178','BFCode||179','BFCode||181','BFCode||182','BFCode||183','BFCode||184','BFCode||185','BFCode||186','BFCode||187','BFCode||188','BFCode||189','BFCode||190','BFCode||191','BFCode||192','BFCode||193','BFCode||194','BFCode||195','BFCode||196','BFCode||197','BFCode||198','BFCode||199','BFCode||200','BFCode||201','BFCode||202','BFCode||203','BFCode||204','BFCode||205','BFCode||206','BFCode||207','BFCode||208','BFCode||209','BFCode||210','BFCode||211','BFCode||212','BFCode||213','BFCode||214','BFCode||215','BFCode||216','BFCode||217','BFCode||218','BFCode||219','BFCode||220','BFCode||221','BFCode||222','BFCode||223','BFCode||224','BFCode||225','BFCode||226','BFCode||227','BFCode||228','BFCode||229','BFCode||230','BFCode||231','BFCode||232','BFCode||233','BFCode||234','BFCode||235','BFCode||236','BFCode||237','BFCode||238','BFCode||239','BFCode||240','BFCode||241','BFCode||242','BFCode||243','BFCode||244','BFCode||245','BFCode||246','BFCode||247','BFCode||248','BFCode||249','BFCode||250','BFCode||251','BFCode||252','BFCode||254','BFCode||255','BFCode||256','BFCode||258','BFCode||259','BFCode||260','BFCode||261','BFCode||262','BFCode||263','BFCode||264','BFCode||265','BFCode||266','BFCode||267','BFCode||268','BFCode||269','BFCode||270','BFCode||271','BFCode||272','BFCode||273','BFCode||274','BFCode||275','BFCode||276','BFCode||277','BFCode||278','BFCode||279','BFCode||280','BFCode||281','BFCode||282','BFCode||283','BFCode||284','BFCode||285','BFCode||289','BFCode||290','BFCode||291','BFCode||293','BFCode||303','BFCode||305','BFCode||307','BFCode||312','BFCode||313','BFCode||315','BFCode||328','BFCode||329','BFCode||330','BFCode||331','BFCode||332','BFCode||336','BFCode||337','BFCode||338','BFCode||339','BFCode||340','BFCode||342','BFCode||344','BFCode||345','BFCode||347','BFCode||348','BFCode||349','BFCode||350','BFCode||351','BFCode||352','BFCode||354','BFCode||355','BFCode||356','BFCode||357','BFCode||358','BFCode||359','BFCode||360','BFCode||361','BFCode||363','BFCode||364','BFCode||366','BFCode||367','BFCode||369','BFCode||370','BFCode||371','BFCode||372','BFCode||373','BFCode||374','BFCode||375','BFCode||376','BFCode||377','BFCode||378','BFCode||379','BFCode||380','BFCode||381','BFCode||382','BFCode||383','BFCode||384','BFCode||385','BFCode||387','BFCode||390','BFCode||391','BFCode||392','BFCode||393','BFCode||394','BFCode||396','BFCode||397','BFCode||398','BFCode||399','BFCode||400','BFCode||401','BFCode||402','BFCode||405','BFCode||408','BFCode||411','BFCode||412','BFCode||424','BFCode||425','BFCode||426','BFCode||427','BFCode||428','BFCode||429','BFCode||430','BFCode||434','BFCode||436')}"
		d ##class(%ResultSet).RunQuery("DHCWL.DM.I.RaqService","CQLQuery",cql,"@#",1)
}

Query CQLQuery(cqlExpression As %Text(MAXLEN=10240), delimiter As %String = ",", retrieve As %Boolean = 1) As %Query(ROWSPEC = "ResultSetName:%String,dims:%String,metrics:%String") [ SqlProc ]
{
}

ClassMethod CQLQueryExecute(ByRef qHandle As %Binary, cqlExpression As %Text(MAXLEN=10240), delimiter As %String = ",", retrieve As %Boolean = 1) As %Status
{
	s ^lhhtest(1)=cqlExpression
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	try{
		s parserObj=##class(DHCWL.DM.Core.CQLParser).%New()
		s status=parserObj.Parse(cqlExpression)
		if (status'=$$$OK){
			d errorPrint
			Quit
		}
		d okPrint
		s executorObj=##class(DHCWL.DM.Core.PhysicalExecutor).%New(parserObj)
		s list=executorObj.GetIteratorList()
		s rs=$lg(list,1)
		s it=executorObj.GetIterator(rs)
		s dimList=it.GetDimMeta()
		s metricList=it.GetMetricMeta()
		s metaList=$lb(),metaListInd=1
		f i=1:1:$ll(dimList){
			s dim=$lg(dimList,i)
			s ty=it.GetDimDataType(dim)
			s $list(metaList,metaListInd)=dim
			s $list(metaList,metaListInd+1)=ty
			s metaListInd=metaListInd+2
		}
		f i=1:1:$ll(metricList){
			s metric=$lg(metricList,i)
			s ty=it.GetMetricDataType(metric)
			s $list(metaList,metaListInd)=metric
			s $list(metaList,metaListInd+1)=ty
			s metaListInd=metaListInd+2
		}
		s ^CacheTemp(repid,ind)=$lb(rs,$lts(metaList,delimiter,1),"")
		s ind=ind+1
		q:retrieve=0
		s status= executorObj.Execute()
		if (status'=$$$OK){
			s ind=1
			d errorPrint
			Quit
		}
		while(it.HasNext()){
			s ^CacheTemp(repid,ind)=$lb(rs,$lts(it.CurDims(),delimiter,1),$lts(it.CurMetrics(),delimiter,1))
			s ind=ind+1
		}
		d executorObj.Close()
	}catch(e){
		s status=$$$ERROR(e)
		s ind=1
		d errorPrint
	}
	
	Quit $$$OK
errorPrint
	do DecomposeStatus^%apiOBJ(status,.err,"-d")
	s errorInfo=""
	for i=1:1:err s errorInfo=errorInfo_err(i)
	s lb=$lb(errorInfo,"","")	
	s ^CacheTemp(repid,ind)=lb
	s ind=ind+1
	q
okPrint
	s ^CacheTemp(repid,ind)=$lb("1","","")
	s ind=ind+1
	q
}

ClassMethod CQLQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CQLQueryExecute ]
{
	s repid=$LIST(qHandle,2)
 	k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod CQLQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CQLQueryExecute ]
{
	s AtEnd=$LIST(qHandle,1)
 	s repid=$LIST(qHandle,2)
 	s ind=$LIST(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}else {				
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
