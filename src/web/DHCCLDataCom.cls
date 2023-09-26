Class web.DHCCLDataCom Extends %RegisteredObject
{

/// Creator：      	wll
/// CreatDate：    	2016-05-25
/// Description： 	导入医护人员类型数据
/// Table：        	CT_CarPrvTp  
/// Input:			RowStr=CtcpTpCode_"^"_CtcpTpDesc_"^"_CtcpTpType
/// Return：       	ResultSet
/// w ##class(web.DHCCLDataCom).ImportCarPrvTp("","test^测试^NURSE")
ClassMethod ImportCarPrvTp(ChangeType As %String = "", RowStr As %String = "") As %String
{
	if ChangeType="Clear" do
	.K ^CT("CPT")
	
	quit:ChangeType="Clear" "数据已清:医护人员类型"
	
	set del="^"
	set RowStr=$tr(RowStr," ","")
	set CtcpTpCode=$p(RowStr,del,1), CtcpTpDesc=$p(RowStr,del,2), CtcpTpType=$p(RowStr,del,3)

	quit:CtcpTpCode="" "医护人员类型代码为空"
	quit:$d(^CT("CPT",0,"Code",$$ALPHAUP^SSUTIL4(CtcpTpCode))) "医护人员类型代码已经存在:CtcpTpCode="_CtcpTpCode
	
	quit:CtcpTpDesc="" "医护人员类型名称为空"
	quit:$d(^CT("CPT",0,"Desc",$$ALPHAUP^SSUTIL4(CtcpTpDesc))) "医护人员类型名称已经存在:CtcpTpDesc="_CtcpTpDesc
	
	quit:CtcpTpType="" "医护人员类型的类型为空"
	quit:((CtcpTpType'="NURSE")&&(CtcpTpType'="DOCTOR")) "医护人员类型的类型不为NURSE或DOCTOR"
	
	TSTART
	k PLIST
	s PLIST(2)=$$ALPHAUP^SSUTIL4(CtcpTpCode)       //CTCPT_Code
	s PLIST(3)=$$ALPHAUP^SSUTIL4(CtcpTpDesc)	   //CTCPT_Desc
	s PLIST(5)=CtcpTpType					       //CTCPT_InternalType
	s PLIST(6)=+$h						           //CTCPT_DateFrom
	
	&sql(INSERT INTO SQLUser.CT_CarPrvTp VALUES PLIST())
	if SQLCODE'=0  TRollBack
	quit:SQLCODE "插入医护人员类型表失败!"
	
	TCOMMIT
    quit 0
}

/// Creator：      	wll
/// CreatDate：    	2016-05-25
/// Description： 	导入安全组
/// Table：        	SS_Group  
/// Input:			RowStr=GroupDesc
/// Return：       	ResultSet
/// w ##class(web.DHCCLDataCom).ImportSSGroup("","test安全组")
ClassMethod ImportSSGroup(ChangeType As %String = "", RowStr As %String = "") As %String
{
	quit:ChangeType="Clear" "数据已清:安全组"
	
	set del="^"
	set RowStr=$tr(RowStr," ","")
	set GroupDesc=$p(RowStr,del,1)

	quit:GroupDesc="" "安全组名称为空"
    set UserGroupDr="",GroupId=0,CircleFlag=1
	for  set GroupId=$order(^SSU("SSGRP",GroupId)) quit:((GroupId="")!(CircleFlag'=1))  do
	.set GroupName=$p(^SSU("SSGRP",GroupId),"^",1)
	.if GroupName=GroupDesc s CircleFlag=0  q
	quit:CircleFlag=0 "安全组名称已存在:GroupDesc="_GroupDesc
	
	TSTART
	k PLIST
	s PLIST(3)=GroupDesc	   //SSGRP_Desc

	&sql(INSERT INTO SQLUser.SS_Group VALUES PLIST())
	if SQLCODE'=0  TRollBack
	quit:SQLCODE "插入安全组表失败!"
	
	TCOMMIT
    quit 0
}

/// Creator：      	wll
/// CreatDate：    	2016-05-25
/// Description： 	导入基本单位数据
/// Table：        	CT_UOM
/// Input:			RowStr=CTUOMCode_"^"_CTUOMDesc_"^"_CTUOMForeignDesc
/// Return：       	ResultSet
/// w ##class(web.DHCCLDataCom).ImportUom("","testuom^测试单位^")
ClassMethod ImportUom(ChangeType As %String = "", RowStr As %String = "") As %String
{
	if ChangeType="Clear" do
	.K ^CT("UOM")
	
	quit:ChangeType="Clear" "数据已清:基本单位表"
	
	set del="^"
	set RowStr=$tr(RowStr," ","")
	set CTUOMCode=$p(RowStr,del,1), CTUOMDesc=$p(RowStr,del,2), CTUOMForeignDesc=$p(RowStr,del,3)
	
	quit:CTUOMCode="" "单位代码为空"
	quit:$d(^CT("UOM",0,"Code",$$ALPHAUP^SSUTIL4(CTUOMCode))) "单位代码已经存在:CTUOMCode="_CTUOMCode
	
	quit:CTUOMDesc="" "单位名称为空"
	quit:$d(^CT("UOM",0,"Desc",$$ALPHAUP^SSUTIL4(CTUOMDesc))) "单位名称已经存在:CTUOMDesc="_CTUOMDesc
	
	TSTART
	k PLIST
	s PLIST(2)=CTUOMCode     //CTUOM_Code
	s PLIST(3)=CTUOMDesc	      //CTUOM_Desc
	s PLiST(5)=CTUOMForeignDesc					  //CTUOM_ForeignDesc
	
	&sql(INSERT INTO SQLUser.CT_UOM VALUES PLIST())
	if SQLCODE'=0  TRollBack
	quit:SQLCODE "插入单位表失败!"
	
	TCOMMIT
    quit 0
}

/// Creator：      	wll
/// CreatDate：    	2016-06-28
/// Description： 	查找基本单位表数据
/// Table：        	CT_UOM
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCCLDataCom","FindCTUomData")
Query FindCTUomData(code As %String = "", desc As %String = "") As %Query(ROWSPEC = "CTUOMRowId,CTUOMCode,CTUOMDesc,CTUOMForeignDesc") [ SqlProc ]
{
}

ClassMethod FindCTUomDataExecute(ByRef qHandle As %Binary, code As %String = "", desc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	set CTUOMRowId=0
	for  set CTUOMRowId=$o(^CT("UOM",CTUOMRowId))  quit:CTUOMRowId=""  do	
		.set CTUOMCode=$p($g(^CT("UOM",CTUOMRowId)),"^",1)
		.quit:((code'="")&&(CTUOMCode'[code))	
		.set CTUOMDesc=$p($g(^CT("UOM",CTUOMRowId)),"^",2)
		.quit:((desc'="")&&(CTUOMDesc'[desc))
		.set CTUOMForeignDesc=$p($g(^CT("UOM",CTUOMRowId)),"^",3) 
		.do OutputRow	
	
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow
 	Set Data=$lb(CTUOMRowId,CTUOMCode,CTUOMDesc,CTUOMForeignDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindCTUomDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCTUomDataExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindCTUomDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCTUomDataExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Creator：      	wll
/// CreatDate：    	2016-05-25
/// Description： 	导入单位转换表数据
/// Table：        	CT_ConFac
/// Input:			RowStr=CTCFFrUOM_"^"_CTCFFactor_"^"_CTCFToUOM
/// Return：       	ResultSet
/// w ##class(web.DHCCLDataCom).ImportUomConFac("","testuom^14^g")
ClassMethod ImportUomConFac(ChangeType As %String = "", RowStr As %String = "") As %String
{
	if ChangeType="Clear" do
	.K ^CT("CTCF")
	
	quit:ChangeType="Clear" "数据已清:单位转换表"
	
	set del="^"
	set RowStr=$tr(RowStr," ","")
	set CTCFFrUOM=$p(RowStr,del,1),CTCFFactor=$p(RowStr,del,2), CTCFToUOM=$p(RowStr,del,3)
	
	quit:CTCFFrUOM="" "被转换单位为空"
	set CTCFFrUOMDR=$o(^CT("UOM",0,"Code",$$ALPHAUP^SSUTIL4(CTCFFrUOM),""))
	quit:CTCFFrUOMDR="" "被转换单位不存在基本单位表中:Code="_CTCFFrUOM
	
	quit:CTCFToUOM="" "转换单位为空"
	set CTCFToUOMDR=$o(^CT("UOM",0,"Code",$$ALPHAUP^SSUTIL4(CTCFToUOM),""))
	quit:CTCFToUOMDR="" "转换单位不存在基本单位表中:Code="_CTCFToUOM
	
	quit:CTCFFactor="" "转换系数为空:Code="_CTCFFromUOM
	
	TSTART
	k PLIST
	s PLIST(2)=CTCFFrUOMDR
    s PLIST(3)=CTCFToUOMDR
	s PLIST(4)=CTCFFactor
	s PLIST(6)="Y"
	
	&sql(INSERT INTO SQLUser.CT_ConFac VALUES PLIST())
	if SQLCODE'=0  TRollBack
	quit:SQLCODE "插入单位转换表失败!"
	
	
	TCOMMIT
    quit 0
}

/// Creator：      	wll
/// CreatDate：    	2016-06-28
/// Description： 	查找单位转换表数据
/// Table：        	CT_ConFac
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCCLDataCom","FindConFacData")
Query FindConFacData(fromuom As %String = "", touom As %String = "") As %Query(ROWSPEC = "CTCFRowId,CTCFFrUOMDR,CTCFFrUOM,CTCFToUOMDR,CTCFToUOM,CTCFFactor,CTCFActiveFlag") [ SqlProc ]
{
}

ClassMethod FindConFacDataExecute(ByRef qHandle As %Binary, fromuom As %String = "", touom As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	set CTCFRowId=0
	for  set CTCFRowId=$o(^CT("CTCF",CTCFRowId))  quit:CTCFRowId=""  do	
		.set CTCFFrUOMDR=$p($g(^CT("CTCF",CTCFRowId)),"^",1)
		.if CTCFFrUOMDR'="" set CTCFFrUOM=$p($g(^CT("UOM",CTCFFrUOMDR)),"^",2)
		.else  set CTCFFrUOM=""
		.quit:((fromuom'="")&&(CTCFFrUOM'[fromuom))
		.set CTCFToUOMDR=$p($g(^CT("CTCF",CTCFRowId)),"^",2)
		.if CTCFToUOMDR'="" set CTCFToUOM=$p($g(^CT("UOM",CTCFToUOMDR)),"^",2)
		.else  set CTCFToUOM=""
		.quit:((touom'="")&&(CTCFToUOM'[touom))
		.set CTCFFactor=$p($g(^CT("CTCF",CTCFRowId)),"^",3)
		.set CTCFActiveFlag=$p($g(^CT("CTCF",CTCFRowId)),"^",4)
		.do OutputRow	
	
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow
 	Set Data=$lb(CTCFRowId,CTCFFrUOMDR,CTCFFrUOM,CTCFToUOMDR,CTCFToUOM,CTCFFactor,CTCFActiveFlag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindConFacDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindConFacDataExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindConFacDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindConFacDataExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Creator：      	wll
/// CreatDate：    	2016-05-25
/// Description： 	导入频次表
/// Table：        	PHC_Freq,PHC_DispensingTime
/// Input:			RowStr=PHCFRCode_"^"_PHCFRDesc_"^"_PHCFRFactor_"^"_PHCDTTimes
/// Return：       	ResultSet
/// w ##class(web.DHCCLDataCom).ImportPHCFreq("","testQD^测试QD^1^16:00-22:00")
ClassMethod ImportPHCFreq(ChangeType As %String = "", RowStr As %String = "") As %String
{
	if ChangeType="Clear" do
	.K ^PHCFR
	
	quit:ChangeType="Clear" "数据已清:频次表"
	
	set del="^"
	set RowStr=$tr(RowStr," ","")
	set PHCFRCode=$p(RowStr,del,1), PHCFRDesc=$p(RowStr,del,2), PHCFRFactor=$p(RowStr,del,3),PHCDTTimes=$p(RowStr,del,4)
	
	quit:PHCFRCode="" "频次代码为空"
	quit:$d(^PHCFR(0,"Code",$$ALPHAUP^SSUTIL4(PHCFRCode))) "频次代码已经存在:PHCFRCode="_PHCFRCode
	
	quit:PHCFRDesc="" "频次描述为空"
	quit:$d(^PHCFR(0,"Desc",$$ALPHAUP^SSUTIL4(PHCFRDesc))) "单位名称已经存在:PHCFRDesc="_PHCFRDesc
	
	quit:PHCFRFactor="" "转换系数为空"_PHCFRDesc
	
	TSTART
	k PLIST
	s PLIST(2)=PHCFRCode      //PHC_FRCode
	s PLIST(3)=PHCFRFactor	                      //PHC_FRFactor
	s PLIST(4)=PHCFRDesc		  //PHC_FRDesc1
	s PLIST(5)=PHCFRDesc       //PHC_FRDesc2
	
	&sql(INSERT INTO SQLUser.PHC_Freq VALUES PLIST())
	if SQLCODE'=0  TRollBack
	quit:SQLCODE "-1^插入频次表失败!"
	set PHCFRRowId=$g(%ROWID)
	
	if $g(PHCDTTimes)'="" do
	    .set num=$l(PHCDTTimes,"-")
	    .set PHCDTTime=""
	    .for i=1:1:num do
	        ..set PHCDTTime=$p(PHCDTTimes,"-",i)
	        ..quit:PHCDTTime=""
	        ..set PHCDTTime=$zth(PHCDTTime)
	        ..K PLIST
	        ..set PLIST(0)=PHCFRRowId,PLIST(3)=PHCDTTime
	        ..&sql(INSERT INTO SQLUSER.PHC_DispensingTime VALUES :PLIST())
	        ..if SQLCODE'=0  TRollBack
	        ..quit:SQLCODE_"-2^插入频次时间表失败"
	TCOMMIT
    quit 0
}

/// Creator：      	wll
/// CreatDate：    	2016-06-28
/// Description： 	查找频次表数据
/// Table：        	PHC_Freq,PHC_DispensingTime
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCCLDataCom","FindFreqData")
Query FindFreqData(code As %String = "", desc As %String = "") As %Query(ROWSPEC = "PHCFRRowId,PHCFRCode,PHCFRDesc1,PHCFRDesc2,PHCFRFactor,PHCFRTimes") [ SqlProc ]
{
}

ClassMethod FindFreqDataExecute(ByRef qHandle As %Binary, code As %String = "", desc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	set PHCFRRowId=0
	for  set PHCFRRowId=$o(^PHCFR(PHCFRRowId))  quit:PHCFRRowId=""  do
	    .set PHCFRCode=$p($g(^PHCFR(PHCFRRowId)),"^",1)
	    .quit:(($$ALPHAUP^SSUTIL4(code)'="")&&($$ALPHAUP^SSUTIL4(PHCFRCode)'[$$ALPHAUP^SSUTIL4(code)))
	    .set PHCFRFactor=$p($g(^PHCFR(PHCFRRowId)),"^",2)
	    .set PHCFRDesc1=$p($g(^PHCFR(PHCFRRowId)),"^",3)
	    .quit:((desc'="")&&(PHCFRDesc1'[desc))
	    .set PHCFRDesc2=$p($g(^PHCFR(PHCFRRowId)),"^",4)
	    .set subchild=0,PHCFRTimes=""
	    .for  set subchild=$o(^PHCFR(PHCFRRowId,"DT",subchild))  quit:subchild=""  do
	    ..set PHCDTTime=$p($g(^PHCFR(PHCFRRowId,"DT",subchild)),"^",1)
	    ..if PHCDTTime'="" set PHCDTTime=$zt(PHCDTTime,2)
	    ..if PHCFRTimes=""  set PHCFRTimes=PHCDTTime
	    ..else  set PHCFRTimes=PHCFRTimes_"-"_PHCDTTime
		.do OutputRow	
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow
 	Set Data=$lb(PHCFRRowId,PHCFRCode,PHCFRDesc1,PHCFRDesc2,PHCFRFactor,PHCFRTimes)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindFreqDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindFreqDataExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindFreqDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindFreqDataExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Creator：      	wll
/// CreatDate：    	2016-05-25
/// Description： 	导入用法表
/// Table：        	PHC_Instruc
/// Input:			RowStr=PHCINCode_"^"_PHCINDesc
/// Return：       	ResultSet
/// d ##class(web.DHCCLDataCom).ImportPHCInstruct("",RowStr)
ClassMethod ImportPHCInstruct(ChangeType As %String = "", RowStr As %String = "") As %String
{
	if ChangeType="Clear" do
	.K ^PHCIN
	
	quit:ChangeType="Clear" "数据已清:用法表"
	
	set del="^"
	set RowStr=$tr(RowStr," ","")
	set PHCINCode=$p(RowStr,del,1), PHCINDesc=$p(RowStr,del,2)
	
	quit:PHCINCode="" "用法代码为空"
	quit:$d(^PHCIN(0,"Code",$$ALPHAUP^SSUTIL4(PHCINCode))) "用法代码已经存在:PHCINCode="_PHCINCode
	
	quit:PHCINDesc="" "用法描述为空"
	quit:$d(^PHCIN(0,"Desc",$$ALPHAUP^SSUTIL4(PHCINDesc))) "用法描述已经存在:PHCINDesc="_PHCINDesc
	
	
	TSTART
	k PLIST
	s PLIST(2)=PHCINCode       //PHCIN_Code
	s PLIST(3)=PHCINDesc	  //PHCIN_Desc1
	
	&sql(INSERT INTO SQLUser.PHC_Instruc VALUES PLIST())
	if SQLCODE'=0  TRollBack
	quit:SQLCODE "-1^插入用法表失败!"

	TCOMMIT
    quit 0
}

/// Creator：      	wll
/// CreatDate：    	2016-06-28
/// Description： 	查找用法表数据
/// Table：        	PHC_Instruc
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCCLDataCom","FindInstrucData")
Query FindInstrucData(code As %String = "", desc As %String = "") As %Query(ROWSPEC = "PHCINRowId,PHCINCode,PHCINDesc1,PHCINDesc2") [ SqlProc ]
{
}

ClassMethod FindInstrucDataExecute(ByRef qHandle As %Binary, code As %String = "", desc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	set PHCINRowId=0
	for  set PHCINRowId=$o(^PHCIN(PHCINRowId))  quit:PHCINRowId=""  do
	    .set PHCINCode=$p($g(^PHCIN(PHCINRowId)),"^",1)
	    .quit:(($$ALPHAUP^SSUTIL4(code)'="")&&($$ALPHAUP^SSUTIL4(PHCINCode)'[$$ALPHAUP^SSUTIL4(code)))
	    .set PHCINDesc1=$p($g(^PHCIN(PHCINRowId)),"^",2)
	    .quit:((desc'="")&&(PHCINDesc1'[desc))
	    .set PHCINDesc2=$p($g(^PHCIN(PHCINRowId)),"^",3)
		.do OutputRow	
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow
 	Set Data=$lb(PHCINRowId,PHCINCode,PHCINDesc1,PHCINDesc2)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindInstrucDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInstrucDataExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindInstrucDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInstrucDataExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Creator：      	wll
/// CreatDate：    	2016-05-25
/// Description： 	导入药品剂型表
/// Table：        	PHC_FORM
/// Input:			RowStr=PHCFCode_"^"_PHCFDesc
/// Return：       	ResultSet
/// d ##class(web.DHCCLDataCom).ImportPHCForm("",RowStr)
ClassMethod ImportPHCForm(ChangeType As %String = "", RowStr As %String = "") As %String
{
	if ChangeType="Clear" do
	.K ^PHCF
	
	quit:ChangeType="Clear" "数据已清:药品剂型"
	
	set del="^"
	set RowStr=$tr(RowStr," ","")
	set PHCFCode=$p(RowStr,del,1), PHCFDesc=$p(RowStr,del,2)
	
	quit:PHCFCode="" "药品剂型代码为空"
	quit:$d(^PHCF(0,"Code",$$ALPHAUP^SSUTIL4(PHCFCode))) "药品剂型代码已经存在:PHCFCode="_PHCFCode
	
	quit:PHCFDesc="" "药品剂型描述为空"
	quit:$d(^PHCF(0,"Desc",$$ALPHAUP^SSUTIL4(PHCFDesc))) "药品剂型描述已经存在:PHCFDesc="_PHCFDesc
	
	
	TSTART
	k PLIST
	s PLIST(2)=PHCFCode       //PHCF_Code
	s PLIST(3)=PHCFDesc 	     //PHCF_Desc
	
	&sql(INSERT INTO SQLUser.PHC_FORM VALUES PLIST())
	if SQLCODE'=0  TRollBack
	quit:SQLCODE "插入药品剂型失败!"

	TCOMMIT
    quit 0
}

/// Creator：      	wll
/// CreatDate：    	2016-06-28
/// Description： 	查找药品剂型表数据
/// Table：        	PHC_FORM
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCCLDataCom","FindPHCFormData")
Query FindPHCFormData(code As %String = "", desc As %String = "") As %Query(ROWSPEC = "PHCFRowId,PHCFCode,PHCFDesc") [ SqlProc ]
{
}

ClassMethod FindPHCFormDataExecute(ByRef qHandle As %Binary, code As %String = "", desc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	set PHCFRowId=0
	for  set PHCFRowId=$o(^PHCF(PHCFRowId))  quit:PHCFRowId=""  do
	    .set PHCFCode=$p($g(^PHCF(PHCFRowId)),"^",1)
	    .quit:(($$ALPHAUP^SSUTIL4(code)'="")&&($$ALPHAUP^SSUTIL4(PHCFCode)'[$$ALPHAUP^SSUTIL4(code)))
	    .set PHCFDesc=$p($g(^PHCF(PHCFRowId)),"^",1)
	    .quit:((desc'="")&&(PHCFDesc'[desc))
		.do OutputRow	
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow
 	Set Data=$lb(PHCFRowId,PHCFCode,PHCFDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindPHCFormDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPHCFormDataExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPHCFormDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPHCFormDataExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Creator：      	wll
/// CreatDate：    	2016-05-25
/// Description： 	导入药理学分类
/// Table：        	PHC_SubCat
/// Input:			RowStr=PHCCDesc_"^"_PHCSCCode_"^"_PHCSCDesc
/// Return：       	ResultSet
/// d ##class(web.DHCCLDataCom).ImportPHCSubCat("",RowStr)
ClassMethod ImportPHCSubCat(ChangeType As %String = "", RowStr As %String = "") As %String
{
	if ChangeType="Clear" do
	.K ^PHCC
	
	quit:ChangeType="Clear" "数据已清:药理学分类"
	
	set del="^"
	set RowStr=$tr(RowStr," ","")
	set PHCCDesc=$p(RowStr,del,1), PHCSCCode=$p(RowStr,del,2),PHCSCDesc=$p(RowStr,del,3)
	
	quit:PHCCDesc="" "药理学大类为空"
	set PHCCRowid=$o(^PHCC(0,"Desc",$$ALPHAUP^SSUTIL4(PHCCDesc),""))
	quit:PHCCRowid="" "药理学大类描述对应ID为空"_PHCCDesc
	
	quit:PHCSCCode="" "药理学分类代码为空"
	quit:$d(^PHCC("SC_Code",$$ALPHAUP^SSUTIL4(PHCSCCode),PHCCRowid)) "药理学分类代码已经存在:PHCSCCode="_PHCSCCode
	
	quit:PHCSCDesc="" "药理学分类描述为空"
	quit:$d(^PHCC("SC_Desc",$$ALPHAUP^SSUTIL4(PHCSCDesc),PHCCRowid)) "药理学分类描述已经存在:PHCSCDesc="_PHCSCDesc
	
	
	TSTART
	k PLIST
	s PLIST(0)=PHCCRowid                         //PHCSC_PHCC_ParRef
	s PLIST(2)=$$ALPHAUP^SSUTIL4(PHCSCCode)      //PHCSC_Code
	s PLIST(3)=$$ALPHAUP^SSUTIL4(PHCSCDesc) 	 //PHCSC_Desc
	
	&sql(INSERT INTO SQLUser.PHC_SubCat VALUES PLIST())
	if SQLCODE'=0  TRollBack
	quit:SQLCODE "插入药理学分类失败!"

	TCOMMIT
    quit 0
}

/// Creator：      	wll
/// CreatDate：    	2016-05-25
/// Description： 	导入医嘱子类
/// Table：        	ARC_ItemCat 
/// Input:			RowStr=ARCICCode_"^"_ARCICDesc_"^"_ARCICOrderType
/// Return：       	ResultSet
/// d ##class(web.DHCCLDataCom).ImportARCItemCat("",RowStr)
ClassMethod ImportARCItemCat(ChangeType As %String = "", RowStr As %String = "") As %String
{
	if ChangeType="Clear" do
	.K ^ARC("IC")
	
	quit:ChangeType="Clear" "数据已清:医嘱子分类"
	
	set del="^"
	set RowStr=$tr(RowStr," ","")
	set ARCICCode=$p(RowStr,del,1), ARCICDesc=$p(RowStr,del,2),ARCICOrderType=$p(RowStr,del,3)
	set ORCATDesc=$p(RowStr,del,4),ARCICCalcQtyFlag=$p(RowStr,del,5)
	
    quit:ORCATDesc="" "医嘱分类为空"
	set ORCATRowid=$o(^OEC("ORCAT",0,"Desc",$$ALPHAUP^SSUTIL4(ORCATDesc),""))
	quit:ORCATRowid="" "医嘱分类描述对应ID为空"_ORCATDesc
	
	quit:ARCICCode="" "医嘱子分类代码为空"
	quit:$d(^ARC("IC",0,"Code",$$ALPHAUP^SSUTIL4(ARCICCode))) "医嘱子分类代码已经存在:ARCICCode="_ARCICCode
	
	quit:ARCICDesc="" "医嘱子分类描述为空"
	quit:$d(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(ARCICDesc))) "医嘱子分类描述已经存在:ARCICDesc="_ARCICDesc
	
	quit:ARCICOrderType="" "医嘱类型为空"
	set typestr="R^D^I^C^N^T^L^X^P^B^S^H^E^A^F^DTF^BM^PROS"
	quit:("^"_typestr_"^")'[("^"_ARCICOrderType_"^") "医嘱类型填写有误"
	
	quit:ARCICCalcQtyFlag="" "计算标志为空"
	set qtystr="Y^N"
	quit:("^"_qtystr_"^")'[("^"_ARCICCalcQtyFlag_"^") "计算标志填写有误"
	
	TSTART
	k PLIST
	s PLIST(2)=$$ALPHAUP^SSUTIL4(ARCICCode)     //ARCIC_Code
	s PLIST(3)=$$ALPHAUP^SSUTIL4(ARCICDesc)	 //ARCIC_Desc
	s PLIST(8)=ARCICOrderType                    //ARCIC_OrderType
	s PLIST(9)=ORCATRowid                            //ARCIC_OrdCat_DR
	s PLIST(12)=ARCICCalcQtyFlag                        //ARCIC_CalcQtyFlag
	
	&sql(INSERT INTO SQLUser.ARC_ItemCat VALUES PLIST())
	if SQLCODE'=0  TRollBack
	quit:SQLCODE "插入医嘱子类失败"

	TCOMMIT
    quit 0
}

/// Creator：      	wll
/// CreatDate：    	2016-06-28
/// Description： 	查找医嘱子类表数据
/// Table：        	ARC_ItemCat
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCCLDataCom","FindItemCatData")
Query FindItemCatData(code As %String = "", desc As %String = "") As %Query(ROWSPEC = "ARCICRowId,ARCICCode,ARCICDesc,ARCICOrderType,ARCICOrdCat,ARCICCalcQtyFlag") [ SqlProc ]
{
}

ClassMethod FindItemCatDataExecute(ByRef qHandle As %Binary, code As %String = "", desc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	set ARCICRowId=0
	for  set ARCICRowId=$o(^ARC("IC",ARCICRowId))  quit:ARCICRowId=""  do
	    .set ARCICCode=$p($g(^ARC("IC",ARCICRowId)),"^",1)
	    .quit:(($$ALPHAUP^SSUTIL4(code)'="")&&($$ALPHAUP^SSUTIL4(ARCICCode)'[$$ALPHAUP^SSUTIL4(code)))
	    .set ARCICDesc=$p($g(^ARC("IC",ARCICRowId)),"^",2)
	    .quit:((desc'="")&&(ARCICDesc'[desc))
	    .set ARCICOrderType=$p($g(^ARC("IC",ARCICRowId)),"^",7)
	    .set ARCICOrdCatDR=$p($g(^ARC("IC",ARCICRowId)),"^",8)
	    .if ARCICOrdCatDR'="" set ARCICOrdCat=$p($g(^OEC("ORCAT",ARCICOrdCatDR)),"^",2)
	    .else  set ARCICOrdCat=""
	    .set ARCICCalcQtyFlag=$p($g(^ARC("IC",ARCICRowId)),"^",11)
		.do OutputRow	
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow
 	Set Data=$lb(ARCICRowId,ARCICCode,ARCICDesc,ARCICOrderType,ARCICOrdCat,ARCICCalcQtyFlag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindItemCatDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindItemCatDataExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindItemCatDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindItemCatDataExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Creator：      	wll
/// CreatDate：    	2016-05-30
/// Description： 	导入检验项目表
/// Table：        	DHC_CLC_LabTestCode 
/// Input:			RowStr=CLCLTCCode_"^"_CLCLTCDesc_"^"_CLCLTCAbbrev_"^"_CLCLTCStandardCode
/// Return：       	ResultSet
/// w ##class(web.DHCCLDataCom).ImportLabTestCode("","BNP^脑钠肽^BNP^BNP")
ClassMethod ImportLabTestCode(ChangeType As %String = "", RowStr As %String = "") As %String
{
	if ChangeType="Clear" do
	.K ^DHCCLC("LabTestCode")
	
	quit:ChangeType="Clear" "数据已清:检验项目表"
	
	set del="^"
	set RowStr=$tr(RowStr," ","")
	set CLCLTCCode=$p(RowStr,del,1), CLCLTCDesc=$p(RowStr,del,2),CLCLTCAbbrev=$p(RowStr,del,3),CLCLTCStandardCode=$p(RowStr,del,4)
	
	quit:CLCLTCCode="" "检验项目表代码为空"
	set CLCLTCRowId=0,CircleFlag=1
	for  set CLCLTCRowId=$order(^DHCCLC("LabTestCode",CLCLTCRowId)) quit:((CLCLTCRowId="")!(CircleFlag'=1))  do
	.set Code=$listget(^DHCCLC("LabTestCode",CLCLTCRowId),1)
	.if Code=CLCLTCCode set CircleFlag=0 q
	quit:CircleFlag=0 "检验项目表代码已经存在:CLCLTCCode="_CLCLTCCode
	
	quit:CLCLTCDesc="" "检验项目表描述为空"
	quit:CLCLTCStandardCode="" "检验项目表标准代码为空"
	
	TSTART
	k PLIST
	s PLIST(2)=CLCLTCCode                    //CLCLTC_Code
	s PLIST(3)=CLCLTCDesc 	                 //CLCLTC_Desc
	s PLIST(4)=CLCLTCAbbrev                  //CLCLTC_Abbrev
	s PLIST(5)=CLCLTCStandardCode            //CLCLTC_StandardCode
	
	&sql(INSERT INTO SQLUser.DHC_CLC_LabTestCode VALUES PLIST())
	if SQLCODE'=0  TRollBack
	quit:SQLCODE "插入检验项目表失败"

	TCOMMIT
    quit 0
}

/// Creator：      	wll
/// CreatDate：    	2016-06-28
/// Description： 	查找检验项目表数据
/// Table：        	DHC_CLC_LabTestCode
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCCLDataCom","FindLabTestCodeData")
Query FindLabTestCodeData(code As %String = "", desc As %String = "") As %Query(ROWSPEC = "CLCLTCRowId,CLCLTCCode,CLCLTCDesc,CLCLTCAbbrev,CLCLTCStandardCode") [ SqlProc ]
{
}

ClassMethod FindLabTestCodeDataExecute(ByRef qHandle As %Binary, code As %String = "", desc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	set CLCLTCRowId=0
	for  set CLCLTCRowId=$o(^DHCCLC("LabTestCode",CLCLTCRowId))  quit:CLCLTCRowId=""  do
	    .set CLCLTCCode=$lg(^DHCCLC("LabTestCode",CLCLTCRowId),1)
	    .quit:(($$ALPHAUP^SSUTIL4(code)'="")&&($$ALPHAUP^SSUTIL4(CLCLTCCode)'[$$ALPHAUP^SSUTIL4(code)))
	    .set CLCLTCDesc=$lg(^DHCCLC("LabTestCode",CLCLTCRowId),2)
	    .quit:((desc'="")&&(CLCLTCDesc'[desc))
	    .set CLCLTCAbbrev=$lg(^DHCCLC("LabTestCode",CLCLTCRowId),3)
	    .set CLCLTCStandardCode=$lg(^DHCCLC("LabTestCode",CLCLTCRowId),4)
		.do OutputRow	
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow
 	Set Data=$lb(CLCLTCRowId,CLCLTCCode,CLCLTCDesc,CLCLTCAbbrev,CLCLTCStandardCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindLabTestCodeDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLabTestCodeDataExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindLabTestCodeDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLabTestCodeDataExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Creator：      	wll
/// CreatDate：    	2016-05-30
/// Description： 	导入检验标本类型表
/// Table：        	DHC_CLC_LabSpecimen 
/// Input:			RowStr=CLCLSTCode_"^"_CLCLSTDesc
/// Return：       	ResultSet
/// w ##class(web.DHCCLDataCom).ImportLabSpecimen("","血浆^血浆")
ClassMethod ImportLabSpecimen(ChangeType As %String = "", RowStr As %String = "") As %String
{
	if ChangeType="Clear" do
	.K ^DHCCLC("LabSpecimen")
	
	quit:ChangeType="Clear" "数据已清:检验标本类型表"
	
	set del="^"
	set RowStr=$tr(RowStr," ","")
	set CLCLSTCode=$p(RowStr,del,1), CLCLSTDesc=$p(RowStr,del,2)
	
	quit:CLCLSTCode="" "检验标本类型表代码为空"
	set CLCLSTRowId=0,CircleFlag=1
	for  set CLCLSTRowId=$order(^DHCCLC("LabSpecimen",CLCLSTRowId)) quit:((CLCLSTRowId="")!(CircleFlag'=1))  do
	.set Code=$listget(^DHCCLC("LabSpecimen",CLCLSTRowId),1)
	.if Code=CLCLSTCode set CircleFlag=0 q
	quit:CircleFlag=0 "检验标本类型表代码已经存在:CLCLSTCode="_CLCLSTCode
	
	quit:CLCLSTDesc="" "检验标本类型表描述为空"
	
	TSTART
	k PLIST
	s PLIST(2)=CLCLSTCode                    //CLCLST_Code
	s PLIST(3)=CLCLSTDesc 	                 //CLCLST_Desc
	
	&sql(INSERT INTO SQLUser.DHC_CLC_LabSpecimen VALUES PLIST())
	if SQLCODE'=0  TRollBack
	quit:SQLCODE "插入检验标本类型表失败"

	TCOMMIT
    quit 0
}

/// Creator：      	wll
/// CreatDate：    	2016-06-28
/// Description： 	查找检验标本类型表数据
/// Table：        	DHC_CLC_LabSpecimen
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCCLDataCom","FindLabSpecimenData")
Query FindLabSpecimenData(code As %String = "", desc As %String = "") As %Query(ROWSPEC = "CLCLSTRowId,CLCLSTCode,CLCLSTDesc") [ SqlProc ]
{
}

ClassMethod FindLabSpecimenDataExecute(ByRef qHandle As %Binary, code As %String = "", desc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	set CLCLSTRowId=0
	for  set CLCLSTRowId=$o(^DHCCLC("LabSpecimen",CLCLSTRowId))  quit:CLCLSTRowId=""  do
	    .set CLCLSTCode=$lg(^DHCCLC("LabSpecimen",CLCLSTRowId),1)
	    .quit:(($$ALPHAUP^SSUTIL4(code)'="")&&($$ALPHAUP^SSUTIL4(CLCLSTCode)'[$$ALPHAUP^SSUTIL4(code)))
	    .set CLCLSTDesc=$lg(^DHCCLC("LabSpecimen",CLCLSTRowId),2)
	    .quit:((desc'="")&&(CLCLSTDesc'[desc))
		.do OutputRow	
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow
 	Set Data=$lb(CLCLSTRowId,CLCLSTCode,CLCLSTDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindLabSpecimenDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLabSpecimenDataExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindLabSpecimenDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLabSpecimenDataExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Creator：      	wll
/// CreatDate：    	2016-05-20
/// Description： 	查找科室数据导入后的数据
/// Table：        	CT_Loc
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCCLDataCom","FindImportLocData")
Query FindImportLocData(code As %String = "", desc As %String = "", type As %String = "") As %Query(ROWSPEC = "RowId,LocCode,LocDesc,LocType,HospitalCode,LocTel,LocContactName,ActiveDate,ActiveDateTo") [ SqlProc ]
{
}

ClassMethod FindImportLocDataExecute(ByRef qHandle As %Binary, code As %String = "", desc As %String = "", type As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	if (desc'="") s desc=$ZCONVERT(desc,"U")
	set CTLOCRowID=0
	for  set CTLOCRowID=$order(^CTLOC(CTLOCRowID)) quit:CTLOCRowID=""  do
	    .set CTLOCCode=$p($g(^CTLOC(CTLOCRowID)),"^",1) 		//科室代码
		.quit:((code'="")&&(CTLOCCode'[code))
		.set CTLOCDesc=$p($g(^CTLOC(CTLOCRowID)),"^",2)      //科室名称
		.quit:((desc'="")&&(CTLOCDesc'[desc))
		.set CTLOCType=$p($g(^CTLOC(CTLOCRowID)),"^",13)     //科室类型
		.quit:((type'="")&&(CTLOCType'=type))
		.set CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22) 	//医院
		.set CTLOCTelephoneExt=$p($g(^CTLOC(CTLOCRowID)),"^",41)  //电话
		.set CTLOCContactName=$p($g(^CTLOC(CTLOCRowID)),"^",43)   //助记码
		.set CTLOCDateActiveFrom=$p($g(^CTLOC(CTLOCRowID)),"^",24)
		.if (CTLOCDateActiveFrom'="") s CTLOCDateActiveFrom=$zd(CTLOCDateActiveFrom,3)
		.set CTLOCDateActiveTo=$p($g(^CTLOC(CTLOCRowID)),"^",25)
		.if (CTLOCDateActiveTo'="") s CTLOCDateActiveTo=$zd(CTLOCDateActiveTo,3)
		.do OutputRow		
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow
 	Set Data=$lb(CTLOCRowID,CTLOCCode,CTLOCDesc,CTLOCType,CTLOCHospitalDR,CTLOCTelephoneExt,CTLOCContactName,CTLOCDateActiveFrom,CTLOCDateActiveTo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindImportLocDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindImportLocDataExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindImportLocDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindImportLocDataExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Creator：      	wll
/// CreatDate：    	2016-05-20
/// Description： 	查找医护人员类型数据
/// Table：        	CT_CarPrvTp
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCCLDataCom","FindPrvTpData")
Query FindPrvTpData(code As %String = "", desc As %String = "") As %Query(ROWSPEC = "CTCPTRowId,CTCPTCode,CTCPTDesc,CTCPTInternalType,CTCPTDateFrom,CTCPTDateTo") [ SqlProc ]
{
}

ClassMethod FindPrvTpDataExecute(ByRef qHandle As %Binary, code As %String = "", desc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	set CTCPTRowId=0
	for  set CTCPTRowId=$o(^CT("CPT",CTCPTRowId))  quit:CTCPTRowId=""  do	
		.set CTCPTCode=$p($g(^CT("CPT",CTCPTRowId)),"^",1)
		.quit:((code'="")&&(CTCPTCode'[code))	
		.set CTCPTDesc=$p($g(^CT("CPT",CTCPTRowId)),"^",2)
		.quit:((desc'="")&&(CTCPTDesc'[desc))
		.set CTCPTInternalType=$p($g(^CT("CPT",CTCPTRowId)),"^",4) 
		.set CTCPTDateFrom=$p($g(^CT("CPT",CTCPTRowId)),"^",5)
		.if CTCPTDateFrom'="" s CTCPTDateFrom=$zd(CTCPTDateFrom,3)
		.set CTCPTDateTo=$p($g(^CT("CPT",CTCPTRowId)),"^",6)
		.if CTCPTDateTo'="" s CTCPTDateTo=$zd(CTCPTDateTo,3)
		.do OutputRow	
	
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow
 	Set Data=$lb(CTCPTRowId,CTCPTCode,CTCPTDesc,CTCPTInternalType,CTCPTDateFrom,CTCPTDateTo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindPrvTpDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPrvTpDataExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPrvTpDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPrvTpDataExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Creator：      	wll
/// CreatDate：    	2016-05-20
/// Description： 	查找医护人员数据导入后的数据
/// Table：        	CT_CareProv
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCCLDataCom","FindImportCareProvData")
Query FindImportCareProvData(code As %String = "", desc As %String = "", type As %String = "", status As %String = "") As %Query(ROWSPEC = "RowId,CtcpCode,CtcpDesc,CtcpType,CtcpActiveFlag,CtcpOtherName,CtcpDateActiveFrom,CtcpDateActiveTo") [ SqlProc ]
{
}

ClassMethod FindImportCareProvDataExecute(ByRef qHandle As %Binary, code As %String = "", desc As %String = "", type As %String = "", status As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
    if (code'="") s code=$ZCONVERT(code,"U")
	if (desc'="") s desc=$ZCONVERT(desc,"U")
	set CTPCPRowId=0
	for  set CTPCPRowId=$order(^CTPCP(CTPCPRowId)) quit:(CTPCPRowId="")  d	
		.set CTPCPCode=$p($g(^CTPCP(CTPCPRowId,1)),"^",1)       //工号
		.set CTPCPDesc=$p($g(^CTPCP(CTPCPRowId,1)),"^",2)       //姓名
		.set CTPCPCode1=$ZCONVERT(CTPCPCode,"U")
		.quit:((code'="")&&(CTPCPCode1'[code))
		.set CTPCPDesc1=$ZCONVERT(CTPCPDesc,"U")
		.quit:((desc'="")&&(CTPCPDesc1'[desc))
		.set CTPCPCarPrvTpDR=$p($g(^CTPCP(CTPCPRowId,1)),"^",4)    //人员类型ID
		.quit:((type'="")&&(CTPCPCarPrvTpDR'=type))
		.if (CTPCPCarPrvTpDR'="") s CTCPTDesc=$p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",2) //人员类型		
		.else  set CTCPTDesc=""
		.set CTPCPActiveFlag=$p($g(^CTPCP(CTPCPRowId,1)),"^",9)      //是否激活
		.quit:((status'="")&&(CTPCPActiveFlag'=status))
		.set CTPCPOtherName=$p($g(^CTPCP(CTPCPRowId,3)),"^",28)  //别名
		.set CTPCPDateActiveFrom=$p($g(^CTPCP(CTPCPRowId,2)),"^",14)    //激活时间
		.if (CTPCPDateActiveFrom'="") set CTPCPDateActiveFrom=$zd(CTPCPDateActiveFrom,3)
		.set CTPCPDateActiveTo=$p($g(^CTPCP(CTPCPRowId,2)),"^",15)     //截止时间
		.if (CTPCPDateActiveTo'="") set CTPCPDateActiveTo=$zd(CTPCPDateActiveTo,3)
		.do OutputRow	
	
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow
 	Set Data=$lb(CTPCPRowId,CTPCPCode,CTPCPDesc,CTCPTDesc,CTPCPActiveFlag,CTPCPOtherName,CTPCPDateActiveFrom,CTPCPDateActiveTo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindImportCareProvDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindImportCareProvDataExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindImportCareProvDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindImportCareProvDataExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Creator：      	wll
/// CreatDate：    	2016-05-23
/// Description： 	查找医嘱子分类内容
/// Table：        	ARC_ItemCat
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCCLDataCom","FindARCItemCatData")
Query FindARCItemCatData(code As %String = "", desc As %String = "") As %Query(ROWSPEC = "ARCICRowId,ARCICCode,ARCICDesc,ARCICOrderType,ARCICOrdCatDR,ARCICOrdCatDesc,ARCICExecCategDR,ARCICExecCategDesc") [ SqlProc ]
{
}

ClassMethod FindARCItemCatDataExecute(ByRef qHandle As %Binary, code As %String = "", desc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
			
	if (code'="") s code=$ZCONVERT(code,"U") //转换成大写
	if (desc'="") s desc=$ZCONVERT(desc,"U") //转换成大写
	s ARCICRowId=0
	for  set ARCICRowId=$o(^ARC("IC",ARCICRowId)) quit:ARCICRowId=""  do
		.set ARCICCode=$p($g(^ARC("IC",ARCICRowId)),"^",1)
		.set ARCICDesc=$p($g(^ARC("IC",ARCICRowId)),"^",2)
		.set ARCICOrderType=$p($g(^ARC("IC",ARCICRowId)),"^",7)
		.set ARCICOrdCatDR=$p($g(^ARC("IC",ARCICRowId)),"^",8)
		.set ARCICOrdCatDesc=""
		.if (ARCICOrdCatDR'="") s ARCICOrdCatDesc=$p($g(^OEC("ORCAT",ARCICOrdCatDR)),"^",2) //获取医嘱分类描述
		.set ARCICExecCategDR=$p($g(^ARC("IC",ARCICRowId)),"^",9)
		.set ARCICExecCategDesc=""
		.if (ARCICExecCategDR'="") s ARCICExecCategDesc=$p($g(^OEC("EXEC",ARCICExecCategDR)),"^",2) //获取医嘱执行类型描述
		.set ARCICCalcQtyFlag=$p($g(^ARC("IC",ARCICRowId)),"^",11)
		.do OutputRow	
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow
 	Set Data=$lb(ARCICRowId,ARCICCode,ARCICDesc,ARCICOrderType,ARCICOrdCatDR,ARCICOrdCatDesc,ARCICExecCategDR,ARCICExecCategDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindARCItemCatDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindARCItemCatDataExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindARCItemCatDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindARCItemCatDataExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Creator：      	wll
/// CreatDate：    	2016-05-23
/// Description： 	查找药品数据导入后的数据
/// Table：        	ARC_ItmMast
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCCLDataCom","FindImportArcimData")
Query FindImportArcimData(code As %String = "", desc As %String = "", arcimcat As %String = "") As %Query(ROWSPEC = "rowid,ARCIMCode,ARCIMDesc,ARCIMGenericDesc,phcdCode,itemCat,billUnit,ARCIMUpdateDate,ARCIMUpdateTime") [ SqlProc ]
{
}

ClassMethod FindImportArcimDataExecute(ByRef qHandle As %Binary, code As %String = "", desc As %String = "", arcimcat As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	if (code'="") s code=$ZCONVERT(code,"U") //转换成大写
	if (desc'="") s desc=$ZCONVERT(desc,"U") //转换成大写
	set ARCIMSubscript=0 
    for  set ARCIMSubscript=$o(^ARCIM(ARCIMSubscript)) quit:ARCIMSubscript=""  do        
        .set ARCIMVersion=0
        .for  set ARCIMVersion=$o(^ARCIM(ARCIMSubscript,ARCIMVersion)) quit:ARCIMVersion=""  do 
            ..set ItemCatRowId=ARCIMSubscript_"||"_ARCIMVersion
            ..set rowid=ItemCatRowId
            ..set ARCIMCode=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)  
            ..quit:((code'="")&&(ARCIMCode'[code))
            ..set ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
            ..quit:((desc'="")&&(ARCIMDesc'[desc))
            ..set orderAbbrev =$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",3)
            ..set ARCIMPHCDFDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",12)       ;药物   
            ..if (ARCIMPHCDFDR'="") set ARCIMPHCDFDR11=$p(ARCIMPHCDFDR,"||",1)   
            ..if (ARCIMPHCDFDR'="") set phcdCode= $p($g(^PHCD(ARCIMPHCDFDR11,1)),"^",1)
            ..if (ARCIMPHCDFDR="")  set phcdCode=""
            ..set ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)     ; 医嘱子分类
            ..quit:(arcimcat'="")&&(ARCIMItemCatDR'=arcimcat)
            ..if (ARCIMItemCatDR'="")  do
                ...set ItemCatRowId=ARCIMItemCatDR
                ...set itemCat=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",2)  
            ..else  do
                ...set ItemCatRowId=""
                ...set itemCat=""           
            ..set ARCIMBillSubDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",9)       ; 账单组与 账单子组
            ..if (ARCIMBillSubDR'="") set billGrp=$p(ARCIMBillSubDR,"||",1)                     ; 账单组DR
            ..if (ARCIMBillSubDR'="") set billGroup=$p($g(^ARCBG($p(ARCIMBillSubDR,"||",1))),"^",2) 
            ..if (ARCIMBillSubDR'="") set billSub=$P($g(^ARCBG($p(ARCIMBillSubDR,"||",1),"SG",$p(ARCIMBillSubDR,"||",2))),"^",2)    
            ..if (billGrp'="") set BillGroupRowid=billGrp
            ..if (ARCIMBillSubDR'="") set billSubRowid=ARCIMBillSubDR
            ..if (ARCIMBillSubDR="")  set billGrp=""            
            ..set ARCIMPHCDFDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",12)       ;药物   
            ..if (ARCIMPHCDFDR'="") set ARCIMPHCDFDR11=$p(ARCIMPHCDFDR,"||",1)   
            ..if (ARCIMPHCDFDR'="") set phcdCode= $p($g(^PHCD(ARCIMPHCDFDR11,1)),"^",1)
            ..if (ARCIMPHCDFDR="") set phcdCode=""            
            ..s ARCIMBillingUOMDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",14)    ; 计帐单位 
            ..if (ARCIMBillingUOMDR'="") set billunitRowid=ARCIMBillingUOMDR
            ..if (ARCIMBillingUOMDR'="") set billUnit=$p($g(^CT("UOM",ARCIMBillingUOMDR)),"^",2)         
            ..set ARCIMGenericDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",21)            
            ..set ARCIMUpdateDate=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",1)
            ..if (ARCIMUpdateDate'="") set ARCIMUpdateDate=$zd(ARCIMUpdateDate,3)
            ..set ARCIMUpdateTime=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",2)
            ..if (ARCIMUpdateTime'="") set ARCIMUpdateTime=$zt(ARCIMUpdateTime,2)
            ..do OutputRow
     
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow
 	Set Data=$lb(rowid,ARCIMCode,ARCIMDesc,ARCIMGenericDesc,phcdCode,itemCat,billUnit,ARCIMUpdateDate,ARCIMUpdateTime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindImportArcimDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindImportArcimDataExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindImportArcimDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindImportArcimDataExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

}
