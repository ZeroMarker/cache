Class web.DHCMedLoadComponent Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 102;

/// w ##class(web.DHCMedLoadComponent).DownLoadComps("DHCMed","d:\Comp.txt","P5","P5")
ClassMethod DownLoadComps(nameprefix, filename, VFrom, VTo)
{
	set rset = ##class(%ResultSet).%New()
	set sql="select Name ,* from websys.Component where Name like '"_nameprefix_"%'"_" order by Id"
 	Do rset.Prepare(sql)
 	Do rset.Execute()
 	
 	set CompName=""
 	
 	set count=1
 	set file=##class(%File).%New(filename)
	Do file.Open("WSN")
	
	While (rset.Next(.sc)) // go to the next row of the result set
 	{
 		If ($SYSTEM.Status.IsOK(sc)) // check if this succeeded without errors
 		{
 		    set CompName=rset.Data("Name") // perform busines logic
 		    
 		    Do file.WriteLine(CompName)
 		    Kill ^DHCMedComponent(CompName)
 		    Set Ret=..DownLoadComp(CompName, VFrom, VTo)
 		    w "  Ret="_Ret
 		    //set ret=(MenuName)
 		    //w CompNames,!
 		}
 		Else // if there was an error, break out of the While loop
 		{
	        w "   err"
	        Do file.Close()
 		    Quit
 		}
	 	set count=count+1
 	}
 	If $SYSTEM.Status.IsError(sc) // if there was an error, process that
 	{
 	    Kill ^DHCMedComponent(CompName)
 	}
 	Do file.Close()
 	w !!!
	Quit "OK"
}

/// w ##class(web.DHCMedLoadComponent).DownLoadComp("DHCMed","P5","P5")
ClassMethod DownLoadComp(CompName, VFrom, VTo)
{
	w !!,CompName_"....."
 	if (VFrom="P5")&(VTo="P5"){
	 	Set Ret=##class(web.DHCMedLoadCompMac).GetComponentP5(CompName)
	 	}
 	if (VFrom="P5")&(VTo="P7"){
	 	Set Ret=##class(web.DHCMedLoadCompMac).GetComponentP5P7(CompName)
	 	}
 	if (VFrom="P7")&(VTo="P5"){
	 	 Set Ret=##class(web.DHCMedLoadCompMac).GetComponentP7P5(CompName)
	 	}
 	if (VFrom="P7")&(VTo="P7"){
	 	Set Ret=##class(web.DHCMedLoadCompMac).GetComponentP7(CompName)
	    }
 	//if (VFrom="P7")&(VTo="P8"){
	// 	Set Ret=##class(web.DHCMedLoadCompMac).GetComponentP7P8(CompName)
	//    }
 	if (VFrom="P8")&(VTo="P5"){
	 	Set Ret=##class(web.DHCMedLoadCompMac).GetComponentP8P5(CompName)
	    }
 	if (VFrom="P8")&(VTo="P7"){
	 	Set Ret=##class(web.DHCMedLoadCompMac).GetComponentP8P7(CompName)
	    }
 	//if (VFrom="P8")&(VTo="P8"){
	// 	Set Ret=##class(web.DHCMedLoadCompMac).GetComponentP8(CompName)
	//    }
	quit Ret
}

/// w ##class(web.DHCMedLoadComponent).UpLoadComps("d:\Comp.txt","P5","P5")
ClassMethod UpLoadComps(filename, VFrom, VTo)
{
	If '##class(%File).Exists(filename) q
	new line,parid,errs
	s errs=""
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename=filename
	While 'stream.AtEnd {
		Set CompName=stream.ReadLine()
		Set Ret=..UpLoadComp(CompName, VFrom, VTo)
 		w "  Ret="_Ret
		
	}
   w !!!
   Quit "OK"
}

/// w ##class(web.DHCMedLoadComponent).UpLoadComp("DHCMed","P7","P5")
ClassMethod UpLoadComp(CompName, VFrom, VTo)
{
	w !!,CompName_"..."
	if (VFrom="P5")&(VTo="P5"){
	    Set Ret=##class(web.DHCMedLoadCompMac).PutComponentP5(CompName)
		}
	if (VFrom="P7")&(VTo="P5"){
		Set Ret=##class(web.DHCMedLoadCompMac).PutComponentP7P5(CompName)
		}
 	if (VFrom="P7")&(VTo="P7"){
	     Set Ret=##class(web.DHCMedLoadCompMac).PutComponentP7(CompName)
	     }
 	if (VFrom="P7")&(VTo="P8"){
	    Set Ret=##class(web.DHCMedLoadCompMac).PutComponentP8(CompName)
	    }
	quit Ret
}

/// w ##class(web.DHCMedLoadComponent).CopyComponent("DHCMedEpdReportList","DHCMedInfReportQry")
ClassMethod CopyComponent(CompFrom, CompTo)
{
	&SQL(SELECT ID INTO :ComponentId FROM websys.Component 
			WHERE Name=:CompFrom)
	If (ComponentId="") Quit -100   ;No CompFrom
	
	&SQL(SELECT * FROM websys.Component WHERE Name=:CompTo)
	;If 'SQLCODE Quit -101    ;Have CompTo
	If 'SQLCODE d
	.&SQL(DELETE FROM websys.Component WHERE Name=:CompTo)
	.w !,"Delete "_CompTo_" SQLCODE="_SQLCODE
	KILL PLIST
	
	KILL PLIST
	;Get Comp
	&SQL(SELECT * INTO :PLIST() FROM websys.Component Where ID=:ComponentId)
	KILL PLIST(1)
	Set PLIST(33)=CompTo
	;Set Comp
	&SQL(INSERT INTO websys.Component VALUES :PLIST())
	w !,"1  INSERT Comp ="_SQLCODE
	Set ID=$g(%ROWID)
	Quit:ID="" SQLCODE
	
	;Get LayOut
	Set LayOut=##Class(websys.Preferences).GetData("SITE","DHCJST","LAYOUT",ComponentId)
	Set LayOut=$LIST(LayOut,1) 
	Set LayOut=$TR(LayOut,ComponentId,ID)
	;m ^DHCMedComponent(ComponentName,"LAYOUT")=LayOut
	;Set LayOut
	
	&SQL(Update websys.Component Set Template=:LayOut WHERE ID=:ID)
	w !,"1.1 Update LAYOUT ="_SQLCODE
	
	;Get  ComponentItems
	Kill PLIST
	Kill ^DHCMedComponent
	&SQL(DECLARE CompItems CURSOR FOR 
				SELECT * INTO :PLIST() FROM websys.ComponentItems 
				Where ParRef=:ComponentId)
	&SQL(OPEN CompItems)
	Set Items=1
	For  &SQL(FETCH CompItems) Quit:SQLCODE  Do
	.m ^DHCMedComponent(Items)=PLIST
	.;&SQL(INSERT INTO websys.ComponentItems VALUES :PLIST())
	.;w !,"2  INSERT ComponentItems,Index="_Items_" SQLCODE="_SQLCODE
	.Set Items=Items+1
	&SQL(CLOSE CompItems)
	
	;Set  ComponentItems
	Set Items=0
	f  Set Items=$o(^DHCMedComponent(Items)) Quit:Items=""  Do
	.KILL PLIST
	.m PLIST=^DHCMedComponent(Items)
	.Set PLIST(0)=ID
	.KILL PLIST(1)
	.KILL PLIST(60)    //ComponentItems.ChildSub  不同版本需要修改此值
	.&SQL(INSERT INTO websys.ComponentItems VALUES :PLIST())
	.w !,"2  INSERT ComponentItems,Index="_Items_" SQLCODE="_SQLCODE
		
	;Get ComponentTableItems
	Kill PLIST
	Kill ^DHCMedComponent
	&SQL(DECLARE CompTable CURSOR FOR 
				SELECT * INTO :PLIST() FROM websys.ComponentTableItems 
				Where ParRef=:ComponentId)
	&SQL(OPEN CompTable)
	Set Items=1
	For  &SQL(FETCH CompTable) Quit:SQLCODE  Do
	.;Set ComponentTableItems
	.m ^DHCMedComponent(Items)=PLIST
	.Set Items=Items+1
	&SQL(CLOSE CompTable)
	
	;Set  ComponentTableItems
	Set Items=0
	f  Set Items=$o(^DHCMedComponent(Items)) Quit:Items=""  Do
	.KILL PLIST
	.m PLIST=^DHCMedComponent(Items)
	.Set PLIST(0)=ID
	.KILL PLIST(1)
	.KILL PLIST(60)  //ComponentTableItems.ChildSub  不同版本需要修改此值
	.&SQL(INSERT INTO websys.ComponentTableItems VALUES :PLIST())
	.w !,"3  INSERT ComponentTableItems,Index="_Items_" SQLCODE="_SQLCODE
	
	
	;Get ComponentMessages
	Kill PLIST
	Kill ^DHCMedComponent
	&SQL(DECLARE CompMessage CURSOR FOR 
				SELECT * INTO :PLIST() FROM websys.ComponentMessages 
				Where ParRef=:ComponentId)
	&SQL(OPEN CompMessage)
	Set Items=1
	For  &SQL(FETCH CompMessage) Quit:SQLCODE  Do
	.m ^DHCMedComponent(Items)=PLIST
	.Set Items=Items+1
	&SQL(CLOSE CompMessage)
	
	;Set  ComponentMessages
	Set Items=0
	f  Set Items=$o(^DHCMedComponent(Items)) Quit:Items=""  Do
	.KILL PLIST
	.m PLIST=^DHCMedComponent(Items)
	.Set PLIST(0)=ID
	.KILL PLIST(1)
	.KILL PLIST(4)
	.&SQL(INSERT INTO websys.ComponentMessages VALUES :PLIST())
	.w !,"4  INSERT ComponentMessages,Index="_Items_" SQLCODE="_SQLCODE
	
	Kill ^DHCMedComponent
	w !,"OK",!
	Quit ID
}

/// w ##Class(web.DHCMedLoadComponent).ImportCompToFile("")
ClassMethod ImportCompToFile(FilePath)
{
	n (FilePath)
	Quit:FilePath="" "FilePath is Null!"
	
	s compname=""
	f  s compname=$o(^DHCMedComponent(compname)) q:compname=""  d
	.set tmpPath=FilePath_compname_".txt"
	.set file=##class(%File).%New(tmpPath)
	.Do file.Open("WSN")
	.s subid1=""
	.f  s subid1=$o(^DHCMedComponent(compname,subid1)) q:subid1=""  d
	..s tmp=$g(^DHCMedComponent(compname,subid1))
	..s tmp1="^DHCMedComponent("_compname_","_subid1_"))="_tmp
	..d:tmp'="" file.WriteLine(tmp1)
	..s subid2=""
	..f  s subid2=$o(^DHCMedComponent(compname,subid1,subid2)) q:subid2=""  d
	...s tmp=$g(^DHCMedComponent(compname,subid1,subid2))
	...s tmp1="^DHCMedComponent("_compname_","_subid1_","_subid2_"))="_tmp
	...d:tmp'="" file.WriteLine(tmp1)
	...s subid3=""
	...f  s subid3=$o(^DHCMedComponent(compname,subid1,subid2,subid3)) q:subid3=""  d
	....s tmp=$g(^DHCMedComponent(compname,subid1,subid2,subid3))
	....s tmp1="^DHCMedComponent("_compname_","_subid1_","_subid2_","_subid3_"))="_tmp
	....d:tmp'="" file.WriteLine(tmp1)
	....s subid4=""
	....f  s subid4=$o(^DHCMedComponent(compname,subid1,subid2,subid3,subid4)) q:subid4=""  d
	.....s tmp=$g(^DHCMedComponent(compname,subid1,subid2,subid3,subid4))
	.....s tmp1="^DHCMedComponent("_compname_","_subid1_","_subid2_","_subid3_","_subid4_"))="_tmp
	.....d:tmp'="" file.WriteLine(tmp1)
	.Do file.Close()
	
    Quit "Import File Over!"
}

/// add by lxf 2008-11-17
/// 将^DHCMedComponent中存在的所有组件全部一次性导入
/// w ##class(web.DHCMedLoadComponent).UpLoadCompsAll("P7","P5")
ClassMethod UpLoadCompsAll(VFrom, VTo)
{
	n (VFrom, VTo)
	s CompName="",i=0
	f  s CompName=$o(^DHCMedComponent(CompName)) q:CompName=""  d
	.s i=i+1
	.s Ret=..UpLoadComp(CompName, VFrom, VTo)		    
 	.w "  Ret="_Ret
 	w !,"Import "_i_" Components!"
    w !!!
    Quit "OK"
}

}
