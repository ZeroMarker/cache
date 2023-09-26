/// Description：医疗单元及医疗单元关联医护人员导入程序
/// Creator：陈莹
/// CreatDate: 2017-05-31
Class web.BDPExt.DHCCTLocMedUnitCareProvBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Description：医疗单元及医疗单元关联医护人员保存接口
/// Creator：陈莹
/// CreatDate: 2017-05-31
/// Input：通过Ceobj传参
/// Return:保存成功时返回 "{success:'true',id:'MURowId'}"   保存失败时返回错误信息
/// debug: w ##class(web.BDPExt.DHCCTLocMedUnitCareProvBLL).SaveEntity(eobj)
ClassMethod SaveEntity(Ceobj As web.BDPExt.DHCCTLocMedUnitCareProvEntity) As %String
{
	n (Ceobj,%session)
	s ImportResult=""
	///日期为空时默认当天
	if Ceobj.CTMUDateFrom="" s Ceobj.CTMUDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)  ;医疗单元开始日期
	if Ceobj.MUCPDateFrom="" s Ceobj.MUCPDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)  ;医疗单元关联医护人员开始日期
	///默认医疗单元激活
	s:Ceobj.CTMUActiveFlag="" Ceobj.CTMUActiveFlag="Y"       ;是否激活
	s Ceobj.CTMUCTLOCParRef=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("CT_Loc",Ceobj.CTMUCTLOCParRef,Ceobj.LinkHospId)   ;医疗单元关联的科室
	s Ceobj.CTLocDr=Ceobj.CTMUCTLOCParRef   ;医疗单元关联的科室
	s CTMUobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.DHCCTLocMedUnit")
	s MUCPobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.DHCCTLocMedUnitCareProv")
	s CTMUobj.CTLocDr=Ceobj.CTMUCTLOCParRef   ;医疗单元关联的科室
	
	Ts	
	///校验数据是否重复
	s ret=##class(web.BDPExt.DHCCTLocMedUnitCareProvBLL).FormValidate(Ceobj.CTLocDr,Ceobj.CTMUCode,Ceobj.CTMUDesc)
	if $p(ret,"^",1)=0
	{
		s MURowId=$p(ret,"^",2)
		if (MURowId="")  ///医疗单元不存在时增加数据
		{
			///医疗单元
			s MUSaveResult=##class(web.DHCBL.CT.DHCCTLocMedUnit).SaveEntity("",Ceobj.CTMUActiveFlag,CTMUobj)
			s MURowId=##class(web.BDPExt.FunLib).GetResultRowId(MUSaveResult)
		}
		if (MURowId'=""){
			///医疗单元关联医护人员
			s MUCPobj.MUCPParRef=MURowId
			s MUCPobj.MUCPDoctorDR=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(Ceobj.CTPCPCode),0))
			s MUCPSaveResult=##class(web.DHCBL.CT.DHCCTLocMedUnitCareProv).SaveEntity(MUCPobj)
			s MUCPRowId=##class(web.BDPExt.FunLib).GetResultRowId(MUCPSaveResult)
			if (MUCPRowId="")
			{
				s ImportResult="医疗单元关联医护人员:"_MUCPSaveResult				
			}		    
			
		}else{
			s ImportResult="医疗单元:"_MUSaveResult	
		}
	}else{
		s ImportResult="医疗单元代码或描述重复"	
	}
	
	if (ImportResult="")
	{
		Tc
		s ImportResult="{success:'true',id:'"_$g(MUCPRowId)_"'}" 
	}
	else
	{
		Tro
	}
	q ImportResult
}

/// Creator:陈莹
/// CreatDate:20170330
/// Description:清除医疗单元表、医疗单元关联医护人员表
/// d ##class(web.BDPExt.DHCCTLocMedUnitCareProvBLL).ClearData()
ClassMethod ClearData()
{
	n
	s CTLOCROWID=0
	for 
	{
		s CTLOCROWID=$o(^CTLOC(CTLOCROWID)) q:CTLOCROWID=""
		s MUsub=0
		for 
		{
			s MUsub=$o(^CTLOC(CTLOCROWID,"MU",MUsub)) q:MUsub=""
			s MUROWID=CTLOCROWID_"||"_MUsub
			d ##class(User.DHCCTLocMedUnit).%DeleteId(MUROWID)
		}
		k ^CTLOC(CTLOCROWID,"MU",0)
	}
}

/// Description：代码，描述进行数据校验，判断是否重复，代码和描述对应同一个rowid时不判断重复
/// Creator：陈莹
/// CreatDate: 2017-05-31
/// Input：ctlocdr (科室rowid),code(代码）,desc(描述）
/// Return:1^5    
///  ^第一个返回值     1 （重复）， 0 （不重复
///  当第一个返回值为0时， 当不存在这条数据、描述或代码有一个为空时 第二个返回值为空 ，
///                      当代码和描述不为空且存在代码和描述对应的数据时，第二个返回值为对应医疗单元的rowid
/// debug: w ##class(web.BDPExt.DHCCTLocMedUnitCareProvBLL).FormValidate("1","33","3333")
ClassMethod FormValidate(ctlocdr As %String, code As %String, desc As %String) As %String
{
	n (ctlocdr,code,desc)
	s flag=0,CodeID=""
	s:code'="" code=$zcvt(code,"U")
	s:desc'="" desc=$zcvt(desc,"U")
	s HospId=""
	if ctlocdr'="" s HospId=$p($g(^CTLOC(ctlocdr)),"^",22) 
	s CTLocDr=0		
	if (code'="")&&(desc'="")
	{
		for
		{
			s CTLocDr=$o(^CTLOC(CTLocDr)) q:(CTLocDr="")||(flag=1)
			s CTHospitalDR=$p($g(^CTLOC(CTLocDr)),"^",22) 
			if CTHospitalDR=HospId  //校验同一个医院  医疗组代码和名称不重复。
			{
				s CTChildsub=0                                                                                 
				for
				{
					s CTChildsub=$o(^CTLOC(CTLocDr,"MU",CTChildsub)) q:(CTChildsub="")||(flag=1)
					s MURowId=CTLocDr_"||"_CTChildsub
					s CTMUCode=$p($g(^CTLOC(CTLocDr,"MU",CTChildsub)),"^",1)                   
					s CTMUDesc=$p($g(^CTLOC(CTLocDr,"MU",CTChildsub)),"^",2)

					if (($zcvt(CTMUCode,"U")=code)&&($zcvt(CTMUDesc,"U")=desc))
					{
						s flag=0
						s CodeID=MURowId
					}
					elseif (($zcvt(CTMUCode,"U")=code)||($zcvt(CTMUDesc,"U")=desc))
					{
						s flag=1
					}
					
				}
			}
		}
	
	}
	q flag_"^"_CodeID
}

}
