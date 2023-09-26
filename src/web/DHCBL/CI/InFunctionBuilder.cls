/// 内部功能的集成
Class web.DHCBL.CI.InFunctionBuilder Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 根据发票RowID串来执行
ClassMethod OPChargeServiceByPRTStr(PRTRowIDStr As %String, SFlag As %String) As %String
{
	n (PRTRowIDStr, SFlag)
	s $ZT="ERRORNoTrans^DHCSSERR"
	
	s myrtn=0
	
	s mylen=$l(PRTRowIDStr,"^")
	
	f myIdx=2:1:mylen   d
	.s myPRTRowID=$p(PRTRowIDStr,"^",myIdx)
	.s myinfo=..OPChargeService(myPRTRowID, SFlag)
	.s myrtn=+$p(myinfo,"^",1)
	
	q myrtn
}

/// 门诊收费/退费的功能
ClassMethod OPChargeService(INVPRTRowID As %String, SFlag As %String) As %String
{
	;1.根据发票获取医嘱RowID；
	;2. 把医嘱RowID串，传递给初排程接口
	;3. 把医嘱RowID串，传递给
	s $ZT="ERRORNoTrans^DHCSSERR"
	n (INVPRTRowID, SFlag)
	
	s myrtn=0
	s myOEORIStr=##class(web.DHCBL.CIDefine.OEORIDefine).GetOEORIStrByPRTRowID(INVPRTRowID,SFlag)
	q:myOEORIStr="" myrtn
	b	;;InInterFace
	;2. 把医嘱RowID串，传递给初排程接口
	s myrtn=##class(web.DHCBL.CIDefine.CICacheTypeDefine).SetRBApptScheduleByOEORDStr(myOEORIStr,SFlag)
	
	q myrtn
}

}
