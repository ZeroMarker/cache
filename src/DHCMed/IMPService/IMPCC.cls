Class DHCMed.IMPService.IMPCC Extends (%RegisteredObject, DHCMed.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// Creator：     liuyh
/// CreatDate：   2010-10-19
/// Description:  监控重点患者
/// d ##class(%ResultSet).RunQuery("DHCMed.IMPService.IMPCC","QueryPatientInfo","A","","","","","","","","","I","*1*2*3",2,2)
Query QueryPatientInfo(InHospital As %String, MrNo As %String, RegNo As %String, DateFrom As %String, DateTo As %String, Loc As %String, Ward As %String, PatName As %String, CardNo As %String, CurrentAdmType As %String, IMPCCList As %String, Type As %String, SubjectID As %String) As %Query(ROWSPEC = "Paadm:%String,PatientID:%String,AdmitDate:%String:住院日期,Room:%String:病室,Bed:%String:病床,DoctorName:%String,Department:%String:就诊科室,Ward:%String:病区,RegNo:%String:登记号,PatientName:%String:患者姓名,Sex:%String:性别,Age:%String:年龄,DisDate:%String:出院日期,Score:%String:分数,retStoreID:%String,detail:%String:监控明细,FireItmCnt:%String:触发项目数量,FireDetail:%String:触发项目,PatientID:%String,IMPType:%String")
{
}

ClassMethod QueryPatientInfoExecute(ByRef qHandle As %Binary, InHospital As %String, MrNo As %String, RegNo As %String, DateFrom As %String, DateTo As %String, Loc As %String, Ward As %String, PatName As %String, CardNo As %String, CurrentAdmType As %String, IMPCCList As %String, Type As %String, SubjectID As %String) As %Status
{
	s Mrepid=$I(^CacheTemp)
	s qHandle=$lb(0,Mrepid,0)
	s inds=1
	q:$g(InHospital)="" $$$OK
	s:CurrentAdmType="" CurrentAdmType="I"
	s Singleflag=0,AdmitDate=0
	s:DateFrom["/" DateFrom=$zdh(DateFrom)
	s:DateTo["/" DateTo=$zdh(DateTo)
	s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	s:DateTo["-" DateTo=$zdh(DateTo,3)
	
	/*
	i CardNo'=""  d    // 卡号不为空
	.s Singleflag=1
	.s CardRefRowid=0
	.f  s CardRefRowid=$o(^DHCCARDi("CF",0,"CardNo",CardNo,CardRefRowid)) q:CardRefRowid=""  d
	..s tmp=$g(^DHCCARD("CF",+CardRefRowid))
	..q:tmp=""
	..s PAPMI=$p(tmp,"^",4)
	..q:PAPMI=""
	..s ret=$$GetInfoFromPAPMI()
	q:Singleflag=1 $$$OK
	
	i ($g(RegNo)'="") d   //登记号不为空
	.s RegNo=+RegNo
	.s Singleflag=1
	.s len=10
	.s PATCFid=$o(^CF("PATCF",""))
	.i PATCFid'="" s len=$p($g(^CF("PATCF",PATCFid,3)),"^",5)
	.i $l(RegNo)<len d
	..s prelen=len-$l(RegNo)
	..f i=1:1:prelen s RegNo="0"_RegNo
	.s PAPMI=$o(^PAPERi("PAPMI_PatNo",RegNo,""))
	.q:$g(PAPMI)=""
	.s ret=$$GetInfoFromPAPMI()
	q:Singleflag=1 $$$OK
	
	i PatName'=""  d    // 病人姓名不为空
	.s Singleflag=1
    .s PAPMI=""
    .f  s PAPMI=$o(^PAPERi("PAPER_PatName",PatName,PAPMI)) q:PAPMI=""  d
	..s ret=$$GetInfoFromPAPMI()
	q:Singleflag=1 $$$OK
	
	//病案系统接口调用：病案号取病人ID接口
	i MrNo'="" d   // 病案号不为空
	.s Singleflag=1
	.s PatientIDs=##Class(DHCWMR.IO.OutService).IGetPatientIDByMrNo(MrNo,"I","","")
	.q:PatientIDs'=""
	.f indPat=1:1:$l(PatientIDs,",") d
	..s PAPMI=$p(PatientIDs,",",indPat)
	..q:PAPMI=""
	..s ret=$$GetInfoFromPAPMI()
	q:Singleflag=1 $$$OK
	*/
	
	s storeID=$I(^CacheTemp)
	s PaadmNum=1
	s detail=""
	
	i InHospital="A" d   // 在院
	.i +Ward>0 d   // 病区不为空
	..s Singleflag=1
    ..q:'$d(^PAADMi("CurrWard",+Ward))
    ..s Room="" f  s Room=$o(^PAADMi("CurrWard",+Ward,Room)) q:Room=""  d
    ...s paadm="" f  s paadm=$o(^PAADMi("CurrWard",+Ward,Room,paadm)) q:paadm=""  d
    ....;s ret=$$GetPatInfo()
    ....s objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(paadm)
    ....q:$IsObject(objAdm)=0
    ....q:((Loc'="")&(Loc'=objAdm.DepartmentID))
    ....s:objAdm.AdmitDate["-" AdmitDate=$zdh(objAdm.AdmitDate,3)
    ....q:((+DateFrom>0)&(AdmitDate<DateFrom))
    ....q:((+DateTo>0)&(AdmitDate>DateTo))
    ....;q:((PatName'="")&(objPatient.PatientName'[PatName))
    ....s ^CacheTemp(storeID,PaadmNum)= paadm
    ....s PaadmNum=PaadmNum+1
    ....;s ret=$$OutputRow()
    .e  i ((+Loc>0)&(+Ward=0)) d   // 科室不为空，病区为空
    ..s Singleflag=1
    ..s DeptItem=Loc
    ..s:DateFrom'="" Date=DateFrom-1
    ..f i=1:1:$l(CurrentAdmType,"/")  d
    ...s cAdmType=$p(CurrentAdmType,"/",i) 
    ...s Date=""
    ...f  s Date=$o(^PAADMi("AdmTypeCurrLoc",cAdmType,DeptItem,Date)) q:((Date="")||((DateTo'="")&(Date>DateTo)))  d
    ....s Time=""
    ....f  s Time=$o(^PAADMi("AdmTypeCurrLoc",cAdmType,DeptItem,Date,Time)) q:(Time="")  d
    .....s paadm=""
    .....f  s paadm=$o(^PAADMi("AdmTypeCurrLoc",cAdmType,DeptItem,Date,Time,paadm)) q:(paadm="")  d
    ......;s ret=$$GetPatInfo()
    ......s objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(paadm)
    ......q:$IsObject(objAdm)=0
    ......s:objAdm.AdmitDate["-" AdmitDate=$zdh(objAdm.AdmitDate,3)
    ......q:((+DateFrom>0)&(AdmitDate<DateFrom))
    ......q:((+DateTo>0)&(AdmitDate>DateTo))
    ......s ^CacheTemp(storeID,PaadmNum)= paadm
    ......s PaadmNum=PaadmNum+1
	......;s ret=$$OutputRow()
	.e  d   //查询全院在院患者
	..s DeptItem=""
	..f  s DeptItem=$o(^CTLOC(DeptItem)) q:DeptItem=""  d
	...s LocType=$p($g(^CTLOC(DeptItem)),"^",13)
	...q:LocType'="E"
	...s Date=""
    ...f  s Date=$o(^PAADMi("AdmTypeCurrLoc","I",DeptItem,Date)) q:(Date="")  d
    ....s Time=""
    ....f  s Time=$o(^PAADMi("AdmTypeCurrLoc","I",DeptItem,Date,Time)) q:(Time="")  d
    .....s paadm=""
    .....f  s paadm=$o(^PAADMi("AdmTypeCurrLoc","I",DeptItem,Date,Time,paadm)) q:(paadm="")  d
    ......;s ret=$$GetPatInfo()
    ......s objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(paadm)
    ......q:$IsObject(objAdm)=0
    ......s AdmitDate=0
    ......s:objAdm.AdmitDate["-" AdmitDate=$zdh(objAdm.AdmitDate,3)
    ......s:objAdm.AdmitDate["/" AdmitDate=$zdh(objAdm.AdmitDate,4)
    ......q:((+DateFrom>0)&(AdmitDate<DateFrom))
    ......q:((+DateTo>0)&(AdmitDate>DateTo))
    ......s ^CacheTemp(storeID,PaadmNum)= paadm
    ......s PaadmNum=PaadmNum+1
    ......;s ret=$$OutputRow()
    ;q:Singleflag=1 $$$OK
	
	e  i InHospital="D" d   // 出院
	.i ((DateFrom'="")&(DateTo'="")) d
	..s Singleflag=1
	..s Date=DateFrom
	..f Date=DateFrom:1:DateTo  d
	...s paadm=""
	...f  s paadm=$o(^PAADMi("DischDate",Date,paadm)) q:paadm=""  d
	....;s ret=$$GetPatInfo()
	....s objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(paadm)
    ....q:$IsObject(objAdm)=0
	....q:((Loc'="")&(Loc'=objAdm.DepartmentID))
	....q:((Ward'="")&(Ward'=objAdm.WardID))
	....s ^CacheTemp(storeID,PaadmNum)= paadm
    ....s PaadmNum=PaadmNum+1
	....;s ret=$$OutputRow()
	.e  i ((DateFrom'="")||(DateTo'=""))  d
	..s Date=""
	..i DateFrom'="" d
	...s Date=DateFrom
	..e  d
	...s Date=DateTo
	..s paadm=""
	..f  s paadm=$o(^PAADMi("DischDate",Date,paadm)) q:paadm=""  d
	...;s ret=$$GetPatInfo()
	...s objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(paadm)
    ...q:$IsObject(objAdm)=0
	...q:((Loc'="")&(Loc'=objAdm.DepartmentID))
	...q:((Ward'="")&(Ward'=objAdm.WardID))
	...s ^CacheTemp(storeID,PaadmNum)= paadm
    ...s PaadmNum=PaadmNum+1
	...;s ret=$$OutputRow()
	;q:Singleflag=1 $$$OK
	s retStoreID=""
	;i IMPCCList'="" d
    ;.;d ##class(%Library.ResultSet).RunQuery("DHCMed.CCService.System.VMShell","RunVM",3,storeID)
	s:Type=2 retStoreID=##class(DHCMed.CCService.System.VM).Process(SubjectID,storeID,IMPCCList)
	s retStoreID=$g(retStoreID)
	s:retStoreID'="" retStoreID=$li(retStoreID,2)
	s num=0
	f  s num=$o(^CacheTemp(storeID,num)) q:num=""  d
	.s paadm=^CacheTemp(storeID,num)
	.q:(Type=2)&&(retStoreID'="")&&($p($g(^CacheTemp(retStoreID,"Paadm",paadm)),"^",2)<1) //未触发任何项目的不显示
	.s detail=..GetIMPCCExp(retStoreID,paadm)
	.s retStr=$$GetPatInfo()
	.s ret=$$OutputRow()
	
	k ^CacheTemp(storeID)
	k:retStoreID'="" ^CacheTemp(retStoreID)
	q $$$OK
	
GetPatInfo()
   s objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(paadm)
   q:$IsObject(objAdm)=0
   s objPatient=##class(DHCMed.Base.Patient).GetObjById(objAdm.PatientID)
   q:$IsObject(objPatient)=0
   s $li(data,1)=objAdm.AdmRowID
   s $li(data,2)=objAdm.PatientID
   s $li(data,3)=objAdm.AdmitDate
   s $li(data,4)=objAdm.Room
   s $li(data,5)=objAdm.Bed
   s $li(data,6)=objAdm.DoctorName
   s $li(data,7)=objAdm.Department
   s $li(data,8)=objAdm.Ward
   s $li(data,9)=objPatient.PapmiNo
   s $li(data,10)=objPatient.PatientName
   s $li(data,11)=objPatient.Sex
   s $li(data,12)=objPatient.Age
   s $li(data,13)=objAdm.DisDate
   s:$li(data,13)="1840-12-31" $li(data,13)=""
   s $li(data,14)=""
   s:retStoreID'="" $li(data,14)=$p($g(^CacheTemp(retStoreID,"Paadm",paadm)),"^",1)
   s $li(data,15)=retStoreID
   s $li(data,16)=detail	//监控结果明细
   s:detail<0 $li(data,16)=""
   s $li(data,17)=""
   s:retStoreID'="" $li(data,17)=$p($g(^CacheTemp(retStoreID,"Paadm",paadm)),"^",2)
   s $li(data,18)=""
   i (retStoreID'="")&&($d(^CacheTemp(retStoreID,"Paadm",paadm))) d
   .s ID=""
   .f  s ID=$o(^CacheTemp(retStoreID,"Paadm",paadm,ID)) q:(ID="")||(+ID=0)  d
   ..s:$li(data,18)'="" $li(data,18)=$li(data,18)_";"_^CacheTemp(retStoreID,"Paadm",paadm,ID)
   ..s:$li(data,18)="" $li(data,18)=^CacheTemp(retStoreID,"Paadm",paadm,ID)
   //Add By LiYang 2011-03-06
   s $li(data,19)=objAdm.PatientID 
   s tmp=##class(DHCMed.IMPService.IMPAdmQry).GetData(objAdm.AdmRowID)
   s $li(data,20)=$li(tmp,13) //重点患者标记信息
   q 1
OutputRow()
   s ^CacheTemp(Mrepid,inds)=data
   s inds=inds+1
   k objAdm
   k objPatient
   q 1
}

ClassMethod QueryPatientInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPatientInfoExecute ]
{
	Set Mrepid=$LIST(qHandle,2)
 	Kill ^CacheTemp(Mrepid)
	Quit $$$OK
}

ClassMethod QueryPatientInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef MAtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPatientInfoExecute ]
{
	Set MAtEnd=$LIST(qHandle,1)
 	Set Mrepid=$LIST(qHandle,2)
 	Set inds=$LIST(qHandle,3)
 	Set inds=$o(^CacheTemp(Mrepid,inds))
 	//w !,"Mrepid="_Mrepid
 	If inds="" {
 		Set MAtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(Mrepid,inds)
 	}
 	//w !,"   Row="_Row
 	s qHandle=$lb(MAtEnd,Mrepid,inds)
	
	Quit $$$OK
}

/// 描述：取监控结果详细信息
/// w ##Class(DHCMed.IMPService.IMPCC).GetIMPCCExp(3,3164)
ClassMethod GetIMPCCExp(tstoreID As %String, tpaadm As %String) As %String
{
	n (tstoreID,tpaadm)
	s ret=-1,str="",detInfo=""
	q:(tstoreID="")||(tpaadm="") ret
	q:'$d(^CacheTemp(tstoreID,"Paadm",tpaadm)) ret
	s rowid=""
	f  s rowid=$o(^CacheTemp(tstoreID,"Paadm",tpaadm,rowid)) q:(rowid="")||(+rowid=0)  d
	.s:str'="" str=str_";"_^CacheTemp(tstoreID,"Paadm",tpaadm,rowid)
	.s:str="" str=^CacheTemp(tstoreID,"Paadm",tpaadm,rowid)
	.s:detInfo'="" detInfo=detInfo_"<br><b style=margin:50px'>"_^CacheTemp(tstoreID,"Paadm",tpaadm,rowid)_" 明细:</b>"
	.s:detInfo="" detInfo="<b style=margin:50px'>"_^CacheTemp(tstoreID,"Paadm",tpaadm,rowid)_" 明细:</b>"
	.s detID=""
	.f  s detID=$o(^CacheTemp(tstoreID,"Paadm",tpaadm,"Detail",rowid,detID)) q:detID=""  d
	..s detStr=^CacheTemp(tstoreID,"Paadm",tpaadm,"Detail",rowid,detID)
	..s:detInfo'="" detInfo=detInfo_"<br><a style=margin:80px'>"_##Class(DHCMed.CCService.System.GetCCInfo).GetCCDetail(detStr)_"</a>"
	..;s:detInfo="" detInfo=##Class(DHCMed.CCService.System.GetCCInfo).GetCCDetail(detStr)
	s:str'="" ret="<b style=margin:20px'>触发项目:</b>"_str_"<br>"_detInfo
	q ret
}

/// 描述：通过监控主题ID获取监控主题颜色信息
/// w ##Class(DHCMed.IMPService.IMPCC).GetSubColorById(2)
ClassMethod GetSubColorById(SubjectID As %String) As %String
{
	n (SubjectID)
	s ret=""
	q:SubjectID="" ret
	q:'$d(^DHCMed.CC.SubjectColorI("SubjectIndex",SubjectID)) ret
	
	s rowid=""
	f  s rowid=$o(^DHCMed.CC.SubjectColorI("SubjectIndex",SubjectID,rowid)) q:rowid=""  d
	.s obj=##Class(DHCMed.CC.SubjectColor).GetObjById(rowid)
	.q:'$IsObject(obj)
	.s:ret'="" ret=ret_$c(1)_obj.Score_"^"_obj.ColorRGB
	.s:ret="" ret=obj.Score_"^"_obj.ColorRGB
	
	q ret
}

//w ##Class(DHCMed.IMPService.IMPCC).InsertData("A^^^^^^^^^I^1^2^2","DHCMed.IMPService.IMPCC","QueryPatientInfo")

ClassMethod InsertData(str As %String, ClassName As %String, QueryName As %String) As %String
{
	n (str,ClassName,QueryName)
	s retInfo="",arr=""
	s cdef = ##class(%Dictionary.ClassDefinition).%OpenId(ClassName)
	s count = cdef.Queries.Count() 
 	f i = 1:1:count d
	.i (cdef.Queries.GetAt(i).Name=QueryName) d
	..s retInfo=cdef.Queries.GetAt(i).Parameters.GetAt("ROWSPEC")

	s rowLen=$l(retInfo,",")
	
	s rset = ##class(%ResultSet).%New()
	s rset.ClassName = ClassName
	s rset.QueryName = QueryName
	s execute="s sc=rset.Execute("
	f i=1:1:$l(str,"^")  d 
 	.s PLIST(i)=$p(str,"^",i)
 	.s:i'=$l(str,"^") execute=execute_"PLIST("_i_"),"
 	.s:i=$l(str,"^") execute=execute_"PLIST("_i_")"
 	s execute=execute_")"
	x execute
	
	s arr=arr_"var datas = [];"
	f  s info=rset.Next(.sc) q:info'=1  d
	.i $SYSTEM.Status.IsOK(sc)  d
	..s arr=arr_"datas.push({"
	..f j=1:1:rowLen d
	...s retName=$p($p(retInfo,",",j),":",1)
	...s arr=arr_retName
	...s:j'=rowLen arr=arr_":"_rset.Data(retName)_","
	...s:j=rowLen arr=arr_":"_rset.Data(retName)	//最后一个
	..s arr=arr_"});"
	
	//w arr
	q 1
}

/// Creator：     liuyh
/// CreatDate：   2010-11-03
/// Description:  根据监控主题获取主题项 json树信息
/// Table：       DHCMed.CC.Subject、DHCMed.CC.SubjectItm
/// Input：       SubjectID : 主题ID
/// Output:       childJson: 主题项json树信息
/// Return：      
/// Others:       此方法内部递归调用，构建子类树
/// w ##class(DHCMed.IMPService.IMPCC).BuildItemSubJson(3,.childJson)
ClassMethod BuildItemSubJson(SubjectID As %String, childJson As %String) As %String
{
	new (SubjectID,childJson)
	set json=""
	set retFlag=0
 	quit:'$d(^DHCMed.CC.SubjectItmI("IndexSubjectID",SubjectID,1)) "[]"
 	set itmID=""
	set itmID=$o(^DHCMed.CC.SubjectItmI("IndexSubjectID",SubjectID,1,""))
	while (itmID'=""){
		set obj=##class(DHCMed.CC.SubjectItm).%OpenId(itmID)
		if $IsObject(obj)
		{
		 	set objDic=##class(DHCMed.CC.ItemDic).%OpenId(obj.ItemDic)
		 	set IDDesc=objDic.IDDesc
	 		set:json'="" json=json_","
			set json=json_"{"_"""id"":"""_itmID_"L"",""text"":"""_IDDesc_""","
			set json=json_"""expanded"":true,"
			set json=json_"""checked"":true,"
			set json=json_"""leaf"":true"
	    	set json=json_"}"
		 }
		set itmID=$o(^DHCMed.CC.SubjectItmI("IndexSubjectID",SubjectID,1,itmID))
	 }
	set childJson="["_json_"]"
	quit childJson
}

/// Creator：     liuyh
/// CreatDate：   2010-11-03
/// Description:  根据监控主题Id构造监控主题、主题项的树形结构json串
/// Table：       DHCMed.CC.Subject、DHCMed.CC.SubjectItm
/// Return：      返回树形结构json串
/// Others:       此方法内部递归调用，构建菜单树
/// w ##class(DHCMed.IMPService.IMPCC).BuildItemJson()
ClassMethod BuildItemJson() As %String
{
	set configID=$o(^DHCMed.SS.ConfigI("IndexKeyHosp"," IMPCC",0,""))	//重点患者配置项目
	quit:+configID<1 "[]"
	set objCon=##class(DHCMed.SS.Config).%OpenId(configID)
	quit:'$IsObject(objCon) "[]"
	set SubjectID=objCon.Val
	quit:SubjectID="" "[]"
	set json=""
		//set SubjectID=$o(^DHCMed.CC.SubjectD(""))	
		//while SubjectID'=""{
			set obj=##class(DHCMed.CC.Subject).%OpenId(SubjectID)
				set:json'="" json=json_","
				set itemJson="{"_"""id"":"""_SubjectID_"P"",""text"":"""_obj.Title_""","
				//set itemJson=itemJson_"""iconCls"":""icon-pro"","
				set itemJson=itemJson_"""expanded"":true,"
				set secFlag=0,childJson="[]"
				d:$d(^DHCMed.CC.SubjectItmI("IndexSubjectID",SubjectID,1)) ..BuildItemSubJson(SubjectID,.childJson)
				set itemJson=itemJson_"""checked"":true,"
				set itemJson=itemJson_"""children"":"_childJson_"}"
				set json=json_itemJson
			
		//	set SubjectID=$o(^DHCMed.CC.SubjectD(SubjectID))
		//	}
	quit "["_json_"]"
}

}
