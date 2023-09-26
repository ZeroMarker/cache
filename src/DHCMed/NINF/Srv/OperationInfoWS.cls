Class DHCMed.NINF.Srv.OperationInfoWS Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter SERVICENAME = "OperationInfo";

Parameter LOCATION = "http://10.193.10.128:1972/csp/websource";

Parameter NAMESPACE = "http://tempuri.org";

/// 描述：更新手术接口数据
/// patientid, name, sex, age, department, bed, operation, optime, opdate, oproom, operator, anestor, mark, status, yz_no, xh_nurse, is_infect, xs_nurse, group_id, b_time, ward, exam, jy_mz, mzfs, ops1, ops2, tel, is_insert, yz, is_xshs, is_xhhs, is_mz, c, fz, is_oproom, op_type, is_ope, submit_time, lis_type, his_yz_no, is_yz, ack, szbd, yigan, bingan, RPR, HIV, ope_status, waiting_area_display, planType
/// patientid, e_date, 姓名, 性别, 年龄, 住院号, 科室, 手术诊断, 手术名称, 急诊, ASA, 麻醉方法, 手术医生, 手术开始时间, 手术结束时间, 手术科室, 自体血, 医嘱号, 主刀,  助1, 助2, 助3, 助4, 输血, 出血量
ClassMethod Update(aInputStr As %String) As %String [ WebMethod ]
{
	Set return=##Class(DHCMed.NINF.Srv.OperationInfo).Update(aInputStr)
	Quit return
}

/*
patientid 病案号 
 name,
 sex, 
 age,
 department,手术科室
 bed,床号
 operation,手术名称 
 optime,手术时间
 opdate,手术日期
 oproom,手术室
 operator,手术医生	
 anestor,麻醉医生
 mark,备注
 status,状态
 yz_no,医嘱编号
 xh_nurse,巡回护士
 is_infect,是否感染
 xs_nurse,洗手护士
 group_id,第几台手术
 b_time,开始时间
 ward,病房
 exam,诊断
 jy_mz,麻醉方式
 mzfs,
 ops1,一助	
 ops2,二助
 tel,
 is_insert,
 yz,下医嘱的医生
 is_xshs,是否是洗手护士
 is_xhhs,是否需要巡回护士
 is_mz,是否需要麻醉
 c,CD机的人
 fz,分组
 is_oproom,
 op_type, 门诊或住院
 is_ope,
 submit_time,
 lis_type,
 his_yz_no,医嘱号
 is_yz, 
 ack,
 szbd,
 yigan,
 bingan,
 RPR,
 HIV,
 ope_status,
 waiting_area_display,
 planType
*/
}
