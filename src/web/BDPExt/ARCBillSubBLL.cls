/// 名称:BDP数据导入-账单分类导入
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期:2020-06-11
Class web.BDPExt.ARCBillSubBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Description：单独账单分类导入保存接口
/// Creator：chenying
/// CreatDate: 2020-06-11
/// Input：通过Ceobj传参
/// Return:保存成功时返回 "{success:'true',id:'ARCBGRowId'}"   保存失败时返回错误信息
/// debug: w ##class(web.BDPExt.ARCBillSubBLL).SaveEntity(eobj)
ClassMethod SaveEntity(Ceobj As web.BDPExt.ChargeCategoryEntity) As %String
{
	new (Ceobj,%session)
	s ImportResult=""    
	s Ceobj.ARCBGDesc=Ceobj.ARCBGCode  //账单大类 
	s Ceobj.ARCBGAbbrev=Ceobj.ARCBGDesc
	s Ceobj.ARCSGDesc=Ceobj.ARCSGCode      //账单子类
	s Ceobj.ARCSGAbbrev=Ceobj.ARCSGDesc              
	
	; 帐单大类                                            
	s ARCBillGrpobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.ARCBillGrp")
	; 帐单子类    
	s ARCBillSubobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.ARCBillSub")
	
	; 1 账单大类 与账单子类
	s ARCBGRowId=""
	if (Ceobj.ARCBGCode'="")&(Ceobj.ARCSGCode'="")&&(Ceobj.ARCBGDesc'="")&(Ceobj.ARCSGDesc'="")
	{
		Tstart
		s ARCBGRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("ARC_BillGrp",Ceobj.ARCBGCode,Ceobj.LinkHospId)  //$o(^ARCBG(0,"Code",$$ALPHAUP^SSUTIL4(Ceobj.ARCBGCode),0))    
		if (ARCBGRowId="")
		{
			s ARCBillGrpobj.ARCBGRowId=""
			s ARCBillGrpobj.LinkHospId=Ceobj.LinkHospId
			s ARCBillGrpSaveResult=##class(web.DHCBL.CT.ARCBillGrp).SaveEntity(ARCBillGrpobj)
			s ARCBGRowId=##class(web.BDPExt.FunLib).GetResultRowId(ARCBillGrpSaveResult)
			if (ARCBGRowId="")
			{
				Tro
				s ImportResult="<账单大类>:"_ARCBillGrpSaveResult              
			}
		}
		if (ARCBGRowId'="")
		{
			; 账单子类
			s ARCSGSub=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("ARC_BillSub",Ceobj.ARCSGCode,Ceobj.LinkHospId)  //$o(^ARCBG("SG_Code",$$ALPHAUP^SSUTIL4(Ceobj.ARCSGCode),ARCBGRowId,0))
			if (ARCSGSub="")
			{
				s ARCBillSubobj.ParentRowId=ARCBGRowId
				s ARCBillSubobj.LinkHospId=Ceobj.LinkHospId
				s ARCBillSubSaveResult=##class(web.DHCBL.CT.ARCBillSub).SaveEntity(ARCBillSubobj)
				s ARCSGRowId=##class(web.BDPExt.FunLib).GetResultRowId(ARCBillSubSaveResult)     
				if (ARCSGRowId="")
				{
					Tro
					s ImportResult=ImportResult_"<账单子类>:"_ARCBillSubSaveResult              
				}
				else
				{
					TC
				}
			}
			else
			{
				Tro
				s ImportResult=ImportResult_"<账单子类>:"_Ceobj.ARCSGCode_"已存在。"
			}
		}
	}
	else
	{
		if ((Ceobj.ARCBGCode'="")||(Ceobj.ARCSGCode'="")||(Ceobj.ARCBGDesc'="")||(Ceobj.ARCSGDesc'="")) s ImportResult=ImportResult_"账单大类或账单子类有空值。"
	}
	
	if (ImportResult="")
	{
		s ImportResult="{success:'true',id:'"_$g(ARCBGRowId)_"'}" 
	}
	
	q ImportResult
}

}
