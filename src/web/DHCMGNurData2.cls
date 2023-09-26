Class web.DHCMGNurData2 Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage127() As %Status
{
 //w "[{text:'fold2',id:'fold2',leaf:false,children:[{text:'itm21',id:'itm21',leaf:false,children:[{text:'ver211',id:'ver211',leaf:true}]},{text:'itm22',id:'itm22',leaf:false,children:[{text:'ver221',id:'ver221',leaf:true}]}]}]"}
	i $D(%session) s Loc=$G(%session.Data("LOGON.CTLOCID"))
	e  s Loc=""
	s DepModelStr=##class(web.DHCNurseRecordComm).GetDepModel(Loc)
	w "["
	for ii=1:1:$L(DepModelStr,"^")
	{
		s DepModel=$P(DepModelStr,"^",ii)
		if DepModel="" continue
		w "{text:'"_$P(DepModel,"|",2)_"',id:'"_$P(DepModel,"|",1)_"',leaf:true}"
		if ii<($L(DepModelStr,"^")-1) w ","
	}
	w "]"
	 Quit $$$OK
}

ClassMethod OnPage() As %Status
{
    //w "[{text:'fold2',id:'fold2',leaf:false,children:[{text:'itm21',id:'itm21',leaf:false,children:[{text:'ver211',id:'ver211',leaf:true}]},{text:'itm22',id:'itm22',leaf:false,children:[{text:'ver221',id:'ver221',leaf:true}]}]}]"}
	s EpisodeID=%request.Get("EpisodeID")
	i $D(%session) s Loc=$G(%session.Data("LOGON.CTLOCID"))
	//e  s Loc=""
	e  s Loc=%request.Get("Loc")
	s ^objcyf888333(EpisodeID)=EpisodeID_"^"_Loc
	s DepModelStr=##class(web.DHCNurseRecordComm).GetDepModel(Loc)
	w "["
	for ii=1:1:$L(DepModelStr,"^")
	{
		s DepModel=$P(DepModelStr,"^",ii)
		if DepModel="" continue	
		s EmrCode=$P(DepModel,"|",1)
		s LocDesc=$p(^CTLOC(Loc),"^",2)
		s ^objcyf4445(EmrCode)=LocDesc
		s flag=0
		//i (LocDesc["病房")
		//{
		s flag=..GetModelDataStatus(EpisodeID,EmrCode)
		//}
		//else
		//{
		if (flag'=0) s DepModel=DepModel_":"_flag
		//}
		
		if (flag=0)
		{	 
	    w "{text:'"_$P(DepModel,"|",2)_"',id:'"_$P(DepModel,"|",1)_"',leaf:true}"
		}
		else
		{
		w "{text:'"_$P(DepModel,"|",2)_"',id:'"_$P(DepModel,"|",1)_"',leaf:true,icon:'../scripts/nurse/image/save.gif'}"
		}
		if ii<($L(DepModelStr,"^")-1) w ","
	}
	w "]"
    Quit $$$OK
}

ClassMethod GetModelDataStatus(EpisodeID, EmrCode) As %String
{
	//w ##class(web.DHCMGNurData2).GetModelDataStatus("12","DHCNURXH_tsxt")
	s ret=0
	s ^objcyfds(EpisodeID,EmrCode)=""
	if (EpisodeID'="")&&(EmrCode'="")
	{
	 s code=$ZConvert(EmrCode,"U")
	 s EmrCode=$ZConvert(EmrCode,"U")
	 i code="DHCNURANHUISPLIST" s code="DHCNURANHUI21"
	 i code="DHCNURXHSBLIST_FKSS" s EmrCode="DHCNURXH_FKSS2"
	 i code="DHCNURLIST_FFYC" s code="DHCNURXHFFYC"
	 i code="DHCNURLIST_DDZC" s code="DHCNURXHFFDD"
	 i code="DHCNURXHLIST_YTCRL" s EmrCode="DHCNURXH_YTCRL"
	 s id=""
	 s DHCMoudid=""  f  s DHCMoudid=$O(^Nur.DHCMoudDataI("EmrCode"," "_code," "_EpisodeID,DHCMoudid)) q:DHCMoudid=""  d
	 .i DHCMoudid'="" d
	 ..s b=##class(Nur.DHCMoudData).%OpenId(DHCMoudid)
	 ..s EmrDate=b.EmrDate
	 ..s EmrDate=$zd(EmrDate,3)
	 ..b ;3
	 ..i code="DHCNURXHFFYC" d
	 ...s Item12=b.Item12
	 ...s Item13=b.Item13
	 ...s Item14=b.Item14
	 ...s Item70=b.Item70
	 ...s Item71=b.Item71
	 ...i Item12'="" s EmrDate=Item12
	 ...i Item13'="" s EmrDate=Item13
     ...i Item14'="" s EmrDate=Item14
	 ...i Item70'="" s EmrDate=Item70
	 ...i Item71'="" s EmrDate=Item71
	 ..i code="DHCNURXHFFDD" d
	 ...s Item12=b.Item12
	 ...s Item13=b.Item13
	 ...s Item14=b.Item14
	 ...s Item68=b.Item68
	 ...s Item69=b.Item69
	 ...i Item12'="" s EmrDate=Item12
	 ...i Item13'="" s EmrDate=Item13
     ...i Item14'="" s EmrDate=Item14
	 ...i Item68'="" s EmrDate=Item68
	 ...i Item69'="" s EmrDate=Item69
	 
	 ..i (b.RecCancelUser="") s id=EmrDate
	 ..b 
	 s par=""  s par=$O(^Nur.DHCNurseRecParentI("Episode"," "_EpisodeID,par))
	 if par'=""
	 {
	 s rw="" f  s rw=$o(^Nur.DHCNurseRecSubD(par,rw),1) q:(rw="")!(id'="")  d
	 .s tmp("Id")=par_"||"_rw
	 .s a=##class(Nur.DHCNurseRecSub).%OpenId(tmp("Id"))
	 .s CareDate=a.CareDate
	 .s CareDate=$zd(CareDate,3)
	 .s typ=a.RecTyp
	 .s typ=$ZConvert(typ,"U")
	 .i (typ=EmrCode)&&(a.RecCancelUser="") s id=CareDate
	 }	 
	 b ;44
	 if (EmrCode="DHCNURPFLIST")&(par'="")
	 {
		 //s id=""
		 s p="" f  s p=$O(^Nur.DHCMoudDataI("EmrCode"," DHCNURPFB"," "_EpisodeID,p),1) q:(p="")!(id'="")  d
 	     .s chl=""  f  s chl=$O(^Nur.DHCMoudDataD(p,"ChildRec",chl),1) q:(chl="")!(id'="")  d
 	     ..s a=##class(Nur.DHCMoudDataSub).%OpenId(p_"||"_chl)
 	     ..s canceluser=a.RecCancelUser
 	     ..q:(canceluser'="")
         ..s Item20=a.Item20
         ..s RecDate=a.EmrDate
         ..i Item20="" s Item20=$zd(RecDate,3)
         ..s id=Item20
	 }
	 b ;88
	}
	i id'="" s ret=id
	q ret
}

ClassMethod PrintLinkFile()
{
 //d ##class(web.DHCMGNurData).PrintLinkFile()
 w !,"<link rel=""stylesheet"" type=""text/css"" href=""../scripts/nurse/ext-3.1.1/resources/css/ext-all.css"" />"

 w !,"<script type=""text/javascript"" src=""../scripts/nurse/ext-3.1.1/adapter/ext/ext-base.js""></script>"
 w !,"<script type=""text/javascript"" src=""../scripts/nurse/ext-3.1.1/ext-all.js""></script>"
 w !,"<link rel=""stylesheet"" type=""text/css"" href=""../scripts/nurse/ext-3.1.1/resources/css/desktop.css"" />"
 w !, "<link rel=""stylesheet"" type=""text/css"" href=""../scripts/nurse/ext-3.1.1/resources/css/GroupHeaderPlugin.css"" />"
 w !,"<script type=""text/javascript"" src=""../scripts/nurse/ext-3.1.1/GroupHeaderPlugin.js""></script>"

 w !,"<script type=""text/javascript"" src=""../scripts/nurse/ext-3.1.1/PLU/Multiselect/js/Ext.ux.util.js""></script>"
 w !,"<script type=""text/javascript"" src=""../scripts/nurse/ext-3.1.1/PLU/Multiselect/js/Ext.ux.form.LovCombo.js""></script>"
 w !,"<link rel=""stylesheet"" type=""text/css"" href=""../scripts/nurse/ext-3.1.1/PLU/Multiselect/css/Ext.ux.form.LovCombo.css"" />"
}

ClassMethod PrintLinkFile1()
{
 w !,"<link rel=""stylesheet"" type=""text/css"" href=""../ext-3.1.1/resources/css/ext-all.css"" />"

 w !,"<script type=""text/javascript"" src=""../ext-3.1.1/adapter/ext/ext-base.js""></script>"
 w !,"<script type=""text/javascript"" src=""../ext-3.1.1/ext-all.js""></script>"
 w !,"<link rel=""stylesheet"" type=""text/css"" href=""../ext-3.1.1/resources/css/desktop.css"" />"
 w !, "<link rel=""stylesheet"" type=""text/css"" href=""../Ext.ux.form.LovCombo.css"" />"
 w !, "<link rel=""stylesheet"" type=""text/css"" href=""../ext-3.1.1/resources/css/GroupHeaderPlugin.css"" />"
 w !,"<link rel=""stylesheet"" type=""text/css"" href=""lovcombo.css"" />"
 w !,"<script type=""text/javascript"" src=""../ext-3.1.1/GroupHeaderPlugin.js""></script>"
 w !,"<script type=""text/javascript"" src=""../Ext.ux.util.js""></script>"
 w !,"<script type=""text/javascript"" src=""../Ext.ux.form.LovCombo.js""></script>"
}

ClassMethod getEncrypt(itm) As %String
{
 //w ##class(web.DHCMGNurData).getEncrypt()
	q ##Class(websys.Page).Encrypt($lb(itm))
}

}
