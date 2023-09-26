/// 名称: CT.IPMR.FP.ICDMapping
/// 描述: ICD对照表
/// 创建者：zhouyang
/// 创建日期: 2021-08-17
Class CT.IPMR.FP.ICDMapping Extends (%Persistent, MA.IPMR.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 版本
Property IMFVerDr As CT.IPMR.FP.ICDVer [ Required ];

/// ICD
Property IMFICD As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 映射版本
Property IMTVerDr As CT.IPMR.FP.ICDVer [ Required ];

/// 映射ICD
Property IMTICD As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// ICD 指针
Property IMFICDDr As CT.IPMR.FP.ICDDx [ Required ];

/// 映射ICD 指针
Property IMTICDDr As CT.IPMR.FP.ICDDx [ Required ];

/// 是否生效
Property IMIsActive As %Boolean [ Required ];

/// 备注
Property IMResume As %String(MAXLEN = 500, TRUNCATE = 1);

Index IndexVerICD On (IMFVerDr, IMTVerDr, IMFICD, IMTICD) [ Unique ];

Index IndexTVerICD On (IMTVerDr, IMFVerDr, IMTICD, IMFICD);

Index IndexVerICDEx On (IMFVerDr, IMTVerDr, IMFICD) [ Unique ];

Index IndexFICD On IMFICD;

Index IndexTICD On IMTICD;

/// Creator：     liyi
/// CreatDate：   2022-04-24
/// Description:  ICD10全量编码取对照后ICD10
/// Table：       CT.IPMR.FP.ICDMapping
/// Input：       aFverID : 版本id
/// 			  aFICD : ICD10（主码或者全量编码）
/// 			  aTVerID : 目标版本id
/// Return：      对照全量ICD10
/// w ##class(CT.IPMR.FP.ICDMapping).GetMapICD(1,"A01.000x005",3)
ClassMethod GetMapICD(aFverID As %String, aFICD As %String, aTVerID As %String) As %String
{
	new (aFverID,aFICD,aTVerID)
	Set return=""
	Set aFICD = $tr(aFICD,"?","†")
	Set aFICD = $tr(aFICD,"+","†")
	Quit:(aFverID="")||(aFICD="")||(aTVerID="") return
	Quit:'$d(^CT.IPMR.FP.ICDMappingI("IndexVerICD",aFverID,aTVerID)) return
	
	// 获取入参ICD对应编码的全量编码
	set objICDDx = ##class(CT.IPMR.FP.ICDDx).GetObjByICD10(aFverID,aFICD)
	If $isobject(objICDDx) {
		set aFICD = objICDDx.FIICD10_objICDDx.FIICDinPair
	}
	set objMap = ##class(CT.IPMR.FP.ICDMapping).GetMapObj(aFverID,aFICD,aTVerID)
	Quit:'$IsObject(objMap) return
	Set return = objMap.IMTICD //	全量ICD
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2022-04-27
/// Description:  ICD10全量编码取对照后ICD10字典对象
/// Table：       CT.IPMR.FP.ICDMapping
/// Input：       aFverID : 版本id
/// 			  aFICD : ICD10（主码或者全量编码）
/// 			  aTVerID : 目标版本id
/// Return：      返回Object
/// w ##class(CT.IPMR.FP.ICDMapping).GetMapObj("7","A01.001†K77.0*","11")
/// w ##class(CT.IPMR.FP.ICDMapping).GetMapObj("7","A01.001†","11")
ClassMethod GetMapObj(aFverID As %String, aFICD As %String, aTVerID As %String) As CT.IPMR.FP.ICDMapping
{
	new (aFverID,aFICD,aTVerID)
	set return =""
	Set aFICD = $tr(aFICD,"?","†")
	Set aFICD = $tr(aFICD,"+","†")
	Quit:(aFverID="")||(aFICD="")||(aTVerID="") return
	Quit:'$d(^CT.IPMR.FP.ICDMappingI("IndexVerICD",aFverID,aTVerID)) return
	
	// 获取入参ICD对应编码的全量编码
	set objICDDx = ##class(CT.IPMR.FP.ICDDx).GetObjByICD10(aFverID,aFICD)
	If $isobject(objICDDx) {
		if objICDDx.FIICD10[objICDDx.FIICDinPair {
			Set aFICD		= objICDDx.FIICD10
		}else{
		set aFICD = objICDDx.FIICD10_objICDDx.FIICDinPair
		}
	}
	set ICD=""
	if $d(^CT.IPMR.FP.ICDMappingI("IndexVerICD",aFverID,aTVerID," "_$zcvt(aFICD,"U"))) {	//	全量对照
		set ICD = $o(^CT.IPMR.FP.ICDMappingI("IndexVerICD",aFverID,aTVerID," "_$zcvt(aFICD,"U"),""))
	}else{
		if aFICD["†" {
			set aFICD=$tr(aFICD,"†","+")	// 全量对照
			set ICD = $o(^CT.IPMR.FP.ICDMappingI("IndexVerICD",aFverID,aTVerID," "_$zcvt(aFICD,"U"),""))
			if ICD="" {
				Set aFICD = $p(aFICD,"+",1)	// 主码不带+号
				set ICD = $o(^CT.IPMR.FP.ICDMappingI("IndexVerICD",aFverID,aTVerID," "_$zcvt(aFICD,"U"),""))
				if ICD="" {
					Set aFICD = aFICD_"+"	// 主码带+号
					set ICD = $o(^CT.IPMR.FP.ICDMappingI("IndexVerICD",aFverID,aTVerID," "_$zcvt(aFICD,"U"),""))
				}
			}
		}elseif aFICD["+" {
			set aFICD=$tr(aFICD,"+","†")	// 全量对照
			set ICD = $o(^CT.IPMR.FP.ICDMappingI("IndexVerICD",aFverID,aTVerID," "_$zcvt(aFICD,"U"),""))
			if ICD="" {
				Set aFICD = $p(aFICD,"†",1)	// 主码不带†号
				set ICD = $o(^CT.IPMR.FP.ICDMappingI("IndexVerICD",aFverID,aTVerID," "_$zcvt(aFICD,"U"),""))
				if ICD="" {
					Set aFICD = aFICD_"†"	// 主码带†号
					set ICD = $o(^CT.IPMR.FP.ICDMappingI("IndexVerICD",aFverID,aTVerID," "_$zcvt(aFICD,"U"),""))
				}
			}
		}elseif (aFICD["/")&&($e(aFICD,1,1)'="M") {	// 主码C 副码为肿瘤形态学
			set aFICD=$p(aFICD,"M",1)	// 主码对照
			set ICD = $o(^CT.IPMR.FP.ICDMappingI("IndexVerICD",aFverID,aTVerID," "_$zcvt(aFICD,"U"),""))
		}
	}
	Quit:ICD="" return
	
	Set MapID =  $o(^CT.IPMR.FP.ICDMappingI("IndexVerICD",aFverID,aTVerID," "_$zcvt(aFICD,"U"),ICD,0))
	Quit:MapID="" return
	Set return = ..GetObjById(MapID)
	Quit return
}

/// Creator：     zhouyang
/// CreatDate：   2021-08-17
/// Description:  取ICD映射
/// Table：       CT.IPMR.FP.ICDMapping
/// Input：       Id : CT.IPMR.FP.ICDMapping.ID
/// Return：      返回Object
/// w ##class(CT.IPMR.FP.ICDMapping).GetObjById()
ClassMethod GetObjById(aId As %String) As CT.IPMR.FP.ICDMapping
{
	new (aId)
	quit:'##class(CT.IPMR.FP.ICDMapping).%ExistsId(aId) ""
	set obj=##Class(CT.IPMR.FP.ICDMapping).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhouyang
/// CreatDate：   2021-08-17
/// Description:  更新ICD映射
/// Table：       CT.IPMR.FP.ICDMapping
/// Input：       InputStr ：数据
///               Separate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(CT.IPMR.FP.ICDMapping).Update("^1^A00.000^4^A00.001","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID			= $p(aInputStr,aSeparate,1)
	Set FVerID  	= $p(aInputStr,aSeparate,2)
	Set FICD	 	= $p(aInputStr,aSeparate,3)
	Set FICD = $tr(FICD,"+","†")	// 剑号不允许存为加号
	Set TVerID		= $p(aInputStr,aSeparate,4)
	Set TICD 		= $p(aInputStr,aSeparate,5)
	Set TICD = $tr(TICD,"+","†")	// 剑号不允许存为加号
	Set FICDID		= $p(aInputStr,aSeparate,6)
	Set TICDID		= $p(aInputStr,aSeparate,7)
	Set IsActive	= +$p(aInputStr,aSeparate,8)
	Set Resume		= $p(aInputStr,aSeparate,9)
	Quit:(FVerID="")||(FICD="")||(TVerID="")||(TICD="") return
	Quit:(FICDID="")||(TICDID="") return
	
	Set objICD = ##class(CT.IPMR.FP.ICDDx).GetObjById(FICDID)
	Quit:'$isobject(objICD) return
	Set objICD = ##class(CT.IPMR.FP.ICDDx).GetObjById(TICDID)
	Quit:'$isobject(objICD) return
	
	Set objFVer = ##class(CT.IPMR.FP.ICDVer).GetObjById(FVerID)
	Quit:'$isobject(objFVer) return
	Set objTVer = ##class(CT.IPMR.FP.ICDVer).GetObjById(TVerID)
	Quit:'$isobject(objTVer) return
	
	Set tID = $o(^CT.IPMR.FP.ICDMappingI("IndexVerICD",FVerID,TVerID," "_$zcvt(FICD,"U")," "_$zcvt(TICD,"U"),0))
	Quit:'((ID=tID)||(tID="")) -100
	
	Set xID = $o(^CT.IPMR.FP.ICDMappingI("IndexVerICDEx",FVerID,TVerID," "_$zcvt(FICD,"U"),0))
	Quit:'((ID=xID)||(xID="")) -100
	
	Set:tID'="" ID=tID
	If ID="" {
		Set obj=##class(CT.IPMR.FP.ICDMapping).%New()
	}Else{
		Set obj=##class(CT.IPMR.FP.ICDMapping).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.IMFVerDr		= objFVer
	Set obj.IMFICD			= FICD
	Set obj.IMTVerDr		= objTVer
	Set obj.IMTICD			= TICD
	Set obj.IMFICDDr		= ##class(CT.IPMR.FP.ICDDx).GetObjById(FICDID)
	Set obj.IMTICDDr		= ##class(CT.IPMR.FP.ICDDx).GetObjById(TICDID)
	Set obj.IMIsActive		= IsActive
	Set obj.IMResume		= Resume
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhouyang
/// CreatDate：   2021-08-17
/// Description:  删除ICD映射
/// Table：       CT.IPMR.FP.ICDMapping
/// Input：       Id : CT.IPMR.FP.ICDMapping.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(CT.IPMR.FP.ICDMapping).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(CT.IPMR.FP.ICDMapping).%DeleteId(aId)
	if $system.Status.IsError(sc) {  //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

Storage Default
{
<Data name="ICDMappingDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IMFVerDr</Value>
</Value>
<Value name="3">
<Value>IMFICD</Value>
</Value>
<Value name="4">
<Value>IMTVerDr</Value>
</Value>
<Value name="5">
<Value>IMTICD</Value>
</Value>
<Value name="6">
<Value>IMFICDDr</Value>
</Value>
<Value name="7">
<Value>IMTICDDr</Value>
</Value>
<Value name="8">
<Value>IMIsActive</Value>
</Value>
<Value name="9">
<Value>IMResume</Value>
</Value>
</Data>
<DataLocation>^CT.IPMR.FP.ICDMappingD</DataLocation>
<DefaultData>ICDMappingDefaultData</DefaultData>
<IdLocation>^CT.IPMR.FP.ICDMappingD</IdLocation>
<IndexLocation>^CT.IPMR.FP.ICDMappingI</IndexLocation>
<StreamLocation>^CT.IPMR.FP.ICDMappingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
