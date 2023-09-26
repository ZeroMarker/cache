Class EMRservice.BL.BLMainDictFunction Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// Creator：      LingChen
/// CreatDate：    2010-10-22
/// Description:   查询
/// Table：        
/// Input：          
/// Output：       EMRservice.dataset.EMainRoleAllDataSet
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod SelectAll() As EMRservice.dataset.EMainDictFunctionAllDataSet
{
	Set ds=##class(EMRservice.dataset.EMainDictFunctionAllDataSet).%New()
	Quit ds
}

Query SelectAll() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,FuncName:%String,FuncDesc:%String,ParentID:%String,Type:%String,Notes:%String")
{
	SELECT ID,FuncName,FuncDesc,ParentID,Type,Notes
	FROM EMRmeta.MainDictFunction
	ORDER BY ID
}

/// 添加项
ClassMethod AddDictFunction(ADictFunction As EMRservice.entity.EMainDictFunction) As %String
{
	
	s ret = "0"
	s objDictFunction = ##Class(EMRmeta.MainDictFunction).%New()
	s objDictFunction.FuncName =ADictFunction.FuncName
	s objDictFunction.FuncDesc =ADictFunction.FuncDesc
	s objDictFunction.ParentID =ADictFunction.ParentID
	s objDictFunction.Type =ADictFunction.Type
	s objDictFunction.Notes =ADictFunction.Notes
	if (objDictFunction.%Save())
	{
		s ret = objDictFunction.%Id()
	}
	d objDictFunction.%Close()
	q ret
}

/// 清除数据
ClassMethod ClearData()
{
	k ^DHCEMRM.MainDictFunctionI
	k ^DHCEMRM.MainDictFunctionD
}

/// 设为无效
ClassMethod DelDictFunction(RowID As %String) As %String
{
	s ret = "0"
	q:(RowID="") ret
	//原有数据进行“删除”,将数据ActiveFlag设置为0
	s obj = ##class(EMRmeta.MainDictFunction).%OpenId(RowID)
	q:(obj="") ret
	/*
	s strFuncName = obj.FuncName
	s RoleID = ""
	&SQL(select id into :RoleID from EMRmeta.MainRoleFunction where FuncName =:strFuncName)
    d ##class(EMRmeta.MainRoleFunction).%DeleteId(RoleID)
    */
	d ##class(EMRmeta.MainDictFunction).%DeleteId(RowID)
	d obj.%Close()
	s ret = "1"
	q ret
}

}
