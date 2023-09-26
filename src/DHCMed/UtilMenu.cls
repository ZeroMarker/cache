/// 名称: DHCMed.UtilMenu
/// 描述: 导入导出iMedical的菜单
/// 编写者：wuqk
/// 编写日期: 2012-09-26
/// 
/// 导出菜单方法：将以MenuNameAlias开头的菜单导出到指定文件夹，菜单列表存在menus.txt中
/// w ##class(DHCMed.UtilMenu).DownLoadMenus("MenuNameAlias","d:\tmp\")
/// 
/// 导入菜单方法：导入指定路径下menus.txt文件中的菜单
/// w ##class(DHCMed.UtilMenu).UpLoadMenus("d:\tmp\",0)        //不覆盖已有的同名菜单
/// w ##class(DHCMed.UtilMenu).UpLoadMenus("d:\tmp\",1)        //覆盖已有同名菜单
/// 
Class DHCMed.UtilMenu Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

Property Caption As %String(TRUNCATE = 1);

Property Chart As epr.Chart;

Property ChartBook As epr.ChartBook;

Property ConditionalExpression As %Library.String(MAXLEN = "", TRUNCATE = 1);

Property Image As %String(MAXLEN = "", TRUNCATE = 1);

/// filename of where the JavascriptFunction resides. 
/// Should only be set for custom site menus, expects file to sit in relation to custom/SITECODE/scripts folder
Property JavascriptFileName As %String(TRUNCATE = 1);

Property JavascriptFunction As %Library.String(TRUNCATE = 1);

/// Used in conjunction with LinkUrl of websysDefault.asp.
/// If this property is set then LinkLinkUrl is assumes to be websysDefault.ASP
Property LinkComponent As websys.Component;

Property LinkReport As websys.Report;

Property LinkUrl As %String(MAXLEN = "", TRUNCATE = 1);

Property Method As %String(MAXLEN = "", TRUNCATE = 1);

Property Name As %String(MAXLEN = 99, TRUNCATE = 1);

Property PrintPreview As %Library.Boolean;

Property PrintLocal As %Library.Boolean;

Property Sequence As %String(TRUNCATE = 1);

Property ShortcutKey As %String(TRUNCATE = 1);

Property ShowInNewWindow As %Library.String(MAXLEN = "", TRUNCATE = 1);

Property SubMenuOf As websys.Menu;

/// name of browser window frame to send the link
Property Target As %Library.String(TRUNCATE = 1);

/// a value of either: SideMenu, ComponentMenu, HeaderMenu
/// this will be automatically calculated on update
Property Type As %Library.String(TRUNCATE = 1);

Property UpdateDate As %Library.Date;

Property UpdateTime As %Library.Time;

Property UpdateUser As User.SSUser;

Property ValueExpression As %String(MAXLEN = "", TRUNCATE = 1);

/// Name of workflow
Property WorkFlow As websys.WorkFlow;

Property Worklist As epr.Worklist;

Property ChartName As %String;

/// As epr.Chart;
Property ChartBookName As %String;

/// As epr.ChartBook;
Property LinkComponentName As %String;

/// As websys.Component;
Property LinkReportName As %String;

/// As websys.Report;
Property SubMenuOfName As %String;

/// As websys.Menu;
Property UpdateUserName As %String;

/// As User.SSUser;
Property WorkFlowName As %String;

/// As websys.WorkFlow;
Property WorklistName As %String;

/// As epr.Worklist;
/// Creator：     wuqk
/// CreatDate：   2012-09-26
/// Description:  将iMedical系统菜单导出为xml文件
/// Table：       websys.Menu
/// Input：       
/// 			nameprefix : 菜单名称的开头字母
///         path       ：导出文件的路径
/// Return：      
/// w ##class(DHCMed.UtilMenu).DownLoadMenus("DHCMed","d:\tmp\")
ClassMethod DownLoadMenus(nameprefix As %String, path As %String)
{
	set rset = ##class(%ResultSet).%New()
	set sql="select * from websys.menu where Name like '"_nameprefix_"%'"
 	do rset.Prepare(sql)
 	do rset.Execute()
 	set indexfilename=path_"menus.txt"
 	set MenuNames=""
 	kill TempLoadMenu
 	set count=0,success=0
	
	While (rset.Next(.sc)) // go to the next row of the result set
 	{
 		If ($SYSTEM.Status.IsOK(sc)) // check if this succeeded without errors
 		{
 		    set MenuId=rset.Data("ID") // perform busines logic
 		    set MenuName=rset.Data("Name")
 		    w !!,"Menu Name: "_MenuName
 		    set ret=..ExportMenuToXML(MenuId,path)
 		    w !,"    Ret: "_ret
 		    w !,"    Export finished!!!"
 		    set:+ret>0 success=success+1
 		    set TempLoadMenu(count)=MenuName
 		}
 		Else // if there was an error, break out of the While loop
 		{
	        w "   err"
	        do file.Close()
 		    Quit
 		}
	 	set count=count+1
 	}
 	
 	set file=##class(%File).%New(indexfilename)
	do file.Open("WSN")
	set index=""
	for {
		set index=$o(TempLoadMenu(index))
		quit:index=""
		set MenuName=$g(TempLoadMenu(index))
		do file.WriteLine(MenuName)
	}	
 	do file.Close()
 	w !!,"count="_count
	w !,"success="_success,!!
 	
	Quit "OK"
}

ClassMethod ExportMenuToXML(MenuId, Path As %String)
{
	new (MenuId, Path)
	set ret=1
	//set $ZT="ERRORExportMenuToXML"
	
	set obj=##class(websys.Menu).%OpenId(MenuId)
	set objUtilMenu=##class(DHCMed.UtilMenu).%New()
	set cdef=##class(%Library.CompiledClass).%OpenId(obj.%ClassName(1))
	set intPropertyCnt=cdef.Properties.Count()
	for i=1:1:intPropertyCnt  {
		set objProperty=cdef.Properties.GetAt(i)
		set strPropertyName=objProperty.Name
		continue:strPropertyName["%"
		set orderGet="set val=obj."_strPropertyName                
		x orderGet                                                   //读取菜单属性的值
		set orderSet="set objUtilMenu."_strPropertyName_"=val"
		x orderSet                                                   //赋值
	}
	set:$IsObject(obj.Chart) objUtilMenu.Chart=obj.Chart.Name
	set:$IsObject(obj.ChartBook) objUtilMenu.ChartBookName=obj.ChartBook.Description
	set:$IsObject(obj.LinkComponent) objUtilMenu.LinkComponentName=obj.LinkComponent.Name
	set:$IsObject(obj.LinkReport) objUtilMenu.LinkReportName=obj.LinkReport.Code
	set:$IsObject(obj.SubMenuOf) objUtilMenu.SubMenuOfName=obj.SubMenuOf.Name
	set:$IsObject(obj.UpdateUser) objUtilMenu.UpdateUserName=obj.UpdateUser.SSUSRInitials
	set:$IsObject(obj.WorkFlow) objUtilMenu.WorkFlowName=obj.WorkFlow.Name
	set:$IsObject(obj.Worklist) objUtilMenu.WorklistName=obj.Worklist.Name
	do obj.%Close()
	set obj=""
	
	
	w !,"    objUtilMenu.ChartName="_objUtilMenu.ChartName          
	w !,"    objUtilMenu.ChartBookName="_objUtilMenu.ChartBookName   
	w !,"    objUtilMenu.LinkComponentName="_objUtilMenu.LinkComponentName
	w !,"    objUtilMenu.LinkReportName="_objUtilMenu.LinkReportName    
	w !,"    objUtilMenu.SubMenuOfName="_objUtilMenu.SubMenuOfName     
	w !,"    objUtilMenu.UpdateUserName="_objUtilMenu.UpdateUserName    
	w !,"    objUtilMenu.WorkFlowName="_objUtilMenu.WorkFlowName      
	w !,"    objUtilMenu.WorklistName="_objUtilMenu.WorklistName     
		
	set objUtilMenu.Chart=""
	set objUtilMenu.ChartBook=""
	set objUtilMenu.LinkComponent=""
	set objUtilMenu.LinkReport=""
	set objUtilMenu.SubMenuOf=""
	set objUtilMenu.UpdateUser=""
	set objUtilMenu.WorkFlow=""
	set objUtilMenu.Worklist=""
	
	set filename=Path_objUtilMenu.Name_".xml"
	
	/* file save*/
	set file=##class(%File).%New(filename)
	Do file.Open("WSN")
	set xmlStream=""
	do objUtilMenu.XMLExportToStream(.xmlStream)
	//d $system.OBJ.Dump(objUtilMenu)
	//b	
	set line=xmlStream.ReadLine()                  //max 32k
	Do file.WriteLine(line)
	do file.Close()
	
	/* stream save 
	set xmlStream=""
	do objUtilMenu.XMLExportToStream(.xmlStream)
	do xmlStream.FilenameSet(filename)
	set sc=xmlStream.SaveStream()
	*/
	w !,"    Export to file: "_filename
	w !,"    Size: "_xmlStream.SizeGet()
	
	do xmlStream.%Close()
	set xmlStream=""
	set objUtilMenu=""
	quit ret
ERRORExportMenuToXML
	w !,$ZError
	w !,"    MenuId="_$g(MenuId)_",MenuName="_objUtilMenu.Name
	quit -1
}

/// Creator：     wuqk
/// CreatDate：   2012-09-26
/// Description:  从xml文件夹中导入iMedical系统菜单
/// Table：       websys.Menu
/// Input：       
///         path       ：导入文件的路径
///         overload   ：是否覆盖同名菜单，1：覆盖，0：不覆盖
/// Return：      
/// w ##class(DHCMed.UtilMenu).UpLoadMenus("d:\tmp\",0)
ClassMethod UpLoadMenus(path As %String, overload As %Integer)
{
	set overload=+$g(overload)
	set filename=path_"menus.txt"
	quit:'##class(%File).Exists(filename)
	set (line,parid,errs)=""
	set stream=##class(%FileCharacterStream).%New()
	set stream.Filename=filename
	set count=0,success=0
	While 'stream.AtEnd {
		set menuname=stream.ReadLine()
		w !!,"Menu Name: "_menuname
		set ret=..LoadMenusFromXML(path,menuname,overload)
		w !,"     Ret="_ret,!!!
		set:+ret>0 success=success+1
		set count=count+1
	}
	
	w !!,"count="_count
	w !,"success="_success,!!
   Quit "OK"
}

ClassMethod LoadMenusFromXML(path As %String, menuname As %String, overload As %Integer)
{
	new (path,menuname,overload)
	set ret=-100
	set menuFileName=path_menuname_".xml"
	quit:'##class(%File).Exists(menuFileName) ret
	
	set ret=1
	
	set $ZT="ERRORLoadMenusFromXML"
	
	w !,"     begin..."
	w !,"     FileName: "_menuFileName
	Set reader = ##class(%XML.Reader).%New()
	set stream=##class(%FileCharacterStream).%New()
	w !,"     Size:"_stream.SizeGet()
	set stream.Filename=menuFileName
	set sc=reader.OpenStream(stream)	
	
	Do reader.Correlate("UtilMenu","DHCMed.UtilMenu")
	
	While reader.Next(.objUtilMenu,.sc) 
	{
		
		//set:'IsObject(objUtilMenu) ret=-101
		quit:ret<0
		
		set menuid=""
		&SQL(SELECT id into :menuid FROM websys.Menu WHERE Name=:menuname)
		if (menuid=""){
			set obj=##class(websys.Menu).%New()
		}
		else {
			w !,"     MenuId: "_menuid
			set:overload'=1 ret="Do not overload ....................."                           
			quit:overload'=1                                   //不覆盖原菜单
			w !,"     Overload: "_overload
			set obj=##class(websys.Menu).%OpenId(menuid)
		}
		
		set cdef=##class(%Library.CompiledClass).%OpenId(obj.%ClassName(1))
		set intPropertyCnt=cdef.Properties.Count()
		for i=1:1:intPropertyCnt  {
			set objProperty=cdef.Properties.GetAt(i)
			set strPropertyName=objProperty.Name
			continue:strPropertyName["%"
			set orderGet="set val=objUtilMenu."_strPropertyName                
			x orderGet                                                   //读取菜单属性的值
			set orderSet="set obj."_strPropertyName_"=val"
			x orderSet                                                   //赋值
		}
	
		if objUtilMenu.ChartName'="" {
			set ChartId="",ChartName=objUtilMenu.ChartName
			&SQL(select id into :ChartId from epr.chart where Name =:ChartName)
			if (ChartId'=""){
				set obj.Chart=##class(epr.Chart).%OpenId(ChartId)
			}
		}
		if objUtilMenu.ChartBookName'="" {
			set ChartBookId="",ChartBook=objUtilMenu.ChartBookName
			&SQL(select id into :ChartBookId from epr.chartbook where Description =:LinkChartBook)
			if (ChartBookId'=""){
				set obj.ChartBook=##class(epr.ChartBook).%OpenId(ChartBookId)
			}
		}
		if objUtilMenu.LinkComponentName'="" {
			set CompNameId="",ComponentName	=objUtilMenu.LinkComponentName	
			&SQL(select id into :CompNameId from websys.component where name = :ComponentName)
			//b //1
			if (CompNameId'=""){
				set obj.LinkComponent=##class(websys.Component).%OpenId(CompNameId)
			}
		}
		
		//if objUtilMenu.LinkReportName'=""
		
		if objUtilMenu.SubMenuOfName'="" {
			set SubMenuId="",SubMenuOfName=objUtilMenu.SubMenuOfName
			&SQL(SELECT id into :SubMenuId FROM websys.Menu WHERE Name=:SubMenuOfName)
			if (SubMenuId'=""){
				set obj.SubMenuOf=##class(websys.Menu).%OpenId(SubMenuId)
			}
		}
		
		//if objUtilMenu.UpdateUserName'=""    
		if objUtilMenu.WorkFlowName'="" {
			set WorkFlowId="",WorkFlowName=objUtilMenu.WorkFlowName
			&SQL(select id into :WorkFlowId from websys.WorkFlow where name = :WorkFlowName)
			if (WorkFlowId'=""){
				set obj.WorkFlow=##class(websys.WorkFlow).%OpenId(WorkFlowId)
			}
		} 
		if objUtilMenu.WorklistName'="" {
			set WorkListId="",WorklistName=objUtilMenu.WorklistName
			&SQL(select id into :WorkListId from epr.Worklist where name = :WorklistName)
			if (WorkListId'=""){
				set obj.Worklist=##class(epr.Worklist).%OpenId(WorkListId)
			}
		}
		
		d $System.OBJ.Dump(obj)
		
		/**/
		set sc=obj.%Save()
		if $system.Status.IsError(sc) {              //保存失败
			set ret=-102
			d $system.OBJ.DisplayError(sc) 
		}
		
	}
	quit ret
ERRORLoadMenusFromXML
	w !,$ZError
	w !,"    MenuName="_$g(menuname)_",  menuFileName="_$g(menuFileName)
	quit -200
}

Storage Default
{
<Data name="UtilMenuDefaultData">
<Subscript>"UtilMenu"</Subscript>
<Value name="1">
<Value>NName</Value>
</Value>
</Data>
<DefaultData>UtilMenuDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
