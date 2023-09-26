/// ClassName:    DtPortal.Configure.LocGroup
/// TableName:	  DtPortal_Configure.LocGroup
/// Description:  科室组维护
/// Creator：     chengpeng
/// CreatDate:    2016-10-20
Class DtPortal.Configure.LocGroup Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildLog As DtPortal.Configure.LocGroupSub [ Cardinality = children, Inverse = ParRef ];

Relationship ChildLogHead As DtPortal.Configure.LocGroupHead [ Cardinality = children, Inverse = ParRef ];

/// code
Property LocGroupCode As %String(TRUNCATE = 1);

/// Desc
Property LocGroupDesc As %String(TRUNCATE = 1);

/// 更新日期
Property UpdateDate As %Date;

/// 更新时间
Property UpdateTime As %Time;

/// 索引：科室组Code
Index IndexCode On LocGroupCode As SQLSTRING;

/// 索引：可是组描述
Index IndexDesc On LocGroupDesc As SQLSTRING;

/// Creator：     chengpeng
/// CreatDate：   2016-10-20
/// Description:  取科室组维护对象
/// Table：       DtPortal_Configure.LocGroup
/// Input：       DtPortal.Configure.LocGroup.ID
/// Return：      返回obj
/// w ##class(DtPortal.Configure.LocGroup).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.SPE.Patients
{
	New (aId)
	Set obj=##Class(DtPortal.Configure.LocGroup).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chengpeng
/// CreatDate：   2016-10-20
/// Description:  更新科室组维护记录
/// Table：       DtPortal.Configure.LocGroup
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DtPortal.Configure.LocGroup).Update("^fk^妇科","^")
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	New (aInput,aSeparate)
	Set return=-1
	
	Set:aSeparate="" aSeparate="^"
	Set ID=$p(aInput,aSeparate,1)
	Set Code=$p(aInput,aSeparate,2)
	set Code=$$ALPHAUP^SSUTIL4(Code)
	Set Desc=$p(aInput,aSeparate,3)
	
	set RowID1="",RowID2=""
	
	set RowID2=$o(^DtPortal.Configure.LocGroupI("IndexDesc"," "_Desc,""))
	If ID="" {
		quit:(RowID2'="") RowID2
		Set obj=##class(DtPortal.Configure.LocGroup).%New()
	} Else {
		quit:(RowID2'="")&&(RowID2'=ID) ID

		Set obj=##class(DtPortal.Configure.LocGroup).%OpenId(ID)		
	}
	Quit:'$IsObject(obj) return
	
	Set obj.LocGroupCode    = Code
	Set obj.LocGroupDesc    = Desc
	Set obj.UpdateDate      = $p($h,",",1)
	Set obj.UpdateTime      = $p($h,",",2)
	
	
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
/// Description:  删除科室组维护记录
/// Table：       DtPortal.Configure.LocGroup
/// Input：       DtPortal.Configure.LocGroup.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DtPortal.Configure.LocGroup).DeleteById(2)
ClassMethod DeleteById(ID) As %String
{
	New (ID)
	s ^cheng(12)=ID
	Set return=0
	Set sc = ##class(DtPortal.Configure.LocGroup).%DeleteId(+ID)
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
/// Description:  查询科室组维护
/// Table：       DtPortal_Configure.LocGroup
/// w ##Class(DtPortal.Configure.LocGroup).qureyLocGroup(1,10,"")
ClassMethod qureyLocGroup(page = 1, rows = 10, code As %String = "", desc As %String = "", docHead As %String = "") As %String
{
	 s ^cheng(6555)=page_"$$"_rows
	 set start=(page-1)*rows+1
	 set end=page*rows
	 set count=0
	 w "{""rows"":["
	 set code=$$ALPHAUP^SSUTIL4(code)
	 set rowID=""
	 for
	 {
		 set rowID=$o(^DtPortal.Configure.LocGroupD(rowID))
		 quit:rowID=""
		 
		 set obj=##class(DtPortal.Configure.LocGroup).GetObjById(rowID)
		 continue:'$IsObject(obj)
		 set LocGroupCode=obj.LocGroupCode
		 set LocGroupDesc=obj.LocGroupDesc
		 continue:((code'="")&&(LocGroupCode'=code))
		 continue:((desc'="")&&(LocGroupDesc'[desc))

		 set DocHeadIDStr="",DocHeadDescStr="",DocFlagStr="",DocNameStr=""
		 set HeadID=""
		 for
		 {
			 set HeadID=$o(^DtPortal.Configure.LocGroupD(rowID,"HEAD",HeadID))
			 quit:HeadID=""
			 
			 set LocHead=rowID_"||"_HeadID
			 set LocHeadObj=##class(DtPortal.Configure.LocGroupHead).GetObjById(LocHead)
			 continue:'$IsObject(LocHeadObj)
			 continue:LocHeadObj.LocGroupDocHead=""
			 set DocHeadID=LocHeadObj.LocGroupDocHead.%Id()
			 set DocCode=LocHeadObj.LocGroupDocHead.SSUSRInitials
			 set DocName=LocHeadObj.LocGroupDocHead.SSUSRName
			 set DocFlag=LocHeadObj.LocGroupHeadFlag
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
		 continue:((docHead'="")&&(("^"_DocHeadIDStr_"^")'[("^"_docHead_"^")))
		 set count=count+1
		 continue:count<start
		 continue:count>end
		 w $case(count,start:"",:",")
		 w "{"
		 w """LocGroupID"":"_""""_rowID_""""_","
		 w """LocGroupCode"":"_""""_LocGroupCode_""""_","
		 w """LocGroupDesc"":"_""""_LocGroupDesc_""""_","
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
/// Description:  查询用户
/// Table：       SS_user
/// w ##Class(DtPortal.Configure.LocGroup).qureyUser(1,1000,"o7015")
ClassMethod qureyUser(page = 1, rows = 10, q) As %String
{
	 ;set start=(page-1)*rows+1
	 ;set end=page*rows
	 set start=1
	 set end=1000
	 set count=0

	 w "["
	 
	 set UserId=""
	 set q=$$ALPHAUP^SSUTIL4(q)
	 ;set:(q'["O")&&(q'["ZJ") q="O"_q
	 ;w q,!
	 set:q'="" UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",q,""))
	 ;w UserId,!
	 if UserId'=""
	 {
		 set UserCode=$P(^SSU("SSUSR",UserId),"^",1)
		 set UserName=$P(^SSU("SSUSR",UserId),"^",2)
		 set UserName=$tr(UserName,$c(0,10,13,32),"")
		 set UserCode=$tr(UserCode,$c(0,10,13,32),"")
		 w "{"
		 w """id"":"_""""_UserId_""""_","
		 w """text"":"_""""_UserName_"("_UserCode_")"_""""
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
/// w ##Class(DtPortal.Configure.LocGroup).updateLocDoc("^d^g^46*Y^","^")
ClassMethod updateLocDoc(aInput As %String, aSeparate As %String = "") As %String
{
	New (aInput,aSeparate)
	Set return=1
	s ^cheng(6766)=aInput
	set ID=$p(aInput,aSeparate,1)

	set str=ID_"^"_$p(aInput,aSeparate,2)_"^"_$p(aInput,aSeparate,3)
	set ret1=##Class(DtPortal.Configure.LocGroup).Update(str,aSeparate)

	quit:ret1<0 ret1
	set:ret1'=0 ID=ret1

	set DocStr=$p(aInput,aSeparate,4)
	
	//清空原先的配置
	set HeadSubID=""
	for
	{
		set HeadSubID=$o(^DtPortal.Configure.LocGroupD(ID,"HEAD",HeadSubID))
		quit:HeadSubID=""
		
		set HeadSubRowID=ID_"||"_HeadSubID
		set retD=##Class(DtPortal.Configure.LocGroupHead).DeleteById(HeadSubRowID)
	}
	
	//重新维护
	for index=1:1:$l(DocStr,"|")
	{
		set DocUserID=$p($p(DocStr,"|",index),"*",1)
		set DocFlag=$p($p(DocStr,"|",index),"*",2)
		continue:DocUserID=""
		set HeadSubID=$o(^DtPortal.Configure.LocGroupI("HEAD",DocUserID,ID,""))
		set LocHeadStr=ID_"^"_HeadSubID_"^"_DocUserID_"^"_DocFlag
		
		set ret2=##Class(DtPortal.Configure.LocGroupHead).Update(LocHeadStr,aSeparate)
	
		set:ret2<1 return=-100				
	}

	Quit return
}

/// Creator：     chengpeng
/// CreatDate：   2016-12-29
/// Description:  导入科室组维护
/// Table：       DtPortal.Configure.LocGroup
/// Table：       DtPortal.Configure.LocGroupHead
/// Input：       filePath:数据文档地址
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DtPortal.Configure.LocGroup).updateLocDoc("^d^g^46*Y^","^")
ClassMethod ImportDataByCSVFile(filePath As %String) As %String
{
	New (filePath)
	Set return=1

	set message = ##class(%FileCharacterStream).%New()
	set message.Filename = filePath  
	set firstFlag="0"
	set suCount=0,faCount=0
	while 'message.AtEnd {
		set firstFlag=+firstFlag+1
		set record=message.ReadLine()
		continue:firstFlag="1"
		set Input="SOAP^"_$p(record,",",1)_"^"_$p(record,",",2)_"^"_$p(record,",",3)_"^"_$p(record,",",4)
		set Input=Input_"^"_$p(record,",",5)_"^"_$p(record,",",6)_"^"_$p(record,",",7)_"^"_$p(record,",",8)_"^"_$p(record,",",9)
		set Input=Input_"^"_$p(record,",",10)_"^"_$p(record,",",11)_"^"_$p(record,",",12)_"^"_$p(record,",",13)_"^"_$p(record,",",14)
		set Input=Input_"^add"
	}
	Quit return
}

/// Creator：     chengpeng
/// CreatDate：   2016-12-29
/// Description:  从his中获取数据导入科室组
/// Table：       DtPortal.Configure.LocGroup
/// Table：       DtPortal.Configure.LocGroupHead
/// Return：      return 1:成功  0:失败
/// w ##Class(DtPortal.Configure.LocGroup).ImportDataText()
ClassMethod ImportDataText() As %String
{
	Set return=1
	k ^||ImportDataText
	set locID=0
	for
	{
		set locID=$o(^CTLOC(locID))
		quit:locID=""
		
		set ActiveFlag=$p(^CTLOC(locID),"^",14)
		//continue:ActiveFlag'="Y"
		set LocType=$p(^CTLOC(locID),"^",13)
		continue:LocType'="E"
		set locDesc=$p(^CTLOC(locID),"^",2)
		set:locDesc["-" locDesc=$p(locDesc,"-",2)
		continue:locDesc'["科"
		continue:$p(locDesc,"科",2)'=""
		set:locDesc["科" locLocGro=$p(locDesc,"科",1)
		set:locDesc'["科" locLocGro=$p(locDesc,"门诊",1)
		continue:locLocGro=""
		set:'$d(^||ImportDataText(locLocGro)) ^||ImportDataText(locLocGro)=0
		if $p(locDesc,"科",2)=""
		{
			set ^||ImportDataText(locLocGro,locID)=locDesc
			set ^||ImportDataText(locLocGro)=+$g(^||ImportDataText(locLocGro))+1
		}
		
	}
	
	set locGrouDesc=""
	for
	{
		set locGrouDesc=$o(^||ImportDataText(locGrouDesc))
		quit:locGrouDesc=""
		
		set num=^||ImportDataText(locGrouDesc)
		;continue:num<2
		
		set locGrouDesc=locGrouDesc_"科"
		set code=##Class(DtPortal.Common.Util.ChineseToPY).GetPY(locGrouDesc)
		set str="|"_code_"|"_locGrouDesc
		;w str,!
		set return1=..Update(str,"|")
		set return=return_"|"_return1
	}
	Quit return
}

/// Creator：     chengpeng
/// CreatDate：   2016-10-21
/// Description:  查询科室组维护
/// Table：       DtPortal_Configure.LocGroup
/// w ##Class(DtPortal.Configure.LocGroup).ImportDataText2()
ClassMethod ImportDataText2() As %String
{
	 
	 set return=0
	 set rowID=""
	 for
	 {
		 set rowID=$o(^DtPortal.Configure.LocGroupD(rowID))
		 quit:rowID=""
		 
		 set obj=##class(DtPortal.Configure.LocGroup).GetObjById(rowID)
		 continue:'$IsObject(obj)
		 set LocGroupCode=obj.LocGroupCode
		 set LocGroupDesc=obj.LocGroupDesc
		 set locLocGroA=""
		 set:LocGroupDesc["科" locLocGroA=$p(LocGroupDesc,"科",1)
		 continue:locLocGroA=""
		 set locID=0
		for
		{
			set locID=$o(^CTLOC(locID))
			quit:locID=""
			
			set ActiveFlag=$p(^CTLOC(locID),"^",14)
			//continue:ActiveFlag'="Y"
			set LocType=$p(^CTLOC(locID),"^",13)
			continue:LocType'="E"
			set locDesc=$p(^CTLOC(locID),"^",2)
			set:locDesc["-" locDesc=$p(locDesc,"-",2)
			continue:locDesc'["科"
			continue:$p(locDesc,"科",2)'=""
			set:locDesc["科" locLocGro=$p(locDesc,"科",1)
			set:locDesc'["科" locLocGro=$p(locDesc,"门诊",1)
			continue:locLocGro=""
			continue:locLocGroA'=locLocGro
			set str=rowID_"^^"_locID_"^I^"
			set ret1=##Class(DtPortal.Configure.LocGroupSub).Update(str,"^")
			set return=return_"|"_ret1
			
		}

		 
	 }
	 q return
}

/// Creator：     chengpeng
/// CreatDate：   2017-05-15
/// Description:  查询门诊/住院/急诊关联的住院科室ID
/// Input：       locGroupID    :  科室组id
/// Input：       locType    :  科室类型
/// Return：      医生信息
/// w ##class(DtPortal.Configure.LocGroup).getDDIlocByOtherLoc(243)
ClassMethod getDDIlocByOtherLoc(alocID As %String)
{
	new (alocID)
	set return=alocID
	quit:'$d(^DtPortal.Configure.LocGroupI("Log","IndexGroupLocID",alocID)) return
	set locGrop=$o(^DtPortal.Configure.LocGroupI("Log","IndexGroupLocID",alocID,""))
	set locGropSub=$o(^DtPortal.Configure.LocGroupI("Log","IndexGroupLocID",alocID,locGrop,""))
	set obj=##class(DtPortal.Configure.LocGroupSub).GetObjById(locGrop_"||"_locGropSub)
	quit:'$IsObject(obj) return
	set type=obj.LocGroupType
	quit:type="I" return
	quit:obj.LocGroupRelationLoc="" return
	set pzLoc=obj.LocGroupRelationLoc
	set:pzLoc'="" return=pzLoc
	
	Quit return
}

/// Creator：     chengpeng
/// CreatDate：   2017-05-15
/// Description:  根据住院科室查询门诊/急诊/病区科室ID
/// Input：       locGroupID    :  科室组id
/// Input：       locType    :  科室类型
/// Return：      医生信息
/// w ##class(DtPortal.Configure.LocGroup).getDDOtherlocByILoc("1||4","O")
ClassMethod getDDOtherlocByILoc(alocID As %String, type As %String)
{
	new (alocID,type)
	set return=""
	quit:'$d(^DtPortal.Configure.LocGroupI("Log","IndexGroupLocID",alocID)) ""
	
	set alocGrop=$o(^DtPortal.Configure.LocGroupI("Log","IndexGroupLocID",alocID,""))
	set alocGropSub=$o(^DtPortal.Configure.LocGroupI("Log","IndexGroupLocID",alocID,alocGrop,""))
	set locGropSub=""
	for
	{
		set locGropSub=$o(^DtPortal.Configure.LocGroupD(alocGrop,"Log",locGropSub))
		quit:locGropSub=""

		set obj=##class(DtPortal.Configure.LocGroupSub).GetObjById(alocGrop_"||"_locGropSub)
		continue:'$IsObject(obj)
		set locType=obj.LocGroupType
		continue:locType'=type
		set ZyGoupSub=obj.LocGroupRelationLoc
		set aZyGoupSub="^"_ZyGoupSub_"^"
		continue:aZyGoupSub'[("^"_alocGrop_"||"_alocGropSub_"^")
		set OtherLoc=obj.LocGroupLocID.%Id()
		set:return'="" return=return_"^"_OtherLoc
		set:return="" return=OtherLoc
		Do obj.%Close()
	}
	
	Quit return
}

Storage Default
{
<Data name="LocGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LocGroupCode</Value>
</Value>
<Value name="3">
<Value>LocGroupDesc</Value>
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
</Data>
<DataLocation>^DtPortal.Configure.LocGroupD</DataLocation>
<DefaultData>LocGroupDefaultData</DefaultData>
<IdLocation>^DtPortal.Configure.LocGroupD</IdLocation>
<IndexLocation>^DtPortal.Configure.LocGroupI</IndexLocation>
<StreamLocation>^DtPortal.Configure.LocGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
