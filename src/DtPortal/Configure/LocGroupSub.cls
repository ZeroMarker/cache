/// ClassName:    DtPortal.Configure.LocGroupSub
/// TableName:	  DtPortal_Configure.LocGroupSub
/// Description:  科室组项目维护
/// Creator：     chengpeng
/// CreatDate:    2016-10-20
Class DtPortal.Configure.LocGroupSub Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ParRef As DtPortal.Configure.LocGroup [ Cardinality = parent, Inverse = ChildLog ];

Relationship ChildHeadLog As DtPortal.Configure.LocGroupSubHead [ Cardinality = children, Inverse = ParRef ];

/// LocID
Property LocGroupLocID As User.CTLoc;

/// Type(I：住院科室，O：门诊科室，E：急诊科室,w: 病区)
Property LocGroupType As %String(TRUNCATE = 1);

/// 关联科室（用于门诊/急诊/病区关联到住院科室，选用字段）
Property LocGroupRelationLoc As %String(TRUNCATE = 1);

// Property LocGroupRelationLoc As DtPortal.Configure.LocGroupSub;

/// 关联科室（用于门诊/急诊/病区关联到住院科室，选用字段）
/// 更新日期
Property UpdateDate As %Date;

/// 更新时间
Property UpdateTime As %Time;

/// 索引：科室索引
Index IndexGroupLocID On LocGroupLocID;

/// Creator：     chengpeng
/// CreatDate：   2016-10-20
/// Description:  取科室组维护字表对象
/// Table：       DtPortal_Configure.LocGroupSub
/// Input：       DtPortal.Configure.LocGroupSub.ID
/// Return：      返回obj
/// w ##class(DtPortal.Configure.LocGroupSub).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.SPE.Patients
{
	New (aId)
	Set obj=##Class(DtPortal.Configure.LocGroupSub).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chengpeng
/// CreatDate：   2016-10-20
/// Description:  更新科室组项目维护字表记录
/// Table：       DtPortal_Configure.LocGroupSub
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DtPortal.Configure.LocGroupSub).Update("8^3^110^I^^^","^")
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate="^"
	
	Set ParRef=$p(aInput,aSeparate,1)
	Set LocID=$p(aInput,aSeparate,3)
	Set ChildSub=$p(aInput,aSeparate,2)
	set linLoc=$p(aInput,aSeparate,5)
	
	set ID=ParRef_"||"_ChildSub
	set YZID=""
	set IsHave=0
	set YZRowID=""
	for
	{
		set YZRowID=$o(^DtPortal.Configure.LocGroupI("Log","IndexGroupLocID",LocID,YZRowID))
		quit:YZRowID=""
		
		set YZRowSubID=""
		for
		{
			set YZRowSubID=$o(^DtPortal.Configure.LocGroupI("Log","IndexGroupLocID",LocID,YZRowID,YZRowSubID))
			quit:YZRowSubID=""
			
			set YZID=YZRowID_"||"_YZRowSubID
			set:YZID'=ID IsHave=1
		}
		
		
		
	}

	quit:IsHave=1 YZID
	If (ChildSub="") {
		Set obj=##class(DtPortal.Configure.LocGroupSub).%New()
	} Else {
		Set obj=##class(DtPortal.Configure.LocGroupSub).%OpenId(ParRef_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	Set obj.ParRef=##class(DtPortal.Configure.LocGroup).GetObjById(ParRef)
	Set obj.LocGroupLocID  =##Class(User.CTLoc).%OpenId(LocID)
	Set obj.LocGroupType   =$p(aInput,aSeparate,4)
	Set obj.UpdateDate     = $p($h,",",1)
	Set obj.UpdateTime     = $p($h,",",2)
	
	if linLoc'=""
	{
		set linLoc=$tr(linLoc,"*","^")
		Set obj.LocGroupRelationLoc=linLoc
	}else
	{
		Set obj.LocGroupRelationLoc=""
	}
	
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
/// CreatDate：   2016-10-20
/// Description:  删除科室组项目维护字表记录
/// Table：       DtPortal_Configure.LocGroupSub
/// Input：       DtPortal.Configure.LocGroupSub.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DtPortal.Configure.LocGroupSub).DeleteById("1||11")
ClassMethod DeleteById(ID) As %String
{
	New (ID)
	Set return=0
	Set sc = ##class(DtPortal.Configure.LocGroupSub).%DeleteId(ID)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Creator：     chengpeng
/// CreatDate：   2016-10-21
/// Description:  查询科室组项目维护
/// Table：       DtPortal_Configure.LocGroupSub
/// w ##Class(DtPortal.Configure.LocGroupSub).qureyLocGroupSub(1,110,1)
ClassMethod qureyLocGroupSub(page = 1, rows = 10, locGroupID) As %String
{
	 set start=(page-1)*rows+1
	 set end=page*rows
	 set count=0
	 w "{""rows"":["
	 
	 set rowSubID=""
	 for
	 {
		 set rowSubID=$o(^DtPortal.Configure.LocGroupD(locGroupID,"Log",rowSubID))
		 quit:rowSubID=""
		 set rowID=locGroupID_"||"_rowSubID
		 set obj=##class(DtPortal.Configure.LocGroupSub).GetObjById(rowID)
		 continue:'$IsObject(obj)
		 set count=count+1
		 continue:count<start
		 continue:count>end
		 set LocGroupLocID=obj.LocGroupLocID.%Id()
		 set LocGroupLocDesc=obj.LocGroupLocID.CTLOCDesc
		 set:LocGroupLocDesc["-" LocGroupLocDesc=$p(LocGroupLocDesc,"-",2)
		 set LocGroupType=obj.LocGroupType
		 set LocGroupRelationLocID="",LocGroupRelationLocDesc="",linLocDesc=""
		 set LocGroupRelationLocID=obj.LocGroupRelationLoc
		 if LocGroupRelationLocID'=""
		 {
			 for index=1:1:$l(LocGroupRelationLocID,"^")
			 {
				 set locLinkID=$p(LocGroupRelationLocID,"^",index)
				 set subObj1=##class(DtPortal.Configure.LocGroupSub).GetObjById(locLinkID)
				 if $IsObject(subObj1)
				 {
					 set:LocGroupRelationLocDesc'="" LocGroupRelationLocDesc=LocGroupRelationLocDesc_"</br>"_subObj1.LocGroupLocID.CTLOCDesc
					 set:LocGroupRelationLocDesc="" LocGroupRelationLocDesc=subObj1.LocGroupLocID.CTLOCDesc
					 set:linLocDesc'="" linLocDesc=linLocDesc_"^"_subObj1.LocGroupLocID.CTLOCDesc
					 set:linLocDesc="" linLocDesc=subObj1.LocGroupLocID.CTLOCDesc
				 }
			 }
			
		 }
		 set:LocGroupRelationLocDesc["-" LocGroupRelationLocDesc=$p(LocGroupRelationLocDesc,"-",2)
		 set:LocGroupRelationLocDesc["-" LocGroupRelationLocDesc=$p(LocGroupRelationLocDesc,"-",2)
		 set LocGroupTypeDesc=$s((LocGroupType="I"):"住院",(LocGroupType="O"):"门诊",(LocGroupType="W"):"病区",(LocGroupType="E"):"急诊",1:"")
		
		 set DocHeadIDStr="",DocHeadDescStr="",DocFlagStr="",DocNameStr=""
		 set subHeadID=""
		 for
		 {
			 set subHeadID=$o(^DtPortal.Configure.LocGroupD(locGroupID,"Log",rowSubID,"SUBHEAD",subHeadID))
			 quit:subHeadID=""
			 
			 set subHead=locGroupID_"||"_rowSubID_"||"_subHeadID
			 set subHeadObj=##class(DtPortal.Configure.LocGroupSubHead).GetObjById(subHead)
			 continue:'$IsObject(subHeadObj)
			 
			 set DocHeadID=subHeadObj.LocGroupDocHead.%Id()
			 set DocCode=subHeadObj.LocGroupDocHead.SSUSRInitials
			 set DocName=subHeadObj.LocGroupDocHead.SSUSRName
			 set DocFlag=subHeadObj.LocGroupHeadFlag
			 set DocFlagDesc=""
			 set:DocFlag="Y" DocFlagDesc="正"
			 set:DocFlag="N" DocFlagDesc="副"
			 set DocDesc=DocName_"("_DocCode_")("_DocFlagDesc_")"
			 set:DocHeadIDStr'="" DocHeadIDStr=DocHeadIDStr_"^"_DocHeadID
			 set:DocHeadIDStr="" DocHeadIDStr=DocHeadID
			 set:DocNameStr'="" DocNameStr=DocNameStr_"^"_DocName
			 set:DocNameStr="" DocNameStr=DocName
			 set:DocHeadDescStr'="" DocHeadDescStr=DocHeadDescStr_"</br>"_DocDesc
			 set:DocHeadDescStr="" DocHeadDescStr=DocDesc
			 set:DocFlagStr'="" DocFlagStr=DocFlagStr_"^"_DocFlag
			 set:DocFlagStr="" DocFlagStr=DocFlag
			 
		 }
		
		 w $case(count,start:"",:",")
		 w "{"
		 w """rowID"":"_""""_rowID_""""_","
		 w """rowSubID"":"_""""_rowSubID_""""_","
		 w """LocGroupLocID"":"_""""_LocGroupLocID_""""_","
		 w """LocGroupLocDesc"":"_""""_LocGroupLocDesc_""""_","
		 w """LocGroupType"":"_""""_LocGroupType_""""_","
		 w """LocGroupTypeDesc"":"_""""_LocGroupTypeDesc_""""_","
		 w """LocGroupRelationLocID"":"_""""_LocGroupRelationLocID_""""_","		 
		 w """LocGroupRelationLocDesc"":"_""""_LocGroupRelationLocDesc_""""_","		 
		  w """linLocDesc"":"_""""_linLocDesc_""""_","		 
		 w """DocHeadIDStr"":"_""""_DocHeadIDStr_""""_","
		 w """DocNameStr"":"_""""_DocNameStr_""""_","
		 w """DocFlagStr"":"_""""_DocFlagStr_""""_","
		 w """DocHeadDesc"":"_""""_DocHeadDescStr_""""
		 w "}" 
		 
	 }
	 w "],""total"":"_count_"}"
	 q ""
}

/// Creator：     chengpeng
/// CreatDate：   2016-10-21
/// Description:  查询科室组项目中的住院科室
/// Table：       DtPortal_Configure.LocGroupSub
/// w ##Class(DtPortal.Configure.LocGroupSub).qureyLocGroupSubI(,,)
ClassMethod qureyLocGroupSubI(page = 1, rows = 10, locGroupID = "") As %String
{
	 set start=(page-1)*rows+1
	 set end=page*rows
	 set count=0
	 
	 w "["
	 set rowSubID=""
	 for
	 {
		 set rowSubID=$o(^DtPortal.Configure.LocGroupD(locGroupID,"Log",rowSubID))
		 quit:rowSubID=""
		 set rowID=locGroupID_"||"_rowSubID
		 set obj=##class(DtPortal.Configure.LocGroupSub).GetObjById(rowID)
		 continue:'$IsObject(obj)
		 
		
		 set LocGroupLocID=obj.LocGroupLocID.%Id()
		 set LocGroupLocDesc=obj.LocGroupLocID.CTLOCDesc
		 set:LocGroupLocDesc["-" LocGroupLocDesc=$p(LocGroupLocDesc,"-",2)
		 set LocGroupType=obj.LocGroupType
		 continue:LocGroupType'="I"
		 set LocGroupTypeDesc="住院科室"
		 set count=count+1
		 //continue:count<start
		 //continue:count>end
		 
		 w $case(count,start:"",:",")

		 w "{"
		 w """id"":"_""""_rowID_""""_","
		 w """text"":"_""""_LocGroupLocDesc_"("_LocGroupTypeDesc_")"_""""	 
		 w "}" 
		 
	 }
	 w "]"
	 q ""
}

/// Creator：     chengpeng
/// CreatDate：   2016-10-21
/// Description:  查询科室
/// Table：       CT_LOC
/// w ##Class(DtPortal.Configure.LocGroupSub).qureyLoc(,,)
ClassMethod qureyLoc(page = 1, rows = 10, q = "") As %String
{
	 ;set start=(page-1)*rows+1
	 ;set end=page*rows
	 set start=1
	 set end=10

	 set count=0
	 w "["
	 
	 
	 set q=$$ALPHAUP^SSUTIL4(q)
	 set LocRowID=""
	 for
	 {
		set LocRowID=$o(^CTLOC(LocRowID))
		q:LocRowID=""
		set LocCodeDesc=$p(^CTLOC(LocRowID),"^",2)
		set LocType=$p(^CTLOC(LocRowID),"^",13)
		continue:(LocType'="E")&&(LocType'="W")		//暂时只取执行科室 即只取：门诊科室，住院科室，急诊科室
		Set:LocCodeDesc["-" LocCodeDesc=$p(LocCodeDesc,"-",2)
		continue:LocCodeDesc'[q
		
		set LocCodeDesc=$tr(LocCodeDesc,$c(0,10,13,32),"")
		
		set count=count+1
		//continue:count<start		//下拉表格暂时不分页
		//continue:count>end		//下拉表格暂时不分页
	    w $case(count,start:"",:",")
		w "{"
		w """id"":"_""""_LocRowID_""""_","
		w """text"":"_""""_LocCodeDesc_""""
		w "}" 	
	}

	w "]"
	q ""
}

/// Creator：     chengpeng
/// CreatDate：   2016-12-18
/// Description:  保存科室组和大科主任
/// Table：       DtPortal.Configure.LocGroup
/// Table：       DtPortal.Configure.LocGroupHead
/// Input：       DtPortal.Configure.LocGroup.ID^科室组code^科室组描述^科主任UserID串(如：123|456)
/// Input：       参数分隔符：^
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DtPortal.Configure.LocGroupSub).updateLocDoc("8^1^105^I^140*Y^","^")
ClassMethod updateLocDoc(aInput As %String, aSeparate As %String = "") As %String
{
	New (aInput,aSeparate)
	Set return=1
	set RowID=$p(aInput,aSeparate,1)
	set ^cheng("updateLocDoc")=aInput
	set str=RowID_"^"_$p(aInput,aSeparate,2)_"^"_$p(aInput,aSeparate,3)_"^"_$p(aInput,aSeparate,4)_"^"_$p(aInput,aSeparate,5)
	set ret1=##Class(DtPortal.Configure.LocGroupSub).Update(str,aSeparate)

	set ID=""
	quit:ret1<0 ret1
	set:ret1'=0 ID=ret1
	
	set subID=$p(ID,"||",2)
	set DocStr=$p(aInput,aSeparate,6)
	
	//清空原先的配置
	set HeadSubID=""
	for
	{
		set HeadSubID=$o(^DtPortal.Configure.LocGroupD(RowID,"Log",subID,"SUBHEAD",HeadSubID))
		quit:HeadSubID=""
		
		set HeadSubRowID=RowID_"||"_subID_"||"_HeadSubID
		set retD=##Class(DtPortal.Configure.LocGroupSubHead).DeleteById(HeadSubRowID)
	}
	
	//重新维护
	for index=1:1:$l(DocStr,"|")
	{
		set DocUserID=$p($p(DocStr,"|",index),"*",1)
		set DocFlag=$p($p(DocStr,"|",index),"*",2)
		continue:DocUserID=""
		set HeadSubID=$o(^DtPortal.Configure.LocGroupI("SUBHEAD","IndexDocHead",DocUserID,RowID,subID,""))
		set LocHeadStr=RowID_"^"_subID_"^"_HeadSubID_"^"_DocUserID_"^"_DocFlag
		set ret2=##Class(DtPortal.Configure.LocGroupSubHead).Update(LocHeadStr,aSeparate)
	
		set:ret2<1 return=-100				
	}

	Quit return
}

Storage Default
{
<Data name="LocGroupSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LocGroupLocID</Value>
</Value>
<Value name="3">
<Value>LocGroupType</Value>
</Value>
<Value name="4">
<Value>UpdateDate</Value>
</Value>
<Value name="5">
<Value>UpdateTime</Value>
</Value>
<Value name="6">
<Value>LocGroupDocHead</Value>
</Value>
<Value name="7">
<Value>LocGroupDocHeadFlag</Value>
</Value>
<Value name="8">
<Value>LocGroupRelationLoc</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Log")</DataLocation>
<DefaultData>LocGroupSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("Log")</IdLocation>
<IndexLocation>^DtPortal.Configure.LocGroupI("Log")</IndexLocation>
<StreamLocation>^DtPortal.Configure.LocGroupSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
