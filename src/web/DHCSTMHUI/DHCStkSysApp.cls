Import sqluser

/// Descript:应用程序维护相关
/// Creater:	LiMingzhong
/// CreateDate:	2012-06-6
Class web.DHCSTMHUI.DHCStkSysApp Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	保存/更新应用程序
/// Creator:	wangjiabin
/// CreateDate:	2018-08-20
/// Table:		DHC_StkSysApp
/// Input:		数据串:rowid^代码^描述^程序类型(B,Q,S,M)
/// Output:		
/// Return:		RtnObj-Json
/// Other: w ##class(web.DHCSTMHUI.DHCStkSysApp).Save()
ClassMethod Save(Params As %String) As %Library.String
{
	n (Params,%session)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!").Json()
	
	s StkType=..sssCode()
	ts
	While(RtnObj.success=0){
		s RowObj=PJObj.%Pop()
		q:RowObj=""
		
		s RowId=RowObj.%Get("RowId")
		s Code=RowObj.%Get("Code")
		s Desc=RowObj.%Get("Desc")
		s Type=RowObj.%Get("Type")
		s:Type="" Type="B"	;默认模块类别为"业务"
		s SortNum=RowObj.%Get("SortNum")
		i ($$ALPHAUP^SSUTIL4(Code)="")||($$ALPHAUP^SSUTIL4(Desc)="") d RtnObj.Err(-2,RowId,"代码或名称不可为空!","",0)
		continue:RtnObj.success<0
		s TmpId=$o(^DHCSSA(0,"ACODE",$$ALPHAUP^SSUTIL4(Code),""))
		i (TmpId'="")&(TmpId'=RowId) d RtnObj.Err(-2,RowId,Code_" 代码重复!","",0)
		continue:RtnObj.success<0
		s TmpId=$o(^DHCSSA(0,"ADESC",$$ALPHAUP^SSUTIL4(Desc),""))
		i (TmpId'="")&(TmpId'=RowId) d RtnObj.Err(-2,RowId,Desc_" 名称重复!","",0)
		continue:RtnObj.success<0
		
		i RowId="" d
		.s AppObj=##class(User.DHCStkSysApp).%New()
		e  d
		.s AppObj=##Class(User.DHCStkSysApp).%OpenId(RowId)
		s AppObj.SSACode=Code
		s AppObj.SSADesc=Desc
		s AppObj.SSAGrpType=StkType
		s AppObj.SSAModuType=Type
		s AppObj.SSASortNum=SortNum
		s Sc=AppObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-10,RowId,"保存失败!")
		continue:RtnObj.success<0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:	应用系统管理
/// Creater:	LiMingzhong
/// CreateDate:	2012-06-6
/// Table:DHC_StkSysApp
/// Input:rowid
/// Output:		
/// Return：0 – 成功，非0 ：失败
ClassMethod Delete(rowid As %String) As %Library.String
{
	n (rowid)
 	
 	;不能为空项
 	q:rowid="" ""
 	s $ZT=..sssError()
 	&sql(Delete from DHC_StkSysApp where SSA_RowID=:rowid)
 	q SQLCODE
}

/// Descript:	查询应用系统管理
/// Creator:	wangjiabin
/// CreateDate:	2018-08-18
/// Table:		DHC_StkSysApp
/// Input:
/// Output:		
/// Return：应用系统管理Json字符串
/// Other:w ##class(web.DHCSTMHUI.DHCStkSysApp).SelectAll()
ClassMethod SelectAll()
{
	new
	s result = ##class(%Library.ResultSet).%New()
	s StkType=..sssCode()
	s sqlStr = "select SSA_RowID as RowId,SSA_Code as Code,SSA_Desc as Description,SSA_ModuType as ModuType,SSA_SortNum SortNum from DHC_StkSysApp"
		_" where SSA_RowID>0 and SSA_GrpType="_"'"_StkType_"' order By SortNum"
	d result.Prepare(sqlStr)
	d result.Execute()
	s Count = 0
	s json = ##class(web.DHCSTMHUI.Common.JsonObj).%New()
	While(result.Next())
	{
		s RowId = result.Data("RowId")
		s Code = result.Data("Code")
		s Desc = result.Data("Description")
		s Type = result.Data("ModuType")
		s SortNum = result.Data("SortNum")
		s DataStr=RowId_"^"_Code_"^"_Desc_"^"_Type_"^"_SortNum
		s Count = Count+1
		d json.InsertRowData(DataStr)
	}
	d result.Close()
	d json.getJsonData("RowId^Code^Desc^Type^SortNum",Count)
	k json
	q ""
}

}
