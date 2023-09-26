/// 病案副页卷表
Class DHCWMR.VP.Volume Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 病案主表
Property VVMainDr As DHCWMR.SS.Main [ Required ];

/// 病案卷表
Property VVVolumeDr As DHCWMR.SS.Volume [ Required ];

/// 病案类型
Property VVMrType As DHCWMR.SS.MrType [ Required ];

/// 病案号
Property VVMrNo As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 副页条码号 (主表条码+日期+流水)
Property VVBarcode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 创建日期
Property VVBuildDate As %Date [ Required ];

/// 创建时间
Property VVBuildTime As %Time [ Required ];

/// 是否有效
Property VVIsActive As %Boolean [ Required ];

/// 备注
Property VVResume As %String(MAXLEN = 500, TRUNCATE = 1);

/// 病案号有效索引
Index IndexMrNoMrTypeIsActive On (VVMrNo, VVMrType, VVIsActive);

/// 副页条码号有效索引
Index IndexBarcodeIsActive On (VVBarcode, VVIsActive);

/// 病案卷表有效索引
Index IndexVolumeIsActive On (VVVolumeDr, VVIsActive);

/// 病案主表索引
Index IndexMainDr On VVMainDr;

/// Creator:          liyi
/// CreateDate:       2015-11-11
/// Description:      根据ID取病案副页卷表
/// OperationTable:   DHCWMR.VP.Volume
/// Input:            Id : DHCWMR.VP.Volume.ID
/// Output:           返回Object
/// w ##Class(DHCWMR.VP.Volume).GetObjById(21)
ClassMethod GetObjById(aId As %String) As DHCWMR.VP.Volume
{
	new (aId)
	quit:'##class(DHCWMR.VP.Volume).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.VP.Volume).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     liyi
/// CreatDate：   2015-11-11
/// Description:  更新病案副页卷表
/// Table：       DHCWMR.VP.Volume
/// Input：       InputStr : %Id^MainID^VolumeID^MrTypeID^MrNo^Barcode^BuildDate^BuildTime^IsActive^Resume
///               Separate ：分隔符
/// Return：      返回新纪录的%Id()值
/// w ##class(DHCWMR.VP.Volume).Update("","")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID			=$p(aInputStr,aSeparate,1)
	Set MainID		=$p(aInputStr,aSeparate,2)
	Set VolumeID	=$p(aInputStr,aSeparate,3)
	Set MrTypeID	=$p(aInputStr,aSeparate,4)
	Set MrNo		=$p(aInputStr,aSeparate,5)
	Set Barcode		=$p(aInputStr,aSeparate,6)
	Set BuildDate	=$p(aInputStr,aSeparate,7)
	Set:BuildDate["-" BuildDate=$zdh(BuildDate,3)
	Set:BuildDate="" BuildDate=+$h
	Set BuildTime	=$p(aInputStr,aSeparate,8)
	Set:BuildTime[":" BuildTime=$zth(BuildTime,1)
	Set:BuildTime="" BuildTime=$p($h,",",2)
	Set IsActive	=+$p(aInputStr,aSeparate,9)
	Set Resume		=$p(aInputStr,aSeparate,10)
	Quit:(MrTypeID="")||(MrNo="")||(MainID="")||(VolumeID="") return
	
	Set objMain=##class(DHCWMR.SS.Main).GetObjById(MainID)
	Quit:'$IsObject(objMain) return
	
	Set objVolume=##class(DHCWMR.SS.Volume).GetObjById(VolumeID)
	Quit:'$IsObject(objVolume) return
	
	Set objMrType=##class(DHCWMR.SS.MrType).GetObjById(MrTypeID)
	Quit:'$IsObject(objMrType) return
	
	If ID="" {
		Set obj=##class(DHCWMR.VP.Volume).%New()
		Set MainBarcode = objMain.SMBarcode
		Set Numumber=""
		If ($d(^DHCWMR.VP.VolumeI("IndexMainDr",MainID))){
			Set xNum = "",Num = 1
			For {
				Set xNum = $o(^DHCWMR.VP.VolumeI("IndexMainDr",MainID,xNum))
				Quit:xNum=""
				Set Num=Num+1
			}
			Set:Num=0 Num=1
		}else{
			Set Num=1
		}
		Set $p(Numumber,"0",3-$l(Num)+1)=Num
		Set Barcode = MainBarcode_$zd(+$h,8)_Numumber
		
	} Else {
		Set obj=##class(DHCWMR.VP.Volume).%OpenId(ID)
		Set Barcode = obj.VVBarcode
	}
	Quit:'$IsObject(obj) return
	
	Set obj.VVMainDr 	= objMain
	Set obj.VVVolumeDr 	= objVolume
	Set obj.VVMrType 	= objMrType
	Set obj.VVMrNo 		= MrNo 
	Set obj.VVBarcode 	= Barcode
	Set obj.VVBuildDate = BuildDate
	Set obj.VVBuildTime = BuildTime
	Set obj.VVIsActive 	= IsActive
	Set obj.VVResume 	= Resume
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}	
	Quit return
}

/// Creator：     李毅
/// CreatDate：   2015-11-11
/// Description:  删除病案副页卷表
/// Table：       DHCWMR.VP.Volume
/// Input：       Id : DHCWMR.VP.Volume.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.VP.Volume).%DeleteId(aId)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

/// w ##class(DHCWMR.VP.Volume).InsertVpage(6,"D000005")
ClassMethod InsertVpage(aMrTypeID As %String, aMrNo As %String)
{
	New (aMrNo,aMrTypeID)
	Set return =-1
	Quit:(aMrNo="")||(aMrTypeID="") return
	
	Set aMrNo = $zcvt(aMrNo,"U")
	Set MainID =$o(^DHCWMR.SS.MainI("IndexTypeNoAct",aMrTypeID," "_aMrNo,1,""))
	Quit:MainID=""
	
	Set VolumeID= $o(^DHCWMR.SS.VolumeI("IndexMainDrAct",MainID,1,""))
	Quit:VolumeID=""
	
	Set $p(InputStr,"^",1)=""
	Set $p(InputStr,"^",2)=MainID
	Set $p(InputStr,"^",3)=VolumeID
	Set $p(InputStr,"^",4)=aMrTypeID
	Set $p(InputStr,"^",5)=aMrNo
	Set $p(InputStr,"^",6)=""
	Set $p(InputStr,"^",7)=""
	Set $p(InputStr,"^",8)=""
	Set $p(InputStr,"^",9)=1
	Set $p(InputStr,"^",10)=""
	Set flg=##class(DHCWMR.VP.Volume).Update(InputStr,"^")
	Set return = flg
	
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VVMainDr</Value>
</Value>
<Value name="3">
<Value>VVVolumeDr</Value>
</Value>
<Value name="4">
<Value>VVMrType</Value>
</Value>
<Value name="5">
<Value>VVMrNo</Value>
</Value>
<Value name="6">
<Value>VVBarcode</Value>
</Value>
<Value name="7">
<Value>VVStatus</Value>
</Value>
<Value name="8">
<Value>VVBuildDate</Value>
</Value>
<Value name="9">
<Value>VVBuildTime</Value>
</Value>
<Value name="10">
<Value>VVIsActive</Value>
</Value>
<Value name="11">
<Value>VVResume</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.VP.VolumeD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.VP.VolumeD</IdLocation>
<IndexLocation>^DHCWMR.VP.VolumeI</IndexLocation>
<StreamLocation>^DHCWMR.VP.VolumeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
