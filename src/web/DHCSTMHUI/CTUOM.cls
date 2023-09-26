Import sqluser

/// Descript:	单位（包括单位转换）相关
/// Creater:	徐超
/// CreateDate:	2018-04-09
Class web.DHCSTMHUI.CTUOM Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	保存/更新单位信息
/// Creater:	徐超
/// CreateDate:	2018-04-09
/// Table:		CT_Uom
/// Input:		数据Json串:rowid,代码,描述
/// Return：	RtnObj Json
ClassMethod Save(Params) As %Library.String
{
	n (Params,%session)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	ts
 	s $ZT=..sssError()
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s Code=Obj.%Get("Code")
		s Description=Obj.%Get("Description")
	 	i (Code="")||(Description="") s Sc=RtnObj.Err(-2,"","必填项不能为空!","",0)
 		q:RtnObj.success'=0
		s TmpId=$o(^CT("UOM",0,"Code",$$UPPER^SSUTIL4(Code),""))
		i (TmpId'="")&&(TmpId'=RowId) s Sc=RtnObj.Err(-3,"",Description_"代码重复!","",0)
		q:RtnObj.success'=0
	 	s TmpId=$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(Description),""))
	 	i (TmpId'="")&&(TmpId'=RowId) s Sc=RtnObj.Err(-4,"",Description_"名称重复!","",0)
	 	q:RtnObj.success'=0
		i RowId'=""  d
		.s RtnObj=..Update(RowId,Code,Description)
		e  d
		.s RtnObj=..Insert(Code,Description)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:	增加单位信息
/// Creater:	徐超
/// CreateDate:	2018-04-11
/// Table:		CT_Uom
/// Input:		代码,描述
/// Output:		
/// Return：	RtnObj
ClassMethod Insert(Code As %String, Description As %String) As RtnObj [ Private ]
{
	n (Code,Description,%session)
	s RtnObj=##class(RtnObj).%New()
	&sql(Insert into CT_UOM
		(CTUOM_Code,CTUOM_Desc)
		values
		(:Code,:Description))
	i SQLCODE'=0  d
	.s sc=RtnObj.Err(-11,"",$ClassName()_".Insert:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RtnObj=##class(Log).SaveLog("CT_UOM","User.CTUOM","单位信息",$SYSTEM.SQL.GetROWID(),Description,"A")
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	更新单位信息
/// Creater:	徐超
/// CreateDate:	2018-04-10
/// Table:		CT_Uom
/// Input:		rowid^代码^描述
/// Return：	RtnObj
ClassMethod Update(RowId As %String, Code As %String, Description As %String) As RtnObj [ Private ]
{
	n (RowId,Code,Description,%session)
	s RtnObj=##class(RtnObj).%New()
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("CT_UOM",RowId)
	&sql(Update CT_Uom set 
		CTUOM_Code=:Code,CTUOM_Desc=:Description
		where CTUOM_RowId=:RowId)
	i SQLCODE'=0  d
	.s sc=RtnObj.Err(-22,"",$ClassName()_".Update:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RtnObj=##class(Log).SaveLog("CT_UOM","User.CTUOM","单位信息",RowId,Description,"U","",OldJsonStr)
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	查询单位信息
/// Creater:	徐超
/// CreateDate:	2018-04-09
/// Table:		CT_Uom
/// Input:		{Desc:Text}
/// Return：	单位信息
Query SelectAll(Params As %String) As Query(ROWSPEC = "RowId,Code,Description") [ SqlProc ]
{
}

ClassMethod SelectAllExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	 
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s PDescription=PJobj.%Get("Description")
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s SqlStr="SELECT CTUOM_RowId as RowId,CTUOM_Code as Code,CTUOM_Desc as Description"
		_" FROM CT_Uom where CTUOM_Desc like '%"_PDescription_"%'"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s Code = Result.Data("Code")
		s Description = Result.Data("Description")
		d OutPutRow
 	}
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,Code,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	保存单位转换关系
/// Creater:	徐超
/// CreateDate:	2018-04-11
/// Table:		CT_ConFac
/// Input:		From单位id 
/// Return：	消息Json串
ClassMethod SaveConFac(FrUom, Params) As %Library.String
{
	n (FrUom,Params,%session)
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
		s RowId=Obj.%Get("RowId")
		s ToUom=Obj.%Get("ToUomId")
		s ConFac=Obj.%Get("ConFac")
		s ActiveFlag=Obj.%Get("ActiveFlag")
		i (ToUom="")||(ConFac="") d RtnObj.Err(-2,"","必填项不能为空!","",0)
		q:RtnObj.success'=0
		q:'$d(^CT("UOM",FrUom))
		q:'$d(^CT("UOM",ToUom))
		i RowId="" d
		.s RtnObj=..InsertConFac(FrUom,ToUom,ConFac,ActiveFlag)
		e  d
		.s RtnObj=..UpdateConFac(RowId,ConFac,ActiveFlag)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:	增加单位转换关系
/// Creater:	徐超
/// CreateDate:	2018-04-11
/// Table:		CT_ConFac
/// Input:		From单位id,To单位id,转换因子,激活标志
/// Output:		
/// Return：	RtnObj
ClassMethod InsertConFac(FrUom As %String, ToUom As %String, ConFac As %Integer, ActiveFlag As %String) As RtnObj
{
	n (FrUom,ToUom,ConFac,ActiveFlag,%session)
	s RtnObj=##class(RtnObj).%New()
	s FrUomDesc=$p(^CT("UOM",FrUom),"^",2)
	s ToUomDesc=$p(^CT("UOM",ToUom),"^",2)
	s Id=$o(^CT("CTCF",0,"UOM",FrUom,ToUom,""))   ;存在该单位间的转换关系
	i Id'=""  d
	.s Sc=RtnObj.Err(-20,"","存在到单位"_ToUomDesc_"的转换关系","",0)
	q:RtnObj.success'=0 RtnObj
	i (FrUom="")||(ToUom="")||('$d(^CT("UOM",FrUom)))||('$d(^CT("UOM",ToUom))) d
	.s Sc=RtnObj.Err(-21,"","必填项不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	&sql(Insert into CT_ConFac
		(CTCF_FrUOM_DR,CTCF_ToUOM_DR,CTCF_Factor,CTCF_ActiveFlag)
		 values
		 (:FrUom,:ToUom,:ConFac,:ActiveFlag))
	i SQLCODE'=0  d
	.s Sc=RtnObj.Err(-11,"",$ClassName()_".InsertConFac:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RtnObj=##class(Log).SaveLog("CT_ConFac","User.CTConFac","单位换算信息",$SYSTEM.SQL.GetROWID(),FrUomDesc,"A")
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	更新单位转换关系
/// Creater:	徐超
/// CreateDate:	2018-04-11
/// Table:		CT_ConFac
/// Input:		RowId,转换系数,激活标志
/// Return：	RtnObj
ClassMethod UpdateConFac(RowId As %String, ConFac As %Integer, ActiveFlag As %String) As RtnObj
{
	n (RowId,ConFac,ActiveFlag,%session)
	s RtnObj=##class(RtnObj).%New()
	s ToUom=$p(^CT("CTCF",RowId),"^",2)
	s ToUomDesc=$p(^CT("UOM",ToUom),"^",2)
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("CT_ConFac",RowId)
	&sql(Update CT_ConFac set 
		CTCF_Factor=:ConFac,CTCF_ActiveFlag=:ActiveFlag 
		where CTCF_RowId=:RowId)
	i SQLCODE'=0  d
	.s sc=RtnObj.Err(-1,RowId,$ClassName()_".UpdateConFac:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RtnObj=##class(Log).SaveLog("CT_ConFac","User.CTConFac","单位换算信息",RowId,ToUomDesc,"U","",OldJsonStr)
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	删除单位转换关系
/// Creater:	徐超
/// CreateDate:	2018-04-11
/// Table:		CT_ConFac
/// Input:		rowid
/// Return：	消息Json串
ClassMethod DeleteConFac(Params As %String) As %Library.String
{
	n (Params,%session)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	ts
	s $ZT=..sssError()
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		q:RowId=""
		s ToUomId=Obj.%Get("ToUomId")
		s ToUomDesc=$p(^CT("UOM",ToUomId),"^",2) 
		s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("CT_ConFac",RowId)
		&sql(Delete from CT_ConFac where CTCF_RowId=:RowId)
		i SQLCODE'=0  d
		.s sc=RtnObj.Err(-2,RowId,$ClassName()_".DeleteConFac:SQLCODE"_SQLCODE_":"_$g(%msg))
		e  d
		.s RtnObj=##class(Log).SaveLog("CT_ConFac","User.CTConFac","单位换算信息",RowId,ToUomDesc,"D",JsonStr)
		q:RtnObj.success'=0
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	
	tc
	q RtnObj.Json()
}

/// Descript:	查询和已知单位存在转换关系的单位
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-10
/// Table:		CT_ConFac
/// Input:		From单位id
/// Return：	转换信息
ClassMethod SelectConUom(FrUomId As %String) As %Library.String
{
	n (FrUomId)
	q:FrUomId="" ""
	s Count = 0
	s Json = ##class(web.DHCSTMHUI.Common.JsonObj).%New()
	s ToUomId=""
	f  s ToUomId=$o(^CT("CTCF",0,"UOM",FrUomId,ToUomId)) q:ToUomId=""  d
	.s RowId=$o(^CT("CTCF",0,"UOM",FrUomId,ToUomId,"")) 
	.q:RowId="" 
	.s ToUomCode=$p(^CT("UOM",ToUomId),"^",1)
	.s ToUomDesc=$p(^CT("UOM",ToUomId),"^",2) 
	.s ConFac=$p(^CT("CTCF",RowId),"^",3)
	.s ActiveFlag=$p(^CT("CTCF",RowId),"^",4)
	.s Tmp=RowId_"^"_ToUomId_"^"_ToUomCode_"^"_ToUomDesc_"^"_ConFac_"^"_ActiveFlag
	.s Count = Count+1		
	.d Json.InsertRowData(Tmp)
	d Json.getJsonData("RowId^ToUomId^ToUomCode^ToUomDesc^ConFac:number^ActiveFlag",Count)
	k Json
	q ""
}

}
