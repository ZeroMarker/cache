Import SQLUser

Class web.DHCMedWMRPUBLIC Extends (%Library.RegisteredObject, websys.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 49;

ClassMethod QueryLocListByDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLocListByDepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryLocListByDepExecute(ByRef qHandle As %Binary, CTLOCDepDR As %String, Str As %String, LocDesc As %String) As %Status
{
	//用于cboBox
	//根据DepDr查科室，DepDr为空查全部
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	i Str'="" d
	.s s=$p(Str,"^",1)_"^"_$p(Str,"^",2)
	.d BuildData
	i CTLOCDepDR'="" d
    .q:'$d(^CTLOC(0,"DepGrp",CTLOCDepDR))
    .s tmpid=0  f  s tmpid=$o(^CTLOC(0,"DepGrp",CTLOCDepDR,tmpid)) q:tmpid=""  d
	..q:'$d(^CTLOC(+tmpid))
    ..s locdesc=$p($g(^CTLOC(+tmpid)),"^",2)
    ..q:((LocDesc'="")||(locdesc '[ LocDesc))
    ..s s=+tmpid_"^"_locdesc
	..d BuildData
	e  d
	.s tmpid=0 f  s tmpid=$o(^CTLOC(tmpid)) q:tmpid=""  d
	..q:'$d(^CTLOC(+tmpid))
    ..s locdesc=$p($g(^CTLOC(+tmpid)),"^",2)
    ..q:((LocDesc'="")||(locdesc '[ LocDesc))
    ..s s=+tmpid_"^"_locdesc
	..d BuildData
	Quit $$$OK

BuildData
	set Data=$lb("")
 	f iBuild=1:1:$l(s,"^") d
 	.s $li(Data,iBuild)=$p(s,"^",iBuild)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryLocListByDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocListByDepExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 用于科室Combox的查询
Query QueryLocListByDep(CTLOCDepDR As %String, Str As %String, LocDesc As %String) As %Query(ROWSPEC = "ctlocid:%String,ctloc:%String")
{
}

ClassMethod QueryLoctionByDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLoctionByDescExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryLoctionByDescExecute(ByRef qHandle As %Binary, Desc As %String) As %Status
{
	//用于TextBox
	//根据首字母查询
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	s Desc=$$ALPHAUP^SSUTIL4(Desc)
	s len=$l(Desc)
	s Id=0
	f  s Id=$o(^CTLOC(Id)) q:Id=""  d
	.q:'$d(^CTLOC(+Id))
    .s LocDesc=$p($g(^CTLOC(+Id)),"^",2)
    .s LocDescAlphaUp=$$ALPHAUP^SSUTIL4(LocDesc)
    .q:((Desc'="")&&($e(LocDescAlphaUp,1,len)'=Desc))
    .s s=+Id_"^"_LocDesc
	.d BuildData
	Quit $$$OK
}

ClassMethod QueryLoctionByDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLoctionByDescExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 用于科室TextBox的查询
Query QueryLoctionByDesc(Desc As %String) As %Query(ROWSPEC = "ctlocid:%String,ctloc:%String")
{
}

ClassMethod QueryWardByDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryWardByDescExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryWardByDescExecute(ByRef qHandle As %Binary, Desc As %String) As %Status
{
	//用于TextBox
	//根据首字母查询
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	s Desc=$$ALPHAUP^SSUTIL4(Desc)
	s len=$l(Desc)
	s Id=0
	f  s Id=$o(^CTLOC(Id)) q:Id=""  d
	.q:'$d(^CTLOC(+Id))
    .s LocDesc=$p($g(^CTLOC(+Id)),"^",2)
    .q:((Desc'="")&&($e(LocDesc,1,len)'=Desc))
    .s LocType=$p($g(^CTLOC(+Id)),"^",13)
    .q:LocType'="W"
    .s s=+Id_"^"_LocDesc
	.d BuildData
	Quit $$$OK
}

ClassMethod QueryWardByDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryWardByDescExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 用于科室TextBox的查询
Query QueryWardByDesc(Desc As %String) As %Query(ROWSPEC = "ctlocid:%String,ctloc:%String")
{
}

ClassMethod GetUserInfo(UserID)
{
	n (UserID)
	q:UserID="" ""
	s s=UserID_"^"_$g(^SSU("SSUSR",UserID))
	q s
}

ClassMethod GetLocInfo(LocID)
{
	n (LocID)
	q:LocID="" ""
	s s=LocID_"^"_$g(^CTLOC(LocID))
	q s
}

/*
ClassMethod clsWMRBarCode()
{
	s s="<OBJECT ID='clsWMRBarCode' CLASSID='CLSID:7826FC92-0551-4534-888A-AFE78F040000' CODEBASE='../addins/client/DHCMedWebPackage.CAB#version=1,1,0,55'> <SPAN STYLE='color:red'>ActiveX control failed to load!</SPAN> </OBJECT>"
	q s
}

ClassMethod clsPrinter()
{
	s s="<OBJECT ID='clsPrinter' CLASSID='CLSID:64E79B36-8BD1-48C5-90D8-841C2AB93DD6' CODEBASE='../addins/client/VBPrinter.CAB#version=1,1,0,0'> <SPAN STYLE='color:red'>ActiveX control failed to load!</SPAN> </OBJECT>"
	//s s="<OBJECT ID='clsPrinter' CLASSID='CLSID:5BCF2928-885E-4D15-9280-7209705C8CFD' CODEBASE='../addins/client/DHCMedWebPackage.CAB#version=1,1,0,55'> <SPAN STYLE='color:red'>ActiveX control failed to load!</SPAN> </OBJECT>"
	q s
}

ClassMethod clsDHCMedWebCommon()
{
	s s="<OBJECT ID='cls_DHCMedWebCommon' CLASSID='CLSID:A4AB98AE-A176-4DB7-BCEB-731402535C88' CODEBASE='../addins/client/DHCMedWebPackage.CAB#version=1,1,0,55'>  <SPAN STYLE='color:red'>ActiveX control failed to load!</SPAN> </OBJECT>"
	q s
}

ClassMethod clsPinYin()
{
	s s="<OBJECT ID='clsPinYin' CLASSID='CLSID:0D7458A0-F944-499B-B379-250B8056C503' CODEBASE='../addins/client/DHCMedWebPackage.CAB#version=1,1,0,55'><SPAN STYLE='color:red'>ActiveX control failed to load!</SPAN> </OBJECT>"
	q s
}
*/
ClassMethod clsWMRBarCode()
{
	s s="<OBJECT ID='clsWMRBarCode' CLASSID='CLSID:DBD01ED7-E82C-48DB-867F-2D3E0857DADC' CODEBASE='../addins/client/DHCMedWebPackage.CAB#version=1,1,0,69'> <SPAN STYLE='color:red'>ActiveX control failed to load!</SPAN> </OBJECT>"
	q s
}

ClassMethod clsPrinter()
{
	s s="<OBJECT ID='clsPrinter' CLASSID='CLSID:64E79B36-8BD1-48C5-90D8-841C2AB93DD6' CODEBASE='../addins/client/VBPrinter.CAB#version=1,1,0,0'> <SPAN STYLE='color:red'>ActiveX control failed to load!</SPAN> </OBJECT>"
	//s s="<OBJECT ID='clsPrinter' CLASSID='CLSID:5BCF2928-885E-4D15-9280-7209705C8CFD' CODEBASE='../addins/client/DHCMedWebPackage.CAB#version=1,1,0,55'> <SPAN STYLE='color:red'>ActiveX control failed to load!</SPAN> </OBJECT>"
	q s
}

ClassMethod clsDHCMedWebCommon()
{
	s s="<OBJECT ID='cls_DHCMedWebCommon' CLASSID='CLSID:54CD1CC4-0C18-4207-BED0-DE87D6239DE2' CODEBASE='../addins/client/DHCMedWebPackage.CAB#version=1,1,0,69'>  <SPAN STYLE='color:red'>ActiveX control failed to load!</SPAN> </OBJECT>"
	q s
}

ClassMethod clsPinYin()
{
	s s="<OBJECT ID='clsPinYin' CLASSID='CLSID:01374624-5099-4E25-89C7-AFA5AEFC959C' CODEBASE='../addins/client/DHCMedWebPackage.CAB#version=1,1,0,69'><SPAN STYLE='color:red'>ActiveX control failed to load!</SPAN> </OBJECT>"
	q s
}

}
