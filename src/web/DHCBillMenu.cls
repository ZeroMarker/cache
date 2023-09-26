Import SQLUSER

/// Creator:	TangTao
/// CreateDate:	2014-04-10
/// Function:	jQuery类
Class web.DHCBillMenu Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:	TangTao
/// CreateDate:	2014-04-10
/// Discription:生成侧菜单json数据
/// Input：		初始化侧菜单是的json数据主节点
/// w ##class(web.DHCBillMenu).jQueryWriteJson("basic")
ClassMethod jQueryWriteJson(Root)
{
	;s ^TMP("tt")=Root
	Kill JudgeNode
	Set MainMenuStr=""
	Set PareRowid=""
	For  Set PareRowid=$o(^DHCJFSYSTREENODE("0",PareRowid)) Quit:PareRowid=""  Do
	.Quit:PareRowid<=0
	.Set DHCSNote1=$p(^DHCJFSYSTREENODE(PareRowid),"^",8)	; 值为main是头菜单,显示
	.Quit:DHCSNote1="main"
	.Quit:PareRowid=49
	.Quit:PareRowid=39
	.Set DHCSTText=$p(^DHCJFSYSTREENODE(PareRowid),"^",1)
	.Set DHCSTHref=$p(^DHCJFSYSTREENODE(PareRowid),"^",10)
	.Set DHCSNote2=$p(^DHCJFSYSTREENODE(PareRowid),"^",9)
	.Set MenuStr="""menuid"" : """_PareRowid_""","_" ""icon"" : """_DHCSNote2_""","_" ""menuname"" : """_DHCSTText_""","_" ""menus"" : ["
	.Quit:$d(JudgeNode(PareRowid))
	.Set NodeRowid="",SubMenuStr=""
	.For  Set NodeRowid=$o(^DHCJFSYSTREENODE("0",PareRowid,"ParrentNode",NodeRowid)) Quit:NodeRowid=""  Do
	..Quit:NodeRowid=0
	..Quit:NodeRowid=49
	..Quit:NodeRowid=39
	..Set rtn=..JudgeIsParentorNot(NodeRowid)
	..If rtn="" Do
	...Set DHCSTText=$p(^DHCJFSYSTREENODE(NodeRowid),"^",1)
	...Set DHCSTHref=$p(^DHCJFSYSTREENODE(NodeRowid),"^",10)
	...Set DHCSNote2=$p(^DHCJFSYSTREENODE(NodeRowid),"^",9)
	...If DHCSTHref="" Set DHCSTHref="#"
	...If SubMenuStr="" Set SubMenuStr="{ "_"""menuid"" : """_NodeRowid_""","_" ""icon"" : """_DHCSNote2_""","_" ""menuname"" : """_DHCSTText_""","_" ""url"" : """_DHCSTHref_"""}"
	...Else  Set SubMenuStr=SubMenuStr_","_"{ "_"""menuid"" : """_NodeRowid_""","_" ""icon"" : """_DHCSNote2_""","_" ""menuname"" : """_DHCSTText_""","_" ""url"" : """_DHCSTHref_"""}"
	..Else  Do
	...Set DHCSTText=$p(^DHCJFSYSTREENODE(NodeRowid),"^",1)
	...Set DHCSTHref=$p(^DHCJFSYSTREENODE(NodeRowid),"^",10)
	...Set DHCSNote2=$p(^DHCJFSYSTREENODE(NodeRowid),"^",9)
	...If DHCSTHref="" Set DHCSTHref="#"
	...If SubMenuStr="" Set SubMenuStr="{ "_"""menuid"" : """_NodeRowid_""","_" ""icon"" : """_DHCSNote2_""","_" ""menuname"" : """_DHCSTText_""","_" ""menus"" : ["_rtn_"]}"
	...Else  Set SubMenuStr=SubMenuStr_","_"{ "_"""menuid"" : """_NodeRowid_""","_" ""icon"" : """_DHCSNote2_""","_" ""menuname"" : """_DHCSTText_""","_" ""menus"" : ["_rtn_"]}"
	..Set JudgeNode(NodeRowid)=NodeRowid
	.Set MenuStr="{"_MenuStr_SubMenuStr_"]}"
	.If MainMenuStr="" Set MainMenuStr=MenuStr
	.Else  Set MainMenuStr=MainMenuStr_","_MenuStr
	Set MainMenuStr="{"""_Root_""": ["_MainMenuStr_"]}"
	;Set MainMenuStr="["_MainMenuStr_"]"

	Quit MainMenuStr
}

/// w ##class(web.DHCBillMenu).JudgeIsParentorNot()
ClassMethod JudgeIsParentorNot(PareRowid)
{
	New (PareRowid)
	Quit:'$d(^DHCJFSYSTREENODE("0",PareRowid)) ""
	Set NodeRowid="",SubMenuStr=""
	For  Set NodeRowid=$o(^DHCJFSYSTREENODE("0",PareRowid,"ParrentNode",NodeRowid)) Quit:NodeRowid=""  Do
	.Quit:NodeRowid=0
	.Set DHCSTText=$p(^DHCJFSYSTREENODE(NodeRowid),"^",1)
	.Set DHCSTHref=$p(^DHCJFSYSTREENODE(NodeRowid),"^",10)
	.Set DHCSNote2=$p(^DHCJFSYSTREENODE(NodeRowid),"^",9)
	.If SubMenuStr="" Set SubMenuStr="{ "_"""menuid"" : """_NodeRowid_""","_" ""icon"" : """_DHCSNote2_""","_" ""menuname"" : """_DHCSTText_""","_" ""url"" : """_DHCSTHref_"""}"
	.Else  Set SubMenuStr=SubMenuStr_","_"{ "_"""menuid"" : """_NodeRowid_""","_" ""icon"" : """_DHCSNote2_""","_" ""menuname"" : """_DHCSTText_""","_" ""url"" : """_DHCSTHref_"""}"
	Quit SubMenuStr
}

/// Creator:	TangTao
/// CreateDate:	2014-04-10
/// Discription:生成侧菜单json数据
/// Input：		初始化侧菜单是的json数据主节点
/// w ##class(web.DHCBillMenu).jQueryWriteJsonNew("basic")
ClassMethod jQueryWriteJsonNew(Root)
{
	;s ^TMP("tt")=Root
	k JudgeNode
	Set MainMenuStr=""
	Set PareRowid=""
	For  Set PareRowid=$o(^DHCBILLCHECKTREENODE(PareRowid)) Quit:PareRowid=""  Do
	.Quit:PareRowid<=0
	.Set DHCBTNote1=$p(^DHCBILLCHECKTREENODE(PareRowid),"^",8)	; 值为main是头菜单,显示
	.Quit:DHCBTNote1="main"
	.Quit:DHCBTNote1["child"	; 显示父菜单 foldermenu
	.Quit:PareRowid=4
	.Set DHCBTTText=$p(^DHCBILLCHECKTREENODE(PareRowid),"^",1)
	.Set DHCBTTHref=$p(^DHCBILLCHECKTREENODE(PareRowid),"^",10)
	.Set DHCBTNote2=$p(^DHCBILLCHECKTREENODE(PareRowid),"^",9)
	.Set MenuStr="""menuid"" : """_PareRowid_""","_" ""icon"" : """_DHCBTNote2_""","_" ""menuname"" : """_DHCBTTText_""","_" ""menus"" : ["
	.Quit:$d(JudgeNode(PareRowid))
	.Set NodeRowid="",SubMenuStr=""
	.For  Set NodeRowid=$o(^DHCBILLCHECKTREENODE("0",PareRowid,"ParrentNode",NodeRowid)) Quit:NodeRowid=""  Do
	..Quit:NodeRowid=0
	..Set rtn=..JudgeIsParentorNotNew(NodeRowid)
	..If rtn="" Do
	...Set DHCBTTText=$p(^DHCBILLCHECKTREENODE(NodeRowid),"^",1)
	...Set DHCBTTHref=$p(^DHCBILLCHECKTREENODE(NodeRowid),"^",10)
	...Set DHCBTNote2=$p(^DHCBILLCHECKTREENODE(NodeRowid),"^",9)
	...Set DHCBTClassName=$p(^DHCBILLCHECKTREENODE(NodeRowid),"^",11)
	...Set DHCBTMethodName=$p(^DHCBILLCHECKTREENODE(NodeRowid),"^",12)
	...Set DHCBTParam=$p(^DHCBILLCHECKTREENODE(NodeRowid),"^",13)
	...Set DHCBTParamNum=$p(^DHCBILLCHECKTREENODE(NodeRowid),"^",14)
	...If DHCBTTHref="" Set DHCBTTHref="#"
	...If SubMenuStr="" Set SubMenuStr="{ "_"""menuid"" : """_NodeRowid_""","_" ""icon"" : """_DHCBTNote2_""","_" ""menuname"" : """_DHCBTTText_""","_" ""url"" : """_DHCBTTHref_""","_" ""classname"" : """_DHCBTClassName_""","_" ""methodname"" : """_DHCBTMethodName_""","_" ""menuparam"" : """_DHCBTParam_""","_" ""menuparamnum"" : """_DHCBTParamNum_"""}"
	...Else  Set SubMenuStr=SubMenuStr_","_"{ "_"""menuid"" : """_NodeRowid_""","_" ""icon"" : """_DHCBTNote2_""","_" ""menuname"" : """_DHCBTTText_""","_" ""url"" : """_DHCBTTHref_""","_" ""classname"" : """_DHCBTClassName_""","_" ""methodname"" : """_DHCBTMethodName_""","_" ""menuparam"" : """_DHCBTParam_""","_" ""menuparamnum"" : """_DHCBTParamNum_"""}"
	..Else  Do
	...Set DHCBTTText=$p(^DHCBILLCHECKTREENODE(NodeRowid),"^",1)
	...Set DHCBTTHref=$p(^DHCBILLCHECKTREENODE(NodeRowid),"^",10)
	...Set DHCBTNote2=$p(^DHCBILLCHECKTREENODE(NodeRowid),"^",9)
	...If DHCBTTHref="" Set DHCBTTHref="#"
	...If SubMenuStr="" Set SubMenuStr="{ "_"""menuid"" : """_NodeRowid_""","_" ""icon"" : """_DHCBTNote2_""","_" ""menuname"" : """_DHCBTTText_""","_" ""menus"" : ["_rtn_"]}"
	...Else  Set SubMenuStr=SubMenuStr_","_"{ "_"""menuid"" : """_NodeRowid_""","_" ""icon"" : """_DHCBTNote2_""","_" ""menuname"" : """_DHCBTTText_""","_" ""menus"" : ["_rtn_"]}"
	..Set JudgeNode(NodeRowid)=NodeRowid
	.Set MenuStr="{"_MenuStr_SubMenuStr_"]}"
	.If MainMenuStr="" Set MainMenuStr=MenuStr
	.Else  Set MainMenuStr=MainMenuStr_","_MenuStr
	Set MainMenuStr="{"""_Root_""": ["_MainMenuStr_"]}"
	;Set MainMenuStr="["_MainMenuStr_"]"

	Quit MainMenuStr
}

/// w ##class(web.DHCBillMenu).JudgeIsParentorNotNew(1)
ClassMethod JudgeIsParentorNotNew(PareRowid)
{
	New (PareRowid)
	Quit:'$d(^DHCBILLCHECKTREENODE("0",PareRowid)) ""
	Set NodeRowid="",SubMenuStr=""
	For  Set NodeRowid=$o(^DHCBILLCHECKTREENODE("0",PareRowid,"ParrentNode",NodeRowid)) Quit:NodeRowid=""  Do
	.Quit:NodeRowid=0
	.Set DHCBTTText=$p(^DHCBILLCHECKTREENODE(NodeRowid),"^",1)
	.Set DHCBTTHref=$p(^DHCBILLCHECKTREENODE(NodeRowid),"^",10)
	.Set DHCBTNote2=$p(^DHCBILLCHECKTREENODE(NodeRowid),"^",9)
	.Set DHCBTClassName=$p(^DHCBILLCHECKTREENODE(NodeRowid),"^",11)
	.Set DHCBTMethodName=$p(^DHCBILLCHECKTREENODE(NodeRowid),"^",12)
	.Set DHCBTParam=$p(^DHCBILLCHECKTREENODE(NodeRowid),"^",13)
	.Set DHCBTParamNum=$p(^DHCBILLCHECKTREENODE(NodeRowid),"^",14)
	.If SubMenuStr="" Set SubMenuStr="{ "_"""menuid"" : """_NodeRowid_""","_" ""icon"" : """_DHCBTNote2_""","_" ""menuname"" : """_DHCBTTText_""","_" ""url"" : """_DHCBTTHref_""","_" ""classname"" : """_DHCBTClassName_""","_" ""methodname"" : """_DHCBTMethodName_""","_" ""menuparam"" : """_DHCBTParam_""","_" ""menuparamnum"" : """_DHCBTParamNum_"""}"
	.Else  Set SubMenuStr=SubMenuStr_","_"{ "_"""menuid"" : """_NodeRowid_""","_" ""icon"" : """_DHCBTNote2_""","_" ""menuname"" : """_DHCBTTText_""","_" ""url"" : """_DHCBTTHref_""","_" ""classname"" : """_DHCBTClassName_""","_" ""methodname"" : """_DHCBTMethodName_""","_" ""menuparam"" : """_DHCBTParam_""","_" ""menuparamnum"" : """_DHCBTParamNum_"""}"
	Quit SubMenuStr
}

Query FindCheckMenu(MenuType) As %Query(ROWSPEC = "Rowid:%String,DHCBTText:%String,DHCBTHref:%String,DHCBTMenuTypeDesc:%String,DHCBTParentText:%String,DHCBTClassName:%String,DHCBTMethodName:%String,DHCBTParentNode:%String,DHCBTMenuType:%String,DHCBTParam:%String,DHCBTParamNum:%String")
{
}

ClassMethod FindCheckMenuExecute(ByRef qHandle As %Binary, MenuType) As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    
    Set Rowid=""
    For  Set Rowid=$o(^DHCBILLCHECKTREENODE(Rowid)) Quit:Rowid=""  Do
    .Quit:Rowid=0
    .Set DHCBTText=$p(^DHCBILLCHECKTREENODE(Rowid),"^",1)
    .Set DHCBTHref=$p(^DHCBILLCHECKTREENODE(Rowid),"^",3)
    .Set DHCBTMenuType=$p(^DHCBILLCHECKTREENODE(Rowid),"^",8)
   	.Set DHCBTMenuTypeDesc=""
    .If DHCBTMenuType="main" Set DHCBTMenuTypeDesc="主菜单"
    .If DHCBTMenuType="foldermenu" Set DHCBTMenuTypeDesc="父菜单"
    .If DHCBTMenuType="childmenu" Set DHCBTMenuTypeDesc="子菜单"
    .Quit:((MenuType'="")&(MenuType'[DHCBTMenuType))
    .Set DHCBTParentNode=$p(^DHCBILLCHECKTREENODE(Rowid),"^",5)
    .Set DHCBTParentText=""
    .If DHCBTParentNode'=0 Set DHCBTParentText=$p(^DHCBILLCHECKTREENODE(DHCBTParentNode),"^",1)
    .Set DHCBTClassName=$p(^DHCBILLCHECKTREENODE(Rowid),"^",11)
    .Set DHCBTMethodName=$p(^DHCBILLCHECKTREENODE(Rowid),"^",12)
    .Set DHCBTParam=$p(^DHCBILLCHECKTREENODE(Rowid),"^",13)
    .Set DHCBTParamNum=$p(^DHCBILLCHECKTREENODE(Rowid),"^",14)
    .Do OutputRowMenu
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowMenu
	Set Data=$lb(Rowid,DHCBTText,DHCBTHref,DHCBTMenuTypeDesc,DHCBTParentText,DHCBTClassName,DHCBTMethodName,DHCBTParentNode,DHCBTMenuType,DHCBTParam,DHCBTParamNum)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindCheckMenuClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckMenuExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCheckMenuFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckMenuExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod InsertMenu(InsertInto)
{
	s ^TMP("tt",1)=InsertInto
	Set DHCBTText=$p(InsertInto,"^",2)
	Set DHCBTCode="MenuTree"
	Set DHCBTHref=$p(InsertInto,"^",3)
	Set DHCBTLeaf="false"
	Set DHCBTHrefTarget="mainFrame"
	Set DHCBTNote1=$p(InsertInto,"^",4)
	Set DHCBTNote2="icon-nav"
	If DHCBTNote1="foldermenu" Set DHCBTNote2="icon-sys"
	If DHCBTNote1="childmenu" Set DHCBTNote2="icon-nav"
	Set DHCBTParrentNodeDr=$p(InsertInto,"^",5)
	Set DHCBTNewHref=$p(InsertInto,"^",3)
	Set DHCBTClassName=$p(InsertInto,"^",6)
	Set DHCBTMethodName=$p(InsertInto,"^",7)
	Set DHCBTUserClass=""
	Set DHCBTParam=$p(InsertInto,"^",8)
	Set DHCBTParamNum=$p(InsertInto,"^",9)
	
    Kill PLIST
    Set PLIST(2)=DHCBTText
    Set PLIST(3)=DHCBTCode
    Set PLIST(4)=DHCBTHref
    Set PLIST(5)=DHCBTLeaf
    Set PLIST(6)=DHCBTHrefTarget
    Set PLIST(7)=DHCBTUserClass
    Set PLIST(8)=DHCBTNote1
    Set PLIST(9)=DHCBTNote2
    Set PLIST(10)=DHCBTParrentNodeDr
    Set PLIST(11)=DHCBTNewHref
    Set PLIST(12)=DHCBTClassName
    Set PLIST(13)=DHCBTMethodName
    Set PLIST(14)=DHCBTParam
    Set PLIST(15)=DHCBTParamNum

	&sql(INSERT INTO DHC_BillCheckTreeNode Values PLIST())

	Set Myrtn=SQLCODE

    Quit Myrtn
}

ClassMethod UpdateMenu(InsertInto)
{
	Set DHCBTRowid=$p(InsertInto,"^",1)
	s ^TMP("tt")=InsertInto
	Kill PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_BillCheckTreeNode WHERE DHCBT_Rowid=:DHCBTRowid) 	
	Quit:SQLCODE'=0 SQLCODE
    Set OldDHCBTText=PLIST(2)
    Set OldDHCBTCode=PLIST(3)
    Set OldDHCBTHref=PLIST(4)
    Set OldDHCBTLeaf=PLIST(5)
    Set OldDHCBTHrefTarget=PLIST(6)
    Set OldDHCBTUserClass=PLIST(7)
    Set OldDHCBTNote1=PLIST(8)
    Set OldDHCBTNote2=PLIST(9)
    Set OldDHCBTParrentNodeDr=PLIST(10)
    Set OldDHCBTNewHref=PLIST(11)
    Set OldDHCBTClassName=PLIST(12)
    Set OldDHCBTMethodName=PLIST(13)
    Set OldDHCBTParam=PLIST(14)
    Set OldDHCBTParamNum=PLIST(15)
	
	Set DHCBTText=$p(InsertInto,"^",2)
	Set DHCBTCode="MenuTree"
	Set DHCBTHref=$p(InsertInto,"^",3)
	Set DHCBTLeaf="false"
	Set DHCBTHrefTarget="mainFrame"
	Set DHCBTNote1=$p(InsertInto,"^",4)
	Set DHCBTNote2="icon-nav"
	If DHCBTNote1="foldermenu" Set DHCBTNote2="icon-sys"
	If DHCBTNote1="childmenu" Set DHCBTNote2="icon-nav"
	Set DHCBTParrentNodeDr=$p(InsertInto,"^",5)
	Set DHCBTNewHref=$p(InsertInto,"^",3)
	Set DHCBTClassName=$p(InsertInto,"^",6)
	Set DHCBTMethodName=$p(InsertInto,"^",7)
	Set DHCBTUserClass=""
	Set DHCBTParam=$p(InsertInto,"^",8)
	Set DHCBTParamNum=$p(InsertInto,"^",9)

	Set Count=0
	If ((DHCBTText'=OldDHCBTText)!(DHCBTCode'=OldDHCBTCode)!(DHCBTHref'=OldDHCBTHref)) Set Count=Count+1
	If ((DHCBTLeaf'=OldDHCBTLeaf)!(DHCBTHrefTarget'=OldDHCBTHrefTarget)!(DHCBTNote1'=OldDHCBTNote1)) Set Count=Count+1
	If ((DHCBTNote2'=OldDHCBTNote2)!(DHCBTParrentNodeDr'=OldDHCBTParrentNodeDr)!(DHCBTNewHref'=OldDHCBTNewHref)) Set Count=Count+1
	If ((DHCBTClassName'=OldDHCBTClassName)!(DHCBTMethodName'=OldDHCBTMethodName)!(DHCBTUserClass'=OldDHCBTUserClass)) Set Count=Count+1
	If ((OldDHCBTParam'=DHCBTParam)!(OldDHCBTParamNum'=DHCBTParamNum)) Set Count=Count+1
	Quit:Count=0 -1001

    Kill PLIST
    Set PLIST(2)=DHCBTText
    Set PLIST(3)=DHCBTCode
    Set PLIST(4)=DHCBTHref
    Set PLIST(5)=DHCBTLeaf
    Set PLIST(6)=DHCBTHrefTarget
    Set PLIST(7)=DHCBTUserClass
    Set PLIST(8)=DHCBTNote1
    Set PLIST(9)=DHCBTNote2
    Set PLIST(10)=DHCBTParrentNodeDr
    Set PLIST(11)=DHCBTNewHref
    Set PLIST(12)=DHCBTClassName
    Set PLIST(13)=DHCBTMethodName
    Set PLIST(14)=DHCBTParam
    Set PLIST(15)=DHCBTParamNum
    
	&sql(UPDATE DHC_BillCheckTreeNode VALUES :PLIST() WHERE DHCBT_Rowid=:DHCBTRowid)

	Set Myrtn=SQLCODE

    Quit Myrtn
}

ClassMethod DeleteMenu(InsertInto)
{
	Set DHCBTRowid=$p(InsertInto,"^",1)
	
	&sql(DELETE FROM DHC_BillCheckTreeNode WHERE DHCBT_Rowid=:DHCBTRowid)

	Set Myrtn=SQLCODE

    Quit Myrtn
}

ClassMethod tb()
{
	n SQLCODE
	TSTART  s SQLCODE=$zu(34)
	q
}

ClassMethod tc()
{
	n SQLCODE
	TCOMMIT  s SQLCODE=$zu(34)
	q
}

/// 通过Query生成DataGrid列名json串
/// Input	ClassName 类名		QueryName Query名称		ArgCnt 参数个数
/// 			p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16	入参
ClassMethod WriteColumnJsonByQuery(ClassName As %String, QueryName As %String, ArgCnt As %String, p1 = "", p2 = "", p3 = "", p4 = "", p5 = "", p6 = "", p7 = "", p8 = "", p9 = "", p10 = "", p11 = "", p12 = "", p13 = "", p14 = "", p15 = "", p16 = "")
{
	s ^TMP("tt",2)=ClassName_","_QueryName_","_ArgCnt_","_p1_","_p2_","_p3_","_p4_","_p5_","_p6_","_p7_","_p8_","_p9_","_p10_","_p11_","_p12_","_p13_","_p14_","_p15_","_p16
	If ArgCnt="" Set ArgCnt=0
	Set rset=##class(%ResultSet).%New(ClassName_":"_QueryName)
	Set execute="Set %sc=$zobjmethod(rset,""Execute"""
	If +$g(ArgCnt)'=0 Do
	.For i=1:1:ArgCnt Set execute=execute_",.p"_i
	Else  Do
	.Set execute=execute
	Set execute=execute_")"
	Xecute execute
	
	Set OutStr="[]"
	If rset.QueryIsValid() { 
		Set OutStr="["
		Set columns = rset.GetColumnCount()
		For i=1:1:columns  Do
		.If i=1 Set OutStr=OutStr_"{field:"_"'"_rset.GetColumnName(i)_"'"_","
		.Else  Set OutStr=OutStr_",{field:"_"'"_rset.GetColumnName(i)_"'"_","
		.Set OutStr=OutStr_"title:"_"'"_rset.GetColumnName(i)_"'"_","
		.Set OutStr=OutStr_"align:"_"'"_"left"_"'"_","
		.Set OutStr=OutStr_"sortable:"_"'"_"true"_"'"_","
		.If rset.GetColumnName(i)="HJFlag" Do
		..Set OutStr=OutStr_"hidden:"_"'"_"true"_"'"_","
		.Set OutStr=OutStr_"resizable:"_"'"_"true"_"'"_"}"
		
		Set OutStr=OutStr_"]"
	}
	;w "Columns=["_OutStr_"]"
	Quit OutStr
}

}
