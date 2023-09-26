Import SQLUser

/// 根据文件前缀或工程导出单个XML文件
Class web.DHCMedExportFiles Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 49;

/// w ##Class(web.DHCMedExportFiles).ExportByFileName("DHC-APP",$lb("User.DHCMed","User.DHCWMR","web.DHCMed","web.DHCWMR"),"E:\DHCMedicare")
/// w ##Class(web.DHCMedExportFiles).ExportByFileName("DHC-MEDSRC",$lb("DHCMed","DHCWMR"),"E:\DHCMedicare")
/// w ##Class(web.DHCMedExportFiles).ExportByFileName("LABSRC",$lb("DHCMed"),"E:\DHCMedicare")
ClassMethod ExportByFileName(aNameSpace, aFileNames, aFilePath)
{
	n (aNameSpace,aFileNames,aFilePath)
	s ret=0
	q:(aNameSpace="")||(aFileNames="")||(aFilePath="") ret
	
	s CurrentNS=$ZNSPACE
    s WebsrcNS=$LB("DHCAPP","WEBSOURCE","WEBSRC")
    s MedsrcNS=$LB("MEDSOURCE","MEDSRC","DHCMEDSRC")
	s LabsrcNS=$LB("LABSOURCE","LABSRC")
	s tmpNS=$$ALPHAUP^SSUTIL4(aNameSpace)
	q:(($listfind(WebsrcNS,tmpNS)<1)&&($listfind(MedsrcNS,tmpNS)<1)&&($listfind(LabsrcNS,tmpNS)<1)) ret
	
	//导WEBSRC-CLS文件
	i $listfind(WebsrcNS,tmpNS)>0 d
	.s clsFilePath1=aFilePath_"\WebsourceClass\User\"
	.s clsFilePath2=aFilePath_"\WebsourceClass\"
	.s:clsFilePath1["/" clsFilePath1=$tr(clsFilePath1,"\","/")
	.s:clsFilePath2["/" clsFilePath2=$tr(clsFilePath2,"\","/")
	.f Ind=1:1:$listlength(aFileNames) d
	..s tmp=$list(aFileNames,Ind)
	..s clsName=tmp
	..f  s clsName=$o(^oddDEF(clsName)) q:(clsName="")||($e(clsName,1,$l(tmp))'=tmp)  d
	...q:clsName="User.DHCMedicalRPaadm"
	...i $e(clsName,1,5)="User." d
	....s tmpName=$e(clsName,6,$l(clsName))
	....d $System.OBJ.Export(clsName_".cls",clsFilePath1_tmpName_".XML","")
	...i $e(clsName,1,4)="web." d
	....s tmpName=$e(clsName,5,$l(clsName))
	....d $System.OBJ.Export(clsName_".cls",clsFilePath2_tmpName_".XML","")
	
	//导MEDSRC-MAC文件
	i $listfind(MedsrcNS,tmpNS)>0 d
	.s macFilePath=aFilePath_"\MedsrcMac\"
	.s:macFilePath["/" macFilePath=$tr(macFilePath,"\","/")
	.ZN aNameSpace
	.f Ind=1:1:$listlength(aFileNames) d
	..s tmp=$list(aFileNames,Ind)
	..s macName=tmp
	..f  s macName=$o(^rMAC(macName)) q:(macName="")||($e(macName,1,$l(tmp))'=tmp)  d
	...d $System.OBJ.Export(macName_".mac",macFilePath_macName_".XML","")
	.ZN CurrentNS
	
	//导LABSRC-MAC文件
	i $listfind(LabsrcNS,tmpNS)>0 d
	.s macFilePath=aFilePath_"\LabsrcMac\"
	.s:macFilePath["/" macFilePath=$tr(macFilePath,"\","/")
	.ZN aNameSpace
	.f Ind=1:1:$listlength(aFileNames) d
	..s tmp=$list(aFileNames,Ind)
	..s macName=tmp
	..f  s macName=$o(^rMAC(macName)) q:(macName="")||($e(macName,1,$l(tmp))'=tmp)  d
	...d $System.OBJ.Export(macName_".mac",macFilePath_macName_".XML","")
	.ZN CurrentNS
	
	s ret=1
	q ret
}

/// w ##Class(web.DHCMedExportFiles).ExportByaPrjName("DHC-APP","Prj_DHCMedicare","E:\DHCMedicare1")
/// w ##Class(web.DHCMedExportFiles).ExportByaPrjName("DHC-MEDSRC","Prj_DHCMedicare","E:\DHCMedicare1")
/// w ##Class(web.DHCMedExportFiles).ExportByaPrjName("LABSRC","Prj_DHCMedicare","E:\DHCMedicare1")
ClassMethod ExportByaPrjName(aNameSpace, aPrjName, aFilePath)
{
	n (aNameSpace,aPrjName,aFilePath)
	s ret=0
	q:(aNameSpace="")||(aPrjName="")||(aFilePath="") ret
	
	s CurrentNS=$ZNSPACE
    s WebsrcNS=$LB("DHCAPP","WEBSOURCE","WEBSRC")
    s MedsrcNS=$LB("MEDSOURCE","MEDSRC","DHCMEDSRC")
	s LabsrcNS=$LB("LABSOURCE","LABSRC")
	s tmpNS=$$ALPHAUP^SSUTIL4(aNameSpace)
	q:(($listfind(WebsrcNS,tmpNS)<1)&&($listfind(MedsrcNS,tmpNS)<1)&&($listfind(LabsrcNS,tmpNS)<1)) ret
	
	//导WEBSRC-CLS文件
	i $listfind(WebsrcNS,tmpNS)>0 d
	.s clsFilePath=aFilePath_"\websrc\"
	.s:clsFilePath["/" clsFilePath=$tr(clsFilePath,"\","/")
	.s clsName=""
	.f  s clsName=$o(^oddPROJECT(aPrjName,"Items",clsName)) q:clsName=""  d
	..s tmp1=$o(^oddPROJECT(aPrjName,"Items",clsName,""))
	..q:(tmp1'="CLS")&&(tmp1'="MAC")
	..w clsName,!
	..d $System.OBJ.Export(clsName_".cls",clsFilePath_clsName_".XML","")
	
	//导MEDSRC-MAC文件
	i $listfind(MedsrcNS,tmpNS)>0 d
	.s macFilePath=aFilePath_"\mebsrc\"
	.s:macFilePath["/" macFilePath=$tr(macFilePath,"\","/")
	.ZN aNameSpace
	.s macName=""
	.f  s macName=$o(^oddPROJECT(aPrjName,"Items",macName)) q:macName=""  d
	..s tmp1=$o(^oddPROJECT(aPrjName,"Items",macName,""))
	..q:(tmp1'="CLS")&&(tmp1'="MAC")
	..w macName,!
	..d $System.OBJ.Export(macName,macFilePath_$e(macName,1,$l(macName)-4)_".XML","")
	.ZN CurrentNS
	
	//导LABSRC-MAC文件
	i $listfind(LabsrcNS,tmpNS)>0 d
	.s macFilePath=aFilePath_"\labsrc\"
	.s:macFilePath["/" macFilePath=$tr(macFilePath,"\","/")
	.ZN aNameSpace
	.s macName=""
	.f  s macName=$o(^oddPROJECT(aPrjName,"Items",macName)) q:macName=""  d
	..s tmp1=$o(^oddPROJECT(aPrjName,"Items",macName,""))
	..q:(tmp1'="CLS")&&(tmp1'="MAC")
	..w macName,!
	..d $System.OBJ.Export(macName,macFilePath_$e(macName,1,$l(macName)-4)_".XML","")
	.ZN CurrentNS
	
	s ret=1
	q ret
}

}
