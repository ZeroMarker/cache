Class DHCWL.RptMgmt.Interface Extends %RegisteredObject
{

/*
Query qryGetRptCfg(inRaqName As %String,inCSPName As %String) As %SQLQuery(CONTAINID = 1)  [ SqlProc ]
{

    SELECT ID, AdvUser, AuxiliaryMenuName, CSPName, CreateDate, Demo, DepMaintainer, Filter, HisTableName, KPIName, MenuName, ProMaintainer, ProgramLogic, QueryName, RaqName, RowColShow, Spec, UPdateDate, UsedByDep 	FROM DHCWL_RptMgmt.RptCfg 
    WHERE RaqName = :inRaqName AND CSPName = :inCSPName 
}
*/

//d ##class(DHCWL.RptMgmt.Interface)QryGetRptCfg(inRaqName,inCSPName)

Query QryGetRptCfg(inRaqName As %String, inCSPName As %String, inAuxiliaryMenuName As %String) As %Query(ROWSPEC = "menuName:%String,raqName:%String,CSPName:%String,queryName:%String,spec:%String,hisTableName:%String,KPIName:%String,filter:%String,rowColShow:%String,programLogic:%String,advUser:%String,proMaintainer:%String,depMaintainer:%String,demo:%String,createDate:%String,updateDate:%String,auxiliaryMenuName:%String,usedByDep") [ SqlProc ]
{
}

ClassMethod QryGetRptCfgExecute(ByRef qHandle As %Binary, inRaqName As %String, inCSPName As %String, AuxiliaryMenuName As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1

	
	if $d(^DHCWL.RptMgmt.RptCfgI("InxRaqCspTitle",$g(inRaqName)_"|"_$g(inCSPName)_"|"_$g(AuxiliaryMenuName))) {
		s ID=$o(^DHCWL.RptMgmt.RptCfgI("InxRaqCspTitle",$g(inRaqName)_"|"_$g(inCSPName)_"|"_$g(AuxiliaryMenuName),""))
		s rptObj=##class(DHCWL.RptMgmt.RptCfg).%OpenId(ID)
		s menuName=rptObj.MenuName
		s raqName=rptObj.RaqName
		s CSPName=rptObj.CSPName
		s queryName=rptObj.QueryName
		s spec=rptObj.Spec
		s hisTableName=rptObj.HisTableName
		s KPIName=rptObj.KPIName
		s filter=rptObj.Filter
		s rowColShow=rptObj.RowColShow
		s programLogic=rptObj.ProgramLogic
		s advUser=rptObj.AdvUser
		s proMaintainer=rptObj.ProMaintainer
		s depMaintainer=rptObj.DepMaintainer
		s demo=rptObj.Demo
		s createDate=rptObj.CreateDate
		s updateDate=rptObj.UPdateDate
		s auxiliaryMenuName=rptObj.AuxiliaryMenuName
		s usedByDep=rptObj.UsedByDep

		s Data=$lb(menuName,raqName,CSPName,queryName,spec,hisTableName,KPIName,filter,rowColShow,programLogic,advUser,proMaintainer,depMaintainer,demo,createDate,updateDate,auxiliaryMenuName,usedByDep)
		Do OutRow
	}
    Set qHandle=$lb(0,repid,0)
    k ^TEMPDHCWL($j)
 	Quit $$$OK
OutRow
    //s LocDesc=$p(^CTLOC(locdr),"^",2)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QryGetRptCfgClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryGetRptCfgExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryGetRptCfgFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryGetRptCfgExecute ]
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

ClassMethod GetRptCfg(ByRef inParam, ByRef outParam) As %String
{
	s ret=""

	s RaqName=$g(inParam("RaqName"))
	s CSPName=$g(inParam("CSPName"))
	s AuxiliaryMenuName=$g(inParam("AuxiliaryMenuName"))
		
	s sql="SELECT ID, AdvUser, AuxiliaryMenuName, CSPName, CreateDate, "
	s sql=sql_"Demo, DepMaintainer, Filter, HisTableName, KPIName, "
	s sql=sql_"MenuName, ProMaintainer, ProgramLogic, QueryName, RaqName," 
	s sql=sql_"RowColShow, Spec, UPdateDate,UsedByDep FROM DHCWL_RptMgmt.RptCfg "
	s sqlConf=""

	if RaqName'="" {
		if sqlConf'="" s sqlConf=sqlConf_" and "
		s sqlConf=sqlConf_"RaqName = '"_RaqName_"'"
	}else {
		if sqlConf'="" s sqlConf=sqlConf_" and "
		s sqlConf=sqlConf_"RaqName is NULL"		
	}
			
	if CSPName'="" {
		if sqlConf'="" s sqlConf=sqlConf_" and "
		s sqlConf=sqlConf_"CSPName = '"_CSPName_"'"
	}else {
		if sqlConf'="" s sqlConf=sqlConf_" and "
		s sqlConf=sqlConf_"CSPName is NULL"		
	}	

	if AuxiliaryMenuName'="" {
		if sqlConf'="" s sqlConf=sqlConf_" and "
		s sqlConf=sqlConf_"AuxiliaryMenuName = '"_AuxiliaryMenuName_"'"
	}else {
		if sqlConf'="" s sqlConf=sqlConf_" and "
		s sqlConf=sqlConf_"AuxiliaryMenuName is NULL"		
	}
	
	if sqlConf'="" s sql=sql_"WHERE "_sqlConf
	//w !,sql

	s jsonPro="ID, AdvUser, AuxiliaryMenuName, CSPName, CreateDate, "
	s jsonPro=jsonPro_"Demo, DepMaintainer, Filter, HisTableName, KPIName, "
	s jsonPro=jsonPro_"MenuName, ProMaintainer, ProgramLogic, QueryName, RaqName," 
	s jsonPro=jsonPro_"RowColShow, Spec, UPdateDate,UsedByDep	"	
	
	s qryName="%DynamicQuery:SQL"	
	s json=##class(DHCWL.RptMgmt.Util).GetJsonByQry(qryName,"",sql,0,0,jsonPro)
	w json.GetHead()
	d{
		s obj=json.Next()
		w obj
	}while(obj'="")
	i json.GetCount()=0 w "]}"		
	
	q ret
}

/// 导出到xml
ClassMethod expXml(ByRef inParam, ByRef outParam) As %String
{
	s sqlTableName=inParam("sqlTableName")
	s rangeRecs=inParam("rangeRecs")
	s fieldNames=inParam("fieldNames")
	
	s list=##Class(%Library.ListOfObjects).%New()
	
	if rangeRecs="allRecs"  {
		s ID=""
		f {
			s ID=$o(^DHCWL.RptMgmt.RptCfgD(ID))
			q:+$g(ID)=0
			
			s rptObj=##class(DHCWL.RptMgmt.RptCfg).%OpenId(ID)
			continue:rptObj=""
			d list.Insert(rptObj)
		}
	}else{
		s recCnt=$l(rangeRecs,",")
		f i=1:1:recCnt {
			s ID=$p(rangeRecs,",",i)
			continue:+ID=0
			
			s rptObj=##class(DHCWL.RptMgmt.RptCfg).%OpenId(ID)
			continue:rptObj=""
			d list.Insert(rptObj)
		}
		
	}


	s service=##class(DHCWL.ModuleManageServ.ModuleOutputIF).%New()
	d ##class(DHCWL.MKPIIO.util.Write).WriteXML(list,.service,,.outStream,"mgmt")
	
	Set sc =##class(%XML.TextReader).ParseStream(outStream,.reader)
	If $$$ISERR(sc) {
		D DecomposeStatus^%apiOBJ(sc,.err,"-d") 
		w "导出错误:"
		For i=1:1:err Write err(i),! 
		q
	}

	d ##class(DHCWL.MKPIIO.DefaultOutService).TraverXmlToStr(reader)
	q ""
}

}
