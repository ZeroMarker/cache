/// 名称:系统计数类型
/// 描述:删改查功能
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期:2014-4-2
Class web.DHCBL.CT.INCSysCounter Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2014-4-3
/// Description:查询数据	
/// Table:INC_SysCounter,CF_PatConf,CF_SM
/// Return:Json串
/// w ##class(web.DHCBL.CT.INCSysCounter).OpenData()
ClassMethod OpenData() As %String
{
	s str=""
	s eobj = ##class(web.Entity.CT.INCSysCounter).%New()
	s eobj.PATCFIPNoPrefix=$P($g(^CF("PATCF",1,1)),"^",19)
	s eobj.PATCFIPNoSuffix=$P($g(^CF("PATCF",1,1)),"^",20)
	s eobj.PATCFIPNoLength=$P($g(^CF("PATCF",1,3)),"^",5)
	s eobj.PATCFIPNoValue=$g(^PAPER(0,"CNT","I"))
	s eobj.PATCFOPAdmNoPrefix=$P($g(^CF("PATCF",1,1)),"^",23)
	s eobj.PATCFOPAdmNoSuffix=$P($g(^CF("PATCF",1,1)),"^",24)
	s eobj.PATCFOPAdmNoLength=$P($g(^CF("PATCF",1,3)),"^",4)
	s eobj.PATCFOPAdmNoValue=$g(^PAADM(0,"CNT","O"))
	s eobj.PATCFIPAdmNoPrefix=$P($g(^CF("PATCF",1,1)),"^",17)
	s eobj.PATCFIPAdmNoSuffix=$P($g(^CF("PATCF",1,1)),"^",18)
	s eobj.PATCFIPAdmNoLength=$P($g(^CF("PATCF",1,3)),"^",3)
	s eobj.PATCFIPAdmNoValue=$g(^PAADM(0,"CNT","I"))
	s eobj.PATCFEMAdmNoPrefix=$P($g(^CF("PATCF",1,1)),"^",13)
	s eobj.PATCFEMAdmNoSuffix=$P($g(^CF("PATCF",1,1)),"^",14)
	s eobj.PATCFEMAdmNoLength= $P($g(^CF("PATCF",1,3)),"^",1)
	s eobj.PATCFEMAdmNoValue=$g(^PAADM(0,"CNT","E"))
	s eobj.PATCFProcessPrefix=$P($g(^CF("PATCF",1,5)),"^",8)
	s eobj.PATCFProcessSuffix=$P($g(^CF("PATCF",1,5)),"^",9)
	s eobj.PATCFProcessLength=$P($g(^CF("PATCF",1,5)),"^",10)
	s eobj.PATCFProcessValue=$g(^PAADM(0,"CNT","PROC"))
	s eobj.PATCFHPPrefix=$P($g(^CF("PATCF",1,9)),"^",3)
	s eobj.PATCFHPSuffix=$P($g(^CF("PATCF",1,9)),"^",4)
	s eobj.PATCFHPLength=$P($g(^CF("PATCF",1,9)),"^",5)
	s eobj.PATCFHPValue=$g(^PAADM(0,"CNT","H"))
	
	s eobj.PATCFAnaestPrefix=$P($g(^CF("PATCF",1,4)),"^",2)
	s eobj.PATCFAnaestSuffix=$P($g(^CF("PATCF",1,4)),"^",3)
	s eobj.PATCFAnaestLength=$P($g(^CF("PATCF",1,4)),"^",2)
	s eobj.PATCFAnaestValue=$g(^PAPER(0,"CNT","ANA"))
	s eobj.PATCFOperPrefix=$P($g(^CF("PATCF",1,4)),"^",5)
	s eobj.PATCFOperSuffix=$P($g(^CF("PATCF",1,4)),"^",6)
	s eobj.PATCFOperLength=$P($g(^CF("PATCF",1,4)),"^",7)
	s eobj.PATCFOperValue=$g(^PAPER(0,"CNT","OPER"))
	
	s eobj.SMCFErrorFileCounter=$P($g(^CF("SM",1)),"^",8)
	
	s eobj.INCCNADJLength=$g(^COUNT("STOCK",1,"ADJ_Len"))
	s eobj.INCCNADJPrefix=$g(^COUNT("STOCK",1,"ADJ_Pre"))
	s eobj.INCCNADJSuffix=$g(^COUNT("STOCK",1,"ADJ_Suf"))
	s eobj.INCCNADJNo=$g(^COUNT("STOCK",1,"ADJ_No"))
	
	s eobj.INCCNDISPLength=$g(^COUNT("STOCK",1,"DISP_Len"))
	s eobj.INCCNDISPPrefix=$g(^COUNT("STOCK",1,"DISP_Pre"))
	s eobj.INCCNDISPSuffix=$g(^COUNT("STOCK",1,"DISP_Suf"))
	s eobj.INCCNDISPNo=$g(^COUNT("STOCK",1,"DISP_No"))
	
	s eobj.INCCNGRNLength=$g(^COUNT("STOCK",1,"GRN_Len"))
	s eobj.INCCNGRNPrefix=$g(^COUNT("STOCK",1,"GRN_Pre"))
	s eobj.INCCNGRNSuffix=$g(^COUNT("STOCK",1,"GRN_Suf"))
	s eobj.INCCNGRNNo=$g(^COUNT("STOCK",1,"GRN_No"))
	
	s eobj.INCCNRRLength=$g(^COUNT("STOCK",1,"RR_Len"))
	s eobj.INCCNRRPrefix=$g(^COUNT("STOCK",1,"RR_Pre"))
	s eobj.INCCNRRSuffix=$g(^COUNT("STOCK",1,"RR_Suf"))
	s eobj.INCCNRRNo=$g(^COUNT("STOCK",1,"RR_No"))
	
	s eobj.INCCNREQLength=$g(^COUNT("STOCK",1,"REQ_Len"))
	s eobj.INCCNREQPrefix=$g(^COUNT("STOCK",1,"REQ_Pre"))
	s eobj.INCCNREQSuffix=$g(^COUNT("STOCK",1,"REQ_Suf"))
	s eobj.INCCNREQNo=$g(^COUNT("STOCK",1,"REQ_No"))
	
	s eobj.INCCNSTLength=$g(^COUNT("STOCK",1,"ST_Len"))
	s eobj.INCCNSTPrefix=$g(^COUNT("STOCK",1,"ST_Pre"))
	s eobj.INCCNSTSuffix=$g(^COUNT("STOCK",1,"ST_Suf"))
	s eobj.INCCNSTNo=$g(^COUNT("STOCK",1,"ST_No"))
	
	s eobj.INCCNTRFLength=$g(^COUNT("STOCK",1,"TRF_Len"))
	s eobj.INCCNTRFPrefix=$g(^COUNT("STOCK",1,"TRF_Pre"))
	s eobj.INCCNTRFSuffix=$g(^COUNT("STOCK",1,"TRF_Suf"))
	s eobj.INCCNTRFNo=$g(^COUNT("STOCK",1,"TRF_No"))
	
	s eobj.INCCNPOLength=$g(^COUNT("STOCK",1,"PO_Len"))
	s eobj.INCCNPOPrefix=$g(^COUNT("STOCK",1,"PO_Pre"))
	s eobj.INCCNPOSuffix=$g(^COUNT("STOCK",1,"PO_Suf"))
	s eobj.INCCNPONo=$g(^COUNT("STOCK",1,"PO_No"))
	
	s eobj.INCCNMRQLength=$g(^COUNT("STOCK",1,"MRQ_Len"))
	s eobj.INCCNMRQPrefix=$g(^COUNT("STOCK",1,"MRQ_Pre"))
	s eobj.INCCNMRQSuffix=$g(^COUNT("STOCK",1,"MRQ_Suf"))
	s eobj.INCCNMRQNo=$g(^COUNT("STOCK",1,"MRQ_No"))
	
	s eobj.INCCNMOLength=$g(^COUNT("STOCK",1,"MO_Len"))
	s eobj.INCCNMOPrefix=$g(^COUNT("STOCK",1,"MO_Pre"))
	s eobj.INCCNMOSuffix=$g(^COUNT("STOCK",1,"MO_Suf"))
	s eobj.INCCNMONo=$g(^COUNT("STOCK",1,"MO_No"))
	
	s eobj.INCCNCSRLength=$g(^COUNT("STOCK",1,"CSR_Len"))
	s eobj.INCCNCSRPrefix=$g(^COUNT("STOCK",1,"CSR_Pre"))
	s eobj.INCCNCSRSuffix=$g(^COUNT("STOCK",1,"CSR_Suf"))
	s eobj.INCCNCSRNo=$g(^COUNT("STOCK",1,"CSR_No"))
	
	s eobj.INCCNCONSLength=$g(^COUNT("STOCK",1,"CONS_Len"))
	s eobj.INCCNCONSPrefix=$g(^COUNT("STOCK",1,"CONS_Pre"))
	s eobj.INCCNCONSSuffix=$g(^COUNT("STOCK",1,"CONS_Suf"))
	s eobj.INCCNCONSNo=$g(^COUNT("STOCK",1,"CONS_No"))
	
	s eobj.INCCNIsRetLength=$g(^COUNT("STOCK",1,"ISR_Len"))
	s eobj.INCCNIsRetPrefix=$g(^COUNT("STOCK",1,"ISR_Pre"))
	s eobj.INCCNIsRetSuffix=$g(^COUNT("STOCK",1,"ISR_Suf"))
	s eobj.INCCNIsRetNo=$g(^COUNT("STOCK",1,"ISR_No"))
	
	///add@2017-08-23  检验号生成配置
	s eobj.LabtrakNumberType=$P($g(^CF("PATCF",1,7)),"^",1)
	if eobj.LabtrakNumberType="U"
	{
		//s eobj.LabtrakCurrentNumber=$P($g(^COUNT("CNTTYPE",1)),"^",5)  //当前号
		s eobj.LabtrakCurrentNumber=$P($g(^COUNT("CNTTYPE",1,"No")),"^",1)  //当前号   2020-09-01换成下面的global节点。
		s eobj.LabtrakNumberLength=$P($g(^COUNT("CNTTYPE",1)),"^",4) ///总长度
	}
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
	///s ^CF("PATCF",1,7)="U^1^^Y^^^^^^^^^^^^^^^^^^^"
}

ClassMethod SaveEntity(eobj As web.Entity.CT.INCSysCounter) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		//病人管理-注册编号
		s $P(^CF("PATCF",1,1),"^",19)=eobj.PATCFIPNoPrefix
		s $P(^CF("PATCF",1,1),"^",20)=eobj.PATCFIPNoSuffix
		s $P(^CF("PATCF",1,3),"^",5)=eobj.PATCFIPNoLength
		IF $O(^PAPER(0))>0  //判断有没有业务数据
		{
			//有业务数据时，只允许计数器改大
			if eobj.PATCFIPNoValue>=$g(^PAPER(0,"CNT","I"))
			{
				s ^PAPER(0,"CNT","I")=eobj.PATCFIPNoValue
			}
			else
			{
				q "{success:'false',errorinfo:'已经有业务数据，<注册编号>计数器不允许改小！'}"
			}
		}
		else
		{
			s ^PAPER(0,"CNT","I")=eobj.PATCFIPNoValue
		}
		
		//病人管理-门诊病人
		s $P(^CF("PATCF",1,1),"^",23)=eobj.PATCFOPAdmNoPrefix
		s $P(^CF("PATCF",1,1),"^",24)=eobj.PATCFOPAdmNoSuffix
		s $P(^CF("PATCF",1,3),"^",4)=eobj.PATCFOPAdmNoLength
		IF $O(^PAADM(0))>0
		{
			//有业务数据时，只允许计数器改大
			if eobj.PATCFOPAdmNoValue>=$g(^PAADM(0,"CNT","O"))
			{
				s ^PAADM(0,"CNT","O")=eobj.PATCFOPAdmNoValue
			}
			else
			{
				q "{success:'false',errorinfo:'已经有业务数据，<门诊病人>计数器不允许改小！'}"
			}
		}
		else
		{
			s ^PAADM(0,"CNT","O")=eobj.PATCFOPAdmNoValue
		}
		
		//病人管理-住院病人
		s $P(^CF("PATCF",1,1),"^",17)=eobj.PATCFIPAdmNoPrefix
		s $P(^CF("PATCF",1,1),"^",18)=eobj.PATCFIPAdmNoSuffix
		s $P(^CF("PATCF",1,3),"^",3)=eobj.PATCFIPAdmNoLength
		IF $O(^PAADM(0))>0
		{
			//有业务数据时，只允许计数器改大
			if eobj.PATCFIPAdmNoValue>=$g(^PAADM(0,"CNT","I"))
			{
				s ^PAADM(0,"CNT","I")=eobj.PATCFIPAdmNoValue
			}
			else
			{
				q "{success:'false',errorinfo:'已经有业务数据，<住院病人>计数器不允许改小！'}"
			}
		}
		else
		{
			s ^PAADM(0,"CNT","I")=eobj.PATCFIPAdmNoValue
		}
		//病人管理-急诊病人
		s $P(^CF("PATCF",1,1),"^",13)=eobj.PATCFEMAdmNoPrefix
		s $P(^CF("PATCF",1,1),"^",14)=eobj.PATCFEMAdmNoSuffix
		s $P(^CF("PATCF",1,3),"^",1)=eobj.PATCFEMAdmNoLength
		IF $O(^PAADM(0))>0
		{
			//有业务数据时，只允许计数器改大
			if eobj.PATCFEMAdmNoValue>=$g(^PAADM(0,"CNT","E"))
			{
				s ^PAADM(0,"CNT","E")=eobj.PATCFEMAdmNoValue
			}
			else
			{
				q "{success:'false',errorinfo:'已经有业务数据，<急诊病人>计数器不允许改小！'}"
			}
		}
		else
		{
			s ^PAADM(0,"CNT","E")=eobj.PATCFEMAdmNoValue
		}
		//病人管理-过程编号
		s $P(^CF("PATCF",1,5),"^",8)=eobj.PATCFProcessPrefix
		s $P(^CF("PATCF",1,5),"^",9)=eobj.PATCFProcessSuffix
		s $P(^CF("PATCF",1,5),"^",10)=eobj.PATCFProcessLength
		IF $O(^PAADM(0))>0
		{
			//有业务数据时，只允许计数器改大
			if eobj.PATCFProcessValue>=$g(^PAADM(0,"CNT","PROC"))
			{
				s ^PAADM(0,"CNT","PROC")=eobj.PATCFProcessValue
			}
			else
			{
				q "{success:'false',errorinfo:'已经有业务数据，<过程编号>计数器不允许改小！'}"
			}
		}
		else
		{
			s ^PAADM(0,"CNT","PROC")=eobj.PATCFProcessValue
		}
		//病人管理-体检病人
		s $P(^CF("PATCF",1,9),"^",3)=eobj.PATCFHPPrefix
		s $P(^CF("PATCF",1,9),"^",4)=eobj.PATCFHPSuffix
		s $P(^CF("PATCF",1,9),"^",5)=eobj.PATCFHPLength
		IF $O(^PAADM(0))>0
		{
			//有业务数据时，只允许计数器改大
			if eobj.PATCFHPValue>=$g(^PAADM(0,"CNT","H"))
			{
				s ^PAADM(0,"CNT","H")=eobj.PATCFHPValue
			}
			else
			{
				q "{success:'false',errorinfo:'已经有业务数据，<体检病人>计数器不允许改小！'}"
			}
		}
		else
		{
			s ^PAADM(0,"CNT","H")=eobj.PATCFHPValue
		}
		//临床-麻醉
		s $P(^CF("PATCF",1,4),"^",2)=eobj.PATCFAnaestPrefix
		s $P(^CF("PATCF",1,4),"^",3)=eobj.PATCFAnaestSuffix
		s $P(^CF("PATCF",1,4),"^",2)=eobj.PATCFAnaestLength
		IF $O(^PAPER(0))>0
		{
			//有业务数据时，只允许计数器改大
			if eobj.PATCFAnaestValue>=$g(^PAPER(0,"CNT","ANA"))
			{
				s ^PAPER(0,"CNT","ANA")=eobj.PATCFAnaestValue
			}
			else
			{
				q "{success:'false',errorinfo:'已经有业务数据，<麻醉>计数器不允许改小！'}"
			}
		}
		else
		{
			s ^PAPER(0,"CNT","ANA")=eobj.PATCFAnaestValue
		}
		//临床-手术
		s $P(^CF("PATCF",1,4),"^",5)=eobj.PATCFOperPrefix
		s $P(^CF("PATCF",1,4),"^",6)=eobj.PATCFOperSuffix
		s $P(^CF("PATCF",1,4),"^",7)=eobj.PATCFOperLength
		IF $O(^PAPER(0))>0
		{
			//有业务数据时，只允许计数器改大
			if eobj.PATCFOperValue>=$g(^PAPER(0,"CNT","OPER"))
			{
				s ^PAPER(0,"CNT","OPER")=eobj.PATCFOperValue
			}
			else
			{
				q "{success:'false',errorinfo:'已经有业务数据，<手术>计数器不允许改小！'}"
			}
		}
		else
		{
			s ^PAPER(0,"CNT","OPER")=eobj.PATCFOperValue
		}
		
		s $P(^CF("SM",1),"^",8)=eobj.SMCFErrorFileCounter
		
		s ^COUNT("STOCK",1,"ADJ_Len")=eobj.INCCNADJLength
		s ^COUNT("STOCK",1,"ADJ_Pre")=eobj.INCCNADJPrefix
		s ^COUNT("STOCK",1,"ADJ_Suf")=eobj.INCCNADJSuffix
		s ^COUNT("STOCK",1,"ADJ_No")=eobj.INCCNADJNo
		
		s ^COUNT("STOCK",1,"DISP_Len")=eobj.INCCNDISPLength
		s ^COUNT("STOCK",1,"DISP_Pre")=eobj.INCCNDISPPrefix
		s ^COUNT("STOCK",1,"DISP_Suf")=eobj.INCCNDISPSuffix
		s ^COUNT("STOCK",1,"DISP_No")=eobj.INCCNDISPNo
		
		s ^COUNT("STOCK",1,"GRN_Len")=eobj.INCCNGRNLength
		s ^COUNT("STOCK",1,"GRN_Pre")=eobj.INCCNGRNPrefix
		s ^COUNT("STOCK",1,"GRN_Suf")=eobj.INCCNGRNSuffix
		s ^COUNT("STOCK",1,"GRN_No")=eobj.INCCNGRNNo
		
		s ^COUNT("STOCK",1,"RR_Len")=eobj.INCCNRRLength
		s ^COUNT("STOCK",1,"RR_Pre")=eobj.INCCNRRPrefix
		s ^COUNT("STOCK",1,"RR_Suf")=eobj.INCCNRRSuffix
		s ^COUNT("STOCK",1,"RR_No")=eobj.INCCNRRNo
		
		s ^COUNT("STOCK",1,"REQ_Len")=eobj.INCCNREQLength
		s ^COUNT("STOCK",1,"REQ_Pre")=eobj.INCCNREQPrefix
		s ^COUNT("STOCK",1,"REQ_Suf")=eobj.INCCNREQSuffix
		s ^COUNT("STOCK",1,"REQ_No")=eobj.INCCNREQNo
		
		s ^COUNT("STOCK",1,"ST_Len")=eobj.INCCNSTLength
		s ^COUNT("STOCK",1,"ST_Pre")=eobj.INCCNSTPrefix
		s ^COUNT("STOCK",1,"ST_Suf")=eobj.INCCNSTSuffix
		s ^COUNT("STOCK",1,"ST_No")=eobj.INCCNSTNo
		
		s ^COUNT("STOCK",1,"TRF_Len")=eobj.INCCNTRFLength
		s ^COUNT("STOCK",1,"TRF_Pre")=eobj.INCCNTRFPrefix
		s ^COUNT("STOCK",1,"TRF_Suf")=eobj.INCCNTRFSuffix
		s ^COUNT("STOCK",1,"TRF_No")=eobj.INCCNTRFNo
		
		s ^COUNT("STOCK",1,"PO_Len")=eobj.INCCNPOLength
		s ^COUNT("STOCK",1,"PO_Pre")=eobj.INCCNPOPrefix
		s ^COUNT("STOCK",1,"PO_Suf")=eobj.INCCNPOSuffix
		s ^COUNT("STOCK",1,"PO_No")=eobj.INCCNPONo
		
		s ^COUNT("STOCK",1,"MRQ_Len")=eobj.INCCNMRQLength
		s ^COUNT("STOCK",1,"MRQ_Pre")=eobj.INCCNMRQPrefix
		s ^COUNT("STOCK",1,"MRQ_Suf")=eobj.INCCNMRQSuffix
		s ^COUNT("STOCK",1,"MRQ_No")=eobj.INCCNMRQNo
		
		s ^COUNT("STOCK",1,"MO_Len")=eobj.INCCNMOLength
		s ^COUNT("STOCK",1,"MO_Pre")=eobj.INCCNMOPrefix
		s ^COUNT("STOCK",1,"MO_Suf")=eobj.INCCNMOSuffix
		s ^COUNT("STOCK",1,"MO_No")=eobj.INCCNMONo
		
		s ^COUNT("STOCK",1,"CSR_Len")=eobj.INCCNCSRLength
		s ^COUNT("STOCK",1,"CSR_Pre")=eobj.INCCNCSRPrefix
		s ^COUNT("STOCK",1,"CSR_Suf")=eobj.INCCNCSRSuffix
		s ^COUNT("STOCK",1,"CSR_No")=eobj.INCCNCSRNo
		
		s ^COUNT("STOCK",1,"CONS_Len")=eobj.INCCNCONSLength
		s ^COUNT("STOCK",1,"CONS_Pre")=eobj.INCCNCONSPrefix
		s ^COUNT("STOCK",1,"CONS_Suf")=eobj.INCCNCONSSuffix
		s ^COUNT("STOCK",1,"CONS_No")=eobj.INCCNCONSNo
		
		s ^COUNT("STOCK",1,"ISR_Len")=eobj.INCCNIsRetLength
		s ^COUNT("STOCK",1,"ISR_Pre")=eobj.INCCNIsRetPrefix
		s ^COUNT("STOCK",1,"ISR_Suf")=eobj.INCCNIsRetSuffix
		s ^COUNT("STOCK",1,"ISR_No")=eobj.INCCNIsRetNo
		
		s $P(^CF("PATCF",1,7),"^",1)=eobj.LabtrakNumberType
		if eobj.LabtrakNumberType="U"
		{
			s $P(^CF("PATCF",1,7),"^",2)="1"
			///s $P(^COUNT("CNTTYPE","1"),"^",5)=eobj.LabtrakCurrentNumber  ///^前缀^后缀^长度^当前号  2020-09-01换成下面的global节点。
			s $P(^COUNT("CNTTYPE",1,"No"),"^",1)=eobj.LabtrakCurrentNumber
			s $P(^COUNT("CNTTYPE","1"),"^",4)=eobj.LabtrakNumberLength
		}
	
		s result = "{success:'true'}"				
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator:陈莹
/// CreatDate:2022-03-25
/// Description:将不同区域的数据分开保存-病人管理	
/// Table:
/// w ##class(web.DHCBL.CT.INCSysCounter).SaveEntityAdmNo()
ClassMethod SaveEntityAdmNo(eobj As web.Entity.CT.INCSysCounter) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		//病人管理-注册编号
		s $P(^CF("PATCF",1,1),"^",19)=eobj.PATCFIPNoPrefix
		s $P(^CF("PATCF",1,1),"^",20)=eobj.PATCFIPNoSuffix
		s $P(^CF("PATCF",1,3),"^",5)=eobj.PATCFIPNoLength
		IF $O(^PAPER(0))>0  //判断有没有业务数据
		{
			//有业务数据时，只允许计数器改大
			if eobj.PATCFIPNoValue>=$g(^PAPER(0,"CNT","I"))
			{
				s ^PAPER(0,"CNT","I")=eobj.PATCFIPNoValue
			}
			else
			{
				q "{success:'false',errorinfo:'已经有业务数据，<注册编号>计数器不允许改小！'}"
			}
		}
		else
		{
			s ^PAPER(0,"CNT","I")=eobj.PATCFIPNoValue
		}
		
		//病人管理-门诊病人
		s $P(^CF("PATCF",1,1),"^",23)=eobj.PATCFOPAdmNoPrefix
		s $P(^CF("PATCF",1,1),"^",24)=eobj.PATCFOPAdmNoSuffix
		s $P(^CF("PATCF",1,3),"^",4)=eobj.PATCFOPAdmNoLength
		IF $O(^PAADM(0))>0
		{
			//有业务数据时，只允许计数器改大
			if eobj.PATCFOPAdmNoValue>=$g(^PAADM(0,"CNT","O"))
			{
				s ^PAADM(0,"CNT","O")=eobj.PATCFOPAdmNoValue
			}
			else
			{
				q "{success:'false',errorinfo:'已经有业务数据，<门诊病人>计数器不允许改小！'}"
			}
		}
		else
		{
			s ^PAADM(0,"CNT","O")=eobj.PATCFOPAdmNoValue
		}
		
		//病人管理-住院病人
		s $P(^CF("PATCF",1,1),"^",17)=eobj.PATCFIPAdmNoPrefix
		s $P(^CF("PATCF",1,1),"^",18)=eobj.PATCFIPAdmNoSuffix
		s $P(^CF("PATCF",1,3),"^",3)=eobj.PATCFIPAdmNoLength
		IF $O(^PAADM(0))>0
		{
			//有业务数据时，只允许计数器改大
			if eobj.PATCFIPAdmNoValue>=$g(^PAADM(0,"CNT","I"))
			{
				s ^PAADM(0,"CNT","I")=eobj.PATCFIPAdmNoValue
			}
			else
			{
				q "{success:'false',errorinfo:'已经有业务数据，<住院病人>计数器不允许改小！'}"
			}
		}
		else
		{
			s ^PAADM(0,"CNT","I")=eobj.PATCFIPAdmNoValue
		}
		//病人管理-急诊病人
		s $P(^CF("PATCF",1,1),"^",13)=eobj.PATCFEMAdmNoPrefix
		s $P(^CF("PATCF",1,1),"^",14)=eobj.PATCFEMAdmNoSuffix
		s $P(^CF("PATCF",1,3),"^",1)=eobj.PATCFEMAdmNoLength
		IF $O(^PAADM(0))>0
		{
			//有业务数据时，只允许计数器改大
			if eobj.PATCFEMAdmNoValue>=$g(^PAADM(0,"CNT","E"))
			{
				s ^PAADM(0,"CNT","E")=eobj.PATCFEMAdmNoValue
			}
			else
			{
				q "{success:'false',errorinfo:'已经有业务数据，<急诊病人>计数器不允许改小！'}"
			}
		}
		else
		{
			s ^PAADM(0,"CNT","E")=eobj.PATCFEMAdmNoValue
		}
		//病人管理-过程编号
		s $P(^CF("PATCF",1,5),"^",8)=eobj.PATCFProcessPrefix
		s $P(^CF("PATCF",1,5),"^",9)=eobj.PATCFProcessSuffix
		s $P(^CF("PATCF",1,5),"^",10)=eobj.PATCFProcessLength
		IF $O(^PAADM(0))>0
		{
			//有业务数据时，只允许计数器改大
			if eobj.PATCFProcessValue>=$g(^PAADM(0,"CNT","PROC"))
			{
				s ^PAADM(0,"CNT","PROC")=eobj.PATCFProcessValue
			}
			else
			{
				q "{success:'false',errorinfo:'已经有业务数据，<过程编号>计数器不允许改小！'}"
			}
		}
		else
		{
			s ^PAADM(0,"CNT","PROC")=eobj.PATCFProcessValue
		}
		//病人管理-体检病人
		s $P(^CF("PATCF",1,9),"^",3)=eobj.PATCFHPPrefix
		s $P(^CF("PATCF",1,9),"^",4)=eobj.PATCFHPSuffix
		s $P(^CF("PATCF",1,9),"^",5)=eobj.PATCFHPLength
		IF $O(^PAADM(0))>0
		{
			//有业务数据时，只允许计数器改大
			if eobj.PATCFHPValue>=$g(^PAADM(0,"CNT","H"))
			{
				s ^PAADM(0,"CNT","H")=eobj.PATCFHPValue
			}
			else
			{
				q "{success:'false',errorinfo:'已经有业务数据，<体检病人>计数器不允许改小！'}"
			}
		}
		else
		{
			s ^PAADM(0,"CNT","H")=eobj.PATCFHPValue
		}
		s result = "{success:'true'}"				
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator:陈莹
/// CreatDate:2022-03-25
/// Description:将不同区域的数据分开保存-临床
/// Table:
/// w ##class(web.DHCBL.CT.INCSysCounter).SaveEntityClinic()
ClassMethod SaveEntityClinic(eobj As web.Entity.CT.INCSysCounter) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		//临床-麻醉
		s $P(^CF("PATCF",1,4),"^",2)=eobj.PATCFAnaestPrefix
		s $P(^CF("PATCF",1,4),"^",3)=eobj.PATCFAnaestSuffix
		s $P(^CF("PATCF",1,4),"^",2)=eobj.PATCFAnaestLength
		IF $O(^PAPER(0))>0
		{
			//有业务数据时，只允许计数器改大
			if eobj.PATCFAnaestValue>=$g(^PAPER(0,"CNT","ANA"))
			{
				s ^PAPER(0,"CNT","ANA")=eobj.PATCFAnaestValue
			}
			else
			{
				q "{success:'false',errorinfo:'已经有业务数据，<麻醉>计数器不允许改小！'}"
			}
		}
		else
		{
			s ^PAPER(0,"CNT","ANA")=eobj.PATCFAnaestValue
		}
		//临床-手术
		s $P(^CF("PATCF",1,4),"^",5)=eobj.PATCFOperPrefix
		s $P(^CF("PATCF",1,4),"^",6)=eobj.PATCFOperSuffix
		s $P(^CF("PATCF",1,4),"^",7)=eobj.PATCFOperLength
		IF $O(^PAPER(0))>0
		{
			//有业务数据时，只允许计数器改大
			if eobj.PATCFOperValue>=$g(^PAPER(0,"CNT","OPER"))
			{
				s ^PAPER(0,"CNT","OPER")=eobj.PATCFOperValue
			}
			else
			{
				q "{success:'false',errorinfo:'已经有业务数据，<手术>计数器不允许改小！'}"
			}
		}
		else
		{
			s ^PAPER(0,"CNT","OPER")=eobj.PATCFOperValue
		}
		s result = "{success:'true'}"				
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator:陈莹
/// CreatDate:2022-03-25
/// Description:将不同区域的数据分开保存-系统
/// Table:
/// w ##class(web.DHCBL.CT.INCSysCounter).SaveEntitySystem()
ClassMethod SaveEntitySystem(eobj As web.Entity.CT.INCSysCounter) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s $P(^CF("SM",1),"^",8)=eobj.SMCFErrorFileCounter
		s result = "{success:'true'}"				
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator:陈莹
/// CreatDate:2022-03-25
/// Description:将不同区域的数据分开保存-检验号生成配置
/// Table:
/// w ##class(web.DHCBL.CT.INCSysCounter).SaveEntityLabtrak()
ClassMethod SaveEntityLabtrak(eobj As web.Entity.CT.INCSysCounter) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		
		//检验号生成配置
		s $P(^CF("PATCF",1,7),"^",1)=eobj.LabtrakNumberType
		if eobj.LabtrakNumberType="U"
		{
			s $P(^CF("PATCF",1,7),"^",2)="1"
			///s $P(^COUNT("CNTTYPE","1"),"^",5)=eobj.LabtrakCurrentNumber  ///^前缀^后缀^长度^当前号  2020-09-01换成下面的global节点。
			s $P(^COUNT("CNTTYPE",1,"No"),"^",1)=eobj.LabtrakCurrentNumber
			s $P(^COUNT("CNTTYPE","1"),"^",4)=eobj.LabtrakNumberLength
		}
		
		s result = "{success:'true'}"				
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator:陈莹
/// CreatDate:2022-03-25
/// Description:将不同区域的数据分开保存-库存
/// Table:
/// w ##class(web.DHCBL.CT.INCSysCounter).SaveEntityStock()
ClassMethod SaveEntityStock(eobj As web.Entity.CT.INCSysCounter) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		
		s ^COUNT("STOCK",1,"ADJ_Len")=eobj.INCCNADJLength
		s ^COUNT("STOCK",1,"ADJ_Pre")=eobj.INCCNADJPrefix
		s ^COUNT("STOCK",1,"ADJ_Suf")=eobj.INCCNADJSuffix
		s ^COUNT("STOCK",1,"ADJ_No")=eobj.INCCNADJNo
		
		s ^COUNT("STOCK",1,"DISP_Len")=eobj.INCCNDISPLength
		s ^COUNT("STOCK",1,"DISP_Pre")=eobj.INCCNDISPPrefix
		s ^COUNT("STOCK",1,"DISP_Suf")=eobj.INCCNDISPSuffix
		s ^COUNT("STOCK",1,"DISP_No")=eobj.INCCNDISPNo
		
		s ^COUNT("STOCK",1,"GRN_Len")=eobj.INCCNGRNLength
		s ^COUNT("STOCK",1,"GRN_Pre")=eobj.INCCNGRNPrefix
		s ^COUNT("STOCK",1,"GRN_Suf")=eobj.INCCNGRNSuffix
		s ^COUNT("STOCK",1,"GRN_No")=eobj.INCCNGRNNo
		
		s ^COUNT("STOCK",1,"RR_Len")=eobj.INCCNRRLength
		s ^COUNT("STOCK",1,"RR_Pre")=eobj.INCCNRRPrefix
		s ^COUNT("STOCK",1,"RR_Suf")=eobj.INCCNRRSuffix
		s ^COUNT("STOCK",1,"RR_No")=eobj.INCCNRRNo
		
		s ^COUNT("STOCK",1,"REQ_Len")=eobj.INCCNREQLength
		s ^COUNT("STOCK",1,"REQ_Pre")=eobj.INCCNREQPrefix
		s ^COUNT("STOCK",1,"REQ_Suf")=eobj.INCCNREQSuffix
		s ^COUNT("STOCK",1,"REQ_No")=eobj.INCCNREQNo
		
		s ^COUNT("STOCK",1,"ST_Len")=eobj.INCCNSTLength
		s ^COUNT("STOCK",1,"ST_Pre")=eobj.INCCNSTPrefix
		s ^COUNT("STOCK",1,"ST_Suf")=eobj.INCCNSTSuffix
		s ^COUNT("STOCK",1,"ST_No")=eobj.INCCNSTNo
		
		s ^COUNT("STOCK",1,"TRF_Len")=eobj.INCCNTRFLength
		s ^COUNT("STOCK",1,"TRF_Pre")=eobj.INCCNTRFPrefix
		s ^COUNT("STOCK",1,"TRF_Suf")=eobj.INCCNTRFSuffix
		s ^COUNT("STOCK",1,"TRF_No")=eobj.INCCNTRFNo
		
		s ^COUNT("STOCK",1,"PO_Len")=eobj.INCCNPOLength
		s ^COUNT("STOCK",1,"PO_Pre")=eobj.INCCNPOPrefix
		s ^COUNT("STOCK",1,"PO_Suf")=eobj.INCCNPOSuffix
		s ^COUNT("STOCK",1,"PO_No")=eobj.INCCNPONo
		
		s ^COUNT("STOCK",1,"MRQ_Len")=eobj.INCCNMRQLength
		s ^COUNT("STOCK",1,"MRQ_Pre")=eobj.INCCNMRQPrefix
		s ^COUNT("STOCK",1,"MRQ_Suf")=eobj.INCCNMRQSuffix
		s ^COUNT("STOCK",1,"MRQ_No")=eobj.INCCNMRQNo
		
		s ^COUNT("STOCK",1,"MO_Len")=eobj.INCCNMOLength
		s ^COUNT("STOCK",1,"MO_Pre")=eobj.INCCNMOPrefix
		s ^COUNT("STOCK",1,"MO_Suf")=eobj.INCCNMOSuffix
		s ^COUNT("STOCK",1,"MO_No")=eobj.INCCNMONo
		
		s ^COUNT("STOCK",1,"CSR_Len")=eobj.INCCNCSRLength
		s ^COUNT("STOCK",1,"CSR_Pre")=eobj.INCCNCSRPrefix
		s ^COUNT("STOCK",1,"CSR_Suf")=eobj.INCCNCSRSuffix
		s ^COUNT("STOCK",1,"CSR_No")=eobj.INCCNCSRNo
		
		s ^COUNT("STOCK",1,"CONS_Len")=eobj.INCCNCONSLength
		s ^COUNT("STOCK",1,"CONS_Pre")=eobj.INCCNCONSPrefix
		s ^COUNT("STOCK",1,"CONS_Suf")=eobj.INCCNCONSSuffix
		s ^COUNT("STOCK",1,"CONS_No")=eobj.INCCNCONSNo
		
		s ^COUNT("STOCK",1,"ISR_Len")=eobj.INCCNIsRetLength
		s ^COUNT("STOCK",1,"ISR_Pre")=eobj.INCCNIsRetPrefix
		s ^COUNT("STOCK",1,"ISR_Suf")=eobj.INCCNIsRetSuffix
		s ^COUNT("STOCK",1,"ISR_No")=eobj.INCCNIsRetNo
		
		s result = "{success:'true'}"				
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

}
