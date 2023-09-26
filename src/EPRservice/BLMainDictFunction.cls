Class EPRservice.BLMainDictFunction Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// Creator：      LingChen
/// CreatDate：    2010-10-22
/// Description:   查询
/// Table：        
/// Input：          
/// Output：       EPRservice.dataset.MainRoleAllDataSet
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod SelectAll() As EPRservice.dataset.MainDictFunctionAllDataSet
{
	Set ds=##class(EPRservice.dataset.MainDictFunctionAllDataSet).%New()
	Quit ds
}

}
