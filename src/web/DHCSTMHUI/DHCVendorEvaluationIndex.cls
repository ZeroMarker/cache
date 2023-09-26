Import sqluser

/// Descript: 供应商评价
/// Creater: tsr
/// CreateDate:	2016-06-18
Class web.DHCSTMHUI.DHCVendorEvaluationIndex Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	查询供应商评价指标
/// Creater:	tsr
/// CreateDate:	2018-08-28
/// Table:		DHC_VendorEvaluationIndex
Query EvalIndex(Params) As Query(ROWSPEC = "RowId,Code,Desc,Weight,SysIndex,ScoreEdited") [ SqlProc ]
{
}

ClassMethod EvalIndexExecute(ByRef qHandle As %Binary, Params) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s gHospId=PJobj.%Get("gHospId")
	s HospId=PJobj.%Get("Hospital")
	i HospId'="" s gHospId=HospId	//使用选择的医院ID
	
	s SqlStr="SELECT VEI_RowId, VEI_Code, VEI_Desc, VEI_Weight, VEI_SySIndex, VEI_ScoreEdited FROM DHC_VendorEvaluationIndex"
	s result=##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(SqlStr)
	s sc=result.Execute()
	i $$$ISERR(sc) q $$$OK
	while (result.Next())
	{
		s RowId = result.Data("VEI_RowId")
		//判断医院权限
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_VendorEvaluationIndex",RowId,gHospId)
		continue:ShowDataFlag="N"
		s Code = result.Data("VEI_Code")
		s Desc = result.Data("VEI_Desc")
		s Weight = result.Data("VEI_Weight")
		s SysIndex = result.Data("VEI_SySIndex")
		s ScoreEdited = result.Data("VEI_ScoreEdited")
		s:SysIndex="" SysIndex="N"
		s:ScoreEdited="" ScoreEdited="N"
		d OutPutRow 
	}
	d result.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,Code,Desc,Weight,SysIndex,ScoreEdited)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	保存/更新供应商评价指标
/// Creater:	tsr
/// CreateDate:	2018-08-29
/// Table:		DHC_VendorEvaluationIndex
ClassMethod Save(Params As %String, Main As %String) As %Library.String
{
	n (Params,Main,%session)
	s RtnObj=##class(RtnObj).%New()

	s MainPJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:MainPJObj.%FromJSON(Main)'=0 RtnObj.Err(-1,"","入参解析失败!").Json()
	s gHospId=MainPJObj.%Get("gHospId")
	s HospId=MainPJObj.%Get("Hospital")
	i HospId'="" s gHospId=HospId	//使用选择的医院ID

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s $ZT=..sssError()
	ts
	while(RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s Code=Obj.%Get("Code")
		s Desc=Obj.%Get("Desc")
		s Weight=Obj.%Get("Weight")
		s SysIndex=Obj.%Get("SysIndex")
		s ScoreEdited=Obj.%Get("ScoreEdited")
		i (Code="")||(Desc="")||(Weight="") d RtnObj.Err(-2,"","必填项不能为空!","",0)
		q:RtnObj.success'=0
		s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("CODE",Code,"DHC_VendorEvaluationIndex",gHospId,RowId)
		i ret>0 d RtnObj.Err(-2,RowId,Code_" 代码重复!","",0)
		continue:RtnObj.success<0
		s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",Desc,"DHC_VendorEvaluationIndex",gHospId,RowId)
		i ret>0 d RtnObj.Err(-2,RowId,Desc_" 名称重复!","",0)
		continue:RtnObj.success<0
		i RowId'=""  d
		.s RtnObj=..Update(RowId,Code,Desc,Weight,SysIndex,ScoreEdited)
		e  d
		.s RtnObj=..Insert(Code,Desc,Weight,SysIndex,ScoreEdited,gHospId)
		q:RtnObj.success'=0
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:	增加供应商评价指标
/// Creater:	tsr
/// CreateDate:	2018-08-29
/// Table:		DHC_VendorEvaluationIndex
ClassMethod Insert(Code As %String, Desc As %String, Weight As %String, SysIndex As %String, ScoreEdited As %String, gHospId) As RtnObj [ Private ]
{
	n (Code,Desc,Weight,SysIndex,ScoreEdited,gHospId,%session)
	s RtnObj=##class(RtnObj).%New()
	&sql(Insert into DHC_VendorEvaluationIndex
		(VEI_Code,VEI_Desc,VEI_Weight,VEI_SySIndex,VEI_ScoreEdited)
		values(:Code,:Desc,:Weight,:SysIndex,:ScoreEdited))
	i SQLCODE'=0  d
	.d RtnObj.Err(-11,"","增加评价指标失败:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RowId=%ROWID
	.//保存医院关联
	.s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("DHC_VendorEvaluationIndex",RowId,gHospId)
	.i ret<0 d RtnObj.Err(-11,"","关联医院失败"_ret)
	.q:RtnObj.success'=0
	.s RtnObj=##class(Log).SaveLog("DHC_VendorEvaluationIndex","User.DHCVendorEvaluationIndex","评价指标",$SYSTEM.SQL.GetROWID(),Desc,"A")
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	更新供应商评价指标
/// Creater:	tsr
/// CreateDate:	2018-08-29
/// Table:		DHC_VendorEvaluationIndex
ClassMethod Update(RowId As %String, Code As %String, Desc As %String, Weight As %String, SysIndex As %String, ScoreEdited As %String) As RtnObj [ Private ]
{
	n (RowId,Code,Desc,Weight,SysIndex,ScoreEdited,%session)
	s RtnObj=##class(RtnObj).%New()
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_VendorEvaluationIndex",RowId)
	&sql(UPDATE DHC_VendorEvaluationIndex 
		SET VEI_Code=:Code,VEI_Desc=:Desc,VEI_Weight=:Weight,VEI_SySIndex=:SysIndex,VEI_ScoreEdited=:ScoreEdited
		WHERE VEI_RowId=:RowId)
	i SQLCODE'=0  d
	.d RtnObj.Err(-22,"","更新评价指标失败:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RtnObj=##class(Log).SaveLog("DHC_VendorEvaluationIndex","User.DHCVendorEvaluationIndex","评价指标",RowId,Desc,"U","",OldJsonStr)
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	查询评价指标对应扣分原因
/// Creater:	tsr
/// CreateDate:	2018-08-29
/// Table:		DHC_VenEvalReason
/// Input:		评价指标Id
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCVendorEvaluationIndex","EvalReason","","","1")
Query EvalReason(Parref As %String) As Query(ROWSPEC = "RowId,Code,Desc,Weight:%Float") [ SqlProc ]
{
}

ClassMethod EvalReasonExecute(ByRef qHandle As %Binary, Parref As %String) As %Status
{
	n (qHandle,Parref)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Parref="" $$$OK

	s SqlStr="SELECT VEIR_RowId, VEIR_Code, VEIR_Desc, VEIR_Weight FROM DHC_VenEvalReason"
		_" WHERE VEIR_VEI="_Parref
	s result=##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(SqlStr)
	s sc=result.Execute()
	i $$$ISERR(sc) q $$$OK
	while (result.Next())
	{
		s RowId = result.Data("VEIR_RowId")
		s Code = result.Data("VEIR_Code")
		s Desc = result.Data("VEIR_Desc")
		s Weight = result.Data("VEIR_Weight")
		d OutPutReasonRow 
	}
	d result.Close()
	Quit $$$OK
OutPutReasonRow
	s Data=$lb(RowId,Code,Desc,Weight)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	保存/更新供应商评价指标对应扣分原因
/// Creater:	tsr
/// CreateDate:	2018-08-29
/// Table:		DHC_VenEvalReason
ClassMethod SaveEvalReason(EvalIndex As %String, Params As %String) As %Library.String
{
	n (EvalIndex,Params,%session)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	i EvalIndex="" d RtnObj.Err(-1,"","请选择评价指标!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-2,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s $ZT=..sssError()
	ts
	while(RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s Code=Obj.%Get("Code")
		s Desc=Obj.%Get("Desc")
		s Weight=Obj.%Get("Weight")
		i (Code="")||(Desc="")||(Weight="") d RtnObj.Err(-3,"","必填项不能为空!","",0)
		q:RtnObj.success'=0
		s TmpId=..CheckVEIRCode($$ALPHAUP^SSUTIL4(Code),EvalIndex)
		i (TmpId'="")&&(TmpId'=RowId) d RtnObj.Err(-4,"",Desc_"代码重复!","",0)
		q:RtnObj.success'=0
		s TmpId=..CheckVEIRDesc($$ALPHAUP^SSUTIL4(Desc),EvalIndex)
		i (TmpId'="")&&(TmpId'=RowId) d RtnObj.Err(-5,"",Desc_"名称重复!","",0)
		q:RtnObj.success'=0
		i RowId'=""  d
		.s RtnObj=..UpdateVEIR(EvalIndex,RowId,Code,Desc,Weight)
		e  d
		.s RtnObj=..InsertVEIR(EvalIndex,Code,Desc,Weight)
		q:RtnObj.success'=0
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:	验证扣分原因代码是否重复
/// Creater:	tsr
/// CreateDate: 2018-08-29
/// Table:		DHC_VenEvalReason
ClassMethod CheckVEIRCode(Code As %String, EvalIndex As %String) As %String
{
	n (Code,EvalIndex)
	s RowId=""
	&sql(select VEIR_RowId into :RowId from DHC_VenEvalReason where VEIR_Code=:Code and VEIR_VEI=:EvalIndex)
	q RowId
}

/// Descript:	验证扣分原因名称是否重复
/// Creater:	tsr
/// CreateDate: 2018-08-29
/// Table:		DHC_VenEvalReason
ClassMethod CheckVEIRDesc(Desc As %String, EvalIndex As %String) As %String
{
	n (Desc,EvalIndex)
	s RowId=""
	&sql(select VEIR_RowId into :RowId from DHC_VenEvalReason where VEIR_Desc=:Desc and VEIR_VEI=:EvalIndex)
	q RowId
}

/// Descript:	增加供应商评价指标扣分原因
/// Creater:	tsr
/// CreateDate:	2018-08-29
/// Table:		DHC_VenEvalReason
ClassMethod InsertVEIR(EvalIndex As %String, Code As %String, Desc As %String, Weight As %String) As RtnObj [ Private ]
{
	n (EvalIndex,Code,Desc,Weight,%session)
	s RtnObj=##class(RtnObj).%New()
 	&sql(Insert into DHC_VenEvalReason
 		(VEIR_VEI,VEIR_Code,VEIR_Desc,VEIR_Weight)
 		values(:EvalIndex,:Code,:Desc,:Weight))
 	i SQLCODE'=0  d
 	.d RtnObj.Err(-11,"","增加扣分项失败:SQLCODE"_SQLCODE_":"_$g(%msg))
 	e  d
    .s RtnObj=##class(Log).SaveLog("DHC_VenEvalReason","User.DHCVenEvalReason","扣分项",$SYSTEM.SQL.GetROWID(),Desc,"A")
 	q:RtnObj.success'=0 RtnObj
 	q RtnObj
}

/// Descript:	更新供应商评价指标扣分原因
/// Creater:	tsr
/// CreateDate:	2018-08-29
/// Table:		DHC_VenEvalReason
ClassMethod UpdateVEIR(EvalIndex As %String, RowId As %String, Code As %String, Desc As %String, Weight As %String) As RtnObj [ Private ]
{
	n (EvalIndex,RowId,Code,Desc,Weight,%session)
 	s RtnObj=##class(RtnObj).%New()
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_VenEvalReason",RowId)
 	&sql(UPDATE DHC_VenEvalReason 
 		SET VEIR_Code=:Code,VEIR_Desc=:Desc,VEIR_Weight=:Weight
 		WHERE VEIR_RowId=:RowId AND VEIR_VEI=:EvalIndex)
 	i SQLCODE'=0  d
 	.d RtnObj.Err(-22,"","更新扣分项失败:SQLCODE"_SQLCODE_":"_$g(%msg))
 	e  d
    .s RtnObj=##class(Log).SaveLog("DHC_VenEvalReason","User.DHCVenEvalReason","扣分项",RowId,Desc,"U","",OldJsonStr)
    q:RtnObj.success'=0 RtnObj
 	q RtnObj
}

/// Descript: 删除供应商评价指标
/// Creater: tsr
/// CreateDate:	2016-06-18
/// Table: DHC_VendorEvaluationIndex
ClassMethod Delete(rowid As %String) As %Library.String
{
	n (rowid,%session)
 	q:rowid="" ""
 	s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_VendorEvaluationIndex",rowid)
 	&sql(Delete from DHC_VendorEvaluationIndex where VEI_RowId=:rowid)
 	q:SQLCODE'=0 SQLCODE
	d ##class(Log).SaveLog("DHC_VendorEvaluationIndex","User.DHCVendorEvaluationIndex","供应商评价指标",rowid,"","D",JsonStr)
	q 0
}

/// Descript: 查询供应商评价指标
/// Creater: tsr
/// CreateDate:	2016-06-18
/// Table: DHC_VendorEvaluationIndex
ClassMethod SelectAll()
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT VEI_RowId as Rowid,VEI_Code as Code,VEI_Desc as Description,VEI_Weight as Weight,VEI_SySIndex SysIndex,VEI_ScoreEdited FROM DHC_VendorEvaluationIndex"
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s json = ##class(web.DHCSTMHUI.Common.JsonObj).%New()
	While(result.Next())
	{
		s Rowid = result.Data("Rowid")
		s Code = result.Data("Code")
		s Description = result.Data("Description")
	    s Weight = result.Data("Weight")
	    s SysIndex = result.Data("SysIndex")
	    s ScoreEdited = result.Data("VEI_ScoreEdited")
	    s:SysIndex="" SysIndex="N"
	    s:ScoreEdited="" ScoreEdited="N"
		s tmp=Rowid_"^"_Code_"^"_Description_"^"_Weight_"^"_SysIndex_"^"_ScoreEdited
		s count = count+1
		d json.InsertRowData(tmp)
	}
	d result.Close()
	d json.getJsonData("RowId^Code^Desc^Weight:number^SysIndex^ScoreEdited",count)
	k json
}

/// Descript: 供应商评价指标权重
/// Creater: tsr
/// CreateDate:	2016-06-18
/// Table: DHC_VendorEvaluationIndex
ClassMethod GetWeight(rowid As %String) As %Library.String
{
	n (rowid)
	q:rowid="" ""
	s weight=""
	s weight=$p(^DHCVEI(rowid),"^",3)
	q weight
}

/// Descript: 供应商评价指标系统标志
/// Creater: tsr
/// CreateDate:	2016-06-22
/// Table: DHC_VendorEvaluationIndex
ClassMethod GetSySIndex(rowid As %String) As %Library.String
{
	n (rowid)
	q:rowid="" ""
	s sysIndex=""
	s sysIndex=$p(^DHCVEI(rowid),"^",4)
	s:((sysIndex="")||(sysIndex="N")) sysIndex=0
	s:sysIndex="Y" sysIndex=1
	q sysIndex
}

/// 验证供应商评价指标权重之和是否小于等于1(相同时间)
/// Author: tsr
/// Date: 2016-06-18
ClassMethod CheckWeight(Vendor As %String, Date As %String) As %String
{
	n (Vendor,Date)
	q:Vendor="" -1
	q:Date="" -1
	s (VERowid,Weight,TotalWeight,err)=0
	f  s VERowid=$o(^DHCVE(0,"Vendor",Vendor,VERowid)) q:((VERowid="")||(err'=0))  d
	.s EvaluDate=$p(^DHCVE(VERowid),"^",5)
	.q:EvaluDate'=Date
	.s EvaluIndex=$p(^DHCVE(VERowid),"^",2)
	.s Weight=$p(^DHCVEI(EvaluIndex),"^",3)
	.s TotalWeight=TotalWeight+Weight
	.i TotalWeight>1 d
	..s err=-2
	q err
}

/// Descript: 供应商评价指标分数
/// Creater: tsr
/// CreateDate:	2016-06-18
/// Table: DHC_VendorEvaluationIndex
ClassMethod GetEvalIndex(Vendor As %String, Pointer As %String = "", Type As %String = "") As %Library.String
{
	n (Vendor,Pointer,Type)
	s count = 0
	s SqlStr="select VE_RowId RowId,VE_VEI_DR,VE_VEI_DR->VEI_Desc VEIDesc,VE_VEI_DR->VEI_Weight Weight,VE_Score,VE_Remarks,VE_Date,VE_SubmitFlag,VE_Reason_DR"
		_" from DHC_VendorEvaluation where VE_APCVM_DR="_Vendor
	i (Pointer'="")&&(Type'="") s SqlStr=SqlStr_" and VE_Pointer="_Pointer_" and VE_Type='"_Type_"'"
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(SqlStr)
	s sc=result.Execute()
	i $$$ISERR(sc) q $$$OK
	while (result.Next())
	{
		s RowId=result.Data("RowId")
		s Index=result.Data("VE_VEI_DR")
		s Desc=result.Data("VEIDesc")
		s Weight=result.Data("Weight")
		s Score=result.Data("VE_Score")
		s Remark=result.Data("VE_Remarks")
		s Date=..DL2H(result.Data("VE_Date"))
		s SubmitFlag=result.Data("VE_SubmitFlag")
		s:SubmitFlag="" SubmitFlag="N"
		s ReasonDR=result.Data("VE_Reason_DR")
		s ReasonDesc=..GetReasonDesc(ReasonDR)
		s ScoreEdited=$p(^DHCVEI(Index),"^",6)
		s:ScoreEdited="" ScoreEdited="N"
		d OutPutIndexRow 
	}
	d result.Close()
	Quit $$$OK
}

/// Descript: 供应商系统评价指标的默认分数和备注信息
/// Creater: tsr
/// CreateDate:	2016-06-22
/// Table: DHC_VendorEvaluationIndex
ClassMethod GetSysIndexScore(index As %String, vendor As %String) As %Library.String
{
	n (index,vendor)
	q:index="" ""
	q:vendor="" ""
	s ret=""
	s IndexDesc=$p(^DHCVEI(index),"^",2)
	i IndexDesc="送货时间" d
	.s ret=..GetDeliveryTime(vendor)
	q ret
}

/// 取某供应商某入库单(或最近一次)送货时间和对应分数(送货时间=入库日期-要求到货日期)
/// Author: tsr
/// Date: 2016-06-21
/// w ##class(web.DHCSTMHUI.DHCVendorEvaluationIndex).GetDeliveryTime(658)
ClassMethod GetDeliveryTime(Vendor As %String, Type As %String = "", Pointer As %String = "") As %String
{
	n (Vendor,Type,Pointer)
	q:Vendor="" -1
	s (INPO,INPONeedDate,INGRRowId,INGRDate,Date,Score)=""
	i Pointer="" d
	.s INPO=$o(^INPO(0,"Vendor",Vendor,""),-1)
	e  d
	.i Type="G" d
	..s INPO=$p(^DHCINGR(Pointer),"^",11)
	.e  i Type="P" d
	..s INPO=Pointer
	s:INPO'="" INPONeedDate=$p(^INPO(INPO),"^",13)	;订单要求到货日期
	s:INPO'="" INGRRowId=$o(^DHCINGR(0,"PO",INPO,""))
	s:INGRRowId'="" INGRDate=$p(^DHCINGR(INGRRowId),"^",14)		;订单入库日期
	s Date=+(INGRDate-INPONeedDate)
	i Date<4 d
	.s Score=5
	e  i (Date>3)&&(Date<8) d
	.s Score=4
	e  i (Date>7)&&(Date<13) d
	.s Score=3
	e  i (Date>12)&&(Date<19) d
	.s Score=2
	e  i Date>18 d
	.s Score=1
	q "送货时间:"_Date_"天#"_Score
}

/// Descript: 根据入库单获取供应商的评价指标分数
/// Creater: tsr
/// CreateDate:	2016-06-18
/// Table: DHC_VendorEvaluationIndex
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCVendorEvaluationIndex","GetIndexByIngr","","","109")
Query GetIndexByPointer(Pointer As %String, Type As %String) As Query(ROWSPEC = "RowId,IndexId,IndexDesc,Weight:%Float,SysIndex,ScoreEdited,Score:%Float,Remark,Date,SubmitFlag,ReasonId,ReasonDesc") [ SqlProc ]
{
}

ClassMethod GetIndexByPointerExecute(ByRef qHandle As %Binary, Pointer As %String, Type As %String) As %Status
{
	n (qHandle,Pointer,Type)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Pointer="" $$$OK
	
	s Vendor=""
	if Type="G" {	//入库
		s Vendor=$p(^DHCINGR(Pointer),"^",3)
	}elseif Type="P" {	//订单
		s Vendor=$p(^INPO(Pointer),"^",2)
	}else {
		s Vendor=""
	}
	q:Vendor="" $$$OK
	s VERowid=$o(^DHCVE(0,"TypePointer",Type,Pointer,""))
	s (RowId,IndexId,IndexDesc,Weight,SysIndex,ScoreEdited,Score,Remark,Date,SubmitFlag,ReasonId,ReasonDesc)=""
	i VERowid'=""
	{
		s SqlStr="select VE_RowId RowId,VE_VEI_DR,VE_VEI_DR->VEI_Desc VEIDesc,VE_VEI_DR->VEI_Weight Weight,VE_Score,VE_Remarks,VE_Date,VE_SubmitFlag,VE_Reason_DR"
			_" from DHC_VendorEvaluation where VE_APCVM_DR="_Vendor
		s SqlStr=SqlStr_" and VE_Pointer="_Pointer_" and VE_Type='"_Type_"'"
		s result=##class(%Library.ResultSet).%New()
		d result.RuntimeModeSet(0)
		d result.Prepare(SqlStr)
		s sc=result.Execute()
		i $$$ISERR(sc) q $$$OK
		while (result.Next())
		{
			s RowId=result.Data("RowId")
			s IndexId=result.Data("VE_VEI_DR")
			s IndexDesc=result.Data("VEIDesc")
			s Weight=result.Data("Weight")
			s Score=result.Data("VE_Score")
			s Remark=result.Data("VE_Remarks")
			s Date=..DL2H(result.Data("VE_Date"))
			s SubmitFlag=result.Data("VE_SubmitFlag")
			s:SubmitFlag="" SubmitFlag="N"
			s ReasonId=result.Data("VE_Reason_DR")
			s ReasonDesc=..GetReasonDesc(ReasonId)
			s ScoreEdited=$p(^DHCVEI(IndexId),"^",6)
			s:ScoreEdited="" ScoreEdited="N"
			s SysIndex=$p(^DHCVEI(IndexId),"^",4)
			s:SysIndex="" SysIndex="N"
			d OutPutIndexRow 
		}
		d result.Close()
		Quit $$$OK
	}
	else
	{
		s SqlStr = "SELECT VEI_RowId as Rowid,VEI_Desc as Description,VEI_Weight as Weight,VEI_SySIndex SysIndex,VEI_ScoreEdited FROM DHC_VendorEvaluationIndex"
	    s result=##class(%Library.ResultSet).%New()
		d result.RuntimeModeSet(0)
		d result.Prepare(SqlStr)
		s sc=result.Execute()
		i $$$ISERR(sc) q $$$OK
		while (result.Next())
		{
			s RowId = ""
			s IndexId = result.Data("Rowid")
			s IndexDesc = result.Data("Description")
		    s Weight = result.Data("Weight")
		    s SysIndex = result.Data("SysIndex")
		    s:SysIndex="" SysIndex="N"
		    s ScoreEdited = result.Data("VEI_ScoreEdited")
		    s:ScoreEdited="" ScoreEdited="N"
		    s Remark=""
		    i SysIndex="Y" d
		    .s tmp =..GetDeliveryTime(Vendor,Type,Pointer)
		    .s Remark = $p(tmp,"#",1)
		    .s Score = $p(tmp,"#",2)
		    s:Remark="" Score=5
			d OutPutIndexRow 
		}
		d result.Close()
		Quit $$$OK
	}
OutPutIndexRow
	s Data=$lb(RowId,IndexId,IndexDesc,Weight,SysIndex,ScoreEdited,Score,Remark,Date,SubmitFlag,ReasonId,ReasonDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description:根据单据保存供应商评价指标分数
/// Creator:	tsr
/// CreatDate:	2019-09-31
/// Table:		
/// Input:		单据ID,评价指标项分数列表
/// Return:		
ClassMethod SaveVenEvalByPointer(Pointer As %String, List As %String, Type As %String) As %Library.String
{
	n (Pointer,List,Type)
	s RtnObj=##class(RtnObj).%New()
 	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(List)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	i Pointer="" d RtnObj.Err(-1,"","请选择单据!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	s Vendor=""
	if Type="G" {	//入库
		s Vendor=$p(^DHCINGR(Pointer),"^",3)
	}elseif Type="P" {	//订单
		s Vendor=$p(^INPO(Pointer),"^",2)
	}else {
		s Vendor=""
	}
	i Vendor="" d RtnObj.Err(-1,"","此单据供应商为空,请重新选择!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	s RtnObj=..SaveVenEval(Vendor,List,Pointer,Type)
	q RtnObj.Json()
}

/// Description:保存供应商评价指标分数
/// Creator:	tsr
/// CreatDate:	2019-09-31
/// Table:		
/// Input:		供应商,评价指标项分数列表,单据ID,单据类型
/// Return:		
ClassMethod SaveVenEval(Vendor As %String, ListData As %String, Pointer As %String, Type As %String) As RtnObj
{
	n (Vendor,ListData,Pointer,Type)
	s RtnObj=##class(RtnObj).%New()
 	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(ListData)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj

	i Vendor="" d RtnObj.Err(-1,"","供应商为空,请重新选择!","",0)
	q:RtnObj.success'=0 RtnObj
	
	i Pointer="" d RtnObj.Err(-1,"","请选择单据!","",0)
	q:RtnObj.success'=0 RtnObj
	
	ts
	While (RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s IndexId=Obj.%Get("IndexId")
		s Score=Obj.%Get("Score")
		i Score>5 d RtnObj.Err(-3,"","每项指标满分为5分,请重新维护!","",0)
		q:RtnObj.success'=0
		s ReasonId=Obj.%Get("ReasonId")
		s Remark=Obj.%Get("Remark")
		s Date=+$H
		i RowId'="" d
		.&sql(Update DHC_VendorEvaluation set
			VE_APCVM_DR=:Vendor,VE_VEI_DR=:IndexId,VE_Score=:Score,VE_Remarks=:Remark,VE_Date=:Date,VE_Pointer=:Pointer,VE_Type=:Type,VE_Reason_DR=:ReasonId
			where %id=:RowId)
		.i SQLCODE'=0 d RtnObj.Err(-2,RowId,"保存供应商评价信息失败!")
		e  d
		.&sql(Insert into DHC_VendorEvaluation
			(VE_APCVM_DR,VE_VEI_DR,VE_Score,VE_Remarks,VE_Date,VE_Pointer,VE_Type,VE_Reason_DR)
			values(:Vendor,:IndexId,:Score,:Remark,:Date,:Pointer,:Type,:ReasonId))
		.i SQLCODE'=0 d RtnObj.Err(-2,"","保存供应商评价信息失败!")
		q:RtnObj.success'=0
	}
	
	i RtnObj.success'=0 tro  q RtnObj
	tc
	q RtnObj
}

/// Description:根据提交供应商评价指标分数
/// Creator:	tsr
/// CreatDate:	2019-09-31
/// Table:		
/// Input:		供应商,评价指标项分数列表,单据ID,单据类型
/// Return:		
ClassMethod SubmitEvaluation(List As %String) As %Library.String
{
	n (List)
	s RtnObj=##class(RtnObj).%New()
 	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(List)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()

	ts
	While (RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		i RowId="" d RtnObj.Err(-2,"","请先保存供应商评价信息!","",0)
		q:RtnObj.success'=0
		&sql(UPDATE DHC_VendorEvaluation SET VE_SubmitFlag='Y' WHERE VE_RowId=:RowId)
		i SQLCODE'=0 d RtnObj.Err(-3,RowId,"提交失败!")
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript: 查询评价指标对应扣分原因
/// Creater: tsr
/// CreateDate:	2017-05-18
/// Table: DHC_VenEvalReason
ClassMethod GetEvalReason(vei)
{
	n (vei)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT VEIR_RowId, VEIR_Code, VEIR_Desc, VEIR_Weight FROM DHC_VenEvalReason WHERE VEIR_VEI="_vei
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s json = ##class(web.DHCSTMHUI.Common.JsonObj).%New()
	While(result.Next())
	{
		s Rowid = result.Data("VEIR_RowId")
		s Code = result.Data("VEIR_Code")
		s Description = result.Data("VEIR_Desc")
	    s Weight = result.Data("VEIR_Weight")
		s tmp=Rowid_"^"_Code_"^"_Description_"^"_Weight
		s count = count+1
		d json.InsertRowData(tmp)
	}
	d result.Close()
	d json.getJsonData("RowId^Code^Desc^Weight:number",count)
	k json
}

/// Descript: 通过扣分项获取分数
/// Creater: tsr
/// CreateDate:	2017-07-24
/// Table: DHC_VenEvalReason
/// w ##class(web.DHCSTMHUI.DHCVendorEvaluationIndex).EvalScoreByReason(11)
ClassMethod EvalScoreByReason(reasons As %String)
{
	n (reasons)
	s score=5,fullScore=5
	q:reasons="" fullScore
	s len=$l(reasons,",")
	f i=1:1:len d
	.s reason=$p(reasons,",",i)
	.s weight=+$p(^DHCVEIR(reason),"^",3)
	.s score=score-(fullScore*weight)
	q:score<0 0
	q score
}

/// Descript: 通过扣分项ID串获取扣分项名称
/// Creater: tsr
/// CreateDate:	2017-07-24
/// Table: DHC_VenEvalReason
ClassMethod GetReasonDesc(reasons As %String)
{
	n (reasons)
	q:reasons="" ""
	s reasonDescs=""
	s len=$l(reasons,",")
	f i=1:1:len d
	.s reason=$p(reasons,",",i)
	.s reasonDesc=$p(^DHCVEIR(reason),"^",2)
	.i reasonDescs="" d
	..s reasonDescs=reasonDesc
	.e  d
	..s reasonDescs=reasonDescs_","_reasonDesc
	q reasonDescs
}

/// Descript: 通过扣分项ID获取扣分项Desc
/// Creater: tsr
/// CreateDate:	2017-07-24
/// Table: DHC_VenEvalReason
/// w ##class(web.DHCSTMHUI.DHCVendorEvaluationIndex).EvalReasonDescByReason("1,2,3")
ClassMethod EvalReasonDescByReason(reasons As %String)
{
	n (reasons)
	q:reasons="" ""
	s Descs=""
	s len=$l(reasons,",")
	f i=1:1:len d
	.s reason=$p(reasons,",",i)
	.s Desc=$p(^DHCVEIR(reason),"^",2)
	.i Descs="" d
	..s Descs=Desc
	.e  d
	..s Descs=Descs_","_Desc
	
	q Descs
}

}
