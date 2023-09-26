Class web.NurSensAdvComm Extends %RegisteredObject
{

/// Creator:lulin
/// Description:获取不良事件公共信息
/// Date:2020-02-17
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod GetAdvCommonData(id) As %String
{
	s a=##class(Nur.DHCNurSBData).%OpenId(id)
	s str=""
    ;上报日期,上报时间
    s str="ReportDate|"_a.EmrDate_"^ReportTime|"_a.EmrTime_"^DataId|"_id
    ;状态、病案号、就诊号、病人姓名、病人性别、当事人姓名
    s DataStatus=a.Status
    s:a.RecCancelUser'="" DataStatus="C" 
    s str=str_"^DataStatus|"_DataStatus_"^PaRecord|"_a.Item6_"^EpisodeId|"_a.EpisodeId_"^PaName|"_a.Item2_"^PaSex|"_a.Item4_"^ReprtorName|"_a.Item184
    ;职称
    s ReprtorTitle=$P(a.Item185,"!",1) 
    s str=str_"^ReprtorTitle|"_ReprtorTitle
    ;工作年限,包头不包尾
    s ReprtorYear=a.Item187 
	i ReprtorYear["☑未满" s ReprtorYear=1
    i ReprtorYear["☑1-5" s ReprtorYear=5
    i ReprtorYear["☑6-10" s ReprtorYear=10
    i ReprtorYear["☑11-15" s ReprtorYear=15
    i ReprtorYear["☑16-20" s ReprtorYear=20
    i ReprtorYear["☑21-25" s ReprtorYear=25
    i ReprtorYear["☑26" s ReprtorYear=26
    s str=str_"^ReprtorYear|"_ReprtorYear
    ;不良事件伤害等级:死亡、极重度、重度、中度、轻度、无伤害
    s Degree=$p(a.Item42,"!",1) 
    s Degree=$case(Degree,"无伤害":"0","轻度":"1","中度":"2","重度":"3","极重度":"3","死亡":"4",:Degree)
    s str=str_"^Degree|"_Degree
    ;科室、病区中文描述
	s str=str_"^ReportLocDesc|"_a.Item1_"^ReportWardDesc|"_a.Item177
	q str
}

/// Creator:lulin
/// Description:获取东华Ext不良事件数据接口
/// Date:2020-02-17
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod GetAdvData(tmpAdvData) As %String
{
	//管道滑脱：DHCNURXHSB_GDHTN
	//跌倒坠床：DHCNURXHSB_DDZCN
	//压疮：DHCNURXHSB_PFN
	//目前只统计以上三类，还有：给药错误、通用不良事件、输液、输血
	//s rw="" f  s rw=$O(^Nur.DHCNurSBDataI("emdate",date," DHCNURXHSB_GDHTN",rw)) q:rw=""  d
	s rw="" f  s rw=$O(^Nur.DHCNurSBDataD(rw)) q:rw=""  d
	.s a=##class(Nur.DHCNurSBData).%OpenId(rw)
	.s code=$zcvt(a.EmrCode,"U")
	.q:(code'="DHCNURXHSB_GDHTN")&&(code'="DHCNURXHSB_PFN")&&(code'="DHCNURXHSB_DDZCN")
    .s str=..GetAdvCommonData(rw)
    .s otherData=""
    .i code="DHCNURXHSB_GDHTN" d
    ..;下面三种对应类型单选,此处命名和前端相对应
    ..s Item167=$p(a.Item285,"!",1) //I类导管：胸管、t管、口鼻插管、动脉置管、气管切开管、脑室引流管、关节腔引流管
    ..s Item168=$p(a.Item287,"!",1) //II类导管：双套管、深静脉置管、造瘘管、负压引流管、腰椎引流管
    ..s Item169=$p(a.Item103,"!",1) //III类导管：导尿管、胃管、输液管、吸氧管、鼻胃肠管、留置针、picc
    ..s gllideType=""
    ..i Item167="口鼻插管" s gllideType="气管导管,"
    ..i $zcvt(Item168,"U")="深静脉置管" s gllideType=gllideType_"CVC,"
    ..i Item169="导尿管" s gllideType=gllideType_"导尿管,"
    ..i ((Item169="鼻胃肠管")||(Item169="胃管")) s gllideType=gllideType_"胃肠管,"
    ..i $zcvt(Item169,"U")="PICC" s gllideType=gllideType_"PICC,"
    ..i gllideType'="" d
    ...s otherData="AdvType|GDHT^AdvGlideType|"_$E(gllideType,0,($L(gllideType)-1))
    ...s hDate=a.Item73,hTime=a.Item72
    ...i hDate="" s hDate=a.Item71,hTime=a.Item70
    ...s otherData=otherData_"^HappenDate|"_hDate_"^HappenTime|"_hTime
    .e  i code="DHCNURXHSB_DDZCN" d
    ..s hDate=a.Item73,hTime=a.Item72
    ..i hDate="" s hDate=a.Item71,hTime=a.Item70
    ..s otherData=otherData_"AdvType|DD^HappenDate|"_hDate_"^HappenTime|"_hTime
    .e  i code="DHCNURXHSB_PFN" d ;目前取院内压疮，还有入院、目前
    ..s UlcerLevel=$p(a.Item83,"!",1) //压疮期数:1,2,3,4,深层组织损伤，不可分期
    ..s UlcerPNum=a.Item81 //压疮部位数
    ..s Item80=a.Item80 //压疮部位,多选;枕骨,肩胛,骶尾,坐骨,股骨粗隆,足跟,足踝,耳廓,肘部,髋部,髂前上棘
    ..s UlcerPosition=""
    ..s upa=$lb("枕骨","肩胛","骶尾","坐骨","股骨粗隆","足跟","足踝","耳廓","肘部","髋部","髂前上棘")
    ..f i=1:1:$LL(upa)  d
    ...i Item80[("☑"_$LG(upa,i)) d
    ....i UlcerPosition="" s UlcerPosition=$LG(upa,i)
    ....e  s UlcerPosition=UlcerPosition_","_$LG(upa,i)
    ..s Item81=a.Item81 //其他部位
    ..i Item81'="" d
    ...i UlcerPosition="" s UlcerPosition=UlcerPosition
    ...e  s UlcerPosition=UlcerPosition_","_UlcerPosition
    ..s otherData="AdvType|YC^UlcerLevel|"_UlcerLevel_"^UlcerPNum|"_UlcerPNum_"^UlcerPosition|"_UlcerPosition
    ..s hDate=a.Item272,hTime=a.Item273
    ..i hDate="" s hDate=a.Item124,hTime=a.Item176
    ..s otherData=otherData_"^HappenDate|"_hDate_"^HappenTime|"_hTime
    .q:otherData=""
    .s str=str_"^"_otherData
    .s tmpAdvData(rw)=str
}

/// Description: 不良事件接口开发  
/// Creator:     xiaowenwu
/// CreateDate:  2020-05-07 
/// Input:  	  tmpAdvData
/// Return： 	  
/// other:w ##class(web.DHCADVINTERFACE).GetAdvData(.tmpAdvData)  
ClassMethod GetAdvDataForXin(tmpAdvData) As %String
{
	//跌倒坠床：advFallDownFill
 	//管道滑脱:	advPipeOff
 	//压疮：advSkinUlcer
 	s AdvTypeList=##class(web.NurSensConfigComm).#AdvType
	s ID=0
	f  s ID=$o(^DHCADVMASTER(ID)) q:ID=""  d
	.s recordID=$p(^DHCADVMASTER(ID),"^",1) //报告ID
	.q:recordID=""
	.s typedr=$p(^DHCADVMASTER(ID),"^",2)	//报告类型
	.q:typedr=""	
	.s:(typedr'="")&&(typedr'["||") typecode=$p(^DHCMEDADREVT(typedr),"^",1)	//报告类型ID
	.s:(typedr'="")&&(typedr["||") typecode=$p(^DHCMEDADREVTI(+typedr,"MADREVI",$p(typedr,"||",2)),"^",1)
	.s:(typedr'="")&&(typedr'["||") RepType=$p(^DHCMEDADREVT(typedr),"^",2)	//报告类型名称
	.s:(typedr'="")&&(typedr["||") RepType=$p(^DHCMEDADREVTI(+typedr,"MADREVI",$p(typedr,"||",2)),"^",2)
	.s AdvType=##class(web.NurSensConfigComm).GetAdvTypeValue(AdvTypeList,"typeCode",typecode,"value")
	.q:AdvType=""
	.s str=..GetAdvCommonDataXin(ID)
	.s PatName=$p($g(^DHCADVMASTER(ID)),"^",17) 
	.q:##class(web.NurSensDHCCHISComm).IsTextPat(PatName)=1
	.s str=str_"^AdvType|"_AdvType
	.;AdvGlideType|管道滑脱类型^HappenDate|发生日期^HappenTime|发生时间^UlcerLevel|压疮期数
	.;^UlcerPNum|压疮部位数^UlcerPosition|压疮部位^EditDate|填写日期^EditTime|填写时间
	.s interface=##class(web.NurSensConfigComm).GetAdvTypeValue(AdvTypeList,"value",AdvType,"interface")
	.i interface'="" d
	..s refParam="str"
	..s class=interface.GetAt("class")
	..s method=interface.GetAt("method")
	..s param=interface.GetAt("param")
	..s:param'="" refParam=param_","_refParam
	..x ("("_refParam_") s str=str_##class("_class_")."_method_"("_param_")",ID,.str)
	.e  d
	..s str=str_"^AdvGlideType|^HappenDate|^HappenTime|^UlcerLevel|^UlcerPNum|^UlcerPosition|^EditDate|^EditTime|^UlcerPart|"
	.s tmpAdvData(ID)=str
	q ""
	q ""
}

/// Creator:liwenzhen
/// Description:获取压疮信息
/// Date:2022-04-24
/// Table:
/// Input:
/// Output：
/// Others:w ##class(web.NurSensAdvComm).GetSkinUlcer()
ClassMethod GetSkinUlcer(ID)
{
	s UlcerRowID=0,UlcerPosition="",UlcerLevel="",UlcerPNum=0,EditDate="",EditDate=""
	f  s UlcerRowID=$o(^DHCADVULCP(0,"RepDr",ID,UlcerRowID))  q:UlcerRowID=""  d  //压疮RowID
	.s UlcerPNum=UlcerPNum+1
	.i UlcerPosition'=""  d
	..s UlcerPosition=UlcerPosition_","_$p($g(^DHCADVULCP(UlcerRowID)),"^",5) //压疮部位
	..s UlcerLevel=UlcerLevel_","_..GetUlcerLevel($p($g(^DHCADVULCP(UlcerRowID)),"^",6))  //压疮期数
	.i UlcerPosition="" d
	..s UlcerPosition=$p($g(^DHCADVULCP(UlcerRowID)),"^",5)  //压疮部位
	..s UlcerLevel=$p($g(^DHCADVULCP(UlcerRowID)),"^",6)  //压疮期数
	..S UlcerLevel=..GetUlcerLevel(UlcerLevel)
	.s EditDate=$p($g(^DHCADVULCP(UlcerRowID)),"^",3)  //发现日期
	s UlcerPart=..getradio(ID,"UlcerPart-95158-95163") //来源情况
	s str="^AdvGlideType|^HappenDate|^HappenTime|^UlcerLevel|"_UlcerLevel_"^UlcerPNum|"_UlcerPNum
	s str=str_"^UlcerPosition|"_UlcerPosition_"^EditDate|"_EditDate_"^EditTime|"_"^UlcerPart|"_UlcerPart
	q str
}

/// Creator:liwenzhen
/// Description:获取管道滑脱信息
/// Date:2022-04-24
/// Table:
/// Input:
/// Output：
/// Others:w ##class(web.NurSensAdvComm).GetPipeOff()
ClassMethod GetPipeOff(ID)
{
	s RadioList=""
	s RadioList=..getradio(ID,"PipeType")
	s AdvGlideType=""
	f i=1:1:($l(RadioList,"^")) d
	.s Type=$p(RadioList,"^",i)
	.s:AdvGlideType'="" AdvGlideType=AdvGlideType_","_Type  //管道滑脱类型
	.s:AdvGlideType="" AdvGlideType=Type
	s HappenDate=$p(^DHCADVMASTER(ID),"^",25)   //发生日期
	s HappenTime=$p(^DHCADVMASTER(ID),"^",26)   //发生时间
	s:HappenDate?1n.n HappenDate=$zd(HappenDate,3)
	s:HappenTime?1n.n HappenTime=$zt(HappenTime)
	s str="^AdvGlideType|"_AdvGlideType_"^HappenDate|"_HappenDate_"^HappenTime|"_HappenTime
	s str=str_"^UlcerLevel|^UlcerPNum|^UlcerPosition|^EditDate|^EditTime|^UlcerPart|"
	q str
}

ClassMethod GetUlcerLevel(UlcerLevel)
{
	if ((UlcerLevel["I")||(UlcerLevel["Ⅰ")||(UlcerLevel["1")){
		s UlcerLevel=1
	}elseif((UlcerLevel["II")||(UlcerLevel["Ⅱ")||(UlcerLevel["2")){
		s UlcerLevel=2
	}elseif((UlcerLevel["III")||(UlcerLevel["Ⅲ")||(UlcerLevel["3")){
		s UlcerLevel=3
	}elseif(UlcerLevel["深层组织损伤"){
		s UlcerLevel="深层组织损伤"
	}elseif(UlcerLevel["不可分期"){
		s UlcerLevel="不可分期"
	}
	q UlcerLevel
}

/// Creator:xiaowenwu
/// Description:获取不良事件公共信息
/// Date:2020-05-07
/// Table:
/// Input:
/// Output：
/// Others:w ##class(web.NurSensAdvComm).getradio(221,"来源情况：")
ClassMethod getradio(AdvMasterDr, field) As %String
{
	q:AdvMasterDr="" ""
	q:field="" ""
	s parLength=$l(field,"-") // 父元素可能包含- 
	s pid=##class(web.DHCADVCOMMON).NewPid()
	k ^TMP("web.DHCADVINTERFACE","getradio",pid)
	
	s ADVFormRecDr = $p(^DHCADVMASTER(AdvMasterDr),"^",1)	
	s ADVFormRecItmDr=""
	f  s ADVFormRecItmDr = $o(^User.DHCAdvFormRecordItmI("IndexFormRecord",ADVFormRecDr,ADVFormRecItmDr))  q:ADVFormRecItmDr=""  d
	.q:$g(^User.DHCAdvFormRecordItmD(ADVFormRecItmDr))=""
	.s ADVFormDicID = $lg(^User.DHCAdvFormRecordItmD(ADVFormRecItmDr),3)  //元素ID
	.q:ADVFormDicID=""
	.q:$g(^User.DHCAdvFormDicD(ADVFormDicID))=""
	.s FormDicField=$lg(^User.DHCAdvFormDicD(ADVFormDicID),2)
	.q:FormDicField'[field
	.s lastFormField= $piece(FormDicField,"-",1,$l(FormDicField,"-")-1)
	.s ItmValue = $lg(^User.DHCAdvFormRecordItmD(ADVFormRecItmDr),4)  //值 
	.s ItmLength= $l(lastFormField,"-")-parLength
	.q:ItmLength<0
	.s ^TMP("web.DHCADVINTERFACE","getradio",pid,lastFormField,FormDicField)=ItmValue_"^"_ItmLength
	
	s num="",data=""
	f  s num=$o(^TMP("web.DHCADVINTERFACE","getradio",pid,field,num)) q:num=""  d
	.s ItmValue=$p(^TMP("web.DHCADVINTERFACE","getradio",pid,field,num),"^",1)
	.s:data'="" data=data_"^"_ItmValue
	.s:data="" data=ItmValue
	k ^TMP("web.DHCADVINTERFACE","getradio",pid)
	q data
}

/// Creator:xiaowenwu
/// Description:获取不良事件公共信息
/// Date:2020-05-07
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod GetAdvCommonDataXin(ID) As %String
{
	s ADVRepDate=$p(^DHCADVMASTER(ID),"^",4)  //上报日期
	s ADVRepTime=$p(^DHCADVMASTER(ID),"^",5)  //上报时间
	s str=""
    s str="ReportDate|"_ADVRepDate_"^ReportTime|"_ADVRepTime_"^DataId|"_ID
    s ADVRepStausDr=$p(^DHCADVMASTER(ID),"^",3)  //报告状态
    s typedr=$p(^DHCADVMASTER(ID),"^",2)	//报告类型
    s RepStaus="",Medadrreceive=""
    i ADVRepStausDr=""  d
	.s Medadrreceive="V"
	E  D 
	.S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",typedr,ID,""),-1)
	.I MedadrID'=""  D
	..S Medadrreceivedr=$p(^DHCMEDREPADT(MedadrID),"^",9)   //报告状态
	..;"未接收":未接收,1:接收,2:驳回,3:撤销,4:审核,5:归档,6:撤销归档,""
	..;V:未上报，V2:已退回，S1:已上报，S2:评价中，A:已审核，C:作废
	..;S Medadrreceive=$S(Medadrreceivedr="未接收":"V",Medadrreceivedr="1":"S1",Medadrreceivedr="2":"V2",Medadrreceivedr="3":"S1",Medadrreceivedr="4":"S2",Medadrreceivedr="5":"A",Medadrreceivedr="6":"S2",1:"V")
    ..s Medadrreceive=Medadrreceivedr
    ..S RepCancelflag=$p(^DHCMEDREPADT(MedadrID),"^",11) ;作废标识
    ..s:RepCancelflag="Y" Medadrreceive="C"
    s ADVAdmNo=$p(^DHCADVMASTER(ID),"^",20) 	 //病案号
    s ADVEpisodeId=$p(^DHCADVMASTER(ID),"^",16)   //就诊号
    s ADVPatName=$p(^DHCADVMASTER(ID),"^",17)  	 //病人姓名
    s ADVPatSex=$p(^DHCADVMASTER(ID),"^",18)  	 //病人性别
    i ADVPatName="" d
    .i ADVEpisodeId'="" d
    ..s papmidr=$P(^PAADM(ADVEpisodeId),"^",1)
    ..i papmidr'="" d
    ...s ADVPatName=$P($g(^PAPER(papmidr,"ALL")),"^",1)
    ...s ADVPatSex=$p(^PAPER(papmidr,"ALL"),"^",7)
    ...s:ADVPatSex'="" ADVPatSex=$p(^CT("SEX",ADVPatSex),"^",2)
    s ADVRepUserDr=$p(^DHCADVMASTER(ID),"^",6)   //当事人姓名 
    s ADVRepUser=$p(^SSU("SSUSR",ADVRepUserDr),"^",2)    //当事人姓名
    s ADVRepUserTitle=$p(^DHCADVMASTER(ID),"^",28)  	 //职称
    s ADVRepUseWorYears=$p(^DHCADVMASTER(ID),"^",29)   //工作年限
    s ADVRepInjSev=$p(^DHCADVMASTER(ID),"^",13)  	 //伤害严重度
    s:ADVRepInjSev="" ADVRepInjSev=..getradio(ID,"FDResult-95133")
    s ADVRepLocDr=$p(^DHCADVMASTER(ID),"^",7)  	 //科室
    s ADVRepLoc=$p(^CTLOC(ADVRepLocDr),"^",2)		//科室
    s ADVRepWardDr="",ADVRepWardDesc="" //病区 
    i ADVRepLoc'="" d
	.s ADVRepWardDr=$O(^PAWARD(0,"WARD_LocationDR",ADVRepLoc,""))
	.i ADVRepWardDr'="" d
	..s ADVRepWardDesc=$P(^PAWARD(ADVRepWardDr),"^",2)
    s str=str_"^DataStatus|"_Medadrreceive_"^PaRecord|"_ADVAdmNo_"^EpisodeId|"_ADVEpisodeId_"^PaName|"
    s str=str_ADVPatName_"^PaSex|"_ADVPatSex_"^ReprtorName|"_ADVRepUser
    ;职称 
    s str=str_"^ReprtorTitle|"_ADVRepUserTitle 
	i ADVRepUseWorYears<=1 s ADVRepUseWorYears=1
    i (ADVRepUseWorYears>1)&&(ADVRepUseWorYears<=5) s ADVRepUseWorYears=5
    i (ADVRepUseWorYears>5)&&(ADVRepUseWorYears<=10) s ADVRepUseWorYears=10
    i (ADVRepUseWorYears>10)&&(ADVRepUseWorYears<=15) s ADVRepUseWorYears=15
    i (ADVRepUseWorYears>15)&&(ADVRepUseWorYears<=20) s ADVRepUseWorYears=20
    i (ADVRepUseWorYears>20)&&(ADVRepUseWorYears<=25) s ADVRepUseWorYears=25
    i ADVRepUseWorYears>25 s ADVRepUseWorYears=26
    s str=str_"^ReprtorYear|"_ADVRepUseWorYears
    ;不良事件伤害等级:死亡、极重度、重度、中度、轻度、无伤害 
    ;修改成包含关系
    if ((ADVRepInjSev["没有伤害")||(ADVRepInjSev["无伤害")){
		s ADVRepInjSev=0
	}elseif((ADVRepInjSev["轻度")||(ADVRepInjSev["1级")){
		s ADVRepInjSev=1
	}elseif((ADVRepInjSev["中度")||(ADVRepInjSev["2级")){
		s ADVRepInjSev=2
	}elseif((ADVRepInjSev["重度")||(ADVRepInjSev["3级")){
		s ADVRepInjSev=3
	}elseif((ADVRepInjSev["死亡")){
		s ADVRepInjSev=4
	}
    ;s ADVRepInjSev=$case(ADVRepInjSev,"无伤害":"0","轻度":"0","中度":"1","重度":"2","极重度":"3","死亡":"4",:ADVRepInjSev)
    s str=str_"^Degree|"_ADVRepInjSev
    ;科室、病区中文描述
	s str=str_"^ReportLocDesc|"_ADVRepLoc_"^ReportWardDesc|"_ADVRepWardDesc_"^ReportLocId|"_ADVRepLocDr
	q str
}

/// /----------------------Ext滁州中医方法分割线开始-------------------------
/// 不良事件统计分析报表 按发生时间 按工作年限 按职称 按等级 按事件分类
/// d ##class(%ResultSet).RunQuery("web.DHCNurSBDataNew","GetBLSJSBTJB","2019","05","","168")
Query GetBLSJSBTJB(Year As %String, Month As %String, LocId As %String, loc As %String = "") As %Query(ROWSPEC = "Month:%String,Year:%String,pfycNum:%Float,gycwNum:%Float,gdhtNum:%Float,ddzcNum:%Float,tyNum:%Float,syfyNum:%Float,sxfyNum:%Float,fssj1:%Float,fssj2:%Float,fssj3:%Float,fssj4:%Float,fssj5:%Float,fssj6:%Float,fssj7:%Float,fssj8:%Float,fssj9:%Float,fssj10:%Float,fssj11:%Float,fssj12:%Float,gznx1:%Float,gznx2:%Float,gznx3:%Float,gznx4:%Float,gznx5:%Float,gznx6:%Float,gznx7:%Float,zc1:%Float,zc2:%Float,zc3:%Float,zc4:%Float,zc5:%Float,zc6:%Float,zc7:%Float,sjdj1:%Float,sjdj2:%Float,sjdj3:%Float,sjdj4:%Float,sjdj5:%Float,sjdj6:%Float,gdhtdg1:%Float,gdhtdg2:%Float,gdhtdg3:%Float,gdhtdg4:%Float,gdhtdg5:%Float,gdhtdg6:%Float,gdhtdg7:%Float,gdhtdg8:%Float,gdhtdg9:%Float,gdhtdg10:%Float,gdhtdg11:%Float,gdhtdg12:%Float,gdhtdg13:%Float,gdhtdg14:%Float,gdhtdg15:%Float,gdhtdg16:%Float,gdhtdg17:%Float,gdhtdg18:%Float,gdhtdg19:%Float,tyNum276:%Float,tyNum279:%Float,tyNum285:%Float,tyNum72:%Float,tyNum75:%Float,tyNum78:%Float") [ SqlProc ]
{
}

ClassMethod GetBLSJSBTJBExecute(ByRef qHandle As %Binary, Year As %String, Month As %String, LocId As %String, loc As %String) As %Status
{
	;s ^panxuefeng("GetBLSJSBTJB")=""
    s ^panxuefeng("GetBLSJSBTJB")=$lb(Year,Month,LocId,loc)
    s repid=$I(^CacheTemp)
    s ind=1
    s qHandle=$lb(0,repid,0)
    q:Year="" $$$OK
    ;s loc="168"
    s allMonth="01^02^03^04^05^06^07^08^09^10^11^12"
    s pfycNum=0,gycwNum=0,gdhtNum=0,ddzcNum=0,tyNum=0,syfyNum=0,sxfyNum=0
    s fssj1=0,ycfssj1=0,gycwfssj1=0,gdhtfssj1=0,ddzcfssj1=0,tyfssj1=0,syfyfssj1=0,sxfyfssj1=0  ;发生时间
    s fssj2=0,ycfssj2=0,gycwfssj2=0,gdhtfssj2=0,ddzcfssj2=0,tyfssj2=0,syfyfssj2=0,sxfyfssj2=0
    s fssj3=0,ycfssj3=0,gycwfssj3=0,gdhtfssj3=0,ddzcfssj3=0,tyfssj3=0,syfyfssj3=0,sxfyfssj3=0
    s fssj4=0,ycfssj4=0,gycwfssj4=0,gdhtfssj4=0,ddzcfssj4=0,tyfssj4=0,syfyfssj4=0,sxfyfssj4=0
    s fssj5=0,ycfssj5=0,gycwfssj5=0,gdhtfssj5=0,ddzcfssj5=0,tyfssj5=0,syfyfssj5=0,sxfyfssj5=0
    s fssj6=0,ycfssj6=0,gycwfssj6=0,gdhtfssj6=0,ddzcfssj6=0,tyfssj6=0,syfyfssj6=0,sxfyfssj6=0
    s fssj7=0,ycfssj7=0,gycwfssj7=0,gdhtfssj7=0,ddzcfssj7=0,tyfssj7=0,syfyfssj7=0,sxfyfssj7=0
    s fssj8=0,ycfssj8=0,gycwfssj8=0,gdhtfssj8=0,ddzcfssj8=0,tyfssj8=0,syfyfssj8=0,sxfyfssj8=0
    s fssj9=0,ycfssj9=0,gycwfssj9=0,gdhtfssj9=0,ddzcfssj9=0,tyfssj9=0,syfyfssj9=0,sxfyfssj9=0
    s fssj10=0,ycfssj10=0,gycwfssj10=0,gdhtfssj10=0,ddzcfssj10=0,tyfssj10=0,syfyfssj10=0,sxfyfssj10=0
    s fssj11=0,ycfssj11=0,gycwfssj11=0,gdhtfssj11=0,ddzcfssj11=0,tyfssj11=0,syfyfssj11=0,sxfyfssj11=0
    s fssj12=0,ycfssj12=0,gycwfssj12=0,gdhtfssj12=0,ddzcfssj12=0,tyfssj12=0,syfyfssj12=0,sxfyfssj12=0
    
    s gznx1=0,ycgznx1=0,gycwgznx1=0,gdhtgznx1=0,ddzcgznx1=0,tygznx1=0,syfygznx1=0,sxfygznx1=0  ;工作年限
    s gznx2=0,ycgznx2=0,gycwgznx2=0,gdhtgznx2=0,ddzcgznx2=0,tygznx2=0,syfygznx2=0,sxfygznx2=0
    s gznx3=0,ycgznx3=0,gycwgznx3=0,gdhtgznx3=0,ddzcgznx3=0,tygznx3=0,syfygznx3=0,sxfygznx3=0
    s gznx4=0,ycgznx4=0,gycwgznx4=0,gdhtgznx4=0,ddzcgznx4=0,tygznx4=0,syfygznx4=0,sxfygznx4=0
    s gznx5=0,ycgznx5=0,gycwgznx5=0,gdhtgznx5=0,ddzcgznx5=0,tygznx5=0,syfygznx5=0,sxfygznx5=0
    s gznx6=0,ycgznx6=0,gycwgznx6=0,gdhtgznx6=0,ddzcgznx6=0,tygznx6=0,syfygznx6=0,sxfygznx6=0
    s gznx7=0,ycgznx7=0,gycwgznx7=0,gdhtgznx7=0,ddzcgznx7=0,tygznx7=0,syfygznx7=0,sxfygznx7=0
    
    s zc1=0,yczc1=0,gycwzc1=0,gdhtzc1=0,ddzczc1=0,tyzc1=0,syfyzc1=0,sxfyzc1=0  ;职称
    s zc2=0,yczc2=0,gycwzc2=0,gdhtzc2=0,ddzczc2=0,tyzc2=0,syfyzc2=0,sxfyzc2=0
    s zc3=0,yczc3=0,gycwzc3=0,gdhtzc3=0,ddzczc3=0,tyzc3=0,syfyzc3=0,sxfyzc3=0
    s zc4=0,yczc4=0,gycwzc4=0,gdhtzc4=0,ddzczc4=0,tyzc4=0,syfyzc4=0,sxfyzc4=0
    s zc5=0,yczc5=0,gycwzc5=0,gdhtzc5=0,ddzczc5=0,tyzc5=0,syfyzc5=0,sxfyzc5=0
    s zc6=0,yczc6=0,gycwzc6=0,gdhtzc6=0,ddzczc6=0,tyzc6=0,syfyzc6=0,sxfyzc6=0
    s zc7=0,yczc7=0,gycwzc7=0,gdhtzc7=0,ddzczc7=0,tyzc7=0,syfyzc7=0,sxfyzc7=0
    
    s sjdj1=0,ycsjdj1=0,gycwsjdj1=0,gdhtsjdj1=0,ddzcsjdj1=0,tysjdj1=0,syfysjdj1=0,sxfysjdj1=0  ;事件等级
    s sjdj2=0,ycsjdj2=0,gycwsjdj2=0,gdhtsjdj2=0,ddzcsjdj2=0,tysjdj2=0,syfysjdj2=0,sxfysjdj2=0
    s sjdj3=0,ycsjdj3=0,gycwsjdj3=0,gdhtsjdj3=0,ddzcsjdj3=0,tysjdj3=0,syfysjdj3=0,sxfysjdj3=0
    s sjdj4=0,ycsjdj4=0,gycwsjdj4=0,gdhtsjdj4=0,ddzcsjdj4=0,tysjdj4=0,syfysjdj4=0,sxfysjdj4=0
    s sjdj5=0,ycsjdj5=0,gycwsjdj5=0,gdhtsjdj5=0,ddzcsjdj5=0,tysjdj5=0,syfysjdj5=0,sxfysjdj5=0
    s sjdj6=0,ycsjdj6=0,gycwsjdj6=0,gdhtsjdj6=0,ddzcsjdj6=0,tysjdj6=0,syfysjdj6=0,sxfysjdj6=0
    
    s gdhtdg1=0,gdhtdg2=0,gdhtdg3=0,gdhtdg4=0,gdhtdg5=0,gdhtdg6=0,gdhtdg7=0,gdhtdg8=0,gdhtdg9=0,gdhtdg10=0,gdhtdg11=0,gdhtdg12=0,gdhtdg13=0,gdhtdg14=0,gdhtdg15=0,gdhtdg16=0,gdhtdg17=0,gdhtdg18=0,gdhtdg19=0  ;导管类型
    s tyNum276=0,tyNum279=0,tyNum285=0,tyNum72=0,tyNum75=0,tyNum78=0  ;通用事件分类
    i Month'="" d
    .i LocId'=""  d
    ..s LocId1=LocId
    ..d OutwardRowROwBLSJ1
    ..d OutwardRowBLSJ1
    .e  d
    ..s AllLocId=##class(web.DHCNurblsjflwh).GetBtqxCtlocid(loc)
    ..s long=$l(AllLocId,"^")
    ..f num=2:1:long d
    ...s LocId1=$p(AllLocId,"^",num)
    ...d OutwardRowROwBLSJ1
    ..d OutwardRowBLSJ1
    i Month="" d
    .f Num=1:1:12 d
    ..s pfycNum=0,gycwNum=0,gdhtNum=0,ddzcNum=0,tyNum=0,syfyNum=0,sxfyNum=0
    ..s fssj1=0,ycfssj1=0,gycwfssj1=0,gdhtfssj1=0,ddzcfssj1=0,tyfssj1=0,syfyfssj1=0,sxfyfssj1=0
    ..s fssj2=0,ycfssj2=0,gycwfssj2=0,gdhtfssj2=0,ddzcfssj2=0,tyfssj2=0,syfyfssj2=0,sxfyfssj2=0
    ..s fssj3=0,ycfssj3=0,gycwfssj3=0,gdhtfssj3=0,ddzcfssj3=0,tyfssj3=0,syfyfssj3=0,sxfyfssj3=0
    ..s fssj4=0,ycfssj4=0,gycwfssj4=0,gdhtfssj4=0,ddzcfssj4=0,tyfssj4=0,syfyfssj4=0,sxfyfssj4=0
    ..s fssj5=0,ycfssj5=0,gycwfssj5=0,gdhtfssj5=0,ddzcfssj5=0,tyfssj5=0,syfyfssj5=0,sxfyfssj5=0
    ..s fssj6=0,ycfssj6=0,gycwfssj6=0,gdhtfssj6=0,ddzcfssj6=0,tyfssj6=0,syfyfssj6=0,sxfyfssj6=0
    ..s fssj7=0,ycfssj7=0,gycwfssj7=0,gdhtfssj7=0,ddzcfssj7=0,tyfssj7=0,syfyfssj7=0,sxfyfssj7=0
    ..s fssj8=0,ycfssj8=0,gycwfssj8=0,gdhtfssj8=0,ddzcfssj8=0,tyfssj8=0,syfyfssj8=0,sxfyfssj8=0
    ..s fssj9=0,ycfssj9=0,gycwfssj9=0,gdhtfssj9=0,ddzcfssj9=0,tyfssj9=0,syfyfssj9=0,sxfyfssj9=0
    ..s fssj10=0,ycfssj10=0,gycwfssj10=0,gdhtfssj10=0,ddzcfssj10=0,tyfssj10=0,syfyfssj10=0,sxfyfssj10=0
    ..s fssj11=0,ycfssj11=0,gycwfssj11=0,gdhtfssj11=0,ddzcfssj11=0,tyfssj11=0,syfyfssj11=0,sxfyfssj11=0
    ..s fssj12=0,ycfssj12=0,gycwfssj12=0,gdhtfssj12=0,ddzcfssj12=0,tyfssj12=0,syfyfssj12=0,sxfyfssj12=0
    
    ..s gznx1=0,ycgznx1=0,gycwgznx1=0,gdhtgznx1=0,ddzcgznx1=0,tygznx1=0,syfygznx1=0,sxfygznx1=0
    ..s gznx2=0,ycgznx2=0,gycwgznx2=0,gdhtgznx2=0,ddzcgznx2=0,tygznx2=0,syfygznx2=0,sxfygznx2=0
    ..s gznx3=0,ycgznx3=0,gycwgznx3=0,gdhtgznx3=0,ddzcgznx3=0,tygznx3=0,syfygznx3=0,sxfygznx3=0
    ..s gznx4=0,ycgznx4=0,gycwgznx4=0,gdhtgznx4=0,ddzcgznx4=0,tygznx4=0,syfygznx4=0,sxfygznx4=0
    ..s gznx5=0,ycgznx5=0,gycwgznx5=0,gdhtgznx5=0,ddzcgznx5=0,tygznx5=0,syfygznx5=0,sxfygznx5=0
    ..s gznx6=0,ycgznx6=0,gycwgznx6=0,gdhtgznx6=0,ddzcgznx6=0,tygznx6=0,syfygznx6=0,sxfygznx6=0
    ..s gznx7=0,ycgznx7=0,gycwgznx7=0,gdhtgznx7=0,ddzcgznx7=0,tygznx7=0,syfygznx7=0,sxfygznx7=0
    
    ..s zc1=0,yczc1=0,gycwzc1=0,gdhtzc1=0,ddzczc1=0,tyzc1=0,syfyzc1=0,sxfyzc1=0
    ..s zc2=0,yczc2=0,gycwzc2=0,gdhtzc2=0,ddzczc2=0,tyzc2=0,syfyzc2=0,sxfyzc2=0
    ..s zc3=0,yczc3=0,gycwzc3=0,gdhtzc3=0,ddzczc3=0,tyzc3=0,syfyzc3=0,sxfyzc3=0
    ..s zc4=0,yczc4=0,gycwzc4=0,gdhtzc4=0,ddzczc4=0,tyzc4=0,syfyzc4=0,sxfyzc4=0
    ..s zc5=0,yczc5=0,gycwzc5=0,gdhtzc5=0,ddzczc5=0,tyzc5=0,syfyzc5=0,sxfyzc5=0
    ..s zc6=0,yczc6=0,gycwzc6=0,gdhtzc6=0,ddzczc6=0,tyzc6=0,syfyzc6=0,sxfyzc6=0
    ..s zc7=0,yczc7=0,gycwzc7=0,gdhtzc7=0,ddzczc7=0,tyzc7=0,syfyzc7=0,sxfyzc7=0
    
    ..s sjdj1=0,ycsjdj1=0,gycwsjdj1=0,gdhtsjdj1=0,ddzcsjdj1=0,tysjdj1=0,syfysjdj1=0,sxfysjdj1=0
    ..s sjdj2=0,ycsjdj2=0,gycwsjdj2=0,gdhtsjdj2=0,ddzcsjdj2=0,tysjdj2=0,syfysjdj2=0,sxfysjdj2=0
    ..s sjdj3=0,ycsjdj3=0,gycwsjdj3=0,gdhtsjdj3=0,ddzcsjdj3=0,tysjdj3=0,syfysjdj3=0,sxfysjdj3=0
    ..s sjdj4=0,ycsjdj4=0,gycwsjdj4=0,gdhtsjdj4=0,ddzcsjdj4=0,tysjdj4=0,syfysjdj4=0,sxfysjdj4=0
    ..s sjdj5=0,ycsjdj5=0,gycwsjdj5=0,gdhtsjdj5=0,ddzcsjdj5=0,tysjdj5=0,syfysjdj5=0,sxfysjdj5=0
    ..s sjdj6=0,ycsjdj6=0,gycwsjdj6=0,gdhtsjdj6=0,ddzcsjdj6=0,tysjdj6=0,syfysjdj6=0,sxfysjdj6=0
    
    ..s gdhtdg1=0,gdhtdg2=0,gdhtdg3=0,gdhtdg4=0,gdhtdg5=0,gdhtdg6=0,gdhtdg7=0,gdhtdg8=0,gdhtdg9=0,gdhtdg10=0,gdhtdg11=0,gdhtdg12=0,gdhtdg13=0,gdhtdg14=0,gdhtdg15=0,gdhtdg16=0,gdhtdg17=0,gdhtdg18=0,gdhtdg19=0
    ..s tyNum276=0,tyNum279=0,tyNum285=0,tyNum72=0,tyNum75=0,tyNum78=0
    ..s Month=$p(allMonth,"^",Num)
    ..i LocId'="" d
    ...s LocId1=LocId
    ...d OutwardRowROwBLSJ1
    ...d OutwardRowBLSJ1
    ..e  d
    ...s AllLocId1=##class(web.DHCNurblsjflwh).GetBtqxCtlocid(loc)
   
    ...s long1=$l(AllLocId1,"^")
    ...f num1=2:1:long1 d
    ....s LocId1=$p(AllLocId1,"^",num1)
    ....d OutwardRowROwBLSJ1
    ...d OutwardRowBLSJ1
    s qHandle=$lb(0,repid,0)
    Quit $$$OK
OutwardRowBLSJ1
    set Data=$lb(Month,Year,pfycNum,gycwNum,gdhtNum,ddzcNum,tyNum,syfyNum,sxfyNum,fssj1,fssj2,fssj3,fssj4,fssj5,fssj6,fssj7,fssj8,fssj9,fssj10,fssj11,fssj12,gznx1,gznx2,gznx3,gznx4,gznx5,gznx6,gznx7,zc1,zc2,zc3,zc4,zc5,zc6,zc7,sjdj1,sjdj2,sjdj3,sjdj4,sjdj5,sjdj6,gdhtdg1,gdhtdg2,gdhtdg3,gdhtdg4,gdhtdg5,gdhtdg6,gdhtdg7,gdhtdg8,gdhtdg9,gdhtdg10,gdhtdg11,gdhtdg12,gdhtdg13,gdhtdg14,gdhtdg15,gdhtdg16,gdhtdg17,gdhtdg18,gdhtdg19,tyNum276,tyNum279,tyNum285,tyNum72,tyNum75,tyNum78)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
OutwardRowROwBLSJ1
    s Date=Year_"-"_Month_"-"_"1"
    s nextMonth=Month+1
    i nextMonth=13  d 
    .s Year=Year+1 
    .s nextMonth=1
    s endDate=Year_"-"_nextMonth_"-"_"1"
    f sttDate=$zdh(Date,3):1:($zdh(endDate,3)-1) d
    .;b ;888
    .s rw="" f  s rw=$O(^Nur.DHCNurSBDataI("emdate",sttDate," DHCNURXHSB_PFN",rw)) q:rw=""  d
    ..s a=##class(Nur.DHCNurSBData).%OpenId(rw) //皮肤压疮
    ..s Item1=a.Item1
    ..s Item66=a.Item185 //职称
    ..s Item67=a.Item187 //工作年限
    ..s Item72=a.Item273 //发生时间
    ..s Item42=a.Item42 //不良事件等级
    ..s RecCancelUser=a.RecCancelUser
    ..q:RecCancelUser'=""
    ..s status=a.Status
    ..q:((status="C")||(status="V"))
    ..s LocDesc=$P($p(^CTLOC(LocId1),"^",2),"-",2)
    ..q:(Item1'=LocDesc)
    ..s pfycNum=pfycNum+1
    
    ..i Item72="" s Item72=0
    ..s RecTime=$zth(Item72)
    ..i ((RecTime>0)&(RecTime<7200))||(RecTime=0)||(RecTime=7200)         s ycfssj1=ycfssj1+1
    ..i ((RecTime>7200)&(RecTime<14400))||(RecTime=14400)  s ycfssj2=ycfssj2+1
    ..i ((RecTime>14400)&(RecTime<21600))||(RecTime=21600)  s ycfssj3=ycfssj3+1
    ..i ((RecTime>21600)&(RecTime<28800))||(RecTime=28800)  s ycfssj4=ycfssj4+1
    ..i ((RecTime>28800)&(RecTime<36000))||(RecTime=36000)  s ycfssj5=ycfssj5+1
    ..i ((RecTime>36000)&(RecTime<43200))||(RecTime=43200)  s ycfssj6=ycfssj6+1
    ..i ((RecTime>43200)&(RecTime<50400))||(RecTime=50400)  s ycfssj7=ycfssj7+1
    ..i ((RecTime>50400)&(RecTime<57600))||(RecTime=57600)  s ycfssj8=ycfssj8+1
    ..i ((RecTime>57600)&(RecTime<64800))||(RecTime=64800)  s ycfssj9=ycfssj9+1
    ..i ((RecTime>64800)&(RecTime<72000))||(RecTime=72000)  s ycfssj10=ycfssj10+1
    ..i ((RecTime>72000)&(RecTime<79200))||(RecTime=79200)  s ycfssj11=ycfssj11+1
    ..i ((RecTime>79200)&(RecTime<86340))||(RecTime=86340)  s ycfssj12=ycfssj12+1
    
    ..i Item67["☑未满" s ycgznx1=ycgznx1+1
    ..i Item67["☑1-5" s ycgznx2=ycgznx2+1
    ..i Item67["☑6-10" s ycgznx3=ycgznx3+1
    ..i Item67["☑11-15" s ycgznx4=ycgznx4+1
    ..i Item67["☑16-20" s ycgznx5=ycgznx5+1
    ..i Item67["☑21-25" s ycgznx6=ycgznx6+1
    ..i Item67["☑26" s ycgznx7=ycgznx7+1
    ..s Item66=$p(Item66,"!",1)
    ..i Item66="实习护士" s yczc1=yczc1+1
    ..i Item66="轮转护士" s yczc2=yczc2+1
    ..i Item66="护士" s yczc3=yczc3+1
    ..i Item66="护师" s yczc4=yczc4+1
    ..i Item66="主管护师" s yczc5=yczc5+1
    ..i Item66="副主任护师" s yczc6=yczc6+1
    ..i Item66="主任护师" s yczc7=yczc7+1
    ..s Item42=$p(Item42,"!",1)

    ..i Item42="死亡" s ycsjdj1=ycsjdj1+1
    ..i Item42="极重度" s ycsjdj2=ycsjdj2+1
    ..i Item42="重度" s ycsjdj3=ycsjdj3+1
    ..i Item42="中度" s ycsjdj4=ycsjdj4+1
    ..i Item42="轻度" s ycsjdj5=ycsjdj5+1
    ..i Item42="无伤害" s ycsjdj6=ycsjdj6+1
    .s rw="" f  s rw=$O(^Nur.DHCNurSBDataI("emdate",sttDate," DHCNURXHSB_GYCWN",rw)) q:rw=""  d
    ..s a=##class(Nur.DHCNurSBData).%OpenId(rw)  //
    ..s Item1=a.Item1
    ..s Item66=a.Item185 //职称
    ..s Item67=a.Item187 //工作年限
    ..s Item72=a.Item71 //发生时间
    ..s Item42=a.Item42 //不良事件等级
    ..s RecCancelUser=a.RecCancelUser
    ..b:(rw="5691")&&(LocId1="226") ;1
    ..q:RecCancelUser'=""
    ..s status=a.Status
    ..q:((status="C")||(status="V"))
    ..s LocDesc=$P($p(^CTLOC(LocId1),"^",2),"-",2)
    ..b:(rw="5691")&&(LocId1="226") ;2
    ..q:(Item1'=LocDesc)
    ..s gycwNum=gycwNum+1
    
    ..i Item72="" s Item72=0
    ..s RecTime=$zth(Item72)
    ..i ((RecTime>0)&(RecTime<7200))||(RecTime=0)||(RecTime=7200)         s gycwfssj1=gycwfssj1+1
    ..i ((RecTime>7200)&(RecTime<14400))||(RecTime=14400)  s gycwfssj2=gycwfssj2+1
    ..i ((RecTime>14400)&(RecTime<21600))||(RecTime=21600)  s gycwfssj3=gycwfssj3+1
    ..i ((RecTime>21600)&(RecTime<28800))||(RecTime=28800)  s gycwfssj4=gycwfssj4+1
    ..i ((RecTime>28800)&(RecTime<36000))||(RecTime=36000)  s gycwfssj5=gycwfssj5+1
    ..i ((RecTime>36000)&(RecTime<43200))||(RecTime=43200)  s gycwfssj6=gycwfssj6+1
    ..i ((RecTime>43200)&(RecTime<50400))||(RecTime=50400)  s gycwfssj7=gycwfssj7+1
    ..i ((RecTime>50400)&(RecTime<57600))||(RecTime=57600)  s gycwfssj8=gycwfssj8+1
    ..i ((RecTime>57600)&(RecTime<64800))||(RecTime=64800)  s gycwfssj9=gycwfssj9+1
    ..i ((RecTime>64800)&(RecTime<72000))||(RecTime=72000)  s gycwfssj10=gycwfssj10+1
    ..i ((RecTime>72000)&(RecTime<79200))||(RecTime=79200)  s gycwfssj11=gycwfssj11+1
    ..i ((RecTime>79200)&(RecTime<86340))||(RecTime=86340)  s gycwfssj12=gycwfssj12+1
    
    ..i Item67["☑未满" s gycwgznx1=gycwgznx1+1
    ..i Item67["☑1-5" s gycwgznx2=gycwgznx2+1
    ..i Item67["☑6-10" s gycwgznx3=gycwgznx3+1
    ..i Item67["☑11-15" s gycwgznx4=gycwgznx4+1
    ..i Item67["☑16-20" s gycwgznx5=gycwgznx5+1
    ..i Item67["☑21-25" s gycwgznx6=gycwgznx6+1
    ..i Item67["☑26" s gycwgznx7=gycwgznx7+1
    ..

    ..s Item66=$p(Item66,"!",1)
    ..i Item66="实习护士" s gycwzc1=gycwzc1+1
    ..i Item66="轮转护士" s gycwzc2=gycwzc2+1
    ..i Item66="护士" s gycwzc3=gycwzc3+1
    ..i Item66="护师" s gycwzc4=gycwzc4+1
    ..i Item66="主管护师" s gycwzc5=gycwzc5+1
    ..i Item66="副主任护师" s gycwzc6=gycwzc6+1
    ..i Item66="主任护师" s gycwzc7=gycwzc7+1
    ..s Item42=$p(Item42,"!",1)
    ..i Item42="死亡" s gycwsjdj1=gycwsjdj1+1
    ..i Item42="极重度" s gycwsjdj2=gycwsjdj2+1
    ..i Item42="重度" s gycwsjdj3=gycwsjdj3+1
    ..i Item42="中度" s gycwsjdj4=gycwsjdj4+1
    ..i Item42="轻度" s gycwsjdj5=gycwsjdj5+1
    ..i Item42="无伤害" s gycwsjdj6=gycwsjdj6+1
    .s rw="" f  s rw=$O(^Nur.DHCNurSBDataI("emdate",sttDate," DHCNURXHSB_GDHTN",rw)) q:rw=""  d
    ..s a=##class(Nur.DHCNurSBData).%OpenId(rw) //管道滑脱
    ..s Item1=a.Item1
    ..s Item66=a.Item185 //职称
    ..s Item67=a.Item187 //工作年限
    ..s Item72=a.Item72 //发生时间
    ..s Item42=a.Item42 //不良事件等级
    ..s Item167=a.Item285 //I类导管
    ..s Item168=a.Item287 //II类导管
    ..s Item169=a.Item103 //III类导管
    ..s RecCancelUser=a.RecCancelUser
    ..q:RecCancelUser'=""
    ..s status=a.Status
    ..q:((status="C")||(status="V"))
    ..s LocDesc=$P($p(^CTLOC(LocId1),"^",2),"-",2)
    ..q:(Item1'=LocDesc)
    ..s gdhtNum=gdhtNum+1
    
    ..i Item72="" s Item72=0
    ..s RecTime=$zth(Item72)
    ..i ((RecTime>0)&(RecTime<7200))||(RecTime=0)||(RecTime=7200)         s gdhtfssj1=gdhtfssj1+1
    ..i ((RecTime>7200)&(RecTime<14400))||(RecTime=14400)  s gdhtfssj2=gdhtfssj2+1
    ..i ((RecTime>14400)&(RecTime<21600))||(RecTime=21600)  s gdhtfssj3=gdhtfssj3+1
    ..i ((RecTime>21600)&(RecTime<28800))||(RecTime=28800)  s gdhtfssj4=gdhtfssj4+1
    ..i ((RecTime>28800)&(RecTime<36000))||(RecTime=36000)  s gdhtfssj5=gdhtfssj5+1
    ..i ((RecTime>36000)&(RecTime<43200))||(RecTime=43200)  s gdhtfssj6=gdhtfssj6+1
    ..i ((RecTime>43200)&(RecTime<50400))||(RecTime=50400)  s gdhtfssj7=gdhtfssj7+1
    ..i ((RecTime>50400)&(RecTime<57600))||(RecTime=57600)  s gdhtfssj8=gdhtfssj8+1
    ..i ((RecTime>57600)&(RecTime<64800))||(RecTime=64800)  s gdhtfssj9=gdhtfssj9+1
    ..i ((RecTime>64800)&(RecTime<72000))||(RecTime=72000)  s gdhtfssj10=gdhtfssj10+1
    ..i ((RecTime>72000)&(RecTime<79200))||(RecTime=79200)  s gdhtfssj11=gdhtfssj11+1
    ..i ((RecTime>79200)&(RecTime<86340))||(RecTime=86340)  s gdhtfssj12=gdhtfssj12+1
    
    ..i Item67["☑未满" s gdhtgznx1=gdhtgznx1+1
    ..i Item67["☑1-5" s gdhtgznx2=gdhtgznx2+1
    ..i Item67["☑6-10" s gdhtgznx3=gdhtgznx3+1
    ..i Item67["☑11-15" s gdhtgznx4=gdhtgznx4+1
    ..i Item67["☑16-20" s gdhtgznx5=gdhtgznx5+1
    ..i Item67["☑21-25" s gdhtgznx6=gdhtgznx6+1
    ..i Item67["☑26" s gdhtgznx7=gdhtgznx7+1
    ..s Item66=$p(Item66,"!",1)
    ..i Item66="实习护士" s gdhtzc1=gdhtzc1+1
    ..i Item66="轮转护士" s gdhtzc2=gdhtzc2+1
    ..i Item66="护士" s gdhtzc3=gdhtzc3+1
    ..i Item66="护师" s gdhtzc4=gdhtzc4+1
    ..i Item66="主管护师" s gdhtzc5=gdhtzc5+1
    ..i Item66="副主任护师" s gdhtzc6=gdhtzc6+1
    ..i Item66="主任护师" s gdhtzc7=gdhtzc7+1
    ..s Item42=$p(Item42,"!",1)
    ..i Item42="死亡" s gdhtsjdj1=gdhtsjdj1+1
    ..i Item42="极重度" s gdhtsjdj2=gdhtsjdj2+1
    ..i Item42="重度" s gdhtsjdj3=gdhtsjdj3+1
    ..i Item42="中度" s gdhtsjdj4=gdhtsjdj4+1
    ..i Item42="轻度" s gdhtsjdj5=gdhtsjdj5+1
    ..i Item42="无伤害" s gdhtsjdj6=gdhtsjdj6+1
    ..s Item167=$p(Item167,"!",1)
    ..s Item168=$p(Item168,"!",1)
    ..s Item169=$p(Item169,"!",1)
    ..i Item167="胸管" s gdhtdg1=gdhtdg1+1
    ..i Item167="T管" s gdhtdg2=gdhtdg2+1
    ..i Item167="口鼻插管" s gdhtdg3=gdhtdg3+1
    ..i Item167="动脉置管" s gdhtdg4=gdhtdg4+1
    ..i Item167="气管切开管" s gdhtdg5=gdhtdg5+1
    ..i Item167="脑室引流管" s gdhtdg6=gdhtdg6+1
    ..i Item167="关节腔引流管" s gdhtdg7=gdhtdg7+1
    ..i Item168="双套管" s gdhtdg8=gdhtdg8+1
    ..i Item168="深静脉置管" s gdhtdg9=gdhtdg9+1
    ..i Item168="造瘘管1根" s gdhtdg10=gdhtdg10+1
    ..i Item168="负压引流管1根" s gdhtdg11=gdhtdg11+1
    ..i Item168="腰椎引流管" s gdhtdg12=gdhtdg12+1
    ..i Item169="导尿管" s gdhtdg13=gdhtdg13+1
    ..i Item169="胃管" s gdhtdg14=gdhtdg14+1
    ..i Item169="输液管" s gdhtdg15=gdhtdg15+1
    ..i Item169="吸氧管" s gdhtdg16=gdhtdg16+1
    ..i Item169="鼻胃肠管" s gdhtdg17=gdhtdg17+1
    ..i Item169="留置针" s gdhtdg18=gdhtdg18+1
    ..i Item169="PICC" s gdhtdg19=gdhtdg19+1
    .s rw="" f  s rw=$O(^Nur.DHCNurSBDataI("emdate",sttDate," DHCNURXHSB_DDZCN",rw)) q:rw=""  d
    ..s a=##class(Nur.DHCNurSBData).%OpenId(rw)
    ..s Item1=a.Item1
    ..s Item66=a.Item185 //职称
    ..s Item67=a.Item187 //工作年限
    ..s Item72=a.Item72 //发生时间
    ..s Item42=a.Item42 //不良事件等级
    ..s RecCancelUser=a.RecCancelUser
    ..q:RecCancelUser'=""
    ..s status=a.Status
    ..q:((status="C")||(status="V"))
    ..s LocDesc=$P($p(^CTLOC(LocId1),"^",2),"-",2)
    ..q:(Item1'=LocDesc)
    ..s ddzcNum=ddzcNum+1
    
    ..i Item72="" s Item72=0
    ..s RecTime=$zth(Item72)
    ..i ((RecTime>0)&(RecTime<7200))||(RecTime=0)||(RecTime=7200)         s ddzcfssj1=ddzcfssj1+1
    ..i ((RecTime>7200)&(RecTime<14400))||(RecTime=14400)  s ddzcfssj2=ddzcfssj2+1
    ..i ((RecTime>14400)&(RecTime<21600))||(RecTime=21600)  s ddzcfssj3=ddzcfssj3+1
    ..i ((RecTime>21600)&(RecTime<28800))||(RecTime=28800)  s ddzcfssj4=ddzcfssj4+1
    ..i ((RecTime>28800)&(RecTime<36000))||(RecTime=36000)  s ddzcfssj5=ddzcfssj5+1
    ..i ((RecTime>36000)&(RecTime<43200))||(RecTime=43200)  s ddzcfssj6=ddzcfssj6+1
    ..i ((RecTime>43200)&(RecTime<50400))||(RecTime=50400)  s ddzcfssj7=ddzcfssj7+1
    ..i ((RecTime>50400)&(RecTime<57600))||(RecTime=57600)  s ddzcfssj8=ddzcfssj8+1
    ..i ((RecTime>57600)&(RecTime<64800))||(RecTime=64800)  s ddzcfssj9=ddzcfssj9+1
    ..i ((RecTime>64800)&(RecTime<72000))||(RecTime=72000)  s ddzcfssj10=ddzcfssj10+1
    ..i ((RecTime>72000)&(RecTime<79200))||(RecTime=79200)  s ddzcfssj11=ddzcfssj11+1
    ..i ((RecTime>79200)&(RecTime<86340))||(RecTime=86340)  s ddzcfssj12=ddzcfssj12+1

    
    ..i Item67["☑未满" s ddzcgznx1=ddzcgznx1+1
    ..i Item67["☑1-5" s ddzcgznx2=ddzcgznx2+1
    ..i Item67["☑6-10" s ddzcgznx3=ddzcgznx3+1
    ..i Item67["☑11-15" s ddzcgznx4=ddzcgznx4+1
    ..i Item67["☑16-20" s ddzcgznx5=ddzcgznx5+1
    ..i Item67["☑21-25" s ddzcgznx6=ddzcgznx6+1
    ..i Item67["☑26" s ddzcgznx7=ddzcgznx7+1
    ..s Item66=$p(Item66,"!",1)
    ..i Item66="实习护士" s ddzczc1=ddzczc1+1
    ..i Item66="轮转护士" s ddzczc2=ddzczc2+1
    ..i Item66="护士" s ddzczc3=ddzczc3+1
    ..i Item66="护师" s ddzczc4=ddzczc4+1
    ..i Item66="主管护师" s ddzczc5=ddzczc5+1
    ..i Item66="副主任护师" s ddzczc6=ddzczc6+1
    ..i Item66="主任护师" s ddzczc7=ddzczc7+1
    ..s Item42=$p(Item42,"!",1)
    ..i Item42="死亡" s ddzcsjdj1=ddzcsjdj1+1
    ..i Item42="极重度" s ddzcsjdj2=ddzcsjdj2+1
    ..i Item42="重度" s ddzcsjdj3=ddzcsjdj3+1
    ..i Item42="中度" s ddzcsjdj4=ddzcsjdj4+1
    ..i Item42="轻度" s ddzcsjdj5=ddzcsjdj5+1
    ..i Item42="无伤害" s ddzcsjdj6=ddzcsjdj6+1
    .s rw="" f  s rw=$O(^Nur.DHCNurSBDataI("emdate",sttDate," DHCNURXHSB_TYN",rw)) q:rw=""  d
    ..s a=##class(Nur.DHCNurSBData).%OpenId(rw)
    ..s Item1=a.Item1
    ..s Item66=a.Item185 //职称
    ..s Item67=a.Item187 //工作年限
    ..s Item72=a.Item273 //发生时间
    ..s Item42=a.Item42 //不良事件等级
    ..s RecCancelUser=a.RecCancelUser
    ..q:RecCancelUser'=""
    ..s status=a.Status
    ..q:((status="C")||(status="V"))
    ..s LocDesc=$P($p(^CTLOC(LocId1),"^",2),"-",2)
    ..q:(Item1'=LocDesc)
    ..s tyNum=tyNum+1
    ..s Item276=a.Item276
    ..s Item279=a.Item279
    ..s Item285=a.Item285
    ..s Item73=a.Item72
    ..s Item75=a.Item75
    ..s Item78=a.Item78
    ..b:rw="12212" ;1
    ..i Item276["☑"  s tyNum276=tyNum276+1
    ..i Item279["☑"  s tyNum279=tyNum279+1
    ..i Item285["☑"  s tyNum285=tyNum285+1
    ..i Item73["☑"  s tyNum72=tyNum72+1
    ..i Item75["☑"  s tyNum75=tyNum75+1
    ..i Item78["☑"  s tyNum78=tyNum78+1
    ..b:rw="12365" ;11
    ..i Item72="" s Item72=0
    ..s RecTime=$zth(Item72)
    ..i ((RecTime>0)&(RecTime<7200))||(RecTime=0)||(RecTime=7200)         s tyfssj1=tyfssj1+1
    ..i ((RecTime>7200)&(RecTime<14400))||(RecTime=14400)  s tyfssj2=tyfssj2+1
    ..i ((RecTime>14400)&(RecTime<21600))||(RecTime=21600)  s tyfssj3=tyfssj3+1
    ..i ((RecTime>21600)&(RecTime<28800))||(RecTime=28800)  s tyfssj4=tyfssj4+1
    ..i ((RecTime>28800)&(RecTime<36000))||(RecTime=36000)  s tyfssj5=tyfssj5+1
    ..i ((RecTime>36000)&(RecTime<43200))||(RecTime=43200)  s tyfssj6=tyfssj6+1
    ..i ((RecTime>43200)&(RecTime<50400))||(RecTime=50400)  s tyfssj7=tyfssj7+1
    ..i ((RecTime>50400)&(RecTime<57600))||(RecTime=57600)  s tyfssj8=tyfssj8+1
    ..i ((RecTime>57600)&(RecTime<64800))||(RecTime=64800)  s tyfssj9=tyfssj9+1
    ..i ((RecTime>64800)&(RecTime<72000))||(RecTime=72000)  s tyfssj10=tyfssj10+1
    ..i ((RecTime>72000)&(RecTime<79200))||(RecTime=79200)  s tyfssj11=tyfssj11+1
    ..i ((RecTime>79200)&(RecTime<86340))||(RecTime=86340)  s tyfssj12=tyfssj12+1
    
    ..i Item67["☑未满" s tygznx1=tygznx1+1
    ..i Item67["☑1-5" s tygznx2=tygznx2+1
    ..i Item67["☑6-10" s tygznx3=tygznx3+1
    ..i Item67["☑11-15" s tygznx4=tygznx4+1
    ..i Item67["☑16-20" s tygznx5=tygznx5+1
    ..i Item67["☑21-25" s tygznx6=tygznx6+1
    ..i Item67["☑26" s tygznx7=tygznx7+1
    ..s Item66=$p(Item66,"!",1)
    ..i Item66="实习护士" s tyzc1=tyzc1+1
    ..i Item66="轮转护士" s tyzc2=tyzc2+1
    ..i Item66="护士" s tyzc3=tyzc3+1
    ..i Item66="护师" s tyzc4=tyzc4+1
    ..i Item66="主管护师" s tyzc5=tyzc5+1
    ..i Item66="副主任护师" s tyzc6=tyzc6+1
    ..i Item66="主任护师" s tyzc7=tyzc7+1
    ..s Item42=$p(Item42,"!",1)
    ..i Item42="死亡" s tysjdj1=tysjdj1+1
    ..i Item42="极重度" s tysjdj2=tysjdj2+1
    ..i Item42="重度" s tysjdj3=tysjdj3+1
    ..i Item42="中度" s tysjdj4=tysjdj4+1
    ..i Item42="轻度" s tysjdj5=tysjdj5+1
    ..i Item42="无伤害" s tysjdj6=tysjdj6+1
    
    .s rw="" f  s rw=$O(^Nur.DHCNurSBDataI("emdate",sttDate," DHCNURXHSB_SXFYN",rw)) q:rw=""  d
    ..s a=##class(Nur.DHCNurSBData).%OpenId(rw)
    ..s Item1=a.Item1
    ..s Item66=a.Item185 //职称
    ..s Item67=a.Item187 //工作年限
    ..s Item72=a.Item72 //发生时间
    ..s Item42=a.Item42 //不良事件等级
    ..s RecCancelUser=a.RecCancelUser
    ..q:RecCancelUser'=""
    ..s status=a.Status
    ..q:((status="C")||(status="V"))
    ..s LocDesc=$P($p(^CTLOC(LocId1),"^",2),"-",2)
    ..q:(Item1'=LocDesc)
    ..s sxfyNum=sxfyNum+1
    ..i Item72="" s Item72=0
    ..s RecTime=$zth(Item72)
    ..i ((RecTime>0)&(RecTime<7200))||(RecTime=0)||(RecTime=7200)         s sxfyfssj1=sxfyfssj1+1
    ..i ((RecTime>7200)&(RecTime<14400))||(RecTime=14400)  s sxfyfssj2=sxfyfssj2+1
    ..i ((RecTime>14400)&(RecTime<21600))||(RecTime=21600)  s sxfyfssj3=sxfyfssj3+1
    ..i ((RecTime>21600)&(RecTime<28800))||(RecTime=28800)  s sxfyfssj4=sxfyfssj4+1
    ..i ((RecTime>28800)&(RecTime<36000))||(RecTime=36000)  s sxfyfssj5=sxfyfssj5+1
    ..i ((RecTime>36000)&(RecTime<43200))||(RecTime=43200)  s sxfyfssj6=sxfyfssj6+1
    ..i ((RecTime>43200)&(RecTime<50400))||(RecTime=50400)  s sxfyfssj7=sxfyfssj7+1
    ..i ((RecTime>50400)&(RecTime<57600))||(RecTime=57600)  s sxfyfssj8=sxfyfssj8+1
    ..i ((RecTime>57600)&(RecTime<64800))||(RecTime=64800)  s sxfyfssj9=sxfyfssj9+1
    ..i ((RecTime>64800)&(RecTime<72000))||(RecTime=72000)  s sxfyfssj10=sxfyfssj10+1
    ..i ((RecTime>72000)&(RecTime<79200))||(RecTime=79200)  s sxfyfssj11=sxfyfssj11+1
    ..i ((RecTime>79200)&(RecTime<86340))||(RecTime=86340)  s sxfyfssj12=sxfyfssj12+1
    ..i Item67["☑未满" s sxfygznx1=sxfygznx1+1
    ..i Item67["☑1-5" s sxfygznx2=sxfygznx2+1
    ..i Item67["☑6-10" s sxfygznx3=sxfygznx3+1
    ..i Item67["☑11-15" s sxfygznx4=sxfygznx4+1
    ..i Item67["☑16-20" s sxfygznx5=sxfygznx5+1
    ..i Item67["☑21-25" s sxfygznx6=sxfygznx6+1
    ..i Item67["☑26" s sxfygznx7=sxfygznx7+1
    ..s Item66=$p(Item66,"!",1)
    ..i Item66="实习护士" s sxfyzc1=sxfyzc1+1
    ..i Item66="轮转护士" s sxfyzc2=sxfyzc2+1
    ..i Item66="护士" s sxfyzc3=sxfyzc3+1
    ..i Item66="护师" s sxfyzc4=sxfyzc4+1
    ..i Item66="主管护师" s sxfyzc5=sxfyzc5+1
    ..i Item66="副主任护师" s sxfyzc6=sxfyzc6+1
    ..i Item66="主任护师" s sxfyzc7=sxfyzc7+1
    ..s Item42=$p(Item42,"!",1)
    ..i Item42="死亡" s sxfysjdj1=sxfysjdj1+1
    ..i Item42="极重度" s sxfysjdj2=sxfysjdj2+1
    ..i Item42="重度" s sxfysjdj3=sxfysjdj3+1
    ..i Item42="中度" s sxfysjdj4=sxfysjdj4+1
    ..i Item42="轻度" s sxfysjdj5=sxfysjdj5+1
    ..i Item42="无伤害" s sxfysjdj6=sxfysjdj6+1
    .s rw="" f  s rw=$O(^Nur.DHCNurSBDataI("emdate",sttDate," DHCNURXHSB_SYFYN",rw)) q:rw=""  d
    ..s a=##class(Nur.DHCNurSBData).%OpenId(rw)
    ..s Item1=a.Item1
    ..s Item66=a.Item185 //职称
    ..s Item67=a.Item187 //工作年限
    ..s Item72=a.Item72 //发生时间
    ..s Item42=a.Item42 //不良事件等级
    ..s RecCancelUser=a.RecCancelUser
    ..q:RecCancelUser'=""
    ..s status=a.Status
    ..q:((status="C")||(status="V"))
    ..s LocDesc=$P($p(^CTLOC(LocId1),"^",2),"-",2)
    ..q:(Item1'=LocDesc)
    ..s syfyNum=syfyNum+1
    ..i Item72="" s Item72=0
    ..s RecTime=$zth(Item72)
    ..i ((RecTime>0)&(RecTime<7200))||(RecTime=0)||(RecTime=7200)         s syfyfssj1=syfyfssj1+1
    ..i ((RecTime>7200)&(RecTime<14400))||(RecTime=14400)  s syfyfssj2=syfyfssj2+1
    ..i ((RecTime>14400)&(RecTime<21600))||(RecTime=21600)  s syfyfssj3=syfyfssj3+1
    ..i ((RecTime>21600)&(RecTime<28800))||(RecTime=28800)  s syfyfssj4=syfyfssj4+1
    ..i ((RecTime>28800)&(RecTime<36000))||(RecTime=36000)  s syfyfssj5=syfyfssj5+1
    ..i ((RecTime>36000)&(RecTime<43200))||(RecTime=43200)  s syfyfssj6=syfyfssj6+1
    ..i ((RecTime>43200)&(RecTime<50400))||(RecTime=50400)  s syfyfssj7=syfyfssj7+1
    ..i ((RecTime>50400)&(RecTime<57600))||(RecTime=57600)  s syfyfssj8=syfyfssj8+1
    ..i ((RecTime>57600)&(RecTime<64800))||(RecTime=64800)  s syfyfssj9=syfyfssj9+1
    ..i ((RecTime>64800)&(RecTime<72000))||(RecTime=72000)  s syfyfssj10=syfyfssj10+1
    ..i ((RecTime>72000)&(RecTime<79200))||(RecTime=79200)  s syfyfssj11=syfyfssj11+1
    ..i ((RecTime>79200)&(RecTime<86340))||(RecTime=86340)  s syfyfssj12=syfyfssj12+1
    ..i Item67["☑未满" s syfygznx1=syfygznx1+1
    ..i Item67["☑1-5" s syfygznx2=syfygznx2+1
    ..i Item67["☑6-10" s syfygznx3=syfygznx3+1
    ..i Item67["☑11-15" s syfygznx4=syfygznx4+1
    ..i Item67["☑16-20" s syfygznx5=syfygznx5+1
    ..i Item67["☑21-25" s syfygznx6=syfygznx6+1
    ..i Item67["☑26" s syfygznx7=syfygznx7+1
    ..s Item66=$p(Item66,"!",1)
    ..i Item66="实习护士" s syfyzc1=syfyzc1+1
    ..i Item66="轮转护士" s syfyzc2=syfyzc2+1
    ..i Item66="护士" s syfyzc3=syfyzc3+1
    ..i Item66="护师" s syfyzc4=syfyzc4+1
    ..i Item66="主管护师" s syfyzc5=syfyzc5+1
    ..i Item66="副主任护师" s syfyzc6=syfyzc6+1
    ..i Item66="主任护师" s syfyzc7=syfyzc7+1
    ..s Item42=$p(Item42,"!",1)
    ..i Item42="死亡" s syfysjdj1=syfysjdj1+1
    ..i Item42="极重度" s syfysjdj2=syfysjdj2+1
    ..i Item42="重度" s syfysjdj3=syfysjdj3+1
    ..i Item42="中度" s syfysjdj4=syfysjdj4+1
    ..i Item42="轻度" s syfysjdj5=syfysjdj5+1
    ..i Item42="无伤害" s syfysjdj6=syfysjdj6+1
    
    
    s fssj1=ycfssj1+gycwfssj1+gdhtfssj1+ddzcfssj1+tyfssj1+syfyfssj1+sxfyfssj1
    s fssj2=ycfssj2+gycwfssj2+gdhtfssj2+ddzcfssj2+tyfssj2+syfyfssj2+sxfyfssj2
    s fssj3=ycfssj3+gycwfssj3+gdhtfssj3+ddzcfssj3+tyfssj3+syfyfssj3+sxfyfssj3
    s fssj4=ycfssj4+gycwfssj4+gdhtfssj4+ddzcfssj4+tyfssj4+syfyfssj4+sxfyfssj4
    s fssj5=ycfssj5+gycwfssj5+gdhtfssj5+ddzcfssj5+tyfssj5+syfyfssj5+sxfyfssj5
    s fssj6=ycfssj6+gycwfssj6+gdhtfssj6+ddzcfssj6+tyfssj6+syfyfssj6+sxfyfssj6
    s fssj7=ycfssj7+gycwfssj7+gdhtfssj7+ddzcfssj7+tyfssj7+syfyfssj7+sxfyfssj7
    s fssj8=ycfssj8+gycwfssj8+gdhtfssj8+ddzcfssj8+tyfssj8+syfyfssj8+sxfyfssj8
    s fssj9=ycfssj9+gycwfssj9+gdhtfssj9+ddzcfssj9+tyfssj9+syfyfssj9+sxfyfssj9
    s fssj10=ycfssj10+gycwfssj10+gdhtfssj10+ddzcfssj10+tyfssj10+syfyfssj10+sxfyfssj10
    s fssj11=ycfssj11+gycwfssj11+gdhtfssj11+ddzcfssj11+tyfssj11+syfyfssj11+sxfyfssj11
    s fssj12=ycfssj12+gycwfssj12+gdhtfssj12+ddzcfssj12+tyfssj12+syfyfssj12+sxfyfssj12
    s gznx1=ycgznx1+gycwgznx1+gdhtgznx1+ddzcgznx1+tygznx1+syfygznx1+sxfygznx1
    s gznx2=ycgznx2+gycwgznx2+gdhtgznx2+ddzcgznx2+tygznx2+syfygznx2+sxfygznx2
    s gznx3=ycgznx3+gycwgznx3+gdhtgznx3+ddzcgznx3+tygznx3+syfygznx3+sxfygznx3
    s gznx4=ycgznx4+gycwgznx4+gdhtgznx4+ddzcgznx4+tygznx4+syfygznx4+sxfygznx4
    s gznx5=ycgznx5+gycwgznx5+gdhtgznx5+ddzcgznx5+tygznx5+syfygznx5+sxfygznx5
    s gznx6=ycgznx6+gycwgznx6+gdhtgznx6+ddzcgznx6+tygznx6+syfygznx6+sxfygznx6
    s gznx7=ycgznx7+gycwgznx7+gdhtgznx7+ddzcgznx7+tygznx7+syfygznx7+sxfygznx7
    s zc1=yczc1+gycwzc1+gdhtzc1+ddzczc1+tyzc1+syfyzc1+sxfyzc1
    s zc2=yczc2+gycwzc2+gdhtzc2+ddzczc2+tyzc2+syfyzc2+sxfyzc2
    s zc3=yczc3+gycwzc3+gdhtzc3+ddzczc3+tyzc3+syfyzc3+sxfyzc3
    s zc4=yczc4+gycwzc4+gdhtzc4+ddzczc4+tyzc4+syfyzc4+sxfyzc4
    s zc5=yczc5+gycwzc5+gdhtzc5+ddzczc5+tyzc5+syfyzc5+sxfyzc5
    s zc6=yczc6+gycwzc6+gdhtzc6+ddzczc6+tyzc6+syfyzc6+sxfyzc6
    s zc7=yczc7+gycwzc7+gdhtzc7+ddzczc7+tyzc7+syfyzc7+sxfyzc7
    s sjdj1=ycsjdj1+gycwsjdj1+gdhtsjdj1+ddzcsjdj1+tysjdj1+syfysjdj1+sxfysjdj1
    s sjdj2=ycsjdj2+gycwsjdj2+gdhtsjdj2+ddzcsjdj2+tysjdj2+syfysjdj2+sxfysjdj2
    s sjdj3=ycsjdj3+gycwsjdj3+gdhtsjdj3+ddzcsjdj3+tysjdj3+syfysjdj3+sxfysjdj3
    s sjdj4=ycsjdj4+gycwsjdj4+gdhtsjdj4+ddzcsjdj4+tysjdj4+syfysjdj4+sxfysjdj4
    s sjdj5=ycsjdj5+gycwsjdj5+gdhtsjdj5+ddzcsjdj5+tysjdj5+syfysjdj5+sxfysjdj5
    s sjdj6=ycsjdj6+gycwsjdj6+gdhtsjdj6+ddzcsjdj6+tysjdj6+syfysjdj6+sxfysjdj6
    i nextMonth=1 d
    .s Year=Year-1
}

ClassMethod GetBLSJSBTJBFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBLSJSBTJBExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {                // if there are no more rows, finish fetching
    Set AtEnd=1
    Set Row=""
 }
 Else {         
        Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod GetBLSJSBTJBClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBLSJSBTJBExecute ]
{
 
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// 住院跌倒按季度发生率统计
/// d ##class(%ResultSet).RunQuery("web.DHCNurSBDataNew","GetZYDDFSLYBAJD","2019","","168")
Query GetZYDDFSLYBAJD(Year As %String, LocId As %String, loc As %String) As %Query(ROWSPEC = "jddesc:%String,allPatNum:%Float,ddzcNum:%Float,rate:%Float,Year:%String") [ SqlProc ]
{
}

ClassMethod GetZYDDFSLYBAJDExecute(ByRef qHandle As %Binary, Year As %String, LocId As %String, loc As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set ind=1
    ;s ^Panxuefengtemp("GetZYDDFSLYBAJD")=Year_"^"_LocId_"^"_loc
    q:Year="" $$$OK

    i LocId'="" s LocId1=LocId
    e  s LocId1=##class(web.DHCNurblsjflwh).GetBtqxCtlocid(loc)
    
    s dyjd="01^02^03"
    s dejd="04^05^06"
    s dsjd1="07^08^09"
    s dsjd2="10^11^12"
    s allMonth=dyjd_"&"_dejd_"&"_dsjd1_"&"_dsjd2
    f Num=1:1:4 d
    .s allPatNum=0, ddzcNum=0,rate=0
    .s jd=$p(allMonth,"&",Num)
    .i jd="01^02^03" s jddesc="1季度"
    .i jd="04^05^06" s jddesc="2季度"
    .i jd="07^08^09" s jddesc="3季度"
    .i jd="10^11^12" s jddesc="4季度"
    .f Num1=1:1:3 d
    ..s Month=$p(jd,"^",Num1)
    ..s allPatMonNum=0
    ..d OutwardRowROwAJD2
    ..s allPatNum=allPatMonNum+allPatNum
    ..i allPatNum'=0 s rate=ddzcNum/allPatNum*1000
    ..e  s rate=0
    ..s rate=$fn(rate,"",2)
    .d OutwardRowAJD2
    Quit $$$OK

OutwardRowROwAJD2
    s YeaMonth=Year_"-"_Month
    s stDate=Year_"-"_Month_"-1"
    i Month="12" s endDate=(Year+1)_"-01-01"
    e  s endDate=Year_"-"_(+Month+1)_"-1"
    s allPatMonNum=##class(Nur.DHCNurSBData).GetMKPIByDate("K0029",YeaMonth,YeaMonth,"byMonth","","","","",LocId1)
    
    s locLen=$l(LocId1,"^")
    ;w stDate_","_endDate,!
    f locI=1:1:locLen {
        s locid=$p(LocId1,"^",locI)
        continue:locid=""
        f sttDate=$zdh(stDate,3):1:($zdh(endDate,3)-1) d
        .s rw="" f  s rw=$O(^Nur.DHCNurSBDataI("emdate",sttDate," DHCNURXHSB_DDZC",rw)) q:rw=""  d
        ..s a=##class(Nur.DHCNurSBData).%OpenId(rw)
        ..s Item1=a.Item1
        ..s Item195=$p(a.Item195,"!",1)
        ..s RecCancelUser=a.RecCancelUser
        ..q:RecCancelUser'=""
        ..s status=a.Status
        ..q:((status="C")||(status="V"))
        ..s LocDesc=$P($p(^CTLOC(locid),"^",2),"-",2)
        ..q:Item1'=LocDesc
        ..s ddzcNum=ddzcNum+1
        
        .//20190311
        .s rw="" f  s rw=$O(^Nur.DHCNurSBDataI("emdate",sttDate," DHCNURXHSB_DDZCN",rw)) q:rw=""  d
        ..s a=##class(Nur.DHCNurSBData).%OpenId(rw)
        ..s Item1=a.Item1
        ..s Item195=$p(a.Item69,"!",1)
        ..s RecCancelUser=a.RecCancelUser
        ..q:RecCancelUser'=""
        ..s status=a.Status
        ..q:((status="C")||(status="V"))
        ..s LocDesc=$P($p(^CTLOC(locid),"^",2),"-",2)
        ..q:Item1'=LocDesc
        ..s ddzcNum=ddzcNum+1
    }
    q
 
OutwardRowAJD2
    s Data=$LB(jddesc,allPatNum,ddzcNum,rate,Year)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod GetZYDDFSLYBAJDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetZYDDFSLYBAJDExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             
        Set AtEnd=1
        Set Row=""
    }
    Else      {             
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetZYDDFSLYBAJDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetZYDDFSLYBAJDExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 跌倒发生率按季度按科室统计
/// d ##class(%ResultSet).RunQuery("web.DHCNurSBDataNew","GetZYDDFSLYBAJDAKS","2019","","168")
Query GetZYDDFSLYBAJDAKS(Year As %String, loc As %String) As %Query(ROWSPEC = "locdesc:%String,jddesc:%String,allPatNum:%Float,ddzcNum:%Float,rate:%Float,Year:%String") [ SqlProc ]
{
}

ClassMethod GetZYDDFSLYBAJDAKSExecute(ByRef qHandle As %Binary, Year As %String, loc As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set ind=1
    ;s ^Panxuefengtemp("GetZYDDFSLYBAJDAKS")=Year_"^"_loc
    q:Year="" $$$OK
    s dyjd="01^02^03"
    s dejd="04^05^06"
    s dsjd1="07^08^09"
    s dsjd2="10^11^12"
    s allMonth=dyjd_"&"_dejd_"&"_dsjd1_"&"_dsjd2
    s allPatNum=0, ddzcNum=0,rate=0
    
    s AllLocId1=##class(web.DHCNurblsjflwh).GetBtqxCtlocid(loc)
    s long1=$l(AllLocId1,"^")
    f num1=2:1:long1 d
    .s LocId1=$p(AllLocId1,"^",num1)
    .s locdesc=$p(^CTLOC(LocId1),"^",2)
    .s locdesc=$p(locdesc,"-",2)
    .f Num=1:1:4 d
    ..s allPatNum=0, ddzcNum=0,rate=0
    ..s jd=$p(allMonth,"&",Num)
    ..i jd="01^02^03" s jddesc="1季度"
    ..i jd="04^05^06" s jddesc="2季度"
    ..i jd="07^08^09" s jddesc="3季度"
    ..i jd="10^11^12" s jddesc="4季度"
    ..f Num1=1:1:3 d
    ...s Month=$p(jd,"^",Num1)
    ...s allPatMonNum=0
    ...d OutwardRowROwAJDAKS3
    ...s allPatNum=allPatMonNum+allPatNum
    ...i allPatNum'=0 s rate=ddzcNum/allPatNum*1000
    ...e  s rate=0
    ..q:(allPatNum="")||(allPatNum="0")
    ..q:(locdesc["门诊")
    ..d OutwardRowAJDAKS3
    Quit $$$OK

OutwardRowROwAJDAKS3
    s YeaMonth=Year_"-"_Month
    s stDate=Year_"-"_Month_"-1"
    i Month="12" s endDate=(Year+1)_"-01-01"
    e  s endDate=Year_"-"_(+Month+1)_"-1"
    s allPatMonNum=##class(Nur.DHCNurSBData).GetMKPIByDate("K0029",YeaMonth,YeaMonth,"byMonth","","","","",LocId1)
    
    s locLen=$l(LocId1,"^")
    ;w stDate_","_endDate,!
    f locI=1:1:locLen {
        s locid=$p(LocId1,"^",locI)
        continue:locid=""
        f sttDate=$zdh(stDate,3):1:($zdh(endDate,3)-1) d
        .s rw="" f  s rw=$O(^Nur.DHCNurSBDataI("emdate",sttDate," DHCNURXHSB_DDZC",rw)) q:rw=""  d
        ..s a=##class(Nur.DHCNurSBData).%OpenId(rw)
        ..s Item1=a.Item1
        ..s Item195=$p(a.Item195,"!",1)
        ..s RecCancelUser=a.RecCancelUser
        ..q:RecCancelUser'=""
        ..s status=a.Status
        ..q:((status="C")||(status="V"))
        ..s LocDesc=$P($p(^CTLOC(locid),"^",2),"-",2)
        ..q:Item1'=LocDesc
        ..s ddzcNum=ddzcNum+1
        
        .//20190311
        .s rw="" f  s rw=$O(^Nur.DHCNurSBDataI("emdate",sttDate," DHCNURXHSB_DDZCN",rw)) q:rw=""  d
        ..s a=##class(Nur.DHCNurSBData).%OpenId(rw)
        ..s Item1=a.Item1
        ..s Item195=$p(a.Item195,"!",1)
        ..s RecCancelUser=a.RecCancelUser
        ..q:RecCancelUser'=""
        ..s status=a.Status
        ..q:((status="C")||(status="V"))
        ..s LocDesc=$P($p(^CTLOC(locid),"^",2),"-",2)
        ..q:Item1'=LocDesc
        ..s ddzcNum=ddzcNum+1
    }
    q
 
OutwardRowAJDAKS3
    s Data=$LB(locdesc,jddesc,allPatNum,ddzcNum,rate,Year)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod GetZYDDFSLYBAJDAKSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetZYDDFSLYBAJDAKSExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             
        Set AtEnd=1
        Set Row=""
    }
    Else      {             
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetZYDDFSLYBAJDAKSClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetZYDDFSLYBAJDAKSExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 各年同月院内跌倒发生率统计
/// d ##class(%ResultSet).RunQuery("web.DHCNurSBDataNew","GetZYDDFSLYB","2019","","","168")
Query GetZYDDFSLYB(Year As %String, Month As %String, LocId As %String, loc As %String) As %Query(ROWSPEC = "Month:%String,allPatNum:%Float,ddzcNum:%Float,ddzcgwNum:%Float,ddzcyshNum:%Float,rate:%Float,Year:%String,ddzcYJ:%Float,ddzcEJ:%Float,ddzcSJ:%Float,ddzcSW:%Float,ddzcWSH:%Float") [ SqlProc ]
{
}

ClassMethod GetZYDDFSLYBExecute(ByRef qHandle As %Binary, Year As %String, Month As %String, LocId As %String, loc As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set ind=1
    ;s ^Panxuefengtemp("GetZYDDFSLYB")=Year_"^"_loc
    q:Year="" $$$OK
    s allMonth="01^02^03^04^05^06^07^08^09^10^11^12"
    
    
    i LocId'="" s LocId1=LocId
    e  s LocId1=##class(web.DHCNurblsjflwh).GetBtqxCtlocid(loc)
    
    
    i Month'="" d
    .s allPatNum=0, ddzcNum=0,ddzcgwNum=0,ddzcyshNum=0,rate=0,ddzcYJ=0,ddzcEJ=0,ddzcSJ=0,ddzcSW=0,ddzcWSH=0
    .d OutwardRowROw4
    .d OutwardRow4
    e  d
    .f Num=1:1:12 d
    ..s allPatNum=0, ddzcNum=0,ddzcgwNum=0,ddzcyshNum=0,rate=0,ddzcYJ=0,ddzcEJ=0,ddzcSJ=0,ddzcSW=0,ddzcWSH=0
    ..s Month=$p(allMonth,"^",Num)
    ..d OutwardRowROw4
    ..d OutwardRow4
    Quit $$$OK
OutwardRowROw4
    s YeaMonth=Year_"-"_Month
    s stDate=Year_"-"_Month_"-1"
    i Month="12" s endDate=(Year+1)_"-01-01"
    e  s endDate=Year_"-"_(+Month+1)_"-1"
    s allPatNum=##class(Nur.DHCNurSBData).GetMKPIByDate("K0029",YeaMonth,YeaMonth,"byMonth","","","","",LocId1)
    
    s locLen=$l(LocId1,"^")
    ;w stDate_","_endDate,!
    f locI=1:1:locLen {
        s locid=$p(LocId1,"^",locI)
        continue:locid=""
        f sttDate=$zdh(stDate,3):1:($zdh(endDate,3)-1) d
        .s rw="" f  s rw=$O(^Nur.DHCNurSBDataI("emdate",sttDate," DHCNURXHSB_DDZC",rw)) q:rw=""  d
        ..s a=##class(Nur.DHCNurSBData).%OpenId(rw)
        ..s Item1=a.Item1
        ..s Item195=$p(a.Item195,"!",1)
        ..s RecCancelUser=a.RecCancelUser
        ..q:RecCancelUser'=""
        ..s status=a.Status
        ..q:((status="C")||(status="V"))
        ..s LocDesc=$P($p(^CTLOC(locid),"^",2),"-",2)
        ..q:Item1'=LocDesc
        ..s ddzcNum=ddzcNum+1
        ..i Item195="1级" s ddzcYJ=ddzcYJ+1
        ..i Item195="2级" s ddzcEJ=ddzcEJ+1
        ..i Item195="3级" s ddzcSJ=ddzcSJ+1
        ..i Item195="死亡" s ddzcSW=ddzcSW+1
        ..i Item195="无伤害" s ddzcWSH=ddzcWSH+1
        ..i Item195'="无伤害" s ddzcyshNum=ddzcyshNum+1
        .s rw="" f  s rw=$O(^Nur.DHCNurSBDataI("emdate",sttDate," DHCNURBG_DDZCGWSBB",rw)) q:rw=""  d
        ..s a=##class(Nur.DHCNurSBData).%OpenId(rw)
        ..s Item1=a.Item1
        ..s RecCancelUser=a.RecCancelUser
        ..q:RecCancelUser'=""
        ..s status=a.Status
        ..q:((status="C")||(status="V"))
        ..s LocDesc=$P($p(^CTLOC(locid),"^",2),"-",2)
        ..q:Item1'=LocDesc
        ..s ddzcgwNum=ddzcgwNum+1
        
        .//20190311
        .s rw="" f  s rw=$O(^Nur.DHCNurSBDataI("emdate",sttDate," DHCNURXHSB_DDZCN",rw)) q:rw=""  d
        ..s a=##class(Nur.DHCNurSBData).%OpenId(rw)
        ..s Item1=a.Item1
        ..s Item195=$p(a.Item69,"!",1)
        ..s RecCancelUser=a.RecCancelUser
        ..q:RecCancelUser'=""
        ..s status=a.Status
        ..q:((status="C")||(status="V"))
        ..s LocDesc=$P($p(^CTLOC(locid),"^",2),"-",2)
        ..q:Item1'=LocDesc
        ..s ddzcNum=ddzcNum+1
        ..i Item195="1级" s ddzcYJ=ddzcYJ+1
        ..i Item195="2级" s ddzcEJ=ddzcEJ+1
        ..i Item195="3级" s ddzcSJ=ddzcSJ+1
        ..i Item195="死亡" s ddzcSW=ddzcSW+1
        ..i Item195="无伤害" s ddzcWSH=ddzcWSH+1
        ..i Item195'="无伤害" s ddzcyshNum=ddzcyshNum+1
        
        /*
        .s rw="" f  s rw=$O(^Nur.DHCNurSBDataI("emdate",sttDate," DHCNURXHSB_DDZC",rw)) q:rw=""  d
        ..s a=##class(Nur.DHCNurSBData).%OpenId(rw)
        ..s Item1=a.Item1
        ..s Item195=$p(a.Item195,"!",1)
        ..s RecCancelUser=a.RecCancelUser
        ..q:RecCancelUser'=""
        ..s status=a.Status
        ..q:((status="C")||(status="V"))
        ..s LocDesc=$P($p(^CTLOC(locid),"^",2),"-",2)
        ..q:Item1'=LocDesc
        ..q:Item195="无伤害"
        ..s ddzcyshNum=ddzcyshNum+1
        */
    }
    
    i allPatNum'=0 s rate=ddzcNum/allPatNum*1000
    e  s rate=0
    q
 
OutwardRow4
    s Data=$LB(Month,allPatNum,ddzcNum,ddzcgwNum,ddzcyshNum,rate,Year,ddzcYJ,ddzcEJ,ddzcSJ,ddzcSW,ddzcWSH)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod GetZYDDFSLYBFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetZYDDFSLYBExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             
        Set AtEnd=1
        Set Row=""
    }
    Else      {             
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetZYDDFSLYBClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetZYDDFSLYBExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 另一年同月院内跌倒发生率统计
/// d ##class(%ResultSet).RunQuery("web.DHCNurSBDataNew","GetZYDDFSLYBOther","2018","","","168")
Query GetZYDDFSLYBOther(Year As %String, Month As %String, LocId As %String, loc As %String) As %Query(ROWSPEC = "Month:%String,allPatNum:%Float,ddzcNum:%Float,ddzcgwNum:%Float,ddzcyshNum:%Float,rate:%Float,Year:%String,ddzcYJ:%Float,ddzcEJ:%Float,ddzcSJ:%Float,ddzcSW:%Float,ddzcWSH:%Float") [ SqlProc ]
{
}

ClassMethod GetZYDDFSLYBOtherExecute(ByRef qHandle As %Binary, Year As %String, Month As %String, LocId As %String, loc As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set ind=1
    ;s ^Panxuefengtemp("GetZYDDFSLYB")=Year_"^"_loc
    q:Year="" $$$OK
    s allMonth="01^02^03^04^05^06^07^08^09^10^11^12"
    
    
    i LocId'="" s LocId1=LocId
    e  s LocId1=##class(web.DHCNurblsjflwh).GetBtqxCtlocid(loc)
    
    
    i Month'="" d
    .s allPatNum=0, ddzcNum=0,ddzcgwNum=0,ddzcyshNum=0,rate=0,ddzcYJ=0,ddzcEJ=0,ddzcSJ=0,ddzcSW=0,ddzcWSH=0
    .d OutwardRowROwOther5
    .d OutwardRowOther5
    e  d
    .f Num=1:1:12 d
    ..s allPatNum=0, ddzcNum=0,ddzcgwNum=0,ddzcyshNum=0,rate=0,ddzcYJ=0,ddzcEJ=0,ddzcSJ=0,ddzcSW=0,ddzcWSH=0
    ..s Month=$p(allMonth,"^",Num)
    ..d OutwardRowROwOther5
    ..d OutwardRowOther5
    Quit $$$OK

OutwardRowROwOther5
    s YeaMonth=Year_"-"_Month
    s stDate=Year_"-"_Month_"-1"
    i Month="12" s endDate=(Year+1)_"-01-01"
    e  s endDate=Year_"-"_(+Month+1)_"-1"
    s allPatNum=##class(Nur.DHCNurSBData).GetMKPIByDate("K0029",YeaMonth,YeaMonth,"byMonth","","","","",LocId1)
    
    s locLen=$l(LocId1,"^")
    ;w stDate_","_endDate,!
    f locI=1:1:locLen {
        s locid=$p(LocId1,"^",locI)
        continue:locid=""
        f sttDate=$zdh(stDate,3):1:($zdh(endDate,3)-1) d
        .s rw="" f  s rw=$O(^Nur.DHCNurSBDataI("emdate",sttDate," DHCNURXHSB_DDZC",rw)) q:rw=""  d
        ..s a=##class(Nur.DHCNurSBData).%OpenId(rw)
        ..s Item1=a.Item1
        ..s Item195=$p(a.Item195,"!",1)
        ..s RecCancelUser=a.RecCancelUser
        ..q:RecCancelUser'=""
        ..s status=a.Status
        ..q:((status="C")||(status="V"))
        ..s LocDesc=$P($p(^CTLOC(locid),"^",2),"-",2)
        ..q:Item1'=LocDesc
        ..s ddzcNum=ddzcNum+1
        ..i Item195="1级" s ddzcYJ=ddzcYJ+1
        ..i Item195="2级" s ddzcEJ=ddzcEJ+1
        ..i Item195="3级" s ddzcSJ=ddzcSJ+1
        ..i Item195="死亡" s ddzcSW=ddzcSW+1
        ..i Item195="无伤害" s ddzcWSH=ddzcWSH+1
        ..i Item195'="无伤害" s ddzcyshNum=ddzcyshNum+1
        
        .//20190311
        .s rw="" f  s rw=$O(^Nur.DHCNurSBDataI("emdate",sttDate," DHCNURXHSB_DDZCN",rw)) q:rw=""  d
        ..s a=##class(Nur.DHCNurSBData).%OpenId(rw)
        ..s Item1=a.Item1
        ..s Item195=$p(a.Item195,"!",1)
        ..s RecCancelUser=a.RecCancelUser
        ..q:RecCancelUser'=""
        ..s status=a.Status
        ..q:((status="C")||(status="V"))
        ..s LocDesc=$P($p(^CTLOC(locid),"^",2),"-",2)
        ..q:Item1'=LocDesc
        ..s ddzcNum=ddzcNum+1
        ..i Item195="1级" s ddzcYJ=ddzcYJ+1
        ..i Item195="2级" s ddzcEJ=ddzcEJ+1
        ..i Item195="3级" s ddzcSJ=ddzcSJ+1
        ..i Item195="死亡" s ddzcSW=ddzcSW+1
        ..i Item195="无伤害" s ddzcWSH=ddzcWSH+1
        ..i Item195'="无伤害" s ddzcyshNum=ddzcyshNum+1
        
        .s rw="" f  s rw=$O(^Nur.DHCNurSBDataI("emdate",sttDate," DHCNURBG_DDZCGWSBB",rw)) q:rw=""  d
        ..s a=##class(Nur.DHCNurSBData).%OpenId(rw)
        ..s Item1=a.Item1
        ..s RecCancelUser=a.RecCancelUser
        ..q:RecCancelUser'=""
        ..s status=a.Status
        ..q:((status="C")||(status="V"))
        ..s LocDesc=$P($p(^CTLOC(locid),"^",2),"-",2)
        ..q:Item1'=LocDesc
        ..s ddzcgwNum=ddzcgwNum+1
        
        /*
        .s rw="" f  s rw=$O(^Nur.DHCNurSBDataI("emdate",sttDate," DHCNURXHSB_DDZC",rw)) q:rw=""  d
        ..s a=##class(Nur.DHCNurSBData).%OpenId(rw)
        ..s Item1=a.Item1
        ..s Item195=$p(a.Item195,"!",1)
        ..s RecCancelUser=a.RecCancelUser
        ..q:RecCancelUser'=""
        ..s status=a.Status
        ..q:((status="C")||(status="V"))
        ..s LocDesc=$P($p(^CTLOC(locid),"^",2),"-",2)
        ..q:Item1'=LocDesc
        ..q:Item195="无伤害"
        ..s ddzcyshNum=ddzcyshNum+1
        */
    }
    
    i allPatNum'=0 s rate=ddzcNum/allPatNum*1000
    e  s rate=0
    Quit $$$OK

 
OutwardRowOther5
    s Data=$LB(Month,allPatNum,ddzcNum,ddzcgwNum,ddzcyshNum,rate,Year,ddzcYJ,ddzcEJ,ddzcSJ,ddzcSW,ddzcWSH)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod GetZYDDFSLYBOtherFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetZYDDFSLYBOtherExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             
        Set AtEnd=1
        Set Row=""
    }
    Else      {             
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetZYDDFSLYBOtherClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetZYDDFSLYBOtherExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 按季度压疮发生率统计
/// d ##class(%ResultSet).RunQuery("web.DHCNurSBDataNew","GetZYYCFSRSTJBBAJD","2019","","168")
Query GetZYYCFSRSTJBBAJD(Year As %String, LocId As %String, loc As %String) As %Query(ROWSPEC = "Year:%String,jd:%String,MonthAllNum:%Float,rate:%Float,ynycall:%Float") [ SqlProc ]
{
}

ClassMethod GetZYYCFSRSTJBBAJDExecute(ByRef qHandle As %Binary, Year As %String, LocId As %String, loc As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set ind=1
    ;s ^Panxuefengtemp("GetZYDDFSLYB")=Year_"^"_loc
    q:Year="" $$$OK
    s dyjd="01^02^03"
    s dejd="04^05^06"
    s dsjd1="07^08^09"
    s dsjd2="10^11^12"
    s allMonth=dyjd_"&"_dejd_"&"_dsjd1_"&"_dsjd2
    s lastMonthNum=0,thisMonthNum=0,ynycall=0,pfyc=0,nbmyc=0
    i LocId'="" d
    .f Num=1:1:4 d
    ..s ynycall=0,pfyc=0,nbmyc=0,jdnum=0,MonthAllNum=0
    ..s jd=$p(allMonth,"&",Num)
    ..i jd="01^02^03" s jddesc="1季度"
    ..i jd="04^05^06" s jddesc="2季度"
    ..i jd="07^08^09" s jddesc="3季度"
    ..i jd="10^11^12" s jddesc="4季度"
    ..f Num1=1:1:3 d
    ...s Month=$p(jd,"^",Num1)
    ...s LocId1=LocId
    ...s MonthksNum=0
    ...d OutwardRowROw6
    ...s MonthAllNum=MonthksNum+MonthAllNum
    ...i MonthAllNum'=0 s rate=ynycall/MonthAllNum*100
    ...e  s rate=0
    ..d OutwardRow6
    i LocId="" d
    .f Num=1:1:4 d
    ..s ynycall=0,pfyc=0,nbmyc=0,jdnum=0,MonthAllNum=0
    ..s jd=$p(allMonth,"&",Num)
    ..i jd="01^02^03" s jddesc="1季度"
    ..i jd="04^05^06" s jddesc="2季度"
    ..i jd="07^08^09" s jddesc="3季度"
    ..i jd="10^11^12" s jddesc="4季度"
    ..f Num1=1:1:3 d
    ...s Month=$p(jd,"^",Num1)
    ...s AllLocId1=##class(web.DHCNurblsjflwh).GetBtqxCtlocid(loc)
    ...s long1=$l(AllLocId1,"^")
    ...f num1=2:1:long1 d
    ....s LocId1=$p(AllLocId1,"^",num1)
    ....s MonthksNum=0
    ....d OutwardRowROw6
    ....s MonthAllNum=MonthksNum+MonthAllNum
    ....i MonthAllNum'=0 s rate=ynycall/MonthAllNum*100
    ....e  s rate=0
    ..d OutwardRow6
    Quit $$$OK

OutwardRowROw6
    s Date=Year_"-"_Month_"-"_"1"
    s lastendDate=$zdh(Date,3)-1
    s nextMonth=Month+1
    i nextMonth=13  d 
    .s Year=Year+1 
    .s nextMonth=1
    s endDate=Year_"-"_nextMonth_"-"_"1"
    s lastMonthNum=0
    s thisMonthNum=0
    s MRIProwid=0 f  s MRIProwid=$o(^MRIPdaily("MRIP_DATE",lastendDate,MRIProwid)) q:MRIProwid=""  d
    .s lastdayNum=$p($g(^MRIPdaily(MRIProwid)),"^",13)
    .s MRIPlocdr=$p($g(^MRIPdaily(MRIProwid)),"^",7)
    .q:(LocId1'="")&&(MRIPlocdr'=LocId1)
    .s lastMonthNum=lastMonthNum+lastdayNum
    f sttDate=$zdh(Date,3):1:($zdh(endDate,3)-1) d
    .s MRIProwid1="" f  s MRIProwid1=$o(^MRIPdaily("MRIP_DATE",sttDate,MRIProwid1)) q:MRIProwid1=""  d
    ..s ytrsNum=0
    ..s ytrsNum=$p($g(^MRIPdaily(MRIProwid1)),"^",8)
    ..s MRIPlocdr=$p($g(^MRIPdaily(MRIProwid1)),"^",7)
    ..q:(LocId1'="")&&(MRIPlocdr'=LocId1)
    ..s thisMonthNum=thisMonthNum+ytrsNum
    //s stDate="" f  s stDate=$o(^PAADMi("DepDateTime",LocId1,stDate))  q:stDate=""  d
    //.q:stDate>lastendDate
    //.s stTime=""  f  s stTime=$o(^PAADMi("DepDateTime",LocId1,stDate,stTime)) q:stTime=""  d
    //..s Episodeid="" f  s Episodeid=$o(^PAADMi("DepDateTime",LocId1,stDate,stTime,Episodeid))  q:Episodeid=""  d
    //...s DisDate=$p(^PAADM(Episodeid),"^",17)
    //...q:(DisDate<=lastendDate)&&(DisDate'="")
    //...s lastMonthNum=lastMonthNum+1
    //s stDate2="" f  s stDate2=$o(^PAADMi("DepDateTime",LocId1,stDate2))  q:stDate2=""  d
    //.s stDate22=$zd(stDate2,3)
    //.q:Year'=$p(stDate22,"-",1)
    //.q:Month'=$p(stDate22,"-",2)
    //.s stTime2=""  f  s stTime2=$o(^PAADMi("DepDateTime",LocId1,stDate2,stTime2)) q:stTime2=""  d
    //..s Episodeid2="" f  s Episodeid2=$o(^PAADMi("DepDateTime",LocId1,stDate2,stTime2,Episodeid2))  q:Episodeid2=""  d
    //...s thisMonthNum=thisMonthNum+1
    s MonthksNum=lastMonthNum+thisMonthNum
    //s MonthAllNum=MonthAllNum/2
    f sttDate=$zdh(Date,3):1:($zdh(endDate,3)-1) d
    .;b ;888
    .s rw="" f  s rw=$O(^Nur.DHCNurSBDataI("emdate",sttDate," DHCNURXHSB_PF",rw)) q:rw=""  d
    ..s a=##class(Nur.DHCNurSBData).%OpenId(rw)
    ..s Item1=a.Item1
    ..s RecCancelUser=a.RecCancelUser
    ..s status=a.Status
    ..q:((status="C")||(status="V"))
    ..q:RecCancelUser'=""
    ..s LocDesc=$P($p(^CTLOC(LocId1),"^",2),"-",2)
    ..q:Item1'=LocDesc
    ..s pfyc=pfyc+1
    
    .///20190311
    .s rw="" f  s rw=$O(^Nur.DHCNurSBDataI("emdate",sttDate," DHCNURXHSB_PFN",rw)) q:rw=""  d
    ..s a=##class(Nur.DHCNurSBData).%OpenId(rw)
    ..s Item1=a.Item1
    ..s RecCancelUser=a.RecCancelUser
    ..s status=a.Status
    ..q:((status="C")||(status="V"))
    ..q:RecCancelUser'=""
    ..s LocDesc=$P($p(^CTLOC(LocId1),"^",2),"-",2)
    ..q:Item1'=LocDesc
    ..s pfyc=pfyc+1
    .s rw="" f  s rw=$O(^Nur.DHCNurSBDataI("emdate",sttDate," DHCNURPGD_NMYSBB",rw)) q:rw=""  d
    ..s a=##class(Nur.DHCNurSBData).%OpenId(rw)
    ..s Item1=a.Item1
    ..s RecCancelUser=a.RecCancelUser
    ..s status=a.Status
    ..q:((status="C")||(status="V"))
    ..q:RecCancelUser'=""
    ..s LocDesc=$P($p(^CTLOC(LocId1),"^",2),"-",2)
    ..q:Item1'=LocDesc
    ..s nbmyc=nbmyc+1
    i nextMonth=1 d
    .s Year=Year-1 
    s ynycall=pfyc+nbmyc
    i MonthAllNum'=0 s rate=ynycall/MonthAllNum*100
    e  s rate=0
    q
OutwardRow6
    s Data=$LB(Year,jddesc,MonthAllNum,rate,ynycall)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod GetZYYCFSRSTJBBAJDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetZYYCFSRSTJBBAJDExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             
        Set AtEnd=1
        Set Row=""
    }
    Else      {             
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetZYYCFSRSTJBBAJDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetZYYCFSRSTJBBAJDExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 科室按季度压疮发生率统计
/// d ##class(%ResultSet).RunQuery("web.DHCNurSBDataNew","GetLocquaFsl","2019","","168")
Query GetLocquaFsl(Year As %String, loc As %String) As %Query(ROWSPEC = "Year:%String,locdesc:%String,jd:%String,MonthAllNum:%Float,rate:%Float,ynycall:%Float") [ SqlProc ]
{
}

ClassMethod GetLocquaFslExecute(ByRef qHandle As %Binary, Year As %String, loc As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set ind=1
    ;s ^Panxuefengtemp("GetLocquaFsl")=Year_"^"_loc
    q:Year="" $$$OK
    s dyjd="01^02^03"
    s dejd="04^05^06"
    s dsjd1="07^08^09"
    s dsjd2="10^11^12"
    s allMonth=dyjd_"&"_dejd_"&"_dsjd1_"&"_dsjd2
    s lastMonthNum=0,thisMonthNum=0,ynycall=0,pfyc=0,nbmyc=0
    
    s AllLocId1=##class(web.DHCNurblsjflwh).GetBtqxCtlocid(loc)
    s long1=$l(AllLocId1,"^")
    f num1=2:1:long1 d
    .s LocId1=$p(AllLocId1,"^",num1)
    .s locdesc=$p(^CTLOC(LocId1),"^",2)
    .s locdesc=$p(locdesc,"-",2)
    .f Num=1:1:4 d
    ..s lastMonthNum=0,thisMonthNum=0,ynycall=0,pfyc=0,nbmyc=0,MonthAllNum=0
    ..s jd=$p(allMonth,"&",Num)
    ..i jd="01^02^03" s jddesc="1季度"
    ..i jd="04^05^06" s jddesc="2季度"
    ..i jd="07^08^09" s jddesc="3季度"
    ..i jd="10^11^12" s jddesc="4季度"
    ..f Num1=1:1:3 d
    ...s Month=$p(jd,"^",Num1)
    ...s MonthksNum=0
    ...d OutwardRowROw7
    ...s MonthAllNum=MonthksNum+MonthAllNum
    ...i MonthAllNum'=0 s rate=ynycall/MonthAllNum*100
    ...e  s rate=0
    ..q:(MonthAllNum="")||(MonthAllNum="0")
    ..q:(locdesc["门诊")
    ..d OutwardRow7
    Quit $$$OK

OutwardRowROw7
    s Date=Year_"-"_Month_"-"_"1"
    s lastendDate=$zdh(Date,3)-1
    s nextMonth=Month+1
    i nextMonth=13  d 
    .s Year=Year+1 
    .s nextMonth=1
    s endDate=Year_"-"_nextMonth_"-"_"1"
    s lastMonthNum=0
    s thisMonthNum=0
    s MRIProwid=0 f  s MRIProwid=$o(^MRIPdaily("MRIP_DATE",lastendDate,MRIProwid)) q:MRIProwid=""  d
    .s lastdayNum=$p($g(^MRIPdaily(MRIProwid)),"^",13)
    .s MRIPlocdr=$p($g(^MRIPdaily(MRIProwid)),"^",7)
    .q:(LocId1'="")&&(MRIPlocdr'=LocId1)
    .s lastMonthNum=lastMonthNum+lastdayNum
    f sttDate=$zdh(Date,3):1:($zdh(endDate,3)-1) d
    .s MRIProwid1="" f  s MRIProwid1=$o(^MRIPdaily("MRIP_DATE",sttDate,MRIProwid1)) q:MRIProwid1=""  d
    ..s ytrsNum=0
    ..s ytrsNum=$p($g(^MRIPdaily(MRIProwid1)),"^",8)
    ..s MRIPlocdr=$p($g(^MRIPdaily(MRIProwid1)),"^",7)
    ..q:(LocId1'="")&&(MRIPlocdr'=LocId1)
    ..s thisMonthNum=thisMonthNum+ytrsNum
    //s stDate="" f  s stDate=$o(^PAADMi("DepDateTime",LocId1,stDate))  q:stDate=""  d
    //.q:stDate>lastendDate
    //.s stTime=""  f  s stTime=$o(^PAADMi("DepDateTime",LocId1,stDate,stTime)) q:stTime=""  d
    //..s Episodeid="" f  s Episodeid=$o(^PAADMi("DepDateTime",LocId1,stDate,stTime,Episodeid))  q:Episodeid=""  d
    //...s DisDate=$p(^PAADM(Episodeid),"^",17)
    //...q:(DisDate<=lastendDate)&&(DisDate'="")
    //...s lastMonthNum=lastMonthNum+1
    //s stDate2="" f  s stDate2=$o(^PAADMi("DepDateTime",LocId1,stDate2))  q:stDate2=""  d
    //.s stDate22=$zd(stDate2,3)
    //.q:Year'=$p(stDate22,"-",1)
    //.q:Month'=$p(stDate22,"-",2)
    //.s stTime2=""  f  s stTime2=$o(^PAADMi("DepDateTime",LocId1,stDate2,stTime2)) q:stTime2=""  d
    //..s Episodeid2="" f  s Episodeid2=$o(^PAADMi("DepDateTime",LocId1,stDate2,stTime2,Episodeid2))  q:Episodeid2=""  d
    //...s thisMonthNum=thisMonthNum+1
    s MonthksNum=lastMonthNum+thisMonthNum
    //s MonthAllNum=MonthAllNum/2
    f sttDate=$zdh(Date,3):1:($zdh(endDate,3)-1) d
    .;b ;888
    .s rw="" f  s rw=$O(^Nur.DHCNurSBDataI("emdate",sttDate," DHCNURXHSB_PF",rw)) q:rw=""  d
    ..s a=##class(Nur.DHCNurSBData).%OpenId(rw)
    ..s Item1=a.Item1
    ..s RecCancelUser=a.RecCancelUser
    ..s status=a.Status
    ..q:((status="C")||(status="V"))
    ..q:RecCancelUser'=""
    ..s LocDesc=$P($p(^CTLOC(LocId1),"^",2),"-",2)
    ..q:Item1'=LocDesc
    ..s pfyc=pfyc+1
    
    .//20190311
    .s rw="" f  s rw=$O(^Nur.DHCNurSBDataI("emdate",sttDate," DHCNURXHSB_PFN",rw)) q:rw=""  d
    ..s a=##class(Nur.DHCNurSBData).%OpenId(rw)
    ..s Item1=a.Item1
    ..s RecCancelUser=a.RecCancelUser
    ..s status=a.Status
    ..q:((status="C")||(status="V"))
    ..q:RecCancelUser'=""
    ..s LocDesc=$P($p(^CTLOC(LocId1),"^",2),"-",2)
    ..q:Item1'=LocDesc
    ..s pfyc=pfyc+1
    .s rw="" f  s rw=$O(^Nur.DHCNurSBDataI("emdate",sttDate," DHCNURPGD_NMYSBB",rw)) q:rw=""  d
    ..s a=##class(Nur.DHCNurSBData).%OpenId(rw)
    ..s Item1=a.Item1
    ..s RecCancelUser=a.RecCancelUser
    ..s status=a.Status
    ..q:((status="C")||(status="V"))
    ..q:RecCancelUser'=""
    ..s LocDesc=$P($p(^CTLOC(LocId1),"^",2),"-",2)
    ..q:Item1'=LocDesc
    ..s nbmyc=nbmyc+1
    i nextMonth=1 d
    .s Year=Year-1 
    s ynycall=pfyc+nbmyc
    i MonthAllNum'=0 s rate=ynycall/MonthAllNum*100
    e  s rate=0
    q
OutwardRow7
    s Data=$LB(Year,locdesc,jddesc,MonthAllNum,rate,ynycall)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod GetLocquaFslFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocquaFslExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             
        Set AtEnd=1
        Set Row=""
    }
    Else      {             
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetLocquaFslClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocquaFslExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 各年同月院内压疮发生率统计
/// d ##class(%ResultSet).RunQuery("web.DHCNurSBDataNew","GetEachYearSameMonthrate","2019","","168")
Query GetEachYearSameMonthrate(Year As %String, LocId As %String, loc As %String) As %Query(ROWSPEC = "Year:%String,Month:%String,MonthAllNum:%Float,rate:%Float,ynycall:%Float") [ SqlProc ]
{
}

ClassMethod GetEachYearSameMonthrateExecute(ByRef qHandle As %Binary, Year As %String, LocId As %String, loc As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set ind=1
    ;s ^Panxuefengtemp("GetEachYearSameMonthrate")=Year_"^"_loc
    q:Year="" $$$OK
    s AllMonth="01^02^03^04^05^06^07^08^09^10^11^12"
    s lastMonthNum=0,thisMonthNum=0,ynycall=0,pfyc=0,nbmyc=0
    i LocId'="" d
    .f Num1=1:1:12 d
    ..s lastMonthNum=0,thisMonthNum=0,ynycall=0,pfyc=0,nbmyc=0,MonthAllNum=0
    ..s Month=$p(AllMonth,"^",Num1)
    ..s LocId1=LocId
    ..s MonthksNum=0
    ..d OutwardRowROw8
    ..s MonthAllNum=MonthksNum+MonthAllNum
    ..i MonthAllNum'=0 s rate=ynycall/MonthAllNum*100
    ..e  s rate=0
    ..d OutwardRow8
    i LocId="" d
    .f Num1=1:1:12 d
    ..s lastMonthNum=0,thisMonthNum=0,ynycall=0,pfyc=0,nbmyc=0,MonthAllNum=0
    ..s Month=$p(AllMonth,"^",Num1)
    ..s AllLocId1=##class(web.DHCNurblsjflwh).GetBtqxCtlocid(loc)
    ..s long1=$l(AllLocId1,"^")
    ..f num1=2:1:long1 d
    ...s LocId1=$p(AllLocId1,"^",num1)
    ...s MonthksNum=0
    ...d OutwardRowROw8
    ...s MonthAllNum=MonthksNum+MonthAllNum
    ...i MonthAllNum'=0 s rate=ynycall/MonthAllNum*100
    ...e  s rate=0
    ..d OutwardRow8
    Quit $$$OK

OutwardRowROw8
    s Date=Year_"-"_Month_"-"_"1"
    s lastendDate=$zdh(Date,3)-1
    s nextMonth=Month+1
    i nextMonth=13  d 
    .s Year=Year+1 
    .s nextMonth=1
    s endDate=Year_"-"_nextMonth_"-"_"1"
    s lastMonthNum=0
    s thisMonthNum=0
    s MRIProwid=0 f  s MRIProwid=$o(^MRIPdaily("MRIP_DATE",lastendDate,MRIProwid)) q:MRIProwid=""  d
    .s lastdayNum=$p($g(^MRIPdaily(MRIProwid)),"^",13)
    .s MRIPlocdr=$p($g(^MRIPdaily(MRIProwid)),"^",7)
    .q:(LocId1'="")&&(MRIPlocdr'=LocId1)
    .s lastMonthNum=lastMonthNum+lastdayNum
    f sttDate=$zdh(Date,3):1:($zdh(endDate,3)-1) d
    .s MRIProwid1="" f  s MRIProwid1=$o(^MRIPdaily("MRIP_DATE",sttDate,MRIProwid1)) q:MRIProwid1=""  d
    ..s ytrsNum=0
    ..s ytrsNum=$p($g(^MRIPdaily(MRIProwid1)),"^",8)
    ..s MRIPlocdr=$p($g(^MRIPdaily(MRIProwid1)),"^",7)
    ..q:(LocId1'="")&&(MRIPlocdr'=LocId1)
    ..s thisMonthNum=thisMonthNum+ytrsNum
    //s stDate="" f  s stDate=$o(^PAADMi("DepDateTime",LocId1,stDate))  q:stDate=""  d
    //.q:stDate>lastendDate
    //.s stTime=""  f  s stTime=$o(^PAADMi("DepDateTime",LocId1,stDate,stTime)) q:stTime=""  d
    //..s Episodeid="" f  s Episodeid=$o(^PAADMi("DepDateTime",LocId1,stDate,stTime,Episodeid))  q:Episodeid=""  d
    //...s DisDate=$p(^PAADM(Episodeid),"^",17)
    //...q:(DisDate<=lastendDate)&&(DisDate'="")
    //...s lastMonthNum=lastMonthNum+1
    //s stDate2="" f  s stDate2=$o(^PAADMi("DepDateTime",LocId1,stDate2))  q:stDate2=""  d
    //.s stDate22=$zd(stDate2,3)
    //.q:Year'=$p(stDate22,"-",1)
    //.q:Month'=$p(stDate22,"-",2)
    //.s stTime2=""  f  s stTime2=$o(^PAADMi("DepDateTime",LocId1,stDate2,stTime2)) q:stTime2=""  d
    //..s Episodeid2="" f  s Episodeid2=$o(^PAADMi("DepDateTime",LocId1,stDate2,stTime2,Episodeid2))  q:Episodeid2=""  d
    //...s thisMonthNum=thisMonthNum+1
    s MonthksNum=lastMonthNum+thisMonthNum
    //s MonthAllNum=MonthAllNum/2
    f sttDate=$zdh(Date,3):1:($zdh(endDate,3)-1) d
    .;b ;888
    .s rw="" f  s rw=$O(^Nur.DHCNurSBDataI("emdate",sttDate," DHCNURXHSB_PF",rw)) q:rw=""  d
    ..s a=##class(Nur.DHCNurSBData).%OpenId(rw)
    ..s Item1=a.Item1
    ..s RecCancelUser=a.RecCancelUser
    ..s status=a.Status
    ..q:((status="C")||(status="V"))
    ..q:RecCancelUser'=""
    ..s LocDesc=$P($p(^CTLOC(LocId1),"^",2),"-",2)
    ..q:Item1'=LocDesc
    ..s pfyc=pfyc+1
    .///20190311
    .s rw="" f  s rw=$O(^Nur.DHCNurSBDataI("emdate",sttDate," DHCNURXHSB_PFN",rw)) q:rw=""  d
    ..s a=##class(Nur.DHCNurSBData).%OpenId(rw)
    ..s Item1=a.Item1
    ..s RecCancelUser=a.RecCancelUser
    ..s status=a.Status
    ..q:((status="C")||(status="V"))
    ..q:RecCancelUser'=""
    ..s LocDesc=$P($p(^CTLOC(LocId1),"^",2),"-",2)
    ..q:Item1'=LocDesc
    ..s pfyc=pfyc+1
    .s rw="" f  s rw=$O(^Nur.DHCNurSBDataI("emdate",sttDate," DHCNURPGD_NMYSBB",rw)) q:rw=""  d
    ..s a=##class(Nur.DHCNurSBData).%OpenId(rw)
    ..s Item1=a.Item1
    ..s RecCancelUser=a.RecCancelUser
    ..s status=a.Status
    ..q:((status="C")||(status="V"))
    ..q:RecCancelUser'=""
    ..s LocDesc=$P($p(^CTLOC(LocId1),"^",2),"-",2)
    ..q:Item1'=LocDesc
    ..s nbmyc=nbmyc+1
    i nextMonth=1 d
    .s Year=Year-1 
    s ynycall=pfyc+nbmyc
    i MonthAllNum'=0 s rate=ynycall/MonthAllNum*100
    e  s rate=0
    q

OutwardRow8
    s Data=$LB(Year,Month,MonthAllNum,rate,ynycall)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod GetEachYearSameMonthrateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEachYearSameMonthrateExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             
        Set AtEnd=1
        Set Row=""
    }
    Else      {             
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetEachYearSameMonthrateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEachYearSameMonthrateExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 另外一个年份的压疮发生率统计
/// d ##class(%ResultSet).RunQuery("web.DHCNurSBDataNew","GetEachYearSameMonthrateother","2019","","168")
Query GetEachYearSameMonthrateother(Year As %String, LocId As %String, loc As %String) As %Query(ROWSPEC = "Year:%String,Month:%String,MonthAllNum:%Float,rate:%Float,ynycall:%Float") [ SqlProc ]
{
}

ClassMethod GetEachYearSameMonthrateotherExecute(ByRef qHandle As %Binary, Year As %String, LocId As %String, loc As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set ind=1
    ;s ^Panxuefengtemp("GetEachYearSameMonthrateother")=Year_"^"_loc
    q:Year="" $$$OK
    s AllMonth="01^02^03^04^05^06^07^08^09^10^11^12"
    s lastMonthNum=0,thisMonthNum=0,ynycall=0,pfyc=0,nbmyc=0
    i LocId'="" d
    .f Num1=1:1:12 d
    ..s lastMonthNum=0,thisMonthNum=0,ynycall=0,pfyc=0,nbmyc=0,MonthAllNum=0
    ..s Month=$p(AllMonth,"^",Num1)
    ..s LocId1=LocId
    ..s MonthksNum=0
    ..d OutwardRowROw9
    ..s MonthAllNum=MonthksNum+MonthAllNum
    ..i MonthAllNum'=0 s rate=ynycall/MonthAllNum*100
    ..e  s rate=0
    ..d OutwardRow9
    i LocId="" d
    .f Num1=1:1:12 d
    ..s lastMonthNum=0,thisMonthNum=0,ynycall=0,pfyc=0,nbmyc=0,MonthAllNum=0
    ..s Month=$p(AllMonth,"^",Num1)
    ..s AllLocId1=##class(web.DHCNurblsjflwh).GetBtqxCtlocid(loc)
    ..s long1=$l(AllLocId1,"^")
    ..f num1=2:1:long1 d
    ...s LocId1=$p(AllLocId1,"^",num1)
    ...s MonthksNum=0
    ...d OutwardRowROw9
    ...s MonthAllNum=MonthksNum+MonthAllNum
    ...i MonthAllNum'=0 s rate=ynycall/MonthAllNum*100
    ...e  s rate=0
    ..d OutwardRow9
    Quit $$$OK

OutwardRowROw9
    s Date=Year_"-"_Month_"-"_"1"
    s lastendDate=$zdh(Date,3)-1
    s nextMonth=Month+1
    i nextMonth=13  d 
    .s Year=Year+1 
    .s nextMonth=1
    s endDate=Year_"-"_nextMonth_"-"_"1"
    s lastMonthNum=0
    s thisMonthNum=0
    s MRIProwid=0 f  s MRIProwid=$o(^MRIPdaily("MRIP_DATE",lastendDate,MRIProwid)) q:MRIProwid=""  d
    .s lastdayNum=$p($g(^MRIPdaily(MRIProwid)),"^",13)
    .s MRIPlocdr=$p($g(^MRIPdaily(MRIProwid)),"^",7)
    .q:(LocId1'="")&&(MRIPlocdr'=LocId1)
    .s lastMonthNum=lastMonthNum+lastdayNum
    f sttDate=$zdh(Date,3):1:($zdh(endDate,3)-1) d
    .s MRIProwid1="" f  s MRIProwid1=$o(^MRIPdaily("MRIP_DATE",sttDate,MRIProwid1)) q:MRIProwid1=""  d
    ..s ytrsNum=0
    ..s ytrsNum=$p($g(^MRIPdaily(MRIProwid1)),"^",8)
    ..s MRIPlocdr=$p($g(^MRIPdaily(MRIProwid1)),"^",7)
    ..q:(LocId1'="")&&(MRIPlocdr'=LocId1)
    ..s thisMonthNum=thisMonthNum+ytrsNum
    //s stDate="" f  s stDate=$o(^PAADMi("DepDateTime",LocId1,stDate))  q:stDate=""  d
    //.q:stDate>lastendDate
    //.s stTime=""  f  s stTime=$o(^PAADMi("DepDateTime",LocId1,stDate,stTime)) q:stTime=""  d
    //..s Episodeid="" f  s Episodeid=$o(^PAADMi("DepDateTime",LocId1,stDate,stTime,Episodeid))  q:Episodeid=""  d
    //...s DisDate=$p(^PAADM(Episodeid),"^",17)
    //...q:(DisDate<=lastendDate)&&(DisDate'="")
    //...s lastMonthNum=lastMonthNum+1
    //s stDate2="" f  s stDate2=$o(^PAADMi("DepDateTime",LocId1,stDate2))  q:stDate2=""  d
    //.s stDate22=$zd(stDate2,3)
    //.q:Year'=$p(stDate22,"-",1)
    //.q:Month'=$p(stDate22,"-",2)
    //.s stTime2=""  f  s stTime2=$o(^PAADMi("DepDateTime",LocId1,stDate2,stTime2)) q:stTime2=""  d
    //..s Episodeid2="" f  s Episodeid2=$o(^PAADMi("DepDateTime",LocId1,stDate2,stTime2,Episodeid2))  q:Episodeid2=""  d
    //...s thisMonthNum=thisMonthNum+1
    s MonthksNum=lastMonthNum+thisMonthNum
    //s MonthAllNum=MonthAllNum/2
    f sttDate=$zdh(Date,3):1:($zdh(endDate,3)-1) d
    .;b ;888
    .s rw="" f  s rw=$O(^Nur.DHCNurSBDataI("emdate",sttDate," DHCNURXHSB_PF",rw)) q:rw=""  d
    ..s a=##class(Nur.DHCNurSBData).%OpenId(rw)
    ..s Item1=a.Item1
    ..s RecCancelUser=a.RecCancelUser
    ..s status=a.Status
    ..q:((status="C")||(status="V"))
    ..q:RecCancelUser'=""
    ..s LocDesc=$P($p(^CTLOC(LocId1),"^",2),"-",2)
    ..q:Item1'=LocDesc
    ..s pfyc=pfyc+1
    .///20190311
    .s rw="" f  s rw=$O(^Nur.DHCNurSBDataI("emdate",sttDate," DHCNURXHSB_PFN",rw)) q:rw=""  d
    ..s a=##class(Nur.DHCNurSBData).%OpenId(rw)
    ..s Item1=a.Item1
    ..s RecCancelUser=a.RecCancelUser
    ..s status=a.Status
    ..q:((status="C")||(status="V"))
    ..q:RecCancelUser'=""
    ..s LocDesc=$P($p(^CTLOC(LocId1),"^",2),"-",2)
    ..q:Item1'=LocDesc
    ..s pfyc=pfyc+1
    .s rw="" f  s rw=$O(^Nur.DHCNurSBDataI("emdate",sttDate," DHCNURPGD_NMYSBB",rw)) q:rw=""  d
    ..s a=##class(Nur.DHCNurSBData).%OpenId(rw)
    ..s Item1=a.Item1
    ..s RecCancelUser=a.RecCancelUser
    ..s status=a.Status
    ..q:((status="C")||(status="V"))
    ..q:RecCancelUser'=""
    ..s LocDesc=$P($p(^CTLOC(LocId1),"^",2),"-",2)
    ..q:Item1'=LocDesc
    ..s nbmyc=nbmyc+1
    i nextMonth=1 d
    .s Year=Year-1 
    s ynycall=pfyc+nbmyc
    i MonthAllNum'=0 s rate=ynycall/MonthAllNum*100
    e  s rate=0
    q
 
OutwardRow9
    s Data=$LB(Year,Month,MonthAllNum,rate,ynycall)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod GetEachYearSameMonthrateotherFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEachYearSameMonthrateotherExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             
        Set AtEnd=1
        Set Row=""
    }
    Else      {             
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetEachYearSameMonthrateotherClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEachYearSameMonthrateotherExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
