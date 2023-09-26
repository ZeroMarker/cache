Class web.DHCPE.DHCPEComponent Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// DHCPEComponent	;w $$GetComponent^DHCPEComponent("DHCPEIReport")
/// 	;w $$PutComponent^DHCPEComponent("DHCPEIReport")
/// 	;P5->P5,P7->P7		$$GetComponent(ComponentName)
/// 	;P5->P7				$$GetComponentP5P7(ComponentName)
/// 	;
/// 	;P5->P5				$$PutComponent(ComponentName)
/// 	;P7->P7		        $$PutComponentP7(ComponentName)
/// 	;P5->P7             $$PutComponentP5P7(ComponentName)
/// d ##class(web.DHCPE.IMPMenuAndCompont).BakComponent("55","DHCPE","/tmp/DHCPE.txt")
ClassMethod GetComponent(ComponentName)
{
	;
	&SQL(SELECT ID INTO :ComponentId FROM websys.Component 
			WHERE Name=:ComponentName)
	If SQLCODE Quit 1
	Kill ^DHCComponent(ComponentName)
	;
	KILL PLIST
	&SQL(SELECT * INTO :PLIST() FROM websys.Component Where ID=:ComponentId)
	m ^DHCComponent(ComponentName,"COMP")=PLIST
	Set ^DHCComponent(ComponentName,"ID")=ComponentId
	;
	Kill PLIST
	&SQL(DECLARE CompItems CURSOR FOR 
				SELECT * INTO :PLIST() FROM websys.ComponentItems 
				Where ParRef=:ComponentId)
	&SQL(OPEN CompItems)
	Set Items=1
	For  &SQL(FETCH CompItems) Quit:SQLCODE  Do
	.m ^DHCComponent(ComponentName,"ITEM",Items)=PLIST
	.Set Items=Items+1
	&SQL(CLOSE CompItems)
	;
	Kill PLIST
	&SQL(DECLARE CompTable CURSOR FOR 
				SELECT * INTO :PLIST() FROM websys.ComponentTableItems 
				Where ParRef=:ComponentId)
	&SQL(OPEN CompTable)
	Set Items=1
	For  &SQL(FETCH CompTable) Quit:SQLCODE  Do
	.m ^DHCComponent(ComponentName,"TABLE",Items)=PLIST
	.Set Items=Items+1
	&SQL(CLOSE CompTable)
	;
	Kill PLIST
	&SQL(DECLARE CompMessage CURSOR FOR 
				SELECT * INTO :PLIST() FROM websys.ComponentMessages 
				Where ParRef=:ComponentId)
	&SQL(OPEN CompMessage)
	Set Items=1
	For  &SQL(FETCH CompMessage) Quit:SQLCODE  Do
	.m ^DHCComponent(ComponentName,"Messages",Items)=PLIST
	.Set Items=Items+1
	&SQL(CLOSE CompMessage)
	;
	;i 
	Set LayOut=##Class(websys.Preferences).GetData("SITE","DHCHealth","LAYOUT",ComponentId)   //DHCJST  DHCHealth
	Set LayOut=$LIST(LayOut,1) 
	m ^DHCComponent(ComponentName,"LAYOUT")=LayOut
	w ComponentId_"55"
	Quit ComponentId
}

ClassMethod GetComponentP5P7(ComponentName)
{
	w ComponentName_"57",!
	&SQL(SELECT ID INTO :ComponentId FROM websys.Component 
			WHERE Name=:ComponentName)
	If SQLCODE Quit 1
	Kill ^DHCComponent(ComponentName)
	;
	KILL PLIST
	&SQL(SELECT * INTO :PLIST() FROM websys.Component Where ID=:ComponentId)
	m ^DHCComponent(ComponentName,"COMP")=PLIST
	Set ^DHCComponent(ComponentName,"ID")=ComponentId
	;
	Kill PLIST
	&SQL(DECLARE CompItems1 CURSOR FOR 
				SELECT * INTO :PLIST() FROM websys.ComponentItems 
				Where ParRef=:ComponentId)
	&SQL(OPEN CompItems1)
	Set Items=1
	For  &SQL(FETCH CompItems1) Quit:SQLCODE  Do
	.m ^DHCCom123=PLIST
	.;m ^DHCComponent(ComponentName,"ITEM",Items)=PLIST
	.For MM=0:1:24 Set ^DHCComponent(ComponentName,"ITEM",Items,MM)=PLIST(MM)
	.Set ^DHCComponent(ComponentName,"ITEM",Items,25)=""
	.For MM=25:1:44 Set ^DHCComponent(ComponentName,"ITEM",Items,MM+1)=PLIST(MM)
	.Set ^DHCComponent(ComponentName,"ITEM",Items,46)=""
	.For MM=45:1:60 Set ^DHCComponent(ComponentName,"ITEM",Items,MM+2)=PLIST(MM)
	.Set Items=Items+1
	&SQL(CLOSE CompItems1)
	;
	Kill PLIST
	&SQL(DECLARE CompTable1 CURSOR FOR 
				SELECT * INTO :PLIST() FROM websys.ComponentTableItems 
				Where ParRef=:ComponentId)
	&SQL(OPEN CompTable1)
	Set Items=1
	For  &SQL(FETCH CompTable1) Quit:SQLCODE  Do
	.;m ^DHCComponent(ComponentName,"TABLE",Items)=PLIST
	.For MM=0:1:24 Set ^DHCComponent(ComponentName,"TABLE",Items,MM)=PLIST(MM)
	.Set ^DHCComponent(ComponentName,"TABLE",Items,25)=""
	.For MM=25:1:44 Set ^DHCComponent(ComponentName,"TABLE",Items,MM+1)=PLIST(MM)
	.Set ^DHCComponent(ComponentName,"TABLE",Items,46)=""
	.For MM=45:1:60 Set ^DHCComponent(ComponentName,"TABLE",Items,MM+2)=PLIST(MM)
	.Set Items=Items+1
	&SQL(CLOSE CompTable1)
	;
	Kill PLIST
	&SQL(DECLARE CompMessage1 CURSOR FOR 
				SELECT * INTO :PLIST() FROM websys.ComponentMessages 
				Where ParRef=:ComponentId)
	&SQL(OPEN CompMessage1)
	Set Items=1
	For  &SQL(FETCH CompMessage1) Quit:SQLCODE  Do
	.m ^DHCComponent(ComponentName,"Messages",Items)=PLIST
	.Set Items=Items+1
	&SQL(CLOSE CompMessage1)
	;
	Set LayOut=##Class(websys.Preferences).GetData("SITE","DHCJST","LAYOUT",ComponentId)
	Set LayOut=$LIST(LayOut,1) 
	m ^DHCComponent(ComponentName,"LAYOUT")=LayOut
	Quit ComponentId
}

ClassMethod PutComponent(ComponentName)
{
	;
	&SQL(SELECT id into :comid FROM websys.Component WHERE Name=:ComponentName)
	;If 'SQLCODE Quit 1
	Set SourceId=^DHCComponent(ComponentName,"ID")
	KILL PLIST
	;
	
	m PLIST=^DHCComponent(ComponentName,"COMP")
	
	KILL PLIST(1)
	i comid>0
	{
		&SQL(Delete From websys.ComponentMessages Where parref=:comid )
		&SQL(Delete From websys.ComponentTableItems Where parref=:comid )
		&SQL(Delete From websys.ComponentItems Where parref=:comid )
		&SQL(Delete From websys.Preferences Where AppSubkey=:comid )
		&SQL(Update websys.Component VALUES :PLIST() Where id=:comid)
		s ID=comid		
	}
	else
	{
		&SQL(INSERT INTO websys.Component VALUES :PLIST())
		Set ID=$g(%ROWID)
		//s PLIST(45)=##class(web.DHCPE.Public.Setting).Replace(PLIST(45),SourceId,ID)
		//&SQL(Update websys.Component VALUES :PLIST() Where id=:ID)
	}	
	;
	
	Set LAYOUT=^DHCComponent(ComponentName,"LAYOUT")
	Set LAYOUT=##class(web.DHCPE.IMPMenuAndCompont).Replace(LAYOUT,SourceId,ID)
	&SQL(Update websys.Component Set Template=:LAYOUT WHERE ID=:ID)
	;&SQL(INSERT INTO websys.Preferences (AppKey,AppSubkey,Data,ObjectReference,ObjectType) VALUES("LAYOUT",:ID,:LAYOUT,"DHC","SITE"))
	;
	
	Set Items=0
	f  Set Items=$o(^DHCComponent(ComponentName,"ITEM",Items)) Quit:Items=""  Do
	.KILL PLIST
	.m PLIST=^DHCComponent(ComponentName,"ITEM",Items)
	.Set PLIST(0)=ID
	.KILL PLIST(1)
	.KILL PLIST(60)
	.&SQL(INSERT INTO websys.ComponentItems VALUES :PLIST())
	;
	
	Set Items=0
	f  Set Items=$o(^DHCComponent(ComponentName,"TABLE",Items)) Quit:Items=""  Do
	.KILL PLIST
	.m PLIST=^DHCComponent(ComponentName,"TABLE",Items)
	.Set PLIST(0)=ID
	.KILL PLIST(1)
	.KILL PLIST(60)
	.&SQL(INSERT INTO websys.ComponentTableItems VALUES :PLIST())
	;
	
	Set Items=0
	f  Set Items=$o(^DHCComponent(ComponentName,"Messages",Items)) Quit:Items=""  Do
	.KILL PLIST
	.m PLIST=^DHCComponent(ComponentName,"Messages",Items)
	.Set PLIST(0)=ID
	.KILL PLIST(1)
	.KILL PLIST(4)
	.&SQL(INSERT INTO websys.ComponentMessages VALUES :PLIST())
	;	
	
	QUIT ID
}

ClassMethod PutComponentP7(ComponentName)
{
	;
	&SQL(SELECT id into :comid FROM websys.Component WHERE Name=:ComponentName)
	;If 'SQLCODE Quit 1
	Set SourceId=^DHCComponent(ComponentName,"ID")
	KILL PLIST
	;
	;m mPLIST=^DHCComponent(ComponentName,"COMP")
	;For NL=1:1:17 if $d(mPLIST(NL)) Set PLIST(NL)=mPLIST(NL) 
	;Set PLIST(18)=""
	;For NL=18:1:47 If $D(mPLIST(NL)) Set PLIST(NL+1)=mPLIST(NL)
	;KILL mPLIST
	m PLIST=^DHCComponent(ComponentName,"COMP")
	KILL PLIST(1)
	
	i comid>0
	{
		&SQL(Delete From websys.ComponentMessages Where parref=:comid )
		&SQL(Delete From websys.ComponentTableItems Where parref=:comid )
		&SQL(Delete From websys.ComponentItems Where parref=:comid )
		&SQL(Delete From websys.Preferences Where AppSubkey=:comid )
		&SQL(Update websys.Component VALUES :PLIST() Where id=:comid)
		s ID=comid		
	}
	else
	{
		&SQL(INSERT INTO websys.Component VALUES :PLIST())
		Set ID=$g(%ROWID)
		//s PLIST(45)=##class(web.DHCPE.Public.Setting).Replace(PLIST(45),SourceId,ID)
		//&SQL(Update websys.Component VALUES :PLIST() Where id=:ID)
	}	
	w !,"gg"_"^"_SQLCODE
	;Set ID=$g(%ROWID)
	;
	Set LAYOUT=^DHCComponent(ComponentName,"LAYOUT")
	Set LAYOUT=##class(web.DHCPE.IMPMenuAndCompont).Replace(LAYOUT,SourceId,ID)
	&SQL(Update websys.Component Set Template=:LAYOUT WHERE ID=:ID)
	;&SQL(INSERT INTO websys.Preferences (AppKey,AppSubkey,Data,ObjectReference,ObjectType) VALUES("LAYOUT",:ID,:LAYOUT,"DHC","SITE"))
	w "aa:"_SQLCODE,! ;ds
	;
	Set Items=0
	f  Set Items=$o(^DHCComponent(ComponentName,"ITEM",Items)) Quit:Items=""  Do
	.KILL PLIST
	.m PLIST=^DHCComponent(ComponentName,"ITEM",Items)
	.Set PLIST(0)=ID
	.KILL PLIST(1)
	.KILL PLIST(62)
	.&SQL(INSERT INTO websys.ComponentItems VALUES :PLIST())
	w "bb:"_SQLCODE,! ;ss
	;
	Set Items=0
	f  Set Items=$o(^DHCComponent(ComponentName,"TABLE",Items)) Quit:Items=""  Do
	.KILL PLIST
	.m PLIST=^DHCComponent(ComponentName,"TABLE",Items)
	.Set PLIST(0)=ID
	.KILL PLIST(1)
	.KILL PLIST(62)
	.&SQL(INSERT INTO websys.ComponentTableItems VALUES :PLIST())
	;
	w "cc:"_SQLCODE,!
	Set Items=0
	f  Set Items=$o(^DHCComponent(ComponentName,"Messages",Items)) Quit:Items=""  Do
	.KILL PLIST
	.m PLIST=^DHCComponent(ComponentName,"Messages",Items)
	.Set PLIST(0)=ID
	.KILL PLIST(1)
	.KILL PLIST(4)
	.&SQL(INSERT INTO websys.ComponentMessages VALUES :PLIST())
	;	
	QUIT ID
}

ClassMethod PutComponentP5P7(ComponentName)
{
	;
	&SQL(SELECT id into :comid FROM websys.Component WHERE Name=:ComponentName)
	;If 'SQLCODE Quit 1
	Set SourceId=^DHCComponent(ComponentName,"ID")
	KILL PLIST
	;
	m mPLIST=^DHCComponent(ComponentName,"COMP")
	For NL=1:1:17 if $d(mPLIST(NL)) Set PLIST(NL)=mPLIST(NL) 
	Set PLIST(18)=""
	For NL=18:1:47 If $D(mPLIST(NL)) Set PLIST(NL+1)=mPLIST(NL)
	KILL mPLIST
	KILL PLIST(1)
	
	i comid>0
	{
		&SQL(Delete From websys.ComponentMessages Where parref=:comid )
		&SQL(Delete From websys.ComponentTableItems Where parref=:comid )
		&SQL(Delete From websys.ComponentItems Where parref=:comid )
		&SQL(Delete From websys.Preferences Where AppSubkey=:comid )
		&SQL(Update websys.Component VALUES :PLIST() Where id=:comid)
		s ID=comid		
	}
	else
	{
		&SQL(INSERT INTO websys.Component VALUES :PLIST())
		Set ID=$g(%ROWID)
		//s PLIST(45)=##class(web.DHCPE.Public.Setting).Replace(PLIST(45),SourceId,ID)
		//&SQL(Update websys.Component VALUES :PLIST() Where id=:ID)
	}	
	w !,"gg"_"^"_SQLCODE
	;Set ID=$g(%ROWID)
	;
	Set LAYOUT=^DHCComponent(ComponentName,"LAYOUT")
	Set LAYOUT=##class(web.DHCPE.IMPMenuAndCompont).Replace(LAYOUT,SourceId,ID)
	&SQL(Update websys.Component Set Template=:LAYOUT WHERE ID=:ID)
	;&SQL(INSERT INTO websys.Preferences (AppKey,AppSubkey,Data,ObjectReference,ObjectType) VALUES("LAYOUT",:ID,:LAYOUT,"DHC","SITE"))
	w "aa:"_SQLCODE,! ;ds
	;
	Set Items=0
	f  Set Items=$o(^DHCComponent(ComponentName,"ITEM",Items)) Quit:Items=""  Do
	.KILL PLIST
	.m PLIST=^DHCComponent(ComponentName,"ITEM",Items)
	.Set PLIST(0)=ID
	.KILL PLIST(1)
	.KILL PLIST(62)
	.&SQL(INSERT INTO websys.ComponentItems VALUES :PLIST())
	w "bb:"_SQLCODE,! ;ss
	;
	Set Items=0
	f  Set Items=$o(^DHCComponent(ComponentName,"TABLE",Items)) Quit:Items=""  Do
	.KILL PLIST
	.m PLIST=^DHCComponent(ComponentName,"TABLE",Items)
	.Set PLIST(0)=ID
	.KILL PLIST(1)
	.KILL PLIST(62)
	.&SQL(INSERT INTO websys.ComponentTableItems VALUES :PLIST())
	;
	w "cc:"_SQLCODE,!
	Set Items=0
	f  Set Items=$o(^DHCComponent(ComponentName,"Messages",Items)) Quit:Items=""  Do
	.KILL PLIST
	.m PLIST=^DHCComponent(ComponentName,"Messages",Items)
	.Set PLIST(0)=ID
	.KILL PLIST(1)
	.KILL PLIST(4)
	.&SQL(INSERT INTO websys.ComponentMessages VALUES :PLIST())
	;	
	QUIT ID
}

Storage Default
{
<Data name="DHCPEComponentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCP.DHCPEComponentD</DataLocation>
<DefaultData>DHCPEComponentDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCP.DHCPEComponentD</IdLocation>
<IndexLocation>^web.DHCP.DHCPEComponentI</IndexLocation>
<StreamLocation>^web.DHCP.DHCPEComponentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
