/// 2019-04-12
/// chenying
/// 导入医嘱套
Class web.BDPExt.ARCOrdSetsBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Description：医嘱套导入保存接口
/// Creator：陈莹
/// CreatDate: 2019-04-16
/// Input：通过Ceobj传参
/// Return:保存成功时返回 "{success:'true',id:'ARCOSRowId'}"   保存失败时返回错误信息
/// debug: w ##class(web.BDPExt.ARCOrdSetsBLL).SaveEntity(eobj)
/// Table:User.ARCOrdSets,User.DHCUserFavItems,User.ARCAlias,User.ARCOrdSetDate,User.ARCOrdSetDateItem
ClassMethod SaveEntity(Ceobj As web.BDPExt.ARCOrdSetsEntity) As %String
{
	n (%session,Ceobj)
	s $zt="ERROR"
	s ImportResult=""
	s Ceobj.Remarks=$CASE(Ceobj.Remarks,"取药医嘱":"ONE","出院带药":"OUT","PRN":"PRN","自备药":"OM","嘱托":"ZT",:"")  //附加说明
	s Ceobj.ITMStage=$CASE(Ceobj.ITMStage,"术前":"SQ","术中":"SZ","术后":"SH","产中":"CZ",:"")  //医嘱阶段
	s Ceobj.ITMVisible=$CASE(Ceobj.ITMVisible,"Yes":"Y","是":"Y","N":"N","No":"N","否":"N",:"")  //可见
	s:Ceobj.ITMVisible="" Ceobj.ITMVisible="Yes"
	Tstart	
	s:Ceobj.ARCOSEffDateFrom'="" Ceobj.ARCOSEffDateFrom = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Ceobj.ARCOSEffDateFrom)
	s:Ceobj.ARCOSEffDateTo'="" Ceobj.ARCOSEffDateTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Ceobj.ARCOSEffDateTo)
	if Ceobj.ARCOSEffDateFrom="" s Ceobj.ARCOSEffDateFrom=+$h
	s:Ceobj.ARCIMEffDate'="" Ceobj.ARCIMEffDate = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Ceobj.ARCIMEffDate)
	s:Ceobj.ARCIMEffDateTo'="" Ceobj.ARCIMEffDateTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Ceobj.ARCIMEffDateTo)
				
	s ARCOSRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("ARC_OrdSets",Ceobj.ARCOSCode,Ceobj.FavUseHospDr)    ///已存在的医嘱项跳过
	if (ARCOSRowId="")
	{
		//新增医嘱套
		s obj=##class(User.ARCOrdSets).%New()
		s obj.ARCOSCode = Ceobj.ARCOSCode
		s obj.ARCOSDesc= Ceobj.ARCOSDesc
		s obj.ARCOSActiveFlag="Y"
		s obj.ARCOSEffDateTime=$h
		d obj.ARCOSOrdCatDRSetObjectId(Ceobj.ARCOSOrdCatDR)
		d obj.ARCOSOrdSubCatDRSetObjectId(Ceobj.ARCOSOrdSubCatDR)
		s obj.ARCOSEffDateFrom = Ceobj.ARCOSEffDateFrom
		s obj.ARCOSEffDateTo = Ceobj.ARCOSEffDateTo
		s sc=obj.%Save()
		if $$$ISOK(sc){
			s ARCOSRowId = obj.%Id()
			//s ^TMPBJYG("ARC_OrdSets",ARCOSRowId)=$zd(+$h,3)
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_OrdSets","User.ARCOrdSets","医嘱套",ARCOSRowId,Ceobj.ARCOSDesc,"A",Ceobj)
			
			///权限表
			s obj1=##class(User.DHCUserFavItems).%New()
			d obj1.FavItemRowidSetObjectId(ARCOSRowId)  //注意有些项目是string
			//s obj1.FavItemRowid=ARCOSRowId
			s obj1.FavType="ARCOS"
			d obj1.FavUserDrSetObjectId(Ceobj.FavUserDr)
			d obj1.FavDepDrSetObjectId(Ceobj.FavDepDr)
			
			d obj1.FavUseHospDrSetObjectId(Ceobj.FavUseHospDr)  //用户所属医院	 add 2020-06-24	新扩展的字段
			if (Ceobj.FavUserDr="")&&(Ceobj.FavDepDr="")
			{
				s Ceobj.FavHospDr=Ceobj.FavUseHospDr
				d obj1.FavHospDrSetObjectId(Ceobj.FavHospDr)  //医嘱套医院
			}
			
			s sc=obj1.%Save()
			if $$$ISOK(sc){	
			
			}
			else
			{
				
				s ImportResult = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
			}
		}else{
			s ImportResult = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		}
	}
	
	if (ARCOSRowId'="")&&(ImportResult="")
	{
		if Ceobj.Alias=""
		{
			s Ceobj.Alias=##class(web.DHCBL.BDP.FunLib).GetPYCODE(Ceobj.ARCOSDesc)
			s:Ceobj.Alias["-" Ceobj.Alias=$p(Ceobj.Alias,"-",2)
			
		}
		if Ceobj.Alias'=""
		{
			//医嘱套别名 2019-06-05
			s length=$l(Ceobj.Alias,"/")
			s i=0
			for i=1:1:length
			{
				if $p(Ceobj.Alias,"/",i)'=""
				{
					s ALIASText=$p(Ceobj.Alias,"/",i)
					S ALIASR=""
					&sqL(select ALIAS_rowid INTO :ALIASR from SQLUser.ARC_Alias WHERE ALIAS_ARCOS_DR=:ARCOSRowId AND ALIAS_Type='ARCOS' AND ALIAS_Text=:ALIASText)
					if (+ALIASR=0)
					{
						
						k obj
						s obj = ##class(User.ARCAlias).%New()
						d obj.ALIASARCOSDRSetObjectId(ARCOSRowId)
						s obj.ALIASText=$p(Ceobj.Alias,"/",i)
						s obj.ALIASDesc=Ceobj.ARCOSDesc
						d obj.ALIASOrderSubCatDRSetObjectId(Ceobj.ARCOSOrdSubCatDR)
						s obj.ALIASDateFrom=Ceobj.ARCOSEffDateFrom
						s obj.ALIASDateTo=Ceobj.ARCOSEffDateTo
						s obj.ALIASType="ARCOS"
						d obj.%Save()
					}
				}
			}
		}
		
	}
	
	if (ARCOSRowId'="")&&(ImportResult="")
	{
		
		s DATEChildsub=$O(^ARCOS(ARCOSRowId,"DATE",""),-1)
		if DATEChildsub=""
		{	
			s dateobj=##class(User.ARCOrdSetDate).%New(ARCOSRowId)
			d dateobj.DATEParRefSetObjectId(ARCOSRowId)
			s dateobj.DATEDateFrom=Ceobj.ARCOSEffDateFrom
			s dateobj.DATEDateTo=Ceobj.ARCOSEffDateTo
			s sc=dateobj.%Save()
			if $$$ISOK(sc){
				s DATERowId= dateobj.%Id()
				s ^TMPBJYG("ARC_OrdSetDate",DATERowId)=$zd(+$h,3)
				s DATEChildsub=$p(DATERowId,"||",2)
			}
			else
			{
				s ImportResult = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
			}
		}
		else
		{
			s DATERowId= ARCOSRowId_"||"_DATEChildsub	
		}
		
		if ($g(DATERowId)'="")&&(ImportResult="")
		{
			if (Ceobj.Type="医嘱项")
			{
				
				if (Ceobj.ARCIMCode'="")
				{
					s arcimrowid=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("ARC_ItmMast",Ceobj.ARCIMCode,Ceobj.FavUseHospDr)
					if arcimrowid=""
					{
						s ImportResult="项目代码（医嘱项）不存在，"
					}
					else
					{
						s Desc1=$p($g(^ARCIM($p(arcimrowid,"||",1),$p(arcimrowid,"||",2),1)),"^",2)
						if (Desc1'=Ceobj.ARCIMDesc)
						{
							 s ImportResult="医嘱项代码和描述不对应，"
						}
						else
						{
							s itmobj=##class(User.ARCOrdSetDateItem).%New(DATERowId)
							d itmobj.ITMParRefSetObjectId(DATERowId)
							d itmobj.ITMARCIMDRSetObjectId(arcimrowid)
							s itmobj.ITMSerialNo=Ceobj.ITMSerialNo
							d itmobj.ITMInstrucDRSetObjectId(Ceobj.ITMInstrucDR)
							d itmobj.ITMFreqDRSetObjectId(Ceobj.ITMFreqDR)
							s itmobj.ITMQty = Ceobj.ITMQty
							
							s itmobj.ITMDoseQty=Ceobj.ITMDoseQty 
							d itmobj.ITMUOMDRSetObjectId(Ceobj.ITMUOMDR)  //剂量单位
							s itmobj.ITMVisible= "Y"
							s itmobj.ITMLinkToVisibleItem=Ceobj.ITMLinkToVisibleItem   //关联   -->ITM_LinkDoctor2020-06-24
							d itmobj.ITMDuratDRSetObjectId(Ceobj.ITMDuratDR)
							
							set PropObj=##class(%Dictionary.PropertyDefinition).%OpenId("User.ARCOrdSetDateItem||ITMRecLocDR",0)
							i $IsObject(PropObj)
							{
								d itmobj.ITMRecLocDRSetObjectId(Ceobj.ITMRecLocDR)
							}
							set PropObj=##class(%Dictionary.PropertyDefinition).%OpenId("User.ARCOrdSetDateItem||ITMStage",0)
							i $IsObject(PropObj)
							{
								s itmobj.ITMStage=Ceobj.ITMStage   //医嘱阶段
							}
							set PropObj=##class(%Dictionary.PropertyDefinition).%OpenId("User.ARCOrdSetDateItem||ITMPackQtyUomDR",0)
							i $IsObject(PropObj)
							{
								d itmobj.ITMPackQtyUomDRSetObjectId(Ceobj.ITMPackQtyUomDR)
							}
							set PropObj=##class(%Dictionary.PropertyDefinition).%OpenId("User.ARCOrdSetDateItem||ITMSkinTest",0)
							i $IsObject(PropObj)
							{
								s itmobj.ITMSkinTest=Ceobj.ITMSkinTest
							}
							set PropObj=##class(%Dictionary.PropertyDefinition).%OpenId("User.ARCOrdSetDateItem||ITMSkinTestAction",0)
							i $IsObject(PropObj)
							{
								d itmobj.ITMSkinTestActionSetObjectId(Ceobj.ITMSkinTestAction)
							}
							set PropObj=##class(%Dictionary.PropertyDefinition).%OpenId("User.ARCOrdSetDateItem||ITMLinkDoctor",0)
							i $IsObject(PropObj)
							{
								s itmobj.ITMLinkDoctor=Ceobj.ITMLinkDoctor  //关联
							}
							s sc=itmobj.%Save()
							if $$$ISOK(sc){
								s ITMRowId = itmobj.%Id()
								s DATEChildsub=$p(ITMRowId,"||",2)
								s ITMChildsub=$p(ITMRowId,"||",3)
								//s ^TMPBJYG("ARC_OrdSetDateItem",ITMRowId)=$zd(+$h,3)
								s ^ARCOS(ARCOSRowId,"DATE",DATEChildsub,"ITM",ITMChildsub,"NOTES","^",1)=Ceobj.ITMNotes   //备注 									
								s $p(^ARCOS(ARCOSRowId,"DATE",DATEChildsub,"ITM",ITMChildsub,"DHC"),"^",1)=Ceobj.ITMType  //医嘱类型
								s $p(^ARCOS(ARCOSRowId,"DATE",DATEChildsub,"ITM",ITMChildsub,"DHC"),"^",2)=Ceobj.Specimen  //标本
								s $p(^ARCOS(ARCOSRowId,"DATE",DATEChildsub,"ITM",ITMChildsub,"DHC"),"^",3)=Ceobj.Remarks   //附加说明
								s $p(^ARCOS(ARCOSRowId,"DATE",DATEChildsub,"ITM",ITMChildsub,"DHC"),"^",4)=Ceobj.OrderMustEnter   //是否必开
								d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_OrdSetDateItem","User.ARCOrdSetDateItem","医嘱套-医嘱项",ITMRowId,Ceobj.ARCOSDesc_"-"_Ceobj.ARCIMDesc,"A",Ceobj)	
							
							}else{
								
								s ImportResult = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
							}
						}
					}
				}
			}
			elseif (Ceobj.Type="医嘱套")
			{
				if (Ceobj.ARCIMCode'="")
				{
					s arcosid=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("ARC_OrdSets",Ceobj.ARCIMCode,Ceobj.FavUseHospDr)
					if arcosid=""
					{
						s ImportResult="项目代码（医嘱套）不存在，"
					}
					else
					{
						s Desc1=$p($g(^ARCOS(arcosid)),"^",2)
						if (Desc1'=Ceobj.ARCIMDesc)
						{
							s ImportResult="医嘱套代码和描述不对应，"
						}
						else
						{
							s osobj=##class(User.ARCOrdSetDateOS).%New(DATERowId)
							d osobj.OSParRefSetObjectId(DATERowId)
							d osobj.OSOrderSetDRSetObjectId(arcosid)
									
							s sc=osobj.%Save()
							if $$$ISOK(sc){
								s OSRowId = osobj.%Id()
								//s ^TMPBJYG("ARC_OrdSetDateOS",OSRowId)=$zd(+$h,3)
								d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_OrdSetDateOS","User.ARCOrdSetDateOS","医嘱套-医嘱套",OSRowId,Ceobj.ARCOSDesc_"-"_Ceobj.ARCIMDesc,"A",Ceobj)	
							}else{
								
								s ImportResult = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
							}	
						}
					}
				}
					
			}
		}
		else
		{
			s ImportResult="医嘱套User.ARCOrdSetDate数据有误"
			
		}	
	}
	else
	{
		
		s ImportResult="医嘱套:"_myVresult	
	}
	
	if (ImportResult="")
	{
		Tcommit
		s ImportResult="{success:'true',id:'"_$g(ARCOSRowId)_"'}"
	}
	else
	{
		Trollback	
	}
	
	q ImportResult
ERROR
	Q "导入报错"_$ZE
}

/// Creator：基础数据平台组 陈莹
/// CreatDate: 2019-04-22 update 2020-06-30
/// Description：获取标本对应的code
/// Table： ARC_OrdSets
/// Input：  desc
/// Return："1"(数据重复),"0"(数据不重复)
/// w ##class(web.BDPExt.ARCOrdSetsBLL).GetSpecimenIDByDesc("血")
ClassMethod GetSpecimenIDByDesc(desc) As %String
{
	n (desc)
	s Code=""
	i $d(^DHCLISBSVersion(1))&&(desc'="")
	{
		s ID=0
		for
		{
			s ID=$O(^dbo.BTSpecimenD(ID)) Q:ID=""
			s SpecimenDesc=$lg($g(^dbo.BTSpecimenD(ID)),3)
			if (SpecimenDesc=desc)
			{
				s Code=$lg($g(^dbo.BTSpecimenD(ID)),2)
			}
		}
	}
	else
	{
		s ID=0
		for
		{
			s ID=$O(^TTAB("SPEC",ID)) Q:ID=""
			s SpecimenDesc=$p($G(^TTAB("SPEC",ID)),"\",1)
			if (SpecimenDesc=desc)
			{
				s Code=ID
			}
		}
	}
		
	q Code
}

/// Creator:陈莹
/// CreatDate:2020-04-14
/// Description:新装医嘱套时，要清掉原来的global
/// Table:User.ARCOrdSets,User.DHCUserFavItems,User.ARCAlias,User.ARCOrdSetDate,User.ARCOrdSetDateItem
/// Other:d ##class(web.BDPExt.ARCOrdSetsBLL).ClearData()
ClassMethod ClearData()
{
	n
	k ^ARCOS,^DHCFavItems
	s ARCOSRowId=0
	for
	{
		s ARCOSRowId=$o(^ARC("ALIAS",0,"ARCOS",ARCOSRowId))  q:ARCOSRowId=""
		s ALIASRowId=0
		for
		{
			s ALIASRowId=$o(^ARC("ALIAS",0,"ARCOS",ARCOSRowId,ALIASRowId))  q:ALIASRowId=""
			D ##class(User.ARCAlias).%DeleteId(ALIASRowId)
		}
	}
}

}
