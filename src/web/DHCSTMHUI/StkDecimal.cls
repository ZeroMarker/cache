Import sqluser

/// Descript:小数规则维护
/// Creater:	wfg
/// CreateDate:	2018-09-28
Class web.DHCSTMHUI.StkDecimal Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppTable [ Final ] = "DHC_StkDecimal";

/// Descript:	保存/更新小数规则信息
/// Creater:	wfg
/// CreateDate:	2018-09-28
/// Table:DHC_StkDecimal
/// Input:数据串:rowid^规则名称^规则描述^是否使用,rowid^规则名称^规则描述^是否使用
/// Output:		
/// Return："" – 成功，
/// 非空：失败
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
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!").Json()
	s StkType=..sssCode()
	ts
	While(RtnObj.success=0){
		s RowObj=PJObj.%Pop()
		q:RowObj=""
		s RowId=RowObj.%Get("RowId")
		s Name=RowObj.%Get("Name")
		s Desc=RowObj.%Get("Desc")
		s UseFlag=RowObj.%Get("UseFlag")
		i ($$ALPHAUP^SSUTIL4(Name)="")||($$ALPHAUP^SSUTIL4(Desc)="") d RtnObj.Err(-2,RowId,"代码或名称不可为空!","",0)
		continue:RtnObj.success<0
		s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("CODE",Name,..#AppTable,gHospId,RowId)
		i ret>0 d RtnObj.Err(-2,RowId,Desc_" 代码重复!","",0)
		continue:RtnObj.success<0
		s OpType="",OldJsonStr=""
		i RowId="" d
		.s DHCStkDecimalObj=##class(User.DHCStkDecimal).%New()
		.s OpType="A"
		e  d
		.s DHCStkDecimalObj=##Class(User.DHCStkDecimal).%OpenId(RowId)
		.s OpType="U"
		.s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_StkDecimal",RowId)
		s DHCStkDecimalObj.SDName=Name
		s DHCStkDecimalObj.SDDesc=Desc
		s DHCStkDecimalObj.SDUseFlag=UseFlag
		s DHCStkDecimalObj.SDType=StkType
		s Sc=DHCStkDecimalObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-10,RowId,"保存失败!")
		continue:RtnObj.success<0
		s RowId=DHCStkDecimalObj.%Id()
		//保存医院关联
		s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP(..#AppTable,RowId,gHospId)
		i ret<0 d RtnObj.Err(-11,"","关联医院失败"_ret)
		continue:RtnObj.success<0
		s RtnObj=##class(Log).SaveLog("DHC_StkDecimal","User.DHCStkDecimal","小数规则信息",RowId,Desc,OpType,"",OldJsonStr)
		continue:RtnObj.success<0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:	删除小数规则信息
/// Creater:	wfg
/// CreateDate:	2018-09-28
/// Table:DHC_StkDecimal
/// Input:rowid
/// Output:		
/// Return：0 – 成功，非0 ：失败
ClassMethod Delete(rowid As %String) As %Library.String
{
	n (rowid,%session)
	q:rowid="" ""
	s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_StkDecimal",rowid)
	s Err=0
	&sql(Delete from DHC_StkDecimal where SD_Rowid=:rowid)
	i SQLCODE'=0  d
	.s Err=-1
	e  d
	.d ##class(Log).SaveLog("DHC_StkDecimal","User.DHCStkDecimal","小数规则信息",rowid,"","D",JsonStr)
	q Err
}

/// Descript:	查询小数规则信息
/// Creater:	wfg
/// CreateDate:	2018-09-28
/// Table:DHC_StkDecimal
/// Input:
/// Output:		
/// Return：小数规则信息
ClassMethod SelectAll(Params As %String)
{
	n (Params,%session)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:PJObj.%FromJSON(Params)'=0 $$$OK

	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s gHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)

	s result = ##class(%Library.ResultSet).%New()
	s type=..sssCode()
	s sqlStr = "SELECT SD_Rowid as Rowid,SD_Name,SD_Desc,SD_UseFlag"_  
	" FROM DHC_StkDecimal where SD_Type='"_type_"'"
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s resultString = ""
	s json = ##class(web.DHCSTMHUI.Common.JsonObj).%New()
	While(result.Next())
	{	
		s Rowid = result.Data("Rowid")
		CONTINUE:+Rowid=0
		//判断医院权限
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag(..#AppTable,Rowid,gHospId)
		continue:ShowDataFlag="N"
		s Name = result.Data("SD_Name")
		s Desc = result.Data("SD_Desc")
		s UseFlag = result.Data("SD_UseFlag")

		s tmp=Rowid_"^"_Name_"^"_Desc_"^"_UseFlag
		s count = count+1		
		d json.InsertRowData(tmp)
	}
	d result.Close()
	d json.getJsonData("RowId^Name^Desc^UseFlag",count)
	k json
	Q ""
}

}
