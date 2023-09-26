Import sqluser

/// 压疮部位数据表 
Class web.DHCADVULCPARTINFO Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 保存[压疮部位数据]
/// Creator:     CongYue
/// CreateDate:  2018-05-08
/// Table: 		 DHC_AdvUlcPartInfo  
/// Input:  	 报告id,表单记录id ,DataList: 压疮部位数据信息, 以字符"^"分割,格式为：发现日期^压疮来源^压疮部位^压疮分期^压疮面积^渗出液^伤口颜色^气味&&发现日期^压疮来源^压疮部位^压疮分期^压疮面积^渗出液^伤口颜色^气味,
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVULCPARTINFO).SaveUlcPartList("^内科^内科^^Y")
ClassMethod SaveUlcPartList(RepDr As %String, FormRecordDr As %String, DataList As %String) As %String
{
	N (RepDr,FormRecordDr,DataList)
	S Err=0
	I $d(^DHCADVULCP(0,"RepDr",RepDr))  D
	.&SQL(DELETE DHC_AdvUlcPartInfo WHERE  ADVUP_RepDr=:RepDr)
	S:+$g(SQLCODE)'=0 Err=SQLCODE
	Q:Err'=0 Err
	
	S len=$L(DataList,"&&")
	F i=2:1:len D
	.S TmpStr=$p(DataList,"&&",i)
	.S Err=..InsUlcPart(RepDr,FormRecordDr,TmpStr)
	Q Err
}

/// Description: 增加[压疮部位数据]
/// Creator:     CongYue
/// CreateDate:  2018-05-08
/// Table: 		 DHC_AdvUlcPartInfo
/// Input:  	 DataList: 压疮部位数据信息, 以字符"^"分割,格式为：id^代码^描述,
/// Return:	 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVULCPARTINFO).InsUlcPart("")
ClassMethod InsUlcPart(RepDr As %String, FormRecordDr As %String, DataList As %String) As %String
{
	N (RepDr,FormRecordDr,DataList)
	S ADVUPRepDr=RepDr
	S ADVUPRecordDr=FormRecordDr
	S ADVUPFindDate=$p(DataList,"^",1)
	S:ADVUPFindDate'="" ADVUPFindDate=$zdh(ADVUPFindDate,3) ;##class(web.DHCADVCOMMON).DateHtmlToLogical(ADVUPFindDate)
	S ADVUPUlcSource=$p(DataList,"^",2)
	S ADVUPUlcPart=$p(DataList,"^",3)
	S ADVUPUlcStage=$p(DataList,"^",4)
	S ADVUPUlcArea=$p(DataList,"^",5)
	S ADVUPPercolate=$p(DataList,"^",6)
	S ADVUPWoundColor=$p(DataList,"^",7)
	S ADVUPSmell=$p(DataList,"^",8)
	
 	&SQL(INSERT INTO DHC_AdvUlcPartInfo(ADVUP_RepDr,ADVUP_RecordDr,ADVUP_FindDate,ADVUP_UlcSource,ADVUP_UlcPart,ADVUP_UlcStage,ADVUP_UlcArea,ADVUP_Percolate,ADVUP_WoundColor,ADVUP_Smell) 
 	VALUES(:ADVUPRepDr,:ADVUPRecordDr,:ADVUPFindDate,:ADVUPUlcSource,:ADVUPUlcPart,:ADVUPUlcStage,:ADVUPUlcArea,:ADVUPPercolate,:ADVUPWoundColor,:ADVUPSmell))
 	I SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Description: 获取[压疮部位数据]
/// Creator:     CongYue
/// CreateDate:  2018-05-08
/// Table: 		 DHC_AdvUlcPartInfo  
/// Input:  	 报告id,表单记录id ,DataList: 压疮部位数据信息, 以字符"^"分割,格式为：发现日期^压疮来源^压疮部位^压疮分期^压疮面积^渗出液^伤口颜色^气味&&发现日期^压疮来源^压疮部位^压疮分期^压疮面积^渗出液^伤口颜色^气味,
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVULCPARTINFO).GetUlcPartList()
ClassMethod GetUlcPartList() As %String
{
	S RepID="",FormRecordDr="",DataList="",Err=0
	S StDate="2018-01-01"   //开始日期
	S EndDate=+$h   //结束日期
	S:StDate'="" StDate=$zdh(ADVUPFindDate,3) ;##class(web.DHCADVCOMMON).DateHtmlToLogical(StDate)
	S AllList=""
	f date=EndDate:-1:StDate d
	.S RepID="",FormRecordDr="",RepList=""
	.F  S RepID=$o(^DHCADVMASTER(0,"RepDate",date,RepID))  Q:RepID=""  D
	..S FormRecordDr=$p(^DHCADVMASTER(RepID),"^",1)
	..S RepType=$p(^DHCADVMASTER(RepID),"^",2)
	..S RepTypeCode=""  ;$p(^DHCMEDADREVT(EvtTypeId),"^",1)
	..S:(RepType'="")&&(RepType'["||") RepTypeCode=$p(^DHCMEDADREVT(RepType),"^",1)
	..S:(RepType'="")&&(RepType["||") RepTypeCode=$p(^DHCMEDADREVTI(+RepType,"MADREVI",$p(RepType,"||",2)),"^",1)	
	..Q:RepTypeCode'="advSkinUlcer"
	..S DataList=..GetDatagridData(FormRecordDr,"UlcerPart")
	..S len=$L(DataList,"&&")
	..S UlcAreal="",UlcAreaw="",UlcAreah="",UlcSource="",UlcSourcesub="",UlcPart="",UlcPartsub="",FindDate="",UlcStage="",RepList=""
	..F i=1:1:len-1 D
	...S PartList=""
	...S TmpStr=$p(DataList,"&&",i)
	...S TmpStrLen=$L(TmpStr,"**")
	...F j=2:1:TmpStrLen D
	....S TmpStrList=$p(TmpStr,"**",j)
	....S:$p(TmpStrList,"^",1)["UlcerPart-95158-95189-94247" UlcAreal =$p(TmpStrList,"^",2)
	....S:$p(TmpStrList,"^",1)["UlcerPart-95158-95189-94249" UlcAreaw =$p(TmpStrList,"^",2)
	....S:$p(TmpStrList,"^",1)["UlcerPart-95158-95189-94251" UlcAreah =$p(TmpStrList,"^",2)
	....S:$p(TmpStrList,"^",1)["UlcerPart-95158-95162-95192" FindDate =$p(TmpStrList,"^",2)
	....S:($p(TmpStrList,"^",1)["UlcerPart-95158-95163")&&($L($p(TmpStrList,"^",1),"-")=4) UlcSource =$p(TmpStrList,"^",2)
	....S:$p(TmpStrList,"^",1)["UlcerPart-95158-95163-95171-" UlcSourcesub =$p(TmpStrList,"^",2)
	....S:($p(TmpStrList,"^",1)["UlcerPart-95158-95166")&&($L($p(TmpStrList,"^",1),"-")=4) UlcPart =$p(TmpStrList,"^",2)
	....S:($p(TmpStrList,"^",1)["UlcerPart-95158-95166")&&($L($p(TmpStrList,"^",1),"-")=5) UlcPartsub =$p(TmpStrList,"^",2)
	....S:$p(TmpStrList,"^",1)["UlcerPart-95158-95169" UlcStage =$p(TmpStrList,"^",2)
	...S PartList=FindDate_"^"_UlcSource_UlcSourcesub_"^"_UlcPart_UlcPartsub_"^"_UlcStage_"^"_UlcAreal_"*"_UlcAreaw_"*"_UlcAreah
	...S:PartList'="" RepList=RepList_"&&"_PartList
	...S UlcAreal="",UlcAreaw="",UlcAreah="",UlcSource="",UlcSourcesub="",UlcPart="",UlcPartsub="",FindDate="",UlcStage=""
	...S:RepList'="" Err=..SaveUlcPartList(RepID,FormRecordDr,RepList)
	.;S:RepList'="" AllList=AllList_"$$"_RepList
	q Err
}

/// 传入唯一确定table的前面的Code
/// w ##class(web.DHCADVULCPARTINFO).GetDatagridData(4,"UlcerPart")
ClassMethod GetDatagridData(ADVFormRecDr, TableParrefCode)
{
	n (ADVFormRecDr,TableParrefCode)
	s Count=0
	s repid=$i(^CacheTemp)
	k ^TMP("DHCADV","web.DHCADVCOMMONPRINT","GetDatagridData")
	q:ADVFormRecDr="" ""
	s RsDate="",RsString=""
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
	
	s Num=0,ret="",List=""
	s DataRowKey=0
	f  s DataRowKey = $o(^TMP("DHCADV","web.DHCADVCOMMONPRINT","GetDatagridData",repid,DataRowKey)) q:DataRowKey=""  d
	.s Count=0,RsStr="",RsData=""
	.f  s Count = $o(^TMP("DHCADV","web.DHCADVCOMMONPRINT","GetDatagridData",repid,DataRowKey,Count)) q:Count=""  d
	..s Data = ^TMP("DHCADV","web.DHCADVCOMMONPRINT","GetDatagridData",repid,DataRowKey,Count)
	..s:Data'="" ret = ret_"**"_Data
	.s ret=ret_"&&"
	.s Num=Num+1
	q ret
}

/// Description: 查询[压疮部位数据]
/// Creator:     CongYue
/// CreateDate:  2018-05-08
/// Table: 		 DHC_AdvUlcPartInfo  
/// Input:  	 报告id,表单记录id 
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVULCPARTINFO).QueryUlcPartList(3,4)
ClassMethod QueryUlcPartList(RepDr, FormRecordDr) As %String
{
	N (RepDr,FormRecordDr)
	S DataList="",ADVUPRowID=""
	F  S ADVUPRowID=$o(^DHCADVULCP(0,"RepDr",RepDr,ADVUPRowID))  Q:ADVUPRowID=""  D
	.S ADVUPRecordDr=$p(^DHCADVULCP(ADVUPRowID),"^",2)
	.S ADVUPFindDate=$p(^DHCADVULCP(ADVUPRowID),"^",3)
	.S:ADVUPFindDate'="" ADVUPFindDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(ADVUPFindDate)
	.S ADVUPUlcSource=$p(^DHCADVULCP(ADVUPRowID),"^",4)
	.S ADVUPUlcPart=$p(^DHCADVULCP(ADVUPRowID),"^",5)
	.S ADVUPUlcStage=$p(^DHCADVULCP(ADVUPRowID),"^",6)
	.S ADVUPUlcArea=$p(^DHCADVULCP(ADVUPRowID),"^",7)
	.S ADVUPPercolate=$p(^DHCADVULCP(ADVUPRowID),"^",8)
	.S ADVUPWoundColor=$p(^DHCADVULCP(ADVUPRowID),"^",9)
	.S ADVUPSmell=$p(^DHCADVULCP(ADVUPRowID),"^",10)
	.S DataList=DataList_"&&"_ADVUPFindDate_"^"_ADVUPUlcSource_"^"_ADVUPUlcPart_"^"_ADVUPUlcStage_"^"_ADVUPUlcArea_"^"_ADVUPPercolate_"^"_ADVUPWoundColor_"^"_ADVUPSmell
	Q DataList
}

/// Description: 获取[压疮部位数据]
/// Creator:     CongYue
/// CreateDate:  2018-05-08
/// Table: 		 DHC_AdvUlcPartInfo  
/// Input:  	 报告id,表单记录id 
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVULCPARTINFO).SavePartList()
ClassMethod SavePartList(RepID, FormRecordDr) As %String
{
	N (RepID,FormRecordDr)
	S DataList="",AllList="",RepList="",Err=0
	S FormRecordDr=$p(^DHCADVMASTER(RepID),"^",1)
	S RepType=$p(^DHCADVMASTER(RepID),"^",2)
	S RepTypeCode=""
	S:(RepType'="")&&(RepType'["||") RepTypeCode=$p(^DHCMEDADREVT(RepType),"^",1)
	S:(RepType'="")&&(RepType["||") RepTypeCode=$p(^DHCMEDADREVTI(+RepType,"MADREVI",$p(RepType,"||",2)),"^",1)
	Q:RepTypeCode'="advSkinUlcer" Err
	S DataList=..GetDatagridData(FormRecordDr,"UlcerPart")
	S len=$L(DataList,"&&")
	S UlcAreal="",UlcAreaw="",UlcAreah="",UlcSource="",UlcSourcesub="",UlcPart="",UlcPartsub="",FindDate="",UlcStage=""
	F i=1:1:len-1 D
	.S PartList=""
	.S TmpStr=$p(DataList,"&&",i)
	.S TmpStrLen=$L(TmpStr,"**")
	.F j=2:1:TmpStrLen D
	..S TmpStrList=$p(TmpStr,"**",j)
	..S:$p(TmpStrList,"^",1)["UlcerPart-95158-95189-94247" UlcAreal =$p(TmpStrList,"^",2)
	..S:$p(TmpStrList,"^",1)["UlcerPart-95158-95189-94249" UlcAreaw =$p(TmpStrList,"^",2)
	..S:$p(TmpStrList,"^",1)["UlcerPart-95158-95189-94251" UlcAreah =$p(TmpStrList,"^",2)
	..S:$p(TmpStrList,"^",1)["UlcerPart-95158-95162-95192" FindDate =$p(TmpStrList,"^",2)
	..S:($p(TmpStrList,"^",1)["UlcerPart-95158-95163")&&($L($p(TmpStrList,"^",1),"-")=4) UlcSource =$p(TmpStrList,"^",2)
	..S:$p(TmpStrList,"^",1)["UlcerPart-95158-95163-95171-" UlcSourcesub =$p(TmpStrList,"^",2)
	..S:($p(TmpStrList,"^",1)["UlcerPart-95158-95166")&&($L($p(TmpStrList,"^",1),"-")=4) UlcPart =$p(TmpStrList,"^",2)
	..S:($p(TmpStrList,"^",1)["UlcerPart-95158-95166")&&($L($p(TmpStrList,"^",1),"-")=5) UlcPartsub =$p(TmpStrList,"^",2)
	..S:$p(TmpStrList,"^",1)["UlcerPart-95158-95169" UlcStage =$p(TmpStrList,"^",2)
	.S PartList=FindDate_"^"_UlcSource_UlcSourcesub_"^"_UlcPart_UlcPartsub_"^"_UlcStage_"^"_UlcAreal_"*"_UlcAreaw_"*"_UlcAreah
	.S:PartList'="" RepList=RepList_"&&"_PartList
	.S UlcAreal="",UlcAreaw="",UlcAreah="",UlcSource="",UlcSourcesub="",UlcPart="",UlcPartsub="",FindDate="",UlcStage=""
	S:RepList'="" Err=..SaveUlcPartList(RepID,FormRecordDr,RepList)
	q Err
}

}
