/// Description:科室导入程序
/// 涉及表:CT_Loc,PAC_AdmTypeLocation,CT_LocLinkLocation
Class web.BDPExt.CTLocBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod SaveEntity(Ceobj As web.BDPExt.CTLocEntity) As %String
{
	n (Ceobj,%session)
	s ImportResult=""
	
	///默认值 
	if Ceobj.CTLOCDateActiveFrom="" s Ceobj.CTLOCDateActiveFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	s:Ceobj.CTLOCIndex="" Ceobj.CTLOCIndex="Y"
	s:Ceobj.CTLOCExecuteConfirmation="" Ceobj.CTLOCExecuteConfirmation="Y"
	s:Ceobj.CTLOCMedicalRecordActive="" Ceobj.CTLOCMedicalRecordActive="Y"
	s:Ceobj.CTLOCActiveFlag="" Ceobj.CTLOCActiveFlag="Y"
	S Ceobj.CTLOCType=$$ALPHAUP^SSUTIL4(Ceobj.CTLOCType)
	if (Ceobj.CTLOCType="WARD") s Ceobj.CTLOCType="W"
	else  if (Ceobj.CTLOCType="EXECUTE") s Ceobj.CTLOCType="E"
	else  if (Ceobj.CTLOCType="DRUGINJECTION") s Ceobj.CTLOCType="DI"
	else  if (Ceobj.CTLOCType="DISPENSING") s Ceobj.CTLOCType="D"
	else  if (Ceobj.CTLOCType="CASHIER") s Ceobj.CTLOCType="C"
	else  if (Ceobj.CTLOCType="OTHER") s Ceobj.CTLOCType="O"
	else  if (Ceobj.CTLOCType="OPERATINGTHEATRE") s Ceobj.CTLOCType="OP"
	else  if (Ceobj.CTLOCType="EMERGENCY") s Ceobj.CTLOCType="EM"
	else  if (Ceobj.CTLOCType="DAYSURGERY") s Ceobj.CTLOCType="DS"
	else  if (Ceobj.CTLOCType="MEDICALRECORDS") s Ceobj.CTLOCType="MR"
	else  if (Ceobj.CTLOCType="OUTPATIENTCONSULTINGROOM") s Ceobj.CTLOCType="OR"
	else  if (Ceobj.CTLOCType="CLINIC") s Ceobj.CTLOCType="CL"
	else  if (Ceobj.CTLOCType="ADMISSIONPOINT") s Ceobj.CTLOCType="ADM"
	else  s Ceobj.CTLOCType=""
	
	if (Ceobj.CTLOCType="W")||(Ceobj.CTLOCType="EM")||(Ceobj.CTLOCType="OP") s Ceobj.WARDActive="Y"
	
	if Ceobj.CTLOCClinicType'=""
	{
		s Ceobj.CTLOCClinicType=$zcvt(Ceobj.CTLOCClinicType,"U")
		s length=$l(Ceobj.CTLOCClinicType,"/")
	
		s CTLOCClinicType=""
		for i=1:1:length
		{		
		
			s Type=$p(Ceobj.CTLOCClinicType,"/",i)
			s Type=$CASE(Type,"门诊":"O","住院":"I","急诊":"E","体检":"H",:"")  //作为接收科室时能接收的就诊类型
			if Type'=""
			{
				if CTLOCClinicType="" s CTLOCClinicType=Type
				else  s CTLOCClinicType=CTLOCClinicType_"&"_Type
			}
		}
		s Ceobj.CTLOCClinicType=CTLOCClinicType
		
	}
	// 楼层转为医院楼楼层id	likefan	20201202
	s Ceobj.CTLOCFloor=##class(web.DHCBL.CT.CTLocBuildingFloor).GetFloorIDByDesc(Ceobj.CTLOCFloor,Ceobj.CTLOCHospitalDR)
	
	s ctloceobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.CTLoc")
	s AdmTLobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.PACAdmTypeLocation")
	s CTLOCRowID=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("CT_Loc",Ceobj.CTLOCCode,Ceobj.CTLOCHospitalDR)
	Tstart
	if (CTLOCRowID="")  ///科室
	
	{
		s ctloceobj.CTLOCRowID=""
		if ctloceobj.CTLOCContactName="" s ctloceobj.CTLOCContactName=##class(web.DHCBL.BDP.FunLib).GetPYCODE(ctloceobj.CTLOCDesc)
		
		
		s CTLOCSaveResult=##class(web.DHCBL.CT.CTLoc).SaveEntity(ctloceobj,Ceobj.CTLOCClinicType)
		s CTLOCRowID=##class(web.BDPExt.FunLib).GetResultRowId(CTLOCSaveResult)
		if (CTLOCRowID'="")
		{
			if Ceobj.DataAlias'=""
			{
				if Ceobj.DataAlias["/"
				{
					s length=$l(Ceobj.DataAlias,"/")
					for i=1:1:length
					{
						s aliasi=$p(Ceobj.DataAlias,"/",i)
				 		d ##class(web.DHCBL.BDP.BDPAlias).Insert("CT_Loc",aliasi,CTLOCRowID) 
					}
				}
			}
			///访问类型位置  2017-05-17  考虑存在 科室分类为门诊/住院的情况
			if Ceobj.ADMLOCAdmType'=""
			{
				s Ceobj.ADMLOCAdmType=$zcvt(Ceobj.ADMLOCAdmType,"U")
				s length=$l(Ceobj.ADMLOCAdmType,"/")
				for i=1:1:length
				{	
					s Type=$p(Ceobj.ADMLOCAdmType,"/",i)
					s Type=$CASE(Type,"门诊":"O","住院":"I","急诊":"E","体检":"H",:"")  //访问类型位置
				 	if Type'=""
					{
						s AdmTLobj.ADMLOCCTLOCDR=CTLOCRowID
						s AdmTLobj.ADMLOCAdmType=Type
						s AdmTLSaveResult=##class(web.DHCBL.CT.PACAdmTypeLocation).SaveEntity(AdmTLobj)
						s ADMLOCRowId=##class(web.BDPExt.FunLib).GetResultRowId(AdmTLSaveResult)		
		
						if (ADMLOCRowId="")
						{
							s ImportResult="访问类型位置:"_AdmTLSaveResult				
						}
					}
				}
		
			}
			
			/*
			s Ceobj.ADMLOCAdmType=$CASE(Ceobj.ADMLOCAdmType,"门诊":"O","住院":"I","急诊":"E","体检":"H",:"")  //访问类型位置，只能关联一个科室分类
	
			///访问类型位置 一个科室只能关联一个科室分类 2020-06-04 //2022-07-20 去掉限制
			IF Ceobj.ADMLOCAdmType'=""
			{
				s AdmTLobj.ADMLOCCTLOCDR=CTLOCRowID
				s AdmTLobj.ADMLOCAdmType=Ceobj.ADMLOCAdmType
				s AdmTLSaveResult=##class(web.DHCBL.CT.PACAdmTypeLocation).SaveEntity(AdmTLobj)
				s ADMLOCRowId=##class(web.BDPExt.FunLib).GetResultRowId(AdmTLSaveResult)		
		
				if (ADMLOCRowId="")
				{
					s ImportResult="访问类型位置:"_AdmTLSaveResult				
				}
			}
			*/
			
		}
		else
		{
			s ImportResult="科室:"_CTLOCSaveResult	
		}
	}
	else
	{
		s ImportResult="科室:该代码已存在，校验失败"	
	}
	
	if (ImportResult="")
	{
		Tcommit
		s ImportResult="{success:'true',id:'"_CTLOCRowID_"'}" 
	}
	else
	{
		Trollback
	}
	q ImportResult
}

/// Creator:陈莹
/// CreatDate:2017-04-18
/// Description:新装科室时 要清除安全组库存授权 以及科室列表关联科室
/// Other:d ##class(web.BDPExt.CTLocBLL).ClearData()
ClassMethod ClearData()
{
	n
	//清除科室/病区/床位/访问类型位置
	k ^CTLOC,^PAWARD,^PAWARDA,^PAC("ADMLOC"),^PAC("PACWD")  //,^User.BDPAliasI,^User.BDPAliasD
	//清除组织部门关联Location 2020-12-25
	k ^User.CTDepartmentLocationD,^User.CTDepartmentLocationI
	//清除安全组库存授权
	s SSGRPRowId=0
	for  
	{	
		s SSGRPRowId=$o(^SSU("SSGRP",SSGRPRowId)) q:SSGRPRowId=""
		s SSGRPDesc=$p($g(^SSU("SSGRP",SSGRPRowId)),"^",1)  //Demo Group
		s sub=0
		for 
		{
			s sub=$o(^SSU("SSGRP",SSGRPRowId,"ST",sub)) q:sub=""
			s RowId=SSGRPRowId_"||"_sub
			d ##class(User.SSGroupStockLocations).%DeleteId(RowId)
		}
		k ^SSU("SSGRP",SSGRPRowId,"ST",0)	
	}
	//清除科室列表
	s ParRef=0
	for  
	{ 
		s ParRef=$o(^CT("LL",ParRef)) q:ParRef=""
		s ChildSub=0
		for  
		{ 
			s ChildSub=$o(^CT("LL",ParRef,"LOC",ChildSub)) q:ChildSub="" 
			s RowId=ParRef_"||"_ChildSub 
			d ##class(User.CTLocationListLocations).%DeleteId(RowId)	
		}
		k ^CT("LL",ParRef,"LOC",0)
	}
	//清除CDSS科室用户授权
	k ^User.BDPCDSSDeptUserAutD,^User.BDPCDSSDeptUserAutI  
	try
	{
		d ClearRegBaseData^DHCDocConfigClear() //调用医生站清除分诊区相关数据
	}
	catch(e)
	{
	}
	//人员关联科室。分配资源到科室
	k ^RB("RES")
	//清除医嘱大类接收科室
	s RLParRef=0
	for  
	{ 
		s RLParRef=$o(^OEC("ORCAT",RLParRef)) q:RLParRef=""
		s ChildSub=0
		for
		{
			s ChildSub=$o(^OEC("ORCAT",RLParRef,"RL",ChildSub)) q:(ChildSub="")
			s RowId=RLParRef_"||"_ChildSub 
			d ##class(User.OECOrdCatRecLoc).%DeleteId(RowId)
		}
		k ^OEC("ORCAT",RLParRef,"RL")
	}
	//清除医嘱子类接收科室
	s RLParRef=0
	for  
	{ 
		s RLParRef=$o(^ARC("IC",RLParRef)) q:RLParRef=""
		s ChildSub=0
		for
		{
			s ChildSub=$o(^ARC("IC",RLParRef,"RL",ChildSub)) q:(ChildSub="")
			s RowId=RLParRef_"||"_ChildSub 
			d ##class(User.ARCItemCatRecLoc).%DeleteId(RowId)
		}
		k ^ARC("IC",RLParRef,"RL")
	}
	//清除医嘱项接收科室
	k ^ARCRL
	//清除用法接收科室
	s ParRef=0
	for  
	{ 
		s ParRef=$o(^PHCIN(ParRef)) q:ParRef=""
		s InstrRecLocSub=0
		for
		{
			s InstrRecLocSub=$o(^PHCIN(ParRef,"RecLoc",InstrRecLocSub)) q:InstrRecLocSub=""
			s RowId=ParRef_"||"_InstrRecLocSub
			d ##class(User.DHCPHCInstrRecLoc).%DeleteId(RowId)
		}
		k ^PHCIN(ParRef,"RecLoc",0)
	}
}

/// Creator:陈莹
/// CreatDate:2017-04-18
/// Description:新装医院时 要清除安全组医院授权
/// Other:d ##class(web.BDPExt.CTLocBLL).ClearHospData()
ClassMethod ClearHospData()
{
	n
	s SSGRPRowId=0
	for  
	{	
		s SSGRPRowId=$o(^SSU("SSGRP",SSGRPRowId)) q:SSGRPRowId=""
		s sub=0
		for 
		{
			s sub=$o(^SSU("SSGRP",SSGRPRowId,"HOSP",sub)) q:sub=""
			s RowId=SSGRPRowId_"||"_sub
			d ##class(User.SSGroupHospitals).%DeleteId(RowId)
		}
		k ^SSU("SSGRP",SSGRPRowId,"HOSP",0)	
	}
}

}
