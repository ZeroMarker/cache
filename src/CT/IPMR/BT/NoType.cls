/// 名称: CT.IPMR.BT.NoType
/// 描述: 号码类型
/// 创建者：liyi
/// 创建日期: 2019-09-17
Class CT.IPMR.BT.NoType Extends (%Persistent, MA.IPMR.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As CT.IPMR.BT.MrType [ Cardinality = parent, Inverse = ChildNT ];

Relationship ChildLnk As CT.IPMR.BT.NoTypeLnk [ Cardinality = children, Inverse = Parref ];

/// 代码
Property BNCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 描述
Property BNDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 号码长度
Property BNNoLen As %String(MAXLEN = 100, TRUNCATE = 1);

/// 类型标记
Property BNNoHead As %String(MAXLEN = 100, TRUNCATE = 1);

/// 当前号
Property BNCurrNo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 最大号（结束号）
Property BNMaxNo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 最小号（起始号）
Property BNMinNo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否默认类型
Property BNIsDefault As %Boolean;

/// 是否有效
Property BNIsActive As %Boolean;

/// 备注
Property BNResume As %String(MAXLEN = 500, TRUNCATE = 1);

/// Creator：     liyi
/// CreatDate：   2020-04-27
/// Description:  根据关联医院、科室、病人类型取号码类型
/// Table：       
/// Input：       aAdmType：就诊类型
/// 			  aHospID : 医院ID
/// 			  aLocID：科室ID
/// 			  aPatType：病人类型
/// Return：      obj
/// w ##class(CT.IPMR.BT.NoType).GetObjByNoLink("I","2",1)
ClassMethod GetObjByNoLink(aAdmType As %String, aHospID As %String, aLocID As %String, aPatType As %String = "") As CT.IPMR.BT.NoType
{
	New (aAdmType,aHospID,aLocID,aPatType)
	Set return = ""
	Quit:(aAdmType="") return
	Quit:(aHospID="")&&(aLocID="")&&(aPatType="") return
	
	Set IOCheckNoTpLnk		= ##class(CT.IPMR.BT.Config).GetValByCode("IOCheckNoTpLnk","")
	Set IOCheckNoTpLnk=+IOCheckNoTpLnk	//检查号码类型关联类型定义
	Set IOCheckNoTpLocList	= ##class(CT.IPMR.BT.Config).GetValByCode("IOCheckNoTpLocList","")
	Set IOCheckNoTpLocList=","_IOCheckNoTpLocList_","	//科室列表区分院区设置,IOCheckNoTpLnk=4，需要设置此科室列表代码
	
	Set xID=0
	For {
		Set xID=$o(^CT.IPMR.BT.MrTypeD(xID))
		Quit:xID=""
		Quit:(+return)>0
		
		Set objMrType	= ##class(CT.IPMR.BT.MrType).GetObjById(xID)
		Continue:'$IsObject(objMrType)
		Continue:'$IsObject(objMrType.BMMrClass)
		Set xAdmType	= objMrType.BMAdmType
		Set xAdmType	= "#"_xAdmType_"#"
		Continue:xAdmType'[("#"_aAdmType_"#")
		Set BMHospIDs="#"_objMrType.BMHospIDs_"#"
		Continue:BMHospIDs'[("#"_aHospID_"#")
		
		Set xSub=0
	 	For {
		 	Set xSub=$o(^CT.IPMR.BT.MrTypeD(xID,"NoType",xSub))
		 	Quit:xSub=""
			Quit:(+return)>0
			
		 	Set objNoType=##class(CT.IPMR.BT.NoType).GetObjById(xID_"||"_xSub)
		 	Continue:'$IsObject(objNoType)
		 	Continue:objNoType.BNIsActive'=1
			Set NoTypeID=objNoType.%Id()
			
		 	If IOCheckNoTpLnk=1 { 			//通过医院过滤
		 		Continue:'$d(^CT.IPMR.BT.MrTypeI("Link","IndexHospID",xID,xSub," "_aHospID))
		 	} ElseIf IOCheckNoTpLnk=2 {		//通过科室过滤
		 		Continue:'$d(^CT.IPMR.BT.MrTypeI("Link","IndexLocID",xID,xSub," "_aLocID))
		 	} ElseIf IOCheckNoTpLnk=3 {		//通过病人类型过滤
		 		Continue:'$d(^CT.IPMR.BT.MrTypeI("Link","IndexPatType",xID,xSub," "_aPatType))
		 	} ElseIf IOCheckNoTpLnk=4 {		//通过科室列表区分院区
		 		Set LinkLocID=$o(^CT.IPMR.BT.MrTypeI("Link","IndexLocID",xID,xSub,""))
		 		Continue:LinkLocID=""
		 		Set LinkLocID=$tr(LinkLocID," ","")
		 		Set IsNoTpAct=0
		 		// 此代码有问题，首先取值gloable不对，其次分库以后应该走病案系统科室
		 		/*
		 		Set xLLID=0
		 		For {
			 		Set xLLID=$o(^CT("LL",xLLID))		//*待定*
			 		Quit:xLLID=""
			 		Set LLCode=$p($g(^CT("LL",xLLID)),"^",1)
			 		Set LLCode=","_LLCode_","
			 		Continue:IOCheckNoTpLocList'[LLCode
					Continue:'$d(^CT("LL",xLLID,"LOC",0,"Loc",LinkLocID))
					Continue:'$d(^CT("LL",xLLID,"LOC",0,"Loc",aLocID))
		 			Set IsNoTpAct=1
			 	}
			 	*/
			 	Continue:IsNoTpAct'=1
		 	} Else {
			 	Set IsDefault=objNoType.BNIsDefault
			 	Continue:IsDefault'=1
			}
			Set return=NoTypeID
	 	}
	}
	Set return = ..GetObjById(return)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2020-04-27
/// Description:  根据号码类型格式化病案号
/// Table：       
/// Input：       aNoTypeID : 号码类型ID
/// 			  aMrNo：病案号
/// Return：      返回病案号
/// w ##class(CT.IPMR.BT.NoType).FormatMrNo("7||1",202100008)
/// w ##class(CT.IPMR.BT.NoType).FormatMrNo("7||1","H000001")
ClassMethod FormatMrNo(aNoTypeID As %String, aMrNo As %String) As %String
{
	New (aNoTypeID,aMrNo)
	Set return=""
	Quit:(aMrNo="")||(aNoTypeID="") return

	Set aMrNo=##Class(MA.IPMR.SSService.CommonSrv).ChangeChar(aMrNo)
	Quit:aMrNo="" return
		
	Set objNoType = ..GetObjById(aNoTypeID)
	Quit:'$isobject(objNoType) return
	
	Set NoHead=objNoType.BNNoHead
	Set:NoHead'="" NoHead=$zcvt(NoHead,"U")
	Set NoLen=objNoType.BNNoLen
	Set:NoLen'="" NoLen=+NoLen
	
	Set UseYear	= ##class(CT.IPMR.BT.Config).GetValByCode("MrNoUseYear","")	// 病案号前是否拼接年份
	Set HeadLen = $l(NoHead)
		
	If UseYear=1{   //系统病案号拼接年份
		if $l(aMrNo)=(NoLen+4) {	// 带年份输入，输入格式为2019000001
			Set MrNo=NoHead_aMrNo
			Set return = MrNo
		}else{
			Set $p(return,"0",NoLen-$l(aMrNo)+1)=aMrNo	// 不带年份，就一个数字1
			Set YearNode=$p($zd(+$h,3),"-",1)
			Set MrNo=NoHead_YearNode_return
			Set return = MrNo
		}
	}else{		//系统病案号未拼接年份
		If $e(aMrNo,0,HeadLen)=NoHead {  //NoHead="":00001 或者 NoHead开头：XT00001
			If NoHead=""{
				Set $p(return,"0",NoLen-$l(aMrNo)+1)=aMrNo
			}Else{
				Set return=aMrNo
			}
			;Set return=aMrNo
		}else{		//其他情况：NoHead不空，输入00001
			Set $p(return,"0",NoLen-$l(aMrNo)+1)=aMrNo
			Set MrNo=NoHead_return			//格式化后的病案号
			Set return = MrNo
		}
	}
	
	Quit return
}

/// Creator：     WHui
/// CreatDate：   2019-10-28
/// Description:  取病案号码类型
/// Table：       CT.IPMR.BT.NoType
/// Input：       Id : CT.IPMR.BT.NoType.ID
/// Return：      返回Object
/// w ##class(CT.IPMR.BT.NoType).GetObjById("1||1")
ClassMethod GetObjById(aId As %String) As CT.IPMR.BT.NoType
{
	New (aId)
	Quit:'##class(CT.IPMR.BT.NoType).%ExistsId(aId) ""
	Set obj=##Class(CT.IPMR.BT.NoType).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     WHui
/// CreatDate：   2019-10-28
/// Description:  更新病案号码类型
/// Table：       CT.IPMR.BT.NoType
/// Input：       InputStr : 号码类型信息
///               Separate ：分隔符
/// Return：      return>0:成功  return<=0:失败
/// w ##class(CT.IPMR.BT.NoType).Update("7^^1^全院号码^6^^0^999999^1^1^1^","^")
/// w ##class(CT.IPMR.BT.NoType).Update("1^^5^门诊号码1^5^C^40000^50000^40000^0^1^5^","^")
/// w ##class(CT.IPMR.BT.NoType).Update("1^2^5^门诊号码1^5^C^40000^50000^40000^0^1^5^","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	Set Parref		= $p(aInputStr,aSeparate,1)
	Set ChildSub	= $p(aInputStr,aSeparate,2)
	Set Code		= $p(aInputStr,aSeparate,3)
	Set Desc		= $p(aInputStr,aSeparate,4)
	Set NoLen		=+$p(aInputStr,aSeparate,5)
	Set NoHead		= $p(aInputStr,aSeparate,6)
	Set CurrNo		=+$p(aInputStr,aSeparate,7)
	Set MaxNo		=+$p(aInputStr,aSeparate,8)
	Set MinNo		=+$p(aInputStr,aSeparate,9)
	Set IsDefault	=+$p(aInputStr,aSeparate,10)
	Set IsActive	=+$p(aInputStr,aSeparate,11)
	Set Resume		= $p(aInputStr,aSeparate,12)
	Quit:(Parref="") return
	Set objParref=##class(CT.IPMR.BT.MrType).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	
	If ChildSub="" {
		Set obj=##class(CT.IPMR.BT.NoType).%New()
	} Else {
		Set obj=##class(CT.IPMR.BT.NoType).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref      = objParref
	Set obj.BNCode      = Code
	Set obj.BNDesc      = Desc
	Set obj.BNNoLen     = NoLen
	Set obj.BNNoHead    = $zcvt(NoHead,"U")
	Set obj.BNCurrNo    = CurrNo
	Set obj.BNMaxNo     = MaxNo
	Set obj.BNMinNo     = MinNo
	Set obj.BNIsDefault = IsDefault
	Set obj.BNIsActive  = IsActive
	Set obj.BNResume    = Resume
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

/// Creator：     WHui
/// CreatDate：   2019-10-28
/// Description:  删除病案号码类型
/// Table：       CT.IPMR.BT.NoType
/// Input：       Id : CT.IPMR.BT.NoType.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(CT.IPMR.BT.NoType).DeleteById("1||1")
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(CT.IPMR.BT.NoType).%DeleteId(aId)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BNCode</Value>
</Value>
<Value name="3">
<Value>BNDesc</Value>
</Value>
<Value name="4">
<Value>BNNoLen</Value>
</Value>
<Value name="5">
<Value>BNNoHead</Value>
</Value>
<Value name="6">
<Value>BNCurrNo</Value>
</Value>
<Value name="7">
<Value>BNMaxNo</Value>
</Value>
<Value name="8">
<Value>BNMinNo</Value>
</Value>
<Value name="9">
<Value>BNIsDefault</Value>
</Value>
<Value name="10">
<Value>BNIsActive</Value>
</Value>
<Value name="11">
<Value>BNResume</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("NoType")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>{%%PARENT}("NoType")</IdLocation>
<IndexLocation>^CT.IPMR.BT.MrTypeI("NoType")</IndexLocation>
<StreamLocation>^CT.IPMR.BT.NoTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
