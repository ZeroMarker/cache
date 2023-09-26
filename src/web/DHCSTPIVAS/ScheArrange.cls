Import sqluser

/// creator: 	yunhaibao
/// createdate: 2018-07-11
/// description:排班(手工修改)
Class web.DHCSTPIVAS.ScheArrange Extends %RegisteredObject
{

/// desrciption: 保存排班
/// inputStr
ClassMethod SaveScheArrItm(inputStr)
{
	s ^TMPDHCSTPARAMS("web.DHCSTPIVAS.ScheArrange","SaveScheArrItm")=inputStr
	s psaId=+$p(inputStr,"^",1)	
	s psaIDate=$p(inputStr,"^",2)	// 排班日期
	s psaIDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(psaIDate)
	s psaIScheId=$p(inputStr,"^",3)	// 班次
	s psaIUserId=$p(inputStr,"^",4)	// 人员
	q:psaId'>0 "-1^排班主表Id为空"
	q:+psaIDate=0 "-1^排班日期为空"
	q:+psaIScheId=0 "-1^班次为空"
	q:+psaIUserId=0 "-1^人员为空"
	s pduId=$o(^Config.PIVA.DutyUser(0,"User",psaIUserId,""))
	q:pduId="" "-1^人员岗位未关联"
	s psaIDutyId=$p(^Config.PIVA.DutyUser(pduId),"^",1)
	q:psaIDutyId="""-1^岗位不存在"
	// 验证是否存在
	&SQL(
		SELECT * FROM PIVA_ScheArrangeItm 
		WHERE 
		PSAI_Parref=:psaId AND PSAI_Date=:psaIDate AND PSAI_User_Dr=:psaIUserId AND PSAI_Schedul_Dr=:psaIScheId
	)
	q:SQLCODE=0 "-1^人员已排该日期此班次"
	s maxChild=$o(^Busi.PIVA.ScheArrange(psaId,"I",""),-1)+1
	&SQL(
		INSERT INTO PIVA_ScheArrangeItm
		(PSAI_Parref,PSAI_ChildSub,PSAI_Date,PSAI_User_Dr,PSAI_Schedul_Dr,PSAI_Duty_Dr)
		VALUES
		(:psaId,:maxChild,:psaIDate,:psaIUserId,:psaIScheId,:psaIDutyId)	
		)
	q:SQLCODE'=0 "-1^插入排班子表失败,SQLCODE:"_SQLCODE_","_$g(%msg)
	s psaItmId=$p(%ROWID,$c(1))
	s psaItmData=$g(^Busi.PIVA.ScheArrange(+psaItmId,"I",+$p(psaItmId,"||",2))) 
	s restRet=##class(web.DHCSTPIVAS.Rest).SaveRestItm(psaItmData,"PLUS")
	q 0
}

/// description: 删除排班
/// input:		 ^1:排班子表Id
ClassMethod DeleteScheArrItm(inputStr)
{
	s psaItmId=$p(inputStr,"!!",1)
	q:psaItmId="" "-1^排班子表Id为空"
	s psaItmData=$g(^Busi.PIVA.ScheArrange(+psaItmId,"I",+$p(psaItmId,"||",2))) 
	&SQL(DELETE FROM PIVA_ScheArrangeItm WHERE PSAI_RowId=:psaItmId)
	q:SQLCODE'=0 "-1^删除失败,SQLCODE:"_SQLCODE_","_$g(%msg)
	s restRet=##class(web.DHCSTPIVAS.Rest).SaveRestItm(psaItmData,"MINUS")
	q 0
}

}
