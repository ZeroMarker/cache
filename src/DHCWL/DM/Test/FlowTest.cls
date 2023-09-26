Class DHCWL.DM.Test.FlowTest Extends DHCWL.DM.Core.Flow
{

Method Flowing(ByRef fromData, ByRef toData) As %Boolean
{
  s toData("RecDep")=fromData("dim1")
  ;s toData("AdmType")=fromData("AdmType")
  s toData("fee")=1
  q 1
}

}
