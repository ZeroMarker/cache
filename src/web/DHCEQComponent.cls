Class web.DHCEQComponent Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Menu
/// d ##class(web.DHCEQComponent).BakMenus("8","DHCEQ","d:\DHCEQMenu.txt")
/// d ##class(web.DHCEQComponent).BakMenus("8","DHCEQ","/DHCEQMenu.txt")
ClassMethod BakMenus(FromVersion, nameprefix As %String, filename)
{
	new rset,sql,MenuName,MenuNames
	Set rset = ##class(%ResultSet).%New()
	set sql="SELECT Name FROM websys.Menu WHERE Name like '"_nameprefix_"%' Order By Name"
	//set sql="select sequence ,* from websys.menu where sequence like 'eq%' order by sequence" // 此条不能执行 2014-1-26 HZY0051
	//set sql="select sequence ,* from websys.menu where sequence like 'eq%'"	//2014-1-26 HZY0051
 	Do rset.Prepare(sql)
 	Do rset.Execute()
 	set MenuNames=""
 	
 	Set file=##class(%File).%New(filename)
	Do file.Open("WSN")
	
	While (rset.Next(.sc)) // go to the next row of the result set
 	{
 		If ($SYSTEM.Status.IsOK(sc)) // check if this succeeded without errors
 		{
 			set MenuName=rset.Data("Name") // perform busines logic
 			w MenuName,!
 			Do file.WriteLine(MenuName)
 			set parmenu=..BakMenu(FromVersion,MenuName) 		
	 		w parmenu,!
 			set MenuNames=MenuNames_MenuName_"_"_parmenu_","
 		}
 		Else // if there was an error, break out of the While loop
 		{
	    	w "err"
	   		Do file.Close()
 			Quit
 		}
 	}
 	If $SYSTEM.Status.IsError(sc) // if there was an error, process that
 	{
 		Kill ^DHCMenu(MenuName)
 	}
 	Do file.Close()
	Quit MenuNames
}

/// w ##Class(web.DHCEQComponent).BakMenu("EqPre.BuyReqAP1")
ClassMethod BakMenu(FromVersion, menuname As %String)
{
	new submenuname,linkcompname,menu
	s (submenuname,linkcompname)=""
	i menuname="" q ""
	Kill ^DHCMenu(menuname) 
	
	&SQL(SELECT ID,SubMenuOf->Name,LinkComponent->Name INTO :id,:submenuname,:linkcompname FROM websys.menu
			WHERE Name=:menuname)
	If SQLCODE Quit 1
	
	s menu=##class(websys.Menu).%OpenId(id)
	s ^DHCMenu(menuname,"ParName")=submenuname
	s ^DHCMenu(menuname,"ComponentName")=linkcompname
	;b
	s ^DHCMenu(menuname,"Caption")=menu.Caption
	s ^DHCMenu(menuname,"Chart")=menu.Chart
	s ^DHCMenu(menuname,"ChartBook")=menu.ChartBook
	s ^DHCMenu(menuname,"ConditionalExpression")=menu.ConditionalExpression
	s ^DHCMenu(menuname,"Image")=menu.Image
	i FromVersion'="5" d
	.s ^DHCMenu(menuname,"JavascriptFileName")=menu.JavascriptFileName
	s ^DHCMenu(menuname,"JavascriptFunction")=menu.JavascriptFunction
	//s ^DHCMenu(menuname,"LinkComponent")=menu.LinkComponent
	s ^DHCMenu(menuname,"LinkReport")=menu.LinkReport
	s ^DHCMenu(menuname,"LinkUrl")=menu.LinkUrl
	s ^DHCMenu(menuname,"Method")=menu.Method
	s ^DHCMenu(menuname,"Name")=menu.Name
	i FromVersion'="5" d
	.s ^DHCMenu(menuname,"PrintLocal")=menu.PrintLocal
	s ^DHCMenu(menuname,"PrintPreview")=menu.PrintPreview
	s ^DHCMenu(menuname,"Sequence")=menu.Sequence
	s ^DHCMenu(menuname,"ShortcutKey")=menu.ShortcutKey
	s ^DHCMenu(menuname,"ShowInNewWindow")=menu.ShowInNewWindow
	//s ^DHCMenu(menuname,"SubMenuOf")=menu.SubMenuOf
	s ^DHCMenu(menuname,"Target")=menu.Target
	s ^DHCMenu(menuname,"Type")=menu.Type
	s ^DHCMenu(menuname,"UpdateDate")=menu.UpdateDate
	s ^DHCMenu(menuname,"UpdateTime")=menu.UpdateTime
	;b
	;s ^DHCMenu(menuname,"UpdateUser")=menu.UpdateUser.%Id()
	s ^DHCMenu(menuname,"ValueExpression")=menu.ValueExpression
	s ^DHCMenu(menuname,"WorkFlow")=menu.WorkFlow
	s ^DHCMenu(menuname,"Worklist")=menu.Worklist


	q submenuname
}

/// w ##class(web.DHCPE.IMPMenuAndCompont).BakMenusFromFile("/tmp/DHCPEMenu.txt")
ClassMethod BakMenusFromFile(FromVersion, filename)
{
	new errs,line,parmenu
	If '##class(%File).Exists(filename) q
	s errs=""
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename=filename
	While 'stream.AtEnd {
		Set line=stream.ReadLine()
		if line="" continue
		set parmenu=..BakMenu(FromVersion,line) 		
	 	w parmenu,!
		}
	if (errs'="")
		{	w "err:"_errs}
	else
		{	w "import success!"}
}

/// w ##Class(web.DHCEQComponent).UpdateMenu("8","DHCEQ")
ClassMethod UpdateMenu(ToVersion, menuname As %String, ProjectFlag As %String = "")
{
	new (ToVersion,menuname,ProjectFlag)
	s menuname=##class(web.DHCEQCommon).Replace(menuname,$C(13),"")   //回车符转换为""
	set parid=""
	&SQL(SELECT id into :menuid FROM websys.Menu WHERE Name=:menuname)
	
	i menuid>0
	{
		s menu=##class(websys.Menu).%OpenId(menuid)
	}
	else
	{
		s menu=##class(websys.Menu).%New()
	}
	
	set parname=^DHCMenu(menuname,"ParName")
	i parname'=""
	{
		&SQL(SELECT id into :parid FROM websys.Menu WHERE Name=:parname)
		If SQLCODE<0 Quit SQLCODE
	
		s menu.SubMenuOf=##class(websys.Menu).%OpenId(parid)
	}
	
	s compname=$g(^DHCMenu(menuname,"ComponentName"))
	if (compname'="")
	{
		set compid=""		
		&SQL(select id into :compid from websys.component where name = :compname)
		s menu.LinkComponent=##class(websys.Component).%OpenId(compid)
		//s PLIST(8)=compid		
	}
	s menu.Caption=^DHCMenu(menuname,"Caption")
	i ((ProjectFlag'="")&&((menu.Caption["(待定)")||(menu.Caption["(作废)"))) q 999999
	i $g(^DHCMenu(menuname,"Chart"))'=""
	{
		;s menu.Chart=^DHCMenu(menuname,"Chart")
	}
	i $g(^DHCMenu(menuname,"ChartBook"))'=""
	{
		;s menu.ChartBook=^DHCMenu(menuname,"ChartBook")
	}
	s menu.ConditionalExpression=^DHCMenu(menuname,"ConditionalExpression")
	s menu.Image=^DHCMenu(menuname,"Image")
	//p5中无此字段
	i ToVersion'=5  d
	.s menu.JavascriptFileName=$g(^DHCMenu(menuname,"JavascriptFileName"))
	s menu.JavascriptFunction=^DHCMenu(menuname,"JavascriptFunction")
	;s menu.LinkComponent=^DHCMenu(menuname,"LinkComponent")
	i $g(^DHCMenu(menuname,"LinkReport"))'=""
	{
		;s menu.LinkReport=^DHCMenu(menuname,"LinkReport")
	}
	s menu.LinkUrl=^DHCMenu(menuname,"LinkUrl")
	s menu.Method=^DHCMenu(menuname,"Method")
	s menu.Name=^DHCMenu(menuname,"Name")
	//p5中无此字段
	i ToVersion'=5  d
	.s menu.PrintLocal=$g(^DHCMenu(menuname,"PrintLocal"))
	s menu.PrintPreview=^DHCMenu(menuname,"PrintPreview")
	s menu.Sequence=^DHCMenu(menuname,"Sequence")
	s menu.ShortcutKey=^DHCMenu(menuname,"ShortcutKey")
	s menu.ShowInNewWindow=^DHCMenu(menuname,"ShowInNewWindow")
	;s menu.SubMenuOf=^DHCMenu(menuname,"SubMenuOf")
	s menu.Target=^DHCMenu(menuname,"Target")
	s menu.Type=^DHCMenu(menuname,"Type")
	s menu.UpdateDate=^DHCMenu(menuname,"UpdateDate")
	s menu.UpdateTime=^DHCMenu(menuname,"UpdateTime")
	;s menu.UpdateUser=^DHCMenu(menuname,"UpdateUser")
	s menu.ValueExpression=^DHCMenu(menuname,"ValueExpression")
	i $g(^DHCMenu(menuname,"WorkFlow"))'=""
	{
		;s menu.WorkFlow=^DHCMenu(menuname,"WorkFlow")
	}
	i $g(^DHCMenu(menuname,"Worklist"))'=""
	{
		;s menu.Worklist=^DHCMenu(menuname,"Worklist")
	}
	
	s sc=menu.%Save()
	
	//add by czf 2021-03-03 给菜单关联院区
	s MenuRowID=menu.%Id()
	i MenuRowID'=""
	{
		i ##class(%Dictionary.MethodDefinition).%ExistsId("BSP.GRPHOSP.SRV.Interface||SetDataShowFlag") d	//添加类方法判断 czf 20211125
		.d ##class(BSP.GRPHOSP.SRV.Interface).SetDataShowFlag("websys.Menu",MenuRowID,"ALL")
	}
	
	q menu.%Id()
}

/// d ##class(web.DHCEQComponent).UpdateMenus("8","/tmp/DHCEQMenu.txt")
/// d ##class(web.DHCEQComponent).UpdateMenus("8","d:\DHCEQMenu.txt")
ClassMethod UpdateMenus(ToVersion As %String, filename As %String, ProjectFlag As %String = "")
{
	n line,errs,parid
	If '##class(%File).Exists(filename) q
	s errs=""
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename=filename
	While 'stream.AtEnd {
		Set line=stream.ReadLine()
		if line="" continue
		set parid=..UpdateMenu(ToVersion,line,ProjectFlag)

		w line_","_parid,!
		i parid<1 {
			s errs=errs_"@"_line_","_parid
		}
	}
	if (errs'="")
		{	w "err:"_errs}
	else
		{	w "import success!"}
}

/// FromVersion:  "5":P5   "7":P7  "8":P8
ClassMethod BakComponentsFromFile(FromVersion As %String, filename)
{
	If '##class(%File).Exists(filename) q
	new line,ComponentID,errs
	s errs=""
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename=filename
	While 'stream.AtEnd {
		Set line=stream.ReadLine()
		if line="" continue
		set ComponentID=..BakComponentNew(FromVersion,line)
 			
 		w line_","_ComponentID,!
		i ComponentID<=1 {
			s errs=errs_"@"_line_","_ComponentID
		}
	}
	if (errs'="")
		{	w "err:"_errs}
	else
		{	w "import success!"}
}

/// Creator：      guozongtao
/// CreatDate：    2008-09-17
/// Description:   导出包下所有类为xml文件到指定目录下
/// Table：        
/// Input：        ackagename：包名  path：路径(c:\tmp\) prefix:类名前缀。
/// Output：       对输出参数的说明
/// Return：       函数返回值的说明
/// Others：       其它说明
/// d ##Class(web.DHCEQComponent).ExportClassforSVN("web","d:\tmp\xml\","web.DHCEQ")
ClassMethod ExportClassforSVN(ackagename As %String, path As %String, prefix As %String)
{
    s arrarylistcls=""
    s clsname="",clspath=""
	w $system.OBJ.GetPackageList(.arrarylistcls,ackagename)
	s clskey=""
	f  s clskey=$o(arrarylistcls(clskey)) q:clskey=""  d
	.q:clskey'[prefix
	.d ..ExportClsToXML(clskey,path)
}

/// Creator：      guozongtao
/// CreatDate：    2008-09-17
/// Description:   按照修改日期范围,导出包下类为xml文件到指定目录下
/// Table：        
/// Input：        ackagename：包名  path：路径(c:\tmp\) StDate：开始日期 EndDate：截止日期 (YYYY-MM-DD)。
/// Output：       对输出参数的说明
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod ExportClsforSVNOnDate(ackagename As %String, path As %String, StDate As %String, EndDate As %String, prefix As %String)
{
	//日期格式同意调整 add by 吴月
	s mStdate=##Class(web.DHCEQCommon).TransValueFromPage(StDate,"Date")
	s mStdate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"Date")
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
	.q:clskey'[prefix
	.w "clsname: ",clskey,!
	.d ..ExportClsToXML(clskey,path)
}

ClassMethod ExportClsToXML(clskey, path)
{
	new clsname,clspath
	s clsname=clskey_".cls"
	s clspath=path_clskey_".xml"
	Do $system.OBJ.Export(clsname,clspath)
}

/// 
/// d ##class(web.DHCEQComponent).UpdateComponentsByXML("/tmp/DHCEQComponent.txt","/tmp/")
ClassMethod UpdateComponentsByXML(filename As %String, xmlpath As %String)
{
	If '##class(%File).Exists(filename) q
	new line,ComponentID,errs,componentcount,icount
	//new streama
	s errs=""
	s componentcount=1
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename=filename
	While '(stream.AtEnd) {
		Set line=stream.ReadLine()
		if line="" continue
		Set line=xmlpath_line_".xml"
		s PList(componentcount)=line
		s componentcount=componentcount+1
	}
	s componentcount=componentcount-1
	f icount=1:1:componentcount  d
	.w PList(icount)_":"_icount,!
	.d ##Class(web.Util.UtilService).PutComponent(PList(icount))
 	if (errs'="")
		{	w "err:"_errs}
	else
		{	w "import success!"}
}

/// w ##Class(web.DHCEQComponent).UpdateComponentNew("8","DHCEQAInMoveFind")
/// Create by jdl 2009-05-22
/// 更新组件
/// ToVersion:更新Trakcare版本(P5为5，P7为7，P8为8)	ComponentName：组件名称
/// modify by lmm 2020-05-15 DelComponentFlag:入参添加 是否删除组件主表
ClassMethod UpdateComponentNew(ToVersion, ComponentName, MsgFlag As %String = "Y", DelComponentFlag As %String = "")
{
	new SourceId,CurId
	new node,errs
	
	Set $ZT="ERRORUpdateComponent"
	
	s ComponentName=##class(web.DHCEQCommon).Replace(ComponentName,$C(13),"")   //回车符转换为""
	if MsgFlag="Y" 
	{
		w "导入组件"_ComponentName_",",!
		w "继续请输入g,取消请输入q,输入后回车!"
	}
	s errs =""
	//add by lmm 2020-05-15 begin
	if (DelComponentFlag="Y")
	{
		&SQL(Delete From websys.Component Where Name=:ComponentName)
	}
	//add by lmm 2020-05-15 end
			
	s CurId=""
	&SQL(SELECT ID INTO :CurId FROM websys.Component WHERE Name=:ComponentName)
	
	TStart
	if CurId=""
	{
		s component=##class(websys.Component).%New()
	}
	else
	{
		&SQL(Delete From websys.ComponentMessages Where parref=:CurId )
		&SQL(Delete From websys.ComponentTableItems Where parref=:CurId )
		&SQL(Delete From websys.ComponentItems Where parref=:CurId )
		&SQL(Delete From websys.Preferences Where AppSubkey=:CurId )
		;Add By JDL 20150906 V4.0.0 清除 layout
		&SQL(Delete From websys.Preferences Where AppSubkey=:ComponentName )
		
		s component=##class(websys.Component).%OpenId(CurId)
	}

	
	s SourceId=^DHCComponent(ComponentName,"COMP","ID")
	;if $g(^DHCComponent(ComponentName,"COMP","ID"))'="" s component.ID=^DHCComponent(ComponentName,"COMP","ID")
	if $g(^DHCComponent(ComponentName,"COMP","Caption"))'="" s component.Caption=^DHCComponent(ComponentName,"COMP","Caption")
	if $g(^DHCComponent(ComponentName,"COMP","Caption1"))'="" s component.Caption1=^DHCComponent(ComponentName,"COMP","Caption1")
	if $g(^DHCComponent(ComponentName,"COMP","Caption2"))'="" s component.Caption2=^DHCComponent(ComponentName,"COMP","Caption2")
	if $g(^DHCComponent(ComponentName,"COMP","Caption3"))'="" s component.Caption3=^DHCComponent(ComponentName,"COMP","Caption3")
	if $g(^DHCComponent(ComponentName,"COMP","Caption4"))'="" s component.Caption4=^DHCComponent(ComponentName,"COMP","Caption4")
	if $g(^DHCComponent(ComponentName,"COMP","Caption5"))'="" s component.Caption5=^DHCComponent(ComponentName,"COMP","Caption5")
	if $g(^DHCComponent(ComponentName,"COMP","Caption6"))'="" s component.Caption6=^DHCComponent(ComponentName,"COMP","Caption6")
	if $g(^DHCComponent(ComponentName,"COMP","Caption7"))'="" s component.Caption7=^DHCComponent(ComponentName,"COMP","Caption7")
	if $g(^DHCComponent(ComponentName,"COMP","Caption8"))'="" s component.Caption8=^DHCComponent(ComponentName,"COMP","Caption8")
	if $g(^DHCComponent(ComponentName,"COMP","Caption9"))'="" s component.Caption9=^DHCComponent(ComponentName,"COMP","Caption9")
	if $g(^DHCComponent(ComponentName,"COMP","CenterForm"))'="" s component.CenterForm=^DHCComponent(ComponentName,"COMP","CenterForm")
	if $g(^DHCComponent(ComponentName,"COMP","ClassName"))'="" s component.ClassName=^DHCComponent(ComponentName,"COMP","ClassName")
	if $g(^DHCComponent(ComponentName,"COMP","CodeTable"))'="" s component.CodeTable=^DHCComponent(ComponentName,"COMP","CodeTable")
	if ((ToVersion="7")||(ToVersion="8"))	d
	.if $g(^DHCComponent(ComponentName,"COMP","CustomListFilter"))'="" s component.CustomListFilter=^DHCComponent(ComponentName,"COMP","CustomListFilter")
	if $g(^DHCComponent(ComponentName,"COMP","CustomScript"))'="" s component.CustomScript=^DHCComponent(ComponentName,"COMP","CustomScript")
	if $g(^DHCComponent(ComponentName,"COMP","Disabled"))'="" s component.Disabled=^DHCComponent(ComponentName,"COMP","Disabled")
	if $g(^DHCComponent(ComponentName,"COMP","DisplayType"))'="" s component.DisplayType=^DHCComponent(ComponentName,"COMP","DisplayType")
	if ToVersion="8"  d
	.if $g(^DHCComponent(ComponentName,"COMP","ExpandTree"))'="" s component.ExpandTree=^DHCComponent(ComponentName,"COMP","ExpandTree")
	.if $g(^DHCComponent(ComponentName,"COMP","FixedWidthColumns"))'="" s component.FixedWidthColumns=^DHCComponent(ComponentName,"COMP","FixedWidthColumns")
	if $g(^DHCComponent(ComponentName,"COMP","FormSizeAndPosition"))'="" s component.FormSizeAndPosition=^DHCComponent(ComponentName,"COMP","FormSizeAndPosition")
	if $g(^DHCComponent(ComponentName,"COMP","Help"))'="" s component.Help=^DHCComponent(ComponentName,"COMP","Help")
	if $g(^DHCComponent(ComponentName,"COMP","HideHeadings"))'="" s component.HideHeadings=^DHCComponent(ComponentName,"COMP","HideHeadings")
	if $g(^DHCComponent(ComponentName,"COMP","HideMenus"))'="" s component.HideMenus=^DHCComponent(ComponentName,"COMP","HideMenus")
	if $g(^DHCComponent(ComponentName,"COMP","LastUpdateDate"))'="" s component.LastUpdateDate=^DHCComponent(ComponentName,"COMP","LastUpdateDate")
	if $g(^DHCComponent(ComponentName,"COMP","LastUpdateTime"))'="" s component.LastUpdateTime=^DHCComponent(ComponentName,"COMP","LastUpdateTime")
	if $g(^DHCComponent(ComponentName,"COMP","ListPrint"))'="" s component.ListPrint=^DHCComponent(ComponentName,"COMP","ListPrint")
	if $g(^DHCComponent(ComponentName,"COMP","ListRows"))'="" s component.ListRows=^DHCComponent(ComponentName,"COMP","ListRows")
	if $g(^DHCComponent(ComponentName,"COMP","LockExtraClass"))'="" s component.LockExtraClass=^DHCComponent(ComponentName,"COMP","LockExtraClass")
	if $g(^DHCComponent(ComponentName,"COMP","LockExtraId"))'="" s component.LockExtraId=^DHCComponent(ComponentName,"COMP","LockExtraId")
	if $g(^DHCComponent(ComponentName,"COMP","Menus"))'="" s component.Menus=^DHCComponent(ComponentName,"COMP","Menus")
	if $g(^DHCComponent(ComponentName,"COMP","MultiPart"))'="" s component.MultiPart=^DHCComponent(ComponentName,"COMP","MultiPart")
	s component.Name=ComponentName
	if $g(^DHCComponent(ComponentName,"COMP","OtherScripts"))'="" s component.OtherScripts=^DHCComponent(ComponentName,"COMP","OtherScripts")
	if $g(^DHCComponent(ComponentName,"COMP","PassThruParameters"))'="" s component.PassThruParameters=^DHCComponent(ComponentName,"COMP","PassThruParameters")
	if $g(^DHCComponent(ComponentName,"COMP","QueryName"))'="" s component.QueryName=^DHCComponent(ComponentName,"COMP","QueryName")
	if $g(^DHCComponent(ComponentName,"COMP","QuerySQL"))'="" s component.QuerySQL=^DHCComponent(ComponentName,"COMP","QuerySQL")
	if $g(^DHCComponent(ComponentName,"COMP","QuerySQLNames"))'="" s component.QuerySQLNames=^DHCComponent(ComponentName,"COMP","QuerySQLNames")
	if $g(^DHCComponent(ComponentName,"COMP","QuerySQLParsed"))'="" s component.QuerySQLParsed=^DHCComponent(ComponentName,"COMP","QuerySQLParsed")
	if $g(^DHCComponent(ComponentName,"COMP","Script"))'="" s component.Script=^DHCComponent(ComponentName,"COMP","Script")
	if $g(^DHCComponent(ComponentName,"COMP","ShowNextInNewWindow"))'="" s component.ShowNextInNewWindow=^DHCComponent(ComponentName,"COMP","ShowNextInNewWindow")
	if $g(^DHCComponent(ComponentName,"COMP","Style"))'="" s component.Style=^DHCComponent(ComponentName,"COMP","Style")
	;if $g(^DHCComponent(ComponentName,"COMP","TableDelimiters"))'="" s component.TableDelimiters=^DHCComponent(ComponentName,"COMP","TableDelimiters")
	;if $g(^DHCComponent(ComponentName,"COMP","TableSequence"))'="" s component.TableSequence=^DHCComponent(ComponentName,"COMP","TableSequence")
	;Add By JDL 20150906 V4.0.0 更新列设置
	s component.TableDelimiters=$g(^DHCComponent(ComponentName,"COMP","TableDelimiters"))
	s component.TableSequence=$g(^DHCComponent(ComponentName,"COMP","TableSequence"))
	
	
	;if $g(^DHCComponent(ComponentName,"COMP","Template"))'="" s component.Template=^DHCComponent(ComponentName,"COMP","Template")
	if $g(^DHCComponent(ComponentName,"COMP","UseFormSizeAndPosition"))'="" s component.UseFormSizeAndPosition=^DHCComponent(ComponentName,"COMP","UseFormSizeAndPosition")
	if ToVersion="8"  d
	.if $g(^DHCComponent(ComponentName,"COMP","WrapColumns"))'="" s component.WrapColumns=^DHCComponent(ComponentName,"COMP","WrapColumns")
	Set sc=component.%Save()
	If $$$ISERR(sc) 
	{
		d $System.Status.DisplayError(sc)
		TRollBack
		q "Save Component("_ComponentName_") failed."_sc
 	}	
	//if sc="0"
	//{
	//	TRollBack
	//	q "Save Component("_ComponentName_") failed."
	//}
	s CurId=component.%Id()
	;保存布局
	Set LAYOUT=^DHCComponent(ComponentName,"LAYOUT")
	Set LAYOUT=##Class(web.DHCEQCommon).Replace(LAYOUT,SourceId,CurId)
	s component.Template=LAYOUT
	Set sc=component.%Save()
	If $$$ISERR(sc)
	{
		d $System.Status.DisplayError(sc)
		TRollBack
		q "Save Component("_ComponentName_") Template failed."_$System.Status.DisplayError()
	}
	/*
	if sc="0"
	{
		TRollBack
		q "Save Component("_ComponentName_") Template failed."
	}
	*/
	
	;保存Items
	s node=""
	f  s node=$o(^DHCComponent(ComponentName,"ITEMS",node))  quit:((node="")||(errs'=""))  d
	.s item=##class(websys.ComponentItems).%New()
	.s item.ParRef=component
	.;if $g(^DHCComponent(ComponentName,"ITEMS",node,"ID"))'="" s item.ID=^DHCComponent(ComponentName,"ITEMS",node,"ID")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"AttachedFile"))'="" s item.AttachedFile=^DHCComponent(ComponentName,"ITEMS",node,"AttachedFile")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"Caption"))'="" s item.Caption=^DHCComponent(ComponentName,"ITEMS",node,"Caption")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"CaptionStyle"))'="" s item.CaptionStyle=^DHCComponent(ComponentName,"ITEMS",node,"CaptionStyle")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"ClassMethod"))'="" s item.ClassMethod=^DHCComponent(ComponentName,"ITEMS",node,"ClassMethod")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"ClassMethodIfDirty"))'="" s item.ClassMethodIfDirty=^DHCComponent(ComponentName,"ITEMS",node,"ClassMethodIfDirty")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"CustomExpression"))'="" s item.CustomExpression=^DHCComponent(ComponentName,"ITEMS",node,"CustomExpression")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"CustomLookupBrokerMethod"))'="" s item.CustomLookupBrokerMethod=^DHCComponent(ComponentName,"ITEMS",node,"CustomLookupBrokerMethod")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"CustomLookupClassName"))'="" s item.CustomLookupClassName=^DHCComponent(ComponentName,"ITEMS",node,"CustomLookupClassName")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"CustomLookupProperties"))'="" s item.CustomLookupProperties=^DHCComponent(ComponentName,"ITEMS",node,"CustomLookupProperties")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"CustomLookupQueryName"))'="" s item.CustomLookupQueryName=^DHCComponent(ComponentName,"ITEMS",node,"CustomLookupQueryName")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"DataType"))'="" s item.DataType=^DHCComponent(ComponentName,"ITEMS",node,"DataType")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"DefaultValueAlways"))'="" s item.DefaultValueAlways=^DHCComponent(ComponentName,"ITEMS",node,"DefaultValueAlways")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"DefaultValueExpression"))'="" s item.DefaultValueExpression=^DHCComponent(ComponentName,"ITEMS",node,"DefaultValueExpression")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"Description"))'="" s item.Description=^DHCComponent(ComponentName,"ITEMS",node,"Description")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"Disabled"))'="" s item.Disabled=^DHCComponent(ComponentName,"ITEMS",node,"Disabled")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"DisplayOnly"))'="" s item.DisplayOnly=^DHCComponent(ComponentName,"ITEMS",node,"DisplayOnly")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"DisplayType"))'="" s item.DisplayType=^DHCComponent(ComponentName,"ITEMS",node,"DisplayType")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"HelpUrl"))'="" s item.HelpUrl=^DHCComponent(ComponentName,"ITEMS",node,"HelpUrl")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"Hidden"))'="" s item.Hidden=^DHCComponent(ComponentName,"ITEMS",node,"Hidden")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"IconProfile"))'="" s item.IconProfile=^DHCComponent(ComponentName,"ITEMS",node,"IconProfile")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"Image"))'="" s item.Image=^DHCComponent(ComponentName,"ITEMS",node,"Image")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"ItemIdGetExpression"))'="" s item.ItemIdGetExpression=^DHCComponent(ComponentName,"ITEMS",node,"ItemIdGetExpression")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"LinkComponent"))'="" s item.LinkComponent=^DHCComponent(ComponentName,"ITEMS",node,"LinkComponent")
	.if ((ToVersion="7")||(ToVersion="8"))  d
	..if $g(^DHCComponent(ComponentName,"ITEMS",node,"LinkConditionalExp"))'="" s item.LinkConditionalExp=^DHCComponent(ComponentName,"ITEMS",node,"LinkConditionalExp")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"LinkExpression"))'="" s item.LinkExpression=^DHCComponent(ComponentName,"ITEMS",node,"LinkExpression")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"LinkUrl"))'="" s item.LinkUrl=^DHCComponent(ComponentName,"ITEMS",node,"LinkUrl")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"LinkWorkFlow"))'="" s item.LinkWorkFlow=^DHCComponent(ComponentName,"ITEMS",node,"LinkWorkFlow")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"ListCellStyle"))'="" s item.ListCellStyle=^DHCComponent(ComponentName,"ITEMS",node,"ListCellStyle")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"LookupBrokerMethod"))'="" s item.LookupBrokerMethod=^DHCComponent(ComponentName,"ITEMS",node,"LookupBrokerMethod")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"LookupClassName"))'="" s item.LookupClassName=^DHCComponent(ComponentName,"ITEMS",node,"LookupClassName")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"LookupCustomComponent"))'="" s item.LookupCustomComponent=^DHCComponent(ComponentName,"ITEMS",node,"LookupCustomComponent")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"LookupJavascriptFunction"))'="" s item.LookupJavascriptFunction=^DHCComponent(ComponentName,"ITEMS",node,"LookupJavascriptFunction")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"LookupProperties"))'="" s item.LookupProperties=^DHCComponent(ComponentName,"ITEMS",node,"LookupProperties")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"LookupQueryName"))'="" s item.LookupQueryName=^DHCComponent(ComponentName,"ITEMS",node,"LookupQueryName")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"LookupUserDefined"))'="" s item.LookupUserDefined=^DHCComponent(ComponentName,"ITEMS",node,"LookupUserDefined")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"LookupUserDefinedValues"))'="" s item.LookupUserDefinedValues=^DHCComponent(ComponentName,"ITEMS",node,"LookupUserDefinedValues")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"Name"))'="" s item.Name=^DHCComponent(ComponentName,"ITEMS",node,"Name")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"NestedComponent"))'="" s item.NestedComponent=^DHCComponent(ComponentName,"ITEMS",node,"NestedComponent")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"NestedCondExpr"))'="" s item.NestedCondExpr=^DHCComponent(ComponentName,"ITEMS",node,"NestedCondExpr")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"NestedTransExpr"))'="" s item.NestedTransExpr=^DHCComponent(ComponentName,"ITEMS",node,"NestedTransExpr")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"OrderByAsc"))'="" s item.OrderByAsc=^DHCComponent(ComponentName,"ITEMS",node,"OrderByAsc")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"OrderByDesc"))'="" s item.OrderByDesc=^DHCComponent(ComponentName,"ITEMS",node,"OrderByDesc")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"Password"))'="" s item.Password=^DHCComponent(ComponentName,"ITEMS",node,"Password")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"PasswordKeepVal"))'="" s item.PasswordKeepVal=^DHCComponent(ComponentName,"ITEMS",node,"PasswordKeepVal")
	.if ((ToVersion="7")||(ToVersion="8"))  d
	..if $g(^DHCComponent(ComponentName,"ITEMS",node,"ReadOnly"))'="" s item.ReadOnly=^DHCComponent(ComponentName,"ITEMS",node,"ReadOnly")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"ReferencedObject"))'="" s item.ReferencedObject=^DHCComponent(ComponentName,"ITEMS",node,"ReferencedObject")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"Required"))'="" s item.Required=^DHCComponent(ComponentName,"ITEMS",node,"Required")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"SQLColumn"))'="" s item.SQLColumn=^DHCComponent(ComponentName,"ITEMS",node,"SQLColumn")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"SQLComment"))'="" s item.SQLComment=^DHCComponent(ComponentName,"ITEMS",node,"SQLComment")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"SQLExtendedReference"))'="" s item.SQLExtendedReference=^DHCComponent(ComponentName,"ITEMS",node,"SQLExtendedReference")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"SQLTable"))'="" s item.SQLTable=^DHCComponent(ComponentName,"ITEMS",node,"SQLTable")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"SQLToVBCodeTable"))'="" s item.SQLToVBCodeTable=^DHCComponent(ComponentName,"ITEMS",node,"SQLToVBCodeTable")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"ShortcutKey"))'="" s item.ShortcutKey=^DHCComponent(ComponentName,"ITEMS",node,"ShortcutKey")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"ShowInNewWindow"))'="" s item.ShowInNewWindow=^DHCComponent(ComponentName,"ITEMS",node,"ShowInNewWindow")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"Style"))'="" s item.Style=^DHCComponent(ComponentName,"ITEMS",node,"Style")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"TabSequence"))'="" s item.TabSequence=^DHCComponent(ComponentName,"ITEMS",node,"TabSequence")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"Tooltip"))'="" s item.Tooltip=^DHCComponent(ComponentName,"ITEMS",node,"Tooltip")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"ValueDefault"))'="" s item.ValueDefault=^DHCComponent(ComponentName,"ITEMS",node,"ValueDefault")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"ValueGet"))'="" s item.ValueGet=^DHCComponent(ComponentName,"ITEMS",node,"ValueGet")
	.if $g(^DHCComponent(ComponentName,"ITEMS",node,"ValueSet"))'="" s item.ValueSet=^DHCComponent(ComponentName,"ITEMS",node,"ValueSet")
	.;if $g(^DHCComponent(ComponentName,"ITEMS",node,"childsub"))'="" s item.childsub=^DHCComponent(ComponentName,"ITEMS",node,"childsub")
	.Set sc=item.%Save()
	.If $$$ISERR(sc)  d
	..d $System.Status.DisplayError(sc)
	..s errs= "Save Component Item("_ComponentName_"--"_^DHCComponent(ComponentName,"ITEMS",node,"Name")_") failed."_sc
	if errs'=""
	{
		TRollBack
		q errs
	}
	
	/*
	///Add by JDL0140 临时用于插入列表元素
	s errs=##Class(web.DHCEQComponent).InsertTableItems(component,"THiddenItem",15)
	if errs'=""
	{
		TRollBack
		q errs
	}
	*/
	
	;保存TableItems
	s node=""
	f  s node=$o(^DHCComponent(ComponentName,"TABLEITEMS",node))  quit:((node="")||(errs'=""))  d
	.s tableitem=##class(websys.ComponentTableItems).%New()
	.s tableitem.ParRef=component
	.;if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"ID"))'="" s tableitem.ID=^DHCComponent(ComponentName,"TABLEITEMS",node,"ID")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"AttachedFile"))'="" s tableitem.AttachedFile=^DHCComponent(ComponentName,"TABLEITEMS",node,"AttachedFile")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"Caption"))'="" s tableitem.Caption=^DHCComponent(ComponentName,"TABLEITEMS",node,"Caption")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"CaptionStyle"))'="" s tableitem.CaptionStyle=^DHCComponent(ComponentName,"TABLEITEMS",node,"CaptionStyle")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"ClassMethod"))'="" s tableitem.ClassMethod=^DHCComponent(ComponentName,"TABLEITEMS",node,"ClassMethod")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"ClassMethodIfDirty"))'="" s tableitem.ClassMethodIfDirty=^DHCComponent(ComponentName,"TABLEITEMS",node,"ClassMethodIfDirty")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"CustomExpression"))'="" s tableitem.CustomExpression=^DHCComponent(ComponentName,"TABLEITEMS",node,"CustomExpression")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"CustomLookupBrokerMethod"))'="" s tableitem.CustomLookupBrokerMethod=^DHCComponent(ComponentName,"TABLEITEMS",node,"CustomLookupBrokerMethod")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"CustomLookupClassName"))'="" s tableitem.CustomLookupClassName=^DHCComponent(ComponentName,"TABLEITEMS",node,"CustomLookupClassName")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"CustomLookupProperties"))'="" s tableitem.CustomLookupProperties=^DHCComponent(ComponentName,"TABLEITEMS",node,"CustomLookupProperties")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"CustomLookupQueryName"))'="" s tableitem.CustomLookupQueryName=^DHCComponent(ComponentName,"TABLEITEMS",node,"CustomLookupQueryName")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"DataType"))'="" s tableitem.DataType=^DHCComponent(ComponentName,"TABLEITEMS",node,"DataType")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"DefaultValueAlways"))'="" s tableitem.DefaultValueAlways=^DHCComponent(ComponentName,"TABLEITEMS",node,"DefaultValueAlways")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"DefaultValueExpression"))'="" s tableitem.DefaultValueExpression=^DHCComponent(ComponentName,"TABLEITEMS",node,"DefaultValueExpression")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"Description"))'="" s tableitem.Description=^DHCComponent(ComponentName,"TABLEITEMS",node,"Description")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"Disabled"))'="" s tableitem.Disabled=^DHCComponent(ComponentName,"TABLEITEMS",node,"Disabled")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"DisplayOnly"))'="" s tableitem.DisplayOnly=^DHCComponent(ComponentName,"TABLEITEMS",node,"DisplayOnly")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"DisplayType"))'="" s tableitem.DisplayType=^DHCComponent(ComponentName,"TABLEITEMS",node,"DisplayType")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"HelpUrl"))'="" s tableitem.HelpUrl=^DHCComponent(ComponentName,"TABLEITEMS",node,"HelpUrl")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"Hidden"))'="" s tableitem.Hidden=^DHCComponent(ComponentName,"TABLEITEMS",node,"Hidden")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"IconProfile"))'="" s tableitem.IconProfile=^DHCComponent(ComponentName,"TABLEITEMS",node,"IconProfile")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"Image"))'="" s tableitem.Image=^DHCComponent(ComponentName,"TABLEITEMS",node,"Image")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"ItemIdGetExpression"))'="" s tableitem.ItemIdGetExpression=^DHCComponent(ComponentName,"TABLEITEMS",node,"ItemIdGetExpression")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"LinkComponent"))'="" s tableitem.LinkComponent=^DHCComponent(ComponentName,"TABLEITEMS",node,"LinkComponent")
	.if ((ToVersion="7")||(ToVersion="8"))  d
	..if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"LinkConditionalExp"))'="" s tableitem.LinkConditionalExp=^DHCComponent(ComponentName,"TABLEITEMS",node,"LinkConditionalExp")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"LinkExpression"))'="" s tableitem.LinkExpression=^DHCComponent(ComponentName,"TABLEITEMS",node,"LinkExpression")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"LinkUrl"))'="" s tableitem.LinkUrl=^DHCComponent(ComponentName,"TABLEITEMS",node,"LinkUrl")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"LinkWorkFlow"))'="" s tableitem.LinkWorkFlow=^DHCComponent(ComponentName,"TABLEITEMS",node,"LinkWorkFlow")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"ListCellStyle"))'="" s tableitem.ListCellStyle=^DHCComponent(ComponentName,"TABLEITEMS",node,"ListCellStyle")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"LookupBrokerMethod"))'="" s tableitem.LookupBrokerMethod=^DHCComponent(ComponentName,"TABLEITEMS",node,"LookupBrokerMethod")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"LookupClassName"))'="" s tableitem.LookupClassName=^DHCComponent(ComponentName,"TABLEITEMS",node,"LookupClassName")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"LookupCustomComponent"))'="" s tableitem.LookupCustomComponent=^DHCComponent(ComponentName,"TABLEITEMS",node,"LookupCustomComponent")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"LookupJavascriptFunction"))'="" s tableitem.LookupJavascriptFunction=^DHCComponent(ComponentName,"TABLEITEMS",node,"LookupJavascriptFunction")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"LookupProperties"))'="" s tableitem.LookupProperties=^DHCComponent(ComponentName,"TABLEITEMS",node,"LookupProperties")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"LookupQueryName"))'="" s tableitem.LookupQueryName=^DHCComponent(ComponentName,"TABLEITEMS",node,"LookupQueryName")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"LookupUserDefined"))'="" s tableitem.LookupUserDefined=^DHCComponent(ComponentName,"TABLEITEMS",node,"LookupUserDefined")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"LookupUserDefinedValues"))'="" s tableitem.LookupUserDefinedValues=^DHCComponent(ComponentName,"TABLEITEMS",node,"LookupUserDefinedValues")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"Name"))'="" s tableitem.Name=^DHCComponent(ComponentName,"TABLEITEMS",node,"Name")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"NestedComponent"))'="" s tableitem.NestedComponent=^DHCComponent(ComponentName,"TABLEITEMS",node,"NestedComponent")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"NestedCondExpr"))'="" s tableitem.NestedCondExpr=^DHCComponent(ComponentName,"TABLEITEMS",node,"NestedCondExpr")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"NestedTransExpr"))'="" s tableitem.NestedTransExpr=^DHCComponent(ComponentName,"TABLEITEMS",node,"NestedTransExpr")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"OrderByAsc"))'="" s tableitem.OrderByAsc=^DHCComponent(ComponentName,"TABLEITEMS",node,"OrderByAsc")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"OrderByDesc"))'="" s tableitem.OrderByDesc=^DHCComponent(ComponentName,"TABLEITEMS",node,"OrderByDesc")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"Password"))'="" s tableitem.Password=^DHCComponent(ComponentName,"TABLEITEMS",node,"Password")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"PasswordKeepVal"))'="" s tableitem.PasswordKeepVal=^DHCComponent(ComponentName,"TABLEITEMS",node,"PasswordKeepVal")
	.if ((ToVersion="7")||(ToVersion="8"))  d
	..if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"ReadOnly"))'="" s tableitem.ReadOnly=^DHCComponent(ComponentName,"TABLEITEMS",node,"ReadOnly")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"ReferencedObject"))'="" s tableitem.ReferencedObject=^DHCComponent(ComponentName,"TABLEITEMS",node,"ReferencedObject")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"Required"))'="" s tableitem.Required=^DHCComponent(ComponentName,"TABLEITEMS",node,"Required")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"SQLColumn"))'="" s tableitem.SQLColumn=^DHCComponent(ComponentName,"TABLEITEMS",node,"SQLColumn")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"SQLComment"))'="" s tableitem.SQLComment=^DHCComponent(ComponentName,"TABLEITEMS",node,"SQLComment")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"SQLExtendedReference"))'="" s tableitem.SQLExtendedReference=^DHCComponent(ComponentName,"TABLEITEMS",node,"SQLExtendedReference")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"SQLTable"))'="" s tableitem.SQLTable=^DHCComponent(ComponentName,"TABLEITEMS",node,"SQLTable")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"SQLToVBCodeTable"))'="" s tableitem.SQLToVBCodeTable=^DHCComponent(ComponentName,"TABLEITEMS",node,"SQLToVBCodeTable")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"ShortcutKey"))'="" s tableitem.ShortcutKey=^DHCComponent(ComponentName,"TABLEITEMS",node,"ShortcutKey")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"ShowInNewWindow"))'="" s tableitem.ShowInNewWindow=^DHCComponent(ComponentName,"TABLEITEMS",node,"ShowInNewWindow")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"Style"))'="" s tableitem.Style=^DHCComponent(ComponentName,"TABLEITEMS",node,"Style")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"TabSequence"))'="" s tableitem.TabSequence=^DHCComponent(ComponentName,"TABLEITEMS",node,"TabSequence")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"Tooltip"))'="" s tableitem.Tooltip=^DHCComponent(ComponentName,"TABLEITEMS",node,"Tooltip")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"ValueDefault"))'="" s tableitem.ValueDefault=^DHCComponent(ComponentName,"TABLEITEMS",node,"ValueDefault")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"ValueGet"))'="" s tableitem.ValueGet=^DHCComponent(ComponentName,"TABLEITEMS",node,"ValueGet")
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"ValueSet"))'="" s tableitem.ValueSet=^DHCComponent(ComponentName,"TABLEITEMS",node,"ValueSet")
	.;if $g(^DHCComponent(ComponentName,"TABLEITEMS",node,"childsub"))'="" s tableitem.childsub=^DHCComponent(ComponentName,"TABLEITEMS",node,"childsub")
	.Set sc=tableitem.%Save()	
	.If $$$ISERR(sc)  d
	..d $System.Status.DisplayError(sc)
	..s errs= "Save Component TableItem("_ComponentName_"--"_^DHCComponent(ComponentName,"TABLEITEMS",node,"Name")_") failed."_sc
	if errs'=""
	{
		TRollBack
		q errs
	}
	
	;保存Messages
	s node=""
	f  s node=$o(^DHCComponent(ComponentName,"MESSAGES",node))  quit:((node="")||(errs'=""))  d
	.s message=##class(websys.ComponentMessages).%New()
	.s message.ParRef=component
	.s message.Code=^DHCComponent(ComponentName,"MESSAGES",node,"Code")
	.s message.Description=^DHCComponent(ComponentName,"MESSAGES",node,"Description")
	.Set sc=message.%Save()	
	.If $$$ISERR(sc)  d
	..d $System.Status.DisplayError(sc)
	..s errs= "Save Component Message("_ComponentName_"--"_^DHCComponent(ComponentName,"MESSAGES",node,"Description")_") failed."_sc
	if errs'=""
	{
		TRollBack
		q errs
	}
	
	/*	
	;保存站点
	S Config=##Class(websys.Configuration).%OpenId(1)
	S SiteCode=Config.SiteCode
	s preferences=##class(websys.Preferences).%New()
	s preferences.AppKey="LAYOUT"
	s preferences.AppSubKey=CurId
	s preferences.Data=LAYOUT
	s preferences.ObjectReference=SiteCode
	s preferences.ObjectType="SITE"
	Set sc=preferences.%Save()	
	if sc="0" s errs= "Save Component Preferences("_ComponentName_") failed."
	if errs'=""
	{
		TRollBack
		q errs
	}
	
	;保存：websys.ComponentXRef
	s ComponentXRef=##class(websys.ComponentXRef).%New()
	s CNLangId=$o(^SS("LAN",0,"Code","CHN",0))
	s ComponentXRef.ComponentId=CurId
	s ComponentXRef.App="SITE."_SiteCode
	s ComponentXRef.Context="-100000000000000"
	i CNLangId'="" s ComponentXRef.LangId=CNLangId
	s ComponentXRef.LastUpdateDate=+$H
	s ComponentXRef.LastUpdateTime=$p($H,",",2)
	*/
	
	TCommit	
	QUIT CurId
ERRORUpdateComponent
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORUpdateComponent"_ErrorMsg     //返回错误消息 ;
}

/// w ##Class(web.DHCEQComponent).BakComponentNew(8,"DHCEQAInMoveFind")
/// Create by jdl 2009-05-22
/// 备份组件
/// FromVersion:备份组件的Trakcare版本(P5为5,P7为7,P8为8)	ComponentName：组件名称
ClassMethod BakComponentNew(FromVersion, ComponentName)
{
	
	new err
	s err=""
	
	
	&SQL(SELECT ID INTO :ComponentId FROM websys.Component WHERE Name=:ComponentName)
	If SQLCODE Quit ComponentName_":does not find the component"
	Kill ^DHCComponent(ComponentName)

	s component=##class(websys.Component).%OpenId(ComponentId)
	if '$IsObject(component) q ComponentName_":is not an object reference"
	
	;保存组件信息
	s ^DHCComponent(ComponentName,"COMP","ID")=ComponentId
	s ^DHCComponent(ComponentName,"COMP","Caption")=component.Caption
	s ^DHCComponent(ComponentName,"COMP","Caption1")=component.Caption1
	s ^DHCComponent(ComponentName,"COMP","Caption2")=component.Caption2
	s ^DHCComponent(ComponentName,"COMP","Caption3")=component.Caption3
	s ^DHCComponent(ComponentName,"COMP","Caption4")=component.Caption4
	s ^DHCComponent(ComponentName,"COMP","Caption5")=component.Caption5
	s ^DHCComponent(ComponentName,"COMP","Caption6")=component.Caption6
	s ^DHCComponent(ComponentName,"COMP","Caption7")=component.Caption7
	s ^DHCComponent(ComponentName,"COMP","Caption8")=component.Caption8
	s ^DHCComponent(ComponentName,"COMP","Caption9")=component.Caption9
	s ^DHCComponent(ComponentName,"COMP","CenterForm")=component.CenterForm
	s ^DHCComponent(ComponentName,"COMP","ClassName")=component.ClassName
	s ^DHCComponent(ComponentName,"COMP","CodeTable")=component.CodeTable
	
	if ((FromVersion="7")||(FromVersion="8"))	d
	.s ^DHCComponent(ComponentName,"COMP","CustomListFilter")=component.CustomListFilter
	s ^DHCComponent(ComponentName,"COMP","CustomScript")=component.CustomScript
	s ^DHCComponent(ComponentName,"COMP","Disabled")=component.Disabled
	s ^DHCComponent(ComponentName,"COMP","DisplayType")=component.DisplayType
	
	if FromVersion="8"	d
	.s ^DHCComponent(ComponentName,"COMP","ExpandTree")=component.ExpandTree
	.s ^DHCComponent(ComponentName,"COMP","FixedWidthColumns")=component.FixedWidthColumns
	s ^DHCComponent(ComponentName,"COMP","FormSizeAndPosition")=component.FormSizeAndPosition
	s ^DHCComponent(ComponentName,"COMP","Help")=component.Help
	s ^DHCComponent(ComponentName,"COMP","HideHeadings")=component.HideHeadings
	s ^DHCComponent(ComponentName,"COMP","HideMenus")=component.HideMenus
	s ^DHCComponent(ComponentName,"COMP","LastUpdateDate")=component.LastUpdateDate
	s ^DHCComponent(ComponentName,"COMP","LastUpdateTime")=component.LastUpdateTime
	s ^DHCComponent(ComponentName,"COMP","ListPrint")=component.ListPrint
	s ^DHCComponent(ComponentName,"COMP","ListRows")=component.ListRows
	s ^DHCComponent(ComponentName,"COMP","LockExtraClass")=component.LockExtraClass
	s ^DHCComponent(ComponentName,"COMP","LockExtraId")=component.LockExtraId
	s ^DHCComponent(ComponentName,"COMP","Menus")=component.Menus
	s ^DHCComponent(ComponentName,"COMP","MultiPart")=component.MultiPart
	s ^DHCComponent(ComponentName,"COMP","Name")=component.Name
	s ^DHCComponent(ComponentName,"COMP","OtherScripts")=component.OtherScripts
	s ^DHCComponent(ComponentName,"COMP","PassThruParameters")=component.PassThruParameters
	s ^DHCComponent(ComponentName,"COMP","QueryName")=component.QueryName
	s ^DHCComponent(ComponentName,"COMP","QuerySQL")=component.QuerySQL
	s ^DHCComponent(ComponentName,"COMP","QuerySQLNames")=component.QuerySQLNames
	s ^DHCComponent(ComponentName,"COMP","QuerySQLParsed")=component.QuerySQLParsed
	s ^DHCComponent(ComponentName,"COMP","Script")=component.Script
	s ^DHCComponent(ComponentName,"COMP","ShowNextInNewWindow")=component.ShowNextInNewWindow
	s ^DHCComponent(ComponentName,"COMP","Style")=component.Style
	s ^DHCComponent(ComponentName,"COMP","TableDelimiters")=component.TableDelimiters
	s ^DHCComponent(ComponentName,"COMP","TableSequence")=component.TableSequence
	s ^DHCComponent(ComponentName,"COMP","Template")=component.Template
	s ^DHCComponent(ComponentName,"COMP","UseFormSizeAndPosition")=component.UseFormSizeAndPosition
	
	if FromVersion="8"	d
	.s ^DHCComponent(ComponentName,"COMP","WrapColumns")=component.WrapColumns

	
	;保存Layout
	S Config=##Class(websys.Configuration).%OpenId(1)
	S SiteCode=Config.SiteCode
	S LayOut=##Class(websys.Preferences).GetData("SITE",SiteCode,"LAYOUT",ComponentId)
	
	;2012-09-20  HZY0033
	/*
	i LayOut="" q ComponentName_":no layout" 
	s LayOut=$LIST(LayOut,1) 
	m ^DHCComponent(ComponentName,"LAYOUT")=LayOut
	*/
	if LayOut=""
	{
		if component.Template'=""
		{
			s ^DHCComponent(ComponentName,"LAYOUT")=component.Template
		}
		else
		{
			q ComponentName_":no layout , no Template" 
		}
	}
	else
	{	//2012-09-20
		s LayOut=$LIST(LayOut,1) 
		m ^DHCComponent(ComponentName,"LAYOUT")=LayOut
	}
	
	;保存Items信息
	s result = ##class(%Library.ResultSet).%New()
	s sql="select * from websys.componentitems where parref="_ComponentId 
	d result.Prepare(sql)
	d result.Execute()
	s node=1
	While (result.Next(.sc)&&(err="")) // go to the next row of the result set
 	{
 		If ($SYSTEM.Status.IsOK(sc)) // check if this succeeded without errors
 		{
	 		Set count = result.GetColumnCount()
 			For i = 1:1:count 
 			{
	 			;if node=1 w "i $g(^DHCComponent(ComponentName,"_"""ITEMS"""_",node,"""_result.GetColumnName(i)_"""))'="" s item."_result.GetColumnName(i)_"="_"^DHCComponent(ComponentName,"_"""ITEMS"""_",node,"""_result.GetColumnName(i)_""")",!	 			
	 			s ^DHCComponent(ComponentName,"ITEMS",node,result.GetColumnName(i))=result.GetData(i)
	 	 
			}
			s node=node+1
 		}
 		Else // if there was an error, break out of the While loop
 		{
	 		s err=ComponentName_":read items info error"
 			Quit
 		}
 	}
 	
 	;保存TableItems信息
	s result = ##class(%Library.ResultSet).%New()
	s sql="select * from websys.componenttableitems where parref="_ComponentId 
	d result.Prepare(sql)
	d result.Execute()
	s node=1
	While (result.Next(.sc)&&(err="")) // go to the next row of the result set
 	{
 		If ($SYSTEM.Status.IsOK(sc)) // check if this succeeded without errors
 		{
	 		Set count = result.GetColumnCount()
 			For i = 1:1:count 
 			{
	 			//if node=1 w result.GetColumnName(i)_"="_result.GetData(i),!
	 			s ^DHCComponent(ComponentName,"TABLEITEMS",node,result.GetColumnName(i))=result.GetData(i)
	 	 
			}
			s node=node+1
 		}
 		Else // if there was an error, break out of the While loop
 		{
	 		s err=ComponentName_":read tableitems info error"
 			Quit
 		}
 	}
 	
 	;保存Messages信息
	s result = ##class(%Library.ResultSet).%New()
	s sql="select * from websys.componentmessages where parref="_ComponentId 
	d result.Prepare(sql)
	d result.Execute()
	s node=1
	While (result.Next(.sc)&&(err="")) // go to the next row of the result set
 	{
 		If ($SYSTEM.Status.IsOK(sc)) // check if this succeeded without errors
 		{
	 		Set count = result.GetColumnCount()
 			For i = 1:1:count 
 			{
	 			//if node=1 w result.GetColumnName(i)_"="_result.GetData(i),!
	 			s ^DHCComponent(ComponentName,"MESSAGES",node,result.GetColumnName(i))=result.GetData(i)
	 	 
			}
			s node=node+1
 		}
 		Else // if there was an error, break out of the While loop
 		{
	 		s err=ComponentName_":read messages info error"
 			Quit
 		}
 	}
	d result.Close()
	
	q ComponentId
	
	/*
	;获取类定义
	Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId("websys.Component")
	Set count = cdef.Properties.Count()
 	For i = 1:1:count 
 	{
	 	 
     Write cdef.Properties.GetAt(i).Name,!
     
	}
	w "count:"_count
	q*/
}

/// 批量备份本地组件至^DHCComponent
/// FromVersion:  "5":P5   "7":P7  "8":P8
/// d ##class(web.DHCEQComponent).BakComponentsNew("8","DHCEQ","d:\DHCEQComponent.txt")
ClassMethod BakComponentsNew(FromVersion As %String, ComponentNamePrefix As %String, filename)
{
	new rset,sql,ComponentName,ComponentNames,ComponentID
	Set rset = ##class(%ResultSet).%New()
	set sql="SELECT Name FROM websys.Component WHERE Name like '"_ComponentNamePrefix_"%'"
 	Do rset.Prepare(sql)
 	Do rset.Execute()
 	set ComponentNames=""
 	
 	Set file=##class(%File).%New(filename)
	Do file.Open("WSN")
	
 	While (rset.Next(.sc)) // go to the next row of the result set
 	{
 		If ($SYSTEM.Status.IsOK(sc)) // check if this succeeded without errors
 		{
 			set ComponentName=rset.Data("Name") // perform busines logic
 			set ComponentID=..BakComponentNew(FromVersion,ComponentName)
 			
 			w ComponentID_"^"_ComponentName,!
 			Do file.WriteLine(ComponentName)
 			set ComponentNames=ComponentNames_ComponentName_"_"_ComponentID_","
 		}
 		Else // if there was an error, break out of the While loop
 		{
	        w "err"
	        Do file.Close()
 			Quit
 		}
 	}
	w sc,!
 	If $SYSTEM.Status.IsError(sc) // if there was an error, process that
 	{
 		Kill ^DHCComponent(ComponentName)
 	}   
	Do file.Close()
	Quit ComponentNames
}

/// 批量把^DHCComponent组件更新至本库
/// ToVersion:  "5":P5   "7":P7  "8":P8
/// d ##class(web.DHCEQComponent).UpdateComponentsNew("8","/tmp/DHCEQComponent.txt")
/// d ##class(web.DHCEQComponent).UpdateComponentsNew("8","d:\DHCEQComponent.txt")
/// modify by lmm 2020-05-14 DelComponentFlag:入参添加  是否删除组件主表
ClassMethod UpdateComponentsNew(ToVersion As %String, filename As %String, MsgFlag As %String = "Y", DelComponentFlag As %String = "")
{
	If '##class(%File).Exists(filename)
	{
		w "没有找到列表文件!"
		q
	}
	new line,ComponentID,errs
	s errs=""
	
	w "批量导入组件,组件列表文件"_filename,!
	w "继续请输入g,取消请输入q,输入后回车!"
	
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename=filename
	While 'stream.AtEnd {
		Set line=stream.ReadLine()
		if line="" continue
		set ComponentID=..UpdateComponentNew(ToVersion,line,MsgFlag,DelComponentFlag)
		w line_","_ComponentID,!
		i ComponentID<=1 {
			s errs=errs_"@"_line_","_ComponentID
		}
	}
	if (errs'="")
		{	w "err:"_errs}
	else
		{	w "import success!"}
}

/// Mozy0027	2010-11-01
/// 把源组件的元素复制目的组件上
/// type:	1."item"时操作界面元素	2."table"时操作表格元素
/// 返回值:	0-正常 		其他-错误
/// 注：新增表格元素需要在组件编辑器Layout重新编译一次
/// w ##Class(web.DHCEQTest).AddItemToComponent("table","DHCEQEquipFind","BAdd","DHCEQEquipFind","")
ClassMethod AddItemToComponent(type, SourceComp, SourceItem, DestComp, DestItem)
{
	Quit:(type'="item")&&(type'="table") "类型参数错误(应为item或table)"
	Quit:SourceComp="" "源组件不能为空"
	Quit:SourceItem="" "源组件元素不能为空"
	Quit:DestComp="" "目的组件不能为空"
	
	New SourceCompId,SourceItemId,DestCompId,DestItemId
	
	// 查找源组件信息
	Set SourceCompId="websys.ComponentItems"
	// select * from websys.Component where Name ='DHCEQEquipFind'
	&SQL(Select ID into :SourceCompId from websys.Component where Name=:SourceComp)
	Quit:SourceCompId="" "未找到源组件:"_SourceCompId
	
	//查找源组件元素信息
	Set SourceItemId=""
	// select * from websys.ComponentItems where ParRef=51154 and Name='BAdd'
	If type="item" &SQL(Select ID into :SourceItemId from websys.ComponentItems where ParRef=:SourceCompId and Name=:SourceItem)
	If type="table" &SQL(Select ID into :SourceItemId from websys.ComponentTableItems where ParRef=:SourceCompId and Name=:SourceItem)
	Quit:SourceItemId="" "未找到源组件元素:"_SourceItemId
	
	// 查找目的组件信息
	Set DestCompId=""
	// select * from websys.Component where Name ='DHCEQEquipFind'
	&SQL(Select ID into :DestCompId from websys.Component where Name=:DestComp)
	Quit:DestCompId="" "未找到目的组件:"_DestCompId
	
	// 查找目的组件元素信息
	Set DestItemId=""
	If DestItem'="" Do
	.If type="item" &SQL(Select ID into :DestItemId from websys.ComponentItems where ParRef=:DestCompId and Name=:DestItem)
	.If type="table" &SQL(Select ID into :DestItemId from websys.ComponentTableItems where ParRef=:DestCompId and Name=:DestItem)
	Else  Do
	.If type="item" &SQL(Select Count(ID) into :DestItemId from websys.ComponentItems where ParRef=:DestCompId and Name %STARTSWITH :SourceItem)
	.If type="table" &SQL(Select Count(ID) into :DestItemId from websys.ComponentTableItems where ParRef=:DestCompId and Name %STARTSWITH :SourceItem)
	.Set DestItemId=DestItemId+1
	.Set DestItemId=SourceItem_DestItemId
	Quit:(DestItem'="")&(DestItemId'="") "目的组件已经存在该元素:"_DestItem
	
	Set SQLCODE=0
	// select * from websys.ComponentItems where ParRef=51154 and Name='BAdd'
	If type="item" &SQL(Insert into websys.ComponentItems (ParRef, Caption, ClassMethod, ClassMethodIfDirty, DataType, DefaultValueAlways, Description, Disabled, DisplayOnly, DisplayType, Hidden, Image, LinkComponent, LinkExpression, LinkUrl, LookupBrokerMethod, LookupClassName, LookupJavascriptFunction, LookupProperties, LookupQueryName, LookupUserDefined, Name, ReadOnly, ReferencedObject, Required, SQLColumn, SQLExtendedReference, SQLTable, ShortcutKey, ShowInNewWindow, Style, TabSequence, Tooltip, ValueGet, ValueSet) select :DestCompId, :DestItemId, ClassMethod, ClassMethodIfDirty, DataType, DefaultValueAlways, Description, Disabled, DisplayOnly, DisplayType, Hidden, Image, LinkComponent, LinkExpression, LinkUrl, LookupBrokerMethod, LookupClassName, LookupJavascriptFunction, LookupProperties, LookupQueryName, LookupUserDefined, :DestItemId, ReadOnly, ReferencedObject, Required, SQLColumn, SQLExtendedReference, SQLTable, ShortcutKey, ShowInNewWindow, Style, TabSequence, Tooltip, ValueGet, ValueSet from websys.ComponentItems Where ParRef=:SourceCompId and Name=:SourceItem)
	If type="table" &SQL(Insert into websys.ComponentTableItems (ParRef, Caption, ClassMethod, ClassMethodIfDirty, DataType, DefaultValueAlways, Description, Disabled, DisplayOnly, DisplayType, Hidden, Image, LinkComponent, LinkExpression, LinkUrl, LookupBrokerMethod, LookupClassName, LookupJavascriptFunction, LookupProperties, LookupQueryName, LookupUserDefined, Name, ReadOnly, ReferencedObject, Required, SQLColumn, SQLExtendedReference, SQLTable, ShortcutKey, ShowInNewWindow, Style, TabSequence, Tooltip, ValueGet, ValueSet) select :DestCompId, :DestItemId, ClassMethod, ClassMethodIfDirty, DataType, DefaultValueAlways, Description, Disabled, DisplayOnly, DisplayType, Hidden, Image, LinkComponent, LinkExpression, LinkUrl, LookupBrokerMethod, LookupClassName, LookupJavascriptFunction, LookupProperties, LookupQueryName, LookupUserDefined, :DestItemId, ReadOnly, ReferencedObject, Required, SQLColumn, SQLExtendedReference, SQLTable, ShortcutKey, ShowInNewWindow, Style, TabSequence, Tooltip, ValueGet, ValueSet from websys.ComponentTableItems Where ParRef=:SourceCompId and Name=:SourceItem)
	
	Quit SQLCODE
}

/*
/// Add By JDL0140 20150821 导入组件时，插入列表元素
/// 入参：	Component 组件对象
/// 			ItemName:插入元素名字，插入元素名字以 ItemName+i 来命名
/// 			Rows:插入元素数量
/// w ##Class(web.DHCEQComponent).InsertTableItems("","THiddenItem",15)
ClassMethod InsertTableItems(Component, ItemName, InsertRows)
{
	n NewTableItem,CopyFromTableItem,FromID,NewItemName,ColCount,Parref
	n sc,errs,i
	s errs=""
	s (FromID,ColCount)=""
	&SQL(select ID into :FromID from websys.componenttableitems where parref->name like 'DHCEQ%' and name='THiddenItem')
	i (FromID="") q "失败!请先手工在一个组件中增加一个隐藏的TableItem元素THiddenItem"
	w "FromID="_FromID,!
	//s Parref=Component.%Id()
	;没有列表元素的组件不需要插入
	i '$d(^DHCComponent(ComponentName,"TABLEITEMS")) q ""
	
	s CopyFromTableItem=##class(websys.ComponentTableItems).%OpenId(FromID)
	w CopyFromTableItem.Name,!
	f i=1:1:InsertRows  d
	.s NewTableItem=##class(websys.ComponentTableItems).%New()
	.s NewItemName=ItemName_i
	.s NewTableItem=CopyFromTableItem.%ConstructClone()
	.s NewTableItem.ParRef=Component
	.s NewTableItem.Name=NewItemName
	.s sc=NewTableItem.%Save()
	.w sc_"&"_i,!
	.If $$$ISERR(sc)  d
	..d $System.Status.DisplayError(sc)
	.s errs= "Save Component TableItem("_Component.Name_"--"_NewItemName_") failed."_sc
	
	q errs
}
*/
/// w ##Class(web.DHCEQComponent).AdjustColSorts(0,"")
ClassMethod AdjustColSorts(SourceType, SourceID)
{
	n ComponentName,errs
	if SourceType q "请输入正确的SourceType"
	if SourceID="" s SourceID=0
	s ComponentName=""
	f  s ComponentName=$o(^DHCEQCComponent("DHCEQCComponentSetOld",0,"Component",SourceType,SourceID,ComponentName))  quit:(ComponentName="")  d
	.s errs= ##Class(web.DHCEQComponent).AdjustColSort(SourceType,SourceID,ComponentName)
	.w ComponentName_":"_errs,!
}

/// Add By JDL0140 20150824 根据组件设置中的列顺序信息，调整组件列表元素的顺序
/// 入参：		
/// 			SourceType:		0:系统 1:Hospital 2:安全组 3:用户
/// 			SourceID:		对应的SourceID
/// 				ComponentName 	组件名称
/// 	返回：		errs：空调整成功，否则失败
/// w ##Class(web.DHCEQComponent).AdjustColSort(0,"","DHCEQBatchDisuseRequestFind")
ClassMethod AdjustColSort(SourceType, SourceID, ComponentName)
{
	n CurId,ComponentSetID,RowID,ToVersion,Component,Sort,ItemName,Node,TempNode,ErrorMsg,Hidden
	n sc,errs,i
	s ToVersion=8
	s errs=""
	s CurId=""
	if SourceType=""
	{
		q "组件设置类型为空,请明确设置类型!(0:系统 1:Hospital 2:安全组 3:用户)"
	}
	if (SourceID="")&&(SourceType=0) s SourceID=0
	if (SourceID="")
	{
		q "请根据设置类型(0:系统 1:Hospital 2:安全组 3:用户),指定SourceID!"
	}
	&SQL(SELECT ID INTO :CurId FROM websys.Component WHERE Name=:ComponentName)
	if CurId=""
	{
		q "没有找到组件，不能调整列顺序!"
	}
	s ComponentSetID=""
	s RowID=""
	f  s RowID=$o(^DHCEQCComponent("DHCEQCComponentSetOld",0,"Component",SourceType,SourceID,ComponentName,RowID))  quit:((RowID="")||(ComponentSetID'=""))  d
	.q:$p(^DHCEQCComponent("DHCEQCComponentSetOld",RowID),"^",8)="Y"
	.s ComponentSetID=RowID
	if ComponentSetID=""
	{
		q "没有需要的组件配置信息，不能调整列顺序!"
	}
	
	Set $ZT="ERRORSave"
	;k ^DHCComponent(ComponentName)
	;d ##Class(web.DHCEQComponent).BakComponentNew(ToVersion,ComponentName)	
	if '$d(^DHCComponent(ComponentName))
	{
		q "请先备份组件信息，才能调整列顺序!"
	}
	
	TStart
	&SQL(Delete From websys.ComponentTableItems Where parref=:CurId )
	;&SQL(Delete From websys.ComponentItems Where parref=:CurId )
	s Component=##class(websys.Component).%OpenId(CurId)
	
	;根据配置调整列顺序
	s Sort=""
	f  s Sort=$o(^DHCEQCComponent("DHCEQCComponentSetItemOld",0,"IndexSort",ComponentSetID,1,Sort))  quit:((Sort="")||(errs'=""))  d
	.s ItemName=""
	.f  s ItemName=$o(^DHCEQCComponent("DHCEQCComponentSetItemOld",0,"IndexSort",ComponentSetID,1,Sort,ItemName))  quit:((ItemName="")||(errs'=""))  d
	..d GetNode
	..s RowID=$o(^DHCEQCComponent("DHCEQCComponentSetItemOld",0,"IndexSort",ComponentSetID,1,Sort,ItemName,""))
	..d AddTableItem	
	
	;未排序的,根据顺序 保存TableItems
	s Node=""
	f  s Node=$o(^DHCComponent(ComponentName,"TABLEITEMS",Node))  quit:((Node="")||(errs'=""))  d
	.s ItemName=$g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"Name"))
	.s RowID=$o(^DHCEQCComponent("DHCEQCComponentSetItemOld",0,"IndexItemName",ComponentSetID,1,ItemName,0))
	.q:(RowID'="")&&($p($g(^DHCEQCComponent("DHCEQCComponentSetItemOld",RowID)),"^",13)'="")
	.d AddTableItem
	if errs'=""
	{
		TRollBack
		q errs
	}
	TCommit
	q errs
AddTableItem
	s TableItem=##class(websys.ComponentTableItems).%New()
	s TableItem.ParRef=Component
	;if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"ID"))'="" s TableItem.ID=^DHCComponent(ComponentName,"TABLEITEMS",Node,"ID")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"AttachedFile"))'="" s TableItem.AttachedFile=^DHCComponent(ComponentName,"TABLEITEMS",Node,"AttachedFile")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"Caption"))'="" s TableItem.Caption=^DHCComponent(ComponentName,"TABLEITEMS",Node,"Caption")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"CaptionStyle"))'="" s TableItem.CaptionStyle=^DHCComponent(ComponentName,"TABLEITEMS",Node,"CaptionStyle")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"ClassMethod"))'="" s TableItem.ClassMethod=^DHCComponent(ComponentName,"TABLEITEMS",Node,"ClassMethod")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"ClassMethodIfDirty"))'="" s TableItem.ClassMethodIfDirty=^DHCComponent(ComponentName,"TABLEITEMS",Node,"ClassMethodIfDirty")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"CustomExpression"))'="" s TableItem.CustomExpression=^DHCComponent(ComponentName,"TABLEITEMS",Node,"CustomExpression")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"CustomLookupBrokerMethod"))'="" s TableItem.CustomLookupBrokerMethod=^DHCComponent(ComponentName,"TABLEITEMS",Node,"CustomLookupBrokerMethod")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"CustomLookupClassName"))'="" s TableItem.CustomLookupClassName=^DHCComponent(ComponentName,"TABLEITEMS",Node,"CustomLookupClassName")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"CustomLookupProperties"))'="" s TableItem.CustomLookupProperties=^DHCComponent(ComponentName,"TABLEITEMS",Node,"CustomLookupProperties")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"CustomLookupQueryName"))'="" s TableItem.CustomLookupQueryName=^DHCComponent(ComponentName,"TABLEITEMS",Node,"CustomLookupQueryName")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"DataType"))'="" s TableItem.DataType=^DHCComponent(ComponentName,"TABLEITEMS",Node,"DataType")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"DefaultValueAlways"))'="" s TableItem.DefaultValueAlways=^DHCComponent(ComponentName,"TABLEITEMS",Node,"DefaultValueAlways")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"DefaultValueExpression"))'="" s TableItem.DefaultValueExpression=^DHCComponent(ComponentName,"TABLEITEMS",Node,"DefaultValueExpression")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"Description"))'="" s TableItem.Description=^DHCComponent(ComponentName,"TABLEITEMS",Node,"Description")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"Disabled"))'="" s TableItem.Disabled=^DHCComponent(ComponentName,"TABLEITEMS",Node,"Disabled")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"DisplayOnly"))'="" s TableItem.DisplayOnly=^DHCComponent(ComponentName,"TABLEITEMS",Node,"DisplayOnly")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"DisplayType"))'="" s TableItem.DisplayType=^DHCComponent(ComponentName,"TABLEITEMS",Node,"DisplayType")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"HelpUrl"))'="" s TableItem.HelpUrl=^DHCComponent(ComponentName,"TABLEITEMS",Node,"HelpUrl")
	
	s Hidden=""		//Add By DJ 2017-03-21
	i RowID'=""
	s Hidden=$p($g(^DHCEQCComponent("DHCEQCComponentSetItemOld",RowID)),"^",8)
	s Hidden=$CASE(Hidden,"Y":"1","N":"0",:"")
	i Hidden="" s Hidden=$g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"Hidden"))
	i Hidden'="" s TableItem.Hidden=Hidden
	
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"IconProfile"))'="" s TableItem.IconProfile=^DHCComponent(ComponentName,"TABLEITEMS",Node,"IconProfile")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"Image"))'="" s TableItem.Image=^DHCComponent(ComponentName,"TABLEITEMS",Node,"Image")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"ItemIdGetExpression"))'="" s TableItem.ItemIdGetExpression=^DHCComponent(ComponentName,"TABLEITEMS",Node,"ItemIdGetExpression")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"LinkComponent"))'="" s TableItem.LinkComponent=^DHCComponent(ComponentName,"TABLEITEMS",Node,"LinkComponent")
	if ((ToVersion="7")||(ToVersion="8"))  d
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"LinkConditionalExp"))'="" s TableItem.LinkConditionalExp=^DHCComponent(ComponentName,"TABLEITEMS",Node,"LinkConditionalExp")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"LinkExpression"))'="" s TableItem.LinkExpression=^DHCComponent(ComponentName,"TABLEITEMS",Node,"LinkExpression")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"LinkUrl"))'="" s TableItem.LinkUrl=^DHCComponent(ComponentName,"TABLEITEMS",Node,"LinkUrl")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"LinkWorkFlow"))'="" s TableItem.LinkWorkFlow=^DHCComponent(ComponentName,"TABLEITEMS",Node,"LinkWorkFlow")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"ListCellStyle"))'="" s TableItem.ListCellStyle=^DHCComponent(ComponentName,"TABLEITEMS",Node,"ListCellStyle")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"LookupBrokerMethod"))'="" s TableItem.LookupBrokerMethod=^DHCComponent(ComponentName,"TABLEITEMS",Node,"LookupBrokerMethod")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"LookupClassName"))'="" s TableItem.LookupClassName=^DHCComponent(ComponentName,"TABLEITEMS",Node,"LookupClassName")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"LookupCustomComponent"))'="" s TableItem.LookupCustomComponent=^DHCComponent(ComponentName,"TABLEITEMS",Node,"LookupCustomComponent")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"LookupJavascriptFunction"))'="" s TableItem.LookupJavascriptFunction=^DHCComponent(ComponentName,"TABLEITEMS",Node,"LookupJavascriptFunction")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"LookupProperties"))'="" s TableItem.LookupProperties=^DHCComponent(ComponentName,"TABLEITEMS",Node,"LookupProperties")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"LookupQueryName"))'="" s TableItem.LookupQueryName=^DHCComponent(ComponentName,"TABLEITEMS",Node,"LookupQueryName")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"LookupUserDefined"))'="" s TableItem.LookupUserDefined=^DHCComponent(ComponentName,"TABLEITEMS",Node,"LookupUserDefined")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"LookupUserDefinedValues"))'="" s TableItem.LookupUserDefinedValues=^DHCComponent(ComponentName,"TABLEITEMS",Node,"LookupUserDefinedValues")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"Name"))'="" s TableItem.Name=^DHCComponent(ComponentName,"TABLEITEMS",Node,"Name")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"NestedComponent"))'="" s TableItem.NestedComponent=^DHCComponent(ComponentName,"TABLEITEMS",Node,"NestedComponent")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"NestedCondExpr"))'="" s TableItem.NestedCondExpr=^DHCComponent(ComponentName,"TABLEITEMS",Node,"NestedCondExpr")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"NestedTransExpr"))'="" s TableItem.NestedTransExpr=^DHCComponent(ComponentName,"TABLEITEMS",Node,"NestedTransExpr")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"OrderByAsc"))'="" s TableItem.OrderByAsc=^DHCComponent(ComponentName,"TABLEITEMS",Node,"OrderByAsc")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"OrderByDesc"))'="" s TableItem.OrderByDesc=^DHCComponent(ComponentName,"TABLEITEMS",Node,"OrderByDesc")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"Password"))'="" s TableItem.Password=^DHCComponent(ComponentName,"TABLEITEMS",Node,"Password")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"PasswordKeepVal"))'="" s TableItem.PasswordKeepVal=^DHCComponent(ComponentName,"TABLEITEMS",Node,"PasswordKeepVal")
	if ((ToVersion="7")||(ToVersion="8"))  d
	.if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"ReadOnly"))'="" s TableItem.ReadOnly=^DHCComponent(ComponentName,"TABLEITEMS",Node,"ReadOnly")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"ReferencedObject"))'="" s TableItem.ReferencedObject=^DHCComponent(ComponentName,"TABLEITEMS",Node,"ReferencedObject")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"Required"))'="" s TableItem.Required=^DHCComponent(ComponentName,"TABLEITEMS",Node,"Required")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"SQLColumn"))'="" s TableItem.SQLColumn=^DHCComponent(ComponentName,"TABLEITEMS",Node,"SQLColumn")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"SQLComment"))'="" s TableItem.SQLComment=^DHCComponent(ComponentName,"TABLEITEMS",Node,"SQLComment")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"SQLExtendedReference"))'="" s TableItem.SQLExtendedReference=^DHCComponent(ComponentName,"TABLEITEMS",Node,"SQLExtendedReference")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"SQLTable"))'="" s TableItem.SQLTable=^DHCComponent(ComponentName,"TABLEITEMS",Node,"SQLTable")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"SQLToVBCodeTable"))'="" s TableItem.SQLToVBCodeTable=^DHCComponent(ComponentName,"TABLEITEMS",Node,"SQLToVBCodeTable")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"ShortcutKey"))'="" s TableItem.ShortcutKey=^DHCComponent(ComponentName,"TABLEITEMS",Node,"ShortcutKey")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"ShowInNewWindow"))'="" s TableItem.ShowInNewWindow=^DHCComponent(ComponentName,"TABLEITEMS",Node,"ShowInNewWindow")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"Style"))'="" s TableItem.Style=^DHCComponent(ComponentName,"TABLEITEMS",Node,"Style")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"TabSequence"))'="" s TableItem.TabSequence=^DHCComponent(ComponentName,"TABLEITEMS",Node,"TabSequence")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"Tooltip"))'="" s TableItem.Tooltip=^DHCComponent(ComponentName,"TABLEITEMS",Node,"Tooltip")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"ValueDefault"))'="" s TableItem.ValueDefault=^DHCComponent(ComponentName,"TABLEITEMS",Node,"ValueDefault")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"ValueGet"))'="" s TableItem.ValueGet=^DHCComponent(ComponentName,"TABLEITEMS",Node,"ValueGet")
	if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"ValueSet"))'="" s TableItem.ValueSet=^DHCComponent(ComponentName,"TABLEITEMS",Node,"ValueSet")
	;if $g(^DHCComponent(ComponentName,"TABLEITEMS",Node,"childsub"))'="" s TableItem.childsub=^DHCComponent(ComponentName,"TABLEITEMS",Node,"childsub")
	Set sc=TableItem.%Save()	
	If $$$ISERR(sc)  d
	.d $System.Status.DisplayError(sc)
	.s errs= "Save Component TableItem("_ComponentName_"--"_ItemName_") failed."_sc
	q
GetNode
	s (Node,TempNode)=""
	f  s TempNode=$o(^DHCComponent(ComponentName,"TABLEITEMS",TempNode))  quit:((TempNode="")||(Node'=""))  d
	.i ItemName=$g(^DHCComponent(ComponentName,"TABLEITEMS",TempNode,"Name")) s Node=TempNode
	q
GetSetInfo
	
	q
ERRORSave 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "<ERRORSave>"_ErrorMsg_",errs:"_errs     //返回错误消息 ;
}

/// Add By DJ 2015-07-31
/// 描  述:设置安全组菜单权限
/// 参  数:vGroupID   安全组ID
/// 	   vMenuID    菜单ID
/// 	   vFlag	  菜单权限配置或取消标志  1:配置  0:取消
/// 		   vParentFlag 1:操作父菜单  0:不操作父菜单
/// 返回值:vReturn    "SetSuccess":标识成功
/// w ##Class(web.DHCEQComponent).SetGroupMenu(215,52667,1,1)
ClassMethod SetGroupMenu(vGroupID, vMenuID, vFlag, vParentFlag)
{
	n (vGroupID,vMenuID,vFlag,vParentFlag)
	
	i vGroupID="" q "安全组ID不能为空"
	i vMenuID="" q "菜单ID不能为空"
	i vFlag="" q "菜单权限配置或取消标志不能为空"
	s MaxMenuId=$o(^websys.MenuD(""),-1)
	s eprrowid=$o(^ooGroupSettingsI("GroupDRIndex",vGroupID,0))		//epr.GroupSettings表RowID
	i eprrowid=""
	{
		&SQL(Insert Into epr.GroupSettings(GroupDR) Values(:vGroupID))
		s eprrowid=$G(%ROWID)
	}
	s objEprGroupSetting=##class(epr.GroupSettings).%OpenId(eprrowid)
	s security=objEprGroupSetting.MenuSecurity
	i security="" s security=$zbitstr(MaxMenuId,0)
	i $zbitlen(security)<vMenuID s security=$zbitor(security,$zbitstr(MaxMenuId,0))
	s security=$zbitset(security,vMenuID,vFlag)
	s objEprGroupSetting.MenuSecurity=security
	s sc=objEprGroupSetting.%Save()
	d objEprGroupSetting.%Close()
	s objEprGroupSetting=""
	s ParentMenu=""
	s Caption=""
	i vFlag="0" s vParentFlag="0"
	&SQL(SELECT SubMenuOf, Caption into :ParentMenu, :Caption FROM websys.Menu WHERE ID=:vMenuID)
	i vParentFlag="1"  d
	.i ParentMenu'=""  d
	..s Return=..SetGroupMenu(vGroupID,ParentMenu,vFlag,vParentFlag)
	..w Return,!
	
	q Caption_":SetSuccess"
}

/// Add By DJ 2015-09-09
/// 描述:新建安全组配置菜单
/// 参数:vGroupDesc  需要配菜单的安全组全称
/// 		vPrefix	  需要配置菜单的前缀如:"DHCEQ"
///     vConfigOrCancel  1:表示配置  0:表示取消
/// w ##Class(web.DHCEQComponent).DistributionMenu("固定资产系统管理员","DHCEQ",1)
ClassMethod DistributionMenu(vGroupDesc, vPrefix, vConfigOrCancel)
{
	//检测安全组DR是否存在
	&SQL(SELECT SSGRP_Rowid into :vGroupDR FROM SQLUser.SS_Group WHERE SSGRP_Desc =:vGroupDesc)
	i ((vGroupDR="")||'$D(^SSU("SSGRP",vGroupDR)))	q "请正确输入安全组全称!"
	i vPrefix="" q "请正确输入vPrefix参数!"
	i (vConfigOrCancel'=0)&&(vConfigOrCancel'=1) q "请正确输入vConfigOrCancel参数!"
	//开始遍历菜单配置或取消权限
	s ParentFlag=0
	i vConfigOrCancel=1 s ParentFlag=1
	s MenuID=0
	f  s MenuID=$o(^websys.MenuD(MenuID))  q:MenuID=""  d
	.s MenuName=$lg(^websys.MenuD(MenuID),4)
	.q:((vPrefix'="")&&(($ZCONVERT($E(MenuName,1,$L(vPrefix)),"U")'=$ZCONVERT(vPrefix,"U"))))
	.d ..SetGroupMenu(vGroupDR,MenuID,vConfigOrCancel,ParentFlag)
	
	q "Finish"
}

/*
/// add by zy 2015-11-26
/// 根据table的名称来取对应table可以显示的数据列信息,动态生成一个columns对象
/// sourcetype:  0:系统 1:Hospital 2:安全组 3:用户
/// sourceid  :  当前打开的tableID
/// ComponentName：当前要取的组件的名称
/// w ##Class(web.DHCEQComponent).GetComponentItemInfo("0","0","21")
ClassMethod GetComponentItemInfo(SourceType, SourceID, ComponentName)
{
	new ComponentSetID
	new Sort,ItemInfo,ItemName,ItemID,DataList,HiddenFlag
	i '$Data(^DHCEQCComponent("DHCEQCComponentSet",0,"Component",SourceType,SourceID,ComponentName)) q ""
	s ComponentSetID=$o(^DHCEQCComponent("DHCEQCComponentSet",0,"Component",SourceType,SourceID,ComponentName,0))
	i ComponentSetID="" q ""
	
	s (Sort,ItemInfo)=""
	f  s Sort=$o(^DHCEQCComponent("DHCEQCComponentSetItem",0,"IndexSort",ComponentSetID,1,Sort))  quit:Sort=""  d
	.s ItemName=""
	.f  s ItemName=$o(^DHCEQCComponent("DHCEQCComponentSetItem",0,"IndexSort",ComponentSetID,1,Sort,ItemName))  quit:ItemName=""  d
	..s ItemID=$o(^DHCEQCComponent("DHCEQCComponentSetItem",0,"IndexSort",ComponentSetID,1,Sort,ItemName,""))
	..s DataList=$g(^DHCEQCComponent("DHCEQCComponentSetItem",ItemID))
	..;q:$p(DataList,"^",8)="Y"
	..s HiddenFlag=$CASE($p(DataList,"^",8),"Y":"true","N":"false",:"")
	..i ItemInfo=""  d
	...s ItemInfo=ItemName_","_$p(DataList,"^",4)_","_$p(DataList,"^",9)_","_HiddenFlag_","
	..e  d
	...s ItemInfo=ItemInfo_"^"_ItemName_","_$p(DataList,"^",4)_","_$p(DataList,"^",9)_","_HiddenFlag_","
	s Detail="detail,详细,100,center,,detailOperation"
	s ItemInfo=ItemInfo
	
	quit ItemInfo
}
*/
/// d ##class(%ResultSet).RunQuery("web.DHCEQComponent","GetGroupMenu","固定资产(管理员)","85")
/// Call web.DHCEQComponent_GetGroupMenu("固定资产(管理员)","85")
Query GetGroupMenu(vGroupName As %String = "", vGroupID As %String = "") As %Query(ROWSPEC = "TGroupName:%String,TMenuName:%String,TMenuCaption:%String,TMenuFlag:%String,TParIDs:%String,TMenuID:%String,TMenuSequence:%String,TClass:%String") [ SqlProc ]
{
}

ClassMethod GetGroupMenuExecute(ByRef qHandle As %Binary, vGroupName As %String = "", vGroupID As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	i ((vGroupName="")&&(vGroupID="")) Quit $$$OK
	i vGroupID=""
	{
		&SQL(Select SSGRP_RowID Into :vGroupID From SQLUSER.SS_Group Where SSGRP_Desc=:vGroupName)
		i vGroupID="" q "["_vGroupName_"]安全组不存在!"
	}
	else
	{
		&SQL(Select SSGRP_Desc Into :vGroupName From SQLUSER.SS_Group Where SSGRP_RowID=:vGroupID)
	}
	s eprrowid=$o(^ooGroupSettingsI("GroupDRIndex",vGroupID,0))
	s objEprGroupSetting=##class(epr.GroupSettings).%OpenId(eprrowid)
	s security=objEprGroupSetting.MenuSecurity
	s MaxMenuID=$zbitlen(security)
	s TGroupName=vGroupName
	s CurMenuID=0
	f CurMenuID=1:1:MaxMenuID  d
	.s TMenuFlag=$zbitget(security,CurMenuID)
	.q:TMenuFlag=0
	.s TMenuName=$lg($g(^websys.MenuD(CurMenuID)),4)
	.s TMenuCaption=$lg($g(^websys.MenuD(CurMenuID)),1)
	.q:((TMenuName="")&&(TMenuCaption=""))
	.s TMenuID=CurMenuID
	.s TMenuSequence=$lg($g(^websys.MenuD(CurMenuID)),5)
	.s TParIDs=##Class(web.DHCEQComponent).GetParIDsByMenuID(CurMenuID)
	.i $L(TParIDs,"|")>2  d
	..s TMenuCaption=##class(web.DHCEQCCounter).LPAD(""," ",($L(TParIDs,"|")-2)*2)_TMenuCaption
	.s TClass=$L(TParIDs,"|")-1
	.s ^DHCEQDJ("GroupMenu",CurMenuID)=TGroupName_"^"_TMenuName_"^"_TMenuCaption_"^"_TMenuFlag
	.d OutputRowGetGroupMenu
	
	Quit $$$OK
OutputRowGetGroupMenu
	Set Data=$lb(TGroupName,TMenuName,TMenuCaption,TMenuFlag,TParIDs,TMenuID,TMenuSequence,TClass)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
}

ClassMethod GetGroupMenuFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGroupMenuExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetGroupMenuClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGroupMenuExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Add By DJ 2015-07-31
/// 描  述:设置安全组菜单权限
/// 参  数:vGroupName   安全组名称
/// 	   vMenuName  菜单名
/// 	   vFlag	  菜单权限配置或取消标志  1:配置  0:取消
/// 返回值:vReturn    "SetSuccess":标识成功
ClassMethod SetGroupMenuByName(vGroupName As %String = "", vMenuName As %String = "", vFlag As %String = "") As %String [ SqlProc ]
{
	n (vGroupName,vMenuName,vFlag)
	i vGroupName="" q "安全组名不能为空"
	i vMenuName="" q "菜单不能为空"
	i vFlag="" q "菜单权限配置或取消标志不能为空"
	s vGroupID=""
	&SQL(Select SSGRP_RowID Into :vGroupID From SQLUSER.SS_Group Where SSGRP_Desc=:vGroupName)
	i vGroupID="" q "["_vGroupName_"]安全组不存在!"
	s vMenuID=""
	&SQL(Select ID Into :vMenuID From websys.Menu Where Name=:vMenuName)
	i vMenuID="" q "["_vMenuName_"]菜单不存在!"
	s Return=..SetGroupMenu(vGroupID,vMenuID,vFlag,"0")
	q Return
}

/*
/// add by zy 2015-11-15
/// 描述：根据角色ID和提醒菜单种类取待办业务数据
/// 参数：BussType：业务类型代码
/// 	  RoleIDs：角色ids
/// d ##class(%ResultSet).RunQuery("web.DHCEQComponent","GetComponentSet","","","")
Query GetComponentSet(SourceType As %String = "", SourceID As %String = "", BussCode As %String = "", ComponentDesc As %String = "") As %Query(ROWSPEC = "TComponentID:%String,TSourceType:%String,TSourceTypeDesc:%String,TSourceID:%String,TSource:%String,TComponentName:%String,TLayout:%String,TComponentDesc:%String")
{
}

ClassMethod GetComponentSetExecute(ByRef qHandle As %Binary, SourceType As %String = "", SourceID As %String = "", BussCode As %String = "", ComponentDesc As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	
	f  s rowid=$o(^DHCEQCComponent("DHCEQCComponentSet",rowid)) q:rowid=""  d
 	.s TComponentID=rowid
	.quit:$p($g(^DHCEQCComponent("DHCEQCComponentSet",rowid)),"^",8)="Y"
	.s TSourceType=$p($g(^DHCEQCComponent("DHCEQCComponentSet",rowid)),"^",1)
	.q:TSourceType=""
 	.q:(SourceType'="")&(SourceType'=TSourceType)
 	.i TSourceType'="" s TSourceTypeDesc=$CASE(TSourceType,0:"系统",1:"院区",2:"安全组",3:"用户",:"")
	.s TSourceID=$p($g(^DHCEQCComponent("DHCEQCComponentSet",rowid)),"^",2)
	.q:TSourceID=""
 	.q:(SourceID'="")&(SourceID'=TSourceID)
	.i (TSourceID'="")&($p($g(^DHCEQCComponent("DHCEQCComponentSet",rowid)),"^",1)=0) d  //系统
	..s TSource=0
	.i (TSourceID'="")&($p($g(^DHCEQCComponent("DHCEQCComponentSet",rowid)),"^",1)=1) d  //院区
	..s TSource=$p($g(^CT("HOSP",TSourceID)),"^",2)
	.i (TSourceID'="")&($p($g(^DHCEQCComponent("DHCEQCComponentSet",rowid)),"^",1)=2) d  //安全组
	..s TSource = ##class(web.DHCEQCommon).GetTrakNameByID("grp",TSourceID)
	.i (TSourceID'="")&($p($g(^DHCEQCComponent("DHCEQCComponentSet",rowid)),"^",1)=3) d  //用户
	..s TSource = ##class(web.DHCEQCommon).GetTrakNameByID("user",TSourceID)
	.s TComponentName=$p($g(^DHCEQCComponent("DHCEQCComponentSet",rowid)),"^",3)
	.q:(BussCode'="")&&(TComponentName'[BussCode)
	.s TComponentDesc=##Class(web.DHCEQCBussType).GetBussTypeByCode(1,TComponentName)
	.q:(ComponentDesc'="")&&(TComponentDesc'[ComponentDesc)
	.s TLayout=$p($g(^DHCEQCComponent("DHCEQCComponentSet",rowid)),"^",4)
	.d OutputRowGetComponentSet
	
	
	
	
	
	//i (SourceType="")||(SourceID="") Quit $$$OK
	
//	s Source=""
//	i '$Data(^DHCEQCComponent("DHCEQCComponentSet",0,"Component",SourceType,SourceID)) Quit $$$OK
//	s SourceTypedesc = ##class(web.DHCEQComponent).GetSourceType(SourceType)
//	s ComponentName=""
//	f  s ComponentName=$o(^DHCEQCComponent("DHCEQCComponentSet",0,"Component",SourceType,SourceID,ComponentName)) quit:ComponentName=""  d
//	.q:(BussCode'="")&&(BussCode'[ComponentName)
//	.s ComponentDesc=##Class(web.DHCEQCBussType).GetBussTypeByCode(1,ComponentName)
//	.s ComponentID=0
//	.f  s ComponentID=$o(^DHCEQCComponent("DHCEQCComponentSet",0,"Component",SourceType,SourceID,ComponentName,ComponentID)) quit:ComponentID=""  d
//	..quit:$p($g(^DHCEQCComponent("DHCEQCComponentSet",ComponentID)),"^",8)="Y"
//	..s Layout=$p($g(^DHCEQCComponent("DHCEQCComponentSet",ComponentID)),"^",4)
//	..d OutputRowGetComponentSet
	
	Quit $$$OK
OutputRowGetComponentSet
	set Data=$lb(TComponentID,TSourceType,TSourceTypeDesc,TSourceID,TSource,TComponentName,TLayout,TComponentDesc)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetComponentSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetComponentSetExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetComponentSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetComponentSetExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by zy 2015-11-15
/// 描述：根据角色ID和提醒菜单种类取待办业务数据
/// 参数：BussType：业务类型代码
/// 	  RoleIDs：角色ids
/// d ##class(%ResultSet).RunQuery("web.DHCEQComponent","GetComponentSetItem","1","1")
Query GetComponentSetItem(ComponentID As %String = "", ItemName As %String = "", Caption As %String = "", ItemType As %String = "1") As %Query(ROWSPEC = "TItemID:%String,TItemName:%String,TCaption:%String,THiddenFlag:%String,TItemStyle:%String,TSort:%String")
{
}

ClassMethod GetComponentSetItemExecute(ByRef qHandle As %Binary, ComponentID As %String = "", ItemName As %String = "", Caption As %String = "", ItemType As %String = "1") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	i ComponentID="" Quit $$$OK
	s (TSort,TItemInfo)=""
	f  s TSort=$o(^DHCEQCComponent("DHCEQCComponentSetItem",0,"IndexSort",ComponentID,ItemType,TSort))  quit:TSort=""  d
	.s TItemName=""
	.f  s TItemName=$o(^DHCEQCComponent("DHCEQCComponentSetItem",0,"IndexSort",ComponentID,ItemType,TSort,TItemName))  quit:TItemName=""  d
	..s TItemID=$o(^DHCEQCComponent("DHCEQCComponentSetItem",0,"IndexSort",ComponentID,ItemType,TSort,TItemName,""))
	..s DataList=$g(^DHCEQCComponent("DHCEQCComponentSetItem",TItemID))
	..s TItemName=$p(DataList,"^",3)
	..q:(ItemName'="")&&(TItemName'[ItemName)
	..s TCaption=$p(DataList,"^",4)
	..q:(Caption'="")&&(TCaption'[Caption)
	..s THiddenFlag=$p(DataList,"^",8)
	..s TItemStyle=$p(DataList,"^",9)
	..d OutputRowGetComponentSetItem
	Quit $$$OK
OutputRowGetComponentSetItem
	set Data=$lb(TItemID,TItemName,TCaption,THiddenFlag,TItemStyle,TSort)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetComponentSetItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetComponentSetItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetComponentSetItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetComponentSetItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by zy 2015-11-15
/// 描述：根据角色ID和提醒菜单种类取待办业务数据
/// 参数：BussType：业务类型代码
/// 	  RoleIDs：角色ids
/// d ##class(%ResultSet).RunQuery("web.DHCEQComponent","GetSourceIDByQX","0")
Query GetSourceIDByQX(SourceType As %String = "") As %Query(ROWSPEC = "sourceID:%String,source:%String")
{
}

ClassMethod GetSourceIDByQXExecute(ByRef qHandle As %Binary, SourceType As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	i SourceType=0  d
	.s SourceID=0,Source=""
	.d OutputRowGetSourceIDByQX
	Quit $$$OK
OutputRowGetSourceIDByQX
	set Data=$lb(SourceID,Source)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetSourceIDByQXFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSourceIDByQXExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetSourceIDByQXClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSourceIDByQXExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQComponent).SaveComponent("",3,2,"11","100,center")
ClassMethod SaveComponent(ComponentID, SourceType, SourceID, ComponentName, Layout)
{
	new SQLCODE
	i ComponentID'=""
	{
		&SQL(update SQLUSER.DHC_EQCComponentSet(CS_SourceType,CS_SourceID,CS_ComponentName,CS_Layout) values (:SourceType,:SourceID,:ComponentName,:Layout) where CS_RowID=:ComponentID)
	}
	else
	{
		&SQL(select CS_RowID Into:ComponentID from SQLUSER.DHC_EQCComponentSet  Where CS_SourceType=:SourceType and CS_SourceID=:SourceID and CS_ComponentName=:ComponentName)
		i ComponentID=""
		{
			&SQL(insert into SQLUSER.DHC_EQCComponentSet(CS_SourceType,CS_SourceID,CS_ComponentName,CS_Layout) values (:SourceType,:SourceID,:ComponentName,:Layout))
		}
		else
		{
			&SQL(update SQLUSER.DHC_EQCComponentSet(CS_SourceType,CS_SourceID,CS_ComponentName,CS_Layout) values (:SourceType,:SourceID,:ComponentName,:Layout) where CS_RowID=:ComponentID)
		}
	}
	q SQLCODE
}

/// w ##Class(web.DHCEQComponent).SaveComponentItem("",15,"Test","测试","100,center",1,Y)
ClassMethod SaveComponentItem(ItemID, ComponentID, ItemName, Caption, ItemStyle, Sort, HiddenFlag, ItemType As %String = "1")
{
	new SQLCODE
	i ItemID'=""
	{
		&SQL(update SQLUSER.DHC_EQCComponentSetItem(CSI_ComponentSetDR,CSI_ItemType,CSI_ItemName,CSI_Caption,CSI_ItemStyle,CSI_Sort,CSI_Hidden) values (:ComponentID,:ItemType,:ItemName,:Caption,:ItemStyle,:Sort,:HiddenFlag) where CSI_RowID=:ItemID)
	}
	else
	{
		&SQL(select CSI_RowID Into:ItemID from SQLUSER.DHC_EQCComponentSetItem  Where CSI_ComponentSetDR=:ComponentID and CSI_ItemName=:ItemName)
		i ItemID=""
		{
			&SQL(insert into SQLUSER.DHC_EQCComponentSetItem(CSI_ComponentSetDR,CSI_ItemType,CSI_ItemName,CSI_Caption,CSI_ItemStyle,CSI_Sort,CSI_Hidden) values (:ComponentID,:ItemType,:ItemName,:Caption,:ItemStyle,:Sort,:HiddenFlag))
		}
		else
		{
			&SQL(update SQLUSER.DHC_EQCComponentSetItem(CSI_ComponentSetDR,CSI_ItemType,CSI_ItemName,CSI_Caption,CSI_ItemStyle,CSI_Sort,CSI_Hidden) values (:ComponentID,:ItemType,:ItemName,:Caption,:ItemStyle,:Sort,:HiddenFlag) where CSI_RowID=:ItemID)
		}
	}
	q SQLCODE
}

ClassMethod DeleteComponent(ComponentID)
{
	new SQLCODE
	&SQL(Delete SQLUSER.DHC_EQCComponentSetItem where CSI_ComponentSetDR=:ComponentID)
	i SQLCODE=100 s SQLCODE=0
	i SQLCODE'=0 q SQLCODE
	&SQL(Delete SQLUSER.DHC_EQCComponentSet where CS_RowID=:ComponentID)
	q SQLCODE
}

ClassMethod DeleteComponentItem(ItemID)
{
	new SQLCODE
	&SQL(Delete SQLUSER.DHC_EQCComponentSetItem where CSI_RowID=:ItemID)
	q SQLCODE
}
*/
/// 组件设置类型
/// w ##class(web.DHCEQComponent).GetSourceType(0)
ClassMethod GetSourceType(TSourceType)
{
	Quit $CASE(TSourceType,"0":"系统","1":"院区","2":"安全组","3":"用户","":"")
}

/// 把数据库内组件及菜单备份至Global
/// d ##class(web.DHCEQComponent).DoBak()
ClassMethod DoBak()
{
	w "---- BakComponents ----",!
	d ##class(web.DHCEQComponent).BakComponentsNew("8","DHCEQ","/DHCEQComponent.txt")
	w "---- BakMenus ----",!
	d ##class(web.DHCEQComponent).BakMenus("8","DHCEQ","/DHCEQMenu.txt")
	w "Over"
}

/// 把Gloabl内的组件和菜单信息更新至数据库
/// d ##class(web.DHCEQComponent).DoUpdate()
ClassMethod DoUpdate()
{
	w "将Gloabl内的组件和菜单信息更新至当前数据库",!
	b "继续请输入g,取消请输入q,输入后回车!"
	w "---- UpdateComponents ----",!
	d ##class(web.DHCEQComponent).UpdateComponentsNew("8","d:\DHCEQComponent.txt")
	w "---- UpdateMenus ----",!
	d ##class(web.DHCEQComponent).UpdateMenus("8","d:\DHCEQMenu.txt")
	w !,!,"Over!"
}

/// w ##Class(web.DHCEQComponent).SetMenu("固定资产(管理员)")
ClassMethod SetMenu(vGName)
{
	s Error=""
	s CurRow=0
	f  s CurRow=$o(^DHCEQDJ("GroupMenu",CurRow))  q:(CurRow="")||(Error'="")  D
	.s GroupName=vGName
	.s MenuName=$p($g(^DHCEQDJ("GroupMenu",CurRow)),"^",2)
	.s MenuFlag=$p($g(^DHCEQDJ("GroupMenu",CurRow)),"^",4)
	.s Return=##Class(web.DHCEQComponent).SetGroupMenuByName(GroupName,MenuName,MenuFlag)
	.i $p(Return,":",2)'="SetSuccess" s Error=Return
	
	i Error'="" q Error
	q "Success"
}

/***************************************************************************/
/// Add By DJ 2017-02-09
/// 描述:根据导出组件的global与本地组件比较,输出导出组件的属性或元素的差异结果
/// 入参:FromVersion表示版本号("5":P5   "7":P7  "8":P8)
/// 		ComponentNamePrefix表示组件前缀
/// 		filename表示差异结果输出文件路径
/// d ##class(web.DHCEQComponent).CheckComponentsChange("8","DHCEQ","d:\DHCEQComponent.txt")
ClassMethod CheckComponentsChange(FromVersion As %String, ComponentNamePrefix As %String, filename)
{
	new rset,sql,ComponentName,ComponentNames,ComponentID
	
	/**********************************导出Global元素名称转换***********************************/
	w "(1):开始转换导出Global元素名称......"	
	s ComponentName=""
 	f  s ComponentName=$o(^DHCComponent(ComponentName))  q:ComponentName=""  d
 	.s ID=0
 	.f  s ID=$o(^DHCComponent(ComponentName,"TABLEITEMS",ID))  q:ID=""  d
 	..s Name=$g(^DHCComponent(ComponentName,"TABLEITEMS",ID,"Name"))
 	..s Prop=""
 	..f  s Prop=$o(^DHCComponent(ComponentName,"TABLEITEMS",ID,Prop))  q:Prop=""  d
 	...s ^DHCComponent(ComponentName,"TABLEITEMS1",Name,Prop)=$g(^DHCComponent(ComponentName,"TABLEITEMS",ID,Prop))
 	..k ^DHCComponent(ComponentName,"TABLEITEMS",ID)
 	.s ID=0
 	.f  s ID=$o(^DHCComponent(ComponentName,"ITEMS",ID))  q:ID=""  d
 	..s Name=$g(^DHCComponent(ComponentName,"ITEMS",ID,"Name"))
 	..s Prop=""
 	..f  s Prop=$o(^DHCComponent(ComponentName,"ITEMS",ID,Prop))  q:Prop=""  d
 	...s ^DHCComponent(ComponentName,"ITEMS1",Name,Prop)=$g(^DHCComponent(ComponentName,"ITEMS",ID,Prop))
 	..k ^DHCComponent(ComponentName,"ITEMS",ID)
 	
 	w !,"(2):导出Global元素名称转换结束!比对处理开始......"
 	
 	/****************************组件对比处理*************************************/
 	k ^DHCComponentDif
	Set rset = ##class(%ResultSet).%New()
	set sql="SELECT Name FROM websys.Component WHERE Name like '"_ComponentNamePrefix_"%'"
 	Do rset.Prepare(sql)
 	Do rset.Execute()
 	set ComponentNames=""
 	
 	Set file=##class(%File).%New(filename)
	Do file.Open("WSN")
	
 	While (rset.Next(.sc)) // go to the next row of the result set
 	{
 		If ($SYSTEM.Status.IsOK(sc)) // check if this succeeded without errors
 		{
 			set ComponentName=rset.Data("Name") // perform busines logic
 			set ComponentID=..CheckComponentChange(FromVersion,ComponentName)
 			i $P(ComponentID,":",1)="Error" w ComponentID,!
 			
 			set ComponentNames=ComponentNames_ComponentName_"_"_ComponentID_","
 		}
 		Else // if there was an error, break out of the While loop
 		{
	        w "err"
	        Do file.Close()
 			Quit
 		}
 	}
	;w sc,!
 	If $SYSTEM.Status.IsError(sc) // if there was an error, process that
 	{
 		;Kill ^DHCComponent(ComponentName)
 	}
 	w !,"(3):比对处理结束!开始输出对比结果......"
 	
 	/*********************************比对完成,输出检测结果********************************/
 	Do file.WriteLine("组件名|元素|属性|导出值|本地值|差异类型") 	
 	s ComponentName=""
 	f  s ComponentName=$o(^DHCComponentDif(ComponentName))  q:ComponentName=""  d
 	.s ID=""
 	.f  s ID=$o(^DHCComponentDif(ComponentName,"TABLEITEMS1",ID))  q:ID=""  d
 	..s Prop=""
 	..f  s Prop=$o(^DHCComponentDif(ComponentName,"TABLEITEMS1",ID,Prop))  q:Prop=""  d
 	...s Str=ComponentName_"|"_ID_"|"_Prop_"|"_$g(^DHCComponentDif(ComponentName,"TABLEITEMS1",ID,Prop))_"|修改"
 	...Do file.WriteLine(Str)
 	.s ID=""
 	.f  s ID=$o(^DHCComponentDif(ComponentName,"ITEMS1",ID))  q:ID=""  d
 	..s Prop=""
 	..f  s Prop=$o(^DHCComponentDif(ComponentName,"ITEMS1",ID,Prop))  q:Prop=""  d
 	...s Str=ComponentName_"|"_ID_"|"_Prop_"|"_$g(^DHCComponentDif(ComponentName,"ITEMS1",ID,Prop))_"|修改"
 	...Do file.WriteLine(Str)
 	.s ID=""
 	.f  s ID=$o(^DHCComponentDif(ComponentName,"COMP",ID))  q:ID=""  d
 	..s Str=ComponentName_"||"_ID_"|"_$g(^DHCComponentDif(ComponentName,"COMP",ID))_"|修改"
 	..Do file.WriteLine(Str)
 	//输出导出新增组件或元素
 	s ComponentName=""
 	f  s ComponentName=$o(^DHCComponent(ComponentName))  q:ComponentName=""  d
 	.s ComponentId=""
 	.&SQL(SELECT ID INTO :ComponentId FROM websys.Component WHERE Name=:ComponentName)
 	.i ComponentId=""  d
 	..s Str=ComponentName_"|||||新增组件"
 	..Do file.WriteLine(Str)
 	.e  d
 	..s ID=""
 	..f  s ID=$o(^DHCComponent(ComponentName,"TABLEITEMS",ID))  q:ID=""  d
 	...s Prop=""
 	...f  s Prop=$o(^DHCComponent(ComponentName,"TABLEITEMS",ID,Prop))  q:Prop=""  d
 	....s Str=ComponentName_"|"_ID_"|"_Prop_"|"_$g(^DHCComponent(ComponentName,"TABLEITEMS",ID,Prop))_"||新增列表元素"
 	....Do file.WriteLine(Str)
 	..s ID=""
 	..f  s ID=$o(^DHCComponent(ComponentName,"ITEMS",ID))  q:ID=""  d
 	...s Prop=""
 	...f  s Prop=$o(^DHCComponent(ComponentName,"ITEMS",ID,Prop))  q:Prop=""  d
 	....s Str=ComponentName_"|"_ID_"|"_Prop_"|"_$g(^DHCComponent(ComponentName,"ITEMS",ID,Prop))_"||新增元素"
 	....Do file.WriteLine(Str)
 	
 	w !,"(4):比对结果输出完成!",!
 	
 	/**********************************/   
	Do file.Close()
	Quit ComponentNames
}

ClassMethod CheckComponentChange(FromVersion, ComponentName)
{
	
	new err
	s err=""
	
	&SQL(SELECT ID INTO :ComponentId FROM websys.Component WHERE Name=:ComponentName)
	If SQLCODE Quit "Error:"_ComponentName_":[does not find the component]"
	;Kill ^DHCComponent(ComponentName)
	s component=##class(websys.Component).%OpenId(ComponentId)
	if '$IsObject(component) q "Error:"_ComponentName_":[is not an object reference]"
	
	//组件信息
	i $g(^DHCComponent(ComponentName,"COMP","ClassName"))'=component.ClassName  d
	.s ^DHCComponentDif(ComponentName,"COMP","ClassName")=$g(^DHCComponent(ComponentName,"COMP","ClassName"))_"|"_component.ClassName
	
	i $g(^DHCComponent(ComponentName,"COMP","Menus"))'=component.Menus  d
	.s ^DHCComponentDif(ComponentName,"COMP","Menus")=^DHCComponent(ComponentName,"COMP","Menus")_"|"_component.Menus
	
	i $g(^DHCComponent(ComponentName,"COMP","OtherScripts"))'=component.OtherScripts  d
	.s ^DHCComponentDif(ComponentName,"COMP","OtherScripts")=^DHCComponent(ComponentName,"COMP","OtherScripts")_"|"_component.OtherScripts
	
	i $g(^DHCComponent(ComponentName,"COMP","QueryName"))'=component.QueryName  d
	.s ^DHCComponentDif(ComponentName,"COMP","QueryName")=^DHCComponent(ComponentName,"COMP","QueryName")_"|"_component.QueryName
	
	k ^DHCComponent(ComponentName,"COMP")
	
	k ^DHCComponent(ComponentName,"LAYOUT")
	
	;保存Items信息
	s result = ##class(%Library.ResultSet).%New()
	s sql="select * from websys.componentitems where parref="_ComponentId 
	d result.Prepare(sql)
	d result.Execute()
	s node=1
	While (result.Next(.sc)&&(err="")) // go to the next row of the result set
 	{
 		If ($SYSTEM.Status.IsOK(sc)) // check if this succeeded without errors
 		{
	 		Set count = result.GetColumnCount()
	 		s node=result.GetDataByName("Name")
	 		s FindStr=",Name,Caption,DisplayType,DataType,Image,ValueGet,ValueSet,ClassMethod,CustomExpression,"
	 		s FindStr=FindStr_"LinkUrl,LinkComponent,LinkExpression,"
	 		s FindStr=FindStr_"LookupClassName,LookupQueryName,LookupProperties,LookupJavascriptFunction,"
	 		
 			For i = 1:1:count 
 			{
	 			i FindStr[(","_result.GetColumnName(i)_",")  d
	 			.i $D(^DHCComponent(ComponentName,"ITEMS1",node))  d
	 			..i $g(^DHCComponent(ComponentName,"ITEMS1",node,result.GetColumnName(i)))'=result.GetData(i)  d
	 			...s ^DHCComponentDif(ComponentName,"ITEMS1",node,result.GetColumnName(i))=$g(^DHCComponent(ComponentName,"ITEMS1",node,result.GetColumnName(i)))_"|"_result.GetData(i)
			}
			k ^DHCComponent(ComponentName,"ITEMS1",node)
 		}
 		Else // if there was an error, break out of the While loop
 		{
	 		s err="Error:"_ComponentName_":[read items info error]"
 			Quit
 		}
 	}
 	
 	;保存TableItems信息
	s result = ##class(%Library.ResultSet).%New()
	s sql="select * from websys.componenttableitems where parref="_ComponentId 
	d result.Prepare(sql)
	d result.Execute()
	s node=1
	While (result.Next(.sc)&&(err="")) // go to the next row of the result set
 	{
 		If ($SYSTEM.Status.IsOK(sc)) // check if this succeeded without errors
 		{
	 		Set count = result.GetColumnCount()
	 		s node=result.GetDataByName("Name")
	 		s FindStr=",Name,Caption,DisplayType,DataType,Image,ValueGet,ValueSet,ClassMethod,CustomExpression,"
	 		s FindStr=FindStr_"LinkUrl,LinkComponent,LinkExpression,"
	 		s FindStr=FindStr_"LookupClassName,LookupQueryName,LookupProperties,LookupJavascriptFunction,"
	 		
 			For i = 1:1:count 
 			{
	 			i FindStr[(","_result.GetColumnName(i)_",")  d
	 			.i $D(^DHCComponent(ComponentName,"TABLEITEMS1",node))  d
	 			..i $g(^DHCComponent(ComponentName,"TABLEITEMS1",node,result.GetColumnName(i)))'=result.GetData(i)  d
	 			...s ^DHCComponentDif(ComponentName,"TABLEITEMS1",node,result.GetColumnName(i))=$g(^DHCComponent(ComponentName,"TABLEITEMS1",node,result.GetColumnName(i)))_"|"_result.GetData(i)
			}
			k ^DHCComponent(ComponentName,"TABLEITEMS1",node)
 		}
 		Else // if there was an error, break out of the While loop
 		{
	 		s err="Error:"_ComponentName_":[read tableitems info error]"
 			Quit
 		}
 	}
 	
	d result.Close()
	
	q ComponentId
}

/// add by zy 2015-11-15
/// 描述：根据角色ID和提醒菜单种类取待办业务数据
/// 参数：BussType：业务类型代码
/// 	  RoleIDs：角色ids
/// d ##class(%ResultSet).RunQuery("web.DHCEQComponent","GetComponentSet","","","")
Query GetComponentSet(SourceType As %String = "", SourceID As %String = "", BussCode As %String = "", ComponentDesc As %String = "") As %Query(ROWSPEC = "TComponentID:%String,TSourceType:%String,TSourceTypeDesc:%String,TSourceID:%String,TSource:%String,TComponentName:%String,TLayout:%String,TComponentDesc:%String")
{
}

ClassMethod GetComponentSetExecute(ByRef qHandle As %Binary, SourceType As %String = "", SourceID As %String = "", BussCode As %String = "", ComponentDesc As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	
	f  s rowid=$o(^DHCEQCComponent("DHCEQCComponentSet",rowid)) q:rowid=""  d
 	.s TComponentID=rowid
	.quit:$p($g(^DHCEQCComponent("DHCEQCComponentSet",rowid)),"^",8)="Y"
	.s TSourceType=$p($g(^DHCEQCComponent("DHCEQCComponentSet",rowid)),"^",1)
	.q:TSourceType=""
 	.q:(SourceType'="")&(SourceType'=TSourceType)
 	.i TSourceType'="" s TSourceTypeDesc=$CASE(TSourceType,0:"系统",1:"院区",2:"安全组",3:"用户",:"")
	.s TSourceID=$p($g(^DHCEQCComponent("DHCEQCComponentSet",rowid)),"^",2)
	.q:TSourceID=""
 	.q:(SourceID'="")&(SourceID'=TSourceID)
	.i (TSourceID'="")&($p($g(^DHCEQCComponent("DHCEQCComponentSet",rowid)),"^",1)=0) d  //系统
	..s TSource=0
	.i (TSourceID'="")&($p($g(^DHCEQCComponent("DHCEQCComponentSet",rowid)),"^",1)=1) d  //院区
	..s TSource=$p($g(^CT("HOSP",TSourceID)),"^",2)
	.i (TSourceID'="")&($p($g(^DHCEQCComponent("DHCEQCComponentSet",rowid)),"^",1)=2) d  //安全组
	..s TSource = ##class(web.DHCEQCommon).GetTrakNameByID("grp",TSourceID)
	.i (TSourceID'="")&($p($g(^DHCEQCComponent("DHCEQCComponentSet",rowid)),"^",1)=3) d  //用户
	..s TSource = ##class(web.DHCEQCommon).GetTrakNameByID("user",TSourceID)
	.s TComponentName=$p($g(^DHCEQCComponent("DHCEQCComponentSet",rowid)),"^",3)
	.q:(BussCode'="")&&(TComponentName'[BussCode)
	.s TComponentDesc=##Class(web.DHCEQCBussType).GetBussTypeByCode(1,TComponentName)
	.q:(ComponentDesc'="")&&(TComponentDesc'[ComponentDesc)
	.s TLayout=$p($g(^DHCEQCComponent("DHCEQCComponentSet",rowid)),"^",4)
	.d OutputRowGetComponentSet
	
	Quit $$$OK
OutputRowGetComponentSet
	set Data=$lb(TComponentID,TSourceType,TSourceTypeDesc,TSourceID,TSource,TComponentName,TLayout,TComponentDesc)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetComponentSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetComponentSetExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetComponentSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetComponentSetExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by zy 2015-11-15
/// 描述：根据角色ID和提醒菜单种类取待办业务数据
/// 参数：BussType：业务类型代码
/// 	  RoleIDs：角色ids
/// d ##class(%ResultSet).RunQuery("web.DHCEQComponent","GetComponentSetItem","1","1")
Query GetComponentSetItem(ComponentID As %String = "", ItemName As %String = "", Caption As %String = "", ItemType As %String = "1") As %Query(ROWSPEC = "TItemID:%String,TItemName:%String,TCaption:%String,THiddenFlag:%String,TItemStyle:%String,TSort:%String")
{
}

ClassMethod GetComponentSetItemExecute(ByRef qHandle As %Binary, ComponentID As %String = "", ItemName As %String = "", Caption As %String = "", ItemType As %String = "1") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	i ComponentID="" Quit $$$OK
	s (TSort,TItemInfo)=""
	f  s TSort=$o(^DHCEQCComponent("DHCEQCComponentSetItem",0,"IndexSort",ComponentID,ItemType,TSort))  quit:TSort=""  d
	.s TItemName=""
	.f  s TItemName=$o(^DHCEQCComponent("DHCEQCComponentSetItem",0,"IndexSort",ComponentID,ItemType,TSort,TItemName))  quit:TItemName=""  d
	..s TItemID=$o(^DHCEQCComponent("DHCEQCComponentSetItem",0,"IndexSort",ComponentID,ItemType,TSort,TItemName,""))
	..s DataList=$g(^DHCEQCComponent("DHCEQCComponentSetItem",TItemID))
	..s TItemName=$p(DataList,"^",3)
	..q:(ItemName'="")&&(TItemName'[ItemName)
	..s TCaption=$p(DataList,"^",4)
	..q:(Caption'="")&&(TCaption'[Caption)
	..s THiddenFlag=$p(DataList,"^",8)
	..s TItemStyle=$p(DataList,"^",9)
	..d OutputRowGetComponentSetItem
	Quit $$$OK
OutputRowGetComponentSetItem
	set Data=$lb(TItemID,TItemName,TCaption,THiddenFlag,TItemStyle,TSort)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetComponentSetItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetComponentSetItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetComponentSetItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetComponentSetItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// /////////////////////////////////////////////////
/// w ##Class(web.DHCEQComponent).GetParIDsByMenuID(56521)
ClassMethod GetParIDsByMenuID(vCurMenuID As %String = "")
{
	i vCurMenuID="" q ""
	s ParentIDs=vCurMenuID
	do
	{
		s ParID=$lg($g(^websys.MenuD(vCurMenuID)),12)
		i ParID'=""  d
		.i ParentIDs'="" s ParentIDs=ParID_"|"_ParentIDs
		.i ParentIDs="" s ParentIDs=ParID
		s vCurMenuID=ParID
	}while(ParID'="")
	
	q "M"_ParentIDs
}

}
