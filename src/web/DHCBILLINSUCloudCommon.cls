Class web.DHCBILLINSUCloudCommon Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator: tangzf
/// CreateDate: 2019-07-18
/// Descript: 根据session来获取此角色的真实医院级别权限。
/// Input:	
/// Output: 
/// Return: 有权查看：Y ;无权查看：N
/// DeBug: w ##class(web.DHCBILLINSUCloudCommon).getBDPMappingHosp()
ClassMethod GetBDPMappingHosp() As %String
{
	s HospAutStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
	q HospAutStr
}

/// Creator: tangzf
/// CreateDate: 2019-07-18
/// Descript: 批量写入 通用医院关联表
/// Input:	Type : 导入类型
/// 		Hospital  : 医院ROWID
/// Output: 
/// Return: 成功数量
/// DeBug: w ##class(web.DHCBILLINSUCloudCommon).BatchInsertBDPMappingHosp("DICDATA",2)
ClassMethod BatchInsertBDPMappingHosp(TableName, Hospital) As %String
{
	q:(TableName="") "-1^表名不能为空"
	q:(Hospital="") "-2^医院指针不能为空" 
	s SuccessNum=0
	;医保字典
	i TableName="INSU_DicData"  d
	.s INSUDicDataRowId=0
	.f  s INSUDicDataRowId=$o(^DHCINDID(INSUDicDataRowId)) q:(INSUDicDataRowId="")||(SuccessNum=1)  d
	..s err=##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("INSU_DicData",INSUDicDataRowId,Hospital)
	..b ;insert
	..i +err=-1 d
	...s ^CacheTemp("BatchInsertBDPMappingHosp","ErrData",INSUDicDataRowId)=err
	..i +err>0  d
	...s SuccessNum=SuccessNum+1
	...s ^CacheTemp("BatchInsertBDPMappingHosp","SuccessData",INSUDicDataRowId)=$p(err,"^",1)
	q SuccessNum
}

/// Creator: tangzf
/// CreateDate: 2019-07-18
/// Descript: 
/// Input: 
/// Output: 
/// Return: 
/// DeBug: w ##class(web.DHCBILLINSUCloudCommon).SetSessionData()
ClassMethod SetSessionData(val) As %String
{
	//Set ^temp("SetSessionData") = val
	Do %session.Lock()
	Set %session.Data("DHCBILLINSUCloud.Hospital") = val 
	q 1
}

/// Creator: tangzf
/// CreateDate: 2019-07-18
/// Descript: 取基础数据表医院Id
/// 涉及表：BDP_MappingHosp 
/// Input:	TableName :      表名 ,例如 DHC_TarItem
/// 		DataReference  : TableName中 的ROWID
/// 		ParmHospital  : 界面通过医院下拉框 获取到的医院rowid
/// Output: 
/// Return: 有权查看：Y ;无权查看：N
/// DeBug: w ##class(web.DHCBILLINSUCloudCommon).GetBDPMappingHospId("DHC_TarItem",889)
ClassMethod GetBDPMappingHospId(TableName, DataReference) As %String
{
	q:(TableName=""||DataReference="") ""
	s Hospital=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospital(TableName,DataReference,"ID")
	q Hospital
}

/// Creator: tangzf
/// CreateDate: 2020-05-08
/// Descript: 取医保分组表 默认院区Id
/// 涉及表： User.INSUDataGroup 
/// Input:	TableName :      表名 ,例如 DHC_TarItem
/// 		ParmHospital  : 界面通过医院下拉框 获取到的医院rowid
/// Output: 
/// Return: 有权查看：Y ;无权查看：N
/// DeBug: w ##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("INSUConBDPTableList","")
/// 该接口不允许随意修改 ！
ClassMethod GetINSUGroupDefaultHospId(TableName As %String, ParmHospital As %String = "", date As %String = "") As %String
{
	new (TableName, ParmHospital,date,%session)
	quit:(TableName="") "-1"
	
	//quit:TableName="INSUConBDPTableList" "" // 表结构登记对照

	set BusinessCode=..GetINSUDicCode(TableName)
	
	set DataType=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDataType(BusinessCode)	 //获取数据公有私有类型 公有数据不带医院表示
	quit:DataType="G" ""
	set DefaultHosp=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName(BusinessCode,ParmHospital,date)
	quit DefaultHosp
}

/// Creator: tangzf
/// CreateDate: 2020-05-20
/// Descript: 根据院区ID获取医院分组默认Id  未分组的返回传入院区的Id
/// 涉及表： 
/// Input:	BusinessCode :      表名 ,例如 DHC_TarItem,AKC021ZZB
/// 		ParmHospital  : TableName中 的ROWID
/// Output: 
/// Return: 医院分组默认Id  未分组的返回传入院区的Id
/// DeBug: w ##class(web.DHCBILLINSUCloudCommon).GetHISDefaultHospId("INSU_DicData",2)
/// 该接口不允许随意修改 ！
ClassMethod GetHISDefaultHospId(BusinessCode, ParmHospital, date As %String = "") As %String
{
	new (BusinessCode, ParmHospital,date,%session)
	q:(BusinessCode="") ""
	q:ParmHospital="" ""
	//s:(ParmHospital="")&&(%session'="") ParmHospital=$g(%session.Data("DHCBILLINSUCloud.Hospital"))
	//根据paramHosp获取分组默认Id
	s BusinessCode=..GetINSUDicCode(BusinessCode)
	s DefaultHosp=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName(BusinessCode,ParmHospital,date)
	q DefaultHosp
}

/// Creator: tangzf
/// CreateDate: 2020-05-20
/// Descript: 根据医保字典 系统Code(AKC021ZZB)  查询表结构登记中的实际code(AKC021ZZB)
/// 涉及表： 
/// Input:	Code :      AKC021ZZB
/// Output: 
/// Return:  AKC021
/// DeBug: w ##class(web.DHCBILLINSUCloudCommon).GetINSUDicCode("DLLType")
ClassMethod GetINSUDicCode(Code) As %String
{
	new (Code)
	set rtn=""
	
	/*01-医保基础表数据取值*/
	set TableCode=Code
	set tmpTableListID=$o(^User.BDPTableListI("NameIndex"," "_$ZCONVERT(TableCode,"U"),0))
	quit:+tmpTableListID'=0 TableCode  //如果根据索引找到code则说明已经进行登记
	
	/*02-医保配置字典(不包括医保类型)取值*/
	set DicCfgCode="INSU_DicSys_"_Code
	set tmpTableListID=$o(^User.BDPTableListI("NameIndex"," "_$ZCONVERT(DicCfgCode,"U"),0))
	quit:+tmpTableListID'=0 DicCfgCode   //如果根据索引找到code则说明已经进行登记
	
	/*03-医保字典数据，医保对照数据(一般是带医保类型的字典)取值*/
	set DicCfgCode=""
	set DicDataId=$o(^DHCINDID("0","ITypeCode","INSUConBDPTableList",Code,""))
	set:DicDataId'="" DicCfgCode=$p(^DHCINDID(DicDataId),"^",4)
	quit:DicCfgCode="" rtn
	set tmpTableListID=$o(^User.BDPTableListI("NameIndex"," "_$ZCONVERT(DicCfgCode,"U"),0))
	quit:+tmpTableListID'=0 DicCfgCode   //如果根据索引找到code则说明已经进行登记

	
	quit rtn
}

/// Creator: tangzf
/// CreateDate: 2019-07-18
/// Descript: 判断当前登录人是否有显示 表里某一条数据的权限 
/// Input:	TableName : 表名 ARC_ItemCat 必传
/// 		DataReference  : TableName中 的ROWID 必传
/// 		ParmHospital  : 界面通过医院下拉框 获取到的医院rowid
/// 		TableHospital : 数据表中的院区
/// 		BaseDataFlag : ="Y" 基础平台数据，通过基础数据平台接口判断 时 此处传Y 
/// Output: 
/// Return: 有权查看：Y ;无权查看：N,
/// DeBug: w ##class(web.DHCBILLINSUCloudCommon).CheckDataSession("INSU_DicData",2421,2)
ClassMethod CheckDataSession(TableName As %String, DataReference As %String, ParmHospital As %String = "", TableHospital As %String = "", BaseDataFlag As %String = "") As %String
{
	s rtn="N"
	
	s:($g(%session)'="")&&(+ParmHospital=0) ParmHospital=$g(%session.Data("DHCBILLINSUCloud.Hospital"))
	s ^CacheTemp("BillCheckDataSession")=$lb(TableName, DataReference, ParmHospital,TableHospital,BaseDataFlag)
	
	// 院区 表名 数据ROWID 不能为空
	q:(ParmHospital="")&&(TableHospital="") rtn
	q:TableName="" rtn
	q:DataReference="" rtn
	
	
	//超级管理员 此处需要有Session权限
	//s AuthFlag=""
	//s:$g(%session)'="" AuthFlag=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag() // 返回1为管理员 权限最高
	//quit:AuthFlag="1" "Y"
	
	//q:(TableHospital="")&&(Type'="Y") "N" // 数据表中的院区指针为空 集团管控数据 的模板
	
	i (ParmHospital=TableHospital)  d
	.s rtn="Y"

	// 基础平台数据，通过基础数据平台接口判断
	if BaseDataFlag="Y"  d
	.//s HospAutflag = ..GetHospAuthorize() //获取平台配置是否开启医院级别授权 
	.//i ($g(%session)'="")&&(HospAutflag="Y")  d // 开启院区授权开关
	.s rtn=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(TableName,DataReference,ParmHospital)
	.//else  d
	.//.s rtn=..GetHospShowDataFlag($zcvt(TableName,"U"),DataReference,ParmHospital)
	
	q rtn
}

/// Creator: tangzf
/// CreateDate: 2019-07-18
/// Descript: insertBDPMappingHosp 通用医院关联表数据写入
/// Input:	TableName : 表名 ARC_ItemCat
/// 		DataReference  : TableName中 需要写入 通用医院关联表 的ROWID
/// 		Hospital : 医院ROWID
/// Output: 
/// Return: rtn>0 添加成功 rtn=BDPMappingHos.RowId ；rtn<0 添加失败 
/// DeBug: w ##class(web.DHCBILLINSUCloudCommon).InsertBDPMappingHosp("DHC_TarPara","2","2")
ClassMethod InsertBDPMappingHosp(TableName, DataReference, Hospital) As %String
{
	set ^CacheTemp("InsertBDPMappingHosp")=$lb(TableName,DataReference,Hospital)
	q:TableName="" "-1^表名不能为空"
	q:DataReference="" "-3^数据RowId不能为空"
	q:Hospital="" "-2^医院指针不能为空" 
	s err=##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP(TableName,DataReference,Hospital)
	i +err<0 d
	.s ^CacheTemp("InsertBDPMappingHosp","ErrData",TableName,DataReference,Hospital)=err
	i +err>0  d
	.s ^CacheTemp("InsertBDPMappingHosp","SuccessData",TableName,DataReference,Hospital)=err
	.s err=0
	q err
}

/// Creator: tangzf
/// CreateDate: 2019-07-18
/// Descript: deleteBDPMappingHosp 通用医院关联表数据删除
/// Input:	TableName : 表名 ARC_ItemCat
/// 		DataReference  : TableName中 需要写入 通用医院关联表 的ROWID
/// 		Hospital : 医院ROWID
/// Output: 
/// Return:  rtn=0 删除成功  ；rtn<0 删除失败 
/// DeBug: w ##class(web.DHCBILLINSUCloudCommon).DeleteBDPMappingHosp(TableName, DataReference, Hospital)
ClassMethod DeleteBDPMappingHosp(TableName, DataReference, Hospital) As %String
{
	q:TableName="" "-1^表名不能为空"
	q:DataReference="" "-3^数据RowId不能为空"
	q:Hospital="" "-2^医院指针不能为空" 
	s err=##class(web.DHCBL.BDP.BDPMappingHOSP).DeleteHospital(TableName,DataReference,Hospital)
	i +err<0 d
	.s ^CacheTemp("DeleteBDPMappingHosp","ErrData",TableName,DataReference,Hospital)=err
	i +err>0  d
	.s ^CacheTemp("DeleteBDPMappingHosp","SuccessData",TableName,DataReference,Hospital)=err
	.s err=0
	q err
}

/// Creator: tangzf
/// CreateDate: 2019-07-18
/// Descript: 根据session来获取此角色的真实医院级别权限。 公有数据调用
/// Input: 要求必须能获取到%session
/// Output: 
/// Return:  err="Y" 有权查看页面 ;能查看指定院区 {limited:1,IDS:[{ID:2},{ID:3}]}注释：其中2,3为所能看到哪些医院数据的医院rowid值)
/// DeBug: w ##class(web.DHCBILLINSUCloudCommon).GetUserAuthorize()
ClassMethod GetUserAuthorize() As %String
{
	s err=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
	s err=$case(err,"1":"Y","off":"Y",:err)
	q err
}

/// Creator: tangzf
/// CreateDate: 2019-07-18
/// Descript: 数据授权
/// Input: HospitalField : 院区在表中的字段名 若为空则通过医院关联表操作
/// Output: 
/// Return:  
/// DeBug: w ##class(web.DHCBILLINSUCloudCommon).Authorize("User.INSUDicData","INDIDHospital","2733","3")
ClassMethod Authorize(ClassName, HospitalField, RowId, Hospital) As %String
{
	set ^CacheTemp("BILLINSUAuthorize",ClassName)=$lb(ClassName, HospitalField, RowId, Hospital)
	
	quit:'##class(websys.Conversions).IsValidClassName(ClassName) "-1^表不存在"
	set obj=$ZOBJCLASSMETHOD(ClassName, "%OpenId", RowId, 0)
	quit:('$IsObject(obj)) "-2^数据不存在"
	
	set Rc=""
	set Id=""
	ts
	set newObj=obj.%ConstructClone()
	
	s HospitalField=$tr(HospitalField," ","")
	
	//数据表中有院区字段
	if (HospitalField="INDIDHospital") d
	.set newObj.INDIDHospital=Hospital
	if (HospitalField="TMHospDr") d
	.set newObj.TMHospDr=Hospital
	// 住院费用核查
	if (HospitalField="MPCHospDr") d
	.set newObj.MPCHospDr=Hospital
	if (HospitalField="CDHospDr") d
	.set newObj.CDMPConfigDR=Hospital
	
	
	set Rc=newObj.%Save()
	b ;qqqq
	If ($$$ISOK(Rc)){
		Set Id=newObj.%Id()
		//通过医院关联表操作
		if HospitalField="" {
			
			set BDPMPHTableName=##class(websys.Conversions).GetSQLTableName(ClassName) 
			set rtn=##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP(BDPMPHTableName,Id,Hospital)
			
			if $p(rtn,"^",1)="-1"{
				tro
				quit rtn
			}else{
				tc	
			}
			
		}else{
			tc //不操作医院管理表 直接提交	
		}	
		Quit Id_"^"_"授权成功"
	}Else{
		tro
		Quit "-3^保存数据失败ERR="_$SYSTEM.OBJ.DisplayError(Rc)
	}
	
	do newObj.%Close()
	do obj.%Close()

	quit Id_"^"
}

/// Creator: tangzf
/// CreateDate: 2019-07-18
/// Descript: 根据安全组取院区
/// Input: 
/// Output: 
/// Return:  
/// DeBug: w ##class(web.DHCBILLINSUCloudCommon).GetHospDrByGroup()
ClassMethod GetHospDrByGroup(groupDr) As %String
{
	quit +$o(^SSU("SSGRP",groupDr,"HOSP",0,"Hosp",""))
}

/// Creator: tangzf
/// CreateDate: 2020-03-18
/// Descript: 更新对象 通过xml/json对象 更新实体类对象
/// Input: PersistentObj : 实体类对象 obj
/// 			InputParam : 入参对象 xml/json 属性是string 即可 ，属性名称必须和实体类名称一致！
/// Output: 
/// Return:  
/// DeBug: w ##class(web.DHCBILLINSUCloudCommon).UpDatePersistentObjByObj()
ClassMethod UpDatePersistentObjByObj(PersistentObj, InputParam, ParamType As %String = "obj") As %String
{
	set ClassName=PersistentObj.%ClassName()
	if (ParamType="String"){
		set ParamObj=##class(%DynamicAbstractObject).%FromJSON(InputParam)
	}else{
		set ParamObj=InputParam	
	}
	set tempObj=##class(%Dictionary.CompiledClass).%OpenId("User."_ClassName)
	b ;qq
	quit:('$IsObject(tempObj)) "-1"
	for i=1:1:tempObj.Properties.Count() {
		set property=tempObj.Properties.GetAt(i)
		set name=property.Name
		continue:(ParamType="String")&&(InputParam'[name)
		continue:($e(name,1)="%") // 过滤 id
		if $e(property.Type,1,5)="User."  d
		.set TmpRowId=$ZOBJPROPERTY(ParamObj,name)
		.set $ZOBJPROPERTY(PersistentObj,name)=$ZOBJCLASSMETHOD(property.Type, "%OpenId", TmpRowId, 0)
		else  d
		.set $ZOBJPROPERTY(PersistentObj,name)=$ZOBJPROPERTY(ParamObj,name)
	}
	b ;UpDatePersistentObjByObj
	s ParamObj="",tempObj=""
	q PersistentObj
}

/// Creator: tangzf
/// CreateDate: 2020-03-18
/// Descript: 查询医院是否开启 基础数据平台的医院级授权 
/// Input: 
/// Output: 
/// Return:  "Y" 开启 "N"未开启
/// DeBug: w ##class(web.DHCBILLINSUCloudCommon).GetHospAuthorize()
ClassMethod GetHospAuthorize() As %String
{
	quit ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut")
}

/// Creator: tangzf
/// CreateDate: 2020-04-14
/// Descript: 未开启 基础数据平台的医院级授权时  获取基础数据访问权限  
/// Input: 
/// Output: 
/// Return:  "Y" 开启 "N"未开启
/// DeBug: w ##class(web.DHCBILLINSUCloudCommon).GetHospShowDataFlag()
ClassMethod GetHospShowDataFlag(tableName As %String, dataid As %String, HospID As %String) As %String
{
	 s flag="Y"
		if tableName="SS_GROUP"
		{
			S SSGRPRowId=dataid
			s AuHospFlag=0 
			s HOSPChildsub=0
			for
			{
				s HOSPChildsub=$o(^SSU("SSGRP",SSGRPRowId,"HOSP",HOSPChildsub)) q:(HOSPChildsub="")||(AuHospFlag=1)
				s CTHospitalDR=$p($g(^SSU("SSGRP",SSGRPRowId,"HOSP",HOSPChildsub)),"^",1)
				if (CTHospitalDR=HospID) s AuHospFlag=1
			}
			if (AuHospFlag=0)
			{
				s flag="N"
			}
			
		}
		elseif tableName="CT_LOC"
		{
			s CTLOCRowID=dataid
			s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22)     //医院
			i (CTLOCHospitalDR'=HospID)
			{
				s flag="N"
			}
		}
		elseif tableName="SS_USER"
		{
			s SSUSRRowId=dataid
			s SSUSRHospitalDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",98) 	//医院
			i (SSUSRHospitalDR'=HospID)
			{
				s flag="N"
			}
		}
		elseif tableName="CT_CAREPROV"
		{
			s CTPCPRowId1=dataid
			s HOSPChildsub=0,AuHospFlag=0
			for
			{
				s HOSPChildsub=$o(^CTPCP(CTPCPRowId1,"HOSP",HOSPChildsub)) q:(HOSPChildsub="")||(AuHospFlag=1)
				s CTHospitalDR=$g(^CTPCP(CTPCPRowId1,"HOSP",HOSPChildsub))
				if (CTHospitalDR=HospID) s AuHospFlag=1
			}
			if (AuHospFlag=0)
			{
				s flag="N"
			}
		}
		elseif tableName="ARC_ITMMAST"
		{
			S ARCIMSubscript=$P(dataid,"||",1)
			S ARCIMVersion=$P(dataid,"||",2)
			; 遍历 医院子表，查询医院dr 进行筛选
			s HospChildsub=0,AuHospFlag=0 
			for
			{
				s HospChildsub=$o(^ARCIM(ARCIMSubscript,ARCIMVersion,"HOSP",HospChildsub)) q:(HospChildsub="")||(AuHospFlag=1)  
				s HOSPHospitalDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"HOSP",HospChildsub)),"^",1)  
				if (HOSPHospitalDR=HospID) s AuHospFlag=1
			}
			if (AuHospFlag=0)
			{
				s flag="N"
			}
			
		}
		elseif tableName="INC_ITM"
		{
			//库存项表DHC_ItmAddHosp
			if $d(^ITMADDHOP(0,"HospInc",HospID,dataid))>0
			{
				s AuHospFlag=1		
			}
			if (AuHospFlag=0)
			{
				s flag="N"
			}
		}
		elseif (tableName="DHCEXABOROUGH")
		{
			s ExabHospitalDr=$LISTGET($g(^User.DHCExaBoroughD(dataid)),13)
			if (ExabHospitalDr=HospID) s AuHospFlag=1
		}
		else
		{
			
			s DataTypeFlag=##class(web.DHCBL.BDP.BDPTableList).GetDataType(tableName)	 //获取数据公有私有类型
			if (DataTypeFlag'="G")
			{
			
				s Hospital= ","_##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospital(tableName,dataid,"ID")_","
				if (Hospital'="")
				{
					s strHospitalRowId = ","_HospID_","
					if Hospital'[strHospitalRowId s flag="N"
				}
				else
				{
					s flag="N"
				}	
			}
		}
	q flag
}

/// Creator: tangzf
/// CreateDate: 2020-05-20
/// Descript: 获取界面 对应的操作表  挂菜单时需要维护  值表达式 (&TableName=INSU_TarContrast)
/// 涉及表： BDP_Menu
/// Input:	ID :      BDP_Menu.RowId
/// Output: 
/// Return: 界面菜单csp 对应的操作表 例如User.INSUTarContrast
/// DeBug: w ##class(web.DHCBILLINSUCloudCommon).GetBDPMenuTable(2421)
ClassMethod GetBDPMenuTable(ID, BDPValType = "TableName") As %String
{
	q:ID="" ""
	set Data=$g(^User.BDPMenuD(ID))
	quit:Data="" ""
	set TabelName=""
	set ParentMenuDr=""
	set ValExpression=$lg(Data,15)
	set Tabel=..GetData(ValExpression,BDPValType)
	q Tabel
}

/// Creator: tangzf
/// CreateDate: 2020-05-20
/// Descript: 获取界面 对应的操作表
/// 涉及表： BDP_Menu
/// Input:	ID :      BDP_Menu.RowId
/// Output: 
/// Return: 界面菜单csp 对应的操作表 例如User.INSUTarContrast
/// DeBug: w ##class(web.DHCBILLINSUCloudCommon).GetData("&a=1&b=2","a")
/// &a=1&b=2
ClassMethod GetData(str, code, split As %String = "&", val As %String = "=") As %String
{
	set strLength=$l(str,split)
	set rtn=""
	for index=1:1:strLength q:rtn'=""  d
	.set tmpStr=$p(str,split,index) // a=1
	.set tmpCode=$p(tmpStr,val,1)
	.set tmpVal=$p(tmpStr,val,2)
	.q:tmpCode'=code
	.s rtn=tmpVal
	q rtn
}

/// Description:获取院区指针
///       Input:
///               ArgVal:参数值 
///              ArgType:参数类型 目前有[AdmDr, BillDr,INVPrtDr,PEPrtDr,JustThread]取值
///               参数类型取值解释
///               AdmDr:Pa_Adm.Rowid   ,  BillDr:DHC_PatientBill.Rowid
///               INVPrtDr:DHC_INVPRT.Rowd  , PEPrtDr:DHC_PE_INVPRT.Rowid
///               INDivDr:INSU_Divide.Rowd  , INAdmDr:INSU_AdmInfo.Rowid
///               JustThread:^DHCTMPACCColPRT("IP",{JustThread}) 进程号(发票集中打印)
///      Return：CTHOSPITAL.Rowid
///      DingSH  20200513
///      Others: 
///      w ##class(web.DHCBILLINSUCloudCommon).GetHOSPID("8","AdmDr")
///      w ##class(web.DHCBILLINSUCloudCommon).GetHOSPID("67","BillDr")
///      w ##class(web.DHCBILLINSUCloudCommon).GetHOSPID("1345","INVPrtDr")
///      w ##class(web.DHCBILLINSUCloudCommon).GetHOSPID("12","PEPrtDr")
///      w ##class(web.DHCBILLINSUCloudCommon).GetHOSPID("69","InAdmDr")
///      w ##class(web.DHCBILLINSUCloudCommon).GetHOSPID("111","InDivDr")
///      w ##class(web.DHCBILLINSUCloudCommon).GetHOSPID("14","JustThread")
ClassMethod GetHOSPID(ArgVal As %String = "", ArgType As %String = "") As %String
{

	
	s HospDr = ""
	
	s ArgType=$ZCVT(ArgType,"U")
	
	//1 进程号(发票集中打印)取院区
	i ArgType="JUSTTHREAD" d
	.s ArgVal=##class(web.DHCINSUBase).GetACCColFirstPRTDr(ArgVal)
	.s ArgType="INVPRTDR"
	
	//2 帐单Dr取院区
	i (ArgType="BILLDR") d
	.s ArgVal =$P(^DHCPB(ArgVal),"^",1)
	.s ArgType="ADMDR"
	
	//3 医保登记表Dr取院区
	i (ArgType="INADMDR") d
	.s ArgVal =$P(^DHCINADM(ArgVal),"^",1)
	.s ArgType="ADMDR"
	
	//4 医保结算表Dr取院区
	i (ArgType="INDIVDR") d
	.s ArgVal =$P(^DHCINDIV(ArgVal),"^",1)
	.s ArgType="ADMDR"
	
	
	//5 就诊Dr取院区
	i (ArgType="ADMDR") d
	.s HospDr = $P(^PAADM(ArgVal,2),"^",85) ;//PAADMHospitalDR
	.i HospDr ="" d
	..s DepCodeDR = ""
	..s DepCodeDR = $P(^PAADM(ArgVal),"^",4)
	..s:DepCodeDR'="" HospDr=$P(^CTLOC(DepCodeDR),"^",22)
	
	//6 门诊发票表Dr取院区
	i (ArgType="INVPRTDR") d
	.s HospDr = $P(^DHCINVPRT(ArgVal),"^",39)
	
	//7 体检发票表Dr取院区
	i (ArgType="PEPRTDR") d
	.s HospDr =$P(^DHCPEINVPRT(ArgVal),"^",26)
	
	

	q HospDr
}

/// 2021-12-03
/// Creator:DingSH
/// Function：获取表是公有G ，私有S，管控C，绝对私有A标识
/// Table：User.BDPTableList
/// Return：公有G ，私有S，管控C，绝对私有A 或 "" 说明未进行表结构登记(基础平台)
/// w ##class(web.DHCBILLINSUCloudCommon).GetDataType("INSUConBDPTableList")
ClassMethod GetDataType(TableName As %String) As %String
{
	n (TableName)
	set BusinessCode=..GetINSUDicCode(TableName)
	quit:$g(BusinessCode)="" ""  //表结构未登记
	set DataType=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDataType(BusinessCode)	 //获取数据公有私有类型 公有数据不带医院表示
	q DataType
}

}
