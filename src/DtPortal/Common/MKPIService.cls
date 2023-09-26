Class DtPortal.Common.MKPIService Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 获取指标数据，根据指标code获取对应的指标数据，如果code为空则取全部的指标数据
/// creted by zhaoli 
/// 入参：code 指标code 模糊匹配
/// d ##class(%ResultSet).RunQuery("DtPortal.Common.MKPIService","QueryKpiData","SK")
Query QueryKpiData(code As %String) As DtPortal.Query(ROWSPEC = "ind,MKPICode,MKPIName,MKPIDesc,MKPIEXCode,MKPIUser,MKPIUpdateDate,MKPIRemark,MKPIDataNod,DimCode,DimDesc,BaseDimCode,BaseDimId,BaseDimName") [ SqlProc ]
{
}

ClassMethod QueryKpiDataExecute(ByRef qHandle As %Binary, code As %String) As %Status
{
	n (qHandle,code)
	  
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	//^DHCWL.MKPI.MKPID(ID)
	set MKPIID=""
	for {
		set MKPIID=$o(^DHCWL.MKPI.MKPID(MKPIID))
		quit:MKPIID=""
		
		//获取指标信息DHCWL_MKPI.DHCWLMKPI
		set MKPICode=$lg(^DHCWL.MKPI.MKPID(MKPIID),2)			//指标code
		set MKPIName=$lg(^DHCWL.MKPI.MKPID(MKPIID),3)			//指标名称
		set MKPIEXCode=$lg(^DHCWL.MKPI.MKPID(MKPIID),4)		//指标执行代码
		set MKPIDesc=$lg(^DHCWL.MKPI.MKPID(MKPIID),5)			//指标描述
		
		set MKPIUser=$lg(^DHCWL.MKPI.MKPID(MKPIID),8)			//指标创建者
		set MKPIUpdateDate=$lg(^DHCWL.MKPI.MKPID(MKPIID),7) 	//指标更新时间
		
		set MKPIRemark=$lg($G(^DHCWL.MKPI.MKPID(MKPIID)),6) 		//指标备注
		set MKPIDataNod=$lg(^DHCWL.MKPI.MKPID(MKPIID),12) 	//数据节点 
		
		//判断是否根据code来过滤
		;continue:(code'="")&&(("^"_MKPICode_"^")'[(code)&&MKPIName'[(code))
		;continue:(code'="")&&(("^"_MKPICode_"^")'[(code)&&MKPIName'[(code))
		set pdMKPICode=$$ALPHAUP^SSUTIL4(MKPICode) ///统一转大写做判断
		set pdcode=$$ALPHAUP^SSUTIL4(code) ///统一转大写做判断
		set pdMKPIName=$$ALPHAUP^SSUTIL4(MKPIName) ///统一转大写做判断
		continue:(pdMKPICode'[pdcode)&&(pdMKPIName'[pdcode) ///统一转大写做判断
		
		set MKPITypeDr=$lg(^DHCWL.MKPI.MKPID(MKPIID),10)		//维度信息代码,关联DHCWL.MKPI.MKPIDimType
		//获取指标维度信息DHCWL_MKPI.DHCWLMKPIDim
		//^DHCWL.MKPI.MKPIDimensionsI("KPIOrderI",MKPIDr,MKPIDimOrder,ID)
		set MKPIDimOrder="",DimCode="",DimDesc=""
		 s BaseDimCode=""
	    s BaseDimId=""
	    s BaseDimName=""
		for{
			set MKPIDimOrder=$o(^DHCWL.MKPI.MKPIDimensionsI("KPIOrderI",MKPIID,MKPIDimOrder))	//维度orderID
			quit:MKPIDimOrder=""
			
			set MKPIDimID=""		//维度ID
			for {
				set MKPIDimID=$o(^DHCWL.MKPI.MKPIDimensionsI("KPIOrderI",MKPIID,MKPIDimOrder,MKPIDimID))
				quit:MKPIDimID=""
				
				set MKPIDimCode=$lg(^DHCWL.MKPI.MKPIDimensionsD(MKPIDimID),2)			//维度code
				set MKPIDimDesc=$lg(^DHCWL.MKPI.MKPIDimensionsD(MKPIDimID),4)			//维度描述
				set MKPIDimDeli=$lg(^DHCWL.MKPI.MKPIDimensionsD(MKPIDimID),7)			//维度分割符
				set KDTId=$lg(^DHCWL.MKPI.MKPIDimensionsD(MKPIDimID),5)	 ///基础维度的id
				set KDTCode=$lg(^DHCWL.MKPI.MKPIDimTypeD(KDTId),2)	//基础维度Code
				set KDTDesc=$lg(^DHCWL.MKPI.MKPIDimTypeD(KDTId),3)	//基础维度描述
				set KDTName=$lg(^DHCWL.MKPI.MKPIDimTypeD(KDTId),5)	//基础维度名称
				
				if DimCode="" set DimCode=MKPIDimCode 
				else  set DimCode=DimCode_","_MKPIDimCode
				
				if DimDesc="" set DimDesc=MKPIDimDesc 
				else  set DimDesc=DimDesc_","_MKPIDimDesc
				
				if BaseDimCode="" set BaseDimCode=KDTCode 
				else  set BaseDimCode=BaseDimCode_","_KDTCode
				
				if BaseDimName="" set BaseDimName=KDTName 
				else  set BaseDimName=BaseDimName_","_KDTName
				
				if BaseDimId="" set BaseDimId=KDTId 
				else  set BaseDimId=BaseDimId_","_KDTId
				
			}	
		}
		do OutputRow1	
	}
	Quit $$$OK
OutputRow1
    s Data=$lb(ind,MKPICode,MKPIName,MKPIDesc,MKPIEXCode,MKPIUser,MKPIUpdateDate,MKPIRemark,MKPIDataNod,DimCode,DimDesc,BaseDimCode,BaseDimId,BaseDimName)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

/// 获取具备指定指标维度的指标数据
/// creted by zhaoli 
/// 入参：filterDimId 过滤维度，多个时用^分割  kpiDimId 取数维度（不能为空） 基础指标维度code集合，多个按照^分割
/// 出参：MKPICode 指标code，MKPIName指标名称，DimCode指标维度数据14#Doc^PatDoc*19#loc^Dept
/// d ##class(%ResultSet).RunQuery("DtPortal.Common.MKPIServiceTest","QueryKpiDataByDimId","21","19","")
Query QueryKpiDataByDimId(filterDimId As %String, kpiDimId As %String, kpiList As %String) As DtPortal.Query(ROWSPEC = "ind,MKPIID,MKPICode,MKPIName,DimCode") [ SqlProc ]
{
}

ClassMethod QueryKpiDataByDimIdExecute(ByRef qHandle As %Binary, filterDimId As %String, kpiDimId As %String, kpiList As %String) As %Status
{
	n (qHandle,filterDimId,kpiDimId,kpiList)
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	if (kpiDimId="") Quit $$$OK 
	kill ^TempDHCDPQueryKpiDataByDimId("MKPICode",$j)
	set KDTIDList=""			//基础维度IDlist
	if ((filterDimId="")||(filterDimId=kpiDimId)){
		set KDTIDList=$listfromstring(kpiDimId,"^")
	}else{
		set KDTIDList=$listfromstring(filterDimId_"^"_kpiDimId,"^")	
	}
	set KDTIDLength=$listlength(KDTIDList)
	set finalLength=0
	for i=1:1:KDTIDLength {
		set value= $ListGet(KDTIDList,i) 
		
		 if ($ListFind(KDTIDList,value)=i )	{
			set finalLength=finalLength+1 
		 }
			
	}
	set:kpiList'="" MKPICodeList=$listfromstring(kpiList,"^")
	
	//指标维度表 DHCWL_MKPI.DHCWLMKPIDim
	//^DHCWL.MKPI.MKPIDimensionsD(ID)=$LB(%%CLASSNAME,MKPIDimCode,MKPIDr,MKPIDimDes,MKPIDimDimDr,MKPIDimOrder,MKPIDimDeli)
	//^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",MKPIDr,MKPIDimDimDr,ID)
	set MKPIDr=""
	for{
		set MKPIDr=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",MKPIDr))
		quit:MKPIDr=""
		
		//指标主表  DHCWL_MKPI.DHCWLMKPI 
		//^DHCWL.MKPI.MKPID(ID)=$LB(%%CLASSNAME,MKPICode,MKPIDesc,MKPIEXCode,MKPIName,MKPIRemark,MKPIUpdateDate,MKPIUser,MKPICate,MKPITypeDr,MKPISectionFlag,MKPIDataNod,MKPIGlobalFlag,MKPIGetValueType)
		set MKPICode=$lg(^DHCWL.MKPI.MKPID(MKPIDr),2)						//指标code
		continue:(kpiList'="")&&('$listfind(MKPICodeList,MKPICode))			//如果传入code,就只获取该code的指标信息
		
		set MKPIDimDimDr=""
		for{
			set MKPIDimDimDr=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",MKPIDr,MKPIDimDimDr))
			quit:MKPIDimDimDr=""
			
			//DHCWL_MKPI.DHCWLMKPIDimType基础维度表
			//^DHCWL.MKPI.MKPIDimTypeD(ID)=$LB(%%CLASSNAME,KDTCode,KDTDesc,KDTEXCode,KDTName,KDTRemark,KDTUpdateDate,KDTUser,KDTExeCode)	
			continue:('$listfind(KDTIDList,MKPIDimDimDr))
			
			set MKPIDimCodeStr=""	//指标维度code串
			set MKPIDimID=""		//指标维度表ID
			for{
				set MKPIDimID=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",MKPIDr,MKPIDimDimDr,MKPIDimID))
				quit:MKPIDimID=""
				
				set MKPIDimCode=$lg(^DHCWL.MKPI.MKPIDimensionsD(MKPIDimID),2)			//指标维度表DHCWL_MKPI.DHCWLMKPIDim中的code
				continue:MKPIDimCode=""
				
				if (MKPIDimCodeStr=""){
					set MKPIDimCodeStr=MKPIDimCode_"_"_$lg(^DHCWL.MKPI.MKPIDimensionsD(MKPIDimID),4)		
				}else{
					set MKPIDimCodeStr=MKPIDimCodeStr_"^"_MKPIDimCode_"_"_$lg(^DHCWL.MKPI.MKPIDimensionsD(MKPIDimID),4)		
				}
			}
			set ^TempDHCDPQueryKpiDataByDimId("MKPICode",$j,MKPIDr,MKPIDimDimDr)=MKPIDimCodeStr
		}
	}
	
	//获取数据
	set MKPIID=""
	for{
		set MKPIID=$o(^TempDHCDPQueryKpiDataByDimId("MKPICode",$j,MKPIID))
		quit:MKPIID=""					//指标DHCWL_MKPI.DHCWLMKPI ID
		
		set MKPICode=$lg(^DHCWL.MKPI.MKPID(MKPIID),2)				//指标Code		
		set MKPIName=$lg(^DHCWL.MKPI.MKPID(MKPIID),5)				//指标name
		
		set length=0					//基础维度个数
		set MKPIDimStr=""				//指标维度
		set KDTID=""					//基础维度DHCWL_MKPI.DHCWLMKPIDimType ID
		for{
			set KDTID=$o(^TempDHCDPQueryKpiDataByDimId("MKPICode",$j,MKPIID,KDTID))	
			quit:KDTID=""
			set length=length+1
			set MKPIDimCodes=$g(^TempDHCDPQueryKpiDataByDimId("MKPICode",$j,MKPIID,KDTID))
			
			if (MKPIDimStr=""){
				set MKPIDimStr=KDTID_"#"_MKPIDimCodes	
			}else{
				set MKPIDimStr=MKPIDimStr_"*"_KDTID_"#"_MKPIDimCodes		
			}
		}
		continue:finalLength'=length
		d OutputRowDimInfo	
	}
	Quit $$$OK
OutputRowDimInfo
    s Data=$lb(ind,MKPIID,MKPICode,MKPIName,MKPIDimStr)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

/// 获取所有的基础维度以及对应的指标维度的属性
/// 基础维度表 DHCWL_MKPI.DHCWLMKPIDimType
/// creted by zhaoli 
/// 入参：
/// d ##class(%ResultSet).RunQuery("DtPortal.Common.MKPIService","QueryBaseDimProData")
Query QueryBaseDimProData() As DtPortal.Query(ROWSPEC = "ind,MKPIDimCode,MKPIDimDes,MKPIDimId") [ SqlProc ]
{
}

ClassMethod QueryBaseDimProDataExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	//^DHCWL.MKPI.MKPIDimTypeD(ID)=$LB(%%CLASSNAME,KDTCode,KDTDesc,KDTEXCode,KDTName,KDTRemark,KDTUpdateDate,KDTUser,KDTExeCode)
	set KDTID=""
	for{
		set KDTID=$o(^DHCWL.MKPI.MKPIDimTypeD(KDTID))			//基础维度表ID
		quit:KDTID=""
		
		set KDTCode=$lg(^DHCWL.MKPI.MKPIDimTypeD(KDTID),2)	//基础维度Code
		set KDTDesc=$lg(^DHCWL.MKPI.MKPIDimTypeD(KDTID),3)	//基础维度描述
		set KDTName=$lg(^DHCWL.MKPI.MKPIDimTypeD(KDTID),5)	//基础维度名称
		d OutputRowBaseDimPro
	}
	Quit $$$OK
OutputRowBaseDimPro
    s Data=$lb(ind,KDTCode,KDTName,KDTID)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

/// 根据维度id获取对应维度的维度属性列表
/// created by zhaoli
/// 入参： 基础维度id
/// d ##class(%ResultSet).RunQuery("DtPortal.Common.MKPIService","QueryDimProDataById","19")
Query QueryDimProDataById(id As %String) As DtPortal.Query(ROWSPEC = "DimProCode,DimProName,DimProDefaultFlag") [ SqlProc ]
{
}

ClassMethod QueryDimProDataByIdExecute(ByRef qHandle As %Binary, id As %String) As %Status
{
	n (qHandle,id)
	  
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	IF id="" 	Quit $$$OK
	k ^tempWdbyzl($j)
	set ^tempWdbyzl($j)=""
	//DHCWL_MKPI.DHCWLDimProperty 维度属性表
	//^DHCWL.MKPI.DimPropertyI("DimCodeI",DimDr,Code:AlphaUp,ID)
	//^DHCWL.MKPI.DimPropertyD(ID)=$LB(%%CLASSNAME,DimDr,Code,Name,Desc,ExcuteCode,DefaultFlag,ValueDeli)
	set code=""
	for{
		set code=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",id,$$ALPHAUP^SSUTIL4(code)))
		quit:code=""
		set DimproID=""
		for{
			set DimproID=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",id,$$ALPHAUP^SSUTIL4(code),DimproID))
			quit:DimproID=""
			set ^tempWdbyzl($j,DimproID)=""
			;set DimProCode=$lg(^DHCWL.MKPI.DimPropertyD(DimproID),3) 			//维度属性code
			;set DimProName=$lg(^DHCWL.MKPI.DimPropertyD(DimproID),4) 			//维度属性名称
			;set DimProDefaultFlag=$lg(^DHCWL.MKPI.DimPropertyD(DimproID),7) 	//是否默认属性
			;d OutputProByIdRow	
		}
	}
	set DimproID=""
	for{
			set DimproID=$o(^tempWdbyzl($j,DimproID))
			quit:DimproID=""
			
			set DimProCode=$lg(^DHCWL.MKPI.DimPropertyD(DimproID),3) 			//维度属性code
			set DimProName=$lg(^DHCWL.MKPI.DimPropertyD(DimproID),4) 			//维度属性名称
			set DimProDefaultFlag=$lg(^DHCWL.MKPI.DimPropertyD(DimproID),7) 	//是否默认属性
			d OutputProByIdRow	
	}
	Quit $$$OK
OutputProByIdRow
    s Data=$lb(DimProCode,DimProName,DimProDefaultFlag)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

/// 根据选择的指标 获取所有的相同的基础维度列表
/// creted by zhaoli 
/// 入参：
/// d ##class(%ResultSet).RunQuery("DtPortal.Common.MKPIServiceCeshi","QueryCommonDimData","SK0136")
Query QueryCommonDimData(codes As %String) As DtPortal.Query(ROWSPEC = "MKPIDimCode,MKPIDimDes,MKPIDimId") [ SqlProc ]
{
}

ClassMethod QueryCommonDimDataExecute(ByRef qHandle As %Binary, codes As %String) As %Status
{
	n (qHandle,codes)
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	kill ^TempDimData($j,"MKPIDim")
	set ^TempDimData($j,"MKPIDim")=""
	if (codes="") Quit $$$OK 
	set MKPICodeListOrigin=$listfromstring(codes,"^")
	set CodeLengthOrigin=$ListLength(MKPICodeListOrigin)
	set handleStr=""
	for j=1:1:CodeLengthOrigin{
		set item=$p(codes,"^",j)
		if ($listfind(MKPICodeListOrigin,item) = j){
			if (j=1){
					set handleStr=handleStr_item
			}else{
				
			  set handleStr=handleStr_"^"_item
			}
		
		}
		
	}
	set MKPICodeList=$listfromstring(handleStr,"^")
	set CodeLength=$ListLength(MKPICodeList)
	set isHave="true"
	
	set MKPIDr=""
	for{
		set MKPIDr=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",MKPIDr))
		quit:MKPIDr=""
		
		//指标主表  DHCWL_MKPI.DHCWLMKPI 
		//^DHCWL.MKPI.MKPID(ID)=$LB(%%CLASSNAME,MKPICode,MKPIDesc,MKPIEXCode,MKPIName,MKPIRemark,MKPIUpdateDate,MKPIUser,MKPICate,MKPITypeDr,MKPISectionFlag,MKPIDataNod,MKPIGlobalFlag,MKPIGetValueType)
		set MKPICode=$lg(^DHCWL.MKPI.MKPID(MKPIDr),2)						//指标code
		continue:('$listfind(MKPICodeList,MKPICode))			//如果传入code,就只获取该code的指标信息
		
		set MKPIDimDimDr=""
		set flage=0
		if ($O(^TempDimData($j,"MKPIDim",""))=""){
			set flage=1
			
		} 
		set isHaveIn="false"
		for{
			set MKPIDimDimDr=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",MKPIDr,MKPIDimDimDr))
			
			quit:MKPIDimDimDr=""
			///代表第一个指标，将这个指标的关联基础维度全部保存下来
			if (flage=1){
				set isHaveIn="true"
				set ^TempDimData($j,"MKPIDim",MKPIDimDimDr)=MKPIDimDimDr
			}else{
				
				///如果存在，则将值叠加
				if ($g(^TempDimData($j,"MKPIDim",MKPIDimDimDr))'=""){
					
					set isHaveIn="true"
					set ^TempDimData($j,"MKPIDim",MKPIDimDimDr)=$g(^TempDimData($j,"MKPIDim",MKPIDimDimDr))_"^"_MKPIDimDimDr
				
				}
				
			}
         }
        
         if (isHaveIn="false"){
	         set isHave="false"
	     }
        quit:isHaveIn="false"
	}
	
	if isHave="false" Quit $$$OK
	
    ///遍历保存的维度数据
	set MKPIDimDimDr=""
	for{
		set MKPIDimDimDr=$o(^TempDimData($j,"MKPIDim",MKPIDimDimDr))	
		quit:MKPIDimDimDr=""
		set value=$g(^TempDimData($j,"MKPIDim",MKPIDimDimDr))
		set length=$l(value,"^")
		if (length=CodeLength){
			s DimCode=$lg(^DHCWL.MKPI.MKPIDimTypeD(MKPIDimDimDr),2) //维度code
			s DimName=$lg(^DHCWL.MKPI.MKPIDimTypeD(MKPIDimDimDr),5) //维度名称
		    set ID=MKPIDimDimDr
			d OutputRowBaseDimData
		}
		
	}
	Quit $$$OK
OutputRowBaseDimData
    s Data=$lb(DimCode,DimName,ID)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

/// //// 根据指标过滤和取数规则以及查询类型，输出最终的数据
/// /created by zhaoli  期初、期末、累计、平均
/// 入参===startDate:开始日期,endDate:结束日期,dateType:查询类型,kpiRule:过滤规则,filterRule:取数规则 ,mode 模式（实时或者历史） type 处理方式 期初、期末，
/// contractTye 数据类型，空代表获取的取本期的值，PP代表上期的，SL代表同期的值
/// /groupType 统计方式，all代表统计成一条数据，date按照日期统计，dim按照维度id统计，detail 不统计
/// /w ##class(DtPortal.Common.MKPIService).GetKPIData("2018-03-01","2018-03-31","byMonth","KPPD030101A:PatDoc.DocName^PatDoc.DocCode^PatDoc.DocPrv^PatDoc.Doc^PatDoc.DocLoc,KPPD030101B:PatDoc.DocName^PatDoc.DocCode^PatDoc.DocPrv^PatDoc.Doc^PatDoc.DocLoc,KPPD030101C:PatDoc.DocName^PatDoc.DocCode^PatDoc.DocPrv^PatDoc.Doc^PatDoc.DocLoc,KPPD040101G:PatDoc.DocName^PatDoc.DocCode^PatDoc.DocPrv^PatDoc.Doc^PatDoc.DocLoc,KPPD040101B:PatDoc.DocName^PatDoc.DocCode^PatDoc.DocPrv^PatDoc.Doc^PatDoc.DocLoc","KPPD030101A,KPPD030101B,KPPD030101C,KPPD040101G,KPPD040101B","H")
/// //w ##class(DtPortal.Common.MKPIService).GetKPIData("2019-01-01","2019-01-09","byMonth","SK0137:PatLoc.LocDesc,SK0138:PatLoc.LocDesc,SK0139:PatLoc.LocDesc","SK0137,SK0138,SK0139","H")
/// //w ##class(DtPortal.Common.MKPIService).GetKPIData("2018-04-01","2018-04-30","byMonth","KLQ0008:ward.WardName","KLQ0008","KLQ0008:ward.WardName","KLQ0008","","all","H")
ClassMethod GetKPIData(startDate, endDate, dateType, kpiRule, filterRule, kpiRuleSpe, filterRuleSpe, contractTye, groupType, mode = "H") As DtPortal.OutPut
{
	n (startDate,endDate,dateType,kpiRule,filterRule,mode, kpiRuleSpe,filterRuleSpe,groupType,contractTye)
	set mode="H"
	#Dim retFinal As DtPortal.OutPut
	Set retFinal = ##class(DtPortal.OutPut).%New()
	///清除临时global的数据
	k ^TempkpiValueCurrent($j) ///本期数据的保存
	k ^TempkpiValuePro($j) ///维度属性的值
	k ^TempkpiValueProDesc($j) ///维度属性的值
	k ^TempkpiValuePP($j)   ////上期数据的保存
	k ^TempkpiValueSL($j)    ///同期数据的保存
	k ^TempDate($j)
	set ^TempkpiValueCurrent($j)=""
	set ^TempkpiValuePP($j)=""
	set ^TempkpiValueSL($j)=""
	set ^TempkpiValuePro($j)=""
	set ^TempkpiValueProDesc($j)=""
	set ^TempDate($j)=""
	
	
	k ^TempkpiValueFinal($j) ///最终的数据处理
	k ^TempkpiValuePPFinal($j) ///最终的数据处理
	k ^TempkpiValueSLFinal($j) ///最终的数据处理
	set ^TempkpiValueFinal($j)=""
	set ^TempkpiValuePPFinal($j)=""
	set ^TempkpiValueSLFinal($j)=""
	
	IF (startDate="")||(endDate="")||(kpiRule="")||(filterRule="") {
		
		Set retFinal.status = 1
	    Set retFinal.errMSG = ""
		Set retFinal.data = "[]"
		q retFinal 
	}
	////计算开始日期和结束日期的间隔年、间隔月、间隔的天数
	set numStart=$zdh(startDate,3)
	set numEnd=$zdh(endDate,3)
	///年份差
	set yearLength=0  
	//月份差
	set monthLength=0
	///天数
	set dayLength=numEnd-numStart+1
	//季度的差值
	set quaLength=numEnd-numStart+1
	set yearStart=$p(startDate,"-",1)
	set yearEnd=$p(endDate,"-",1)
	set monthStart=$p(startDate,"-",2)
	set monthEnd=$p(endDate,"-",2)
	
	///开始日期所在的季度
	set ys1=monthStart#3
	set currentQ1=1
	if (ys1=0){
		set currentQ1=monthStart\3
	}else{
		set currentQ1=(monthStart\3)+1
	}
	//结束日期所在的季度
	set ys2=monthEnd#3
	set currentQ2=1
	if (ys2=0){
		set currentQ2=monthEnd\3
	}else{
		set currentQ2=(monthEnd\3)+1
	}
	set quaLength=(yearEnd-yearStart)*4+(currentQ2-currentQ1)+1
	set commonLength=0
		
	
	set monthLength=(yearEnd-yearStart)*12+(monthEnd-monthStart)+1
	set yearLength=yearEnd-yearStart+1
	set tempcontractTye=contractTye
	if (groupType="date")&&(contractTye["PP"){
	  if (contractTye["SL"){
		  set tempcontractTye="SL"
	  }ELSE{
		  set tempcontractTye=""
		  
	 	}
	}
	
	w dayLength_"-"_monthLength_"-"_yearLength_"-"_quaLength,!
	
	
	w $j,!
	///用于处理期初和期末值 统计方式不是按照日期时，生成的实际的开始日期和结束日期
	set startDateInfact=$p(startDate,"-",1)_"年"_$p(startDate,"-",2)_"月"_$p(startDate,"-",3)_"日"
	set endDateInfact=$p(endDate,"-",1)_"年"_$p(endDate,"-",2)_"月"_$p(endDate,"-",3)_"日"

	
	////根据开始日期和结束日期以及日期查询方式，生成日期段
	if (dateType="byDay"){
		set commonLength=dayLength
		set num1=$zdh(startDate,3)
		set num2=$zdh(endDate,3)
		if (num2>=+$h){
			set endDateInfact=$zd(+$h-1,3)
		}
		for i=num1:1:num2{
			set date=$zd(i,3)
			s dateStr=$p(date,"-",1)_"年"_$p(date,"-",2)_"月"_$p(date,"-",3)_"日"
			set ^TempkpiValueCurrent($j,dateStr)=0
			///设置一个默认的维度    
			set ^TempkpiValueCurrent($j,dateStr,-1)=0
			
			
		}
	}
	if (dateType="byMonth"){
		set commonLength=monthLength
		set qujianDate=startDate
		for i=1:1:monthLength{
			
			set tempMonth=$p(qujianDate,"-",2)
			if (i>1){
				if (tempMonth="12"){
					set qujianDate=($p(qujianDate,"-",1)+1)_"-01"
				}else{
					set nowM=tempMonth+1
					if (nowM<10) set nowM="0"_nowM
					set qujianDate=$p(qujianDate,"-",1)_"-"_nowM
				}
			}
            
			s dateStr=$p(qujianDate,"-",1)_"年"_$p(qujianDate,"-",2)_"月"
			set ^TempkpiValueCurrent($j,dateStr)=0
			set ^TempkpiValueCurrent($j,dateStr,-1)=0
			w dateStr,!
			if (i=monthLength){
				set endDateInfact=dateStr
			}
			if (i=1){
				set startDateInfact=dateStr
			}
			
		}
		w startDateInfact,endDateInfact,!
	}
	
	if (dateType="byYear"){
        set commonLength=yearLength
		set num1=$P(startDate,"-",1)
		set num2=$P(endDate,"-",1)
		for i=num1:1:num2{
			set date=i
			s dateStr=i_"年"
			set ^TempkpiValueCurrent($j,dateStr)=0
			set ^TempkpiValueCurrent($j,dateStr,-1)=0
			if (i=num2){
				set endDateInfact=dateStr
			}
			if (i=num1){
				set startDateInfact=dateStr
			}
		}
	}
	if (dateType="byQua"){
		set commonLength=quaLength
		set qujianDate=yearStart_"-"_currentQ1
		for i=1:1:quaLength{
			
			set tempQ=$p(qujianDate,"-",2)
			if (i>1){
				if (tempQ="4"){
					set qujianDate=($p(qujianDate,"-",1)+1)_"-1"
				}else{
					set qujianDate=$p(qujianDate,"-",1)_"-"_(tempQ+1)
				}
			}

			s dateStr=$p(qujianDate,"-",1)_"年"_$p(qujianDate,"-",2)_"季度"
			set ^TempkpiValueCurrent($j,dateStr)=0
			set ^TempkpiValueCurrent($j,dateStr,-1)=0
			if (i=quaLength){
				set endDateInfact=dateStr
			}
			if (i=1){
				set startDateInfact=dateStr
			}
			
		}
		
	}
	
	
	set kpiNum=$l(kpiRule,",")
	set kpiNumSpe=$l(kpiRuleSpe,",")
	
		set proStr=$p($p(kpiRule,",",1),":",2)
	
	set proArray=""
	set proNum=$l(proStr,"^")
	for j=1:1:proNum{
		set item=$p(proStr,"^",j)
		if j=1{
			set proArray=$p(item,".",2)
		}else{
			set proArray=proArray_"^"_$p(item,".",2)
		}
		
	}
	set currDate=$zd(+$h,3)
	set currMonth=$p(currDate,"-",1)_"年"_$p(currDate,"-",2)_"月"
	set currYear=$p(currDate,"-",1) ///当前年
	set currMonthStand=$p(currDate,"-",1)_"-"_$p(currDate,"-",2)_"" ///当前月
	set ^TempDate($j)=""
	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDate,endDate,dateType,kpiRule,filterRule,mode,tempcontractTye)
	set isHaveData=0

	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
			
		set isHaveData=1
		s month=rs.Data("month") //日期列
		s month=$tr(month,"同期","")
		s month=$tr(month,"上期","")
		s monthStr=rs.Data("month") //日期中文
         ///判断区间类型，根据特殊指标以及查询的方式，查询各个区间的期初和期末的数据
        set contractTyeCurrent=rs.Data("contractTye")
        //同期数据，生成同期的时间段
       
		///维度的id
		set dimId=rs.Data("dimIdCol1")
		if dimId="" set dimId="Null"
		
		
		
		///给临时globle赋值，将指标的值保存到临时global中
	    set ret=..setValue(rs, kpiNum, contractTyeCurrent, month, dimId, kpiRule,"")
		
			
		set ^TempkpiValuePro($j,dimId)=""
		for j=1:1:proNum{
			set proCode=$p(proArray,"^",j)
			set dimDesc=rs.Data("dimDesCol"_j)
			if dimDesc="" set dimDesc="Null"
			set ^TempkpiValuePro($j,dimId,proCode)=dimDesc
		}
		//如果是按照天查询，则不用再去单独查询区间的数据
		if (dateType="byDay")&&(kpiRuleSpe'="")&&(filterRuleSpe'="") {
			set ret=..setValue(rs, kpiNum, contractTyeCurrent, month, dimId, kpiRule,"start")
			set ret=..setValue(rs, kpiNum, contractTyeCurrent, month, dimId, kpiRule,"end")
			
		}
		///同一个日期段，不再重复查询 期初和期末值 针对 按月、按季度、按年   
		////对于上期值只针对不根据日期统计数据的情况，需要重新计算期初和期末值,否则后边去单独处理
	    if (kpiRuleSpe'="")&&(filterRuleSpe'="")&&('$g(^TempDate($j,monthStr)))&&(dateType'="byDay"){
		    set ^TempDate($j,monthStr)=monthStr
		        
			//区间内的开始日期和结束日期
		    set intervalStartDate=+$h
		   	set intervalendDate=+$h
		   	set qujianDate=""
		   	
			///按照年查询，则根据当前年生成开始日期和结束日期
			if (dateType="byYear") {
					s qujianDate=$tr(month,"年","")
					if (contractTyeCurrent="SL"){
						SET qujianDate=qujianDate-1 
					}
					///上期值，上期值取的是向前推的时间段的日期
					if (contractTyeCurrent="PP"){
						SET qujianDate=qujianDate-yearLength 
					}
					set intervalStartDate=qujianDate_"-01"_"-01"
					set intervalendDate=qujianDate_"-12"_"-31"
					set sDateNum=$zdh(intervalStartDate,3)
					set endNum=$zdh(intervalendDate,3) ///获取结束日期的数字值	
					if (endNum>=+$h){
						set intervalendDate=$zd(+$h-1,3) //获取当前日期前一天的数据
						set endNum=$zdh(intervalendDate,3)
					}
					if (sDateNum>endNum){
						set intervalendDate=intervalStartDate ///如果是当前年，将结束日期定为当前日期
					}
			    
			}
			if (dateType="byMonth") {
				
					s qujianDate=$tr(month,"年","-")
						
					s qujianDate=$tr(qujianDate,"月","")
					///上期值
					if (contractTyeCurrent="PP"){
						///获取当前月
						for ppm=1:1:monthLength{
							set tempMonth=$p(qujianDate,"-",2)
							if (tempMonth="01"){
							set qujianDate=($p(qujianDate,"-",1)-1)_"-12"
							}else{
								set nowM=tempMonth-1
								if (nowM<10) set nowM="0"_nowM
								set qujianDate=$p(qujianDate,"-",1)_"-"_nowM
							}
							
						}
						
						
					}elseif (contractTyeCurrent="SL"){
						SET year=$p(qujianDate,"-",1)-1
						SET qujianDate=year_"-"_$p(qujianDate,"-",2)
					}else{
						
						
					}
					set intervalStartDate=qujianDate_"-01"
					///获取当前月的最后一天
					set intervalendDate=##Class(DtPortal.Common.PublicService).getLastDayOfMonth(qujianDate,1)
				
					set endNum=$zdh(intervalendDate,3) ///获取结束日期的数字值
					set sDateNum=$zdh(intervalStartDate,3)
					if (endNum>=+$h){
						set intervalendDate=$zd(+$h-1,3) //获取当前日期前一天的数据
						set endNum=$zdh(intervalendDate,3)
					}
								
					if (sDateNum>endNum){
						set intervalendDate=intervalStartDate ///如果是当前年，将结束日期定为当前日期
					}
				 
			}
			if (dateType="byQua") {
					s qujianDate=$tr(month,"年","Q")
					s qujianDate=$tr(qujianDate,"季度","")
					///获取当前的季度值
					set year=$p(qujianDate,"Q",1) //所在年
					set num=$p(qujianDate,"Q",2)  ///所在季度
					if (contractTyeCurrent="PP"){
						//第一季度
						//if (num="1"){
						//	set num=4
						//	set year=year-1
						//}else{
						//	set num=num-1
						//}
						for ppm=1:1:quaLength{
							set tempQ=$p(qujianDate,"Q",2)
							if (tempQ="1"){
							set qujianDate=($p(qujianDate,"Q",1)-1)_"Q4"
							}else{
								set qujianDate=$p(qujianDate,"Q",1)_"Q"_(tempQ-1)
							}
							
						}
						
						set year=$p(qujianDate,"Q",1) //所在年
						set num=$p(qujianDate,"Q",2)  ///所在季度
					}elseif (contractTyeCurrent="SL"){
						set year=year-1
						
					}
					//取季度的第一天
					set intervalStartDate=$CASE(num,1:year_"-01-01",2:year_"-04-01",3:year_"-07-01",4:year_"-10-01")
					///取季度的最后一天
					set intervalendDate=$CASE(num,1:year_"-03-31",2:year_"-06-30",3:year_"-09-30",4:year_"-12-31")
					set endNum=$zdh(intervalendDate,3) ///获取结束日期的数字值
					set sDateNum=$zdh(intervalStartDate,3)
					if (endNum>=+$h){
						set intervalendDate=$zd(+$h-1,3) //获取当前日期前一天的数据
						set endNum=$zdh(intervalendDate,3)
					}
								
					if (sDateNum>endNum){
						set intervalendDate=intervalStartDate ///如果是当前年，将结束日期定为当前日期
					}
					 
					
			}
			////不是按照天查询的
			if (dateType'="byDay")&&(kpiRuleSpe'="")&&(filterRuleSpe'=""){
				
				///获取期初值
				s rsStart=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",intervalStartDate,intervalStartDate,"byDay",kpiRuleSpe,filterRuleSpe,"S",contractTye)
				///设置期初值
				While rsStart.Next(.sc) {
					If $$$ISERR(sc) Quit
					;set contractTyeCurrent=rsStart.Data("contractTye")
					//维度的id
					set dimId=rsStart.Data("dimIdCol1") 
					
					set ret=..setValue(rsStart, kpiNumSpe, contractTyeCurrent, month, dimId, kpiRuleSpe,"start")
					
			
				} 
			   
				///获取期末的值
				s rsEnd=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",intervalendDate,intervalendDate,"byDay",kpiRuleSpe,filterRuleSpe,"S",contractTye)
					
					///设置期末值
				While rsEnd.Next(.sc) {
					If $$$ISERR(sc) Quit
					;set contractTyeCurrent=rsEnd.Data("contractTye")
					///判断区间类型，根据特殊指标以及查询的方式，查询各个区间的期初和期末的数据
					; set ret=..setValue(rs, kpiNum, contractTyeCurrent, month, dimId, kpiRule,"end")        
					///维度的id
					set dimId=rsEnd.Data("dimIdCol1")
					
					set ret=..setValue(rsEnd, kpiNumSpe, contractTyeCurrent, month, dimId, kpiRuleSpe,"end")	
							
				}
				
				
		    }

		}
		
	}
	
	//判断当前日期的1号是否在查询的时间段内
	s ifTimeHaveCurrMonth="false"
	;if (dateType="byMonth"){
		s currDate01=$p(currDate,"-",1)_"-"_$p(currDate,"-",2)_"-01"
		s currDate01Num=$zdh(currDate01,3)
		
		if ((currDate01Num>=$zdh(startDate,3))&&(currDate01Num<=$zdh(endDate,3))){
			s ifTimeHaveCurrMonth="true"
		}
	;}
		
	///MODE 为S 代表汇总所有的数据，例如本月的数据，只需要将这个月的下的各个维度的数据汇总
	//------------------取当月、当年、当季度的数据，汇总日期段的数据，按照c处理
	//如果是按照月查询，则重新生成当月的数据
	if (dateType="byMonth"){
		set month=currMonth	
		set intervalStartDate=$p(currDate,"-",1)_"-"_$p(currDate,"-",2)_"-01"
		set intervalendDate=currDate	
	}
	if (dateType="byYear"){
		set month=$p(currDate,"-",1)_"年"
		set intervalStartDate=$p(currDate,"-",1)_"-01-01"
		set intervalendDate=currDate		
	}
	if (dateType="byQua"){
		set year=$p(currDate,"-",1)
		set monthNum=$p(currDate,"-",2)
		set currentQ=1
		set ys=monthNum#3
		if (ys=0){
			set currentQ=monthNum\3
		}else{
			set currentQ=(monthNum\3)+1
		}
		///季度的第一天
		set intervalStartDate=$CASE(currentQ,1:year_"-01-01",2:year_"-04-01",3:year_"-07-01",4:year_"-10-01")
		
		set month=$p(currDate,"-",1)_"年"_currentQ_"季度"	
		set intervalendDate=currDate	
	}
	
	if (dateType'="byDay")&&(dateType'="")&&(ifTimeHaveCurrMonth="true"){
				
		s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",intervalStartDate,intervalendDate,"byDay",kpiRule,filterRule,"S","")
		
		While rs.Next(.sc) {
			If $$$ISERR(sc) Quit
            set isHaveData=1
			set dimId=rs.Data("dimIdCol1")
			if dimId="" set dimId="Null"
		    set ret=..setValue(rs, kpiNum, "", month, dimId, kpiRule,"")	
			///维度属性的数据
		    set ^TempkpiValuePro($j,dimId)=""
				for j=1:1:proNum{
					set proCode=$p(proArray,"^",j)
					set dimDesc=rs.Data("dimDesCol"_j)
			        if dimDesc="" set dimDesc="Null"
					set ^TempkpiValuePro($j,dimId,proCode)=dimDesc
				}
	
		}
		 if (kpiRuleSpe'="")&&(filterRuleSpe'=""){
			    
				///获取期初值
				s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",intervalStartDate,intervalStartDate,"byDay",kpiRuleSpe,filterRuleSpe,"S","")
				///设置期初值
				While rs.Next(.sc) {
					If $$$ISERR(sc) Quit
					///维度的id
					set dimId=rs.Data("dimIdCol1")
					if dimId="" set dimId="Null"
					;set contractTyeCurrent=rs.Data("contractTye")
					set ret=..setValue(rs, kpiNumSpe, "", month, dimId, kpiRuleSpe,"start")	
						
				}
					///获取期末的值
					s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",intervalendDate,intervalendDate,"byDay",kpiRuleSpe,filterRuleSpe,"S","")
					///设置期末值
					While rs.Next(.sc) {
						If $$$ISERR(sc) Quit
						s month=qujianDate
    						///维度的id
						set dimId=rs.Data("dimIdCol1")
						if dimId="" set dimId="Null"
						set ret=..setValue(rs, kpiNumSpe, "", month, dimId, kpiRuleSpe,"end")	

					}
				
		    }
		 
		
	}
	///处理按照日期分组时的上期值的处理，按照日期分组 去各个时间段的上期值，而不是整个时间段的上期值，
	////先将开始日期所在日期段的上期值获取出来
	if (groupType="date")&&(contractTye["PP"){
		if (dateType="byMonth"){
			
			set ppDate=$p(startDate,"-",1)_"-"_$p(startDate,"-",2)_"-01"
			set ppNum=$zdh(startDate,3)
			set ppNum=ppNum-1
			set ppDate=$zd(ppNum,3)
			set month=$p(startDate,"-",1)_"年"_$p(startDate,"-",2)_"月"
			set ppStartDate=$p(ppDate,"-",1)_"-"_$p(ppDate,"-",2)_"-01"
			set ppEndDate=ppDate	
		}
		if (dateType="byYear"){
			set ppDate=($p(startDate,"-",1)-1)_"-01-01"	
			set month=$p(startDate,"-",1)_"年"
			set ppStartDate=ppDate
			set ppEndDate=($p(ppDate,"-",1))_"-12-31"		
		}
		if (dateType="byQua"){
			set year=$p(startDate,"-",1)
			set monthNum=$p(startDate,"-",2)
			set currentQ=1
			set ys=monthNum#3
			if (ys=0){
				set currentQ=monthNum\3
			}else{
				set currentQ=(monthNum\3)+1
			}
			set month=$p(year,"-",1)_"年"_currentQ_"季度"
			//向前推一个季度的值，然后计算出一个日期
			if (currentQ=1){
				set year=year-1
			}else{
				set currentQ=currentQ-1
			}
			///季度的第一天
			set ppDate=$CASE(currentQ,1:year_"-01-01",2:year_"-04-01",3:year_"-07-01",4:year_"-10-01")
			set ppStartDate=ppDate
			set ppEndDate=$CASE(num,1:year_"-03-31",2:year_"-06-30",3:year_"-09-30",4:year_"-12-31")
		}
		if (dateType="byDay"){
			set ppNum=$zdh(startDate,3)
			set ppNum=ppNum-1
			set ppDate=$zd(ppNum,3)
			set ppStartDate=ppDate
			set ppEndDate=ppDate
			set month=$p(startDate,"-",1)_"年"_$p(startDate,"-",2)_"月"_$p(startDate,"-",3)_"日"		
		}
		w month,ppStartDate,ppEndDate,!
		s rsPP=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",ppStartDate,ppEndDate,dateType,kpiRule,filterRule,"S","")
		
		While rsPP.Next(.sc) {
			If $$$ISERR(sc) Quit
             set isHaveData=1
			set dimId=rsPP.Data("dimIdCol1")
			if dimId="" set dimId="Null"
		    set ret=..setValue(rsPP, kpiNum, "PP", month, dimId, kpiRule,"")	
			///维度属性的数据
		    set ^TempkpiValuePro($j,dimId)=""
			for j=1:1:proNum{
				set proCode=$p(proArray,"^",j)
				set dimDesc=rsPP.Data("dimDesCol"_j)
			     if dimDesc="" set dimDesc="Null"
				set ^TempkpiValuePro($j,dimId,proCode)=dimDesc
			}
	
		}
		 if (kpiRuleSpe'="")&&(filterRuleSpe'=""){
			    ///如果开始日期和结束日期不是用一天，也就是当前时间是月份1号的时候，期末数据为前一天的数据
			    
				///获取期初值
				s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",ppStartDate,ppStartDate,"byDay",kpiRuleSpe,filterRuleSpe,"S","")
				///设置期初值
				While rs.Next(.sc) {
					If $$$ISERR(sc) Quit
					///维度的id
					set dimId=rs.Data("dimIdCol1")
					if dimId="" set dimId="Null"
					;set contractTyeCurrent=rs.Data("contractTye")
					set ret=..setValue(rs, kpiNumSpe, "PP", month, dimId, kpiRuleSpe,"start")	
						
				}
				///获取期末的值
				s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",ppEndDate,ppEndDate,"byDay",kpiRuleSpe,filterRuleSpe,"S","")
					///设置期末值
				While rs.Next(.sc) {
					If $$$ISERR(sc) Quit
					s month=qujianDate
    						///维度的id
					set dimId=rs.Data("dimIdCol1")
					if dimId="" set dimId="Null"
					set ret=..setValue(rs, kpiNumSpe, "PP", month, dimId, kpiRuleSpe,"end")	

				}
				
		    }
		
	}
	
	
    ////如果不存在数据，则直接返回
    if (isHaveData=0)&&(groupType'="all"){
	   b ;333333
	   Set retFinal.status = 1
		Set retFinal.errMSG = ""
		Set retFinal.data = "[]"
		q retFinal 
	 
	}
	set row=""
	set rtn=""
	set displayRows=0
	
	
	
	
	/////处理生成的数据  2
	
	set date=""
	for{
		///日期
	   set date=$o(^TempkpiValueCurrent($j,date))
	
	   q:date=""
	   for i=1:1:kpiNum{
			set kpiCode=$p($p(kpiRule,",",i),":",1)								
			set ^TempkpiValueFinal($j,"date",date,kpiCode,"sum")=0
					
	   }
       ///获取各个维度的指标值
	  		set dimId=""
	 		for{
		 		
				set dimId=$o(^TempkpiValueCurrent($j,date,dimId))
				q:dimId=""
				set row=""
		        for i=1:1:kpiNum{
		   
		   
			        set kpiCode=$p($p(kpiRule,",",i),":",1)
			   
				
		 		    set value=+$g(^TempkpiValueCurrent($j,date,dimId,kpiCode))
		 		    ///获取维度的第一个维度属性值
		 		    set proCode=$p(proArray,"^",1)
		 		    set dimDesc=$g(^TempkpiValuePro($j,dimId,proCode))
		 		    if (dimDesc'=""){
			 		    set ^TempkpiValueProDesc($j,dimDesc)=dimId
			 		 }
		 		    
		 		    if (dimId=-1){
			 		   SET dimDesc="NULL_VALUE_TEMP_PORTAL"  ///设置一个临时的值，用到这个值不使用
			 		}
		 		    ;w dimId,proCode,!
		 		     ////指标值的统计值
					set ^TempkpiValueFinal($j,"all",kpiCode,"sum")=+$g(^TempkpiValueFinal($j,"all",kpiCode,"sum")) +value
					////按照维度id的统计值
					set ^TempkpiValueFinal($j,"dim",dimId,kpiCode,"sum")=+$g(^TempkpiValueFinal($j,"dim",dimId,kpiCode,"sum")) +value
					
					set ^TempkpiValueFinal($j,"date",date,kpiCode,"sum")=+$g(^TempkpiValueFinal($j,"date",date,kpiCode,"sum")) +value
					//按照维度的属性
					set ^TempkpiValueFinal($j,"dimDesc",dimDesc,kpiCode,"sum")=+$g(^TempkpiValueFinal($j,"dimDesc",dimDesc,kpiCode,"sum")) +value
					set row=row_$case(i,1:"",:",")_""""_kpiCode_""":"""_##class(ext.util.String).EvalJSON(value)_""""
					
					///存在期初数据
					if (kpiRuleSpe'="")&&(filterRuleSpe'=""){
						set startValue=+$g(^TempkpiValueCurrent($j,date,dimId,kpiCode,"start"))
						///如果是统计类的数据，则期初期末值只取第一个和最后一个日期区间的值
						set flage=1
						IF (groupType="all")||(groupType="dim")||(groupType="dimDesc"){
							if (date'=startDateInfact){
								set flage=0
								
							}
						}
						if (flage=1){
							///指标值的统计值
							set ^TempkpiValueFinal($j,"all",kpiCode,"start")=+$g(^TempkpiValueFinal($j,"all",kpiCode,"start")) +startValue
							////按照维度id的统计值
							set ^TempkpiValueFinal($j,"dim",dimId,kpiCode,"start")=+$g(^TempkpiValueFinal($j,"dim",dimId,kpiCode,"start")) +startValue
								
							set ^TempkpiValueFinal($j,"dimDesc",dimDesc,kpiCode,"start")=+$g(^TempkpiValueFinal($j,"dimDesc",dimDesc,kpiCode,"start")) +startValue
					
						}
												
						
						set row=row_","_""""_kpiCode_"_Start"":"""_##class(ext.util.String).EvalJSON(startValue)_""""
						///日期的统计值
						set ^TempkpiValueFinal($j,"date",date,kpiCode,"start")=+$g(^TempkpiValueFinal($j,"date",date,kpiCode,"start")) +startValue
						}
					//存在期末数据
					if (kpiRuleSpe'="")&&(filterRuleSpe'=""){
						set endValue=+$g(^TempkpiValueCurrent($j,date,dimId,kpiCode,"end"))
						///如果是统计类的数据，则期初期末值只取第一个和最后一个日期区间的值
						set flage=1
						IF (groupType="all")||(groupType="dim")||(groupType="dimDesc"){
							if (date'=endDateInfact){
								;w
								set flage=0
								
							}
						}
						if (flage=1){
							;w date,endValue,!
							////指标值的统计值
							set ^TempkpiValueFinal($j,"all",kpiCode,"end")=+$g(^TempkpiValueFinal($j,"all",kpiCode,"end")) +endValue
							////按照维度id的统计值
							set ^TempkpiValueFinal($j,"dim",dimId,kpiCode,"end")=+$g(^TempkpiValueFinal($j,"dim",dimId,kpiCode,"end")) +endValue
							set ^TempkpiValueFinal($j,"dimDesc",dimDesc,kpiCode,"end")=+$g(^TempkpiValueFinal($j,"dimDesc",dimDesc,kpiCode,"end")) +endValue
						}
						set row=row_","_""""_kpiCode_"_End"":"""_##class(ext.util.String).EvalJSON(endValue)_""""
						///日期的统计值
						set ^TempkpiValueFinal($j,"date",date,kpiCode,"end")=+$g(^TempkpiValueFinal($j,"date",date,kpiCode,"end")) +endValue
						
					}
					
					//获取期初和期末的数据，根据情况设置
					///....
					
					///获取上期的值
					if (contractTye'="")&&(contractTye["PP"){
						
						set valuePP=+$g(^TempkpiValuePP($j,date,dimId,kpiCode))
						///日期的统计值
						set ^TempkpiValuePPFinal($j,"date",date,kpiCode,"sum")=+$g(^TempkpiValuePPFinal($j,"date",date,kpiCode,"sum")) +valuePP
						////指标值的统计值
						set ^TempkpiValuePPFinal($j,"all",kpiCode,"sum")=+$g(^TempkpiValuePPFinal($j,"all",kpiCode,"sum")) +valuePP
						////按照维度id的统计值
						set ^TempkpiValuePPFinal($j,"dim",dimId,kpiCode,"sum")=+$g(^TempkpiValuePPFinal($j,"dim",dimId,kpiCode,"sum")) +valuePP
						set ^TempkpiValuePPFinal($j,"dimDesc",dimDesc,kpiCode,"sum")=+$g(^TempkpiValuePPFinal($j,"dimDesc",dimDesc,kpiCode,"sum")) +valuePP
						set ratePP=0
						if (valuePP=0){
							set ratePP=0 ///正无穷大
						}else{
							set ratePP=$fn(value/valuePP-1*100,"",2)
						}
						set row=row_","_""""_kpiCode_"_PP"":"""_##class(ext.util.String).EvalJSON(valuePP)_""""
						set row=row_","_""""_kpiCode_"_PPRate"":"""_##class(ext.util.String).EvalJSON(ratePP)_""""	
						set startValue=0
						set endValue=0
						///存在期初数据
						if (kpiRuleSpe'="")&&(filterRuleSpe'=""){
							

							set startValuePP=+$g(^TempkpiValuePP($j,date,dimId,kpiCode,"start"))
							set rateStartPP=0
							if (startValuePP=0){
								set rateStartPP=0 ///正无穷大
							}else{
								set rateStartPP=$fn(startValue/startValuePP-1*100,"",2)
							}
							set row=row_","_""""_kpiCode_"_PP_Start"":"""_##class(ext.util.String).EvalJSON(startValuePP)_""""
							set row=row_","_""""_kpiCode_"_PP_StartRate"":"""_##class(ext.util.String).EvalJSON(rateStartPP)_""""
							set flage=1
							IF (groupType="all")||(groupType="dim")||(groupType="dimDesc"){
								if (date'=startDateInfact){
									set flage=0
									
								}
							}
							if (flage=1){
								
								////指标值的统计值
								set ^TempkpiValuePPFinal($j,"all",kpiCode,"start")=+$g(^TempkpiValuePPFinal($j,"all",kpiCode,"start")) +startValuePP
								////按照维度id的统计值
								set ^TempkpiValuePPFinal($j,"dim",dimId,kpiCode,"start")=+$g(^TempkpiValuePPFinal($j,"dim",dimId,kpiCode,"start")) +startValuePP
							
								set ^TempkpiValuePPFinal($j,"dimDesc",dimDesc,kpiCode,"start")=+$g(^TempkpiValuePPFinal($j,"dimDesc",dimDesc,kpiCode,"start")) +startValuePP
							
							}
							///日期的统计值
							set ^TempkpiValuePPFinal($j,"date",date,kpiCode,"start")=+$g(^TempkpiValuePPFinal($j,"date",date,kpiCode,"start")) +startValuePP
							
						}
						//同期数据的，存在期末数据
						if (kpiRuleSpe'="")&&(filterRuleSpe'=""){
							set endValuePP=+$g(^TempkpiValuePP($j,date,dimId,kpiCode,"end"))
							set rateEndPP=0
							if (endValuePP=0){
								set rateEndPP=0 ///正无穷大
							}else{
								set rateEndPP=$fn(endValue/endValuePP-1*100,"",2)
							}
							set row=row_","_""""_kpiCode_"_PP_End"":"""_##class(ext.util.String).EvalJSON(endValuePP)_""""
							set row=row_","_""""_kpiCode_"_PP_EndRate"":"""_##class(ext.util.String).EvalJSON(rateEndPP)_""""
							
							set flage=1
							IF (groupType="all")||(groupType="dim")||(groupType="dimDesc"){
								if (date'=endDateInfact){
									set flage=0
									
								}
							}
							if (flage=1){
								////指标值的统计值
								set ^TempkpiValuePPFinal($j,"all",kpiCode,"end")=+$g(^TempkpiValuePPFinal($j,"all",kpiCode,"end")) +endValuePP
								////按照维度id的统计值
								set ^TempkpiValuePPFinal($j,"dim",dimId,kpiCode,"end")=+$g(^TempkpiValuePPFinal($j,"dim",dimId,kpiCode,"end")) +endValuePP
								set ^TempkpiValuePPFinal($j,"dimDesc",dimDesc,kpiCode,"end")=+$g(^TempkpiValuePPFinal($j,"dimDesc",dimDesc,kpiCode,"end")) +endValuePP
							}
							///日期的统计值
							set ^TempkpiValuePPFinal($j,"date",date,kpiCode,"end")=+$g(^TempkpiValuePPFinal($j,"date",date,kpiCode,"end")) +endValuePP
							
						}
					}
					///获取同期的值
					if (contractTye'="")&&(contractTye["SL"){
						set valueSL=+$g(^TempkpiValueSL($j,date,dimId,kpiCode))
						///日期的统计值
						set ^TempkpiValueSLFinal($j,"date",date,kpiCode,"sum")=+$g(^TempkpiValueSLFinal($j,"date",date,kpiCode,"sum")) +valueSL
						////指标值的统计值
						set ^TempkpiValueSLFinal($j,"all",kpiCode,"sum")=+$g(^TempkpiValueSLFinal($j,"all",kpiCode,"sum")) +valueSL
						////按照维度id的统计值
						set ^TempkpiValueSLFinal($j,"dim",dimId,kpiCode,"sum")=+$g(^TempkpiValueSLFinal($j,"dim",dimId,kpiCode,"sum")) +valueSL
						
						set ^TempkpiValueSLFinal($j,"dimDesc",dimDesc,kpiCode,"sum")=+$g(^TempkpiValueSLFinal($j,"dimDesc",dimDesc,kpiCode,"sum")) +valueSL
						set rateSL=0
						if (valueSL=0){
							set rateSL=0 ///正无穷大
						}else{
							set rateSL=$fn(value/valueSL-1*100,"",2)
						}
						set row=row_","_""""_kpiCode_"_SL"":"""_##class(ext.util.String).EvalJSON(valueSL)_""""
						set row=row_","_""""_kpiCode_"_SLRate"":"""_##class(ext.util.String).EvalJSON(rateSL)_""""	
						///存在期初数据
						if (kpiRuleSpe'="")&&(filterRuleSpe'=""){
							set startValueSL=+$g(^TempkpiValueSL($j,date,dimId,kpiCode,"start"))
							set rateStartSL=0
							if (startValueSL=0){
								set rateStartSL=0 ///正无穷大
							}else{
								set rateStartSL=$fn(startValue/startValueSL-1*100,"",2)
							}
							set row=row_","_""""_kpiCode_"_SL_Start"":"""_##class(ext.util.String).EvalJSON(startValueSL)_""""
							set row=row_","_""""_kpiCode_"_SL_StartRate"":"""_##class(ext.util.String).EvalJSON(rateStartSL)_""""
							set flage=1
							IF (groupType="all")||(groupType="dim")||(groupType="dimDesc"){
								if (date'=endDateInfact){
									set flage=0
									
								}
							}
							if (flage=1){
								////指标值的统计值
								set ^TempkpiValueSLFinal($j,"all",kpiCode,"start")=+$g(^TempkpiValueSLFinal($j,"all",kpiCode,"start")) +startValueSL
								////按照维度id的统计值
								set ^TempkpiValueSLFinal($j,"dim",dimId,kpiCode,"start")=+$g(^TempkpiValueSLFinal($j,"dim",dimId,kpiCode,"start")) +startValueSL
							
								set ^TempkpiValueSLFinal($j,"dimDesc",dimDesc,kpiCode,"start")=+$g(^TempkpiValueSLFinal($j,"dimDesc",dimDesc,kpiCode,"start")) +startValueSL
					
							}
							///日期的统计值
							set ^TempkpiValueSLFinal($j,"date",date,kpiCode,"start")=+$g(^TempkpiValueSLFinal($j,"date",date,kpiCode,"start")) +startValueSL
						}
						//存在期末数据
						if (kpiRuleSpe'="")&&(filterRuleSpe'=""){
							set endValueSL=+$g(^TempkpiValueSL($j,date,dimId,kpiCode,"end"))
							set rateEndSL=0
							if (endValueSL=0){
								set rateEndSL=0 ///正无穷大
							}else{
								set rateEndSL=$fn(endValue/endValueSL-1*100,"",2)
							}
							
							set row=row_","_""""_kpiCode_"_SL_End"":"""_##class(ext.util.String).EvalJSON(endValue)_""""
							set row=row_","_""""_kpiCode_"_SL_EndRate"":"""_##class(ext.util.String).EvalJSON(rateEndSL)_""""
							set flage=1
							IF (groupType="all")||(groupType="dim")||(groupType="dimDesc"){
								if (date'=endDateInfact){
									set flage=0
									
								}
							}
							if (flage=1){
								////指标值的统计值
								set ^TempkpiValueSLFinal($j,"all",kpiCode,"end")=+$g(^TempkpiValueSLFinal($j,"all",kpiCode,"end")) +endValueSL
								////按照维度id的统计值
								set ^TempkpiValueSLFinal($j,"dim",dimId,kpiCode,"end")=+$g(^TempkpiValueSLFinal($j,"dim",dimId,kpiCode,"end")) +endValueSL
							
								set ^TempkpiValueSLFinal($j,"dimDesc",dimDesc,kpiCode,"end")=+$g(^TempkpiValueSLFinal($j,"dimDesc",dimDesc,kpiCode,"end")) +endValueSL
										
							}
							///日期的统计值
							set ^TempkpiValueSLFinal($j,"date",date,kpiCode,"end")=+$g(^TempkpiValueSLFinal($j,"date",date,kpiCode,"end")) +endValueSL
						}
					}
		 		 
	 		 }
	 		
			 ////如果没有具体的统计方式，则按照日期和维度输出数据
			if (groupType="detail")&&(dimId'=-1){
				set monthStr=date
			  
				if (dateType="byYear") {
					s month=$tr(monthStr,"年","")
				}
				if (dateType="byDay") {
					s month=$tr(monthStr,"年","-")
					s month=$tr(month,"月","-")
					s month=$tr(month,"日","")
				}
				if (dateType="byMonth") {
					s month=$tr(monthStr,"年","-")
					
					s month=$tr(month,"月","")
				}
				if (dateType="byQua") {
					s month=$tr(monthStr,"年","Q")
					s month=$tr(month,"季度","")
				}
		 		for j=1:1:proNum{
					set proCode=$p(proArray,"^",j)
					set valueDesc=$g(^TempkpiValuePro($j,dimId,proCode))
					set row=row_","""_proCode_""":"""_##class(ext.util.String).EvalJSON(valueDesc)_""""
					set row=row_",""dimIdCol"_j_""":"""_##class(ext.util.String).EvalJSON(dimId)_""""
				}
				set row= row_",""month"":"""_month_""""
	       		set row= row_",""monthStr"":"""_monthStr_""""
	       		;w displayRows,!
	      		Set rtn = rtn_$case(displayRows,0:"",:",")_"{"_row_"}"
	      		;w rtn,!
	      		;b ;1111
		   		set displayRows = displayRows+1
			}		
			
			
				
		}
			
			
		   		
		}
		    
	
	 
	  //按照日期统计，遍历日期节点的数据
	if (groupType="date"){
		
		set row=""
		set rtn=""
		set displayRows=0
		set date=""
		for{
		///日期
		   set date=$o(^TempkpiValueFinal($j,"date",date))
		   
		   q:date=""
		   ///去日期段的日期差
		  set dateNum=..getDateNum(date,dateType,"")
		  set dateSLNum=..getDateNum(date,dateType,"SL")
		  set datePPNum=..getDateNum(date,dateType,"PP")
		   set row=""
		   for i=1:1:kpiNum{
				set kpiCode=$p($p(kpiRule,",",i),":",1)
				///同期值处理
				   ///累计值
				set value=+$g(^TempkpiValueFinal($j,"date",date,kpiCode,"sum"))
				   ////期初值
				set startValue=+$g(^TempkpiValueFinal($j,"date",date,kpiCode,"start"))
				   ///期末值
				set endValue=+$g(^TempkpiValueFinal($j,"date",date,kpiCode,"end"))
				
				set row=row_$case(i,1:"",:",")_""""_kpiCode_""":"""_##class(ext.util.String).EvalJSON(value)_""""
				set row=row_","_""""_kpiCode_"_Avg"":"""_##class(ext.util.String).EvalJSON(value/dateNum)_""""
				if (kpiRuleSpe'="")&&(filterRuleSpe'=""){
					set row=row_","_""""_kpiCode_"_Start"":"""_##class(ext.util.String).EvalJSON(startValue)_""""
				}
				if (kpiRuleSpe'="")&&(filterRuleSpe'=""){
					set row=row_","_""""_kpiCode_"_End"":"""_##class(ext.util.String).EvalJSON(endValue)_""""
				}
						
				///查询了上期值
				if (contractTye'="")&&(contractTye["PP"){
					///将这里的上期值改为当前时间段的上期值的数据
					///获取上期的值
					
					//先获取下有没有上期的值，如果有代表是特殊处理下生成，否则从本期值里去获取值
					set startDateStr=$p(startDate,"-",1)_"年"_$p(startDate,"-",2)_"月"_$p(startDate,"-",3)_"日"
					if (dateType="byMonth"){
						set startDateStr=$p(startDate,"-",1)_"年"_$p(startDate,"-",2)_"月"
					}
					if (dateType="byYear"){
						set startDateStr=$p(startDate,"-",1)_"年"
					}
					if (dateType="byQua"){
						set year=$p(startDate,"-",1)
						set monthNum=$p(startDate,"-",2)
						set currentQ=1
						set ys=monthNum#3
						if (ys=0){
							set currentQ=monthNum\3
						}else{
							set currentQ=(monthNum\3)+1
						}
						set startDateStr=$p(year,"-",1)_"年"_currentQ_"季度"
						
					}
					set valuePP=+$g(^TempkpiValuePPFinal($j,"date",date,kpiCode,"sum"))
					if (startDateStr=date){
						set valuePP=+$g(^TempkpiValuePPFinal($j,"date",date,kpiCode,"sum"))
					}else{
						///去当前时间段的日期
						set ppdate=..getPPDate(date,dateType)
						set valuePP=+$g(^TempkpiValueFinal($j,"date",ppdate,kpiCode,"sum"))
					}
					
					set row=row_","_""""_kpiCode_"_PP"":"""_##class(ext.util.String).EvalJSON(valuePP)_""""
					set valueAvgPP=valuePP/datePPNum
					set rateAvgPP=0
						if (valueAvgPP=0){
							set rateAvgPP=0 ///正无穷大
						}else{
							set rateAvgPP=$fn((value/dateNum)/valueAvgPP-1*100,"",2)
						}
					set row=row_","_""""_kpiCode_"_PP_Avg"":"""_##class(ext.util.String).EvalJSON(valueAvgPP)_""""
					set row=row_","_""""_kpiCode_"_PP_AvgRate"":"""_##class(ext.util.String).EvalJSON(rateAvgPP)_""""
					set ratePP=0
						if (valuePP=0){
							set ratePP=0 ///正无穷大
						}else{
							set ratePP=$fn(value/valuePP-1*100,"",2)
						}
						
					set row=row_","_""""_kpiCode_"_PPRate"":"""_##class(ext.util.String).EvalJSON(ratePP)_""""
					///存在期初值
					if (kpiRuleSpe'="")&&(filterRuleSpe'=""){
						set startValuePP=+$g(^TempkpiValuePPFinal($j,"date",date,kpiCode,"start"))
						if (startDateStr=date){
							set startValuePP=+$g(^TempkpiValuePPFinal($j,"date",date,kpiCode,"start"))
						}else{
							///去当前时间段的日期
							set ppdate=..getPPDate(date,dateType)
							set startValuePP=+$g(^TempkpiValueFinal($j,"date",ppdate,kpiCode,"start"))
						}
						set rateStartPP=0
						if (startValuePP=0){
							set rateStartPP=0 ///正无穷大
						}else{
							set rateStartPP=$fn(startValue/startValuePP-1*100,"",2)
						}
						set row=row_","_""""_kpiCode_"_PP_Start"":"""_##class(ext.util.String).EvalJSON(startValuePP)_""""
						set row=row_","_""""_kpiCode_"_PP_StartRate"":"""_##class(ext.util.String).EvalJSON(rateStartPP)_""""
					}
					///存在期末值
					if (kpiRuleSpe'="")&&(filterRuleSpe'=""){
						set endValuePP=+$g(^TempkpiValuePPFinal($j,"date",date,kpiCode,"end"))
						if (startDateStr=date){
							set endValuePP=+$g(^TempkpiValuePPFinal($j,"date",date,kpiCode,"end"))
						}else{
							///去当前时间段的日期
							set ppdate=..getPPDate(date,dateType)
							set endValuePP=+$g(^TempkpiValueFinal($j,"date",ppdate,kpiCode,"end"))
						}
						if (endValuePP=0){
							set rateEndPP=0 ///正无穷大
						}else{
							set rateEndPP=$fn(endValue/endValuePP-1*100,"",2)
						}
						set row=row_","_""""_kpiCode_"_PP_End"":"""_##class(ext.util.String).EvalJSON(endValuePP)_""""
						set row=row_","_""""_kpiCode_"_PP_EndRate"":"""_##class(ext.util.String).EvalJSON(rateEndPP)_""""
					}
				}
				///查询同期值
				if (contractTye'="")&&(contractTye["SL"){
					set valueSL=+$g(^TempkpiValueSLFinal($j,"date",date,kpiCode,"sum"))
					set row=row_","_""""_kpiCode_"_SL"":"""_##class(ext.util.String).EvalJSON(valueSL)_""""
					set valueAvgSL=valueSL/dateSLNum
					set rateAvgSL=0
						if (valueAvgSL=0){
							set rateAvgSL=0 ///正无穷大
						}else{
							set rateAvgSL=$fn((value/dateNum)/valueAvgSL-1*100,"",2)
						}
					set row=row_","_""""_kpiCode_"_SL_Avg"":"""_##class(ext.util.String).EvalJSON(valueSL/dateSLNum)_""""
					set row=row_","_""""_kpiCode_"_SL_AvgRate"":"""_##class(ext.util.String).EvalJSON(rateAvgSL)_""""
					set rateSL=0
						if (valueSL=0){
							set rateSL=0 ///正无穷大
						}else{
							set rateSL=$fn(value/valueSL-1*100,"",2)
						}
						
					set row=row_","_""""_kpiCode_"_SLRate"":"""_##class(ext.util.String).EvalJSON(rateSL)_""""
					
						
					///存在期初值
					if (kpiRuleSpe'="")&&(filterRuleSpe'=""){
						set startValueSL=+$g(^TempkpiValueSLFinal($j,"date",date,kpiCode,"start"))
						set rateStartSL=0
						if (startValueSL=0){
							set rateStartSL=0 ///正无穷大
						}else{
							set rateStartSL=$fn(startValue/startValueSL-1*100,"",2)
						}
						set row=row_","_""""_kpiCode_"_SL_Start"":"""_##class(ext.util.String).EvalJSON(startValueSL)_""""
						set row=row_","_""""_kpiCode_"_SL_StartRate"":"""_##class(ext.util.String).EvalJSON(rateStartSL)_""""
					}
					///存在期末值
					if (kpiRuleSpe'="")&&(filterRuleSpe'=""){
						set endValueSL=+$g(^TempkpiValueSLFinal($j,"date",date,kpiCode,"end"))
						if (endValueSL=0){
							set rateEndSL=0 ///正无穷大
						}else{
							set rateEndSL=$fn(endValue/endValueSL-1*100,"",2)
						}
						set row=row_","_""""_kpiCode_"_SL_End"":"""_##class(ext.util.String).EvalJSON(endValueSL)_""""
						set row=row_","_""""_kpiCode_"_SL_EndRate"":"""_##class(ext.util.String).EvalJSON(rateEndSL)_""""
					}
				        
					
				}
				
		   }
		   set monthStr=date
		  
			if (dateType="byYear") {
				s month=$tr(monthStr,"年","")
			}
			if (dateType="byDay") {
				s month=$tr(monthStr,"年","-")
				s month=$tr(month,"月","-")
				s month=$tr(month,"日","")
			}
			if (dateType="byMonth") {
				s month=$tr(monthStr,"年","-")
				
				s month=$tr(month,"月","")
			}
			if (dateType="byQua") {
				s month=$tr(monthStr,"年","Q")
				s month=$tr(month,"季度","")
			}
			
		   set row= row_",""month"":"""_month_""""
	       set row= row_",""monthStr"":"""_monthStr_""""
	       Set rtn = rtn_$case(displayRows,0:"",:",")_"{"_row_"}"
		   set displayRows = displayRows+1
		}
		
    }
    ;b ;梳理出数据
    set dateNum=..getDateNum2(startDate,endDate,dateType,"",commonLength)
	set dateSLNum=..getDateNum2(startDate,endDate,dateType,"SL",commonLength)
	set datePPNum=..getDateNum2(startDate,endDate,dateType,"PP",commonLength)
     //按照统计所有的值
	if (groupType="all"){
		set row=""
		set rtn=""
		set displayRows=0
		set kpiCode=""
		set i=0
		for{
		///日期
		   set kpiCode=$o(^TempkpiValueFinal($j,"all",kpiCode))
		   
		   q:kpiCode=""
		   //for i=1:1:kpiNum{
				//set kpiCode=$p($p(kpiRule,",",k),":",1)
				///同期值处理
				   ///累计值
				set value=+$g(^TempkpiValueFinal($j,"all",kpiCode,"sum"))
				   ////期初值
				set startValue=+$g(^TempkpiValueFinal($j,"all",kpiCode,"start"))
				   ///期末值
				set endValue=+$g(^TempkpiValueFinal($j,"all",kpiCode,"end"))
				
				
				set row=row_$case(i,0:"",:",")_""""_kpiCode_""":"""_##class(ext.util.String).EvalJSON(value)_""""
				set row=row_","_""""_kpiCode_"_Avg"":"""_##class(ext.util.String).EvalJSON(value/dateNum)_""""
				///存在期初值
				if (kpiRuleSpe'="")&&(filterRuleSpe'=""){
					 set row=row_","_""""_kpiCode_"_Start"":"""_##class(ext.util.String).EvalJSON(startValue)_""""
				}
			    ///存在期末值
				if (kpiRuleSpe'="")&&(filterRuleSpe'=""){

					 set row=row_","_""""_kpiCode_"_End"":"""_##class(ext.util.String).EvalJSON(endValue)_""""
				}
				
				///查询了上期值
				if (contractTye'="")&&(contractTye["PP"){
					set valuePP=+$g(^TempkpiValuePPFinal($j,"all",kpiCode,"sum"))
					
				    set row=row_","_""""_kpiCode_"_PP"":"""_##class(ext.util.String).EvalJSON(valuePP)_""""
				    set valueAvgPP=valuePP/datePPNum
					set rateAvgPP=0
						if (valueAvgPP=0){
							set rateAvgPP=0 ///正无穷大
						}else{
							set rateAvgPP=$fn((value/dateNum)/valueAvgPP-1*100,"",2)
						}
				    set row=row_","_""""_kpiCode_"_PP_Avg"":"""_##class(ext.util.String).EvalJSON(valueAvgPP)_""""
				    
				    set row=row_","_""""_kpiCode_"_PP_AvgRate"":"""_##class(ext.util.String).EvalJSON(rateAvgPP)_""""
				    set ratePP=0
						if (valuePP=0){
							set ratePP=0 ///正无穷大
						}else{
							set ratePP=$fn(value/valuePP-1*100,"",2)
						}
						
					set row=row_","_""""_kpiCode_"_PPRate"":"""_##class(ext.util.String).EvalJSON(ratePP)_""""
					///存在期初值
					if (kpiRuleSpe'="")&&(filterRuleSpe'=""){
						set startValuePP=+$g(^TempkpiValuePPFinal($j,"all",kpiCode,"start"))
						set rateStartPP=0
						if (startValuePP=0){
							set rateStartPP=0 ///正无穷大
						}else{
							set rateStartPP=$fn(startValue/startValuePP-1*100,"",2)
						}
						set row=row_","_""""_kpiCode_"_PP_Start"":"""_##class(ext.util.String).EvalJSON(startValuePP)_""""
						set row=row_","_""""_kpiCode_"_PP_StartRate"":"""_##class(ext.util.String).EvalJSON(rateStartPP)_""""
					}
					///存在期末值
					if (kpiRuleSpe'="")&&(filterRuleSpe'=""){
						set endValuePP=+$g(^TempkpiValuePPFinal($j,"all",kpiCode,"end"))
						if (endValuePP=0){
							set rateEndPP=0 ///正无穷大
						}else{
							set rateEndPP=$fn(endValue/endValuePP-1*100,"",2)
						}
						set row=row_","_""""_kpiCode_"_PP_End"":"""_##class(ext.util.String).EvalJSON(endValuePP)_""""
						set row=row_","_""""_kpiCode_"_PP_EndRate"":"""_##class(ext.util.String).EvalJSON(rateEndPP)_""""
					}
				}
				///查询同期值
				if (contractTye'="")&&(contractTye["SL"){ 
				    
					set valueSL=+$g(^TempkpiValueSLFinal($j,"all",kpiCode,"sum"))
					
				    set row=row_","_""""_kpiCode_"_SL"":"""_##class(ext.util.String).EvalJSON(valueSL)_""""
				    set valueAvgSL=valueSL/dateSLNum
					set rateAvgSL=0
						if (valueAvgSL=0){
							set rateAvgSL=0 ///正无穷大
						}else{
							set rateAvgSL=$fn((value/dateNum)/valueAvgSL-1*100,"",2)
						}
				    set row=row_","_""""_kpiCode_"_SL_Avg"":"""_##class(ext.util.String).EvalJSON(valueAvgSL)_""""
				    set row=row_","_""""_kpiCode_"_SL_AvgRate"":"""_##class(ext.util.String).EvalJSON(rateAvgSL)_""""
				    set rateSL=0
						if (valueSL=0){
							set rateSL=0 ///正无穷大
						}else{
							set rateSL=$fn(value/valueSL-1*100,"",2)
						}
						
					set row=row_","_""""_kpiCode_"_SLRate"":"""_##class(ext.util.String).EvalJSON(rateSL)_""""
					///存在期初值
					if (kpiRuleSpe'="")&&(filterRuleSpe'=""){
						set startValueSL=+$g(^TempkpiValueSLFinal($j,"all",kpiCode,"start"))
						set rateStartSL=0
						if (startValueSL=0){
							set rateStartSL=0 ///正无穷大
						}else{
							set rateStartSL=$fn(startValue/startValueSL-1*100,"",2)
						}
						set row=row_","_""""_kpiCode_"_SL_Start"":"""_##class(ext.util.String).EvalJSON(startValueSL)_""""
						set row=row_","_""""_kpiCode_"_SL_StartRate"":"""_##class(ext.util.String).EvalJSON(rateStartSL)_""""
					}
					///存在期末值
					if (kpiRuleSpe'="")&&(filterRuleSpe'=""){
						set endValueSL=+$g(^TempkpiValueSLFinal($j,"all",kpiCode,"end"))
						if (endValueSL=0){
							set rateEndSL=0 ///正无穷大
						}else{
							set rateEndSL=$fn(endValue/endValueSL-1*100,"",2)
						}
						set row=row_","_""""_kpiCode_"_SL_End"":"""_##class(ext.util.String).EvalJSON(endValueSL)_""""
						set row=row_","_""""_kpiCode_"_SL_EndRate"":"""_##class(ext.util.String).EvalJSON(rateEndSL)_""""
					}
				}
				
		   //}
		  
	      set i=i+1
		   
		}
		 Set rtn = rtn_$case(displayRows,0:"",:",")_"{"_row_"}"
		 set displayRows = displayRows+1
    }
      //按照维度统计，遍历维度节点的数据
	if (groupType="dim"){
		set row=""
		set rtn=""
		set displayRows=0
		set dimId=""
		for{
		///日期
		   set dimId=$o(^TempkpiValueFinal($j,"dim",dimId))
		   q:(dimId="")
		   continue:dimId=-1
		   set row=""
		   for i=1:1:kpiNum{
				set kpiCode=$p($p(kpiRule,",",i),":",1)
				///同期值处理
				   ///累计值
				set value=+$g(^TempkpiValueFinal($j,"dim",dimId,kpiCode,"sum"))
				   ////期初值
				set startValue=+$g(^TempkpiValueFinal($j,"dim",dimId,kpiCode,"start"))
				   ///期末值
				set endValue=+$g(^TempkpiValueFinal($j,"dim",dimId,kpiCode,"end"))
				
				set row=row_$case(i,1:"",:",")_""""_kpiCode_""":"""_##class(ext.util.String).EvalJSON(value)_""""
				set row=row_","_""""_kpiCode_"_Avg"":"""_##class(ext.util.String).EvalJSON(value/dateNum)_""""
				if (kpiRuleSpe'="")&&(filterRuleSpe'=""){
					set row=row_","_""""_kpiCode_"_Start"":"""_##class(ext.util.String).EvalJSON(startValue)_""""
				}
				if (kpiRuleSpe'="")&&(filterRuleSpe'=""){
					set row=row_","_""""_kpiCode_"_End"":"""_##class(ext.util.String).EvalJSON(endValue)_""""
				}
						
				///查询了上期值
				if (contractTye'="")&&(contractTye["PP"){
					set valuePP=+$g(^TempkpiValuePPFinal($j,"dim",dimId,kpiCode,"sum"))
					set row=row_","_""""_kpiCode_"_PP"":"""_##class(ext.util.String).EvalJSON(valuePP)_""""
					
					set valueAvgPP=valuePP/datePPNum
					set rateAvgPP=0
						if (valueAvgPP=0){
							set rateAvgPP=0 ///正无穷大
						}else{
							set rateAvgPP=$fn((value/dateNum)/valueAvgPP-1*100,"",2)
						}
					set row=row_","_""""_kpiCode_"_PP_Avg"":"""_##class(ext.util.String).EvalJSON(valuePP/datePPNum)_""""
					set row=row_","_""""_kpiCode_"_PP_AvgRate"":"""_##class(ext.util.String).EvalJSON(rateAvgPP)_""""
					    set ratePP=0
						if (valuePP=0){
							set ratePP=0 ///正无穷大
						}else{
							set ratePP=$fn(value/valuePP-1*100,"",2)
						}
						
					set row=row_","_""""_kpiCode_"_PPRate"":"""_##class(ext.util.String).EvalJSON(ratePP)_""""
					///存在期初值
					if (kpiRuleSpe'="")&&(filterRuleSpe'=""){
						set startValuePP=+$g(^TempkpiValuePPFinal($j,"dim",dimId,kpiCode,"start"))
						set rateStartPP=0
						if (startValuePP=0){
							set rateStartPP=0 ///正无穷大
						}else{
							set rateStartPP=$fn(startValue/startValuePP-1*100,"",2)
						}
						set row=row_","_""""_kpiCode_"_PP_Start"":"""_##class(ext.util.String).EvalJSON(startValuePP)_""""
						set row=row_","_""""_kpiCode_"_PP_StartRate"":"""_##class(ext.util.String).EvalJSON(rateStartPP)_""""
					}
					///存在期末值
					if (kpiRuleSpe'="")&&(filterRuleSpe'=""){
						set endValuePP=+$g(^TempkpiValuePPFinal($j,"dim",dimId,kpiCode,"end"))
						if (endValuePP=0){
							set rateEndPP=0 ///正无穷大
						}else{
							set rateEndPP=$fn(endValue/endValuePP-1*100,"",2)
						}
						set row=row_","_""""_kpiCode_"_PP_End"":"""_##class(ext.util.String).EvalJSON(endValuePP)_""""
						set row=row_","_""""_kpiCode_"_PP_EndRate"":"""_##class(ext.util.String).EvalJSON(rateEndPP)_""""
					}
				}
				///查询同期值
				if (contractTye'=""&&(contractTye["SL")){
					set valueSL=+$g(^TempkpiValueSLFinal($j,"dim",dimId,kpiCode,"sum"))
					set row=row_","_""""_kpiCode_"_SL"":"""_##class(ext.util.String).EvalJSON(valueSL)_""""
					set valueAvgSL=valueSL/dateSLNum
					set rateAvgSL=0
						if (valueAvgSL=0){
							set rateAvgSL=0 ///正无穷大
						}else{
							set rateAvgSL=$fn((value/dateNum)/valueAvgSL-1*100,"",2)
						}
					set row=row_","_""""_kpiCode_"_SL_Avg"":"""_##class(ext.util.String).EvalJSON(valueSL/dateSLNum)_""""
					set row=row_","_""""_kpiCode_"_SL_AvgRate"":"""_##class(ext.util.String).EvalJSON(rateAvgSL)_""""
					    set rateSL=0
						if (valueSL=0){
							set rateSL=0 ///正无穷大
						}else{
							set rateSL=$fn(value/valueSL-1*100,"",2)
						}
						
					set row=row_","_""""_kpiCode_"_SLRate"":"""_##class(ext.util.String).EvalJSON(rateSL)_""""
					///存在期初值
					if (kpiRuleSpe'="")&&(filterRuleSpe'=""){
						set startValueSL=+$g(^TempkpiValueSLFinal($j,"dim",dimId,kpiCode,"start"))
						set rateStartSL=0
						if (startValueSL=0){
							set rateStartSL=0 ///正无穷大
						}else{
							set rateStartSL=$fn(startValue/startValueSL-1*100,"",2)
						}
						set row=row_","_""""_kpiCode_"_SL_Start"":"""_##class(ext.util.String).EvalJSON(startValueSL)_""""
						set row=row_","_""""_kpiCode_"_SL_StartRate"":"""_##class(ext.util.String).EvalJSON(rateStartSL)_""""
					}
					///存在期末值
					if (kpiRuleSpe'="")&&(filterRuleSpe'=""){
						set endValueSL=+$g(^TempkpiValueSLFinal($j,"dim",dimId,kpiCode,"end"))
						if (endValueSL=0){
							set rateEndSL=0 ///正无穷大
						}else{
							set rateEndSL=$fn(endValue/endValueSL-1*100,"",2)
						}
						set row=row_","_""""_kpiCode_"_SL_End"":"""_##class(ext.util.String).EvalJSON(endValueSL)_""""
						set row=row_","_""""_kpiCode_"_SL_EndRate"":"""_##class(ext.util.String).EvalJSON(rateEndSL)_""""
					}
				        
					
				}
				
		   }
		   for j=1:1:proNum{
				set proCode=$p(proArray,"^",j)
				set valueDesc=$g(^TempkpiValuePro($j,dimId,proCode))
				set row=row_","""_proCode_""":"""_##class(ext.util.String).EvalJSON(valueDesc)_""""
				set row=row_",""dimIdCol"_j_""":"""_##class(ext.util.String).EvalJSON(dimId)_""""
			}
		   
	       Set rtn = rtn_$case(displayRows,0:"",:",")_"{"_row_"}"
		   set displayRows = displayRows+1
		}
		
    }
          //按照维度统计，遍历维度节点的数据
	if (groupType="dimDesc"){
		set row=""
		set rtn=""
		set displayRows=0
		set dimDesc=""
		for{
		///日期
		   set dimDesc=$o(^TempkpiValueFinal($j,"dimDesc",dimDesc))
		   
		   q:(dimDesc="")
		   continue:(dimDesc="NULL_VALUE_TEMP_PORTAL")
		   
		   set row=""
		   for i=1:1:kpiNum{
				set kpiCode=$p($p(kpiRule,",",i),":",1)
				///本期值处理
				   ///累计值
				set value=+$g(^TempkpiValueFinal($j,"dimDesc",dimDesc,kpiCode,"sum"))
				   ////期初值
				set startValue=+$g(^TempkpiValueFinal($j,"dimDesc",dimDesc,kpiCode,"start"))
				   ///期末值
				set endValue=+$g(^TempkpiValueFinal($j,"dimDesc",dimDesc,kpiCode,"end"))
				
				set row=row_$case(i,1:"",:",")_""""_kpiCode_""":"""_##class(ext.util.String).EvalJSON(value)_""""
				set row=row_","_""""_kpiCode_"_Avg"":"""_##class(ext.util.String).EvalJSON(value/dateNum)_""""
				if (kpiRuleSpe'="")&&(filterRuleSpe'=""){
					set row=row_","_""""_kpiCode_"_Start"":"""_##class(ext.util.String).EvalJSON(startValue)_""""
				}
				if (kpiRuleSpe'="")&&(filterRuleSpe'=""){
					set row=row_","_""""_kpiCode_"_End"":"""_##class(ext.util.String).EvalJSON(endValue)_""""
				}
						
				///查询了上期值
				if (contractTye'="")&&(contractTye["PP"){
					set valuePP=+$g(^TempkpiValuePPFinal($j,"dimDesc",dimDesc,kpiCode,"sum"))
					set row=row_","_""""_kpiCode_"_PP"":"""_##class(ext.util.String).EvalJSON(valuePP)_""""
					set valueAvgPP=valuePP/datePPNum
					set rateAvgPP=0
						if (valueAvgPP=0){
							set rateAvgPP=0 ///正无穷大
						}else{
							set rateAvgPP=$fn((value/dateNum)/valueAvgPP-1*100,"",2)
						}
					set row=row_","_""""_kpiCode_"_PP_Avg"":"""_##class(ext.util.String).EvalJSON(valuePP/datePPNum)_""""
					set row=row_","_""""_kpiCode_"_PP_AvgRate"":"""_##class(ext.util.String).EvalJSON(rateAvgPP)_""""
					
					
					    set ratePP=0
						if (valuePP=0){
							set ratePP=0 ///正无穷大
						}else{
							set ratePP=$fn(value/valuePP-1*100,"",2)
						}
						
					set row=row_","_""""_kpiCode_"_PPRate"":"""_##class(ext.util.String).EvalJSON(ratePP)_""""
					///存在期初值
					if (kpiRuleSpe'="")&&(filterRuleSpe'=""){
						set startValuePP=+$g(^TempkpiValuePPFinal($j,"dimDesc",dimDesc,kpiCode,"start"))
						set rateStartPP=0
						if (startValuePP=0){
							set rateStartPP=0 ///正无穷大
						}else{
							set rateStartPP=$fn(startValue/startValuePP-1*100,"",2)
						}
						set row=row_","_""""_kpiCode_"_PP_Start"":"""_##class(ext.util.String).EvalJSON(startValuePP)_""""
						set row=row_","_""""_kpiCode_"_PP_StartRate"":"""_##class(ext.util.String).EvalJSON(rateStartPP)_""""
					}
					///存在期末值
					if (kpiRuleSpe'="")&&(filterRuleSpe'=""){
						set endValuePP=+$g(^TempkpiValuePPFinal($j,"dimDesc",dimDesc,kpiCode,"end"))
						if (endValuePP=0){
							set rateEndPP=0 ///正无穷大
						}else{
							set rateEndPP=$fn(endValue/endValuePP-1*100,"",2)
						}
						set row=row_","_""""_kpiCode_"_PP_End"":"""_##class(ext.util.String).EvalJSON(endValuePP)_""""
						set row=row_","_""""_kpiCode_"_PP_EndRate"":"""_##class(ext.util.String).EvalJSON(rateEndPP)_""""
					}
				}
				///查询同期值
				if (contractTye'="")&&(contractTye["SL"){
					set valueSL=+$g(^TempkpiValueSLFinal($j,"dimDesc",dimDesc,kpiCode,"sum"))
					set row=row_","_""""_kpiCode_"_SL"":"""_##class(ext.util.String).EvalJSON(valueSL)_""""
					set valueAvgSL=valueSL/dateSLNum
					set rateAvgSL=0
						if (valueAvgSL=0){
							set rateAvgSL=0 ///正无穷大
						}else{
							set rateAvgSL=$fn((value/dateNum)/valueAvgSL-1*100,"",2)
						}
					set row=row_","_""""_kpiCode_"_SL_Avg"":"""_##class(ext.util.String).EvalJSON(valueAvgSL)_""""
					set row=row_","_""""_kpiCode_"_SL_AvgRate"":"""_##class(ext.util.String).EvalJSON(rateAvgSL)_""""
					
					    set rateSL=0
						if (valueSL=0){
							set rateSL=0 ///正无穷大
						}else{
							set rateSL=$fn(value/valueSL-1*100,"",2)
						}
						
					set row=row_","_""""_kpiCode_"_SLRate"":"""_##class(ext.util.String).EvalJSON(rateSL)_""""
					///存在期初值
					if (kpiRuleSpe'="")&&(filterRuleSpe'=""){
						set startValueSL=+$g(^TempkpiValueSLFinal($j,"dimDesc",dimDesc,kpiCode,"start"))
						set rateStartSL=0
						if (startValueSL=0){
							set rateStartSL=0 ///正无穷大
						}else{
							set rateStartSL=$fn(startValue/startValueSL-1*100,"",2)
						}
						set row=row_","_""""_kpiCode_"_SL_Start"":"""_##class(ext.util.String).EvalJSON(startValueSL)_""""
						set row=row_","_""""_kpiCode_"_SL_StartRate"":"""_##class(ext.util.String).EvalJSON(rateStartSL)_""""
					}
					///存在期末值
					if (kpiRuleSpe'="")&&(filterRuleSpe'=""){
						set endValueSL=+$g(^TempkpiValueSLFinal($j,"dimDesc",dimDesc,kpiCode,"end"))
						if (endValueSL=0){
							set rateEndSL=0 ///正无穷大
						}else{
							set rateEndSL=$fn(endValue/endValueSL-1*100,"",2)
						}
						set row=row_","_""""_kpiCode_"_SL_End"":"""_##class(ext.util.String).EvalJSON(endValueSL)_""""
						set row=row_","_""""_kpiCode_"_SL_EndRate"":"""_##class(ext.util.String).EvalJSON(rateEndSL)_""""
					}
				        
					
				}
				
		   }
		   set dimId=$g(^TempkpiValueProDesc($j,dimDesc))
		   for j=1:1:proNum{
				set proCode=$p(proArray,"^",j)
				set valueDesc=$g(^TempkpiValuePro($j,dimId,proCode))
				set row=row_","""_proCode_""":"""_##class(ext.util.String).EvalJSON(valueDesc)_""""
				set row=row_",""dimIdCol"_j_""":"""_##class(ext.util.String).EvalJSON(dimId)_""""
			}
		   //set proCode=$p(proArray,"^",1)
		   
		   //set dimId=$g(^TempkpiValueProDesc($j,dimDesc))
		   //set row=row_","""_proCode_""":"""_##class(ext.util.String).EvalJSON(dimDesc)_""""
		   //set row=row_",""dimIdCol1"":"""_##class(ext.util.String).EvalJSON(dimId)_""""
		   
		  
	       Set rtn = rtn_$case(displayRows,0:"",:",")_"{"_row_"}"
		   set displayRows = displayRows+1
		}
		
    }	
	set rtn= "["_rtn_"]"
	W rtn,!
	
	Set retFinal.status = 1
	Set retFinal.errMSG = ""
	Set retFinal.data = rtn
	q retFinal
}

/// /根据接口返回的数据，给各个指标赋值
ClassMethod setValue(rs, kpiNum, contractTye, month, dimId, kpiRule, type) As %String
{
   new (rs,kpiNum,contractTye,month,dimId,kpiRule,type)
 	///上期的数据
	       ;if dimId=""  set dimId=0
			for i=1:1:kpiNum{
					set value=rs.Data("kpiValueCol"_i)
					;w value,!
					if value="" s value=0
					set kpiCode=$p($p(kpiRule,",",i),":",1)
					if (contractTye=""){
						if (type="start"){
							set ^TempkpiValueCurrent($j,month,dimId,kpiCode,"start")=value
						}
						if (type="end"){
							;w month_"---"_dimId_"---"_value,!
							set ^TempkpiValueCurrent($j,month,dimId,kpiCode,"end")=value
						}
						if (type=""){
							set ^TempkpiValueCurrent($j,month,dimId,kpiCode)=value
						}
						
					}
					///上期的数据
					if (contractTye="PP"){
							if (type="start"){
								set ^TempkpiValuePP($j,month,dimId,kpiCode,"start")=value
							}
							if (type="end"){
								set ^TempkpiValuePP($j,month,dimId,kpiCode,"end")=value
							}
							if (type=""){
								set ^TempkpiValuePP($j,month,dimId,kpiCode)=value
								///如果当期值，不存在这个维度和日期
								if ('$data(^TempkpiValueCurrent($j,month,dimId,kpiCode))){
									set ^TempkpiValueCurrent($j,month,dimId,kpiCode)=0
								}
							}
					}
					///同期的数据
					if (contractTye="SL"){
						
						if (type="start"){
							set ^TempkpiValueSL($j,month,dimId,kpiCode,"start")=value
						}
						if (type="end"){
							;B ;22222444
							set ^TempkpiValueSL($j,month,dimId,kpiCode,"end")=value
						}
						if (type=""){
							set ^TempkpiValueSL($j,month,dimId,kpiCode)=value
							///如果当期值，不存在这个维度
							if ('$data(^TempkpiValueCurrent($j,month,dimId,kpiCode))){
								set ^TempkpiValueCurrent($j,month,dimId,kpiCode)=0
							}
						}
						
					}
				
										
		} 

				    
	q 0
}

/// //获取日期差，用于计算指标的平均值，
/// date 日期(中文的)、日期类型、类型（同期、上期）空代表本期
/// 返回日期差
/// w ##Class(DtPortal.Common.MKPIServiceCeshi).getDateNum("2018年05月","byMonth","PP")
ClassMethod getDateNum(date, dateType, contractTyeCurrent) As %String
{
	 new (date,dateType,contractTyeCurrent)
	 ;w date,!
	 set dateNum=0
	 
	 	if (dateType="byYear") {
			s qujianDate=$tr(date,"年","")
			if (contractTyeCurrent="SL")||(contractTyeCurrent="PP"){
				SET qujianDate=qujianDate-1 
			}
			set intervalStartDate=qujianDate_"-01"_"-01"
			set intervalendDate=qujianDate_"-12"_"-31"
			set sDateNum=$zdh(intervalStartDate,3)
			set endNum=$zdh(intervalendDate,3) ///获取结束日期的数字值
			if (endNum>=+$h){
				set intervalendDate=$zd(+$h-1,3) //获取当前日期前一天的数据
				set endNum=$zdh(intervalendDate,3)
			}
			if (sDateNum>endNum){
				set endNum=sDateNum ///如果是当前年，将结束日期定为当前日期
			}	
			set dateNum=endNum-sDateNum+1
			
		}
		if (dateType="byMonth") {
				
			s qujianDate=$tr(date,"年","-")
						
			s qujianDate=$tr(qujianDate,"月","")
					///上期值
			if (contractTyeCurrent="PP"){
					set tempMonth=$p(qujianDate,"-",2)
					if (tempMonth="01"){
						set qujianDate=($p(qujianDate,"-",1)-1)_"-12"
					}else{
						
						set qujianDate=$p(qujianDate,"-",1)_"-"_(tempMonth-1)
					}
					//SET qujianDate=qujianDate-1 
			}elseif (contractTyeCurrent="SL"){
				SET year=$p(qujianDate,"-",1)-1
				SET qujianDate=year_"-"_$p(qujianDate,"-",2)
			}
			       ;b ;222
					set intervalStartDate=qujianDate_"-01"
					///获取当前月的最后一天
					set intervalendDate=##Class(DtPortal.Common.PublicService).getLastDayOfMonth(qujianDate,1)
				
					set endNum=$zdh(intervalendDate,3) ///获取结束日期的数字值
					set sDateNum=$zdh(intervalStartDate,3)
					if (endNum>=+$h){
						set intervalendDate=$zd(+$h-1,3) //获取当前日期前一天的数据
						set endNum=$zdh(intervalendDate,3)
					}
					if (sDateNum>endNum){
						set endNum=sDateNum ///如果是当前年，将结束日期定为当前日期
			        }			
					set dateNum=endNum-sDateNum+1
				
			}
			if (dateType="byQua") {
					s qujianDate=$tr(date,"年","Q")
					s qujianDate=$tr(qujianDate,"季度","")
					///获取当前的季度值
					set year=$p(qujianDate,"Q",1) //所在年
					set num=$p(qujianDate,"Q",2)  ///所在季度
					if (contractTyeCurrent="PP"){
						//第一季度
						if (num="1"){
							set num=4
							set year=year-1
						}else{
							set num=num-1
						}
						
					}elseif (contractTyeCurrent="SL"){
						set year=year-1
						
					}
					//取季度的第一天
					set intervalStartDate=$CASE(num,1:year_"-01-01",2:year_"-04-01",3:year_"-07-01",4:year_"-10-01")
					///取季度的最后一天
					set intervalendDate=$CASE(num,1:year_"-03-31",2:year_"-06-30",3:year_"-09-30",4:year_"-12-31")
					;W intervalStartDate,intervalendDate,!
					set endNum=$zdh(intervalendDate,3) ///获取结束日期的数字值
					set sDateNum=$zdh(intervalStartDate,3)
					if (endNum>=+$h){
						set intervalendDate=$zd(+$h-1,3) //获取当前日期前一天的数据
						set endNum=$zdh(intervalendDate,3)
					}
					if (sDateNum>endNum){
						set endNum=sDateNum ///如果是当前年，将结束日期定为当前日期
			        }
					set dateNum=endNum-sDateNum+1			
					
					
			}
	 if (dateType="byDay") {
		 
		 set dateNum=1
	 }
				
					
					
	 q dateNum
}

/// //获取日期差，根据开始日期和结束日期去生成，本期、上期、同期的时间差
/// //w ##Class(DtPortal.Common.MKPIServiceCeshi).getDateNum2("2018-01-01","2018-01-01","byMonth","")
/// //w ##Class(DtPortal.Common.MKPIServiceCeshi).getDateNum2("2019-03-01","2019-03-31","byMonth","1")
ClassMethod getDateNum2(startDate, endDate, dateType, type, dateNum) As %String
{
	new (startDate, endDate, dateType,type,dateNum)
	 w dateType,type,dateNum,!
	set endNum=$zdh(endDate,3) ///获取结束日期的数字值
	set sDateNum=$zdh(startDate,3) ///
	if (dateType="byYear") {
		set startDate=$p(startDate,"-",1)_"-01-01"
		set endDate=$p(endDate,"-",1)_"-12-31"
		if (type="PP"){//上期
		    set startDate=$p(startDate,"-",1)-dateNum_"-01-01"
		     set endDate=$p(endDate,"-",1)-dateNum_"-12-31"
		}elseif(type="SL"){//同期
		    set startDate=$p(startDate,"-",1)-1_"-01-01"
		     set endDate=$p(endDate,"-",1)-1_"-12-31"
		}
		
	}
	if (dateType="byMonth") {
		set startDate=$p(startDate,"-",1)_"-"_$p(startDate,"-",2)_"-01"
		set endDate=##Class(DtPortal.Common.PublicService).getLastDayOfMonth(endDate,1)
		if (type="PP"){//上期
			set sDateNum=$zdh(startDate,3) ///获取开始日期的数字值
			set qujianDateStart=startDate
			set qujianDateEnd=endDate
		    for ppm=1:1:dateNum{
					set tempMonth=$p(qujianDateStart,"-",2)
					if (tempMonth="01"){
						set qujianDateStart=($p(qujianDateStart,"-",1)-1)_"-12"
					}else{
						set nowM=tempMonth-1
						if (nowM<10) set nowM="0"_nowM
						set qujianDateStart=$p(qujianDateStart,"-",1)_"-"_nowM
					}
					//结束日期的判断
					set tempMonthEnd=$p(qujianDateEnd,"-",2)
					if (tempMonthEnd="01"){
						set qujianDateEnd=($p(qujianDateEnd,"-",1)-1)_"-12"
					}else{
						set nowM=tempMonthEnd-1
						if (nowM<10) set nowM="0"_nowM
						set qujianDateEnd=$p(qujianDateEnd,"-",1)_"-"_nowM
					}
							
			}
			set startDate=qujianDateStart
			set endDate=qujianDateEnd
			//set sDateNum=sDateNum-1 ///开始日期向前推一个月
			//set startDate=$zd(sDateNum,3)
			set startDate=$p(startDate,"-",1)_"-"_$p(startDate,"-",2)_"-01"
			//set endDate=$p(endDate,"-",1)_"-"_$p(endDate,"-",2)_"-01"
			//set endNum=$zdh(endDate,3) ///获取结束日期的数字值
			//set endNum=endNum-1 ///开始日期向前推一个月
			set endDate=##Class(DtPortal.Common.PublicService).getLastDayOfMonth($zd(endNum,3),1)
			
		}elseif(type="SL"){//同期
			SET syear=$p(startDate,"-",1)-1
			SET startDate=syear_"-"_$p(startDate,"-",2)_"-01"
			SET eyear=$p(endDate,"-",1)-1
			SET endDate=eyear_"-"_$p(endDate,"-",2)_"-01"
			set endDate=##Class(DtPortal.Common.PublicService).getLastDayOfMonth(endDate,1)
		}
		
	}
	if (dateType="byQua") {
		SET yearS=$p(startDate,"-",1)
		set monthNumS=$p(startDate,"-",2)
	
		///当前日期所在的季度
		set ys=monthNumS#3
		if (ys=0){
			set currentQS=monthNumS\3
		}else{
			set currentQS=(monthNumS\3)+1
		}
		SET yearE=$p(endDate,"-",1)
		set monthNumE=$p(endDate,"-",2)
		///当前日期所在的季度
		set ys1=monthNumE#3
		if (ys1=0){
			set currentQE=monthNumE\3
		}else{
			set currentQE=(monthNumE\3)+1
		}
		//取季度的第一天
		set startDate=$CASE(currentQS,1:yearS_"-01-01",2:yearS_"-04-01",3:yearS_"-07-01",4:yearS_"-10-01")
		///取季度的最后一天
		set endDate=$CASE(currentQE,1:yearE_"-03-31",2:yearE_"-06-30",3:yearE_"-09-30",4:yearE_"-12-31")
		if (type="PP"){//上期
		   ///如果是第一个季度，则推到上年的第四个季度
		   

			set qujianDateStart=yearS_"Q"_currentQS
		    set qujianDateEnd=yearE_"Q"_currentQE
			for ppm=1:1:dateNum{
						set tempQ=$p(qujianDateStart,"Q",2)
						if (tempQ="1"){
							set qujianDateStart=($p(qujianDateStart,"Q",1)-1)_"Q4"
						}else{
							set nowM=tempQ-1
							set qujianDateStart=$p(qujianDateStart,"Q",1)_"Q"_nowM
						}
						//结束日期的判断
						set tempQEnd=$p(qujianDateEnd,"Q",2)
						if (tempQEnd="1"){
							set qujianDateEnd=($p(qujianDateEnd,"Q",1)-1)_"Q4"
						}else{
							set nowM=tempQEnd-1
							set qujianDateEnd=$p(qujianDateEnd,"Q",1)_"Q"_nowM
						}
								
			}
			;w qujianDateStart,"33333",!
			set currentQS=$p(qujianDateStart,"Q",2)
			set yearS=$p(qujianDateStart,"Q",1)
			set currentQE=$p(qujianDateEnd,"Q",2)
			set yearE=$p(qujianDateEnd,"Q",1)
			W currentQS,currentQE,!
			set startDate=$CASE(currentQS,1:yearS_"-01-01",2:yearS_"-04-01",3:yearS_"-07-01",4:yearS_"-10-01")
			///取季度的最后一天
			set endDate=$CASE(currentQE,1:yearE_"-03-31",2:yearE_"-06-30",3:yearE_"-09-30",4:yearE_"-12-31")
		}elseif(type="SL"){//同期
		     set yearS=yearS-1
		     set yearE=yearE-1
		     set startDate=$CASE(currentQS,1:yearS_"-01-01",2:yearS_"-04-01",3:yearS_"-07-01",4:yearS_"-10-01")
			  ///取季度的最后一天
			 set endDate=$CASE(currentQE,1:yearE_"-03-31",2:yearE_"-06-30",3:yearE_"-09-30",4:yearE_"-12-31")
		}
		
	}
	;w startDate,endDate,!
	set endNum=$zdh(endDate,3) ///获取结束日期的数字值
	set sDateNum=$zdh(startDate,3) ///
	
	if (dateType="byDay") {
		set endNum=$zdh(endDate,3) ///获取结束日期的数字值
		set sDateNum=$zdh(startDate,3)
	}
	if (endNum>=+$h){
		set intervalendDate=$zd(+$h-1,3) //获取当前日期前一天的数据
		set endNum=$zdh(intervalendDate,3)
	}
	if (sDateNum>endNum){
		set endNum=sDateNum 
	}
	set dateNum=endNum-sDateNum+1
	q dateNum
}

/// 取上一个季度的值
/// //w ##Class(DtPortal.Common.MKPIServiceCeshi).getPPDate("2019年01月01日","byDay")
/// //w ##Class(DtPortal.Common.MKPIServiceCeshi).getPPDate("2019年","byYear")
/// //w ##Class(DtPortal.Common.MKPIServiceCeshi).getPPDate("2019年02月","byMonth")
/// //w ##Class(DtPortal.Common.MKPIServiceCeshi).getPPDate("2019年1季度","byQua")
ClassMethod getPPDate(date, dateType) As %String
{
	 new (date,dateType)
	 set dateNum=0
	 SET ppDate=date
	 	if (dateType="byYear") {
			s qujianDate=$tr(date,"年","")
			SET qujianDate=qujianDate-1
			SET ppDate=qujianDate_"年"
			
		}
		if (dateType="byMonth") {
				
			s qujianDate=$tr(date,"年","-")
						
			s qujianDate=$tr(qujianDate,"月","")
			set tempMonth=$p(qujianDate,"-",2)
			if (tempMonth="01"){
				set qujianDate=($p(qujianDate,"-",1)-1)_"-12"
			}else{
				set nowM=tempMonth-1
				if (nowM<10) set nowM="0"_nowM
				set qujianDate=$p(qujianDate,"-",1)_"-"_nowM
			}
			SET ppDate=$p(qujianDate,"-",1)_"年"_$p(qujianDate,"-",2)_"月"
				
		}
		if (dateType="byQua") {
			s qujianDate=$tr(date,"年","Q")
			s qujianDate=$tr(qujianDate,"季度","")
			///获取当前的季度值
			set year=$p(qujianDate,"Q",1) //所在年
			set num=$p(qujianDate,"Q",2)  ///所在季度
			
			//第一季度
			if (num="1"){
				set num=4
				set year=year-1
				}else{
				set num=num-1
			}
						
			SET ppDate=	year_"年"_num_"季度"
					
					
	   }
	 if (dateType="byDay") {
		 s qujianDate=$tr(date,"年","-")
						
		s qujianDate=$tr(qujianDate,"月","-")
		s qujianDate=$tr(qujianDate,"日","")
		set dateNum=$zdh(qujianDate,3)
		set dateNum=dateNum-1
		s qujianDate=$zd(dateNum,3)
		SET ppDate=$p(qujianDate,"-",1)_"年"_$p(qujianDate,"-",2)_"月"_$p(qujianDate,"-",3)_"日"
	 }
				
					
					
	 q ppDate
}

/// /读取 query的入参和出参 add by zhaoli
/// w ##class(DtPortal.Common.MKPIService).readParam("DtPortal.Common.PublicService","GetWsgAuthenticationData")
ClassMethod readParam(clsName As %String, queryName As %String) As %String
{
    set qdf=##class(%Dictionary.QueryDefinition).%OpenId(clsName_"||"_queryName)
	s err="{""status"":""-1"",""errMSG"":""("_clsName_")."_queryName_" was not found"""_",""total"":""0"",""data"":[]}"
	;s objErr="{""status"":""-1"",""errMSG"":""("_clsName_")."_methodName_" 's return value is not an object """_",""total"":""0"",""data"":[]}"
	set output=""
	set paras=""
	///是否query的判断，如果是query的进入query的公式
	if $IsObject(qdf){
	set paras=qdf.FormalSpec
	set:paras="" parasCount=0
	set:paras'="" parasCount=$l(paras,",")
	set rs=##class(%ResultSet).%New(clsName_":"_queryName)
	quit:'$IsObject(rs) err
	For i = 1:1:rs.GetColumnCount()
	{   
	set filedName=rs.GetColumnName(i)
	if i=1 set output=filedName 
	else  set output=output_","_filedName 

	}
	}else{
	s mdf=##class(%Dictionary.CompiledMethod).%OpenId(clsName_"||"_queryName)
	    quit:'$IsObject(mdf) err
	    set paras=mdf.FormalSpec
	}
	set jsonObj = ##class(DtPortal.Common.JsonObject).%New()
	d jsonObj.Put("params",paras)
	d jsonObj.Put("output",output)

	Set ret = ##class(DtPortal.OutPut).%New()
	set ret.status=1
	set ret.data=jsonObj.Json()

	q ret
}

}
