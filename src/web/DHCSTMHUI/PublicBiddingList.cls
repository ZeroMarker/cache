Import sqluser

Class web.DHCSTMHUI.PublicBiddingList Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// Description:插入或更新数据
/// Creator:	wangjiabin
/// CreateDate:	2018-10-31
/// Table:		DHC_PublicBiddingList
/// Input:		JsonStr
/// Output:		RtnObj.Json()
/// w ##class(web.DHCSTMHUI.PublicBiddingList).Save("[{""Code"":""3"",""Description"":""测试"",""Date"":""2018-10-23"",""Tenderee"":"""",""StartDate"":""2025-10-31"",""EndDate"":"""",""Level"":"""",""Remark"":"""",""ActiveFlag"":""N""}]")
ClassMethod Save(Params As %String, Main As %String) As %Library.String
{
	n (Params,Main,%session)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	
	s MainPJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:MainPJObj.%FromJSON(Main)'=0 RtnObj.Err(-1,"","入参解析失败!").Json()
	s gHospId=MainPJObj.%Get("gHospId")
	s pHospId=MainPJObj.%Get("BDPHospital")
	s gHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success<0 RtnObj.Json()
	
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s RowId=Obj.%Get("RowId")
		s Code=Obj.%Get("Code")
		s Desc=Obj.%Get("Description")
		s Type=..sssCode()
		
		s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("CODE",Code,"DHC_PublicBiddingList",gHospId,RowId)
		i ret>0 d RtnObj.Err(-2,RowId,Code_" 代码重复!","",0)
		continue:RtnObj.success<0
		s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",Desc,"DHC_PublicBiddingList",gHospId,RowId)
		i ret>0 d RtnObj.Err(-2,RowId,Desc_" 名称重复!","",0)
		continue:RtnObj.success<0
		
		s ObjStr=Obj.%ToJSON()
		i RowId'="" d
		.s RtnObj=..Update(ObjStr)
		e  d
		.s RtnObj=..Insert(ObjStr,gHospId)
		continue:RtnObj.success'=0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:   新增
/// CreateDate: 2018-10-31
/// Input:
/// Output:     
/// Return：rowid
ClassMethod Insert(Params, gHospId) As RtnObj [ Private ]
{
	n (Params,gHospId,%session)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"","Insert:参数接触错误!")
	
	s Code=PJObj.%Get("Code")
	s Description=PJObj.%Get("Description")
	s Date=PJObj.%Get("Date")
	s Date=..DH2L(Date)
	s Tenderee=PJObj.%Get("Tenderee")
	s StartDate=PJObj.%Get("StartDate")
	s StartDate=..DH2L(StartDate)
	s EndDate=PJObj.%Get("EndDate")
	s EndDate=..DH2L(EndDate)
	s LevelId=PJObj.%Get("LevelId")
	s Remark=PJObj.%Get("Remark")
	s Active=PJObj.%Get("ActiveFlag")
	
	i (Code="")||(Description="") q RtnObj.Err(-1,"","必填项不可为空","",0)
	
	s Type=..sssCode()
	&sql(Insert into DHC_PublicBiddingList
		(DHCPBL_Code,DHCPBL_Desc,DHCPBL_Date,DHCPBL_Tenderee,DHCPBL_EfficDateFrom,
		DHCPBL_EfficDateTo,DHCPBL_Level,DHCPBL_Remark,DHCPBL_ActiveFlag,DHCPBL_Type)
		values
		(:Code,:Description,:Date,:Tenderee,:StartDate,
		:EndDate,:LevelId,:Remark,:Active,:Type)
	)
	i SQLCODE'=0 q RtnObj.Err(-2,"","Insert失败:"_SQLCODE_":"_$g(%msg))
	s RowId=$p(%ROWID,$c(1))
	
	//保存医院关联
	s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("DHC_PublicBiddingList",RowId,gHospId)
	i ret<0 d RtnObj.Err(-11,"","关联医院失败"_ret)
	q:RtnObj.success<0 RtnObj
	s RtnObj=##class(Log).SaveLog("DHC_PublicBiddingList","User.DHCPublicBiddingList","招标轮次信息",RowId,Description,"A")
	q:RtnObj.success<0 RtnObj
	s RtnObj.rowid=RowId
	q RtnObj
}

/// Descript:   更新
/// Creater:    zhangxiao
/// CreateDate: 2017-8-10
/// Table:DHC_PublicBiddingList
/// Input:
/// Output:     
/// Return：
ClassMethod Update(Params) As RtnObj [ Private ]
{
	n (Params,%session)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s RowId=PJObj.%Get("RowId")
	s Code=PJObj.%Get("Code")
	s Description=PJObj.%Get("Description")
	s Date=PJObj.%Get("Date")
	s Date=..DH2L(Date)
	s Tenderee=PJObj.%Get("Tenderee")
	s StartDate=PJObj.%Get("StartDate")
	s StartDate=..DH2L(StartDate)
	s EndDate=PJObj.%Get("EndDate")
	s EndDate=..DH2L(EndDate)
	s LevelId=PJObj.%Get("LevelId")
	s Remark=PJObj.%Get("Remark")
	s Active=PJObj.%Get("ActiveFlag")
	
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_PublicBiddingList",RowId)
	&sql(Update DHC_PublicBiddingList
		set DHCPBL_Code=:Code,DHCPBL_Desc=:Description,DHCPBL_Date=:Date,DHCPBL_Tenderee=:Tenderee,DHCPBL_EfficDateFrom=:StartDate,
		DHCPBL_EfficDateTo=:EndDate,DHCPBL_Level=:LevelId,DHCPBL_Remark=:Remark,DHCPBL_ActiveFlag=:Active
		where DHCPBL_Rowid=:RowId
	)
	i SQLCODE'=0 q RtnObj.Err(-1,RowId,"Update失败!",Params)
	s RtnObj=##class(Log).SaveLog("DHC_PublicBiddingList","User.DHCPublicBiddingList","招标轮次信息",RowId,Description,"U","",OldJsonStr)
	q RtnObj
}

///  Descript:   删除招标信息
/// Creater:     zhangxiao
/// CreateDate: 2017-8-10
/// Table:DHC_PublicBiddingList
/// Input:rowid
/// Output:     
/// Return：0 – 成功，非0 ：失败
ClassMethod Delete(rowid As %String) As %Library.String
{
	n (rowid,%session)
	q:rowid="" ""
	s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_PublicBiddingList",rowid)
	&sql(Delete from DHC_PublicBiddingList where DHCPBL_Rowid=:rowid)
	q:SQLCODE'=0 SQLCODE
	d ##class(Log).SaveLog("DHC_PublicBiddingList","User.DHCPublicBiddingList","招标信息",rowid,"","D",JsonStr)
	q 0
}

/// Descript:	查询招标信息
/// Creater:	qiushengxin
/// CreateDate:	20180808
/// Table: DHC_PublicBiddingList
/// Input:
/// Output:		
/// Return：招标信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.PublicBiddingList","SelectAll","RowId","Desc")
Query SelectAll(Params) As Query(ROWSPEC = "RowId,Code,Description,Date,Tenderee,StartDate,EndDate,LevelId,Level,Remark,ActiveFlag") [ SqlProc ]
{
}

ClassMethod SelectAllExecute(ByRef qHandle As %Binary, Params) As %Status
{
	n (qHandle,Params,%session)

	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s gHospId=PJobj.%Get("gHospId")
	s pHospId=PJobj.%Get("BDPHospital")
	s gHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s Result=##class(%Library.ResultSet).%New()
	s Type=..sssCode()
	s SqlStr = "select DHCPBL_Rowid as RowId, DHCPBL_Code as Code,DHCPBL_Desc as Description, DHCPBL_Date,DHCPBL_Tenderee,DHCPBL_EfficDateFrom,DHCPBL_EfficDateTo,DHCPBL_Level,DHCPBL_Remark,DHCPBL_ActiveFlag from DHC_PublicBiddingList where DHCPBL_Type="_"'"_Type_"'"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId=Result.Data("RowId")
		CONTINUE:+RowId=0
		//判断医院权限
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_PublicBiddingList",RowId,gHospId)
		continue:ShowDataFlag="N"
		s Code=Result.Data("Code")
		s Description=Result.Data("Description")
		s Date=Result.Data("DHCPBL_Date")
		s Date=..DL2H(Date)
		s Tenderee=Result.Data("DHCPBL_Tenderee")
		s StartDate=Result.Data("DHCPBL_EfficDateFrom")
		s StartDate=..DL2H(StartDate)
		s EndDate=Result.Data("DHCPBL_EfficDateTo")
		s EndDate=..DL2H(EndDate)
		s LevelId=Result.Data("DHCPBL_Level")
		s Level=$s(LevelId'="":$p($g(^DHCITMPBL(LevelId)),"^",2),1:"")
		i Level="" s LevelId=""
		s Remark=Result.Data("DHCPBL_Remark")
		s ActiveFlag=Result.Data("DHCPBL_ActiveFlag")
		d OutPutRow
	}
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,Code,Description,Date,Tenderee,
		StartDate,EndDate,LevelId,Level,Remark,
		ActiveFlag)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
