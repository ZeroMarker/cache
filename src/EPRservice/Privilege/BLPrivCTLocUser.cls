Class EPRservice.Privilege.BLPrivCTLocUser Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// Output：EPRservice.dataset.Privilege.EPrivCTLocUserDataset
/// added by Jiangew on 2012-11-15
ClassMethod GetCTLocUserList() As EPRservice.dataset.Privilege.EPrivCTLocUserDataset
{
	Set ds=##class(EPRservice.dataset.Privilege.EPrivCTLocUserDataset).%New()
	Quit ds
}

}
