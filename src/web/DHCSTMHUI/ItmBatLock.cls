Import sqluser

/// Descript:物资批次锁定
/// Creater:徐超
/// CreateDate:	2015-05-19
Class web.DHCSTMHUI.ItmBatLock Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	查询
/// Creater:	XuChao
/// CreateDate:	2018-08-09
/// Return：信息
Query GetBatInfo(Inci As %String) As Query(ROWSPEC = "Incib,IncibNo,IncibExp,RecallFlag,Vendor,Manf")
{
}

ClassMethod GetBatInfoExecute(ByRef qHandle As %Binary, Inci As %String) As %Status
{
	n (qHandle,Inci)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Inci="" $$$OK
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	s sqlStr ="select INCIB_APCVM_Dr->APCVM_Name,INCIB_PHMNF_Dr->PHMNF_Name,"
	s sqlStr=sqlStr_"INCIB_INCIB_Dr,INCIB_INCIB_Dr->INCIB_No,INCIB_INCIB_Dr->INCIB_RecallFlag,"
	s sqlStr=sqlStr_"INCIB_INCIB_Dr->INCIB_ExpDate from DHC_IncItmBat where INCIB_INCIB_Dr->INCIB_INCI_Parref="_Inci
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s incib = result.Data("INCIB_INCIB_Dr")
		s incibno = result.Data("INCIB_No")
		s incibexp = result.Data("INCIB_ExpDate")
		s:incibexp'="" incibexp=..DL2H(incibexp)
		s recallflag = result.Data("INCIB_RecallFlag")
		s apcname = result.Data("APCVM_Name")
		s phmname = result.Data("PHMNF_Name")
		d OutPutRow
	}
	Quit $$$OK

OutPutRow
	s Data=$lb(incib,incibno,incibexp,recallflag,apcname,phmname)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	保存锁定标志
/// Creater:	徐超
/// CreateDate:	2015-05-19
/// Table:INC_ItmBat 
/// Input:数据串:rowid^标志
/// Output:		
/// Return：0:成功
ClassMethod Save(ListData As %String) As %Library.String
{
	n (ListData)
	s $zt=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(ListData)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s Incib=Obj.%Get("Incib")
		s RecallFlag=Obj.%Get("RecallFlag")
		&sql(Update INC_ItmBat set INCIB_RecallFlag=:RecallFlag where INCIB_RowId=:Incib)
 		i SQLCODE'=0  d
 		.d RtnObj.Err(-1,Incib,$ClassName()_".Update:SQLCODE"_SQLCODE_":"_$g(%msg))
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

ClassMethod SaveRecallFlag(ListData As %String) As %Library.String
{
	n (ListData)
	s $zt=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(ListData)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s Inclb=Obj.%Get("Inclb")
		s Incib=$p(^INCI($p(Inclb,"||",1),"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1)
		s RecallFlag=Obj.%Get("RecallFlag")
		&sql(Update INC_ItmBat set INCIB_RecallFlag=:RecallFlag where INCIB_RowId=:Incib)
 		i SQLCODE'=0  d
 		.d RtnObj.Err(-1,Incib,$ClassName()_".Update:SQLCODE"_SQLCODE_":"_$g(%msg))
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

}
