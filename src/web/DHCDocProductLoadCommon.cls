Class web.DHCDocProductLoadCommon Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

ClassMethod FillMenuRegisteredObject(MenuId As %String, ClassName As %String, file As %File, TarGetPath As %String)
{
	n (MenuId,ClassName,file,TarGetPath)
	s aCmdCreateCls="objCompRegistered=##class("_ClassName_").%New()"
	s @aCmdCreateCls
	s aCmdCreatePerCls="objCompPersistent=##class("_$p(ClassName,"Tmp",2)_").%OpenId("_MenuId_")"
	s @aCmdCreatePerCls
	s obj=##Class(%Dictionary.CompiledClass).%OpenId($p(ClassName,"Tmp",2))
	s cnt=obj.Properties.Count()
	w "MenuId: ",MenuId,!
	f i=1:1:cnt  d
	.s PropertyName=obj.Properties.GetAt(i).Name
	.q:PropertyName="%Concurrency"  d
	.q:PropertyName="%IsInSave"  d
	.q:(obj.Properties.GetAt(i).Private=1)  d
	.s mValue=$ZOBJPROPERTY(objCompPersistent,PropertyName)
	.s ^CacheTemp(PropertyName)=mValue
	.i PropertyName="LinkComponent"  d
	..q:'$ISOBJECT($ZOBJPROPERTY(objCompPersistent,"LinkComponent"))
	..s CompId=$ZOBJPROPERTY(objCompPersistent,"LinkComponent").%Id()
	..s CompName=$ZOBJPROPERTY(objCompPersistent,"LinkComponent").Name
	..;d ##class(web.Util.UtilService).GetExportComponents(CompName,TarGetPath) 
	.i PropertyName="SubMenuOf"  d
	..q:'$ISOBJECT($ZOBJPROPERTY(objCompPersistent,"SubMenuOf"))
	..s SubMenuId=$ZOBJPROPERTY(objCompPersistent,"SubMenuOf").%Id()
	..s SubMenuName=$ZOBJPROPERTY(objCompPersistent,"SubMenuOf").Name
	..d ..FillMenuRegisteredObject(SubMenuId,"Tmpwebsys.Menu",file,TarGetPath)
	.i PropertyName="WorkFlow"  d
	..q:'$ISOBJECT($ZOBJPROPERTY(objCompPersistent,"WorkFlow"))
	..s ^CacheTemp(PropertyName)=$ZOBJPROPERTY(objCompPersistent,"WorkFlow").Name
	.i PropertyName="Worklist"  d
	..q:'$ISOBJECT($ZOBJPROPERTY(objCompPersistent,"Worklist"))
	..s ^CacheTemp(PropertyName)=$ZOBJPROPERTY(objCompPersistent,"Worklist").Name
	.s aCmdLetValue="objCompRegistered."_PropertyName_"="_"$g(^CacheTemp(PropertyName))"
	.s @aCmdLetValue
	s aCmdLetValue="objCompRegistered."_"RowId"_"="_MenuId
	s @aCmdLetValue
	s aCmdXmlExport="b=objCompRegistered.XMLExportToString(.xml)"
	s @aCmdXmlExport
	d file.WriteLine(xml)
	w "...Export Menu Name:"_objCompPersistent.Name_"'s Menu is finished.",!
	q
}

/// Creator：      郭荣勇
/// CreatDate：    2013-01-21
/// Description:   导出菜单到xml文件
/// Table：        
/// Input：        MenuName：websys.Menu.Name 组件名称; TarGetPath：目标路径。。
/// Output：       
/// Return：       file.SizeGet():输出文件大小
/// Others：       其它说明
/// W ##CLASS(web.Util.UtilService).ExportMenuToXml(52544,"DHC.Outpatient.Doctor.Help","C:\temp\Menu\")
ClassMethod ExportMenuToXml(MenuId As %String, MenuName As %String, TarGetPath As %String) As %String
{
	s ExistsFlag=##class(%File).DirectoryExists(TarGetPath)
	i 'ExistsFlag s ExistsFlag=##class(%File).CreateDirectoryChain(TarGetPath)
	i 'ExistsFlag w "创建导出菜单的目录失败",!
	
	s objExistsFlag=##class(%Dictionary.CompiledClass).%OpenId("Tmpwebsys.Menu")
 	i objExistsFlag=""  d
    .d ##class(web.Util.UtilService).CreateClass("websys.Menu")
	
	s file=##class(%File).%New(TarGetPath_MenuName_".xml")
	d file.Open("WSN")
    d file.WriteLine("<"_"DHCMENUEXPORT"_">")
    d file.WriteLine("<Menus>")
	d ..FillMenuRegisteredObject(MenuId,"Tmpwebsys.Menu",file,TarGetPath)
	d file.WriteLine("</Menus>")
	d file.WriteLine("</"_"DHCMENUEXPORT"_">") 
	d file.Close()
	q file.SizeGet()
}

ClassMethod ExportMenu(MenuName As %String, TarGetPath As %String = "")
{
}

/// Creator：      郭荣勇
/// CreatDate：    2013-01-21
/// Description:   从xml文件导入菜单
/// Table：        
/// Input：        FileName：导入文件路径。。
/// Output：       
/// Return：       
/// Others：       其它说明
/// W ##CLASS(web.Util.UtilService).ImportMenu("C:\temp\Menu\DHC.Outpatient.Doctor.Help.xml")
ClassMethod ImportMenu(FileName As %String)
{
	s objExistsFlag=##class(%Dictionary.CompiledClass).%OpenId("Tmpwebsys.Menu")
 	i objExistsFlag=""  d
    .d ##class(web.Util.UtilService).CreateClass("websys.Menu")
	
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
	/*
	d stream.Rewind()
	While 'stream.AtEnd {
		Set line=stream.ReadLine()
		w line,!
	}
	*/
	d reader.Correlate("DHCMENUEXPORT","web.Util.RegisteredMenuCls")
	
	While reader.Next(.obj,.sc) 
	{
		w "ImportMenu begin...",!
		s Count=obj.Menus.Count()
		for j=1:1:Count 
		{
			s MenuName=$$ALPHAUP^SSUTIL4(obj.Menus.GetAt(j).Name)
			if $d(^websys.MenuI("UniqueNameIndex",MenuName))'=0  d
			.s MenuNameId=""
			.s MenuNameId=$o(^websys.ComponentI("UniqueNameIndex",MenuName,MenuNameId))
			.s objMenuPersistent=##class(websys.Menu).%OpenId(MenuNameId)
			e  d
			.s objMenuPersistent=##class(websys.Menu).%New()
			s objMenuStructure=##Class(%Dictionary.CompiledClass).%OpenId("Tmpwebsys.Menu")
			s cnt=objMenuStructure.Properties.Count()
		
			for i=1:1:cnt
			{
				s aCmdLetValue=""
				s PropertyName=objMenuStructure.Properties.GetAt(i).Name
	            i PropertyName="RowId"  continue
	            i PropertyName="ParRef"  continue
	            i PropertyName="%%OID" continue		
				s aCmdLetValue=	"^TMP(""EXPORT"",""Menus"",PropertyName)"_"="_"obj.Menus.GetAt(j)."_PropertyName	
			    s @aCmdLetValue
				s aCmdLetValue="objMenuPersistent."_PropertyName_"="_"$g(^TMP(""EXPORT"",""Menus"",PropertyName))"
				s @aCmdLetValue	
				i PropertyName="WorkFlow" d
				.
				i PropertyName="Worklist" d
				.
			}
			d objMenuPersistent.%Save()
			s MenuId=objMenuPersistent.%Id()
			s MenuName=objMenuPersistent.Name
		
			w "...ImportMenu "_MenuName_" Menu is finished",!
		}
	}
	
	q
}

}
