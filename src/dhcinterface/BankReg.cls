Class dhcinterface.BankReg Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 银医卡接口调度
ClassMethod BankRegisterBuilder(RequestObj As dhcinterface.BankSendMsg) As dhcinterface.BankReturnMsg
{
	s $ZTrap="OnSendMsgError" 
	s ResponseObj=##class(dhcinterface.BankReturnMsg).%New()
	i (RequestObj.BankCode="")!((RequestObj.BankCode=$c(0)))
	{
		s ResponseObj.ResultCode="001"
		s ResponseObj.ErrorMsg="注册失败:银行编码 BankCode不能为空 "
	    q ResponseObj
	}
	s Initials=RequestObj.BankCode
	s RequestObj.UserDR=$o(^SSU("SSUSR",0,"SSUSR_Initials",Initials,""))
	i (RequestObj.UserDR="")
	{
		s ResponseObj.ResultCode="001"
		s ResponseObj.ErrorMsg="注册失败:医院无对应的银行编码 BankCode代码 "
		q ResponseObj
	}
	i RequestObj.ActionCode="R01" //注册
	{
		s ResponseObj=##class(dhcinterface.BankRegRule).ToRegister(RequestObj)
	}
	elseif RequestObj.ActionCode="R02" //换卡
	{
		s ResponseObj=##class(dhcinterface.BankRegRule).ChangeCard(RequestObj)
	}
	elseif RequestObj.ActionCode="R03" //挂失
	{
		s ResponseObj=##class(dhcinterface.BankRegRule).DeclareCardLost(RequestObj)
	}
	elseif RequestObj.ActionCode="R04" //撤消挂失
	{
		s ResponseObj=##class(dhcinterface.BankRegRule).RecallCard(RequestObj)
	}
	elseif RequestObj.ActionCode="R05" //卡作废
	{
		s ResponseObj=##class(dhcinterface.BankRegRule).RepealCard(RequestObj)
	}
	elseif RequestObj.ActionCode="R06" //变更病人基本信息
	{
		s ResponseObj=##class(dhcinterface.BankRegRule).ChangePatientInfo(RequestObj)
	}
	q ResponseObj
OnSendMsgError
	s ResponseObj.ResultCode="001"
	s ResponseObj.ErrorMsg="BankRegisterBuilder异常:"_$ze
	q ResponseObj
}

/// 银医卡接口
ClassMethod BankRegister(XmlPara As %String) As %String
{
	s $ZTrap="OnSendMsgError"
	s Xml=""
	s reader=##class(%XML.Reader).%New()
	s sc=reader.OpenString(XmlPara)
	Do reader.Correlate("Request","dhcinterface.BankSendMsg")
	While reader.Next(.BankPara,.sc)  
	{
		 //转换病人登记号为Rowid
		 i BankPara.PatientDetails.Count()>0
		 {
			 s PAPMINO=BankPara.PatientDetails.GetAt(BankPara.PatientDetails.Count()).PatientID
			 i PAPMINO'="" 
			 {
				s PAPMIRowID=$o(^PAPERi("PAPMI_PatNo",PAPMINO,""))
			 	s BankPara.PatientDetails.GetAt(BankPara.PatientDetails.Count()).PatientID=PAPMIRowID
			 }
		 }
		 s msgobj=##class(dhcinterface.BankReg).BankRegisterBuilder(BankPara)
		 s msgobj.TxDate=$zd(+$h,3)
		 s msgobj.TransactionId=BankPara.TransactionId
		 s msgobj.ActionCode=BankPara.ActionCode
		 s msgobj.BankCode=BankPara.BankCode
		 i $tr(msgobj.PatientID," ")'=""
		 {
			 s PAPMINO=$p($g(^PAPER(msgobj.PatientID,"PAT",1)),"^",2 )
			 s msgobj.PatientID=PAPMINO
		 }         
		 s status=msgobj.XMLExportToString(.Xml,"Response") 
	}
	Q Xml
OnSendMsgError
 	Quit "<Response><ResultCode>001</ResultCode><ErrorMsg>BankRegister异常"_$ze_"</ErrorMsg></Response>"
}

ClassMethod Test(input As %String) As %String
{
	s input="<Request><ActionCode>R01</ActionCode><PatientDetails><BankPatDetail><PatientCard>9558804402111582577</PatientCard><Name>测试</Name><Sex>M</Sex><DOB>1986-01-01</DOB><IDType>01</IDType><IDNo>522863198601012685</IDNo><Address>111111</Address><TelephoneNo>85111369</TelephoneNo><OldPatientCard></OldPatientCard></BankPatDetail></PatientDetails><BankCode></BankCode><TransactionId>000433893</TransactionId><UserDR></UserDR></Request>"	
	
	;s XmlPara="<Request><BankCode>ICBC</BankCode><TransactionId>10169953</TransactionId><ActionCode>R01</ActionCode><TxDate>2011-02-21</TxDate><UserDR></UserDR><MAC></MAC><PatientDetails><BankPatDetail><PatientID></PatientID><PatientCard>6227000610550099583</PatientCard><Name>宫雪茹</Name><Sex>F</Sex><Workplace>0</Workplace><PatType>1</PatType><DOB>1986-10-17</DOB><IDType>A</IDType><IDNo>21062319861017188X</IDNo><Address>东港市十字街镇</Address><Zip>118000</Zip><TelephoneNo></TelephoneNo><Mobile>13941561776</Mobile><OldPatientCard></OldPatientCard></BankPatDetail></PatientDetails></Request>"
    
    ;s XmlPara="<Request><ActionCode>R01</ActionCode><PatientDetails><BankPatDetail><PatientCard>9558804402111582577</PatientCard><Name>测试</Name><Sex>M</Sex><DOB>1986-01-01</DOB><IDType>01</IDType><IDNo>522863198601012685</IDNo><Address>111111</Address><TelephoneNo>85111369</TelephoneNo><OldPatientCard></OldPatientCard></BankPatDetail></PatientDetails><BankCode>ICBC</BankCode><TransactionId>000433893</TransactionId><UserDR>ICBC</UserDR></Request>"
    ;s XmlPara="<Request><TxDate>2008-09-24</TxDate><TransactionId>3973</TransactionId><ActionCode>R01</ActionCode><BankCode>CCB</BankCode><PatientDetails><BankPatDetail><PatientID>06882083</PatientID><PatientCard>6227003811070058005</PatientCard><Name>赵嘉鑫</Name><Sex>M</Sex><DOB>1986-05-27</DOB><IDType>A</IDType><IDNo>14220119860527146X</IDNo><Address>b</Address><Zip></Zip><TelephoneNo>555532</TelephoneNo><Mobile>123123</Mobile><OldPatientCard></OldPatientCard></BankPatDetail></PatientDetails></Request>"
	
	;s XmlPara="<Request><ActionCode>R02</ActionCode><PatientDetails><BankPatDetail><PatientCard>6222328327117507</PatientCard><Name>测试卡</Name><Sex></Sex><DOB></DOB><IDType>01</IDType><IDNo>510999198202023366</IDNo><Address></Address><TelephoneNo></TelephoneNo><OldPatientCard></OldPatientCard><PatientID>00676768</PatientID></BankPatDetail></PatientDetails><BankCode>ICBC</BankCode><TransactionId>000434697</TransactionId><UserDR>ICBC</UserDR></Request>"
	
	
	;s XmlPara="<Request><ActionCode>R01</ActionCode><PatientDetails><BankPatDetail><PatientCard>6222138327570880</PatientCard><Name>测试</Name><Sex>M</Sex><DOB>1985-11-13</DOB><IDType>01</IDType><IDNo>510107198511131798</IDNo><Address>成都</Address><TelephoneNo>85350063</TelephoneNo><OldPatientCard></OldPatientCard><PatientID></PatientID></BankPatDetail></PatientDetails><BankCode>ICBC</BankCode><TransactionId>000435720</TransactionId><UserDR>ICBC</UserDR></Request>"

	s a=..BankRegister(input)
	q a
}

}
