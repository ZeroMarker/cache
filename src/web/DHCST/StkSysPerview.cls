Import sqluser

/// Descript:权限设置
/// Creater:	LiMingzhong
/// CreateDate:	2012-06-6
Class web.DHCST.StkSysPerview Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:	查询权限
/// Creater:	LiMingzhong
/// CreateDate:	2012-6-6
/// Table:DHC_StkSysPerview
/// Input:
/// Output:		
/// Return：权限Json字符串
/// Other:w ##class(web.DHCST.StkSysPerview).SelectAll()
ClassMethod SelectAll()
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select SSP_RowID as RowId,SSP_Point as Point,SSP_Type as Type,SSP_STCUS_Dr,SSP_Level from DHC_StkSysPerview where SSP_RowID>0"
	d result.Prepare(sqlStr)
	d result.Execute()
	;
	s count = 0
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{	
		s RowId = result.Data("RowId")
		s Code = result.Data("Code")
		s Desc = result.Data("Description")
		s Type = result.Data("ModuType")
		s tmp=RowId_"^"_Code_"^"_Desc_"^"_Type
		s count = count+1		
		d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RowId^Code^Desc^Type",count)
	k json
	Q resultString
}

}
