Class web.DHCMedUtil.UtilService Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 导出组件方法
/// d ##Class(web.DHCMedUtil.UtilService).GetComponents("ComponentAlias","E:\temp\")
/// d ##Class(web.DHCMedUtil.UtilService).GetComponent("ComponentName","E:\temp\")
/// 导入组件方法
/// d ##Class(web.DHCMedUtil.UtilService).PutComponents("ComponentList.TXT","E:\temp\")
/// d ##Class(web.DHCMedUtil.UtilService).PutComponent("E:\temp\ComponentName.XML")
/// 导出类方法
/// d ##Class(web.DHCMedUtil.UtilService).ExportClassforSVNOnName("web","ClassNameAlias","E:\temp\")
/// d ##Class(web.DHCMedUtil.UtilService).ExportClsforSVNOnDate("web","E:\temp\","2010-09-28","2010-10-08")
/// 
/// 导组件程序
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
	.Do $system.OBJ.Export(clsname,clspath)
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
	.Do $system.OBJ.Export(clsname,clspath)
}

/// Creator：      wuqk
/// CreatDate：    2010-01-15
/// Description:   导出包下所有制定开头名的类为xml文件到指定目录下
/// Table：        
/// Input：        packagename：包名  nameAlias：指定类开头名 path：路径(c:\tmp\)。
/// Output：       对输出参数的说明
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod ExportClassforSVNOnName(packagename As %String, nameAlias As %String, path As %String)
{
    s arrarylistcls=""
    s clsname="",clspath=""
	w $system.OBJ.GetPackageList(.arrarylistcls,packagename)
	s clskey=""
	f  s clskey=$o(arrarylistcls(clskey)) q:clskey=""  d
	.q:clskey'[nameAlias
	.s clsname=clskey_".cls"
	.s clspath=path_clskey_".xml"
	.Do $system.OBJ.Export(clsname,clspath)
}

/// Creator：      guozongtao
/// CreatDate：    2008-09-17
/// Description:   填充非持久化对象,序列化为xml,写入文件
/// Table：        websys.Component;websys.ComponentItems;websys.ComponentTableItems;websys.ComponentMessages 
/// Input：        ComponentId：websys.Component主键  ClassName：填充目标类名称; file 写入文件对象。
/// Output：       对输出参数的说明
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod FillRegisteredObject(ComponentId As %String, ClassName As %String, file As %File, TarGetPath As %String)
{
	k ^TMP($J,"PropertyName")
	if ClassName="web.DHCMedUtil.Component"
	{
		s aCmdCreateCls="objCompRegistered=##class("_ClassName_").%New()"
		s @aCmdCreateCls
		s objCompPersistent=##class(websys.Component).%OpenId(ComponentId)
		s obj=##Class(%Dictionary.CompiledClass).%OpenId("websys.Component")
		s cnt=obj.Properties.Count()
		f i=1:1:cnt  d
		.s PropertyName=obj.Properties.GetAt(i).Name
		.q:PropertyName="%Concurrency"  d
		.q:PropertyName="%IsInSave"  d
		.q:(obj.Properties.GetAt(i).Private=1)  d
		.i PropertyName="Template"  d
		..s mValue=""
		..s ^TMP($J,"PropertyName",PropertyName)=mValue
		..s mValue=$ZOBJPROPERTY(objCompPersistent,PropertyName)
		..S Config=##Class(websys.Configuration).%OpenId(1)
		..S SiteCode=Config.SiteCode
		..S LayOut=##Class(websys.Preferences).GetData("SITE",SiteCode,"LAYOUT",ComponentId)
		..S:LayOut'="" mValue=$LIST(LayOut,1)
		..s ^TMP($J,"PropertyName",PropertyName)=mValue
		.e  d
		..s mValue=$ZOBJPROPERTY(objCompPersistent,PropertyName)
		..s ^TMP($J,"PropertyName",PropertyName)=mValue
		.//i PropertyName="ClassName"  d
		.//.q:$ZOBJPROPERTY(objCompPersistent,"ClassName")=""
		.//.s clsname=mValue_".cls"
		.//.s clspath=TarGetPath_clsname_".xml"
		.//.Do $system.OBJ.Export(clsname,clspath)
		.s aCmdLetValue="objCompRegistered."_PropertyName_"="_"$g(^TMP($J,""PropertyName"",PropertyName))"
		.s @aCmdLetValue
		s aCmdLetValue="objCompRegistered."_"RowId"_"="_ComponentId
		s @aCmdLetValue
		s aCmdXmlExport="b=objCompRegistered.XMLExportToString(.xml)"
		s @aCmdXmlExport
		Do file.WriteLine(xml)
		w "...Export Component's Component is finished.",!
	}
	if ClassName="web.DHCMedUtil.ComponentItems"
	{
		s aCmdCreateCls="objCompRegistered=##class("_ClassName_").%New()"
		s @aCmdCreateCls
		s obj=##Class(%Dictionary.CompiledClass).%OpenId("websys.ComponentItems")
		s cnt=obj.Properties.Count()
		s ItemsID=""
		Do file.WriteLine("<Items>")
		f  s ItemsID=$o(^websys.ComponentItemsD(ComponentId,ItemsID)) q:ItemsID=""  d
		.s objCompPersistent=##class(websys.ComponentItems).%OpenId(ComponentId_"||"_ItemsID)
		.f i=1:1:cnt  d
		..s PropertyName=obj.Properties.GetAt(i).Name
		..q:PropertyName="%Concurrency"  d
		..q:PropertyName="%IsInSave"  d
		..q:(obj.Properties.GetAt(i).Private=1)  d
		..s mValue=$ZOBJPROPERTY(objCompPersistent,PropertyName)
		..s ^TMP($J,"PropertyName",PropertyName)=mValue
		..s aCmdLetValue="objCompRegistered."_PropertyName_"="_"$g(^TMP($J,""PropertyName"",PropertyName))"
		..s @aCmdLetValue	
		.s PropertyName="RowId"
		.s ^TMP($J,"PropertyName",PropertyName)=ComponentId_"||"_ItemsID
		.s aCmdLetValue="objCompRegistered."_PropertyName_"="_"$g(^TMP($J,""PropertyName"",PropertyName))"
		.s @aCmdLetValue
		.s aCmdXmlExport="b=objCompRegistered.XMLExportToString(.xml)"
		.s @aCmdXmlExport
	    .Do file.WriteLine(xml)
	    s aCmdLetObj=""
	    Do file.WriteLine("</Items>")
	    w "...Export Component's ComponentItems is finished.",!
	}
	if ClassName="web.DHCMedUtil.ComponentTableItems"
	{
		s aCmdCreateCls="objCompRegistered=##class("_ClassName_").%New()"
		s @aCmdCreateCls
		s obj=##Class(%Dictionary.CompiledClass).%OpenId("websys.ComponentTableItems")
		s cnt=obj.Properties.Count()
		s ItemsID=""
		Do file.WriteLine("<TableItems>")
		f  s ItemsID=$o(^websys.ComponentTableItemsD(ComponentId,ItemsID)) q:ItemsID=""  d
		.s objCompPersistent=##class(websys.ComponentTableItems).%OpenId(ComponentId_"||"_ItemsID)
		.f i=1:1:cnt  d
		..s PropertyName=obj.Properties.GetAt(i).Name
		..q:PropertyName="%Concurrency"  d
		..q:PropertyName="%IsInSave"  d
		..q:(obj.Properties.GetAt(i).Private=1)  d
		..s mValue=$ZOBJPROPERTY(objCompPersistent,PropertyName)
		..s ^TMP($J,"PropertyName",PropertyName)=mValue
		..s aCmdLetValue="objCompRegistered."_PropertyName_"="_"$g(^TMP($J,""PropertyName"",PropertyName))"
		..s @aCmdLetValue	
		.s PropertyName="RowId"
		.s ^TMP($J,"PropertyName",PropertyName)=ComponentId_"||"_ItemsID
		.s aCmdLetValue="objCompRegistered."_PropertyName_"="_"$g(^TMP($J,""PropertyName"",PropertyName))"
		.s @aCmdLetValue
		.s aCmdXmlExport="b=objCompRegistered.XMLExportToString(.xml)"
		.s @aCmdXmlExport
	    .Do file.WriteLine(xml)
	    Do file.WriteLine("</TableItems>")
	    w "...Export Component's ComponentTableItems is finished.",!
	}
	if ClassName="web.DHCMedUtil.ComponentMessages"
	{
		s aCmdCreateCls="objCompRegistered=##class("_ClassName_").%New()"
		s @aCmdCreateCls
		s obj=##Class(%Dictionary.CompiledClass).%OpenId("websys.ComponentMessages")
		s cnt=obj.Properties.Count()
		s ItemsID=""
		Do file.WriteLine("<Messages>")
		f  s ItemsID=$o(^websys.ComponentD(ComponentId,"Messages",ItemsID)) q:ItemsID=""  d
		.s objCompPersistent=##class(websys.ComponentMessages).%OpenId(ComponentId_"||"_ItemsID)
		.f i=1:1:cnt  d
		..s PropertyName=obj.Properties.GetAt(i).Name
		..q:PropertyName="%Concurrency"  d
		..q:PropertyName="%IsInSave"  d
		..q:(obj.Properties.GetAt(i).Private=1)  d
		..s mValue=$ZOBJPROPERTY(objCompPersistent,PropertyName)
		..s ^TMP($J,"PropertyName",PropertyName)=mValue
		..s aCmdLetValue="objCompRegistered."_PropertyName_"="_"$g(^TMP($J,""PropertyName"",PropertyName))"
		..s @aCmdLetValue	
		.s PropertyName="RowId"
		.s ^TMP($J,"PropertyName",PropertyName)=ComponentId_"||"_ItemsID
		.s aCmdLetValue="objCompRegistered."_PropertyName_"="_"$g(^TMP($J,""PropertyName"",PropertyName))"
		.s @aCmdLetValue
		.s aCmdXmlExport="b=objCompRegistered.XMLExportToString(.xml)"
		.s @aCmdXmlExport
	    .Do file.WriteLine(xml)
	    Do file.WriteLine("</Messages>")
	    w "...Export Component's ComponentMessages is finished.",!
	}
	k ^TMP($J,"PropertyName")
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
/// CreatDate：    2008-09-17
/// Description:   导出组件到xml文件
/// Table：        
/// Input：        ComponentName：websys.Component.Name 组件名称; TarGetPath：目标路径。。
/// Output：       
/// Return：       file.SizeGet():输出文件大小
/// Others：       其它说明
ClassMethod ExportComportToXml(ComponentId As %String, ComponentName As %String, TarGetPath As %String) As %String
{
	n (ComponentId,ComponentName,TarGetPath)
	q:(ComponentId="")||(ComponentName="")||(TarGetPath="")
	d ..CreateClassManager()
	Set file=##class(%File).%New(TarGetPath_ComponentName_".xml")
	Do file.Open("WSN")
    Do file.WriteLine("<"_"DHCCOMPONENTEXPORT"_">")
	d ..FillRegisteredObject(ComponentId,"web.DHCMedUtil.Component",file,TarGetPath)
	d ..FillRegisteredObject(ComponentId,"web.DHCMedUtil.ComponentItems",file)
	d ..FillRegisteredObject(ComponentId,"web.DHCMedUtil.ComponentTableItems",file)
	d ..FillRegisteredObject(ComponentId,"web.DHCMedUtil.ComponentMessages",file)
	Do file.WriteLine("</"_"DHCCOMPONENTEXPORT"_">")
	d file.Close()
	q file.SizeGet()
}

ClassMethod IsLayOut(ComponentId As %String)
{
	n (ComponentId)
	s ret=0
	S Config=##Class(websys.Configuration).%OpenId(1)
	S SiteCode=Config.SiteCode
	S LayOut=##Class(websys.Preferences).GetData("SITE",SiteCode,"LAYOUT",ComponentId)
	q:LayOut="" ret
	s ret=1
	q ret
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
	s tmpClassName="Tmp"_ClassName
	s:ClassName="websys.Component" UnusualProperties=$lb("CustomListFilter","ExpandTree","FixedWidthColumns","WrapColumns")
	s:ClassName="websys.ComponentItems" UnusualProperties=$lb("LinkConditionalExp","ReadOnly")
	s:ClassName="websys.ComponentTableItems" UnusualProperties=$lb("LinkConditionalExp","ReadOnly")
	s:$e(ClassName,1,7)="websys." tmpClassName="web.DHCMedUtil."_$e(ClassName,8,$l(ClassName))
	s cdef = ##class(%Dictionary.ClassDefinition).%New(tmpClassName)	
	s cdef.Super = "%RegisteredObject,%XML.Adaptor"
	s cdef.Owner= ""
	s pdef = ##class(%Dictionary.PropertyDefinition).%New("RowId")
	d cdef.Properties.Insert(pdef)
	s pdef.Name="RowId"
	S pdef.Type="%String"
	s obj=##Class(%Dictionary.CompiledClass).%OpenId(ClassName)
	s cnt=obj.Properties.Count()
	f i=1:1:cnt  d
	.s PropertiesName=obj.Properties.GetAt(i).Name
	.q:PropertiesName="%Concurrency"  d
	.q:PropertiesName="%IsInSave"  d
	.q:(obj.Properties.GetAt(i).Private=1)  d
	.q:(ClassName="websys.Component")&$listfind(UnusualProperties,PropertiesName)
	.q:(ClassName="websys.ComponentItems")&$listfind(UnusualProperties,PropertiesName)
	.q:(ClassName="websys.ComponentTableItems")&$listfind(UnusualProperties,PropertiesName)
	.s pdef = ##class(%Dictionary.PropertyDefinition).%New(PropertiesName)
	.d cdef.Properties.Insert(pdef)
	.s pdef.Name=PropertiesName
	.s pdef.Type="%String"
	.d pdef.Parameters.SetAt("","MAXLEN")
	.d pdef.Parameters.SetAt(1,"TRUNCATE")
	f ind=1:1:$listlength(UnusualProperties) d
	.s PropertiesName=$listget(UnusualProperties,ind)
	.s pdef = ##class(%Dictionary.PropertyDefinition).%New(PropertiesName)
	.d cdef.Properties.Insert(pdef)
	.s pdef.Name=PropertiesName
	.s pdef.Type="%String"
	.d pdef.Parameters.SetAt("","MAXLEN")
	.d pdef.Parameters.SetAt(1,"TRUNCATE")
	s SaveStatus=cdef.%Save()
	q:(+SaveStatus=0) "-1"
	q $System.OBJ.Compile(tmpClassName, "-d")
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
	s cdef = ##class(%Dictionary.ClassDefinition).%New("web.DHCMedUtil.RegisteredCls")	
	s cdef.Super = "%RegisteredObject,%XML.Adaptor"
	s cdef.Owner= ""
	s PropertiesName="Component"
	s pdef = ##class(%Dictionary.PropertyDefinition).%New(PropertiesName)
	d cdef.Properties.Insert(pdef)
	s pdef.Name=PropertiesName
	S pdef.Type="web.DHCMedUtil.Component"
	s PropertiesName="Items"
	s pdef = ##class(%Dictionary.PropertyDefinition).%New(PropertiesName)
	d cdef.Properties.Insert(pdef)
	s pdef.Name=PropertiesName
	S pdef.Type="web.DHCMedUtil.ComponentItems"
	S pdef.Collection="list"
	s PropertiesName="TableItems"
	s pdef = ##class(%Dictionary.PropertyDefinition).%New(PropertiesName)
	d cdef.Properties.Insert(pdef)
	s pdef.Name=PropertiesName
	s pdef.Type="web.DHCMedUtil.ComponentTableItems"
	S pdef.Collection="list"
	s PropertiesName="Messages"
	s pdef = ##class(%Dictionary.PropertyDefinition).%New(PropertiesName)
	d cdef.Properties.Insert(pdef)
	s pdef.Name=PropertiesName
	S pdef.Type="web.DHCMedUtil.ComponentMessages"
	S pdef.Collection="list"
	s SaveStatus=cdef.%Save()
	q:(+SaveStatus=0) "-1"
	q $System.OBJ.Compile("web.DHCMedUtil.RegisteredCls", "-d")
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
	s objExistsFlag=##class(%Dictionary.CompiledClass).%OpenId("web.DHCMedUtil.Component")
 	i objExistsFlag=""  d
    .d ..CreateClass("websys.Component")
	
	s objExistsFlag=##class(%Dictionary.CompiledClass).%OpenId("web.DHCMedUtil.ComponentItems")
 	i objExistsFlag=""  d
	.d ..CreateClass("websys.ComponentItems")
	
	s objExistsFlag=##class(%Dictionary.CompiledClass).%OpenId("web.DHCMedUtil.ComponentTableItem")
 	i objExistsFlag=""  d
	.d ..CreateClass("websys.ComponentTableItems")
	
	s objExistsFlag=##class(%Dictionary.CompiledClass).%OpenId("web.DHCMedUtil.ComponentMessages")
 	i objExistsFlag=""  d
	.d ..CreateClass("websys.ComponentMessages")

	s objExistsFlag=##class(%Dictionary.CompiledClass).%OpenId("web.DHCMedUtil.RegisteredCls")
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
ClassMethod GetComponents(ComponentName As %String, TarGetPath As %String)
{
	n (ComponentName,TarGetPath)
	q:(ComponentName="")||(TarGetPath="")
	k ^TMP($J,"ComponentID")
	s ComponentCnt=..GetExportCompentList(ComponentName)
	w "Summary Infomation : Component Count: "_ComponentCnt,!
	s ComponentId="",ComponentName=""
	f  s ComponentId=$o(^TMP($J,"ComponentID",ComponentId)) q:ComponentId=""  d
	.s ComponentName=$g(^TMP($J,"ComponentID",ComponentId))
	.d ..GetComponent(ComponentName,TarGetPath)
	s tmp=$tr($zd($p($h,",",1),3),"-","")_$tr($zt($p($h,",",2),1),":","")
	s ComListFile=##class(%File).%New(TarGetPath_"ComponentList"_tmp_".txt")
	d ComListFile.Open("WSN")
	s ComponentId=""
	f  s ComponentId=$o(^TMP($J,"ComponentID",ComponentId)) q:ComponentId=""  d
	.s ComponentName=$g(^TMP($J,"ComponentID",ComponentId))
	.d ComListFile.WriteLine(ComponentName)
	d ComListFile.Close()
	w "Component List:"_TarGetPath_"ComponentList"_tmp_".txt",!
	k ^TMP($J,"ComponentID")
	q
}

ClassMethod GetComponent(ComponentName As %String, TarGetPath As %String)
{
	n (ComponentName,TarGetPath)
	q:(ComponentName="")||(TarGetPath="")
	s flg=..CreateDirectory(TarGetPath)
	s ComponentId=$o(^websys.ComponentI("UniqueNameIndex",$$ALPHAUP^SSUTIL4(ComponentName),""))
	q:ComponentId=""
	w "GetComponent begin...",!
	w "...ComponentId: "_ComponentId,!
	s flg=..IsLayOut(ComponentId)
	w:flg=0 "...Component: "_ComponentName_" is not layout!",!
	k:flg=0 ^TMP($J,"ComponentID",ComponentId)
	q:flg=0
	s rtn=..ExportComportToXml(ComponentId,ComponentName,TarGetPath)
	w "...Component: "_ComponentName_" is finished!",!
	w "...FilePath:"_TarGetPath_ComponentName_".xml, "_"Size(byte): "_rtn,!
	q
}

ClassMethod PutComponents(FileName As %String, FilePath As %String)
{
	n (FileName,FilePath)
	q:(FileName="")||(FilePath="")
	k ^TMP($J,"ComponentID")
	i '##class(%File).Exists(FilePath_FileName) q
	s stream=##class(%FileCharacterStream).%New()
	s stream.Filename=FilePath_FileName
	s Ind=0
	While 'stream.AtEnd {
		s ComponentName=stream.ReadLine()
		i ComponentName="" continue
		i '##class(%File).Exists(FilePath_ComponentName_".xml") d
		.w "Component:"_FilePath_ComponentName_".xml is not exists!",!
		e  d
		.s Ind=Ind+1
		.s ^TMP($J,"ComponentID",Ind)=ComponentName
	}
	w "Summary Infomation : Component Count: "_Ind,!
	s Ind=0
	f  s Ind=$o(^TMP($J,"ComponentID",Ind)) q:Ind=""  d
	.s ComponentName=$g(^TMP($J,"ComponentID",Ind))
	.d ..PutComponent(FilePath_ComponentName_".xml")
	k ^TMP($J,"ComponentID")
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
ClassMethod PutComponent(FileName As %String)
{
	n (FileName)
	d ..CreateClassManager()
	K ^TMP($J,"EXPORT")
	s ExistsFlag=##Class(%File).Exists(FileName)
	q:ExistsFlag'=1  d
	Set reader = ##class(%XML.Reader).%New()
	set stream=##class(%FileCharacterStream).%New()
	set stream.Filename=FileName
	set sc=reader.OpenStream(stream)
	Do reader.Correlate("DHCCOMPONENTEXPORT","web.DHCMedUtil.RegisteredCls")
	While reader.Next(.obj,.sc) 
	{
		w "PutComponent begin...",!
		s ComponentName=obj.Component.Name
		
		If $d(^websys.ComponentI("UniqueNameIndex",$$ALPHAUP^SSUTIL4(ComponentName)))'=0 {
			Set ComponentId=""
			Set ComponentId=$o(^websys.ComponentI("UniqueNameIndex",$$ALPHAUP^SSUTIL4(ComponentName),ComponentId))
			Set objCompPersistent=##class(websys.Component).%OpenId(ComponentId)
			Set sc=##class(websys.Component).%DeleteId(ComponentId)
			If $$$ISERR(sc) {
				Do $System.Status.DisplayError(sc)
				Quit
			}
			Set objCompPersistent=##class(websys.Component).%New()
		} Else {
			Set objCompPersistent=##class(websys.Component).%New()
		}
		
		s objCompStructure=##Class(%Dictionary.CompiledClass).%OpenId("websys.Component")
		s cnt=objCompStructure.Properties.Count()
		for i=1:1:cnt
		{
			s aCmdLetValue=""
			s PropertyName=objCompStructure.Properties.GetAt(i).Name
			i objCompStructure.Properties.GetAt(i).Private=1 continue
			i PropertyName="%Concurrency" continue
			i PropertyName="%IsInSave" continue
            i PropertyName="RowId"  continue
            i PropertyName="ParRef"  continue
			s aCmdLetValue=	"^TMP($J,""EXPORT"",""Component"",PropertyName)"_"="_"obj.Component."_PropertyName	
		    s @aCmdLetValue
			s aCmdLetValue="objCompPersistent."_PropertyName_"="_"$g(^TMP($J,""EXPORT"",""Component"",PropertyName))"
			s @aCmdLetValue
			i PropertyName="Template" d
			.s layout=$g(^TMP($J,"EXPORT","Component","Template"))
			.q:layout=""
			.&SQL(Update websys.Component Set Template=:layout WHERE ID=:ComponentId)
		}
		d objCompPersistent.%Save()
		s ComponentId=objCompPersistent.%Id()
		
		w "...ComponentId = ",ComponentId,!
		w "...Import Component's Component is finished",!
		s objItemsStructure=##Class(%Dictionary.CompiledClass).%OpenId("websys.ComponentItems")
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
				i objItemsStructure.Properties.GetAt(k).Private=1 continue
				i PropertyName="%Concurrency" continue
				i PropertyName="%IsInSave" continue
	            i PropertyName="RowId"  continue
	            i PropertyName="ParRef"  continue
				s aCmdLetValue=	"^TMP($J,""EXPORT"",""Item"",j,PropertyName)"_"="_"obj.Items.GetAt(j)."_PropertyName	
			    s @aCmdLetValue
			    s aCmdLetValue="objItemsPersistent."_PropertyName_"="_"$g(^TMP($J,""EXPORT"",""Item"",j,PropertyName))"
				s @aCmdLetValue	
			}
			s objItemsPersistent.ParRef=objCompPersistent
			d objCompPersistent.%Save()	
		}
		
		w "...Import Component's ComponentItems is finished",!
		s objTableItemsStructure=##Class(%Dictionary.CompiledClass).%OpenId("websys.ComponentTableItems")
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
				i objTableItemsStructure.Properties.GetAt(k).Private=1 continue
				i PropertyName="%Concurrency" continue
				i PropertyName="%IsInSave" continue
				i PropertyName="RowId"  continue
				i PropertyName="ParRef"  continue
				s aCmdLetValue=	"^TMP($J,""EXPORT"",""TableItem"",PropertyName)"_"="_"obj.TableItems.GetAt(j)."_PropertyName	
			    s @aCmdLetValue
				s aCmdLetValue="objTableItemsPersistent."_PropertyName_"="_"$g(^TMP($J,""EXPORT"",""TableItem"",PropertyName))"
				s @aCmdLetValue	
			}

			s objTableItemsPersistent.ParRef=objCompPersistent
			d objCompPersistent.%Save()			
		}
		w "...Import Component's ComponentTableItems is finished",!
		s objMessageStructure=##Class(%Dictionary.CompiledClass).%OpenId("websys.ComponentMessages")
		s cnt=objMessageStructure.Properties.Count()
		s Count=obj.Messages.Count()
		if $d(^websys.ComponentD(ComponentId,"Messages"))'=0  d
		.s Childsub=""
		.f  s Childsub=$o(^websys.ComponentD(ComponentId,"Messages",Childsub)) q:Childsub=""  d
		..s mCurrRow=$g(^websys.ComponentD(ComponentId,"Messages",Childsub))
		..s objMessagePersistent=##class(websys.ComponentMessages).%OpenId(ComponentId_"||"_Childsub)
		..s ^TMP($J,"EXPORT",ComponentId,objMessagePersistent.Code)=ComponentId_"||"_Childsub
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
			if $d(^TMP($J,"EXPORT",ComponentId,MessageCode))'=0  d
			.s MessageId=$g(^TMP($J,"EXPORT",ComponentId,MessageCode))
			.s objMessagePersistent=##class(websys.ComponentMessages).%OpenId(MessageId)
			e  d
			.s objCompPersistent=##class(websys.Component).%OpenId(ComponentId)
			.s objMessagePersistent=##class(websys.ComponentMessages).%New()
			for k=1:1:cnt
			{
				s PropertyName=objMessageStructure.Properties.GetAt(k).Name
				i objMessageStructure.Properties.GetAt(k).Private=1 continue
				i PropertyName="%Concurrency" continue
				i PropertyName="%IsInSave" continue
				i PropertyName="RowId"  continue
				i PropertyName="ParRef"  continue
				s aCmdLetValue=	"^TMP($J,""EXPORT"",""Messages"",PropertyName)"_"="_"obj.Messages.GetAt(j)."_PropertyName	
			    s @aCmdLetValue
				s aCmdLetValue="objMessagePersistent."_PropertyName_"="_"$g(^TMP($J,""EXPORT"",""Messages"",PropertyName))"
				s @aCmdLetValue	
			}
			s objMessagePersistent.ParRef=objCompPersistent
			d objCompPersistent.%Save()
		}
		w "...Import Component's ComponentMessage is finished",!
		w "...Component: "_ComponentName_" is finished!",!
		w "...FilePath:"_FileName_"!",!
	}
	K ^TMP($J,"EXPORT")
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit
	Quit
}

/// 创建一个新目录
/// d ##class(web.DHCPE.IMPMenuAndCompont).CreateDirectory("d:\wrz\wrz\wrz")
ClassMethod CreateDirectory(directoryName)
{
	s flag=0
	s flag=..DirectoryExists(directoryName)
	i flag=0 d
	.s flag=##class(%File).CreateDirectoryChain(directoryName)
	q flag
}

/// 判断目录是否存在
ClassMethod DirectoryExists(directoryName)
{
	q ##class(%File).DirectoryExists(directoryName)
}

}
