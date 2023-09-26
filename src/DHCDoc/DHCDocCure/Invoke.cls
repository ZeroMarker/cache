Class DHCDoc.DHCDocCure.Invoke Extends DHCDoc.Util.RegisteredObject
{

ClassMethod CheckFeeControl(orderExecId, ByRef ErrMsg As %String = "")
{
	s ErrCode=##class(web.DHCDocMainOrderInterface).CheckFeeControl(orderExecId)
	if +ErrCode'=0{
		s ErrMsg=..%GetErrCodeMsg("-100056","web.DHCDocMainOrderInterface")
		Q "-100056"
	}
	Q 0
}

ClassMethod InputForApply(OrdStr, UserID)
{
	f k=1:1:$l(OrdStr,"^")-1 {
		s OrdID=$p($p(OrdStr,"^",k),"*",2)
		i OrdID="" continue
		s InputDataPara=""
		s DCARowID=$o(^DHCDocCure(0,"OEORI",OrdID,""))
		continue:DCARowID=""
		s Para=OrdID_"^^"_DCARowID_"^"_"AP"_"^"_UserID
		D ##class(DHCDoc.DHCDocCure.Invoke).InputDataToCDR(Para)
	}
}

/// Desc:调用平台接口保存治疗生命周期数据到Ens_Status、Ens_StatusLog表
/// W ##CLASS(DHCDoc.DHCDocCure.Invoke).InputDataToCDR("1752910||2^^1^AP^1^测试")
ClassMethod InputDataToCDR(Para)
{
	/*
	OEOrdItemID	医嘱号	必填	该节点作为闭环的第一查询条件：对于检验检查闭环，该节点存放医嘱号；对于其他闭环存放规则如下：手术申请单id、输血申请单号、静配医嘱执行记录id、会诊id
	Position	检查部位		多部位时将多个部位以@@分隔
	ExamID	检查号\病理标本号\检验条码号		该节点作为闭环的第二查询条件：对于检验检查闭环，该节点存放条码号检查号；对于其他闭环存放规则如下：用血血袋号等
	Status	状态代码	必填	以《闭环节点登记表》为准
	UserID	操作人工号	必填	
	UserName	操作人姓名	必填	
	UpDateTime	操作日期时间	必填	yyyy-mm-dd hh24:mi:ss
	SourceSystem	来源系统代码	必填	以《闭环节点登记表》为准
	Remarks	备注
	*/	
		
	s DCARowID=$p(Para,"^",1) ;治疗站传治疗申请ID
	s Position=$p(Para,"^",2) ;治疗站传空
	s ExamID=$p(Para,"^",3) ;治疗站传业务节点ID
	s Status=$p(Para,"^",4)
	s UserID=$p(Para,"^",5)
	s Remarks=$p(Para,"^",6)
	s UserName=""
	s:UserID'="" UserName=$p(^SSU("SSUSR",UserID),"^",2)
	
	s:Remarks="" Remarks=$case(Status,"CUREAP":"治疗申请","CURECAP":"撤销治疗申请","CURECASP":"撤销治疗评定申请","CUREASP":"治疗评定申请","CUREBK":"治疗预约","CURECBK":"治疗取消预约","CUREZL":"治疗执行","CURECZL":"治疗执行撤销","CUREASS":"治疗评估","CURECASS":"治疗评估删除",:"治疗工作站")
	s SourceSystem="CURE" ;治疗站固定系统代码ZLJL
	s UpDateTime=$zd(+$H,3)_" "_$ZT($p($h,",",2))
	s InputObj=[]
	s JsonObj={}
	s JsonObj.OEOrdItemID=DCARowID
	s JsonObj.Position=Position
	s JsonObj.ExamID=ExamID
	s JsonObj.Status=Status
	s JsonObj.UserID=UserID
	s JsonObj.UserName=UserName
	s JsonObj.UpDateTime=UpDateTime
	s JsonObj.SourceSystem=SourceSystem
	s JsonObj.Remarks=Remarks
	d InputObj.%Push(JsonObj)
	s JsonStr=InputObj.%ToJSON()
	s InputStream = ##Class(%Stream.GlobalCharacter).%New()
	d InputStream.Write(JsonStr)
	b ;input
	s ret = ##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",InputStream)
	;s ^tmplog("InputDataToCDR",Status)=$lb(Para,JsonStr,ret.Read())
	q ret.Read()
}

}
