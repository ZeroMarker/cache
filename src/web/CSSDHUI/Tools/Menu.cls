/// 导出菜单方法：将以MenuNameAlias开头的菜单导出到指定文件夹，菜单列表存在menus.txt中
/// w ##class(web.CSSDHUI.Tools.Menu).DownLoadMenus("CSSDHUI","c:\menus\")
/// 导出菜单方法：将指定安全组的菜单导出到指定文件夹，菜单列表存在menus.txt中
/// w ##class(web.CSSDHUI.Tools.Menu).DownLoadMenusByGroup(1,"d:\tmp\")
/// 
/// 导入菜单方法：导入指定路径下menus.txt文件中的菜单
/// w ##class(web.CSSDHUI.Tools.Menu).UpLoadMenus("D:\svn\cssdhisui\menu\",0)        //不覆盖已有的同名菜单
/// w ##class(web.CSSDHUI.Tools.Menu).UpLoadMenus("D:\svn\CSSDHUI开发版本\menu\",1)        //覆盖已有同名菜单
/// 
Class web.CSSDHUI.Tools.Menu Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// 这些属性, 和websys.Menu平行,具体含义以websys.Menu注释为准
Property Caption As %String(TRUNCATE = 1);

Property Chart As epr.Chart;

Property ChartBook As epr.ChartBook;

Property ConditionalExpression As %Library.String(MAXLEN = "", TRUNCATE = 1);

Property Image As %String(MAXLEN = "", TRUNCATE = 1);

Property JavascriptFileName As %String(TRUNCATE = 1);

Property JavascriptFunction As %Library.String(TRUNCATE = 1);

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

Property Target As %Library.String(TRUNCATE = 1);

Property Type As %Library.String(TRUNCATE = 1);

Property UpdateDate As %Library.Date;

Property UpdateTime As %Library.Time;

Property UpdateUser As User.SSUser;

Property ValueExpression As %String(MAXLEN = "", TRUNCATE = 1);

Property WorkFlow As websys.WorkFlow;

Property Worklist As epr.Worklist;

Property ChartName As %String;

Property ChartBookName As %String;

Property LinkComponentName As %String;

Property LinkReportName As %String;

Property SubMenuOfName As %String;

Property UpdateUserName As %String;

Property WorkFlowName As %String;

Property WorklistName As %String;

Property HelpCode As %String;

Property HelpStyle As %String;

Property MenuGroup As websys.MenuGroup;

Property IsXhrRefresh As %String;

/// CreatDate：   2018-08-14
/// Description:  将iMedical系统菜单导出为xml文件
/// Table：       websys.Menu
/// Input：       nameprefix : 菜单名称的开头字母
///               path       ：导出文件的路径
///               ParentMenuName: 头菜单名称(以此递归)
///               MenuLevel  : 菜单级别,默认为0
/// Return：      
/// d ##class(web.CSSDHUI.Tools.Menu).DownLoadMenus("CSSDHUI.","d:\menus\","System.MainMenu")
ClassMethod DownLoadMenus(nameprefix As %String, path As %String, ParentMenuName = "System.MainMenu", MenuLevel = "0")
{
	n (nameprefix,path,ParentMenuName,MenuLevel)
	s path=##class(%File).NormalizeDirectory(path)
	set indexfilename=path_"menus.txt"
	set file=##class(%File).%New(indexfilename)
	do file.Open("WSN")
	
	k ^TempLoadMenu("CSSDHUI")
	set count=0,success=0
	
	;1.递归导出头菜单
	d ..DownLoadMenusRecord(nameprefix,path,"",MenuLevel)
	;2.递归导出侧菜单,并记录global
	d ..DownLoadMenusRecord(nameprefix,path,ParentMenuName,MenuLevel)
	;3.导出menus.txt
	s Index=0
	f  s Index=$o(^TempLoadMenu("CSSDHUI",Index)) q:Index=""  d
	.s ExportMenuName=^TempLoadMenu("CSSDHUI",Index)
	.d file.WriteLine(ExportMenuName)
	.s count=count+1
	do file.Close()
	k ^TempLoadMenu("CSSDHUI")
	
	w !!,"count="_count
}

/// 递归导出菜单,并记录菜单global(Tab处理,方便层级展示)
/// ps:[ ProcedureBlock = 1 ]请勿去除
ClassMethod DownLoadMenusRecord(nameprefix As %String, path As %String, ParentMenuName = "System.MainMenu", MenuLevel = "0") [ Private, ProcedureBlock = 1 ]
{
	s path=##class(%File).NormalizeDirectory(path)
	set count=0,success=0
	
	set rset = ##class(%ResultSet).%New()
	set sql="select * from websys.menu"
		_" where Name like '"_nameprefix_"%'"
		_" and nvl(SubMenuOf->Name,'')=nvl('"_ParentMenuName_"','')"
		_" order by Sequence,Caption"
	do rset.RuntimeModeSet(0)
	do rset.Prepare(sql)
	do rset.Execute()
	While (rset.Next(.sc)) {
		If ($SYSTEM.Status.IsOK(sc)){
			set MenuId=rset.Data("ID")
			set MenuName=rset.Data("Name")
			set Caption=rset.Data("Caption")
			w !!,"Menu Name: "_MenuName
			set ret=..ExportMenuToXML(MenuId,path)
			w !,"    Ret: "_ret
			w !,"    Export finished!!!"
			s ExportSpace=""
			f i=1:1:MenuLevel d
			.s ExportSpace=ExportSpace_$c(9)
			;这里的组织方式和UpLoadMenus方法要对应
			s MenuName=$$FixLength(MenuName)
			s ExportMenuName=MenuName_$c(9)_ExportSpace_Caption
			s ^TempLoadMenu("CSSDHUI",$i(^TempLoadMenu("CSSDHUI",0)))=ExportMenuName
			
			&sql(SELECT %id FROM websys.menu WHERE SubMenuOf->Name=:MenuName)
			i SQLCODE=0 d ..DownLoadMenusRecord(nameprefix,path,MenuName,MenuLevel+1)
		}Else {
			w "   err"
			Quit
		}
		set count=count+1
	}
FixLength(MenuName)
	s Len=50
	s FixLen=Len-$l(MenuName)
	f i=1:1:FixLen d
	.s MenuName=MenuName_$c(32)		;拼接空格
	q MenuName
}

ClassMethod ExportMenuToXML(MenuId, Path As %String) [ Private ]
{
	new (MenuId, Path)
	set ret=1
	set $ZT="ERRORExportMenuToXML"
	
	set obj=##class(websys.Menu).%OpenId(MenuId)
	set objUtilMenu=##class(web.CSSDHUI.Tools.Menu).%New()
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
	set objUtilMenu.UpdateDate=""			;日期,时间置空,方便菜单对比
	set objUtilMenu.UpdateTime=""
	set objUtilMenu.HelpStyle=""
	set objUtilMenu.IsXhrRefresh=""
	
	set filename=Path_objUtilMenu.Name_".xml"
	
	/* file save*/
	set file=##class(%File).%New(filename)
	Do file.Open("WSN")
	set xmlStream=""
	do objUtilMenu.XMLExportToStream(.xmlStream)
	set line=xmlStream.ReadLine()                  //max 32k
	Do file.WriteLine(line)
	do file.Close()
	
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

/// CreatDate：   2018-08
/// Description:  从xml文件夹中导入iMedical系统菜单
/// Table：       websys.Menu
/// Input：       
/// 		path		: 导入文件的路径(注意路径后面的斜杠)
/// 		overload	: 是否覆盖同名菜单，1：覆盖，0：不覆盖
/// 		hospstr		: 医院id串（^隔开）
/// Return：      
/// w ##class(web.CSSDHUI.Tools.Menu).UpLoadMenus("D:\MediwaySVN\CSSD\trunk\CSSDHUI\CSSDHUICode\menu\",1,"")
ClassMethod UpLoadMenus(path As %String, overload As %Integer, hospstr As %String = "")
{
	i hospstr="" d
	.s hospid=""
	.f  s hospid=$o(^CT("HOSP",hospid)) q:hospid=""  d
	..i hospstr="" s hospstr=hospid
	..e  s hospstr=hospstr_"^"_hospid
	set overload=+$g(overload)
	set filename=path_"menus.txt"
	quit:'##class(%File).Exists(filename)
	set (line,parid,errs)=""
	set stream=##class(%FileCharacterStream).%New()
	set stream.Filename=filename
	set count=0,success=0
	While 'stream.AtEnd {
		set menuname=stream.ReadLine()
		s menuname=$tr(menuname,$c(13,10,32))
		;这里的处理要和DownLoadMenus相对应
		s menuname=$p(menuname,$c(9),1)
		w !!,"Menu Name: "_menuname
		set ret=..LoadMenusFromXML(path,menuname,overload,hospstr)
		w !,"     Ret="_ret,!!!
		set:+ret>0 success=success+1
		set count=count+1
	}
	
	w !!,"count="_count
	w !,"success="_success,!!
	Quit "OK"
}

/// w ##class(web.CSSDHUI.Tools.Menu).LoadMenusFromXML("d:\temp\","DHC.CARDCPP.POS",1)
ClassMethod LoadMenusFromXML(path As %String, menuname As %String, overload As %Integer, hospstr As %String = "") [ Private ]
{
	new (path,menuname,overload,hospstr)
	set ret=-100
	set menuFileName=path_menuname_".xml"
	quit:'##class(%File).Exists(menuFileName) ret
	
	set ret=1
	
	set $ZT="ERRORLoadMenusFromXML"
	
	w !,"     begin..."
	w !,"     FileName: "_menuFileName
	Set reader = ##class(%XML.Reader).%New()
	set stream=##class(%FileCharacterStream).%New()
	set stream.Filename=menuFileName
	set sc=reader.OpenStream(stream)
	w !,"     Size:"_stream.SizeGet()
	Do reader.Correlate("Menu","web.CSSDHUI.Tools.Menu")
	s objUtilMenu=##class(web.CSSDHUI.Tools.Menu).%New()
	
	While reader.Next(.objUtilMenu,.sc) 
	{
		//set:'IsObject(objUtilMenu) ret=-101
		quit:ret<0

		set menuid=""
		&SQL(SELECT id into :menuid FROM websys.Menu WHERE Name=:menuname)
		if (menuid=""){
			set obj=##class(websys.Menu).%New()
		}else {
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
			
			s val=""
			try{
				set orderGet="set val=objUtilMenu."_strPropertyName
				//读取菜单属性的值
				x orderGet
			}catch{}
			continue:val=""
			
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
			if (CompNameId'=""){
				set obj.LinkComponent=##class(websys.Component).%OpenId(CompNameId)
			}
		}
		if objUtilMenu.SubMenuOfName'="" {
			set SubMenuId="",SubMenuOfName=objUtilMenu.SubMenuOfName
			&SQL(SELECT id into :SubMenuId FROM websys.Menu WHERE Name=:SubMenuOfName)
			if (SubMenuId'=""){
				set obj.SubMenuOf=##class(websys.Menu).%OpenId(SubMenuId)
			}
		}
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
		if objUtilMenu.UpdateDate="" {
			s obj.UpdateDate=+$h
			s obj.UpdateTime=$p($h,",",2)
		}
		
		;添加type的修改
		s objType=objUtilMenu.Type
		d $System.OBJ.Dump(obj)
		
		set sc=obj.%Save()
		s menuid=obj.%Id()
		if $system.Status.IsError(sc) {              //保存失败
			set ret=-102
			d $system.OBJ.DisplayError(sc)
		}
		q:ret<0
		
		;添加type的修改  不使用类方法保存，有触发器
		&sql(update websys.Menu set Type=:objType where ID=:menuid)
		s matret=0
		i hospstr'="" d
		.s del="^"
		.s len=$l(hospstr,del)
		.f i=1:1:len d
		..s hospid=$p(hospstr,del,i)
		..s matret=##class(web.CSSDHUI.HospMap).SaveHOSP("websys.Menu",menuid,hospid)
		..q:matret<0
		i matret<0 s ret=-103
	}
	quit ret
ERRORLoadMenusFromXML
	w !,$ZError
	w !,"    MenuName="_$g(menuname)_",  menuFileName="_$g(menuFileName)
	quit -200
}

/*
--第1层侧菜单Sequence查询
SELECT SubMenuOf->caption Par, caption, Sequence, Sequence seq, * FROM websys.menu WHERE SubMenuOf->name='CSSDHUI.CSSD.Side'
ORDER BY seq

--第2层侧菜单Sequence查询
SELECT SubMenuOf->caption Par, caption, Sequence, Sequence seq, * FROM websys.menu WHERE SubMenuOf->SubMenuOf->name='CSSDHUI.CSSD.Side'
ORDER BY SubMenuOf->Sequence, seq

--第3层侧菜单Sequence查询
SELECT SubMenuOf->SubMenuOf->caption ParPar, SubMenuOf->caption Par, caption, Sequence, Sequence seq, * FROM websys.menu WHERE SubMenuOf->SubMenuOf->SubMenuOf->name='CSSDHUI.CSSD.Side'
ORDER BY SubMenuOf->SubMenuOf->Sequence, SubMenuOf->Sequence, seq
*/
}
