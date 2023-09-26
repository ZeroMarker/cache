Class web.DHCBL.KB.DHCPHDiseaseUse Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2014-12-3
/// Description：查询给药途径表内容
/// Table：User.DHCPHDiseaseUse
/// Input：rowid
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHDiseaseUse","GetList","2","1","FORM","1")
Query GetList(TypeDr, GenDr, PointerType, PointerDr) As %Query(ROWSPEC = "PDIRowId,PDIInstDr,PDIUseDR,PHEINCode,PHEINDesc,PHINSTMode,PDIExcludeFlag,PDAAgeDr,PDAAgeDesc,PDAMinVal,PDAMaxVal,PDAUomDr,PHEUDesc,PDIAlertMsg")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, TypeDr, GenDr, PointerType, PointerDr) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s TypeDr=$o(^DHCPHPINL("0","Code","PREMET",0))
	//s:PointerType'="" PointerType=$zcvt(PointerType,"U")
	s PDIInstDr=0
	for{
		s PDIInstDr=$o(^DHCPHINSTRUC("0","TGP",TypeDr,GenDr,PointerType,PointerDr,PDIInstDr))	q:PDIInstDr=""

		s PHINSTMode = $p($g(^DHCPHINSTRUC(PDIInstDr)),"^",14) //管制级别
		s PDIRowId = $o(^DHCPHDISUSE("0","Inst",PDIInstDr,0))  continue:PDIRowId=""
		s PDIUseDR=$p($g(^DHCPHDISUSE(PDIRowId)),"^",2)  //给药途径Dr
		s:PDIUseDR'="" PHEINCode=$p($g(^DHCPHEINSTR(PDIUseDR)),"^",1) //方法代码 
		s:PDIUseDR'="" PHEINDesc=$p($g(^DHCPHEINSTR(PDIUseDR)),"^",2) //方法名称 
		s PDIExcludeFlag=$p($g(^DHCPHDISUSE(PDIRowId)),"^",3)  //禁忌
		s PDIAlertMsg=$p($g(^DHCPHDISUSE(PDIRowId)),"^",4)  //提示消息
		s PDARowId = $o(^DHCPHDISAGE("0","Inst",PDIInstDr,0)) //continue:PDARowId=""
		if (PDARowId'=""){
			s PDAAgeDr = $p($g(^DHCPHDISAGE(PDARowId)),"^",2) //年龄Dr 
			s:PDAAgeDr'="" PDAAgeDesc=$p($g(^DHCPHPAGEL(PDAAgeDr)),"^",2) //年龄描述
			s:PDAAgeDr="" PDAAgeDesc="" //年龄描述
			s PDAMinVal = $p($g(^DHCPHDISAGE(PDARowId)),"^",3) //年龄限制最小值
			s PDAMaxVal = $p($g(^DHCPHDISAGE(PDARowId)),"^",4) //年龄限制最大值
			s PDAUomDr = $p($g(^DHCPHDISAGE(PDARowId)),"^",5) //年龄单位
			s:PDAUomDr'="" PHEUDesc=$p($g(^DHCPHEUO(PDAUomDr)),"^",2)  //年龄单位描述
			s:PDAUomDr="" PHEUDesc="" //年龄单位描述
		}
		
		d OutputRow
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PDIRowId,PDIInstDr,PDIUseDR,PHEINCode,PHEINDesc,PHINSTMode,PDIExcludeFlag,PDAAgeDr,PDAAgeDesc,PDAMinVal,PDAMaxVal,PDAUomDr,PHEUDesc,PDIAlertMsg)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
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

/// Creator：丁亚男
/// CreatDate: 2018-9-4
/// Description：查询给药途径表内容
/// Table：User.DHCPHDiseaseUse
/// Input：rowid
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHDiseaseUse","GetListNew","","16","Form","2","口服")
Query GetListNew(TypeDr, GenDr, PointerType, PointerDr, desc) As %Query(ROWSPEC = "PDIRowId,PDIInstDr,PDIUseDR,PHEINDescF,PHEINDesc,PHINSTModeF,PHINSTMode,PDIExcludeFlagF,PDIExcludeFlag,PDAAgeDrF,PDAAgeDr,PDAMinVal,PDAMaxVal,PDAUomDrF,PDAUomDr,PDIAlertMsg")
{
}

ClassMethod GetListNewExecute(ByRef qHandle As %Binary, TypeDr, GenDr, PointerType, PointerDr, desc) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s TypeDr=$o(^DHCPHPINL("0","Code","PREMET",0))
	//s:PointerType'="" PointerType=$zcvt(PointerType,"U")
	s PDIInstDr=0
	for{
		s PDIInstDr=$o(^DHCPHINSTRUC("0","TGP",TypeDr,GenDr,PointerType,PointerDr,PDIInstDr))	q:PDIInstDr=""

		s PHINSTModeF = $p($g(^DHCPHINSTRUC(PDIInstDr)),"^",14) //管制级别
		s PHINSTMode=PHINSTModeF
		s PDIRowId = $o(^DHCPHDISUSE("0","Inst",PDIInstDr,0))  continue:PDIRowId=""
		s PDIUseDR=$p($g(^DHCPHDISUSE(PDIRowId)),"^",2)  //给药途径Dr
		s PHEINDescF=PDIUseDR
		s:PDIUseDR'="" PHEINCode=$p($g(^DHCPHEINSTR(PDIUseDR)),"^",1) //方法代码 
		s:PDIUseDR'="" PHEINDesc=$p($g(^DHCPHEINSTR(PDIUseDR)),"^",2) //方法名称 
		s PDIExcludeFlagF=$p($g(^DHCPHDISUSE(PDIRowId)),"^",3)  //禁忌
		s PDIExcludeFlag=PDIExcludeFlagF
		s PDIAlertMsg=$p($g(^DHCPHDISUSE(PDIRowId)),"^",4)  //提示消息
		s PDARowId = $o(^DHCPHDISAGE("0","Inst",PDIInstDr,0)) //continue:PDARowId=""
		if (PDARowId'=""){
			s PDAAgeDrF = $p($g(^DHCPHDISAGE(PDARowId)),"^",2) //年龄Dr 
			s:PDAAgeDrF'="" PDAAgeDr=$p($g(^DHCPHPAGEL(PDAAgeDrF)),"^",2) //年龄描述
			s:PDAAgeDrF="" PDAAgeDr="" //年龄描述
			s PDAMinVal = $p($g(^DHCPHDISAGE(PDARowId)),"^",3) //年龄限制最小值
			s PDAMaxVal = $p($g(^DHCPHDISAGE(PDARowId)),"^",4) //年龄限制最大值
			s PDAUomDrF = $p($g(^DHCPHDISAGE(PDARowId)),"^",5) //年龄单位
			s:PDAUomDrF'="" PDAUomDr=$p($g(^DHCPHEUO(PDAUomDrF)),"^",2)  //年龄单位描述
			s:PDAUomDrF="" PDAUomDr="" //年龄单位描述
		}
		s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
		s PHEINDesc1=$$ALPHAUP^SSUTIL4(PHEINDesc)
		if (PHEINDesc1[desc){
			d OutputRow
		}
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PDIRowId,PDIInstDr,PDIUseDR,PHEINDescF,PHEINDesc,PHINSTModeF,PHINSTMode,PDIExcludeFlagF,PDIExcludeFlag,PDAAgeDrF,PDAAgeDr,PDAMinVal,PDAMaxVal,PDAUomDrF,PDAUomDr,PDIAlertMsg)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListNewExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetListNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListNewExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
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

/// Creator:高姗姗
/// CreatDate: 2014-12-3
/// Description：保存给药途径
/// Table：User.DHCPHDiseaseUse    User.DHCPHInstructions
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(useStr As %String) As %String
{
 if (useStr'=""){
	s result = ""
	s uselen=$Length(useStr,"*")
	for i=1:1:uselen
	{
		s use=$p(useStr,"*",i)
		s PDIUseDR=$p(use,"^",1) //频率字典id
		s Mode=$p(use,"^",2) //管制级别
		s Type=$p(use,"^",3) //知识库目录
		s OrderNum=$p(use,"^",4) //顺序
		s Gen=$p(use,"^",5) //通用名
		s Pointer=$p(use,"^",6) //指针
		s PointerType=$p(use,"^",7) //指针类型
		s Lib=$p(use,"^",8) //知识库标识
		s ActiveFlag=$p(use,"^",9) //是否可用
		s SysFlag=$p(use,"^",10) //是否系统标识
		s ExcludeFlag=$p(use,"^",11) //禁忌
		s Age=$p(use,"^",12) //年龄
		s MinVal=$p(use,"^",13) //年龄限制最小值
		s MaxVal=$p(use,"^",14) //年龄限制最大值
		s UomDr=$p(use,"^",15) //年龄单位
		s PDIAlertMsg=$p(use,"^",16) //提示消息
	/*
	s TypeDr=$o(^DHCPHPINL("0","Code","PREMET",0))
	s PDIInstDr=0
	s UseDRs = ""
	s AgeDrs = ""
	for{
		s PDIInstDr=$o(^DHCPHINSTRUC("0","TGP",TypeDr,Gen,PointerType,Pointer,PDIInstDr))	q:PDIInstDr=""
		s PDIRowId = $o(^DHCPHDISUSE("0","Inst",PDIInstDr,0))  continue:PDIRowId=""
		s UseDR=$p($g(^DHCPHDISUSE(PDIRowId)),"^",2)  //给药途径Dr
		s UseDRs="<"_UseDR_">,"_UseDRs
		if (PDIUseDR=UseDR){
			s PDARowId = $o(^DHCPHDISAGE("0","Inst",PDIInstDr,0)) 
			if (PDARowId'=""){
				s PDAAgeDr = $p($g(^DHCPHDISAGE(PDARowId)),"^",2) //年龄Dr 
				s AgeDrs = "<"_PDAAgeDr_">,"_AgeDrs
			}
		}
	}
	s UseDRa = "<"_PDIUseDR_">"
	s AgeDr = "<"_Age_">"
	if (UseDRs[UseDRa)&&(AgeDrs[AgeDr) Quit "{success:'false',info:'该记录已存在'}"
	*/
	;主索引表
	Ts
	s sobj=##class(User.DHCPHInstructions).%New()
	
	s sobj.PHINSTMode=Mode
	s TypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT(Type,"U"),0))
	d:TypeDr'="" sobj.PHINSTTypeDrSetObjectId(TypeDr)
	s sobj.PHINSTOrderNum=OrderNum
	//d:Gen'="" sobj.PHINSTGenDrSetObjectId(Gen)
	s:Gen'="" sobj.PHINSTGenDr=Gen
	s sobj.PHINSTPointerDr=Pointer
	s sobj.PHINSTPointerType=PointerType
	s LibDr=$o(^DHCPHLIBL(0,"Code",$ZCONVERT(Lib,"U"),0))
	d:LibDr'="" sobj.PHINSTLibDrSetObjectId(LibDr)
	s sobj.PHINSTActiveFlag=ActiveFlag
	s sobj.PHINSTSysFlag=SysFlag
	s sobj.PHINSTText=PDIAlertMsg
	;给药途径主索引json
	s slogJson="PHINSTMode:"_$C(34)_Mode_$C(34)_",PHINSTTypeDr:"_$C(34)_TypeDr_$C(34)_",PHINSTOrderNum:"_$C(34)_OrderNum_$C(34)_",PHINSTGenDr:"_$C(34)_Gen_$C(34)_",PHINSTPointerDr:"_$C(34)_Pointer_$C(34)_",PHINSTPointerType:"_$C(34)_PointerType_$C(34)_",PHINSTLibDr:"_$C(34)_LibDr_$C(34)_",PHINSTActiveFlag:"_$C(34)_ActiveFlag_$C(34)_",PHINSTSysFlag:"_$C(34)_SysFlag_$C(34)_",PHINSTText:"_$C(34)_PDIAlertMsg_$C(34)
	
	s scs=sobj.%Save()
	d sobj.%Close()
	If $$$ISOK(scs){ 
		s sid = sobj.%Id()
		;d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHInstructions","User.DHCPHInstructions","给药途径主索引",sid,Mode,"A",slogJson)	
	}
	else{
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scs)_"_'}"    //返回错误信息
	}
	;年龄表
	s aobj=##class(User.DHCPHDiseaseAge).%New()
	d:sid'="" aobj.PDAInstDrSetObjectId(sid)
	d:Age'="" aobj.PDAAgeDrSetObjectId(Age)
	s aobj.PDAMinVal=MinVal
	s aobj.PDAMaxVal=MaxVal
	d:UomDr'="" aobj.PDAUomDrSetObjectId(UomDr)
	;年龄json
	s alogJson="PDAAgeDr:"_$c(34)_Age_$C(34)_",PDAInstDr:"_$C(34)_sid_$C(34)_",PDAMinVal:"_$c(34)_MinVal_$c(34)_",PDAMaxVal:"_$c(34)_MaxVal_$c(34)_",PDAUomDr:"_$c(34)_UomDr_$c(34)
	s sca=aobj.%Save()
	d aobj.%Close()
	If $$$ISOK(sca){ 
		s aid = aobj.%Id()
		;d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHDiseaseAge","User.DHCPHDiseaseAge","年龄",aid,Age,"A",alogJson)	
	}
	else{
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sca)_"_'}"    //返回错误信息
	}
	
	;给药途径表
	s obj=##class(User.DHCPHDiseaseUse).%New()
	d:PDIUseDR'="" obj.PDIUseDRSetObjectId(PDIUseDR)
	s PHEINDesc=""
	s:PDIUseDR'="" PHEINDesc=$p($g(^DHCPHEINSTR(PDIUseDR)),"^",2) //方法名称 
	
	d:sid'="" obj.PDIInstDrSetObjectId(sid)
	i ExcludeFlag="true"
	{
		s obj.PDIExcludeFlag = "Y"
	}
	else
	{
		s obj.PDIExcludeFlag = "N"
	}
	s obj.PDIAlertMsg=PDIAlertMsg
	;给药途径json
	s ulogJson="PDIUseDR:"_$c(34)_PDIUseDR_$C(34)_",PDIInstDr:"_$C(34)_sid_$C(34)_",PDIExcludeFlag:"_$c(34)_obj.PDIExcludeFlag_$c(34)_",PDIAlertMsg:"_$c(34)_obj.PDIAlertMsg_$c(34)
	s logJson="{"_ulogJson_","_alogJson_","_slogJson_"}"
	
	s sc=obj.%Save()
	d obj.%Close()	
	
	If $$$ISOK(sc){
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}"    
		//d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHDiseaseUse","User.DHCPHDiseaseUse","药品说明书编辑器给药途径",id,PHEINDesc,"A",logJson)
	    //d:SSUSRRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHDiseaseUse","User.DHCPHDiseaseUse","给药途径",SSUSRRowId,SSUSRName,"U",logJson,blogJson)
	}
	else{
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"_'}"    //返回错误信息
	}
				
   	if (result["true"){
		Tc
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHInstructions","User.DHCPHInstructions","药品说明书编辑器-给药途径",sid,PHEINDesc,"A",logJson)
	}
	else{
		Trollback
		s result="{success:'false',info:'保存失败'}"
	}	
	}
	q result
 }
}

/// Creator:丁亚男
/// CreatDate: 2018-09-30 
/// Description：修改给药途径
/// Table：User.DHCPHDiseaseUse    User.DHCPHInstructions
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHDiseaseUse).UpdateData("5^C^PREMET^0^16^2^Form^DRUG^Y^Y^N^4^18^120^8^^63")
ClassMethod UpdateData(useStr As %String) As %String
{
	if (useStr'=""){
		s result = ""
		s uselen=$Length(useStr,"*")
		for i=1:1:uselen
		{
			s use=$p(useStr,"*",i)
			s PDIUseDR=$p(use,"^",1) //频率字典id
			s Mode=$p(use,"^",2) //管制级别
			s Type=$p(use,"^",3) //知识库目录
			s OrderNum=$p(use,"^",4) //顺序
			s Gen=$p(use,"^",5) //通用名
			s Pointer=$p(use,"^",6) //指针
			s PointerType=$p(use,"^",7) //指针类型
			s Lib=$p(use,"^",8) //知识库标识
			s ActiveFlag=$p(use,"^",9) //是否可用
			s SysFlag=$p(use,"^",10) //是否系统标识
			s ExcludeFlag=$p(use,"^",11) //禁忌
			s Age=$p(use,"^",12) //年龄
			s MinVal=$p(use,"^",13) //年龄限制最小值
			s MaxVal=$p(use,"^",14) //年龄限制最大值
			s UomDr=$p(use,"^",15) //年龄单位
			s PDIAlertMsg=$p(use,"^",16) //提示消息
			s InstDr=$p(use,"^",17) //主索引表id
			
			Ts
			
			s PHDDInstDr=InstDr
			
			//修改主索引表	
			s sobj=##class(User.DHCPHInstructions).%OpenId(PHDDInstDr)
			s bobj=##class(web.Entity.KB.DHCPHInstructions).%New()
			s bobj.PHINSTRowId=PHDDInstDr
			s bobj.PHINSTMode=sobj.PHINSTMode
			s:sobj.PHINSTTypeDr'="" bobj.PHINSTTypeDr = sobj.PHINSTTypeDr.%Id()
			s bobj.PHINSTOrderNum=sobj.PHINSTOrderNum	
			s bobj.PHINSTGenDr = sobj.PHINSTGenDr
			s bobj.PHINSTPointerDr=sobj.PHINSTPointerDr
			s bobj.PHINSTPointerType=sobj.PHINSTPointerType
			s:sobj.PHINSTLibDr'="" bobj.PHINSTLibDr = sobj.PHINSTLibDr.%Id()
			s bobj.PHINSTActiveFlag=sobj.PHINSTActiveFlag
			s bobj.PHINSTSysFlag=sobj.PHINSTSysFlag
			s bobj.PHINSTText=sobj.PHINSTText
			
			
			s sobj.PHINSTMode=Mode
			s TypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT(Type,"U"),0))
			d:TypeDr'="" sobj.PHINSTTypeDrSetObjectId(TypeDr)
			s sobj.PHINSTOrderNum=OrderNum
			//d:Gen'="" sobj.PHINSTGenDrSetObjectId(Gen)
			s:Gen'="" sobj.PHINSTGenDr=Gen
			s sobj.PHINSTPointerDr=Pointer
			s sobj.PHINSTPointerType=PointerType
			s LibDr=$o(^DHCPHLIBL(0,"Code",$ZCONVERT(Lib,"U"),0))
			d:LibDr'="" sobj.PHINSTLibDrSetObjectId(LibDr)
			s sobj.PHINSTActiveFlag=ActiveFlag
			s sobj.PHINSTSysFlag=SysFlag
			s sobj.PHINSTText=PDIAlertMsg
			;给药途径主索引json
			s slogJson="PHINSTMode:"_$C(34)_Mode_$C(34)_",PHINSTTypeDr:"_$C(34)_TypeDr_$C(34)_",PHINSTOrderNum:"_$C(34)_OrderNum_$C(34)_",PHINSTGenDr:"_$C(34)_Gen_$C(34)_",PHINSTPointerDr:"_$C(34)_Pointer_$C(34)_",PHINSTPointerType:"_$C(34)_PointerType_$C(34)_",PHINSTLibDr:"_$C(34)_LibDr_$C(34)_",PHINSTActiveFlag:"_$C(34)_ActiveFlag_$C(34)_",PHINSTSysFlag:"_$C(34)_SysFlag_$C(34)_",PHINSTText:"_$C(34)_PDIAlertMsg_$C(34)
			s oslogJson="PHINSTMode:"_bobj.PHINSTMode_$C(34)_",PHINSTTypeDr:"_$C(34)_bobj.PHINSTTypeDr_$C(34)_",PHINSTOrderNum:"_$C(34)_bobj.PHINSTOrderNum_$C(34)_",PHINSTGenDr:"_$C(34)_bobj.PHINSTGenDr_$C(34)_",PHINSTPointerDr:"_$C(34)_bobj.PHINSTPointerDr_$C(34)_",PHINSTPointerType:"_$C(34)_bobj.PHINSTPointerType_$C(34)_",PHINSTLibDr:"_$C(34)_bobj.PHINSTLibDr_$C(34)_",PHINSTActiveFlag:"_$C(34)_bobj.PHINSTActiveFlag_$C(34)_",PHINSTSysFlag:"_$C(34)_bobj.PHINSTSysFlag_$C(34)_",PHINSTText:"_$C(34)_bobj.PHINSTText_$C(34)
			
			s scIns=sobj.%Save()	
			d sobj.%Close()
			If $$$ISOK(scIns)
			{
				s Insid = sobj.%Id()
				;d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHInstructions","User.DHCPHInstructions","给药途径主索引",Insid,Mode,"U",slogJson)	

			}
			else
			{
				s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scIns)_"_'}"    //返回错误信息
			}
			
			//修改年龄业务表
			//通过索引获取年龄业务表的RowId——PDARowId
			s alogJson="PDAAgeDr:"""",PDAInstDr:"""",PDAMinVal:"""",PDAMaxVal:"""",PDAUomDr:"""""
			s oalogJson="PDAAgeDr:"""",PDAInstDr:"""",PDAMinVal:"""",PDAMaxVal:"""",PDAUomDr:"""""
			s PDARowId=$o(^DHCPHDISAGE(0,"Inst",PHDDInstDr,0))
			if (PDARowId'="")
			{
					
			  	s objAge = ##class(User.DHCPHDiseaseAge).%OpenId(PDARowId)
			  	s bobjAge=##class(web.Entity.KB.DHCPHDiseaseAge).%New()
		  		s bobjAge.PDARowId=PDARowId
		  		s:objAge.PDAInstDr'="" bobjAge.PDAInstDr = objAge.PDAInstDr.%Id()
		  		s:objAge.PDAAgeDr'="" bobjAge.PDAAgeDr = objAge.PDAAgeDr.%Id()
		  		
		  		s bobjAge.PDAMinVal=objAge.PDAMinVal
		  		s bobjAge.PDAMaxVal=objAge.PDAMaxVal
		  		s:objAge.PDAUomDr'="" bobjAge.PDAUomDr = objAge.PDAUomDr.%Id()
		  		
				d:Age'="" objAge.PDAAgeDrSetObjectId(Age)
				s objAge.PDAMinVal=MinVal
				s objAge.PDAMaxVal=MaxVal
				d:UomDr'="" objAge.PDAUomDrSetObjectId(UomDr)
				;年龄json
				s alogJson="PDAAgeDr:"_$c(34)_Age_$C(34)_",PDAInstDr:"_$C(34)_PHDDInstDr_$C(34)_",PDAMinVal:"_$c(34)_MinVal_$c(34)_",PDAMaxVal:"_$c(34)_MaxVal_$c(34)_",PDAUomDr:"_$c(34)_UomDr_$c(34)
				s oalogJson="PDAAgeDr:"_$c(34)_bobjAge.PDAAgeDr_$C(34)_",PDAInstDr:"_$C(34)_bobjAge.PDAInstDr_$C(34)_",PDAMinVal:"_$c(34)_bobjAge.PDAMinVal_$c(34)_",PDAMaxVal:"_$c(34)_bobjAge.PDAMaxVal_$c(34)_",PDAUomDr:"_$c(34)_bobjAge.PDAUomDr_$c(34)

				s scAge=objAge.%Save()
				d objAge.%Close()
			
				if $$$ISOK(scAge)
				{
					s ageId=objAge.%Id()
					;d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHDiseaseAge","User.DHCPHDiseaseAge","年龄",ageId,Age,"U",alogJson)	
				}
				else{
					s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scAge)_"_'}"    //返回错误信息
				}
			}
			elseif ((PDARowId="")&(Age'=""))
			{
			 	
			 	s objAge = ##class(User.DHCPHDiseaseAge).%New()
			 	d objAge.PDAInstDrSetObjectId(PHDDInstDr)	
			 	d:Age'="" objAge.PDAAgeDrSetObjectId(Age)
				s objAge.PDAMinVal=MinVal
				s objAge.PDAMaxVal=MaxVal
				d:UomDr'="" objAge.PDAUomDrSetObjectId(UomDr)
				;年龄json 
				s alogJson="PDAAgeDr:"_$c(34)_Age_$C(34)_",PDAInstDr:"_$C(34)_PHDDInstDr_$C(34)_",PDAMinVal:"_$c(34)_MinVal_$c(34)_",PDAMaxVal:"_$c(34)_MaxVal_$c(34)_",PDAUomDr:"_$c(34)_UomDr_$c(34)
				//s oalogJson="PDAAgeDr:"""",PDAInstDr:"""",PDAMinVal:"""",PDAMaxVal:"""",PDAUomDr:"""""
				s scAge=objAge.%Save()
				d objAge.%Close()
			
				if $$$ISOK(scAge)
				{
					s ageId=objAge.%Id()
					;d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHDiseaseAge","User.DHCPHDiseaseAge","年龄",ageId,Age,"U",alogJson,oalogJson)	
				}
				else{
					s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scAge)_"_'}"    //返回错误信息
				}
			 	
			}
			
			//修改用给药途径业务表
			//通过索引获取给药途径业务表的RowId——PDFRowId
			s ulogJson="PDIUseDR:"""",PDIInstDr:"""",PDIExcludeFlag:"""",PDIAlertMsg:"""""
			s oulogJson="PDIUseDR:"""",PDIInstDr:"""",PDIExcludeFlag:"""",PDIAlertMsg:"""""
			s PDIRowId=$o(^DHCPHDISUSE("0","Inst",PHDDInstDr,0))
			if (PDIRowId'="")
			{
				s objUse = ##class(User.DHCPHDiseaseUse).%OpenId(PDIRowId)
				s bobjUse=##class(web.Entity.KB.DHCPHDiseaseUse).%New()
				s bobjUse.PDIRowId=PDIRowId
				s:objUse.PDIInstDr'="" bobjUse.PDIInstDr = objUse.PDIInstDr.%Id()
				s:objUse.PDIUseDR'="" bobjUse.PDIUseDR = objUse.PDIUseDR.%Id()
				s bobjUse.PDIExcludeFlag=objUse.PDIExcludeFlag
				s bobjUse.PDIAlertMsg=objUse.PDIAlertMsg
				i ExcludeFlag="true"
				{
					s ExcludeFlag = "Y"
				}
				else
				{
					s ExcludeFlag = "N"
				}
				
				d:PDIUseDR'="" objUse.PDIUseDRSetObjectId(PDIUseDR)
				s PHEINDesc=""
				s:PDIUseDR'="" PHEINDesc=$p($g(^DHCPHEINSTR(PDIUseDR)),"^",2) //方法名称
				 
				s objUse.PDIExcludeFlag=ExcludeFlag
				s objUse.PDIAlertMsg=PDIAlertMsg
				
				s ulogJson="PDIUseDR:"_$c(34)_PDIUseDR_$C(34)_",PDIInstDr:"_$C(34)_PHDDInstDr_$C(34)_",PDIExcludeFlag:"_$c(34)_objUse.PDIExcludeFlag_$c(34)_",PDIAlertMsg:"_$c(34)_objUse.PDIAlertMsg_$c(34)
				s oulogJson="PDIUseDR:"_$c(34)_bobjUse.PDIUseDR_$C(34)_",PDIInstDr:"_$C(34)_bobjUse.PDIInstDr_$C(34)_",PDIExcludeFlag:"_$c(34)_bobjUse.PDIExcludeFlag_$c(34)_",PDIAlertMsg:"_$c(34)_bobjUse.PDIAlertMsg_$c(34)
				
				
				
				s scUse=objUse.%Save()
				d objUse.%Close()
			
				if $$$ISOK(scUse)
				{
					s UseId=objUse.%Id()
					//d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHDiseaseUse","User.DHCPHDiseaseUse","药品说明书编辑器给药途径",UseId,PHEINDesc,"U",logJson,ologJson)
	    
				}
				else
				{
					s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scUse)_"_'}" 
				}
				
			}
			elseif(PDIRowId="")&(PDIUseDR'="")
			{
				;给药途径表
				s obj=##class(User.DHCPHDiseaseUse).%New()
				d:PDIUseDR'="" obj.PDIUseDRSetObjectId(PDIUseDR)
				s PHEINDesc=""
				s:PDIUseDR'="" PHEINDesc=$p($g(^DHCPHEINSTR(PDIUseDR)),"^",2) //方法名称 
				
				d:sid'="" obj.PDIInstDrSetObjectId(sid)
				i ExcludeFlag="true"
				{
					s obj.PDIExcludeFlag = "Y"
				}
				else
				{
					s obj.PDIExcludeFlag = "N"
				}
				s obj.PDIAlertMsg=PDIAlertMsg
				;给药途径json
				s ulogJson="PDIUseDR:"_$c(34)_PDIUseDR_$C(34)_",PDIInstDr:"_$C(34)_sid_$C(34)_",PDIExcludeFlag:"_$c(34)_obj.PDIExcludeFlag_$c(34)_",PDIAlertMsg:"_$c(34)_obj.PDIAlertMsg_$c(34)
				s oulogJson="PDIUseDR:"""",PDIInstDr:"""",PDIExcludeFlag:"""",PDIAlertMsg:"""""

			}
			s logJson="{"_ulogJson_","_alogJson_","_slogJson_"}"
			s ologJson="{"_oulogJson_","_oalogJson_","_oslogJson_"}"
			
			if (result["false")
			{
				Trollback
				s result = "{success:'false',errorinfo:'保存失败'}"
				
			}
			else
			{
				Tc
				s result = "{success:'true',id:'"_PHDDInstDr_"'}" //返回RowId
				d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHInstructions","User.DHCPHInstructions","药品说明书编辑器-给药途径",Insid,PHEINDesc,"U",logJson,ologJson)

			}
		}
		q result		
	}
}

/// Creator:高姗姗
/// CreatDate:2014-12-4
/// Description:根据id删除
/// Table:User.DHCPHDiseaseUse
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCPHDiseaseUse).DeleteData("211")
ClassMethod DeleteData(id As %String) As %String
{
	s return="",myInfo=""
	
		s pobj = ##class(User.DHCPHDiseaseUse).%OpenId(id)
		
		;年龄表
		s PDARowId=$o(^DHCPHDISAGE(0,"Inst",pobj.PDIInstDr.%Id(),0))
		if (PDARowId'=""){
			s aobj = ##class(User.DHCPHDiseaseAge).%OpenId(PDARowId)
			s aeobj = ##class(web.Entity.KB.DHCPHDiseaseAge).%New()
			s aeobj.PDARowId=PDARowId
			s:aobj.PDAAgeDr'="" aeobj.PDAAgeDr=aobj.PDAAgeDr.%Id()
			s:aobj.PDAInstDr'="" aeobj.PDAInstDr=aobj.PDAInstDr.%Id()
			s aeobj.PDAMinVal=aobj.PDAMinVal
			s aeobj.PDAMaxVal=aobj.PDAMaxVal
			s:aobj.PDAUomDr'="" aeobj.PDAUomDr=aobj.PDAUomDr.%Id()
			s oalogJson="PDAAgeDr:"_$c(34)_aeobj.PDAAgeDr_$C(34)_",PDAInstDr:"_$C(34)_aeobj.PDAInstDr_$C(34)_",PDAMinVal:"_$c(34)_aeobj.PDAMinVal_$c(34)_",PDAMaxVal:"_$c(34)_aeobj.PDAMaxVal_$c(34)_",PDAUomDr:"_$c(34)_aeobj.PDAUomDr_$c(34)
		}else {
			s oalogJson="PDAAgeDr:"""",PDAInstDr:"""",PDAMinVal:"""",PDAMaxVal:"""",PDAUomDr:"""""
		}
		
		
		s sca=##class(User.DHCPHDiseaseAge).%DeleteId(PDARowId)
		if $$$ISOK(sca){
			;d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDiseaseAge","User.DHCPHDiseaseAge","年龄",PDARowId,aeobj.PDAAgeDr,"D",aeobj)
		}
		else{
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sca)_"'}"  //返回错误信息
		}
		
		;主索引表
		s seobj = ##class(web.Entity.KB.DHCPHInstructions).%New()
		s spobj = ##class(User.DHCPHInstructions).%OpenId(pobj.PDIInstDr.%Id())
		s seobj.PHINSTRowId=pobj.PDIInstDr.%Id()
		s seobj.PHINSTMode=spobj.PHINSTMode
		s:spobj.PHINSTTypeDr'="" seobj.PHINSTTypeDr = spobj.PHINSTTypeDr.%Id()
		s seobj.PHINSTOrderNum=spobj.PHINSTOrderNum
		//s:spobj.PHINSTGenDr'="" seobj.PHINSTGenDr = spobj.PHINSTGenDr.%Id()
		s:spobj.PHINSTGenDr'="" seobj.PHINSTGenDr = spobj.PHINSTGenDr
		s seobj.PHINSTPointerDr=spobj.PHINSTPointerDr
		s seobj.PHINSTPointerType=spobj.PHINSTPointerType
		s:spobj.PHINSTLibDr'="" seobj.PHINSTLibDr = spobj.PHINSTLibDr.%Id()
		s seobj.PHINSTActiveFlag=spobj.PHINSTActiveFlag
		s seobj.PHINSTSysFlag=spobj.PHINSTSysFlag
		s seobj.PHINSTText=spobj.PHINSTText
		s oslogJson="PHINSTMode:"_seobj.PHINSTMode_$C(34)_",PHINSTTypeDr:"_$C(34)_seobj.PHINSTTypeDr_$C(34)_",PHINSTOrderNum:"_$C(34)_seobj.PHINSTOrderNum_$C(34)_",PHINSTGenDr:"_$C(34)_seobj.PHINSTGenDr_$C(34)_",PHINSTPointerDr:"_$C(34)_seobj.PHINSTPointerDr_$C(34)_",PHINSTPointerType:"_$C(34)_seobj.PHINSTPointerType_$C(34)_",PHINSTLibDr:"_$C(34)_seobj.PHINSTLibDr_$C(34)_",PHINSTActiveFlag:"_$C(34)_seobj.PHINSTActiveFlag_$C(34)_",PHINSTSysFlag:"_$C(34)_seobj.PHINSTSysFlag_$C(34)_",PHINSTText:"_$C(34)_seobj.PHINSTText_$C(34)
		
		s scs=##class(User.DHCPHInstructions).%DeleteId(pobj.PDIInstDr.%Id())
		if $$$ISOK(scs){
			;d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","给药途径主索引",seobj.PHINSTRowId,seobj.PHINSTMode,"D",seobj)
		}
		else{
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scs)_"'}"  //返回错误信息
		}
		
		;给药途径表
		s eobj = ##class(web.Entity.KB.DHCPHDiseaseUse).%New()
		s eobj.PDIRowId=id
		s:pobj.PDIUseDR'="" eobj.PDIUseDR = pobj.PDIUseDR.%Id()
		s PHEINDesc=""
		s:pobj.PDIUseDR'="" PHEINDesc=$p($g(^DHCPHEINSTR(pobj.PDIUseDR)),"^",2) //方法名称
		
		s:pobj.PDIInstDr'="" eobj.PDIInstDr = pobj.PDIInstDr.%Id()
		s eobj.PDIExcludeFlag = pobj.PDIExcludeFlag
		s eobj.PDIAlertMsg = pobj.PDIAlertMsg
		s oulogJson="PDIUseDR:"_$c(34)_eobj.PDIUseDR_$C(34)_",PDIInstDr:"_$C(34)_eobj.PDIInstDr_$C(34)_",PDIExcludeFlag:"_$c(34)_eobj.PDIExcludeFlag_$c(34)_",PDIAlertMsg:"_$c(34)_eobj.PDIAlertMsg_$c(34)
		s ologJson="{"_oulogJson_","_oalogJson_","_oslogJson_"}"		
		

		s sc=##class(User.DHCPHDiseaseUse).%DeleteId(id)
		if $$$ISOK(sc){
			s result="{success:'true',info:'删除成功！'}"
			;d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDiseaseUse","User.DHCPHDiseaseUse","给药途径",id,eobj.PDIUseDR,"D",eobj)
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHInstructions","User.DHCPHInstructions","药品说明书编辑器-给药途径",seobj.PHINSTRowId,PHEINDesc,"D",ologJson)
		}
		else{
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
		
		
	q result
}

/// Description：根据主索引的id获取给药途径显示数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHDiseaseUse).GetData("513")
ClassMethod GetData(InstId As %String) As %String
{
	s str=""
	s PDIRowId = $o(^DHCPHDISUSE("0","Inst",InstId,0))
	s:PDIRowId'="" PDIUseDR=$p($g(^DHCPHDISUSE(PDIRowId)),"^",2)  //给药途径Dr
	s:PDIRowId'="" PDIExcludeFlag=$p($g(^DHCPHDISUSE(PDIRowId)),"^",3) //禁忌
	s PHEINDesc=""
	s:PDIUseDR'="" PHEINDesc=$p($g(^DHCPHEINSTR(PDIUseDR)),"^",2) //方法名称
	
	s PDAAgeDesc=""
	s PDAMinVal=""
	s PDAMaxVal=""
	s PHEUDesc=""
	s PDAAgeDesc=""
	s PDARowId = $o(^DHCPHDISAGE("0","Inst",InstId,0))
	if (PDARowId'=""){
		s PDAAgeDr = $p($g(^DHCPHDISAGE(PDARowId)),"^",2) //年龄Dr 
		s:PDAAgeDr'="" PDAAgeDesc=$p($g(^DHCPHPAGEL(PDAAgeDr)),"^",2) //年龄描述
		s:PDAAgeDr="" PDAAgeDesc="" //年龄描述
		s PDAMinVal = $p($g(^DHCPHDISAGE(PDARowId)),"^",3) //年龄最小值
		s PDAMaxVal = $p($g(^DHCPHDISAGE(PDARowId)),"^",4) //年龄最大值
		s PDAUomDr = $p($g(^DHCPHDISAGE(PDARowId)),"^",5) //年龄单位Dr
		s:PDAUomDr'="" PHEUDesc=$p($g(^DHCPHEUO(PDAUomDr)),"^",2) //年龄描述
		s:PDAUomDr="" PHEUDesc="" //年龄描述
	}
	
	if (PDIExcludeFlag="Y") {
		if (PDAMinVal=""){
			s str=str_"禁忌:"_PHEINDesc_";"_PDAAgeDesc
		}else{
			s str=str_"禁忌:"_PHEINDesc_";"_PDAMinVal_"-"_PDAMaxVal_PHEUDesc_";"_PDAAgeDesc
		}
	}
	else {
		if (PDAMinVal=""){
			s str=str_PHEINDesc_";"_PDAAgeDesc
		}else{
			s str=str_PHEINDesc_";"_PDAMinVal_"-"_PDAMaxVal_PHEUDesc_";"_PDAAgeDesc
		}
	}
	q str
}

/// Description：获取给药途径中已选方法的串
/// Other: w ##class(web.DHCBL.KB.DHCPHDiseaseUse).GetUseDR("","11","Form","2")
ClassMethod GetUseDR(TypeDr, GenDr, PointerType, PointerDr) As %String
{
	s str=""
	s TypeDr=$o(^DHCPHPINL("0","Code","PREMET",0))
	s PDIInstDr=0
	for{
		s PDIInstDr=$o(^DHCPHINSTRUC("0","TGP",TypeDr,GenDr,PointerType,PointerDr,PDIInstDr))	q:PDIInstDr=""
		s PDIRowId = $o(^DHCPHDISUSE("0","Inst",PDIInstDr,0)) continue:PDIRowId=""
		s PDIUseDR=$p($g(^DHCPHDISUSE(PDIRowId)),"^",2)  //给药途径Dr
		s:PDIUseDR'="" PHEINCode=$p($g(^DHCPHEINSTR(PDIUseDR)),"^",1) //方法代码 
		s str="<"_PHEINCode_">^"_str
	}
	q str
}

/// Creator:高姗姗
/// CreatDate: 2015-1-22
/// Description：修改保存级别
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// d ##class(web.DHCBL.KB.DHCPHDiseaseUse).SaveMode("450","C","3")
ClassMethod SaveMode(id As %String, mode As %String, ageDr As %String, minVal As %String, maxVal As %String, uomDr As %String, flag As %String, msg As %String) As %String
{
	s result = ""

	s $p(^DHCPHINSTRUC(id),"^",14)=mode     //级别
	s $p(^DHCPHINSTRUC(id),"^",15)=msg      //text
	
	s PDARowId = $o(^DHCPHDISAGE("0","Inst",id,0))
	s bageDr = $p(^DHCPHDISAGE(PDARowId),"^",2)
	if (ageDr'=bageDr){
		s TypeDr=$o(^DHCPHPINL("0","Code","PREMET",0))
		s GenDr=$p($g(^DHCPHINSTRUC(id)),"^",3)
		s PointerType=$p($g(^DHCPHINSTRUC(id)),"^",5)
		s PointerDr=$p($g(^DHCPHINSTRUC(id)),"^",4)
		s PDIUseDR=$p($g(^DHCPHDISUSE($o(^DHCPHDISUSE("0","Inst",id,0)))),"^",2)
		s PDIInstDr=0
		s AgeDrs = ""
		for{
			s PDIInstDr=$o(^DHCPHINSTRUC("0","TGP",TypeDr,GenDr,PointerType,PointerDr,PDIInstDr))	q:PDIInstDr=""
			s PDIRowId = $o(^DHCPHDISUSE("0","Inst",PDIInstDr,0))  continue:PDIRowId=""
			s UseDR=$p($g(^DHCPHDISUSE(PDIRowId)),"^",2)  //给药途径Dr
			if (PDIUseDR=UseDR){
				s RowId = $o(^DHCPHDISAGE("0","Inst",PDIInstDr,0)) 
				if (RowId'=""){
					s PDAAgeDr = $p($g(^DHCPHDISAGE(RowId)),"^",2) //年龄Dr 
					s AgeDrs = "<"_PDAAgeDr_">,"_AgeDrs
				}
			}
		}
		s AgeDr = "<"_ageDr_">"
		if (AgeDrs[AgeDr) Quit "{success:'false',info:'该记录已存在'}"	
	}
	s $p(^DHCPHDISAGE(PDARowId),"^",2)=ageDr       //年龄
	if ((ageDr'=bageDr)&&(ageDr'="")){
		//根据年龄获取年龄字典相关信息
		s PDAAgeMin=$p($g(^DHCPHPAGEL(ageDr)),"^",3)	
		s PDAAgeMax=$p($g(^DHCPHPAGEL(ageDr)),"^",4)
		s UomRowId=$p($g(^DHCPHPAGEL(ageDr)),"^",7)
		s:UomRowId'="" PDAUomDr=$p($g(^DHCPHEUO(UomRowId)),"^",2)
		s:UomRowId="" PDAUomDr=""
		
		s $p(^DHCPHDISAGE(PDARowId),"^",3) = PDAAgeMin //最小值
		s $p(^DHCPHDISAGE(PDARowId),"^",4) = PDAAgeMax //最大值
		s $p(^DHCPHDISAGE(PDARowId),"^",5) = PDAUomDr //年龄单位
	}
	else {
		s $p(^DHCPHDISAGE(PDARowId),"^",3) = minVal //最小值
		s $p(^DHCPHDISAGE(PDARowId),"^",4) = maxVal //最大值
		s $p(^DHCPHDISAGE(PDARowId),"^",5) = uomDr //年龄单位
	}
	
	s PDIRowId = $o(^DHCPHDISUSE("0","Inst",id,0))
	s $p(^DHCPHDISUSE(PDIRowId),"^",3)=flag //禁忌   
	s $p(^DHCPHDISUSE(PDIRowId),"^",4)=msg //提示消息 
	
	s result = "{success:'true',info:'修改成功'}"  
	q result
}

}
