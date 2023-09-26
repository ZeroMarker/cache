Class web.DHCINSUExportSvn Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      liushufeng
/// CreatDate：    2012 03 02
/// Description:   导出医保组所有类和M为xml文件到指定目录下
/// Table：        
/// Input：        
/// Output：       对输出参数的说明
/// Return：       函数返回值的说明
/// Others：       其它说明    path window :c:\DHCINSU\Cache\   unix:/TMP/DHCINSU/Cache/  
/// W ##CLASS(web.DHCINSUExportSvn).DHCINSUExport("c:\DHCINSU\Cache\")
ClassMethod DHCINSUExport(path)
{
	
	s Outpath=path_"M\"
	s:path["/" Outpath=$tr(Outpath,"\","/")
  	W ##CLASS(web.DHCINSUExportSvn).ExportMacforSVN("DHCINSU*.MAC","DHC-APP",Outpath)
  	//W ##CLASS(web.DHCINSUExportSvn).ExportMacforSVN("INSU*.MAC","DHC-APP","c:\DHCINSU\Cache\M\")
	
	s pathFile=path_"\class.txt"
	s:path["/" pathFile=$tr(pathFile,"\","/")
	s Outpath=path_"class\"
	s:Outpath["/" Outpath=$tr(Outpath,"\","/")
  	w ##Class(web.DHCINSUExportSvn).ShowClasses("DHC-APP",pathFile)
  	w ##Class(web.DHCINSUExportSvn).ExportClassByFileList(pathFile,Outpath)
  	;w ##Class(web.DHCINSUExportSvn).ShowClasses("DHC-APP","c:\DHCINSU\Cache\class.txt")
  	;w ##Class(web.DHCINSUExportSvn).ExportClassByFileList("c:\DHCINSU\Cache\class.txt","c:\DHCINSU\Cache\class\")
  	
  	s Outpath=path_"Components\"
	s:path["/" Outpath=$tr(Outpath,"\","/")
	W ##CLASS(web.DHCINSUExportSvn).DHCINSUExportComponents(Outpath)
  	;W ##CLASS(web.DHCINSUExportSvn).DHCINSUExportComponents("c:\DHCINSU\Cache\Components\")
  
  	q 0
}

/// Creator：      liushufeng
/// CreatDate：    2012 03 02
/// Description:   导出医保组所有类和M为xml文件到指定目录下
/// Table：        
/// Input：        
/// Output：       对输出参数的说明
/// Return：       函数返回值的说明
/// Others：       其它说明
/// W ##CLASS(web.DHCINSUExportSvn).DHCINSUExportComponents("c:\DHCINSU\Cache\Components\")
/// W ##CLASS(web.DHCINSUExportSvn).DHCINSUExportComponents("/TMP/DHCINSU/Cache/Components/")
ClassMethod DHCINSUExportComponents(path As %String)
{
  	d ##class(web.Util.UtilService).GetExportComponents("INSUAudit",path)
  	d ##class(web.Util.UtilService).GetExportComponents("INSUDicDataCom",path)
  	d ##class(web.Util.UtilService).GetExportComponents("INSUTarItemsCom",path)
  	d ##class(web.Util.UtilService).GetExportComponents("INSUTarEditCom",path)
  	d ##class(web.Util.UtilService).GetExportComponents("INSUTarContrast1",path)
  	d ##class(web.Util.UtilService).GetExportComponents("INSUTarContrast2",path)
  	d ##class(web.Util.UtilService).GetExportComponents("INSUTarContrastListCom",path)
  	d ##class(web.Util.UtilService).GetExportComponents("INSUIPReg",path)
  	d ##class(web.Util.UtilService).GetExportComponents("DHCInsuLocInfo",path)
  	d ##class(web.Util.UtilService).GetExportComponents("INSUAuditIP",path)
  	d ##class(web.Util.UtilService).GetExportComponents("INSUAuditDetailsIP",path)
  	d ##class(web.Util.UtilService).GetExportComponents("INSUAuditOP",path)
  	d ##class(web.Util.UtilService).GetExportComponents("DHCINSUOedLinkTar",path)
  	d ##class(web.Util.UtilService).GetExportComponents("DHCINSUTarConTar",path)
  	d ##class(web.Util.UtilService).GetExportComponents("INSUAuditReport",path)
  	d ##class(web.Util.UtilService).GetExportComponents("INSUAuditRepDetails",path)
  	d ##class(web.Util.UtilService).GetExportComponents("INSUReport",path)
  	d ##class(web.Util.UtilService).GetExportComponents("INSURegInfo",path)
 
  q 0
}

/// Creator：      guozongtao
/// CreatDate：    2008-09-17
/// Description:   导出包下所有类为xml文件到指定目录下
/// Table：        
/// Input：        ackagename：包名  path：路径(c:\tmp\)。
/// Output：       对输出参数的说明
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod ExportClassforSVN(ackagename As %String, path As %String)
{
    s arrarylistcls=""
    s clsname="",clspath=""
	w $system.OBJ.GetPackageList(.arrarylistcls,ackagename)
	s clskey=""
	f  s clskey=$o(arrarylistcls(clskey)) q:clskey=""  d
	.s clsname=clskey_".cls"
	.s clspath=path_clskey_".xml"
	.d $system.OBJ.Export(clsname,clspath)
}

/// Creator：      guozongtao
/// CreatDate：    2008-09-17
/// Description:   按照修改日期范围,导出包下类为xml文件到指定目录下
/// Table：        
/// Input：        ackagename：包名  path：路径(c:\tmp\) StDate：开始日期 EndDate：截止日期 (YYYY-MM-DD)。
/// Output：       对输出参数的说明
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod ExportClsforSVNOnDate(ackagename As %String, path As %String, StDate As %String, EndDate As %String)
{
	s mStdate=$zdh(StDate,3)
	s mEndDate=$zdh(EndDate,3)
	s arrarylistcls=""
    s clsname="",clspath=""
	w $system.OBJ.GetPackageList(.arrarylistcls,ackagename)
	s clskey=""
	f  s clskey=$o(arrarylistcls(clskey)) q:clskey=""  d
	.s objCompiledClass=##Class(%Dictionary.CompiledClass).%OpenId(clskey)
	.s TimeChanged=objCompiledClass.TimeChanged
	.s intTimeChanged=$p(TimeChanged,",",1)
	.q:(intTimeChanged>mEndDate)  d
	.q:(intTimeChanged<mStdate)  d
	.w "clsname: ",clsname,!
	.s clsname=clskey_".cls"
	.s clspath=path_clskey_".xml"
	.d $system.OBJ.Export(clsname,clspath)
}

/// Creator：      guozongtao
/// CreatDate：    2008-09-17
/// Description:   填充非持久化对象,序列化为xml,写入文件
/// Table：        websys.Component;websys.ComponentItems;websys.ComponentTableItems;websys.ComponentMessages 
/// Input：        ComponentId：websys.Component主键  ClassName：填充目标类名称; file 写入文件对象。
/// Output：       对输出参数的说明
/// Return：       函数返回值的说明
/// Others：       其它说明
/// History:       2010-03-29
///                LayOut 导出原则：如果websys.Preferences中没有组件的SITE级别的Layout,则取websys.Component.Template的内容作为导出的Layout
ClassMethod FillRegisteredObject(ComponentId As %String, ClassName As %String, file As %File, TarGetPath As %String)
{

	if ClassName="Tmpwebsys.Component"
	{
		
		s aCmdCreateCls="objCompRegistered=##class("_ClassName_").%New()"
		s @aCmdCreateCls
		s objCompPersistent=##class(websys.Component).%OpenId(ComponentId)
		s obj=##Class(%Dictionary.CompiledClass).%OpenId("websys.Component")
		s cnt=obj.Properties.Count()
		w "ComponentId: ",ComponentId,!
		f i=1:1:cnt  d
		.s PropertyName=obj.Properties.GetAt(i).Name
		.q:PropertyName="%Concurrency"  d
		.q:PropertyName="%IsInSave"  d
		.q:(obj.Properties.GetAt(i).Private=1)  d
		.i PropertyName="Template"  d
		..s mValue=""
		..;s ^CacheTemp(ComponentId,PropertyName)=mValue
		..s ^CacheTemp(PropertyName)=mValue
		..s Config=##Class(websys.Configuration).%OpenId(1)
		..s SiteCode=Config.SiteCode
		..s LayOut=##Class(websys.Preferences).GetData("SITE",SiteCode,"LAYOUT",ComponentId)
		..//q:LayOut=""  // <2010-03-29><guozongtao><修改layout导出原则,详见函数声明出History>
		..i LayOut=""  d
		...s mValue=$ZOBJPROPERTY(objCompPersistent,PropertyName)
		..e  d
		...s LayOut=$LIST(LayOut,1)
		...s mValue=LayOut
		..;s ^CacheTemp(ComponentId,PropertyName)=mValue
		..s ^CacheTemp(PropertyName)=mValue
		.e  d
		..s mValue=$ZOBJPROPERTY(objCompPersistent,PropertyName)
		..;s ^CacheTemp(ComponentId,PropertyName)=mValue
		..s ^CacheTemp(PropertyName)=mValue
		.i PropertyName="ClassName"  d
		..q:$ZOBJPROPERTY(objCompPersistent,"ClassName")=""
		..s clsname=mValue_".cls"
		..s clspath=TarGetPath_clsname_".xml"
		..d $system.OBJ.Export(clsname,clspath)			 
		.;s aCmdLetValue="objCompRegistered."_PropertyName_"="_"$g(^CacheTemp(ComponentId,PropertyName))"
		.s aCmdLetValue="objCompRegistered."_PropertyName_"="_"$g(^CacheTemp(PropertyName))"
		.s @aCmdLetValue
		s aCmdLetValue="objCompRegistered."_"RowId"_"="_ComponentId
		s @aCmdLetValue
		s aCmdXmlExport="b=objCompRegistered.XMLExportToString(.xml)"
		s @aCmdXmlExport
		d file.WriteLine(xml)
		w "...Export Component Name:"_Name_"'s Component is finished.",!
	}
	if ClassName="Tmpwebsys.ComponentItems"
	{
		s aCmdCreateCls="objCompRegistered=##class("_ClassName_").%New()"
		s @aCmdCreateCls
		s obj=##Class(%Dictionary.CompiledClass).%OpenId("websys.ComponentItems")
		s cnt=obj.Properties.Count()
		s ItemsID=""
		d file.WriteLine("<Items>")
		f  s ItemsID=$o(^websys.ComponentItemsD(ComponentId,ItemsID)) q:ItemsID=""  d
		.s objCompPersistent=##class(websys.ComponentItems).%OpenId(ComponentId_"||"_ItemsID)
		.f i=1:1:cnt  d
		..s PropertyName=obj.Properties.GetAt(i).Name
		..q:PropertyName="%Concurrency"  d
		..q:PropertyName="%IsInSave"  d
		..q:(obj.Properties.GetAt(i).Private=1)  d
		..s mValue=$ZOBJPROPERTY(objCompPersistent,PropertyName)
		..s ^CacheTemp(PropertyName)=mValue
		..s aCmdLetValue="objCompRegistered."_PropertyName_"="_"$g(^CacheTemp(PropertyName))"
		..s @aCmdLetValue	
		.s PropertyName="RowId"
		.s ^CacheTemp(PropertyName)=ComponentId_"||"_ItemsID
		.s aCmdLetValue="objCompRegistered."_PropertyName_"="_"$g(^CacheTemp(PropertyName))"
		.s @aCmdLetValue
		.s aCmdXmlExport="b=objCompRegistered.XMLExportToString(.xml)"
		.s @aCmdXmlExport
	    .d file.WriteLine(xml)
	    s aCmdLetObj=""
	    d file.WriteLine("</Items>")
	    w "...Export Component Name:"_Name_"'s ComponentItems is finished.",!
	}
	if ClassName="Tmpwebsys.ComponentTableItems"
	{
		s aCmdCreateCls="objCompRegistered=##class("_ClassName_").%New()"
		s @aCmdCreateCls
		s obj=##Class(%Dictionary.CompiledClass).%OpenId("websys.ComponentTableItems")
		s cnt=obj.Properties.Count()
		s ItemsID=""
		d file.WriteLine("<TableItems>")
		f  s ItemsID=$o(^websys.ComponentTableItemsD(ComponentId,ItemsID)) q:ItemsID=""  d
		.s objCompPersistent=##class(websys.ComponentTableItems).%OpenId(ComponentId_"||"_ItemsID)
		.f i=1:1:cnt  d
		..s PropertyName=obj.Properties.GetAt(i).Name
		..q:PropertyName="%Concurrency"  d
		..q:PropertyName="%IsInSave"  d
		..q:(obj.Properties.GetAt(i).Private=1)  d
		..s mValue=$ZOBJPROPERTY(objCompPersistent,PropertyName)
		..s ^CacheTemp(PropertyName)=mValue
		..s aCmdLetValue="objCompRegistered."_PropertyName_"="_"$g(^CacheTemp(PropertyName))"
		..s @aCmdLetValue	
		.s PropertyName="RowId"
		.s ^CacheTemp(PropertyName)=ComponentId_"||"_ItemsID
		.s aCmdLetValue="objCompRegistered."_PropertyName_"="_"$g(^CacheTemp(PropertyName))"
		.s @aCmdLetValue
		.s aCmdXmlExport="b=objCompRegistered.XMLExportToString(.xml)"
		.s @aCmdXmlExport
	    .d file.WriteLine(xml)
	    d file.WriteLine("</TableItems>")
	    w "...Export Component Name:"_Name_"'s ComponentTableItems is finished.",!
	}
	if ClassName="Tmpwebsys.ComponentMessages"
	{
		s aCmdCreateCls="objCompRegistered=##class("_ClassName_").%New()"
		s @aCmdCreateCls
		s obj=##Class(%Dictionary.CompiledClass).%OpenId("websys.ComponentMessages")
		s cnt=obj.Properties.Count()
		s ItemsID=""
		d file.WriteLine("<Messages>")
		f  s ItemsID=$o(^websys.ComponentD(ComponentId,"Messages",ItemsID)) q:ItemsID=""  d
		.s objCompPersistent=##class(websys.ComponentMessages).%OpenId(ComponentId_"||"_ItemsID)
		.f i=1:1:cnt  d
		..s PropertyName=obj.Properties.GetAt(i).Name
		..q:PropertyName="%Concurrency"  d
		..q:PropertyName="%IsInSave"  d
		..q:(obj.Properties.GetAt(i).Private=1)  d
		..s mValue=$ZOBJPROPERTY(objCompPersistent,PropertyName)
		..s ^CacheTemp(PropertyName)=mValue
		..s aCmdLetValue="objCompRegistered."_PropertyName_"="_"$g(^CacheTemp(PropertyName))"
		..s @aCmdLetValue	
		.s PropertyName="RowId"
		.s ^CacheTemp(PropertyName)=ComponentId_"||"_ItemsID
		.s aCmdLetValue="objCompRegistered."_PropertyName_"="_"$g(^CacheTemp(PropertyName))"
		.s @aCmdLetValue
		.s aCmdXmlExport="b=objCompRegistered.XMLExportToString(.xml)"
		.s @aCmdXmlExport
	    .d file.WriteLine(xml)
	    d file.WriteLine("</Messages>")
	    w "...Export Component Name:"_Name_"'s ComponentMessages is finished.",!
	}
	q
}

/// Creator：      guozongtao
/// CreatDate：    2008-09-17
/// Description:   取得需要导出组建列表
/// Table：        websys.Component 
/// Input：        ComponentName：websys.Component.Name 组件名称。
/// Output：       
/// Return：       i:符合条件的组件数量
/// Others：       其它说明
ClassMethod GetExportCompentList(ComponentName As %String) As %String
{
	s ComponentName=$$ALPHAUP^SSUTIL4(ComponentName)
	s CompName=ComponentName
	s flag="N"
	s i=0
	k ^TMP($j)
	s Rowid=""
	i $d(^websys.ComponentI("UniqueNameIndex",ComponentName))'=0  d
	.s Rowid=$O(^websys.ComponentI("UniqueNameIndex",ComponentName,Rowid))
	.s mCurrRow=$g(^websys.ComponentD(Rowid))
	.s Name=$list(mCurrRow,1)
	.s ^TMP($J,"ComponentID",Rowid)=Name
	.s i=i+1
	f  s CompName=$o(^websys.ComponentI("UniqueNameIndex",CompName)) q:(CompName="")!(flag="Y")  d
	.if $e(CompName,1,$L(ComponentName))'=ComponentName s flag="Y" q
	.s Rowid=""
	.f  s Rowid=$o(^websys.ComponentI("UniqueNameIndex",CompName,Rowid)) q:Rowid=""  d
	..s mCurrRow=$g(^websys.ComponentD(Rowid))
	..s Name=$list(mCurrRow,1)
	..s ^TMP($J,"ComponentID",Rowid)=Name
	..s i=i+1
	q i
}

/// Creator：      guozongtao
/// CreatDate：    2010-3-22
/// Description:   取得需要导出组建列表
/// Table：        websys.Component 
/// Input：        CustomComponentID：websys.Component.ID 组件ROWID
/// Output：       
/// Return：       i:符合条件的组件数量
/// Others：       其它说明
ClassMethod GetExportCompentListByRowID(CustomComponentID As %String) As %String
{
	k ^TMP($j)
	s i=CustomComponentID
	s Rowid=CustomComponentID
	f  s Rowid=$o(^websys.ComponentD(Rowid)) q:Rowid=""  d
	.s mCurrRow=$g(^websys.ComponentD(Rowid))
	.q:mCurrRow=""  d 
	.s Name=$list(mCurrRow,1)
	.s ^TMP($J,"ComponentID",Rowid)=Name
	.s i=i+1
	q i
}

/// Creator：      guozongtao
/// CreatDate：    2008-09-17
/// Description:   导出组件到xml文件
/// Table：        
/// Input：        ComponentName：websys.Component.Name 组件名称; TarGetPath：目标路径。。
/// Output：       
/// Return：       file.SizeGet():输出文件大小
/// Others：       其它说明
ClassMethod ExportComportToXml(ComponentId As %String, ComponentName As %String, TarGetPath As %String) As %String
{
	d ..CreateClassManager()
	
	s file=##class(%File).%New(TarGetPath_ComponentName_".xml")
	d file.Open("WSN")
    d file.WriteLine("<"_"DHCCOMPONENTEXPORT"_">")
	d ..FillRegisteredObject(ComponentId,"Tmpwebsys.Component",file,TarGetPath)
	d ..FillRegisteredObject(ComponentId,"Tmpwebsys.ComponentItems",file)
	d ..FillRegisteredObject(ComponentId,"Tmpwebsys.ComponentTableItems",file)
	d ..FillRegisteredObject(ComponentId,"Tmpwebsys.ComponentMessages",file)
	d file.WriteLine("</"_"DHCCOMPONENTEXPORT"_">") 
	d file.Close()
	q file.SizeGet()
}

/// Creator：      guozongtao
/// CreatDate：    2008-09-17
/// Description:   根据本地数据库,websys.Component创建可序列化xml的非持久化对象。
/// Table：        
/// Input：        ComponentName：websys.Component.Name 组件名称; TarGetPath：目标路径。。
/// Output：       
/// Return：       file.SizeGet():输出文件大小
/// Others：       其它说明
ClassMethod CreateClass(ClassName As %String)
{
	s cdef = ##class(%Dictionary.ClassDefinition).%New("Tmp"_ClassName)	
	s cdef.Super = "%RegisteredObject,%XML.Adaptor"
	s cdef.Owner= ""
	s pdef = ##class(%Dictionary.PropertyDefinition).%New("RowId")
	d cdef.Properties.Insert(pdef)
	s pdef.Name="RowId"
	s pdef.Type="%String"
	s Parametersdef=##class(%Dictionary.ParameterDefinition).%New("XMLIGNOREINVALIDTAG")
	d cdef.Parameters.Insert(Parametersdef) 
	s Parametersdef.Name="XMLIGNOREINVALIDTAG"
	s Parametersdef.Default="1" 
	s obj=##Class(%Dictionary.CompiledClass).%OpenId(ClassName)
	s cnt=obj.Properties.Count()
	f i=1:1:cnt  d
	.s PropertiesName=obj.Properties.GetAt(i).Name
	.q:PropertiesName="%Concurrency"  d
	.q:PropertiesName="%IsInSave"  d
	.q:(obj.Properties.GetAt(i).Private=1)  d
	.s pdef = ##class(%Dictionary.PropertyDefinition).%New(PropertiesName)
	.d cdef.Properties.Insert(pdef)
	.s pdef.Name=PropertiesName
	.s pdef.Type="%String"
	.d pdef.Parameters.SetAt("","MAXLEN")
	.d pdef.Parameters.SetAt(1,"TRUNCATE")
	s SaveStatus=cdef.%Save()
	q:(+SaveStatus=0) "-1"
	q $System.OBJ.Compile("Tmp"_ClassName, "-d")
}

/// Creator：      guozongtao
/// CreatDate：    2008-09-17
/// Description:   生成用于反序列化xml的非持久化对象。
/// Table：        
/// Input：        
/// Output：       
/// Return：       file.SizeGet():输出文件大小
/// Others：       其它说明
ClassMethod CreateRegisteredCls()
{
	s cdef = ##class(%Dictionary.ClassDefinition).%New("web.Util.RegisteredCls")	
	s cdef.Super = "%RegisteredObject,%XML.Adaptor"
	s cdef.Owner= ""
	s PropertiesName="Component"
	s pdef = ##class(%Dictionary.PropertyDefinition).%New(PropertiesName)
	d cdef.Properties.Insert(pdef)
	s pdef.Name=PropertiesName
	s pdef.Type="Tmpwebsys.Component"
	s PropertiesName="Items"
	s pdef = ##class(%Dictionary.PropertyDefinition).%New(PropertiesName)
	d cdef.Properties.Insert(pdef)
	s pdef.Name=PropertiesName
	s pdef.Type="Tmpwebsys.ComponentItems"
	s pdef.Collection="list"
	s PropertiesName="TableItems"
	s pdef = ##class(%Dictionary.PropertyDefinition).%New(PropertiesName)
	d cdef.Properties.Insert(pdef)
	s pdef.Name=PropertiesName
	s pdef.Type="Tmpwebsys.ComponentTableItems"
	s pdef.Collection="list"
	s PropertiesName="Messages"
	s pdef = ##class(%Dictionary.PropertyDefinition).%New(PropertiesName)
	d cdef.Properties.Insert(pdef)
	s pdef.Name=PropertiesName
	s pdef.Type="Tmpwebsys.ComponentMessages"
	s pdef.Collection="list"
	s SaveStatus=cdef.%Save()
	q:(+SaveStatus=0) "-1"
	q $System.OBJ.Compile("web.Util.RegisteredCls", "-d")
}

/// Creator：      guozongtao
/// CreatDate：    2008-09-17
/// Description:   根据本地数据库组件表结构,生成用于序列化xml的非持久化对象。
/// Table：        
/// Input：        
/// Output：       
/// Return：       file.SizeGet():输出文件大小
/// Others：       其它说明
ClassMethod CreateClassManager()
{
	s objExistsFlag=##class(%Dictionary.CompiledClass).%OpenId("Tmpwebsys.Component")
 	i objExistsFlag=""  d
    .d ..CreateClass("websys.Component")
	
	s objExistsFlag=##class(%Dictionary.CompiledClass).%OpenId("Tmpwebsys.ComponentItems")
 	i objExistsFlag=""  d
	.d ..CreateClass("websys.ComponentItems")
	
	s objExistsFlag=##class(%Dictionary.CompiledClass).%OpenId("Tmpwebsys.ComponentTableItem")
 	i objExistsFlag=""  d
	.d ..CreateClass("websys.ComponentTableItems")
	
	s objExistsFlag=##class(%Dictionary.CompiledClass).%OpenId("Tmpwebsys.ComponentMessages")
 	i objExistsFlag=""  d
	.d ..CreateClass("websys.ComponentMessages")

	s objExistsFlag=##class(%Dictionary.CompiledClass).%OpenId("web.Util.RegisteredCls")
 	i objExistsFlag=""  d
	.d ..CreateRegisteredCls()
}

/// Creator：      guozongtao
/// CreatDate：    2008-09-17
/// Description:   根据组件名称导出组件到xml到指定路径。
/// Table：        
/// Input：        ComponentName：组件名称; TarGetPath:文件导出目标路径 (c:\temp\)   
/// Output：       
/// Return：       
/// Others：       其它说明
/// d ##class(web.Util.UtilService).GetExportComponents("DHCOPRegInsuComp","D:\DTHealth\DHCOPRegInsuComp.xml")
ClassMethod GetExportComponents(ComponentName As %String, TarGetPath As %String)
{
	s ComponentCnt=..GetExportCompentList(ComponentName)
	w "Summary Infomation : Component Count: "_ComponentCnt,!
	s id=""
	s ComponentName=""
	f  s id=$o(^TMP($J,"ComponentID",id)) q:id=""  d
	.s Name=$g(^TMP($J,"ComponentID",id))
	.s rtn=..ExportComportToXml(id,Name,TarGetPath)
	.w "Component: "_Name_" is finished path:"_TarGetPath_Name_".xml "_"Size(byte): "_rtn  ,!
	q
}

/// Creator：      guozongtao
/// CreatDate：    2010-03-22
/// Description:   根据组件ROWID,将ROWID大于CustomComponentID的组件全部导出组件到xml到指定路径。
/// Table：        
/// Input：        CustomComponentID：需要导出的组件的最小的ROWID; TarGetPath:文件导出目标路径 (c:\temp\)   
/// Output：       
/// Return：       
/// Others：       其它说明
/// D ##Class(web.Util.UtilService).GetExportComponentsByRowID("50012","z:\")
ClassMethod GetExportComponentsByRowID(CustomComponentID As %String, TarGetPath As %String)
{
	s ComponentCnt=..GetExportCompentListByRowID(CustomComponentID)
	w "Summary Infomation : Component Count: "_ComponentCnt,!
	s id="",FileCnt=1
	s ComponentName=""
	f  s id=$o(^TMP($J,"ComponentID",id)) q:id=""  d
	.s Name=$g(^TMP($J,"ComponentID",id))
	.s rtn=..ExportComportToXml(id,Name,TarGetPath)
	.w "Component: "_Name_" is finished path:"_TarGetPath_Name_".xml "_"Size(byte): "_rtn  ,!
	.s FileCnt=FileCnt+1
	w "Summary: "_FileCnt_" Components have been exported to the "_TarGetPath,!
	q
}

/// Creator：      guozongtao
/// CreatDate：    2008-09-17
/// Description:   根据xml文件名称导入组件。
/// Table：        
/// Input：        FileName：文件名称 (c:\temp\DHCExportCmpTest.xml)   
/// Output：       
/// Return：       
/// Others：       其它说明
/// History:       新增参数 DeleteFlag='True' 表示不删除组件websys.Component记录,保证其它配置调用.
///                         删除组件下item,tableitem,messages,按照导入文件数据导入.
///                增加导入组件的xml文件不存在时的错误信息。
/// D ##Class(web.Util.UtilService).PutComponent("D:\DTHealth\DHCDocRapidRegist.xml")
ClassMethod PutComponent(FileName As %String, DeleteFlag As %String = "False")
{
	d ..CreateClassManager()
	
	K ^TMP("EXPORT")
	s ExistsFlag=##Class(%File).Exists(FileName)
	i ExistsFlag'=1  d
	.w "Error: "_FileName_"  does not exist !"
	q:ExistsFlag'=1  d
	s reader = ##class(%XML.Reader).%New()
	s stream=##class(%FileCharacterStream).%New()
	s stream.Filename=FileName
	s sc=reader.OpenStream(stream)
	//If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit  
	d reader.Correlate("DHCCOMPONENTEXPORT","web.Util.RegisteredCls")
	While reader.Next(.obj,.sc) 
	{
		w "PutComponent begin...",!
		s ComponentName=$$ALPHAUP^SSUTIL4(obj.Component.Name)
		if $d(^websys.ComponentI("UniqueNameIndex",ComponentName))'=0  d
		.s ComponentId=""
		.s ComponentId=$o(^websys.ComponentI("UniqueNameIndex",ComponentName,ComponentId))
		.s objCompPersistent=##class(websys.Component).%OpenId(ComponentId)
		e  d
		.s objCompPersistent=##class(websys.Component).%New()
		s objCompStructure=##Class(%Dictionary.CompiledClass).%OpenId("Tmpwebsys.Component")
		s cnt=objCompStructure.Properties.Count()
		for i=1:1:cnt
		{
			s aCmdLetValue=""
			s PropertyName=objCompStructure.Properties.GetAt(i).Name
            i PropertyName="RowId"  continue
            i PropertyName="ParRef"  continue
			s aCmdLetValue=	"^TMP(""EXPORT"",""Component"",PropertyName)"_"="_"obj.Component."_PropertyName	
		    s @aCmdLetValue
			s aCmdLetValue="objCompPersistent."_PropertyName_"="_"$g(^TMP(""EXPORT"",""Component"",PropertyName))"
			s @aCmdLetValue	
			i PropertyName="Template" d
			.s layout=$g(^TMP("EXPORT","Component","Template"))
			.q:layout=""  d
			.&SQL(Update websys.Component Set Template=:layout WHERE ID=:ComponentId)
		}
		d objCompPersistent.%Save()
		s ComponentId=objCompPersistent.%Id()
		
		w "...PutComponent "_ComponentName_" Component is finished",!
		i DeleteFlag="True" d
		.&SQL(Delete FROM websys.ComponentItems WHERE ParRef=:ComponentId)
		s objItemsStructure=##Class(%Dictionary.CompiledClass).%OpenId("Tmpwebsys.ComponentItems")
		s cnt=objItemsStructure.Properties.Count()
		s Count=obj.Items.Count()
		for j=1:1:Count 
		{
			s ItemsName=" "_$$ALPHAUP^SSUTIL4(obj.Items.GetAt(j).Name)
			if $d(^websys.ComponentItemsI("Name",ComponentId,ItemsName))'=0  d
			.s ItemsId=""
			.s ItemsId=$o(^websys.ComponentItemsI("Name",ComponentId,ItemsName,ItemsId))
			.s objItemsPersistent=##class(websys.ComponentItems).%OpenId(ComponentId_"||"_ItemsId)
			e  d
			.s objCompPersistent=##class(websys.Component).%OpenId(ComponentId)
			.s objItemsPersistent=##class(websys.ComponentItems).%New()
			for k=1:1:cnt
			{
				s PropertyName=objItemsStructure.Properties.GetAt(k).Name
	            if PropertyName="RowId"  continue
	            if PropertyName="ParRef"  continue
				s aCmdLetValue=	"^TMP(""EXPORT"",""Item"",j,PropertyName)"_"="_"obj.Items.GetAt(j)."_PropertyName	
			    s @aCmdLetValue
				s aCmdLetValue="objItemsPersistent."_PropertyName_"="_"$g(^TMP(""EXPORT"",""Item"",j,PropertyName))"
				s @aCmdLetValue	
			}
			s objItemsPersistent.ParRef=objCompPersistent
			d objCompPersistent.%Save()	
		}
		
		w "...PutComponent "_ComponentName_" ComponentItems is finished",!
		i DeleteFlag="True" d
		.&SQL(Delete FROM websys.ComponentTableItems WHERE ParRef=:ComponentId)		
		s objTableItemsStructure=##Class(%Dictionary.CompiledClass).%OpenId("Tmpwebsys.ComponentTableItems")
		s cnt=objTableItemsStructure.Properties.Count()
		s Count=obj.TableItems.Count()
		for j=1:1:Count 
		{
			s TableItemsName=" "_$$ALPHAUP^SSUTIL4(obj.TableItems.GetAt(j).Name)
			if $d(^websys.ComponentTableItemsI("Name",ComponentId,TableItemsName))'=0  d
			.s TableItemsId=""
			.s TableItemsId=$o(^websys.ComponentTableItemsI("Name",ComponentId,TableItemsName,TableItemsId))
			.s objTableItemsPersistent=##class(websys.ComponentTableItems).%OpenId(ComponentId_"||"_TableItemsId)
			e  d
			.s objCompPersistent=##class(websys.Component).%OpenId(ComponentId)
			.s objTableItemsPersistent=##class(websys.ComponentTableItems).%New()
			for k=1:1:cnt
			{
				s PropertyName=objTableItemsStructure.Properties.GetAt(k).Name
				i PropertyName="RowId"  continue
				i PropertyName="ParRef"  continue
				s aCmdLetValue=	"^TMP(""EXPORT"",""TableItem"",PropertyName)"_"="_"obj.TableItems.GetAt(j)."_PropertyName	
			    s @aCmdLetValue
				s aCmdLetValue="objTableItemsPersistent."_PropertyName_"="_"$g(^TMP(""EXPORT"",""TableItem"",PropertyName))"
				s @aCmdLetValue	
			}

			s objTableItemsPersistent.ParRef=objCompPersistent
			d objCompPersistent.%Save()			
		}
		w "...PutComponent "_ComponentName_" ComponentTableItems is finished",!
		i DeleteFlag="True" d
		.&SQL(Delete FROM websys.ComponentMessages WHERE ParRef=:ComponentId)			
		s objMessageStructure=##Class(%Dictionary.CompiledClass).%OpenId("Tmpwebsys.ComponentMessages")
		s cnt=objMessageStructure.Properties.Count()
		s Count=obj.Messages.Count()
		if $d(^websys.ComponentD(ComponentId,"Messages"))'=0  d
		.s Childsub=""
		.f  s Childsub=$o(^websys.ComponentD(ComponentId,"Messages",Childsub)) q:Childsub=""  d
		..s mCurrRow=$g(^websys.ComponentD(ComponentId,"Messages",Childsub))
		..s objMessagePersistent=##class(websys.ComponentMessages).%OpenId(ComponentId_"||"_Childsub)
		..s ^TMP("EXPORT",ComponentId,objMessagePersistent.Code)=ComponentId_"||"_Childsub
		for j=1:1:Count 
		{ 
			s MessageCode=obj.Messages.GetAt(j).Code
			/*
			&SQL(SELECT  ID INTO :MessageId FROM websys.ComponentMessages Where (ParRef=:ComponentId AND Code=:MessageCode))
			w "MessageCodeAfter: ",MessageCode," MessageId: ",MessageId,!
			if MessageId'=""  d
			.s objMessagePersistent=##class(websys.ComponentMessages).%OpenId(MessageId)
			e  d
			.s objCompPersistent=##class(websys.Component).%OpenId(ComponentId)
			.s objMessagePersistent=##class(websys.ComponentMessages).%New()
			*/
			if $d(^TMP("EXPORT",ComponentId,MessageCode))'=0  d
			.s MessageId=$g(^TMP("EXPORT",ComponentId,MessageCode))
			.s objMessagePersistent=##class(websys.ComponentMessages).%OpenId(MessageId)
			e  d
			.s objCompPersistent=##class(websys.Component).%OpenId(ComponentId)
			.s objMessagePersistent=##class(websys.ComponentMessages).%New()
			for k=1:1:cnt
			{
				s PropertyName=objMessageStructure.Properties.GetAt(k).Name
				i PropertyName="RowId"  continue
				i PropertyName="ParRef"  continue
				s aCmdLetValue=	"^TMP(""EXPORT"",""Messages"",PropertyName)"_"="_"obj.Messages.GetAt(j)."_PropertyName	
			    s @aCmdLetValue
				s aCmdLetValue="objMessagePersistent."_PropertyName_"="_"$g(^TMP(""EXPORT"",""Messages"",PropertyName))"
				s @aCmdLetValue	
			}
			s objMessagePersistent.ParRef=objCompPersistent
			d objCompPersistent.%Save()
		}
		w "...PutComponent "_ComponentName_" ComponentMessage is finished",!
		w "ComponentId = ",ComponentId,!

	}
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit
}

/// Creator：      guozongtao
/// CreatDate：    2010-01-22
/// Description:   导出指定NameSpace下的MAC为xml文件到指定目录下
/// Table：        
/// Input：        Spec：M的名称,可以使用通配符 
///                      *.MAC 
///                      A*.MAC 
///                      A?.MAC 
///                      A*.MAC,B*.MAC
///                path：路径(c:\tmp)
///                namespace 命名空间 DHC-APP DHC-MEDSRC LABSRC
/// 
/// Output：       对输出参数的说明
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod ExportMacforSVN(Spec As %String, NameSpace As %String, Path As %String)
{
	s PreviousNameSpace=$zu(5)
	zn NameSpace
	s rset = ##class(%ResultSet).%New("%Library.Routine:RoutineList")
    s sc = rset.Execute(Spec,"1","MAC",NameSpace)
 	while rset.Next(.sc)
	{   
 		s Name = rset.GetData(1)
 		;d $System.OBJ.Export(Name,Path_Name)
 		;w !,Name
		d $System.OBJ.Export(Name,Path_Name_".xml")  ;+liusf 2012 03 02
		w "Export Routine: ",Name,!
	}
	d rset.Close()
	zn PreviousNameSpace
	If $$$ISERR(sc) d
	.zn PreviousNameSpace 
	Quit 0
}

/// Creator：      guozongtao
/// CreatDate：    2010-01-22
/// Description:   导出指定NameSpace下的MAC为xml文件到指定目录下
/// Table：        
/// Input：        Spec：M的名称,可以使用通配符 
///                      *.MAC 
///                      A*.MAC 
///                      A?.MAC 
///                      A*.MAC,B*.MAC
///                path：路径(c:\tmp)
///                namespace 命名空间 DHC-APP DHC-MEDSRC LABSRC
///                StDate：开始日期 EndDate：截止日期 (YYYY-MM-DD)
/// 
/// Output：       对输出参数的说明
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod ExportMacforSVNOnDate(Spec As %String, namespace As %String, path As %String, StDate As %String, EndDate As %String)
{
	s previousnamespace=$zu(5)
	s StDate=$zdh(StDate,3)
	s EndDate=$zdh(EndDate,3)
	zn namespace
	s rset = ##class(%ResultSet).%New("%Library.Routine:RoutineList")
    s sc = rset.Execute(Spec,"1","MAC",namespace)
 	while rset.Next(.sc)
	{   
 		s name = rset.GetData(1)
 		s modidata=$zdh($p(rset.GetData(3)," ",1),3)
 		if ((modidata>=StDate)&(modidata<EndDate)){
			D $System.OBJ.Export(name,path_name_".xml")
			w "ModiDate: ",rset.GetData(3),!
 		}
	}
	d rset.Close()
	zn previousnamespace
	If $$$ISERR(sc) zn previousnamespace Quit
}

/// Creator：      guozongtao
/// CreatDate：    2010-03-22
/// Description:   导出指定NameSpace下的CLASS清单,到文本文件。
/// 
/// Output：       对输出参数的说明
/// Return：       函数返回值的说明
/// Others：       其它说明
/// D ##Class(web.Util.UtilService).ShowClasses("DHC-APP","D:\class.txt")
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
	.s Flag=name["DHCINSU"                     ;+liusf 2011 03 02
	.s Flag1=name["INSU"                     ;+liusf 2011 03 02
	.q:(Flag)=0&&(Flag1=0)                                  ;+liusf 2011 03 02
	.;w !,name,"==",Flag
	.s cs=result.GetDataByName("System")
	.s ch=result.GetDataByName("Hidden")
	.s tn=result.GetDataByName("SqlTableName")
	.s show=('cs)&('ch)!(cs&fs)!(ch&fh)
	.i show Write result.GetDataByName("Name") Write:fd ?25,$zdt(result.GetDataByName("TimeChanged")) Write result.GetDataByName("SqlTableName") Write !
	.d stream.WriteLine(result.GetDataByName("Name"))  ;_"	"_result.GetDataByName("SqlTableName"))
	d stream.SaveStream()
	d stream.%Close()
	Quit $$$OK
}

/// Creator：      guozongtao
/// CreatDate：    2010-03-23
/// Description:   导出CLASS清单文件中类文件到指定路径下
/// 
/// Input:         FileListPath:类清单文件classlist.txt;ExportFilesPath导出目录
/// Output：       对输出参数的说明
/// Return：       函数返回值的说明
/// Others：       其它说明
/// D ##Class(web.Util.UtilService).ExportClassByFileList("D:\classlist.txt","D:\class\")
ClassMethod ExportClassByFileList(FileListPath As %String, ExportFilesPath)
{
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=FileListPath
	s FileCnt=1
	While 'Stream.AtEnd {
		s Line=Stream.ReadLine()
		s Line=$tr(Line," ","")    ;+liusf 2012 03 02 
		w Line,!
		s ClsName=Line_".cls"
	    s ClsPath=ExportFilesPath_Line_".xml"
	    d $system.OBJ.Export(ClsName,ClsPath)
	    s FileCnt=FileCnt+1
	}
	w "Summary: "_FileCnt_" files have been exported to the "_ExportFilesPath,!
	quit 0
}

/// Creator：      guozongtao
/// CreatDate：    2010-03-23
/// Description:   指定路径下组件的XML,导入到环境中
/// 
/// Input:         Directory存放组件XML文件的路径
/// Output：       对输出参数的说明
/// Return：       函数返回值的说明
/// Others：       其它说明
/// d ##class(web.Util.UtilService).PutComponentByDirectory("D:\Component")
ClassMethod PutComponentByDirectory(Directory As %String)
{
	 s rs=##class(%ResultSet).%New("%File:FileSet")
	 s wildcard="*.xml" ,sortby="DateCreated"
	 s FileCnt=1
	 s Status=rs.Execute(Directory,wildcard,sortby)
	 while rs.Next() 
	 {
	   s fn=rs.Get("Name"),type=rs.Get("Type")
	   i $p(fn,".",$l(fn,"."))="xml" 
	   {
		   w "filename: ",fn,!
		   d ..PutComponent(fn)
		   d ##Class(%File).Rename(fn,fn_".imported")
		   s FileCnt=FileCnt+1
	   }
	 }
	 d rs.%Close()
	 w "Summary: "_FileCnt_" files have been imported",!
	 quit
}

}
