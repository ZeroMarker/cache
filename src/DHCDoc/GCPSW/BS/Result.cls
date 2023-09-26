/// CTOR: QP
/// DATE: 2020-09-11
/// DESC: 筛选结果
Class DHCDoc.GCPSW.BS.Result Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-09-07
/// DESC: 保存
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Result).Save()
ClassMethod Save(mList)
{
	s mRtn=0
	s PID=$p(mList,"^",2)
	s PatientID=$p(mList,"^",1)
	s id=$o(^BS.DOC.GCPSW.ResultI("PrjPat",PID,PatientID,""))
	q:id'="" 0
	i id="" {
		s a=##class(User.GCPSWResult).%New()
		d a.RPrjSetObjectId(PID)
		d a.RPatientIDSetObjectId(PatientID)
		s a.RAddDate=+$H
		s a.RAddTime=$p($h,",",2)
		
	} else {
		//s a=##class(User.GCPSWResult).%OpenId(id)
		w "UPDATE"
	}
	s sc=a.%Save()
	If $$$ISERR(sc) {
		//d $system.OBJ.DisplayError(sc) 
		s mRtn=-101
	} else {
		s mRtn=a.%Id()
	}
	d a.%Close()
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-09-03
/// DESC: 病人状态类型改变
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Result).ChgRDel("293",1)
ClassMethod ChgRDel(RID As %String, Val As %String = "")
{
	Q:RID="" 0
	&SQL(UPDATE SQLUser.GCPSW_Result SET R_Del=:Val WHERE R_ID=:RID)
	Q:SQLCODE'=0 -102
	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-09-09
/// DESC: 查询项目
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.GCPSW.BS.Result","QryPrj",1)
Query QryPrj(UserID = "") As %Query(ROWSPEC = "id,code,desc,startDate,endDate,gcpName")
{
}

ClassMethod QryPrjExecute(ByRef qHandle As %Binary, UserID = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	
 	s id=""
 	f  s id=$o(^BS.DOC.GCPSW.ResultI("RPrj",id)) q:id=""  d
 	.q:'$d(^CF.DOC.GCPSW.PrjD(id))
 	.s code=$p(^CF.DOC.GCPSW.PrjD(id),"^",1)
 	.s desc=$p(^CF.DOC.GCPSW.PrjD(id),"^",2)
 	.s startDate=$p(^CF.DOC.GCPSW.PrjD(id),"^",3)
 	.s endDate=$p(^CF.DOC.GCPSW.PrjD(id),"^",4)
 	.s PPRowId=$p(^CF.DOC.GCPSW.PrjD(id),"^",5)
 	.s gcpName=$p(^DHCDocPP(PPRowId),"^",2)
 	.s startDate=##class(DHCDoc.GCPSW.COM.Func).DateLogicalToHtml(startDate)
 	.s endDate=##class(DHCDoc.GCPSW.COM.Func).DateLogicalToHtml(endDate)
 	.s teamView=$p(^CF.DOC.GCPSW.PrjD(id),"^",11)
 	.s addUser=$p(^CF.DOC.GCPSW.PrjD(id),"^",8)
 	.s flag=##class(DHCDoc.GCPSW.COM.Func).IsPITeam(UserID,PPRowId,teamView,addUser)
 	.q:flag=0
 	.d output2
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
output2
	Set Data=$lb(id,code,desc,startDate,endDate,gcpName)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryPrjClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPrjExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPrjFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPrjExecute ]
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

/// CTOR: QP
/// DATE: 2020-09-09
/// DESC: 查询结果
/// IN  : {"InLis":"3||1^0013^1,2^FULL^1#D001^3950||1!D002^3949||1!D003^11730||1/3||2^BloodChemical^23^FULL^0#TE^2737||1","OutLis":""}
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.GCPSW.BS.Result","QryResult",2,0,^QP("QryResult",1),^QP("QryResult",2),^QP("QryResult",3))
Query QryResult(PID = "", ExtArr = "", PersonArr = "", DiagArr = "", LisArr = "", InHosp = "") As %Query(ROWSPEC = "id,PatientID,PatNo,PatName,sexDesc,age,height,weight,telPhone,admDoc,admLoc,BMI")
{
}

ClassMethod QryResultExecute(ByRef qHandle As %Binary, PID = "", ExtArr = "", PersonArr = "", DiagArr = "", LisArr = "", InHosp = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	i PID="" {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK	
	}
	//s ^QP("QryResult")=PersonArr
	s ^QP("QryResult",1)=PersonArr
	s ^QP("QryResult",2)=DiagArr
	s ^QP("QryResult",3)=LisArr
	s ^QP("QryResult",4)=ExtArr
	s ^QP("QryResult",5)=PID
	s num=0,maxNum=1000	//默认最多展示1000
	s PersonJson = ##class(ext.util.JsonObject).FromJSON(PersonArr)
	s DiagJson = ##class(ext.util.JsonObject).FromJSON(DiagArr)
	s LisJson = ##class(ext.util.JsonObject).FromJSON(LisArr)
	s InRDel=$p(ExtArr,"^",1)
	s id=""
 	f  s id=$o(^BS.DOC.GCPSW.ResultI("RPrj",PID,id)) Q:(id="")||(num>maxNum)  d
 	.q:num>maxNum
 	.s PatientID=$P(^BS.DOC.GCPSW.ResultD(id),"^",2)
 	.;待优化1，最后一次就诊需要建表存储，否则查询太慢
 	.s LastAdmInfo=""	//##class(DHCDoc.GCPSW.BS.Adm).GetLastAdmInfo(PatientID)
 	.s RDel=$P(^BS.DOC.GCPSW.ResultD(id),"^",8)
 	.i RDel="" s RDel=0
 	.q:(InRDel'="")&&(InRDel'=RDel)
 	.b ;001
 	.s exitFlag=..FilterCondition(id,PatientID,.PersonJson,.LisJson,.DiagJson,InHosp)
 	.;w exitFlag,!
 	.b ;002
 	.;w exitFlag_","
	.q:exitFlag=1
 	.s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)
 	.s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)
 	.s sex=$p(^PAPER(PatientID,"ALL"),"^",7)
 	.s sexDesc=""
 	.i sex'="" s sexDesc=$p(^CT("SEX",sex),"^",2)
 	.s age=##class(web.DHCBillInterface).GetPapmiAge(PatientID,"",InHosp)
 	.s PHW=##class(DHCDoc.GCPSW.COM.Func).GetLastHeightAndWeigh(PatientID)
 	.s height=$p(PHW,"^",1)
 	.s weight=$p(PHW,"^",2)
 	.i height=0 s height=""
 	.i weight=0 s weight=""
 	.s BMI=##class(DHCDoc.GCPSW.COM.Func).GetPatBMI(height,weight) 
 	.s telPhone=$p(^PAPER(PatientID,"PER",1),"^",11)
 	.s admLoc=""
 	.s admDoc=""
 	.i LastAdmInfo'="" d
 	..s admLoc=$p(LastAdmInfo,"^",3)
 	..s admDoc=$p(LastAdmInfo,"^",4)
 	..i admLoc'="" s admLoc=$p($g(^CTLOC(admLoc)),"^",2)
 	..i admDoc'="" s admDoc=$P($g(^CTPCP(admDoc,1)),"^",2)
 	.s num=num+1
 	
 	.d output1
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
output1
	Set Data=$lb(id,PatientID,PatNo,PatName,sexDesc,age,height,weight,telPhone,admDoc,admLoc,BMI)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryResultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryResultExecute ]
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

/// CTOR: QP
/// DATE: 2020-09-17
/// DESC: 过滤条件
/// IN  : 
/// OUT : 1退出
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Result).FilterCondition()
ClassMethod FilterCondition(RID, PatientID, ByRef PersonJson, ByRef LisJson, ByRef DiagJson, InHosp)
{
	s ok=0
	s no=1
	;过滤基本信息
	s InSex=PersonJson.GetValue("sex")
	s InAge=PersonJson.GetValue("age")
	s InHeight=PersonJson.GetValue("height")
	s InWeight=PersonJson.GetValue("weight")
	s InBMI=PersonJson.GetValue("BMI")
	i InSex'="" {
		s sex=$p(^PAPER(PatientID,"ALL"),"^",7)
		q:(InSex'[sex) no
	}
	;身高体重
	s PHW=##class(DHCDoc.GCPSW.COM.Func).GetLastHeightAndWeigh(PatientID)
 	s height=$p(PHW,"^",1)
 	s weight=$p(PHW,"^",2)
	i InHeight'="-" {
		s startHeight=$p(InHeight,"-",1)
		s endHeight=$p(InHeight,"-",2)
		q:(startHeight'="")&&(height<startHeight) no
		q:(endHeight'="")&&(height>endHeight) no	
	}
	i InWeight'="-" {
		s startWeight=$p(InWeight,"-",1)
		s endWeight=$p(InWeight,"-",2)
		q:(startWeight'="")&&(weight<startWeight) no
		q:(endWeight'="")&&(weight>endWeight) no	
	}
	;年龄
	i InAge'="" {
		s age=##class(DHCDoc.GCPSW.COM.Func).GetPapmiAge(PatientID,"",InHosp)
		s startAge=$p(InAge,"-",1)
		s endAge=$p(InAge,"-",2)
		q:(startAge'="")&&(age<startAge) no
		q:(endAge'="")&&(age>endAge) no
	}
	;BMI
	s BMI=##class(DHCDoc.GCPSW.COM.Func).GetPatBMI(height,weight)
	i InBMI'="-" {
		s startBMI=$p(InBMI,"-",1)
		s endBMI=$p(InBMI,"-",2)
		q:(startBMI'="")&&(BMI<startBMI) no
		q:(endBMI'="")&&(BMI>endBMI) no	
	}
	;b ;001
	;过滤诊断
	s InDiag=DiagJson.GetValue("InDiag")
	;b ;04
	//7480-16625-16396-哈哈-8456
	i InDiag'="" {
		s hasDiag=..HasDiagnosis(PatientID,InDiag)
		;b ;0023
		q:hasDiag'=1 no
		
	}
	//Q ok
	;b ;002
	;过滤检验
	;"3||1#WhiteCell^1!Hemochrome^2!Platelet^3/3||2#TE^12"
	s InLis=LisJson.GetValue("InLis")
	s IsBlank=..IsLisKPIBalnk(InLis)
	i IsBlank=0 {
		;b ;00LIS
		s hasLis=..HasLis(RID,PatientID,InLis)
		;b ;0024
		q:hasLis'=1 no
	}
	
	Q ok
}

/// CTOR: QP
/// DATE: 2020-09-28
/// DESC: 解析检验指标串，判断是否为空
/// IN  : 3||1^0013^1,2^FULL^1#D001^3950||1!D002^3949||1!D003^11730||1
/// OUT : 1为空，0不为空
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Task).GetLisArr("3||1^0013^1,2^FULL^1#D001^3950||1,3949||1!D002^3949||1!D003^11730||1/3||2^BloodChemical^23^FULL^0#TE^2737||1",.LisArr)
ClassMethod IsLisKPIBalnk(InLis)
{
	s mRtn=1
	Q:InLis="" 1
	f j=1:1:$l(InLis,"/") {
		s rec=$p(InLis,"/",j)
		s ITInfo=$p(rec,"#",1)
		s IKInfo=$p(rec,"#",2)
		s itemDR=$P(ITInfo,"^",1)
		s val=$P(ITInfo,"^",3)
		s rule=$P(ITInfo,"^",4)
		s section=$P(ITInfo,"^",5)
		i val'="," s mRtn=0
		Q:mRtn=0
		
	}
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-09-17
/// DESC: 判断患者是否包含指定的Lis
/// IN  : 
/// OUT : 1包含，0不包含
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Result).HasLis(70149,8271205,"3||1^0113^1,10^FULL^1#D6001^21488||1,21491||1,21485||1!D0134^21487||1,21484||1")
ClassMethod HasLis(RID, PAPMI = "", InLis = "")
{
	s mRtn=0
	s MDList=""
	d ##class(DHCDoc.GCPSW.BS.Task).GetLisArr(InLis,.MDList)
	/*f j=1:1:$l(InLis,"/") {
		s rec=$p(InLis,"/",j)
		s itemDR=$P(rec,"#",1)
		s SUB=$P(itemDR,"||",2)
		s itemOeori=$p(^CF.DOC.GCPSW.KPITypeD(+itemDR,"I",SUB),"^",7)
		continue:itemOeori=""
		s itemKPIStr=$P(rec,"#",2)
		continue:itemKPIStr=""
		//d ##class(DHCDoc.GCPSW.BS.Task).GetArr(itemOeori,itemDR,itemKPIStr,.MDList)
		s MDList(itemOeori)=""
		s itemKPIStr=$P(rec,"#",2)
		continue:itemKPIStr=""
		f k=1:1:$L(itemKPIStr,"!") {
			s cr=$p(itemKPIStr,"!",k)
			s code=$p(cr,"^",1)
			s val=$p(cr,"^",2)
			s rule=$p(cr,"^",3)
			s MDList(itemOeori,code)=val_"^"_rule
		}
	}*/
	;解析MDList
	/*
		MDList("3950||1")=""
		MDList("3950||1","Hemochrome")=2
		MDList("3950||1","Platelet")=3
		MDList("3950||1","WhiteCell")=1
		MDList("6901||1")=""
		MDList("6901||1","TE")=12
	*/
	//b ;001
	//各项之间取或关系
	s arcim=""
	f  s arcim=$o(MDList(arcim)) q:(arcim="")||(mRtn=1)  d
	.s code=""
	.s inFlag=##class(DHCDoc.GCPSW.COM.Func).HasLis(RID,PAPMI,arcim)
	.Q:inFlag'=1
	.Q:$o(MDList(arcim,""))=""
	.s itemFlag=##class(DHCDoc.GCPSW.COM.Func).HasLisItemNew(RID,PAPMI,arcim,.MDList)
	.i itemFlag=1 s mRtn=1
	/*
	s arcim=""
	f  s arcim=$o(MDList(arcim)) q:(arcim="")||(mRtn=1)  d
	.s code=""
	.s inFlag=##class(DHCDoc.GCPSW.COM.Func).HasLis(RID,PAPMI,arcim)
	.Q:inFlag'=1
	.i $o(MDList(arcim,""))="" s mRtn=1
	.q:mRtn=1
	.s itemFlag=##class(DHCDoc.GCPSW.COM.Func).HasLisItem(RID,PAPMI,arcim,.MDList)
	.i itemFlag=1 s mRtn=1
	*/
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-09-17
/// DESC: 根据病人ID,判断患者是否包含指定的诊断
/// IN  : 
/// OUT : 1包含，0不包含
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Result).HasDiagnosis(8369030,3)
ClassMethod HasDiagnosis(PAPMI = "", InDiag = "")
{
	s mRtn=0
	
	s AdmType=""
	f  s AdmType=$O(^PAPERdr(PAPMI,"ADM",AdmType)) Quit:(AdmType="")||(mRtn=1)  Do
	.s PAAdm=""
	.f  s PAAdm=$O(^PAPERdr(PAPMI,"ADM",AdmType,PAAdm)) Quit:(PAAdm="")||(mRtn=1)  Do
	..s mradm=$P(^PAADM(PAAdm),"^",61)
	..q:mradm=""
	..s id=0
	..f  s id=$o(^MR(mradm,"DIA",id)) q:(id="")||(mRtn=1)  d
	...s DiagID=$P($g(^MR(mradm,"DIA",id)),"^",1)
	...;s DiagDesc=""
	...;i DiagID'="" s DiagDesc=$p($g(^MRC("ID",DiagID)),"^",2)
	...i $g(DiagID)="" s DiagID=$g(^MR(mradm,"DIA",id,"DES",1))
	...q:DiagID=""
	...;w DiagID,!
	...s tempFlag=##class(DHCDoc.GCPSW.COM.Func).InArray(InDiag,DiagID,"-")
	...i tempFlag=1 s mRtn=1
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-09-07
/// DESC: 保存
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Result).SyncData()
ClassMethod SyncDataOld(mList)
{
	s mRtn=1
	q:mList="" mRtn
	f i=1:1:$L(mList,"!") {
		s rec=$P(mList,"!",i)
		s id=$p(rec,"^",1)
		s prj=$p(rec,"^",2)
		s PatientID=$p(rec,"^",3)
		s AdmDep=$p(rec,"^",4)	
		s AdmDoc=$p(rec,"^",5)	
		s AddDate=$p(rec,"^",6)	
		s AddTime=$p(rec,"^",7)	
		s User=$p(rec,"^",8)	
		s Del=$p(rec,"^",9)	
		q:mRtn'=1
		continue:$d(^BS.DOC.GCPSW.ResultI("PrjPat",prj,PatientID))
		i '$d(^BS.DOC.GCPSW.ResultI("PrjPat",prj,PatientID)) {
			s a=##class(User.GCPSWResult).%New()
			d a.RAddUserSetObjectId(User)
			d a.RPatientIDSetObjectId(PatientID)
			d a.RPrjSetObjectId(prj)
			d a.RAdmDepSetObjectId(AdmDep)
			d a.RAdmDocSetObjectId(AdmDoc)
		} else {
			//s a=##class(User.GCPSWResult).%OpenId(id)
		}
		s a.RDel=Del
		s a.RAddDate=AddDate
		s a.RAddTime=AddTime
		s sc=a.%Save()
		If $$$ISERR(sc) {
			//d $system.OBJ.DisplayError(sc) 
			s mRtn=-101
		} else {
			s mRtn=1	//a.%Id()
		}
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-09-24
/// DESC: 同步数据
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Result).SyncData()
ClassMethod SyncData(mList)
{
	//s LID=##class(DHCDoc.GCPSW.BS.TaskLog).Save("","","WS")
	s mRtn=1
	q:mList="" mRtn
	f i=1:1:$L(mList,"!") {
		s rec=$P(mList,"!",i)
		s node=$p(rec,"@",1)
		s val=$p(rec,"@",2)
		s tableName=$p(rec,"@",3)
		i tableName="TaskLog" {
			s ^BS.DOC.GCPSW.TaskLogD(node)=val
		} else {
			i node'["^" s ^BS.DOC.GCPSW.ResultD(node)=val
			e  d
			.s RID=$P(node,"^",1)
			.s FL=$P(node,"^",2)
			.s SUB=$P(node,"^",3)
			.s ^BS.DOC.GCPSW.ResultD(RID,FL,SUB)=val
		}
		
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-09-24
/// DESC: 同步索引
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Result).SyncData()
ClassMethod SyncIndex(mList)
{
	s mRtn=1
	q:mList="" mRtn
	f i=1:1:$L(mList,"!") {
		s rec=$P(mList,"!",i)
		i rec["TaskLog" {
			s node=$p(rec,"^",1)
			s node=$p(node,"-",2)
			i node="EndDate" {
				s EndDate=$p(rec,"^",2)	
				s ID=$p(rec,"^",3)	
				S ^BS.DOC.GCPSW.TaskLogI("EndDate",EndDate,ID)=""
			}
			i node="StartDate" {
				s EndDate=$p(rec,"^",2)	
				s ID=$p(rec,"^",3)	
				S ^BS.DOC.GCPSW.TaskLogI("StartDate",EndDate,ID)=""
			}
			i node="Type" {
				s EndDate=$p(rec,"^",2)	
				s ID=$p(rec,"^",3)	
				S ^BS.DOC.GCPSW.TaskLogI("Type",EndDate,ID)=""
			}
			i node="Prj" {
				s EndDate=$p(rec,"^",2)	
				s ID=$p(rec,"^",3)	
				S ^BS.DOC.GCPSW.TaskLogI("Prj",EndDate,ID)=""
			}
			i node="EndDatePrj" {
				s EndDate=$p(rec,"^",2)	
				s prj=$p(rec,"^",3)	
				s ID=$p(rec,"^",4)	
				S ^BS.DOC.GCPSW.TaskLogI("EndDatePrj",EndDate,prj,ID)=""
			}
			i node="StartDatePrj" {
				s EndDate=$p(rec,"^",2)	
				s prj=$p(rec,"^",3)	
				s ID=$p(rec,"^",4)	
				S ^BS.DOC.GCPSW.TaskLogI("StartDatePrj",EndDate,prj,ID)=""
			}
			
		} else {
			i rec["PrjPat" {
				s prj=$p(rec,"^",2)	
				s patientID=$p(rec,"^",3)	
				s RID=$p(rec,"^",4)	
				S ^BS.DOC.GCPSW.ResultI("PrjPat",prj,patientID,RID)=""
			}
			i rec["RPrj" {
				s prj=$p(rec,"^",2)		
				s RID=$p(rec,"^",3)	
				S ^BS.DOC.GCPSW.ResultI("RPrj",prj,RID)=""
			}
			i rec["AddDate" {
				s RID=$p(rec,"^",3)	
				s addDate=$p(rec,"^",4)	
				s sub=$p(rec,"^",5)	
				S ^BS.DOC.GCPSW.ResultI("ResultAdm","AddDate",RID,addDate,sub)=""
			}
			i rec["Adm" {
				s RID=$p(rec,"^",3)	
				s adm=$p(rec,"^",4)	
				s sub=$p(rec,"^",5)	
				S ^BS.DOC.GCPSW.ResultI("ResultAdm","Adm",RID,adm,sub)=""
			}
			i rec["Arcim" {
				i rec["ArcimCode" {
					s RID=$p(rec,"^",3)	
					s arcim=$p(rec,"^",4)	
					s code=$p(rec,"^",5)	//bug,之前写错4
					s sub=$p(rec,"^",6)	
					S ^BS.DOC.GCPSW.ResultI("ResultLis","ArcimCode",RID,arcim,code,sub)=""
				} else {
					s RID=$p(rec,"^",3)	
					s arcim=$p(rec,"^",4)	
					s sub=$p(rec,"^",5)	
					S ^BS.DOC.GCPSW.ResultI("ResultAdm","Arcim",RID,arcim,sub)=""
				}
			}
			i rec["Oeori" {
				s RID=$p(rec,"^",3)	
				s oeori=$p(rec,"^",4)	
				s sub=$p(rec,"^",5)	
				S ^BS.DOC.GCPSW.ResultI("ResultAdm","Oeori",RID,oeori,sub)=""
			}
			i (rec["ResultLis")&&(rec["Code") {
				s RID=$p(rec,"^",3)	
				s code=$p(rec,"^",4)	
				s sub=$p(rec,"^",5)	
				S ^BS.DOC.GCPSW.ResultI("ResultLis","Code",RID,code,sub)=""
			}
		}
		
	}
	
	Q mRtn
}

}
