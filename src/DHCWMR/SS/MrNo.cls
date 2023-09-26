/// 病案号生成/使用记录
Class DHCWMR.SS.MrNo Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 病案类型
Property MNMrType As DHCWMR.SS.MrType [ Required ];

/// 病案号
Property MNMrNo As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 号码类型
Property MNNoType As DHCWMR.SS.NoType [ Required ];

/// 备用
Property MNPatientID As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 操作科室(指向CT_Loc)
Property MNActLoc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 操作用户(指向SS_User)
Property MNActUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 操作日期
Property MNActDate As %Date;

/// 操作时间
Property MNActTime As %Time;

/// 是否有效
Property MNIsActive As %Boolean;

/// 备注
Property MNResume As %String(MAXLEN = 500, TRUNCATE = 1);

/// 号码类型+是否有效 索引
Index IndexActMrNo On (MNNoType, MNIsActive, MNPatientID);

/// 病案类型+是否有效 索引
Index IndexActMrNo1 On (MNMrType, MNIsActive, MNPatientID);

/// 号码类型+病案号 索引
Index IndexNoTypeMrNo On (MNNoType, MNMrNo) [ Unique ];

/// 病案类型+病案号 索引
Index IndexMrTypeMrNo On (MNMrType, MNMrNo) [ Unique ];

/// Creator：     zhufei
/// CreatDate：   2014-08-28
/// Description:  取病案号记录
/// Table：       DHCWMR.SS.MrNo
/// Input：       Id : DHCWMR.SS.MrNo.ID
/// Return：      返回Object
/// w ##class(DHCWMR.SS.MrNo).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.SS.MrNo
{
	new (aId)
	quit:'##class(DHCWMR.SS.MrNo).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.SS.MrNo).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhufei
/// CreatDate：   2014-09-24
/// Description:  获取有效病案号
/// Table：       DHCWMR.SS.MrType、DHCWMR.SS.NoType、DHCWMR.SS.MrNo
/// Input：       NoTypeID : 号码类型ID
///               LocID ：科室ID
///               UserID : 用户ID
/// Return：      返回String
/// w ##class(DHCWMR.SS.MrNo).GetNewMrNo("7||1","00000789",1,1,8)
ClassMethod GetNewMrNo(aNoTypeID As %String, aLocID As %String, aUserID As %String) As %String
{
	new (aNoTypeID,aLocID,aUserID)
	set return=""
	quit:(aNoTypeID="")||(aLocID="")||(aUserID="") return
	
	set objNoType=##class(DHCWMR.SS.NoType).GetObjById(aNoTypeID)
	quit:'$IsObject(objNoType) return
	set MrTypeID=+aNoTypeID
	
	set CTHospID=##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(aLocID)
	set SetPublicNoMrType=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("SetPublicNoMrType",CTHospID)
	
	//可用病案号
	set xID=0
	for {
		set xID=$o(^DHCWMR.SS.MrNoI("IndexActMrNo",aNoTypeID,1," "_0,xID))
		quit:xID=""
		quit:return'=""
		
		set objMrNo=##class(DHCWMR.SS.MrNo).GetObjById(xID)
		continue:'$IsObject(objMrNo)
		continue:'$IsObject(objMrNo.MNMrType)
		continue:'$IsObject(objMrNo.MNNoType)
		
		//update by zf 20150611 检查病案号是否已被占用
		set IsMrNoAct=1
		set MrNo = objMrNo.MNMrNo
		if $d(^DHCWMR.SS.MainI("IndexTypeNoAct",MrTypeID," "_MrNo,1)) {
			set IsMrNoAct=0
		} else {
			if SetPublicNoMrType'="" {
				for indMrType=1:1:$l(SetPublicNoMrType,",") {
					set xMrTypeID=$p(SetPublicNoMrType,",",indMrType)
					continue:xMrTypeID=""
					continue:'$d(^DHCWMR.SS.MainI("IndexTypeNoAct",xMrTypeID," "_MrNo,1))
					set IsMrNoAct=0
				}
			}
		}
		
		set InputStr=xID
		set InputStr=InputStr_"^"_objMrNo.MNMrType.%Id()
		set InputStr=InputStr_"^"_objMrNo.MNMrNo
		set InputStr=InputStr_"^"_objMrNo.MNNoType.%Id()
		set InputStr=InputStr_"^"_""
		set InputStr=InputStr_"^"_aLocID
		set InputStr=InputStr_"^"_aUserID
		set InputStr=InputStr_"^"_+$h
		set InputStr=InputStr_"^"_$p($h,",",2)
		set InputStr=InputStr_"^"_0  //设置号码无效
		set InputStr=InputStr_"^"_objMrNo.MNResume
		set flg=##class(DHCWMR.SS.MrNo).Update(InputStr,"^")
		if flg>0 {
			continue:IsMrNoAct=0 //表示病案号已被占用,同时已占用病案号设置成无效
			set return=objMrNo.MNMrNo
		}
		quit //存在符合条件的病案号,退出循环
	}
	quit:return'="" return
	
	//分配新号码
	set NoLen=objNoType.NTNoLen
	set NoLen=+NoLen
	set NoHead=objNoType.NTNoHead
	set MaxNo=objNoType.NTMaxNo
	set MinNo=objNoType.NTMinNo
	
	//设置当前起始号
	set CurrNo=objNoType.NTCurrNo
	set CurrNo=+CurrNo
	set xCurrNo=+$g(^DHCWMR.SS.MrNoC(MrTypeID,aNoTypeID))
	if CurrNo>xCurrNo {
		set ^DHCWMR.SS.MrNoC(MrTypeID,aNoTypeID)=CurrNo
	}
	
	set return=""
	for {
		quit:return'=""
		
		set MrNo=""
		set Num=$i(^DHCWMR.SS.MrNoC(MrTypeID,aNoTypeID))
		quit:(MinNo'="")&(Num<MinNo)
		quit:(MaxNo'="")&(Num>MaxNo)
		
		if NoLen>$l(Num) {
			set $p(MrNo,"0",NoLen+1-$l(Num))=Num
		} else {
			set MrNo=Num
		}
		set:NoHead'="" MrNo=$zcvt(NoHead,"U")_MrNo
		
		//update by zf 20150611 检查病案号是否已被占用
		set IsMrNoAct=1
		if $d(^DHCWMR.SS.MainI("IndexTypeNoAct",MrTypeID," "_MrNo,1)) {
			set IsMrNoAct=0
		} else {
			if SetPublicNoMrType'="" {
				for indMrType=1:1:$l(SetPublicNoMrType,",") {
					set xMrTypeID=$p(SetPublicNoMrType,",",indMrType)
					continue:xMrTypeID=""
					continue:'$d(^DHCWMR.SS.MainI("IndexTypeNoAct",xMrTypeID," "_MrNo,1))
					set IsMrNoAct=0
				}
			}
		}
		continue:IsMrNoAct=0 //表示病案号已被占用,已占用病案号不入号码库
		
		set InputStr=""
		set InputStr=InputStr_"^"_MrTypeID
		set InputStr=InputStr_"^"_MrNo
		set InputStr=InputStr_"^"_aNoTypeID
		set InputStr=InputStr_"^"_""
		set InputStr=InputStr_"^"_aLocID
		set InputStr=InputStr_"^"_aUserID
		set InputStr=InputStr_"^"_+$h
		set InputStr=InputStr_"^"_$p($h,",",2)
		set InputStr=InputStr_"^"_0  //设置号码无效
		set InputStr=InputStr_"^"_""
		set flg=##class(DHCWMR.SS.MrNo).Update(InputStr,"^")
		if flg>0 {
			set return=MrNo
		}
		quit //存在符合条件的病案号,退出循环
	}
	
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-09-24
/// Description:  分配新病案号
/// Table：       DHCWMR.SS.MrType、DHCWMR.SS.NoType、DHCWMR.SS.MrNo
/// Input：       NoTypeID : 号码类型ID
///               LocID ：科室ID
///               UserID : 用户ID
/// Return：      返回String
/// w ##class(DHCWMR.SS.MrNo).GetPatMrNo(1,8)
ClassMethod GetPatMrNo(aMrTypeID As %String, aPatientID As %String) As %String
{
	new (aMrTypeID,aPatientID)
	set return=""
	quit:(aMrTypeID="")||(aPatientID="") return
	
	//可用病案号
	set xID=0,MrNo=""
	for {
		set xID=$o(^DHCWMR.SS.MrNoI("IndexActMrNo1",aMrTypeID,1," "_aPatientID,xID))
		quit:xID=""
		
		set objMrNo=##class(DHCWMR.SS.MrNo).GetObjById(xID)
		continue:'$IsObject(objMrNo)
		continue:'$IsObject(objMrNo.MNMrType)
		continue:objMrNo.MNMrType.%Id()'=aMrTypeID
		continue:objMrNo.MNIsActive'=1
		set MrNo=objMrNo.MNMrNo
		quit //存在符合条件的病案号,退出循环
	}
	quit:MrNo'="" MrNo
	
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-09-24
/// Description:  取消分配病案号
/// Table：       DHCWMR.SS.MrType、DHCWMR.SS.NoType、DHCWMR.SS.MrNo
/// Input：       NoTypeID ：号码类型ID
///               MrNo ：病案号
///               LocID ：科室ID
///               UserID ：用户ID
/// Return：      返回String
/// w ##class(DHCWMR.SS.MrNo).SetMrNoAct(1,"00000789",1,1)
ClassMethod SetMrNoAct(aMrTypeID As %String, aMrNo As %String, aLocID As %String, aUserID As %String) As %String
{
	new (aMrTypeID,aMrNo,aLocID,aUserID)
	set return=0
	quit:(aMrTypeID="")||(aMrNo="") return
	
	set xID=$o(^DHCWMR.SS.MrNoI("IndexMrTypeMrNo",aMrTypeID," "_$zcvt(aMrNo,"U"),0))
	set objMrNo=##class(DHCWMR.SS.MrNo).GetObjById(xID)
	quit:'$IsObject(objMrNo) return
	
	set InputStr=xID
	set InputStr=InputStr_"^"_objMrNo.MNMrType.%Id()
	set InputStr=InputStr_"^"_objMrNo.MNMrNo
	set InputStr=InputStr_"^"_objMrNo.MNNoType.%Id()
	set InputStr=InputStr_"^"_objMrNo.MNPatientID
	set InputStr=InputStr_"^"_aLocID
	set InputStr=InputStr_"^"_aUserID
	set InputStr=InputStr_"^"_+$h
	set InputStr=InputStr_"^"_$p($h,",",2)
	set InputStr=InputStr_"^"_1
	set InputStr=InputStr_"^"_objMrNo.MNResume
	set flg=##class(DHCWMR.SS.MrNo).Update(InputStr,"^")
	quit:flg<1 return
	
	set return=1
	quit return
}

/// Creator：     liyi
/// CreatDate：   2014-08-28
/// Description:  更新号码生成记录
/// Table：       DHCWMR.SS.MrNo
/// Input：       InputStr ：号码ID^病案类型ID^病案号^号码类型ID^科室ID^用户ID^操作日期^操作时间^是否有效^备注
///               Separate : 分隔符
/// Return：      返回%Id()值
/// w ##class(DHCWMR.SS.MrNo).Update()
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID=$p(aInputStr,aSeparate,1)
	Set MrTypeID=$p(aInputStr,aSeparate,2)
	Set MrNo=$p(aInputStr,aSeparate,3)
	Set NoTypeID=$p(aInputStr,aSeparate,4)
	Set PatientID=+$p(aInputStr,aSeparate,5)
	Set ActLocID=$p(aInputStr,aSeparate,6)
	Set ActUserID=$p(aInputStr,aSeparate,7)
	Set ActDate=$p(aInputStr,aSeparate,8)
	Set ActTime=$p(aInputStr,aSeparate,9)
	Set IsActive=$p(aInputStr,aSeparate,10)
	Set Resume=$p(aInputStr,aSeparate,11)
	Quit:(MrTypeID="")||(MrNo="")||(NoTypeID="") return
	
	Set objMrType=##class(DHCWMR.SS.MrType).GetObjById(MrTypeID)
	Quit:'$IsObject(objMrType) return
	Set objNoType=##class(DHCWMR.SS.NoType).GetObjById(NoTypeID)
	Quit:'$IsObject(objNoType) return
	
	If ID="" {
		Set obj=##class(DHCWMR.SS.MrNo).%New()
	} Else {
		Set obj=##class(DHCWMR.SS.MrNo).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.MNMrType    = objMrType
	Set obj.MNMrNo      = MrNo
	Set obj.MNNoType    = objNoType
	Set obj.MNPatientID = PatientID
	Set obj.MNActLoc    = ActLocID
	Set obj.MNActUser   = ActUserID
	Set obj.MNActDate   = ActDate
	Set obj.MNActTime   = ActTime
	Set obj.MNIsActive  = ((IsActive="Y")||(IsActive=1))
	Set obj.MNResume    = Resume
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-08-28
/// Description:  删除病案号记录
/// Table：       DHCWMR.SS.MrNo
/// Input：       Id : DHCWMR.SS.MrNo.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCWMR.SS.MrNo).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
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
<Value>MNMrType</Value>
</Value>
<Value name="3">
<Value>MNMrNo</Value>
</Value>
<Value name="4">
<Value>MNNoType</Value>
</Value>
<Value name="5">
<Value>MNPatientID</Value>
</Value>
<Value name="6">
<Value>MNActLoc</Value>
</Value>
<Value name="7">
<Value>MNActUser</Value>
</Value>
<Value name="8">
<Value>MNActDate</Value>
</Value>
<Value name="9">
<Value>MNActTime</Value>
</Value>
<Value name="10">
<Value>MNIsActive</Value>
</Value>
<Value name="11">
<Value>MNResume</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.SS.MrNoD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.SS.MrNoD</IdLocation>
<IndexLocation>^DHCWMR.SS.MrNoI</IndexLocation>
<StreamLocation>^DHCWMR.SS.MrNoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
