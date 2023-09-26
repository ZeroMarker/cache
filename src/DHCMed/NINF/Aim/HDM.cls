Class DHCMed.NINF.Aim.HDM Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 临床上报表ID
Property CRReportDR As %String(TRUNCATE = 1) [ Required ];

Index CRReportDR On CRReportDR [ Unique ];

/// 是否感染
Property IfInfection As %String(TRUNCATE = 1);

/// 感染类型
Property InfType As %String(TRUNCATE = 1);

/// 医院感染部位
Property HosInfPos As %String(TRUNCATE = 1);

/// 医院感染部位对应病原体
Property HosInfObj As %String(TRUNCATE = 1);

/// 社区感染部位
Property SocInfPos As %String(TRUNCATE = 1);

/// 社区感染部位对应病原体
Property SocInfObj As %String(TRUNCATE = 1);

/// 泌尿道有无插管
Property UricPipe As %String(TRUNCATE = 1);

/// 泌尿道感染前48小时有泌尿道插管
Property UricPipeInf48 As %String(TRUNCATE = 1);

/// 动静脉有无插管
Property AVPipe As %String(TRUNCATE = 1);

/// 血流感染前48有无动静脉插管
Property AVPipeInf48 As %String(TRUNCATE = 1);

/// 气管有无切开
Property TrachealCut As %String(TRUNCATE = 1);

/// 肺部感染前48小时是否有气管切开
Property TrachealCutInf48 As %String(TRUNCATE = 1);

/// 是否使用呼吸机
Property BrethMachine As %String;

/// 肺部感染前48小时是否使用过呼吸机
Property BrethMachineInf48 As %String(TRUNCATE = 1);

/// 是否进行过血液透析
Property BloodDialysis As %String(TRUNCATE = 1);

/// 是否使用过抗菌药物
Property AntiUsed As %String(TRUNCATE = 1);

/// 抗生素名称
Property AntiName As %String(TRUNCATE = 1);

/// 目的
Property Aim As %String(TRUNCATE = 1);

/// 联用
Property UniteDrug As %String(TRUNCATE = 1);

/// 治疗用药已送培养
Property AntiToLis As %String(TRUNCATE = 1);

/// 调查者
Property CheckUser As %String(TRUNCATE = 1);

/// 调查日期
Property checkDate As %String;

Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..CRReportDR_separete
	set return=return_..IfInfection _separete
	set return=return_..InfType_separete
	set return=return_..HosInfPos_separete
	set return=return_..HosInfObj_separete
	set return=return_..SocInfPos_separete
	set return=return_..SocInfObj_separete
	set return=return_..UricPipe_separete
	set return=return_..UricPipeInf48_separete
	set return=return_..AVPipe_separete
	set return=return_..AVPipeInf48_separete
	set return=return_..TrachealCut_separete
	set return=return_..TrachealCutInf48_separete
	set return=return_..BrethMachine_separete
	set return=return_..BrethMachineInf48_separete
	set return=return_..BloodDialysis_separete
	set return=return_..AntiUsed_separete
	set return=return_..AntiName_separete
	set return=return_..Aim_separete
	set return=return_..UniteDrug_separete
	set return=return_..AntiToLis_separete
	set return=return_..CheckUser_separete
	set return=return_..checkDate
	

	quit return
}

/// w ##class(DHCMed.NINF.Aim.HDM).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.NINF.Aim.HDM
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.NINF.Aim.HDM).%ExistsId(+id) return
	set obj=##Class(DHCMed.NINF.Aim.HDM).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// w ##class(DHCMed.NINF.Aim.HDM).GetStringById(1)
ClassMethod GetStringById(id As %String, separete As %String) As %String
{
	new (id,separete)
	set return=""
	set obj=..GetObjById(id)
	if $IsObject(obj){
		set return=obj.ToString($g(separete))
	}	
	quit return
}

/// d ##class(DHCMed.NINF.Aim.HDM).Update(^2^3^4^^^^^^)
ClassMethod Update(InStr As %String) As %String
{
	new (InStr)
	set id=0
	set ID=$p(InStr,"^",1)	
	if ID="" {
		set obj=##class(DHCMed.NINF.Aim.HDM).%New()
		} 
	else {
		set obj=##class(DHCMed.NINF.Aim.HDM).%OpenId(ID)
		}
	set obj.CRReportDR= $p(InStr,"^",2)
	set obj.IfInfection  = $p(InStr,"^",3)
	set obj.InfType = $p(InStr,"^",4)
	set obj.HosInfPos = $p(InStr,"^",5)
	set obj.HosInfObj = $p(InStr,"^",6)
	set obj.SocInfPos = $p(InStr,"^",7)
	set obj.SocInfObj = $p(InStr,"^",8)
	set obj.UricPipe =$p(InStr,"^",9)
	set obj.UricPipeInf48 =$p(InStr,"^",10)
	set obj.AVPipe =$p(InStr,"^",11)
	set obj.AVPipeInf48 =$p(InStr,"^",12)
	set obj.TrachealCut =$p(InStr,"^",13)
	set obj.TrachealCutInf48 =$p(InStr,"^",14)
	set obj.BrethMachine =$p(InStr,"^",15)
	set obj.BrethMachineInf48 =$p(InStr,"^",16)
	set obj.BloodDialysis =$p(InStr,"^",17)
	set obj.AntiUsed =$p(InStr,"^",18)
	set obj.AntiName =$p(InStr,"^",19)
	set obj.Aim =$p(InStr,"^",20)
	set obj.UniteDrug =$p(InStr,"^",21)
	set obj.AntiToLis =$p(InStr,"^",22)
	set obj.CheckUser =$p(InStr,"^",23)
	set obj.checkDate =$p(InStr,"^",24)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}
	else{
		set id=obj.%Id()
		}
	do obj.%Close()
	quit id
}

ClassMethod DeleteById(Id As %String) As %String
{
	new (Id)
	set sc = ##class(DHCMed.NINF.Aim.HDM).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

/// w ##class(DHCMed.NINF.Aim.HDM).UpdateDataFromEPR("104")
ClassMethod UpdateDataFromEPR(CRReportDR As %String) As %String
{
	n (CRReportDR)
	s ret=-1
	
	q:CRReportDR="" ret
	s RepID=""
	i $d(^DHCMed.NINF.Aim.HDMI("CRReportDR"," "_CRReportDR)) d
	.s RepID=$o(^DHCMed.NINF.Aim.HDMI("CRReportDR"," "_CRReportDR,""),-1)

	s objCRReport=##class(DHCMed.CR.Report).%OpenId(CRReportDR)
	q:'$IsObject(objCRReport)
	s EpisodeID=objCRReport.EpisodeID
	s InstanceDataID=objCRReport.InstanceID
	q:(EpisodeID="")||(InstanceDataID="") ret
	
	s TID=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("INFHDMTIDValue","")
	q:TID="" $$$OK
	
	s tmp = RepID
	s tmp = tmp _ "^" _ CRReportDR	
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"感染O0013#TYPE:Simple#TID:"_TID_"#TVER:0#SCODE:O0013#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"感染分类O0014#TYPE:Simple#TID:"_TID_"#TVER:0#SCODE:O0014#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"横断面报告.医院感染.感染部位：#TYPE:Table#TID:"_TID_"#TVER:0#TCODE:T0016#SCODE:O0017#ROWNO:0#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"横断面报告.医院感染.病原体: #TYPE:Table#TID:"_TID_"#TVER:0#TCODE:T0016#SCODE:M0020#ROWNO:0#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"横断面报告.社区感染.感染部位: #TYPE:Table#TID:"_TID_"#TVER:0#TCODE:T0030#SCODE:O0031#ROWNO:0#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"横断面报告.社区感染.病原体： #TYPE:Table#TID:"_TID_"#TVER:0#TCODE:T0030#SCODE:M0032#ROWNO:0#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"泌尿道插管O0021#TYPE:Simple#TID:"_TID_"#TVER:0#SCODE:O0021#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"泌尿道感染前48h内有泌尿道插管O0022#TYPE:Simple#TID:"_TID_"#TVER:0#SCODE:O0022#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"动静脉插管O0023#TYPE:Simple#TID:"_TID_"#TVER:0#SCODE:O0023#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"血流感染前48h内有动静脉插管O0024#TYPE:Simple#TID:"_TID_"#TVER:0#SCODE:O0024#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"气管切开O0025#TYPE:Simple#TID:"_TID_"#TVER:0#SCODE:O0025#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"肺部感染前48h内有气管切开O0026#TYPE:Simple#TID:"_TID_"#TVER:0#SCODE:O0026#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"使用呼吸机O0027#TYPE:Simple#TID:"_TID_"#TVER:0#SCODE:O0027#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"肺部感染前48h内有使用呼吸机O0028#TYPE:Simple#TID:"_TID_"#TVER:0#SCODE:O0028#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"血液透析 O0029#TYPE:Simple#TID:"_TID_"#TVER:0#SCODE:O0029#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"抗菌药物使用O0033#TYPE:Simple#TID:"_TID_"#TVER:0#SCODE:O0033#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"名称G0034抗生素.M0040^#TYPE:SegmentSimple#TID:"_TID_"#TVER:0#TCODE:G0034#SCODE:M0040#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"目的O0035#TYPE:Simple#TID:"_TID_"#TVER:0#SCODE:O0035#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"联用O0036#TYPE:Simple#TID:"_TID_"#TVER:0#SCODE:O0036#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"治疗用药已送细菌培养O0037#TYPE:Simple#TID:"_TID_"#TVER:0#SCODE:O0037#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"调查者S0038#TYPE:Simple#TID:"_TID_"#TVER:0#SCODE:S0038#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"调查日期D0039#TYPE:Simple#TID:"_TID_"#TVER:0#SCODE:D0039#VTYPE:V",InstanceDataID)
	
	s ret=..Update(tmp)
	
	q ret
}

ClassMethod GetDataFromEPR(EpisodeID As %String, ItemPara As %String, InstanceDataID As %String) As %String
{
	n (EpisodeID, ItemPara ,InstanceDataID)
	
	s ret=##class(EPRservice.BOScatterData).GetEPRMultipleData(EpisodeID, ItemPara ,InstanceDataID)
	
	q ret
}

/*
/// 判断是否存在 导尿 医嘱
/// w ##class(DHCMed.NINF.Aim.HDM).GetMNDOrderByPaadm(2986516)
ClassMethod GetMNDOrderByPaadm(Paadm As %String) As %String
{
	n (Paadm)
	
	s IfMNDDipe="无",flg=-1
 	q:+Paadm=0 $$$OK

    q:'$d(^OEORD(0,"Adm",+Paadm)) IfMNDDipe
    s oeord=$o(^OEORD(0,"Adm",+Paadm,"")) 
    s arcim=""
    f  s arcim=$o(^OEORDi(0,"ARCIM",+oeord,arcim),-1) q:(arcim="")||(flg=1)  d
    .s objCls=##class(DHCMed.Base.Arcim).GetObjById(arcim)
    .q:'$IsObject(objCls)
    .s ARCIMDesc=objCls.ARCIMDesc
    .s:ARCIMDesc["导尿" flg=1	
	
	s:flg=1 IfMNDDipe="有"
	
	q IfMNDDipe
}

/// 判断是否存在 中心静脉和动脉穿刺 医嘱
/// w ##class(DHCMed.NINF.Aim.HDM).GetZXJMOrderByPaadm(2986516)
ClassMethod GetZXJMOrderByPaadm(Paadm As %String) As %String
{
	n (Paadm)
	
	s ret="无",flg=-1
 	q:+Paadm=0 $$$OK

    q:'$d(^OEORD(0,"Adm",+Paadm)) ret
    s oeord=$o(^OEORD(0,"Adm",+Paadm,"")) 
    s arcim=""
    f  s arcim=$o(^OEORDi(0,"ARCIM",+oeord,arcim),-1) q:(arcim="")||(flg=1)  d
    .s objCls=##class(DHCMed.Base.Arcim).GetObjById(arcim)
    .q:'$IsObject(objCls)
    .s ARCIMDesc=objCls.ARCIMDesc
    .s:(ARCIMDesc["中心静脉")||(ARCIMDesc["动脉穿刺") flg=1	
	
	s:flg=1 ret="有"
	
	q ret
}

/// 判断是否存在 气管切开 医嘱
/// w ##class(DHCMed.NINF.Aim.HDM).GetQGQKOrderByPaadm(2986516)
ClassMethod GetQGQKOrderByPaadm(Paadm As %String) As %String
{
	n (Paadm)
	
	s ret="无",flg=-1
 	q:+Paadm=0 $$$OK

    q:'$d(^OEORD(0,"Adm",+Paadm)) ret
    s oeord=$o(^OEORD(0,"Adm",+Paadm,"")) 
    s arcim=""
    f  s arcim=$o(^OEORDi(0,"ARCIM",+oeord,arcim),-1) q:(arcim="")||(flg=1)  d
    .s objCls=##class(DHCMed.Base.Arcim).GetObjById(arcim)
    .q:'$IsObject(objCls)
    .s ARCIMDesc=objCls.ARCIMDesc
    .s:ARCIMDesc["气管切开" flg=1	
	
	s:flg=1 ret="有"
	
	q ret
}

/// 判断是否存在 呼吸机辅助呼吸 医嘱
/// w ##class(DHCMed.NINF.Aim.HDM).GetHXJOrderByPaadm(2986516)
ClassMethod GetHXJOrderByPaadm(Paadm As %String) As %String
{
	n (Paadm)
	
	s ret="无",flg=-1
 	q:+Paadm=0 $$$OK

    q:'$d(^OEORD(0,"Adm",+Paadm)) ret
    s oeord=$o(^OEORD(0,"Adm",+Paadm,"")) 
    s arcim=""
    f  s arcim=$o(^OEORDi(0,"ARCIM",+oeord,arcim),-1) q:(arcim="")||(flg=1)  d
    .s objCls=##class(DHCMed.Base.Arcim).GetObjById(arcim)
    .q:'$IsObject(objCls)
    .s ARCIMDesc=objCls.ARCIMDesc
    .s:ARCIMDesc["呼吸机辅助呼吸" flg=1	
	
	s:flg=1 ret="有"
	
	q ret
}

/// 判断是否存在 血液透析和血液透析滤过 医嘱
/// w ##class(DHCMed.NINF.Aim.HDM).GetXYTXOrderByPaadm(2986516)
ClassMethod GetXYTXOrderByPaadm(Paadm As %String) As %String
{
	n (Paadm)
	
	s ret="无",flg=-1
 	q:+Paadm=0 $$$OK

    q:'$d(^OEORD(0,"Adm",+Paadm)) ret
    s oeord=$o(^OEORD(0,"Adm",+Paadm,"")) 
    s arcim=""
    f  s arcim=$o(^OEORDi(0,"ARCIM",+oeord,arcim),-1) q:(arcim="")||(flg=1)  d
    .s objCls=##class(DHCMed.Base.Arcim).GetObjById(arcim)
    .q:'$IsObject(objCls)
    .s ARCIMDesc=objCls.ARCIMDesc
    .s:(ARCIMDesc["血液透析")||(ARCIMDesc["血液透析滤过") flg=1	
	
	s:flg=1 ret="有"
	
	q ret
}
*/
/// d ##class(%ResultSet).RunQuery("DHCMed.NINF.Aim.HDM","GetMNDOrderByPaadm","3049075")
Query GetMNDOrderByPaadm(Paadm As %String) As %Query(ROWSPEC = "IfMNDDipe:%String")
{
}

ClassMethod GetMNDOrderByPaadmExecute(ByRef qHandle As %Binary, Paadm As %String) As %Status
{
	Set repid=$I(^CacheTemp)

	s ind=1
	Set qHandle=$lb(0,repid,0)

	s IfMNDDipe="无",flg=-1
 	q:+Paadm=0 $$$OK

    if ('$d(^OEORD(0,"Adm",+Paadm)))
    { 
    	s Data=$lb(IfMNDDipe)
		s ^CacheTemp(repid,ind)=Data 
		Quit $$$OK
	}
	
    s oeord=$o(^OEORD(0,"Adm",+Paadm,"")) 
    s arcim=""
    f  s arcim=$o(^OEORDi(0,"ARCIM",+oeord,arcim),-1) q:(arcim="")||(flg=1)  d
    .s objCls=##class(DHCMed.Base.Arcim).GetObjById(arcim)
    .q:'$IsObject(objCls)
    .s ARCIMDesc=objCls.ARCIMDesc
    .s:ARCIMDesc["导尿" flg=1		
	s:flg=1 IfMNDDipe="有"
	s Data=$lb(IfMNDDipe)

	s ^CacheTemp(repid,ind)=Data
	Quit $$$OK
}

ClassMethod GetMNDOrderByPaadmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMNDOrderByPaadmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetMNDOrderByPaadmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMNDOrderByPaadmExecute ]
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

/// d ##class(%ResultSet).RunQuery("DHCMed.NINF.Aim.HDM","GetZXJMOrderByPaadm","2986516")
Query GetZXJMOrderByPaadm(Paadm As %String) As %Query(ROWSPEC = "IfZXJMDipe:%String")
{
}

ClassMethod GetZXJMOrderByPaadmExecute(ByRef qHandle As %Binary, Paadm As %String) As %Status
{
	s repid=$I(^CacheTemp)

	s ind=1
	s qHandle=$lb(0,repid,0)

	s IfZXJMDipe="无",flg=-1
 	q:+Paadm=0 $$$OK
	if ('$d(^OEORD(0,"Adm",+Paadm)))
    { 
    	s Data=$lb(IfZXJMDipe)
		s ^CacheTemp(repid,ind)=Data 
		Quit $$$OK
	}
	
	s oeord=$o(^OEORD(0,"Adm",+Paadm,"")) 
	s arcim=""
	f  s arcim=$o(^OEORDi(0,"ARCIM",+oeord,arcim),-1) q:(arcim="")||(flg=1)  d
	.s objCls=##class(DHCMed.Base.Arcim).GetObjById(arcim)
	.q:'$IsObject(objCls)
	.s ARCIMDesc=objCls.ARCIMDesc
	.s:(ARCIMDesc["中心静脉")||(ARCIMDesc["动脉穿刺") flg=1	
			
	s:flg=1 IfZXJMDipe="有"

	set Data=$lb(IfZXJMDipe)
	
	s ^CacheTemp(repid,ind)=Data

	Quit $$$OK
}

ClassMethod GetZXJMOrderByPaadmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetZXJMOrderByPaadmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetZXJMOrderByPaadmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetZXJMOrderByPaadmExecute ]
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

/// d ##class(%ResultSet).RunQuery("DHCMed.NINF.Aim.HDM","GetQGQKOrderByPaadm","2986516")
Query GetQGQKOrderByPaadm(Paadm As %String) As %Query(ROWSPEC = "IfQGQK:%String")
{
}

ClassMethod GetQGQKOrderByPaadmExecute(ByRef qHandle As %Binary, Paadm As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	
	s IfQGQK="无",flg=-1
 	q:+Paadm=0 $$$OK
	if ('$d(^OEORD(0,"Adm",+Paadm)))
    { 
    	s Data=$lb(IfQGQK)
		s ^CacheTemp(repid,ind)=Data 
		Quit $$$OK
	}
    	s oeord=$o(^OEORD(0,"Adm",+Paadm,"")) 
    	s arcim=""
    	f  s arcim=$o(^OEORDi(0,"ARCIM",+oeord,arcim),-1) q:(arcim="")||(flg=1)  d
    	.s objCls=##class(DHCMed.Base.Arcim).GetObjById(arcim)
    	.q:'$IsObject(objCls)
    	.s ARCIMDesc=objCls.ARCIMDesc
    	.s:ARCIMDesc["气管切开" flg=1	
	
	s:flg=1 IfQGQK="有"
	s ^CacheTemp(repid,ind)=$LB(IfQGQK)

	Quit $$$OK
}

ClassMethod GetQGQKOrderByPaadmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetQGQKOrderByPaadmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetQGQKOrderByPaadmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetQGQKOrderByPaadmExecute ]
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

/// d ##class(%ResultSet).RunQuery("DHCMed.NINF.Aim.HDM","GetHXJOrderByPaadm","2986516")
Query GetHXJOrderByPaadm(Paadm As %String) As %Query(ROWSPEC = "IfHXJ:%String")
{
}

ClassMethod GetHXJOrderByPaadmExecute(ByRef qHandle As %Binary, Paadm As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s IfHXJ="无",flg=-1
 	q:+Paadm=0 $$$OK
	
	if ('$d(^OEORD(0,"Adm",+Paadm)))
    { 
    	s Data=$lb(IfHXJ)
		s ^CacheTemp(repid,ind)=Data 
		Quit $$$OK
	}
    	s oeord=$o(^OEORD(0,"Adm",+Paadm,"")) 
    	s arcim=""
    	f  s arcim=$o(^OEORDi(0,"ARCIM",+oeord,arcim),-1) q:(arcim="")||(flg=1)  d
    	.s objCls=##class(DHCMed.Base.Arcim).GetObjById(arcim)
    	.q:'$IsObject(objCls)
    	.s ARCIMDesc=objCls.ARCIMDesc
    	.s:ARCIMDesc["呼吸机辅助呼吸" flg=1	
	
	s:flg=1 IfHXJ="有"
	s ^CacheTemp(repid,ind)=$LB(IfHXJ)

	Quit $$$OK
}

ClassMethod GetHXJOrderByPaadmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHXJOrderByPaadmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetHXJOrderByPaadmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHXJOrderByPaadmExecute ]
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

/// d ##class(%ResultSet).RunQuery("DHCMed.NINF.Aim.HDM","GetXYTXOrderByPaadm","2986516")
Query GetXYTXOrderByPaadm(Paadm As %String) As %Query(ROWSPEC = "IfXYTX:%String")
{
}

ClassMethod GetXYTXOrderByPaadmExecute(ByRef qHandle As %Binary, Paadm As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	
	s IfXYTX="无",flg=-1
 	q:+Paadm=0 $$$OK
	if ('$d(^OEORD(0,"Adm",+Paadm)))
    { 
    	s Data=$lb(IfXYTX)
		s ^CacheTemp(repid,ind)=Data 
		Quit $$$OK
	}
	s oeord=$o(^OEORD(0,"Adm",+Paadm,"")) 
	s arcim=""
	f  s arcim=$o(^OEORDi(0,"ARCIM",+oeord,arcim),-1) q:(arcim="")||(flg=1)  d
	.s objCls=##class(DHCMed.Base.Arcim).GetObjById(arcim)
	.q:'$IsObject(objCls)
	.s ARCIMDesc=objCls.ARCIMDesc
	.s:(ARCIMDesc["血液透析")||(ARCIMDesc["血液透析滤过") flg=1	

	s:flg=1 IfXYTX="有"
	s ^CacheTemp(repid,ind)=$LB(IfXYTX)

	Quit $$$OK
}

ClassMethod GetXYTXOrderByPaadmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetXYTXOrderByPaadmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetXYTXOrderByPaadmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetXYTXOrderByPaadmExecute ]
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

/// d ##class(%ResultSet).RunQuery("DHCMed.NINF.Aim.HDM","QryHDMArcim","2986516")
Query QryHDMArcim(Paadm As %String) As %Query(ROWSPEC = "ArcimDescString:%String,HavaArcim:%String,AllUse:%String")
{
}

ClassMethod QryHDMArcimExecute(ByRef qHandle As %Binary, Paadm As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	Quit:Paadm="" $$$OK

 	Set OrderID=$o(^OEORD(0,"Adm",Paadm,""))
 	Set ArcimID=""
 	set OrderIDString=""
 	set ArcimDescString=""

 	For {
	 	Set ArcimID=$o(^OEORDi(0,"ARCIM",+OrderID,ArcimID))
	 	Quit:ArcimID=""
	 	set ARCIMDesc=""
	 	Set objArcim=##class(DHCMed.Base.Arcim).GetObjById(ArcimID)
	 	Continue:'$IsObject(objArcim)
	 	Set ARCICOrderType=objArcim.ARCICOrderType
	 	Continue:ARCICOrderType'="R"
	 	Set ARCIMPHCDFDR=objArcim.ARCIMPHCDFDR
	 	set ARCIMDesc=objArcim.ARCIMDesc
	 	Set objPhc=##class(DHCMed.Base.PHC).GetObjById(ARCIMPHCDFDR)
	 
		Continue:((objPhc.PHCSCDesc'["抗感染")&(objPhc.PHCSCDesc'["抗生素")&(objPhc.PHCSCDesc'["抗微生物药"))
		Set StartDate=0
		For {
			Set StartDate=$o(^OEORDi(0,"ARCIM",+OrderID,ArcimID,StartDate))
			Quit:StartDate=""
			Set SubID=0
			For {
				Set SubID=$o(^OEORDi(0,"ARCIM",+OrderID,ArcimID,StartDate,SubID))
				Quit:SubID=""
				Set xDate=$p($g(^OEORD(OrderID,"I",SubID,3)),"^",34)
				Continue:(+xDate)'=0  //停止的医嘱过滤掉
				set:ARCIMDesc'="" ArcimDescString=ArcimDescString_ARCIMDesc_"/"
			
			}
		}
	}
	set AllUse=""
	set HavaArcim="否"
	set:ArcimDescString'="" HavaArcim="是"
	set:ArcimDescString'="" AllUse=($length(ArcimDescString,"/")-1)
	set AllUse=$SELECT(AllUse="":"",AllUse=1:"一联",AllUse=2:"二联",AllUse=3:"三联",1:"四联及四联以上")
	set Data=$lb(ArcimDescString,HavaArcim,AllUse)
	set ^CacheTemp(repid,ind)=Data
	Quit $$$OK
}

ClassMethod QryHDMArcimClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHDMArcimExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryHDMArcimFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHDMArcimExecute ]
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

Storage Default
{
<Data name="HDMDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AVPipe</Value>
</Value>
<Value name="3">
<Value>AVPipeInf48</Value>
</Value>
<Value name="4">
<Value>Aim</Value>
</Value>
<Value name="5">
<Value>AntiName</Value>
</Value>
<Value name="6">
<Value>AntiToLis</Value>
</Value>
<Value name="7">
<Value>AntiUsed</Value>
</Value>
<Value name="8">
<Value>BloodDialysis</Value>
</Value>
<Value name="9">
<Value>BrethMachine</Value>
</Value>
<Value name="10">
<Value>BrethMachineInf48</Value>
</Value>
<Value name="11">
<Value>CRReportDR</Value>
</Value>
<Value name="12">
<Value>CheckUser</Value>
</Value>
<Value name="13">
<Value>HosInfObj1</Value>
</Value>
<Value name="14">
<Value>HosInfObj2</Value>
</Value>
<Value name="15">
<Value>HosInfObj3</Value>
</Value>
<Value name="16">
<Value>HosInfPos1</Value>
</Value>
<Value name="17">
<Value>HosInfPos2</Value>
</Value>
<Value name="18">
<Value>HosInfPos3</Value>
</Value>
<Value name="19">
<Value>IfInfection</Value>
</Value>
<Value name="20">
<Value>InfType</Value>
</Value>
<Value name="21">
<Value>SocInfObj1</Value>
</Value>
<Value name="22">
<Value>SocInfObj2</Value>
</Value>
<Value name="23">
<Value>SocInfObj3</Value>
</Value>
<Value name="24">
<Value>SocInfPos1</Value>
</Value>
<Value name="25">
<Value>SocInfPos2</Value>
</Value>
<Value name="26">
<Value>SocInfPos3</Value>
</Value>
<Value name="27">
<Value>TrachealCut</Value>
</Value>
<Value name="28">
<Value>TrachealCutInf48</Value>
</Value>
<Value name="29">
<Value>UniteDrug</Value>
</Value>
<Value name="30">
<Value>UricPipe</Value>
</Value>
<Value name="31">
<Value>UricPipeInf48</Value>
</Value>
<Value name="32">
<Value>checkDate</Value>
</Value>
<Value name="33">
<Value>HosInfObj</Value>
</Value>
<Value name="34">
<Value>HosInfPos</Value>
</Value>
<Value name="35">
<Value>SocInfObj</Value>
</Value>
<Value name="36">
<Value>SocInfPos</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF.Aim.HDMD</DataLocation>
<DefaultData>HDMDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF.Aim.HDMD</IdLocation>
<IndexLocation>^DHCMed.NINF.Aim.HDMI</IndexLocation>
<StreamLocation>^DHCMed.NINF.Aim.HDMS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
