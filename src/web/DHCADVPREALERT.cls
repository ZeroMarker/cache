Import sqluser

Class web.DHCADVPREALERT Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 不良反应报告按病区统计
/// Creator:     CongYue
/// CreateDate:  2016-05-06  
/// Input:  	 开始日期^结束日期"12","1","2016-02-02^2016-02-02"
/// Output:   	 医疗报告个数^药品报告个数^器械报告个数^用药安全报告个数^输血报告个数^不良反应报告总数
/// Others:		 d ##class(web.DHCADVPREALERT).StaticPreAlert("12","1","2016-05-15^2016-05-16")
ClassMethod StaticPreAlert(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	S End = page*rows
	S Start = (page-1)*rows+1
	S pid=##class(web.DHCADVCOMMON).NewPid()
	d ..StaPre(params,pid)
	S typecode=""
	S ward=""
	S Numalls=0
	S h=0
	
	F  S ward=$o(^TMP("DHCADV","web.DHCADVPREALERT","StaticPreAlert",pid,ward)) Q:ward=""  D
	.F  S typecode=$o(^TMP("DHCADV","web.DHCADVPREALERT","StaticPreAlert",pid,ward,typecode)) Q:typecode=""  D
	..S Numall=$p(^TMP("DHCADV","web.DHCADVPREALERT","StaticPreAlert",pid,ward,typecode),"^",3)
	..S ListData=$g(^TMP("DHCADV","web.DHCADVPREALERT","StaticPreAlert",pid,ward,typecode))
	..S h=h+1
	..S ^TMP("DHCADV","web.DHCADVPREALERT","StaticPreAlert",pid,+Numall,ward,typecode,h)=ListData
	.
	
	I h=0 W ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""
	S ListTitle="name^group^value^reptype"
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S Num=0
	S count=""
	S ward=""
	S typecode=""
	S index=""
	F  S count=$o(^TMP("DHCADV","web.DHCADVPREALERT","StaticPreAlert",pid,count),-1) Q:count=""  D
	.F  S ward=$o(^TMP("DHCADV","web.DHCADVPREALERT","StaticPreAlert",pid,count,ward)) Q:ward=""  D
	..F  S typecode=$o(^TMP("DHCADV","web.DHCADVPREALERT","StaticPreAlert",pid,count,ward,typecode)) Q:typecode=""  D
	...F  S index=$o(^TMP("DHCADV","web.DHCADVPREALERT","StaticPreAlert",pid,count,ward,typecode,index)) Q:index=""  D
	....S ListData=$g(^TMP("DHCADV","web.DHCADVPREALERT","StaticPreAlert",pid,count,ward,typecode,index))
	....Q:ListData=""
	....S Num=Num+1
	....Q:(Num<Start)||(Num>End)
	....I Num=Start D
	.....W ##class(web.DHCADVJSONCOMMON).getJsonData(ListTitle,ListData)
	....E  D
	.....W ","_##class(web.DHCADVJSONCOMMON).getJsonData(ListTitle,ListData)
	....
	...
	..
	.
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	K ^TMP("DHCADV","web.DHCADVPREALERT","StaticPreAlert",pid)
	Q ""
}

/// Description: 不良反应报告按病区分析
/// Creator:     CongYue
/// CreateDate:  2016-05-09  
/// Input:  	 开始日期^结束日期"2016-02-02^2016-02-02"
/// Output:   	 
/// Others:		 d ##class(web.DHCADVPREALERT).AnalyPreAlert("2016-05-15^2016-05-16")
ClassMethod AnalyPreAlert(params As %String) As %String
{
	N (params)
	S pid=##class(web.DHCADVCOMMON).NewPid()
	d ..StaPre(params,pid)
	S typecode=""
	S ward=""
	S warda=""
	F  S ward=$o(^TMP("DHCADV","web.DHCADVPREALERT","StaticPreAlert",pid,ward)) Q:ward=""  D
	.F  S typecode=$o(^TMP("DHCADV","web.DHCADVPREALERT","StaticPreAlert",pid,ward,typecode)) Q:typecode=""  D
	..S Numall=$p(^TMP("DHCADV","web.DHCADVPREALERT","StaticPreAlert",pid,ward,typecode),"^",3)
	..S ListData=$g(^TMP("DHCADV","web.DHCADVPREALERT","StaticPreAlert",pid,ward,typecode))
	..I $d(^TMP("DHCADV","web.DHCADVPREALERT","AnalyPreAlert",pid,ward)) D
	...S $p(^TMP("DHCADV","web.DHCADVPREALERT","AnalyPreAlert",pid,ward),"^",3)=$p(^TMP("DHCADV","web.DHCADVPREALERT","AnalyPreAlert",pid,ward),"^",3)+Numall
	..E  S ^TMP("DHCADV","web.DHCADVPREALERT","AnalyPreAlert",pid,ward)=ListData
	.

	F  S warda=$o(^TMP("DHCADV","web.DHCADVPREALERT","AnalyPreAlert",pid,warda)) Q:warda=""  D
	.S Numalls=$p(^TMP("DHCADV","web.DHCADVPREALERT","AnalyPreAlert",pid,warda),"^",3)
	.S ListDatas=$g(^TMP("DHCADV","web.DHCADVPREALERT","AnalyPreAlert",pid,warda))
	.S ^TMP("DHCADV","web.DHCADVPREALERT","AnalyPreAlert",pid,+Numalls,warda)=ListDatas
	
	S ListTitle="name^group^value"
	W "["
	S Num=0
	S count=""
	S index=""
	F  S count=$o(^TMP("DHCADV","web.DHCADVPREALERT","AnalyPreAlert",pid,count),-1) Q:count=""  D
	.F  S index=$o(^TMP("DHCADV","web.DHCADVPREALERT","AnalyPreAlert",pid,count,index)) Q:index=""  D
	..S ListData=$g(^TMP("DHCADV","web.DHCADVPREALERT","AnalyPreAlert",pid,count,index))
	..Q:ListData=""
	..S Num=Num+1
	..Q:Num=6
	..I Num=1 D
	...W ##class(web.DHCADVJSONCOMMON).getSisJsonData(ListTitle,ListData)
	..E  D
	...W ","_##class(web.DHCADVJSONCOMMON).getSisJsonData(ListTitle,ListData)
	..
	.
	W "]"
	K ^TMP("DHCADV","web.DHCADVPREALERT","AnalyPreAlert",pid)
	K ^TMP("DHCADV","web.DHCADVPREALERT","StaticPreAlert",pid)
	Q ""
}

/// Description: 不良反应报告按病区统计与分析
/// Creator:     CongYue
/// CreateDate:  2016-05-05  
/// Input:  	 开始日期^结束日期"12","1","2016-02-02^2016-02-02"
/// Output:   	 医疗报告个数^药品报告个数^器械报告个数^用药安全报告个数^输血报告个数^不良反应报告总数
/// Others:		 d ##class(web.DHCADVPREALERT).StaPre("2016-05-15^2016-05-16","1")
ClassMethod StaPre(params As %String, pid As %String) As %String
{
	N (params,pid)
	S StDate=$p(params,"^",1)       //开始日期
	S EndDate=$p(params,"^",2)      //结束日期
	S StDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(StDate) //$zdh(StDate,3)
	S EndDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(EndDate) //$zdh(EndDate,3)
	S Repnum=0
	S Num=1
	S ID=""
	F dd=StDate:1:EndDate D
	.;医疗
	.F  S ID=$o(^DHCMEDADRR(0,"CreateDate",dd,ID))  Q:ID=""  D 
	..S status=$p(^DHCMEDADRR(ID),"^",27)
	..q:status=""
	..S typedr=$p(^DHCMEDADRR(ID),"^",30)
	..q:typedr=""
	..S typecode=$p(^DHCMEDADREVT(typedr),"^",1)
	..S type=$p(^DHCMEDADREVT(typedr),"^",2)	
	..S AdmNo=$p(^DHCMEDADRR(ID),"^",33) //就诊ID		
	..Q:AdmNo=""
	..S AdmWardID=$p(^PAADM(AdmNo),"^",70) //病区
	..Q:AdmWardID=""
	..S AdmWard=$p(^PAWARD(AdmWardID),"^",2)
	..S:AdmWard["-" AdmWard=$p(AdmWard,"-",2)
	..I $d(^TMP("DHCADV","web.DHCADVPREALERT","StaticPreAlert",pid,AdmWard,typecode)) D
	...S $p(^TMP("DHCADV","web.DHCADVPREALERT","StaticPreAlert",pid,AdmWard,typecode),"^",3)=$p(^TMP("DHCADV","web.DHCADVPREALERT","StaticPreAlert",pid,AdmWard,typecode),"^",3)+Num
	..E  S ^TMP("DHCADV","web.DHCADVPREALERT","StaticPreAlert",pid,AdmWard,typecode)=AdmWard_"^"_"报告数量"_"^"_Num_"^"_type_"^"_typedr
	.;药品
	.F  S ID=$o(^DHCADVDRUGREP(0,"CreateDate",dd,ID))  Q:ID=""  D 
	..S status=$p(^DHCADVDRUGREP(ID),"^",48)
	..q:status=""
	..S typedr=$p(^DHCADVDRUGREP(ID),"^",49)
	..q:typedr=""
	..S typecode=$p(^DHCMEDADREVT(typedr),"^",1)
	..S type=$p(^DHCMEDADREVT(typedr),"^",2)
	..S AdmNo=$p(^DHCADVDRUGREP(ID),"^",7) //就诊ID
	..Q:AdmNo=""
	..S AdmWardID=$p(^PAADM(AdmNo),"^",70) //病区
	..Q:AdmWardID=""
	..S AdmWard=$p(^PAWARD(AdmWardID),"^",2)
	..S:AdmWard["-" AdmWard=$p(AdmWard,"-",2)
	..I $d(^TMP("DHCADV","web.DHCADVPREALERT","StaticPreAlert",pid,AdmWard,typecode)) D
	...S $p(^TMP("DHCADV","web.DHCADVPREALERT","StaticPreAlert",pid,AdmWard,typecode),"^",3)=$p(^TMP("DHCADV","web.DHCADVPREALERT","StaticPreAlert",pid,AdmWard,typecode),"^",3)+Num
	..E  S ^TMP("DHCADV","web.DHCADVPREALERT","StaticPreAlert",pid,AdmWard,typecode)=AdmWard_"^"_"报告数量"_"^"_Num_"^"_type_"^"_typedr
	.;器械
	.F  S ID=$o(^DHCMATADRR(0,"CreateDate",dd,ID))  Q:ID=""  D 
	..S status=$p(^DHCMATADRR(ID),"^",41)
	..q:status=""
	..S typedr=$p(^DHCMATADRR(ID),"^",46)
	..q:typedr=""
	..S typecode=$p(^DHCMEDADREVT(typedr),"^",1)
	..S type=$p(^DHCMEDADREVT(typedr),"^",2)
	..S AdmNo=$p(^DHCMATADRR(ID),"^",48) //就诊ID
	..Q:AdmNo=""
	..S AdmWardID=$p(^PAADM(AdmNo),"^",70) //病区
	..Q:AdmWardID=""
	..S AdmWard=$p(^PAWARD(AdmWardID),"^",2)
	..S:AdmWard["-" AdmWard=$p(AdmWard,"-",2)
	..I $d(^TMP("DHCADV","web.DHCADVPREALERT","StaticPreAlert",pid,AdmWard,typecode)) D
	...S $p(^TMP("DHCADV","web.DHCADVPREALERT","StaticPreAlert",pid,AdmWard,typecode),"^",3)=$p(^TMP("DHCADV","web.DHCADVPREALERT","StaticPreAlert",pid,AdmWard,typecode),"^",3)+Num
	..E  S ^TMP("DHCADV","web.DHCADVPREALERT","StaticPreAlert",pid,AdmWard,typecode)=AdmWard_"^"_"报告数量"_"^"_Num_"^"_type_"^"_typedr
	.;用药差错
	.F  S ID=$o(^DHCADVMEDSAR(0,"CreateDate",dd,ID))  Q:ID=""  D 
	..S status=$p(^DHCADVMEDSAR(ID),"^",18)
	..q:status=""
	..S typedr=$p(^DHCADVMEDSAR(ID),"^",20)
	..q:typedr=""
	..S typecode=$p(^DHCMEDADREVT(typedr),"^",1)
	..S type=$p(^DHCMEDADREVT(typedr),"^",2)
	..S AdmNo=$p(^DHCADVMEDSAR(ID),"^",21) //就诊ID
	..Q:AdmNo=""
	..S AdmWardID=$p(^PAADM(AdmNo),"^",70) //病区
	..Q:AdmWardID=""
	..S AdmWard=$p(^PAWARD(AdmWardID),"^",2)
	..S:AdmWard["-" AdmWard=$p(AdmWard,"-",2)
	..I $d(^TMP("DHCADV","web.DHCADVPREALERT","StaticPreAlert",pid,AdmWard,typecode)) D
	...S $p(^TMP("DHCADV","web.DHCADVPREALERT","StaticPreAlert",pid,AdmWard,typecode),"^",3)=$p(^TMP("DHCADV","web.DHCADVPREALERT","StaticPreAlert",pid,AdmWard,typecode),"^",3)+Num
	..E  S ^TMP("DHCADV","web.DHCADVPREALERT","StaticPreAlert",pid,AdmWard,typecode)=AdmWard_"^"_"报告数量"_"^"_Num_"^"_type_"^"_typedr
	.;输血
	.F  S ID=$o(^DHCBLDADVRPT(0,"CreateDate",dd,ID))  Q:ID=""  D 
	..S status=$p(^DHCBLDADVRPT(ID),"^",46)
	..q:status=""
	..S typedr=$p(^DHCBLDADVRPT(ID),"^",47)
	..q:typedr=""
	..S typecode=$p(^DHCMEDADREVT(typedr),"^",1)
	..S type=$p(^DHCMEDADREVT(typedr),"^",2)
	..S AdmNo=$p(^DHCBLDADVRPT(ID),"^",7) //就诊ID
	..Q:AdmNo=""
	..S AdmWardID=$p(^PAADM(AdmNo),"^",70) //病区
	..Q:AdmWardID=""
	..S AdmWard=$p(^PAWARD(AdmWardID),"^",2)
	..S:AdmWard["-" AdmWard=$p(AdmWard,"-",2)
	..I $d(^TMP("DHCADV","web.DHCADVPREALERT","StaticPreAlert",pid,AdmWard,typecode)) D
	...S $p(^TMP("DHCADV","web.DHCADVPREALERT","StaticPreAlert",pid,AdmWard,typecode),"^",3)=$p(^TMP("DHCADV","web.DHCADVPREALERT","StaticPreAlert",pid,AdmWard,typecode),"^",3)+Num
	..E  S ^TMP("DHCADV","web.DHCADVPREALERT","StaticPreAlert",pid,AdmWard,typecode)=AdmWard_"^"_"报告数量"_"^"_Num_"^"_type_"^"_typedr
	Q ""
}

/// Description: 不良反应报告待办统计
/// Creator:     yangyongtao
/// CreateDate:  2016-05-17  
/// Input:  	 开始日期^结束日期"12","1","2016-02-02^2016-02-02"
/// Output:   	 医疗报告个数^药品报告个数^器械报告个数^用药安全报告个数^输血报告个数^不良反应报告总数
/// Others:		 d ##class(web.DHCADVPREALERT).UntreatedList("12","1","2016-04-27^2016-05-16^126^63^600")
ClassMethod UntreatedList(rows As %String, page As %String, param As %String) As %String
{
	
	n (rows,page,param)
	s End = page*rows
    s Start = (page-1)*rows+1
    S pid=##class(web.DHCADVCOMMON).NewPid()  //调用计数器类并给其赋值
    d ..killTmpGlobal(pid) //k掉临时global
    s StDate=$p(param,"^",1)    //开始日期
	s EndDate=$p(param,"^",2)   //结束日期 
	S GroupId=$p(param,"^",3)   //安全组ID
    S LocId=$p(param,"^",4)     //科室ID
    S UserId=$p(param,"^",5)    //用户ID
    S list=UserId_"^"_LocId_"^"_GroupId
	;s LocID=$p(param,"^",3)   //科室ID 
	s StDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(StDate) //$zdh(StDate,3)
	s EndDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(EndDate) //$zdh(EndDate,3)
	s h=0,count=0
	S Numalls=0   //合计初始化
    s Num=1       //审核状态类型数量统计初始化
	S ID=""
	F dd=StDate:1:EndDate D
	.;医疗
	.F  S ID=$o(^DHCMEDADRR(0,"CreateDate",dd,ID))  Q:ID=""  D 
	..S StatusID=$p(^DHCMEDADRR(ID),"^",27) //当前状态
	..Q:StatusID=""
	..S typedr=$p(^DHCMEDADRR(ID),"^",30) //类型ID
	..Q:typedr=""
	..S typecode=$p(^DHCMEDADREVT(typedr),"^",1)
	..S type=$p(^DHCMEDADREVT(typedr),"^",2)
	..I StatusID'="" D
	...S MedadrRowID=$o(^DHCMEDREPADT(0,"Pointer",typedr,ID,""),-1)
	...S Medadrreceivedr=""
	...S:MedadrRowID'="" Medadrreceivedr=$p(^DHCMEDREPADT(MedadrRowID),"^",9) 
	...S AdrewOrderNo=$p(StatusID,"^",2)
	...S StatusNext=""
	...S AdrewRowID=$p(StatusID,"||",1)
	...S AdrewChildSub=$p(StatusID,"||",2)
	...S Status=$p(^DHCADREVTWFI(AdrewRowID,"ADREWI",AdrewChildSub),"^",2)
	...S Listt=ID_"^"_typedr_"^"_list_"^"_StatusID
	...S matalist=##class(web.DHCADVCOMMON).InsStatusDr(Listt) 
	...S StatusNextID=$p(matalist,"^",2)  //下一状态
	...Q:StatusNextID=""
	...q:Medadrreceivedr="2" //判断是否驳回
	...S adrwfgID=""
	...F  S adrwfgID=$o(^DHCADREVTWFGR(0,"ItmDr",StatusNextID,adrwfgID)) Q:adrwfgID=""  d
	....S adrwfgType=$p(^DHCADREVTWFGR(adrwfgID),"^",3)
	....S adrwfgLocID=$p(^DHCADREVTWFGR(adrwfgID),"^",4)
	....Q:(LocId'="")&(LocId'=adrwfgLocID)
	....Q:adrwfgType'=2  //判断权限是否为科室
	....S Numalls=Numalls+1
	....I $d(^TMP("DHCADV","web.DHCADVPREALERT","UntreatedList",pid,type))  d
	.....S $p(^TMP("DHCADV","web.DHCADVPREALERT","UntreatedList",pid,type),"^",2)=$p(^TMP("DHCADV","web.DHCADVPREALERT","UntreatedList",pid,type),"^",2)+Num
	....E  d
	.....S h=h+1  
	.....S ^TMP("DHCADV","web.DHCADVPREALERT","UntreatedList",pid,type)=type_"^"_Num
	...
    .;药品
	.F  S ID=$o(^DHCADVDRUGREP(0,"CreateDate",dd,ID))  Q:ID=""  D 
	..S StatusID=$p(^DHCADVDRUGREP(ID),"^",48)
	..Q:StatusID=""
	..S typedr=$p(^DHCADVDRUGREP(ID),"^",49)
	..Q:typedr=""
	..S typecode=$p(^DHCMEDADREVT(typedr),"^",1)
	..S type=$p(^DHCMEDADREVT(typedr),"^",2)
    ..I StatusID'="" D
	...S MedadrRowID=$o(^DHCMEDREPADT(0,"Pointer",typedr,ID,""),-1)
	...S Medadrreceivedr=""
	...S:MedadrRowID'="" Medadrreceivedr=$p(^DHCMEDREPADT(MedadrRowID),"^",9) 
	...S AdrewOrderNo=$p(StatusID,"^",2)
	...S StatusNext=""
	...S AdrewRowID=$p(StatusID,"||",1)
	...S AdrewChildSub=$p(StatusID,"||",2)
	...S Status=$p(^DHCADREVTWFI(AdrewRowID,"ADREWI",AdrewChildSub),"^",2)
	...S Listt=ID_"^"_typedr_"^"_list_"^"_StatusID
	...S matalist=##class(web.DHCADVCOMMON).InsStatusDr(Listt) 
	...S StatusNextID=$p(matalist,"^",2)  //下一状态
	...Q:StatusNextID=""
	...Q:Medadrreceivedr="2" //判断是否驳回
	...S adrwfgID=""
	...F  S adrwfgID=$o(^DHCADREVTWFGR(0,"ItmDr",StatusNextID,adrwfgID)) Q:adrwfgID=""  d
	....S adrwfgType=$p(^DHCADREVTWFGR(adrwfgID),"^",3)
	....S adrwfgLocID=$p(^DHCADREVTWFGR(adrwfgID),"^",4)
	....Q:(LocId'="")&(LocId'=adrwfgLocID)
	....Q:adrwfgType'=2 //判断权限是否为科室
	....S Numalls=Numalls+1
	....I $d(^TMP("DHCADV","web.DHCADVPREALERT","UntreatedList",pid,type))  d
	.....S $p(^TMP("DHCADV","web.DHCADVPREALERT","UntreatedList",pid,type),"^",2)=$p(^TMP("DHCADV","web.DHCADVPREALERT","UntreatedList",pid,type),"^",2)+Num
	....E  d
	.....S h=h+1  
	.....S ^TMP("DHCADV","web.DHCADVPREALERT","UntreatedList",pid,type)=type_"^"_Num
	...
    .;器械
	.F  S ID=$o(^DHCMATADRR(0,"CreateDate",dd,ID))  Q:ID=""  D 
	..S StatusID=$p(^DHCMATADRR(ID),"^",41)
	..Q:StatusID=""
	..S typedr=$p(^DHCMATADRR(ID),"^",46)
	..Q:typedr=""
	..S typecode=$p(^DHCMEDADREVT(typedr),"^",1)
	..S type=$p(^DHCMEDADREVT(typedr),"^",2)
    ..I StatusID'="" D
	...S MedadrRowID=$o(^DHCMEDREPADT(0,"Pointer",typedr,ID,""),-1)
	...S Medadrreceivedr=""
	...S:MedadrRowID'="" Medadrreceivedr=$p(^DHCMEDREPADT(MedadrRowID),"^",9) 
	...S AdrewOrderNo=$p(StatusID,"^",2)
	...S StatusNext=""
	...S AdrewRowID=$p(StatusID,"||",1)
	...S AdrewChildSub=$p(StatusID,"||",2)
	...S Status=$p(^DHCADREVTWFI(AdrewRowID,"ADREWI",AdrewChildSub),"^",2)
	...S Listt=ID_"^"_typedr_"^"_list_"^"_StatusID
	...S matalist=##class(web.DHCADVCOMMON).InsStatusDr(Listt) 
	...S StatusNextID=$p(matalist,"^",2)  //下一状态
	...Q:StatusNextID=""
	...Q:Medadrreceivedr="2" //判断是否驳回
	...S adrwfgID=""
	...F  S adrwfgID=$o(^DHCADREVTWFGR(0,"ItmDr",StatusNextID,adrwfgID)) Q:adrwfgID=""  d
	....S adrwfgType=$p(^DHCADREVTWFGR(adrwfgID),"^",3)
	....S adrwfgLocID=$p(^DHCADREVTWFGR(adrwfgID),"^",4)
	....Q:(LocId'="")&(LocId'=adrwfgLocID)
	....Q:adrwfgType'=2  //判断权限是否为科室
	....S Numalls=Numalls+1
	....I $d(^TMP("DHCADV","web.DHCADVPREALERT","UntreatedList",pid,type))  d
	.....S $p(^TMP("DHCADV","web.DHCADVPREALERT","UntreatedList",pid,type),"^",2)=$p(^TMP("DHCADV","web.DHCADVPREALERT","UntreatedList",pid,type),"^",2)+Num
	....E  d
	.....S h=h+1  
	.....S ^TMP("DHCADV","web.DHCADVPREALERT","UntreatedList",pid,type)=type_"^"_Num
	...

	.;用药差错
	.F  S ID=$o(^DHCADVMEDSAR(0,"CreateDate",dd,ID))  Q:ID=""  D 
	..S StatusID=$p(^DHCADVMEDSAR(ID),"^",18)
	..Q:StatusID=""
	..S typedr=$p(^DHCADVMEDSAR(ID),"^",20)
	..Q:typedr=""
	..S typecode=$p(^DHCMEDADREVT(typedr),"^",1)
	..S type=$p(^DHCMEDADREVT(typedr),"^",2)
	..I StatusID'="" D
	...S MedadrRowID=$o(^DHCMEDREPADT(0,"Pointer",typedr,ID,""),-1)
	...S Medadrreceivedr=""
	...S:MedadrRowID'="" Medadrreceivedr=$p(^DHCMEDREPADT(MedadrRowID),"^",9) 
	...S AdrewOrderNo=$p(StatusID,"^",2)
	...S StatusNext=""
	...S AdrewRowID=$p(StatusID,"||",1)
	...S AdrewChildSub=$p(StatusID,"||",2)
	...S Status=$p(^DHCADREVTWFI(AdrewRowID,"ADREWI",AdrewChildSub),"^",2)
	...S Listt=ID_"^"_typedr_"^"_list_"^"_StatusID
	...S matalist=##class(web.DHCADVCOMMON).InsStatusDr(Listt) 
	...S StatusNextID=$p(matalist,"^",2)  //下一状态
	...Q:StatusNextID=""
	...Q:Medadrreceivedr="2" //判断是否驳回
	...S adrwfgID=""
	...F  S adrwfgID=$o(^DHCADREVTWFGR(0,"ItmDr",StatusNextID,adrwfgID)) Q:adrwfgID=""  d
	....S adrwfgType=$p(^DHCADREVTWFGR(adrwfgID),"^",3)
	....S adrwfgLocID=$p(^DHCADREVTWFGR(adrwfgID),"^",4)
	....Q:(LocId'="")&(LocId'=adrwfgLocID)
	....Q:adrwfgType'=2  //判断权限是否为科室
	....S Numalls=Numalls+1
	....I $d(^TMP("DHCADV","web.DHCADVPREALERT","UntreatedList",pid,type))  d
	.....S $p(^TMP("DHCADV","web.DHCADVPREALERT","UntreatedList",pid,type),"^",2)=$p(^TMP("DHCADV","web.DHCADVPREALERT","UntreatedList",pid,type),"^",2)+Num
	....E  d
	.....S h=h+1  
	.....S ^TMP("DHCADV","web.DHCADVPREALERT","UntreatedList",pid,type)=type_"^"_Num
	...

	.;输血
	.F  S ID=$o(^DHCBLDADVRPT(0,"CreateDate",dd,ID))  Q:ID=""  D 
	..S StatusID=$p(^DHCBLDADVRPT(ID),"^",46)
	..Q:StatusID=""
	..S typedr=$p(^DHCBLDADVRPT(ID),"^",47)
	..Q:typedr=""
	..S typecode=$p(^DHCMEDADREVT(typedr),"^",1)
	..S type=$p(^DHCMEDADREVT(typedr),"^",2)
    ..I StatusID'="" D
	...S MedadrRowID=$o(^DHCMEDREPADT(0,"Pointer",typedr,ID,""),-1)
	...S Medadrreceivedr=""
	...S:MedadrRowID'="" Medadrreceivedr=$p(^DHCMEDREPADT(MedadrRowID),"^",9) 
	...S AdrewOrderNo=$p(StatusID,"^",2)
	...S StatusNext=""
	...S AdrewRowID=$p(StatusID,"||",1)
	...S AdrewChildSub=$p(StatusID,"||",2)
	...S Status=$p(^DHCADREVTWFI(AdrewRowID,"ADREWI",AdrewChildSub),"^",2)
	...S Listt=ID_"^"_typedr_"^"_list_"^"_StatusID
	...S matalist=##class(web.DHCADVCOMMON).InsStatusDr(Listt) 
	...S StatusNextID=$p(matalist,"^",2)  //下一状态
	...Q:StatusNextID=""
	...Q:Medadrreceivedr="2" //判断是否驳回
	...S adrwfgID=""
	...F  S adrwfgID=$o(^DHCADREVTWFGR(0,"ItmDr",StatusNextID,adrwfgID)) Q:adrwfgID=""  d
	....S adrwfgType=$p(^DHCADREVTWFGR(adrwfgID),"^",3)
	....S adrwfgLocID=$p(^DHCADREVTWFGR(adrwfgID),"^",4)
	....Q:(LocId'="")&(LocId'=adrwfgLocID)
	....Q:adrwfgType'=2  //判断权限是否为科室
	....S Numalls=Numalls+1
	....I $d(^TMP("DHCADV","web.DHCADVPREALERT","UntreatedList",pid,type))  d
	.....S $p(^TMP("DHCADV","web.DHCADVPREALERT","UntreatedList",pid,type),"^",2)=$p(^TMP("DHCADV","web.DHCADVPREALERT","UntreatedList",pid,type),"^",2)+Num
	....E  d
	.....S h=h+1  
	.....S ^TMP("DHCADV","web.DHCADVPREALERT","UntreatedList",pid,type)=type_"^"_Num
	...


	I h=0 W ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""
	S ^TMP("DHCADV","web.DHCADVPREALERT","UntreatedList",pid,h)="合计:"_"^"_Numalls
	
	///转换数据为Json格式
	S Title="name^value"
	
	w ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h+1) //输出json前缀串  qunianpeng  2016-07-13
	s index=""
	f  s index=$o(^TMP("DHCADV","web.DHCADVPREALERT","UntreatedList",pid,index),-1) q:index=""  d
	.s mdate=$g(^TMP("DHCADV","web.DHCADVPREALERT","UntreatedList",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	.e  d
	..w ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	w ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCADV","web.DHCADVPREALERT","UntreatedList",pid)
}

}
