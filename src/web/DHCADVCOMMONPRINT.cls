Import SQLUser

/// Creator: 	Congyue&huaxiaoying
/// CreateDate: 2017-12-12
/// Descript: 	不良事件打印公共类
Class web.DHCADVCOMMONPRINT Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// 表单元素Code获取ID
/// W ##Class(web.DHCADVCOMMONPRINT).GetDiscIdByCode("PatName")
ClassMethod GetDiscIdByCode(DisCode)
{
	n (DisCode)
	q:DisCode="" ""
	s DisId = $o(^User.DHCAdvFormDicI("IndexField",$$ALPHAUP^SSUTIL4(DisCode),""))
	q DisId
}

/// 表单元素描述获取ID
/// W ##Class(web.DHCADVCOMMONPRINT).GetDiscIdByLable("PatEventProcess-95032")
ClassMethod GetDiscIdByLable(DisLable)
{
	n (DisLable)
	q:DisLable="" ""
	s DisId = $o(^User.DHCAdvFormDicI("IndexTitle",DisLable,""))
	q DisId
}

/// 表单元素ID获取信息
/// return:lb("",code(唯一标示),类型,Lable,url,父元素id)
/// W ##Class(web.DHCADVCOMMONPRINT).GetDiscIdByCode("")
/// w ##class(web.DHCADVCOMMONPRINT).GetDiscInfoByDisId("94099")
ClassMethod GetDiscInfoByDisId(DisId)
{
	n (DisId)
	q:DisId="" ""
	s Data = $g(^User.DHCAdvFormDicD(DisId))
	s Ret=$lg(Data,2)_"^"_$lg(Data,3)_"^"_$lg(Data,4)_"^"_$lg(Data,5)_"^"_$lg(Data,$lg(Data,6))
	q Ret
}

/// Description: 获取 数据保存值 
/// Creator:     CongYue
/// CreateDate:  2017-12-12
/// Input:  	 record : 表单填写记录表ID, formdic:元素rowid
/// Table:       FormRecordItm,FormDic
/// Return: 	 Data  数据保存值
/// Others:		 w ##class(web.DHCADVCOMMONPRINT).GetRecordItmData(56,89001)
ClassMethod GetRecordItmData(record As %String, formdic As %String)
{
	n (record,formdic)
	s recordItmID="",Data=""
	f  s recordItmID=$o(^User.DHCAdvFormRecordItmI("IndexFormRecord",record,recordItmID)) q:recordItmID=""  d
	.s dataList=^User.DHCAdvFormRecordItmD(recordItmID)
	.s ItmformDicDr=$LIST(dataList,3) ;元素表指向
	.q:(ItmformDicDr'="")&&(formdic'=ItmformDicDr)
	.S Datalist=$LIST(dataList,4)
	.S:(Datalist'="")&(Datalist'="title") Data=Datalist
	.Q:Data'=""
	q Data
}

/// Description: 获取打印数据
/// RETURN: json数据
/// INPUT: AdvMaster ID
/// w ##class(web.DHCADVCOMMONPRINT).GetPrintData(2)
ClassMethod GetPrintData(AdvMasterDr)
{
	n (AdvMasterDr)
	s repid=##class(web.DHCADVCOMMON).NewPid()
	k ^TMP("DHCADV","web.DHCADVCOMMONPRINT","GetPrintData")
	q:AdvMasterDr="" ""
	;s RsDate="",RsString="",tableName=""
	S RepLocDr=$p(^DHCADVMASTER(AdvMasterDr),"^",7)
	S:RepLocDr'="" RepLoc=$p(^CTLOC(RepLocDr),"^",2)
	S:RepLoc["-" RepLoc=$p(RepLoc,"-",2)
	;S Loclist=##class(web.DHCADVJSONCOMMON).getJsonDataPort("RepLoc",RepLoc,"#")
	S LocDep=##class(web.DHCADVCOMMONPART).GetSecuGroupDesc(RepLocDr)
	
	S ADVFormRecDr = $p(^DHCADVMASTER(AdvMasterDr),"^",1)
	S DataList=..GetPrintDataList(ADVFormRecDr,RepLoc,LocDep)
	q DataList
}

/// Description: 获取打印数据
/// RETURN: json数据
/// INPUT: AdvMaster ID
/// w ##class(web.DHCADVCOMMONPRINT).GetPrintDataList(15,"","")
ClassMethod GetPrintDataList(ADVFormRecDr, RepLoc, LocDep)
{
	n (ADVFormRecDr,RepLoc,LocDep)
	s repid=##class(web.DHCADVCOMMON).NewPid()
	k ^TMP("DHCADV","web.DHCADVCOMMONPRINT","GetPrintData")
	q:ADVFormRecDr="" ""
	s RsDate="",RsString="",tableName=""
	s ADVFormRecItmDr=""
	f  s ADVFormRecItmDr = $o(^User.DHCAdvFormRecordItmI("IndexFormRecord",ADVFormRecDr,ADVFormRecItmDr))  q:ADVFormRecItmDr=""  d
	.s ADVFormDicID = $lg(^User.DHCAdvFormRecordItmD(ADVFormRecItmDr),3)  //元素ID
	.s ItmValue = $lg(^User.DHCAdvFormRecordItmD(ADVFormRecItmDr),4)  //值
	.s ItmID = $lg(^User.DHCAdvFormDicD(ADVFormDicID),2)        //元素唯一标示，对应界面的ID
	.s DataRowKey = $lg(^User.DHCAdvFormRecordItmD(ADVFormRecItmDr),7)  //Key 只有table才有的标识
	.s:DataRowKey ^TMP("DHCADV","web.DHCADVCOMMONPRINT","GetPrintData",repid,$p(ItmID,"-",1))=""
	.q:DataRowKey'=""     //table 数据单独写
	.q:ItmValue="title"
	.;这个下面是获取数据内容：RsString 返回json数据的title  RsDate：返回数据的data串
	.s:RsDate'="" RsDate = RsDate_"#"_ItmValue
	.s:RsString'="" RsString = RsString_"#"_ItmID
	.s:RsDate="" RsDate = RepLoc_"#"_LocDep_"#"_ItmValue
	.s:RsString="" RsString = "RepLoc"_"#"_"LocDep"_"#"_ItmID
	s TableName=""
	f  s TableName =$o(^TMP("DHCADV","web.DHCADVCOMMONPRINT","GetPrintData",repid,TableName)) q:TableName=""  d
	.s:RsDate'="" RsDate = RsDate_"#"_##class(web.DHCADVCOMMONPRINT).GetDatagridData(ADVFormRecDr,TableName)
	.s:RsString'="" RsString = RsString_"#"_TableName
	.s:RsDate="" RsDate = ##class(web.DHCADVCOMMONPRINT).GetDatagridData(ADVFormRecDr,TableName)
	.s:RsString="" RsString = TableName 
	q ##class(web.DHCADVJSONCOMMON).getJsonDataPort(RsString,RsDate,"#")
}

/// 传入唯一确定table的前面的Code
/// w ##class(web.DHCADVCOMMONPRINT).GetDatagridData(2,"UlcerPart-95158-95163-95171")
ClassMethod GetDatagridData(ADVFormRecDr, TableParrefCode)
{
	n (ADVFormRecDr,TableParrefCode)
	s Count=0
	s repid=##class(web.DHCADVCOMMON).NewPid()
	k ^TMP("DHCADV","web.DHCADVCOMMONPRINT","GetDatagridData")
	q:ADVFormRecDr="" ""
	s RsDate="",RsString=""
	;s ADVFormRecDr = $p(^DHCADVMASTER(AdvMasterDr),"^",1)
	s ADVFormRecItmDr=""
	f  s ADVFormRecItmDr = $o(^User.DHCAdvFormRecordItmI("IndexFormRecord",ADVFormRecDr,ADVFormRecItmDr))  q:ADVFormRecItmDr=""  d
	.s ADVFormDicID = $lg(^User.DHCAdvFormRecordItmD(ADVFormRecItmDr),3)  //元素ID
	.s ItmValue = $lg(^User.DHCAdvFormRecordItmD(ADVFormRecItmDr),4)  //值
	.s ItmID = $lg(^User.DHCAdvFormDicD(ADVFormDicID),2)        //元素唯一标示，对应界面的ID
	.q:ItmID'[TableParrefCode         //只保留表格数据
	.q:ItmValue="title"
	.s DataRowKey = $lg(^User.DHCAdvFormRecordItmD(ADVFormRecItmDr),7)  //Key
	.q:DataRowKey=""
	.s Count=Count+1
	.s ^TMP("DHCADV","web.DHCADVCOMMONPRINT","GetDatagridData",repid,DataRowKey,Count) = ItmID_"^"_ItmValue
	
	s Num=0,ret=""
	s ret = "["
	s DataRowKey=0
	f  s DataRowKey = $o(^TMP("DHCADV","web.DHCADVCOMMONPRINT","GetDatagridData",repid,DataRowKey)) q:DataRowKey=""  d
	.s Count=0,RsStr="",RsData=""
	.f  s Count = $o(^TMP("DHCADV","web.DHCADVCOMMONPRINT","GetDatagridData",repid,DataRowKey,Count)) q:Count=""  d
	..s Data = ^TMP("DHCADV","web.DHCADVCOMMONPRINT","GetDatagridData",repid,DataRowKey,Count)
	..s:RsStr'="" RsStr = RsStr_"^"_$p(Data,"^",1)
	..s:RsData'="" RsData = RsData_"^"_$p(Data,"^",2)
	..s:RsStr="" RsStr = $p(Data,"^",1)
	..s:RsData="" RsData= $p(Data,"^",2)
	.s ret=ret_$case(Num,0:"",:",")
	.s Num=Num+1
	.s ret=ret_##class(web.DHCADVJSONCOMMON).getJsonDataPort(RsStr,RsData)
	s ret=ret_"]"
	q ret
}

/// 传入唯一确定table的前面的Code
/// w ##class(web.DHCADVCOMMONPRINT).GetTableData(2,"UlcerPart","UlcerPart-95158-95163")
ClassMethod GetTableData(AdvMasterDr, TableParrefCode, SelItmID)
{
	n (AdvMasterDr,TableParrefCode,SelItmID)
	s Count=0
	s repid=##class(web.DHCADVCOMMON).NewPid()
	k ^TMP("DHCADV","web.DHCADVCOMMONPRINT","GetTableData")
	q:AdvMasterDr="" ""
	s RsDate="",RsString=""
	s ADVFormRecDr = $p(^DHCADVMASTER(AdvMasterDr),"^",1)
	s ADVFormRecItmDr=""
	f  s ADVFormRecItmDr = $o(^User.DHCAdvFormRecordItmI("IndexFormRecord",ADVFormRecDr,ADVFormRecItmDr))  q:ADVFormRecItmDr=""  d
	.s ADVFormDicID = $lg(^User.DHCAdvFormRecordItmD(ADVFormRecItmDr),3)  //元素ID
	.s ItmValue = $lg(^User.DHCAdvFormRecordItmD(ADVFormRecItmDr),4)  //值
	.q:'$d(^User.DHCAdvFormDicD(ADVFormDicID))
	.s ItmID = $lg(^User.DHCAdvFormDicD(ADVFormDicID),2)        //元素唯一标示，对应界面的ID
	.q:ItmID'[TableParrefCode         //只保留表格数据
	.q:ItmValue="title"
	.s DataRowKey = $lg(^User.DHCAdvFormRecordItmD(ADVFormRecItmDr),7)  //Key
	.q:DataRowKey=""
	.s ^TMP("DHCADV","web.DHCADVCOMMONPRINT","GetTableData",repid,DataRowKey,ItmID) = ItmValue
	
	s Ret=""
	s DataRowKey="" 
	f  s DataRowKey = $o(^TMP("DHCADV","web.DHCADVCOMMONPRINT","GetTableData",repid,DataRowKey)) q:DataRowKey=""  d
	.s HasData="",AreaDesc=""
	.s ItmID= SelItmID
	.f  s ItmID = $o(^TMP("DHCADV","web.DHCADVCOMMONPRINT","GetTableData",repid,DataRowKey,ItmID)) q:ItmID=""  d
	..q:ItmID'[SelItmID
	..s Data = $g(^TMP("DHCADV","web.DHCADVCOMMONPRINT","GetTableData",repid,DataRowKey,ItmID))
	..i SelItmID'="UlcerPart-95158-95189" d
	...s HasData=1
	...i $l(ItmID,"-")=5 d
	....s:Ret'="" Ret=Ret_"("_Data_")"
	....s:Ret="" Ret=Data
	...i $l(ItmID,"-")'=5 d
	....s:Ret'="" Ret=Ret_","_Data
	....s:Ret="" Ret=Data
	..i SelItmID="UlcerPart-95158-95189" d
	...s HasData=1
	...s:AreaDesc'="" AreaDesc=AreaDesc_"*"_Data
	...s:AreaDesc="" AreaDesc=Data
	.i SelItmID="UlcerPart-95158-95189" d
	..q:+AreaDesc=0
	..s:Ret'="" Ret=Ret_","_AreaDesc
	..s:Ret="" Ret=AreaDesc
	.i HasData="" d
	..s:Ret'="" Ret=Ret_",无"
	..s:Ret="" Ret="无"
	
	q Ret
}

/// Description: 获取不良事件word导出程序
/// Creator:     CongYue
/// CreateDate:  2017-12-21  
/// Table:		 
/// Input:   	 报告ID(master表的id)
/// Output:  	 上报日期，发生日期，发生时间，医疗机构名称，不良事件类别，事件经过 
/// Others:		 w ##class(web.DHCADVCOMMONPRINT).GetExportbyWord("15","")
ClassMethod GetExportbyWord(AdvMasterDr, RepTypeCode) As %String
{
	n (AdvMasterDr,RepTypeCode)
	Q:AdvMasterDr=""
	S RepDate="",OccDate="",OccTime="",RepType="",RepProcess=""
	S recordid=$p(^DHCADVMASTER(AdvMasterDr),"^",1)
	S RepDate=$p(^DHCADVMASTER(AdvMasterDr),"^",4)
	S:RepDate'="" RepDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(RepDate)
	S OccDate=$p(^DHCADVMASTER(AdvMasterDr),"^",25)
	S OccTime=$p(^DHCADVMASTER(AdvMasterDr),"^",26)
	S:OccTime'="" OccTime=$zt(OccTime,1)
	S RepProcess=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("WLEventProcess"))
	S:RepTypeCode="advSkinUlcer" OccDate=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("UlcerPart-95158-95162-95192"))
	S:OccDate'="" OccDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(RepDate)
	q RepDate_"^"_OccDate_" "_OccTime_"^"_RepProcess
}

/// Description: 获取不良事件朝阳医疗机构excel导出程序
/// Creator:     CongYue
/// CreateDate:  2017-12-21  
/// Table:		 
/// Input:   	 
/// Output:  	 上报日期，发生日期，发生时间，医疗机构名称，不良事件类别，事件经过 
/// Others:		 w ##class(web.DHCADVCOMMONPRINT).GetExportbyExcel("2017-12-15","2017-12-22")
ClassMethod GetExportbyExcel(StDate, EndDate) As %String
{
	n (StDate,EndDate)
	
	S ListNum=""
	S Ulcernum=0,Pipenum=0,Fallnum=0,Drugerrnum=0,Accidentnum=0,Wallnum=0,RepTypeCode=""
	S ulcernumall=0,ulcerinqy=0,ulcerinhz=0,ulcerinwfz=0,ulcerinfz=0,ulcerinOne=0,ulcerinTwo=0,ulcerinThr=0,ulcerinFour=0,ulcerinFive=0,ulcerinSix=0,ulcerout=0
	S pipewg=0,pipeng=0,pipesjm=0,pipeoth=0
	S Falltypnum=0,Downtypnum=0
	S DrugPaterr=0,DrugTimeerr=0,Drugjlerr=0,Drugotherr=0
	S Accidentlost=0,Accidentkill=0,Accidentts=0,Accidentoth=0
	S Wallmed=0,Walldrug=0,Wallnur=0,Walloth=0
	S:StDate'="" StDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(StDate)
	S:EndDate'="" EndDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(EndDate)
	q:StDate="" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符  //yangyongtao   2017-11-22
	f date=StDate:1:EndDate d
	.s RepID="",Ulcerorignin="",Ulcerorignout="",Ulcerlevone="",Ulcerlevtwo="",Ulcerlevthr="",Ulcerlevfour="",Ulcerlevfive="",Ulcerlevsix=""
	.s Pipetwgype="",Pipetngype="",Pipetsjmype="",Falltyp="",Downtype=""
	.s DrugPattype="",DrugTimtype="",Drugjltype="",Accidentlosttype="",Accidentkilltype="",Accidenttstype="",Wallmedtype="",Walldrugtype="",Wallnurtype=""
	.f  s RepID=$o(^DHCADVMASTER(0,"RepDate",date,RepID)) q:RepID=""  d
	..S RepCancelflag=""
	..S recordid=$p(^DHCADVMASTER(RepID),"^",1)
	..Q:recordid=""
	..S RepTypeDr=$p(^DHCADVMASTER(RepID),"^",2)
	..;S:RepTypeDr'="" RepTypeCode=$p(^DHCMEDADREVT(RepTypeDr),"^",1)
	..S RepTypeCode=""  
	..S:(RepTypeDr'="")&&(RepTypeDr'["||") RepTypeCode=$p(^DHCMEDADREVT(RepTypeDr),"^",1)
	..S:(RepTypeDr'="")&&(RepTypeDr["||") RepTypeCode=$p(^DHCMEDADREVTI(+RepTypeDr,"MADREVI",$p(RepTypeDr,"||",2)),"^",1)	
	..S:RepTypeCode="advSkinUlcer" Ulcernum=Ulcernum+1
	..S:RepTypeCode="advPipeOff" Pipenum=Pipenum+1
	..S:RepTypeCode="advFallDownFill" Fallnum=Fallnum+1
	..S:RepTypeCode="advDrugUseErr" Drugerrnum=Drugerrnum+1
	..S:RepTypeCode="advAccidentFill" Accidentnum=Accidentnum+1
	..S:RepTypeCode="advWallLeakage" Wallnum=Wallnum+1
	..S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,RepID,""),-1)
	..S:MedadrID'="" RepCancelflag=$p(^DHCMEDREPADT(MedadrID),"^",11) ;作废标识
	..Q:RepCancelflag="Y"
	..S Ulcerorign=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("UlcerPart-95158-95163-95170"))
	..S:Ulcerorign'="" ulcernumall=ulcernumall+1 //院内发生 总数
	..S Ulcerorignout=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("UlcerPart-95158-95163-95171")) 
	..S:Ulcerorignout'="" ulcerout=ulcerout+1 //院外带入
	..S Ulcerlevone=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("UlcerPart-95158-95169-95183"))
	..S:Ulcerlevone'="" ulcerinOne=ulcerinOne+1 //Ⅰ
	..S Ulcerlevtwo=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("UlcerPart-95158-95169-95184"))
	..S:Ulcerlevtwo'="" ulcerinTwo=ulcerinTwo+1 //Ⅱ
	..S Ulcerlevthr=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("UlcerPart-95158-95169-95185"))
	..S:Ulcerlevthr'="" ulcerinThr=ulcerinThr+1 //Ⅲ
	..S Ulcerlevfour=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("UlcerPart-95158-95169-95186"))
	..S:Ulcerlevfour'="" ulcerinFour=ulcerinFour+1 //Ⅳ
	..S Ulcerlevfive=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("UlcerPart-95158-95169-95187"))
	..S:Ulcerlevfive'="" ulcerinFive=ulcerinFive+1  //Ⅴ
	..S Ulcerlevsix=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("UlcerPart-95158-95169-95188"))
	..S:Ulcerlevsix'="" ulcerinSix=ulcerinSix+1 //Ⅵ
	
	..S Pipetwgype=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("PipeType-94449"))
	..S:Pipetwgype'="" pipewg=pipewg+1 //胃管
	..S Pipetngype=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("PipeType-94450"))
	..S:Pipetngype'="" pipeng=pipeng+1 //尿管
	..S Pipetsjmype=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("PipeType-94456"))
	..S:Pipetsjmype'="" pipesjm=pipesjm+1 //深静脉
	..S Pipettxglpe=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("PipeType-94451"))
	..S:Pipettxglpe'="" pipeoth=pipeoth+1 //导管事件其他 透析管路
	..S Pipetqgcgpe=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("PipeType-94452"))
	..S:Pipetqgcgpe'="" pipeoth=pipeoth+1 //导管事件其他 气管插管
	..S Pipetqgqktgpe=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("PipeType-94453"))
	..S:Pipetqgqktgpe'="" pipeoth=pipeoth+1 //导管事件其他 气管切开套管
	..S Pipetbsgpe=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("PipeType-94454"))
	..S:Pipetbsgpe'="" pipeoth=pipeoth+1 //导管事件其他 鼻饲管
	..S Pipetdmzgpe=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("PipeType-94455"))
	..S:Pipetdmzgpe'="" pipeoth=pipeoth+1 //导管事件其他 动脉置管
	..S Pipetpiccpe=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("PipeType-94457"))
	..S:Pipetpiccpe'="" pipeoth=pipeoth+1 //导管事件其他 PICC
	..S Pipetxqbspe=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("PipeType-94458"))
	..S:Pipetxqbspe'="" pipeoth=pipeoth+1 //导管事件其他 胸腔闭式引流管
	..S Pipetfqylpe=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("PipeType-94459"))
	..S:Pipetfqylpe'="" pipeoth=pipeoth+1 //导管事件其他 腹腔引流管
	..S Pipetskylpe=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("PipeType-94460"))
	..S:Pipetskylpe'="" pipeoth=pipeoth+1 //导管事件其他 伤口引流管
	..S Pipetxbylpe=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("PipeType-94461"))
	..S:Pipetxbylpe'="" pipeoth=pipeoth+1 //导管事件其他 心包引流管
	..S Pipetnsylpe=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("PipeType-94462"))
	..S:Pipetnsylpe'="" pipeoth=pipeoth+1 //导管事件其他 脑室引流管
	..S Pipetothpe=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("PipeType-94463"))
	..S:Pipetothpe'="" pipeoth=pipeoth+1 //导管事件其他 其他
	
	..S Falltyp=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("FallDownType-94261"))
	..S:Falltyp'="" Falltypnum=Falltypnum+1	 //跌倒
	..S Downtype=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("FallDownType-94262"))
	..S:Downtype'="" Downtypnum=Downtypnum+1 //坠床
	
	..S DrugPattype=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("DrugUseErrType-94616"))
	..S:DrugPattype'="" DrugPaterr=DrugPaterr+1 //给错患者
	..S DrugTimtype=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("DrugUseErrType-94617"))
	..S:DrugTimtype'="" DrugTimeerr=DrugTimeerr+1 //时间
	..S Drugjltype=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("DrugUseErrType-94621"))
	..S:Drugjltype'="" Drugjlerr=Drugjlerr+1 //剂量
	..S Drugtjtype=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("DrugUseErrType-94618"))
	..S:Drugtjtype'="" Drugotherr=Drugotherr+1 //给药途径错误 
	..S Druglosttype=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("DrugUseErrType-94619"))
	..S:Druglosttype'="" Drugotherr=Drugotherr+1 //遗漏给药
	..S Drugsysdtype=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("DrugUseErrType-94620"))
	..S:Drugsysdtype'="" Drugotherr=Drugotherr+1 //输液速度错误
	..S Drugjxtype=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("DrugUseErrType-94622"))
	..S:Drugjxtype'="" Drugotherr=Drugotherr+1 //剂型错误
	..S Drugnametype=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("DrugUseErrType-94623"))
	..S:Drugnametype'="" Drugotherr=Drugotherr+1 //药物错误
	..S Drugywxqtype=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("DrugUseErrType-94624"))
	..S:Drugywxqtype'="" Drugotherr=Drugotherr+1 //药物有效期错误
	..S Drugyothype=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("DrugUseErrType-94625"))
	..S:Drugyothype'="" Drugotherr=Drugotherr+1 //其它

	..S Accidentlosttype=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("AFType-94981"))
	..S:Accidentlosttype'="" Accidentlost=Accidentlost+1 //走失
	..S Accidentkilltype=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("AFType-94500"))
	..S:Accidentkilltype'="" Accidentkill=Accidentkill+1 //自杀
	..S Accidenttstype=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("AFType-94498"))
	..S:Accidenttstype'="" Accidentts=Accidentts+1 //烫伤

	..S Wallmedtype=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("RelatedAreas-93867"))
	..S:Wallmedtype'="" Wallmed=Wallmed+1 //堵漏/隐患事件  医疗相关
	..S Walldrugtype=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("RelatedAreas-93868"))
	..S:Walldrugtype'="" Walldrug=Walldrug+1 //堵漏/隐患事件  药事相关
	..S Wallnurtype=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("RelatedAreas-93869"))
	..S:Wallnurtype'="" Wallnur=Wallnur+1 //堵漏/隐患事件  护理相关
	..S Wallhqtype=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("RelatedAreas-93870"))
	..S:Wallhqtype'="" Walloth=Walloth+1 //堵漏/隐患事件  后勤
	..S Wallothtype=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("RelatedAreas-93871"))
	..S:Wallothtype'="" Walloth=Walloth+1 //堵漏/隐患事件  其他
	;S pipeoth=Pipenum-pipewg-pipeng-pipesjm  //导管事件其他
	;S Drugotherr=Drugerrnum-DrugPaterr-DrugTimeerr-Drugjlerr  //用药错误事件其他
	S Accidentoth=Accidentnum-Accidentlost-Accidentkill-Accidentts  //意外事件其他
	;S Walloth=Wallnum-Wallmed-Walldrug-Wallnur // 堵漏/隐患事件其他
	
	S ListNum=ulcernumall_"^"_ulcerinqy_"^"_ulcerinhz_"^"_ulcerinwfz_"^"_ulcerinfz_"^"_ulcerinOne_"^"_ulcerinTwo_"^"_ulcerinThr_"^"_ulcerinFour_"^"_ulcerinFive_"^"_ulcerinSix_"^"_ulcerout
	S ListNum=ListNum_"^"_pipewg_"^"_pipeng_"^"_pipesjm_"^"_pipeoth
	S ListNum=ListNum_"^"_Falltypnum_"^"_Downtypnum
	S ListNum=ListNum_"^"_DrugPaterr_"^"_DrugTimeerr_"^"_Drugjlerr_"^"_Drugotherr
	S ListNum=ListNum_"^"_Accidentlost_"^"_Accidentkill_"^"_Accidentts_"^"_Accidentoth
	S ListNum=ListNum_"^"_Wallmed_"^"_Walldrug_"^"_Wallnur_"^"_Walloth

	q ListNum
}

/// Description: 获取不良事件医管局excel导出程序
/// Creator:     CongYue
/// CreateDate:  2017-12-21  
/// Table:		 
/// Input:   	 
/// Output:  	 上报日期，发生日期，发生时间，医疗机构名称，不良事件类别，事件经过 
/// Others:		 w ##class(web.DHCADVCOMMONPRINT).GetExpbyExcel("2017-12-21","2017-12-22","医疗护理风险防范(堵漏/隐患)事件报告单")
ClassMethod GetExpbyExcel(StDate, EndDate, reporttype) As %String
{
	n (StDate,EndDate,reporttype)
	S ret=""
	S:StDate'="" StDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(StDate)
	S:EndDate'="" EndDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(EndDate)
	q:StDate="" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符  //yangyongtao   2017-11-22
	s num=0
	f date=StDate:1:EndDate d
	.s RepID=""
	.f  s RepID=$o(^DHCADVMASTER(0,"RepDate",date,RepID)) q:RepID=""  d
	..S RepCancelflag=""
	..S RepTypeDr=$p(^DHCADVMASTER(RepID),"^",2)
	..;S:RepTypeDr'="" RepType=$p(^DHCMEDADREVT(RepTypeDr),"^",2)
	..S RepType=""  
	..S:(RepTypeDr'="")&&(RepTypeDr'["||") RepType=$p(^DHCMEDADREVT(RepTypeDr),"^",2)
	..S:(RepTypeDr'="")&&(RepTypeDr["||") RepType=$p(^DHCMEDADREVTI(+RepTypeDr,"MADREVI",$p(RepTypeDr,"||",2)),"^",2)	
	..Q:RepType'=reporttype
	..S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,RepID,""),-1)
	..S:MedadrID'="" RepCancelflag=$p(^DHCMEDREPADT(MedadrID),"^",11) ;作废标识
	..Q:RepCancelflag="Y"
	..S RepLocDr=$p(^DHCADVMASTER(RepID),"^",7)
	..S:RepLocDr'="" RepLoc=$p(^CTLOC(RepLocDr),"^",2)
	..S:RepLoc["-" RepLoc=$p(RepLoc,"-",2)
	..;S Loclist=##class(web.DHCADVJSONCOMMON).getJsonDataPort("RepLoc",RepLoc,"#")
	..S LocDep=##class(web.DHCADVCOMMONPART).GetSecuGroupDesc(RepLocDr)
	..;S LocDepdr="",LocDep=""
	..;S:RepLocDr'="" LocDepdr=$p(^CTLOC(RepLocDr),"^",19)
	..;S:LocDepdr'="" LocDep=$p(^RBC("DEP",LocDepdr),"^",2)
	..;S LocDeplist=##class(web.DHCADVJSONCOMMON).getJsonDataPort("LocDep",LocDep,"#")
	..S DataList=..GetPrintData(RepID)
	..I ret=""  D
	...S ret=DataList
	..E  D
	...S ret=ret_","_DataList
	..
	.
	q "["_ret_"]"
}

/// Description: 获取不良事件动态excel导出程序
/// Creator:     CongYue
/// CreateDate:  2017-12-22  
/// Table:		 
/// Input:   	 
/// Output:  	 上报日期，发生日期，发生时间，医疗机构名称，不良事件类别，事件经过 
/// Others:		 w ##class(web.DHCADVCOMMONPRINT).GetExportData("2018-01-01","2020-08-06","医疗护理风险防范(堵漏/隐患)不良事件","PatDOB#PatName#EventProcess#EventInforpanel","出生日期#患者姓名#事件经过#事件基本信息","2018-01-01^2020-08-06^114^^23^114^12177^Y^87||1^^^^^^^^^^^^^N","12177^114^23^2","")
ClassMethod GetExportData(StDate, EndDate, reporttype, TitleList, DescList, StrParam As %String, LgParam As %String, ParStr As %String) As %String
{
	N (StDate,EndDate,reporttype,TitleList,DescList,StrParam, LgParam, ParStr)
    S UserId=$p(LgParam,"^",1)    //用户ID
    S LocId=$p(LgParam,"^",2)     //科室ID
	S GroupId=$p(LgParam,"^",3)   //安全组ID
	S HospId=$p(LgParam,"^",4)   //医院ID

	S StDate=$p(StrParam,"^",1)    //开始日期
	S EndDate=$p(StrParam,"^",2)   //结束日期
	S DeptID=$p(StrParam,"^",3)    //科室
	S patNo=$p(StrParam,"^",4)     //登记号
    S StatTypedr=$p(StrParam,"^",8)  //状态
    S typeevent=$p(StrParam,"^",9)    		//填报类型
    S statShare=$p(StrParam,"^",10)    		//分享状态
    S receive=$p(StrParam,"^",11)    		//接收状态
    
	S receiveflag=$p(StrParam,"^",12)    	//接收标识
    S impflag=$p(StrParam,"^",13)    		//重点关注
    S appauditflag=$p(StrParam,"^",14) 		//待审批标识
    S backflag=$p(StrParam,"^",15) 			//退回标识
    S auditflag=$p(StrParam,"^",16)  		//已处理标识
   	S inpfileflag=$p(StrParam,"^",17)  		//归档标识
	S OverTime=$p(StrParam,"^",18)    		//是否超时
	S homeAutOverTime=$p(StrParam,"^",19)   //首页是否护士长审核超时
	
	S repflag=$p(StrParam,"^",20)    //已报标识(Y) 草稿标识(N) 12
	S homeRepOverTime=$p(StrParam,"^",21)    //首页是否填报超时 16
	S Cancelflag=$p(StrParam,"^",22)   //作废界面查询 17
	
	S RepCode=$p(StrParam,"^",23)			//报告类型过滤
	S QueAudFlag=$p(StrParam,"^",24)			// 1 查询标识 2 审核标识
	S userlist=UserId_"^"_LocId_"^"_GroupId
    S IFDISTHOSP=##Class(web.DHCAppComPar).GetAppPropValue("DHCADV","IFDISTHOSP",HospId,LocId,UserId,GroupId) //hxy 2020-02-24

	S ret="",valuelist="",allList="",tablelist="",tableString="",all=""
	S:StDate'="" StDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(StDate)
	S:EndDate'="" EndDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(EndDate)
	Q:StDate="" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符  //yangyongtao   2017-11-22
	S ret=##class(web.DHCADVJSONCOMMON).getJsonDataPort(TitleList,DescList,"#")
	S num=0
	F date=StDate:1:EndDate D
	.S RepID=""
	.F  S RepID=$o(^DHCADVMASTER(0,"RepDate",date,RepID)) Q:RepID=""  D
	..S status="",RepTypeDr="",RepTypeCode="",RepType="",RepStaus="",RepUser="",RepLoc="",RepSubType="",RepImpFlag="",Medadrreceive="",Medadrreceivedr="",StatusNext="",MedadrUserID="",MedadrRevStatus="",StaFistAuditUser="",BackAuditUser="",RepOverTimeflag="",AutOverTimeflag="",RepOverTime="",AutOverTime="",RepCancelflag="",StaFistAuditUserDr="",BackAuditUserDr="",MedadrNextLocDR="",RepLevelDr=""
	..S recordid=$p(^DHCADVMASTER(RepID),"^",1)
	..Q:recordid=""
	..// 获取报告id（报告表单类型id或者报告不良事件类别勾选维护工作流的类型id） 2020-06-22
	..S RepTypeString=##class(web.DHCADVCOMMONPART).GetRepTypeString(RepID)
	..S TypeDr=$p(RepTypeString,"^",1) ; 报告表单类型id
	..S TypeCode=$p(RepTypeString,"^",2)
	..S Type=$p(RepTypeString,"^",3)
	..S RepTypeDr=$p(RepTypeString,"^",4)
	..S RepTypeCode=$p(RepTypeString,"^",5)
	..Q:Type'=reporttype	
	..S FILERowID=$o(^DHCADVFILE(0,"RepDrType",RepID,TypeDr,""))
	..S File="",FileFlag=""
	..S:FILERowID'="" File=$p(^DHCADVFILE(FILERowID),"^",3)
	..S:(File'="Y")||(File'="N") File=##class(web.DHCADVCOMMONPART).JudgeIsOutCome(RepID,TypeDr,LgParam)
	..S FileFlag=$S(File="0":"未归档",(File="1")||(File="3"):"已归档",File="4":"归档(待复核)",(File="2")||(File="5"):"撤销归档",File="N":"撤销归档",File="Y":"已归档",1:"")
	..S RepStausDr=$p(^DHCADVMASTER(RepID),"^",3)
	..I RepStausDr=""  D
	...S RepStaus="未提交"
	...S status="N"
	..E  D 
	...S status="Y"
	...S RepStaus=$p(^DHCADREVTWFI(+RepStausDr,"ADREWI",$p(RepStausDr,"||",2)),"^",2)
	..S RepDate=$p(^DHCADVMASTER(RepID),"^",4)
	..S RepTime=$p(^DHCADVMASTER(RepID),"^",5)
	..S OccurDate=$p(^DHCADVMASTER(RepID),"^",25)  ///发生日期
	..S:OccurDate="" OccurDate=0
	..S OccurTime=$p(^DHCADVMASTER(RepID),"^",26)  ///发生时间
	..S:OccurTime="" OccurTime=0
	..S RepOverTime=""
	..S HolidayDate=##class(web.DHCADVCOMMONPART).CheckTimeEscapeHoliday(OccurDate,OccurTime,RepDate,RepTime)
	..S FillTime=##class(web.DHCADVCOMMON).GetEmSysConfig("FILLTIME",LgParam)  ///填报时限时长
	..I (+FillTime'=0)&&(HolidayDate>FillTime) S RepOverTimeflag="Y"   //填报超时
	..S RepOverTime=$S(RepOverTimeflag="":"未超时",RepOverTimeflag="N":"未超时",RepOverTimeflag="Y":"已超时",1:"")
	..S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,RepID,""),-1)
	..S Subflag=0
	..S SubUserflag=0 
	..I MedadrID'=""  D
	...S Medadrreceivedr=$p(^DHCMEDREPADT(MedadrID),"^",9) 
	...I Medadrreceivedr=""  S Medadrreceivedr="未接收"
	...S Medadrreceive=$S(Medadrreceivedr="未接收":"未接收",Medadrreceivedr="1":"接收",Medadrreceivedr="2":"驳回",Medadrreceivedr="3":"撤销",Medadrreceivedr="4":"审核",Medadrreceivedr="5":"归档",Medadrreceivedr="6":"撤销归档",Medadrreceivedr="7":"归档(待复核)",1:"")
	...S MedadrUserID=$p(^DHCMEDREPADT(MedadrID),"^",4)
	...S MedadrLocID=$p(^DHCMEDREPADT(MedadrID),"^",12)
	...S MedadrRevStatus=$p(^DHCMEDREPADT(MedadrID),"^",14) ;驳回指向
	...S StaFistAuditDr=""
	...S:(RepTypeDr'="")&&(MedadrRevStatus'="") StaFistAuditUserDr=##class(web.DHCADVCOMMON).GetStaFisUserID(RepID, RepTypeDr, MedadrRevStatus ) ;$o(^DHCMEDREPADT(0,"TypeSta",RepTypeDr,MedadrRevStatus,""))
	...S:StaFistAuditUserDr'="" StaFistAuditUser=$p(^SSU("SSUSR",StaFistAuditUserDr),"^",2) ;被驳回人
	...S:Medadrreceivedr="2" BackAuditUserDr=MedadrUserID
	...S:BackAuditUserDr'="" BackAuditUser=$p(^SSU("SSUSR",BackAuditUserDr),"^",2) ;驳回操作人
	...S MedadrNextLocDR=$p(^DHCMEDREPADT(MedadrID),"^",7) ;指向科室（分派科室）
	..Q:(appauditflag'="")&&(MedadrNextLocDR'="")&&(MedadrNextLocDR'=LocId)
	..S AuditId="",RepCancelflag="",AutOverTimeflag=""
	..F  S AuditId=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,RepID,AuditId),-1)  Q:(AuditId="")  d
	...S OverTimeflag=$p(^DHCMEDREPADT(AuditId),"^",15) ;护士长审核超时标志
	...S AuditCancelflag=$p(^DHCMEDREPADT(AuditId),"^",11) ;作废标识
	...S:OverTimeflag'="" AutOverTimeflag=OverTimeflag
	...S:AuditCancelflag'="" RepCancelflag=AuditCancelflag
	..S AutOverTime=""
	..S AutOverTime=$S(AutOverTimeflag="":"未超时",AutOverTimeflag="N":"未超时",AutOverTimeflag="Y":"已超时",1:"")
	..S Medadrflag=##class(web.DHCADVSEARCHREPORT).SearchAuditIMess(MedadrID)
	..S:Medadrflag=1 Subflag=1 //转抄 
	..S:Medadrflag=2 Subflag=2 //全部回复 
	..S:Medadrflag=3 Subflag=3 //部分回复 
	..S RepLevel=$p(^DHCADVMASTER(RepID),"^",12)  ///不良事件级别
	..S RepLevelDr=$S(RepLevel["Ⅰ级事件":"1",RepLevel["Ⅱ级事件":"2",RepLevel["Ⅲ级事件":"3",RepLevel["Ⅳ级事件":"4",1:"")
	..S RepInjSev=$p(^DHCADVMASTER(RepID),"^",13) ///伤害严重度
	..S params=RepID_"^"_RepTypeCode_"^"_UserId_"^"_LocId 
	..S SubUserflag=##class(web.DHCADVSEARCHREPORT).SearchAuditIUser(MedadrID,params) 
	..S RepUserList=RepID_"^"_RepTypeDr_"^"_userlist_"^"_RepStausDr_"^"_MedadrNextLocDR_"^"_RepLevelDr
	..S matalast=##class(web.DHCADVCOMMON).InsStatusLast(RepUserList) 
	..S StatusLastID=$p(matalast,"^",2)  //上一状态
	..S StatusLast=""
	..I StatusLastID'=""  D
	...S AdrewRowIDnLast=$p(StatusLastID,"||",1)
	...S AdrewChildSubnLast=$p(StatusLastID,"||",2)
	...S StatusLast=$p(^DHCADREVTWFI(AdrewRowIDnLast,"ADREWI",AdrewChildSubnLast),"^",2)
	..S matalist=##class(web.DHCADVCOMMON).InsStatusDr(RepUserList,LgParam) 
	..S StatusNextID=$p(matalist,"^",2)  //下一状态
	..I StatusNextID'=""  D
	...S AdrewRowIDn=$p(StatusNextID,"||",1)
	...S AdrewChildSubn=$p(StatusNextID,"||",2)
	...S StatusNext=$p(^DHCADREVTWFI(AdrewRowIDn,"ADREWI",AdrewChildSubn),"^",2)
	..S:RepDate'="" RepDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(RepDate)
	..S RepUserDr=$p(^DHCADVMASTER(RepID),"^",6)
	..S:RepUserDr'="" RepUser=$p(^SSU("SSUSR",RepUserDr),"^",2)
	..S RecRepUser=##class(web.DHCADVCOMMONPART).QueryInputDataInfo(recordid,"填报人姓名")  //取匿名信息 sufan 2019-11-07
	..S:RecRepUser'="" RepUser=RecRepUser
	..S RepLocDr=$p(^DHCADVMASTER(RepID),"^",7)
	..S RepHospID="",LogHospID="" //hxy 2020-02-18 st
	..S:RepLocDr'="" RepHospID=$p($g(^CTLOC(+RepLocDr)),"^",22) 
	..S:LocId'="" LogHospID=$p($g(^CTLOC(+LocId)),"^",22)
	..Q:(IFDISTHOSP="1")&(RepHospID'="")&(LogHospID'="")&(LogHospID'=RepHospID) //登录科室医院不同于报告科室医院退出 ed
	..S:RepLocDr'="" RepLoc=$p(^CTLOC(RepLocDr),"^",2)
	..S:RepLoc["-" RepLoc=$p(RepLoc,"-",2)
	..S RepSubType=$p(^DHCADVMASTER(RepID),"^",8)
	..S RepImp=$p(^DHCADVMASTER(RepID),"^",9)
	..S RepImpFlag=$S(RepImp="Y":"关注",RepImp="N":"未关注",1:"")
	..S AdmID=$p(^DHCADVMASTER(RepID),"^",16)  
	..S PatName=$p(^DHCADVMASTER(RepID),"^",17)  
	..S AdmNo=$p(^DHCADVMASTER(RepID),"^",20)  ///病案号	
	..S OccurLoc=$p(^DHCADVMASTER(RepID),"^",27)  ///发生科室
	..S:OccurLoc'="" OccurLoc=$p(^CTLOC(OccurLoc),"^",2)
	..S:OccurLoc["-" OccurLoc=$p(OccurLoc,"-",2)
	..S:OccurDate="0" OccurDate=""
	..S:(OccurDate'="")&&(OccurDate'="0") OccurDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(OccurDate)
	..S PatID=$p(^DHCADVMASTER(RepID),"^",14)  ///登记号
	..S PapRowid=""
	..S:AdmID'="" PapRowid=$p(^PAADM(AdmID),"^",1)
	..S:(AdmID'="")&&(AdmNo="") AdmNo=##Class(web.DHCADVCOMMON).IGetMrNoByEpisodeID(AdmID,"")  //病案号 
	..S:(PapRowid'="")&&(PatID="") PatID=$p(^PAPER(PapRowid,"PAT",1),"^",1)  ;PAPMI_IPNo  字段
	..S:(PapRowid'="")&&(AdmNo="") AdmNo=##Class(web.DHCADVCOMMON).IGetMrNoByEpisodeID("",PapRowid)  //病案号
	..S:(PapRowid'="")&&(PatName="") PatName=$p(^PAPER(PapRowid,"ALL"),"^",1) //姓名
	..S RepShareStatus="未分享"
	..S rshShare=$o(^DHCADVRSH(0,"TypePointer",TypeDr,RepID,""))
	..I rshShare'="" D
	...S RepShareStatus="分享"
	..S:Subflag=0 Medadrreceive=Medadrreceive
	..S:Subflag=1 Medadrreceive=Medadrreceive_"："_"已转抄"
	..S:Subflag=2 Medadrreceive=Medadrreceive_"："_"全部回复"
	..S:Subflag=3 Medadrreceive=Medadrreceive_"："_"部分回复"
	..S GroupDesc=$p(^SSU("SSGRP",GroupId),"^",1)
	..S:RepStausDr'="" StsusGrant=##class(web.DHCADVCOMMON).CheckWorkItmGrant(RepStausDr,userlist)  ;判断当前登录人对此报告状态是否有授权
	..S UserLeadflag=##class(web.DHCADVCOMMONPART).GetSecuUserLeader(UserId,GroupId)
	..S StatusNextIDaudit=##class(web.DHCADVCOMMON).GetRepNextStatusDr(RepUserList,"",LgParam)
	..S LocDep=""
	..S:RepLocDr'="" LocDep=##class(web.DHCADVCOMMONPART).GetSecuGroupDesc(RepLocDr)  ;报告科室所属大科系统
	..S CaseShareflag="",CaseShareLoclist="",CaseShareUserlist="",CaseShareAdvicelist=""
	..S CaseShareflag=##class(web.DHCADVCOMMONPART).GetCaseFlag(RepID,TypeDr,LocId,UserId)
	..S ShareDataList=##class(web.DHCADVCOMMONPART).GetCaseLocList(RepID,TypeDr)
	..I ShareDataList["&&" S CaseShareLoclist=$p(ShareDataList,"&&",1) //共享科室列表
	..I ShareDataList["&&" S CaseShareUserlist=$p(ShareDataList,"&&",2) //共享用户列表
	..I ShareDataList["&&" S CaseShareAdvicelist=$p(ShareDataList,"&&",3) //共享意见列表
	..S RepAppAuditFlag=0
	..S:StatusNextIDaudit=StatusNextID RepAppAuditFlag=1
	..S CondFlag=##class(web.DHCADVCOMMONPART).CheckCondition(ParStr,RepID,LgParam,2)  //高级查询条件判断
	..S PatOutFlag="N"  //转归标识
	..S:##class(web.DHCADVCOMMONPART).GetRecordId(recordid,"PatOutcomform")'="" PatOutFlag="Y"
	..S MedadrUserLocList=##class(web.DHCADVCOMMON).GetRepAuditUserLoc(RepID,RepTypeDr)	
	..S RepList=RepTypeDr_"^"_RepLocDr_"^"_RepUserDr_"^"_RepID 
	..S flag=##class(web.DHCADVSEARCHREPORT).CheckQuerySec(RepList,LgParam)
	..Q:((flag'="")&&(flag'=1))&&(CaseShareflag'="Y")
	..Q:(QueAudFlag=1)&&(StatTypedr'="全部")&&(StatTypedr'="")&&(StatTypedr'=status)
	..Q:(QueAudFlag=2)&&(status="N")
	..Q:(QueAudFlag=2)&&(StatTypedr'="")&&(StatTypedr'=RepStausDr)
	..Q:(DeptID'="")&&(DeptID'=RepLocDr)
	..Q:(patNo'="")&&(patNo'=PatID)
	..Q:(typeevent'="")&&(typeevent'=TypeDr) 
	..Q:(receive'="")&&(receive'[Medadrreceivedr) 
	..Q:(statShare'="")&&(statShare'=RepShareStatus)
	..Q:(receiveflag="Y")&(MedadrUserID'=UserId) ;校验报告是否为本人接收的报告
	..Q:(impflag'="")&&(impflag'=RepImp) 
	..Q:(appauditflag'="")&&((StatusNextIDaudit'=StatusNextID))  ;校验报告是否为本人待审批的报告
	..Q:(backflag="Y")&&(Medadrreceivedr="2")&&(StaFistAuditUserDr'=UserId)&&(BackAuditUserDr'=UserId)  ;校验报告是否为本人审核并且被驳回来的报告
	..Q:(auditflag="Y")&&((("；"_MedadrUserLocList)'[("；"_LocId_":"_UserId_"；"))||(Medadrreceivedr="未接收")||(Medadrreceivedr="1")||(Medadrreceivedr="3"))  ;校验报告是否为本人处理的报告(最新操作 驳回或者审核)	
	..Q:(inpfileflag="N")&&(FileFlag="已归档")  ;||((StsusGrant'=1)&&(BackAuditUserDr'=UserId))
	..Q:(inpfileflag="Y")&&(FileFlag'="已归档")
	..Q:(OverTime="N")&&(RepOverTime'="未超时")&&(AutOverTime'="未超时")
	..Q:(OverTime="Y")&&(RepOverTime'="已超时")&&(AutOverTime'="已超时")
	..Q:(homeAutOverTime="Y")&(AutOverTime="未超时")
	..Q:(Cancelflag'="Y")&&(RepCancelflag="Y")
	..Q:(Cancelflag="Y")&&(RepCancelflag'="Y")
	..Q:(CondFlag'="1")
	..Q:(repflag'="")&(RepUserDr'=UserId)  //2018-01-13 cy  首页过滤
	..Q:(homeRepOverTime="Y")&(RepOverTime'="已超时")
	..S len=$L(TitleList,"#")
	..S valuelist=""
	..F i=1:1:len D
	...S DicCode=$p(TitleList,"#",i)
	...S DicID=..GetDiscIdByCode(DicCode)
	...I DicCode["UlcerPart" D
	....S Dicvalue=..GetDatagridData(recordid,"UlcerPart")
	...E  I DicCode["SuspectNewDrug" D
	....S Dicvalue=..GetDatagridData(recordid,"SuspectNewDrug")
	...E  I DicCode["BlendNewDrug" D
	....S Dicvalue=..GetDatagridData(recordid,"BlendNewDrug")
	...E  D
	....S Dicvalue=..GetRecordItmData(recordid,DicID)
	...S valuelist = valuelist_"#"_Dicvalue
	...S list=$p(valuelist,"#",2,len+1)
	...S allList=##class(web.DHCADVJSONCOMMON).getJsonDataPort(TitleList,list,"#")
	..I ret=""  D
	...S ret=allList
	..E  D
	...S ret=ret_","_allList
	..
	.
	Q "["_ret_"]"
}

/// Description: 获取不良事件全部导出excel程序
/// Creator:     CongYue
/// CreateDate:  2017-12-29  
/// Table:		 
/// Input:   	 
/// Output:  	 上报日期，发生日期，发生时间，医疗机构名称，不良事件类别，事件经过 
/// Others:		 w ##class(web.DHCADVCOMMONPRINT).GetExportAllData("2018-01-01","2020-08-06","全部","2018-01-01^2020-08-06^114^^23  ^114^12177^Y^^^^^^^^^^^^^^N","12177^114^23^2","")
ClassMethod GetExportAllData(StDate, EndDate, reporttype, StrParam As %String, LgParam As %String, ParStr As %String) As %String
{
	N (StDate,EndDate,reporttype,StrParam, LgParam, ParStr)
    S UserId=$p(LgParam,"^",1)    //用户ID
    S LocId=$p(LgParam,"^",2)     //科室ID
	S GroupId=$p(LgParam,"^",3)   //安全组ID
	S HospId=$p(LgParam,"^",4)   //医院ID

	S StDate=$p(StrParam,"^",1)    //开始日期
	S EndDate=$p(StrParam,"^",2)   //结束日期
	S DeptID=$p(StrParam,"^",3)    //科室
	S patNo=$p(StrParam,"^",4)     //登记号
    S StatTypedr=$p(StrParam,"^",8)  //状态
    S typeevent=$p(StrParam,"^",9)    		//填报类型
    S statShare=$p(StrParam,"^",10)    		//分享状态
    S receive=$p(StrParam,"^",11)    		//接收状态
    
	S receiveflag=$p(StrParam,"^",12)    	//接收标识
    S impflag=$p(StrParam,"^",13)    		//重点关注
    S appauditflag=$p(StrParam,"^",14) 		//待审批标识
    S backflag=$p(StrParam,"^",15) 			//退回标识
    S auditflag=$p(StrParam,"^",16)  		//已处理标识
   	S inpfileflag=$p(StrParam,"^",17)  		//归档标识
	S OverTime=$p(StrParam,"^",18)    		//是否超时
	S homeAutOverTime=$p(StrParam,"^",19)   //首页是否护士长审核超时
	
	S repflag=$p(StrParam,"^",20)    //已报标识(Y) 草稿标识(N) 12
	S homeRepOverTime=$p(StrParam,"^",21)    //首页是否填报超时 16
	S Cancelflag=$p(StrParam,"^",22)   //作废界面查询 17
	
	S RepCode=$p(StrParam,"^",23)			//报告类型过滤
	S QueAudFlag=$p(StrParam,"^",24)			// 1 查询标识 2 审核标识
	S list=UserId_"^"_LocId_"^"_GroupId
    S IFDISTHOSP=##Class(web.DHCAppComPar).GetAppPropValue("DHCADV","IFDISTHOSP",HospId,LocId,UserId,GroupId) //hxy 2020-02-24	
	
	S ret="",valuelist="",allList=""
	S:StDate'="" StDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(StDate)
	S:EndDate'="" EndDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(EndDate)
	Q:StDate="" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符  
	S ulcernumall=0,ulcerout=0
	S Ulcernum=0,Pipenum=0,Fallnum=0,Drugerrnum=0,Accidentnum=0,Wallnum=0,Mednum=0,RepTypeCode=""
	
	S pid = ##class(web.DHCADVCOMMON).NewPid()
	K ^TMP("DHCADV","web.DHCADVCOMMONPRINT","GetExportAllData",pid)
	S num=0
	F date=StDate:1:EndDate D
	.S RepID=""
	.F  S RepID=$o(^DHCADVMASTER(0,"RepDate",date,RepID)) Q:RepID=""  D
	..S status="",RepTypeDr="",RepTypeCode="",RepType="",RepStaus="",RepUser="",RepLoc="",RepSubType="",RepImpFlag="",Medadrreceive="",Medadrreceivedr="",StatusNext="",MedadrUserID="",MedadrRevStatus="",StaFistAuditUser="",BackAuditUser="",RepOverTimeflag="",AutOverTimeflag="",RepOverTime="",AutOverTime="",RepCancelflag="",StaFistAuditUserDr="",BackAuditUserDr="",MedadrNextLocDR="",RepLevelDr=""
	..S recordid=$p(^DHCADVMASTER(RepID),"^",1)
	..Q:recordid=""
	..// 获取报告id（报告表单类型id或者报告不良事件类别勾选维护工作流的类型id） 2020-06-22
	..S RepTypeString=##class(web.DHCADVCOMMONPART).GetRepTypeString(RepID)
	..S TypeDr=$p(RepTypeString,"^",1) ; 报告表单类型id
	..S TypeCode=$p(RepTypeString,"^",2)
	..S RepType=$p(RepTypeString,"^",3)
	..S RepTypeDr=$p(RepTypeString,"^",4)
	..S RepTypeCode=$p(RepTypeString,"^",5)
	..S FILERowID=$o(^DHCADVFILE(0,"RepDrType",RepID,TypeDr,""))
	..S File="",FileFlag=""
	..S:FILERowID'="" File=$p(^DHCADVFILE(FILERowID),"^",3)
	..S:(File'="Y")||(File'="N") File=##class(web.DHCADVCOMMONPART).JudgeIsOutCome(RepID,TypeDr,LgParam)
	..S FileFlag=$S(File="0":"未归档",(File="1")||(File="3"):"已归档",File="4":"归档(待复核)",(File="2")||(File="5"):"撤销归档",File="N":"撤销归档",File="Y":"已归档",1:"")
	
	..S RepTypeExp=""
	..S:(RepTypeDr'="")&&(RepTypeDr'["||") RepTypeExp=$p(^DHCMEDADREVT(RepTypeDr),"^",2)
	..S:(RepTypeDr'="")&&(RepTypeDr["||") RepTypeExp=$p(^DHCMEDADREVTI(+RepTypeDr,"MADREVI",$p(RepTypeDr,"||",2)),"^",2)	
	..Q:(reporttype'="全部")&&(reporttype'="")&&(RepType'=reporttype)
	..S RepStausDr=$p(^DHCADVMASTER(RepID),"^",3)
	..I RepStausDr=""  D
	...S RepStaus="未提交"
	...S status="N"
	..E  D 
	...S status="Y"
	...S RepStaus=$p(^DHCADREVTWFI(+RepStausDr,"ADREWI",$p(RepStausDr,"||",2)),"^",2)
	..S RepDate=$p(^DHCADVMASTER(RepID),"^",4)
	..S RepTime=$p(^DHCADVMASTER(RepID),"^",5)
	..S OccurDate=$p(^DHCADVMASTER(RepID),"^",25)  ///发生日期
	..S:OccurDate="" OccurDate=0
	..S OccurTime=$p(^DHCADVMASTER(RepID),"^",26)  ///发生时间
	..S:OccurTime="" OccurTime=0
	..S RepOverTime=""
	..S HolidayDate=##class(web.DHCADVCOMMONPART).CheckTimeEscapeHoliday(OccurDate,OccurTime,RepDate,RepTime)
	..S FillTime=##class(web.DHCADVCOMMON).GetEmSysConfig("FILLTIME",LgParam)  ///填报时限时长
	..I (+FillTime'=0)&&(HolidayDate>FillTime) S RepOverTimeflag="Y"   //填报超时
	..S RepOverTime=$S(RepOverTimeflag="":"未超时",RepOverTimeflag="N":"未超时",RepOverTimeflag="Y":"已超时",1:"")
	..S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,RepID,""),-1)
	..S Subflag=0
	..S SubUserflag=0 
	..I MedadrID'=""  D
	...S Medadrreceivedr=$p(^DHCMEDREPADT(MedadrID),"^",9) 
	...I Medadrreceivedr=""  S Medadrreceivedr="未接收"
	...S Medadrreceive=$S(Medadrreceivedr="未接收":"未接收",Medadrreceivedr="1":"接收",Medadrreceivedr="2":"驳回",Medadrreceivedr="3":"撤销",Medadrreceivedr="4":"审核",Medadrreceivedr="5":"归档",Medadrreceivedr="6":"撤销归档",Medadrreceivedr="7":"归档(待复核)",1:"")
	...S MedadrUserID=$p(^DHCMEDREPADT(MedadrID),"^",4)
	...S MedadrLocID=$p(^DHCMEDREPADT(MedadrID),"^",12)
	...S MedadrRevStatus=$p(^DHCMEDREPADT(MedadrID),"^",14) ;驳回指向
	...S StaFistAuditDr=""
	...S:(RepTypeDr'="")&&(MedadrRevStatus'="") StaFistAuditUserDr=##class(web.DHCADVCOMMON).GetStaFisUserID(RepID, RepTypeDr, MedadrRevStatus ) ;$o(^DHCMEDREPADT(0,"TypeSta",RepTypeDr,MedadrRevStatus,""))
	...S:StaFistAuditUserDr'="" StaFistAuditUser=$p(^SSU("SSUSR",StaFistAuditUserDr),"^",2) ;被驳回人
	...S:Medadrreceivedr="2" BackAuditUserDr=MedadrUserID
	...S:BackAuditUserDr'="" BackAuditUser=$p(^SSU("SSUSR",BackAuditUserDr),"^",2) ;驳回操作人
	...S MedadrNextLocDR=$p(^DHCMEDREPADT(MedadrID),"^",7) ;指向科室（分派科室）
	..Q:(appauditflag'="")&&(MedadrNextLocDR'="")&&(MedadrNextLocDR'=LocId)
	..S AuditId="",RepCancelflag="",AutOverTimeflag=""
	..F  S AuditId=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,RepID,AuditId),-1)  Q:(AuditId="")  d
	...S OverTimeflag=$p(^DHCMEDREPADT(AuditId),"^",15) ;护士长审核超时标志
	...S AuditCancelflag=$p(^DHCMEDREPADT(AuditId),"^",11) ;作废标识
	...S:OverTimeflag'="" AutOverTimeflag=OverTimeflag
	...S:AuditCancelflag'="" RepCancelflag=AuditCancelflag
	..S AutOverTime=""
	..S AutOverTime=$S(AutOverTimeflag="":"未超时",AutOverTimeflag="N":"未超时",AutOverTimeflag="Y":"已超时",1:"")
	..S Medadrflag=##class(web.DHCADVSEARCHREPORT).SearchAuditIMess(MedadrID)
	..S:Medadrflag=1 Subflag=1 //转抄 
	..S:Medadrflag=2 Subflag=2 //全部回复 
	..S:Medadrflag=3 Subflag=3 //部分回复 
	..S RepLevel=$p(^DHCADVMASTER(RepID),"^",12)  ///不良事件级别
	..S RepLevelDr=$S(RepLevel["Ⅰ级事件":"1",RepLevel["Ⅱ级事件":"2",RepLevel["Ⅲ级事件":"3",RepLevel["Ⅳ级事件":"4",1:"")
	..S RepInjSev=$p(^DHCADVMASTER(RepID),"^",13) ///伤害严重度
	..S params=RepID_"^"_RepTypeCode_"^"_UserId_"^"_LocId 
	..S SubUserflag=##class(web.DHCADVSEARCHREPORT).SearchAuditIUser(MedadrID,params) 
	..S Listt=RepID_"^"_RepTypeDr_"^"_list_"^"_RepStausDr_"^"_MedadrNextLocDR_"^"_RepLevelDr
	..S matalast=##class(web.DHCADVCOMMON).InsStatusLast(Listt) 
	..S StatusLastID=$p(matalast,"^",2)  //上一状态
	..S StatusLast=""
	..I StatusLastID'=""  D
	...S AdrewRowIDnLast=$p(StatusLastID,"||",1)
	...S AdrewChildSubnLast=$p(StatusLastID,"||",2)
	...S StatusLast=$p(^DHCADREVTWFI(AdrewRowIDnLast,"ADREWI",AdrewChildSubnLast),"^",2)
	..S matalist=##class(web.DHCADVCOMMON).InsStatusDr(Listt,LgParam) 
	..S StatusNextID=$p(matalist,"^",2)  //下一状态
	..I StatusNextID'=""  D
	...S AdrewRowIDn=$p(StatusNextID,"||",1)
	...S AdrewChildSubn=$p(StatusNextID,"||",2)
	...S StatusNext=$p(^DHCADREVTWFI(AdrewRowIDn,"ADREWI",AdrewChildSubn),"^",2)
	..S:RepDate'="" RepDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(RepDate)
	..S RepUserDr=$p(^DHCADVMASTER(RepID),"^",6)
	..S:RepUserDr'="" RepUser=$p(^SSU("SSUSR",RepUserDr),"^",2)
	..S RecRepUser=##class(web.DHCADVCOMMONPART).QueryInputDataInfo(recordid,"填报人姓名")  //取匿名信息 sufan 2019-11-07
	..S:RecRepUser'="" RepUser=RecRepUser
	..S RepLocDr=$p(^DHCADVMASTER(RepID),"^",7)
	..S RepHospID="",LogHospID="" //hxy 2020-02-18 st
	..S:RepLocDr'="" RepHospID=$p($g(^CTLOC(+RepLocDr)),"^",22) 
	..S:LocId'="" LogHospID=$p($g(^CTLOC(+LocId)),"^",22)
	..Q:(IFDISTHOSP="1")&(RepHospID'="")&(LogHospID'="")&(LogHospID'=RepHospID) //登录科室医院不同于报告科室医院退出 ed
	..S:RepLocDr'="" RepLoc=$p(^CTLOC(RepLocDr),"^",2)
	..S:RepLoc["-" RepLoc=$p(RepLoc,"-",2)
	..S RepSubType=$p(^DHCADVMASTER(RepID),"^",8)
	..S RepImp=$p(^DHCADVMASTER(RepID),"^",9)
	..S RepImpFlag=$S(RepImp="Y":"关注",RepImp="N":"未关注",1:"")
	..S PatAdm=$p(^DHCADVMASTER(RepID),"^",16)  //病人就诊id
	..S DischgDateList="",DischgDate="",DischgTime=""
	..S:PatAdm'="" DischgDateList=##class(web.DHCDischargeHistory).GetDischargeDateTime(PatAdm) ;出院日期
	..S:DischgDateList["^" DischgDate=$p(DischgDateList,"^",1) //病人出院日期
	..S:DischgDate'="" DischgDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(DischgDate) 
	..S:DischgDateList["^" DischgTime=$p(DischgDateList,"^",2) //病人出院时间
	..S:DischgTime'="" DischgTime=$zt(DischgTime,1)
	..S PatID=$p(^DHCADVMASTER(RepID),"^",14)  //病人登记号
	..S PatName=$p(^DHCADVMASTER(RepID),"^",17)  //病人姓名
	..S PatSex=$p(^DHCADVMASTER(RepID),"^",18)  //病人性别
	..S PatAge=$p(^DHCADVMASTER(RepID),"^",19)  //病人年龄
	..S AdmNo=$p(^DHCADVMASTER(RepID),"^",20)  ///病案号
	..S PatDiag=$p(^DHCADVMASTER(RepID),"^",21)  ///诊断
	..S PatAdmDate=$p(^DHCADVMASTER(RepID),"^",23)  ///入院日期
	..S:PatAdmDate'="" PatAdmDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(PatAdmDate)
	..S OccurLoc=$p(^DHCADVMASTER(RepID),"^",27)  ///发生科室
	..S:OccurLoc'="" OccurLoc=$p(^CTLOC(OccurLoc),"^",2)
	..S:OccurLoc["-" OccurLoc=$p(OccurLoc,"-",2)
	..S OccurDate=$p(^DHCADVMASTER(RepID),"^",25)  ///发生日期
	..S:OccurDate'="" OccurDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(OccurDate)
	..S RepShareStatus="未分享"
	..S rshShare=$o(^DHCADVRSH(0,"TypePointer",TypeDr,RepID,""))
	..I rshShare'="" D
	...S RepShareStatus="分享"
	..I Subflag=0 S Medadrreceive=Medadrreceive
	..I Subflag=1 S Medadrreceive=Medadrreceive_"："_"已转抄"
	..I Subflag=2 S Medadrreceive=Medadrreceive_"："_"全部回复"
	..I Subflag=3 S Medadrreceive=Medadrreceive_"："_"部分回复"
	..S GroupDesc=$p(^SSU("SSGRP",GroupId),"^",1)
	..S:RepStausDr'="" StsusGrant=##class(web.DHCADVCOMMON).CheckWorkItmGrant(RepStausDr,list)  ;判断当前登录人对此报告状态是否有授权
	..S UserLeadflag=##class(web.DHCADVCOMMONPART).GetSecuUserLeader(UserId,GroupId)
	..S StatusNextIDaudit=##class(web.DHCADVCOMMON).GetRepNextStatusDr(Listt,"",LgParam)
	..S LocDep=""
	..S:RepLocDr'="" LocDep=##class(web.DHCADVCOMMONPART).GetSecuGroupDesc(RepLocDr)  ;报告科室所属大科系统
	..S CaseShareflag="",CaseShareLoclist="",CaseShareUserlist="",CaseShareAdvicelist=""
	..S CaseShareflag=##class(web.DHCADVCOMMONPART).GetCaseFlag(RepID,TypeDr,LocId,UserId)
	..S ShareDataList=##class(web.DHCADVCOMMONPART).GetCaseLocList(RepID,TypeDr)
	..I ShareDataList["&&" S CaseShareLoclist=$p(ShareDataList,"&&",1) //共享科室列表
	..I ShareDataList["&&" S CaseShareUserlist=$p(ShareDataList,"&&",2) //共享用户列表
	..I ShareDataList["&&" S CaseShareAdvicelist=$p(ShareDataList,"&&",3) //共享意见列表
	..S RepAppAuditFlag=0
	..S:StatusNextIDaudit=StatusNextID RepAppAuditFlag=1
	..S CondFlag=##class(web.DHCADVCOMMONPART).CheckCondition(ParStr,RepID,LgParam,2)  //高级查询条件判断
	..S PatOutFlag="N"  //转归标识
	..S:##class(web.DHCADVCOMMONPART).GetRecordId(recordid,"PatOutcomform")'="" PatOutFlag="Y"
	..S MedadrUserLocList=##class(web.DHCADVCOMMON).GetRepAuditUserLoc(RepID,RepTypeDr)	
	..S RepList=RepTypeDr_"^"_RepLocDr_"^"_RepUserDr_"^"_RepID 
	..S flag=##class(web.DHCADVSEARCHREPORT).CheckQuerySec(RepList,LgParam)
	..S LocDep=##class(web.DHCADVCOMMONPART).GetSecuGroupDesc(RepLocDr)
	..S NurLev=##class(web.DHCADVCOMMONPART).QueryDataInfo(recordid,"护理级别")
	..S DegreeEducate=##class(web.DHCADVCOMMONPART).QueryDataInfo(recordid,"文化程度")	
	..S Ulcerorign=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("UlcerPart-95158-95163-95170"))
	..S:Ulcerorign'="" ulcernumall=ulcernumall+1 //院内发生 总数
	..S:Ulcerorign'="" RepTypeExp="院内压疮"
	..S Ulcerorignout=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordid,..GetDiscIdByCode("UlcerPart-95158-95163-95171")) 
	..S:Ulcerorignout'="" ulcerout=ulcerout+1 //院外带入
	..S:Ulcerorignout'="" RepTypeExp="院外带来压疮"
	..S:RepTypeCode="advSkinUlcer" Ulcernum=Ulcernum+1
	..S:RepTypeCode="advPipeOff" Pipenum=Pipenum+1
	..S:RepTypeCode="advFallDownFill" Fallnum=Fallnum+1
	..S:RepTypeCode="advDrugUseErr" Drugerrnum=Drugerrnum+1
	..S:RepTypeCode="advAccidentFill" Accidentnum=Accidentnum+1
	..S:RepTypeCode="advWallLeakage" Wallnum=Wallnum+1
	..S:RepTypeCode="advDisMedThing" Mednum=Mednum+1
	..S PapRowid=""
	..S:PatAdm'="" PapRowid=$p(^PAADM(PatAdm),"^",1)
	..S:(PatAdm'="")&&(AdmNo="") AdmNo=##Class(web.DHCADVCOMMON).IGetMrNoByEpisodeID(PatAdm,"")  //病案号 
	..S:(PapRowid'="")&&(PatID="") PatID=$p(^PAPER(PapRowid,"PAT",1),"^",1)  ;PAPMI_IPNo  字段
	..S:(PapRowid'="")&&(AdmNo="") AdmNo=##Class(web.DHCADVCOMMON).IGetMrNoByEpisodeID("",PapRowid)  //病案号
	..S:(PapRowid'="")&&(PatSex="") PatSex=$p(^CT("SEX",$p(^PAPER(PapRowid,"ALL"),"^",7)),"^",2)
	..S:(PapRowid'="")&&(PatAge="") PatAge=##Class(web.DHCSTKUTIL).GetAge(PapRowid)  //年龄    
	..S AdminDateList="",AdminDate=""
	..S:(PatAdmDate="")&&(PatAdm'="") AdminDateList=##class(web.DHCDischargeHistory).GetAdminDateTime(PatAdm) ;入院日期
	..S:AdminDateList["^" AdminDate=$p(AdminDateList,"^",1)
	..S:AdminDate'="" PatAdmDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(AdminDate) 
	..Q:((flag'="")&&(flag'=1))&&(CaseShareflag'="Y")	
	..Q:(QueAudFlag=1)&&(StatTypedr'="全部")&&(StatTypedr'="")&&(StatTypedr'=status)
	..Q:(QueAudFlag=2)&&(status="N")
	..Q:(QueAudFlag=2)&&(StatTypedr'="")&&(StatTypedr'=RepStausDr)
	..Q:(DeptID'="")&&(DeptID'=RepLocDr)
	..Q:(patNo'="")&&(patNo'=PatID)
	..Q:(typeevent'="")&&(typeevent'=TypeDr) 
	..Q:(receive'="")&&(receive'[Medadrreceivedr) 
	..Q:(statShare'="")&&(statShare'=RepShareStatus)
	..Q:(receiveflag="Y")&(MedadrUserID'=UserId) ;校验报告是否为本人接收的报告
	..Q:(impflag'="")&&(impflag'=RepImp) 
	..Q:(appauditflag'="")&&((StatusNextIDaudit'=StatusNextID))  ;校验报告是否为本人待审批的报告
	..Q:(backflag="Y")&&(Medadrreceivedr="2")&&(StaFistAuditUserDr'=UserId)&&(BackAuditUserDr'=UserId)  ;校验报告是否为本人审核并且被驳回来的报告
	..Q:(auditflag="Y")&&((("；"_MedadrUserLocList)'[("；"_LocId_":"_UserId_"；"))||(Medadrreceivedr="未接收")||(Medadrreceivedr="1")||(Medadrreceivedr="3"))  ;校验报告是否为本人处理的报告(最新操作 驳回或者审核)	
	..Q:(inpfileflag="N")&&(FileFlag="已归档")  ;||((StsusGrant'=1)&&(BackAuditUserDr'=UserId))
	..Q:(inpfileflag="Y")&&(FileFlag'="已归档")
	..Q:(OverTime="N")&&(RepOverTime'="未超时")&&(AutOverTime'="未超时")
	..Q:(OverTime="Y")&&(RepOverTime'="已超时")&&(AutOverTime'="已超时")
	..Q:(homeAutOverTime="Y")&(AutOverTime="未超时")
	..Q:(Cancelflag'="Y")&&(RepCancelflag="Y")
	..Q:(Cancelflag="Y")&&(RepCancelflag'="Y")
	..Q:(CondFlag'="1")
	..Q:(repflag'="")&(RepUserDr'=UserId)  //2018-01-13 cy  首页过滤
	..Q:(homeRepOverTime="Y")&(RepOverTime'="已超时")	
	..S DataList=RepDate_"^"_RepLoc_"^"_RepType_"^"_AdmNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatDiag_"^"_OccurDate_"^"_OccurLoc_"^"_RepStaus_"^"_RepUser_"^"_RepID_"^"_LocDep_"^"_NurLev_"^"_DegreeEducate
	..S DataList=DataList_"^"_ulcernumall_"^"_ulcerout_"^"_Ulcernum_"^"_Pipenum_"^"_Fallnum_"^"_Drugerrnum_"^"_Accidentnum_"^"_Wallnum_"^"_Mednum_"^"_RepTypeExp_"^"_DischgDate_"^"_PatAdmDate_"^"_PatID
	
	..S num=num+1
	..S ^TMP("DHCADV","web.DHCADVCOMMONPRINT","GetExportAllData",pid,num)=DataList
	.
	W "[" //输出json前缀串
	S count=0
	S index=""
	F  S index=$o(^TMP("DHCADV","web.DHCADVCOMMONPRINT","GetExportAllData",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCADV","web.DHCADVCOMMONPRINT","GetExportAllData",pid,index))
	.S count=count+1
    .W $case(count,1:"",:",") 
	.W ##class(web.DHCADVJSONCOMMON).getJsonData("RepDate^RepLoc^RepType^AdmNo^PatName^PatSex^PatAge^PatDiag^OccurDate^OccurLoc^RepStaus^RepUser^RepID^LocDep^NurLev^DegreeEducate^ulcernumall^ulcerout^Ulcernum^Pipenum^Fallnum^Drugerrnum^Accidentnum^Wallnum^Mednum^RepTypeExp^DischgDate^PatAdmDate^PatID",mdate) ;2016-09-03 congyue 
	W "]" //输出json结尾符
	K ^TMP("DHCADV","web.DHCADVCOMMONPRINT","GetExportAllData",pid)
	Q ""
}

/// Description: 获取不良事件父元素下子元素的ID
/// Creator:     yuliping
/// CreateDate:  2018-05-29
/// Table:		 
/// Input:   	 父元素ID
/// Output:  	 子元素ID串
/// Others:		 w ##class(web.DHCADVCOMMONPRINT).getRadioChildList("advMedicalReportType-label-97190")
ClassMethod getRadioChildList(field)
{
	n (field)
	q:field="" ""
	s flag=0
	s parentId=$o(^User.DHCAdvFormDicI("IndexField",$$ALPHAUP^SSUTIL4(field),""))
	q:+parentId=0 ""
	
	s childIdList=""
	s childId=""
	f  s childId=$o(^User.DHCAdvFormDicI("IndexParef"," "_parentId,childId))  q:(childId="")  d
	.s childField=$lg(^User.DHCAdvFormDicD(childId),2)
	.i $D(^User.DHCAdvFormDicI("IndexParef"," "_childField)) d
	..s childField2=$o(^User.DHCAdvFormDicI("IndexParef"," "_childField,""))
	..i $D(^User.DHCAdvFormDicI("IndexParef"," "_childField)) d
	...s childField3=$o(^User.DHCAdvFormDicI("IndexParef"," "_childField,""))
	.
	.i childIdList="" d
	..s childIdList=childField
	.e  d
	..s childIdList=childIdList_"^"_childField
	
	q childIdList
}

/// Description: 根据父元素ID获取已选择子元素的值,父类子类都是checkbox的情况
/// Creator:     yuliping
/// CreateDate:  2018-05-30
/// Table:		 
/// Input:   	 父元素ID
/// Output:  	 PatOrigin InfomationEventType-96412
/// Others:		 w ##class(web.DHCADVCOMMONPRINT).getRadioList("42","advMedicalReportType-label")
ClassMethod getRadioList(AdvMasterDr, field)
{
	n (AdvMasterDr,field)
	q:AdvMasterDr="" ""
	q:field="" ""
	s parLength=$l(field,"-") // 父元素可能包含- 
	s pid=##class(web.DHCADVCOMMON).NewPid()
	k ^TMP("web.DHCADVCOMMONPRINT","getRadioList",pid)
	
	s ADVFormRecDr = $p(^DHCADVMASTER(AdvMasterDr),"^",1)	
	s ADVFormRecItmDr=""
	f  s ADVFormRecItmDr = $o(^User.DHCAdvFormRecordItmI("IndexFormRecord",ADVFormRecDr,ADVFormRecItmDr))  q:ADVFormRecItmDr=""  d
	.s ADVFormDicID = $lg(^User.DHCAdvFormRecordItmD(ADVFormRecItmDr),3)  //元素ID
	.s FormDicField=$lg(^User.DHCAdvFormDicD(ADVFormDicID),2)
	.q:FormDicField'[field
	.s lastFormField= $piece(FormDicField,"-",1,$l(FormDicField,"-")-1)
	.s ItmValue = $lg(^User.DHCAdvFormRecordItmD(ADVFormRecItmDr),4)  //值 
	.s ItmLength= $l(lastFormField,"-")-parLength
	.q:ItmLength<0
	.s ^TMP("web.DHCADVCOMMONPRINT","getRadioList",pid,lastFormField,FormDicField)=ItmValue_"^"_ItmLength
	
	d ..getParrefField(pid,"",parLength,field)					//向前遍历到父元素
	d ..pirntRadioList(pid,"")								//遍历所有值
	k ^TMP("web.DHCADVCOMMONPRINT","getRadioList",pid)
	q ""
}

ClassMethod pirntRadioList(pid, floor)
{
	n (pid,floor)
	s floor=$g(floor)	
	f  s floor=$o(^TMP("web.DHCADVCOMMONPRINT","getRadioList",pid,floor)) q:floor=""  d
	.d ..getChildRadio(pid,floor)
}

ClassMethod getChildRadio(pid, floor)
{
	n (pid,floor)
	s thisField=""
	s flagTitle="$"
	f  s thisField=$o(^TMP("web.DHCADVCOMMONPRINT","getRadioList",pid,floor,thisField)) q:thisField=""  d
	.s childList=^TMP("web.DHCADVCOMMONPRINT","getRadioList",pid,floor,thisField)
	.s data=$p(childList,"^",1)
	.s flag=$p(childList,"^",2)
	.s flagText=""
	.s flagText=$case(flag,0:"!",1:"^",2:"*",3:"#",4:"&")
	.i flag=0 d
	..w flagTitle_data_flagText
	.e  d
	..w flagText_data
	.k ^TMP("web.DHCADVCOMMONPRINT","getRadioList",pid,floor,thisField)
	.i $d(^TMP("web.DHCADVCOMMONPRINT","getRadioList",pid,thisField)) d
	..d ..getChildRadio(pid,thisField)
}

ClassMethod getParrefField(pid, floor, parLength, field)
{
	n (pid,floor,parLength,field)
	s floor=$g(floor)
	s field=$g(field)
	q:(floor'["-")&(floor'="")
	;q:$l(floor,"-")=parLength	
	;q:field=floor								//已经遍历到父类	
	f  s floor=$o(^TMP("web.DHCADVCOMMONPRINT","getRadioList",pid,floor)) q:floor=""  d
	.s lastFormField= $piece(floor,"-",1,$l(floor,"-")-1)
	.q:lastFormField=""
	.q:$d(^TMP("web.DHCADVCOMMONPRINT","getRadioList",pid,lastFormField,floor))			
	.s parId=$o(^User.DHCAdvFormDicI("IndexField",$$ALPHAUP^SSUTIL4(floor),""))
	.q:parId=""
	.s value=$lg(^User.DHCAdvFormDicD(parId),4)										//上一级的title
	.s lastLength=$l(lastFormField,"-")-parLength		
	.q:lastLength<0							//上一级的级别
	.s ^TMP("web.DHCADVCOMMONPRINT","getRadioList",pid,lastFormField,floor)=value_"^"_lastLength
	.d ..getParrefField(pid,floor,parLength,field)
}

/// Description: 根据评价表单中父元素ID获取已选择子元素的值,父类子类都是checkbox的情况
/// Creator:     cy
/// CreateDate:  2018-07-16
/// Table:		 
/// Input:   	 FormRecLinkDr 表单记录关联id ， FormNameCode  表单名称代码，ResonStr  原因分析元素唯一标识串
/// Output:  	 字符串
/// Others:		 w ##class(web.DHCADVCOMMONPRINT).getResonListInfo("8","POHumFactor")
ClassMethod getResonListInfo(FormRecDr, field)
{
	n (FormRecDr,field)
	q:FormRecDr="" ""
	q:field="" ""
	s parLength=$l(field,"-") // 父元素可能包含- 
	s pid=##class(web.DHCADVCOMMON).NewPid()
	k ^TMP("web.DHCADVCOMMONPRINT","getRadioList",pid)
	S FormDicDr=$o(^User.DHCAdvFormDicI("IndexField",##class(web.DHCADVAction).ALPHAUP(field),""))
	S FormDicTitle=$LIST(^User.DHCAdvFormDicD(FormDicDr),4)
	s ADVFormRecItmDr=""
	f  s ADVFormRecItmDr = $o(^User.DHCAdvFormRecordItmI("IndexFormRecord",FormRecDr,ADVFormRecItmDr))  q:ADVFormRecItmDr=""  d
	.s ADVFormDicID = $lg(^User.DHCAdvFormRecordItmD(ADVFormRecItmDr),3)  //元素ID
	.s FormDicField=$lg(^User.DHCAdvFormDicD(ADVFormDicID),2)
	.q:FormDicField'[field
	.s lastFormField= $piece(FormDicField,"-",1,$l(FormDicField,"-")-1)
	.s ItmValue = $lg(^User.DHCAdvFormRecordItmD(ADVFormRecItmDr),4)  //值 
	.s ItmLength= $l(lastFormField,"-")-parLength
	.q:ItmLength<0
	.s ^TMP("web.DHCADVCOMMONPRINT","getRadioList",pid,lastFormField,FormDicField)=ItmValue_"^"_ItmLength
	w "*"_FormDicTitle
	d ..getParrefField(pid,"",parLength,field)					//向前遍历到父元素
	d ..pirntRadioList(pid,"")								//遍历所有值
	k ^TMP("web.DHCADVCOMMONPRINT","getRadioList",pid)
	q ""
}

/// Description: 根据报告ID与报告类型，获取报告评价json串
/// Creator:     cy
/// CreateDate:  2018-08-16
/// Table:		 
/// Input:   	 RepID 报告ID ， RepTypeCode  报告类型代码 29
/// Output:  	 报告评价json串
/// Others:		 w ##class(web.DHCADVCOMMONPRINT).GetRepEvaluateToJson("50","01/01/2018^16/05/2019^advPipeOff^")
ClassMethod GetRepEvaluateToJson(ReportID, StrParam)
{
	N (ReportID,StrParam,%session)
	S StDate=$p(StrParam,"^",1)    //开始日期
	S EndDate=$p(StrParam,"^",2)   //结束日期
	S TypeCode=$p(StrParam,"^",3)    //报告类型Code
	S TypeDr=$p(StrParam,"^",4)     //报告类型Dr
	S:(TypeCode="")&&(TypeDr'="")&&(TypeDr'["||") TypeCode=$p(^DHCMEDADREVT(TypeDr),"^",1)
	S:(TypeCode="")&&(TypeDr'="")&&(TypeDr["||") TypeCode=$p(^DHCMEDADREVTI(+TypeDr,"MADREVI",$p(TypeDr,"||",2)),"^",1)
	
	S:StDate'="" StDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(StDate)
	S:EndDate'="" EndDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(EndDate)
	Q:StDate="" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	S pid=##class(web.DHCADVCOMMON).NewPid()
	K ^TMP("DHCADV","web.DHCADVCOMMONPRINT","GetListToJson",pid)

	Q:TypeCode="" ""
 	S JsonList="",FieldList=""
	S EvaFormRecDr="",EvaFormCode=""
	S EvaFormCode="RepComEvaluate" ; 公共评价单NameCode
	S FieldList="PersonFactorCom^DiviceFactorCom^GoodsFactorCom^ManaFactorCom^EnvirFactorCom^OthFactorCom" ; 原因分析中元素唯一标识串
	
	I TypeCode="advPipeOff"  D  ;管路滑脱
	.S EvaFormCode="POHeaNurEvaluate" ;评价单NameCode
	.S FieldList="POHumFactor^POMatFactor^POManaFactor^POEnvirFactor^POOthFactor" ; 原因分析中元素唯一标识串
	I TypeCode="advFallDownFill"  D  ;跌倒坠床
	.S EvaFormCode="FDHeaNurEvaluate" ;评价单NameCode
	.S FieldList="PersonFactor^DiviceFactor^ManaFactor^EnvirFactor" ; 原因分析中元素唯一标识串
	I TypeCode="advSkinUlcer"  D  ;压疮报告
	.S EvaFormCode="UlcerHeaNurEvaluate" ;评价单NameCode
	.S FieldList="HumFactor^UlcDeviceCause^MatFactor^UlcMethodFactor^UlcEnvirFactor^UlcManaFactor" ; 原因分析中元素唯一标识串
	I TypeCode="advDrugUseErr"  D  ;药品报告单
	.S EvaFormCode="DrugHeaNurEvaluate" ;评价单NameCode
	.S FieldList="PersonCause^DeviceCause^goodsCase^ManaCase^EveCause" ; 原因分析中元素唯一标识串
	S Len=$L(FieldList,"^")
	S List=""
	F i=1:1:Len D
	.S TmpStr=$p(FieldList,"^",i)
	.f date=EndDate:-1:StDate d
	..s RepID=""
	..f  s RepID=$o(^DHCADVMASTER(0,"RepDate",date,RepID)) q:RepID=""  d
	...Q:(ReportID'="")&&(ReportID'=RepID)
	...S RepTypeCode="",RepTypeDr="",RepType="",ReprecordID="",RepUser="",RepLoc="",RepSubType="",RepImpFlag="",MedadrReceive="",MedadrReceivedr="",FileFlag="",RepOverTimeflag="",AutOverTimeflag="",RepOverTime="",AutOverTime="",RepCancelflag="",StaFistAuditUser="",BackAuditUser=""
	...S ReprecordID=$p(^DHCADVMASTER(RepID),"^",1)
	...Q:ReprecordID=""
	...S RepTypeDr=$p(^DHCADVMASTER(RepID),"^",2)
	...S:(RepTypeDr'="")&&(RepTypeDr'["||") RepTypeCode=$p(^DHCMEDADREVT(RepTypeDr),"^",1)
	...S:(RepTypeDr'="")&&(RepTypeDr["||") RepTypeCode=$p(^DHCMEDADREVTI(+RepTypeDr,"MADREVI",$p(RepTypeDr,"||",2)),"^",1)
	...S:(RepTypeDr'="")&&(RepTypeDr'["||") RepType=$p(^DHCMEDADREVT(RepTypeDr),"^",2)
	...S:(RepTypeDr'="")&&(RepTypeDr["||") RepType=$p(^DHCMEDADREVTI(+RepTypeDr,"MADREVI",$p(RepTypeDr,"||",2)),"^",2)
	...Q:TypeCode'=RepTypeCode
	...S RepStausDr=$p(^DHCADVMASTER(RepID),"^",3)
	...Q:RepStausDr=""
	...S Ulcerorignout=""  ;安贞专用  Ulcerorignout
	...S Ulcerorignout=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(ReprecordID,##class(web.DHCADVCOMMONPRINT).GetDiscIdByCode("UlcerPart-95158-95163-95171")) 
	...Q:Ulcerorignout'="" 
	...S EvaFormRecDr=##class(web.DHCADVCOMMONPART).GetRecordId(ReprecordID,EvaFormCode)
	...Q:EvaFormRecDr=""
	...D ..GetListToJson(EvaFormRecDr,TmpStr,pid) 
	.S FormDicDr=$o(^User.DHCAdvFormDicI("IndexField",##class(web.DHCADVAction).ALPHAUP(TmpStr),""))
	.Q:FormDicDr="" 
	.S FormDicTitle=$LIST(^User.DHCAdvFormDicD(FormDicDr),4)
	.S FormDicTitle=##Class(web.DHCADVCOMMON).GetTransDesc("User.DHCAdvFormDic","title","",FormDicTitle)  ;2020-06-28 cy
	.S List= "{""text"":"""_FormDicTitle_""",""causes"":["_..GetParentListToJson(pid,"",ReportID)_"]}"
	.I List'=""  D 
	..I JsonList=""  D
	...S JsonList=List
	..E  D
	...S JsonList=JsonList_","_List
	
	K ^TMP("DHCADV","web.DHCADVCOMMONPRINT","GetListToJson",pid)
	S ReasonDesc=##class(websys.Translation).Get("dhcadv.fishbone.csp","原因分析")
	S:JsonList'="" JsonList="{""text"":"""_ReasonDesc_""","_"""size"":""20"","_"""weight"":"_"""Bold"","_"""causes"""_":["_JsonList_"]}"
	
	Q JsonList
}

/// Description: 根据评价表单中父元素ID获取已选择子元素的值json串
/// Creator:     cy
/// CreateDate:  2018-07-16
/// Table:		 
/// Input:   	 FormRecLinkDr 表单记录关联id ， FormNameCode  表单名称代码，ResonStr  原因分析元素唯一标识串
/// Output:  	 字符串
/// Others:		 w ##class(web.DHCADVCOMMONPRINT).GetListToJson("24","EnvirFactor")
ClassMethod GetListToJson(FormRecDr, field, pid)
{
	n (FormRecDr,field,pid,%session)
	
	q:FormRecDr="" ""
	q:field="" ""
	s parLength=$l(field,"-") // 父元素可能包含- 
	S FormDicDr=$o(^User.DHCAdvFormDicI("IndexField",##class(web.DHCADVAction).ALPHAUP(field),""))
	q:FormDicDr="" ""   
	s h=0
	S FormDicTitle=$LIST(^User.DHCAdvFormDicD(FormDicDr),4)
	s ADVFormRecItmDr=""
	f  s ADVFormRecItmDr = $o(^User.DHCAdvFormRecordItmI("IndexFormRecord",FormRecDr,ADVFormRecItmDr))  q:ADVFormRecItmDr=""  d
	.s ADVFormDicID = $lg(^User.DHCAdvFormRecordItmD(ADVFormRecItmDr),3)  //元素ID
	.s FormDicField=$lg(^User.DHCAdvFormDicD(ADVFormDicID),2)
	.q:FormDicField'[field
	.s lastFormField= $piece(FormDicField,"-",1,$l(FormDicField,"-")-1)
	.s ItmValue = $lg(^User.DHCAdvFormRecordItmD(ADVFormRecItmDr),4)  //值 
	.s FormDicType=$lg(^User.DHCAdvFormDicD(ADVFormDicID),3) //元素类型
	.s:FormDicType["-input" ItmValue=$lg(^User.DHCAdvFormDicD(ADVFormDicID),4) //元素类型包含-input  value值显示元素描述
	.s ItmLength= $l(lastFormField,"-")-parLength
	.q:ItmLength<0
	.s h=h+1
	.i $D(^TMP("DHCADV","web.DHCADVCOMMONPRINT","GetListToJson",pid,lastFormField,FormDicField)) D
	..S $p(^TMP("DHCADV","web.DHCADVCOMMONPRINT","GetListToJson",pid,lastFormField,FormDicField),"^",3)=$p(^TMP("DHCADV","web.DHCADVCOMMONPRINT","GetListToJson",pid,lastFormField,FormDicField),"^",3)+1
	.E  S ^TMP("DHCADV","web.DHCADVCOMMONPRINT","GetListToJson",pid,lastFormField,FormDicField)=ItmValue_"^"_ItmLength_"^"_1
	s ListAll=""

	q:h=0 ""
	d ..GetParentFieldList(pid,"",parLength,field)					//向前遍历到父元素
	q ""
}

ClassMethod GetParentFieldList(pid, floor, parLength, field)
{
	n (pid,floor,parLength,field,%session)
	s floor=$g(floor)
	s field=$g(field)
	q:(floor'["-")&(floor'="")
	f  s floor=$o(^TMP("DHCADV","web.DHCADVCOMMONPRINT","GetListToJson",pid,floor)) q:floor=""  d
	.s lastFormField= $piece(floor,"-",1,$l(floor,"-")-1)
	.q:lastFormField=""
	.q:$d(^TMP("DHCADV","web.DHCADVCOMMONPRINT","GetListToJson",pid,lastFormField,floor))			
	.s parId=$o(^User.DHCAdvFormDicI("IndexField",$$ALPHAUP^SSUTIL4(floor),""))
	.q:parId=""
	.s value=$lg(^User.DHCAdvFormDicD(parId),4)										//上一级的title
	.s lastLength=$l(lastFormField,"-")-parLength		
	.q:lastLength<0							//上一级的级别
	.;s ^TMP("web.DHCADVCOMMONPRINT","GetListToJson",pid,lastFormField,floor)=value_"^"_lastLength
	.i $D(^TMP("DHCADV","web.DHCADVCOMMONPRINT","GetListToJson",pid,lastFormField,floor)) D
	..S $p(^TMP("DHCADV","web.DHCADVCOMMONPRINT","GetListToJson",pid,lastFormField,floor),"^",3)=$p(^TMP("DHCADV","web.DHCADVCOMMONPRINT","GetListToJson",pid,lastFormField,floor),"^",3)+1
	.E  S ^TMP("DHCADV","web.DHCADVCOMMONPRINT","GetListToJson",pid,lastFormField,floor)=value_"^"_lastLength_"^"_1
	.d ..GetParentFieldList(pid,floor,parLength,field)
	.d ..GetParentFieldList(pid,"",parLength,field) ;2018-09-13  获取元素不是checkbox类型的父元素
}

ClassMethod GetParentListToJson(pid, floor, ReportID)
{
	n (pid,floor, ReportID,%session)
	s ParentList=""
	s floor=$g(floor)	
	f  s floor=$o(^TMP("DHCADV","web.DHCADVCOMMONPRINT","GetListToJson",pid,floor)) q:floor=""  d
	.s ParentList=ParentList_..GetChildListToJson(pid,floor,"",ReportID)
	return ParentList
}

ClassMethod GetChildListToJson(pid, floor, parentflag, ReportID)
{
	n (pid,floor,parentflag,ReportID,%session)
	s thisField=""
	s Lsit=""
	s num=0
	f  s thisField=$o(^TMP("DHCADV","web.DHCADVCOMMONPRINT","GetListToJson",pid,floor,thisField)) q:thisField=""  d
	.s childList=^TMP("DHCADV","web.DHCADVCOMMONPRINT","GetListToJson",pid,floor,thisField)
	.s ifchild=..getRadioChildList(thisField) ;获取子元素id
	.s data=$p(childList,"^",1)
	.s data=##Class(web.DHCADVCOMMON).GetTransDesc("User.DHCAdvFormDic","title","",data)  ;2020-06-28 cy
	.s flag=$p(childList,"^",2)
	.s danum=$p(childList,"^",3)
	.s:ifchild'="" danum="" ;子元素id 不等于空，数值赋值为空
	.s:ReportID'="" danum="" ;ReportID 不等于空（勾选单独报告数据），数值赋值为空
	.;s:danum=1 danum=""
	.s:danum'="" danum="("_danum_"例)"
	.i (flag=0)&&(num=0) d
	..s Lsit=Lsit_ "{""text"":"""_data_danum_""""  
	.e  i (flag=0)&&(num'=0) d
	..s Lsit=Lsit_ ",{""text"":"""_data_danum_""""  
	.e  i parentflag=flag  d
	..s Lsit=Lsit_ ","_"{""text"":"""_data_danum_"""" 
	.e  d
	..s Lsit=Lsit_ "{""text"":"""_data_danum_"""" 
	.s parentflag=flag
	.s num=num+1
	.k ^TMP("DHCADV","web.DHCADVCOMMONPRINT","GetListToJson",pid,floor,thisField)
	.i $d(^TMP("DHCADV","web.DHCADVCOMMONPRINT","GetListToJson",pid,thisField)) d
	..s Lsit=Lsit_",""causes"":["_ ..GetChildListToJson(pid,thisField,flag,ReportID)_ "]"
	.s Lsit=Lsit_ "}"
	return Lsit
}

}
