Class DHCDoc.Interface.YiBaoJianGuan.LocalData Extends %RegisteredObject [ ProcedureBlock ]
{

/// 说明：如下参数是周口中心医院，其他各医院根据文档要求和医院实际情况进行设置
/// 
/// 医疗机构行政区划编码
Parameter MedinsAdmdvs = 411600;

/// 医疗服务机构类型  按照文档中提供的字典表 找出医院对应的数据
Parameter MedinsType = "A1";

/// 医疗机构等级(medins_lv) 按照文档中提供的字典表 找出医院对应的数据   
Parameter MedinsLv = 1;

/// 医疗服务机构标识(medins_id)     定点医疗机构ID
Parameter MedinsId = "H41160200010";

/// 医疗机构名称(medins_id)   
Parameter medinsname = "周口市中心医院";

/// syscode
Parameter syscode = "IMS";

/// 获取医师专业技术职务 DR_PRO_TECH_DUTY
ClassMethod GetDocTitle(DoctorID)
{
	/*
	1 医士
	2 医师/住院医师
	3 主治医师
	4 副主任医师
	5 主任医师
	6 无
	*/
	q:(DoctorID="") 6
	s DoctorTypeCode="",ExtDoctorTypeCode=""
	s DoctorTypeRowId=$P($G(^CTPCP(DoctorID,1)),"^",4)
	s DoctorTypeDesc=$P(^CT("CPT",DoctorTypeRowId),"^",2)
	s TransCareProvType=$P(^CT("CPT",DoctorTypeRowId),"^",4)
	if (TransCareProvType'="DOCTOR"){
		q 6
	}elseif (DoctorTypeDesc["副主任"){
		q 4
	}elseif (DoctorTypeDesc["主任"){
		q 5
	}elseif (DoctorTypeDesc["主治"){
		q 4
	}elseif (DoctorTypeDesc["医师"){
		q 2
	}elseif (DoctorTypeDesc["医士"){
		q 1
	}
	q 6
}

/// w ##class(DHCDoc.Interface.YiBaoJianGuan.LocalData).GetConfig("MedinsAdmdvs")
ClassMethod GetConfig(key As %String)
{
	q:key="" ""
	q $Parameter($this,key)
}

}
