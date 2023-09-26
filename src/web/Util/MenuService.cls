/// @author: wanghc 
/// @date: 2013-04-12
/// @desc: 导出菜单工具类
Class web.Util.MenuService Extends %RegisteredObject
{

/// @input: MenuName 菜单名(模糊查询)
/// @input: GroupName 安全组名
/// @input: MenuGroupName 菜单组名
/// @desc: d ##class(%ResultSet).RunQuery("web.Util.MenuService","FindMenu","","demo","")
Query FindMenu(MenuName As %String = "", GroupName = "", MenuGroupName As %String = "") As websys.Query(ROWSPEC = "id,Caption")
{
}

ClassMethod FindMenuExecute(ByRef qHandle As %Binary, MenuName As %String = "", GroupName = "", MenuGroupName = "") As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s ^Temp("wanghc","exec")="d ##class(%ResultSet).RunQuery(""web.Util.MenuService"",""FindMenu"","""_MenuName_""","""_GroupName_""")"
    s GroupID = ##class(web.SSGroup).GetIdFromCodeOrDescription(GroupName)
    s myGroupMenuSecurity=""
    i GroupID'=""{
	    s myEprGSRowID=$o(^ooGroupSettingsI("GroupDRIndex", GroupID, 0))
		s myEGSObj=##class(epr.GroupSettings).%OpenId(myEprGSRowID, 0)
		s myGroupMenuSecurity = myEGSObj.MenuSecurity	
		d myEGSObj.%Close()   
    }
    s MenuGroupRowid = ##class(websys.Menu).GetIdFromCodeOrDescription(MenuGroupName)
    s Caption="",Name=""
    s id=""
    do{
		d getmenuid
		q:id=""				
		s ^CacheTemp(repid,ind)=$lb(id,Caption_"("_Name_")")
		s ind=ind+1
	}while(id'="")
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
 ;找到下一个满足条件的菜单ID
getmenuid	
	do{
		s id = $o(^websys.MenuD(id))
		q:id=""
		s Name = $lg(^websys.MenuD(id),4)
		s Caption = $lg(^websys.MenuD(id),1)
		s SubMenuOf = $lg(^websys.MenuD(id),12)
	    s MenuMatch=0,GroupMatch=0,MenuGroupMatch=0
	    s:MenuName="" MenuMatch=1
	    
		s:(MenuName'="")&&($zcvt(Name,"U")[$zcvt(MenuName,"U")) MenuMatch=1
		s:(MenuName'="")&&($zcvt(Caption,"U")[$zcvt(MenuName,"U")) MenuMatch=1
		
		s:MenuGroupRowid="" MenuGroupMatch=1
		s:(MenuGroupRowid'="")&&(SubMenuOf=MenuGroupRowid) MenuGroupMatch=1
		
		s:GroupID="" GroupMatch=1
		s:(GroupID'="")&&($zbitlen(myGroupMenuSecurity)>=id)&&($zbitget(myGroupMenuSecurity,id)=1) GroupMatch=1 
		q:GroupMatch&&MenuMatch&&MenuGroupMatch
	}while(id'="")
	q
}

ClassMethod ExportProxy(Path, ByRef SuccList, ByRef Len)
{
	s MenuIds = ""
	s cb="cbz"	
	do{
		s cb = $o(%request.Data(cb)) 
		q:cb=""
		if ($e(cb,1,3)="cbz"){
			if MenuIds="" s MenuIds=%request.Data(cb,1)
			e  s MenuIds = MenuIds_"^"_%request.Data(cb,1)
		}
	}while(cb'="")
	d ..Export(MenuIds,Path,.SuccList,.Len)
	q $$$OK
}

/// @Input MenuIds 菜单RowID串(websys.Menu-RowId)
/// @Input Path 导出的xml文件
/// @Output SuccList 成功导出菜单的列表
/// @Output Len 一共需要导出多少个菜单
/// @Sample w ##class(web.Util.MenuService).Export("52844^52111","d:\XMLPath\lookuptest.xml",.SuccList,.Len)
ClassMethod Export(MenuIds, Path, ByRef SuccList, ByRef Len)
{
	s ^Temp("wanghc","MenuService")=MenuIds_","_Path
	s SuccList=""
	s Len=0
	q:MenuIds="" -1
	q:Path="" -1
	
	s $zt = "Error"
	set file = ##class(%File).%New(Path)
	Do file.Open("WSN")
	;d file.WriteLine("<?xml version=""1.0"" encoding=""gb2312"" ?>")
	d file.WriteLine("<DHCMENUEXPORT>")
	d file.WriteLine("<Menus>")
	s Len = $l(MenuIds,"^")
	s i=1
	do{		
		set MenuId = $p(MenuIds,"^",i)
		if MenuId'=""{
			set po=##class(websys.Menu).%OpenId(MenuId,0)
			if $IsObject(po){
				set ro = ##class(web.Util.Menu).%New()
				do ro.CopyFrom(po)
				set xml = ro.Export(.file)				
				s SuccList(ro.Name)=ro.Caption
				do ro.%Close()
				set ro=""
				do po.%Close()
			}
			set po=""
		}
		set i=i+1
	}while(i<=Len)
	d file.WriteLine("</Menus>")
	d file.WriteLine("</DHCMENUEXPORT>")
Error
	d file.%Close()
	s file=""
	q $$$OK
}

ClassMethod ImportProxy(Path, ByRef SuccList)
{
	s MenuNames = "^"
	s cb="cbz"	
	do{
		s cb = $o(%request.Data(cb)) 
		q:cb=""
		if ($e(cb,1,3)="cbz"){
			s MenuNames = MenuNames_$g(%request.Data(cb,1))_"^"
		}
	}while(cb'="")
	d ..Import(Path,$g(%request.Data("overload",1)),.SuccList,MenuNames)
	q $$$OK
}

/// @Input {%String} Path 菜单xml文件
/// @Input {0/1} overload 是不是覆盖导入
/// @Output {ByRef} SuccList 成功导入的菜单列表
/// @Input {%String} MenuNames path文件中要导入的菜单名,dhc.dhctt.header^dhctt.config^....。导入文件中所有菜单则为空就成
/// w ##class(web.Util.MenuService).Import("d:/xml/menu.xml",0,.SuccList)
/// bug---如果xml中有header与header下的菜单,应该先导头菜单再导子菜单
ClassMethod Import(Path, overload As %Integer = 0, ByRef SuccList, MenuNames = "")
{
	s ExistsFlag=##Class(%File).Exists(Path)
	q:ExistsFlag'=1 "Error: "_Path_"  does not exist !"
	s $zt="ErrorImport"
	s reader = ##class(%XML.Reader).%New()
	s stream=##class(%FileCharacterStream).%New()
	s stream.Filename=Path
	s sc=reader.OpenStream(stream)
	d reader.Correlate("Menu","web.Util.Menu")
	s ret=$$$OK
	While reader.Next(.obj,.sc)	{
		Set menuName = obj.Name
		if (MenuNames="")||(MenuNames[("^"_menuName_"^")){
			s po=""
			if ##class(websys.Menu).UniqueNameIndexExists(menuName,.id){
				if overload{
					s po = ##class(websys.Menu).%OpenId(id)
				}
			}else{
				s po = ##class(websys.Menu).%New() 
			}
			if $IsObject(po){
				do obj.CopyTo(po)		
				set sc=po.%Save()
				if $system.Status.IsError(sc) {set ret=-102}
				set SuccList(menuName) = obj.Caption
				do po.%Close()
				set po=""
				q:ret<0
			}
		}				
	}
	
ErrorImport
	d stream.%Close()
	s stream = ""
	d reader.%Close()
	s reader = ""	
	q ret
}

/// 通过菜单名导出xml
/// 可开头匹配导出xml
/// d ##class(web.Util.MenuService).ExportByName("dhc.side","d:\tmp\dhc.side.1104.xml")
ClassMethod ExportByName(MenuName, path)
{
	Set rowids=""
	Set rs = ##class(%ResultSet).%New("web.Util.MenuService:FindMenu")
	Set sc = rs.Execute(MenuName)
	while(rs.Next()){
		Set rowids =rowids_"^"_rs.GetData(1)
	}
	w rowids,!
	do rs.Close()
	Set rs=""
	d ##class(web.Util.MenuService).Export(rowids,path,.slist,.len)
	zw slist
	q ""
}

/// d ##class(websys.DHCChartStyle).grantMenu(56342,56390,"住院医师")
ClassMethod grantMenu(stMenuId, endMenuId, groupDesc)
{
	Set ssGroupID = ##class(web.SSGroup).GetIdFromCodeOrDescription(groupDesc)
	Set eprGroupID= ##class(epr.GroupSettings).GetIdFromGroupId(ssGroupID)
	set objEprGroupSetting=##class(epr.GroupSettings).%OpenId(eprGroupID)
	set security=objEprGroupSetting.MenuSecurity
	set:security="" security=$zbitstr(50000,0)
	set:$zbitlen(security)<endMenuId security=$zbitor(security,$zbitstr(endMenuId,0))
	for i=stMenuId:1:endMenuId{
		set security=$zbitset(security,i,1)
	}
	Set objEprGroupSetting.MenuSecurity=security
	Set sc = objEprGroupSetting.%Save()
	i $$$ISOK( sc) w "grant menu success"
	e  w "grant menu fail"
}

/// 覆盖导入 w ##class(web.Util.MenuService).ImportTxt("d:\menu.txt",1,1)
/// Path : txt文件的绝对路径，要放在服务器的磁盘上。
/// DisplayLog : 执行函数是否在控制台显示日志（一般显示）
/// overwrite : 菜单存在相同的代码名称时，是否覆盖。默认0:跳过不更新，不覆盖。
ClassMethod ImportTxt(Path, DisplayLog = 1, overwrite = 0)
{
	s ExistsFlag=##Class(%File).Exists(Path)
	q:ExistsFlag'=1 "Error: "_ Path _"  does not exist !"
	Set file = ##class(%File).%New(Path)
	Set file.Name = Path
	Set sc = file.Open("WRS")
	if $$$ISERR(sc){
		do file.Close()
		set file=""
		Quit "读取文件异常"_$system.Status.GetErrorText(sc)
	}
	k ^||importTxtContentTemp
	Set PChar = $c(9)
	While('file.AtEnd){
		Set Str = file.ReadLine()
		Set Name = $P(Str,PChar,1)		
		Continue:Name=""
		Set ParCode = $P(Str,PChar,5)
		Set:$D(^||importTxtContentTemp(Name)) repeatMenuName = Name
		Set ^||importTxtContentTemp(Name) = Str
		Set ^||importTxtContentTemp(Name, "parentCode") = ParCode	
	}
	Do file.Close()
	Set file=""
	Quit:$D(repeatMenuName) "文件中，有重复名字的菜单：" _ repeatMenuName
	TS
	Set Success=0
	Set Name = ""
	for {
		Set Name = $O(^||importTxtContentTemp(Name))
		Quit:Name=""
		;b ;1
		Set Success = ..saveMenuObj( Name, overwrite)
		Quit:Success=0
	}
	k ^||importTxtContentTemp
	If Success=0 {TRo  b  Quit Rtn_",保存失败"}
	TC
	w !,"成功结束"
	Quit ""
}

ClassMethod saveMenuObj(Name, overwrite)
{
	;b ;3
	Quit:$d(^||importTxtContentTemp(Name, "rowid")) 1	
	s parentCode = $G(^||importTxtContentTemp(Name, "parentCode"))
	if ((parentCode="") || $d(^||importTxtContentTemp(parentCode, "rowid"))) {
		;b ;4
		d insertOrUpdate
	} else {
		s Success = ..saveMenuObj( parentCode, overwrite) // 先保存父菜单
		;b ;5
		s Success = ..saveMenuObj( Name, overwrite) // 再保存子菜单
		;b ;6
	}
	Quit:$G(Success)=0 Success
	Quit 1
insertOrUpdate()
	;b ;2
	Set Str = ^||importTxtContentTemp(Name)
	Set PChar = $c(9)
	Set Caption = $P(Str,PChar,2),LinkUrl = $P(Str,PChar,3),ValueExpression = $P(Str,PChar,4),ParCode = $P(Str,PChar,5),Sequence = $P(Str,PChar,6)
	Set SubMenuOf = parentCode
	Set:parentCode'="" SubMenuOf = $G(^||importTxtContentTemp(parentCode, "rowid"))
	&sql(select ID into :RowId From websys.Menu where Name=:Name)
	If SQLCODE=100{
		&sql(
			insert into websys.menu (Name,Caption,LinkUrl,ValueExpression,Sequence,SubMenuOf) 
			values (:Name,:Caption,:LinkUrl,:ValueExpression,:Sequence,:SubMenuOf)
		)
		If SQLCODE=0{
			Write !,"导入成功 "_ Caption _","_%ROWID
			IF ##class(websys.Conversions).IsValidMethodName("BSP.GRPHOSP.SRV.Interface","SetDataShowFlag") d ##class(BSP.GRPHOSP.SRV.Interface).SetDataShowFlag("websys.Menu",%ROWID,"ALL")
			s ^||importTxtContentTemp(Name, "rowid") = %ROWID
		}ELSE {
			Write ",导入失败 ",SQLCODE
			Set Success=0
		}
	}else{
		If RowId>0 {
			Write !,"已存在 "_Caption_","_RowId
			if (overwrite){
				Write ",覆盖导入"
				&sql(
					update websys.menu 
					Set Caption=:Caption,LinkUrl=:LinkUrl,ValueExpression=:ValueExpression,Sequence=:Sequence,SubMenuOf=:SubMenuOf
					Where ID=:RowId
				)
				If SQLCODE=0{
					Write "成功 "_Caption_","_%ROWID
					//s ^||importTxtContentTemp(Name, "rowid") = RowId
				}ELSE {
					Write "失败 ",SQLCODE
					Set Success=0
				}
			}
		}
		s ^||importTxtContentTemp(Name, "rowid") = RowId // 避免死循环
	}
}

ClassMethod AjaxExport(MenuIds, fileName)
{
	s fileName=$tr(fileName,"\/","..")
	s menuxml="\temp\menuxml\"
	s path = ##class(ext.util.String).GetPhysicalPath("",menuxml)
	if '##class(%File).DirectoryExists(path) d ##class(%File).CreateDirectoryChain(path)
	if $p(fileName,".",$l(fileName,"."))="xml" s fileName=$e(fileName,1,$l(fileName)-4)
	s fileNameWithExt=fileName_".xml"
	
	if ##class(%File).Exists(path_fileNameWithExt) {
		s fileName=fileName_"-"_$tr($zdt($h,3),"- :","")
		s fileNameWithExt=fileName_".xml"
	}
	d ..Export(MenuIds,path_fileNameWithExt,.SuccList,.Len)
	s json=##class(BSP.SYS.COM.ProxyObject).%New()
	s json.success=1
	s json.url="dhctt.file.csp?act=download&dirname="_path_"&filename="_fileNameWithExt_""
	q json.%ToJSON()
}

ClassMethod AjaxImport(fileName, overwrite = 0, MenuNames = "", HospId = "")
{
	s grantHospFlag=0
	if HospId>0,##class(%Dictionary.MethodDefinition).%ExistsId("BSP.GRPHOSP.SRV.Interface||SetDataShowFlag") s grantHospFlag=1
	if MenuNames'="" s MenuNames="^"_MenuNames_"^"
	s json=##class(BSP.SYS.COM.ProxyObject).%New()
	s menuxml="\temp\menuxml\"
	s path = ##class(ext.util.String).GetPhysicalPath("",menuxml)
	s fullFileName=path_fileName
	if ##Class(%File).Exists(fullFileName){
		s ret=..Import(fullFileName,overwrite=1,.SuccList,MenuNames)
		s cnt=0,code="",arr=##class(BSP.SYS.COM.ProxyArray).%New()
		f  s code=$o(SuccList(code)) q:code=""  d
		.s item=##class(BSP.SYS.COM.ProxyObject).%New()
		.s item.code=code,item.desc=SuccList(code),cnt=cnt+1
		.if grantHospFlag,##class(websys.Menu).UniqueNameIndexExists(code,.menuid) d ##class(BSP.GRPHOSP.SRV.Interface).SetDataShowFlag("websys.Menu",menuid,HospId)
		.d arr.%Push(item)
		
		s json.success=1
		s json.data=arr
		s json.msg=ret
	}else{
		s json.success=0
		s json.msg="文件"_fileName_"不存在"	
	}
	q json.%ToJSON()
}

ClassMethod AjaxParseMenuXml()
{
	s json=##class(BSP.SYS.COM.ProxyObject).%New()
	if $data(%request.MimeData("FileStream",1)){
		s menuxml="\temp\menuxml\"
		s path = ##class(ext.util.String).GetPhysicalPath("",menuxml)
		if '##class(%File).DirectoryExists(path) d ##class(%File).CreateDirectoryChain(path)
		
		Set fileStream = %request.MimeData("FileStream",1)
		Set fileName = fileStream.FileName
		Set fileName = $p(fileName,"\",$l(fileName,"\"))
		Set fileName = $p(fileName,"/",$l(fileName,"/"))
		if $p(fileName,".",$l(fileName,"."))="xml" {
			s fileName=$e(fileName,1,$l(fileName)-4)
			s fileNameWithExt=fileName_".xml"
			
			if ##class(%File).Exists(path_fileNameWithExt) {
				s fileName=fileName_"-"_$tr($zdt($h,3),"- :","")
				s fileNameWithExt=fileName_".xml"
			}
			Set file = ##class(%FileBinaryStream).%New()
			Set file.Filename=path_fileNameWithExt
			Do file.Rewind()
			do file.CopyFromAndSave(fileStream)
			Do file.Flush()
			Do file.%Save()
			do file.%Close()
			s file=""
			
			//存完文件 读文件 解析xml
			s reader = ##class(%XML.Reader).%New()
			s stream=##class(%FileCharacterStream).%New()
			s stream.Filename=path_fileNameWithExt
			s sc=reader.OpenStream(stream)
			d reader.Correlate("Menu","web.Util.Menu")
			s count=0,arr=##class(BSP.SYS.COM.ProxyArray).%New()
			While reader.Next(.obj,.sc){
				s exists=0
				if ##class(websys.Menu).UniqueNameIndexExists(obj.Name,.id) s exists=1
				s item=##class(BSP.SYS.COM.ProxyObject).%New()
				s item.code=obj.Name,item.desc=obj.Caption,item.ind=$i(count),item.exists=exists
				d arr.%Push(item)
			}
			
			d stream.%Close()
			s stream = ""
			d reader.%Close()
			s reader = ""
			
			s json.success=1
			s json.data=arr
			s json.fileName=fileNameWithExt
		}else{
			s json.success=0
			s json.msg="仅支持xml格式的文件导入"
		}
	}else{
		s json.success=0
		s json.msg="请选择正确的文件"
	}
	q json.%ToJSON()
}

}
