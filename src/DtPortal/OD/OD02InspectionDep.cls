/// 名称:DtPortal.OD.OD02InspectionDep
/// 描述:检查科室--调用pacs接口
/// 编写者：bmz
/// 编写日期: 2015-8-20
Class DtPortal.OD.OD02InspectionDep Extends %RegisteredObject
{

/// 名称:DtPortal.OD.OD02InspectionDep
/// CreatDate： 2015-08-20
/// Description: 查询检查科室的人数信息
/// Input：          
/// Return： 
/// 服务代码 OD02.01.01
/// d ##class(%ResultSet).RunQuery("DtPortal.OD.OD02InspectionDep","OD020101","O","")
Query OD020101(patType As %String = "", hospitalId As %String = "") As DtPortal.Query(ROWSPEC = "depDesc,dueNum,expectNum,registrationNum,finishNum,waitingNum")
{
}

ClassMethod OD020101Execute(ByRef qHandle As %Binary, patType As %String = "", hospitalId As %String = "") As %Status
{
	//New (qHandle,userCode)
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	s hospitalCode=""
	i hospitalId'="" s hospitalCode=$p($g(^CT("HOSP",hospitalId)),"^",1)
	
	//先判断DHC-PACS命名空间是否存在,存在就转换，不存在判断PACS
	s ifPACS=##class(%SYS.Namespace).Exists("DHC-PACS")
	if (ifPACS=1){
		zn "DHC-PACS"
	}else{
		s ifPACS=##class(%SYS.Namespace).Exists("PACS")
		if (ifPACS=1){
			zn "PACS"
		}else{
			q $$$OK
		}
	}
	
	Set obj=##class(%ResultSet).%New("PACS.RISInterface:QueryStudyNumSummaryInfo")
	s num=0

	d obj.Execute(patType,hospitalCode)
	For  Quit:'obj.Next()  Do
	.;科室描述、申请未预约、预计人数（已预约和到达过的）、到达、已检、待检
	.s num=num+1
	.s depDesc="",(dueNum,expectNum,registrationNum,finishNum,waitingNum)=0
	.s depDesc=obj.Data("depDesc")
	.s dueNum=obj.Data("dueNum")
	.s expectNum=obj.Data("expectNum")
	.s registrationNum=obj.Data("registrationNum")
	.s finishNum=obj.Data("finishNum")
	.s waitingNum=obj.Data("waitingNum")
	.s pacsTempData("pacsTempData",$j,num)=depDesc_"^"_dueNum_"^"_expectNum_"^"_registrationNum_"^"_finishNum_"^"_waitingNum
	d obj.Close()


	zn "DHC-APP"
	s num1=""
	f  s num1=$o(pacsTempData("pacsTempData",$j,num1)) q:num1=""  d
	.s data=pacsTempData("pacsTempData",$j,num1)
	.s depDesc=$p(data,"^",1)
	.i depDesc["-" s depDesc=$p(depDesc,"-",2)
	.s dueNum=$p(data,"^",2)
	.s expectNum=$p(data,"^",3)
	.s registrationNum=$p(data,"^",4)
	.s finishNum=$p(data,"^",5)
	.s waitingNum=$p(data,"^",6)
	.d RISInterface
	q $$$OK
	

  
RISInterface
    s Data=$lb(depDesc,dueNum,expectNum,registrationNum,finishNum,waitingNum)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

}
