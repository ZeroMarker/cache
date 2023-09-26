Class web.DHCHM.MenuImp Extends %Persistent [ Not ProcedureBlock ]
{

/// 备份菜单
/// d ##class(web.DHCHM.MenuImp).BakMenu("DHCHM","d:/DHCHM/")
ClassMethod BakMenu(nameprefix As %String, filename, MinID As %Library.String = 0)
{
	
	new rset,sql,MenuName,MenuNames,parmenu
	Set rset = ##class(%ResultSet).%New()
	set sql="SELECT Name FROM websys.Menu WHERE Name like '"_nameprefix_"%'"_" order by submenuof Asc"
 	Do rset.Prepare(sql)
 	Do rset.Execute()
 	set MenuNames=""
 	s filename=##class(Tools).Replace(filename,"\","/")
 	s filename=filename_"Menu/"
 	s flag=..CreateDirectory(filename)
	
 	Set MenuFile=filename_"DHCPEMenu.txt"
 	Set file=##class(%File).%New(MenuFile)
	Do file.Open("WSN")
	k ^DHCPEMenu
	While (rset.Next(.sc)) // go to the next row of the result set
 	{
 		If ($SYSTEM.Status.IsOK(sc)) // check if this succeeded withut errors
 		{
	 		set MenuName=rset.Data("Name") // perform busines logic
 			s MenuID=+$o(^websys.MenuI("UniqueNameIndex"," "_$ZCVT(MenuName,"U"),0))
 			continue:MenuID<+MinID
 			w MenuName,!
 			Do file.WriteLine(MenuName)
 			set parmenu=##class(web.DHCHM.Menu).GetMenuByName(MenuName)
 			s FName=filename_MenuName_".txt"	
	 		s f=##class(%File).%New(FName)
	 		Do f.Open("WSN")
	 		s Node1=""
 			f  s Node1=$o(^DHCPEMenu(MenuName,Node1)) q:Node1=""  d
 			.s text=$G(^DHCPEMenu(MenuName,Node1))
 			.s text=..Remove(text)
 			.s text="^DHCPEMenu("_""""_MenuName_""""_","_""""_Node1_""""_")="_""""_text_""""
 			.i $o(^DHCPEMenu(MenuName,Node1,""))="" Do f.WriteLine(text)
 			.s Node2=""
 			.f  s Node2=$o(^DHCPEMenu(MenuName,Node1,Node2)) q:Node2=""  d
 			..s text=$G(^DHCPEMenu(MenuName,Node1,Node2))
 			..s text=..Remove(text)
 			..s text="^DHCPEMenu("_""""_MenuName_""""_","_""""_Node1_""""_","_""""_Node2_""""_")="_""""_text_""""
 			..i $o(^DHCPEMenu(MenuName,Node1,Node2,""))="" Do f.WriteLine(text)
 			..s Node3=""
 			..f  s Node3=$o(^DHCPEMenu(MenuName,Node1,Node2,Node3)) q:Node3=""  d
 			...s text=$G(^DHCPEMenu(MenuName,Node1,Node2,Node3))
 			...s text=..Remove(text)
 			...s text="^DHCPEMenu("_""""_MenuName_""""_","_""""_Node1_""""_","_""""_Node2_""""_","_""""_Node3_""""_")="_""""_text_""""
 			...i $o(^DHCPEMenu(MenuName,Node1,Node2,Node3,""))="" Do f.WriteLine(text)
 			...s Node4=""
 			...f  s Node4=$o(^DHCPEMenu(MenuPEName,Node1,Node2,Node3,Node4)) q:Node4=""  d
 			....s text=$G(^DHCPEMenu(MenuName,Node1,Node2,Node3,Node4))
 			....s text=..Remove(text)
 			....s text="^DHCPEMenu("_""""_MenuName_""""_","_""""_Node1_""""_","_""""_Node2_""""_","_""""_Node3_""""_","_""""_Node4_""""_")="_""""_text_""""
 			....Do f.WriteLine(text)
 			Do f.Close()
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
 	Kill ^DHCPEMenu
	Quit MenuNames
}

//d ##class(web.DHCHM.MenuImp).BakMenusBySubMenuOf("DHCHM","d:/DHCHM/")

ClassMethod BakMenusBySubMenuOf(SubMenuOfName, filename)
{
	s SubMenuOf=$O(^websys.MenuI("UniqueNameIndex"," "_SubMenuOfName,0))
	q:SubMenuOf="" "菜单名称错误"
	s filename=##class(Tools).Replace(filename,"\","/")
 	s filename=filename_"Menu/"
 	s flag=..CreateDirectory(filename)
	
 	Set MenuFile=filename_"DHCPEMenu.txt"
 	Set file=##class(%File).%New(MenuFile)
	Do file.Open("WSN")
	k ^DHCPEMenu
	d BakOneMenu(SubMenuOfName)
	s MenuID=0
	f  s MenuID=$o(^websys.MenuI("SubMenuOf1",SubMenuOf,MenuID)) q:MenuID=""  d
	.s MenuName=$LIST($G(^websys.MenuD(MenuID)),4)
	.d BakOneMenu(MenuName)
 	Do file.Close()
 	Kill ^DHCPEMenu
 	
BakOneMenu(MenuName)
	w MenuName,!
 	Do file.WriteLine(MenuName)
 	set parmenu=##class(web.DHCHM.Menu).GetMenuByName(MenuName)
 	s FName=filename_MenuName_".txt"	
	s f=##class(%File).%New(FName)
	Do f.Open("WSN")
	s Node1=""
 	f  s Node1=$o(^DHCPEMenu(MenuName,Node1)) q:Node1=""  d
 	.s text=$G(^DHCPEMenu(MenuName,Node1))
 	.s text=..Remove(text)
 	.s text="^DHCPEMenu("_""""_MenuName_""""_","_""""_Node1_""""_")="_""""_text_""""
 	.i $o(^DHCPEMenu(MenuName,Node1,""))="" Do f.WriteLine(text)
 	.s Node2=""
 	.f  s Node2=$o(^DHCPEMenu(MenuName,Node1,Node2)) q:Node2=""  d
 	..s text=$G(^DHCPEMenu(MenuName,Node1,Node2))
 	..s text=..Remove(text)
 	..s text="^DHCPEMenu("_""""_MenuName_""""_","_""""_Node1_""""_","_""""_Node2_""""_")="_""""_text_""""
 	..i $o(^DHCPEMenu(MenuName,Node1,Node2,""))="" Do f.WriteLine(text)
 	..s Node3=""
 	..f  s Node3=$o(^DHCPEMenu(MenuName,Node1,Node2,Node3)) q:Node3=""  d
 	...s text=$G(^DHCPEMenu(MenuName,Node1,Node2,Node3))
 	...s text=..Remove(text)
 	...s text="^DHCPEMenu("_""""_MenuName_""""_","_""""_Node1_""""_","_""""_Node2_""""_","_""""_Node3_""""_")="_""""_text_""""
 	...i $o(^DHCPEMenu(MenuName,Node1,Node2,Node3,""))="" Do f.WriteLine(text)
 	...s Node4=""
 	...f  s Node4=$o(^DHCPEMenu(MenuPEName,Node1,Node2,Node3,Node4)) q:Node4=""  d
 	....s text=$G(^DHCPEMenu(MenuName,Node1,Node2,Node3,Node4))
 	....s text=..Remove(text)
 	....s text="^DHCPEMenu("_""""_MenuName_""""_","_""""_Node1_""""_","_""""_Node2_""""_","_""""_Node3_""""_","_""""_Node4_""""_")="_""""_text_""""
 	....Do f.WriteLine(text)
 	Do f.Close()
}

/// 更新菜单
/// d ##class(web.DHCHM.MenuImp).UpdateMenus("d:/DHCHM/")
ClassMethod UpdateMenus(filename As %String)
{
	k ^DHCPEMenu
	s filename=##class(Tools).Replace(filename,"\","/")
	s filename=filename_"Menu/"
	s Menutext=filename_"DHCPEMenu.txt"
	If '##class(%File).Exists(Menutext) q "File Not Found"
	new line,MenuID,errs
	s errs=""
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename=Menutext
	While 'stream.AtEnd {
		Set line=stream.ReadLine()
		if line="" continue
		s st=##class(%FileCharacterStream).%New()
		s st.Filename=filename_line_".txt"
		while 'st.AtEnd{
			s text=st.ReadLine()
			i text="" continue
			s aa=text,@aa
		}
		d ReturnMenuStr(line)
		Set MenuID=##class(web.DHCHM.Menu).ImportMenuByName(line)
		w line_MenuID,!
		
	}
	if (errs'="")
		{	w "err:"_errs
			q
		}
	k ^DHCPEMenu
	q "OVER"
ReturnMenuStr(MenuName)
	s Node1=""
 	f  s Node1=$o(^DHCPEMenu(MenuName,Node1)) q:Node1=""  d
 	.s text=$G(^DHCPEMenu(MenuName,Node1))
 	.s text=..ReturnStr(text)
 	.i $o(^DHCPEMenu(MenuName,Node1,""))="" s ^DHCPEMenu(MenuName,Node1)=text
 	.s Node2=""
 	.f  s Node2=$o(^DHCPEMenu(MenuName,Node1,Node2)) q:Node2=""  d
 	..s text=$G(^DHCPEMenu(MenuName,Node1,Node2))
 	..s text=..ReturnStr(text)
 	..i $o(^DHCPEMenu(MenuName,Node1,Node2,""))="" s ^DHCPEMenu(MenuName,Node1,Node2)=text
 	..s Node3=""
 	..f  s Node3=$o(^DHCPEMenu(MenuName,Node1,Node2,Node3)) q:Node3=""  d
 	...s text=$G(^DHCPEMenu(MenuName,Node1,Node2,Node3))
 	...s text=..ReturnStr(text)
 	...i $o(^DHCPEMenu(MenuName,Node1,Node2,Node3,""))="" s ^DHCPEMenu(MenuName,Node1,Node2,Node3)=text
 	...s Node4=""
 	...f  s Node4=$o(^DHCPEMenu(MenuName,Node1,Node2,Node3,Node4)) q:Node4=""  d
 	....s text=$G(^DHCPEMenu(MenuName,Node1,Node2,Node3,Node4))
 	....s text=..ReturnStr(text)
 	....s ^DHCPEMenu(MenuName,Node1,Node2,Node3,Node4)=text
 	
 	q
}

/// 恢复 "  '  $C(13)  $C(10)  等符号
ClassMethod ReturnStr(text)
{
	s text=##class(Tools).Replace(text,"$C(10)",$C(10))
 	s text=##class(Tools).Replace(text,"$C(13)",$C(13))
 	s text=##class(Tools).Replace(text,"$C(2)","'")
 	s text=##class(Tools).Replace(text,"$C(1)","""")
 	q text
}

/// 去掉 "  '  $C(13)  $C(10)  等符号
ClassMethod Remove(text)
{
	s text=##class(Tools).Replace(text,"""","$C(1)")
 	s text=##class(Tools).Replace(text,"'","$C(2)")
 	s text=##class(Tools).Replace(text,$C(13),"$C(13)")
 	s text=##class(Tools).Replace(text,$C(10),"$C(10)")
 	q text
}

/// 创建一个新目录
/// d ##class(web.DHCHM.MenuImp).CreateDirectory("d:\wrz\wrz\wrz")
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

Storage Default
{
<Data name="MenuImpDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCHM.MenuImpD</DataLocation>
<DefaultData>MenuImpDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCHM.MenuImpD</IdLocation>
<IndexLocation>^web.DHCHM.MenuImpI</IndexLocation>
<StreamLocation>^web.DHCHM.MenuImpS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
