Class DHCWL.Interface.MKPI.DimData Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Description：返回维度树需要的list
/// add by wk.2016-06-01
ClassMethod GetDimTreeList(ByRef json)
{
	n (json)
	s dimId=""
	s num=1
	for{
		s dimId=$o(^DHCWL.MKPI.MKPIDimTypeD(dimId))
		q:dimId=""
		s dimCode=$lg(^DHCWL.MKPI.MKPIDimTypeD(dimId),2)
		s dimDesc=$lg(^DHCWL.MKPI.MKPIDimTypeD(dimId),3)
		s dimInfor=dimCode_"-"_dimDesc
		s treeNod(num,"text")="'"_dimInfor_"'"
		s treeNod(num,"id")="'dim-"_dimId_"'"
		s treeNod(num,"cls")="'folder'"
		s treeNod(num,"leaf")="false"
		//s treeNod(num,"checked")="false"
		s num=num+1 
	}
	i $d(treeNod) d ##class(DHCWL.SysService.SetFilterService).MetrixToTreePanelJson(.treeNod,.json)
	q
}

/// Description：返回维度属性树需要的list
/// add by wk.2016-06-01
ClassMethod GetDimProTreeList(dimCode, ByRef json)
{
	n (dimCode,json)
	s dimId=""
	s num=1
	s dimId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(dimCode,"DHCWL.MKPI.MKPIDimType")
	s upDimProCode=""
	for{
		s upDimProCode=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimId,upDimProCode))
		q:upDimProCode=""
		s dimProId=""
		s dimProId=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimId,upDimProCode,dimProId))
		s dimProCode=$lg(^DHCWL.MKPI.DimPropertyD(dimProId),3)
		s dimProDesc=$lg(^DHCWL.MKPI.DimPropertyD(dimProId),4)
		s dimProInfor=dimProCode_"-"_dimProDesc
		s treeNod(num,"text")="'"_dimProInfor_"'"
		s treeNod(num,"id")="'dimPro-"_dimProId_"'"
		//s treeNod(num,"cls")="'folder'"
		s treeNod(num,"leaf")="true"
		s treeNod(num,"checked")="false"
		s num=num+1
	}
	i $d(treeNod) d ##class(DHCWL.SysService.SetFilterService).MetrixToTreePanelJson(.treeNod,.json)
	q
}

//d ##class(DHCWL.Interface.MKPI.DimData).GetDimStandardXML()

/*ClassMethod GetDimStandardXML()
{
	s dimSysList=##class(DHCWL.MKPIIO.DefaultOutService).GetAllDimProList()
	d ##class(DHCWL.MKPIIO.DefaultOutService).OutputMDIMToStream(dimSysList,.outStream)
	Set sc =##class(%XML.TextReader).ParseStream(outStream,.reader)
	if (reader="") {
	    w "导出错误!"
		q
	}
	s deli=##class(DHCWL.util.DirectoryFile).SetPathOS()
	s deli=$p(deli,"||",2)
	s tmp=##class(DHCWL.util.DirectoryFile).GetTempDir()
	i $e(tmp,$l(tmp))'=deli s tmp=tmp_deli
	//s tempFile=tmp_"dimStandardXML.xml"
	s tempFile="C:\dimStandardXML.xml"
	s result=##class(DHCWL.MKPIIO.DefaultOutService).TraverXmlToFile(reader,tempFile)
	if result=1{
		w "导出成功,标准版文件路径："_tempFile
	}else{
		w "导出失败!"
	}
}*/
/// Description：升级或者安装指标时，将维度属性激活状态关闭
/// add by wk.2017-02-23
/// d ##class(DHCWL.Interface.MKPI.DimData).ChangeSecDimProAct()
ClassMethod ChangeSecDimProAct()
{
	n
	q:'$d(^DHCWL.MKPI.SectionPropertyD)
	s secID=""
	for{
		s secID=$o(^DHCWL.MKPI.SectionPropertyD(secID))
		q:secID=""
		s actFlag=$lg(^DHCWL.MKPI.SectionPropertyD(secID),7)
		if (actFlag="Y"){
			s $li(^DHCWL.MKPI.SectionPropertyD(secID),7)="N"
		}
	}
	q
}

}
