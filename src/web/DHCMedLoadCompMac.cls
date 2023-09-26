Class web.DHCMedLoadCompMac Extends (%Library.RegisteredObject, websys.Abstract) [ Inheritance = right ]
{

Parameter BUILD = 14;

ClassMethod PutComponentP5(ComponentName)
{
	;
	Set SourceId=$g(^DHCMedComponent(ComponentName,"ID"))
	Quit:SourceId="" -100
	&SQL(SELECT * FROM websys.Component WHERE Name=:ComponentName)
	If 'SQLCODE d
	.&SQL(DELETE FROM websys.Component WHERE Name=:ComponentName)
	.w !," Delete "_SQLCODE
	
	KILL PLIST
	;
	;
	m PLIST=^DHCMedComponent(ComponentName,"COMP")
	KILL PLIST(1)
	
	&SQL(INSERT INTO websys.Component VALUES :PLIST())
	Set ID=$g(%ROWID)
	
	;
	Set LAYOUT=^DHCMedComponent(ComponentName,"LAYOUT")
	Set LAYOUT=$TR(LAYOUT,SourceId,ID)
	&SQL(Update websys.Component Set Template=:LAYOUT WHERE ID=:ID)
	;&SQL(INSERT INTO websys.Preferences (AppKey,AppSubkey,Data,ObjectReference,ObjectType) VALUES("LAYOUT",:ID,:LAYOUT,"DHC","SITE"))
	;
	Set Items=0
	f  Set Items=$o(^DHCMedComponent(ComponentName,"ITEM",Items)) Quit:Items=""  Do
	.KILL PLIST
	.m PLIST=^DHCMedComponent(ComponentName,"ITEM",Items)
	.Set PLIST(0)=ID
	.KILL PLIST(1)
	.KILL PLIST(60)
	.&SQL(INSERT INTO websys.ComponentItems VALUES :PLIST())
	;
	Set Items=0
	f  Set Items=$o(^DHCMedComponent(ComponentName,"TABLE",Items)) Quit:Items=""  Do
	.KILL PLIST
	.m PLIST=^DHCMedComponent(ComponentName,"TABLE",Items)
	.Set PLIST(0)=ID
	.KILL PLIST(1)
	.KILL PLIST(60)
	.KILL PLIST(38)    ;add by wuqk for NextComp 2008-03-27
	.Set NestCompName=$g(^DHCMedComponent(ComponentName,"TABLE",Items,"NestedComponent"))
	.s NestCompId=""
	.i (NestCompName'="") d
	..&SQL(SELECT ID INTO :NestCompId FROM websys.Component WHERE Name=:NestCompName)
	.Set PLIST(38)=NestCompId
	.&SQL(INSERT INTO websys.ComponentTableItems VALUES :PLIST())
	;
	Set Items=0
	f  Set Items=$o(^DHCMedComponent(ComponentName,"Messages",Items)) Quit:Items=""  Do
	.KILL PLIST
	.m PLIST=^DHCMedComponent(ComponentName,"Messages",Items)
	.Set PLIST(0)=ID
	.KILL PLIST(1)
	.KILL PLIST(4)
	.&SQL(INSERT INTO websys.ComponentMessages VALUES :PLIST())
	;	
	QUIT ID
}

ClassMethod PutComponentP7P5(ComponentName)
{
	;
	Set SourceId=$g(^DHCMedComponent(ComponentName,"ID"))
	Quit:SourceId="" -100
	&SQL(SELECT * FROM websys.Component WHERE Name=:ComponentName)
	If 'SQLCODE d
	.&SQL(DELETE FROM websys.Component WHERE Name=:ComponentName)
	.w !," Delete "_SQLCODE
	
	KILL PLIST
	;
	m mPLIST=^DHCMedComponent(ComponentName,"COMP")
	For NL=1:1:17 if $d(mPLIST(NL)) Set PLIST(NL)=mPLIST(NL) 
	For NL=19:1:47 If $D(mPLIST(NL)) Set PLIST(NL-1)=mPLIST(NL)
	KILL mPLIST
	;m PLIST=^DHCMedComponent(ComponentName,"COMP")
	KILL PLIST(1)
	
	&SQL(INSERT INTO websys.Component VALUES :PLIST())
	Set ID=$g(%ROWID)
	
	;
	Set LAYOUT=^DHCMedComponent(ComponentName,"LAYOUT")
	Set LAYOUT=$TR(LAYOUT,SourceId,ID)
	&SQL(Update websys.Component Set Template=:LAYOUT WHERE ID=:ID)
	;&SQL(INSERT INTO websys.Preferences (AppKey,AppSubkey,Data,ObjectReference,ObjectType) VALUES("LAYOUT",:ID,:LAYOUT,"DHC","SITE"))
	;
	Set Items=0
	f  Set Items=$o(^DHCMedComponent(ComponentName,"ITEM",Items)) Quit:Items=""  Do
	.KILL PLIST
	.m mPLIST=^DHCMedComponent(ComponentName,"ITEM",Items)
	.For NL=0:1:24 if $d(mPLIST(NL)) Set PLIST(NL)=mPLIST(NL) 
	.For NL=26:1:45 If $D(mPLIST(NL)) Set PLIST(NL-1)=mPLIST(NL)
	.For NL=47:1:62 If $D(mPLIST(NL)) Set PLIST(NL-2)=mPLIST(NL)
	.KILL mPLIST
	.;m PLIST=^DHCMedComponent(ComponentName,"ITEM",Items)
	.Set PLIST(0)=ID
	.KILL PLIST(1)
	.KILL PLIST(60)
	.&SQL(INSERT INTO websys.ComponentItems VALUES :PLIST())
	;
	Set Items=0
	f  Set Items=$o(^DHCMedComponent(ComponentName,"TABLE",Items)) Quit:Items=""  Do
	.KILL PLIST
	.m mPLIST=^DHCMedComponent(ComponentName,"TABLE",Items)
	.For NL=0:1:24 if $d(mPLIST(NL)) Set PLIST(NL)=mPLIST(NL) 
	.For NL=26:1:45 If $D(mPLIST(NL)) Set PLIST(NL-1)=mPLIST(NL)
	.For NL=47:1:62 If $D(mPLIST(NL)) Set PLIST(NL-2)=mPLIST(NL)
	.KILL mPLIST
	.;m PLIST=^DHCMedComponent(ComponentName,"TABLE",Items)
	.Set PLIST(0)=ID
	.KILL PLIST(1)
	.KILL PLIST(60)
	.KILL PLIST(38)    ;add by wuqk for NextComp 2008-03-27
	.Set NestCompName=$g(^DHCMedComponent(ComponentName,"TABLE",Items,"NestedComponent"))
	.s NestCompId=""
	.i (NestCompName'="") d
	..&SQL(SELECT ID INTO :NestCompId FROM websys.Component WHERE Name=:NestCompName)
	.Set PLIST(38)=NestCompId
	.&SQL(INSERT INTO websys.ComponentTableItems VALUES :PLIST())
	;
	Set Items=0
	f  Set Items=$o(^DHCMedComponent(ComponentName,"Messages",Items)) Quit:Items=""  Do
	.KILL PLIST
	.m PLIST=^DHCMedComponent(ComponentName,"Messages",Items)
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
	Set SourceId=$g(^DHCMedComponent(ComponentName,"ID"))
	Quit:SourceId="" -100
	&SQL(SELECT * FROM websys.Component WHERE Name=:ComponentName)
	;If 'SQLCODE Quit 1
	If 'SQLCODE d
	.&SQL(DELETE FROM websys.Component WHERE Name=:ComponentName)
	.w !," Delete "_SQLCODE
	KILL PLIST
	;
	m PLIST=^DHCMedComponent(ComponentName,"COMP")
	KILL PLIST(1)
	&SQL(INSERT INTO websys.Component VALUES :PLIST())
	Set ID=$g(%ROWID)
	;
	Set LAYOUT=^DHCMedComponent(ComponentName,"LAYOUT")
	Set LAYOUT=$TR(LAYOUT,SourceId,ID)
	&SQL(Update websys.Component Set Template=:LAYOUT WHERE ID=:ID)
	;&SQL(INSERT INTO websys.Preferences (AppKey,AppSubkey,Data,ObjectReference,ObjectType) VALUES("LAYOUT",:ID,:LAYOUT,"DHC","SITE"))
	;
	Set Items=0
	f  Set Items=$o(^DHCMedComponent(ComponentName,"ITEM",Items)) Quit:Items=""  Do
	.KILL PLIST
	.m PLIST=^DHCMedComponent(ComponentName,"ITEM",Items)
	.Set PLIST(0)=ID
	.KILL PLIST(1)
	.KILL PLIST(62)
	.&SQL(INSERT INTO websys.ComponentItems VALUES :PLIST())
	;
	Set Items=0
	f  Set Items=$o(^DHCMedComponent(ComponentName,"TABLE",Items)) Quit:Items=""  Do
	.KILL PLIST
	.m PLIST=^DHCMedComponent(ComponentName,"TABLE",Items)
	.Set PLIST(0)=ID
	.KILL PLIST(1)
	.KILL PLIST(62)
	.KILL PLIST(40)    ;add by wuqk for NextComp 2008-03-27
	.Set NestCompName=$g(^DHCMedComponent(ComponentName,"TABLE",Items,"NestedComponent"))
	.s NestCompId=""
	.i (NestCompName'="") d
	..&SQL(SELECT ID INTO :NestCompId FROM websys.Component WHERE Name=:NestCompName)
	.Set PLIST(40)=NestCompId
	.&SQL(INSERT INTO websys.ComponentTableItems VALUES :PLIST())
	;
	Set Items=0
	f  Set Items=$o(^DHCMedComponent(ComponentName,"Messages",Items)) Quit:Items=""  Do
	.KILL PLIST
	.m PLIST=^DHCMedComponent(ComponentName,"Messages",Items)
	.Set PLIST(0)=ID
	.KILL PLIST(1)
	.KILL PLIST(4)
	.&SQL(INSERT INTO websys.ComponentMessages VALUES :PLIST())
	;
	QUIT ID
}

ClassMethod PutComponentP8(ComponentName)
{
	;w $$PutComponentP8^DHCMedComponent()
	Set SourceId=$g(^DHCMedComponent(ComponentName,"ID"))
	Quit:SourceId="" -100
	&SQL(SELECT * FROM websys.Component WHERE Name=:ComponentName)
	;If 'SQLCODE Quit 1
	If 'SQLCODE d
	.&SQL(DELETE FROM websys.Component WHERE Name=:ComponentName)
	.w !," Delete "_SQLCODE
	Set SourceId=^DHCMedComponent(ComponentName,"ID")
	KILL PLIST
	;
	m mPLIST=^DHCMedComponent(ComponentName,"COMP")
	For NL=1:1:21 if $d(mPLIST(NL)) Set PLIST(NL)=mPLIST(NL) 
	Set PLIST(22)=""
	Set PLIST(23)=""
	For NL=22:1:47 If $D(mPLIST(NL)) Set PLIST(NL+2)=mPLIST(NL)
	KILL mPLIST
	;m PLIST=^DHCMedComponent(ComponentName,"COMP")
	KILL PLIST(1)
	&SQL(INSERT INTO websys.Component VALUES :PLIST())
	w !,"gg"_"^"_SQLCODE
	Set ID=$g(%ROWID)
	;
	Set LAYOUT=^DHCMedComponent(ComponentName,"LAYOUT")
	Set LAYOUT=$TR(LAYOUT,SourceId,ID)
	&SQL(Update websys.Component Set Template=:LAYOUT WHERE ID=:ID)
	;&SQL(INSERT INTO websys.Preferences (AppKey,AppSubkey,Data,ObjectReference,ObjectType) VALUES("LAYOUT",:ID,:LAYOUT,"DHC","SITE"))
	w "aa:"_SQLCODE,! ;ds
	;
	Set Items=0
	f  Set Items=$o(^DHCMedComponent(ComponentName,"ITEM",Items)) Quit:Items=""  Do
	.KILL PLIST
	.m PLIST=^DHCMedComponent(ComponentName,"ITEM",Items)
	.Set PLIST(0)=ID
	.KILL PLIST(1)
	.KILL PLIST(62)
	.&SQL(INSERT INTO websys.ComponentItems VALUES :PLIST())
	w "bb:"_SQLCODE,! ;ss
	;
	Set Items=0
	f  Set Items=$o(^DHCMedComponent(ComponentName,"TABLE",Items)) Quit:Items=""  Do
	.KILL PLIST
	.m PLIST=^DHCMedComponent(ComponentName,"TABLE",Items)
	.Set PLIST(0)=ID
	.KILL PLIST(1)
	.KILL PLIST(62)	 
	.KILL PLIST(39)  ;add by wuqk for NextComp 2008-03-27
	.Set NestCompName=$g(^DHCMedComponent(ComponentName,"TABLE",Items,"NestedComponent"))
	.s NestCompId=""
	.i (NestCompName'="") d
	..&SQL(SELECT ID INTO :NestCompId FROM websys.Component WHERE Name=:NestCompName)
	.Set PLIST(39)=NestCompId
	.&SQL(INSERT INTO websys.ComponentTableItems VALUES :PLIST())
	;
	w "cc:"_SQLCODE,!
	Set Items=0
	f  Set Items=$o(^DHCMedComponent(ComponentName,"Messages",Items)) Quit:Items=""  Do
	.KILL PLIST
	.m PLIST=^DHCMedComponent(ComponentName,"Messages",Items)
	.Set PLIST(0)=ID
	.KILL PLIST(1)
	.KILL PLIST(4)
	.&SQL(INSERT INTO websys.ComponentMessages VALUES :PLIST())
	;	
	QUIT ID
}

ClassMethod GetComponentP5(ComponentName)
{
	;
	
	Set ComponentId=""
	&SQL(SELECT ID INTO :ComponentId FROM websys.Component 
			WHERE Name=:ComponentName)
	If (ComponentId="") Quit -100
	
	KILL PLIST
	&SQL(SELECT * INTO :PLIST() FROM websys.Component Where ID=:ComponentId)
	m ^DHCMedComponent(ComponentName,"COMP")=PLIST
	Set ^DHCMedComponent(ComponentName,"ID")=ComponentId
	;
	Kill PLIST
	&SQL(DECLARE CompItems CURSOR FOR 
				SELECT * INTO :PLIST() FROM websys.ComponentItems 
				Where ParRef=:ComponentId)
	&SQL(OPEN CompItems)
	Set Items=1
	For  &SQL(FETCH CompItems) Quit:SQLCODE  Do
	.m ^DHCMedComponent(ComponentName,"ITEM",Items)=PLIST
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
	.m ^DHCMedComponent(ComponentName,"TABLE",Items)=PLIST
	.Set NestCompId=PLIST(38)           ;add by wuqk for NextComp 2008-03-27
	.Set NestCompName=""
	.if (NestCompId'="") d
	..&SQL(SELECT Name INTO :NestCompName FROM websys.Component WHERE ID=:NestCompId)
	.s ^DHCMedComponent(ComponentName,"TABLE",Items,"NestedComponent")=NestCompName
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
	.m ^DHCMedComponent(ComponentName,"Messages",Items)=PLIST
	.Set Items=Items+1
	&SQL(CLOSE CompMessage)
	;
	Set LayOut=##Class(websys.Preferences).GetData("SITE","DHCJST","LAYOUT",ComponentId)
	Set LayOut=$LIST(LayOut,1) 
	m ^DHCMedComponent(ComponentName,"LAYOUT")=LayOut
	Quit ComponentId
}

ClassMethod GetComponentP5P7(ComponentName)
{
	&SQL(SELECT ID INTO :ComponentId FROM websys.Component 
			WHERE Name=:ComponentName)
	If (ComponentId="") Quit -100
	//Kill ^DHCMedComponent(ComponentName)
	;
	KILL PLIST
	&SQL(SELECT * INTO :PLIST() FROM websys.Component Where ID=:ComponentId)
	;m ^DHCMedComponent(ComponentName,"COMP")=PLIST
	Set CNT=0
	For MM=0:1:17 Do
		.Set ^DHCMedComponent(ComponentName,"COMP",CNT)=$g(PLIST(MM))
		.Set CNT=CNT+1
	Set ^DHCMedComponent(ComponentName,"COMP",CNT)=""
	Set CNT=CNT+1	
	For MM=18:1:46 Do
		.Set ^DHCMedComponent(ComponentName,"COMP",CNT)=$g(PLIST(MM))
		.Set CNT=CNT+1
	
	Set ^DHCMedComponent(ComponentName,"ID")=ComponentId
	;
	Kill PLIST
	&SQL(DECLARE CompItems1 CURSOR FOR 
				SELECT * INTO :PLIST() FROM websys.ComponentItems 
				Where ParRef=:ComponentId)
	&SQL(OPEN CompItems1)
	Set Items=1
	For  &SQL(FETCH CompItems1) Quit:SQLCODE  Do
	.m ^DHCCom123=PLIST
	.;m ^DHCMedComponent(ComponentName,"ITEM",Items)=PLIST
	.For MM=0:1:24 Set ^DHCMedComponent(ComponentName,"ITEM",Items,MM)=PLIST(MM)
	.Set ^DHCMedComponent(ComponentName,"ITEM",Items,25)=""
	.For MM=25:1:44 Set ^DHCMedComponent(ComponentName,"ITEM",Items,MM+1)=PLIST(MM)
	.Set ^DHCMedComponent(ComponentName,"ITEM",Items,46)=""
	.For MM=45:1:60 Set ^DHCMedComponent(ComponentName,"ITEM",Items,MM+2)=PLIST(MM)
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
	.;m ^DHCMedComponent(ComponentName,"TABLE",Items)=PLIST
	.For MM=0:1:24 Set ^DHCMedComponent(ComponentName,"TABLE",Items,MM)=PLIST(MM)
	.Set ^DHCMedComponent(ComponentName,"TABLE",Items,25)=""
	.For MM=25:1:44 Set ^DHCMedComponent(ComponentName,"TABLE",Items,MM+1)=PLIST(MM)
	.Set ^DHCMedComponent(ComponentName,"TABLE",Items,46)=""
	.For MM=45:1:60 Set ^DHCMedComponent(ComponentName,"TABLE",Items,MM+2)=PLIST(MM)
	.Set NestCompId=PLIST(38)           ;add by wuqk for NextComp 2008-03-27
	.Set NestCompName=""
	.if (NestCompId'="") d
	..&SQL(SELECT Name INTO :NestCompName FROM websys.Component WHERE ID=:NestCompId)
	.s ^DHCMedComponent(ComponentName,"TABLE",Items,"NestedComponent")=NestCompName
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
	.m ^DHCMedComponent(ComponentName,"Messages",Items)=PLIST
	.Set Items=Items+1
	&SQL(CLOSE CompMessage1)
	;
	Set LayOut=##Class(websys.Preferences).GetData("SITE","DHCJST","LAYOUT",ComponentId)
	Set LayOut=$LIST(LayOut,1) 
	m ^DHCMedComponent(ComponentName,"LAYOUT")=LayOut
	Quit ComponentId
	;
}

ClassMethod GetComponentP7(ComponentName)
{
	;
	
	Set ComponentId=""
	&SQL(SELECT ID INTO :ComponentId FROM websys.Component 
			WHERE Name=:ComponentName)
	If (ComponentId="") Quit -100
	
	KILL PLIST
	&SQL(SELECT * INTO :PLIST() FROM websys.Component Where ID=:ComponentId)
	m ^DHCMedComponent(ComponentName,"COMP")=PLIST
	Set ^DHCMedComponent(ComponentName,"ID")=ComponentId
	;
	Kill PLIST
	&SQL(DECLARE CompItems7 CURSOR FOR 
				SELECT * INTO :PLIST() FROM websys.ComponentItems 
				Where ParRef=:ComponentId)
	&SQL(OPEN CompItems7)
	Set Items=1
	For  &SQL(FETCH CompItems7) Quit:SQLCODE  Do
	.m ^DHCMedComponent(ComponentName,"ITEM",Items)=PLIST
	.Set Items=Items+1
	&SQL(CLOSE CompItems7)
	;
	Kill PLIST
	&SQL(DECLARE CompTable7 CURSOR FOR 
				SELECT * INTO :PLIST() FROM websys.ComponentTableItems 
				Where ParRef=:ComponentId)
	&SQL(OPEN CompTable7)
	Set Items=1
	For  &SQL(FETCH CompTable7) Quit:SQLCODE  Do
	.m ^DHCMedComponent(ComponentName,"TABLE",Items)=PLIST
	.Set NestCompId=PLIST(40)           ;add by wuqk for NextComp 2008-03-27
	.Set NestCompName=""
	.if (NestCompId'="") d
	..&SQL(SELECT Name INTO :NestCompName FROM websys.Component WHERE ID=:NestCompId)
	.s ^DHCMedComponent(ComponentName,"TABLE",Items,"NestedComponent")=NestCompName
	.Set Items=Items+1
	&SQL(CLOSE CompTable7)
	;
	Kill PLIST
	&SQL(DECLARE CompMessage7 CURSOR FOR 
				SELECT * INTO :PLIST() FROM websys.ComponentMessages 
				Where ParRef=:ComponentId)
	&SQL(OPEN CompMessage7)
	Set Items=1
	For  &SQL(FETCH CompMessage7) Quit:SQLCODE  Do
	.m ^DHCMedComponent(ComponentName,"Messages",Items)=PLIST
	.Set Items=Items+1
	&SQL(CLOSE CompMessage7)
	;
	Set LayOut=##Class(websys.Preferences).GetData("SITE","DHCHealth","LAYOUT",ComponentId)
	Set LayOut=$LIST(LayOut,1) 
	m ^DHCMedComponent(ComponentName,"LAYOUT")=LayOut
	Quit ComponentId
}

ClassMethod GetComponentP7P5(ComponentName)
{
	;
	
	&SQL(SELECT ID INTO :ComponentId FROM websys.Component 
			WHERE Name=:ComponentName)
	If (ComponentId="") Quit -100
	Kill ^DHCMedComponent(ComponentName)
	;
	KILL PLIST
	&SQL(SELECT * INTO :PLIST() FROM websys.Component Where ID=:ComponentId)
	;m ^DHCMedComponent(ComponentName,"COMP")=PLIST
	Set CNT=0
	For MM=0:1:17 Do
		.Set ^DHCMedComponent(ComponentName,"COMP",CNT)=$g(PLIST(MM))
		.Set CNT=CNT+1	
	For MM=19:1:47 Do
		.Set ^DHCMedComponent(ComponentName,"COMP",CNT)=$g(PLIST(MM))
		.Set CNT=CNT+1
	Set ^DHCMedComponent(ComponentName,"ID")=ComponentId
	;
	Kill PLIST
	&SQL(DECLARE CompItn1 CURSOR FOR 
				SELECT * INTO :PLIST() FROM websys.ComponentItems 
				Where ParRef=:ComponentId)
	&SQL(OPEN CompItn1)
	Set Items=1
	For  &SQL(FETCH CompItn1) Quit:SQLCODE  Do
	.;m ^DHCMedComponent(ComponentName,"ITEM",Items)=PLIST
	.Set CNT=0
	.For MM=0:1:24 Do
		..Set ^DHCMedComponent(ComponentName,"ITEM",Items,CNT)=$g(PLIST(MM))
		..Set CNT=CNT+1	
	.For MM=26:1:45 Do
		..Set ^DHCMedComponent(ComponentName,"ITEM",Items,CNT)=$g(PLIST(MM))
		..Set CNT=CNT+1
	.For MM=47:1:62 Do
		..Set ^DHCMedComponent(ComponentName,"ITEM",Items,CNT)=$g(PLIST(MM))
		..Set CNT=CNT+1
	.Set Items=Items+1
	&SQL(CLOSE CompItn1)
	;
	Kill PLIST
	&SQL(DECLARE CompTan1 CURSOR FOR 
				SELECT * INTO :PLIST() FROM websys.ComponentTableItems 
				Where ParRef=:ComponentId)
	&SQL(OPEN CompTan1)
	Set Items=1
	For  &SQL(FETCH CompTan1) Quit:SQLCODE  Do
	.;m ^DHCMedComponent(ComponentName,"TABLE",Items)=PLIST
	.Set CNT=0
	.For MM=0:1:24 Do
		..Set ^DHCMedComponent(ComponentName,"TABLE",Items,CNT)=$g(PLIST(MM))
		..Set CNT=CNT+1
	.For MM=26:1:45 Do
		..Set ^DHCMedComponent(ComponentName,"TABLE",Items,CNT)=$g(PLIST(MM))
		..Set CNT=CNT+1
	.For MM=47:1:62 Do
		..Set ^DHCMedComponent(ComponentName,"TABLE",Items,CNT)=$g(PLIST(MM))
		..Set CNT=CNT+1
    .Set NestCompId=PLIST(40)           ;add by wuqk for NextComp 2008-03-27
	.Set NestCompName=""
	.if (NestCompId'="") d
	..&SQL(SELECT Name INTO :NestCompName FROM websys.Component WHERE ID=:NestCompId)
	.s ^DHCMedComponent(ComponentName,"TABLE",Items,"NestedComponent")=NestCompName
	.Set Items=Items+1
	&SQL(CLOSE CompTan1)
	;
	Kill PLIST
	&SQL(DECLARE CompMesn1 CURSOR FOR 
				SELECT * INTO :PLIST() FROM websys.ComponentMessages 
				Where ParRef=:ComponentId)
	&SQL(OPEN CompMesn1)
	Set Items=1
	For  &SQL(FETCH CompMesn1) Quit:SQLCODE  Do
	.m ^DHCMedComponent(ComponentName,"Messages",Items)=PLIST
	.Set Items=Items+1
	&SQL(CLOSE CompMesn1)
	;
	Set LayOut=##Class(websys.Preferences).GetData("SITE","DHCHealth","LAYOUT",ComponentId)
	Set LayOut=$LIST(LayOut,1) 
	m ^DHCMedComponent(ComponentName,"LAYOUT")=LayOut
	Quit ComponentId
}

ClassMethod GetComponentP8P7(ComponentName)
{
	;
	
	&SQL(SELECT ID INTO :ComponentId FROM websys.Component 
			WHERE Name=:ComponentName)
	If (ComponentId="") Quit -100
	Kill ^DHCMedComponent(ComponentName)
	;
	KILL PLIST
	&SQL(SELECT * INTO :PLIST() FROM websys.Component Where ID=:ComponentId)
	;m ^DHCMedComponent(ComponentName,"COMP")=PLIST
	Set CNT=0
	For MM=0:1:21 Do
		.Set ^DHCMedComponent(ComponentName,"COMP",CNT)=$g(PLIST(MM))
		.Set CNT=CNT+1
	For MM=24:1:49 Do
		.Set ^DHCMedComponent(ComponentName,"COMP",CNT)=$g(PLIST(MM))
		.Set CNT=CNT+1
	Set ^DHCMedComponent(ComponentName,"ID")=ComponentId
	;
	Kill PLIST
	&SQL(DECLARE CompItems87 CURSOR FOR 
				SELECT * INTO :PLIST() FROM websys.ComponentItems 
				Where ParRef=:ComponentId)
	&SQL(OPEN CompItems87)
	Set Items=1
	For  &SQL(FETCH CompItems87) Quit:SQLCODE  Do
	.m ^DHCMedComponent(ComponentName,"ITEM",Items)=PLIST
	.Set Items=Items+1
	&SQL(CLOSE CompItems87)
	;
	Kill PLIST
	&SQL(DECLARE CompTable87 CURSOR FOR 
				SELECT * INTO :PLIST() FROM websys.ComponentTableItems 
				Where ParRef=:ComponentId)
	&SQL(OPEN CompTable87)
	Set Items=1
	For  &SQL(FETCH CompTable87) Quit:SQLCODE  Do
	.m ^DHCMedComponent(ComponentName,"TABLE",Items)=PLIST
	.Set NestCompId=PLIST(40)           ;add by wuqk for NextComp 2008-03-27
	.Set NestCompName=""
	.if (NestCompId'="") d
	..&SQL(SELECT Name INTO :NestCompName FROM websys.Component WHERE ID=:NestCompId)
	.s ^DHCMedComponent(ComponentName,"TABLE",Items,"NestedComponent")=NestCompName
	.Set Items=Items+1
	&SQL(CLOSE CompTable87)
	;
	Kill PLIST
	&SQL(DECLARE CompMessage87 CURSOR FOR 
				SELECT * INTO :PLIST() FROM websys.ComponentMessages 
				Where ParRef=:ComponentId)
	&SQL(OPEN CompMessage87)
	Set Items=1
	For  &SQL(FETCH CompMessage87) Quit:SQLCODE  Do
	.m ^DHCMedComponent(ComponentName,"Messages",Items)=PLIST
	.Set Items=Items+1
	&SQL(CLOSE CompMessage87)
	;
	Set LayOut=##Class(websys.Preferences).GetData("SITE","DHCHEALTH","LAYOUT",ComponentId)
	Set LayOut=$LIST(LayOut,1) 
	m ^DHCMedComponent(ComponentName,"LAYOUT")=LayOut
	Quit ComponentId
}

ClassMethod GetComponentP8P5(ComponentName)
{
	;
	
	&SQL(SELECT ID INTO :ComponentId FROM websys.Component 
			WHERE Name=:ComponentName)
	If (ComponentId="") Quit -100
	Kill ^DHCMedComponent(ComponentName)
	;
	KILL PLIST
	&SQL(SELECT * INTO :PLIST() FROM websys.Component Where ID=:ComponentId)
	;m ^DHCMedComponent(ComponentName,"COMP")=PLIST
	Set CNT=0
	For MM=0:1:17 Do
		.Set ^DHCMedComponent(ComponentName,"COMP",CNT)=$g(PLIST(MM))
		.Set CNT=CNT+1
	For MM=19:1:21 Do
		.Set ^DHCMedComponent(ComponentName,"COMP",CNT)=$g(PLIST(MM))
		.Set CNT=CNT+1
	For MM=24:1:49 Do
		.Set ^DHCMedComponent(ComponentName,"COMP",CNT)=$g(PLIST(MM))
		.Set CNT=CNT+1
	Set ^DHCMedComponent(ComponentName,"ID")=ComponentId
	;
	Kill PLIST
	&SQL(DECLARE CompItn85 CURSOR FOR 
				SELECT * INTO :PLIST() FROM websys.ComponentItems 
				Where ParRef=:ComponentId)
	&SQL(OPEN CompItn85)
	Set Items=1
	For  &SQL(FETCH CompItn85) Quit:SQLCODE  Do
	.;m ^DHCMedComponent(ComponentName,"ITEM",Items)=PLIST
	.Set CNT=0
	.For MM=0:1:24 Do
		..Set ^DHCMedComponent(ComponentName,"ITEM",Items,CNT)=$g(PLIST(MM))
		..Set CNT=CNT+1	
	.For MM=26:1:45 Do
		..Set ^DHCMedComponent(ComponentName,"ITEM",Items,CNT)=$g(PLIST(MM))
		..Set CNT=CNT+1
	.For MM=47:1:62 Do
		..Set ^DHCMedComponent(ComponentName,"ITEM",Items,CNT)=$g(PLIST(MM))
		..Set CNT=CNT+1
	.Set Items=Items+1
	&SQL(CLOSE CompItn85)
	;
	Kill PLIST
	&SQL(DECLARE CompTan85 CURSOR FOR 
				SELECT * INTO :PLIST() FROM websys.ComponentTableItems 
				Where ParRef=:ComponentId)
	&SQL(OPEN CompTan85)
	Set Items=1
	For  &SQL(FETCH CompTan85) Quit:SQLCODE  Do
	.;m ^DHCMedComponent(ComponentName,"TABLE",Items)=PLIST
	.Set CNT=0
	.For MM=0:1:24 Do
		..Set ^DHCMedComponent(ComponentName,"TABLE",Items,CNT)=$g(PLIST(MM))
		..Set CNT=CNT+1
	.For MM=26:1:45 Do
		..Set ^DHCMedComponent(ComponentName,"TABLE",Items,CNT)=$g(PLIST(MM))
		..Set CNT=CNT+1
	.For MM=47:1:62 Do
		..Set ^DHCMedComponent(ComponentName,"TABLE",Items,CNT)=$g(PLIST(MM))
		..Set CNT=CNT+1
    .Set NestCompId=PLIST(40)           ;add by wuqk for NextComp 2008-03-27
	.Set NestCompName=""
	.if (NestCompId'="") d
	..&SQL(SELECT Name INTO :NestCompName FROM websys.Component WHERE ID=:NestCompId)
	.s ^DHCMedComponent(ComponentName,"TABLE",Items,"NestedComponent")=NestCompName
	.Set Items=Items+1
	&SQL(CLOSE CompTan85)
	;
	Kill PLIST
	&SQL(DECLARE CompMesn85 CURSOR FOR 
				SELECT * INTO :PLIST() FROM websys.ComponentMessages 
				Where ParRef=:ComponentId)
	&SQL(OPEN CompMesn85)
	Set Items=1
	For  &SQL(FETCH CompMesn85) Quit:SQLCODE  Do
	.m ^DHCMedComponent(ComponentName,"Messages",Items)=PLIST
	.Set Items=Items+1
	&SQL(CLOSE CompMesn85)
	;
	Set LayOut=##Class(websys.Preferences).GetData("SITE","DHCHEALTH","LAYOUT",ComponentId)
	Set LayOut=$LIST(LayOut,1) 
	m ^DHCMedComponent(ComponentName,"LAYOUT")=LayOut
	Quit ComponentId
}

ClassMethod GetComponentP8(ComponentName)
{
	;
	
	Set ComponentId=""
	&SQL(SELECT ID INTO :ComponentId FROM websys.Component 
			WHERE Name=:ComponentName)
	If (ComponentId="") Quit -100
	
	KILL PLIST
	&SQL(SELECT * INTO :PLIST() FROM websys.Component Where ID=:ComponentId)
	m ^DHCMedComponent(ComponentName,"COMP")=PLIST
	Set ^DHCMedComponent(ComponentName,"ID")=ComponentId
	;
	Kill PLIST
	&SQL(DECLARE CompItems8 CURSOR FOR 
				SELECT * INTO :PLIST() FROM websys.ComponentItems 
				Where ParRef=:ComponentId)
	&SQL(OPEN CompItems8)
	Set Items=1
	For  &SQL(FETCH CompItems8) Quit:SQLCODE  Do
	.m ^DHCMedComponent(ComponentName,"ITEM",Items)=PLIST
	.Set Items=Items+1
	&SQL(CLOSE CompItems8)
	;
	Kill PLIST
	&SQL(DECLARE CompTable8 CURSOR FOR 
				SELECT * INTO :PLIST() FROM websys.ComponentTableItems 
				Where ParRef=:ComponentId)
	&SQL(OPEN CompTable8)
	Set Items=1
	For  &SQL(FETCH CompTable8) Quit:SQLCODE  Do
	.m ^DHCMedComponent(ComponentName,"TABLE",Items)=PLIST
	.Set NestCompId=PLIST(40)           ;add by wuqk for NextComp 2008-03-27
	.Set NestCompName=""
	.if (NestCompId'="") d
	..&SQL(SELECT Name INTO :NestCompName FROM websys.Component WHERE ID=:NestCompId)
	.s ^DHCMedComponent(ComponentName,"TABLE",Items,"NestedComponent")=NestCompName
	.Set Items=Items+1
	&SQL(CLOSE CompTable8)
	;
	Kill PLIST
	&SQL(DECLARE CompMessage8 CURSOR FOR 
				SELECT * INTO :PLIST() FROM websys.ComponentMessages 
				Where ParRef=:ComponentId)
	&SQL(OPEN CompMessage8)
	Set Items=1
	For  &SQL(FETCH CompMessage8) Quit:SQLCODE  Do
	.m ^DHCMedComponent(ComponentName,"Messages",Items)=PLIST
	.Set Items=Items+1
	&SQL(CLOSE CompMessage8)
	;
	Set LayOut=##Class(websys.Preferences).GetData("SITE","DHCHEALTH","LAYOUT",ComponentId)
	Set LayOut=$LIST(LayOut,1) 
	m ^DHCMedComponent(ComponentName,"LAYOUT")=LayOut
	Quit ComponentId
}

}
