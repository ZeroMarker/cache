Class web.DHCEQTools Extends %RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 210;

ClassMethod CreateFind(findname As %String, paras As %String, clsname As %String)
{
	new tmp,gblname
	new rowspec,gblinfo,setdata
	set (rowspec,gblinfo,setdata)=""
	d ..GetROWSPEC(clsname,.rowspec,.gblinfo,.setdata)
	w rowspec,!
	w gblinfo,!
	w setdata,!
	set gblname=##Class(web.DHCEQCommon).Replace(clsname,"_","")
	///生成接口
	set tmp="Query "_findname_"("_paras_") As %Query(ROWSPEC = "_""""_rowspec_""""_")"_$c(13)_$c(10)
	set tmp=tmp_"{"_$c(13)_$c(10)
	set tmp=tmp_"}"_$c(13)_$c(10)
	set tmp=tmp_$c(13)_$c(10)
	///生成执行实体	
	set tmp=tmp_"ClassMethod "_findname_"Execute(ByRef qHandle As %Binary"
	i paras'="" d
	.s tmp=tmp_","_" "_paras
	s tmp=tmp_") As %Status"_$c(13)_$c(10)
	s tmp=tmp_"{"_$c(13)_$c(10)
	
	set tmp=tmp_" 	new repid, index,rowid"_$c(13)_$c(10)
	set tmp=tmp_"	Set repid=$I(^CacheTemp)"_$c(13)_$c(10)
	set tmp=tmp_" 	Set qHandle=$lb(0,repid,0)"_$c(13)_$c(10)
	set tmp=tmp_"	s index=1"_$c(13)_$c(10)
	set tmp=tmp_"	s rowid=0"_$c(13)_$c(10)
	set tmp=tmp_"	d BuildData"_findname_$c(13)_$c(10)
	set tmp=tmp_"	Quit $$$OK"_$c(13)_$c(10)
	
	set tmp=tmp_"BuildData"_findname_$c(13)_$c(10)
	set tmp=tmp_"	f  s rowid=$o(^"_gblname_"(rowid))  quit:rowid="_""""""_"  d"_$c(13)_$c(10)
	set tmp=tmp_"	.d ResetVariables"_findname_$c(13)_$c(10)
	set tmp=tmp_gblinfo
	set tmp=tmp_"	.d OutputRow"_findname_$c(13)_$c(10)
	set tmp=tmp_"	quit"_$c(13)_$c(10)
	
	set tmp=tmp_"OutputRow"_findname_$c(13)_$c(10)
	set tmp=tmp_"	s Data=$lb("_setdata_")"_$c(13)_$c(10)
	set tmp=tmp_"	Set ^CacheTemp(repid,index)=Data"_$c(13)_$c(10)
	set tmp=tmp_"	Set index=index+1"_$c(13)_$c(10)
	set tmp=tmp_"	quit"_$c(13)_$c(10)
	
	set tmp=tmp_"ResetVariables"_findname_$c(13)_$c(10)
	set tmp=tmp_"	s ("_setdata_")="""""_$c(13)_$c(10)
	set tmp=tmp_"	quit"_$c(13)_$c(10)	
	
	
	set tmp=tmp_"}"_$c(13)_$c(10)
	set tmp=tmp_$c(13)_$c(10)
	///生成Fetch
	set tmp=tmp_"ClassMethod "_findname_"Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = "_findname_"Execute ]"_$c(13)_$c(10)
	set tmp=tmp_"{"_$c(13)_$c(10)	
	set tmp=tmp_"	Set AtEnd=$LIST(qHandle,1)"_$c(13)_$c(10)
	set tmp=tmp_" 	Set repid=$LIST(qHandle,2)"_$c(13)_$c(10)
	set tmp=tmp_" 	Set ind=$LIST(qHandle,3)"_$c(13)_$c(10)
	set tmp=tmp_" 	Set ind=$o(^CacheTemp(repid,ind))"_$c(13)_$c(10)
	set tmp=tmp_" 	If ind="""" {"_$c(13)_$c(10)
	set tmp=tmp_" 		Set AtEnd=1"_$c(13)_$c(10)
	set tmp=tmp_" 		Set Row="""""_$c(13)_$c(10)
	set tmp=tmp_" 		}"_$c(13)_$c(10)
	set tmp=tmp_" 	Else      {"_$c(13)_$c(10)
	set tmp=tmp_" 		Set Row=^CacheTemp(repid,ind)"_$c(13)_$c(10)
	set tmp=tmp_" 		}"_$c(13)_$c(10)
	set tmp=tmp_"	s qHandle=$lb(AtEnd,repid,ind)"_$c(13)_$c(10)
	set tmp=tmp_"	Quit $$$OK"_$c(13)_$c(10)
	set tmp=tmp_"}"_$c(13)_$c(10)
	set tmp=tmp_$c(13)_$c(10)
	///生成Close
	set tmp=tmp_"ClassMethod "_findname_"Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = "_findname_"Execute ]"_$c(13)_$c(10)
	set tmp=tmp_"{"_$c(13)_$c(10)	
	set tmp=tmp_"	Set repid=$LIST(qHandle,2)"_$c(13)_$c(10)
	set tmp=tmp_" 	Kill ^CacheTemp(repid)"_$c(13)_$c(10)
	set tmp=tmp_" 	Quit $$$OK"_$c(13)_$c(10)	
	set tmp=tmp_"}"_$c(13)_$c(10)
	set tmp=tmp_$c(13)_$c(10)

	d ##Class(web.DHCEQCommon).WriteFile("D:\Share\cdl\"_clsname_"_"_findname_".cdl",tmp,1)
	Quit tmp
}

ClassMethod GetROWSPEC(clsname As %String, rowspec As %String, gblinfo As %String, setdata As %String)
{
	//new rowspec,tmpdesc,gblinfo
	new tmpdesc
	new rset,sql,fieldname,sort,i
	set rowspec="",tmpdesc="",gblinfo="",setdata=""
	Set rset = ##class(%ResultSet).%New()
	set sql="SELECT TableDesc,SortNO,DataItem,ItemName,ItemType,ItemLength,AllowNull,DefaultValue,Reference,InsideFlag,Remark,IndexInfo FROM sqluser.operationTable WHERE tabledesc= '"_clsname_"'"
	set sort=1
	Do rset.Prepare(sql)
 	Do rset.Execute()
 	While (rset.Next(.sc)) // go to the next row of the result set
     {	    
        If ($SYSTEM.Status.IsOK(sc)) // check if this succeeded without errors
            {
                s fieldname=rset.Data("DataItem") // perform busines logic   
                s fieldname=$p(fieldname,"_",2)
                s fieldname="T"_fieldname
                s rowspec=rowspec_","_fieldname_":%String"
                i (##Class(web.DHCEQCommon).EndWith(fieldname,"RowID")=1)
                {
                	s gblinfo=gblinfo_"	.s "_fieldname_" = rowid"_$c(13)_$c(10)
                	continue
                }
                if (##Class(web.DHCEQCommon).EndWith(fieldname,"Date")=1)
                {
	                s gblinfo=gblinfo_"	.s "_fieldname_" = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^"_##Class(web.DHCEQCommon).Replace(clsname,"_","")_"(rowid)),"_"""^"""_","_sort_"),"_"""date"")"_$c(13)_$c(10)
	            }
                else
                {
                	s gblinfo=gblinfo_"	.s "_fieldname_" = $p($g(^"_##Class(web.DHCEQCommon).Replace(clsname,"_","")_"(rowid)),"_"""^"""_","_sort_")"_$c(13)_$c(10)
                }
                set sort=sort+1
                i (##Class(web.DHCEQCommon).EndWith(fieldname,"DR")=1) d
                .s fieldname=$e(fieldname,1,$l(fieldname)-2)
                .s tmpdesc=tmpdesc_","_fieldname_":%String"                
                .s gblinfo=gblinfo_"	.i "_fieldname_"DR '="""""_"  d"_$c(13)_$c(10)
 				.s gblinfo=gblinfo_"	..s "_fieldname_" = $p($g(^"_##Class(web.DHCEQCommon).Replace(rset.Data("Reference"),"_","")_"("_fieldname_"DR)),"_"""^"""_",XX)"_$c(13)_$c(10)
            }
        Else // if there was an error, break out of the While loop
            {
	            w "err"
                Quit
            }
     }
 	If $SYSTEM.Status.IsError(sc) // if there was an error, process that
     {
     	Quit "err"
     }
    i rowspec'="" d
    .s rowspec=$e(rowspec,2,$l(rowspec))    
    .i tmpdesc'="" d
    ..s rowspec=rowspec_tmpdesc
    .s setdata=##Class(web.DHCEQCommon).Replace(rowspec,":%String","") 
	///Quit rowspec_$c(13)_$c(10)_gblinfo
}

ClassMethod CreatePList(clsname As %String)
{
	new plist,paraname,combindata,sqlfields,sqlvalues
	new rset,sql,fieldname,sort,i
	set plist="",paraname="val",combindata="",sqlfields="",sqlvalues=""
	Set rset = ##class(%ResultSet).%New()
	set sql="SELECT TableDesc,SortNO,DataItem,ItemName,ItemType,ItemLength,AllowNull,DefaultValue,Reference,InsideFlag,Remark,IndexInfo FROM sqluser.operationTable WHERE tabledesc= '"_clsname_"'"
	set sort=1
	Do rset.Prepare(sql)
 	Do rset.Execute()
 	While (rset.Next(.sc)) // go to the next row of the result set
     {	    
        If ($SYSTEM.Status.IsOK(sc)) // check if this succeeded without errors
            {
                s fieldname=rset.Data("DataItem") // perform busines logic   
                s sqlfields=sqlfields_","_fieldname
                s fieldname=$p(fieldname,"_",2)
                
                s plist=plist_" s PLIST("_(sort)_") = "_"$p("_paraname_","_"""^"","_sort_")	;"_fieldname_$c(13)_$c(10)
                if (##Class(web.DHCEQCommon).EndWith(fieldname,"Flag")=1) 
                	{s plist=plist_" i $p("_paraname_","_"""^"","_(sort)_")'="_""""""_"  s PLIST("_(sort)_") = "_"##Class(web.DHCEQCommon).TransValueFromPage($p("_paraname_","_"""^"","_sort_"),"_"""bool"")"_"	;"_fieldname_$c(13)_$c(10)	            }
	            elseif (##Class(web.DHCEQCommon).EndWith(fieldname,"Date")=1)
	            	{s plist=plist_" i $p("_paraname_","_"""^"","_(sort)_")'="_""""""_"  s PLIST("_(sort)_") = "_"##Class(web.DHCEQCommon).TransValueFromPage($p("_paraname_","_"""^"","_sort_"),"_"""date"")"_"	;"_fieldname_$c(13)_$c(10)		        }
                
                s sqlvalues=sqlvalues_",:"_fieldname
                if (##Class(web.DHCEQCommon).EndWith(fieldname,"RowID")=1)
                	{s combindata=combindata_"  	combindata=GetElementValue("_""""_fieldname_""") ;"_$c(13)_$c(10)}
                elseif (##Class(web.DHCEQCommon).EndWith(fieldname,"Flag")=1)
                	{s combindata=combindata_"  	combindata=combindata+"_"""^"""_"+GetChkElementValue("_""""_fieldname_""") ;"_$c(13)_$c(10)}
                else
                	{s combindata=combindata_"  	combindata=combindata+"_"""^"""_"+GetElementValue("_""""_fieldname_""") ;"_$c(13)_$c(10)}
                
                set sort=sort+1
            }
        Else{
	            w "err"
                Quit
            }
     }
 	 If $SYSTEM.Status.IsError(sc){
     	Quit "err"
     }
     s plist=plist_" k PLIST(1)"_$c(13)_$c(10)
     s combindata=" 	var combindata="_""""";"_$c(13)_$c(10)_combindata
     w plist,!
     w combindata,!
     d ##Class(web.DHCEQCommon).WriteFile("D:\Share\cdl\combin"_clsname_".txt",plist_combindata,1)
}

ClassMethod CreateSetData(clsname As %String)
{
	new psetdata,psetpagedata
	new rset,sql,fieldname,sort,i,sortex
	set psetdata="",psetpagedata=""
	Set rset = ##class(%ResultSet).%New()
	set sql="SELECT TableDesc,SortNO,DataItem,ItemName,ItemType,ItemLength,AllowNull,DefaultValue,Reference,InsideFlag,Remark,IndexInfo FROM sqluser.operationTable WHERE tabledesc= '"_clsname_"'"
	set sort=1
	set sortex=0
	s psetdata=psetdata_"	new result,resultex"_$c(13)_$c(10)
	s psetdata=psetdata_"	s (result,resultex)="""""_$c(13)_$c(10)
	s psetdata=psetdata_"	s result= ^XXX(rowid)"_$c(13)_$c(10)	
	
	Do rset.Prepare(sql)
 	Do rset.Execute()
 	While (rset.Next(.sc)) // go to the next row of the result set
     {	    
        If ($SYSTEM.Status.IsOK(sc)) // check if this succeeded without errors
            {
                s fieldname=rset.Data("DataItem") // perform busines logic   
                s fieldname=$p(fieldname,"_",2)                
                
                if (##Class(web.DHCEQCommon).EndWith(fieldname,"RowID")=1)
                { continue }
                elseif (##Class(web.DHCEQCommon).EndWith(fieldname,"Flag")=1) 
                	{s psetdata=psetdata_"	s $p(result,"_"""^"","_(sort)_")="_"##Class(web.DHCEQCommon).TransValueToPage($p(result,"_"""^"","_sort_"),"_"""bool"")"_"	;"_fieldname_$c(13)_$c(10)
                	 s psetpagedata=psetpagedata_"	SetChkElement("""_fieldname_""",list["_(sort-1)_"]);"_$c(13)_$c(10) }
	            elseif (##Class(web.DHCEQCommon).EndWith(fieldname,"Date")=1)
	            	{s psetdata=psetdata_"	s $p(result,"_"""^"","_(sort)_")="_"##Class(web.DHCEQCommon).TransValueToPage($p(result,"_"""^"","_sort_"),"_"""date"")"_"	;"_fieldname_$c(13)_$c(10)
	            	 s psetpagedata=psetpagedata_"	SetElement("""_fieldname_""",list["_(sort-1)_"]);"_$c(13)_$c(10) }
                elseif (##Class(web.DHCEQCommon).EndWith(fieldname,"DR")=1)
                	{
	                	s psetdata=psetdata_"	s resultex=resultex_""^"""_"	;"_fieldname_$c(13)_$c(10)
	                	s psetdata=psetdata_"	i $p(result,"_"""^"","_sort_")'=""""  d"_$c(13)_$c(10)
	                	if (+rset.Data("InsideFlag")=1)
	                	{s psetdata=psetdata_"	.s resultex=resultex_"_"$p($g(^"_##Class(web.DHCEQCommon).Replace(rset.Data("Reference"),"_","")_"($p(result,"_"""^"","_sort_"))),"_"""^"""_",XX)"_$c(13)_$c(10)}
	                	else
	                	{s psetdata=psetdata_"	.s resultex=resultex_"_"##Class(web.DHCEQCommon).GetTrakNameByID(""XXXX"",$p(result,""^"","_sort_"))"_$c(13)_$c(10)}
	                	
	                	s psetpagedata=psetpagedata_"	SetElement("""_fieldname_""",list["_(sort-1)_"]);"_$c(13)_$c(10)
	                	s psetpagedata=psetpagedata_"	SetElement("""_$e(fieldname,1,$l(fieldname)-2)_""",list[sort+"_sortex_"]);"_$c(13)_$c(10)	                	
	                	s sortex=sortex+1
	                }
	             else
	             {    s psetpagedata=psetpagedata_"	SetElement("""_fieldname_""",list["_(sort-1)_"]);"_$c(13)_$c(10)    }
	            set sort=sort+1
            }
        Else // if there was an error, break out of the While loop
            {
	            w "err"
                Quit
            }
     }
 	If $SYSTEM.Status.IsError(sc) // if there was an error, process that
     {
     	Quit "err"
     }
     s psetdata=psetdata_"	q result_resultex"_$c(13)_$c(10)
     s psetpagedata="	var sort="_(sort-1)_$c(13)_$c(10)_psetpagedata
     d ##Class(web.DHCEQCommon).WriteFile("D:\Share\cdl\SetData"_clsname_".txt",psetdata_psetpagedata,1)
}

ClassMethod CreateInit(clsname As %String)
{
	new clears,standardkeyups
	new rset,sql,fieldname,sort
	set clears="",standardkeyups=""
	Set rset = ##class(%ResultSet).%New()
	set sql="SELECT TableDesc,SortNO,DataItem,ItemName,ItemType,ItemLength,AllowNull,DefaultValue,Reference,InsideFlag,Remark,IndexInfo FROM sqluser.operationTable WHERE tabledesc= '"_clsname_"'"
	set sort=1
	
	set standardkeyups="function InitStandardKeyUp()"_$c(13)_$c(10)
	set standardkeyups=standardkeyups_"{"_$c(13)_$c(10)	
	set clears="function Clear()"_$c(13)_$c(10)
	set clears=clears_"{"_$c(13)_$c(10)
	 
	Do rset.Prepare(sql)
 	Do rset.Execute()
 	While (rset.Next(.sc)) {	    
        If ($SYSTEM.Status.IsOK(sc)) {
                s fieldname=rset.Data("DataItem") // perform busines logic   
                s fieldname=$p(fieldname,"_",2)
                i (##Class(web.DHCEQCommon).EndWith(fieldname,"DR")=1)
                {
	                set standardkeyups=standardkeyups_"	var obj=document.getElementById("""_$e(fieldname,1,$l(fieldname)-2)_""");"_$c(13)_$c(10)
	                set standardkeyups=standardkeyups_"	if (obj) obj.onkeyup=Standard_KeyUp;"_$c(13)_$c(10)
	                
	                set clears=clears_"	SetElement("""_$e(fieldname,1,$l(fieldname)-2)_""","""_""");"_$c(13)_$c(10)
	                set clears=clears_"	SetElement("""_fieldname_""","""_""");"_$c(13)_$c(10)
	            }
	            elseif(##Class(web.DHCEQCommon).EndWith(fieldname,"Flag")=1)
                {   set clears=clears_"	SetChkElement("""_fieldname_""",0);"_$c(13)_$c(10)}
	            else
	            {	set clears=clears_"	SetElement("""_fieldname_""","""_""");"_$c(13)_$c(10)}
                set sort=sort+1
            }
        Else{
	            w "err"
                Quit
            }
     }
 	 If $SYSTEM.Status.IsError(sc)     {     	Quit "err"     }
 	 set standardkeyups=standardkeyups_"}"_$c(13)_$c(10)
 	 set clears=clears_"}"_$c(13)_$c(10)
 	 
     d ##Class(web.DHCEQCommon).WriteFile("D:\Share\cdl\CreateInit"_clsname_".txt",standardkeyups_clears,1)
}

ClassMethod GetFieldType(fieldname As %String)
{
	s a="asdf"
	s b=0
	f  s b=b+1 quit:b>8  d
	.s a=a
	.i b=2 
	..s dd="" 
	.q:b=2
	.w a_b,!
}

//生成对于look up 的ID项赋值的函数“^”

ClassMethod CreateGet(val As %Library.String)
{
	s i=$L(val,"^")
	s Return=""
	f j=1:1:i
	{
		s Return=Return_"function Get"_$p(val,"^",j)_" (value)"_$c(13)_$c(10)
		s Return=Return_"{"_$c(13)_$c(10)_"    GetLookUpID("""_$p(val,"^",j)_"DR"_""",value);"_$c(13)_$c(10)
		s Return=Return_"}"_$c(13)_$c(10)
	}
	
	q Return
}

ClassMethod BakMenus(nameprefix As %String, filename)
{
	new rset,sql,MenuName,MenuNames,parmenu
	Set rset = ##class(%ResultSet).%New()
	set sql="SELECT Name FROM websys.Menu WHERE Name like '"_nameprefix_"%'"
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
 		set parmenu=..BakMenu(MenuName) 		
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

ClassMethod BakMenu(menuname As %String)
{
	&SQL(SELECT SubMenuOf->Name,LinkComponent->Name INTO :submenuname,:linkcompname FROM websys.menu
			WHERE Name=:menuname)
	If SQLCODE Quit 1
	Kill ^DHCMenu(menuname)
	KILL PLIST
	&SQL(SELECT * INTO :PLIST() FROM websys.menu Where Name=:menuname)
	m ^DHCMenu(menuname,"Menu")=PLIST
	Set ^DHCMenu(menuname,"ParName")=submenuname
	Set ^DHCMenu(menuname,"ComponentName")=linkcompname
	q submenuname
}

ClassMethod RestoreMenu(menuname As %String)
{
	set parid=""
	&SQL(SELECT * FROM websys.Menu WHERE Name=:menuname)
	If 'SQLCODE Quit SQLCODE
	set parname=^DHCMenu(menuname,"ParName")
	&SQL(SELECT id into :parid FROM websys.Menu WHERE Name=:parname)
	If SQLCODE<0 Quit SQLCODE
	k PLIST
	m PLIST=^DHCMenu(menuname,"Menu")
	KILL PLIST(1)
	KILL PLIST(17)
	s compname=^DHCMenu(menuname,"ComponentName")
	if (compname'="")
	{
		set compid=""		
		&SQL(select id into :compid from websys.component where name = :compname)
		s PLIST(8)=compid		
	}
	if (parid'="")	set PLIST(17)=parid
	&SQL(INSERT INTO websys.menu VALUES :PLIST())
	If SQLCODE Quit SQLCODE
	q $g(%ROWID)
}

ClassMethod RestoreMenus(filename As %String)
{
	If '##class(%File).Exists(filename) q
	new line,parid,errs
	s errs=""
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename=filename
	While 'stream.AtEnd {
		Set line=stream.ReadLine()
		set parid=..RestoreMenu(line)
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

ClassMethod DeleteAndRestoreMenu(menuname As %String)
{
	new menuid
	set parid=""
	&SQL(SELECT id into :menuid FROM websys.Menu WHERE Name=:menuname)
	i menuid>0  d
	.&SQL(delete from websys.Menu where id=:menuid)
	set parname=^DHCMenu(menuname,"ParName")
	&SQL(SELECT id into :parid FROM websys.Menu WHERE Name=:parname)
	If SQLCODE<0 Quit SQLCODE
	k PLIST
	m PLIST=^DHCMenu(menuname,"Menu")
	KILL PLIST(1)
	KILL PLIST(17)
	s compname=^DHCMenu(menuname,"ComponentName")
	if (compname'="")
	{
		set compid=""		
		&SQL(select id into :compid from websys.component where name = :compname)
		s PLIST(8)=compid		
	}
	if (parid'="")	set PLIST(17)=parid
	&SQL(INSERT INTO websys.menu VALUES :PLIST())
	If SQLCODE Quit SQLCODE
	q $g(%ROWID)
}

ClassMethod DeleteAndRestoreMenus(filename As %String)
{
	If '##class(%File).Exists(filename) q
	new line,parid,errs
	s errs=""
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename=filename
	While 'stream.AtEnd {
		Set line=stream.ReadLine()
		set parid=..DeleteAndRestoreMenu(line)
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

ClassMethod UpdateMenu(menuname As %String)
{
	new menuid
	set parid=""
	&SQL(SELECT id into :menuid FROM websys.Menu WHERE Name=:menuname)
	;i menuid>0  d
	;.&SQL(delete from websys.Menu where id=:menuid)
	set parname=^DHCMenu(menuname,"ParName")
	&SQL(SELECT id into :parid FROM websys.Menu WHERE Name=:parname)
	If SQLCODE<0 Quit SQLCODE
	k PLIST
	m PLIST=^DHCMenu(menuname,"Menu")
	KILL PLIST(1)
	KILL PLIST(17)
	s compname=^DHCMenu(menuname,"ComponentName")
	if (compname'="")
	{
		set compid=""		
		&SQL(select id into :compid from websys.component where name = :compname)
		s PLIST(8)=compid		
	}
	if (parid'="")	set PLIST(17)=parid
	i menuid>0
	{&SQL(Update websys.menu VALUES :PLIST() Where id=:menuid)
	}
	else
	{&SQL(INSERT INTO websys.menu VALUES :PLIST())}
	If SQLCODE Quit SQLCODE
	q $g(%ROWID)
}

ClassMethod UpdateMenus(filename As %String)
{
	If '##class(%File).Exists(filename) q
	new line,parid,errs
	s errs=""
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename=filename
	While 'stream.AtEnd {
		Set line=stream.ReadLine()
		if line="" continue
		set parid=..UpdateMenu(line)
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

ClassMethod PutIntoCodeTable()
{
	TSTART
	Set rset = ##class(%ResultSet).%New()
	set sql="SELECT CodeName,ShortDesc,ExtendStandard,NeedItem,IndexInfo,CodeDesc,Remark FROM Sqluser.CodeTable WHERE InsideFlag=1"
	d rset.Prepare(sql)
	d rset.Execute()
	While (rset.Next(.sc))
     {	    
        If ($SYSTEM.Status.IsOK(sc))
            {
                set CodeName=rset.Data("CodeName")
                if ($o(^DHCEQCCodeTable(0,"TableName",CodeName,0))'="") continue
                set ShortDesc=rset.Data("ShortDesc")
                set ExtendStandard=rset.Data("ExtendStandard")
                set NeedItem=rset.Data("NeedItem")
                set Remark=$E(rset.Data("Remark"),1,30)
                set CodeDesc=rset.Data("CodeDesc")
                if $L(NeedItem)>0
                {s NeedItem="2"}
                else
                {s NeedItem="1"}
                &sql(insert into sqluser.DHC_EQCCodeTable set CT_TableName=:CodeName,CT_TableDesc=:CodeDesc,CT_Remark=:Remark,CT_Type=:NeedItem,CT_Hidden='0',CT_ReadOnly='0',CT_PreFix=:ShortDesc)
            }
     }
	TCOMMIT
	q SQLCODE
}

/// clsname 类名，type   类型 0:item  1:tableitem  
ClassMethod CreateComponentItems(clsname, type, componentname)
{
	new rset,sql,name,names,caption
	new hidden,displayonly,valueget,datatype,displaytype
	new name1,hidden1
	
	set componentid=""
	&SQL(Select id into :componentid from websys.component where name =:componentname)
	if componentid=""  
	{	w "No component "
		q	}
	Set rset = ##class(%ResultSet).%New()
	set sql="SELECT * FROM sqluser.operationtable WHERE tabledesc = '"_clsname_"'"
 	Do rset.Prepare(sql)
 	Do rset.Execute()
 	set names=""
	While (rset.Next(.sc)) // go to the next row of the result set
 	{
 		If ($SYSTEM.Status.IsOK(sc)) // check if this succeeded without errors
 		{
 		set name=rset.Data("DataItem")
 		set name=$p(name,"_",2)
 		set names=names_","_name
 		set caption=rset.Data("ItemName")
 		set name1=""
 		set hidden1=0
 		
 		s hidden=0
 		s datatype="%String"
		s displayonly=0
		s displaytype="T"
 		if (##Class(web.DHCEQCommon).EndWith(name,"RowID")=1)
 		{
	 		s hidden=1
	 	}
	 	if (##Class(web.DHCEQCommon).EndWith(name,"DR")=1)
	 	{
		 	s hidden=1
		 	s name1=$e(name,1,$l(name)-2)
		}
	 	if ((##Class(web.DHCEQCommon).EndWith(name,"Num"))||(##Class(web.DHCEQCommon).EndWith(name,"Fee")))
	 	{
		 	s datatype="%Library.Float"
		}
		if (##Class(web.DHCEQCommon).EndWith(name,"Date"))
		{
			s datatype="%Library.Date"
		}		
 		
 		if (type=0)
 			{
	 			if (rset.Data("ItemLength")'=""&rset.Data("ItemLength")>100)
	 			{s displaytype="TA"}
	 			&SQL(Insert Into websys.componentitems(parref,name,caption,displayonly,displaytype,datatype,hidden)
	 					values (:componentid,:name,:caption,:displayonly,:displaytype,:datatype,:hidden)
	 				)
	 			if (name1'="")
	 			{
		 			&SQL(Insert Into websys.componentitems(parref,name,caption,displayonly,displaytype,datatype,hidden)
	 					values (:componentid,:name1,:caption,:displayonly,:displaytype,:datatype,:hidden1)
	 				)
		 		}
	 		}
	 	else
	 		{
		 		s datatype="%String"
		 		s displayonly=1
		 		s displaytype="T"
		 		s name="T"_name
		 		s valueget="s val=rs.GetDataByName("""_name_""")"
		 		&SQL(Insert Into websys.componenttableitems(parref,name,caption,displayonly,displaytype,datatype,hidden,valueget)
	 					values (:componentid,:name,:caption,:displayonly,:displaytype,:datatype,:hidden,:valueget)
	 				)
	 			w "^"_componentid_"^"_name_"^"_caption_"^"_displayonly_"^"_displaytype_"^"_datatype_"^"_hidden_"^"_valueget_"^",!
	 			if (name1'="")
	 			{
		 			s name1="T"_name1
		 			s valueget="s val=rs.GetDataByName("""_name1_""")"
		 			&SQL(Insert Into websys.componenttableitems(parref,name,caption,displayonly,displaytype,datatype,hidden,valueget)
	 					values (:componentid,:name1,:caption,:displayonly,:displaytype,:datatype,:hidden1,:valueget)
	 				)
		 		}
	 		}
 		}
 		Else // if there was an error, break out of the While loop
 		{
	    w "err"
	    Quit
 		}
 	}
 	q names
}

ClassMethod ClearGlobals(filename As %String)
{
	If '##class(%File).Exists(filename) q
	new line,parid,errs
	s errs=""
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename=filename
	While 'stream.AtEnd {
		Set line=stream.ReadLine()
		set result=..ClearGlobal(line)
		w line_","_result,!
		i result<1 {
			s errs=errs_"@"_line_","_result
		}
	}
	if (errs'="")
		{	w "err:"_errs}
	else
		{	w "clear success!"}
}

ClassMethod ClearGlobal(tablename As %String)
{
	new id,sql,rset
	set sql="Delete FROM sqluser."_tablename	
	Set rset = ##class(%ResultSet).%New()
	Do rset.Prepare(sql)
 	Do rset.Execute()
	q 1
}

/// 解析计算表达式
ClassMethod ParseExpression(expression)
{
	new tmp,end,val
	set expression=##Class(web.DHCEQCommon).Replace(expression," ","")
	set val=0
	set tmp=""
	set end=$FIND(expression,")")
	if end>0
	{
		set tmp=$e(expression,1,end-2)
		set tmp=$p(tmp,"(",$l(tmp,"("))
		set val=..Calculate(tmp)
		w "tmp1:"_tmp,!
		w "val:"_val,!
		set tmp=$e(expression,1,end-2-$l(tmp)-1)_val_$e(expression,end,$l(expression))
		w "tmp2:"_tmp,!
		set val=..ParseExpression(tmp)
		//w "val:"_val,!
	}
	else
	{
		set val=..Calculate(expression)
	}
	//w "val:"_val,!
	q val
}

ClassMethod Calculate(expression)
{
	//a+b*c/d-e
	new len,prepos,nextnum,nextoper,val,data,count,c,nextpos,calflag,i
	set len=$l(expression)	
	set prepos=1
	set count=0
	set calflag=0
	set (nextnum,nextope,nextpos)=""
	for i=1:1:len
	{
		set c=$e(expression,i,i)
		if ((c="+")||(c="-"))
		{
			if (calflag=0)
			{
				set data(count)=$e(expression,prepos,i-1)
				set count=count+1
			}
			set calflag=0
			set data(count)=c
			set count=count+1
			set prepos=i+1
		}
		elseif ((c="*")||(c="/"))
		{
			if (calflag=0)
			{
			set data(count)=$e(expression,prepos,i-1)
			set count=count+1
			set prepos=i+1
			}
			else
			{	set calflag=0}
			d ..GetNextNum(expression,i,.nextnum,.nextoper,.nextpos)
			set val=..GetResult(data(count-1),c,nextnum)
			set data(count-1)=val
			set i=nextpos-1
			set prepos=nextpos+1
			set calflag=1			
		}
		elseif((i=len)&(prepos'>len))
		{
			//w "prepos:"_prepos_" len:"_len,!
			set data(count)=$e(expression,prepos,i)
			set count=count+1
		}
	}
	
	set val=data(0)
	w count,!
	//w "data:"_data(0)_" "_data(1)_" "_data(2)_" "_data(3) // _" "_data(4)_" "_data(5)_" "_data(6)_" "_data(7),!
	i count>2
	{
	for i=1:2:count-1
	{
		//w i_" "_count,!
		//w "data(i+1):"_val_" "_data(i)_" "_data(i+1),!
		set val=..GetResult(val,data(i),data(i+1))
	}
	}
	//w "合计"_val,!
	q val
}

ClassMethod CheckPriority(oper1, oper2)
{
	if ((oper1="*")||(oper1="/")) q 1
	if ((oper2="+")||(oper2="-")||(oper2="")) q 1
	q 0
}

ClassMethod GetNextNum(expression, pos, nextnum, nextoper, nextpos)
{
	new len,c,i
	set len=$l(expression)	
	for i=pos+1:1:len
	{
		set c=$e(expression,i,i)
		if ((c="+")||(c="-")||(c="*")||(c="/"))
		{
			set nextnum=$e(expression,pos+1,i-1)
			set nextoper=c
			set nextpos=i
			q
		}
		elseif(i=len)
		{
			set nextnum=$e(expression,pos+1,i)
			set nextoper=""
			set nextpos=i
			q
		}
	}
}

ClassMethod GetResult(num1, oper, num2)
{
	w "计算："_num1_" "_oper_" "_num2,!
	q $CASE(oper,"+":(num1+num2),"-":(num1-num2),"*":(num1*num2),"/":(num1/num2),:0)
}

/// d ##class(web.DHCEQTools).ExportProgressByProject("DHCEQCLS","CDL")
/// 不能导出js文件
/// Type  XML  CDL
ClassMethod ExportProgressByProject(ProjectName, Type)
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
	..d ..ExportOneProgress(FileName,Type)
}

/// 
/// d ##class(web.DHCEQTools).ExportProgressByFileName("d:\classname.txt","XML")
/// 导出cdl的时候只导出cls文件，并且不需要添加后缀
/// 导出xml的时候需要添加添加后缀，不能导出js文件
/// Type  XML  CDL
ClassMethod ExportProgressByFileName(FileName, Type)
{
	If '##class(%File).Exists(FileName) q
	new classname
	s errs=""
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename=FileName
	While 'stream.AtEnd {
		Set classname=stream.ReadLine()
		if classname="" continue
		d ..ExportOneProgress(classname,Type)
		
	}
}

/// 
/// d ##class(web.DHCEQTools).ExportOneProgress("web.DHCEQEquip.cls","XML")
/// d ##class(web.DHCEQTools).ExportOneProgress("trakcare/web/csp/dhceqbuyrequest.csp","XML")
/// d ##class(web.DHCEQTools).ExportOneProgress("web.DHCEQEquip","cdl")
/// 导出cdl的时候只导出cls文件，并且不需要添加后缀
/// 导出xml的时候需要添加添加后缀，不能导出js文件,csp文件需要写明详细的
/// Type  XML  CDL
ClassMethod ExportOneProgress(classname, Type)
{
	new filename,FileNameTemp
	s Type=$ZCVT(Type,"U")
	//根据类型导出文件
	i Type="XML"{
		Set filename="d:\tmp\cdl\"_classname_".xml"
		set sc=$$ExportXMLList^%apiOBJ(.classname,filename,"","","")
		Set FileNameTemp="d:\tmp\cdltemp\"_classname_".xml"
	}
	else
	{
		Set flags=$$$FormatFlag($get(flags))
		Set filename="d:\tmp\cdl\"_classname_".cdl"
		Set sc=$$ExportCDLList^%apiOBJ(classname,filename,flags,"","")
		//If $$$hasflag(flags,$$$flagDISPLAY) Write "  File "_filename,!
		Set FileNameTemp="d:\tmp\cdltemp\"_classname_".cdl"
	}
	//生成用于比较异同的文件
	s FileNameTemp=##Class(web.DHCEQCommon).Replace(FileNameTemp,"/","\")
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

}
