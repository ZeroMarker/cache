Class DtPortal.Configure.arcim Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildItem As DtPortal.Configure.arcimItem [ Cardinality = children, Inverse = ParRef ];

/// 医嘱配置code
Property ArcimCode As %String(TRUNCATE = 1);

/// 医嘱配置描述
Property ArcimDesc As %String(TRUNCATE = 1);

/// 医嘱组配置
Property ArcimGro As %String(TRUNCATE = 1);

/// 是否有效 （Y：有效；N：无效）
Property ArcimIsActive As %String;

/// 是否关联医嘱 （Y：有效；N：无效）
Property ArcimIsToItmMast As %String;

/// 是否在病区提示显示 （Y：有效；N：无效）
Property ArcimIsShowWard As %String;

/// 是否生成指标数据 （Y：有效；N：无效）
Property ArcimIsLoadZB As %String;

/// 更新日期
Property ArcimUpdate As %Date;

/// 更新时间
Property ArcimUpTime As %Time;

// 医嘱配置code索引

Index ArcimCodeIndex On ArcimCode;

// 医嘱配置Desc索引

Index ArcimDescIndex On ArcimDesc;

// 是否生成指标数据索引

Index ArcimIsLoadZBIndex On ArcimIsLoadZB;

// 是否在病区提示索引

Index ArcimIsShowWardIndex On ArcimIsShowWard;

// 医嘱组索引

Index ArcimGroIndex On ArcimGro;

/// Creator：     chengpeng
/// CreatDate：   2016-09-13
/// Description:  取医嘱配置
/// Table：       DtPortal_Configure.arcim
/// Return：      返回obj
/// w ##class(DtPortal.Configure.arcim).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DtPortal.Configure.arcim
{
	New (aId)
	Set obj=##Class(DtPortal.Configure.arcim).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chengpeng
/// CreatDate：   2016-07-08
/// Description:  更新医嘱配置
/// Table：       DtPortal_Configure.arcim
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DtPortal.Configure.arcim).Update("^^2^Y^","^")
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	New (aInput,aSeparate)
	Set return=-1
	Set:aSeparate="" aSeparate="^"
	
	Set ID=$p(aInput,aSeparate,1)
	set code=$p(aInput,aSeparate,2)
	set code=$$ALPHAUP^SSUTIL4(code)
	set desc=$p(aInput,aSeparate,3)
	set desc=$$ALPHAUP^SSUTIL4(desc)
	set rowID1Str="",rowID2Str=""
	set rowID1=""
	for
	{
		set rowID1=$o(^DtPortal.Configure.ArcimI("ArcimCodeIndex"," "_code,rowID1))
		quit:rowID1=""
		set:rowID1Str'="" rowID1Str=rowID1Str_"^"_rowID1
		set:rowID1Str="" rowID1Str=rowID1
	}
	
	set rowID2=""
	for
	{
		set rowID2=$o(^DtPortal.Configure.ArcimI("ArcimDescIndex"," "_desc,rowID2))
		quit:rowID2=""
		set:rowID2Str'="" rowID2Str=rowID2Str_"^"_rowID2
		set:rowID2Str="" rowID2Str=rowID2
	}
	If ID="" {		
		quit:((rowID1Str'="")||(rowID2Str'="")) 0
		Set obj=##class(DtPortal.Configure.arcim).%New()
	} Else {
		quit:(($L(rowID1Str,"^")>1)||($L(rowID2Str,"^")>1)) 0
		Set obj=##class(DtPortal.Configure.arcim).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.ArcimCode       = $p(aInput,aSeparate,2)
	Set obj.ArcimDesc       = $p(aInput,aSeparate,3)
	Set obj.ArcimGro   		= $p(aInput,aSeparate,4)
	Set obj.ArcimIsActive   = $p(aInput,aSeparate,5)
	Set obj.ArcimIsToItmMast= $p(aInput,aSeparate,6)
	Set obj.ArcimIsShowWard = $p(aInput,aSeparate,7)
	Set obj.ArcimIsLoadZB   = $p(aInput,aSeparate,8)
	Set obj.ArcimUpdate     = $p($h,",",1)
	Set obj.ArcimUpTime     = $p($h,",",2)
	
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     chengpeng
/// CreatDate：   2016-07-08
/// Description:  删除医嘱配置
/// Table：       DtPortal_Configure.arcim
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(ID) As %String
{
	New (ID)
	Set return=0
	Set sc = ##class(DtPortal.Configure.arcim).%DeleteId(+ID)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Creator：     chengpeng
/// CreatDate：   2016-07-08
/// Description:  查询医嘱配置
/// Table：       DtPortal_Configure.arcim
/// w ##Class(DtPortal.Configure.arcim).qureyArcimConfigure()
ClassMethod qureyArcimConfigure(page = 1, rows = 10, code As %String = "", desc As %String = "", Grop As %String = "") As %String
{
	 set start=(page-1)*rows+1
	 set end=page*rows
	 set count=0
	 w "{""rows"":["
	 
	 //获取his版本
	 set hisEdition=##Class(DtPortal.Common.PublicService).getValueByCode("HISEDITION")
	 
	 set arcGro=""
	 for
	 {
		 set arcGro=$o(^DtPortal.Configure.ArcimI("ArcimGroIndex",arcGro))
		 quit:arcGro=""
		 
		  set rowID=""
		 for
		 {
			 set rowID=$o(^DtPortal.Configure.ArcimI("ArcimGroIndex",arcGro,rowID))
			 quit:rowID=""
			 
			 set obj=##class(DtPortal.Configure.arcim).GetObjById(rowID)
			 continue:'$IsObject(obj)
			 set ArcimCode=obj.ArcimCode
			 set ArcimDesc=obj.ArcimDesc
			 set ArcimGro=obj.ArcimGro
			 set ArcimIsActive=obj.ArcimIsActive
			 set ArcimIsToItmMast=obj.ArcimIsToItmMast
			 set ArcimIsShowWard=obj.ArcimIsShowWard
			 set ArcimIsLoadZB=obj.ArcimIsLoadZB
			 continue:(code'="")&&(code'=ArcimCode)
			 continue:(desc'="")&&(ArcimDesc'[desc)
			 continue:(Grop'="")&&(Grop'=ArcimGro)
			 
			 set count=count+1
			 continue:count<start
			 continue:count>end
			 w $case(count,start:"",:",")
			 w "{"
			 w """ID"":"_""""_rowID_""""_","
			 w """ArcimCode"":"_""""_ArcimCode_""""_","
			 w """ArcimDesc"":"_""""_ArcimDesc_""""_","
			 w """ArcimGro"":"_""""_ArcimGro_""""_","
			 w """ArcimIsActive"":"_""""_ArcimIsActive_""""_","
			 w """ArcimIsToItmMast"":"_""""_ArcimIsToItmMast_""""_","
			 w """ArcimIsShowWard"":"_""""_ArcimIsShowWard_""""_","
			 w """ArcimIsLoadZB"":"_""""_ArcimIsLoadZB_""""
			 w "}" 
			 
		 }
	 }
	 w "],""total"":"_count_",""hisEdition"":"""_hisEdition_"""}"
	 q ""
}

/// Creator：      chengpeng
/// CreatDate：    2016-07-04
/// Description：  分页显示医嘱
/// Table：        SS_Group
/// Input：	      page：当前页数
///               rows：每页条数
/// Return：       
/// d ##class(DtPortal.Configure.arcim).qureyItmMast(1,10,"4g")
ClassMethod qureyItmMast(page = 1, rows = 10, q)
{
    set start=(page-1)*rows+1
    set end=page*rows
    set count=0
    
    w "{""rows"":["
    set ARCIMID=0
    for
    {
	    set ARCIMID=$o(^ARCIM(ARCIMID))
	    quit:ARCIMID=""
	    
	    set ARCIMSubID=0
	    for
	    {
		    set ARCIMSubID= $o(^ARCIM(ARCIMID,ARCIMSubID))
		    quit:ARCIMSubID=""
		    
		    set ItmMastID=ARCIMID_"||"_ARCIMSubID
		    set ItmMastCode=$p($g(^ARCIM(ARCIMID,ARCIMSubID,1)),"^",1)
		    set ItmMastDesc=$p($g(^ARCIM(ARCIMID,ARCIMSubID,1)),"^",2)
		    continue:(q'="")&&(ItmMastDesc'[q)
		    set count=count+1
			continue:count<start
		    continue:count>end
		    
		    w $case(count,start:"",:",")
		    w "{"
		    w """ID"":"_""""_ItmMastID_""""_","
		    w """ItmMastCode"":"_""""_ItmMastCode_""""_","
			w """ItmMastDesc"":"_""""_ItmMastDesc_""""
			w "}" 
		}	 
	}
	w "],""total"":"_count_"}"
	q ""
}

/// Creator：     chengpeng
/// CreatDate：   2017-08-11
/// Description:  获取指标信息指标数据
/// return:		  
/// w ##Class(DtPortal.Configure.arcim).getKPIInfo("Dtportal0001,Dtportal0002")
ClassMethod getKPIInfo(KPICode) As %String
{
	set return=-1
	
	Set $ZT="getKPIInfo"
	set rKPIID="",rKPIDesc=""
	for index=1:1:$l(KPICode,",")
	{
		set code=$p(KPICode,",",index)
		set kpiID=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(code,"DHCWL.MKPI.MKPI")
		continue:kpiID=""
		set KpiObj=##class(DHCWL.MKPI.MKPI).%OpenId(kpiID)
		continue:'$IsObject(KpiObj)
		set Desc=KpiObj.MKPIDesc
		set:rKPIID'="" rKPIID=rKPIID_"^"_kpiID,rKPIDesc=rKPIDesc_"^"_Desc
		set:rKPIID="" rKPIID=kpiID,rKPIDesc=Desc
	}
	quit:rKPIID="" 0
	quit """"_rKPIID_","_rKPIDesc_""""
	
getKPIInfo
	quit -1
}

/// Creator：     chengpeng
/// CreatDate：   2017-08-11
/// Description:  生成指标数据
/// return:		  
/// w ##Class(DtPortal.Configure.arcim).buidZbData()
ClassMethod buidZbData(starDate, endDate, KPIID) As %String
{
	set return=-1
	Set $ZT="buidZbData"

	d AddKpiData^DHCWLAutoCreatMKPIData(starDate,endDate,KPIID,1)

	quit ""
	
buidZbData
	quit return
}

/// Creator：     程鹏
/// CreatDate：   2018-09-26
/// Description:  导出全部数据
/// w ##Class(DtPortal.Configure.arcim).locIndexExp()
ClassMethod locIndexExp() As %String
{
	
	 w "["
	 set isFirst=1,isHaveRole=0
	 set rowID=""
	 for
	 {
		 set rowID=$o(^DtPortal.Configure.ArcimD(rowID))
		 quit:rowID=""
		 
		 set obj=##class(DtPortal.Configure.arcim).GetObjById(rowID)
		 continue:'$IsObject(obj)
		 
		 set ArcimCode=obj.ArcimCode
		 set ArcimDesc=obj.ArcimDesc
		 set ArcimGro=obj.ArcimGro
		 set ArcimIsActive=obj.ArcimIsActive
		 set ArcimIsToItmMast=obj.ArcimIsToItmMast
		 set ArcimIsShowWard=obj.ArcimIsShowWard
		 set ArcimIsLoadZB=obj.ArcimIsLoadZB
	
		 
		 w:isFirst'=1 ","
		 w "{"
		 w """ArcimCode"":"_""""_ArcimCode_""""_","
		 w """ArcimDesc"":"_""""_ArcimDesc_""""_","
		 w """ArcimGro"":"_""""_ArcimGro_""""_","
		 w """ArcimIsActive"":"_""""_ArcimIsActive_""""_","
		 w """ArcimIsToItmMast"":"_""""_ArcimIsToItmMast_""""_","
		 w """ArcimIsShowWard"":"_""""_ArcimIsShowWard_""""_","
		 w """ArcimIsLoadZB"":"_""""_ArcimIsLoadZB_""""_","
		 w """subData"":["
		 
		 set isFirst=isFirst+1
		 
		 set isSubFirst=1
		 set subID=""
		 for
		 {
			 set subID=$o(^DtPortal.Configure.ArcimD(rowID,"Item",subID))
			 quit:subID=""
			 
			 Set subObj=##class(DtPortal.Configure.arcimItem).%OpenId(rowID_"||"_subID)
			 continue:'$IsObject(subObj)
			 
			 set ItmMastID=subObj.ItmMastObj.%Id()
			 set ItmMastDesc=subObj.ItmMastObj.ARCIMDesc
			 set ItmOtherText=subObj.ItmOtherText
			 set:ArcimIsToItmMast="Y" ItmOtherText=""
			 
			 w:isSubFirst'=1 ","
			 w "{"
			 w """ArcimCode"":"_""""_ArcimCode_""""_","
			 w """ArcimDesc"":"_""""_ArcimDesc_""""_","
			 w """ItmMastID"":"_""""_ItmMastID_""""_","
			 w """ItmMastDesc"":"_""""_ItmMastDesc_""""_","
			 w """ItmOtherText"":"_""""_ItmOtherText_""""
			 w "}" 
			 set isSubFirst=2
		 }
		 w "]}" 
		
	 }
	 
	 
	 w "]"
	q ""
}

/// Creator：     程鹏
/// CreatDate：   2018-09-26
/// Description:  导入数据
/// w ##Class(DtPortal.Configure.arcim).locIndexInport("^13149^Doctor^医生^Y*^13501^DirectorDoctor^科主任^Y*^13147^NurseDepartment^护理部^Y*^13502^MedicalDepartment^医务部^Y*^13504^NurseHead^护士长^Y*^19701^OutpatientDepartment^门诊部^Y*^10165^User^普通用户^Y*^15526^CEO^院长^Y*^1066908^IPD^住院部^Y*^13503^Nurse^护士^Y(%)Doctor^医生^29^住院医师*DirectorDoctor^科主任^30^住院医师(主任)*NurseDepartment^护理部^69^护理部*NurseDepartment^护理部^117^护理部主任")
ClassMethod locIndexInport(inpotData) As %String
{
	set length=$l(inpotData,"*")
	quit:length=0 """"_0_"^"_"数据为空！！！"_""""
	
	k ^DtPortal.Configure.ArcimD
	k ^DtPortal.Configure.ArcimI
	
	set arcData=$p(inpotData,"(%)",1)
	set subArcData=$p(inpotData,"(%)",2)

	set return="",isOk=0,ErrStr="",subIsOK=0,subErrStr=""
	for index=1:1:$l(arcData,"*")
	{
		set dataStr=$p(arcData,"*",index)
		continue:dataStr=""
		s ret=..Update(dataStr,"^")
		
		set arcDesc=$p(dataStr,"^",3)
		
		set:((ret=-1)&&(ErrStr'="")) ErrStr=ErrStr_"/"_arcDesc_"保存失败"
		set:((ret=-1)&&(ErrStr="")) ErrStr=arcDesc_"保存失败"
		
		set:((ret=0)&&(ErrStr'="")) ErrStr=ErrStr_"/"_arcDesc_"已存在"
		set:((ret=0)&&(ErrStr="")) ErrStr=arcDesc_"已存在"
		
		set:ret>0 isOk=+isOk+1
		
	}
	
	if subArcData'=""
	{
		for index=1:1:$l(subArcData,"*")
		{
			set dataStr=$p(subArcData,"*",index)
			continue:dataStr=""
			
			set ArcimCode=$p(dataStr,"^",1)
			set ArcimDesc=$p(dataStr,"^",2)
			set ItmMastID=$p(dataStr,"^",3)
			set ItmMastDesc=$p(dataStr,"^",4)
			set ItmOtherText=$p(dataStr,"^",4)
			
			set ArcimCode=$$ALPHAUP^SSUTIL4(ArcimCode)
			
			set rowID=$o(^DtPortal.Configure.ArcimI("ArcimCodeIndex"," "_ArcimCode,""))
			if rowID="" 
			{
				set:subErrStr'="" subErrStr=subErrStr_"/"_ItmMastDesc_"保存失败"_ArcimDesc_"不存在"
				set:subErrStr'="" subErrStr=ItmMastDesc_"保存失败"_ArcimDesc_"不存在"
				continue
			}
			
			set arcObj=##Class(User.ARCItmMast).%OpenId(ItmMastID)
			if '$IsObject(arcObj)
			{
				set:subErrStr'="" subErrStr=subErrStr_"/"_ArcimDesc_"医嘱项不存在"
				set:subErrStr'="" subErrStr=ArcimDesc_"医嘱项不存在"
				continue
			}
			
			set subStrSave=rowID_"^^"_ItmMastID_"^"_ItmOtherText
			
			set subStr=##Class(DtPortal.Configure.arcimItem).Update(subStrSave,"^")
			
			set:((subStr=-1)&&(subErrStr'="")) subErrStr=subErrStr_"/"_ArcimDesc_ItmMastDesc_"保存失败"
			set:((subStr=-1)&&(subErrStr="")) subErrStr=ArcimDesc_ItmMastDesc_"保存失败"
			
			set:((subStr=0)&&(subErrStr'="")) subErrStr=subErrStr_"/"_ArcimDesc_ItmMastDesc_"已存在"
			set:((subStr=0)&&(subErrStr="")) subErrStr=ArcimDesc_ItmMastDesc_"已存在"
			
			set:subStr>0 subIsOK=+subIsOK+1
			
		}
	}
	set return=""""_isOk_"^"_ErrStr_"^"_subIsOK_"^"_subErrStr_""""
	q return
}

/// Creator：     chengpeng
/// CreatDate：   2017-04-25
/// Description:  根据项目code查询医嘱id
/// input:		  ArcimCode 医嘱配置code  以^分割
/// input:		  type 查询类型(1:医嘱ID;2:医嘱code;3:医嘱描述)
/// return:		  医嘱串  (以^分隔)
/// Table：       DtPortal_Configure.arcimItem
/// w ##Class(DtPortal.Configure.arcim).getArcImID("SERIOUSLY^CRITICALLY",1)
ClassMethod getArcImID(ArcimCodeStr As %String, type As %String) As %String
{
	 new (ArcimCodeStr,type)
	 set return=""
	 Set $ZT="getArcImID"
	 for arcIndex=1:1:$l(ArcimCodeStr,"^")
	 {
		 set arcStr=""
		 set ArcimCode=$p(ArcimCodeStr,"^",arcIndex)

		 set arcImConId=$o(^DtPortal.Configure.ArcimI("ArcimCodeIndex"," "_ArcimCode,""))
		 continue:arcImConId=""
		 
 		 set arcimStr=$g(^DtPortal.Configure.ArcimD(arcImConId))
 	
 		 set ArcimIsActive=$li(arcimStr,4)
 		 set ArcimIsToItmMast=$li(arcimStr,10)
 		 //continue:ArcimIsActive'="Y"
 		 
 		if (ArcimIsActive="Y"){
		 	 set arcimConSubID=""
			 for
			 {
				 set arcimConSubID=$o(^DtPortal.Configure.ArcimD(arcImConId,"Item",arcimConSubID))
				 quit:arcimConSubID=""
		
	             set arcimConSubStr=$g(^DtPortal.Configure.ArcimD(arcImConId,"Item",arcimConSubID))
	 	
				 set ItmMastID=""
				 set ItmMastCode=""
				 set ItmMastDesc=""
				 set ItmOtherText=$li(arcimConSubStr,5)
				 if ArcimIsToItmMast'="Y"
				 {
					set ItmMastID=ItmOtherText
				 	set ItmMastCode=ItmOtherText
				 	set ItmMastDesc=ItmOtherText
				 }else{
					 set ItmMastID=$li(arcimConSubStr,2)
					 set ItmMastCode=$p(^ARCIM($p(ItmMastID,"||",1),$p(ItmMastID,"||",2),1),"^",1)
				     set ItmMastDesc=$p(^ARCIM($p(ItmMastID,"||",1),$p(ItmMastID,"||",2),1),"^",2)
				 }
				 if arcStr=""
				 {
					 set:type=1 arcStr=ItmMastID
					 set:type=2 arcStr=ItmMastCode
					 set:type=3 arcStr=ItmMastDesc
				 }else
				 {
					 set:type=1 arcStr=arcStr_"^"_ItmMastID
					 set:type=2 arcStr=arcStr_"^"_ItmMastCode
					 set:type=3 arcStr=arcStr_"^"_ItmMastDesc
				 }
			 }
	 	}
		
		 if (arcIndex="1") s return=arcStr
		 else  s return=return_"*"_arcStr

	 }
	 
	 q return
getArcImID
	q -1
}

/// Creator：     chengpeng
/// CreatDate：   2017-04-25
/// Description:  获取病区显示的医嘱ID
/// input:		  FindType 查询类型(1:在病区显示;2:生成指标)
/// input:		  RetType  返回类型(1:医嘱ID;2:医嘱code;3:医嘱描述)
/// return:		  医嘱串  (以^分隔)
/// Table：       DtPortal_Configure.arcimItem
/// w ##Class(DtPortal.Configure.arcim).getArcImIDByType(1,1)
ClassMethod getArcImIDByType(FindType As %String, RetType As %String) As %String
{
	 new (FindType,RetType)
	 set return=""
	 
	 if FindType=1
	 {
		 set arcImConId=""
		 for
		 {
			 set arcImConId=$o(^DtPortal.Configure.ArcimI("ArcimIsShowWardIndex"," Y",arcImConId))
			 quit:arcImConId=""
			 
			 set arcimStr=$g(^DtPortal.Configure.ArcimD(arcImConId))
 	
 		 	 set ArcimIsActive=$li(arcimStr,4)
 			 set ArcimIsToItmMast=$li(arcimStr,10)
			 
		 	 continue:ArcimIsToItmMast'="Y"
			 set arcimConSubID=""
			 for
			 {
				 set arcimConSubID=$o(^DtPortal.Configure.ArcimD(arcImConId,"Item",arcimConSubID))
				 quit:arcimConSubID=""
				 
				 set arcimConSubStr=$g(^DtPortal.Configure.ArcimD(arcImConId,"Item",arcimConSubID))

			 	 set ItmMastID=$li(arcimConSubStr,2)
				 set ItmMastCode=$p(^ARCIM($p(ItmMastID,"||",1),$p(ItmMastID,"||",2),1),"^",1)
			     set ItmMastDesc=$p(^ARCIM($p(ItmMastID,"||",1),$p(ItmMastID,"||",2),1),"^",2)
			     
				 if return=""
				 {
					 set:RetType=1 return=ItmMastID
					 set:RetType=2 return=ItmMastCode
					 set:RetType=3 return=ItmMastDesc
				 }else
				 {
					 set:RetType=1 return=return_"^"_ItmMastID
					 set:RetType=2 return=return_"^"_ItmMastCode
					 set:RetType=3 return=return_"^"_ItmMastDesc
				 }
			 }

		 }
	 }else
	 {
		 set arcImConId=""
		 for
		 {
			 set arcImConId=$o(^DtPortal.Configure.ArcimI("ArcimIsLoadZBIndex"," Y",arcImConId))
			 quit:arcImConId=""
			 
			 set arcimStr=$g(^DtPortal.Configure.ArcimD(arcImConId))
 	
 		 	 set ArcimIsActive=$li(arcimStr,4)
 			 set ArcimIsToItmMast=$li(arcimStr,10)
	 		 
	 		 continue:ArcimIsActive'="Y"
		 	 continue:ArcimIsToItmMast'="Y"
		 	 
			 set arcimConSubID=""
			 for
			 {
				 set arcimConSubID=$o(^DtPortal.Configure.ArcimD(arcImConId,"Item",arcimConSubID))
				 quit:arcimConSubID=""
				 
				 set arcimConSubStr=$g(^DtPortal.Configure.ArcimD(arcImConId,"Item",arcimConSubID))

			 	 set ItmMastID=$li(arcimConSubStr,2)
				 set ItmMastCode=$p(^ARCIM($p(ItmMastID,"||",1),$p(ItmMastID,"||",2),1),"^",1)
			     set ItmMastDesc=$p(^ARCIM($p(ItmMastID,"||",1),$p(ItmMastID,"||",2),1),"^",2)
				 if return=""
				 {
					 set:RetType=1 return=ItmMastID
					 set:RetType=2 return=ItmMastCode
					 set:RetType=3 return=ItmMastDesc
				 }else
				 {
					 set:RetType=1 return=return_"^"_ItmMastID
					 set:RetType=2 return=return_"^"_ItmMastCode
					 set:RetType=3 return=return_"^"_ItmMastDesc
				 }
			 }

		 }

	 }

	 
	 q return
}

/// Creator：     chengpeng
/// CreatDate：   2017-04-25
/// Description:  根据就诊号和医嘱id判断该病人当天是否执行该医嘱
/// input:		  AdmNo 就诊号
/// input:		  ArcRowIdStr 医嘱ID串(以^分隔)
/// return:		  1/0  1:有;  0:没有
/// w ##Class(DtPortal.Configure.arcim).IsArcRowByIDs("645317","3706||1")
ClassMethod IsArcRowByIDs(AdmNo, ArcRowIdStr) As %String
{
 
 n (AdmNo,ArcRowIdStr)
 s AdmNo=$g(AdmNo)
 s ArcRowIdStr="^"_ArcRowIdStr_"^"
 set retno=0
 q:AdmNo="" 0
 q:ArcRowIdStr="" 0
 set ord=$o(^OEORD(0,"Adm",AdmNo,""))
 q:ord="" 0
 s flag=0
 s ordSttTime="" f  s ordSttTime=$o(^OEORDi(0,"Date",ord,+$h,ordSttTime)) q:(ordSttTime="")!(retno=1)  d
 .s OrdSub=0 f  s OrdSub=$o(^OEORDi(0,"Date",ord,+$h,ordSttTime,OrdSub)) q:(OrdSub="")!(retno=1)  d
 ..s OreSub=0 f  s OreSub=$o(^OEORDi(0,"Date",ord,+$h,ordSttTime,OrdSub,OreSub)) q:(OreSub="")!(retno=1)  d
 ...s ordStatusId=$p($g(^OEORD(ord,"I",OrdSub,"X",OreSub,"BILL")),"^",1)  
 ...s ordStat=$p($g(^OEC("OSTAT",ordStatusId)),"^",1)
 ...q:(ordStat'="V")&(ordStat'="E") 
 ...set ArcRowIdsS=$p(^OEORD(ord,"I",OrdSub,1),"^",2)
 ...set ArcRowIdsS="^"_ArcRowIdsS_"^"
 ...q:ArcRowIdStr'[ArcRowIdsS
 ...q:StrArcRowIds'=$p(^OEORD(ord,"I",OrdSub,1),"^",2)
 ...s retno=1
 q retno
}

/// Creator：     chengpeng
/// CreatDate：   2017-05-16
/// Description:  根据医嘱ID和类型(1:在病区显示;2:生成指标数据)获取医嘱配置code
/// Table：       DtPortal_Configure.arcimItem
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DtPortal.Configure.arcim).getArcCode(2,"10056||1")
ClassMethod getArcCode(type, ArcRowId) As %String
{
	New (type,ArcRowId)
	Set return=""
	
	set arcPzID=""
	for
	{
		set arcPzID=$o(^DtPortal.Configure.ArcimI("Item","IndexItmMastID",ArcRowId,arcPzID))
		quit:arcPzID=""
		
		set obj=##class(DtPortal.Configure.arcim).GetObjById(arcPzID)
		continue:'$IsObject(obj)
		set ArcimIsActive=obj.ArcimIsActive
 		continue:ArcimIsActive'="Y"
 		set ArcimIsShowWard=obj.ArcimIsShowWard
 		set ArcimIsLoadZB=obj.ArcimIsLoadZB
 		continue:(type=1)&&(ArcimIsShowWard'="Y")
 		continue:(type=2)&&(ArcimIsLoadZB'="Y")
 		set ArcimCode=obj.ArcimCode
 		set:return'="" return=return_"^"_ArcimCode
 		set:return="" return=ArcimCode
	}
	
	Quit return
}

Storage Default
{
<Data name="arcimDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ArcimCode</Value>
</Value>
<Value name="3">
<Value>ArcimDesc</Value>
</Value>
<Value name="4">
<Value>ArcimIsActive</Value>
</Value>
<Value name="5">
<Value>ArcimUpdate</Value>
</Value>
<Value name="6">
<Value>ArcimUpTime</Value>
</Value>
<Value name="7">
<Value>ArcimIsShowWard</Value>
</Value>
<Value name="8">
<Value>ArcimIsLoadZB</Value>
</Value>
<Value name="9">
<Value>ArcimGro</Value>
</Value>
<Value name="10">
<Value>ArcimIsToItmMast</Value>
</Value>
</Data>
<DataLocation>^DtPortal.Configure.ArcimD</DataLocation>
<DefaultData>arcimDefaultData</DefaultData>
<IdLocation>^DtPortal.Configure.ArcimD</IdLocation>
<IndexLocation>^DtPortal.Configure.ArcimI</IndexLocation>
<StreamLocation>^DtPortal.Configure.ArcimS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
