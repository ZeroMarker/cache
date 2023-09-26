Class web.DHCST Extends %RegisteredObject
{

ClassMethod Test11()
{
	s Soap=##Class(DHCENS.DRUG.BS.SOAP.WebENSDRUGServiceSoap).%New()  
	s Input="<Request><Drug><PhacID >70951</ PhacID></Drug></Request>" 
	s RetStr=Soap.IPDrugSend(Input)    
	//s Input="<Request><Drug><PhdID>204625</PhdID></Drug></Request>"
	//s RetStr=Soap.OPDrugSend(Input)
	s reader = ##class(%XML.Reader).%New()
	s sc=reader.OpenString(RetStr)
	d reader.Correlate("Response","web.DHCSTENSMSGPH")
	s RetCode="", RetContent=""
	While (reader.Next(.obj,.sc)) {
		s RetCode =obj.ResultCode
		s RetContent=obj.ResultContent
	}
	i RetCode=0 d
	.w "OK",!
	q 0
}

// 获取住院药房组件

// w ##class(web.DHCST).GetComDHCPha()

ClassMethod GetComDHCPha(path)
{
	 k ^TMPST("Export","DHCPha")
	 s flag="dhcpha.%"
	 &sql(declare x1 cursor for select name from websys.component where name like :flag)
	 &sql(open x1)
	 k comlist($j)
	 s n=0
	 f  &sql(fetch x1 into :comname) q:SQLCODE  d
	 .s n=n+1
	 .s comlist($j,n)=comname
	 .s ^TMPST("Export","DHCPha",n)=comname
	 .w !,comname
	 .
	 &sql(close x1)
	 
	 f i=1:1:n  d
	 .s cn=comlist($j,i)
	 .
	 .
	 .d ##class(web.Util.UtilService).GetExportComponents(cn,path)
	 q "........OVER........"
}

// 获取门诊药房组件

// w ##class(web.DHCST).GetComDHCOut()

ClassMethod GetComDHCOut(path)
{
	 k ^TMPST("Export","DHCOut")
	 s flag="DHCOutPh%"
	 &sql(declare x2 cursor for select name from websys.component where name like :flag)
	 &sql(open x2)
	 k comlist($j)
	 s n=0
	 f  &sql(fetch x2 into :comname) q:SQLCODE  d
	 .s n=n+1
	 .s comlist($j,n)=comname
	 .s ^TMPST("Export","DHCOut",n)=comname
	 .w !,comname
	 .
	 &sql(close x2)
	 f i=1:1:n  d
	 .s cn=comlist($j,i)
	 .d ##class(web.Util.UtilService).GetExportComponents(cn,path)
	 q "........OVER........"
}

// 获取配液组件

// w ##class(web.DHCST).GetComDHCPIVA()

ClassMethod GetComDHCPIVA()
{
	 k ^TMPST("Export","DHCPIVA")
	 s flag="DHCST.PIVA%"
	 &sql(declare x3 cursor for select name from websys.component where name like :flag)
	 &sql(open x3)
	 k comlist($j)
	 s n=0
	 f  &sql(fetch x3 into :comname) q:SQLCODE  d
	 .s n=n+1
	 .s comlist($j,n)=comname
	 .s ^TMPST("Export","DHCPIVA",n)=comname
	 .w !,comname
	 .
	 &sql(close x3)
	 f i=1:1:n  d
	 .s cn=comlist($j,i)
	 .d ##class(web.Util.UtilService).GetExportComponents(cn,"D:\DHCPIVA\")
	 q "........OVER........"
}

// 导入住院药房组件

// s path="D:\dhcpha\"

ClassMethod PutComDHCPha(path)
{
	 s n=""
	 f  s n=$o(^TMPST("Export","DHCPha",n)) q:n=""  d
	 .s comname=^TMPST("Export","DHCPha",n)
	 .
	 .s comname=comname_".xml"
	 .s comname=path_comname
	 .w !,comname
	 .D ##Class(web.Util.UtilService).PutComponent(comname)
	 q "........OVER........"
}

// 导入门诊药房组件

// s path="D:\DHCOut\"

ClassMethod PutComDHCOut(path)
{
	 
	 s n=""
	 f  s n=$o(^TMPST("Export","DHCOut",n)) q:n=""  d
	 .s comname=^TMPST("Export","DHCOut",n)
	 .s comname=comname_".xml"
	 .s comname=path_comname
	 .w !,comname
	 .D ##Class(web.Util.UtilService).PutComponent(comname)
	 q "........OVER........"
}

// 导入配液组件

// s path="D:\DHCPIVA\"

ClassMethod PutComDHCPIVA(path)
{
	 s n=""
	 f  s n=$o(^TMPST("Export","DHCPIVA",n)) q:n=""  d
	 .s comname=^TMPST("Export","DHCPIVA",n)
	 .
	 .s comname=comname_".xml"
	 .//q:comname'="DHCST.PIVA.BATTIME.xml"
	 .s comname=path_comname
	 .w !,comname
	 .D ##Class(web.Util.UtilService).PutComponent(comname)
	 q "........OVER........"
}

/// Description:   导出指定NameSpace下的CLASS清单,到文本文件。(只导web.DHCST*.cls)
/// 
/// Output：       对输出参数的说明
/// Return：       函数返回值的说明
/// Others：       其它说明
/// D ##Class(web.DHCST).ShowClasses("DHC-APP","D:\stclass.txt")
ClassMethod ShowClasses(qspec As %String = "", filename) As %Status
{
	; Name:Super:Hidden:Datatype:System:Final:Persistent:Serial:TimeChanged:
	s sc=$$$qualifierParse("ShowClassAndObject",.qspec,.qstruct) q:$$$ISERR(sc) sc
	
	s fh=$$$qualifierGetValue(qstruct,"hidden")  ; show hidden classes
	s fs=$$$qualifierGetValue(qstruct,"system")  ; show system classes
	s fd=$$$qualifierGetValue(qstruct,"detail")  ; show details

	s stream=##class(%FileCharacterStream).%New()
	s stream.Filename=filename
	d stream.TranslateTableSet("UTF8")
	s result=##class(%ResultSet).%New("%ClassDefinition.ClassInfo")
	d result.Execute()
	f  Quit:result.Next()=0  Do
	.; filter out classes
	.s name=result.GetDataByName("Name")
	.q:name["%"  d
	.q:$p(name,".",1)="csp"  d
	.q:$p(name,".",1)="csr"  d
	.q:$p(name,".",1)="custom"  d
	.q:$p(name,".",1)="XML"  d
	.q:$p(name,".",1)="websys"  d
	.q:$p(name,".",2)'["DHCST"  d
	.q:$p(name,".",1)="User"  d
	.s cs=result.GetDataByName("System")
	.s ch=result.GetDataByName("Hidden")
	.s tn=result.GetDataByName("SqlTableName")
	.s show=('cs)&('ch)!(cs&fs)!(ch&fh)
	.i show Write result.GetDataByName("Name") Write:fd ?25,$zdt(result.GetDataByName("TimeChanged")) Write result.GetDataByName("SqlTableName") Write !
	.//d stream.WriteLine(result.GetDataByName("Name")_"	"_result.GetDataByName("SqlTableName"))
	.d stream.WriteLine(result.GetDataByName("Name"))
	d stream.SaveStream()
	d stream.%Close()
	Quit $$$OK
}

/// CreatDate：    2010-03-23
/// Description:   导出CLASS清单文件中类文件到指定路径下
/// 
/// Input:         FileListPath:类清单文件classlist.txt;ExportFilesPath导出目录
/// Output：       对输出参数的说明
/// Return：       函数返回值的说明
/// Others：       其它说明
/// D ##Class(web.Util.UtilService).ExportClassByFileList("D:\stclass.txt","D:\stclass\")
ClassMethod ExportClassByFileList(FileListPath As %String, ExportFilesPath)
{
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=FileListPath
	s FileCnt=1

	While 'Stream.AtEnd {
		s Line=Stream.ReadLine()
		w Line,!
		s ClsName=Line_".cls"
	    s ClsPath=ExportFilesPath_Line_".xml"
	    d $system.OBJ.Export(ClsName,ClsPath)
	    s FileCnt=FileCnt+1
	}
	w "Summary: "_FileCnt_" files have been exported to the "_ExportFilesPath,!
	quit
}

// w ##class(web.DHCST).ExportIPClassforSVN("web","D:\dhcphacls\")

// 导出住院药房相关类,配液和公共类除外

ClassMethod ExportIPClassforSVN(ackagename As %String, path As %String)
{
    s arrarylistcls=""
    s clsname="",clspath=""
	w $system.OBJ.GetPackageList(.arrarylistcls,ackagename)
	s clskey=""
	f  s clskey=$o(arrarylistcls(clskey)) q:clskey=""  d
	.s clsname=clskey_".cls"
	.q:clsname'["DHCST"
	.q:clsname["PIVA"
	.q:clsname["CNTS"
	.q:clsname="web.DHCST01.cls"
	.q:clsname="web.DHCST.cls"
	.q:clsname="web.DHCSTCOMINC.cls"
	.q:clsname="web.DHCSTCOMMO.cls"
	.q:clsname="web.DHCSTCOMMONSRV.cls"
	.q:clsname="web.DHCSTCOMMPARA.cls"
	.q:clsname="web.DHCSTCOMWEB.cls"
	.q:clsname="web.DHCSTCUSTOMER.cls"
	.q:clsname="web.DHCSTEXTCOMMON.cls"
	.q:clsname="web.DHCSTINTERFACE.cls"
	.q:clsname="web.DHCSTInterfacePH.cls"
	.q:clsname="web.DHCSTITMDESC.cls"
	.q:clsname="web.DHCSTKUTIL.cls"
	.q:clsname="web.DHCSTLOCBTDTOTAL.cls"
	.q:clsname="web.DHCSTLOCDTOTAL.cls"
	.q:clsname="web.DHCSTSTKQTY.cls"
	.q:clsname="web.DHCSTPIVA.cls"
	.q:clsname="web.DHCOutPhCommon.cls"
	.s clspath=path_clskey_".xml"
	.d $system.OBJ.Export(clsname,clspath)
	q "------------over-----------"
}

// w ##class(web.DHCST).ExportOPClassforSVN("web","D:\dhcoutph\05_cls\")

// 导出门诊药房相关类,住院、配液、公共类除外

ClassMethod ExportOPClassforSVN(ackagename As %String, path As %String)
{
    s arrarylistcls=""
    s clsname="",clspath=""
	w $system.OBJ.GetPackageList(.arrarylistcls,ackagename)
	s clskey=""
	f  s clskey=$o(arrarylistcls(clskey)) q:clskey=""  d
	.s clsname=clskey_".cls"
	.q:(clsname'["DHCOutPh")&(clsname'="web.DHCMZYFXTYW02.cls")&(clsname'="web.udhcOPPHARWIN.cls")
	.q:clsname="web.DHCOutPhCommon.cls"
	.s clspath=path_clskey_".xml"
	.d $system.OBJ.Export(clsname,clspath)
	q "------------over-----------"
}

// w ##class(web.DHCST).ExportCOMClassforSVN("web","D:\dhcphacomcls\")

// 导出住院和门诊药房和配液中心的公共类

ClassMethod ExportCOMClassforSVN(ackagename As %String, path As %String)
{
    s arrarylistcls=""
    s clsname="",clspath=""
	w $system.OBJ.GetPackageList(.arrarylistcls,ackagename)
	s clskey=""
	f  s clskey=$o(arrarylistcls(clskey)) q:clskey=""  d
	.s clsname=clskey_".cls"
	.s ret=""
	.i clsname="web.DHCST01.cls" s ret=1
	.i clsname="web.DHCST.cls" s ret=1
	.i clsname="web.DHCSTCOMINC.cls" s ret=1
	.i clsname="web.DHCSTCOMMO.cls" s ret=1
	.i clsname="web.DHCSTCOMMONSRV.cls" s ret=1
	.i clsname="web.DHCSTCOMMPARA.cls" s ret=1
	.i clsname="web.DHCSTCOMWEB.cls" s ret=1
	.i clsname="web.DHCSTCUSTOMER.cls" s ret=1
	.i clsname="web.DHCSTEXTCOMMON.cls" s ret=1
	.i clsname="web.DHCSTINTERFACE.cls" s ret=1
	.i clsname="web.DHCSTInterfacePH.cls" s ret=1
	.i clsname="web.DHCSTITMDESC.cls" s ret=1
	.i clsname="web.DHCSTKUTIL.cls" s ret=1
	.i clsname="web.DHCSTLOCBTDTOTAL.cls" s ret=1
	.i clsname="web.DHCSTLOCDTOTAL.cls" s ret=1
	.i clsname="web.DHCSTSTKQTY.cls" s ret=1
	.i clsname="web.DHCSTPIVA.cls" s ret=1
	.i clsname="web.DHCOutPhCommon.cls" s ret=1
	.q:ret=""
	.s clspath=path_clskey_".xml"
	.d $system.OBJ.Export(clsname,clspath)
	q "------------over-----------"
}

// w ##class(web.DHCST).ExportIPUserClassforSVN("user","D:\dhcipuser\")

// 导出住院药房User类

ClassMethod ExportIPUserClassforSVN(ackagename As %String, path As %String)
{
    s arrarylistcls=""
    s clsname="",clspath=""
	w $system.OBJ.GetPackageList(.arrarylistcls,ackagename)
	s clskey=""
	f  s clskey=$o(arrarylistcls(clskey)) q:clskey=""  d
	.s ret=""
	.s clsname=clskey_".cls"
	.q:clsname["DHCPHARWIN"
	.i clsname["DHCPha" s ret=1
	.i clsname["DHCPHA" s ret=1
	.i clsname["DHCBaseDrug" s ret=1
	.i clsname["DHCSTDRUGREFUSE" s ret=1
	.i clsname["DHCStkDrugGroup" s ret=1
	.q:ret'=1
	.s clspath=path_clskey_".xml"
	.d $system.OBJ.Export(clsname,clspath)
	q "------------over-----------"
}

// w ##class(web.DHCST).ExportOPUserClassforSVN("user","D:\dhcoutph\03_user")

// 导出门诊药房User类

ClassMethod ExportOPUserClassforSVN(ackagename As %String, path As %String)
{
    s arrarylistcls=""
    s clsname="",clspath=""
	w $system.OBJ.GetPackageList(.arrarylistcls,ackagename)
	s clskey=""
	f  s clskey=$o(arrarylistcls(clskey)) q:clskey=""  d
	.s ret=""
	.s clsname=clskey_".cls"
	.q:clsname'["DHCPH"
	.q:clsname["DHCPHCNTS"
	.q:clsname["DHCPHCOMMENTS"
	.q:clsname["DHCPHACollected"
	.q:clsname["DHCPHACollectItm"
	.s clspath=path_clskey_".xml"
	.d $system.OBJ.Export(clsname,clspath)
	q "------------over-----------"
}

ClassMethod ExportCNTSClassforSVN(ackagename As %String, path As %String)
{
    s arrarylistcls=""
    s clsname="",clspath=""
	w $system.OBJ.GetPackageList(.arrarylistcls,ackagename)
	s clskey=""
	f  s clskey=$o(arrarylistcls(clskey)) q:clskey=""  d
	.s clsname=clskey_".cls"
	.q:clsname'["DHCSTCNTS"
	.s clspath=path_clskey_".xml"
	.d $system.OBJ.Export(clsname,clspath)
	q "------------over-----------"
}

/// 导出门诊药房相关cls,user,组件xml,公用的除外
/// Creator:LiangQiang
/// CreatDate:2013-04-23
/// w ##class(web.DHCST).ExportOPClass()
/// 注意:06_component中web.要手工去除
ClassMethod ExportOPClass()
{
	w ##class(web.DHCST).ExportOPClassforSVN("web","D:\dhcoutph\05_cls\")
	w ##class(web.DHCST).ExportOPUserClassforSVN("user","D:\dhcoutph\03_user\")
	w ##class(web.DHCST).GetComDHCOut("D:\dhcoutph\06_component\")
	q ""
}

/// 导出住院药房相关cls,user,组件xml,公用的除外
/// Creator:LiangQiang
/// CreatDate:2013-04-23
/// w ##class(web.DHCST).ExportIPClass()
/// 注意:06_component中web.要手工去除
ClassMethod ExportIPClass()
{
	w ##class(web.DHCST).ExportIPClassforSVN("web","D:\dhcpha\05_cls\")
	w ##class(web.DHCST).ExportIPUserClassforSVN("user","D:\dhcpha\03_user\")
	w ##class(web.DHCST).GetComDHCPha("D:\dhcpha\06_component\")
	q ""
}

/// 导出门诊,住院药房,配液相关公用的web类
/// Creator:LiangQiang
/// CreatDate:2013-04-23
/// w ##class(web.DHCST).ExportDHCPHCOMClass()
ClassMethod ExportDHCPHCOMClass()
{
	w ##class(web.DHCST).ExportCOMClassforSVN("web","D:\dhcphcomm\05_cls\")
	q ""
}

/// 导出处方点评相关类,公用的除外
/// Creator:LiangQiang
/// CreatDate:2013-04-23
/// w ##class(web.DHCST).ExportCNTSClass()
ClassMethod ExportCNTSClass()
{
	w ##class(web.DHCST).ExportCNTSClassforSVN("web","D:\dhccnts\05_cls\")
	q ""
}

/// 导出处方点评相关User类
/// Creator:LiangQiang
/// CreatDate:2013-04-23
/// w ##class(web.DHCST).ExportCNTSUserClass()
ClassMethod ExportCNTSUserClass()
{
	w ##class(web.DHCST).ExportCNTSUserforSVN("user","D:\dhccnts\03_user\")
	q ""
}

/// 导出处方点评相关User类,公用的除外
/// Creator:LiangQiang
/// CreatDate:2013-04-23
/// w ##class(web.DHCST).ExportCNTSUserforSVN()
ClassMethod ExportCNTSUserforSVN(ackagename As %String, path As %String)
{
    s arrarylistcls=""
    s clsname="",clspath=""
	w $system.OBJ.GetPackageList(.arrarylistcls,ackagename)
	s clskey=""
	f  s clskey=$o(arrarylistcls(clskey)) q:clskey=""  d
	.s clsname=clskey_".cls"
	.q:(clsname'["DHCPHCNTS")&(clsname'["DHCPHCOMMENTS")
	.s clspath=path_clskey_".xml"
	.d $system.OBJ.Export(clsname,clspath)
	q "------------over-----------"
}

}
