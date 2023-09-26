/// 科室病区扩展表
/// 基础数据-likefan
/// 2020-12-24
Class web.DHCBL.CT.CTLocExtend Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator: 基础数据-likefan
/// CreatDate: 2020-12-24
/// Description:增加/修改
/// Table: User.CTLocExtend
/// Input: web.Entity.CT.CTLocExtend
/// Return:成功返回success:'true'和新增或修改的数据的OPERRowId;失败返回success:'false'和失败原因
/// Other: w ##class(web.DHCBL.CT.CTLocExtend).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.CTLocExtend) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.CTLOCEMedtechFlag="" eobj.CTLOCEMedtechFlag="N"
		if (eobj.CTLOCERowID="")       
		{
			s obj=##class(User.CTLocExtend).%New()
		}
		else                           
		{
			s obj=##class(User.CTLocExtend).%OpenId(eobj.CTLOCERowID)
			s bobj = ##class(web.Entity.CT.CTLocExtend).%New()
			s bobj.CTLOCERowID = eobj.CTLOCERowID
			s bobj.CTLOCEItro = obj.CTLOCEItro
			s bobj.CTLOCEDeptType = obj.CTLOCEDeptType
			s bobj.CTLOCEAprvBedCnt = obj.CTLOCEAprvBedCnt
			s bobj.CTLOCEHiCrtfBedCnt = obj.CTLOCEHiCrtfBedCnt
			s bobj.CTLOCEPoolareaNo = obj.CTLOCEPoolareaNo
			s bobj.CTLOCEDrPsncnt = obj.CTLOCEDrPsncnt
			s bobj.CTLOCEPharPsncnt = obj.CTLOCEPharPsncnt
			s bobj.CTLOCENursPsncnt = obj.CTLOCENursPsncnt
			s bobj.CTLOCETecnPsncnt = obj.CTLOCETecnPsncnt
			s bobj.CTLOCEStandardCode = obj.CTLOCEStandardCode
			s bobj.CTLOCEStandardDesc = obj.CTLOCEStandardDesc
			s bobj.CTLOCEMedtechFlag = obj.CTLOCEMedtechFlag
			s bobj.CTLOCEDeptMedServScp = obj.CTLOCEDeptMedServScp
			s bobj.CTLOCEMedservType = obj.CTLOCEMedservType
			s bobj.CTLOCEMemo = obj.CTLOCEMemo
		}
		s obj.CTLOCEItro = eobj.CTLOCEItro	// 简介
		s obj.CTLOCEDeptType = eobj.CTLOCEDeptType	// 诊疗科目类别
		s obj.CTLOCEAprvBedCnt = eobj.CTLOCEAprvBedCnt	// 批准床位数量
		s obj.CTLOCEHiCrtfBedCnt = eobj.CTLOCEHiCrtfBedCnt	// 医保认可床位数
		s obj.CTLOCEPoolareaNo = eobj.CTLOCEPoolareaNo	// 统筹区编号
		s obj.CTLOCEDrPsncnt = eobj.CTLOCEDrPsncnt	// 医师人数
		s obj.CTLOCEPharPsncnt = eobj.CTLOCEPharPsncnt	// 药师人数
		s obj.CTLOCENursPsncnt = eobj.CTLOCENursPsncnt	// 护士人数
		s obj.CTLOCETecnPsncnt = eobj.CTLOCETecnPsncnt	// 技师人数
		s obj.CTLOCEStandardCode = eobj.CTLOCEStandardCode	//标准编码
		s obj.CTLOCEStandardDesc = eobj.CTLOCEStandardDesc	//标准名称
		s obj.CTLOCEMedtechFlag = eobj.CTLOCEMedtechFlag	//是否医技科室
		s obj.CTLOCEDeptMedServScp = eobj.CTLOCEDeptMedServScp	//科室医疗服务范围
		s obj.CTLOCEMedservType = eobj.CTLOCEMedservType	//医疗服务类型
		s obj.CTLOCEMemo = eobj.CTLOCEMemo	//备注
		
		Tstart
		s sc=obj.%Save()
		d obj.%Close()
		if $$$ISOK(sc){
			Tcommit
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			s CTLOCDesc=$p($g(^CTLOC(id)),"^",2)       //科室名
			d:eobj.CTLOCERowID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_LocExtend","User.CTLocExtend","科室信息扩展表",id,CTLOCDesc,"U",eobj,bobj)
			
			//调用医保组接口，记录科室变更状态，用于医保变更接口判断	2022-12-21
            d ##class(web.DHCINSUPort).UptLocFlag(id)
            
		}else{
			Trollback
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("科室信息扩展表","web.DHCBL.CT.CTLocExtend","SaveEntity",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Creator: 基础数据-likefan
/// CreatDate: 2020-12-24
/// Description:双击修改时查询数据
/// Table: User.CTLocExtend
/// Return:Json格式的字符串
/// Other: w ##class(web.DHCBL.CT.CTLocExtend).OpenData("1")
ClassMethod OpenData(id As %String) As web.BDP.sys.String
{
	s str=""
	s pobj = ##class(User.CTLocExtend).%OpenId(id)
	s eobj = ##class(web.Entity.CT.CTLocExtend).%New()
	s eobj.CTLOCERowID = id
	s eobj.CTLOCEItro = pobj.CTLOCEItro	// 简介
	s eobj.CTLOCEDeptType = pobj.CTLOCEDeptType	// 诊疗科目类别
	s eobj.CTLOCEAprvBedCnt = pobj.CTLOCEAprvBedCnt	// 批准床位数量
	s eobj.CTLOCEHiCrtfBedCnt = pobj.CTLOCEHiCrtfBedCnt	// 医保认可床位数
	s eobj.CTLOCEPoolareaNo = pobj.CTLOCEPoolareaNo	// 统筹区编号
	s eobj.CTLOCEDrPsncnt = pobj.CTLOCEDrPsncnt	// 医师人数
	s eobj.CTLOCEPharPsncnt = pobj.CTLOCEPharPsncnt	// 药师人数
	s eobj.CTLOCENursPsncnt = pobj.CTLOCENursPsncnt	// 护士人数
	s eobj.CTLOCETecnPsncnt = pobj.CTLOCETecnPsncnt	// 技师人数
	s eobj.CTLOCEStandardCode = pobj.CTLOCEStandardCode	//标准编码
	s eobj.CTLOCEStandardDesc = pobj.CTLOCEStandardDesc	//标准名称
	s eobj.CTLOCEMedtechFlag = pobj.CTLOCEMedtechFlag	//是否医技科室
	s eobj.CTLOCEDeptMedServScp = pobj.CTLOCEDeptMedServScp	//科室医疗服务范围
	s eobj.CTLOCEMedservType = pobj.CTLOCEMedservType	//医疗服务类型
	s eobj.CTLOCEMemo = pobj.CTLOCEMemo	//备注
	s:eobj.CTLOCEMedtechFlag="Y" eobj.CTLOCEMedtechFlag="true"	
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

}
