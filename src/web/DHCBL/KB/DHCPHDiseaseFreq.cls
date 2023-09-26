Class web.DHCBL.KB.DHCPHDiseaseFreq Extends %RegisteredObject
{

/// Creator：丁亚男
/// CreatDate: 2018-09-05
/// Description：查询药品频率表内容
/// Table：User.DHCPHDiseaseFreq
/// Input：rowid
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHDiseaseFreq","GetListNew","2","10","FORM","2")
Query GetListNew(TypeDr, GenDr, PointerType, PointerDr, desc) As %Query(ROWSPEC = "PDFRowId,PDFInstDr,PDFFreqDR,PHEFDescF,PHEFDesc,PHINSTModeF,PHINSTMode,PDFExcludeFlagF,PDFExcludeFlag,PDAAgeDrF,PDAAgeDr,PDAAgeDesc,PDAMinVal,PDAMaxVal,PDAUomDrF,PDAUomDrF,PDAUomDr,PDFAlertMsg")
{
}

ClassMethod GetListNewExecute(ByRef qHandle As %Binary, TypeDr, GenDr, PointerType, PointerDr, desc) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s TypeDr=$o(^DHCPHPINL("0","Code","FREQ",0))
	s PDFInstDr=0
	for{
		s PDFInstDr=$o(^DHCPHINSTRUC("0","TGP",TypeDr,GenDr,PointerType,PointerDr,PDFInstDr))	q:PDFInstDr=""
		s PHINSTModeF = $p($g(^DHCPHINSTRUC(PDFInstDr)),"^",14) //管制级别
		s PHINSTMode=PHINSTModeF
		s PDFRowId = $o(^DHCPHDISFR("0","Inst",PDFInstDr,0)) continue:PDFRowId=""
		s PDFFreqDR=$p($g(^DHCPHDISFR(PDFRowId)),"^",2)  //用药频率Dr
		s PHEFDescF=PDFFreqDR
		s:PDFFreqDR'="" PHEFCode=$p($g(^DHCPHEFR(PDFFreqDR)),"^",1) //频率代码
		s:PDFFreqDR'="" PHEFDesc=$p($g(^DHCPHEFR(PDFFreqDR)),"^",2) //频率名称
		s PDFExcludeFlagF=$p($g(^DHCPHDISFR(PDFRowId)),"^",3)  //禁忌
		s PDFExcludeFlag=PDFExcludeFlagF
		s PDFAlertMsg=$p($g(^DHCPHDISFR(PDFRowId)),"^",4)  //提示消息 
		s PDARowId = $o(^DHCPHDISAGE("0","Inst",PDFInstDr,0)) 
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
		s PHEFDesc1=$$ALPHAUP^SSUTIL4(PHEFDesc)
		if (PHEFDesc1[desc){
			d OutputRow
		}
		
		
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PDFRowId,PDFInstDr,PDFFreqDR,PHEFDescF,PHEFDesc,PHINSTModeF,PHINSTMode,PDFExcludeFlagF,PDFExcludeFlag,PDAAgeDrF,PDAAgeDr,PDAAgeDesc,PDAMinVal,PDAMaxVal,PDAUomDrF,PDAUomDrF,PDAUomDr,PDFAlertMsg)
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

/// Creator：高姗姗
/// CreatDate: 2014-12-3
/// Description：查询药品频率表内容
/// Table：User.DHCPHDiseaseFreq
/// Input：rowid
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHDiseaseFreq","GetList","2","10","FORM","2")
Query GetList(TypeDr, GenDr, PointerType, PointerDr) As %Query(ROWSPEC = "PDFRowId,PDFInstDr,PDFFreqDR,PHEFCode,PHEFDesc,PHINSTMode,PDFExcludeFlag,PDAAgeDr,PDAAgeDesc,PDAMinVal,PDAMaxVal,PDAUomDr,PHEUDesc,PDFAlertMsg")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, TypeDr, GenDr, PointerType, PointerDr) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s TypeDr=$o(^DHCPHPINL("0","Code","FREQ",0))
	s PDFInstDr=0
	for{
		s PDFInstDr=$o(^DHCPHINSTRUC("0","TGP",TypeDr,GenDr,PointerType,PointerDr,PDFInstDr))	q:PDFInstDr=""
		s PHINSTMode = $p($g(^DHCPHINSTRUC(PDFInstDr)),"^",14) //管制级别
		s PDFRowId = $o(^DHCPHDISFR("0","Inst",PDFInstDr,0)) continue:PDFRowId=""
		s PDFFreqDR=$p($g(^DHCPHDISFR(PDFRowId)),"^",2)  //用药频率Dr
		s:PDFFreqDR'="" PHEFCode=$p($g(^DHCPHEFR(PDFFreqDR)),"^",1) //频率代码
		s:PDFFreqDR'="" PHEFDesc=$p($g(^DHCPHEFR(PDFFreqDR)),"^",2) //频率名称
		s PDFExcludeFlag=$p($g(^DHCPHDISFR(PDFRowId)),"^",3)  //禁忌 
		s PDFAlertMsg=$p($g(^DHCPHDISFR(PDFRowId)),"^",4)  //提示消息 
		s PDARowId = $o(^DHCPHDISAGE("0","Inst",PDFInstDr,0)) 
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
    set Data=$lb(PDFRowId,PDFInstDr,PDFFreqDR,PHEFCode,PHEFDesc,PHINSTMode,PDFExcludeFlag,PDAAgeDr,PDAAgeDesc,PDAMinVal,PDAMaxVal,PDAUomDr,PHEUDesc,PDFAlertMsg)
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

/// Creator:高姗姗
/// CreatDate: 2014-12-3
/// Description：保存用药频率
/// Table：User.DHCPHDiseaseFreq    User.DHCPHInstructions
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// d ##class(web.DHCBL.KB.DHCPHDiseaseFreq).SaveData("1^C^FREQ^0^5^21^Form^DRUG^Y^Y^true^^^^")
ClassMethod SaveData(freqStr As %String) As %String
{
 if (freqStr'=""){
	s result = ""
	s freqlen=$Length(freqStr,"*")
	for i=1:1:freqlen
	{
		s freq=$p(freqStr,"*",i)
		s PDFFreqDR=$p(freq,"^",1) //频率字典id
		s Mode=$p(freq,"^",2) //管制级别
		s Type=$p(freq,"^",3) //知识库目录
		s OrderNum=$p(freq,"^",4) //顺序
		s Gen=$p(freq,"^",5) //通用名
		s Pointer=$p(freq,"^",6) //指针
		s PointerType=$p(freq,"^",7) //指针类型
		s Lib=$p(freq,"^",8) //知识库标识
		s ActiveFlag=$p(freq,"^",9) //是否可用
		s SysFlag=$p(freq,"^",10) //是否系统标识
		s ExcludeFlag=$p(freq,"^",11) //禁忌
		s Age=$p(freq,"^",12) //年龄
		s MinVal=$p(freq,"^",13) //年龄限制最小值
		s MaxVal=$p(freq,"^",14) //年龄限制最大值
		s UomDr=$p(freq,"^",15) //年龄单位
		s PDFAlertMsg=$p(freq,"^",16) //提示消息
	/*
	s TypeDr=$o(^DHCPHPINL("0","Code","FREQ",0))
	s PDFInstDr=0
	s FreqDRs = ""
	s AgeDrs = ""
	for{
		s PDFInstDr=$o(^DHCPHINSTRUC("0","TGP",TypeDr,Gen,PointerType,Pointer,PDFInstDr)) q:PDFInstDr=""
		s PDFRowId = $o(^DHCPHDISFR("0","Inst",PDFInstDr,0)) continue:PDFRowId=""
		s FreqDR=$p($g(^DHCPHDISFR(PDFRowId)),"^",2)  //用药频率Dr
		s FreqDRs="<"_FreqDR_">,"_FreqDRs
		if (PDFFreqDR=FreqDR){
			s PDARowId = $o(^DHCPHDISAGE("0","Inst",PDFInstDr,0)) 
			if (PDARowId'=""){
				s PDAAgeDr = $p($g(^DHCPHDISAGE(PDARowId)),"^",2) //年龄Dr 
				s AgeDrs = "<"_PDAAgeDr_">,"_AgeDrs
			}
		}
	}
	s FreqDRa = "<"_PDFFreqDR_">"
	s AgeDr = "<"_Age_">"
	if (FreqDRs[FreqDRa)&&(AgeDrs[AgeDr) q "{success:'false',info:'该记录已存在'}"		
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
	s sobj.PHINSTText=PDFAlertMsg
	;用药频率主索引json
	s slogJson="PHINSTMode:"_$C(34)_Mode_$C(34)_",PHINSTTypeDr:"_$C(34)_TypeDr_$C(34)_",PHINSTOrderNum:"_$C(34)_OrderNum_$C(34)_",PHINSTGenDr:"_$C(34)_Gen_$C(34)_",PHINSTPointerDr:"_$C(34)_Pointer_$C(34)_",PHINSTPointerType:"_$C(34)_PointerType_$C(34)_",PHINSTLibDr:"_$C(34)_LibDr_$C(34)_",PHINSTActiveFlag:"_$C(34)_ActiveFlag_$C(34)_",PHINSTSysFlag:"_$C(34)_SysFlag_$C(34)_",PHINSTText:"_$C(34)_PDFAlertMsg_$C(34)
	s scs=sobj.%Save()
	d sobj.%Close()
	If $$$ISOK(scs){ 
		s sid = sobj.%Id()
		//d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHInstructions","User.DHCPHInstructions","用药频率主索引",sid,Mode,"A",slogJson)	
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
		//d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHDiseaseAge","User.DHCPHDiseaseAge","年龄",aid,Age,"A",alogJson)	
	}
	else{
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sca)_"_'}"    //返回错误信息
	}
	
	;用药频率表
	s obj=##class(User.DHCPHDiseaseFreq).%New()
	d:PDFFreqDR'="" obj.PDFFreqDRSetObjectId(PDFFreqDR)
	s PHEFDesc=""
	s:PDFFreqDR'="" PHEFDesc=$p($g(^DHCPHEFR(PDFFreqDR)),"^",2) //频率名称
	d:sid'="" obj.PDFInstDrSetObjectId(sid)
	i ExcludeFlag="true"
	{
		s obj.PDFExcludeFlag = "Y"
	}
	else
	{
		s obj.PDFExcludeFlag = "N"
	}
	s obj.PDFAlertMsg=PDFAlertMsg
	;用药频率json
	s flogJson="PDFFreqDR:"_$c(34)_PDFFreqDR_$C(34)_",PDFInstDr:"_$C(34)_sid_$C(34)_",PDFExcludeFlag:"_$c(34)_obj.PDFExcludeFlag_$c(34)_",PDFAlertMsg:"_$c(34)_obj.PDFAlertMsg_$c(34)
	s logJson="{"_flogJson_","_alogJson_","_slogJson_"}"
	
	s sc=obj.%Save()
	d obj.%Close()	
	
	If $$$ISOK(sc){
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}"    
		//d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHDiseaseFreq","User.DHCPHDiseaseFreq","药品说明书编辑器用药频率",id,PHEFDesc,"A",logJson)
	   }
	else{
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"_'}"    //返回错误信息
	}			
   	if (result["true"){
		Tc
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHInstructions","User.DHCPHInstructions","药品说明书编辑器-用药频率",sid,PHEFDesc,"A",logJson)
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
/// Description：修改用药频率
/// Table：User.DHCPHDiseaseFreq    User.DHCPHInstructions
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHDiseaseFreq).UpdateData()
ClassMethod UpdateData(freqStr As %String) As %String
{
	if (freqStr'=""){
		s result = ""
		s freqlen=$Length(freqStr,"*")
		for i=1:1:freqlen
		{
			s freq=$p(freqStr,"*",i)
			s PDFFreqDR=$p(freq,"^",1) //频率字典id
			s Mode=$p(freq,"^",2) //管制级别
			s Type=$p(freq,"^",3) //知识库目录
			s OrderNum=$p(freq,"^",4) //顺序
			s Gen=$p(freq,"^",5) //通用名
			s Pointer=$p(freq,"^",6) //指针
			s PointerType=$p(freq,"^",7) //指针类型
			s Lib=$p(freq,"^",8) //知识库标识
			s ActiveFlag=$p(freq,"^",9) //是否可用
			s SysFlag=$p(freq,"^",10) //是否系统标识
			s ExcludeFlag=$p(freq,"^",11) //禁忌
			s Age=$p(freq,"^",12) //年龄
			s MinVal=$p(freq,"^",13) //年龄限制最小值
			s MaxVal=$p(freq,"^",14) //年龄限制最大值
			s UomDr=$p(freq,"^",15) //年龄单位
			s PDFAlertMsg=$p(freq,"^",16) //提示消息
			s InstDr=$p(freq,"^",17) //主索引表id
			
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
			s sobj.PHINSTText=PDFAlertMsg
			;用药频率主索引json
	        s slogJson="PHINSTMode:"_$C(34)_Mode_$C(34)_",PHINSTTypeDr:"_$C(34)_TypeDr_$C(34)_",PHINSTOrderNum:"_$C(34)_OrderNum_$C(34)_",PHINSTGenDr:"_$C(34)_Gen_$C(34)_",PHINSTPointerDr:"_$C(34)_Pointer_$C(34)_",PHINSTPointerType:"_$C(34)_PointerType_$C(34)_",PHINSTLibDr:"_$C(34)_LibDr_$C(34)_",PHINSTActiveFlag:"_$C(34)_ActiveFlag_$C(34)_",PHINSTSysFlag:"_$C(34)_SysFlag_$C(34)_",PHINSTText:"_$C(34)_PDFAlertMsg_$C(34)
			s oslogJson="PHINSTMode:"_bobj.PHINSTMode_$C(34)_",PHINSTTypeDr:"_$C(34)_bobj.PHINSTTypeDr_$C(34)_",PHINSTOrderNum:"_$C(34)_bobj.PHINSTOrderNum_$C(34)_",PHINSTGenDr:"_$C(34)_bobj.PHINSTGenDr_$C(34)_",PHINSTPointerDr:"_$C(34)_bobj.PHINSTPointerDr_$C(34)_",PHINSTPointerType:"_$C(34)_bobj.PHINSTPointerType_$C(34)_",PHINSTLibDr:"_$C(34)_bobj.PHINSTLibDr_$C(34)_",PHINSTActiveFlag:"_$C(34)_bobj.PHINSTActiveFlag_$C(34)_",PHINSTSysFlag:"_$C(34)_bobj.PHINSTSysFlag_$C(34)_",PHINSTText:"_$C(34)_bobj.PHINSTText_$C(34)
			
			s scIns=sobj.%Save()	
			d sobj.%Close()
			If $$$ISOK(scIns)
			{
				s Insid = sobj.%Id()
				;d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHInstructions","User.DHCPHInstructions","用药频率主索引",Insid,Mode,"U",slogJson,oslogJson)	
			}
			else{
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
					;d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHDiseaseAge","User.DHCPHDiseaseAge","年龄",ageId,Age,"U",alogJson,oalogJson)	
				}
				else{
					s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scAge)_"_'}"    //返回错误信息
				}
			}
			elseif ((PDARowId="")&((Age'="")||(MinVal'="")||(MaxVal'="")))
			{
			 	s objAge = ##class(User.DHCPHDiseaseAge).%New()
			 	d objAge.PDAInstDrSetObjectId(PHDDInstDr)	
			 	d:Age'="" objAge.PDAAgeDrSetObjectId(Age)
				s objAge.PDAMinVal=MinVal
				s objAge.PDAMaxVal=MaxVal
				d:UomDr'="" objAge.PDAUomDrSetObjectId(UomDr)
				;年龄json 
				s alogJson="PDAAgeDr:"_$c(34)_Age_$C(34)_",PDAInstDr:"_$C(34)_PHDDInstDr_$C(34)_",PDAMinVal:"_$c(34)_MinVal_$c(34)_",PDAMaxVal:"_$c(34)_MaxVal_$c(34)_",PDAUomDr:"_$c(34)_UomDr_$c(34)
				;s oalogJson="PDAAgeDr:"""",PDAInstDr:"""",PDAMinVal:"""",PDAMaxVal:"""",PDAUomDr:"""""
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
			
			//修改用药频率业务表
			//通过索引获取用药频率业务表的RowId——PDFRowId
			s flogJson="PDFFreqDR:"""",PDFInstDr:"""",PDFExcludeFlag:"""",PDFAlertMsg:"""""
			s oflogJson="PDFFreqDR:"""",PDFInstDr:"""",PDFExcludeFlag:"""",PDFAlertMsg:"""""
			s PDFRowId=$o(^DHCPHDISFR("0","Inst",PHDDInstDr,0))
			if (PDFRowId'="")
			{
				s objFreq = ##class(User.DHCPHDiseaseFreq).%OpenId(PDFRowId)
				s bobjFreq=##class(web.Entity.KB.DHCPHDiseaseFreq).%New()
				s bobjFreq.PDFRowId=PDFRowId
				s:objFreq.PDFInstDr'="" bobjFreq.PDFInstDr = objFreq.PDFInstDr.%Id()
				s:objFreq.PDFFreqDR'="" bobjFreq.PDFFreqDR = objFreq.PDFFreqDR.%Id()
				s bobjFreq.PDFExcludeFlag=objFreq.PDFExcludeFlag
				s bobjFreq.PDFAlertMsg=objFreq.PDFAlertMsg
				
				i ExcludeFlag="true"
				{
					s ExcludeFlag = "Y"
				}
				else
				{
					s ExcludeFlag = "N"
				}
				d:PDFFreqDR'="" objFreq.PDFFreqDRSetObjectId(PDFFreqDR)
				s PHEFDesc=""
				s:PDFFreqDR'="" PHEFDesc=$p($g(^DHCPHEFR(PDFFreqDR)),"^",2) //频率名称
				s objFreq.PDFExcludeFlag = ExcludeFlag	
				s objFreq.PDFAlertMsg=PDFAlertMsg
				
				
				s flogJson="PDFFreqDR:"_$c(34)_PDFFreqDR_$C(34)_",PDFInstDr:"_$C(34)_PHDDInstDr_$C(34)_",PDFExcludeFlag:"_$c(34)_ExcludeFlag_$c(34)_",PDFAlertMsg:"_$c(34)_PDFAlertMsg_$c(34)
				s oflogJson="PDFFreqDR:"_$c(34)_bobjFreq.PDFFreqDR_$C(34)_",PDFInstDr:"_$C(34)_bobjFreq.PDFInstDr_$C(34)_",PDFExcludeFlag:"_$c(34)_bobjFreq.PDFExcludeFlag_$c(34)_",PDFAlertMsg:"_$c(34)_bobjFreq.PDFAlertMsg_$c(34)
				
				
				
				s scFreq=objFreq.%Save()
				d objFreq.%Close()
				
				if $$$ISOK(scFreq)
				{
					s freqId=objFreq.%Id()
					//d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHDiseaseFreq","User.DHCPHDiseaseFreq","药品说明书编辑器用药频率",freqId,PHEFDesc,"U",logJson,ologJson)
				}
				else{
					s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scFreq)_"_'}" 
				}
				
			}
			elseif(PDFRowId="")&(PDFFreqDR'="")
			{
				;用药频率表
				s obj=##class(User.DHCPHDiseaseFreq).%New()
				d:PDFFreqDR'="" obj.PDFFreqDRSetObjectId(PDFFreqDR)
				s PHEFDesc=""
				s:PDFFreqDR'="" PHEFDesc=$p($g(^DHCPHEFR(PDFFreqDR)),"^",2) //频率名称
				d:sid'="" obj.PDFInstDrSetObjectId(sid)
				i ExcludeFlag="true"
				{
					s obj.PDFExcludeFlag = "Y"
				}
				else
				{
					s obj.PDFExcludeFlag = "N"
				}
				s obj.PDFAlertMsg=PDFAlertMsg
				;用药频率json
				s flogJson="PDFFreqDR:"_$c(34)_PDFFreqDR_$C(34)_",PDFInstDr:"_$C(34)_sid_$C(34)_",PDFExcludeFlag:"_$c(34)_obj.PDFExcludeFlag_$c(34)_",PDFAlertMsg:"_$c(34)_obj.PDFAlertMsg_$c(34)
				s oflogJson="PDFFreqDR:"""",PDFInstDr:"""",PDFExcludeFlag:"""",PDFAlertMsg:"""""
				
			}
			s logJson="{"_flogJson_","_alogJson_","_slogJson_"}"
			s ologJson="{"_oflogJson_","_oalogJson_","_oslogJson_"}"
			
			if (result["false")  
			{
				Trollback
				s result = "{success:'false',errorinfo:'保存失败'}"
				
			}
			else
			{
				Tc
				s result = "{success:'true',id:'"_PHDDInstDr_"'}" //返回RowId
				d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHInstructions","User.DHCPHInstructions","药品说明书编辑器-用药频率",Insid,PHEFDesc,"U",logJson,ologJson)

			}
		}
		q result		
	}
}

/// Creator:高姗姗
/// CreatDate:2014-12-4
/// Description:根据id删除
/// Table:User.DHCPHDiseaseFreq
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCPHDiseaseFreq).DeleteData("21")
ClassMethod DeleteData(id As %String) As %String
{
	s return="",myInfo=""
	
		s pobj = ##class(User.DHCPHDiseaseFreq).%OpenId(id)
		
		;年龄表
		s PDARowId=$o(^DHCPHDISAGE(0,"Inst",pobj.PDFInstDr.%Id(),0))
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
		Ts
		s seobj = ##class(web.Entity.KB.DHCPHInstructions).%New()
		s spobj = ##class(User.DHCPHInstructions).%OpenId(pobj.PDFInstDr.%Id())
		s seobj.PHINSTRowId=pobj.PDFInstDr.%Id()
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
			
		
		s scs=##class(User.DHCPHInstructions).%DeleteId(pobj.PDFInstDr.%Id())
		if $$$ISOK(scs){
			Tc
			;d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","用药频率主索引",seobj.PHINSTRowId,seobj.PHINSTMode,"D",seobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
		
		;用药频率表
		Ts
		s eobj = ##class(web.Entity.KB.DHCPHDiseaseFreq).%New()
		s eobj.PDFRowId=id
		s:pobj.PDFFreqDR'="" eobj.PDFFreqDR = pobj.PDFFreqDR.%Id()
		s PHEFDesc=""
		s:pobj.PDFFreqDR'="" PHEFDesc=$p($g(^DHCPHEFR(eobj.PDFFreqDR)),"^",2) //频率名称
		
		s:pobj.PDFInstDr'="" eobj.PDFInstDr = pobj.PDFInstDr.%Id()
		s eobj.PDFExcludeFlag = pobj.PDFExcludeFlag
		s eobj.PDFAlertMsg = pobj.PDFAlertMsg
		s oflogJson="PDFFreqDR:"_$c(34)_eobj.PDFFreqDR_$C(34)_",PDFInstDr:"_$C(34)_eobj.PDFInstDr_$C(34)_",PDFExcludeFlag:"_$c(34)_eobj.PDFExcludeFlag_$c(34)_",PDFAlertMsg:"_$c(34)_eobj.PDFAlertMsg_$c(34)
		s ologJson="{"_oflogJson_","_oalogJson_","_oslogJson_"}"		
		
		s sc=##class(User.DHCPHDiseaseFreq).%DeleteId(id)
		if $$$ISOK(sc){
			Tc
			s result="{success:'true',info:'删除成功！'}"
			;d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDiseaseFreq","User.DHCPHDiseaseFreq","用药频率",id,eobj.PDFFreqDR,"D",eobj)
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHInstructions","User.DHCPHInstructions","药品说明书编辑器-用药频率",seobj.PHINSTRowId,PHEFDesc,"D",ologJson)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}

	q result
}

/// Description：根据主索引的id获取用药方法显示数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHDiseaseFreq).GetData("927")
ClassMethod GetData(InstId As %String) As %String
{
	s str=""
	s PDFRowId = $o(^DHCPHDISFR("0","Inst",InstId,0)) 
	s:PDFRowId'="" PDFFreqDR=$p($g(^DHCPHDISFR(PDFRowId)),"^",2)  //用药频率Dr
	s:PDFRowId'="" PDFExcludeFlag=$p($g(^DHCPHDISFR(PDFRowId)),"^",3)  //禁忌
	s:PDFFreqDR'="" PHEFDesc=$p($g(^DHCPHEFR(PDFFreqDR)),"^",2) //频率名称 

	s PDAAgeDesc=""
	s PDAMinVal=""
	s PDAMaxVal=""
	s PHEUDesc=""
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
	
	if (PDFExcludeFlag="Y") {
		if (PDAMinVal=""){
			s str=str_"禁忌:"_PHEFDesc_";"_PDAAgeDesc
		}else{
			s str=str_"禁忌:"_PHEFDesc_";"_PDAMinVal_"-"_PDAMaxVal_PHEUDesc_";"_PDAAgeDesc
		}
	}
	else {
		if (PDAMinVal=""){
			s str=str_PHEFDesc_";"_PDAAgeDesc
		}else{
			s str=str_PHEFDesc_";"_PDAMinVal_"-"_PDAMaxVal_PHEUDesc_";"_PDAAgeDesc
		}
	}
	q str
}

/// Description：获取用药频率中已选频率的串
/// Other: w ##class(web.DHCBL.KB.DHCPHDiseaseFreq).GetFreqDr("","10","Form","2")
ClassMethod GetFreqDr(TypeDr, GenDr, PointerType, PointerDr) As %String
{
	s str=""
	s TypeDr=$o(^DHCPHPINL("0","Code","FREQ",0))
	s PDFInstDr=0
	for{
		s PDFInstDr=$o(^DHCPHINSTRUC("0","TGP",TypeDr,GenDr,PointerType,PointerDr,PDFInstDr))	q:PDFInstDr=""
		s PDFRowId = $o(^DHCPHDISFR("0","Inst",PDFInstDr,0)) continue:PDFRowId=""
		s PDFFreqDR=$p($g(^DHCPHDISFR(PDFRowId)),"^",2)  //用药频率Dr
		s:PDFFreqDR'="" PHEFCode=$p($g(^DHCPHEFR(PDFFreqDR)),"^",1) //频率代码
		s str="<"_PHEFCode_">^"_str
	}
	q str
}

/// Creator:高姗姗
/// CreatDate: 2015-1-22
/// Description：修改保存级别
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// d ##class(web.DHCBL.KB.DHCGenItmContrast).SaveCoeff("8^9^LAB")
ClassMethod SaveMode(id As %String, mode As %String, ageDr As %String, minVal As %String, maxVal As %String, uomDr As %String, flag As %String, msg As %String) As %String
{
	s result = ""	
	
	s $p(^DHCPHINSTRUC(id),"^",14)=mode     //级别
	s $p(^DHCPHINSTRUC(id),"^",15)=msg      //text
	
	s PDARowId = $o(^DHCPHDISAGE("0","Inst",id,0))
	if (PDARowId'=""){
		s bageDr = $p(^DHCPHDISAGE(PDARowId),"^",2)
		if (ageDr'=bageDr){
			s TypeDr=$o(^DHCPHPINL("0","Code","FREQ",0))
			s GenDr=$p($g(^DHCPHINSTRUC(id)),"^",3)
			s PointerType=$p($g(^DHCPHINSTRUC(id)),"^",5)
			s PointerDr=$p($g(^DHCPHINSTRUC(id)),"^",4)
			s PDFFreqDR = $p($g(^DHCPHDISFR($o(^DHCPHDISFR("0","Inst",id,0)))),"^",2)
			s PDFInstDr=0
			s AgeDrs = ""
			for{
				s PDFInstDr=$o(^DHCPHINSTRUC("0","TGP",TypeDr,GenDr,PointerType,PointerDr,PDFInstDr)) q:PDFInstDr=""
				s PDFRowId = $o(^DHCPHDISFR("0","Inst",PDFInstDr,0)) continue:PDFRowId=""
				s FreqDR=$p($g(^DHCPHDISFR(PDFRowId)),"^",2)  //用药频率Dr
				if (PDFFreqDR=FreqDR){
					s RowId = $o(^DHCPHDISAGE("0","Inst",PDFInstDr,0)) 
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
	}
	s PDFRowId = $o(^DHCPHDISFR("0","Inst",id,0))
	s $p(^DHCPHDISFR(PDFRowId),"^",3)=flag //禁忌  
	s $p(^DHCPHDISFR(PDFRowId),"^",4)=msg //提示消息  
	
	s result = "{success:'true',info:'修改成功'}"  
	q result
}

/// Creator：丁亚男
/// CreatDate: 2018-02-09
/// Description：查询频率字典表内容
/// Table：User.DHCPHExtFreq
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHDiseaseFreq","GetFreqList","","","","","")
Query GetFreqList(rowid, code, desc) As %Query(ROWSPEC = "PHEFRowId,PHEFCode,PHEFDesc,PHEFActiveFlag,PHEFSysFlag")
{
}

ClassMethod GetFreqListExecute(ByRef qHandle As %Binary, rowid, code, desc) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权Json
    //s AuStr=##class(web.DHCBL.Authorize.SSUser).DHCGetDataByDefaultSession()
    ;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
    ;假设未授权情况下默认全部显示数据
    //s AuFlag=0
    //if (AuStr="")||(AuStr["limited:0") s AuFlag=1
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s PHEFRowId=rowid
        s PHEFCode=$p($g(^DHCPHEFR(PHEFRowId)),"^",1)  //代码
        s PHEFDesc=$p($g(^DHCPHEFR(PHEFRowId)),"^",2)  //描述
        s PHEFActiveFlag=$p($g(^DHCPHEFR(PHEFRowId)),"^",3)  //是否可用
        s PHEFSysFlag=$p($g(^DHCPHEFR(PHEFRowId)),"^",4)  //是否系统标识
        if (PHEFActiveFlag'="N")
        {
	        d OutputRow1
	    }
        
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U")
        s:desc'="" desc=$ZCONVERT(desc,"U")
        s PHEFRowId=0
        for  
        {   
            s PHEFRowId=$o(^DHCPHEFR(PHEFRowId)) q:PHEFRowId="" 
            s strRowId = "{ID:"_PHEFRowId_"}"
            //i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
            //{
                s PHEFCode=$p($g(^DHCPHEFR(PHEFRowId)),"^",1)  //代码
                s PHEFCodeU=$ZCONVERT(PHEFCode,"U")
                s PHEFDesc=$p($g(^DHCPHEFR(PHEFRowId)),"^",2)  //描述
                s PHEFDescU=$ZCONVERT(PHEFDesc,"U")
                s PHEFActiveFlag=$p($g(^DHCPHEFR(PHEFRowId)),"^",3)  //是否可用
                s PHEFSysFlag=$p($g(^DHCPHEFR(PHEFRowId)),"^",4)  //是否系统标识
                
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHEFDescU))
                i (PHEFCodeU[code)&((PHEFDescU[desc)||(PINYIN[desc)) &(PHEFActiveFlag'="N")  //条件
                {
                    d OutputRow1
                }       
            //}
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow1
    set Data=$lb(PHEFRowId,PHEFCode,PHEFDesc,PHEFActiveFlag,PHEFSysFlag)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetFreqListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFreqListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetFreqListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFreqListExecute ]
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

}
