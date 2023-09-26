/// 名称:BDP数据导入
/// 编写者:基础数据平台组 - 谷雪萍/陈莹
/// 编写日期:2016-3-24
/// update2020-02-11
Class web.DHCBL.BDP.BDPDataExport Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：chenying
/// CreatDate: 2016-3-29
/// Description：导出excel 通过表名获取表描述  返回sheetname
/// Table：User.BDPEXConfig
/// Input：tablename
/// Other: w ##class(web.DHCBL.BDP.BDPDataExport).GetTableDesc("CT_Province")
ClassMethod GetTableDesc(tablename) As %String
{
	q:tablename="" ""
	s tabledesc=$o(^User.BDPEXConfigI("TableNameDescIndex",tablename,0))
	s tabledesc=$tr(tabledesc,"[","-") //2021-03-22 不能包含：\/?[]{}*等符号
	s tabledesc=$tr(tabledesc,"]","")  
	s tabledesc=$tr(tabledesc,"/","")
	s tabledesc=$tr(tabledesc,"\","")
	s tabledesc=$tr(tabledesc,":","")
	s tabledesc=$tr(tabledesc,"?","")
	s tabledesc=$tr(tabledesc,"*","")
	q tabledesc
}

/// Creator：chenying
/// CreatDate: 2016-3-29
/// Description：获取总共数据条数
/// Table：User.BDPEXConfig
/// Input：tablename
/// Other: w ##class(web.DHCBL.BDP.BDPDataExport).GetDataCount("PHC_DrgMastNew")
ClassMethod GetDataCount(tablename) As %String
{
	n (tablename,%session)
	
	s mySysID =$s($d(%session):%session.%Id(),1:$j)
	q:tablename="" ""
	
	s EImenuID=$o(^User.BDPEIMenuI("UniqueCodeIndex"," "_$zcvt(tablename,"U"),0))
	s LinkTableDr=$LISTGET($G(^User.BDPEIMenuD(EImenuID)),13)
	S tableListName=""
	if LinkTableDr'="" s tableListName=$LISTGET($G(^User.BDPTableListD(LinkTableDr)),8)   //获取导入导出菜单的表结构登记指针对应的代码
	if tableListName="" s tableListName=tablename
	
	s EXCID=$o(^User.BDPEXConfigI("UniqueTableName"," "_$zcvt(tablename,"U"),0))
	q:EXCID="" ""
	s EXCXGlobal=$lg($g(^User.BDPEXConfigD(EXCID)),5)
	s EXCIsChildTable=$LISTGET($G(^User.BDPEXConfigD(EXCID)),8)
	s DataCount=0
	k ^TMPEXCELEXPORT(mySysID,tablename)
	///2020-06-29 开启医院级授权，导出时，只导出本人医院级授权 所能看到医院的相关的数据
	
	s myobj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCBL.BDP.BDPConfig"_"||"_"GetConfigValue")
    i $IsObject(myobj)
    {
        s myobj=""
        s HospAutflag = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut")  //获取平台配置是否开启医院级别授权
    }
    else
    {
	    s HospAutflag = "N"
    }
    
    s myobj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCBL.Authorize.BDPHospitalAut"_"||"_"GetHospAutFlag")
    i $IsObject(myobj)
    {
        s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
    }
    else
    {
	    s AuHospStr="off"
    }
    s myobj=""
        
	
	if (EXCIsChildTable="Y")  ///子表特殊处理父表xstr
	{
		if (tablename="PAC_Bed") ///床位
		{
			s ParRef=0
			for
			{
				s ParRef=$o(^PAWARD(ParRef)) q:((ParRef="")||(ParRef'>0))
				if (HospAutflag="Y")&&(AuHospStr'="off")&&(AuHospStr'=1)
				{
					s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("PAC_Ward",ParRef)
					continue:showflag="N"
				}
				//床位表
				if ($d(^PAWARD(0,"Sequence"))>0)
				{
					s Sequence=0,flag0=0
					for
					{
						s Sequence=$o(^PAWARD(0,"Sequence",ParRef,Sequence))
						q:flag0=1
						if (Sequence="")	//先查询有序号的数据(0节点之后)，再查询没有序号(0节点)的数据
						{
							s flag0=1
							s Sequence=0
						}
						s BEDChildsub=0
						for
						{
							s BEDChildsub=$o(^PAWARD(0,"Sequence",ParRef,Sequence,BEDChildsub)) q:BEDChildsub=""
							s BEDRowID=ParRef_"||"_BEDChildsub
							s DataCount=DataCount+1
							s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=ParRef_"#"_BEDChildsub
						}
					}
				}
				else
				{
					s BEDChildsub=0
					for
					{
						s BEDChildsub=$o(^PAWARD(ParRef,"BED",BEDChildsub)) q:BEDChildsub=""
						s DataCount=DataCount+1
						s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=ParRef_"#"_BEDChildsub
					}
				}
				
				//房间分配（等候区）
				s Childsub=0
				for
				{
					s Childsub=$o(^PAWARD(ParRef,"ROOM",Childsub)) q:Childsub=""
					s DataCount=DataCount+1
					s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=ParRef_"#"_"#"_Childsub
				}
			}
		}
		else
		{
			
			s EXCParRefGlobal=$LISTGET($G(^User.BDPEXConfigD(EXCID)),9)
			s xrowidstr="s xrowid="_EXCXGlobal	
			s xparrefstr="s xparref="_EXCParRefGlobal
			s xparref=0		
			for
			{		
				x xparrefstr  q:((xparref="")||(xparref'>0))
				if (HospAutflag="Y")&&(AuHospStr'="off")&&(AuHospStr'=1)
				{
					if (tablename="ARC_BillSub") ///账单分类
					{
						s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("ARC_BillGrp",xparref)
						continue:showflag="N"
					}
					if (tablename="ARC_ItmRecLoc") //医嘱项接收科室
					{
						s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("ARC_ItmMast",xparref_"||1")
						continue:showflag="N"
					}
					if (tablename="SS_UserOtherLogonLoc") //用户其他登录科室
					{
						s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("SS_User",xparref)
						continue:showflag="N"
					}
					//?
					if (tablename="OEC_OrdCatRecLoc") //医嘱大类接收科室
					{
						s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("OEC_OrderCategory",xparref)
						continue:showflag="N"
					}
					if (tablename="ARC_ItemCatRecLoc") //医嘱子分类接收科室
					{
						s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("ARC_ItemCat",xparref)
						continue:showflag="N"
					}
					if (tablename="ARC_ItmRecLoc") //用法接收科室
					{	
						///?
					}
				}
				s xrowid=0 			
				for 
				{
					x xrowidstr  q:((xrowid="")||(xrowid'>0))	
					if (tablename="ARC_BillSub") ///账单分类
					{
						
						if (HospAutflag="Y")&&(AuHospStr'="off")&&(AuHospStr'=1)
						{
							s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("ARC_BillSub",xparref_"||"_xrowid)
							continue:showflag="N"
						}
					}		
					s DataCount=DataCount+1
					s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=xparref_"&#"_xrowid
				}
			}
		}
	}
	else
	{
		///update2019-03-10
		if (tablename["ARC_ItmMast")  //检查检验治疗
		{
			s subscript=0
			for
			{
				s subscript=$o(^ARCIM(subscript))   q:subscript=""  
				CONTINUE:$D(^INCI(0,"ARCIM_DR",subscript))>0 //20190823 过滤掉关联了库存项的医嘱项
				s version=0
				for 
				{
					s version=$o(^ARCIM(subscript,version))  q:version="" 
					continue:$p($g(^ARCIM(subscript,version,1)),"^",1)=""  //过滤空数据
					//s ARCIMEffDateTo=$p($g(^ARCIM(subscript,version,7)),"^",1)              ;结束日期
					//CONTINUE:(ARCIMEffDateTo'="")&&(ARCIMEffDateTo<+$H)
					if (HospAutflag="Y")&&(AuHospStr'="off")&&(AuHospStr'=1)
					{
						s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("ARC_ItmMast",subscript_"||"_version)
						continue:showflag="N"
					}
					s ARCIMItemCatDR=$p($g(^ARCIM(subscript,version,1)),"^",10)
					if ARCIMItemCatDR'=""
					{
						s ARCICOrderType=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",7)
						if (ARCICOrderType'="R")  //&&(ARCICOrderType'="M")
						{
							s OLTARCIMDR=subscript_"||"_version
							if ($d(^DHCOLT(0,"ARTTA",OLTARCIMDR))>0)
							{
								///导出收费项目
								s OLTTariffDR=0
								for
								{
									s OLTTariffDR=$o(^DHCOLT(0,"ARTTA",OLTARCIMDR,OLTTariffDR)) q:OLTTariffDR=""   
									s OLTStartDate=0
									for
									{
										s OLTStartDate=$o(^DHCOLT(0,"ARTTA",OLTARCIMDR,OLTTariffDR,OLTStartDate)) q:OLTStartDate=""
										s OLTRowId=0
										for
										{
											s OLTRowId=$o(^DHCOLT(0,"ARTTA",OLTARCIMDR,OLTTariffDR,OLTStartDate,OLTRowId)) q:OLTRowId=""
											//s OLTEndDate=$p($g(^DHCOLT(OLTRowId)),"^",5)
											//CONTINUE:(OLTEndDate'="")&&(OLTEndDate<+$H)
											s DataCount=DataCount+1
											s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=subscript_"||"_version_"#"_OLTTariffDR_"#"_OLTRowId
										}
									}
								}
							}
							else
							{
								///导出医嘱项目
								s DataCount=DataCount+1
								s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=subscript_"||"_version
							}	
						}
					}	
				}
			}
		}
		elseif (tablename="ARCItmMast")  //所有医嘱项 2019-02-16
		{
			s subscript=0
			for
			{
				s subscript=$o(^ARCIM(subscript))   q:subscript=""  
				s version=0
				for 
				{
					s version=$o(^ARCIM(subscript,version))  q:version="" 
					continue:$p($g(^ARCIM(subscript,version,1)),"^",1)=""  //过滤空数据
					if HospAutflag="Y"
					{
						s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("ARC_ItmMast",subscript_"||"_version)
						continue:showflag="N"
					}
					s DataCount=DataCount+1
					s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=subscript_"||"_version
						
				}
			}
		}
		elseif (tablename="PHC_DrgMast")  //药品 医嘱子分类类型为R(Drug)的医嘱项
		{
			s INCIRowId=0
			for
			{
				s INCIRowId=$o(^INCI(INCIRowId)) q:((INCIRowId="")||(INCIRowId'>0))
				continue:$p($g(^INCI(INCIRowId,1)),"^",1)=""  //过滤空数据
				S INCIOriginalARCIMDR=$P($G(^INCI(INCIRowId,1)),"^",3)
				if INCIOriginalARCIMDR'=""
				{
					s ARCIMSubscript=$p(INCIOriginalARCIMDR,"||",1)
					s ARCIMVersion=$p(INCIOriginalARCIMDR,"||",2)
					continue:((ARCIMSubscript="")||(ARCIMVersion=""))
					//s ARCIMEffDateTo=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",1)              ;结束日期
					//CONTINUE:(ARCIMEffDateTo'="")&&(ARCIMEffDateTo<+$H)
					if (HospAutflag="Y")&&(AuHospStr'="off")&&(AuHospStr'=1)
					{
						s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("ARC_ItmMast",ARCIMSubscript_"||"_ARCIMVersion)
						continue:showflag="N"
					}
					s ARCIMPHCDFDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",12)
					continue:ARCIMPHCDFDR=""
					s ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)
					if ARCIMItemCatDR'=""
					{
						s ARCICOrderType=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",7)
						if (ARCICOrderType="R")
						{
							if ($d(^DHCOLT(0,"ARTTA",INCIOriginalARCIMDR))>0)
							{
								///导出收费项目
								s TARIRowId=0
								for
								{
									s TARIRowId=$o(^DHCOLT(0,"ARTTA",INCIOriginalARCIMDR,TARIRowId)) q:TARIRowId=""   
									s OLTStartDate=0
									for
									{
										s OLTStartDate=$o(^DHCOLT(0,"ARTTA",INCIOriginalARCIMDR,TARIRowId,OLTStartDate)) q:OLTStartDate=""
										s OLTRowId=0
										for
										{
											s OLTRowId=$o(^DHCOLT(0,"ARTTA",INCIOriginalARCIMDR,TARIRowId,OLTStartDate,OLTRowId)) q:OLTRowId=""
											
											//s OLTEndDate=$p($g(^DHCOLT(OLTRowId)),"^",5)
											//CONTINUE:(OLTEndDate'="")&&(OLTEndDate<+$H)
											s DataCount=DataCount+1
											///库存项id#医嘱项id#收费项id#医嘱与收费项关联id#药学DrgFormid
											s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=INCIRowId_"#"_INCIOriginalARCIMDR_"#"_TARIRowId_"#"_OLTRowId_"#"_ARCIMPHCDFDR
										}
									}
								}
							}
							else
							{
								s DataCount=DataCount+1
								s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=INCIRowId_"#"_INCIOriginalARCIMDR_"###"_ARCIMPHCDFDR
							}
						
						}
					}	
				}
			}
		}
		elseif (tablename="PHC_DrgMastNew")  //药品(新医嘱模式) 的医嘱项
		{
			
			s INCIRowId=0
			for
			{
				s INCIRowId=$o(^INCI(INCIRowId)) q:((INCIRowId="")||(INCIRowId'>0))
				continue:$p($g(^INCI(INCIRowId,1)),"^",1)=""  //过滤空数据
				S INCIOriginalARCIMDR=$P($G(^INCI(INCIRowId,1)),"^",3)
				if INCIOriginalARCIMDR'=""
				{
					s ARCIMSubscript=$p(INCIOriginalARCIMDR,"||",1)
					s ARCIMVersion=$p(INCIOriginalARCIMDR,"||",2)
					continue:((ARCIMSubscript="")||(ARCIMVersion=""))
					if (HospAutflag="Y")&&(AuHospStr'="off")&&(AuHospStr'=1)
					{
						s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("ARC_ItmMast",INCIOriginalARCIMDR)
						continue:showflag="N"
					}
					s ARCIMPHCDFDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",12)
					continue:ARCIMPHCDFDR=""
					s ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)
					//s ARCICOrderType=""
					//s:ARCIMItemCatDR'="" ARCICOrderType=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",7)
					//continue:(ARCICOrderType'="R")
					if ($d(^DHCINCTARi("INCI",INCIRowId))>0)
					{
						//User.DHCIncTarRela
						s INCTRRowId=0
						for
						{
							s INCTRRowId=$o(^DHCINCTARi("INCI",INCIRowId,INCTRRowId)) q:INCTRRowId=""   
							s TARIRowId=$p($g(^DHCINCTAR(INCTRRowId)),"^",2)
							continue:TARIRowId=""
							s DataCount=DataCount+1
							///库存项id#医嘱项id#收费项id#库存项与收费项关联id#药学DrgFormid
							s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=INCIRowId_"#"_INCIOriginalARCIMDR_"#"_TARIRowId_"#"_INCTRRowId_"#"_ARCIMPHCDFDR
								
						}			
					}
				}
			}
		}
		elseif (tablename="INC_Itm")  //材料物资 医嘱子分类类型为M(Material)的医嘱项
		{
			s INCIRowId=0
			for
			{
				s INCIRowId=$o(^INCI(INCIRowId)) q:((INCIRowId="")||(INCIRowId'>0))
				continue:$p($g(^INCI(INCIRowId,1)),"^",1)=""  //过滤空数据 2020-03-13
				S INCIOriginalARCIMDR=$P($G(^INCI(INCIRowId,1)),"^",3)
				if INCIOriginalARCIMDR'=""
				{
					s ARCIMSubscript=$p(INCIOriginalARCIMDR,"||",1)
					s ARCIMVersion=$p(INCIOriginalARCIMDR,"||",2)
					continue:((ARCIMSubscript="")||(ARCIMVersion=""))
					if (HospAutflag="Y")&&(AuHospStr'="off")&&(AuHospStr'=1)
					{
						s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("ARC_ItmMast",INCIOriginalARCIMDR)
						continue:showflag="N"
					}
					//s ARCIMEffDateTo=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",1)              ;结束日期
					//CONTINUE:(ARCIMEffDateTo'="")&&(ARCIMEffDateTo<+$H)
					s ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)
					if ARCIMItemCatDR'=""
					{
						s ARCICOrderType=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",7)
						if (ARCICOrderType'="R")  //20190823update 改成判断类型不是药品的库存项(因为老项目里没有M类型)
						{
							if ($d(^DHCOLT(0,"ARTTA",INCIOriginalARCIMDR))>0)
							{
								///导出收费项目
								s TARIRowId=0
								for
								{
									s TARIRowId=$o(^DHCOLT(0,"ARTTA",INCIOriginalARCIMDR,TARIRowId)) q:TARIRowId=""   
									s OLTStartDate=0
									for
									{
										s OLTStartDate=$o(^DHCOLT(0,"ARTTA",INCIOriginalARCIMDR,TARIRowId,OLTStartDate)) q:OLTStartDate=""
										s OLTRowId=0
										for
										{
											s OLTRowId=$o(^DHCOLT(0,"ARTTA",INCIOriginalARCIMDR,TARIRowId,OLTStartDate,OLTRowId)) q:OLTRowId=""
											//s OLTEndDate=$p($g(^DHCOLT(OLTRowId)),"^",5)
											//CONTINUE:(OLTEndDate'="")&&(OLTEndDate<+$H)
											s DataCount=DataCount+1
											///库存项id#医嘱项id#收费项id#医嘱与收费项关联id
											s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=INCIRowId_"#"_INCIOriginalARCIMDR_"#"_TARIRowId_"#"_OLTRowId
										}
									}
								}
							}
							else
							{
								s DataCount=DataCount+1
								s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=INCIRowId_"#"_INCIOriginalARCIMDR_"##"
							}
						}
					}	
				}
				else
				{
					if (HospAutflag="Y")&&(AuHospStr'="off")&&(AuHospStr'=1)
					{
						s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("INC_Itm",INCIRowId)
						continue:showflag="N"
					}
					s DataCount=DataCount+1
					s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=INCIRowId
				}
			}
		}
		elseif (tablename="SS_User")  //用户医护人员
		{
			K ^TMPSSUSRCARE
			s SSUSRRowId=0
			for  
			{	
				s SSUSRRowId=$o(^SSU("SSUSR",SSUSRRowId)) q:SSUSRRowId="" 
				if (HospAutflag="Y")&&(AuHospStr'="off")&&(AuHospStr'=1)
				{
					s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("SS_User",SSUSRRowId)
					continue:showflag="N"
				}
				//s SSUSRActive=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",19)      //是否激活
				//s SSUSRDateTo=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",97)  //截止日期
				//continue:SSUSRActive'="Y"
				//continue:(SSUSRDateTo'="")&&(SSUSRDateTo<+$h)
				s SSUSRCareProvDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",14)      //医护人员DR
				s DataCount=DataCount+1
				s Type=""
				if SSUSRCareProvDR'=""
				{
					s Type="UC"
					s ^TMPSSUSRCARE(SSUSRCareProvDR)=SSUSRRowId
				}
				if SSUSRCareProvDR="" s Type="U"
				s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=SSUSRRowId_"#"_SSUSRCareProvDR_"#"_Type
			}
			
			s CTPCPRowId1=0
			for  
			{				
				s CTPCPRowId1=$o(^CTPCP(CTPCPRowId1)) q:((CTPCPRowId1="")||(CTPCPRowId1'>0))
				continue:$d(^CTPCP(CTPCPRowId1,1))=0
				if (HospAutflag="Y")&&(AuHospStr'="off")&&(AuHospStr'=1)
				{
					s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("CT_CareProv",CTPCPRowId1)
					continue:showflag="N"
				}
				//s CTPCPActiveFlag=$p($g(^CTPCP(CTPCPRowId1,1)),"^",9)      //是否激活
				//s CTPCPDateActiveTo=$p($g(^CTPCP(CTPCPRowId1,2)),"^",15)     //截止时间
				//continue:CTPCPActiveFlag'="Y"
				//continue:(CTPCPDateActiveTo'="")&&(CTPCPDateActiveTo<+$h)
				if $d(^TMPSSUSRCARE(CTPCPRowId1))=0
				{
					s Type="C"
					s DataCount=DataCount+1
					s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=""_"#"_CTPCPRowId1_"#"_Type
				}
			}
			k ^TMPSSUSRCARE
		}
		elseif (tablename="ARC_OrdSets")  //医嘱套 2019-04-04
		{
			s ARCOSRowId=0
			for
			{
				s ARCOSRowId=$o(^ARCOS(ARCOSRowId))   q:ARCOSRowId=""
				s ARCOSCode=$p($g(^ARCOS(ARCOSRowId)),"^",1)
				if (HospAutflag="Y")&&(AuHospStr'="off")&&(AuHospStr'=1)
				{
					s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("ARC_OrdSets",ARCOSRowId)
					continue:showflag="N"
				}
				//continue:$p($g(^ARCOS(ARCOSRowId)),"^",16)<+$h   //过滤医嘱套
				S DATEChildSub=0
				for
				{
					s DATEChildSub=$o(^ARCOS(ARCOSRowId,"DATE",DATEChildSub))   q:DATEChildSub=""
					S ITMChildSub=0
					for
					{
						s ITMChildSub=$o(^ARCOS(ARCOSRowId,"DATE",DATEChildSub,"ITM",ITMChildSub))   q:ITMChildSub=""
						s ITMARCIMDR=$p($g(^ARCOS(ARCOSRowId,"DATE",DATEChildSub,"ITM",ITMChildSub)),"^",1)
						continue:ITMARCIMDR=""
						//s ARCIMEffDate=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",13)                 ;开始日期
						//s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,"Z",1)
						//s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,",",1)
						//continue:ARCIMEffDate'=65179
						//continue:$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",1)'<+$h
						if ($g(^TMPARCOS("EndFlag"))=1) //只导废除医嘱对应的医嘱套-医嘱项
						{
							continue:$d(^TMPBDPEndData("ARCItmMast",ITMARCIMDR))=0
						}
						
						s DataCount=DataCount+1
						s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=ARCOSRowId_"#"_DATEChildSub_"#"_ITMChildSub_"#"_"TIM"
												
					}
					if ($g(^TMPARCOS("EndFlag"))'=1) //只导废除医嘱对应的医嘱套-医嘱项
					{
						S OSChildSub=0
						for
						{
							s OSChildSub=$o(^ARCOS(ARCOSRowId,"DATE",DATEChildSub,"OS",OSChildSub))   q:OSChildSub=""
							s OSOrderSetDR=$p($g(^ARCOS(ARCOSRowId,"DATE",DATEChildSub,"OS",OSChildSub)),"^",1)
							continue:OSOrderSetDR=""
							//continue:$p($g(^ARCOS(OSOrderSetDR)),"^",16)<+$h   //过滤医嘱套
							s DataCount=DataCount+1
							s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=ARCOSRowId_"#"_DATEChildSub_"#"_OSChildSub_"#"_"OS"
													
						}	
					}
				}
			}
		}
		elseif (tablename="RB_ResEffDateSession")  //排班模板 20190912
		{
			s RESRowId=0
			for
			{
				s RESRowId=$o(^RB("RES",RESRowId))  q:RESRowId=""
				if (HospAutflag="Y")&&(AuHospStr'="off")&&(AuHospStr'=1)
				{
					s RESCTLOCDR=$p($g(^RB("RES",RESRowId)),"^",1)       //科室ID
					s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("CT_Loc",RESCTLOCDR)
					continue:showflag="N"
				}
				
				s RESEQDR=$p($g(^RB("RES",RESRowId)),"^",3)
				continue:RESEQDR'=""
				S DATEChildSub=0
				for
				{
					s DATEChildSub=$o(^RB("RES",RESRowId,"DATE",DATEChildSub)) q:DATEChildSub=""
					S SESSChildsub=0
					for
					{
						s SESSChildsub=$o(^RB("RES",RESRowId,"DATE",DATEChildSub,"SESS",SESSChildsub))   q:SESSChildsub=""
						s DataCount=DataCount+1
						s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=RESRowId_"#"_DATEChildSub_"#"_SESSChildsub
												
					}
					
				}
			}
		}
		elseif (tablename="OrderCategory")  //医嘱分类 20191023
		{
			s ARCICRowId=0
			for
			{
				s ARCICRowId=$o(^ARC("IC",ARCICRowId))  q:ARCICRowId=""
				s ARCICOrdCatDR = $p($g(^ARC("IC",ARCICRowId)),"^",8)
				if (HospAutflag="Y")&&(AuHospStr'="off")&&(AuHospStr'=1)
				{
					s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag(tableListName,ARCICRowId)
					continue:showflag="N"
				}
				s DataCount=DataCount+1
				s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=ARCICRowId_"#"_ARCICOrdCatDR
				
			}
		}
		elseif (tablename="ChargeCategory")  //费用分类 20191024
		{
			if (HospAutflag="Y") //开启医院级授权后
			{
				s AuStr=##class(web.DHCBL.Authorize.CTHospital).DHCGetDataByDefaultSession()
				s AuFlag=0
				if AuStr="" s AuFlag=1 //判断是否有授权,如果没有则全部显示
				s HOSPRowId=0
				for  
				{
					s HOSPRowId=$o(^CT("HOSP",HOSPRowId)) q:HOSPRowId=""
					s strRowId = "{ID:"_HOSPRowId_"}"
					i ((AuStr[strRowId)||(AuFlag=1))&((AuHospStr="off")||(AuHospStr[strRowId)||(AuHospStr=1)) ;用来筛选授权数据，如果未授权情况下筛选无效
					{
						s HOSPDateTo=$p($g(^CT("HOSP",HOSPRowId)),"^",10)
						continue:(HOSPDateTo'="")&&(HOSPDateTo<+$h) 
						//收费子类
						s RowId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("DHC_TarSubCate",HOSPRowId)  //获取到医院对应的默认医院（判断例外和医院组）
						if (RowId>0) s HospArray(RowId)=""    
						//住院子类
						s RowId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("DHC_TarInpatCate",HOSPRowId)  //获取到医院对应的默认医院（判断例外和医院组）
						if (RowId>0) s HospArray(RowId)=""    
						//门诊子类
						s RowId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("DHC_TarOutpatCate",HOSPRowId)  //获取到医院对应的默认医院（判断例外和医院组）
						if (RowId>0) s HospArray(RowId)=""    
						//核算子类
						s RowId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("DHC_TarEMCCate",HOSPRowId)  //获取到医院对应的默认医院（判断例外和医院组）
						if (RowId>0) s HospArray(RowId)=""  
						//会计子类
						s RowId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("DHC_TarAcctCate",HOSPRowId)  //获取到医院对应的默认医院（判断例外和医院组）
						if (RowId>0) s HospArray(RowId)=""  
						//病案子类
						s RowId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("DHC_TarMRCate",HOSPRowId)  //获取到医院对应的默认医院（判断例外和医院组）
						if (RowId>0) s HospArray(RowId)=""  
						//新病案首页子类
						s RowId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("DHC_TarMCCateNew",HOSPRowId)  //获取到医院对应的默认医院（判断例外和医院组）
						if (RowId>0) s HospArray(RowId)=""  

					}
				}

				s HOSPRowId=0
				for  
				{	
					s HOSPRowId=$o(HospArray(HOSPRowId)) q:HOSPRowId=""
					s StartCount=+($o(^TMPEXCELEXPORT(mySysID,tablename,""),-1))
					s DataCount=StartCount
					s TARSCRowId=0
					for
					{ 
						s TARSCRowId=$o(^DHCTarC("SC",TARSCRowId))  q:TARSCRowId=""  
						CONTINUE:(##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarSubCate",TARSCRowId,HOSPRowId))="N"
						s DataCount=DataCount+1
						s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",1)=HOSPRowId
						s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",2)=TARSCRowId  

					}
					s DataCount=StartCount
					s TARICRowId=0
					for
					{ 
						s TARICRowId=$o(^DHCTarC("IC",TARICRowId)) q:TARICRowId=""
						CONTINUE:(##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarInpatCate",TARICRowId,HOSPRowId))="N"
						s DataCount=DataCount+1
						s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",1)=HOSPRowId
						s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",3)=TARICRowId
					} 


					s DataCount=StartCount
					s TAROCRowId=0
					for
					{ 
						s TAROCRowId=$o(^DHCTarC("OC",TAROCRowId))  q:TAROCRowId=""
						CONTINUE:(##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarOutpatCate",TAROCRowId,HOSPRowId))="N"
						s DataCount=DataCount+1
						s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",1)=HOSPRowId
						s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",4)=TAROCRowId
					}

					s DataCount=StartCount
					s TARECRowId=0
					for
					{ 
						s TARECRowId=$o(^DHCTarC("EC",TARECRowId))  q:TARECRowId=""
						CONTINUE:(##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarEMCCate",TARECRowId,HOSPRowId))="N"
						s DataCount=DataCount+1
						s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",1)=HOSPRowId
						s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",5)=TARECRowId
					}   
					s DataCount=StartCount
					s TARACRowId=0
					for
					{ 
						s TARACRowId=$o(^DHCTarC("AC",TARACRowId))  q:TARACRowId=""
						CONTINUE:(##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarAcctCate",TARACRowId,HOSPRowId))="N"
						s DataCount=DataCount+1
						s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",1)=HOSPRowId
						s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",6)=TARACRowId
					}   

					s DataCount=StartCount
					s TARMCRowId=0
					for
					{ 
						s TARMCRowId=$o(^DHCTarC("MC",TARMCRowId))  q:TARMCRowId=""
						CONTINUE:(##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarMRCate",TARMCRowId,HOSPRowId))="N"
						s DataCount=DataCount+1
						s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",1)=HOSPRowId
						s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",7)=TARMCRowId
					}  
					s DataCount=StartCount
					s NTARMCRowId=0
					for
					{ 
						s NTARMCRowId=$o(^DHCTarC("MCNew",NTARMCRowId))  q:NTARMCRowId=""
						CONTINUE:(##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarMCCateNew",NTARMCRowId,HOSPRowId))="N"
						s DataCount=DataCount+1
						s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",1)=HOSPRowId
						s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",8)=NTARMCRowId
					} 
					s DataCount=+($o(^TMPEXCELEXPORT(mySysID,tablename,""),-1))
				}  
	        }
	        else  //没有开启医院级授权时，适用于早版本项目
	        {
		        s StartCount=0
				s DataCount=StartCount
				s TARSCRowId=0
				for
				{ 
					s TARSCRowId=$o(^DHCTarC("SC",TARSCRowId))  q:TARSCRowId=""  
					s DataCount=DataCount+1
					s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",2)=TARSCRowId  
					
				}
				s DataCount=StartCount
				s TARICRowId=0
				for
				{ 
					s TARICRowId=$o(^DHCTarC("IC",TARICRowId)) q:TARICRowId=""
					s DataCount=DataCount+1
					s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",3)=TARICRowId
				} 
				
				
				s DataCount=StartCount
				s TAROCRowId=0
				for
				{ 
					s TAROCRowId=$o(^DHCTarC("OC",TAROCRowId))  q:TAROCRowId=""
					s DataCount=DataCount+1
					s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",4)=TAROCRowId
				}
				
				s DataCount=StartCount
				s TARECRowId=0
				for
				{ 
					s TARECRowId=$o(^DHCTarC("EC",TARECRowId))  q:TARECRowId=""
					s DataCount=DataCount+1
					s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",5)=TARECRowId
				}   
				s DataCount=StartCount
				s TARACRowId=0
				for
				{ 
					s TARACRowId=$o(^DHCTarC("AC",TARACRowId))  q:TARACRowId=""
					s DataCount=DataCount+1
					s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",6)=TARACRowId
				}   
				
				s DataCount=StartCount
				s TARMCRowId=0
				for
				{ 
					s TARMCRowId=$o(^DHCTarC("MC",TARMCRowId))  q:TARMCRowId=""
					s DataCount=DataCount+1
					s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",7)=TARMCRowId
				}  
				s DataCount=StartCount
				s NTARMCRowId=0
				for
				{ 
					s NTARMCRowId=$o(^DHCTarC("MCNew",NTARMCRowId))  q:NTARMCRowId=""
					s DataCount=DataCount+1
					s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",8)=NTARMCRowId
				} 
				s DataCount=+($o(^TMPEXCELEXPORT(mySysID,tablename,""),-1))
	        }
		}
		elseif (tablename="PAC_Bed") ///床位
		{
			s ParRef=0
			for
			{
				s ParRef=$o(^PAWARD(ParRef)) q:((ParRef="")||(ParRef'>0))
				if (HospAutflag="Y")&&(AuHospStr'="off")&&(AuHospStr'=1)
				{
					s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("PAC_Ward",ParRef)
					continue:showflag="N"
				}
				//床位表
				if ($d(^PAWARD(0,"Sequence"))>0)
				{
					s Sequence=0,flag0=0
					for
					{
						s Sequence=$o(^PAWARD(0,"Sequence",ParRef,Sequence))
						q:flag0=1
						if (Sequence="")	//先查询有序号的数据(0节点之后)，再查询没有序号(0节点)的数据
						{
							s flag0=1
							s Sequence=0
						}
						s BEDChildsub=0
						for
						{
							s BEDChildsub=$o(^PAWARD(0,"Sequence",ParRef,Sequence,BEDChildsub)) q:BEDChildsub=""
							s BEDRowID=ParRef_"||"_BEDChildsub
							s DataCount=DataCount+1
							s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=ParRef_"#"_BEDChildsub
						}
					}
				}
				else
				{
					s BEDChildsub=0
					for
					{
						s BEDChildsub=$o(^PAWARD(ParRef,"BED",BEDChildsub)) q:BEDChildsub=""
						s DataCount=DataCount+1
						s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=ParRef_"#"_BEDChildsub
					}
				}
				
				//房间分配（等候区）
				s Childsub=0
				for
				{
					s Childsub=$o(^PAWARD(ParRef,"ROOM",Childsub)) q:Childsub=""
					s DataCount=DataCount+1
					s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=ParRef_"#"_"#"_Childsub
				}
			}
		}
		elseif (tablename="ARC_ItemExternalCodes")  //检验外部代码  20191024
		{
			s subscript=0
			for
			{
				s subscript=$o(^ARCIM(subscript))   q:subscript=""  
				s version=0
				for 
				{
					s version=$o(^ARCIM(subscript,version))  q:version="" 
					s extsub=0
					for
					{
						s extsub=$o(^ARCIM(subscript,version,"EXT",extsub)) q:extsub=""  d
						continue:$p($g(^ARCIM(subscript,version,1)),"^",1)=""  //过滤空数据
						if (HospAutflag="Y")&&(AuHospStr'="off")&&(AuHospStr'=1)
						{
							s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("ARC_ItmMast",subscript_"||"_version)
							continue:showflag="N"
						}
						s DataCount=DataCount+1
						s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=subscript_"#"_version_"#"_extsub
					}	
				}
			}
		
		}
		elseif (tablename="DHC_CTLoc_MedUnitCareProv")  //医疗单元及关联医护人员  20191024
		{
			
			s CTLOCRowId=0
			for
			{
				s CTLOCRowId=$o(^CTLOC(CTLOCRowId)) q:CTLOCRowId=""
				if (HospAutflag="Y")&&(AuHospStr'="off")&&(AuHospStr'=1)
				{
					s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("CT_Loc",CTLOCRowId)
					continue:showflag="N"
				}
				s CTMUChildsub=0
				for
				{
					s CTMUChildsub=$o(^CTLOC(CTLOCRowId,"MU",CTMUChildsub)) q:CTMUChildsub=""
					s MURowId=CTLOCRowId_"||"_CTMUChildsub
					if $d(^CTLOC(CTLOCRowId,"MU", CTMUChildsub,"CP"))>0
					{
						s MUCPChildsub=0
						for
						{
							s MUCPChildsub=$o(^CTLOC(CTLOCRowId,"MU", CTMUChildsub,"CP",MUCPChildsub)) q:(MUCPChildsub="")  
							s DataCount=DataCount+1
							s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=CTLOCRowId_"#"_CTMUChildsub_"#"_MUCPChildsub
						}	
					}
					else
					{
						
						s DataCount=DataCount+1
						s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=CTLOCRowId_"#"_CTMUChildsub_"#"
						
					}
				}
			}
		
		}
		elseif (tablename="BDP_TableList")	//表结构登记及子表 20200920
		{
			s TBID=0
			for
			{
				s TBID=$o(^User.BDPTableListD(TBID)) q:TBID=""
				if $d(^User.BDPTableListD(TBID,"ChildField"))>0
				{
					s TBChildsub=0
				 	for 
				 	{
					 	s TBChildsub=$o(^User.BDPTableListD(TBID,"ChildField",TBChildsub)) q:TBChildsub=""
					 	s DataCount=DataCount+1
						s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=TBID_"#"_TBChildsub
				 	}
				}
				else
				{
					s DataCount=DataCount+1
					s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=TBID_"#"
				}
			}
		}
		elseif (tablename="DHC_PHCCat")  //药理学分类  20191024
		{
			
			d ##class(web.DHCBL.BDP.BDPDataExport).GetChildPHCC(mySysID,tablename,0)
			s DataCount=$o(^TMPEXCELEXPORT(mySysID,tablename,""),-1)
		}
		elseif (tablename="PHC_Cat")  //药理学分类  20191024
		{
			s PHCCRowId=0
			for
			{
				s PHCCRowId=$o(^PHCC(PHCCRowId)) q:((PHCCRowId="")||(PHCCRowId'>0))   ;此处例外,不是在PHCCRowId为空的情况下quit
				s DataCount=DataCount+1
				s PHCCCode=$p($g(^PHCC(PHCCRowId)),"^",1)
				s PHCCDesc=$p($g(^PHCC(PHCCRowId)),"^",2)
				s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=1_"&%"_PHCCCode_"&%"_PHCCDesc
				s PHCSCChildSub=0 
				for
				{
					s PHCSCChildSub=$o(^PHCC(PHCCRowId,"SC",PHCSCChildSub)) q:PHCSCChildSub=""
					s DataCount=DataCount+1
					s PHCSCCode=$p($g(^PHCC(PHCCRowId,"SC",PHCSCChildSub)),"^",1)
					s PHCSCDesc=$p($g(^PHCC(PHCCRowId,"SC",PHCSCChildSub)),"^",2)
					s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=2_"&%"_PHCSCCode_"&%"_PHCSCDesc
					s MINChildsub=0
					for
					{
						s MINChildsub=$o(^PHCC(PHCCRowId,"SC",PHCSCChildSub,"MIN",MINChildsub)) q:MINChildsub=""
						s DataCount=DataCount+1
						s MINCode=$p($g(^PHCC(PHCCRowId,"SC",PHCSCChildSub,"MIN",MINChildsub)),"^",1)
						s MINDesc=$p($g(^PHCC(PHCCRowId,"SC",PHCSCChildSub,"MIN",MINChildsub)),"^",2)
						s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=3_"&%"_MINCode_"&%"_MINDesc
					}
				}
				
			}
		}
		elseif (tablename="DHC_TarItemPrice")  //收费项价格 2021-08-20
		{
			
			k PriceArray
			s TARIRowId=0
			for
			{
				s TARIRowId=$o(^DHCTARI(TARIRowId)) q:TARIRowId=""
				if $d(^DHCTARI(TARIRowId))=10 CONTINUE
				//过滤掉药品 和物资 
				s SubCate =$p($g(^DHCTARI(TARIRowId)),"^",4) ///收费项目子类
				IF (SubCate'="")
				{
					s Cate=$p($g(^DHCTarC("SC",SubCate)),"^",3) ///收费项目大类 
					s:Cate'="" Cate=$p($g(^DHCTarC("CC",Cate)),"^",2) ///收费项目大类 -描述
					if (Cate["药品")||(Cate["材料")
					{
						continue
					}
				}
				s TPChildSub=""
				for
				{
					s TPChildSub=$o(^DHCTARI(TARIRowId,"P",TPChildSub),-1) q:(TPChildSub=0)||(TPChildSub="")
					s TPPatInsType=$p($g(^DHCTARI(TARIRowId,"P",TPChildSub)),"^",13) //一个费别显示一条价格
					continue:$d(PriceArray(TARIRowId,TPPatInsType))>0
					
					s PriceArray(TARIRowId,TPPatInsType)=""
					s DataCount=DataCount+1
					s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=TARIRowId_"#"_TPChildSub
					
				}
				
			}
		}
		else
		{
			s xrowid=0
			s xrowidstr="s xrowid="_EXCXGlobal
			s n=0
			for 
			{
				x xrowidstr  q:((xrowid="")||(xrowid'>0))
				if (HospAutflag="Y")&&(AuHospStr'="off")&&(AuHospStr'=1)
				{
					if (tablename="DHCBorExaRoom")  //分诊区诊室对照
					{
						s BorDr=$LISTGET($g(^User.DHCBorExaRoomD(xrowid)),5)
						s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("DHCExaBorough",BorDr)
						continue:showflag="N"
					}
					elseif (tablename="DHCExaBorDep")  //分诊区科室对照
					{
						s BordBorDr=$LISTGET($g(^User.DHCExaBorDepD(xrowid)),6)
						s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("DHCExaBorough",BordBorDr)
						continue:showflag="N"
					}
					elseif (tablename="DHCDepMark")  //分诊区号别对照
					{
						s DepmBorDr=$LISTGET($g(^User.DHCDepMarkD(xrowid)),7)
						s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("DHCExaBorough",DepmBorDr)
						continue:showflag="N"
					}
					elseif (tablename="DHCMarkDoc")  //医生号别对照
					{
						s MarkddepDr=$LISTGET($g(^User.DHCMarkDocD(xrowid)),4)
						s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("CT_Loc",MarkddepDr)
						continue:showflag="N"
					}
					elseif (tablename="DHCBorUser")  //操作员诊区对照
					{
						s BorDr=$LISTGET($g(^User.DHCBorUserD(xrowid)),2)
						s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("DHCExaBorough",BorDr)
						continue:showflag="N"
					}
					else
					{
						//科室部门组，科室，安全组，诊断，供应商，厂商，产地，配送商,分诊区
						s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag(tableListName,xrowid)
						continue:showflag="N"	
					}
				}
				if tablename["DHC_TarItem"  //2019-04-24
			    {
			    	if $d(^DHCTARI(xrowid))=10 CONTINUE
			    }
				s DataCount=DataCount+1
				s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=xrowid
			}
		}		
	}
	q DataCount
}

/// Creator：chenying
/// CreatDate: 2020-04-09
/// Description：数据导出完以后，清掉临时global
/// Input：tablename
/// Other: w ##class(web.DHCBL.BDP.BDPDataExport).KillTMPEXCELEXPORTGlobal("CT_Province")
ClassMethod KillTMPEXCELEXPORTGlobal(tablename) As %String
{
	n (tablename,%session)
	s mySysID =$s($d(%session):%session.%Id(),1:$j)
	q:tablename="" ""
	k ^TMPEXCELEXPORT(mySysID,tablename)
	q ""
}

/// Creator：chenying
/// CreatDate: 2016-3-29
/// Description：导出excel 通过表名获取表描述  返回sheetname
/// Table：User.BDPEXConfig
/// Input：tablename
/// Other: w ##class(web.DHCBL.BDP.BDPDataExport).GetFieldDesc("CT_Province")
ClassMethod GetFieldDesc(tablename) As %String
{
	q:tablename="" ""
	s EXCID=$o(^User.BDPEXConfigI("UniqueTableName"," "_$zcvt(tablename,"U"),0))
	q:EXCID="" ""
	s ID=0,fresult=""
	s vcount=0
	for
	{
		s ID=$o(^User.BDPEXConfigD(EXCID,"ChildField",ID)) q:ID=""
		s vcount=vcount+1
		s EXFCFieldDesc=$LISTGET($G(^User.BDPEXConfigD(EXCID,"ChildField",ID)),2)
	    if (fresult'="")||(vcount>1)
		{
			s fresult=fresult_"&%"_EXFCFieldDesc
		}
		else
		{
			s fresult=EXFCFieldDesc
		}
	}
	q fresult
}

/// Other: w ##class(web.DHCBL.BDP.BDPDataExport).GetFieldName("CT_Province")
/// Return:PROVCode&%PROVDesc&%PROVRegionDR&%PROVDateFrom&%PROVDateTo
ClassMethod GetFieldName(tablename) As %String
{
	q:tablename="" ""
	s EXCID=$o(^User.BDPEXConfigI("UniqueTableName"," "_$zcvt(tablename,"U"),0))
	q:EXCID="" ""
	s ID=0,fresult=""
	s vcount=0
	for
	{
		s ID=$o(^User.BDPEXConfigD(EXCID,"ChildField",ID)) q:ID=""
		s vcount=vcount+1
		s EXFCFieldName=$LISTGET($G(^User.BDPEXConfigD(EXCID,"ChildField",ID)),3)
	    if (fresult'="")||(vcount>1)
		{
			s fresult=fresult_"&%"_EXFCFieldName
		}
		else
		{
			s fresult=EXFCFieldName
		}
	}
	q fresult
}

/// Creator：chenying
/// CreatDate: 2016-3-29
/// Description：导出excel 通过表名获取表描述  返回sheetname
/// Table：User.BDPEXConfig
/// Input：tablename
/// Other: w ##class(web.DHCBL.BDP.BDPDataExport).GetFieldValue("PHC_DrgMastNew",1)
///        w ##class(web.DHCBL.BDP.BDPDataExport).GetFieldValue(""MRC_ICDDx"",1)
///        w ##class(web.DHCBL.BDP.BDPDataExport).GetFieldValue("ARC_ItmMast",1)
ClassMethod GetFieldValue(tablename, i) As %String
{
	n (tablename, i,%session)
	s mySysID =$s($d(%session):%session.%Id(),1:$j)
	q:tablename="" ""
	
	s EImenuID=$o(^User.BDPEIMenuI("UniqueCodeIndex"," "_$zcvt(tablename,"U"),0))
	s LinkTableDr=$LISTGET($G(^User.BDPEIMenuD(EImenuID)),13)
	S tableListName=""
	if LinkTableDr'="" s tableListName=$LISTGET($G(^User.BDPTableListD(LinkTableDr)),8)  //获取导入导出菜单的表结构登记指针对应的代码
	if tableListName="" s tableListName=tablename
	
	
	s EXCID=$o(^User.BDPEXConfigI("UniqueTableName"," "_$zcvt(tablename,"U"),0))
	q:EXCID="" ""
	s EXCIsChildTable=$LISTGET($G(^User.BDPEXConfigD(EXCID)),8)
	s n=0
	if (EXCIsChildTable="Y")  //子表特殊处理父表xstr
	{
		if (tablename="PAC_Bed") //病区id#床位id#等候区id
		{
			s IDStr=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			s xparref=$p(IDStr,"#",1)
			s xrowid=$p(IDStr,"#",2)
			s RoomDR="",DateFrom="",DateTo="",FloorId=""
			s:xrowid'="" RoomDR=$p($g(^PAWARD(xparref,"BED",xrowid)),"^",3)  //床位 房间指针
			s:xrowid'="" RoomDR=$p($g(^PAWARD(xparref,"BED",xrowid)),"^",3)  //床位 房间指针
			s RoomChildSub=$p(IDStr,"#",3)
			s:RoomChildSub'="" RoomDR=$p($g(^PAWARD(xparref,"ROOM",RoomChildSub)),"^",1)  //等候区 房间指针
			s:xrowid'="" DateFrom=$p($g(^PAWARD(xparref,"BED",xrowid)),"^",21)  //开始日期（床位）
			s:xrowid'="" DateTo=$p($g(^PAWARD(xparref,"BED",xrowid)),"^",22)  //结束日期（床位）
			s:RoomChildSub'="" DateFrom=$p($g(^PAWARD(xparref,"ROOM",RoomChildSub)),"^",7)  //开始日期（等候区）
			s:RoomChildSub'="" DateTo=$p($g(^PAWARD(xparref,"ROOM",RoomChildSub)),"^",8)  //结束日期（等候区）
		}
		else
		{
			s xparref=$p($g(^TMPEXCELEXPORT(mySysID,tablename,i)),"&#",1)
			s xrowid=$p($g(^TMPEXCELEXPORT(mySysID,tablename,i)),"&#",2)
		}
	}
	else
	{
		//update2019-03-10
		if (tablename["ARC_ItmMast") //医嘱项id#收费项id#关联id
		{
			s IDStr=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			s ARCIMRowId=$p(IDStr,"#",1)
			s ARCIMSubscript=$p($p(IDStr,"#",1),"||",1)
			s ARCIMVersion=$p($p(IDStr,"#",1),"||",2)
			s TARIRowId=$p(IDStr,"#",2)
			s OLTRowId=$p(IDStr,"#",3)
		}
		elseif (tablename="ARCItmMast")  //医嘱项id (所有医嘱项） //2019-02-16
		{
			s IDStr=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			s ARCIMRowId=$p(IDStr,"#",1)
			s ARCIMSubscript=$p($p(IDStr,"#",1),"||",1)
			s ARCIMVersion=$p($p(IDStr,"#",1),"||",2)
		}
		elseif (tablename="PHC_DrgMast")  ///库存项id#医嘱项id#收费项id#医嘱与收费项关联id#药学形态id
		{
			s IDStr=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			s INCIRowId=$p(IDStr,"#",1)
			s ARCIMRowId=$p(IDStr,"#",2)
			s ARCIMSubscript=$p(ARCIMRowId,"||",1)
			s ARCIMVersion=$p(ARCIMRowId,"||",2)
			s TARIRowId=$p(IDStr,"#",3)
			s OLTRowId=$p(IDStr,"#",4)
			s PHCDFRowId=$p(IDStr,"#",5)
			s PHCDRowId=$p(PHCDFRowId,"||",1)
			s PHCDFChildSub=$p(PHCDFRowId,"||",2)
			S INFORowId=""
			S:INCIRowId'="" INFORowId=$o(^DHCITMINFO(0,"INCI",INCIRowId,0))
			
		}
		elseif (tablename="PHC_DrgMastNew")  ///库存项id#医嘱项id#收费项id#库存与收费项关联id#药学形态id  2019-02-16
		{
			s IDStr=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			s INCIRowId=$p(IDStr,"#",1)
			s ARCIMRowId=$p(IDStr,"#",2)
			s ARCIMSubscript=$p(ARCIMRowId,"||",1)
			s ARCIMVersion=$p(ARCIMRowId,"||",2)
			s TARIRowId=$p(IDStr,"#",3)
			s INCTRRowId=$p(IDStr,"#",4)
			s PHCDFRowId=$p(IDStr,"#",5)
			s PHCDRowId=$p(PHCDFRowId,"||",1)
			s PHCDFChildSub=$p(PHCDFRowId,"||",2)
			S INFORowId=""
			S:INCIRowId'="" INFORowId=$o(^DHCITMINFO(0,"INCI",INCIRowId,0))
			
		}
		elseif (tablename="INC_Itm")  ///库存项id#医嘱项id#收费项id#医嘱与收费项关联id
		{
			s IDStr=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			s INCIRowId=$p(IDStr,"#",1)
			s ARCIMRowId=$p(IDStr,"#",2)
			s ARCIMSubscript=$p(ARCIMRowId,"||",1)
			s ARCIMVersion=$p(ARCIMRowId,"||",2)
			s TARIRowId=$p(IDStr,"#",3)
			s OLTRowId=$p(IDStr,"#",4)
			S INFORowId=""
			S:INCIRowId'="" INFORowId=$o(^DHCITMINFO(0,"INCI",INCIRowId,0))
		}
		elseif (tablename="SS_User")  ///用户id#医护人员id#类型（U,UC,C)
		{
			s IDStr=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			s SSUSRRowId=$p(IDStr,"#",1)
			s CTPCPRowId1=$p(IDStr,"#",2)
			s SSType=$p(IDStr,"#",3)
			if SSType["U" s URowId=SSUSRRowId
			else  s URowId=CTPCPRowId1
		}
		elseif (tablename="ARC_OrdSets")  //医嘱套 2019-04-04  update2019-04-08
		{
			s IDStr=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			s ARCOSRowId=$p(IDStr,"#",1)
			s DATEChildSub=$p(IDStr,"#",2)
			s ITMChildSub="",OSChildSub=""
			s Type=$p(IDStr,"#",4)
			s ChildSub=$p(IDStr,"#",3)
			if Type="TIM" s ITMChildSub=$p(IDStr,"#",3)
			if Type="OS" s OSChildSub=$p(IDStr,"#",3)
			s FavRowId=$o(^DHCFavItems(0,"ItemRowid",ARCOSRowId,0))
		}
		elseif (tablename="RB_ResEffDateSession")  //排版模板20190912
		{
			s IDStr=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			s RESRowId=$p(IDStr,"#",1)
			s DATEChildSub=$p(IDStr,"#",2)
			S SESSChildsub=$p(IDStr,"#",3)
			
		}
		elseif (tablename="INC_StkCat")  //库存分类 20191023
		{
			s INCSCRowId=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			s xrowid=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			s SCGRowid=$o(^DHCSCG("STKCAT",INCSCRowId,0))  //库存类组rowid
			
		}
		elseif (tablename="OrderCategory")  //医嘱分类 20191023
		{
			s IDStr=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			s ARCICRowId=$p(IDStr,"#",1)
			s ORCATRowId=$p(IDStr,"#",2)
		}
		elseif (tablename="ChargeCategory")  //费用分类 20191023
		{
			s IDStr=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			//s ARCSGRowId=$p(IDStr,"#",1)
			s HOSPRowId=$p(IDStr,"#",1)
			s TARSCRowId=$p(IDStr,"#",2)
			s TARICRowId=$p(IDStr,"#",3)
			s TAROCRowId=$p(IDStr,"#",4)
			s TARECRowId=$p(IDStr,"#",5)
			s TARACRowId=$p(IDStr,"#",6)
			s TARMCRowId=$p(IDStr,"#",7)
			s NTARMCRowId=$p(IDStr,"#",8)
		}
		elseif (tablename="RoomBedType")  //床位类型房间类型 20191024
		{
			
			s IDStr=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			s ROOMTRowId=$p(IDStr,"#",1)
			s BEDTPRowId=$p(IDStr,"#",2)
			
		}
		elseif (tablename="ARC_ItemExternalCodes")  //检验外部代码  20191024
		{
			
			s IDStr=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			s subscript=$p(IDStr,"#",1)
			s version=$p(IDStr,"#",2)
			s extsub=$p(IDStr,"#",3)
		
		}
		elseif (tablename="DHC_CTLoc_MedUnitCareProv")  //医疗单元及关联医护人员  20191024
		{
			
			s IDStr=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			s CTLOCRowId=$p(IDStr,"#",1)
			s CTMUChildsub=$p(IDStr,"#",2)
			s MUCPChildsub=$p(IDStr,"#",3)
		
		}
		elseif (tablename="BDP_TableList")	//表结构登记及子表 20200920
		{
			s IDStr=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			s TBID=$p(IDStr,"#",1)
			s TBChildsub=$p(IDStr,"#",2)
		}
		elseif (tablename="PHC_Cat")  //药理学分类  20191024
		{
			s IDStr=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			s PHCCLevel=$p(IDStr,"&%",1)
			s PHCCCode=$p(IDStr,"&%",2)
			s PHCCDesc=$p(IDStr,"&%",3)
		}
		elseif (tablename="DHC_TarItemPrice")  //收费项价格 2021-08-20
		{
			s IDStr=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			s TARIRowId=$p(IDStr,"#",1)
			s TPChildSub=$p(IDStr,"#",2)
		}
		elseif (tablename="PAC_Bed") //病区id#床位id#等候区id
		{
			s IDStr=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			s xparref=$p(IDStr,"#",1)
			s xrowid=$p(IDStr,"#",2)
			s RoomDR="",DateFrom="",DateTo="",FloorId=""
			s:xrowid'="" RoomDR=$p($g(^PAWARD(xparref,"BED",xrowid)),"^",3)  //床位 房间指针
			s:xrowid'="" RoomDR=$p($g(^PAWARD(xparref,"BED",xrowid)),"^",3)  //床位 房间指针
			s RoomChildSub=$p(IDStr,"#",3)
			s:RoomChildSub'="" RoomDR=$p($g(^PAWARD(xparref,"ROOM",RoomChildSub)),"^",1)  //等候区 房间指针
			s:xrowid'="" DateFrom=$p($g(^PAWARD(xparref,"BED",xrowid)),"^",21)  //开始日期（床位）
			s:xrowid'="" DateTo=$p($g(^PAWARD(xparref,"BED",xrowid)),"^",22)  //结束日期（床位）
			s:RoomChildSub'="" DateFrom=$p($g(^PAWARD(xparref,"ROOM",RoomChildSub)),"^",7)  //开始日期（等候区）
			s:RoomChildSub'="" DateTo=$p($g(^PAWARD(xparref,"ROOM",RoomChildSub)),"^",8)  //结束日期（等候区）
		}
		else
		{
			s xrowid=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
		}
	}
	s vcount=0
	s ID=0,vresult=""
	for
	{
		s ID=$o(^User.BDPEXConfigD(EXCID,"ChildField",ID)) q:ID=""
		s EXFCFieldDesc=$LISTGET($G(^User.BDPEXConfigD(EXCID,"ChildField",ID)),2)
	   	s EXFCFieldName=$LISTGET($G(^User.BDPEXConfigD(EXCID,"ChildField",ID)),3)		   
	    s EXFCGetField=$LISTGET($G(^User.BDPEXConfigD(EXCID,"ChildField",ID)),6)
	    
	    s SSRowId=$g(SSUSRRowId),CTRowId=$g(CTPCPRowId1)
	    if ($g(SSType)="C")&&(EXFCFieldName="SSUSRInitials")
		{
			s EXFCGetField="$p($g(^CTPCP(CTPCPRowId1,1)),""^"",1)"
		}
		if ($g(SSType)="C")&&(EXFCFieldName="SSUSRName")
		{
			s EXFCGetField="$p($g(^CTPCP(CTPCPRowId1,1)),""^"",2)"
		}
				    
	    s vcount=vcount+1
	    s EXFCFieldType=$LISTGET($G(^User.BDPEXConfigD(EXCID,"ChildField",ID)),4)    ///String
	    
	    s blankflag=0
	    if (tablename["ARC_ItmMast")&&(((EXFCGetField["TARIRowId")&&($g(TARIRowId)=""))||((EXFCGetField["OLTRowId")&&($g(OLTRowId)=""))) s blankflag=1
		if (tablename["PHC_DrgMast")&&(((EXFCGetField["TARIRowId")&&($g(TARIRowId)=""))||((EXFCGetField["OLTRowId")&&($g(OLTRowId)=""))||((EXFCGetField["ARCIMSubscript")&&($g(ARCIMSubscript)=""))||((EXFCGetField["ARCIMVersion")&&($g(ARCIMVersion)=""))||((EXFCGetField["PHCDFRowId")&&($g(PHCDFRowId)=""))||((EXFCGetField["PHCDRowId")&&($g(PHCDRowId)=""))||((EXFCGetField["INFORowId")&&($g(INFORowId)=""))||((EXFCGetField["INCTRRowId")&&($g(INCTRRowId)=""))) s blankflag=1
		if (tablename="INC_Itm")&&(((EXFCGetField["TARIRowId")&&($g(TARIRowId)=""))||((EXFCGetField["OLTRowId")&&($g(OLTRowId)=""))||((EXFCGetField["ARCIMSubscript")&&($g(ARCIMSubscript)=""))||((EXFCGetField["ARCIMVersion")&&($g(ARCIMVersion)=""))||((EXFCGetField["INFORowId")&&($g(INFORowId)=""))) s blankflag=1
		if (tablename="SS_User")&&(((EXFCGetField["SSUSRRowId")&&($g(SSUSRRowId)=""))||((EXFCGetField["CTPCPRowId1")&&($g(CTPCPRowId1)=""))) s blankflag=1
		if (tablename="ARC_OrdSets")&&(((EXFCGetField["ITMChildSub")&&($g(ITMChildSub)=""))||((EXFCGetField["OSChildSub")&&($g(OSChildSub)=""))||((EXFCGetField["FavRowId")&&($g(FavRowId)=""))) s blankflag=1
		if (tablename="INC_StkCat")&&((EXFCGetField["SCGRowid")&&($g(SCGRowid)="")) s blankflag=1
		if (tablename="ChargeCategory")&&(((EXFCGetField["ARCSGRowId")&&($g(ARCSGRowId)=""))||((EXFCGetField["TARSCRowId")&&($g(TARSCRowId)=""))||((EXFCGetField["TARICRowId")&&($g(TARICRowId)=""))||((EXFCGetField["TAROCRowId")&&($g(TAROCRowId)=""))||((EXFCGetField["TARECRowId")&&($g(TARECRowId)="")) ||((EXFCGetField["TARACRowId")&&($g(TARACRowId)="")) ||((EXFCGetField[",TARMCRowId")&&($g(TARMCRowId)=""))||((EXFCGetField["NTARMCRowId")&&($g(NTARMCRowId)=""))||((EXFCGetField["HOSPRowId")&&($g(HOSPRowId)=""))) s blankflag=1
		if (tablename="RoomBedType")&&(((EXFCGetField["ROOMTRowId")&&($g(ROOMTRowId)=""))||((EXFCGetField["BEDTPRowId")&&($g(BEDTPRowId)=""))) s blankflag=1
		if (tablename="DHC_CTLoc_MedUnitCareProv")&&((EXFCGetField["MUCPChildsub")&&($g(MUCPChildsub)="")) s blankflag=1
		if (tablename="BDP_TableList")&&((EXFCGetField["TBChildsub")&&($g(TBChildsub)="")) s blankflag=1
		if (tablename="PAC_Bed")&&(((EXFCGetField["RoomChildSub")&&($g(RoomChildSub)=""))||((EXFCGetField["xrowid")&&($g(xrowid)=""))||((EXFCGetField["RoomDR")&&($g(RoomDR)=""))||((EXFCGetField="DateFrom")&&($g(DateFrom)=""))||((EXFCGetField="DateTo")&&($g(DateTo)=""))) s blankflag=1
		if blankflag=1
		{
			s EXFCIDToCodestr="s "_EXFCFieldName_"="""""
			x EXFCIDToCodestr
			if (vresult'="")||(vcount>1)
			{
				s vrs="s vresult=vresult_""&%""_"_EXFCFieldName
				x vrs
			}
			else
			{
				s vrs="s vresult="_EXFCFieldName
				x vrs
				
			}
			continue
		}

		if EXFCGetField="" s EXFCGetField=""""""
		
		s EXFCFieldNamestr="s "_EXFCFieldName_"="_EXFCGetField
		x EXFCFieldNamestr
		if (EXFCFieldType="DR")
		{
			s EXFCIDToCode=$LISTGET($G(^User.BDPEXConfigD(EXCID,"ChildField",ID)),5) //$listget($g(^IHBI.BaseKPIDefineD(KPIDR)),1)
			if (EXFCIDToCode'="")
			{
				;s EXFCIDToCodeName=$LISTGET($G(^User.BDPEXConfigD(EXCID,"ChildField",childsub)),7)  //KPICode
				s EXFCIDToCodestr="if "_EXFCFieldName_"'="""" s "_EXFCFieldName_"="_EXFCIDToCode
				x EXFCIDToCodestr
			}
		}
		if (EXFCFieldType["Date")
		{
			s datestr= "if "_EXFCFieldName_"'="""" s "_EXFCFieldName_"=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml("_EXFCFieldName_")"
			x datestr
		}
		if (EXFCFieldType["Time")
		{
			s datestr= "if "_EXFCFieldName_"'="""" s "_EXFCFieldName_"=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml("_EXFCFieldName_")"
			x datestr
		}
		if (vresult'="")||(vcount>1)
		{
			s vrs="s vresult=vresult_""&%""_"_EXFCFieldName
			x vrs
		}
		else
		{
			s vrs="s vresult="_EXFCFieldName
			x vrs
		}
		
		
	}	
	s ^TMPEXPORTEXCEL(tablename,"ROW")=i
	q vresult
}

// Other: w ##class(web.DHCBL.BDP.BDPDataExport).GetFieldRow("CT_Province")

ClassMethod GetFieldRow(tablename) As %String
{
	q:tablename="" 1
	s row=$g(^TMPEXPORTEXCEL(tablename,"ROW"))
	q row
}

/// Creator:陈莹
/// CreatDate:2019-10-24
/// Description:获取一个药理学分类下的所有子级，不区分医院 2020-06-30
/// w ##class(web.DHCBL.BDP.BDPDataExport).GetChildPHCC("sss","DHC_PHCCat",0)
ClassMethod GetChildPHCC(mySysID, tablename, parentid) As %String
{
	N (mySysID,tablename,parentid)
	s HOSPDr=""  //考虑没有医院的时候 为0
	for
	{
		s HOSPDr=$o(^DHCPHCC(0,"PARCAT",HOSPDr)) q:HOSPDr=""
		s PHCCRowId=0
		for
		{
			s PHCCRowId=$o(^DHCPHCC(0,"PARCAT",HOSPDr,parentid,PHCCRowId)) q:PHCCRowId=""
			S DataCount=$o(^TMPEXCELEXPORT(mySysID,tablename,""),-1)
			s DataCount=DataCount+1
			s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=PHCCRowId
			D ##class(web.DHCBL.BDP.BDPDataExport).GetChildPHCC(mySysID, tablename,PHCCRowId)
		}
		
	}
	q ""
}

/// 2019-10-10整合导出调用到的方法
/// Creator:陈莹
/// CreatDate:2017-09-06
/// Description:通过库存项rowid获取药品进价（调价表进价）
/// w ##class(web.DHCBL.BDP.BDPDataExport).GetRp("1")
/// SELECT INASP_CTUOM_Rp,inasp_ctuom_price,* FROM in_adjsaleprice
ClassMethod GetRp(INCIRowId) As %String
{
	n (INCIRowId,%session)
	q:INCIRowId="" ""
	s Rp=""
	s HospID= ##class(web.DHCBL.BDP.BDPDataExport).GetHospital("INC_Itm",INCIRowId)
	if HospID=""
	{
		if $d(%session) s HospID=$g(%session.Data("LOGON.HOSPID"))
	}
	s:HospID="" HospID=$o(^CT("HOSP",0))
	if HospID'=""
	{
		s INCICTUOMPurchDR=$p($g(^INCI(INCIRowId,3)),"^",6)  //入库单位
		s INCIINCSCDR=$p($g(^INCI(INCIRowId,2)),"^",2)  //库存分类
		if INCIINCSCDR'="" 
		{
			s Type=$p($g(^INC("SC",INCIINCSCDR)),"^",3)
			if (Type="G")
			{
				//药品
				s Rp=##Class(web.DHCSTPRICE).GetRp(INCIRowId,+$H,INCICTUOMPurchDR,HospID,"")
				//s Rp=##Class(web.DHCSTPRICE).GetInciBasicRp(INCIRowId,+$h,INCICTUOMPurchDR,HospID)  //调价表进价
				//s Rp=##Class(web.DHCSTPRICE).GetInciLastRp(INCIRowId,INCICTUOMPurchDR,HospID)   //入库表进价	
			}
			else
			{
				// 物资
				s Rp=##Class(web.DHCSTPRICE).GetRp(INCIRowId,+$H,INCICTUOMPurchDR,HospID,"")
				//s Rp=##Class(web.DHCSTPRICE).GetInciBasicRp(INCIRowId,+$h,INCICTUOMPurchDR,HospID)  //调价表进价
				//s Rp=##Class(web.DHCSTPRICE).GetInciLastRp(INCIRowId,INCICTUOMPurchDR,HospID)   //入库表进价	
				//s Sp=$$GetInciLRp^DHCSTPRICE(INCIRowId,INCICTUOMPurchDR)  //6.8  zn "meddata"  
				//s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciBasicRpOld(INCIRowId,+$H,INCICTUOMPurchDR,HospID)
			}
		}
	}
    q Rp
}

/// Creator:陈莹
/// CreatDate:2017-09-06
/// Description:通过库存项rowid获取药品售价
/// w ##class(web.DHCBL.BDP.BDPDataExport).GetSp(INCIRowId)
ClassMethod GetSp(INCIRowId) As %String
{
	n (INCIRowId,%session)
	q:INCIRowId="" ""
	s Sp=""
	s HospID= ##class(web.DHCBL.BDP.BDPDataExport).GetHospital("INC_Itm",INCIRowId)
	if HospID=""
	{
		if $d(%session) s HospID=$g(%session.Data("LOGON.HOSPID"))
	}
	s:HospID="" HospID=$o(^CT("HOSP",0))
	if HospID'=""
	{
		s INCICTUOMPurchDR=$p($g(^INCI(INCIRowId,3)),"^",6)  //入库单位
		s INCIINCSCDR=$p($g(^INCI(INCIRowId,2)),"^",2)  //库存分类
		if INCIINCSCDR'="" 
		{
			s Type=$p($g(^INC("SC",INCIINCSCDR)),"^",3)
			if (Type="G")
			{
				//药品
				s Sp=##Class(web.DHCSTPRICE).GetSp(INCIRowId,+$H,INCICTUOMPurchDR,HospID,"")
				//s Sp=##Class(web.DHCSTCOMMONSRV).GetPriceElse(INCIRowId,+$H,INCICTUOMPurchDR,HospID)  //调价表售价
				//s Sp=##Class(web.DHCSTPRICE).GetSp(INCIRowId,+$H,INCICTUOMPurchDR,HospID,"") 
			}
			else
			{
				//物资
				s Sp=##Class(web.DHCSTPRICE).GetSp(INCIRowId,+$H,INCICTUOMPurchDR,HospID,"")
				//s Sp=##class(web.DHCSTCOMMONSRV).GetPriceElse(INCIRowId,+$H,INCICTUOMPurchDR,HospID) //调价表售价
				//s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetSp(INCIRowId,+$H,INCICTUOMPurchDR,HospID)
			}
		}
	}
    q Sp
}

/// Creator:陈莹
/// CreatDate:2017-09-06
/// Description:通过医嘱项rowid获取医嘱项的别名
/// w ##class(web.DHCBL.BDP.BDPDataExport).GetARCIMAlias(ARCIMRowId)
ClassMethod GetARCIMAlias(ARCIMRowId) As %String
{
	n (ARCIMRowId)
	q:ARCIMRowId="" ""
	s ALIASRowId=0
	s ALIASText1=""
	for
	{
		s ALIASRowId=$o(^ARC("ALIAS",0,"ARCIM",ARCIMRowId,ALIASRowId)) q:ALIASRowId=""
		s ALIASText=$p($g(^ARC("ALIAS",ALIASRowId)),"^",6)
		if ALIASText'=""
		{
			if ALIASText1'="" s ALIASText1=ALIASText1_"/"_ALIASText
			else  s ALIASText1=ALIASText
		}
	}
	q ALIASText1
}

/// Creator:陈莹
/// CreatDate:2021-05-29
/// Description:通过医嘱套rowid获取医嘱套的别名
/// w ##class(web.DHCBL.BDP.BDPDataExport).GetARCOSAlias(ARCOSRowId)
ClassMethod GetARCOSAlias(ARCOSRowId) As %String
{
	n (ARCOSRowId)
	q:ARCOSRowId="" ""
	s ALIASRowId=0
	s ALIASText1=""
	for
	{
		s ALIASRowId=$o(^ARC("ALIAS",0,"ARCOS",ARCOSRowId,ALIASRowId)) q:ALIASRowId=""
		s ALIASText=$p($g(^ARC("ALIAS",ALIASRowId)),"^",6)
		if ALIASText'=""
		{
			if ALIASText1'="" s ALIASText1=ALIASText1_"/"_ALIASText
			else  s ALIASText1=ALIASText
		}
	}
	q ALIASText1
}

/// Creator:陈莹
/// CreatDate:2017-07-13
/// Description:通过收费项rowid获取收费项别名
/// w ##class(web.DHCBL.CT.DHCTarItem).GetTarAliasByRowId("1")
ClassMethod GetTarAliasByRowId(id) As %String
{
	n (id)
	s ALIASText1=""
	s TIARowId=0
	for
	{
		s TIARowId=$o(^DHCTARAL("A",id,TIARowId))  q:TIARowId=""
		s TIAAlias=$p($g(^DHCTARAL(TIARowId)),"^",3)
		s:ALIASText1'="" ALIASText1=ALIASText1_"/"_TIAAlias
		s:ALIASText1="" ALIASText1=TIAAlias
	}
	q ALIASText1
}

///  Function: 获取医嘱项的价格
///  Creator:  sunfengchao
///  CreateDate: 2015-8-5
///  Input:arcimrowid（医嘱项rowid）
///  Return: 医嘱项 目前的价格
///  w ##class(web.DHCBL.BDP.BDPDataExport).GetOrderPrice("14009||1")
ClassMethod GetOrderPrice(arcimrowid As %String) As %String
{
	n (arcimrowid,%session)
	q:arcimrowid="" ""
	s price=""
	s HospID=##class(web.DHCBL.BDP.BDPDataExport).GetHospital("ARC_ItmMast",arcimrowid)
	if HospID=""
	{
		if $d(%session) s HospID=$g(%session.Data("LOGON.HOSPID"))
	}
	s:HospID="" HospID=$o(^CT("HOSP",0))
	if HospID'=""
	{
		Set aricmprice=""
		s myobj=""
		s myobj=##class(%Dictionary.CompiledMethod).%OpenId("web.UDHCJFPRICE||GetOrderPrice")
		s Params=myobj.FormalSpec
		if ($zcvt(Params,"U")["HOSPID")
		{
			s aricmprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcimrowid,+$h,"","","","",HospID)
		}
		else
		{
			s aricmprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcimrowid,+$h,"","","","")
		}
		s myobj=""
		s price=$p(aricmprice,"^",1)
		if $e(price,1)="." s price="0"_price
		s price=$tr(price,$c(10),"")
		s price=$tr(price,$c(13),"")
		s price=$tr(price,$c(0),"")
	}
	q price
}

/// Function: 获取收费项价格
/// CreateDate:2016-8-26
/// Creator: chenying
/// Input:tarirowid(收费项rowid)
/// Retrun:收费项价格
/// w ##class(web.DHCBL.BDP.BDPDataExport).GetTariPrice("22")
ClassMethod GetTariPrice(tarirowid As %String) As %String
{
	n (tarirowid,%session)
	q:tarirowid="" ""
	s tarprice=""
	s HospID=##class(web.DHCBL.BDP.BDPDataExport).GetHospital("DHC_TarItem",tarirowid)
	if HospID=""
	{
		if $d(%session) s HospID=$g(%session.Data("LOGON.HOSPID"))
	}
	s:HospID="" HospID=$o(^CT("HOSP",0))
	if HospID'=""
	{
		s priceinfo=""
		s myobj=""
		s myobj=##class(%Dictionary.CompiledMethod).%OpenId("web.UDHCJFPRICE||GetItmPrice")
		s Params=myobj.FormalSpec
		if ($zcvt(Params,"U")["HOSPID")
		{
			if $d(^DHCINCTARi("TAR",tarirowid))>0  //药品需要传医嘱项才能取到价格 20230404update
			{
				s INCIOriginalARCIMDR="",INCIRowId=""
				s INCTRRowId=$o(^DHCINCTARi("TAR",tarirowid,0))
				s:INCTRRowId'="" INCIRowId=$P($G(^DHCINCTAR(INCTRRowId)),"^",1)
				s:INCIRowId'="" INCIOriginalARCIMDR=$P($G(^INCI(INCIRowId,1)),"^",3)
				s ExpString="^^^^^"_INCIOriginalARCIMDR_"^^^^^"_INCIRowId
				s priceinfo=##class(web.UDHCJFPRICE).GetItmPrice(tarirowid,+$h,"","","",HospID,ExpString)
			}
			else
			{
				s priceinfo=##class(web.UDHCJFPRICE).GetItmPrice(tarirowid,+$h,"","","",HospID)
			}
		}
		else
		{
			s priceinfo=##class(web.UDHCJFPRICE).GetItmPrice(tarirowid,+$h,"","","")
		}
		s myobj=""
		s tarprice=$p(priceinfo,"^",1)
		if $e(tarprice,1)="." s tarprice="0"_tarprice
		s tarprice=$tr(tarprice,$c(10),"")
		s tarprice=$tr(tarprice,$c(13),"")
		s tarprice=$tr(tarprice,$c(0),"")		
	}
	q tarprice
}

/// Creator:陈莹
/// CreatDate:2017-10-10
/// Description:通过库存项是否收费标志（有没有关联医嘱项）
/// w ##class(web.DHCBL.BDP.BDPDataExport).GetChargeFlag(INCIRowId)
ClassMethod GetChargeFlag(INCIRowId) As %String
{
	n (INCIRowId)
	q:INCIRowId="" ""
	s INCIOriginalARCIMDR=$P($G(^INCI(INCIRowId,1)),"^",3)
	if (INCIOriginalARCIMDR'="")
	{
		s Flag="Y"
	}
	else
	{
		s Flag="N"
	}
	q Flag
}

/// Creator:陈莹
/// CreatDate:2017-10-10
/// Description:通过库存项获取库存类组描述
/// 库存类组与分类关联表 User.DHCStkCatGrpRelations
/// w ##class(web.BDPExt.WZBLL).GetCatGrpByRowId(INCIRowId)
ClassMethod GetCatGrpByRowId(INCIRowId) As %String
{
	n (INCIRowId)
	q:INCIRowId="" ""
	s Desc=""
	s StkCat=$p($g(^INCI(INCIRowId,2)),"^",2)
	if StkCat'=""
	{
		s StkCatType=$p($g(^INC("SC",StkCat)),"^",3)
		s SCGRowid=0
		for
		{
			s SCGRowid=$o(^DHCSCG("STKCAT",StkCat,SCGRowid)) q:SCGRowid=""
			s SCGType=$p($g(^DHCSCG(SCGRowid)),"^",3)
			if (SCGType=StkCatType)  //判断类组和库存分类的类型是否匹配，遇到项目上关联了不同类型的情况
			{
				 s Desc=$p($g(^DHCSCG(SCGRowid)),"^",2)
			}
		}
	}
	q Desc
}

/// Descript:   查询库存项别名
/// Creater:    ZhangDongmei
/// CreateDate: 2011-12-23
/// Table:INC_Itm
/// Input:库存项id
/// Output:别名1/别名2
/// Return：
ClassMethod GetIncAlias(InciId) As %Library.String
{

    n (InciId)
    q:InciId="" ""
    s AliasStr=""
    s IncaId=0
    f  s IncaId=$o(^INCALIAS(0,"INCI",InciId,IncaId))  q:IncaId=""  d
    .s Alias=$p($g(^INCALIAS(IncaId)),"^",4)
    .q:Alias=""
    .i AliasStr=""  d
    ..s AliasStr=Alias
    .e  d
    ..s AliasStr=AliasStr_"/"_Alias
    .
    q AliasStr
}

/// Creator:陈莹
/// CreatDate:2017-09-06
/// Description:获取根据树形药理学分类的级别获取他的父级或者本身的药理学分类描述
/// w ##class(web.DHCBL.BDP.BDPDataExport).GetPHCCatByPHCCRowId(PHCCRowId,3)
ClassMethod GetPHCCatByPHCCRowId(PHCCRowId, Level) As %String
{
	n (PHCCRowId,Level)
	q:PHCCRowId="" ""
	s PHCCLevel=$p($g(^DHCPHCC(PHCCRowId)),"^",4)
	s PHCCat=""
	if PHCCLevel=Level
	{
		s PHCCat=$p($g(^DHCPHCC(PHCCRowId)),"^",2)
	}
	else
	{
		if PHCCLevel>Level
		{
			s PHCCParCatDr=$p($g(^DHCPHCC(PHCCRowId)),"^",3)
			s PHCCat=..GetPHCCatByPHCCRowId(PHCCParCatDr,Level)
		}
		
	}
	
	q PHCCat
}

/// Creator:陈莹
/// CreatDate:2017-09-06
/// Description:通过药学形态rowid获取药理学分类( User.PHCDrgFormExt  PHCDFPHCCDr) 药品导出时调用
/// w ##class(web.DHCBL.BDP.BDPDataExport).GetPHCCatByRowId(PHCDFRowId,3)
ClassMethod GetPHCCatByRowId(PHCDFRowId, Level) As %String
{
	n (PHCDFRowId,Level)
	q:PHCDFRowId="" ""
	s PHCCat=""
	s PHCDRowId=$p(PHCDFRowId,"||",1)
	s PHCDFChildSub=$p(PHCDFRowId,"||",2)
	q:(PHCDRowId="")||(PHCDFChildSub="") ""
	s PHCDFPHCCDr=$P($g(^PHCD(PHCDRowId,"DF",PHCDFChildSub,"DHC")),"^",20)
	if PHCDFPHCCDr'=""
	{
		s PHCCLevel=$p($g(^DHCPHCC(PHCDFPHCCDr)),"^",4)
		if PHCCLevel=Level
		{
			s PHCCat=$p($g(^DHCPHCC(PHCDFPHCCDr)),"^",2)
		}
		else
		{
			if PHCCLevel>Level
			{
				s PHCCat=..GetPHCCatByPHCCRowId(PHCDFPHCCDr,Level)
			}
			
		}
	}
	else
	{

		s PHCMinorSubCat=$P($g(^PHCD(PHCDRowId,1)),"^",6)
		s PHCDPHCSCDR=$P($g(^PHCD(PHCDRowId,1)),"^",3)
		
		if (Level=3)&&(PHCMinorSubCat'="")
		{
			s PHCCRowId=$p(PHCMinorSubCat,"||",1)
			s PHCSCRowId=$p(PHCMinorSubCat,"||",2)
			s MINRowId=$p(PHCMinorSubCat,"||",3)
			if ($g(PHCCRowId)'="")&&($G(PHCSCRowId)'="")&&($G(MINRowId)'="") s PHCCat=$p($g(^PHCC(PHCCRowId,"SC",PHCSCRowId,"MIN",MINRowId)),"^",2)
			
		}
		if (Level=2)&&(PHCDPHCSCDR'="")
		{
			s PHCCRowId=$p(PHCDPHCSCDR,"||",1)
			s PHCSCRowId=$p(PHCDPHCSCDR,"||",2)
			if ($g(PHCCRowId)'="")&&($G(PHCSCRowId)'="") s PHCCat=$p($g(^PHCC(PHCCRowId,"SC",PHCSCRowId)),"^",2)
		}
		if (Level=1)&&(PHCDPHCSCDR'="")
		{
			s PHCCRowId=$p(PHCDPHCSCDR,"||",1)
			if ($g(PHCCRowId)'="") s PHCCat=$p($g(^PHCC(PHCCRowId)),"^",2)
		} 
		
	}
	
	
	q PHCCat
}

/// Creator:陈莹
/// CreatDate:2017-09-06 药品导出用
/// Description:PHC_FormDoseEquiv表
/// w ##class(web.DHCBL.BDP.BDPDataExport).GetEQValue(PHCDFRowId,"EQQty1")
ClassMethod GetEQValue(PHCDFRowId, Property) As %String
{
	n (PHCDFRowId, Property)
	s value=""
	s count=0
	s PHCDRowId=$p(PHCDFRowId,"||",1)
	s PHCDFChildSub=$p(PHCDFRowId,"||",2)
	q:(PHCDRowId="")||(PHCDFChildSub="") ""
	s EQChildsub = 0
	for
	{
		s EQChildsub = $o(^PHCD(PHCDRowId,"DF",PHCDFChildSub,"EQ",EQChildsub))
		q:EQChildsub=""
		s count=count+1
		if (count=1)
		{
			if (Property="EQCTUOMDR1")  //等效单位1
			{
				s value = $p($g(^PHCD(PHCDRowId,"DF",PHCDFChildSub,"EQ",EQChildsub)),"^",1)
				//s:EQCTUOMDR'="" value=$p($g(^CT("UOM",EQCTUOMDR)),"^",2)  //不在后台转换，在前台dr转换  2018-03-19
			}
			if (Property="EQQty1")  //等效数量1
			{
				s value = $p($g(^PHCD(PHCDRowId,"DF",PHCDFChildSub,"EQ",EQChildsub)),"^",2)
			}
			if (Property="EQDefaultDose1")  //缺省数量1
			{  
				s value = $p($g(^PHCD(PHCDRowId,"DF",PHCDFChildSub,"EQ",EQChildsub)),"^",3)
			}
			///2020-01-11add by chenying
			if (Property="EQDefault1")  //等效单位1默认(Y/N)
			{
				s value = $p($g(^PHCD(PHCDRowId,"DF",PHCDFChildSub,"EQ",EQChildsub)),"^",4)
			}		
			
		}
		
		if (count=2)
		{
			if (Property="EQCTUOMDR2")
			{
				s value = $p($g(^PHCD(PHCDRowId,"DF",PHCDFChildSub,"EQ",EQChildsub)),"^",1)
				//s:EQCTUOMDR'="" value=$p($g(^CT("UOM",EQCTUOMDR)),"^",2)  //不在后台转换，在前台dr转换
			}
			if (Property="EQQty2")
			{
				s value = $p($g(^PHCD(PHCDRowId,"DF",PHCDFChildSub,"EQ",EQChildsub)),"^",2)
			}
			if (Property="EQDefaultDose2")
			{
				s value = $p($g(^PHCD(PHCDRowId,"DF",PHCDFChildSub,"EQ",EQChildsub)),"^",3)
			}
			///2020-01-11add by chenying
			if (Property="EQDefault2")  //等效单位2默认(Y/N)
			{
				s value = $p($g(^PHCD(PHCDRowId,"DF",PHCDFChildSub,"EQ",EQChildsub)),"^",4)
			}	
		}
		
		
	}
	q value
}

/// Creator：陈莹 
/// CreatDate: 2017-03-2809-11
/// Description：获取从单位到单位的转换系数
/// Table：User.CTConFac
/// Input:fruom:从单位的描述,touom:到单位的描述
/// Return：factor
/// w ##class(web.DHCBL.BDP.BDPDataExport).GetFactor("kg","g")
/// w ##class(web.DHCBL.BDP.BDPDataExport).GetFactor("盒(10)","片")
ClassMethod GetFactor(fruomdesc, touomdesc) As %String
{
	n (fruomdesc,touomdesc)
	q:(fruomdesc="")||(touomdesc="") ""
	S factor=""
	if (fruomdesc=touomdesc) q 1
	s:fruomdesc'="" fruomdesc=$ZCONVERT(fruomdesc,"U") //$$ALPHAUP^SSUTIL4(code)
	s:touomdesc'="" touomdesc=$ZCONVERT(touomdesc,"U") //$$ALPHAUP^SSUTIL4(desc)
	q:(fruomdesc="")||(touomdesc="") ""
	s fruomid=$o(^CT("UOM",0,"Code",fruomdesc,0))
	s touomid=$o(^CT("UOM",0,"Code",touomdesc,0))
	q:(fruomid="")||(touomid="") ""
	s CTCFRowID=$O(^CT("CTCF",0,"UOM",fruomid,touomid,0))
	IF CTCFRowID'="" S factor=$p($g(^CT("CTCF",CTCFRowID)),"^",3)
	q factor
}

/// Creator:陈莹
/// CreatDate:2017-10-10
/// Description:返回一条数据的别名（BDPAlias）
/// Other:w ##class(web.DHCBL.BDP.BDPDataExport).GetDataAliasByRowId("1","CT_Loc")
/// Other:w ##class(web.DHCBL.BDP.BDPDataExport).GetDataAliasByRowId("1","PHC_Generic")
ClassMethod GetDataAliasByRowId(RowId, TableName)
{
	n (RowId,TableName)
	s ALIASText1=""
	s AliasRowId=0
	for
	{
		s AliasRowId=$o(^User.BDPAliasI("DataRef",TableName,RowId,AliasRowId))
		q:AliasRowId=""
		s ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
		if ALIASText1'="" s ALIASText1=ALIASText1_"/"_ALIASText
		else  s ALIASText1=ALIASText
		
	}
	q ALIASText1
}

/// Creator:陈莹
/// CreatDate:2017-10-10
/// Description:
/// Other:w ##class(web.DHCBL.BDP.BDPDataExport).GetProValueByRowId("1","ADMLOCAdmType")
/// 改名GetCTLOCProValueByRowId
ClassMethod GetCTLOCProValueByRowId(RowId, ProName)
{
  	n (ProName,RowId)
	s value=""
	Q:(RowId="")||(ProName="") ""
	if ProName="CTLOCClinicType"  //作为接收科室时能接收的就诊类型(门诊/住院/急诊/体检)
	{
		s value=$p($g(^CTLOC(RowId)),"^",85)	
	}
	
	if ProName="ADMLOCAdmType"   //科室分类(门诊/住院/急诊/体检)
	{
		s ADMLOCRowId=0
		for 
		{
			s ADMLOCRowId=$o(^PAC("ADMLOC",ADMLOCRowId)) q:ADMLOCRowId=""	 
			s ADMLOCAdmType=$p($g(^PAC("ADMLOC",ADMLOCRowId)),"^",1) 
			s ADMLOCCTLOCDR=$p($g(^PAC("ADMLOC",ADMLOCRowId)),"^",2)				   
			if (ADMLOCCTLOCDR=RowId)
			{
				if value'="" s value=value_"/"_ADMLOCAdmType
				else  s value=ADMLOCAdmType
				
			}
		}	
	}
	
	if value'=""
	{
		S value=$tr(value,"&","/")
		S value= ..Replace(value,"O", "门诊")
		S value= ..Replace(value,"I", "住院")
		S value= ..Replace(value,"E", "急诊")
		S value= ..Replace(value,"H", "体检")
	}
	if ProName="LINKCTLOCDR"  //LINK科室/发药关联科室
	{
		s LINKChildsub=0
		for
		{
			s LINKChildsub=$o(^CTLOC(RowId,"LINK",LINKChildsub)) q:LINKChildsub=""
			s LINKCTLOCDR=$p($g(^CTLOC(RowId,"LINK",LINKChildsub)),"^",1)
			s LINKCTLOCDR=##class(web.DHCBL.BDP.BDPDataExport).GetCTLocDescByRowId(LINKCTLOCDR)
			i (LINKChildsub>0)&&(LINKCTLOCDR'="")
			{
				if value'="" s value=value_"/"_LINKCTLOCDR
				else  s value=LINKCTLOCDR
			}
		}
		
	}
	q value
}

/// ##class(web.BDP.util.String).Replace()
/// 要求被替换的内容不能=""
ClassMethod Replace(instr As %String, substr As %String, replacement As %String) As %String
{
	
	;w ##class(web.BDP.util.String).Replace()
	q:(substr="") instr
	;q:(replacement="") instr
	q:'($l(instr,substr)>1) instr
	
	s mylen=$l(instr,substr)
	for myIdx=1:1:mylen {
		s myary(myIdx)=$p(instr,substr, myIdx)
	}
	
	s mystr=""
	s myIdx=""
	s myIdx=$o(myary(myIdx))
	while (myIdx'=""){
		s myrepstr=""
		i ($o(myary(myIdx))=""){
			s myrepstr=myary(myIdx)
		}else{
			s myrepstr=myary(myIdx)_replacement
		}
		
		i (mystr=""){
			s mystr=myrepstr
		}else{
			s mystr=mystr_myrepstr
		}
		
		s myIdx=$o(myary(myIdx))
		q:(myIdx="")
	}
	
	q mystr
}

/// Creator:陈莹
/// CreatDate:2019-10-23
/// Description:获取药品用法，频次的就诊类型对应的中文
/// Other:w ##class(web.DHCBL.BDP.BDPDataExport).GetClinicType("")
ClassMethod GetClinicType(ClinicType) As %String
{
  	n (ClinicType)
  	s value=""
	if ClinicType'=""
	{
		s ClinicTypeDesc=""
		if ClinicType["O"
		{
			s ClinicTypeDesc="门诊"
		}
		else
		{
			s ClinicTypeDesc=""
		}
		if ClinicType["E"
		{
			if ClinicTypeDesc=""
			{
				s ClinicTypeDesc="急诊"
			}
			else
			{
				s ClinicTypeDesc=ClinicTypeDesc_","_"急诊"
		
			}
		}

		if ClinicType["I"
		{
			if ClinicTypeDesc=""
			{
				s ClinicTypeDesc="住院"
			}
			else
			{
				s ClinicTypeDesc=ClinicTypeDesc_","_"住院"
		
			}
		}

		if ClinicType["H"
		{
			if ClinicTypeDesc=""
			{
				s ClinicTypeDesc="体检"
			}
			else
			{
				s ClinicTypeDesc=ClinicTypeDesc_","_"体检"
		
			}
		}
		if ClinicType["N"
		{
			if ClinicTypeDesc=""
			{
				s ClinicTypeDesc="新生儿"
			}
			else
			{
				s ClinicTypeDesc=ClinicTypeDesc_","_"新生儿"
		
			}
		}
		s value=ClinicTypeDesc
		
	}
	else
	{
		s value="门诊,急诊,住院,体检,新生儿"
	}
	q value
}

/// CreatDate: 2017-09-01
/// Description: 获取床位价格
/// Table：PAC_BedAdm , GetBedPriceById
/// Input：parref,childsub
/// Return：床位价格
/// w ##class(web.DHCBL.BDP.BDPDataExport).GetBedPrice("2","1")
ClassMethod GetBedPrice(ParRef, Childsub) As %String
{
	n (ParRef,Childsub,%session)
	q:(ParRef="")||(Childsub="") ""
	s Price=0
	s BEDBedTypeDR=$p($g(^PAWARD(ParRef,"BED",Childsub)),"^",2)
	if (BEDBedTypeDR'="")
	{
		if ($g(^DHCDocConfig("RollNotUseNewConfig"))=1)||($d(^DHCDocConfig("RollNotUseNewConfig"))=0)  ///勾选，取床位类型维护页面医嘱项价格数据
		{
			s ARCIMRowId=$p($g(^PAC("BEDTP",BEDBedTypeDR)),"^",4)
			if ARCIMRowId'="" s Price=..GetOrderPrice(ARCIMRowId)
		}
		else   //为0时，取医生站床位费用设置页面数据  DHC_PAC_BedTypeFeeItem/DHC_PAC_BedFeeItem
		{
			if ($o(^PAWARD(ParRef,"BED",Childsub,"FEE",0))>0)
			{
				s BEDIChildsub=0
				for
				{
					s BEDIChildsub=$o(^PAWARD(ParRef,"BED",Childsub,"FEE",BEDIChildsub)) q:BEDIChildsub=""
					s BEDIARCIMDR=$p($g(^PAWARD(ParRef,"BED",Childsub,"FEE",BEDIChildsub)),"^",2) //床位附加费用医嘱项
					s BEDIStartDate=$p($g(^PAWARD(ParRef,"BED",Childsub,"FEE",BEDIChildsub)),"^",3)	//开始日期
					s BEDIEndDate=$p($g(^PAWARD(ParRef,"BED",Childsub,"FEE",BEDIChildsub)),"^",4)		//结束日期
					if ((BEDIStartDate'="")&&(BEDIStartDate<=+$h))&&((BEDIEndDate="")||((BEDIEndDate'="")&&(BEDIEndDate>=+$h)))
					{
						s Price1=..GetOrderPrice(BEDIARCIMDR)
						s Price=Price1+Price
					}
				}
			}
			else
			{
				s BEDTPIChildsub=0
				for
				{
					s BEDTPIChildsub=$o(^PAC("BEDTP",BEDBedTypeDR,"FEE",BEDTPIChildsub)) q:BEDTPIChildsub=""
					s BEDTPIFeeType=$p($g(^PAC("BEDTP",BEDBedTypeDR,"FEE",BEDTPIChildsub)),"^",1)  //费用类型
					
					///只取附加费的医嘱价格 2018-04-02---2022-05-13去掉
					//s Code=""
					//if BEDTPIFeeType'="" s Code=$p($g(^PAC("FEETP",BEDTPIFeeType)),"^",1)
					//if Code'="A" continue
					s BEDTPIARCIMDR=$p($g(^PAC("BEDTP",BEDBedTypeDR,"FEE",BEDTPIChildsub)),"^",2)
					s BEDTPIStartDate=$p($g(^PAC("BEDTP",BEDBedTypeDR,"FEE",BEDTPIChildsub)),"^",3)
					s BEDTPIEndDate=$p($g(^PAC("BEDTP",BEDBedTypeDR,"FEE",BEDTPIChildsub)),"^",4)
					if ((BEDTPIStartDate'="")&&(BEDTPIStartDate<=+$h))&&((BEDTPIEndDate="")||((BEDTPIEndDate'="")&&(BEDTPIEndDate>=+$h)))
					{
						s Price1=..GetOrderPrice(BEDTPIARCIMDR)
						s Price=Price1+Price
					}
				}
			}
	
		}
	}
	q Price
}

/// 2017-10-13--不用了
/// 获取床位不同性别的病人在同一房间的描述
/// w ##class(web.DHCBL.BDP.BDPDataExport).GetDspValue(xparref,xrowid)
ClassMethod GetDspValue(xparref, xrowid) As %String
{
	n (xparref,xrowid)
	q:(xparref="")||(xrowid="") ""
	s ROOMDifferentSexPatients=""
	s RoomId=$p($g(^PAWARD(xparref,"BED",xrowid)),"^",3)
	
	if RoomId'=""
	{
		s ROOMDifferentSexPatients=$p($g(^PAROOM(RoomId)),"^",4)
		s ROOMDifferentSexPatients=$CASE(ROOMDifferentSexPatients,"D":"Does Not Matter","W":"Warning","N":"Not Allowed",:"")
	}
	
	q ROOMDifferentSexPatients
}

/// Creator:陈莹
/// CreatDate:2019-05-10
/// Description:获取频次分发时间
/// w ##class(web.DHCBL.BDP.BDPDataExport).GetPHCDTTime("5")
ClassMethod GetPHCDTTime(PHCFRRowId) As %String
{
	n (PHCFRRowId,PropertyName)
	s value=""
	s PHCDTChildSub=0
	for
	{
		s PHCDTChildSub=$o(^PHCFR(PHCFRRowId,"DT",PHCDTChildSub)) q:PHCDTChildSub=""
		i (PHCDTChildSub>0)
		{
			s PHCDTTime=$p($g(^PHCFR(PHCFRRowId,"DT",PHCDTChildSub)),"^",1)
			if (PHCDTTime'="")
			{
				s PHCDTTime=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(PHCDTTime)
				if value=""
				{
					s value=PHCDTTime
					
				}
				else
				{
					s value=value_"/"_PHCDTTime
				}
			
			}
		}
	}
	q value
}

/// Creator:陈莹
/// CreatDate:2019-05-10
/// Description:获取频次分发时间描述
/// w ##class(web.DHCBL.BDP.BDPDataExport).GetPHCDTTimeDesc("5")
ClassMethod GetPHCDTTimeDesc(PHCFRRowId) As %String
{
	n (PHCFRRowId,PropertyName)
	s value=""
	s PHCDTChildSub=0
	for
	{
		s PHCDTChildSub=$o(^PHCFR(PHCFRRowId,"DT",PHCDTChildSub)) q:PHCDTChildSub=""
		i (PHCDTChildSub>0)
		{
			s PHCDTTimeDesc=$p($g(^PHCFR(PHCFRRowId,"DT",PHCDTChildSub)),"^",2)
			if value=""
			{
				s value=PHCDTTimeDesc
				
			}
			else
			{
				s value=value_"/"_PHCDTTimeDesc
			}
			
		}
	}
	q value
}

/// Creator:陈莹
/// CreatDate:2019-10-24
/// Description:获取科室描述，去掉科室前面的简拼
/// Other:w ##class(web.DHCBL.BDP.BDPDataExport).GetCTLocDescByRowId(1)
ClassMethod GetCTLocDescByRowId(RowId) As %String
{
	n (RowId)
	q:RowId="" ""
	s Desc=$p($g(^CTLOC(RowId)),"^",2)
	s Desc=$tr(Desc,"/","")
	if Desc["-" s Desc=$p(Desc,"-",2)    //去掉科室前面的简拼
	q Desc
}

/// Creator:陈莹
/// CreatDate:2019-10-30
/// Description:获取安全组描述，如果有新的安全组对照就取新安全组的名称
/// Other:w ##class(web.DHCBL.BDP.BDPDataExport).GetSSGRPDescByRowId(1)
ClassMethod GetSSGRPDescByRowId(RowId) As %String
{
	n (RowId)
	q:RowId="" ""
	s Desc=$p($g(^SSU("SSGRP",RowId)),"^",1)
	s Desc=$tr(Desc,"/","")
	if Desc'=""
	{
		if $D(^TMPSSGROUPCONTRAST(Desc)) S Desc=$G(^TMPSSGROUPCONTRAST(Desc))
	}
	q Desc
}

/*
/// Creator:陈莹
/// CreatDate:2017-10-10
/// Description:返回一条数据的科室 或者安全组
/// Other:w ##class(web.DHCBL.BDP.BDPDataExport).GetSSUserProValueByRowId(1,"DeptLoc","ID")
/// 配置##class(web.DHCBL.BDP.BDPDataExport).GetSSUserProValueByRowId(SSUSRRowId,"DeptLoc")
/// 改名GetSSUserProValueByRowId
ClassMethod GetSSUserProValueByRowId(RowId, ProName, Label As %String = "") As %String
{
	n (ProName,RowId,Label)
	s value=""
	Q:(RowId="")||(ProName="") ""
	if (ProName="DeptLoc")||(ProName="SSUSRGroup")  //科室  安全组
	{
		
		// 处理数据，去重，去掉无效数据
		k ArrayLOCSGroup
		s DefCTLOC=$p($g(^SSU("SSUSR",RowId)),"^",4)
		s DefSSGroup=$p($g(^SSU("SSUSR",RowId)),"^",5)
		s ChildSub =0
		for
		{
			s ChildSub=$o(^SSU("SSUSR",RowId,"OTHLL",ChildSub)) q:ChildSub=""
			s OTHLLStartDate=$p($g(^SSU("SSUSR",RowId,"OTHLL",ChildSub)),"^",4)
			s OTHLLEndDate=$p($g(^SSU("SSUSR",RowId,"OTHLL",ChildSub)),"^",5)
			continue:(OTHLLEndDate'="")&&(OTHLLEndDate<+$h)
			s OTHLLCTLOCDR=$p($g(^SSU("SSUSR",RowId,"OTHLL",ChildSub)),"^",1)
			s OTHLLUserGroupDR=$p($g(^SSU("SSUSR",RowId,"OTHLL",ChildSub)),"^",2)
			continue:OTHLLCTLOCDR=""
			continue:OTHLLUserGroupDR=""
	  		if '((DefCTLOC=OTHLLCTLOCDR)&&(DefSSGroup=OTHLLUserGroupDR))
	  		{
	  			s ArrayLOCSGroup(OTHLLCTLOCDR,OTHLLUserGroupDR)=""  //其他登录科室
	  			
	  		}
		}
		if ProName="DeptLoc"  //科室
		{
			if (DefCTLOC'="")
			{
				IF Label="ID"
				{
					s value=DefCTLOC
				}
				else
				{
					s value=##class(web.DHCBL.BDP.BDPDataExport).GetCTLocDescByRowId(DefCTLOC)
				}
			}
		}
		if ProName="SSUSRGroup"   //安全组	
		{
			if (DefSSGroup'="")
			{
				s value=##class(web.DHCBL.BDP.BDPDataExport).GetSSGRPDescByRowId(DefSSGroup)
			}
		}
		s CTLOC =0
		for
		{
			s CTLOC=$o(ArrayLOCSGroup(CTLOC)) q:CTLOC=""
			s SSGroup =0
			for
			{
				s SSGroup=$o(ArrayLOCSGroup(CTLOC,SSGroup)) q:SSGroup=""
				if ProName="DeptLoc"  //科室
				{
					IF Label="ID"
					{
						s Desc=CTLOC
					}
					else
					{
						s Desc=##class(web.DHCBL.BDP.BDPDataExport).GetCTLocDescByRowId(CTLOC)
					}
			  		s value=value_"/"_Desc
				}
				if ProName="SSUSRGroup"   //安全组
				{
					s Desc=##class(web.DHCBL.BDP.BDPDataExport).GetSSGRPDescByRowId(SSGroup)
					s value=value_"/"_Desc
				}
			}
		}
	}
	q value
}
*/
/// Creator:陈莹
/// CreatDate:2017-10-10
/// Description:返回一条数据的科室 或者安全组
/// Other:w ##class(web.DHCBL.BDP.BDPDataExport).GetSSUserProValueByRowId(1,"DeptLoc","ID","UC")
/// 配置 ##class(web.DHCBL.BDP.BDPDataExport).GetSSUserProValueByRowId(URowId,"DeptLoc","",SSType)
/// 改名GetSSUserProValueByRowId
ClassMethod GetSSUserProValueByRowId(RowId, ProName, Label As %String = "", SSType As %String = "")
{
	n (ProName,RowId,Label,SSType)
	s value=""
	Q:((RowId="")&&(CTPCPRowId=""))||(ProName="") ""
	if (SSType'="C")
	{
		if (ProName="DeptLoc")||(ProName="SSUSRGroup")  //科室  安全组
		{
		
			// 处理数据，去重，去掉无效数据
			k ArrayLOCSGroup
			s DefCTLOC=$p($g(^SSU("SSUSR",RowId)),"^",4)
			s DefSSGroup=$p($g(^SSU("SSUSR",RowId)),"^",5)
			s ChildSub =0
			for
			{
				s ChildSub=$o(^SSU("SSUSR",RowId,"OTHLL",ChildSub)) q:ChildSub=""
				s OTHLLStartDate=$p($g(^SSU("SSUSR",RowId,"OTHLL",ChildSub)),"^",4)
				s OTHLLEndDate=$p($g(^SSU("SSUSR",RowId,"OTHLL",ChildSub)),"^",5)
				continue:(OTHLLEndDate'="")&&(OTHLLEndDate<+$h)
				s OTHLLCTLOCDR=$p($g(^SSU("SSUSR",RowId,"OTHLL",ChildSub)),"^",1)
				s OTHLLUserGroupDR=$p($g(^SSU("SSUSR",RowId,"OTHLL",ChildSub)),"^",2)
				continue:OTHLLCTLOCDR=""
				continue:OTHLLUserGroupDR=""
		  		if '((DefCTLOC=OTHLLCTLOCDR)&&(DefSSGroup=OTHLLUserGroupDR))
		  		{
		  			s ArrayLOCSGroup(OTHLLCTLOCDR,OTHLLUserGroupDR)=""  //其他登录科室
	  			
		  		}
			}
			if ProName="DeptLoc"  //科室
			{
				if (DefCTLOC'="")
				{
					IF Label="ID"
					{
						s value=DefCTLOC
					}
					else
					{
						s value=##class(web.DHCBL.BDP.BDPDataExport).GetCTLocDescByRowId(DefCTLOC)
					}
				}
			}
			if ProName="SSUSRGroup"   //安全组	
			{
				if (DefSSGroup'="")
				{
					s value=##class(web.DHCBL.BDP.BDPDataExport).GetSSGRPDescByRowId(DefSSGroup)
				}
			}
			s CTLOC =0
			for
			{
				s CTLOC=$o(ArrayLOCSGroup(CTLOC)) q:CTLOC=""
				s SSGroup =0
				for
				{
					s SSGroup=$o(ArrayLOCSGroup(CTLOC,SSGroup)) q:SSGroup=""
					if ProName="DeptLoc"  //科室
					{
						IF Label="ID"
						{
							s Desc=CTLOC
						}
						else
						{
							s Desc=##class(web.DHCBL.BDP.BDPDataExport).GetCTLocDescByRowId(CTLOC)
						}
				  		s value=value_"/"_Desc
					}
					if ProName="SSUSRGroup"   //安全组
					{
						s Desc=##class(web.DHCBL.BDP.BDPDataExport).GetSSGRPDescByRowId(SSGroup)
						s value=value_"/"_Desc
					}
				}
			}
		}
	}
	ELSE
	{
		if (ProName="DeptLoc")&&(SSType="C")
		{
			s CTLOCDR=0
			for
			{  
				s CTLOCDR=$o(^RB("RES",0,"CTPCP",RowId,CTLOCDR)) q:CTLOCDR="" 
				s RESRowId1=0
				for
				{  
					s RESRowId1=$o(^RB("RES",0,"CTPCP",RowId,CTLOCDR,RESRowId1)) q:RESRowId1=""  
					s RESDateActiveFrom=$p($g(^RB("RES",RESRowId1)),"^",22)
					s RESDateActiveTo=$p($g(^RB("RES",RESRowId1)),"^",23)
					continue:(RESDateActiveTo'="")&&(RESDateActiveTo<+$h)
					s RESCTLOCDR=$p($g(^RB("RES",RESRowId1)),"^",1)       //科室ID
					IF Label="ID"
					{
						s Desc=RESCTLOCDR
					}
					else
					{
						s Desc=##class(web.DHCBL.BDP.BDPDataExport).GetCTLocDescByRowId(RESCTLOCDR)
					}
			  		s:value'="" value=value_"/"_Desc
				  	s:value="" value=Desc
				}
			}
			
		}
		
	}
	q value
}

/// Creator:陈莹
/// CreatDate:2020-05-15
/// Description:返回医护人员的关联管制药品分类，/分隔
/// Input:医护人员rowid
/// Output:医护人员的关联管制药品分类，/分隔
/// Other:w ##class(web.DHCBL.BDP.BDPDataExport).GetCTCareProvPHCPoison(1)
ClassMethod GetCTCareProvPHCPoison(CTPCPRowId) As %String
{
	n (CTPCPRowId)
	s value=""
	Q:(CTPCPRowId="") ""
	s CPPChildsub=0
	for
	{
		s CPPChildsub=$o(^CTPCP(CTPCPRowId,"CPP",CPPChildsub)) q:CPPChildsub=""
		s CPPPHCPoisonDR=$p($g(^CTPCP(CTPCPRowId,"CPP",CPPChildsub)),"^",1)
		s:CPPPHCPoisonDR'="" CPPPHCPoisonDR=$p($g(^PHCPO(CPPPHCPoisonDR)),"^",2)
		if (value="")
		{
			s value=CPPPHCPoisonDR
		}
		else
		{
			s value=value_"/"_CPPPHCPoisonDR
		}
	}
	q value
}

/// Creator:陈莹
/// CreatDate:2017-10-10
/// Description:返回一条数据的别名（BDPAlias）
/// Other:w ##class(web.BDPExt.SSUserBLL).GetDataAliasByRowId(URowId,SSType)
/// 改名GetSSUserDataAliasByRowId
ClassMethod GetSSUserDataAliasByRowId(URowId, SSType) As %String
{
	n (URowId,SSType)
	Q:URowId="" ""
	s ALIASText1=""
	if SSType["U"
	{
		s AliasRowId=0
		for
		{
			s AliasRowId=$o(^User.BDPAliasI("DataRef","SS_User",URowId,AliasRowId))
			q:AliasRowId=""
			s ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
			if ALIASText1'="" s ALIASText1=ALIASText1_"/"_ALIASText
			else  s ALIASText1=ALIASText
		}
		s SSUSRCareProvDR=$p($g(^SSU("SSUSR",URowId)),"^",14)
		if SSUSRCareProvDR'=""
		{
			
			s AliasRowId=0
			for
			{
				s AliasRowId=$o(^User.BDPAliasI("DataRef","CT_CareProv",SSUSRCareProvDR,AliasRowId))
				q:AliasRowId=""
				s ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
				if ALIASText1'="" s ALIASText1=ALIASText1_"/"_ALIASText
				else  s ALIASText1=ALIASText
			}
		
		}
		
	}
	
	if SSType="C"
	{
		s AliasRowId=0
		for
		{
			s AliasRowId=$o(^User.BDPAliasI("DataRef","CT_CareProv",URowId,AliasRowId))
			q:AliasRowId=""
			s ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
			if ALIASText1'="" s ALIASText1=ALIASText1_"/"_ALIASText
			else  s ALIASText1=ALIASText
		}
	}
	
	
	
	q ALIASText1
}

/// Creator:陈莹
/// CreatDate:2021-05-26
/// Description:返回一条数据的开始日期 结束日期 
/// Other:w ##class(web.DHCBL.BDP.BDPDataExport).GetSSUserDateByRowId(URowId,SSType,"SSUSRDateFrom")
ClassMethod GetSSUserDateByRowId(URowId, SSType, Label) As %String
{
	n (URowId,SSType,Label)
	Q:URowId="" ""
	s value=""
	if SSType["U"
	{
		if Label="SSUSRDateFrom" s value=$p($g(^SSU("SSUSR",URowId)),"^",96)    //开始日期
		if Label="SSUSRDateTo" s value =$p($g(^SSU("SSUSR",URowId)),"^",97)  //结束日期	
	}
	if SSType="C"
	{
		if Label="SSUSRDateFrom" s value=$p($g(^CTPCP(URowId,2)),"^",14)    //开始日期
		if Label="SSUSRDateTo" s value=$p($g(^CTPCP(URowId,2)),"^",15)     //结束日期	
	}
	q value
}

/// Creator:陈莹
/// CreatDate:2019-10-23
/// Description:获取ICD诊断数据的别名
/// Other:w ##class(web.DHCBL.BDP.BDPDataExport).GetMRCIDDataAliasByRowId(MRCIDRowId)
/// 改名GetSSUserDataAliasByRowId
ClassMethod GetMRCIDDataAliasByRowId(MRCIDRowId) As %String
{
	n (MRCIDRowId)
	Q:MRCIDRowId="" ""
	s ALIASText1=""
	s ALIASChildsub=0
	for {
		s ALIASChildsub=$o(^MRC("ID",MRCIDRowId,"ALIAS",ALIASChildsub)) q:ALIASChildsub=""
		s ALIASText=$g(^MRC("ID",MRCIDRowId,"ALIAS",ALIASChildsub))
		if ALIASText1'="" s ALIASText1=ALIASText1_"&"_ALIASText
		else  s ALIASText1=ALIASText
	}
	
	q ALIASText1
}

/// Creator:陈莹
/// CreatDate:2019-10-23
/// Description:获取手术数据的别名
/// Other:w ##class(web.DHCBL.BDP.BDPDataExport).GetOPERDataAliasByRowId(OPERRowId)
/// 改名GetSSUserDataAliasByRowId
ClassMethod GetOPERDataAliasByRowId(OPERRowId) As %String
{
	n (OPERRowId)
	Q:OPERRowId="" ""
	s ALIASText1=""
	s ALIASChildsub=0
	for
	{
		s ALIASChildsub=$o(^ORC("OPER",OPERRowId,"ALIAS",ALIASChildsub)) q:ALIASChildsub=""
		s ALIASText=$p($g(^ORC("OPER",OPERRowId,"ALIAS",ALIASChildsub)),"^",1)
		if ALIASText1'="" s ALIASText1=ALIASText1_"&"_ALIASText
		else  s ALIASText1=ALIASText
	}
	q ALIASText1
}

/// Creator:陈莹
/// CreatDate:2019-09-14
/// Description:获取排班预约信息（方式|限额|起始号）--改成（预约方式|最大预约数|保留数）
/// Other:w ##class(web.DHCBL.BDP.BDPDataExport).GetAppMethodStr(RESRowId,DATEChildSub,SESSChildsub)
ClassMethod GetAppMethodStr(RESRowId, DATEChildSub, SESSChildsub) As %String
{
	n (RESRowId,DATEChildSub,SESSChildsub)
	//预约方式信息（方式|限额|起始号）
	/*s ret=""
	s AQSub=0
	for
	{
		s AQSub=$o(^RB("RES",RESRowId,"Date",DATEChildSub,"SESS",SESSChildsub,"AQ",AQSub)) q:AQSub=""
		Set AQMethodDR=$p($g(^RB("RES",RESRowId,"Date",DATEChildSub,"SESS",SESSChildsub,"AQ",AQSub)),"^",1)  //方式
		Set AQQty=$p($g(^RB("RES",RESRowId,"Date",DATEChildSub,"SESS",SESSChildsub,"AQ",AQSub)),"^",2)   //限额
		Set AQStartNum=$p($g(^RB("RES",RESRowId,"Date",DATEChildSub,"SESS",SESSChildsub,"AQ",AQSub)),"^",3)  //起始号
		
		if AQMethodDR'="" s AQMethodDR=$p($g(^RBC("APTM",AQMethodDR)),"^",2)
		s str=AQMethodDR_"|"_AQQty_"|"_AQStartNum
		if ret="" s ret=str
		else  s ret=ret_"&"_str
	}*/
	//2021-01-21 改成预约方式信息（预约方式|最大预约数|保留数）
	
	s ret=""
	s AQSub=0
	for
	{
		s AQSub=$o(^RB("RES",RESRowId,"Date",DATEChildSub,"SESS",SESSChildsub,"AQ",AQSub)) q:AQSub=""
		Set AQMethodDR=$p($g(^RB("RES",RESRowId,"Date",DATEChildSub,"SESS",SESSChildsub,"AQ",AQSub)),"^",1)  //方式
		Set AQMaxQty=$p($g(^RB("RES",RESRowId,"Date",DATEChildSub,"SESS",SESSChildsub,"AQ",AQSub)),"^",4)  //最大预约数
		Set AQQty=$p($g(^RB("RES",RESRowId,"Date",DATEChildSub,"SESS",SESSChildsub,"AQ",AQSub)),"^",2)   //保留数
		
		if AQMethodDR'="" s AQMethodDR=$p($g(^RBC("APTM",AQMethodDR)),"^",2)
		s str=AQMethodDR_"|"_AQMaxQty_"|"_AQQty
		if ret="" s ret=str
		else  s ret=ret_"&"_str
	}
	
	q ret
}

/// Creator:陈莹
/// CreatDate:2023-02-21
/// Description:获取排班模板亚专业（id1,id2,id3对应的描述)
/// Other:w ##class(web.DHCBL.BDP.BDPDataExport).GetCLGRPDesc(RESRowId,DATEChildSub,SESSChildsub)
ClassMethod GetCLGRPDesc(RESRowId, DATEChildSub, SESSChildsub) As %String
{
	n (RESRowId,DATEChildSub,SESSChildsub)
	s ret=""
	//$p($g(^RB("RES",RESRowId,"DATE",DATEChildSub,"SESS",SESSChildsub)),"^",35)
	//$p($g(^RBC("CLGRP",CLGRPDesc)),"^",2)
	s DefCLGRPID=$p($g(^RB("RES",RESRowId,"DATE",DATEChildSub,"SESS",SESSChildsub)),"^",35)
	if (DefCLGRPID'="")
	{
		s DefCLGRPIDs=$p($g(^RB("RES",RESRowId,"DATE",DATEChildSub,"SESS",SESSChildsub)),"^",42)  //id1,id2
		if (DefCLGRPIDs'="")
		{
			s length=$l(DefCLGRPIDs,",")
			for IDi=1:1:length
			{
				s ID=$p(DefCLGRPIDs,",",IDi)
				s Desc=$p($g(^RBC("CLGRP",ID)),"^",2)
				if ret="" s ret=Desc
				else  s ret=ret_","_Desc
			}
		}
		else
		{
			s ret=$p($g(^RBC("CLGRP",DefCLGRPID)),"^",2)
		}
	}
	q ret
}

/// Creator:陈莹
/// CreatDate:2019-04-12
/// Description:获取医嘱套 对应的代码，名称的值（医嘱项T，医嘱套A)
/// w ##class(web.DHCBL.BDP.BDPDataExport).GetARCOSValueByType(ARCOSRowId, DATEChildSub, ChildSub,Type,"Code")
ClassMethod GetARCOSValueByType(ARCOSRowId, DATEChildSub, ChildSub, Type, Property) As %String
{
	n (ARCOSRowId, DATEChildSub, ChildSub, Type, Property)
	s value=""
	if (Type["医嘱项")||(Type["T") //TIM
	{
		
		if Property="Code"
		{
			s ARCIMDR=$p($g(^ARCOS(ARCOSRowId,"DATE",DATEChildSub,"ITM",ChildSub)),"^",1)
			s:(($p(ARCIMDR,"||",1)'="")&&($p(ARCIMDR,"||",2)'="")) value=$p($g(^ARCIM($p(ARCIMDR,"||",1),$p(ARCIMDR,"||",2),1)),"^",1)
		}
		if Property="Desc"
		{
			s ARCIMDR=$p($g(^ARCOS(ARCOSRowId,"DATE",DATEChildSub,"ITM",ChildSub)),"^",1)
			
			s:(($p(ARCIMDR,"||",1)'="")&&($p(ARCIMDR,"||",2)'="")) value=$p($g(^ARCIM($p(ARCIMDR,"||",1),$p(ARCIMDR,"||",2),1)),"^",2)	
		}
		if Property="EffDate"
		{
			s ARCIMDR=$p($g(^ARCOS(ARCOSRowId,"DATE",DATEChildSub,"ITM",ChildSub)),"^",1)
			s:(($p(ARCIMDR,"||",1)'="")&&($p(ARCIMDR,"||",2)'="")) value=$p($g(^ARCIM($p(ARCIMDR,"||",1),$p(ARCIMDR,"||",2),1)),"^",13)
			s value=$p(value,"Z",1)
			s value=$p(value,",",1)
		}
		if Property="EffDateTo"
		{
			s ARCIMDR=$p($g(^ARCOS(ARCOSRowId,"DATE",DATEChildSub,"ITM",ChildSub)),"^",1)
			s:(($p(ARCIMDR,"||",1)'="")&&($p(ARCIMDR,"||",2)'="")) value=$p($g(^ARCIM($p(ARCIMDR,"||",1),$p(ARCIMDR,"||",2),7)),"^",1)
			s value=$p(value,"Z",1)
			s value=$p(value,",",1)
		}	
		if Property="Specimen" //标本
		{
			s SampleID=$p($G(^ARCOS(ARCOSRowId,"DATE",DATEChildSub,"ITM",ChildSub,"DHC")),"^",2)  ///存的是标本代码，而不是id
			s HOSPID=""
			i ($d(%session)) s HOSPID=$G(%session.Get("LOGON.HOSPID"))
			s:HOSPID="" HOSPID=$o(^CT("HOSP",0))
			S HOSPCode=$p($G(^CT("HOSP",HOSPID)),"^",1)
			i $d(^DHCLISBSVersion(1))&&(SampleID'="")
			{
				s HOSPID=$o(^dbo.BTHospitalI("IndexCode",##Class(web.DHCBL.BDP.FunLib).IndexData(HOSPCode),""))
				i (HOSPID="") s HOSPID = $o(^dbo.BTHospitalD(""))
				i (HOSPID'="")
				{
					s SpecimenDR=$o(^dbo.BTSpecimenI("IndexCode",HOSPID,##Class(web.DHCBL.BDP.FunLib).IndexData(SampleID),""))
					s:SpecimenDR'="" value=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),3)
				}
			}
			else
			{
				s:SampleID'="" value=$p($G(^TTAB("SPEC",SampleID)),"\",1)
				s:SampleID="" value=""
			}
		}
		if Property="Remarks" //附加说明
		{
			s value=$p($G(^ARCOS(ARCOSRowId,"DATE",DATEChildSub,"ITM",ChildSub,"DHC")),"^",3)
			s value=$CASE(value,"ONE":"取药医嘱","OUT":"出院带药","PRN":"PRN","OM":"自备药","ZT":"嘱托",:"")
		}
		
		if Property="ITMStage" //医嘱阶段
		{
			s value=$p($g(^ARCOS(ARCOSRowId,"DATE",DATEChildSub,"ITM",ChildSub)),"^",22)
			s value=$CASE(value,"SQ":"术前","SZ":"术中","SH":"术后","CZ":"产中",:"")
		}
		
	}
	if (Type="医嘱套")||(Type["O") //OS
	{
		
		if Property="Code"
		{
			s OSOrderSetDR=$p($g(^ARCOS(ARCOSRowId,"DATE",DATEChildSub,"OS",ChildSub)),"^",1)
			s:OSOrderSetDR'="" value=$p($g(^ARCOS(OSOrderSetDR)),"^",1)
		}
		if Property="Desc"
		{
			s OSOrderSetDR=$p($g(^ARCOS(ARCOSRowId,"DATE",DATEChildSub,"OS",ChildSub)),"^",1)
			s:OSOrderSetDR'="" value=$p($g(^ARCOS(OSOrderSetDR)),"^",2)
			 
		}
		if Property="EffDate"
		{
			s OSOrderSetDR=$p($g(^ARCOS(ARCOSRowId,"DATE",DATEChildSub,"OS",ChildSub)),"^",1)
			s:OSOrderSetDR'="" value=$p($g(^ARCOS(OSOrderSetDR)),"^",15)
			s value=$p(value,"Z",1)
			s value=$p(value,",",1)	
		}
		if Property="EffDateTo"
		{
			s OSOrderSetDR=$p($g(^ARCOS(ARCOSRowId,"DATE",DATEChildSub,"OS",ChildSub)),"^",1)
			s:OSOrderSetDR'="" value=$p($g(^ARCOS(OSOrderSetDR)),"^",16)
			s value=$p(value,"Z",1)
			s value=$p(value,",",1)
		}
	}
	q value
}

/// Creator：陈莹 
/// CreatDate: 2019-10-21
/// Description：输出升级项目数据导出菜单
/// Table：User.BDPEIMenu
/// w ##class(web.DHCBL.BDP.BDPDataExport).WriteMenu("CatTreeRoot")
ClassMethod WriteMenu(id) As %String
{
	n (id)
	if (id="CatTreeRoot")||(id="") s id=-100000000000000
	s mySMRowID=0
	s myMenuCount=0
	s mySMSeq=0
	k myMenuArray

	//生成菜单索引数组
	s mySMSeq=0
	s n=0
	for {
		s mySMSeq=$o(^User.BDPEIMenuI("ParSeqIdx",id,mySMSeq))
		q:(mySMSeq="")
		s n=n+1
		s a(n)= $p(mySMSeq," ",2)
	}
	set left=1,right=n
	d:$d(a) ##class(web.DHCBL.BDP.FunLib).QuickSort(.a,left,right) //排序
	s mySMRowID=0
	s n=0
	s mySMSeq=0
	for {
		s n=$o(a(n)) q:(n="")
		s mySMSeq=$g(a(n))
		for {
			s mySMRowID=$o(^User.BDPEIMenuI("ParSeqIdx",id," "_mySMSeq,mySMRowID)) q:(mySMRowID="")
			s myMenuCount=myMenuCount+1
			s myMenuArray(myMenuCount)=mySMRowID
			;w !,mySMRowID
		}
	}
	s mySMRowID=0
	s myMenuSeq=0
	s myJsonStr=""
	for {
		s myMenuSeq=$o(myMenuArray(myMenuSeq)) q:(myMenuSeq="")
		s mySMRowID=$g(myMenuArray(myMenuSeq))
		continue:$LISTGET($G(^User.BDPEIMenuD(mySMRowID)),11)'="Y"  //判断是否在导出里显示
		
		if id=-100000000000000
		{
			w "<option style=""background-color:yellow;font-size:22px"" value="""">"_$LISTGET($G(^User.BDPEIMenuD(mySMRowID)),2)_$LISTGET($G(^User.BDPEIMenuD(mySMRowID)),3)_"</option>"	
		}
		else
		{
			if ($d(^User.BDPEIMenuI("ParMenuIdx",mySMRowID))=0)  //地理信息为3级菜单，第二级菜单改成不显示
			{
				w "<option value="""_$LISTGET($G(^User.BDPEIMenuD(mySMRowID)),2)_""">"_$LISTGET($G(^User.BDPEIMenuD(mySMRowID)),3)_"</option>"
			}
		}
		//判断是否有子菜单
		if ($d(^User.BDPEIMenuI("ParMenuIdx",mySMRowID))>0)
		{
			d ..WriteMenu(mySMRowID)
		}
		
	}
	q ""
}

/// terminal测试数据导出
/// Other: d ##class(web.DHCBL.BDP.BDPDataExport).TestGetFieldValue("PHC_DrgMastNew")
ClassMethod TestGetFieldValue(tablename) As %String
{
	w ##class(web.DHCBL.BDP.BDPDataExport).GetTableDesc(tablename)
	w ##class(web.DHCBL.BDP.BDPDataExport).GetDataCount(tablename),!
	s mySysID =$s($d(%session):%session.%Id(),1:$j)
	s i=0
	for
	{
		s i=$o(^TMPEXCELEXPORT(mySysID,tablename,i)) q:i=""
		w ##class(web.DHCBL.BDP.BDPDataExport).GetFieldValue(tablename,i),!
		
	}
}

/// terminal测试数据导出-V2 导入导出配置合并以后的导出功能
/// Other: d ##class(web.DHCBL.BDP.BDPDataExport).TestGetFieldValueV2("PHC_DrgMastNew")
ClassMethod TestGetFieldValueV2(tablename) As %String
{
	w ##class(web.DHCBL.BDP.BDPDataExport).GetTempletFieldDescV2(tablename)
	w ##class(web.DHCBL.BDP.BDPDataExport).GetTableDesc(tablename)
	w ##class(web.DHCBL.BDP.BDPDataExport).GetDataCountV2(tablename),!
	s mySysID =$s($d(%session):%session.%Id(),1:$j)
	s i=0
	for
	{
		s i=$o(^TMPEXCELEXPORT(mySysID,tablename,i)) q:i=""
		w ##class(web.DHCBL.BDP.BDPDataExport).GetFieldValueV2(tablename,i),!
		
	}
}

/// Creator:陈莹
/// CreatDate:2019-12-01
/// Description:查询 安全组及对照数据
/// Table:User.SSGroup
/// Input:rowid,desc
/// Return:SSGRPRowId,SSGRPDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPDataExport","GetConSSGroupList","","demo")
Query GetConSSGroupList(desc As %String, condesc As %String) As %Query(ROWSPEC = "SSGRPDesc:%String,SSGRPConDesc:%String,SSGRPUsedFlag:%String")
{
}

ClassMethod GetConSSGroupListExecute(ByRef qHandle As %Binary, desc As %String, condesc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	s:desc'="" desc=$ZCONVERT(desc,"U")
	s:condesc'="" condesc=$ZCONVERT(condesc,"U")
	s SSGRPRowId=0
	for
	{
		s SSGRPRowId=$o(^SSU("SSGRP",SSGRPRowId)) q:SSGRPRowId=""
		s SSGRPDesc=$p($g(^SSU("SSGRP",SSGRPRowId)),"^",1)
		s SSGRPConDesc=$p($g(^TMPSSGROUPCONTRAST(SSGRPDesc)),"^",1)	//安全组对照描述 update 2019-11-4 钟荣枫
		s UsedFlagStr=1 //..SSGroupGetRefFlag(SSGRPRowId)		//安全组是否被引用标志
		s SSGRPUsedFlag=$p(UsedFlagStr,"^",1)
		s:SSGRPUsedFlag=1 SSGRPUsedFlag="Y"
		s:SSGRPUsedFlag=0 SSGRPUsedFlag="N"
		s PINYIN=""
		if (desc'="")  s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(SSGRPDesc)
		s CONPINYIN=""
		if (condesc'="")  s CONPINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(SSGRPConDesc)
		if ((PINYIN[desc)||($ZCVT(SSGRPDesc,"U")[desc))&&((CONPINYIN[condesc)||($ZCVT(SSGRPConDesc,"U")[condesc))
		{
			d OutputRowContrastSSGroup
			
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowContrastSSGroup
    set Data=$lb(SSGRPDesc,SSGRPConDesc,SSGRPUsedFlag)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetConSSGroupListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetConSSGroupListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetConSSGroupListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetConSSGroupListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:陈莹
/// CreatDate:2013-8-21
/// Description:安全组删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod SSGroupGetRefFlag(id As %String) As %String
{
	n (id)
	s return="",myInfo=""
	//用户表SS_User.安全组主菜单设置表epr.GroupSettings中
	if ($d(^SSU("SSUSR",0,"Group",id))'=0)
	{
		s flag=1
		s myInfo=myInfo_"<用户>"
	}
	s RowId=0,flag=0
	for
	{
		s RowId=$o(^SSU("SSUSR",RowId)) q:(RowId="")||(flag=1)  d
		s SUB=0
		for
		{
			s SUB=$o(^SSU("SSUSR",RowId,"OTHLL",SUB)) q:(SUB="")||(flag=1)  d
			s GroupDR=$P($G(^SSU("SSUSR",RowId,"OTHLL",SUB)),"^",2)
			i (GroupDR=id)
			{
				s flag=1
			}
		}
	}
	if flag=1 s myInfo=myInfo_"<用户其他登录科室>"
	
	s RowId=0,flag=0
	for
	{
		s RowId=$o(^ooGroupSettingsD(RowId)) q:(RowId="")||(flag=1)  d
		s GroupDR=$LISTGET($g(^ooGroupSettingsD(RowId)),4)
		i (GroupDR=id)
		{
			s flag=1
		}
	}
	if flag=1 s myInfo=myInfo_"<安全组主菜单设置表>"
	
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	q return
}

/// Creator:钟荣枫
/// CreatDate:2019-11-4
/// Description：用于修改安全组对照描述临时global
/// w ##class(web.DHCBL.CT.SSGroup).UpdateContrastGroup("门诊挂号【停用】","门诊挂号【停用】1")
/// 0 失败 1成功
ClassMethod UpdateContrastGroup(desc As %String, condesc As %String) As %String
{
	n (desc,condesc)
	q:desc="" 0
	s ^TMPSSGROUPCONTRAST(desc)=condesc
	q 1
}

///  Function:获取数据关联的医院信息
///  Type:"ID"或者空，取出医院rowid串，用/连接
///  Type:"Desc"   取出医院rowid名称串，用/连接 
///  Creator: chenying
///  CreateDate:2020-06-29
/// debug:   w ##class(web.DHCBL.BDP.BDPDataExport).GetHospital("SS_User",2,"Desc")
ClassMethod GetHospital(tableName As %String, BDPMPHDataReference As %String, Type As %String = "") As %String
{
    n (tableName,BDPMPHDataReference,Type)
    q:tableName="" ""
    q:BDPMPHDataReference="" ""
    s str=""
    s date=+$h
    s split="/"   //输出返回值连接符
    s dataid=BDPMPHDataReference
   	if (tableName="CT_Loc")   //科室，绝对私有
	{
		s CTLOCRowID=dataid
		s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22)     //医院
		
		s value=CTLOCHospitalDR
		if (Type="Desc")&&(value'="") s value=$p($g(^CT("HOSP",value)),"^",2)
		s str=value
	}
	elseif (tableName="PAC_Ward")  //病区 ，绝对私有
	{
		s WARDRowID=dataid
		s CTLOCRowID=$p($g(^PAWARD(WARDRowID)),"^",5)
		if (CTLOCRowID'="")
		{
			s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22)     //医院
			s value=CTLOCHospitalDR
			if (Type="Desc")&&(value'="") s value=$p($g(^CT("HOSP",value)),"^",2)
			s str=value
		}
	}
	elseif (tableName="PAC_Bed")   //床位 ，绝对私有
	{
		s WARDRowID=$p(dataid,"||",1)
		s CTLOCRowID=$p($g(^PAWARD(WARDRowID)),"^",5)
		if (CTLOCRowID'="")
		{
			s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22)     //医院
			s value=CTLOCHospitalDR
			if (Type="Desc")&&(value'="") s value=$p($g(^CT("HOSP",value)),"^",2)
			s str=value
		}
	}
	elseif (tableName="SS_User")  //用户 判断用户默认登录科室对应医院及用户其他登录科室对应医院
	{
		s SSUSRRowId=dataid
		s CTLOCIDs= ##class(web.DHCBL.BDP.BDPDataExport).GetSSUserProValueByRowId(SSUSRRowId,"DeptLoc","ID")
		for CTLOCIDi=1:1:$l(CTLOCIDs,"/")
		{
			s CTLOCID=$p(CTLOCIDs,"/",CTLOCIDi)
			S CTLOCHospitalDR=""
			if CTLOCID'="" s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCID)),"^",22)     //医院
			s value=CTLOCHospitalDR
			if (Type="Desc")&&(value'="") s value=$p($g(^CT("HOSP",value)),"^",2)
			if (CTLOCIDi=1) s str=value
			else  s str=str_split_value
		}
		
	}
	elseif tableName="CT_CareProv"  //医护人员，
	{
		s CTPCPRowId1=dataid
		s HOSPChildsub=0
		for
		{
			s HOSPChildsub=$o(^CTPCP(CTPCPRowId1,"HOSP",HOSPChildsub)) q:(HOSPChildsub="")
			s CTHospitalDR=$P($g(^CTPCP(CTPCPRowId1,"HOSP",HOSPChildsub)),"^",1)
			s value=CTHospitalDR
			if (Type="Desc")&&(value'="") s value=$p($g(^CT("HOSP",value)),"^",2)
			if str="" s str=value
			else  s str=str_split_value
		}
	}
	elseif (tableName="ARC_ItmMast") //医嘱项
	{
		S ARCIMSubscript=$P(dataid,"||",1)
		S ARCIMVersion=$P(dataid,"||",2)
		; 遍历 医院子表，查询医院dr 进行筛选
		s HospChildsub=0
		for
		{
			s HospChildsub=$o(^ARCIM(ARCIMSubscript,ARCIMVersion,"HOSP",HospChildsub)) q:(HospChildsub="")  
			s HOSPHospitalDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"HOSP",HospChildsub)),"^",1)  
			s value=HOSPHospitalDR
			if (Type="Desc")&&(value'="") s value=$p($g(^CT("HOSP",value)),"^",2)
			if str="" s str=value
			else  s str=str_split_value
		}
	}
	elseif (tableName="SS_Group") //安全组
	{
		S SSGRPRowId=dataid
		s HOSPChildsub=0
		for
		{
			s HOSPChildsub=$o(^SSU("SSGRP",SSGRPRowId,"HOSP",HOSPChildsub)) q:(HOSPChildsub="")
			s CTHospitalDR=$p($g(^SSU("SSGRP",SSGRPRowId,"HOSP",HOSPChildsub)),"^",1)
			s value=CTHospitalDR
			if (Type="Desc")&&(value'="") s value=$p($g(^CT("HOSP",value)),"^",2)
			if str="" s str=value
			else  s str=str_split_value
		}
	}
	elseif (tableName="INC_Itm") //库存项
	{
		//库存项表DHC_ItmAddHosp
		s HOSPHospitalDR=0
		for
		{
			s HOSPHospitalDR=$o(^ITMADDHOP(0,"HospInc",HOSPHospitalDR)) q:HOSPHospitalDR=""
			if $d(^ITMADDHOP(0,"HospInc",HOSPHospitalDR,dataid))>0
			{
				s value=HOSPHospitalDR
				if (Type="Desc")&&(value'="") s value=$p($g(^CT("HOSP",value)),"^",2)
				if str="" s str=value
				else  s str=str_split_value
			}
		}
		
	}
	elseif (tableName="PAC_Bed")   //床位 ，绝对私有
	{
		s WARDRowID=$p(dataid,"||",1)
		s CTLOCRowID=$p($g(^PAWARD(WARDRowID)),"^",5)
		if (CTLOCRowID'="")
		{
			s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22)     //医院
			s value=CTLOCHospitalDR
			if (Type="Desc")&&(value'="") s value=$p($g(^CT("HOSP",value)),"^",2)
			s str=value
		}
	}
	elseif (tableName="DHCExaBorough") //分诊区
	{
		s ExabHospitalDr=$LISTGET($g(^User.DHCExaBoroughD(dataid)),13)
		s value=ExabHospitalDr
		if (Type="Desc")&&(value'="") s value=$p($g(^CT("HOSP",value)),"^",2)
		s str=value
	}
	elseif (tableName="ARC_OrdSets") //医嘱套
	{
		s FavRowId=$o(^DHCFavItems(0,"ItemRowid",dataid,0))
		if FavRowId'=""
		{
			s FavUseHospDr=$p($g(^DHCFavItems(FavRowId)),"^",11)
			s value=FavUseHospDr
			if (Type="Desc")&&(value'="") s value=$p($g(^CT("HOSP",value)),"^",2)
			s str=value
		}
	}
	else
	{
		s myobj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCBL.BDP.BDPConfig"_"||"_"GetConfigValue")
	    i $IsObject(myobj)
	    {
	        s myobj=""
	        s HospAutflag = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut")  //获取平台配置是否开启医院级别授权
	    }
	    else
	    {
		    s HospAutflag = "N"
	    }
	    if HospAutflag = "Y"
		{
			s myobj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCBL.BDP.BDPMappingHOSP"_"||"_"GetDataType")
		    i $IsObject(myobj)
		    {
		        s myobj=""
		        s DataTypeFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDataType(tableName)	 //获取数据公有私有类型
		    }
		    else
		    {
			    s DataTypeFlag = "G"
		    }
			
			if (DataTypeFlag'="G")
			{
				if ($d(^User.BDPMappingHospI("HospRef",tableName,BDPMPHDataReference)))
			    {
			        s Hospital=0
			        for
			        {
			            s Hospital= $O(^User.BDPMappingHospI("HospRef",tableName,BDPMPHDataReference,Hospital)) q:Hospital=""
			            s value=Hospital
			            if Type="Desc" s value=$p($g(^CT("HOSP",Hospital)),"^",2)
						if str="" s str=value
						else  s str=str_split_value
			        }
			    }
			}
		}
	}
	
    q str
}

/// 根据医院楼层id(CT_Loc的CTLOCFloor字段的值)返回描述，导出用
/// 基础数据平台-likefan
/// input：医院楼层id
/// output：医院楼层描述
/// w ##class(web.DHCBL.BDP.BDPDataExport).GetFloorDescById("9||1")
ClassMethod GetFloorDescById(id) As %String
{
	n (id)
	q:id="" ""
	s resultDesc=""
	s CTLBFParRef=$p(id,"||",1)
	s CTLBFChildsub=$p(id,"||",2)
	q:(CTLBFParRef="")||(CTLBFChildsub="") ""
	s CTLBDesc=$p($g(^CT("CTLB",CTLBFParRef)),"^",2)	//医院楼描述
	s CTLBFFloor=$p($g(^CT("CTLB",CTLBFParRef,"Floor",CTLBFChildsub)),"^",1)  //楼层
	s resultDesc=CTLBDesc_"-"_CTLBFFloor
	q resultDesc
}

/// Creator:likefan
/// CreatDate:2020-05-15
/// Description:返回医护人员的关联处方权，/分隔
/// Input:医护人员rowid
/// Output:医护人员的关联处方权，/分隔
/// Other:w ##class(web.DHCBL.BDP.BDPDataExport).GetCTCareProvPrescriptSet(1)
ClassMethod GetCTCareProvPrescriptSet(CTPCPRowId)
{
	n (CTPCPRowId)
	s value=""
	Q:(CTPCPRowId="") ""
	s CPPSChildsub=0
	for
	{
		s CPPSChildsub=$o(^CTPCP(CTPCPRowId,"CPPS",CPPSChildsub)) q:CPPSChildsub=""
		s CPPSPrescriptSetDR=$p($g(^CTPCP(CTPCPRowId,"CPPS",CPPSChildsub)),"^",1)
		if (CPPSPrescriptSetDR'="") 
		{
			s PSDesc=$p($g(^DHCPRESCRIPTSET(CPPSPrescriptSetDR)),"^",2)
			s PSType=$p($g(^DHCPRESCRIPTSET(CPPSPrescriptSetDR)),"^",3)
			s PSActive=$p($g(^DHCPRESCRIPTSET(CPPSPrescriptSetDR)),"^",5)
			s PSHospDr=$p($g(^DHCPRESCRIPTSET(CPPSPrescriptSetDR)),"^",7)
			continue:PSActive="N"
			s HOSPDesc=""
			if (PSHospDr'="")
			{
				continue:('$d(^CT("HOSP",PSHospDr)))
				s HOSPDesc=$p($g(^CT("HOSP",PSHospDr)),"^",2)
			}
			//s:HOSPDesc'="" HOSPDesc="("_HOSPDesc_")"
			s:PSType="CM" PSType="草药"
			s:PSType="XM" PSType="西药"
			//s:PSType'="" PSDesc=PSDesc_"-"_PSType
			s:(PSDesc'="")&&(HOSPDesc'="") PSDesc=HOSPDesc_"-"_PSDesc
			s:(value'="")&&(PSDesc'="") value=value_"/"
			s value=value_PSDesc
		}
	}
	q value
}

/// //////////导出功能 -第二版/////////////////
/// Creator:陈莹 
/// CreatDate:2021-05-26
/// Description:导出时调用，工作簿名&%字段描述^字段name^是否必填0&#字段描述^字段name^是否必填1 ///按照顺序字段取字段信息，有维护顺序的排在前面，空的排在后面
/// Input:导出菜单对应的代码  
/// Other:w ##class(web.DHCBL.BDP.BDPDataExport).GetTempletFieldDescV2("SS_User")
/// Return:工作簿名&%字段描述1^字段name1^是否必填0&#字段描述2^字段name2^是否必填1
ClassMethod GetTempletFieldDescV2(table) As %String
{
	n (table)
	s IMCID=""
	s:table'="" table=$ZCONVERT(table,"U") //转换成大写
	s:table'="" IMCID=$o(^User.BDPIMConfigI("UniqueTableName"," "_table,0))

	q:IMCID="" ""
	
	S EIMenuID=$O(^User.BDPEIMenuI("UniqueCodeIndex"," "_$ZCVT(table,"U"),0))
	s IMCTableDesc=""
	s:EIMenuID'="" IMCTableDesc=$listget($g(^User.BDPEIMenuD(EIMenuID)),3)
	s IMCTableDesc=$tr(IMCTableDesc,"/","")
	s IMCTableDesc=$tr(IMCTableDesc,"\","")
	s IMCTableDesc=$tr(IMCTableDesc,"?","")
	s IMCTableDesc=$tr(IMCTableDesc,"[","")
	s IMCTableDesc=$tr(IMCTableDesc,"]","")
	s IMCTableDesc=$tr(IMCTableDesc,"|","")
	s IMCTableDesc=$tr(IMCTableDesc,"*","")
	s IMCTableDesc=$tr(IMCTableDesc,"{","")
	s IMCTableDesc=$tr(IMCTableDesc,"}","")
	s IMCTableDesc=$tr(IMCTableDesc,":","")
	s IMCTableDesc=$tr(IMCTableDesc,"：","")
	///先排序，不导出的不排序
	k SeqArray
	s mySMSeq=0
	s n=0
	for 
	{
		s mySMSeq=$o(^User.BDPIMFieldConfigI("ParSeqIdx",IMCID,mySMSeq))
		q:(mySMSeq="")
		s IMFCchildsub=0
		for
		{
			s IMFCchildsub=$o(^User.BDPIMFieldConfigI("ParSeqIdx",IMCID,mySMSeq,IMFCchildsub)) q:IMFCchildsub=""
			//s IMFCImport=$listget($g(^User.BDPIMConfigD(IMCID,"ChildField",IMFCchildsub)),10)  ///是否导入
			//continue:IMFCImport="N"
			s IMFCExport=$listget($g(^User.BDPIMConfigD(IMCID,"ChildField",IMFCchildsub)),14)  ///是否导出
			continue:IMFCExport="N"
			s n=n+1
			s SeqArray(n)=IMFCchildsub
		}
	}
	///没有填写顺序的排在有顺序的后面
	if $d(^User.BDPIMFieldConfigI("ParSeqIdx",IMCID,-100000000000000))>0
	{
		s IMFCchildsub=0
		for
		{
			s IMFCchildsub=$o(^User.BDPIMFieldConfigI("ParSeqIdx",IMCID,-100000000000000,IMFCchildsub)) q:IMFCchildsub=""
			//s IMFCImport=$listget($g(^User.BDPIMConfigD(IMCID,"ChildField",IMFCchildsub)),10)  ///是否导入
			//continue:IMFCImport="N"
			s IMFCExport=$listget($g(^User.BDPIMConfigD(IMCID,"ChildField",IMFCchildsub)),14)  ///是否导出
			continue:IMFCExport="N"
			s n=n+1
			s SeqArray(n)=IMFCchildsub
		}
	}

	s result=""
	s n=0
	for 
	{
		s n=$o(SeqArray(n)) q:n=""
		s IMFCchildsub=$g(SeqArray(n))
		s IMFCFieldDesc=$LISTGET($G(^User.BDPIMConfigD(IMCID,"ChildField",IMFCchildsub)),2)
		s IMFCFieldName=$LISTGET($G(^User.BDPIMConfigD(IMCID,"ChildField",IMFCchildsub)),3)
		s IMFCRequired=$listget($g(^User.BDPIMConfigD(IMCID,"ChildField",IMFCchildsub)),9)
		s RFlag=0  //是否必填
		if (IMFCRequired="Y") s RFlag=1
		s IMFCFieldDescU=$ZCONVERT(IMFCFieldDesc,"U")
		continue:IMFCFieldDescU="ROWID"
		if (result'="")
		{
			s result=result_"&#"_IMFCFieldDesc_"^"_IMFCFieldName_"^"_RFlag
		}
		else
		{
			s result=IMFCFieldDesc_"^"_IMFCFieldName_"^"_RFlag
		}
		
	}

	q IMCTableDesc_"&%"_result
}

/// Creator:陈莹 
/// CreatDate:2021-05-26  V2
/// Description:导出“导入说明”（导出导入模版时调用）
/// Input:导入菜单对应的代码
/// Return:导出说明
/// Other:w ##class(web.DHCBL.BDP.BDPDataExport).GetExcelInstructionV2("CT_Province")
ClassMethod GetExcelInstructionV2(table) As %String
{
	q:table="" ""
	s IMCID=""
	s:table'="" table=$ZCONVERT(table,"U") //转换成大写
	s:table'="" IMCID=$o(^User.BDPIMConfigI("UniqueTableName"," "_table,0))
	q:IMCID="" ""
	s IMCText=$LISTGET($G(^User.BDPIMConfigD(IMCID)),12)  ///导入说明,add@2016-11-22
	q IMCText
}

/// Creator：chenying
/// CreatDate: 2021-05-26
/// Description：获取总共数据条数 V2
/// Table：User.BDPIMConfig
/// Input：tablename
/// Other: w ##class(web.DHCBL.BDP.BDPDataExport).GetDataCountV2("SS_User")
ClassMethod GetDataCountV2(tablename) As %String
{
	n (tablename,%session)
	
	s mySysID =$s($d(%session):%session.%Id(),1:$j)
	q:tablename="" ""
	
	s EImenuID=$o(^User.BDPEIMenuI("UniqueCodeIndex"," "_$zcvt(tablename,"U"),0))
	s LinkTableDr=$LISTGET($G(^User.BDPEIMenuD(EImenuID)),13)
	S tableListName=""
	if LinkTableDr'="" s tableListName=$LISTGET($G(^User.BDPTableListD(LinkTableDr)),8)   //获取导入导出菜单的表结构登记指针对应的代码
	if tableListName="" s tableListName=tablename
	
	s IMCID=$o(^User.BDPIMConfigI("UniqueTableName"," "_$zcvt(tablename,"U"),0))
	q:IMCID="" ""
	s EXCXGlobal=$lg($g(^User.BDPIMConfigD(IMCID)),13)
	s EXCIsChildTable=$LISTGET($G(^User.BDPIMConfigD(IMCID)),14)
	s DataCount=0
	k ^TMPEXCELEXPORT(mySysID,tablename)
	///2020-06-29 开启医院级授权，导出时，只导出本人医院级授权 所能看到医院的相关的数据
	s myobj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCBL.BDP.BDPConfig"_"||"_"GetConfigValue")
    i $IsObject(myobj)
    {
        s myobj=""
        s HospAutflag = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut")  //获取平台配置是否开启医院级别授权
    }
    else
    {
	    s HospAutflag = "N"
    }
    
    s myobj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCBL.Authorize.BDPHospitalAut"_"||"_"GetHospAutFlag")
    i $IsObject(myobj)
    {
        s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
    }
    else
    {
	    s AuHospStr="off"
    }
    s myobj=""
	if (EXCIsChildTable="Y")  ///子表特殊处理父表xstr
	{
		if (tablename="PAC_Bed") ///床位
		{
			s ParRef=0
			for
			{
				s ParRef=$o(^PAWARD(ParRef)) q:((ParRef="")||(ParRef'>0))
				if (HospAutflag="Y")&&(AuHospStr'="off")&&(AuHospStr'=1)
				{
					s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("PAC_Ward",ParRef)
					continue:showflag="N"
				}
				//床位表
				if ($d(^PAWARD(0,"Sequence"))>0)
				{
					s Sequence=0,flag0=0
					for
					{
						s Sequence=$o(^PAWARD(0,"Sequence",ParRef,Sequence))
						q:flag0=1
						if (Sequence="")	//先查询有序号的数据(0节点之后)，再查询没有序号(0节点)的数据
						{
							s flag0=1
							s Sequence=0
						}
						s BEDChildsub=0
						for
						{
							s BEDChildsub=$o(^PAWARD(0,"Sequence",ParRef,Sequence,BEDChildsub)) q:BEDChildsub=""
							s BEDRowID=ParRef_"||"_BEDChildsub
							s DataCount=DataCount+1
							s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=ParRef_"#"_BEDChildsub
						}
					}
				}
				else
				{
					s BEDChildsub=0
					for
					{
						s BEDChildsub=$o(^PAWARD(ParRef,"BED",BEDChildsub)) q:BEDChildsub=""
						s DataCount=DataCount+1
						s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=ParRef_"#"_BEDChildsub
					}
				}
				
				//房间分配（等候区）
				s Childsub=0
				for
				{
					s Childsub=$o(^PAWARD(ParRef,"ROOM",Childsub)) q:Childsub=""
					s DataCount=DataCount+1
					s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=ParRef_"#"_"#"_Childsub
				}
			}
		}
		else
		{
			s EXCParRefGlobal=$LISTGET($G(^User.BDPIMConfigD(IMCID)),15)
			s xrowidstr="s xrowid="_EXCXGlobal	
			s xparrefstr="s xparref="_EXCParRefGlobal
			s xparref=0		
			for
			{		
				x xparrefstr  q:((xparref="")||(xparref'>0))
				if (HospAutflag="Y")&&(AuHospStr'="off")&&(AuHospStr'=1)
				{
					if (tablename="ARC_BillSub") ///账单分类
					{
						s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("ARC_BillGrp",xparref)
						continue:showflag="N"
					}
					if (tablename="ARC_ItmRecLoc") //医嘱项接收科室
					{
						s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("ARC_ItmMast",xparref_"||1")
						continue:showflag="N"
					}
					if (tablename="SS_UserOtherLogonLoc") //用户其他登录科室
					{
						s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("SS_User",xparref)
						continue:showflag="N"
					}
					//?
					if (tablename="OEC_OrdCatRecLoc") //医嘱大类接收科室
					{
						s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("OEC_OrderCategory",xparref)
						continue:showflag="N"
					}
					if (tablename="ARC_ItemCatRecLoc") //医嘱子分类接收科室
					{
						s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("ARC_ItemCat",xparref)
						continue:showflag="N"
					}
					if (tablename="ARC_ItmRecLoc") //用法接收科室
					{	
						///?
					}
				}
				s xrowid=0 			
				for 
				{
					x xrowidstr  q:((xrowid="")||(xrowid'>0))	
					if (tablename="ARC_BillSub") ///账单分类
					{
						if (HospAutflag="Y")&&(AuHospStr'="off")&&(AuHospStr'=1)
						{
							s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("ARC_BillSub",xparref_"||"_xrowid)
							continue:showflag="N"
						}
					}		
					s DataCount=DataCount+1
					s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=xparref_"&#"_xrowid
				}
			}
		}
	}
	else
	{
		if (tablename["ARC_ItmMast")  //检查检验治疗
		{
			s subscript=0
			for
			{
				s subscript=$o(^ARCIM(subscript))   q:subscript=""  
				CONTINUE:$D(^INCI(0,"ARCIM_DR",subscript))>0 //20190823 过滤掉关联了库存项的医嘱项
				s version=0
				for 
				{
					s version=$o(^ARCIM(subscript,version))  q:version="" 
					continue:$p($g(^ARCIM(subscript,version,1)),"^",1)=""  //过滤空数据
					//s ARCIMEffDateTo=$p($g(^ARCIM(subscript,version,7)),"^",1)              ;结束日期
					//CONTINUE:(ARCIMEffDateTo'="")&&(ARCIMEffDateTo<+$H)
					if (HospAutflag="Y")&&(AuHospStr'="off")&&(AuHospStr'=1)
					{
						s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("ARC_ItmMast",subscript_"||"_version)
						continue:showflag="N"
					}
					s ARCIMItemCatDR=$p($g(^ARCIM(subscript,version,1)),"^",10)
					if ARCIMItemCatDR'=""
					{
						s ARCICOrderType=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",7)
						if (ARCICOrderType'="R")  //&&(ARCICOrderType'="M")
						{
							s OLTARCIMDR=subscript_"||"_version
							if ($d(^DHCOLT(0,"ARTTA",OLTARCIMDR))>0)
							{
								///导出收费项目
								s OLTTariffDR=0
								for
								{
									s OLTTariffDR=$o(^DHCOLT(0,"ARTTA",OLTARCIMDR,OLTTariffDR)) q:OLTTariffDR=""   
									s OLTStartDate=0
									for
									{
										s OLTStartDate=$o(^DHCOLT(0,"ARTTA",OLTARCIMDR,OLTTariffDR,OLTStartDate)) q:OLTStartDate=""
										s OLTRowId=0
										for
										{
											s OLTRowId=$o(^DHCOLT(0,"ARTTA",OLTARCIMDR,OLTTariffDR,OLTStartDate,OLTRowId)) q:OLTRowId=""
											//s OLTEndDate=$p($g(^DHCOLT(OLTRowId)),"^",5)
											//CONTINUE:(OLTEndDate'="")&&(OLTEndDate<+$H)
											s DataCount=DataCount+1
											s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=subscript_"||"_version_"#"_OLTTariffDR_"#"_OLTRowId
										}
									}
								}
							}
							else
							{
								///导出医嘱项目
								s DataCount=DataCount+1
								s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=subscript_"||"_version
							}	
						}
					}	
				}
			}
		}
		elseif (tablename="ARCItmMast")  //所有医嘱项 2019-02-16
		{
			s subscript=0
			for
			{
				s subscript=$o(^ARCIM(subscript))   q:subscript=""  
				s version=0
				for 
				{
					s version=$o(^ARCIM(subscript,version))  q:version="" 
					continue:$p($g(^ARCIM(subscript,version,1)),"^",1)=""  //过滤空数据
					//s ARCIMEffDateTo=$p($g(^ARCIM(subscript,version,7)),"^",1)              ;结束日期
					//CONTINUE:(ARCIMEffDateTo'="")&&(ARCIMEffDateTo<+$H)
					if (HospAutflag="Y")&&(AuHospStr'="off")&&(AuHospStr'=1)
					{
						s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("ARC_ItmMast",subscript_"||"_version)
						continue:showflag="N"
					}
					s DataCount=DataCount+1
					s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=subscript_"||"_version
						
				}
			}
		}
		elseif (tablename="PHC_DrgMast")  //药品 医嘱子分类类型为R(Drug)的医嘱项
		{
			s INCIRowId=0
			for
			{
				s INCIRowId=$o(^INCI(INCIRowId)) q:((INCIRowId="")||(INCIRowId'>0))
				continue:$p($g(^INCI(INCIRowId,1)),"^",1)=""  //过滤空数据
				S INCIOriginalARCIMDR=$P($G(^INCI(INCIRowId,1)),"^",3)
				if INCIOriginalARCIMDR'=""
				{
					s ARCIMSubscript=$p(INCIOriginalARCIMDR,"||",1)
					s ARCIMVersion=$p(INCIOriginalARCIMDR,"||",2)
					continue:((ARCIMSubscript="")||(ARCIMVersion=""))
					//s ARCIMEffDateTo=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",1)              ;结束日期
					//CONTINUE:(ARCIMEffDateTo'="")&&(ARCIMEffDateTo<+$H)
					if (HospAutflag="Y")&&(AuHospStr'="off")&&(AuHospStr'=1)
					{
						s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("ARC_ItmMast",ARCIMSubscript_"||"_ARCIMVersion)
						continue:showflag="N"
					}
					s ARCIMPHCDFDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",12)
					continue:ARCIMPHCDFDR=""
					s ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)
					if ARCIMItemCatDR'=""
					{
						s ARCICOrderType=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",7)
						if (ARCICOrderType="R")
						{
							if ($d(^DHCOLT(0,"ARTTA",INCIOriginalARCIMDR))>0)
							{
								///导出收费项目
								s TARIRowId=0
								for
								{
									s TARIRowId=$o(^DHCOLT(0,"ARTTA",INCIOriginalARCIMDR,TARIRowId)) q:TARIRowId=""   
									s OLTStartDate=0
									for
									{
										s OLTStartDate=$o(^DHCOLT(0,"ARTTA",INCIOriginalARCIMDR,TARIRowId,OLTStartDate)) q:OLTStartDate=""
										s OLTRowId=0
										for
										{
											s OLTRowId=$o(^DHCOLT(0,"ARTTA",INCIOriginalARCIMDR,TARIRowId,OLTStartDate,OLTRowId)) q:OLTRowId=""
											
											//s OLTEndDate=$p($g(^DHCOLT(OLTRowId)),"^",5)
											//CONTINUE:(OLTEndDate'="")&&(OLTEndDate<+$H)
											s DataCount=DataCount+1
											///库存项id#医嘱项id#收费项id#医嘱与收费项关联id#药学DrgFormid
											s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=INCIRowId_"#"_INCIOriginalARCIMDR_"#"_TARIRowId_"#"_OLTRowId_"#"_ARCIMPHCDFDR
										}
									}
								}
							}
							else
							{
								s DataCount=DataCount+1
								s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=INCIRowId_"#"_INCIOriginalARCIMDR_"###"_ARCIMPHCDFDR
							}
						
						}
					}	
				}
			}
		}
		elseif (tablename="PHC_DrgMastNew")  //药品(新医嘱模式) 的医嘱项
		{
			
			s INCIRowId=0
			for
			{
				s INCIRowId=$o(^INCI(INCIRowId)) q:((INCIRowId="")||(INCIRowId'>0))
				continue:$p($g(^INCI(INCIRowId,1)),"^",1)=""  //过滤空数据
				S INCIOriginalARCIMDR=$P($G(^INCI(INCIRowId,1)),"^",3)
				if INCIOriginalARCIMDR'=""
				{
					s ARCIMSubscript=$p(INCIOriginalARCIMDR,"||",1)
					s ARCIMVersion=$p(INCIOriginalARCIMDR,"||",2)
					continue:((ARCIMSubscript="")||(ARCIMVersion=""))
					if (HospAutflag="Y")&&(AuHospStr'="off")&&(AuHospStr'=1)
					{
						s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("ARC_ItmMast",INCIOriginalARCIMDR)
						continue:showflag="N"
					}
					s ARCIMPHCDFDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",12)
					continue:ARCIMPHCDFDR=""
					s ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)
					//s ARCICOrderType=""
					//s:ARCIMItemCatDR'="" ARCICOrderType=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",7)
					//continue:(ARCICOrderType'="R")
					if ($d(^DHCINCTARi("INCI",INCIRowId))>0)
					{
						//User.DHCIncTarRela
						s INCTRRowId=0
						for
						{
							s INCTRRowId=$o(^DHCINCTARi("INCI",INCIRowId,INCTRRowId)) q:INCTRRowId=""   
							s TARIRowId=$p($g(^DHCINCTAR(INCTRRowId)),"^",2)
							continue:TARIRowId=""
							s DataCount=DataCount+1
							///库存项id#医嘱项id#收费项id#库存项与收费项关联id#药学DrgFormid
							s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=INCIRowId_"#"_INCIOriginalARCIMDR_"#"_TARIRowId_"#"_INCTRRowId_"#"_ARCIMPHCDFDR
								
						}			
					}
					
				}
			}
		}
		/*elseif (tablename["PHC_DrgMast")  //药品 新医嘱模式/旧医嘱模式
		{
			
			s INCIRowId=0
			for
			{
				s INCIRowId=$o(^INCI(INCIRowId)) q:((INCIRowId="")||(INCIRowId'>0))
				continue:$p($g(^INCI(INCIRowId,1)),"^",1)=""  //过滤空数据
				S INCIOriginalARCIMDR=$P($G(^INCI(INCIRowId,1)),"^",3)
				if INCIOriginalARCIMDR'=""
				{
					s ARCIMSubscript=$p(INCIOriginalARCIMDR,"||",1)
					s ARCIMVersion=$p(INCIOriginalARCIMDR,"||",2)
					continue:((ARCIMSubscript="")||(ARCIMVersion=""))
					if (HospAutflag="Y")&&(AuHospStr'="off")&&(AuHospStr'=1)
					{
						s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("ARC_ItmMast",INCIOriginalARCIMDR)
						continue:showflag="N"
					}
					s ARCIMPHCDFDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",12)
					continue:ARCIMPHCDFDR=""
					s ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)
					//s ARCICOrderType=""
					//s:ARCIMItemCatDR'="" ARCICOrderType=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",7)
					//continue:(ARCICOrderType'="R")
					if ($d(^DHCINCTARi("INCI",INCIRowId))>0)
					{
						//User.DHCIncTarRela
						s INCTRRowId=0
						for
						{
							s INCTRRowId=$o(^DHCINCTARi("INCI",INCIRowId,INCTRRowId)) q:INCTRRowId=""   
							s TARIRowId=$p($g(^DHCINCTAR(INCTRRowId)),"^",2)
							continue:TARIRowId=""
							s DataCount=DataCount+1
							///库存项id#医嘱项id#收费项id#库存项与收费项关联id#药学DrgFormid
							s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=INCIRowId_"#"_INCIOriginalARCIMDR_"#"_TARIRowId_"#"_""_"#"_ARCIMPHCDFDR_"#"_INCTRRowId
								
						}			
					}
					else
					{
						
						if ($d(^DHCOLT(0,"ARTTA",INCIOriginalARCIMDR))>0)
						{
							///导出收费项目
							s TARIRowId=0
							for
							{
								s TARIRowId=$o(^DHCOLT(0,"ARTTA",INCIOriginalARCIMDR,TARIRowId)) q:TARIRowId=""   
								s OLTStartDate=0
								for
								{
									s OLTStartDate=$o(^DHCOLT(0,"ARTTA",INCIOriginalARCIMDR,TARIRowId,OLTStartDate)) q:OLTStartDate=""
									s OLTRowId=0
									for
									{
										s OLTRowId=$o(^DHCOLT(0,"ARTTA",INCIOriginalARCIMDR,TARIRowId,OLTStartDate,OLTRowId)) q:OLTRowId=""
										
										//s OLTEndDate=$p($g(^DHCOLT(OLTRowId)),"^",5)
										//CONTINUE:(OLTEndDate'="")&&(OLTEndDate<+$H)
										s DataCount=DataCount+1
										///库存项id#医嘱项id#收费项id#医嘱与收费项关联id#药学DrgFormid
										s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=INCIRowId_"#"_INCIOriginalARCIMDR_"#"_TARIRowId_"#"_OLTRowId_"#"_ARCIMPHCDFDR_"#"
									}
								}
							}
						}
						else
						{
							s DataCount=DataCount+1
							s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=INCIRowId_"#"_INCIOriginalARCIMDR_"###"_ARCIMPHCDFDR_"#"
						}
						
					}
				}
			}
		}*/
		elseif (tablename="INC_Itm")  //材料物资 医嘱子分类类型为M(Material)的医嘱项
		{
			s INCIRowId=0
			for
			{
				s INCIRowId=$o(^INCI(INCIRowId)) q:((INCIRowId="")||(INCIRowId'>0))
				continue:$p($g(^INCI(INCIRowId,1)),"^",1)=""  //过滤空数据 2020-03-13
				S INCIOriginalARCIMDR=$P($G(^INCI(INCIRowId,1)),"^",3)
				if INCIOriginalARCIMDR'=""
				{
					s ARCIMSubscript=$p(INCIOriginalARCIMDR,"||",1)
					s ARCIMVersion=$p(INCIOriginalARCIMDR,"||",2)
					continue:((ARCIMSubscript="")||(ARCIMVersion=""))
					if (HospAutflag="Y")&&(AuHospStr'="off")&&(AuHospStr'=1)
					{
						s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("ARC_ItmMast",INCIOriginalARCIMDR)
						continue:showflag="N"
					}
					//s ARCIMEffDateTo=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",1)              ;结束日期
					//CONTINUE:(ARCIMEffDateTo'="")&&(ARCIMEffDateTo<+$H)
					s ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)
					if ARCIMItemCatDR'=""
					{
						s ARCICOrderType=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",7)
						if (ARCICOrderType'="R")  //20190823update 改成判断类型不是药品的库存项(因为老项目里没有M类型)
						{
							if ($d(^DHCOLT(0,"ARTTA",INCIOriginalARCIMDR))>0)
							{
								///导出收费项目
								s TARIRowId=0
								for
								{
									s TARIRowId=$o(^DHCOLT(0,"ARTTA",INCIOriginalARCIMDR,TARIRowId)) q:TARIRowId=""   
									s OLTStartDate=0
									for
									{
										s OLTStartDate=$o(^DHCOLT(0,"ARTTA",INCIOriginalARCIMDR,TARIRowId,OLTStartDate)) q:OLTStartDate=""
										s OLTRowId=0
										for
										{
											s OLTRowId=$o(^DHCOLT(0,"ARTTA",INCIOriginalARCIMDR,TARIRowId,OLTStartDate,OLTRowId)) q:OLTRowId=""
											//s OLTEndDate=$p($g(^DHCOLT(OLTRowId)),"^",5)
											//CONTINUE:(OLTEndDate'="")&&(OLTEndDate<+$H)
											s DataCount=DataCount+1
											///库存项id#医嘱项id#收费项id#医嘱与收费项关联id
											s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=INCIRowId_"#"_INCIOriginalARCIMDR_"#"_TARIRowId_"#"_OLTRowId
										}
									}
								}
							}
							else
							{
								s DataCount=DataCount+1
								s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=INCIRowId_"#"_INCIOriginalARCIMDR_"##"
							}
						}
					}	
				}
				else
				{
					if (HospAutflag="Y")&&(AuHospStr'="off")&&(AuHospStr'=1)
					{
						s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("INC_Itm",INCIRowId)
						continue:showflag="N"
					}
					s DataCount=DataCount+1
					s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=INCIRowId
				}
			}
		}
		elseif (tablename="SS_User")  //用户医护人员
		{
			K ^TMPSSUSRCARE
			s SSUSRRowId=0
			for  
			{	
				s SSUSRRowId=$o(^SSU("SSUSR",SSUSRRowId)) q:SSUSRRowId="" 
				if (HospAutflag="Y")&&(AuHospStr'="off")&&(AuHospStr'=1)
				{
					s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("SS_User",SSUSRRowId)
					continue:showflag="N"
				}
				//s SSUSRActive=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",19)      //是否激活
				//s SSUSRDateTo=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",97)  //截止日期
				//continue:SSUSRActive'="Y"
				//continue:(SSUSRDateTo'="")&&(SSUSRDateTo<+$h)
				s SSUSRCareProvDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",14)      //医护人员DR
				s DataCount=DataCount+1
				s Type=""
				if SSUSRCareProvDR'=""
				{
					s Type="UC"
					s ^TMPSSUSRCARE(SSUSRCareProvDR)=SSUSRRowId
				}
				if SSUSRCareProvDR="" s Type="U"
				s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=SSUSRRowId_"#"_SSUSRCareProvDR_"#"_Type
			}
			
			s CTPCPRowId1=0
			for  
			{				
				s CTPCPRowId1=$o(^CTPCP(CTPCPRowId1)) q:((CTPCPRowId1="")||(CTPCPRowId1'>0))
				continue:$d(^CTPCP(CTPCPRowId1,1))=0
				if (HospAutflag="Y")&&(AuHospStr'="off")&&(AuHospStr'=1)
				{
					s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("CT_CareProv",CTPCPRowId1)
					continue:showflag="N"
				}
				//s CTPCPActiveFlag=$p($g(^CTPCP(CTPCPRowId1,1)),"^",9)      //是否激活
				//s CTPCPDateActiveTo=$p($g(^CTPCP(CTPCPRowId1,2)),"^",15)     //截止时间
				//continue:CTPCPActiveFlag'="Y"
				//continue:(CTPCPDateActiveTo'="")&&(CTPCPDateActiveTo<+$h)
				if $d(^TMPSSUSRCARE(CTPCPRowId1))=0
				{
					s Type="C"
					s DataCount=DataCount+1
					s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=""_"#"_CTPCPRowId1_"#"_Type
				}
			}
			k ^TMPSSUSRCARE
		}
		elseif (tablename="ARC_OrdSets")  //医嘱套 2019-04-04
		{
			s ARCOSRowId=0
			for
			{
				s ARCOSRowId=$o(^ARCOS(ARCOSRowId))   q:ARCOSRowId=""
				s ARCOSCode=$p($g(^ARCOS(ARCOSRowId)),"^",1)
				if (HospAutflag="Y")&&(AuHospStr'="off")&&(AuHospStr'=1)
				{
					s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("ARC_OrdSets",ARCOSRowId)
					continue:showflag="N"
				}
				//continue:$p($g(^ARCOS(ARCOSRowId)),"^",16)<+$h   //过滤医嘱套
				S DATEChildSub=0
				for
				{
					s DATEChildSub=$o(^ARCOS(ARCOSRowId,"DATE",DATEChildSub))   q:DATEChildSub=""
					S ITMChildSub=0
					for
					{
						s ITMChildSub=$o(^ARCOS(ARCOSRowId,"DATE",DATEChildSub,"ITM",ITMChildSub))   q:ITMChildSub=""
						s ITMARCIMDR=$p($g(^ARCOS(ARCOSRowId,"DATE",DATEChildSub,"ITM",ITMChildSub)),"^",1)
						continue:ITMARCIMDR=""
						//s ARCIMEffDate=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",13)                 ;开始日期
						//s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,"Z",1)
						//s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,",",1)
						//continue:ARCIMEffDate'=65179
						//continue:$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",1)'<+$h
						if ($g(^TMPARCOS("EndFlag"))=1) //只导废除医嘱对应的医嘱套-医嘱项
						{
							continue:$d(^TMPBDPEndData("ARCItmMast",ITMARCIMDR))=0
						}
						
						s DataCount=DataCount+1
						s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=ARCOSRowId_"#"_DATEChildSub_"#"_ITMChildSub_"#"_"TIM"
												
					}
					if ($g(^TMPARCOS("EndFlag"))'=1) //只导废除医嘱对应的医嘱套-医嘱项
					{
						S OSChildSub=0
						for
						{
							s OSChildSub=$o(^ARCOS(ARCOSRowId,"DATE",DATEChildSub,"OS",OSChildSub))   q:OSChildSub=""
							s OSOrderSetDR=$p($g(^ARCOS(ARCOSRowId,"DATE",DATEChildSub,"OS",OSChildSub)),"^",1)
							continue:OSOrderSetDR=""
							//continue:$p($g(^ARCOS(OSOrderSetDR)),"^",16)<+$h   //过滤医嘱套
							s DataCount=DataCount+1
							s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=ARCOSRowId_"#"_DATEChildSub_"#"_OSChildSub_"#"_"OS"
													
						}	
					}
				}
			}
		}
		elseif (tablename="RB_ResEffDateSession")  //排班模板 20190912
		{
			s RESRowId=0
			for
			{
				s RESRowId=$o(^RB("RES",RESRowId))  q:RESRowId=""
				if (HospAutflag="Y")&&(AuHospStr'="off")&&(AuHospStr'=1)
				{
					s RESCTLOCDR=$p($g(^RB("RES",RESRowId)),"^",1)       //科室ID
					s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("CT_Loc",RESCTLOCDR)
					continue:showflag="N"
				}
				
				s RESEQDR=$p($g(^RB("RES",RESRowId)),"^",3)
				continue:RESEQDR'=""
				S DATEChildSub=0
				for
				{
					s DATEChildSub=$o(^RB("RES",RESRowId,"DATE",DATEChildSub)) q:DATEChildSub=""
					S SESSChildsub=0
					for
					{
						s SESSChildsub=$o(^RB("RES",RESRowId,"DATE",DATEChildSub,"SESS",SESSChildsub))   q:SESSChildsub=""
						s DataCount=DataCount+1
						s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=RESRowId_"#"_DATEChildSub_"#"_SESSChildsub
												
					}
					
				}
			}
		}
		elseif (tablename="OrderCategory")  //医嘱分类 20191023
		{
			s ARCICRowId=0
			for
			{
				s ARCICRowId=$o(^ARC("IC",ARCICRowId))  q:ARCICRowId=""
				s ARCICOrdCatDR = $p($g(^ARC("IC",ARCICRowId)),"^",8)
				if (HospAutflag="Y")&&(AuHospStr'="off")&&(AuHospStr'=1)
				{
					s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag(tableListName,ARCICRowId)
					continue:showflag="N"
				}
				s DataCount=DataCount+1
				s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=ARCICRowId_"#"_ARCICOrdCatDR
				
			}
		}
		elseif (tablename="ChargeCategory")  //费用分类 20191024
		{
			if (HospAutflag="Y") //开启医院级授权后
			{
				s AuStr=##class(web.DHCBL.Authorize.CTHospital).DHCGetDataByDefaultSession()
				s AuFlag=0
				if AuStr="" s AuFlag=1 //判断是否有授权,如果没有则全部显示
				s HOSPRowId=0
				for  
				{
					s HOSPRowId=$o(^CT("HOSP",HOSPRowId)) q:HOSPRowId=""
					s strRowId = "{ID:"_HOSPRowId_"}"
					i ((AuStr[strRowId)||(AuFlag=1))&((AuHospStr="off")||(AuHospStr[strRowId)||(AuHospStr=1)) ;用来筛选授权数据，如果未授权情况下筛选无效
					{
						s HOSPDateTo=$p($g(^CT("HOSP",HOSPRowId)),"^",10)
						continue:(HOSPDateTo'="")&&(HOSPDateTo<+$h) 
						//收费子类
						s RowId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("DHC_TarSubCate",HOSPRowId)  //获取到医院对应的默认医院（判断例外和医院组）
						if (RowId>0) s HospArray(RowId)=""    
						//住院子类
						s RowId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("DHC_TarInpatCate",HOSPRowId)  //获取到医院对应的默认医院（判断例外和医院组）
						if (RowId>0) s HospArray(RowId)=""    
						//门诊子类
						s RowId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("DHC_TarOutpatCate",HOSPRowId)  //获取到医院对应的默认医院（判断例外和医院组）
						if (RowId>0) s HospArray(RowId)=""    
						//核算子类
						s RowId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("DHC_TarEMCCate",HOSPRowId)  //获取到医院对应的默认医院（判断例外和医院组）
						if (RowId>0) s HospArray(RowId)=""  
						//会计子类
						s RowId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("DHC_TarAcctCate",HOSPRowId)  //获取到医院对应的默认医院（判断例外和医院组）
						if (RowId>0) s HospArray(RowId)=""  
						//病案子类
						s RowId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("DHC_TarMRCate",HOSPRowId)  //获取到医院对应的默认医院（判断例外和医院组）
						if (RowId>0) s HospArray(RowId)=""  
						//新病案首页子类
						s RowId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("DHC_TarMCCateNew",HOSPRowId)  //获取到医院对应的默认医院（判断例外和医院组）
						if (RowId>0) s HospArray(RowId)=""  

					}
				}

				s HOSPRowId=0
				for  
				{	
					s HOSPRowId=$o(HospArray(HOSPRowId)) q:HOSPRowId=""
					s StartCount=+($o(^TMPEXCELEXPORT(mySysID,tablename,""),-1))
					s DataCount=StartCount
					s TARSCRowId=0
					for
					{ 
						s TARSCRowId=$o(^DHCTarC("SC",TARSCRowId))  q:TARSCRowId=""  
						CONTINUE:(##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarSubCate",TARSCRowId,HOSPRowId))="N"
						s DataCount=DataCount+1
						s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",1)=HOSPRowId
						s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",2)=TARSCRowId  

					}
					s DataCount=StartCount
					s TARICRowId=0
					for
					{ 
						s TARICRowId=$o(^DHCTarC("IC",TARICRowId)) q:TARICRowId=""
						CONTINUE:(##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarInpatCate",TARICRowId,HOSPRowId))="N"
						s DataCount=DataCount+1
						s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",1)=HOSPRowId
						s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",3)=TARICRowId
					} 


					s DataCount=StartCount
					s TAROCRowId=0
					for
					{ 
						s TAROCRowId=$o(^DHCTarC("OC",TAROCRowId))  q:TAROCRowId=""
						CONTINUE:(##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarOutpatCate",TAROCRowId,HOSPRowId))="N"
						s DataCount=DataCount+1
						s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",1)=HOSPRowId
						s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",4)=TAROCRowId
					}

					s DataCount=StartCount
					s TARECRowId=0
					for
					{ 
						s TARECRowId=$o(^DHCTarC("EC",TARECRowId))  q:TARECRowId=""
						CONTINUE:(##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarEMCCate",TARECRowId,HOSPRowId))="N"
						s DataCount=DataCount+1
						s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",1)=HOSPRowId
						s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",5)=TARECRowId
					}   
					s DataCount=StartCount
					s TARACRowId=0
					for
					{ 
						s TARACRowId=$o(^DHCTarC("AC",TARACRowId))  q:TARACRowId=""
						CONTINUE:(##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarAcctCate",TARACRowId,HOSPRowId))="N"
						s DataCount=DataCount+1
						s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",1)=HOSPRowId
						s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",6)=TARACRowId
					}   

					s DataCount=StartCount
					s TARMCRowId=0
					for
					{ 
						s TARMCRowId=$o(^DHCTarC("MC",TARMCRowId))  q:TARMCRowId=""
						CONTINUE:(##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarMRCate",TARMCRowId,HOSPRowId))="N"
						s DataCount=DataCount+1
						s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",1)=HOSPRowId
						s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",7)=TARMCRowId
					}  
					s DataCount=StartCount
					s NTARMCRowId=0
					for
					{ 
						s NTARMCRowId=$o(^DHCTarC("MCNew",NTARMCRowId))  q:NTARMCRowId=""
						CONTINUE:(##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarMCCateNew",NTARMCRowId,HOSPRowId))="N"
						s DataCount=DataCount+1
						s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",1)=HOSPRowId
						s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",8)=NTARMCRowId
					} 
					s DataCount=+($o(^TMPEXCELEXPORT(mySysID,tablename,""),-1))
				}  
	        }
	        else  //没有开启医院级授权时，适用于早版本项目
	        {
		        s StartCount=0
				s DataCount=StartCount
				s TARSCRowId=0
				for
				{ 
					s TARSCRowId=$o(^DHCTarC("SC",TARSCRowId))  q:TARSCRowId=""  
					s DataCount=DataCount+1
					s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",2)=TARSCRowId  
					
				}
				s DataCount=StartCount
				s TARICRowId=0
				for
				{ 
					s TARICRowId=$o(^DHCTarC("IC",TARICRowId)) q:TARICRowId=""
					s DataCount=DataCount+1
					s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",3)=TARICRowId
				} 
				
				
				s DataCount=StartCount
				s TAROCRowId=0
				for
				{ 
					s TAROCRowId=$o(^DHCTarC("OC",TAROCRowId))  q:TAROCRowId=""
					s DataCount=DataCount+1
					s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",4)=TAROCRowId
				}
				
				s DataCount=StartCount
				s TARECRowId=0
				for
				{ 
					s TARECRowId=$o(^DHCTarC("EC",TARECRowId))  q:TARECRowId=""
					s DataCount=DataCount+1
					s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",5)=TARECRowId
				}   
				s DataCount=StartCount
				s TARACRowId=0
				for
				{ 
					s TARACRowId=$o(^DHCTarC("AC",TARACRowId))  q:TARACRowId=""
					s DataCount=DataCount+1
					s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",6)=TARACRowId
				}   
				
				s DataCount=StartCount
				s TARMCRowId=0
				for
				{ 
					s TARMCRowId=$o(^DHCTarC("MC",TARMCRowId))  q:TARMCRowId=""
					s DataCount=DataCount+1
					s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",7)=TARMCRowId
				}  
				s DataCount=StartCount
				s NTARMCRowId=0
				for
				{ 
					s NTARMCRowId=$o(^DHCTarC("MCNew",NTARMCRowId))  q:NTARMCRowId=""
					s DataCount=DataCount+1
					s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",8)=NTARMCRowId
				} 
				s DataCount=+($o(^TMPEXCELEXPORT(mySysID,tablename,""),-1))
	        }
			
		}
		elseif (tablename="RoomBedType")  //床位类型房间类型 20191024
		{
			s DataCount=0
			s ROOMTRowId=0
			for  
			{	
				s ROOMTRowId=$o(^PAC("ROOMT",ROOMTRowId)) q:ROOMTRowId=""
				s DataCount=DataCount+1
				s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=ROOMTRowId  
				
			}
			
			s DataCount=0
			s BEDTPRowId=0
			for  
			{	
				s BEDTPRowId=$o(^PAC("BEDTP",BEDTPRowId)) q:BEDTPRowId=""
				s DataCount=DataCount+1
				s $p(^TMPEXCELEXPORT(mySysID,tablename,DataCount),"#",2)=BEDTPRowId
				
			}
			s DataCount=$o(^TMPEXCELEXPORT(mySysID,tablename,""),-1)
		}
		elseif (tablename="PAC_Bed") ///床位
		{
			s ParRef=0
			for
			{
				s ParRef=$o(^PAWARD(ParRef)) q:((ParRef="")||(ParRef'>0))
				if (HospAutflag="Y")&&(AuHospStr'="off")&&(AuHospStr'=1)
				{
					s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("PAC_Ward",ParRef)
					continue:showflag="N"
				}
				//床位表
				if ($d(^PAWARD(0,"Sequence"))>0)
				{
					s Sequence=0,flag0=0
					for
					{
						s Sequence=$o(^PAWARD(0,"Sequence",ParRef,Sequence))
						q:flag0=1
						if (Sequence="")	//先查询有序号的数据(0节点之后)，再查询没有序号(0节点)的数据
						{
							s flag0=1
							s Sequence=0
						}
						s BEDChildsub=0
						for
						{
							s BEDChildsub=$o(^PAWARD(0,"Sequence",ParRef,Sequence,BEDChildsub)) q:BEDChildsub=""
							s BEDRowID=ParRef_"||"_BEDChildsub
							s DataCount=DataCount+1
							s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=ParRef_"#"_BEDChildsub
						}
					}
				}
				else
				{
					s BEDChildsub=0
					for
					{
						s BEDChildsub=$o(^PAWARD(ParRef,"BED",BEDChildsub)) q:BEDChildsub=""
						s DataCount=DataCount+1
						s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=ParRef_"#"_BEDChildsub
					}
				}
				
				//房间分配（等候区）
				s Childsub=0
				for
				{
					s Childsub=$o(^PAWARD(ParRef,"ROOM",Childsub)) q:Childsub=""
					s DataCount=DataCount+1
					s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=ParRef_"#"_"#"_Childsub
				}
			}
		}
		elseif (tablename="ARC_ItemExternalCodes")  //检验外部代码  20191024
		{
			s subscript=0
			for
			{
				s subscript=$o(^ARCIM(subscript))   q:subscript=""  
				s version=0
				for 
				{
					s version=$o(^ARCIM(subscript,version))  q:version="" 
					s extsub=0
					for
					{
						s extsub=$o(^ARCIM(subscript,version,"EXT",extsub)) q:extsub=""  d
						continue:$p($g(^ARCIM(subscript,version,1)),"^",1)=""  //过滤空数据
						if (HospAutflag="Y")&&(AuHospStr'="off")&&(AuHospStr'=1)
						{
							s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("ARC_ItmMast",subscript_"||"_version)
							continue:showflag="N"
						}
						s DataCount=DataCount+1
						s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=subscript_"#"_version_"#"_extsub
					}	
				}
			}
		
		}
		elseif (tablename="DHC_CTLoc_MedUnitCareProv")  //医疗单元及关联医护人员  20191024
		{
			
			s CTLOCRowId=0
			for
			{
				s CTLOCRowId=$o(^CTLOC(CTLOCRowId)) q:CTLOCRowId=""
				if (HospAutflag="Y")&&(AuHospStr'="off")&&(AuHospStr'=1)
				{
					s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("CT_Loc",CTLOCRowId)
					continue:showflag="N"
				}
				s CTMUChildsub=0
				for
				{
					s CTMUChildsub=$o(^CTLOC(CTLOCRowId,"MU",CTMUChildsub)) q:CTMUChildsub=""
					s MURowId=CTLOCRowId_"||"_CTMUChildsub
					if $d(^CTLOC(CTLOCRowId,"MU", CTMUChildsub,"CP"))>0
					{
						s MUCPChildsub=0
						for
						{
							s MUCPChildsub=$o(^CTLOC(CTLOCRowId,"MU", CTMUChildsub,"CP",MUCPChildsub)) q:(MUCPChildsub="")  
							s DataCount=DataCount+1
							s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=CTLOCRowId_"#"_CTMUChildsub_"#"_MUCPChildsub
						}	
					}
					else
					{
						
						s DataCount=DataCount+1
						s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=CTLOCRowId_"#"_CTMUChildsub_"#"
						
					}
				}
			}
		
		}
		elseif (tablename="BDP_TableList")	//表结构登记及子表 20200920
		{
			s TBID=0
			for
			{
				s TBID=$o(^User.BDPTableListD(TBID)) q:TBID=""
				if $d(^User.BDPTableListD(TBID,"ChildField"))>0
				{
					s TBChildsub=0
				 	for 
				 	{
					 	s TBChildsub=$o(^User.BDPTableListD(TBID,"ChildField",TBChildsub)) q:TBChildsub=""
					 	s DataCount=DataCount+1
						s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=TBID_"#"_TBChildsub
				 	}
				}
				else
				{
					s DataCount=DataCount+1
					s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=TBID_"#"
				}
			}
		}
		elseif (tablename="CT_LocBuilding")	//医院楼及楼层子表	2022-04-20	likefan
		{
			s CTLBRowId=0
			for
			{
				s CTLBRowId=$o(^CT("CTLB",CTLBRowId)) q:CTLBRowId=""
				if $d(^CT("CTLB",CTLBRowId,"Floor"))
				{
					s CTLBFChildsub=0
				 	for 
				 	{
					 	s CTLBFChildsub=$o(^CT("CTLB",CTLBRowId,"Floor",CTLBFChildsub)) q:CTLBFChildsub=""
					 	s DataCount=DataCount+1
						s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=CTLBRowId_"#"_CTLBFChildsub
				 	}
				}
				else
				{
					s DataCount=DataCount+1
					s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=CTLBRowId_"#"
				}
			}
		}
		elseif (tablename="DHC_PHCCat")  //药理学分类  20191024
		{
			
			d ##class(web.DHCBL.BDP.BDPDataExport).GetChildPHCC(mySysID,tablename,0)
			s DataCount=$o(^TMPEXCELEXPORT(mySysID,tablename,""),-1)
		}
		elseif (tablename="PHC_Cat")  //药理学分类  20191024
		{
			s PHCCRowId=0
			for
			{
				s PHCCRowId=$o(^PHCC(PHCCRowId)) q:((PHCCRowId="")||(PHCCRowId'>0))   ;此处例外,不是在PHCCRowId为空的情况下quit
				s DataCount=DataCount+1
				s PHCCCode=$p($g(^PHCC(PHCCRowId)),"^",1)
				s PHCCDesc=$p($g(^PHCC(PHCCRowId)),"^",2)
				s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=1_"&%"_PHCCCode_"&%"_PHCCDesc
				s PHCSCChildSub=0 
				for
				{
					s PHCSCChildSub=$o(^PHCC(PHCCRowId,"SC",PHCSCChildSub)) q:PHCSCChildSub=""
					s DataCount=DataCount+1
					s PHCSCCode=$p($g(^PHCC(PHCCRowId,"SC",PHCSCChildSub)),"^",1)
					s PHCSCDesc=$p($g(^PHCC(PHCCRowId,"SC",PHCSCChildSub)),"^",2)
					s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=2_"&%"_PHCSCCode_"&%"_PHCSCDesc
					s MINChildsub=0
					for
					{
						s MINChildsub=$o(^PHCC(PHCCRowId,"SC",PHCSCChildSub,"MIN",MINChildsub)) q:MINChildsub=""
						s DataCount=DataCount+1
						s MINCode=$p($g(^PHCC(PHCCRowId,"SC",PHCSCChildSub,"MIN",MINChildsub)),"^",1)
						s MINDesc=$p($g(^PHCC(PHCCRowId,"SC",PHCSCChildSub,"MIN",MINChildsub)),"^",2)
						s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=3_"&%"_MINCode_"&%"_MINDesc
					}
				}
				
			}
		}
		else
		{
			s xrowid=0
			s xrowidstr="s xrowid="_EXCXGlobal
			s n=0
			for 
			{
				x xrowidstr  q:xrowid=""
				if (HospAutflag="Y")&&(AuHospStr'="off")&&(AuHospStr'=1)
				{
					if (tablename="DHCBorExaRoom")  //分诊区诊室对照
					{
						s BorDr=$LISTGET($g(^User.DHCBorExaRoomD(xrowid)),5)
						s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("DHCExaBorough",BorDr)
						continue:showflag="N"
					}
					elseif (tablename="DHCExaBorDep")  //分诊区科室对照
					{
						s BordBorDr=$LISTGET($g(^User.DHCExaBorDepD(xrowid)),6)
						s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("DHCExaBorough",BordBorDr)
						continue:showflag="N"
					}
					elseif (tablename="DHCDepMark")  //分诊区号别对照
					{
						s DepmBorDr=$LISTGET($g(^User.DHCDepMarkD(xrowid)),7)
						s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("DHCExaBorough",DepmBorDr)
						continue:showflag="N"
					}
					elseif (tablename="DHCMarkDoc")  //医生号别对照
					{
						s MarkddepDr=$LISTGET($g(^User.DHCMarkDocD(xrowid)),4)
						s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("CT_Loc",MarkddepDr)
						continue:showflag="N"
					}
					elseif (tablename="DHCBorUser")  //操作员诊区对照
					{
						s BorDr=$LISTGET($g(^User.DHCBorUserD(xrowid)),2)
						s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("DHCExaBorough",BorDr)
						continue:showflag="N"
					}
					else
					{
						//科室部门组，科室，安全组，诊断，供应商，厂商，产地，配送商,分诊区
						s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag(tableListName,xrowid)
						continue:showflag="N"	
					}
				}
				if tablename["DHC_TarItem"  //2019-04-24
			    {
			    	if $d(^DHCTARI(xrowid))=10 CONTINUE
			    }
				s DataCount=DataCount+1
				s ^TMPEXCELEXPORT(mySysID,tablename,DataCount)=xrowid
			}
		}		
	}
	q DataCount
}

/// Creator：chenying
/// CreatDate: 2021-05-26  V2
/// Description：导出excel 通过表名获取表描述  返回sheetname
/// Table：User.BDPIMConfig
/// Input：tablename
/// Other: w ##class(web.DHCBL.BDP.BDPDataExport).GetFieldValueV2("SS_User",1)
///        w ##class(web.DHCBL.BDP.BDPDataExport).GetFieldValueV2""MRC_ICDDx"",1)
///        w ##class(web.DHCBL.BDP.BDPDataExport).GetFieldValueV2("ARC_ItmMast",1)
ClassMethod GetFieldValueV2(tablename, i) As %String
{
	n (tablename, i,%session)
	s mySysID =$s($d(%session):%session.%Id(),1:$j)
	q:tablename="" ""
	
	s EImenuID=$o(^User.BDPEIMenuI("UniqueCodeIndex"," "_$zcvt(tablename,"U"),0))
	s LinkTableDr=$LISTGET($G(^User.BDPEIMenuD(EImenuID)),13)
	S tableListName=""
	if LinkTableDr'="" s tableListName=$LISTGET($G(^User.BDPTableListD(LinkTableDr)),8)  //获取导入导出菜单的表结构登记指针对应的代码
	if tableListName="" s tableListName=tablename
	
	s IMCID=$o(^User.BDPIMConfigI("UniqueTableName"," "_$zcvt(tablename,"U"),0))
	q:IMCID="" ""
	s EXCIsChildTable=$LISTGET($G(^User.BDPIMConfigD(IMCID)),14)  //是否子表
	s n=0
	if (EXCIsChildTable="Y")  //子表特殊处理父表xstr
	{	
		if (tablename="PAC_Bed") //病区id#床位id#等候区id
		{
			s IDStr=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			s xparref=$p(IDStr,"#",1)
			s xrowid=$p(IDStr,"#",2)
			s RoomDR="",DateFrom="",DateTo="",FloorId=""
			s:xrowid'="" RoomDR=$p($g(^PAWARD(xparref,"BED",xrowid)),"^",3)  //床位 房间指针
			s:xrowid'="" RoomDR=$p($g(^PAWARD(xparref,"BED",xrowid)),"^",3)  //床位 房间指针
			s RoomChildSub=$p(IDStr,"#",3)
			s:RoomChildSub'="" RoomDR=$p($g(^PAWARD(xparref,"ROOM",RoomChildSub)),"^",1)  //等候区 房间指针
			s:xrowid'="" DateFrom=$p($g(^PAWARD(xparref,"BED",xrowid)),"^",21)  //开始日期（床位）
			s:xrowid'="" DateTo=$p($g(^PAWARD(xparref,"BED",xrowid)),"^",22)  //结束日期（床位）
			s:RoomChildSub'="" DateFrom=$p($g(^PAWARD(xparref,"ROOM",RoomChildSub)),"^",7)  //开始日期（等候区）
			s:RoomChildSub'="" DateTo=$p($g(^PAWARD(xparref,"ROOM",RoomChildSub)),"^",8)  //结束日期（等候区）
		}
		else
		{
			s xparref=$p($g(^TMPEXCELEXPORT(mySysID,tablename,i)),"&#",1)
			s xrowid=$p($g(^TMPEXCELEXPORT(mySysID,tablename,i)),"&#",2)
		}
	}
	else
	{
		//update2019-03-10
		if (tablename["ARC_ItmMast") //医嘱项id#收费项id#关联id
		{
			s IDStr=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			s ARCIMRowId=$p(IDStr,"#",1)
			s ARCIMSubscript=$p($p(IDStr,"#",1),"||",1)
			s ARCIMVersion=$p($p(IDStr,"#",1),"||",2)
			s TARIRowId=$p(IDStr,"#",2)
			s OLTRowId=$p(IDStr,"#",3)
		}
		elseif (tablename="ARCItmMast")  //医嘱项id (所有医嘱项） //2019-02-16
		{
			s IDStr=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			s ARCIMRowId=$p(IDStr,"#",1)
			s ARCIMSubscript=$p($p(IDStr,"#",1),"||",1)
			s ARCIMVersion=$p($p(IDStr,"#",1),"||",2)
		}
		elseif (tablename="PHC_DrgMast")  ///库存项id#医嘱项id#收费项id#医嘱与收费项关联id#药学形态id
		{
			s IDStr=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			s INCIRowId=$p(IDStr,"#",1)
			s ARCIMRowId=$p(IDStr,"#",2)
			s ARCIMSubscript=$p(ARCIMRowId,"||",1)
			s ARCIMVersion=$p(ARCIMRowId,"||",2)
			s TARIRowId=$p(IDStr,"#",3)
			s OLTRowId=$p(IDStr,"#",4)
			s PHCDFRowId=$p(IDStr,"#",5)
			s PHCDRowId=$p(PHCDFRowId,"||",1)
			s PHCDFChildSub=$p(PHCDFRowId,"||",2)
			S INFORowId=""
			S:INCIRowId'="" INFORowId=$o(^DHCITMINFO(0,"INCI",INCIRowId,0))
			
		}
		elseif (tablename="PHC_DrgMastNew")  ///库存项id#医嘱项id#收费项id#库存与收费项关联id#药学形态id  2019-02-16
		{
			s IDStr=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			s INCIRowId=$p(IDStr,"#",1)
			s ARCIMRowId=$p(IDStr,"#",2)
			s ARCIMSubscript=$p(ARCIMRowId,"||",1)
			s ARCIMVersion=$p(ARCIMRowId,"||",2)
			s TARIRowId=$p(IDStr,"#",3)
			s INCTRRowId=$p(IDStr,"#",4)
			s PHCDFRowId=$p(IDStr,"#",5)
			s PHCDRowId=$p(PHCDFRowId,"||",1)
			s PHCDFChildSub=$p(PHCDFRowId,"||",2)
			S INFORowId=""
			S:INCIRowId'="" INFORowId=$o(^DHCITMINFO(0,"INCI",INCIRowId,0))
			
		}
		/*elseif (tablename["PHC_DrgMast")  ///库存项id#医嘱项id#收费项id#医嘱与收费项关联id#药学形态id#库存与收费项关联id 2021-05-29
		{
			s IDStr=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			s INCIRowId=$p(IDStr,"#",1)
			s ARCIMRowId=$p(IDStr,"#",2)
			s ARCIMSubscript=$p(ARCIMRowId,"||",1)
			s ARCIMVersion=$p(ARCIMRowId,"||",2)
			s TARIRowId=$p(IDStr,"#",3)
			s OLTRowId=$p(IDStr,"#",4)
			s INCTRRowId=$p(IDStr,"#",6)
			s PHCDFRowId=$p(IDStr,"#",5)
			s PHCDRowId=$p(PHCDFRowId,"||",1)
			s PHCDFChildSub=$p(PHCDFRowId,"||",2)
			S INFORowId=""
			S:INCIRowId'="" INFORowId=$o(^DHCITMINFO(0,"INCI",INCIRowId,0))
			
		}*/
		elseif (tablename="INC_Itm")  ///库存项id#医嘱项id#收费项id#医嘱与收费项关联id
		{
			s IDStr=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			s INCIRowId=$p(IDStr,"#",1)
			s ARCIMRowId=$p(IDStr,"#",2)
			s ARCIMSubscript=$p(ARCIMRowId,"||",1)
			s ARCIMVersion=$p(ARCIMRowId,"||",2)
			s TARIRowId=$p(IDStr,"#",3)
			s OLTRowId=$p(IDStr,"#",4)
			S INFORowId=""
			S:INCIRowId'="" INFORowId=$o(^DHCITMINFO(0,"INCI",INCIRowId,0))
		}
		elseif (tablename="SS_User")  ///用户id#医护人员id#类型（U,UC,C)
		{
			s IDStr=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			s SSUSRRowId=$p(IDStr,"#",1)
			s CTPCPRowId1=$p(IDStr,"#",2)
			s SSType=$p(IDStr,"#",3)
			if SSType["U" s URowId=SSUSRRowId
			else  s URowId=CTPCPRowId1
		}
		elseif (tablename="ARC_OrdSets")  //医嘱套 2019-04-04  update2019-04-08
		{
			s IDStr=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			s ARCOSRowId=$p(IDStr,"#",1)
			s DATEChildSub=$p(IDStr,"#",2)
			s ITMChildSub="",OSChildSub=""
			s Type=$p(IDStr,"#",4)
			s ChildSub=$p(IDStr,"#",3)
			if Type="TIM" s ITMChildSub=$p(IDStr,"#",3)
			if Type="OS" s OSChildSub=$p(IDStr,"#",3)
			s FavRowId=$o(^DHCFavItems(0,"ItemRowid",ARCOSRowId,0))
		}
		elseif (tablename="RB_ResEffDateSession")  //排版模板20190912
		{
			s IDStr=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			s RESRowId=$p(IDStr,"#",1)
			s DATEChildSub=$p(IDStr,"#",2)
			S SESSChildsub=$p(IDStr,"#",3)
			
		}
		elseif (tablename="INC_StkCat")  //库存分类 20191023
		{
			s INCSCRowId=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			s xrowid=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			s SCGRowid=$o(^DHCSCG("STKCAT",INCSCRowId,0))  //库存类组rowid
			
		}
		elseif (tablename="OrderCategory")  //医嘱分类 20191023
		{
			s IDStr=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			s ARCICRowId=$p(IDStr,"#",1)
			s ORCATRowId=$p(IDStr,"#",2)
		}
		elseif (tablename="ChargeCategory")  //费用分类 20191023
		{
			s IDStr=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			//s ARCSGRowId=$p(IDStr,"#",1)
			s HOSPRowId=$p(IDStr,"#",1)
			s TARSCRowId=$p(IDStr,"#",2)
			s TARICRowId=$p(IDStr,"#",3)
			s TAROCRowId=$p(IDStr,"#",4)
			s TARECRowId=$p(IDStr,"#",5)
			s TARACRowId=$p(IDStr,"#",6)
			s TARMCRowId=$p(IDStr,"#",7)
			s NTARMCRowId=$p(IDStr,"#",8)
		}
		elseif (tablename="RoomBedType")  //床位类型房间类型 20191024
		{
			
			s IDStr=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			s ROOMTRowId=$p(IDStr,"#",1)
			s BEDTPRowId=$p(IDStr,"#",2)
			
		}
		elseif (tablename="ARC_ItemExternalCodes")  //检验外部代码  20191024
		{
			
			s IDStr=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			s subscript=$p(IDStr,"#",1)
			s version=$p(IDStr,"#",2)
			s extsub=$p(IDStr,"#",3)
		
		}
		elseif (tablename="DHC_CTLoc_MedUnitCareProv")  //医疗单元及关联医护人员  20191024
		{
			
			s IDStr=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			s CTLOCRowId=$p(IDStr,"#",1)
			s CTMUChildsub=$p(IDStr,"#",2)
			s MUCPChildsub=$p(IDStr,"#",3)
		
		}
		elseif (tablename="BDP_TableList")	//表结构登记及子表 20200920
		{
			s IDStr=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			s TBID=$p(IDStr,"#",1)
			s TBChildsub=$p(IDStr,"#",2)
		}
		elseif (tablename="CT_LocBuilding")	//医院楼及楼层子表	2022-04-20	likefan
		{
			s IDStr=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			s CTLBRowId=$p(IDStr,"#",1)
			s CTLBFChildsub=$p(IDStr,"#",2)
		}
		elseif (tablename="PHC_Cat")  //药理学分类  20191024
		{
			s IDStr=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			s PHCCLevel=$p(IDStr,"&%",1)
			s PHCCCode=$p(IDStr,"&%",2)
			s PHCCDesc=$p(IDStr,"&%",3)
		}
		elseif (tablename="PAC_Bed") //病区id#床位id#等候区id
		{
			s IDStr=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
			s xparref=$p(IDStr,"#",1)
			s xrowid=$p(IDStr,"#",2)
			s RoomDR="",DateFrom="",DateTo="",FloorId=""
			s:xrowid'="" RoomDR=$p($g(^PAWARD(xparref,"BED",xrowid)),"^",3)  //床位 房间指针
			s:xrowid'="" RoomDR=$p($g(^PAWARD(xparref,"BED",xrowid)),"^",3)  //床位 房间指针
			s RoomChildSub=$p(IDStr,"#",3)
			s:RoomChildSub'="" RoomDR=$p($g(^PAWARD(xparref,"ROOM",RoomChildSub)),"^",1)  //等候区 房间指针
			s:xrowid'="" DateFrom=$p($g(^PAWARD(xparref,"BED",xrowid)),"^",21)  //开始日期（床位）
			s:xrowid'="" DateTo=$p($g(^PAWARD(xparref,"BED",xrowid)),"^",22)  //结束日期（床位）
			s:RoomChildSub'="" DateFrom=$p($g(^PAWARD(xparref,"ROOM",RoomChildSub)),"^",7)  //开始日期（等候区）
			s:RoomChildSub'="" DateTo=$p($g(^PAWARD(xparref,"ROOM",RoomChildSub)),"^",8)  //结束日期（等候区）
		}
		else
		{
			s xrowid=$g(^TMPEXCELEXPORT(mySysID,tablename,i))
		}
	}
	///先排序，不导入的不排序
	k SeqArray
	s mySMSeq=0
	s n=0
	for {
		s mySMSeq=$o(^User.BDPIMFieldConfigI("ParSeqIdx",IMCID,mySMSeq))
		q:(mySMSeq="")
		s IMFCchildsub=0
		for
		{
			s IMFCchildsub=$o(^User.BDPIMFieldConfigI("ParSeqIdx",IMCID,mySMSeq,IMFCchildsub)) q:IMFCchildsub=""
			s IMFCExport=$listget($g(^User.BDPIMConfigD(IMCID,"ChildField",IMFCchildsub)),14)  ///是否导出
			continue:IMFCExport="N"
			s n=n+1
			s SeqArray(n)=IMFCchildsub
		}
	}
	///没有填写顺序的排在有顺序的后面
	if $d(^User.BDPIMFieldConfigI("ParSeqIdx",IMCID,-100000000000000))>0
	{
		s IMFCchildsub=0
		for
		{
			s IMFCchildsub=$o(^User.BDPIMFieldConfigI("ParSeqIdx",IMCID,-100000000000000,IMFCchildsub)) q:IMFCchildsub=""
			s IMFCExport=$listget($g(^User.BDPIMConfigD(IMCID,"ChildField",IMFCchildsub)),14)  ///是否导出
			continue:IMFCExport="N"
			s n=n+1
			s SeqArray(n)=IMFCchildsub
		}
	}
	s vcount=0
	s vresult=""
	s n=0
	for 
	{
		s n=$o(SeqArray(n)) q:n=""
		s IMFCchildsub=$g(SeqArray(n))
		s IMFCFieldDesc=$LISTGET($G(^User.BDPIMConfigD(IMCID,"ChildField",IMFCchildsub)),2)
		s IMFCFieldName=$LISTGET($G(^User.BDPIMConfigD(IMCID,"ChildField",IMFCchildsub)),3)
		s IMFCRequired=$listget($g(^User.BDPIMConfigD(IMCID,"ChildField",IMFCchildsub)),9)
		s RFlag=0
		if (IMFCRequired="Y") s RFlag=1
		s IMFCFieldDescU=$ZCONVERT(IMFCFieldDesc,"U")
		continue:IMFCFieldDescU="ROWID"
		s vcount=vcount+1
		s EXFCGetField=$LISTGET($G(^User.BDPIMConfigD(IMCID,"ChildField",IMFCchildsub)),13)
	    s EXFCFieldType=$LISTGET($G(^User.BDPIMConfigD(IMCID,"ChildField",IMFCchildsub)),15)    ///String
	    s SSRowId=$g(SSUSRRowId),CTRowId=$g(CTPCPRowId1)
	    if ($g(SSType)="C")&&(IMFCFieldName="SSUSRInitials")
		{
			s EXFCGetField="$p($g(^CTPCP(CTPCPRowId1,1)),""^"",1)"
		}
		if ($g(SSType)="C")&&(IMFCFieldName="SSUSRName")
		{
			s EXFCGetField="$p($g(^CTPCP(CTPCPRowId1,1)),""^"",2)"
		}
		
	    s blankflag=0
	    if (tablename["ARC_ItmMast")&&(((EXFCGetField["TARIRowId")&&($g(TARIRowId)=""))||((EXFCGetField["OLTRowId")&&($g(OLTRowId)=""))) s blankflag=1
		if (tablename["PHC_DrgMast")&&(((EXFCGetField["TARIRowId")&&($g(TARIRowId)=""))||((EXFCGetField["OLTRowId")&&($g(OLTRowId)=""))||((EXFCGetField["ARCIMSubscript")&&($g(ARCIMSubscript)=""))||((EXFCGetField["ARCIMVersion")&&($g(ARCIMVersion)=""))||((EXFCGetField["PHCDFRowId")&&($g(PHCDFRowId)=""))||((EXFCGetField["PHCDRowId")&&($g(PHCDRowId)=""))||((EXFCGetField["INFORowId")&&($g(INFORowId)=""))||((EXFCGetField["INCTRRowId")&&($g(INCTRRowId)=""))) s blankflag=1
		if (tablename="INC_Itm")&&(((EXFCGetField["TARIRowId")&&($g(TARIRowId)=""))||((EXFCGetField["OLTRowId")&&($g(OLTRowId)=""))||((EXFCGetField["ARCIMSubscript")&&($g(ARCIMSubscript)=""))||((EXFCGetField["ARCIMVersion")&&($g(ARCIMVersion)=""))||((EXFCGetField["INFORowId")&&($g(INFORowId)=""))) s blankflag=1
		if (tablename="SS_User")&&(((EXFCGetField["SSUSRRowId")&&($g(SSUSRRowId)=""))||((EXFCGetField["CTPCPRowId1")&&($g(CTPCPRowId1)=""))) s blankflag=1
		if (tablename="ARC_OrdSets")&&(((EXFCGetField["ITMChildSub")&&($g(ITMChildSub)=""))||((EXFCGetField["OSChildSub")&&($g(OSChildSub)=""))||((EXFCGetField["FavRowId")&&($g(FavRowId)=""))) s blankflag=1
		if (tablename="INC_StkCat")&&((EXFCGetField["SCGRowid")&&($g(SCGRowid)="")) s blankflag=1
		if (tablename="ChargeCategory")&&(((EXFCGetField["ARCSGRowId")&&($g(ARCSGRowId)=""))||((EXFCGetField["TARSCRowId")&&($g(TARSCRowId)=""))||((EXFCGetField["TARICRowId")&&($g(TARICRowId)=""))||((EXFCGetField["TAROCRowId")&&($g(TAROCRowId)=""))||((EXFCGetField["TARECRowId")&&($g(TARECRowId)="")) ||((EXFCGetField["TARACRowId")&&($g(TARACRowId)="")) ||((EXFCGetField[",TARMCRowId")&&($g(TARMCRowId)=""))||((EXFCGetField["NTARMCRowId")&&($g(NTARMCRowId)=""))||((EXFCGetField["HOSPRowId")&&($g(HOSPRowId)=""))) s blankflag=1
		if (tablename="RoomBedType")&&(((EXFCGetField["ROOMTRowId")&&($g(ROOMTRowId)=""))||((EXFCGetField["BEDTPRowId")&&($g(BEDTPRowId)=""))) s blankflag=1
		if (tablename="DHC_CTLoc_MedUnitCareProv")&&((EXFCGetField["MUCPChildsub")&&($g(MUCPChildsub)="")) s blankflag=1
		if (tablename="BDP_TableList")&&((EXFCGetField["TBChildsub")&&($g(TBChildsub)="")) s blankflag=1
		if (tablename="CT_LocBuilding")&&((EXFCGetField["CTLBFChildsub")&&($g(CTLBFChildsub)="")) s blankflag=1	//医院楼及楼层子表	2022-04-20	likefan
		if (tablename="PAC_Bed")&&(((EXFCGetField["RoomChildSub")&&($g(RoomChildSub)=""))||((EXFCGetField["xrowid")&&($g(xrowid)=""))||((EXFCGetField["RoomDR")&&($g(RoomDR)=""))||((EXFCGetField="DateFrom")&&($g(DateFrom)=""))||((EXFCGetField="DateTo")&&($g(DateTo)=""))) s blankflag=1
		if blankflag=1
		{
			s EXFCIDToCodestr="s "_IMFCFieldName_"="""""
			x EXFCIDToCodestr
			if (vresult'="")||(vcount>1)
			{
				s vrs="s vresult=vresult_""&%""_"_IMFCFieldName
				x vrs
			}
			else
			{
				s vrs="s vresult="_IMFCFieldName
				x vrs
				
			}
		}
		else
		{
			if EXFCGetField="" s EXFCGetField=""""""
			
			s IMFCFieldNamestr="s "_IMFCFieldName_"="_EXFCGetField
			x IMFCFieldNamestr
			if (EXFCFieldType="DR")
			{
				s EXFCIDToCode=$LISTGET($G(^User.BDPIMConfigD(IMCID,"ChildField",IMFCchildsub)),12) //$listget($g(^IHBI.BaseKPIDefineD(KPIDR)),1)
				if (EXFCIDToCode'="")
				{
					s EXFCIDToCodestr="if "_IMFCFieldName_"'="""" s "_IMFCFieldName_"="_EXFCIDToCode
					x EXFCIDToCodestr
				}
			}
			if (EXFCFieldType["Date")
			{
				s datestr= "if "_IMFCFieldName_"'="""" s "_IMFCFieldName_"=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml("_IMFCFieldName_")"
				x datestr
			}
			if (EXFCFieldType["Time")
			{
				s datestr= "if "_IMFCFieldName_"'="""" s "_IMFCFieldName_"=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml("_IMFCFieldName_")"
				x datestr
			}
			if (vresult'="")||(vcount>1)
			{
				s vrs="s vresult=vresult_""&%""_"_IMFCFieldName
				x vrs
			}
			else
			{
				s vrs="s vresult="_IMFCFieldName
				x vrs
			}
		}
	}
	
	s ^TMPEXPORTEXCEL(tablename,"ROW")=i
	q vresult
}

/// Creator: chenying
/// CreatDate: 2021-05-29
/// Description: 取计费系统参数配置医院的默认缺省费别 id
/// Input:收费项rowid
/// OutPut:计费系统参数配置的默认缺省费别 id
/// Debug: w ##class(web.DHCBL.BDP.BDPDataExport).GetTARIDefInsType(20)
ClassMethod GetTARIDefInsType(TariId As %String) As %String
{
	n (TariId)
	s hospId=##class(web.DHCBL.BDP.BDPDataExport).GetHospital("DHC_TarItem",TariId,"")
	s InsType=""
	set Conf=..GetTarParaId(hospId)
	if (+Conf=0) {
		s Conf=$o(^DHCTarC("CF",""))
	}
	if (Conf'="") set InsType=$p($g(^DHCTarC("CF",Conf)),"^",3)
	q InsType
}

/// Creator: ZhYW
/// CreatDate: 2020-03-20
/// Description: 取计费系统参数配置
/// Input: hospId: CT_Hospital.RowId
/// Return: cfgId: DHC_TarPara.RowId
/// Debug: w ##class(web.DHCBL.BDP.BDPDataExport).GetTarParaId(2)
ClassMethod GetTarParaId(hospId As %String) As %String
{
	new (hospId)
	s myobj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCBL.BDP.BDPMappingHOSP"_"||"_"GetDefHospIdByTableName")
    i $IsObject(myobj)
    {
        s myobj=""
        set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_Com_TarPara", hospId)
    }
    else
    {
	    set defHospId=hospId
    }
	
	set cfgId=""
	set rowId="0"
	while ($o(^DHCTarC("CF",rowId))&&(cfgId="")) {
		set rowId=$o(^DHCTarC("CF",rowId))
		set hospDR=$p($g(^DHCTarC("CF",rowId)),"^",16)
		continue:(hospDR'=defHospId)
		set cfgId=rowId
	}
	
	quit cfgId
}

/// Creator:陈莹
/// CreatDate:2021-06-01
/// Description:获取厂商/供应商的信息
/// Other:w ##class(web.DHCBL.BDP.BDPDataExport).GetPropertyValueByRowId("Manf",555,"insProLic",6)
/// Other:w ##class(web.DHCBL.BDP.BDPDataExport).GetPropertyValueByRowId("Vendor",555,"comLic",6)
ClassMethod GetPropertyValueByRowId(CERTOrgType, CERTOrgId, CERTType, Location) As %String
{
	n (CERTOrgType,CERTOrgId,CERTType,Location)
	//Location  执照号6   14开始日期   9结束日期	
	s value=""
	Q:(CERTOrgType="")||(CERTOrgId="")||(CERTType="") ""
	s myobj=##class(%Dictionary.CompiledClass).%OpenId("User.DHCCertDetail")
    i ($IsObject(myobj))&&($d(^User.DHCCertDetailD))
    {
        if $d(^User.DHCCertDetailI("OrgType",CERTOrgType,CERTOrgId,CERTType))
		{
			s CertDetailID=$O(^User.DHCCertDetailI("OrgType",CERTOrgType,CERTOrgId,CERTType,0))
			Q:CertDetailID="" ""
			s value=$listget($g(^User.DHCCertDetailD(CertDetailID)),Location)     
		}
    }
    else  //取之前附加表的数据   
    {
	    if CERTOrgType="Manf"  //User.DHCManfAddionInfo
	    {
		    s MANFRowid=$o(^DHCMANF(0,"MANF",CERTOrgId,0))  
			if MANFRowid'=""
			{
				s MANFType=$p($g(^DHCMANF(MANFRowid)),"^",7)  //生产厂商类型
				//营业执照
				if (CERTType="comLic")&&(Location="6")
				{ 
					s value=$p($g(^DHCMANF(MANFRowid)),"^",8)  //营业执照号  MANFComLic  
				}
				if (CERTType="comLic")&&(Location="14")
				{
					s value=""                                  //营业执照号 开始日期
				}
				if (CERTType="comLic")&&(Location="9")
				{
					s value=$p($g(^DHCMANF(MANFRowid)),"^",9)  //营业执照号 结束日期  MANFComLicDate
				}
	    		//器械生产许可号
	    		if (CERTType="insProLic")&&(Location="6")
				{
					s value=$p($g(^DHCMANF(MANFRowid)),"^",5)  //器械生产许可号  MANFMatProductPermit
				}
				if (CERTType="insProLic")&&(Location="14")
				{
					s value=""                                  //器械生产许可号 开始日期
				}
				if (CERTType="insProLic")&&(Location="9")
				{
					s value=$p($g(^DHCMANF(MANFRowid)),"^",6)  //器械生产许可号 结束日期  MANFMatProductExpDate
				}
				//一类器械生产备案号
				if (CERTType="firstProdLic")&&(Location="6")
				{
					s value=""
				}
			}
			
	    }
	    
	    if CERTOrgType="Vendor"  //User.DHCSTVendor
	    {
	    	s STVRowId=$o(^DHCSTV(0,CERTOrgId,0))
	    	if STVRowId'=""
			{
		    	//营业执照
				if (CERTType="comLic")&&(Location="6")
				{ 
					s value=$p($g(^DHCSTV(STVRowId)),"^",1)  //营业执照号  STVComLic  
				}
				if (CERTType="comLic")&&(Location="14")
				{
					s value=""                                  //营业执照号 开始日期
				}
				if (CERTType="comLic")&&(Location="9")
				{
					s value=$p($g(^DHCSTV(STVRowId)),"^",2)  //营业执照号 结束日期  STVComLicDate
				}
				
				
				//经营许可证
				if (CERTType="insBusLic")&&(Location="6")
				{ 
					s value=$p($g(^DHCSTV(STVRowId)),"^",14)  //经营许可证  STVMatManLic
				}
				if (CERTType="insBusLic")&&(Location="14")
				{
					s value=""                                  //经营许可证 开始日期
				}
				if (CERTType="insBusLic")&&(Location="9")
				{
					s value=$p($g(^DHCSTV(STVRowId)),"^",15)  //经营许可证 结束日期  STVMatManLicDate
				}
				
				//二类经营备案号
				if (CERTType="secondBusLic")&&(Location="6")
				{ 
					s value=$p($g(^DHCSTV(STVRowId)),"^",82)  //二类经营备案号  STVSecondMatManLic
				}
				if (CERTType="secondBusLic")&&(Location="14")
				{
					s value=$p($g(^DHCSTV(STVRowId)),"^",85)  //二类经营备案号 开始日期  STVSecondMatManIssuedDate
				}
				if (CERTType="secondBusLic")&&(Location="9")
				{
					s value=$p($g(^DHCSTV(STVRowId)),"^",83)  //二类经营备案号 结束日期  STVSecondMatManLicDate
				}
			}
	    }
	    	
    }
	
	q value
}

/// 描述：根据床位ID返回楼层信息
/// 如果床位所属房间有定义楼层，返回房间楼层(楼-楼层)；如果没定义，返回病区对应科室的楼层(房间楼层优先级>科室楼层)
/// 基础数据平台-李可凡
/// 2020年9月1日
/// input：床位ID
/// output：楼层
/// w ##class(web.DHCBL.BDP.BDPDataExport).GetFloorByBedID("1||1")
ClassMethod GetFloorByBedID(id) As %String
{
	n (id)
	s parref=$p(id,"||",1)
	s childsub=$p(id,"||",2)
	q:(parref="")||(childsub="") ""
	s CTLBFFloor=""
	s BEDRoomDR=$p($g(^PAWARD(parref,"BED",childsub)),"^",3)
	if (BEDRoomDR'="")
	{
		s ROOMFloorDR=$p($g(^PAROOM(BEDRoomDR)),"^",11)	//房间的楼层DR
		s CTLBFParRef=$p(ROOMFloorDR,"||",1)
		s CTLBFChildsub=$p(ROOMFloorDR,"||",2)
		if (CTLBFParRef'="")&&(CTLBFChildsub'="")	//房间有定义楼层
		{
			s CTLBDesc=$p($g(^CT("CTLB",CTLBFParRef)),"^",2)		//医院楼描述
			s CTLBFFloor=$p($g(^CT("CTLB",CTLBFParRef,"Floor",CTLBFChildsub)),"^",1)  //楼层
			s CTLBFFloor=CTLBDesc_"-"_CTLBFFloor
			q CTLBFFloor
		}
	}
	if (CTLBFFloor="")	//返回病区所在科室的楼层
	{
		s WARDLocationDR=$p($g(^PAWARD(parref)),"^",5)	//科室
		if (WARDLocationDR'="")
		{
			s CTLOCFloor=$p($g(^CTLOC(WARDLocationDR)),"^",16)      //楼层DR
			s CTLBFParRef=$p(CTLOCFloor,"||",1)
			s CTLBFChildsub=$p(CTLOCFloor,"||",2)
			if (CTLBFParRef'="")&&(CTLBFChildsub'="")	//科室有定义楼层
			{
				s CTLBDesc=$p($g(^CT("CTLB",CTLBFParRef)),"^",2)		//医院楼描述
				s CTLBFFloor=$p($g(^CT("CTLB",CTLBFParRef,"Floor",CTLBFChildsub)),"^",1)  //楼层
				s CTLBFFloor=CTLBDesc_"-"_CTLBFFloor
				q CTLBFFloor
			}
		}
	}
	q CTLBFFloor
}

/// Creator:陈莹
/// CreatDate:2021-06-05
/// Description:根据街道代码获取街道描述
/// Other:w ##class(web.DHCBL.BDP.BDPDataExport).GetStreetDescByCode("110101007")
ClassMethod GetStreetDescByCode(Code) As %String
{
	
	n (Code)
	q:Code="" ""
	s Desc=""
	s RowId=$o(^CT("LOCTYPE",0,"Code",$$ALPHAUP^SSUTIL4(Code),0))
    s:RowId'="" Desc=$p($g(^CT("LOCTYPE",RowId)),"^",2)
    q Desc
}

/// Creator:陈莹
/// CreatDate:2021-06-05
/// Description:根据城市区域代码获取城市区域描述
/// Other:w ##class(web.DHCBL.BDP.BDPDataExport).GetCityAreaDescByCode("110101")
ClassMethod GetCityAreaDescByCode(Code) As %String
{
	
	n (Code)
	q:Code="" ""
	s Desc=""
	s RowId=$o(^CT("CITAREA",0,"Code",$$ALPHAUP^SSUTIL4(Code),0))
	s:RowId'="" Desc=$p($g(^CT("CITAREA",RowId)),"^",2) 
	q Desc
}

/*
1$公共信息
1.1$地理信息
CT_Country$国籍/地区
CT_Region$区域
CT_Province$省
CT_City$城市
CT_CityArea$城市区域
CT_Zip$邮编
CT_LocalityType$街道
CT_Community$社区
CT_Address$地址
CT_Occupation$职业
CT_Relation$家庭关系
CT_Title$职称
BDP_Translation$数据翻译
BDP_TableList$表结构登记
2$医院/科室/人员
RBC_DepartmentGroup$科室部门组
CT_LocBuilding$医院楼
CT_Loc$科室病区
CT_CarPrvTp$医护人员类型
SS_Group$安全组
CT_Spec$医生专长
SS_User$用户医护人员
DHC_CTLoc_MedUnitCareProv$医疗单元及关联医护人员
3$药品/材料/检查/治疗
PH_Manufacturer$生产厂商
APC_Vendor$供应商
DHC_STOrigin$产地
DHC_Carrier$配送商
PHC_Form$剂型
Uom$单位及转换系数
Freq$频次及分发时间
PHC_Instruc$用法
PHC_Duration$疗程
DHC_PHCCat$药理学分类
PHC_Cat$药理学分类[PHC_Cat]
OrderCategory$医嘱分类
INC_StkCat$库存分类
ARC_BillSub$账单分类
ChargeCategory$费用分类
DHC_PHChemical$药品通用名
PHC_Generic$药品通用名[旧模式]
PHC_DrgMast$药品[旧模式]
PHC_DrgMastNew$药品
INC_Itm$材料物资
ARC_ItmMast$检查检验治疗
ARC_OrdSets$医嘱套
DHC_TarItem$收费项目
4$接收科室
OEC_OrdCatRecLoc$医嘱大类接收科室
ARC_ItemCatRecLoc$医嘱子类接收科室
ARC_ItmRecLoc$医嘱项接收科室
5$诊断/麻醉/手术
MRC_ICDDx$ICD诊断
ORC_Operation$手术
MRC_TCMTreatment$中医治法
6$床位数据
PAC_BedType$床位类型
PAC_RoomType$房间类型
PAC_Bed$床位
7$医生站
DHCExaBorough$分诊区
DHCBorExaRoom$分诊区诊室对照
DHCExaBorDep$分诊区科室对照
DHCMarkDoc$医生号别对照
DHCDepMark$分诊区号别对照
DHCBorUser$操作员诊区对照
RB_ResEffDateSession$排班模板
9$检验
ARC_ItemExternalCodes$检验对应外部代码
dbo.BT_Hospital$医院
dbo.BT_Species$性别
dbo.BT_CostItem$收费项目
dbo.BT_TestCodeSCode$标准码
dbo.BT_Room$房间
dbo.BT_Department$检验科室
dbo.BT_CollectPrompt$采集提示
dbo.BT_ReportPrompt$取报告提示
dbo.BT_Container$采集容器
dbo.BT_Specimen$标本类型
dbo.BT_SpecimenGroup$标本组
dbo.BT_WorkGroup$工作组
dbo.BT_TestCode$检验项目
dbo.BT_WorkGroupMachine$工作小组
dbo.BT_TestSet$项目组合套
dbo.BT_TestSetGroup$组合套分组及关联
*/

// d ##class(web.ExportData).ExportData2("RB_ResEffDateSession")

ClassMethod ExportData(tablename)
{
	s file="/test/Export"_$replace(tablename,"_","")_$zd(+$h,8)_".txt"
 	OPEN file:("NRW"):5
 	WRITE !,"开始写数据到"_file_"",!
 	u file
	s FieldDescStr=##class(web.DHCBL.BDP.BDPDataExport).GetFieldDesc(tablename)
	s FieldNameStr=##class(web.DHCBL.BDP.BDPDataExport).GetFieldName(tablename)
	w FieldDescStr,!
	w FieldNameStr,!
	s count=##class(web.DHCBL.BDP.BDPDataExport).GetDataCount(tablename)  //GetDataCountV2
	s i=0
	f i=1:1:count d
	.s str=##class(web.DHCBL.BDP.BDPDataExport).GetFieldValue(tablename,i)  //GetFieldValueV2
	.w str,!

	c file
 	w "写文件完成",!
	d ##class(web.DHCBL.BDP.BDPDataExport).KillTMPEXCELEXPORTGlobal(tablename)
	q 0
}

ClassMethod ExportData2(tablename)
{
	s file="/test/Export"_$replace(tablename,"_","")_$zd(+$h,8)_".txt"
 	OPEN file:("NRW"):5
 	WRITE !,"开始写数据到"_file_"",!
 	u file
	s FieldDescStr=##class(web.DHCBL.BDP.BDPDataExport).GetTempletFieldDescV2(tablename)
	s FieldDesc=$p(FieldDescStr,"&%",2)
	s length=$l(FieldDesc,"&#")
	s str1=""
	s str2="" //$p(Desc,"^",2)

	f j=1:1:length d
	.s Desc=$p(FieldDesc,"&#",j)
	.i str1'="" s str1=str1_"&%"_$p(Desc,"^",1)
	.e  s str1=$p(Desc,"^",1)	
	.i str2'="" s str2=str2_"&%"_$p(Desc,"^",2)
	.e  s str2=$p(Desc,"^",2)

	w str1,!
	w str2,!
	s count=##class(web.DHCBL.BDP.BDPDataExport).GetDataCount(tablename)  //GetDataCountV2
	s i=0
	f i=1:1:count d
	.s str=##class(web.DHCBL.BDP.BDPDataExport).GetFieldValue(tablename,i)  //GetFieldValueV2
	.w str,!

	c file
 	w "写文件完成",!
	d ##class(web.DHCBL.BDP.BDPDataExport).KillTMPEXCELEXPORTGlobal(tablename)
	q 0
}

/// Creator:gss
/// CreatDate:2023-05-04
/// Description:返回用户是否启用岗位登录
/// Other:w ##class(web.DHCBL.BDP.BDPDataExport).GetSSUserIsEnablePostLogon(URowId)
ClassMethod GetSSUserIsEnablePostLogon(URowId) As %String
{
	n (URowId)
	Q:URowId="" ""
	s EnablePostLogon=""
	if (##class(web.DHCBL.BDP.FunLib).IsValidMethodName("BSP.SYS.SRV.StandardTypeItem","IsEnablePostLogon"))
	{
		s EnablePostLogon=##class(BSP.SYS.SRV.StandardTypeItem).IsEnablePostLogon(URowId)
		s EnablePostLogon=$CASE(EnablePostLogon,"1":"Y","0":"N",:"N") 
	}
	return EnablePostLogon
}

}
