/// Description:揭药护士审核查询相关
/// Creator:    hulihua
/// CreateDate: 2017-09-12
/// Table:      DHC_PhaMedBroth-揭药主表、DHC_PhaMedBrothItm-揭药子表
Class web.DHCINPHA.HMNurseCheck.NurseCheckQuery Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Description:查询揭药患者主信息相关
/// Creator:	hulihua
/// CreateDate:	2017-09-12
/// Table:      DHC_PhaMedBroth-揭药主表
/// Input:		每页行数、页数、病区ID
/// Output:		患者姓名、床号、住院号
/// Return：    
/// w ##class(web.DHCINPHA.HMNurseCheck.NurseCheckQuery).GetBrothPatList("50","1","01/09/2017^12/09/2017^114^N")
ClassMethod GetBrothPatList(rows, page, params) As %String
{
	n (rows, page,params)
	//s ^hlh($h)=$lb(rows, page,params)
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	i $g(page)="" s page=1
	i $g(rows)="" s rows=50
	s End = page*rows
	s Start=(page-1)*rows+1
	s StartDate=$p(params,"^",1)
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=$p(params,"^",2)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s WardLocId=$p(params,"^",3)
	s NurseCheckFlag=$p(params,"^",4)
	S pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid("web.DHCINPHA.HMNurseCheck.NurseCheckQuery")
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.HMNurseCheck.NurseCheckQuery","GetBrothPatList",pid,"PAT")
	s n=0
	f Date=StartDate:1:EndDate d
	.s phmbid="" 
	.f  s phmbid=$o(^DHCPHAMEDBi("NurseFlagWardLocDate",NurseCheckFlag,WardLocId,Date,phmbid)) q:phmbid=""  d
	..s papmi=$p(^DHCPHAMEDB(phmbid),"^",1)  
	..q:$d(^TMP("DHCINPHA","web.DHCINPHA.HMNurseCheck.NurseCheckQuery","GetBrothPatList",pid,"PAT",papmi))
	..s phmbCh=0,delFlag=""
	..f  s phmbCh=$o(^DHCPHAMEDB(phmbid,"I",phmbCh)) q:(phmbCh="")||(delFlag'="")  d
	...s uncovMedFlag=$p(^DHCPHAMEDB(phmbid,"I",phmbCh),"^",5)
	...s:uncovMedFlag="Y" delFlag=1
	..q:delFlag=""											
	..s admDr=$p(^DHCPHAMEDB(phmbid),"^",2)
	..s patInfo=##class(PHA.COM.Order).GetPatInfo(admDr)
	..s PatNo=$p(patInfo,"^",1)
	..s PatCardNo=$p(patInfo,"^",12)
	..s PatName=$p(patInfo,"^",3)
	..s BedId=$p(^PAADM(admDr),"^",73)	//未转病区则取当前床位，转病区则床号为空
 	..s Bed=$S(BedId'="":$p($g(^PAWARD($p(BedId,"||",1),"BED",$p(BedId,"||",2))),"^",1),1:"") 
	..s n=n+1
	..s data1=$g(PatNo)_"^"_$g(PatCardNo)_"^"_$g(PatName)_"^"_$g(Bed)_"^"_$g(papmi)
	..s index=papmi
	..s ^TMP("DHCINPHA","web.DHCINPHA.HMNurseCheck.NurseCheckQuery","GetBrothPatList",pid,"PAT",index)=data1
	q:n=0 ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(n) //输出空的json串
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonStartSign(n) //输出json前缀串
	s count=0
	s h=""
	f  s h=$o(^TMP("DHCINPHA","web.DHCINPHA.HMNurseCheck.NurseCheckQuery","GetBrothPatList",pid,"PAT",h),-1) q:h=""  d
	.s mdata=^TMP("DHCINPHA","web.DHCINPHA.HMNurseCheck.NurseCheckQuery","GetBrothPatList",pid,"PAT",h)
	.s count = count+1
	.s Title1="TPatNo^TPatCardNo^TPatName^TBed^TPapmi"
	.s Title=Title1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)

	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign() //输出json结尾符
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.HMNurseCheck.NurseCheckQuery","GetBrothPatList",pid,"PAT")
	q ""
}

/// Description:查询某患者的所有处方揭药信息
/// Creator:	hulihua
/// CreateDate:	2017-09-12
/// Table:      DHC_PhaMedBroth-揭药主表、DHC_PhaMedBrothItm-揭药子表
/// Input:		每页行数、页数、患者ID
/// Output:		处方号、揭药日期、实际揭药日期、数量、接收人、接收部门、接收时间
/// Return：    
/// w ##class(web.DHCINPHA.HMNurseCheck.NurseCheckQuery).GetPatBrothPreList("50","1","03/07/2019^08/07/2019^^153^Y^3888")
ClassMethod GetPatBrothPreList(rows, page, params) As %String
{
	n (rows, page,params)
	//s ^hlh($h)=$lb(rows, page,params)
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	i $g(page)="" s page=1
	i $g(rows)="" s rows=50
	s End = page*rows
	s Start=(page-1)*rows+1
	s StartDate=$p(params,"^",1)
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=$p(params,"^",2)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s Papmi=$p(params,"^",3)
	s WardLocId=$p(params,"^",4)
	s NurseCheckFlag=$p(params,"^",5)
	s BarCode=$p(params,"^",6)
	S pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid("web.DHCINPHA.HMNurseCheck.NurseCheckQuery")
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.HMNurseCheck.NurseCheckQuery","GetPatBrothPreList",pid,"PrescNo")
	s n=0
	f Date=StartDate:1:EndDate d
	.i Papmi'=""  d
	..s MedBroCompFlag=""
	..f  s MedBroCompFlag=$o(^DHCPHAMEDBi("PapmiCompFlagPres",Papmi,MedBroCompFlag)) q:MedBroCompFlag=""  d
	...s PrescNo="" 
	...f  s PrescNo=$o(^DHCPHAMEDBi("PapmiCompFlagPres",Papmi,MedBroCompFlag,PrescNo)) q:PrescNo=""  d
	....s phmbid=""
	....f  s phmbid=$o(^DHCPHAMEDBi("PapmiCompFlagPres",Papmi,MedBroCompFlag,PrescNo,phmbid))  q:phmbid=""  d
	.....s phmbch=0
	.....f  s phmbch=$o(^DHCPHAMEDB(phmbid,"I",phmbch)) q:phmbch=""  d
	......s UncovMedFlag=$p(^DHCPHAMEDB(phmbid,"I",phmbch),"^",5)
	......q:UncovMedFlag'="Y"											//未揭药的过滤 
	......d SetTmpGlobal											
	....
	...
	..
	.
	.e  d
	..s phmbid=""
	..f  s phmbid=$o(^DHCPHAMEDBi("ActDateWordLoc",Date,WardLocId,phmbid))  q:phmbid=""  d
	...s PrescNo=$p(^DHCPHAMEDB(phmbid),"^",4)
	...s phmbch=0
	...f  s phmbch=$o(^DHCPHAMEDB(phmbid,"I",phmbch)) q:phmbch=""  d
	....s UncovMedFlag=$p(^DHCPHAMEDB(phmbid,"I",phmbch),"^",5)
	....q:UncovMedFlag'="Y"											//未揭药的过滤 
	....d SetTmpGlobal
	...
	..
	.
	q:n=0 ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(n) //输出空的json串
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonStartSign(n) //输出json前缀串
	s count=0
	s index=""
	f  s index=$o(^TMP("DHCINPHA","web.DHCINPHA.HMNurseCheck.NurseCheckQuery","GetPatBrothPreList",pid,"PrescNo",index)) q:index=""  d
	.s mdata=^TMP("DHCINPHA","web.DHCINPHA.HMNurseCheck.NurseCheckQuery","GetPatBrothPreList",pid,"PrescNo",index)
	.s count = count+1
	.s Title1="TPrescNo^TActUncovMedDate^TActUncovMedPocNum^TNurseCheckUser^TNurseCheckDate"
	.s Title2="TWardLoc^TPhmbi^TRemark^TPatNo^TPameNo"
	.s Title3="TPatName^TBedNo"
	.s Title=Title1_"^"_Title2_"^"_Title3
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)

	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign() //输出json结尾符
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.HMNurseCheck.NurseCheckQuery","GetPatBrothPreList",pid,"PrescNo")
	q ""
	
SetTmpGlobal
    s NurseCheck=$p(^DHCPHAMEDB(phmbid,"I",phmbch),"^",10)
    q:NurseCheck'=NurseCheckFlag									//护士审核的判断
    s PhbBoxNo=BarCode
    q:(PhbBoxNo'="")&&('$d(^DHCPHBOXi("No",PhbBoxNo)))
	s PhBoxId=$s(PhbBoxNo'="":$o(^DHCPHBOXi("No",PhbBoxNo,""),-1),1:"")
	s PhBoxDr=$p(^DHCPHAMEDB(phmbid,"I",phmbch),"^",16)
	q:(PhBoxId'="")&&(PhBoxId'=PhBoxDr)
	s Phmbi=phmbid_"||"_phmbch
	s MedBrothInfo=##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetMedBrothInfo(Phmbi)
	s WardLocDr=$p(MedBrothInfo,"^",1)				//揭药科室
    q:(NurseCheckFlag'="Y")&&(WardLocId'=WardLocDr)	//查找已核对时候可以显示其他病区的
	s admDr=$p(MedBrothInfo,"^",13)
	s patInfo=##class(PHA.COM.Order).GetPatInfo(admDr)
	s PatNo=$p(patInfo,"^",1)
	s PatName=$p(patInfo,"^",3)
	s PameNo=$p(patInfo,"^",12)
	s BedId=$p(^PAADM(admDr),"^",73)				//未转病区则取当前床位，转病区则床号为空
 	s Bed=$S(BedId'="":$p($g(^PAWARD($p(BedId,"||",1),"BED",$p(BedId,"||",2))),"^",1),1:"") 
    s ActUncovMedDate=$p(MedBrothInfo,"^",7)		//揭药日期
    s ActUncovMedPocNum=$p(MedBrothInfo,"^",6)		//揭药袋数	
    s NurseCheckUser=$p(MedBrothInfo,"^",17)		//核对护士
    s NurseCheckDate=$p(MedBrothInfo,"^",18)		//核对日期
    s WardLoc=$p(MedBrothInfo,"^",2)
    s UncovMedDate=$p(MedBrothInfo,"^",3)			//应揭药日期
    s Remark=$p(MedBrothInfo,"^",8)					//备注
    s n=n+1
	s data1=$g(PrescNo)_"^"_$g(ActUncovMedDate)_"^"_$g(ActUncovMedPocNum)_"^"_$g(NurseCheckUser)_"^"_$g(NurseCheckDate)
	s data2=WardLoc_"^"_Phmbi_"^"_Remark_"^"_$g(PatNo)_"^"_$g(PameNo)
	s data3=$g(PatName)_"^"_$g(Bed)
	s index=PrescNo_","_UncovMedDate
	s ^TMP("DHCINPHA","web.DHCINPHA.HMNurseCheck.NurseCheckQuery","GetPatBrothPreList",pid,"PrescNo",index)=data1_"^"_data2_"^"_data3
	q
}

/// Description:保存护士审核揭药信息
/// Creator:	hulihua
/// CreateDate:	2017-09-14
/// Table:      DHC_PhaMedBroth-揭药主表、DHC_PhaMedBrothItm-揭药子表
/// Input:		揭药明细ID串
/// Output:		
/// Return：    
/// Others:
/// w ##class(web.DHCINPHA.HMMedBroth.MedBrothDispQuery).GetWardLocMedBrothList("1","50","27/08/2017^01/09/2017^88^265")
ClassMethod SavaBrothNurseCheck(listData As %String) As %String
{
	n (listData)
	s phmbistr=$p(listData,"&&",1)
	q:phmbistr="" -1
	s NurseCheckUser=$p(listData,"&&",2)
	s NurseCheckUserID=##Class(web.DHCINPHA.MTCommon.CommonUtil).UserNameToRowID(NurseCheckUser)
	q:NurseCheckUserID="" -2
	s len=$l(phmbistr,"^")
	s ret=0
	ts
	f i=1:1:len  q:ret'=0  d
	.s phmbi=$p(phmbistr,"^",i)
	.s ret=##class(web.DHCINPHA.HMNurseCheck.SqlDbNurseCheck).SaveBroNurCheckDb(phmbi,NurseCheckUserID)
	.i ret'=0 tro
	q:ret'=0 ret
	tc 
	q ret
}

Storage Default
{
<Data name="NurseCheckQueryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCINP36DD.NurseCheckQuB1AD</DataLocation>
<DefaultData>NurseCheckQueryDefaultData</DefaultData>
<IdLocation>^web.DHCINP36DD.NurseCheckQuB1AD</IdLocation>
<IndexLocation>^web.DHCINP36DD.NurseCheckQuB1AI</IndexLocation>
<StreamLocation>^web.DHCINP36DD.NurseCheckQuB1AS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
