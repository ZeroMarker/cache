Import SQLUser

/// Mozy	2019-7-1	条码配置
Class web.DHCEQCBarInfo Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 版本信息
Parameter BaseDate = "2021-07-30";

Parameter BaseVersion = 4.1;

/// w ##Class(web.DHCEQCBarInfo).GetVer()
ClassMethod GetVer()
{
	q "Version:"_..#BaseVersion_"    Date:"_..#BaseDate
}

/// Mozy	2019-6-26	打印条码配置信息
/// BarType:条码类型(Hold1)
/// 		0:设备 1:附件 2:报废
/// w ##Class(web.DHCEQCBarInfo).GetPrintBarInfo(-1,5)
ClassMethod GetPrintBarInfo(EquipID As %Library.String = "", BarInfoDR As %Library.String = "", BarType As %Library.String = "")
{
	i EquipID=-1 s EquipID=$O(^DHCEQEquip(0))	// Mozy003007		2020-04-07
	i EquipID="" q ""
	
	i BarInfoDR=""
	{
		;取到一条配置信息
		;s HospitalDR=$p($g(^CTLOC(%session.Get("LOGON.CTLOCID"))),"^",22)
		// MZY0071	1760015		2021-04-08	增加索引
		Set id=""
		f  s id=$o(^DHCEQCCode("DHCEQCBarSet",0,"BarInfo",id)) q:(id="")||(BarInfoDR'="")  d
		.; MZY0087	2021-08-13
		.q:$p($g(^DHCEQCCode("DHCEQCBarInfo",id)),"^",28)'="N"							;BI_InvalidFlag
		.q:(BarType'="")&&($p($g(^DHCEQCCode("DHCEQCBarInfo",id)),"^",33)'=BarType)		;BI_Hold1
		.
		.Set rowid=0
		.f  s rowid=$o(^DHCEQCCode("DHCEQCBarSet",0,"BarInfo",id,rowid)) q:(rowid="")||(BarInfoDR'="")  d
		..q:$p($g(^DHCEQCCode("DHCEQCBarSet",rowid)),"^",4)'="N"
		..;q:($p($g(^DHCEQCCode("DHCEQCBarSet",rowid)),"^",2)'="")&&($p($g(^DHCEQCCode("DHCEQCBarSet",rowid)),"^",2)'=$p($g(^CTLOC($p($g(^DHCEQEquip(EquipID)),"^",67))),"^",22))    //modify by jyp 2019-10-18 CTLOC调整
		..q:($p($g(^DHCEQCCode("DHCEQCBarSet",rowid)),"^",2)'="")&&($p($g(^DHCEQCCode("DHCEQCBarSet",rowid)),"^",2)'=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID($p($g(^DHCEQEquip(EquipID)),"^",67)))    //modify by jyp 2019-10-18 CTLOC调整
		..q:($p($g(^DHCEQCCode("DHCEQCBarSet",rowid)),"^",3)'="")&&($p($g(^DHCEQCCode("DHCEQCBarSet",rowid)),"^",3)'=$p($g(^DHCEQEquip(EquipID)),"^",63))
		..i $p($g(^DHCEQCCode("DHCEQCBarInfo",id)),"^",25)="Y" s BarInfoDR=id
	}
	
	// MZY0087	2021-08-13	取第一个active激活的标签配置
	i BarInfoDR=""
	{
		Set id=""
		f  s id=$o(^DHCEQCCode("DHCEQCBarInfo",0,"Active","Y",id)) q:(id="")||(BarInfoDR'="")  d
		.q:$p($g(^DHCEQCCode("DHCEQCBarInfo",id)),"^",28)'="N"							;BI_InvalidFlag
		.q:(BarType'="")&&($p($g(^DHCEQCCode("DHCEQCBarInfo",id)),"^",33)'=BarType)		;BI_Hold1
		.s BarInfoDR=id
	}
	i BarInfoDR="" q ""
	
	Set ObjEquip=##Class(User.DHCEQEquip).%OpenId(EquipID)
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")
	s result=$g(^DHCEQCCode("DHCEQCBarInfo",BarInfoDR))
	s result=result_"^"	;	BI_Style
	s result=result_$CASE($p(result,"^",2),"1":"标准二维码","2":"标准一维码",:"其他标签")	// MZY0087	2021-08-13
	;s $p(result,"^",20) = $CASE($p(result,"^",20),"0":"QRErrorCorrectLevel.M","1":"QRErrorCorrectLevel.L","2":"QRErrorCorrectLevel.H","3":"QRErrorCorrectLevel.Q",:"没有定义")
	s result=result_"^"	;	BI_BarMark
	
	/* MZY0087	2021-08-13
	i $p(result,"^",21) = "" d
	.s result=result_$p($g(^DHCEQEquip(EquipID)),"^",71)
	e  if $p(result,"^",21) = "AFNo"  d
	.; 附件编号		objEquip.EQNo+"_"+AFHold1+"_"+AffSequence
	.s result=result_AFNo
	e  d
	.;fileno:EQFileNo,no:EQNo	编码信息(待改进)
	.s result=result_$ZOBJPROPERTY(ObjEquip,$p(result,"^",21))*/
	
	; ^DHCEQCCode("DHCEQCBarDetail",0,"BarInfo",1,0,2,2,4)
	s bardetail=""
	s type=""
	f  s type=$o(^DHCEQCCode("DHCEQCBarDetail",0,"BarInfo",BarInfoDR,type)) q:type=""  d
	.s LineNum=""
	.f  s LineNum=$o(^DHCEQCCode("DHCEQCBarDetail",0,"BarInfo",BarInfoDR,type,LineNum)) q:LineNum=""  d
	..s ColNum=""
	..f  s ColNum=$o(^DHCEQCCode("DHCEQCBarDetail",0,"BarInfo",BarInfoDR,type,LineNum,ColNum)) q:ColNum=""  d
	...s rowid=""
	...f  s rowid=$o(^DHCEQCCode("DHCEQCBarDetail",0,"BarInfo",BarInfoDR,type,LineNum,ColNum,rowid)) q:rowid=""  d
	....;q:($p($g(^DHCEQCCode("DHCEQCBarDetail",rowid)),"^",20)="Y")		;BD_Hidden	在js进行过滤处理
	....i bardetail'="" s bardetail=bardetail_SplitRowCode
	....s tmpresult=$g(^DHCEQCCode("DHCEQCBarDetail",rowid))
	....;i $p(tmpresult,"^",3)'="" s $p(tmpresult,"^",3)=$ZOBJPROPERTY(ObjEquip,$p(tmpresult,"^",3))
	....s bardetail=bardetail_tmpresult
	
	s result=result_SplitRowCode_bardetail
	q result
}

/// Mozy	2019-7-1	条码配置列表
/// d ##class(%ResultSet).RunQuery("web.DHCEQCBarInfo","GetBarInfoList")
Query GetBarInfoList() As %Query(ROWSPEC = "Row:%String,Hidden:%String,Desc:%String")
{
}

ClassMethod GetBarInfoListExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	s Row=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCBarInfo",rowid)) q:rowid=""  d
	.q:$p(^DHCEQCCode("DHCEQCBarInfo",rowid),"^",28)'="N"
	.s desc=$p($g(^DHCEQCCode("DHCEQCBarInfo",rowid)),"^",1)
	.;s code=$p(^DHCEQCCode("DHCEQCBarInfo",rowid),"^",2)
	.d OutputRowGetBarInfoList
	Quit $$$OK
OutputRowGetBarInfoList
    Set Row=Row+1
	Set Data=$lb(Row,rowid,desc)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetBarInfoListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBarInfoListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetBarInfoListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBarInfoListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQCBarInfo","GetBarDetail", 1)
Query GetBarDetail(BarInfoDR As %Library.String = "") As %Query(ROWSPEC = "TRow:%String,TRowID:%String,TType:%String,TKey:%String,TCaption:%String,TPrtCaption:%String,TFontName:%String,TFontSize:%String,TBold:%String,TLineNum:%String,TColNum:%String,TPrintLine:%String,TLeft:%String,TTop:%String,TCFontName:%String,TCFontSize:%String,TCBold:%String,TLineX:%String,TLineY:%String,TLine:%String,THidden:%String,TFormatDR:%String,TFormat:%String,TRemark:%String,TCharacters:%String")
{
}

ClassMethod GetBarDetailExecute(ByRef qHandle As %Binary, BarInfoDR As %Library.String = "") As %Status
{
 	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	; ^DHCEQCCode("DHCEQCBarDetail",0,"BarInfo",1,0,10,0,11)
	s index=1
	s TRow=0
	i BarInfoDR=""
 	{
	 	d ResetVariablesGetBarDetail
		d OutputRowGetBarDetail
	 	Quit $$$OK
 	}
 	
	s TType=""
	f  s TType=$o(^DHCEQCCode("DHCEQCBarDetail",0,"BarInfo",BarInfoDR,TType)) q:TType=""  d
	.s LineNum=""
	.f  s LineNum=$o(^DHCEQCCode("DHCEQCBarDetail",0,"BarInfo",BarInfoDR,TType,LineNum)) q:LineNum=""  d
	..s ColNum=""
	..f  s ColNum=$o(^DHCEQCCode("DHCEQCBarDetail",0,"BarInfo",BarInfoDR,TType,LineNum,ColNum)) q:ColNum=""  d
	...s TRowID=""
	...f  s TRowID=$o(^DHCEQCCode("DHCEQCBarDetail",0,"BarInfo",BarInfoDR,TType,LineNum,ColNum,TRowID)) q:TRowID=""  d
	....d ResetVariablesGetBarDetail
	....s TKey = $p($g(^DHCEQCCode("DHCEQCBarDetail",TRowID)),"^",3)
	....s TCaption = $p($g(^DHCEQCCode("DHCEQCBarDetail",TRowID)),"^",4)
	....s TPrtCaption = $p($g(^DHCEQCCode("DHCEQCBarDetail",TRowID)),"^",5)
	....s TFontName = $p($g(^DHCEQCCode("DHCEQCBarDetail",TRowID)),"^",6)
	....s TFontSize = $p($g(^DHCEQCCode("DHCEQCBarDetail",TRowID)),"^",7)
	....s TBold=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQCCode("DHCEQCBarDetail",TRowID)),"^",8),"bool")
	....s TLineNum = $p($g(^DHCEQCCode("DHCEQCBarDetail",TRowID)),"^",9)
	....s TColNum = $p($g(^DHCEQCCode("DHCEQCBarDetail",TRowID)),"^",10)
	....s TPrintLine=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQCCode("DHCEQCBarDetail",TRowID)),"^",11),"bool")
	....s TLeft = $p($g(^DHCEQCCode("DHCEQCBarDetail",TRowID)),"^",12)
	....s TTop = $p($g(^DHCEQCCode("DHCEQCBarDetail",TRowID)),"^",13)
	....s TCFontName = $p($g(^DHCEQCCode("DHCEQCBarDetail",TRowID)),"^",14)
	....s TCFontSize = $p($g(^DHCEQCCode("DHCEQCBarDetail",TRowID)),"^",15)
	....s TCBold=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQCCode("DHCEQCBarDetail",TRowID)),"^",16),"bool")
	....s TLineX = $p($g(^DHCEQCCode("DHCEQCBarDetail",TRowID)),"^",17)
	....s TLineY = $p($g(^DHCEQCCode("DHCEQCBarDetail",TRowID)),"^",18)
	....s TLine = $p($g(^DHCEQCCode("DHCEQCBarDetail",TRowID)),"^",19)
	....s THidden=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQCCode("DHCEQCBarDetail",TRowID)),"^",20),"bool")
	....s TFormatDR = $p($g(^DHCEQCCode("DHCEQCBarDetail",TRowID)),"^",21)
	....s TFormat=##class(web.DHCEQCColumns).FormatDiaplay(TFormatDR)
	....s TRemark = $p($g(^DHCEQCCode("DHCEQCBarDetail",TRowID)),"^",22)
	....s TCharacters = $p($g(^DHCEQCCode("DHCEQCBarDetail",TRowID)),"^",23)
	....d OutputRowGetBarDetail
	
	;没有数据时也返回一个空行,用于编辑
	i TRow=0  d
	.d ResetVariablesGetBarDetail
	.d OutputRowGetBarDetail
	
	Quit $$$OK
OutputRowGetBarDetail
    Set TRow=TRow+1
	Set Data=$lb(TRow,TRowID,TType,TKey,TCaption,TPrtCaption,TFontName,TFontSize,TBold,TLineNum,TColNum,TPrintLine,TLeft,TTop,TCFontName,TCFontSize,TCBold,TLineX,TLineY,TLine,THidden,TFormatDR,TFormat,TRemark,TCharacters)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetBarDetail
	Set (TKey,TCaption,TPrtCaption,TFontName,TFontSize,TBold,TLineNum,TColNum,TPrintLine,TLeft,TTop,TCFontName,TCFontSize,TCBold,TLineX,TLineY,TLine,THidden,TFormatDR,TFormat,TRemark,TCharacters)=""
	quit
}

ClassMethod GetBarDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBarDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetBarDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBarDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQCBarInfo).GetOneBarInfo(1)
ClassMethod GetOneBarInfo(rowid As %Library.String = "")
{
	i rowid="" q ""
	new result,resultex
	s (result,resultex)=""
	s result=$g(^DHCEQCCode("DHCEQCBarInfo",rowid))
	s $p(result,"^",14)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",14),"bool")
	s $p(result,"^",25)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",25),"bool")
	s $p(result,"^",34)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",34),"bool")		// MZY0087	2021-08-13
	s resultex=resultex_"^"	;BI_BarStyle
	s resultex=resultex_$CASE($p(result,"^",5),0:"无边框",1:"打印内外边框",:"")
	s resultex=resultex_"^"	;BI_BarStyle
	s resultex=resultex_$CASE($p(result,"^",15),"0":"二维码",:"一维码")
	s resultex=resultex_"^"	;BI_CorrectLevel
	i $p(result,"^",20)'="" d
	.s resultex=resultex_$CASE($p(result,"^",20),"0":"QRErrorCorrectLevel.M","1":"QRErrorCorrectLevel.L","2":"QRErrorCorrectLevel.H","3":"QRErrorCorrectLevel.Q",:"错误定义")
	// MZY0087	2021-08-13
	s resultex=resultex_"^"	;BI_Hold1
	s resultex=resultex_$CASE($p(result,"^",33),"0":"设备","1":"附件","2":"报废",:"")
	
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQCBarInfo","BorderStyleList")
Query BorderStyleList() As %Query(ROWSPEC = "TDesc:%String,Hidden:%String")
{
}

ClassMethod BorderStyleListExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	s rowid=0
	s Desc="无边框"
	d OutputRowBorderStyleList
	
	s rowid=1
	s Desc="打印内外边框"
	d OutputRowBorderStyleList
	
	Quit $$$OK
OutputRowBorderStyleList
	Set Data=$lb(Desc,rowid)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
}

ClassMethod BorderStyleListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BorderStyleListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod BorderStyleListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BorderStyleListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQCBarInfo","BarStyleList")
Query BarStyleList() As %Query(ROWSPEC = "TDesc:%String,Hidden:%String")
{
}

ClassMethod BarStyleListExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	s rowid=0
	s Desc="二维码"
	d OutputRowBarStyleList
	
	s rowid=1
	s Desc="一维码"
	d OutputRowBarStyleList
	
	Quit $$$OK
OutputRowBarStyleList
	Set Data=$lb(Desc,rowid)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
}

ClassMethod BarStyleListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BarStyleListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod BarStyleListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BarStyleListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 二维码纠错级别
/// d ##class(%ResultSet).RunQuery("web.DHCEQCBarInfo","CorrectLevelList")
Query CorrectLevelList() As %Query(ROWSPEC = "TLevel:%String,Hidden:%String,TDesc:%String")
{
}

ClassMethod CorrectLevelListExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	;{ L : 1, M : 0, Q : 3, H : 2};
	;L级可纠正约7%错误、M级别可纠正约15%错误、Q级别可纠正约25%错误、H级别可纠正约30%错误 
	
	s rowid=1
	s Level="QRErrorCorrectLevel.L"
	s Desc="容错率 7%"
	d OutputRowCorrectLevelList
	
	s rowid=0
	s Level="QRErrorCorrectLevel.M"
	s Desc="容错率 15%"
	d OutputRowCorrectLevelList
	
	s rowid=3
	s Level="QRErrorCorrectLevel.Q"
	s Desc="容错率 25%"
	d OutputRowCorrectLevelList
	
	s rowid=2
	s Level="QRErrorCorrectLevel.H"
	s Desc="容错率 30%"
	d OutputRowCorrectLevelList
	
	Quit $$$OK
OutputRowCorrectLevelList
	Set Data=$lb(Level,rowid,Desc)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
}

ClassMethod CorrectLevelListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CorrectLevelListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod CorrectLevelListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CorrectLevelListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQCBarInfo).SaveData("1^二维条码左侧打印-南方医院^1^60^500^0^2^2^3500^2000^1350^200^宋体^10^01^0^160^600^1200^0^3^EQNo^0^520^0^true^tiaoma^2","","")
ClassMethod SaveData(val, valList, DelRowid)
{
	new (val, valList, DelRowid, %session)
	Set $ZT="ERRORSave"
	
	s RowID=$P(val,"^",1)
	i RowID'=""
	{
		s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCBarInfo",RowID)),"^",28)
		i InvalidFlag'="N" q -1015
	}
 	Set PLIST(2) = $Piece(val,"^",2) ;Desc
	Set PLIST(3) = $Piece(val,"^",3) ;Style
	Set PLIST(4) = $Piece(val,"^",4) ;Left
	Set PLIST(5) = $Piece(val,"^",5) ;Top
	Set PLIST(6) = $Piece(val,"^",6) ;BorderStyle
	Set PLIST(7) = $Piece(val,"^",7) ;Line
	Set PLIST(8) = $Piece(val,"^",8) ;LineB
	Set PLIST(9) = $Piece(val,"^",9) ;BorderX
	Set PLIST(10) = $Piece(val,"^",10) ;BorderY
	Set PLIST(11) = $Piece(val,"^",11) ;OffsetX
	Set PLIST(12) = $Piece(val,"^",12) ;LineHeigh
	Set PLIST(13) = $Piece(val,"^",13) ;FontName
	Set PLIST(14) = $Piece(val,"^",14) ;FontSize
	Set PLIST(15) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",15),"bool") ;FontBold
	Set PLIST(16) = $Piece(val,"^",16) ;BarStyle
	Set PLIST(17) = $Piece(val,"^",17) ;BarPosX
	Set PLIST(18) = $Piece(val,"^",18) ;BarPosY
	Set PLIST(19) = $Piece(val,"^",19) ;BarWidth
	Set PLIST(20) = $Piece(val,"^",20) ;BarHeight
	Set PLIST(21) = $Piece(val,"^",21) ;CorrectLevel
	Set PLIST(22) = $Piece(val,"^",22) ;BarMark
	Set PLIST(23) = $Piece(val,"^",23) ;CapationCellWidth
	Set PLIST(24) = $Piece(val,"^",24) ;ColWidth
	Set PLIST(25) = $Piece(val,"^",25) ;LineOffset
	Set PLIST(26) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",26),"bool") ;ActiveFlag
	Set PLIST(27) = $Piece(val,"^",27) ;PrtName
	Set PLIST(28) = $Piece(val,"^",28) ;BarLine
	;if PLIST(16)=1 Set PLIST(28) = 6
	Set PLIST(29) = "N"
	Set PLIST(30) = ##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Set PLIST(31) = +$H
	Set PLIST(32) = $P($H,",",2)
	Set PLIST(33) = $Piece(val,"^",29) 	;WordCount
	// MZY0087	2021-08-13
	Set PLIST(34) = $Piece(val,"^",30) 	;Hold1
 	Set PLIST(35) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",31),"bool")	;Hold2	是否打印附件横线
 	Set PLIST(36) = $Piece(val,"^",32)	;Hold3
 	Set PLIST(37) = $Piece(val,"^",33)	;Hold4
 	Set PLIST(38) = $Piece(val,"^",34)	;Hold5
	TSTART	
 	if RowID=""
 	{
		&SQL(insert into sqluser.DHC_EQCBarInfo values :PLIST())
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		s RowID=$G(%ROWID)
 	}
 	else
 	{
		&SQL(update sqluser.DHC_EQCBarInfo values :PLIST() where BI_RowID=:RowID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
 	}
 	;先删除明细再保存明细
 	s SQLCODE=##Class(web.DHCEQCBarInfo).DeleteBarDetail(DelRowid)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
 	s SQLCODE=##Class(web.DHCEQCBarInfo).SaveBarDetail(RowID,valList)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
 	s ID=RowID
 	q ID
ERRORSave 
	TRollBack	
	Set ErrorMsg=$ZE	     		//得到系统返回的错误消息
 	Quit "<ERRORSave>"_ErrorMsg     //返回错误消息
}

/// 描述:删除明细
/// w ##Class(web.DHCEQCBarInfo).DeleteBarDetail(" ,0,0,0")
ClassMethod DeleteBarDetail(DelRowIDs)
{
	i DelRowIDs="" q 0
	new Flag,Length,BDRowID,i
	s Flag=0
	s Length=$l(DelRowIDs,",")
	for i=1:1:Length
	{
		q:Flag'=0
		s BDRowID=$p(DelRowIDs,",",i)
		if (BDRowID>0)
		{
			&SQL(delete from  sqluser.DHC_EQCBarDetail where BD_RowID=:BDRowID)
			i SQLCODE s Flag=SQLCODE
		}
	}
	q Flag
}

/// w ##Class(web.DHCEQCBarInfo).SaveBarDetail(4,"1^31^0^mc^ms^bt^zt^1^false^^^false^^^^^false^^^^false^^&2^32^0^mc^ms^bt^zt^1^false^^^false^^^^^false^^^^false^^&3^27^0^11^标题22^人民医院33^宋体44^1055^false^5^8^false^800^50^^^true^^^^true^^&4^28^0^11^标题22^固定资产卡33^宋体44^1055^false^6^9^true^1000^250^^^false^^^^true^^&5^29^0^Name11^设备名称22^名称:33^宋体44^655^false^7^1^true^^^^8^true^^^^false^^&6^30^0^mc^ms^bt^55^66^true^77^88^true^99^00^11^22^true^33^44^55^true^66^77&7^^0^11^22^33^44^55^true^^^false^^^^^false^^^^false^^")
ClassMethod SaveBarDetail(BIRowID, val)
{
	new Length,BDRowID,Flag,i,InvoiceNo,InvoiceDate,InvoiceFee
	n valList,TSourceType,TSourceID
	;s ^DHCEQMozy(BIRowID)=val
	k PLISTMX
	i val="" q 0
	i BIRowID="" q -1
	
	s Length=$l(val,"&")
	s PLISTMX(2)=BIRowID  					;BD_BarInfoDR
	s Flag=0
	for i=1:1:Length
	{
		q:Flag'=0
		s valList=$p(val,"&",i)
		
		s BDRowID=$p(valList,"^",2)
		s PLISTMX(3)=$p(valList,"^",3)  	;BD_Type
		s PLISTMX(4)=$p(valList,"^",4)		;BD_Key
		s PLISTMX(5)=$p(valList,"^",5)		;BD_Caption
		s PLISTMX(6)=$p(valList,"^",6)  	;BD_PrtCaption
		s PLISTMX(7)=$p(valList,"^",7)  	;BD_FontName
		s PLISTMX(8)=$p(valList,"^",8)  	;BD_FontSize
		s PLISTMX(9)=##class(web.DHCEQCommon).TransValueFromPage($p(valList,"^",9),"bool") 	;BD_Bold
		s PLISTMX(10)=$p(valList,"^",10)  	;BD_LineNum
		s PLISTMX(11)=$p(valList,"^",11)  	;BD_ColNum
		s PLISTMX(12)=##class(web.DHCEQCommon).TransValueFromPage($p(valList,"^",12),"bool") ;BD_PrintLine
		s PLISTMX(13)=$p(valList,"^",13)  	;BD_Left
		s PLISTMX(14)=$p(valList,"^",14)	;BD_Top
		s PLISTMX(15)=$p(valList,"^",15)  	;BD_CFontName
		s PLISTMX(16)=$p(valList,"^",16)  	;BD_CFontSize
		s PLISTMX(17)=##class(web.DHCEQCommon).TransValueFromPage($p(valList,"^",17),"bool") ;BD_CBold
		s PLISTMX(18)=$p(valList,"^",18)  	;BD_LineX
		s PLISTMX(19)=$p(valList,"^",19) 	;BD_LineY
 		s PLISTMX(20)=$p(valList,"^",20)	;BD_Line
 		s PLISTMX(21)=##class(web.DHCEQCommon).TransValueFromPage($p(valList,"^",21),"bool") ;BD_Hidden
 		s PLISTMX(22)=$p(valList,"^",22)	;BD_Format
 		s PLISTMX(23)=$p(valList,"^",23)	;BD_Remark
 		s PLISTMX(24)=$p(valList,"^",24)	;BD_Characters
 		s PLISTMX(25)=$p(valList,"^",25)	;BD_Hold1   //Modiedy by zc0057 限定条件
		if (BDRowID="")
		{
			&SQL(Insert Into SQLUSER.DHC_EQCBarDetail Values :PLISTMX())
			s BDRowID=$G(%ROWID)
		}
		else
		{
			&SQL(update sqluser.DHC_EQCBarDetail values :PLISTMX() where BD_RowID=:BDRowID)
		}
		i SQLCODE
 		{
			s Flag=SQLCODE
 		}
 		q:Flag'=0
	}
	q Flag
}

/// 描述:删除
/// w ##Class(web.DHCEQCBarInfo).DeleteData(2)
ClassMethod DeleteData(BarInfoDR)
{
	i BarInfoDR="" q ""
	Set $ZT="ERRORDelete"
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	; Mozy0234	2019-11-26
	s Date=+$H
	s Time=$P($H,",",2)
	s SQLCODE=0
	&SQL(Update SQLUSER.DHC_EQCBarInfo Set BI_InvalidFlag='Y',BI_UpdateUserDR=:User,BI_UpdateDate=:Date,BI_UpdateTime=:Time where BI_RowID=:BarInfoDR)
	
 	q SQLCODE
ERRORDelete 
	TRollBack	
	Set ErrorMsg=$ZE	    		//得到系统返回的错误消息
 	Quit "ERRORDelete"_ErrorMsg     //返回错误消息
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQCBarInfo","GetBarSet", 8)
Query GetBarSet(BarInfoDR As %Library.String = "") As %Query(ROWSPEC = "TRow:%String,TRowID:%String,TDesc:%String,THospitalDR:%String,THospital:%String,TEquipTypeDR:%String,TEquipType:%String")
{
}

ClassMethod GetBarSetExecute(ByRef qHandle As %Binary, BarInfoDR As %Library.String = "") As %Status
{
 	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=0
	i BarInfoDR="" Quit $$$OK
	
	s TRowID=""
	f  s TRowID=$o(^DHCEQCCode("DHCEQCBarSet",0,"BarInfo",BarInfoDR,TRowID)) q:TRowID=""  d
	.q:$p($g(^DHCEQCCode("DHCEQCBarSet",TRowID)),"^",4)'="N"
	.s TDesc = $p($g(^DHCEQCCode("DHCEQCBarInfo",BarInfoDR)),"^",1)
	.s THospitalDR = $p($g(^DHCEQCCode("DHCEQCBarSet",TRowID)),"^",2)
	.s THospital = $p($g(^CT("HOSP",+THospitalDR)),"^",2)
	.s TEquipTypeDR = $p($g(^DHCEQCCode("DHCEQCBarSet",TRowID)),"^",3)
	.s TEquipType = ##class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR)
	.d OutputRowGetBarSet
	
	Quit $$$OK
OutputRowGetBarSet
    Set TRow=TRow+1
	Set Data=$lb(TRow,TRowID,TDesc,THospitalDR,THospital,TEquipTypeDR,TEquipType)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetBarSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBarSetExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetBarSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBarSetExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 描述:删除
/// w ##Class(web.DHCEQCBarInfo).UpdateBarSet(2)
ClassMethod UpdateBarSet(val As %Library.String = "", apptype As %Library.String = "")
{
	i val="" q 0
	i apptype="" q 0
	Set $ZT="ERRORUpdateBarSet"
	s SQLCODE=0
	k PLIST
	s RowID=$p(val,"^",1)
	
	i apptype=1
	{
		
		&SQL(Update SQLUSER.DHC_EQCBarSet Set BS_InvalidFlag='Y' where BS_RowID=:RowID)
		if (SQLCODE'=0)&&(SQLCODE'=100)
	 	{
			q SQLCODE
	 	}
	 	q RowID 
	}
	s PLIST(2)=$p(val,"^",2)
	s PLIST(3)=$p(val,"^",3)
	s PLIST(4)=$p(val,"^",4)
	s PLIST(5)="N"
	i RowID=""
	{
		&SQL(Insert Into SQLUSER.DHC_EQCBarSet Values :PLIST())
		Set RowID=$g(%ROWID)
	}
	else
	{
		&SQL(Update SQLUSER.DHC_EQCBarSet Values :PLIST() where BS_RowID = :RowID) 
	}
	if (SQLCODE'=0)&&(SQLCODE'=100)
	{
		q SQLCODE
	}
 	q RowID
ERRORUpdateBarSet 
	TRollBack	
	Set ErrorMsg=$ZE	    		//得到系统返回的错误消息
 	Quit "ERRORUpdateBarSet"_ErrorMsg     //返回错误消息
}

/// w ##Class(web.DHCEQCBarInfo).GetOneBarSet(2)
ClassMethod GetOneBarSet(rowid As %Library.String = "")
{
	i rowid="" q ""
	s result=$g(^DHCEQCCode("DHCEQCBarSet",rowid))
	s resultex="^"		;BS_BarInfoDR
	i $p(result,"^",1)'="" d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCBarInfo",$p(result,"^",1))),"^",1)
	s resultex=resultex_"^"		;BS_HospitalDR
	i $p(result,"^",2)'="" d
	.s resultex=resultex_$p($g(^CT("HOSP",$p(result,"^",2))),"^",2)
	s resultex=resultex_"^"		;BS_EquipTypeDR
	i $p(result,"^",3)'="" d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", $p(result,"^",3))

	q result_resultex
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQCBarInfo","BarDetailKeyList","p")
Query BarDetailKeyList(Name As %String = "", Desc As %String = "") As %Query(ROWSPEC = "Hidden:%String,Hidden:%String,TName:%String:名称,TDesc:%String:描述,THold1:%String:属性,Hidden:%String,Hidden:%String")
{
}

ClassMethod BarDetailKeyListExecute(ByRef qHandle As %Binary, Name As %String = "", Desc As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
 	s Name=$ZCONVERT(Name ,"U")
 	s Desc=$ZCONVERT(Desc ,"U")
	s index=1
	s TRow=0
	
	s TName=0
	f  s TName=$o(^DHCEQCCode("DHCEQCBarDetailKey",0,"Name",TName)) quit:TName=""  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQCCode("DHCEQCBarDetailKey",0,"Name",TName,rowid)) quit:rowid=""  d
	..d ResetVariablesGetBarDetailKeyList
	..s TRowID=rowid
	..q:$p($g(^DHCEQCCode("DHCEQCBarDetailKey",TRowID)),"^",3)="Y"
	..;s TName=$p($g(^DHCEQCCode("DHCEQCBarDetailKey",TRowID)),"^",1) //代码
	..s TDesc=$p($g(^DHCEQCCode("DHCEQCBarDetailKey",TRowID)),"^",2) //描述
	..;q:($ZCONVERT(TDesc,"U")'[Desc)&&(Desc'="")
	..q:($ZCONVERT(TDesc,"U")'[Name)&&($ZCONVERT(TName,"U")'[Name)&&(Name'="")
	..s THold1=$p($g(^DHCEQCCode("DHCEQCBarDetailKey",TRowID)),"^",4)
	..s THold2=$p($g(^DHCEQCCode("DHCEQCBarDetailKey",TRowID)),"^",5)
	..s THold3=$p($g(^DHCEQCCode("DHCEQCBarDetailKey",TRowID)),"^",6)
	..d OutputRowGetBarDetailKeyList
	Quit $$$OK
OutputRowGetBarDetailKeyList
	Set TRow=TRow+1
   	Set Data=$lb(TRow,TRowID,TName,TDesc,THold1,THold2,THold3)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	
	quit
ResetVariablesGetBarDetailKeyList
	s (TRowID,TDesc,THold1,THold2,THold3)=""
	quit
}

ClassMethod BarDetailKeyListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BarDetailKeyListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod BarDetailKeyListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BarDetailKeyListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// MZY0087	2021-08-13
/// d ##class(%ResultSet).RunQuery("web.DHCEQCBarInfo","Hold1List")
Query Hold1List() As %Query(ROWSPEC = "TDesc:%String,TID:%String")
{
}

ClassMethod Hold1ListExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	s rowid=0
	s Desc="设备"
	d OutputRowHold1List
	
	s rowid=1
	s Desc="附件"
	d OutputRowHold1List
	
	s rowid=2
	s Desc="报废"
	d OutputRowHold1List
	
	Quit $$$OK
OutputRowHold1List
	Set Data=$lb(Desc,rowid)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
}

ClassMethod Hold1ListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = Hold1ListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod Hold1ListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = Hold1ListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
