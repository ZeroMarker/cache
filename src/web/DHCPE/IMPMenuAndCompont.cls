Class web.DHCPE.IMPMenuAndCompont Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

// 更新体检基础数据菜单

ClassMethod UpdateBDPMenus(ParentCode)
{
	n (ParentCode)
	s ParentID=$O(^User.BDPMenuI("UniqueCodeIndex"," "_$ZCVT(ParentCode,"U"),""))
	q:ParentID="" ParentCode_"不存在"
	s BMCode=""
	f  s BMCode=$O(^DHCPEBDPMenu(ParentCode,BMCode)) q:BMCode=""  d
	.s BMRowID=$O(^User.BDPMenuI("UniqueCodeIndex"," "_$ZCVT(BMCode,"U"),""))
	.s BMInfo=^DHCPEBDPMenu(ParentCode,BMCode)
	.i BMRowID'="" d
	..s obj=##class(User.BDPMenu).%OpenId(BMRowID)
	.e  d
	..s obj=##class(User.BDPMenu).%New()
	.s obj.Code=$LG(BMInfo,2)
	.s obj.Caption=$LG(BMInfo,3)
	.//d obj.LinkFuntionDRSetObjectId($LG(BMInfo,2))
	.s obj.LinkUrl=$LG(BMInfo,5)
	.s obj.Image=$LG(BMInfo,6)
	.//d obj.MethodSetObjectId($LG(BMInfo,7))
	.s obj.Sequence=$LG(BMInfo,8)
	.s obj.ShortcutKey=$LG(BMInfo,9)
	.s obj.ShowInNewWindow=$LG(BMInfo,10)
	.d obj.ParentMenuDrSetObjectId(ParentID)
	.s obj.UpdateDate=+$H
	.s obj.UpdateTime=$P($H,",",2)
	.d obj.UpdateUserSetObjectId(1)
	.//d obj.ValueExpressionSetObjectId($LG(BMInfo,15))
	.s obj.ActiveFlag=$LG(BMInfo,16)
	.s obj.CompName=$LG(BMInfo,17)
	.d obj.ProductLineDrSetObjectId($LG(BMInfo,18))
	.s obj.FirstPYCODE=$LG(BMInfo,19)
	.s obj.WholePYCODE=$LG(BMInfo,20)
	.s obj.IsMKBMenu=$LG(BMInfo,21)
	.d obj.%Save()
	.d ..UpdateBDPMenus(BMCode)
}

// 备份体检基础数据菜单

ClassMethod ExportPEBDPMenu(ParentCode, BMCode, KillFlag As %String = "1")
{
	n (ParentCode, BMCode,KillFlag)
	k:KillFlag="1" ^DHCPEBDPMenu
	s BMCodeU=" "_$ZCVT(BMCode,"U")
	s BMRowId=$O(^User.BDPMenuI("UniqueCodeIndex",BMCodeU,""))
	Q:BMRowId="" "-1^"_BMCode
	s ^DHCPEBDPMenu(ParentCode,BMCode)=^User.BDPMenuD(BMRowId)
	s Sequence=""  
	f  s Sequence=$O(^User.BDPMenuI("ParSeqIdx",BMRowId,Sequence))  q:Sequence=""  d
	.s ID=""  
	.f  s ID=$O(^User.BDPMenuI("ParSeqIdx",BMRowId,Sequence,ID))  q:ID=""  d
	..s IDCode=$LG(^User.BDPMenuD(ID),2)
	..s ^DHCPEBDPMenu(BMCode,IDCode)=^User.BDPMenuD(ID)
	..d ..ExportPEBDPMenu(BMCode,IDCode,0)
	
	q 0
}

ClassMethod BackPEMenu(filename)
{
	;d ##class(web.DHCPE.IMPMenuAndCompont).BackPEMenu("D:/DHCPE/")
	Kill ^DHCPEMenu
	s filename=..Replace(filename,"\","/")
 	s filename=filename_"Menu/"
 	s flag=..CreateDirectory(filename)
	//体检顶菜单
	d ##class(web.DHCPE.IMPMenuAndCompont).BakMenuBySubMenuOfName("DHCPE.Main.Hearder",filename)
	
	//医生站
	d ##class(web.DHCPE.IMPMenuAndCompont).BakMenuBySubMenuOfName("DHC.Outpatient.Doctor.Header",filename)
	//q
	//体检收费管理
	d ##class(web.DHCPE.IMPMenuAndCompont).BakMenuBySubMenuOfName("DHCPE.CashierManager",filename)
	//预约审核修改
	d ##class(web.DHCPE.IMPMenuAndCompont).BakMenuBySubMenuOfName("system.DHCPEPreAuditModify",filename)
	//个人信息处理
	d ##class(web.DHCPE.IMPMenuAndCompont).BakMenuBySubMenuOfName("system.DHCPEMenu.ITakeIn",filename)
	//科室小结
	d ##class(web.DHCPE.IMPMenuAndCompont).BakMenuBySubMenuOfName("system.DHCPEStationS",filename)
}

/// d ##class(web.DHCPE.IMPMenuAndCompont).BakMenuBySubMenuOfName("DHCPE.Main.Hearder","/tmp/DHCPE/")
/// d ##class(web.DHCPE.IMPMenuAndCompont).BakMenuBySubMenuOfName("system.DHCPEPreAuditModify","/tmp/DHCPE/")
/// d ##class(web.DHCPE.IMPMenuAndCompont).BakMenuBySubMenuOfName("system.DHCPEMenu.ITakeIn","/tmp/DHCPE/")
/// d ##class(web.DHCPE.IMPMenuAndCompont).BakMenuBySubMenuOfName("system.DHCPEStationS","/tmp/DHCPE/")
/// d ##class(web.DHCPE.IMPMenuAndCompont).BakMenuBySubMenuOfName("DHCPE.Cashier.CardManager","D:/yyyy/")
ClassMethod BakMenuBySubMenuOfName(SubMenuName, filename)
{
	n (SubMenuName,filename)
	d ..BakMenuByName(SubMenuName,filename)
	w SubMenuName,!
 	s SubName=$ZCVT(SubMenuName,"U")
	s id=0
	s id=+$o(^websys.MenuI("UniqueNameIndex"," "_SubName,0))
	s MenuID=0
	f  s MenuID=$O(^websys.MenuI("SubMenuOf1",id,MenuID)) q:MenuID=""  d
	.s MenuName2=$LG(^websys.MenuD(MenuID),4)
	.d ..BakMenuBySubMenuOfName(MenuName2,filename)
}

ClassMethod BakMenuByName(MenuName, filename)
{
	n (MenuName,filename)
	q:MenuName'[("DHCPE")
			set parmenu=##class(web.DHCPE.Menu).GetMenuByName(MenuName)
 			s i=$I(^DHCPEMenu)
 			m ^DHCPEMenu(i,MenuName)=^DHCPEMenu(MenuName)
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
 			k ^DHCPEMenu(MenuName)
 			Do f.Close()
}

ClassMethod UpdateOtherInfo()
{
	&sql(update Sqluser.DHC_PE_ExpertDiagnosis set ED_HighRisk='N')
	s MaxEDID=$O(^DHCPEED(""),-1)
	s ^DHCPESetting("DHCPE","DefaultEDID")=MaxEDID
}

/// 更新菜单
/// d ##class(web.DHCPE.IMPMenuAndCompont).UpdateMenus("D:\DHCPE\")
ClassMethod UpdateMenus(filename As %String = "")
{
	d ..UpdateOtherInfo()
	i filename=""{
		s i=0
		f  s i=$O(^DHCPEMenu(i)) q:i=""  d
		.s MenuName=""
		.f  s MenuName=$O(^DHCPEMenu(i,MenuName)) q:MenuName=""  d
		..m ^DHCPEMenu(MenuName)=^DHCPEMenu(i,MenuName)
		..s ^DHCPEMenu(MenuName,"Menu","UpdateUser")=""
		..Set MenuID=##class(web.DHCPE.Menu).ImportMenuByName(MenuName)
		..k ^DHCPEMenu(MenuName)
		..w MenuName,!
		&SQL(update websys.menu set Type='ComponentMenu' where name like 'system.DHCPE%')
		q
	}
	s filename=..Replace(filename,"\","/")
	s filename=filename_"Menu/"
	s Menutext=filename_"DHCPEMenu.txt"
	b ;Menutext
	If '##class(%File).Exists(Menutext) q "File Not Found"
	new line,MenuID,errs
	s errs=""
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename=Menutext
	While 'stream.AtEnd {
		Set MenuName=stream.ReadLine()
		if MenuName="" continue
		s st=##class(%FileCharacterStream).%New()
		s st.Filename=filename_MenuName_".txt"
		b ;st.Filename
		while 'st.AtEnd{
			s text=st.ReadLine()
			i text="" continue
			s aa=text,@aa
		}
		s MenuName=$P(MenuName,".txt",1)
		d ReturnMenuStr(MenuName)
		Set MenuID=##class(web.DHCPE.Menu).ImportMenuByName(MenuName)
		;w MenuName_MenuID,!
		
	}
	&SQL(update websys.menu set Type='ComponentMenu' where name like 'system.DHCPE%')
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

/// 备份组件
/// d ##class(web.DHCPE.IMPMenuAndCompont).BakComponent("DHCRisWardNurseQuery","D:\")
/// d ##class(web.DHCPE.IMPMenuAndCompont).BakComponent("DHCPE","d:/DHCPE/")
ClassMethod BakComponent(ComponentNamePrefix As %String, filename)
{
	/*
	new rset,sql,ComponentName,ComponentNames,ComponentID
	Set rset = ##class(%ResultSet).%New()
	set sql="SELECT Name FROM websys.Component WHERE Name like '"_ComponentNamePrefix_"%' and LastUpdateDate > 63004" 
 	Do rset.Prepare(sql)
 	Do rset.Execute()
 	set ComponentNames=""
 	s filename=..Replace(filename,"\","/")
 	s filename=filename_"Component/"
 	s flag=..CreateDirectory(filename)
	set f=##class(%File).%New(filename_"Component.txt")
	Do f.Open("WSN")
 	;k ^DHCPEComponent
 	While (rset.Next(.sc)) // go to the next row of the result set
 	{
 		If ($SYSTEM.Status.IsOK(sc)) // check if this succeeded without errors
 		{
 			set ComponentName=rset.Data("Name")
 			continue:ComponentName'[ComponentNamePrefix
 			w ComponentName,!
 			Set file=##class(%File).%New(filename_ComponentName_".txt")
			Do file.Open("WSN")
 			d ##Class(web.Util.UtilService).GetExportComponents(ComponentName,filename_ComponentName_"/")
 			continue
 			s ID=##class(web.DHCPE.Component).GetComponentByName(ComponentName)
 			//w $G(^DHCPEComponent(ComponentName,"Component","ID"))
 			s Node1=""
 			f  s Node1=$o(^DHCPEComponent(ComponentName,Node1)) q:Node1=""  d
 			.s text=$G(^DHCPEComponent(ComponentName,Node1))
 			.s text=..Remove(text)
 			.s Flag=0
 			.i text'="" s Flag=1
 			.s text="^DHCPEComponent("_""""_ComponentName_""""_","_""""_Node1_""""_")="_""""_text_""""
 			.i ($o(^DHCPEComponent(ComponentName,Node1,""))="")||(Flag=1) Do file.WriteLine(text)
 			.s Node2=""
 			.f  s Node2=$o(^DHCPEComponent(ComponentName,Node1,Node2)) q:Node2=""  d
 			..s text=$G(^DHCPEComponent(ComponentName,Node1,Node2))
 			..s text=..Remove(text)
 			..s Flag=0
 			..i text'="" s Flag=1
 			..s text="^DHCPEComponent("_""""_ComponentName_""""_","_""""_Node1_""""_","_""""_Node2_""""_")="_""""_text_""""
 			..i ($o(^DHCPEComponent(ComponentName,Node1,Node2,""))="")||(Flag=1) Do file.WriteLine(text)
 			..s Node3=""
 			..f  s Node3=$o(^DHCPEComponent(ComponentName,Node1,Node2,Node3)) q:Node3=""  d
 			...s text=$G(^DHCPEComponent(ComponentName,Node1,Node2,Node3))
 			...s text=..Remove(text)
 			...s Flag=0
 			...i text'="" s Flag=1
 			
 			...s text="^DHCPEComponent("_""""_ComponentName_""""_","_""""_Node1_""""_","_""""_Node2_""""_","_""""_Node3_""""_")="_""""_text_""""
 			...i ($o(^DHCPEComponent(ComponentName,Node1,Node2,Node3,""))="")||(Flag=1) Do file.WriteLine(text)
 			...s Node4=""
 			...f  s Node4=$o(^DHCPEComponent(ComponentName,Node1,Node2,Node3,Node4)) q:Node4=""  d
 			....s text=$G(^DHCPEComponent(ComponentName,Node1,Node2,Node3,Node4))
 			....s text=..Remove(text)
 			....s text="^DHCPEComponent("_""""_ComponentName_""""_","_""""_Node1_""""_","_""""_Node2_""""_","_""""_Node3_""""_","_""""_Node4_""""_")="_""""_text_""""
 			....Do file.WriteLine(text)
 			Do f.WriteLine(ComponentName)
 			Do file.Close()
 			
 		}
 		Else // if there was an error, break out of the While loop
 		{
	        w "err"
	        
 			Quit
 		}
 	}
 	//k ^DHCPEComponent
	If $SYSTEM.Status.IsError(sc) // if there was an error, process that
 	{
 		Kill ^DHCPEComponent(ComponentName)
 	}   
	Do f.Close()
	Quit "Export Over"
	
	
	*/
	
	new rset,sql,ComponentName,ComponentNames,ComponentID
	Set rset = ##class(%ResultSet).%New()
	set sql="SELECT Name FROM websys.Component WHERE Name like '"_ComponentNamePrefix_"%' and LastUpdateDate > 63004" 
 	Do rset.Prepare(sql)
 	Do rset.Execute()
 	set ComponentNames=""
 	s filename=..Replace(filename,"\","/")
 	s filename=filename_"Component/"
 	s flag=..CreateDirectory(filename)
	set f=##class(%File).%New(filename_"Component.txt")
	Do f.Open("WSN")
	k ^DHCPEComponent
 	While (rset.Next(.sc)) // go to the next row of the result set
 	{
 		If ($SYSTEM.Status.IsOK(sc)) // check if this succeeded without errors
 		{
 			set ComponentName=rset.Data("Name")
 			continue:ComponentName'[ComponentNamePrefix
 			Do f.WriteLine(ComponentName)
 			w "ComponentName:"_ComponentName,!
 			s ID=##class(web.DHCPE.Component).GetComponentByName(ComponentName)
 			s flag=..CreateDirectory(filename_ComponentName_"/")
 			d ##Class(web.Util.UtilService).GetExportComponents(ComponentName,filename_ComponentName_"/")
 			
 		}
 		Else // if there was an error, break out of the While loop
 		{
	        w "err"
	        
 			Quit
 		}
 	}
 	//k ^DHCPEComponent
	If $SYSTEM.Status.IsError(sc) // if there was an error, process that
 	{
 		Kill ^DHCPEComponent(ComponentName)
 	}   
	Do f.Close()
	Quit "Export Over"
	;
}

/// 去掉 "  '  $C(13)  $C(10)  等符号
ClassMethod Remove(text)
{
	s text=..Replace(text,"""","$C(1)")
 	s text=..Replace(text,"'","$C(2)")
 	s text=..Replace(text,$C(13),"$C(13)")
 	s text=..Replace(text,$C(10),"$C(10)")
 	q text
}

/// 恢复 "  '  $C(13)  $C(10)  等符号
ClassMethod ReturnStr(text)
{
	s text=..Replace(text,"$C(10)",$C(10))
 	s text=..Replace(text,"$C(13)",$C(13))
 	s text=..Replace(text,"$C(2)","'")
 	s text=..Replace(text,"$C(1)","""")
 	q text
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

/// 更新组件
/// d ##class(web.DHCPE.IMPMenuAndCompont).UpdateComponents("/tmp/DHCPE/")
/// d ##class(web.DHCPE.IMPMenuAndCompont).UpdateComponents("D:\DHCPE\")
ClassMethod UpdateComponents(filename As %String = "")
{
	i filename=""
	{
	s line=""
	f  s line=$O(^DHCPEComponent(line)) q:line=""  d
	.q:"DHCPerState"=line
	.Set ComponentID=##class(web.DHCPE.Component).ImportComponentByName(line)
	.w line_ComponentID,!
	q
	}
	s filename=..Replace(filename,"\","/")
	s filename=filename_"Component/"
	s Componenttext=filename_"Component.txt"
	If '##class(%File).Exists(Componenttext) q "File Not Found"
	new line,ComponentID,errs
	k ^TempDHCPEComponent("Comp")
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename=Componenttext
	While 'stream.AtEnd {
		Set line=stream.ReadLine()
		if line="" continue
		s XMLName=filename_line_"/"_line_".xml"
		s ^TempDHCPEComponent("Comp",line)=XMLName
	}
	s Comi=""
	f  s Comi=$O(^TempDHCPEComponent("Comp",Comi)) q:Comi=""  d
	.s XMLName=$P(^TempDHCPEComponent("Comp",Comi),"^",1)
	.d ##Class(web.Util.UtilService).PutComponent(XMLName,"True")
	
	k ^TempDHCPEComponent("Comp")
	d ..UpdateResultComponent()
	q "OVER"
}

/// 更新体检医生站组件里面潜套的组件
/// d ##class(web.DHCPE.IMPMenuAndCompont).UpdateResultComponent()
ClassMethod UpdateResultComponent()
{
	s id=""
	&SQL(select id into :id from websys.component where name = 'DHCPEResultItemEdit')
	q:id=""
	&SQL(update  websys.componenttableitems set nestedcomponent=:id where parref->name = 'DHCPE.Station.ResultEdit'  and name='Select')
	q:SQLCODE'=0
	s id=""
	&SQL(select id into :id from websys.component where name = 'DHCPERisResultItemEdit')
	q:id=""
	&SQL(update  websys.componenttableitems set nestedcomponent=:id where parref->name = 'DHCPERis.Station.ResultEdit'  and name='Select')
}

/// 字符串替换函数
ClassMethod Replace(Strings, Str, Rep) As %String [ Language = basic ]
{
	return Replace(Strings,Str,Rep)
}

/// Add by wrz
/// d ##class(web.DHCPE.IMPMenuAndCompont).ExportProgressByProject("DHCPE","XML","/tmp/DHCPE/")
/// 不能导出js文件
/// Type  XML  CDL
ClassMethod ExportProgressByProject(ProjectName, Type, filename)
{
	new ItemName,PType,FileName
	s Type=$ZCVT(Type,"U")
	s ItemName=""
	f  s ItemName=$o(^oddPROJECT(ProjectName,"Items",ItemName)) q:ItemName=""  d
	.//w ItemName,!
	.//q
	.q:$l(ItemName,"/scripts/")>1
	.s PType="" 
	.f  s PType=$o(^oddPROJECT(ProjectName,"Items",ItemName,PType)) q:PType=""  d
	..q:(PType'="CLS")&&(Type'="XML")
	..i (PType="CLS")&&(Type="XML") d
	...s FileName=ItemName_".cls"
	..e  d
	...s FileName=ItemName
	..w FileName,!
	..d ..ExportOneProgress(FileName,Type,filename)
}

/// Add by wrz
/// d ##class(web.DHCPE.IMPMenuAndCompont).ExportOneProgress("web.DHCPE.BarPrint.cls","XML")
/// d ##class(web.DHCPE.IMPMenuAndCompont).ExportOneProgress("trakcare/web/csp/dhcpeireport.normal.cover.csp","XML")
/// d ##class(web.DHCPE.IMPMenuAndCompont).ExportOneProgress("web.DHCPE.BarPrint","cdl")
/// 导出cdl的时候只导出cls文件，并且不需要添加后缀
/// 导出xml的时候需要添加添加后缀，不能导出js文件,csp文件需要写明详细的
/// Type  XML  CDL
ClassMethod ExportOneProgress(classname, Type, filename)
{
	new (filename,classname,Type)
	s filename=..Replace(filename,"\","/")
	s filenametemp=filename_"Progress/clstemp/"
	s flag=..CreateDirectory(filenametemp)
	s filename=filename_"Progress/cls/"
	s flag=..CreateDirectory(filename)
	s Type=$ZCVT(Type,"U")
	//根据类型导出文件
	i Type="XML"{
		Set filename=filename_classname_".xml"
		Set FileNameTemp=filenametemp_classname_".xml"
		set sc=$$ExportXMLList^%apiOBJ(.classname,filename,"","","")
		
	}
	else
	{
		Set flags=$$$FormatFlag($get(flags))
		Set filename=filename_classname_".cdl"
		Set sc=$$ExportCDLList^%apiOBJ(classname,filename,flags,"","")
		//If $$$hasflag(flags,$$$flagDISPLAY) Write "  File "_filename,!
		Set FileNameTemp=filenametemp_classname_".cdl"
	}
	//生成用于比较异同的文件
	//s FileNameTemp=..Replace(FileNameTemp,"\","/")
	Set streamtemp=##class(%FileCharacterStream).%New()
	Set streamtemp.Filename=filename
	
	
	Set file=##class(%File).%New(FileNameTemp)
	Do file.Open("WSN")
	While 'streamtemp.AtEnd {
		s temp=streamtemp.ReadLine()
		i Type="XML" d
		.i (temp["<Checksum value=")||(temp["<Export generator=")||(temp["<Default>")||(temp["<TimeChanged>")||(temp["<TimeCreated>")  d
		..s temp=""
		e  d
		.i (temp["Date:")||(temp["parameter BUILD") d
		..s temp=""
		d file.WriteLine(temp)
	}
	Do file.Close()
}

/// 备份程序 13801019331  
/// d ##class(web.DHCPE.IMPMenuAndCompont).Export("d:/DHCPE/")
ClassMethod Export(DirName As %String = "D:/DHCPE/", Project As %String = "DHCPEAllCls", ExportType As %String = "XML", CompPrefix As %String = "DHCPE", MenuPrefix As %String = "System.DHCPE")
{
	//导类文件
	//d ##class(web.DHCPE.IMPMenuAndCompont).ExportProgressByProject(Project,ExportType,DirName)
	//w "Class Export Over",!
	//导组件
	//d ##class(web.DHCPE.IMPMenuAndCompont).BakComponent(CompPrefix,DirName)
	//w "Component Export Over",!
	//导菜单
	d ##class(web.DHCPE.IMPMenuAndCompont).BakMenu(MenuPrefix,DirName)
	w "Menu Export Over",!
	
	//d ..CreateDirectory(DirName_"JS/")
	//d ..CreateDirectory(DirName_"CSP/")
	//d ..CreateDirectory(DirName_"Image/")
	//d ..CreateDirectory(DirName_"Templates/")
	//d ..CreateDirectory(DirName_"MedSrc/")
	//d ..CreateDirectory(DirName_"xmlAndDll/")
	//导基础数据
	//s DirName=DirName_"DHCPEData/"
	//d ##class(web.DHCPE.ExportData).ExportData(DirName)
	w "All Export OVER"
}

/// 恢复程序
/// d ##class(web.DHCPE.IMPMenuAndCompont).Import("d:/DHCPE/")
ClassMethod Import(DirName)
{
	//首先Studio下导入程序
	//恢复组件
	d ##class(web.DHCPE.IMPMenuAndCompont).UpdateComponents(DirName)
	w "Component Import Over",!
	//恢复菜单
	d ##class(web.DHCPE.IMPMenuAndCompont).UpdateMenus(DirName)
	w "Menu Import Over",!
	//恢复基础数据
	s DirName=DirName_"DHCPEData/"
	//d ##class(web.DHCPE.ExportData).ImportData(DirName)
	w "Data Import Over",!
}

Storage Default
{
<Data name="IMPMenuAndCompontDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCP.IMPMenuAndCompontD</DataLocation>
<DefaultData>IMPMenuAndCompontDefaultData</DefaultData>
<IdLocation>^web.DHCP.IMPMenuAndCompontD</IdLocation>
<IndexLocation>^web.DHCP.IMPMenuAndCompontI</IndexLocation>
<StreamLocation>^web.DHCP.IMPMenuAndCompontS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
