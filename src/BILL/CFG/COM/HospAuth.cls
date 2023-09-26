/// 名称: BILL.CFG.COM.HospAuth.cls
/// 描述: 医院级授权配置类
/// 编写者: ZhYW
/// 编写日期: 2020-06-08
/// 产品组：计费医保组
Class BILL.CFG.COM.HospAuth Extends BILL.COM.Abstract
{

/// Creator: ZhYW
/// CreatDate: 2017-08-01
/// Description: 指标任务类型
/// Input: 
/// Output: 
/// Debug: d ##class(%ResultSet).RunQuery("BILL.CFG.COM.HospAuth", "FindKPITaskType")
Query FindKPITaskType() As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod FindKPITaskTypeExecute(ByRef qHandle As %Binary) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	set rowId=0
	while($o(^DHCBILLKPITASKTYPE(rowId))) {
		set rowId=$o(^DHCBILLKPITASKTYPE(rowId))
		set data=$g(^DHCBILLKPITASKTYPE(rowId))
		continue:(data="")
		set desc=$p(data,"^",2)
		do OutputTaskType
	}
	
	quit $$$OK
OutputTaskType
	set Data=$lb(rowId,desc)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
}

/// Creator: ZhYW
/// CreatDate: 2017-08-01
/// Description: 查询指标信息
/// Input: 
/// Output: 
/// Debug: d ##class(%ResultSet).RunQuery("BILL.CFG.COM.HospAuth", "FindKPIDetails", "", "", "")
Query FindKPIDetails(taskTypeId As %String, kpiCode As %String, kpiName As %String) As websys.Query(ROWSPEC = "ID:%String,Code:%String,Name:%String,TypeName:%String,TaskTypeName:%String,ClassName:%String,MethodName:%String,StorageType:%String,TableName:%String,DataNode:%String,DataDimen:%String,Active:%String,Creator:%String,CreatDate:%String,CreatTime:%String,ReMark:%String")
{
}

ClassMethod FindKPIDetailsExecute(ByRef qHandle As %Binary, taskTypeId As %String, kpiCode As %String, kpiName As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	set rowId=0
	while($o(^DHCBILLKPISETTING(rowId))) {
		set rowId=$o(^DHCBILLKPISETTING(rowId))
		set data=$g(^DHCBILLKPISETTING(rowId))
		continue:(data="")
		set taskTypeDR=$p(data,"^",1)
		continue:((taskTypeId'="")&&(taskTypeId'=taskTypeDR))
		set taskTypeName=$p($g(^DHCBILLKPITASKTYPE(taskTypeDR)),"^",2)
		set type=$p(data,"^",2)
		set typeName=$case(type,"C":"自定义",:"固有")
		set code=$p(data,"^",3)
		continue:((kpiCode'="")&&(code'[kpiCode))
		set name=$p(data,"^",4)
		continue:((kpiName'="")&&(name'[kpiName))
		set className=$p(data,"^",6)
		set methodName=$p(data,"^",7)
		set kpiStorageType=$p(data,"^",8)
		set storageType=$case(kpiStorageType,"G":"Global",:"Table")_"存储"
		set tableName=$p(data,"^",9)
		set dataNode=$p(data,"^",10)
		set dataDimen=$p(data,"^",11)
		set active=$p(data,"^",12)
		set creator=$p(data,"^",13)
		set creatDate=$p(data,"^",14)
		set creatDate=##class(websys.Conversions).DateLogicalToHtml(creatDate)
		set creatTime=$p(data,"^",15)
		set creatTime=##class(websys.Conversions).TimeLogicalToHtml(creatTime,1)
		set reMark=$p(data,"^",16)
		do OutputDetails
	}
	
	quit $$$OK
OutputDetails
	set Data=$lb(rowId,code,name,typeName,taskTypeName,className,methodName,storageType,tableName,dataNode,dataDimen,active,creator,creatDate,creatTime,reMark)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
}

/// Creator: ZhYW
/// CreatDate: 2017-08-02
/// Description: 保存计费指标数据
/// Input: 
/// Return: rtn:=0 成功, <>0失败
/// Debug: w ##class(BILL.CFG.COM.HospAuth).SaveKPI(^TMP("SaveKPI"))
ClassMethod SaveKPI(kpiInfo As %String) As %String
{
	set $zt="ERROR"
	set rowId=$p(kpiInfo,"^",1)
	ts
	if (+rowId'=0) {
		set dataObj=##class(User.DHCBillKPISetting).%OpenId(rowId)
	}else {
		set dataObj=##class(User.DHCBillKPISetting).%New()
		set dataObj.KPICreator=$p(kpiInfo,"^",14)
		set dataObj.KPICreatDate=+$h
		set dataObj.KPICreatTime=$p($h,",",2)
	}
	do dataObj.KPITaskTypeSetObjectId($p(kpiInfo,"^",2))
	set dataObj.KPIType=$p(kpiInfo,"^",3)
	set dataObj.KPICode=$p(kpiInfo,"^",4)
	set dataObj.KPIName=$p(kpiInfo,"^",5)
	set dataObj.KPIOrder=$p(kpiInfo,"^",6)
	set dataObj.KPIClass=$p(kpiInfo,"^",7)
	set dataObj.KPIMethod=$p(kpiInfo,"^",8)
	set dataObj.KPIStorageType=$p(kpiInfo,"^",9)
	set dataObj.KPITableName=$p(kpiInfo,"^",10)
	set dataObj.KPIDataNode=$p(kpiInfo,"^",11)
	set dataObj.KPIDataDimen=$p(kpiInfo,"^",12)
	set dataObj.KPIActive=$p(kpiInfo,"^",13)
	set dataObj.KPIReMark=$p(kpiInfo,"^",15)
	set sc=dataObj.%Save()
	do dataObj.%Close()
	if $$$ISERR(sc) {
		tro
		quit $System.Status.GetErrorCodes(sc)
	}
	tc
	
	quit 0
	
ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2017-08-02
/// Description: 删除计费指标数据
/// Input: 
/// Return: rtn: = 0 成功, <>0失败
/// Debug: w ##class(BILL.CFG.COM.HospAuth).DeleteKPI()
ClassMethod DeleteKPI(kpiId As %String) As %String
{
	quit:(+kpiId=0) 0
	set sc=##class(User.DHCBillKPISetting).%DeleteId(kpiId)
	if $$$ISERR(sc) {
		quit $System.Status.GetErrorCodes(sc)
	}
	quit 0
}

}
