/// 名称: DHCMed.Base.OROper
/// 描述: 手术表（手术麻醉系统）的业务封装，定义常用属性和方法
/// 编写者：zf
/// 编写日期: 2010-04-10
/// 说明：手术排班表：DHC_AN_OPArrange
///       手术麻醉表：OR_Anaesthesia
///       手术表：OR_Anaest_Operation
///       手术字典表：ORC_Operation
///       手术助理表：OR_An_Oper_Assistant
///       麻醉方式表：ORC_AnaestMethod
///       取手术信息有三部分：手术医嘱、手术申请单、手术麻醉系统
///       三部分取值封装不同的业务类
Class DHCMed.Base.OROper Extends (%Persistent, DHCMed.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 手术表Id  OP_Anaest_Operation.ANAOP_RowId
Property OPRowid As %String(TRUNCATE = 1);

/// 手术字典指针  OP_Anaest_Operation.ANAOP_Type_DR  指向ORC_Operation
Property OPOperDr As %String(TRUNCATE = 1);

/// 手术代码  ORC_Operation.OPER_Code
Property OPOperCode As %String(TRUNCATE = 1);

/// 手术名称  ORC_Operation.OPER_Desc
Property OPOperDesc As %String(TRUNCATE = 1);

/// 手术主编码  ORC_Operation.OPER_ICD9Map
Property OPOperICD As %String(TRUNCATE = 1);

/// 手术副编码  ORC_Operation.OPER_ICD10Map
Property OPOperICD1 As %String(TRUNCATE = 1);

/// 手术医生  OR_Anaest_Operation.ANAOP_Surgeon_DR  指向 CT_CareProv	
Property OPDocDr As %Integer;

/// 医生工号  CT_CareProv.CTPCP_Code
Property OPDocCode As %String(TRUNCATE = 1);

/// 医生姓名  CT_CareProv.CTPCP_Desc
Property OPDocDesc As %String(TRUNCATE = 1);

/// 一助  OR_An_Oper_Assistant.OPAS_Assist_DR  指向 CT_CareProv
Property OPAss1Dr As %Integer;

/// 一助工号  CT_CareProv.CTPCP_Code
Property OPAss1Code As %String(TRUNCATE = 1);

/// 一助姓名  CT_CareProv.CTPCP_Desc
Property OPAss1Desc As %String(TRUNCATE = 1);

/// 二助  OR_An_Oper_Assistant.OPAS_Assist_DR  指向 CT_CareProv
Property OPAss2Dr As %Integer;

/// 二助工号  CT_CareProv.CTPCP_Code
Property OPAss2Code As %String(TRUNCATE = 1);

/// 二助姓名  CT_CareProv.CTPCP_Desc
Property OPAss2Desc As %String(TRUNCATE = 1);

/// 手术护士  OR_Anaest_Operation.ANAOP_Circul_Nurse_DR  指向 CT_CareProv
Property OPNurseDr As %Integer;

/// 手术护士工号  CT_CareProv.CTPCP_Code
Property OPNurseCode As %String(TRUNCATE = 1);

/// 手术护士姓名  CT_CareProv.CTPCP_Desc
Property OPNurseDesc As %String(TRUNCATE = 1);

/// 手术麻醉表Id  OR_Anaesthesia.ANA_Rowid
Property AnaRowid As %String(TRUNCATE = 1);

/// 麻醉方式  OR_Anaesthesia.ANA_Method  指向ORC_AnaestMethod
Property AnaMethodDr As %String(TRUNCATE = 1);

/// 麻醉方式代码  ORC_AnaestMethod.ANMET_Code
Property AnaMethodCode As %String(TRUNCATE = 1);

/// 麻醉方式名称  ORC_AnaestMethod.ANMET_Desc
Property AnaMethodDesc As %String(TRUNCATE = 1);

/// 麻醉医师  OR_Anaesthesia.ANA_Anaesthetist_Dr  指向 CT_CareProv
Property AnaDocDr As %Integer;

/// 麻醉医师工号  CT_CareProv.CTPCP_Code
Property AnaDocCode As %String(TRUNCATE = 1);

/// 麻醉医师姓名  CT_CareProv.CTPCP_Desc
Property AnaDocDesc As %String(TRUNCATE = 1);

/// 手术排班表Id  DHC_AN_OPArrange.OPA_Rowid
Property OPARowid As %String(TRUNCATE = 1);

/// 手术状态  DHC_AN_OPArrange.OPA_Status
Property OPAStatus As %String(TRUNCATE = 1);

/// 手术开始日期  DHC_AN_OPArrange.OPA_StartDate
Property OPAStartDate As %Library.Date;

/// 手术开始时间  DHC_AN_OPArrange.OPA_StartTime
Property OPAStartTime As %Library.Time;

/// 手术结束日期  DHC_AN_OPArrange.OPA_EndDate
Property OPAEndDate As %Library.Date;

/// 手术结束时间  DHC_AN_OPArrange.OPA_EndTime
Property OPAEndTime As %Library.Time;

/// 就诊号  DHC_AN_OPArrange.OPAAdmdr
Property OPAPaadm As %String(TRUNCATE = 1);

/// Creator：     zf
/// CreatDate：   2010-04-10
/// Description:  将对象格式化为字符串
/// Table：       
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
///               1:Rowid 2:Code 3:Desc 3:Type 5:HospitalDr 6:DepGroupDr
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
	}
	set return=..OPRowid
	set return=return_separete_..OPOperDr_separete_..OPOperCode_separete_..OPOperDesc_separete_..OPOperICD_separete_..OPOperICD1
	set return=return_separete_..OPDocDr_separete_..OPDocCode_separete_..OPDocDesc
	set return=return_separete_..OPAss1Dr_separete_..OPAss1Code_separete_..OPAss1Desc
	set return=return_separete_..OPAss2Dr_separete_..OPAss2Code_separete_..OPAss2Desc
	set return=return_separete_..OPNurseDr_separete_..OPNurseCode_separete_..OPNurseDesc
	
	set return=return_separete_..AnaRowid
	set return=return_separete_..AnaMethodDr_separete_..AnaMethodCode_separete_..AnaMethodDesc
	set return=return_separete_..AnaDocDr_separete_..AnaDocCode_separete_..AnaDocDesc
	
	set return=return_separete_..OPARowid
	set return=return_separete_..OPAStatus
	set return=return_separete_..OPAStartDate_separete_..OPAStartTime
	set return=return_separete_..OPAEndDate_separete_..OPAEndTime
	set return=return_separete_..OPAPaadm
	quit return
}

/// Creator：     zf
/// CreatDate：   2010-04-10
/// Description:  根据DHC_AN_OPArrange.OPA_Rowid,OP_Anaest_Operation.ANAOP_RowId取手术麻醉信息
/// Table：       DHC_AN_OPArrange,OR_Anaesthesia,OR_Anaest_Operation
/// Input：       OPARowid: DHC_AN_OPArrange.OPA_RowId
///               OPRowid: OP_Anaest_Operation.ANAOP_RowId
/// Return：      返回obj
/// Others：      手术排班表没有以手术麻醉表ID字段建的索引
/// w ##class(DHCMed.Base.OROper).GetObjById(1,"1||1||1")
ClassMethod GetObjById(OPARowid As %String, OPRowid As %String) As DHCMed.Base.OROper
{
	new (OPARowid,OPRowid)
	set return=""
	quit:(OPARowid="")&&(OPRowid="") return
	
	set AnaRowid=""
	set OPAInfo="",OPInfo="",AnaInfo=""
	if (OPARowid'=""){
		set OPAInfo=$g(^DHCANOPArrange(+OPARowid))
		set AnaRowid=$p(OPAInfo,"^",2)
	}
	if (OPRowid'=""){
		set Paadm=$p(OPRowid,"||",1)
		set AnaChild=$p(OPRowid,"||",2)
		set OPChild=$p(OPRowid,"||",3)
		set OPInfo=$g(^OR(+Paadm,"ANA",+AnaChild,"OP",+OPChild))
		set AnaRowid=Paadm_"||"_AnaChild
	}
	if (AnaRowid'=""){
		set Paadm=$p(AnaRowid,"||",1)
		set AnaChild=$p(AnaRowid,"||",2)
		set AnaInfo=$g(^OR(+Paadm,"ANA",+AnaChild))
	}
	q:(OPARowid="")&&(OPRowid="")&&(AnaRowid="") return
	
	set obj=##Class(DHCMed.Base.OROper).%New()
	if (OPAInfo'=""){
		set obj.OPARowid=OPARowid
		set obj.OPAStatus=$p(OPAInfo,"^",27)
		set OPAStartDate=$p(OPAInfo,"^",14)
		set obj.OPAStartDate=$s(OPAStartDate="":"",1:$zd(+OPAStartDate,3))
		set OPAStartTime=$p(OPAInfo,"^",15)
		set obj.OPAStartTime=$s(OPAStartTime="":"",1:$zt(+OPAStartTime,2))
		set OPAEndDate=$p(OPAInfo,"^",16)
		set obj.OPAEndDate=$s(OPAEndDate="":"",1:$zd(+OPAEndDate,3))
		set OPAEndTime=$p(OPAInfo,"^",17)
		set obj.OPAEndTime=$s(OPAEndTime="":"",1:$zt(+OPAEndTime,2))
		set obj.OPAPaadm=$p(OPAInfo,"^",1)
	}
	if (AnaInfo'=""){
		set obj.AnaRowid=AnaRowid
		set AnaMethodDr=$p(AnaInfo,"^",5)
		set obj.AnaMethodDr=AnaMethodDr
		set obj.AnaMethodCode=$s(AnaMethodDr="":"",1:$p($g(^ORC("ANMET",+AnaMethodDr)),"^",1))
		set obj.AnaMethodDesc=$s(AnaMethodDr="":"",1:$p($g(^ORC("ANMET",+AnaMethodDr)),"^",2))
		set AnaDocDr=$p(AnaInfo,"^",6)
		set obj.AnaDocDr=AnaDocDr
		set obj.AnaDocCode=$s(AnaDocDr="":"",1:$p($g(^CTPCP(+AnaDocDr,1)),"^",1))
		set obj.AnaDocDesc=$s(AnaDocDr="":"",1:$p($g(^CTPCP(+AnaDocDr,1)),"^",2))
		set obj.OPAPaadm=Paadm
	}
	if (OPInfo'=""){
		set obj.OPRowid=OPRowid
		set OPOperDr=$p(OPInfo,"^",6)
		set obj.OPOperDr=OPOperDr
		set obj.OPOperCode=$s(OPOperDr="":"",1:$p($g(^ORC("OPER",+OPOperDr)),"^",1))
		set obj.OPOperDesc=$s(OPOperDr="":"",1:$p($g(^ORC("OPER",+OPOperDr)),"^",2))
		set obj.OPOperICD=$s(OPOperDr="":"",1:$p($g(^ORC("OPER",+OPOperDr)),"^",21))
		set obj.OPOperICD1=$s(OPOperDr="":"",1:$p($g(^ORC("OPER",+OPOperDr)),"^",20))
		set OPDocDr=$p(OPInfo,"^",8)
		set obj.OPDocDr=OPDocDr
		set obj.OPDocCode=$s(OPDocDr="":"",1:$p($g(^CTPCP(+OPDocDr,1)),"^",1))
		set obj.OPDocDesc=$s(OPDocDr="":"",1:$p($g(^CTPCP(+OPDocDr,1)),"^",2))
		set OPAss1Dr="",OPAss2Dr=""
		if $d(^OR(+Paadm,"ANA",+AnaChild,"OP",+OPChild,"ASS")){
			set OPASChild1=$o(^OR(+Paadm,"ANA",+AnaChild,"OP",+OPChild,"ASS",""))
			set:OPASChild1'="" OPAss1Dr=$p($g(^OR(+Paadm,"ANA",+AnaChild,"OP",+OPChild,"ASS",OPASChild1)),"^",1)
			set OPASChild2=$o(^OR(+Paadm,"ANA",+AnaChild,"OP",+OPChild,"ASS",OPASChild1))
			set:OPASChild2'="" OPAss2Dr=$p($g(^OR(+Paadm,"ANA",+AnaChild,"OP",+OPChild,"ASS",OPASChild2)),"^",1)
		}
		set obj.OPAss1Dr=OPAss1Dr
		set obj.OPAss1Code=$s(OPAss1Dr="":"",1:$p($g(^CTPCP(+OPAss1Dr,1)),"^",1))
		set obj.OPAss1Desc=$s(OPAss1Dr="":"",1:$p($g(^CTPCP(+OPAss1Dr,1)),"^",2))
		set obj.OPAss2Dr=OPAss2Dr
		set obj.OPAss2Code=$s(OPAss2Dr="":"",1:$p($g(^CTPCP(+OPAss2Dr,1)),"^",1))
		set obj.OPAss2Desc=$s(OPAss2Dr="":"",1:$p($g(^CTPCP(+OPAss2Dr,1)),"^",2))
		set OPNurseDr=$p(OPInfo,"^",7)
		set obj.OPNurseDr=OPNurseDr
		set obj.OPNurseCode=$s(OPNurseDr="":"",1:$p($g(^CTPCP(+OPNurseDr,1)),"^",1))
		set obj.OPNurseDesc=$s(OPNurseDr="":"",1:$p($g(^CTPCP(+OPNurseDr,1)),"^",2))
		set obj.OPAPaadm=Paadm
	}
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zf
/// CreatDate：   2010-04-10
/// Description:  根据DHC_AN_OPArrange.OPA_Rowid,OP_Anaest_Operation.ANAOP_RowId取手术麻醉信息
/// Table：       DHC_AN_OPArrange,OR_Anaesthesia,OR_Anaest_Operation
/// Input：       OPARowid: DHC_AN_OPArrange.OPA_RowId
///               OPRowid: OP_Anaest_Operation.ANAOP_RowId
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.Base.OROper).GetStringById(1,"1||1||1","$")
ClassMethod GetStringById(OPARowid As %String, OPRowid As %String, separete As %String) As %String
{
	new (OPARowid,OPRowid,separete)
	set return=""
	set obj=..GetObjById(OPARowid,OPRowid)
	if $IsObject(obj){
		set return=obj.ToString($g(separete))
	}
	quit return
}

/// Creator：     zf
/// CreatDate：   2010-04-10
/// Description:  根据就诊号查询手术麻醉信息列表
/// Table：       DHC_AN_OPArrange,OR_Anaesthesia,OR_Anaest_Operation
/// Input：       Paadm: 就诊号
/// Return：      ResultSet
/// Others：      就诊号-->手术排班记录-->麻醉表(手术排班表字段)-->手术表(麻醉表子表)
/// d ##class(%ResultSet).RunQuery("DHCMed.Base.OROper","QueryByPaadm",EpisodeID)
Query QueryByPaadm(argEpisodeID As %String) As %Query(ROWSPEC = "OPRowid:%String,OPOperDr:%String,OPOperCode:%String,OPOperDesc:%String,OPOperICD:%String,OPOperICD1:%String,OPDocDr:%String,OPDocCode:%String,OPDocDesc:%String,OPAss1Dr:%String,OPAss1Code:%String,OPAss1Desc:%String,OPAss2Dr:%String,OPAss2Code:%String,OPAss2Desc:%String,OPNurseDr:%String,OPNurseCode:%String,OPNurseDesc:%String,AnaRowid:%String,AnaMethodDr:%String,AnaMethodCode:%String,AnaMethodDesc:%String,AnaDocDr:%String,AnaDocCode:%String,AnaDocDesc:%String,OPARowid:%String,OPAStatus:%String,OPAStartDate:%String,OPAStartTime:%String,OPAEndDate:%String,OPAEndTime:%String,OPAPaadm:%String")
{
}

ClassMethod QueryByPaadmExecute(ByRef qHandle As %Binary, argEpisodeID As %String) As %Status
{
	
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//手术排班表DHC_AN_OPArrange
	//^DHCANOPArrange(0,"Adm",{OPA_Adm_dr},{OPA_RowId})
	//麻醉表OR_Anaesthesia
	//^OR({PA_Adm.PAADM_RowID},"ANA",{ANA_Childsub})
	//手术表OR_Anaest_Operation
	//^OR({PA_Adm.PAADM_RowID},"ANA",{Childsub},"OP",{ANAOP_Childsub})
	//取CTLOC_Desc=tmpALias的数据
	quit:argEpisodeID="" $$$OK
	quit:'$d(^DHCANOPArrange(0,"Adm",argEpisodeID)) $$$OK
	set OPARowid=$o(^DHCANOPArrange(0,"Adm",argEpisodeID,0))
	while (OPARowid'=""){
		set AnaRowid=$p($g(^DHCANOPArrange(+OPARowid)),"^",2)
		set Paadm=$p(AnaRowid,"||",1)
		set AnaChild=$p(AnaRowid,"||",2)
		set OPChild=$o(^OR(Paadm,"ANA",AnaChild,"OP",0))
		while (OPChild'=""){
			set OPRowid=Paadm_"||"_AnaChild_"||"_OPChild
			set retStr=..GetStringById(OPARowid,OPRowid,$c(1))
			set Data=##Class(DHCMed.Base.CommFunSrv).GetListFromString(retStr,$c(1))
			set ^CacheTemp(repid,ind)=Data
			set ind=ind+1
			set OPChild=$o(^OR(Paadm,"ANA",AnaChild,"OP",OPChild))
		}
		set OPARowid=$o(^DHCANOPArrange(0,"Adm",argEpisodeID,OPARowid))
	}
	
	Quit $$$OK
}

ClassMethod QueryByPaadmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByPaadmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryByPaadmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByPaadmExecute ]
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

}
