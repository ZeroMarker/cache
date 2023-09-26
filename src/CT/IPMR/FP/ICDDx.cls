/// 名称: CT.IPMR.FP.ICDDx
/// 描述: ICD字典
/// 创建者：liyi
/// 创建日期: 2019-09-17
Class CT.IPMR.FP.ICDDx Extends (%Persistent, MA.IPMR.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildAlias As CT.IPMR.FP.ICDAlias [ Cardinality = children, Inverse = Parref ];

/// 代码（主码拼接副码）
Property FICode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 名称
Property FIDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 诊断库版本
Property FIICDVerDr As CT.IPMR.FP.ICDVer [ Required ];

/// ICD10（编码中的剑号不允许存为加号）
Property FIICD10 As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 副码（编码中的剑号不允许存为加号）
Property FIICDinPair As %String(MAXLEN = 100, TRUNCATE = 1);

/// 肿瘤码
Property FIMCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术操作类型（OperType）
Property FIOperTypeDr As CT.IPMR.BT.Dictionary;

/// HIS诊断库指针
Property FIMRCDr As %String(MAXLEN = 100, TRUNCATE = 1);

/// HIS手术库指针
Property FIORCDr As %String(MAXLEN = 100, TRUNCATE = 1);

/// 启用日期
Property FIActDate As %Date [ Required ];

/// 停用日期
Property FIEndDate As %Date;

/// 是否有效
Property FIIsActive As %Boolean [ Required ];

/// 类目
Property FICatDr As CT.IPMR.FP.ICDCat;

/// 亚目
Property FICatSubDr As CT.IPMR.FP.ICDCatSub;

/// 手术等级（OperationRank）
Property FIOperLevelDr As CT.IPMR.BT.Dictionary;

/// 备注
Property FIResume As %String(MAXLEN = 500, TRUNCATE = 1);

/// 细目
Property FIDetailCataDr As CT.IPMR.FP.ICDDetailCata;

/// 是否入组Drg（ICDIsGroupDRG）
Property FIIsGroupDRGDr As CT.IPMR.BT.Dictionary;

/// 诊断并发症或合并症（DrgComplication）
Property FIDrgComplicationDr As CT.IPMR.BT.Dictionary;

/// 是否医保灰码（ICDIsMedInsuGray）
Property FIIsMedInsuGray As CT.IPMR.BT.Dictionary;

/// 医保诊断库指针
Property FIINSMRCDr As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医保手术库指针
Property FIINSORCDr As %String(MAXLEN = 100, TRUNCATE = 1);

Index IndexCode On (FIICDVerDr, FICode);

Index IndexDesc On (FIICDVerDr, FIDesc);

Index IndexICD10 On (FIICDVerDr, FIICD10);

Index IndexICD10ALP On (FIICDVerDr, FIICD10 As STRING);

Index IndexMCode On (FIICDVerDr, FIMCode);

Index IndexICDVer On FIICDVerDr;

Index IndexMRCDr On FIMRCDr;

Index IndexORCDr On FIORCDr;

Index IndexVerICD On (FIICDVerDr, FIICD10, FIDesc) [ Unique ];

Index IndexVerMRCDr On (FIICDVerDr, FIMRCDr);

Index IndexVerORCDr On (FIICDVerDr, FIORCDr);

Index IndexVerINSMRCDr On (FIICDVerDr, FIINSMRCDr);

Index IndexVerINSORCDr On (FIICDVerDr, FIINSORCDr);

/// Creator：     chenPJ
/// CreatDate：   2019-10-22
/// Description:  取诊ICD字典
/// Table：       CT.IPMR.BT.ICDDx
/// Input：       ID : CT.IPMR.FP.ICDDx.ID
/// Return：      返回obj
/// w ##class(CT.IPMR.FP.ICDDx).GetObjById()
ClassMethod GetObjById(aId As %String) As CT.IPMR.FP.ICDDx
{
	New (aId)
	Set return=""
	Quit:aId="" return
	
	Quit:'##class(CT.IPMR.FP.ICDDx).%ExistsId(aId) return
	Set obj=##Class(CT.IPMR.FP.ICDDx).%OpenId(aId)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     WHui
/// CreatDate：   2020-05-22
/// Description:  通过ICD10取对应诊断字典
/// Table：       CT.IPMR.FP.ICDDx
/// Input：       ICDVer : 诊断库
///               ICD10 : 诊断编码
///               ICD10入参形态
///               A01.000x005+J17.0*	// 加号全量形态
///               A01.000x005†J17.0*	// 剑号全量形态
///               A01.000x005			// 主码不带剑号
///               A01.001†				// 主码带剑号
///               A01.001+				// 主码带加号
///               C85.710M97160/3		// 主码合并形态学全量编码
///               C85.710				// 主码不合并形态学全量编码
/// Return：      返回obj
/// w ##class(CT.IPMR.FP.ICDDx).GetObjByICD10(1,"A01.000x005+J17.0*")
ClassMethod GetObjByICD10(aICDVer As %String, aICD10 As %String) As CT.IPMR.FP.ICDDx
{
	New (aICDVer,aICD10)
	Set return=""
	Quit:(aICDVer="")||(aICD10="") return
	Set aICD10 = $tr(aICD10,"?","†")
	Set aICD10 = $tr(aICD10,"+","†")
	// 全量查找
	set id = ""
	Set id=$o(^CT.IPMR.FP.ICDDxI("IndexICD10",aICDVer," "_$zcvt(aICD10,"U"),id))
	if id="" {
		if aICD10["†" {
			set tmpICD10 = $tr(aICD10,"†","+")
			Set id=$o(^CT.IPMR.FP.ICDDxI("IndexICD10",aICDVer," "_$zcvt(tmpICD10,"U"),id))
			// 拆分 主码查找
			if id="" {
				set tmpICD10 = $p(aICD10,"†",1)	//不带剑号的主码
				Set id=$o(^CT.IPMR.FP.ICDDxI("IndexICD10",aICDVer," "_$zcvt(tmpICD10,"U"),id))
				if id="" {
					set tmpICD10 = $p(aICD10,"†",1)_"†"	//带剑号的主码
					Set id=$o(^CT.IPMR.FP.ICDDxI("IndexICD10",aICDVer," "_$zcvt(tmpICD10,"U"),id))
				}
			}
		}elseif aICD10["+" {
			set tmpICD10 = $tr(aICD10,"+","†")
			Set id=$o(^CT.IPMR.FP.ICDDxI("IndexICD10",aICDVer," "_$zcvt(tmpICD10,"U"),id))
			// 拆分 主码查找
			if id="" {
				set tmpICD10 = $p(aICD10,"+",1)	//不带加号的主码
				Set id=$o(^CT.IPMR.FP.ICDDxI("IndexICD10",aICDVer," "_$zcvt(tmpICD10,"U"),id))
				if id="" {
					set tmpICD10 = $p(aICD10,"+",1)_"+"	//带加号的主码
					Set id=$o(^CT.IPMR.FP.ICDDxI("IndexICD10",aICDVer," "_$zcvt(tmpICD10,"U"),id))
				}
			}
		}else{	
			set firstleter = $zcvt($e(aICD10,1,1),"U") 
			if (firstleter'="M")&&(aICD10["/") {	// 主码合并形态学全量编码
				set tmpICD10 = $p(aICD10,"M",1)	//主码
				Set id=$o(^CT.IPMR.FP.ICDDxI("IndexICD10",aICDVer," "_$zcvt(tmpICD10,"U"),id))
			}else{
			}
		}
	}
	Set return=..GetObjById(id)
	/*
	Set xID=0
	For {
		Set xID=$o(^CT.IPMR.FP.ICDDxI("IndexICD10",aICDVer," "_$zcvt(aICD10,"U"),xID))
		Quit:xID=""
		Quit:return'=""
		Set obj=..GetObjById(xID)
		Continue:'$IsObject(obj)
		Set return=obj
	}
	*/
	Quit return
}

/// Creator：     chenPJ
/// CreatDate：   2019-10-22
/// Description:  更新ICD字典
/// Table：       CT.IPMR.FP.ICDDx
/// Input：       InputStr ：记录信息
///               Separate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(CT.IPMR.FP.ICDDx).Update("255^A16.209^增殖型肺结核^1^A16.209^^^^255^^65042^^1^","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String = "^") As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID        	= $p(aInputStr,aSeparate,1)
	Set Code      	= $p(aInputStr,aSeparate,2)
	Set Desc      	= $p(aInputStr,aSeparate,3)
	Set ICDVerID   	= $p(aInputStr,aSeparate,4)
	Set ICD10     	= $p(aInputStr,aSeparate,5)
	Set ICD10 = $tr(ICD10,"+","†")	// 编码中的剑号不允许存为加号
	Set ICDinPair	= $p(aInputStr,aSeparate,6)
	Set ICDinPair = $tr(ICDinPair,"+","†")	// 编码中的剑号不允许存为加号
	Set MCode   	= $p(aInputStr,aSeparate,7)
	Set OperTypeID  = $p(aInputStr,aSeparate,8)
	Set MRCID     	= $p(aInputStr,aSeparate,9)
	Set ORCID     	= $p(aInputStr,aSeparate,10)
	Set ActDate   	= $p(aInputStr,aSeparate,11)
	Set ActDate = ##Class(MA.IPMR.ImedicalSrv).DateHtmlToLogical(ActDate)
	Set EndDate   	= $p(aInputStr,aSeparate,12)
	Set EndDate = ##Class(MA.IPMR.ImedicalSrv).DateHtmlToLogical(EndDate)
	Set IsActive  	= +$p(aInputStr,aSeparate,13)
	Set Resume    	= $p(aInputStr,aSeparate,14)
	Set CatID    	= $p(aInputStr,aSeparate,15)
	Set CatSubID  	= $p(aInputStr,aSeparate,16)
	Set OperLevelID = $p(aInputStr,aSeparate,17)
	Set DetailCataID= $p(aInputStr,aSeparate,18)
	Set IsGroupDRGID= $p(aInputStr,aSeparate,19)
	Set DrgComplicationID= $p(aInputStr,aSeparate,20)
	Set IsMedInsuGray = $P(aInputStr,aSeparate,21)
	Set INSMRCID    = $p(aInputStr,aSeparate,22)
	Set INSORCID    = $p(aInputStr,aSeparate,23)
	
	Quit:(Code="")||(Desc="")||(ICDVerID="")||(ICD10="") return
	Quit:(ActDate="")||(IsActive="") return
	
	Set objICDVer = ##class(CT.IPMR.FP.ICDVer).GetObjById(ICDVerID)
	Quit:'$IsObject(objICDVer) return 
	
	Set objCat = ##class(CT.IPMR.FP.ICDCat).GetObjById(CatID)
	Set objCatSub = ##class(CT.IPMR.FP.ICDCatSub).GetObjById(CatSubID)
	// 版本 编码 名称 唯一索引
	Set tID=$o(^CT.IPMR.FP.ICDDxI("IndexVerICD",ICDVerID," "_$zcvt(ICD10,"U")," "_$zcvt(Desc,"U"),0))
	if ID="" {	// 增加
		Quit:tID'="" -100
	}else{	// 修改
		Quit:(tID'="")&&(ID'=tID) -100
	}
	
	If ID="" {
		Set obj=##class(CT.IPMR.FP.ICDDx).%New()
	}Else{
		Set obj=##class(CT.IPMR.FP.ICDDx).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.FICode     = Code
	Set obj.FIDesc     = Desc
	Set obj.FIICDVerDr = objICDVer
	Set obj.FIICD10    = ICD10
	Set obj.FIICDinPair= ICDinPair
	Set obj.FIMCode    = MCode
	Set obj.FIOperTypeDr= ##class(CT.IPMR.BT.Dictionary).GetObjById(OperTypeID)
	Set obj.FIMRCDr    = MRCID
	Set obj.FIORCDr    = ORCID
	Set obj.FIActDate  = ActDate
	Set obj.FIEndDate  = EndDate
	Set obj.FIIsActive = IsActive
	Set obj.FIResume   = Resume
	Set obj.FICatDr   = objCat
	Set obj.FICatSubDr   = objCatSub
	Set obj.FIOperLevelDr= ##class(CT.IPMR.BT.Dictionary).GetObjById(OperLevelID)
	Set obj.FIDetailCataDr= ##class(CT.IPMR.FP.ICDDetailCata).GetObjById(DetailCataID)
	Set obj.FIIsGroupDRGDr= ##class(CT.IPMR.BT.Dictionary).GetObjById(IsGroupDRGID)
	Set obj.FIDrgComplicationDr= ##class(CT.IPMR.BT.Dictionary).GetObjById(DrgComplicationID)
	Set obj.FIIsMedInsuGray = ##class(CT.IPMR.BT.Dictionary).GetObjById(IsMedInsuGray)
	Set obj.FIINSMRCDr    = INSMRCID
	Set obj.FIINSORCDr    = INSORCID
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

/// Creator：     chenPJ
/// CreatDate：   2019-10-22
/// Description:  删除ICD字典
/// Table：       CT.IPMR.FP.ICDDx
/// Input：       Id
/// Return：      return>0:成功  return<=0:失败
/// w ##class(CT.IPMR.FP.ICDDx).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set return=0
	Quit:aId="" return
	Set sc = ##class(CT.IPMR.FP.ICDDx).%DeleteId(aId)
	If $system.Status.IsError(sc) {  //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FICode</Value>
</Value>
<Value name="3">
<Value>FIDesc</Value>
</Value>
<Value name="4">
<Value>FIICDVerDr</Value>
</Value>
<Value name="5">
<Value>FIICD10</Value>
</Value>
<Value name="6">
<Value>FIICDinPair</Value>
</Value>
<Value name="7">
<Value>FIMCode</Value>
</Value>
<Value name="8">
<Value>FIOperTypeDr</Value>
</Value>
<Value name="9">
<Value>FIMRCDr</Value>
</Value>
<Value name="10">
<Value>FIORCDr</Value>
</Value>
<Value name="11">
<Value>FIActDate</Value>
</Value>
<Value name="12">
<Value>FIEndDate</Value>
</Value>
<Value name="13">
<Value>FIIsActive</Value>
</Value>
<Value name="14">
<Value>FICatDr</Value>
</Value>
<Value name="15">
<Value>FICatSubDr</Value>
</Value>
<Value name="16">
<Value>FIResume</Value>
</Value>
<Value name="17">
<Value>FIOperLevelDr</Value>
</Value>
<Value name="18">
<Value>FIDetailCataDr</Value>
</Value>
<Value name="19">
<Value>FIIsGroupDRGDr</Value>
</Value>
<Value name="20">
<Value>FIDrgComplicationDr</Value>
</Value>
<Value name="21">
<Value>FIIsMedInsuGray</Value>
</Value>
<Value name="22">
<Value>FIINSMRCDr</Value>
</Value>
<Value name="23">
<Value>FIINSORCDr</Value>
</Value>
</Data>
<DataLocation>^CT.IPMR.FP.ICDDxD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CT.IPMR.FP.ICDDxD</IdLocation>
<IndexLocation>^CT.IPMR.FP.ICDDxI</IndexLocation>
<StreamLocation>^CT.IPMR.FP.ICDDxS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
