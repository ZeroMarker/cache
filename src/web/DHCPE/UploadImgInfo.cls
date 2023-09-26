Class web.DHCPE.UploadImgInfo Extends %RegisteredObject
{

// w ##class(web.DHCPE.UploadImgInfo).OutNumTypeToHTML()

ClassMethod OutNumTypeToHTML(ContrlWidth As %String = "", DefaultValue As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	s IP=##class(ext.util.String).ClientIP()
	q:(IP="") $$$OK
	s DefaultValue=$g(^DHCPEDataEx("UpLoadImgNumType",IP))
	w "<select name='NumType' id='NumType' style='width:"_ContrlWidth_"' HEIGHT=0  tabIndex=2>",!
	w "<option value=''>  </option>",!
	s selected=""
	s:DefaultValue="Reg" selected="selected"
	w "<option value='Reg' "_selected_"> 登记号 </option>",!
	s selected=""
	s:DefaultValue="HpNo" selected="selected"
	w "<option value='HpNo' "_selected_"> 体检号 </option>",!
	
	w "</select>",!
	Quit ""
}

// OtherInfo:项目ID，图片路径，是否读取txt文件

/// 保存上传设置信息
ClassMethod SaveOtherInfo(ComputeName, OtherInfo, NumType As %String = "")
{
	q:ComputeName="" ""
	s ^DHCPEDataEx("UpLoadImgNumType",ComputeName)=NumType
	s ^DHCPEDataEx("UploadImgInfo",ComputeName)=OtherInfo
	q 0
}

ClassMethod SaveResultInfo(OEID, DocID, ResultStr)
{
	s OEID=##class(web.DHCPE.ReportGetInfor).Replace(OEID,"-","||")
	s ^wrzUploadImgInfo=ResultStr
	s ArcimID=$P(^OEORD(+OEID,"I",$P(OEID,"||",2),1),"^",2)
	s ArcimDesc=$P(^ARCIM(+ArcimID,1,1),"^",2)
	s ^wrzUploadImgInfo(0)=ArcimDesc
	i ArcimDesc="14碳呼气试验(各类呼气试验)"{
		s ODID="40||1"
		s Result="DPM="_$P(ResultStr,":DPM=",2)
		s ResultStr=OEID_"^"_ODID_"^"_Result
	}elseif ArcimDesc="骨密度测定"{
		s ODID="11||3"
		s MinValue=""
		s MaxValue=""
		s ResultLength=$L(ResultStr,"^")
		for i=1:1:ResultLength{
			s OneResult=$P(ResultStr,"^",i)
			s OneValue=$E(OneResult,66,70)
			s OneValue=##class(web.DHCPE.ReportGetInfor).Replace(OneValue," ","")
			continue:OneValue="-"
			i MinValue="" d
			.s MinValue=OneValue
			.s MaxValue=OneValue
			e  d
			.i MinValue>OneValue d
			..s MinValue=OneValue
			.i MaxValue<OneValue d
			..s MaxValue=OneValue
		}
		i (MinValue>(-0.9)) d
		.s Result="骨质正常"
		e  i (MinValue>(-2.5)) d
		.s Result="骨量减少"
		e  d
		.s Result="骨质疏松"
		s ResultStr=OEID_"^"_ODID_"^"_Result
	}else{
		s ResultStr=""
	}
	q:ResultStr="" "0"
	s CheckDate=$ZD($H,3)
	s ret=##class(web.DHCPE.ResultNew).SaveResult(ResultStr,DocID,"",CheckDate)
	q ret
}

// OtherInfo:项目ID，图片路径，是否读取txt文件，项目名称

/// 得到上传信息
ClassMethod GetOtherInfo(ComputeName)
{
	q:ComputeName="" ""
	s OtherInfo=$G(^DHCPEDataEx("UploadImgInfo",ComputeName))
	q:OtherInfo="" OtherInfo
	s ItemID=$P(OtherInfo,"^",1)
	s ItemName=""
	s:ItemID'="" ItemName=$P(^ARCIM(+ItemID,1,1),"^",2)
	q OtherInfo_"^"_ItemName
}

/// 获取对应的医嘱ID
ClassMethod GetOEIDInfo(ARCIMID, FileName As %String = "", LastFileName)
{
	;w ##class(web.DHCPE.UploadImgInfo).GetOEIDInfo("3065||1","0000000006.jpg^000000002.tif^000000002.txt^00000000303.txt^0000000316.txt^0000001390.txt^00000013902.txt^00000013903.txt^1.jpg^123123.txt^1231232.txt^123456.txt^Book1.pdf^Book1.txt","jpg")
	q:FileName="" ""
	s LastFileName=$ZCVT(LastFileName,"U")
	s FileName=##class(web.DHCPE.ReportGetInfor).Replace(FileName,"\","/")
	;s FileName=$ZCVT(FileName,"U")
	
	S Falseinfo="",Trueinfo=""
	s C1=$C(1)
	s C2=$C(2)
	s FileLength=$L(FileName,"^")
	f i=1:1:FileLength d
	.s OneFileName=$P(FileName,"^",i)
	.s OneFileName=$P(OneFileName,"/",$L(OneFileName,"/"))
	.s OneLastFileName=$P(OneFileName,".",$L(OneFileName,"."))
	.s OneLastFileName=$ZCVT(OneLastFileName,"U")
	.q:OneLastFileName'=LastFileName
	.s RegNo=$p($p(OneFileName,"-",1),".",1)
	.//s RegNo=+OneFileName
	.//s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
	.s OEID=..GetLastOEID(RegNo,ARCIMID)
	.i OEID="" d
	..s Falseinfo=##class(%ArrayOfDataTypes).%New()
	..s oeidList=##class(%ListOfDataTypes).%New()
	..s oeid=##class(%ArrayOfDataTypes).%New()
	..d oeid.SetAt(OEID,"OEID")
	..d oeid.SetAt(OneFileName,"OneFileName")
	..d oeidList.Insert(oeid)
    ..d Falseinfo.SetAt(oeidList,"OEIDStr")
    ..//q ##class(Nur.JSON).Encode(Falseinfo)
	.e  d
	..s Trueinfo=##class(%ArrayOfDataTypes).%New()
	..s TrueoeidList=##class(%ListOfDataTypes).%New()
	..s Trueoeid=##class(%ArrayOfDataTypes).%New()
	..d Trueoeid.SetAt(OEID,"OEID")
	..d Trueoeid.SetAt(OneFileName,"OneFileName")
	..d TrueoeidList.Insert(oeid)
    ..d Trueinfo.SetAt(TrueoeidList,"OEIDStr")
    	
	q ##class(Nur.JSON).Encode(Trueinfo)_C2_##class(Nur.JSON).Encode(Falseinfo)
	
	
	/*.i OEID="" d
	..s OneInfo=OEID_"^"_OneFileName
	..i FalseInfo="" d
	...s FalseInfo=OneInfo
	..e  d
	...s FalseInfo=FalseInfo_C1_OneInfo
	.e  d
	..s OneInfo=OEID_"^"_OneFileName
	..i TrueInfo="" d
	...s TrueInfo=OneInfo
	..e  d
	...s TrueInfo=TrueInfo_C1_OneInfo
	
	q:(TrueInfo="")&&(FalseInfo="") ""
	q TrueInfo_C2_FalseInfo*/
}

// w ##class(web.DHCPE.UploadImgInfo).GetLastOEID("PT00000035.jpg","2727||1")

ClassMethod GetLastOEID(RegNo, ARCIMID)
{
	s IP=##class(ext.util.String).ClientIP()
	q:(IP="") ""
	s DefaultValue=$g(^DHCPEDataEx("UpLoadImgNumType",IP))
	i DefaultValue="HpNo"{
	
	s IADM=""
	s PIADM=""
	f  s PIADM=$o(^DHCPEPreIADM(0,"HPNo",RegNo,PIADM),-1) q:(PIADM="")||(IADM'="")  d
	.s Status=$p($g(^DHCPEPreIADM(PIADM)),"^",8)
	.q:(Status'="ARRIVED")&&(Status'="REGISTERED")
	.s IADM=PIADM
	
	}
	else{
	s PIBI=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
	q:PIBI="" ""
	s IADM=""
	s PIADM=""
	f  s PIADM=$o(^DHCPEPreIADM(0,"PIBI",PIBI,PIADM),-1) q:(PIADM="")||(IADM'="")  d
	.q:(1=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PIADM))
	.s Status=$p($g(^DHCPEPreIADM(PIADM)),"^",8)
	.q:(Status'="ARRIVED")&&(Status'="REGISTERED")
	.s IADM=PIADM
	
	}
	//b ;3
	q:IADM="" ""
	s IADM=$O(^DHCPEIADM(0,"CRMADM",IADM,0))
	q:IADM="" ""
	s PAADM=$P($g(^DHCPEIADM(IADM)),"^",1)
	q:PAADM="" ""
	s OrderID=$O(^OEORD(0,"Adm",PAADM,0))
	q:OrderID="" ""
	s OrderSub=""
	s SttDate=""
	f  s SttDate=$O(^OEORDi(0,"ARCIM",OrderID,ARCIMID,SttDate),-1) q:(SttDate="")||(OrderSub'="")  d
	.s Sub=""
	.f  s Sub=$O(^OEORDi(0,"ARCIM",OrderID,ARCIMID,SttDate,Sub),-1) q:(Sub="")||(OrderSub'="")  d
	..s Stat=$P($g(^OEORD(OrderID,"I",Sub,1)),"^",13)
	..q:Stat="4"
	..s OrderSub=Sub
	
	q:OrderSub="" ""
	q OrderID_"-"_OrderSub
}

ClassMethod SaveUploadInfo(OEID, UserID, FTPFileName, DeleteFlag As %String = "1")
{
	s OEID=##class(web.DHCPE.ReportGetInfor).Replace(OEID,"-","||")
	s Sort=$I(^DHCPEDataEx("UploadImg",OEID))
	if DeleteFlag=1 d
	.m ^DHCPEDataEx("UploadImgDelete",OEID)=^DHCPEDataEx("UploadImg",OEID)
	.s Date=+$g(^DHCPEDataEx("UploadImg",OEID))
	.k ^DHCPEDataEx("UploadImgDate",Date,OEID)
	.k ^DHCPEDataEx("UploadImg",OEID)
	.s ^DHCPEDataEx("UploadImg",OEID)=Sort
	.
	s FTPFileName=##class(web.DHCPE.ReportGetInfor).Replace(FTPFileName,"||","-")
	
	s ^DHCPEDataEx("UploadImg",OEID,Sort)=$H_"^"_UserID_"^"_FTPFileName
	s ^DHCPEDataEx("UploadImgDate",+$H,OEID,Sort)=$H_"^"_UserID_"^"_FTPFileName
	q ""
}

// w ##class(web.DHCPE.UploadImgInfo).GetOESort("643-2")

ClassMethod GetOESort(OEID)
{
	s OEID=$replace(OEID,"-","||")
	//b ;1
	q $g(^DHCPEDataEx("UploadImg",OEID))+1
}

// 

// w ##class(web.DHCPE.UploadImgInfo).GetHadUpLoadInfos("2727||1")

ClassMethod GetHadUpLoadInfos(Item, Date As %String = "")
{
	s:(Date="") Date=+$H
	s ret=""
	s OEID=""
	f  s OEID=$o(^DHCPEDataEx("UploadImgDate",Date,OEID)) q:(OEID="")  d
	.s CurArc=$P(^OEORD(+OEID,"I",$P(OEID,"||",2),1),"^",2)
	.q:(CurArc'=Item)
	.s PAADM=$p(^OEORD(+OEID),"^",1)
	.s PatID=$p(^PAADM(PAADM),"^",1)
	.s PatName=$p($g(^PAPER(PatID,"ALL")),"^",1)
	.s Reg=$p(^PAPER(PatID,"PAT",1),"^",1)
	.s Sort=""
	.f  s Sort=$o(^DHCPEDataEx("UploadImgDate",Date,OEID,Sort)) q:(Sort="")  d
	..s Hadinfo=##class(%ArrayOfDataTypes).%New()
	..s oeidList=##class(%ListOfDataTypes).%New()
	..s oeid=##class(%ArrayOfDataTypes).%New()
	..d oeid.SetAt(Reg_PatName_Sort,"Info")
	..d oeidList.Insert(oeid)
    ..d Hadinfo.SetAt(oeidList,"OEIDStr")
    
    q ##class(Nur.JSON).Encode(Hadinfo)
	
	
	/*..s:(ret'="") ret=ret_"^"_Reg_PatName_Sort
	..s:(ret="") ret=Reg_PatName_Sort
	..
	q ret*/
}

/// 根据输入条件查找站点 涉及组件 DHCPEStation.List
/// ImgPath+"^"+LastFileName+"^"+ReadTxt;
///  d ##class(%ResultSet).RunQuery("web.DHCPE.UploadImgInfo","FindInfo","","")
Query FindInfo(ComputerName As %Library.String = "", ItemName As %Library.String = "") As %Query(ROWSPEC = "TComputerName:%String,TItemName:%String,ImgPath:%String,LastFileName:%String,ReadText:%String")
{
}

ClassMethod FindInfoExecute(ByRef qHandle As %Binary, ComputerName As %Library.String = "", ItemName As %Library.String = "") As %Status
{
	

	Set repid=$I(^CacheTemp)
 	s ind=1
 	//  s ^DHCPEDataEx("UploadImgInfo",ComputeName)=OtherInfo
 	s ^DHCPEDataExTMP("UploadImgInfo")=ComputerName_"^"_ItemName
 	s TComputerName=""	//
	f  s TComputerName=$o(^DHCPEDataEx("UploadImgInfo",TComputerName)) q:TComputerName=""  d
	.//w TComputerName_"TComputerName"
	.q:(ComputerName'="")&&(ComputerName'=TComputerName)
	.s CurData=$g(^DHCPEDataEx("UploadImgInfo",TComputerName))
	.s TItemName=$p(CurData,"^",1)
	.s TItemNameDesc=$p($g(^ARCIM(+TItemName,$p(TItemName,"||",2),1)),"^",2)
	.q:(""'=ItemName)&(ItemName'=TItemNameDesc)
	.// ImgPath+"^"+LastFileName+"^"+ReadTxt
    .s ImgPath=$p(CurData,"^",2)
    .s LastFileName=$p(CurData,"^",3)
    .s ReadTxt=$p(CurData,"^",4)
    .i (ReadTxt="1") s ReadTxt="是"
    .e  s ReadTxt="否"
    .d FindBuild	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
FindBuild      
	set Data=$lb(TComputerName,TItemNameDesc,ImgPath,LastFileName,"是")
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
