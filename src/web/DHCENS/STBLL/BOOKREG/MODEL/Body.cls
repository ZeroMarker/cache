Class web.DHCENS.STBLL.BOOKREG.MODEL.Body Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Body";

/// 科室信息
Property deptInfos As web.DHCENS.STBLL.BOOKREG.MODEL.DeptInfoList(XMLNAME = "DepartmentsInfoRt");

/// 医院信息
Property hospitalInfos As web.DHCENS.STBLL.BOOKREG.MODEL.HospitalInfoList(XMLNAME = "HospitalInfoRt");

/// 医生信息
Property doctorInfos As web.DHCENS.STBLL.BOOKREG.MODEL.DoctorInfoList(XMLNAME = "DoctorsInfoRt");

/// 排班信息
Property rbApptSchedule As web.DHCENS.STBLL.BOOKREG.MODEL.RBApptSchedule(XMLNAME = "SynScheduleInfoRt");

/// 排班状态信息
Property rbApptScheduleStatus As web.DHCENS.STBLL.BOOKREG.MODEL.RBApptScheduleStatus(XMLNAME = "SynScheduleStatusInfoRt");

/// 取号确认
Property bookRegService As web.DHCENS.STBLL.BOOKREG.MODEL.BookRegService(XMLNAME = "BookRegRt");

}
