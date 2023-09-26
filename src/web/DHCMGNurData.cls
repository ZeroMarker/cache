Class web.DHCMGNurData Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
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

ClassMethod OnPage127() As %Status
{
    //w "[{text:'fold2',id:'fold2',leaf:false,children:[{text:'itm21',id:'itm21',leaf:false,children:[{text:'ver211',id:'ver211',leaf:true}]},{text:'itm22',id:'itm22',leaf:false,children:[{text:'ver221',id:'ver221',leaf:true}]}]}]"}
	s EpisodeID=%request.Get("EpisodeID")
	i $D(%session) s Loc=$G(%session.Data("LOGON.CTLOCID"))
	//e  s Loc=""
	e  s Loc=%request.Get("Loc")
	s ^objcyf444(Loc)=EpisodeID
	s DepModelStr=##class(web.DHCNurseRecordComm).GetDepModel(Loc)
	w "["
	for ii=1:1:$L(DepModelStr,"^")
	{
		s DepModel=$P(DepModelStr,"^",ii)
		if DepModel="" continue	
		s EmrCode=$P(DepModel,"|",1)
		s LocDesc=$p(^CTLOC(Loc),"^",2)
		s ^objcyf4445(EmrCode)=LocDesc
		i (LocDesc["病房")
		{
		s flag=..GetModelDataStatus(EpisodeID,EmrCode)
		}
		else
		{
		s flag=0
		}
		
		if (flag=0)
		{	 
	    w "{text:'"_$P(DepModel,"|",2)_"',id:'"_$P(DepModel,"|",1)_"',leaf:true}"
		}
		else
		{
		w "{text:'"_$P(DepModel,"|",2)_"',id:'"_$P(DepModel,"|",1)_"',leaf:true,icon:'../image/saved.gif'}"
		}
		if ii<($L(DepModelStr,"^")-1) w ","
	}
	w "]"
    Quit $$$OK
}

ClassMethod GetModelDataStatus(EpisodeID, EmrCode) As %String
{
	//w ##class(web.DHCMGNurData).GetModelDataStatus(11062752,"DHCNURANHUISPLIST")
	s ret=0
	if (EpisodeID'="")&&(EmrCode'="")
	{
	 s code=$ZConvert(EmrCode,"U")
	 i code="DHCNURANHUISPLIST" s code="DHCNURANHUI21"
	 //s ^fuckwxy(EpisodeID,code)=code
	 //s id=""  s id=$O(^Nur.DHCMoudDataI("EmrCode"," "_code," "_EpisodeID,id))
	 s id=""
	 s DHCMoudid=""  f  s DHCMoudid=$O(^Nur.DHCMoudDataI("EmrCode"," "_code," "_EpisodeID,DHCMoudid)) q:DHCMoudid=""  d
	 .i DHCMoudid'="" d
	 ..s b=##class(Nur.DHCMoudData).%OpenId(DHCMoudid)
	 ..i (b.RecCancelUser="") s id=DHCMoudid
	 
	 s par=""  s par=$O(^Nur.DHCNurseRecParentI("Episode"," "_EpisodeID,par))
	 if par'=""
	 {
	 s rw="" f  s rw=$o(^Nur.DHCNurseRecSubD(par,rw)) q:rw=""  d
	 .s tmp("Id")=par_"||"_rw
	 .s a=##class(Nur.DHCNurseRecSub).%OpenId(tmp("Id"))
	 .//w !,a.RecTyp_"^"_a.RecCancelUser
	 .i (a.RecTyp=EmrCode)&&(a.RecCancelUser="") s id=tmp("Id")
	 }	 
	}
	i id'="" s ret=1
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
 w !,"<link rel=""stylesheet"" type=""text/css"" href=""../skin/default/css/websys.ext.3.1.1.css"" />"
    //////
 w !," "_"<script type='text/javascript'>"
	;w !,"Ext.BLANK_IMAGE_URL='"_pre_..#pExtLibPath_"ext3.2.1/resources/images/default/s.gif';"
	Set format = ##class(websys.Conversions).DateFormat()
	If (format=3){ 
		Set format="Y-m-d"
	} elseif(format=4){
		Set format = "d/m/Y"
	}
	w !," "_"websys_DateFormat='"_format_"';"
	w !," "_"if(Ext.util.Format){"
	w !," "_"   Ext.util.Format.date = function(v, format){"
	w !," "_"      if(!v) return """";"
	w !," "_"      if(!(v instanceof Date)) v = new Date(Date.parse(v));"
	w !," "_"      return v.dateFormat(format || websys_DateFormat);"
	w !," "_"   };"
	w !," "_"}"
	w !," "_"if(Ext.DatePicker){"
	w !," "_"   Ext.apply(Ext.DatePicker.prototype, {"
	w !," "_"      format:websys_DateFormat"
	w !," "_"   });"
	w !," "_"}"
	w !," "_"if(Ext.form.DateField) {"
	w !," "_"	Ext.apply(Ext.form.DateField.prototype,{format: websys_DateFormat});"
	w !," "_"}"
	w !," "_"</script>"
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
