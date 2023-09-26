Import sqluser

Class web.CSSDHUI.Tools.InputHospData Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/**
CSSD_Parameter               --User.CSSDParameter
CSSD_CodeDict                --User.CSSDCodeDict
CSSD_Package                 --User.CSSDPackage
CSSD_PackageClass            --User.CSSDPackageClass
CSSD_Item                    --User.CSSDItem
CSSD_BindLoc                 --User.CSSDBindLoc
CSSD_BaseCode                --User.CSSDBaseCode
CSSD_CleanType               --User.CSSDCleanType
CSSD_Material                --User.CSSDMaterial
CSSD_MachineConfig           --User.CSSDMachineConfig
CSSD_CleanItmReason          --User.CSSDCleanItmReason
CSSD_MachineConsumeReason    --User.CSSDMachineConsumeReason
CSSD_RecallReason            --User.CSSDRecallReason
CSSD_SteCheckReason          --User.CSSDSteCheckReason
CSSD_SterType                --User.CSSDSterType
CSSD_Ven                     --User.CSSDVen
*/
/// w ##class(web.CSSDHUI.Tools.InputHospData).InputHospData(3)
ClassMethod InputHospData(HospId As %String) As %String
{
	n (HospId)
	s rowid=""
	s ret=1
	ts
	f  s rowid=$O(^User.CSSDParameterD(rowid)) q:(rowid="")||(+ret<0)  d
	.s ret=##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("CSSD_Parameter",rowid,HospId)
	i +ret<0 tro
	q:+ret<0 ret
	s rowid=""
	f  s rowid=$O(^User.CSSDCodeDictD(rowid)) q:(rowid="")||(+ret<0)  d
	.s ret=##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("CSSD_CodeDict",rowid,HospId)
	i +ret<0 tro
	q:+ret<0 ret
	s rowid=""
	f  s rowid=$O(^User.CSSDPackageD(rowid)) q:(rowid="")||(+ret<0)  d
	.s ret=##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("CSSD_Package",rowid,HospId)
	i +ret<0 tro
	q:+ret<0 ret
	s rowid=""
	f  s rowid=$O(^User.CSSDPackageClassD(rowid)) q:(rowid="")||(+ret<0)  d
	.s ret=##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("CSSD_PackageClass",rowid,HospId)
	i +ret<0 tro
	q:+ret<0 ret
	s rowid=""
	f  s rowid=$O(^User.CSSDItemD(rowid)) q:(rowid="")||(+ret<0)  d
	.s ret=##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("CSSD_Item",rowid,HospId)
	i +ret<0 tro
	q:+ret<0 ret
	s rowid=""
	f  s rowid=$O(^User.CSSDBindLocD(rowid)) q:(rowid="")||(+ret<0)  d
	.s ret=##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("CSSD_BindLoc",rowid,HospId)
	i +ret<0 tro
	q:+ret<0 ret
	s rowid=""
	f  s rowid=$O(^User.CSSDBaseCodeD(rowid)) q:(rowid="")||(+ret<0)  d
	.s ret=##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("CSSD_BaseCode",rowid,HospId)
	i +ret<0 tro
	q:+ret<0 ret
	s rowid=""
	f  s rowid=$O(^User.CSSDCleanTypeD(rowid)) q:(rowid="")||(+ret<0)  d
	.s ret=##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("CSSD_CleanType",rowid,HospId)
	i +ret<0 tro
	q:+ret<0 ret
	s rowid=""
	f  s rowid=$O(^User.CSSDMaterialD(rowid)) q:(rowid="")||(+ret<0)  d
	.s ret=##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("CSSD_Material",rowid,HospId)
	i +ret<0 tro
	q:+ret<0 ret
	s rowid=""
	f  s rowid=$O(^User.CSSDMachineConfigD(rowid)) q:(rowid="")||(+ret<0)  d
	.s ret=##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("CSSD_MachineConfig",rowid,HospId)
	i +ret<0 tro
	q:+ret<0 ret
    s rowid=""
	f  s rowid=$O(^User.CSSDCleanItmReasonD(rowid)) q:(rowid="")||(+ret<0)  d
	.s ret=##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("CSSD_CleanItmReason",rowid,HospId)
	i +ret<0 tro
	q:+ret<0 ret
	s rowid=""
	f  s rowid=$O(^User.CSSDMachineConsumeReasonD(rowid)) q:(rowid="")||(+ret<0)  d
	.s ret=##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("CSSD_MachineConsumeReason",rowid,HospId)
	i +ret<0 tro
	q:+ret<0 ret
	s rowid=""
	f  s rowid=$O(^User.CSSDRecallReasonD(rowid)) q:(rowid="")||(+ret<0)  d
	.s ret=##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("CSSD_RecallReason",rowid,HospId)
	i +ret<0 tro
	q:+ret<0 ret
	s rowid=""
	f  s rowid=$O(^User.CSSDSteCheckReasonD(rowid)) q:(rowid="")||(+ret<0)  d
	.s ret=##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("CSSD_SteCheckReason",rowid,HospId)
	i +ret<0 tro
	q:+ret<0 ret
	s rowid=""
	f  s rowid=$O(^User.CSSDSterTypeD(rowid)) q:(rowid="")||(+ret<0)  d
	.s ret=##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("CSSD_SterType",rowid,HospId)
	i +ret<0 tro
	q:+ret<0 ret
	s rowid=""
	f  s rowid=$O(^User.CSSDVenD(rowid)) q:(rowid="")||(+ret<0)  d
	.s ret=##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("CSSD_Ven",rowid,HospId)
	i +ret<0 tro
	q:+ret<0 ret
	tc
	q ret
}

}
