/// Desc:用于上线治疗站的数据快速生成
/// Creator：nk
/// CreateDate:20201030
Class DHCDoc.DHCDocCure.OnlineSupport Extends %RegisteredObject
{

/// Desc:批量生成治疗申请记录，并当做直接执行处理，同时生成治疗记录
/// Input:data: OrderID
/// Debug:w ##class(DHCDoc.DHCDocCure.OnlineSupport).CreateCureDataBatch("D:\\Doctor.txt")
ClassMethod CreateCureDataBatch(FilePath)
{
	Set file=##class(%File).%New(FilePath)
	set ExistsFlag=##class(%File).Exists(FilePath)
	if ExistsFlag'=1 d file.Open("N")
	d file.Close()
	Q:ExistsFlag'=1 "文件不存在"
	
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename=FilePath
	w !,"数据生成中..."
	set total=0
	set success=0
	set error=0
	set line=0
	While 'stream.AtEnd {
		set total=total+1
		Set data=stream.ReadLine()
		Set err=..CreateCureData(data)
		if err'=0{
			s ^TMP("DHCDoc.DHCDocCure.Common","CreateCureDataBatch",total)=data_",错误:"_err
			s error=error+1	
		}else{
			s success=success+1	
		}
	}
	Q "一共"_total_"条数据，成功:"_success_"条，失败:"_error_"条"
}

ClassMethod CreateCureData(data)
{
	s OrderRowID=$p(data,"^",1)
	s EpisodeID=$p(^OEORD(+OrderRowID),"^",1)
	Q:EpisodeID=""
	s OrderPar=+OrderRowID
	s OrderChild=$p(OrderRowID,"||",2)
	s UserID=$p(^OEORD(+OrderPar,"I",OrderChild,7),"^",1)
	s DCARowID=$o(^DHCDocCure(0,"OEORI",OrderRowID,""))
	Q:DCARowID'="" "治疗申请已生成"
	s err=0
	Ts
	s ret=##class(DHCDoc.DHCDocCure.Apply).CreateCureApply(EpisodeID,OrderRowID,UserID,"Y")
	if +ret=0{
		s DCARowID=$p(ret,"^",2)
		if DCARowID'=""{
			s OrdExecIDStr=""
			s OrderExecChild=0
			for {
				s OrderExecChild=$o(^OEORD(OrderPar,"I",OrderChild,"X",OrderExecChild)) Q:OrderExecChild=""
				s OEORERowID=OrderRowID_"||"_OrderExecChild
				s execdata=$g(^OEORD(OrderPar,"I",OrderChild,"X",OrderExecChild))
				s OEOREStatus=$p(execdata,"^",16)
				s OEOREStatusCode=""
				s:OEOREStatus'="" OEOREStatusCode=$p(^OEC("STAT",OEOREStatus),"^",1),OEOREStatus=$p(^OEC("STAT",OEOREStatus),"^",2)
				continue:(OEOREStatusCode'="F")
				s DCRCureDate=$p(execdata,"^",19)
				s DCRCureTime=$p(execdata,"^",20)
				s EUserID=$p(execdata,"^",15)
				s err=$$InsertRecord()
				if err'=0{
					Tro
					s err="Err Record:"_err	
				}
			}
		}else{
			Tro
			s err="Null DCARowID"	
		}
	}else{
		Tro
		s err="Err Apply:"_+ret
	}
	if err=0{
		TC	
	}
	q err
InsertRecord()
	set content=##class(DHCDoc.DHCDocCure.Record).GetCureRecordByDCA("","",OEORERowID)
	s DCRTitle=$p(content,"^",3)
	s DCRContent=$p(content,"^",4)	
	s PLIST(0)=DCARowID
	s PLIST(3)=""
	s PLIST(4)=OEORERowID
	s PLIST(5)=DCRTitle
	s PLIST(6)=DCRContent
	s PLIST(7)=EUserID
	s PLIST(8)=+$h
	s PLIST(9)=$p($h,",",2)
	s PLIST(13)="Y"
	s PLIST(15)=DCRCureDate
	s PLIST(16)=DCRCureTime
 	&sql(insert into SQLUser.DHC_DocCureRecode values :PLIST())
	Q SQLCODE
}

/// Creator:nk
/// Date:	20201030
/// Desc:	批量激活所有的治疗医嘱
///         手动申请、门诊直接执行、住院直接执行 默认空
///         服务组 ？？？ 需确认
/// Table:	[DHC_DocCureItemSet]
/// Input:  Hospital 院区 
///         ServiceGroupDR 默认的服务组 
///         ItemCatID 不为空则只设置该子类医嘱项
/// Output:
/// Debug:	w ##class(DHCDoc.DHCDocCure.OnlineSupport).InsertAllCureItem()
/// Others:	不要二次使用
ClassMethod InsertAllCureItem(Hospital As %String, ServiceGroupDR As %String, ItemCatID As %String = "") As %String
{
	q "开发程序，勿轻易使用"
	if ServiceGroupDR=""{
		Q "请确认需设置的服务组ID"	
	}
	Set rset=##class(%ResultSet).%New("DHCDoc.DHCDocCure.Config:GetCureItemTree")
	do rset.Execute("","","","",Hospital,"","Y","")
	Set columns = rset.GetColumnCount()
	set row=0
	While (rset.Next()) {
		set id=rset.GetData(1)
		set pId=rset.GetData(2)
		set name=rset.GetData(3)
		set eleid=rset.GetData(4)
		set Type=$p(eleid,"^",1)
		continue:Type'="ARCIM"
		set ArcimID=$p(eleid,"^",3)
		continue:ArcimID=""
		
		set ItemCatDr=$p(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1),"^",10)
		continue:(ItemCatID'="")&&(ItemCatID'=ItemCatDr)
		if Type="ARCIM"{
			s (ShortName,AutoAppFlag,Effect,Indication,Avoid,RelateAssTemp)=""
			s ManualApply="" ;手动申请
			s ApplyExec="" ;门诊直接执行
			s IPApplyExec="" ;住院直接执行
			s ActiveFlag="Y"
			k PLIST
			s PLIST(2)=ArcimID
			s PLIST(3)=ShortName
			s PLIST(4)=ServiceGroupDR
			s PLIST(5)=AutoAppFlag
			s PLIST(6)=Effect
			s PLIST(7)=Indication
			s PLIST(8)=Avoid
			s PLIST(9)=ManualApply
			s PLIST(10)=ApplyExec
			s PLIST(11)=ActiveFlag
			s PLIST(12)=IPApplyExec
			s PLIST(13)=Hospital
			s PLIST(14)=RelateAssTemp
			&sql(
				Insert into SQLUSER.DHC_DocCureItemSet values :PLIST()
			)
		}
	}
	
	q "OK"
}

/// CTOR:   nk
/// DATE:   2021-04-08
/// DESC:   治疗医嘱项批量导入Excel
/// INPUT:  医嘱项ID 		ARC_ItmMast表 ARCIM_RowId
/// 		医嘱项名称 		ARC_ItmMast表 ARCIM_Desc
/// 		服务组名称 		DHC_DocCureRBCServiceGroupSet表 DDCSGS_Desc
/// 		是否手动申请    Y/N
/// 		门诊直接执行    Y/N
/// 		住院直接执行    Y/N
/// 		是否激活		Y/N
/// 		院区ID   	 	CT_Hospital
/// OUTPUT: SQLCODE
/// DEBUG:  w ##class(DHCDoc.DHCDocCure.OnlineSupport).ImportCureItemExcel("康复门诊^1708^王康^3^上午^心理^102",2)
ClassMethod ImportCureItemExcel(excelStr As %String, ExpStr As %String = "") As %String
{
	s ImportHospName=""
	s ImportHospId=$p(ExpStr,"^",1) //导入院区
	s:ImportHospId'="" ImportHospName=$p(^CT("HOSP",ImportHospId),"^",2)
	s Hospital=$p(excelStr,"^",8)
	if Hospital="" s Hospital=ImportHospId
	s $p(excelStr,"^",8)=Hospital
	
	s InPara=..CheckBeforeImport(excelStr,ExpStr)
    q:(+InPara<0) InPara
	s ret=##class(DHCDoc.DHCDocCure.CureItemSet).SaveCureItemSet(InPara,Hospital)
    
    q ret
}

ClassMethod CheckBeforeImport(value, ExpStr)
{
	s ARCIMRowId=$p(value,"^",1)
	s ARCIMDesc=$p(value,"^",2)
	s ServiceGroupDesc=$p(value,"^",3)
	s ManualApply=$zcvt($p(value,"^",4),"U")
	s ApplyExec=$zcvt($p(value,"^",5),"U")
	s IPApplyExec=$zcvt($p(value,"^",6),"U")
	s ActiveFlag=$zcvt($p(value,"^",7),"U")
	s Hospital=$p(value,"^",8)
	
	if (ARCIMRowId=""){
		Q "-1^医嘱项ID为空!"
	}
	if $l(ARCIMRowId,"||")'=2{
		Q "-1^医嘱项ID格式错误!"
	}
	if '$d(^ARCIM(+ARCIMRowId,$P(ARCIMRowId,"||",2))){
		Q "-1^医嘱项ID无效!"
	}
	s HospShowDataFlag=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",ARCIMRowId,Hospital)
	if HospShowDataFlag="N"{
		Q "-1^该医嘱项在对应院区不可用!"	
	}
	s ServiceGroupDr=0,FindServiceGroupDr=""
	for {
		s ServiceGroupDr=$o(^DHCDocCureRBCServiceGroupSet(ServiceGroupDr)) Q:(ServiceGroupDr="")||(FindServiceGroupDr'="")
		s tmpServiceGroupDesc=$p(^DHCDocCureRBCServiceGroupSet(ServiceGroupDr),"^",2)
		continue:(tmpServiceGroupDesc'=ServiceGroupDesc)
		continue:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHC_DocCureRBCServiceGroupSet",ServiceGroupDr,Hospital)="N"
		s FindServiceGroupDr=ServiceGroupDr
	}
	s ServiceGroupDr=FindServiceGroupDr
	if (ServiceGroupDr="") {
		Q "-1^无效的服务组:"_ServiceGroupDesc
	}
	if ManualApply'="Y"{
		s ManualApply="N"	
	}	
	if ApplyExec'="Y"{
		s ApplyExec="N"	
	}	
	if IPApplyExec'="Y"{
		s IPApplyExec="N"	
	}
	if ActiveFlag="" s ActiveFlag="Y"	
	if ActiveFlag'="Y"{
		s Active="N"	
	}	
	
	Set DDCISRowid=##class(DHCDoc.DHCDocCure.CureItemSet).GetDDCISIDByItem(ARCIMRowId,Hospital)
	Set ShortName=""
	Set AutoAppFlag=""
	Set Effect=""
	Set Indication=""
	Set Avoid=""
	set RelateAssTemp=""
	s OutStr=DDCISRowid_"^"_ARCIMRowId_"^"_ShortName_"^"_ServiceGroupDr_"^"_AutoAppFlag
	s OutStr=OutStr_"^"_Effect_"^"_Indication_"^"_Avoid_"^"_ManualApply_"^"_ApplyExec
	s OutStr=OutStr_"^"_ActiveFlag_"^"_IPApplyExec_"^"_RelateAssTemp
	;s OutStr=OutStr_"^"_Hospital
	Q OutStr
}

/// CTOR:   nk
/// DATE:   2021-04-08
/// DESC:   治疗医嘱项批量导入Excel
/// INPUT:  医嘱项ID 		ARC_ItmMast表 ARCIM_RowId
/// 		医嘱项名称 		ARC_ItmMast表 ARCIM_RowId
/// 		服务组名称 		DHC_DocCureRBCServiceGroupSet表 DDCSGS_Desc
/// 		是否手动申请    Y/N
/// 		门诊直接执行    Y/N
/// 		住院直接执行    Y/N
/// 		是否激活		Y/N
/// 		院区ID   	 	CT_Hospital
/// OUTPUT: SQLCODE
/// DEBUG:  w ##class(DHCDoc.DHCDocCure.OnlineSupport).ImportExcel("039^李丽^I^KSS1^A^1^1")
ClassMethod ImportTotalExcel(ByRef excelStrArr, ExpStr As %String = "") As %String
{
	s mRtn=0
	s loop=0
	Ts
	for{
		s loop=$o(excelStrArr(loop))
		q:loop=""
		s excelStr=excelStrArr(loop)
		s totalLen=$l(excelStr,"!")
		
		f tloop=1:1:totalLen {
			s cInput = $p(excelStr,"!",tloop)
			s rtn=..ImportCureItemExcel(cInput,ExpStr)
			i rtn'=0{
				s mRtn=$p(cInput,"^",1)_","_$p(cInput,"^",2)_","_rtn
			}
			q:rtn'=0 
		}
		q:mRtn'=0 
	}
	if mRtn=0{
		Tc
	}else{
		Tro	
	}
    q mRtn
}

/// CTOR:   nk
/// DATE:   2021-04-08
/// DESC:   治疗部位/穴位批量导入Excel
/// INPUT:  类型 		部位/穴位
/// 		描述 		
/// 		别名 		
/// 		是否默认    Y/N
/// 		激活    	Y/N
/// 		定位(仅类型为穴位)
/// 		主治(仅类型为穴位)
/// 			操作(仅类型为穴位)
/// 		可用院区ID  CT_Hospital
/// OUTPUT: SQLCODE
/// DEBUG:  w ##class(DHCDoc.DHCDocCure.OnlineSupport).ImportExcel("039^李丽^I^KSS1^A^1^1")
ClassMethod ImportCurePartExcel(ByRef excelStrArr, ExpStr As %String = "") As %String
{
	s mRtn=0
	s loop=0
	Ts
	for{
		s loop=$o(excelStrArr(loop))
		q:loop=""
		s excelStr=excelStrArr(loop)
		s totalLen=$l(excelStr,"!")
		
		f tloop=1:1:totalLen {
			s cInput = $p(excelStr,"!",tloop)
			s rtn=..ImportCurePart(cInput,ExpStr)
			i rtn'=0{
				s mRtn=rtn
			}
			q:rtn'=0 
		}
		q:mRtn'=0 
	}
	if mRtn=0{
		Tc
	}else{
		Tro	
	}
    q mRtn
}

/// CTOR:   nk
/// DATE:   2021-04-08
/// DESC:   治疗部位/穴位批量导入Excel
/// INPUT:  类型 		部位/穴位
/// 		描述 		
/// 		别名 		
/// 		是否默认    Y/N
/// 		激活    	Y/N
/// 		定位(仅类型为穴位)
/// 		主治(仅类型为穴位)
/// 			操作(仅类型为穴位)
/// 		可用院区ID  CT_Hospital
/// OUTPUT: SQLCODE
/// DEBUG:  w ##class(DHCDoc.DHCDocCure.OnlineSupport).ImportCurePart("康复门诊^1708^王康^3^上午^心理^102",2)
ClassMethod ImportCurePart(excelStr As %String, ExpStr As %String = "") As %String
{
	s ImportHospName=""
	s ImportHospId=$p(ExpStr,"^",1) //导入院区
	s:ImportHospId'="" ImportHospName=$p(^CT("HOSP",ImportHospId),"^",2)
	
	k JsonArr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(excelStr,.JsonArr)
	s DDCPSType=$g(JsonArr("类型(部位/穴位)"))
	s DDCPSCode=""
	s DDCPSDesc=$g(JsonArr("描述"))
	s DDCPSAlias=$g(JsonArr("别名"))
	s DDCPSDefaultFlag=$g(JsonArr("是否默认(Y/N)"))
	s DDCPSAvailFlag=$g(JsonArr("是否激活(Y/N)"))
	s CPSAcupPosition=$g(JsonArr("定位(仅穴位)"))
	s CPSAcupAttending=$g(JsonArr("主治(穴位)"))
	s CPSAcupOperation=$g(JsonArr("操作(穴位)"))
	s Hospital=$g(JsonArr("可用院区ID(CT_Hosptial多个以&分割)"))
	
	if Hospital="" s Hospital=ImportHospId
	
	s CheckPara=DDCPSType_"^"_DDCPSDesc_"^"_DDCPSAlias_"^"_DDCPSDefaultFlag_"^"_DDCPSAvailFlag
	s CheckPara=CheckPara_"^"_CPSAcupPosition_"^"_CPSAcupAttending_"^"_CPSAcupOperation_"^"_Hospital
	s mHospID=$p(Hospital,"&",1)
	s InPara=..CheckBeforeImportCurePart(CheckPara,ExpStr)
    q:(+InPara<0) InPara
	s ret=##class(DHCDoc.DHCDocCure.BodySet).SaveCurePartSet(InPara,mHospID)
    s DDCPSROWID=$p(ret,"^",2)
    s ret=$p(ret,"^",1)
    if ret=0{
	   	for kk=2:1:$l(Hospital,"&"){
			s mHospID=$p(Hospital,"&",kk)
			s mHospID=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("DHC_DocCure_PartSet",mHospID,+$H)
		 	d ##class(DHCDoc.Common.Hospital).SaveHOSP("DHC_DocCure_PartSet",DDCPSROWID,mHospID)
		}
		if $p(InPara,"^",2)="A"{
			s AcupArr("AcupPosition")=CPSAcupPosition
			s AcupArr("AcupAttending")=CPSAcupAttending
			s AcupArr("AcupOperation")=CPSAcupOperation
			s AcupJson=##Class(DHCDoc.Util.FromJSON).GetArrJson(.AcupArr)
			s ret=##class(DHCDoc.DHCDocCure.BodySet).AcupDetailSet(DDCPSROWID,AcupJson)
		}
	}
	if ret'=0{
		if ret=101 s rtn="描述已存在"
		else  s rtn=ret
		s ret=DDCPSType_"-"_DDCPSDesc_","_rtn
	}
    q ret
}

ClassMethod CheckBeforeImportCurePart(value, ExpStr)
{
	s DDCPSType=$p(value,"^",1)
	s DDCPSCode=""
	s DDCPSDesc=$p(value,"^",2)
	s DDCPSAlias=$p(value,"^",3)
	s DDCPSDefaultFlag=$zcvt($p(value,"^",4),"U")
	s DDCPSAvailFlag=$zcvt($p(value,"^",5),"U")
	s CPSAcupPosition=$p(value,"^",6)
	s CPSAcupAttending=$p(value,"^",7)
	s CPSAcupOperation=$p(value,"^",8)
	s HospId=$p(value,"^",9)
	
	if (DDCPSType=""){
		Q "-1^类型为空!"
	}else{
		if ((DDCPSType'="部位")&&(DDCPSType'="穴位")){	
			Q "-1^类型仅限部位或穴位!"
		}	
	}
	s DDCPSType=$case(DDCPSType,"部位":"BP","穴位":"A")
	if (DDCPSDesc=""){
		Q "-1^描述为空!"
	}
	if (HospId=""){
		Q "-1^可用院区为空!"
	}
	s DDCPSDefaultFlag=$case(DDCPSDefaultFlag,"Y":"Y",:"N")
	s DDCPSAvailFlag=$case(DDCPSAvailFlag,"Y":"Y",:"N")
	
	s DDCPSROWID=""
	s OutStr=DDCPSROWID_"^"_DDCPSType_"^"_DDCPSCode_"^"_DDCPSDesc_"^"_DDCPSDefaultFlag
	s OutStr=OutStr_"^"_DDCPSAvailFlag_"^"_DDCPSAlias
	Q OutStr
}

/// DATE: 2023-04-15
/// DESC: 治疗项目设置数据导入模板
/// Input  : 
/// OUT : ARC_ItmMast医嘱项ID	医嘱项名称	服务组名称	是否手动申请Y/N	门诊直接执行Y/N	住院直接执行Y/N	是否激活Y/N	CT_Hospital院区ID
/// EXEC: d ##Class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.OnlineSupport","QryItemSetTPL")
Query QryItemSetTPL() As %Query(ROWSPEC = "C1:%String:ARC_ItmMast医嘱项ID,C2:%String:医嘱项名称,C3:%String:服务组名称,C4:%String:是否手动申请Y/N,C5:%String:门诊直接执行Y/N,C6:%String:住院直接执行Y/N,C7:%String:是否激活Y/N,C8:%String:CT_Hospital院区ID")
{
}

ClassMethod QryItemSetTPLExecute(ByRef qHandle As %Binary) As %Status
{
 	s C1="2709||1",C2="组织胺激发试验",C3="皮肤治疗组",C4="Y"
 	s C5="Y",C6="Y",C7="Y",C8="2"		
	d OutputRow
 	s C1="4894||1",C2="水负荷试验",C3="康复治疗组",C4="N"
 	s C5="N",C6="N",C7="Y",C8="2"		
 	d OutputRow
	Quit $$$OK
OutputRow
	set Data=$lb(C1,C2,C3,C4,C5,C6,C7,C8)
	set qHandle($I(ind))=Data
	quit
}

ClassMethod QryItemSetTPLFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryItemSetTPLExecute ]
{
	s ind=$O(qHandle(""))
	if ind{
		s Row=qHandle(ind)
		k qHandle(ind)
	}else{
		s AtEnd=1
	}
	Quit $$$OK
}

/// DATE: 2023-04-15
/// DESC: 排程计划数据导入模板
/// Input  : 
/// OUT : 科室名称	医生工号	医生姓名	星期	时段名称	服务组名称	最大预约数	是否激活	是否分时段	分时段间隔分钟数	分时段保留号数
/// EXEC: d ##Class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.OnlineSupport","QryItemSetTPL")
Query QryResPlanTPL() As %Query(ROWSPEC = "C1:%String:科室名称,C2:%String:医生工号,C3:%String:医生姓名,C4:%String:星期,C5:%String:时段名称,C6:%String:服务组名称,C7:%String:最大预约数,C8:%String:是否激活,C9:%String:是否分时段,C10:%String:分时段间隔分钟数,C11:%String:分时段保留号数")
{
}

ClassMethod QryResPlanTPLExecute(ByRef qHandle As %Binary) As %Status
{
	;康复门诊	1708	王康	4	上午	康复治疗组	99	N	N		
	;康复门诊	1708	王康	5	下午	康复治疗组	99	Y	Y	30	

 	s C1="康复门诊",C2="1708",C3="王康",C4="4",C5="上午"
 	s C6="康复治疗组",C7="99",C8="N",C9="N",C10="N",C11=""	
	d OutputRow
 	s C1="康复门诊",C2="1708",C3="王康",C4="5",C5="下午"
 	s C6="康复治疗组",C7="99",C8="Y",C9="Y",C10="30",C11=""			
 	d OutputRow
	Quit $$$OK
OutputRow
	set Data=$lb(C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,,C11)
	set qHandle($I(ind))=Data
	quit
}

ClassMethod QryResPlanTPLFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryResPlanTPLExecute ]
{
	s ind=$O(qHandle(""))
	if ind{
		s Row=qHandle(ind)
		k qHandle(ind)
	}else{
		s AtEnd=1
	}
	Quit $$$OK
}

}
