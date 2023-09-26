Import sqluser

/// Descript:支配科室信息相关
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-24
Class web.DHCSTMHUI.DefLoc Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	保存/更新支配科室
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-24
/// Table:DHC_DefLoc
/// Input:科室id,支配科室id^支配科室id
/// Output:		
/// Return：""：成功，非空：保存失败
/// w ##class(web.DHCSTMHUI.DefLoc).Save(326,^xjc("2"))
ClassMethod Save(LocId As %String, Params As %String) As %Library.String
{
	n (LocId,Params,%session)
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s sc=PJObj.%FromJSON(Params)
	i sc'=0 d
	.s sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	ts
	s $ZT=..sssError()
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s SubLocId=Obj.%Get("CtRowId")
		s SubLocDesc=Obj.%Get("CtDesc")
		s UseFlag="Y"
		s Rowid=Obj.%Get("Rowid")
		i Rowid'="" d
		.s RtnObj=..Update(LocId,Rowid,SubLocId,UseFlag)
		e  d
		.s RtnObj=..Insert(LocId,SubLocId,UseFlag)
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// 更新方法
/// w ##class(web.DHCSTMHUI.DefLoc).Update()
ClassMethod Update(LocId As %String, Rowid As %String, SubLocId As %String, UseFlag As %String) As RtnObj [ Private ]
{
	n (LocId,Rowid,SubLocId,UseFlag,%session)
	s RtnObj=##class(RtnObj).%New()
 	i ((Rowid="")||(SubLocId="")) d
 	.s Sc=RtnObj.Err(-21,"","必填项不能为空!","",0)
 	q:RtnObj.success'=0 RtnObj
 	&sql(select DLOC_ROWID into :rowid from DHC_DefLoc  where DLOC_Lead_DR = :LocId and DLOC_Sub_DR = :SubLocId)
	i (rowid'="")&&(rowid'=Rowid) d RtnObj.Err(-102,"","科室描述信息重复,请重新输入!","",0)
	q:RtnObj.success'=0 RtnObj
	&sql(Update DHC_DefLoc set DLOC_Sub_DR=:SubLocId,DLOC_UseFlag=:UseFlag where DLOC_ROWID=:Rowid)
 	i SQLCODE'=0  d
 	.s Sc=RtnObj.Err(-11,"",$ClassName()_".Update:SQLCODE"_SQLCODE_":"_$g(%msg))
     q:RtnObj.success'=0 RtnObj
 	q RtnObj
}

/// Descript:	增加支配科室定义
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-24
/// Table:DHC_DefLoc
/// Input:科室id,支配科室id
/// Output:		
/// Return：rowid
ClassMethod Insert(LocId As %String, SubLocId As %String, UseFlag As %String) As RtnObj [ Private ]
{
	n (LocId,SubLocId,UseFlag)
	s RtnObj=##class(RtnObj).%New()
 	;
 	s err=0
 	s rowid=""
 	&sql(select DLOC_ROWID into :rowid from DHC_DefLoc  where DLOC_Lead_DR = :LocId and DLOC_Sub_DR = :SubLocId)
	i rowid'="" d RtnObj.Err(-102,"","科室描述信息重复,请重新输入!","",0)
	q:RtnObj.success'=0 RtnObj
 	&sql(Insert into DHC_DefLoc(DLOC_Lead_DR,DLOC_Sub_DR,DLOC_UseFlag)
 	values(:LocId,:SubLocId,:UseFlag))
 	i SQLCODE'=0  d
 	.s Sc=RtnObj.Err(-11,"",$ClassName()_".Insert:SQLCODE"_SQLCODE_":"_$g(%msg))
 	q:RtnObj.success'=0 RtnObj
 	q RtnObj
}

/// Descript:	删除支配科室定义
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-24
/// Table:DHC_DefLoc
/// Input:rowid
/// Output:		
/// Return：0,成功,
/// w ##class(web.DHCSTMHUI.DefLoc).Delete(^tmplh(555))
ClassMethod Delete(Params As %String) As RtnObj
{
	n (Params)
	s ^tmplh(555)=Params
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s sc=PJObj.%FromJSON(Params)
	i sc'=0 d
	.s sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
 	s Obj=PJObj.%Pop()
 	s rowid=Obj.%Get("Rowid")
 	q:rowid="" RtnObj.Json()
 	&sql(Delete from DHC_DefLoc where DLOC_ROWID=:rowid)
 	i SQLCODE'=0  d
 	.s Sc=RtnObj.Err(-11,"",$ClassName()_".Insert:SQLCODE"_SQLCODE_":"_$g(%msg))
 	  q:RtnObj.success'=0 RtnObj
 	  q RtnObj.Json()
}

/// Descript:	查询某科室对应的支配科室信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-24
/// Table:DHC_DefLoc
/// Input:开始行，一页记录数，排序字段，排序方向,主科室id
/// Output:		
/// Return：Rowid^支配科室id^支配科室代码^支配科室描述
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DefLoc","QueryDefLoc","")
Query QueryDefLoc(LocId As %String) As websys.Query(ROWSPEC = "Rowid,CtRowId,CtCode,CtDesc,UseFlag") [ SqlProc ]
{
}

ClassMethod QueryDefLocExecute(ByRef qHandle As %Binary, LocId As %String) As %Status
{
	n (qHandle,LocId)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:LocId="" $$$OK
	s StrSql="select DLOC_ROWID as Rowid,DLOC_UseFlag,DLOC_Sub_DR CtRowId,DLOC_Sub_DR->CTLOC_Code as CtCode,"_
		"DLOC_Sub_DR->CTLOC_Desc as CtDesc"_
		" from DHC_DefLoc where DLOC_Lead_DR='"_LocId_"'"
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(StrSql)
	s sc=result.Execute()
	i $$$ISERR(sc) q $$$OK
	While(result.Next())
	{
		s Rowid = result.Data("Rowid")
		s CtRowId = result.Data("CtRowId")
		s CtCode = result.Data("CtCode")
		s CtDesc = result.Data("CtDesc")
		s UseFlag=result.Data("DLOC_UseFlag")
		s Data=Rowid_"^"_CtRowId_"^"_CtCode_"^"_CtDesc_"^"_UseFlag	
		d OutPutDefLocdesc
	}
	Quit $$$OK
OutPutDefLocdesc
	s Data=$lb(Rowid,CtRowId,CtCode,CtDesc,UseFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
