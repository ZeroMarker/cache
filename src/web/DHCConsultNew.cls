Import SQLUser

Include Nur.DateFormat

Class web.DHCConsultNew Extends %RegisteredObject [ ClassType = "", LegacyInstanceContext, Not ProcedureBlock ]
{

ClassMethod WriteJSONDataByQuery(ClassName As %String, QueryName As %String, Start As %String = "", Limit As %String = "", p1 = "", p2 = "", p3 = "", p4 = "", p5 = "", p6 = "", p7 = "", p8 = "", p9 = "", p10 = "", p11 = "", p12 = "", p13 = "", p14 = "", p15 = "", p16 = "") As %String
{
    Set pcount=$zutil(141)-4
	Set rset=##class(%ResultSet).%New(ClassName_":"_QueryName)
	Set execute="Set %sc=$zobjmethod(rset,""Execute"""
	For i=1:1:pcount Set execute=execute_",.p"_i
	Set execute=execute_")"
	b ;112
	Xecute execute
    If $$$ISERR(%sc) Do DisplayError^%apiOBJ(%sc) Quit
    
    q ..WriteJSONDataByResult(rset,Start,Limit)
}

/// 通过数据集Result生成JSON数据
ClassMethod WriteJSONDataByResult(rset As %ResultSet, Start As %String = "", Limit As %String = "") As %String
{
	   q:rset="" ""
	   s value=""
	   Set columns = rset.GetColumnCount()
	   b ;111
       s myIdx=0,ind=0  ;计数器
       While (rset.Next()) {
	        s myIdx=myIdx+1   ;累计总行数
	        i (+Limit>0)&&((ind<(+Start))!(ind>((+Start)+(+Limit)-1))) s ind=ind+1 continue  ;分页设置
	        s ind=ind+1
	        s rowvalue=""
	       // b ;1211
	        f i=1:1:columns 
	        {	 
	        i i=1 set rowvalue=rset.GetData(i)
			e  s rowvalue=rowvalue_"^"_rset.GetData(i)
	        }
			if value="" s value=rowvalue
			else  s value=value_"!"_rowvalue
	  }
	  
	  q value
}

ClassMethod GetDocListByLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDocListByLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)             
    Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCConsultNew","GetDocListByLoc",3,"",3)

ClassMethod GetDocListByLocExecute(ByRef qHandle As %Binary, ConLocId As %String = "", username As %String = "", ItmLocId As %String = "") As %Status
{
	;s ^sctmpv1("GetDocListByLoc")= ConLocId_","_ username_","_  ItmLocId
	 Set repid=$I(^CacheTemp)
 	 s ind=1
 	 //i CTLocId"" s qHandle=$lb(0,repid,0) q $$$OK
 	 s ConLocId=$replace(ConLocId," ","")
 	 b ;1
 	i ConLocId'="" 
 	{
	 s resId="" 
	 f  s resId=$O(^RB("RES",0,"CTLOC",ItmLocId,resId))  q:resId=""  d
	 .s ctcpId=$P(^RB("RES",resId),"^",2)
	 .q:ctcpId=""
	 .s ctcptId=$p($g(^CTPCP(ctcpId,1)),"^",4)
	 .q:ctcptId=""
	 .s ctcptInternalType=$P($g(^CT("CPT",ctcptId)),"^",4)  ;CT_CarPrvTp:CTCPT_InternalType
	 .q:ctcptInternalType'="DOCTOR"
	 .s ctcpDesc=$p($g(^CTPCP(ctcpId,1)),"^",2)	
	 .q:(username'="")&&(ctcpDesc'[username)
	 .d OutputRow111	
	}
	else
	{
	s ctcpId="" f  s ctcpId=$O(^CTPCP(ctcpId))  q:ctcpId=""  d
		.s ctcptId=$P($g(^CTPCP(ctcpId,1)),"^",4)  ;CTPCP_CarPrvTp_DR
		.q:ctcptId=""
    	.s ctcptInternalType=$P($g(^CT("CPT",ctcptId)),"^",4)  ;CT_CarPrvTp:CTCPT_InternalType
		.q:ctcptInternalType'="DOCTOR"
		.s ctcpDesc=$p($g(^CTPCP(ctcpId,1)),"^",2)
		.q:(username'="")&&(ctcpDesc'[username)
		.d OutputRow111	
		}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow111
	set Data=$lb(ctcpDesc,ctcpId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetDocListByLocExecuteBak(ByRef qHandle As %Binary, ConLocId As %String = "", username As %String = "", ItmLocId As %String = "") As %Status
{
	;s ^sctmpv1("GetDocListByLoc")= ConLocId_","_ username_","_  ItmLocId
	 Set repid=$I(^CacheTemp)
 	 s ind=1
 	 //i CTLocId"" s qHandle=$lb(0,repid,0) q $$$OK
 	 s ConLocId=$replace(ConLocId," ","")
 	 b ;1
 	i ConLocId'="" 
 	{
	 s CTLocId="" f  s CTLocId=$o(^User.DHCConsultLocItmI("GetChildloc",ConLocId,CTLocId)) q:CTLocId=""  d
	 .q:(ItmLocId'="")&(CTLocId'=ItmLocId)
	 .q:ItmLocId=""  ///子科室为空不让选择医生
	 .s resId="" f  s resId=$O(^RB("RES",0,"CTLOC",CTLocId,resId))  q:resId=""  d
	 ..s ctcpId=$P(^RB("RES",resId),"^",2)
	 ..q:ctcpId=""
	 ..s ctcptId=$p($g(^CTPCP(ctcpId,1)),"^",4)
	 ..q:ctcptId=""
	 ..s ctcpDesc=$p($g(^CTPCP(ctcpId,1)),"^",2)	
	 ..q:(username'="")&&(ctcpDesc'[username)
	 ..d OutputRow1	
	 	}
	else
	{
	s ctcpId="" f  s ctcpId=$O(^CTPCP(ctcpId))  q:ctcpId=""  d
		.s ctcptId=$P($g(^CTPCP(ctcpId,1)),"^",4)  ;CTPCP_CarPrvTp_DR
		.q:ctcptId=""
    	.s ctcptInternalType=$P($g(^CT("CPT",ctcptId)),"^",4)  ;CT_CarPrvTp:CTCPT_InternalType
		.q:ctcptInternalType'="DOCTOR"
		.s ctcpDesc=$p($g(^CTPCP(ctcpId,1)),"^",2)
		.q:(username'="")&&(ctcpDesc'[username)
		.d OutputRow1	
		}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(ctcpDesc,ctcpId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetDocListByLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDocListByLocExecute ]
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

// 获取科室医生 

Query GetDocListByLoc(ConLocId As %String = "", username As %String = "", ItmLocId As %String = "") As %Query(ROWSPEC = "ctcpDesc,ctcpId")
{
}

// 获取病区，combobox用

// 

/// w ##class(web.DHCConsultNew).GetDocList("110")
ClassMethod GetDocList(dep As %String = "")
{
	;s ^sctmpv1("GetDocList") = dep
	s ret=""
	if dep'=""
	{
		s resId="" f  s resId=$O(^RB("RES",0,"CTLOC",dep,resId))  q:resId=""  d
			   .s ctcpId=$P(^RB("RES",resId),"^",2)
			   .q:ctcpId=""
			   .s ctcptId=$p($g(^CTPCP(ctcpId,1)),"^",4)
			   .q:ctcptId=""
			   .s ctcpDesc=$p($g(^CTPCP(ctcpId,1)),"^",2)
			   .if ret'="" d
			   ..i ret'[("["_ctcpId_",") d
			   ...s ret = ret_",["_ctcpId_",'"_ctcpDesc_"']"
			   .e  d
			   ..s ret="["_ctcpId_",'"_ctcpDesc_"']"
			   q "["_ret_"]" 
			  
		
		}
	else
	{
		s ctcpId="" f  s ctcpId=$O(^CTPCP(ctcpId))  q:ctcpId=""  d
		.s ctcptId=$P($g(^CTPCP(ctcpId,1)),"^",4)  ;CTPCP_CarPrvTp_DR
		.q:ctcptId=""
    	.s ctcptInternalType=$P($g(^CT("CPT",ctcptId)),"^",4)  ;CT_CarPrvTp:CTCPT_InternalType
		.q:ctcptInternalType'="DOCTOR"
		.s ctcpDesc=$p($g(^CTPCP(ctcpId,1)),"^",2)
		.if ret'="" d
		..i ret'[("["_ctcpId_",") d
		...s ret = ret_",["_ctcpId_",'"_ctcpDesc_"']"
		.e  d
		..s ret="["_ctcpId_",'"_ctcpDesc_"']"
		q "["_ret_"]" 
		}
}

ClassMethod GetPatinfo(EpisodeID As %String = "")
{
	s ret=""
	s patinf=##class(web.DHCMGNurComm).PatInfo(EpisodeID)
	s regno=$P(patinf,"^",1) //登记号
	///s Diag=$P(patinf,"^",9) //诊断
	s mradm=$p(^PAADM(EpisodeID),"^",61)
	s Diag=..Diag(mradm,"")   ///诊断
	S patname=$P(patinf,"^",5)  //姓名
	s patsex=$P(patinf,"^",4)  //性别
	s patage=$P(patinf,"^",7)  //年龄
	s bedcode=$P(patinf,"^",6)   //床号
	s wardDesc=$P(patinf,"^",8) //病区
	s appdate=$$$ZD(+$h,3)   //申请日期
	s apptime=$zt($p($h,",",2),2)  //申请时间
	s appdoc=%session.Data("LOGON.USERNAME")   //申请医生
	s MedCareNo=$P(patinf,"^",10)  //病案号
	s:regno["@" regno=$p(regno,"@",2)
	s:Diag["@" Diag=$p(Diag,"@",2)
	s:patname["@" patname=$p(patname,"@",2)
	s:patsex["@" patsex=$p(patsex,"@",2)
	s:patage["@" patage=$p(patage,"@",2)
	s:bedcode["@" bedcode=$p(bedcode,"@",2)
	s:MedCareNo["@" MedCareNo=$p(MedCareNo,"@",2)
	s:wardDesc["@" wardDesc=$p(wardDesc,"@",2)
	s ret=patname_"^"_patsex_"^"_patage_"^"_bedcode_"^"_appdate_"^"_appdoc_"^"_MedCareNo_"^"_Diag_"^"_regno_"^"_wardDesc_"^"_apptime
	q ret
}

Query QryCTLoc(argDesc As %String, argType As %String, argLocID As %String, Hos As %String = "") As %Query(ROWSPEC = "CTLocID:%String,CTLocCode:%String,CTLocDesc:%String")
{
}

ClassMethod QryCTLocExecute(ByRef qHandle As %Binary, argDesc As %String, argType As %String, argLocID As %String, Hos As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	Set tmp=argLocID
	Set argLocID=$p(tmp,"-",1)
	Set argHospID=$p(tmp,"-",2)
	
	Set:argDesc'="" argDesc=$$ALPHAUP^SSUTIL4(argDesc)
	//^CTLOC({CTLOC_RowID})
	//^CTLOC({CT_Loc.CTLOC_RowID},"LINK",0,"Loc",{LINK_CTLOC_DR},{LINK_Childsub})
	Set CTLocID=0
	For {
		Set CTLocID=$o(^CTLOC(CTLocID))
		Quit:CTLocID=""
		Set tmp=$g(^CTLOC(CTLocID))
		Set CTLocCode=$p(tmp,"^",1)
		Set CTLocDesc=$p(tmp,"^",2)
		Set CTLocType=$p(tmp,"^",13) //Type E-科室，W-病区，D-药房，O-办公室，OP-CT室等
		Continue:(argLocID'="")&&'$d(^CTLOC(+argLocID,"LINK",0,"Loc",CTLocID))
		Set tmpLocDesc=$$ALPHAUP^SSUTIL4(CTLocDesc)
		Continue:(argDesc'="")&&(tmpLocDesc'[argDesc) //检查运算符右边的串是否包含了左边的串
		Set HospID=$p(tmp,"^",22)
		Continue:(argHospID'="")&&(HospID'=argHospID)
		Continue:(Hos'="")&&(HospID'=Hos)
		i CTLocDesc["-" s CTLocDesc=$p(CTLocDesc,"-",2)
		Set Data=$lb(CTLocID,CTLocCode,CTLocDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	//********************************************************
	
	Quit $$$OK
}

ClassMethod QryCTLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCTLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	;Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCTLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCTLocExecute ]
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

// ******************************************获取多科会诊的会诊列表

ClassMethod GetConSultListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetConSultListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)             
    Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCConsultNew","GetConSultList","23/8/2017","23/8/2017","F")

ClassMethod GetConSultListExecute(ByRef qHandle As %Binary, startdate As %String = "", enddate As %String = "", Auditflag As %String = "") As %Status
{
	;s ^sctmpv1("GetConSultList") = startdate _"^"_ enddate  _"^"_ Auditflag 
	 Set repid=$I(^CacheTemp)
 	 s ind=1
 	 //i CTLocId"" s qHandle=$lb(0,repid,0) q $$$OK
 	 ;s flag=..isdate(startdate)
 	 ;i flag="0" s startdate=+$h
 	 ;e  
 	 s startdate=$$$zdh(startdate,5)
 	 ;s flag=..isdate(enddate)
 	 ;i flag="0" s enddate=+$h
 	 ;e  
 	 s enddate=$$$zdh(enddate,5)
 	f date=startdate:1:enddate
 	{
	 	s locid="" f  s locid=$o(^User.DHCConSultationNewI("AppDep",date,locid)) q:locid=""  d
	 	.s id="" f  s id=$o(^User.DHCConSultationNewI("AppDep",date,locid,id)) q:id=""  d
	 	..s ret=^User.DHCConSultationNewD(id)
	 	..s EpisodeId=$listget(ret,2)
	 	..s PatDep=$listget(ret,5)
	 	..i PatDep'="" s PatDep=$P(^CTLOC(PatDep),"^",2)
	 	..s:PatDep["-" PatDep=$p(PatDep,"-",2)
	 	..s Diag=$listget(ret,14)  //诊断
	 	..s Destination=$listget(ret,9)  //会诊备注
	 	..s Destinationtwo=$listget(ret,17)  //会诊目的
	 	..s Contyp=$listget(ret,7)  //会诊类别
	 	..s InOut=$listget(ret,8)
	 	..s AppDate=$listget(ret,3)
	 	..s AppTime=$listget(ret,4)
	 	..s:AppDate'="" AppDate=$$$zd(AppDate,3)
	 	..s:AppTime'="" AppTime=$zt(AppTime,2)
	 	..s Status=$listget(ret,10)
	 	..//q:((Status="E")!(Status="F"))&(Auditflag="true")
	 	..//q:(Status'="E")&(Status'="F")&(Auditflag="false")
	 	..q:Status'=Auditflag
	 	..s Status=$s(Status="W":"待审",Status="V":"申请",Status="E":"审核",Status="C":"撤销",Status="F":"已完成",Status="R":"已拒绝",1:"")
	 	..s Contyp=$s(Contyp="M":"多科",Contyp="C":"普通",Contyp="E":"急",1:"")
	 	..s RowID=id
	 	..//****************
	 	..s (RequestDep,RequestItmDep,RequestDoc,RequestDepdr,RequestItmDepdr,RequestDocdr)=""
	 	..s idsub="" f  s idsub=$o(^User.DHCConSultationNewSubD(id,idsub)) q:idsub=""  d
	 	...s result=^User.DHCConSultationNewSubD(id,idsub)
	 	...s RequestDocdr="",RequestDep=""
	 	...s RequestDocdr=$listget(result,3)
	 	...q:RequestDocdr=""
	 	...s ctcpDesc=$p($g(^CTPCP(RequestDocdr,1)),"^",2)
	 	...i RequestDoc="" s RequestDoc=ctcpDesc
	 	...e  s RequestDoc=RequestDoc_" "_ctcpDesc
	 	...;s RequestDepdr="",RequestDocdr=""
	 	..s subid="" f  s subid =$O(^User.DHCConSultationNewSubI("ConsultDep",id,subid)) q:subid=""  d
    	...s depName=$P(^CTLOC($tr(subid," ")),"^",2)
    	...i depName["-" s RequestDep=RequestDep_" "_$P(depName,"-",2)
    	...e  s RequestDep=RequestDep_" "_$P(^CTLOC($tr(subid," ")),"^",2)
	 	..//**************************
	 	..s patinf=##class(web.DHCMGNurComm).PatInfo(EpisodeId)
	 	..s BedCode=$P(patinf,"^",6)   //床号
	 	..S PatName=$P(patinf,"^",5)  //姓名
	    ..//s patsex=$P(patinf,"^",4)  //性别
	    ..//s patage=$P(patinf,"^",7)  //年龄
	    ..s:BedCode["@" BedCode=$p(BedCode,"@",2)
	    ..s:PatName["@" PatName=$p(PatName,"@",2)
	    ..//s:patsex["@" patsex=$p(patsex,"@",2)
	    ..//s:patage["@" patage=$p(patage,"@",2)
	    ..d OutputRow2
	 	
	 	}
 	
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(PatDep,BedCode,PatName,Diag,Destination,Destinationtwo,RequestDep,RequestItmDep,RequestDoc,Contyp,InOut,AppDate,AppTime,Status,EpisodeId,RowID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetConSultListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetConSultListExecute ]
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

Query GetConSultList(startdate As %String = "", enddate As %String = "", Auditflag As %String = "") As %Query(ROWSPEC = "PatDep,BedCode,PatName,Diag,Destination,Destinationtwo,RequestDep,RequestItmDep,RequestDoc,Contyp,InOut,AppDate,AppTime,Status,EpisodeId,RowID")
{
}

// 返回1 表示正确的时间格式

ClassMethod istime(str)
{
	s len=$l(str,":")
	s match=$s(len=3:str?1.2N1":"1.2N1":"1.2N,len=2:str?1.2N1":"1.2N,1:0)
	q:match=0 0
	q:($p(str,":")>24)!($p(str,":",2)>60)!($p(str,":",3)>60) 0
	q match
}

// 返回1表示合法的日期格式,否则不合法

ClassMethod isdate(str)
{
	s match=$s(str["/"=1:str?1.2N1"/"2N1"/"4N,str["-"=1:str?4N1"-"1.2N1"-"1.2N,1:0)
	q:match=0 0
	i str["-" d
	.s year=$p(str,"-")
	.s month=$p(str,"-",2)
	.i (month>12)!(month<1) s match=0 q
	.d getdays(year,month)
	.i ($p(str,"-",3)<1)!($p(str,"-",3)>days) s match=0 q
	i str["/" d
	.s year=$p(str,"/",3)
	.s month=$p(str,"/",2)
	.i (month>12)!(month<1) s match=0 q
	.d getdays(year,month)
	.i ($p(str,"/")<1)!($p(str,"/")>days) s match=0 q
	q match
getdays(year,month)
    s calmonth="31;28;31;30;31;30;31;31;30;31;30;31"
 	s days=+$p(calmonth,";",+month)
 	if (+month=2)&(year#4=0)&((year#100'=0)!(year#400=0)) s days=29 
 	q days
}

/// w ##class(web.DHCConsultNew).GetPatinfobyId("53")
ClassMethod GetPatinfobyId(id As %String = "")
{
    
    
	s obj=##class(User.DHCConSultationNew).%OpenId(id)
	if $ISObject(obj) {
	s Diag=obj.Diag
	s appdate=obj.AppDate
	s apptime=obj.AppTime
	s appdoc=obj.AppDoc   //申请医生
	b ;11
	s InOut=obj.InOut    //院内院外
	s ConType=obj.ConType    //会诊类别	
	s EpisodeID=obj.Adm
	s ConDestination=obj.ConDestination
	s ConDestinationtwo=obj.ConDestinationtwo
	s MoreConPlace=obj.MoreConPlace
	s MoreConTime=obj.MoreConTime
	d obj.%Close()
	}
	s:ConDestination["^" ConDestination=$replace(ConDestination,"^","")
	s:ConDestinationtwo["^" ConDestinationtwo=$replace(ConDestinationtwo,"^","")
    s ret=""
	s patinf=##class(web.DHCMGNurComm).PatInfo(EpisodeID)
	s regno=$P(patinf,"^",1) //登记号
	S patname=$P(patinf,"^",5)  //姓名
	s patsex=$P(patinf,"^",4)  //性别
	s patage=$P(patinf,"^",7)  //年龄
	s bedcode=$P(patinf,"^",6)   //床号
	s wardDesc=$P(patinf,"^",8) //病区
	s MedCareNo=$P(patinf,"^",10)  //病案号
	s:appdoc'="" appdoc=$p(^SSU("SSUSR",appdoc),"^",2)  //申请医生
	b ;22
	s:apptime'="" apptime=$zt(apptime,2)
	s:regno["@" regno=$p(regno,"@",2)
	s:patname["@" patname=$p(patname,"@",2)
	s:patsex["@" patsex=$p(patsex,"@",2)
	s:patage["@" patage=$p(patage,"@",2)
	s:bedcode["@" bedcode=$p(bedcode,"@",2)
	s:MedCareNo["@" MedCareNo=$p(MedCareNo,"@",2)
	s:wardDesc["@" wardDesc=$p(wardDesc,"@",2)
	I appdate'="" S appdate=$$$zd(appdate,3)
	s ret=patname_"^"_patsex_"^"_patage_"^"_bedcode_"^"_appdate_"^"_appdoc_"^"_MedCareNo_"^"_Diag_"^"_regno_"^"_wardDesc_"^"_apptime_"^"_appdoc_"^"_InOut_"^"_ConType_"^"_ConDestination_"^"_ConDestinationtwo_"^"_MoreConPlace_"^"_MoreConTime_"^"_appdate
	;s ^Temp("csa")=ret
	q ret
}

/// 获取会诊地点和时间
ClassMethod GetConPlace(id As %String = "")
{
	s conplace=""
	s contime=""
	s ret=""
	s idsub=$o(^User.DHCConsultationI("ConSultPontDr",id,""))
	i idsub="" s ret="^" q ret
	s obj=##class(User.DHCConsultation).%OpenId(idsub)
	if $IsObject(obj)
	{
		s conplace=obj.MoreConPlace
		s contime=obj.MoreConTime
		}
	s ret=conplace_"^"_contime
	q ret
}

// 获取要求会诊科室列表

/// w ##class(web.DHCConsultNew).GetConlistbyId("")
ClassMethod GetConlistbyId(id As %String = "")
{
	;s ^sctmpv1("GetConlistbyId") = id
 q:id="" ""
 s ret=""
 s dep="" f  s dep=$o(^User.DHCConSultationNewSubI("ConsultDep",id,dep)) q:dep=""  d
 .;s depid=$replace(dep," ","")
 .;s depesc=$listget(^User.DHCConsultLocD(depid),2)
 .s depid="" ;dep
 .s depesc="" ;$P(^CTLOC(depid),"^",2)        //
 .b //s:depesc["-" depesc=$p(depesc,"-",2)
 .s idsub=$o(^User.DHCConSultationNewSubI("ConsultDep",id,dep,""))
 .i idsub'="" d
 ..s Itmloc=$listget(^User.DHCConSultationNewSubD(id,idsub),5)
 ..i Itmloc'="" d
 ...s Itmlocdesc=$P(^CTLOC(Itmloc),"^",2)
 ...s depid=Itmloc
 ...s depesc=Itmlocdesc
 ..e  d
 ...s Itmlocdesc=""
 ...s depid=Itmloc
 ...s depesc=Itmlocdesc
 ..s doctordr=$listget(^User.DHCConSultationNewSubD(id,idsub),3)
 ..i doctordr'="" s doctor=$p(^CTPCP(doctordr,1),"^",2)
 ..e  s doctor=""
 .e  d
 ..s (Itmloc,Itmlocdesc,doctordr,doctor)=""
 .s conSubId = id_"||"_idsub
 .i ret="" d
 ..s ret=depid_"^"_depesc_"^"_Itmloc_"^"_Itmlocdesc_"^"_doctordr_"^"_doctor_"^"_conSubId
 .e  s ret=ret_"!"_depid_"^"_depesc_"^"_Itmloc_"^"_Itmlocdesc_"^"_doctordr_"^"_doctor_"^"_conSubId
 q ret
}

ClassMethod GetConlistbyIdBak(id As %String = "")
{
	
 q:id="" ""
 s ret=""
 s dep="" f  s dep=$o(^User.DHCConSultationNewSubI("ConsultDep",id,dep)) q:dep=""  d
 .s depid=$replace(dep," ","")
 .s depesc=$listget(^User.DHCConsultLocD(depid),2)
 .//s depid=dep
 .//s depesc=$P(^CTLOC(depid),"^",2)        //
 .s:depesc["-" depesc=$p(depesc,"-",2)
 .s idsub=$o(^User.DHCConSultationNewSubI("ConsultDep",id,dep,""))
 .i idsub'="" d
 ..s Itmloc=$listget(^User.DHCConSultationNewSubD(id,idsub),5)
 ..i Itmloc'="" s Itmlocdesc=$P(^CTLOC(Itmloc),"^",2)
 ..e  s Itmlocdesc=""
 ..s doctordr=$listget(^User.DHCConSultationNewSubD(id,idsub),3)
 ..i doctordr'="" s doctor=$p(^CTPCP(doctordr,1),"^",2)
 ..e  s doctor=""
 .e  d
 ..s (Itmloc,Itmlocdesc,doctordr,doctor)=""
 .i ret="" s ret=depid_"^"_depesc_"^"_Itmloc_"^"_Itmlocdesc_"^"_doctordr_"^"_doctor
 .e  s ret=ret_"!"_depid_"^"_depesc_"^"_Itmloc_"^"_Itmlocdesc_"^"_doctordr_"^"_doctor
 q ret
}

ClassMethod GetConlistbyId20140528(id As %String = "")
{
 q:id="" ""
 s ret=""
 s dep="" f  s dep=$o(^User.DHCConSultationNewSubI("ConsultDep",id,dep)) q:dep=""  d
 .s depid=$replace(dep," ","")
 .s depesc=$listget(^User.DHCConsultLocD(depid),2)
 .//s depid=dep
 .//s depesc=$P(^CTLOC(depid),"^",2)        //
 .s:depesc["-" depesc=$p(depesc,"-",2)
  .b ;1
 .i ret="" s ret=depid_"^"_depesc
 .e  s ret=ret_"!"_depid_"^"_depesc
 q ret
}

// ************************************会诊配置界面 User.DHCConsultLoc表取

ClassMethod GetConsultDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetConsultDepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)             
    Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCConsultNew","GetConsultDep","2")

ClassMethod GetConsultDepExecute(ByRef qHandle As %Binary, hospitalid As %String = "") As %Status
{
	 Set repid=$I(^CacheTemp)
 	 s ind=1
 	i hospitalid=""
 	{
	 s id="" f  s id=$o(^User.DHCConsultLocD(id)) q:id=""  d
	 .s ret=^User.DHCConsultLocD(id)
	 .s ConID=id
	 .s ConDesc=$listget(ret,2)	
	 .s HosID=$listget(ret,3)
	 .q:HosID=""
	 .s ARCItmmastDr=$listget(ret,4)
	 .i ARCItmmastDr'="" d
	 ..s ARCItmmast=$p(^ARCIM(+ARCItmmastDr,$p(ARCItmmastDr,"||",2),1),"^",2)
	 .e  s ARCItmmast=""
	 .s HosDesc=$p(^CT("HOSP",HosID),"^",2)
	 .s ConCode=$listget(ret,5)
	 .d OutputRow3
	 	
	 	}
	 else
	 {
	  s id=""  f  s id=$o(^User.DHCConsultLocI("CTLOCHospitalDR",hospitalid,id)) q:id=""  d
	  .s ret=^User.DHCConsultLocD(id)
	  .s ConID=id
	  .s ConDesc=$listget(ret,2)	
	  .s HosID=$listget(ret,3)
	  .s ARCItmmastDr=$listget(ret,4)
	  .i ARCItmmastDr'="" d
	  ..s ARCItmmast=$p(^ARCIM(+ARCItmmastDr,$p(ARCItmmastDr,"||",2),1),"^",2)
	  .e  s ARCItmmast=""
	  .s HosDesc=$p(^CT("HOSP",HosID),"^",2)
	  .s ConCode=$listget(ret,5)
	  .d OutputRow3	 
		 
		 }
	 	
 	
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow3
	set Data=$lb(ConID,ConDesc,ConCode,ARCItmmast,ARCItmmastDr,HosID,HosDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetConsultDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetConsultDepExecute ]
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

Query GetConsultDep(hospitalid As %String = "") As %Query(ROWSPEC = "ConID,ConDesc,ConCode,ARCItmmast,ARCItmmastDr,HosID,HosDesc")
{
}

// ************************************************获取会诊大科室

// ************************************会诊配置界面 User.DHCConsultLoc表取

ClassMethod GetBigLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBigLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)             
    Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCConsultNew","GetBigLoc","2")

ClassMethod GetBigLocExecute(ByRef qHandle As %Binary, Locdesc As %String = "") As %Status
{
	 Set repid=$I(^CacheTemp)
 	 s ind=1
 	 ;s ^sctmpv1("GetBigLoc")=Locdesc
	 s id="" f  s id=$o(^User.DHCConsultLocD(id)) q:id=""  d
	 .s ret=^User.DHCConsultLocD(id)
	 .s BigLocID=id
	 .s BigLocDesc=$listget(ret,2)
	 .q:(Locdesc'="")&(BigLocDesc'[Locdesc)	
	 .d OutputRow4 
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow4
	set Data=$lb(BigLocID,BigLocDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetBigLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBigLocExecute ]
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

Query GetBigLoc(Locdesc As %String = "") As %Query(ROWSPEC = "BigLocID,BigLocDesc")
{
}

// ************************************************获取会诊子科室

// ************************************会诊配置界面 User.DHCConsultLocItm表取

ClassMethod GetItemLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetItemLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)             
    Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCConsultNew","GetItemLoc","2")

ClassMethod GetItemLocExecute(ByRef qHandle As %Binary, cboBigCTLoc As %String = "") As %Status
{
	 Set repid=$I(^CacheTemp)
 	 s ind=1
 	//^User.DHCConsultLocItmI("GetChildloc",11,85,1)	
 	i cboBigCTLoc'=""
 	{
	 	s id="" f  s id=$o(^User.DHCConsultLocItmI("GetChildloc",cboBigCTLoc,id)) q:id=""  d
	 	.s LocID=id
	 	.s LocDesc=$P(^CTLOC(id),"^",2)
	 	.s LocParr=cboBigCTLoc
	 	.s LocParrDesc=$listget(^User.DHCConsultLocD(LocParr),2)
	 	.s subid=$o(^User.DHCConsultLocItmI("GetChildloc",cboBigCTLoc,id,""))
	 	.s rowid=LocParr_"||"_subid
	 	.d OutputRow5
	 	
	 	}
	 	
	 else
	 {
		s id="" f  s id=$o(^User.DHCConsultLocItmD(id)) q:id=""  d
		.s subid="" f  s subid=$o(^User.DHCConsultLocItmD(id,subid)) q:subid=""  d
		..s LocID=$listget(^User.DHCConsultLocItmD(id,subid),2)
		..s LocDesc=$P(^CTLOC(LocID),"^",2)
		..s LocParr=id
		..s LocParrDesc=$listget(^User.DHCConsultLocD(id),2)
		..s rowid=id_"||"_subid
		..d OutputRow5
		 
		 }
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow5
	set Data=$lb(LocID,LocDesc,LocParr,LocParrDesc,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetItemLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetItemLocExecute ]
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

Query GetItemLoc(cboBigCTLoc As %String = "") As %Query(ROWSPEC = "LocID,LocDesc,LocParr,LocParrDesc,rowid")
{
}

/// //会诊界面获取会诊科室
ClassMethod getloc(funname As %String) As %String
{
 s id="" f  s id=$o(^User.DHCConsultLocD(id)) q:id=""  d
 .s ret=^User.DHCConsultLocD(id)
 .s c=$listget(ret,2)
 .s rtnval=funname_"('"_$ZCVT($g(id),"O","JS")_"','"_$ZCVT($g(c),"O","JS")_"');"
 .&javascript<#(rtnval)#>
 q 0	
	
 /*s rw="" f  s rw=$O(^CTLOC(rw)) q:rw=""  d
 .s a=$P(^CTLOC(rw),"^")
 .s c=$P(^CTLOC(rw),"^",2)
 .q:c=""
 .;s c=$P(c,"-",2)
 .s rtnval=funname_"('"_$ZCVT($g(rw),"O","JS")_"','"_$ZCVT($g(c),"O","JS")_"');"
 .&javascript<#(rtnval)#>
 .//w !,b
 q 0*/
}

/// 根据会诊科室获取子科室的医生
/// 入参：consultdep：User.DHCConsultLoc表id
ClassMethod GetDoc(consultdep) As %String
{
	s ret=""
	//q:dep="" ""
	if consultdep'=""
	{
	s dep="" f  s dep=$o(^User.DHCConsultLocItmI("GetChildloc",consultdep,dep)) q:dep=""  d	
		.s resId="" f  s resId=$O(^RB("RES",0,"CTLOC",dep,resId))  q:resId=""  d
			   ..s ctcpId=$P(^RB("RES",resId),"^",2)
			   ..q:ctcpId=""
			   ..s ctcptId=$p($g(^CTPCP(ctcpId,1)),"^",4)
			   ..q:ctcptId=""
			   ..//s ctcptType=$p(^CT("CPT",ctcptId),"^",4)
			   ..//q:(ifDoctor'="")&(ifDoctor="Y")&(ctcptType'="DOCTOR")
		       ..//q:(ifDoctor'="")&(ifDoctor'="Y")&(ctcptType'="NURSE")
			   ..s ctcpDesc=$p($g(^CTPCP(ctcpId,1)),"^",2)
			   ..s ret=ret_ctcpId_"|"_ctcpDesc_"^"
			   ..;b
	}
	else
	{
		s ctcpId="" f  s ctcpId=$O(^CTPCP(ctcpId))  q:ctcpId=""  d
		.s ctcptId=$P($g(^CTPCP(ctcpId,1)),"^",4)  ;CTPCP_CarPrvTp_DR
		.q:ctcptId=""
    	.s ctcptInternalType=$P($g(^CT("CPT",ctcptId)),"^",4)  ;CT_CarPrvTp:CTCPT_InternalType
		.q:ctcptInternalType'="DOCTOR"
		.s ctcpDesc=$p($g(^CTPCP(ctcpId,1)),"^",2)
		.s ret=ret_ctcpId_"|"_ctcpDesc_"^"
	}
   	q ret
}

/// 会诊申请界面获取维护的会诊科室
ClassMethod QryConsultDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryConsultDepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)             
    Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCConsultNew","QryConsultDep","2")

ClassMethod QryConsultDepExecute(ByRef qHandle As %Binary, Content As %String = "") As %Status
{
	s ^TMPyzs("QryConsultDepExecute")=Content
	 Set repid=$I(^CacheTemp)
 	 s ind=1
 	 b ;1
	 s id="" f  s id=$o(^User.DHCConsultLocD(id)) q:id=""  d
	 .s ret=^User.DHCConsultLocD(id)
	 .s ConID=id
	 .s ConDesc=$listget(ret,2)
	 .q:ConDesc'[Content	
	 .s HosID=$listget(ret,3)
	 .b ;2
	 .q:HosID=""
	 .s HosDesc=$p(^CT("HOSP",HosID),"^",2)
	 .d OutputRow6
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow6
	set Data=$lb(ConID,ConDesc,HosID,HosDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryConsultDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryConsultDepExecute ]
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

Query QryConsultDep(Content As %String = "") As %Query(ROWSPEC = "ConID,ConDesc,HosID,HosDesc")
{
}

// huoqu huizhen keshizu

ClassMethod getLocStr(Grouploc As %String = "") As %String
{
	s retStr=""
	s id="" f  s id=$o(^User.DHCConsultLocItmI("Ctloc",Grouploc,id)) q:id=""  d
	.s retStr="^"_id_"^"
	q retStr
	/*
	s id=0
	f  s id=$O(^User.DHCLocGroupD(id)) q:(id="")  d
	.s loc=$listget(^User.DHCLocGroupD(id),2)
	.s group=$listget(^User.DHCLocGroupD(id),3)
	.q:(group="")
	.q:loc=""
	.q:(Grouploc'="")&&(group'=Grouploc)
	.i retStr="" s retStr="^"_loc_"^"
	.e  i (("^"_loc_"^")'[retStr)  s retStr=retStr_loc_"^"
	q retStr
	*/
}

Query FindMasterItem(ARCIMDesc As %String) As %Query(ROWSPEC = "ArcimDesc:%String,ArcimDR:%String")
{
}

ClassMethod FindMasterItemExecute(ByRef qHandle As %Binary, ARCIMDesc As %String) As %Status
{
	;s ^sctmpv1("FindMasterItem") = ARCIMDesc
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
    i (ARCIMDesc'="") s ARCIMDesc=$$ALPHAUP^SSUTIL4(ARCIMDesc)
 	s ArcimID=0 
 	f  s ArcimID=$o(^ARCIM(ArcimID)) q:ArcimID=""  d
	.s ArcimSubID=0 f  s ArcimSubID=$o(^ARCIM(ArcimID,ArcimSubID)) q:ArcimSubID=""  d
	..s ArcimDR=ArcimID_"||"_ArcimSubID
	..s AlisDR="" f  s AlisDR=$O(^ARC("ALIAS",0,"ARCIM",ArcimDR,AlisDR)) q:AlisDR=""  d
	...q:AlisDR=""
	...s AlisDesc=$$ALPHAUP^SSUTIL4($p(^ARC("ALIAS",AlisDR),"^",6))
	...s ArcimDesc=$p(^ARCIM(ArcimID,ArcimSubID,1),"^",2)
	...s ArcimDesc=AlisDesc_"-"_ArcimDesc
	...q:ArcimDesc'[ARCIMDesc
	...s ArcimDesc=$p(ArcimDesc,"-",2)
	...//q:$p(ArcimDesc,ARCIMDesc,1)'=""
	...Do OutputRow9
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow9
	set Data=$lb(ArcimDesc,ArcimDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindMasterItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMasterItemExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindMasterItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMasterItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// **************************会诊申请界面根据传过来的医嘱项id来获取信息

// w ##class(web.DHCConsultNew).getConInfoByArcimid("127||23")

ClassMethod getConInfoByArcimid(Arcimid As %String = "") As %String
{
	;s ^sctmpv1("getConInfoByArcimid") = Arcimid
	;s Arcimid="2||1"
	s ret=""
	b ;1
	q:Arcimid="" ret
	s Arcim=$p(^ARCIM(+Arcimid,$P(Arcimid,"||",2),1),"^",2)  //医嘱项内容"多科" ;
	b ;2
	s:Arcim["多科" ret="M"           //多科会诊返回M
	s id=$o(^User.DHCConsultLocI("ItmMastDR",Arcimid,""))
	q:id="" ret
	s Condep=$listget(^User.DHCConsultLocD(id),2)
	s Condepid=id
	
	s ret=ret_"!"_Condep_"^"_Condepid
	q ret
}

// ******************************************

ClassMethod GetListItemLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListItemLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)             
    Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCConsultNew","GetListItemLoc","2","")

ClassMethod GetListItemLocExecute(ByRef qHandle As %Binary, cboBigCTLoc As %String = "", content As %String = "") As %Status
{
	 Set repid=$I(^CacheTemp)
 	 s ind=1
 	 s cboBigCTLoc=$replace(cboBigCTLoc," ","")
 	 S cboBigCTLoc=""
 	 
 	//^User.DHCConsultLocItmI("GetChildloc",11,85,1)	
 	i cboBigCTLoc'=""
 	{
	 	s id="" f  s id=$o(^User.DHCConsultLocItmI("GetChildloc",cboBigCTLoc,id)) q:id=""  d
	 	.s ItmLocID=id
	 	.s ItmLocDesc=$P(^CTLOC(id),"^",2)
	 	.s CTLocCode= $p($g(^CTLOC(id)),"^",43)
  		.s comparWarddesc=$$ALPHAUP^SSUTIL4(CTLocCode)
	 	.q:(content'="")&((ItmLocDesc'[content)!(comparWarddesc)'[$$ALPHAUP^SSUTIL4(content))
	 	.d OutputRow11
	 	
	 	}
	 	
	 else
	 {
		 s rw="" f  s rw=$O(^CTLOC(rw)) q:rw=""  d
 		.s a=$P(^CTLOC(rw),"^")
 		.s c=$P(^CTLOC(rw),"^",2)
 		.s dateFrom=$P(^CTLOC(rw),"^",24)
 		.s dateTo=$P(^CTLOC(rw),"^",25)
 		.s h=+$h
 		.q:(((h<dateFrom)&&(dateFrom'=""))!((h>dateTo)&&(dateTo'="")))
 		.q:c=""
		.s ItmLocID=rw
		.s ItmLocDesc=c
		.s CTLocCode= $p($g(^CTLOC(rw)),"^",43)
  		.s comparWarddesc=$$ALPHAUP^SSUTIL4(CTLocCode)	 	
		.q:(content'="")&((($$ALPHAUP^SSUTIL4(ItmLocDesc))'[($$ALPHAUP^SSUTIL4(content)))&(comparWarddesc'[($$ALPHAUP^SSUTIL4(content))))
		.d OutputRow11
		 
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow11
	set Data=$lb(ItmLocID,ItmLocDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetListItemLocExecuteBAK(ByRef qHandle As %Binary, cboBigCTLoc As %String = "", content As %String = "") As %Status
{
	 Set repid=$I(^CacheTemp)
 	 s ind=1
 	 s cboBigCTLoc=$replace(cboBigCTLoc," ","")
 	//^User.DHCConsultLocItmI("GetChildloc",11,85,1)	
 	i cboBigCTLoc'=""
 	{
	 	s id="" f  s id=$o(^User.DHCConsultLocItmI("GetChildloc",cboBigCTLoc,id)) q:id=""  d
	 	.s ItmLocID=id
	 	.s ItmLocDesc=$P(^CTLOC(id),"^",2)
	 	.q:(content'="")&(ItmLocDesc'[content)
	 	.d OutputRow10
	 	
	 	}
	 	
	 else
	 {
		s id="" f  s id=$o(^User.DHCConsultLocItmD(id)) q:id=""  d
		.s subid="" f  s subid=$o(^User.DHCConsultLocItmD(id,subid)) q:subid=""  d
		..s ItmLocID=$listget(^User.DHCConsultLocItmD(id,subid),2)
		..s ItmLocDesc=$P(^CTLOC(LocID),"^",2)
		..q:(content'="")&(ItmLocDesc'[content)
		..d OutputRow10
		 
		 }
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow10
	set Data=$lb(ItmLocID,ItmLocDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetListItemLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListItemLocExecute ]
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

Query GetListItemLoc(cboBigCTLoc As %String = "", content As %String = "") As %Query(ROWSPEC = "ItmLocID,ItmLocDesc")
{
}

/// 多科会诊结束，插入会诊费用
/// /User.DHCConSultationNew
/// w ##class(web.DHCConsultNew).ExcuteMoreConsult("21","366","9")
ClassMethod ExcuteMoreConsultBAK(rowid As %String = "", defaultuserid As %String = "", defaultLoc As %String = "") As %String
{
	
	;;s ^sctmpv1("ExcuteMoreConsult") = rowid_","_defaultuserid_","_$g(defaultLoc)
	    //写死科室 --北京同仁医院
	/*i defaultLoc="" s defaultLoc=%session.Data("LOGON.CTLOCID")
	i defaultuserid="" s defaultuserid=%session.Data("LOGON.USERID")
	s recieveloc="2"     ///接受科室默认写为同仁医院
	s ret=""
	b ;0
	s ConSultationNewStatus=$listget(^User.DHCConSultationNewD(rowid),10)
	q:ConSultationNewStatus="F" "会诊已结束"
	q:ConSultationNewStatus="V" "会诊未开始,请先确认"
	s patadm=$listget(^User.DHCConSultationNewD(rowid),2)  ///就诊id
	 s patvisit=$p($g(^PAADM(patadm)),"^",20)
	 q:patvisit'="A" "非在院病人"
	s SendInfo=##class(web.DHCConsultNew).SendConsultApply(rowid,"E")
	i SendInfo'="0"
	{
		//TRO
		q "给电子病历发送消息失败!"
		}
	b	;1
	TS
	s id=""
	b	;2
	f  s id=$o(^User.DHCConsultationI("ConSultPontDr",rowid,id)) q:(id="")!(ret=0)  d
	.s result=^User.DHCConsultationD(id)
	.s status=$listget(result,16)
	.q:(status="E")!(status="C")
	.s ItmLoc=$listget(result,34)  //要求会诊子科室
	.i ItmLoc'=""  d
	..s ConDepID=ItmLoc  //接受科室
	.e  d
	..;s ConDepID=recieveloc     //没有接受科室默认为同仁医院
	..s requestDep=$listget(result,11)  //要求会诊科室id
	..i requestDep="" d 
	...s ConDepID=recieveloc
	..e  d
	...s requestdepcode=$listget(^User.DHCConsultLocD(requestDep),5)  //科室code
	...s ConDepID=$o(^CTLOC(0,"Code",$zu(28,requestdepcode,6),""))
	...s:ConDepID="" ConDepID=recieveloc
	.s EpisodeID=$listget(result,2)
	.s CTCareId=$listget(result,20)   //多科会诊要求会诊医生
	.s userid=""
	.i CTCareId'="" s userid=$o(^SSU("SSUSR",0,"CTPCP",CTCareId,0))
	.s:userid="" userid=defaultuserid
	.b ;csq1
	.s rtn=##class(web.DHCConsult).InsertConsultOrder(userid, EpisodeID,ConDepID,id,"","") //插入费用
	.i rtn'=0 s ret=0  TRO  q
	.i rtn=0 d
	..s resultstatus="E",curdate=+$h,curtime=$p($h,",",2)
	..s CTCareDr=$p(^SSU("SSUSR",userid),"^",14)  //
	..//i CTCareDr="" s CTCareDr=$p(^SSU("SSUSR",defaultuserid),"^",14)  //
	..//&SQL(update sqluser.DHC_Consultation set Status=:resultstatus,ExecuteConDep=:defaultLoc,ConsultDoc=:CTCareDr,ConsultDate=:curdate,ConsultTime=:curtime where ID=:id)
	..&SQL(update sqluser.DHC_Consultation set Status=:resultstatus,ConsultDoc=:CTCareDr,ConsultDate=:curdate,ConsultTime=:curtime where ID=:id)
	//q:ret="0" "error"
	s obj=##class(User.DHCConSultationNew).%OpenId(rowid)
	if $IsObject(obj)
	{
		s obj.Status="F"  //多科会诊结束
		d obj.%Save()
		}
	i ret=0
	{
		TRO
		q "error"
		}
	
	TC*/
	q 0
}

/// 多科会诊结束，插入会诊费用
/// /User.DHCConSultationNew
/// w ##class(web.DHCConsultNew).ExcuteMoreConsult("17","366","9")
ClassMethod ExcuteMoreConsult(rowid As %String = "", defaultuserid As %String = "", defaultLoc As %String = "") As %String
{
	
	;s ^sctmpv1("ExcuteMoreConsult") = rowid_","_defaultuserid_","_$g(defaultLoc)
	    //写死科室 --北京同仁医院
	i defaultLoc="" s defaultLoc=%session.Data("LOGON.CTLOCID")
	i defaultuserid="" s defaultuserid=%session.Data("LOGON.USERID")
	s recieveloc="811"     ///接受科室默认写为同仁医院
	s ret=""
	b ;0
	s ConSultationNewStatus=$listget(^User.DHCConSultationNewD(rowid),10)
	q:ConSultationNewStatus="F" "会诊已结束"
	q:ConSultationNewStatus="V" "会诊未开始,请先确认"
	s patadm=$listget(^User.DHCConSultationNewD(rowid),2)  ///就诊id
	 s patvisit=$p($g(^PAADM(patadm)),"^",20)
	 q:(patvisit'="A")&&(patvisit'="D") "非在院病人"
	s SendInfo=##class(web.DHCConsultNew).SendConsultApply(rowid,"E")
	i SendInfo'="0"
	{
		//TRO
		q "给电子病历发送消息失败!"
		}
	b	;1
	TS
	s id=""
	b	;2
	f  s id=$o(^User.DHCConsultationI("ConSultPontDr",rowid,id)) q:(id="")!(ret=0)  d
	.b ;4
	.s result=^User.DHCConsultationD(id)
	.s status=$listget(result,16)
	.q:(status="E")!(status="C")
	.s ItmLoc=$listget(result,34)  //要求会诊子科室
	.i ItmLoc'=""  d
	..s ConDepID=ItmLoc  //接受科室
	.e  d
	..;s ConDepID=recieveloc     //没有接受科室默认为同仁医院
	..s requestDep=$listget(result,11)  //要求会诊科室id
	..i requestDep="" d 
	...s ConDepID=recieveloc
	..e  d
	...s requestdepcode=$p($g(^CTLOC(requestDep)),"^",1) ;$listget(^User.DHCConsultLocD(requestDep),5)  //科室code
	...s ConDepID=$o(^CTLOC(0,"Code",$zu(28,requestdepcode,6),""))
	...s:ConDepID="" ConDepID=recieveloc
	.s EpisodeID=$listget(result,2)
	.s CTCareId=$listget(result,20)   //多科会诊要求会诊医生
	.s userid=""
	.i CTCareId'="" s userid=$o(^SSU("SSUSR",0,"CTPCP",CTCareId,0))
	.s:userid="" userid=defaultuserid
	.b ;csq1
	.s objSC=##class(User.DHCConsultation).%OpenId(id)
	.b ;s InOut = obj.InOut
	.s rtn=##class(User.DHCConsultation).ChangeStatus(id, "E", "Y", userid, EpisodeID, objSC.ConsultDep )
	.;s rtn=##class(web.DHCConsult).InsertConsultOrder(objSC.AppDoc, objSC.AppDep,EpisodeID,objSC.ConsultDep,objSC.ConsultDoc,objSC.InOut,objSC.DocGrade,"E") //插入费用
	.i rtn'=0 s ret=0  TRO  q
	.i rtn=0 d
	..s resultstatus="E",curdate=+$h,curtime=$p($h,",",2)
	..s CTCareDr=$p(^SSU("SSUSR",userid),"^",14)  //
	..//i CTCareDr="" s CTCareDr=$p(^SSU("SSUSR",defaultuserid),"^",14)  //
	..//&SQL(update sqluser.DHC_Consultation set Status=:resultstatus,ExecuteConDep=:defaultLoc,ConsultDoc=:CTCareDr,ConsultDate=:curdate,ConsultTime=:curtime where ID=:id)
	..&SQL(update sqluser.DHC_Consultation set Status=:resultstatus,ConsultDoc=:CTCareDr,ConsultDate=:curdate,ConsultTime=:curtime where ID=:id)
	//q:ret="0" "error"
	s obj=##class(User.DHCConSultationNew).%OpenId(rowid)
	if $IsObject(obj)
	{
		s obj.Status="F"  //多科会诊结束
		d obj.%Save()
		}
	i ret=0
	{
		TRO
		q "error"
		}
	b ;3
	TC
	q 0
}

/// 集成平台调用插入费用的医嘱，单科会诊
/// 医生工号,会诊科室id，会诊主键
/// 执行会诊
ClassMethod ExcuteConsult(userCode As %String = "", ConDepCode As %String = "", ConAppID) As %String
{
	
	q:ConAppID="" "会诊单主键为空"
	 s ^TEMPExcuteConsult(ConAppID,+$h,$p($h,",",2))=userCode_"#"_ConDepCode_"#"_$g(ConAppID)
	 s allItem=$g(^User.DHCConsultationD(ConAppID))
	 s curStatuscode=$listget(allItem,16)  //当前会诊状态
	 q:(curStatuscode="E") "会诊已执行,不能执行！"
	 q:(curStatuscode="C") "会诊撤销,不能执行！"
	 q:ConDepCode="" "缺少科室编码"
	 s userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",$zu(28,userCode,6),""))
	 q:userid="" "缺少工号"
	 s ConDepID=$o(^CTLOC(0,"Code",$zu(28,ConDepCode,6),""))
	 q:ConDepID="" "缺少接收科室"
	 s patadm=$listget(allItem,2)  ///就诊id
	 s patvisit=$p($g(^PAADM(patadm)),"^",20)
	 q:patvisit'="A" "非在院病人"
	 TS
	  s CTCareDr=$p(^SSU("SSUSR",userid),"^",14)  //
	 i CTCareDr'="" s CTCareTp=$p(^CTPCP(CTCareDr,1),"^",4)
	 e  s CTCareTp=""
	 s docgrade=$s(CTCareTp="1":"D",CTCareTp="2":"A",CTCareTp="3":"C",CTCareTp="4":"P",CTCareTp="5":"E",1:"")
	 
	 s obj=##class(User.DHCConsultation).%OpenId(ConAppID)
	 i $ISObject(obj)
	 {
		 s obj.Status="E"            //会诊执行
		 s obj.ConsultDate=+$h       //会诊日期
	     s obj.ConsultTime=$p($h,",",2)
	     s obj.ConsultDoc=CTCareDr    //会诊医生
	     s obj.ExecuteConDep=ConDepID
	     s obj.DocGrade=docgrade   //获取医护人员医师级别
		 d obj.%Save()
		 d obj.%Close()
		 }
		 
     //插入费用
     s EpisodeID=$listget($g(^User.DHCConsultationD(ConAppID)),2)
     s InOut=$listget($g(^User.DHCConsultationD(ConAppID)),14)
     b ;开始插入费用
	 s rtn=##class(web.DHCConsult).InsertConsultOrder(userid, EpisodeID,ConDepID,ConAppID,InOut,docgrade)
	 if rtn'="0"
	 {
		 TRO
		 q trn
		 }
		 TC
	 q rtn
}

/*// 调用平台接口，发送会诊申请
ClassMethod SendConsultApply(Adm, RetStr) As %String
{
	for i=1:1:$l(RetStr,"^") {
		set RetInfo=$p(RetStr,"^",i)
		set oeitm=$p(RetInfo,"*",2)
		continue:oeitm=""
		continue:'$d(^TEMPTRYYOEORDITEM("Consult",oeitm))
		set ConsSheetID=$o(^TEMPTRYYOEORDITEM("Consult",oeitm,""))
		set ConsultInfo=..GetConsultInfo(Adm,oeitm,ConsSheetID)
		s ^jasontr("consult",oeitm,2)=ConsultInfo
		set ret=##class(web.DHCENS.EnsHISService).SendConsSheet(ConsultInfo)
		if ret=0 {
			set ^TEMPTRYYOEORDITEM("Consult",oeitm,ConsSheetID)="Y"
		}else{
			set ^TEMPTRYYOEORDITEMERROR("ConsultErr",Adm,$zd(+$h,3),oeitm,ConsSheetID)=""
		}
	}
}
*/
/// 调用平台接口，发送会诊申请
/// /多科会诊确认时发送
/// /sendflag:"V":确认时发送 ，E：会诊完成时发送
/// w ##class(web.DHCConsultNew).SendConsultApply("38","V")
ClassMethod SendConsultApply(Id As %String = "", sendflag As %String = "") As %String
{
	
	q:Id="" ""
	s conid="0",resultConId="0"
	f  s conid=$o(^User.DHCConsultationI("ConSultPontDr",Id,conid)) q:conid=""  d
	.set ConsultInfoconid=..GetConsultInfo(conid,sendflag)
	.b ;123
	.;s ^Tempcs("info",ConsultInfoconid)=ConsultInfoconid
	.set ret="0^0^0" ;##class(web.DHCENS.EnsHISService).SendConsSheet(ConsultInfoconid)
	.b ;456
	.i $p(ret,"^",1)=0  d
	..s ^TEMPSENDConsultDate("Consult",Id,+$h,conid)="Y"
	.e  d
	..s ^TEMPSENDConsultDate("ConsultErr",Id,+$h,conid)=""
	..s resultConId="false"
	q resultConId
}

/// conid:会诊id   sendflag:"V":确认时发送 ，E：会诊完成时发送
ClassMethod GetConsultInfo(conid As %String = "", sendflag As %String = "") As %String
{
	;s ^sctmpv1("GetConsultInfo") = conid _","_ sendflag
	n (conid,sendflag)
	Quit:conid="" ""
	s result=^User.DHCConsultationD(conid)
	s PAADMRowId=$listget(result,2)  //就诊id
	Quit:PAADMRowId="" ""
	set PatientId=$p($g(^PAADM(PAADMRowId)),"^",1)
	set AdmName=$p($g(^PAPER(PatientId,"ALL")),"^",1)
	set MedicareNo=##class(web.DHCWMRService).IGetMrNoByEpisodeID(PAADMRowId)
	i MedicareNo="-2" s MedicareNo=""  //q "病案卷不存在"
    i MedicareNo="-1" s MedicareNo="" //q "获取病案号失败"
	set BedID=$p($g(^PAADM(PAADMRowId)),"^",73)
	set BedNo=$p($g(^PAWARD(+BedID,"BED",$p(BedID,"||",2))),"^",1)
	set AdmDate=$$$zd($p($g(^PAADM(PAADMRowId)),"^",6),3)	
	set ApplyType="HZ",ApplyStatus=1,ApplyCondition=""   ///ApplyType申请类型固定 申请状态ApplyStatus固定
	set:sendflag="E" ApplyStatus="2"
	set OrdDeptDR=$p(^PAADM(PAADMRowId),"^",4) //$p($g(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),1)),"^",3)
	set ApplyDeptCode=$p($g(^CTLOC(OrdDeptDR)),"^",1)
	set ApplyDeptDesc=$p($g(^CTLOC(OrdDeptDR)),"^",2)
	set DoctorDR=$listget(result,5)          //$p($g(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),1)),"^",11)
	set ApplyDocCode=$p($g(^CTPCP(DoctorDR,1)),"^",1)
	set ApplyDocDesc=$p($g(^CTPCP(DoctorDR,1)),"^",2)
	set OEORIDate=$listget(result,3)      //$p($g(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),3)),"^",7)
	set OEORITime=$listget(result,6)  //$p($g(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),1)),"^",17)
	set ApplyDate=$$$zd(OEORIDate,3)_" "_$zt(OEORITime,1)
	set DepProcNotes=$listget(result,8)   //会诊备注$g(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),"DEP",1))
	set DepProcNotes=$replace(DepProcNotes,"^","")  
	set Consultdep=$listget(result,11)  //找处置科室
	b ;1234
	;i Consultdep'="" set Consultdepcode=$listget(^User.DHCConsultLocD(Consultdep),5)  
	;e  s Consultdepcode=""
	
	;i Consultdepcode'="" s ConDepID=$o(^CTLOC(0,"Code",$zu(28,Consultdepcode,6),""))
	s ConDepID = Consultdep
	i $g(ConDepID)'=""
	{
		s TreatDeptCode=$p($g(^CTLOC(ConDepID)),"^",1)
		s TreatDeptDesc=$p($g(^CTLOC(ConDepID)),"^",2)
		
		}
	else
	{
	set TreatDeptCode="",TreatDeptDesc=""            ///处置科室
	}
	set ConsultInfo=MedicareNo_"^"_AdmName_"^"_BedNo_"^"_BedID_"^"_ApplyType_"^"_ApplyDeptCode_"^"_ApplyDeptDesc
	set ConsultInfo=ConsultInfo_"^"_ApplyStatus_"^"_ApplyCondition_"^"_DepProcNotes_"^"_AdmDate_"^"_ApplyDeptCode
	set ConsultInfo=ConsultInfo_"^"_ApplyDocDesc_"^"_ApplyDate_"^"_TreatDeptCode_"^"_TreatDeptDesc_"^"_conid_"^"_sendflag
	
	Quit ConsultInfo
}

/// /获取会诊医生
/// /用于会诊审核界面，弹出会诊界面往gridpanel里添加数据时用
ClassMethod GetConSultDoc(ctcpId As %String = "") As %String
{
	q:ctcpId="" ""
	s ctcpDesc=$p($g(^CTPCP(ctcpId,1)),"^",2)	
	q ctcpDesc
}

/// /获取会诊子科室
/// /用于会诊审核界面，弹出会诊界面往gridpanel里添加数据时用
ClassMethod GetConSultItmDep(ItmLocId As %String = "") As %String
{
	q:ItmLocId="" ""
	q:'($ISVALIDNUM(ItmLocId)) ""
	s ItmLocDesc=$P(^CTLOC(ItmLocId),"^",2)  //会诊子科室
	s:ItmLocDesc["-" ItmLocDesc=$p(ItmLocDesc,"-",2)
	q ItmLocDesc
}

/// 判断是否隐藏按钮
ClassMethod Ifhiddenelement(rowid As %String = "") As %String
{
	s ret=""
	s obj=##class(User.DHCConSultationNew).%OpenId(rowid)
	if $IsObject(obj)
	{
		s ret=obj.Status
		}
	q ret
}

// typ: DIS^出院诊断 M^主诊断 PRE^初步诊断

ClassMethod Diag(mradm, typ)
{
 //web.DHCMGNurComm^GetPat^^S0|PATNAME@S1|AGE@S2|SEX@S3|DIAG@S4|LOC
         s i=0
         s diag=""
         f a2=1:1:$g(^MR(mradm,"DIA",0)) d
         .s icdr=$p($g(^MR(mradm,"DIA",a2)),"^",1)
         .i icdr'="" d
         ..s diatypedr=$P($g(^MR(mradm,"DIA",a2,"TYP",1)),"^",1)
         ..i $g(diatypedr)'="" s diatype=$P($g(^MRC("DTYP",diatypedr)),"^",1)  ;诊断类型
         ..e  s diatype=""
         ..;q:diatype'=typ
         ..q:(diatype'=typ)&(typ'="")
         ..s date=$$$ZD($p($g(^MR(mradm,"DIA",a2)),"^",7),3) ;日期
         ..s statusdr=$p($g(^MR(mradm,"DIA",a2)),"^",9)
         ..//i statusdr'="" d
         ..//.s status=$P($g(^MRC("DSTAT",statusdr)),"^",2)
         ..//.e  d
         ..//..s status=""
         ..s icdcode=$P($g(^MRC("ID",icdr)),"^",2)   ;疾病描述
         ..s mrdesc=""
         ..f de=1:1:$g(^MR(mradm,"DIA",a2,"DES",0)) d
         ...s mrdesc=$g(mrdesc)_$g(^MR(mradm,"DIA",a2,"DES",de)) ;
         ..s i=i+1
         ..;s diag=icdcode_" "_$g(mrdesc)
         ..i diag="" s diag=icdcode_" "_$g(mrdesc)
         ..e  s diag=diag_";"_icdcode_" "_$g(mrdesc)
          
          
          s ret="",MRDIADesc=""
         s chl="" f  s chl=$o(^MR(mradm,"DIA",chl)) q:chl=""  d
         .q:chl=""
         .s typedr=$P($g(^MR(mradm,"DIA",chl,"TYP",1)),"^",1)
         .i $g(typedr)'="" s type=$P($g(^MRC("DTYP",typedr)),"^",1)  ;诊断类型
         .e  s type=""
         .q:(type'=typ)&(typ'="")
         
         .s MRDIADesc=0 s MRDIADesc=$o(^MR(mradm,"DIA",chl,"DES",MRDIADesc))
         .q:MRDIADesc=""
         .s MRDIADesc=$p(^MR(mradm,"DIA",chl,"DES",MRDIADesc),"^",1)
         .i ret="" s ret=MRDIADesc
         .e  s ret=ret_";"_MRDIADesc
         i (ret'="")&(diag'="") s diag=diag_";"_ret
         i diag="" s diag=ret
         
         q diag
}

/// //获取默认会诊子科室,多个子科室返回空，多科会诊申请,添加科室时自动添加子科室
ClassMethod GetItemLocStr(biglocid As %String = "")
{
	q:biglocid="" ""
	s ret=""
	s id=""
	f  s id=$o(^User.DHCConsultLocItmD(biglocid,id)) q:id=""  d
	.s ctlocid=$listget(^User.DHCConsultLocItmD(biglocid,id),2)
	.i ret="" s ret=ctlocid
	.e  s ret=ret_"^"_ctlocid
	i $l(ret,"^")>1 s ret=""
	q ret
}

/// 补发会诊申请 add by gj 20151205
/// w ##class(web.DHCConsultNew).ReSendConsultApply()
ClassMethod ReSendConsultApply() As %String
{
	
	s conid="19379",sendflag="V"
	f  s conid=$o(^User.DHCConsultationD(conid)) q:conid="19464"  d
	.set ConsultInfoconid=..GetConsultInfo(conid,sendflag)
	.i ConsultInfoconid'="" d
	..s ApplyDate=$p(ConsultInfoconid,"^",14)
	..s ApplyTime=$p(ApplyDate," ",2)
	..s:ApplyTime'="" ApplyTime=$zth(ApplyTime,1)
	.;b ;111
	.q:$g(ApplyTime)<34800
	.;b ;222
	.set ret=##class(web.DHCENS.EnsHISService).SendConsSheet(ConsultInfoconid)
	.i $p(ret,"^",1)=0  d
	..s ^tmpguojie("Consult",+$h,conid)="Y"
	.e  d
	..s ^tmpguojie("ConsultErr",+$h,conid)=""
    q 0
}

/// Creator:      SongChao
/// CreateDate:   2017.8.23
/// Description:  删除会诊科室
/// Input:		  id,dep
/// Return:       
/// Other:  ##class(web.DHCConsultNew).deleteLoc(111,3)
ClassMethod deleteLoc(objID)
{
	s ret=""
	q:objID="" ret
	;s objID = id_"||"_idsub
	set sc = ##class(User.DHCConSultationNewSub).%DeleteId(objID)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set ret=-1
	}else{
		set ret=1
	}
	q ret
}

}
